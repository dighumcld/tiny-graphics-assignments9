
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