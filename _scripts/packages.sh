#!/bin/bash

source "$HOME/dotfiles/_scripts/utils.sh"
source "$HOME/.zprofile"

failed=0
(
	title "Installing packages from Homebrew"

	/opt/homebrew/bin/brew bundle --cleanup --file "$DOTFILES/Brewfile"
) || failed=1

if [ $failed -eq 0 ]; then
	ok "All packages installed successfully!"
else
	err_exit "One or more errors occured during packages installation. Try running _scripts/packages.sh again."
fi
