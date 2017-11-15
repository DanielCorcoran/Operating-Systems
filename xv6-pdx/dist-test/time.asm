
_time:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#ifdef CS333_P2
#include "types.h"
#include "user.h"
int
main(int argc, char* argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	83 ec 20             	sub    $0x20,%esp
  12:	89 cb                	mov    %ecx,%ebx
  int start_ticks;
  int total_ticks;
  int pid = fork();
  14:	e8 dd 03 00 00       	call   3f6 <fork>
  19:	89 45 f4             	mov    %eax,-0xc(%ebp)

  start_ticks = uptime();
  1c:	e8 75 04 00 00       	call   496 <uptime>
  21:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(pid == 0){
  24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  28:	75 47                	jne    71 <main+0x71>
    exec(argv[1],argv+1);
  2a:	8b 43 04             	mov    0x4(%ebx),%eax
  2d:	8d 50 04             	lea    0x4(%eax),%edx
  30:	8b 43 04             	mov    0x4(%ebx),%eax
  33:	83 c0 04             	add    $0x4,%eax
  36:	8b 00                	mov    (%eax),%eax
  38:	83 ec 08             	sub    $0x8,%esp
  3b:	52                   	push   %edx
  3c:	50                   	push   %eax
  3d:	e8 f4 03 00 00       	call   436 <exec>
  42:	83 c4 10             	add    $0x10,%esp
    if(argv[1])
  45:	8b 43 04             	mov    0x4(%ebx),%eax
  48:	83 c0 04             	add    $0x4,%eax
  4b:	8b 00                	mov    (%eax),%eax
  4d:	85 c0                	test   %eax,%eax
  4f:	74 1b                	je     6c <main+0x6c>
      printf(2, "exec of %s failed\n", argv[1]);
  51:	8b 43 04             	mov    0x4(%ebx),%eax
  54:	83 c0 04             	add    $0x4,%eax
  57:	8b 00                	mov    (%eax),%eax
  59:	83 ec 04             	sub    $0x4,%esp
  5c:	50                   	push   %eax
  5d:	68 73 09 00 00       	push   $0x973
  62:	6a 02                	push   $0x2
  64:	e8 54 05 00 00       	call   5bd <printf>
  69:	83 c4 10             	add    $0x10,%esp
    exit();
  6c:	e8 8d 03 00 00       	call   3fe <exit>
  }
  wait();
  71:	e8 90 03 00 00       	call   406 <wait>
  total_ticks = uptime()-start_ticks;
  76:	e8 1b 04 00 00       	call   496 <uptime>
  7b:	2b 45 f0             	sub    -0x10(%ebp),%eax
  7e:	89 45 ec             	mov    %eax,-0x14(%ebp)

  if(!argv[1])
  81:	8b 43 04             	mov    0x4(%ebx),%eax
  84:	83 c0 04             	add    $0x4,%eax
  87:	8b 00                	mov    (%eax),%eax
  89:	85 c0                	test   %eax,%eax
  8b:	75 14                	jne    a1 <main+0xa1>
    printf(1, "ran in ");
  8d:	83 ec 08             	sub    $0x8,%esp
  90:	68 86 09 00 00       	push   $0x986
  95:	6a 01                	push   $0x1
  97:	e8 21 05 00 00       	call   5bd <printf>
  9c:	83 c4 10             	add    $0x10,%esp
  9f:	eb 1b                	jmp    bc <main+0xbc>
  else
    printf(1, "%s ran in ", argv[1]);
  a1:	8b 43 04             	mov    0x4(%ebx),%eax
  a4:	83 c0 04             	add    $0x4,%eax
  a7:	8b 00                	mov    (%eax),%eax
  a9:	83 ec 04             	sub    $0x4,%esp
  ac:	50                   	push   %eax
  ad:	68 8e 09 00 00       	push   $0x98e
  b2:	6a 01                	push   $0x1
  b4:	e8 04 05 00 00       	call   5bd <printf>
  b9:	83 c4 10             	add    $0x10,%esp

  int seconds = (total_ticks)/1000;
  bc:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  bf:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
  c4:	89 c8                	mov    %ecx,%eax
  c6:	f7 ea                	imul   %edx
  c8:	c1 fa 06             	sar    $0x6,%edx
  cb:	89 c8                	mov    %ecx,%eax
  cd:	c1 f8 1f             	sar    $0x1f,%eax
  d0:	29 c2                	sub    %eax,%edx
  d2:	89 d0                	mov    %edx,%eax
  d4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  int milliseconds = (total_ticks)%1000;
  d7:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  da:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
  df:	89 c8                	mov    %ecx,%eax
  e1:	f7 ea                	imul   %edx
  e3:	c1 fa 06             	sar    $0x6,%edx
  e6:	89 c8                	mov    %ecx,%eax
  e8:	c1 f8 1f             	sar    $0x1f,%eax
  eb:	29 c2                	sub    %eax,%edx
  ed:	89 d0                	mov    %edx,%eax
  ef:	69 c0 e8 03 00 00    	imul   $0x3e8,%eax,%eax
  f5:	29 c1                	sub    %eax,%ecx
  f7:	89 c8                	mov    %ecx,%eax
  f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)

  if(milliseconds < 10)
  fc:	83 7d e4 09          	cmpl   $0x9,-0x1c(%ebp)
 100:	7f 17                	jg     119 <main+0x119>
    printf(1, "%d.00%d", seconds, milliseconds);
 102:	ff 75 e4             	pushl  -0x1c(%ebp)
 105:	ff 75 e8             	pushl  -0x18(%ebp)
 108:	68 99 09 00 00       	push   $0x999
 10d:	6a 01                	push   $0x1
 10f:	e8 a9 04 00 00       	call   5bd <printf>
 114:	83 c4 10             	add    $0x10,%esp
 117:	eb 32                	jmp    14b <main+0x14b>
  else if(milliseconds < 100)
 119:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 11d:	7f 17                	jg     136 <main+0x136>
    printf(1, "%d.0%d", seconds, milliseconds);
 11f:	ff 75 e4             	pushl  -0x1c(%ebp)
 122:	ff 75 e8             	pushl  -0x18(%ebp)
 125:	68 a1 09 00 00       	push   $0x9a1
 12a:	6a 01                	push   $0x1
 12c:	e8 8c 04 00 00       	call   5bd <printf>
 131:	83 c4 10             	add    $0x10,%esp
 134:	eb 15                	jmp    14b <main+0x14b>
  else
    printf(1, "%d.%d", seconds, milliseconds);
 136:	ff 75 e4             	pushl  -0x1c(%ebp)
 139:	ff 75 e8             	pushl  -0x18(%ebp)
 13c:	68 a8 09 00 00       	push   $0x9a8
 141:	6a 01                	push   $0x1
 143:	e8 75 04 00 00       	call   5bd <printf>
 148:	83 c4 10             	add    $0x10,%esp

  printf(1, " seconds.\n");
 14b:	83 ec 08             	sub    $0x8,%esp
 14e:	68 ae 09 00 00       	push   $0x9ae
 153:	6a 01                	push   $0x1
 155:	e8 63 04 00 00       	call   5bd <printf>
 15a:	83 c4 10             	add    $0x10,%esp

  exit();
 15d:	e8 9c 02 00 00       	call   3fe <exit>

