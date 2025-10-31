
#! /bin/bash

set -e

WORKSPACE=/tmp/workspace
mkdir -p $WORKSPACE
mkdir -p /work/artifact

# libressl
cd $WORKSPACE
aa=4.2.1
curl -sL https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-$aa.tar.gz | tar x --gzip
cd libressl-$aa
./configure --prefix=/usr --disable-tests -disable-shared --enable-static
make
make install


# gocryptfs
cd $WORKSPACE
git clone https://github.com/rfjakob/gocryptfs.git
cd gocryptfs
cat /go/gocryptfs.static.patch | patch -p0
if [ "$(uname -m)" == "x86_64" ]; then
GOAMD64=v3 GOOS=$(uname -o | sed -e s@^.*/@@ | tr '[:upper:]' '[:lower:]') GOARCH=amd64 CGO_ENABLED=1 bash ./build.bash
elif [ "$(uname -m)" == "aarch64" ]; then
GOARM64=v8.0,lse GOOS=$(uname -o | sed -e s@^.*/@@ | tr '[:upper:]' '[:lower:]') GOARCH=arm64 CGO_ENABLED=1 bash ./build.bash
else
exit 1
fi

cd $WORKSPACE/gocryptfs
tar cJf ./gocryptfs.tar.xz gocryptfs

mv ./gocryptfs.tar.xz /work/artifact/
