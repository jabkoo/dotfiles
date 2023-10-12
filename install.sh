#!/bin/bash

set -o posix

source "$HOME/dotfiles/_scripts/utils.sh"

AVAILABLE_SCRIPTS=(
	"softwareupdate"
	"homebrew"
	"packages"
	"symlink"
	"ssh"
	"asdf"
	"xcode"
	"defaults"
	"dock"
)

scripts_to_run=()

usage() {
	echo "Usage: $0 [OPTIONS]"
	echo "Options (use only one at a time):"
	echo "  -h, --help          Display this help message"
	echo "  -o, --only          Execute only specified scripts"
	echo "  -e, --except        Execute with exclusion of provided scripts"
	echo "Available scripts:"
	echo "  softwareupdate      Runs MacOS software update and installs Rosetta"
	echo "  homebrew            Installs Homebrew package manager"
	echo "  packages            Downloads Homebrew packages defined in Brewfile"
	echo "  symlink             Symlinks dotfiles; List of files is defined in the script itself"
	echo "  ssh                 Generates a new SSH key"
	echo "  asdf                Installs programming languages with asdf version manager"
	echo "  xcode               Builds XCode"
	echo "  defaults            Configures various default MacOS settings"
	echo "  dock                Customises MacOS dock"
}

check_and_extract_arguments() {
	flag="$1"
	shift;
	selected_scripts=()

	for element in "$@"; do
		if [[ ! " ${AVAILABLE_SCRIPTS[*]} " =~ $element ]]; then
			err "Invalid argument: $element" >&2
			usage
			exit 1
		else
			selected_scripts+=("$element")
		fi
	done

	if [ "$flag" == "only" ]; then
		for script in "${AVAILABLE_SCRIPTS[@]}"; do
			for selected in "${selected_scripts[@]}"; do
				if [[ "$script" == "$selected" ]]; then
					scripts_to_run+=("$script")
				fi
			done
		done
	fi

	if [ "$flag" == "except" ]; then
		scripts_to_run=("${AVAILABLE_SCRIPTS[@]}")

		for del in "${selected_scripts[@]}"; do
			for i in "${!scripts_to_run[@]}"; do
				if [[ "${scripts_to_run[i]}" == "$del" ]]; then
					unset 'scripts_to_run[i]'
				fi
			done
		done
	fi
}

install() {
	if [ $# -gt 0 ]; then
		case $1 in
		-h | --help)
			usage
			exit 0
			;;
		-e | --except*)
			shift
			check_and_extract_arguments "except" "$@"
			run_scripts
			exit 0
			;;
		-o | --only*)
			shift
			check_and_extract_arguments "only" "$@"
			run_scripts
			exit 0
			;;
		*)
			echo "Invalid option: $1" >&2
			usage
			exit 1
			;;
		esac
  	fi

	scripts_to_run=("${AVAILABLE_SCRIPTS[@]}")
	run_scripts
}

run_scripts() {
	for script in "${scripts_to_run[@]}"; do
    	. "$HOME/dotfiles/_scripts/$script.sh"
	done
}

while true; do
	osascript -e 'tell application "System Events" to keystroke "."'
	if [ $? -eq 0 ]; then
		 break
	fi
	sleep 1
done

install "$@"
