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

##### patch to fix this in oe-core sent
QT_CONFIG_FLAGS += "-release -no-cups -reduce-relocations \
                    -shared -no-nas-sound -no-nis \
                    -system-libjpeg -system-libpng -system-libtiff -system-zlib \
                    -no-pch -stl -glib \
                    -no-rpath -silent \
                    ${QT_DBUS} \
                    ${QT_QT3SUPPORT} \
                    ${QT_WEBKIT} \
                    ${QT_PHONON} \
                    ${QT_XML} \
                    ${QT_MULTIMEDIA} \
                    ${QT_SQL_DRIVER_FLAGS} \
                    ${QT_DISTRO_FLAGS} \
                    ${QT_GLFLAGS}"

QT_EMBEDDED_FLAGS ?= " \
    -embedded $QT_ARCH \
    -qtlibinfix ${QT_LIBINFIX} \
"
QT_EMBEDDED_EXTRA_FLAGS ?= " \
    -plugin-gfx-transformed -plugin-gfx-qvfb -plugin-gfx-vnc -plugin-gfx-directfb \
    -plugin-mouse-tslib -qt-mouse-pc -qt-mouse-qvfb -qt-mouse-linuxinput \
    -qt-kbd-tty \
"
QT_EMBEDDED_KEYPAD_FLAGS ?= " \
    -DQT_KEYPAD_NAVIGATION \
"

QT_CONFIG_FLAGS += "${QT_EMBEDDED_FLAGS} ${QT_EMBEDDED_EXTRA_FLAGS} ${QT_EMBEDDED_KEYPAD_FLAGS}"

##### patch to fix this in oe-core sent

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
QT_EMBEDDED_EXTRA_FLAGS = ""
QT_EMBEDDED_KEYPAD_FLAGS = ""

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

QT_DEVICE_FLAGS = " \
  ${QT_WEBOS_DESKTOP_FLAGS} \
"
QT_DEVICE_FLAGS_armv7a = " \
  ${QT_WEBOS_PALM_DEVICE_FLAGS} \
  -DPALM_DEVICE \
"
QT_DEVICE_FLAGS_armv6 = " \
  ${QT_WEBOS_PALM_DEVICE_FLAGS} \
  -DPALM_DEVICE \
"

QT_DISTRO_FLAGS = " \
  ${QT_DISABLE_FLAGS} \
  ${QT_BLIT} \
  ${QT_NEON} \
  ${QT_DEVICE_FLAGS} \
  ${QT_WEBOS_FLAGS} \
"
# -force-pkg-config
# qemux86 -no-rpath ???

