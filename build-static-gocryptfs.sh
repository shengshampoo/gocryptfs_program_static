
#! /bin/bash

set -e

WORKSPACE=/tmp/workspace
mkdir -p $WORKSPACE
mkdir -p /work/artifact

# libressl
cd $WORKSPACE
aa=4.1.0
curl -sL https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-$aa.tar.gz | tar xv --gzip
cd libressl-$aa
./configure --prefix=/usr --disable-tests -disable-shared --enable-static
make
make install

# gocryptfs
cd $WORKSPACE
git clone https://github.com/rfjakob/gocryptfs.git
cd gocryptfs
cat /go/gocryptfs.static.patch | patch -p0
CGO_ENABLED=1 bash ./build.bash

cd $WORKSPACE/gocryptfs
tar vcJf ./gocryptfs.tar.xz gocryptfs

mv ./gocryptfs.tar.xz /work/artifact/
