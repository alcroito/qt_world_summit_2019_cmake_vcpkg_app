mkdir -p builds_ios_simulator
rm -r builds_ios_simulator/*
cd builds_ios_simulator
QT_PATH=/Volumes/T3/Dev/qt/qt514_built_static_debug_and_release_ios_fat/qtbase
~/Dev/cmake/build/bin/cmake .. -GXcode -DCMAKE_TOOLCHAIN_FILE=/Volumes/T3/Dev/projects/world_summit/vcpkg_world_summit/scripts/buildsystems/vcpkg.cmake -DCMAKE_SYSTEM_NAME=iOS -DVCPKG_TARGET_TRIPLET=x64-ios -DCMAKE_PREFIX_PATH=$QT_PATH -DCMAKE_FIND_ROOT_PATH=$QT_PATH -DCMAKE_OSX_SYSROOT=iphonesimulator -DCMAKE_OSX_ARCHITECTURES=x86_64
xcodebuild
