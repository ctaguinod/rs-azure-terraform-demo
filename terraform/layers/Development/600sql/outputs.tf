###############################################################################
# State Import Example
# terraform output state_import_example
###############################################################################
output "state_import_example" {
  description = "An example to use this layers state in another."

  value = <<EOF

  data "terraform_remote_state" "600sql" {
    backend = "azurerm"

    config = {
      storage_account_name = "${data.terraform_remote_state.main_state.outputs.terraform_storage_account_name}"
      container_name       = "${data.terraform_remote_state.main_state.outputs.terraform_storage_container_name}"
      key                  = "terraform.${lower(var.environment)}.600sql.tfstate"
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

## Outputs - 600sql layer

| * | Value |
|---|---|
|---|---|

EOF

  description = "600sql Layer Outputs Summary `terraform output summary` "
}
