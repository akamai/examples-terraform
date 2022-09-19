terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
    }
  }
}

variable token { default = "YOUR_TOKEN_HERE" }

provider "linode" {
  token = var.token
}

data "linode_account" "account" {}

resource "linode_instance" "web" {
    label = "YOUR_LINODE_NAME_HERE"
    image = "linode/debian11"
    region = "eu-west"
    type = "g6-nanode-1"
    root_pass = "YOUR_LINODE_ROOT_PASSWORD_HERE"
    swap_size = 512
    private_ip = false
}