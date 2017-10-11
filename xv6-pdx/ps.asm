
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
  1c:	e8 f6 08 00 00       	call   917 <malloc>
  21:	83 c4 10             	add    $0x10,%esp
  24:	89 45 e0             	mov    %eax,-0x20(%ebp)

  running_procs = getprocs(UPROC_TABLE_MAX, table);
  27:	83 ec 08             	sub    $0x8,%esp
  2a:	ff 75 e0             	pushl  -0x20(%ebp)
  2d:	6a 40                	push   $0x40
  2f:	e8 31 05 00 00       	call   565 <getprocs>
  34:	83 c4 10             	add    $0x10,%esp
  37:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(running_procs == 0) {
  3a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  3e:	75 1b                	jne    5b <main+0x5b>
    printf(2, "Error: ps call failed.  %s at line %d\n", __FILE__, __LINE__);
  40:	6a 11                	push   $0x11
  42:	68 fc 09 00 00       	push   $0x9fc
  47:	68 04 0a 00 00       	push   $0xa04
  4c:	6a 02                	push   $0x2
  4e:	e8 f1 05 00 00       	call   644 <printf>
  53:	83 c4 10             	add    $0x10,%esp
    exit();
  56:	e8 32 04 00 00       	call   48d <exit>
  }

  printf(1, "PID\tName\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\n");
  5b:	83 ec 08             	sub    $0x8,%esp
  5e:	68 2c 0a 00 00       	push   $0xa2c
  63:	6a 01                	push   $0x1
  65:	e8 da 05 00 00       	call   644 <printf>
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
  c6:	68 5a 0a 00 00       	push   $0xa5a
  cb:	6a 01                	push   $0x1
  cd:	e8 72 05 00 00       	call   644 <printf>
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
  e7:	e8 6d 00 00 00       	call   159 <calcelapsedtime>
  ec:	83 c4 10             	add    $0x10,%esp
    calcelapsedtime(table[i].CPU_total_ticks);
  ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  f2:	6b d0 5c             	imul   $0x5c,%eax,%edx
  f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  f8:	01 d0                	add    %edx,%eax
  fa:	8b 40 14             	mov    0x14(%eax),%eax
  fd:	83 ec 0c             	sub    $0xc,%esp
 100:	50                   	push   %eax
 101:	e8 53 00 00 00       	call   159 <calcelapsedtime>
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
 127:	68 6a 0a 00 00       	push   $0xa6a
 12c:	6a 01                	push   $0x1
 12e:	e8 11 05 00 00       	call   644 <printf>
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

  free(table);
 146:	83 ec 0c             	sub    $0xc,%esp
 149:	ff 75 e0             	pushl  -0x20(%ebp)
 14c:	e8 84 06 00 00       	call   7d5 <free>
 151:	83 c4 10             	add    $0x10,%esp
  exit();
 154:	e8 34 03 00 00       	call   48d <exit>

00000159 <calcelapsedtime>:

// Determines the seconds elapsed for a running process to the thousandth of a
// second and prints the result
void
calcelapsedtime(int ticks_in)
{
 159:	55                   	push   %ebp
 15a:	89 e5                	mov    %esp,%ebp
 15c:	83 ec 18             	sub    $0x18,%esp
  int seconds = (ticks_in)/1000;
 15f:	8b 4d 08             	mov    0x8(%ebp),%ecx
 162:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
 167:	89 c8                	mov    %ecx,%eax
 169:	f7 ea                	imul   %edx
 16b:	c1 fa 06             	sar    $0x6,%edx
 16e:	89 c8                	mov    %ecx,%eax
 170:	c1 f8 1f             	sar    $0x1f,%eax
 173:	29 c2                	sub    %eax,%edx
 175:	89 d0                	mov    %edx,%eax
 177:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int milliseconds = (ticks_in)%1000;
 17a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 17d:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
 182:	89 c8                	mov    %ecx,%eax
 184:	f7 ea                	imul   %edx
 186:	c1 fa 06             	sar    $0x6,%edx
 189:	89 c8                	mov    %ecx,%eax
 18b:	c1 f8 1f             	sar    $0x1f,%eax
 18e:	29 c2                	sub    %eax,%edx
 190:	89 d0                	mov    %edx,%eax
 192:	69 c0 e8 03 00 00    	imul   $0x3e8,%eax,%eax
 198:	29 c1                	sub    %eax,%ecx
 19a:	89 c8                	mov    %ecx,%eax
 19c:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(milliseconds < 10)
 19f:	83 7d f0 09          	cmpl   $0x9,-0x10(%ebp)
 1a3:	7f 17                	jg     1bc <calcelapsedtime+0x63>
    printf(1, "%d.00%d\t", seconds, milliseconds);
 1a5:	ff 75 f0             	pushl  -0x10(%ebp)
 1a8:	ff 75 f4             	pushl  -0xc(%ebp)
 1ab:	68 71 0a 00 00       	push   $0xa71
 1b0:	6a 01                	push   $0x1
 1b2:	e8 8d 04 00 00       	call   644 <printf>
 1b7:	83 c4 10             	add    $0x10,%esp
  else if(milliseconds < 100)
    printf(1, "%d.0%d\t", seconds, milliseconds);
  else
    printf(1, "%d.%d\t", seconds, milliseconds);
}
 1ba:	eb 32                	jmp    1ee <calcelapsedtime+0x95>
  int seconds = (ticks_in)/1000;
  int milliseconds = (ticks_in)%1000;

  if(milliseconds < 10)
    printf(1, "%d.00%d\t", seconds, milliseconds);
  else if(milliseconds < 100)
 1bc:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
 1c0:	7f 17                	jg     1d9 <calcelapsedtime+0x80>
    printf(1, "%d.0%d\t", seconds, milliseconds);
 1c2:	ff 75 f0             	pushl  -0x10(%ebp)
 1c5:	ff 75 f4             	pushl  -0xc(%ebp)
 1c8:	68 7a 0a 00 00       	push   $0xa7a
 1cd:	6a 01                	push   $0x1
 1cf:	e8 70 04 00 00       	call   644 <printf>
 1d4:	83 c4 10             	add    $0x10,%esp
  else
    printf(1, "%d.%d\t", seconds, milliseconds);
}
 1d7:	eb 15                	jmp    1ee <calcelapsedtime+0x95>
  if(milliseconds < 10)
    printf(1, "%d.00%d\t", seconds, milliseconds);
  else if(milliseconds < 100)
    printf(1, "%d.0%d\t", seconds, milliseconds);
  else
    printf(1, "%d.%d\t", seconds, milliseconds);
 1d9:	ff 75 f0             	pushl  -0x10(%ebp)
 1dc:	ff 75 f4             	pushl  -0xc(%ebp)
 1df:	68 82 0a 00 00       	push   $0xa82
 1e4:	6a 01                	push   $0x1
 1e6:	e8 59 04 00 00       	call   644 <printf>
 1eb:	83 c4 10             	add    $0x10,%esp
}
 1ee:	90                   	nop
 1ef:	c9                   	leave  
 1f0:	c3                   	ret    

