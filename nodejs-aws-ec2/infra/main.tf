data "aws_ami" "ubuntu" {
    most_recent = true
    owners = ["099720109477"]

    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }
}


data "aws_key_pair" "nodejs-ec2-key-pair" {
    key_name = "nodejs-ec2-instance-kp"
}

resource "aws_instance" "nodejs-ec2-instance" {
    ami = data.aws_ami.ubuntu.id
    instance_type = "t2.micro"
    key_name = data.aws_key_pair.nodejs-ec2-key-pair.key_name
    tags = {
        Name = "nodejs-ec2-instance"
    }

    vpc_security_group_ids = [aws_security_group.nodejs-ec2-instance-sg.id]
    user_data = file("init.tpl")

    tags_all = {
        Name = "nodejs-ec2-instance"
    }

    lifecycle {
      prevent_destroy = false
    }
}

resource "aws_default_vpc" "default" {
  
}

resource "aws_security_group" "nodejs-ec2-instance-sg" {
    name = "nodejs-ec2-instance-sg"
    
    vpc_id = aws_default_vpc.default.id

  
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

