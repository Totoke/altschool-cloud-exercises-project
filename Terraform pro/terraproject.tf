terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  access_key = ""
  secret_key = ""
}

# Create VPC
resource "aws_vpc" "terraproject_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "terraproject_vpc"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "terraproject_internet_gateway" {
  vpc_id = aws_vpc.terraproject_vpc.id
  tags = {
    Name = "terraproject_internet_gateway"
  }
}

#create route table
resource "aws_route_table" "terraproject-route-table-public" {
  vpc_id = aws_vpc.terraproject_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraproject_internet_gateway.id
  }
  tags = {
    Name = "terraproject-route-table-public"
  }
}

resource "aws_route_table_association" "terraproject-public-subnet1-association" {
  subnet_id      = aws_subnet.terraproject-public-subnet1.id
  route_table_id = aws_route_table.terraproject-route-table-public.id
}
# Associate public subnet 2 with public route table
resource "aws_route_table_association" "terraproject-public-subnet2-association" {
  subnet_id      = aws_subnet.terraproject-public-subnet2.id
  route_table_id = aws_route_table.terraproject-route-table-public.id
}
# create public subnet-1
resource "aws_subnet" "terraproject-public-subnet1" {
  vpc_id                  = aws_vpc.terraproject_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "terraproject-public-subnet1"
  }
}
# Create Public Subnet-2
resource "aws_subnet" "terraproject-public-subnet2" {
  vpc_id                  = aws_vpc.terraproject_vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"
  tags = {
    Name = "terraproject-public-subnet2"
  }
}

resource "aws_network_acl" "terraproject-network_acl" {
vpc_id     = aws_vpc.terraproject_vpc.id
subnet_ids = [aws_subnet.terraproject-public-subnet1.id, aws_subnet.terraproject-public-subnet2.id]


 ingress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}

# security group for load balancer
  resource "aws_security_group" "terraproject-load_balancer_sg" {
  name        = "terraproject-load-balancer-sg"
  description = "Security group for the load balancer"
  vpc_id      = aws_vpc.terraproject_vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
 cidr_blocks = ["0.0.0.0/0"]
  }
}


# Create Security Group to allow port 22, 80 and 443 for ec2 instances
resource "aws_security_group" "terraproject-security-grp-rule" {
  name        = "allow_ssh_http_https"
  description = "Allow SSH, HTTP and HTTPS inbound traffic for private instances"
  vpc_id      = aws_vpc.terraproject_vpc.id
 ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.terraproject-load_balancer_sg.id]
  }

 ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.terraproject-load_balancer_sg.id]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = {
  tags = {
    Name = "terraproject-security-grp-rule"
  }
}

# creating instance 1
resource "aws_instance" "terraproject1" {
  ami             = "ami-00874d747dde814fa"
  instance_type   = "t2.micro"
  key_name        = "ExamProjectKey"
  security_groups = [aws_security_group.terraproject-security-grp-rule.id]
  subnet_id       = aws_subnet.terraproject-public-subnet1.id  availability_zone = "us-east-1a"
  tags = {
    Name   = "terraproject1"
    source = "terraform"
  }
}

# creating instance 2
 resource "aws_instance" "terraproject2" {
  ami             = "ami-00874d747dde814fa"
  instance_type   = "t2.micro"
  key_name        = "ExamProjectKey"
  security_groups = [aws_security_group.terraproject-security-grp-rule.id]
  subnet_id       = aws_subnet.terraproject-public-subnet2.id
  availability_zone = "us-east-1b"
  tags = {
    Name   = "terraproject2"
    source = "terraform"
  }
}
# creating instance 3
resource "aws_instance" "terraproject3" {
  ami             = "ami-00874d747dde814fa"
  instance_type   = "t2.micro"
  key_name        = "ExamProjectKey"
  security_groups = [aws_security_group.terraproject-security-grp-rule.id]
  subnet_id       = aws_subnet.terraproject-public-subnet1.id
  availability_zone = "us-east-1a"
  tags = {
    Name   = "terraproject3"
    source = "terraform"
  }
}

# Create a file to store the IP addresses of the instances
resource "local_file" "Ip_address" {
  filename ="/vagrant/terraform/host-inventory"
  content  = <<EOT
${aws_instance.terraproject1.public_ip}
${aws_instance.terraproject2.public_ip}
${aws_instance.terraproject3.public_ip}
  EOT
}

# Create an Application Load Balancer
resource "aws_lb" "terraproject-load-balancer" {
  name               = "terraproject-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.terraproject-load_balancer_sg.id]
  subnets            = [aws_subnet.terraproject-public-subnet1.id, aws_subnet.terraproject-public-subnet2.id]
  enable_cross_zone_load_balancing = true
  enable_deletion_protection = false
  depends_on                 = [aws_instance.terraproject1, aws_instance.terraproject2, aws_instance.terraproject3]
}

# Create the target group
resource "aws_lb_target_group" "terraproject-target-group" {
  name     = "terraproject-target-group"
  target_type = "instance"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.terraproject_vpc.id
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

# Create the listener
resource "aws_lb_listener" "terraproject-listener" {
  load_balancer_arn = aws_lb.terraproject-load-balancer.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.terraproject-target-group.arn
  }
}
# Create the listener rule
resource "aws_lb_listener_rule" "terraproject-listener-rule" {
  listener_arn = aws_lb_listener.terraproject-listener.arn
  priority     = 1
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.terraproject-target-group.arn
  }
  condition {
    path_pattern {
      values = ["/"]
    }
  }
}

# Attach the target group to the load balancer
resource "aws_lb_target_group_attachment" "terraproject-target-group-attachment1" {
  target_group_arn = aws_lb_target_group.terraproject-target-group.arn
  target_id        = aws_instance.terraproject1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "terraproject-target-group-attachment2" {
  target_group_arn = aws_lb_target_group.terraproject-target-group.arn
  target_id        = aws_instance.terraproject2.id
  port             = 80
}
resource "aws_lb_target_group_attachment" "terraproject-target-group-attachment3" {
  target_group_arn = aws_lb_target_group.terraproject-target-group.arn
  target_id        = aws_instance.terraproject3.id
  port             = 80

  }

# get hosted zone details
resource "aws_route53_zone" "hosted_zone" {
  name = var.domain_name
  tags = {
    Environment = "dev"
  }
}
# create a record set in route 53
# terraform aws route 53 record
resource "aws_route53_record" "site_domain" {
  zone_id = aws_route53_zone.hosted_zone.zone_id
  name    = "terraform-test.${var.domain_name}"
  type    = "A"
  alias {
    name                   = aws_lb.terraproject-load-balancer.dns_name
    zone_id                = aws_lb.terraproject-load-balancer.zone_id
    evaluate_target_health = true
  }
}
