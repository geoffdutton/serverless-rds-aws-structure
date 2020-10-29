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
  default = "us-east-2"
}

variable "bastion_host_key_pair_name" {
  default = "geoffpersonal_us_east_2"
}


