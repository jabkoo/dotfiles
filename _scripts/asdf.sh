#!/bin/bash

source "$HOME/dotfiles/_scripts/utils.sh"
source "$HOME/.zprofile"

export ASDF_PYTHON_DEFAULT_PACKAGES_FILE="$HOME/.config/asdf/.default-python-packages"
export ASDF_NPM_DEFAULT_PACKAGES_FILE="$HOME/.config/asdf/.default-npm-packages"

failed=0
(
	title "Installing language runtimes with asdf"

	asdf plugin add nodejs
	asdf plugin add python
	asdf plugin add golang

	asdf install
	asdf reshim
) || failed=1

if [ $failed -eq 0 ]; then
	ok "Language runtimes installation finished successfully!"
else
	err_exit "One or more errors occured during language runtime installation with asdf. Try running _scripts/asdf.sh again."
fi
