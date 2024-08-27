# Azure Infrastructure Monitoring and Alerting Script

## Overview
This PowerShell script automates the setup of infrastructure monitoring and alerting for an Azure Virtual Machine using Azure Monitor. This is the extra script because this repository have a Python script as the main script.

## Prerequisites
- Azure PowerShell module installed - There is a Install_ps_linux.sh script to install the prerequisites on linux ubuntu if you use linux.
- Azure account with appropriate permissions
- Existing Virtual Machine in Azure

## Setup Instructions

1. **Login to Azure:**
   ```powershell
   Connect-AzAccount
