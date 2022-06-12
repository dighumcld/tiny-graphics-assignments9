#ifndef _PIXELBUFFER_H_
#define _PIXELBUFFER_H_

#ifndef SWIG
#include <cstdint>
#include <cstring>
#include <cassert>
#include <cstdio>
#endif

class PixelBuffer {
public:
  PixelBuffer(uint32_t width, uint32_t height, uint32_t bpp){
    this->width = width;
    this->height = height;
    this->bpp = bpp;
    this->size = width * height * bpp;
    this->buffer = new uint8_t[size];
  };
  ~PixelBuffer(){
  	delete buffer;
  };

  PixelBuffer* copy() {
    PixelBuffer* buf = new PixelBuffer(width, height, bpp);
    memcpy(buf->buffer, buffer, size);
    return buf;
  }

  PixelBuffer* crop(uint32_t x, uint32_t y, uint32_t w, uint32_t h) {
  	assert(x + w <= width);
  	assert(y + h <= height);

  	PixelBuffer* buf = new PixelBuffer(w, h, bpp);
  	uint8_t* ps = buffer + x * bpp + y * width * bpp;
  	uint8_t* pd = buf->buffer;
  	for(int i = 0; i < h; i++) {
  		memcpy(pd, ps, w * bpp);
  		ps += width * bpp;
  		pd += w * bpp;
  	}
  	return buf;
  }

  uint32_t width;
  uint32_t height;
  uint32_t bpp;
  uint32_t size;
  uint8_t* buffer;
};

#endif
