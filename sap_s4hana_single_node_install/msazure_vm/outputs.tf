
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
  #### Copy/Paste the below into your shell for easy login
  ####


  bastion_private_key_file="$PWD/ssh/bastion_rsa"
  target_private_key_file="$PWD/ssh/hosts_rsa"
  
  bastion_user="bastionuser"
  bastion_host="${module.run_bastion_inject_module.output_bastion_ip}"
  bastion_port="${var.bastion_ssh_port}"
  target_host_array=(${join(" ", flatten([for key, value in module.run_host_provision_module : value.*.output_host_private_ip]))} "Quit")

  function sshjump() {
    select opt in "$${target_host_array[@]}"
    do
        if [ $opt == "Quit" ]; then exit; fi
        target_ip=$opt
        echo "---- Selected option $REPLY, logging into $target_ip ----"
        break
    done

    if [ -n "$target_ip" ]
    then
    ssh -i $target_private_key_file root@$target_ip -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
        -o ProxyCommand="ssh -W %h:%p $bastion_user@$bastion_host -p $bastion_port -i $bastion_private_key_file -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
    fi

  }

  # Then call shell function and select which target
  sshjump

EOF
}

