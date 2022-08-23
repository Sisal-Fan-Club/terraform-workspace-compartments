locals {
  root_compartment = try(oci_identity_compartment.root_compartment, "")
  root_admins = try(oci_identity_group.root_admins, "")
  root_admin_policy = try(oci_identity_policy.root_admin_policy, "")
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
  
  enable_delete = true
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
  
  name = "${local.root_admins.name}"
  description = "Permissions for compartment ${local.root_compartment.name}'s administrators group (${local.root_admins.name})."
  
  statements = [
    "Allow group ${local.root_admins.name} to use users in tenancy",
    "Allow group ${local.root_admins.name} to manage groups in tenancy where target.group.name = '${local.root_admins.name}'",
#    "Allow group ${local.root_admins.name} to manage policies in compartment id ${local.root_compartment.id}",
    "Allow group ${local.root_admins.name} to manage policies in tenancy where target.compartment.id = '${local.root_compartment.id}'",
  ]
  
  freeform_tags = {
    group = "${local.root_admins.name}"
    compartment = "${local.root_compartment.id}"
  }
}
