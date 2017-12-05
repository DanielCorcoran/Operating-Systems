
_chown:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	83 ec 10             	sub    $0x10,%esp
  12:	89 cb                	mov    %ecx,%ebx
  if(argc != 3){
  14:	83 3b 03             	cmpl   $0x3,(%ebx)
  17:	74 17                	je     30 <main+0x30>
    printf(2, "Wrong number of arguments!\n");
  19:	83 ec 08             	sub    $0x8,%esp
  1c:	68 60 09 00 00       	push   $0x960
  21:	6a 02                	push   $0x2
  23:	e8 81 05 00 00       	call   5a9 <printf>
  28:	83 c4 10             	add    $0x10,%esp
    exit();
  2b:	e8 a2 03 00 00       	call   3d2 <exit>
  }

  int owner = atoi(argv[1]);
  30:	8b 43 04             	mov    0x4(%ebx),%eax
  33:	83 c0 04             	add    $0x4,%eax
  36:	8b 00                	mov    (%eax),%eax
  38:	83 ec 0c             	sub    $0xc,%esp
  3b:	50                   	push   %eax
  3c:	e8 2c 02 00 00       	call   26d <atoi>
  41:	83 c4 10             	add    $0x10,%esp
  44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char *path = argv[2];
  47:	8b 43 04             	mov    0x4(%ebx),%eax
  4a:	8b 40 08             	mov    0x8(%eax),%eax
  4d:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(owner < 0 || owner > 32767){
  50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  54:	78 09                	js     5f <main+0x5f>
  56:	81 7d f4 ff 7f 00 00 	cmpl   $0x7fff,-0xc(%ebp)
  5d:	7e 17                	jle    76 <main+0x76>
    printf(2, "The value of user is not valid");
  5f:	83 ec 08             	sub    $0x8,%esp
  62:	68 7c 09 00 00       	push   $0x97c
  67:	6a 02                	push   $0x2
  69:	e8 3b 05 00 00       	call   5a9 <printf>
  6e:	83 c4 10             	add    $0x10,%esp
    exit();
  71:	e8 5c 03 00 00       	call   3d2 <exit>
  }

  if(chown(path, owner) == -1){
  76:	83 ec 08             	sub    $0x8,%esp
  79:	ff 75 f4             	pushl  -0xc(%ebp)
  7c:	ff 75 f0             	pushl  -0x10(%ebp)
  7f:	e8 3e 04 00 00       	call   4c2 <chown>
  84:	83 c4 10             	add    $0x10,%esp
  87:	83 f8 ff             	cmp    $0xffffffff,%eax
  8a:	75 17                	jne    a3 <main+0xa3>
    printf(2, "The path is not valid");
  8c:	83 ec 08             	sub    $0x8,%esp
  8f:	68 9b 09 00 00       	push   $0x99b
  94:	6a 02                	push   $0x2
  96:	e8 0e 05 00 00       	call   5a9 <printf>
  9b:	83 c4 10             	add    $0x10,%esp
    exit();
  9e:	e8 2f 03 00 00       	call   3d2 <exit>
  }

  exit();
  a3:	e8 2a 03 00 00       	call   3d2 <exit>

000000a8 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  a8:	55                   	push   %ebp
  a9:	89 e5                	mov    %esp,%ebp
  ab:	57                   	push   %edi
  ac:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  b0:	8b 55 10             	mov    0x10(%ebp),%edx
  b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  b6:	89 cb                	mov    %ecx,%ebx
  b8:	89 df                	mov    %ebx,%edi
  ba:	89 d1                	mov    %edx,%ecx
  bc:	fc                   	cld    
  bd:	f3 aa                	rep stos %al,%es:(%edi)
  bf:	89 ca                	mov    %ecx,%edx
  c1:	89 fb                	mov    %edi,%ebx
  c3:	89 5d 08             	mov    %ebx,0x8(%ebp)
  c6:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  c9:	90                   	nop
  ca:	5b                   	pop    %ebx
  cb:	5f                   	pop    %edi
  cc:	5d                   	pop    %ebp
  cd:	c3                   	ret    

000000ce <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  ce:	55                   	push   %ebp
  cf:	89 e5                	mov    %esp,%ebp
  d1:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  d4:	8b 45 08             	mov    0x8(%ebp),%eax
  d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  da:	90                   	nop
  db:	8b 45 08             	mov    0x8(%ebp),%eax
  de:	8d 50 01             	lea    0x1(%eax),%edx
  e1:	89 55 08             	mov    %edx,0x8(%ebp)
  e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  e7:	8d 4a 01             	lea    0x1(%edx),%ecx
  ea:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  ed:	0f b6 12             	movzbl (%edx),%edx
  f0:	88 10                	mov    %dl,(%eax)
  f2:	0f b6 00             	movzbl (%eax),%eax
  f5:	84 c0                	test   %al,%al
  f7:	75 e2                	jne    db <strcpy+0xd>
    ;
  return os;
  f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  fc:	c9                   	leave  
  fd:	c3                   	ret    

000000fe <strcmp>:

