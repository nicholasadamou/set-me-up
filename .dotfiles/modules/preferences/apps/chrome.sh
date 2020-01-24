#!/bin/bash

defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool true

defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true

defaults write com.google.Chrome DisablePrintPreview -bool true

killall "Google Chrome" &> /dev/null
