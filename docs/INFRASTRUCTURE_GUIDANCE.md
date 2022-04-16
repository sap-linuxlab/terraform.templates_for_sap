# Infrastructure platforms guidance

The following document contains information relevant to executing the Terraform Templates for SAP on each infrastructure platform.

This document does not contain all information relevant to each Cloud Service Provider hyperscaler and Hypervisor. These Terraform Template for SAP anticipate an end user has a basic level of knowledge for the target infrastructure platform and has requested the necessary access from their Administrator/s.


## IBM Cloud hyperscaler

The Terraform Templates for IBM Cloud are designed to be executed by an Administrator or a user with limited delegated administration privileges.

There are options within the Terraform Templates to:
- Create VPC, or re-use existing VPC Subnet
- Create Resource Group, or re-use existing Resource Group
- Create IAM `(WIP)`

### Terraform execution permissions

The API Key of either a User Account or Service ID will need to be assigned, by the Cloud Account Administrator, to an IAM Access Group with a minimum set of user permissons to perform these activities automatically with Terraform.

**Create the IAM Access Group with the minimum user permissions, using IBM Cloud CLI:**

```
# Login (see alternatives for user/password and SSO using ibmcloud login --help)
ibmcloud login --apikey=

# Create IBM Cloud IAM Access Group for Terraform executions
ibmcloud iam access-group-create 'ag-terraform-exec'
ibmcloud iam access-group-policy-create 'ag-terraform-exec' --roles Editor --service-name=is
ibmcloud iam access-group-policy-create 'ag-terraform-exec' --roles Editor,Manager --service-name=transit
ibmcloud iam access-group-policy-create 'ag-terraform-exec' --roles Editor,Manager --service-name=dns-svcs
```

**If creating Resource Group:**
```
ibmcloud iam access-group-policy-create 'ag-terraform-exec' --roles Administrator --resource-type=resource-group
```

**If creating IAM:**
```
ibmcloud iam access-group-policy-create 'ag-terraform-exec' --roles Viewer --attributes 'serviceType=service'
ibmcloud iam access-group-policy-create 'ag-terraform-exec' --roles Editor --service-name=iam-svcs
ibmcloud iam access-group-policy-create 'ag-terraform-exec' --roles Editor --service-name=iam-groups
```

**Create the IAM Access Group with the minimum user permissions, using IBM Cloud web console UI:**

- Open cloud.ibm.com - click Manage on navbar, click Access IAM, then on left nav menu click Access Groups
- Create an Access Group, with the following policies:
  - IAM Services > VPC Infrastructure Services > click All resources as scope + Platform Access as Editor
  - IAM Services > DNS Services > click All resources as scope + Platform Access as Editor + Service access as Manager
  - IAM Services > Transit Gateway > click All resources as scope + Platform Access as Editor + Service access as Manager
  - `[OPTIONAL]` IAM Services > All Identity and Access enabled services > click All resources as scope + Platform Access as Viewer + Resource group access as Administrator
  - `[OPTIONAL]` Account Management > Identity and Access Management > click Platform access as Editor
  - `[OPTIONAL]` Account Management > IAM Access Groups Service > click All resources as scope + Platform Access as Editor


## IBM PowerVC hypervisor

IBM Power Virtualization Center (IBM PowerVC) is the centralized management component for IBM Power hardware running with the IBM PowerVM Type 1 hypervisor (PHYP firmware) or KVM on IBM Power Type 2 hypervisor (OPAL firmware).

The IBM PowerVC engine supports and is able to interpret Openstack API commands, therefore all Terraform for IBM Power hardware uses the Terraform Provider for Openstack to provision to either hypervisor technologies avaialble with IBM Power hardware.

