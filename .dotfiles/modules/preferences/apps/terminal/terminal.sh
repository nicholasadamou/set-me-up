#!/bin/bash

defaults write com.apple.terminal FocusFollowsMouse -string true

defaults write com.apple.terminal SecureKeyboardEntry -bool true

defaults write com.apple.Terminal ShowLineMarks -int 0

defaults write com.apple.terminal StringEncodings -array 4

defaults write com.googlecode.iterm2 PromptOnQuit -bool false

./set_terminal_theme.applescript

# Ensure the Touch ID is used when `sudo` is required.

if ! grep -q "pam_tid.so" "/etc/pam.d/sudo"; then
    sudo sh -c 'echo \"auth sufficient pam_tid.so\" >> /etc/pam.d/sudo'
fi
