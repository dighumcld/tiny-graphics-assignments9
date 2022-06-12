
#include "DeepCapture.h"

#ifdef _WIN32
  #error "Windows is not supported yet"
#elif __APPLE__
  #include "MacDisplayCapture.h"

  DeepCapture* create_display_capture()
  {
    return new MacDisplayCapture();
  }
#elif __linux__
  #error "Windows is not supported yet"
#else
  #error "Unknown compiler"
#endif
