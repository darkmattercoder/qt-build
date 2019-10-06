#!/bin/sh
# this config is so weird looking because there was a bug in the original 5.6.1 that has been hotfixed.
# To get the ci scheme work with this, I have to tweak it that way...
set -e
set -x
CORE_COUNT=$1
# adding compatible ssl version
git clone https://github.com/openssl/openssl.git
cd openssl
git checkout OpenSSL_1_0_2-stable
LATEST_TAG=$(git describe --match "OpenSSL_1_0_2[a-z]*" --abbrev=0)
git checkout $LATEST_TAG
./config --prefix=/opt/openssl_build_stable -shared > /dev/null 2>&1 || ./config --prefix=/opt/openssl_build_stable -shared
make -j$CORE_COUNT > /dev/null 2>&1 || make -j$CORE_COUNT
make test > /dev/null 2>&1 || make test
make install > /dev/null 2>&1 || make install
cd ..
OPENSSL_LIBS='-L/opt/openssl_build_stable/lib -lssl -lcrypto' ../../qt-everywhere-opensource-src-5.6.1/configure -prefix $QT_PREFIX -opensource -confirm-license -nomake examples -nomake tests -qt-xcb -openssl-linked -I /opt/openssl_build_stable/include -L /opt/openssl_build_stable/lib
mkdir -p /opt/extra-dependencies/lib
cp -r /opt/openssl_build_stable /opt/extra-dependencies
ln -s /opt/extra-dependencies/openssl_build_stable/lib/* /opt/extra-dependencies/lib