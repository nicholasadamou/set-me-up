#!/bin/bash

# shellcheck source=/dev/null

declare current_dir && \
    current_dir="$(dirname "${BASH_SOURCE[0]}")" && \
    cd "${current_dir}" && \
    source "$HOME/set-me-up/.dotfiles/utilities/utilities.sh"

declare -r VUNDLE_DIR="$HOME/.vim/plugins/Vundle.vim"
declare -r VUNDLE_GIT_REPO_URL="https://github.com/VundleVim/Vundle.vim.git"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

configure_visual_studio_code() {

    local extension="Shan.code-settings-sync"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if ! cmd_exists "code"; then
        return 1
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if ! [[ "$(code --list-extensions | grep ${extension})" == "$extension" ]]; then
        code --install-extension "$extension"
    fi

}

create_vimrc_local() {

    declare -r FILE_PATH="$HOME/.vimrc.local"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if [[ ! -e "$FILE_PATH" ]] || [[ -z "$FILE_PATH" ]]; then
        touch "$FILE_PATH"
    fi

}

install_plugins() {

    # Make sure 'backups', 'swaps' & 'undos' directories exist.
    # If not, create them.

    [[ ! -d "$HOME/.vim/backups" ]] && \
        mkdir -p "$HOME/.vim/backups"

    [[ ! -d "$HOME/.vim/swaps" ]] && \
        mkdir -p "$HOME/.vim/swaps"

    [[ ! -d "$HOME/.vim/undos" ]] && \
        mkdir -p "$HOME/.vim/undos"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Install plugins.

    git clone --quiet "$VUNDLE_GIT_REPO_URL" "$VUNDLE_DIR" \
            && printf '\n' | vim +PluginInstall +qall \
        || return 1

}

update_plugins() {

    vim +PluginUpdate +qall

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    brew_bundle_install "brewfile"

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    configure_visual_studio_code

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	create_vimrc_local

	if [[ ! -d "$VUNDLE_DIR" ]]; then
        install_plugins
    else
        update_plugins
    fi

}

main
