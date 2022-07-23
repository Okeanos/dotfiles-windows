#Requires -RunAsAdministrator

# https://github.com/microsoft/winget-pkgs

# TODO improve/simplify winget invocations
winget install --id Git.Git --override "/VERYSILENT /NOCANCEL /LOADINF=$pwd\winget_git.ini"
winget install --id Google.Chrome --override "/quiet"
# https://docs.docker.com/desktop/windows/install/#install-from-the-command-line
winget install --id Docker.DockerDesktop
# https://support.mozilla.org/en-US/kb/deploy-firefox-msi-installers
winget install --id Mozilla.Firefox --override "OPTIONAL_EXTENSIONS=false /quiet"
winget install --id Microsoft.VisualStudioCode --override "--silent"


foreach ($package in @(
	#AgileBits.1Password
	7zip.7zip
	Adobe.Acrobat.Reader.64-bit
	Golang.Go
	EclipseAdoptium.Temurin.17
	#Stedolan.Jq
	#DominikReichl.KeePass
	KeePassXCTeam.KeePassXC
	#ahmetb.kubectx
	#ahmetb.kubens
	#kubernetes-cli
	#johanhaleby.kubetail
	#Apache.Maven
	OpenJS.NodeJS
	#Notepad++.Notepad++
	Atlassian.Sourcetree
	Starship.Starship
	Jetbrains.Toolbox
	Microsoft.WindowsTerminal
	Yarn.Yarn
	#Mikefarah.Yq
	)
) {
	winget install --id $package
}

# TODO Should be Ubuntu-22.04; not listed on Windows 10
wsl --install -d Ubuntu-20.04

