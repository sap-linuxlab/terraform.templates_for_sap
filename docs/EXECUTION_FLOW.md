
## Execution workflow structure

Each Terraform Template is for a deployment of a SAP Software solution scenario to a platform, and reuses custom [Terraform Modules for SAP](https://github.com/sap-linuxlab/terraform.modules_for_sap) to provision resources (e.g. host machines) and execute Ansible Playbooks (referencing Ansible Collection Role/s) for configuration of OS and installation of SAP software.

Infrastructure-as-Code (IaC) uses Terraform Templates, and acts as the task runner using `local-exec` and `remote-exec` before/after provisioning; the Configuration-as-Code (CaC) to install SAP Software uses Ansible Playbooks with the injection of variable values from the Terraform Template into the Ansible Playbook (+ Ansible Extra Variables file).

Segregation of definitions for the Infrastructure and SAP Software follows the same delineation:
- Terraform defines the Infrastructure Specification templates
- Ansible defines the SAP Software installation / SAP System templates

For example:
- Terraform file `variable_map_hosts.tf` for an SAP solution scenario (path: ***/<<sap_scenario>>/<<infrastructure_platform>>/***). [See example for SAP HANA install to AWS](../sap_hana_single_node_install/aws_ec2_instance/variable_map_hosts.tf).
- Ansible Variable `sap_swpm_templates_install_dictionary` + Ansible Role `sap_swpm` with "Default Templates mode" (path: ***/templates_for_sap/modules_for_sap/all/ansible_<<sap_scenario>>/`ansible_vars.yml`***). Refer to the [Terraform Modules for SAP example for SAP S/4HANA System Copy](https://github.com/sap-linuxlab/terraform.modules_for_sap/blob/main/all/ansible_sap_s4hana_system_copy_hdb/create_ansible_extravars.tf).


**Breakdown of this modular and nested structure used in end-to-end deployments using Terraform, is shown below:**

- OPTIONAL: Self-Service GUI
  - Terraform Template for SAP solution scenario on Cloud IaaS / Hypervisor
    - Terraform Module for Cloud IaaS / Hypervisor bootstrap (e.g. Networking, DNS, SSH Key, IAM)
    - Terraform Module for Cloud IaaS / Hypervisor hosts
    - Terraform Module for Ansible Playbook execution
      - Ansible Playbook + Ansible Extra Vars (for Terraform Input Variable injections and defined SAP SWPM Ansible Role 'Default Templates')
        - Ansible Collection Role/s
          - Ansible Tasks
            - Ansible Module (built-in for Shell):
              - OS CLI/binaries
              - Vendor CLI/binaries (i.e. SAP Software CLI/binaries)
            - Ansible Modules (custom):
              - Shell scripts --> OS and Vendor CLI/binaries
              - Python scripts

![Terraform execution flow](./docs/terraform_sap_infrastructure_exec_flow.svg)

### Execution process with Self-Service GUI

Self-Service request > Orchestration Pipeline > Terraform (Template > Modules) > Ansible (Playbook > Collection Roles > Modules)

### Execution process with CLI

Terraform (Template > Modules) > Ansible (Playbook > Collection Roles > Modules)