Summary of hypervisor technologies for IBM Power hardware:
- **IBM PowerVM for SAP**
  - IBM PowerVM using PowerVM hypervisor mode enabled on PHYP Firmware, using either IBM Power E, L or S Models (there are exclusions)
  - IBM PowerVM hypervisor (PHYP) installed directly to hardware
  - IBM PowerVC as the hypervisor control plane
  - Support for SAP NetWeaver and SAP AnyDB; LPARs with AIX, IBM i, or various Linux OS may run SAP NetWeaver or SAP AnyDB
  - Support for SAP HANA; LPARs with Linux OS (RHEL or SLES) may run SAP HANA (as per SAP Note 2188482 for SAP HANA)
- **KVM on IBM Power**
  - OPAL KVM hypervisor mode enabled on OPAL Firmware, using IBM Power AC/LC/IC Models (there are exclusions)
  - Linux OS installed directly to hardware, with KVM hypervisor installed to the Linux OS distribution. Instead of Linux OS (e.g. RHEL), a specialised KVM OS release may be used (e.g. RHV 4.2)
  - Support for SAP NetWeaver and SAP AnyDB; Virtual Machines with various Linux OS may run SAP NetWeaver or AnyDB, depending on the KVM and Linux OS distribution in use:
    - SLES (SAP Note 1522993)
    - RHEL (SAP Note 1400911)
    - RHV (SAP Note 1400911)
  - NO support for SAP HANA; Virtual Machines cannot run SAP HANA using KVM on IBM Power

For more information on IBM PowerVM (PHYP firmware) and KVM (OPAL firmware) for SAP workloads, please read:
[Red Book March 2020 - IBM Power Systems Virtualization Operation Management for SAP Applications](http://www.redbooks.ibm.com/redpapers/pdfs/redp5579.pdf)

## Microsoft Azure hyperscaler

The Terraform Templates for Microsoft Azure are designed to be executed by an Administrator or a user with limited delegated administration privileges.

There are options within the Terraform Templates to:
- Create VNet, or re-use existing VNet Subnet
- Create Resource Group, or re-use existing Resource Group

### Terraform execution permissions

The Azure Application Service Principal will need to be assigned, by the Cloud Account Administrator, with the minimum Azure AD Role to perform these activities automatically with Terraform.

**Create the Azure Application credentials with the minimum user permissions, using Azure CLI:**
```
# Login
az login

# Show Tenant and Subscription ID
export AZ_SUBSCRIPTION_ID=$(az account show | jq .id --raw-output)
export AZ_TENANT_ID=$(az account show | jq .tenantId --raw-output)

# Create Azure Application, includes Client ID
export AZ_CLIENT_ID=$(az ad app create --display-name Terraform | jq .appId --raw-output)

# Create Azure Service Principal, instantiation of Azure Application
export AZ_SERVICE_PRINCIPAL_ID=$(az ad sp create --id $AZ_CLIENT_ID | jq .objectId --raw-output)

# Assign default Azure AD Role with privileges for creating Azure Virtual Machines
az role assignment create --assignee "$AZ_SERVICE_PRINCIPAL_ID" \
--subscription "$AZ_SUBSCRIPTION_ID" \
--role "Virtual Machine Contributor" \
--role "Contributor"

# Reset Azure Application, to provide the Client ID and Client Secret to use the Azure Service Principal
export AZ_CREDENTIALS=$(az ad sp credential reset --name $AZ_CLIENT_ID)
export AZ_CLIENT_SECRET=$(echo $AZ_CREDENTIALS | jq .password --raw-output)


# If temporary, remove Azure Application and Service Principal using:
#az ad sp delete --id $AZ_SERVICE_PRINCIPAL_ID
```

### Other MS Azure notes

**List of Azure Regions with Availability Zones:**

There is no API response containing a list of Azure Regions with Availability Zones. As an approximate, it is possible to identify the recommended locations (which includes all Regions with AZs):
```
az account list-locations --output json | jq '[(.[] | select(.metadata.regionCategory == "Recommended"))]'
```

Documentation of Azure Regions with Availability Zones is available on the following URL:
https://docs.microsoft.com/en-us/azure/availability-zones/az-region#azure-regions-with-availability-zones
