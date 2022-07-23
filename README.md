# Okeanos’ dotfiles

![Screenshot of my shell prompt](screenshot.png)

## Installation

**Warning:** If you want to give these dotfiles a try, you should first fork this repository, review the code, and remove things you don’t want or need. Don’t blindly use my settings unless you know what that entails. Use at your own risk!

### Getting Started:

Before cloning this repository make sure to do some things as preliminary setup first:

Set the following `User Environment Variables` in Windows:

- `HOME` : `%UserProfile%` (this will prevent Git Bash supplied tools from arbitrarily deciding on their own where `~`, i.e. `${HOME}` is)

Once that is done:

1. Manually download [`winget.ps1`](https://raw.githubusercontent.com/Okeanos/dotfiles-windows/main/winget.ps1) and all other `winget_*` files into the same location
1. Update the `winget.ps1` to only install software you actually want
1. Go through the `winget_*` files and modify them as necessary because they will be used to source the installation options for e.g. Git to allow unattended installation.
1. Execute `winget.ps1` from your PowerShell (may need elevated permissions)
1. You can now clone the repository wherever you want (I like to keep it in `%UserProfile%\Workspace\dotfiles`)
1. You can now `bootstrap.sh` your system

#### Installing Software (`winget.ps1`)

When setting up a new PC, you need to install some common [Windows Packages](https://github.com/microsoft/winget-cli) (after making sure that `winget` is installed, of course) for this repository to work as expected:

```powershell
.\winget.ps1
```

Some of the functionality of these dotfiles depends on packages installed by `winget.ps1`. If you don’t plan to use `winget`, you should look carefully through the `winget.ps1` and related config files and manually install any particularly important tools manually. Good examples of these are Windows Terminal and Git Bash.

##### Manual Installation Caveats

Follow the installation instructions for the following software and take note of the caveats below:

- [Windows Terminal](https://github.com/microsoft/terminal)
- [Git Bash](https://git-scm.com)
	- **Select Components**
		- Uncheck the box for the Windows Explorer Integration (it doesn't work with Windows Terminal integration)
		- Check the box for the Windows Terminal Fragment
	- When prompted use the Windows Secure Channel library instead of the bundled certficates (allows using the Windows certificate store for system-wide same behavior when it comes to self-signed certificates)
	- When prompted select "checkout as-is, commit as-is" (less magic and tools can be correctly configured to use Unix style line endings nowadays)
- A password manager, either:
	- [KeePass](https://keepass.info)
		- [KeeAgent](https://github.com/dlech/KeeAgent) for SSH support (supports Windows native OpenSSH & Git Bash bundled OpenSSH in parallel)
	- [KeePassXC](https://keepass.info) (built in SSH Agent Support, different from KeeAgent; only supports Windows native OpenSSH)
		- [Chrome/Chromium Extension](https://chrome.google.com/webstore/detail/keepassxc-browser/oboonakemofpalcgghocfoadofidjkkk)
		- [Firefox Extension](https://addons.mozilla.org/en-US/firefox/addon/keepassxc-browser/)
	- [1Password]()
		- [SSH Agent Setup](https://developer.1password.com/docs/ssh/agent/)

Once you installed all of this and configured the software to your liking you can now clone the repository wherever you want (I like to keep it in `%UserProfile%/Workspace/dotfiles`). Afterwards you can run the bootstrapper from your Git Bash as described below.

#### SSH Setup

Please read [SSH Setup](./ssh-setup.md) for details and options.

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

#### Sensible Windows defaults (`windows.ps1`)

When setting up a new PC, you may want to set some sensible Windows defaults. Please note that you really ought to read the contents of the following script very, very carefully because it changes a large number of system settings. You can apply it by invoking it like this:

```powershell
cd $HOME\Workspace\dotfiles && .\windows.ps1
```

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
* [Tim Schneider](https://github.com/timschneiderxyz) and his [dotfiles](https://github.com/timschneiderxyz/dotfiles)
* Anyone who [contributed a patch](https://github.com/mathiasbynens/dotfiles/contributors) or [made a helpful suggestion](https://github.com/mathiasbynens/dotfiles/issues)
