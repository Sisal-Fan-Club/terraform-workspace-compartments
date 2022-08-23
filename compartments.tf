locals {
  root_compartment = try(oci_identity_compartment.root_compartment, "")
  test_compartment = try(oci_identity_compartment.test_compartment, "")
  
  root_admins = try(oci_identity_group.root_admins, "")
  root_opers = try(oci_identity_group.root_opers, "")
  
  root_admin_policy = try(oci_identity_policy.root_admin_policy, "")
  root_opers_policy = try(oci_identity_policy.root_opers_policy, "")
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
    "Allow group ${local.root_admins.name} to manage policies in compartment id ${local.root_compartment.id}",
  ]
  
  freeform_tags = {
    group = "${local.root_admins.name}"
    compartment = "${local.root_compartment.id}"
  }
}


resource "oci_identity_group" "root_opers" {
  provider = oci.home
  
  compartment_id = var.oci_tenancy_id
  
  name = "${local.root_compartment.name}-operators"
  description = "Compartment ${local.root_compartment.name}'s operators."
  
  freeform_tags = merge({
  }, local.root_compartment.freeform_tags)
}


resource "oci_identity_policy" "root_opers_policy" {
  provider = oci.home
  
  compartment_id = local.root_compartment.id
  
  name = "${local.root_opers.name}"
  description = "Permissions for compartment ${local.root_compartment.name}'s operators group (${local.root_opers.name})."
  
  statements = [
    "Allow group ${local.root_opers.name} to use instance-family in compartment id ${local.root_compartment.id}",
  ]
  
  freeform_tags = {
    group = "${local.root_opers.name}"
    compartment = "${local.root_compartment.id}"
  }
}


resource "oci_identity_compartment" "test_compartment" {
  provider = oci.home
  
  compartment_id = local.root_compartment.id
  
  name = "${local.root_compartment.name}-test"
  description = "${local.root_compartment.description} - Test Environment"
  
  freeform_tags = merge({
    environment = "test"
  }, local.root_compartment.freeform_tags)
  
  enable_delete = true
}
