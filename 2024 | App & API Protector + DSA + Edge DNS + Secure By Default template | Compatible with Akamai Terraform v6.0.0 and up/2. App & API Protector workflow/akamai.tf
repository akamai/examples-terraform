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
            version = ">= 6.0.0"
    }
  }

  # Constraint to specify which versions of Terraform can be used with this configuration.
  required_version = ">= 1.0.0"
}

# A provider block is used to specify a provider configuration.
provider "akamai" {
    
    # edgerc refers to the Akamai EdgeGrid authentication file that contains your Akamai API tokens. Typically ~/.edgerc.
    edgerc = var.edgerc_path

    # config_section refers to the section inside the edgerc file which can contain multiple sets of Akamai API tokens. Typically default.
    config_section = var.config_section
}

# variable edgerc_path to define where your .edgerc file is located for Akamai EdgeGrid authentication.
variable "edgerc_path" { }

# variable config_section to define which config_section to use inside the edgerc file. Typically added in akamai.auto.tfvars.
variable "config_section" { }

# variable contract_id reflects your Akamai Contract ID.
variable "contract_id" { }

# variable group_name reflects the name of your group you want to store your config. Groups are part of an Akamai contract.
variable "group_name" { }

# variable group_name reflects the name of your group you want to store your config. Groups are part of an Akamai contract.
variable "group_id" { }

# variable hostname defines the hostname you want to deliver and protect with Akamai.
variable "hostname" { }

# variable edge_hostnames defines the name of your EdgeHostname used to route traffic to Akamai. Ending in either *.akamaized.net, *.edgesuite.net or *.edgekey.net.
variable "edge_hostname" { }

# variable origin_hostnames defines the name of your origin. Eg. your web server, load balancer, cloud provider etc.
variable "origin_hostname" { }

# variable email is used to notify activations.
variable "email" { }

# variable dns_zone is used for you existing Akamai Edge DNS zone to add records to.
variable "dns_zone" { }

# variable network is used for deploying the configuration to Akamai STAGING or Akamai PRODUCTION
variable "network" { }