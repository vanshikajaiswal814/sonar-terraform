# Plugin configuration for Azure
plugin "azurerm" {
  enabled = true
  version = "0.2.1"  # Ensure this version is correct and available
  source = "github.com/terraform-linters/tflint-ruleset-azurerm"
}

# Rule configuration for Azure
rule "azurerm_resource_group_location" {
  enabled = false  # Make sure this rule name is correct
}
