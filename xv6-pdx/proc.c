#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#ifdef CS333_P2
#include "uproc.h"
#endif

#ifdef CS333_P3P4
struct StateLists {
  struct proc* ready;
  struct proc* free;
  struct proc* sleep;
  struct proc* zombie;
  struct proc* running;
  struct proc* embryo;
};
#endif

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
  #ifdef CS333_P3P4
  struct StateLists pLists;
  #endif
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  #ifdef CS333_P3P4
  p = removeFromQueue(&ptable.pLists.free);
  if(p)
    goto found;
  #else
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
  #endif
  release(&ptable.lock);
  return 0;

found:
  #ifdef CS333_P3P4
  assertState(p, UNUSED);
  p->state = EMBRYO;
  addToListFront(&ptable.pLists.embryo, p);
  #else
  p->state = EMBRYO;
  #endif
  p->pid = nextpid++;
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    #ifdef CS333_P3P4
    switchStates(&ptable.pLists.embryo, &ptable.pLists.free, p,
        EMBRYO, UNUSED);
    #else
    p->state = UNUSED;
    #endif
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  #ifdef CS333_P1
  p->start_ticks = ticks;
  #endif
  #ifdef CS333_P2
  p->cpu_ticks_total = 0;
  p->cpu_ticks_in = 0;
  #endif

  return p;
}

// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  #ifdef CS333_P3P4
  ptable.pLists.ready = 0;
  ptable.pLists.free = 0;
  ptable.pLists.sleep = 0;
  ptable.pLists.zombie = 0;
  ptable.pLists.running = 0;
  ptable.pLists.embryo = 0;

  for(int i = 0; i < NPROC; i++){
    addToListFront(&ptable.pLists.free, &ptable.proc[i]);
  }
  #endif
  
  p = allocproc();
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  #ifdef CS333_P2
  p->uid = DEFAULTUID;
  p->gid = DEFAULTGID;
  #endif
  #ifdef CS333_P3P4
  switchToRunnable(&ptable.pLists.embryo, p, EMBRYO);
  #else
  p->state = RUNNABLE;
  #endif
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  
  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  proc->sz = sz;
  switchuvm(proc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
    return -1;

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    #ifdef CS333_P3P4
    switchStates(&ptable.pLists.embryo, &ptable.pLists.free, np,
        EMBRYO, UNUSED);
    #else
    np->state = UNUSED;
    #endif
    return -1;
  }
  np->sz = proc->sz;
  np->parent = proc;
  *np->tf = *proc->tf;
  #ifdef CS333_P2
  np->uid = proc->uid;
  np->gid = proc->gid;
  #endif

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);

  safestrcpy(np->name, proc->name, sizeof(proc->name));
 
  pid = np->pid;

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
  #ifdef CS333_P3P4
  switchToRunnable(&ptable.pLists.embryo, np, EMBRYO);
  #else
  np->state = RUNNABLE;
  #endif
  release(&ptable.lock);
  
  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