000001f1 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1f1:	55                   	push   %ebp
 1f2:	89 e5                	mov    %esp,%ebp
 1f4:	57                   	push   %edi
 1f5:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1f9:	8b 55 10             	mov    0x10(%ebp),%edx
 1fc:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ff:	89 cb                	mov    %ecx,%ebx
 201:	89 df                	mov    %ebx,%edi
 203:	89 d1                	mov    %edx,%ecx
 205:	fc                   	cld    
 206:	f3 aa                	rep stos %al,%es:(%edi)
 208:	89 ca                	mov    %ecx,%edx
 20a:	89 fb                	mov    %edi,%ebx
 20c:	89 5d 08             	mov    %ebx,0x8(%ebp)
 20f:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 212:	90                   	nop
 213:	5b                   	pop    %ebx
 214:	5f                   	pop    %edi
 215:	5d                   	pop    %ebp
 216:	c3                   	ret    

00000217 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 217:	55                   	push   %ebp
 218:	89 e5                	mov    %esp,%ebp
 21a:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 21d:	8b 45 08             	mov    0x8(%ebp),%eax
 220:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 223:	90                   	nop
 224:	8b 45 08             	mov    0x8(%ebp),%eax
 227:	8d 50 01             	lea    0x1(%eax),%edx
 22a:	89 55 08             	mov    %edx,0x8(%ebp)
 22d:	8b 55 0c             	mov    0xc(%ebp),%edx
 230:	8d 4a 01             	lea    0x1(%edx),%ecx
 233:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 236:	0f b6 12             	movzbl (%edx),%edx
 239:	88 10                	mov    %dl,(%eax)
 23b:	0f b6 00             	movzbl (%eax),%eax
 23e:	84 c0                	test   %al,%al
 240:	75 e2                	jne    224 <strcpy+0xd>
    ;
  return os;
 242:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 245:	c9                   	leave  
 246:	c3                   	ret    

00000247 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 247:	55                   	push   %ebp
 248:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 24a:	eb 08                	jmp    254 <strcmp+0xd>
    p++, q++;
 24c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 250:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 254:	8b 45 08             	mov    0x8(%ebp),%eax
 257:	0f b6 00             	movzbl (%eax),%eax
 25a:	84 c0                	test   %al,%al
 25c:	74 10                	je     26e <strcmp+0x27>
 25e:	8b 45 08             	mov    0x8(%ebp),%eax
 261:	0f b6 10             	movzbl (%eax),%edx
 264:	8b 45 0c             	mov    0xc(%ebp),%eax
 267:	0f b6 00             	movzbl (%eax),%eax
 26a:	38 c2                	cmp    %al,%dl
 26c:	74 de                	je     24c <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 26e:	8b 45 08             	mov    0x8(%ebp),%eax
 271:	0f b6 00             	movzbl (%eax),%eax
 274:	0f b6 d0             	movzbl %al,%edx
 277:	8b 45 0c             	mov    0xc(%ebp),%eax
 27a:	0f b6 00             	movzbl (%eax),%eax
 27d:	0f b6 c0             	movzbl %al,%eax
 280:	29 c2                	sub    %eax,%edx
 282:	89 d0                	mov    %edx,%eax
}
 284:	5d                   	pop    %ebp
 285:	c3                   	ret    

00000286 <strlen>:

