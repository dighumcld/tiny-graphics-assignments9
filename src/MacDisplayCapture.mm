
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