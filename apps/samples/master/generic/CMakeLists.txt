option (WITH_LINUX_FIRMWARE "Generate Linux firmware" on)

add_subdirectory (common)
if (WITH_LINUX_FIRMWARE)
add_subdirectory (linux-firmware)
endif (WITH_LINUX_FIRMWARE)
add_subdirectory (echo_test)
add_subdirectory (matrix_multiply)
