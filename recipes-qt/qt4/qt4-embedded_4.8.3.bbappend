inherit webos-ports-submissions

# qt4-webos repo does not have LICENSE.GPL3 like upstream has
LICENSE = "LGPLv2.1"
LIC_FILES_CHKSUM = "file://LICENSE.LGPL;md5=cc5963be04f8b19c3e3c46bc31f0f6e1 \
                    file://LGPL_EXCEPTION.txt;md5=411080a56ff917a5a1aa08c98acae354"

SRC_URI = "git://github.com/webOS-ports/qt.git;branch=rebased-v4.8.3-no-palm-tools+oe-core \
  file://linux.conf \
  file://g++.conf \
  file://qte.sh \
"
SRCREV = "0c7691fb6a77790cf72b2bdb08ba98c953f2ae37"
S = "${WORKDIR}/git"

PROVIDES += "qt4-webos"

DEPENDS += "nyx-lib"

# disable some stuff which is enabled in oe-core
QT_QT3SUPPORT = " \
  -no-qt3support \
"
QT_XML = " \
  -no-xmlpatterns \
"
QT_WEBKIT = " \
  -no-webkit \
  -no-javascript-jit \
  -no-scripttools \
"
QT_PHONON = " \
  -no-phonon \
  -no-phonon-backend \
"
QT_DBUS = " \
  -no-dbus \
"
QT_MULTIMEDIA = " \
  -no-multimedia \
  -no-audio-backend \
  -no-gstreamer \
"

# per arch flags for opengl
QT_GLFLAGS = " \
  -no-opengl \
"
QT_GLFLAGS_armv7a = " \
  -opengl 
  -plugin-gfx-egl \
"
QT_GLFLAGS_x86 = ""

DEPENDS_append_armv7a = " virtual/egl"

# disable few more stuff, which is not specified at all in oe-core
QT_DISABLE_FLAGS = " \
  -no-exceptions \
  -no-accessibility \
  -no-svg \
  -no-libtiff \
  -no-libmng \
  -no-gtkstyle \
  -reduce-exports \
  -qt-zlib \
  -system-freetype \
  -qt-kbd-linuxinput \
"

QT_BLIT = " \
  -DQT_QWS_CLIENTBLIT \
"
QT_BLIT_x86 = ""

QT_NEON = " \
  -no-neon \
"
QT_NEON_armv7a = ""

QT_DEVICE_FLAGS = ""
QT_DEVICE_FLAGS_armv7a = "-DPALM_DEVICE"
QT_DEVICE_FLAGS_armv6 = "-DPALM_DEVICE"

QT_DISTRO_FLAGS = " \
  ${QT_DISABLE_FLAGS} \
  ${QT_BLIT} \
  ${QT_NEON} \
  ${QT_DEVICE_FLAGS} \
"
# -force-pkg-config
# qemux86 -no-rpath ???
