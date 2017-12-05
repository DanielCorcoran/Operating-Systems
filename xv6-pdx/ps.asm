
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
  11:	83 ec 18             	sub    $0x18,%esp
  int running_procs;

  struct uproc* table = malloc(sizeof(struct uproc)*UPROC_TABLE_MAX);
  14:	83 ec 0c             	sub    $0xc,%esp
  17:	68 00 18 00 00       	push   $0x1800
  1c:	e8 ec 09 00 00       	call   a0d <malloc>
  21:	83 c4 10             	add    $0x10,%esp
  24:	89 45 e0             	mov    %eax,-0x20(%ebp)

  running_procs = getprocs(UPROC_TABLE_MAX, table);
  27:	83 ec 08             	sub    $0x8,%esp
  2a:	ff 75 e0             	pushl  -0x20(%ebp)
  2d:	6a 40                	push   $0x40
  2f:	e8 07 06 00 00       	call   63b <getprocs>
  34:	83 c4 10             	add    $0x10,%esp
  37:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(running_procs == 0) {
  3a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  3e:	75 1b                	jne    5b <main+0x5b>
    printf(2, "Error: ps call failed.  %s at line %d\n", __FILE__, __LINE__);
  40:	6a 11                	push   $0x11
  42:	68 f0 0a 00 00       	push   $0xaf0
  47:	68 f8 0a 00 00       	push   $0xaf8
  4c:	6a 02                	push   $0x2
  4e:	e8 e7 06 00 00       	call   73a <printf>
  53:	83 c4 10             	add    $0x10,%esp
    exit();
  56:	e8 08 05 00 00       	call   563 <exit>
    calcelapsedtime(table[i].elapsed_ticks);
    calcelapsedtime(table[i].CPU_total_ticks);
    printf(1, "%s\t%d\n", table[i].state, table[i].size);
  }
  #else
  printf(1, "PID\tName\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\n");
  5b:	83 ec 08             	sub    $0x8,%esp
  5e:	68 20 0b 00 00       	push   $0xb20
  63:	6a 01                	push   $0x1
  65:	e8 d0 06 00 00       	call   73a <printf>
  6a:	83 c4 10             	add    $0x10,%esp
  for(int i = 0; i < running_procs; i++){
  6d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  74:	e9 09 01 00 00       	jmp    182 <main+0x182>
    printf(1, "%d\t%s\t%d\t%d\t%d\t", table[i].pid, table[i].name,
        table[i].uid, table[i].gid, table[i].ppid);
  79:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  7c:	89 d0                	mov    %edx,%eax
  7e:	01 c0                	add    %eax,%eax
  80:	01 d0                	add    %edx,%eax
  82:	c1 e0 05             	shl    $0x5,%eax
  85:	89 c2                	mov    %eax,%edx
  87:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8a:	01 d0                	add    %edx,%eax
    printf(1, "%s\t%d\n", table[i].state, table[i].size);
  }
  #else
  printf(1, "PID\tName\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\n");
  for(int i = 0; i < running_procs; i++){
    printf(1, "%d\t%s\t%d\t%d\t%d\t", table[i].pid, table[i].name,
  8c:	8b 70 0c             	mov    0xc(%eax),%esi
        table[i].uid, table[i].gid, table[i].ppid);
  8f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  92:	89 d0                	mov    %edx,%eax
  94:	01 c0                	add    %eax,%eax
  96:	01 d0                	add    %edx,%eax
  98:	c1 e0 05             	shl    $0x5,%eax
  9b:	89 c2                	mov    %eax,%edx
  9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  a0:	01 d0                	add    %edx,%eax
    printf(1, "%s\t%d\n", table[i].state, table[i].size);
  }
  #else
  printf(1, "PID\tName\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\n");
  for(int i = 0; i < running_procs; i++){
    printf(1, "%d\t%s\t%d\t%d\t%d\t", table[i].pid, table[i].name,
  a2:	8b 58 08             	mov    0x8(%eax),%ebx
        table[i].uid, table[i].gid, table[i].ppid);
  a5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  a8:	89 d0                	mov    %edx,%eax
  aa:	01 c0                	add    %eax,%eax
  ac:	01 d0                	add    %edx,%eax
  ae:	c1 e0 05             	shl    $0x5,%eax
  b1:	89 c2                	mov    %eax,%edx
  b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  b6:	01 d0                	add    %edx,%eax
    printf(1, "%s\t%d\n", table[i].state, table[i].size);
  }
  #else
  printf(1, "PID\tName\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\n");
  for(int i = 0; i < running_procs; i++){
    printf(1, "%d\t%s\t%d\t%d\t%d\t", table[i].pid, table[i].name,
  b8:	8b 48 04             	mov    0x4(%eax),%ecx
  bb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  be:	89 d0                	mov    %edx,%eax
  c0:	01 c0                	add    %eax,%eax
  c2:	01 d0                	add    %edx,%eax
  c4:	c1 e0 05             	shl    $0x5,%eax
  c7:	89 c2                	mov    %eax,%edx
  c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  cc:	01 d0                	add    %edx,%eax
  ce:	8d 78 3c             	lea    0x3c(%eax),%edi
  d1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  d4:	89 d0                	mov    %edx,%eax
  d6:	01 c0                	add    %eax,%eax
  d8:	01 d0                	add    %edx,%eax
  da:	c1 e0 05             	shl    $0x5,%eax
  dd:	89 c2                	mov    %eax,%edx
  df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  e2:	01 d0                	add    %edx,%eax
  e4:	8b 00                	mov    (%eax),%eax
  e6:	83 ec 04             	sub    $0x4,%esp
  e9:	56                   	push   %esi
  ea:	53                   	push   %ebx
  eb:	51                   	push   %ecx
  ec:	57                   	push   %edi
  ed:	50                   	push   %eax
  ee:	68 4e 0b 00 00       	push   $0xb4e
  f3:	6a 01                	push   $0x1
  f5:	e8 40 06 00 00       	call   73a <printf>
  fa:	83 c4 20             	add    $0x20,%esp
        table[i].uid, table[i].gid, table[i].ppid);
    calcelapsedtime(table[i].elapsed_ticks);
  fd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 100:	89 d0                	mov    %edx,%eax
 102:	01 c0                	add    %eax,%eax
 104:	01 d0                	add    %edx,%eax
 106:	c1 e0 05             	shl    $0x5,%eax
 109:	89 c2                	mov    %eax,%edx
 10b:	8b 45 e0             	mov    -0x20(%ebp),%eax
 10e:	01 d0                	add    %edx,%eax
 110:	8b 40 10             	mov    0x10(%eax),%eax
 113:	83 ec 0c             	sub    $0xc,%esp
 116:	50                   	push   %eax
 117:	e8 85 00 00 00       	call   1a1 <calcelapsedtime>
 11c:	83 c4 10             	add    $0x10,%esp
    calcelapsedtime(table[i].CPU_total_ticks);
 11f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 122:	89 d0                	mov    %edx,%eax
 124:	01 c0                	add    %eax,%eax
 126:	01 d0                	add    %edx,%eax
 128:	c1 e0 05             	shl    $0x5,%eax
 12b:	89 c2                	mov    %eax,%edx
 12d:	8b 45 e0             	mov    -0x20(%ebp),%eax
 130:	01 d0                	add    %edx,%eax
 132:	8b 40 14             	mov    0x14(%eax),%eax
 135:	83 ec 0c             	sub    $0xc,%esp
 138:	50                   	push   %eax
 139:	e8 63 00 00 00       	call   1a1 <calcelapsedtime>
 13e:	83 c4 10             	add    $0x10,%esp
    printf(1, "%s\t%d\n", table[i].state, table[i].size);
 141:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 144:	89 d0                	mov    %edx,%eax
 146:	01 c0                	add    %eax,%eax
 148:	01 d0                	add    %edx,%eax
 14a:	c1 e0 05             	shl    $0x5,%eax
 14d:	89 c2                	mov    %eax,%edx
 14f:	8b 45 e0             	mov    -0x20(%ebp),%eax
 152:	01 d0                	add    %edx,%eax
 154:	8b 48 38             	mov    0x38(%eax),%ecx
 157:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 15a:	89 d0                	mov    %edx,%eax
 15c:	01 c0                	add    %eax,%eax
 15e:	01 d0                	add    %edx,%eax
 160:	c1 e0 05             	shl    $0x5,%eax
 163:	89 c2                	mov    %eax,%edx
 165:	8b 45 e0             	mov    -0x20(%ebp),%eax
 168:	01 d0                	add    %edx,%eax
 16a:	83 c0 18             	add    $0x18,%eax
 16d:	51                   	push   %ecx
 16e:	50                   	push   %eax
 16f:	68 5e 0b 00 00       	push   $0xb5e
 174:	6a 01                	push   $0x1
 176:	e8 bf 05 00 00       	call   73a <printf>
 17b:	83 c4 10             	add    $0x10,%esp
    calcelapsedtime(table[i].CPU_total_ticks);
    printf(1, "%s\t%d\n", table[i].state, table[i].size);
  }
  #else
  printf(1, "PID\tName\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\n");
  for(int i = 0; i < running_procs; i++){
 17e:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 182:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 185:	3b 45 dc             	cmp    -0x24(%ebp),%eax
 188:	0f 8c eb fe ff ff    	jl     79 <main+0x79>
    calcelapsedtime(table[i].CPU_total_ticks);
    printf(1, "%s\t%d\n", table[i].state, table[i].size);
  }
  #endif

  free(table);
 18e:	83 ec 0c             	sub    $0xc,%esp
 191:	ff 75 e0             	pushl  -0x20(%ebp)
 194:	e8 32 07 00 00       	call   8cb <free>
 199:	83 c4 10             	add    $0x10,%esp
  exit();
 19c:	e8 c2 03 00 00       	call   563 <exit>

