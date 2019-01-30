#! /bin/bash
# Copyright 2015-2019 Peter Williams and collaborators.
# This file is licensed under a 3-clause BSD license; see LICENSE.txt.

[ "$NJOBS" = '<UNDEFINED>' -o -z "$NJOBS" ] && NJOBS=1
set -ex

export PATH="$PREFIX/qt4/bin:$PATH"

# Pre-build setup

pushd $PREFIX
ln -s xercesc28 include/xercesc

if [ $(uname) = Darwin ] ; then
    src=libxerces-c.28.0.dylib
else
    src=libxerces-c.so.28.0
fi

ln -s $src lib/libxerces-c$SHLIB_EXT
popd

# Ready to configure and make

cmake_args=(
    -DCMAKE_BUILD_TYPE=Release
    -DCMAKE_COLOR_MAKEFILE=OFF
    -DCMAKE_INSTALL_PREFIX=$PREFIX
    -DPGPLOT_INCLUDE_DIRS=$PREFIX/include/pgplot
    -DQT_DBUSXML2CPP_EXECUTABLE=$PREFIX/qt4/bin/qdbusxml2cpp
    -DQT_LIBRARY_DIR=$PREFIX/qt4/lib
    -DQT_MKSPECS_DIR=$PREFIX/qt4/mkspecs
    -DQT_RCC_EXECUTABLE=$PREFIX/qt4/bin/rcc
    -DQWT_INCLUDE_DIRS=$PREFIX/include/qwt5
    -DUseCrashReporter=OFF
)

#cmake_args+=(--debug-trycompile --debug-output)

if [ $(uname) = Darwin ] ; then
    linkflags="-Wl,-rpath,$PREFIX/lib $LDFLAGS"

    cmake_args+=(
	-Darch=darwin64
	-Darchflag=x86_64
	-DCMAKE_Fortran_COMPILER=gfortran
	-DEXTRA_CXX_FLAGS="-arch $OSX_ARCH -stdlib=libc++"
	-DPGPLOT_LIBRARIES="$PREFIX/lib/libpgplot.dylib;$PREFIX/lib/libcpgplot.a"
	# Make sure to get Conda versions of libraries:
	-DLIBXML2_ROOT_DIR=$PREFIX
	-DLIBXSLT_ROOT_DIR=$PREFIX
	-DREADLINE_ROOT_DIR=$PREFIX
    )
else
    linkflags="-Wl,-rpath-link,$PREFIX/lib $LDFLAGS"

    cmake_args+=(
	-DBLAS_LIBRARIES="$PREFIX/lib/libopenblas.so"
	-DLAPACK_LIBRARIES="$PREFIX/lib/libopenblas.so"
	-DPGPLOT_LIBRARIES="$PREFIX/lib/libpgplot.so;$PREFIX/lib/libcpgplot.a"
    )
fi

cmake_args+=(
    -DCMAKE_EXE_LINKER_FLAGS="$linkflags"
    -DCMAKE_MODULE_LINKER_FLAGS="$linkflags"
    -DCMAKE_SHARED_LINKER_FLAGS="$linkflags"
)

cd code
mkdir build
cd build
# helps debugging:
env |sed -e 's/^/export /' -e "s/\([^=]*\)=/\1='/" -e "s/$/'/" |tr '\0' '\n' >ENVIRON.sh
cmake "${cmake_args[@]}" ..
make -j$NJOBS VERBOSE=1

# Post-install tidying

pushd $PREFIX
rm -f casainit.* lib/casa/casainit.* makedefs VERSION
rm -f bin/t* bin/qwtplottertest # tests

# if we keep the compat symlinks, conda thinks we installed these files:
rm -f lib/libxerces-c$SHLIB_EXT include/xercesc

if [ $(uname) = Darwin ] ; then
    rm -rf apps
fi

popd
