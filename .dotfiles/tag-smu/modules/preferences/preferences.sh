#!/bin/bash

# shellcheck source=/dev/null

declare current_dir && \
    current_dir="$(dirname "${BASH_SOURCE[0]}")" && \
    cd "${current_dir}" && \
    source "$HOME/set-me-up/.dotfiles/utilities/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    print_in_purple "  MacOS Preferences\n\n"


    brew_bundle_install "brewfile"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    printf "\n"

    # Close any open `System Preferences` panes in order to
    # avoid overriding the preferences that are being changed.

    ./close_system_preferences_panes.applescript

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # App preferences
    ./apps/terminal/terminal.sh
    ./apps/app_store.sh
    ./apps/finder.sh
    ./apps/chrome.sh
    ./apps/safari.sh
    ./apps/maps.sh
    ./apps/photos.sh
    ./apps/transmission.sh
    ./apps/textedit.sh
    ./apps/firefox.sh

    # System preferences
    ./system/dashboard.sh
    ./system/dock.sh
    ./system/keyboard.sh
    ./system/language_and_region.sh
    ./system/trackpad.sh
    ./system/ui_and_ux.sh

}

main