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
    this