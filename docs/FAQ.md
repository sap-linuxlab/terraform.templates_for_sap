# FAQ

This FAQ document includes the most common questions.


## Customized deployments of a SAP Software solution scenarios
---

### <samp>I'm an SAP Customer, can I use and amend this code for custom business purposes?</samp>

**Yes.** All code is under the Apache license, you can extend and use for internal purposes without any concerns. All feedback and contributions back to the project are appreciated.

### <samp>I'm an SAP Services Partner, can I use and amend this code to create new products/offerings for customers?</samp>

**Yes.** All code is under the Apache license you can extend and use for commercial purposes without any concerns. All feedback and contributions back to the project are appreciated.

### <samp>How to provision larger SAP Systems?</samp>

Each Terraform Template for SAP includes a "host specification plan" default named `small_256gb`. This is a baseline sizing customized to each Infrastructure Platform.

To append additional host specifications, edit the file `variable_map_hosts.tf` contained in each directory for each Terraform Template for SAP.

The `variable_map_hosts.tf` file:
- uses a single variable using Map type, containing all host specification plans
- each host specification plan can contain multiple hosts, with different host specificatons
- the host specifications contain a (flat design) key-value input for...
  - Configuration of mount points (/hana/data, /hana/log, /hana/shared, /usr/sap, /sapmnt, /swap)
  - Disk Volumes - count, type, capacity
  - Filesystem using LVM - filesystem type, enable (on/off), configuration of Physical Volumes + Volume Group + Logical Volumes (inc. block size)
  - Filesystem direct - filesystem type, block size

```terraform
variable "map_host_specifications" {
  description = "Map of host specficiations for SAP HANA"
  type = map(any)
  default = {

    small_new_384gb = {

      host1 = {
        virtual_server_profile = "mx2-48x384"
        ...
      },

      host2 = {
        virtual_server_profile = "mx2-32x256"
        ...
      }
    }
  }
}
```

### <samp>How to use custom OS Images on each Cloud hyperscaler?</samp>

Each Terraform Template for SAP for a Cloud Service Provider, includes an OS Image lookup name for all available OS Images from the Cloud Service Provider; such as `sles-15-2-sap-hana` or `rhel-8-4-sap-hana`.

Each of these OS Image lookup names refer to a regex pattern to retrieve the latest OS Image for the specific OS distribution version (i.e. major.minor release). This is necessary for some Cloud Service Providers which provide different OS Image versions / naming per Region.

To append additional OS Images such as a custom OS Image, edit the file `variable_map_os.tf` contained in each directory for each Terraform Template for SAP.

The `variable_map_os.tf` file:
- uses a single variable using Map type, containing all OS Image key-value input

```terraform
variable "map_os_image_regex" {
  description = "Map of operating systems OS Image regex, to identify latest OS Image for the OS major.minor version"
  type = map(any)
  default = {

    custom-name-here = ".*custom.*9-9.*name.*"

  }
}
```

### <samp>How to deploy to specific locations on each Cloud hyperscaler?</samp>

Each Terraform Template for SAP for a Cloud Service Provider, provides the user with the choice of Region and deployment Availability Zone (if using an existing virtualized private network, this will re-use the same Availability Zone).

In principle, each Cloud Service Provider uses the same geographical location logic:
- Region (alt. Location Display Name)
  - Availability Zone (aka. Data center)
    - Placement segmentation; known by various names e.g. Placement Groups / Physical Fault Domains etc.

Each Terraform Template for SAP uses fixed logic, to deploy to the first Availability Zone within a Region, edit the logic in file `variable_locals.tf`.


## Design choices of the Terraform Templates for SAP
---

### <samp>Why are the Terraform Templates for SAP designed for end-user laptops?</samp>

The Terraform Templates for SAP primary experience is designed for / assumes the end user is running from their own laptop.

All the Terraform Templates for SAP are a baseline which can be re-configured for other deployment approaches, such as deployments via CI/CD orchestration pipeline tools (e.g. Jenkins) which can be added to user self-service tools (e.g. ServiceNow).

By creating modular and comparable deployments of SAP Software Solution Scenarios across multiple Infrastructure Platforms, allows each end-user to rapidly test, compare and evaluate:
- migration of existing SAP System/s to new SAP Software versions
- migration of existing SAP System/s to new Infrastructure platforms
- new installation SAP Software functionality
- regression impacts using SAP System/s copies

These end-user activities, often map to various business-focused outcomes and initiatives:
- Migration to SAP S/4HANA AnyPremise:
  - Greenfield
  - Brownfield
  - Selective Data Transition
- Datacenter Exit / Cloud Service Provider switch:
  - Compute Re-locate
  - Compute Re-locate and move to SAP HANA
- Enterprise re-structures:
  - Spin-offs and Divestitures
  - Mergers and Acquisitions

### <samp>Why are SSH key output to files into the Terraform Template directory?</samp>

Please read *<samp>Why are the Terraform Templates for SAP designed for end-user laptops?</samp>* first.

Each Terraform Template for SAP is designed to be modular, but the execution is enclosed/self-contained (and often the deployment is only temporary). The output of the SSH Key files during the `terraform apply` execution into the directory path *`<<sap_solution_scenario>> / <<infrastructure_platform>> / ssh`* enables:
- the Ansible execution to be performed immediately
- ouput of a copy/paste Linux Shell or Windows PowerShell function after provisioning to:
  - SSH auto-login to OS
  - SSH tunnel for login to SAP HANA Studio and SAPGUI

