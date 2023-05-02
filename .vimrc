set encoding=utf-8

" Define a global variable containing the current environment's name
" if it hasn't been already defined.
if !exists('g:env')
    if has('win64') || has('win32') || has('win16')
        let g:env = 'WINDOWS'
    else
        " LINUX, DARWIN, SUNOS, etc.
        let g:env = toupper(substitute(system('uname'), '\n', '', ''))
    endif
endif

set nocompatible    " use Vim defaults
filetype off        " required before loading plugins

" OS-specific plugin settings
if g:env == 'WINDOWS'
    set rtp+=C:/ProgramData/chocolatey/bin/ " Substitute local fzf install location
    call plug#begin()
else
    " Since I only use Windows or Linux, I'm lazy and assume Linux here
    set rtp+=/usr/bin/fzf   " Substitute local fzf install location
    call plug#begin()
endif

Plug 'altercation/vim-colors-solarized'
" Plug 'nanotech/jellybeans.vim'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/fzf'   " must install fzf locally
Plug 'junegunn/fzf.vim'
Plug 'w0rp/ale'
Plug 'pangloss/vim-javascript'
Plug 'mhinz/vim-startify'
Plug 'dkarter/bullets.vim'
Plug 'frioux/vim-regedit'
Plug 'robbles/logstash.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'ryanoasis/vim-devicons' " must be last

call plug#end()
filetype plugin indent on
syntax enable

if has('gui_running')
    if g:env == 'WINDOWS'
        set rop=type:directx,gamma:1.0,contrast:0.5,level:1,geom:1,renmode:4,taamode:1
        set guifont=Hack_NF:h15
    else
        set guifont=Hack\ 15
    endif
endif

if g:env != 'WINDOWS' || has('vcon')
    set termguicolors   " enable 24-bit colors
endif

" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^linux\|^Eterm'
  set t_Co=16
endif

let g:solarized_termtrans=1
colorscheme solarized
set background=dark


let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#formatter='unique_tail'
let g:airline#extensions#ale#enabled=1
let g:airline_powerline_fonts=1
let g:airline_theme='solarized'
let g:airline_solarized_bg='dark'

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"

let g:webdevicons_enable_startify = 1
let g:startify_session_persistence = 1
let g:startify_change_to_dir = 1

if g:env == 'WINDOWS'
    let g:gitgutter_git_executable = 'C:\Program Files\Git\bin\git.exe'
endif
set updatetime=100
" Git Gutter color changes (these need to be applied after `syntax enable`)
highlight GitGutterAdd cterm=bold ctermbg=234 ctermfg=2
highlight GitGutterChange cterm=bold ctermbg=234 ctermfg=3
highlight GitGutterDelete cterm=bold ctermbg=234 ctermfg=1
highlight GitGutterChangeDelete cterm=bold ctermbg=234 ctermfg=5

let g:javascript_plugin_jsdoc=1

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['eslint'],
\}
" let g:ale_lint_on_text_changed = 'never'
" let g:ale_sign_column_always = 1
let g:ale_statusline_format = ['⨉ %d', '⚠ %d', '⬥ ok']
" let g:ale_javascript_eslint_executable = 'eslint_d'
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '⚠'
"let g:ale_fix_on_save = 1
nmap <leader>d <Plug>(ale_fix)

" Write current file as superuser
if g:env == 'WINDOWS'
    command! W :execute ':silent w !sudo tee ' . shellescape(@%, 1) . ' > NUL' | :edit!
else
    command! W :execute ':silent w !sudo tee ' . shellescape(@%, 1) . ' > /dev/null' | :edit!
endif

set undofile

" Make sure these folders exist!
set backupdir=$HOME/.vim/tmp//,.
set directory=$HOME/.vim/tmp//,.
set undodir=$HOME/.vim/tmp//,.

set cmdheight=2         " height of the command-line
set whichwrap+=<,>,h,l  " allow the specified motions to move to the next/prev line
set backspace=indent,eol,start  " configure backspace to work like it should

" set clipboard=unnamedplus
set clipboard=autoselect

" Buffer stuff
set hidden  " allows a modified buffer to be hidden; caution! this makes it easy to forget about unmodified buffers!
nnoremap <C-N> :enew<CR>        " Open a new, empty buffer
nnoremap <Tab> :bnext<CR>       " Move to the next buffer
nnoremap <S-Tab> :bprevious<CR> " Move to the previous buffer
nnoremap <C-X> :w <BAR> bp <BAR> bdelete #<CR>  " Save and close the current buffer, and move to the previous one
map <leader>cd :cd %:p:h<cr>:pwd<cr>    " Switch CWD to the directory of the open buffer

" search options
set ignorecase
set smartcase
set hlsearch
set incsearch

set wildmenu    " enhanced command-line completion
set lazyredraw  " postpone screen redraw during macro execution, etc.
set showmatch   " briefly jump to matching bracket
set matchtime=2 " tenths of a second to blink when matching brackets

nmap <silent> <leader>s :setlocal spell!<CR>
set spelllang=en_us

" Suppress error sounds/flashes
set noerrorbells
set novisualbell
set t_vb=
set tm=500

