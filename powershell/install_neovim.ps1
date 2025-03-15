
choco install neovim nodejs -y

pip3.10 install pynvim neovim-remote

$dir = "~\.config\nvim"
if (-not Test-Path -Path $dir) {
    mkdir $dir
}

$dir = "~\.config\nvim\autoload"
if (-not Test-Path -Path $dir) {
    mkdir $dir
}

#配置使用Windows专门的(有一些插件Windows中没有）
cp .\config\plug.vim ~\.config\nvim\autoload\
cp .\config\coc-settings.json ~\.config\nvim\

#共享函数配置
cp ..\config_file\nvim\init.vim ~\.config\nvim\
cp ..\config_file\nvim\function.vim ~\.config\nvim\
cp ..\config_file\nvim\filetype.vim ~\.config\nvim\
cp ..\config_file\nvim\unite_extension.vim ~\.config\nvim\
cp ..\config_file\nvim\yj.lua ~\.config\nvim\


nvim -c "PlugInstall"

#nvim插件配置文件修改
$dir = "~\.config\nvim\plugged\"
cp ./config/seoul256.vim $dir/seoul256.vim/colors/seoul256.vim

$dir = "~\.config\nvim\plugged\vim-snippets\UltiSnips\"
cp ../config_file/snippets/all.snippets $dir
cp ../config_file/snippets/cpp.snippets $dir
cp ../config_file/snippets/javascript.snippets   $dir
cp ../config_file/snippets/make.snippets $dir
cp ../config_file/snippets/python.snippets   $dir
cp ../config_file/snippets/snippets.snippets $dir
cp ../config_file/snippets/cmake.snippets   $dir
cp ../config_file/snippets/c.snippets $dir
cp ../config_file/snippets/java.snippets $dir
cp ../config_file/snippets/markdown.snippets   $dir
cp ../config_file/snippets/sh.snippets $dir
cp ../config_file/snippets/tex.snippets $dir
cp ../config_file/snippets/ps1.snippets $dir

