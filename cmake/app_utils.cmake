function(add_qt_gui_executable target)
    if(ANDROID)
        add_library("${target}" MODULE ${ARGN})
        # Not having this flag set will cause the
        # executable to have main() hidden and it can thus no longer be loaded
        # through dlopen().
        set_property(TARGET "${target}" PROPERTY C_VISIBILITY_PRESET default)
        set_property(TARGET "${target}" PROPERTY CXX_VISIBILITY_PRESET default)
    else()
        add_executable("${target}" WIN32 MACOSX_BUNDLE ${ARGN})
    endif()
    if(APPLE)
        set(MACOSX_BUNDLE_BUNDLE_NAME "CryptEd" PARENT_SCOPE)
        set(MACOSX_BUNDLE_GUI_IDENTIFIER "io.qt.alcroito.crypted" PARENT_SCOPE)
        set(MACOSX_BUNDLE_INFO_STRING "CryptEd" PARENT_SCOPE)
        set(MACOSX_BUNDLE_LONG_VERSION_STRING "0.1.0" PARENT_SCOPE)
        set(MACOSX_BUNDLE_SHORT_VERSION_STRING "0.1" PARENT_SCOPE)
        set(MACOSX_BUNDLE_BUNDLE_VERSION "0.1" PARENT_SCOPE)
        if(IOS)
            set_target_properties(${target} PROPERTIES MACOSX_BUNDLE_INFO_PLIST
                                  "${CMAKE_CURRENT_SOURCE_DIR}/Info_ios.plist.in")
        else()
            set_target_properties(${target} PROPERTIES MACOSX_BUNDLE_INFO_PLIST
                                  "${CMAKE_CURRENT_SOURCE_DIR}/Info.plist")
        endif()
    endif()
endfunction()

function(setup_vcpkg_before_project)
    if(DEFINED ENV{VCPKG_ROOT})
        set(vcpkg_toolchain_path "$ENV{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake")
        get_filename_component(vcpkg_toolchain_path "${vcpkg_toolchain_path}" ABSOLUTE)
    endif()

    if(DEFINED CMAKE_TOOLCHAIN_FILE AND vcpkg_toolchain_path)
        get_filename_component(supplied_toolchain_file "${CMAKE_TOOLCHAIN_FILE}" ABSOLUTE)
        if(NOT supplied_toolchain_file STREQUAL vcpkg_toolchain_path)
            set(VCPKG_CHAINLOAD_TOOLCHAIN_FILE "${CMAKE_TOOLCHAIN_FILE}" CACHE STRING "")
        endif()
    endif()

    if(vcpkg_toolchain_path AND EXISTS "${vcpkg_toolchain_path}")
        set(CMAKE_TOOLCHAIN_FILE "${vcpkg_toolchain_path}" CACHE STRING "" FORCE)
        message(STATUS "Using vcpkg from $ENV{VCPKG_ROOT}")
    endif()

    if(DEFINED ENV{VCPKG_DEFAULT_TRIPLET} AND NOT VCPKG_TARGET_TRIPLET)
        set(VCPKG_TARGET_TRIPLET "$ENV{VCPKG_DEFAULT_TRIPLET}" CACHE STRING "")
    endif()
    message(STATUS "Using vcpkg triplet ${VCPKG_TARGET_TRIPLET}")
endfunction()

macro(setup_ios_before_project)
    if(CMAKE_SYSTEM_NAME STREQUAL "iOS")
        set(CMAKE_OSX_DEPLOYMENT_TARGET "12.2" CACHE STRING "")
        set(CMAKE_XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "iPhone Developer")

        # Add the team identifier here, otherwise code-signing for the device won't work.
        # Can also be set via CMake cache variable.
        #set(CMAKE_XCODE_ATTRIBUTE_DEVELOPMENT_TEAM "")

        # Currently Botan is not built with bitcode support.
        set(CMAKE_XCODE_ATTRIBUTE_ENABLE_BITCODE "NO")

        # Skips lengthy dsym extraction step.
        set(CMAKE_XCODE_ATTRIBUTE_DEBUG_INFORMATION_FORMAT "DWARF")
    endif()
endmacro()
