#!/bin/bash

# Become location-aware
export SELF_CALLDIR="$(pwd)"

# Prepare
rm -R -f ./papi_id
mkdir ./papi_id
cd ./papi_id

# Get & Unpack
wget http://icl.cs.utk.edu/projects/papi/downloads/papi-5.7.0.tar.gz
tar -xvzf ./papi-5.7.0.tar.gz
cd ./papi-5.7.0/src/

# Patch
patch -p1 < ../../../fix1.patch
patch -p1 < ../../../fix2.patch

# Configure
export CFLAGS="-fPIC ${CFLAGS}"
export CC=gcc
./configure \
  --prefix=/usr/local/ \
  --with-static-lib=yes --with-shared-lib=yes \
  --with-perf-events

# Build & Install
make -j8
sudo make install

# Clean up
cd "$SELF_CALLDIR"
rm -R -f ./papi_id

# Setup LD_LIBRARY_PATH
sudo mkdir -p /etc/ld.so.conf.d/
cd /etc/ld.so.conf.d/
sudo touch /etc/ld.so.conf.d/locallib.conf
sudo bash -c "echo \"/usr/local/lib/\" >> /etc/ld.so.conf.d/locallib.conf"

# Update LD_LIBRARY_PATH systemwide
cd "$SELF_CALLDIR"
sudo ldconfig -v
