#include <nuttx/config.h>
#include "hello_world.h"

extern "C" {
int hellocpp_main(void) {
  CHelloWorld* pHelloWorld = new CHelloWorld();
  pHelloWorld->HelloWorld();

  CHelloWorld helloWorld;
  helloWorld.HelloWorld();

  delete pHelloWorld;
  return 0;
}
}
