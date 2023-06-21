variable "region" {
  description = "The project region"
  default = "eu-north-1"
}

variable "instance_ami" {
  description = "Linux version"
  default = "ami-08766f81ab52792ce"
}

variable "instance_type" {
  default     = "t3.micro"
}

variable "instance_key_name" {
  description = "Name ssh key"
  default = "nginx-ssh"
}

variable "instance_tag" {
  default     = "exchange-currency-2"
}

variable "secure_group_name" {
  default     = "exchange-security-group"
}

variable "user_name" {
    default = "example_user"
}

variable "user_policy_name" {
    default = "example_user_policy"
}