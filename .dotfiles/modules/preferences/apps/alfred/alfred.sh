#!/bin/bash

# shellcheck source=/dev/null

declare current_dir && \
    current_dir="$(dirname "${BASH_SOURCE[0]}")" && \
    cd "${current_dir}" && \
    source "$HOME/set-me-up/.dotfiles/utilities/utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "   Alfred\n\n"

# install alfred packages
npm_install "awm"

[ -f "$(locate_alfred_preferences)" ] && {
	npm_install "alfred-emoj"
	npm_install "alfred-npms"
	npm_install "alfred-dark-mode"
	npm_install "alfred-cdnjs"
	npm_install "alfred-packagist"
	npm_install "alfred-mdi"
	npm_install "alfred-awe"
}
