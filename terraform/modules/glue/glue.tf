
resource "aws_iam_role" "glue_role" {
  name               = "${var.project}-glue-role"
  assume_role_policy = data.aws_iam_policy_document.glue_base_policy.json
  tags               = { Owner = "Terraform" }
}

resource "aws_iam_role_policy" "task_role_policy" {
  name   = "${var.project}-glue-role-policy"
  role   = aws_iam_role.glue_role.id
  policy = data.aws_iam_policy_document.glue_access_policy.json
}


resource "aws_glue_crawler" "s3_crawler" {
  name          = "${var.project}-analytics-db-crawler"
  database_name = aws_glue_catalog_database.analytics_database.name
  role          = aws_iam_role.glue_role.arn

  s3_target {
    path = "s3://${var.data-lake-bucket}/Annotations_parquet/"
  }

  recrawl_policy {
    recrawl_behavior = "CRAWL_EVERYTHING"
  }

  schema_change_policy {
    delete_behavior = "LOG"
    update_behavior = "LOG"
  }
}

resource "aws_glue_catalog_database" "analytics_database" {
  name = "${var.project}-analytics-db"
}

resource "aws_glue_job" "etl_job" {
  name         = "${var.project}-s3-etl-job"
  role_arn     = aws_iam_role.glue_role.arn
  glue_version = "4.0"

  command {
    name            = "glueetl"
    script_location = "s3://${var.data-lake-bucket}/Scripts/pyspark_convert.py"
    python_version  = 3
  }

  default_arguments = {
    "--enable-job-insights" = "true"
    "--job-language"        = "python"
    "--INPUT_PATH"          = "s3://${var.data-lake-bucket}/Annotations_label_studio/"
    "--OUTPUT_PATH"         = "s3://${var.data-lake-bucket}/Annotations_parquet/"
    "--glue_database"       = aws_glue_catalog_database.analytics_database.name
  }

  timeout           = 5
  tags              = { Owner = "Terraform" }
  number_of_workers = 2
  worker_type       = "G.1X"
}


