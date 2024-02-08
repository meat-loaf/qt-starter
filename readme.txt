This is a basic project to help get up and running with modern versions of QT,
  hopefully without too much trouble. It expects a typical unix-like build environment,
  and assumes the QT library headers are placed in /usr/include. Simply running `make`
  should yield a very basic executable that constructs an empty class which inherits
  from QMainWindow. The makefile is expected to be used with GNU make.
Adding sources to an ongoing project is done manually: see the UI_SOURCE_BASE_RAW
  (for QT sources with headers that must be run through the MOC) and SOURCES_RAW
  (for everything else) variables in the makefile. Make's wildcards are not used to
  automatically gather sources for you.
If you wish to have a new subdirectory under `src' which will contain cpp files, you
  must add it to the BUILD_SUBDIRS variable as well, as make must know about it to
  build the generated files hierarchy for you. Adding nested subdirectories will
  work as expected.
The current setup will have two generated hierarchies, one for debug builds and one for
  non-debug builds (in subdirectories .debug and .build respectively). There are a handful
  of phony targets for executing each: the `debug' target will invoke gdb on the resultant
  binary, while `run' and `rundebug' will execute a nondebug and a debug build respectively.
  `debugbuild' will simply build a debug target (the default target, or running `make' with
  no other arguments, will build a non debug-target).
The makefile has some basic support for switching between QT versions with the QT_VER variable.
  I'm not sure how flexible this would ultimately end up being, but since this I wanted this to
  be more of a useful, baseline example I didn't want it to get too involved.
Why something like this over either of QT's supported build systems, or something else? Make
  offers a decent amount of control; I didn't personally like qmake so much (for QT5), and I
  simply loathe cmake (for QT6), so I went along and whipped something up myself. Meson seems
  to have decent QT support, and I would probably suggest that over Make these days, but for
  personal projects where I don't really have to justify myself so much, I tend to like make
  for several completely opinionated and non-technical resons.
