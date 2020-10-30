variable project_name {
  default     = "serverless-rds-internet"
  description = "The base name of the project"
}

variable stage {
  description = "The development stage, like 'dev' or 'production'"
}

variable db_name {
  default = "test_db"
}

variable db_username {
  default = "postgres"
}

variable "region" {
  default = "us-west-2"
}

variable "cidr_block_vpc" {
  default = "10.1.0.0/16"
}

variable "cidr_block_subnet_public" {
  default = "10.1.1.0/24"
}
variable "cidr_block_subnets_private" {
  default = ["10.1.2.0/24", "10.1.3.0/24", "10.1.4.0/24"]
}

variable "bastion_host_key_pair_name" {
  default = "geoffpersonal_us_west_2"
}


