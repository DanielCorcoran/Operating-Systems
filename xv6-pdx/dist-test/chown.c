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

  int owner = atoi(argv[1]);
  char *path = argv[2];

  if(owner < 0 || owner > 32767){
    printf(2, "The value of user is not valid");
    exit();
  }

  if(chown(path, owner) == -1){
    printf(2, "The path is not valid");
    exit();
  }

  exit();
}

#endif
