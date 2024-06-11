# variable edgerc_path to define where your .edgerc file is located for Akamai EdgeGrid authentication.
edgerc_path = "~/.edgerc"

# variable config_section to define which config_section to use inside the edgerc file.
config_section = "default" # Recommended value: default

# variable contract_id reflects your Akamai Contract ID.
contract_id = ""

# variable group_name reflects the name of your group you want to store your config. Groups are part of an Akamai contract.
group_name = ""

# variable group_name reflects the ID of your group 
group_id = ""

# variable dns_zone reflects your existing Akamai Edge DNS zone to add records to.
dns_zone = ""

#your hostname to Akamaize.
hostname = "" 

# the Akamai Edge Hostname to create, ending in either *.akamaized.net, *.edgesuite.net or *.edgekey.net.
edge_hostname = "" 

# the hostname where we can retrieve your content from.
origin_hostname = ""

# email address to receive activation notifications to.
email = "" 

# network to deploy changes on
network = "STAGING"