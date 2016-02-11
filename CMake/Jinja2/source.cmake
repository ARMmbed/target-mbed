# Copyright (C) 2016 ARM Limited. All rights reserved.

if(TARGET_MBED_COMMON_JINJA2_SOURCE_TOOLCHAIN_INCLUDED)
    return()
endif()
set(TARGET_MBED_COMMON_JINJA2_SOURCE_TOOLCHAIN_INCLUDED 1)

set(MBED_JINJA2_GENERATE_SCRIPT "${CMAKE_CURRENT_LIST_DIR}/../../scripts/jinja2_template.py")


function(generate_source_from_jinja2_template  input  output)

    # TODO: output isn't a required argument with this approach, we could pick somewhere in the build directory automatically
    # TODO: need to make sure output directory exists

    # add dependency of the output file on:
    # - the (merged) yotta config info,
    # - the script used to generate it, and
    # - the input file.
    set_source_files_properties(
        "${output}"
        PROPERTIES
            GENERATED TRUE
        OBJECT_DEPENDS
            "${YOTTA_CONFIG_MERGED_JSON_FILE}" ;
            "${MBED_JINJA2_GENERATE_SCRIPT}" ;
            "${input}"
    )

    add_custom_command(
        OUTPUT "${output}"
        MAIN_DEPENDENCY "${YOTTA_CONFIG_MERGED_JSON_FILE}"
        DEPENDS "${YOTTA_CONFIG_MERGED_JSON_FILE}" "${input}" "${MBED_JINJA2_GENERATE_SCRIPT}"
        COMMAND python "${MBED_JINJA2_GENERATE_SCRIPT}" "${YOTTA_CONFIG_MERGED_JSON_FILE}" "${input}" "${output}"
        COMMENT "Generating ${output}"
    )

    # to get the generated input file included in the build, we
    # need to build it into a separate library, and indicate that
    # the current module's library has a link-dependency on it
    # (otherwise it would not be linked in the final application):

    # first determine a sane name for the generated library:
    get_filename_component(sourceFilename "${output}" NAME)
    set(generatedLibName "${PROJECT_NAME}_template_${sourceFilename}")

    # generate it:
    add_library("${generatedLibName}" "${output}")

    # link the generated library to the existing library for this module:
    target_link_libraries("${PROJECT_NAME}" "${generatedLibName}")

endfunction()
