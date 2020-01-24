#!/bin/bash

defaults write -g AppleKeyboardUIMode -int 3

defaults write -g ApplePressAndHoldEnabled -bool false

defaults write -g 'InitialKeyRepeat_Level_Saved' -int 10

defaults write -g KeyRepeat -int 2 \
        && defaults write NSGlobalDomain InitialKeyRepeat -int 15

defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false

defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false

defaults write -g NSAutomaticDashSubstitutionEnabled -bool false

defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false
