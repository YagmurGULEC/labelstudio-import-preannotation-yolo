import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from pyspark.sql import DataFrame
from pyspark.sql.functions import *
from pyspark.sql.types import *

# Initialize Glue context
args = getResolvedOptions(sys.argv, ['JOB_NAME', 'INPUT_PATH', 'OUTPUT_PATH'])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

def flatten_labelstudio_json(input_path, output_path):
    """
    Convert Label Studio JSON format to Parquet using Spark
    """
    
    # Read JSON files
    df = spark.read.option("multiline", "true").json(input_path)
    
    # Define the flattening transformation
    flattened_df = df.select(
        col("data.image").alias("image_path"),
        explode(col("annotations")).alias("annotation")
    ).select(
        col("image_path"),
        explode(col("annotation.result")).alias("result")
    ).where(
        col("result.type") == "rectanglelabels"
    ).select(
        col("image_path"),
        col("result.value.x").alias("x_coordinate"),
        col("result.value.y").alias("y_coordinate"),
        col("result.value.width").alias("width"),
        col("result.value.height").alias("height"),
        explode(col("result.value.rectanglelabels")).alias("class_label")
    ).withColumn(
        "x_center", col("x_coordinate") + col("width") / 2
    ).withColumn(
        "y_center", col("y_coordinate") + col("height") / 2
    ).withColumn(
        "area", col("width") * col("height")
    ).withColumn(
        "image_filename", regexp_extract(col("image_path"), "([^/]+)$", 1)
    ).withColumn(
        "processing_date", current_date()
    )
    
    # # Write as Parquet with partitioning
    flattened_df.write \
        .mode("overwrite") \
        .partitionBy("processing_date") \
        .option("compression", "snappy") \
        .parquet(output_path)
    
    
    
    return flattened_df

# Execute the transformation
result_df = flatten_labelstudio_json(args['INPUT_PATH'], args['OUTPUT_PATH'])

# Commit the job
job.commit()