000001a1 <calcelapsedtime>:

// Determines the seconds elapsed for a running process to the thousandth of a
// second and prints the result
void
calcelapsedtime(int ticks_in)
{
 1a1:	55                   	push   %ebp
 1a2:	89 e5                	mov    %esp,%ebp
 1a4:	83 ec 18             	sub    $0x18,%esp
  int seconds = (ticks_in)/1000;
 1a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1aa:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
 1af:	89 c8                	mov    %ecx,%eax
 1b1:	f7 ea                	imul   %edx
 1b3:	c1 fa 06             	sar    $0x6,%edx
 1b6:	89 c8                	mov    %ecx,%eax
 1b8:	c1 f8 1f             	sar    $0x1f,%eax
 1bb:	29 c2                	sub    %eax,%edx
 1bd:	89 d0                	mov    %edx,%eax
 1bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int milliseconds = (ticks_in)%1000;
 1c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1c5:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
 1ca:	89 c8                	mov    %ecx,%eax
 1cc:	f7 ea                	imul   %edx
 1ce:	c1 fa 06             	sar    $0x6,%edx
 1d1:	89 c8                	mov    %ecx,%eax
 1d3:	c1 f8 1f             	sar    $0x1f,%eax
 1d6:	29 c2                	sub    %eax,%edx
 1d8:	89 d0                	mov    %edx,%eax
 1da:	69 c0 e8 03 00 00    	imul   $0x3e8,%eax,%eax
 1e0:	29 c1                	sub    %eax,%ecx
 1e2:	89 c8                	mov    %ecx,%eax
 1e4:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(milliseconds < 10)
 1e7:	83 7d f0 09          	cmpl   $0x9,-0x10(%ebp)
 1eb:	7f 17                	jg     204 <calcelapsedtime+0x63>
    printf(1, "%d.00%d\t", seconds, milliseconds);
 1ed:	ff 75 f0             	pushl  -0x10(%ebp)
 1f0:	ff 75 f4             	pushl  -0xc(%ebp)
 1f3:	68 65 0b 00 00       	push   $0xb65
 1f8:	6a 01                	push   $0x1
 1fa:	e8 3b 05 00 00       	call   73a <printf>
 1ff:	83 c4 10             	add    $0x10,%esp
  else if(milliseconds < 100)
    printf(1, "%d.0%d\t", seconds, milliseconds);
  else
    printf(1, "%d.%d\t", seconds, milliseconds);
}
 202:	eb 32                	jmp    236 <calcelapsedtime+0x95>
  int seconds = (ticks_in)/1000;
  int milliseconds = (ticks_in)%1000;

  if(milliseconds < 10)
    printf(1, "%d.00%d\t", seconds, milliseconds);
  else if(milliseconds < 100)
 204:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
 208:	7f 17                	jg     221 <calcelapsedtime+0x80>
    printf(1, "%d.0%d\t", seconds, milliseconds);
 20a:	ff 75 f0             	pushl  -0x10(%ebp)
 20d:	ff 75 f4             	pushl  -0xc(%ebp)
 210:	68 6e 0b 00 00       	push   $0xb6e
 215:	6a 01                	push   $0x1
 217:	e8 1e 05 00 00       	call   73a <printf>
 21c:	83 c4 10             	add    $0x10,%esp
  else
    printf(1, "%d.%d\t", seconds, milliseconds);
}
 21f:	eb 15                	jmp    236 <calcelapsedtime+0x95>
  if(milliseconds < 10)
    printf(1, "%d.00%d\t", seconds, milliseconds);
  else if(milliseconds < 100)
    printf(1, "%d.0%d\t", seconds, milliseconds);
  else
    printf(1, "%d.%d\t", seconds, milliseconds);
 221:	ff 75 f0             	pushl  -0x10(%ebp)
 224:	ff 75 f4             	pushl  -0xc(%ebp)
 227:	68 76 0b 00 00       	push   $0xb76
 22c:	6a 01                	push   $0x1
 22e:	e8 07 05 00 00       	call   73a <printf>
 233:	83 c4 10             	add    $0x10,%esp
}
 236:	90                   	nop
 237:	c9                   	leave  
 238:	c3                   	ret    

