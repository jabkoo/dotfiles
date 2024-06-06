# dotfiles

A space for my MacOS dotfiles. It also includes few scripts to automate most of my setup from scratch.

Tested only on my MacBook Air (M1, 2020) with Sonoma 14.5 (previously tested with Sonoma 14.0, and Ventura 13.2 - 13.5.1).

- **WM**: Amethyst
- **Editor**: Neovim, sometimes VS Code
- **Terminal**: Alacritty using zsh /w Antigen, Powerlevel10k, tmux
- **Color Theme**: Catppuccin Latte


![Screenshot 2023-10-12 at 16 53 33](https://github.com/jabkoo/dotfiles/assets/83245748/ac233185-d2fc-4321-a125-db3fd40978bf)


## Installation

**Prerequisites**: Give a terminal application additional permissions:
- `System Settings -> Privacy & Security -> Full Disk Access`
- `System Settings -> Privacy & Security -> Accessibility`
- `System Settings -> Privacy & Security -> Automation -> System Events`
	- Can be done by running, e.g. `osascript -e 'tell application "System Events" to keystroke "."'`, but `install.sh` script already handles that 

Use `run.sh` script to copy the repository and run full installation:

`/bin/bash -c "$(curl -L https://raw.githubusercontent.com/jabkoo/dotfiles/main/run.sh)"`

or use `install.sh` to run the installation if the repository was already cloned.

Both scripts accept following options:
- `-h, --help`: Displays help message
- `-o, --only`: Executes only specified scripts
- `-e, --except`: Executes with exclusion of specified scripts

Available scripts:
- `dirs`: Creates necessary directories
- `softwareupdate`: Runs MacOS software update and installs Rosetta
- `homebrew`: Installs Homebrew package manager
- `packages`: Downloads Homebrew packages defined in Brewfile
- `symlink`: Symlinks dotfiles; List of files is defined in the script itself
- `ssh`: Generates a new SSH key
- `asdf`: Installs programming languages with asdf version manager
- `xcode`: Builds XCode
- `defaults`: Configures various default MacOS settings
- `dock`: Customises MacOS dock
