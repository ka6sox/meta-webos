# Copyright 2012  Palm, Inc.  All rights reserved.

DESCRIPTION = "webOS WebKit is an open source web rendering engine."
LICENSE = "LGPLv2.1"
LIC_FILES_CHKSUM =  "file://Source/WebCore/LICENSE-LGPL-2.1;md5=a778a33ef338abbaf8b8a7c36b6eec80"
DEPENDS = "qt4-webos luna-service2 sqlite3"

inherit autotools
inherit webos_submissions

PR = "r2"

#
# Webkit source is identified WEBOS_SUBMISSION and SRCREV defined in
# webos-component-submission.inc & webos-component-head.inc. Those 
# values needs adjustment for future updates. 
#
SRC_URI = "${ISIS_PROJECT_DOWNLOAD}/WebKit/WebKit_${WEBOS_SUBMISSION}s.zip \
           file://webkit-lunasysmanager-unistd.patch"
S = "${WORKDIR}/isis-project-WebKit-${SRCREV}"

SRC_URI[md5sum] = "2ccc10a11c6e940b20b3b3b0cd30e9bc"
SRC_URI[sha256sum] = "c60a8d2748b4c36accb46ed9479c6ee4995bd367ba06759eb499a05f984d63ab"

# XXX Expediently patch Tools/Scripts/webkitdirs.pm to remove the
# extraneous empty "-W1,-soname," that qmake adds to link command lines.
# Eventually, arrange for qmake to do the right thing.
SRC_URI += "file://remove-empty-soname-arg.patch"

PALM_CC_OPT = "-O2"
OBJDIR = "${TARGET_ARCH}"

WEBKITOUTPUTDIR = "${S}/WebKitBuild/${OBJDIR}"
PALM_BUILD_DIR = "${WEBKITOUTPUTDIR}/Release"

export STRIP_TMP="${STRIP}"
export F77_TMP="${F77}"
export QMAKE_MKSPEC_PATH_TMP="${QMAKE_MKSPEC_PATH}"
export CC_TMP="${CC}"
export CPPFLAGS_TMP="${CPPFLAGS}"
export RANLIB_TMP="${RANLIB}"
export CXX_TMP="${CXX}"
export OBJCOPY_TMP="${OBJCOPY}"
export CCLD_TMP="${CCLD}"
export CFLAGS_TMP="${CFLAGS}"
export TARGET_LDFLAGS_TMP="${TARGET_LDFLAGS}"
export LDFLAGS_TMP="${LDFLAGS}"
export AS_TMP="${AS}"
export AR_TMP="${AR}"
export CPP_TMP="${CPP}"
export TARGET_CPPFLAGS_TMP="${TARGET_CPPFLAGS}"
export CXXFLAGS_TMP="${CXXFLAGS}"
export OBJDUMP_TMP="${OBJDUMP}"
export LD_TMP="${LD}"
export QTDIR="${STAGING_DIR_HOST}/usr/src/qt4-webos"

do_configure() {
    :
}

do_compile() {
    export STAGING_INCDIR="${STAGING_INCDIR}"
    export STAGING_LIBDIR="${STAGING_LIBDIR}"

    QMAKE_LINK_ARGS=""

    WEBKITOUTPUTDIR=${WEBKITOUTPUTDIR} ${S}/Tools/Scripts/build-webkit --qt \
        --release \
        --no-video \
        --no-webgl \
        --only-webkit \
        --no-webkit2 \
        --qmake="${STAGING_BINDIR_NATIVE}/qmake-palm" \
        --makeargs="${PARALLEL_MAKE}" \
        --qmakearg="DEFINES+=PALM_DEVICE" \
        --qmakearg="DEFINES+=ENABLE_PALM_SERVICE_BRIDGE=1" \
        --qmakearg="QMAKE_AR=\"${AR} r\"" \
        ${QMAKE_LINK_ARGS}
}

do_install() {
    install -d ${STAGING_INCDIR}/QtWebKit

    libqtwebkit_3ver=$(basename ${PALM_BUILD_DIR}/lib/libQtWebKit.so.*.*.*)
    if [ ! -r "${PALM_BUILD_DIR}/lib/$libqtwebkit_3ver" ]; then
        echo ERROR: '${PALM_BUILD_DIR}/lib/$libqtwebkit_3ver' did not expand or expanded to multiple files.
        return 1
    fi
    libqtwebkit_2ver=$(echo $libqtwebkit_3ver | awk -F. '{ print $1 "." $2 "." $3 "." $4 }')
    libqtwebkit_1ver=$(echo $libqtwebkit_3ver | awk -F. '{ print $1 "." $2 "." $3 }')

    install -m 555 ${PALM_BUILD_DIR}/lib/$libqtwebkit_3ver ${STAGING_LIBDIR}
    ln -sf $libqtwebkit_3ver ${STAGING_LIBDIR}/$libqtwebkit_2ver
    ln -sf $libqtwebkit_3ver ${STAGING_LIBDIR}/$libqtwebkit_1ver
    ln -sf $libqtwebkit_3ver ${STAGING_LIBDIR}/libQtWebKit.so


    # WebKit stages header files that include other header files. We can't just
    # copy their staged header files because the path won't be correct so we
    # have to copy the actual header file that is referenced.
    install -m 444 ${PALM_BUILD_DIR}/include/QtWebKit/Q* ${STAGING_INCDIR}/QtWebKit
    cd ${PALM_BUILD_DIR}/include/QtWebKit && perl -e 'while (<>) {if (m/^#include "([^"]+)"/) {print `install -m 444 $1 ${STAGING_INCDIR}/QtWebKit`;}}' q*.h
    install -d ${D}${libdir}
    oe_libinstall -C ${PALM_BUILD_DIR}/lib -so libQtWebKit ${D}/${libdir}

    install -d ${D}${prefix}/plugins/imports/QtWebKit
    install -m 555 ${PALM_BUILD_DIR}/imports/QtWebKit/* ${D}${prefix}/plugins/imports/QtWebKit
}

FILES_${PN} += "${libdir}/libQtWebKit.so*"
FILES_${PN} += "${prefix}/plugins/imports/QtWebKit/qmldir"
FILES_${PN} += "${prefix}/plugins/imports/QtWebKit/libqmlwebkitplugin.so"
FILES_${PN}-dbg += "${libdir}/.debug"
FILES_${PN}-dbg += "${prefix}/plugins/imports/QtWebKit/.debug"
