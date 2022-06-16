
##############################################################
# Export SSH key to file on local
##############################################################

# Use path object to store key files temporarily in root of execution  - https://www.terraform.io/docs/language/expressions/references.html#filesystem-and-workspace-info
resource "local_file" "bastion_rsa" {
  content         = module.run_account_bootstrap_module.output_bastion_private_ssh_key
  filename        = "${path.root}/ssh/bastion_rsa"
  file_permission = "0400"
}

# Use path object to store key files temporarily in root of execution - https://www.terraform.io/docs/language/expressions/references.html#filesystem-and-workspace-info
resource "local_file" "hosts_rsa" {
  content         = module.run_account_bootstrap_module.output_host_private_ssh_key
  filename        = "${path.root}/ssh/hosts_rsa"
  file_permission = "0400"
}


output "ssh_sap_connection_details" {
  value = <<EOF

#### SSH Connections details ####

SSH Remote connection requires on origin/local (from where **ssh** is executed):
- bastion_rsa key file
- hosts_rsa key file

SSH Connection using:
- Bastion Private key on local
- VS SSH Private Key on local
- ProxyCommand with stdin/stdout forwarding (-W) mode to "bounce" the connection through a bastion host on specified port


####
#### Copy/Paste the below into your shell for easy login, and run 'sshjump' afterwards
####

bastion_private_key_file="$PWD/ssh/bastion_rsa"
target_private_key_file="$PWD/ssh/hosts_rsa"

bastion_user="bastionuser"
bastion_host="${module.run_bastion_inject_module.output_bastion_ip}"
bastion_port="${var.bastion_ssh_port}"
target_host_array=(${join(" ", flatten([for key, value in module.run_host_provision_module : value.*.output_host_private_ip]))} "Quit")

sap_hana_instance_no="${var.sap_hana_install_instance_number}"
sap_nwas_pas_instance_no="${var.sap_nwas_pas_instance_no}"


function sshjump() {

    options=(
        "SAP HANA Studio or SAPGUI, via SSH port forward binding proxy"
        "OS root access, via SSH stdin/stdout forwarding proxy"
        "Quit"
    )

    select opt in "$${options[@]}"; do
        case $opt in
        "SAP HANA Studio or SAPGUI, via SSH port forward binding proxy")
            echo ">>> Chosen option $REPLY: $opt"
            select opt in "$${target_host_array[@]}"; do
                if [ $opt == "Quit" ]; then exit; fi
                target_ip=$opt
                echo "---- Selected option $REPLY, tunneling into $target_ip ----"
                break
            done
            echo ""
            echo "#### For SAP HANA Studio, use Add System with host name as localhost; do not add port numbers."
            echo "#### If selecting 'Connect using SSL' on Connection Properties, then on Additional Properties (final) screen deselect 'Validate the SSL certificate'"
            echo ""
            echo "#### For SAPGUI, use expert mode SAP Logon String as: ####"
            echo "conn=/H/localhost/S/32$sap_nwas_pas_instance_no&expert=true"
            echo ""
            # SSH port forward binding, using -L local_host:local_port:remote_host:remote_port [add -vv for debugging]
            ssh -N \
                $bastion_user@$bastion_host -p $bastion_port -i $bastion_private_key_file \
                -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
                -L localhost:32$sap_nwas_pas_instance_no:$target_ip:32$sap_nwas_pas_instance_no \
                -L localhost:33$sap_nwas_pas_instance_no:$target_ip:33$sap_nwas_pas_instance_no \
                -L localhost:3$${sap_hana_instance_no}13:$target_ip:3$${sap_hana_instance_no}13 \
                -L localhost:3$${sap_hana_instance_no}15:$target_ip:3$${sap_hana_instance_no}15 \
                -L localhost:3$${sap_hana_instance_no}41:$target_ip:3$${sap_hana_instance_no}41 \
                -L localhost:443$sap_hana_instance_no:$target_ip:443$sap_hana_instance_no \
                -L localhost:443$sap_nwas_pas_instance_no:$target_ip:443$sap_nwas_pas_instance_no \
                -L localhost:5$${sap_hana_instance_no}13:$target_ip:5$${sap_hana_instance_no}13 \
                -L localhost:5$${sap_hana_instance_no}14:$target_ip:5$${sap_hana_instance_no}14
            break
            ;;
        "OS root access, via SSH stdin/stdout forwarding proxy")
            echo ">>> Chosen option $REPLY: $opt"
            select opt in "$${target_host_array[@]}"; do
                if [ $opt == "Quit" ]; then exit; fi
                target_ip=$opt
                echo "---- Selected option $REPLY, logging into $target_ip ----"
                break
            done

            if [ -n "$target_ip" ]; then
                ssh -i $target_private_key_file root@$target_ip -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
                    -o ProxyCommand="ssh -W %h:%p $bastion_user@$bastion_host -p $bastion_port -i $bastion_private_key_file -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
            fi
            break
            ;;
        "Quit")
            exit
            ;;
        *) echo "Invalid option $REPLY" ;;
        esac
    done
}

# Then call shell function and select which target
sshjump

EOF
}

