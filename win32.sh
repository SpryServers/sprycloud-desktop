#!/bin/bash
VERSION=2.5.0
SRCPATH=$(pwd)
git submodule init
git submodule update
cd admin/win/docker
docker build . -t sprycloud-client-win32:$VERSION
cd $SRCPATH
docker run -v "$PWD:/home/user/client" sprycloud-client-win32:$VERSION    \
        /home/user/client/admin/win/docker/build.sh client/  $(id -u)
