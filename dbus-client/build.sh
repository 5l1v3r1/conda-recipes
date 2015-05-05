#! /bin/bash
# Copyright 2014-2015 Peter Williams and collaborators.
# This file is licensed under a 3-clause BSD license; see LICENSE.txt.

# We disable systemd since otherwise the installation tries to write to
# /usr/lib/... even though we've specified --prefix.

set -e
./configure --prefix=$PREFIX --disable-tests --disable-systemd || { cat config.log ; exit 1 ; }
make
make install

cd $PREFIX
rm -rf bin etc libexec share
