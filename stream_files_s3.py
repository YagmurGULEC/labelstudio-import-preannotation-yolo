import boto3
import zipfile
import io

# Your S3 bucket and (optional) prefix
bucket_name = "label-studio-crawler-bucket"
prefix = "pascal-voc-2012/"

# Path to your local ZIP file
zip_path = "./data/pascal-voc-2012-dataset.zip"

# Initialize S3 client (uses IAM role if on EC2)
s3 = boto3.client("s3")
print(s3)
# Open the zip file
with open(zip_path, "rb") as f:
    zip_bytes = io.BytesIO(f.read())

with zipfile.ZipFile(zip_bytes) as zip_file:
    for file_info in zip_file.infolist():
        if file_info.is_dir():
            continue  # Skip folders

        file_name = file_info.filename
        base_name = file_name.split("/")[-1]
        prefix_name = ""
        if  file_name.endswith(".xml"):
            if 'train_val' in file_name :
                # Remove the prefix from the file name
                prefix_name = "/train_val/Annotations/" + base_name
            elif 'test' in file_name:
                prefix_name = "/test/Annotations/" + base_name
        elif file_name.endswith(".jpg"):
            if 'train_val' in file_name:
                prefix_name = "/train_val/Images/" + base_name
            elif 'test' in file_name:
                prefix_name = "/test/Images/" + base_name
        if prefix_name:
            print(f"Uploading {file_name} to s3://{bucket_name}/{prefix_name}")
            # # Upload the file to S3
            with zip_file.open(file_info) as file_data:
                s3.upload_fileobj(file_data, bucket_name, prefix + prefix_name)
