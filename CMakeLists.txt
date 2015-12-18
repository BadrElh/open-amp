cmake_minimum_required (VERSION 2.6)


# The version number
set (OPENAMP_VERSION_MAJOR 1)
set (OPENAMP_VERSION_MINOR 0)

list (APPEND CMAKE_MODULE_PATH
      "${CMAKE_SOURCE_DIR}/cmake"
      "${CMAKE_SOURCE_DIR}/cmake/modules"
      "${CMAKE_SOURCE_DIR}/cmake/platforms")

project (OpenAMP)
enable_language(C ASM)

include (CheckIncludeFiles)
include (CheckCSourceCompiles)
include (collect)
include (options)
enable_testing ()

set (OPENAMP_ROOT_DIR "${CMAKE_CURRENT_SOURCE_DIR}")

if (NOT DEFINED CMAKE_LIBRARY_OUTPUT_DIRECTORY)
  set (CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/libs)
endif (NOT DEFINED CMAKE_LIBRARY_OUTPUT_DIRECTORY)

if (NOT DEFINED CMAKE_ARCHIVE_OUTPUT_DIRECTORY)
  set (CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/libs)
endif (NOT DEFINED CMAKE_ARCHIVE_OUTPUT_DIRECTORY)

set_property (GLOBAL PROPERTY "PROJECT_LIB_EXTRA_CFLAGS")

collector_create (PROJECT_LIB_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}")
collect (PROJECT_LIB_DIRS "${CMAKE_CURRENT_BINARY_DIR}")
collect (PROJECT_INC_DIRS "${CMAKE_CURRENT_SOURCE_DIR}/include")
collect (PROJECT_INC_DIRS "${CMAKE_CURRENT_SOURCE_DIR}/include/porting/system/${PROJECT_SYSTEM}/machine/${PROJECT_MACHINE}")

if (WITH_OBSOLETE)
  add_subdirectory (obsolete)
endif (WITH_OBSOLETE)

add_subdirectory (common)
if (WITH_VIRTIO)
  add_subdirectory (virtio)
endif (WITH_VIRTIO)
if (WITH_RPMSG)
  add_subdirectory (rpmsg)
endif (WITH_RPMSG)
if (WITH_REMOTEPROC)
  add_subdirectory (remoteproc)
endif (WITH_REMOTEPROC)
if (WITH_PROXY)
  add_subdirectory (proxy)
endif (WITH_PROXY)
add_subdirectory (porting)

set (OPENAMP_LIB open_amp)

collector_list (_list PROJECT_INC_DIRS)
include_directories (${_list})

get_property (_ecflags GLOBAL PROPERTY "PROJECT_LIB_EXTRA_CFLAGS")

collector_list (_list PROJECT_LIB_SOURCES)
set_property (SOURCE ${_list}
  APPEND_STRING PROPERTY COMPILE_FLAGS " ${_ecflags}")
add_library (${OPENAMP_LIB} STATIC ${_list})

if (WITH_APPS)
  add_subdirectory (apps)
endif (WITH_APPS)

# vim: expandtab:ts=2:sw=2:smartindent
