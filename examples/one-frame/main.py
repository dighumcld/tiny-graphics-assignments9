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
