provider "aws" {
  region = "us-east-1"
}

# 0. Automatically find the latest Ubuntu 22.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical (the creators of Ubuntu)
}

# 1. Security Group for Docker Swarm
resource "aws_security_group" "swarm_sg" {
  name        = "docker-swarm-sg"
  description = "Allow SSH, HTTP, HTTPS and Swarm traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Swarm Management Port (Manager only usually, but open for all nodes for simplicity)
  ingress {
    from_port   = 2377
    to_port     = 2377
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Swarm Communication Ports
  ingress {
    from_port   = 7946
    to_port     = 7946
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 7946
    to_port     = 7946
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Overlay Network Port
  ingress {
    from_port   = 4789
    to_port     = 4789
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. EC2 Instances
resource "aws_instance" "swarm_manager" {
  ami                    = data.aws_ami.ubuntu.id # Uses the ID found above
  instance_type          = "t2.micro"
  key_name               = "vockey" 
  vpc_security_group_ids = [aws_security_group.swarm_sg.id]
  iam_instance_profile   = "LabInstanceProfile" 

  tags = { Name = "Swarm-Manager" }
}

resource "aws_instance" "swarm_worker" {
  count                  = 2
  ami                    = data.aws_ami.ubuntu.id # Uses the ID found above
  instance_type          = "t2.micro"
  key_name               = "vockey"
  vpc_security_group_ids = [aws_security_group.swarm_sg.id]
  iam_instance_profile   = "LabInstanceProfile"

  tags = { Name = "Swarm-Worker-${count.index}" }
}

# 3. Create Elastic IPs (Static IPs)
resource "aws_eip" "manager_eip" {
  instance = aws_instance.swarm_manager.id
  domain   = "vpc" 
}

resource "aws_eip" "worker_eip" {
  count    = 2
  instance = aws_instance.swarm_worker[count.index].id
  domain   = "vpc" 
}

# 4. FINAL OUTPUTS
output "static_manager_ip" {
  value = aws_eip.manager_eip.public_ip
}

output "static_worker_ips" {
  value = aws_eip.worker_eip[*].public_ip
}