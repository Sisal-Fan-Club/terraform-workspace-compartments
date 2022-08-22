module "root_compartment" {
  source = "Terraform-Modules-Lib/compartment/oci"
  
  # Pinning a specific version
  version = "~> 1"
  
  # Requiring a oci provider pointing to home region
  providers = {
    oci = oci.home
  }
  
  parent_ocid = var.oci_tenancy_id
  
  name = "sisal-fan-club"
  description = "Sisal Fan Club"
  freeform_tags = {
    factory = "digital"
    app_code = "nsfc"
    managed-by = "terraform cloud"
  }
  
  manage = true
}
  
resource "oci_identity_group" "compartment_admins" {
    provider = oci.home
  
    compartment_id = var.oci_tenancy_id

    name = "${module.root_compartment.oci-compartment.name}-admins"
    description = "Administrators of Compartment ${module.root_compartment.oci-compartment.name}"
}

resource "oci_identity_policy" "compartment_admins" {
    provider = oci.home
  
    compartment_id = var.oci_tenancy_id
  
    name = oci_identity_group.compartment_admins.name
    description = "Grants for group adminstrators of compartment ${module.root_compartment.oci-compartment.name} (${oci_identity_group.compartment_admins.name})"
    statements = [
      "Allow group ${oci_identity_group.compartment_admins.name} to use users in tenancy",
      "Allow group ${oci_identity_group.compartment_admins.name} to manage groups in tenancy where target.group.name = '${oci_identity_group.compartment_admins.name}'",
      "Allow group ${oci_identity_group.compartment_admins.name} to manage policies where target.compartment.name = '${module.root_compartment.oci-compartment.name}'",
#      "Allow group ${oci_identity_group.compartment_admins.name} to manage all-resources in compartment ${module.root_compartment.oci-compartment.name}"
    ]
}

module "test_compartment" {
  source = "Terraform-Modules-Lib/compartment/oci"
  
  # Pinning a specific version
  version = "~> 1"
  
  # Requiring a oci provider pointing to home region
  providers = {
    oci = oci.home
  }
  
  parent_ocid = module.root_compartment.oci-compartment.id
  
  name = "${module.root_compartment.oci-compartment.name}-test"
  description = "${module.root_compartment.oci-compartment.description} - Test Environment"
  freeform_tags = {
    environment = "test"
  }
  
  manage = true
}
