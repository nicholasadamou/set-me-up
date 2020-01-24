#!/bin/bash

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
