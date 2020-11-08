" @file nav.vim
" @brief Navigation shortcuts, for everything related to moving around.
"===============================================================================

" make the j and k work better with wrapped text
" if you hit j, it goes down a visual line, not a logical line
noremap j gj
noremap k gk

" navigate splits by adding the Ctrl-modifier to the analogous vim motion
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
