
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
  }
  arg1 = reinterpret_cast< DeepCapture * >(argp1);
  ecode2 = SWIG_AsVal_unsigned_SS_int(obj1, &val2);
  if (!SWIG_IsOK(ecode2)) {
    SWIG_exception_fail(SWIG_ArgError(ecode2), "in method '" "DeepCapture__capture" "', argument " "2"" of type '" "uint32_t""'");
  }
  arg2 = static_cast< uint32_t >(val2);
  ecode3 = SWIG_AsVal_unsigned_SS_int(obj2, &val3);
  if (!SWIG_IsOK(ecode3)) {
    SWIG_exception_fail(SWIG_ArgError(ecode3), "in method '" "DeepCapture__capture" "', argument " "3"" of type '" "uint32_t""'");
  }
  arg3 = static_cast< uint32_t >(val3);
  ecode4 = SWIG_AsVal_unsigned_SS_int(obj3, &val4);
  if (!SWIG_IsOK(ecode4)) {
    SWIG_exception_fail(SWIG_ArgError(ecode4), "in method '" "DeepCapture__capture" "', argument " "4"" of type '" "uint32_t""'");
  }
  arg4 = static_cast< uint32_t >(val4);
  ecode5 = SWIG_AsVal_unsigned_SS_int(obj4, &val5);
  if (!SWIG_IsOK(ecode5)) {
    SWIG_exception_fail(SWIG_ArgError(ecode5), "in method '" "DeepCapture__capture" "', argument " "5"" of type '" "uint32_t""'");
  }
  arg5 = static_cast< uint32_t >(val5);

  npy_intp dims[1];
  dims[0] = (npy_intp) arg4*arg5*arg1->get_buffer()->bpp;
  array = PyArray_SimpleNew(1, dims, NPY_UINT8);
  if (!array) SWIG_fail;
  $1 = (uint8_t*) PyArray_DATA((PyArrayObject*)array);
}

%typemap(argout) uint8_t* DC_NUMPY_OUT
{
  $result = SWIG_Python_AppendOutput($result,(PyObject*)array$argnum);
}

%include "DeepCapture.h"
