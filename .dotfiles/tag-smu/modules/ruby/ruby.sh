#!/bin/bash

# shellcheck source=/dev/null

declare current_dir && \
    current_dir="$(dirname "${BASH_SOURCE[0]}")" && \
    cd "${current_dir}" && \
    source "$HOME/set-me-up/.dotfiles/utilities/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_latest_stable_ruby() {

    # Install the latest stable version of Ruby
    # (this will also set it as the default).

    # Determine which version is the LTS version of ruby
    # see: https://stackoverflow.com/a/30191850/5290011

    # Determine the current version of Ruby installed
    # see: https://stackoverflow.com/a/51285042/5290011

    local latest_version
    local current_version

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Check if `rbenv` is installed

    if ! cmd_exists "rbenv"; then
        return 1
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    latest_version="$(
        rbenv install -l | \
        grep -v - | \
        tail -1 | \
        tr -d '[:space:]'
    )"

    current_version="$(
        ruby -e "puts RUBY_VERSION"
    )"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if [ "$current_version" != "$latest_version" ]; then
        execute \
            "rbenv install $latest_version \
                && rbenv global $latest_version" \
            "rbenv (install ruby v$latest_version)"
    else
         print_success "(ruby) is already on the latest version"
    fi

}

install_ruby_gems() {

    print_in_yellow "\n   Install ruby gems\n\n"

    gem_install "bundler"
    gem_install "tmuxinator"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    print_in_purple "  rbenv & Ruby\n\n"

    brew_bundle_install "Brewfile"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    printf "\n"

    ask_for_sudo
    
    install_latest_stable_ruby

    install_ruby_gems

}

main
