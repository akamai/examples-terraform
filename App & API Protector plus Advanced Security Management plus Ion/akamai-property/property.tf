# Akamai Property template, specifically created for Akamai Ion Standard.
# This TF configuration uses best practices to utilize Ion with it's best capabilities.
# Created by Mike Elissen, Developer Advocate @ Akamai, @securitylevelup
# Version 1.0.0, February 11, 2022.

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

# variable product_id reflects the ID of the Akamai Product that you want to use for Content Delivery.
variable "product_id" { }

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

# variable email reflects your email address to receive notifications on regarding the deployment of your configuration.
variable "email" { }

# data source that contains the Akamai group based on the name supplied in a variable. A group is tied to an Akamai contract.
data "akamai_group" "group" {
 group_name = var.group_name
 contract_id = var.contract_id
}

# data source that contains the Akamai contract. An Akamai contract contains all the entitlements and Akamai product/solution usage.
data "akamai_contract" "contract" {
  group_name = var.group_name
}

# data source to define the Akamai Property Rules. Akamai's delivery configurations are managed in 'Property Manager' and are currently driven of a JSON template. A main.json file contains all the rules, behaviors and criteria that make up an Akamai property / delivery configuration.
data "akamai_property_rules_template" "rules" {

  # template file is found in the fixed property-snippets folder in which main.json is located. JSON files can also be split into smaller JSON files.
  template_file = abspath("${path.module}/property-snippets/main.json")

  # variable origin_hostname is taken from the Terraform variables file and injected in the Origin Server Property Behavior. This defines the location of your Origin.
  variables {
    name = "origin_hostname"
    value = var.origin_hostname
    type = "string"
  }

  # variable cp_code is taken from the Terraform variables file and injected in the CP Code Property Behavior. This is used for billing, monitoring and reporting.
  variables {
    name = "cp_code"
    value = parseint(replace(akamai_cp_code.cp_code.id, "cpc_", ""), 10)
    type = "number"
  }
}

# resource that creates / manages the Akamai CP Code which is a 6 or 7 digit ID that is used for billing, monitoring and reporting. CP Codes are tied to an Akamai Contract and Akamai Group as well as an Akamai Product and have a name provided in a variable.
resource "akamai_cp_code" "cp_code" {
  product_id  = var.product_id
  contract_id = var.contract_id
  group_id = data.akamai_group.group.id
  name = var.cpcode_name
}

# resource that creates / manages the Akamai Edge Hostname which is used to route traffic to Akamai. Usually ends in *.akamaized.net, *.edgesuite.net or *.edgekey.net.
resource "akamai_edge_hostname" "edge_hostname" {
  product_id  = var.product_id
  contract_id = var.contract_id
  group_id = data.akamai_group.group.id
  ip_behavior = var.ip_behavior
  edge_hostname = var.edge_hostname 
}

# resource that creates / manages the Akamai Property / delivery configuration. Configuration is tied to a Contract and Group. Configuration has a specific Product tied to it as well.
resource "akamai_property" "property" {
  name = var.hostname
  product_id  = var.product_id
  contract_id = var.contract_id
  group_id = data.akamai_group.group.id
  rule_format = var.rule_format

  # hostname required to add to the configuration. Also requires the Edge Hostname to add the logical mapping. Please note that a manual step is needed to update your DNS to route traffic properly to Akamai after deployment and testing.
  hostnames {
    cname_from = var.hostname
    cname_to = var.edge_hostname
    cert_provisioning_type = var.cert_provisioning_type
  }
 
  # rules will load in the main.json file added earlier in a data source.
  rules = data.akamai_property_rules_template.rules.json
}

# resource to activate the Akamai Property on either Akamai STAGING or Akamai PRODUCTION. Email address is used to notify on completed deployment.
resource "akamai_property_activation" "activation" {
  property_id = akamai_property.property.id
  contact = [ var.email ]
  version = akamai_property.property.latest_version
  network = upper(var.akamai_network)
}