#Requires -RunAsAdministrator

Param
(
	[switch]
	[alias("f")]
	$Force
)

Function UnlinkFiles {
	Param (
		[Parameter(Mandatory = $true, Position = 0)]
		[alias("s","source")]
		[string] $SourceFolder,
		[Parameter(Mandatory = $true, Position = 1)]
		[alias("t","target")]
		[string] $TargetFolder
	)

	Get-ChildItem -Path "$SourceFolder\" -File | ForEach-Object {
		$file = "$TargetFolder\$($_.Name -replace 'dot-','.')"
		if((Test-Path -Path $file) -and ((Get-Item $file).LinkType -eq 'SymbolicLink')) {
			(Get-Item $file).Delete()
		}
	}
}

Function DoIt {
	Get-ChildItem -Path "$($PSScriptRoot)\stow\" -Directory -Exclude "powershell" | ForEach-Object {
		UnlinkFiles $_.FullName "$($ENV:UserProfile)"
	}

	UnlinkFiles "$($PSScriptRoot)\stow\powershell\" "$($ENV:UserProfile)\Documents\WindowsPowerShell\"

	UnlinkFiles "$($PSScriptRoot)\stow\vim\.vim\colors\" "$($ENV:UserProfile)\.vim\colors\"
	UnlinkFiles "$($PSScriptRoot)\stow\vim\.vim\syntax\" "$($ENV:UserProfile)\.vim\syntax\"
}

if ($Force) {
	DoIt
	Write-Host "Please logout from your shell for the changes to be applied."
} else {
	$reply = Read-Host 'This will unlink the dotfiles from your home directory. No files will actually be deleted. Are you sure? (y/n)'
	if ($reply -match "[yY]") {
		DoIt
		Write-Host "Please logout from your shell for the changes to be applied."
	}
}
