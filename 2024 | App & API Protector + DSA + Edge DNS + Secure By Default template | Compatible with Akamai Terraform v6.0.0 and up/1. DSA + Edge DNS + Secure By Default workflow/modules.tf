# modules.tf
# version 1.0.0
# This Terraform configuration functions as the configuration to create Akamai modules which acts as logical groupings of Akamai functionality.

module "akamai-property" {
    source = "./akamai-property"

    edgerc_path = var.edgerc_path
    config_section = var.config_section

    contract_id = var.contract_id
    group_name = var.group_name
    group_id = var.group_id
    product_id = "prd_Site_Accel" #prd_Site_Accel = Akamai Dynamic Site Accelerator. Do not change.

    property_name = var.hostname

    hostname = var.hostname
    edge_hostname = var.edge_hostname
    origin_hostname = var.origin_hostname

    cpcode_name = var.hostname

    cert_provisioning_type = "DEFAULT" #DEFAULT for Secure By Default, CPS_MANAGED for Certificate Provisioning System
    ip_behavior = "IPV6_COMPLIANCE"
    rule_format = "v2024-02-12"

    akamai_network = "STAGING"
    email = var.email
}

module "akamai-edgedns" {
    source = "./akamai-edgedns"

    edgerc_path = var.edgerc_path
    config_section = var.config_section

    zone_name = var.dns_zone

    dv_record_name = module.akamai-property.dv_record
    dv_record_target = module.akamai-property.dv_record_target

    hostname = var.hostname

    edge_hostname = var.edge_hostname
}