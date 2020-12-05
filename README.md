## Deep Capture

Display / Camera Capturing for Deep Learning Pipeline

Designed for real-time deep/reinfororcement learning agent in real environment.

Capturing video data in numpy format at high frame rate

![demo](https://raw.githubusercontent.com/zzh8829/deep-capture/master/demo.png)

## Compiling
```bash
./build.sh
cd lib/python
pip install -e .
```
pre-req: cmake, numpy, swig, python3

## Usage
See examples/one-frame/main.py

```python
import deep_capture
import matplotlib.pyplot as plt
import time

dc = deep_capture.create_display_capture()
dc.init()
dc.start()

time.sleep(0.1) # Wait for start
frame = dc.c