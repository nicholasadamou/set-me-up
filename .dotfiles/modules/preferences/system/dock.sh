#!/bin/bash

# shellcheck source=/dev/null

declare current_dir && \
    current_dir="$(dirname "${BASH_SOURCE[0]}")" && \
    cd "${current_dir}" && \
    source "$HOME/set-me-up/.dotfiles/utilities/utilities.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# dock.sh - contributed by @rpavlick
# https://github.com/rpavlick/add_to_dock

function add_app_to_dock {
  # adds an application to macOS Dock
  # usage: add_app_to_dock "Application Name"
  # example add_app_to_dock "Terminal"

  app_name="${1}"
  launchservices_path="/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister"
  app_path=$(${launchservices_path} -dump | grep -o "/.*${app_name}.app" | grep -v -E "Backups|Caches|TimeMachine|Temporary|/Volumes/${app_name}" | uniq | sort | head -n1)
  if open -Ra "${app_path}"; then
      echo "$app_path added to the Dock."
      defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>${app_path}</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
  else
      echo "ERROR: $1 not found."
  fi
}

function add_folder_to_dock {
  # adds a folder to macOS Dock
  # usage: add_folder_to_dock "Folder Path" -s n -d n -v n
  # example: add_folder_to_dock "~/Downloads" -d 0 -s 2 -v 1
  # key:
  # -s or --sortby
  # 1 -> Name
  # 2 -> Date Added
  # 3 -> Date Modified
  # 4 -> Date Created
  # 5 -> Kind
  # -d or --displayas
  # 0 -> Stack
  # 1 -> Folder
  # -v or --viewcontentas
  # 0 -> Automatic
  # 1 -> Fan
  # 2 -> Grid
  # 3 -> List

  folder_path="${1}"
  sortby="1"
  displayas="0"
  viewcontentas="0"
  while [[ "$#" -gt 0 ]]
  do
      case $1 in
          -s|--sortby)
          if [[ $2 =~ ^[1-5]$ ]]; then
              sortby="${2}"
          fi
          ;;
          -d|--displayas)
          if [[ $2 =~ ^[0-1]$ ]]; then
              displayas="${2}"
          fi
          ;;
          -v|--viewcontentas)
          if [[ $2 =~ ^[0-3]$ ]]; then
              viewcontentas="${2}"
          fi
          ;;
      esac
      shift
  done

  if [ -d "$folder_path" ]; then
      echo "$folder_path added to the Dock."
      defaults write com.apple.dock persistent-others -array-add "<dict>
              <key>tile-data</key> <dict>
                  <key>arrangement</key> <integer>${sortby}</integer>
                  <key>displayas</key> <integer>${displayas}</integer>
                  <key>file-data</key> <dict>
                      <key>_CFURLString</key> <string>file://${folder_path}</string>
                      <key>_CFURLStringType</key> <integer>15</integer>
                  </dict>
                  <key>file-type</key> <integer>2</integer>
                  <key>showas</key> <integer>${viewcontentas}</integer>
              </dict>
              <key>tile-type</key> <string>directory-tile</string>
          </dict>"
  else
      echo "ERROR: $folder_path not found."
  fi
}

function add_spacer_to_dock {
  # adds an empty space to macOS Dock

  defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="small-spacer-tile";}'
}

function clear_dock {
  # removes all persistent icons from macOS Dock

  defaults write com.apple.dock persistent-apps -array
}

function reset_dock {
  # reset macOS Dock to default settings

  defaults write com.apple.dock; killall Dock
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Dock\n\n"

execute "defaults write com.apple.dock autohide -bool true" \
    "Automatically hide/show the Dock"

execute "defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true" \
    "Enable spring loading for all Dock items"

execute "defaults write com.apple.dock expose-group-by-app -bool false" \
    "Do not group windows by application in Mission Control"

execute "defaults write com.apple.dock mineffect -string 'scale'" \
    "Change minimize/maximize window effect"

execute "defaults write com.apple.dock minimize-to-application -bool true" \
    "Reduce clutter by minimizing windows into their application icons"

execute "defaults write com.apple.dock mru-spaces -bool false" \
    "Do not automatically rearrange spaces based on most recent use"

execute "defaults write com.apple.dock show-process-indicators -bool true" \
    "Show indicator lights for open applications"

execute "defaults write com.apple.dock showhidden -bool true" \
    "Make icons of hidden applications translucent"

execute "defaults write com.apple.dock tilesize -int 60" \
    "Set icon size"

execute "defaults write com.apple.dock pinning -string start" \
    "Adjust the Dock to the left side corner"

killall "Dock" &> /dev/null
