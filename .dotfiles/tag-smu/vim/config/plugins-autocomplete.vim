" @file plugins-autocomplete.vim
" @brief Plugins related to autocompletion functions.
"===============================================================================

" ----------------------------------------------------------------------
" | Plugins - deoplete                                                 |
" ----------------------------------------------------------------------
Plugin 'shougo/deoplete.nvim'

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

" Make `Tab` autocomplete.

inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

" Make `Shift+Tab` insert `Tab` character.

inoremap <S-TAB> <C-V><TAB>
