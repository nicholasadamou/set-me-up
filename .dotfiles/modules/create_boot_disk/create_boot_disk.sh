#!/bin/bash

# shellcheck source=/dev/null

declare current_dir && \
    current_dir="$(dirname "${BASH_SOURCE[0]}")" && \
    cd "${current_dir}" && \
    source "$HOME/set-me-up/.dotfiles/utilities/utilities.sh"

readonly INSTALL_APP_PATH="/Applications/Install macOS Catalina.app"
readonly MAC_APP_STORE_ID="id1466841314"
readonly DISK_IMAGE_SIZE="10G"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

	print_in_purple "  Configure a MacOS Catalina bootable disk\n\n"

	ask "Enter the '/Volumes' path to where we should makes a bootable disk: "
	readonly VOLUME_PATH=$(get_answer)

	if [[ -r "$INSTALL_APP_PATH/Contents/SharedSupport/InstallESD.dmg" ]]; then
		print_warning "Found the install app, create an install disk."

		if [[ ! -e $VOLUME_PATH ]]; then
			readonly DISK_IMAGE_NAME=$(basename "$VOLUME_PATH")

			print_warning "Creating a disk image '$DISK_IMAGE_NAME' ($DISK_IMAGE_SIZE)"

			hdiutil create -o "$DISK_IMAGE_NAME.dmg" \
				-volname "$DISK_IMAGE_NAME" -size $DISK_IMAGE_SIZE -layout SPUD -fs HFS+J && \
				hdiutil attach "$DISK_IMAGE_NAME.dmg"
		fi

		# Create an install disk.
		sudo "$INSTALL_APP_PATH/Contents/Resources/createinstallmedia" \
			--volume "$VOLUME_PATH" \
			--downloadassets \
			--noninteractive
	else
		# Open Mac App Store to download the macOS Catalina installer app.
		/usr/bin/open "macappstores://itunes.apple.com/app/$MAC_APP_STORE_ID"

		print_warning "Click Get on Mac App Store to download installer app, then run this script again to create an install disk image."
	fi

}

main
