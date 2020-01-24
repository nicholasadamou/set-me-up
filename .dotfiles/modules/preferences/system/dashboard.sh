#!/bin/bash

defaults write com.apple.dashboard mcx-disabled -bool true

# `killall Dashboard` doesn't actually do anything. To apply the
# changes for `Dashboard`, `killall Dock` is enough as `Dock` is
# `Dashboard`'s parent process.

killall "Dock" &> /dev/null