# qconfig-palm.h
QT_WEBOS_FLAGS = " \
  -feature-webos \
  ${QT_WEBOS_COMPILER_FLAGS} \
  ${QT_WEBOS_DIALOGS_FLAGS} \
  ${QT_WEBOS_IO_FLAGS} \
  ${QT_WEBOS_FONTS_FLAGS} \
  ${QT_WEBOS_GUI_FLAGS} \
  ${QT_WEBOS_IMAGES_FLAGS} \
  ${QT_WEBOS_ITEMVIEWS_FLAGS} \
  ${QT_WEBOS_KERNEL_FLAGS} \
  ${QT_WEBOS_NETWORKING_FLAGS} \
  ${QT_WEBOS_PAINTING_FLAGS} \
  ${QT_WEBOS_PHONON_FLAGS} \
  ${QT_WEBOS_EMBEDDED_FLAGS} \
  ${QT_WEBOS_SVG_FLAGS} \
  ${QT_WEBOS_STYLES_FLAGS} \
  ${QT_WEBOS_UTILITIES_FLAGS} \
  ${QT_WEBOS_WIDGETS_FLAGS} \
  ${QT_WEBOS_IDENTITY_FLAGS} \
  ${QT_WEBOS_WINDOWS_FLAGS} \
"
QT_WEBOS_COMPILER_FLAGS = " \
  -no-exceptions \
"
QT_WEBOS_DIALOGS_FLAGS = " \
  -no-feature-colordialog \
  -no-feature-errormessage \
  -no-feature-filedialog \
  -no-feature-fontdialog \
  -no-feature-inputdialog \
  -no-feature-messagebox \
  -no-feature-printdialog \
  -no-feature-printpreviewdialog \
  -no-feature-progressdialog \
  -no-feature-tabdialog \
  -no-feature-wizard \
"
QT_WEBOS_IO_FLAGS = " \
  -no-feature-dom \
"
QT_WEBOS_FONTS_FLAGS = " \
  -no-feature-qws-qpf \
  -no-feature-qws-qpf2 \
"
QT_WEBOS_GUI_FLAGS = " \
  -no-feature-softkeymanager \
"
# -no-feature-imageformat-xpm (different for desktop and palm device)
QT_WEBOS_IMAGES_FLAGS = " \
  -no-feature-imageformat-ppm \
  -no-feature-imageformat-xbm \
  -no-feature-image-text \
  -no-feature-movie \
"
QT_WEBOS_ITEMVIEWS_FLAGS = " \
  -no-feature-itemviews \
  -no-feature-datawidgetmapper \
  -no-feature-dirmodel \
  -no-feature-listview \
  -no-feature-columnview \
  -no-feature-proxymodel \
  -no-feature-sortfilterproxymodel \
  -no-feature-standarditemmodel \
  -no-feature-stringlistmodel \
  -no-feature-tableview \
  -no-feature-treeview \
"
# -no-feature-clipboard (different for desktop and palm device}
# -no-feature-cursor (different for desktop and palm device)
# -no-feature-wheelevent (different for desktop and palm device)
QT_WEBOS_KERNEL_FLAGS = " \
  -no-feature-cssparser \
  -no-feature-cursor \
  -no-feature-sessionmanager \
  -no-feature-sound \
  -no-feature-tabletevent \
  -no-feature-texthtmlparser \
"
# -no-feature-cop (commented out in qconfig-palm.h)
# -no-feature-networkproxy (commented out in qconfig-palm.h)
# -no-feature-socks5 (commented out in qconfig-palm.h)
# -no-feature-udpsocket (commented out in qconfig-palm.h)
QT_WEBOS_NETWORKING_FLAGS = " \
  -no-feature-ftp \
"
QT_WEBOS_PAINTING_FLAGS = " \
  -no-feature-cups \
"
QT_WEBOS_PHONON_FLAGS = " \
  -no-feature-phonon-abstractmediastream \
  -no-feature-phonon-audiocapture \
  -no-feature-phonon-effect \
  -no-feature-phonon-mediacontroller \
  -no-feature-phonon-objectdescriptionmodel \
  -no-feature-phonon-platformplugin \
  -no-feature-phonon-seekslider \
  -no-feature-phonon-settingsgroup \
  -no-feature-phonon-video \
  -no-feature-phonon-volumeslider \
"
QT_WEBOS_EMBEDDED_FLAGS = " \
  -no-feature-qwsembedwidget \
  -no-feature-qws-alpha-cursor \
  -no-feature-qws-decoration-default \
  -no-feature-qws-multiprocess \
  -no-feature-qws-transformed \
  -no-feature-qws-vnc \
"
QT_WEBOS_SVG_FLAGS = " \
  -no-feature-svg \
  -no-feature-graphicssvgitem \
  -no-feature-svggenerator \
  -no-feature-svgrenderer \
  -no-feature-svgwidget \
"
QT_WEBOS_STYLES_FLAGS = " \
  -no-feature-style-motif \
"
# -no-feature-script (QT Declarative requires QT Script)
# -no-feature-completer (QT Keypad Navigation requires QT completer)
QT_WEBOS_UTILITIES_FLAGS = " \
  -no-feature-accessibility \
  -no-feature-desktopservices \
  -no-feature-systemtrayicon \
  -no-feature-undocommand \
  -no-feature-undogroup \
  -no-feature-undostack \
  -no-feature-undoview \
"
# -no-feature-lineedit (QT Declarative requires QT Lineedit)
# -no-feature-signalmappera (commented out in qconfig-palm.h)
QT_WEBOS_WIDGETS_FLAGS = " \
  -no-feature-groupbox \
  -no-feature-buttongroup \
  -no-feature-lcdnumber \
  -no-feature-combobox \
  -no-feature-fontcombobox \
  -no-feature-spinbox \
  -no-feature-calendarwidget \
  -no-feature-datetimeedit \
  -no-feature-listwidget \
  -no-feature-menu \
  -no-feature-contextmenu \
  -no-feature-mainwindow \
  -no-feature-dockwidget \
  -no-feature-toolbar \
  -no-feature-menubar \
  -no-feature-workspace \
  -no-feature-progressbar \
  -no-feature-resizehandler \
  -no-feature-rubberband \
  -no-feature-splitter \
  -no-feature-sizegrip \
  -no-feature-dial \
  -no-feature-printpreviewwidget \
  -no-feature-mdiarea \
  -no-feature-textedit \
  -no-feature-syntaxhighlighter \
  -no-feature-textbrowser \
  -no-feature-spinwidget \
  -no-feature-splashscreen \
  -no-feature-stackedwidget \
  -no-feature-tabwidget \
  -no-feature-statusbar \
  -no-feature-statustip \
  -no-feature-tablewidget \
  -no-feature-toolbutton \
  -no-feature-tabbar \
  -no-feature-toolbox \
  -no-feature-whatsthis \
  -no-feature-tooltip \
  -no-feature-treewidget \
  -no-feature-validator \
"
QT_WEBOS_IDENTITY_FLAGS = " \
  -no-feature-identityproxymodel \
"
QT_WEBOS_WINDOWS_FLAGS = " \
  -no-feature-win-activeqt \
"
QT_WEBOS_DESKTOP_FLAGS = " \
  -feature-imageformat-xpm \
  -feature-clipboard \
  -feature-cursor \
  -feature-wheelevent \
  -feature-lineedit \
"
QT_WEBOS_PALM_DEVICE_FLAGS = " \
  -no-feature-imageformat-xpm \
  -no-feature-clipboard \
  -no-feature-cursor \
  -no-feature-wheelevent \
"
