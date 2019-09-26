###############################################################################
# State Import Example
# terraform output state_import_example
###############################################################################
output "state_import_example" {
  description = "An example to use this layers state in another."

  value = <<EOF

  data "terraform_remote_state" "300scaleset" {
    backend = "azurerm"

    config = {
      storage_account_name = "${data.terraform_remote_state.main_state.outputs.terraform_storage_account_name}"
      container_name       = "${data.terraform_remote_state.main_state.outputs.terraform_storage_container_name}"
      key                  = "terraform.${lower(var.environment)}.300scaleset.tfstate"
    }
  }
EOF
}


###############################################################################
# Summary Output
# terraform output summary
###############################################################################
output "summary" {
  value = <<EOF

## Outputs - 300scaleset layer

| Scaleset | Value |
|---|---| 
|---|---| 


EOF

  description = "300scaleset Layer Outputs Summary `terraform output summary` "
}

/*
| loadbalancer01_public_ip_address | ${module.loadbalancer01.azurerm_public_ip_address[0]} |
*/