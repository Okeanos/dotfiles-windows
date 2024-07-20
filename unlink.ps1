#Requires -RunAsAdministrator

Param
(
	[switch]
	[alias("f")]
	$Force
)

Function UnlinkFiles
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
		$file = "$TargetFolder\$( $_.Name -replace 'dot-', '.' )"
		if ((Test-Path -Path $file) -and ((Get-Item $file).LinkType -eq 'SymbolicLink'))
		{
			(Get-Item $file).Delete()
		}
	}
}

Function DoIt
{
	Get-ChildItem -Path "$( $PSScriptRoot )\stow\" -Directory -Exclude "powershell","vscode" | ForEach-Object {
		Write-Host "Unlinking '$_' from '$( $ENV:UserProfile )'"
		UnlinkFiles $_.FullName "$( $ENV:UserProfile )"
	}

	Write-Host "Unlinking files"
	UnlinkFiles "$( $PSScriptRoot )\stow\maven\.m2\" "$( $ENV:UserProfile )\.m2\"
	UnlinkFiles "$( $PSScriptRoot )\stow\shell\.config\" "$( $ENV:UserProfile )\.config\"
	UnlinkFiles "$( $PSScriptRoot )\stow\shell\.config\bash\" "$( $ENV:UserProfile )\.config\bash\"
	UnlinkFiles "$( $PSScriptRoot )\stow\shell\.config\bat\" "$( $ENV:UserProfile )\.config\bat\"
	UnlinkFiles "$( $PSScriptRoot )\stow\shell\.config\bat\themes\" "$( $ENV:UserProfile )\.config\bat\themes\"
	UnlinkFiles "$( $PSScriptRoot )\stow\shell\.config\gh\" "$( $ENV:UserProfile )\.config\gh\"
	UnlinkFiles "$( $PSScriptRoot )\stow\shell\.config\tmux\" "$( $ENV:UserProfile )\.config\tmux\"
	UnlinkFiles "$( $PSScriptRoot )\stow\shell\.config\vim\" "$( $ENV:UserProfile )\.config\vim\"
	UnlinkFiles "$( $PSScriptRoot )\stow\shell\.config\vim\colors\" "$( $ENV:UserProfile )\.config\vim\colors\"
	UnlinkFiles "$( $PSScriptRoot )\stow\shell\.config\vim\syntax\" "$( $ENV:UserProfile )\.config\vim\syntax\"
	UnlinkFiles "$( $PSScriptRoot )\stow\ssh\.ssh\" "$( $ENV:UserProfile )\.ssh\"
	UnlinkFiles "$( $PSScriptRoot )\stow\ssh\.ssh\config.d\" "$( $ENV:UserProfile )\.ssh\config.d\"

	Write-Host "Unlinking 'bat' from '$( $ENV:AppData )\bat'"
	UnlinkFiles "$( $PSScriptRoot )\stow\bat\" "$( $ENV:AppData )\bat\"
	UnlinkFiles "$( $PSScriptRoot )\stow\bat\themes" "$( $ENV:AppData )\bat\themes"

	Write-Host "Unlinking 'git' from '$( $ENV:AppData )\Git'"
	UnlinkFiles "$( $PSScriptRoot )\stow\git\" "$( $ENV:AppData )\Git\"

	Write-Host "Unlinking 'powershell' from '$( $ENV:UserProfile )\Documents\WindowsPowerShell'"
	UnlinkFiles "$( $PSScriptRoot )\stow\powershell\" "$( $ENV:UserProfile )\Documents\WindowsPowerShell\"

	Write-Host "Unlinking 'vscode' from '$( $ENV:UserProfile )\Code\User'"
	UnlinkFiles "$( $PSScriptRoot )\stow\vscode\" "$( $ENV:AppData )\Code\User\"
}

if ($Force)
{
	DoIt
	Write-Host "Please logout from your shell for the changes to be applied."
}
else
{
	$reply = Read-Host 'This will unlink the dotfiles from your home directory. No files will actually be deleted. Are you sure? (y/n)'
	if ($reply -match "[yY]")
	{
		DoIt
		Write-Host "Please logout from your shell for the changes to be applied."
	}
}
