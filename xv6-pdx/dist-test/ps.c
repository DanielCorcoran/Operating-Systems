#ifdef CS333_P2
#include "types.h"
#include "user.h"
#include "uproc.h"

#define UPROC_TABLE_MAX 64

int
main(void)
{
  int running_procs;

  struct uproc* table = malloc(sizeof(struct uproc)*UPROC_TABLE_MAX);

  running_procs = getprocs(UPROC_TABLE_MAX, table);
  if(running_procs == 0) {
    printf(2, "Error: ps call failed.  %s at line %d\n", __FILE__, __LINE__);
    exit();
  }

  #ifdef CS333_P3P4
  printf(1, "PID\tName\tUID\tGID\tPPID\tPrio\tElapsed\tCPU\tState\tSize\n");
  for(int i = 0; i < running_procs; i++){
    printf(1, "%d\t%s\t%d\t%d\t%d\t%d\t", table[i].pid, table[i].name,
        table[i].uid, table[i].gid, table[i].ppid, table[i].priority);
    calcelapsedtime(table[i].elapsed_ticks);
    calcelapsedtime(table[i].CPU_total_ticks);
    printf(1, "%s\t%d\n", table[i].state, table[i].size);
  }
  #else
  printf(1, "PID\tName\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\n");
  for(int i = 0; i < running_procs; i++){
    printf(1, "%d\t%s\t%d\t%d\t%d\t", table[i].pid, table[i].name,
        table[i].uid, table[i].gid, table[i].ppid);
    calcelapsedtime(table[i].elapsed_ticks);
    calcelapsedtime(table[i].CPU_total_ticks);
    printf(1, "%s\t%d\n", table[i].state, table[i].size);
  }
  #endif

  free(table);
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
    printf(1, "%d.00%d\t", seconds, milliseconds);
  else if(milliseconds < 100)
    printf(1, "%d.0%d\t", seconds, milliseconds);
  else
    printf(1, "%d.%d\t", seconds, milliseconds);
}
#endif
