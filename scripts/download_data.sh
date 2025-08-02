#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mkdir -p $SCRIPT_DIR/../data_2012
cd $SCRIPT_DIR/../data_2012

# download train
wget http://host.robots.ox.ac.uk/pascal/VOC/voc2012/VOCtrainval_11-May-2012.tar
tar -xf VOCtrainval_11-May-2012.tar
rm -rf VOCtrainval_11-May-2012.tar

