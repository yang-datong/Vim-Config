#!/bin/bash

#set -e

ScriptVersion="1.0"

unset src
unset cc
unset file_suffix
unset level
unset flag
unset include_path
unset lib_path
unset debug

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
	echo "	\$(CC) \$^ -o \$@ ${lib_path}" >> Makefile
	echo "" >> Makefile
	echo "clean:" >> Makefile
	echo "	rm \$(OBJS) \$(BIN)" >> Makefile
	make
  rm *.o
}

check_build_type(){
	local c_total=$(ls | grep "\.c$" | wc -l)
	local cpp_total=$(ls | grep "\.cpp$" | wc -l)

  if [ $debug ];then
    echo -e "\033[31minto check_build_type\033[0m"
    echo -e "\033[31mc_total->$c_total\033[0m"
    echo -e "\033[31mcpp_total->$cpp_total\033[0m"
    ls | grep "\.c$\|\.cpp$"
  fi

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

info(){
  if [ $debug ];then
    echo -e "\033[31margv[1]->$1\033[0m"
    echo -e "\033[31margv[2]->$2\033[0m"
    echo -e "\033[31mcc->$cc\033[0m"
    echo -e "\033[31mfile_suffix->$file_suffix\033[0m"
    echo -e "\033[31mlevel->$level\033[0m"
    echo -e "\033[31mflag->$flag\033[0m"
    echo -e "\033[31minclude_path->$include_path\033[0m"
    echo -e "\033[31mlib_path->$lib_path\033[0m"
  fi
}

usage (){
  echo "Usage :  $(basename $0) [options] [--]

  Options:
  -h|help       Display this message
  -d|debug      Debug model run
  -p|posix      Posix model parse shell command
  -v|version    Display script version
  -s            Test input argument
  -c            Used source file
  -I            Used include file
  -L            Used dynamic library(default all dylib)
  -t            Build type"

}


clean_cmake(){
  local date=$(date +"%Y%m%d%H%M%S")
  if [ -f Makefile ];then
    if [ "$1" == "all" ];then make clean;fi
    mv Makefile /tmp/Makefile_$date
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
  fi
  generate_cmakelists
  clean_cmake
}

#  Handle command line arguments
while getopts ":hvdps:c:I:L:t:D:" opt;do
  case $opt in
  h|help)     usage; exit ;;
  d|debug)    set -x ;;
  p|posix)    set -o posix ;;
  v|version)  echo "$0 -- Version $ScriptVersion"; exit ;;
  s)          echo $OPTARG; exit;;
  c)          src=$OPTARG ;;
  I)          include_path="$OPTARG" ;;
  L)          lib_path=$OPTARG ;;
  t)          cc=$OPTARG ;;
  D)          dir=$OPTARG ;;
  * )         echo -e "\n  Option does not exist : $OPTARG\n"
              usage; exit 1 ;;
  esac
done
shift $(($OPTIND-1))

#main $@

cmake_main $@
