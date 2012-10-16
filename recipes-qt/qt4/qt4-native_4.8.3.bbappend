# for webkit-webos
do_install_append() {
  ln -s moc ${D}${bindir}/moc-palm
  ln -s uic ${D}${bindir}/uic-palm
  ln -s uic3 ${D}${bindir}/uic3-palm
  ln -s rcc ${D}${bindir}/rcc-palm
  ln -s qmake2 ${D}${bindir}/qmake-palm
}

# replace broken qmake-webos-native with this one
PROVIDES += "qmake-webos-native"
