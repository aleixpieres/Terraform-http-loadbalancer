variable "project" {    #project you're going to deploy resources
  type = string
  default = "your-project-id"
}

variable "target_size" { #amount of vm (not compatible with autoscaler)
  type    = number
  default = 2
}

variable "group1_region" { #mig1 region
  type    = string
  default = "europe-central2"
}

variable "group2_region" { #mig2 region
  type    = string
  default = "europe-southwest1"
}

variable "network_prefix" { #network name 
  type    = string
  default = "terraform-lb-network"
}
