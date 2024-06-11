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

# variable edgerc_config_section to define which config_section to use inside the edgerc file. Typically added in akamai.auto.tfvars.
variable "config_section" { }

variable "zone_name" { }
variable "hostname" { }
variable "edge_hostname" { }
variable "dv_record_name" { }
variable "dv_record_target" { }

resource "akamai_dns_record" "dv-validation" {
    zone = var.zone_name
    name = var.dv_record_name
    recordtype = "CNAME"
    target = [var.dv_record_target]
    ttl = 60
}

resource "akamai_dns_record" "akamai-cname" {
    zone = var.zone_name
    name = var.hostname
    recordtype = "CNAME"
    target = [var.edge_hostname]
    ttl = 600
}