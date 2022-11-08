# Terraform Templates for SAP
![Terraform Validate Tests](https://github.com/sap-linuxlab/terraform.templates_for_sap/actions/workflows/terraform_validate.yml/badge.svg?branch=main)

Deploy various SAP Software solution scenarios onto different Hyperscaler Cloud Service Providers and Hypervisors platforms.

These Terraform Templates for SAP are designed to be:
- simple to understand,
- highly reconfigurable,
- result in an equal installation performed to any Infrastructure Platform (Hyperscaler Cloud Service Providers and Hypervisors platforms),
- use Terraform as Infrastructure-as-Code (IaC),
- and Ansible as Configuration-as-Code (CaC) for configuraton of OS and installation of SAP Software.

**Please read the [full documentation](/docs#readme) for how-to guidance, requirements, and all other details**

---

# Terraform Templates for SAP - available scenarios

| Scenario | Infrastructure Platform |
|:--- |:--- |
| **SAP HANA 2.0 (any version)**<br/>single-node installation | <sub><ul><li>:white_check_mark: AWS EC2</li><li>:white_check_mark: IBM Cloud, Intel VS</li><li>:white_check_mark: IBM Cloud, Power VS</li><li>:white_check_mark: Microsoft Azure</li><li>:white_check_mark: IBM PowerVM LPAR</li></ul>*Coming Soon: GCP VM, OVirt VM, VMware vSphere VM*</sub> |
| **SAP S/4HANA (2020, 2021, 2022)**<br/>single-node installation | <sub><ul><li>:white_check_mark: AWS EC2</li><li>:white_check_mark: IBM Cloud, Intel VS</li><li>:white_check_mark: IBM Cloud, Power VS</li><li>:white_check_mark: Microsoft Azure</li><li>:white_check_mark: IBM PowerVM LPAR</li></ul>*Coming Soon: GCP VM, OVirt VM, VMware vSphere VM*</sub> |
| **SAP S/4HANA (2020, 2021, 2022)**<br/>single-node installation,<br/>using SAP Maintenance Planner Stack XML<br/>(to run SUM and SPAM / SAINT) | <sub><ul><li>:white_check_mark: AWS EC2</li><li>:white_check_mark: IBM Cloud, Intel VS</li><li>:white_check_mark: IBM Cloud, Power VS</li><li>:white_check_mark: Microsoft Azure</li><li>:white_check_mark: IBM PowerVM LPAR</li></ul>*Coming Soon: GCP VM, OVirt VM, VMware vSphere VM*</sub> |
| **SAP S/4HANA (1909, 2020, 2021, 2022)**<br/>single-node System Copy installation</br>(Homogeneous with SAP HANA Backup / Recovery) | <sub><ul><li>:warning: AWS EC2</li><li>:white_check_mark: IBM Cloud, Intel VS</li><li>:white_check_mark: IBM Cloud, Power VS</li><li>:warning: Microsoft Azure</li><li>:warning: IBM PowerVM LPAR</li></ul>*Coming Soon: GCP VM, OVirt VM, VMware vSphere VM*</sub> |
| **SAP BW/4HANA (2021)**<br/>single-node installation | <sub><ul><li>:white_check_mark: AWS EC2</li><li>:white_check_mark: IBM Cloud, Intel VS</li><li>:white_check_mark: IBM Cloud, Power VS</li><li>:white_check_mark: Microsoft Azure</li><li>:white_check_mark: IBM PowerVM LPAR</li></ul>*Coming Soon: GCP VM, OVirt VM, VMware vSphere VM*</sub> |
| **SAP ECC on SAP HANA (EHP7, EHP8)**<br/>single-node System Copy installation</br>(Homogeneous with SAP HANA Backup / Recovery) | <sub><ul><li>:warning: AWS EC2</li><li>:white_check_mark: IBM Cloud, Intel VS</li><li>:white_check_mark: IBM Cloud, Power VS</li><li>:warning: Microsoft Azure</li><li>:warning: IBM PowerVM LPAR</li></ul>*Coming Soon: GCP VM, OVirt VM, VMware vSphere VM*</sub> |
| **SAP ECC on IBM Db2 (EHP7, EHP8)**<br/>single-node installation | <sub><ul><li>:warning: AWS EC2</li><li>:white_check_mark: IBM Cloud, Intel VS</li><li>:white_check_mark: IBM Cloud, Power VS</li><li>:warning: Microsoft Azure</li><li>:warning: IBM PowerVM LPAR</li></ul>*Coming Soon: GCP VM, OVirt VM, VMware vSphere VM*</sub> |
| **SAP ECC on Oracle DB (EHP7, EHP8)**<br/>single-node installation | <sub><ul><li>:warning: AWS EC2</li><li>:white_check_mark: IBM Cloud, Intel VS</li><li>:white_check_mark: IBM Cloud, Power VS</li><li>:warning: Microsoft Azure</li><li>:warning: IBM PowerVM LPAR</li></ul>*Coming Soon: GCP VM, OVirt VM, VMware vSphere VM*</sub> |
| **SAP ECC on SAP ASE (EHP7, EHP8)**<br/>single-node installation | <sub><ul><li>:warning: AWS EC2</li><li>:white_check_mark: IBM Cloud, Intel VS</li><li>:white_check_mark: IBM Cloud, Power VS</li><li>:warning: Microsoft Azure</li><li>:warning: IBM PowerVM LPAR</li></ul>*Coming Soon: GCP VM, OVirt VM, VMware vSphere VM*</sub> |
| **SAP ECC on SAP MaxDB (EHP7, EHP8)**<br/>single-node installation | <sub><ul><li>:warning: AWS EC2</li><li>:white_check_mark: IBM Cloud, Intel VS</li><li>:white_check_mark: IBM Cloud, Power VS</li><li>:warning: Microsoft Azure</li><li>:warning: IBM PowerVM LPAR</li></ul>*Coming Soon: GCP VM, OVirt VM, VMware vSphere VM*</sub> |
| **SAP NetWeaver AS (ABAP) with SAP HANA (7.50, 7.52)**<br/>single-node installation | <sub><ul><li>:warning: AWS EC2</li><li>:white_check_mark: IBM Cloud, Intel VS</li><li>:white_check_mark: IBM Cloud, Power VS</li><li>:warning: Microsoft Azure</li><li>:warning: IBM PowerVM LPAR</li></ul>*Coming Soon: GCP VM, OVirt VM, VMware vSphere VM*</sub> |
| **SAP NetWeaver AS (ABAP) with IBM Db2 (7.50, 7.52)**<br/>single-node installation | <sub><ul><li>:warning: AWS EC2</li><li>:white_check_mark: IBM Cloud, Intel VS</li><li>:white_check_mark: IBM Cloud, Power VS</li><li>:warning: Microsoft Azure</li><li>:warning: IBM PowerVM LPAR</li></ul>*Coming Soon: GCP VM, OVirt VM, VMware vSphere VM*</sub> |
| **SAP NetWeaver AS (ABAP) with Oracle DB (7.50, 7.52)**<br/>single-node installation | <sub><ul><li>:warning: AWS EC2</li><li>:white_check_mark: IBM Cloud, Intel VS</li><li>:white_check_mark: IBM Cloud, Power VS</li><li>:warning: Microsoft Azure</li><li>:warning: IBM PowerVM LPAR</li></ul>*Coming Soon: GCP VM, OVirt VM, VMware vSphere VM*</sub> |
| **SAP NetWeaver AS (ABAP) with SAP ASE (7.50, 7.52)**<br/>single-node installation | <sub><ul><li>:warning: AWS EC2</li><li>:white_check_mark: IBM Cloud, Intel VS</li><li>:white_check_mark: IBM Cloud, Power VS</li><li>:warning: Microsoft Azure</li><li>:warning: IBM PowerVM LPAR</li></ul>*Coming Soon: GCP VM, OVirt VM, VMware vSphere VM*</sub> |
| **SAP NetWeaver AS (ABAP) with SAP MaxDB (7.50, 7.52)**<br/>single-node installation | <sub><ul><li>:warning: AWS EC2</li><li>:white_check_mark: IBM Cloud, Intel VS</li><li>:white_check_mark: IBM Cloud, Power VS</li><li>:warning: Microsoft Azure</li><li>:warning: IBM PowerVM LPAR</li></ul>*Coming Soon: GCP VM, OVirt VM, VMware vSphere VM*</sub> |

## Disclaimer

These are common SAP solution scenarios which are codified using Infrastructure Automation for SAP (Terraform) and Build Automation for SAP (Ansible). These can be extended as needed for bespoke requirements.

This does not intend (and can not) replicate every SAP software deployment scenario, and does not replace any existing SAP installation procedures detailed in the [SAP Help Portal](https://help.sap.com) or [SAP Notes on SAP ONE Support](https://launchpad.support.sap.com). However, with the Ansible Role for SAP SWPM it is possible to install any SAP Software which is supported by SAP Software Provisioning Manager (SWPM 1.0/2.0).

For move-fast activities, such as rapid provisioning and administration testing tasks (latest software releases and revision/patch levels, system copy restore to Cloud etc.), these Terraform Templates for SAP can be amended to suit these requirements.

For greater support in automating the lifecycle of SAP Systems themselves, it is recommended to consider [SAP Landscape Management Enterprise Edition](https://www.sap.com/uk/products/landscape-management.html).

For greater demo and evaluation of SAP Software business functionality, it is recommended to consider [SAP Cloud Appliance Library](https://www.sap.com/products/cloud-appliance-library.html).
