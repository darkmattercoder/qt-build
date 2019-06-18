QT += core network
QT -= gui
TARGET = ssltest
CONFIG   += console
CONFIG   -= app_bundle
TEMPLATE = app
SOURCES += main.cpp

lessThan(10, QT_MINOR_VERSION){
INCLUDEPATH += /opt/openssl_build_stable/include
LIBS += -L/opt/openssl_build_stable/lib -lcrypto -lssl
}