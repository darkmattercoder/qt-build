#!/bin/sh
# Patch Qt to find Firebird library
sed -i -e 's/"-lgds"/"-lfbclient"/' ../qtbase/src/plugins/sqldrivers/configure.json

../configure -prefix $QT_PREFIX -opensource -confirm-license -nomake examples -nomake tests