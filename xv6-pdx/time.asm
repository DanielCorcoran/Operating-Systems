
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
  int start_ticks = uptime();
  14:	e8 56 04 00 00       	call   46f <uptime>
  19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int total_ticks;
  int pid = fork();
  1c:	e8 ae 03 00 00       	call   3cf <fork>
  21:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(pid == 0){
  24:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  28:	75 20                	jne    4a <main+0x4a>
    exec(argv[1],argv+1);
  2a:	8b 43 04             	mov    0x4(%ebx),%eax
  2d:	8d 50 04             	lea    0x4(%eax),%edx
  30:	8b 43 04             	mov    0x4(%ebx),%eax
  33:	83 c0 04             	add    $0x4,%eax
  36:	8b 00                	mov    (%eax),%eax
  38:	83 ec 08             	sub    $0x8,%esp
  3b:	52                   	push   %edx
  3c:	50                   	push   %eax
  3d:	e8 cd 03 00 00       	call   40f <exec>
  42:	83 c4 10             	add    $0x10,%esp
    exit();
  45:	e8 8d 03 00 00       	call   3d7 <exit>
  }
  wait();
  4a:	e8 90 03 00 00       	call   3df <wait>
  total_ticks = uptime()-start_ticks;
  4f:	e8 1b 04 00 00       	call   46f <uptime>
  54:	2b 45 f4             	sub    -0xc(%ebp),%eax
  57:	89 45 ec             	mov    %eax,-0x14(%ebp)

  if(!argv[1])
  5a:	8b 43 04             	mov    0x4(%ebx),%eax
  5d:	83 c0 04             	add    $0x4,%eax
  60:	8b 00                	mov    (%eax),%eax
  62:	85 c0                	test   %eax,%eax
  64:	75 14                	jne    7a <main+0x7a>
    printf(1, "ran in ");
  66:	83 ec 08             	sub    $0x8,%esp
  69:	68 44 09 00 00       	push   $0x944
  6e:	6a 01                	push   $0x1
  70:	e8 19 05 00 00       	call   58e <printf>
  75:	83 c4 10             	add    $0x10,%esp
  78:	eb 1b                	jmp    95 <main+0x95>
  else
    printf(1, "%s ran in ", argv[1]);
  7a:	8b 43 04             	mov    0x4(%ebx),%eax
  7d:	83 c0 04             	add    $0x4,%eax
  80:	8b 00                	mov    (%eax),%eax
  82:	83 ec 04             	sub    $0x4,%esp
  85:	50                   	push   %eax
  86:	68 4c 09 00 00       	push   $0x94c
  8b:	6a 01                	push   $0x1
  8d:	e8 fc 04 00 00       	call   58e <printf>
  92:	83 c4 10             	add    $0x10,%esp

  int seconds = (total_ticks)/1000;
  95:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  98:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
  9d:	89 c8                	mov    %ecx,%eax
  9f:	f7 ea                	imul   %edx
  a1:	c1 fa 06             	sar    $0x6,%edx
  a4:	89 c8                	mov    %ecx,%eax
  a6:	c1 f8 1f             	sar    $0x1f,%eax
  a9:	29 c2                	sub    %eax,%edx
  ab:	89 d0                	mov    %edx,%eax
  ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
  int milliseconds = (total_ticks)%1000;
  b0:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  b3:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
  b8:	89 c8                	mov    %ecx,%eax
  ba:	f7 ea                	imul   %edx
  bc:	c1 fa 06             	sar    $0x6,%edx
  bf:	89 c8                	mov    %ecx,%eax
  c1:	c1 f8 1f             	sar    $0x1f,%eax
  c4:	29 c2                	sub    %eax,%edx
  c6:	89 d0                	mov    %edx,%eax
  c8:	69 c0 e8 03 00 00    	imul   $0x3e8,%eax,%eax
  ce:	29 c1                	sub    %eax,%ecx
  d0:	89 c8                	mov    %ecx,%eax
  d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)

  if(milliseconds < 10)
  d5:	83 7d e4 09          	cmpl   $0x9,-0x1c(%ebp)
  d9:	7f 17                	jg     f2 <main+0xf2>
    printf(1, "%d.00%d", seconds, milliseconds);
  db:	ff 75 e4             	pushl  -0x1c(%ebp)
  de:	ff 75 e8             	pushl  -0x18(%ebp)
  e1:	68 57 09 00 00       	push   $0x957
  e6:	6a 01                	push   $0x1
  e8:	e8 a1 04 00 00       	call   58e <printf>
  ed:	83 c4 10             	add    $0x10,%esp
  f0:	eb 32                	jmp    124 <main+0x124>
  else if(milliseconds < 100)
  f2:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
  f6:	7f 17                	jg     10f <main+0x10f>
    printf(1, "%d.0%d", seconds, milliseconds);
  f8:	ff 75 e4             	pushl  -0x1c(%ebp)
  fb:	ff 75 e8             	pushl  -0x18(%ebp)
  fe:	68 5f 09 00 00       	push   $0x95f
 103:	6a 01                	push   $0x1
 105:	e8 84 04 00 00       	call   58e <printf>
 10a:	83 c4 10             	add    $0x10,%esp
 10d:	eb 15                	jmp    124 <main+0x124>
  else
    printf(1, "%d.%d", seconds, milliseconds);
 10f:	ff 75 e4             	pushl  -0x1c(%ebp)
 112:	ff 75 e8             	pushl  -0x18(%ebp)
 115:	68 66 09 00 00       	push   $0x966
 11a:	6a 01                	push   $0x1
 11c:	e8 6d 04 00 00       	call   58e <printf>
 121:	83 c4 10             	add    $0x10,%esp

  printf(1, " seconds.\n");
 124:	83 ec 08             	sub    $0x8,%esp
 127:	68 6c 09 00 00       	push   $0x96c
 12c:	6a 01                	push   $0x1
 12e:	e8 5b 04 00 00       	call   58e <printf>
 133:	83 c4 10             	add    $0x10,%esp

  exit();
 136:	e8 9c 02 00 00       	call   3d7 <exit>

