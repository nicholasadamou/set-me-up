#!/bin/bash

# shellcheck source=/dev/null

declare current_dir && \
    current_dir="$(dirname "${BASH_SOURCE[0]}")" && \
    cd "${current_dir}" && \
    source "$HOME/set-me-up/.dotfiles/utilities/utilities.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

configure_visual_studio_code() {

    local extension="Shan.code-settings-sync"

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

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    print_in_purple "  Editor\n\n"

    print_in_yellow "   Install brew packages\n\n"

    brew_bundle_install "brewfile"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    print_in_yellow "\n   Configure Visual Studio Code\n\n"

    configure_visual_studio_code

    print_in_yellow "\n   Install diff and merge tools\n\n"

    install_diff_and_merge_tools

}

main
