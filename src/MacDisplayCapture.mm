
#include "MacDisplayCapture.h"

#import <Cocoa/Cocoa.h>

#include <stdlib.h>
#include <unistd.h>
#include <iostream>
using namespace std;

const int MAX_DISPLAYS = 32;

MacDisplayCapture::MacDisplayCapture()
{
  pthread_mutex_init(&mutex, NULL);
}

MacDisplayCapture::~MacDisplayCapture()
{
  stop();
  delete buffer;
  pthread_mutex_destroy(&mutex);
}

void MacDisplayCapture::update(CGDisplayStreamFrameStatus status,
      uint64_t displayTime,
      IOSurfaceRef frameSurface,
      CGDisplayStreamUpdateRef updateRef)
{
  if (status == kCGDisplayStreamFrameStatusFrameComplete && frameSurface != NULL)
  {
    IOSurfaceLock(frameSurface, kIOSurfaceLockReadOnly, NULL);
    void* baseAddress = IOSurfaceGetBaseAddress(frameSurface);
    // int bytesPerRow = IOSurfaceGetBytesPerRow(frameSurface);
    // int totalBytes = bytesPerRow * height;
    // assert(totalBytes == buffer->size);
