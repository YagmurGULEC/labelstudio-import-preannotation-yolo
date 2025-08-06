variable "raw_path" {
  description = "The S3 path to the raw data"
  type        = string
  default     = "s3://label-studio-crawler-bucket/Annotations_label_studio/"
}

variable "data-lake-bucket" {
  description = "The name of the S3 bucket to use for data lake"
  type        = string
  default     = "label-studio-crawler-bucket"
}

variable "project" {
  description = "The name of the project"
  type        = string
  default     = "label-studio-crawler"
}

variable "glue_role_name" {
  description = "The name of the IAM role for Glue"
  type        = string
  default     = "glue_crawler_role"
}
