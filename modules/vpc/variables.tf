
variable "existing_vpc_id" {
  type        = string
  description = "ID of the existing VPC"
  default = "vpc-04ef858a4c609cde4"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block of the existing VPC"
  default  =  "10.0.128.0/20"
}

variable "subnet_count" {
  type        = number
  description = "Number of subnets to create"
  default     = 2
}