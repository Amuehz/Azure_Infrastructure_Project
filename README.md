# Azure Infrastructure Project

## What this does
Deploys a load-balanced web server setup on Azure using Packer and Terraform. Part of the Udacity Azure DevOps course.

## What you need
- Azure account
- Azure CLI
- Packer 1.14+
- Terraform 1.0+

## Setup

### Step 1: Azure Policy for tags
We need a policy that requires tags on all resources.

Create the policy:
```bash
az policy definition create \
  --name "require-tags-policy" \
  --display-name "Require tags on all resources" \
  --description "Denies deployment of resources without tags" \
  --rules tagging-policy.json \
  --mode Indexed
```

Assign it to your subscription (replace YOUR_SUBSCRIPTION_ID):
```bash
az policy assignment create \
  --name "require-tags-assignment" \
  --policy "require-tags-policy" \
  --scope "/subscriptions/YOUR_SUBSCRIPTION_ID"
```

Check it worked:
```bash
az policy assignment list
```

### Step 2: Build the server image with Packer

Install the Azure plugin:
```bash
packer init packer-plugin.pkr.hcl
```

Build the image (takes ~5 minutes):
```bash
packer build server.json
```

This creates an Ubuntu 22.04 image with a basic web server.

### Step 3: Deploy with Terraform

Initialize:
```bash
terraform init
```

See what will be created:
```bash
terraform plan -out solution.plan
```

Deploy it:
```bash
terraform apply solution.plan
```

Takes about 5-10 minutes to create everything.

### Cleaning up

Don't forget to destroy resources when you're done:
```bash
terraform destroy
```

## Customizing the deployment

Edit `vars.tf` to change these settings:

- **prefix**: Changes the name prefix for all resources (default: "udacity")
- **location**: Azure region (default: "West Europe")
- **vm_count**: How many VMs to create - keep between 2-5 (default: 2)
- **admin_username**: VM login username (default: "azureuser")
- **admin_password**: VM password - change this to something secure
- **resource_group_name**: Must match an existing resource group (default: "Azuredevops")
- **packer_image_id**: Path to your Packer image - auto-configured

Example - to deploy 3 VMs instead of 2, change this line in `vars.tf`:
```hcl
variable "vm_count" {
  default = 3
}
```

## What gets created

- Virtual network (10.0.0.0/16) and subnet (10.0.1.0/24)
- Network security group that blocks internet access but allows VM-to-VM traffic
- Load balancer with a public IP
- 2 VMs by default (or whatever you set vm_count to)
- Availability set for the VMs
- Network interfaces and disks for each VM

Everything gets tagged with `project = "udacity-azure-devops"` so the policy allows it.

## Notes

- The Packer template uses `use_azure_cli_auth` instead of service principal credentials
- VMs use the Ubuntu 22.04 LTS image (the original course used 18.04 which is outdated)
- Network security rules explicitly deny inbound from internet (priority 100)
- Load balancer uses Standard SKU (Basic is deprecated)

## Issues I ran into

1. Service principal permissions - solved by using CLI auth in Packer
2. Policy blocking Packer builds - needed to add tags to the Packer template
3. Resource group permissions - had to use existing RG instead of creating new one
