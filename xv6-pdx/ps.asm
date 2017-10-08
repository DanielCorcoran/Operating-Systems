
_ps:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
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
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	83 ec 1c             	sub    $0x1c,%esp
  int MAX = 64;
  13:	c7 45 e0 40 00 00 00 	movl   $0x40,-0x20(%ebp)
  int running_procs;

  struct uproc* table = malloc(sizeof(struct uproc)*MAX);
  1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1d:	6b c0 5c             	imul   $0x5c,%eax,%eax
  20:	83 ec 0c             	sub    $0xc,%esp
  23:	50                   	push   %eax
  24:	e8 ed 08 00 00       	call   916 <malloc>
  29:	83 c4 10             	add    $0x10,%esp
  2c:	89 45 dc             	mov    %eax,-0x24(%ebp)

  running_procs = getprocs(MAX, table);
  2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  32:	83 ec 08             	sub    $0x8,%esp
  35:	ff 75 dc             	pushl  -0x24(%ebp)
  38:	50                   	push   %eax
  39:	e8 26 05 00 00       	call   564 <getprocs>
  3e:	83 c4 10             	add    $0x10,%esp
  41:	89 45 d8             	mov    %eax,-0x28(%ebp)
  if(running_procs == 0) {
  44:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  48:	75 1b                	jne    65 <main+0x65>
    printf(2, "Error: ps call failed.  %s at line %d\n", __FILE__, __LINE__);
  4a:	6a 0f                	push   $0xf
  4c:	68 fc 09 00 00       	push   $0x9fc
  51:	68 04 0a 00 00       	push   $0xa04
  56:	6a 02                	push   $0x2
  58:	e8 e6 05 00 00       	call   643 <printf>
  5d:	83 c4 10             	add    $0x10,%esp
    exit();
  60:	e8 27 04 00 00       	call   48c <exit>
  }

  printf(1, "PID\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\tName\n");
  65:	83 ec 08             	sub    $0x8,%esp
  68:	68 2c 0a 00 00       	push   $0xa2c
  6d:	6a 01                	push   $0x1
  6f:	e8 cf 05 00 00       	call   643 <printf>
  74:	83 c4 10             	add    $0x10,%esp
  for(int i = 0; i < running_procs; i++){
  77:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  7e:	e9 c4 00 00 00       	jmp    147 <main+0x147>
    printf(1, "%d\t%d\t%d\t%d\t", table[i].pid,
        table[i].uid, table[i].gid, table[i].ppid);
  83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  86:	6b d0 5c             	imul   $0x5c,%eax,%edx
  89:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8c:	01 d0                	add    %edx,%eax
    exit();
  }

  printf(1, "PID\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\tName\n");
  for(int i = 0; i < running_procs; i++){
    printf(1, "%d\t%d\t%d\t%d\t", table[i].pid,
  8e:	8b 58 0c             	mov    0xc(%eax),%ebx
        table[i].uid, table[i].gid, table[i].ppid);
  91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  94:	6b d0 5c             	imul   $0x5c,%eax,%edx
  97:	8b 45 dc             	mov    -0x24(%ebp),%eax
  9a:	01 d0                	add    %edx,%eax
    exit();
  }

  printf(1, "PID\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\tName\n");
  for(int i = 0; i < running_procs; i++){
    printf(1, "%d\t%d\t%d\t%d\t", table[i].pid,
  9c:	8b 48 08             	mov    0x8(%eax),%ecx
        table[i].uid, table[i].gid, table[i].ppid);
  9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  a2:	6b d0 5c             	imul   $0x5c,%eax,%edx
  a5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  a8:	01 d0                	add    %edx,%eax
    exit();
  }

  printf(1, "PID\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\tName\n");
  for(int i = 0; i < running_procs; i++){
    printf(1, "%d\t%d\t%d\t%d\t", table[i].pid,
  aa:	8b 50 04             	mov    0x4(%eax),%edx
  ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  b0:	6b f0 5c             	imul   $0x5c,%eax,%esi
  b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  b6:	01 f0                	add    %esi,%eax
  b8:	8b 00                	mov    (%eax),%eax
  ba:	83 ec 08             	sub    $0x8,%esp
  bd:	53                   	push   %ebx
  be:	51                   	push   %ecx
  bf:	52                   	push   %edx
  c0:	50                   	push   %eax
  c1:	68 5a 0a 00 00       	push   $0xa5a
  c6:	6a 01                	push   $0x1
  c8:	e8 76 05 00 00       	call   643 <printf>
  cd:	83 c4 20             	add    $0x20,%esp
        table[i].uid, table[i].gid, table[i].ppid);
    calcelapsedtime(table[i].elapsed_ticks);
  d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  d3:	6b d0 5c             	imul   $0x5c,%eax,%edx
  d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  d9:	01 d0                	add    %edx,%eax
  db:	8b 40 10             	mov    0x10(%eax),%eax
  de:	83 ec 0c             	sub    $0xc,%esp
  e1:	50                   	push   %eax
  e2:	e8 71 00 00 00       	call   158 <calcelapsedtime>
  e7:	83 c4 10             	add    $0x10,%esp
    calcelapsedtime(table[i].CPU_total_ticks);
  ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  ed:	6b d0 5c             	imul   $0x5c,%eax,%edx
  f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  f3:	01 d0                	add    %edx,%eax
  f5:	8b 40 14             	mov    0x14(%eax),%eax
  f8:	83 ec 0c             	sub    $0xc,%esp
  fb:	50                   	push   %eax
  fc:	e8 57 00 00 00       	call   158 <calcelapsedtime>
 101:	83 c4 10             	add    $0x10,%esp
    printf(1, "%s\t%d\t%s\n", table[i].state, table[i].size, table[i].name);
 104:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 107:	6b d0 5c             	imul   $0x5c,%eax,%edx
 10a:	8b 45 dc             	mov    -0x24(%ebp),%eax
 10d:	01 d0                	add    %edx,%eax
 10f:	8d 48 3c             	lea    0x3c(%eax),%ecx
 112:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 115:	6b d0 5c             	imul   $0x5c,%eax,%edx
 118:	8b 45 dc             	mov    -0x24(%ebp),%eax
 11b:	01 d0                	add    %edx,%eax
 11d:	8b 40 38             	mov    0x38(%eax),%eax
 120:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 123:	6b da 5c             	imul   $0x5c,%edx,%ebx
 126:	8b 55 dc             	mov    -0x24(%ebp),%edx
 129:	01 da                	add    %ebx,%edx
 12b:	83 c2 18             	add    $0x18,%edx
 12e:	83 ec 0c             	sub    $0xc,%esp
 131:	51                   	push   %ecx
 132:	50                   	push   %eax
 133:	52                   	push   %edx
 134:	68 67 0a 00 00       	push   $0xa67
 139:	6a 01                	push   $0x1
 13b:	e8 03 05 00 00       	call   643 <printf>
 140:	83 c4 20             	add    $0x20,%esp
    printf(2, "Error: ps call failed.  %s at line %d\n", __FILE__, __LINE__);
    exit();
  }

  printf(1, "PID\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\tName\n");
  for(int i = 0; i < running_procs; i++){
 143:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 147:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 14a:	3b 45 d8             	cmp    -0x28(%ebp),%eax
 14d:	0f 8c 30 ff ff ff    	jl     83 <main+0x83>
    calcelapsedtime(table[i].elapsed_ticks);
    calcelapsedtime(table[i].CPU_total_ticks);
    printf(1, "%s\t%d\t%s\n", table[i].state, table[i].size, table[i].name);
  }

  exit();
 153:	e8 34 03 00 00       	call   48c <exit>

