#!/bin/bash

source "$HOME/dotfiles/_scripts/utils.sh"
source "$HOME/.zprofile"

failed=0
(
	title "Generating SSH key"

	email=$(git config user.email)

	if [ -z "$email" ]
	then
		warn ".gitconfig file was not found or it was missing user.email variable. Skipping SSH key generation..."
		exit 1
	fi

	ssh-keygen -t ed25519 -C "${email}" -f "$HOME/.ssh/id_ed25519"
	cp ./ssh/config "$HOME/.ssh/config"
	eval "$(ssh-agent -s)"
	ssh-add --apple-use-keychain "$HOME/.ssh/id_ed25519"

	pbcopy <"$HOME/.ssh/id_ed25519.pub"
) || failed=1

if [ $failed -eq 0 ]; then
	ok "SSH key generated successfully!"
else
	err_exit "One or more errors occured during generating SSH key. Try running _scripts/ssh.sh again."
fi