int
strcmp(const char *p, const char *q)
{
  fe:	55                   	push   %ebp
  ff:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 101:	eb 08                	jmp    10b <strcmp+0xd>
    p++, q++;
 103:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 107:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 10b:	8b 45 08             	mov    0x8(%ebp),%eax
 10e:	0f b6 00             	movzbl (%eax),%eax
 111:	84 c0                	test   %al,%al
 113:	74 10                	je     125 <strcmp+0x27>
 115:	8b 45 08             	mov    0x8(%ebp),%eax
 118:	0f b6 10             	movzbl (%eax),%edx
 11b:	8b 45 0c             	mov    0xc(%ebp),%eax
 11e:	0f b6 00             	movzbl (%eax),%eax
 121:	38 c2                	cmp    %al,%dl
 123:	74 de                	je     103 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 125:	8b 45 08             	mov    0x8(%ebp),%eax
 128:	0f b6 00             	movzbl (%eax),%eax
 12b:	0f b6 d0             	movzbl %al,%edx
 12e:	8b 45 0c             	mov    0xc(%ebp),%eax
 131:	0f b6 00             	movzbl (%eax),%eax
 134:	0f b6 c0             	movzbl %al,%eax
 137:	29 c2                	sub    %eax,%edx
 139:	89 d0                	mov    %edx,%eax
}
 13b:	5d                   	pop    %ebp
 13c:	c3                   	ret    

0000013d <strlen>:

