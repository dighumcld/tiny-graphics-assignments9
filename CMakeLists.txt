cmake_minimum_required(VERSION 3.8)

project(DeepCapture)

find_library(AUDIOUNIT AudioUnit)
find_library(COCOA Cocoa)
find_library(COREAUDIO CoreAudio)
find_library(COREFOUNDATION CoreFoundation)
find_library(IOSURF IOSurface)

include_directories(
  ${AUDIOUNIT}
  ${COCOA}
  ${COREAUDIO}
  ${COREFOUNDATION}
  ${IOSURF}
)

include_directories(include)

file(GLOB HEADERS
  includes/*.h
)

file(GLOB SOURCES
  src/*.cpp
  src/*.mm
)

add_library(${PROJECT_NAME} SHARED
  ${SOURCES}
  ${HEADERS})

target_link_libraries(${PROJECT_NAME}
  ${AUDIOUNIT}
  ${COCOA}
  ${COREAUDIO}
  ${COREFOUNDATION}
  ${IOSURF})

add_library(${PROJECT_NAME}Static STATIC
  ${SOURCES}
  ${HEADERS})

target_link_libraries(${PROJECT_NAME}Static
  ${AUDIOUNIT}
  ${COCOA}
  ${COREAUDIO}
  ${COREFOUNDATION}
  ${IOSURF})

install(TARGETS ${PROJECT_NAME}
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib)

install(TARGETS ${PROJECT_NAME}Static
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib)

add_subdirectory(swig)
add_subdirectory(examples)
