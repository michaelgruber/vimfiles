" Dein
if &compatible
  set nocompatible
endif
set runtimepath^=$HOME/vimfiles/bundle/repos/github.com/Shougo/dein.vim

call dein#begin(expand('$HOME/vimfiles/bundle'))

call dein#add('Shougo/dein.vim')
call dein#add('altercation/vim-colors-solarized')
call dein#add('AndrewRadev/vim-eco')
call dein#add('ekalinin/Dockerfile.vim')
call dein#add('fatih/vim-go')
call dein#add('kchmck/vim-coffee-script')
call dein#add('pangloss/vim-javascript')
call dein#add('Shougo/unite.vim')
call dein#add('Shougo/vimproc.vim', {'build': has('win32') ? 'tools\\update-dll-mingw' : 'make'})
call dein#add('Shougo/vimshell.vim')
call dein#add('thinca/vim-qfreplace')
call dein#add('tpope/vim-surround')

call dein#end()

filetype plugin indent on

if dein#check_install()
  call dein#install()
endif

" General
syntax on
cd %:p:h         " set working dir to current file/dir when vim opens
set path=$PWD/** " add subdirectories to path for searching
set backspace=2  " enable backspace
set hidden       " hide buffer instead of closing
set nowrap       " don't wrap lines
set number       " line numbers
set ruler        " cursor location
set spell        " spell checker
set t_Co=256     " 256 colors if terminal supports it
set novisualbell " stop beeping

" Sierra + tmux clipboard fix
" https://github.com/tmux/tmux/issues/543#issuecomment-248980734
set clipboard=unnamed

" Persist undo
if has('persistent_undo')
  set undodir=$HOME/vimfiles/backups
  set undofile
endif

" Move viminfo
set viminfo+=n$HOME/vimfiles/viminfo

" Recovery & Backup Off
set nobackup
set noswapfile
set nowb

" Color Scheme
silent! colorscheme solarized
set background=light

" Indentation
set expandtab " soft tabs
set tabstop=2
set shiftwidth=2

" Syntax
autocmd BufRead,BufNewFile *.rabl set filetype=ruby " Rabl
autocmd BufRead,BufNewFile *.md set filetype=text

" Unite
call unite#filters#matcher_default#use(['matcher_fuzzy'])

let g:unite_source_rec_async_command = ['pt', '--follow', '--nocolor', '--nogroup', '--hidden', '-l', '']
let g:unite_source_grep_command = 'pt'
let g:unite_source_grep_default_opts = '--nogroup --nocolor'
let g:unite_source_grep_recursive_opt = ''

nnoremap <leader>f :<C-u>Unite -start-insert file_rec/async:!<CR>
nnoremap <leader>s :<C-u>Unite -start-insert -buffer-name=search grep:.<CR>

autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()"{{{
  " Overwrite settings.

  let unite = unite#get_current_unite()
  if unite.profile_name ==# 'search'
    nnoremap <silent><buffer><expr> r unite#do_action('replace')
  else
    nnoremap <silent><buffer><expr> r unite#do_action('rename')
  endif
endfunction"}}}

" Windows
if has('win32')
    set guifont=Source\ Code\ Pro:h11,Consolas:h11
    source $VIMRUNTIME\mswin.vim " for windows copy and pasting

" Unix
elseif has('unix')
    let s:uname = system("echo -n \"$(uname)\"") " get OS type

" OS X
    if !v:shell_error && s:uname == "Darwin"
        set guifont=Source\ Code\ Pro:h12,\ Menlo:h13

" Linux
    else

    endif
endif
