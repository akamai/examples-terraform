# akamai.tf
# version 1.0.0
# This Terraform configuration functions as the top level configuration that sources the Akamai Terraform Provider and handles authentication with Akamai EdgeGrid API tokens.
# For more information on Akamai EdgeGrid and authenticating the Akamai Terraform Provider: https://techdocs.akamai.com/developer/docs/authenticate-with-edgegrid

# Terraform block used to configure some high-level behaviors of Terraform.
terraform {
    
    # What provider version to use within this configuration and where to source it from.
    required_providers {
        akamai = { 
            source = "akamai/akamai" 
    }
  }

  # Constraint to specify which versions of Terraform can be used with this configuration.
  required_version = ">= 1.0.0"
}

# A provider block is used to specify a provider configuration.
provider "akamai" {
    
    # edgerc refers to the Akamai EdgeGrid authentication file that contains your Akamai API tokens. Typically ~/.edgerc.
    edgerc = "~/.edgerc"

    # config_section refers to the section inside the edgerc file which can contain multiple sets of Akamai API tokens. Typically default.
    config_section = var.edgerc_config_section
}

# variable edgerc_config_section to define which config_section to use inside the edgerc file. Typically added in akamai.auto.tfvars.
variable "edgerc_config_section" { }

# variable contract_id reflects your Akamai Contract ID.
variable "contract_id" { }

# variable group_name reflects the name of your group you want to store your config. Groups are part of an Akamai contract.
variable "group_name" { }