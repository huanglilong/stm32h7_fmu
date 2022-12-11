Ref:
  1. https://nuttx.apache.org/docs/latest/guides/cpp_cmake.html
  2. https://github.com/apache/incubator-nuttx/issues/5530

Build:
  1. How to build Nutxx

    $ git clone https://github.com/huanglilong/stm32h7_fmu

    $ git submodule update --init --recursive

    $ cmake -B build;cmake --build build

  2. How to update firmware

    $ st-flash write ./build/fmu_nuttx.bin 0x8000000

  3. Testing with nsh

    $ reset MCU
    
    $ screen /dev/ttyACM0 115200 8N1

    ![nsh testing](figs/nsh.png)
