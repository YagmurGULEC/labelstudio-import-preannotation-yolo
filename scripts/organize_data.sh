#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_DIR="$SCRIPT_DIR/../data/data"
NEW_DATA_DIR="$SCRIPT_DIR/../data/new_data"
mkdir -p "$NEW_DATA_DIR"
mkdir -p "$NEW_DATA_DIR/Images"
mkdir -p "$NEW_DATA_DIR/Annotations"


# (
# cd "$DATA_DIR" || exit 1


# annotations=$(find . -maxdepth 4 -type f -name "*.xml")
# images=$(find . -maxdepth 4 -type f \( -name "*.jpg" -o -name "*.png" \))
# echo "Number of annotations found: $(echo "$annotations" | wc -l)"
# echo "Number of images found: $(echo "$images" | wc -l)"
# # Collect all annotation base names
# match_count=0
# for annotation in $annotations; do
# echo "Processing annotation: $annotation"
#    base=$(basename "$annotation" .xml)
#    directory=$(dirname "$annotation")
#    image_directory=$(dirname "$directory")/JPEGImages
#     image_file="$image_directory/$base.jpg"
#     echo "Looking for image file: $image_file"

#     if [[ -f "$image_file" ]]; then
#         echo "Found matching image file: $image_file"
#         match_count=$((match_count + 1))
#         cp "$image_file" "$NEW_DATA_DIR/Images/"
#         cp "$annotation" "$NEW_DATA_DIR/Annotations/"
#     fi
# done
# echo "Total matching image files found: $match_count"
# echo "Copied $match_count matching image files to $NEW_DATA_DIR"

# )
(
cd "$NEW_DATA_DIR" || exit 1
echo $(find . -type f -name "*.jpg" | wc -l) "images found in $NEW_DATA_DIR/Images"
echo $(find . -type f -name "*.xml" | wc -l) "annotations found in $NEW_DATA_DIR/Annotations"
# zip -r "$NEW_DATA_DIR/Annotated.zip" .
# zip -r "$NEW_DATA_DIR/Annotated.zip" .
unzip "$NEW_DATA_DIR/Annotated.zip" -d "$NEW_DATA_DIR/Annotated" || echo "No zip file found, skipping unzip"
)
