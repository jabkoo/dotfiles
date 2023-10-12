#!/bin/bash

source "$HOME/dotfiles/_scripts/utils.sh"
source "$HOME/.zprofile"

failed=0
(
	title "Updating MacOS software"

	softwareupdate --install --all --force --agree-to-license

	if ! pkgutil --pkg-info=com.apple.pkg.RosettaUpdateAuto > /dev/null 2>&1
  	then
	    info "Installing Rosetta"
		softwareupdate --install-rosetta --agree-to-license
	else
		info "Rosetta is already installed"
	fi
) || failed=1

if [ $failed -eq 0 ]; then
	ok "Finished software update successfully"
else
	err_exit "One or more errors occured during software update. Try running _scripts/softwareupdate.sh again."
fi
