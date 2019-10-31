find_path(BOTAN_INCLUDE_DIRS NAMES botan/botan.h
          DOC "The botan include directory")

find_library(BOTAN_LIBRARIES NAMES botan botan-2
             DOC "The botan library")

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Botan REQUIRED_VARS BOTAN_LIBRARIES BOTAN_INCLUDE_DIRS)

if(Botan_FOUND)
    add_library(Botan::Botan UNKNOWN IMPORTED)

    set_target_properties(Botan::Botan PROPERTIES
                          IMPORTED_LOCATION "${BOTAN_LIBRARIES}"
                          INTERFACE_INCLUDE_DIRECTORIES "${BOTAN_INCLUDE_DIRS}")
endif()

mark_as_advanced(BOTAN_LIBRARIES BOTAN_INCLUDE_DIRS)
