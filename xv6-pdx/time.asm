
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
  14:	e8 6b 04 00 00       	call   484 <fork>
  19:	89 45 f4             	mov    %eax,-0xc(%ebp)

  start_ticks = uptime();
  1c:	e8 03 05 00 00       	call   524 <uptime>
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
  3d:	e8 82 04 00 00       	call   4c4 <exec>
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
  5d:	68 19 0a 00 00       	push   $0xa19
  62:	6a 02                	push   $0x2
  64:	e8 fa 05 00 00       	call   663 <printf>
  69:	83 c4 10             	add    $0x10,%esp
    exit();
  6c:	e8 1b 04 00 00       	call   48c <exit>
  }
  wait();
  71:	e8 1e 04 00 00       	call   494 <wait>
  total_ticks = uptime()-start_ticks;
  76:	e8 a9 04 00 00       	call   524 <uptime>
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
  90:	68 2c 0a 00 00       	push   $0xa2c
  95:	6a 01                	push   $0x1
  97:	e8 c7 05 00 00       	call   663 <printf>
  9c:	83 c4 10             	add    $0x10,%esp
  9f:	eb 1b                	jmp    bc <main+0xbc>
  else
    printf(1, "%s ran in ", argv[1]);
  a1:	8b 43 04             	mov    0x4(%ebx),%eax
  a4:	83 c0 04             	add    $0x4,%eax
  a7:	8b 00                	mov    (%eax),%eax
  a9:	83 ec 04             	sub    $0x4,%esp
  ac:	50                   	push   %eax
  ad:	68 34 0a 00 00       	push   $0xa34
  b2:	6a 01                	push   $0x1
  b4:	e8 aa 05 00 00       	call   663 <printf>
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
 108:	68 3f 0a 00 00       	push   $0xa3f
 10d:	6a 01                	push   $0x1
 10f:	e8 4f 05 00 00       	call   663 <printf>
 114:	83 c4 10             	add    $0x10,%esp
 117:	eb 32                	jmp    14b <main+0x14b>
  else if(milliseconds < 100)
 119:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 11d:	7f 17                	jg     136 <main+0x136>
    printf(1, "%d.0%d", seconds, milliseconds);
 11f:	ff 75 e4             	pushl  -0x1c(%ebp)
 122:	ff 75 e8             	pushl  -0x18(%ebp)
 125:	68 47 0a 00 00       	push   $0xa47
 12a:	6a 01                	push   $0x1
 12c:	e8 32 05 00 00       	call   663 <printf>
 131:	83 c4 10             	add    $0x10,%esp
 134:	eb 15                	jmp    14b <main+0x14b>
  else
    printf(1, "%d.%d", seconds, milliseconds);
 136:	ff 75 e4             	pushl  -0x1c(%ebp)
 139:	ff 75 e8             	pushl  -0x18(%ebp)
 13c:	68 4e 0a 00 00       	push   $0xa4e
 141:	6a 01                	push   $0x1
 143:	e8 1b 05 00 00       	call   663 <printf>
 148:	83 c4 10             	add    $0x10,%esp

  printf(1, " seconds.\n");
 14b:	83 ec 08             	sub    $0x8,%esp
 14e:	68 54 0a 00 00       	push   $0xa54
 153:	6a 01                	push   $0x1
 155:	e8 09 05 00 00       	call   663 <printf>
 15a:	83 c4 10             	add    $0x10,%esp

  exit();
 15d:	e8 2a 03 00 00       	call   48c <exit>

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
 285:	e8 1a 02 00 00       	call   4a4 <read>
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
 2e8:	e8 df 01 00 00       	call   4cc <open>
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
 309:	e8 d6 01 00 00       	call   4e4 <fstat>
 30e:	83 c4 10             	add    $0x10,%esp
 311:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 314:	83 ec 0c             	sub    $0xc,%esp
 317:	ff 75 f4             	pushl  -0xc(%ebp)
 31a:	e8 95 01 00 00       	call   4b4 <close>
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

000003f6 <atoo>:

