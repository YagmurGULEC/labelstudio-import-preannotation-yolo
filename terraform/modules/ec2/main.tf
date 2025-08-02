

# resource "aws_s3_bucket" "my_bucket" {
#   bucket = "my-ec2-access-bucket-${random_id.bucket_id.hex}"

# }

# resource "aws_s3_bucket_public_access_block" "my_bucket_pab" {
#   bucket = aws_s3_bucket.my_bucket.id

#   block_public_acls       = true
#   block_public_policy     = true
#   ignore_public_acls      = true
#   restrict_public_buckets = true
# }
# resource "random_id" "bucket_id" {
#   byte_length = 4
# }

# resource "aws_iam_role" "ec2_s3_role" {
#   name = "ec2-s3-access-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [{
#       Action = "sts:AssumeRole",
#       Effect = "Allow",
#       Principal = {
#         Service = "ec2.amazonaws.com"
#       }
#     }]
#   })
# }

# resource "aws_iam_role_policy" "s3_access_policy" {
#   name = "ec2-s3-policy"
#   role = aws_iam_role.ec2_s3_role.id

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [{
#       Action = [
#         "s3:ListBucket",
#         "s3:GetObject",
#         "s3:PutObject"
#       ],
#       Effect = "Allow",
#       Resource = [
#         aws_s3_bucket.my_bucket.arn,
#         "${aws_s3_bucket.my_bucket.arn}/*"
#       ]
#     }]
#   })
# }

# resource "aws_iam_instance_profile" "ec2_instance_profile" {
#   name = "ec2-s3-profile"
#   role = aws_iam_role.ec2_s3_role.name
# }


# VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "custom-vpc"
  }
}

# Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "igw"
  }
}

# Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route"
  }
}

# Route Table Association
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Security Group for EC2 with port 8080 open
resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Allow port 8080"
  vpc_id      = aws_vpc.main.id

  #   ingress {
  #     from_port   = 8080
  #     to_port     = 8080
  #     protocol    = "tcp"
  #     cidr_blocks = ["0.0.0.0/0"]
  #   }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH (change this for security)
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP
  }
  # Allow HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
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
    Name = "ec2_sg"
  }
}

# EC2 instance with IAM role and public IP
resource "aws_instance" "web" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  #   iam_instance_profile        = aws_iam_instance_profile.ec2_instance_profile.name
  associate_public_ip_address = true
  key_name                    = var.key_name # use the key name in AWS
  user_data                   = file(var.ec2_setup_script_path)
  tags = {
    Name = "my-ec2"
  }
}


