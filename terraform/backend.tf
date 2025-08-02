terraform {

  backend "s3" {
    bucket = "terraform-state-storage-all"
    key    = "label-studio-crawler-2/terraform.tfstate"
    region = "us-east-1"
    # dynamodb_table = "terraform-locks"
  }
}
