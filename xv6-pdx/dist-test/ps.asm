
_ps:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

#define UPROC_TABLE_MAX 64

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
  11:	83 ec 28             	sub    $0x28,%esp
  int running_procs;

  struct uproc* table = malloc(sizeof(struct uproc)*UPROC_TABLE_MAX);
  14:	83 ec 0c             	sub    $0xc,%esp
  17:	68 00 18 00 00       	push   $0x1800
  1c:	e8 5f 09 00 00       	call   980 <malloc>
  21:	83 c4 10             	add    $0x10,%esp
  24:	89 45 e0             	mov    %eax,-0x20(%ebp)

  running_procs = getprocs(UPROC_TABLE_MAX, table);
  27:	83 ec 08             	sub    $0x8,%esp
  2a:	ff 75 e0             	pushl  -0x20(%ebp)
  2d:	6a 40                	push   $0x40
  2f:	e8 92 05 00 00       	call   5c6 <getprocs>
  34:	83 c4 10             	add    $0x10,%esp
  37:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(running_procs == 0) {
  3a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  3e:	75 1b                	jne    5b <main+0x5b>
    printf(2, "Error: ps call failed.  %s at line %d\n", __FILE__, __LINE__);
  40:	6a 11                	push   $0x11
  42:	68 64 0a 00 00       	push   $0xa64
  47:	68 6c 0a 00 00       	push   $0xa6c
  4c:	6a 02                	push   $0x2
  4e:	e8 5a 06 00 00       	call   6ad <printf>
  53:	83 c4 10             	add    $0x10,%esp
    exit();
  56:	e8 93 04 00 00       	call   4ee <exit>
  }

  #ifdef CS333_P3P4
  printf(1, "PID\tName\tUID\tGID\tPPID\tPrio\tElapsed\tCPU\tState\tSize\n");
  5b:	83 ec 08             	sub    $0x8,%esp
  5e:	68 94 0a 00 00       	push   $0xa94
  63:	6a 01                	push   $0x1
  65:	e8 43 06 00 00       	call   6ad <printf>
  6a:	83 c4 10             	add    $0x10,%esp
  for(int i = 0; i < running_procs; i++){
  6d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  74:	e9 22 01 00 00       	jmp    19b <main+0x19b>
    printf(1, "%d\t%s\t%d\t%d\t%d\t%d\t", table[i].pid, table[i].name,
        table[i].uid, table[i].gid, table[i].ppid, table[i].priority);
  79:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  7c:	89 d0                	mov    %edx,%eax
  7e:	01 c0                	add    %eax,%eax
  80:	01 d0                	add    %edx,%eax
  82:	c1 e0 05             	shl    $0x5,%eax
  85:	89 c2                	mov    %eax,%edx
  87:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8a:	01 d0                	add    %edx,%eax
  }

  #ifdef CS333_P3P4
  printf(1, "PID\tName\tUID\tGID\tPPID\tPrio\tElapsed\tCPU\tState\tSize\n");
  for(int i = 0; i < running_procs; i++){
    printf(1, "%d\t%s\t%d\t%d\t%d\t%d\t", table[i].pid, table[i].name,
  8c:	8b 78 5c             	mov    0x5c(%eax),%edi
        table[i].uid, table[i].gid, table[i].ppid, table[i].priority);
  8f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  92:	89 d0                	mov    %edx,%eax
  94:	01 c0                	add    %eax,%eax
  96:	01 d0                	add    %edx,%eax
  98:	c1 e0 05             	shl    $0x5,%eax
  9b:	89 c2                	mov    %eax,%edx
  9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  a0:	01 d0                	add    %edx,%eax
  }

  #ifdef CS333_P3P4
  printf(1, "PID\tName\tUID\tGID\tPPID\tPrio\tElapsed\tCPU\tState\tSize\n");
  for(int i = 0; i < running_procs; i++){
    printf(1, "%d\t%s\t%d\t%d\t%d\t%d\t", table[i].pid, table[i].name,
  a2:	8b 70 0c             	mov    0xc(%eax),%esi
        table[i].uid, table[i].gid, table[i].ppid, table[i].priority);
  a5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  a8:	89 d0                	mov    %edx,%eax
  aa:	01 c0                	add    %eax,%eax
  ac:	01 d0                	add    %edx,%eax
  ae:	c1 e0 05             	shl    $0x5,%eax
  b1:	89 c2                	mov    %eax,%edx
  b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  b6:	01 d0                	add    %edx,%eax
  }

  #ifdef CS333_P3P4
  printf(1, "PID\tName\tUID\tGID\tPPID\tPrio\tElapsed\tCPU\tState\tSize\n");
  for(int i = 0; i < running_procs; i++){
    printf(1, "%d\t%s\t%d\t%d\t%d\t%d\t", table[i].pid, table[i].name,
  b8:	8b 58 08             	mov    0x8(%eax),%ebx
        table[i].uid, table[i].gid, table[i].ppid, table[i].priority);
  bb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  be:	89 d0                	mov    %edx,%eax
  c0:	01 c0                	add    %eax,%eax
  c2:	01 d0                	add    %edx,%eax
  c4:	c1 e0 05             	shl    $0x5,%eax
  c7:	89 c2                	mov    %eax,%edx
  c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  cc:	01 d0                	add    %edx,%eax
  }

  #ifdef CS333_P3P4
  printf(1, "PID\tName\tUID\tGID\tPPID\tPrio\tElapsed\tCPU\tState\tSize\n");
  for(int i = 0; i < running_procs; i++){
    printf(1, "%d\t%s\t%d\t%d\t%d\t%d\t", table[i].pid, table[i].name,
  ce:	8b 48 04             	mov    0x4(%eax),%ecx
  d1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  d4:	89 d0                	mov    %edx,%eax
  d6:	01 c0                	add    %eax,%eax
  d8:	01 d0                	add    %edx,%eax
  da:	c1 e0 05             	shl    $0x5,%eax
  dd:	89 c2                	mov    %eax,%edx
  df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  e2:	01 d0                	add    %edx,%eax
  e4:	83 c0 3c             	add    $0x3c,%eax
  e7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  ed:	89 d0                	mov    %edx,%eax
  ef:	01 c0                	add    %eax,%eax
  f1:	01 d0                	add    %edx,%eax
  f3:	c1 e0 05             	shl    $0x5,%eax
  f6:	89 c2                	mov    %eax,%edx
  f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  fb:	01 d0                	add    %edx,%eax
  fd:	8b 00                	mov    (%eax),%eax
  ff:	57                   	push   %edi
 100:	56                   	push   %esi
 101:	53                   	push   %ebx
 102:	51                   	push   %ecx
 103:	ff 75 d4             	pushl  -0x2c(%ebp)
 106:	50                   	push   %eax
 107:	68 c7 0a 00 00       	push   $0xac7
 10c:	6a 01                	push   $0x1
 10e:	e8 9a 05 00 00       	call   6ad <printf>
 113:	83 c4 20             	add    $0x20,%esp
        table[i].uid, table[i].gid, table[i].ppid, table[i].priority);
    calcelapsedtime(table[i].elapsed_ticks);
 116:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 119:	89 d0                	mov    %edx,%eax
 11b:	01 c0                	add    %eax,%eax
 11d:	01 d0                	add    %edx,%eax
 11f:	c1 e0 05             	shl    $0x5,%eax
 122:	89 c2                	mov    %eax,%edx
 124:	8b 45 e0             	mov    -0x20(%ebp),%eax
 127:	01 d0                	add    %edx,%eax
 129:	8b 40 10             	mov    0x10(%eax),%eax
 12c:	83 ec 0c             	sub    $0xc,%esp
 12f:	50                   	push   %eax
 130:	e8 85 00 00 00       	call   1ba <calcelapsedtime>
 135:	83 c4 10             	add    $0x10,%esp
    calcelapsedtime(table[i].CPU_total_ticks);
 138:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 13b:	89 d0                	mov    %edx,%eax
 13d:	01 c0                	add    %eax,%eax
 13f:	01 d0                	add    %edx,%eax
 141:	c1 e0 05             	shl    $0x5,%eax
 144:	89 c2                	mov    %eax,%edx
 146:	8b 45 e0             	mov    -0x20(%ebp),%eax
 149:	01 d0                	add    %edx,%eax
 14b:	8b 40 14             	mov    0x14(%eax),%eax
 14e:	83 ec 0c             	sub    $0xc,%esp
 151:	50                   	push   %eax
 152:	e8 63 00 00 00       	call   1ba <calcelapsedtime>
 157:	83 c4 10             	add    $0x10,%esp
    printf(1, "%s\t%d\n", table[i].state, table[i].size);
 15a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 15d:	89 d0                	mov    %edx,%eax
 15f:	01 c0                	add    %eax,%eax
 161:	01 d0                	add    %edx,%eax
 163:	c1 e0 05             	shl    $0x5,%eax
 166:	89 c2                	mov    %eax,%edx
 168:	8b 45 e0             	mov    -0x20(%ebp),%eax
 16b:	01 d0                	add    %edx,%eax
 16d:	8b 48 38             	mov    0x38(%eax),%ecx
 170:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 173:	89 d0                	mov    %edx,%eax
 175:	01 c0                	add    %eax,%eax
 177:	01 d0                	add    %edx,%eax
 179:	c1 e0 05             	shl    $0x5,%eax
 17c:	89 c2                	mov    %eax,%edx
 17e:	8b 45 e0             	mov    -0x20(%ebp),%eax
 181:	01 d0                	add    %edx,%eax
 183:	83 c0 18             	add    $0x18,%eax
 186:	51                   	push   %ecx
 187:	50                   	push   %eax
 188:	68 da 0a 00 00       	push   $0xada
 18d:	6a 01                	push   $0x1
 18f:	e8 19 05 00 00       	call   6ad <printf>
 194:	83 c4 10             	add    $0x10,%esp
    exit();
  }

  #ifdef CS333_P3P4
  printf(1, "PID\tName\tUID\tGID\tPPID\tPrio\tElapsed\tCPU\tState\tSize\n");
  for(int i = 0; i < running_procs; i++){
 197:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 19b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 19e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
 1a1:	0f 8c d2 fe ff ff    	jl     79 <main+0x79>
    calcelapsedtime(table[i].CPU_total_ticks);
    printf(1, "%s\t%d\n", table[i].state, table[i].size);
  }
  #endif

  free(table);
 1a7:	83 ec 0c             	sub    $0xc,%esp
 1aa:	ff 75 e0             	pushl  -0x20(%ebp)
 1ad:	e8 8c 06 00 00       	call   83e <free>
 1b2:	83 c4 10             	add    $0x10,%esp
  exit();
 1b5:	e8 34 03 00 00       	call   4ee <exit>

