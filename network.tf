resource "oci_core_vcn" "vcn" {
  compartment_id = local.root_compartment.id
  
  display_name = local.root_compartment.name
  
  cidr_blocks = [
    "10.0.0.0/16"
  ]
  
  freeform_tags = merge({
  }, local.root_compartment.freeform_tags)
}
