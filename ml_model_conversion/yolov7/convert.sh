#!/bin/bash

python export.py \
  --weights yolov7x.pt \
  --img-size 640 640 \
  --grid \
  --simplify

cp yolov7x.onnx /tmp/models/

