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

	Get-ChildItem -Path "$SourceFolder\" -File | ForEach-Object {
		$file = "$TargetFolder\$( $_.Name -replace 'dot-', '.' )"
		if ((Test-Path -Path $file) -and ((Get-Item $file).LinkType -eq 'SymbolicLink'))
		{
			(Get-Item $file).Delete()
		}
	}
}

Function DoIt
{
	Get-ChildItem -Path "$( $PSScriptRoot )\stow\" -Directory -Exclude "powershell" -Exclude "vscode" | ForEach-Object {
		Write-Host "Unlinking '$_.FullName' from '$( $ENV:UserProfile )'"
		UnlinkFiles $_.FullName "$( $ENV:UserProfile )"
	}

	UnlinkFiles "$( $PSScriptRoot )\stow\shell\.config\" "$( $ENV:UserProfile )\.config\"
	UnlinkFiles "$( $PSScriptRoot )\stow\shell\.config\bat\" "$( $ENV:UserProfile )\.config\bat\"
	UnlinkFiles "$( $PSScriptRoot )\stow\shell\.config\bat\themes\" "$( $ENV:UserProfile )\.config\bat\themes\"
	UnlinkFiles "$( $PSScriptRoot )\stow\ssh\.ssh\config.d\" "$( $ENV:UserProfile )\.ssh\config.d\"
	UnlinkFiles "$( $PSScriptRoot )\stow\vim\.vim\colors\" "$( $ENV:UserProfile )\.vim\colors\"
	UnlinkFiles "$( $PSScriptRoot )\stow\vim\.vim\syntax\" "$( $ENV:UserProfile )\.vim\syntax\"

	Write-Host "Unlinking 'powershell' from '$( $ENV:UserProfile )\Documents\WindowsPowerShell'"
	UnlinkFiles "$( $PSScriptRoot )\stow\powershell\" "$( $ENV:UserProfile )\Documents\WindowsPowerShell\"

	Write-Host "Unlinking 'vscode' from '$( $ENV:UserProfile )\Code\User'"
	UnlinkFiles "$( $PSScriptRoot )\stow\vscode\settings.json" "$( $ENV:AppData )\Code\User\settings.json"
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
