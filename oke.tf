locals {
  test_oke = try(oci_containerengine_cluster.test_oke, "")
  test_oke_kubeconfig = try(data.oci_containerengine_cluster_kube_config.test_oke_kubeconfig, "")
}

output "debug" {
  value = local.test_oke_kubeconfig
}

resource "oci_containerengine_cluster" "test_oke" {
  compartment_id = local.test_compartment.id
  
  vcn_id = local.vcn.id
  
  name = "${local.test_compartment.name}"
  kubernetes_version = "v1.24.1"
  
  endpoint_config {
    subnet_id = local.test_subnet_public.id
    is_public_ip_enabled = true
  }
  
  options {
    service_lb_subnet_ids = [
      local.test_subnet_public.id
    ]
    service_lb_config {
      freeform_tags = merge({
      }, local.test_subnet_public.freeform_tags, local.vcn.freeform_tags, local.test_compartment.freeform_tags)
    }
    
    persistent_volume_config {
      freeform_tags = merge({
      }, local.test_compartment.freeform_tags)
    }
  }
  
  freeform_tags = merge({
  }, local.test_compartment.freeform_tags)
}

data "oci_containerengine_cluster_kube_config" "test_oke_kubeconfig" {
  cluster_id = local.test_oke.id
}


resource "null_resource" "local_oci_cli" {
  triggers = {
    run_every_time = timestamp()
  }
  
  provisioner "local-exec" {
    command = "curl -L -o ./oci_install.sh 'https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh' && chmod u+x ./oci_install.sh && ./oci_install.sh --accept-all-defaults"
  }
}