000001ba <calcelapsedtime>:

// Determines the seconds elapsed for a running process to the thousandth of a
// second and prints the result
void
calcelapsedtime(int ticks_in)
{
 1ba:	55                   	push   %ebp
 1bb:	89 e5                	mov    %esp,%ebp
 1bd:	83 ec 18             	sub    $0x18,%esp
  int seconds = (ticks_in)/1000;
 1c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1c3:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
 1c8:	89 c8                	mov    %ecx,%eax
 1ca:	f7 ea                	imul   %edx
 1cc:	c1 fa 06             	sar    $0x6,%edx
 1cf:	89 c8                	mov    %ecx,%eax
 1d1:	c1 f8 1f             	sar    $0x1f,%eax
 1d4:	29 c2                	sub    %eax,%edx
 1d6:	89 d0                	mov    %edx,%eax
 1d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int milliseconds = (ticks_in)%1000;
 1db:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1de:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
 1e3:	89 c8                	mov    %ecx,%eax
 1e5:	f7 ea                	imul   %edx
 1e7:	c1 fa 06             	sar    $0x6,%edx
 1ea:	89 c8                	mov    %ecx,%eax
 1ec:	c1 f8 1f             	sar    $0x1f,%eax
 1ef:	29 c2                	sub    %eax,%edx
 1f1:	89 d0                	mov    %edx,%eax
 1f3:	69 c0 e8 03 00 00    	imul   $0x3e8,%eax,%eax
 1f9:	29 c1                	sub    %eax,%ecx
 1fb:	89 c8                	mov    %ecx,%eax
 1fd:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(milliseconds < 10)
 200:	83 7d f0 09          	cmpl   $0x9,-0x10(%ebp)
 204:	7f 17                	jg     21d <calcelapsedtime+0x63>
    printf(1, "%d.00%d\t", seconds, milliseconds);
 206:	ff 75 f0             	pushl  -0x10(%ebp)
 209:	ff 75 f4             	pushl  -0xc(%ebp)
 20c:	68 e1 0a 00 00       	push   $0xae1
 211:	6a 01                	push   $0x1
 213:	e8 95 04 00 00       	call   6ad <printf>
 218:	83 c4 10             	add    $0x10,%esp
  else if(milliseconds < 100)
    printf(1, "%d.0%d\t", seconds, milliseconds);
  else
    printf(1, "%d.%d\t", seconds, milliseconds);
}
 21b:	eb 32                	jmp    24f <calcelapsedtime+0x95>
  int seconds = (ticks_in)/1000;
  int milliseconds = (ticks_in)%1000;

  if(milliseconds < 10)
    printf(1, "%d.00%d\t", seconds, milliseconds);
  else if(milliseconds < 100)
 21d:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
 221:	7f 17                	jg     23a <calcelapsedtime+0x80>
    printf(1, "%d.0%d\t", seconds, milliseconds);
 223:	ff 75 f0             	pushl  -0x10(%ebp)
 226:	ff 75 f4             	pushl  -0xc(%ebp)
 229:	68 ea 0a 00 00       	push   $0xaea
 22e:	6a 01                	push   $0x1
 230:	e8 78 04 00 00       	call   6ad <printf>
 235:	83 c4 10             	add    $0x10,%esp
  else
    printf(1, "%d.%d\t", seconds, milliseconds);
}
 238:	eb 15                	jmp    24f <calcelapsedtime+0x95>
  if(milliseconds < 10)
    printf(1, "%d.00%d\t", seconds, milliseconds);
  else if(milliseconds < 100)
    printf(1, "%d.0%d\t", seconds, milliseconds);
  else
    printf(1, "%d.%d\t", seconds, milliseconds);
 23a:	ff 75 f0             	pushl  -0x10(%ebp)
 23d:	ff 75 f4             	pushl  -0xc(%ebp)
 240:	68 f2 0a 00 00       	push   $0xaf2
 245:	6a 01                	push   $0x1
 247:	e8 61 04 00 00       	call   6ad <printf>
 24c:	83 c4 10             	add    $0x10,%esp
}
 24f:	90                   	nop
 250:	c9                   	leave  
 251:	c3                   	ret    

