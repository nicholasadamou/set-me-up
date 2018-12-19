#!/bin/bash

# shellcheck source=/dev/null

declare current_dir && \
    current_dir="$(dirname "${BASH_SOURCE[0]}")" && \
    . "$(readlink -f "${current_dir}/../utilities/utils.sh")"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    print_in_purple "\n • MacOS Preferences\n"


    brew_bundle_install "Brewfile"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    printf "\n"

    # Close any open `System Preferences` panes in order to
    # avoid overriding the preferences that are being changed.

    ./close_system_preferences_panes.applescript

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # App preferences
    ./preferences/apps/terminal/terminal.sh
    ./preferences/apps/app_store.sh
    ./preferences/apps/finder.sh
    ./preferences/apps/chrome.sh
    ./preferences/apps/safari.sh
    ./preferences/apps/maps.sh
    ./preferences/apps/photos.sh
    ./preferences/apps/transmission.sh
    ./preferences/apps/textedit.sh
    ./preferences/apps/firefox.sh

    # System preferences
    ./preferences/system/dashboard.sh
    ./preferences/system/dock.sh
    ./preferences/system/keyboard.sh
    ./preferences/system/language_and_region.sh
    ./preferences/system/trackpad.sh
    ./preferences/system/ui_and_ux.sh

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    execute \
        "mackup restore" \
        "mackup (restore)"

}