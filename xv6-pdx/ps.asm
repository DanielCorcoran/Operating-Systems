
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
  17:	68 00 17 00 00       	push   $0x1700
  1c:	e8 e8 08 00 00       	call   909 <malloc>
  21:	83 c4 10             	add    $0x10,%esp
  24:	89 45 e0             	mov    %eax,-0x20(%ebp)

  running_procs = getprocs(UPROC_TABLE_MAX, table);
  27:	83 ec 08             	sub    $0x8,%esp
  2a:	ff 75 e0             	pushl  -0x20(%ebp)
  2d:	6a 40                	push   $0x40
  2f:	e8 23 05 00 00       	call   557 <getprocs>
  34:	83 c4 10             	add    $0x10,%esp
  37:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(running_procs == 0) {
  3a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  3e:	75 1b                	jne    5b <main+0x5b>
    printf(2, "Error: ps call failed.  %s at line %d\n", __FILE__, __LINE__);
  40:	6a 11                	push   $0x11
  42:	68 ec 09 00 00       	push   $0x9ec
  47:	68 f4 09 00 00       	push   $0x9f4
  4c:	6a 02                	push   $0x2
  4e:	e8 e3 05 00 00       	call   636 <printf>
  53:	83 c4 10             	add    $0x10,%esp
    exit();
  56:	e8 24 04 00 00       	call   47f <exit>
  }

  printf(1, "PID\tName\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\n");
  5b:	83 ec 08             	sub    $0x8,%esp
  5e:	68 1c 0a 00 00       	push   $0xa1c
  63:	6a 01                	push   $0x1
  65:	e8 cc 05 00 00       	call   636 <printf>
  6a:	83 c4 10             	add    $0x10,%esp
  for(int i = 0; i < running_procs; i++){
  6d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  74:	e9 c1 00 00 00       	jmp    13a <main+0x13a>
    printf(1, "%d\t%s\t%d\t%d\t%d\t", table[i].pid, table[i].name,
        table[i].uid, table[i].gid, table[i].ppid);
  79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  7c:	6b d0 5c             	imul   $0x5c,%eax,%edx
  7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  82:	01 d0                	add    %edx,%eax
    exit();
  }

  printf(1, "PID\tName\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\n");
  for(int i = 0; i < running_procs; i++){
    printf(1, "%d\t%s\t%d\t%d\t%d\t", table[i].pid, table[i].name,
  84:	8b 58 0c             	mov    0xc(%eax),%ebx
        table[i].uid, table[i].gid, table[i].ppid);
  87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8a:	6b d0 5c             	imul   $0x5c,%eax,%edx
  8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  90:	01 d0                	add    %edx,%eax
    exit();
  }

  printf(1, "PID\tName\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\n");
  for(int i = 0; i < running_procs; i++){
    printf(1, "%d\t%s\t%d\t%d\t%d\t", table[i].pid, table[i].name,
  92:	8b 48 08             	mov    0x8(%eax),%ecx
        table[i].uid, table[i].gid, table[i].ppid);
  95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  98:	6b d0 5c             	imul   $0x5c,%eax,%edx
  9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  9e:	01 d0                	add    %edx,%eax
    exit();
  }

  printf(1, "PID\tName\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\n");
  for(int i = 0; i < running_procs; i++){
    printf(1, "%d\t%s\t%d\t%d\t%d\t", table[i].pid, table[i].name,
  a0:	8b 50 04             	mov    0x4(%eax),%edx
  a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  a6:	6b f0 5c             	imul   $0x5c,%eax,%esi
  a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  ac:	01 f0                	add    %esi,%eax
  ae:	8d 70 3c             	lea    0x3c(%eax),%esi
  b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  b4:	6b f8 5c             	imul   $0x5c,%eax,%edi
  b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  ba:	01 f8                	add    %edi,%eax
  bc:	8b 00                	mov    (%eax),%eax
  be:	83 ec 04             	sub    $0x4,%esp
  c1:	53                   	push   %ebx
  c2:	51                   	push   %ecx
  c3:	52                   	push   %edx
  c4:	56                   	push   %esi
  c5:	50                   	push   %eax
  c6:	68 4a 0a 00 00       	push   $0xa4a
  cb:	6a 01                	push   $0x1
  cd:	e8 64 05 00 00       	call   636 <printf>
  d2:	83 c4 20             	add    $0x20,%esp
        table[i].uid, table[i].gid, table[i].ppid);
    calcelapsedtime(table[i].elapsed_ticks);
  d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  d8:	6b d0 5c             	imul   $0x5c,%eax,%edx
  db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  de:	01 d0                	add    %edx,%eax
  e0:	8b 40 10             	mov    0x10(%eax),%eax
  e3:	83 ec 0c             	sub    $0xc,%esp
  e6:	50                   	push   %eax
  e7:	e8 5f 00 00 00       	call   14b <calcelapsedtime>
  ec:	83 c4 10             	add    $0x10,%esp
    calcelapsedtime(table[i].CPU_total_ticks);
  ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  f2:	6b d0 5c             	imul   $0x5c,%eax,%edx
  f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  f8:	01 d0                	add    %edx,%eax
  fa:	8b 40 14             	mov    0x14(%eax),%eax
  fd:	83 ec 0c             	sub    $0xc,%esp
 100:	50                   	push   %eax
 101:	e8 45 00 00 00       	call   14b <calcelapsedtime>
 106:	83 c4 10             	add    $0x10,%esp
    printf(1, "%s\t%d\n", table[i].state, table[i].size);
 109:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 10c:	6b d0 5c             	imul   $0x5c,%eax,%edx
 10f:	8b 45 e0             	mov    -0x20(%ebp),%eax
 112:	01 d0                	add    %edx,%eax
 114:	8b 40 38             	mov    0x38(%eax),%eax
 117:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 11a:	6b ca 5c             	imul   $0x5c,%edx,%ecx
 11d:	8b 55 e0             	mov    -0x20(%ebp),%edx
 120:	01 ca                	add    %ecx,%edx
 122:	83 c2 18             	add    $0x18,%edx
 125:	50                   	push   %eax
 126:	52                   	push   %edx
 127:	68 5a 0a 00 00       	push   $0xa5a
 12c:	6a 01                	push   $0x1
 12e:	e8 03 05 00 00       	call   636 <printf>
 133:	83 c4 10             	add    $0x10,%esp
    printf(2, "Error: ps call failed.  %s at line %d\n", __FILE__, __LINE__);
    exit();
  }

  printf(1, "PID\tName\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\n");
  for(int i = 0; i < running_procs; i++){
 136:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 13a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 13d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
 140:	0f 8c 33 ff ff ff    	jl     79 <main+0x79>
    calcelapsedtime(table[i].elapsed_ticks);
    calcelapsedtime(table[i].CPU_total_ticks);
    printf(1, "%s\t%d\n", table[i].state, table[i].size);
  }

  exit();
 146:	e8 34 03 00 00       	call   47f <exit>

