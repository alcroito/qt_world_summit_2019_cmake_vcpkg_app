mkdir -p builds_android_emulator
rm -r builds_android_emulator/*
cd builds_android_emulator
QT_PATH=/Volumes/T3/Dev/qt/qt514_built_android_developer/qtbase
ANDROID_NDK_HOME=/Volumes/T3/Dev/android/sdk/ndk/20.0.5594570
ANDROID_SDK_HOME=/Volumes/T3/Dev/android/sdk
~/Dev/cmake/build/bin/cmake .. -G"Unix Makefiles" -DCMAKE_TOOLCHAIN_FILE=/Volumes/T3/Dev/projects/world_summit/vcpkg_world_summit/scripts/buildsystems/vcpkg.cmake -DVCPKG_TARGET_TRIPLET=x86-android -DCMAKE_PREFIX_PATH=$QT_PATH -DCMAKE_FIND_ROOT_PATH=$QT_PATH -DANDROID_NATIVE_API_LEVEL=28 -DVCPKG_CHAINLOAD_TOOLCHAIN_FILE=/Volumes/T3/Dev/android/sdk/ndk/20.0.5594570/build/cmake/android.toolchain.cmake -DANDROID_ABI=x86 -DANDROID_SDK=$ANDROID_SDK_HOME -DANDROID_NDK=$ANDROID_NDK_HOME
make -j16
make -j16 VERBOSE=1 apk