00000158 <calcelapsedtime>:

// Determines the seconds elapsed for a running process to the thousandth of a
// second and prints the result
void
calcelapsedtime(int ticks_in)
{
 158:	55                   	push   %ebp
 159:	89 e5                	mov    %esp,%ebp
 15b:	83 ec 18             	sub    $0x18,%esp
  int seconds = (ticks_in)/1000;
 15e:	8b 4d 08             	mov    0x8(%ebp),%ecx
 161:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
 166:	89 c8                	mov    %ecx,%eax
 168:	f7 ea                	imul   %edx
 16a:	c1 fa 06             	sar    $0x6,%edx
 16d:	89 c8                	mov    %ecx,%eax
 16f:	c1 f8 1f             	sar    $0x1f,%eax
 172:	29 c2                	sub    %eax,%edx
 174:	89 d0                	mov    %edx,%eax
 176:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int milliseconds = (ticks_in)%1000;
 179:	8b 4d 08             	mov    0x8(%ebp),%ecx
 17c:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
 181:	89 c8                	mov    %ecx,%eax
 183:	f7 ea                	imul   %edx
 185:	c1 fa 06             	sar    $0x6,%edx
 188:	89 c8                	mov    %ecx,%eax
 18a:	c1 f8 1f             	sar    $0x1f,%eax
 18d:	29 c2                	sub    %eax,%edx
 18f:	89 d0                	mov    %edx,%eax
 191:	69 c0 e8 03 00 00    	imul   $0x3e8,%eax,%eax
 197:	29 c1                	sub    %eax,%ecx
 199:	89 c8                	mov    %ecx,%eax
 19b:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(milliseconds < 10)
 19e:	83 7d f0 09          	cmpl   $0x9,-0x10(%ebp)
 1a2:	7f 17                	jg     1bb <calcelapsedtime+0x63>
    printf(2, "%d.00%d\t", seconds, milliseconds);
 1a4:	ff 75 f0             	pushl  -0x10(%ebp)
 1a7:	ff 75 f4             	pushl  -0xc(%ebp)
 1aa:	68 71 0a 00 00       	push   $0xa71
 1af:	6a 02                	push   $0x2
 1b1:	e8 8d 04 00 00       	call   643 <printf>
 1b6:	83 c4 10             	add    $0x10,%esp
  else if(milliseconds < 100)
    printf(2, "%d.0%d\t", seconds, milliseconds);
  else
    printf(2, "%d.%d\t", seconds, milliseconds);
}
 1b9:	eb 32                	jmp    1ed <calcelapsedtime+0x95>
  int seconds = (ticks_in)/1000;
  int milliseconds = (ticks_in)%1000;

  if(milliseconds < 10)
    printf(2, "%d.00%d\t", seconds, milliseconds);
  else if(milliseconds < 100)
 1bb:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
 1bf:	7f 17                	jg     1d8 <calcelapsedtime+0x80>
    printf(2, "%d.0%d\t", seconds, milliseconds);
 1c1:	ff 75 f0             	pushl  -0x10(%ebp)
 1c4:	ff 75 f4             	pushl  -0xc(%ebp)
 1c7:	68 7a 0a 00 00       	push   $0xa7a
 1cc:	6a 02                	push   $0x2
 1ce:	e8 70 04 00 00       	call   643 <printf>
 1d3:	83 c4 10             	add    $0x10,%esp
  else
    printf(2, "%d.%d\t", seconds, milliseconds);
}
 1d6:	eb 15                	jmp    1ed <calcelapsedtime+0x95>
  if(milliseconds < 10)
    printf(2, "%d.00%d\t", seconds, milliseconds);
  else if(milliseconds < 100)
    printf(2, "%d.0%d\t", seconds, milliseconds);
  else
    printf(2, "%d.%d\t", seconds, milliseconds);
 1d8:	ff 75 f0             	pushl  -0x10(%ebp)
 1db:	ff 75 f4             	pushl  -0xc(%ebp)
 1de:	68 82 0a 00 00       	push   $0xa82
 1e3:	6a 02                	push   $0x2
 1e5:	e8 59 04 00 00       	call   643 <printf>
 1ea:	83 c4 10             	add    $0x10,%esp
}
 1ed:	90                   	nop
 1ee:	c9                   	leave  
 1ef:	c3                   	ret    

000001f0 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	57                   	push   %edi
 1f4:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1f8:	8b 55 10             	mov    0x10(%ebp),%edx
 1fb:	8b 45 0c             	mov    0xc(%ebp),%eax
 1fe:	89 cb                	mov    %ecx,%ebx
 200:	89 df                	mov    %ebx,%edi
 202:	89 d1                	mov    %edx,%ecx
 204:	fc                   	cld    
 205:	f3 aa                	rep stos %al,%es:(%edi)
 207:	89 ca                	mov    %ecx,%edx
 209:	89 fb                	mov    %edi,%ebx
 20b:	89 5d 08             	mov    %ebx,0x8(%ebp)
 20e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 211:	90                   	nop
 212:	5b                   	pop    %ebx
 213:	5f                   	pop    %edi
 214:	5d                   	pop    %ebp
 215:	c3                   	ret    

