#!/bin/bash

export SELF_CALLDIR="$(pwd)"

rm -R -f ./papi_id
mkdir ./papi_id

cd ./papi_id
wget http://icl.cs.utk.edu/projects/papi/downloads/papi-5.7.0.tar.gz

tar -xvzf ./papi-5.7.0.tar.gz

cd ./papi-5.7.0/src/

patch -p1 < ../../../fix1.patch
patch -p1 < ../../../fix2.patch

export CFLAGS="-fPIC ${CFLAGS}"
export CC=gcc
./configure \
  --prefix=/usr/local/ \
  --with-static-lib=yes --with-shared-lib=yes \
  --with-perf-events

make -j8
sudo make install

cd "$SELF_CALLDIR"
rm -R -f ./papi_id

