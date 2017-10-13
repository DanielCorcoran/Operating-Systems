
_testgetprocs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#include "uproc.h"

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 38             	sub    $0x38,%esp
  int table_size[] = {1, 16, 64, 72};
  14:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
  1b:	c7 45 c0 10 00 00 00 	movl   $0x10,-0x40(%ebp)
  22:	c7 45 c4 40 00 00 00 	movl   $0x40,-0x3c(%ebp)
  29:	c7 45 c8 48 00 00 00 	movl   $0x48,-0x38(%ebp)
  int MAXCOUNT = 4;
  30:	c7 45 d8 04 00 00 00 	movl   $0x4,-0x28(%ebp)
  int running_procs;

  for(int i = 0; i < MAXCOUNT; i++){
  37:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  3e:	e9 98 01 00 00       	jmp    1db <main+0x1db>
    struct uproc* table = malloc(sizeof(struct uproc)*table_size[i]);
  43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  46:	8b 44 85 bc          	mov    -0x44(%ebp,%eax,4),%eax
  4a:	6b c0 5c             	imul   $0x5c,%eax,%eax
  4d:	83 ec 0c             	sub    $0xc,%esp
  50:	50                   	push   %eax
  51:	e8 54 09 00 00       	call   9aa <malloc>
  56:	83 c4 10             	add    $0x10,%esp
  59:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    for(int j = 0; j < 72; j++){
  5c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  63:	eb 27                	jmp    8c <main+0x8c>
      int pid = fork();
  65:	e8 ae 04 00 00       	call   518 <fork>
  6a:	89 45 d0             	mov    %eax,-0x30(%ebp)

      if(pid == 0){
  6d:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  71:	75 15                	jne    88 <main+0x88>
        sleep(100000);
  73:	83 ec 0c             	sub    $0xc,%esp
  76:	68 a0 86 01 00       	push   $0x186a0
  7b:	e8 30 05 00 00       	call   5b0 <sleep>
  80:	83 c4 10             	add    $0x10,%esp
        exit();
  83:	e8 98 04 00 00       	call   520 <exit>
  int running_procs;

  for(int i = 0; i < MAXCOUNT; i++){
    struct uproc* table = malloc(sizeof(struct uproc)*table_size[i]);

    for(int j = 0; j < 72; j++){
  88:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  8c:	83 7d e0 47          	cmpl   $0x47,-0x20(%ebp)
  90:	7e d3                	jle    65 <main+0x65>
        sleep(100000);
        exit();
      }
    }

    running_procs = getprocs(table_size[i], table);
  92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  95:	8b 44 85 bc          	mov    -0x44(%ebp,%eax,4),%eax
  99:	83 ec 08             	sub    $0x8,%esp
  9c:	ff 75 d4             	pushl  -0x2c(%ebp)
  9f:	50                   	push   %eax
  a0:	e8 53 05 00 00       	call   5f8 <getprocs>
  a5:	83 c4 10             	add    $0x10,%esp
  a8:	89 45 cc             	mov    %eax,-0x34(%ebp)
    if(running_procs == 0) {
  ab:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  af:	75 1b                	jne    cc <main+0xcc>
      printf(2, "Error: ps call failed.  %s at line %d\n", __FILE__, __LINE__);
  b1:	6a 1b                	push   $0x1b
  b3:	68 90 0a 00 00       	push   $0xa90
  b8:	68 a0 0a 00 00       	push   $0xaa0
  bd:	6a 02                	push   $0x2
  bf:	e8 13 06 00 00       	call   6d7 <printf>
  c4:	83 c4 10             	add    $0x10,%esp
      exit();
  c7:	e8 54 04 00 00       	call   520 <exit>
    }

    printf(1, "PID\tName\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\n");
  cc:	83 ec 08             	sub    $0x8,%esp
  cf:	68 c8 0a 00 00       	push   $0xac8
  d4:	6a 01                	push   $0x1
  d6:	e8 fc 05 00 00       	call   6d7 <printf>
  db:	83 c4 10             	add    $0x10,%esp
    for(int j = 0; j < running_procs; j++){
  de:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  e5:	e9 c1 00 00 00       	jmp    1ab <main+0x1ab>
      printf(1, "%d\t%s\t%d\t%d\t%d\t", table[j].pid, table[j].name,
          table[j].uid, table[j].gid, table[j].ppid);
  ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  ed:	6b d0 5c             	imul   $0x5c,%eax,%edx
  f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  f3:	01 d0                	add    %edx,%eax
      exit();
    }

    printf(1, "PID\tName\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\n");
    for(int j = 0; j < running_procs; j++){
      printf(1, "%d\t%s\t%d\t%d\t%d\t", table[j].pid, table[j].name,
  f5:	8b 58 0c             	mov    0xc(%eax),%ebx
          table[j].uid, table[j].gid, table[j].ppid);
  f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  fb:	6b d0 5c             	imul   $0x5c,%eax,%edx
  fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 101:	01 d0                	add    %edx,%eax
      exit();
    }

    printf(1, "PID\tName\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\n");
    for(int j = 0; j < running_procs; j++){
      printf(1, "%d\t%s\t%d\t%d\t%d\t", table[j].pid, table[j].name,
 103:	8b 48 08             	mov    0x8(%eax),%ecx
          table[j].uid, table[j].gid, table[j].ppid);
 106:	8b 45 dc             	mov    -0x24(%ebp),%eax
 109:	6b d0 5c             	imul   $0x5c,%eax,%edx
 10c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 10f:	01 d0                	add    %edx,%eax
      exit();
    }

    printf(1, "PID\tName\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\n");
    for(int j = 0; j < running_procs; j++){
      printf(1, "%d\t%s\t%d\t%d\t%d\t", table[j].pid, table[j].name,
 111:	8b 50 04             	mov    0x4(%eax),%edx
 114:	8b 45 dc             	mov    -0x24(%ebp),%eax
 117:	6b f0 5c             	imul   $0x5c,%eax,%esi
 11a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 11d:	01 f0                	add    %esi,%eax
 11f:	8d 70 3c             	lea    0x3c(%eax),%esi
 122:	8b 45 dc             	mov    -0x24(%ebp),%eax
 125:	6b f8 5c             	imul   $0x5c,%eax,%edi
 128:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 12b:	01 f8                	add    %edi,%eax
 12d:	8b 00                	mov    (%eax),%eax
 12f:	83 ec 04             	sub    $0x4,%esp
 132:	53                   	push   %ebx
 133:	51                   	push   %ecx
 134:	52                   	push   %edx
 135:	56                   	push   %esi
 136:	50                   	push   %eax
 137:	68 f6 0a 00 00       	push   $0xaf6
 13c:	6a 01                	push   $0x1
 13e:	e8 94 05 00 00       	call   6d7 <printf>
 143:	83 c4 20             	add    $0x20,%esp
          table[j].uid, table[j].gid, table[j].ppid);
      calcelapsedtime(table[j].elapsed_ticks);
 146:	8b 45 dc             	mov    -0x24(%ebp),%eax
 149:	6b d0 5c             	imul   $0x5c,%eax,%edx
 14c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 14f:	01 d0                	add    %edx,%eax
 151:	8b 40 10             	mov    0x10(%eax),%eax
 154:	83 ec 0c             	sub    $0xc,%esp
 157:	50                   	push   %eax
 158:	e8 8f 00 00 00       	call   1ec <calcelapsedtime>
 15d:	83 c4 10             	add    $0x10,%esp
      calcelapsedtime(table[j].CPU_total_ticks);
 160:	8b 45 dc             	mov    -0x24(%ebp),%eax
 163:	6b d0 5c             	imul   $0x5c,%eax,%edx
 166:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 169:	01 d0                	add    %edx,%eax
 16b:	8b 40 14             	mov    0x14(%eax),%eax
 16e:	83 ec 0c             	sub    $0xc,%esp
 171:	50                   	push   %eax
 172:	e8 75 00 00 00       	call   1ec <calcelapsedtime>
 177:	83 c4 10             	add    $0x10,%esp
      printf(1, "%s\t%d\n", table[j].state, table[j].size);
 17a:	8b 45 dc             	mov    -0x24(%ebp),%eax
 17d:	6b d0 5c             	imul   $0x5c,%eax,%edx
 180:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 183:	01 d0                	add    %edx,%eax
 185:	8b 40 38             	mov    0x38(%eax),%eax
 188:	8b 55 dc             	mov    -0x24(%ebp),%edx
 18b:	6b ca 5c             	imul   $0x5c,%edx,%ecx
 18e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 191:	01 ca                	add    %ecx,%edx
 193:	83 c2 18             	add    $0x18,%edx
 196:	50                   	push   %eax
 197:	52                   	push   %edx
 198:	68 06 0b 00 00       	push   $0xb06
 19d:	6a 01                	push   $0x1
 19f:	e8 33 05 00 00       	call   6d7 <printf>
 1a4:	83 c4 10             	add    $0x10,%esp
      printf(2, "Error: ps call failed.  %s at line %d\n", __FILE__, __LINE__);
      exit();
    }

    printf(1, "PID\tName\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\n");
    for(int j = 0; j < running_procs; j++){
 1a7:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
 1ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
 1ae:	3b 45 cc             	cmp    -0x34(%ebp),%eax
 1b1:	0f 8c 33 ff ff ff    	jl     ea <main+0xea>
          table[j].uid, table[j].gid, table[j].ppid);
      calcelapsedtime(table[j].elapsed_ticks);
      calcelapsedtime(table[j].CPU_total_ticks);
      printf(1, "%s\t%d\n", table[j].state, table[j].size);
    }
    printf(1, "\n\n");
 1b7:	83 ec 08             	sub    $0x8,%esp
 1ba:	68 0d 0b 00 00       	push   $0xb0d
 1bf:	6a 01                	push   $0x1
 1c1:	e8 11 05 00 00       	call   6d7 <printf>
 1c6:	83 c4 10             	add    $0x10,%esp
    free(table);
 1c9:	83 ec 0c             	sub    $0xc,%esp
 1cc:	ff 75 d4             	pushl  -0x2c(%ebp)
 1cf:	e8 94 06 00 00       	call   868 <free>
 1d4:	83 c4 10             	add    $0x10,%esp
{
  int table_size[] = {1, 16, 64, 72};
  int MAXCOUNT = 4;
  int running_procs;

  for(int i = 0; i < MAXCOUNT; i++){
 1d7:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 1db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 1de:	3b 45 d8             	cmp    -0x28(%ebp),%eax
 1e1:	0f 8c 5c fe ff ff    	jl     43 <main+0x43>
      printf(1, "%s\t%d\n", table[j].state, table[j].size);
    }
    printf(1, "\n\n");
    free(table);
  }
  exit();
 1e7:	e8 34 03 00 00       	call   520 <exit>

000001ec <calcelapsedtime>:

// Determines the seconds elapsed for a running process to the thousandth of a
// second and prints the result
void
calcelapsedtime(int ticks_in)
{
 1ec:	55                   	push   %ebp
 1ed:	89 e5                	mov    %esp,%ebp
 1ef:	83 ec 18             	sub    $0x18,%esp
  int seconds = (ticks_in)/1000;
 1f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1f5:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
 1fa:	89 c8                	mov    %ecx,%eax
 1fc:	f7 ea                	imul   %edx
 1fe:	c1 fa 06             	sar    $0x6,%edx
 201:	89 c8                	mov    %ecx,%eax
 203:	c1 f8 1f             	sar    $0x1f,%eax
 206:	29 c2                	sub    %eax,%edx
 208:	89 d0                	mov    %edx,%eax
 20a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int milliseconds = (ticks_in)%1000;
 20d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 210:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
 215:	89 c8                	mov    %ecx,%eax
 217:	f7 ea                	imul   %edx
 219:	c1 fa 06             	sar    $0x6,%edx
 21c:	89 c8                	mov    %ecx,%eax
 21e:	c1 f8 1f             	sar    $0x1f,%eax
 221:	29 c2                	sub    %eax,%edx
 223:	89 d0                	mov    %edx,%eax
 225:	69 c0 e8 03 00 00    	imul   $0x3e8,%eax,%eax
 22b:	29 c1                	sub    %eax,%ecx
 22d:	89 c8                	mov    %ecx,%eax
 22f:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(milliseconds < 10)
 232:	83 7d f0 09          	cmpl   $0x9,-0x10(%ebp)
 236:	7f 17                	jg     24f <calcelapsedtime+0x63>
    printf(1, "%d.00%d\t", seconds, milliseconds);
 238:	ff 75 f0             	pushl  -0x10(%ebp)
 23b:	ff 75 f4             	pushl  -0xc(%ebp)
 23e:	68 10 0b 00 00       	push   $0xb10
 243:	6a 01                	push   $0x1
 245:	e8 8d 04 00 00       	call   6d7 <printf>
 24a:	83 c4 10             	add    $0x10,%esp
  else if(milliseconds < 100)
    printf(1, "%d.0%d\t", seconds, milliseconds);
  else
    printf(1, "%d.%d\t", seconds, milliseconds);
}
 24d:	eb 32                	jmp    281 <calcelapsedtime+0x95>
  int seconds = (ticks_in)/1000;
  int milliseconds = (ticks_in)%1000;

  if(milliseconds < 10)
    printf(1, "%d.00%d\t", seconds, milliseconds);
  else if(milliseconds < 100)
 24f:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
 253:	7f 17                	jg     26c <calcelapsedtime+0x80>
    printf(1, "%d.0%d\t", seconds, milliseconds);
 255:	ff 75 f0             	pushl  -0x10(%ebp)
 258:	ff 75 f4             	pushl  -0xc(%ebp)
 25b:	68 19 0b 00 00       	push   $0xb19
 260:	6a 01                	push   $0x1
 262:	e8 70 04 00 00       	call   6d7 <printf>
 267:	83 c4 10             	add    $0x10,%esp
  else
    printf(1, "%d.%d\t", seconds, milliseconds);
}
 26a:	eb 15                	jmp    281 <calcelapsedtime+0x95>
  if(milliseconds < 10)
    printf(1, "%d.00%d\t", seconds, milliseconds);
  else if(milliseconds < 100)
    printf(1, "%d.0%d\t", seconds, milliseconds);
  else
    printf(1, "%d.%d\t", seconds, milliseconds);
 26c:	ff 75 f0             	pushl  -0x10(%ebp)
 26f:	ff 75 f4             	pushl  -0xc(%ebp)
 272:	68 21 0b 00 00       	push   $0xb21
 277:	6a 01                	push   $0x1
 279:	e8 59 04 00 00       	call   6d7 <printf>
 27e:	83 c4 10             	add    $0x10,%esp
}
 281:	90                   	nop
 282:	c9                   	leave  
 283:	c3                   	ret    

