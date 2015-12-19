#! /bin/bash
# Copyright 2014-2015 Peter Williams and collaborators.
# This file is licensed under a 3-clause BSD license; see LICENSE.txt.

[ "$NJOBS" = '<UNDEFINED>' ] && NJOBS=1
set -e

./configure --prefix=$PREFIX || { cat config.log ; exit 1 ; }
make -j$NJOBS
make install