uint
strlen(char *s)
{
 286:	55                   	push   %ebp
 287:	89 e5                	mov    %esp,%ebp
 289:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 28c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 293:	eb 04                	jmp    299 <strlen+0x13>
 295:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 299:	8b 55 fc             	mov    -0x4(%ebp),%edx
 29c:	8b 45 08             	mov    0x8(%ebp),%eax
 29f:	01 d0                	add    %edx,%eax
 2a1:	0f b6 00             	movzbl (%eax),%eax
 2a4:	84 c0                	test   %al,%al
 2a6:	75 ed                	jne    295 <strlen+0xf>
    ;
  return n;
 2a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2ab:	c9                   	leave  
 2ac:	c3                   	ret    

000002ad <memset>:

void*
memset(void *dst, int c, uint n)
{
 2ad:	55                   	push   %ebp
 2ae:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 2b0:	8b 45 10             	mov    0x10(%ebp),%eax
 2b3:	50                   	push   %eax
 2b4:	ff 75 0c             	pushl  0xc(%ebp)
 2b7:	ff 75 08             	pushl  0x8(%ebp)
 2ba:	e8 32 ff ff ff       	call   1f1 <stosb>
 2bf:	83 c4 0c             	add    $0xc,%esp
  return dst;
 2c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c5:	c9                   	leave  
 2c6:	c3                   	ret    

000002c7 <strchr>:

char*
strchr(const char *s, char c)
{
 2c7:	55                   	push   %ebp
 2c8:	89 e5                	mov    %esp,%ebp
 2ca:	83 ec 04             	sub    $0x4,%esp
 2cd:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d0:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2d3:	eb 14                	jmp    2e9 <strchr+0x22>
    if(*s == c)
 2d5:	8b 45 08             	mov    0x8(%ebp),%eax
 2d8:	0f b6 00             	movzbl (%eax),%eax
 2db:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2de:	75 05                	jne    2e5 <strchr+0x1e>
      return (char*)s;
 2e0:	8b 45 08             	mov    0x8(%ebp),%eax
 2e3:	eb 13                	jmp    2f8 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2e5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2e9:	8b 45 08             	mov    0x8(%ebp),%eax
 2ec:	0f b6 00             	movzbl (%eax),%eax
 2ef:	84 c0                	test   %al,%al
 2f1:	75 e2                	jne    2d5 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2f8:	c9                   	leave  
 2f9:	c3                   	ret    

000002fa <gets>:

char*
gets(char *buf, int max)
{
 2fa:	55                   	push   %ebp
 2fb:	89 e5                	mov    %esp,%ebp
 2fd:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 300:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 307:	eb 42                	jmp    34b <gets+0x51>
    cc = read(0, &c, 1);
 309:	83 ec 04             	sub    $0x4,%esp
 30c:	6a 01                	push   $0x1
 30e:	8d 45 ef             	lea    -0x11(%ebp),%eax
 311:	50                   	push   %eax
 312:	6a 00                	push   $0x0
 314:	e8 8c 01 00 00       	call   4a5 <read>
 319:	83 c4 10             	add    $0x10,%esp
 31c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 31f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 323:	7e 33                	jle    358 <gets+0x5e>
      break;
    buf[i++] = c;
 325:	8b 45 f4             	mov    -0xc(%ebp),%eax
 328:	8d 50 01             	lea    0x1(%eax),%edx
 32b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 32e:	89 c2                	mov    %eax,%edx
 330:	8b 45 08             	mov    0x8(%ebp),%eax
 333:	01 c2                	add    %eax,%edx
 335:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 339:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 33b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 33f:	3c 0a                	cmp    $0xa,%al
 341:	74 16                	je     359 <gets+0x5f>
 343:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 347:	3c 0d                	cmp    $0xd,%al
 349:	74 0e                	je     359 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 34b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 34e:	83 c0 01             	add    $0x1,%eax
 351:	3b 45 0c             	cmp    0xc(%ebp),%eax
 354:	7c b3                	jl     309 <gets+0xf>
 356:	eb 01                	jmp    359 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 358:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 359:	8b 55 f4             	mov    -0xc(%ebp),%edx
 35c:	8b 45 08             	mov    0x8(%ebp),%eax
 35f:	01 d0                	add    %edx,%eax
 361:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 364:	8b 45 08             	mov    0x8(%ebp),%eax
}
 367:	c9                   	leave  
 368:	c3                   	ret    

00000369 <stat>:

int
stat(char *n, struct stat *st)
{
 369:	55                   	push   %ebp
 36a:	89 e5                	mov    %esp,%ebp
 36c:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 36f:	83 ec 08             	sub    $0x8,%esp
 372:	6a 00                	push   $0x0
 374:	ff 75 08             	pushl  0x8(%ebp)
 377:	e8 51 01 00 00       	call   4cd <open>
 37c:	83 c4 10             	add    $0x10,%esp
 37f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 382:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 386:	79 07                	jns    38f <stat+0x26>
    return -1;
 388:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 38d:	eb 25                	jmp    3b4 <stat+0x4b>
  r = fstat(fd, st);
 38f:	83 ec 08             	sub    $0x8,%esp
 392:	ff 75 0c             	pushl  0xc(%ebp)
 395:	ff 75 f4             	pushl  -0xc(%ebp)
 398:	e8 48 01 00 00       	call   4e5 <fstat>
 39d:	83 c4 10             	add    $0x10,%esp
 3a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 3a3:	83 ec 0c             	sub    $0xc,%esp
 3a6:	ff 75 f4             	pushl  -0xc(%ebp)
 3a9:	e8 07 01 00 00       	call   4b5 <close>
 3ae:	83 c4 10             	add    $0x10,%esp
  return r;
 3b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 3b4:	c9                   	leave  
 3b5:	c3                   	ret    

000003b6 <atoi>:

int
atoi(const char *s)
{
 3b6:	55                   	push   %ebp
 3b7:	89 e5                	mov    %esp,%ebp
 3b9:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 3bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 3c3:	eb 04                	jmp    3c9 <atoi+0x13>
 3c5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3c9:	8b 45 08             	mov    0x8(%ebp),%eax
 3cc:	0f b6 00             	movzbl (%eax),%eax
 3cf:	3c 20                	cmp    $0x20,%al
 3d1:	74 f2                	je     3c5 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 3d3:	8b 45 08             	mov    0x8(%ebp),%eax
 3d6:	0f b6 00             	movzbl (%eax),%eax
 3d9:	3c 2d                	cmp    $0x2d,%al
 3db:	75 07                	jne    3e4 <atoi+0x2e>
 3dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3e2:	eb 05                	jmp    3e9 <atoi+0x33>
 3e4:	b8 01 00 00 00       	mov    $0x1,%eax
 3e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 3ec:	8b 45 08             	mov    0x8(%ebp),%eax
 3ef:	0f b6 00             	movzbl (%eax),%eax
 3f2:	3c 2b                	cmp    $0x2b,%al
 3f4:	74 0a                	je     400 <atoi+0x4a>
 3f6:	8b 45 08             	mov    0x8(%ebp),%eax
 3f9:	0f b6 00             	movzbl (%eax),%eax
 3fc:	3c 2d                	cmp    $0x2d,%al
 3fe:	75 2b                	jne    42b <atoi+0x75>
    s++;
 400:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 404:	eb 25                	jmp    42b <atoi+0x75>
    n = n*10 + *s++ - '0';
 406:	8b 55 fc             	mov    -0x4(%ebp),%edx
 409:	89 d0                	mov    %edx,%eax
 40b:	c1 e0 02             	shl    $0x2,%eax
 40e:	01 d0                	add    %edx,%eax
 410:	01 c0                	add    %eax,%eax
 412:	89 c1                	mov    %eax,%ecx
 414:	8b 45 08             	mov    0x8(%ebp),%eax
 417:	8d 50 01             	lea    0x1(%eax),%edx
 41a:	89 55 08             	mov    %edx,0x8(%ebp)
 41d:	0f b6 00             	movzbl (%eax),%eax
 420:	0f be c0             	movsbl %al,%eax
 423:	01 c8                	add    %ecx,%eax
 425:	83 e8 30             	sub    $0x30,%eax
 428:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 42b:	8b 45 08             	mov    0x8(%ebp),%eax
 42e:	0f b6 00             	movzbl (%eax),%eax
 431:	3c 2f                	cmp    $0x2f,%al
 433:	7e 0a                	jle    43f <atoi+0x89>
 435:	8b 45 08             	mov    0x8(%ebp),%eax
 438:	0f b6 00             	movzbl (%eax),%eax
 43b:	3c 39                	cmp    $0x39,%al
 43d:	7e c7                	jle    406 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 43f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 442:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 446:	c9                   	leave  
 447:	c3                   	ret    

00000448 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 448:	55                   	push   %ebp
 449:	89 e5                	mov    %esp,%ebp
 44b:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 44e:	8b 45 08             	mov    0x8(%ebp),%eax
 451:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 454:	8b 45 0c             	mov    0xc(%ebp),%eax
 457:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 45a:	eb 17                	jmp    473 <memmove+0x2b>
    *dst++ = *src++;
 45c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 45f:	8d 50 01             	lea    0x1(%eax),%edx
 462:	89 55 fc             	mov    %edx,-0x4(%ebp)
 465:	8b 55 f8             	mov    -0x8(%ebp),%edx
 468:	8d 4a 01             	lea    0x1(%edx),%ecx
 46b:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 46e:	0f b6 12             	movzbl (%edx),%edx
 471:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 473:	8b 45 10             	mov    0x10(%ebp),%eax
 476:	8d 50 ff             	lea    -0x1(%eax),%edx
 479:	89 55 10             	mov    %edx,0x10(%ebp)
 47c:	85 c0                	test   %eax,%eax
 47e:	7f dc                	jg     45c <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 480:	8b 45 08             	mov    0x8(%ebp),%eax
}
 483:	c9                   	leave  
 484:	c3                   	ret    

00000485 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 485:	b8 01 00 00 00       	mov    $0x1,%eax
 48a:	cd 40                	int    $0x40
 48c:	c3                   	ret    

0000048d <exit>:
SYSCALL(exit)
 48d:	b8 02 00 00 00       	mov    $0x2,%eax
 492:	cd 40                	int    $0x40
 494:	c3                   	ret    

00000495 <wait>:
SYSCALL(wait)
 495:	b8 03 00 00 00       	mov    $0x3,%eax
 49a:	cd 40                	int    $0x40
 49c:	c3                   	ret    

0000049d <pipe>:
SYSCALL(pipe)
 49d:	b8 04 00 00 00       	mov    $0x4,%eax
 4a2:	cd 40                	int    $0x40
 4a4:	c3                   	ret    

000004a5 <read>:
SYSCALL(read)
 4a5:	b8 05 00 00 00       	mov    $0x5,%eax
 4aa:	cd 40                	int    $0x40
 4ac:	c3                   	ret    

000004ad <write>:
SYSCALL(write)
 4ad:	b8 10 00 00 00       	mov    $0x10,%eax
 4b2:	cd 40                	int    $0x40
 4b4:	c3                   	ret    

000004b5 <close>:
SYSCALL(close)
 4b5:	b8 15 00 00 00       	mov    $0x15,%eax
 4ba:	cd 40                	int    $0x40
 4bc:	c3                   	ret    

000004bd <kill>:
SYSCALL(kill)
 4bd:	b8 06 00 00 00       	mov    $0x6,%eax
 4c2:	cd 40                	int    $0x40
 4c4:	c3                   	ret    

000004c5 <exec>:
SYSCALL(exec)
 4c5:	b8 07 00 00 00       	mov    $0x7,%eax
 4ca:	cd 40                	int    $0x40
 4cc:	c3                   	ret    

000004cd <open>:
SYSCALL(open)
 4cd:	b8 0f 00 00 00       	mov    $0xf,%eax
 4d2:	cd 40                	int    $0x40
 4d4:	c3                   	ret    

000004d5 <mknod>:
SYSCALL(mknod)
 4d5:	b8 11 00 00 00       	mov    $0x11,%eax
 4da:	cd 40                	int    $0x40
 4dc:	c3                   	ret    

000004dd <unlink>:
SYSCALL(unlink)
 4dd:	b8 12 00 00 00       	mov    $0x12,%eax
 4e2:	cd 40                	int    $0x40
 4e4:	c3                   	ret    

000004e5 <fstat>:
SYSCALL(fstat)
 4e5:	b8 08 00 00 00       	mov    $0x8,%eax
 4ea:	cd 40                	int    $0x40
 4ec:	c3                   	ret    

000004ed <link>:
SYSCALL(link)
 4ed:	b8 13 00 00 00       	mov    $0x13,%eax
 4f2:	cd 40                	int    $0x40
 4f4:	c3                   	ret    

000004f5 <mkdir>:
SYSCALL(mkdir)
 4f5:	b8 14 00 00 00       	mov    $0x14,%eax
 4fa:	cd 40                	int    $0x40
 4fc:	c3                   	ret    

000004fd <chdir>:
SYSCALL(chdir)
 4fd:	b8 09 00 00 00       	mov    $0x9,%eax
 502:	cd 40                	int    $0x40
 504:	c3                   	ret    

00000505 <dup>:
SYSCALL(dup)
 505:	b8 0a 00 00 00       	mov    $0xa,%eax
 50a:	cd 40                	int    $0x40
 50c:	c3                   	ret    

0000050d <getpid>:
SYSCALL(getpid)
 50d:	b8 0b 00 00 00       	mov    $0xb,%eax
 512:	cd 40                	int    $0x40
 514:	c3                   	ret    

00000515 <sbrk>:
SYSCALL(sbrk)
 515:	b8 0c 00 00 00       	mov    $0xc,%eax
 51a:	cd 40                	int    $0x40
 51c:	c3                   	ret    

0000051d <sleep>:
SYSCALL(sleep)
 51d:	b8 0d 00 00 00       	mov    $0xd,%eax
 522:	cd 40                	int    $0x40
 524:	c3                   	ret    

00000525 <uptime>:
SYSCALL(uptime)
 525:	b8 0e 00 00 00       	mov    $0xe,%eax
 52a:	cd 40                	int    $0x40
 52c:	c3                   	ret    

0000052d <halt>:
SYSCALL(halt)
 52d:	b8 16 00 00 00       	mov    $0x16,%eax
 532:	cd 40                	int    $0x40
 534:	c3                   	ret    

00000535 <date>:
SYSCALL(date)
 535:	b8 17 00 00 00       	mov    $0x17,%eax
 53a:	cd 40                	int    $0x40
 53c:	c3                   	ret    

0000053d <getuid>:
SYSCALL(getuid)
 53d:	b8 18 00 00 00       	mov    $0x18,%eax
 542:	cd 40                	int    $0x40
 544:	c3                   	ret    

00000545 <getgid>:
SYSCALL(getgid)
 545:	b8 19 00 00 00       	mov    $0x19,%eax
 54a:	cd 40                	int    $0x40
 54c:	c3                   	ret    

0000054d <getppid>:
SYSCALL(getppid)
 54d:	b8 1a 00 00 00       	mov    $0x1a,%eax
 552:	cd 40                	int    $0x40
 554:	c3                   	ret    

00000555 <setuid>:
SYSCALL(setuid)
 555:	b8 1b 00 00 00       	mov    $0x1b,%eax
 55a:	cd 40                	int    $0x40
 55c:	c3                   	ret    

0000055d <setgid>:
SYSCALL(setgid)
 55d:	b8 1c 00 00 00       	mov    $0x1c,%eax
 562:	cd 40                	int    $0x40
 564:	c3                   	ret    

00000565 <getprocs>:
SYSCALL(getprocs)
 565:	b8 1d 00 00 00       	mov    $0x1d,%eax
 56a:	cd 40                	int    $0x40
 56c:	c3                   	ret    

0000056d <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 56d:	55                   	push   %ebp
 56e:	89 e5                	mov    %esp,%ebp
 570:	83 ec 18             	sub    $0x18,%esp
 573:	8b 45 0c             	mov    0xc(%ebp),%eax
 576:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 579:	83 ec 04             	sub    $0x4,%esp
 57c:	6a 01                	push   $0x1
 57e:	8d 45 f4             	lea    -0xc(%ebp),%eax
 581:	50                   	push   %eax
 582:	ff 75 08             	pushl  0x8(%ebp)
 585:	e8 23 ff ff ff       	call   4ad <write>
 58a:	83 c4 10             	add    $0x10,%esp
}
 58d:	90                   	nop
 58e:	c9                   	leave  
 58f:	c3                   	ret    

00000590 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 590:	55                   	push   %ebp
 591:	89 e5                	mov    %esp,%ebp
 593:	53                   	push   %ebx
 594:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 597:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 59e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 5a2:	74 17                	je     5bb <printint+0x2b>
 5a4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5a8:	79 11                	jns    5bb <printint+0x2b>
    neg = 1;
 5aa:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 5b1:	8b 45 0c             	mov    0xc(%ebp),%eax
 5b4:	f7 d8                	neg    %eax
 5b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5b9:	eb 06                	jmp    5c1 <printint+0x31>
  } else {
    x = xx;
 5bb:	8b 45 0c             	mov    0xc(%ebp),%eax
 5be:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 5c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 5c8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 5cb:	8d 41 01             	lea    0x1(%ecx),%eax
 5ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
 5d1:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5d7:	ba 00 00 00 00       	mov    $0x0,%edx
 5dc:	f7 f3                	div    %ebx
 5de:	89 d0                	mov    %edx,%eax
 5e0:	0f b6 80 04 0d 00 00 	movzbl 0xd04(%eax),%eax
 5e7:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 5eb:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5f1:	ba 00 00 00 00       	mov    $0x0,%edx
 5f6:	f7 f3                	div    %ebx
 5f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5fb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5ff:	75 c7                	jne    5c8 <printint+0x38>
  if(neg)
 601:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 605:	74 2d                	je     634 <printint+0xa4>
    buf[i++] = '-';
 607:	8b 45 f4             	mov    -0xc(%ebp),%eax
 60a:	8d 50 01             	lea    0x1(%eax),%edx
 60d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 610:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 615:	eb 1d                	jmp    634 <printint+0xa4>
    putc(fd, buf[i]);
 617:	8d 55 dc             	lea    -0x24(%ebp),%edx
 61a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 61d:	01 d0                	add    %edx,%eax
 61f:	0f b6 00             	movzbl (%eax),%eax
 622:	0f be c0             	movsbl %al,%eax
 625:	83 ec 08             	sub    $0x8,%esp
 628:	50                   	push   %eax
 629:	ff 75 08             	pushl  0x8(%ebp)
 62c:	e8 3c ff ff ff       	call   56d <putc>
 631:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 634:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 638:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 63c:	79 d9                	jns    617 <printint+0x87>
    putc(fd, buf[i]);
}
 63e:	90                   	nop
 63f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 642:	c9                   	leave  
 643:	c3                   	ret    

00000644 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 644:	55                   	push   %ebp
 645:	89 e5                	mov    %esp,%ebp
 647:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 64a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 651:	8d 45 0c             	lea    0xc(%ebp),%eax
 654:	83 c0 04             	add    $0x4,%eax
 657:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 65a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 661:	e9 59 01 00 00       	jmp    7bf <printf+0x17b>
    c = fmt[i] & 0xff;
 666:	8b 55 0c             	mov    0xc(%ebp),%edx
 669:	8b 45 f0             	mov    -0x10(%ebp),%eax
 66c:	01 d0                	add    %edx,%eax
 66e:	0f b6 00             	movzbl (%eax),%eax
 671:	0f be c0             	movsbl %al,%eax
 674:	25 ff 00 00 00       	and    $0xff,%eax
 679:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 67c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 680:	75 2c                	jne    6ae <printf+0x6a>
      if(c == '%'){
 682:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 686:	75 0c                	jne    694 <printf+0x50>
        state = '%';
 688:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 68f:	e9 27 01 00 00       	jmp    7bb <printf+0x177>
      } else {
        putc(fd, c);
 694:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 697:	0f be c0             	movsbl %al,%eax
 69a:	83 ec 08             	sub    $0x8,%esp
 69d:	50                   	push   %eax
 69e:	ff 75 08             	pushl  0x8(%ebp)
 6a1:	e8 c7 fe ff ff       	call   56d <putc>
 6a6:	83 c4 10             	add    $0x10,%esp
 6a9:	e9 0d 01 00 00       	jmp    7bb <printf+0x177>
      }
    } else if(state == '%'){
 6ae:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 6b2:	0f 85 03 01 00 00    	jne    7bb <printf+0x177>
      if(c == 'd'){
 6b8:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 6bc:	75 1e                	jne    6dc <printf+0x98>
        printint(fd, *ap, 10, 1);
 6be:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6c1:	8b 00                	mov    (%eax),%eax
 6c3:	6a 01                	push   $0x1
 6c5:	6a 0a                	push   $0xa
 6c7:	50                   	push   %eax
 6c8:	ff 75 08             	pushl  0x8(%ebp)
 6cb:	e8 c0 fe ff ff       	call   590 <printint>
 6d0:	83 c4 10             	add    $0x10,%esp
        ap++;
 6d3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6d7:	e9 d8 00 00 00       	jmp    7b4 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 6dc:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6e0:	74 06                	je     6e8 <printf+0xa4>
 6e2:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6e6:	75 1e                	jne    706 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 6e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6eb:	8b 00                	mov    (%eax),%eax
 6ed:	6a 00                	push   $0x0
 6ef:	6a 10                	push   $0x10
 6f1:	50                   	push   %eax
 6f2:	ff 75 08             	pushl  0x8(%ebp)
 6f5:	e8 96 fe ff ff       	call   590 <printint>
 6fa:	83 c4 10             	add    $0x10,%esp
        ap++;
 6fd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 701:	e9 ae 00 00 00       	jmp    7b4 <printf+0x170>
      } else if(c == 's'){
 706:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 70a:	75 43                	jne    74f <printf+0x10b>
        s = (char*)*ap;
 70c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 70f:	8b 00                	mov    (%eax),%eax
 711:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 714:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 718:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 71c:	75 25                	jne    743 <printf+0xff>
          s = "(null)";
 71e:	c7 45 f4 89 0a 00 00 	movl   $0xa89,-0xc(%ebp)
        while(*s != 0){
 725:	eb 1c                	jmp    743 <printf+0xff>
          putc(fd, *s);
 727:	8b 45 f4             	mov    -0xc(%ebp),%eax
 72a:	0f b6 00             	movzbl (%eax),%eax
 72d:	0f be c0             	movsbl %al,%eax
 730:	83 ec 08             	sub    $0x8,%esp
 733:	50                   	push   %eax
 734:	ff 75 08             	pushl  0x8(%ebp)
 737:	e8 31 fe ff ff       	call   56d <putc>
 73c:	83 c4 10             	add    $0x10,%esp
          s++;
 73f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 743:	8b 45 f4             	mov    -0xc(%ebp),%eax
 746:	0f b6 00             	movzbl (%eax),%eax
 749:	84 c0                	test   %al,%al
 74b:	75 da                	jne    727 <printf+0xe3>
 74d:	eb 65                	jmp    7b4 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 74f:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 753:	75 1d                	jne    772 <printf+0x12e>
        putc(fd, *ap);
 755:	8b 45 e8             	mov    -0x18(%ebp),%eax
 758:	8b 00                	mov    (%eax),%eax
 75a:	0f be c0             	movsbl %al,%eax
 75d:	83 ec 08             	sub    $0x8,%esp
 760:	50                   	push   %eax
 761:	ff 75 08             	pushl  0x8(%ebp)
 764:	e8 04 fe ff ff       	call   56d <putc>
 769:	83 c4 10             	add    $0x10,%esp
        ap++;
 76c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 770:	eb 42                	jmp    7b4 <printf+0x170>
      } else if(c == '%'){
 772:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 776:	75 17                	jne    78f <printf+0x14b>
        putc(fd, c);
 778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 77b:	0f be c0             	movsbl %al,%eax
 77e:	83 ec 08             	sub    $0x8,%esp
 781:	50                   	push   %eax
 782:	ff 75 08             	pushl  0x8(%ebp)
 785:	e8 e3 fd ff ff       	call   56d <putc>
 78a:	83 c4 10             	add    $0x10,%esp
 78d:	eb 25                	jmp    7b4 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 78f:	83 ec 08             	sub    $0x8,%esp
 792:	6a 25                	push   $0x25
 794:	ff 75 08             	pushl  0x8(%ebp)
 797:	e8 d1 fd ff ff       	call   56d <putc>
 79c:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 79f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7a2:	0f be c0             	movsbl %al,%eax
 7a5:	83 ec 08             	sub    $0x8,%esp
 7a8:	50                   	push   %eax
 7a9:	ff 75 08             	pushl  0x8(%ebp)
 7ac:	e8 bc fd ff ff       	call   56d <putc>
 7b1:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 7b4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7bb:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 7bf:	8b 55 0c             	mov    0xc(%ebp),%edx
 7c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c5:	01 d0                	add    %edx,%eax
 7c7:	0f b6 00             	movzbl (%eax),%eax
 7ca:	84 c0                	test   %al,%al
 7cc:	0f 85 94 fe ff ff    	jne    666 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7d2:	90                   	nop
 7d3:	c9                   	leave  
 7d4:	c3                   	ret    

000007d5 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7d5:	55                   	push   %ebp
 7d6:	89 e5                	mov    %esp,%ebp
 7d8:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7db:	8b 45 08             	mov    0x8(%ebp),%eax
 7de:	83 e8 08             	sub    $0x8,%eax
 7e1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e4:	a1 20 0d 00 00       	mov    0xd20,%eax
 7e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7ec:	eb 24                	jmp    812 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f1:	8b 00                	mov    (%eax),%eax
 7f3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7f6:	77 12                	ja     80a <free+0x35>
 7f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7fb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7fe:	77 24                	ja     824 <free+0x4f>
 800:	8b 45 fc             	mov    -0x4(%ebp),%eax
 803:	8b 00                	mov    (%eax),%eax
 805:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 808:	77 1a                	ja     824 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 80a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80d:	8b 00                	mov    (%eax),%eax
 80f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 812:	8b 45 f8             	mov    -0x8(%ebp),%eax
 815:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 818:	76 d4                	jbe    7ee <free+0x19>
 81a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81d:	8b 00                	mov    (%eax),%eax
 81f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 822:	76 ca                	jbe    7ee <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 824:	8b 45 f8             	mov    -0x8(%ebp),%eax
 827:	8b 40 04             	mov    0x4(%eax),%eax
 82a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 831:	8b 45 f8             	mov    -0x8(%ebp),%eax
 834:	01 c2                	add    %eax,%edx
 836:	8b 45 fc             	mov    -0x4(%ebp),%eax
 839:	8b 00                	mov    (%eax),%eax
 83b:	39 c2                	cmp    %eax,%edx
 83d:	75 24                	jne    863 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 83f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 842:	8b 50 04             	mov    0x4(%eax),%edx
 845:	8b 45 fc             	mov    -0x4(%ebp),%eax
 848:	8b 00                	mov    (%eax),%eax
 84a:	8b 40 04             	mov    0x4(%eax),%eax
 84d:	01 c2                	add    %eax,%edx
 84f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 852:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 855:	8b 45 fc             	mov    -0x4(%ebp),%eax
 858:	8b 00                	mov    (%eax),%eax
 85a:	8b 10                	mov    (%eax),%edx
 85c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 85f:	89 10                	mov    %edx,(%eax)
 861:	eb 0a                	jmp    86d <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 863:	8b 45 fc             	mov    -0x4(%ebp),%eax
 866:	8b 10                	mov    (%eax),%edx
 868:	8b 45 f8             	mov    -0x8(%ebp),%eax
 86b:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 86d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 870:	8b 40 04             	mov    0x4(%eax),%eax
 873:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 87a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 87d:	01 d0                	add    %edx,%eax
 87f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 882:	75 20                	jne    8a4 <free+0xcf>
    p->s.size += bp->s.size;
 884:	8b 45 fc             	mov    -0x4(%ebp),%eax
 887:	8b 50 04             	mov    0x4(%eax),%edx
 88a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 88d:	8b 40 04             	mov    0x4(%eax),%eax
 890:	01 c2                	add    %eax,%edx
 892:	8b 45 fc             	mov    -0x4(%ebp),%eax
 895:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 898:	8b 45 f8             	mov    -0x8(%ebp),%eax
 89b:	8b 10                	mov    (%eax),%edx
 89d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a0:	89 10                	mov    %edx,(%eax)
 8a2:	eb 08                	jmp    8ac <free+0xd7>
  } else
    p->s.ptr = bp;
 8a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a7:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8aa:	89 10                	mov    %edx,(%eax)
  freep = p;
 8ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8af:	a3 20 0d 00 00       	mov    %eax,0xd20
}
 8b4:	90                   	nop
 8b5:	c9                   	leave  
 8b6:	c3                   	ret    

000008b7 <morecore>:

static Header*
morecore(uint nu)
{
 8b7:	55                   	push   %ebp
 8b8:	89 e5                	mov    %esp,%ebp
 8ba:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 8bd:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 8c4:	77 07                	ja     8cd <morecore+0x16>
    nu = 4096;
 8c6:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8cd:	8b 45 08             	mov    0x8(%ebp),%eax
 8d0:	c1 e0 03             	shl    $0x3,%eax
 8d3:	83 ec 0c             	sub    $0xc,%esp
 8d6:	50                   	push   %eax
 8d7:	e8 39 fc ff ff       	call   515 <sbrk>
 8dc:	83 c4 10             	add    $0x10,%esp
 8df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8e2:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8e6:	75 07                	jne    8ef <morecore+0x38>
    return 0;
 8e8:	b8 00 00 00 00       	mov    $0x0,%eax
 8ed:	eb 26                	jmp    915 <morecore+0x5e>
  hp = (Header*)p;
 8ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f8:	8b 55 08             	mov    0x8(%ebp),%edx
 8fb:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
 901:	83 c0 08             	add    $0x8,%eax
 904:	83 ec 0c             	sub    $0xc,%esp
 907:	50                   	push   %eax
 908:	e8 c8 fe ff ff       	call   7d5 <free>
 90d:	83 c4 10             	add    $0x10,%esp
  return freep;
 910:	a1 20 0d 00 00       	mov    0xd20,%eax
}
 915:	c9                   	leave  
 916:	c3                   	ret    

00000917 <malloc>:

void*
malloc(uint nbytes)
{
 917:	55                   	push   %ebp
 918:	89 e5                	mov    %esp,%ebp
 91a:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 91d:	8b 45 08             	mov    0x8(%ebp),%eax
 920:	83 c0 07             	add    $0x7,%eax
 923:	c1 e8 03             	shr    $0x3,%eax
 926:	83 c0 01             	add    $0x1,%eax
 929:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 92c:	a1 20 0d 00 00       	mov    0xd20,%eax
 931:	89 45 f0             	mov    %eax,-0x10(%ebp)
 934:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 938:	75 23                	jne    95d <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 93a:	c7 45 f0 18 0d 00 00 	movl   $0xd18,-0x10(%ebp)
 941:	8b 45 f0             	mov    -0x10(%ebp),%eax
 944:	a3 20 0d 00 00       	mov    %eax,0xd20
 949:	a1 20 0d 00 00       	mov    0xd20,%eax
 94e:	a3 18 0d 00 00       	mov    %eax,0xd18
    base.s.size = 0;
 953:	c7 05 1c 0d 00 00 00 	movl   $0x0,0xd1c
 95a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 95d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 960:	8b 00                	mov    (%eax),%eax
 962:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 965:	8b 45 f4             	mov    -0xc(%ebp),%eax
 968:	8b 40 04             	mov    0x4(%eax),%eax
 96b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 96e:	72 4d                	jb     9bd <malloc+0xa6>
      if(p->s.size == nunits)
 970:	8b 45 f4             	mov    -0xc(%ebp),%eax
 973:	8b 40 04             	mov    0x4(%eax),%eax
 976:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 979:	75 0c                	jne    987 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 97b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97e:	8b 10                	mov    (%eax),%edx
 980:	8b 45 f0             	mov    -0x10(%ebp),%eax
 983:	89 10                	mov    %edx,(%eax)
 985:	eb 26                	jmp    9ad <malloc+0x96>
      else {
        p->s.size -= nunits;
 987:	8b 45 f4             	mov    -0xc(%ebp),%eax
 98a:	8b 40 04             	mov    0x4(%eax),%eax
 98d:	2b 45 ec             	sub    -0x14(%ebp),%eax
 990:	89 c2                	mov    %eax,%edx
 992:	8b 45 f4             	mov    -0xc(%ebp),%eax
 995:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 998:	8b 45 f4             	mov    -0xc(%ebp),%eax
 99b:	8b 40 04             	mov    0x4(%eax),%eax
 99e:	c1 e0 03             	shl    $0x3,%eax
 9a1:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 9a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a7:	8b 55 ec             	mov    -0x14(%ebp),%edx
 9aa:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 9ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9b0:	a3 20 0d 00 00       	mov    %eax,0xd20
      return (void*)(p + 1);
 9b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b8:	83 c0 08             	add    $0x8,%eax
 9bb:	eb 3b                	jmp    9f8 <malloc+0xe1>
    }
    if(p == freep)
 9bd:	a1 20 0d 00 00       	mov    0xd20,%eax
 9c2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 9c5:	75 1e                	jne    9e5 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 9c7:	83 ec 0c             	sub    $0xc,%esp
 9ca:	ff 75 ec             	pushl  -0x14(%ebp)
 9cd:	e8 e5 fe ff ff       	call   8b7 <morecore>
 9d2:	83 c4 10             	add    $0x10,%esp
 9d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9dc:	75 07                	jne    9e5 <malloc+0xce>
        return 0;
 9de:	b8 00 00 00 00       	mov    $0x0,%eax
 9e3:	eb 13                	jmp    9f8 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ee:	8b 00                	mov    (%eax),%eax
 9f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 9f3:	e9 6d ff ff ff       	jmp    965 <malloc+0x4e>
}
 9f8:	c9                   	leave  
 9f9:	c3                   	ret    
