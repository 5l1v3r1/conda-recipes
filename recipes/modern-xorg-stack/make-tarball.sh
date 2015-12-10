#! /bin/bash
# Copyright 2014-2015 Peter Williams and collaborators.
# This file is licensed under a 3-clause BSD license; see LICENSE.txt.

# This script builds a mega-tarball of all the sources of the X11 libraries we
# require. This is necessary because Conda doesn't let us define a package with
# multiple source tarballs, and I don't want to ship a separate package for all
# of these stupid dependencies.
#
# The list of packages below should be kept synchronized with the commands in
# build.sh.

if [ -z "$1" ] ; then
    echo >&2 "usage: $0 <version>

Where the recommended version is of the form YYYY.MM, e.g., 2015.12."
    exit 1
fi

tarbase="modern-xorg-stack-$1"

work="$(mktemp -d)"
origpwd="$(pwd)"
cd "$work"
mkdir src unpacked
cd src

while read sha1 pkg ; do
    wget -q http://xorg.freedesktop.org/releases/individual/$pkg
    echo "$sha1 $(basename $pkg)" |sha1sum --check || exit 1
    (cd ../unpacked && tar xjf ../src/$(basename $pkg))
done <<EOF
3c3a857a117ce48a1947a16860056e77cd494fdf  lib/libICE-1.0.9.tar.bz2
e6d5dab6828dfd296e564518d2ed0a349a25a714  lib/libSM-1.2.2.tar.bz2
6f2aadf8346ee00b7419bd338461c6986e274733  lib/libX11-1.6.3.tar.bz2
d9512d6869e022d4e9c9d33f6d6199eda4ad096b  lib/libXau-1.0.8.tar.bz2
3c09eabb0617c275b5ab09fae021d279a4832cac  lib/libXdmcp-1.1.2.tar.bz2
43abab84101159563e68d9923353cc0b3af44f07  lib/libXext-1.3.3.tar.bz2
e14fa072bd70b30eef47391cac637bdb4de9e8a3  lib/libXfixes-5.0.1.tar.bz2
00fa8883c5297b9bf1a87f37cba9a15f6f026d9d  lib/libXi-1.7.5.tar.bz2
31bf63dfb4fcb82a6db73abe98df87cb50c17176  lib/libXrender-0.9.9.tar.bz2
7fd92a3c865c3c5e1cc724646babc3e1cdc799bc  lib/libXtst-1.2.2.tar.bz2
2d3ae1839d841f568bc481c6116af7d2a9f9ba59  lib/xtrans-1.3.5.tar.bz2
ab605af5da8c98c0c2f8b2c578fed7c864ee996a  proto/fixesproto-5.0.tar.bz2
4eacc1883593d3f0040e410be3afc8483c7d2409  proto/inputproto-2.3.tar.bz2
bc9c0fa7d39edf4ac043e6eeaa771d3e245ac5b2  proto/kbproto-1.0.7.tar.bz2
1f48c4b0004d8b133efd0498e8d88d68d3b9199c  proto/recordproto-1.14.2.tar.bz2
7ae9868a358859fe539482b02414aa15c2d8b1e4  proto/renderproto-0.11.1.tar.bz2
b8d736342dcb73b71584d99a1cb9806d93c25ff8  proto/xextproto-7.3.0.tar.bz2
d62c43e1b3619ab85732e0113eaa2104920730ac  proto/xproto-7.0.28.tar.bz2
7fc486ad0ec54938f8b781cc374218f50eac8b99  xcb/libpthread-stubs-0.3.tar.bz2
28e47aa699d2c2cffed31d1aa2473a9fefe77f17  xcb/libxcb-1.11.1.tar.bz2
608bd60663e223464d38acec0183ddb827776401  xcb/xcb-proto-1.11.tar.bz2
EOF

cd ../unpacked
tar cjf ../"$tarbase".tar.bz2 *

cd "$origpwd"
mv "$work/$tarbase".tar.bz2 .
sha1sum "$tarbase".tar.bz2
rm -rf "$work"