0000014b <calcelapsedtime>:

// Determines the seconds elapsed for a running process to the thousandth of a
// second and prints the result
void
calcelapsedtime(int ticks_in)
{
 14b:	55                   	push   %ebp
 14c:	89 e5                	mov    %esp,%ebp
 14e:	83 ec 18             	sub    $0x18,%esp
  int seconds = (ticks_in)/1000;
 151:	8b 4d 08             	mov    0x8(%ebp),%ecx
 154:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
 159:	89 c8                	mov    %ecx,%eax
 15b:	f7 ea                	imul   %edx
 15d:	c1 fa 06             	sar    $0x6,%edx
 160:	89 c8                	mov    %ecx,%eax
 162:	c1 f8 1f             	sar    $0x1f,%eax
 165:	29 c2                	sub    %eax,%edx
 167:	89 d0                	mov    %edx,%eax
 169:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int milliseconds = (ticks_in)%1000;
 16c:	8b 4d 08             	mov    0x8(%ebp),%ecx
 16f:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
 174:	89 c8                	mov    %ecx,%eax
 176:	f7 ea                	imul   %edx
 178:	c1 fa 06             	sar    $0x6,%edx
 17b:	89 c8                	mov    %ecx,%eax
 17d:	c1 f8 1f             	sar    $0x1f,%eax
 180:	29 c2                	sub    %eax,%edx
 182:	89 d0                	mov    %edx,%eax
 184:	69 c0 e8 03 00 00    	imul   $0x3e8,%eax,%eax
 18a:	29 c1                	sub    %eax,%ecx
 18c:	89 c8                	mov    %ecx,%eax
 18e:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(milliseconds < 10)
 191:	83 7d f0 09          	cmpl   $0x9,-0x10(%ebp)
 195:	7f 17                	jg     1ae <calcelapsedtime+0x63>
    printf(1, "%d.00%d\t", seconds, milliseconds);
 197:	ff 75 f0             	pushl  -0x10(%ebp)
 19a:	ff 75 f4             	pushl  -0xc(%ebp)
 19d:	68 61 0a 00 00       	push   $0xa61
 1a2:	6a 01                	push   $0x1
 1a4:	e8 8d 04 00 00       	call   636 <printf>
 1a9:	83 c4 10             	add    $0x10,%esp
  else if(milliseconds < 100)
    printf(1, "%d.0%d\t", seconds, milliseconds);
  else
    printf(1, "%d.%d\t", seconds, milliseconds);
}
 1ac:	eb 32                	jmp    1e0 <calcelapsedtime+0x95>
  int seconds = (ticks_in)/1000;
  int milliseconds = (ticks_in)%1000;

  if(milliseconds < 10)
    printf(1, "%d.00%d\t", seconds, milliseconds);
  else if(milliseconds < 100)
 1ae:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
 1b2:	7f 17                	jg     1cb <calcelapsedtime+0x80>
    printf(1, "%d.0%d\t", seconds, milliseconds);
 1b4:	ff 75 f0             	pushl  -0x10(%ebp)
 1b7:	ff 75 f4             	pushl  -0xc(%ebp)
 1ba:	68 6a 0a 00 00       	push   $0xa6a
 1bf:	6a 01                	push   $0x1
 1c1:	e8 70 04 00 00       	call   636 <printf>
 1c6:	83 c4 10             	add    $0x10,%esp
  else
    printf(1, "%d.%d\t", seconds, milliseconds);
}
 1c9:	eb 15                	jmp    1e0 <calcelapsedtime+0x95>
  if(milliseconds < 10)
    printf(1, "%d.00%d\t", seconds, milliseconds);
  else if(milliseconds < 100)
    printf(1, "%d.0%d\t", seconds, milliseconds);
  else
    printf(1, "%d.%d\t", seconds, milliseconds);
 1cb:	ff 75 f0             	pushl  -0x10(%ebp)
 1ce:	ff 75 f4             	pushl  -0xc(%ebp)
 1d1:	68 72 0a 00 00       	push   $0xa72
 1d6:	6a 01                	push   $0x1
 1d8:	e8 59 04 00 00       	call   636 <printf>
 1dd:	83 c4 10             	add    $0x10,%esp
}
 1e0:	90                   	nop
 1e1:	c9                   	leave  
 1e2:	c3                   	ret    

000001e3 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1e3:	55                   	push   %ebp
 1e4:	89 e5                	mov    %esp,%ebp
 1e6:	57                   	push   %edi
 1e7:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1eb:	8b 55 10             	mov    0x10(%ebp),%edx
 1ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f1:	89 cb                	mov    %ecx,%ebx
 1f3:	89 df                	mov    %ebx,%edi
 1f5:	89 d1                	mov    %edx,%ecx
 1f7:	fc                   	cld    
 1f8:	f3 aa                	rep stos %al,%es:(%edi)
 1fa:	89 ca                	mov    %ecx,%edx
 1fc:	89 fb                	mov    %edi,%ebx
 1fe:	89 5d 08             	mov    %ebx,0x8(%ebp)
 201:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 204:	90                   	nop
 205:	5b                   	pop    %ebx
 206:	5f                   	pop    %edi
 207:	5d                   	pop    %ebp
 208:	c3                   	ret    

