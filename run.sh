#!/bin/bash

if command "git" >/dev/null 2>&1; then
	git clone https://github.com/jabkoo/dotfiles ~/dotfiles
	chmod +x ~/dotfiles
 	touch .zprofile
	cd ~/dotfiles || exit
	./install.sh "$@"
else
	curl -LO https://github.com/jabkoo/dotfiles/archive/main.zip
	unzip main.zip
	rm -rf main.zip
	mv dotfiles-main ~/dotfiles
	chmod +x ~/dotfiles
 	touch .zprofile
	cd ~/dotfiles || exit
	./install.sh "$@"
fi
