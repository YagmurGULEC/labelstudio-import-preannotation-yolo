module "ec2" {
  source                = "./modules/ec2"
  aws_region            = var.region
  s3_bucket_name        = var.s3_bucket_name
  ec2_setup_script_path = "${path.root}/../scripts/setup_ec2.sh"
  availability_zone     = var.availability_zone

}

# module "glue" {
#   source = "./modules/glue"

# }
