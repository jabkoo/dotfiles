#!/bin/bash

source "$HOME/dotfiles/_scripts/utils.sh"
source "$HOME/.zprofile"

BACKUP_DIR=$HOME/dotfiles-backup
FF_PROFILE_NAME="jabko"

ff_profile_folder=""

prepare_astronvim() {
	info "Cloning AstroNvim"

	rm -rf "$HOME/.config/nvim"
	git clone --depth 1 https://github.com/AstroNvim/AstroNvim "$HOME/.config/nvim"
}

prepare_firefox() {
	info "Setting up Firefox"

    firefox -CreateProfile $FF_PROFILE_NAME

    firefox -no-remote &

    while [ ! -f "$HOME/Library/Application Support/Firefox/installs.ini" ]; do
        sleep 1
    done

    ff_profile_folder=$(find "$HOME/Library/Application Support/Firefox/Profiles" -type d -name "*.$FF_PROFILE_NAME" -exec basename {} \;)
	ff_default_profile_folder=$(find "$HOME/Library/Application Support/Firefox/Profiles" -type d -name "*.default-release" -exec basename {} \;)
	sed -i "" "s/Default=Profiles\/$ff_default_profile_folder/Default=Profiles\/$ff_profile_folder/g" "$HOME/Library/Application Support/Firefox/profiles.ini"
    sed -i "" "s/default-release/$FF_PROFILE_NAME/g" "$HOME/Library/Application Support/Firefox/installs.ini"

    killall "firefox" 2>/dev/null || true

	cp -i "$HOME/dotfiles/firefox/org.mozilla.firefox.plist" "$HOME/Library/Preferences"
}

symlink_icloud_dirs() {
	info "Symlinking iCloud directories"

	ln -fns "$HOME/Library/Mobile Documents/iCloud~md~Obsidian/Documents/TasksVault" "$HOME/tasks"
	ln -fns "$HOME/Library/Mobile Documents/iCloud~md~Obsidian/Documents/NotesVault" "$HOME/notes"
}

backup_files() {
	info "Backing up dotfiles to $BACKUP_DIR"

    mkdir -p "$BACKUP_DIR"

    for target_name in "${symlink_targets[@]}"; do
        if [[ -f "$target_name" || -d "$target_name" ]]; then
            info "Backing up $target_name"
           	cp -Lrf "$target_name" "$BACKUP_DIR"
			rm -rf "$target_name"
        else
            warn "$target_name does not exist at this location"
        fi
    done
}

symlink_files() {
	info "Creating symlinks"

	i=0
    for target_name in "${symlink_targets[@]}"; do
		source_name=${symlink_sources[$i]}

		info "Creating symlink from $source_name to $target_name"
       	ln -fns "$source_name" "$target_name"
		chflags nouchg "$target_name"
		i=${i}+1
    done
}

failed=0
(
	title "Creating symlinks"

	prepare_firefox

	symlink_sources=(
		"$HOME/dotfiles/.gitconfig"
		"$HOME/dotfiles/.editorconfig"
		"$HOME/dotfiles/zsh/.zshrc"
		"$HOME/dotfiles/ssh/config"
		"$HOME/dotfiles/amethyst"
		"$HOME/dotfiles/tmux"
		"$HOME/dotfiles/alacritty"
		"$HOME/dotfiles/nvim/lua/user"
		"$HOME/dotfiles/asdf/.default-npm-packages"
		"$HOME/dotfiles/asdf/.default-python-packages"
		"$HOME/dotfiles/vscode/settings.json"
		"$HOME/dotfiles/firefox/user.js"
	)

	symlink_targets=(
		"$HOME/.gitconfig"
		"$HOME/.editorconfig"
		"$HOME/.zshrc"
		"$HOME/.ssh/config"
		"$HOME/.config/amethyst"
		"$HOME/.config/tmux"
		"$HOME/.config/alacritty"
		"$HOME/.config/nvim/lua/user"
		"$HOME/.config/asdf/.default-npm-packages"
		"$HOME/.config/asdf/.default-python-packages"
		"$HOME/Library/Application Support/Code/User/settings.json"
		"$HOME/Library/Application Support/Firefox/Profiles/$ff_profile_folder/user.js"
	)

	backup_files

	prepare_astronvim

	symlink_icloud_dirs
	symlink_files

) || failed=1

if [ $failed -eq 0 ]; then
	ok "All files symlinked successfully!"
else
	err_exit "One or more errors occured during symlinking files. Try running _scripts/symlink.sh again."
fi
