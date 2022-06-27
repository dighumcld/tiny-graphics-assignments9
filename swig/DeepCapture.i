
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

%{
#include "DeepCapture.h"
%}

%typemap(in,numinputs=0) uint8_t* DC_NUMPY_OUT
  (PyObject* array = NULL)
{
	if (!PyArg_ParseTuple(args,(char *)"OOOOO:DeepCapture__capture",&obj0,&obj1,&obj2,&obj3,&obj4)) SWIG_fail;
  res1 = SWIG_ConvertPtr(obj0, &argp1,SWIGTYPE_p_DeepCapture, 0 |  0 );
  if (!SWIG_IsOK(res1)) {
    SWIG_exception_fail(SWIG_ArgError(res1), "in method '" "DeepCapture__capture" "', argument " "1"" of type '" "DeepCapture *""'");