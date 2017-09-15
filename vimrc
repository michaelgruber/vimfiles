" Dein
if &compatible
  set nocompatible
endif
set runtimepath+=$HOME/vimfiles/bundle/repos/github.com/Shougo/dein.vim

if dein#load_state(expand('$HOME/vimfiles/bundle'))
  call dein#begin(expand('$HOME/vimfiles/bundle'))
  call dein#add('Shougo/dein.vim')

  call dein#add('altercation/vim-colors-solarized')
  call dein#add('AndrewRadev/vim-eco')
  call dein#add('ekalinin/Dockerfile.vim')
  call dein#add('fatih/vim-go')
  call dein#add('hashivim/vim-terraform')
  call dein#add('ianks/vim-tsx')
  call dein#add('junegunn/vim-easy-align')
  call dein#add('kchmck/vim-coffee-script')
  call dein#add('leafgarland/typescript-vim')
  call dein#add('pangloss/vim-javascript')
  call dein#add('Quramy/tsuquyomi')
  call dein#add('Shougo/neocomplete.vim')
  call dein#add('Shougo/unite.vim')
  call dein#add('Shougo/vimproc.vim', {'build': has('win32') ? 'tools\\update-dll-mingw' : 'make'})
  call dein#add('Shougo/vimshell.vim')
  call dein#add('stephpy/vim-yaml')
  call dein#add('thinca/vim-qfreplace')
  call dein#add('tpope/vim-surround')

  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
syntax enable

if dein#check_install()
  call dein#install()
endif

" General
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
set tabstop=2
set shiftwidth=2
set expandtab " soft tabs

" Syntax
autocmd BufRead,BufNewFile *.rabl set filetype=ruby " Rabl
autocmd BufRead,BufNewFile *.md set filetype=text

" Easy Align
xnoremap ga <Plug>(EasyAlign)
nnoremap ga <Plug>(EasyAlign)

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

" Neocomplete
let g:acp_enableAtStartup = 0                           " disable AutoComplPop
let g:neocomplete#enable_at_startup = 1                 " use neocomplete
let g:neocomplete#enable_smart_case = 1                 " use smartcase
let g:neocomplete#sources#syntax#min_keyword_length = 3 " set minimum syntax keyword length
let g:neocomplete#sources#dictionary#dictionaries = {
  \ 'default' : '',
  \ 'vimshell' : $HOME.'/.vimshell_hist',
  \ 'scheme' : $HOME.'/.gosh_completions'
\ }

set completeopt+=menuone

if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {} " define keyword
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

inoremap <expr><C-g> neocomplete#undo_completion()
inoremap <expr><C-l> neocomplete#complete_common_string()
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>

function! s:my_cr_function()
  return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
endfunction

inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"

autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType typescript setlocal omnifunc=tsuquyomi#complete

if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {} " enable heavy omni completion
endif

let g:neocomplete#sources#omni#input_patterns.typescript = '[^. *\t]\.\w*\|\h\w*::' " for tsuquyomi
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'        " for perlomni.vim setting.

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
