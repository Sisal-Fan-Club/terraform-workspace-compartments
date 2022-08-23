locals {
  root_compartment = try(oci_identity_compartment.root_compartment, "")
}

resource "oci_identity_compartment" "root_compartment" {
  provider = oci.home
  
  compartment_id = var.oci_tenancy_id
  
  name = "sisal-fan-club"
  description = "Sisal Fan Club"
  
  freeform_tags = {
    factory = "digital"
    managed-by = "terraform cloud"
    app_code = "nsfc"
  }
}

resource "oci_identity_group" "root_admins" {
  provider = oci.home
  
  compartment_id = var.oci_tenancy_id
  
  name = "${local.root_compartment.name}-admins"
  description = "Compartment ${local.root_compartment.name}'s administrators."
  
  freeform_tags = merge({
    manages = "${local.root_compartment.name}"
  }, local.root_compartment.freeform_tags)
}

resource "oci_identity_policy" "root_admin_policy" {
  provider = oci.home
  
  compartment_id = var.oci_tenancy_id
  
  name = "${oci_identity_group.root_admins.name}"
  description = "Permissions for compartment ${local.root_compartment.name}'s administrators group (${oci_identity_group.root_admins.name})."
  
  statements = [
    "Allow group ${oci_identity_group.root_admins.name} to use users in tenancy",
    "Allow group ${oci_identity_group.root_admins.name} to manage groups in tenancy where target.group.name = '${oci_identity_group.root_admins.name}'",
    "Allow group ${oci_identity_group.root_admins.name} to manage policies in compartment id ${local.root_compartment.id}",
    "Allow group ${oci_identity_group.root_admins.name} to manage all-resources in compartment id ${local.root_compartment.id}",
  ]
  
  
}
