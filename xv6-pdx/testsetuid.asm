
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
  11:	e8 9b 05 00 00       	call   5b1 <getuid>
  16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(1, "Current UID is: %d\n", uid);
  19:	83 ec 04             	sub    $0x4,%esp
  1c:	ff 75 f4             	pushl  -0xc(%ebp)
  1f:	68 70 0a 00 00       	push   $0xa70
  24:	6a 01                	push   $0x1
  26:	e8 8d 06 00 00       	call   6b8 <printf>
  2b:	83 c4 10             	add    $0x10,%esp
  printf(1, "Setting UID to 100\n");
  2e:	83 ec 08             	sub    $0x8,%esp
  31:	68 84 0a 00 00       	push   $0xa84
  36:	6a 01                	push   $0x1
  38:	e8 7b 06 00 00       	call   6b8 <printf>
  3d:	83 c4 10             	add    $0x10,%esp
  if(setuid(100) == -1) {
  40:	83 ec 0c             	sub    $0xc,%esp
  43:	6a 64                	push   $0x64
  45:	e8 7f 05 00 00       	call   5c9 <setuid>
  4a:	83 c4 10             	add    $0x10,%esp
  4d:	83 f8 ff             	cmp    $0xffffffff,%eax
  50:	75 17                	jne    69 <main+0x69>
    printf(1, "Setting UID failed. Test FAILED.\n");
  52:	83 ec 08             	sub    $0x8,%esp
  55:	68 98 0a 00 00       	push   $0xa98
  5a:	6a 01                	push   $0x1
  5c:	e8 57 06 00 00       	call   6b8 <printf>
  61:	83 c4 10             	add    $0x10,%esp
    exit();
  64:	e8 98 04 00 00       	call   501 <exit>
  }
  uid = getuid();
  69:	e8 43 05 00 00       	call   5b1 <getuid>
  6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(1, "Current UID is: %d\n", uid);
  71:	83 ec 04             	sub    $0x4,%esp
  74:	ff 75 f4             	pushl  -0xc(%ebp)
  77:	68 70 0a 00 00       	push   $0xa70
  7c:	6a 01                	push   $0x1
  7e:	e8 35 06 00 00       	call   6b8 <printf>
  83:	83 c4 10             	add    $0x10,%esp
  printf(1, "Setting UID to 32,768\n");
  86:	83 ec 08             	sub    $0x8,%esp
  89:	68 ba 0a 00 00       	push   $0xaba
  8e:	6a 01                	push   $0x1
  90:	e8 23 06 00 00       	call   6b8 <printf>
  95:	83 c4 10             	add    $0x10,%esp
  if(setuid(32768) == 0) {
  98:	83 ec 0c             	sub    $0xc,%esp
  9b:	68 00 80 00 00       	push   $0x8000
  a0:	e8 24 05 00 00       	call   5c9 <setuid>
  a5:	83 c4 10             	add    $0x10,%esp
  a8:	85 c0                	test   %eax,%eax
  aa:	75 17                	jne    c3 <main+0xc3>
    printf(1, "Setting UID succeeded. Set should fail. Test FAILED.\n");
  ac:	83 ec 08             	sub    $0x8,%esp
  af:	68 d4 0a 00 00       	push   $0xad4
  b4:	6a 01                	push   $0x1
  b6:	e8 fd 05 00 00       	call   6b8 <printf>
  bb:	83 c4 10             	add    $0x10,%esp
    exit();
  be:	e8 3e 04 00 00       	call   501 <exit>
  }
  else
    printf(1, "Not allowed to set UID to 32,768. PASSED.\n");
  c3:	83 ec 08             	sub    $0x8,%esp
  c6:	68 0c 0b 00 00       	push   $0xb0c
  cb:	6a 01                	push   $0x1
  cd:	e8 e6 05 00 00       	call   6b8 <printf>
  d2:	83 c4 10             	add    $0x10,%esp
  printf(1, "Setting UID to -1\n");
  d5:	83 ec 08             	sub    $0x8,%esp
  d8:	68 37 0b 00 00       	push   $0xb37
  dd:	6a 01                	push   $0x1
  df:	e8 d4 05 00 00       	call   6b8 <printf>
  e4:	83 c4 10             	add    $0x10,%esp
  if(setuid(-1) == 0) {
  e7:	83 ec 0c             	sub    $0xc,%esp
  ea:	6a ff                	push   $0xffffffff
  ec:	e8 d8 04 00 00       	call   5c9 <setuid>
  f1:	83 c4 10             	add    $0x10,%esp
  f4:	85 c0                	test   %eax,%eax
  f6:	75 17                	jne    10f <main+0x10f>
    printf(1, "Setting UID succeeded.  Set should fail. Test FAILED.\n");
  f8:	83 ec 08             	sub    $0x8,%esp
  fb:	68 4c 0b 00 00       	push   $0xb4c
 100:	6a 01                	push   $0x1
 102:	e8 b1 05 00 00       	call   6b8 <printf>
 107:	83 c4 10             	add    $0x10,%esp
    exit();
 10a:	e8 f2 03 00 00       	call   501 <exit>
  }
  else
    printf(1, "Not allowed to set UID to -1. PASSED.\n");
 10f:	83 ec 08             	sub    $0x8,%esp
 112:	68 84 0b 00 00       	push   $0xb84
 117:	6a 01                	push   $0x1
 119:	e8 9a 05 00 00       	call   6b8 <printf>
 11e:	83 c4 10             	add    $0x10,%esp

  gid = getgid();
 121:	e8 93 04 00 00       	call   5b9 <getgid>
 126:	89 45 f0             	mov    %eax,-0x10(%ebp)
  printf(1, "Current GID is: %d\n", gid);
 129:	83 ec 04             	sub    $0x4,%esp
 12c:	ff 75 f0             	pushl  -0x10(%ebp)
 12f:	68 ab 0b 00 00       	push   $0xbab
 134:	6a 01                	push   $0x1
 136:	e8 7d 05 00 00       	call   6b8 <printf>
 13b:	83 c4 10             	add    $0x10,%esp
  printf(1, "Setting GID to 100\n");
 13e:	83 ec 08             	sub    $0x8,%esp
 141:	68 bf 0b 00 00       	push   $0xbbf
 146:	6a 01                	push   $0x1
 148:	e8 6b 05 00 00       	call   6b8 <printf>
 14d:	83 c4 10             	add    $0x10,%esp
  if(setgid(100) == -1) {
 150:	83 ec 0c             	sub    $0xc,%esp
 153:	6a 64                	push   $0x64
 155:	e8 77 04 00 00       	call   5d1 <setgid>
 15a:	83 c4 10             	add    $0x10,%esp
 15d:	83 f8 ff             	cmp    $0xffffffff,%eax
 160:	75 17                	jne    179 <main+0x179>
    printf(1, "Setting GID failed. Test FAILED.\n");
 162:	83 ec 08             	sub    $0x8,%esp
 165:	68 d4 0b 00 00       	push   $0xbd4
 16a:	6a 01                	push   $0x1
 16c:	e8 47 05 00 00       	call   6b8 <printf>
 171:	83 c4 10             	add    $0x10,%esp
    exit();
 174:	e8 88 03 00 00       	call   501 <exit>
  }
  gid = getgid();
 179:	e8 3b 04 00 00       	call   5b9 <getgid>
 17e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  printf(1, "Current GID is: %d\n", gid);
 181:	83 ec 04             	sub    $0x4,%esp
 184:	ff 75 f0             	pushl  -0x10(%ebp)
 187:	68 ab 0b 00 00       	push   $0xbab
 18c:	6a 01                	push   $0x1
 18e:	e8 25 05 00 00       	call   6b8 <printf>
 193:	83 c4 10             	add    $0x10,%esp
  printf(1, "Setting GID to 32,768\n");
 196:	83 ec 08             	sub    $0x8,%esp
 199:	68 f6 0b 00 00       	push   $0xbf6
 19e:	6a 01                	push   $0x1
 1a0:	e8 13 05 00 00       	call   6b8 <printf>
 1a5:	83 c4 10             	add    $0x10,%esp
  if(setgid(32768) == 0) {
 1a8:	83 ec 0c             	sub    $0xc,%esp
 1ab:	68 00 80 00 00       	push   $0x8000
 1b0:	e8 1c 04 00 00       	call   5d1 <setgid>
 1b5:	83 c4 10             	add    $0x10,%esp
 1b8:	85 c0                	test   %eax,%eax
 1ba:	75 17                	jne    1d3 <main+0x1d3>
    printf(1, "Setting GID succeeded. Set should fail. Test FAILED.\n");
 1bc:	83 ec 08             	sub    $0x8,%esp
 1bf:	68 10 0c 00 00       	push   $0xc10
 1c4:	6a 01                	push   $0x1
 1c6:	e8 ed 04 00 00       	call   6b8 <printf>
 1cb:	83 c4 10             	add    $0x10,%esp
    exit();
 1ce:	e8 2e 03 00 00       	call   501 <exit>
  }
  else
    printf(1, "Not allowed to set GID to 32,768. PASSED.\n");
 1d3:	83 ec 08             	sub    $0x8,%esp
 1d6:	68 48 0c 00 00       	push   $0xc48
 1db:	6a 01                	push   $0x1
 1dd:	e8 d6 04 00 00       	call   6b8 <printf>
 1e2:	83 c4 10             	add    $0x10,%esp
  printf(1, "Setting GID to -1\n");
 1e5:	83 ec 08             	sub    $0x8,%esp
 1e8:	68 73 0c 00 00       	push   $0xc73
 1ed:	6a 01                	push   $0x1
 1ef:	e8 c4 04 00 00       	call   6b8 <printf>
 1f4:	83 c4 10             	add    $0x10,%esp
  if(setgid(-1) == 0) {
 1f7:	83 ec 0c             	sub    $0xc,%esp
 1fa:	6a ff                	push   $0xffffffff
 1fc:	e8 d0 03 00 00       	call   5d1 <setgid>
 201:	83 c4 10             	add    $0x10,%esp
 204:	85 c0                	test   %eax,%eax
 206:	75 17                	jne    21f <main+0x21f>
    printf(1, "Setting GID succeeded.  Set should fail. Test FAILED.\n");
 208:	83 ec 08             	sub    $0x8,%esp
 20b:	68 88 0c 00 00       	push   $0xc88
 210:	6a 01                	push   $0x1
 212:	e8 a1 04 00 00       	call   6b8 <printf>
 217:	83 c4 10             	add    $0x10,%esp
    exit();
 21a:	e8 e2 02 00 00       	call   501 <exit>
  }
  else
    printf(1, "Not allowed to set GID to -1. PASSED.\n");
 21f:	83 ec 08             	sub    $0x8,%esp
 222:	68 c0 0c 00 00       	push   $0xcc0
 227:	6a 01                	push   $0x1
 229:	e8 8a 04 00 00       	call   6b8 <printf>
 22e:	83 c4 10             	add    $0x10,%esp
  
  ppid = getppid();
 231:	e8 8b 03 00 00       	call   5c1 <getppid>
 236:	89 45 ec             	mov    %eax,-0x14(%ebp)
  printf(1, "My parent process is: %d\n", ppid);
 239:	83 ec 04             	sub    $0x4,%esp
 23c:	ff 75 ec             	pushl  -0x14(%ebp)
 23f:	68 e7 0c 00 00       	push   $0xce7
 244:	6a 01                	push   $0x1
 246:	e8 6d 04 00 00       	call   6b8 <printf>
 24b:	83 c4 10             	add    $0x10,%esp
  printf(1, "Done!\n");
 24e:	83 ec 08             	sub    $0x8,%esp
 251:	68 01 0d 00 00       	push   $0xd01
 256:	6a 01                	push   $0x1
 258:	e8 5b 04 00 00       	call   6b8 <printf>
 25d:	83 c4 10             	add    $0x10,%esp

  exit();
 260:	e8 9c 02 00 00       	call   501 <exit>

