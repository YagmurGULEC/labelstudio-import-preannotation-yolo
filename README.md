## Introduction  

This repository is to import your object detection datasets ready for training for Yolo models. The dataset to be used is well-known Pascal VOC 2012 dataset.

1. Download preannotated Pascal VOC datasets. 
```bash

chmod +x download_data.sh
./download_data.sh
```
2. Create a Python environment by either uv package, you may follow the installation steps through the link (https://docs.astral.sh/uv/getting-started/installation). After the installation, you can create the environment to install the necessary packages.
```bash 
uv venv
source .venv/bin/activate
```
2. After downloading the VOC2012 dataset, you need to convert them into Label Studio format.
```
uv run python generate_annotations.py 
```
3. You can run glue jobs locally 
```
docker-compose run glue-local spark-submit   src/pyspark_convert.py   --JOB_NAME test_job   --INPUT_PATH /home/hadoop/workspace/data   --OUTPUT_PATH /home/hadoop/workspace/data/output
```
4. Ensure write permissions on the host folder
```
chmod -R 777 workspace/data
```
5. You can infer schema by running
```
docker-compose run glue-local spark-submit   src/create_schema.py   --JOB_NAME test_job   --INPUT_PATH /home/hadoop/workspace/data   --OUTPUT_PATH /home/hadoop/workspace/output
```
