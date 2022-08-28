
/* -*- C -*-  (not really, but good for syntax highlighting) */

/*
 * Copyright (c) 2005-2015, NumPy Developers.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *
 *     * Redistributions of source code must retain the above copyright
 *        notice, this list of conditions and the following disclaimer.
 *
 *     * Redistributions in binary form must reproduce the above
 *        copyright notice, this list of conditions and the following
 *        disclaimer in the documentation and/or other materials provided
 *        with the distribution.
 *
 *     * Neither the name of the NumPy Developers nor the names of any
 *        contributors may be used to endorse or promote products derived
 *        from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#ifdef SWIGPYTHON

%{
#ifndef SWIG_FILE_WITH_INIT
#define NO_IMPORT_ARRAY
#endif
#include "stdio.h"
#define NPY_NO_DEPRECATED_API NPY_1_7_API_VERSION
#include <numpy/arrayobject.h>
%}

/**********************************************************************/

%fragment("NumPy_Backward_Compatibility", "header")
{
%#if NPY_API_VERSION < 0x00000007
%#define NPY_ARRAY_DEFAULT NPY_DEFAULT
%#define NPY_ARRAY_FARRAY  NPY_FARRAY
%#define NPY_FORTRANORDER  NPY_FORTRAN
%#endif
}

/**********************************************************************/

/* The following code originally appeared in
 * enthought/kiva/agg/src/numeric.i written by Eric Jones.  It was
 * translated from C++ to C by John Hunter.  Bill Spotz has modified
 * it to fix some minor bugs, upgrade from Numeric to numpy (all
 * versions), add some comments and functionality, and convert from
 * direct code insertion to SWIG fragments.
 */

%fragment("NumPy_Macros", "header")
{
/* Macros to extract array attributes.
 */
%#if NPY_API_VERSION < 0x00000007
%#define is_array(a)            ((a) && PyArray_Check((PyArrayObject*)a))
%#define array_type(a)          (int)(PyArray_TYPE((PyArrayObject*)a))
%#define array_numdims(a)       (((PyArrayObject*)a)->nd)
%#define array_dimensions(a)    (((PyArrayObject*)a)->dimensions)
%#define array_size(a,i)        (((PyArrayObject*)a)->dimensions[i])
%#define array_strides(a)       (((PyArrayObject*)a)->strides)
%#define array_stride(a,i)      (((PyArrayObject*)a)->strides[i])
%#define array_data(a)          (((PyArrayObject*)a)->data)
%#define array_descr(a)         (((PyArrayObject*)a)->descr)
%#define array_flags(a)         (((PyArrayObject*)a)->flags)
%#define array_enableflags(a,f) (((PyArrayObject*)a)->flags) = f
%#define array_is_fortran(a)    (PyArray_ISFORTRAN((PyArrayObject*)a))
%#else
%#define is_array(a)            ((a) && PyArray_Check(a))
%#define array_type(a)          PyArray_TYPE((PyArrayObject*)a)
%#define array_numdims(a)       PyArray_NDIM((PyArrayObject*)a)
%#define array_dimensions(a)    PyArray_DIMS((PyArrayObject*)a)
%#define array_strides(a)       PyArray_STRIDES((PyArrayObject*)a)
%#define array_stride(a,i)      PyArray_STRIDE((PyArrayObject*)a,i)
%#define array_size(a,i)        PyArray_DIM((PyArrayObject*)a,i)
%#define array_data(a)          PyArray_DATA((PyArrayObject*)a)
%#define array_descr(a)         PyArray_DESCR((PyArrayObject*)a)
%#define array_flags(a)         PyArray_FLAGS((PyArrayObject*)a)
%#define array_enableflags(a,f) PyArray_ENABLEFLAGS((PyArrayObject*)a,f)
%#define array_is_fortran(a)    (PyArray_IS_F_CONTIGUOUS((PyArrayObject*)a))
%#endif
%#define array_is_contiguous(a) (PyArray_ISCONTIGUOUS((PyArrayObject*)a))
%#define array_is_native(a)     (PyArray_ISNOTSWAPPED((PyArrayObject*)a))
}

/**********************************************************************/

%fragment("NumPy_Utilities",
          "header")
{
  /* Given a PyObject, return a string describing its type.
   */
  const char* pytype_string(PyObject* py_obj)
  {
    if (py_obj == NULL          ) return "C NULL value";
    if (py_obj == Py_None       ) return "Python None" ;
    if (PyCallable_Check(py_obj)) return "callable"    ;
    if (PyString_Check(  py_obj)) return "string"      ;
    if (PyInt_Check(     py_obj)) return "int"         ;
    if (PyFloat_Check(   py_obj)) return "float"       ;
    if (PyDict_Check(    py_obj)) return "dict"        ;
    if (PyList_Check(    py_obj)) return "list"        ;
    if (PyTuple_Check(   py_obj)) return "tuple"       ;
%#if PY_MAJOR_VERSION < 3
    if (PyFile_Check(    py_obj)) return "file"        ;
    if (PyModule_Check(  py_obj)) return "module"      ;
    if (PyInstance_Check(py_obj)) return "instance"    ;
%#endif

    return "unknown type";
  }

  /* Given a NumPy typecode, return a string describing the type.
   */
  const char* typecode_string(int typecode)
  {
    static const char* type_names[25] = {"bool",
                                         "byte",
                                         "unsigned byte",
                                         "short",
                                         "unsigned short",
                                         "int",
                                         "unsigned int",
                                         "long",
                                         "unsigned long",
                                         "long long",
                                         "unsigned long long",
                                         "float",
                                         "double",
                                         "long double",
                                         "complex float",
                                         "complex double",
                                         "complex long double",
                                         "object",
                                         "string",
                                         "unicode",
                                         "void",
                                         "ntypes",
                                         "notype",
                                         "char",
                                         "unknown"};
    return typecode < 24 ? type_names[typecode] : type_names[24];
  }

  /* Make sure input has correct numpy type.  This now just calls
     PyArray_EquivTypenums().
   */
  int type_match(int actual_type,
                 int desired_type)
  {
    return PyArray_EquivTypenums(actual_type, desired_type);
  }

%#ifdef SWIGPY_USE_CAPSULE
  void free_cap(PyObject * cap)
  {
    void* array = (void*) PyCapsule_GetPointer(cap,SWIGPY_CAPSULE_NAME);
    if (array != NULL) free(array);
  }
%#endif


}

