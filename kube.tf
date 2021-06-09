/*
  MiniKube Servers
*/
resource "aws_security_group" "kubevpc" {
  name        = "vpc_kube"
  description = "Allow incoming database connections."

  ingress {
    from_port       = 30000
    to_port         = 32767
    protocol        = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress { 
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  vpc_id = aws_vpc.default.id

  tags = {
    Name = "KubeSG"
  }
}

resource "aws_subnet" "ap-southeast-1a-private" {
  vpc_id = aws_vpc.default.id

  cidr_block        = var.private_subnet_cidr
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "Private Subnet"
  }
} 

resource "aws_instance" "kube" {
  ami                    = "${lookup(var.amis, var.aws_region)}"
  availability_zone      = "ap-southeast-1a"
  instance_type          = "t2.medium"
  key_name               = aws_key_pair.ubuntu.key_name
  user_data              = file("minikubeinstall.sh")
  vpc_security_group_ids = ["${aws_security_group.kubevpc.id}"]
  subnet_id              = aws_subnet.ap-southeast-1a-private.id
  source_dest_check      = false

  root_block_device {
    delete_on_termination = true
    encrypted             = false
    volume_size           = var.root_device_size
    volume_type           = var.root_device_type
  }

  tags = {
    Name = "KubeServer"
  }
}  