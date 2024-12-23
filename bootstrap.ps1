﻿#Requires -RunAsAdministrator

Param
(
	[switch]
	[alias("f")]
	$Force
)

git pull --autostash --rebase

Function LinkFiles
{
	Param (
		[Parameter(Mandatory = $true, Position = 0)]
		[alias("s", "source")]
		[string] $SourceFolder,
		[Parameter(Mandatory = $true, Position = 1)]
		[alias("t", "target")]
		[string] $TargetFolder
	)

	Get-ChildItem -Path "$SourceFolder" -File | ForEach-Object {
		$TargetPath = "$TargetFolder$( $_.Name -replace 'dot-', '.' )"
		$StowPath = "$( $_.FullName )"
		If (!(Test-Path -PathType Leaf "$TargetPath")) {
			New-Item -ItemType SymbolicLink -Path "$TargetPath" -Target "$StowPath" | Out-Null
		} else {
			Write-Warning "Cannot link to '$TargetPath' from '$StowPath' because it already exists as a file"
		}
	}
}

Function InitPowershell
{
	New-Item -ItemType Directory -Path "$( $ENV:UserProfile )\Documents\WindowsPowerShell" -Force | Out-Null
	LinkFiles "$( $PSScriptRoot )\stow\powershell\" "$( $ENV:UserProfile )\Documents\WindowsPowerShell\"
	Write-Host "In PowerShell run the following to allow starship to work: 'Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser'"
}


function InitApps() {
	Write-Host "Rebuild bat cache for custom theme support"
	# Requires absolute path because of https://github.com/microsoft/winget-cli/issues/549
	C:\"Program Files"\WinGet\Links\bat.exe cache --build
}

Function DoIt
{
	Write-Host "Creating expected XDG target directories"
	New-Item -Path "$( $ENV:UserProfile )\.cache",
		"$( $ENV:UserProfile )\.cache\bash",
		"$( $ENV:UserProfile )\.cache\vim\swap" `
		-ItemType Directory -Force | Out-Null
	New-Item -Path "$( $ENV:UserProfile )\.config",
		"$( $ENV:UserProfile )\.config\bash",
		"$( $ENV:UserProfile )\.config\gh",
		"$( $ENV:UserProfile )\.config\tmux",
		"$( $ENV:UserProfile )\.config\vim\autoload",
		"$( $ENV:UserProfile )\.config\vim\colors",
		"$( $ENV:UserProfile )\.config\vim\syntax" `
		-ItemType Directory -Force | Out-Null
	New-Item -Path "$( $ENV:UserProfile )\.local",
		"$( $ENV:UserProfile )\.local\share",
		"$( $ENV:UserProfile )\.local\state" `
		-ItemType Directory -Force | Out-Null
	New-Item -Path "$( $ENV:UserProfile )\.local\share\bash-completion",
		"$( $ENV:UserProfile )\.local\share\bash-completion\completions" `
		-ItemType Directory -Force | Out-Null
	New-Item -Path "$( $ENV:UserProfile )\.local\share\node",
		"$( $ENV:UserProfile )\.local\share\vim\bundle",
		"$( $ENV:UserProfile )\.local\share\vim\plugged" `
		-ItemType Directory -Force | Out-Null
	New-Item -Path "$( $ENV:UserProfile )\.local\state\vim",
		"$( $ENV:UserProfile )\.local\state\vim\backup",
		"$( $ENV:UserProfile )\.local\state\vim\undo" `
		-ItemType Directory -Force | Out-Null

	Write-Host "Creating non-XDG target directories"
	New-Item -Path "$( $ENV:AppData )\bat",
		"$( $ENV:AppData )\bat\themes" `
		-ItemType Directory -Force | Out-Null
	New-Item -Path "$( $ENV:AppData )\Git" -ItemType Directory -Force | Out-Null
	New-Item -Path "$( $ENV:AppData )\Code\User" -ItemType Directory -Force | Out-Null
	# prevents accidentally syncing sensitive files later on if/when parts of this are put into the dotfiles
	New-Item -Path "$( $ENV:UserProfile )\.gradle" -ItemType Directory -Force | Out-Null
	# prevents accidentally syncing sensitive files later on if/when parts of this are put into the dotfiles
	New-Item -Path "$( $ENV:UserProfile )\.m2" -ItemType Directory -Force | Out-Null
	# prevents accidentally syncing sensitive files later on if/when parts of this are put into the dotfiles
	New-Item -Path "$( $ENV:UserProfile )\.ssh",
		"$( $ENV:UserProfile )\.ssh\config.d" `
		-ItemType Directory -Force | Out-Null

	Write-Host "Linking files"
	LinkFiles "$( $PSScriptRoot )\stow\bat\" "$( $ENV:AppData )\bat\"
	LinkFiles "$( $PSScriptRoot )\stow\bat\themes\" "$( $ENV:AppData )\bat\themes\"
	LinkFiles "$( $PSScriptRoot )\stow\git\" "$( $ENV:AppData )\Git\"
	LinkFiles "$( $PSScriptRoot )\stow\maven\.m2\" "$( $ENV:UserProfile )\.m2\"
	LinkFiles "$( $PSScriptRoot )\stow\misc\" "$( $ENV:UserProfile )\"
	LinkFiles "$( $PSScriptRoot )\stow\shell\" "$( $ENV:UserProfile )\"
	LinkFiles "$( $PSScriptRoot )\stow\shell\.config\" "$( $ENV:UserProfile )\.config\"
	LinkFiles "$( $PSScriptRoot )\stow\shell\.config\bash\" "$( $ENV:UserProfile )\.config\bash\"
	LinkFiles "$( $PSScriptRoot )\stow\shell\.config\gh\" "$( $ENV:UserProfile )\.config\gh\"
	LinkFiles "$( $PSScriptRoot )\stow\shell\.config\tmux\" "$( $ENV:UserProfile )\.config\tmux\"
	LinkFiles "$( $PSScriptRoot )\stow\shell\.config\vim\" "$( $ENV:UserProfile )\.config\vim\"
	LinkFiles "$( $PSScriptRoot )\stow\shell\.config\vim\colors\" "$( $ENV:UserProfile )\.config\vim\colors\"
	LinkFiles "$( $PSScriptRoot )\stow\shell\.config\vim\syntax\" "$( $ENV:UserProfile )\.config\vim\syntax\"
	LinkFiles "$( $PSScriptRoot )\stow\ssh\.ssh\" "$( $ENV:UserProfile )\.ssh\"
	LinkFiles "$( $PSScriptRoot )\stow\ssh\.ssh\config.d\" "$( $ENV:UserProfile )\.ssh\config.d\"
	LinkFiles "$( $PSScriptRoot )\stow\vscode\" "$( $ENV:AppData )\Code\User\"
}

