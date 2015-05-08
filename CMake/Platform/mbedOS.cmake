# Copyright (C) 2014 ARM Limited. All rights reserved. 

# This is a platform definition file for mbedOS there isn't much here because
# most of our setup is related to the compiler used
#message("mbedOS.cmake included")

# No shared libraries
set_property(GLOBAL PROPERTY TARGET_SUPPORTS_SHARED_LIBS FALSE)

set(CMAKE_STATIC_LIBRARY_PREFIX "")
set(CMAKE_STATIC_LIBRARY_SUFFIX ".ar")
set(CMAKE_EXECUTABLE_SUFFIX "")

# adjust the default behaviour of the FIND_XXX() commands:
# search headers and libraries in the target environment, search 
# programs in the host environment
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