00000265 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 265:	55                   	push   %ebp
 266:	89 e5                	mov    %esp,%ebp
 268:	57                   	push   %edi
 269:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 26a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 26d:	8b 55 10             	mov    0x10(%ebp),%edx
 270:	8b 45 0c             	mov    0xc(%ebp),%eax
 273:	89 cb                	mov    %ecx,%ebx
 275:	89 df                	mov    %ebx,%edi
 277:	89 d1                	mov    %edx,%ecx
 279:	fc                   	cld    
 27a:	f3 aa                	rep stos %al,%es:(%edi)
 27c:	89 ca                	mov    %ecx,%edx
 27e:	89 fb                	mov    %edi,%ebx
 280:	89 5d 08             	mov    %ebx,0x8(%ebp)
 283:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 286:	90                   	nop
 287:	5b                   	pop    %ebx
 288:	5f                   	pop    %edi
 289:	5d                   	pop    %ebp
 28a:	c3                   	ret    

0000028b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 28b:	55                   	push   %ebp
 28c:	89 e5                	mov    %esp,%ebp
 28e:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 291:	8b 45 08             	mov    0x8(%ebp),%eax
 294:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 297:	90                   	nop
 298:	8b 45 08             	mov    0x8(%ebp),%eax
 29b:	8d 50 01             	lea    0x1(%eax),%edx
 29e:	89 55 08             	mov    %edx,0x8(%ebp)
 2a1:	8b 55 0c             	mov    0xc(%ebp),%edx
 2a4:	8d 4a 01             	lea    0x1(%edx),%ecx
 2a7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 2aa:	0f b6 12             	movzbl (%edx),%edx
 2ad:	88 10                	mov    %dl,(%eax)
 2af:	0f b6 00             	movzbl (%eax),%eax
 2b2:	84 c0                	test   %al,%al
 2b4:	75 e2                	jne    298 <strcpy+0xd>
    ;
  return os;
 2b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2b9:	c9                   	leave  
 2ba:	c3                   	ret    

