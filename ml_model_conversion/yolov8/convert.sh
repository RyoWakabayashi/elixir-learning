#!/bin/bash

python3 python/yolov8_to_onnx.py n
python3 python/yolov8_to_onnx.py x

cp -r ./models/* /tmp/models/