set expandtab
set smarttab
set shiftwidth=4
set tabstop=4

set lbr
set tw=500
set ai
set si
set wrap
set number relativenumber
set nocursorline

" Treat long lines as break lines
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<CR>

"nmap <leader>md :%!markdown <cr>   "Markdown to HTML
"nmap <F8> :TagbarToggle<CR>
map <C-o> :NERDTreeToggle<CR>
map ; :Files<CR>
map <F9> :e $MYVIMRC<CR>

"autocmd BufNewFile,BufRead *.cpp set formatprg=astyle\ -A1fpUxdjk1
"autocmd FileType html,htmldjango,jinjahtml,eruby,mako let b:closetag_html_style=1
"autocmd FileType html,xhtml,xml,htmldjango,jinjahtml,eruby,mako source /usr/share/vim/vim73/plugin/closetag.vim
au BufNewFile,BufRead PKGBUILD set filetype=PKGBUILD
autocmd FileType javascript set tabstop=2|set shiftwidth=2

command! Gwd :Gw | :bdelete<CR>     " git save, add, and close file
nnoremap <leader>gd :Gdiffsplit!<CR>
nnoremap <leader>du :diffupdate<CR>
nnoremap <leader>g2 :diffget //2<CR>
nnoremap <leader>g3 :diffget //3<CR>

" Arduino stuff
"nnoremap <leader>ib :!ino build<CR>
"nnoremap <leader>iu :!ino upload<CR>
"nnoremap <leader>is :!ino serial<CR>

" Remove trailing whitespace
nnoremap <silent> <leader>rw :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

" ALE now takes care of the following; kept for posterity
" Remove trailing whitespace on save
" autocmd BufWritePre * %s/\s\+$//e

let g:xml_syntax_folding=1
au FileType xml setlocal foldmethod=syntax

" Watch for changes to .vimrc (et al.), reload, and maximize window
augroup myvimrc
    au!
    au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc so $MYVIMRC | if has('gui_running') | simalt ~x | endif
augroup END

" Maximize window on GUI load
autocmd GUIEnter * simalt ~x

autocmd InsertEnter * :set norelativenumber
autocmd InsertLeave * :set relativenumber

" terminal cursor options
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

highlight Comment cterm=italic

if exists("g:loaded_webdevicons")
  call webdevicons#refresh()
endif

let $FZF_DEFAULT_COMMAND = 'rg --files --no-ignore --hidden --follow --glob "!.git/*" --glob "!node_modules/*"'

" Files + devicons
function! Fzf_dev()
  "let l:fzf_files_options = '--preview "rougify {2..-1} | head -'.&lines.'"'
  let l:fzf_files_options = ' -m --bind ctrl-d:preview-page-down,ctrl-u:preview-page-up --preview "bat --color always --style numbers {2..}"'

  function! s:files()
    let l:files = split(system($FZF_DEFAULT_COMMAND), '\n')
    return s:prepend_icon(l:files)
  endfunction

  function! s:prepend_icon(candidates)
    let l:result = []
    for l:candidate in a:candidates
      let l:filename = fnamemodify(l:candidate, ':p:t')
      let l:icon = WebDevIconsGetFileTypeSymbol(l:filename, isdirectory(l:filename))
      call add(l:result, printf('%s %s', l:icon, l:candidate))
    endfor

    return l:result
  endfunction

  function! s:edit_file(item)
    let l:pos = stridx(a:item, ' ')
    let l:file_path = a:item[pos+1:-1]
    execute 'silent e' l:file_path
  endfunction

  call fzf#run({
        \ 'source': <sid>files(),
        \ 'sink':   function('s:edit_file'),
        \ 'options': '-m ' . l:fzf_files_options,
        \ 'down':    '40%' })
endfunction

function! FzfWithDevIcons()
  let l:fzf_files_options = ' -m --bind ctrl-d:preview-page-down,ctrl-u:preview-page-up --preview "bat --color always --style numbers {2..}"'

  function! s:files()
    let l:files = split(system($FZF_DEFAULT_COMMAND), '\n')
    return s:prepend_icon(l:files)
  endfunction

  function! s:prepend_icon(candidates)
    let result = []
    for candidate in a:candidates
      let filename = fnamemodify(candidate, ':p:t')
      let icon = WebDevIconsGetFileTypeSymbol(filename, isdirectory(filename))
      call add(result, printf("%s %s", icon, candidate))
    endfor

    return result
  endfunction

  function! s:edit_file(items)
    let items = a:items
    let i = 1
    let ln = len(items)
    while i < ln
      let item = items[i]
      let parts = split(item, ' ')
      let file_path = get(parts, 1, '')
      let items[i] = file_path
      let i += 1
    endwhile
    call s:Sink(items)
  endfunction

  let opts = fzf#wrap({})
  let opts.source = <sid>files()
  let s:Sink = opts['sink*']
  let opts['sink*'] = function('s:edit_file')
  let opts.options .= l:fzf_files_options
  call fzf#run(opts)

endfunction


"command! FilesWithIcon :call FzfWithDevIcons()
command! FilesWithIcon :call Fzf_dev()
