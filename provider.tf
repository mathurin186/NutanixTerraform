
terraform {
  required_version = ">= 0.13"
  ## Define the required version of the provider
  required_providers {
    nutanix = {
      source  = "terraform-providers/nutanix"
      version = "~> 1.1"
    }
  }
}


