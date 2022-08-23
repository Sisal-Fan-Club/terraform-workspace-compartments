locals {
  test_subnet_private = try(oci_core_subnet.test_subnet_private, "")
  test_subnet_public = try(oci_core_subnet.test_subnet_public, "")
}

resource "oci_core_subnet" "test_subnet_private" {
  compartment_id = local.test_compartment.id
  
  vcn_id = local.vcn.id
  
  display_name = "${local.test_compartment.description} - Private Network"
  cidr_block = "10.0.10.0/24"
  prohibit_internet_ingress = true
  
  freeform_tags = merge({
  }, local.vcn.freeform_tags, local.test_compartment.freeform_tags)
}

resource "oci_core_subnet" "test_subnet_public" {
  compartment_id = local.test_compartment.id
  
  vcn_id = local.vcn.id
  
  display_name = "${local.test_compartment.description} - Public Network"
  cidr_block = "10.0.100.0/24"
  prohibit_internet_ingress = false
  
  freeform_tags = merge({
  }, local.vcn.freeform_tags, local.test_compartment.freeform_tags)
}
