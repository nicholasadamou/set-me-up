#!/bin/bash

# shellcheck source=/dev/null

declare current_dir && \
    current_dir="$(dirname "${BASH_SOURCE[0]}")" && \
    cd "${current_dir}" && \
    source "../utilities/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_plugins() {

    declare -r VUNDLE_DIR="$HOME/.vim/plugins/Vundle.vim"
    declare -r VUNDLE_GIT_REPO_URL="https://github.com/VundleVim/Vundle.vim.git"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Install plugins.

    execute \
        "rm -rf '$VUNDLE_DIR' \
            && git clone --quiet '$VUNDLE_GIT_REPO_URL' '$VUNDLE_DIR' \
            && printf '\n' | vim +PluginInstall +qall" \
        "Install plugins" \
        || return 1

}

update_plugins() {

    execute \
        "vim +PluginUpdate +qall" \
        "Update plugins"

}

configure_visual_studio_code() {

    local extension="golf1052.code-sync"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if ! cmd_exists "code"; then
        return 1
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if ! [ "$(code --list-extensions | grep $extension)" == "$extension" ]; then
        execute \
            "code --install-extension $extension" \
            "code ($extension)"
    else
        print_success "($extension) is already installed"
    fi

}

# see: https://pempek.net/articles/2014/04/18/git-p4merge/
# see: https://github.com/so-fancy/diff-so-fancy
install_diff_and_merge_tools() {

    if ! cmd_exists "p4merge"; then
        execute \
            "curl -fsSL https://pempek.net/files/git-p4merge/mac/p4merge > /usr/local/bin/p4merge \
            && chmod +x /usr/local/bin/p4merge" \
            "p4merge (install)"

        execute \
            "git config --global merge.tool p4merge \
                && git config --global mergetool.keepTemporaries false \
                && git config --global mergetool.prompt false" \
            "p4merge (configure)"
    else
        print_success "(p4merge) is already installed"
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if cmd_exists "diff-so-fancy"; then
        execute \
            "git config --global core.pager \"diff-so-fancy | less --tabs=4 -RFX\"" \
            "enable (diff-so-fancy)"
    fi

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    print_in_purple "\n  Editor\n\n"

    print_in_yellow "   Install brew packages\n\n"

    brew_bundle_install "Brewfile"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    print_in_yellow "\n   Vim\n\n"

    install_plugins
    update_plugins

    print_in_yellow "\n   Configure Visual Studio Code\n\n"

    configure_visual_studio_code

    print_in_yellow "\n   Install diff- and merge tools\n\n"

    install_diff_and_merge_tools

}

main