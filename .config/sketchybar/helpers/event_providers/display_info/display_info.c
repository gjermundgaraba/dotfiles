#include <ApplicationServices/ApplicationServices.h>
#include <stdio.h>

int main(void) {
  uint32_t max = 16;
  CGDirectDisplayID displays[16];
  uint32_t count = 0;
  CGError err = CGGetActiveDisplayList(max, displays, &count);
  if (err != kCGErrorSuccess) return 1;

  CGDirectDisplayID mainDisplay = CGMainDisplayID();
  int builtinMain = CGDisplayIsBuiltin(mainDisplay) ? 1 : 0;

  printf("builtin_main=%d\n", builtinMain);
  printf("display_count=%u\n", count);
  return 0;
}

