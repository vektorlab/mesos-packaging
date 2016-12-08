#!/bin/bash
set -e

TARGET=$1
MESOS_SOURCE_REPO="https://github.com/apache/mesos.git"
SOURCE_PATH="/src"
BUILD_PATH="$SOURCE_PATH/build"
MESOS_VERSION="${MESOS_VERSION:=1.1.x}"
MESOS_TEMP_PATH="/tmp/mesos"
MESOS_TEMP_PATH_GO="/tmp/mesos-proto-go"

function init_source {
  if [ ! -f "$SOURCE_PATH/bootstrap" ]; then
    git clone $MESOS_SOURCE_REPO src
    git checkout $MESOS_VERSION
  fi
  if [ ! -d "$BUILD_PATH" ]; then
    mkdir "$BUILD_PATH"
  fi
  cd $SOURCE_PATH
  MESOS_VERSION="$(git rev-parse --abbrev-ref HEAD)"
  cd ..
}

function build_mesos {
  CONFIG_OPTIONS=$1
  cd $SOURCE_PATH
  ./bootstrap
  cd $BUILD_PATH
  echo "configure $CONFIG_OPTIONS"
  $SOURCE_PATH/configure --prefix=/usr $CONFIG_OPTIONS
  make -j "$(cat /proc/cpuinfo |grep processor |wc -l)"
  # make check
  make install DESTDIR="$MESOS_TEMP_PATH"
  make distclean
}

case "$TARGET" in 
  'tiny')
    echo "Building $TARGET"
    init_source
    build_mesos "--disable-python --enable-optimize"
    cd $SOURCE_PATH
    tar -czvf "mesos-$MESOS_VERSION-tiny.tar.gz" -C "$MESOS_TEMP_PATH" .
    md5sum "mesos-$MESOS_VERSION-tiny.tar.gz" > "mesos-$MESOS_VERSION-tiny.tar.gz.md5"
    ;;
  'protoc-go')
    echo "Building protocol buffers for Go"
    init_source
    cd $SOURCE_PATH/include
    if [ ! -d "$MESOS_TEMP_PATH_GO" ]; then
      mkdir "$MESOS_TEMP_PATH_GO"
    fi
    for i in $(find . |grep '\.proto'); do 
      protoc --go_out="$MESOS_TEMP_PATH_GO" $i
    done
    cd ..
    tar -czvf "mesos-$MESOS_VERSION-proto-go.tar.gz" -C "$MESOS_TEMP_PATH_GO/mesos" .
    md5sum "mesos-$MESOS_VERSION-proto-go.tar.gz" > "mesos-$MESOS_VERSION-proto-go.tar.gz.md5"
    ;;
  *)
    echo "Select a target [tiny, protoc-go]"
    exit 1
esac 
