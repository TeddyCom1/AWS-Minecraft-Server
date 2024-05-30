variable "vpc_id" {
    type = string
}

variable "subnet_id" {
    type = string
}

variable "instance_size" {
    type = string
    default = "t2.medium"
}