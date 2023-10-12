#!/bin/bash

source "$HOME/dotfiles/_scripts/utils.sh"
source "$HOME/.zprofile"

failed=0
(
	title "Installing Homebrew"

	if ! command -v brew &> /dev/null; then
		info "Homebrew not found. Installing...\n"

		installer=$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh 2>&1)
		exitcode=$?

		if [ $exitcode -ne 0 ] ; then
		    err_exit "Failed to download Homebrew installation script. Error code $exitcode. Please try again."
		fi;

		/bin/bash -c "$installer"

		if ! grep -q -s '/opt/homebrew/bin/brew shellenv' "$HOME/.zprofile"; then
			echo $'eval "$(/opt/homebrew/bin/brew shellenv)"' >>"$HOME/.zprofile"
			eval "$(/opt/homebrew/bin/brew shellenv)"
		fi
	else
		info "Homebrew already installed. Updating...\n"
		brew update
	fi
) || failed=1

if [ $failed -eq 0 ]; then
	ok "Homebrew was installed successfully!"
else
	err_exit "One or more errors occured during Homebrew installation. Try running _scripts/homebrew.sh again."
fi
