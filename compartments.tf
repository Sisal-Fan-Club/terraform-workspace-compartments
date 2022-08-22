module "root_compartment" {
  source = "Terraform-Modules-Lib/compartment/oci"
  
  # Pinning a specific version
  version = "~> 3"
  
  # Requiring a oci provider pointing to home region
  providers = {
    oci = oci.home
  }
  
  parent_ocid = var.oci_tenancy_id
  tenancy_ocid = var.oci_tenancy_id
  
  name = "sisal-fan-club"
  description = "Sisal Fan Club"
  freeform_tags = {
    factory = "digital"
    app_code = "nsfc"
    managed-by = "terraform cloud"
  }
  
  manage = true
}

module "test_compartment" {
  source = "Terraform-Modules-Lib/compartment/oci"
  
  # Pinning a specific version
  version = "~> 3"
  
  # Requiring a oci provider pointing to home region
  providers = {
    oci = oci.home
  }
  
  parent_ocid = module.root_compartment.oci-compartment.id
  tenancy_ocid = var.oci_tenancy_id
  
  name = "${module.root_compartment.oci-compartment.name}-test"
  description = "${module.root_compartment.oci-compartment.description} - Test Environment"
  freeform_tags = {
    environment = "test"
  }
  
  manage = true
}
