from src.tools import convert_to_label_studio_format,write_to_file
import asyncio
import os
import argparse
from pathlib import Path
import pandas as pd 
import json
from src.config import VOC_CLASSES, MAX_CONCURRENT_WRITES

def flatten_json(json_data, output_dir=None):
    image_id= json_data.get('data', '').get('image', '')
    all_rows = []
    annotations=json_data.get('annotations', [])
    for annotation in annotations:
        results = annotation.get('result', [])
        for result in results:
            if result['type'] == 'rectanglelabels':
                value = result.get('value', {})
                x = value.get('x', 0)
                y = value.get('y', 0)
                width = value.get('width', 0)
                height = value.get('height', 0)
                rectanglelabels = value.get('rectanglelabels', [])
                label = rectanglelabels[0] if rectanglelabels else ''
                all_rows.append({
                    'image_id': image_id,   
                    'x': x,
                    'y': y,
                    'width': width,
                    'height': height,
                    'label': label
                })
        
    
    
    return all_rows

async def main(annotation_dir,train=True,s3_bucket=None, img_prefix=None, image_dir=None, output_dir=None, output_dir_2=None):
    """
    Main function to convert VOC annotations to Label Studio format.
    """
    semaphore = asyncio.Semaphore(MAX_CONCURRENT_WRITES)
    annotation_files = [os.path.join(annotation_dir, f) for f in os.listdir(annotation_dir) if f.endswith('.xml')]
    print (f"Found {len(annotation_files)} annotation files.")
    annotation_files = sorted(annotation_files)
    # annotation_files=annotation_files[:2]  # Limit to 1000 files for testing
  
    if not annotation_files:
        print("No XML annotation files found in the specified directory.")
        return

    tasks = [
        convert_to_label_studio_format(
            annotation_path=annotation_file,
            s3_bucket=s3_bucket,
            img_prefix=img_prefix,
            image_dir=image_dir,
            output_dir=output_dir
        ) for annotation_file in annotation_files
    ]
    os.makedirs(output_dir, exist_ok=True)
    os.makedirs(output_dir_2, exist_ok=True)
    results = await asyncio.gather(*tasks)
    write_tasks = []
    for result in results:
        if result is not None:
            annotation_path, annotation = result

            # Write flattened format
            raws = flatten_json(annotation)
           
            # annotation_path_flat = Path(output_dir_2) / f"{Path(annotation_path).stem}_flat.csv"
            # df = pd.DataFrame(raws)
            # df.to_csv(annotation_path_flat, index=False)
    write_tasks.extend([
        write_to_file(annotation_path, json.dumps(annotation, indent=2),semaphore)
        for annotation_path, annotation in results if annotation is not None
        ])

    await asyncio.gather(*write_tasks)
    
 


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Convert VOC annotations to Label Studio format.")
    parser.add_argument("--main_dir", type=str,default="./data_2012/VOCdevkit/VOC2012", help="Directory containing VOC XML annotation files.")
    parser.add_argument("--s3_bucket", type=str,  default="yolo-voc-pascal",help="S3 bucket name forstoring images and annotations.")
    parser.add_argument("--img_prefix", type=str, default="images/", help="Prefix for image paths in S3 bucket.",)
    parser.add_argument("--output_dir", type=str, default="./bucket/Annotations", help="Directory containing images.")
    parser.add_argument("--output_dir_2", type=str, default="./bucket/Annotations_Glue", help="Directory containing images.")
    args = parser.parse_args()
    
    # dir= Path(args.main_dir)

    dir=Path("..")
    annotation_dir = str(dir / 'Annotations')
    image_dir = str(dir / 'JPEGImages')

    s3_bucket = args.s3_bucket
    img_prefix =args.img_prefix if args.s3_bucket else None
    
    output_dir = args.output_dir
    output_dir_2 = args.output_dir_2
    asyncio.run(main(annotation_dir,
        s3_bucket=args.s3_bucket,
        img_prefix=args.img_prefix,
        image_dir=image_dir,
        output_dir=args.output_dir,
        output_dir_2=args.output_dir_2
    ))
    json_files=[file for file in os.listdir(output_dir) if file.endswith('.json')]
 