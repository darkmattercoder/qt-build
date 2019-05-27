#!/bin/bash
# Call this script like so:
#./build-dockerfile-local.sh 5 6 0 everywhere-opensource 2 8
QT_VERSION_MAJOR=$1
QT_VERSION_MINOR=$2
QT_VERSION_PATCH=$3
QT_TARBALL_NAMING_SCHEME=$4
CI_BUILD=$5
CORE_COUNT=$6
PROXY=$7
# builder
docker build --pull --build-arg QT_VERSION_MAJOR=$QT_VERSION_MAJOR --build-arg QT_VERSION_MINOR=$QT_VERSION_MINOR --build-arg QT_VERSION_PATCH=$QT_VERSION_PATCH --build-arg QT_TARBALL_NAMING_SCHEME=$QT_TARBALL_NAMING_SCHEME --build-arg CI_BUILD=$CI_BUILD --build-arg CORE_COUNT=$CORE_COUNT --build-arg PROXY=$PROXY --target=builder -t darkmattercoder/qt-build:builder-$QT_VERSION_MAJOR.$QT_VERSION_MINOR.$QT_VERSION_PATCH .
# qt
docker build --pull --cache-from darkmattercoder/qt-build:builder-$QT_VERSION_MAJOR.$QT_VERSION_MINOR.$QT_VERSION_PATCH --build-arg QT_VERSION_MAJOR=$QT_VERSION_MAJOR --build-arg QT_VERSION_MINOR=$QT_VERSION_MINOR --build-arg QT_VERSION_PATCH=$QT_VERSION_PATCH --build-arg QT_TARBALL_NAMING_SCHEME=$QT_TARBALL_NAMING_SCHEME --build-arg CI_BUILD=$CI_BUILD --build-arg CORE_COUNT=$CORE_COUNT --target=qt -t darkmattercoder/qt-build:$QT_VERSION_MAJOR.$QT_VERSION_MINOR.$QT_VERSION_PATCH .