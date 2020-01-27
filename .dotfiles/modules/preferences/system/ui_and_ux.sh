#!/bin/bash

declare current_dir && \
    current_dir="$PWD" && \
    cd "${current_dir}" || exit

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

declare -r DESKTOP_WALLPAPER_PATH="${current_dir}/wallpaper/winter.jpeg"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if brew info wallpaper &>/dev/null; then
	wallpaper set "$DESKTOP_WALLPAPER_PATH"
fi

defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true && \
		defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

sudo defaults write /Library/Preferences/com.apple.loginwindow showInputMenu -bool true

defaults write com.apple.CrashReporter UseUNC 1

defaults write com.apple.LaunchServices LSQuarantine -bool false

defaults write com.apple.print.PrintingPrefs 'Quit When Finished' -bool true

defaults write com.apple.screencapture disable-shadow -bool true

defaults write com.apple.screencapture location -string "$HOME/Desktop"

defaults write com.apple.screencapture type -string 'png'

defaults write com.apple.screensaver askForPassword -int 1 && \
		defaults write com.apple.screensaver askForPasswordDelay -int 0

defaults write -g AppleFontSmoothing -int 2

defaults write -g AppleShowScrollBars -string 'Always'

defaults write -g NSDisableAutomaticTermination -bool true

defaults write -g NSNavPanelExpandedStateForSaveMode -bool true

defaults write -g NSTableViewDefaultSizeMode -int 2

defaults write -g NSUseAnimatedFocusRing -bool false

defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

defaults write -g PMPrintingExpandedStateForPrint -bool true

sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string 'macOS' && \
		sudo scutil --set ComputerName 'macOS' && \
		sudo scutil --set HostName 'macOS' && \
		sudo scutil --set LocalHostName 'macOS'

sudo systemsetup -setrestartfreeze on

for domain in ~/Library/Preferences/ByHost/com.apple.systemuiserver.*; do
            sudo defaults write "${domain}" dontAutoLoad -array \
                '/System/Library/CoreServices/Menu Extras/TimeMachine.menu' \
                '/System/Library/CoreServices/Menu Extras/Volume.menu'
		done \
            && sudo defaults write com.apple.systemuiserver menuExtras -array \
                '/System/Library/CoreServices/Menu Extras/Bluetooth.menu' \
                '/System/Library/CoreServices/Menu Extras/AirPort.menu' \
                '/System/Library/CoreServices/Menu Extras/Battery.menu' \
                '/System/Library/CoreServices/Menu Extras/Clock.menu'

killall "SystemUIServer" &> /dev/null
