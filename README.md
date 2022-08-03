## Providers
* Using ***provider*** block to specify which provider you wanna use
* For providers that is not maintained by Hashicorp, you need to add ***required_providers*** block

## Phases
Terraform stores the state of the infrastructure created from the TF files in a file called **Terraform State File**\
This state will allow terraform to map real world resources to your existing configuration

* Run `terraform init` which in-return will download plugins associated with the provider\
    *.terraform.lock.hcl* file is also created, define explicit version of terraform provider, then if you want to change version of terraform provider, you need to delete that file and run *terraform init* again
* Run `terraform plan` to see what's going to be provisioned
* Run `terraform apply` to provision resources\
    **Terraform State File** is shown as *terraform.tfstate* file\
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

## Types of variable
It restricts what type you can assign to a variable\
If variable's type does not match, it will raise an error

| Type | Description |
| ------ | ------ |
| string | a sequence of Unicode characters representing some text, like "hello" |
| number | a numeric value. The number type can represent both whole numbers like 15 and fractional values like 6.283185 |
| bool | a boolean value, either true or false. bool values can be used in conditional logic. |
| list/tuple | a boolean value, either true or false. bool values can be used in conditional logic, like ["value1", "value2"\ You can access each value by using `var.[var_name][0]`] |
| map/object | a group of values identified by named labels, like {name = "Mabel", age = 52}\ You can access each value by using `var.[var_name][0] or var.[var_name]["age"]`] |
| null | a value that represents absence or omission |

```
Ex: variable "vpn_ip" {
        default = "172.25.10.148/32"
        type = string
    }
```

## Count and count index
The following syntax will create 8 ec2 instance 
```
Ex: resource "aws_instance" "ec2_test" {
    ami           = "ami-052efd3df9dad4825"
    instance_type = "t2.micro"
    name = "new_ec2_${count.index}" 
    count = 8
}
```
You can also define a list and assign that list to *name* file in the above example.\

## Conditional Expression
```
EX: 
variable "something" {
    default = false
}

resource "aws_instance" "ec2_test" {
    ... 
    count = var.something == true ? 1 : 0
}
```