00000216 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 216:	55                   	push   %ebp
 217:	89 e5                	mov    %esp,%ebp
 219:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 21c:	8b 45 08             	mov    0x8(%ebp),%eax
 21f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 222:	90                   	nop
 223:	8b 45 08             	mov    0x8(%ebp),%eax
 226:	8d 50 01             	lea    0x1(%eax),%edx
 229:	89 55 08             	mov    %edx,0x8(%ebp)
 22c:	8b 55 0c             	mov    0xc(%ebp),%edx
 22f:	8d 4a 01             	lea    0x1(%edx),%ecx
 232:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 235:	0f b6 12             	movzbl (%edx),%edx
 238:	88 10                	mov    %dl,(%eax)
 23a:	0f b6 00             	movzbl (%eax),%eax
 23d:	84 c0                	test   %al,%al
 23f:	75 e2                	jne    223 <strcpy+0xd>
    ;
  return os;
 241:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 244:	c9                   	leave  
 245:	c3                   	ret    

00000246 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 246:	55                   	push   %ebp
 247:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 249:	eb 08                	jmp    253 <strcmp+0xd>
    p++, q++;
 24b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 24f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 253:	8b 45 08             	mov    0x8(%ebp),%eax
 256:	0f b6 00             	movzbl (%eax),%eax
 259:	84 c0                	test   %al,%al
 25b:	74 10                	je     26d <strcmp+0x27>
 25d:	8b 45 08             	mov    0x8(%ebp),%eax
 260:	0f b6 10             	movzbl (%eax),%edx
 263:	8b 45 0c             	mov    0xc(%ebp),%eax
 266:	0f b6 00             	movzbl (%eax),%eax
 269:	38 c2                	cmp    %al,%dl
 26b:	74 de                	je     24b <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 26d:	8b 45 08             	mov    0x8(%ebp),%eax
 270:	0f b6 00             	movzbl (%eax),%eax
 273:	0f b6 d0             	movzbl %al,%edx
 276:	8b 45 0c             	mov    0xc(%ebp),%eax
 279:	0f b6 00             	movzbl (%eax),%eax
 27c:	0f b6 c0             	movzbl %al,%eax
 27f:	29 c2                	sub    %eax,%edx
 281:	89 d0                	mov    %edx,%eax
}
 283:	5d                   	pop    %ebp
 284:	c3                   	ret    

00000285 <strlen>:

