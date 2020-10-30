data "template_file" "vpc_config" {
  // fil = file("${path.module}/../src/vpc.js")
  template = file("${path.module}/templates/vpc.js.tpl")
  vars = {
    region           = jsonencode(var.region)
    securityGroupIds = jsonencode([aws_security_group.lambda.id])
    subnetIds = jsonencode(
      aws_subnet.private.*.id
    )
  }
}

resource "local_file" "vpc_config" {
  filename = "${path.module}/../src/vpc.${var.stage}.js"
  content  = data.template_file.vpc_config.rendered
}

data "template_file" "dotenv" {
  template = file("${path.module}/templates/dotenv.tpl")
  vars = {
    pg_host     = aws_rds_cluster.main.endpoint
    pg_user     = aws_rds_cluster.main.master_username
    pg_password = aws_rds_cluster.main.master_password
    pg_database = aws_rds_cluster.main.database_name
  }
}

resource "local_file" "dotenv" {
  filename = "${path.module}/../src/.env.${var.stage}"
  content  = data.template_file.dotenv.rendered
}