#ifdef CS333_P5
int
atoo(const char *s)
{
 3f6:	55                   	push   %ebp
 3f7:	89 e5                	mov    %esp,%ebp
 3f9:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 3fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 403:	eb 04                	jmp    409 <atoo+0x13>
 405:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 409:	8b 45 08             	mov    0x8(%ebp),%eax
 40c:	0f b6 00             	movzbl (%eax),%eax
 40f:	3c 20                	cmp    $0x20,%al
 411:	74 f2                	je     405 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 413:	8b 45 08             	mov    0x8(%ebp),%eax
 416:	0f b6 00             	movzbl (%eax),%eax
 419:	3c 2d                	cmp    $0x2d,%al
 41b:	75 07                	jne    424 <atoo+0x2e>
 41d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 422:	eb 05                	jmp    429 <atoo+0x33>
 424:	b8 01 00 00 00       	mov    $0x1,%eax
 429:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 42c:	8b 45 08             	mov    0x8(%ebp),%eax
 42f:	0f b6 00             	movzbl (%eax),%eax
 432:	3c 2b                	cmp    $0x2b,%al
 434:	74 0a                	je     440 <atoo+0x4a>
 436:	8b 45 08             	mov    0x8(%ebp),%eax
 439:	0f b6 00             	movzbl (%eax),%eax
 43c:	3c 2d                	cmp    $0x2d,%al
 43e:	75 27                	jne    467 <atoo+0x71>
    s++;
 440:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 444:	eb 21                	jmp    467 <atoo+0x71>
    n = n*8 + *s++ - '0';
 446:	8b 45 fc             	mov    -0x4(%ebp),%eax
 449:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 450:	8b 45 08             	mov    0x8(%ebp),%eax
 453:	8d 50 01             	lea    0x1(%eax),%edx
 456:	89 55 08             	mov    %edx,0x8(%ebp)
 459:	0f b6 00             	movzbl (%eax),%eax
 45c:	0f be c0             	movsbl %al,%eax
 45f:	01 c8                	add    %ecx,%eax
 461:	83 e8 30             	sub    $0x30,%eax
 464:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 467:	8b 45 08             	mov    0x8(%ebp),%eax
 46a:	0f b6 00             	movzbl (%eax),%eax
 46d:	3c 2f                	cmp    $0x2f,%al
 46f:	7e 0a                	jle    47b <atoo+0x85>
 471:	8b 45 08             	mov    0x8(%ebp),%eax
 474:	0f b6 00             	movzbl (%eax),%eax
 477:	3c 39                	cmp    $0x39,%al
 479:	7e cb                	jle    446 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 47b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 47e:	0f af 45 fc          	imul   -0x4(%ebp),%eax
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

0000056c <setpriority>:
SYSCALL(setpriority)
 56c:	b8 1e 00 00 00       	mov    $0x1e,%eax
 571:	cd 40                	int    $0x40
 573:	c3                   	ret    

00000574 <chmod>:
SYSCALL(chmod)
 574:	b8 1f 00 00 00       	mov    $0x1f,%eax
 579:	cd 40                	int    $0x40
 57b:	c3                   	ret    

0000057c <chown>:
SYSCALL(chown)
 57c:	b8 20 00 00 00       	mov    $0x20,%eax
 581:	cd 40                	int    $0x40
 583:	c3                   	ret    

00000584 <chgrp>:
SYSCALL(chgrp)
 584:	b8 21 00 00 00       	mov    $0x21,%eax
 589:	cd 40                	int    $0x40
 58b:	c3                   	ret    

0000058c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 58c:	55                   	push   %ebp
 58d:	89 e5                	mov    %esp,%ebp
 58f:	83 ec 18             	sub    $0x18,%esp
 592:	8b 45 0c             	mov    0xc(%ebp),%eax
 595:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 598:	83 ec 04             	sub    $0x4,%esp
 59b:	6a 01                	push   $0x1
 59d:	8d 45 f4             	lea    -0xc(%ebp),%eax
 5a0:	50                   	push   %eax
 5a1:	ff 75 08             	pushl  0x8(%ebp)
 5a4:	e8 03 ff ff ff       	call   4ac <write>
 5a9:	83 c4 10             	add    $0x10,%esp
}
 5ac:	90                   	nop
 5ad:	c9                   	leave  
 5ae:	c3                   	ret    

