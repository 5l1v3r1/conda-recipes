#! /bin/bash
# Copyright 2015 Peter Williams and collaborators.
# This file is licensed under a 3-clause BSD license; see LICENSE.txt.

configure_args=(
--prefix=$PREFIX
--enable-fortran
--with-cfitsiolib=$PREFIX/lib
--with-cfitsioinc=$PREFIX/include
--with-pgplotlib=$PREFIX/lib
--with-pgplotinc=$PREFIX/include/pgplot
)

[ "$NJOBS" = '<UNDEFINED>' ] && NJOBS=1
set -e

if [ -n "$OSX_ARCH" ] ; then
    export MACOSX_DEPLOYMENT_TARGET=10.6
    sdk=/
    export F77=gfortran-4.2
    export CFLAGS="$CFLAGS -isysroot $sdk"
    export FFLAGS="$FFLAGS -isysroot $sdk"
    export LDFLAGS="$LDFLAGS -Wl,-syslibroot,$sdk"
fi

# Get newer compilers that use libgfortran.so.3:
export PATH=/opt/rh/devtoolset-2/root/usr/bin:$PATH

./configure ${configure_args[@]} || { cat config.log ; exit 1 ; }
make # note: Makefile is not parallel-safe
make install

cd $PREFIX
rm -rf share/doc