00000252 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 252:	55                   	push   %ebp
 253:	89 e5                	mov    %esp,%ebp
 255:	57                   	push   %edi
 256:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 257:	8b 4d 08             	mov    0x8(%ebp),%ecx
 25a:	8b 55 10             	mov    0x10(%ebp),%edx
 25d:	8b 45 0c             	mov    0xc(%ebp),%eax
 260:	89 cb                	mov    %ecx,%ebx
 262:	89 df                	mov    %ebx,%edi
 264:	89 d1                	mov    %edx,%ecx
 266:	fc                   	cld    
 267:	f3 aa                	rep stos %al,%es:(%edi)
 269:	89 ca                	mov    %ecx,%edx
 26b:	89 fb                	mov    %edi,%ebx
 26d:	89 5d 08             	mov    %ebx,0x8(%ebp)
 270:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 273:	90                   	nop
 274:	5b                   	pop    %ebx
 275:	5f                   	pop    %edi
 276:	5d                   	pop    %ebp
 277:	c3                   	ret    

00000278 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 278:	55                   	push   %ebp
 279:	89 e5                	mov    %esp,%ebp
 27b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 27e:	8b 45 08             	mov    0x8(%ebp),%eax
 281:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 284:	90                   	nop
 285:	8b 45 08             	mov    0x8(%ebp),%eax
 288:	8d 50 01             	lea    0x1(%eax),%edx
 28b:	89 55 08             	mov    %edx,0x8(%ebp)
 28e:	8b 55 0c             	mov    0xc(%ebp),%edx
 291:	8d 4a 01             	lea    0x1(%edx),%ecx
 294:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 297:	0f b6 12             	movzbl (%edx),%edx
 29a:	88 10                	mov    %dl,(%eax)
 29c:	0f b6 00             	movzbl (%eax),%eax
 29f:	84 c0                	test   %al,%al
 2a1:	75 e2                	jne    285 <strcpy+0xd>
    ;
  return os;
 2a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2a6:	c9                   	leave  
 2a7:	c3                   	ret    

000002a8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2a8:	55                   	push   %ebp
 2a9:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 2ab:	eb 08                	jmp    2b5 <strcmp+0xd>
    p++, q++;
 2ad:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2b1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 2b5:	8b 45 08             	mov    0x8(%ebp),%eax
 2b8:	0f b6 00             	movzbl (%eax),%eax
 2bb:	84 c0                	test   %al,%al
 2bd:	74 10                	je     2cf <strcmp+0x27>
 2bf:	8b 45 08             	mov    0x8(%ebp),%eax
 2c2:	0f b6 10             	movzbl (%eax),%edx
 2c5:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c8:	0f b6 00             	movzbl (%eax),%eax
 2cb:	38 c2                	cmp    %al,%dl
 2cd:	74 de                	je     2ad <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 2cf:	8b 45 08             	mov    0x8(%ebp),%eax
 2d2:	0f b6 00             	movzbl (%eax),%eax
 2d5:	0f b6 d0             	movzbl %al,%edx
 2d8:	8b 45 0c             	mov    0xc(%ebp),%eax
 2db:	0f b6 00             	movzbl (%eax),%eax
 2de:	0f b6 c0             	movzbl %al,%eax
 2e1:	29 c2                	sub    %eax,%edx
 2e3:	89 d0                	mov    %edx,%eax
}
 2e5:	5d                   	pop    %ebp
 2e6:	c3                   	ret    

000002e7 <strlen>:

