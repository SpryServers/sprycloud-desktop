#! /bin/bash

set -xe

mkdir /app
mkdir /build

#Set Qt-5.12
export QT_BASE_DIR=/opt/qt5.12.5
export QTDIR=$QT_BASE_DIR
export PATH=$QT_BASE_DIR/bin:$PATH
export LD_LIBRARY_PATH=$QT_BASE_DIR/lib/x86_64-linux-gnu:$QT_BASE_DIR/lib:$LD_LIBRARY_PATH
export PKG_CONFIG_PATH=$QT_BASE_DIR/lib/pkgconfig:$PKG_CONFIG_PATH

#set defaults
export SUFFIX=${DRONE_PULL_REQUEST:=master}
if [ $SUFFIX != "master" ]; then
    SUFFIX="PR-$SUFFIX"
fi

#QtKeyChain master
cd /build
git clone https://github.com/frankosterfeld/qtkeychain.git
cd qtkeychain
git checkout master
mkdir build
cd build
cmake -D CMAKE_INSTALL_PREFIX=/usr ../
make -j4
make DESTDIR=/app install

#Build client
cd /build
mkdir build-client
cd build-client
cmake -D CMAKE_INSTALL_PREFIX=/usr \
    -D NO_SHIBBOLETH=1 \
    -D QTKEYCHAIN_LIBRARY=/app/usr/lib/x86_64-linux-gnu/libqt5keychain.so \
    -D QTKEYCHAIN_INCLUDE_DIR=/app/usr/include/qt5keychain/ \
    -DMIRALL_VERSION_SUFFIX=PR-$DRONE_PULL_REQUEST \
    -DMIRALL_VERSION_BUILD=$DRONE_BUILD_NUMBER \
    $DRONE_WORKSPACE
make -j4
make DESTDIR=/app install

# Move stuff around
cd /app

mv ./usr/lib/x86_64-linux-gnu/sprycloud/* ./usr/lib/x86_64-linux-gnu/
mv ./usr/lib/x86_64-linux-gnu/* ./usr/lib/
rm -rf ./usr/lib/sprycloud
rm -rf ./usr/lib/cmake
rm -rf ./usr/include
rm -rf ./usr/mkspecs
rm -rf ./usr/lib/x86_64-linux-gnu/

# Don't bundle nextcloudcmd as we don't run it anyway
rm -rf ./usr/bin/sprycloudcmd

# Don't bundle the explorer extentions as we can't do anything with them in the AppImage
rm -rf ./usr/share/caja-python/
rm -rf ./usr/share/nautilus-python/
rm -rf ./usr/share/nemo-python/

# Move sync exlucde to right location
mv ./etc/spryCloud/sync-exclude.lst ./usr/bin/
rm -rf ./etc

DESKTOP_FILE=/app/usr/share/applications/${LINUX_APPLICATION_ID}.desktop
sed -i -e 's|Icon=sprycloud|Icon=spryCloud|g' usr/share/applications/sprycloud.desktop # Bug in desktop file?
cp ./usr/share/icons/hicolor/512x512/apps/spryCloud.png . # Workaround for linuxeployqt bug, FIXME

# Because distros need to get their shit together
cp -R /lib/x86_64-linux-gnu/libssl.so* ./usr/lib/
cp -R /lib/x86_64-linux-gnu/libcrypto.so* ./usr/lib/
cp -P /usr/local/lib/libssl.so* ./usr/lib/
cp -P /usr/local/lib/libcrypto.so* ./usr/lib/

# NSS fun
cp -P -r /usr/lib/x86_64-linux-gnu/nss ./usr/lib/

# Use linuxdeployqt to deploy
cd /build
wget -c "https://github.com/probonopd/linuxdeployqt/releases/download/continuous/linuxdeployqt-continuous-x86_64.AppImage"
chmod a+x linuxdeployqt*.AppImage
./linuxdeployqt-continuous-x86_64.AppImage --appimage-extract
rm ./linuxdeployqt-continuous-x86_64.AppImage
unset QTDIR; unset QT_PLUGIN_PATH ; unset LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/app/usr/lib/
./squashfs-root/AppRun ${DESKTOP_FILE} -bundle-non-qt-libs

# Set origin
./squashfs-root/usr/bin/patchelf --set-rpath '$ORIGIN/' /app/usr/lib/libsprycloudsync.so.0

# Build AppImage
./squashfs-root/AppRun ${DESKTOP_FILE} -appimage

mv spryCloud*.AppImage spryCloud-${SUFFIX}-${DRONE_COMMIT}-x86_64.AppImage
