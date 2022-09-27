#include "hello_nuttx.h"

extern "C" int main(int argc, char** argv);

int main(int argc, char** argv) {
  HelloNuttx test_nuttx;
  return test_nuttx.GetTest();
}
