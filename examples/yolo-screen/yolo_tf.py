
import numpy as np
import tensorflow as tf
import cv2
import time
import sys
import matplotlib.pyplot as plt

DEBUG = False

class YOLO_TF:
    weights_file = 'YOLO_tiny.ckpt'
    alpha = 0.1
    threshold = 0.05
    iou_threshold = 0.2
    num_class = 20
    num_box = 2
    grid_size = 7
    classes =  ["aeroplane", "bicycle", "bird", "boat", "bottle", "bus", "car", "cat", "chair", "cow", "diningtable", "dog", "horse", "motorbike", "person", "pottedplant", "sheep", "sofa", "train","tvmonitor"]

    w_img = 640
    h_img = 480

    def __init__(self):