# Windows Terminal with Git Bash

This repository contains files for setting up the [Windows Terminal](https://github.com/microsoft/terminal) together with the [Git Bash](https://git-scm.com).

Additionally, some Bash and Git dotfiles are supplied (`.bash_profile`, `.bashrc`, `.bash_prompt`, …) based on [Okeanos/dotfiles](https://github.com/Okeanos/dotfiles) (originally forked from [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles)).

## KeePass as SSH Agent
The Bash configuration enables using [KeePass](https://keepass.info) together with the [KeeAgent](https://lechnology.com/software/keeagent/) plugin as an SSH agent to manage SSH keys on Windows.

## Installation
Follow the installation instructions for:

- [Windows Terminal](https://github.com/microsoft/terminal)
- [Git Bash](https://git-scm.com)
- [KeePass](https://keepass.info)
- [KeeAgent](https://lechnology.com/software/keeagent/)

Afterwards:

Set the following `User Environment Variables`

- `HOME` : `C:\Users\<YOUR ACCOUNT>`
- `SSH_AUTH_SOCK` : `C:\Users\<YOUR ACCOUNT>\.ssh\tmp\cyglockfile`
- Place the `.git*` files into your home directory
- Place the `.bash*` files into your home directory
- Place the `.ssh/config.d` folder into `C:\Users\<YOUR ACCOUNT>\.ssh\config.d` along with its contents

Create a new file called `90-user` and place it into `C:\Users\<YOUR ACCOUNT>\.ssh\config.d\90-user` with the following contents:

```
Host *
	User <your account>
	IdentityFile ~/.ssh/id_rsa

```

Please make sure to have an empty new line at the end.

To add new SSH configurations just create files as necessary in the `~/.ssh/config.d` that contain the necessary configuration ending with an empty new line line each. To make sure a valid SSH configuration can be created from that the order of files is important, i.e. your custom host configurations should be alphabetically between the `00-base` and the `90-user` files. You have to delete the `~/.ssh/config` file after each change to a host and reload the `.bashrc` file to make the changes available.
