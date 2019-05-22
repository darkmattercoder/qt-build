#!/bin/sh
set -e
# adding compatible ssl version
git clone https://github.com/openssl/openssl.git
cd openssl
git checkout OpenSSL_1_0_2-stable
LATEST_TAG=$(git describe --match "OpenSSL_1_0_2[a-z]*" --abbrev=0)
git checkout $LATEST_TAG
./config --prefix=/opt/openssl_build_stable -shared
make > /dev/null 2>&1 || make
make test
make install > /dev/null || make install

OPENSSL_LIBS='-L/opt/openssl_build_stable/lib -lssl -lcrypto' ../configure -prefix $QT_PREFIX -opensource -confirm-license -nomake examples -nomake tests -qt-xcb -openssl-linked -I /opt/openssl_build_stable/include/openssl -L /opt/openssl_build_stable/lib