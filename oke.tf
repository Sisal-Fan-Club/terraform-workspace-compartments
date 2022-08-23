locals {
  test_oke = try(oci_containerengine_cluster.test_oke, "")
}

resource "oci_containerengine_cluster" "test_oke" {
  compartment_id = local.test_compartment.id
  
  vcn_id = local.vcn.id
  
  name = "${local.test_compartment.name}"
  kubernetes_version = "v1.24.1"
}
