output "vpc" {
    value = aws_default_vpc.ecs_vpc
}

output "default_subnet_ab" {
    value = aws_default_subnet.default_subnet_ab.id
}

output "default_subnet_ac" {
    value = aws_default_subnet.default_subnet_ac.id
}