00000284 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 284:	55                   	push   %ebp
 285:	89 e5                	mov    %esp,%ebp
 287:	57                   	push   %edi
 288:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 289:	8b 4d 08             	mov    0x8(%ebp),%ecx
 28c:	8b 55 10             	mov    0x10(%ebp),%edx
 28f:	8b 45 0c             	mov    0xc(%ebp),%eax
 292:	89 cb                	mov    %ecx,%ebx
 294:	89 df                	mov    %ebx,%edi
 296:	89 d1                	mov    %edx,%ecx
 298:	fc                   	cld    
 299:	f3 aa                	rep stos %al,%es:(%edi)
 29b:	89 ca                	mov    %ecx,%edx
 29d:	89 fb                	mov    %edi,%ebx
 29f:	89 5d 08             	mov    %ebx,0x8(%ebp)
 2a2:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 2a5:	90                   	nop
 2a6:	5b                   	pop    %ebx
 2a7:	5f                   	pop    %edi
 2a8:	5d                   	pop    %ebp
 2a9:	c3                   	ret    

000002aa <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 2aa:	55                   	push   %ebp
 2ab:	89 e5                	mov    %esp,%ebp
 2ad:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 2b0:	8b 45 08             	mov    0x8(%ebp),%eax
 2b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 2b6:	90                   	nop
 2b7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ba:	8d 50 01             	lea    0x1(%eax),%edx
 2bd:	89 55 08             	mov    %edx,0x8(%ebp)
 2c0:	8b 55 0c             	mov    0xc(%ebp),%edx
 2c3:	8d 4a 01             	lea    0x1(%edx),%ecx
 2c6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 2c9:	0f b6 12             	movzbl (%edx),%edx
 2cc:	88 10                	mov    %dl,(%eax)
 2ce:	0f b6 00             	movzbl (%eax),%eax
 2d1:	84 c0                	test   %al,%al
 2d3:	75 e2                	jne    2b7 <strcpy+0xd>
    ;
  return os;
 2d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2d8:	c9                   	leave  
 2d9:	c3                   	ret    

