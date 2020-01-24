#!/bin/bash

defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

killall "Photos" &> /dev/null
