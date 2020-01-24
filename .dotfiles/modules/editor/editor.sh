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
        code --install-extension "$extension"
    fi

}

# see: https://pempek.net/articles/2014/04/18/git-p4merge/
# see: https://github.com/so-fancy/diff-so-fancy
install_diff_and_merge_tools() {

    if ! cmd_exists "p4merge"; then
        curl -fsSL https://pempek.net/files/git-p4merge/mac/p4merge > /usr/local/bin/p4merge \
            && chmod +x /usr/local/bin/p4merge

        git config --global merge.tool p4merge \
                && git config --global mergetool.keepTemporaries false \
                && git config --global mergetool.prompt false
    fi

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    brew_bundle_install "brewfile"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    configure_visual_studio_code

    install_diff_and_merge_tools

}

main
