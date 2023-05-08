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
    " Linux or MacOS
    set rtp+=/usr/bin/fzf   " Substitute local fzf install location
    " Install vim-plug if it doesn't already exist
    let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
    if empty(glob(data_dir . '/autoload/plug.vim'))
        silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
    """
    call plug#begin()
endif

"Plug 'altercation/vim-colors-solarized'
"Plug 'mhartington/oceanic-next'
Plug 'gruvbox-community/gruvbox'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/fzf'   " must install fzf, bat (batcat), and ripgrep locally
Plug 'junegunn/fzf.vim'
Plug 'w0rp/ale'
Plug 'mhinz/vim-startify'
Plug 'dkarter/bullets.vim'
Plug 'frioux/vim-regedit'
Plug 'robbles/logstash.vim'
Plug 'christoomey/vim-tmux-navigator'
" :CocInstall coc-html coc-json coc-java coc-tsserver coc-sh coc-markdownlint coc-pyright coc-eslint coc-prettier coc-snippets
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ryanoasis/vim-devicons' " must be last

call plug#end()
filetype plugin indent on
syntax enable

set encoding=utf-8
set updatetime=300
" Backups don't play well with some language servers
set nobackup
set nowritebackup

" Set font for gvim, etc.
if has('gui_running')
    if g:env == 'WINDOWS'
        set rop=type:directx,gamma:1.0,contrast:0.5,level:1,geom:1,renmode:4,taamode:1
        set guifont=Hack_NF:h15
    else
        set guifont=Hack\ 15
    endif
endif

if has('termguicolors') || has('vcon')
    set termguicolors   " enable 24-bit colors
endif

" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^linux\|^Eterm'
    set t_Co=16
endif

" Color scheme stuff
autocmd vimenter * ++nested colorscheme gruvbox
" let g:solarized_termtrans=1
" colorscheme solarized
set background=dark
" let g:oceanic_next_terminal_bold = 1
" let g:oceanic_next_terminal_italic = 1
" colorscheme OceanicNext

" airline settings
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#formatter='unique_tail'
let g:airline#extensions#ale#enabled=1
let g:airline_powerline_fonts=1
let g:airline#extensions#coc#enabled = 1
let g:airline#extensions#coc#show_coc_status = 1
" let g:airline_theme='oceanicnext'
" let g:airline_theme='solarized'
" let g:airline_solarized_bg='dark'

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"

" startify settings
let g:webdevicons_enable_startify = 1
let g:startify_session_persistence = 1
let g:startify_change_to_dir = 1

" gitgitter settings
if g:env == 'WINDOWS'
    let g:gitgutter_git_executable = 'C:\Program Files\Git\bin\git.exe'
endif
" Git Gutter color changes (these need to be applied after `syntax enable`)
highlight GitGutterAdd cterm=bold ctermbg=234 ctermfg=2
highlight GitGutterChange cterm=bold ctermbg=234 ctermfg=3
highlight GitGutterDelete cterm=bold ctermbg=234 ctermfg=1
highlight GitGutterChangeDelete cterm=bold ctermbg=234 ctermfg=5

" ale settings
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
let g:ale_disable_lsp = 1
nmap <leader>d <Plug>(ale_fix)

" Write current file as superuser
if g:env == 'WINDOWS'
    command! W :execute ':silent w !sudo tee ' . shellescape(@%, 1) . ' > NUL' | :edit!
else
    command! W :execute ':silent w !sudo tee ' . shellescape(@%, 1) . ' > /dev/null' | :edit!
endif

" Make sure these folders exist!
set backupdir=$HOME/.vim/tmp//,.
set directory=$HOME/.vim/tmp//,.
set undodir=$HOME/.vim/tmp//,.
set undofile

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

" suppress error sounds/flashes
set noerrorbells novisualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=     " must be set after GUI is loaded

" misc settings
set cmdheight=2         " height of the command-line
set whichwrap+=<,>,h,l  " allow the specified motions to move to the next/prev line
set backspace=indent,eol,start  " configure backspace to work like it should
set clipboard=autoselect
set wildmenu    " enhanced command-line completion
set lazyredraw  " postpone screen redraw during macro execution, etc.
set showmatch   " briefly jump to matching bracket
set matchtime=2 " tenths of a second to blink when matching brackets
set timeoutlen=500  " time in ms to wait for key sequence to complete
set expandtab       " tabs to spaces
set smarttab        " tab inserts `shiftwidth` spaces at start of line
set shiftwidth=4    " number of spaces to insert for tab for autoindent, etc.
set tabstop=4       " number of spaces to insert for tab elsewhere
set wrap            " (soft) wrap long lines
set linebreak       " wrap lines at word boundaries
set breakindent     " wrapped lines continue visually indented
let &showbreak = '>>> ' " marker for wrapped lines
set autoindent      " enable autoindent
set smartindent     " enable smart indent
set number relativenumber   " enable line and relative line numbering
set nocursorline    " disable current line highlighting

" spelling
nmap <silent> <leader>s :setlocal spell!<CR>
set spelllang=en_us

" coc settings
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
    if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
    else
        call feedkeys('K', 'in')
    endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Mappings for CoCList
" Show all diagnostics
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" Treat long lines as break lines
" nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
" nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<CR>

" Misc. shortcuts
map <C-o> :NERDTreeToggle<CR>
map <F9> :e $MYVIMRC<CR>

autocmd BufNewFile,BufRead PKGBUILD set filetype=PKGBUILD
autocmd FileType javascript set tabstop=2|set shiftwidth=2 " JS tabs are 2 spaces

" Git shortcuts
command! Gwd :Gw | :bdelete<CR>     " git save, add, and close file
nnoremap <leader>gd :Gdiffsplit!<CR>
nnoremap <leader>du :diffupdate<CR>
nnoremap <leader>g2 :diffget //2<CR>
nnoremap <leader>g3 :diffget //3<CR>

" Remove trailing whitespace
nnoremap <silent> <leader>rw :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

let g:xml_syntax_folding=1
au FileType xml setlocal foldmethod=syntax

" Watch for changes to .vimrc (et al.), reload, and maximize window
augroup myvimrc
    au!
    au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc so $MYVIMRC | if has('gui_running') | simalt ~x | endif
augroup END

" Maximize window on GUI load
autocmd GUIEnter * simalt ~x

" Temporarily disable relative numbers when in insert mode
autocmd InsertEnter * :set norelativenumber
autocmd InsertLeave * :set relativenumber

" terminal cursor options
let &t_SI = "\<Esc>[6 q"    " Start Insert mode (bar cursor shape)
let &t_SR = "\<Esc>[4 q"    " Start Replace mode (underline cursor shape)
let &t_EI = "\<Esc>[2 q"    " End Insert or Replace mode (block cursor shape)

highlight Comment cterm=italic  " Render comments in italics

" Devicon settings
if g:env == 'DARWIN'
    let g:WebDevIconOS = 'Darwin'
endif
if exists("g:loaded_webdevicons")
    call webdevicons#refresh()
endif

" FZF stuff
let $FZF_DEFAULT_COMMAND = 'rg --files --no-ignore --hidden --follow --glob "!.git/*" --glob "!node_modules/*"'

" Requires bat
function! FzfWithDevIcons()
    let l:fzf_files_options = ' -m --bind ctrl-d:preview-page-down,ctrl-u:preview-page-up --preview "bat--color always --style numbers {2..}"'

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

" requires bat and devicon-lookup (installed via cargo)
function! FzfWithDevIcons2()
    let l:fzf_files_options = ' -m --bind ctrl-d:preview-page-down,ctrl-u:preview-page-up --preview "bat --color always --style numbers {2..}"'

    function! s:files()
        let l:files = split(system($FZF_DEFAULT_COMMAND.'| devicon-lookup'), '\n')
        return l:files
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

command! FilesWithIcon :call FzfWithDevIcons()
command! FilesWithIconFast :call FzfWithDevIcons2()

map ; :FilesWithIconFast<CR>
