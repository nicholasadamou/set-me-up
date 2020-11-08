#!/bin/bash

defaults write com.apple.dock autohide -bool true

defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

defaults write com.apple.dock expose-group-by-app -bool false

defaults write com.apple.dock mineffect -string 'scale'

defaults write com.apple.dock minimize-to-application -bool true

defaults write com.apple.dock mru-spaces -bool false

defaults write com.apple.dock mru-spaces -bool false

defaults write com.apple.dock showhidden -bool true

defaults write com.apple.dock tilesize -int 60

defaults write com.apple.dock pinning -string start

defaults write com.apple.dock workspaces-auto-swoosh -bool false

killall "Dock" &> /dev/null
