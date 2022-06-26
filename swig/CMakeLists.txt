
find_package(SWIG REQUIRED)
include(${SWIG_USE_FILE})

find_package(PythonLibs)
include_directories(${PYTHON_INCLUDE_PATH})
include_directories(/Users/zihao/.virtualenvs/py3/lib/python3.6/site-packages/numpy/core/include)

set(CMAKE_SWIG_FLAGS "")

set_source_files_properties(DeepCapture.i PROPERTIES CPLUSPLUS ON)
set_source_files_properties(DeepCapture.i PROPERTIES SWIG_FLAGS "-includeall")

set(PYTHON_NAME deep_capture)

swig_add_library(${PYTHON_NAME} LANGUAGE python SOURCES DeepCapture.i)
swig_link_libraries(${PYTHON_NAME} ${PYTHON_LIBRARIES} ${PROJECT_NAME})

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/_${PYTHON_NAME}.so DESTINATION lib/python)
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${PYTHON_NAME}.py DESTINATION lib/python)
install(FILES setup.py DESTINATION lib/python)