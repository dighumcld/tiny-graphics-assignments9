
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>

#include "DeepCapture.h"
#include "MacDisplayCapture.h"

#import <CoreGraphics/CGDisplayStream.h>
#import <Cocoa/Cocoa.h>

#include <iostream>
#include <ctime>
using namespace std;

#define MAX_DISPLAYS 32

CGDisplayStreamRef stream_ref;
int display_index = 0;

clock_t last_tick = 0;
clock_t fps = 0;
int fpassed = 0;

int width = 0;
int height = 0;

pthread_mutex_t mutex_update;

void update(CGDisplayStreamFrameStatus status,
      uint64_t displayTime,
      IOSurfaceRef frameSurface,
      CGDisplayStreamUpdateRef updateRef)
{
  if (status == kCGDisplayStreamFrameStatusFrameComplete && frameSurface != NULL)
  {
    IOSurfaceLock(frameSurface, kIOSurfaceLockReadOnly, NULL);

    void* baseAddress = IOSurfaceGetBaseAddress(frameSurface);
    int bytesPerRow = IOSurfaceGetBytesPerRow(frameSurface);

    int totalBytes = bytesPerRow * height;
    void *rawData = malloc(totalBytes);
    memcpy(rawData, baseAddress, totalBytes);
    usleep(1000);

    IOSurfaceUnlock(frameSurface, kIOSurfaceLockReadOnly, NULL);

    // cout << "Update: " << displayTime << endl;

    size_t dropped_frames = CGDisplayStreamUpdateGetDropCount(updateRef);
    if (dropped_frames > 0)
    {
      cout << "Dropped: " << dropped_frames << " frames" << endl;
    }

    if(!last_tick) last_tick = clock();

    pthread_mutex_lock(&mutex_update);

    fpassed++;
    // cout << "Update: " << fpassed << clock() - last_tick << " " << CLOCKS_PER_SEC << endl;

    // usleep(1000);
    // cout << (clock() - last_tick)/(double)CLOCKS_PER_SEC  << endl;
    if((clock() - last_tick)/(double)CLOCKS_PER_SEC >= 0.05)
    {
      // cout << "Update: " << fpassed << clock() - last_tick << " " << CLOCKS_PER_SEC << endl;
      cout << "FPS: " << fpassed/(clock() - last_tick)/(double)CLOCKS_PER_SEC << endl;

      last_tick = clock();
      fpassed = 0;
    }
    pthread_mutex_unlock(&mutex_update);
  }
}

void init()
{
  CGDirectDisplayID displays[MAX_DISPLAYS];
  uint32_t numDisplays;