load(qt_module)

QT = core organizer

TARGET = qtorganizer_memory
target.path += $$[QT_INSTALL_PLUGINS]/organizer
INSTALLS += target

load(qt_plugin)

DESTDIR = $$QT.organizer.plugins/organizer

HEADERS += \
    qorganizeritemmemorybackend_p.h

SOURCES += \
    qorganizeritemmemorybackend.cpp