000002da <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2da:	55                   	push   %ebp
 2db:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 2dd:	eb 08                	jmp    2e7 <strcmp+0xd>
    p++, q++;
 2df:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2e3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 2e7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ea:	0f b6 00             	movzbl (%eax),%eax
 2ed:	84 c0                	test   %al,%al
 2ef:	74 10                	je     301 <strcmp+0x27>
 2f1:	8b 45 08             	mov    0x8(%ebp),%eax
 2f4:	0f b6 10             	movzbl (%eax),%edx
 2f7:	8b 45 0c             	mov    0xc(%ebp),%eax
 2fa:	0f b6 00             	movzbl (%eax),%eax
 2fd:	38 c2                	cmp    %al,%dl
 2ff:	74 de                	je     2df <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 301:	8b 45 08             	mov    0x8(%ebp),%eax
 304:	0f b6 00             	movzbl (%eax),%eax
 307:	0f b6 d0             	movzbl %al,%edx
 30a:	8b 45 0c             	mov    0xc(%ebp),%eax
 30d:	0f b6 00             	movzbl (%eax),%eax
 310:	0f b6 c0             	movzbl %al,%eax
 313:	29 c2                	sub    %eax,%edx
 315:	89 d0                	mov    %edx,%eax
}
 317:	5d                   	pop    %ebp
 318:	c3                   	ret    

00000319 <strlen>:

uint
strlen(char *s)
{
 319:	55                   	push   %ebp
 31a:	89 e5                	mov    %esp,%ebp
 31c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 31f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 326:	eb 04                	jmp    32c <strlen+0x13>
 328:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 32c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 32f:	8b 45 08             	mov    0x8(%ebp),%eax
 332:	01 d0                	add    %edx,%eax
 334:	0f b6 00             	movzbl (%eax),%eax
 337:	84 c0                	test   %al,%al
 339:	75 ed                	jne    328 <strlen+0xf>
    ;
  return n;
 33b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 33e:	c9                   	leave  
 33f:	c3                   	ret    

00000340 <memset>:

void*
memset(void *dst, int c, uint n)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 343:	8b 45 10             	mov    0x10(%ebp),%eax
 346:	50                   	push   %eax
 347:	ff 75 0c             	pushl  0xc(%ebp)
 34a:	ff 75 08             	pushl  0x8(%ebp)
 34d:	e8 32 ff ff ff       	call   284 <stosb>
 352:	83 c4 0c             	add    $0xc,%esp
  return dst;
 355:	8b 45 08             	mov    0x8(%ebp),%eax
}
 358:	c9                   	leave  
 359:	c3                   	ret    