#ifndef CS333_P3P4
void
exit(void)
{
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(proc->cwd);
  end_op();
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}
#else
void
exit(void)
{
  int fd;

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(proc->cwd);
  end_op();
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  passChildrenToInit(&ptable.pLists.embryo, proc);
  passChildrenToInit(&ptable.pLists.ready, proc);
  passChildrenToInit(&ptable.pLists.running, proc);
  passChildrenToInit(&ptable.pLists.sleep, proc);
  passChildrenToInit(&ptable.pLists.zombie, proc);

  // Jump into the scheduler, never to return.
  switchStates(&ptable.pLists.running, &ptable.pLists.zombie, proc, RUNNING,
      ZOMBIE);
  sched();
  panic("zombie exit");
}
#endif

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
#ifndef CS333_P3P4
int
wait(void)
{
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->state = UNUSED;
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
#else
int
wait(void)
{
  struct proc *p = 0;
  int havekids, pid;

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    p = findChildren(&ptable.pLists.zombie, proc);
    if(p){
      pid = p->pid;
      kfree(p->kstack);
      p->kstack = 0;
      freevm(p->pgdir);
      switchStates(&ptable.pLists.zombie, &ptable.pLists.free, p,
          ZOMBIE, UNUSED);
      p->pid = 0;
      p->parent = 0;
      p->name[0] = 0;
      p->killed = 0;
      release(&ptable.lock);
      return pid;
    }
    else{
      p = findChildren(&ptable.pLists.embryo, proc);
      if(!p)
        p = findChildren(&ptable.pLists.ready, proc);
      if(!p)
        p = findChildren(&ptable.pLists.sleep, proc);
      if(!p)
        p = findChildren(&ptable.pLists.running, proc);
      if(p)
        havekids = 1;
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
#endif

// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
#ifndef CS333_P3P4
// original xv6 scheduler. Use if CS333_P3P4 NOT defined.
void
scheduler(void)
{
  struct proc *p;
  int idle;  // for checking if processor is idle

  for(;;){
    // Enable interrupts on this processor.
    sti();

    idle = 1;  // assume idle unless we schedule a process
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      idle = 0;  // not idle this timeslice
      proc = p;
      switchuvm(p);
      p->state = RUNNING;
      #ifdef CS333_P2
      p->cpu_ticks_in = ticks;
      #endif
      swtch(&cpu->scheduler, proc->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
    // if idle, wait for next interrupt
    if (idle) {
      sti();
      hlt();
    }
  }
}
#else
void
scheduler(void)
{
  struct proc *p;
  int idle;  // for checking if processor is idle

  for(;;){
    // Enable interrupts on this processor.
    sti();

    idle = 1;  // assume idle unless we schedule a process
    acquire(&ptable.lock);
    p = removeFromQueue(&ptable.pLists.ready);
    if(p){

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      idle = 0;  // not idle this timeslice
      proc = p;
      switchuvm(p);
      assertState(p, RUNNABLE);
      p->state = RUNNING;
      addToListFront(&ptable.pLists.running, p);
      #ifdef CS333_P2
      p->cpu_ticks_in = ticks;
      #endif
      swtch(&cpu->scheduler, proc->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
  }
  // if idle, wait for next interrupt
  if (idle) {
    sti();
    hlt();
  }
}
#endif

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
#ifndef CS333_P3P4
void
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = cpu->intena;
  #ifdef CS333_P2
  proc->cpu_ticks_total += ticks-proc->cpu_ticks_in;
  #endif
  swtch(&proc->context, cpu->scheduler);
  cpu->intena = intena;
}
#else
void
sched(void)
{
  int intena;
  
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = cpu->intena;
  #ifdef CS333_P2
  proc->cpu_ticks_total += ticks-proc->cpu_ticks_in;
  #endif
  swtch(&proc->context, cpu->scheduler);
  cpu->intena = intena;
}
#endif

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  #ifdef CS333_P3P4
  switchToRunnable(&ptable.pLists.running, proc, RUNNING);
  #else
  proc->state = RUNNABLE;
  #endif
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }
  
  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
// 2016/12/28: ticklock removed from xv6. sleep() changed to
// accept a NULL lock to accommodate.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
    panic("sleep");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){
    acquire(&ptable.lock);
    if (lk) release(lk);
  }

  // Go to sleep.
  proc->chan = chan;
  #ifdef CS333_P3P4
  switchStates(&ptable.pLists.running, &ptable.pLists.sleep, proc,
      RUNNING, SLEEPING);
  #else
  proc->state = SLEEPING;
  #endif
  sched();

  // Tidy up.
  proc->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){ 
    release(&ptable.lock);
    if (lk) acquire(lk);
  }
}

#ifndef CS333_P3P4
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
#else
static void
wakeup1(void *chan)
{
  struct proc *current;
  struct proc *temp;

  current = ptable.pLists.sleep;
  while(current){
    if(current->chan == chan){
      temp = current;
      current = current->next;
      switchToRunnable(&ptable.pLists.sleep, temp, SLEEPING);
    }
    else{
      current = current->next;
    }
  }
  return;
}
#endif

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
#ifndef CS333_P3P4
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
#else
int
kill(int pid)
{
  struct proc *p = 0;

  acquire(&ptable.lock);
  p = findPid(&ptable.pLists.embryo, pid);
  if(!p)
    p = findPid(&ptable.pLists.ready, pid);
  if(!p)
    p = findPid(&ptable.pLists.running, pid);
  if(!p)
    p = findPid(&ptable.pLists.sleep, pid);
  if(!p)
    p = findPid(&ptable.pLists.zombie, pid);
  if(p){
    p->killed = 1;
    if(p->state == SLEEPING)
      switchToRunnable(&ptable.pLists.sleep, p, SLEEPING);
    release(&ptable.lock);
    return 0;
  }
  release(&ptable.lock);
  return -1;
}
#endif

static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
};

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  #ifdef CS333_P2
  cprintf("\nPID\tName\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\t PCs\n");
  #elif defined CS333_P1
  cprintf("\nPID\tState\tName\tElapsed\t PCs\n");
  #endif
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    #ifdef CS333_P2
    int ppid;

    if(!p->parent)
      ppid = 1;
    else
      ppid = p->parent->pid;

    cprintf("%d\t%s\t%d\t%d\t%d\t", p->pid, p->name, p->uid, p->gid, ppid);
    calcelapsedtime(ticks-p->start_ticks);
    calcelapsedtime(p->cpu_ticks_total);
    cprintf("%s\t%d\t", state, p->sz);
    #elif defined CS333_P1
    cprintf("%d\t%s\t%s\t", p->pid, state, p->name);
    calcelapsedtime(ticks-p->start_ticks);
    #else
    cprintf("%d %s %s", p->pid, state, p->name);
    #endif
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}