000005af <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5af:	55                   	push   %ebp
 5b0:	89 e5                	mov    %esp,%ebp
 5b2:	53                   	push   %ebx
 5b3:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5b6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 5bd:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 5c1:	74 17                	je     5da <printint+0x2b>
 5c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5c7:	79 11                	jns    5da <printint+0x2b>
    neg = 1;
 5c9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 5d0:	8b 45 0c             	mov    0xc(%ebp),%eax
 5d3:	f7 d8                	neg    %eax
 5d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5d8:	eb 06                	jmp    5e0 <printint+0x31>
  } else {
    x = xx;
 5da:	8b 45 0c             	mov    0xc(%ebp),%eax
 5dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 5e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 5e7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 5ea:	8d 41 01             	lea    0x1(%ecx),%eax
 5ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
 5f0:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5f6:	ba 00 00 00 00       	mov    $0x0,%edx
 5fb:	f7 f3                	div    %ebx
 5fd:	89 d0                	mov    %edx,%eax
 5ff:	0f b6 80 d4 0c 00 00 	movzbl 0xcd4(%eax),%eax
 606:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 60a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 60d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 610:	ba 00 00 00 00       	mov    $0x0,%edx
 615:	f7 f3                	div    %ebx
 617:	89 45 ec             	mov    %eax,-0x14(%ebp)
 61a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 61e:	75 c7                	jne    5e7 <printint+0x38>
  if(neg)
 620:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 624:	74 2d                	je     653 <printint+0xa4>
    buf[i++] = '-';
 626:	8b 45 f4             	mov    -0xc(%ebp),%eax
 629:	8d 50 01             	lea    0x1(%eax),%edx
 62c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 62f:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 634:	eb 1d                	jmp    653 <printint+0xa4>
    putc(fd, buf[i]);
 636:	8d 55 dc             	lea    -0x24(%ebp),%edx
 639:	8b 45 f4             	mov    -0xc(%ebp),%eax
 63c:	01 d0                	add    %edx,%eax
 63e:	0f b6 00             	movzbl (%eax),%eax
 641:	0f be c0             	movsbl %al,%eax
 644:	83 ec 08             	sub    $0x8,%esp
 647:	50                   	push   %eax
 648:	ff 75 08             	pushl  0x8(%ebp)
 64b:	e8 3c ff ff ff       	call   58c <putc>
 650:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 653:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 657:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 65b:	79 d9                	jns    636 <printint+0x87>
    putc(fd, buf[i]);
}
 65d:	90                   	nop
 65e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 661:	c9                   	leave  
 662:	c3                   	ret    

