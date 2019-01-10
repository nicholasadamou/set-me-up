#!/bin/bash

# shellcheck source=/dev/null

declare current_dir && \
    current_dir="$(dirname "${BASH_SOURCE[0]}")" && \
    cd "${current_dir}" && \
    source "$HOME/set-me-up/.dotfiles/utilities/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Dashboard\n\n"

execute "defaults write com.apple.dashboard mcx-disabled -bool true" \
    "Disable Dashboard"

# `killall Dashboard` doesn't actually do anything. To apply the
# changes for `Dashboard`, `killall Dock` is enough as `Dock` is
# `Dashboard`'s parent process.

killall "Dock" &> /dev/null
