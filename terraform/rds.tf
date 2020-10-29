resource "random_string" "db_password" {
  length  = 16
  special = false
}

resource "aws_db_subnet_group" "db" {
  name       = "${local.tag_name}-db-sng"
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id, aws_subnet.private_3.id]

  tags = {
    Name = local.tag_name
  }
}

resource "aws_rds_cluster" "main" {
  cluster_identifier     = local.tag_name
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.db.name
  // It's recommended to have at least 3 in production
  availability_zones      = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1], data.aws_availability_zones.available.names[2]]
  engine                  = "aurora-postgresql"
  engine_mode             = "serverless"
  database_name           = var.db_name
  master_username         = var.db_username
  master_password         = random_string.db_password.result
  backup_retention_period = 7
  // As I work through this, I'm going to set this to true.
  // In production I'd recommend false
  skip_final_snapshot = true

  // So we can query in the AWS console among other things
  enable_http_endpoint = true

  scaling_configuration {
    // Save cost when not in use, you may want this
    // to be false in production depending on how often
    // you are querying the database
    auto_pause = true
    // just for testing
    min_capacity             = 2
    max_capacity             = 2
    seconds_until_auto_pause = 300
  }
}

output "db_connection" {
  value = "${var.db_username}:${random_string.db_password.result}@${aws_rds_cluster.main.endpoint}:5432/${var.db_name}"
}
