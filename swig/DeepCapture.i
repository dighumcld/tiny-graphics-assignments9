
%module deep_capture

%{
#define SWIG_FILE_WITH_INIT
%}

%include "numpy.i"
%include "stdint.i"

%init %{
import_array();
%}

%newobject PixelBuffer::copy;
%newobject PixelBuffer::crop;