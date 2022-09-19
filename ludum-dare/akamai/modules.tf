# modules.tf
# version 1.0.0
# This Terraform configuration functions as the configuration to create Akamai modules which acts as logical groupings of Akamai functionality.

module "akamai-property" {
    source = "./akamai-property"

    edgerc_config_section = var.edgerc_config_section

    contract_id = var.contract_id
    group_name = var.group_name
    product_id = "prd_Fresca" #prd_Fresca = Akamai Ion Standard. Do not change.

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

module "akamai-application-security" {
    source = "./akamai-application-security"

    edgerc_config_section = var.edgerc_config_section
    contract_id = var.contract_id
    group_name = var.group_name

    configuration_name = ""
    configuration_description = ""

    hostname = ""

    policy_name = "First Security Policy"
    policy_prefix = "qik1"

    ipblock_list = [ "192.0.0.1" ] # the list of IP/CIDR addresses you want to block
    ipblock_list_exceptions = [ "192.0.0.2" ] # the list of IP/CIDR addresses you want to block
    geoblock_list = [ "" ] # the list of GEO country codes you want to block
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
    email = ""
    activation_notes = "AppSec configuration deployed with the Akamai Terraform Provider. v1." # Activation Notes, changing the notes will deploy a new version to your chosen Akamai network.
}