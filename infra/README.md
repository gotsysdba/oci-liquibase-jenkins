# OCI Infrastructure Deployment

_Important_: It is recommended to [create a new compartment](https://docs.oracle.com/en/cloud/paas/integration-cloud/oracle-integration-oci/creating-oci-compartment.html) in your tenancy for this deployment.

## Deployement

### OCI Cloud Shell

Using [OCI Cloud Shell](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/cloudshellintro.htm) is, by far, the easiest way to manually install this Architecture.

1. Log into your tenancy and launch Cloud Shell
2. Fork this repository into your own GitHub account
3. Clone the forked repository; example: `git clone https://github.com/<your account>/oci-liquibase-jenkins.git`
4. `cd oci-liquibase-jenkins/infra`
5. `source ./cloud-shell.env`
6. Specify a password to use for the ADMIN database/Jenkins user:
   - `export TF_VAR_password=<Unique Password>`
7. To install into a specific compartment, change the TF_VAR_compartment_ocid variable (default root)
   - `export TF_VAR_compartment_ocid=ocid1.compartment....e7e5q`
8. If not using Always Free resources, run:
    - `export TF_VAR_is_paid=true`
9. Deploy!
   - `terraform init`
   - `terraform apply`

### Terraform Client

#### Setup API Key Authentication

1. Fork this repository into your own GitHub account
2. Clone the forked repository; example: `git clone https://github.com/<your account>/oci-liquibase-jenkins.git`
3. `cd oci-liquibase-jenkins/infra`
4. Update the [terraform.tfvars.tmpl](terraform.tfvars.tmpl) file and rename it to `terraform.tfvars`.     
    - For more information on the attributes and where to find the values, see [API Key Authentication](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm#APIKeyAuth).

#### Install Terraform

Instructions on installing Terraform are [here](https://www.terraform.io/intro/getting-started/install.html).  The manual, pre-compiled binary installation is quickest way to start using Terraform.

You can test that the install was successful by running the command:
    terraform

You should see usage information returned.

#### Build the Architecture

Once the environment has been setup.  Run the following to build the infrastructure:

```bash
terraform init
terraform apply
```

## Cleanup

Tear down the infrastructure by running the following: `terraform destroy`
