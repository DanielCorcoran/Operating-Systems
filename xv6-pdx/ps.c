#ifdef CS333_P2
#include "types.h"
#include "user.h"
#include "uproc.h"
int
main(void)
{
  int MAX = 64;
  int running_procs;

  struct uproc* table = malloc(sizeof(struct uproc)*MAX);

  running_procs = getprocs(MAX, table);
  if(running_procs == 0) {
    printf(2, "Error: ps call failed.  %s at line %d\n", __FILE__, __LINE__);
    exit();
  }

  printf(1, "PID\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\tName\n");
  for(int i = 0; i < running_procs; i++){
    printf(1, "%d\t%d\t%d\t%d\t", table[i].pid,
        table[i].uid, table[i].gid, table[i].ppid);
    calcelapsedtime(table[i].elapsed_ticks);
    calcelapsedtime(table[i].CPU_total_ticks);
    printf(1, "%s\t%d\t%s\n", table[i].state, table[i].size, table[i].name);
  }

  exit();
}

// Determines the seconds elapsed for a running process to the thousandth of a
// second and prints the result
void
calcelapsedtime(int ticks_in)
{
  int seconds = (ticks_in)/1000;
  int milliseconds = (ticks_in)%1000;

  if(milliseconds < 10)
    printf(2, "%d.00%d\t", seconds, milliseconds);
  else if(milliseconds < 100)
    printf(2, "%d.0%d\t", seconds, milliseconds);
  else
    printf(2, "%d.%d\t", seconds, milliseconds);
}
#endif
