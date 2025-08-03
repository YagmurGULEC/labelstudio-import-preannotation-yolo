variable "aws_region" {
  description = "The AWS region to deploy into"
  type        = string

}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket to use for Glue Crawler"
  type        = string

}
variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
  default     = "ami-0cbbe2c6a1bb2ad63" # Example AMI ID, replace with your own

}

variable "availability_zone" {
  description = "The availability zone to deploy into"
  type        = string

}

variable "instance_type" {
  description = "The type of EC2 instance to launch"
  type        = string
  default     = "t2.micro" # Example instance type, replace with your own
}

variable "key_name" {
  description = "The name of the key pair to use for SSH access to the EC2 instance"
  type        = string
  default     = "new-key" # Replace with your key pair name
}
variable "ec2_setup_script_path" {
  description = "The path to the EC2 setup script"
  type        = string

}

variable "existing_bucket_name" {
  description = "The name of the existing S3 bucket to use for EC2 instance role policy"
  type        = string
  default     = "label-studio-crawler-bucket" # Replace with your existing bucket name
}