00000162 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 162:	55                   	push   %ebp
 163:	89 e5                	mov    %esp,%ebp
 165:	57                   	push   %edi
 166:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 167:	8b 4d 08             	mov    0x8(%ebp),%ecx
 16a:	8b 55 10             	mov    0x10(%ebp),%edx
 16d:	8b 45 0c             	mov    0xc(%ebp),%eax
 170:	89 cb                	mov    %ecx,%ebx
 172:	89 df                	mov    %ebx,%edi
 174:	89 d1                	mov    %edx,%ecx
 176:	fc                   	cld    
 177:	f3 aa                	rep stos %al,%es:(%edi)
 179:	89 ca                	mov    %ecx,%edx
 17b:	89 fb                	mov    %edi,%ebx
 17d:	89 5d 08             	mov    %ebx,0x8(%ebp)
 180:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 183:	90                   	nop
 184:	5b                   	pop    %ebx
 185:	5f                   	pop    %edi
 186:	5d                   	pop    %ebp
 187:	c3                   	ret    

00000188 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 188:	55                   	push   %ebp
 189:	89 e5                	mov    %esp,%ebp
 18b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 18e:	8b 45 08             	mov    0x8(%ebp),%eax
 191:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 194:	90                   	nop
 195:	8b 45 08             	mov    0x8(%ebp),%eax
 198:	8d 50 01             	lea    0x1(%eax),%edx
 19b:	89 55 08             	mov    %edx,0x8(%ebp)
 19e:	8b 55 0c             	mov    0xc(%ebp),%edx
 1a1:	8d 4a 01             	lea    0x1(%edx),%ecx
 1a4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 1a7:	0f b6 12             	movzbl (%edx),%edx
 1aa:	88 10                	mov    %dl,(%eax)
 1ac:	0f b6 00             	movzbl (%eax),%eax
 1af:	84 c0                	test   %al,%al
 1b1:	75 e2                	jne    195 <strcpy+0xd>
    ;
  return os;
 1b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1b6:	c9                   	leave  
 1b7:	c3                   	ret    

000001b8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1b8:	55                   	push   %ebp
 1b9:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1bb:	eb 08                	jmp    1c5 <strcmp+0xd>
    p++, q++;
 1bd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1c1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1c5:	8b 45 08             	mov    0x8(%ebp),%eax
 1c8:	0f b6 00             	movzbl (%eax),%eax
 1cb:	84 c0                	test   %al,%al
 1cd:	74 10                	je     1df <strcmp+0x27>
 1cf:	8b 45 08             	mov    0x8(%ebp),%eax
 1d2:	0f b6 10             	movzbl (%eax),%edx
 1d5:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d8:	0f b6 00             	movzbl (%eax),%eax
 1db:	38 c2                	cmp    %al,%dl
 1dd:	74 de                	je     1bd <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1df:	8b 45 08             	mov    0x8(%ebp),%eax
 1e2:	0f b6 00             	movzbl (%eax),%eax
 1e5:	0f b6 d0             	movzbl %al,%edx
 1e8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1eb:	0f b6 00             	movzbl (%eax),%eax
 1ee:	0f b6 c0             	movzbl %al,%eax
 1f1:	29 c2                	sub    %eax,%edx
 1f3:	89 d0                	mov    %edx,%eax
}
 1f5:	5d                   	pop    %ebp
 1f6:	c3                   	ret    

000001f7 <strlen>:

