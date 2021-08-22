# Windows Terminal with Git Bash

This repository contains files for setting up the [Windows Terminal](https://github.com/microsoft/terminal) together with the [Git Bash](https://git-scm.com).

Additionally, some Bash and Git dotfiles are supplied (`.bash_profile`, `.bashrc`, `.bash_prompt`, …) based on [Okeanos/dotfiles](https://github.com/Okeanos/dotfiles) (originally forked from [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles)).

## KeePassXC as SSH Agent
The Windows enabled OpenSSH client makes using [KeePassXC](https://keepassxc.org) as an SSH agent to manage SSH keys on Windows within the Git Bash possible.
Enable the OpenSSH Agent via the Windows Services management interface by setting the `OpenSSH Authentication Agent` to `automatic` and starting it.

Within KeePassXC the SSH support has to be enabled in the KeePassXC settings along with the option to use OpenSSH instead of Pageant.

## Environment:

Set the following `User Environment Variables` in Windows:

- `HOME` : `%UserProfile%` (this will prevent Git Bash supplied tools from arbitrarily deciding on their own where `~/` is)

## Installation
Follow the installation instructions for:

- [Windows Terminal](https://github.com/microsoft/terminal)
- [Git Bash](https://git-scm.com)
  - Check the box for the Windows Terminal Fragment
  - When prompted, select externally supplied SSH
  - When prompted use the Windows Secure Channel library instead of the bundled certficates
- [KeePassXC](https://keepass.info)
  - [Chrome/Chromium Extension](https://chrome.google.com/webstore/detail/keepassxc-browser/oboonakemofpalcgghocfoadofidjkkk)
  - [Firefox Extension](https://addons.mozilla.org/en-US/firefox/addon/keepassxc-browser/)

In addition to that individual SSH keys within the KeePass vault have to be enabled and/or loaded manually into the SSH agent.

- Place the `.git*` files into your home directory
- Place the `.bash*` files into your home directory
- Place the `config.d` folder contents into `%UserProfile%\.ssh\config.d` along with its contents

Create a new file called `90-user` and place it into `%UserProfile%\.ssh\config.d\90-user` with the following contents:

```
Host *
	User <your account>
	IdentityFile ~/.ssh/id_rsa

```

Please make sure to have an empty new line at the end.

To add new SSH configurations just create files as necessary in the `~/.ssh/config.d` that contain the necessary configuration ending with an empty new line line each. To make sure a valid SSH configuration can be created from that the order of files is important, i.e. your custom host configurations should be alphabetically between the `00-base` and the `90-user` files. You have to delete the `~/.ssh/config` file after each change to a host and reload the `.bashrc` file to make the changes available.
