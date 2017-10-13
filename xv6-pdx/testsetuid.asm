
_testsetuid:     file format elf32-i386


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
   d:	51                   	push   %ecx
   e:	83 ec 14             	sub    $0x14,%esp
  
  uint uid, gid, ppid;

  uid = getuid();
  11:	e8 b3 05 00 00       	call   5c9 <getuid>
  16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(1, "Current UID is: %d\n", uid);
  19:	83 ec 04             	sub    $0x4,%esp
  1c:	ff 75 f4             	pushl  -0xc(%ebp)
  1f:	68 88 0a 00 00       	push   $0xa88
  24:	6a 01                	push   $0x1
  26:	e8 a5 06 00 00       	call   6d0 <printf>
  2b:	83 c4 10             	add    $0x10,%esp
  printf(1, "Setting UID to 100\n");
  2e:	83 ec 08             	sub    $0x8,%esp
  31:	68 9c 0a 00 00       	push   $0xa9c
  36:	6a 01                	push   $0x1
  38:	e8 93 06 00 00       	call   6d0 <printf>
  3d:	83 c4 10             	add    $0x10,%esp
  if(setuid(100) == -1) {
  40:	83 ec 0c             	sub    $0xc,%esp
  43:	6a 64                	push   $0x64
  45:	e8 97 05 00 00       	call   5e1 <setuid>
  4a:	83 c4 10             	add    $0x10,%esp
  4d:	83 f8 ff             	cmp    $0xffffffff,%eax
  50:	75 17                	jne    69 <main+0x69>
    printf(1, "Setting UID failed. Test FAILED.\n");
  52:	83 ec 08             	sub    $0x8,%esp
  55:	68 b0 0a 00 00       	push   $0xab0
  5a:	6a 01                	push   $0x1
  5c:	e8 6f 06 00 00       	call   6d0 <printf>
  61:	83 c4 10             	add    $0x10,%esp
    exit();
  64:	e8 b0 04 00 00       	call   519 <exit>
  }
  uid = getuid();
  69:	e8 5b 05 00 00       	call   5c9 <getuid>
  6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(1, "Current UID is: %d\n", uid);
  71:	83 ec 04             	sub    $0x4,%esp
  74:	ff 75 f4             	pushl  -0xc(%ebp)
  77:	68 88 0a 00 00       	push   $0xa88
  7c:	6a 01                	push   $0x1
  7e:	e8 4d 06 00 00       	call   6d0 <printf>
  83:	83 c4 10             	add    $0x10,%esp
  printf(1, "Setting UID to 32,768\n");
  86:	83 ec 08             	sub    $0x8,%esp
  89:	68 d2 0a 00 00       	push   $0xad2
  8e:	6a 01                	push   $0x1
  90:	e8 3b 06 00 00       	call   6d0 <printf>
  95:	83 c4 10             	add    $0x10,%esp
  if(setuid(32768) == 0) {
  98:	83 ec 0c             	sub    $0xc,%esp
  9b:	68 00 80 00 00       	push   $0x8000
  a0:	e8 3c 05 00 00       	call   5e1 <setuid>
  a5:	83 c4 10             	add    $0x10,%esp
  a8:	85 c0                	test   %eax,%eax
  aa:	75 17                	jne    c3 <main+0xc3>
    printf(1, "Setting UID succeeded. Set should fail. Test FAILED.\n");
  ac:	83 ec 08             	sub    $0x8,%esp
  af:	68 ec 0a 00 00       	push   $0xaec
  b4:	6a 01                	push   $0x1
  b6:	e8 15 06 00 00       	call   6d0 <printf>
  bb:	83 c4 10             	add    $0x10,%esp
    exit();
  be:	e8 56 04 00 00       	call   519 <exit>
  }
  else
    printf(1, "Not allowed to set UID to 32,768. PASSED.\n");
  c3:	83 ec 08             	sub    $0x8,%esp
  c6:	68 24 0b 00 00       	push   $0xb24
  cb:	6a 01                	push   $0x1
  cd:	e8 fe 05 00 00       	call   6d0 <printf>
  d2:	83 c4 10             	add    $0x10,%esp
  printf(1, "Setting UID to -1\n");
  d5:	83 ec 08             	sub    $0x8,%esp
  d8:	68 4f 0b 00 00       	push   $0xb4f
  dd:	6a 01                	push   $0x1
  df:	e8 ec 05 00 00       	call   6d0 <printf>
  e4:	83 c4 10             	add    $0x10,%esp
  if(setuid(-1) == 0) {
  e7:	83 ec 0c             	sub    $0xc,%esp
  ea:	6a ff                	push   $0xffffffff
  ec:	e8 f0 04 00 00       	call   5e1 <setuid>
  f1:	83 c4 10             	add    $0x10,%esp
  f4:	85 c0                	test   %eax,%eax
  f6:	75 17                	jne    10f <main+0x10f>
    printf(1, "Setting UID succeeded.  Set should fail. Test FAILED.\n");
  f8:	83 ec 08             	sub    $0x8,%esp
  fb:	68 64 0b 00 00       	push   $0xb64
 100:	6a 01                	push   $0x1
 102:	e8 c9 05 00 00       	call   6d0 <printf>
 107:	83 c4 10             	add    $0x10,%esp
    exit();
 10a:	e8 0a 04 00 00       	call   519 <exit>
  }
  else
    printf(1, "Not allowed to set UID to -1. PASSED.\n");
 10f:	83 ec 08             	sub    $0x8,%esp
 112:	68 9c 0b 00 00       	push   $0xb9c
 117:	6a 01                	push   $0x1
 119:	e8 b2 05 00 00       	call   6d0 <printf>
 11e:	83 c4 10             	add    $0x10,%esp

  gid = getgid();
 121:	e8 ab 04 00 00       	call   5d1 <getgid>
 126:	89 45 f0             	mov    %eax,-0x10(%ebp)
  printf(1, "Current GID is: %d\n", gid);
 129:	83 ec 04             	sub    $0x4,%esp
 12c:	ff 75 f0             	pushl  -0x10(%ebp)
 12f:	68 c3 0b 00 00       	push   $0xbc3
 134:	6a 01                	push   $0x1
 136:	e8 95 05 00 00       	call   6d0 <printf>
 13b:	83 c4 10             	add    $0x10,%esp
  printf(1, "Setting GID to 100\n");
 13e:	83 ec 08             	sub    $0x8,%esp
 141:	68 d7 0b 00 00       	push   $0xbd7
 146:	6a 01                	push   $0x1
 148:	e8 83 05 00 00       	call   6d0 <printf>
 14d:	83 c4 10             	add    $0x10,%esp
  if(setgid(100) == -1) {
 150:	83 ec 0c             	sub    $0xc,%esp
 153:	6a 64                	push   $0x64
 155:	e8 8f 04 00 00       	call   5e9 <setgid>
 15a:	83 c4 10             	add    $0x10,%esp
 15d:	83 f8 ff             	cmp    $0xffffffff,%eax
 160:	75 17                	jne    179 <main+0x179>
    printf(1, "Setting GID failed. Test FAILED.\n");
 162:	83 ec 08             	sub    $0x8,%esp
 165:	68 ec 0b 00 00       	push   $0xbec
 16a:	6a 01                	push   $0x1
 16c:	e8 5f 05 00 00       	call   6d0 <printf>
 171:	83 c4 10             	add    $0x10,%esp
    exit();
 174:	e8 a0 03 00 00       	call   519 <exit>
  }
  gid = getgid();
 179:	e8 53 04 00 00       	call   5d1 <getgid>
 17e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  printf(1, "Current GID is: %d\n", gid);
 181:	83 ec 04             	sub    $0x4,%esp
 184:	ff 75 f0             	pushl  -0x10(%ebp)
 187:	68 c3 0b 00 00       	push   $0xbc3
 18c:	6a 01                	push   $0x1
 18e:	e8 3d 05 00 00       	call   6d0 <printf>
 193:	83 c4 10             	add    $0x10,%esp
  printf(1, "Setting GID to 32,768\n");
 196:	83 ec 08             	sub    $0x8,%esp
 199:	68 0e 0c 00 00       	push   $0xc0e
 19e:	6a 01                	push   $0x1
 1a0:	e8 2b 05 00 00       	call   6d0 <printf>
 1a5:	83 c4 10             	add    $0x10,%esp
  if(setgid(32768) == 0) {
 1a8:	83 ec 0c             	sub    $0xc,%esp
 1ab:	68 00 80 00 00       	push   $0x8000
 1b0:	e8 34 04 00 00       	call   5e9 <setgid>
 1b5:	83 c4 10             	add    $0x10,%esp
 1b8:	85 c0                	test   %eax,%eax
 1ba:	75 17                	jne    1d3 <main+0x1d3>
    printf(1, "Setting GID succeeded. Set should fail. Test FAILED.\n");
 1bc:	83 ec 08             	sub    $0x8,%esp
 1bf:	68 28 0c 00 00       	push   $0xc28
 1c4:	6a 01                	push   $0x1
 1c6:	e8 05 05 00 00       	call   6d0 <printf>
 1cb:	83 c4 10             	add    $0x10,%esp
    exit();
 1ce:	e8 46 03 00 00       	call   519 <exit>
  }
  else
    printf(1, "Not allowed to set GID to 32,768. PASSED.\n");
 1d3:	83 ec 08             	sub    $0x8,%esp
 1d6:	68 60 0c 00 00       	push   $0xc60
 1db:	6a 01                	push   $0x1
 1dd:	e8 ee 04 00 00       	call   6d0 <printf>
 1e2:	83 c4 10             	add    $0x10,%esp
  printf(1, "Setting GID to -1\n");
 1e5:	83 ec 08             	sub    $0x8,%esp
 1e8:	68 8b 0c 00 00       	push   $0xc8b
 1ed:	6a 01                	push   $0x1
 1ef:	e8 dc 04 00 00       	call   6d0 <printf>
 1f4:	83 c4 10             	add    $0x10,%esp
  if(setgid(-1) == 0) {
 1f7:	83 ec 0c             	sub    $0xc,%esp
 1fa:	6a ff                	push   $0xffffffff
 1fc:	e8 e8 03 00 00       	call   5e9 <setgid>
 201:	83 c4 10             	add    $0x10,%esp
 204:	85 c0                	test   %eax,%eax
 206:	75 17                	jne    21f <main+0x21f>
    printf(1, "Setting GID succeeded.  Set should fail. Test FAILED.\n");
 208:	83 ec 08             	sub    $0x8,%esp
 20b:	68 a0 0c 00 00       	push   $0xca0
 210:	6a 01                	push   $0x1
 212:	e8 b9 04 00 00       	call   6d0 <printf>
 217:	83 c4 10             	add    $0x10,%esp
    exit();
 21a:	e8 fa 02 00 00       	call   519 <exit>
  }
  else
    printf(1, "Not allowed to set GID to -1. PASSED.\n");
 21f:	83 ec 08             	sub    $0x8,%esp
 222:	68 d8 0c 00 00       	push   $0xcd8
 227:	6a 01                	push   $0x1
 229:	e8 a2 04 00 00       	call   6d0 <printf>
 22e:	83 c4 10             	add    $0x10,%esp
  
  ppid = getppid();
 231:	e8 a3 03 00 00       	call   5d9 <getppid>
 236:	89 45 ec             	mov    %eax,-0x14(%ebp)
  printf(1, "My process ID is: %d\n", getpid());
 239:	e8 5b 03 00 00       	call   599 <getpid>
 23e:	83 ec 04             	sub    $0x4,%esp
 241:	50                   	push   %eax
 242:	68 ff 0c 00 00       	push   $0xcff
 247:	6a 01                	push   $0x1
 249:	e8 82 04 00 00       	call   6d0 <printf>
 24e:	83 c4 10             	add    $0x10,%esp
  printf(1, "My parent process ID is: %d\n", ppid);
 251:	83 ec 04             	sub    $0x4,%esp
 254:	ff 75 ec             	pushl  -0x14(%ebp)
 257:	68 15 0d 00 00       	push   $0xd15
 25c:	6a 01                	push   $0x1
 25e:	e8 6d 04 00 00       	call   6d0 <printf>
 263:	83 c4 10             	add    $0x10,%esp
  printf(1, "Done!\n");
 266:	83 ec 08             	sub    $0x8,%esp
 269:	68 32 0d 00 00       	push   $0xd32
 26e:	6a 01                	push   $0x1
 270:	e8 5b 04 00 00       	call   6d0 <printf>
 275:	83 c4 10             	add    $0x10,%esp

  exit();
 278:	e8 9c 02 00 00       	call   519 <exit>

