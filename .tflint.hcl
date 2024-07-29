# General configuration
module = true
force = false
disabled_by_default = false
varfile = ["example1.tfvars", "example2.tfvars"]

# Plugin configuration for Azure
plugin "azurerm" {
  enabled = true
  version = "0.2.1"  # Use the appropriate version for your setup
  source = "github.com/terraform-linters/tflint-ruleset-azurerm"
}

# Rule configuration for Azure
rule "azurerm_resource_group_location" {
  enabled = false
}