00000239 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 239:	55                   	push   %ebp
 23a:	89 e5                	mov    %esp,%ebp
 23c:	57                   	push   %edi
 23d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 23e:	8b 4d 08             	mov    0x8(%ebp),%ecx
 241:	8b 55 10             	mov    0x10(%ebp),%edx
 244:	8b 45 0c             	mov    0xc(%ebp),%eax
 247:	89 cb                	mov    %ecx,%ebx
 249:	89 df                	mov    %ebx,%edi
 24b:	89 d1                	mov    %edx,%ecx
 24d:	fc                   	cld    
 24e:	f3 aa                	rep stos %al,%es:(%edi)
 250:	89 ca                	mov    %ecx,%edx
 252:	89 fb                	mov    %edi,%ebx
 254:	89 5d 08             	mov    %ebx,0x8(%ebp)
 257:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 25a:	90                   	nop
 25b:	5b                   	pop    %ebx
 25c:	5f                   	pop    %edi
 25d:	5d                   	pop    %ebp
 25e:	c3                   	ret    

0000025f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 25f:	55                   	push   %ebp
 260:	89 e5                	mov    %esp,%ebp
 262:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 265:	8b 45 08             	mov    0x8(%ebp),%eax
 268:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 26b:	90                   	nop
 26c:	8b 45 08             	mov    0x8(%ebp),%eax
 26f:	8d 50 01             	lea    0x1(%eax),%edx
 272:	89 55 08             	mov    %edx,0x8(%ebp)
 275:	8b 55 0c             	mov    0xc(%ebp),%edx
 278:	8d 4a 01             	lea    0x1(%edx),%ecx
 27b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 27e:	0f b6 12             	movzbl (%edx),%edx
 281:	88 10                	mov    %dl,(%eax)
 283:	0f b6 00             	movzbl (%eax),%eax
 286:	84 c0                	test   %al,%al
 288:	75 e2                	jne    26c <strcpy+0xd>
    ;
  return os;
 28a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 28d:	c9                   	leave  
 28e:	c3                   	ret    

0000028f <strcmp>:

int
strcmp(const char *p, const char *q)
{
 28f:	55                   	push   %ebp
 290:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 292:	eb 08                	jmp    29c <strcmp+0xd>
    p++, q++;
 294:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 298:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 29c:	8b 45 08             	mov    0x8(%ebp),%eax
 29f:	0f b6 00             	movzbl (%eax),%eax
 2a2:	84 c0                	test   %al,%al
 2a4:	74 10                	je     2b6 <strcmp+0x27>
 2a6:	8b 45 08             	mov    0x8(%ebp),%eax
 2a9:	0f b6 10             	movzbl (%eax),%edx
 2ac:	8b 45 0c             	mov    0xc(%ebp),%eax
 2af:	0f b6 00             	movzbl (%eax),%eax
 2b2:	38 c2                	cmp    %al,%dl
 2b4:	74 de                	je     294 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 2b6:	8b 45 08             	mov    0x8(%ebp),%eax
 2b9:	0f b6 00             	movzbl (%eax),%eax
 2bc:	0f b6 d0             	movzbl %al,%edx
 2bf:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c2:	0f b6 00             	movzbl (%eax),%eax
 2c5:	0f b6 c0             	movzbl %al,%eax
 2c8:	29 c2                	sub    %eax,%edx
 2ca:	89 d0                	mov    %edx,%eax
}
 2cc:	5d                   	pop    %ebp
 2cd:	c3                   	ret    

000002ce <strlen>:

