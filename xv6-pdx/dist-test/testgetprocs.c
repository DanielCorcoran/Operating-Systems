#ifdef CS333_P2
#include "types.h"
#include "user.h"
#include "uproc.h"

int
main(void)
{
  int table_size[] = {1, 16, 64, 72};
  int MAXCOUNT = 4;
  int running_procs;

  for(int i = 0; i < MAXCOUNT; i++){
    struct uproc* table = malloc(sizeof(struct uproc)*table_size[i]);

    for(int j = 0; j < 72; j++){
      int pid = fork();

      if(pid == 0){
        sleep(100000);
        exit();
      }
    }

    running_procs = getprocs(table_size[i], table);
    if(running_procs == 0) {
      printf(2, "Error: ps call failed.  %s at line %d\n", __FILE__, __LINE__);
      exit();
    }

    printf(1, "PID\tName\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\n");
    for(int j = 0; j < running_procs; j++){
      printf(1, "%d\t%s\t%d\t%d\t%d\t", table[j].pid, table[j].name,
          table[j].uid, table[j].gid, table[j].ppid);
      calcelapsedtime(table[j].elapsed_ticks);
      calcelapsedtime(table[j].CPU_total_ticks);
      printf(1, "%s\t%d\n", table[j].state, table[j].size);
    }
    printf(1, "\n\n");
    free(table);
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
    printf(1, "%d.00%d\t", seconds, milliseconds);
  else if(milliseconds < 100)
    printf(1, "%d.0%d\t", seconds, milliseconds);
  else
    printf(1, "%d.%d\t", seconds, milliseconds);
}
#endif
