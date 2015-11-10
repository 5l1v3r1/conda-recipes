#! /bin/bash
# Copyright 2015 Peter Williams and collaborators.
# This file is licensed under a 3-clause BSD license; see LICENSE.txt.

set -e

cmake_args="
-DBLAS_LIBRARIES=$PREFIX/lib/libcblas.a;$PREFIX/lib/libatlas.a
-DCMAKE_BUILD_TYPE=Release
-DCMAKE_C_COMPILER=/usr/bin/gcc
-DCMAKE_COLOR_MAKEFILE=OFF
-DCMAKE_CXX_COMPILER=/opt/rh/devtoolset-2/root/usr/bin/g++
-DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath-link,$PREFIX/lib
-DCMAKE_Fortran_COMPILER=/usr/bin/gfortran
-DCMAKE_INSTALL_PREFIX=$PREFIX
-DCMAKE_MODULE_LINKER_FLAGS=-Wl,-rpath-link,$PREFIX/lib
-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-rpath-link,$PREFIX/lib
-DCMAKE_STATIC_LINKER_FLAGS=-L$PREFIX/lib
-DPGPLOT_INCLUDE_DIRS=$PREFIX/include/pgplot
-DPGPLOT_LIBRARIES=$PREFIX/lib/libpgplot.so;$PREFIX/lib/libcpgplot.a
-DQWT_INCLUDE_DIRS=$PREFIX/include/qwt5
"
#cmake_args="$cmake_args --debug-trycompile --debug-output"
jflag=-j4

cd code
mkdir build
cd build
cmake $cmake_args ..
make $jflag VERBOSE=1

cd $PREFIX
rm -f casainit.* lib/casa/casainit.* makedefs
rm -f bin/t* bin/qwtplottertest # tests

# casabrowser as installed is a broken + pointless wrapper script around
# qcasabrowser. Shockingly, all other binaries appear to be usable as
# installed.
rm -f bin/casabrowser
ln -s qcasabrowser bin/casabrowser
