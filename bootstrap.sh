#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]:-$0}")" || exit;

git pull --autostash --rebase;

function initPowerShell() {
	mkdir -p "${HOME}/Documents/PowerShell"
	cp -rf "stow/powershell/." "${HOME}/Documents/WindowsPowerShell/"
}

function doIt() {
	cp -r "stow/curl/." "${HOME}/";
	cp -r "stow/git/." "${HOME}/";
	mkdir -p "${HOME}/.m2";
	cp -r "stow/maven/." "${HOME}/";
	cp -r "stow/misc/." "${HOME}/";
	mkdir -p "${HOME}/.config";
	cp -r "stow/shell/." "${HOME}/";
	mkdir -p "${HOME}/.ssh/.config.d";
	cp -r "stow/ssh/." "${HOME}/";
	cp -r "stow/vim/." "${HOME}/";

	for filename in "${HOME}/dot-"*; do
		mv -f "${filename}" "${filename/dot-/\.}"
	done
	# load new config
	# shellcheck disable=SC1090
	source ~/.bash_profile;
}

function setGitUser() {
	local username, email, signingKey, signWithSSH;
	read -rp "Enter your Git Username: " username;
	read -rp "Enter your Git E-Mail address: " email;
	echo "
[user]

	name = ${username}
	email = ${email}
" > "${HOME}/.gituser"

	read -rp "Use GPG Commit Signing? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		signWithSSH="";
		read -rp "Sign with SSH: " -n 1;
		echo "";
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			touch "${HOME}/.ssh/allowed_signers";
			signWithSSH="
[gpg]

	format = ssh

[gpg \"ssh\"]
	allowedSignersFile = ~/.ssh/allowed_signers";
		fi
		read -rp "Enter your GPG or SSH Signing Key ID: " signingKey;
		echo "
	signingkey = ${signingKey}

[commit]
	gpgsign = true

${signWithSSH}
" >> "${HOME}/.gituser"
	fi;
}

if [ "$1" == "--force" ] || [ "$1" == "-f" ]; then
	doIt;
	initPowerShell;
	echo "In PowerShell run the following to allow starship to work: 'Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser'"
else
	read -rp "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;

	read -rp "Add starship (https://starship.rs) configuration to PowerShell as well? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		initPowerShell;
		echo "In PowerShell run the following to allow starship to work: 'Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser'"
	fi;
fi;
unset doIt;

if [ ! -f "${HOME}/.gituser" ]; then
	setGitUser;
fi
unset setGitUser;
