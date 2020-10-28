#!/bin/sh
sed -i -e 's/"-lgds"/"-lfbclient"/' ../qtbase/src/plugins/sqldrivers/configure.json
../configure -prefix $QT_PREFIX -opensource -confirm-license -nomake examples -nomake tests -skip qtwebengine -xcb -bundled-xcb-xinput