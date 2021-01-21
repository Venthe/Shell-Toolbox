# Set connection to private
Get-NetConnectionProfile
Set-NetConnectionProfile -InterfaceIndex 11 -NetworkCategory Private

# Enable remote terminal access
winrm quickconfig
# Enable-PSRemoting -SkipNetworkProfileCheck -Force
# Enter-PSSession -ComputerName Asgard
# Test-WSMan -ComputerName Asgard
# Test-WSMan -ComputerName SRV2 -Credential MicrosoftAccount\jacek.b.lipiec@outlook.com