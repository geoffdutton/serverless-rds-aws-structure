// Find the latest default amazon AMI

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

// Create a small instance to be able to tunnel
// to the database, run migrations, etc

resource "aws_instance" "bastion_host" {
  ami = data.aws_ami.amazon_linux_2.id
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.ssh.id]
  subnet_id = aws_subnet.public.id
  associate_public_ip_address = true
  // For the key pair, we could use terraform
  // to generate it, but I've chosen to just
  // create it via the AWS console.
  //
  // Make sure it's a key pair name from the same
  // region in vars.tf, i.e. us-east-2
  key_name = var.bastion_host_key_pair_name
  root_block_device {
    volume_type = "gp2"
    volume_size = 100
    encrypted = true
  }
  tags = {
    Name = "${local.tag_name}-bastion-host"
  }
}
// Output the ssh command for quick access
output "ssh_cmd" {
  value = "ssh -i ~/.ssh/${var.bastion_host_key_pair_name}.pem ec2-user@${aws_instance.bastion_host.public_ip}"
}
