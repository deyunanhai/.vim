if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
   set fileencodings=ucs-bom,utf-8,euc-jp,latin1
endif

set nocompatible    " Use Vim defaults (much better!)
set bs=indent,eol,start     " allow backspacing over everything in insert mode
"set ai         " always set autoindenting on
"set backup     " keep a backup file
set viminfo='20,\"50    " read/write a .viminfo file, don't store more
            " than 50 lines of registers
set history=50      " keep 50 lines of command line history
set ruler       " show the cursor position all the time

filetype off                   " Required!

if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim/

endif

let $FZF_DEFAULT_COMMAND='ag -p ~/.gitignore -g ""'

call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
"NeoBundle 'Shougo/neobundle.vim'

" Recommended to install
" After install, turn shell ~/.vim/bundle/vimproc, (n,g)make -f your_machines_makefile
" NeoBundle 'Shougo/vimproc'
NeoBundle 'Lokaltog/vim-powerline'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/Denite.nvim'
NeoBundle 'roxma/nvim-yarp'
NeoBundle 'roxma/vim-hug-neovim-rpc'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'Shougo/neocomplcache-clang'
"NeoBundle 'pekepeke/titanium-vim'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'elzr/vim-json'
NeoBundle 'fatih/vim-go'
NeoBundle 'terryma/vim-multiple-cursors'
NeoBundle 'Shougo/vimproc', {
      \ 'build' : {
      \     'windows' : 'make -f make_mingw32.mak',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }
NeoBundle 'Shougo/vimshell'
NeoBundle 'Shougo/neoyank.vim'

"NeoBundle 'JavaScript-syntax'
NeoBundle 'pangloss/vim-javascript'
NeoBundle 'leafgarland/typescript-vim'
NeoBundle 'peitalin/vim-jsx-typescript'
NeoBundle 'walm/jshint.vim'
NeoBundle 'mxw/vim-jsx'
NeoBundle 'prettier/vim-prettier'

NeoBundle 'LeafCage/yankround.vim'

" NeoBundle 'vim-syntastic/syntastic'
" NeoBundle 'mtscout6/syntastic-local-eslint.vim'

NeoBundle 'mileszs/ack.vim'

NeoBundle 'derekwyatt/vim-scala'
NeoBundle 'vim-scripts/yaml.vim'
NeoBundle 'w0rp/ale'
NeoBundle 'junegunn/fzf', { 'do': { -> fzf#install() } }
NeoBundle 'junegunn/fzf.vim'

" NeoBundle 'isRuslan/vim-es6'

call neobundle#end()

" Only do this part when compiled with support for autocommands
if has("autocmd")
  augroup redhat
  autocmd!
  " In text files, always limit the width of text to 78 characters
  autocmd BufRead *.txt set tw=78
  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
  " don't write swapfile on most commonly used directories for NFS mounts or USB sticks
  autocmd BufNewFile,BufReadPre /media/*,/mnt/* set directory=~/tmp,/var/tmp,/tmp
  " start with spec file template
  autocmd BufNewFile *.spec 0r /usr/share/vim/vimfiles/template.spec
  augroup END
endif

if has("cscope") && filereadable("/usr/bin/cscope")
   set csprg=/usr/bin/cscope
   set csto=0
   set cst
   set nocsverb
   " add any database in current directory
   if filereadable("cscope.out")
      cs add cscope.out
   " else add database pointed to by environment
   elseif $CSCOPE_DB != ""
      cs add $CSCOPE_DB
   endif
   set csverb
endif

set t_Co=256
set laststatus=2

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

filetype plugin indent on

if &term=="xterm"
     set t_Co=8
     set t_Sb=^[[4%dm
     set t_Sf=^[[3%dm
endif

" Don't wake up system with blinking cursor:
" http://www.linuxpowertop.org/known.php
let &guicursor = &guicursor . ",a:blinkon0"

set autoindent
set expandtab
set tabstop=4
set shiftwidth=4
if has("autocmd")
  autocmd FileType *
    \ let &l:comments
    \=join(filter(split(&l:comments, ','), 'v:val =~ "^[sme]"'), ',')
endif

"行頭へ
inoremap <silent> <C-a> <C-r>=MyJumptoBol('　。、．，／！？「」')<CR>
""行末へ
inoremap <silent> <C-e> <C-r>=MyJumptoEol('　。、．，／！？「」')<CR>

if neobundle#exists_not_installed_bundles()
    echomsg 'Not installed bundles : ' .
     \ string(neobundle#get_not_installed_bundle_names())
    echomsg 'Please execute ":NeoBundleInstall" command.'
endif


function! MyJumptoBol(sep)
  if col('.') == 1
    call cursor(line('.')-1, col('$'))
    call cursor(line('.'), col('$'))
    return ''
  endif
  if matchend(strpart(getline('.'), 0, col('.')), '[[:blank:]]\+') >= col('.')-1
    silent exec 'normal! 0'
    return ''
  endif
  if a:sep != ''
    call search('[^'.a:sep.']\+', 'bW', line("."))
    if col('.') == 1
      silent exec 'normal! ^'
    endif
    return ''
  endif
  exec 'normal! ^'
  return ''
endfunction

function! MyJumptoEol(sep)
  if col('.') == col('$')
    silent exec 'normal! w'
    return ''
  endif

  if a:sep != ''
    let prevcol = col('.')
    call search('['.a:sep.']\+[^'.a:sep.']', 'eW', line("."))
    if col('.') != prevcol
      return ''
    endif
  endif
  call cursor(line('.'), col('$'))
  return ''
endfunction

" clear search when press ecs twice
"nmap <Esc><Esc> :nohlsearch<CR><Esc>

" fzf
" https://github.com/junegunn/fzf/blob/master/README-VIM.md
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'relative': v:true, 'yoffset': 0, 'xoffset': 0 } }
let g:fzf_history_dir = '~/.local/share/fzf-history'

" FuzzyFinder
let g:fuf_enumeratingLimit = 40
" let g:fuf_file_exclude = '\v\.DS_Store|\.git|\.swp|\.svn|node_modules'
let g:fuf_file_exclude = '\v\~$|\.(o|exe|dll|bak|orig|swp|class|png|gif|jpg|jar)$|(^|[/\\])(\.(hg|git|bzr|svn)|(bytecode|node_modules|classes|exports|gef.*|perspectives.*|gsr.*|jacf.*))($|[/\\])'
let g:fuf_coveragefile_exclude = '\v\~$|\.(class|png|gif|jpg|jar|o|exe|dll|bak|orig|swp)$|(^|[/\\])(\.(hg|git|bzr|svn)|(bytecode|classes|node_modules|vendor|data|logs))($|[/\\])'
let g:fuf_dir_exclude = '\v\~$|(^|[/\\])(\.(hg|git|bzr|svn)|(bytecode|node_modules|classes|exports|gef.*|perspectives.*|gsr.*|jacf.*))($|[/\\])'
" nnoremap <silent> <C-p> :<C-u>FufCoverageFile!<CR>
nnoremap <silent> <C-l> :<C-u>FufLine!<CR>

nnoremap <silent> <C-p> :<C-u>FZF<CR>

" denite
call denite#custom#var('file/rec', 'command', ['ag', '--follow', '--nocolor', '--nogroup', '--hidden', '-g', ''])
call denite#custom#source('file/rec', 'matchers', ['matcher_regexp', 'matcher_ignore_globs'])
call denite#custom#filter('matcher/ignore_globs', 'ignore_globs',
	      \ [
          \ '.git/', 'node_modules/',
	      \   'images/', '*.min.*', 'img/', 'fonts/'])
call denite#custom#var('grep', 'command', ['ag'])
call denite#custom#var('grep', 'default_opts', ['-i', '--vimgrep'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', [])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

nnoremap <silent> <C-m><C-p> :<C-u>Denite file/rec -start-filter<CR>
nnoremap <silent> <C-m><C-l> :<C-u>Denite line -start-filter<CR>
nmap <silent> <C-m><C-t> :<C-u>Denite filetype<CR>
nmap <silent> <C-m><C-g> :<C-u>Denite grep<CR>
nmap <silent> <C-m><C-h> :<C-u>DeniteCursorWord grep<CR>
nmap <silent> <C-m><C-y> :<C-u>Denite neoyank<CR>
nmap <silent> <C-m><C-f> :<C-u>Denite -resume<CR>
nmap <silent> <C-m><C-r> :<C-u>Denite register<CR>
nmap <silent> <C-m><C-m> :<C-u>Denite menu<CR>
nmap <silent> <C-m>; :<C-u>Denite -resume -immediately -select=+1<CR>
nmap <silent> <C-m>- :<C-u>Denite -resume -immediately -select=-1<CR>
nmap <silent> <C-m><C-d> :<C-u>call denite#start([{'name': 'file/rec', 'args': ['~/dotfiles']}])<CR>

autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
    nnoremap <silent><buffer><expr> <CR> denite#do_map('do_action')
    "noremap <silent><buffer><expr> d denite#do_map('do_action', 'delete')
    nnoremap <silent><buffer><expr> p denite#do_map('do_action', 'preview')
    "nnoremap <silent><buffer><expr> a denite#do_map('choose_action')
    nnoremap <silent><buffer><expr> q denite#do_map('quit')
    nnoremap <silent><buffer><expr> i denite#do_map('open_filter_buffer')
    nnoremap <silent><buffer><expr> <Space> denite#do_map('toggle_select')
endfunction

autocmd FileType denite-filter call s:denite_filter_my_settings()
function! s:denite_filter_my_settings() abort
    imap <silent><buffer> <C-o> <Plug>(denite_filter_quit)
endfunction

" Add custom menus
let s:menus = {}
let s:menus.zsh = {
            \ 'description': 'Edit your import zsh configuration'
            \ }
let s:menus.zsh.file_candidates = [
            \ ['zshrc', '~/.zshrc'],
            \ ['zshenv', '~/.zshenv'],
            \ ]
let s:menus.my_commands = {
            \ 'description': 'Example commands'
            \ }
let s:menus.my_commands.command_candidates = [
            \ ['Split the window', 'vnew'],
            \ ['Open zsh menu', 'Denite menu:zsh'],
            \ ]
call denite#custom#var('menu', 'menus', s:menus)


syntax enable
set background=dark
""let g:solarized_termcolors=256
"colorscheme solarized
"call togglebg#map("<F5>")
colorscheme Tomorrow-Night-Eighties

"colorscheme slate
"hi Pmenu ctermfg=0 ctermbg=6 guibg=#444444
"hi PmenuSel ctermfg=7 ctermbg=4 guibg=#555555 guifg=#ffffff
"set cursorline
"hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white

" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
"imap <expr><TAB> neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
"smap <expr><TAB> neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
"imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"
imap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)": pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" zf create fold
" zd delete fold
" za toggle fold zA for recursive
" zR open all flod
" zfit or zfat for html
nmap zh zfat

" vim-multiple-cursors
let g:multi_cursor_next_key='<C-n>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

" jsx
let g:jsx_ext_required = 0

let g:ale_linters = {
            \   'javascript': ['stylelint', 'eslint'],
            \   'jsx': ['stylelint', 'eslint'],
            \   'json': ['spectral'],
            \   'graphql': [],
            \   'javascript.jsx': ['stylelint', 'eslint'],
            \   'bash': ['sh'],
            \}

let g:ale_javascript_eslint_executable = 'eslint'
let g:ale_javascript_eslint_options = ''
let g:ale_javascript_eslint_suppress_eslintignore = 0
let g:ale_javascript_eslint_use_global = 0
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'


" don't hiding double quotes symbols
let g:vim_json_syntax_conceal = 0

let g:syntastic_javascript_checkers=['eslint']
" ref. https://github.com/vim-syntastic/syntastic
let g:syntastic_enable_signs = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

" let g:ale_echo_msg_format = '[%linter%] %s'
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

"LeafCage/yankround.vim
nmap p <Plug>(yankround-p)
xmap p <Plug>(yankround-p)
nmap P <Plug>(yankround-P)
nmap gp <Plug>(yankround-gp)
xmap gp <Plug>(yankround-gp)
nmap gP <Plug>(yankround-gP)
nmap <C-j> <Plug>(yankround-prev)
nmap <C-k> <Plug>(yankround-next)
let g:yankround_max_history = 35
let g:yankround_dir = '~/.cache/yankround'

" add reg
let @d='yyp'

" For snippet_complete marker.
if has('conceal')
    set conceallevel=2 concealcursor=i
endif
autocmd Filetype json setl conceallevel=0

let g:neocomplcache_enable_at_startup = 1

"let g:neocomplcache_clang_use_library=1
"let g:neocomplcache_clang_library_path = '/usr/lib/'
let g:neocomplcache_clang_executable_path = '/usr/bin/clang'
let g:neocomplcache_clang_auto_options = "path, .clang_complete, clang"
let g:neocomplcache_max_list=1000

" show hidden files in NERDTree. use shift+i to hidden them
let NERDTreeShowHidden=1

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

command! Rpspace :normal :%s/\s\+$// <CR><ESC>

" hilight the end space
augroup HighlightTrailingSpaces
  autocmd!
  autocmd VimEnter,WinEnter,ColorScheme * highlight TrailingSpaces term=underline guibg=Red ctermbg=Red
  autocmd VimEnter,WinEnter * match TrailingSpaces /\s\+$/
augroup END

" let jinja template's syntax same as yaml
autocmd BufReadPost *.jinja set syntax=yaml

" use local ackrc
" let $ACKRC=".ackrc"
nnoremap <expr> gr ':Ack!' . ' -w --ignore-dir=node_modules --ignore-dir=.next --ignore-dir=releases --ignore-dir=data --ignore-dir=vendor --ignore-dir=logs ' . expand('<cword>')

" search the select text
vnoremap * "zy:let @/ = @z<CR>n

if filereadable(".vimrc") && fnamemodify('.', ':p:h') != fnamemodify('~', ':p:h') && fnamemodify('.', ':p:h') != fnamemodify('~/.vim', ':p:h')
    source .vimrc
endif

" disable preview window
set completeopt-=preview