0000035a <strchr>:

char*
strchr(const char *s, char c)
{
 35a:	55                   	push   %ebp
 35b:	89 e5                	mov    %esp,%ebp
 35d:	83 ec 04             	sub    $0x4,%esp
 360:	8b 45 0c             	mov    0xc(%ebp),%eax
 363:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 366:	eb 14                	jmp    37c <strchr+0x22>
    if(*s == c)
 368:	8b 45 08             	mov    0x8(%ebp),%eax
 36b:	0f b6 00             	movzbl (%eax),%eax
 36e:	3a 45 fc             	cmp    -0x4(%ebp),%al
 371:	75 05                	jne    378 <strchr+0x1e>
      return (char*)s;
 373:	8b 45 08             	mov    0x8(%ebp),%eax
 376:	eb 13                	jmp    38b <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 378:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 37c:	8b 45 08             	mov    0x8(%ebp),%eax
 37f:	0f b6 00             	movzbl (%eax),%eax
 382:	84 c0                	test   %al,%al
 384:	75 e2                	jne    368 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 386:	b8 00 00 00 00       	mov    $0x0,%eax
}
 38b:	c9                   	leave  
 38c:	c3                   	ret    

0000038d <gets>:

char*
gets(char *buf, int max)
{
 38d:	55                   	push   %ebp
 38e:	89 e5                	mov    %esp,%ebp
 390:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 393:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 39a:	eb 42                	jmp    3de <gets+0x51>
    cc = read(0, &c, 1);
 39c:	83 ec 04             	sub    $0x4,%esp
 39f:	6a 01                	push   $0x1
 3a1:	8d 45 ef             	lea    -0x11(%ebp),%eax
 3a4:	50                   	push   %eax
 3a5:	6a 00                	push   $0x0
 3a7:	e8 8c 01 00 00       	call   538 <read>
 3ac:	83 c4 10             	add    $0x10,%esp
 3af:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 3b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3b6:	7e 33                	jle    3eb <gets+0x5e>
      break;
    buf[i++] = c;
 3b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3bb:	8d 50 01             	lea    0x1(%eax),%edx
 3be:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3c1:	89 c2                	mov    %eax,%edx
 3c3:	8b 45 08             	mov    0x8(%ebp),%eax
 3c6:	01 c2                	add    %eax,%edx
 3c8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3cc:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 3ce:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3d2:	3c 0a                	cmp    $0xa,%al
 3d4:	74 16                	je     3ec <gets+0x5f>
 3d6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3da:	3c 0d                	cmp    $0xd,%al
 3dc:	74 0e                	je     3ec <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3de:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3e1:	83 c0 01             	add    $0x1,%eax
 3e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
 3e7:	7c b3                	jl     39c <gets+0xf>
 3e9:	eb 01                	jmp    3ec <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 3eb:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 3ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3ef:	8b 45 08             	mov    0x8(%ebp),%eax
 3f2:	01 d0                	add    %edx,%eax
 3f4:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 3f7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3fa:	c9                   	leave  
 3fb:	c3                   	ret    

000003fc <stat>:

int
stat(char *n, struct stat *st)
{
 3fc:	55                   	push   %ebp
 3fd:	89 e5                	mov    %esp,%ebp
 3ff:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 402:	83 ec 08             	sub    $0x8,%esp
 405:	6a 00                	push   $0x0
 407:	ff 75 08             	pushl  0x8(%ebp)
 40a:	e8 51 01 00 00       	call   560 <open>
 40f:	83 c4 10             	add    $0x10,%esp
 412:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 415:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 419:	79 07                	jns    422 <stat+0x26>
    return -1;
 41b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 420:	eb 25                	jmp    447 <stat+0x4b>
  r = fstat(fd, st);
 422:	83 ec 08             	sub    $0x8,%esp
 425:	ff 75 0c             	pushl  0xc(%ebp)
 428:	ff 75 f4             	pushl  -0xc(%ebp)
 42b:	e8 48 01 00 00       	call   578 <fstat>
 430:	83 c4 10             	add    $0x10,%esp
 433:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 436:	83 ec 0c             	sub    $0xc,%esp
 439:	ff 75 f4             	pushl  -0xc(%ebp)
 43c:	e8 07 01 00 00       	call   548 <close>
 441:	83 c4 10             	add    $0x10,%esp
  return r;
 444:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 447:	c9                   	leave  
 448:	c3                   	ret    

00000449 <atoi>:

int
atoi(const char *s)
{
 449:	55                   	push   %ebp
 44a:	89 e5                	mov    %esp,%ebp
 44c:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 44f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 456:	eb 04                	jmp    45c <atoi+0x13>
 458:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 45c:	8b 45 08             	mov    0x8(%ebp),%eax
 45f:	0f b6 00             	movzbl (%eax),%eax
 462:	3c 20                	cmp    $0x20,%al
 464:	74 f2                	je     458 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 466:	8b 45 08             	mov    0x8(%ebp),%eax
 469:	0f b6 00             	movzbl (%eax),%eax
 46c:	3c 2d                	cmp    $0x2d,%al
 46e:	75 07                	jne    477 <atoi+0x2e>
 470:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 475:	eb 05                	jmp    47c <atoi+0x33>
 477:	b8 01 00 00 00       	mov    $0x1,%eax
 47c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 47f:	8b 45 08             	mov    0x8(%ebp),%eax
 482:	0f b6 00             	movzbl (%eax),%eax
 485:	3c 2b                	cmp    $0x2b,%al
 487:	74 0a                	je     493 <atoi+0x4a>
 489:	8b 45 08             	mov    0x8(%ebp),%eax
 48c:	0f b6 00             	movzbl (%eax),%eax
 48f:	3c 2d                	cmp    $0x2d,%al
 491:	75 2b                	jne    4be <atoi+0x75>
    s++;
 493:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 497:	eb 25                	jmp    4be <atoi+0x75>
    n = n*10 + *s++ - '0';
 499:	8b 55 fc             	mov    -0x4(%ebp),%edx
 49c:	89 d0                	mov    %edx,%eax
 49e:	c1 e0 02             	shl    $0x2,%eax
 4a1:	01 d0                	add    %edx,%eax
 4a3:	01 c0                	add    %eax,%eax
 4a5:	89 c1                	mov    %eax,%ecx
 4a7:	8b 45 08             	mov    0x8(%ebp),%eax
 4aa:	8d 50 01             	lea    0x1(%eax),%edx
 4ad:	89 55 08             	mov    %edx,0x8(%ebp)
 4b0:	0f b6 00             	movzbl (%eax),%eax
 4b3:	0f be c0             	movsbl %al,%eax
 4b6:	01 c8                	add    %ecx,%eax
 4b8:	83 e8 30             	sub    $0x30,%eax
 4bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 4be:	8b 45 08             	mov    0x8(%ebp),%eax
 4c1:	0f b6 00             	movzbl (%eax),%eax
 4c4:	3c 2f                	cmp    $0x2f,%al
 4c6:	7e 0a                	jle    4d2 <atoi+0x89>
 4c8:	8b 45 08             	mov    0x8(%ebp),%eax
 4cb:	0f b6 00             	movzbl (%eax),%eax
 4ce:	3c 39                	cmp    $0x39,%al
 4d0:	7e c7                	jle    499 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 4d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 4d5:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 4d9:	c9                   	leave  
 4da:	c3                   	ret    

000004db <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 4db:	55                   	push   %ebp
 4dc:	89 e5                	mov    %esp,%ebp
 4de:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 4e1:	8b 45 08             	mov    0x8(%ebp),%eax
 4e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 4e7:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ea:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 4ed:	eb 17                	jmp    506 <memmove+0x2b>
    *dst++ = *src++;
 4ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4f2:	8d 50 01             	lea    0x1(%eax),%edx
 4f5:	89 55 fc             	mov    %edx,-0x4(%ebp)
 4f8:	8b 55 f8             	mov    -0x8(%ebp),%edx
 4fb:	8d 4a 01             	lea    0x1(%edx),%ecx
 4fe:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 501:	0f b6 12             	movzbl (%edx),%edx
 504:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 506:	8b 45 10             	mov    0x10(%ebp),%eax
 509:	8d 50 ff             	lea    -0x1(%eax),%edx
 50c:	89 55 10             	mov    %edx,0x10(%ebp)
 50f:	85 c0                	test   %eax,%eax
 511:	7f dc                	jg     4ef <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 513:	8b 45 08             	mov    0x8(%ebp),%eax
}
 516:	c9                   	leave  
 517:	c3                   	ret    

00000518 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 518:	b8 01 00 00 00       	mov    $0x1,%eax
 51d:	cd 40                	int    $0x40
 51f:	c3                   	ret    

00000520 <exit>:
SYSCALL(exit)
 520:	b8 02 00 00 00       	mov    $0x2,%eax
 525:	cd 40                	int    $0x40
 527:	c3                   	ret    

00000528 <wait>:
SYSCALL(wait)
 528:	b8 03 00 00 00       	mov    $0x3,%eax
 52d:	cd 40                	int    $0x40
 52f:	c3                   	ret    

00000530 <pipe>:
SYSCALL(pipe)
 530:	b8 04 00 00 00       	mov    $0x4,%eax
 535:	cd 40                	int    $0x40
 537:	c3                   	ret    

00000538 <read>:
SYSCALL(read)
 538:	b8 05 00 00 00       	mov    $0x5,%eax
 53d:	cd 40                	int    $0x40
 53f:	c3                   	ret    

00000540 <write>:
SYSCALL(write)
 540:	b8 10 00 00 00       	mov    $0x10,%eax
 545:	cd 40                	int    $0x40
 547:	c3                   	ret    

00000548 <close>:
SYSCALL(close)
 548:	b8 15 00 00 00       	mov    $0x15,%eax
 54d:	cd 40                	int    $0x40
 54f:	c3                   	ret    

00000550 <kill>:
SYSCALL(kill)
 550:	b8 06 00 00 00       	mov    $0x6,%eax
 555:	cd 40                	int    $0x40
 557:	c3                   	ret    

00000558 <exec>:
SYSCALL(exec)
 558:	b8 07 00 00 00       	mov    $0x7,%eax
 55d:	cd 40                	int    $0x40
 55f:	c3                   	ret    

00000560 <open>:
SYSCALL(open)
 560:	b8 0f 00 00 00       	mov    $0xf,%eax
 565:	cd 40                	int    $0x40
 567:	c3                   	ret    

00000568 <mknod>:
SYSCALL(mknod)
 568:	b8 11 00 00 00       	mov    $0x11,%eax
 56d:	cd 40                	int    $0x40
 56f:	c3                   	ret    

00000570 <unlink>:
SYSCALL(unlink)
 570:	b8 12 00 00 00       	mov    $0x12,%eax
 575:	cd 40                	int    $0x40
 577:	c3                   	ret    

00000578 <fstat>:
SYSCALL(fstat)
 578:	b8 08 00 00 00       	mov    $0x8,%eax
 57d:	cd 40                	int    $0x40
 57f:	c3                   	ret    

00000580 <link>:
SYSCALL(link)
 580:	b8 13 00 00 00       	mov    $0x13,%eax
 585:	cd 40                	int    $0x40
 587:	c3                   	ret    

00000588 <mkdir>:
SYSCALL(mkdir)
 588:	b8 14 00 00 00       	mov    $0x14,%eax
 58d:	cd 40                	int    $0x40
 58f:	c3                   	ret    

00000590 <chdir>:
SYSCALL(chdir)
 590:	b8 09 00 00 00       	mov    $0x9,%eax
 595:	cd 40                	int    $0x40
 597:	c3                   	ret    

00000598 <dup>:
SYSCALL(dup)
 598:	b8 0a 00 00 00       	mov    $0xa,%eax
 59d:	cd 40                	int    $0x40
 59f:	c3                   	ret    

000005a0 <getpid>:
SYSCALL(getpid)
 5a0:	b8 0b 00 00 00       	mov    $0xb,%eax
 5a5:	cd 40                	int    $0x40
 5a7:	c3                   	ret    

000005a8 <sbrk>:
SYSCALL(sbrk)
 5a8:	b8 0c 00 00 00       	mov    $0xc,%eax
 5ad:	cd 40                	int    $0x40
 5af:	c3                   	ret    

000005b0 <sleep>:
SYSCALL(sleep)
 5b0:	b8 0d 00 00 00       	mov    $0xd,%eax
 5b5:	cd 40                	int    $0x40
 5b7:	c3                   	ret    

000005b8 <uptime>:
SYSCALL(uptime)
 5b8:	b8 0e 00 00 00       	mov    $0xe,%eax
 5bd:	cd 40                	int    $0x40
 5bf:	c3                   	ret    

000005c0 <halt>:
SYSCALL(halt)
 5c0:	b8 16 00 00 00       	mov    $0x16,%eax
 5c5:	cd 40                	int    $0x40
 5c7:	c3                   	ret    

000005c8 <date>:
SYSCALL(date)
 5c8:	b8 17 00 00 00       	mov    $0x17,%eax
 5cd:	cd 40                	int    $0x40
 5cf:	c3                   	ret    

000005d0 <getuid>:
SYSCALL(getuid)
 5d0:	b8 18 00 00 00       	mov    $0x18,%eax
 5d5:	cd 40                	int    $0x40
 5d7:	c3                   	ret    

000005d8 <getgid>:
SYSCALL(getgid)
 5d8:	b8 19 00 00 00       	mov    $0x19,%eax
 5dd:	cd 40                	int    $0x40
 5df:	c3                   	ret    

000005e0 <getppid>:
SYSCALL(getppid)
 5e0:	b8 1a 00 00 00       	mov    $0x1a,%eax
 5e5:	cd 40                	int    $0x40
 5e7:	c3                   	ret    

000005e8 <setuid>:
SYSCALL(setuid)
 5e8:	b8 1b 00 00 00       	mov    $0x1b,%eax
 5ed:	cd 40                	int    $0x40
 5ef:	c3                   	ret    

000005f0 <setgid>:
SYSCALL(setgid)
 5f0:	b8 1c 00 00 00       	mov    $0x1c,%eax
 5f5:	cd 40                	int    $0x40
 5f7:	c3                   	ret    

000005f8 <getprocs>:
SYSCALL(getprocs)
 5f8:	b8 1d 00 00 00       	mov    $0x1d,%eax
 5fd:	cd 40                	int    $0x40
 5ff:	c3                   	ret    

00000600 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 600:	55                   	push   %ebp
 601:	89 e5                	mov    %esp,%ebp
 603:	83 ec 18             	sub    $0x18,%esp
 606:	8b 45 0c             	mov    0xc(%ebp),%eax
 609:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 60c:	83 ec 04             	sub    $0x4,%esp
 60f:	6a 01                	push   $0x1
 611:	8d 45 f4             	lea    -0xc(%ebp),%eax
 614:	50                   	push   %eax
 615:	ff 75 08             	pushl  0x8(%ebp)
 618:	e8 23 ff ff ff       	call   540 <write>
 61d:	83 c4 10             	add    $0x10,%esp
}
 620:	90                   	nop
 621:	c9                   	leave  
 622:	c3                   	ret    

00000623 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 623:	55                   	push   %ebp
 624:	89 e5                	mov    %esp,%ebp
 626:	53                   	push   %ebx
 627:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 62a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 631:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 635:	74 17                	je     64e <printint+0x2b>
 637:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 63b:	79 11                	jns    64e <printint+0x2b>
    neg = 1;
 63d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 644:	8b 45 0c             	mov    0xc(%ebp),%eax
 647:	f7 d8                	neg    %eax
 649:	89 45 ec             	mov    %eax,-0x14(%ebp)
 64c:	eb 06                	jmp    654 <printint+0x31>
  } else {
    x = xx;
 64e:	8b 45 0c             	mov    0xc(%ebp),%eax
 651:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 654:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 65b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 65e:	8d 41 01             	lea    0x1(%ecx),%eax
 661:	89 45 f4             	mov    %eax,-0xc(%ebp)
 664:	8b 5d 10             	mov    0x10(%ebp),%ebx
 667:	8b 45 ec             	mov    -0x14(%ebp),%eax
 66a:	ba 00 00 00 00       	mov    $0x0,%edx
 66f:	f7 f3                	div    %ebx
 671:	89 d0                	mov    %edx,%eax
 673:	0f b6 80 a4 0d 00 00 	movzbl 0xda4(%eax),%eax
 67a:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 67e:	8b 5d 10             	mov    0x10(%ebp),%ebx
 681:	8b 45 ec             	mov    -0x14(%ebp),%eax
 684:	ba 00 00 00 00       	mov    $0x0,%edx
 689:	f7 f3                	div    %ebx
 68b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 68e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 692:	75 c7                	jne    65b <printint+0x38>
  if(neg)
 694:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 698:	74 2d                	je     6c7 <printint+0xa4>
    buf[i++] = '-';
 69a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 69d:	8d 50 01             	lea    0x1(%eax),%edx
 6a0:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6a3:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6a8:	eb 1d                	jmp    6c7 <printint+0xa4>
    putc(fd, buf[i]);
 6aa:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6b0:	01 d0                	add    %edx,%eax
 6b2:	0f b6 00             	movzbl (%eax),%eax
 6b5:	0f be c0             	movsbl %al,%eax
 6b8:	83 ec 08             	sub    $0x8,%esp
 6bb:	50                   	push   %eax
 6bc:	ff 75 08             	pushl  0x8(%ebp)
 6bf:	e8 3c ff ff ff       	call   600 <putc>
 6c4:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6c7:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 6cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6cf:	79 d9                	jns    6aa <printint+0x87>
    putc(fd, buf[i]);
}
 6d1:	90                   	nop
 6d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6d5:	c9                   	leave  
 6d6:	c3                   	ret    

