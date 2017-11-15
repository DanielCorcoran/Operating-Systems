
_testlists:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "user.h"

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 14             	sub    $0x14,%esp

  //for(int i = 0; i < 32; i++){
    int pid = fork();
  11:	e8 bc 02 00 00       	call   2d2 <fork>
  16:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if(pid == 0){
  19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1d:	75 15                	jne    34 <main+0x34>
      while(1){
        sleep(5000);
  1f:	83 ec 0c             	sub    $0xc,%esp
  22:	68 88 13 00 00       	push   $0x1388
  27:	e8 3e 03 00 00       	call   36a <sleep>
  2c:	83 c4 10             	add    $0x10,%esp
        exit();
  2f:	e8 a6 02 00 00       	call   2da <exit>
      }
    }
    wait();
  34:	e8 a9 02 00 00       	call   2e2 <wait>
  //}
  exit();
  39:	e8 9c 02 00 00       	call   2da <exit>

0000003e <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  3e:	55                   	push   %ebp
  3f:	89 e5                	mov    %esp,%ebp
  41:	57                   	push   %edi
  42:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  43:	8b 4d 08             	mov    0x8(%ebp),%ecx
  46:	8b 55 10             	mov    0x10(%ebp),%edx
  49:	8b 45 0c             	mov    0xc(%ebp),%eax
  4c:	89 cb                	mov    %ecx,%ebx
  4e:	89 df                	mov    %ebx,%edi
  50:	89 d1                	mov    %edx,%ecx
  52:	fc                   	cld    
  53:	f3 aa                	rep stos %al,%es:(%edi)
  55:	89 ca                	mov    %ecx,%edx
  57:	89 fb                	mov    %edi,%ebx
  59:	89 5d 08             	mov    %ebx,0x8(%ebp)
  5c:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  5f:	90                   	nop
  60:	5b                   	pop    %ebx
  61:	5f                   	pop    %edi
  62:	5d                   	pop    %ebp
  63:	c3                   	ret    

00000064 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  64:	55                   	push   %ebp
  65:	89 e5                	mov    %esp,%ebp
  67:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  6a:	8b 45 08             	mov    0x8(%ebp),%eax
  6d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  70:	90                   	nop
  71:	8b 45 08             	mov    0x8(%ebp),%eax
  74:	8d 50 01             	lea    0x1(%eax),%edx
  77:	89 55 08             	mov    %edx,0x8(%ebp)
  7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  7d:	8d 4a 01             	lea    0x1(%edx),%ecx
  80:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  83:	0f b6 12             	movzbl (%edx),%edx
  86:	88 10                	mov    %dl,(%eax)
  88:	0f b6 00             	movzbl (%eax),%eax
  8b:	84 c0                	test   %al,%al
  8d:	75 e2                	jne    71 <strcpy+0xd>
    ;
  return os;
  8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  92:	c9                   	leave  
  93:	c3                   	ret    

00000094 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  94:	55                   	push   %ebp
  95:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  97:	eb 08                	jmp    a1 <strcmp+0xd>
    p++, q++;
  99:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  9d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  a1:	8b 45 08             	mov    0x8(%ebp),%eax
  a4:	0f b6 00             	movzbl (%eax),%eax
  a7:	84 c0                	test   %al,%al
  a9:	74 10                	je     bb <strcmp+0x27>
  ab:	8b 45 08             	mov    0x8(%ebp),%eax
  ae:	0f b6 10             	movzbl (%eax),%edx
  b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  b4:	0f b6 00             	movzbl (%eax),%eax
  b7:	38 c2                	cmp    %al,%dl
  b9:	74 de                	je     99 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  bb:	8b 45 08             	mov    0x8(%ebp),%eax
  be:	0f b6 00             	movzbl (%eax),%eax
  c1:	0f b6 d0             	movzbl %al,%edx
  c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  c7:	0f b6 00             	movzbl (%eax),%eax
  ca:	0f b6 c0             	movzbl %al,%eax
  cd:	29 c2                	sub    %eax,%edx
  cf:	89 d0                	mov    %edx,%eax
}
  d1:	5d                   	pop    %ebp
  d2:	c3                   	ret    

000000d3 <strlen>:

