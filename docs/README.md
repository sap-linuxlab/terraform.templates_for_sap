# Documentation of Terraform Templates for SAP

## Get started

It is recommended to fully read the README below for context and understanding, before you execute this code.

To get started immediately, requirements:
- Infrastructure Platform credentials and required authorizations (see [Infrastructure Guidance](./DEV_INFRASTRUCTURE_GUIDANCE.md)); depending on choice may require OS Vendor subscription
- SAP ONE Support Launchpad credentials, with Software Download privileges
- Terraform and Ansible installed
- Optional, depending on choice SAP solution scenario: SAP System Copy backup file

<br/>
<details>
  <summary><b>Local - macOS instructions summary:</b></summary>
  
  Tested steps to use Terraform Templates for SAP from local machines running Windows 10:

  1. Install Homebrew, please see documentation: https://docs.brew.sh
      - Install Terraform and Ansible Community Edition (contains ansible-core); such as using `brew install ansible bash gawk jq openssl@1.1 terraform`
  2. Download Terraform Templates for SAP using `curl -L https://github.com/sap-linuxlab/terraform.templates_for_sap/archive/refs/heads/main.zip -o main.zip && tar -xvf main.zip`
  3. Run and follow prompts `./run_terraform.sh`
  4. Once completed, follow output copy/paste to open SSH connection to OS or an SSH tunnel for SAP HANA Studio and SAPGUI
</details>

<br/>

<details>
  <summary><b>Local - Windows OS instructions summary:</b></summary>
  
  Windows cannot natively run Ansible because of Python package dependencies which are not available for Windows. Therefore the only tested method is to use Windows Subsystem for Linux v2 (WSL2) with Ubuntu 20.04 to execute the Terraform Templates for SAP from; after which output is given in PowerShell to use the native OpenSSH Client in Windows 10 and above.

  Tested steps to use Terraform Templates for SAP from local machines running Windows 10:

  1. Download and Install Windows Terminal for simplified terminal usage, please see: https://apps.microsoft.com/store/detail/windows-terminal/9N0DX20HK701
  2. Install Windows Subsystem for Linux v2 (WSL2), please see documentation: https://aka.ms/wsl2-install
  3. After WSL setup is completed, install Ubuntu 20.04 onto host using `wsl --install -d Ubuntu-20.04`. Follow proceeding steps.
  4. Update `apt` and install `pip` for System Python and `unzip`, using `sudo apt update && sudo apt install python3-pip unzip`
  5. Install Terraform and Ansible Community Edition (contains ansible-core) using `apt`; alternative using Homebrew for Linux in proceeding step.
      - Install Terraform on Ubuntu using `apt`, please see documentation: https://learn.hashicorp.com/tutorials/terraform/install-cli#install-terraform
      - Install Ansible Community Edition (contains ansible-core) using `apt`, please see documentation: https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-on-ubuntu
  6. ALTERNATIVE / Not recommended: Install Homebrew on Linux, please see documentation: https://docs.brew.sh/Homebrew-on-Linux
      - Install Terraform and Ansible Community Edition (contains ansible-core); such as using `brew install ansible terraform`
  7. Download Terraform Templates for SAP using `curl -L https://github.com/sap-linuxlab/terraform.templates_for_sap/archive/refs/heads/main.zip -o main.zip && unzip main.zip`
  8. Run and follow prompts `./run_terraform.sh`
  9. If altering any files, these can be accessed with Windows Finder by using directory `\\wsl$`. For example, opening this directory using VS Code for Windows.
  10. Run and follow prompts `./run_terraform.sh`
  11. Once completed, follow output copy/paste to open SSH connection to OS or an SSH tunnel for SAP HANA Studio and SAPGUI

  `NOTE:` If editing any code, please ensure the file is saved in LF and not the Windows default CRLF as the format for End of Line Sequence. Terraform and Ansible may not work correctly if files are CRLF.
</details>

<br/>
<details>
  <summary><b>Local - Advanced users summary:</b></summary>
  
  The `./run_terraform.sh` script is provided as an entry point for beginner users, with prompts for the target SAP Scenario and Infrastructure Platform which will then switch to the correct directory for the specific Terraform Template of those choices.

  As an example, the script would run the following 3 commands for a user selecting SAP S/4HANA on IBM Cloud and using default variable values:
  ```
  cd /terraform.templates_for_sap/sap_s4hana_single_node_install_maintenance_plan/ibmcloud_vs
  terraform init
  terraform apply -var-file=variables_generic_for_cli.tfvars
  ```
