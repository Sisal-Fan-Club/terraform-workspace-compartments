locals {
  vcn = try(oci_core_vcn.vcn, "")
  
  internet_gateway = try(oci_core_internet_gateway.internet_gateway, "")
}

resource "oci_core_vcn" "vcn" {
  compartment_id = local.root_compartment.id
  
  display_name = local.root_compartment.name
  
  cidr_blocks = [
    "10.0.0.0/16"
  ]
  
  freeform_tags = merge({
  }, local.root_compartment.freeform_tags)
}

resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = local.vcn.compartment_id
  
  vcn_id = local.vcn.id
  
  display_name = "Ingress Gateway (1:1 NAT)"
  
  freeform_tags = merge({
  }, local.vcn.freeform_tags)
}