uint
strlen(char *s)
{
 2ce:	55                   	push   %ebp
 2cf:	89 e5                	mov    %esp,%ebp
 2d1:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 2d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 2db:	eb 04                	jmp    2e1 <strlen+0x13>
 2dd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 2e1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2e4:	8b 45 08             	mov    0x8(%ebp),%eax
 2e7:	01 d0                	add    %edx,%eax
 2e9:	0f b6 00             	movzbl (%eax),%eax
 2ec:	84 c0                	test   %al,%al
 2ee:	75 ed                	jne    2dd <strlen+0xf>
    ;
  return n;
 2f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2f3:	c9                   	leave  
 2f4:	c3                   	ret    

000002f5 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2f5:	55                   	push   %ebp
 2f6:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 2f8:	8b 45 10             	mov    0x10(%ebp),%eax
 2fb:	50                   	push   %eax
 2fc:	ff 75 0c             	pushl  0xc(%ebp)
 2ff:	ff 75 08             	pushl  0x8(%ebp)
 302:	e8 32 ff ff ff       	call   239 <stosb>
 307:	83 c4 0c             	add    $0xc,%esp
  return dst;
 30a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 30d:	c9                   	leave  
 30e:	c3                   	ret    

0000030f <strchr>:

char*
strchr(const char *s, char c)
{
 30f:	55                   	push   %ebp
 310:	89 e5                	mov    %esp,%ebp
 312:	83 ec 04             	sub    $0x4,%esp
 315:	8b 45 0c             	mov    0xc(%ebp),%eax
 318:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 31b:	eb 14                	jmp    331 <strchr+0x22>
    if(*s == c)
 31d:	8b 45 08             	mov    0x8(%ebp),%eax
 320:	0f b6 00             	movzbl (%eax),%eax
 323:	3a 45 fc             	cmp    -0x4(%ebp),%al
 326:	75 05                	jne    32d <strchr+0x1e>
      return (char*)s;
 328:	8b 45 08             	mov    0x8(%ebp),%eax
 32b:	eb 13                	jmp    340 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 32d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 331:	8b 45 08             	mov    0x8(%ebp),%eax
 334:	0f b6 00             	movzbl (%eax),%eax
 337:	84 c0                	test   %al,%al
 339:	75 e2                	jne    31d <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 33b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 340:	c9                   	leave  
 341:	c3                   	ret    

00000342 <gets>:

char*
gets(char *buf, int max)
{
 342:	55                   	push   %ebp
 343:	89 e5                	mov    %esp,%ebp
 345:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 348:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 34f:	eb 42                	jmp    393 <gets+0x51>
    cc = read(0, &c, 1);
 351:	83 ec 04             	sub    $0x4,%esp
 354:	6a 01                	push   $0x1
 356:	8d 45 ef             	lea    -0x11(%ebp),%eax
 359:	50                   	push   %eax
 35a:	6a 00                	push   $0x0
 35c:	e8 1a 02 00 00       	call   57b <read>
 361:	83 c4 10             	add    $0x10,%esp
 364:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 367:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 36b:	7e 33                	jle    3a0 <gets+0x5e>
      break;
    buf[i++] = c;
 36d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 370:	8d 50 01             	lea    0x1(%eax),%edx
 373:	89 55 f4             	mov    %edx,-0xc(%ebp)
 376:	89 c2                	mov    %eax,%edx
 378:	8b 45 08             	mov    0x8(%ebp),%eax
 37b:	01 c2                	add    %eax,%edx
 37d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 381:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 383:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 387:	3c 0a                	cmp    $0xa,%al
 389:	74 16                	je     3a1 <gets+0x5f>
 38b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 38f:	3c 0d                	cmp    $0xd,%al
 391:	74 0e                	je     3a1 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 393:	8b 45 f4             	mov    -0xc(%ebp),%eax
 396:	83 c0 01             	add    $0x1,%eax
 399:	3b 45 0c             	cmp    0xc(%ebp),%eax
 39c:	7c b3                	jl     351 <gets+0xf>
 39e:	eb 01                	jmp    3a1 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 3a0:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 3a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3a4:	8b 45 08             	mov    0x8(%ebp),%eax
 3a7:	01 d0                	add    %edx,%eax
 3a9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 3ac:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3af:	c9                   	leave  
 3b0:	c3                   	ret    

000003b1 <stat>:

int
stat(char *n, struct stat *st)
{
 3b1:	55                   	push   %ebp
 3b2:	89 e5                	mov    %esp,%ebp
 3b4:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3b7:	83 ec 08             	sub    $0x8,%esp
 3ba:	6a 00                	push   $0x0
 3bc:	ff 75 08             	pushl  0x8(%ebp)
 3bf:	e8 df 01 00 00       	call   5a3 <open>
 3c4:	83 c4 10             	add    $0x10,%esp
 3c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 3ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3ce:	79 07                	jns    3d7 <stat+0x26>
    return -1;
 3d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3d5:	eb 25                	jmp    3fc <stat+0x4b>
  r = fstat(fd, st);
 3d7:	83 ec 08             	sub    $0x8,%esp
 3da:	ff 75 0c             	pushl  0xc(%ebp)
 3dd:	ff 75 f4             	pushl  -0xc(%ebp)
 3e0:	e8 d6 01 00 00       	call   5bb <fstat>
 3e5:	83 c4 10             	add    $0x10,%esp
 3e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 3eb:	83 ec 0c             	sub    $0xc,%esp
 3ee:	ff 75 f4             	pushl  -0xc(%ebp)
 3f1:	e8 95 01 00 00       	call   58b <close>
 3f6:	83 c4 10             	add    $0x10,%esp
  return r;
 3f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 3fc:	c9                   	leave  
 3fd:	c3                   	ret    

000003fe <atoi>:

int
atoi(const char *s)
{
 3fe:	55                   	push   %ebp
 3ff:	89 e5                	mov    %esp,%ebp
 401:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 404:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 40b:	eb 04                	jmp    411 <atoi+0x13>
 40d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 411:	8b 45 08             	mov    0x8(%ebp),%eax
 414:	0f b6 00             	movzbl (%eax),%eax
 417:	3c 20                	cmp    $0x20,%al
 419:	74 f2                	je     40d <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 41b:	8b 45 08             	mov    0x8(%ebp),%eax
 41e:	0f b6 00             	movzbl (%eax),%eax
 421:	3c 2d                	cmp    $0x2d,%al
 423:	75 07                	jne    42c <atoi+0x2e>
 425:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 42a:	eb 05                	jmp    431 <atoi+0x33>
 42c:	b8 01 00 00 00       	mov    $0x1,%eax
 431:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 434:	8b 45 08             	mov    0x8(%ebp),%eax
 437:	0f b6 00             	movzbl (%eax),%eax
 43a:	3c 2b                	cmp    $0x2b,%al
 43c:	74 0a                	je     448 <atoi+0x4a>
 43e:	8b 45 08             	mov    0x8(%ebp),%eax
 441:	0f b6 00             	movzbl (%eax),%eax
 444:	3c 2d                	cmp    $0x2d,%al
 446:	75 2b                	jne    473 <atoi+0x75>
    s++;
 448:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 44c:	eb 25                	jmp    473 <atoi+0x75>
    n = n*10 + *s++ - '0';
 44e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 451:	89 d0                	mov    %edx,%eax
 453:	c1 e0 02             	shl    $0x2,%eax
 456:	01 d0                	add    %edx,%eax
 458:	01 c0                	add    %eax,%eax
 45a:	89 c1                	mov    %eax,%ecx
 45c:	8b 45 08             	mov    0x8(%ebp),%eax
 45f:	8d 50 01             	lea    0x1(%eax),%edx
 462:	89 55 08             	mov    %edx,0x8(%ebp)
 465:	0f b6 00             	movzbl (%eax),%eax
 468:	0f be c0             	movsbl %al,%eax
 46b:	01 c8                	add    %ecx,%eax
 46d:	83 e8 30             	sub    $0x30,%eax
 470:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 473:	8b 45 08             	mov    0x8(%ebp),%eax
 476:	0f b6 00             	movzbl (%eax),%eax
 479:	3c 2f                	cmp    $0x2f,%al
 47b:	7e 0a                	jle    487 <atoi+0x89>
 47d:	8b 45 08             	mov    0x8(%ebp),%eax
 480:	0f b6 00             	movzbl (%eax),%eax
 483:	3c 39                	cmp    $0x39,%al
 485:	7e c7                	jle    44e <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 487:	8b 45 f8             	mov    -0x8(%ebp),%eax
 48a:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 48e:	c9                   	leave  
 48f:	c3                   	ret    

00000490 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 490:	55                   	push   %ebp
 491:	89 e5                	mov    %esp,%ebp
 493:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 496:	8b 45 08             	mov    0x8(%ebp),%eax
 499:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 49c:	8b 45 0c             	mov    0xc(%ebp),%eax
 49f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 4a2:	eb 17                	jmp    4bb <memmove+0x2b>
    *dst++ = *src++;
 4a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4a7:	8d 50 01             	lea    0x1(%eax),%edx
 4aa:	89 55 fc             	mov    %edx,-0x4(%ebp)
 4ad:	8b 55 f8             	mov    -0x8(%ebp),%edx
 4b0:	8d 4a 01             	lea    0x1(%edx),%ecx
 4b3:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 4b6:	0f b6 12             	movzbl (%edx),%edx
 4b9:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4bb:	8b 45 10             	mov    0x10(%ebp),%eax
 4be:	8d 50 ff             	lea    -0x1(%eax),%edx
 4c1:	89 55 10             	mov    %edx,0x10(%ebp)
 4c4:	85 c0                	test   %eax,%eax
 4c6:	7f dc                	jg     4a4 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 4c8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4cb:	c9                   	leave  
 4cc:	c3                   	ret    

000004cd <atoo>:

#ifdef CS333_P5
int
atoo(const char *s)
{
 4cd:	55                   	push   %ebp
 4ce:	89 e5                	mov    %esp,%ebp
 4d0:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 4d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 4da:	eb 04                	jmp    4e0 <atoo+0x13>
 4dc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 4e0:	8b 45 08             	mov    0x8(%ebp),%eax
 4e3:	0f b6 00             	movzbl (%eax),%eax
 4e6:	3c 20                	cmp    $0x20,%al
 4e8:	74 f2                	je     4dc <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 4ea:	8b 45 08             	mov    0x8(%ebp),%eax
 4ed:	0f b6 00             	movzbl (%eax),%eax
 4f0:	3c 2d                	cmp    $0x2d,%al
 4f2:	75 07                	jne    4fb <atoo+0x2e>
 4f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4f9:	eb 05                	jmp    500 <atoo+0x33>
 4fb:	b8 01 00 00 00       	mov    $0x1,%eax
 500:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 503:	8b 45 08             	mov    0x8(%ebp),%eax
 506:	0f b6 00             	movzbl (%eax),%eax
 509:	3c 2b                	cmp    $0x2b,%al
 50b:	74 0a                	je     517 <atoo+0x4a>
 50d:	8b 45 08             	mov    0x8(%ebp),%eax
 510:	0f b6 00             	movzbl (%eax),%eax
 513:	3c 2d                	cmp    $0x2d,%al
 515:	75 27                	jne    53e <atoo+0x71>
    s++;
 517:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 51b:	eb 21                	jmp    53e <atoo+0x71>
    n = n*8 + *s++ - '0';
 51d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 520:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 527:	8b 45 08             	mov    0x8(%ebp),%eax
 52a:	8d 50 01             	lea    0x1(%eax),%edx
 52d:	89 55 08             	mov    %edx,0x8(%ebp)
 530:	0f b6 00             	movzbl (%eax),%eax
 533:	0f be c0             	movsbl %al,%eax
 536:	01 c8                	add    %ecx,%eax
 538:	83 e8 30             	sub    $0x30,%eax
 53b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 53e:	8b 45 08             	mov    0x8(%ebp),%eax
 541:	0f b6 00             	movzbl (%eax),%eax
 544:	3c 2f                	cmp    $0x2f,%al
 546:	7e 0a                	jle    552 <atoo+0x85>
 548:	8b 45 08             	mov    0x8(%ebp),%eax
 54b:	0f b6 00             	movzbl (%eax),%eax
 54e:	3c 39                	cmp    $0x39,%al
 550:	7e cb                	jle    51d <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 552:	8b 45 f8             	mov    -0x8(%ebp),%eax
 555:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 559:	c9                   	leave  
 55a:	c3                   	ret    

0000055b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 55b:	b8 01 00 00 00       	mov    $0x1,%eax
 560:	cd 40                	int    $0x40
 562:	c3                   	ret    

00000563 <exit>:
SYSCALL(exit)
 563:	b8 02 00 00 00       	mov    $0x2,%eax
 568:	cd 40                	int    $0x40
 56a:	c3                   	ret    

0000056b <wait>:
SYSCALL(wait)
 56b:	b8 03 00 00 00       	mov    $0x3,%eax
 570:	cd 40                	int    $0x40
 572:	c3                   	ret    

00000573 <pipe>:
SYSCALL(pipe)
 573:	b8 04 00 00 00       	mov    $0x4,%eax
 578:	cd 40                	int    $0x40
 57a:	c3                   	ret    

0000057b <read>:
SYSCALL(read)
 57b:	b8 05 00 00 00       	mov    $0x5,%eax
 580:	cd 40                	int    $0x40
 582:	c3                   	ret    

00000583 <write>:
SYSCALL(write)
 583:	b8 10 00 00 00       	mov    $0x10,%eax
 588:	cd 40                	int    $0x40
 58a:	c3                   	ret    

0000058b <close>:
SYSCALL(close)
 58b:	b8 15 00 00 00       	mov    $0x15,%eax
 590:	cd 40                	int    $0x40
 592:	c3                   	ret    

00000593 <kill>:
SYSCALL(kill)
 593:	b8 06 00 00 00       	mov    $0x6,%eax
 598:	cd 40                	int    $0x40
 59a:	c3                   	ret    

0000059b <exec>:
SYSCALL(exec)
 59b:	b8 07 00 00 00       	mov    $0x7,%eax
 5a0:	cd 40                	int    $0x40
 5a2:	c3                   	ret    

000005a3 <open>:
SYSCALL(open)
 5a3:	b8 0f 00 00 00       	mov    $0xf,%eax
 5a8:	cd 40                	int    $0x40
 5aa:	c3                   	ret    

000005ab <mknod>:
SYSCALL(mknod)
 5ab:	b8 11 00 00 00       	mov    $0x11,%eax
 5b0:	cd 40                	int    $0x40
 5b2:	c3                   	ret    

000005b3 <unlink>:
SYSCALL(unlink)
 5b3:	b8 12 00 00 00       	mov    $0x12,%eax
 5b8:	cd 40                	int    $0x40
 5ba:	c3                   	ret    

000005bb <fstat>:
SYSCALL(fstat)
 5bb:	b8 08 00 00 00       	mov    $0x8,%eax
 5c0:	cd 40                	int    $0x40
 5c2:	c3                   	ret    

000005c3 <link>:
SYSCALL(link)
 5c3:	b8 13 00 00 00       	mov    $0x13,%eax
 5c8:	cd 40                	int    $0x40
 5ca:	c3                   	ret    

000005cb <mkdir>:
SYSCALL(mkdir)
 5cb:	b8 14 00 00 00       	mov    $0x14,%eax
 5d0:	cd 40                	int    $0x40
 5d2:	c3                   	ret    

000005d3 <chdir>:
SYSCALL(chdir)
 5d3:	b8 09 00 00 00       	mov    $0x9,%eax
 5d8:	cd 40                	int    $0x40
 5da:	c3                   	ret    

000005db <dup>:
SYSCALL(dup)
 5db:	b8 0a 00 00 00       	mov    $0xa,%eax
 5e0:	cd 40                	int    $0x40
 5e2:	c3                   	ret    

000005e3 <getpid>:
SYSCALL(getpid)
 5e3:	b8 0b 00 00 00       	mov    $0xb,%eax
 5e8:	cd 40                	int    $0x40
 5ea:	c3                   	ret    

000005eb <sbrk>:
SYSCALL(sbrk)
 5eb:	b8 0c 00 00 00       	mov    $0xc,%eax
 5f0:	cd 40                	int    $0x40
 5f2:	c3                   	ret    

000005f3 <sleep>:
SYSCALL(sleep)
 5f3:	b8 0d 00 00 00       	mov    $0xd,%eax
 5f8:	cd 40                	int    $0x40
 5fa:	c3                   	ret    

000005fb <uptime>:
SYSCALL(uptime)
 5fb:	b8 0e 00 00 00       	mov    $0xe,%eax
 600:	cd 40                	int    $0x40
 602:	c3                   	ret    

00000603 <halt>:
SYSCALL(halt)
 603:	b8 16 00 00 00       	mov    $0x16,%eax
 608:	cd 40                	int    $0x40
 60a:	c3                   	ret    

0000060b <date>:
SYSCALL(date)
 60b:	b8 17 00 00 00       	mov    $0x17,%eax
 610:	cd 40                	int    $0x40
 612:	c3                   	ret    

00000613 <getuid>:
SYSCALL(getuid)
 613:	b8 18 00 00 00       	mov    $0x18,%eax
 618:	cd 40                	int    $0x40
 61a:	c3                   	ret    

0000061b <getgid>:
SYSCALL(getgid)
 61b:	b8 19 00 00 00       	mov    $0x19,%eax
 620:	cd 40                	int    $0x40
 622:	c3                   	ret    

00000623 <getppid>:
SYSCALL(getppid)
 623:	b8 1a 00 00 00       	mov    $0x1a,%eax
 628:	cd 40                	int    $0x40
 62a:	c3                   	ret    

0000062b <setuid>:
SYSCALL(setuid)
 62b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 630:	cd 40                	int    $0x40
 632:	c3                   	ret    

00000633 <setgid>:
SYSCALL(setgid)
 633:	b8 1c 00 00 00       	mov    $0x1c,%eax
 638:	cd 40                	int    $0x40
 63a:	c3                   	ret    

0000063b <getprocs>:
SYSCALL(getprocs)
 63b:	b8 1d 00 00 00       	mov    $0x1d,%eax
 640:	cd 40                	int    $0x40
 642:	c3                   	ret    

00000643 <setpriority>:
SYSCALL(setpriority)
 643:	b8 1e 00 00 00       	mov    $0x1e,%eax
 648:	cd 40                	int    $0x40
 64a:	c3                   	ret    

0000064b <chmod>:
SYSCALL(chmod)
 64b:	b8 1f 00 00 00       	mov    $0x1f,%eax
 650:	cd 40                	int    $0x40
 652:	c3                   	ret    

00000653 <chown>:
SYSCALL(chown)
 653:	b8 20 00 00 00       	mov    $0x20,%eax
 658:	cd 40                	int    $0x40
 65a:	c3                   	ret    

0000065b <chgrp>:
SYSCALL(chgrp)
 65b:	b8 21 00 00 00       	mov    $0x21,%eax
 660:	cd 40                	int    $0x40
 662:	c3                   	ret    

00000663 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 663:	55                   	push   %ebp
 664:	89 e5                	mov    %esp,%ebp
 666:	83 ec 18             	sub    $0x18,%esp
 669:	8b 45 0c             	mov    0xc(%ebp),%eax
 66c:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 66f:	83 ec 04             	sub    $0x4,%esp
 672:	6a 01                	push   $0x1
 674:	8d 45 f4             	lea    -0xc(%ebp),%eax
 677:	50                   	push   %eax
 678:	ff 75 08             	pushl  0x8(%ebp)
 67b:	e8 03 ff ff ff       	call   583 <write>
 680:	83 c4 10             	add    $0x10,%esp
}
 683:	90                   	nop
 684:	c9                   	leave  
 685:	c3                   	ret    

00000686 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 686:	55                   	push   %ebp
 687:	89 e5                	mov    %esp,%ebp
 689:	53                   	push   %ebx
 68a:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 68d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 694:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 698:	74 17                	je     6b1 <printint+0x2b>
 69a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 69e:	79 11                	jns    6b1 <printint+0x2b>
    neg = 1;
 6a0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6a7:	8b 45 0c             	mov    0xc(%ebp),%eax
 6aa:	f7 d8                	neg    %eax
 6ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6af:	eb 06                	jmp    6b7 <printint+0x31>
  } else {
    x = xx;
 6b1:	8b 45 0c             	mov    0xc(%ebp),%eax
 6b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 6b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 6be:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 6c1:	8d 41 01             	lea    0x1(%ecx),%eax
 6c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 6c7:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6cd:	ba 00 00 00 00       	mov    $0x0,%edx
 6d2:	f7 f3                	div    %ebx
 6d4:	89 d0                	mov    %edx,%eax
 6d6:	0f b6 80 18 0e 00 00 	movzbl 0xe18(%eax),%eax
 6dd:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 6e1:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6e7:	ba 00 00 00 00       	mov    $0x0,%edx
 6ec:	f7 f3                	div    %ebx
 6ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6f5:	75 c7                	jne    6be <printint+0x38>
  if(neg)
 6f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6fb:	74 2d                	je     72a <printint+0xa4>
    buf[i++] = '-';
 6fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 700:	8d 50 01             	lea    0x1(%eax),%edx
 703:	89 55 f4             	mov    %edx,-0xc(%ebp)
 706:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 70b:	eb 1d                	jmp    72a <printint+0xa4>
    putc(fd, buf[i]);
 70d:	8d 55 dc             	lea    -0x24(%ebp),%edx
 710:	8b 45 f4             	mov    -0xc(%ebp),%eax
 713:	01 d0                	add    %edx,%eax
 715:	0f b6 00             	movzbl (%eax),%eax
 718:	0f be c0             	movsbl %al,%eax
 71b:	83 ec 08             	sub    $0x8,%esp
 71e:	50                   	push   %eax
 71f:	ff 75 08             	pushl  0x8(%ebp)
 722:	e8 3c ff ff ff       	call   663 <putc>
 727:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 72a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 72e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 732:	79 d9                	jns    70d <printint+0x87>
    putc(fd, buf[i]);
}
 734:	90                   	nop
 735:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 738:	c9                   	leave  
 739:	c3                   	ret    

0000073a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 73a:	55                   	push   %ebp
 73b:	89 e5                	mov    %esp,%ebp
 73d:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 740:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 747:	8d 45 0c             	lea    0xc(%ebp),%eax
 74a:	83 c0 04             	add    $0x4,%eax
 74d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 750:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 757:	e9 59 01 00 00       	jmp    8b5 <printf+0x17b>
    c = fmt[i] & 0xff;
 75c:	8b 55 0c             	mov    0xc(%ebp),%edx
 75f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 762:	01 d0                	add    %edx,%eax
 764:	0f b6 00             	movzbl (%eax),%eax
 767:	0f be c0             	movsbl %al,%eax
 76a:	25 ff 00 00 00       	and    $0xff,%eax
 76f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 772:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 776:	75 2c                	jne    7a4 <printf+0x6a>
      if(c == '%'){
 778:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 77c:	75 0c                	jne    78a <printf+0x50>
        state = '%';
 77e:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 785:	e9 27 01 00 00       	jmp    8b1 <printf+0x177>
      } else {
        putc(fd, c);
 78a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 78d:	0f be c0             	movsbl %al,%eax
 790:	83 ec 08             	sub    $0x8,%esp
 793:	50                   	push   %eax
 794:	ff 75 08             	pushl  0x8(%ebp)
 797:	e8 c7 fe ff ff       	call   663 <putc>
 79c:	83 c4 10             	add    $0x10,%esp
 79f:	e9 0d 01 00 00       	jmp    8b1 <printf+0x177>
      }
    } else if(state == '%'){
 7a4:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 7a8:	0f 85 03 01 00 00    	jne    8b1 <printf+0x177>
      if(c == 'd'){
 7ae:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 7b2:	75 1e                	jne    7d2 <printf+0x98>
        printint(fd, *ap, 10, 1);
 7b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7b7:	8b 00                	mov    (%eax),%eax
 7b9:	6a 01                	push   $0x1
 7bb:	6a 0a                	push   $0xa
 7bd:	50                   	push   %eax
 7be:	ff 75 08             	pushl  0x8(%ebp)
 7c1:	e8 c0 fe ff ff       	call   686 <printint>
 7c6:	83 c4 10             	add    $0x10,%esp
        ap++;
 7c9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7cd:	e9 d8 00 00 00       	jmp    8aa <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 7d2:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7d6:	74 06                	je     7de <printf+0xa4>
 7d8:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7dc:	75 1e                	jne    7fc <printf+0xc2>
        printint(fd, *ap, 16, 0);
 7de:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7e1:	8b 00                	mov    (%eax),%eax
 7e3:	6a 00                	push   $0x0
 7e5:	6a 10                	push   $0x10
 7e7:	50                   	push   %eax
 7e8:	ff 75 08             	pushl  0x8(%ebp)
 7eb:	e8 96 fe ff ff       	call   686 <printint>
 7f0:	83 c4 10             	add    $0x10,%esp
        ap++;
 7f3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7f7:	e9 ae 00 00 00       	jmp    8aa <printf+0x170>
      } else if(c == 's'){
 7fc:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 800:	75 43                	jne    845 <printf+0x10b>
        s = (char*)*ap;
 802:	8b 45 e8             	mov    -0x18(%ebp),%eax
 805:	8b 00                	mov    (%eax),%eax
 807:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 80a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 80e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 812:	75 25                	jne    839 <printf+0xff>
          s = "(null)";
 814:	c7 45 f4 7d 0b 00 00 	movl   $0xb7d,-0xc(%ebp)
        while(*s != 0){
 81b:	eb 1c                	jmp    839 <printf+0xff>
          putc(fd, *s);
 81d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 820:	0f b6 00             	movzbl (%eax),%eax
 823:	0f be c0             	movsbl %al,%eax
 826:	83 ec 08             	sub    $0x8,%esp
 829:	50                   	push   %eax
 82a:	ff 75 08             	pushl  0x8(%ebp)
 82d:	e8 31 fe ff ff       	call   663 <putc>
 832:	83 c4 10             	add    $0x10,%esp
          s++;
 835:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 839:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83c:	0f b6 00             	movzbl (%eax),%eax
 83f:	84 c0                	test   %al,%al
 841:	75 da                	jne    81d <printf+0xe3>
 843:	eb 65                	jmp    8aa <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 845:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 849:	75 1d                	jne    868 <printf+0x12e>
        putc(fd, *ap);
 84b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 84e:	8b 00                	mov    (%eax),%eax
 850:	0f be c0             	movsbl %al,%eax
 853:	83 ec 08             	sub    $0x8,%esp
 856:	50                   	push   %eax
 857:	ff 75 08             	pushl  0x8(%ebp)
 85a:	e8 04 fe ff ff       	call   663 <putc>
 85f:	83 c4 10             	add    $0x10,%esp
        ap++;
 862:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 866:	eb 42                	jmp    8aa <printf+0x170>
      } else if(c == '%'){
 868:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 86c:	75 17                	jne    885 <printf+0x14b>
        putc(fd, c);
 86e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 871:	0f be c0             	movsbl %al,%eax
 874:	83 ec 08             	sub    $0x8,%esp
 877:	50                   	push   %eax
 878:	ff 75 08             	pushl  0x8(%ebp)
 87b:	e8 e3 fd ff ff       	call   663 <putc>
 880:	83 c4 10             	add    $0x10,%esp
 883:	eb 25                	jmp    8aa <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 885:	83 ec 08             	sub    $0x8,%esp
 888:	6a 25                	push   $0x25
 88a:	ff 75 08             	pushl  0x8(%ebp)
 88d:	e8 d1 fd ff ff       	call   663 <putc>
 892:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 895:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 898:	0f be c0             	movsbl %al,%eax
 89b:	83 ec 08             	sub    $0x8,%esp
 89e:	50                   	push   %eax
 89f:	ff 75 08             	pushl  0x8(%ebp)
 8a2:	e8 bc fd ff ff       	call   663 <putc>
 8a7:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 8aa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8b1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 8b5:	8b 55 0c             	mov    0xc(%ebp),%edx
 8b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8bb:	01 d0                	add    %edx,%eax
 8bd:	0f b6 00             	movzbl (%eax),%eax
 8c0:	84 c0                	test   %al,%al
 8c2:	0f 85 94 fe ff ff    	jne    75c <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 8c8:	90                   	nop
 8c9:	c9                   	leave  
 8ca:	c3                   	ret    

000008cb <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8cb:	55                   	push   %ebp
 8cc:	89 e5                	mov    %esp,%ebp
 8ce:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8d1:	8b 45 08             	mov    0x8(%ebp),%eax
 8d4:	83 e8 08             	sub    $0x8,%eax
 8d7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8da:	a1 34 0e 00 00       	mov    0xe34,%eax
 8df:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8e2:	eb 24                	jmp    908 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e7:	8b 00                	mov    (%eax),%eax
 8e9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8ec:	77 12                	ja     900 <free+0x35>
 8ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8f1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8f4:	77 24                	ja     91a <free+0x4f>
 8f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f9:	8b 00                	mov    (%eax),%eax
 8fb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8fe:	77 1a                	ja     91a <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 900:	8b 45 fc             	mov    -0x4(%ebp),%eax
 903:	8b 00                	mov    (%eax),%eax
 905:	89 45 fc             	mov    %eax,-0x4(%ebp)
 908:	8b 45 f8             	mov    -0x8(%ebp),%eax
 90b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 90e:	76 d4                	jbe    8e4 <free+0x19>
 910:	8b 45 fc             	mov    -0x4(%ebp),%eax
 913:	8b 00                	mov    (%eax),%eax
 915:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 918:	76 ca                	jbe    8e4 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 91a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 91d:	8b 40 04             	mov    0x4(%eax),%eax
 920:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 927:	8b 45 f8             	mov    -0x8(%ebp),%eax
 92a:	01 c2                	add    %eax,%edx
 92c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 92f:	8b 00                	mov    (%eax),%eax
 931:	39 c2                	cmp    %eax,%edx
 933:	75 24                	jne    959 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 935:	8b 45 f8             	mov    -0x8(%ebp),%eax
 938:	8b 50 04             	mov    0x4(%eax),%edx
 93b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93e:	8b 00                	mov    (%eax),%eax
 940:	8b 40 04             	mov    0x4(%eax),%eax
 943:	01 c2                	add    %eax,%edx
 945:	8b 45 f8             	mov    -0x8(%ebp),%eax
 948:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 94b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 94e:	8b 00                	mov    (%eax),%eax
 950:	8b 10                	mov    (%eax),%edx
 952:	8b 45 f8             	mov    -0x8(%ebp),%eax
 955:	89 10                	mov    %edx,(%eax)
 957:	eb 0a                	jmp    963 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 959:	8b 45 fc             	mov    -0x4(%ebp),%eax
 95c:	8b 10                	mov    (%eax),%edx
 95e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 961:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 963:	8b 45 fc             	mov    -0x4(%ebp),%eax
 966:	8b 40 04             	mov    0x4(%eax),%eax
 969:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 970:	8b 45 fc             	mov    -0x4(%ebp),%eax
 973:	01 d0                	add    %edx,%eax
 975:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 978:	75 20                	jne    99a <free+0xcf>
    p->s.size += bp->s.size;
 97a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 97d:	8b 50 04             	mov    0x4(%eax),%edx
 980:	8b 45 f8             	mov    -0x8(%ebp),%eax
 983:	8b 40 04             	mov    0x4(%eax),%eax
 986:	01 c2                	add    %eax,%edx
 988:	8b 45 fc             	mov    -0x4(%ebp),%eax
 98b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 98e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 991:	8b 10                	mov    (%eax),%edx
 993:	8b 45 fc             	mov    -0x4(%ebp),%eax
 996:	89 10                	mov    %edx,(%eax)
 998:	eb 08                	jmp    9a2 <free+0xd7>
  } else
    p->s.ptr = bp;
 99a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 99d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9a0:	89 10                	mov    %edx,(%eax)
  freep = p;
 9a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a5:	a3 34 0e 00 00       	mov    %eax,0xe34
}
 9aa:	90                   	nop
 9ab:	c9                   	leave  
 9ac:	c3                   	ret    

000009ad <morecore>:

static Header*
morecore(uint nu)
{
 9ad:	55                   	push   %ebp
 9ae:	89 e5                	mov    %esp,%ebp
 9b0:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 9b3:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9ba:	77 07                	ja     9c3 <morecore+0x16>
    nu = 4096;
 9bc:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 9c3:	8b 45 08             	mov    0x8(%ebp),%eax
 9c6:	c1 e0 03             	shl    $0x3,%eax
 9c9:	83 ec 0c             	sub    $0xc,%esp
 9cc:	50                   	push   %eax
 9cd:	e8 19 fc ff ff       	call   5eb <sbrk>
 9d2:	83 c4 10             	add    $0x10,%esp
 9d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 9d8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 9dc:	75 07                	jne    9e5 <morecore+0x38>
    return 0;
 9de:	b8 00 00 00 00       	mov    $0x0,%eax
 9e3:	eb 26                	jmp    a0b <morecore+0x5e>
  hp = (Header*)p;
 9e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9ee:	8b 55 08             	mov    0x8(%ebp),%edx
 9f1:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9f7:	83 c0 08             	add    $0x8,%eax
 9fa:	83 ec 0c             	sub    $0xc,%esp
 9fd:	50                   	push   %eax
 9fe:	e8 c8 fe ff ff       	call   8cb <free>
 a03:	83 c4 10             	add    $0x10,%esp
  return freep;
 a06:	a1 34 0e 00 00       	mov    0xe34,%eax
}
 a0b:	c9                   	leave  
 a0c:	c3                   	ret    

00000a0d <malloc>:

void*
malloc(uint nbytes)
{
 a0d:	55                   	push   %ebp
 a0e:	89 e5                	mov    %esp,%ebp
 a10:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a13:	8b 45 08             	mov    0x8(%ebp),%eax
 a16:	83 c0 07             	add    $0x7,%eax
 a19:	c1 e8 03             	shr    $0x3,%eax
 a1c:	83 c0 01             	add    $0x1,%eax
 a1f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a22:	a1 34 0e 00 00       	mov    0xe34,%eax
 a27:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a2a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a2e:	75 23                	jne    a53 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a30:	c7 45 f0 2c 0e 00 00 	movl   $0xe2c,-0x10(%ebp)
 a37:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a3a:	a3 34 0e 00 00       	mov    %eax,0xe34
 a3f:	a1 34 0e 00 00       	mov    0xe34,%eax
 a44:	a3 2c 0e 00 00       	mov    %eax,0xe2c
    base.s.size = 0;
 a49:	c7 05 30 0e 00 00 00 	movl   $0x0,0xe30
 a50:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a53:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a56:	8b 00                	mov    (%eax),%eax
 a58:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a5e:	8b 40 04             	mov    0x4(%eax),%eax
 a61:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a64:	72 4d                	jb     ab3 <malloc+0xa6>
      if(p->s.size == nunits)
 a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a69:	8b 40 04             	mov    0x4(%eax),%eax
 a6c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a6f:	75 0c                	jne    a7d <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a74:	8b 10                	mov    (%eax),%edx
 a76:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a79:	89 10                	mov    %edx,(%eax)
 a7b:	eb 26                	jmp    aa3 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a80:	8b 40 04             	mov    0x4(%eax),%eax
 a83:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a86:	89 c2                	mov    %eax,%edx
 a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a8b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a91:	8b 40 04             	mov    0x4(%eax),%eax
 a94:	c1 e0 03             	shl    $0x3,%eax
 a97:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a9d:	8b 55 ec             	mov    -0x14(%ebp),%edx
 aa0:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 aa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aa6:	a3 34 0e 00 00       	mov    %eax,0xe34
      return (void*)(p + 1);
 aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aae:	83 c0 08             	add    $0x8,%eax
 ab1:	eb 3b                	jmp    aee <malloc+0xe1>
    }
    if(p == freep)
 ab3:	a1 34 0e 00 00       	mov    0xe34,%eax
 ab8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 abb:	75 1e                	jne    adb <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 abd:	83 ec 0c             	sub    $0xc,%esp
 ac0:	ff 75 ec             	pushl  -0x14(%ebp)
 ac3:	e8 e5 fe ff ff       	call   9ad <morecore>
 ac8:	83 c4 10             	add    $0x10,%esp
 acb:	89 45 f4             	mov    %eax,-0xc(%ebp)
 ace:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 ad2:	75 07                	jne    adb <malloc+0xce>
        return 0;
 ad4:	b8 00 00 00 00       	mov    $0x0,%eax
 ad9:	eb 13                	jmp    aee <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ade:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae4:	8b 00                	mov    (%eax),%eax
 ae6:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 ae9:	e9 6d ff ff ff       	jmp    a5b <malloc+0x4e>
}
 aee:	c9                   	leave  
 aef:	c3                   	ret    
