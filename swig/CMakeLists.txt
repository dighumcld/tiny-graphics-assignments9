
find_package(SWIG REQUIRED)
include(${SWIG_USE_FILE})

find_package(PythonLibs)
include_directories(${PYTHON_INCLUDE_PATH})
include_directories(/Users/zihao/.virtualenvs/py3/lib/python3.6/site-packages/numpy/core/include)

set(CMAKE_SWIG_FLAGS "")

set_source_files_properties(DeepCapture.i PROPERTIES CPLUSPLUS ON)
set_source_files_properties(DeepCapture.i PROPERTIES SWIG_FLAGS "-includeall")