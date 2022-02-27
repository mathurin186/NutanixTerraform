# Set the provider to begin your deployment. This can be AWS, Azure, VMware, etc. All of which can be found (https://www.terraform.io/docs/providers/index.html)
provider "nutanix" {
 username = "<user_name>"  #Prism username and password 
 password = "<password>"
 endpoint = "<IP_address>"  #prism virtual IP address as an endpoint
 insecure = true
}

# ncli cluster info
resource "nutanix_virtual_machine" "MyTestVM_TF" {
 name = "MyTestVM-TF"
 description = "Created with Terraform"
 provider = nutanix
 cluster_uuid = "0305ae5b-s47e-41v9-0000-1237000076a8"
  num_vcpus_per_socket = 1
  num_sockets = 1
  memory_size_mib = 2048
  
  nic_list {
     # subnet_reference is saying, which VLAN/network do you want to attach here?
     subnet_uuid = "e6d59992-3323-4e39-8364-9a0603597c50"
   }

  disk_list {
  # data_source_reference in the Nutanix API refers to where the source for
  # the disk device will come from. Could be a clone of a different VM or a
  # image like we're doing here
  # ssh into the CVM and run: acli image.list
  data_source_reference = {
   kind = "image"
   uuid = "1c8cdd38-b9ce-4c61-9fd6-5c5a1d6e6dc5"
    }

  device_properties {
    disk_address = {
   device_index = 0
   adapter_type = "IDE"
    }

    device_type = "DISK"
  }
    disk_size_mib   = 100000
    disk_size_bytes = 104857600000

    # ssh into cvm and run: ncli container list
    storage_config {
      storage_container_reference {
        kind = "storage_container"
        uuid = "04c62ac7-cc5-435a-b77d-61d52b5c8fb0"
    }
   } 
  
   }
}  
  
output "ip_address" {
  value = nutanix_virtual_machine.MyTestVM-TF.nic_list_status.0.ip_endpoint_list[0]["ip"]
}

