#!/bin/bash

defaults write com.apple.terminal FocusFollowsMouse -string true

defaults write com.apple.terminal SecureKeyboardEntry -bool true

defaults write com.apple.Terminal ShowLineMarks -int 0

defaults write com.apple.terminal StringEncodings -array 4

defaults write com.googlecode.iterm2 PromptOnQuit -bool false

./set_terminal_theme.applescript
