#!/bin/bash
# Call this script like so:
#./build-dockerfile-local.sh 5 6 0 official_releases everywhere-opensource 2 8
set -e
QT_VERSION_MAJOR=$1
QT_VERSION_MINOR=$2
QT_VERSION_PATCH=$3
QT_DOWNLOAD_BRANCH=$4
QT_TARBALL_NAMING_SCHEME=$5
CI_BUILD=$6
CORE_COUNT=$7
PROXY=$8
# base
docker build --pull --cache-from darkmattercoder/qt-build:base-$QT_VERSION_MAJOR.$QT_VERSION_MINOR.$QT_VERSION_PATCH --build-arg QT_VERSION_MAJOR=$QT_VERSION_MAJOR --build-arg QT_VERSION_MINOR=$QT_VERSION_MINOR --build-arg QT_VERSION_PATCH=$QT_VERSION_PATCH --build-arg QT_DOWNLOAD_BRANCH=$QT_DOWNLOAD_BRANCH --build-arg QT_TARBALL_NAMING_SCHEME=$QT_TARBALL_NAMING_SCHEME --build-arg CI_BUILD=$CI_BUILD --build-arg CORE_COUNT=$CORE_COUNT --build-arg PROXY=$PROXY --target=base -t darkmattercoder/qt-build:base-$QT_VERSION_MAJOR.$QT_VERSION_MINOR.$QT_VERSION_PATCH .
# builder
docker build --pull --cache-from darkmattercoder/qt-build:builder-$QT_VERSION_MAJOR.$QT_VERSION_MINOR.$QT_VERSION_PATCH --build-arg QT_VERSION_MAJOR=$QT_VERSION_MAJOR --build-arg QT_VERSION_MINOR=$QT_VERSION_MINOR --build-arg QT_VERSION_PATCH=$QT_VERSION_PATCH --build-arg QT_DOWNLOAD_BRANCH=$QT_DOWNLOAD_BRANCH --build-arg QT_TARBALL_NAMING_SCHEME=$QT_TARBALL_NAMING_SCHEME --build-arg CI_BUILD=$CI_BUILD --build-arg CORE_COUNT=$CORE_COUNT --build-arg PROXY=$PROXY --target=builder -t darkmattercoder/qt-build:builder-$QT_VERSION_MAJOR.$QT_VERSION_MINOR.$QT_VERSION_PATCH .
# qt
docker build --pull --cache-from darkmattercoder/qt-build:builder-$QT_VERSION_MAJOR.$QT_VERSION_MINOR.$QT_VERSION_PATCH --build-arg QT_VERSION_MAJOR=$QT_VERSION_MAJOR --build-arg QT_VERSION_MINOR=$QT_VERSION_MINOR --build-arg QT_VERSION_PATCH=$QT_VERSION_PATCH --build-arg QT_DOWNLOAD_BRANCH=$QT_DOWNLOAD_BRANCH --build-arg QT_TARBALL_NAMING_SCHEME=$QT_TARBALL_NAMING_SCHEME --build-arg CI_BUILD=$CI_BUILD --build-arg CORE_COUNT=$CORE_COUNT --target=qt -t darkmattercoder/qt-build:$QT_VERSION_MAJOR.$QT_VERSION_MINOR.$QT_VERSION_PATCH .