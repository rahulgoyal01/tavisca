#variable "aws_access_key" {}
#variable "aws_secret_key" {}

variable "aws_region" {
  description = "EC2 Region for the VPC"
  default     = "ap-southeast-1"
}

variable "amis" {
  description = "AMIs by region"
  default = {
    ap-southeast-1 = "ami-0d058fe428540cd89" # ubuntu 20.04 LTS
  }
}

variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default     = "172.16.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the Public Subnet"
  default     = "172.16.0.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the Private Subnet"
  default     = "172.16.1.0/24"
}

variable "root_device_type" {
  description = "Type of the root block device"
  type        = string
  default     = "gp2"
}
 
variable "root_device_size" {
  description = "Size of the root block device"
  type        = string
  default     = "50"
}