" @file plugins-git.vim
" @brief Plugins for using Git version control
"===============================================================================

Plugin 'tpope/vim-fugitive'

"-------------------------------------------------------------------------------
" GitGutter: If a file is in a git repository, shows a column on the side with
" diff information.
"-------------------------------------------------------------------------------
Plugin 'airblade/vim-gitgutter'

" ----------------------------------------------------------------------
" | Plugins - Signify                                                  |
" ----------------------------------------------------------------------
Plugin 'mhinz/vim-signify'

" Disable Signify by default.
" https://github.com/mhinz/vim-signify

let g:signify_disable_by_default=1

