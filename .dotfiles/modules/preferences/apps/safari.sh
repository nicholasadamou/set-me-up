#!/bin/bash

defaults write com.apple.Safari UniversalSearchEnabled -bool false \
    && defaults write com.apple.Safari SuppressSearchSuggestions -bool true

defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true

defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true && \
		defaults write com.apple.Safari IncludeDevelopMenu -bool true && \
		defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true

defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

defaults write com.apple.Safari HomePage -string 'about:blank'

defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

defaults write com.apple.Safari ShowFavoritesBar -bool false

defaults write com.apple.Safari ShowSidebarInTopSites -bool false

defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true \
    && defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true

defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

defaults write com.apple.Safari ProxiesInBookmarksBar "()"

defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

defaults write com.apple.Safari SuppressSearchSuggestions -bool true && \
        defaults write com.apple.Safari UniversalSearchEnabled -bool false

defaults write -g WebKitDeveloperExtras -bool true

defaults write com.apple.Safari AutoFillFromAddressBook -bool false \
    && defaults write com.apple.Safari AutoFillPasswords -bool false \
    && defaults write com.apple.Safari AutoFillCreditCardData -bool false \
    && defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false

defaults write com.apple.Safari WebContinuousSpellCheckingEnabled -bool true

defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false

defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true

defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false \
    && defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false

defaults write com.apple.Safari WebKitJavaEnabled -bool false \
    && defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled -bool false

defaults write com.apple.Safari WebKitPluginsEnabled -bool false \
    && defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2PluginsEnabled -bool false

defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true

killall "Safari" &> /dev/null
