#! /bin/bash
# Copyright 2015 Peter Williams and collaborators.
# This file is licensed under a 3-clause BSD license; see LICENSE.txt.

# Build a bunch of X.org packages at once. The list of packages below should
# be kept synchronized with make-tarball.sh.

set -e -x

jflag=-j4

export PKG_CONFIG_LIBDIR=$PREFIX/lib/pkgconfig:$PREFIX/share/pkgconfig

# I'm not sure why, but `-e` mode doesn't cause us to exit when the inner
# pipelines fail, even though they exit with error codes.
(cd xproto-* && ./configure --prefix=$PREFIX && make $jflag install) || exit $?
(cd xcb-proto-* && ./configure --prefix=$PREFIX && make $jflag install) || exit $?
(cd xextproto-* && ./configure --prefix=$PREFIX && make $jflag install) || exit $?
(cd fixesproto-* && ./configure --prefix=$PREFIX && make $jflag install) || exit $?
(cd kbproto-* && ./configure --prefix=$PREFIX && make $jflag install) || exit $?
(cd inputproto-* && ./configure --prefix=$PREFIX && make $jflag install) || exit $?
(cd renderproto-* && ./configure --prefix=$PREFIX && make $jflag install) || exit $?
(cd xtrans-* && ./configure --prefix=$PREFIX && make $jflag install) || exit $?
(cd libpthread-stubs-* && ./configure --prefix=$PREFIX && make $jflag && make install) || exit $?
(cd libICE-* && ./configure --prefix=$PREFIX && make $jflag && make install) || exit $?
(cd libSM-* && ./configure --prefix=$PREFIX && make $jflag && make install) || exit $?
(cd libXau-* && ./configure --prefix=$PREFIX && make $jflag && make install) || exit $?
(cd libXdmcp-* && ./configure --prefix=$PREFIX && make $jflag && make install) || exit $?
(cd libxcb-* && ./configure --prefix=$PREFIX --enable-xinput && make $jflag && make install) || exit $?
(cd libX11-* && ./configure --prefix=$PREFIX && make $jflag && make install) || exit $?
(cd libXext-* && ./configure --prefix=$PREFIX && make $jflag && make install) || exit $?
(cd libXfixes-* && ./configure --prefix=$PREFIX && make $jflag && make install) || exit $?
(cd libXi-* && ./configure --prefix=$PREFIX && make $jflag && make install) || exit $?
(cd libXrender-* && ./configure --prefix=$PREFIX && make $jflag && make install) || exit $?

cd $PREFIX
rm -rf share/aclocal share/doc share/man share/pkgconfig lib/python2.7
rm -f lib/*.a lib/*.la
