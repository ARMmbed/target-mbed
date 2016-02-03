# Copyright (C) 2016 ARM Limited. All rights reserved.

if(TARGET_MBED_COMMON_JINJA2_HEADER_TOOLCHAIN_INCLUDED)
    return()
endif()
set(TARGET_MBED_COMMON_JINJA2_HEADER_TOOLCHAIN_INCLUDED 1)

set(MBED_JINJA2_GENERATE_SCRIPT "${CMAKE_CURRENT_LIST_DIR}/../../scripts/jinja2_template.py")


function(generate_header_from_jinja2_template  input  output)

    # TODO: need to make sure output directory exists

    # message("Using ${MBED_JINJA2_GENERATE_SCRIPT} to generate from ${input} to ${output}")

    # add dependency of the output file on the (merged) yotta config info:
    set_source_files_properties("${output}" PROPERTIES HEADER_FILE_ONLY TRUE
                                OBJECT_DEPENDS "${YOTTA_CONFIG_MERGED_JSON_FILE}")

    # add dependency of the output file on the script used to generate it:
    set_source_files_properties("${output}" PROPERTIES HEADER_FILE_ONLY TRUE
                                OBJECT_DEPENDS "${MBED_JINJA2_GENERATE_SCRIPT}")

    # add dependency of the output file on the input file:
    set_source_files_properties("${output}" PROPERTIES HEADER_FILE_ONLY TRUE
                                OBJECT_DEPENDS "${input}")

    add_custom_command(
        OUTPUT "${output}"
        MAIN_DEPENDENCY "${YOTTA_CONFIG_MERGED_JSON_FILE}"
        DEPENDS "${YOTTA_CONFIG_MERGED_JSON_FILE}" "${input}" "${MBED_JINJA2_GENERATE_SCRIPT}"
        COMMAND python "${MBED_JINJA2_GENERATE_SCRIPT}" "${YOTTA_CONFIG_MERGED_JSON_FILE}" "${input}" "${output}"
        COMMENT "Generating ${output}"
    )

    # first determine a sane name for the generated target:
    get_filename_component(headerFilename "${output}" NAME)
    set(generatedName "${PROJECT_NAME}_template_${headerFilename}")

    add_custom_target("${generatedName}" ALL DEPENDS "${input}" "${output}" "${YOTTA_CONFIG_MERGED_JSON_FILE}")

    add_dependencies("${PROJECT_NAME}" "${generatedName}")

endfunction()
