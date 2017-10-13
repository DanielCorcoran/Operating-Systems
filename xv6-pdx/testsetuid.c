#ifdef CS333_P2
#include "types.h"
#include "user.h"

int
main(int argc, char *argv[])
{
  
  uint uid, gid, ppid;

  uid = getuid();
  printf(1, "Current UID is: %d\n", uid);
  printf(1, "Setting UID to 100\n");
  if(setuid(100) == -1) {
    printf(1, "Setting UID failed. Test FAILED.\n");
    exit();
  }
  uid = getuid();
  printf(1, "Current UID is: %d\n", uid);
  printf(1, "Setting UID to 32,768\n");
  if(setuid(32768) == 0) {
    printf(1, "Setting UID succeeded. Set should fail. Test FAILED.\n");
    exit();
  }
  else
    printf(1, "Not allowed to set UID to 32,768. PASSED.\n");
  printf(1, "Setting UID to -1\n");
  if(setuid(-1) == 0) {
    printf(1, "Setting UID succeeded.  Set should fail. Test FAILED.\n");
    exit();
  }
  else
    printf(1, "Not allowed to set UID to -1. PASSED.\n");

  gid = getgid();
  printf(1, "Current GID is: %d\n", gid);
  printf(1, "Setting GID to 100\n");
  if(setgid(100) == -1) {
    printf(1, "Setting GID failed. Test FAILED.\n");
    exit();
  }
  gid = getgid();
  printf(1, "Current GID is: %d\n", gid);
  printf(1, "Setting GID to 32,768\n");
  if(setgid(32768) == 0) {
    printf(1, "Setting GID succeeded. Set should fail. Test FAILED.\n");
    exit();
  }
  else
    printf(1, "Not allowed to set GID to 32,768. PASSED.\n");
  printf(1, "Setting GID to -1\n");
  if(setgid(-1) == 0) {
    printf(1, "Setting GID succeeded.  Set should fail. Test FAILED.\n");
    exit();
  }
  else
    printf(1, "Not allowed to set GID to -1. PASSED.\n");
  
  ppid = getppid();
  printf(1, "My process ID is: %d\n", getpid());
  printf(1, "My parent process ID is: %d\n", ppid);
  printf(1, "Done!\n");

  exit();
}
#endif
