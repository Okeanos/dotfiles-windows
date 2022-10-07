# SSH Setup on Windows

There are multiple, incompatible competing options for useful/working Windows SSH setups.

Windows Subsystem for Linux is not covered here and depending on the version you prefer (WSL1 or WSL2) you may run into various different problems with the options described below. You may want to take a look at [wsl-agent-bridge](https://github.com/reynoldsbd/wsl-agent-bridge) and [wsl-ssh-pageant](https://github.com/benpye/wsl-ssh-pageant) or [Sharing SSH keys between Windows and WSL 2](https://devblogs.microsoft.com/commandline/sharing-ssh-keys-between-windows-and-wsl-2/).
## KeePass with KeeAgent or KeePassXC

There are two options for FOSS based solutions around the [KeePass](https://keepass.info) password manager family available. One relies on Windows native OpenSSH fully (with its own caveats) and the other is a little more flexible but experimental and has other drawbacks such as no official browser support via the password manager.

### KeePass with KeeAgent as SSH Agent

[KeeAgent](https://github.com/dlech/KeeAgent) is incompatible with the Windows OpenSSH _agent_ because it supplies its own SSH agent. However, [KeeAgent](https://github.com/dlech/KeeAgent) is able to talk to both Windows OpenSSH and the Git Bash bundled OpenSSH version after configuring the `SSH_AUTH_SOCK`.

1. Install [KeePass](https://keepass.info) and the [KeeAgent](https://github.com/dlech/KeeAgent) plugin.
1. In KeePass > Tools > Options configure the KeeAgent plugin:
	- Enable agent for Windows OpenSSH (experimental)
	- Create a Cygwin compatible socket file with the path `%UserProfile%\.ssh\cygwin.socket`
	- Create a msysGit compatible socket file with the path `%UserProfile%\.ssh\msysgit.socket`
1. In `%UserProfile%/.exports` toggle the `SSH_AUTH_SOCK` variable (Cygwin should be fine)
1. Optionally, remove the `/c/Windows/System32/OpenSSH`-prefix from `%UserProfile%/.path` to use Windows OpenSSH in PowerShell and Git Bash bundled OpenSSH in Git Bash.

### KeePassXC as SSH Agent

Windows ships its own OpenSSH binaries starting with Windows 10. See the [official documentation](https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_keymanagement#user-key-generation) for more details.

For this to work in Git Bash as expected as well, the `$PATH` has to be prefixed with the Windows OpenSSH binaries or else Git Bash will prefer its bundled OpenSSH version that is incapable of talking to the Windows OpenSSH agent. These dotfiles supply a `$PATH` already containing the correct path modifications (see `%UserProfile%/.path`).

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

### Caveats

Windows OpenSSH has a number of unsolved (despite claims to the contrary in some cases) issues that make it unreliable bordering on unusable:

- [Early EOF errors when running git fetch over ssh](https://github.com/PowerShell/Win32-OpenSSH/issues/1322) (2022-10-08)
- [Support SSH_AUTH_SOCK Unix Domain Sockets for Windows](https://github.com/PowerShell/Win32-OpenSSH/issues/1761) (2022-10-08)
- Windows OpenSSH is a system package and not regularly updated (Windows 10 21H2 shipping OpenSSH_for_Windows_8.1p1, LibreSSL 3.0.2) (2022-10-08)
  - [Win32-OpenSSH update in Windows](https://github.com/PowerShell/Win32-OpenSSH/issues/1693)
  - it may be feasible to replace the default package via [winget](https://github.com/PowerShell/Win32-OpenSSH/issues/1896) & [OpenSSH Version Directory](https://github.com/microsoft/winget-pkgs/tree/master/manifests/m/Microsoft/OpenSSH), though

That means that while KeePassXC may be generally preferable because of its superior Browser integration (or other subjective reasons) the SSH integration on Windows is subpar and likely going to frustrate you. There is an open KeePassXC issue asking to [support MSYS2 ssh-agent sockets on Windows](https://github.com/keepassxreboot/keepassxc/issues/4681) (unresolved by 2022-10-08) that would improve the situation.

## 1Password

A commercial software alternative is [1Password](https://1password.com) that has built in SSH support starting with version 8.

Please check the [official documentation](https://developer.1password.com/docs/ssh/agent/) for details.

## PuTTY and Pageant

A long-time favorite and previous de facto solution on Windows for enabling SSH is [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/) with Pageant. KeePass with KeeAgent and KeePassXC both support Pageant and Git-Bash may also be able to consume SSH keys offered via Pageant managed in KeePass(XC). I have never used this, though.

## BitWarden

[BitWarden](https://bitwarden.com) is a freemium solution similar to 1Password but [does not](https://community.bitwarden.com/t/implement-ssh-agent-protocol/833) offer SSH Agent integration at this time (2022-10-08) on its own. There are some workarounds for that such as [Bitwarden SSH Agent](https://github.com/joaojacome/bitwarden-ssh-agent), though.

## None of the above

Really? Well, that works, too. Whatever floats your boat: Manual (or semi-manual) setup it is.

Please read what GitHub has to say on the matter in [their documentation](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/working-with-ssh-key-passphrases#auto-launching-ssh-agent-on-git-for-windows).
