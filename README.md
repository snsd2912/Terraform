# Terraform

## Phases
Terraform stores the state of the infrastructure created from the TF files in a file called **Terraform State File**\
This state will allow terraform to map real world resources to your existing configuration

* Run `terraform init` which in-return will download plugins associated with the provider\
    *.terraform.lock.hcl* file is also created, define explicit version of terraform provider, then if you want to change version of terraform provider, you need to delete that file and run *terraform init* again
* Run `terraform plan` to see what's going to be provisioned
    Using option *-out [file_name]* to write result to file
* Run `terraform apply` to provision resources\
    **Terraform State File** is shown as *terraform.tfstate* file\
    This file is written in JSON format, contains some keys as follow:\
    *   outputs: include attributes and its value of what you define
    *   resources: include attributes and its value of what terraform have actually created\
    Use the following command to apply the plan stored in the file (made by *terraform plan* command) to *terraform apply* command:\
    ```
    Ex: terraform apply -input=false [plan-file-name]
    ```
* Run `terraform destroy` to delete all resources defined in this folder
    To delete only the targeted resources
```
-target [resource_type].[local_resource_name] 
Example: terraform destroy -target aws_instance.sanglv6-HelloWorld
```
    If you run 'terraform plan' once again after deleting resources, that deleted resources will be shown as what's gonna be provisioned
* Run `terraform refresh` to update current state to *terraform.tfstate* file
    Note: run this command will not update the TF files
* Run `terraform validate` to check where the configuration is systactically valid

## Types of block

### [Terraform](https://www.terraform.io/language/settings)

Terraform settings are gathered together into terraform blocks:
```
terraform {
  # ...
}
```
The various options supported within a terraform block are described in the following sections:
#### [backend](https://www.terraform.io/language/settings/backends/configuration)

### [Providers](https://www.terraform.io/language/providers)
* Using ***provider*** block to specify which provider you wanna use
* For providers that is not maintained by Hashicorp, you need to add [***required_providers***](https://www.terraform.io/language/providers/requirements#requiring-providers) block

### Resource

Resources are the most important element in the Terraform language. Each resource block describes one or more infrastructure objects, such as virtual networks, compute instances, or higher-level components such as DNS records.

#### Syntax

```
                 __ resource_type
                |          __ resource_name
                |         |
resource "aws_instance" "web" {
  ami           = "ami-a1b2c3d4"
  instance_type = "t2.micro"
}

```

### [Module](https://www.terraform.io/language/modules)

### Variables
Variables are usually the declared inputs provided by either a calling module or input when running a tf plan/apply in the HCL directory in which it resides. An easy way to think of them is that they are the information that is passed IN.

#### Types of variable
It restricts what type you can assign to a variable\
If variable's type does not match, it will raise an error\
[Type constraints](https://www.terraform.io/language/expressions/type-constraints)

| Type   | Category | Description |
| ------ | -------- | ----------- |
| string | Primitive | A sequence of Unicode characters representing some text.<br>Ex: "hello" |
| number | Primitive | A numeric value. The number type can represent both whole numbers like 15 and fractional values like 6.283185 |
| bool   | Primitive | A boolean value, either true or false. bool values can be used in conditional logic. |
| list   | Complex - collection types | A sequence of values identified by consecutive whole numbers starting with zero.<br>Ex: ["root", "user1", "user2"]<br>You can access each value by using `var.[var_name][0]`] |
| map    | Complex - collection types | A collection of values where each is identified by a string label.<br>Ex: { "foo": "bar", "bar": "baz" } OR { foo = "bar", bar = "baz" }<br>You can access each value by using `var.[var_name]["foo"]`] | 
| set    | Complex - collection types | A collection of unique values that do not have any secondary identifiers or ordering. |
| tuple  | Complex - structural types | A sequence of elements identified by consecutive whole numbers starting with zero, **where each element has its own type**. |
| object | Complex - structural types | A group of values identified by named labels.<br>Ex: {name = "Mabel", age = 52}  |

Note: 
* Collection types: for grouping similar values
* Structural types: for grouping potentially dissimilar values
* [Conversion](https://www.terraform.io/language/expressions/type-constraints#conversion-of-complex-types)
* keyword "[any](https://www.terraform.io/language/expressions/type-constraints#dynamic-types-the-any-constraint)": *any* is not itself a type, when interpreting a value against a type constraint containing any, Terraform will attempt to find a single actual type that could replace the any keyword to produce a valid result.

#### How to define variables

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

### Locals
Locals are usually used for data transformation/aggregation/mutation from data derived from variables, other locals, data sources, resources, etc.
```
Ex: locals {
    common_tags = {
        Owner = "DevOps Teams"
        Service = local.other_local_name
    }
}

resource ... {
    ...
    tags = local.common_tags
}
```

### [Data Resources]((https://www.terraform.io/language/data-sources))

Data sources allow Terraform to use information defined outside of Terraform, defined by another separate Terraform configuration, or modified by functions.

Example: Let's suppose we want to create a new AWS EC2 instance. We want to use an AMI image which were created and uploaded by a Jenkins job using the AWS CLI, and **not managed by Terraform**. As part of the configuration for our Jenkins job, this AMI image will always have a name with the prefix app-.

In this case, we can use the aws_ami data source to obtain information about the most recent AMI image that has the name prefix app-.
```
data "aws_ami" "app_ami" {
  most_recent = true
  filter {
    name   = "name"
    values = ["app-*"]
  }
}
```

### [Dynamic Blocks](https://www.terraform.io/language/expressions/dynamic-blocks)

Example:
```
variable "sg_ports" {
    type    = list(number)
    default = [8200,8201,8202]
}

resource "aws_security_group" "aws_sg" {
    dynamic "ingress" {
        for_each = var.sg_ports
        iterator = port
        content {
            from_port = port.value // if not using iterator, use: ingress.value
            to_port   = port.value
            ...
        }
    }
}
```

## Advance

### Count and count index
The following syntax will create 8 ec2 instance 
```
Ex: resource "aws_instance" "ec2_test" {
    ami           = "ami-052efd3df9dad4825"
    instance_type = "t2.micro"
    name = "new_ec2_${count.index}" 
    count = 8
}
```
You can also define a list and assign that list to *name* file in the above example.

### Conditional Expression
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

### Debugging
Set TF_LOG to one of the log levels TRACE, DEBUG, INFO, WARN and ERROR
```
Ex: export TF_LOG=TRACE
    export TF_LOG_PATH=/path/to/log/file
```

### Tainting Resource

### Inport existing resources
terraform import

### [Built-in Functions](https://www.terraform.io/language/functions)

## [Terratest](https://github.com/gruntwork-io/terratest)
