
#ifndef _DEEPCAPTURE_H_
#define _DEEPCAPTURE_H_

#include "PixelBuffer.h"

class DeepCapture
{
public:
  virtual ~DeepCapture(){};

  virtual void init() = 0;
  virtual void start() = 0;
  virtual void stop() = 0;
  virtual PixelBuffer* get_buffer() = 0;
};

DeepCapture* create_display_capture();

#endif