00000209 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 209:	55                   	push   %ebp
 20a:	89 e5                	mov    %esp,%ebp
 20c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 20f:	8b 45 08             	mov    0x8(%ebp),%eax
 212:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 215:	90                   	nop
 216:	8b 45 08             	mov    0x8(%ebp),%eax
 219:	8d 50 01             	lea    0x1(%eax),%edx
 21c:	89 55 08             	mov    %edx,0x8(%ebp)
 21f:	8b 55 0c             	mov    0xc(%ebp),%edx
 222:	8d 4a 01             	lea    0x1(%edx),%ecx
 225:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 228:	0f b6 12             	movzbl (%edx),%edx
 22b:	88 10                	mov    %dl,(%eax)
 22d:	0f b6 00             	movzbl (%eax),%eax
 230:	84 c0                	test   %al,%al
 232:	75 e2                	jne    216 <strcpy+0xd>
    ;
  return os;
 234:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 237:	c9                   	leave  
 238:	c3                   	ret    

00000239 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 239:	55                   	push   %ebp
 23a:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 23c:	eb 08                	jmp    246 <strcmp+0xd>
    p++, q++;
 23e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 242:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 246:	8b 45 08             	mov    0x8(%ebp),%eax
 249:	0f b6 00             	movzbl (%eax),%eax
 24c:	84 c0                	test   %al,%al
 24e:	74 10                	je     260 <strcmp+0x27>
 250:	8b 45 08             	mov    0x8(%ebp),%eax
 253:	0f b6 10             	movzbl (%eax),%edx
 256:	8b 45 0c             	mov    0xc(%ebp),%eax
 259:	0f b6 00             	movzbl (%eax),%eax
 25c:	38 c2                	cmp    %al,%dl
 25e:	74 de                	je     23e <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 260:	8b 45 08             	mov    0x8(%ebp),%eax
 263:	0f b6 00             	movzbl (%eax),%eax
 266:	0f b6 d0             	movzbl %al,%edx
 269:	8b 45 0c             	mov    0xc(%ebp),%eax
 26c:	0f b6 00             	movzbl (%eax),%eax
 26f:	0f b6 c0             	movzbl %al,%eax
 272:	29 c2                	sub    %eax,%edx
 274:	89 d0                	mov    %edx,%eax
}
 276:	5d                   	pop    %ebp
 277:	c3                   	ret    

00000278 <strlen>:

