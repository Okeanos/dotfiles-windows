#Requires -RunAsAdministrator

###############################################################################
# Base Environment                                                            #
###############################################################################

Write-Host "Base Environment"

# Variables
# Ensure that Unix tools have a consistent and predictable HOME directory; important if a network drive is used as pseudo-home
Set-ItemProperty "HKCU:\Environment" "HOME" "%USERPROFILE%" -Type ExpandString
# Ensure that Unix tools have a consistent and predictable USER variable available; important for SSH for example
Set-ItemProperty "HKCU:\Environment" "USER" "$Env:UserName"

# Set Execution Policy for Scripts
# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy
Set-ExecutionPolicy Unrestricted -Scope CurrentUser -Force

###############################################################################
# General UI/UX                                                               #
###############################################################################

Write-Host "General UI/UX"

# Disable Wallpaper Compression
New-ItemProperty "HKCU:\Control Panel\Desktop" -Name JPEGImportQuality -Value 0x00000064 | Out-Null

# Enable Clipboard History
#Set-ItemProperty "HKCU:\Software\Microsoft\Clipboard" -Name EnableClipboardHistory -Value 1

# Enable Dark Mode
#Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name SystemUsesLightTheme -Value 0
#Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name AppsUseLightTheme -Value 0

###############################################################################
# Security & Privacy                                                          #
###############################################################################

Write-Host "Security & Privacy"

# Advertising ID for Apps
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name Enabled -Value 0
# Websites access to language list
New-ItemProperty "HKCU:\Control Panel\International\User Profile" -Name HttpAcceptLanguageOptOut -Value 1 | Out-Null
# Track Apps
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name Start_TrackProgs -Value 0
# Automatic installation of Apps
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name SilentInstalledAppsEnabled -Value 0
# Suggested Content
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name SubscribedContent-338393Enabled -Value 0
# Suggested Content
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name SubscribedContent-353694Enabled -Value 0
# Suggested Content
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name SubscribedContent-353696Enabled -Value 0

# Diagnostics & Feedback
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name AllowTelemetry -Value 0
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name MaxTelemetryAllowed -Value 0
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy" -Name TailoredExperiencesWithDiagnosticDataEnabled -Value 0
New-Item -Force -ItemType Directory "HKCU:\Software\Microsoft\Siuf\Rules" | Out-Null
New-ItemProperty "HKCU:\Software\Microsoft\Siuf\Rules" -Name NumberOfSIUFInPeriod -Value 0 | Out-Null

# App Permissions
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" -Name Value -Value Deny
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments" -Name Value -Value Deny
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync" -Name Value -Value Deny
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat" -Name Value -Value Deny
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts" -Name Value -Value Deny
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email" -Name Value -Value Deny
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name Value -Value Deny
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCall" -Name Value -Value Deny
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory" -Name Value -Value Deny
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\radios" -Name Value -Value Deny
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" -Name Value -Value Deny
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userDataTasks" -Name Value -Value Deny

# Services
#Get-Service "*DiagTrack*" | Set-Service -StartupType Disabled
#Get-Service "*dmwappushservice*" | Set-Service -StartupType Disabled

# Tasks
#Get-ScheduledTask "*Consolidator*" | Disable-ScheduledTask | Out-Null
#Get-ScheduledTask "*UsbCeip*" | Disable-ScheduledTask | Out-Null

# Defender
#Set-MpPreference -MAPSReporting Disabled
#Set-MpPreference -SubmitSamplesConsent NeverSend

###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
###############################################################################

#Write-Host "Trackpad, mouse, keyboard, Bluetooth accessories, and input"

#Set-ItemProperty "HKCU:\Control Panel\Mouse" -Name MouseSpeed -Value 0
#Set-ItemProperty "HKCU:\Control Panel\Mouse" -Name MouseSensitivity -Value 12

###############################################################################
# Screen                                                                      #
###############################################################################

#Write-Host "Screen"

# Disable fast startup
#Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name HiberbootEnabled -Value 0

# Disable Lock Screen
#New-Item -Force -ItemType Directory "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" | Out-Null
#New-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Name NoLockScreen -Value 1 | Out-Null

###############################################################################
# Explorer                                                                    #
###############################################################################

Write-Host "Explorer"

#Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name ShowFrequent -Value 0
#Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name LaunchTo -Value 1
Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name HideFileExt -Value 0
#Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name Hidden -Value 1
#Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name AutoCheckSelect -Value 0

# Allow paths longer than 260 characters (the default MAX_PATH length)
# https://learn.microsoft.com/en-us/windows/win32/fileio/maximum-file-path-limitation?tabs=powershell#enable-long-paths-in-windows-10-version-1607-and-later
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "LongPathsEnabled" -Value 1 -Type DWORD -Force

###############################################################################
# Start Menu and Taskbar                                                      #
###############################################################################

#Write-Host "Start Menu and Taskbar"

# Start Menu
#Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name Start_TrackDocs -Value 0

# Taskbar
#Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name SearchboxTaskbarMode -Value 0
#Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name ShowTaskViewButton -Value 0
#Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name TaskbarDa -Value 0
#Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name TaskbarMn -Value 0

