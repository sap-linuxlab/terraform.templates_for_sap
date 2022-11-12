#!/bin/bash

function terraform_install_check()
{

    if ! command -v terraform &> /dev/null
    then
        echo "terraform CLI binary could not be found"
        echo "!!!! Please install Terraform !!!!"
    fi

}


function ansible_install_check()
{

    if ! command -v ansible &> /dev/null
    then
        echo "ansible CLI binary could not be found"
        echo "!!!! Please install Ansible Core !!!!"
        echo "ALT: Please install Ansible Community Edition, which includes Ansible Core and default community Ansible Collections"
    fi

}


function terraform_version_check()
{
    terraform_version="$(terraform --version | awk 'NR==1{print $2}' | sed 's/v//g')"

    # Simple resolution to version comparison: https://stackoverflow.com/a/37939589/8412427
    function version { echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'; }

    if [ $(version $terraform_version) -lt $(version "1.0.3") ]; then
        echo "Terraform version is $terraform_version"
        echo "Lower Terraform version than tested, may produce unexpected results"
    fi

}


function ansible_version_check()
{
    ansible_version="$(ansible --version | awk 'NR==1{print $3}' | sed 's/]//g')"

    # Simple resolution to version comparison: https://stackoverflow.com/a/37939589/8412427
    function version { echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'; }

    if [ $(version $ansible_version) -lt $(version "2.11.5") ]; then
        echo "Ansible version is $ansible_version"
        echo "Lower Ansible version than tested, may produce unexpected results"
    fi

}


function sap_solution_scenario_choice()
{

    scenario_options=(
        "SAP HANA - Install single node"
        "SAP S/4HANA - Install single node"
        "SAP S/4HANA - Install single node (use Maintenance Planner download)"
        "SAP S/4HANA - System Copy single node (Homogeneous with SAP HANA Backup / Recovery)"
        "SAP BW/4HANA - Install single node"
        "SAP ECC on HANA - System Copy single node (Homogeneous with SAP HANA Backup / Recovery)"
        "SAP ECC on IBM DB2 - Install single node"
        "SAP ECC on Oracle DB - Install single node"
        "SAP ECC on SAP ASE - Install single node"
        "SAP ECC on SAP MaxDB - Install single node"
        "SAP NetWeaver AS (ABAP) with SAP HANA - Install single node"
        "SAP NetWeaver AS (ABAP) with IBM DB2 - Install single node"
        "SAP NetWeaver AS (ABAP) with Oracle DB - Install single node"
        "SAP NetWeaver AS (ABAP) with SAP ASE - Install single node"
        "SAP NetWeaver AS (ABAP) with SAP MaxDB - Install single node"
        "Quit"
    )

    select opt_scenario in "${scenario_options[@]}"
    do
        case $opt_scenario in
            "SAP HANA - Install single node")
                echo ">>> Chosen option $REPLY: $opt_scenario"
                sap_solution_scenario="sap_hana_single_node_install"
                break
                ;;
            "SAP S/4HANA - Install single node")
                echo ">>> Chosen option $REPLY: $opt_scenario"
                sap_solution_scenario="sap_s4hana_single_node_install"
                break
                ;;
            "SAP S/4HANA - Install single node (use Maintenance Planner download)")
                echo ">>> Chosen option $REPLY: $opt_scenario"
                sap_solution_scenario="sap_s4hana_single_node_install_maintenance_plan"
                break
                ;;
            "SAP S/4HANA - System Copy single node (Homogeneous with SAP HANA Backup / Recovery)")
                echo ">>> Chosen option $REPLY: $opt_scenario"
                sap_solution_scenario="sap_s4hana_single_node_system_copy_homogeneous_hdb"
                break
                ;;
            "SAP BW/4HANA - Install single node")
                echo ">>> Chosen option $REPLY: $opt_scenario"
                sap_solution_scenario="sap_bw4hana_single_node_install"
                break
                ;;
            "SAP ECC on HANA - System Copy single node (Homogeneous with SAP HANA Backup / Recovery)")
                echo ">>> Chosen option $REPLY: $opt_scenario"
                sap_solution_scenario="sap_ecc_hana_single_node_system_copy_homogeneous_hdb"
                break
                ;;
            "SAP ECC on IBM DB2 - Install single node")
                echo ">>> Chosen option $REPLY: $opt_scenario"
                sap_solution_scenario="sap_ecc_ibmdb2_single_node_install"
                break
                ;;
            "SAP ECC on Oracle DB - Install single node")
                echo ">>> Chosen option $REPLY: $opt_scenario"
                sap_solution_scenario="sap_ecc_oracledb_single_node_install"
                break
                ;;
            "SAP ECC on SAP ASE - Install single node")
                echo ">>> Chosen option $REPLY: $opt_scenario"
                sap_solution_scenario="sap_ecc_sapase_single_node_install"
                break
                ;;
            "SAP ECC on SAP MaxDB - Install single node")
                echo ">>> Chosen option $REPLY: $opt_scenario"
                sap_solution_scenario="sap_ecc_sapmaxdb_single_node_install"
                break
                ;;
            "SAP NetWeaver AS (ABAP) with SAP HANA - Install single node")
                echo ">>> Chosen option $REPLY: $opt_scenario"
                sap_solution_scenario="sap_nwas_abap_hana_install"
                break
                ;;
            "SAP NetWeaver AS (ABAP) with IBM DB2 - Install single node")
                echo ">>> Chosen option $REPLY: $opt_scenario"
                sap_solution_scenario="sap_nwas_abap_ibmdb2_install"
                break
                ;;
            "SAP NetWeaver AS (ABAP) with Oracle DB - Install single node")
                echo ">>> Chosen option $REPLY: $opt_scenario"
                sap_solution_scenario="sap_nwas_abap_oracledb_install"
                break
                ;;
            "SAP NetWeaver AS (ABAP) with SAP ASE - Install single node")
                echo ">>> Chosen option $REPLY: $opt_scenario"
                sap_solution_scenario="sap_nwas_abap_sapase_install"
                break
                ;;
            "SAP NetWeaver AS (ABAP) with SAP MaxDB - Install single node")
                echo ">>> Chosen option $REPLY: $opt_scenario"
                sap_solution_scenario="sap_nwas_abap_sapmaxdb_install"
                break
                ;;
            "Quit")
                break
                ;;
            *) echo "Invalid option $REPLY";;
        esac
    done

}