uint
strlen(char *s)
{
 1f7:	55                   	push   %ebp
 1f8:	89 e5                	mov    %esp,%ebp
 1fa:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 204:	eb 04                	jmp    20a <strlen+0x13>
 206:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 20a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 20d:	8b 45 08             	mov    0x8(%ebp),%eax
 210:	01 d0                	add    %edx,%eax
 212:	0f b6 00             	movzbl (%eax),%eax
 215:	84 c0                	test   %al,%al
 217:	75 ed                	jne    206 <strlen+0xf>
    ;
  return n;
 219:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 21c:	c9                   	leave  
 21d:	c3                   	ret    

0000021e <memset>:

void*
memset(void *dst, int c, uint n)
{
 21e:	55                   	push   %ebp
 21f:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 221:	8b 45 10             	mov    0x10(%ebp),%eax
 224:	50                   	push   %eax
 225:	ff 75 0c             	pushl  0xc(%ebp)
 228:	ff 75 08             	pushl  0x8(%ebp)
 22b:	e8 32 ff ff ff       	call   162 <stosb>
 230:	83 c4 0c             	add    $0xc,%esp
  return dst;
 233:	8b 45 08             	mov    0x8(%ebp),%eax
}
 236:	c9                   	leave  
 237:	c3                   	ret    

00000238 <strchr>:

char*
strchr(const char *s, char c)
{
 238:	55                   	push   %ebp
 239:	89 e5                	mov    %esp,%ebp
 23b:	83 ec 04             	sub    $0x4,%esp
 23e:	8b 45 0c             	mov    0xc(%ebp),%eax
 241:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 244:	eb 14                	jmp    25a <strchr+0x22>
    if(*s == c)
 246:	8b 45 08             	mov    0x8(%ebp),%eax
 249:	0f b6 00             	movzbl (%eax),%eax
 24c:	3a 45 fc             	cmp    -0x4(%ebp),%al
 24f:	75 05                	jne    256 <strchr+0x1e>
      return (char*)s;
 251:	8b 45 08             	mov    0x8(%ebp),%eax
 254:	eb 13                	jmp    269 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 256:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 25a:	8b 45 08             	mov    0x8(%ebp),%eax
 25d:	0f b6 00             	movzbl (%eax),%eax
 260:	84 c0                	test   %al,%al
 262:	75 e2                	jne    246 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 264:	b8 00 00 00 00       	mov    $0x0,%eax
}
 269:	c9                   	leave  
 26a:	c3                   	ret    

0000026b <gets>:

char*
gets(char *buf, int max)
{
 26b:	55                   	push   %ebp
 26c:	89 e5                	mov    %esp,%ebp
 26e:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 271:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 278:	eb 42                	jmp    2bc <gets+0x51>
    cc = read(0, &c, 1);
 27a:	83 ec 04             	sub    $0x4,%esp
 27d:	6a 01                	push   $0x1
 27f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 282:	50                   	push   %eax
 283:	6a 00                	push   $0x0
 285:	e8 8c 01 00 00       	call   416 <read>
 28a:	83 c4 10             	add    $0x10,%esp
 28d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 290:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 294:	7e 33                	jle    2c9 <gets+0x5e>
      break;
    buf[i++] = c;
 296:	8b 45 f4             	mov    -0xc(%ebp),%eax
 299:	8d 50 01             	lea    0x1(%eax),%edx
 29c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 29f:	89 c2                	mov    %eax,%edx
 2a1:	8b 45 08             	mov    0x8(%ebp),%eax
 2a4:	01 c2                	add    %eax,%edx
 2a6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2aa:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 2ac:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2b0:	3c 0a                	cmp    $0xa,%al
 2b2:	74 16                	je     2ca <gets+0x5f>
 2b4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2b8:	3c 0d                	cmp    $0xd,%al
 2ba:	74 0e                	je     2ca <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2bf:	83 c0 01             	add    $0x1,%eax
 2c2:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2c5:	7c b3                	jl     27a <gets+0xf>
 2c7:	eb 01                	jmp    2ca <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 2c9:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2cd:	8b 45 08             	mov    0x8(%ebp),%eax
 2d0:	01 d0                	add    %edx,%eax
 2d2:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2d5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2d8:	c9                   	leave  
 2d9:	c3                   	ret    

000002da <stat>:

int
stat(char *n, struct stat *st)
{
 2da:	55                   	push   %ebp
 2db:	89 e5                	mov    %esp,%ebp
 2dd:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2e0:	83 ec 08             	sub    $0x8,%esp
 2e3:	6a 00                	push   $0x0
 2e5:	ff 75 08             	pushl  0x8(%ebp)
 2e8:	e8 51 01 00 00       	call   43e <open>
 2ed:	83 c4 10             	add    $0x10,%esp
 2f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2f7:	79 07                	jns    300 <stat+0x26>
    return -1;
 2f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2fe:	eb 25                	jmp    325 <stat+0x4b>
  r = fstat(fd, st);
 300:	83 ec 08             	sub    $0x8,%esp
 303:	ff 75 0c             	pushl  0xc(%ebp)
 306:	ff 75 f4             	pushl  -0xc(%ebp)
 309:	e8 48 01 00 00       	call   456 <fstat>
 30e:	83 c4 10             	add    $0x10,%esp
 311:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 314:	83 ec 0c             	sub    $0xc,%esp
 317:	ff 75 f4             	pushl  -0xc(%ebp)
 31a:	e8 07 01 00 00       	call   426 <close>
 31f:	83 c4 10             	add    $0x10,%esp
  return r;
 322:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 325:	c9                   	leave  
 326:	c3                   	ret    

00000327 <atoi>:

int
atoi(const char *s)
{
 327:	55                   	push   %ebp
 328:	89 e5                	mov    %esp,%ebp
 32a:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 32d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 334:	eb 04                	jmp    33a <atoi+0x13>
 336:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 33a:	8b 45 08             	mov    0x8(%ebp),%eax
 33d:	0f b6 00             	movzbl (%eax),%eax
 340:	3c 20                	cmp    $0x20,%al
 342:	74 f2                	je     336 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 344:	8b 45 08             	mov    0x8(%ebp),%eax
 347:	0f b6 00             	movzbl (%eax),%eax
 34a:	3c 2d                	cmp    $0x2d,%al
 34c:	75 07                	jne    355 <atoi+0x2e>
 34e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 353:	eb 05                	jmp    35a <atoi+0x33>
 355:	b8 01 00 00 00       	mov    $0x1,%eax
 35a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 35d:	8b 45 08             	mov    0x8(%ebp),%eax
 360:	0f b6 00             	movzbl (%eax),%eax
 363:	3c 2b                	cmp    $0x2b,%al
 365:	74 0a                	je     371 <atoi+0x4a>
 367:	8b 45 08             	mov    0x8(%ebp),%eax
 36a:	0f b6 00             	movzbl (%eax),%eax
 36d:	3c 2d                	cmp    $0x2d,%al
 36f:	75 2b                	jne    39c <atoi+0x75>
    s++;
 371:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 375:	eb 25                	jmp    39c <atoi+0x75>
    n = n*10 + *s++ - '0';
 377:	8b 55 fc             	mov    -0x4(%ebp),%edx
 37a:	89 d0                	mov    %edx,%eax
 37c:	c1 e0 02             	shl    $0x2,%eax
 37f:	01 d0                	add    %edx,%eax
 381:	01 c0                	add    %eax,%eax
 383:	89 c1                	mov    %eax,%ecx
 385:	8b 45 08             	mov    0x8(%ebp),%eax
 388:	8d 50 01             	lea    0x1(%eax),%edx
 38b:	89 55 08             	mov    %edx,0x8(%ebp)
 38e:	0f b6 00             	movzbl (%eax),%eax
 391:	0f be c0             	movsbl %al,%eax
 394:	01 c8                	add    %ecx,%eax
 396:	83 e8 30             	sub    $0x30,%eax
 399:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 39c:	8b 45 08             	mov    0x8(%ebp),%eax
 39f:	0f b6 00             	movzbl (%eax),%eax
 3a2:	3c 2f                	cmp    $0x2f,%al
 3a4:	7e 0a                	jle    3b0 <atoi+0x89>
 3a6:	8b 45 08             	mov    0x8(%ebp),%eax
 3a9:	0f b6 00             	movzbl (%eax),%eax
 3ac:	3c 39                	cmp    $0x39,%al
 3ae:	7e c7                	jle    377 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 3b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3b3:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 3b7:	c9                   	leave  
 3b8:	c3                   	ret    

000003b9 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3b9:	55                   	push   %ebp
 3ba:	89 e5                	mov    %esp,%ebp
 3bc:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3bf:	8b 45 08             	mov    0x8(%ebp),%eax
 3c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3c5:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3cb:	eb 17                	jmp    3e4 <memmove+0x2b>
    *dst++ = *src++;
 3cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3d0:	8d 50 01             	lea    0x1(%eax),%edx
 3d3:	89 55 fc             	mov    %edx,-0x4(%ebp)
 3d6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3d9:	8d 4a 01             	lea    0x1(%edx),%ecx
 3dc:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 3df:	0f b6 12             	movzbl (%edx),%edx
 3e2:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3e4:	8b 45 10             	mov    0x10(%ebp),%eax
 3e7:	8d 50 ff             	lea    -0x1(%eax),%edx
 3ea:	89 55 10             	mov    %edx,0x10(%ebp)
 3ed:	85 c0                	test   %eax,%eax
 3ef:	7f dc                	jg     3cd <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3f1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3f4:	c9                   	leave  
 3f5:	c3                   	ret    

000003f6 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3f6:	b8 01 00 00 00       	mov    $0x1,%eax
 3fb:	cd 40                	int    $0x40
 3fd:	c3                   	ret    

000003fe <exit>:
SYSCALL(exit)
 3fe:	b8 02 00 00 00       	mov    $0x2,%eax
 403:	cd 40                	int    $0x40
 405:	c3                   	ret    

00000406 <wait>:
SYSCALL(wait)
 406:	b8 03 00 00 00       	mov    $0x3,%eax
 40b:	cd 40                	int    $0x40
 40d:	c3                   	ret    

0000040e <pipe>:
SYSCALL(pipe)
 40e:	b8 04 00 00 00       	mov    $0x4,%eax
 413:	cd 40                	int    $0x40
 415:	c3                   	ret    

00000416 <read>:
SYSCALL(read)
 416:	b8 05 00 00 00       	mov    $0x5,%eax
 41b:	cd 40                	int    $0x40
 41d:	c3                   	ret    

0000041e <write>:
SYSCALL(write)
 41e:	b8 10 00 00 00       	mov    $0x10,%eax
 423:	cd 40                	int    $0x40
 425:	c3                   	ret    

00000426 <close>:
SYSCALL(close)
 426:	b8 15 00 00 00       	mov    $0x15,%eax
 42b:	cd 40                	int    $0x40
 42d:	c3                   	ret    

0000042e <kill>:
SYSCALL(kill)
 42e:	b8 06 00 00 00       	mov    $0x6,%eax
 433:	cd 40                	int    $0x40
 435:	c3                   	ret    

00000436 <exec>:
SYSCALL(exec)
 436:	b8 07 00 00 00       	mov    $0x7,%eax
 43b:	cd 40                	int    $0x40
 43d:	c3                   	ret    

0000043e <open>:
SYSCALL(open)
 43e:	b8 0f 00 00 00       	mov    $0xf,%eax
 443:	cd 40                	int    $0x40
 445:	c3                   	ret    

00000446 <mknod>:
SYSCALL(mknod)
 446:	b8 11 00 00 00       	mov    $0x11,%eax
 44b:	cd 40                	int    $0x40
 44d:	c3                   	ret    

0000044e <unlink>:
SYSCALL(unlink)
 44e:	b8 12 00 00 00       	mov    $0x12,%eax
 453:	cd 40                	int    $0x40
 455:	c3                   	ret    

00000456 <fstat>:
SYSCALL(fstat)
 456:	b8 08 00 00 00       	mov    $0x8,%eax
 45b:	cd 40                	int    $0x40
 45d:	c3                   	ret    

0000045e <link>:
SYSCALL(link)
 45e:	b8 13 00 00 00       	mov    $0x13,%eax
 463:	cd 40                	int    $0x40
 465:	c3                   	ret    

00000466 <mkdir>:
SYSCALL(mkdir)
 466:	b8 14 00 00 00       	mov    $0x14,%eax
 46b:	cd 40                	int    $0x40
 46d:	c3                   	ret    

0000046e <chdir>:
SYSCALL(chdir)
 46e:	b8 09 00 00 00       	mov    $0x9,%eax
 473:	cd 40                	int    $0x40
 475:	c3                   	ret    

00000476 <dup>:
SYSCALL(dup)
 476:	b8 0a 00 00 00       	mov    $0xa,%eax
 47b:	cd 40                	int    $0x40
 47d:	c3                   	ret    

0000047e <getpid>:
SYSCALL(getpid)
 47e:	b8 0b 00 00 00       	mov    $0xb,%eax
 483:	cd 40                	int    $0x40
 485:	c3                   	ret    

00000486 <sbrk>:
SYSCALL(sbrk)
 486:	b8 0c 00 00 00       	mov    $0xc,%eax
 48b:	cd 40                	int    $0x40
 48d:	c3                   	ret    

0000048e <sleep>:
SYSCALL(sleep)
 48e:	b8 0d 00 00 00       	mov    $0xd,%eax
 493:	cd 40                	int    $0x40
 495:	c3                   	ret    

00000496 <uptime>:
SYSCALL(uptime)
 496:	b8 0e 00 00 00       	mov    $0xe,%eax
 49b:	cd 40                	int    $0x40
 49d:	c3                   	ret    

0000049e <halt>:
SYSCALL(halt)
 49e:	b8 16 00 00 00       	mov    $0x16,%eax
 4a3:	cd 40                	int    $0x40
 4a5:	c3                   	ret    

000004a6 <date>:
SYSCALL(date)
 4a6:	b8 17 00 00 00       	mov    $0x17,%eax
 4ab:	cd 40                	int    $0x40
 4ad:	c3                   	ret    

000004ae <getuid>:
SYSCALL(getuid)
 4ae:	b8 18 00 00 00       	mov    $0x18,%eax
 4b3:	cd 40                	int    $0x40
 4b5:	c3                   	ret    

000004b6 <getgid>:
SYSCALL(getgid)
 4b6:	b8 19 00 00 00       	mov    $0x19,%eax
 4bb:	cd 40                	int    $0x40
 4bd:	c3                   	ret    

000004be <getppid>:
SYSCALL(getppid)
 4be:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4c3:	cd 40                	int    $0x40
 4c5:	c3                   	ret    

000004c6 <setuid>:
SYSCALL(setuid)
 4c6:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4cb:	cd 40                	int    $0x40
 4cd:	c3                   	ret    

000004ce <setgid>:
SYSCALL(setgid)
 4ce:	b8 1c 00 00 00       	mov    $0x1c,%eax
 4d3:	cd 40                	int    $0x40
 4d5:	c3                   	ret    

000004d6 <getprocs>:
SYSCALL(getprocs)
 4d6:	b8 1d 00 00 00       	mov    $0x1d,%eax
 4db:	cd 40                	int    $0x40
 4dd:	c3                   	ret    

000004de <setpriority>:
SYSCALL(setpriority)
 4de:	b8 1e 00 00 00       	mov    $0x1e,%eax
 4e3:	cd 40                	int    $0x40
 4e5:	c3                   	ret    

000004e6 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4e6:	55                   	push   %ebp
 4e7:	89 e5                	mov    %esp,%ebp
 4e9:	83 ec 18             	sub    $0x18,%esp
 4ec:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ef:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4f2:	83 ec 04             	sub    $0x4,%esp
 4f5:	6a 01                	push   $0x1
 4f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4fa:	50                   	push   %eax
 4fb:	ff 75 08             	pushl  0x8(%ebp)
 4fe:	e8 1b ff ff ff       	call   41e <write>
 503:	83 c4 10             	add    $0x10,%esp
}
 506:	90                   	nop
 507:	c9                   	leave  
 508:	c3                   	ret    

00000509 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 509:	55                   	push   %ebp
 50a:	89 e5                	mov    %esp,%ebp
 50c:	53                   	push   %ebx
 50d:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 510:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 517:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 51b:	74 17                	je     534 <printint+0x2b>
 51d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 521:	79 11                	jns    534 <printint+0x2b>
    neg = 1;
 523:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 52a:	8b 45 0c             	mov    0xc(%ebp),%eax
 52d:	f7 d8                	neg    %eax
 52f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 532:	eb 06                	jmp    53a <printint+0x31>
  } else {
    x = xx;
 534:	8b 45 0c             	mov    0xc(%ebp),%eax
 537:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 53a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 541:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 544:	8d 41 01             	lea    0x1(%ecx),%eax
 547:	89 45 f4             	mov    %eax,-0xc(%ebp)
 54a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 54d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 550:	ba 00 00 00 00       	mov    $0x0,%edx
 555:	f7 f3                	div    %ebx
 557:	89 d0                	mov    %edx,%eax
 559:	0f b6 80 0c 0c 00 00 	movzbl 0xc0c(%eax),%eax
 560:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 564:	8b 5d 10             	mov    0x10(%ebp),%ebx
 567:	8b 45 ec             	mov    -0x14(%ebp),%eax
 56a:	ba 00 00 00 00       	mov    $0x0,%edx
 56f:	f7 f3                	div    %ebx
 571:	89 45 ec             	mov    %eax,-0x14(%ebp)
 574:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 578:	75 c7                	jne    541 <printint+0x38>
  if(neg)
 57a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 57e:	74 2d                	je     5ad <printint+0xa4>
    buf[i++] = '-';
 580:	8b 45 f4             	mov    -0xc(%ebp),%eax
 583:	8d 50 01             	lea    0x1(%eax),%edx
 586:	89 55 f4             	mov    %edx,-0xc(%ebp)
 589:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 58e:	eb 1d                	jmp    5ad <printint+0xa4>
    putc(fd, buf[i]);
 590:	8d 55 dc             	lea    -0x24(%ebp),%edx
 593:	8b 45 f4             	mov    -0xc(%ebp),%eax
 596:	01 d0                	add    %edx,%eax
 598:	0f b6 00             	movzbl (%eax),%eax
 59b:	0f be c0             	movsbl %al,%eax
 59e:	83 ec 08             	sub    $0x8,%esp
 5a1:	50                   	push   %eax
 5a2:	ff 75 08             	pushl  0x8(%ebp)
 5a5:	e8 3c ff ff ff       	call   4e6 <putc>
 5aa:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5ad:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5b5:	79 d9                	jns    590 <printint+0x87>
    putc(fd, buf[i]);
}
 5b7:	90                   	nop
 5b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5bb:	c9                   	leave  
 5bc:	c3                   	ret    

000005bd <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5bd:	55                   	push   %ebp
 5be:	89 e5                	mov    %esp,%ebp
 5c0:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5c3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5ca:	8d 45 0c             	lea    0xc(%ebp),%eax
 5cd:	83 c0 04             	add    $0x4,%eax
 5d0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5d3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5da:	e9 59 01 00 00       	jmp    738 <printf+0x17b>
    c = fmt[i] & 0xff;
 5df:	8b 55 0c             	mov    0xc(%ebp),%edx
 5e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5e5:	01 d0                	add    %edx,%eax
 5e7:	0f b6 00             	movzbl (%eax),%eax
 5ea:	0f be c0             	movsbl %al,%eax
 5ed:	25 ff 00 00 00       	and    $0xff,%eax
 5f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5f9:	75 2c                	jne    627 <printf+0x6a>
      if(c == '%'){
 5fb:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5ff:	75 0c                	jne    60d <printf+0x50>
        state = '%';
 601:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 608:	e9 27 01 00 00       	jmp    734 <printf+0x177>
      } else {
        putc(fd, c);
 60d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 610:	0f be c0             	movsbl %al,%eax
 613:	83 ec 08             	sub    $0x8,%esp
 616:	50                   	push   %eax
 617:	ff 75 08             	pushl  0x8(%ebp)
 61a:	e8 c7 fe ff ff       	call   4e6 <putc>
 61f:	83 c4 10             	add    $0x10,%esp
 622:	e9 0d 01 00 00       	jmp    734 <printf+0x177>
      }
    } else if(state == '%'){
 627:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 62b:	0f 85 03 01 00 00    	jne    734 <printf+0x177>
      if(c == 'd'){
 631:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 635:	75 1e                	jne    655 <printf+0x98>
        printint(fd, *ap, 10, 1);
 637:	8b 45 e8             	mov    -0x18(%ebp),%eax
 63a:	8b 00                	mov    (%eax),%eax
 63c:	6a 01                	push   $0x1
 63e:	6a 0a                	push   $0xa
 640:	50                   	push   %eax
 641:	ff 75 08             	pushl  0x8(%ebp)
 644:	e8 c0 fe ff ff       	call   509 <printint>
 649:	83 c4 10             	add    $0x10,%esp
        ap++;
 64c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 650:	e9 d8 00 00 00       	jmp    72d <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 655:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 659:	74 06                	je     661 <printf+0xa4>
 65b:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 65f:	75 1e                	jne    67f <printf+0xc2>
        printint(fd, *ap, 16, 0);
 661:	8b 45 e8             	mov    -0x18(%ebp),%eax
 664:	8b 00                	mov    (%eax),%eax
 666:	6a 00                	push   $0x0
 668:	6a 10                	push   $0x10
 66a:	50                   	push   %eax
 66b:	ff 75 08             	pushl  0x8(%ebp)
 66e:	e8 96 fe ff ff       	call   509 <printint>
 673:	83 c4 10             	add    $0x10,%esp
        ap++;
 676:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 67a:	e9 ae 00 00 00       	jmp    72d <printf+0x170>
      } else if(c == 's'){
 67f:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 683:	75 43                	jne    6c8 <printf+0x10b>
        s = (char*)*ap;
 685:	8b 45 e8             	mov    -0x18(%ebp),%eax
 688:	8b 00                	mov    (%eax),%eax
 68a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 68d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 691:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 695:	75 25                	jne    6bc <printf+0xff>
          s = "(null)";
 697:	c7 45 f4 b9 09 00 00 	movl   $0x9b9,-0xc(%ebp)
        while(*s != 0){
 69e:	eb 1c                	jmp    6bc <printf+0xff>
          putc(fd, *s);
 6a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6a3:	0f b6 00             	movzbl (%eax),%eax
 6a6:	0f be c0             	movsbl %al,%eax
 6a9:	83 ec 08             	sub    $0x8,%esp
 6ac:	50                   	push   %eax
 6ad:	ff 75 08             	pushl  0x8(%ebp)
 6b0:	e8 31 fe ff ff       	call   4e6 <putc>
 6b5:	83 c4 10             	add    $0x10,%esp
          s++;
 6b8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6bf:	0f b6 00             	movzbl (%eax),%eax
 6c2:	84 c0                	test   %al,%al
 6c4:	75 da                	jne    6a0 <printf+0xe3>
 6c6:	eb 65                	jmp    72d <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6c8:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6cc:	75 1d                	jne    6eb <printf+0x12e>
        putc(fd, *ap);
 6ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6d1:	8b 00                	mov    (%eax),%eax
 6d3:	0f be c0             	movsbl %al,%eax
 6d6:	83 ec 08             	sub    $0x8,%esp
 6d9:	50                   	push   %eax
 6da:	ff 75 08             	pushl  0x8(%ebp)
 6dd:	e8 04 fe ff ff       	call   4e6 <putc>
 6e2:	83 c4 10             	add    $0x10,%esp
        ap++;
 6e5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6e9:	eb 42                	jmp    72d <printf+0x170>
      } else if(c == '%'){
 6eb:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6ef:	75 17                	jne    708 <printf+0x14b>
        putc(fd, c);
 6f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6f4:	0f be c0             	movsbl %al,%eax
 6f7:	83 ec 08             	sub    $0x8,%esp
 6fa:	50                   	push   %eax
 6fb:	ff 75 08             	pushl  0x8(%ebp)
 6fe:	e8 e3 fd ff ff       	call   4e6 <putc>
 703:	83 c4 10             	add    $0x10,%esp
 706:	eb 25                	jmp    72d <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 708:	83 ec 08             	sub    $0x8,%esp
 70b:	6a 25                	push   $0x25
 70d:	ff 75 08             	pushl  0x8(%ebp)
 710:	e8 d1 fd ff ff       	call   4e6 <putc>
 715:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 718:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 71b:	0f be c0             	movsbl %al,%eax
 71e:	83 ec 08             	sub    $0x8,%esp
 721:	50                   	push   %eax
 722:	ff 75 08             	pushl  0x8(%ebp)
 725:	e8 bc fd ff ff       	call   4e6 <putc>
 72a:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 72d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 734:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 738:	8b 55 0c             	mov    0xc(%ebp),%edx
 73b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73e:	01 d0                	add    %edx,%eax
 740:	0f b6 00             	movzbl (%eax),%eax
 743:	84 c0                	test   %al,%al
 745:	0f 85 94 fe ff ff    	jne    5df <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 74b:	90                   	nop
 74c:	c9                   	leave  
 74d:	c3                   	ret    

0000074e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 74e:	55                   	push   %ebp
 74f:	89 e5                	mov    %esp,%ebp
 751:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 754:	8b 45 08             	mov    0x8(%ebp),%eax
 757:	83 e8 08             	sub    $0x8,%eax
 75a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 75d:	a1 28 0c 00 00       	mov    0xc28,%eax
 762:	89 45 fc             	mov    %eax,-0x4(%ebp)
 765:	eb 24                	jmp    78b <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 767:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76a:	8b 00                	mov    (%eax),%eax
 76c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 76f:	77 12                	ja     783 <free+0x35>
 771:	8b 45 f8             	mov    -0x8(%ebp),%eax
 774:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 777:	77 24                	ja     79d <free+0x4f>
 779:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77c:	8b 00                	mov    (%eax),%eax
 77e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 781:	77 1a                	ja     79d <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 783:	8b 45 fc             	mov    -0x4(%ebp),%eax
 786:	8b 00                	mov    (%eax),%eax
 788:	89 45 fc             	mov    %eax,-0x4(%ebp)
 78b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 791:	76 d4                	jbe    767 <free+0x19>
 793:	8b 45 fc             	mov    -0x4(%ebp),%eax
 796:	8b 00                	mov    (%eax),%eax
 798:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 79b:	76 ca                	jbe    767 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 79d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a0:	8b 40 04             	mov    0x4(%eax),%eax
 7a3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ad:	01 c2                	add    %eax,%edx
 7af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b2:	8b 00                	mov    (%eax),%eax
 7b4:	39 c2                	cmp    %eax,%edx
 7b6:	75 24                	jne    7dc <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7bb:	8b 50 04             	mov    0x4(%eax),%edx
 7be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c1:	8b 00                	mov    (%eax),%eax
 7c3:	8b 40 04             	mov    0x4(%eax),%eax
 7c6:	01 c2                	add    %eax,%edx
 7c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7cb:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d1:	8b 00                	mov    (%eax),%eax
 7d3:	8b 10                	mov    (%eax),%edx
 7d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d8:	89 10                	mov    %edx,(%eax)
 7da:	eb 0a                	jmp    7e6 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7df:	8b 10                	mov    (%eax),%edx
 7e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e4:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e9:	8b 40 04             	mov    0x4(%eax),%eax
 7ec:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f6:	01 d0                	add    %edx,%eax
 7f8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7fb:	75 20                	jne    81d <free+0xcf>
    p->s.size += bp->s.size;
 7fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 800:	8b 50 04             	mov    0x4(%eax),%edx
 803:	8b 45 f8             	mov    -0x8(%ebp),%eax
 806:	8b 40 04             	mov    0x4(%eax),%eax
 809:	01 c2                	add    %eax,%edx
 80b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 811:	8b 45 f8             	mov    -0x8(%ebp),%eax
 814:	8b 10                	mov    (%eax),%edx
 816:	8b 45 fc             	mov    -0x4(%ebp),%eax
 819:	89 10                	mov    %edx,(%eax)
 81b:	eb 08                	jmp    825 <free+0xd7>
  } else
    p->s.ptr = bp;
 81d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 820:	8b 55 f8             	mov    -0x8(%ebp),%edx
 823:	89 10                	mov    %edx,(%eax)
  freep = p;
 825:	8b 45 fc             	mov    -0x4(%ebp),%eax
 828:	a3 28 0c 00 00       	mov    %eax,0xc28
}
 82d:	90                   	nop
 82e:	c9                   	leave  
 82f:	c3                   	ret    

00000830 <morecore>:

static Header*
morecore(uint nu)
{
 830:	55                   	push   %ebp
 831:	89 e5                	mov    %esp,%ebp
 833:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 836:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 83d:	77 07                	ja     846 <morecore+0x16>
    nu = 4096;
 83f:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 846:	8b 45 08             	mov    0x8(%ebp),%eax
 849:	c1 e0 03             	shl    $0x3,%eax
 84c:	83 ec 0c             	sub    $0xc,%esp
 84f:	50                   	push   %eax
 850:	e8 31 fc ff ff       	call   486 <sbrk>
 855:	83 c4 10             	add    $0x10,%esp
 858:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 85b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 85f:	75 07                	jne    868 <morecore+0x38>
    return 0;
 861:	b8 00 00 00 00       	mov    $0x0,%eax
 866:	eb 26                	jmp    88e <morecore+0x5e>
  hp = (Header*)p;
 868:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 86e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 871:	8b 55 08             	mov    0x8(%ebp),%edx
 874:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 877:	8b 45 f0             	mov    -0x10(%ebp),%eax
 87a:	83 c0 08             	add    $0x8,%eax
 87d:	83 ec 0c             	sub    $0xc,%esp
 880:	50                   	push   %eax
 881:	e8 c8 fe ff ff       	call   74e <free>
 886:	83 c4 10             	add    $0x10,%esp
  return freep;
 889:	a1 28 0c 00 00       	mov    0xc28,%eax
}
 88e:	c9                   	leave  
 88f:	c3                   	ret    

00000890 <malloc>:

void*
malloc(uint nbytes)
{
 890:	55                   	push   %ebp
 891:	89 e5                	mov    %esp,%ebp
 893:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 896:	8b 45 08             	mov    0x8(%ebp),%eax
 899:	83 c0 07             	add    $0x7,%eax
 89c:	c1 e8 03             	shr    $0x3,%eax
 89f:	83 c0 01             	add    $0x1,%eax
 8a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8a5:	a1 28 0c 00 00       	mov    0xc28,%eax
 8aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8b1:	75 23                	jne    8d6 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8b3:	c7 45 f0 20 0c 00 00 	movl   $0xc20,-0x10(%ebp)
 8ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8bd:	a3 28 0c 00 00       	mov    %eax,0xc28
 8c2:	a1 28 0c 00 00       	mov    0xc28,%eax
 8c7:	a3 20 0c 00 00       	mov    %eax,0xc20
    base.s.size = 0;
 8cc:	c7 05 24 0c 00 00 00 	movl   $0x0,0xc24
 8d3:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d9:	8b 00                	mov    (%eax),%eax
 8db:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8de:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e1:	8b 40 04             	mov    0x4(%eax),%eax
 8e4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8e7:	72 4d                	jb     936 <malloc+0xa6>
      if(p->s.size == nunits)
 8e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ec:	8b 40 04             	mov    0x4(%eax),%eax
 8ef:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8f2:	75 0c                	jne    900 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f7:	8b 10                	mov    (%eax),%edx
 8f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8fc:	89 10                	mov    %edx,(%eax)
 8fe:	eb 26                	jmp    926 <malloc+0x96>
      else {
        p->s.size -= nunits;
 900:	8b 45 f4             	mov    -0xc(%ebp),%eax
 903:	8b 40 04             	mov    0x4(%eax),%eax
 906:	2b 45 ec             	sub    -0x14(%ebp),%eax
 909:	89 c2                	mov    %eax,%edx
 90b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90e:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 911:	8b 45 f4             	mov    -0xc(%ebp),%eax
 914:	8b 40 04             	mov    0x4(%eax),%eax
 917:	c1 e0 03             	shl    $0x3,%eax
 91a:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 91d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 920:	8b 55 ec             	mov    -0x14(%ebp),%edx
 923:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 926:	8b 45 f0             	mov    -0x10(%ebp),%eax
 929:	a3 28 0c 00 00       	mov    %eax,0xc28
      return (void*)(p + 1);
 92e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 931:	83 c0 08             	add    $0x8,%eax
 934:	eb 3b                	jmp    971 <malloc+0xe1>
    }
    if(p == freep)
 936:	a1 28 0c 00 00       	mov    0xc28,%eax
 93b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 93e:	75 1e                	jne    95e <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 940:	83 ec 0c             	sub    $0xc,%esp
 943:	ff 75 ec             	pushl  -0x14(%ebp)
 946:	e8 e5 fe ff ff       	call   830 <morecore>
 94b:	83 c4 10             	add    $0x10,%esp
 94e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 951:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 955:	75 07                	jne    95e <malloc+0xce>
        return 0;
 957:	b8 00 00 00 00       	mov    $0x0,%eax
 95c:	eb 13                	jmp    971 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 95e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 961:	89 45 f0             	mov    %eax,-0x10(%ebp)
 964:	8b 45 f4             	mov    -0xc(%ebp),%eax
 967:	8b 00                	mov    (%eax),%eax
 969:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 96c:	e9 6d ff ff ff       	jmp    8de <malloc+0x4e>
}
 971:	c9                   	leave  
 972:	c3                   	ret    
