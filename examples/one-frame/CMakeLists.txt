
set(EXECUTABLE one-frame)

add_custom_target(run-${EXECUTABLE}
  COMMAND python main.py
  DEPENDS ${PROJECT_NAME}
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
)