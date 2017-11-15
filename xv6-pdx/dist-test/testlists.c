#ifdef CS333_P3P4
#include "types.h"
#include "user.h"

int
main(void)
{

  //for(int i = 0; i < 32; i++){
    int pid = fork();

    if(pid == 0){
      while(1){
        sleep(5000);
        exit();
      }
    }
    wait();
  //}
  exit();
}
#endif
