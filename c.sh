#!/bin/bash
ScriptVersion="1.0"

unset src
unset cc
unset file_suffix
unset level
unset flag
unset include_path
unset lib_path

main(){
  if [ "$1" == "clean" ];then
    make clean
  fi
  if [ "$cc" == "c" ];then
    c_kind
  elif [ "$cc" == "cpp" ];then
    cpp_kind
  else
    check_build_type
  fi
  check_is_lib_path
  generate_makefile
  info
}

check_is_lib_path(){
  if [ $lib_path ];then
    lib_path="-L $lib_path $(ls $lib_path | grep '.dylib$' | sed -e 's/lib/-l/' -e 's/\.dylib//' -e 's/\..*//' | uniq | tr '\n' ' ' )"
  fi
}

generate_makefile(){
  echo "CC:=$cc" > Makefile
  echo "BIN:=demo" >> Makefile
  if [ $include_path ];then
    include_path="-I $include_path"
  fi
  echo "${flag}:=-g -Wall ${level} ${include_path}" >> Makefile
  if [ -n "$lib_path" ];then
    echo "LIBS=${lib_path}" >> Makefile
    lib_path="\$(LIBS)"
  fi
  if [ $src ];then
    src="SRC:=$src"
  else
    src="SRC:=\$(wildcard *.${file_suffix})"
  fi
  echo "$src" >> Makefile
  echo "OBJS:=\$(patsubst %.${file_suffix},%.o,\$(SRC))" >> Makefile
  echo "" >> Makefile
  echo "\$(BIN):\$(OBJS)" >> Makefile
  echo "  \$(CC) \$^ -o \$@ ${lib_path}" >> Makefile
  echo "" >> Makefile
  echo "clean:" >> Makefile
  echo "  rm \$(OBJS) \$(BIN)" >> Makefile
  make
  rm *.o
}

check_build_type(){
  local c_total=$(ls | grep "\.c$" | wc -l)
  local cpp_total=$(ls | grep "\.cpp$" | wc -l)

  if [  $c_total -gt 0 -a $cpp_total -gt 0 ];then
    echo -e "\033[31mYou can try to excute $0 help\033[0m"
    exit;
  fi

  if [ $c_total == 0 -a $cpp_total == 0 ];then
    echo "no found c\\cpp file" ; exit;
  elif [ $c_total -gt 0 -a $cpp_total == 0 ];then
    c_kind
  elif [ $c_total == 0 -a $cpp_total -gt 0 ];then
    cpp_kind
  fi
}

c_kind(){
  cc="gcc" #gcc 在Mac下同样指向clang
  file_suffix="c"
  level="-std=c11"
  flag="CFLAGS"
}

cpp_kind(){
  cc="g++" #g++ 在Mac下同样指向clang++
  file_suffix="cpp"
  level="-std=c++11"
  flag="CPPFLAGS"
}

clean_cmake(){
  local date=$(date +"%Y%m%d%H%M%S")
  if [ -f Makefile ];then
    if [ "$1" == "all" ];then
      make clean
      mv Makefile /tmp/Makefile_$date
    fi
  fi
  if [ -f CMakeCache.txt ];then
    mv CMakeCache.txt /tmp/CMakeCache.txt_$date
  fi
  if [ -f cmake_install.cmake ];then
    mv cmake_install.cmake /tmp/cmake_install.cmake_$date
  fi
  if [ -f CTestTestfile.cmake ];then
    mv CTestTestfile.cmake /tmp/CTestTestfile.cmake_$date
  fi
  if [ -d CMakeFiles ];then
    mv CMakeFiles /tmp/CMakeFiles_$date
  fi
}


generate_cmakelists(){
  f="CMakeLists.txt"

  echo "cmake_minimum_required(VERSION 3.0)" > $f
  echo "project(project_name)" >> $f
  echo "set(CMAKE_CXX_STANDARD 11)" >> $f
  echo "set(CMAKE_CXX_FLAGS \"\${CMAKE_CXX_FLAGS} -Wall\")" >> $f

  #if [ $include_path ];then
  #  echo "include_directories($include_path)" >> $f
  #fi

  #if [ $lib_path ];then
  #  echo "file(GLOB LIBS \"$lib_path/*.so\" \"$lib_path/*.dylib\")" >> $f
  #fi
  if [ $dir ];then
    echo "set(OpenCV_DIR $dir)" >> $f
    echo "find_package(OpenCV REQUIRED )" >> $f
    echo "include_directories(\${OpenCV_INCLUDE_DIRS})" >> $f
  fi

  if [ $src ];then
    echo "add_executable( ${src%.*} $src )" >> $f
  else
    echo "file(GLOB SOURCES *.cpp *.c)" >> $f
    echo "get_filename_component(BIN \${SOURCES} NAME_WE)" >> $f
    echo "add_executable(\${BIN} \${SOURCES})" >> $f
  fi
  if [ $dir ];then
    if [ $src ];then
      echo "target_link_libraries(${src%.*} \${OpenCV_LIBS} )" >> $f
    else
      echo "target_link_libraries(\${BIN} \${OpenCV_LIBS})" >> $f
    fi
  fi
  #if [ $lib_path ];then
  #  if [ $src ];then
  #    echo "target_link_libraries(${src%.*} \${LIBS} )" >> $f
  #  else
  #    echo "target_link_libraries(\${BIN} \${LIBS})" >> $f
  #  fi
  #fi
  cmake . && make
}

cmake_main(){
  if [ "$1" == "clean" ];then
    clean_cmake "all" && exit
  elif [ "$1" == "make" ];then
    make && clean_cmake && exit
  fi
  generate_cmakelists
  clean_cmake
}

usage (){
  echo "Usage :  $(basename "$0") [options] [--] argument-1 argument-2

  Options:
  -h, --help       Display this message
  -d, --debug      Debug model run
  -p, --posix      Posix model parse shell command
  -v, --version    Display script version
  -f, --file       Test input argument
  -c, --source     Used source file
  -I, --include    Used include file
  -L, --library    Used dynamic library(default all dylib)
  -t, --type       Build type
  -D, --dir        Cmake auto find directory"
}

while getopts ":hdpvf:c:I:L:t:D:-:" opt; do
  case "${opt}" in
    h) usage && exit 0;;
    d) set -x ;;
    p) set -o posix ;;
    v) echo "$0 -- Version $ScriptVersion"; exit ;;
    f) echo "file=${OPTARG}";;
    c) src=${OPTARG} ;;
    I) include_path="${OPTARG}" ;;
    L) lib_path=${OPTARG} ;;
    t) cc=${OPTARG} ;;
    D) dir=${OPTARG} ;;
    -) case "${OPTARG}" in
      help) usage && exit 0;;
      debug)    set -x ;;
      posix)    set -o posix ;;
      version)  echo "$0 -- Version $ScriptVersion"; exit ;;
      file)     echo "file=${!OPTIND}"; OPTIND=$((OPTIND+1));;
      source)   src=${OPTARG} ;;
      include)  include_path="${OPTARG}" ;;
      library)  lib_path=${OPTARG} ;;
      type)     cc=${OPTARG} ;;
      dir)      dir=${OPTARG} ;;
      *) echo "Invalid option: --${OPTARG}" >&2 && exit 1;;
    esac;;
  :) echo "Option -${OPTARG} requires an argument." >&2 && exit 1;;
  *) echo "Invalid option: -${OPTARG}" >&2 && exit 1;;
esac
done

shift $((OPTIND-1))

#main :$@"

cmake_main "$@"
