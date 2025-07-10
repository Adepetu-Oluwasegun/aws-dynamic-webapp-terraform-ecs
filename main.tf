# set aws provider
provider "aws" {
  region = var.region
  profile = "terraform-user"
}

# create vpc
resource "aws_vpc" "vpc" {
  cidr_block              = var.vpc_cidr
  instance_tenancy        = "default"
  enable_dns_hostnames    = true

  tags      = {
    Name    = "${var.project_name}-vpc"
  }
}

# create internet gateway and attach it to vpc
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id    = aws_vpc.vpc.id

  tags      = {
    Name    = "${var.project_name}-igw"
  }
}

# use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}

# create public subnet az1
resource "aws_subnet" "public_subnet_az1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_az1_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true

  tags      = {
    Name    = "public subnet az1"
  }
}

# create public subnet az2
resource "aws_subnet" "public_subnet_az2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_az2_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1] 
  map_public_ip_on_launch = true

  tags      = {
    Name    = "public subnet az2"
  }
}

# create route table and add public route
resource "aws_route_table" "public_route_table" {
  vpc_id       = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags       = {
    Name     = "public route table"
  }
}

# associate public subnet az1 to "public route table"
resource "aws_route_table_association" "public_subnet_az1_route_table_association" {
  subnet_id           = aws_subnet.public_subnet_az1.id
  route_table_id      = aws_route_table.public_route_table.id
}

# associate public subnet az2 to "public route table"
resource "aws_route_table_association" "public_subnet_az2_route_table_association" {
  subnet_id           = aws_subnet.public_subnet_az2.id
  route_table_id      = aws_route_table.public_route_table.id
}

# create private app subnet az1
resource "aws_subnet" "private_app_subnet_az1" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = var.private_app_subnet_az1_cidr
  availability_zone        = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "private app subnet az1"
  }
}

# create private app subnet az2
resource "aws_subnet" "private_app_subnet_az2" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = var.private_app_subnet_az2_cidr
  availability_zone        = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "private app subnet az2"
  }
}

# create private data subnet az1
resource "aws_subnet" "private_data_subnet_az1" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = var.private_data_subnet_az1_cidr
  availability_zone        = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "private data subnet az1"
  }
}

# create private data subnet az2
resource "aws_subnet" "private_data_subnet_az2" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = var.private_data_subnet_az2_cidr
  availability_zone        = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "private data subnet az2"
  }
}

# create elastic ip. this eip will be used for the nat-gateway in the public subnet az1 
resource "aws_eip" "eip_for_nat_gateway_az1" {
  domain =   "vpc"

  tags   = {
    Name = "nat gateway az1 eip"
  }
}

# create elastic ip. this eip will be used for the nat-gateway in the public subnet az2
resource "aws_eip" "eip_for_nat_gateway_az2" {
  domain = "vpc"

  tags   = {
    Name = "nat gateway az2 eip"
  }
}

# create nat gateway in public subnet az1
resource "aws_nat_gateway" "nat_gateway_az1" {
  allocation_id = aws_eip.eip_for_nat_gateway_az1.id
  subnet_id     = var.public_subnet_az1_id

  tags   = {
    Name = "nat gateway az1"
  }

  # to ensure proper ordering, it is recommended to add an explicit dependency
  depends_on = [var.internet_gateway]
}

# create nat gateway in public subnet az2
resource "aws_nat_gateway" "nat_gateway_az2" {
  allocation_id = aws_eip.eip_for_nat_gateway_az2.id
  subnet_id     = var.public_subnet_az2_id

  tags   = {
    Name = "nat gateway az2"
  }

  # to ensure proper ordering, it is recommended to add an explicit dependency
  # on the internet gateway for the vpc.
  depends_on = [var.internet_gateway]
}

# create private route table az1 and add route through nat gateway az1
resource "aws_route_table" "private_route_table_az1" {
  vpc_id            = var.vpc_id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat_gateway_az1.id
  }

  tags   = {
    Name = "private route table az1"
  }
}

# associate private app subnet az1 with private route table az1
resource "aws_route_table_association" "private_app_subnet_az1_route_table_az1_association" {
  subnet_id         = var.private_app_subnet_az1_id
  route_table_id    = aws_route_table.private_route_table_az1.id
}

# associate private data subnet az1 with private route table az1
resource "aws_route_table_association" "private_data_subnet_az1_route_table_az1_association" {
  subnet_id         = var.private_data_subnet_az1_id
  route_table_id    = aws_route_table.private_route_table_az1.id
}

# create private route table az2 and add route through nat gateway az2
resource "aws_route_table" "private_route_table_az2" {
  vpc_id            = var.vpc_id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.nat_gateway_az2.id
  }

  tags   = {
    Name = "private route table az2"
  }
}

# associate private app subnet az2 with private route table az2
resource "aws_route_table_association" "private_app_subnet_az2_route_table_az2_association" {
  subnet_id         = var.private_app_subnet_az2_id
  route_table_id    = aws_route_table.private_route_table_az2.id
}

# associate private data subnet az2 with private route table az2
resource "aws_route_table_association" "private_data_subnet_az2_route_table_az2_association" {
  subnet_id         = var.private_data_subnet_az2_id
  route_table_id    = aws_route_table.private_route_table_az2.id
}

# security group for the application load balancer
resource "aws_security_group" "alb_security_group" {
  name        = "alb security group"
  description = "enable http/https access on port 80/443"
  vpc_id      = var.vpc_id

  ingress {
    description      = "http access"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "https access"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "Application Load Balancer Security Group"
  }
}

# security group for the container
resource "aws_security_group" "ecs_security_group" {
  name        = "ecs security group"
  description = "enable http/https access on port 80/443 via alb sg"
  vpc_id      = var.vpc_id

  ingress {
    description      = "http access"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups  = [aws_security_group.alb_security_group.id]
  }

  ingress {
    description      = "https access"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    security_groups  = [aws_security_group.alb_security_group.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags   = {
    Name = "ECS Security Group"
  }
}

# request public certificates from the amazon certificate manager.
resource "aws_acm_certificate" "acm_certificate" {
  domain_name               = var.domain_name
  subject_alternative_names = [var.alternative_name]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# get details about a route 53 hosted zone
data "aws_route53_zone" "route53_zone" {
  name         = var.domain_name
  private_zone = false
}

# create a record set in route 53 for domain validatation
resource "aws_route53_record" "route53_record" {
  for_each = {
    for dvo in aws_acm_certificate.acm_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.route53_zone.zone_id
}

# validate acm certificates
resource "aws_acm_certificate_validation" "acm_certificate_validation" {
  certificate_arn         = aws_acm_certificate.acm_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.route53_record : record.fqdn]
}