0000013b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 13b:	55                   	push   %ebp
 13c:	89 e5                	mov    %esp,%ebp
 13e:	57                   	push   %edi
 13f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 140:	8b 4d 08             	mov    0x8(%ebp),%ecx
 143:	8b 55 10             	mov    0x10(%ebp),%edx
 146:	8b 45 0c             	mov    0xc(%ebp),%eax
 149:	89 cb                	mov    %ecx,%ebx
 14b:	89 df                	mov    %ebx,%edi
 14d:	89 d1                	mov    %edx,%ecx
 14f:	fc                   	cld    
 150:	f3 aa                	rep stos %al,%es:(%edi)
 152:	89 ca                	mov    %ecx,%edx
 154:	89 fb                	mov    %edi,%ebx
 156:	89 5d 08             	mov    %ebx,0x8(%ebp)
 159:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 15c:	90                   	nop
 15d:	5b                   	pop    %ebx
 15e:	5f                   	pop    %edi
 15f:	5d                   	pop    %ebp
 160:	c3                   	ret    

00000161 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 161:	55                   	push   %ebp
 162:	89 e5                	mov    %esp,%ebp
 164:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 167:	8b 45 08             	mov    0x8(%ebp),%eax
 16a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 16d:	90                   	nop
 16e:	8b 45 08             	mov    0x8(%ebp),%eax
 171:	8d 50 01             	lea    0x1(%eax),%edx
 174:	89 55 08             	mov    %edx,0x8(%ebp)
 177:	8b 55 0c             	mov    0xc(%ebp),%edx
 17a:	8d 4a 01             	lea    0x1(%edx),%ecx
 17d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 180:	0f b6 12             	movzbl (%edx),%edx
 183:	88 10                	mov    %dl,(%eax)
 185:	0f b6 00             	movzbl (%eax),%eax
 188:	84 c0                	test   %al,%al
 18a:	75 e2                	jne    16e <strcpy+0xd>
    ;
  return os;
 18c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 18f:	c9                   	leave  
 190:	c3                   	ret    

00000191 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 191:	55                   	push   %ebp
 192:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 194:	eb 08                	jmp    19e <strcmp+0xd>
    p++, q++;
 196:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 19a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 19e:	8b 45 08             	mov    0x8(%ebp),%eax
 1a1:	0f b6 00             	movzbl (%eax),%eax
 1a4:	84 c0                	test   %al,%al
 1a6:	74 10                	je     1b8 <strcmp+0x27>
 1a8:	8b 45 08             	mov    0x8(%ebp),%eax
 1ab:	0f b6 10             	movzbl (%eax),%edx
 1ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b1:	0f b6 00             	movzbl (%eax),%eax
 1b4:	38 c2                	cmp    %al,%dl
 1b6:	74 de                	je     196 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1b8:	8b 45 08             	mov    0x8(%ebp),%eax
 1bb:	0f b6 00             	movzbl (%eax),%eax
 1be:	0f b6 d0             	movzbl %al,%edx
 1c1:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c4:	0f b6 00             	movzbl (%eax),%eax
 1c7:	0f b6 c0             	movzbl %al,%eax
 1ca:	29 c2                	sub    %eax,%edx
 1cc:	89 d0                	mov    %edx,%eax
}
 1ce:	5d                   	pop    %ebp
 1cf:	c3                   	ret    

000001d0 <strlen>:

uint
strlen(char *s)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1dd:	eb 04                	jmp    1e3 <strlen+0x13>
 1df:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1e3:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1e6:	8b 45 08             	mov    0x8(%ebp),%eax
 1e9:	01 d0                	add    %edx,%eax
 1eb:	0f b6 00             	movzbl (%eax),%eax
 1ee:	84 c0                	test   %al,%al
 1f0:	75 ed                	jne    1df <strlen+0xf>
    ;
  return n;
 1f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1f5:	c9                   	leave  
 1f6:	c3                   	ret    

000001f7 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1f7:	55                   	push   %ebp
 1f8:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1fa:	8b 45 10             	mov    0x10(%ebp),%eax
 1fd:	50                   	push   %eax
 1fe:	ff 75 0c             	pushl  0xc(%ebp)
 201:	ff 75 08             	pushl  0x8(%ebp)
 204:	e8 32 ff ff ff       	call   13b <stosb>
 209:	83 c4 0c             	add    $0xc,%esp
  return dst;
 20c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 20f:	c9                   	leave  
 210:	c3                   	ret    

00000211 <strchr>:

