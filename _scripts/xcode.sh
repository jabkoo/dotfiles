#!/bin/bash

source "$HOME/dotfiles/_scripts/utils.sh"
source "$HOME/.zprofile"

failed=0
(
	title "Building XCode"

	if ! xcode-select --print-path &>/dev/null; then
		xcode-select --install &>/dev/null

		until xcode-select --print-path &>/dev/null; do
			sleep 5
		done
	fi

	sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer
	sudo xcodebuild -license accept
) || failed=1

if [ $failed -eq 0 ]; then
	ok "XCode built successfully!"
else
	err_exit "One or more errors occured during XCode build. Try running _scripts/xcode.sh again."
fi
