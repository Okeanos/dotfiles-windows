# SSH Setup on Windows

There are multiple, incompatible competing options for useful/working Windows SSH setups.

## KeePass with KeeAgent or KeePassXC

There are two options for FOSS based solutions around the KeePass password manager family available. One relies on Windows native OpenSSH fully and the other is a little more flexible but experimental and has other drawbacks such as no official browser support via the password manager.

### KeePass with KeeAgent as SSH Agent

KeeAgent is incompatible with the Windows OpenSSH _agent_ because it supplies its own SSH agent. However, KeeAgent is able to talk to both Windows OpenSSH and the Git Bash bundled OpenSSH version after configuring the `SSH_AUTH_SOCK`.

1. Install KeePass and the KeeAgent plugin.
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

## 1Password

Commercial software but has built in SSH support starting with version 8.

Please check the [official documentation](https://developer.1password.com/docs/ssh/agent/) for details.

## None of the above

Really? Well, that works, too. Whatever floats your boat: Manual (or semi-manual) setup it is.

Please read what GitHub has to say on the matter in [their documentation](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/working-with-ssh-key-passphrases#auto-launching-ssh-agent-on-git-for-windows).