uint
strlen(char *s)
{
  d3:	55                   	push   %ebp
  d4:	89 e5                	mov    %esp,%ebp
  d6:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  e0:	eb 04                	jmp    e6 <strlen+0x13>
  e2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  e9:	8b 45 08             	mov    0x8(%ebp),%eax
  ec:	01 d0                	add    %edx,%eax
  ee:	0f b6 00             	movzbl (%eax),%eax
  f1:	84 c0                	test   %al,%al
  f3:	75 ed                	jne    e2 <strlen+0xf>
    ;
  return n;
  f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  f8:	c9                   	leave  
  f9:	c3                   	ret    

000000fa <memset>:

void*
memset(void *dst, int c, uint n)
{
  fa:	55                   	push   %ebp
  fb:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  fd:	8b 45 10             	mov    0x10(%ebp),%eax
 100:	50                   	push   %eax
 101:	ff 75 0c             	pushl  0xc(%ebp)
 104:	ff 75 08             	pushl  0x8(%ebp)
 107:	e8 32 ff ff ff       	call   3e <stosb>
 10c:	83 c4 0c             	add    $0xc,%esp
  return dst;
 10f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 112:	c9                   	leave  
 113:	c3                   	ret    

00000114 <strchr>:

char*
strchr(const char *s, char c)
{
 114:	55                   	push   %ebp
 115:	89 e5                	mov    %esp,%ebp
 117:	83 ec 04             	sub    $0x4,%esp
 11a:	8b 45 0c             	mov    0xc(%ebp),%eax
 11d:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 120:	eb 14                	jmp    136 <strchr+0x22>
    if(*s == c)
 122:	8b 45 08             	mov    0x8(%ebp),%eax
 125:	0f b6 00             	movzbl (%eax),%eax
 128:	3a 45 fc             	cmp    -0x4(%ebp),%al
 12b:	75 05                	jne    132 <strchr+0x1e>
      return (char*)s;
 12d:	8b 45 08             	mov    0x8(%ebp),%eax
 130:	eb 13                	jmp    145 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 132:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 136:	8b 45 08             	mov    0x8(%ebp),%eax
 139:	0f b6 00             	movzbl (%eax),%eax
 13c:	84 c0                	test   %al,%al
 13e:	75 e2                	jne    122 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 140:	b8 00 00 00 00       	mov    $0x0,%eax
}
 145:	c9                   	leave  
 146:	c3                   	ret    

00000147 <gets>:

char*
gets(char *buf, int max)
{
 147:	55                   	push   %ebp
 148:	89 e5                	mov    %esp,%ebp
 14a:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 14d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 154:	eb 42                	jmp    198 <gets+0x51>
    cc = read(0, &c, 1);
 156:	83 ec 04             	sub    $0x4,%esp
 159:	6a 01                	push   $0x1
 15b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 15e:	50                   	push   %eax
 15f:	6a 00                	push   $0x0
 161:	e8 8c 01 00 00       	call   2f2 <read>
 166:	83 c4 10             	add    $0x10,%esp
 169:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 16c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 170:	7e 33                	jle    1a5 <gets+0x5e>
      break;
    buf[i++] = c;
 172:	8b 45 f4             	mov    -0xc(%ebp),%eax
 175:	8d 50 01             	lea    0x1(%eax),%edx
 178:	89 55 f4             	mov    %edx,-0xc(%ebp)
 17b:	89 c2                	mov    %eax,%edx
 17d:	8b 45 08             	mov    0x8(%ebp),%eax
 180:	01 c2                	add    %eax,%edx
 182:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 186:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 188:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 18c:	3c 0a                	cmp    $0xa,%al
 18e:	74 16                	je     1a6 <gets+0x5f>
 190:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 194:	3c 0d                	cmp    $0xd,%al
 196:	74 0e                	je     1a6 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 198:	8b 45 f4             	mov    -0xc(%ebp),%eax
 19b:	83 c0 01             	add    $0x1,%eax
 19e:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1a1:	7c b3                	jl     156 <gets+0xf>
 1a3:	eb 01                	jmp    1a6 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1a5:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1a9:	8b 45 08             	mov    0x8(%ebp),%eax
 1ac:	01 d0                	add    %edx,%eax
 1ae:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1b1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1b4:	c9                   	leave  
 1b5:	c3                   	ret    

000001b6 <stat>:

int
stat(char *n, struct stat *st)
{
 1b6:	55                   	push   %ebp
 1b7:	89 e5                	mov    %esp,%ebp
 1b9:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1bc:	83 ec 08             	sub    $0x8,%esp
 1bf:	6a 00                	push   $0x0
 1c1:	ff 75 08             	pushl  0x8(%ebp)
 1c4:	e8 51 01 00 00       	call   31a <open>
 1c9:	83 c4 10             	add    $0x10,%esp
 1cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1d3:	79 07                	jns    1dc <stat+0x26>
    return -1;
 1d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1da:	eb 25                	jmp    201 <stat+0x4b>
  r = fstat(fd, st);
 1dc:	83 ec 08             	sub    $0x8,%esp
 1df:	ff 75 0c             	pushl  0xc(%ebp)
 1e2:	ff 75 f4             	pushl  -0xc(%ebp)
 1e5:	e8 48 01 00 00       	call   332 <fstat>
 1ea:	83 c4 10             	add    $0x10,%esp
 1ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1f0:	83 ec 0c             	sub    $0xc,%esp
 1f3:	ff 75 f4             	pushl  -0xc(%ebp)
 1f6:	e8 07 01 00 00       	call   302 <close>
 1fb:	83 c4 10             	add    $0x10,%esp
  return r;
 1fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 201:	c9                   	leave  
 202:	c3                   	ret    

00000203 <atoi>:

int
atoi(const char *s)
{
 203:	55                   	push   %ebp
 204:	89 e5                	mov    %esp,%ebp
 206:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 209:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 210:	eb 04                	jmp    216 <atoi+0x13>
 212:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 216:	8b 45 08             	mov    0x8(%ebp),%eax
 219:	0f b6 00             	movzbl (%eax),%eax
 21c:	3c 20                	cmp    $0x20,%al
 21e:	74 f2                	je     212 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 220:	8b 45 08             	mov    0x8(%ebp),%eax
 223:	0f b6 00             	movzbl (%eax),%eax
 226:	3c 2d                	cmp    $0x2d,%al
 228:	75 07                	jne    231 <atoi+0x2e>
 22a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 22f:	eb 05                	jmp    236 <atoi+0x33>
 231:	b8 01 00 00 00       	mov    $0x1,%eax
 236:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 239:	8b 45 08             	mov    0x8(%ebp),%eax
 23c:	0f b6 00             	movzbl (%eax),%eax
 23f:	3c 2b                	cmp    $0x2b,%al
 241:	74 0a                	je     24d <atoi+0x4a>
 243:	8b 45 08             	mov    0x8(%ebp),%eax
 246:	0f b6 00             	movzbl (%eax),%eax
 249:	3c 2d                	cmp    $0x2d,%al
 24b:	75 2b                	jne    278 <atoi+0x75>
    s++;
 24d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 251:	eb 25                	jmp    278 <atoi+0x75>
    n = n*10 + *s++ - '0';
 253:	8b 55 fc             	mov    -0x4(%ebp),%edx
 256:	89 d0                	mov    %edx,%eax
 258:	c1 e0 02             	shl    $0x2,%eax
 25b:	01 d0                	add    %edx,%eax
 25d:	01 c0                	add    %eax,%eax
 25f:	89 c1                	mov    %eax,%ecx
 261:	8b 45 08             	mov    0x8(%ebp),%eax
 264:	8d 50 01             	lea    0x1(%eax),%edx
 267:	89 55 08             	mov    %edx,0x8(%ebp)
 26a:	0f b6 00             	movzbl (%eax),%eax
 26d:	0f be c0             	movsbl %al,%eax
 270:	01 c8                	add    %ecx,%eax
 272:	83 e8 30             	sub    $0x30,%eax
 275:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 278:	8b 45 08             	mov    0x8(%ebp),%eax
 27b:	0f b6 00             	movzbl (%eax),%eax
 27e:	3c 2f                	cmp    $0x2f,%al
 280:	7e 0a                	jle    28c <atoi+0x89>
 282:	8b 45 08             	mov    0x8(%ebp),%eax
 285:	0f b6 00             	movzbl (%eax),%eax
 288:	3c 39                	cmp    $0x39,%al
 28a:	7e c7                	jle    253 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 28c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 28f:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 293:	c9                   	leave  
 294:	c3                   	ret    

00000295 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 295:	55                   	push   %ebp
 296:	89 e5                	mov    %esp,%ebp
 298:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 29b:	8b 45 08             	mov    0x8(%ebp),%eax
 29e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2a1:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2a7:	eb 17                	jmp    2c0 <memmove+0x2b>
    *dst++ = *src++;
 2a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2ac:	8d 50 01             	lea    0x1(%eax),%edx
 2af:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2b2:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2b5:	8d 4a 01             	lea    0x1(%edx),%ecx
 2b8:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2bb:	0f b6 12             	movzbl (%edx),%edx
 2be:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2c0:	8b 45 10             	mov    0x10(%ebp),%eax
 2c3:	8d 50 ff             	lea    -0x1(%eax),%edx
 2c6:	89 55 10             	mov    %edx,0x10(%ebp)
 2c9:	85 c0                	test   %eax,%eax
 2cb:	7f dc                	jg     2a9 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2cd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2d0:	c9                   	leave  
 2d1:	c3                   	ret    

000002d2 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2d2:	b8 01 00 00 00       	mov    $0x1,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <exit>:
SYSCALL(exit)
 2da:	b8 02 00 00 00       	mov    $0x2,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <wait>:
SYSCALL(wait)
 2e2:	b8 03 00 00 00       	mov    $0x3,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <pipe>:
SYSCALL(pipe)
 2ea:	b8 04 00 00 00       	mov    $0x4,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <read>:
SYSCALL(read)
 2f2:	b8 05 00 00 00       	mov    $0x5,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <write>:
SYSCALL(write)
 2fa:	b8 10 00 00 00       	mov    $0x10,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <close>:
SYSCALL(close)
 302:	b8 15 00 00 00       	mov    $0x15,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <kill>:
SYSCALL(kill)
 30a:	b8 06 00 00 00       	mov    $0x6,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <exec>:
SYSCALL(exec)
 312:	b8 07 00 00 00       	mov    $0x7,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <open>:
SYSCALL(open)
 31a:	b8 0f 00 00 00       	mov    $0xf,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <mknod>:
SYSCALL(mknod)
 322:	b8 11 00 00 00       	mov    $0x11,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <unlink>:
SYSCALL(unlink)
 32a:	b8 12 00 00 00       	mov    $0x12,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <fstat>:
SYSCALL(fstat)
 332:	b8 08 00 00 00       	mov    $0x8,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <link>:
SYSCALL(link)
 33a:	b8 13 00 00 00       	mov    $0x13,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <mkdir>:
SYSCALL(mkdir)
 342:	b8 14 00 00 00       	mov    $0x14,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <chdir>:
SYSCALL(chdir)
 34a:	b8 09 00 00 00       	mov    $0x9,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <dup>:
SYSCALL(dup)
 352:	b8 0a 00 00 00       	mov    $0xa,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <getpid>:
SYSCALL(getpid)
 35a:	b8 0b 00 00 00       	mov    $0xb,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <sbrk>:
SYSCALL(sbrk)
 362:	b8 0c 00 00 00       	mov    $0xc,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <sleep>:
SYSCALL(sleep)
 36a:	b8 0d 00 00 00       	mov    $0xd,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <uptime>:
SYSCALL(uptime)
 372:	b8 0e 00 00 00       	mov    $0xe,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <halt>:
SYSCALL(halt)
 37a:	b8 16 00 00 00       	mov    $0x16,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <date>:
SYSCALL(date)
 382:	b8 17 00 00 00       	mov    $0x17,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <getuid>:
SYSCALL(getuid)
 38a:	b8 18 00 00 00       	mov    $0x18,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <getgid>:
SYSCALL(getgid)
 392:	b8 19 00 00 00       	mov    $0x19,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <getppid>:
SYSCALL(getppid)
 39a:	b8 1a 00 00 00       	mov    $0x1a,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <setuid>:
SYSCALL(setuid)
 3a2:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <setgid>:
SYSCALL(setgid)
 3aa:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <getprocs>:
SYSCALL(getprocs)
 3b2:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <setpriority>:
SYSCALL(setpriority)
 3ba:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3c2:	55                   	push   %ebp
 3c3:	89 e5                	mov    %esp,%ebp
 3c5:	83 ec 18             	sub    $0x18,%esp
 3c8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cb:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3ce:	83 ec 04             	sub    $0x4,%esp
 3d1:	6a 01                	push   $0x1
 3d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3d6:	50                   	push   %eax
 3d7:	ff 75 08             	pushl  0x8(%ebp)
 3da:	e8 1b ff ff ff       	call   2fa <write>
 3df:	83 c4 10             	add    $0x10,%esp
}
 3e2:	90                   	nop
 3e3:	c9                   	leave  
 3e4:	c3                   	ret    

000003e5 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3e5:	55                   	push   %ebp
 3e6:	89 e5                	mov    %esp,%ebp
 3e8:	53                   	push   %ebx
 3e9:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3ec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3f3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3f7:	74 17                	je     410 <printint+0x2b>
 3f9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3fd:	79 11                	jns    410 <printint+0x2b>
    neg = 1;
 3ff:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 406:	8b 45 0c             	mov    0xc(%ebp),%eax
 409:	f7 d8                	neg    %eax
 40b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 40e:	eb 06                	jmp    416 <printint+0x31>
  } else {
    x = xx;
 410:	8b 45 0c             	mov    0xc(%ebp),%eax
 413:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 416:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 41d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 420:	8d 41 01             	lea    0x1(%ecx),%eax
 423:	89 45 f4             	mov    %eax,-0xc(%ebp)
 426:	8b 5d 10             	mov    0x10(%ebp),%ebx
 429:	8b 45 ec             	mov    -0x14(%ebp),%eax
 42c:	ba 00 00 00 00       	mov    $0x0,%edx
 431:	f7 f3                	div    %ebx
 433:	89 d0                	mov    %edx,%eax
 435:	0f b6 80 a0 0a 00 00 	movzbl 0xaa0(%eax),%eax
 43c:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 440:	8b 5d 10             	mov    0x10(%ebp),%ebx
 443:	8b 45 ec             	mov    -0x14(%ebp),%eax
 446:	ba 00 00 00 00       	mov    $0x0,%edx
 44b:	f7 f3                	div    %ebx
 44d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 450:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 454:	75 c7                	jne    41d <printint+0x38>
  if(neg)
 456:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 45a:	74 2d                	je     489 <printint+0xa4>
    buf[i++] = '-';
 45c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 45f:	8d 50 01             	lea    0x1(%eax),%edx
 462:	89 55 f4             	mov    %edx,-0xc(%ebp)
 465:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 46a:	eb 1d                	jmp    489 <printint+0xa4>
    putc(fd, buf[i]);
 46c:	8d 55 dc             	lea    -0x24(%ebp),%edx
 46f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 472:	01 d0                	add    %edx,%eax
 474:	0f b6 00             	movzbl (%eax),%eax
 477:	0f be c0             	movsbl %al,%eax
 47a:	83 ec 08             	sub    $0x8,%esp
 47d:	50                   	push   %eax
 47e:	ff 75 08             	pushl  0x8(%ebp)
 481:	e8 3c ff ff ff       	call   3c2 <putc>
 486:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 489:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 48d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 491:	79 d9                	jns    46c <printint+0x87>
    putc(fd, buf[i]);
}
 493:	90                   	nop
 494:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 497:	c9                   	leave  
 498:	c3                   	ret    

00000499 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 499:	55                   	push   %ebp
 49a:	89 e5                	mov    %esp,%ebp
 49c:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 49f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4a6:	8d 45 0c             	lea    0xc(%ebp),%eax
 4a9:	83 c0 04             	add    $0x4,%eax
 4ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4b6:	e9 59 01 00 00       	jmp    614 <printf+0x17b>
    c = fmt[i] & 0xff;
 4bb:	8b 55 0c             	mov    0xc(%ebp),%edx
 4be:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4c1:	01 d0                	add    %edx,%eax
 4c3:	0f b6 00             	movzbl (%eax),%eax
 4c6:	0f be c0             	movsbl %al,%eax
 4c9:	25 ff 00 00 00       	and    $0xff,%eax
 4ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4d5:	75 2c                	jne    503 <printf+0x6a>
      if(c == '%'){
 4d7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4db:	75 0c                	jne    4e9 <printf+0x50>
        state = '%';
 4dd:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4e4:	e9 27 01 00 00       	jmp    610 <printf+0x177>
      } else {
        putc(fd, c);
 4e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4ec:	0f be c0             	movsbl %al,%eax
 4ef:	83 ec 08             	sub    $0x8,%esp
 4f2:	50                   	push   %eax
 4f3:	ff 75 08             	pushl  0x8(%ebp)
 4f6:	e8 c7 fe ff ff       	call   3c2 <putc>
 4fb:	83 c4 10             	add    $0x10,%esp
 4fe:	e9 0d 01 00 00       	jmp    610 <printf+0x177>
      }
    } else if(state == '%'){
 503:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 507:	0f 85 03 01 00 00    	jne    610 <printf+0x177>
      if(c == 'd'){
 50d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 511:	75 1e                	jne    531 <printf+0x98>
        printint(fd, *ap, 10, 1);
 513:	8b 45 e8             	mov    -0x18(%ebp),%eax
 516:	8b 00                	mov    (%eax),%eax
 518:	6a 01                	push   $0x1
 51a:	6a 0a                	push   $0xa
 51c:	50                   	push   %eax
 51d:	ff 75 08             	pushl  0x8(%ebp)
 520:	e8 c0 fe ff ff       	call   3e5 <printint>
 525:	83 c4 10             	add    $0x10,%esp
        ap++;
 528:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 52c:	e9 d8 00 00 00       	jmp    609 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 531:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 535:	74 06                	je     53d <printf+0xa4>
 537:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 53b:	75 1e                	jne    55b <printf+0xc2>
        printint(fd, *ap, 16, 0);
 53d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 540:	8b 00                	mov    (%eax),%eax
 542:	6a 00                	push   $0x0
 544:	6a 10                	push   $0x10
 546:	50                   	push   %eax
 547:	ff 75 08             	pushl  0x8(%ebp)
 54a:	e8 96 fe ff ff       	call   3e5 <printint>
 54f:	83 c4 10             	add    $0x10,%esp
        ap++;
 552:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 556:	e9 ae 00 00 00       	jmp    609 <printf+0x170>
      } else if(c == 's'){
 55b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 55f:	75 43                	jne    5a4 <printf+0x10b>
        s = (char*)*ap;
 561:	8b 45 e8             	mov    -0x18(%ebp),%eax
 564:	8b 00                	mov    (%eax),%eax
 566:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 569:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 56d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 571:	75 25                	jne    598 <printf+0xff>
          s = "(null)";
 573:	c7 45 f4 4f 08 00 00 	movl   $0x84f,-0xc(%ebp)
        while(*s != 0){
 57a:	eb 1c                	jmp    598 <printf+0xff>
          putc(fd, *s);
 57c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 57f:	0f b6 00             	movzbl (%eax),%eax
 582:	0f be c0             	movsbl %al,%eax
 585:	83 ec 08             	sub    $0x8,%esp
 588:	50                   	push   %eax
 589:	ff 75 08             	pushl  0x8(%ebp)
 58c:	e8 31 fe ff ff       	call   3c2 <putc>
 591:	83 c4 10             	add    $0x10,%esp
          s++;
 594:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 598:	8b 45 f4             	mov    -0xc(%ebp),%eax
 59b:	0f b6 00             	movzbl (%eax),%eax
 59e:	84 c0                	test   %al,%al
 5a0:	75 da                	jne    57c <printf+0xe3>
 5a2:	eb 65                	jmp    609 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5a4:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5a8:	75 1d                	jne    5c7 <printf+0x12e>
        putc(fd, *ap);
 5aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ad:	8b 00                	mov    (%eax),%eax
 5af:	0f be c0             	movsbl %al,%eax
 5b2:	83 ec 08             	sub    $0x8,%esp
 5b5:	50                   	push   %eax
 5b6:	ff 75 08             	pushl  0x8(%ebp)
 5b9:	e8 04 fe ff ff       	call   3c2 <putc>
 5be:	83 c4 10             	add    $0x10,%esp
        ap++;
 5c1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5c5:	eb 42                	jmp    609 <printf+0x170>
      } else if(c == '%'){
 5c7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5cb:	75 17                	jne    5e4 <printf+0x14b>
        putc(fd, c);
 5cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d0:	0f be c0             	movsbl %al,%eax
 5d3:	83 ec 08             	sub    $0x8,%esp
 5d6:	50                   	push   %eax
 5d7:	ff 75 08             	pushl  0x8(%ebp)
 5da:	e8 e3 fd ff ff       	call   3c2 <putc>
 5df:	83 c4 10             	add    $0x10,%esp
 5e2:	eb 25                	jmp    609 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5e4:	83 ec 08             	sub    $0x8,%esp
 5e7:	6a 25                	push   $0x25
 5e9:	ff 75 08             	pushl  0x8(%ebp)
 5ec:	e8 d1 fd ff ff       	call   3c2 <putc>
 5f1:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5f7:	0f be c0             	movsbl %al,%eax
 5fa:	83 ec 08             	sub    $0x8,%esp
 5fd:	50                   	push   %eax
 5fe:	ff 75 08             	pushl  0x8(%ebp)
 601:	e8 bc fd ff ff       	call   3c2 <putc>
 606:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 609:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 610:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 614:	8b 55 0c             	mov    0xc(%ebp),%edx
 617:	8b 45 f0             	mov    -0x10(%ebp),%eax
 61a:	01 d0                	add    %edx,%eax
 61c:	0f b6 00             	movzbl (%eax),%eax
 61f:	84 c0                	test   %al,%al
 621:	0f 85 94 fe ff ff    	jne    4bb <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 627:	90                   	nop
 628:	c9                   	leave  
 629:	c3                   	ret    

0000062a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 62a:	55                   	push   %ebp
 62b:	89 e5                	mov    %esp,%ebp
 62d:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 630:	8b 45 08             	mov    0x8(%ebp),%eax
 633:	83 e8 08             	sub    $0x8,%eax
 636:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 639:	a1 bc 0a 00 00       	mov    0xabc,%eax
 63e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 641:	eb 24                	jmp    667 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 643:	8b 45 fc             	mov    -0x4(%ebp),%eax
 646:	8b 00                	mov    (%eax),%eax
 648:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 64b:	77 12                	ja     65f <free+0x35>
 64d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 650:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 653:	77 24                	ja     679 <free+0x4f>
 655:	8b 45 fc             	mov    -0x4(%ebp),%eax
 658:	8b 00                	mov    (%eax),%eax
 65a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 65d:	77 1a                	ja     679 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 65f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 662:	8b 00                	mov    (%eax),%eax
 664:	89 45 fc             	mov    %eax,-0x4(%ebp)
 667:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 66d:	76 d4                	jbe    643 <free+0x19>
 66f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 672:	8b 00                	mov    (%eax),%eax
 674:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 677:	76 ca                	jbe    643 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 679:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67c:	8b 40 04             	mov    0x4(%eax),%eax
 67f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 686:	8b 45 f8             	mov    -0x8(%ebp),%eax
 689:	01 c2                	add    %eax,%edx
 68b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68e:	8b 00                	mov    (%eax),%eax
 690:	39 c2                	cmp    %eax,%edx
 692:	75 24                	jne    6b8 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 694:	8b 45 f8             	mov    -0x8(%ebp),%eax
 697:	8b 50 04             	mov    0x4(%eax),%edx
 69a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69d:	8b 00                	mov    (%eax),%eax
 69f:	8b 40 04             	mov    0x4(%eax),%eax
 6a2:	01 c2                	add    %eax,%edx
 6a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a7:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ad:	8b 00                	mov    (%eax),%eax
 6af:	8b 10                	mov    (%eax),%edx
 6b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b4:	89 10                	mov    %edx,(%eax)
 6b6:	eb 0a                	jmp    6c2 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bb:	8b 10                	mov    (%eax),%edx
 6bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c0:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c5:	8b 40 04             	mov    0x4(%eax),%eax
 6c8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d2:	01 d0                	add    %edx,%eax
 6d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6d7:	75 20                	jne    6f9 <free+0xcf>
    p->s.size += bp->s.size;
 6d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6dc:	8b 50 04             	mov    0x4(%eax),%edx
 6df:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e2:	8b 40 04             	mov    0x4(%eax),%eax
 6e5:	01 c2                	add    %eax,%edx
 6e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ea:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f0:	8b 10                	mov    (%eax),%edx
 6f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f5:	89 10                	mov    %edx,(%eax)
 6f7:	eb 08                	jmp    701 <free+0xd7>
  } else
    p->s.ptr = bp;
 6f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fc:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6ff:	89 10                	mov    %edx,(%eax)
  freep = p;
 701:	8b 45 fc             	mov    -0x4(%ebp),%eax
 704:	a3 bc 0a 00 00       	mov    %eax,0xabc
}
 709:	90                   	nop
 70a:	c9                   	leave  
 70b:	c3                   	ret    

0000070c <morecore>:

static Header*
morecore(uint nu)
{
 70c:	55                   	push   %ebp
 70d:	89 e5                	mov    %esp,%ebp
 70f:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 712:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 719:	77 07                	ja     722 <morecore+0x16>
    nu = 4096;
 71b:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 722:	8b 45 08             	mov    0x8(%ebp),%eax
 725:	c1 e0 03             	shl    $0x3,%eax
 728:	83 ec 0c             	sub    $0xc,%esp
 72b:	50                   	push   %eax
 72c:	e8 31 fc ff ff       	call   362 <sbrk>
 731:	83 c4 10             	add    $0x10,%esp
 734:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 737:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 73b:	75 07                	jne    744 <morecore+0x38>
    return 0;
 73d:	b8 00 00 00 00       	mov    $0x0,%eax
 742:	eb 26                	jmp    76a <morecore+0x5e>
  hp = (Header*)p;
 744:	8b 45 f4             	mov    -0xc(%ebp),%eax
 747:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 74a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 74d:	8b 55 08             	mov    0x8(%ebp),%edx
 750:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 753:	8b 45 f0             	mov    -0x10(%ebp),%eax
 756:	83 c0 08             	add    $0x8,%eax
 759:	83 ec 0c             	sub    $0xc,%esp
 75c:	50                   	push   %eax
 75d:	e8 c8 fe ff ff       	call   62a <free>
 762:	83 c4 10             	add    $0x10,%esp
  return freep;
 765:	a1 bc 0a 00 00       	mov    0xabc,%eax
}
 76a:	c9                   	leave  
 76b:	c3                   	ret    

0000076c <malloc>:

void*
malloc(uint nbytes)
{
 76c:	55                   	push   %ebp
 76d:	89 e5                	mov    %esp,%ebp
 76f:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 772:	8b 45 08             	mov    0x8(%ebp),%eax
 775:	83 c0 07             	add    $0x7,%eax
 778:	c1 e8 03             	shr    $0x3,%eax
 77b:	83 c0 01             	add    $0x1,%eax
 77e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 781:	a1 bc 0a 00 00       	mov    0xabc,%eax
 786:	89 45 f0             	mov    %eax,-0x10(%ebp)
 789:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 78d:	75 23                	jne    7b2 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 78f:	c7 45 f0 b4 0a 00 00 	movl   $0xab4,-0x10(%ebp)
 796:	8b 45 f0             	mov    -0x10(%ebp),%eax
 799:	a3 bc 0a 00 00       	mov    %eax,0xabc
 79e:	a1 bc 0a 00 00       	mov    0xabc,%eax
 7a3:	a3 b4 0a 00 00       	mov    %eax,0xab4
    base.s.size = 0;
 7a8:	c7 05 b8 0a 00 00 00 	movl   $0x0,0xab8
 7af:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b5:	8b 00                	mov    (%eax),%eax
 7b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bd:	8b 40 04             	mov    0x4(%eax),%eax
 7c0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7c3:	72 4d                	jb     812 <malloc+0xa6>
      if(p->s.size == nunits)
 7c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c8:	8b 40 04             	mov    0x4(%eax),%eax
 7cb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7ce:	75 0c                	jne    7dc <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d3:	8b 10                	mov    (%eax),%edx
 7d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d8:	89 10                	mov    %edx,(%eax)
 7da:	eb 26                	jmp    802 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7df:	8b 40 04             	mov    0x4(%eax),%eax
 7e2:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7e5:	89 c2                	mov    %eax,%edx
 7e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ea:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f0:	8b 40 04             	mov    0x4(%eax),%eax
 7f3:	c1 e0 03             	shl    $0x3,%eax
 7f6:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fc:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7ff:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 802:	8b 45 f0             	mov    -0x10(%ebp),%eax
 805:	a3 bc 0a 00 00       	mov    %eax,0xabc
      return (void*)(p + 1);
 80a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80d:	83 c0 08             	add    $0x8,%eax
 810:	eb 3b                	jmp    84d <malloc+0xe1>
    }
    if(p == freep)
 812:	a1 bc 0a 00 00       	mov    0xabc,%eax
 817:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 81a:	75 1e                	jne    83a <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 81c:	83 ec 0c             	sub    $0xc,%esp
 81f:	ff 75 ec             	pushl  -0x14(%ebp)
 822:	e8 e5 fe ff ff       	call   70c <morecore>
 827:	83 c4 10             	add    $0x10,%esp
 82a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 82d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 831:	75 07                	jne    83a <malloc+0xce>
        return 0;
 833:	b8 00 00 00 00       	mov    $0x0,%eax
 838:	eb 13                	jmp    84d <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 83a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 840:	8b 45 f4             	mov    -0xc(%ebp),%eax
 843:	8b 00                	mov    (%eax),%eax
 845:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 848:	e9 6d ff ff ff       	jmp    7ba <malloc+0x4e>
}
 84d:	c9                   	leave  
 84e:	c3                   	ret    
