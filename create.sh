#!/bin/sh
mkdir bundle
cd bundle
rm -rf neobundle.vim neocomplcache
git clone https://github.com/Shougo/neobundle.vim.git

cd $HOME
ln -s .vim/.vimrc
