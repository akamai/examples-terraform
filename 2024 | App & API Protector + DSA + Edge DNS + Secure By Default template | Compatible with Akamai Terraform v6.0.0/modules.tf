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

module "akamai-security" {
    source = "./akamai-security"

    edgerc_path = var.edgerc_path
    config_section = var.config_section

    contract_id = var.contract_id
    group_name = var.group_name

    configuration_name = "Akamai Security Config"
    configuration_description = "Akamai Security Config"

    hostname = var.hostname

    policy_name = "Security Policy"
    policy_prefix = "waf1"

    ipblock_list = [ "192.0.0.1" ] # the list of IP/CIDR addresses you want to block
    ipblock_list_exceptions = [ "192.0.0.2" ] # the list of IP/CIDR addresses you want to block
    geoblock_list = [ "NL" ] # the list of GEO country codes you want to block
    ukraine_geo_control_action = "deny"
    securitybypass_list = [ "192.0.0.3" ] # the list of IP/CIDR addresses you want to be able to bypass the security policy.
    
    ratepolicy_page_view_requests_action = "alert" # Action set to either alert or deny.
    ratepolicy_origin_error_action = "alert" # Action set to either alert or deny.
    ratepolicy_post_requests_action = "alert" # Action set to either alert or deny.
    slow_post_protection_action = "alert" # Action set to either alert or deny.
    
    attack_group_web_attack_tool_action = "alert" # Action set to either alert or deny.
    attack_group_web_protocol_attack_action = "alert" # Action set to either alert or deny.
    attack_group_sql_injection_action = "alert" # Action set to either alert or deny.
    attack_group_cross_site_scripting_action = "alert" # Action set to either alert or deny.
    attack_group_local_file_inclusion_action = "alert" # Action set to either alert or deny.
    attack_group_remote_file_inclusion_action = "alert" # Action set to either alert or deny.
    attack_group_command_injection_action = "alert" # Action set to either alert or deny.
    attack_group_web_platform_attack_action = "alert" # Action set to either alert or deny.
    attack_group_web_policy_violation_action = "alert" # Action set to either alert or deny.
    attack_group_total_outbound_action = "none" # Action set to either alert or deny.
    
    network = "STAGING"
    email = var.email
}
