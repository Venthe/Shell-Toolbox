# Enable remote terminal access
winrm quickconfig
# Enable-PSRemoting -SkipNetworkProfileCheck -Force
# Enter-PSSession -ComputerName Asgard
# Test-WSMan -ComputerName Asgard
# Test-WSMan -ComputerName SRV2 -Credential MicrosoftAccount\XXXXXX@outlook.com
