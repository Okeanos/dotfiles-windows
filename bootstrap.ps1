#Requires -RunAsAdministrator

Param
(
	[switch]
	[alias("f")]
	$Force
)

git pull --autostash --rebase

Function LinkFiles {
	Param (
		[Parameter(Mandatory = $true, Position = 0)]
		[alias("s","source")]
		[string] $SourceFolder,
		[Parameter(Mandatory = $true, Position = 1)]
		[alias("t","target")]
		[string] $TargetFolder
	)

	Get-ChildItem -Path "$SourceFolder" -File | ForEach-Object {
		New-Item -ItemType SymbolicLink -Path "$TargetFolder\$($_.Name -replace 'dot-','.')" -Target "$($_.FullName)" | Out-Null
	}
}

Function GetBashCompletions {
	New-Item -Path "$($ENV:UserProfile)\bash_completions.d" -ItemType directory | Out-Null
	# Docker
	Invoke-WebRequest https://raw.githubusercontent.com/docker/cli/master/contrib/completion/bash/docker.bash -OutFile "$($ENV:UserProfile)\bash_completions.d\docker-completions.bash"
	# Git Completions
	Invoke-WebRequest https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -OutFile "$($ENV:UserProfile)\bash_completions.d\git-completions.bash"
}

Function initPowershell {
	New-Item -ItemType Directory -Path "$($ENV:UserProfile)\Documents\WindowsPowerShell" -Force | Out-Null
	LinkFiles "$($PSScriptRoot)\stow\powershell\" "$($ENV:UserProfile)\Documents\WindowsPowerShell\"
}

function DoIt {
	LinkFiles "$($PSScriptRoot)\stow\curl\" "$($ENV:UserProfile)\"
	LinkFiles "$($PSScriptRoot)\stow\git\" "$($ENV:UserProfile)\"
	New-Item -Path "$($ENV:UserProfile)\.m2" -ItemType Directory -Force | Out-Null
	LinkFiles "$($PSScriptRoot)\stow\maven\.m2\" "$($ENV:UserProfile)\.m2"
	LinkFiles "$($PSScriptRoot)\stow\misc\" "$($ENV:UserProfile)\"
	New-Item -Path "$($ENV:UserProfile)\.config" -ItemType Directory -Force | Out-Null
	LinkFiles "$($PSScriptRoot)\stow\shell\" "$($ENV:UserProfile)\"
	LinkFiles "$($PSScriptRoot)\stow\shell\.config\" "$($ENV:UserProfile)\.config\"
	New-Item -Path "$($ENV:UserProfile)\.ssh\config.d" -ItemType Directory -Force | Out-Null
	LinkFiles "$($PSScriptRoot)\stow\ssh\.ssh\" "$($ENV:UserProfile)\.ssh\"
	LinkFiles "$($PSScriptRoot)\stow\ssh\.ssh\config.d\" "$($ENV:UserProfile)\.ssh\config.d\"
	New-Item -Path "$($ENV:UserProfile)\.vim\backups","$($ENV:UserProfile)\.vim\colors","$($ENV:UserProfile)\.vim\swaps","$($ENV:UserProfile)\.vim\syntax","$($ENV:UserProfile)\.vim\undo" -ItemType Directory -Force | Out-Null
	LinkFiles "$($PSScriptRoot)\stow\vim\" "$($ENV:UserProfile)\"
	LinkFiles "$($PSScriptRoot)\stow\vim\.vim\colors\" "$($ENV:UserProfile)\.vim\colors\"
	LinkFiles "$($PSScriptRoot)\stow\vim\.vim\syntax\" "$($ENV:UserProfile)\.vim\syntax\"

	GetBashCompletions
}

Function SetGitUser {
	$username = Read-Host 'Enter your Git Username'
	$email = Read-Host 'Enter your Git E-Mail address'

	@"
[user]

	name = $username
	email = $email
"@ | Out-File -Encoding "utf8NoBOM" -FilePath "$($ENV:UserProfile)\.gituser"

	$reply = Read-Host 'Use GPG Commit Signing? (y/n)'
	if ($reply -match "[yY]") {
		$signWithSSH=""
		$reply = Read-Host 'Sign with SSH? (y/n)'
		if ($reply -match "[yY]") {
			New-Item -Path "$($ENV:UserProfile)\.ssh\allowed_signers" -ItemType File | Out-Null
			$signWithSSH = @"
[gpg]

	format = ssh

[gpg "ssh"]

	allowedSignersFile = ~/.ssh/allowed_signers
"@
		}
		$signingKey = Read-Host 'Enter your GPG or SSH Signing Key ID'
		Add-Content -Path "$($ENV:UserProfile)\.gituser" -Value @"
	signingkey = $signingKey

[commit]

	gpgsign = true

$signWithSSH
"@
	}
}

if ($Force) {
	DoIt
	InitPowershell
	Write-Host "In PowerShell run the following to allow starship to work: 'Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser'"
} else {
	$reply = Read-Host 'This may overwrite existing files in your home directory. Are you sure? (y/n)'
	if ($reply -match "[yY]") {
		DoIt
	}

	$reply = Read-Host 'Add starship (https://starship.rs) configuration to PowerShell as well? (y/n)'
	if ($reply -match "[yY]") {
		InitPowershell
		Write-Host "In PowerShell run the following to allow starship to work: 'Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser'"
	}
}

If(!(Test-Path -PathType Leaf "$($ENV:UserProfile)\.gituser")) {
	SetGitUser
}
