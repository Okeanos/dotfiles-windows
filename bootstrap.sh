#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]:-$0}")" || exit;

git pull --autostash --rebase;

function doIt() {
	cp "stow/curl/." "${HOME}/";
	cp "stow/git/." "${HOME}/";
	mkdir -p "${HOME}/.m2";
	cp "stow/maven/." "${HOME}/";
	cp "stow/misc/." "${HOME}/";
	cp "stow/shell/." "${HOME}/";
	mkdir -p "${HOME}/.ssh/.config.d";
	cp "stow/ssh/." "${HOME}/";
	cp "stow/vim/." "${HOME}/";

	for filename in "${HOME}/dot-*"; do
		dotfile=$(echo -n "${filename}" | tr -s 'dot-' '.')
		mv -f "${HOME}/${filename}" "${HOME}/${dotfile}"
	done
	# load new config
	# shellcheck disable=SC1090
	source ~/.bash_profile;
}

function setGitUser() {
	local username, email;
	read -rp "Enter your Git Username: " username;
	read -rp "Enter your Git E-Mail address: " email;
	echo "
[user]

	name = ${username}
	email = ${email}
" > "${HOME}/.gituser"
}

if [ "$1" == "--force" ] || [ "$1" == "-f" ]; then
	doIt;
else
	read -rp "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;

if [ ! -f "${HOME}/.gituser" ]; then
	setGitUser;
fi
unset setGitUser;
