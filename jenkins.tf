/* 
    Jenkins Server
*/

resource "aws_security_group" "jenkinsSG" {
  name        = "vpc_jenkins"
  description = "Allow incoming HTTP connections."

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 ingress {
    from_port   = 22
    to_port     = 22
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
    Name = "JenkinsSG"
  }
}

resource "aws_key_pair" "ubuntu" {
  key_name = "DevTrain"
  public_key = file("./DevTrain.pub")
 }


resource "aws_subnet" "ap-southeast-1a-public" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_instance" "jenkins" {
  ami                         = "${lookup(var.amis, var.aws_region)}"
  availability_zone           = "ap-southeast-1a"
  instance_type               = "t2.medium"
  key_name                    = aws_key_pair.ubuntu.key_name
  user_data                   = file("jenkinsinstall.sh")
  vpc_security_group_ids      = ["${aws_security_group.jenkinsSG.id}"]
  subnet_id                   = aws_subnet.ap-southeast-1a-public.id
  associate_public_ip_address = true
  source_dest_check           = false

  tags = {
    Name = "JenkinsServer"
  }
}
