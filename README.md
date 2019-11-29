# CryptEd - Qt Quick Controls 2 editor app + CMake + vcpkg + static build

![Logo](/logo/logo.png?raw=true "Logo")

This repository contains a modified Qt example (texteditor) that:

* uses both QML and C++
* is built using [CMake](https://cmake.org/) instead of qmake
* is statically built (when using a static Qt)
* uses a third party crypto library ([Botan](https://botan.randombit.net/handbook/api_ref/contents.html)) to encrypt the documents it writes ([ChaCha20](https://botan.randombit.net/handbook/api_ref/stream_ciphers.html#chacha) stream cipher)
* uses [vcpkg](https://github.com/microsoft/vcpkg) to build / install Botan
* runs on the usual desktop configurations (Windows, macOS, Linux) and mobile (iOS, Android)

# Build requirements

* [CMake 3.15](https://cmake.org/download/) or higher
* [Qt 5.14](http://download.qt.io/development_releases/qt/5.14/) or higher
* [ninja](https://github.com/ninja-build/ninja/releases) / make / nmake / [jom](http://download.qt.io/official_releases/jom/jom.zip)

* Android [NDK r20](https://developer.android.com/ndk/downloads) and [SDK v28](https://developer.android.com/studio/index.html#command-tools) or SDK + NDK that comes with [Android Studio](https://developer.android.com/studio) for the Android build
* [Xcode 10.2](https://developer.apple.com/xcode/) or higher for macOS and iOS builds
* [MSVC 2017](https://visualstudio.microsoft.com/downloads/) for Windows builds
* GCC or Clang for Linux builds
* Android NDK Clang for Android builds

* [vcpkg](https://github.com/microsoft/vcpkg)
* A toolchain supporting C++17 for bootstrapping vcpkg (looking at you Apple Clang and your missing std::filesystem support)

For deploying and running on Android you can use either Qt Creator 4.11 or Android Studio.

For deploying and running on iOS use Xcode.

# Tested configurations

* Windows 10 (1809)
* macOS 10.14 + Xcode 10.2.1
* Ubuntu 18.04 Bionic + GCC 7.4.0
* iOS Simulator iPhone X and iPhone 6S on device (targetting 12.2)
* Android x86 Emulator which comes with the Android SDK
* Android arm64-v8a device

# Vcpkg

## Building vcpkg

Follow the instructions at https://github.com/microsoft/vcpkg on how to build vcpkg.

## Vcpkg for iOS and Android

If you want to build the app on iOS / Android, you have to use my [vcpkg fork](https://github.com/alcroito/vcpkg/tree/world_summit_botan)

This is because vcpkg doesn't officially support the mobile platforms yet, and my fork contains adjustments for building Botan on iOS and Android.

Note that the fork currently has some hard-coded assumptions  due to lack of time for generalizing the build rules.

Specifically for iOS the library can be built either for Simulator x86_64 or for device arm64 (armv8).

For Android, the NDK is found via the ANDROID_NDK_HOME environment variable, and the toolchain is hardcoded to use darwin-x86_64 and i686-linux-android29-clang++ for emulator and arm64-v8a toolchain for an arm64 device.

The relevant changes are in ports/botan/portfile.cmake.

## Vcpkg triplets

You will want to set any of the following triplets as the value for the VCPKG_DEFAULT_TRIPLET environment variable, both when building Botan and when building the actual app.

* Windows - x64-windows
* Linux - x64-linux
* macOS - x64-osx
* iOS x86_64 Simulator - x64-ios
* iOS arm64 Device - arm64-ios
* Android x86 Emulator - x86-android
* Android arm64-v8a Device - arm64-android

## Building Botan on Windows host

```
    # Bootstrap vcpkg
    cd <vcpkg dir>
    set VCPKG_DEFAULT_TRIPLET=<triplet>
    vcpkg.exe install botan
```

## Building Botan on Linux / macOS host

```
    # Bootstrap vcpkg
    cd <vcpkg dir>
    export VCPKG_DEFAULT_TRIPLET=<triplet>
    ./vcpkg install botan
```

# Building and running

The instructions for building on desktop platforms are mostly the same, except for the shell syntax and the chosen vcpkg triplet and CMake generator.

For the mobile platforms it's a bit more involved.

You can also get some inspiration from my own build scripts at in repo/my_build_scripts.

## Desktop (Windows)

```
    # Open Visual Studio shell or use vcvarsall.bat targeting x64.
    cd <repo_root_source_dir>
    mkdir build
    cd build
    set VCPKG_ROOT=<path-to-vcpkg-root>
    set VCPKG_DEFAULT_TRIPLET=<triplet>
    set QT_PATH=<PATH_TO_INSTALLED_QT>
    cmake .. -GNinja -DVCPKG_TARGET_TRIPLET=<triplet> -DCMAKE_PREFIX_PATH=%QT_PATH%
    cmake --build .
```

## Desktop (macOS / Linux)

```
    cd <repo_root_source_dir>
    mkdir build && cd build
    export VCPKG_ROOT=<path-to-vcpkg-root>
    export VCPKG_DEFAULT_TRIPLET=<triplet>
    cmake .. -GNinja -DVCPKG_TARGET_TRIPLET=<triplet> -DCMAKE_PREFIX_PATH=<PATH_TO_INSTALLED_QT>
    cmake --build .
```

## iOS Device arm64

```
    cd <repo_root_source_dir>
    mkdir build && cd build
    export VCPKG_ROOT=<path-to-vcpkg-root>
    export VCPKG_DEFAULT_TRIPLET=arm64-ios
    export QT_PATH=<PATH_TO_INSTALLED_QT>
    cmake .. -GXcode -DCMAKE_SYSTEM_NAME=iOS -DCMAKE_PREFIX_PATH=$QT_PATH -DCMAKE_FIND_ROOT_PATH=$QT_PATH -DCMAKE_OSX_SYSROOT=iphoneos -DCMAKE_OSX_ARCHITECTURES=arm64 -DCMAKE_XCODE_ATTRIBUTE_DEVELOPMENT_TEAM=<your-apple-development-team-id>
    xcodebuild
```

Then use Xcode to open and run / deploy the app.

## iOS Simulator x86_64

```
    cd <repo_root_source_dir>
    mkdir build && cd build
    export VCPKG_ROOT=<path-to-vcpkg-root>
    export VCPKG_DEFAULT_TRIPLET=x64-ios
    export QT_PATH=<PATH_TO_INSTALLED_QT>
    cmake .. -GXcode -DCMAKE_SYSTEM_NAME=iOS -DCMAKE_PREFIX_PATH=$QT_PATH -DCMAKE_FIND_ROOT_PATH=$QT_PATH -DCMAKE_OSX_SYSROOT=iphonesimulator -DCMAKE_OSX_ARCHITECTURES=x86_64
    xcodebuild
```
Then use Xcode to open and run / deploy the app.

## Android Emulator x86 (on macOS)

```
    cd <repo_root_source_dir>
    mkdir build && cd build
    export VCPKG_ROOT=<PATH_TO_VCPKG_ROOT>
    export VCPKG_DEFAULT_TRIPLET=x86-android
    export QT_PATH=<PATH_TO_INSTALLED_QT>
    export ANDROID_NDK_HOME=<path-to-android-ndk>
    export ANDROID_SDK_HOME=<path-to-android-sdk>
    cmake .. -GNinja -DCMAKE_PREFIX_PATH=$QT_PATH -DCMAKE_FIND_ROOT_PATH=$QT_PATH -DANDROID_NATIVE_API_LEVEL=28 -DVCPKG_CHAINLOAD_TOOLCHAIN_FILE=$ANDROID_NDK_HOME/build/cmake/android.toolchain.cmake -DANDROID_ABI=x86 -DANDROID_SDK=$ANDROID_SDK_HOME -DANDROID_NDK=$ANDROID_NDK_HOME
    ninja
    ninja -v apk
```

Then use either Qt Creator or Android studio to run / deploy the app.

## Android Device arm64 (on macOS)

```
    cd <repo_root_source_dir>
    mkdir build && cd build
    export VCPKG_ROOT=<PATH_TO_VCPKG_ROOT>
    export VCPKG_DEFAULT_TRIPLET=arm64-android
    export QT_PATH=<PATH_TO_INSTALLED_QT>
    export ANDROID_NDK_HOME=<path-to-android-ndk>
    export ANDROID_SDK_HOME=<path-to-android-sdk>
    cmake .. -GNinja -DCMAKE_PREFIX_PATH=$QT_PATH -DCMAKE_FIND_ROOT_PATH=$QT_PATH -DANDROID_NATIVE_API_LEVEL=28 -DVCPKG_CHAINLOAD_TOOLCHAIN_FILE=$ANDROID_NDK_HOME/build/cmake/android.toolchain.cmake -DANDROID_ABI=arm64-v8a -DANDROID_SDK=$ANDROID_SDK_HOME -DANDROID_NDK=$ANDROID_NDK_HOME
    ninja
    ninja -v apk
```

Then use either Qt Creator or Android studio to run / deploy the app.
