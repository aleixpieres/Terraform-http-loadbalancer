# Terraform-http-loadbalancer

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
