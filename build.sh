#!/bin/bash
set -e

ARG=$1
TARGET="${ARG:=musl}"
DOCKER="/usr/bin/docker"
BUILD_IMAGE="quay.io/vektorcloud/build:latest"

git submodule sync
git submodule update --init

cd mesos-src
MESOS_VERSION=$(git rev-parse --abbrev-ref HEAD)
cd ..

function build_musl {
  PACKAGE_NAME="mesos-musl-$MESOS_VERSION"
  DOCKER="docker run --rm -ti -w /src -v $PWD/mesos-src:/src -v $PWD/target:/target $BUILD_IMAGE"
  $DOCKER ./bootstrap
  $DOCKER ./configure --prefix=/target/musl
  $DOCKER make -j $(cat /proc/cpuinfo |grep processor |wc -l) V=0
  $DOCKER make install
  $DOCKER make clean
  tar -czvf "$PACKAGE_NAME.tar.gz" -C target/musl/ .
  md5sum "$PACKAGE_NAME.tar.gz" > "$PACKAGE_NAME.tar.gz.md5"
}

case "$TARGET" in 
  'musl')
    echo "Building musl.."
    build_musl
    ;;
esac 
