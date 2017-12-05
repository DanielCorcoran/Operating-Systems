#ifdef CS333_P5
#include "types.h"
#include "user.h"

int
main(int argc, char *argv[])
{
  if(argc != 3){
    printf(2, "Wrong number of arguments!\n");
    exit();
  }

  int mode = atoo(argv[1]);
  char *path = argv[2];

  if(mode < 0 || mode > 1023){
    printf(2, "The value of mode is not valid");
    exit();
  }

  if(chmod(path, mode) == -1){
    printf(2, "The path is not valid");
    exit();
  }

  exit();
}

#endif
