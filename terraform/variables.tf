variable "region" {
  description = "The AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket to use for Glue Crawler"
  type        = string
  default     = "label-studio-crawler-bucket"
}

variable "availability_zone" {
  description = "The availability zone to deploy into"
  type        = string
  default     = "us-east-1a"
}

