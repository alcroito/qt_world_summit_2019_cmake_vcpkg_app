mkdir -p builds_linux
rm -r builds_linux/*
cd builds_linux
QT_PATH=/home/alex/Dev/qt/qt514_built_static_debug/qtbase
~/Dev/cmakes/build/bin/cmake .. -GNinja -DCMAKE_TOOLCHAIN_FILE=/home/alex/Dev/projects/world_summit/vcpkg/scripts/buildsystems/vcpkg.cmake -DVCPKG_TARGET_TRIPLET=x64-linux -DCMAKE_PREFIX_PATH=$QT_PATH
ninja
