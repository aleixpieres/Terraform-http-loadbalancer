# Terraform-http-loadbalancer

### Repository Hit Counter [![HitCount](https://hits.dwyl.com/aleixpieres/Terraform-http-loadbalancer.svg?style=flat-square)](http://hits.dwyl.com/aleixpieres/Terraform-http-loadbalancer)


### Description
This Terraform project creates a highly available and scalable infrastructure on Google Cloud Platform (GCP) for deploying web applications. Here's a breakdown of the resources provisioned:

- VPC Network: A Virtual Private Cloud (VPC) network named terraform-lb-network serves as the foundation for all resources.
- Subnetworks: Two subnetworks, terraform-lb-network-group1 and terraform-lb-network-group2, are created within the VPC network to segment traffic and improve security.
- Cloud Routers: A Cloud Router is deployed in each subnetwork (terraform-lb-network-gw-group1 and terraform-lb-network-gw-group2) to facilitate internet access for VMs.
- Cloud NAT: Cloud NAT gateways (terraform-lb-network-cloud-nat-group1 and terraform-lb-network-cloud-nat-group2) are provisioned in each subnet to enable internet connectivity for VMs without public IP addresses.
- External Load Balancer (HTTP): A highly available HTTP(s) Load Balancer named terraform-lb-network distributes incoming traffic across two Managed Instance Groups (MIGs).
- Instance Templates: Two instance templates, one for each MIG, define the configuration of VMs like machine type, boot disk, and startup script.
- Health Checks: A TCP health check (tcp-health-check) monitors the health of VMs ensuring only healthy VMs receive traffic.
- Managed Instance Groups (MIGs): Two MIGs ( mig1 and mig2 ) are created, each launching instances based on their respective instance template.
- Auto Scaling: MIGs are configured with autoscaling enabled, automatically scaling the number of VMs based on CPU utilization (between 2 and 4 instances).

## Install Terraform

1. Install Terraform if it is not already installed (visit [terraform.io](https://terraform.io) for other distributions):

## Set up the environment

1. Set the project, replace `YOUR_PROJECT` with your project ID:

```
PROJECT=YOUR_PROJECT
```

```
gcloud config set project ${PROJECT}
```

2. Configure the environment for Terraform:

```
[[ $CLOUD_SHELL ]] || gcloud auth application-default login
export GOOGLE_PROJECT=$(gcloud config get-value project)
```

## Run Terraform

```
terraform init -upgrade
terraform apply
```

## Testing

1. Open the URL of the load balancer in your browser:

```
curl http://https-loadbalancer-IP::80
```

You should see the instance details from `group1`.

## Cleanup

1. Remove all resources created by terraform:

```
terraform destroy
```


<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
