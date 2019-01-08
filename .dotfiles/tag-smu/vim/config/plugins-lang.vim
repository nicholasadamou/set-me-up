" @file plugins-lang.vim
" @brief Language-specific vim configurations.
" @details I have some options that are language specific, but not related to
" a specific plugin. This is where they live. Also check leader.vim for
" potential filetype-only configs.
"===============================================================================

"-------------------------------------------------------------------------------
" Javascript
"-------------------------------------------------------------------------------
Plugin 'moll/vim-node'
Plugin 'isRuslan/vim-es6'
Plugin 'mtscout6/syntastic-local-eslint.vim'
Plugin 'shutnik/jshint2.vim'

" ----------------------------------------------------------------------
" | Plugins - Instant Markdown                                         |
" ----------------------------------------------------------------------
Plugin 'suan/vim-instant-markdown'

" Do not automatically launch the preview
" window when the markdown file is open.
" https://github.com/suan/vim-instant-markdown#ginstant_markdown_autostart

let g:instant_markdown_autostart = 0

" ----------------------------------------------------------------------
" | Plugins - Markdown                                                 |
" ----------------------------------------------------------------------
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'

" Disable Folding.
" https://github.com/plasticboy/vim-markdown#disable-folding

let g:vim_markdown_folding_disabled=1
