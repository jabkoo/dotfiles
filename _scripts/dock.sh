#!/bin/bash

source "$HOME/dotfiles/_scripts/utils.sh"
source "$HOME/.zprofile"

add_app_to_dock() {
    # adds an application to macOS Dock
    # usage: add_app_to_dock "Application Name"
    # example add_app_to_dock "Terminal"

    app_name="${1}"
    launchservices_path="/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister"
    app_path=$(${launchservices_path} -dump | grep -o "/\S*${app_name}.app" | grep -v -E "Backups|Caches|TimeMachine|Temporary|/Volumes/${app_name}" | uniq | sort -r | head -n1)
    if open -Ra "${app_path}"; then
        printf "%s added to the Dock.\n" "$app_path"
        defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>${app_path}</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
    else
        printf "ERROR: %s not found.\n" "$1" 1>&2
    fi
}

add_folder_to_dock() {
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
    while [[ "$#" -gt 0 ]]; do
        case $1 in
        -s | --sortby)
            if [[ $2 =~ ^[1-5]$ ]]; then
                sortby="${2}"
            fi
            ;;
        -d | --displayas)
            if [[ $2 =~ ^[0-1]$ ]]; then
                displayas="${2}"
            fi
            ;;
        -v | --viewcontentas)
            if [[ $2 =~ ^[0-3]$ ]]; then
                viewcontentas="${2}"
            fi
            ;;
        esac
        shift
    done

    if [ -d "$folder_path" ]; then
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
        printf "%s added to the Dock.\n" "$folder_path"

    else
        printf "ERROR: %s not found.\n" "$folder_path"
    fi
}

add_spacer_to_dock() {
    defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="small-spacer-tile";}'
}

clear_dock() {
    defaults write com.apple.dock persistent-apps -array
}

reset_dock() {
    defaults write com.apple.dock
    killall Dock
}

failed=0
(
	title "Configuring Dock"

	# WARNING: permanently clears existing dock
	clear_dock

	add_app_to_dock "System Settings"
	add_app_to_dock "Launchpad"
	add_app_to_dock "Visual Studio Code"
	add_app_to_dock "Alacritty"
	add_app_to_dock "Safari"
	add_app_to_dock "Brave Browser"
	add_app_to_dock "Firefox"
	add_app_to_dock "Calendar"
	add_app_to_dock "Notes"
	add_app_to_dock "Music"
	add_app_to_dock "Bitwarden"
	# add_folder_to_dock "${HOME}/obsidian/Files" -s 1 -d 0 -v 2

	killall Dock
) || failed=1

if [ $failed -eq 0 ]; then
	ok "Dock configured successfully!"
else
	err_exit "One or more errors occured during dock configuration. Try running _scripts/dock.sh again."
fi
