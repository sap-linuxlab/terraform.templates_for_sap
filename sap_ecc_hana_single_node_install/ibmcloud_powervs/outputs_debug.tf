
##############################################################
# DEBUG variable map
##############################################################

# Show all Storage Test Template names defined
#output "DEBUG_show_storage_test_template_names_all" {
#  value = [
#    for key, value in var.storage_test_templates_map : key
#  ]
#}

# Show each Storage Test Template object, and all the variables set therein
#output "DEBUG_show_storage_test_template_all_variables" {
#  value = [
#    for key, value in var.storage_test_templates_map : value
#  ]
#}

# Show value for specific variable within each Storage Test Template object
#output "DEBUG_show_template_value_single_all_items" {
#  value = [
#    for key, value in var.storage_test_templates_map : value.*.disk_volume_count_hana_data
#  ]
#}

# Show value for specific variable within each Storage Test Template, and de-duplicate e.g. unique Virtual Server Profiles used in the Storage Test Templates
#output "DEBUG_show_storage_test_template_profiles_condense" {
#  value = toset([
#    for key, value in var.storage_test_templates_map : value.*.virtual_server_profile
#  ])
#}


# Show value for specific output from module output in one string
#output "DEBUG_show_host_storage_test_module_output_private_ip_one_string" {
#  value = join(" ", flatten([for key, value in module.run_host_storage_test_template_provision_module: value.*.output_host_private_ip]))
#}



##############################################################
# DEBUG Bastion - Display key values, shown after successful execution
##############################################################

#output "bastion_display_private_key" {
#  value = "\n${tls_private_key.bastion_ssh.private_key_pem}"
#  sensitive = true
#}

#output "bastion_display_public_key" {
#  value = "public_key_openssh is:\n ${tls_private_key.bastion_ssh.public_key_openssh}"
#}

##############################################################
# DEBUG Bastion - Display key values, shown before execution but with poor output
##############################################################

#resource "null_resource" "bastion_show_keys" {
#  provisioner "local-exec" {
#    command = "echo '${tls_private_key.bastion_ssh.private_key_pem}'"
#  }
#  provisioner "local-exec" {
#    command = "echo '${tls_private_key.bastion_ssh.public_key_openssh}'"
#  }
#}

##############################################################
# DEBUG target - Display key values, shown after successful execution
##############################################################

#output "virtual_server_display_private_key" {
#  value = "\n${tls_private_key.virtual_server_ssh.private_key_pem}"
#  sensitive = true
#}

#output "virtual_server_display_public_key" {
#  value = "public_key_openssh:\n ${tls_private_key.virtual_server_ssh.public_key_openssh}"
#}

##############################################################
# DEBUG target - Display key values, shown before execution but with poor output
##############################################################

#resource "null_resource" "host_show_keys" {
#  provisioner "local-exec" {
#    command = "echo '${tls_private_key.virtual_server_ssh.private_key_pem}'"
#  }
#  provisioner "local-exec" {
#    command = "echo '${tls_private_key.virtual_server_ssh.public_key_openssh}'"
#  }
#}