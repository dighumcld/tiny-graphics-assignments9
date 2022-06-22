
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

    pthread_mutex_lock(&mutex);
    memcpy(buffer->buffer, baseAddress, buffer->size);
    pthread_mutex_unlock(&mutex);

    IOSurfaceUnlock(frameSurface, kIOSurfaceLockReadOnly, NULL);

    size_t dropped_frames = CGDisplayStreamUpdateGetDropCount(updateRef);
    if (dropped_frames > 0)
    {
      cout << "Dropped: " << dropped_frames << " frames" << endl;
    }
  }
}

void MacDisplayCapture::init()
{
  CGDirectDisplayID displays[MAX_DISPLAYS];
  uint32_t numDisplays;

  CGGetActiveDisplayList(MAX_DISPLAYS, displays, &numDisplays);

  cout << "Displays["<< numDisplays << "]: ";
  for(int i = 0; i < numDisplays; i++)
  {
    cout << displays[i] << " ";
  }
  cout << endl;

  CGDirectDisplayID displayID = CGMainDisplayID();

  width = CGDisplayPixelsWide(displayID);
  height = CGDisplayPixelsHigh(displayID);
  buffer = new PixelBuffer(width, height, 4);

  NSDictionary *prop = @{
    (NSString*)kCGDisplayStreamShowCursor: (id)kCFBooleanTrue
  };

  stream_ref = CGDisplayStreamCreateWithDispatchQueue(displayID,
    width,
    height,
    'BGRA',
    (CFDictionaryRef)prop,
    dispatch_queue_create("me.zihao.deep-capture", DISPATCH_QUEUE_SERIAL),
     ^(CGDisplayStreamFrameStatus status,
      uint64_t displayTime,
      IOSurfaceRef frameSurface,