Function SetGitUser
{
	Write-Host "Creating Git user config"

	$username = Read-Host 'Enter your Git Username'
	$email = Read-Host 'Enter your Git E-Mail address'

	@"
[user]

	name = $username
	email = $email
"@ | Out-File -Encoding "utf8" -FilePath "$( $ENV:UserProfile )\.config\git\user"

	$reply = Read-Host 'Use GPG Commit Signing? (y/n)'
	if ($reply -match "[yY]")
	{
		$signWithSSH = ""
		$reply = Read-Host 'Sign with SSH? (y/n)'
		if ($reply -match "[yY]")
		{
			New-Item -Path "$( $ENV:UserProfile )\.ssh\allowed_signers" -ItemType File | Out-Null
			$signWithSSH = @"
[gpg]

	format = ssh

[gpg "ssh"]

	allowedSignersFile = ~/.ssh/allowed_signers
"@
		}
		$signingKey = Read-Host 'Enter your GPG or SSH Signing Key ID'
		Add-Content -Path "$( $ENV:UserProfile )\.config\git\user" -Value @"
	signingkey = $signingKey

[commit]

	gpgsign = true

$signWithSSH
"@
	}
}

if ($Force)
{
	DoIt
	InitPowershell
	InitApps
}
else
{
	$reply = Read-Host 'This may overwrite existing files in your home directory. Are you sure? (y/n)'
	if ($reply -match "[yY]")
	{
		DoIt
	}

	$reply = Read-Host 'Add starship (https://starship.rs) configuration to PowerShell as well? (y/n)'
	if ($reply -match "[yY]")
	{
		Write-Host "Adding starship to Powershell"
		InitPowershell
		InitApps
	}
}

If (!(Test-Path -PathType Leaf "$( $ENV:UserProfile )\.config\git\user"))
{
	SetGitUser
}

Write-Host "Done"
