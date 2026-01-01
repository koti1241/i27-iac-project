variable "vpc_name" {
    description =" name of the vpc"
    type = string
}
variable "subnet" {
    description = "list of subnets to be created"
    type = list(object({
        name = string
        #network = string
        ip_cidr_range = string
        region = string
    }))
}

variable "instance" {
    description = " enter the values of instance"
    type = map(object({
        instance_type = string
        zone = string
        subnet = string
        disk_size = number

    }))
}