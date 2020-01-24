#!/bin/bash

defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true && \
		defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true && \
		defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

defaults write com.apple.finder DisableAllAnimations -bool true

defaults write com.apple.finder WarnOnEmptyTrash -bool false

defaults write com.apple.finder FXDefaultSearchScope -string 'SCcf'

defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

defaults write com.apple.finder FXPreferredViewStyle -string 'Nlsv'

defaults write com.apple.finder NewWindowTarget -string 'PfDe' && \
		defaults write com.apple.finder NewWindowTargetPath -string "file://$HOME/Desktop/"

defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true && \
		defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true && \
		defaults write com.apple.finder ShowMountedServersOnDesktop -bool true && \
		defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

defaults write com.apple.finder ShowRecentTags -bool false

defaults write -g AppleShowAllExtensions -bool true

/usr/libexec/PlistBuddy -c 'Set :DesktopViewSettings:IconViewSettings:iconSize 72' ~/Library/Preferences/com.apple.finder.plist && \
		/usr/libexec/PlistBuddy -c 'Set :StandardViewSettings:IconViewSettings:iconSize 72' ~/Library/Preferences/com.apple.finder.plist

/usr/libexec/PlistBuddy -c 'Set :DesktopViewSettings:IconViewSettings:gridSpacing 1' ~/Library/Preferences/com.apple.finder.plist && \
		/usr/libexec/PlistBuddy -c 'Set :StandardViewSettings:IconViewSettings:gridSpacing 1' ~/Library/Preferences/com.apple.finder.plist

/usr/libexec/PlistBuddy -c 'Set :DesktopViewSettings:IconViewSettings:textSize 13' ~/Library/Preferences/com.apple.finder.plist && \
		/usr/libexec/PlistBuddy -c 'Set :StandardViewSettings:IconViewSettings:textSize 13' ~/Library/Preferences/com.apple.finder.plist

/usr/libexec/PlistBuddy -c 'Set :DesktopViewSettings:IconViewSettings:labelOnBottom true' ~/Library/Preferences/com.apple.finder.plist && \
		/usr/libexec/PlistBuddy -c 'Set :StandardViewSettings:IconViewSettings:labelOnBottom true' ~/Library/Preferences/com.apple.finder.plist

/usr/libexec/PlistBuddy -c 'Set :DesktopViewSettings:IconViewSettings:showItemInfo true' ~/Library/Preferences/com.apple.finder.plist && \
		/usr/libexec/PlistBuddy -c 'Set :StandardViewSettings:IconViewSettings:showItemInfo true' ~/Library/Preferences/com.apple.finder.plist

/usr/libexec/PlistBuddy -c 'Set :DesktopViewSettings:IconViewSettings:arrangeBy none' ~/Library/Preferences/com.apple.finder.plist && \
		/usr/libexec/PlistBuddy -c 'Set :StandardViewSettings:IconViewSettings:arrangeBy none' ~/Library/Preferences/com.apple.finder.plist

killall "Finder" &> /dev/null

# Starting with Mac OS X Mavericks preferences are cached,
# so in order for things to get properly set using `PlistBuddy`,
# the `cfprefsd` process also needs to be killed.
#
# https://github.com/alrra/dotfiles/commit/035dda057ddc6013ba21db3d2c30eeb51ba8f200

killall "cfprefsd" &> /dev/null
