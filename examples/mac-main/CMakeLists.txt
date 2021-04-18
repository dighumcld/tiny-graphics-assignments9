
set(EXECUTABLE mac-main)

add_executable(${EXECUTABLE} mac-main.mm)
target_link_libraries(${EXECUTABLE} ${PROJECT_NAME})

install(TARGETS ${EXECUTABLE} RUNTIME DESTINATION bin)

add_custom_target(run-${EXECUTABLE}
  COMMAND ${EXECUTABLE}
  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/bin
)