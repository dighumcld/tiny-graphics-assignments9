
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