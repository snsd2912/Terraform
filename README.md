## Providers
* Using ***provider*** block to specify which provider you wanna use
* For providers that is not maintained by Hashicorp, you need to add ***required_providers*** block

## Phases
Terraform stores the state of the infrastructure created from the TF files in a file called **Terraform State File**
This state will allow terraform to map real world resources to your existing configuration

* Run `terraform init` which in-return will download plugins associated with the provider
    *.terraform.lock.hcl* file is also created, define explicit version of terraform provider, then if you want to change version of terraform provider, you need to delete that file and run *terraform init* again
* Run `terraform plan` to see what's going to be provisioned
* Run `terraform apply` to provision resources
    **Terraform State File** is shown as *terraform.tfstate* file
    This file is written in JSON format, contains some keys as follow:
    *   outputs: include attributes and its value of what you define
    *   resources: include attributes and its value of what terraform have actually created 
* Run `terraform destroy` to delete all resources defined in this folder
    To delete only the targeted resources
```
-target [resource_type].[local_resource_name] 
Example: terraform destroy -target aws_instance.sanglv6-HelloWorld
```
    If you run 'terraform plan' once again after deleting resources, that deleted resources will be shown as what's gonna be provisioned
* Run `terraform refresh` to update current state to *terraform.tfstate* file
    Note: run this command will not update the TF files

## Variables
There are 4 ways to define a variable:
*   Enviroment variables: define in *terraform.tfvars* file
```
Ex: vpn_ip="172.25.10.148/32"
```
If you name your *[something_else].tfvars* file, run terraform apply command as following:
```
Ex: terraform apply -var-file="[something_else].tfvars"
```
*   Command line flags: using the following command
```
Ex: terraform apply -var="vpn_ip=172.25.10.148/32"
```
*   From a file
*   Variable defaults: define in an TF file with *variable* key
```
Ex: variable "vpn_ip" {
        default = "172.25.10.148/32"
    }
```





