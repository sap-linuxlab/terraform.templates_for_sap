# Infrastructure platforms guidance

`This document is for Administrator/s.` The Terraform Templates for SAP require a user to have delegated limited administration privileges.


The following document contains information relevant to and minimum authorizations for executing the Terraform Templates for SAP on each infrastructure platform. This document does not contain all information relevant to each Cloud Service Provider hyperscaler and Hypervisor, or the specific configuration circumstances.

Each Terraform Template for SAP anticipates that an end user has a basic level of knowledge for the target infrastructure platform, and has requested the necessary access from their Administrator/s.

The below document contains guidance for:
- [AWS hyperscaler](#aws-hyperscaler), Cloud Service Provider
- [IBM Cloud hyperscaler](#ibm-cloud-hyperscaler), Cloud Service Provider
- [IBM PowerVC hypervisor](#ibm-powervc-hypervisor)
- [Microsoft Azure hyperscaler](#microsoft-azure-hyperscaler), Cloud Service Provider
- [VMware vSphere hypervisor](#vmware-vsphere-hypervisor)

<br/>

## AWS hyperscaler

The Terraform Templates for SAP on Amazon Web Services are designed to be executed by an Administrator or a user with limited delegated administration privileges.

There are options within the Terraform Templates to:
- Create VPC, or re-use existing VPC Subnet
- Create Resource Group, or re-use existing Resource Group

### Terraform execution permissions

The AWS User and associated key/secret will need to be assigned, by the Cloud Account Administrator, with the minimum AWS IAM privileges to perform these activities automatically with Terraform.

**Create the AWS IAM with the minimum user permissions, using the AWS CLI:**

```
# Login
aws configure

# Create AWS IAM Policy Group
aws iam create-group --group-name 'ag-terraform-exec'
aws iam attach-group-policy --group-name 'ag-terraform-exec' --policy-arn arn:aws:iam::aws:policy/AmazonVPCFullAccess
aws iam attach-group-policy --group-name 'ag-terraform-exec' --policy-arn arn:aws:iam::aws:policy/AmazonEC2FullAccess
aws iam attach-group-policy --group-name 'ag-terraform-exec' --policy-arn arn:aws:iam::aws:policy/AmazonRoute53FullAccess
```


## IBM Cloud hyperscaler

The Terraform Templates for SAP on IBM Cloud are designed to be executed by an Administrator or a user with limited delegated administration privileges.

The same privileges are needed for any IaaS Type available from the IBM Cloud for SAP portfolio which has been automated; the IaaS Types include Intel Virtual Servers and IBM Power Virtual Servers, but does not include Bare Metal or various options from IBM Cloud for VMware (single vSphere, cluster vSphere, cluster vSphere with networking overlay).

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

**Assign to a specified Account User or Service User**
```
ibmcloud iam access-group-user-add 'ag-terraform-exec' <<<IBMid>>>
ibmcloud iam access-group-service-id-add 'ag-terraform-exec' <<<SERVICE_ID_UUID>>>
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

The Terraform Templates for SAP on IBM Power hardware are designed to be executed by an Administrator or a user with limited delegated administration privileges.

IBM Power Virtualization Center (IBM PowerVC) is the centralized management component for IBM Power hardware running with the IBM PowerVM Type 1 hypervisor (PHYP firmware) or KVM on IBM Power Type 2 hypervisor (OPAL firmware).

The IBM PowerVC engine supports and is able to interpret Openstack API commands, therefore all Terraform for IBM Power hardware uses the Terraform Provider for Openstack to provision to either hypervisor technologies available with IBM Power hardware. However please note, only LPARs with Linux OS are approved for SAP HANA as noted in the summary below.

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
  - `NO support` for SAP HANA; Virtual Machines cannot run SAP HANA using KVM on IBM Power

For more information on IBM PowerVM (PHYP firmware) and KVM (OPAL firmware) for SAP workloads, please read:
[Red Book March 2020 - IBM Power Systems Virtualization Operation Management for SAP Applications](http://www.redbooks.ibm.com/redpapers/pdfs/redp5579.pdf)


## Microsoft Azure hyperscaler

The Terraform Templates for SAP on Microsoft Azure are designed to be executed by an Administrator or a user with limited delegated administration privileges.

There are options within the Terraform Templates to:
- Create VNet, or re-use existing VNet Subnet
- Create Resource Group, or re-use existing Resource Group

### Terraform execution permissions

The Azure Application Service Principal will need to be assigned, by the Cloud Account Administrator, with the minimum Azure AD Role to perform these activities automatically with Terraform.

**Create the Azure Application credentials with the minimum user permissions, using the Azure CLI:**
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


## VMware vSphere hypervisor

The Terraform Templates for SAP on VMware vSphere are designed to be executed by an Administrator or a user with limited delegated administration privileges.

## Requirements

- VMware vCenter and VMware vSphere (7.x and above)
- Network access setup for successful VMware Virtual Machine provisioning and subsequent SSH access from Terraform/Ansible, see below for more details


## VMware VM Template setup

The following are required setup items for provisioning VMware Virtual Machines:

- **OS Image with cloud-init installed**
  - Edit the default cloud-init configuration file, found at `/etc/cloud`. It must contain the data source for VMware (and not OVF), and force use of cloud-init metadata and userdata files.
  ```
  disable_vmware_customization: true
  datasource:
    VMware:
      allow_raw_data: true
      vmware_cust_file_max_wait: 10 # seconds
  ```
  - Prior to VM shutdown and marking as a VMware VM Template, run command `vmware-toolbox-cmd config set deployPkg enable-custom-scripts true`
  - Prior to VM shutdown and marking as a VMware VM Template, run command `sudo cloud-init clean --seed --logs --machine-id` to remove cloud-init logs, remove cloud-init seed directory /var/lib/cloud/seed , and remove /etc/machine-id. If using cloud-init versions prior to 22.3.0 then do not use `--machine-id` parameter
  - Once VM is shutdown, then run 'Convert to VM Template'
  - Debug by checking `grep userdata /var/log/vmware-imc/toolsDeployPkg.log` and `/var/log/cloud-init.log`
  - See documentation for further information:
    - VMware KB 59557 - How to switch vSphere Guest OS Customization engine for Linux virtual machine (https://kb.vmware.com/s/article/59557)
    - VMware KB 74880 - Setting the customization script for virtual machines in vSphere 7.x and 8.x (https://kb.vmware.com/s/article/74880)
    - cloud-init documentation - Reference - Datasources - VMware (https://cloudinit.readthedocs.io/en/latest/reference/datasources/vmware.html)


## VMware networking setup

The following are required setup items for provisioning VMware Virtual Machines.

### VMware vCenter and vSphere clusters with VMware NSX virtualized network overlays

For VMware vCenter and vSphere clusters with VMware NSX virtualized network overlays using Segments (e.g. 192.168.0.0/16) connected to Tier-0/Tier-1 Gateways (which are bound to the backbone network subnet, e.g. 10.0.0.0/8), the following are required:

- **CRITICAL: Routable access from host executing Terraform Template for SAP (and thereby Ansible subsequently triggered by the Terraform Template)**. For example, if the Terraform Template for SAP is executed on a macOS laptop running a VPN with connectivity to the VMware vCenter - then the VPN must also have access to the provisioned Subnet, otherwise initialised SSH connections to the VMware VM from Terraform and Ansible will not be successful.
  - It is recommended to investigate proper DNAT configuration for any VMware NSX Segments (this could be automated using Terraform Provider for VMware NSX-T, i.e. https://registry.terraform.io/providers/vmware/nsxt/latest/docs/resources/policy_nat_rule).
- **DHCP Server** must be created (e.g. NSX > Networking > Networking Profiles > DHCP Profile), set in the Gateway (e.g. NSX > Networking > Gateway > Edit > DHCP Config > ), then set for the Subnet (e.g. NSX > Networking > Segment > <<selected subnet>> > Set DHCP Config) which the VMware VM Template is attached to; this allows subsequent cloned VMs to obtain an IPv4 Address
- **Internet Access**: Option 1 - Configured SNAT (e.g. rule added on NSX Gateway) set for the Subnet which the VMware VM Template is attached to; this allows Public Internet access. Option 2 - Web Proxy.
- **DNS Server (Private)** is recommended to assist custom/private root domain resolution (e.g. poc.cloud)


### VMware vCenter and vSphere clusters with direct network subnet IP allocation

For VMware vCenter and vSphere clusters with direct network subnet IP allocations to the VMXNet network adapter (no VMware NSX network overlays), the following are required:

- **CRITICAL: Routable access from host executing Terraform Template for SAP (and thereby Ansible subsequently triggered by the Terraform Template)**. For example, if the Terraform Template for SAP is executed on a macOS laptop running a VPN with connectivity to the VMware vCenter - then the VPN must also have access to the provisioned Subnet, otherwise initialised SSH connections to the VMware VM from Terraform and Ansible will not be successful.
- **DHCP Server** must be created (e.g. NSX > Networking > Networking Profiles > DHCP Profile), set in the Gateway (e.g. NSX > Networking > Gateway > Edit > DHCP Config > ), then set for the Subnet (e.g. NSX > Networking > Segment > <<selected subnet>> > Set DHCP Config) which the VMware VM Template is attached to; this allows subsequent cloned VMs to obtain an IPv4 Address
- **Internet Access**: Option 1 - Configured SNAT (e.g. rule added on NSX Gateway) set for the Subnet which the VMware VM Template is attached to; this allows Public Internet access. Option 2 - Web Proxy.
- **DNS Server (Private)** is recommended to assist custom/private root domain resolution (e.g. poc.cloud)