###############################################################################
# Windows Terminal                                                            #
###############################################################################

Write-Host "Windows Terminal"

# Make Windows Terminal the default Console
# Use {B23D10C0-E52E-411E-9D5B-C09FDF709C7D} for Console & Terminal to use the legacy Windows Console Host instead
# Use {00000000-0000-0000-0000-000000000000} for Console & Terminal to let Windows decide on the fly instead
# https://github.com/microsoft/terminal/discussions/15505
Set-ItemProperty "HKCU:\Console\%%Startup" -Name DelegationConsole -Value "{2EACA947-7F5F-4CFA-BA87-8F7FBEEFBE69}"
Set-ItemProperty "HKCU:\Console\%%Startup" -Name DelegationTerminal -Value "{E12CFF52-A866-4C77-9A90-F570A7AA2C6B}"

If (Test-Path -PathType Leaf "$( $ENV:LocalAppData )\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json")
{
	$terminal_settings = Get-Content "$( $ENV:LocalAppData )\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -Raw | ConvertFrom-Json

	# Set the Terminal Theme to follow the system settings
	$terminal_settings | add-member -Name "theme" -value  "system" -MemberType NoteProperty

	# Add Selenized Light color scheme (based on https://github.com/jan-warchol/selenized/pull/88/files)
	$selenized_light =@"
{
	"background": "#fbf3db",
	"black": "#e9e4d0",
	"blue": "#0072d4",
	"brightBlack": "#cfcebe",
	"brightBlue": "#006dce",
	"brightCyan": "#00978a",
	"brightGreen": "#428b00",
	"brightPurple": "#c44392",
	"brightRed": "#cc1729",
	"brightWhite": "#3a4d53",
	"brightYellow": "#a78300",
	"cursorColor": "#3a4d53",
	"cyan": "#009c8f",
	"foreground": "#53676d",
	"green": "#489100",
	"name": "Selenized Light",
	"purple": "#ca4898",
	"red": "#d2212d",
	"selectionBackground": "#cfcebe",
	"white": "#909995",
	"yellow": "#ad8900"
}
"@
	$terminal_settings.schemes += (ConvertFrom-Json -InputObject $selenized_light)
	$default_profile =@"
{
	"colorScheme": "Selenized Light"
}
"@
	$terminal_settings.profiles.defaults = (ConvertFrom-Json -InputObject $default_profile)

	$terminal_settings | ConvertTo-Json -Depth 100 | Out-File "$( $ENV:LocalAppData )\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -Encoding utf8
}


###############################################################################
# Remove standard applications                                                #
###############################################################################

Write-Host "Remove standard applications:"

Write-Host " - Apps"

# Apps
foreach ($app in @(
"Microsoft.OneDrive"
))
{
	winget uninstall $app
}

Write-Host " - Packages"

# Packages
# List currently installed ones with: Get-AppxProvisionedPackage -Online | Where-Object { $_.PackageName -Like "*Microsoft.*" }
foreach ($package in @(
"*Microsoft.BingNews*"
"*Microsoft.BingWeather*"
"*Microsoft.GamingApp*"
"*Microsoft.GetHelp*"
"*Microsoft.Getstarted*"
"*Microsoft.MicrosoftOfficeHub*"
"*Microsoft.MicrosoftSolitaireCollection*"
"*Microsoft.MicrosoftStickyNotes*"
"*Microsoft.MixedReality.Portal*"
"*Microsoft.Office.OneNote*"
"*Microsoft.OneDriveSync*"
"*Microsoft.PowerAutomateDesktop*"
"*Microsoft.SkypeApp*"
"*Microsoft.Todos*"
"*microsoft.windowscommunicationsapps*"
"*Microsoft.WindowsFeedbackHub*"
"*Microsoft.WindowsMaps*"
"*Microsoft.WindowsSoundRecorder*"
"*Microsoft.Xbox.TCUI*"
"*Microsoft.XboxApp*"
"*Microsoft.ZuneMusic*"
"*Microsoft.ZuneVideo*"
"*MicrosoftTeams*"
"*MicrosoftWindows.Client.WebExperience*"
))
{
	Get-AppxProvisionedPackage -Online | Where-Object { $_.PackageName -Like $package } | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName } | Out-Null
	Get-AppxPackage -AllUsers $package | Remove-AppxPackage
}

Write-Host " - Capabilities"

# Capabilities
# List currently installed ones with: Get-WindowsCapability -Online | Where-Object { $_.State -Like "Installed" }
foreach ($capability in @(
"App.StepsRecorder~~~~0.0.1.0"
"App.Support.QuickAssist~~~~0.0.1.0"
"Browser.InternetExplorer"
"MathRecognizer~~~~0.0.1.0"
"Media.WindowsMediaPlayer~~~~0.0.12.0"
"Microsoft.Windows.PowerShell.ISE~~~~0.0.1.0"
"Microsoft.Windows.WordPad~~~~0.0.1.0"
))
{
	Remove-WindowsCapability -Online -Name $capability | Out-Null
}

Write-Host -NoNewline "Done. Note that some of these changes require a restart to take effect."
