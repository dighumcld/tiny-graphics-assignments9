import time
import matplotlib.pyplot as plt

import sys; sys.path.append('../../lib/python')
import deep_capture

import yolo_tf

import numpy as np
import cv2
import pygame
from pygame.locals import *

CAPTURE_ORIGIN = [200,0]
CAPTURE_SIZE = [800,500]

# x, y, w, h
def main(argv):
    if len(argv) > 1:
        CAPTURE_ORIGIN[0] = int(argv[1])
        CAPTURE_ORIGIN[1] = int(argv[2])
        CAPTURE_SIZE[0] = int(argv[3])
        CAPT