function infrastructure_platform_choice()
{

    infrastructure_options=(
        "AWS - EC2 instance"
#        "GCP - Compute Engine Virtual Machine"
        "IBM Cloud - Intel Virtual Server"
        "IBM Cloud - IBM Power Virtual Server"
        "IBM PowerVC - PHYP LPAR"
        "MS Azure - Virtual Machine"
#        "oVirt - Red Hat Virtualization (RHV)"
#        "VMware vSphere - Virtual Machine"
        "Quit"
    )

    select opt_infrastructure in "${infrastructure_options[@]}"
    do
        case $opt_infrastructure in
            "AWS - EC2 instance")
                echo ">>> Chosen option $REPLY: $opt_infrastructure"
                infrastructure_platform="aws_ec2_instance"
                break
                ;;
#            "GCP - Compute Engine Virtual Machine")
#                echo ">>> Chosen option $REPLY: $opt_infrastructure"
#                infrastructure_platform="gcp_ce_vm"
#                break
#                ;;
            "IBM Cloud - Intel Virtual Server")
                echo ">>> Chosen option $REPLY: $opt_infrastructure"
                infrastructure_platform="ibmcloud_vs"
                break
                ;;
            "IBM Cloud - IBM Power Virtual Server")
                echo ">>> Chosen option $REPLY: $opt_infrastructure"
                infrastructure_platform="ibmcloud_powervs"
                break
                ;;
            "IBM PowerVC - PHYP LPAR")
                echo ">>> Chosen option $REPLY: $opt_infrastructure"
                infrastructure_platform="ibmpowervc"
                break
                ;;
            "MS Azure - Virtual Machine")
                echo ">>> Chosen option $REPLY: $opt_infrastructure"
                infrastructure_platform="msazure_vm"
                break
                ;;
#            "oVirt - Red Hat Virtualization (RHV)")
#                echo ">>> Chosen option $REPLY: $opt_infrastructure"
#                infrastructure_platform="ovirt_rhv"
#                break
#                ;;
#            "VMware vSphere - Virtual Machine")
#                echo ">>> Chosen option $REPLY: $opt_infrastructure"
#                infrastructure_platform="vmware"
#                break
#                ;;
            "Quit")
                break
                ;;
            *) echo "Invalid option $REPLY";;
        esac
    done

}


function terraform_tfvars_choice()
{

    vars_options=(
        "No"
        "Yes"
        "Quit"
    )

    select opt_variables in "${vars_options[@]}"
    do
        case $opt_variables in
            "No")
                echo ">>> Chosen option $REPLY: $opt_variables"
                tfvars_enable=0
                break
                ;;
            "Yes")
                echo ">>> Chosen option $REPLY: $opt_variables"
                tfvars_enable=1
                break
                ;;
            "Quit")
                break
                ;;
            *) echo "Invalid option $REPLY";;
        esac
    done

}


# Main

terraform_install_check
ansible_install_check

terraform_version_check
ansible_version_check


echo "----"
echo "Choose your SAP solution scenario"
echo "----"
sap_solution_scenario_choice

printf "\n"
echo "----"
echo "Choose your infrastructure platform: Cloud IaaS or Hypervisor"
echo "----"
infrastructure_platform_choice

printf "\n"
echo "----"
echo "Choose whether to use generic Terraform Variables for this execution?"
echo "--> If No: execution will prompt and require value to be entered for each Terraform Variable"
echo "--> If Yes: execution will use tfvars file"
echo "----"
terraform_tfvars_choice

printf "\n"
echo "----"
echo "Starting Terraform for $sap_solution_scenario $infrastructure_platform"
echo "... running terraform init and terraform apply"
echo "----"
printf "\n"

if [ $tfvars_enable = 0 ]; then
    cd ./$sap_solution_scenario/$infrastructure_platform
    echo "Executing command 'terraform apply'"
    terraform init
    terraform apply
elif [ $tfvars_enable = 1 ]; then
    cd ./$sap_solution_scenario/$infrastructure_platform
    terraform init
    echo "Using the following generic Terraform Variables:"
    echo "----"
    cat variables_generic_for_cli.tfvars
    printf "\n"
    echo "Executing command 'terraform apply -var-file=variables_generic_for_cli.tfvars'"
    echo "Prompting for remaining Terraform Variables:"
    echo "----"
    terraform apply -var-file=variables_generic_for_cli.tfvars
    echo "####"
    printf "\n"
    echo "# Please change your parent shell current directory before executing the SSH commands. Change to the Terraform Template directory:"
    echo "cd ./$sap_solution_scenario/$infrastructure_platform"
fi

