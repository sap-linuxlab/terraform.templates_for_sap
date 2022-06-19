
# Export SSH key to file on local
# Use path object to store key files temporarily in root of execution - https://www.terraform.io/docs/language/expressions/references.html#filesystem-and-workspace-info
resource "local_file" "hosts_rsa" {
  content         = module.run_host_bootstrap_module.output_host_private_ssh_key
  filename        = "${path.root}/ssh/hosts_rsa"
  file_permission = "0400"
}


output "ssh_sap_connection_details" {
  value = local.detect_windows ? "IGNORE" : <<EOF

#### SSH Connections details ####

####
#### Copy/Paste the below into your shell for easy login, and run 'sshjump' afterwards
####

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



output "ssh_sap_connection_details_windows" {
  value = local.detect_shell ? "IGNORE" : <<EOF

#### PowerShell and Windows 10 OpenSSH client and SSH Connections details ####

####
#### Copy/Paste the below into your PowerShell for easy login, and run 'sshjump' afterwards
####

$target_private_key_file = "$(pwd)\ssh\hosts_rsa"
$target_host_array = @(${join(",", flatten([for key, value in module.run_host_provision_module : value.*.output_host_private_ip]))} "Quit")


function sshjump {

foreach ($target_host in $target_host_array) {
    $i=$target_host_array.IndexOf($target_host)
    echo "$i) $target_host"
}
$target_host_selection = Read-Host "Please make a selection"
if ($target_host_array[$target_host_selection] -eq "Quit" ){
    exit
}else {
    $target_ip = $target_host_array[$target_host_selection]
    #echo ">>> Chosen option $(PSItem)"
    ssh -i $target_private_key_file root@$target_ip -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null `
    -o ProxyCommand="ssh -W %h:%p $bastion_user@$bastion_host -p $bastion_port -i $bastion_private_key_file `
    -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
}

EOF

}
