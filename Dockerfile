FROM golang:alpine3.22

# https://mirrors.alpinelinux.org/
RUN sed -i 's@dl-cdn.alpinelinux.org@ftp.halifax.rwth-aachen.de@g' /etc/apk/repositories

RUN apk update
RUN apk upgrade

# required liboqs 
RUN apk add --no-cache \
  curl git gcc make linux-headers \
  musl-dev bash patch pkgconfig xz

ENV XZ_OPT=-e9
COPY build-static-gocryptfs.sh build-static-gocryptfs.sh
COPY gocryptfs.static.patch gocryptfs.static.patch
RUN chmod +x ./build-static-gocryptfs.sh
RUN bash ./build-static-gocryptfs.sh
