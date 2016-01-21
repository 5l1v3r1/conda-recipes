#! /bin/bash
# Copyright 2014-2016 Peter Williams and collaborators.
# This file is licensed under a 3-clause BSD license; see LICENSE.txt.

# This script builds a mega-tarball of TeX packages. This is necessary because
# Conda doesn't let us define a package with multiple source tarballs, and I
# don't want to ship a separate package for all of these stupid dependencies.

if [ -z "$1" ] ; then
    echo >&2 "usage: $0 <version>

Where the recommended version is of the form YYYYMMDD, e.g., 20160121"
    exit 1
fi

tarbase="texlive-selected-$1"

work="$(mktemp -d)"
origpwd="$(pwd)"
cd "$work"
mkdir -p src unpacked/texmf-dist
cd src

while read pkg options ; do
    echo $pkg
    wget -q http://mirrors.ctan.org/systems/texlive/tlnet/archive/$pkg.tar.xz
    ###echo "$sha1 $(basename $pkg)" |sha1sum --check || exit 1

    case ",$options," in
	*,updir,*) dir=../unpacked src=../src ;;
	*) dir=../unpacked/texmf-dist src=../../src ;;
    esac

    (cd $dir && tar xJf $src/$pkg.tar.xz)
done <<EOF
amsfonts none
amsmath none
cm none
cm-super none
dehyph-exptl none
ec none
emulateapj none
epsf none
etex none
etex-pkg none
etoolbox none
graphics none
hyperref none
hyph-utf8 none
hyphen-ancientgreek none
hyphen-base none
hyphen-german none
hyphen-greek none
ifluatex none
ifxetex none
knuth-lib none
latex none
latex-fonts none
latexconfig none
lm none
microtype none
natbib none
oberdiek none
pdftex updir
plain none
revtex none
revtex4 none
ruhyphen none
texlive.infra updir
textcase none
tools none
ukrhyph none
url none
xetex-def none
zapfding none
EOF

cd ../unpacked
rm -rf texmf-dist/fonts/source readme-html.dir readme-txt.dir
rm -f index.html README README.usergroups
tar cjf ../"$tarbase".tar.bz2 *

cd "$origpwd"
mv "$work/$tarbase".tar.bz2 .
sha256sum "$tarbase".tar.bz2
rm -rf "$work"
