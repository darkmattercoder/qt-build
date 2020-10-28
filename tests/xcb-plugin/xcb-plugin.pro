QT += core
QT -= gui
TARGET = xcb-plugin
CONFIG   += console
TEMPLATE = app
SOURCES += main.cpp
DEFINES += PLUGIN_DIR=\\\"$$[QT_INSTALL_PLUGINS]\\\"