### <samp>Why can SSH Public Keys already uploaded into the Infrastructure Platform not be used for deployments?</samp>

Potentially this feature will be added in the future.

By generating a new SSH Private/Public Key for the bastion and hosts using Terraform, mitigates an element of uncontrollable scope.

It is likely that beginner users may become confused when providing the resource name of an existing SSH Public Key uploaded in an Infrastructure Platform, and the format of the SSH Private Key/s (provided by an Administrator) where Terraform is being executed from. This in turn will cause catastrophic failures throughout the Terraform Template, unable to:
- login and configure the Bastion
- login and configure the Host/s
- Ansible login to run SAP preconfiguration and SAP Software installation

To avoid bad end user experiences and issues/complaints raised in GitHub, leaving a lot of wasted time by everyone involved - the Terraform Templates for SAP currently force newly created SSH Private/Public Keys created for the Bastion and the Host.

There are already a significant number of uncontrollable factors (e.g. non-conflicting resources in the Infrastructure Platform, correct SAP.com credentials, availability of SAP Software, and more) which may cause failures that are unrelated to the Terraform code itself.

### <samp>Why can an existing Bastion on the Cloud hyperscaler not be used for deployments?</samp>

Potentially this feature will be added in the future.

Please read *<samp>Why can SSH Public Keys already uploaded into the Infrastructure Platform not be used for deployments?</samp>* first, as this explains in more detail.

The use of an existing Bastion increases the likelihood of catastrophic failures throughout the Terraform Template, as the SSH Server (sshd) configuration will already be set and the network controls already in place, which potentially cannot be altered to allow jump-through of TCP Ports required for SAP Systems.

### <samp>Why is there no guidance for using with `X` tool?</samp>

Please read *<samp>Why are the Terraform Templates for SAP designed for end-user laptops?</samp>* first.

Each of these deployment approaches are bespoke to every business, with significant differences in setup of each tool for different authorization/approval security flows etc. It is possible sample code will be provided in future, but not within the Terraform Templates for SAP repository.

### <samp>Why must a Bastion be used? Why not deploy SAP Systems on a Public Internet IP address when using Cloud hyperscalers?</samp>

This is an insecure deployment method, which poses a risk to network security. If additional hosts and ports are open to Public Internet, it increases the attack surface for the Cloud account and may inadvertently provide an attack vector that compromises the entire Cloud account. The hosts provisioned through the Terraform Templates for SAP, include the baseline security hardening in the OS Images and not fully hardened for Public Internet ("Red Zone" as most network security engineers would designate).

In short summary, the benefits of the Terraform Templates for SAP using a Bastion are:
- Changing the Bastion SSH Port from default `22` to auto-drop the network packet and using a port from the IANA Dynamic Ports range (49152 to 65535), will reduce an attack vector because it is time-consuming/costly for a hacker to issue scans for all Ports of every Public IP Address.
- Keeping the Host behind the firewall, allows the SSH Port to remain as `22` and to open all other SAP System ports (e.g. `3200` or `44301`) without exposing direct connectivity to the internet that an attacker could use.
- If the SAP Systems are used for extended testing periods and connected to other hosts within the account, the Bastion can be removed and network security design of the Cloud account would not be compromised.


## Common Errors
---

### <samp>SAP Software installation media pre-check or downloads have error 'authentication failed - 401 Client Error'</samp>

SAP software installation media must be obtained from SAP directly, and requires valid license agreements with SAP in order to access these files.

The error HTTP 401 refers to either:
- Unauthorized, the SAP User ID being used belongs to an SAP Company Number (SCN) with one or more Installation Number/s which do not have license agreements for these files
- Unauthorized, the SAP User ID being used does not have SAP Download authorizations
- Unauthorized, the SAP User ID is part of an SAP Universal ID and must use the password of the SAP Universal ID
  - In addition, if a SAP Universal ID is used then the recommendation is to check and reset the SAP User ID ‘Account Password’ in the [SAP Universal ID Account Manager](https://account.sap.com/manage/accounts), which will help to avoid any potential conflicts.

This is documented:
- summary version under [Terraform Templates for SAP - Requirements, Dependencies and Testing](https://github.com/sap-linuxlab/terraform.templates_for_sap#sap-user-id-credentials)
- full detail under [Ansible Collection for SAP Launchpad - Requirements, Dependencies and Testing](https://github.com/sap-linuxlab/community.sap_launchpad#requirements-dependencies-and-testing)

### <samp>SAP Software installation media from SAP Maintenance Planner fails with 'download link `https://softwaredownloads.sap.com/file/___` is not available'</samp>

SAP has refreshed the installation media (new revisions or patch levels) for the files in your SAP Maintenance Planner stack, and you will need to update / create a new plan to re-generate the up to date files.

### <samp>SAP Software installation media pre-check or downloads have error '403'</samp>

SAP Software Center is likely experiencing temporary problems, please try again later. The Ansible Collection for SAP Launchpad will always attempt 3 retries if a HTTP 403 error code is received, if after 3 attempts the file is not available then a failure will occur.