/**********************************************************************/

%fragment("NumPy_Object_to_Array",
          "header",
          fragment="NumPy_Backward_Compatibility",
          fragment="NumPy_Macros",
          fragment="NumPy_Utilities")
{
  /* Given a PyObject pointer, cast it to a PyArrayObject pointer if
   * legal.  If not, set the python error string appropriately and
   * return NULL.
   */
  PyArrayObject* obj_to_array_no_conversion(PyObject* input,
                                            int        typecode)
  {
    PyArrayObject* ary = NULL;
    if (is_array(input) && (typecode == NPY_NOTYPE ||
                            PyArray_EquivTypenums(array_type(input), typecode)))
    {
      ary = (PyArrayObject*) input;
    }
    else if is_array(input)
    {
      const char* desired_type = typecode_string(typecode);
      const char* actual_type  = typecode_string(array_type(input));
      PyErr_Format(PyExc_TypeError,
                   "Array of type '%s' required.  Array of type '%s' given",
                   desired_type, actual_type);
      ary = NULL;
    }
    else
    {
      const char* desired_type = typecode_string(typecode);
      const char* actual_type  = pytype_string(input);
      PyErr_Format(PyExc_TypeError,
                   "Array of type '%s' required.  A '%s' was given",
                   desired_type,
                   actual_type);
      ary = NULL;
    }
    return ary;
  }

  /* Convert the given PyObject to a NumPy array with the given
   * typecode.  On success, return a valid PyArrayObject* with the
   * correct type.  On failure, the python error string will be set and
   * the routine returns NULL.
   */
  PyArrayObject* obj_to_array_allow_conversion(PyObject* input,
                                               int       typecode,
                                               int*      is_new_object)
  {
    PyArrayObject* ary = NULL;
    PyObject*      py_obj;
    if (is_array(input) && (typecode == NPY_NOTYPE ||
                            PyArray_EquivTypenums(array_type(input),typecode)))
    {
      ary = (PyArrayObject*) input;
      *is_new_object = 0;
    }
    else
    {
      py_obj = PyArray_FROMANY(input, typecode, 0, 0, NPY_ARRAY_DEFAULT);
      /* If NULL, PyArray_FromObject will have set python error value.*/
      ary = (PyArrayObject*) py_obj;
      *is_new_object = 1;
    }
    return ary;
  }

  /* Given a PyArrayObject, check to see if it is contiguous.  If so,
   * return the input pointer and flag it as not a new object.  If it is
   * not contiguous, create a new PyArrayObject using the original data,
   * flag it as a new object and return the pointer.
   */
  PyArrayObject* make_contiguous(PyArrayObject* ary,
                                 int*           is_new_object,
                                 int            min_dims,
                                 int            max_dims)
  {
    PyArrayObject* result;
    if (array_is_contiguous(ary))
    {
      result = ary;
      *is_new_object = 0;
    }
    else
    {
      result = (PyArrayObject*) PyArray_ContiguousFromObject((PyObject*)ary,
                                                              array_type(ary),
                                                              min_dims,
                                                              max_dims);
      *is_new_object = 1;
    }
    return result;
  }

  /* Given a PyArrayObject, check to see if it is Fortran-contiguous.
   * If so, return the input pointer, but do not flag it as not a new
   * object.  If it is not Fortran-contiguous, create a new
   * PyArrayObject using the original data, flag it as a new object
   * and return the pointer.
   */
  PyArrayObject* make_fortran(PyArrayObject* ary,
                              int*           is_new_object)
  {
    PyArrayObject* result;
    if (array_is_fortran(ary))
    {
      result = ary;
      *is_new_object = 0;
    }
    else
    {
      Py_INCREF(array_descr(ary));
      result = (PyArrayObject*) PyArray_FromArray(ary,
                                                  array_descr(ary),
%#if NPY_API_VERSION < 0x00000007
                                                  NPY_FORTRANORDER);
%#else
                                                  NPY_ARRAY_F_CONTIGUOUS);
%#endif
      *is_new_object = 1;
    }
    return result;
  }

  /* Convert a given PyObject to a contiguous PyArrayObject of the
   * specified type.  If the input object is not a contiguous
   * PyArrayObject, a new one will be created and the new object flag
   * will be set.
   */
  PyArrayObject* obj_to_array_contiguous_allow_conversion(PyObject* input,
                                                          int       typecode,
                                                          int*      is_new_object)
  {
    int is_new1 = 0;
    int is_new2 = 0;
    PyArrayObject* ary2;
    PyArrayObject* ary1 = obj_to_array_allow_conversion(input,
                                                        typecode,
                                                        &is_new1);
    if (ary1)
    {
      ary2 = make_contiguous(ary1, &is_new2, 0, 0);
      if ( is_new1 && is_new2)
      {
        Py_DECREF(ary1);
      }