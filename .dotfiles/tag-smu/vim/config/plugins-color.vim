" @file plugins-color.vim
" @brief Plugins for syntax highlighting, color schemes, and other miscellaneous
" small visual things.
"===============================================================================

" Enable syntax highlighting.
syntax on
syntax enable

"-------------------------------------------------------------------------------
" vim-polyglot: Generic Language Support
"-------------------------------------------------------------------------------
Plugin 'sheerun/vim-polyglot'

"-------------------------------------------------------------------------------
" Syntastic: Syntax checking on file save, it's a lifesaver for the small
" mistakes I make all the time.  Will alert me to mistakes before compilation.
"-------------------------------------------------------------------------------
Plugin 'scrooloose/syntastic'
Plugin 'jelera/vim-javascript-syntax'

" Nicer symbols in the gutter
let g:syntastic_error_symbol = '✘'
let g:syntastic_warning_symbol = "▲"

let g:syntastic_javascript_checkers = ['eslint']

" LaTeX warnings are very prolific, so it's not too helpful to have on all the
" time.
augroup beziSyntastic
    au!
    au FileType tex let b:syntastic_mode = "passive"
augroup END

" Inform Syntastic which checkers to use based on file types.
" https://github.com/scrooloose/syntastic#faq

let g:syntastic_javascript_checkers = [ 'eslint' ]

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

" Disable syntax checking by default.

let g:syntastic_mode_map = {
    \ "active_filetypes": [],
    \ "mode": "passive",
    \ "passive_filetypes": []
\}

" ----------------------------------------------------------------------
" | Plugins - Vim-Airline-Themes                                       |
" ----------------------------------------------------------------------
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

let g:airline_theme='ayu_mirage'

let g:airline_powerline_fonts = 0

" ----------------------------------------------------------------------
" | Color Scheme                                                       |
" ----------------------------------------------------------------------
Plugin 'ayu-theme/ayu-vim'

" Enable full-color support.
set t_Co=256

" Use colors that look good
" on a dark background.
set background=dark

" set' mirage' version of ayu theme
let ayucolor="mirage"

" Since the colorscheme is in a plugin, it may not always be there at first, so
" we put it into a try-catch
try
    " A nice dark color scheme that's easy on the eyes
    colorscheme ayu
catch
    " Don't do anything, just supress the 'colorscheme doesn't exist' error.
endtry

" ----------------------------------------------------------------------
" | Status Line                                                        |
" ----------------------------------------------------------------------
" Terminal types:
"
"   1) term  (normal terminals, e.g.: vt100, xterm)
"   2) cterm (color terminals, e.g.: MS-DOS console, color-xterm)
"   3) gui   (GUIs)

highlight ColorColumn
    \ term=NONE
    \ cterm=NONE  ctermbg=237    ctermfg=NONE
    \ gui=NONE    guibg=#073642  guifg=NONE

highlight CursorLine
    \ term=NONE
    \ cterm=NONE  ctermbg=235  ctermfg=NONE
    \ gui=NONE    guibg=#073642  guifg=NONE

highlight CursorLineNr
    \ term=bold
    \ cterm=bold  ctermbg=NONE   ctermfg=178
    \ gui=bold    guibg=#073642  guifg=Orange

highlight LineNr
    \ term=NONE
    \ cterm=NONE  ctermfg=241    ctermbg=NONE
    \ gui=NONE    guifg=#839497  guibg=#073642

highlight User1
    \ term=NONE
    \ cterm=NONE  ctermbg=237    ctermfg=Grey
    \ gui=NONE    guibg=#073642  guifg=#839496

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

set statusline=
set statusline+=%1*            " User1 highlight
set statusline+=\ [%n]         " Buffer number
set statusline+=\ %{GetGitBranchName()}        " Git branch name
set statusline+=\ [%f]         " File path
set statusline+=%m             " Modified flag
set statusline+=%r             " Readonly flag
set statusline+=%h             " Help file flag
set statusline+=%w             " Preview window flag
set statusline+=%y             " File type
set statusline+=[
set statusline+=%{&ff}         " File format
set statusline+=:
set statusline+=%{strlen(&fenc)?&fenc:'none'}  " File encoding
set statusline+=]
set statusline+=%=             " Left/Right separator
set statusline+=%c             " File encoding
set statusline+=,
set statusline+=%l             " Current line number
set statusline+=/
set statusline+=%L             " Total number of lines
set statusline+=\ (%P)\        " Percent through file

" Example result:
"
"  [1] [master] [vim/vimrc][vim][unix:utf-8]            17,238/381 (59%)
