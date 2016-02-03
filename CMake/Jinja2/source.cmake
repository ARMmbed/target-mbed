# Copyright (C) 2016 ARM Limited. All rights reserved.

if(TARGET_MBED_COMMON_JINJA2_TOOLCHAIN_INCLUDED)
    return()
endif()
set(TARGET_MBED_COMMON_JINJA2_TOOLCHAIN_INCLUDED 1)

set(MBED_JINJA2_GENERATE_SCRIPT "${CMAKE_CURRENT_LIST_DIR}/../../scripts/jinja2_template.py")


function(generate_source_from_jinja2_template  source  destination)

    # TODO: destination isn't a required argument with this approach, we could pick somewhere in the build directory automatically
    # TODO: need to make sure output directory exists

    message("using ${MBED_JINJA2_GENERATE_SCRIPT} to generate stuff from ${source} to ${destination}")

    # add dependency of the output file on the (merged) yotta config info:
    set_source_files_properties(
        "${destination}" PROPERTIES
        OBJECT_DEPENDS "${YOTTA_CONFIG_MERGED_JSON_FILE}"
    )

    # add dependency of the output file on the script used to generate it:
    set_source_files_properties("${destination}" PROPERTIES
                                OBJECT_DEPENDS "${MBED_JINJA2_GENERATE_SCRIPT}")

    add_custom_command(
        OUTPUT "${destination}"
        MAIN_DEPENDENCY "${YOTTA_CONFIG_MERGED_JSON_FILE}"
        DEPENDS "${YOTTA_CONFIG_MERGED_JSON_FILE}"
        COMMAND python "${MBED_JINJA2_GENERATE_SCRIPT}" "${YOTTA_CONFIG_MERGED_JSON_FILE}" "${source}" "${destination}" "${filters}"
        COMMENT "Generating ${destination}"
    )

    # to get the generated source file included in the build, we
    # need to build it into a separate library, and indicate that
    # the current module's library has a link-dependency on it
    # (otherwise it would not be linked in the final application):

    # first determine a sane name for the generated library:
    get_filename_component(sourceFilename "${destination}" NAME)
    set(generatedLibName "${PROJECT_NAME}_template_${sourceFilename}")

    # generate it:
    add_library("${generatedLibName}" "${destination}")

    # link the generated library to the existing library for this module:
    target_link_libraries("${PROJECT_NAME}" "${generatedLibName}")

endfunction()


# usage example (note that for yotta, the "source" dir is actually the build dir (this is where the CMakeLists are generated).
# Use the list dir in a .cmake file in mymodule/source to refer to the mymodule/source directory
# generate_source_from_jinja2_template("${CMAKE_CURRENT_LIST_DIR}/foo.c.jinja2" "${CMAKE_CURRENT_SOURCE_DIR}/foo.c")