000002bb <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2bb:	55                   	push   %ebp
 2bc:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 2be:	eb 08                	jmp    2c8 <strcmp+0xd>
    p++, q++;
 2c0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2c4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 2c8:	8b 45 08             	mov    0x8(%ebp),%eax
 2cb:	0f b6 00             	movzbl (%eax),%eax
 2ce:	84 c0                	test   %al,%al
 2d0:	74 10                	je     2e2 <strcmp+0x27>
 2d2:	8b 45 08             	mov    0x8(%ebp),%eax
 2d5:	0f b6 10             	movzbl (%eax),%edx
 2d8:	8b 45 0c             	mov    0xc(%ebp),%eax
 2db:	0f b6 00             	movzbl (%eax),%eax
 2de:	38 c2                	cmp    %al,%dl
 2e0:	74 de                	je     2c0 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 2e2:	8b 45 08             	mov    0x8(%ebp),%eax
 2e5:	0f b6 00             	movzbl (%eax),%eax
 2e8:	0f b6 d0             	movzbl %al,%edx
 2eb:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ee:	0f b6 00             	movzbl (%eax),%eax
 2f1:	0f b6 c0             	movzbl %al,%eax
 2f4:	29 c2                	sub    %eax,%edx
 2f6:	89 d0                	mov    %edx,%eax
}
 2f8:	5d                   	pop    %ebp
 2f9:	c3                   	ret    

000002fa <strlen>:

