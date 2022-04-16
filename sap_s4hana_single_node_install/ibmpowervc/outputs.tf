
# Export SSH key to file on local
# Use path object to store key files temporarily in root of execution - https://www.terraform.io/docs/language/expressions/references.html#filesystem-and-workspace-info
resource "local_file" "hosts_rsa" {
  content         = module.run_host_bootstrap_module.output_host_private_ssh_key
  filename        = "${path.root}/ssh/hosts_rsa"
  file_permission = "0400"
}


output "ssh_sap_connection_details" {
  value = <<EOF
  
  #### SSH Connections details ####

  target_private_key_file="$PWD/ssh/hosts_rsa"
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
    ssh -i $target_private_key_file root@$target_ip -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null
    fi

  }

  # Then call shell function and select which target
  sshjump

EOF
}


