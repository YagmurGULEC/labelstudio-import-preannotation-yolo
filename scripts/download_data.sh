#!/bin/bash


source .venv/bin/activate
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mkdir -p $SCRIPT_DIR/../data
cd $SCRIPT_DIR/../data

kaggle datasets download gopalbhattrai/pascal-voc-2012-dataset
# # download train
# wget http://host.robots.ox.ac.uk/pascal/VOC/voc2007/VOCtrainval_06-Nov-2007.tar
# tar -xf VOCtrainval_06-Nov-2007.tar
# mv VOCdevkit VOCdevkit_2007
# rm VOCtrainval_06-Nov-2007.tar

# # download test and combine into same directory
# wget http://host.robots.ox.ac.uk/pascal/VOC/voc2007/VOCtest_06-Nov-2007.tar
# tar -xf VOCtest_06-Nov-2007.tar
# mv VOCdevkit/VOC2007 VOCdevkit_2007/VOC2007test
# rmdir VOCdevkit
# rm VOCtest_06-Nov-2007.tar
