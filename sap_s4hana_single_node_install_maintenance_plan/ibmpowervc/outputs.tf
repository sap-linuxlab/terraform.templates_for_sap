
# Export SSH key to file on local
# Use path object to store key files temporarily in root of execution - https://www.terraform.io/docs/language/expressions/references.html#filesystem-and-workspace-info
resource "local_file" "hosts_rsa" {
  content         = module.run_host_bootstrap_module.output_host_private_ssh_key
  filename        = "${path.root}/ssh/hosts_rsa"
  file_permission = "0400"
}


output "ssh_sap_connection_details" {
  value = local.is_wsl ? "IGNORE" : <<EOF

#### SSH Connections details ####

####
#### Copy/Paste the below into your shell for easy login, and run 'sshjump' afterwards
####

target_private_key_file="$PWD/ssh/hosts_rsa"
target_host_array=(${join(" ", flatten([for key, value in module.run_host_provision_module : value.*.output_host_private_ip]))} "Quit")


function sshjump() {
    select opt in "$${target_host_array[@]}"
    do
        if [ $opt = "Quit" ]; then break; fi
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


# If detected Windows WSL2, then find the installed name using external resource to return a JSON string
data "external" "wsl_distro_name" {
  count = local.is_wsl ? 1 : 0
  program = ["bash", "-c", "echo \"{\\\"stdout\\\":\\\"$(echo $WSL_DISTRO_NAME)\\\"}\""]
}

output "ssh_sap_connection_details_windows" {
  value = local.not_wsl ? "IGNORE" : <<EOF

#### PowerShell and Windows 10 OpenSSH client and SSH Connections details ####

####
#### Copy/Paste the below into your PowerShell for easy login, and run 'sshjump' afterwards
####

$target_private_key_file = "\\wsl$\${data.external.wsl_distro_name[0].result.stdout}${replace(join("",[abspath(path.root),"\\ssh\\hosts_rsa"]),"/","\\")}"
$target_host_string = "${join("','",flatten([for key, value in module.run_host_provision_module : value.*.output_host_private_ip]))}"
$target_host_array = @($target_host_string.Split(","),"Quit")

function sshjump {

echo "Creating ssh_keys temporary directory in $env:userprofile"
New-Item -Path "$env:userprofile\ssh_keys" -ItemType "directory" -Force
echo "Copying SSH Private Keys output from Terraform Template executed using WSL2 and Ubuntu"
Copy-Item $bastion_private_key_file -Destination "$env:userprofile\ssh_keys" -force
Copy-Item $target_private_key_file -Destination "$env:userprofile\ssh_keys" -force
$temp_bastion_private_key_file = "$env:userprofile\ssh_keys\bastion_rsa"
$temp_target_private_key_file = "$env:userprofile\ssh_keys\hosts_rsa"

foreach ($target_host in $target_host_array) {
    $i=$target_host_array.IndexOf($target_host)
    echo "$i) $target_host"
}
$target_host_selection = Read-Host "Please make a selection"
if ($target_host_array[$target_host_selection] -eq "Quit" ){
    break
}else {
    $target_ip = $target_host_array[$target_host_selection]
    ssh -i $temp_target_private_key_file root@$target_ip -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null
}

EOF

}