uint
strlen(char *s)
{
 13d:	55                   	push   %ebp
 13e:	89 e5                	mov    %esp,%ebp
 140:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 143:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 14a:	eb 04                	jmp    150 <strlen+0x13>
 14c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 150:	8b 55 fc             	mov    -0x4(%ebp),%edx
 153:	8b 45 08             	mov    0x8(%ebp),%eax
 156:	01 d0                	add    %edx,%eax
 158:	0f b6 00             	movzbl (%eax),%eax
 15b:	84 c0                	test   %al,%al
 15d:	75 ed                	jne    14c <strlen+0xf>
    ;
  return n;
 15f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 162:	c9                   	leave  
 163:	c3                   	ret    

00000164 <memset>:

void*
memset(void *dst, int c, uint n)
{
 164:	55                   	push   %ebp
 165:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 167:	8b 45 10             	mov    0x10(%ebp),%eax
 16a:	50                   	push   %eax
 16b:	ff 75 0c             	pushl  0xc(%ebp)
 16e:	ff 75 08             	pushl  0x8(%ebp)
 171:	e8 32 ff ff ff       	call   a8 <stosb>
 176:	83 c4 0c             	add    $0xc,%esp
  return dst;
 179:	8b 45 08             	mov    0x8(%ebp),%eax
}
 17c:	c9                   	leave  
 17d:	c3                   	ret    

0000017e <strchr>:

char*
strchr(const char *s, char c)
{
 17e:	55                   	push   %ebp
 17f:	89 e5                	mov    %esp,%ebp
 181:	83 ec 04             	sub    $0x4,%esp
 184:	8b 45 0c             	mov    0xc(%ebp),%eax
 187:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 18a:	eb 14                	jmp    1a0 <strchr+0x22>
    if(*s == c)
 18c:	8b 45 08             	mov    0x8(%ebp),%eax
 18f:	0f b6 00             	movzbl (%eax),%eax
 192:	3a 45 fc             	cmp    -0x4(%ebp),%al
 195:	75 05                	jne    19c <strchr+0x1e>
      return (char*)s;
 197:	8b 45 08             	mov    0x8(%ebp),%eax
 19a:	eb 13                	jmp    1af <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 19c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1a0:	8b 45 08             	mov    0x8(%ebp),%eax
 1a3:	0f b6 00             	movzbl (%eax),%eax
 1a6:	84 c0                	test   %al,%al
 1a8:	75 e2                	jne    18c <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1af:	c9                   	leave  
 1b0:	c3                   	ret    

000001b1 <gets>:

char*
gets(char *buf, int max)
{
 1b1:	55                   	push   %ebp
 1b2:	89 e5                	mov    %esp,%ebp
 1b4:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1be:	eb 42                	jmp    202 <gets+0x51>
    cc = read(0, &c, 1);
 1c0:	83 ec 04             	sub    $0x4,%esp
 1c3:	6a 01                	push   $0x1
 1c5:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1c8:	50                   	push   %eax
 1c9:	6a 00                	push   $0x0
 1cb:	e8 1a 02 00 00       	call   3ea <read>
 1d0:	83 c4 10             	add    $0x10,%esp
 1d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1da:	7e 33                	jle    20f <gets+0x5e>
      break;
    buf[i++] = c;
 1dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1df:	8d 50 01             	lea    0x1(%eax),%edx
 1e2:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1e5:	89 c2                	mov    %eax,%edx
 1e7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ea:	01 c2                	add    %eax,%edx
 1ec:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1f0:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1f2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1f6:	3c 0a                	cmp    $0xa,%al
 1f8:	74 16                	je     210 <gets+0x5f>
 1fa:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1fe:	3c 0d                	cmp    $0xd,%al
 200:	74 0e                	je     210 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 202:	8b 45 f4             	mov    -0xc(%ebp),%eax
 205:	83 c0 01             	add    $0x1,%eax
 208:	3b 45 0c             	cmp    0xc(%ebp),%eax
 20b:	7c b3                	jl     1c0 <gets+0xf>
 20d:	eb 01                	jmp    210 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 20f:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 210:	8b 55 f4             	mov    -0xc(%ebp),%edx
 213:	8b 45 08             	mov    0x8(%ebp),%eax
 216:	01 d0                	add    %edx,%eax
 218:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 21b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 21e:	c9                   	leave  
 21f:	c3                   	ret    

00000220 <stat>:

int
stat(char *n, struct stat *st)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 226:	83 ec 08             	sub    $0x8,%esp
 229:	6a 00                	push   $0x0
 22b:	ff 75 08             	pushl  0x8(%ebp)
 22e:	e8 df 01 00 00       	call   412 <open>
 233:	83 c4 10             	add    $0x10,%esp
 236:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 239:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 23d:	79 07                	jns    246 <stat+0x26>
    return -1;
 23f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 244:	eb 25                	jmp    26b <stat+0x4b>
  r = fstat(fd, st);
 246:	83 ec 08             	sub    $0x8,%esp
 249:	ff 75 0c             	pushl  0xc(%ebp)
 24c:	ff 75 f4             	pushl  -0xc(%ebp)
 24f:	e8 d6 01 00 00       	call   42a <fstat>
 254:	83 c4 10             	add    $0x10,%esp
 257:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 25a:	83 ec 0c             	sub    $0xc,%esp
 25d:	ff 75 f4             	pushl  -0xc(%ebp)
 260:	e8 95 01 00 00       	call   3fa <close>
 265:	83 c4 10             	add    $0x10,%esp
  return r;
 268:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 26b:	c9                   	leave  
 26c:	c3                   	ret    

0000026d <atoi>:

int
atoi(const char *s)
{
 26d:	55                   	push   %ebp
 26e:	89 e5                	mov    %esp,%ebp
 270:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 273:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 27a:	eb 04                	jmp    280 <atoi+0x13>
 27c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 280:	8b 45 08             	mov    0x8(%ebp),%eax
 283:	0f b6 00             	movzbl (%eax),%eax
 286:	3c 20                	cmp    $0x20,%al
 288:	74 f2                	je     27c <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 28a:	8b 45 08             	mov    0x8(%ebp),%eax
 28d:	0f b6 00             	movzbl (%eax),%eax
 290:	3c 2d                	cmp    $0x2d,%al
 292:	75 07                	jne    29b <atoi+0x2e>
 294:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 299:	eb 05                	jmp    2a0 <atoi+0x33>
 29b:	b8 01 00 00 00       	mov    $0x1,%eax
 2a0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 2a3:	8b 45 08             	mov    0x8(%ebp),%eax
 2a6:	0f b6 00             	movzbl (%eax),%eax
 2a9:	3c 2b                	cmp    $0x2b,%al
 2ab:	74 0a                	je     2b7 <atoi+0x4a>
 2ad:	8b 45 08             	mov    0x8(%ebp),%eax
 2b0:	0f b6 00             	movzbl (%eax),%eax
 2b3:	3c 2d                	cmp    $0x2d,%al
 2b5:	75 2b                	jne    2e2 <atoi+0x75>
    s++;
 2b7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 2bb:	eb 25                	jmp    2e2 <atoi+0x75>
    n = n*10 + *s++ - '0';
 2bd:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2c0:	89 d0                	mov    %edx,%eax
 2c2:	c1 e0 02             	shl    $0x2,%eax
 2c5:	01 d0                	add    %edx,%eax
 2c7:	01 c0                	add    %eax,%eax
 2c9:	89 c1                	mov    %eax,%ecx
 2cb:	8b 45 08             	mov    0x8(%ebp),%eax
 2ce:	8d 50 01             	lea    0x1(%eax),%edx
 2d1:	89 55 08             	mov    %edx,0x8(%ebp)
 2d4:	0f b6 00             	movzbl (%eax),%eax
 2d7:	0f be c0             	movsbl %al,%eax
 2da:	01 c8                	add    %ecx,%eax
 2dc:	83 e8 30             	sub    $0x30,%eax
 2df:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 2e2:	8b 45 08             	mov    0x8(%ebp),%eax
 2e5:	0f b6 00             	movzbl (%eax),%eax
 2e8:	3c 2f                	cmp    $0x2f,%al
 2ea:	7e 0a                	jle    2f6 <atoi+0x89>
 2ec:	8b 45 08             	mov    0x8(%ebp),%eax
 2ef:	0f b6 00             	movzbl (%eax),%eax
 2f2:	3c 39                	cmp    $0x39,%al
 2f4:	7e c7                	jle    2bd <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 2f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2f9:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 2fd:	c9                   	leave  
 2fe:	c3                   	ret    

000002ff <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2ff:	55                   	push   %ebp
 300:	89 e5                	mov    %esp,%ebp
 302:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 305:	8b 45 08             	mov    0x8(%ebp),%eax
 308:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 30b:	8b 45 0c             	mov    0xc(%ebp),%eax
 30e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 311:	eb 17                	jmp    32a <memmove+0x2b>
    *dst++ = *src++;
 313:	8b 45 fc             	mov    -0x4(%ebp),%eax
 316:	8d 50 01             	lea    0x1(%eax),%edx
 319:	89 55 fc             	mov    %edx,-0x4(%ebp)
 31c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 31f:	8d 4a 01             	lea    0x1(%edx),%ecx
 322:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 325:	0f b6 12             	movzbl (%edx),%edx
 328:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 32a:	8b 45 10             	mov    0x10(%ebp),%eax
 32d:	8d 50 ff             	lea    -0x1(%eax),%edx
 330:	89 55 10             	mov    %edx,0x10(%ebp)
 333:	85 c0                	test   %eax,%eax
 335:	7f dc                	jg     313 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 337:	8b 45 08             	mov    0x8(%ebp),%eax
}
 33a:	c9                   	leave  
 33b:	c3                   	ret    

0000033c <atoo>:

#ifdef CS333_P5
int
atoo(const char *s)
{
 33c:	55                   	push   %ebp
 33d:	89 e5                	mov    %esp,%ebp
 33f:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 342:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 349:	eb 04                	jmp    34f <atoo+0x13>
 34b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 34f:	8b 45 08             	mov    0x8(%ebp),%eax
 352:	0f b6 00             	movzbl (%eax),%eax
 355:	3c 20                	cmp    $0x20,%al
 357:	74 f2                	je     34b <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 359:	8b 45 08             	mov    0x8(%ebp),%eax
 35c:	0f b6 00             	movzbl (%eax),%eax
 35f:	3c 2d                	cmp    $0x2d,%al
 361:	75 07                	jne    36a <atoo+0x2e>
 363:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 368:	eb 05                	jmp    36f <atoo+0x33>
 36a:	b8 01 00 00 00       	mov    $0x1,%eax
 36f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 372:	8b 45 08             	mov    0x8(%ebp),%eax
 375:	0f b6 00             	movzbl (%eax),%eax
 378:	3c 2b                	cmp    $0x2b,%al
 37a:	74 0a                	je     386 <atoo+0x4a>
 37c:	8b 45 08             	mov    0x8(%ebp),%eax
 37f:	0f b6 00             	movzbl (%eax),%eax
 382:	3c 2d                	cmp    $0x2d,%al
 384:	75 27                	jne    3ad <atoo+0x71>
    s++;
 386:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 38a:	eb 21                	jmp    3ad <atoo+0x71>
    n = n*8 + *s++ - '0';
 38c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 38f:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 396:	8b 45 08             	mov    0x8(%ebp),%eax
 399:	8d 50 01             	lea    0x1(%eax),%edx
 39c:	89 55 08             	mov    %edx,0x8(%ebp)
 39f:	0f b6 00             	movzbl (%eax),%eax
 3a2:	0f be c0             	movsbl %al,%eax
 3a5:	01 c8                	add    %ecx,%eax
 3a7:	83 e8 30             	sub    $0x30,%eax
 3aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 3ad:	8b 45 08             	mov    0x8(%ebp),%eax
 3b0:	0f b6 00             	movzbl (%eax),%eax
 3b3:	3c 2f                	cmp    $0x2f,%al
 3b5:	7e 0a                	jle    3c1 <atoo+0x85>
 3b7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ba:	0f b6 00             	movzbl (%eax),%eax
 3bd:	3c 39                	cmp    $0x39,%al
 3bf:	7e cb                	jle    38c <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 3c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3c4:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 3c8:	c9                   	leave  
 3c9:	c3                   	ret    

000003ca <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3ca:	b8 01 00 00 00       	mov    $0x1,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <exit>:
SYSCALL(exit)
 3d2:	b8 02 00 00 00       	mov    $0x2,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <wait>:
SYSCALL(wait)
 3da:	b8 03 00 00 00       	mov    $0x3,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <pipe>:
SYSCALL(pipe)
 3e2:	b8 04 00 00 00       	mov    $0x4,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <read>:
SYSCALL(read)
 3ea:	b8 05 00 00 00       	mov    $0x5,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <write>:
SYSCALL(write)
 3f2:	b8 10 00 00 00       	mov    $0x10,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <close>:
SYSCALL(close)
 3fa:	b8 15 00 00 00       	mov    $0x15,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <kill>:
SYSCALL(kill)
 402:	b8 06 00 00 00       	mov    $0x6,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    

0000040a <exec>:
SYSCALL(exec)
 40a:	b8 07 00 00 00       	mov    $0x7,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <open>:
SYSCALL(open)
 412:	b8 0f 00 00 00       	mov    $0xf,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <mknod>:
SYSCALL(mknod)
 41a:	b8 11 00 00 00       	mov    $0x11,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    

00000422 <unlink>:
SYSCALL(unlink)
 422:	b8 12 00 00 00       	mov    $0x12,%eax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret    

0000042a <fstat>:
SYSCALL(fstat)
 42a:	b8 08 00 00 00       	mov    $0x8,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    

00000432 <link>:
SYSCALL(link)
 432:	b8 13 00 00 00       	mov    $0x13,%eax
 437:	cd 40                	int    $0x40
 439:	c3                   	ret    

0000043a <mkdir>:
SYSCALL(mkdir)
 43a:	b8 14 00 00 00       	mov    $0x14,%eax
 43f:	cd 40                	int    $0x40
 441:	c3                   	ret    

00000442 <chdir>:
SYSCALL(chdir)
 442:	b8 09 00 00 00       	mov    $0x9,%eax
 447:	cd 40                	int    $0x40
 449:	c3                   	ret    

0000044a <dup>:
SYSCALL(dup)
 44a:	b8 0a 00 00 00       	mov    $0xa,%eax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret    

00000452 <getpid>:
SYSCALL(getpid)
 452:	b8 0b 00 00 00       	mov    $0xb,%eax
 457:	cd 40                	int    $0x40
 459:	c3                   	ret    

0000045a <sbrk>:
SYSCALL(sbrk)
 45a:	b8 0c 00 00 00       	mov    $0xc,%eax
 45f:	cd 40                	int    $0x40
 461:	c3                   	ret    

00000462 <sleep>:
SYSCALL(sleep)
 462:	b8 0d 00 00 00       	mov    $0xd,%eax
 467:	cd 40                	int    $0x40
 469:	c3                   	ret    

0000046a <uptime>:
SYSCALL(uptime)
 46a:	b8 0e 00 00 00       	mov    $0xe,%eax
 46f:	cd 40                	int    $0x40
 471:	c3                   	ret    

00000472 <halt>:
SYSCALL(halt)
 472:	b8 16 00 00 00       	mov    $0x16,%eax
 477:	cd 40                	int    $0x40
 479:	c3                   	ret    

0000047a <date>:
SYSCALL(date)
 47a:	b8 17 00 00 00       	mov    $0x17,%eax
 47f:	cd 40                	int    $0x40
 481:	c3                   	ret    

00000482 <getuid>:
SYSCALL(getuid)
 482:	b8 18 00 00 00       	mov    $0x18,%eax
 487:	cd 40                	int    $0x40
 489:	c3                   	ret    

0000048a <getgid>:
SYSCALL(getgid)
 48a:	b8 19 00 00 00       	mov    $0x19,%eax
 48f:	cd 40                	int    $0x40
 491:	c3                   	ret    

00000492 <getppid>:
SYSCALL(getppid)
 492:	b8 1a 00 00 00       	mov    $0x1a,%eax
 497:	cd 40                	int    $0x40
 499:	c3                   	ret    

0000049a <setuid>:
SYSCALL(setuid)
 49a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    

000004a2 <setgid>:
SYSCALL(setgid)
 4a2:	b8 1c 00 00 00       	mov    $0x1c,%eax
 4a7:	cd 40                	int    $0x40
 4a9:	c3                   	ret    

000004aa <getprocs>:
SYSCALL(getprocs)
 4aa:	b8 1d 00 00 00       	mov    $0x1d,%eax
 4af:	cd 40                	int    $0x40
 4b1:	c3                   	ret    

000004b2 <setpriority>:
SYSCALL(setpriority)
 4b2:	b8 1e 00 00 00       	mov    $0x1e,%eax
 4b7:	cd 40                	int    $0x40
 4b9:	c3                   	ret    

000004ba <chmod>:
SYSCALL(chmod)
 4ba:	b8 1f 00 00 00       	mov    $0x1f,%eax
 4bf:	cd 40                	int    $0x40
 4c1:	c3                   	ret    

000004c2 <chown>:
SYSCALL(chown)
 4c2:	b8 20 00 00 00       	mov    $0x20,%eax
 4c7:	cd 40                	int    $0x40
 4c9:	c3                   	ret    

000004ca <chgrp>:
SYSCALL(chgrp)
 4ca:	b8 21 00 00 00       	mov    $0x21,%eax
 4cf:	cd 40                	int    $0x40
 4d1:	c3                   	ret    

000004d2 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4d2:	55                   	push   %ebp
 4d3:	89 e5                	mov    %esp,%ebp
 4d5:	83 ec 18             	sub    $0x18,%esp
 4d8:	8b 45 0c             	mov    0xc(%ebp),%eax
 4db:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4de:	83 ec 04             	sub    $0x4,%esp
 4e1:	6a 01                	push   $0x1
 4e3:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4e6:	50                   	push   %eax
 4e7:	ff 75 08             	pushl  0x8(%ebp)
 4ea:	e8 03 ff ff ff       	call   3f2 <write>
 4ef:	83 c4 10             	add    $0x10,%esp
}
 4f2:	90                   	nop
 4f3:	c9                   	leave  
 4f4:	c3                   	ret    

000004f5 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4f5:	55                   	push   %ebp
 4f6:	89 e5                	mov    %esp,%ebp
 4f8:	53                   	push   %ebx
 4f9:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4fc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 503:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 507:	74 17                	je     520 <printint+0x2b>
 509:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 50d:	79 11                	jns    520 <printint+0x2b>
    neg = 1;
 50f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 516:	8b 45 0c             	mov    0xc(%ebp),%eax
 519:	f7 d8                	neg    %eax
 51b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 51e:	eb 06                	jmp    526 <printint+0x31>
  } else {
    x = xx;
 520:	8b 45 0c             	mov    0xc(%ebp),%eax
 523:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 526:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 52d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 530:	8d 41 01             	lea    0x1(%ecx),%eax
 533:	89 45 f4             	mov    %eax,-0xc(%ebp)
 536:	8b 5d 10             	mov    0x10(%ebp),%ebx
 539:	8b 45 ec             	mov    -0x14(%ebp),%eax
 53c:	ba 00 00 00 00       	mov    $0x0,%edx
 541:	f7 f3                	div    %ebx
 543:	89 d0                	mov    %edx,%eax
 545:	0f b6 80 24 0c 00 00 	movzbl 0xc24(%eax),%eax
 54c:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 550:	8b 5d 10             	mov    0x10(%ebp),%ebx
 553:	8b 45 ec             	mov    -0x14(%ebp),%eax
 556:	ba 00 00 00 00       	mov    $0x0,%edx
 55b:	f7 f3                	div    %ebx
 55d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 560:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 564:	75 c7                	jne    52d <printint+0x38>
  if(neg)
 566:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 56a:	74 2d                	je     599 <printint+0xa4>
    buf[i++] = '-';
 56c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 56f:	8d 50 01             	lea    0x1(%eax),%edx
 572:	89 55 f4             	mov    %edx,-0xc(%ebp)
 575:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 57a:	eb 1d                	jmp    599 <printint+0xa4>
    putc(fd, buf[i]);
 57c:	8d 55 dc             	lea    -0x24(%ebp),%edx
 57f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 582:	01 d0                	add    %edx,%eax
 584:	0f b6 00             	movzbl (%eax),%eax
 587:	0f be c0             	movsbl %al,%eax
 58a:	83 ec 08             	sub    $0x8,%esp
 58d:	50                   	push   %eax
 58e:	ff 75 08             	pushl  0x8(%ebp)
 591:	e8 3c ff ff ff       	call   4d2 <putc>
 596:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 599:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 59d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5a1:	79 d9                	jns    57c <printint+0x87>
    putc(fd, buf[i]);
}
 5a3:	90                   	nop
 5a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5a7:	c9                   	leave  
 5a8:	c3                   	ret    

000005a9 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5a9:	55                   	push   %ebp
 5aa:	89 e5                	mov    %esp,%ebp
 5ac:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5af:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5b6:	8d 45 0c             	lea    0xc(%ebp),%eax
 5b9:	83 c0 04             	add    $0x4,%eax
 5bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5bf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5c6:	e9 59 01 00 00       	jmp    724 <printf+0x17b>
    c = fmt[i] & 0xff;
 5cb:	8b 55 0c             	mov    0xc(%ebp),%edx
 5ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5d1:	01 d0                	add    %edx,%eax
 5d3:	0f b6 00             	movzbl (%eax),%eax
 5d6:	0f be c0             	movsbl %al,%eax
 5d9:	25 ff 00 00 00       	and    $0xff,%eax
 5de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5e1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5e5:	75 2c                	jne    613 <printf+0x6a>
      if(c == '%'){
 5e7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5eb:	75 0c                	jne    5f9 <printf+0x50>
        state = '%';
 5ed:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5f4:	e9 27 01 00 00       	jmp    720 <printf+0x177>
      } else {
        putc(fd, c);
 5f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5fc:	0f be c0             	movsbl %al,%eax
 5ff:	83 ec 08             	sub    $0x8,%esp
 602:	50                   	push   %eax
 603:	ff 75 08             	pushl  0x8(%ebp)
 606:	e8 c7 fe ff ff       	call   4d2 <putc>
 60b:	83 c4 10             	add    $0x10,%esp
 60e:	e9 0d 01 00 00       	jmp    720 <printf+0x177>
      }
    } else if(state == '%'){
 613:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 617:	0f 85 03 01 00 00    	jne    720 <printf+0x177>
      if(c == 'd'){
 61d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 621:	75 1e                	jne    641 <printf+0x98>
        printint(fd, *ap, 10, 1);
 623:	8b 45 e8             	mov    -0x18(%ebp),%eax
 626:	8b 00                	mov    (%eax),%eax
 628:	6a 01                	push   $0x1
 62a:	6a 0a                	push   $0xa
 62c:	50                   	push   %eax
 62d:	ff 75 08             	pushl  0x8(%ebp)
 630:	e8 c0 fe ff ff       	call   4f5 <printint>
 635:	83 c4 10             	add    $0x10,%esp
        ap++;
 638:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 63c:	e9 d8 00 00 00       	jmp    719 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 641:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 645:	74 06                	je     64d <printf+0xa4>
 647:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 64b:	75 1e                	jne    66b <printf+0xc2>
        printint(fd, *ap, 16, 0);
 64d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 650:	8b 00                	mov    (%eax),%eax
 652:	6a 00                	push   $0x0
 654:	6a 10                	push   $0x10
 656:	50                   	push   %eax
 657:	ff 75 08             	pushl  0x8(%ebp)
 65a:	e8 96 fe ff ff       	call   4f5 <printint>
 65f:	83 c4 10             	add    $0x10,%esp
        ap++;
 662:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 666:	e9 ae 00 00 00       	jmp    719 <printf+0x170>
      } else if(c == 's'){
 66b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 66f:	75 43                	jne    6b4 <printf+0x10b>
        s = (char*)*ap;
 671:	8b 45 e8             	mov    -0x18(%ebp),%eax
 674:	8b 00                	mov    (%eax),%eax
 676:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 679:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 67d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 681:	75 25                	jne    6a8 <printf+0xff>
          s = "(null)";
 683:	c7 45 f4 b1 09 00 00 	movl   $0x9b1,-0xc(%ebp)
        while(*s != 0){
 68a:	eb 1c                	jmp    6a8 <printf+0xff>
          putc(fd, *s);
 68c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 68f:	0f b6 00             	movzbl (%eax),%eax
 692:	0f be c0             	movsbl %al,%eax
 695:	83 ec 08             	sub    $0x8,%esp
 698:	50                   	push   %eax
 699:	ff 75 08             	pushl  0x8(%ebp)
 69c:	e8 31 fe ff ff       	call   4d2 <putc>
 6a1:	83 c4 10             	add    $0x10,%esp
          s++;
 6a4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ab:	0f b6 00             	movzbl (%eax),%eax
 6ae:	84 c0                	test   %al,%al
 6b0:	75 da                	jne    68c <printf+0xe3>
 6b2:	eb 65                	jmp    719 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6b4:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6b8:	75 1d                	jne    6d7 <printf+0x12e>
        putc(fd, *ap);
 6ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6bd:	8b 00                	mov    (%eax),%eax
 6bf:	0f be c0             	movsbl %al,%eax
 6c2:	83 ec 08             	sub    $0x8,%esp
 6c5:	50                   	push   %eax
 6c6:	ff 75 08             	pushl  0x8(%ebp)
 6c9:	e8 04 fe ff ff       	call   4d2 <putc>
 6ce:	83 c4 10             	add    $0x10,%esp
        ap++;
 6d1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6d5:	eb 42                	jmp    719 <printf+0x170>
      } else if(c == '%'){
 6d7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6db:	75 17                	jne    6f4 <printf+0x14b>
        putc(fd, c);
 6dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6e0:	0f be c0             	movsbl %al,%eax
 6e3:	83 ec 08             	sub    $0x8,%esp
 6e6:	50                   	push   %eax
 6e7:	ff 75 08             	pushl  0x8(%ebp)
 6ea:	e8 e3 fd ff ff       	call   4d2 <putc>
 6ef:	83 c4 10             	add    $0x10,%esp
 6f2:	eb 25                	jmp    719 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6f4:	83 ec 08             	sub    $0x8,%esp
 6f7:	6a 25                	push   $0x25
 6f9:	ff 75 08             	pushl  0x8(%ebp)
 6fc:	e8 d1 fd ff ff       	call   4d2 <putc>
 701:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 704:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 707:	0f be c0             	movsbl %al,%eax
 70a:	83 ec 08             	sub    $0x8,%esp
 70d:	50                   	push   %eax
 70e:	ff 75 08             	pushl  0x8(%ebp)
 711:	e8 bc fd ff ff       	call   4d2 <putc>
 716:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 719:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 720:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 724:	8b 55 0c             	mov    0xc(%ebp),%edx
 727:	8b 45 f0             	mov    -0x10(%ebp),%eax
 72a:	01 d0                	add    %edx,%eax
 72c:	0f b6 00             	movzbl (%eax),%eax
 72f:	84 c0                	test   %al,%al
 731:	0f 85 94 fe ff ff    	jne    5cb <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 737:	90                   	nop
 738:	c9                   	leave  
 739:	c3                   	ret    

0000073a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 73a:	55                   	push   %ebp
 73b:	89 e5                	mov    %esp,%ebp
 73d:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 740:	8b 45 08             	mov    0x8(%ebp),%eax
 743:	83 e8 08             	sub    $0x8,%eax
 746:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 749:	a1 40 0c 00 00       	mov    0xc40,%eax
 74e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 751:	eb 24                	jmp    777 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 753:	8b 45 fc             	mov    -0x4(%ebp),%eax
 756:	8b 00                	mov    (%eax),%eax
 758:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 75b:	77 12                	ja     76f <free+0x35>
 75d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 760:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 763:	77 24                	ja     789 <free+0x4f>
 765:	8b 45 fc             	mov    -0x4(%ebp),%eax
 768:	8b 00                	mov    (%eax),%eax
 76a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 76d:	77 1a                	ja     789 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 76f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 772:	8b 00                	mov    (%eax),%eax
 774:	89 45 fc             	mov    %eax,-0x4(%ebp)
 777:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 77d:	76 d4                	jbe    753 <free+0x19>
 77f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 782:	8b 00                	mov    (%eax),%eax
 784:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 787:	76 ca                	jbe    753 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 789:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78c:	8b 40 04             	mov    0x4(%eax),%eax
 78f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 796:	8b 45 f8             	mov    -0x8(%ebp),%eax
 799:	01 c2                	add    %eax,%edx
 79b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79e:	8b 00                	mov    (%eax),%eax
 7a0:	39 c2                	cmp    %eax,%edx
 7a2:	75 24                	jne    7c8 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a7:	8b 50 04             	mov    0x4(%eax),%edx
 7aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ad:	8b 00                	mov    (%eax),%eax
 7af:	8b 40 04             	mov    0x4(%eax),%eax
 7b2:	01 c2                	add    %eax,%edx
 7b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b7:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bd:	8b 00                	mov    (%eax),%eax
 7bf:	8b 10                	mov    (%eax),%edx
 7c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c4:	89 10                	mov    %edx,(%eax)
 7c6:	eb 0a                	jmp    7d2 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cb:	8b 10                	mov    (%eax),%edx
 7cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d0:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d5:	8b 40 04             	mov    0x4(%eax),%eax
 7d8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7df:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e2:	01 d0                	add    %edx,%eax
 7e4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7e7:	75 20                	jne    809 <free+0xcf>
    p->s.size += bp->s.size;
 7e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ec:	8b 50 04             	mov    0x4(%eax),%edx
 7ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f2:	8b 40 04             	mov    0x4(%eax),%eax
 7f5:	01 c2                	add    %eax,%edx
 7f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fa:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 800:	8b 10                	mov    (%eax),%edx
 802:	8b 45 fc             	mov    -0x4(%ebp),%eax
 805:	89 10                	mov    %edx,(%eax)
 807:	eb 08                	jmp    811 <free+0xd7>
  } else
    p->s.ptr = bp;
 809:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 80f:	89 10                	mov    %edx,(%eax)
  freep = p;
 811:	8b 45 fc             	mov    -0x4(%ebp),%eax
 814:	a3 40 0c 00 00       	mov    %eax,0xc40
}
 819:	90                   	nop
 81a:	c9                   	leave  
 81b:	c3                   	ret    

0000081c <morecore>:

static Header*
morecore(uint nu)
{
 81c:	55                   	push   %ebp
 81d:	89 e5                	mov    %esp,%ebp
 81f:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 822:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 829:	77 07                	ja     832 <morecore+0x16>
    nu = 4096;
 82b:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 832:	8b 45 08             	mov    0x8(%ebp),%eax
 835:	c1 e0 03             	shl    $0x3,%eax
 838:	83 ec 0c             	sub    $0xc,%esp
 83b:	50                   	push   %eax
 83c:	e8 19 fc ff ff       	call   45a <sbrk>
 841:	83 c4 10             	add    $0x10,%esp
 844:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 847:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 84b:	75 07                	jne    854 <morecore+0x38>
    return 0;
 84d:	b8 00 00 00 00       	mov    $0x0,%eax
 852:	eb 26                	jmp    87a <morecore+0x5e>
  hp = (Header*)p;
 854:	8b 45 f4             	mov    -0xc(%ebp),%eax
 857:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 85a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 85d:	8b 55 08             	mov    0x8(%ebp),%edx
 860:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 863:	8b 45 f0             	mov    -0x10(%ebp),%eax
 866:	83 c0 08             	add    $0x8,%eax
 869:	83 ec 0c             	sub    $0xc,%esp
 86c:	50                   	push   %eax
 86d:	e8 c8 fe ff ff       	call   73a <free>
 872:	83 c4 10             	add    $0x10,%esp
  return freep;
 875:	a1 40 0c 00 00       	mov    0xc40,%eax
}
 87a:	c9                   	leave  
 87b:	c3                   	ret    

0000087c <malloc>:

void*
malloc(uint nbytes)
{
 87c:	55                   	push   %ebp
 87d:	89 e5                	mov    %esp,%ebp
 87f:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 882:	8b 45 08             	mov    0x8(%ebp),%eax
 885:	83 c0 07             	add    $0x7,%eax
 888:	c1 e8 03             	shr    $0x3,%eax
 88b:	83 c0 01             	add    $0x1,%eax
 88e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 891:	a1 40 0c 00 00       	mov    0xc40,%eax
 896:	89 45 f0             	mov    %eax,-0x10(%ebp)
 899:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 89d:	75 23                	jne    8c2 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 89f:	c7 45 f0 38 0c 00 00 	movl   $0xc38,-0x10(%ebp)
 8a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a9:	a3 40 0c 00 00       	mov    %eax,0xc40
 8ae:	a1 40 0c 00 00       	mov    0xc40,%eax
 8b3:	a3 38 0c 00 00       	mov    %eax,0xc38
    base.s.size = 0;
 8b8:	c7 05 3c 0c 00 00 00 	movl   $0x0,0xc3c
 8bf:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c5:	8b 00                	mov    (%eax),%eax
 8c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cd:	8b 40 04             	mov    0x4(%eax),%eax
 8d0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8d3:	72 4d                	jb     922 <malloc+0xa6>
      if(p->s.size == nunits)
 8d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d8:	8b 40 04             	mov    0x4(%eax),%eax
 8db:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8de:	75 0c                	jne    8ec <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e3:	8b 10                	mov    (%eax),%edx
 8e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e8:	89 10                	mov    %edx,(%eax)
 8ea:	eb 26                	jmp    912 <malloc+0x96>
      else {
        p->s.size -= nunits;
 8ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ef:	8b 40 04             	mov    0x4(%eax),%eax
 8f2:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8f5:	89 c2                	mov    %eax,%edx
 8f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8fa:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 900:	8b 40 04             	mov    0x4(%eax),%eax
 903:	c1 e0 03             	shl    $0x3,%eax
 906:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 909:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90c:	8b 55 ec             	mov    -0x14(%ebp),%edx
 90f:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 912:	8b 45 f0             	mov    -0x10(%ebp),%eax
 915:	a3 40 0c 00 00       	mov    %eax,0xc40
      return (void*)(p + 1);
 91a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91d:	83 c0 08             	add    $0x8,%eax
 920:	eb 3b                	jmp    95d <malloc+0xe1>
    }
    if(p == freep)
 922:	a1 40 0c 00 00       	mov    0xc40,%eax
 927:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 92a:	75 1e                	jne    94a <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 92c:	83 ec 0c             	sub    $0xc,%esp
 92f:	ff 75 ec             	pushl  -0x14(%ebp)
 932:	e8 e5 fe ff ff       	call   81c <morecore>
 937:	83 c4 10             	add    $0x10,%esp
 93a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 93d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 941:	75 07                	jne    94a <malloc+0xce>
        return 0;
 943:	b8 00 00 00 00       	mov    $0x0,%eax
 948:	eb 13                	jmp    95d <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 94a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 950:	8b 45 f4             	mov    -0xc(%ebp),%eax
 953:	8b 00                	mov    (%eax),%eax
 955:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 958:	e9 6d ff ff ff       	jmp    8ca <malloc+0x4e>
}
 95d:	c9                   	leave  
 95e:	c3                   	ret    
