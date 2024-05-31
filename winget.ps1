#Requires -RunAsAdministrator

# https://github.com/microsoft/winget-pkgs

# https://learn.microsoft.com/en-us/windows/package-manager/winget/settings#use-the-winget-settings-command
# Make sure that desired settings for winget are in place
If (!(Test-Path -PathType Container "$( $ENV:LocalAppData )\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState"))
{
	New-Item -Path "$( $ENV:LocalAppData )\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState" -ItemType directory | Out-Null
}

If (!(Test-Path -PathType Leaf "$( $ENV:LocalAppData )\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json"))
{
	Copy-Item "$PSScriptRoot\winget_settings.jsonc" -Destination "$( $ENV:LocalAppData )\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json"
}

# TODO check whether WSL is already installed, prompt for installation if it isn't and abort
if ("Enabled" -ne (Get-WindowsOptionalFeature -FeatureName Microsoft-Windows-Subsystem-Linux -Online | Select-Object -expand "State"))
{
	Write-Error -Message "WSL has not been installed/enabled yet. Please run 'wsl --install' and restart your computer" -Category NotInstalled -CategoryReason "WSL has not been installed/enabled yet." -ErrorAction Stop
}

# To find out how to fully automate installation of Inno Setup based installers (e.g. Git, VSCode)
# run it once with the /SAVEINF=path_to_save parameter; you can then use that output as shown below
# That way the installer will automatically use YOUR preferred settings.
# Read https://jrsoftware.org/ishelp/index.php?topic=setupcmdline for more details

# Apps below need custom invocations to prevent interactivity during/post installation:

# https://github.com/adoptium/installer/tree/master/wix#deploy-via-active-directory-gpo
# https://github.com/adoptium/installer/issues/422
# Requires `--location` support via `InstallerSwitches.InstallLocation: INSTALLDIR="<INSTALLPATH>"` in the manifest
winget install --id "EclipseAdoptium.Temurin.17.JDK" --silent --location "C:\Program Files\Eclipse Adoptium\temurin-17.jdk"
winget install --id "EclipseAdoptium.Temurin.21.JDK" --silent --location "C:\Program Files\Eclipse Adoptium\temurin-21.jdk"
# https://github.com/git-for-windows/git/wiki/Silent-or-Unattended-Installation
winget install --id "Git.Git" --silent --override "/VERYSILENT /NOCANCEL /LOADINF=$PSScriptRoot\winget_git.ini"
winget install --id "Google.Chrome" --silent --override "/quiet"
# https://support.mozilla.org/en-US/kb/deploy-firefox-msi-installers
winget install --id "Mozilla.Firefox" --silent --override "OPTIONAL_EXTENSIONS=false /quiet"
# PowerToys doesn't appear to have a way to define setup options and will by default launch after installation :/
# See e.g. https://github.com/microsoft/PowerToys/issues/24000
#winget install Microsoft.PowerToys --silent
# https://code.visualstudio.com/docs/setup/windows#_what-commandline-arguments-are-supported-by-the-windows-setup
winget install --id "Microsoft.VisualStudioCode" --silent --override "/VERYSILENT /NOCANCEL /MERGETASKS=!runcode /LOADINF=$PSScriptRoot\winget_vscode.ini"
# See https://confluence.atlassian.com/sourcetreekb/sourcetree-silent-installation-windows-732267345.html
# See https://confluence.atlassian.com/sourcetreekb/sourcetree-enterprise-and-msi-installation-947848769.html
# Cannot make installation truly silent; will pop-up same as PowerToys
#winget install --id "Atlassian.Sourcetree" --silent
# Install basic Visual Studio Code extensions
foreach ($extension in @(
"asciidoctor.asciidoctor-vscode"
"ban.spellright"
"DotJoshJohnson.xml"
"EditorConfig.EditorConfig"
"github.vscode-github-actions"
#"jetmartin.bats"
"mkhl.shfmt"
"ms-azuretools.vscode-docker"
"ms-vscode.powershell"
"redhat.vscode-yaml"
"tamasfe.even-better-toml"
"timonwong.shellcheck"
"yzhang.markdown-all-in-one"
))
{
	# Requires absolute path because of https://github.com/microsoft/winget-cli/issues/549
	C:\"Program Files"\"Microsoft VS Code"\bin\code --install-extension $extension
}

# Fully automated and simple installation invocations

foreach ($package in @(
"7zip.7zip"
"Adobe.Acrobat.Reader.64-bit"
#"adrienverge.yamllint"
"ahmetb.kubectx"
"ahmetb.kubens"
#"Apache.Maven"
"dandavison.delta"
"Docker.DockerDesktop"
#"Editorconfig-Checker.Editorconfig-Checker"
"GitHub.cli"
#"Gitleaks.Gitleaks"
"GoLang.Go"
#"hadolint.hadolint"
"IrfanSkiljan.IrfanView"
"JetBrains.Toolbox"
"jqlang.jq"
#"johanhaleby.kubetail"
"KeePassXCTeam.KeePassXC"
#"koalaman.shellcheck"
"Kubernetes.kubectl"
"Microsoft.WindowsTerminal"
"MikeFarah.yq"
#"mvdan.shfmt"
"OO-Software.ShutUp10"
"OpenJS.NodeJS"
"sharkdp.bat"
"Starship.Starship"
"wagoodman.dive"
"Yarn.Yarn"
"YS-L.csvlens"
))
{
	winget install --id $package --silent
}

# MS Store Apps
foreach ($app in @(
"9PMMSR1CGPWG" # HEIF Image Extensions
"9N5TDP8VCMHS" # Web Media Extensions
"9PG2DK419DRG" # Webp Image Extensions
"9N4D0MSMP0PT" # VP9 Video Extensions
"9N95Q1ZZPMH4" # MPEG-2 Video Extension
"9MVZQVXJBQ9V" # AV1 Video Extension
))
{
	winget install --id $app --silent --source msstore --accept-package-agreements --accept-source-agreements
}
