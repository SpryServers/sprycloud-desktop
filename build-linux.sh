#!/bin/bash
SRCDIR=$(pwd)
rm -rf build;
rm -rf client-build;
mkdir build
mkdir client-build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE="Release" \
      -DNO_SHIBBOLETH=1 \
      -DWITH_DOC=FALSE \
      -DQTKEYCHAIN_LIBRARY=/usr/lib/libqt5keychain.so \
      -DQTKEYCHAIN_INCLUDE_DIR=/usr/include/qt5keychain/
make -j4
make DESTDIR=$SRCDIR/client-build install
cd $SRCDIR
cd client-build
sed -i -e 's|Icon=sprycloud|Icon=spryCloud|g' usr/share/applications/sprycloud.desktop
cd $SRCDIR
echo 'Client successfully built. Client files at $SRCDIR/client-build'
