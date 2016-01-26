# Copyright (C) 2014-2016 ARM Limited. All rights reserved. 

# This is a platform definition file for mbedOS there isn't much here because
# most of our setup is related to the compiler used
#message("mbedOS.cmake included")

# No shared libraries
set_property(GLOBAL PROPERTY TARGET_SUPPORTS_SHARED_LIBS FALSE)

set(CMAKE_EXECUTABLE_SUFFIX "")
set(CMAKE_STATIC_LIBRARY_PREFIX "")

if(YOTTA_CFG_MBED_TOOLCHAIN STREQUAL "armcc")
    set(CMAKE_STATIC_LIBRARY_SUFFIX ".ar")
elseif(YOTTA_CFG_MBED_TOOLCHAIN STREQUAL "gcc")
    set(CMAKE_STATIC_LIBRARY_SUFFIX ".a")
    set(CMAKE_C_OUTPUT_EXTENSION ".o")
    set(CMAKE_ASM_OUTPUT_EXTENSION ".o")
    set(CMAKE_CXX_OUTPUT_EXTENSION ".o")
else()
    message(FATAL_ERROR "yotta config value mbed.toolchain must be set to either 'armcc' or 'gcc'")
endif()

include_directories("${CMAKE_BINARY_DIR}/generated/include")
file(MAKE_DIRECTORY "${CMAKE_BINARY_DIR}/generated/include")

# adjust the default behaviour of the FIND_XXX() commands:
# search headers and libraries in the target environment, search 
# programs in the host environment
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

