module "root_compartment" {
  source = "Terraform-Modules-Lib/compartment/oci"
  
  # Pinning a specific version
  version = "~> 1"
  
  # Requiring a oci provider pointing to home region
  providers = {
    oci = oci.home
  }
  
  name = "sisal-fan-club"
  parent_ocid = var.oci_tenancy_id

  manage = true
}
