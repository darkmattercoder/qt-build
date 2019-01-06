#!/bin/sh
# this config is so weird looking because there was a bug in the original 5.6.1 that has been hotfixed.
# To get the ci scheme work with this, I have to tweak it that way...
../../qt-everywhere-opensource-src-5.6.1/configure -prefix $QT_PREFIX -opensource -confirm-license -nomake examples -nomake tests -qt-xcb