</details>

<br/>
<details>
  <summary><b>Hosted - Execution from Terraform Cloud or Terraform Enterprise:</b></summary>
  
  It is also possible to re-use the Terraform Templates for SAP with Terraform Cloud or Terraform Enterprise:

  1. Add any Terraform Template for SAP into the git repository
    - If preference is to use default tfvars file to reduce Terraform Input Variables, then rename `variables_generic_for_cli.tfvars` to `terraform.tfvars` (auto-detected by Terraform Cloud, but not by Terraform Enterprise). Be aware that many .gitignore files will by default ignore files with this file extension.
  2. [Create the Terraform Cloud/Enterprise Organization.](https://app.terraform.io/app/organizations/new)
  3. Within the Organization, [create the Terraform Cloud/Enterprise Workspace.](https://app.terraform.io/app/sll-osi/workspaces/new)
    - Select which execution workflow to use with the Workspace (e.g. API-driven, CLI-driven, or VCS-driven).
      - For example, select Version Control System (VCS) such as GitHub.com or GitHub Enterprise repository. This git repository must contain a Terraform Template, and any existing Terraform State files.
      - The Terraform Template will be loaded into the Terraform Cloud/Enterprise Workspace.
      - Each commit to a git repository, will automatically be detected by Terraform Cloud/Enterprise and execute a Terraform Plan.
  4. [Open the created Terraform Cloud/Enterprise Workspace](https://app.terraform.io/app/sll-osi/workspaces), use the left navigation and click `'Runs'`. Click on the first run shown, which will display a list of required Terraform Input Variables which are required before starting a new run; the list will be smaller if the .tfvars file was used.
  5. [Open the created Terraform Cloud/Enterprise Workspace](https://app.terraform.io/app/sll-osi/workspaces), use the left navigation and click `'Variables'`. Add the missing variables from the previous screen; due to the non-interactive design, the Terraform Input Variable Descriptions are not shown and therefore the expected variables input must be read from the `variables.tf` file.
  6. Return to the `'Runs'` page and click ***Actions > Start new run***. When prompted, it is suggested to use the run type drop-down as 'Plan only' as a first test, then afterwards use 'Plan and apply (standard)'. Click ***Start Run*** to begin the Terraform Template for SAP execution - which will provision to the infrastructure platform and perform the SAP Software installation.
</details>

<br/>
<details>
  <summary><b>Hosted - Execution from Azure DevOps Service:</b></summary>
  
  It is also possible to execute the Terraform Templates for SAP from an Azure DevOps Service Release Pipeline:
  
  Before starting, please ensure an Azure Resource Group and Azure Blob Container (and the parent Azure Storage Account) are created and all Billing setup for Azure DevOps is completed (including allocation of at least 1 Paid parallel jobs).
  
  1. Open [Azure DevOps Services](https://dev.azure.com) (provides access to Azure Pipelines) and login
  2. Create an Azure DevOps Organization on the [Azure DevOps AEX Portal](https://aex.dev.azure.com/)
  3. Within the Azure DevOps Organization, create a new Private Project from the [Azure DevOps Services](https://dev.azure.com) homepage. Ensure version control is set to Git.
  4. Install the [Terraform Extension for Azure DevOps by Microsoft DevLabs](https://marketplace.visualstudio.com/items?itemName=ms-devlabs.custom-terraform-tasks) to the Azure DevOps Organization. This can be subsequently managed from the Azure Organization Settings - Extension page (e.g. `https://dev.azure.com/<<ORG>>/_settings/extensions?tab=installed`)
  5. Open Repos from the navigation menu. Click 'Import a repository' and use 'https://github.com/sap-linuxlab/terraform.templates_for_sap'
  6. Open Pipelines from the navigation menu, then click Releases. Then create a new Release Pipeline. When the Release Pipeline workflow creation page opens, it will open onto the Pipeline tab. At the top of the page, the Release Pipeline can be named.
  7. On the Pipeline tab, a pop-up for the Release Pipeline Stage will open on the right-side and prompt to use a template or create 'Empty job'. Choose 'Empty job'.
  8. On the Pipeline tab, click to 'Add an Artifact'. Choose 'Azure Repo' and select the previously imported Terraform Templates for SAP repo. It is recommended to use the 'main' branch. Then click 'Add'.
  9. Select the Tasks tab, by default an Agent Job will be added to the Release Pipeline Stage 1..n and have the Agent Pool set to to 'Hosted Windows 2019'.
  10. Change the Agent Pool to 'Azure Pipelines', which will prompt for the Agent Specification. Choose 'ubuntu-latest' for the Agent Specification.
  11. Click the `+` button to 'Add a task to Agent Job'. On the right-side search "terraform" which will display two tasks from the Terraform Extension for Azure DevOps by Microsoft DevLabs. Add the 'Terraform tool installer' followed by adding 'Terraform' twice. This will add three tasks under the Agent Job.
  12. In both the second and third task of the Agent Job, change the 'Configuration directory' to `$(System.DefaultWorkingDirectory)/<<Azure_Repo_name_here>>/<<sap_software_scenario>>/<<infrastructure_platform>>`. For example, `$(System.DefaultWorkingDirectory)/_tf-templates-sap/sap_hana_single_node_install/msazure_vm`.
  13. In the second task of the Agent Job, select an Azure Subscription and click 'Authorize' to create a new Azure service principal for this Azure DevOps Release Pipeline. Subsequently select where the Terraform State Files will be stored by selecting an Azure Resource Group and the Azure Blob Container (and the parent Azure Storage Account). The 'Key' option can be set to standard 'terraform.tfstate'. 
  14. In the third task of the Agent Job, change the command to 'apply' and append the '-auto-approve' for the Additional command arguments and if preferring to use default variables for the SAP Software solution scenario then instead append `-auto-approve -var-file=variables_generic_for_cli.tfvars -var "az_app_client_id=value" -var "az_app_client_secret=value" -var "az_location_availability_zone_no=value" -var "az_location_region=value" -var "az_resource_group_name=value" -var "az_subscription_id=value" -var "az_tenant_id=value" -var "az_vnet_name=value" -var "az_vnet_subnet_name=value" -var "sap_id_user=value" -var "sap_id_user_password=value"`
  15. Once completed, click 'Save' for this Release Pipeline
  16. To provision the Terraform Template for SAP, click 'Create release' on the Release Pipeline.
</details>

<br/>
<details>
  <summary><b>Hosted - Execution from IBM Cloud Schematics:</b></summary>
  
  It is also possible to execute the Terraform Templates for SAP from an IBM Cloud Schematics:
  
  1. Open [IBM Cloud Schematics](https://cloud.ibm.com/schematics)
  2. [Create an IBM Cloud Schematics Workspace](https://cloud.ibm.com/schematics/workspaces/create), and specify the Terraform Template for SAP to use:
    - The URL will reference the specific Terraform Template for SAP `https://github.com/sap-linuxlab/terraform.templates_for_sap/tree/main/<<sap_software_scenario>>/<<infrastructure_platform>>`. For example, use the SAP HANA installation Terraform Template for IBM Cloud VS `https://github.com/sap-linuxlab/terraform.templates_for_sap/tree/main/sap_hana_single_node_install/ibmcloud_vs`.
    - Ensure 'Use full repository' is not selected, so that only the specific Terraform Template for SAP is loaded.
    - Ensure the Terraform version is Terraform 1.2 and above.
    - Click next.
    - Define the Workspace Name, Location and the Resource Group. *Note: this the location where the Terraform Template will be executed from, it does not restrict where the resources are provisioned to.*
    - Click next.
    - Review the input, then click Create.
  3. After creating the workspace, it will open onto the Workspace Settings page. The Terraform Input Variables defined for the selected Terraform Template will be imported here.
    - *Note: each Terraform Template for SAP by default does not store default values for the Terraform Input Variables. When executing from CLI, it is optional to load suggested default variable values from `variables_generic_for_cli.tfvars` and then Terraform will only prompt for the remaining Input Variables (e.g. API key, provisioning locatio etc). From IBM Cloud Schematics this file is not loaded, and all values must be populated*
    - Click 'Type' to sort the Terraform Input Variables which are 'Map' type, to the bottom and ignore these.
    - For each Terraform Input Variable, read the Descriptions for the expected input. Click 'Edit' and enter a value. View the `variables_generic_for_cli.tfvars` for suggested values.
    - The variables for Infrastructure Platform credentials must be provided; even if using IBM Cloud Schematics to provision resources on IBM Cloud, the variable `ibmcloud_api_key` is not automatically populated.
  4. Once all variables are set, then click 'Generate Plan'. This will run `terraform plan` as a first test to check the configuration is ready for provisioning.
  5. Then click 'Apply Plan' which will run `terraform apply` to begin the Terraform Template for SAP execution - which will provision to the infrastructure platform and perform the SAP Software installation.

  *Note: If the provisioned resources are no longer required, click **Actions > Destroy resources** to run `terraform destroy`.
</details>


---

## Introduction

This project is designed to be outcome-focused and highly-reusable.

Each Terraform Template is for a pre-defined SAP Software solution scenario on a given Infrastructure Platform, e.g. SAP HANA installation to Microsoft Azure, or SAP ECC on HANA System Copy (Homogeneous) to IBM Cloud.

This Project is built of two technology components:
- Infrastructure-as-Code (IaC) for deployment of host infrastructure. Uses Terraform.
- Configuration-as-Code (CaC) for configuraton of OS and installation of SAP Software. Uses Ansible, dynamically altered by Terraform.

These Terraform Templates are constructed using the custom [Terraform Modules for SAP](https://github.com/sap-linuxlab/terraform.modules_for_sap), which can be combined to create new Terraform Templates for different scenarios. **The provided solution scenarios are a baseline, from which amendments and extensions can be made to create any SAP Software solution scenario on any Infrastructure Platform.**

The project addresses common SAP System activities such as:
- initial SAP software installations (Maintenance Planner)
- move or clone SAP Systems to new infrastructure (System Copy)

The project therefore assists SAP-run enterprises to achieve various outcomes, such as:
| Business requirement | Potential activities assisted by this project |
| --- | --- |
| **Migration to SAP S/4HANA AnyPremise:** | **Greenfield**; perform a new installation from SAP Maintenance Planner |
| | **Brownfield**; perform a backup, execute a System Copy (Homogenous) and execute DMO for SUM with System Move, begin testing activities, add to remediation plan, repeat until cutover plan completed |
| | **Selective Data Transition**; perform a backup, execute a System Copy (Homogenous), execute Shell Conversion or Mix&Match, begin testing activities, add to remediation plan, repeat until cutover plan completed |
| **Datacenter Exit / Cloud Service Provider switch:** | **Compute Re-locate**; perform a backup, execute a System Copy (Homogenous) to a target infrastructure, begin testing activities, add to remediation plan, repeat until cutover plan completed |
| | **Compute Re-locate and move to SAP HANA**; perform a backup, execute a System Copy (Homogenous), upgrade ECC EHP and SAP NetWeaver versions, then System Copy (Heterogeneous) using SWPM |
| **Enterprise re-structures:** | **Spin-offs and Divestitures** (Grow through focus on core value); define split-by action *(e.g. Organizational Units such as Company Code, Plants, Controlling area, Profit centers)*, perform a backup, execute a System Copy (Homogenous), perform carve-out activities, begin testing activities, add to remediation plan, repeat until cutover plan completed |
| | **Mergers and Acquisitions** (Grow through expansion); merge of SAP Systems, perform a backup of each, execute a System Copy (Homogenous) of each, upgrade to ECC EHP and SAP NetWeaver versions to match, smoke test functionality of both post-upgrade, begin testing and identification of business process alterations with the corresponding creation of Transports (e.g. altered BC Sets) to manually move |

## Execution workflow structure

Each Terraform Template is for a deployment of a SAP Software solution scenario to a platform, and reuses custom [Terraform Modules for SAP](https://github.com/sap-linuxlab/terraform.modules_for_sap) to provision resources (e.g. host machines) and execute Ansible Playbooks (referencing Ansible Collection Role/s) for configuration of OS and installation of SAP software.

Segregation of definitions for the Infrastructure and SAP Software follows the same delineation:
- Terraform defines the Infrastructure Specification templates
- Ansible defines the SAP Software installation / SAP System templates

An overview of the execution flow is provided in the image below, for full details please see:
- [the Execution Flow documentation](./DEV_EXECUTION_FLOW.md)
- [the Infrastructure Platform guidance to use Terraform Templates for SAP](./DEV_INFRASTRUCTURE_GUIDANCE.md)
- [the FAQ, includes information for customized deployments of SAP Software solution scenarios](./FAQ.md)
- [the detailed documentation in Terraform Modules for SAP](https://github.com/sap-linuxlab/terraform.modules_for_sap)

![Terraform execution flow](./terraform_sap_infrastructure_exec_flow.svg)

## Available SAP solution scenarios and Infrastructure Platforms

The following is a list of Infrastructure Platforms and Operating System vendors which the Terraform Templates are compatible with, and the various SAP solution scenarios which are developed.

**Hyperscaler Cloud Service Providers, provisioned via Terraform:**
- Amazon Web Services (AWS), EC2 instance (Intel Virtual Machine)
- ~~Google Cloud Platform (GCP), Compute Engine Intel Virtual Machine~~ `[after initial release]`
- IBM Cloud, Intel Virtual Server
- IBM Cloud, IBM Power Virtual Server
- Microsoft Azure, Intel Virtual Machine

**Hypervisors, provisioned via Terraform:**
- IBM PowerVM LPAR
- ~~OVirt / Red Hat Virtualization Virtual Machine~~ `[after initial release]`
- ~~VMware vSphere Virtual Machine~~ `[after initial release]`

**Operating Systems:**
- Red Hat Enterprise Linux for SAP Solutions (RHEL4SAP)
- SUSE Linux Enterprise Server for SAP Applications (SLES4SAP)

**Future SAP solution scenarios:**

There are various suggested/requested SAP solution scenarios under consideration by the SAP LinuxLab open-source team (across multiple SAP Technology Partners), which have been suggested from customers and SAP Service Partners.

While the Ansible Collections for SAP are compatbile with almost any installation (e.g. SAP SolMan, SAP WebDispatcher, SAP BW/4HANA) - our focus in this project is to provide a common end-to-end automated deployment for common scenarios, therefore we are unable to working code for all combinations. For additional detail, see [Disclaimer](#disclaimer) section.

Any contributors who would are available for development and testing of these proposed future SAP solution scenarios in this project are greatly welcomed, please read the [Contributors document](./DEV_CONTRIBUTORS.md). As described in the SAP LinuxLab initiative governance processes, any customer or SAP Partner may submit proposals of new code or direction.

The following list is **`not`** a commitment but is a statement of intent beyond the initial release, the terraform.templates_for_sap project seeks to include in future:

| Proposed future SAP solution scenario | Description |
| --- | --- |
| *SAP HANA multi-node HA/DR installation* | Install of SAP HANA Database Server to multiple virtual machines on a Cloud or Hypervisor, and setup of HA/DR fencing agents and resource agents |
| *SAP HANA multi-node scale-out cluster* installation | Install of SAP HANA Database Server to multiple virtual machines on a Cloud or Hypervisor, and setup of scale-out cluster for OLAP workloads (e.g. SAP BW/4HANA) |
| *SAP S/4HANA distributed installation* | Installation of SAP S/4HANA using SAP HANA Database Server and SAP NetWeaver across multiple virtual machine on a Cloud or Hypervisor |

## Requirements, Dependencies and Testing

### SAP User ID credentials

SAP software installation media must be obtained from SAP directly, and requires valid license agreements with SAP in order to access these files.

An SAP Company Number (SCN) contains one or more Installation Number/s, providing licences for specified SAP Software. When an SAP User ID is created within the SAP Customer Number (SCN), the administrator must provide SAP Download authorizations for the SAP User ID.

When an SAP User ID (e.g. S-User) is enabled with and part of an SAP Universal ID, then the `sap_launchpad` Ansible Collection **must** use:
- the SAP User ID
- the password for login with the SAP Universal ID

In addition, if a SAP Universal ID is used then the recommendation is to check and reset the SAP User ID ‘Account Password’ in the [SAP Universal ID Account Manager](https://account.sap.com/manage/accounts), which will help to avoid any potential conflicts.

### Operating System requirements

The execution/controller host of the Terraform Templates must contain:
- Terraform 1.0+
- Ansible Core 2.11+, may work with Ansible 2.9+ but is not fully tested
- git client
- Python 3+ (i.e. CPython distribution)

### Testing on execution/controller host

**Tests with Ansible Core release versions:**
- Ansible Core 2.11.5 community edition

**Tests with Python release versions:**
- Python 3.9.7 (i.e. CPython distribution)

**Tests with Operating System release versions:**
- macOS 11.6 (Big Sur) and 12.3 (Monterey), with Homebrew used for Python 3.x via PyEnv (using iTerm with Bash 5.1 or Terminal with zsh 5.8)
- Windows 10, November 2021 Update (21H2), with Windows Subsystem for Linux v2 (WSL2) and Ubuntu 20.04
