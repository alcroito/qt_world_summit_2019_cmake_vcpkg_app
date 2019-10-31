mkdir -p builds_ios_device
rm -r builds_ios_device/*
cd builds_ios_device
QT_PATH=/Volumes/T3/Dev/qt/qt514_built_static_debug_and_release_ios_fat/qtbase
~/Dev/cmake/build/bin/cmake .. -GXcode -DCMAKE_TOOLCHAIN_FILE=/Volumes/T3/Dev/projects/world_summit/vcpkg_world_summit/scripts/buildsystems/vcpkg.cmake -DCMAKE_SYSTEM_NAME=iOS -DVCPKG_TARGET_TRIPLET=arm64-ios -DCMAKE_PREFIX_PATH=$QT_PATH -DCMAKE_FIND_ROOT_PATH=$QT_PATH -DCMAKE_OSX_SYSROOT=iphoneos -DCMAKE_OSX_ARCHITECTURES=arm64 -DCMAKE_XCODE_ATTRIBUTE_DEVELOPMENT_TEAM=$ENV_CMAKE_XCODE_ATTRIBUTE_DEVELOPMENT_TEAM
xcodebuild