000006d7 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6d7:	55                   	push   %ebp
 6d8:	89 e5                	mov    %esp,%ebp
 6da:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 6dd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 6e4:	8d 45 0c             	lea    0xc(%ebp),%eax
 6e7:	83 c0 04             	add    $0x4,%eax
 6ea:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 6ed:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 6f4:	e9 59 01 00 00       	jmp    852 <printf+0x17b>
    c = fmt[i] & 0xff;
 6f9:	8b 55 0c             	mov    0xc(%ebp),%edx
 6fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ff:	01 d0                	add    %edx,%eax
 701:	0f b6 00             	movzbl (%eax),%eax
 704:	0f be c0             	movsbl %al,%eax
 707:	25 ff 00 00 00       	and    $0xff,%eax
 70c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 70f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 713:	75 2c                	jne    741 <printf+0x6a>
      if(c == '%'){
 715:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 719:	75 0c                	jne    727 <printf+0x50>
        state = '%';
 71b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 722:	e9 27 01 00 00       	jmp    84e <printf+0x177>
      } else {
        putc(fd, c);
 727:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 72a:	0f be c0             	movsbl %al,%eax
 72d:	83 ec 08             	sub    $0x8,%esp
 730:	50                   	push   %eax
 731:	ff 75 08             	pushl  0x8(%ebp)
 734:	e8 c7 fe ff ff       	call   600 <putc>
 739:	83 c4 10             	add    $0x10,%esp
 73c:	e9 0d 01 00 00       	jmp    84e <printf+0x177>
      }
    } else if(state == '%'){
 741:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 745:	0f 85 03 01 00 00    	jne    84e <printf+0x177>
      if(c == 'd'){
 74b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 74f:	75 1e                	jne    76f <printf+0x98>
        printint(fd, *ap, 10, 1);
 751:	8b 45 e8             	mov    -0x18(%ebp),%eax
 754:	8b 00                	mov    (%eax),%eax
 756:	6a 01                	push   $0x1
 758:	6a 0a                	push   $0xa
 75a:	50                   	push   %eax
 75b:	ff 75 08             	pushl  0x8(%ebp)
 75e:	e8 c0 fe ff ff       	call   623 <printint>
 763:	83 c4 10             	add    $0x10,%esp
        ap++;
 766:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 76a:	e9 d8 00 00 00       	jmp    847 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 76f:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 773:	74 06                	je     77b <printf+0xa4>
 775:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 779:	75 1e                	jne    799 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 77b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 77e:	8b 00                	mov    (%eax),%eax
 780:	6a 00                	push   $0x0
 782:	6a 10                	push   $0x10
 784:	50                   	push   %eax
 785:	ff 75 08             	pushl  0x8(%ebp)
 788:	e8 96 fe ff ff       	call   623 <printint>
 78d:	83 c4 10             	add    $0x10,%esp
        ap++;
 790:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 794:	e9 ae 00 00 00       	jmp    847 <printf+0x170>
      } else if(c == 's'){
 799:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 79d:	75 43                	jne    7e2 <printf+0x10b>
        s = (char*)*ap;
 79f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7a2:	8b 00                	mov    (%eax),%eax
 7a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7a7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7af:	75 25                	jne    7d6 <printf+0xff>
          s = "(null)";
 7b1:	c7 45 f4 28 0b 00 00 	movl   $0xb28,-0xc(%ebp)
        while(*s != 0){
 7b8:	eb 1c                	jmp    7d6 <printf+0xff>
          putc(fd, *s);
 7ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bd:	0f b6 00             	movzbl (%eax),%eax
 7c0:	0f be c0             	movsbl %al,%eax
 7c3:	83 ec 08             	sub    $0x8,%esp
 7c6:	50                   	push   %eax
 7c7:	ff 75 08             	pushl  0x8(%ebp)
 7ca:	e8 31 fe ff ff       	call   600 <putc>
 7cf:	83 c4 10             	add    $0x10,%esp
          s++;
 7d2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d9:	0f b6 00             	movzbl (%eax),%eax
 7dc:	84 c0                	test   %al,%al
 7de:	75 da                	jne    7ba <printf+0xe3>
 7e0:	eb 65                	jmp    847 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7e2:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 7e6:	75 1d                	jne    805 <printf+0x12e>
        putc(fd, *ap);
 7e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7eb:	8b 00                	mov    (%eax),%eax
 7ed:	0f be c0             	movsbl %al,%eax
 7f0:	83 ec 08             	sub    $0x8,%esp
 7f3:	50                   	push   %eax
 7f4:	ff 75 08             	pushl  0x8(%ebp)
 7f7:	e8 04 fe ff ff       	call   600 <putc>
 7fc:	83 c4 10             	add    $0x10,%esp
        ap++;
 7ff:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 803:	eb 42                	jmp    847 <printf+0x170>
      } else if(c == '%'){
 805:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 809:	75 17                	jne    822 <printf+0x14b>
        putc(fd, c);
 80b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 80e:	0f be c0             	movsbl %al,%eax
 811:	83 ec 08             	sub    $0x8,%esp
 814:	50                   	push   %eax
 815:	ff 75 08             	pushl  0x8(%ebp)
 818:	e8 e3 fd ff ff       	call   600 <putc>
 81d:	83 c4 10             	add    $0x10,%esp
 820:	eb 25                	jmp    847 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 822:	83 ec 08             	sub    $0x8,%esp
 825:	6a 25                	push   $0x25
 827:	ff 75 08             	pushl  0x8(%ebp)
 82a:	e8 d1 fd ff ff       	call   600 <putc>
 82f:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 832:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 835:	0f be c0             	movsbl %al,%eax
 838:	83 ec 08             	sub    $0x8,%esp
 83b:	50                   	push   %eax
 83c:	ff 75 08             	pushl  0x8(%ebp)
 83f:	e8 bc fd ff ff       	call   600 <putc>
 844:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 847:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 84e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 852:	8b 55 0c             	mov    0xc(%ebp),%edx
 855:	8b 45 f0             	mov    -0x10(%ebp),%eax
 858:	01 d0                	add    %edx,%eax
 85a:	0f b6 00             	movzbl (%eax),%eax
 85d:	84 c0                	test   %al,%al
 85f:	0f 85 94 fe ff ff    	jne    6f9 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 865:	90                   	nop
 866:	c9                   	leave  
 867:	c3                   	ret    

00000868 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 868:	55                   	push   %ebp
 869:	89 e5                	mov    %esp,%ebp
 86b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 86e:	8b 45 08             	mov    0x8(%ebp),%eax
 871:	83 e8 08             	sub    $0x8,%eax
 874:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 877:	a1 c0 0d 00 00       	mov    0xdc0,%eax
 87c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 87f:	eb 24                	jmp    8a5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 881:	8b 45 fc             	mov    -0x4(%ebp),%eax
 884:	8b 00                	mov    (%eax),%eax
 886:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 889:	77 12                	ja     89d <free+0x35>
 88b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 88e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 891:	77 24                	ja     8b7 <free+0x4f>
 893:	8b 45 fc             	mov    -0x4(%ebp),%eax
 896:	8b 00                	mov    (%eax),%eax
 898:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 89b:	77 1a                	ja     8b7 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 89d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a0:	8b 00                	mov    (%eax),%eax
 8a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8a8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8ab:	76 d4                	jbe    881 <free+0x19>
 8ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b0:	8b 00                	mov    (%eax),%eax
 8b2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8b5:	76 ca                	jbe    881 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 8b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ba:	8b 40 04             	mov    0x4(%eax),%eax
 8bd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8c7:	01 c2                	add    %eax,%edx
 8c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8cc:	8b 00                	mov    (%eax),%eax
 8ce:	39 c2                	cmp    %eax,%edx
 8d0:	75 24                	jne    8f6 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 8d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8d5:	8b 50 04             	mov    0x4(%eax),%edx
 8d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8db:	8b 00                	mov    (%eax),%eax
 8dd:	8b 40 04             	mov    0x4(%eax),%eax
 8e0:	01 c2                	add    %eax,%edx
 8e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8e5:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 8e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8eb:	8b 00                	mov    (%eax),%eax
 8ed:	8b 10                	mov    (%eax),%edx
 8ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8f2:	89 10                	mov    %edx,(%eax)
 8f4:	eb 0a                	jmp    900 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 8f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f9:	8b 10                	mov    (%eax),%edx
 8fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8fe:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 900:	8b 45 fc             	mov    -0x4(%ebp),%eax
 903:	8b 40 04             	mov    0x4(%eax),%eax
 906:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 90d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 910:	01 d0                	add    %edx,%eax
 912:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 915:	75 20                	jne    937 <free+0xcf>
    p->s.size += bp->s.size;
 917:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91a:	8b 50 04             	mov    0x4(%eax),%edx
 91d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 920:	8b 40 04             	mov    0x4(%eax),%eax
 923:	01 c2                	add    %eax,%edx
 925:	8b 45 fc             	mov    -0x4(%ebp),%eax
 928:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 92b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 92e:	8b 10                	mov    (%eax),%edx
 930:	8b 45 fc             	mov    -0x4(%ebp),%eax
 933:	89 10                	mov    %edx,(%eax)
 935:	eb 08                	jmp    93f <free+0xd7>
  } else
    p->s.ptr = bp;
 937:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 93d:	89 10                	mov    %edx,(%eax)
  freep = p;
 93f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 942:	a3 c0 0d 00 00       	mov    %eax,0xdc0
}
 947:	90                   	nop
 948:	c9                   	leave  
 949:	c3                   	ret    

0000094a <morecore>:

static Header*
morecore(uint nu)
{
 94a:	55                   	push   %ebp
 94b:	89 e5                	mov    %esp,%ebp
 94d:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 950:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 957:	77 07                	ja     960 <morecore+0x16>
    nu = 4096;
 959:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 960:	8b 45 08             	mov    0x8(%ebp),%eax
 963:	c1 e0 03             	shl    $0x3,%eax
 966:	83 ec 0c             	sub    $0xc,%esp
 969:	50                   	push   %eax
 96a:	e8 39 fc ff ff       	call   5a8 <sbrk>
 96f:	83 c4 10             	add    $0x10,%esp
 972:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 975:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 979:	75 07                	jne    982 <morecore+0x38>
    return 0;
 97b:	b8 00 00 00 00       	mov    $0x0,%eax
 980:	eb 26                	jmp    9a8 <morecore+0x5e>
  hp = (Header*)p;
 982:	8b 45 f4             	mov    -0xc(%ebp),%eax
 985:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 988:	8b 45 f0             	mov    -0x10(%ebp),%eax
 98b:	8b 55 08             	mov    0x8(%ebp),%edx
 98e:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 991:	8b 45 f0             	mov    -0x10(%ebp),%eax
 994:	83 c0 08             	add    $0x8,%eax
 997:	83 ec 0c             	sub    $0xc,%esp
 99a:	50                   	push   %eax
 99b:	e8 c8 fe ff ff       	call   868 <free>
 9a0:	83 c4 10             	add    $0x10,%esp
  return freep;
 9a3:	a1 c0 0d 00 00       	mov    0xdc0,%eax
}
 9a8:	c9                   	leave  
 9a9:	c3                   	ret    

000009aa <malloc>:

void*
malloc(uint nbytes)
{
 9aa:	55                   	push   %ebp
 9ab:	89 e5                	mov    %esp,%ebp
 9ad:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9b0:	8b 45 08             	mov    0x8(%ebp),%eax
 9b3:	83 c0 07             	add    $0x7,%eax
 9b6:	c1 e8 03             	shr    $0x3,%eax
 9b9:	83 c0 01             	add    $0x1,%eax
 9bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9bf:	a1 c0 0d 00 00       	mov    0xdc0,%eax
 9c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9cb:	75 23                	jne    9f0 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 9cd:	c7 45 f0 b8 0d 00 00 	movl   $0xdb8,-0x10(%ebp)
 9d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9d7:	a3 c0 0d 00 00       	mov    %eax,0xdc0
 9dc:	a1 c0 0d 00 00       	mov    0xdc0,%eax
 9e1:	a3 b8 0d 00 00       	mov    %eax,0xdb8
    base.s.size = 0;
 9e6:	c7 05 bc 0d 00 00 00 	movl   $0x0,0xdbc
 9ed:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9f3:	8b 00                	mov    (%eax),%eax
 9f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9fb:	8b 40 04             	mov    0x4(%eax),%eax
 9fe:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a01:	72 4d                	jb     a50 <malloc+0xa6>
      if(p->s.size == nunits)
 a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a06:	8b 40 04             	mov    0x4(%eax),%eax
 a09:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a0c:	75 0c                	jne    a1a <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a11:	8b 10                	mov    (%eax),%edx
 a13:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a16:	89 10                	mov    %edx,(%eax)
 a18:	eb 26                	jmp    a40 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a1d:	8b 40 04             	mov    0x4(%eax),%eax
 a20:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a23:	89 c2                	mov    %eax,%edx
 a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a28:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a2e:	8b 40 04             	mov    0x4(%eax),%eax
 a31:	c1 e0 03             	shl    $0x3,%eax
 a34:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a3a:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a3d:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a40:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a43:	a3 c0 0d 00 00       	mov    %eax,0xdc0
      return (void*)(p + 1);
 a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4b:	83 c0 08             	add    $0x8,%eax
 a4e:	eb 3b                	jmp    a8b <malloc+0xe1>
    }
    if(p == freep)
 a50:	a1 c0 0d 00 00       	mov    0xdc0,%eax
 a55:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a58:	75 1e                	jne    a78 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a5a:	83 ec 0c             	sub    $0xc,%esp
 a5d:	ff 75 ec             	pushl  -0x14(%ebp)
 a60:	e8 e5 fe ff ff       	call   94a <morecore>
 a65:	83 c4 10             	add    $0x10,%esp
 a68:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a6f:	75 07                	jne    a78 <malloc+0xce>
        return 0;
 a71:	b8 00 00 00 00       	mov    $0x0,%eax
 a76:	eb 13                	jmp    a8b <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a81:	8b 00                	mov    (%eax),%eax
 a83:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a86:	e9 6d ff ff ff       	jmp    9f8 <malloc+0x4e>
}
 a8b:	c9                   	leave  
 a8c:	c3                   	ret    
