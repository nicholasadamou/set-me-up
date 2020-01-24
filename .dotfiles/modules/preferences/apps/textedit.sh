#!/bin/bash

defaults write com.apple.TextEdit PlainTextEncoding -int 4 && \
		defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

defaults write com.apple.TextEdit RichText 0

killall "TextEdit" &> /dev/null
