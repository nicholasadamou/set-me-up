#!/bin/bash

defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true && \
		defaults write com.apple.AppleMultitouchTrackpad Clicking -int 1 && \
		defaults write -g com.apple.mouse.tapBehavior -int 1 && \
		defaults -currentHost write -g com.apple.mouse.tapBehavior -int 1

defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true && \
		defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -int 1 && \
		defaults -currentHost write -g com.apple.trackpad.enableSecondaryClick -bool true && \
		defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 0 && \
		defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -int 0 && \
		defaults -currentHost write -g com.apple.trackpad.trackpadCornerClickBehavior -int 0
