output "ecs_service_security_group_id" {
  value = aws_security_group.ecs_service_security_group 
}
output "alb_target_group" {
  value = aws_lb_target_group.alb_target_group
}