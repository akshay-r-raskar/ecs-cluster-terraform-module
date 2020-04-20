variable "region" {
  type    = string
  default = "us-east-1"
}

variable "namespace" {
  type    = string
  default = "ddp-poc"
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "instance_type" {
  type    = string
  default = "t2.medium"
}

variable "instance_count" {
  type    = string
  default = "3"
}