// Determines the seconds elapsed for a running process to the thousandth of a
// second and prints the result
#ifdef CS333_P1
void
calcelapsedtime(int ticks_in)
{
  int seconds = (ticks_in)/1000;
  int milliseconds = (ticks_in)%1000;

  if(milliseconds < 10)
    cprintf("%d.00%d\t", seconds, milliseconds);
  else if(milliseconds < 100)
    cprintf("%d.0%d\t", seconds, milliseconds);
  else
    cprintf("%d.%d\t", seconds, milliseconds);
}
#endif

// Copies active processes in the ptable to the uproc table passed in
#ifdef CS333_P2
int
getprocs(uint max, struct uproc* table)
{
  int uproc_table_index = 0;

  for(int i = 0; i < NPROC; i++){
    if(ptable.proc[i].state == SLEEPING || ptable.proc[i].state == RUNNING ||
        ptable.proc[i].state == RUNNABLE){
      if(uproc_table_index < max){
        table[uproc_table_index].pid = ptable.proc[i].pid;
        table[uproc_table_index].uid = ptable.proc[i].uid;
        table[uproc_table_index].gid = ptable.proc[i].gid;
        table[uproc_table_index].elapsed_ticks =
            ticks-ptable.proc[i].start_ticks;
        table[uproc_table_index].CPU_total_ticks =
            ptable.proc[i].cpu_ticks_total;
        safestrcpy(table[uproc_table_index].state,
            states[ptable.proc[i].state], STRMAX);
        table[uproc_table_index].size = ptable.proc[i].sz;
        safestrcpy(table[uproc_table_index].name, ptable.proc[i].name, STRMAX);

        if(!ptable.proc[i].parent)
          table[uproc_table_index].ppid = 1;
        else
          table[uproc_table_index].ppid = ptable.proc[i].parent->pid;
        uproc_table_index++;
      }
    }
  }
  return uproc_table_index;
}
#endif

#ifdef CS333_P3P4
// Adds a process to the head of the list passed in
void
addToListFront(struct proc** sList, struct proc* p)
{
  p->next = *sList;
  *sList = p;
  return;
}

// Adds a process to the rear of the list passed in
void
addToListRear(struct proc** sList, struct proc* p)
{
  if(!*sList){
    *sList = p;
    p->next = 0;
  }
  else{
    struct proc *temp = *sList;

    while(temp->next){
      temp = temp->next;
    }

    temp->next = p;
    p->next = 0;
  }
  return;
}