0000027d <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 27d:	55                   	push   %ebp
 27e:	89 e5                	mov    %esp,%ebp
 280:	57                   	push   %edi
 281:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 282:	8b 4d 08             	mov    0x8(%ebp),%ecx
 285:	8b 55 10             	mov    0x10(%ebp),%edx
 288:	8b 45 0c             	mov    0xc(%ebp),%eax
 28b:	89 cb                	mov    %ecx,%ebx
 28d:	89 df                	mov    %ebx,%edi
 28f:	89 d1                	mov    %edx,%ecx
 291:	fc                   	cld    
 292:	f3 aa                	rep stos %al,%es:(%edi)
 294:	89 ca                	mov    %ecx,%edx
 296:	89 fb                	mov    %edi,%ebx
 298:	89 5d 08             	mov    %ebx,0x8(%ebp)
 29b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 29e:	90                   	nop
 29f:	5b                   	pop    %ebx
 2a0:	5f                   	pop    %edi
 2a1:	5d                   	pop    %ebp
 2a2:	c3                   	ret    

000002a3 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 2a3:	55                   	push   %ebp
 2a4:	89 e5                	mov    %esp,%ebp
 2a6:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 2a9:	8b 45 08             	mov    0x8(%ebp),%eax
 2ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 2af:	90                   	nop
 2b0:	8b 45 08             	mov    0x8(%ebp),%eax
 2b3:	8d 50 01             	lea    0x1(%eax),%edx
 2b6:	89 55 08             	mov    %edx,0x8(%ebp)
 2b9:	8b 55 0c             	mov    0xc(%ebp),%edx
 2bc:	8d 4a 01             	lea    0x1(%edx),%ecx
 2bf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 2c2:	0f b6 12             	movzbl (%edx),%edx
 2c5:	88 10                	mov    %dl,(%eax)
 2c7:	0f b6 00             	movzbl (%eax),%eax
 2ca:	84 c0                	test   %al,%al
 2cc:	75 e2                	jne    2b0 <strcpy+0xd>
    ;
  return os;
 2ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2d1:	c9                   	leave  
 2d2:	c3                   	ret    

