Akamai Terraform Provider template for App & API Protector plus Ion Standard

This Akamai Terraform Provider template can be used to onboard a brand new set of infrastructure with Akamai. This template is designed to create an Application Security configuration, tied to the App & API Protector (AAP) solution as well as create an Akamai Delivery configuration, tied to the Ion Standard solution.

This template will also create other assets such as an Akamai CP Code, Akamai Edge Hostname, Akamai Network Lists and has the ability to activate all of these assets to either Akamai STAGING or Akamai PRODUCTION.

This template is created by Mike Elissen, Developer Advocate @ Akamai.
Version 1.0 is created in March 2022 and tested with Akamai Terraform Provider version 1.11.0 and Terraform version 1.1.6.

How to use this template to create configurations from scratch?

1) Download the templates

git clone https://github.com/akamai/examples-terraform.git

2) Navigate to the examples-terraform/App & API Protector plus Ion folder

3) Authentication is handled through Akamai EdgeGrid. See akamai.tf, line 24 & 27. Ensure you have your .edgerc file available and that it contains your Akamai EdgeGrid tokens seperated in sections.

akamai.auto.tfvars has set the EdgeGrid section to 'default'.

For more information on Akamai EdgeGrid, .edgerc file and creating Akamai EdgeGrid tokens, please read more on: https://techdocs.akamai.com/developer/docs/authenticate-with-edgegrid

4) Add your contract ID and group name to akamai.auto.tfvars and Save the changes. You can find these in Akamai Control Center or use the Akamai API/CLI to find these values. 

CLI commands to retrieve Akamai Contract ID and Group Name:
akamai property-manager list-groups --section default

5) Add your values to variables in side of the modules.tf file.

To create the Akamai delivery configuration:
- Line 14, add your hostname that you want to Akamaize.
- Line 15, add your Akamai Edge Hostname that you want to create. Recommended is yourhostname.edgesuite.net for Standard TLS and yourhostname.edgekey.net for Enhanced TLS.
- Line 16, add your Origin Hostname where Akamai can retrieve your static/dynamic content. Can also be an IP address.
- Line 18, add your CP Code name. Recommended is to use your hostname here as well.
- Line 24, add your Akamai network to deploy the configuration to. Recommend is to start with Akamai STAGING.
- Line 25, add your email to receive notifications regarding the activation.

Other settings can be changed if required.

To create the Akamai application security configuration:
- Line 35, add your AppSec configuration name.
- Line 36, add your AppSec configuration description.
- Line 37, add your Hostname again. Important here is to use the same hostname as added to your delivery configuration.
- Line 43 to 46 can be used to manually add IP addresses, CIDR blocks or country codes to add to Akamai Network Lists.
- Lines 48 to 62 will set specific protection mechanisms to ALERT or DENY. Recommended is to start with ALERT.
- Line 64, add your Akamai network to deploy the configuration to. Recommend is to start with Akamai STAGING.
- Line 65, add your email to receive notifications regarding the activation.
- Line 66, activation notes for the Application Security configuration. These are mandatory to deploy your changes.

Following these steps should create your Akamai AAP and Ion configuration as well as activate the network lists, CP Code and Edge Hostname that you have specified.

If you run into any issues, please reach out devrel at akamai dot com or Mike Elissen/@securitylevelup on social media.