00000663 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 663:	55                   	push   %ebp
 664:	89 e5                	mov    %esp,%ebp
 666:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 669:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 670:	8d 45 0c             	lea    0xc(%ebp),%eax
 673:	83 c0 04             	add    $0x4,%eax
 676:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 679:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 680:	e9 59 01 00 00       	jmp    7de <printf+0x17b>
    c = fmt[i] & 0xff;
 685:	8b 55 0c             	mov    0xc(%ebp),%edx
 688:	8b 45 f0             	mov    -0x10(%ebp),%eax
 68b:	01 d0                	add    %edx,%eax
 68d:	0f b6 00             	movzbl (%eax),%eax
 690:	0f be c0             	movsbl %al,%eax
 693:	25 ff 00 00 00       	and    $0xff,%eax
 698:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 69b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 69f:	75 2c                	jne    6cd <printf+0x6a>
      if(c == '%'){
 6a1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6a5:	75 0c                	jne    6b3 <printf+0x50>
        state = '%';
 6a7:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 6ae:	e9 27 01 00 00       	jmp    7da <printf+0x177>
      } else {
        putc(fd, c);
 6b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6b6:	0f be c0             	movsbl %al,%eax
 6b9:	83 ec 08             	sub    $0x8,%esp
 6bc:	50                   	push   %eax
 6bd:	ff 75 08             	pushl  0x8(%ebp)
 6c0:	e8 c7 fe ff ff       	call   58c <putc>
 6c5:	83 c4 10             	add    $0x10,%esp
 6c8:	e9 0d 01 00 00       	jmp    7da <printf+0x177>
      }
    } else if(state == '%'){
 6cd:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 6d1:	0f 85 03 01 00 00    	jne    7da <printf+0x177>
      if(c == 'd'){
 6d7:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 6db:	75 1e                	jne    6fb <printf+0x98>
        printint(fd, *ap, 10, 1);
 6dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6e0:	8b 00                	mov    (%eax),%eax
 6e2:	6a 01                	push   $0x1
 6e4:	6a 0a                	push   $0xa
 6e6:	50                   	push   %eax
 6e7:	ff 75 08             	pushl  0x8(%ebp)
 6ea:	e8 c0 fe ff ff       	call   5af <printint>
 6ef:	83 c4 10             	add    $0x10,%esp
        ap++;
 6f2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6f6:	e9 d8 00 00 00       	jmp    7d3 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 6fb:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6ff:	74 06                	je     707 <printf+0xa4>
 701:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 705:	75 1e                	jne    725 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 707:	8b 45 e8             	mov    -0x18(%ebp),%eax
 70a:	8b 00                	mov    (%eax),%eax
 70c:	6a 00                	push   $0x0
 70e:	6a 10                	push   $0x10
 710:	50                   	push   %eax
 711:	ff 75 08             	pushl  0x8(%ebp)
 714:	e8 96 fe ff ff       	call   5af <printint>
 719:	83 c4 10             	add    $0x10,%esp
        ap++;
 71c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 720:	e9 ae 00 00 00       	jmp    7d3 <printf+0x170>
      } else if(c == 's'){
 725:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 729:	75 43                	jne    76e <printf+0x10b>
        s = (char*)*ap;
 72b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 72e:	8b 00                	mov    (%eax),%eax
 730:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 733:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 737:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 73b:	75 25                	jne    762 <printf+0xff>
          s = "(null)";
 73d:	c7 45 f4 5f 0a 00 00 	movl   $0xa5f,-0xc(%ebp)
        while(*s != 0){
 744:	eb 1c                	jmp    762 <printf+0xff>
          putc(fd, *s);
 746:	8b 45 f4             	mov    -0xc(%ebp),%eax
 749:	0f b6 00             	movzbl (%eax),%eax
 74c:	0f be c0             	movsbl %al,%eax
 74f:	83 ec 08             	sub    $0x8,%esp
 752:	50                   	push   %eax
 753:	ff 75 08             	pushl  0x8(%ebp)
 756:	e8 31 fe ff ff       	call   58c <putc>
 75b:	83 c4 10             	add    $0x10,%esp
          s++;
 75e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 762:	8b 45 f4             	mov    -0xc(%ebp),%eax
 765:	0f b6 00             	movzbl (%eax),%eax
 768:	84 c0                	test   %al,%al
 76a:	75 da                	jne    746 <printf+0xe3>
 76c:	eb 65                	jmp    7d3 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 76e:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 772:	75 1d                	jne    791 <printf+0x12e>
        putc(fd, *ap);
 774:	8b 45 e8             	mov    -0x18(%ebp),%eax
 777:	8b 00                	mov    (%eax),%eax
 779:	0f be c0             	movsbl %al,%eax
 77c:	83 ec 08             	sub    $0x8,%esp
 77f:	50                   	push   %eax
 780:	ff 75 08             	pushl  0x8(%ebp)
 783:	e8 04 fe ff ff       	call   58c <putc>
 788:	83 c4 10             	add    $0x10,%esp
        ap++;
 78b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 78f:	eb 42                	jmp    7d3 <printf+0x170>
      } else if(c == '%'){
 791:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 795:	75 17                	jne    7ae <printf+0x14b>
        putc(fd, c);
 797:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 79a:	0f be c0             	movsbl %al,%eax
 79d:	83 ec 08             	sub    $0x8,%esp
 7a0:	50                   	push   %eax
 7a1:	ff 75 08             	pushl  0x8(%ebp)
 7a4:	e8 e3 fd ff ff       	call   58c <putc>
 7a9:	83 c4 10             	add    $0x10,%esp
 7ac:	eb 25                	jmp    7d3 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7ae:	83 ec 08             	sub    $0x8,%esp
 7b1:	6a 25                	push   $0x25
 7b3:	ff 75 08             	pushl  0x8(%ebp)
 7b6:	e8 d1 fd ff ff       	call   58c <putc>
 7bb:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 7be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7c1:	0f be c0             	movsbl %al,%eax
 7c4:	83 ec 08             	sub    $0x8,%esp
 7c7:	50                   	push   %eax
 7c8:	ff 75 08             	pushl  0x8(%ebp)
 7cb:	e8 bc fd ff ff       	call   58c <putc>
 7d0:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 7d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7da:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 7de:	8b 55 0c             	mov    0xc(%ebp),%edx
 7e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e4:	01 d0                	add    %edx,%eax
 7e6:	0f b6 00             	movzbl (%eax),%eax
 7e9:	84 c0                	test   %al,%al
 7eb:	0f 85 94 fe ff ff    	jne    685 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7f1:	90                   	nop
 7f2:	c9                   	leave  
 7f3:	c3                   	ret    

000007f4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7f4:	55                   	push   %ebp
 7f5:	89 e5                	mov    %esp,%ebp
 7f7:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7fa:	8b 45 08             	mov    0x8(%ebp),%eax
 7fd:	83 e8 08             	sub    $0x8,%eax
 800:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 803:	a1 f0 0c 00 00       	mov    0xcf0,%eax
 808:	89 45 fc             	mov    %eax,-0x4(%ebp)
 80b:	eb 24                	jmp    831 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 80d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 810:	8b 00                	mov    (%eax),%eax
 812:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 815:	77 12                	ja     829 <free+0x35>
 817:	8b 45 f8             	mov    -0x8(%ebp),%eax
 81a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 81d:	77 24                	ja     843 <free+0x4f>
 81f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 822:	8b 00                	mov    (%eax),%eax
 824:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 827:	77 1a                	ja     843 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 829:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82c:	8b 00                	mov    (%eax),%eax
 82e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 831:	8b 45 f8             	mov    -0x8(%ebp),%eax
 834:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 837:	76 d4                	jbe    80d <free+0x19>
 839:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83c:	8b 00                	mov    (%eax),%eax
 83e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 841:	76 ca                	jbe    80d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 843:	8b 45 f8             	mov    -0x8(%ebp),%eax
 846:	8b 40 04             	mov    0x4(%eax),%eax
 849:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 850:	8b 45 f8             	mov    -0x8(%ebp),%eax
 853:	01 c2                	add    %eax,%edx
 855:	8b 45 fc             	mov    -0x4(%ebp),%eax
 858:	8b 00                	mov    (%eax),%eax
 85a:	39 c2                	cmp    %eax,%edx
 85c:	75 24                	jne    882 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 85e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 861:	8b 50 04             	mov    0x4(%eax),%edx
 864:	8b 45 fc             	mov    -0x4(%ebp),%eax
 867:	8b 00                	mov    (%eax),%eax
 869:	8b 40 04             	mov    0x4(%eax),%eax
 86c:	01 c2                	add    %eax,%edx
 86e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 871:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 874:	8b 45 fc             	mov    -0x4(%ebp),%eax
 877:	8b 00                	mov    (%eax),%eax
 879:	8b 10                	mov    (%eax),%edx
 87b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 87e:	89 10                	mov    %edx,(%eax)
 880:	eb 0a                	jmp    88c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 882:	8b 45 fc             	mov    -0x4(%ebp),%eax
 885:	8b 10                	mov    (%eax),%edx
 887:	8b 45 f8             	mov    -0x8(%ebp),%eax
 88a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 88c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 88f:	8b 40 04             	mov    0x4(%eax),%eax
 892:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 899:	8b 45 fc             	mov    -0x4(%ebp),%eax
 89c:	01 d0                	add    %edx,%eax
 89e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8a1:	75 20                	jne    8c3 <free+0xcf>
    p->s.size += bp->s.size;
 8a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a6:	8b 50 04             	mov    0x4(%eax),%edx
 8a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ac:	8b 40 04             	mov    0x4(%eax),%eax
 8af:	01 c2                	add    %eax,%edx
 8b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ba:	8b 10                	mov    (%eax),%edx
 8bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8bf:	89 10                	mov    %edx,(%eax)
 8c1:	eb 08                	jmp    8cb <free+0xd7>
  } else
    p->s.ptr = bp;
 8c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8c9:	89 10                	mov    %edx,(%eax)
  freep = p;
 8cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ce:	a3 f0 0c 00 00       	mov    %eax,0xcf0
}
 8d3:	90                   	nop
 8d4:	c9                   	leave  
 8d5:	c3                   	ret    

000008d6 <morecore>:

static Header*
morecore(uint nu)
{
 8d6:	55                   	push   %ebp
 8d7:	89 e5                	mov    %esp,%ebp
 8d9:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 8dc:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 8e3:	77 07                	ja     8ec <morecore+0x16>
    nu = 4096;
 8e5:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8ec:	8b 45 08             	mov    0x8(%ebp),%eax
 8ef:	c1 e0 03             	shl    $0x3,%eax
 8f2:	83 ec 0c             	sub    $0xc,%esp
 8f5:	50                   	push   %eax
 8f6:	e8 19 fc ff ff       	call   514 <sbrk>
 8fb:	83 c4 10             	add    $0x10,%esp
 8fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 901:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 905:	75 07                	jne    90e <morecore+0x38>
    return 0;
 907:	b8 00 00 00 00       	mov    $0x0,%eax
 90c:	eb 26                	jmp    934 <morecore+0x5e>
  hp = (Header*)p;
 90e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 911:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 914:	8b 45 f0             	mov    -0x10(%ebp),%eax
 917:	8b 55 08             	mov    0x8(%ebp),%edx
 91a:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 91d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 920:	83 c0 08             	add    $0x8,%eax
 923:	83 ec 0c             	sub    $0xc,%esp
 926:	50                   	push   %eax
 927:	e8 c8 fe ff ff       	call   7f4 <free>
 92c:	83 c4 10             	add    $0x10,%esp
  return freep;
 92f:	a1 f0 0c 00 00       	mov    0xcf0,%eax
}
 934:	c9                   	leave  
 935:	c3                   	ret    

00000936 <malloc>:

void*
malloc(uint nbytes)
{
 936:	55                   	push   %ebp
 937:	89 e5                	mov    %esp,%ebp
 939:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 93c:	8b 45 08             	mov    0x8(%ebp),%eax
 93f:	83 c0 07             	add    $0x7,%eax
 942:	c1 e8 03             	shr    $0x3,%eax
 945:	83 c0 01             	add    $0x1,%eax
 948:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 94b:	a1 f0 0c 00 00       	mov    0xcf0,%eax
 950:	89 45 f0             	mov    %eax,-0x10(%ebp)
 953:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 957:	75 23                	jne    97c <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 959:	c7 45 f0 e8 0c 00 00 	movl   $0xce8,-0x10(%ebp)
 960:	8b 45 f0             	mov    -0x10(%ebp),%eax
 963:	a3 f0 0c 00 00       	mov    %eax,0xcf0
 968:	a1 f0 0c 00 00       	mov    0xcf0,%eax
 96d:	a3 e8 0c 00 00       	mov    %eax,0xce8
    base.s.size = 0;
 972:	c7 05 ec 0c 00 00 00 	movl   $0x0,0xcec
 979:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 97c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 97f:	8b 00                	mov    (%eax),%eax
 981:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 984:	8b 45 f4             	mov    -0xc(%ebp),%eax
 987:	8b 40 04             	mov    0x4(%eax),%eax
 98a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 98d:	72 4d                	jb     9dc <malloc+0xa6>
      if(p->s.size == nunits)
 98f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 992:	8b 40 04             	mov    0x4(%eax),%eax
 995:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 998:	75 0c                	jne    9a6 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 99a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 99d:	8b 10                	mov    (%eax),%edx
 99f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9a2:	89 10                	mov    %edx,(%eax)
 9a4:	eb 26                	jmp    9cc <malloc+0x96>
      else {
        p->s.size -= nunits;
 9a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a9:	8b 40 04             	mov    0x4(%eax),%eax
 9ac:	2b 45 ec             	sub    -0x14(%ebp),%eax
 9af:	89 c2                	mov    %eax,%edx
 9b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b4:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 9b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ba:	8b 40 04             	mov    0x4(%eax),%eax
 9bd:	c1 e0 03             	shl    $0x3,%eax
 9c0:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 9c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c6:	8b 55 ec             	mov    -0x14(%ebp),%edx
 9c9:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 9cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9cf:	a3 f0 0c 00 00       	mov    %eax,0xcf0
      return (void*)(p + 1);
 9d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d7:	83 c0 08             	add    $0x8,%eax
 9da:	eb 3b                	jmp    a17 <malloc+0xe1>
    }
    if(p == freep)
 9dc:	a1 f0 0c 00 00       	mov    0xcf0,%eax
 9e1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 9e4:	75 1e                	jne    a04 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 9e6:	83 ec 0c             	sub    $0xc,%esp
 9e9:	ff 75 ec             	pushl  -0x14(%ebp)
 9ec:	e8 e5 fe ff ff       	call   8d6 <morecore>
 9f1:	83 c4 10             	add    $0x10,%esp
 9f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9fb:	75 07                	jne    a04 <malloc+0xce>
        return 0;
 9fd:	b8 00 00 00 00       	mov    $0x0,%eax
 a02:	eb 13                	jmp    a17 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a07:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a0d:	8b 00                	mov    (%eax),%eax
 a0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a12:	e9 6d ff ff ff       	jmp    984 <malloc+0x4e>
}
 a17:	c9                   	leave  
 a18:	c3                   	ret    