uint
strlen(char *s)
{
 278:	55                   	push   %ebp
 279:	89 e5                	mov    %esp,%ebp
 27b:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 27e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 285:	eb 04                	jmp    28b <strlen+0x13>
 287:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 28b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 28e:	8b 45 08             	mov    0x8(%ebp),%eax
 291:	01 d0                	add    %edx,%eax
 293:	0f b6 00             	movzbl (%eax),%eax
 296:	84 c0                	test   %al,%al
 298:	75 ed                	jne    287 <strlen+0xf>
    ;
  return n;
 29a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 29d:	c9                   	leave  
 29e:	c3                   	ret    

0000029f <memset>:

void*
memset(void *dst, int c, uint n)
{
 29f:	55                   	push   %ebp
 2a0:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 2a2:	8b 45 10             	mov    0x10(%ebp),%eax
 2a5:	50                   	push   %eax
 2a6:	ff 75 0c             	pushl  0xc(%ebp)
 2a9:	ff 75 08             	pushl  0x8(%ebp)
 2ac:	e8 32 ff ff ff       	call   1e3 <stosb>
 2b1:	83 c4 0c             	add    $0xc,%esp
  return dst;
 2b4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2b7:	c9                   	leave  
 2b8:	c3                   	ret    

000002b9 <strchr>:

char*
strchr(const char *s, char c)
{
 2b9:	55                   	push   %ebp
 2ba:	89 e5                	mov    %esp,%ebp
 2bc:	83 ec 04             	sub    $0x4,%esp
 2bf:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c2:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2c5:	eb 14                	jmp    2db <strchr+0x22>
    if(*s == c)
 2c7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ca:	0f b6 00             	movzbl (%eax),%eax
 2cd:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2d0:	75 05                	jne    2d7 <strchr+0x1e>
      return (char*)s;
 2d2:	8b 45 08             	mov    0x8(%ebp),%eax
 2d5:	eb 13                	jmp    2ea <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2d7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2db:	8b 45 08             	mov    0x8(%ebp),%eax
 2de:	0f b6 00             	movzbl (%eax),%eax
 2e1:	84 c0                	test   %al,%al
 2e3:	75 e2                	jne    2c7 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2ea:	c9                   	leave  
 2eb:	c3                   	ret    

000002ec <gets>:

char*
gets(char *buf, int max)
{
 2ec:	55                   	push   %ebp
 2ed:	89 e5                	mov    %esp,%ebp
 2ef:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2f9:	eb 42                	jmp    33d <gets+0x51>
    cc = read(0, &c, 1);
 2fb:	83 ec 04             	sub    $0x4,%esp
 2fe:	6a 01                	push   $0x1
 300:	8d 45 ef             	lea    -0x11(%ebp),%eax
 303:	50                   	push   %eax
 304:	6a 00                	push   $0x0
 306:	e8 8c 01 00 00       	call   497 <read>
 30b:	83 c4 10             	add    $0x10,%esp
 30e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 311:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 315:	7e 33                	jle    34a <gets+0x5e>
      break;
    buf[i++] = c;
 317:	8b 45 f4             	mov    -0xc(%ebp),%eax
 31a:	8d 50 01             	lea    0x1(%eax),%edx
 31d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 320:	89 c2                	mov    %eax,%edx
 322:	8b 45 08             	mov    0x8(%ebp),%eax
 325:	01 c2                	add    %eax,%edx
 327:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 32b:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 32d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 331:	3c 0a                	cmp    $0xa,%al
 333:	74 16                	je     34b <gets+0x5f>
 335:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 339:	3c 0d                	cmp    $0xd,%al
 33b:	74 0e                	je     34b <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 33d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 340:	83 c0 01             	add    $0x1,%eax
 343:	3b 45 0c             	cmp    0xc(%ebp),%eax
 346:	7c b3                	jl     2fb <gets+0xf>
 348:	eb 01                	jmp    34b <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 34a:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 34b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 34e:	8b 45 08             	mov    0x8(%ebp),%eax
 351:	01 d0                	add    %edx,%eax
 353:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 356:	8b 45 08             	mov    0x8(%ebp),%eax
}
 359:	c9                   	leave  
 35a:	c3                   	ret    

0000035b <stat>:

int
stat(char *n, struct stat *st)
{
 35b:	55                   	push   %ebp
 35c:	89 e5                	mov    %esp,%ebp
 35e:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 361:	83 ec 08             	sub    $0x8,%esp
 364:	6a 00                	push   $0x0
 366:	ff 75 08             	pushl  0x8(%ebp)
 369:	e8 51 01 00 00       	call   4bf <open>
 36e:	83 c4 10             	add    $0x10,%esp
 371:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 374:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 378:	79 07                	jns    381 <stat+0x26>
    return -1;
 37a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 37f:	eb 25                	jmp    3a6 <stat+0x4b>
  r = fstat(fd, st);
 381:	83 ec 08             	sub    $0x8,%esp
 384:	ff 75 0c             	pushl  0xc(%ebp)
 387:	ff 75 f4             	pushl  -0xc(%ebp)
 38a:	e8 48 01 00 00       	call   4d7 <fstat>
 38f:	83 c4 10             	add    $0x10,%esp
 392:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 395:	83 ec 0c             	sub    $0xc,%esp
 398:	ff 75 f4             	pushl  -0xc(%ebp)
 39b:	e8 07 01 00 00       	call   4a7 <close>
 3a0:	83 c4 10             	add    $0x10,%esp
  return r;
 3a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 3a6:	c9                   	leave  
 3a7:	c3                   	ret    

000003a8 <atoi>:

int
atoi(const char *s)
{
 3a8:	55                   	push   %ebp
 3a9:	89 e5                	mov    %esp,%ebp
 3ab:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 3ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 3b5:	eb 04                	jmp    3bb <atoi+0x13>
 3b7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3bb:	8b 45 08             	mov    0x8(%ebp),%eax
 3be:	0f b6 00             	movzbl (%eax),%eax
 3c1:	3c 20                	cmp    $0x20,%al
 3c3:	74 f2                	je     3b7 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 3c5:	8b 45 08             	mov    0x8(%ebp),%eax
 3c8:	0f b6 00             	movzbl (%eax),%eax
 3cb:	3c 2d                	cmp    $0x2d,%al
 3cd:	75 07                	jne    3d6 <atoi+0x2e>
 3cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3d4:	eb 05                	jmp    3db <atoi+0x33>
 3d6:	b8 01 00 00 00       	mov    $0x1,%eax
 3db:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 3de:	8b 45 08             	mov    0x8(%ebp),%eax
 3e1:	0f b6 00             	movzbl (%eax),%eax
 3e4:	3c 2b                	cmp    $0x2b,%al
 3e6:	74 0a                	je     3f2 <atoi+0x4a>
 3e8:	8b 45 08             	mov    0x8(%ebp),%eax
 3eb:	0f b6 00             	movzbl (%eax),%eax
 3ee:	3c 2d                	cmp    $0x2d,%al
 3f0:	75 2b                	jne    41d <atoi+0x75>
    s++;
 3f2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 3f6:	eb 25                	jmp    41d <atoi+0x75>
    n = n*10 + *s++ - '0';
 3f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3fb:	89 d0                	mov    %edx,%eax
 3fd:	c1 e0 02             	shl    $0x2,%eax
 400:	01 d0                	add    %edx,%eax
 402:	01 c0                	add    %eax,%eax
 404:	89 c1                	mov    %eax,%ecx
 406:	8b 45 08             	mov    0x8(%ebp),%eax
 409:	8d 50 01             	lea    0x1(%eax),%edx
 40c:	89 55 08             	mov    %edx,0x8(%ebp)
 40f:	0f b6 00             	movzbl (%eax),%eax
 412:	0f be c0             	movsbl %al,%eax
 415:	01 c8                	add    %ecx,%eax
 417:	83 e8 30             	sub    $0x30,%eax
 41a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 41d:	8b 45 08             	mov    0x8(%ebp),%eax
 420:	0f b6 00             	movzbl (%eax),%eax
 423:	3c 2f                	cmp    $0x2f,%al
 425:	7e 0a                	jle    431 <atoi+0x89>
 427:	8b 45 08             	mov    0x8(%ebp),%eax
 42a:	0f b6 00             	movzbl (%eax),%eax
 42d:	3c 39                	cmp    $0x39,%al
 42f:	7e c7                	jle    3f8 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 431:	8b 45 f8             	mov    -0x8(%ebp),%eax
 434:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 438:	c9                   	leave  
 439:	c3                   	ret    

0000043a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 43a:	55                   	push   %ebp
 43b:	89 e5                	mov    %esp,%ebp
 43d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 440:	8b 45 08             	mov    0x8(%ebp),%eax
 443:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 446:	8b 45 0c             	mov    0xc(%ebp),%eax
 449:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 44c:	eb 17                	jmp    465 <memmove+0x2b>
    *dst++ = *src++;
 44e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 451:	8d 50 01             	lea    0x1(%eax),%edx
 454:	89 55 fc             	mov    %edx,-0x4(%ebp)
 457:	8b 55 f8             	mov    -0x8(%ebp),%edx
 45a:	8d 4a 01             	lea    0x1(%edx),%ecx
 45d:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 460:	0f b6 12             	movzbl (%edx),%edx
 463:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 465:	8b 45 10             	mov    0x10(%ebp),%eax
 468:	8d 50 ff             	lea    -0x1(%eax),%edx
 46b:	89 55 10             	mov    %edx,0x10(%ebp)
 46e:	85 c0                	test   %eax,%eax
 470:	7f dc                	jg     44e <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 472:	8b 45 08             	mov    0x8(%ebp),%eax
}
 475:	c9                   	leave  
 476:	c3                   	ret    

00000477 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 477:	b8 01 00 00 00       	mov    $0x1,%eax
 47c:	cd 40                	int    $0x40
 47e:	c3                   	ret    

0000047f <exit>:
SYSCALL(exit)
 47f:	b8 02 00 00 00       	mov    $0x2,%eax
 484:	cd 40                	int    $0x40
 486:	c3                   	ret    

00000487 <wait>:
SYSCALL(wait)
 487:	b8 03 00 00 00       	mov    $0x3,%eax
 48c:	cd 40                	int    $0x40
 48e:	c3                   	ret    

0000048f <pipe>:
SYSCALL(pipe)
 48f:	b8 04 00 00 00       	mov    $0x4,%eax
 494:	cd 40                	int    $0x40
 496:	c3                   	ret    

00000497 <read>:
SYSCALL(read)
 497:	b8 05 00 00 00       	mov    $0x5,%eax
 49c:	cd 40                	int    $0x40
 49e:	c3                   	ret    

0000049f <write>:
SYSCALL(write)
 49f:	b8 10 00 00 00       	mov    $0x10,%eax
 4a4:	cd 40                	int    $0x40
 4a6:	c3                   	ret    

000004a7 <close>:
SYSCALL(close)
 4a7:	b8 15 00 00 00       	mov    $0x15,%eax
 4ac:	cd 40                	int    $0x40
 4ae:	c3                   	ret    

000004af <kill>:
SYSCALL(kill)
 4af:	b8 06 00 00 00       	mov    $0x6,%eax
 4b4:	cd 40                	int    $0x40
 4b6:	c3                   	ret    

000004b7 <exec>:
SYSCALL(exec)
 4b7:	b8 07 00 00 00       	mov    $0x7,%eax
 4bc:	cd 40                	int    $0x40
 4be:	c3                   	ret    

000004bf <open>:
SYSCALL(open)
 4bf:	b8 0f 00 00 00       	mov    $0xf,%eax
 4c4:	cd 40                	int    $0x40
 4c6:	c3                   	ret    

000004c7 <mknod>:
SYSCALL(mknod)
 4c7:	b8 11 00 00 00       	mov    $0x11,%eax
 4cc:	cd 40                	int    $0x40
 4ce:	c3                   	ret    

000004cf <unlink>:
SYSCALL(unlink)
 4cf:	b8 12 00 00 00       	mov    $0x12,%eax
 4d4:	cd 40                	int    $0x40
 4d6:	c3                   	ret    

000004d7 <fstat>:
SYSCALL(fstat)
 4d7:	b8 08 00 00 00       	mov    $0x8,%eax
 4dc:	cd 40                	int    $0x40
 4de:	c3                   	ret    

000004df <link>:
SYSCALL(link)
 4df:	b8 13 00 00 00       	mov    $0x13,%eax
 4e4:	cd 40                	int    $0x40
 4e6:	c3                   	ret    

000004e7 <mkdir>:
SYSCALL(mkdir)
 4e7:	b8 14 00 00 00       	mov    $0x14,%eax
 4ec:	cd 40                	int    $0x40
 4ee:	c3                   	ret    

000004ef <chdir>:
SYSCALL(chdir)
 4ef:	b8 09 00 00 00       	mov    $0x9,%eax
 4f4:	cd 40                	int    $0x40
 4f6:	c3                   	ret    

000004f7 <dup>:
SYSCALL(dup)
 4f7:	b8 0a 00 00 00       	mov    $0xa,%eax
 4fc:	cd 40                	int    $0x40
 4fe:	c3                   	ret    

000004ff <getpid>:
SYSCALL(getpid)
 4ff:	b8 0b 00 00 00       	mov    $0xb,%eax
 504:	cd 40                	int    $0x40
 506:	c3                   	ret    

00000507 <sbrk>:
SYSCALL(sbrk)
 507:	b8 0c 00 00 00       	mov    $0xc,%eax
 50c:	cd 40                	int    $0x40
 50e:	c3                   	ret    

0000050f <sleep>:
SYSCALL(sleep)
 50f:	b8 0d 00 00 00       	mov    $0xd,%eax
 514:	cd 40                	int    $0x40
 516:	c3                   	ret    

00000517 <uptime>:
SYSCALL(uptime)
 517:	b8 0e 00 00 00       	mov    $0xe,%eax
 51c:	cd 40                	int    $0x40
 51e:	c3                   	ret    

0000051f <halt>:
SYSCALL(halt)
 51f:	b8 16 00 00 00       	mov    $0x16,%eax
 524:	cd 40                	int    $0x40
 526:	c3                   	ret    

00000527 <date>:
SYSCALL(date)
 527:	b8 17 00 00 00       	mov    $0x17,%eax
 52c:	cd 40                	int    $0x40
 52e:	c3                   	ret    

0000052f <getuid>:
SYSCALL(getuid)
 52f:	b8 18 00 00 00       	mov    $0x18,%eax
 534:	cd 40                	int    $0x40
 536:	c3                   	ret    

00000537 <getgid>:
SYSCALL(getgid)
 537:	b8 19 00 00 00       	mov    $0x19,%eax
 53c:	cd 40                	int    $0x40
 53e:	c3                   	ret    

0000053f <getppid>:
SYSCALL(getppid)
 53f:	b8 1a 00 00 00       	mov    $0x1a,%eax
 544:	cd 40                	int    $0x40
 546:	c3                   	ret    

00000547 <setuid>:
SYSCALL(setuid)
 547:	b8 1b 00 00 00       	mov    $0x1b,%eax
 54c:	cd 40                	int    $0x40
 54e:	c3                   	ret    

0000054f <setgid>:
SYSCALL(setgid)
 54f:	b8 1c 00 00 00       	mov    $0x1c,%eax
 554:	cd 40                	int    $0x40
 556:	c3                   	ret    

00000557 <getprocs>:
SYSCALL(getprocs)
 557:	b8 1d 00 00 00       	mov    $0x1d,%eax
 55c:	cd 40                	int    $0x40
 55e:	c3                   	ret    

0000055f <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 55f:	55                   	push   %ebp
 560:	89 e5                	mov    %esp,%ebp
 562:	83 ec 18             	sub    $0x18,%esp
 565:	8b 45 0c             	mov    0xc(%ebp),%eax
 568:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 56b:	83 ec 04             	sub    $0x4,%esp
 56e:	6a 01                	push   $0x1
 570:	8d 45 f4             	lea    -0xc(%ebp),%eax
 573:	50                   	push   %eax
 574:	ff 75 08             	pushl  0x8(%ebp)
 577:	e8 23 ff ff ff       	call   49f <write>
 57c:	83 c4 10             	add    $0x10,%esp
}
 57f:	90                   	nop
 580:	c9                   	leave  
 581:	c3                   	ret    

00000582 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 582:	55                   	push   %ebp
 583:	89 e5                	mov    %esp,%ebp
 585:	53                   	push   %ebx
 586:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 589:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 590:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 594:	74 17                	je     5ad <printint+0x2b>
 596:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 59a:	79 11                	jns    5ad <printint+0x2b>
    neg = 1;
 59c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 5a3:	8b 45 0c             	mov    0xc(%ebp),%eax
 5a6:	f7 d8                	neg    %eax
 5a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5ab:	eb 06                	jmp    5b3 <printint+0x31>
  } else {
    x = xx;
 5ad:	8b 45 0c             	mov    0xc(%ebp),%eax
 5b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 5b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 5ba:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 5bd:	8d 41 01             	lea    0x1(%ecx),%eax
 5c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
 5c3:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5c9:	ba 00 00 00 00       	mov    $0x0,%edx
 5ce:	f7 f3                	div    %ebx
 5d0:	89 d0                	mov    %edx,%eax
 5d2:	0f b6 80 f4 0c 00 00 	movzbl 0xcf4(%eax),%eax
 5d9:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 5dd:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5e3:	ba 00 00 00 00       	mov    $0x0,%edx
 5e8:	f7 f3                	div    %ebx
 5ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5ed:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5f1:	75 c7                	jne    5ba <printint+0x38>
  if(neg)
 5f3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5f7:	74 2d                	je     626 <printint+0xa4>
    buf[i++] = '-';
 5f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5fc:	8d 50 01             	lea    0x1(%eax),%edx
 5ff:	89 55 f4             	mov    %edx,-0xc(%ebp)
 602:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 607:	eb 1d                	jmp    626 <printint+0xa4>
    putc(fd, buf[i]);
 609:	8d 55 dc             	lea    -0x24(%ebp),%edx
 60c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 60f:	01 d0                	add    %edx,%eax
 611:	0f b6 00             	movzbl (%eax),%eax
 614:	0f be c0             	movsbl %al,%eax
 617:	83 ec 08             	sub    $0x8,%esp
 61a:	50                   	push   %eax
 61b:	ff 75 08             	pushl  0x8(%ebp)
 61e:	e8 3c ff ff ff       	call   55f <putc>
 623:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 626:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 62a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 62e:	79 d9                	jns    609 <printint+0x87>
    putc(fd, buf[i]);
}
 630:	90                   	nop
 631:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 634:	c9                   	leave  
 635:	c3                   	ret    

00000636 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 636:	55                   	push   %ebp
 637:	89 e5                	mov    %esp,%ebp
 639:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 63c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 643:	8d 45 0c             	lea    0xc(%ebp),%eax
 646:	83 c0 04             	add    $0x4,%eax
 649:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 64c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 653:	e9 59 01 00 00       	jmp    7b1 <printf+0x17b>
    c = fmt[i] & 0xff;
 658:	8b 55 0c             	mov    0xc(%ebp),%edx
 65b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 65e:	01 d0                	add    %edx,%eax
 660:	0f b6 00             	movzbl (%eax),%eax
 663:	0f be c0             	movsbl %al,%eax
 666:	25 ff 00 00 00       	and    $0xff,%eax
 66b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 66e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 672:	75 2c                	jne    6a0 <printf+0x6a>
      if(c == '%'){
 674:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 678:	75 0c                	jne    686 <printf+0x50>
        state = '%';
 67a:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 681:	e9 27 01 00 00       	jmp    7ad <printf+0x177>
      } else {
        putc(fd, c);
 686:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 689:	0f be c0             	movsbl %al,%eax
 68c:	83 ec 08             	sub    $0x8,%esp
 68f:	50                   	push   %eax
 690:	ff 75 08             	pushl  0x8(%ebp)
 693:	e8 c7 fe ff ff       	call   55f <putc>
 698:	83 c4 10             	add    $0x10,%esp
 69b:	e9 0d 01 00 00       	jmp    7ad <printf+0x177>
      }
    } else if(state == '%'){
 6a0:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 6a4:	0f 85 03 01 00 00    	jne    7ad <printf+0x177>
      if(c == 'd'){
 6aa:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 6ae:	75 1e                	jne    6ce <printf+0x98>
        printint(fd, *ap, 10, 1);
 6b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6b3:	8b 00                	mov    (%eax),%eax
 6b5:	6a 01                	push   $0x1
 6b7:	6a 0a                	push   $0xa
 6b9:	50                   	push   %eax
 6ba:	ff 75 08             	pushl  0x8(%ebp)
 6bd:	e8 c0 fe ff ff       	call   582 <printint>
 6c2:	83 c4 10             	add    $0x10,%esp
        ap++;
 6c5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6c9:	e9 d8 00 00 00       	jmp    7a6 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 6ce:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6d2:	74 06                	je     6da <printf+0xa4>
 6d4:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6d8:	75 1e                	jne    6f8 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 6da:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6dd:	8b 00                	mov    (%eax),%eax
 6df:	6a 00                	push   $0x0
 6e1:	6a 10                	push   $0x10
 6e3:	50                   	push   %eax
 6e4:	ff 75 08             	pushl  0x8(%ebp)
 6e7:	e8 96 fe ff ff       	call   582 <printint>
 6ec:	83 c4 10             	add    $0x10,%esp
        ap++;
 6ef:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6f3:	e9 ae 00 00 00       	jmp    7a6 <printf+0x170>
      } else if(c == 's'){
 6f8:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6fc:	75 43                	jne    741 <printf+0x10b>
        s = (char*)*ap;
 6fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
 701:	8b 00                	mov    (%eax),%eax
 703:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 706:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 70a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 70e:	75 25                	jne    735 <printf+0xff>
          s = "(null)";
 710:	c7 45 f4 79 0a 00 00 	movl   $0xa79,-0xc(%ebp)
        while(*s != 0){
 717:	eb 1c                	jmp    735 <printf+0xff>
          putc(fd, *s);
 719:	8b 45 f4             	mov    -0xc(%ebp),%eax
 71c:	0f b6 00             	movzbl (%eax),%eax
 71f:	0f be c0             	movsbl %al,%eax
 722:	83 ec 08             	sub    $0x8,%esp
 725:	50                   	push   %eax
 726:	ff 75 08             	pushl  0x8(%ebp)
 729:	e8 31 fe ff ff       	call   55f <putc>
 72e:	83 c4 10             	add    $0x10,%esp
          s++;
 731:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 735:	8b 45 f4             	mov    -0xc(%ebp),%eax
 738:	0f b6 00             	movzbl (%eax),%eax
 73b:	84 c0                	test   %al,%al
 73d:	75 da                	jne    719 <printf+0xe3>
 73f:	eb 65                	jmp    7a6 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 741:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 745:	75 1d                	jne    764 <printf+0x12e>
        putc(fd, *ap);
 747:	8b 45 e8             	mov    -0x18(%ebp),%eax
 74a:	8b 00                	mov    (%eax),%eax
 74c:	0f be c0             	movsbl %al,%eax
 74f:	83 ec 08             	sub    $0x8,%esp
 752:	50                   	push   %eax
 753:	ff 75 08             	pushl  0x8(%ebp)
 756:	e8 04 fe ff ff       	call   55f <putc>
 75b:	83 c4 10             	add    $0x10,%esp
        ap++;
 75e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 762:	eb 42                	jmp    7a6 <printf+0x170>
      } else if(c == '%'){
 764:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 768:	75 17                	jne    781 <printf+0x14b>
        putc(fd, c);
 76a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 76d:	0f be c0             	movsbl %al,%eax
 770:	83 ec 08             	sub    $0x8,%esp
 773:	50                   	push   %eax
 774:	ff 75 08             	pushl  0x8(%ebp)
 777:	e8 e3 fd ff ff       	call   55f <putc>
 77c:	83 c4 10             	add    $0x10,%esp
 77f:	eb 25                	jmp    7a6 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 781:	83 ec 08             	sub    $0x8,%esp
 784:	6a 25                	push   $0x25
 786:	ff 75 08             	pushl  0x8(%ebp)
 789:	e8 d1 fd ff ff       	call   55f <putc>
 78e:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 791:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 794:	0f be c0             	movsbl %al,%eax
 797:	83 ec 08             	sub    $0x8,%esp
 79a:	50                   	push   %eax
 79b:	ff 75 08             	pushl  0x8(%ebp)
 79e:	e8 bc fd ff ff       	call   55f <putc>
 7a3:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 7a6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7ad:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 7b1:	8b 55 0c             	mov    0xc(%ebp),%edx
 7b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b7:	01 d0                	add    %edx,%eax
 7b9:	0f b6 00             	movzbl (%eax),%eax
 7bc:	84 c0                	test   %al,%al
 7be:	0f 85 94 fe ff ff    	jne    658 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7c4:	90                   	nop
 7c5:	c9                   	leave  
 7c6:	c3                   	ret    

000007c7 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7c7:	55                   	push   %ebp
 7c8:	89 e5                	mov    %esp,%ebp
 7ca:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7cd:	8b 45 08             	mov    0x8(%ebp),%eax
 7d0:	83 e8 08             	sub    $0x8,%eax
 7d3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d6:	a1 10 0d 00 00       	mov    0xd10,%eax
 7db:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7de:	eb 24                	jmp    804 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e3:	8b 00                	mov    (%eax),%eax
 7e5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7e8:	77 12                	ja     7fc <free+0x35>
 7ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ed:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7f0:	77 24                	ja     816 <free+0x4f>
 7f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f5:	8b 00                	mov    (%eax),%eax
 7f7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7fa:	77 1a                	ja     816 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ff:	8b 00                	mov    (%eax),%eax
 801:	89 45 fc             	mov    %eax,-0x4(%ebp)
 804:	8b 45 f8             	mov    -0x8(%ebp),%eax
 807:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 80a:	76 d4                	jbe    7e0 <free+0x19>
 80c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80f:	8b 00                	mov    (%eax),%eax
 811:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 814:	76 ca                	jbe    7e0 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 816:	8b 45 f8             	mov    -0x8(%ebp),%eax
 819:	8b 40 04             	mov    0x4(%eax),%eax
 81c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 823:	8b 45 f8             	mov    -0x8(%ebp),%eax
 826:	01 c2                	add    %eax,%edx
 828:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82b:	8b 00                	mov    (%eax),%eax
 82d:	39 c2                	cmp    %eax,%edx
 82f:	75 24                	jne    855 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 831:	8b 45 f8             	mov    -0x8(%ebp),%eax
 834:	8b 50 04             	mov    0x4(%eax),%edx
 837:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83a:	8b 00                	mov    (%eax),%eax
 83c:	8b 40 04             	mov    0x4(%eax),%eax
 83f:	01 c2                	add    %eax,%edx
 841:	8b 45 f8             	mov    -0x8(%ebp),%eax
 844:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 847:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84a:	8b 00                	mov    (%eax),%eax
 84c:	8b 10                	mov    (%eax),%edx
 84e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 851:	89 10                	mov    %edx,(%eax)
 853:	eb 0a                	jmp    85f <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 855:	8b 45 fc             	mov    -0x4(%ebp),%eax
 858:	8b 10                	mov    (%eax),%edx
 85a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 85d:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 85f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 862:	8b 40 04             	mov    0x4(%eax),%eax
 865:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 86c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86f:	01 d0                	add    %edx,%eax
 871:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 874:	75 20                	jne    896 <free+0xcf>
    p->s.size += bp->s.size;
 876:	8b 45 fc             	mov    -0x4(%ebp),%eax
 879:	8b 50 04             	mov    0x4(%eax),%edx
 87c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 87f:	8b 40 04             	mov    0x4(%eax),%eax
 882:	01 c2                	add    %eax,%edx
 884:	8b 45 fc             	mov    -0x4(%ebp),%eax
 887:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 88a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 88d:	8b 10                	mov    (%eax),%edx
 88f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 892:	89 10                	mov    %edx,(%eax)
 894:	eb 08                	jmp    89e <free+0xd7>
  } else
    p->s.ptr = bp;
 896:	8b 45 fc             	mov    -0x4(%ebp),%eax
 899:	8b 55 f8             	mov    -0x8(%ebp),%edx
 89c:	89 10                	mov    %edx,(%eax)
  freep = p;
 89e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a1:	a3 10 0d 00 00       	mov    %eax,0xd10
}
 8a6:	90                   	nop
 8a7:	c9                   	leave  
 8a8:	c3                   	ret    

000008a9 <morecore>:

static Header*
morecore(uint nu)
{
 8a9:	55                   	push   %ebp
 8aa:	89 e5                	mov    %esp,%ebp
 8ac:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 8af:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 8b6:	77 07                	ja     8bf <morecore+0x16>
    nu = 4096;
 8b8:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8bf:	8b 45 08             	mov    0x8(%ebp),%eax
 8c2:	c1 e0 03             	shl    $0x3,%eax
 8c5:	83 ec 0c             	sub    $0xc,%esp
 8c8:	50                   	push   %eax
 8c9:	e8 39 fc ff ff       	call   507 <sbrk>
 8ce:	83 c4 10             	add    $0x10,%esp
 8d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8d4:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8d8:	75 07                	jne    8e1 <morecore+0x38>
    return 0;
 8da:	b8 00 00 00 00       	mov    $0x0,%eax
 8df:	eb 26                	jmp    907 <morecore+0x5e>
  hp = (Header*)p;
 8e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ea:	8b 55 08             	mov    0x8(%ebp),%edx
 8ed:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f3:	83 c0 08             	add    $0x8,%eax
 8f6:	83 ec 0c             	sub    $0xc,%esp
 8f9:	50                   	push   %eax
 8fa:	e8 c8 fe ff ff       	call   7c7 <free>
 8ff:	83 c4 10             	add    $0x10,%esp
  return freep;
 902:	a1 10 0d 00 00       	mov    0xd10,%eax
}
 907:	c9                   	leave  
 908:	c3                   	ret    

00000909 <malloc>:

void*
malloc(uint nbytes)
{
 909:	55                   	push   %ebp
 90a:	89 e5                	mov    %esp,%ebp
 90c:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 90f:	8b 45 08             	mov    0x8(%ebp),%eax
 912:	83 c0 07             	add    $0x7,%eax
 915:	c1 e8 03             	shr    $0x3,%eax
 918:	83 c0 01             	add    $0x1,%eax
 91b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 91e:	a1 10 0d 00 00       	mov    0xd10,%eax
 923:	89 45 f0             	mov    %eax,-0x10(%ebp)
 926:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 92a:	75 23                	jne    94f <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 92c:	c7 45 f0 08 0d 00 00 	movl   $0xd08,-0x10(%ebp)
 933:	8b 45 f0             	mov    -0x10(%ebp),%eax
 936:	a3 10 0d 00 00       	mov    %eax,0xd10
 93b:	a1 10 0d 00 00       	mov    0xd10,%eax
 940:	a3 08 0d 00 00       	mov    %eax,0xd08
    base.s.size = 0;
 945:	c7 05 0c 0d 00 00 00 	movl   $0x0,0xd0c
 94c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 94f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 952:	8b 00                	mov    (%eax),%eax
 954:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 957:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95a:	8b 40 04             	mov    0x4(%eax),%eax
 95d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 960:	72 4d                	jb     9af <malloc+0xa6>
      if(p->s.size == nunits)
 962:	8b 45 f4             	mov    -0xc(%ebp),%eax
 965:	8b 40 04             	mov    0x4(%eax),%eax
 968:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 96b:	75 0c                	jne    979 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 96d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 970:	8b 10                	mov    (%eax),%edx
 972:	8b 45 f0             	mov    -0x10(%ebp),%eax
 975:	89 10                	mov    %edx,(%eax)
 977:	eb 26                	jmp    99f <malloc+0x96>
      else {
        p->s.size -= nunits;
 979:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97c:	8b 40 04             	mov    0x4(%eax),%eax
 97f:	2b 45 ec             	sub    -0x14(%ebp),%eax
 982:	89 c2                	mov    %eax,%edx
 984:	8b 45 f4             	mov    -0xc(%ebp),%eax
 987:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 98a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 98d:	8b 40 04             	mov    0x4(%eax),%eax
 990:	c1 e0 03             	shl    $0x3,%eax
 993:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 996:	8b 45 f4             	mov    -0xc(%ebp),%eax
 999:	8b 55 ec             	mov    -0x14(%ebp),%edx
 99c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 99f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9a2:	a3 10 0d 00 00       	mov    %eax,0xd10
      return (void*)(p + 1);
 9a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9aa:	83 c0 08             	add    $0x8,%eax
 9ad:	eb 3b                	jmp    9ea <malloc+0xe1>
    }
    if(p == freep)
 9af:	a1 10 0d 00 00       	mov    0xd10,%eax
 9b4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 9b7:	75 1e                	jne    9d7 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 9b9:	83 ec 0c             	sub    $0xc,%esp
 9bc:	ff 75 ec             	pushl  -0x14(%ebp)
 9bf:	e8 e5 fe ff ff       	call   8a9 <morecore>
 9c4:	83 c4 10             	add    $0x10,%esp
 9c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9ce:	75 07                	jne    9d7 <malloc+0xce>
        return 0;
 9d0:	b8 00 00 00 00       	mov    $0x0,%eax
 9d5:	eb 13                	jmp    9ea <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9da:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e0:	8b 00                	mov    (%eax),%eax
 9e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 9e5:	e9 6d ff ff ff       	jmp    957 <malloc+0x4e>
}
 9ea:	c9                   	leave  
 9eb:	c3                   	ret    
