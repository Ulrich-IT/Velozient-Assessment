# Velozient-Assessment
Assessment Repository

# Terraform Azure Infrastructure Deployment

## Introduction
This Terraform configuration deploys a highly available and scalable infrastructure on Azure. It includes a Virtual Network with three subnets, VMs with a Load Balancer in the Web tier, a VM in the Application tier, and an Azure SQL Database in the Database tier.

## Prerequisites
- [Terraform](https://www.terraform.io/downloads.html) installed
- Azure CLI configured and authenticated (`az login`)
- An existing Azure subscription

## Cost Estimate

            "Resource	                    Monthly Cost Estimate
            
            2 Web VMs	                            $50.56
            1 Application VM	                    $25.28
            Standard Load Balancer              	$18.00
            Azure SQL Database (S0)	                $15.00
            Bandwidth (Data Transfer)	            $10.00
            
            Total	                                $118.84



