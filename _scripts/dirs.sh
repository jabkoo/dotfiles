#!/bin/bash

source "$HOME/dotfiles/_scripts/utils.sh"
source "$HOME/.zprofile"

failed=0
(
	title "Creating custom directories"

	dirs=(
		"$HOME/Projects/selfhosted"
		"$HOME/Projects/jabkoo"
		"$HOME/.config"
		"$HOME/.ssh"
	)

	for dir in "${dirs[@]}"; do
		info "Creating a new directory at $dir"
        mkdir -p "$dir"
    done
) || failed=1

if [ $failed -eq 0 ]; then
	ok "Custom directories created successfully!"
else
	err_exit "One or more errors occured during creating custom directories. Try running _scripts/dirs.sh again."
fi
