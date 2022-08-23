locals {
  vcn = try(oci_core_vcn.vcn, "")
  
  ingress_gateway = try(oci_core_internet_gateway.ingress_gateway, "")
  
  egress_gateway = try(oci_core_nat_gateway.egress_gateway, "")
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

resource "oci_core_internet_gateway" "ingress_gateway" {
  compartment_id = local.vcn.compartment_id
  
  vcn_id = local.vcn.id
  
  display_name = "${local.vcn.display_name} - Ingress Gateway (1:1 NAT)"
  
  freeform_tags = merge({
  }, local.vcn.freeform_tags)
}

resource "oci_core_nat_gateway" "egress_gateway" {
  compartment_id = local.vcn.compartment_id
  
  vcn_id = local.vcn.id

  display_name = "${local.vcn.display_name} - Egress Gateway (1:N SNAT)"
  
  freeform_tags = merge({
  }, local.vcn.freeform_tags)
}

data "oci_core_services" "oci_services" {
  filter {
    name = "name"
    values = ["^All .* Services In Oracle Services Network"]
    regex = true
  }
}

resource "oci_core_service_gateway" "service_gateway" {
  compartment_id = local.vcn.compartment_id
  
  vcn_id = local.vcn.id

  display_name = "${local.vcn.display_name} - Oracle Cloud Services Gateway"

  dynamic "services" {
    for_each = { for service in data.oci_core_services.oci_services.services:
      service.id => service
    }

    content {
      service_id = services.value.id
    }
  }

  freeform_tags = merge({
  }, local.vcn.freeform_tags)
}


resource "oci_core_default_security_list" "default_security_list" {
  compartment_id = local.vcn.compartment_id
  
  vcn_id = local.vcn.id
  
  ingress_security_rules {
  }
  
  egress_security_rules {
  }
}
