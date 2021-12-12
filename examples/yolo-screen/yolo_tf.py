
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
        self.build_networks()

    def build_networks(self):
        self.x = tf.placeholder('float32',[None,448,448,3])
        self.conv_1 = self.conv_layer(1,self.x,16,3,1)
        self.pool_2 = self.pooling_layer(2,self.conv_1,2,2)
        self.conv_3 = self.conv_layer(3,self.pool_2,32,3,1)
        self.pool_4 = self.pooling_layer(4,self.conv_3,2,2)
        self.conv_5 = self.conv_layer(5,self.pool_4,64,3,1)
        self.pool_6 = self.pooling_layer(6,self.conv_5,2,2)
        self.conv_7 = self.conv_layer(7,self.pool_6,128,3,1)
        self.pool_8 = self.pooling_layer(8,self.conv_7,2,2)
        self.conv_9 = self.conv_layer(9,self.pool_8,256,3,1)