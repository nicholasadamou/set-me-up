#!/bin/bash

# shellcheck source=/dev/null

declare current_dir && \
    current_dir="$(dirname "${BASH_SOURCE[0]}")" && \
    cd "${current_dir}" && \
    source "../utilities/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Language & Region\n\n"

execute "defaults write -g AppleLanguages -array 'en_US'" \
    "Set language"

execute "defaults write -g AppleMeasurementUnits -string 'Inches'" \
    "Set measurement units"

execute "defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false" \
    "Disable auto-correct"
