plugin "aws" {
  enabled = true
}

plugin "azurerm" {
  enabled = true
}

plugin "google" {
  enabled = true
}

# Add any other necessary plugins here

config {
  # Enable the built-in rules you need
  enable_rule = [
    "aws_instance_invalid_type",
    "azurerm_resource_group_name",
    "google_compute_instance_invalid_type",
  ]

  # Optionally, disable specific rules
  disable_rule = [
    "aws_instance_default_type"
  ]
}
