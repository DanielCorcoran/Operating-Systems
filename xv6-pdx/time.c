#ifdef CS333_P2
#include "types.h"
#include "user.h"
int
main(int argc, char* argv[])
{
  int start_ticks = uptime();
  int total_ticks;
  int pid = fork();

  if(pid == 0){
    exec(argv[1],argv+1);
    exit();
  }
  wait();
  total_ticks = uptime()-start_ticks;

  if(!argv[1])
    printf(1, "ran in ");
  else
    printf(1, "%s ran in ", argv[1]);

  int seconds = (total_ticks)/1000;
  int milliseconds = (total_ticks)%1000;

  if(milliseconds < 10)
    printf(1, "%d.00%d", seconds, milliseconds);
  else if(milliseconds < 100)
    printf(1, "%d.0%d", seconds, milliseconds);
  else
    printf(1, "%d.%d", seconds, milliseconds);

  printf(1, " seconds.\n");

  exit();
}

#endif
