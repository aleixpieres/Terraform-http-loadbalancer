provider "google" {
  project = var.project
}

provider "google-beta" {
  project = var.project
}

#### START-UP SCRIPT
# creating template for start-up script, it can be found in the file gceme.sh.tpl
data "template_file" "group-startup-script" {
  template = file(format("%s/gceme.sh.tpl", path.module))

  vars = {
    PROXY_PATH = ""
  }
}

resource "google_compute_health_check" "tcp-health-check" {
  name = "tcp-health-check"

  timeout_sec        = 1
  check_interval_sec = 1

  tcp_health_check {
    port = "80"
  }
}

#### MIG TEMPLATE 1
module "mig1_template" {
  source     = "terraform-google-modules/vm/google//modules/instance_template"
  version    = "~> 7.9"
  network    = google_compute_network.default.self_link
  subnetwork = google_compute_subnetwork.group1.self_link
  service_account = {
    email  = ""
    scopes = ["cloud-platform"]
  }
  name_prefix          = "${var.network_prefix}-group1"
  startup_script       = data.template_file.group-startup-script.rendered
  source_image_family  = "ubuntu-2004-lts"
  source_image_project = "ubuntu-os-cloud"
  tags = [
    "${var.network_prefix}-group1",
    module.cloud-nat-group1.router_name
  ]
}

#### MIG 1
module "mig1" {
  source            = "terraform-google-modules/vm/google//modules/mig"
  version           = "~> 7.9"
  instance_template = module.mig1_template.self_link
  region            = var.group1_region
  wait_for_instances = true
  autoscaling_enabled  = true
  health_check_name = google_compute_health_check.tcp-health-check.name
  autoscaling_cpu = [ {
    target = 0.6
  }] 
  min_replicas      = 2
  max_replicas      = 4
  cooldown_period   = 120
  hostname          = "${var.network_prefix}-group1"
  named_ports = [{
    name = "http",
    port = 80
  }]
  network    = google_compute_network.default.self_link
  subnetwork = google_compute_subnetwork.group1.self_link
}

#### MIG TEMPLATE 2
module "mig2_template" {
  source     = "terraform-google-modules/vm/google//modules/instance_template"
  version    = "~> 7.9"
  machine_type = "n2d-standard-2"
  network    = google_compute_network.default.self_link
  subnetwork = google_compute_subnetwork.group2.self_link
  service_account = {
    email  = ""
    scopes = ["cloud-platform"]
  }
  name_prefix    = "${var.network_prefix}-group2"
  startup_script = data.template_file.group-startup-script.rendered
  tags = [
    "${var.network_prefix}-group2",
    module.cloud-nat-group2.router_name
  ]
}

#### MIG 2
module "mig2" {
  source            = "terraform-google-modules/vm/google//modules/mig"
  version           = "~> 7.9"
  instance_template = module.mig2_template.self_link
  region            = var.group2_region
  hostname          = "${var.network_prefix}-group2"
   wait_for_instances = true
  autoscaling_enabled  = true
  health_check_name = google_compute_health_check.tcp-health-check.name
  autoscaling_cpu = [ {
    target = 0.6
  }] 
  min_replicas      = 2
  max_replicas      = 4
  cooldown_period   = 120
  named_ports = [{
    name = "http",
    port = 80
  }]
  network    = google_compute_network.default.self_link
  subnetwork = google_compute_subnetwork.group2.self_link
}
