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
frame = dc.capture()
plt.imshow(frame[...,[2,1,0,3]]) #BGRA -> RGBA
plt.show()

dc.stop()
```

## Running Examples

```bash
cd build
make run-one-frame

cd build
make run-yolo-screen
```

or without make

```bash
cd examples/one-frame
python main.py

cd examples/yolo-screen
python main.py
```

## Note

Only available on mac for now

Default format is **BGRA**

To run the demo yolo-screen app
download YOLO_tiny.ckpt from

https://drive.google.com/file/d/0B2Jba