000002d3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2d3:	55                   	push   %ebp
 2d4:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 2d6:	eb 08                	jmp    2e0 <strcmp+0xd>
    p++, q++;
 2d8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2dc:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 2e0:	8b 45 08             	mov    0x8(%ebp),%eax
 2e3:	0f b6 00             	movzbl (%eax),%eax
 2e6:	84 c0                	test   %al,%al
 2e8:	74 10                	je     2fa <strcmp+0x27>
 2ea:	8b 45 08             	mov    0x8(%ebp),%eax
 2ed:	0f b6 10             	movzbl (%eax),%edx
 2f0:	8b 45 0c             	mov    0xc(%ebp),%eax
 2f3:	0f b6 00             	movzbl (%eax),%eax
 2f6:	38 c2                	cmp    %al,%dl
 2f8:	74 de                	je     2d8 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 2fa:	8b 45 08             	mov    0x8(%ebp),%eax
 2fd:	0f b6 00             	movzbl (%eax),%eax
 300:	0f b6 d0             	movzbl %al,%edx
 303:	8b 45 0c             	mov    0xc(%ebp),%eax
 306:	0f b6 00             	movzbl (%eax),%eax
 309:	0f b6 c0             	movzbl %al,%eax
 30c:	29 c2                	sub    %eax,%edx
 30e:	89 d0                	mov    %edx,%eax
}
 310:	5d                   	pop    %ebp
 311:	c3                   	ret    

00000312 <strlen>:

