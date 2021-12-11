#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]:-$0}")" || exit;

git pull --autostash --rebase;

function initStarship() {
	local release, starship_zip, starship_sha;
	starship_zip="/tmp/starship.zip";
	starship_sha="${starship_zip}.sha256";
	release=$(curl -sSL -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/starship/starship/releases/latest);
	curl -sSL "$(echo "${release}" | jq -cr '.assets | map(select(.name == "starship-x86_64-pc-windows-msvc.zip")) | .[].browser_download_url')" -o "${starship_zip}"
	curl -sSL "$(echo "${release}" | jq -cr '.assets | map(select(.name == "starship-x86_64-pc-windows-msvc.zip.sha256")) | .[].browser_download_url')" -o "${starship_sha}"

	printf "%s %s" "$(cat ${starship_sha})" "${starship_zip}" | sha256sum --check
	unzip "${starship_zip}" -d "${HOME}/bin"
	export PATH="$HOME/bin:$PATH"
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
	initStarship;
	doIt;
else
	if ! starship;
	then
		read -rp "These dotfiles require starship (https://starship.rs), download and install automatically?" -n 1;
		echo ""
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			initStarship;
		fi;
	fi

	if ! starship;
	then
		echo "starship (https://starship.rs) not found on \$PATH - aborting"
		exit 1
	fi

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
