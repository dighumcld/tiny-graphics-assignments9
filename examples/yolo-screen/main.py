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
        CAPTURE_SIZE[1] = int(argv[4])

    SCREEN_SIZE = CAPTURE_SIZE
    SCREEN_FLAG = DOUBLEBUF|HWSURFACE|RESIZABLE

    # frame = cv2.imread('person.jpg')
    # frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)

    yolo = yolo_tf.YOLO_TF()
    dc = deep_capture.create_display_capture()
    dc.init()
    dc.start()

    pygame.init()
    screen = pygame.display.set_mode(SCREEN_SIZE, SCREEN_FLAG)
    pygame.display.set_caption("YOLO Screen")
    font = pygame.font.SysFont("Courier New",15)
    clock = pygame.time.Clock()

    detect = True
    running = True

    try:
        while running:
            clock.tick()
            for event in pygame.event.get():
                if event.type == Q