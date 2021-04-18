
set(EXECUTABLE mac-main)

add_executable(${EXECUTABLE} mac-main.mm)
target_link_libraries(${EXECUTABLE} ${PROJECT_NAME})

install(TARGETS ${EXECUTABLE} RUNTIME DESTINATION bin)