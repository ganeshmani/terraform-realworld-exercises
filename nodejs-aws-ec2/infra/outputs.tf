output "nodejs-ec2-instance" {
    description = "Public IP of the Node.js EC2 instance"
    value = aws_instance.nodejs-ec2-instance.public_ip
}