output "region" {
  value = var.region
}

output "project_name" {
  value = var.project_name
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_az1_id" {
  value = aws_subnet.public_subnet_az1.id
}

output "public_subnet_az2_id" {
  value = aws_subnet.public_subnet_az2.id
}

output "private_app_subnet_az1_id" {
  value = aws_subnet.private_app_subnet_az1.id
}

output "private_app_subnet_az2_id" {
  value = aws_subnet.private_app_subnet_az2.id
}

output "private_data_subnet_az1_id" {
  value = aws_subnet.private_data_subnet_az1.id
}

output "private_data_subnet_az2_id" {
  value = aws_subnet.private_data_subnet_az2.id
}

output "internet_gateway" {
  value = aws_internet_gateway.internet_gateway.id
}

output "alb_security_group_id" {
  value = aws_security_group.alb_security_group.id
}

output "ecs_security_group_id" {
  value = aws_security_group.ecs_security_group.id
}

output "alb_target_group_arn" {
  value =  aws_lb_target_group.alb_target_group.arn
}

output "application_load_balancer_dns_name" {
  value = aws_lb.application_load_balancer.dns_name
}

output "application_load_balancer_zone" {
  value = aws_lb.application_load_balancer.zone_id
}