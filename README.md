# Okeanos’ dotfiles

![Screenshot of my shell prompt](screenshot.png)

## Installation

Set the following `User Environment Variables` in Windows:

- `HOME` : `%UserProfile%` (this will prevent Git Bash supplied tools from arbitrarily deciding on their own where `~`, i.e. `${HOME}` is)

Follow the installation instructions for:

- [Windows Terminal](https://github.com/microsoft/terminal)
- [Git Bash](https://git-scm.com)
	- **Select Components**
		- Uncheck the box for the Windows Explorer Integration
		- Check the box for the Windows Terminal Fragment
	- When prompted use the Windows Secure Channel library instead of the bundled certficates (allows using the Windows certificate store for system-wide same behavior when it comes to self-signed certificates)
	- When prompted select "checkout as-is, commit as-is" (less magic and tools can be correctly configured to use Unix style line endings nowadays)
- A KeePass, either:
	- [KeePass](https://keepass.info)
		- [KeeAgent](https://github.com/dlech/KeeAgent) for SSH support
	- [KeePassXC](https://keepass.info) (built in SSH, different from KeeAgent)
		- [Chrome/Chromium Extension](https://chrome.google.com/webstore/detail/keepassxc-browser/oboonakemofpalcgghocfoadofidjkkk)
		- [Firefox Extension](https://addons.mozilla.org/en-US/firefox/addon/keepassxc-browser/)

Once you installed all of this and configured the software to your liking you can now clone the repository wherever you want (I like to keep it in `%UserProfile%/Workspace/dotfiles`). Afterwards you can run the bootstrapper from your Git Bash as described below.

### KeePass with KeeAgent or KeePassXC

There are two options here. One relies on Windows OpenSSH fully and the other is a little more flexible but experimental and has other drawbacks such as no official browser support.

#### KeePass with KeeAgent as SSH Agent

1. Install KeePass and the KeeAgent plugin.
1. In KeePass > Tools > Options configure the KeeAgent plugin:
	- Enable agent for Windows OpenSSH (experimental)
	- Create a Cygwin compatible socket file with the path `%UserProfile%\.ssh\cygwin.socket`
	- Create a msysGit compatible socket file with the path `%UserProfile%\.ssh\msysgit.socket`
1. In `%UserProfile%/.exports` toggle the `SSH_AUTH_SOCK` variable (Cygwin should be fine)
1. Optionally, remove the `/c/Windows/System32/OpenSSH`-prefix from `%UserProfile%/.path` to use Windows OpenSSH in PowerShell and Git Bash bundled OpenSSH in Git Bash.

KeeAgent is incompatible with the Windows OpenSSH _agent_ because it supplies its own SSH agent. However, KeeAgent is able to talk to both Windows OpenSSH and the Git Bash bundled OpenSSH version after configuring the `SSH_AUTH_SOCK`.

#### KeePassXC as SSH Agent

Windows ships its own OpenSSH binaries starting with Windows 10. See the [official documentation](https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_keymanagement#user-key-generation) for more details.

The Windows OpenSSH client makes using [KeePassXC](https://keepassxc.org) to manage SSH keys on Windows within the Git Bash possible.
Enable the OpenSSH Agent via the Windows Services management interface by setting the `OpenSSH Authentication Agent` to `automatic` and starting it or alternatively via a PowerShell prompt with administrative permissions:

```powershell
# By default the ssh-agent service is disabled. Allow it to be manually started for the next step to work.
# Make sure you're running as an Administrator.
Get-Service ssh-agent | Set-Service -StartupType Automatic

# Start the service
Start-Service ssh-agent

# This should return a status of Running
Get-Service ssh-agent
```

Within KeePassXC the SSH support has to be enabled in the KeePassXC settings along with the option to use OpenSSH instead of Pageant.

For this to work in Git Bash as expected as well, the `$PATH` has to be prefixed with the Windows OpenSSH binaries or else Git Bash will prefer its bundled OpenSSH version that is incapable of talking to the Windows OpenSSH agent. These dotfiles supply a `$PATH` already containing the correct path modifications (see `%UserProfile%/.path`).

### The bootstrap script (`bootstrap.sh`)

The bootstrapper script will pull in the latest version and copy the files to your home folder. Run it from your Git Bash.

```bash
cd ~/Workspace/dotfiles && ./bootstrap.sh
```

To update, `cd` into your local `dotfiles` repository and then run bootstrapper again:

```bash
cd ~/Workspace/dotfiles && ./bootstrap.sh
```

#### Java Installation

The [Maven Toolchains](https://maven.apache.org/guides/mini/guide-using-toolchains.html) file assumes that the [Adoptium](https://adoptium.net) Java versions are used. Additionally, the target folder has to be modified during the installation to remove any patch and minor version information, i.e.:

`C:\Program Files\Eclipse Adoptium\jdk-17.0.1.12-hotspot` becomes `C:\Program Files\Eclipse Adoptium\jdk-17-hotspot`

This has to be done manually; see [adoptium/installer#422](https://github.com/adoptium/installer/issues/422) for details.

## Modifying the `$PATH`

Please note that the standard dotfiles already modify your Git Bash path in two ways:

- They add `/c/Windows/System32/OpenSSH` to force all programs to use the Windows supplied version of OpenSSH (to make it compatible with KeePassXC by default)
- The add `$HOME/bin` as a place where you can put binaries such as [`jq`](https://github.com/stedolan/jq) to make them easily accessible

If `~/.path` exists, it will be sourced along with the other files, before any feature testing (such as [detecting which version of `ls` is being used](https://github.com/mathiasbynens/dotfiles/blob/aff769fd75225d8f2e481185a71d5e05b76002dc/.aliases#L21-L26)) takes place.

Here’s an example `~/.path` file that adds `/usr/local/bin` to the `$PATH`:

```bash
export PATH="/usr/local/bin:$PATH"
```

## Add custom commands without creating a new fork

If `~/.extra` exists, it will be sourced along with the other files. You can use this to add a few custom commands without the need to fork this entire repository, or to add commands you don’t want to commit to a public repository.

An example of `~/.extra` by the original author of this repository looks something like this:

```bash
# Git credentials
# Not in the repository, to prevent people from accidentally committing under my name
GIT_AUTHOR_NAME="Mathias Bynens"
GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
git config --global user.name "$GIT_AUTHOR_NAME"
GIT_AUTHOR_EMAIL="mathias@mailinator.com"
GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
git config --global user.email "$GIT_AUTHOR_EMAIL"
```

You could also use `~/.extra` to override settings, functions and aliases from my dotfiles repository. It’s probably better to [fork this repository](https://github.com/Okeanos/dotfiles/fork) instead, though.

## Unlinking / Uninstalling

If you want to unlink particular dotfiles (e.g. for `vim`) you'll have to manually delete the files from your `%UserProfile%` directory because there is no [`stow`](https://www.gnu.org/software/stow/) for Windows 😕.

Carefully go through your home directory and remove any of the dotfiles (compare them to the contents of `~/Workspace/dotfiles/stow/**`) you no longer want to use. You can always re-apply them by running:

```bash
cd ~/Workspace/dotfiles && ./bootstrap.sh
```

## Original Author

| [![twitter/mathias](https://gravatar.com/avatar/24e08a9ea84deb17ae121074d0f17125?s=70)](https://twitter.com/mathias "Follow @mathias on Twitter") |
|---|
| [Mathias Bynens](https://mathiasbynens.be/) |

## Thanks to…

* @ptb and [his _macOS Setup_ repository](https://github.com/ptb/mac-setup)
* [Ben Alman](https://benalman.com/) and his [dotfiles repository](https://github.com/cowboy/dotfiles)
* [Cătălin Mariș](https://github.com/alrra) and his [dotfiles repository](https://github.com/alrra/dotfiles)
* [Gianni Chiappetta](https://butt.zone/) for sharing his [amazing collection of dotfiles](https://github.com/gf3/dotfiles)
* [Jan Moesen](https://jan.moesen.nu/) and his [ancient `.bash_profile`](https://gist.github.com/1156154) + [shiny _tilde_ repository](https://github.com/janmoesen/tilde)
* Lauri ‘Lri’ Ranta for sharing [loads of hidden preferences](https://web.archive.org/web/20161104144204/http://osxnotes.net/defaults.html)
* [Matijs Brinkhuis](https://matijs.brinkhu.is/) and his [dotfiles repository](https://github.com/matijs/dotfiles)
* [Nicolas Gallagher](https://nicolasgallagher.com/) and his [dotfiles repository](https://github.com/necolas/dotfiles)
* [Sindre Sorhus](https://sindresorhus.com/)
* [Tom Ryder](https://sanctum.geek.nz/) and his [dotfiles repository](https://sanctum.geek.nz/cgit/dotfiles.git/about)
* [Kevin Suttle](http://kevinsuttle.com/) and his [dotfiles repository](https://github.com/kevinSuttle/dotfiles) and [macOS-Defaults project](https://github.com/kevinSuttle/macOS-Defaults), which aims to provide better documentation for [`~/.macos`](https://mths.be/macos)
* [Haralan Dobrev](https://hkdobrev.com/)
* [Marcel Bischoff](https://herrbischoff.com) and his [Awesome macOS Command Line](https://git.herrbischoff.com/awesome-macos-command-line/about/)
* Anyone who [contributed a patch](https://github.com/mathiasbynens/dotfiles/contributors) or [made a helpful suggestion](https://github.com/mathiasbynens/dotfiles/issues)