uint
strlen(char *s)
{
 285:	55                   	push   %ebp
 286:	89 e5                	mov    %esp,%ebp
 288:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 28b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 292:	eb 04                	jmp    298 <strlen+0x13>
 294:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 298:	8b 55 fc             	mov    -0x4(%ebp),%edx
 29b:	8b 45 08             	mov    0x8(%ebp),%eax
 29e:	01 d0                	add    %edx,%eax
 2a0:	0f b6 00             	movzbl (%eax),%eax
 2a3:	84 c0                	test   %al,%al
 2a5:	75 ed                	jne    294 <strlen+0xf>
    ;
  return n;
 2a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2aa:	c9                   	leave  
 2ab:	c3                   	ret    

000002ac <memset>:

void*
memset(void *dst, int c, uint n)
{
 2ac:	55                   	push   %ebp
 2ad:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 2af:	8b 45 10             	mov    0x10(%ebp),%eax
 2b2:	50                   	push   %eax
 2b3:	ff 75 0c             	pushl  0xc(%ebp)
 2b6:	ff 75 08             	pushl  0x8(%ebp)
 2b9:	e8 32 ff ff ff       	call   1f0 <stosb>
 2be:	83 c4 0c             	add    $0xc,%esp
  return dst;
 2c1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c4:	c9                   	leave  
 2c5:	c3                   	ret    

000002c6 <strchr>:

char*
strchr(const char *s, char c)
{
 2c6:	55                   	push   %ebp
 2c7:	89 e5                	mov    %esp,%ebp
 2c9:	83 ec 04             	sub    $0x4,%esp
 2cc:	8b 45 0c             	mov    0xc(%ebp),%eax
 2cf:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2d2:	eb 14                	jmp    2e8 <strchr+0x22>
    if(*s == c)
 2d4:	8b 45 08             	mov    0x8(%ebp),%eax
 2d7:	0f b6 00             	movzbl (%eax),%eax
 2da:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2dd:	75 05                	jne    2e4 <strchr+0x1e>
      return (char*)s;
 2df:	8b 45 08             	mov    0x8(%ebp),%eax
 2e2:	eb 13                	jmp    2f7 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2e4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2e8:	8b 45 08             	mov    0x8(%ebp),%eax
 2eb:	0f b6 00             	movzbl (%eax),%eax
 2ee:	84 c0                	test   %al,%al
 2f0:	75 e2                	jne    2d4 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2f7:	c9                   	leave  
 2f8:	c3                   	ret    

000002f9 <gets>:

char*
gets(char *buf, int max)
{
 2f9:	55                   	push   %ebp
 2fa:	89 e5                	mov    %esp,%ebp
 2fc:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 306:	eb 42                	jmp    34a <gets+0x51>
    cc = read(0, &c, 1);
 308:	83 ec 04             	sub    $0x4,%esp
 30b:	6a 01                	push   $0x1
 30d:	8d 45 ef             	lea    -0x11(%ebp),%eax
 310:	50                   	push   %eax
 311:	6a 00                	push   $0x0
 313:	e8 8c 01 00 00       	call   4a4 <read>
 318:	83 c4 10             	add    $0x10,%esp
 31b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 31e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 322:	7e 33                	jle    357 <gets+0x5e>
      break;
    buf[i++] = c;
 324:	8b 45 f4             	mov    -0xc(%ebp),%eax
 327:	8d 50 01             	lea    0x1(%eax),%edx
 32a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 32d:	89 c2                	mov    %eax,%edx
 32f:	8b 45 08             	mov    0x8(%ebp),%eax
 332:	01 c2                	add    %eax,%edx
 334:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 338:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 33a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 33e:	3c 0a                	cmp    $0xa,%al
 340:	74 16                	je     358 <gets+0x5f>
 342:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 346:	3c 0d                	cmp    $0xd,%al
 348:	74 0e                	je     358 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 34a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 34d:	83 c0 01             	add    $0x1,%eax
 350:	3b 45 0c             	cmp    0xc(%ebp),%eax
 353:	7c b3                	jl     308 <gets+0xf>
 355:	eb 01                	jmp    358 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 357:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 358:	8b 55 f4             	mov    -0xc(%ebp),%edx
 35b:	8b 45 08             	mov    0x8(%ebp),%eax
 35e:	01 d0                	add    %edx,%eax
 360:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 363:	8b 45 08             	mov    0x8(%ebp),%eax
}
 366:	c9                   	leave  
 367:	c3                   	ret    

00000368 <stat>:

int
stat(char *n, struct stat *st)
{
 368:	55                   	push   %ebp
 369:	89 e5                	mov    %esp,%ebp
 36b:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 36e:	83 ec 08             	sub    $0x8,%esp
 371:	6a 00                	push   $0x0
 373:	ff 75 08             	pushl  0x8(%ebp)
 376:	e8 51 01 00 00       	call   4cc <open>
 37b:	83 c4 10             	add    $0x10,%esp
 37e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 381:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 385:	79 07                	jns    38e <stat+0x26>
    return -1;
 387:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 38c:	eb 25                	jmp    3b3 <stat+0x4b>
  r = fstat(fd, st);
 38e:	83 ec 08             	sub    $0x8,%esp
 391:	ff 75 0c             	pushl  0xc(%ebp)
 394:	ff 75 f4             	pushl  -0xc(%ebp)
 397:	e8 48 01 00 00       	call   4e4 <fstat>
 39c:	83 c4 10             	add    $0x10,%esp
 39f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 3a2:	83 ec 0c             	sub    $0xc,%esp
 3a5:	ff 75 f4             	pushl  -0xc(%ebp)
 3a8:	e8 07 01 00 00       	call   4b4 <close>
 3ad:	83 c4 10             	add    $0x10,%esp
  return r;
 3b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 3b3:	c9                   	leave  
 3b4:	c3                   	ret    

000003b5 <atoi>:

int
atoi(const char *s)
{
 3b5:	55                   	push   %ebp
 3b6:	89 e5                	mov    %esp,%ebp
 3b8:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 3bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 3c2:	eb 04                	jmp    3c8 <atoi+0x13>
 3c4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3c8:	8b 45 08             	mov    0x8(%ebp),%eax
 3cb:	0f b6 00             	movzbl (%eax),%eax
 3ce:	3c 20                	cmp    $0x20,%al
 3d0:	74 f2                	je     3c4 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 3d2:	8b 45 08             	mov    0x8(%ebp),%eax
 3d5:	0f b6 00             	movzbl (%eax),%eax
 3d8:	3c 2d                	cmp    $0x2d,%al
 3da:	75 07                	jne    3e3 <atoi+0x2e>
 3dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3e1:	eb 05                	jmp    3e8 <atoi+0x33>
 3e3:	b8 01 00 00 00       	mov    $0x1,%eax
 3e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 3eb:	8b 45 08             	mov    0x8(%ebp),%eax
 3ee:	0f b6 00             	movzbl (%eax),%eax
 3f1:	3c 2b                	cmp    $0x2b,%al
 3f3:	74 0a                	je     3ff <atoi+0x4a>
 3f5:	8b 45 08             	mov    0x8(%ebp),%eax
 3f8:	0f b6 00             	movzbl (%eax),%eax
 3fb:	3c 2d                	cmp    $0x2d,%al
 3fd:	75 2b                	jne    42a <atoi+0x75>
    s++;
 3ff:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 403:	eb 25                	jmp    42a <atoi+0x75>
    n = n*10 + *s++ - '0';
 405:	8b 55 fc             	mov    -0x4(%ebp),%edx
 408:	89 d0                	mov    %edx,%eax
 40a:	c1 e0 02             	shl    $0x2,%eax
 40d:	01 d0                	add    %edx,%eax
 40f:	01 c0                	add    %eax,%eax
 411:	89 c1                	mov    %eax,%ecx
 413:	8b 45 08             	mov    0x8(%ebp),%eax
 416:	8d 50 01             	lea    0x1(%eax),%edx
 419:	89 55 08             	mov    %edx,0x8(%ebp)
 41c:	0f b6 00             	movzbl (%eax),%eax
 41f:	0f be c0             	movsbl %al,%eax
 422:	01 c8                	add    %ecx,%eax
 424:	83 e8 30             	sub    $0x30,%eax
 427:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 42a:	8b 45 08             	mov    0x8(%ebp),%eax
 42d:	0f b6 00             	movzbl (%eax),%eax
 430:	3c 2f                	cmp    $0x2f,%al
 432:	7e 0a                	jle    43e <atoi+0x89>
 434:	8b 45 08             	mov    0x8(%ebp),%eax
 437:	0f b6 00             	movzbl (%eax),%eax
 43a:	3c 39                	cmp    $0x39,%al
 43c:	7e c7                	jle    405 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 43e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 441:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 445:	c9                   	leave  
 446:	c3                   	ret    

00000447 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 447:	55                   	push   %ebp
 448:	89 e5                	mov    %esp,%ebp
 44a:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 44d:	8b 45 08             	mov    0x8(%ebp),%eax
 450:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 453:	8b 45 0c             	mov    0xc(%ebp),%eax
 456:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 459:	eb 17                	jmp    472 <memmove+0x2b>
    *dst++ = *src++;
 45b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 45e:	8d 50 01             	lea    0x1(%eax),%edx
 461:	89 55 fc             	mov    %edx,-0x4(%ebp)
 464:	8b 55 f8             	mov    -0x8(%ebp),%edx
 467:	8d 4a 01             	lea    0x1(%edx),%ecx
 46a:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 46d:	0f b6 12             	movzbl (%edx),%edx
 470:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 472:	8b 45 10             	mov    0x10(%ebp),%eax
 475:	8d 50 ff             	lea    -0x1(%eax),%edx
 478:	89 55 10             	mov    %edx,0x10(%ebp)
 47b:	85 c0                	test   %eax,%eax
 47d:	7f dc                	jg     45b <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 47f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 482:	c9                   	leave  
 483:	c3                   	ret    

00000484 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 484:	b8 01 00 00 00       	mov    $0x1,%eax
 489:	cd 40                	int    $0x40
 48b:	c3                   	ret    

0000048c <exit>:
SYSCALL(exit)
 48c:	b8 02 00 00 00       	mov    $0x2,%eax
 491:	cd 40                	int    $0x40
 493:	c3                   	ret    

00000494 <wait>:
SYSCALL(wait)
 494:	b8 03 00 00 00       	mov    $0x3,%eax
 499:	cd 40                	int    $0x40
 49b:	c3                   	ret    

0000049c <pipe>:
SYSCALL(pipe)
 49c:	b8 04 00 00 00       	mov    $0x4,%eax
 4a1:	cd 40                	int    $0x40
 4a3:	c3                   	ret    

000004a4 <read>:
SYSCALL(read)
 4a4:	b8 05 00 00 00       	mov    $0x5,%eax
 4a9:	cd 40                	int    $0x40
 4ab:	c3                   	ret    

000004ac <write>:
SYSCALL(write)
 4ac:	b8 10 00 00 00       	mov    $0x10,%eax
 4b1:	cd 40                	int    $0x40
 4b3:	c3                   	ret    

000004b4 <close>:
SYSCALL(close)
 4b4:	b8 15 00 00 00       	mov    $0x15,%eax
 4b9:	cd 40                	int    $0x40
 4bb:	c3                   	ret    

000004bc <kill>:
SYSCALL(kill)
 4bc:	b8 06 00 00 00       	mov    $0x6,%eax
 4c1:	cd 40                	int    $0x40
 4c3:	c3                   	ret    

000004c4 <exec>:
SYSCALL(exec)
 4c4:	b8 07 00 00 00       	mov    $0x7,%eax
 4c9:	cd 40                	int    $0x40
 4cb:	c3                   	ret    

000004cc <open>:
SYSCALL(open)
 4cc:	b8 0f 00 00 00       	mov    $0xf,%eax
 4d1:	cd 40                	int    $0x40
 4d3:	c3                   	ret    

000004d4 <mknod>:
SYSCALL(mknod)
 4d4:	b8 11 00 00 00       	mov    $0x11,%eax
 4d9:	cd 40                	int    $0x40
 4db:	c3                   	ret    

000004dc <unlink>:
SYSCALL(unlink)
 4dc:	b8 12 00 00 00       	mov    $0x12,%eax
 4e1:	cd 40                	int    $0x40
 4e3:	c3                   	ret    

000004e4 <fstat>:
SYSCALL(fstat)
 4e4:	b8 08 00 00 00       	mov    $0x8,%eax
 4e9:	cd 40                	int    $0x40
 4eb:	c3                   	ret    

000004ec <link>:
SYSCALL(link)
 4ec:	b8 13 00 00 00       	mov    $0x13,%eax
 4f1:	cd 40                	int    $0x40
 4f3:	c3                   	ret    

000004f4 <mkdir>:
SYSCALL(mkdir)
 4f4:	b8 14 00 00 00       	mov    $0x14,%eax
 4f9:	cd 40                	int    $0x40
 4fb:	c3                   	ret    

000004fc <chdir>:
SYSCALL(chdir)
 4fc:	b8 09 00 00 00       	mov    $0x9,%eax
 501:	cd 40                	int    $0x40
 503:	c3                   	ret    

00000504 <dup>:
SYSCALL(dup)
 504:	b8 0a 00 00 00       	mov    $0xa,%eax
 509:	cd 40                	int    $0x40
 50b:	c3                   	ret    

0000050c <getpid>:
SYSCALL(getpid)
 50c:	b8 0b 00 00 00       	mov    $0xb,%eax
 511:	cd 40                	int    $0x40
 513:	c3                   	ret    

00000514 <sbrk>:
SYSCALL(sbrk)
 514:	b8 0c 00 00 00       	mov    $0xc,%eax
 519:	cd 40                	int    $0x40
 51b:	c3                   	ret    

0000051c <sleep>:
SYSCALL(sleep)
 51c:	b8 0d 00 00 00       	mov    $0xd,%eax
 521:	cd 40                	int    $0x40
 523:	c3                   	ret    

00000524 <uptime>:
SYSCALL(uptime)
 524:	b8 0e 00 00 00       	mov    $0xe,%eax
 529:	cd 40                	int    $0x40
 52b:	c3                   	ret    

0000052c <halt>:
SYSCALL(halt)
 52c:	b8 16 00 00 00       	mov    $0x16,%eax
 531:	cd 40                	int    $0x40
 533:	c3                   	ret    

00000534 <date>:
SYSCALL(date)
 534:	b8 17 00 00 00       	mov    $0x17,%eax
 539:	cd 40                	int    $0x40
 53b:	c3                   	ret    

0000053c <getuid>:
SYSCALL(getuid)
 53c:	b8 18 00 00 00       	mov    $0x18,%eax
 541:	cd 40                	int    $0x40
 543:	c3                   	ret    

00000544 <getgid>:
SYSCALL(getgid)
 544:	b8 19 00 00 00       	mov    $0x19,%eax
 549:	cd 40                	int    $0x40
 54b:	c3                   	ret    

0000054c <getppid>:
SYSCALL(getppid)
 54c:	b8 1a 00 00 00       	mov    $0x1a,%eax
 551:	cd 40                	int    $0x40
 553:	c3                   	ret    

00000554 <setuid>:
SYSCALL(setuid)
 554:	b8 1b 00 00 00       	mov    $0x1b,%eax
 559:	cd 40                	int    $0x40
 55b:	c3                   	ret    

0000055c <setgid>:
SYSCALL(setgid)
 55c:	b8 1c 00 00 00       	mov    $0x1c,%eax
 561:	cd 40                	int    $0x40
 563:	c3                   	ret    

00000564 <getprocs>:
SYSCALL(getprocs)
 564:	b8 1d 00 00 00       	mov    $0x1d,%eax
 569:	cd 40                	int    $0x40
 56b:	c3                   	ret    

0000056c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 56c:	55                   	push   %ebp
 56d:	89 e5                	mov    %esp,%ebp
 56f:	83 ec 18             	sub    $0x18,%esp
 572:	8b 45 0c             	mov    0xc(%ebp),%eax
 575:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 578:	83 ec 04             	sub    $0x4,%esp
 57b:	6a 01                	push   $0x1
 57d:	8d 45 f4             	lea    -0xc(%ebp),%eax
 580:	50                   	push   %eax
 581:	ff 75 08             	pushl  0x8(%ebp)
 584:	e8 23 ff ff ff       	call   4ac <write>
 589:	83 c4 10             	add    $0x10,%esp
}
 58c:	90                   	nop
 58d:	c9                   	leave  
 58e:	c3                   	ret    

0000058f <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 58f:	55                   	push   %ebp
 590:	89 e5                	mov    %esp,%ebp
 592:	53                   	push   %ebx
 593:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 596:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 59d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 5a1:	74 17                	je     5ba <printint+0x2b>
 5a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5a7:	79 11                	jns    5ba <printint+0x2b>
    neg = 1;
 5a9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 5b0:	8b 45 0c             	mov    0xc(%ebp),%eax
 5b3:	f7 d8                	neg    %eax
 5b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5b8:	eb 06                	jmp    5c0 <printint+0x31>
  } else {
    x = xx;
 5ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 5bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 5c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 5c7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 5ca:	8d 41 01             	lea    0x1(%ecx),%eax
 5cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
 5d0:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5d6:	ba 00 00 00 00       	mov    $0x0,%edx
 5db:	f7 f3                	div    %ebx
 5dd:	89 d0                	mov    %edx,%eax
 5df:	0f b6 80 00 0d 00 00 	movzbl 0xd00(%eax),%eax
 5e6:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 5ea:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5f0:	ba 00 00 00 00       	mov    $0x0,%edx
 5f5:	f7 f3                	div    %ebx
 5f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5fa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5fe:	75 c7                	jne    5c7 <printint+0x38>
  if(neg)
 600:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 604:	74 2d                	je     633 <printint+0xa4>
    buf[i++] = '-';
 606:	8b 45 f4             	mov    -0xc(%ebp),%eax
 609:	8d 50 01             	lea    0x1(%eax),%edx
 60c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 60f:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 614:	eb 1d                	jmp    633 <printint+0xa4>
    putc(fd, buf[i]);
 616:	8d 55 dc             	lea    -0x24(%ebp),%edx
 619:	8b 45 f4             	mov    -0xc(%ebp),%eax
 61c:	01 d0                	add    %edx,%eax
 61e:	0f b6 00             	movzbl (%eax),%eax
 621:	0f be c0             	movsbl %al,%eax
 624:	83 ec 08             	sub    $0x8,%esp
 627:	50                   	push   %eax
 628:	ff 75 08             	pushl  0x8(%ebp)
 62b:	e8 3c ff ff ff       	call   56c <putc>
 630:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 633:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 637:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 63b:	79 d9                	jns    616 <printint+0x87>
    putc(fd, buf[i]);
}
 63d:	90                   	nop
 63e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 641:	c9                   	leave  
 642:	c3                   	ret    

00000643 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 643:	55                   	push   %ebp
 644:	89 e5                	mov    %esp,%ebp
 646:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 649:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 650:	8d 45 0c             	lea    0xc(%ebp),%eax
 653:	83 c0 04             	add    $0x4,%eax
 656:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 659:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 660:	e9 59 01 00 00       	jmp    7be <printf+0x17b>
    c = fmt[i] & 0xff;
 665:	8b 55 0c             	mov    0xc(%ebp),%edx
 668:	8b 45 f0             	mov    -0x10(%ebp),%eax
 66b:	01 d0                	add    %edx,%eax
 66d:	0f b6 00             	movzbl (%eax),%eax
 670:	0f be c0             	movsbl %al,%eax
 673:	25 ff 00 00 00       	and    $0xff,%eax
 678:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 67b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 67f:	75 2c                	jne    6ad <printf+0x6a>
      if(c == '%'){
 681:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 685:	75 0c                	jne    693 <printf+0x50>
        state = '%';
 687:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 68e:	e9 27 01 00 00       	jmp    7ba <printf+0x177>
      } else {
        putc(fd, c);
 693:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 696:	0f be c0             	movsbl %al,%eax
 699:	83 ec 08             	sub    $0x8,%esp
 69c:	50                   	push   %eax
 69d:	ff 75 08             	pushl  0x8(%ebp)
 6a0:	e8 c7 fe ff ff       	call   56c <putc>
 6a5:	83 c4 10             	add    $0x10,%esp
 6a8:	e9 0d 01 00 00       	jmp    7ba <printf+0x177>
      }
    } else if(state == '%'){
 6ad:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 6b1:	0f 85 03 01 00 00    	jne    7ba <printf+0x177>
      if(c == 'd'){
 6b7:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 6bb:	75 1e                	jne    6db <printf+0x98>
        printint(fd, *ap, 10, 1);
 6bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6c0:	8b 00                	mov    (%eax),%eax
 6c2:	6a 01                	push   $0x1
 6c4:	6a 0a                	push   $0xa
 6c6:	50                   	push   %eax
 6c7:	ff 75 08             	pushl  0x8(%ebp)
 6ca:	e8 c0 fe ff ff       	call   58f <printint>
 6cf:	83 c4 10             	add    $0x10,%esp
        ap++;
 6d2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6d6:	e9 d8 00 00 00       	jmp    7b3 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 6db:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6df:	74 06                	je     6e7 <printf+0xa4>
 6e1:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6e5:	75 1e                	jne    705 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 6e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6ea:	8b 00                	mov    (%eax),%eax
 6ec:	6a 00                	push   $0x0
 6ee:	6a 10                	push   $0x10
 6f0:	50                   	push   %eax
 6f1:	ff 75 08             	pushl  0x8(%ebp)
 6f4:	e8 96 fe ff ff       	call   58f <printint>
 6f9:	83 c4 10             	add    $0x10,%esp
        ap++;
 6fc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 700:	e9 ae 00 00 00       	jmp    7b3 <printf+0x170>
      } else if(c == 's'){
 705:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 709:	75 43                	jne    74e <printf+0x10b>
        s = (char*)*ap;
 70b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 70e:	8b 00                	mov    (%eax),%eax
 710:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 713:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 717:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 71b:	75 25                	jne    742 <printf+0xff>
          s = "(null)";
 71d:	c7 45 f4 89 0a 00 00 	movl   $0xa89,-0xc(%ebp)
        while(*s != 0){
 724:	eb 1c                	jmp    742 <printf+0xff>
          putc(fd, *s);
 726:	8b 45 f4             	mov    -0xc(%ebp),%eax
 729:	0f b6 00             	movzbl (%eax),%eax
 72c:	0f be c0             	movsbl %al,%eax
 72f:	83 ec 08             	sub    $0x8,%esp
 732:	50                   	push   %eax
 733:	ff 75 08             	pushl  0x8(%ebp)
 736:	e8 31 fe ff ff       	call   56c <putc>
 73b:	83 c4 10             	add    $0x10,%esp
          s++;
 73e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 742:	8b 45 f4             	mov    -0xc(%ebp),%eax
 745:	0f b6 00             	movzbl (%eax),%eax
 748:	84 c0                	test   %al,%al
 74a:	75 da                	jne    726 <printf+0xe3>
 74c:	eb 65                	jmp    7b3 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 74e:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 752:	75 1d                	jne    771 <printf+0x12e>
        putc(fd, *ap);
 754:	8b 45 e8             	mov    -0x18(%ebp),%eax
 757:	8b 00                	mov    (%eax),%eax
 759:	0f be c0             	movsbl %al,%eax
 75c:	83 ec 08             	sub    $0x8,%esp
 75f:	50                   	push   %eax
 760:	ff 75 08             	pushl  0x8(%ebp)
 763:	e8 04 fe ff ff       	call   56c <putc>
 768:	83 c4 10             	add    $0x10,%esp
        ap++;
 76b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 76f:	eb 42                	jmp    7b3 <printf+0x170>
      } else if(c == '%'){
 771:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 775:	75 17                	jne    78e <printf+0x14b>
        putc(fd, c);
 777:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 77a:	0f be c0             	movsbl %al,%eax
 77d:	83 ec 08             	sub    $0x8,%esp
 780:	50                   	push   %eax
 781:	ff 75 08             	pushl  0x8(%ebp)
 784:	e8 e3 fd ff ff       	call   56c <putc>
 789:	83 c4 10             	add    $0x10,%esp
 78c:	eb 25                	jmp    7b3 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 78e:	83 ec 08             	sub    $0x8,%esp
 791:	6a 25                	push   $0x25
 793:	ff 75 08             	pushl  0x8(%ebp)
 796:	e8 d1 fd ff ff       	call   56c <putc>
 79b:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 79e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7a1:	0f be c0             	movsbl %al,%eax
 7a4:	83 ec 08             	sub    $0x8,%esp
 7a7:	50                   	push   %eax
 7a8:	ff 75 08             	pushl  0x8(%ebp)
 7ab:	e8 bc fd ff ff       	call   56c <putc>
 7b0:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 7b3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7ba:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 7be:	8b 55 0c             	mov    0xc(%ebp),%edx
 7c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c4:	01 d0                	add    %edx,%eax
 7c6:	0f b6 00             	movzbl (%eax),%eax
 7c9:	84 c0                	test   %al,%al
 7cb:	0f 85 94 fe ff ff    	jne    665 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7d1:	90                   	nop
 7d2:	c9                   	leave  
 7d3:	c3                   	ret    

000007d4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7d4:	55                   	push   %ebp
 7d5:	89 e5                	mov    %esp,%ebp
 7d7:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7da:	8b 45 08             	mov    0x8(%ebp),%eax
 7dd:	83 e8 08             	sub    $0x8,%eax
 7e0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e3:	a1 1c 0d 00 00       	mov    0xd1c,%eax
 7e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7eb:	eb 24                	jmp    811 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f0:	8b 00                	mov    (%eax),%eax
 7f2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7f5:	77 12                	ja     809 <free+0x35>
 7f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7fa:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7fd:	77 24                	ja     823 <free+0x4f>
 7ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 802:	8b 00                	mov    (%eax),%eax
 804:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 807:	77 1a                	ja     823 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 809:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80c:	8b 00                	mov    (%eax),%eax
 80e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 811:	8b 45 f8             	mov    -0x8(%ebp),%eax
 814:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 817:	76 d4                	jbe    7ed <free+0x19>
 819:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81c:	8b 00                	mov    (%eax),%eax
 81e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 821:	76 ca                	jbe    7ed <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 823:	8b 45 f8             	mov    -0x8(%ebp),%eax
 826:	8b 40 04             	mov    0x4(%eax),%eax
 829:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 830:	8b 45 f8             	mov    -0x8(%ebp),%eax
 833:	01 c2                	add    %eax,%edx
 835:	8b 45 fc             	mov    -0x4(%ebp),%eax
 838:	8b 00                	mov    (%eax),%eax
 83a:	39 c2                	cmp    %eax,%edx
 83c:	75 24                	jne    862 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 83e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 841:	8b 50 04             	mov    0x4(%eax),%edx
 844:	8b 45 fc             	mov    -0x4(%ebp),%eax
 847:	8b 00                	mov    (%eax),%eax
 849:	8b 40 04             	mov    0x4(%eax),%eax
 84c:	01 c2                	add    %eax,%edx
 84e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 851:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 854:	8b 45 fc             	mov    -0x4(%ebp),%eax
 857:	8b 00                	mov    (%eax),%eax
 859:	8b 10                	mov    (%eax),%edx
 85b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 85e:	89 10                	mov    %edx,(%eax)
 860:	eb 0a                	jmp    86c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 862:	8b 45 fc             	mov    -0x4(%ebp),%eax
 865:	8b 10                	mov    (%eax),%edx
 867:	8b 45 f8             	mov    -0x8(%ebp),%eax
 86a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 86c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86f:	8b 40 04             	mov    0x4(%eax),%eax
 872:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 879:	8b 45 fc             	mov    -0x4(%ebp),%eax
 87c:	01 d0                	add    %edx,%eax
 87e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 881:	75 20                	jne    8a3 <free+0xcf>
    p->s.size += bp->s.size;
 883:	8b 45 fc             	mov    -0x4(%ebp),%eax
 886:	8b 50 04             	mov    0x4(%eax),%edx
 889:	8b 45 f8             	mov    -0x8(%ebp),%eax
 88c:	8b 40 04             	mov    0x4(%eax),%eax
 88f:	01 c2                	add    %eax,%edx
 891:	8b 45 fc             	mov    -0x4(%ebp),%eax
 894:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 897:	8b 45 f8             	mov    -0x8(%ebp),%eax
 89a:	8b 10                	mov    (%eax),%edx
 89c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 89f:	89 10                	mov    %edx,(%eax)
 8a1:	eb 08                	jmp    8ab <free+0xd7>
  } else
    p->s.ptr = bp;
 8a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8a9:	89 10                	mov    %edx,(%eax)
  freep = p;
 8ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ae:	a3 1c 0d 00 00       	mov    %eax,0xd1c
}
 8b3:	90                   	nop
 8b4:	c9                   	leave  
 8b5:	c3                   	ret    

000008b6 <morecore>:

static Header*
morecore(uint nu)
{
 8b6:	55                   	push   %ebp
 8b7:	89 e5                	mov    %esp,%ebp
 8b9:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 8bc:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 8c3:	77 07                	ja     8cc <morecore+0x16>
    nu = 4096;
 8c5:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8cc:	8b 45 08             	mov    0x8(%ebp),%eax
 8cf:	c1 e0 03             	shl    $0x3,%eax
 8d2:	83 ec 0c             	sub    $0xc,%esp
 8d5:	50                   	push   %eax
 8d6:	e8 39 fc ff ff       	call   514 <sbrk>
 8db:	83 c4 10             	add    $0x10,%esp
 8de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8e1:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8e5:	75 07                	jne    8ee <morecore+0x38>
    return 0;
 8e7:	b8 00 00 00 00       	mov    $0x0,%eax
 8ec:	eb 26                	jmp    914 <morecore+0x5e>
  hp = (Header*)p;
 8ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f7:	8b 55 08             	mov    0x8(%ebp),%edx
 8fa:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 900:	83 c0 08             	add    $0x8,%eax
 903:	83 ec 0c             	sub    $0xc,%esp
 906:	50                   	push   %eax
 907:	e8 c8 fe ff ff       	call   7d4 <free>
 90c:	83 c4 10             	add    $0x10,%esp
  return freep;
 90f:	a1 1c 0d 00 00       	mov    0xd1c,%eax
}
 914:	c9                   	leave  
 915:	c3                   	ret    

00000916 <malloc>:

void*
malloc(uint nbytes)
{
 916:	55                   	push   %ebp
 917:	89 e5                	mov    %esp,%ebp
 919:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 91c:	8b 45 08             	mov    0x8(%ebp),%eax
 91f:	83 c0 07             	add    $0x7,%eax
 922:	c1 e8 03             	shr    $0x3,%eax
 925:	83 c0 01             	add    $0x1,%eax
 928:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 92b:	a1 1c 0d 00 00       	mov    0xd1c,%eax
 930:	89 45 f0             	mov    %eax,-0x10(%ebp)
 933:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 937:	75 23                	jne    95c <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 939:	c7 45 f0 14 0d 00 00 	movl   $0xd14,-0x10(%ebp)
 940:	8b 45 f0             	mov    -0x10(%ebp),%eax
 943:	a3 1c 0d 00 00       	mov    %eax,0xd1c
 948:	a1 1c 0d 00 00       	mov    0xd1c,%eax
 94d:	a3 14 0d 00 00       	mov    %eax,0xd14
    base.s.size = 0;
 952:	c7 05 18 0d 00 00 00 	movl   $0x0,0xd18
 959:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 95c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 95f:	8b 00                	mov    (%eax),%eax
 961:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 964:	8b 45 f4             	mov    -0xc(%ebp),%eax
 967:	8b 40 04             	mov    0x4(%eax),%eax
 96a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 96d:	72 4d                	jb     9bc <malloc+0xa6>
      if(p->s.size == nunits)
 96f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 972:	8b 40 04             	mov    0x4(%eax),%eax
 975:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 978:	75 0c                	jne    986 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 97a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97d:	8b 10                	mov    (%eax),%edx
 97f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 982:	89 10                	mov    %edx,(%eax)
 984:	eb 26                	jmp    9ac <malloc+0x96>
      else {
        p->s.size -= nunits;
 986:	8b 45 f4             	mov    -0xc(%ebp),%eax
 989:	8b 40 04             	mov    0x4(%eax),%eax
 98c:	2b 45 ec             	sub    -0x14(%ebp),%eax
 98f:	89 c2                	mov    %eax,%edx
 991:	8b 45 f4             	mov    -0xc(%ebp),%eax
 994:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 997:	8b 45 f4             	mov    -0xc(%ebp),%eax
 99a:	8b 40 04             	mov    0x4(%eax),%eax
 99d:	c1 e0 03             	shl    $0x3,%eax
 9a0:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 9a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
 9a9:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 9ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9af:	a3 1c 0d 00 00       	mov    %eax,0xd1c
      return (void*)(p + 1);
 9b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b7:	83 c0 08             	add    $0x8,%eax
 9ba:	eb 3b                	jmp    9f7 <malloc+0xe1>
    }
    if(p == freep)
 9bc:	a1 1c 0d 00 00       	mov    0xd1c,%eax
 9c1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 9c4:	75 1e                	jne    9e4 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 9c6:	83 ec 0c             	sub    $0xc,%esp
 9c9:	ff 75 ec             	pushl  -0x14(%ebp)
 9cc:	e8 e5 fe ff ff       	call   8b6 <morecore>
 9d1:	83 c4 10             	add    $0x10,%esp
 9d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9db:	75 07                	jne    9e4 <malloc+0xce>
        return 0;
 9dd:	b8 00 00 00 00       	mov    $0x0,%eax
 9e2:	eb 13                	jmp    9f7 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ed:	8b 00                	mov    (%eax),%eax
 9ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 9f2:	e9 6d ff ff ff       	jmp    964 <malloc+0x4e>
}
 9f7:	c9                   	leave  
 9f8:	c3                   	ret    