uint
strlen(char *s)
{
 312:	55                   	push   %ebp
 313:	89 e5                	mov    %esp,%ebp
 315:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 318:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 31f:	eb 04                	jmp    325 <strlen+0x13>
 321:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 325:	8b 55 fc             	mov    -0x4(%ebp),%edx
 328:	8b 45 08             	mov    0x8(%ebp),%eax
 32b:	01 d0                	add    %edx,%eax
 32d:	0f b6 00             	movzbl (%eax),%eax
 330:	84 c0                	test   %al,%al
 332:	75 ed                	jne    321 <strlen+0xf>
    ;
  return n;
 334:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 337:	c9                   	leave  
 338:	c3                   	ret    

00000339 <memset>:

void*
memset(void *dst, int c, uint n)
{
 339:	55                   	push   %ebp
 33a:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 33c:	8b 45 10             	mov    0x10(%ebp),%eax
 33f:	50                   	push   %eax
 340:	ff 75 0c             	pushl  0xc(%ebp)
 343:	ff 75 08             	pushl  0x8(%ebp)
 346:	e8 32 ff ff ff       	call   27d <stosb>
 34b:	83 c4 0c             	add    $0xc,%esp
  return dst;
 34e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 351:	c9                   	leave  
 352:	c3                   	ret    

00000353 <strchr>:

char*
strchr(const char *s, char c)
{
 353:	55                   	push   %ebp
 354:	89 e5                	mov    %esp,%ebp
 356:	83 ec 04             	sub    $0x4,%esp
 359:	8b 45 0c             	mov    0xc(%ebp),%eax
 35c:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 35f:	eb 14                	jmp    375 <strchr+0x22>
    if(*s == c)
 361:	8b 45 08             	mov    0x8(%ebp),%eax
 364:	0f b6 00             	movzbl (%eax),%eax
 367:	3a 45 fc             	cmp    -0x4(%ebp),%al
 36a:	75 05                	jne    371 <strchr+0x1e>
      return (char*)s;
 36c:	8b 45 08             	mov    0x8(%ebp),%eax
 36f:	eb 13                	jmp    384 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 371:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 375:	8b 45 08             	mov    0x8(%ebp),%eax
 378:	0f b6 00             	movzbl (%eax),%eax
 37b:	84 c0                	test   %al,%al
 37d:	75 e2                	jne    361 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 37f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 384:	c9                   	leave  
 385:	c3                   	ret    

00000386 <gets>:

char*
gets(char *buf, int max)
{
 386:	55                   	push   %ebp
 387:	89 e5                	mov    %esp,%ebp
 389:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 38c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 393:	eb 42                	jmp    3d7 <gets+0x51>
    cc = read(0, &c, 1);
 395:	83 ec 04             	sub    $0x4,%esp
 398:	6a 01                	push   $0x1
 39a:	8d 45 ef             	lea    -0x11(%ebp),%eax
 39d:	50                   	push   %eax
 39e:	6a 00                	push   $0x0
 3a0:	e8 8c 01 00 00       	call   531 <read>
 3a5:	83 c4 10             	add    $0x10,%esp
 3a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 3ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3af:	7e 33                	jle    3e4 <gets+0x5e>
      break;
    buf[i++] = c;
 3b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3b4:	8d 50 01             	lea    0x1(%eax),%edx
 3b7:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3ba:	89 c2                	mov    %eax,%edx
 3bc:	8b 45 08             	mov    0x8(%ebp),%eax
 3bf:	01 c2                	add    %eax,%edx
 3c1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3c5:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 3c7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3cb:	3c 0a                	cmp    $0xa,%al
 3cd:	74 16                	je     3e5 <gets+0x5f>
 3cf:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3d3:	3c 0d                	cmp    $0xd,%al
 3d5:	74 0e                	je     3e5 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3da:	83 c0 01             	add    $0x1,%eax
 3dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
 3e0:	7c b3                	jl     395 <gets+0xf>
 3e2:	eb 01                	jmp    3e5 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 3e4:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 3e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3e8:	8b 45 08             	mov    0x8(%ebp),%eax
 3eb:	01 d0                	add    %edx,%eax
 3ed:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 3f0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3f3:	c9                   	leave  
 3f4:	c3                   	ret    

000003f5 <stat>:

int
stat(char *n, struct stat *st)
{
 3f5:	55                   	push   %ebp
 3f6:	89 e5                	mov    %esp,%ebp
 3f8:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3fb:	83 ec 08             	sub    $0x8,%esp
 3fe:	6a 00                	push   $0x0
 400:	ff 75 08             	pushl  0x8(%ebp)
 403:	e8 51 01 00 00       	call   559 <open>
 408:	83 c4 10             	add    $0x10,%esp
 40b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 40e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 412:	79 07                	jns    41b <stat+0x26>
    return -1;
 414:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 419:	eb 25                	jmp    440 <stat+0x4b>
  r = fstat(fd, st);
 41b:	83 ec 08             	sub    $0x8,%esp
 41e:	ff 75 0c             	pushl  0xc(%ebp)
 421:	ff 75 f4             	pushl  -0xc(%ebp)
 424:	e8 48 01 00 00       	call   571 <fstat>
 429:	83 c4 10             	add    $0x10,%esp
 42c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 42f:	83 ec 0c             	sub    $0xc,%esp
 432:	ff 75 f4             	pushl  -0xc(%ebp)
 435:	e8 07 01 00 00       	call   541 <close>
 43a:	83 c4 10             	add    $0x10,%esp
  return r;
 43d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 440:	c9                   	leave  
 441:	c3                   	ret    

00000442 <atoi>:

int
atoi(const char *s)
{
 442:	55                   	push   %ebp
 443:	89 e5                	mov    %esp,%ebp
 445:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 448:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 44f:	eb 04                	jmp    455 <atoi+0x13>
 451:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 455:	8b 45 08             	mov    0x8(%ebp),%eax
 458:	0f b6 00             	movzbl (%eax),%eax
 45b:	3c 20                	cmp    $0x20,%al
 45d:	74 f2                	je     451 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 45f:	8b 45 08             	mov    0x8(%ebp),%eax
 462:	0f b6 00             	movzbl (%eax),%eax
 465:	3c 2d                	cmp    $0x2d,%al
 467:	75 07                	jne    470 <atoi+0x2e>
 469:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 46e:	eb 05                	jmp    475 <atoi+0x33>
 470:	b8 01 00 00 00       	mov    $0x1,%eax
 475:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 478:	8b 45 08             	mov    0x8(%ebp),%eax
 47b:	0f b6 00             	movzbl (%eax),%eax
 47e:	3c 2b                	cmp    $0x2b,%al
 480:	74 0a                	je     48c <atoi+0x4a>
 482:	8b 45 08             	mov    0x8(%ebp),%eax
 485:	0f b6 00             	movzbl (%eax),%eax
 488:	3c 2d                	cmp    $0x2d,%al
 48a:	75 2b                	jne    4b7 <atoi+0x75>
    s++;
 48c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 490:	eb 25                	jmp    4b7 <atoi+0x75>
    n = n*10 + *s++ - '0';
 492:	8b 55 fc             	mov    -0x4(%ebp),%edx
 495:	89 d0                	mov    %edx,%eax
 497:	c1 e0 02             	shl    $0x2,%eax
 49a:	01 d0                	add    %edx,%eax
 49c:	01 c0                	add    %eax,%eax
 49e:	89 c1                	mov    %eax,%ecx
 4a0:	8b 45 08             	mov    0x8(%ebp),%eax
 4a3:	8d 50 01             	lea    0x1(%eax),%edx
 4a6:	89 55 08             	mov    %edx,0x8(%ebp)
 4a9:	0f b6 00             	movzbl (%eax),%eax
 4ac:	0f be c0             	movsbl %al,%eax
 4af:	01 c8                	add    %ecx,%eax
 4b1:	83 e8 30             	sub    $0x30,%eax
 4b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 4b7:	8b 45 08             	mov    0x8(%ebp),%eax
 4ba:	0f b6 00             	movzbl (%eax),%eax
 4bd:	3c 2f                	cmp    $0x2f,%al
 4bf:	7e 0a                	jle    4cb <atoi+0x89>
 4c1:	8b 45 08             	mov    0x8(%ebp),%eax
 4c4:	0f b6 00             	movzbl (%eax),%eax
 4c7:	3c 39                	cmp    $0x39,%al
 4c9:	7e c7                	jle    492 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 4cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 4ce:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 4d2:	c9                   	leave  
 4d3:	c3                   	ret    

000004d4 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 4d4:	55                   	push   %ebp
 4d5:	89 e5                	mov    %esp,%ebp
 4d7:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 4da:	8b 45 08             	mov    0x8(%ebp),%eax
 4dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 4e0:	8b 45 0c             	mov    0xc(%ebp),%eax
 4e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 4e6:	eb 17                	jmp    4ff <memmove+0x2b>
    *dst++ = *src++;
 4e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4eb:	8d 50 01             	lea    0x1(%eax),%edx
 4ee:	89 55 fc             	mov    %edx,-0x4(%ebp)
 4f1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 4f4:	8d 4a 01             	lea    0x1(%edx),%ecx
 4f7:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 4fa:	0f b6 12             	movzbl (%edx),%edx
 4fd:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4ff:	8b 45 10             	mov    0x10(%ebp),%eax
 502:	8d 50 ff             	lea    -0x1(%eax),%edx
 505:	89 55 10             	mov    %edx,0x10(%ebp)
 508:	85 c0                	test   %eax,%eax
 50a:	7f dc                	jg     4e8 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 50c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 50f:	c9                   	leave  
 510:	c3                   	ret    

00000511 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 511:	b8 01 00 00 00       	mov    $0x1,%eax
 516:	cd 40                	int    $0x40
 518:	c3                   	ret    

00000519 <exit>:
SYSCALL(exit)
 519:	b8 02 00 00 00       	mov    $0x2,%eax
 51e:	cd 40                	int    $0x40
 520:	c3                   	ret    

00000521 <wait>:
SYSCALL(wait)
 521:	b8 03 00 00 00       	mov    $0x3,%eax
 526:	cd 40                	int    $0x40
 528:	c3                   	ret    

00000529 <pipe>:
SYSCALL(pipe)
 529:	b8 04 00 00 00       	mov    $0x4,%eax
 52e:	cd 40                	int    $0x40
 530:	c3                   	ret    

00000531 <read>:
SYSCALL(read)
 531:	b8 05 00 00 00       	mov    $0x5,%eax
 536:	cd 40                	int    $0x40
 538:	c3                   	ret    

00000539 <write>:
SYSCALL(write)
 539:	b8 10 00 00 00       	mov    $0x10,%eax
 53e:	cd 40                	int    $0x40
 540:	c3                   	ret    

00000541 <close>:
SYSCALL(close)
 541:	b8 15 00 00 00       	mov    $0x15,%eax
 546:	cd 40                	int    $0x40
 548:	c3                   	ret    

00000549 <kill>:
SYSCALL(kill)
 549:	b8 06 00 00 00       	mov    $0x6,%eax
 54e:	cd 40                	int    $0x40
 550:	c3                   	ret    

00000551 <exec>:
SYSCALL(exec)
 551:	b8 07 00 00 00       	mov    $0x7,%eax
 556:	cd 40                	int    $0x40
 558:	c3                   	ret    

00000559 <open>:
SYSCALL(open)
 559:	b8 0f 00 00 00       	mov    $0xf,%eax
 55e:	cd 40                	int    $0x40
 560:	c3                   	ret    

00000561 <mknod>:
SYSCALL(mknod)
 561:	b8 11 00 00 00       	mov    $0x11,%eax
 566:	cd 40                	int    $0x40
 568:	c3                   	ret    

00000569 <unlink>:
SYSCALL(unlink)
 569:	b8 12 00 00 00       	mov    $0x12,%eax
 56e:	cd 40                	int    $0x40
 570:	c3                   	ret    

00000571 <fstat>:
SYSCALL(fstat)
 571:	b8 08 00 00 00       	mov    $0x8,%eax
 576:	cd 40                	int    $0x40
 578:	c3                   	ret    

00000579 <link>:
SYSCALL(link)
 579:	b8 13 00 00 00       	mov    $0x13,%eax
 57e:	cd 40                	int    $0x40
 580:	c3                   	ret    

00000581 <mkdir>:
SYSCALL(mkdir)
 581:	b8 14 00 00 00       	mov    $0x14,%eax
 586:	cd 40                	int    $0x40
 588:	c3                   	ret    

00000589 <chdir>:
SYSCALL(chdir)
 589:	b8 09 00 00 00       	mov    $0x9,%eax
 58e:	cd 40                	int    $0x40
 590:	c3                   	ret    

00000591 <dup>:
SYSCALL(dup)
 591:	b8 0a 00 00 00       	mov    $0xa,%eax
 596:	cd 40                	int    $0x40
 598:	c3                   	ret    

00000599 <getpid>:
SYSCALL(getpid)
 599:	b8 0b 00 00 00       	mov    $0xb,%eax
 59e:	cd 40                	int    $0x40
 5a0:	c3                   	ret    

000005a1 <sbrk>:
SYSCALL(sbrk)
 5a1:	b8 0c 00 00 00       	mov    $0xc,%eax
 5a6:	cd 40                	int    $0x40
 5a8:	c3                   	ret    

000005a9 <sleep>:
SYSCALL(sleep)
 5a9:	b8 0d 00 00 00       	mov    $0xd,%eax
 5ae:	cd 40                	int    $0x40
 5b0:	c3                   	ret    

000005b1 <uptime>:
SYSCALL(uptime)
 5b1:	b8 0e 00 00 00       	mov    $0xe,%eax
 5b6:	cd 40                	int    $0x40
 5b8:	c3                   	ret    

000005b9 <halt>:
SYSCALL(halt)
 5b9:	b8 16 00 00 00       	mov    $0x16,%eax
 5be:	cd 40                	int    $0x40
 5c0:	c3                   	ret    

000005c1 <date>:
SYSCALL(date)
 5c1:	b8 17 00 00 00       	mov    $0x17,%eax
 5c6:	cd 40                	int    $0x40
 5c8:	c3                   	ret    

000005c9 <getuid>:
SYSCALL(getuid)
 5c9:	b8 18 00 00 00       	mov    $0x18,%eax
 5ce:	cd 40                	int    $0x40
 5d0:	c3                   	ret    

000005d1 <getgid>:
SYSCALL(getgid)
 5d1:	b8 19 00 00 00       	mov    $0x19,%eax
 5d6:	cd 40                	int    $0x40
 5d8:	c3                   	ret    

000005d9 <getppid>:
SYSCALL(getppid)
 5d9:	b8 1a 00 00 00       	mov    $0x1a,%eax
 5de:	cd 40                	int    $0x40
 5e0:	c3                   	ret    

000005e1 <setuid>:
SYSCALL(setuid)
 5e1:	b8 1b 00 00 00       	mov    $0x1b,%eax
 5e6:	cd 40                	int    $0x40
 5e8:	c3                   	ret    

000005e9 <setgid>:
SYSCALL(setgid)
 5e9:	b8 1c 00 00 00       	mov    $0x1c,%eax
 5ee:	cd 40                	int    $0x40
 5f0:	c3                   	ret    

000005f1 <getprocs>:
SYSCALL(getprocs)
 5f1:	b8 1d 00 00 00       	mov    $0x1d,%eax
 5f6:	cd 40                	int    $0x40
 5f8:	c3                   	ret    

000005f9 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 5f9:	55                   	push   %ebp
 5fa:	89 e5                	mov    %esp,%ebp
 5fc:	83 ec 18             	sub    $0x18,%esp
 5ff:	8b 45 0c             	mov    0xc(%ebp),%eax
 602:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 605:	83 ec 04             	sub    $0x4,%esp
 608:	6a 01                	push   $0x1
 60a:	8d 45 f4             	lea    -0xc(%ebp),%eax
 60d:	50                   	push   %eax
 60e:	ff 75 08             	pushl  0x8(%ebp)
 611:	e8 23 ff ff ff       	call   539 <write>
 616:	83 c4 10             	add    $0x10,%esp
}
 619:	90                   	nop
 61a:	c9                   	leave  
 61b:	c3                   	ret    

0000061c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 61c:	55                   	push   %ebp
 61d:	89 e5                	mov    %esp,%ebp
 61f:	53                   	push   %ebx
 620:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 623:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 62a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 62e:	74 17                	je     647 <printint+0x2b>
 630:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 634:	79 11                	jns    647 <printint+0x2b>
    neg = 1;
 636:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 63d:	8b 45 0c             	mov    0xc(%ebp),%eax
 640:	f7 d8                	neg    %eax
 642:	89 45 ec             	mov    %eax,-0x14(%ebp)
 645:	eb 06                	jmp    64d <printint+0x31>
  } else {
    x = xx;
 647:	8b 45 0c             	mov    0xc(%ebp),%eax
 64a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 64d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 654:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 657:	8d 41 01             	lea    0x1(%ecx),%eax
 65a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 65d:	8b 5d 10             	mov    0x10(%ebp),%ebx
 660:	8b 45 ec             	mov    -0x14(%ebp),%eax
 663:	ba 00 00 00 00       	mov    $0x0,%edx
 668:	f7 f3                	div    %ebx
 66a:	89 d0                	mov    %edx,%eax
 66c:	0f b6 80 88 0f 00 00 	movzbl 0xf88(%eax),%eax
 673:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 677:	8b 5d 10             	mov    0x10(%ebp),%ebx
 67a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 67d:	ba 00 00 00 00       	mov    $0x0,%edx
 682:	f7 f3                	div    %ebx
 684:	89 45 ec             	mov    %eax,-0x14(%ebp)
 687:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 68b:	75 c7                	jne    654 <printint+0x38>
  if(neg)
 68d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 691:	74 2d                	je     6c0 <printint+0xa4>
    buf[i++] = '-';
 693:	8b 45 f4             	mov    -0xc(%ebp),%eax
 696:	8d 50 01             	lea    0x1(%eax),%edx
 699:	89 55 f4             	mov    %edx,-0xc(%ebp)
 69c:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6a1:	eb 1d                	jmp    6c0 <printint+0xa4>
    putc(fd, buf[i]);
 6a3:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6a9:	01 d0                	add    %edx,%eax
 6ab:	0f b6 00             	movzbl (%eax),%eax
 6ae:	0f be c0             	movsbl %al,%eax
 6b1:	83 ec 08             	sub    $0x8,%esp
 6b4:	50                   	push   %eax
 6b5:	ff 75 08             	pushl  0x8(%ebp)
 6b8:	e8 3c ff ff ff       	call   5f9 <putc>
 6bd:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6c0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 6c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6c8:	79 d9                	jns    6a3 <printint+0x87>
    putc(fd, buf[i]);
}
 6ca:	90                   	nop
 6cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6ce:	c9                   	leave  
 6cf:	c3                   	ret    

000006d0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6d0:	55                   	push   %ebp
 6d1:	89 e5                	mov    %esp,%ebp
 6d3:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 6d6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 6dd:	8d 45 0c             	lea    0xc(%ebp),%eax
 6e0:	83 c0 04             	add    $0x4,%eax
 6e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 6e6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 6ed:	e9 59 01 00 00       	jmp    84b <printf+0x17b>
    c = fmt[i] & 0xff;
 6f2:	8b 55 0c             	mov    0xc(%ebp),%edx
 6f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6f8:	01 d0                	add    %edx,%eax
 6fa:	0f b6 00             	movzbl (%eax),%eax
 6fd:	0f be c0             	movsbl %al,%eax
 700:	25 ff 00 00 00       	and    $0xff,%eax
 705:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 708:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 70c:	75 2c                	jne    73a <printf+0x6a>
      if(c == '%'){
 70e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 712:	75 0c                	jne    720 <printf+0x50>
        state = '%';
 714:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 71b:	e9 27 01 00 00       	jmp    847 <printf+0x177>
      } else {
        putc(fd, c);
 720:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 723:	0f be c0             	movsbl %al,%eax
 726:	83 ec 08             	sub    $0x8,%esp
 729:	50                   	push   %eax
 72a:	ff 75 08             	pushl  0x8(%ebp)
 72d:	e8 c7 fe ff ff       	call   5f9 <putc>
 732:	83 c4 10             	add    $0x10,%esp
 735:	e9 0d 01 00 00       	jmp    847 <printf+0x177>
      }
    } else if(state == '%'){
 73a:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 73e:	0f 85 03 01 00 00    	jne    847 <printf+0x177>
      if(c == 'd'){
 744:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 748:	75 1e                	jne    768 <printf+0x98>
        printint(fd, *ap, 10, 1);
 74a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 74d:	8b 00                	mov    (%eax),%eax
 74f:	6a 01                	push   $0x1
 751:	6a 0a                	push   $0xa
 753:	50                   	push   %eax
 754:	ff 75 08             	pushl  0x8(%ebp)
 757:	e8 c0 fe ff ff       	call   61c <printint>
 75c:	83 c4 10             	add    $0x10,%esp
        ap++;
 75f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 763:	e9 d8 00 00 00       	jmp    840 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 768:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 76c:	74 06                	je     774 <printf+0xa4>
 76e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 772:	75 1e                	jne    792 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 774:	8b 45 e8             	mov    -0x18(%ebp),%eax
 777:	8b 00                	mov    (%eax),%eax
 779:	6a 00                	push   $0x0
 77b:	6a 10                	push   $0x10
 77d:	50                   	push   %eax
 77e:	ff 75 08             	pushl  0x8(%ebp)
 781:	e8 96 fe ff ff       	call   61c <printint>
 786:	83 c4 10             	add    $0x10,%esp
        ap++;
 789:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 78d:	e9 ae 00 00 00       	jmp    840 <printf+0x170>
      } else if(c == 's'){
 792:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 796:	75 43                	jne    7db <printf+0x10b>
        s = (char*)*ap;
 798:	8b 45 e8             	mov    -0x18(%ebp),%eax
 79b:	8b 00                	mov    (%eax),%eax
 79d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7a0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7a8:	75 25                	jne    7cf <printf+0xff>
          s = "(null)";
 7aa:	c7 45 f4 39 0d 00 00 	movl   $0xd39,-0xc(%ebp)
        while(*s != 0){
 7b1:	eb 1c                	jmp    7cf <printf+0xff>
          putc(fd, *s);
 7b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b6:	0f b6 00             	movzbl (%eax),%eax
 7b9:	0f be c0             	movsbl %al,%eax
 7bc:	83 ec 08             	sub    $0x8,%esp
 7bf:	50                   	push   %eax
 7c0:	ff 75 08             	pushl  0x8(%ebp)
 7c3:	e8 31 fe ff ff       	call   5f9 <putc>
 7c8:	83 c4 10             	add    $0x10,%esp
          s++;
 7cb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d2:	0f b6 00             	movzbl (%eax),%eax
 7d5:	84 c0                	test   %al,%al
 7d7:	75 da                	jne    7b3 <printf+0xe3>
 7d9:	eb 65                	jmp    840 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7db:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 7df:	75 1d                	jne    7fe <printf+0x12e>
        putc(fd, *ap);
 7e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7e4:	8b 00                	mov    (%eax),%eax
 7e6:	0f be c0             	movsbl %al,%eax
 7e9:	83 ec 08             	sub    $0x8,%esp
 7ec:	50                   	push   %eax
 7ed:	ff 75 08             	pushl  0x8(%ebp)
 7f0:	e8 04 fe ff ff       	call   5f9 <putc>
 7f5:	83 c4 10             	add    $0x10,%esp
        ap++;
 7f8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7fc:	eb 42                	jmp    840 <printf+0x170>
      } else if(c == '%'){
 7fe:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 802:	75 17                	jne    81b <printf+0x14b>
        putc(fd, c);
 804:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 807:	0f be c0             	movsbl %al,%eax
 80a:	83 ec 08             	sub    $0x8,%esp
 80d:	50                   	push   %eax
 80e:	ff 75 08             	pushl  0x8(%ebp)
 811:	e8 e3 fd ff ff       	call   5f9 <putc>
 816:	83 c4 10             	add    $0x10,%esp
 819:	eb 25                	jmp    840 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 81b:	83 ec 08             	sub    $0x8,%esp
 81e:	6a 25                	push   $0x25
 820:	ff 75 08             	pushl  0x8(%ebp)
 823:	e8 d1 fd ff ff       	call   5f9 <putc>
 828:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 82b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 82e:	0f be c0             	movsbl %al,%eax
 831:	83 ec 08             	sub    $0x8,%esp
 834:	50                   	push   %eax
 835:	ff 75 08             	pushl  0x8(%ebp)
 838:	e8 bc fd ff ff       	call   5f9 <putc>
 83d:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 840:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 847:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 84b:	8b 55 0c             	mov    0xc(%ebp),%edx
 84e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 851:	01 d0                	add    %edx,%eax
 853:	0f b6 00             	movzbl (%eax),%eax
 856:	84 c0                	test   %al,%al
 858:	0f 85 94 fe ff ff    	jne    6f2 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 85e:	90                   	nop
 85f:	c9                   	leave  
 860:	c3                   	ret    

00000861 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 861:	55                   	push   %ebp
 862:	89 e5                	mov    %esp,%ebp
 864:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 867:	8b 45 08             	mov    0x8(%ebp),%eax
 86a:	83 e8 08             	sub    $0x8,%eax
 86d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 870:	a1 a4 0f 00 00       	mov    0xfa4,%eax
 875:	89 45 fc             	mov    %eax,-0x4(%ebp)
 878:	eb 24                	jmp    89e <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 87a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 87d:	8b 00                	mov    (%eax),%eax
 87f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 882:	77 12                	ja     896 <free+0x35>
 884:	8b 45 f8             	mov    -0x8(%ebp),%eax
 887:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 88a:	77 24                	ja     8b0 <free+0x4f>
 88c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 88f:	8b 00                	mov    (%eax),%eax
 891:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 894:	77 1a                	ja     8b0 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 896:	8b 45 fc             	mov    -0x4(%ebp),%eax
 899:	8b 00                	mov    (%eax),%eax
 89b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 89e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8a1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8a4:	76 d4                	jbe    87a <free+0x19>
 8a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a9:	8b 00                	mov    (%eax),%eax
 8ab:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8ae:	76 ca                	jbe    87a <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 8b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8b3:	8b 40 04             	mov    0x4(%eax),%eax
 8b6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8c0:	01 c2                	add    %eax,%edx
 8c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c5:	8b 00                	mov    (%eax),%eax
 8c7:	39 c2                	cmp    %eax,%edx
 8c9:	75 24                	jne    8ef <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 8cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ce:	8b 50 04             	mov    0x4(%eax),%edx
 8d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d4:	8b 00                	mov    (%eax),%eax
 8d6:	8b 40 04             	mov    0x4(%eax),%eax
 8d9:	01 c2                	add    %eax,%edx
 8db:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8de:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 8e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e4:	8b 00                	mov    (%eax),%eax
 8e6:	8b 10                	mov    (%eax),%edx
 8e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8eb:	89 10                	mov    %edx,(%eax)
 8ed:	eb 0a                	jmp    8f9 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 8ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f2:	8b 10                	mov    (%eax),%edx
 8f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8f7:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 8f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8fc:	8b 40 04             	mov    0x4(%eax),%eax
 8ff:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 906:	8b 45 fc             	mov    -0x4(%ebp),%eax
 909:	01 d0                	add    %edx,%eax
 90b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 90e:	75 20                	jne    930 <free+0xcf>
    p->s.size += bp->s.size;
 910:	8b 45 fc             	mov    -0x4(%ebp),%eax
 913:	8b 50 04             	mov    0x4(%eax),%edx
 916:	8b 45 f8             	mov    -0x8(%ebp),%eax
 919:	8b 40 04             	mov    0x4(%eax),%eax
 91c:	01 c2                	add    %eax,%edx
 91e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 921:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 924:	8b 45 f8             	mov    -0x8(%ebp),%eax
 927:	8b 10                	mov    (%eax),%edx
 929:	8b 45 fc             	mov    -0x4(%ebp),%eax
 92c:	89 10                	mov    %edx,(%eax)
 92e:	eb 08                	jmp    938 <free+0xd7>
  } else
    p->s.ptr = bp;
 930:	8b 45 fc             	mov    -0x4(%ebp),%eax
 933:	8b 55 f8             	mov    -0x8(%ebp),%edx
 936:	89 10                	mov    %edx,(%eax)
  freep = p;
 938:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93b:	a3 a4 0f 00 00       	mov    %eax,0xfa4
}
 940:	90                   	nop
 941:	c9                   	leave  
 942:	c3                   	ret    

00000943 <morecore>:

static Header*
morecore(uint nu)
{
 943:	55                   	push   %ebp
 944:	89 e5                	mov    %esp,%ebp
 946:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 949:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 950:	77 07                	ja     959 <morecore+0x16>
    nu = 4096;
 952:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 959:	8b 45 08             	mov    0x8(%ebp),%eax
 95c:	c1 e0 03             	shl    $0x3,%eax
 95f:	83 ec 0c             	sub    $0xc,%esp
 962:	50                   	push   %eax
 963:	e8 39 fc ff ff       	call   5a1 <sbrk>
 968:	83 c4 10             	add    $0x10,%esp
 96b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 96e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 972:	75 07                	jne    97b <morecore+0x38>
    return 0;
 974:	b8 00 00 00 00       	mov    $0x0,%eax
 979:	eb 26                	jmp    9a1 <morecore+0x5e>
  hp = (Header*)p;
 97b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 981:	8b 45 f0             	mov    -0x10(%ebp),%eax
 984:	8b 55 08             	mov    0x8(%ebp),%edx
 987:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 98a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 98d:	83 c0 08             	add    $0x8,%eax
 990:	83 ec 0c             	sub    $0xc,%esp
 993:	50                   	push   %eax
 994:	e8 c8 fe ff ff       	call   861 <free>
 999:	83 c4 10             	add    $0x10,%esp
  return freep;
 99c:	a1 a4 0f 00 00       	mov    0xfa4,%eax
}
 9a1:	c9                   	leave  
 9a2:	c3                   	ret    

000009a3 <malloc>:

void*
malloc(uint nbytes)
{
 9a3:	55                   	push   %ebp
 9a4:	89 e5                	mov    %esp,%ebp
 9a6:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9a9:	8b 45 08             	mov    0x8(%ebp),%eax
 9ac:	83 c0 07             	add    $0x7,%eax
 9af:	c1 e8 03             	shr    $0x3,%eax
 9b2:	83 c0 01             	add    $0x1,%eax
 9b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9b8:	a1 a4 0f 00 00       	mov    0xfa4,%eax
 9bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9c0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9c4:	75 23                	jne    9e9 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 9c6:	c7 45 f0 9c 0f 00 00 	movl   $0xf9c,-0x10(%ebp)
 9cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9d0:	a3 a4 0f 00 00       	mov    %eax,0xfa4
 9d5:	a1 a4 0f 00 00       	mov    0xfa4,%eax
 9da:	a3 9c 0f 00 00       	mov    %eax,0xf9c
    base.s.size = 0;
 9df:	c7 05 a0 0f 00 00 00 	movl   $0x0,0xfa0
 9e6:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9ec:	8b 00                	mov    (%eax),%eax
 9ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f4:	8b 40 04             	mov    0x4(%eax),%eax
 9f7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9fa:	72 4d                	jb     a49 <malloc+0xa6>
      if(p->s.size == nunits)
 9fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ff:	8b 40 04             	mov    0x4(%eax),%eax
 a02:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a05:	75 0c                	jne    a13 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a0a:	8b 10                	mov    (%eax),%edx
 a0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a0f:	89 10                	mov    %edx,(%eax)
 a11:	eb 26                	jmp    a39 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a16:	8b 40 04             	mov    0x4(%eax),%eax
 a19:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a1c:	89 c2                	mov    %eax,%edx
 a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a21:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a27:	8b 40 04             	mov    0x4(%eax),%eax
 a2a:	c1 e0 03             	shl    $0x3,%eax
 a2d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a33:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a36:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a39:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a3c:	a3 a4 0f 00 00       	mov    %eax,0xfa4
      return (void*)(p + 1);
 a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a44:	83 c0 08             	add    $0x8,%eax
 a47:	eb 3b                	jmp    a84 <malloc+0xe1>
    }
    if(p == freep)
 a49:	a1 a4 0f 00 00       	mov    0xfa4,%eax
 a4e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a51:	75 1e                	jne    a71 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a53:	83 ec 0c             	sub    $0xc,%esp
 a56:	ff 75 ec             	pushl  -0x14(%ebp)
 a59:	e8 e5 fe ff ff       	call   943 <morecore>
 a5e:	83 c4 10             	add    $0x10,%esp
 a61:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a64:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a68:	75 07                	jne    a71 <malloc+0xce>
        return 0;
 a6a:	b8 00 00 00 00       	mov    $0x0,%eax
 a6f:	eb 13                	jmp    a84 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a7a:	8b 00                	mov    (%eax),%eax
 a7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a7f:	e9 6d ff ff ff       	jmp    9f1 <malloc+0x4e>
}
 a84:	c9                   	leave  
 a85:	c3                   	ret    
