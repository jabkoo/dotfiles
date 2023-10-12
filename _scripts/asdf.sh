#!/bin/bash

source "$HOME/dotfiles/_scripts/utils.sh"
source "$HOME/.zprofile"

export ASDF_PYTHON_DEFAULT_PACKAGES_FILE="$HOME/.config/asdf/.default-python-packages"
export ASDF_NPM_DEFAULT_PACKAGES_FILE="$HOME/.config/asdf/.default-npm-packages"

failed=0
(
	title "Installing language runtimes with asdf"

	asdf plugin add golang https://github.com/asdf-community/asdf-golang.git
	asdf plugin add python https://github.com/asdf-community/asdf-python.git
	asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git

	asdf install golang latest
	asdf install python latest
	asdf install nodejs lts

	asdf global golang latest
	asdf global python latest
	asdf global nodejs lts

	asdf reshim golang
	asdf reshim python
	asdf reshim nodejs
) || failed=1

if [ $failed -eq 0 ]; then
	ok "Language runtimes installation finished successfully!"
else
	err_exit "One or more errors occured during language runtime installation with asdf. Try running _scripts/asdf.sh again."
fi
