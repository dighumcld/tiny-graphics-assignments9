
#ifndef _MACDISPLAYCAPTURE_H_
#define _MACDISPLAYCAPTURE_H_

#include "DeepCapture.h"

#include <pthread.h>

#import <CoreGraphics/CGDisplayStream.h>

class MacDisplayCapture : public DeepCapture
{
public:
  MacDisplayCapture();
  ~MacDisplayCapture();

  virtual void init();
  virtual void start();
  virtual void stop();
  virtual PixelBuffer* get_buffer();

private:
  void update(CGDisplayStreamFrameStatus status,
      uint64_t displayTime,
      IOSurfaceRef frameSurface,
      CGDisplayStreamUpdateRef updateRef);

  CGDisplayStreamRef stream_ref;
  pthread_mutex_t mutex;

  int width;
  int height;
  PixelBuffer* buffer;
};

#endif