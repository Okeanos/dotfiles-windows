#Requires -RunAsAdministrator

# https://github.com/microsoft/winget-pkgs

# TODO improve/simplify winget invocations
winget install --id Git.Git --override "/VERYSILENT /NOCANCEL /LOADINF=$PSScriptRoot\winget_git.ini"
winget install --id Google.Chrome --override "/quiet"
# https://docs.docker.com/desktop/windows/install/#install-from-the-command-line
winget install --id Docker.DockerDesktop
# https://support.mozilla.org/en-US/kb/deploy-firefox-msi-installers
winget install --id Mozilla.Firefox --override "OPTIONAL_EXTENSIONS=false /quiet"
winget install --id Microsoft.VisualStudioCode --override "--silent"

foreach ($package in @(
	7zip.7zip
	Adobe.Acrobat.Reader.64-bit
	#AgileBits.1Password
	#ahmetb.kubectx
	#ahmetb.kubens
	#Apache.Maven
	Atlassian.Sourcetree
	#DominikReichl.KeePass
	EclipseAdoptium.Temurin.17
	Golang.Go
	Jetbrains.Toolbox
	#johanhaleby.kubetail
	KeePassXCTeam.KeePassXC
	Kubernetes.kubectl
	Microsoft.WindowsTerminal
	MikeFarah.yq
	#Notepad++.Notepad++
	OpenJS.NodeJS
	Starship.Starship
	stedolan.jq
	Yarn.Yarn
	)
) {
	winget install --id $package
}
