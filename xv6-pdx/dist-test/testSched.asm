
_testSched:     file format elf32-i386


Disassembly of section .text:

00000000 <countForever>:
#define PrioCount 5
#define numChildren 10

void
countForever(int i)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int j, p, rc;
  unsigned long count = 0;
   6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  j = getpid();
   d:	e8 6a 04 00 00       	call   47c <getpid>
  12:	89 45 ec             	mov    %eax,-0x14(%ebp)
  p = i%PrioCount;
  15:	8b 4d 08             	mov    0x8(%ebp),%ecx
  18:	ba 67 66 66 66       	mov    $0x66666667,%edx
  1d:	89 c8                	mov    %ecx,%eax
  1f:	f7 ea                	imul   %edx
  21:	d1 fa                	sar    %edx
  23:	89 c8                	mov    %ecx,%eax
  25:	c1 f8 1f             	sar    $0x1f,%eax
  28:	29 c2                	sub    %eax,%edx
  2a:	89 d0                	mov    %edx,%eax
  2c:	c1 e0 02             	shl    $0x2,%eax
  2f:	01 d0                	add    %edx,%eax
  31:	29 c1                	sub    %eax,%ecx
  33:	89 c8                	mov    %ecx,%eax
  35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  rc = setpriority(j, p);
  38:	83 ec 08             	sub    $0x8,%esp
  3b:	ff 75 f4             	pushl  -0xc(%ebp)
  3e:	ff 75 ec             	pushl  -0x14(%ebp)
  41:	e8 96 04 00 00       	call   4dc <setpriority>
  46:	83 c4 10             	add    $0x10,%esp
  49:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if (rc == 0) 
  4c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  50:	75 17                	jne    69 <countForever+0x69>
    printf(1, "%d: start prio %d\n", j, p);
  52:	ff 75 f4             	pushl  -0xc(%ebp)
  55:	ff 75 ec             	pushl  -0x14(%ebp)
  58:	68 74 09 00 00       	push   $0x974
  5d:	6a 01                	push   $0x1
  5f:	e8 57 05 00 00       	call   5bb <printf>
  64:	83 c4 10             	add    $0x10,%esp
  67:	eb 1b                	jmp    84 <countForever+0x84>
  else {
    printf(1, "setpriority failed. file %s at %d\n", __FILE__, __LINE__);
  69:	6a 16                	push   $0x16
  6b:	68 87 09 00 00       	push   $0x987
  70:	68 94 09 00 00       	push   $0x994
  75:	6a 01                	push   $0x1
  77:	e8 3f 05 00 00       	call   5bb <printf>
  7c:	83 c4 10             	add    $0x10,%esp
    exit();
  7f:	e8 78 03 00 00       	call   3fc <exit>
  }

  while (1) {
    count++;
  84:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if ((count & (0x1FFFFFFF)) == 0) {
  88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8b:	25 ff ff ff 1f       	and    $0x1fffffff,%eax
  90:	85 c0                	test   %eax,%eax
  92:	75 f0                	jne    84 <countForever+0x84>
      p = (p+1) % PrioCount;
  94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  97:	8d 48 01             	lea    0x1(%eax),%ecx
  9a:	ba 67 66 66 66       	mov    $0x66666667,%edx
  9f:	89 c8                	mov    %ecx,%eax
  a1:	f7 ea                	imul   %edx
  a3:	d1 fa                	sar    %edx
  a5:	89 c8                	mov    %ecx,%eax
  a7:	c1 f8 1f             	sar    $0x1f,%eax
  aa:	29 c2                	sub    %eax,%edx
  ac:	89 d0                	mov    %edx,%eax
  ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  b4:	89 d0                	mov    %edx,%eax
  b6:	c1 e0 02             	shl    $0x2,%eax
  b9:	01 d0                	add    %edx,%eax
  bb:	29 c1                	sub    %eax,%ecx
  bd:	89 c8                	mov    %ecx,%eax
  bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
      rc = setpriority(j, p);
  c2:	83 ec 08             	sub    $0x8,%esp
  c5:	ff 75 f4             	pushl  -0xc(%ebp)
  c8:	ff 75 ec             	pushl  -0x14(%ebp)
  cb:	e8 0c 04 00 00       	call   4dc <setpriority>
  d0:	83 c4 10             	add    $0x10,%esp
  d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if (rc == 0) 
  d6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  da:	75 17                	jne    f3 <countForever+0xf3>
	printf(1, "%d: new prio %d\n", j, p);
  dc:	ff 75 f4             	pushl  -0xc(%ebp)
  df:	ff 75 ec             	pushl  -0x14(%ebp)
  e2:	68 b7 09 00 00       	push   $0x9b7
  e7:	6a 01                	push   $0x1
  e9:	e8 cd 04 00 00       	call   5bb <printf>
  ee:	83 c4 10             	add    $0x10,%esp
  f1:	eb 91                	jmp    84 <countForever+0x84>
      else {
	printf(1, "setpriority failed. file %s at %d\n", __FILE__, __LINE__);
  f3:	6a 22                	push   $0x22
  f5:	68 87 09 00 00       	push   $0x987
  fa:	68 94 09 00 00       	push   $0x994
  ff:	6a 01                	push   $0x1
 101:	e8 b5 04 00 00       	call   5bb <printf>
 106:	83 c4 10             	add    $0x10,%esp
	exit();
 109:	e8 ee 02 00 00       	call   3fc <exit>

0000010e <main>:
  }
}

int
main(void)
{
 10e:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 112:	83 e4 f0             	and    $0xfffffff0,%esp
 115:	ff 71 fc             	pushl  -0x4(%ecx)
 118:	55                   	push   %ebp
 119:	89 e5                	mov    %esp,%ebp
 11b:	51                   	push   %ecx
 11c:	83 ec 14             	sub    $0x14,%esp
  int i, rc;

  for (i=0; i<numChildren; i++) {
 11f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 126:	eb 20                	jmp    148 <main+0x3a>
    rc = fork();
 128:	e8 c7 02 00 00       	call   3f4 <fork>
 12d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (!rc) { // child
 130:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 134:	75 0e                	jne    144 <main+0x36>
      countForever(i);
 136:	83 ec 0c             	sub    $0xc,%esp
 139:	ff 75 f4             	pushl  -0xc(%ebp)
 13c:	e8 bf fe ff ff       	call   0 <countForever>
 141:	83 c4 10             	add    $0x10,%esp
int
main(void)
{
  int i, rc;

  for (i=0; i<numChildren; i++) {
 144:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 148:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
 14c:	7e da                	jle    128 <main+0x1a>
    if (!rc) { // child
      countForever(i);
    }
  }
  // what the heck, let's have the parent waste time as well!
  countForever(1);
 14e:	83 ec 0c             	sub    $0xc,%esp
 151:	6a 01                	push   $0x1
 153:	e8 a8 fe ff ff       	call   0 <countForever>
 158:	83 c4 10             	add    $0x10,%esp
  exit();
 15b:	e8 9c 02 00 00       	call   3fc <exit>

00000160 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	57                   	push   %edi
 164:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 165:	8b 4d 08             	mov    0x8(%ebp),%ecx
 168:	8b 55 10             	mov    0x10(%ebp),%edx
 16b:	8b 45 0c             	mov    0xc(%ebp),%eax
 16e:	89 cb                	mov    %ecx,%ebx
 170:	89 df                	mov    %ebx,%edi
 172:	89 d1                	mov    %edx,%ecx
 174:	fc                   	cld    
 175:	f3 aa                	rep stos %al,%es:(%edi)
 177:	89 ca                	mov    %ecx,%edx
 179:	89 fb                	mov    %edi,%ebx
 17b:	89 5d 08             	mov    %ebx,0x8(%ebp)
 17e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 181:	90                   	nop
 182:	5b                   	pop    %ebx
 183:	5f                   	pop    %edi
 184:	5d                   	pop    %ebp
 185:	c3                   	ret    

00000186 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 186:	55                   	push   %ebp
 187:	89 e5                	mov    %esp,%ebp
 189:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 18c:	8b 45 08             	mov    0x8(%ebp),%eax
 18f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 192:	90                   	nop
 193:	8b 45 08             	mov    0x8(%ebp),%eax
 196:	8d 50 01             	lea    0x1(%eax),%edx
 199:	89 55 08             	mov    %edx,0x8(%ebp)
 19c:	8b 55 0c             	mov    0xc(%ebp),%edx
 19f:	8d 4a 01             	lea    0x1(%edx),%ecx
 1a2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 1a5:	0f b6 12             	movzbl (%edx),%edx
 1a8:	88 10                	mov    %dl,(%eax)
 1aa:	0f b6 00             	movzbl (%eax),%eax
 1ad:	84 c0                	test   %al,%al
 1af:	75 e2                	jne    193 <strcpy+0xd>
    ;
  return os;
 1b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1b4:	c9                   	leave  
 1b5:	c3                   	ret    

000001b6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1b6:	55                   	push   %ebp
 1b7:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1b9:	eb 08                	jmp    1c3 <strcmp+0xd>
    p++, q++;
 1bb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1bf:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1c3:	8b 45 08             	mov    0x8(%ebp),%eax
 1c6:	0f b6 00             	movzbl (%eax),%eax
 1c9:	84 c0                	test   %al,%al
 1cb:	74 10                	je     1dd <strcmp+0x27>
 1cd:	8b 45 08             	mov    0x8(%ebp),%eax
 1d0:	0f b6 10             	movzbl (%eax),%edx
 1d3:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d6:	0f b6 00             	movzbl (%eax),%eax
 1d9:	38 c2                	cmp    %al,%dl
 1db:	74 de                	je     1bb <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1dd:	8b 45 08             	mov    0x8(%ebp),%eax
 1e0:	0f b6 00             	movzbl (%eax),%eax
 1e3:	0f b6 d0             	movzbl %al,%edx
 1e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e9:	0f b6 00             	movzbl (%eax),%eax
 1ec:	0f b6 c0             	movzbl %al,%eax
 1ef:	29 c2                	sub    %eax,%edx
 1f1:	89 d0                	mov    %edx,%eax
}
 1f3:	5d                   	pop    %ebp
 1f4:	c3                   	ret    

000001f5 <strlen>:

uint
strlen(char *s)
{
 1f5:	55                   	push   %ebp
 1f6:	89 e5                	mov    %esp,%ebp
 1f8:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 202:	eb 04                	jmp    208 <strlen+0x13>
 204:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 208:	8b 55 fc             	mov    -0x4(%ebp),%edx
 20b:	8b 45 08             	mov    0x8(%ebp),%eax
 20e:	01 d0                	add    %edx,%eax
 210:	0f b6 00             	movzbl (%eax),%eax
 213:	84 c0                	test   %al,%al
 215:	75 ed                	jne    204 <strlen+0xf>
    ;
  return n;
 217:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 21a:	c9                   	leave  
 21b:	c3                   	ret    

0000021c <memset>:

void*
memset(void *dst, int c, uint n)
{
 21c:	55                   	push   %ebp
 21d:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 21f:	8b 45 10             	mov    0x10(%ebp),%eax
 222:	50                   	push   %eax
 223:	ff 75 0c             	pushl  0xc(%ebp)
 226:	ff 75 08             	pushl  0x8(%ebp)
 229:	e8 32 ff ff ff       	call   160 <stosb>
 22e:	83 c4 0c             	add    $0xc,%esp
  return dst;
 231:	8b 45 08             	mov    0x8(%ebp),%eax
}
 234:	c9                   	leave  
 235:	c3                   	ret    

00000236 <strchr>:

char*
strchr(const char *s, char c)
{
 236:	55                   	push   %ebp
 237:	89 e5                	mov    %esp,%ebp
 239:	83 ec 04             	sub    $0x4,%esp
 23c:	8b 45 0c             	mov    0xc(%ebp),%eax
 23f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 242:	eb 14                	jmp    258 <strchr+0x22>
    if(*s == c)
 244:	8b 45 08             	mov    0x8(%ebp),%eax
 247:	0f b6 00             	movzbl (%eax),%eax
 24a:	3a 45 fc             	cmp    -0x4(%ebp),%al
 24d:	75 05                	jne    254 <strchr+0x1e>
      return (char*)s;
 24f:	8b 45 08             	mov    0x8(%ebp),%eax
 252:	eb 13                	jmp    267 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 254:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 258:	8b 45 08             	mov    0x8(%ebp),%eax
 25b:	0f b6 00             	movzbl (%eax),%eax
 25e:	84 c0                	test   %al,%al
 260:	75 e2                	jne    244 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 262:	b8 00 00 00 00       	mov    $0x0,%eax
}
 267:	c9                   	leave  
 268:	c3                   	ret    

00000269 <gets>:

char*
gets(char *buf, int max)
{
 269:	55                   	push   %ebp
 26a:	89 e5                	mov    %esp,%ebp
 26c:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 26f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 276:	eb 42                	jmp    2ba <gets+0x51>
    cc = read(0, &c, 1);
 278:	83 ec 04             	sub    $0x4,%esp
 27b:	6a 01                	push   $0x1
 27d:	8d 45 ef             	lea    -0x11(%ebp),%eax
 280:	50                   	push   %eax
 281:	6a 00                	push   $0x0
 283:	e8 8c 01 00 00       	call   414 <read>
 288:	83 c4 10             	add    $0x10,%esp
 28b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 28e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 292:	7e 33                	jle    2c7 <gets+0x5e>
      break;
    buf[i++] = c;
 294:	8b 45 f4             	mov    -0xc(%ebp),%eax
 297:	8d 50 01             	lea    0x1(%eax),%edx
 29a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 29d:	89 c2                	mov    %eax,%edx
 29f:	8b 45 08             	mov    0x8(%ebp),%eax
 2a2:	01 c2                	add    %eax,%edx
 2a4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a8:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 2aa:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2ae:	3c 0a                	cmp    $0xa,%al
 2b0:	74 16                	je     2c8 <gets+0x5f>
 2b2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2b6:	3c 0d                	cmp    $0xd,%al
 2b8:	74 0e                	je     2c8 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2bd:	83 c0 01             	add    $0x1,%eax
 2c0:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2c3:	7c b3                	jl     278 <gets+0xf>
 2c5:	eb 01                	jmp    2c8 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 2c7:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2cb:	8b 45 08             	mov    0x8(%ebp),%eax
 2ce:	01 d0                	add    %edx,%eax
 2d0:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2d3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2d6:	c9                   	leave  
 2d7:	c3                   	ret    

000002d8 <stat>:

int
stat(char *n, struct stat *st)
{
 2d8:	55                   	push   %ebp
 2d9:	89 e5                	mov    %esp,%ebp
 2db:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2de:	83 ec 08             	sub    $0x8,%esp
 2e1:	6a 00                	push   $0x0
 2e3:	ff 75 08             	pushl  0x8(%ebp)
 2e6:	e8 51 01 00 00       	call   43c <open>
 2eb:	83 c4 10             	add    $0x10,%esp
 2ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2f5:	79 07                	jns    2fe <stat+0x26>
    return -1;
 2f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2fc:	eb 25                	jmp    323 <stat+0x4b>
  r = fstat(fd, st);
 2fe:	83 ec 08             	sub    $0x8,%esp
 301:	ff 75 0c             	pushl  0xc(%ebp)
 304:	ff 75 f4             	pushl  -0xc(%ebp)
 307:	e8 48 01 00 00       	call   454 <fstat>
 30c:	83 c4 10             	add    $0x10,%esp
 30f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 312:	83 ec 0c             	sub    $0xc,%esp
 315:	ff 75 f4             	pushl  -0xc(%ebp)
 318:	e8 07 01 00 00       	call   424 <close>
 31d:	83 c4 10             	add    $0x10,%esp
  return r;
 320:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 323:	c9                   	leave  
 324:	c3                   	ret    

00000325 <atoi>:

int
atoi(const char *s)
{
 325:	55                   	push   %ebp
 326:	89 e5                	mov    %esp,%ebp
 328:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 32b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 332:	eb 04                	jmp    338 <atoi+0x13>
 334:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 338:	8b 45 08             	mov    0x8(%ebp),%eax
 33b:	0f b6 00             	movzbl (%eax),%eax
 33e:	3c 20                	cmp    $0x20,%al
 340:	74 f2                	je     334 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 342:	8b 45 08             	mov    0x8(%ebp),%eax
 345:	0f b6 00             	movzbl (%eax),%eax
 348:	3c 2d                	cmp    $0x2d,%al
 34a:	75 07                	jne    353 <atoi+0x2e>
 34c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 351:	eb 05                	jmp    358 <atoi+0x33>
 353:	b8 01 00 00 00       	mov    $0x1,%eax
 358:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 35b:	8b 45 08             	mov    0x8(%ebp),%eax
 35e:	0f b6 00             	movzbl (%eax),%eax
 361:	3c 2b                	cmp    $0x2b,%al
 363:	74 0a                	je     36f <atoi+0x4a>
 365:	8b 45 08             	mov    0x8(%ebp),%eax
 368:	0f b6 00             	movzbl (%eax),%eax
 36b:	3c 2d                	cmp    $0x2d,%al
 36d:	75 2b                	jne    39a <atoi+0x75>
    s++;
 36f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 373:	eb 25                	jmp    39a <atoi+0x75>
    n = n*10 + *s++ - '0';
 375:	8b 55 fc             	mov    -0x4(%ebp),%edx
 378:	89 d0                	mov    %edx,%eax
 37a:	c1 e0 02             	shl    $0x2,%eax
 37d:	01 d0                	add    %edx,%eax
 37f:	01 c0                	add    %eax,%eax
 381:	89 c1                	mov    %eax,%ecx
 383:	8b 45 08             	mov    0x8(%ebp),%eax
 386:	8d 50 01             	lea    0x1(%eax),%edx
 389:	89 55 08             	mov    %edx,0x8(%ebp)
 38c:	0f b6 00             	movzbl (%eax),%eax
 38f:	0f be c0             	movsbl %al,%eax
 392:	01 c8                	add    %ecx,%eax
 394:	83 e8 30             	sub    $0x30,%eax
 397:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 39a:	8b 45 08             	mov    0x8(%ebp),%eax
 39d:	0f b6 00             	movzbl (%eax),%eax
 3a0:	3c 2f                	cmp    $0x2f,%al
 3a2:	7e 0a                	jle    3ae <atoi+0x89>
 3a4:	8b 45 08             	mov    0x8(%ebp),%eax
 3a7:	0f b6 00             	movzbl (%eax),%eax
 3aa:	3c 39                	cmp    $0x39,%al
 3ac:	7e c7                	jle    375 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 3ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3b1:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 3b5:	c9                   	leave  
 3b6:	c3                   	ret    

000003b7 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3b7:	55                   	push   %ebp
 3b8:	89 e5                	mov    %esp,%ebp
 3ba:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3bd:	8b 45 08             	mov    0x8(%ebp),%eax
 3c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3c3:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3c9:	eb 17                	jmp    3e2 <memmove+0x2b>
    *dst++ = *src++;
 3cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3ce:	8d 50 01             	lea    0x1(%eax),%edx
 3d1:	89 55 fc             	mov    %edx,-0x4(%ebp)
 3d4:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3d7:	8d 4a 01             	lea    0x1(%edx),%ecx
 3da:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 3dd:	0f b6 12             	movzbl (%edx),%edx
 3e0:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3e2:	8b 45 10             	mov    0x10(%ebp),%eax
 3e5:	8d 50 ff             	lea    -0x1(%eax),%edx
 3e8:	89 55 10             	mov    %edx,0x10(%ebp)
 3eb:	85 c0                	test   %eax,%eax
 3ed:	7f dc                	jg     3cb <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3ef:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3f2:	c9                   	leave  
 3f3:	c3                   	ret    

000003f4 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3f4:	b8 01 00 00 00       	mov    $0x1,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <exit>:
SYSCALL(exit)
 3fc:	b8 02 00 00 00       	mov    $0x2,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <wait>:
SYSCALL(wait)
 404:	b8 03 00 00 00       	mov    $0x3,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <pipe>:
SYSCALL(pipe)
 40c:	b8 04 00 00 00       	mov    $0x4,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <read>:
SYSCALL(read)
 414:	b8 05 00 00 00       	mov    $0x5,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <write>:
SYSCALL(write)
 41c:	b8 10 00 00 00       	mov    $0x10,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <close>:
SYSCALL(close)
 424:	b8 15 00 00 00       	mov    $0x15,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <kill>:
SYSCALL(kill)
 42c:	b8 06 00 00 00       	mov    $0x6,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <exec>:
SYSCALL(exec)
 434:	b8 07 00 00 00       	mov    $0x7,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <open>:
SYSCALL(open)
 43c:	b8 0f 00 00 00       	mov    $0xf,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <mknod>:
SYSCALL(mknod)
 444:	b8 11 00 00 00       	mov    $0x11,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <unlink>:
SYSCALL(unlink)
 44c:	b8 12 00 00 00       	mov    $0x12,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <fstat>:
SYSCALL(fstat)
 454:	b8 08 00 00 00       	mov    $0x8,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <link>:
SYSCALL(link)
 45c:	b8 13 00 00 00       	mov    $0x13,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <mkdir>:
SYSCALL(mkdir)
 464:	b8 14 00 00 00       	mov    $0x14,%eax
 469:	cd 40                	int    $0x40
 46b:	c3                   	ret    

0000046c <chdir>:
SYSCALL(chdir)
 46c:	b8 09 00 00 00       	mov    $0x9,%eax
 471:	cd 40                	int    $0x40
 473:	c3                   	ret    

00000474 <dup>:
SYSCALL(dup)
 474:	b8 0a 00 00 00       	mov    $0xa,%eax
 479:	cd 40                	int    $0x40
 47b:	c3                   	ret    

0000047c <getpid>:
SYSCALL(getpid)
 47c:	b8 0b 00 00 00       	mov    $0xb,%eax
 481:	cd 40                	int    $0x40
 483:	c3                   	ret    

00000484 <sbrk>:
SYSCALL(sbrk)
 484:	b8 0c 00 00 00       	mov    $0xc,%eax
 489:	cd 40                	int    $0x40
 48b:	c3                   	ret    

0000048c <sleep>:
SYSCALL(sleep)
 48c:	b8 0d 00 00 00       	mov    $0xd,%eax
 491:	cd 40                	int    $0x40
 493:	c3                   	ret    

00000494 <uptime>:
SYSCALL(uptime)
 494:	b8 0e 00 00 00       	mov    $0xe,%eax
 499:	cd 40                	int    $0x40
 49b:	c3                   	ret    

0000049c <halt>:
SYSCALL(halt)
 49c:	b8 16 00 00 00       	mov    $0x16,%eax
 4a1:	cd 40                	int    $0x40
 4a3:	c3                   	ret    

000004a4 <date>:
SYSCALL(date)
 4a4:	b8 17 00 00 00       	mov    $0x17,%eax
 4a9:	cd 40                	int    $0x40
 4ab:	c3                   	ret    

000004ac <getuid>:
SYSCALL(getuid)
 4ac:	b8 18 00 00 00       	mov    $0x18,%eax
 4b1:	cd 40                	int    $0x40
 4b3:	c3                   	ret    

000004b4 <getgid>:
SYSCALL(getgid)
 4b4:	b8 19 00 00 00       	mov    $0x19,%eax
 4b9:	cd 40                	int    $0x40
 4bb:	c3                   	ret    

000004bc <getppid>:
SYSCALL(getppid)
 4bc:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4c1:	cd 40                	int    $0x40
 4c3:	c3                   	ret    

000004c4 <setuid>:
SYSCALL(setuid)
 4c4:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4c9:	cd 40                	int    $0x40
 4cb:	c3                   	ret    

000004cc <setgid>:
SYSCALL(setgid)
 4cc:	b8 1c 00 00 00       	mov    $0x1c,%eax
 4d1:	cd 40                	int    $0x40
 4d3:	c3                   	ret    

000004d4 <getprocs>:
SYSCALL(getprocs)
 4d4:	b8 1d 00 00 00       	mov    $0x1d,%eax
 4d9:	cd 40                	int    $0x40
 4db:	c3                   	ret    

000004dc <setpriority>:
SYSCALL(setpriority)
 4dc:	b8 1e 00 00 00       	mov    $0x1e,%eax
 4e1:	cd 40                	int    $0x40
 4e3:	c3                   	ret    

000004e4 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4e4:	55                   	push   %ebp
 4e5:	89 e5                	mov    %esp,%ebp
 4e7:	83 ec 18             	sub    $0x18,%esp
 4ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ed:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4f0:	83 ec 04             	sub    $0x4,%esp
 4f3:	6a 01                	push   $0x1
 4f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4f8:	50                   	push   %eax
 4f9:	ff 75 08             	pushl  0x8(%ebp)
 4fc:	e8 1b ff ff ff       	call   41c <write>
 501:	83 c4 10             	add    $0x10,%esp
}
 504:	90                   	nop
 505:	c9                   	leave  
 506:	c3                   	ret    

00000507 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 507:	55                   	push   %ebp
 508:	89 e5                	mov    %esp,%ebp
 50a:	53                   	push   %ebx
 50b:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 50e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 515:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 519:	74 17                	je     532 <printint+0x2b>
 51b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 51f:	79 11                	jns    532 <printint+0x2b>
    neg = 1;
 521:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 528:	8b 45 0c             	mov    0xc(%ebp),%eax
 52b:	f7 d8                	neg    %eax
 52d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 530:	eb 06                	jmp    538 <printint+0x31>
  } else {
    x = xx;
 532:	8b 45 0c             	mov    0xc(%ebp),%eax
 535:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 538:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 53f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 542:	8d 41 01             	lea    0x1(%ecx),%eax
 545:	89 45 f4             	mov    %eax,-0xc(%ebp)
 548:	8b 5d 10             	mov    0x10(%ebp),%ebx
 54b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 54e:	ba 00 00 00 00       	mov    $0x0,%edx
 553:	f7 f3                	div    %ebx
 555:	89 d0                	mov    %edx,%eax
 557:	0f b6 80 34 0c 00 00 	movzbl 0xc34(%eax),%eax
 55e:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 562:	8b 5d 10             	mov    0x10(%ebp),%ebx
 565:	8b 45 ec             	mov    -0x14(%ebp),%eax
 568:	ba 00 00 00 00       	mov    $0x0,%edx
 56d:	f7 f3                	div    %ebx
 56f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 572:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 576:	75 c7                	jne    53f <printint+0x38>
  if(neg)
 578:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 57c:	74 2d                	je     5ab <printint+0xa4>
    buf[i++] = '-';
 57e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 581:	8d 50 01             	lea    0x1(%eax),%edx
 584:	89 55 f4             	mov    %edx,-0xc(%ebp)
 587:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 58c:	eb 1d                	jmp    5ab <printint+0xa4>
    putc(fd, buf[i]);
 58e:	8d 55 dc             	lea    -0x24(%ebp),%edx
 591:	8b 45 f4             	mov    -0xc(%ebp),%eax
 594:	01 d0                	add    %edx,%eax
 596:	0f b6 00             	movzbl (%eax),%eax
 599:	0f be c0             	movsbl %al,%eax
 59c:	83 ec 08             	sub    $0x8,%esp
 59f:	50                   	push   %eax
 5a0:	ff 75 08             	pushl  0x8(%ebp)
 5a3:	e8 3c ff ff ff       	call   4e4 <putc>
 5a8:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5ab:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5b3:	79 d9                	jns    58e <printint+0x87>
    putc(fd, buf[i]);
}
 5b5:	90                   	nop
 5b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5b9:	c9                   	leave  
 5ba:	c3                   	ret    

000005bb <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5bb:	55                   	push   %ebp
 5bc:	89 e5                	mov    %esp,%ebp
 5be:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5c1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5c8:	8d 45 0c             	lea    0xc(%ebp),%eax
 5cb:	83 c0 04             	add    $0x4,%eax
 5ce:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5d1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5d8:	e9 59 01 00 00       	jmp    736 <printf+0x17b>
    c = fmt[i] & 0xff;
 5dd:	8b 55 0c             	mov    0xc(%ebp),%edx
 5e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5e3:	01 d0                	add    %edx,%eax
 5e5:	0f b6 00             	movzbl (%eax),%eax
 5e8:	0f be c0             	movsbl %al,%eax
 5eb:	25 ff 00 00 00       	and    $0xff,%eax
 5f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5f3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5f7:	75 2c                	jne    625 <printf+0x6a>
      if(c == '%'){
 5f9:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5fd:	75 0c                	jne    60b <printf+0x50>
        state = '%';
 5ff:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 606:	e9 27 01 00 00       	jmp    732 <printf+0x177>
      } else {
        putc(fd, c);
 60b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 60e:	0f be c0             	movsbl %al,%eax
 611:	83 ec 08             	sub    $0x8,%esp
 614:	50                   	push   %eax
 615:	ff 75 08             	pushl  0x8(%ebp)
 618:	e8 c7 fe ff ff       	call   4e4 <putc>
 61d:	83 c4 10             	add    $0x10,%esp
 620:	e9 0d 01 00 00       	jmp    732 <printf+0x177>
      }
    } else if(state == '%'){
 625:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 629:	0f 85 03 01 00 00    	jne    732 <printf+0x177>
      if(c == 'd'){
 62f:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 633:	75 1e                	jne    653 <printf+0x98>
        printint(fd, *ap, 10, 1);
 635:	8b 45 e8             	mov    -0x18(%ebp),%eax
 638:	8b 00                	mov    (%eax),%eax
 63a:	6a 01                	push   $0x1
 63c:	6a 0a                	push   $0xa
 63e:	50                   	push   %eax
 63f:	ff 75 08             	pushl  0x8(%ebp)
 642:	e8 c0 fe ff ff       	call   507 <printint>
 647:	83 c4 10             	add    $0x10,%esp
        ap++;
 64a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 64e:	e9 d8 00 00 00       	jmp    72b <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 653:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 657:	74 06                	je     65f <printf+0xa4>
 659:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 65d:	75 1e                	jne    67d <printf+0xc2>
        printint(fd, *ap, 16, 0);
 65f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 662:	8b 00                	mov    (%eax),%eax
 664:	6a 00                	push   $0x0
 666:	6a 10                	push   $0x10
 668:	50                   	push   %eax
 669:	ff 75 08             	pushl  0x8(%ebp)
 66c:	e8 96 fe ff ff       	call   507 <printint>
 671:	83 c4 10             	add    $0x10,%esp
        ap++;
 674:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 678:	e9 ae 00 00 00       	jmp    72b <printf+0x170>
      } else if(c == 's'){
 67d:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 681:	75 43                	jne    6c6 <printf+0x10b>
        s = (char*)*ap;
 683:	8b 45 e8             	mov    -0x18(%ebp),%eax
 686:	8b 00                	mov    (%eax),%eax
 688:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 68b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 68f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 693:	75 25                	jne    6ba <printf+0xff>
          s = "(null)";
 695:	c7 45 f4 c8 09 00 00 	movl   $0x9c8,-0xc(%ebp)
        while(*s != 0){
 69c:	eb 1c                	jmp    6ba <printf+0xff>
          putc(fd, *s);
 69e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6a1:	0f b6 00             	movzbl (%eax),%eax
 6a4:	0f be c0             	movsbl %al,%eax
 6a7:	83 ec 08             	sub    $0x8,%esp
 6aa:	50                   	push   %eax
 6ab:	ff 75 08             	pushl  0x8(%ebp)
 6ae:	e8 31 fe ff ff       	call   4e4 <putc>
 6b3:	83 c4 10             	add    $0x10,%esp
          s++;
 6b6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6bd:	0f b6 00             	movzbl (%eax),%eax
 6c0:	84 c0                	test   %al,%al
 6c2:	75 da                	jne    69e <printf+0xe3>
 6c4:	eb 65                	jmp    72b <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6c6:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6ca:	75 1d                	jne    6e9 <printf+0x12e>
        putc(fd, *ap);
 6cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6cf:	8b 00                	mov    (%eax),%eax
 6d1:	0f be c0             	movsbl %al,%eax
 6d4:	83 ec 08             	sub    $0x8,%esp
 6d7:	50                   	push   %eax
 6d8:	ff 75 08             	pushl  0x8(%ebp)
 6db:	e8 04 fe ff ff       	call   4e4 <putc>
 6e0:	83 c4 10             	add    $0x10,%esp
        ap++;
 6e3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6e7:	eb 42                	jmp    72b <printf+0x170>
      } else if(c == '%'){
 6e9:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6ed:	75 17                	jne    706 <printf+0x14b>
        putc(fd, c);
 6ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6f2:	0f be c0             	movsbl %al,%eax
 6f5:	83 ec 08             	sub    $0x8,%esp
 6f8:	50                   	push   %eax
 6f9:	ff 75 08             	pushl  0x8(%ebp)
 6fc:	e8 e3 fd ff ff       	call   4e4 <putc>
 701:	83 c4 10             	add    $0x10,%esp
 704:	eb 25                	jmp    72b <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 706:	83 ec 08             	sub    $0x8,%esp
 709:	6a 25                	push   $0x25
 70b:	ff 75 08             	pushl  0x8(%ebp)
 70e:	e8 d1 fd ff ff       	call   4e4 <putc>
 713:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 716:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 719:	0f be c0             	movsbl %al,%eax
 71c:	83 ec 08             	sub    $0x8,%esp
 71f:	50                   	push   %eax
 720:	ff 75 08             	pushl  0x8(%ebp)
 723:	e8 bc fd ff ff       	call   4e4 <putc>
 728:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 72b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 732:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 736:	8b 55 0c             	mov    0xc(%ebp),%edx
 739:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73c:	01 d0                	add    %edx,%eax
 73e:	0f b6 00             	movzbl (%eax),%eax
 741:	84 c0                	test   %al,%al
 743:	0f 85 94 fe ff ff    	jne    5dd <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 749:	90                   	nop
 74a:	c9                   	leave  
 74b:	c3                   	ret    

0000074c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 74c:	55                   	push   %ebp
 74d:	89 e5                	mov    %esp,%ebp
 74f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 752:	8b 45 08             	mov    0x8(%ebp),%eax
 755:	83 e8 08             	sub    $0x8,%eax
 758:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 75b:	a1 50 0c 00 00       	mov    0xc50,%eax
 760:	89 45 fc             	mov    %eax,-0x4(%ebp)
 763:	eb 24                	jmp    789 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 765:	8b 45 fc             	mov    -0x4(%ebp),%eax
 768:	8b 00                	mov    (%eax),%eax
 76a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 76d:	77 12                	ja     781 <free+0x35>
 76f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 772:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 775:	77 24                	ja     79b <free+0x4f>
 777:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77a:	8b 00                	mov    (%eax),%eax
 77c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 77f:	77 1a                	ja     79b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 781:	8b 45 fc             	mov    -0x4(%ebp),%eax
 784:	8b 00                	mov    (%eax),%eax
 786:	89 45 fc             	mov    %eax,-0x4(%ebp)
 789:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 78f:	76 d4                	jbe    765 <free+0x19>
 791:	8b 45 fc             	mov    -0x4(%ebp),%eax
 794:	8b 00                	mov    (%eax),%eax
 796:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 799:	76 ca                	jbe    765 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 79b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79e:	8b 40 04             	mov    0x4(%eax),%eax
 7a1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ab:	01 c2                	add    %eax,%edx
 7ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b0:	8b 00                	mov    (%eax),%eax
 7b2:	39 c2                	cmp    %eax,%edx
 7b4:	75 24                	jne    7da <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b9:	8b 50 04             	mov    0x4(%eax),%edx
 7bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bf:	8b 00                	mov    (%eax),%eax
 7c1:	8b 40 04             	mov    0x4(%eax),%eax
 7c4:	01 c2                	add    %eax,%edx
 7c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c9:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cf:	8b 00                	mov    (%eax),%eax
 7d1:	8b 10                	mov    (%eax),%edx
 7d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d6:	89 10                	mov    %edx,(%eax)
 7d8:	eb 0a                	jmp    7e4 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7dd:	8b 10                	mov    (%eax),%edx
 7df:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e2:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e7:	8b 40 04             	mov    0x4(%eax),%eax
 7ea:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f4:	01 d0                	add    %edx,%eax
 7f6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7f9:	75 20                	jne    81b <free+0xcf>
    p->s.size += bp->s.size;
 7fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fe:	8b 50 04             	mov    0x4(%eax),%edx
 801:	8b 45 f8             	mov    -0x8(%ebp),%eax
 804:	8b 40 04             	mov    0x4(%eax),%eax
 807:	01 c2                	add    %eax,%edx
 809:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 80f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 812:	8b 10                	mov    (%eax),%edx
 814:	8b 45 fc             	mov    -0x4(%ebp),%eax
 817:	89 10                	mov    %edx,(%eax)
 819:	eb 08                	jmp    823 <free+0xd7>
  } else
    p->s.ptr = bp;
 81b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 821:	89 10                	mov    %edx,(%eax)
  freep = p;
 823:	8b 45 fc             	mov    -0x4(%ebp),%eax
 826:	a3 50 0c 00 00       	mov    %eax,0xc50
}
 82b:	90                   	nop
 82c:	c9                   	leave  
 82d:	c3                   	ret    

0000082e <morecore>:

static Header*
morecore(uint nu)
{
 82e:	55                   	push   %ebp
 82f:	89 e5                	mov    %esp,%ebp
 831:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 834:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 83b:	77 07                	ja     844 <morecore+0x16>
    nu = 4096;
 83d:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 844:	8b 45 08             	mov    0x8(%ebp),%eax
 847:	c1 e0 03             	shl    $0x3,%eax
 84a:	83 ec 0c             	sub    $0xc,%esp
 84d:	50                   	push   %eax
 84e:	e8 31 fc ff ff       	call   484 <sbrk>
 853:	83 c4 10             	add    $0x10,%esp
 856:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 859:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 85d:	75 07                	jne    866 <morecore+0x38>
    return 0;
 85f:	b8 00 00 00 00       	mov    $0x0,%eax
 864:	eb 26                	jmp    88c <morecore+0x5e>
  hp = (Header*)p;
 866:	8b 45 f4             	mov    -0xc(%ebp),%eax
 869:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 86c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 86f:	8b 55 08             	mov    0x8(%ebp),%edx
 872:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 875:	8b 45 f0             	mov    -0x10(%ebp),%eax
 878:	83 c0 08             	add    $0x8,%eax
 87b:	83 ec 0c             	sub    $0xc,%esp
 87e:	50                   	push   %eax
 87f:	e8 c8 fe ff ff       	call   74c <free>
 884:	83 c4 10             	add    $0x10,%esp
  return freep;
 887:	a1 50 0c 00 00       	mov    0xc50,%eax
}
 88c:	c9                   	leave  
 88d:	c3                   	ret    

0000088e <malloc>:

void*
malloc(uint nbytes)
{
 88e:	55                   	push   %ebp
 88f:	89 e5                	mov    %esp,%ebp
 891:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 894:	8b 45 08             	mov    0x8(%ebp),%eax
 897:	83 c0 07             	add    $0x7,%eax
 89a:	c1 e8 03             	shr    $0x3,%eax
 89d:	83 c0 01             	add    $0x1,%eax
 8a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8a3:	a1 50 0c 00 00       	mov    0xc50,%eax
 8a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8af:	75 23                	jne    8d4 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8b1:	c7 45 f0 48 0c 00 00 	movl   $0xc48,-0x10(%ebp)
 8b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8bb:	a3 50 0c 00 00       	mov    %eax,0xc50
 8c0:	a1 50 0c 00 00       	mov    0xc50,%eax
 8c5:	a3 48 0c 00 00       	mov    %eax,0xc48
    base.s.size = 0;
 8ca:	c7 05 4c 0c 00 00 00 	movl   $0x0,0xc4c
 8d1:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d7:	8b 00                	mov    (%eax),%eax
 8d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8df:	8b 40 04             	mov    0x4(%eax),%eax
 8e2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8e5:	72 4d                	jb     934 <malloc+0xa6>
      if(p->s.size == nunits)
 8e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ea:	8b 40 04             	mov    0x4(%eax),%eax
 8ed:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8f0:	75 0c                	jne    8fe <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f5:	8b 10                	mov    (%eax),%edx
 8f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8fa:	89 10                	mov    %edx,(%eax)
 8fc:	eb 26                	jmp    924 <malloc+0x96>
      else {
        p->s.size -= nunits;
 8fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 901:	8b 40 04             	mov    0x4(%eax),%eax
 904:	2b 45 ec             	sub    -0x14(%ebp),%eax
 907:	89 c2                	mov    %eax,%edx
 909:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 90f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 912:	8b 40 04             	mov    0x4(%eax),%eax
 915:	c1 e0 03             	shl    $0x3,%eax
 918:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 91b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91e:	8b 55 ec             	mov    -0x14(%ebp),%edx
 921:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 924:	8b 45 f0             	mov    -0x10(%ebp),%eax
 927:	a3 50 0c 00 00       	mov    %eax,0xc50
      return (void*)(p + 1);
 92c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92f:	83 c0 08             	add    $0x8,%eax
 932:	eb 3b                	jmp    96f <malloc+0xe1>
    }
    if(p == freep)
 934:	a1 50 0c 00 00       	mov    0xc50,%eax
 939:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 93c:	75 1e                	jne    95c <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 93e:	83 ec 0c             	sub    $0xc,%esp
 941:	ff 75 ec             	pushl  -0x14(%ebp)
 944:	e8 e5 fe ff ff       	call   82e <morecore>
 949:	83 c4 10             	add    $0x10,%esp
 94c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 94f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 953:	75 07                	jne    95c <malloc+0xce>
        return 0;
 955:	b8 00 00 00 00       	mov    $0x0,%eax
 95a:	eb 13                	jmp    96f <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 95c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 962:	8b 45 f4             	mov    -0xc(%ebp),%eax
 965:	8b 00                	mov    (%eax),%eax
 967:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 96a:	e9 6d ff ff ff       	jmp    8dc <malloc+0x4e>
}
 96f:	c9                   	leave  
 970:	c3                   	ret    
