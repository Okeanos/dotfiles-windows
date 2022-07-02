# https://github.com/microsoft/winget-pkgs

# TODO Should be Ubuntu-22.04; not listed on Windows 10
wsl --install -d Ubuntu-20.04

winget install --id Git.Git --override "/VERYSILENT /NOCANCEL /LOADINF=$pwd\winget_git.ini"
winget install --id Golang.Go
winget install --id EclipseAdoptium.Temurin.17
#winget install --id Stedolan.Jq
#winget install --id ahmetb.kubectx
#winget install --id ahmetb.kubens
#winget install --id kubernetes-cli
#winget install --id johanhaleby.kubetail
#winget install --id Apache.Maven
winget install --id OpenJS.NodeJS
winget install --id Starship.Starship
winget install --id Yarn.Yarn
# winget install --id Mikefarah.Yq

#winget install --id AgileBits.1Password
winget install --id 7zip.7zip
winget install --id Adobe.Acrobat.Reader.64-bit
winget install --id Google.Chrome --override "/quiet"
# https://docs.docker.com/desktop/windows/install/#install-from-the-command-line
winget install --id Docker.DockerDesktop
# https://support.mozilla.org/en-US/kb/deploy-firefox-msi-installers
winget install --id Mozilla.Firefox --override "OPTIONAL_EXTENSIONS=false /quiet"
#winget install --id DominikReichl.KeePass
winget install --id KeePassXCTeam.KeePassXC
#winget install --id Notepad++.Notepad++
winget install --id Atlassian.Sourcetree
winget install --id Jetbrains.Toolbox
winget install --id Microsoft.VisualStudioCode --override "--silent"
winget install --id Microsoft.WindowsTerminal
