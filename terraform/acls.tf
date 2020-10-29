resource "aws_network_acl" "private" {
  vpc_id = aws_vpc.main.id
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]
  ingress {
    action = "allow"
    from_port = 1024
    protocol = "tcp"
    rule_no = 100
    to_port = 65535
    cidr_block = aws_vpc.main.cidr_block
  }
//  egress {
//    protocol   = -1
//    rule_no    = 100
//    action     = "allow"
//    cidr_block = "0.0.0.0/0"
//    from_port  = 0
//    to_port    = 0
//  }
  tags = {
    Name = "${local.tag_name}-acl"
  }
}
