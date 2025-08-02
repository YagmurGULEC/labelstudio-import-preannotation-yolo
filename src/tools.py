import asyncio
import json
import os
from pathlib import Path
import xml.etree.ElementTree as ET
import aiofiles
from dotenv import load_dotenv
from .config import VOC_CLASSES, MAX_CONCURRENT_WRITES
import boto3
import argparse

load_dotenv()
semaphore = asyncio.Semaphore(MAX_CONCURRENT_WRITES)

async def write_to_file(file_path, data):
    """Asynchronously write data to a file with concurrency control."""
    async with semaphore:
        async with aiofiles.open(file_path, 'w') as f:
            await f.write(data)

async def convert_to_label_studio_format(annotation_path, s3_bucket=None, img_prefix=None, image_dir=None, output_dir=None):
   
    tree = ET.parse(annotation_path)
    root = tree.getroot()
    # print(f"Processing {annotation_path}...")
    image_filename = root.findtext('filename')
    image_path = (
            f"s3://{s3_bucket}/{img_prefix}{image_filename}"
            if s3_bucket else str(Path(image_dir) / image_filename)
        )
    
    width = int(root.find('size/width').text)
    height = int(root.find('size/height').text)

    objects = root.findall('object')
    if not objects:
        print(f"⚠️ No objects found in {annotation_path}. Skipping.")
        return None

    results = []
    for obj in objects:
        label = obj.findtext('name')
        if label not in VOC_CLASSES:
            print(f"🚫 Label '{label}' not in VOC_CLASSES. Skipping.")
            continue

        bndbox = obj.find('bndbox')
        xmin, ymin, xmax, ymax = [float(bndbox.find(tag).text) for tag in ['xmin', 'ymin', 'xmax', 'ymax']]

        results.append({
            "from_name": "label",
            "to_name": "image",
            "type": "rectanglelabels",
            "value": {
                "x": xmin / width * 100,
                "y": ymin / height * 100,
                "width": (xmax - xmin) / width * 100,
                "height": (ymax - ymin) / height * 100,
                "rectanglelabels": [label]
            }
        })
    
    annotation = {
        "data": {"image": image_path},
        "annotations": [{"result": results}]
    }
    annotation_path = Path(output_dir) / f"{Path(annotation_path).stem}.json"
    
    return annotation_path,annotation





