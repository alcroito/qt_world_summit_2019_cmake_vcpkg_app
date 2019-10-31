cmake_minimum_required(VERSION 3.15)
include(cmake/app_utils.cmake)

setup_vcpkg_before_project()
setup_ios_before_project()
project(encrypted_texteditor LANGUAGES CXX)

set_property(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}" APPEND PROPERTY CMAKE_CONFIGURE_DEPENDS
             "cmake/app_utils.cmake")

find_package(Qt5 5.14 REQUIRED COMPONENTS Quick Qml QmlImportScanner QuickControls2)
find_package(Qt5 5.14 COMPONENTS Widgets)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
find_package(Botan REQUIRED)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

add_qt_gui_executable(${PROJECT_NAME} texteditor.cpp documenthandler.cpp texteditor.qrc)

if(ANDROID OR IOS)
    target_compile_definitions(${PROJECT_NAME} PRIVATE QT_EXTRA_FILE_SELECTOR=\"touch\")
endif()

target_link_libraries(${PROJECT_NAME}
                      PRIVATE Qt5::Gui Qt5::Qml Qt5::Quick Qt5::QuickControls2 Botan::Botan)
if(TARGET Qt5::Widgets)
    target_link_libraries(${PROJECT_NAME} PRIVATE Qt5::Widgets)
endif()

if(IOS)
    target_link_options(${PROJECT_NAME} PRIVATE "-Wl,-e,_qt_main_wrapper")
endif()

# Import qml plugins for static builds.
qt5_import_qml_plugins(${PROJECT_NAME})