uint
strlen(char *s)
{
 2fa:	55                   	push   %ebp
 2fb:	89 e5                	mov    %esp,%ebp
 2fd:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 300:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 307:	eb 04                	jmp    30d <strlen+0x13>
 309:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 30d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 310:	8b 45 08             	mov    0x8(%ebp),%eax
 313:	01 d0                	add    %edx,%eax
 315:	0f b6 00             	movzbl (%eax),%eax
 318:	84 c0                	test   %al,%al
 31a:	75 ed                	jne    309 <strlen+0xf>
    ;
  return n;
 31c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 31f:	c9                   	leave  
 320:	c3                   	ret    

00000321 <memset>:

void*
memset(void *dst, int c, uint n)
{
 321:	55                   	push   %ebp
 322:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 324:	8b 45 10             	mov    0x10(%ebp),%eax
 327:	50                   	push   %eax
 328:	ff 75 0c             	pushl  0xc(%ebp)
 32b:	ff 75 08             	pushl  0x8(%ebp)
 32e:	e8 32 ff ff ff       	call   265 <stosb>
 333:	83 c4 0c             	add    $0xc,%esp
  return dst;
 336:	8b 45 08             	mov    0x8(%ebp),%eax
}
 339:	c9                   	leave  
 33a:	c3                   	ret    

0000033b <strchr>:

char*
strchr(const char *s, char c)
{
 33b:	55                   	push   %ebp
 33c:	89 e5                	mov    %esp,%ebp
 33e:	83 ec 04             	sub    $0x4,%esp
 341:	8b 45 0c             	mov    0xc(%ebp),%eax
 344:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 347:	eb 14                	jmp    35d <strchr+0x22>
    if(*s == c)
 349:	8b 45 08             	mov    0x8(%ebp),%eax
 34c:	0f b6 00             	movzbl (%eax),%eax
 34f:	3a 45 fc             	cmp    -0x4(%ebp),%al
 352:	75 05                	jne    359 <strchr+0x1e>
      return (char*)s;
 354:	8b 45 08             	mov    0x8(%ebp),%eax
 357:	eb 13                	jmp    36c <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 359:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 35d:	8b 45 08             	mov    0x8(%ebp),%eax
 360:	0f b6 00             	movzbl (%eax),%eax
 363:	84 c0                	test   %al,%al
 365:	75 e2                	jne    349 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 367:	b8 00 00 00 00       	mov    $0x0,%eax
}
 36c:	c9                   	leave  
 36d:	c3                   	ret    

0000036e <gets>:

char*
gets(char *buf, int max)
{
 36e:	55                   	push   %ebp
 36f:	89 e5                	mov    %esp,%ebp
 371:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 374:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 37b:	eb 42                	jmp    3bf <gets+0x51>
    cc = read(0, &c, 1);
 37d:	83 ec 04             	sub    $0x4,%esp
 380:	6a 01                	push   $0x1
 382:	8d 45 ef             	lea    -0x11(%ebp),%eax
 385:	50                   	push   %eax
 386:	6a 00                	push   $0x0
 388:	e8 8c 01 00 00       	call   519 <read>
 38d:	83 c4 10             	add    $0x10,%esp
 390:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 393:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 397:	7e 33                	jle    3cc <gets+0x5e>
      break;
    buf[i++] = c;
 399:	8b 45 f4             	mov    -0xc(%ebp),%eax
 39c:	8d 50 01             	lea    0x1(%eax),%edx
 39f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3a2:	89 c2                	mov    %eax,%edx
 3a4:	8b 45 08             	mov    0x8(%ebp),%eax
 3a7:	01 c2                	add    %eax,%edx
 3a9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3ad:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 3af:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3b3:	3c 0a                	cmp    $0xa,%al
 3b5:	74 16                	je     3cd <gets+0x5f>
 3b7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3bb:	3c 0d                	cmp    $0xd,%al
 3bd:	74 0e                	je     3cd <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3c2:	83 c0 01             	add    $0x1,%eax
 3c5:	3b 45 0c             	cmp    0xc(%ebp),%eax
 3c8:	7c b3                	jl     37d <gets+0xf>
 3ca:	eb 01                	jmp    3cd <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 3cc:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 3cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3d0:	8b 45 08             	mov    0x8(%ebp),%eax
 3d3:	01 d0                	add    %edx,%eax
 3d5:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 3d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3db:	c9                   	leave  
 3dc:	c3                   	ret    

000003dd <stat>:

int
stat(char *n, struct stat *st)
{
 3dd:	55                   	push   %ebp
 3de:	89 e5                	mov    %esp,%ebp
 3e0:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3e3:	83 ec 08             	sub    $0x8,%esp
 3e6:	6a 00                	push   $0x0
 3e8:	ff 75 08             	pushl  0x8(%ebp)
 3eb:	e8 51 01 00 00       	call   541 <open>
 3f0:	83 c4 10             	add    $0x10,%esp
 3f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 3f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3fa:	79 07                	jns    403 <stat+0x26>
    return -1;
 3fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 401:	eb 25                	jmp    428 <stat+0x4b>
  r = fstat(fd, st);
 403:	83 ec 08             	sub    $0x8,%esp
 406:	ff 75 0c             	pushl  0xc(%ebp)
 409:	ff 75 f4             	pushl  -0xc(%ebp)
 40c:	e8 48 01 00 00       	call   559 <fstat>
 411:	83 c4 10             	add    $0x10,%esp
 414:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 417:	83 ec 0c             	sub    $0xc,%esp
 41a:	ff 75 f4             	pushl  -0xc(%ebp)
 41d:	e8 07 01 00 00       	call   529 <close>
 422:	83 c4 10             	add    $0x10,%esp
  return r;
 425:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 428:	c9                   	leave  
 429:	c3                   	ret    

0000042a <atoi>:

int
atoi(const char *s)
{
 42a:	55                   	push   %ebp
 42b:	89 e5                	mov    %esp,%ebp
 42d:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 430:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 437:	eb 04                	jmp    43d <atoi+0x13>
 439:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 43d:	8b 45 08             	mov    0x8(%ebp),%eax
 440:	0f b6 00             	movzbl (%eax),%eax
 443:	3c 20                	cmp    $0x20,%al
 445:	74 f2                	je     439 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 447:	8b 45 08             	mov    0x8(%ebp),%eax
 44a:	0f b6 00             	movzbl (%eax),%eax
 44d:	3c 2d                	cmp    $0x2d,%al
 44f:	75 07                	jne    458 <atoi+0x2e>
 451:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 456:	eb 05                	jmp    45d <atoi+0x33>
 458:	b8 01 00 00 00       	mov    $0x1,%eax
 45d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 460:	8b 45 08             	mov    0x8(%ebp),%eax
 463:	0f b6 00             	movzbl (%eax),%eax
 466:	3c 2b                	cmp    $0x2b,%al
 468:	74 0a                	je     474 <atoi+0x4a>
 46a:	8b 45 08             	mov    0x8(%ebp),%eax
 46d:	0f b6 00             	movzbl (%eax),%eax
 470:	3c 2d                	cmp    $0x2d,%al
 472:	75 2b                	jne    49f <atoi+0x75>
    s++;
 474:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 478:	eb 25                	jmp    49f <atoi+0x75>
    n = n*10 + *s++ - '0';
 47a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 47d:	89 d0                	mov    %edx,%eax
 47f:	c1 e0 02             	shl    $0x2,%eax
 482:	01 d0                	add    %edx,%eax
 484:	01 c0                	add    %eax,%eax
 486:	89 c1                	mov    %eax,%ecx
 488:	8b 45 08             	mov    0x8(%ebp),%eax
 48b:	8d 50 01             	lea    0x1(%eax),%edx
 48e:	89 55 08             	mov    %edx,0x8(%ebp)
 491:	0f b6 00             	movzbl (%eax),%eax
 494:	0f be c0             	movsbl %al,%eax
 497:	01 c8                	add    %ecx,%eax
 499:	83 e8 30             	sub    $0x30,%eax
 49c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 49f:	8b 45 08             	mov    0x8(%ebp),%eax
 4a2:	0f b6 00             	movzbl (%eax),%eax
 4a5:	3c 2f                	cmp    $0x2f,%al
 4a7:	7e 0a                	jle    4b3 <atoi+0x89>
 4a9:	8b 45 08             	mov    0x8(%ebp),%eax
 4ac:	0f b6 00             	movzbl (%eax),%eax
 4af:	3c 39                	cmp    $0x39,%al
 4b1:	7e c7                	jle    47a <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 4b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 4b6:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 4ba:	c9                   	leave  
 4bb:	c3                   	ret    

000004bc <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 4bc:	55                   	push   %ebp
 4bd:	89 e5                	mov    %esp,%ebp
 4bf:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 4c2:	8b 45 08             	mov    0x8(%ebp),%eax
 4c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 4c8:	8b 45 0c             	mov    0xc(%ebp),%eax
 4cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 4ce:	eb 17                	jmp    4e7 <memmove+0x2b>
    *dst++ = *src++;
 4d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4d3:	8d 50 01             	lea    0x1(%eax),%edx
 4d6:	89 55 fc             	mov    %edx,-0x4(%ebp)
 4d9:	8b 55 f8             	mov    -0x8(%ebp),%edx
 4dc:	8d 4a 01             	lea    0x1(%edx),%ecx
 4df:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 4e2:	0f b6 12             	movzbl (%edx),%edx
 4e5:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4e7:	8b 45 10             	mov    0x10(%ebp),%eax
 4ea:	8d 50 ff             	lea    -0x1(%eax),%edx
 4ed:	89 55 10             	mov    %edx,0x10(%ebp)
 4f0:	85 c0                	test   %eax,%eax
 4f2:	7f dc                	jg     4d0 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 4f4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4f7:	c9                   	leave  
 4f8:	c3                   	ret    

000004f9 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4f9:	b8 01 00 00 00       	mov    $0x1,%eax
 4fe:	cd 40                	int    $0x40
 500:	c3                   	ret    

00000501 <exit>:
SYSCALL(exit)
 501:	b8 02 00 00 00       	mov    $0x2,%eax
 506:	cd 40                	int    $0x40
 508:	c3                   	ret    

00000509 <wait>:
SYSCALL(wait)
 509:	b8 03 00 00 00       	mov    $0x3,%eax
 50e:	cd 40                	int    $0x40
 510:	c3                   	ret    

00000511 <pipe>:
SYSCALL(pipe)
 511:	b8 04 00 00 00       	mov    $0x4,%eax
 516:	cd 40                	int    $0x40
 518:	c3                   	ret    

00000519 <read>:
SYSCALL(read)
 519:	b8 05 00 00 00       	mov    $0x5,%eax
 51e:	cd 40                	int    $0x40
 520:	c3                   	ret    

00000521 <write>:
SYSCALL(write)
 521:	b8 10 00 00 00       	mov    $0x10,%eax
 526:	cd 40                	int    $0x40
 528:	c3                   	ret    

00000529 <close>:
SYSCALL(close)
 529:	b8 15 00 00 00       	mov    $0x15,%eax
 52e:	cd 40                	int    $0x40
 530:	c3                   	ret    

00000531 <kill>:
SYSCALL(kill)
 531:	b8 06 00 00 00       	mov    $0x6,%eax
 536:	cd 40                	int    $0x40
 538:	c3                   	ret    

00000539 <exec>:
SYSCALL(exec)
 539:	b8 07 00 00 00       	mov    $0x7,%eax
 53e:	cd 40                	int    $0x40
 540:	c3                   	ret    

00000541 <open>:
SYSCALL(open)
 541:	b8 0f 00 00 00       	mov    $0xf,%eax
 546:	cd 40                	int    $0x40
 548:	c3                   	ret    

00000549 <mknod>:
SYSCALL(mknod)
 549:	b8 11 00 00 00       	mov    $0x11,%eax
 54e:	cd 40                	int    $0x40
 550:	c3                   	ret    

00000551 <unlink>:
SYSCALL(unlink)
 551:	b8 12 00 00 00       	mov    $0x12,%eax
 556:	cd 40                	int    $0x40
 558:	c3                   	ret    

00000559 <fstat>:
SYSCALL(fstat)
 559:	b8 08 00 00 00       	mov    $0x8,%eax
 55e:	cd 40                	int    $0x40
 560:	c3                   	ret    

00000561 <link>:
SYSCALL(link)
 561:	b8 13 00 00 00       	mov    $0x13,%eax
 566:	cd 40                	int    $0x40
 568:	c3                   	ret    

00000569 <mkdir>:
SYSCALL(mkdir)
 569:	b8 14 00 00 00       	mov    $0x14,%eax
 56e:	cd 40                	int    $0x40
 570:	c3                   	ret    

00000571 <chdir>:
SYSCALL(chdir)
 571:	b8 09 00 00 00       	mov    $0x9,%eax
 576:	cd 40                	int    $0x40
 578:	c3                   	ret    

00000579 <dup>:
SYSCALL(dup)
 579:	b8 0a 00 00 00       	mov    $0xa,%eax
 57e:	cd 40                	int    $0x40
 580:	c3                   	ret    

00000581 <getpid>:
SYSCALL(getpid)
 581:	b8 0b 00 00 00       	mov    $0xb,%eax
 586:	cd 40                	int    $0x40
 588:	c3                   	ret    

00000589 <sbrk>:
SYSCALL(sbrk)
 589:	b8 0c 00 00 00       	mov    $0xc,%eax
 58e:	cd 40                	int    $0x40
 590:	c3                   	ret    

00000591 <sleep>:
SYSCALL(sleep)
 591:	b8 0d 00 00 00       	mov    $0xd,%eax
 596:	cd 40                	int    $0x40
 598:	c3                   	ret    

00000599 <uptime>:
SYSCALL(uptime)
 599:	b8 0e 00 00 00       	mov    $0xe,%eax
 59e:	cd 40                	int    $0x40
 5a0:	c3                   	ret    

000005a1 <halt>:
SYSCALL(halt)
 5a1:	b8 16 00 00 00       	mov    $0x16,%eax
 5a6:	cd 40                	int    $0x40
 5a8:	c3                   	ret    

000005a9 <date>:
SYSCALL(date)
 5a9:	b8 17 00 00 00       	mov    $0x17,%eax
 5ae:	cd 40                	int    $0x40
 5b0:	c3                   	ret    

000005b1 <getuid>:
SYSCALL(getuid)
 5b1:	b8 18 00 00 00       	mov    $0x18,%eax
 5b6:	cd 40                	int    $0x40
 5b8:	c3                   	ret    

000005b9 <getgid>:
SYSCALL(getgid)
 5b9:	b8 19 00 00 00       	mov    $0x19,%eax
 5be:	cd 40                	int    $0x40
 5c0:	c3                   	ret    

000005c1 <getppid>:
SYSCALL(getppid)
 5c1:	b8 1a 00 00 00       	mov    $0x1a,%eax
 5c6:	cd 40                	int    $0x40
 5c8:	c3                   	ret    

000005c9 <setuid>:
SYSCALL(setuid)
 5c9:	b8 1b 00 00 00       	mov    $0x1b,%eax
 5ce:	cd 40                	int    $0x40
 5d0:	c3                   	ret    

000005d1 <setgid>:
SYSCALL(setgid)
 5d1:	b8 1c 00 00 00       	mov    $0x1c,%eax
 5d6:	cd 40                	int    $0x40
 5d8:	c3                   	ret    

000005d9 <getprocs>:
SYSCALL(getprocs)
 5d9:	b8 1d 00 00 00       	mov    $0x1d,%eax
 5de:	cd 40                	int    $0x40
 5e0:	c3                   	ret    

000005e1 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 5e1:	55                   	push   %ebp
 5e2:	89 e5                	mov    %esp,%ebp
 5e4:	83 ec 18             	sub    $0x18,%esp
 5e7:	8b 45 0c             	mov    0xc(%ebp),%eax
 5ea:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 5ed:	83 ec 04             	sub    $0x4,%esp
 5f0:	6a 01                	push   $0x1
 5f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
 5f5:	50                   	push   %eax
 5f6:	ff 75 08             	pushl  0x8(%ebp)
 5f9:	e8 23 ff ff ff       	call   521 <write>
 5fe:	83 c4 10             	add    $0x10,%esp
}
 601:	90                   	nop
 602:	c9                   	leave  
 603:	c3                   	ret    

00000604 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 604:	55                   	push   %ebp
 605:	89 e5                	mov    %esp,%ebp
 607:	53                   	push   %ebx
 608:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 60b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 612:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 616:	74 17                	je     62f <printint+0x2b>
 618:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 61c:	79 11                	jns    62f <printint+0x2b>
    neg = 1;
 61e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 625:	8b 45 0c             	mov    0xc(%ebp),%eax
 628:	f7 d8                	neg    %eax
 62a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 62d:	eb 06                	jmp    635 <printint+0x31>
  } else {
    x = xx;
 62f:	8b 45 0c             	mov    0xc(%ebp),%eax
 632:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 635:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 63c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 63f:	8d 41 01             	lea    0x1(%ecx),%eax
 642:	89 45 f4             	mov    %eax,-0xc(%ebp)
 645:	8b 5d 10             	mov    0x10(%ebp),%ebx
 648:	8b 45 ec             	mov    -0x14(%ebp),%eax
 64b:	ba 00 00 00 00       	mov    $0x0,%edx
 650:	f7 f3                	div    %ebx
 652:	89 d0                	mov    %edx,%eax
 654:	0f b6 80 58 0f 00 00 	movzbl 0xf58(%eax),%eax
 65b:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 65f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 662:	8b 45 ec             	mov    -0x14(%ebp),%eax
 665:	ba 00 00 00 00       	mov    $0x0,%edx
 66a:	f7 f3                	div    %ebx
 66c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 66f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 673:	75 c7                	jne    63c <printint+0x38>
  if(neg)
 675:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 679:	74 2d                	je     6a8 <printint+0xa4>
    buf[i++] = '-';
 67b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 67e:	8d 50 01             	lea    0x1(%eax),%edx
 681:	89 55 f4             	mov    %edx,-0xc(%ebp)
 684:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 689:	eb 1d                	jmp    6a8 <printint+0xa4>
    putc(fd, buf[i]);
 68b:	8d 55 dc             	lea    -0x24(%ebp),%edx
 68e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 691:	01 d0                	add    %edx,%eax
 693:	0f b6 00             	movzbl (%eax),%eax
 696:	0f be c0             	movsbl %al,%eax
 699:	83 ec 08             	sub    $0x8,%esp
 69c:	50                   	push   %eax
 69d:	ff 75 08             	pushl  0x8(%ebp)
 6a0:	e8 3c ff ff ff       	call   5e1 <putc>
 6a5:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6a8:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 6ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6b0:	79 d9                	jns    68b <printint+0x87>
    putc(fd, buf[i]);
}
 6b2:	90                   	nop
 6b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6b6:	c9                   	leave  
 6b7:	c3                   	ret    

000006b8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6b8:	55                   	push   %ebp
 6b9:	89 e5                	mov    %esp,%ebp
 6bb:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 6be:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 6c5:	8d 45 0c             	lea    0xc(%ebp),%eax
 6c8:	83 c0 04             	add    $0x4,%eax
 6cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 6ce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 6d5:	e9 59 01 00 00       	jmp    833 <printf+0x17b>
    c = fmt[i] & 0xff;
 6da:	8b 55 0c             	mov    0xc(%ebp),%edx
 6dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6e0:	01 d0                	add    %edx,%eax
 6e2:	0f b6 00             	movzbl (%eax),%eax
 6e5:	0f be c0             	movsbl %al,%eax
 6e8:	25 ff 00 00 00       	and    $0xff,%eax
 6ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 6f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6f4:	75 2c                	jne    722 <printf+0x6a>
      if(c == '%'){
 6f6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6fa:	75 0c                	jne    708 <printf+0x50>
        state = '%';
 6fc:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 703:	e9 27 01 00 00       	jmp    82f <printf+0x177>
      } else {
        putc(fd, c);
 708:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 70b:	0f be c0             	movsbl %al,%eax
 70e:	83 ec 08             	sub    $0x8,%esp
 711:	50                   	push   %eax
 712:	ff 75 08             	pushl  0x8(%ebp)
 715:	e8 c7 fe ff ff       	call   5e1 <putc>
 71a:	83 c4 10             	add    $0x10,%esp
 71d:	e9 0d 01 00 00       	jmp    82f <printf+0x177>
      }
    } else if(state == '%'){
 722:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 726:	0f 85 03 01 00 00    	jne    82f <printf+0x177>
      if(c == 'd'){
 72c:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 730:	75 1e                	jne    750 <printf+0x98>
        printint(fd, *ap, 10, 1);
 732:	8b 45 e8             	mov    -0x18(%ebp),%eax
 735:	8b 00                	mov    (%eax),%eax
 737:	6a 01                	push   $0x1
 739:	6a 0a                	push   $0xa
 73b:	50                   	push   %eax
 73c:	ff 75 08             	pushl  0x8(%ebp)
 73f:	e8 c0 fe ff ff       	call   604 <printint>
 744:	83 c4 10             	add    $0x10,%esp
        ap++;
 747:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 74b:	e9 d8 00 00 00       	jmp    828 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 750:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 754:	74 06                	je     75c <printf+0xa4>
 756:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 75a:	75 1e                	jne    77a <printf+0xc2>
        printint(fd, *ap, 16, 0);
 75c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 75f:	8b 00                	mov    (%eax),%eax
 761:	6a 00                	push   $0x0
 763:	6a 10                	push   $0x10
 765:	50                   	push   %eax
 766:	ff 75 08             	pushl  0x8(%ebp)
 769:	e8 96 fe ff ff       	call   604 <printint>
 76e:	83 c4 10             	add    $0x10,%esp
        ap++;
 771:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 775:	e9 ae 00 00 00       	jmp    828 <printf+0x170>
      } else if(c == 's'){
 77a:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 77e:	75 43                	jne    7c3 <printf+0x10b>
        s = (char*)*ap;
 780:	8b 45 e8             	mov    -0x18(%ebp),%eax
 783:	8b 00                	mov    (%eax),%eax
 785:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 788:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 78c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 790:	75 25                	jne    7b7 <printf+0xff>
          s = "(null)";
 792:	c7 45 f4 08 0d 00 00 	movl   $0xd08,-0xc(%ebp)
        while(*s != 0){
 799:	eb 1c                	jmp    7b7 <printf+0xff>
          putc(fd, *s);
 79b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79e:	0f b6 00             	movzbl (%eax),%eax
 7a1:	0f be c0             	movsbl %al,%eax
 7a4:	83 ec 08             	sub    $0x8,%esp
 7a7:	50                   	push   %eax
 7a8:	ff 75 08             	pushl  0x8(%ebp)
 7ab:	e8 31 fe ff ff       	call   5e1 <putc>
 7b0:	83 c4 10             	add    $0x10,%esp
          s++;
 7b3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ba:	0f b6 00             	movzbl (%eax),%eax
 7bd:	84 c0                	test   %al,%al
 7bf:	75 da                	jne    79b <printf+0xe3>
 7c1:	eb 65                	jmp    828 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7c3:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 7c7:	75 1d                	jne    7e6 <printf+0x12e>
        putc(fd, *ap);
 7c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7cc:	8b 00                	mov    (%eax),%eax
 7ce:	0f be c0             	movsbl %al,%eax
 7d1:	83 ec 08             	sub    $0x8,%esp
 7d4:	50                   	push   %eax
 7d5:	ff 75 08             	pushl  0x8(%ebp)
 7d8:	e8 04 fe ff ff       	call   5e1 <putc>
 7dd:	83 c4 10             	add    $0x10,%esp
        ap++;
 7e0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7e4:	eb 42                	jmp    828 <printf+0x170>
      } else if(c == '%'){
 7e6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7ea:	75 17                	jne    803 <printf+0x14b>
        putc(fd, c);
 7ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7ef:	0f be c0             	movsbl %al,%eax
 7f2:	83 ec 08             	sub    $0x8,%esp
 7f5:	50                   	push   %eax
 7f6:	ff 75 08             	pushl  0x8(%ebp)
 7f9:	e8 e3 fd ff ff       	call   5e1 <putc>
 7fe:	83 c4 10             	add    $0x10,%esp
 801:	eb 25                	jmp    828 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 803:	83 ec 08             	sub    $0x8,%esp
 806:	6a 25                	push   $0x25
 808:	ff 75 08             	pushl  0x8(%ebp)
 80b:	e8 d1 fd ff ff       	call   5e1 <putc>
 810:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 813:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 816:	0f be c0             	movsbl %al,%eax
 819:	83 ec 08             	sub    $0x8,%esp
 81c:	50                   	push   %eax
 81d:	ff 75 08             	pushl  0x8(%ebp)
 820:	e8 bc fd ff ff       	call   5e1 <putc>
 825:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 828:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 82f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 833:	8b 55 0c             	mov    0xc(%ebp),%edx
 836:	8b 45 f0             	mov    -0x10(%ebp),%eax
 839:	01 d0                	add    %edx,%eax
 83b:	0f b6 00             	movzbl (%eax),%eax
 83e:	84 c0                	test   %al,%al
 840:	0f 85 94 fe ff ff    	jne    6da <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 846:	90                   	nop
 847:	c9                   	leave  
 848:	c3                   	ret    

00000849 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 849:	55                   	push   %ebp
 84a:	89 e5                	mov    %esp,%ebp
 84c:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 84f:	8b 45 08             	mov    0x8(%ebp),%eax
 852:	83 e8 08             	sub    $0x8,%eax
 855:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 858:	a1 74 0f 00 00       	mov    0xf74,%eax
 85d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 860:	eb 24                	jmp    886 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 862:	8b 45 fc             	mov    -0x4(%ebp),%eax
 865:	8b 00                	mov    (%eax),%eax
 867:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 86a:	77 12                	ja     87e <free+0x35>
 86c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 86f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 872:	77 24                	ja     898 <free+0x4f>
 874:	8b 45 fc             	mov    -0x4(%ebp),%eax
 877:	8b 00                	mov    (%eax),%eax
 879:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 87c:	77 1a                	ja     898 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 87e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 881:	8b 00                	mov    (%eax),%eax
 883:	89 45 fc             	mov    %eax,-0x4(%ebp)
 886:	8b 45 f8             	mov    -0x8(%ebp),%eax
 889:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 88c:	76 d4                	jbe    862 <free+0x19>
 88e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 891:	8b 00                	mov    (%eax),%eax
 893:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 896:	76 ca                	jbe    862 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 898:	8b 45 f8             	mov    -0x8(%ebp),%eax
 89b:	8b 40 04             	mov    0x4(%eax),%eax
 89e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8a8:	01 c2                	add    %eax,%edx
 8aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ad:	8b 00                	mov    (%eax),%eax
 8af:	39 c2                	cmp    %eax,%edx
 8b1:	75 24                	jne    8d7 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 8b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8b6:	8b 50 04             	mov    0x4(%eax),%edx
 8b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8bc:	8b 00                	mov    (%eax),%eax
 8be:	8b 40 04             	mov    0x4(%eax),%eax
 8c1:	01 c2                	add    %eax,%edx
 8c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8c6:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 8c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8cc:	8b 00                	mov    (%eax),%eax
 8ce:	8b 10                	mov    (%eax),%edx
 8d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8d3:	89 10                	mov    %edx,(%eax)
 8d5:	eb 0a                	jmp    8e1 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 8d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8da:	8b 10                	mov    (%eax),%edx
 8dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8df:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 8e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e4:	8b 40 04             	mov    0x4(%eax),%eax
 8e7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f1:	01 d0                	add    %edx,%eax
 8f3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8f6:	75 20                	jne    918 <free+0xcf>
    p->s.size += bp->s.size;
 8f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8fb:	8b 50 04             	mov    0x4(%eax),%edx
 8fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
 901:	8b 40 04             	mov    0x4(%eax),%eax
 904:	01 c2                	add    %eax,%edx
 906:	8b 45 fc             	mov    -0x4(%ebp),%eax
 909:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 90c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 90f:	8b 10                	mov    (%eax),%edx
 911:	8b 45 fc             	mov    -0x4(%ebp),%eax
 914:	89 10                	mov    %edx,(%eax)
 916:	eb 08                	jmp    920 <free+0xd7>
  } else
    p->s.ptr = bp;
 918:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 91e:	89 10                	mov    %edx,(%eax)
  freep = p;
 920:	8b 45 fc             	mov    -0x4(%ebp),%eax
 923:	a3 74 0f 00 00       	mov    %eax,0xf74
}
 928:	90                   	nop
 929:	c9                   	leave  
 92a:	c3                   	ret    

0000092b <morecore>:

static Header*
morecore(uint nu)
{
 92b:	55                   	push   %ebp
 92c:	89 e5                	mov    %esp,%ebp
 92e:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 931:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 938:	77 07                	ja     941 <morecore+0x16>
    nu = 4096;
 93a:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 941:	8b 45 08             	mov    0x8(%ebp),%eax
 944:	c1 e0 03             	shl    $0x3,%eax
 947:	83 ec 0c             	sub    $0xc,%esp
 94a:	50                   	push   %eax
 94b:	e8 39 fc ff ff       	call   589 <sbrk>
 950:	83 c4 10             	add    $0x10,%esp
 953:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 956:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 95a:	75 07                	jne    963 <morecore+0x38>
    return 0;
 95c:	b8 00 00 00 00       	mov    $0x0,%eax
 961:	eb 26                	jmp    989 <morecore+0x5e>
  hp = (Header*)p;
 963:	8b 45 f4             	mov    -0xc(%ebp),%eax
 966:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 969:	8b 45 f0             	mov    -0x10(%ebp),%eax
 96c:	8b 55 08             	mov    0x8(%ebp),%edx
 96f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 972:	8b 45 f0             	mov    -0x10(%ebp),%eax
 975:	83 c0 08             	add    $0x8,%eax
 978:	83 ec 0c             	sub    $0xc,%esp
 97b:	50                   	push   %eax
 97c:	e8 c8 fe ff ff       	call   849 <free>
 981:	83 c4 10             	add    $0x10,%esp
  return freep;
 984:	a1 74 0f 00 00       	mov    0xf74,%eax
}
 989:	c9                   	leave  
 98a:	c3                   	ret    

0000098b <malloc>:

void*
malloc(uint nbytes)
{
 98b:	55                   	push   %ebp
 98c:	89 e5                	mov    %esp,%ebp
 98e:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 991:	8b 45 08             	mov    0x8(%ebp),%eax
 994:	83 c0 07             	add    $0x7,%eax
 997:	c1 e8 03             	shr    $0x3,%eax
 99a:	83 c0 01             	add    $0x1,%eax
 99d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9a0:	a1 74 0f 00 00       	mov    0xf74,%eax
 9a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9ac:	75 23                	jne    9d1 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 9ae:	c7 45 f0 6c 0f 00 00 	movl   $0xf6c,-0x10(%ebp)
 9b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9b8:	a3 74 0f 00 00       	mov    %eax,0xf74
 9bd:	a1 74 0f 00 00       	mov    0xf74,%eax
 9c2:	a3 6c 0f 00 00       	mov    %eax,0xf6c
    base.s.size = 0;
 9c7:	c7 05 70 0f 00 00 00 	movl   $0x0,0xf70
 9ce:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9d4:	8b 00                	mov    (%eax),%eax
 9d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9dc:	8b 40 04             	mov    0x4(%eax),%eax
 9df:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9e2:	72 4d                	jb     a31 <malloc+0xa6>
      if(p->s.size == nunits)
 9e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e7:	8b 40 04             	mov    0x4(%eax),%eax
 9ea:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9ed:	75 0c                	jne    9fb <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 9ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f2:	8b 10                	mov    (%eax),%edx
 9f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9f7:	89 10                	mov    %edx,(%eax)
 9f9:	eb 26                	jmp    a21 <malloc+0x96>
      else {
        p->s.size -= nunits;
 9fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9fe:	8b 40 04             	mov    0x4(%eax),%eax
 a01:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a04:	89 c2                	mov    %eax,%edx
 a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a09:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a0f:	8b 40 04             	mov    0x4(%eax),%eax
 a12:	c1 e0 03             	shl    $0x3,%eax
 a15:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a1b:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a1e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a21:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a24:	a3 74 0f 00 00       	mov    %eax,0xf74
      return (void*)(p + 1);
 a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a2c:	83 c0 08             	add    $0x8,%eax
 a2f:	eb 3b                	jmp    a6c <malloc+0xe1>
    }
    if(p == freep)
 a31:	a1 74 0f 00 00       	mov    0xf74,%eax
 a36:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a39:	75 1e                	jne    a59 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a3b:	83 ec 0c             	sub    $0xc,%esp
 a3e:	ff 75 ec             	pushl  -0x14(%ebp)
 a41:	e8 e5 fe ff ff       	call   92b <morecore>
 a46:	83 c4 10             	add    $0x10,%esp
 a49:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a50:	75 07                	jne    a59 <malloc+0xce>
        return 0;
 a52:	b8 00 00 00 00       	mov    $0x0,%eax
 a57:	eb 13                	jmp    a6c <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a62:	8b 00                	mov    (%eax),%eax
 a64:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a67:	e9 6d ff ff ff       	jmp    9d9 <malloc+0x4e>
}
 a6c:	c9                   	leave  
 a6d:	c3                   	ret    
