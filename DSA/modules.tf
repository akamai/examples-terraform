# modules.tf
# version 1.0.0
# This Terraform configuration functions as the configuration to create Akamai modules which acts as logical groupings of Akamai functionality.

module "akamai-property" {
    source = "./akamai-property"

    edgerc_config_section = var.edgerc_config_section

    contract_id = var.contract_id
    group_name = var.group_name
    product_id = "prd_Site_Accel" #prd_Site_Accel = Akamai Dynamic Site Accelerator. Do not change.

    hostname = "" #your hostname to Akamaize.
    edge_hostname = "" #the Akamai Edge Hostname to create, ending in either *.akamaized.net, *.edgesuite.net or *.edgekey.net.
    origin_hostname = ""

    cpcode_name = ""

    cert_provisioning_type = "CPS_MANAGED" 
    ip_behavior = "IPV6_COMPLIANCE"
    rule_format = "latest"

    akamai_network = "STAGING" #STAGING or PRODUCTION
    email = ""
}