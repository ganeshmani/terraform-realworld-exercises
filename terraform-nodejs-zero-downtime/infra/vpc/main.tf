
resource "aws_default_subnet" "default_subnet_ab" {
    availability_zone = "${var.aws_region}a"
}

resource "aws_default_subnet" "default_subnet_ac" {
    availability_zone = "${var.aws_region}b"
}

resource "aws_default_vpc" "ecs_vpc" {
    tags = {
        Name = "ecs-vpc"
    }
}