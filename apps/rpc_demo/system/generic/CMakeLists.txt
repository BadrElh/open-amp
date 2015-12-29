if (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_ROLE}/CMakeLists.txt")
  add_subdirectory (${PROJECT_ROLE})
endif (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_ROLE}/CMakeLists.txt")
