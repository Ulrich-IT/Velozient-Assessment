###################################
# Prerequisites

# Update the list of packages
sudo apt-get update

# Install pre-requisite packages.
sudo apt-get install -y wget apt-transport-https software-properties-common

# Get the version of Ubuntu
source /etc/os-release

# Download the Microsoft repository keys
wget -q wget https://github.com/PowerShell/PowerShell/releases/download/v7.4.5/powershell_7.4.5-1.deb_amd64.deb

# Register the Microsoft repository keys
sudo dpkg -i powershell_7.4.5-1.deb_amd64.deb

# Delete the Microsoft repository keys file
rm packages-microsoft-prod.deb

# Update the list of packages after we added packages.microsoft.com
sudo apt-get update

###################################
# Install PowerShell
sudo apt-get install -y powershell

# Start PowerShell
pwsh