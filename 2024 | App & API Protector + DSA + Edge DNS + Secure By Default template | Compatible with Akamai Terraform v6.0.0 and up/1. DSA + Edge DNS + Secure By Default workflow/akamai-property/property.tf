# Akamai Property template, specifically created for Akamai Dynamic Site Accelerator (DSA).
# This TF configuration uses best practices to utilize DSA with it's best capabilities.
# Created by Mike Elissen, Developer Advocate @ Akamai, @securitylevelup
# April 1, 2024.

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

# variable contract_id reflects your Akamai Contract ID.
variable "contract_id" { }

# variable group_id reflects the id of your group you want to store your config. Groups are part of an Akamai contract.
variable "group_id" { }

# variable group_name reflects the name of your group you want to store your config. Groups are part of an Akamai contract.
variable "group_name" { }

# variable product_id reflects the ID of the Akamai Product that you want to use for Content Delivery.
variable "product_id" { }

# variable hostname reflects the hostname you want to Akamaize.
variable "property_name" {  }

# variable hostname reflects the hostname you want to Akamaize.
variable "hostname" {  }

# variable cpcode_name reflects the name you want to give to your Akamai CP Code (Content Provider Code) used for billing, monitoring and reporting.
variable "cpcode_name" { }

# variable edge_hostname reflects the Akamai Edge Hostname you want to use, ending in *.akamaized.net, *.edgesuite.net or *.edgekey.net.
variable "edge_hostname" { }

# variable origin_hostname reflects the hostname where your Origin is located.
variable "origin_hostname" { }

# variable ip_behaviors reflects if your hostname supports IPv4 only or IPv4 + IPv6.
variable "ip_behavior" { }

# variable rule_format reflects the Akamai Property Manager rule format which includes updated behaviors for newer versions. 'latest' is accepted.
variable "rule_format" { }

# variable cert_provisioning_type reflects which type of HTTPS SSL/TLS Certificate method you use with Akamai. This can be CPS_MANAGED for certificates managed in Certificate Provisioning System or DEFAULT for Secure By Default feature.
variable "cert_provisioning_type" { }

# variable akamai_network reflects which part of the Akamai platform you wish to deploy your config to, options are STAGING or PRODUCTION.
variable "akamai_network" { }

variable "activate_latest_on_staging" {
  type    = bool
  default = true
}

variable "activate_latest_on_production" {
  type    = bool
  default = true
}

# variable email reflects your email address to receive notifications on regarding the deployment of your configuration.
variable "email" { }

resource "akamai_edge_hostname" "edge_hostname" {
  contract_id   = var.contract_id
  group_id      = var.group_id
  ip_behavior   = var.ip_behavior
  edge_hostname = var.edge_hostname
  product_id = var.product_id
}

resource "akamai_cp_code" "cp_code" {
  name = var.cpcode_name
  contract_id = var.contract_id
  group_id = var.group_id
  product_id = var.product_id
  timeouts {
    update = "1h"
  }
}

resource "akamai_property" "property" {
  name        = var.property_name
  contract_id = var.contract_id
  group_id    = var.group_id
  product_id  = var.product_id
  hostnames {
    cname_from             = var.hostname
    cname_to               = var.edge_hostname
    cert_provisioning_type = var.cert_provisioning_type
  }

  rule_format = data.akamai_property_rules_builder.property_rule_default.rule_format
  rules       = data.akamai_property_rules_builder.property_rule_default.json
}


# NOTE: Be careful when removing this resource as you can disable traffic
resource "akamai_property_activation" "activation-staging" {
  property_id                    = akamai_property.property.id
  contact                        = [var.email]
  version                        = var.activate_latest_on_staging ? akamai_property.property.latest_version : akamai_property.property.staging_version
  network                        = "STAGING"
  auto_acknowledge_rule_warnings = true
}

/* NOT ACTIVATING TO PROUCTION
#NOTE: Be careful when removing this resource as you can disable traffic
resource "akamai_property_activation" "activation-production" {
  property_id                    = akamai_property.property.id
  contact                        = [var.email]
  version                        = var.activate_latest_on_production ? akamai_property.property.latest_version : akamai_property.property.production_version
  network                        = "PRODUCTION"
  auto_acknowledge_rule_warnings = true
}
*/

output "dv_record" {
        value = tolist(akamai_property.property.hostnames)[0].cert_status[0].hostname  
}

output "dv_record_target" {
        value = tolist(akamai_property.property.hostnames)[0].cert_status[0].target  
}

output "hostname" {
        value = var.hostname
}