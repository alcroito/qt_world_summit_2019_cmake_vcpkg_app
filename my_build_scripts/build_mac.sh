mkdir -p builds_mac
rm -r builds_mac/*
cd builds_mac
QT_PATH=/Volumes/T3/Dev/qt/qt514_built_static_debug/qtbase
~/Dev/cmake/build/bin/cmake .. -GNinja -DCMAKE_TOOLCHAIN_FILE=/Volumes/T3/Dev/projects/world_summit/vcpkg_world_summit/scripts/buildsystems/vcpkg.cmake -DVCPKG_TARGET_TRIPLET=x64-osx -DCMAKE_PREFIX_PATH=$QT_PATH
ninja
