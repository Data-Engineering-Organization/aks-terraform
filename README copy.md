# AKS + App Gateway + DNS + ACR (Terraform)

## Run
    az login
    az account show --query id -o tsv        # put this in terraform.tfvars
    cp terraform.tfvars.example terraform.tfvars
    terraform init
    terraform plan
    terraform apply

## Then (Kubernetes side)
    $(terraform output -raw get_credentials_command)
    kubectl apply -f ../ingress-nginx-aks.yaml     # loadBalancerIP must equal var.ingress_lb_private_ip
    kubectl apply -f ../app-manifests.yaml

## Test (before DNS is delegated)
    curl -H "Host: aom-service.com" http://<appgw_public_ip>/login

## Clean up
    terraform destroy
