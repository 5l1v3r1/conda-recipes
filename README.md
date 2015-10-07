conda-recipes
=============

This repository contains recipes for building various packages in the [Conda]
package manager. Most of them build up to providing support for the [Gtk+ 3]
graphical toolkit. Builds are only tested on Linux.

[Conda]: http://conda.pydata.org/
[Gtk+ 3]: http://www.gtk.org/

I upload built packages to [my personal anaconda.org channel]. You can
configure your [Anaconda] installation to fetch packages from it with:

```
conda config --add channels http://conda.anaconda.org/pkgw/channel/main
```

[my personal anaconda.org channel]: https://anaconda.org/pkgw/


Docs for Packagers and Builders
===============================

This repository also includes some notes on packaging software for the [Conda]
system and how to build those packages.

* [Reliably building Anaconda packages](how-it-all-works.md)


License
=======

These files are licensed under a 3-clause BSD license, for compatibility with
the main [conda-recipes] repository. See the file [LICENSE.txt](LICENSE.txt)
for the details.

[conda-recipes]: https://github.com/conda/conda-recipes


Copyright Notice
================

Copyright 2014–2015 Peter Williams

This file is free documentation; the copyright holder gives unlimited
permission to copy, distribute, and modify it.
