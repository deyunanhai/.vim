#!/bin/sh
mkdir bundle
cd bundle
rm -rf neobundle.vim neocomplcache vim-powerline
git clone git://github.com/Shougo/neobundle.vim.git
