
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
  value = local.is_wsl ? "IGNORE" : <<EOF

#### SSH Connections details ####

SSH Remote connection requires on origin/local (from where **ssh** is executed):
- bastion_rsa key file
- hosts_rsa key file

SSH Connection using:
- Bastion Private key on local
- Hosts SSH Private Key on local
- ProxyCommand with stdin/stdout forwarding (-W) mode to "bounce" the connection through a bastion host on specified port


####
#### Copy/Paste the below into your shell for easy login, and run 'sshjump' afterwards
####

bastion_private_key_file="$PWD/ssh/bastion_rsa"
target_private_key_file="$PWD/ssh/hosts_rsa"

bastion_user="${var.bastion_user}"
bastion_host="${module.run_bastion_inject_module.output_bastion_ip}"
bastion_port="${var.bastion_ssh_port}"
target_host_array=(${join(" ", flatten([for key, value in module.run_host_provision_module : value.*.output_host_private_ip]))} "Quit")

sap_hana_instance_no="${var.sap_hana_install_instance_number}"
sap_nwas_abap_pas_instance_no="${var.sap_nwas_abap_pas_instance_no}"


function sshjump() {

    ssh_options=(
        "SAP HANA Studio, via SSH port forward binding proxy"
        "OS root access, via SSH stdin/stdout forwarding proxy"
        "Quit"
    )

    select opt in "$${ssh_options[@]}"; do
        case $opt in
        "SAP HANA Studio or SAPGUI, via SSH port forward binding proxy")
            echo ">>> Chosen option $REPLY: $opt"
            select opt_ip in "$${target_host_array[@]}"; do
                if [ $opt_ip = "Quit" ]; then break 2; fi
                target_ip=$opt_ip
                echo "---- Selected option $REPLY, tunneling into $target_ip ----"
                break
            done
            echo ""
            echo "#### For SAP HANA Studio, use Add System with host name as localhost; do not add port numbers."
            echo "#### If selecting 'Connect using SSL' on Connection Properties, then on Additional Properties (final) screen deselect 'Validate the SSL certificate'"
            echo ""
            echo "#### For SAPGUI, use expert mode SAP Logon String as: ####"
            echo "conn=/H/localhost/S/32$sap_nwas_abap_pas_instance_no&expert=true"
            echo ""
            # SSH port forward binding, using -L local_host:local_port:remote_host:remote_port (add -vv for debugging)
            ssh -N \
                $bastion_user@$bastion_host -p $bastion_port -i $bastion_private_key_file \
                -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
                -L localhost:32$sap_nwas_abap_pas_instance_no:$target_ip:32$sap_nwas_abap_pas_instance_no \
                -L localhost:33$sap_nwas_abap_pas_instance_no:$target_ip:33$sap_nwas_abap_pas_instance_no \
                -L localhost:3$${sap_hana_instance_no}13:$target_ip:3$${sap_hana_instance_no}13 \
                -L localhost:3$${sap_hana_instance_no}15:$target_ip:3$${sap_hana_instance_no}15 \
                -L localhost:3$${sap_hana_instance_no}41:$target_ip:3$${sap_hana_instance_no}41 \
                -L localhost:443$sap_hana_instance_no:$target_ip:443$sap_hana_instance_no \
                -L localhost:443$sap_nwas_abap_pas_instance_no:$target_ip:443$sap_nwas_abap_pas_instance_no \
                -L localhost:5$${sap_hana_instance_no}13:$target_ip:5$${sap_hana_instance_no}13 \
                -L localhost:5$${sap_hana_instance_no}14:$target_ip:5$${sap_hana_instance_no}14
            break
            ;;
        "OS root access, via SSH stdin/stdout forwarding proxy")
            echo ">>> Chosen option $REPLY: $opt"
            select opt_ssh in "$${target_host_array[@]}"; do
                if [ $opt_ssh = "Quit" ]; then break 2; fi
                target_ip=$opt_ssh
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
            break
            ;;
        *) echo "Invalid option $REPLY" ;;
        esac
    done
}

# Then call shell function and select which target
sshjump

EOF
}


# If detected Windows WSL2, then find the installed name using external resource to return a JSON string
data "external" "wsl_distro_name" {
  count = local.is_wsl ? 1 : 0
  program = ["bash", "-c", "echo \"{\\\"stdout\\\":\\\"$(echo $WSL_DISTRO_NAME)\\\"}\""]
}

