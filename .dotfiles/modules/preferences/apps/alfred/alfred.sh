#!/bin/bash

if brew info alfred &>/dev/null; then
	# install alfred packages
	npx_install "awm"

	[ -f "$(locate_alfred_preferences)" ] && {
		npx_install "alfred-emoj"
		npx_install "alfred-npms"
		npx_install "alfred-dark-mode"
		npx_install "alfred-cdnjs"
		npx_install "alfred-packagist"
		npx_install "alfred-mdi"
		npx_install "alfred-awe"
	}
fi
