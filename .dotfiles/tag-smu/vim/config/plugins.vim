" @file plugins.vim
" @brief Pulls in all of the plugin files with Vundle.
"===============================================================================

" ----------------------------------------------------------------------
" | Plugins                                                            |
" ----------------------------------------------------------------------

" Use Vundle to manage the Vim plugins.
" https://github.com/VundleVim/Vundle.vim

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

" Disable file type detection
" (this is required by Vundle).

filetype off

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

" Include Vundle in the runtime path.

set runtimepath+=~/.vim/plugins/Vundle.vim

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

" Initialize Vundle and specify the path
" where the plugins should be installed.

call vundle#begin("~/.vim/plugins")

"-------------------------------------------------------------------------------
" Vundle
"-------------------------------------------------------------------------------
Plugin 'gmarik/Vundle.vim'

"-------------------------------------------------------------------------------
" Theme, Color-scheme and syntax highlighting plugins
"-------------------------------------------------------------------------------
runtime config/plugins-color.vim

"-------------------------------------------------------------------------------
" Autocomplete plugins
"-------------------------------------------------------------------------------
runtime config/plugins-autocomplete.vim

"-------------------------------------------------------------------------------
" Git plugins
"-------------------------------------------------------------------------------
runtime config/plugins-git.vim

"-------------------------------------------------------------------------------
" Language specific plugins
"-------------------------------------------------------------------------------
runtime config/plugins-lang.vim

"-------------------------------------------------------------------------------
" Miscellaneous plugins
"-------------------------------------------------------------------------------
runtime config/plugins-misc.vim

call vundle#end()

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

" Re-enable file type detection
" (disabling it was required by Vundle).

filetype on
