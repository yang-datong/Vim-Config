
choco install neovim nodejs -y

pip3.10 install pynvim neovim-remote

mkdir ~\.config\nvim
mkdir ~\.config\nvim\autoload

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
cp ./config/seoul256.vim ~/.config/nvim/plugged/seoul256.vim/colors/seoul256.vim

cp ../config_file/snippets/all.snippets ~/.config/nvim/plugged/vim-snippets/UltiSnips/
cp ../config_file/snippets/cpp.snippets ~/.config/nvim/plugged/vim-snippets/UltiSnips/
cp ../config_file/snippets/javascript.snippets   ~/.config/nvim/plugged/vim-snippets/UltiSnips/
cp ../config_file/snippets/make.snippets ~/.config/nvim/plugged/vim-snippets/UltiSnips/
cp ../config_file/snippets/python.snippets   ~/.config/nvim/plugged/vim-snippets/UltiSnips/
cp ../config_file/snippets/snippets.snippets ~/.config/nvim/plugged/vim-snippets/UltiSnips/
cp ../config_file/snippets/cmake.snippets   ~/.config/nvim/plugged/vim-snippets/UltiSnips/
cp ../config_file/snippets/c.snippets ~/.config/nvim/plugged/vim-snippets/UltiSnips/
cp ../config_file/snippets/java.snippets ~/.config/nvim/plugged/vim-snippets/UltiSnips/
cp ../config_file/snippets/markdown.snippets   ~/.config/nvim/plugged/vim-snippets/UltiSnips/
cp ../config_file/snippets/sh.snippets ~/.config/nvim/plugged/vim-snippets/UltiSnips/
cp ../config_file/snippets/tex.snippets ~/.config/nvim/plugged/vim-snippets/UltiSnips/
cp ../config_file/snippets/ps1.snippets ~/.config/nvim/plugged/vim-snippets/UltiSnips/