// Checks if a process is in the given list, and if so, removes it
void
removeFromStateList(struct proc** sList, struct proc* p)
{
  struct proc *current = *sList;
  struct proc *previous = *sList;

  if(!(*sList))
    panic("Cannot remove the process from an empty list!");
  if(*sList == p){
    *sList = (*sList)->next;
    p->next = 0;
    return;
  }
  current = current->next;
  while(current){
    if(current == p){
      previous->next = current->next;
      p->next = 0;
      return;
    }
    else{
      previous = current;
      current = current->next;
    }
  }
  cprintf("Process %s is not in the list!", p->name);
  panic("Cannot remove the process from the list!");
}

// Removes a process from the list passed in and
// returns it to the calling routine
struct proc*
removeFromQueue(struct proc** sList)
{
  if(!*sList)
    return 0;
  else{
    struct proc *temp = *sList;
    *sList = (*sList)->next;
    temp->next = 0;
    return temp;
  }
}

// Checks if a process is in the state given and returns, otherwise panic
void
assertState(struct proc* p, int state)
{
  if(p->state != state){
    cprintf("The state of %s does not match %s!", p->state, state);
    panic("States do not match!");
  }
  return;
}

// Asserts that a process is in a state, removes it from that list,
// updates its state, and adds it to the new list
void
switchStates(struct proc** list_to_remove, struct proc** list_to_add,
    struct proc* p, int check_state, int add_state)
{
  assertState(p, check_state);
  removeFromStateList(list_to_remove, p);
  p->state = add_state;
  addToListFront(list_to_add, p);
  return;
}

// Removes a process from the list passed in and adds it to the ready list
void
switchToRunnable(struct proc** sList, struct proc* p, int check_state)
{ 
  assertState(p, check_state);
  removeFromStateList(sList, p);
  p->state = RUNNABLE;
  addToListRear(&ptable.pLists.ready, p);
  return;
}

// Traverses the list passed in to find children of process p, and if found,
// sets their parent to initproc
void
passChildrenToInit(struct proc** sList, struct proc* p)
{
  struct proc *current = *sList;

  while(current){
    if(current->parent == p){
      current->parent = initproc;
      if(&ptable.pLists.zombie == sList)
        wakeup1(initproc);
    }
    current = current->next;
  }
  return;
}

// Searches a list for a child of process p, and returns that process if found.
// Otherwise return null
struct proc*
findChildren(struct proc** sList, struct proc* p)
{
  struct proc *current = *sList;

  while(current){
    if(current->parent == p)
      return current;
    else
      current = current->next;
  }
  return 0;
}

// Searches a list for a process with the passed in pid, and returns that
// process if found
struct proc*
findPid(struct proc** sList, int pid)
{
  struct proc *current;

  if(!*sList)
    return 0;
  current = *sList;
  while(current){
    if(current->pid == pid)
      return current;
    else
      current = current->next;
  }
  return 0;
}

// Prints all processes in the ready list by their PID
void
printReadyList(void)
{
  cprintf("Ready List Processes:\n");
  printProcesses(ptable.pLists.ready);
  return;
}

// Prints the number of unused processes
void
printFree(void)
{
  int count = 0;
  struct proc *current = ptable.pLists.free;

  while(current){
    current = current->next;
    count++;
  }

  cprintf("Free List Size: %d processes\n", count);
}

// Prints all processes in the sleep list by their PID
void
printSleepList(void)
{
  cprintf("Sleep List Processes:\n");
  printProcesses(ptable.pLists.sleep);
  return;
}

// Prints all processes by their PID and their parent PID
void
printZombieList(void)
{
  int ppid;
  struct proc *current = ptable.pLists.zombie;

  cprintf("Zombie List Processes:\n");

  if(!current){
    cprintf("There are no processes in the list\n");
    return;
  }
  while(current){
    if(!current->parent)
      ppid = 1;
    else
      ppid = current->parent->pid;
    cprintf("(%d, %d)", current->pid, ppid);
    current = current->next;
    if(current)
      cprintf("->");
  }
  cprintf("\n");
  return;

}

// Traverses the list passed in and prints corresponding processes by PID
void
printProcesses(struct proc* sList)
{
  struct proc *current = sList;

  if(!current){
    cprintf("There are no processes in the list\n");
    return;
  }
  while(current){
    cprintf("%d", current->pid);
    current = current->next;
    if(current)
      cprintf("->");
  }
  cprintf("\n");
  return;
}
#endif
