# Terraform Templates for SAP

Terraform Templates for deployment of various SAP Software solution scenarios onto different Hyperscaler Cloud Service Providers and Hypervisors platforms.

These Terraform Templates for SAP are designed to be simple to understand and highly reconfigurable. Each Terraform Template uses the [Terraform Modules for SAP](https://github.com/sap-linuxlab/terraform.modules_for_sap).

Project is built of two components:
- Infrastructure-as-Code (IaC) for deployment of host infrastructure. Uses Terraform.
- Configuration-as-Code (CaC) for configuraton of OS and installation of SAP Software. Uses Ansible, dynamically altered by Terraform.

# Get started

It is recommended to fully read the README below for context and understanding, before you execute this code.

To get started immediately, requirements:
- Terraform and Ansible installed
- Infrastructure Platform credentials; depending on choice may require OS Vendor subscription
- SAP ONE Support Launchpad credentials, with Software Download privileges
- Optional depending on choice SAP solution scenario: SAP System Copy backup file

<br/>
<details>
  <summary><b>macOS instructions summary:</b></summary>
  
  Tested steps to use Terraform Templates for SAP from local machines running Windows 10:

  1. Install Homebrew, please see documentation: https://docs.brew.sh
      - Install Terraform and Ansible Community Edition (contains ansible-core); such as using `brew install ansible bash gawk jq openssl@1.1 terraform`
  2. Download Terraform Templates for SAP using `curl -L https://github.com/sap-linuxlab/terraform.templates_for_sap/archive/refs/heads/main.zip -o main.zip && tar -xvf main.zip`
  3. Run and follow prompts `./run_terraform.sh`
  4. Once completed, follow output copy/paste to open SSH connection to OS or an SSH tunnel for SAP HANA Studio and SAPGUI
</details>

<br/>

<details>
  <summary><b>Windows OS instructions summary:</b></summary>
  
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

---

## Introduction

This project is designed to be outcome-focused and highly-reusable.

Each Terraform Template is for a pre-defined SAP Software solution scenario on a given Infrastructure Platform, e.g. SAP HANA installation to Microsoft Azure, or SAP ECC on HANA System Copy (Homogeneous) to IBM Cloud.

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
- [the Execution Flow documentation](/docs/EXECUTION_FLOW.md)
- [the Infrastructure Platform guidance to use Terraform Templates for SAP](/docs/INFRASTRUCTURE_GUIDANCE.md)
- [the detailed documentation in Terraform Modules for SAP](https://github.com/sap-linuxlab/terraform.modules_for_sap)

![Terraform execution flow](./docs/terraform_sap_infrastructure_exec_flow.svg)

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

**Solution Architecture scenarios, provisioned via Ansible:**
| Scenario | Description | Infrastructure Platform&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; |
|:--- |:--- |:--- |
| **SAP HANA single-node installation** | Installation of SAP HANA Database Server to a single virtual machine on a Cloud or Hypervisor | <ul><li>:white_check_mark: AWS EC2</li><li>:x: GCP VM</li><li>:white_check_mark: IBM Cloud, Intel VS</li><li>:white_check_mark: IBM Cloud, Power VS</li><li>:white_check_mark: Microsoft Azure</li><li>:white_check_mark: IBM PowerVM LPAR</li><li>:x: OVirt VM</li><li>:x: VMware vSphere VM</li></ul> |
| **SAP S/4HANA single-node installation, using SAP Maintenance Planner** | Installation of SAP S/4HANA using SAP HANA Database Server and SAP NetWeaver to a single virtual machine on a Cloud or Hypervisor | <ul><li>:white_check_mark: AWS EC2</li><li>:x: GCP VM</li><li>:white_check_mark: IBM Cloud, Intel VS</li><li>:white_check_mark: IBM Cloud, Power VS</li><li>:white_check_mark: Microsoft Azure</li><li>:white_check_mark: IBM PowerVM LPAR</li><li>:x: OVirt VM</li><li>:x: VMware vSphere VM</li></ul> |
| **SAP S/4HANA single-node System Copy (Homogeneous with SAP HANA Backup / Recovery) installation** | Installation of SAP S/4HANA from an SAP HANA data backup file and using SAP HANA Database Server and SAP NetWeaver to a single virtual machine on a Cloud or Hypervisor | <ul><li>:warning: AWS EC2</li><li>:x: GCP VM</li><li>:white_check_mark: IBM Cloud, Intel VS</li><li>:white_check_mark: IBM Cloud, Power VS</li><li>:warning: Microsoft Azure</li><li>:warning: IBM PowerVM LPAR</li><li>:x: OVirt VM</li><li>:x: VMware vSphere VM</li></ul> |
| **SAP ECC on SAP HANA single-node System Copy** | Installation of SAP ECC from an SAP HANA data backup file and using SAP HANA Database Server and SAP NetWeaver to a single virtual machine on a Cloud or Hypervisor | <ul><li>:warning: AWS EC2</li><li>:x: GCP VM</li><li>:white_check_mark: IBM Cloud, Intel VS</li><li>:warning: IBM Cloud, Power VS</li><li>:warning: Microsoft Azure</li><li>:warning: IBM PowerVM LPAR</li><li>:x: OVirt VM</li><li>:x: VMware vSphere VM</li></ul> |

Key:
- :white_check_mark: Ready and Tested
- :warning: Pending work; either the Terraform Template has not been created/tested for this SAP solution scenario and infrastructure platform, or work is pending to underlying [Terraform Modules for SAP](https://github.com/sap-linuxlab/terraform.modules_for_sap)
- :x: Not available yet

**Future SAP solution scenarios:**

There are various suggested/requested SAP solution scenarios under consideration by the SAP LinuxLab open-source team (across multiple SAP Technology Partners), which have been suggested from customers and SAP Service Partners.

While the Ansible Collections for SAP are compatbile with almost any installation (e.g. SAP SolMan, SAP WebDispatcher, SAP BW/4HANA) - our focus in this project is to provide a common end-to-end automated deployment for common scenarios, therefore we are unable to working code for all combinations. For additional detail, see [Disclaimer](#disclaimer) section.

Any contributors who would are available for development and testing of these proposed future SAP solution scenarios in this project are greatly welcomed, please read the [Contributors document](/docs/CONTRIBUTORS.md). As described in the SAP LinuxLab initiative governance processes, any customer or SAP Partner may submit proposals of new code or direction.

The following list is **`not`** a commitment but is a statement of intent beyond the initial release, the terraform.templates_for_sap project seeks to include in future:

| Proposed future SAP solution scenario | Description |
| --- | --- |
| *SAP HANA multi-node HA/DR installation* | Install of SAP HANA Database Server to multiple virtual machines on a Cloud or Hypervisor, and setup of HA/DR fencing agents and resource agents |
| *SAP HANA multi-node scale-out cluster* installation | Install of SAP HANA Database Server to multiple virtual machines on a Cloud or Hypervisor, and setup of scale-out cluster for OLAP workloads (e.g. SAP BW/4HANA) |
| *SAP S/4HANA distributed installation* | Installation of SAP S/4HANA using SAP HANA Database Server and SAP NetWeaver across multiple virtual machine on a Cloud or Hypervisor |
| *SAP BW/4HANA single-node installation* | Installation of SAP BW/4HANA using SAP HANA Database Server and SAP NetWeaver to a single virtual machine on a Cloud or Hypervisor |

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
- macOS 11.6 (Big Sur) and 12.3 (Monterey), with Homebrew used for Python 3.x via PyEnv
- Windows 10, November 2021 Update (21H2), with Windows Subsystem for Linux v2 (WSL2) and Ubuntu 20.04

## Disclaimer

These are common SAP solution scenarios which are codified using Infrastructure Automation for SAP (Terraform) and Build Automation for SAP (Ansible). These can be extended as needed for bespoke requirements.

This does not intend (and can not) replicate every SAP software deployment scenario, and does not replace any existing SAP installation procedures detailed in the [SAP Help Portal](https://help.sap.com) or [SAP Notes on SAP ONE Support](https://launchpad.support.sap.com). However, with the Ansible Role for SAP SWPM is possible to install any SAP Software which is supported by SAP Software Provisioning Manager (SWPM 1.0/2.0).

For move-fast activities, such as rapid provisioning and administration testing tasks (latest software releases and revision/patch levels, system copy restore to Cloud etc.), these Terraform Templates for SAP can be amended to suit these requirements.

For greater support in automating the lifecycle of SAP Systems themselves, it is recommended to consider [SAP Landscape Management Enterprise Edition](https://www.sap.com/uk/products/landscape-management.html).

For greater demo and evaluation of SAP Software business functionality, it is recommended to consider [SAP Cloud Appliance Library](https://www.sap.com/products/cloud-appliance-library.html).