output "ssh_sap_connection_details_windows" {
  value = local.not_wsl ? "IGNORE" : <<EOF

#### PowerShell and Windows 10 OpenSSH client and SSH Connections details ####

SSH Remote connection requires on origin/local (from where **ssh** is executed):
- bastion_rsa key file
- hosts_rsa key file

SSH Connection using:
- Bastion Private key on local
- Hosts SSH Private Key on local
- ProxyCommand with stdin/stdout forwarding (-W) mode to "bounce" the connection through a bastion host on specified port


####
#### Copy/Paste the below into your PowerShell for easy login, and run 'sshjump' afterwards
####

$bastion_private_key_file = "\\wsl$\${data.external.wsl_distro_name[0].result.stdout}${replace(join("",[abspath(path.root),"\\ssh\\bastion_rsa"]),"/","\\")}"
$target_private_key_file = "\\wsl$\${data.external.wsl_distro_name[0].result.stdout}${replace(join("",[abspath(path.root),"\\ssh\\hosts_rsa"]),"/","\\")}"

$bastion_user = "${var.bastion_user}"
$bastion_host = "${module.run_bastion_inject_module.output_bastion_ip}"
$bastion_port = "${var.bastion_ssh_port}"
$target_host_string = "${join("','",flatten([for key, value in module.run_host_provision_module : value.*.output_host_private_ip]))}"
$target_host_array = @($target_host_string.Split(","),"Quit")

$sap_hana_instance_no = "${var.sap_hana_install_instance_number}"
$sap_nwas_abap_pas_instance_no = "${var.sap_nwas_abap_pas_instance_no}"


function sshjump {

    echo '1) SAP HANA Studio or SAPGUI, via SSH port forward binding proxy'
    echo '2) OS root access, via SSH stdin/stdout forwarding proxy'
    echo '3) Quit'

    $selection = Read-Host "Please make a selection"

    echo "Creating ssh_keys temporary directory in $env:userprofile"
    New-Item -Path "$env:userprofile\ssh_keys" -ItemType "directory" -Force
    echo "Copying SSH Private Keys output from Terraform Template executed using WSL2 and Ubuntu"
    Copy-Item $bastion_private_key_file -Destination "$env:userprofile\ssh_keys" -force
    Copy-Item $target_private_key_file -Destination "$env:userprofile\ssh_keys" -force
    $temp_bastion_private_key_file = "$env:userprofile\ssh_keys\bastion_rsa"
    $temp_target_private_key_file = "$env:userprofile\ssh_keys\hosts_rsa"

    switch ( $selection )
    {
        1 {
            foreach ($target_host in $target_host_array) {
                $i=$target_host_array.IndexOf($target_host)
                echo "$i. $target_host"
            }
            $target_host_selection = Read-Host "Please make a selection"
            if ($target_host_array[$target_host_selection] -eq "Quit" ){
                break
            }else {
                $target_ip = $target_host_array[$target_host_selection]
                #echo ">>> Chosen option $(PSItem)"
                echo ""
                echo "#### For SAP HANA Studio, use Add System with host name as localhost; do not add port numbers."
                echo "#### If selecting 'Connect using SSL' on Connection Properties, then on Additional Properties (final) screen deselect 'Validate the SSL certificate'"
                echo ""
                echo "#### For SAPGUI, use expert mode SAP Logon String as: ####"
                echo "conn=/H/localhost/S/32$sap_nwas_abap_pas_instance_no&expert=true"
                echo ""
                # SSH port forward binding, using -L local_host:local_port:remote_host:remote_port (add -vv for debugging)
                ssh -N `
                $bastion_user@$bastion_host -p $bastion_port -i $temp_bastion_private_key_file `
                -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null `
                -L localhost:32$${sap_nwas_abap_pas_instance_no}:$${target_ip}:32$${sap_nwas_abap_pas_instance_no} `
                -L localhost:33$${sap_nwas_abap_pas_instance_no}:$${target_ip}:33$${sap_nwas_abap_pas_instance_no} `
                -L localhost:3$${sap_hana_instance_no}13:$${target_ip}:3$${sap_hana_instance_no}13 `
                -L localhost:3$${sap_hana_instance_no}15:$${target_ip}:3$${sap_hana_instance_no}15 `
                -L localhost:3$${sap_hana_instance_no}41:$${target_ip}:3$${sap_hana_instance_no}41 `
                -L localhost:443$${sap_hana_instance_no}:$${target_ip}:443$${sap_hana_instance_no} `
                -L localhost:443$${sap_nwas_abap_pas_instance_no}:$${target_ip}:443$${sap_nwas_abap_pas_instance_no} `
                -L localhost:5$${sap_hana_instance_no}13:$${target_ip}:5$${sap_hana_instance_no}13 `
                -L localhost:5$${sap_hana_instance_no}14:$${target_ip}:5$${sap_hana_instance_no}14
            }
        }
        2 {
            foreach ($target_host in $target_host_array) {
                $i=$target_host_array.IndexOf($target_host)
                echo "$i) $target_host"
            }
            $target_host_selection = Read-Host "Please make a selection"
            if ($target_host_array[$target_host_selection] -eq "Quit" ){
                break
            }else {
                $target_ip = $target_host_array[$target_host_selection]
                #echo ">>> Chosen option $(PSItem)"
                ssh -i $temp_target_private_key_file root@$target_ip -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null `
                -o ProxyCommand="ssh -W %h:%p $bastion_user@$bastion_host -p $bastion_port -i $temp_bastion_private_key_file `
                -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
            }
        }
        3 {
            break
        }
    }
}

EOF

}