uint
strlen(char *s)
{
 2e7:	55                   	push   %ebp
 2e8:	89 e5                	mov    %esp,%ebp
 2ea:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 2ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 2f4:	eb 04                	jmp    2fa <strlen+0x13>
 2f6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 2fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2fd:	8b 45 08             	mov    0x8(%ebp),%eax
 300:	01 d0                	add    %edx,%eax
 302:	0f b6 00             	movzbl (%eax),%eax
 305:	84 c0                	test   %al,%al
 307:	75 ed                	jne    2f6 <strlen+0xf>
    ;
  return n;
 309:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 30c:	c9                   	leave  
 30d:	c3                   	ret    

0000030e <memset>:

void*
memset(void *dst, int c, uint n)
{
 30e:	55                   	push   %ebp
 30f:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 311:	8b 45 10             	mov    0x10(%ebp),%eax
 314:	50                   	push   %eax
 315:	ff 75 0c             	pushl  0xc(%ebp)
 318:	ff 75 08             	pushl  0x8(%ebp)
 31b:	e8 32 ff ff ff       	call   252 <stosb>
 320:	83 c4 0c             	add    $0xc,%esp
  return dst;
 323:	8b 45 08             	mov    0x8(%ebp),%eax
}
 326:	c9                   	leave  
 327:	c3                   	ret    

00000328 <strchr>:

char*
strchr(const char *s, char c)
{
 328:	55                   	push   %ebp
 329:	89 e5                	mov    %esp,%ebp
 32b:	83 ec 04             	sub    $0x4,%esp
 32e:	8b 45 0c             	mov    0xc(%ebp),%eax
 331:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 334:	eb 14                	jmp    34a <strchr+0x22>
    if(*s == c)
 336:	8b 45 08             	mov    0x8(%ebp),%eax
 339:	0f b6 00             	movzbl (%eax),%eax
 33c:	3a 45 fc             	cmp    -0x4(%ebp),%al
 33f:	75 05                	jne    346 <strchr+0x1e>
      return (char*)s;
 341:	8b 45 08             	mov    0x8(%ebp),%eax
 344:	eb 13                	jmp    359 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 346:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 34a:	8b 45 08             	mov    0x8(%ebp),%eax
 34d:	0f b6 00             	movzbl (%eax),%eax
 350:	84 c0                	test   %al,%al
 352:	75 e2                	jne    336 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 354:	b8 00 00 00 00       	mov    $0x0,%eax
}
 359:	c9                   	leave  
 35a:	c3                   	ret    

0000035b <gets>:

char*
gets(char *buf, int max)
{
 35b:	55                   	push   %ebp
 35c:	89 e5                	mov    %esp,%ebp
 35e:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 361:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 368:	eb 42                	jmp    3ac <gets+0x51>
    cc = read(0, &c, 1);
 36a:	83 ec 04             	sub    $0x4,%esp
 36d:	6a 01                	push   $0x1
 36f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 372:	50                   	push   %eax
 373:	6a 00                	push   $0x0
 375:	e8 8c 01 00 00       	call   506 <read>
 37a:	83 c4 10             	add    $0x10,%esp
 37d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 380:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 384:	7e 33                	jle    3b9 <gets+0x5e>
      break;
    buf[i++] = c;
 386:	8b 45 f4             	mov    -0xc(%ebp),%eax
 389:	8d 50 01             	lea    0x1(%eax),%edx
 38c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 38f:	89 c2                	mov    %eax,%edx
 391:	8b 45 08             	mov    0x8(%ebp),%eax
 394:	01 c2                	add    %eax,%edx
 396:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 39a:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 39c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3a0:	3c 0a                	cmp    $0xa,%al
 3a2:	74 16                	je     3ba <gets+0x5f>
 3a4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3a8:	3c 0d                	cmp    $0xd,%al
 3aa:	74 0e                	je     3ba <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3af:	83 c0 01             	add    $0x1,%eax
 3b2:	3b 45 0c             	cmp    0xc(%ebp),%eax
 3b5:	7c b3                	jl     36a <gets+0xf>
 3b7:	eb 01                	jmp    3ba <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 3b9:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 3ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3bd:	8b 45 08             	mov    0x8(%ebp),%eax
 3c0:	01 d0                	add    %edx,%eax
 3c2:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 3c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3c8:	c9                   	leave  
 3c9:	c3                   	ret    

000003ca <stat>:

int
stat(char *n, struct stat *st)
{
 3ca:	55                   	push   %ebp
 3cb:	89 e5                	mov    %esp,%ebp
 3cd:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3d0:	83 ec 08             	sub    $0x8,%esp
 3d3:	6a 00                	push   $0x0
 3d5:	ff 75 08             	pushl  0x8(%ebp)
 3d8:	e8 51 01 00 00       	call   52e <open>
 3dd:	83 c4 10             	add    $0x10,%esp
 3e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 3e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3e7:	79 07                	jns    3f0 <stat+0x26>
    return -1;
 3e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3ee:	eb 25                	jmp    415 <stat+0x4b>
  r = fstat(fd, st);
 3f0:	83 ec 08             	sub    $0x8,%esp
 3f3:	ff 75 0c             	pushl  0xc(%ebp)
 3f6:	ff 75 f4             	pushl  -0xc(%ebp)
 3f9:	e8 48 01 00 00       	call   546 <fstat>
 3fe:	83 c4 10             	add    $0x10,%esp
 401:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 404:	83 ec 0c             	sub    $0xc,%esp
 407:	ff 75 f4             	pushl  -0xc(%ebp)
 40a:	e8 07 01 00 00       	call   516 <close>
 40f:	83 c4 10             	add    $0x10,%esp
  return r;
 412:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 415:	c9                   	leave  
 416:	c3                   	ret    

00000417 <atoi>:

int
atoi(const char *s)
{
 417:	55                   	push   %ebp
 418:	89 e5                	mov    %esp,%ebp
 41a:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 41d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 424:	eb 04                	jmp    42a <atoi+0x13>
 426:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 42a:	8b 45 08             	mov    0x8(%ebp),%eax
 42d:	0f b6 00             	movzbl (%eax),%eax
 430:	3c 20                	cmp    $0x20,%al
 432:	74 f2                	je     426 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 434:	8b 45 08             	mov    0x8(%ebp),%eax
 437:	0f b6 00             	movzbl (%eax),%eax
 43a:	3c 2d                	cmp    $0x2d,%al
 43c:	75 07                	jne    445 <atoi+0x2e>
 43e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 443:	eb 05                	jmp    44a <atoi+0x33>
 445:	b8 01 00 00 00       	mov    $0x1,%eax
 44a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 44d:	8b 45 08             	mov    0x8(%ebp),%eax
 450:	0f b6 00             	movzbl (%eax),%eax
 453:	3c 2b                	cmp    $0x2b,%al
 455:	74 0a                	je     461 <atoi+0x4a>
 457:	8b 45 08             	mov    0x8(%ebp),%eax
 45a:	0f b6 00             	movzbl (%eax),%eax
 45d:	3c 2d                	cmp    $0x2d,%al
 45f:	75 2b                	jne    48c <atoi+0x75>
    s++;
 461:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 465:	eb 25                	jmp    48c <atoi+0x75>
    n = n*10 + *s++ - '0';
 467:	8b 55 fc             	mov    -0x4(%ebp),%edx
 46a:	89 d0                	mov    %edx,%eax
 46c:	c1 e0 02             	shl    $0x2,%eax
 46f:	01 d0                	add    %edx,%eax
 471:	01 c0                	add    %eax,%eax
 473:	89 c1                	mov    %eax,%ecx
 475:	8b 45 08             	mov    0x8(%ebp),%eax
 478:	8d 50 01             	lea    0x1(%eax),%edx
 47b:	89 55 08             	mov    %edx,0x8(%ebp)
 47e:	0f b6 00             	movzbl (%eax),%eax
 481:	0f be c0             	movsbl %al,%eax
 484:	01 c8                	add    %ecx,%eax
 486:	83 e8 30             	sub    $0x30,%eax
 489:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 48c:	8b 45 08             	mov    0x8(%ebp),%eax
 48f:	0f b6 00             	movzbl (%eax),%eax
 492:	3c 2f                	cmp    $0x2f,%al
 494:	7e 0a                	jle    4a0 <atoi+0x89>
 496:	8b 45 08             	mov    0x8(%ebp),%eax
 499:	0f b6 00             	movzbl (%eax),%eax
 49c:	3c 39                	cmp    $0x39,%al
 49e:	7e c7                	jle    467 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 4a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 4a3:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 4a7:	c9                   	leave  
 4a8:	c3                   	ret    

000004a9 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 4a9:	55                   	push   %ebp
 4aa:	89 e5                	mov    %esp,%ebp
 4ac:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 4af:	8b 45 08             	mov    0x8(%ebp),%eax
 4b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 4b5:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 4bb:	eb 17                	jmp    4d4 <memmove+0x2b>
    *dst++ = *src++;
 4bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4c0:	8d 50 01             	lea    0x1(%eax),%edx
 4c3:	89 55 fc             	mov    %edx,-0x4(%ebp)
 4c6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 4c9:	8d 4a 01             	lea    0x1(%edx),%ecx
 4cc:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 4cf:	0f b6 12             	movzbl (%edx),%edx
 4d2:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4d4:	8b 45 10             	mov    0x10(%ebp),%eax
 4d7:	8d 50 ff             	lea    -0x1(%eax),%edx
 4da:	89 55 10             	mov    %edx,0x10(%ebp)
 4dd:	85 c0                	test   %eax,%eax
 4df:	7f dc                	jg     4bd <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 4e1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4e4:	c9                   	leave  
 4e5:	c3                   	ret    

000004e6 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4e6:	b8 01 00 00 00       	mov    $0x1,%eax
 4eb:	cd 40                	int    $0x40
 4ed:	c3                   	ret    

000004ee <exit>:
SYSCALL(exit)
 4ee:	b8 02 00 00 00       	mov    $0x2,%eax
 4f3:	cd 40                	int    $0x40
 4f5:	c3                   	ret    

000004f6 <wait>:
SYSCALL(wait)
 4f6:	b8 03 00 00 00       	mov    $0x3,%eax
 4fb:	cd 40                	int    $0x40
 4fd:	c3                   	ret    

000004fe <pipe>:
SYSCALL(pipe)
 4fe:	b8 04 00 00 00       	mov    $0x4,%eax
 503:	cd 40                	int    $0x40
 505:	c3                   	ret    

00000506 <read>:
SYSCALL(read)
 506:	b8 05 00 00 00       	mov    $0x5,%eax
 50b:	cd 40                	int    $0x40
 50d:	c3                   	ret    

0000050e <write>:
SYSCALL(write)
 50e:	b8 10 00 00 00       	mov    $0x10,%eax
 513:	cd 40                	int    $0x40
 515:	c3                   	ret    

00000516 <close>:
SYSCALL(close)
 516:	b8 15 00 00 00       	mov    $0x15,%eax
 51b:	cd 40                	int    $0x40
 51d:	c3                   	ret    

0000051e <kill>:
SYSCALL(kill)
 51e:	b8 06 00 00 00       	mov    $0x6,%eax
 523:	cd 40                	int    $0x40
 525:	c3                   	ret    

00000526 <exec>:
SYSCALL(exec)
 526:	b8 07 00 00 00       	mov    $0x7,%eax
 52b:	cd 40                	int    $0x40
 52d:	c3                   	ret    

0000052e <open>:
SYSCALL(open)
 52e:	b8 0f 00 00 00       	mov    $0xf,%eax
 533:	cd 40                	int    $0x40
 535:	c3                   	ret    

00000536 <mknod>:
SYSCALL(mknod)
 536:	b8 11 00 00 00       	mov    $0x11,%eax
 53b:	cd 40                	int    $0x40
 53d:	c3                   	ret    

0000053e <unlink>:
SYSCALL(unlink)
 53e:	b8 12 00 00 00       	mov    $0x12,%eax
 543:	cd 40                	int    $0x40
 545:	c3                   	ret    

00000546 <fstat>:
SYSCALL(fstat)
 546:	b8 08 00 00 00       	mov    $0x8,%eax
 54b:	cd 40                	int    $0x40
 54d:	c3                   	ret    

0000054e <link>:
SYSCALL(link)
 54e:	b8 13 00 00 00       	mov    $0x13,%eax
 553:	cd 40                	int    $0x40
 555:	c3                   	ret    

00000556 <mkdir>:
SYSCALL(mkdir)
 556:	b8 14 00 00 00       	mov    $0x14,%eax
 55b:	cd 40                	int    $0x40
 55d:	c3                   	ret    

0000055e <chdir>:
SYSCALL(chdir)
 55e:	b8 09 00 00 00       	mov    $0x9,%eax
 563:	cd 40                	int    $0x40
 565:	c3                   	ret    

00000566 <dup>:
SYSCALL(dup)
 566:	b8 0a 00 00 00       	mov    $0xa,%eax
 56b:	cd 40                	int    $0x40
 56d:	c3                   	ret    

0000056e <getpid>:
SYSCALL(getpid)
 56e:	b8 0b 00 00 00       	mov    $0xb,%eax
 573:	cd 40                	int    $0x40
 575:	c3                   	ret    

00000576 <sbrk>:
SYSCALL(sbrk)
 576:	b8 0c 00 00 00       	mov    $0xc,%eax
 57b:	cd 40                	int    $0x40
 57d:	c3                   	ret    

0000057e <sleep>:
SYSCALL(sleep)
 57e:	b8 0d 00 00 00       	mov    $0xd,%eax
 583:	cd 40                	int    $0x40
 585:	c3                   	ret    

00000586 <uptime>:
SYSCALL(uptime)
 586:	b8 0e 00 00 00       	mov    $0xe,%eax
 58b:	cd 40                	int    $0x40
 58d:	c3                   	ret    

0000058e <halt>:
SYSCALL(halt)
 58e:	b8 16 00 00 00       	mov    $0x16,%eax
 593:	cd 40                	int    $0x40
 595:	c3                   	ret    

00000596 <date>:
SYSCALL(date)
 596:	b8 17 00 00 00       	mov    $0x17,%eax
 59b:	cd 40                	int    $0x40
 59d:	c3                   	ret    

0000059e <getuid>:
SYSCALL(getuid)
 59e:	b8 18 00 00 00       	mov    $0x18,%eax
 5a3:	cd 40                	int    $0x40
 5a5:	c3                   	ret    

000005a6 <getgid>:
SYSCALL(getgid)
 5a6:	b8 19 00 00 00       	mov    $0x19,%eax
 5ab:	cd 40                	int    $0x40
 5ad:	c3                   	ret    

000005ae <getppid>:
SYSCALL(getppid)
 5ae:	b8 1a 00 00 00       	mov    $0x1a,%eax
 5b3:	cd 40                	int    $0x40
 5b5:	c3                   	ret    

000005b6 <setuid>:
SYSCALL(setuid)
 5b6:	b8 1b 00 00 00       	mov    $0x1b,%eax
 5bb:	cd 40                	int    $0x40
 5bd:	c3                   	ret    

000005be <setgid>:
SYSCALL(setgid)
 5be:	b8 1c 00 00 00       	mov    $0x1c,%eax
 5c3:	cd 40                	int    $0x40
 5c5:	c3                   	ret    

000005c6 <getprocs>:
SYSCALL(getprocs)
 5c6:	b8 1d 00 00 00       	mov    $0x1d,%eax
 5cb:	cd 40                	int    $0x40
 5cd:	c3                   	ret    

000005ce <setpriority>:
SYSCALL(setpriority)
 5ce:	b8 1e 00 00 00       	mov    $0x1e,%eax
 5d3:	cd 40                	int    $0x40
 5d5:	c3                   	ret    

000005d6 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 5d6:	55                   	push   %ebp
 5d7:	89 e5                	mov    %esp,%ebp
 5d9:	83 ec 18             	sub    $0x18,%esp
 5dc:	8b 45 0c             	mov    0xc(%ebp),%eax
 5df:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 5e2:	83 ec 04             	sub    $0x4,%esp
 5e5:	6a 01                	push   $0x1
 5e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
 5ea:	50                   	push   %eax
 5eb:	ff 75 08             	pushl  0x8(%ebp)
 5ee:	e8 1b ff ff ff       	call   50e <write>
 5f3:	83 c4 10             	add    $0x10,%esp
}
 5f6:	90                   	nop
 5f7:	c9                   	leave  
 5f8:	c3                   	ret    

000005f9 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5f9:	55                   	push   %ebp
 5fa:	89 e5                	mov    %esp,%ebp
 5fc:	53                   	push   %ebx
 5fd:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 600:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 607:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 60b:	74 17                	je     624 <printint+0x2b>
 60d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 611:	79 11                	jns    624 <printint+0x2b>
    neg = 1;
 613:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 61a:	8b 45 0c             	mov    0xc(%ebp),%eax
 61d:	f7 d8                	neg    %eax
 61f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 622:	eb 06                	jmp    62a <printint+0x31>
  } else {
    x = xx;
 624:	8b 45 0c             	mov    0xc(%ebp),%eax
 627:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 62a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 631:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 634:	8d 41 01             	lea    0x1(%ecx),%eax
 637:	89 45 f4             	mov    %eax,-0xc(%ebp)
 63a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 63d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 640:	ba 00 00 00 00       	mov    $0x0,%edx
 645:	f7 f3                	div    %ebx
 647:	89 d0                	mov    %edx,%eax
 649:	0f b6 80 74 0d 00 00 	movzbl 0xd74(%eax),%eax
 650:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 654:	8b 5d 10             	mov    0x10(%ebp),%ebx
 657:	8b 45 ec             	mov    -0x14(%ebp),%eax
 65a:	ba 00 00 00 00       	mov    $0x0,%edx
 65f:	f7 f3                	div    %ebx
 661:	89 45 ec             	mov    %eax,-0x14(%ebp)
 664:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 668:	75 c7                	jne    631 <printint+0x38>
  if(neg)
 66a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 66e:	74 2d                	je     69d <printint+0xa4>
    buf[i++] = '-';
 670:	8b 45 f4             	mov    -0xc(%ebp),%eax
 673:	8d 50 01             	lea    0x1(%eax),%edx
 676:	89 55 f4             	mov    %edx,-0xc(%ebp)
 679:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 67e:	eb 1d                	jmp    69d <printint+0xa4>
    putc(fd, buf[i]);
 680:	8d 55 dc             	lea    -0x24(%ebp),%edx
 683:	8b 45 f4             	mov    -0xc(%ebp),%eax
 686:	01 d0                	add    %edx,%eax
 688:	0f b6 00             	movzbl (%eax),%eax
 68b:	0f be c0             	movsbl %al,%eax
 68e:	83 ec 08             	sub    $0x8,%esp
 691:	50                   	push   %eax
 692:	ff 75 08             	pushl  0x8(%ebp)
 695:	e8 3c ff ff ff       	call   5d6 <putc>
 69a:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 69d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 6a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6a5:	79 d9                	jns    680 <printint+0x87>
    putc(fd, buf[i]);
}
 6a7:	90                   	nop
 6a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6ab:	c9                   	leave  
 6ac:	c3                   	ret    

000006ad <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6ad:	55                   	push   %ebp
 6ae:	89 e5                	mov    %esp,%ebp
 6b0:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 6b3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 6ba:	8d 45 0c             	lea    0xc(%ebp),%eax
 6bd:	83 c0 04             	add    $0x4,%eax
 6c0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 6c3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 6ca:	e9 59 01 00 00       	jmp    828 <printf+0x17b>
    c = fmt[i] & 0xff;
 6cf:	8b 55 0c             	mov    0xc(%ebp),%edx
 6d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6d5:	01 d0                	add    %edx,%eax
 6d7:	0f b6 00             	movzbl (%eax),%eax
 6da:	0f be c0             	movsbl %al,%eax
 6dd:	25 ff 00 00 00       	and    $0xff,%eax
 6e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 6e5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6e9:	75 2c                	jne    717 <printf+0x6a>
      if(c == '%'){
 6eb:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6ef:	75 0c                	jne    6fd <printf+0x50>
        state = '%';
 6f1:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 6f8:	e9 27 01 00 00       	jmp    824 <printf+0x177>
      } else {
        putc(fd, c);
 6fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 700:	0f be c0             	movsbl %al,%eax
 703:	83 ec 08             	sub    $0x8,%esp
 706:	50                   	push   %eax
 707:	ff 75 08             	pushl  0x8(%ebp)
 70a:	e8 c7 fe ff ff       	call   5d6 <putc>
 70f:	83 c4 10             	add    $0x10,%esp
 712:	e9 0d 01 00 00       	jmp    824 <printf+0x177>
      }
    } else if(state == '%'){
 717:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 71b:	0f 85 03 01 00 00    	jne    824 <printf+0x177>
      if(c == 'd'){
 721:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 725:	75 1e                	jne    745 <printf+0x98>
        printint(fd, *ap, 10, 1);
 727:	8b 45 e8             	mov    -0x18(%ebp),%eax
 72a:	8b 00                	mov    (%eax),%eax
 72c:	6a 01                	push   $0x1
 72e:	6a 0a                	push   $0xa
 730:	50                   	push   %eax
 731:	ff 75 08             	pushl  0x8(%ebp)
 734:	e8 c0 fe ff ff       	call   5f9 <printint>
 739:	83 c4 10             	add    $0x10,%esp
        ap++;
 73c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 740:	e9 d8 00 00 00       	jmp    81d <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 745:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 749:	74 06                	je     751 <printf+0xa4>
 74b:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 74f:	75 1e                	jne    76f <printf+0xc2>
        printint(fd, *ap, 16, 0);
 751:	8b 45 e8             	mov    -0x18(%ebp),%eax
 754:	8b 00                	mov    (%eax),%eax
 756:	6a 00                	push   $0x0
 758:	6a 10                	push   $0x10
 75a:	50                   	push   %eax
 75b:	ff 75 08             	pushl  0x8(%ebp)
 75e:	e8 96 fe ff ff       	call   5f9 <printint>
 763:	83 c4 10             	add    $0x10,%esp
        ap++;
 766:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 76a:	e9 ae 00 00 00       	jmp    81d <printf+0x170>
      } else if(c == 's'){
 76f:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 773:	75 43                	jne    7b8 <printf+0x10b>
        s = (char*)*ap;
 775:	8b 45 e8             	mov    -0x18(%ebp),%eax
 778:	8b 00                	mov    (%eax),%eax
 77a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 77d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 781:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 785:	75 25                	jne    7ac <printf+0xff>
          s = "(null)";
 787:	c7 45 f4 f9 0a 00 00 	movl   $0xaf9,-0xc(%ebp)
        while(*s != 0){
 78e:	eb 1c                	jmp    7ac <printf+0xff>
          putc(fd, *s);
 790:	8b 45 f4             	mov    -0xc(%ebp),%eax
 793:	0f b6 00             	movzbl (%eax),%eax
 796:	0f be c0             	movsbl %al,%eax
 799:	83 ec 08             	sub    $0x8,%esp
 79c:	50                   	push   %eax
 79d:	ff 75 08             	pushl  0x8(%ebp)
 7a0:	e8 31 fe ff ff       	call   5d6 <putc>
 7a5:	83 c4 10             	add    $0x10,%esp
          s++;
 7a8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7af:	0f b6 00             	movzbl (%eax),%eax
 7b2:	84 c0                	test   %al,%al
 7b4:	75 da                	jne    790 <printf+0xe3>
 7b6:	eb 65                	jmp    81d <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7b8:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 7bc:	75 1d                	jne    7db <printf+0x12e>
        putc(fd, *ap);
 7be:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7c1:	8b 00                	mov    (%eax),%eax
 7c3:	0f be c0             	movsbl %al,%eax
 7c6:	83 ec 08             	sub    $0x8,%esp
 7c9:	50                   	push   %eax
 7ca:	ff 75 08             	pushl  0x8(%ebp)
 7cd:	e8 04 fe ff ff       	call   5d6 <putc>
 7d2:	83 c4 10             	add    $0x10,%esp
        ap++;
 7d5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7d9:	eb 42                	jmp    81d <printf+0x170>
      } else if(c == '%'){
 7db:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7df:	75 17                	jne    7f8 <printf+0x14b>
        putc(fd, c);
 7e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7e4:	0f be c0             	movsbl %al,%eax
 7e7:	83 ec 08             	sub    $0x8,%esp
 7ea:	50                   	push   %eax
 7eb:	ff 75 08             	pushl  0x8(%ebp)
 7ee:	e8 e3 fd ff ff       	call   5d6 <putc>
 7f3:	83 c4 10             	add    $0x10,%esp
 7f6:	eb 25                	jmp    81d <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7f8:	83 ec 08             	sub    $0x8,%esp
 7fb:	6a 25                	push   $0x25
 7fd:	ff 75 08             	pushl  0x8(%ebp)
 800:	e8 d1 fd ff ff       	call   5d6 <putc>
 805:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 808:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 80b:	0f be c0             	movsbl %al,%eax
 80e:	83 ec 08             	sub    $0x8,%esp
 811:	50                   	push   %eax
 812:	ff 75 08             	pushl  0x8(%ebp)
 815:	e8 bc fd ff ff       	call   5d6 <putc>
 81a:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 81d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 824:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 828:	8b 55 0c             	mov    0xc(%ebp),%edx
 82b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 82e:	01 d0                	add    %edx,%eax
 830:	0f b6 00             	movzbl (%eax),%eax
 833:	84 c0                	test   %al,%al
 835:	0f 85 94 fe ff ff    	jne    6cf <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 83b:	90                   	nop
 83c:	c9                   	leave  
 83d:	c3                   	ret    

0000083e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 83e:	55                   	push   %ebp
 83f:	89 e5                	mov    %esp,%ebp
 841:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 844:	8b 45 08             	mov    0x8(%ebp),%eax
 847:	83 e8 08             	sub    $0x8,%eax
 84a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 84d:	a1 90 0d 00 00       	mov    0xd90,%eax
 852:	89 45 fc             	mov    %eax,-0x4(%ebp)
 855:	eb 24                	jmp    87b <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 857:	8b 45 fc             	mov    -0x4(%ebp),%eax
 85a:	8b 00                	mov    (%eax),%eax
 85c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 85f:	77 12                	ja     873 <free+0x35>
 861:	8b 45 f8             	mov    -0x8(%ebp),%eax
 864:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 867:	77 24                	ja     88d <free+0x4f>
 869:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86c:	8b 00                	mov    (%eax),%eax
 86e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 871:	77 1a                	ja     88d <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 873:	8b 45 fc             	mov    -0x4(%ebp),%eax
 876:	8b 00                	mov    (%eax),%eax
 878:	89 45 fc             	mov    %eax,-0x4(%ebp)
 87b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 87e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 881:	76 d4                	jbe    857 <free+0x19>
 883:	8b 45 fc             	mov    -0x4(%ebp),%eax
 886:	8b 00                	mov    (%eax),%eax
 888:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 88b:	76 ca                	jbe    857 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 88d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 890:	8b 40 04             	mov    0x4(%eax),%eax
 893:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 89a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 89d:	01 c2                	add    %eax,%edx
 89f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a2:	8b 00                	mov    (%eax),%eax
 8a4:	39 c2                	cmp    %eax,%edx
 8a6:	75 24                	jne    8cc <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 8a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ab:	8b 50 04             	mov    0x4(%eax),%edx
 8ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b1:	8b 00                	mov    (%eax),%eax
 8b3:	8b 40 04             	mov    0x4(%eax),%eax
 8b6:	01 c2                	add    %eax,%edx
 8b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8bb:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 8be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c1:	8b 00                	mov    (%eax),%eax
 8c3:	8b 10                	mov    (%eax),%edx
 8c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8c8:	89 10                	mov    %edx,(%eax)
 8ca:	eb 0a                	jmp    8d6 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 8cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8cf:	8b 10                	mov    (%eax),%edx
 8d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8d4:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 8d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d9:	8b 40 04             	mov    0x4(%eax),%eax
 8dc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e6:	01 d0                	add    %edx,%eax
 8e8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8eb:	75 20                	jne    90d <free+0xcf>
    p->s.size += bp->s.size;
 8ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f0:	8b 50 04             	mov    0x4(%eax),%edx
 8f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8f6:	8b 40 04             	mov    0x4(%eax),%eax
 8f9:	01 c2                	add    %eax,%edx
 8fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8fe:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 901:	8b 45 f8             	mov    -0x8(%ebp),%eax
 904:	8b 10                	mov    (%eax),%edx
 906:	8b 45 fc             	mov    -0x4(%ebp),%eax
 909:	89 10                	mov    %edx,(%eax)
 90b:	eb 08                	jmp    915 <free+0xd7>
  } else
    p->s.ptr = bp;
 90d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 910:	8b 55 f8             	mov    -0x8(%ebp),%edx
 913:	89 10                	mov    %edx,(%eax)
  freep = p;
 915:	8b 45 fc             	mov    -0x4(%ebp),%eax
 918:	a3 90 0d 00 00       	mov    %eax,0xd90
}
 91d:	90                   	nop
 91e:	c9                   	leave  
 91f:	c3                   	ret    

00000920 <morecore>:

static Header*
morecore(uint nu)
{
 920:	55                   	push   %ebp
 921:	89 e5                	mov    %esp,%ebp
 923:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 926:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 92d:	77 07                	ja     936 <morecore+0x16>
    nu = 4096;
 92f:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 936:	8b 45 08             	mov    0x8(%ebp),%eax
 939:	c1 e0 03             	shl    $0x3,%eax
 93c:	83 ec 0c             	sub    $0xc,%esp
 93f:	50                   	push   %eax
 940:	e8 31 fc ff ff       	call   576 <sbrk>
 945:	83 c4 10             	add    $0x10,%esp
 948:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 94b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 94f:	75 07                	jne    958 <morecore+0x38>
    return 0;
 951:	b8 00 00 00 00       	mov    $0x0,%eax
 956:	eb 26                	jmp    97e <morecore+0x5e>
  hp = (Header*)p;
 958:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 95e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 961:	8b 55 08             	mov    0x8(%ebp),%edx
 964:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 967:	8b 45 f0             	mov    -0x10(%ebp),%eax
 96a:	83 c0 08             	add    $0x8,%eax
 96d:	83 ec 0c             	sub    $0xc,%esp
 970:	50                   	push   %eax
 971:	e8 c8 fe ff ff       	call   83e <free>
 976:	83 c4 10             	add    $0x10,%esp
  return freep;
 979:	a1 90 0d 00 00       	mov    0xd90,%eax
}
 97e:	c9                   	leave  
 97f:	c3                   	ret    

00000980 <malloc>:

void*
malloc(uint nbytes)
{
 980:	55                   	push   %ebp
 981:	89 e5                	mov    %esp,%ebp
 983:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 986:	8b 45 08             	mov    0x8(%ebp),%eax
 989:	83 c0 07             	add    $0x7,%eax
 98c:	c1 e8 03             	shr    $0x3,%eax
 98f:	83 c0 01             	add    $0x1,%eax
 992:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 995:	a1 90 0d 00 00       	mov    0xd90,%eax
 99a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 99d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9a1:	75 23                	jne    9c6 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 9a3:	c7 45 f0 88 0d 00 00 	movl   $0xd88,-0x10(%ebp)
 9aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9ad:	a3 90 0d 00 00       	mov    %eax,0xd90
 9b2:	a1 90 0d 00 00       	mov    0xd90,%eax
 9b7:	a3 88 0d 00 00       	mov    %eax,0xd88
    base.s.size = 0;
 9bc:	c7 05 8c 0d 00 00 00 	movl   $0x0,0xd8c
 9c3:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9c9:	8b 00                	mov    (%eax),%eax
 9cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d1:	8b 40 04             	mov    0x4(%eax),%eax
 9d4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9d7:	72 4d                	jb     a26 <malloc+0xa6>
      if(p->s.size == nunits)
 9d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9dc:	8b 40 04             	mov    0x4(%eax),%eax
 9df:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9e2:	75 0c                	jne    9f0 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 9e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e7:	8b 10                	mov    (%eax),%edx
 9e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9ec:	89 10                	mov    %edx,(%eax)
 9ee:	eb 26                	jmp    a16 <malloc+0x96>
      else {
        p->s.size -= nunits;
 9f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f3:	8b 40 04             	mov    0x4(%eax),%eax
 9f6:	2b 45 ec             	sub    -0x14(%ebp),%eax
 9f9:	89 c2                	mov    %eax,%edx
 9fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9fe:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a04:	8b 40 04             	mov    0x4(%eax),%eax
 a07:	c1 e0 03             	shl    $0x3,%eax
 a0a:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a10:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a13:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a16:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a19:	a3 90 0d 00 00       	mov    %eax,0xd90
      return (void*)(p + 1);
 a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a21:	83 c0 08             	add    $0x8,%eax
 a24:	eb 3b                	jmp    a61 <malloc+0xe1>
    }
    if(p == freep)
 a26:	a1 90 0d 00 00       	mov    0xd90,%eax
 a2b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a2e:	75 1e                	jne    a4e <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a30:	83 ec 0c             	sub    $0xc,%esp
 a33:	ff 75 ec             	pushl  -0x14(%ebp)
 a36:	e8 e5 fe ff ff       	call   920 <morecore>
 a3b:	83 c4 10             	add    $0x10,%esp
 a3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a45:	75 07                	jne    a4e <malloc+0xce>
        return 0;
 a47:	b8 00 00 00 00       	mov    $0x0,%eax
 a4c:	eb 13                	jmp    a61 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a51:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a57:	8b 00                	mov    (%eax),%eax
 a59:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a5c:	e9 6d ff ff ff       	jmp    9ce <malloc+0x4e>
}
 a61:	c9                   	leave  
 a62:	c3                   	ret    
