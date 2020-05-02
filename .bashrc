# Make the KeePass SSH Agent available to shell applications
export SSH_AUTH_SOCK="$HOME/.ssh/tmp/cyglockfile"

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in "$HOME"/.{path,bash_prompt,exports,aliases,functions,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null;
done;

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null; then
	complete -o default -o nospace -F _git g;
fi;

# Ensure SSH config exists
if [[ ! -f "$HOME/.ssh/config" ]] && [[ -d "$HOME/.ssh/config.d" ]]; then
	cat "$HOME"/.ssh/config.d/* > "$HOME/.ssh/config"
fi

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
# See https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#Programmable-Completion-Builtins
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" $HOME/.ssh/config | grep -v "[?*\!]" | cut -d " " -f2- | tr ' ' '\n' | sort | uniq)" scp sftp ssh cssh cscp;

# Use complete -F (function) instead of complete -W (Word list)
#_complete_ssh_hosts () {
#	COMPREPLY=()
#	cur="${COMP_WORDS[COMP_CWORD]}"
#	comp_ssh_hosts=$(cat $HOME/.ssh/config 2>/dev/null | \
#					grep -oE "^Host" | \
#					grep -v "[?*\!]" | \
#					cut -d " " -f2- | \
#					tr ' ' '\n' | \
#					sort | \
#					uniq
#					)
#	COMPREPLY=( $(compgen -W "${comp_ssh_hosts}" -- $cur))
#	return 0
#}
#complete -F _complete_ssh_hosts scp sftp ssh cssh cscp
