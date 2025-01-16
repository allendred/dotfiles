#!/bin/sh

# 在 .gitignore 中添加 `vim/pack/vendor/start/` 将 vim 插件全部不 track

mkdir -p ~/.vim/pack/vendor/start/

git clone --depth=1 https://github.com/preservim/nerdtree.git ~/.vim/pack/vendor/start/nerdtree
git clone --depth=1 https://github.com/ojroques/vim-oscyank.git ~/.vim/pack/vendor/start/vim-oscyank
