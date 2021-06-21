set(EXECUTABLE yolo-screen)

add_custom_target(run-${EXECUTABLE}
  COMMAND python main.py
  DEPENDS ${P