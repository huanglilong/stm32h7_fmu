Ref:
  1. https://nuttx.apache.org/docs/latest/guides/cpp_cmake.html
  2. https://github.com/apache/incubator-nuttx/issues/5530

Build:
  1. How to build Nutxx

    $ cd nuttx/nuttx

    $ ./tools/configure.sh -l stm32f4discovery:nsh

    $ make

    $ make export


  2. How to build apps

    $ cd hellocpp

    $ mkdir build

    $ cd build

    $ cmake ..

    $ make
