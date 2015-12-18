
if ("${PROJECT_ROLE}" STREQUAL "master")
  set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -D\"BAREMETAL_MASTER=1\"")
else ("${PROJECT_ROLE}" STREQUAL "master")
  set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -D\"BAREMETAL_MASTER=0\"")
endif ("${PROJECT_ROLE}" STREQUAL "master")

collector_list (_list PROJECT_INC_DIRS)
include_directories (${_list} ${CMAKE_CURRENT_SOURCE_DIR})
add_library (baremetal-${PROJECT_ROLE} STATIC baremetal.c)