char*
strchr(const char *s, char c)
{
 211:	55                   	push   %ebp
 212:	89 e5                	mov    %esp,%ebp
 214:	83 ec 04             	sub    $0x4,%esp
 217:	8b 45 0c             	mov    0xc(%ebp),%eax
 21a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 21d:	eb 14                	jmp    233 <strchr+0x22>
    if(*s == c)
 21f:	8b 45 08             	mov    0x8(%ebp),%eax
 222:	0f b6 00             	movzbl (%eax),%eax
 225:	3a 45 fc             	cmp    -0x4(%ebp),%al
 228:	75 05                	jne    22f <strchr+0x1e>
      return (char*)s;
 22a:	8b 45 08             	mov    0x8(%ebp),%eax
 22d:	eb 13                	jmp    242 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 22f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 233:	8b 45 08             	mov    0x8(%ebp),%eax
 236:	0f b6 00             	movzbl (%eax),%eax
 239:	84 c0                	test   %al,%al
 23b:	75 e2                	jne    21f <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 23d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 242:	c9                   	leave  
 243:	c3                   	ret    

00000244 <gets>:

char*
gets(char *buf, int max)
{
 244:	55                   	push   %ebp
 245:	89 e5                	mov    %esp,%ebp
 247:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 24a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 251:	eb 42                	jmp    295 <gets+0x51>
    cc = read(0, &c, 1);
 253:	83 ec 04             	sub    $0x4,%esp
 256:	6a 01                	push   $0x1
 258:	8d 45 ef             	lea    -0x11(%ebp),%eax
 25b:	50                   	push   %eax
 25c:	6a 00                	push   $0x0
 25e:	e8 8c 01 00 00       	call   3ef <read>
 263:	83 c4 10             	add    $0x10,%esp
 266:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 269:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 26d:	7e 33                	jle    2a2 <gets+0x5e>
      break;
    buf[i++] = c;
 26f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 272:	8d 50 01             	lea    0x1(%eax),%edx
 275:	89 55 f4             	mov    %edx,-0xc(%ebp)
 278:	89 c2                	mov    %eax,%edx
 27a:	8b 45 08             	mov    0x8(%ebp),%eax
 27d:	01 c2                	add    %eax,%edx
 27f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 283:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 285:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 289:	3c 0a                	cmp    $0xa,%al
 28b:	74 16                	je     2a3 <gets+0x5f>
 28d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 291:	3c 0d                	cmp    $0xd,%al
 293:	74 0e                	je     2a3 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 295:	8b 45 f4             	mov    -0xc(%ebp),%eax
 298:	83 c0 01             	add    $0x1,%eax
 29b:	3b 45 0c             	cmp    0xc(%ebp),%eax
 29e:	7c b3                	jl     253 <gets+0xf>
 2a0:	eb 01                	jmp    2a3 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 2a2:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2a6:	8b 45 08             	mov    0x8(%ebp),%eax
 2a9:	01 d0                	add    %edx,%eax
 2ab:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2ae:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2b1:	c9                   	leave  
 2b2:	c3                   	ret    

000002b3 <stat>:

int
stat(char *n, struct stat *st)
{
 2b3:	55                   	push   %ebp
 2b4:	89 e5                	mov    %esp,%ebp
 2b6:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2b9:	83 ec 08             	sub    $0x8,%esp
 2bc:	6a 00                	push   $0x0
 2be:	ff 75 08             	pushl  0x8(%ebp)
 2c1:	e8 51 01 00 00       	call   417 <open>
 2c6:	83 c4 10             	add    $0x10,%esp
 2c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2d0:	79 07                	jns    2d9 <stat+0x26>
    return -1;
 2d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2d7:	eb 25                	jmp    2fe <stat+0x4b>
  r = fstat(fd, st);
 2d9:	83 ec 08             	sub    $0x8,%esp
 2dc:	ff 75 0c             	pushl  0xc(%ebp)
 2df:	ff 75 f4             	pushl  -0xc(%ebp)
 2e2:	e8 48 01 00 00       	call   42f <fstat>
 2e7:	83 c4 10             	add    $0x10,%esp
 2ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2ed:	83 ec 0c             	sub    $0xc,%esp
 2f0:	ff 75 f4             	pushl  -0xc(%ebp)
 2f3:	e8 07 01 00 00       	call   3ff <close>
 2f8:	83 c4 10             	add    $0x10,%esp
  return r;
 2fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2fe:	c9                   	leave  
 2ff:	c3                   	ret    

00000300 <atoi>:

int
atoi(const char *s)
{
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 306:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 30d:	eb 04                	jmp    313 <atoi+0x13>
 30f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 313:	8b 45 08             	mov    0x8(%ebp),%eax
 316:	0f b6 00             	movzbl (%eax),%eax
 319:	3c 20                	cmp    $0x20,%al
 31b:	74 f2                	je     30f <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 31d:	8b 45 08             	mov    0x8(%ebp),%eax
 320:	0f b6 00             	movzbl (%eax),%eax
 323:	3c 2d                	cmp    $0x2d,%al
 325:	75 07                	jne    32e <atoi+0x2e>
 327:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 32c:	eb 05                	jmp    333 <atoi+0x33>
 32e:	b8 01 00 00 00       	mov    $0x1,%eax
 333:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 336:	8b 45 08             	mov    0x8(%ebp),%eax
 339:	0f b6 00             	movzbl (%eax),%eax
 33c:	3c 2b                	cmp    $0x2b,%al
 33e:	74 0a                	je     34a <atoi+0x4a>
 340:	8b 45 08             	mov    0x8(%ebp),%eax
 343:	0f b6 00             	movzbl (%eax),%eax
 346:	3c 2d                	cmp    $0x2d,%al
 348:	75 2b                	jne    375 <atoi+0x75>
    s++;
 34a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 34e:	eb 25                	jmp    375 <atoi+0x75>
    n = n*10 + *s++ - '0';
 350:	8b 55 fc             	mov    -0x4(%ebp),%edx
 353:	89 d0                	mov    %edx,%eax
 355:	c1 e0 02             	shl    $0x2,%eax
 358:	01 d0                	add    %edx,%eax
 35a:	01 c0                	add    %eax,%eax
 35c:	89 c1                	mov    %eax,%ecx
 35e:	8b 45 08             	mov    0x8(%ebp),%eax
 361:	8d 50 01             	lea    0x1(%eax),%edx
 364:	89 55 08             	mov    %edx,0x8(%ebp)
 367:	0f b6 00             	movzbl (%eax),%eax
 36a:	0f be c0             	movsbl %al,%eax
 36d:	01 c8                	add    %ecx,%eax
 36f:	83 e8 30             	sub    $0x30,%eax
 372:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 375:	8b 45 08             	mov    0x8(%ebp),%eax
 378:	0f b6 00             	movzbl (%eax),%eax
 37b:	3c 2f                	cmp    $0x2f,%al
 37d:	7e 0a                	jle    389 <atoi+0x89>
 37f:	8b 45 08             	mov    0x8(%ebp),%eax
 382:	0f b6 00             	movzbl (%eax),%eax
 385:	3c 39                	cmp    $0x39,%al
 387:	7e c7                	jle    350 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 389:	8b 45 f8             	mov    -0x8(%ebp),%eax
 38c:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 390:	c9                   	leave  
 391:	c3                   	ret    

00000392 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 392:	55                   	push   %ebp
 393:	89 e5                	mov    %esp,%ebp
 395:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 398:	8b 45 08             	mov    0x8(%ebp),%eax
 39b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 39e:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3a4:	eb 17                	jmp    3bd <memmove+0x2b>
    *dst++ = *src++;
 3a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3a9:	8d 50 01             	lea    0x1(%eax),%edx
 3ac:	89 55 fc             	mov    %edx,-0x4(%ebp)
 3af:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3b2:	8d 4a 01             	lea    0x1(%edx),%ecx
 3b5:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 3b8:	0f b6 12             	movzbl (%edx),%edx
 3bb:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3bd:	8b 45 10             	mov    0x10(%ebp),%eax
 3c0:	8d 50 ff             	lea    -0x1(%eax),%edx
 3c3:	89 55 10             	mov    %edx,0x10(%ebp)
 3c6:	85 c0                	test   %eax,%eax
 3c8:	7f dc                	jg     3a6 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3ca:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3cd:	c9                   	leave  
 3ce:	c3                   	ret    

000003cf <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3cf:	b8 01 00 00 00       	mov    $0x1,%eax
 3d4:	cd 40                	int    $0x40
 3d6:	c3                   	ret    

000003d7 <exit>:
SYSCALL(exit)
 3d7:	b8 02 00 00 00       	mov    $0x2,%eax
 3dc:	cd 40                	int    $0x40
 3de:	c3                   	ret    

000003df <wait>:
SYSCALL(wait)
 3df:	b8 03 00 00 00       	mov    $0x3,%eax
 3e4:	cd 40                	int    $0x40
 3e6:	c3                   	ret    

000003e7 <pipe>:
SYSCALL(pipe)
 3e7:	b8 04 00 00 00       	mov    $0x4,%eax
 3ec:	cd 40                	int    $0x40
 3ee:	c3                   	ret    

000003ef <read>:
SYSCALL(read)
 3ef:	b8 05 00 00 00       	mov    $0x5,%eax
 3f4:	cd 40                	int    $0x40
 3f6:	c3                   	ret    

000003f7 <write>:
SYSCALL(write)
 3f7:	b8 10 00 00 00       	mov    $0x10,%eax
 3fc:	cd 40                	int    $0x40
 3fe:	c3                   	ret    

000003ff <close>:
SYSCALL(close)
 3ff:	b8 15 00 00 00       	mov    $0x15,%eax
 404:	cd 40                	int    $0x40
 406:	c3                   	ret    

00000407 <kill>:
SYSCALL(kill)
 407:	b8 06 00 00 00       	mov    $0x6,%eax
 40c:	cd 40                	int    $0x40
 40e:	c3                   	ret    

0000040f <exec>:
SYSCALL(exec)
 40f:	b8 07 00 00 00       	mov    $0x7,%eax
 414:	cd 40                	int    $0x40
 416:	c3                   	ret    

00000417 <open>:
SYSCALL(open)
 417:	b8 0f 00 00 00       	mov    $0xf,%eax
 41c:	cd 40                	int    $0x40
 41e:	c3                   	ret    

0000041f <mknod>:
SYSCALL(mknod)
 41f:	b8 11 00 00 00       	mov    $0x11,%eax
 424:	cd 40                	int    $0x40
 426:	c3                   	ret    

00000427 <unlink>:
SYSCALL(unlink)
 427:	b8 12 00 00 00       	mov    $0x12,%eax
 42c:	cd 40                	int    $0x40
 42e:	c3                   	ret    

0000042f <fstat>:
SYSCALL(fstat)
 42f:	b8 08 00 00 00       	mov    $0x8,%eax
 434:	cd 40                	int    $0x40
 436:	c3                   	ret    

00000437 <link>:
SYSCALL(link)
 437:	b8 13 00 00 00       	mov    $0x13,%eax
 43c:	cd 40                	int    $0x40
 43e:	c3                   	ret    

0000043f <mkdir>:
SYSCALL(mkdir)
 43f:	b8 14 00 00 00       	mov    $0x14,%eax
 444:	cd 40                	int    $0x40
 446:	c3                   	ret    

00000447 <chdir>:
SYSCALL(chdir)
 447:	b8 09 00 00 00       	mov    $0x9,%eax
 44c:	cd 40                	int    $0x40
 44e:	c3                   	ret    

0000044f <dup>:
SYSCALL(dup)
 44f:	b8 0a 00 00 00       	mov    $0xa,%eax
 454:	cd 40                	int    $0x40
 456:	c3                   	ret    

00000457 <getpid>:
SYSCALL(getpid)
 457:	b8 0b 00 00 00       	mov    $0xb,%eax
 45c:	cd 40                	int    $0x40
 45e:	c3                   	ret    

0000045f <sbrk>:
SYSCALL(sbrk)
 45f:	b8 0c 00 00 00       	mov    $0xc,%eax
 464:	cd 40                	int    $0x40
 466:	c3                   	ret    

00000467 <sleep>:
SYSCALL(sleep)
 467:	b8 0d 00 00 00       	mov    $0xd,%eax
 46c:	cd 40                	int    $0x40
 46e:	c3                   	ret    

0000046f <uptime>:
SYSCALL(uptime)
 46f:	b8 0e 00 00 00       	mov    $0xe,%eax
 474:	cd 40                	int    $0x40
 476:	c3                   	ret    

00000477 <halt>:
SYSCALL(halt)
 477:	b8 16 00 00 00       	mov    $0x16,%eax
 47c:	cd 40                	int    $0x40
 47e:	c3                   	ret    

0000047f <date>:
SYSCALL(date)
 47f:	b8 17 00 00 00       	mov    $0x17,%eax
 484:	cd 40                	int    $0x40
 486:	c3                   	ret    

00000487 <getuid>:
SYSCALL(getuid)
 487:	b8 18 00 00 00       	mov    $0x18,%eax
 48c:	cd 40                	int    $0x40
 48e:	c3                   	ret    

0000048f <getgid>:
SYSCALL(getgid)
 48f:	b8 19 00 00 00       	mov    $0x19,%eax
 494:	cd 40                	int    $0x40
 496:	c3                   	ret    

00000497 <getppid>:
SYSCALL(getppid)
 497:	b8 1a 00 00 00       	mov    $0x1a,%eax
 49c:	cd 40                	int    $0x40
 49e:	c3                   	ret    

0000049f <setuid>:
SYSCALL(setuid)
 49f:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4a4:	cd 40                	int    $0x40
 4a6:	c3                   	ret    

000004a7 <setgid>:
SYSCALL(setgid)
 4a7:	b8 1c 00 00 00       	mov    $0x1c,%eax
 4ac:	cd 40                	int    $0x40
 4ae:	c3                   	ret    

000004af <getprocs>:
SYSCALL(getprocs)
 4af:	b8 1d 00 00 00       	mov    $0x1d,%eax
 4b4:	cd 40                	int    $0x40
 4b6:	c3                   	ret    

000004b7 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4b7:	55                   	push   %ebp
 4b8:	89 e5                	mov    %esp,%ebp
 4ba:	83 ec 18             	sub    $0x18,%esp
 4bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 4c0:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4c3:	83 ec 04             	sub    $0x4,%esp
 4c6:	6a 01                	push   $0x1
 4c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4cb:	50                   	push   %eax
 4cc:	ff 75 08             	pushl  0x8(%ebp)
 4cf:	e8 23 ff ff ff       	call   3f7 <write>
 4d4:	83 c4 10             	add    $0x10,%esp
}
 4d7:	90                   	nop
 4d8:	c9                   	leave  
 4d9:	c3                   	ret    

000004da <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4da:	55                   	push   %ebp
 4db:	89 e5                	mov    %esp,%ebp
 4dd:	53                   	push   %ebx
 4de:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4e1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4e8:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4ec:	74 17                	je     505 <printint+0x2b>
 4ee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4f2:	79 11                	jns    505 <printint+0x2b>
    neg = 1;
 4f4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4fb:	8b 45 0c             	mov    0xc(%ebp),%eax
 4fe:	f7 d8                	neg    %eax
 500:	89 45 ec             	mov    %eax,-0x14(%ebp)
 503:	eb 06                	jmp    50b <printint+0x31>
  } else {
    x = xx;
 505:	8b 45 0c             	mov    0xc(%ebp),%eax
 508:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 50b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 512:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 515:	8d 41 01             	lea    0x1(%ecx),%eax
 518:	89 45 f4             	mov    %eax,-0xc(%ebp)
 51b:	8b 5d 10             	mov    0x10(%ebp),%ebx
 51e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 521:	ba 00 00 00 00       	mov    $0x0,%edx
 526:	f7 f3                	div    %ebx
 528:	89 d0                	mov    %edx,%eax
 52a:	0f b6 80 cc 0b 00 00 	movzbl 0xbcc(%eax),%eax
 531:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 535:	8b 5d 10             	mov    0x10(%ebp),%ebx
 538:	8b 45 ec             	mov    -0x14(%ebp),%eax
 53b:	ba 00 00 00 00       	mov    $0x0,%edx
 540:	f7 f3                	div    %ebx
 542:	89 45 ec             	mov    %eax,-0x14(%ebp)
 545:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 549:	75 c7                	jne    512 <printint+0x38>
  if(neg)
 54b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 54f:	74 2d                	je     57e <printint+0xa4>
    buf[i++] = '-';
 551:	8b 45 f4             	mov    -0xc(%ebp),%eax
 554:	8d 50 01             	lea    0x1(%eax),%edx
 557:	89 55 f4             	mov    %edx,-0xc(%ebp)
 55a:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 55f:	eb 1d                	jmp    57e <printint+0xa4>
    putc(fd, buf[i]);
 561:	8d 55 dc             	lea    -0x24(%ebp),%edx
 564:	8b 45 f4             	mov    -0xc(%ebp),%eax
 567:	01 d0                	add    %edx,%eax
 569:	0f b6 00             	movzbl (%eax),%eax
 56c:	0f be c0             	movsbl %al,%eax
 56f:	83 ec 08             	sub    $0x8,%esp
 572:	50                   	push   %eax
 573:	ff 75 08             	pushl  0x8(%ebp)
 576:	e8 3c ff ff ff       	call   4b7 <putc>
 57b:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 57e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 582:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 586:	79 d9                	jns    561 <printint+0x87>
    putc(fd, buf[i]);
}
 588:	90                   	nop
 589:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 58c:	c9                   	leave  
 58d:	c3                   	ret    

0000058e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 58e:	55                   	push   %ebp
 58f:	89 e5                	mov    %esp,%ebp
 591:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 594:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 59b:	8d 45 0c             	lea    0xc(%ebp),%eax
 59e:	83 c0 04             	add    $0x4,%eax
 5a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5a4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5ab:	e9 59 01 00 00       	jmp    709 <printf+0x17b>
    c = fmt[i] & 0xff;
 5b0:	8b 55 0c             	mov    0xc(%ebp),%edx
 5b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5b6:	01 d0                	add    %edx,%eax
 5b8:	0f b6 00             	movzbl (%eax),%eax
 5bb:	0f be c0             	movsbl %al,%eax
 5be:	25 ff 00 00 00       	and    $0xff,%eax
 5c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5c6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5ca:	75 2c                	jne    5f8 <printf+0x6a>
      if(c == '%'){
 5cc:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5d0:	75 0c                	jne    5de <printf+0x50>
        state = '%';
 5d2:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5d9:	e9 27 01 00 00       	jmp    705 <printf+0x177>
      } else {
        putc(fd, c);
 5de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5e1:	0f be c0             	movsbl %al,%eax
 5e4:	83 ec 08             	sub    $0x8,%esp
 5e7:	50                   	push   %eax
 5e8:	ff 75 08             	pushl  0x8(%ebp)
 5eb:	e8 c7 fe ff ff       	call   4b7 <putc>
 5f0:	83 c4 10             	add    $0x10,%esp
 5f3:	e9 0d 01 00 00       	jmp    705 <printf+0x177>
      }
    } else if(state == '%'){
 5f8:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5fc:	0f 85 03 01 00 00    	jne    705 <printf+0x177>
      if(c == 'd'){
 602:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 606:	75 1e                	jne    626 <printf+0x98>
        printint(fd, *ap, 10, 1);
 608:	8b 45 e8             	mov    -0x18(%ebp),%eax
 60b:	8b 00                	mov    (%eax),%eax
 60d:	6a 01                	push   $0x1
 60f:	6a 0a                	push   $0xa
 611:	50                   	push   %eax
 612:	ff 75 08             	pushl  0x8(%ebp)
 615:	e8 c0 fe ff ff       	call   4da <printint>
 61a:	83 c4 10             	add    $0x10,%esp
        ap++;
 61d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 621:	e9 d8 00 00 00       	jmp    6fe <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 626:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 62a:	74 06                	je     632 <printf+0xa4>
 62c:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 630:	75 1e                	jne    650 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 632:	8b 45 e8             	mov    -0x18(%ebp),%eax
 635:	8b 00                	mov    (%eax),%eax
 637:	6a 00                	push   $0x0
 639:	6a 10                	push   $0x10
 63b:	50                   	push   %eax
 63c:	ff 75 08             	pushl  0x8(%ebp)
 63f:	e8 96 fe ff ff       	call   4da <printint>
 644:	83 c4 10             	add    $0x10,%esp
        ap++;
 647:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 64b:	e9 ae 00 00 00       	jmp    6fe <printf+0x170>
      } else if(c == 's'){
 650:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 654:	75 43                	jne    699 <printf+0x10b>
        s = (char*)*ap;
 656:	8b 45 e8             	mov    -0x18(%ebp),%eax
 659:	8b 00                	mov    (%eax),%eax
 65b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 65e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 662:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 666:	75 25                	jne    68d <printf+0xff>
          s = "(null)";
 668:	c7 45 f4 77 09 00 00 	movl   $0x977,-0xc(%ebp)
        while(*s != 0){
 66f:	eb 1c                	jmp    68d <printf+0xff>
          putc(fd, *s);
 671:	8b 45 f4             	mov    -0xc(%ebp),%eax
 674:	0f b6 00             	movzbl (%eax),%eax
 677:	0f be c0             	movsbl %al,%eax
 67a:	83 ec 08             	sub    $0x8,%esp
 67d:	50                   	push   %eax
 67e:	ff 75 08             	pushl  0x8(%ebp)
 681:	e8 31 fe ff ff       	call   4b7 <putc>
 686:	83 c4 10             	add    $0x10,%esp
          s++;
 689:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 68d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 690:	0f b6 00             	movzbl (%eax),%eax
 693:	84 c0                	test   %al,%al
 695:	75 da                	jne    671 <printf+0xe3>
 697:	eb 65                	jmp    6fe <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 699:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 69d:	75 1d                	jne    6bc <printf+0x12e>
        putc(fd, *ap);
 69f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6a2:	8b 00                	mov    (%eax),%eax
 6a4:	0f be c0             	movsbl %al,%eax
 6a7:	83 ec 08             	sub    $0x8,%esp
 6aa:	50                   	push   %eax
 6ab:	ff 75 08             	pushl  0x8(%ebp)
 6ae:	e8 04 fe ff ff       	call   4b7 <putc>
 6b3:	83 c4 10             	add    $0x10,%esp
        ap++;
 6b6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6ba:	eb 42                	jmp    6fe <printf+0x170>
      } else if(c == '%'){
 6bc:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6c0:	75 17                	jne    6d9 <printf+0x14b>
        putc(fd, c);
 6c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6c5:	0f be c0             	movsbl %al,%eax
 6c8:	83 ec 08             	sub    $0x8,%esp
 6cb:	50                   	push   %eax
 6cc:	ff 75 08             	pushl  0x8(%ebp)
 6cf:	e8 e3 fd ff ff       	call   4b7 <putc>
 6d4:	83 c4 10             	add    $0x10,%esp
 6d7:	eb 25                	jmp    6fe <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6d9:	83 ec 08             	sub    $0x8,%esp
 6dc:	6a 25                	push   $0x25
 6de:	ff 75 08             	pushl  0x8(%ebp)
 6e1:	e8 d1 fd ff ff       	call   4b7 <putc>
 6e6:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6ec:	0f be c0             	movsbl %al,%eax
 6ef:	83 ec 08             	sub    $0x8,%esp
 6f2:	50                   	push   %eax
 6f3:	ff 75 08             	pushl  0x8(%ebp)
 6f6:	e8 bc fd ff ff       	call   4b7 <putc>
 6fb:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6fe:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 705:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 709:	8b 55 0c             	mov    0xc(%ebp),%edx
 70c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 70f:	01 d0                	add    %edx,%eax
 711:	0f b6 00             	movzbl (%eax),%eax
 714:	84 c0                	test   %al,%al
 716:	0f 85 94 fe ff ff    	jne    5b0 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 71c:	90                   	nop
 71d:	c9                   	leave  
 71e:	c3                   	ret    

0000071f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 71f:	55                   	push   %ebp
 720:	89 e5                	mov    %esp,%ebp
 722:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 725:	8b 45 08             	mov    0x8(%ebp),%eax
 728:	83 e8 08             	sub    $0x8,%eax
 72b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 72e:	a1 e8 0b 00 00       	mov    0xbe8,%eax
 733:	89 45 fc             	mov    %eax,-0x4(%ebp)
 736:	eb 24                	jmp    75c <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 738:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73b:	8b 00                	mov    (%eax),%eax
 73d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 740:	77 12                	ja     754 <free+0x35>
 742:	8b 45 f8             	mov    -0x8(%ebp),%eax
 745:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 748:	77 24                	ja     76e <free+0x4f>
 74a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74d:	8b 00                	mov    (%eax),%eax
 74f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 752:	77 1a                	ja     76e <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 754:	8b 45 fc             	mov    -0x4(%ebp),%eax
 757:	8b 00                	mov    (%eax),%eax
 759:	89 45 fc             	mov    %eax,-0x4(%ebp)
 75c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 762:	76 d4                	jbe    738 <free+0x19>
 764:	8b 45 fc             	mov    -0x4(%ebp),%eax
 767:	8b 00                	mov    (%eax),%eax
 769:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 76c:	76 ca                	jbe    738 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 76e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 771:	8b 40 04             	mov    0x4(%eax),%eax
 774:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 77b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77e:	01 c2                	add    %eax,%edx
 780:	8b 45 fc             	mov    -0x4(%ebp),%eax
 783:	8b 00                	mov    (%eax),%eax
 785:	39 c2                	cmp    %eax,%edx
 787:	75 24                	jne    7ad <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 789:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78c:	8b 50 04             	mov    0x4(%eax),%edx
 78f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 792:	8b 00                	mov    (%eax),%eax
 794:	8b 40 04             	mov    0x4(%eax),%eax
 797:	01 c2                	add    %eax,%edx
 799:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 79f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a2:	8b 00                	mov    (%eax),%eax
 7a4:	8b 10                	mov    (%eax),%edx
 7a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a9:	89 10                	mov    %edx,(%eax)
 7ab:	eb 0a                	jmp    7b7 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b0:	8b 10                	mov    (%eax),%edx
 7b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b5:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ba:	8b 40 04             	mov    0x4(%eax),%eax
 7bd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c7:	01 d0                	add    %edx,%eax
 7c9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7cc:	75 20                	jne    7ee <free+0xcf>
    p->s.size += bp->s.size;
 7ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d1:	8b 50 04             	mov    0x4(%eax),%edx
 7d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d7:	8b 40 04             	mov    0x4(%eax),%eax
 7da:	01 c2                	add    %eax,%edx
 7dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7df:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e5:	8b 10                	mov    (%eax),%edx
 7e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ea:	89 10                	mov    %edx,(%eax)
 7ec:	eb 08                	jmp    7f6 <free+0xd7>
  } else
    p->s.ptr = bp;
 7ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7f4:	89 10                	mov    %edx,(%eax)
  freep = p;
 7f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f9:	a3 e8 0b 00 00       	mov    %eax,0xbe8
}
 7fe:	90                   	nop
 7ff:	c9                   	leave  
 800:	c3                   	ret    

00000801 <morecore>:

static Header*
morecore(uint nu)
{
 801:	55                   	push   %ebp
 802:	89 e5                	mov    %esp,%ebp
 804:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 807:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 80e:	77 07                	ja     817 <morecore+0x16>
    nu = 4096;
 810:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 817:	8b 45 08             	mov    0x8(%ebp),%eax
 81a:	c1 e0 03             	shl    $0x3,%eax
 81d:	83 ec 0c             	sub    $0xc,%esp
 820:	50                   	push   %eax
 821:	e8 39 fc ff ff       	call   45f <sbrk>
 826:	83 c4 10             	add    $0x10,%esp
 829:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 82c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 830:	75 07                	jne    839 <morecore+0x38>
    return 0;
 832:	b8 00 00 00 00       	mov    $0x0,%eax
 837:	eb 26                	jmp    85f <morecore+0x5e>
  hp = (Header*)p;
 839:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 83f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 842:	8b 55 08             	mov    0x8(%ebp),%edx
 845:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 848:	8b 45 f0             	mov    -0x10(%ebp),%eax
 84b:	83 c0 08             	add    $0x8,%eax
 84e:	83 ec 0c             	sub    $0xc,%esp
 851:	50                   	push   %eax
 852:	e8 c8 fe ff ff       	call   71f <free>
 857:	83 c4 10             	add    $0x10,%esp
  return freep;
 85a:	a1 e8 0b 00 00       	mov    0xbe8,%eax
}
 85f:	c9                   	leave  
 860:	c3                   	ret    

00000861 <malloc>:

void*
malloc(uint nbytes)
{
 861:	55                   	push   %ebp
 862:	89 e5                	mov    %esp,%ebp
 864:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 867:	8b 45 08             	mov    0x8(%ebp),%eax
 86a:	83 c0 07             	add    $0x7,%eax
 86d:	c1 e8 03             	shr    $0x3,%eax
 870:	83 c0 01             	add    $0x1,%eax
 873:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 876:	a1 e8 0b 00 00       	mov    0xbe8,%eax
 87b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 87e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 882:	75 23                	jne    8a7 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 884:	c7 45 f0 e0 0b 00 00 	movl   $0xbe0,-0x10(%ebp)
 88b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 88e:	a3 e8 0b 00 00       	mov    %eax,0xbe8
 893:	a1 e8 0b 00 00       	mov    0xbe8,%eax
 898:	a3 e0 0b 00 00       	mov    %eax,0xbe0
    base.s.size = 0;
 89d:	c7 05 e4 0b 00 00 00 	movl   $0x0,0xbe4
 8a4:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8aa:	8b 00                	mov    (%eax),%eax
 8ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b2:	8b 40 04             	mov    0x4(%eax),%eax
 8b5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8b8:	72 4d                	jb     907 <malloc+0xa6>
      if(p->s.size == nunits)
 8ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bd:	8b 40 04             	mov    0x4(%eax),%eax
 8c0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8c3:	75 0c                	jne    8d1 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c8:	8b 10                	mov    (%eax),%edx
 8ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8cd:	89 10                	mov    %edx,(%eax)
 8cf:	eb 26                	jmp    8f7 <malloc+0x96>
      else {
        p->s.size -= nunits;
 8d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d4:	8b 40 04             	mov    0x4(%eax),%eax
 8d7:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8da:	89 c2                	mov    %eax,%edx
 8dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8df:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e5:	8b 40 04             	mov    0x4(%eax),%eax
 8e8:	c1 e0 03             	shl    $0x3,%eax
 8eb:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f1:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8f4:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8fa:	a3 e8 0b 00 00       	mov    %eax,0xbe8
      return (void*)(p + 1);
 8ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 902:	83 c0 08             	add    $0x8,%eax
 905:	eb 3b                	jmp    942 <malloc+0xe1>
    }
    if(p == freep)
 907:	a1 e8 0b 00 00       	mov    0xbe8,%eax
 90c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 90f:	75 1e                	jne    92f <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 911:	83 ec 0c             	sub    $0xc,%esp
 914:	ff 75 ec             	pushl  -0x14(%ebp)
 917:	e8 e5 fe ff ff       	call   801 <morecore>
 91c:	83 c4 10             	add    $0x10,%esp
 91f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 922:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 926:	75 07                	jne    92f <malloc+0xce>
        return 0;
 928:	b8 00 00 00 00       	mov    $0x0,%eax
 92d:	eb 13                	jmp    942 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 92f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 932:	89 45 f0             	mov    %eax,-0x10(%ebp)
 935:	8b 45 f4             	mov    -0xc(%ebp),%eax
 938:	8b 00                	mov    (%eax),%eax
 93a:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 93d:	e9 6d ff ff ff       	jmp    8af <malloc+0x4e>
}
 942:	c9                   	leave  
 943:	c3                   	ret    
