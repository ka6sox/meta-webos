# (c) Copyright 2012  Hewlett-Packard Development Company, L.P.

SUMMARY = "WebKit supplemental features for Open webOS"
SECTION = "webos/libs"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

DEPENDS = "qt4-webos webkit-webos qmake-webos-native"

PR = "r5"

inherit webos_public_repo
inherit webos_qmake
inherit webos_submissions
inherit webos_library
inherit webos_machine_dep

WEBOS_GIT_TAG = "${WEBOS_SUBMISSION}"
SRC_URI = "${ISIS_PROJECT_GIT_REPO}/WebKitSupplemental;tag=${WEBOS_GIT_TAG};protocol=git"
S = "${WORKDIR}/git"

PALM_CC_OPT = "-O2"
WEBOS_BUILD_DIR = "build-${MACHINE}"

EXTRA_OEMAKE += "-C ${WEBOS_BUILD_DIR} -f Makefile.WebKitSupplemental"

# Make strip into a NOP to eliminate the
#   "File 'xxx' from <component> was already stripped, this will prevent future debugging!"
# warnings.
export STRIP_TMP = ":"

export TARGET_ARCH
export QTDIR = "${WORKDIR}/qt4-webos"

do_configure() {
    # Don't trust incremental configures
    rm -rf ${WEBOS_BUILD_DIR}
    
    # .qmake.cache is not part of qt4-webos checkout, so let's try to create fake one, pointing to your stored stuff
    mkdir -p "${QTDIR}"
    echo "QT_SOURCE_TREE = \$\$quote(${STAGING_DIR_HOST}/usr/src/qt4-webos/git)" > ${QTDIR}/.qmake.cache
    echo "QT_BUILD_TREE = \$\$quote(${STAGING_DIR_HOST}/usr/src/qt4-webos/build)" >> ${QTDIR}/.qmake.cache

    mkdir -p ${WEBOS_BUILD_DIR}
    # Can't use ${S}/Makefile as we want to do an out-of-tree builds which it 
    # doesn't support.
    (cd ${WEBOS_BUILD_DIR}; ${QMAKE} ${S}/WebKitSupplemental.pro -o Makefile.WebKitSupplemental)

    # Now generate the Makefile.WebKitSupplemental-s in the subdirectories. The
    # *.pro-s arrange for have them to install into STAGING_INCDIR and
    # STAGING_LIBDIR under INSTALL_ROOT.
    export STAGING_INCDIR=${includedir}
    export STAGING_LIBDIR=${libdir}
    oe_runmake qmake_all

    # XXX misc.pro uses the value of STAGING_INCDIR (/usr/include) to generate
    # -I arguments for the INCPATH make variable. Remove them here until misc.pro
    # is fixed.
    sed -i -e 's:-I/usr/include/*[^ ]* ::g' -e 's:-I/usr/include/*[^ ]*$::g' ${WEBOS_BUILD_DIR}/misc/Makefile.WebKitSupplemental
}


do_install() {
    oe_runmake INSTALL_ROOT=${D} install

    # XXX Move libqbsplugin.so to its expected location here until qbsplugin.pro
    # is fixed
    install -d ${D}${prefix}/plugins/platforms/
    mv -v ${D}/plugins/platforms/libqbsplugin.so ${D}${prefix}/plugins/platforms/
    (cd ${D}; rmdir -vp plugins/platforms)

    # XXX Move libqtwebkitplugin.so to its expected location here until
    # qtwebkitplugin.pro is fixed
    install -d ${D}${prefix}/plugins/webkit/
    mv -v ${D}${libdir}/libqtwebkitplugin.so ${D}${prefix}/plugins/webkit/

    if [ -d qbsplugin/fonts ]; then
        install -d ${D}${datadir}/fonts
        install -v -m 644 -t ${D}${datadir}/fonts qbsplugin/fonts/*
    fi
}


FILES_${PN} += "${prefix}/plugins/platforms/libqbsplugin.so"
FILES_${PN} += "${prefix}/plugins/webkit/libqtwebkitplugin.so"
FILES_${PN} += "${datadir}/fonts"
FILES_${PN}-dbg += "${prefix}/plugins/platforms/.debug"
FILES_${PN}-dbg += "${prefix}/plugins/webkit/.debug"
