rmdir /S /Q builds_win
mkdir builds_win
cd builds_win
set QT_PATH=E:\Dev\qt\qt514_built_static_debug\qtbase
set VCPKG_ROOT=E:\Dev\projects\world_summit\vcpkg
C:\Dev\cmake315\bin\cmake.exe .. -GNinja -DVCPKG_TARGET_TRIPLET=x64-windows -DCMAKE_PREFIX_PATH=%QT_PATH%
ninja
cd ..
