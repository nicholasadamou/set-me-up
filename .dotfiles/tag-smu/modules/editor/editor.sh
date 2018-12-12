#!/bin/bash

install_plugins() {

    declare -r VUNDLE_DIR="$HOME/.vim/plugins/Vundle.vim"
    declare -r VUNDLE_GIT_REPO_URL="https://github.com/VundleVim/Vundle.vim.git"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Install plugins.

    rm -rf "$VUNDLE_DIR" \
        && git clone --quiet "$VUNDLE_GIT_REPO_URL" "$VUNDLE_DIR" \
        && printf '\n' | vim +PluginInstall +qall \
    || return 1

}

update_plugins() {

    vim +PluginUpdate +qall

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

echo "------------------------------"
echo "Running editor module"
echo "------------------------------"
echo ""

# Install `brew` dependencies

echo "------------------------------"
echo "Installing brew dependencies"

brew bundle install -v --file="./brewfile"

# Install vim plugins

echo "------------------------------"
echo "Installing vim plugins"

install_plugins
update_plugins

# Configure Visual Studio Code

echo "------------------------------"
echo "Configuring Visual Studio Code"

if [[ $(command -v code) ]]; then
    code --install-extension CodeSync
fi

# Install Diff- and merge tools

echo "------------------------------"
echo "Installing diff- and merge tools"

# https://pempek.net/articles/2014/04/18/git-p4merge/
curl -fsSL https://pempek.net/files/git-p4merge/mac/p4merge > /usr/local/bin/p4merge
chmod +x /usr/local/bin/p4merge

git config --global merge.tool p4merge \
    && git config --global mergetool.keepTemporaries false \
    && git config --global mergetool.prompt false

# https://github.com/so-fancy/diff-so-fancy
git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
