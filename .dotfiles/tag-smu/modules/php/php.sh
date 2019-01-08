#!/bin/bash

# shellcheck source=/dev/null

declare current_dir && \
    current_dir="$(dirname "${BASH_SOURCE[0]}")" && \
    cd "${current_dir}" && \
    source "$HOME/set-me-up/.dotfiles/utilities/utils.sh"

declare -r COMPOSER_DIRECTORY="/usr/local/bin"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_composer() {

    EXPECTED_SIGNATURE="$(wget -q -O - https://composer.github.io/installer.sig)"
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    ACTUAL_SIGNATURE="$(php -r "echo hash_file('SHA384', 'composer-setup.php');")"

    if [ "$EXPECTED_SIGNATURE" == "$ACTUAL_SIGNATURE" ]; then
        execute \
            "php composer-setup.php --install-dir=\"$COMPOSER_DIRECTORY\" --filename=composer --quiet" \
            "composer (install)"
    else
        print_error "ERROR:" "Invalid installer signature"
    fi

    rm composer-setup.php

}

update_composer() {

    execute \
        "php $COMPOSER_DIRECTORY/composer self-update --quiet" \
        "composer (update)"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    print_in_purple "  composer & PHP\n\n"

    print_in_yellow "   Install brew packages\n\n"

    brew_bundle_install "brewfile"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    printf "\n"

    ask_for_sudo

    if ! cmd_exists "composer" && [ ! -e "$COMPOSER_DIRECTORY/composer" ]; then
        install_composer
    else
        update_composer
    fi

}

main
