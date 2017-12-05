
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
  11:	e8 41 06 00 00       	call   657 <getuid>
  16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(1, "Current UID is: %d\n", uid);
  19:	83 ec 04             	sub    $0x4,%esp
  1c:	ff 75 f4             	pushl  -0xc(%ebp)
  1f:	68 34 0b 00 00       	push   $0xb34
  24:	6a 01                	push   $0x1
  26:	e8 53 07 00 00       	call   77e <printf>
  2b:	83 c4 10             	add    $0x10,%esp
  printf(1, "Setting UID to 100\n");
  2e:	83 ec 08             	sub    $0x8,%esp
  31:	68 48 0b 00 00       	push   $0xb48
  36:	6a 01                	push   $0x1
  38:	e8 41 07 00 00       	call   77e <printf>
  3d:	83 c4 10             	add    $0x10,%esp
  if(setuid(100) == -1) {
  40:	83 ec 0c             	sub    $0xc,%esp
  43:	6a 64                	push   $0x64
  45:	e8 25 06 00 00       	call   66f <setuid>
  4a:	83 c4 10             	add    $0x10,%esp
  4d:	83 f8 ff             	cmp    $0xffffffff,%eax
  50:	75 17                	jne    69 <main+0x69>
    printf(1, "Setting UID failed. Test FAILED.\n");
  52:	83 ec 08             	sub    $0x8,%esp
  55:	68 5c 0b 00 00       	push   $0xb5c
  5a:	6a 01                	push   $0x1
  5c:	e8 1d 07 00 00       	call   77e <printf>
  61:	83 c4 10             	add    $0x10,%esp
    exit();
  64:	e8 3e 05 00 00       	call   5a7 <exit>
  }
  uid = getuid();
  69:	e8 e9 05 00 00       	call   657 <getuid>
  6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(1, "Current UID is: %d\n", uid);
  71:	83 ec 04             	sub    $0x4,%esp
  74:	ff 75 f4             	pushl  -0xc(%ebp)
  77:	68 34 0b 00 00       	push   $0xb34
  7c:	6a 01                	push   $0x1
  7e:	e8 fb 06 00 00       	call   77e <printf>
  83:	83 c4 10             	add    $0x10,%esp
  printf(1, "Setting UID to 32,768\n");
  86:	83 ec 08             	sub    $0x8,%esp
  89:	68 7e 0b 00 00       	push   $0xb7e
  8e:	6a 01                	push   $0x1
  90:	e8 e9 06 00 00       	call   77e <printf>
  95:	83 c4 10             	add    $0x10,%esp
  if(setuid(32768) == 0) {
  98:	83 ec 0c             	sub    $0xc,%esp
  9b:	68 00 80 00 00       	push   $0x8000
  a0:	e8 ca 05 00 00       	call   66f <setuid>
  a5:	83 c4 10             	add    $0x10,%esp
  a8:	85 c0                	test   %eax,%eax
  aa:	75 17                	jne    c3 <main+0xc3>
    printf(1, "Setting UID succeeded. Set should fail. Test FAILED.\n");
  ac:	83 ec 08             	sub    $0x8,%esp
  af:	68 98 0b 00 00       	push   $0xb98
  b4:	6a 01                	push   $0x1
  b6:	e8 c3 06 00 00       	call   77e <printf>
  bb:	83 c4 10             	add    $0x10,%esp
    exit();
  be:	e8 e4 04 00 00       	call   5a7 <exit>
  }
  else
    printf(1, "Not allowed to set UID to 32,768. PASSED.\n");
  c3:	83 ec 08             	sub    $0x8,%esp
  c6:	68 d0 0b 00 00       	push   $0xbd0
  cb:	6a 01                	push   $0x1
  cd:	e8 ac 06 00 00       	call   77e <printf>
  d2:	83 c4 10             	add    $0x10,%esp
  printf(1, "Setting UID to -1\n");
  d5:	83 ec 08             	sub    $0x8,%esp
  d8:	68 fb 0b 00 00       	push   $0xbfb
  dd:	6a 01                	push   $0x1
  df:	e8 9a 06 00 00       	call   77e <printf>
  e4:	83 c4 10             	add    $0x10,%esp
  if(setuid(-1) == 0) {
  e7:	83 ec 0c             	sub    $0xc,%esp
  ea:	6a ff                	push   $0xffffffff
  ec:	e8 7e 05 00 00       	call   66f <setuid>
  f1:	83 c4 10             	add    $0x10,%esp
  f4:	85 c0                	test   %eax,%eax
  f6:	75 17                	jne    10f <main+0x10f>
    printf(1, "Setting UID succeeded.  Set should fail. Test FAILED.\n");
  f8:	83 ec 08             	sub    $0x8,%esp
  fb:	68 10 0c 00 00       	push   $0xc10
 100:	6a 01                	push   $0x1
 102:	e8 77 06 00 00       	call   77e <printf>
 107:	83 c4 10             	add    $0x10,%esp
    exit();
 10a:	e8 98 04 00 00       	call   5a7 <exit>
  }
  else
    printf(1, "Not allowed to set UID to -1. PASSED.\n");
 10f:	83 ec 08             	sub    $0x8,%esp
 112:	68 48 0c 00 00       	push   $0xc48
 117:	6a 01                	push   $0x1
 119:	e8 60 06 00 00       	call   77e <printf>
 11e:	83 c4 10             	add    $0x10,%esp

  gid = getgid();
 121:	e8 39 05 00 00       	call   65f <getgid>
 126:	89 45 f0             	mov    %eax,-0x10(%ebp)
  printf(1, "Current GID is: %d\n", gid);
 129:	83 ec 04             	sub    $0x4,%esp
 12c:	ff 75 f0             	pushl  -0x10(%ebp)
 12f:	68 6f 0c 00 00       	push   $0xc6f
 134:	6a 01                	push   $0x1
 136:	e8 43 06 00 00       	call   77e <printf>
 13b:	83 c4 10             	add    $0x10,%esp
  printf(1, "Setting GID to 100\n");
 13e:	83 ec 08             	sub    $0x8,%esp
 141:	68 83 0c 00 00       	push   $0xc83
 146:	6a 01                	push   $0x1
 148:	e8 31 06 00 00       	call   77e <printf>
 14d:	83 c4 10             	add    $0x10,%esp
  if(setgid(100) == -1) {
 150:	83 ec 0c             	sub    $0xc,%esp
 153:	6a 64                	push   $0x64
 155:	e8 1d 05 00 00       	call   677 <setgid>
 15a:	83 c4 10             	add    $0x10,%esp
 15d:	83 f8 ff             	cmp    $0xffffffff,%eax
 160:	75 17                	jne    179 <main+0x179>
    printf(1, "Setting GID failed. Test FAILED.\n");
 162:	83 ec 08             	sub    $0x8,%esp
 165:	68 98 0c 00 00       	push   $0xc98
 16a:	6a 01                	push   $0x1
 16c:	e8 0d 06 00 00       	call   77e <printf>
 171:	83 c4 10             	add    $0x10,%esp
    exit();
 174:	e8 2e 04 00 00       	call   5a7 <exit>
  }
  gid = getgid();
 179:	e8 e1 04 00 00       	call   65f <getgid>
 17e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  printf(1, "Current GID is: %d\n", gid);
 181:	83 ec 04             	sub    $0x4,%esp
 184:	ff 75 f0             	pushl  -0x10(%ebp)
 187:	68 6f 0c 00 00       	push   $0xc6f
 18c:	6a 01                	push   $0x1
 18e:	e8 eb 05 00 00       	call   77e <printf>
 193:	83 c4 10             	add    $0x10,%esp
  printf(1, "Setting GID to 32,768\n");
 196:	83 ec 08             	sub    $0x8,%esp
 199:	68 ba 0c 00 00       	push   $0xcba
 19e:	6a 01                	push   $0x1
 1a0:	e8 d9 05 00 00       	call   77e <printf>
 1a5:	83 c4 10             	add    $0x10,%esp
  if(setgid(32768) == 0) {
 1a8:	83 ec 0c             	sub    $0xc,%esp
 1ab:	68 00 80 00 00       	push   $0x8000
 1b0:	e8 c2 04 00 00       	call   677 <setgid>
 1b5:	83 c4 10             	add    $0x10,%esp
 1b8:	85 c0                	test   %eax,%eax
 1ba:	75 17                	jne    1d3 <main+0x1d3>
    printf(1, "Setting GID succeeded. Set should fail. Test FAILED.\n");
 1bc:	83 ec 08             	sub    $0x8,%esp
 1bf:	68 d4 0c 00 00       	push   $0xcd4
 1c4:	6a 01                	push   $0x1
 1c6:	e8 b3 05 00 00       	call   77e <printf>
 1cb:	83 c4 10             	add    $0x10,%esp
    exit();
 1ce:	e8 d4 03 00 00       	call   5a7 <exit>
  }
  else
    printf(1, "Not allowed to set GID to 32,768. PASSED.\n");
 1d3:	83 ec 08             	sub    $0x8,%esp
 1d6:	68 0c 0d 00 00       	push   $0xd0c
 1db:	6a 01                	push   $0x1
 1dd:	e8 9c 05 00 00       	call   77e <printf>
 1e2:	83 c4 10             	add    $0x10,%esp
  printf(1, "Setting GID to -1\n");
 1e5:	83 ec 08             	sub    $0x8,%esp
 1e8:	68 37 0d 00 00       	push   $0xd37
 1ed:	6a 01                	push   $0x1
 1ef:	e8 8a 05 00 00       	call   77e <printf>
 1f4:	83 c4 10             	add    $0x10,%esp
  if(setgid(-1) == 0) {
 1f7:	83 ec 0c             	sub    $0xc,%esp
 1fa:	6a ff                	push   $0xffffffff
 1fc:	e8 76 04 00 00       	call   677 <setgid>
 201:	83 c4 10             	add    $0x10,%esp
 204:	85 c0                	test   %eax,%eax
 206:	75 17                	jne    21f <main+0x21f>
    printf(1, "Setting GID succeeded.  Set should fail. Test FAILED.\n");
 208:	83 ec 08             	sub    $0x8,%esp
 20b:	68 4c 0d 00 00       	push   $0xd4c
 210:	6a 01                	push   $0x1
 212:	e8 67 05 00 00       	call   77e <printf>
 217:	83 c4 10             	add    $0x10,%esp
    exit();
 21a:	e8 88 03 00 00       	call   5a7 <exit>
  }
  else
    printf(1, "Not allowed to set GID to -1. PASSED.\n");
 21f:	83 ec 08             	sub    $0x8,%esp
 222:	68 84 0d 00 00       	push   $0xd84
 227:	6a 01                	push   $0x1
 229:	e8 50 05 00 00       	call   77e <printf>
 22e:	83 c4 10             	add    $0x10,%esp
  
  ppid = getppid();
 231:	e8 31 04 00 00       	call   667 <getppid>
 236:	89 45 ec             	mov    %eax,-0x14(%ebp)
  printf(1, "My process ID is: %d\n", getpid());
 239:	e8 e9 03 00 00       	call   627 <getpid>
 23e:	83 ec 04             	sub    $0x4,%esp
 241:	50                   	push   %eax
 242:	68 ab 0d 00 00       	push   $0xdab
 247:	6a 01                	push   $0x1
 249:	e8 30 05 00 00       	call   77e <printf>
 24e:	83 c4 10             	add    $0x10,%esp
  printf(1, "My parent process ID is: %d\n", ppid);
 251:	83 ec 04             	sub    $0x4,%esp
 254:	ff 75 ec             	pushl  -0x14(%ebp)
 257:	68 c1 0d 00 00       	push   $0xdc1
 25c:	6a 01                	push   $0x1
 25e:	e8 1b 05 00 00       	call   77e <printf>
 263:	83 c4 10             	add    $0x10,%esp
  printf(1, "Done!\n");
 266:	83 ec 08             	sub    $0x8,%esp
 269:	68 de 0d 00 00       	push   $0xdde
 26e:	6a 01                	push   $0x1
 270:	e8 09 05 00 00       	call   77e <printf>
 275:	83 c4 10             	add    $0x10,%esp

  exit();
 278:	e8 2a 03 00 00       	call   5a7 <exit>

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
 3a0:	e8 1a 02 00 00       	call   5bf <read>
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
 403:	e8 df 01 00 00       	call   5e7 <open>
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
 424:	e8 d6 01 00 00       	call   5ff <fstat>
 429:	83 c4 10             	add    $0x10,%esp
 42c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 42f:	83 ec 0c             	sub    $0xc,%esp
 432:	ff 75 f4             	pushl  -0xc(%ebp)
 435:	e8 95 01 00 00       	call   5cf <close>
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

00000511 <atoo>:

#ifdef CS333_P5
int
atoo(const char *s)
{
 511:	55                   	push   %ebp
 512:	89 e5                	mov    %esp,%ebp
 514:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 517:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 51e:	eb 04                	jmp    524 <atoo+0x13>
 520:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 524:	8b 45 08             	mov    0x8(%ebp),%eax
 527:	0f b6 00             	movzbl (%eax),%eax
 52a:	3c 20                	cmp    $0x20,%al
 52c:	74 f2                	je     520 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 52e:	8b 45 08             	mov    0x8(%ebp),%eax
 531:	0f b6 00             	movzbl (%eax),%eax
 534:	3c 2d                	cmp    $0x2d,%al
 536:	75 07                	jne    53f <atoo+0x2e>
 538:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 53d:	eb 05                	jmp    544 <atoo+0x33>
 53f:	b8 01 00 00 00       	mov    $0x1,%eax
 544:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 547:	8b 45 08             	mov    0x8(%ebp),%eax
 54a:	0f b6 00             	movzbl (%eax),%eax
 54d:	3c 2b                	cmp    $0x2b,%al
 54f:	74 0a                	je     55b <atoo+0x4a>
 551:	8b 45 08             	mov    0x8(%ebp),%eax
 554:	0f b6 00             	movzbl (%eax),%eax
 557:	3c 2d                	cmp    $0x2d,%al
 559:	75 27                	jne    582 <atoo+0x71>
    s++;
 55b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 55f:	eb 21                	jmp    582 <atoo+0x71>
    n = n*8 + *s++ - '0';
 561:	8b 45 fc             	mov    -0x4(%ebp),%eax
 564:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 56b:	8b 45 08             	mov    0x8(%ebp),%eax
 56e:	8d 50 01             	lea    0x1(%eax),%edx
 571:	89 55 08             	mov    %edx,0x8(%ebp)
 574:	0f b6 00             	movzbl (%eax),%eax
 577:	0f be c0             	movsbl %al,%eax
 57a:	01 c8                	add    %ecx,%eax
 57c:	83 e8 30             	sub    $0x30,%eax
 57f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 582:	8b 45 08             	mov    0x8(%ebp),%eax
 585:	0f b6 00             	movzbl (%eax),%eax
 588:	3c 2f                	cmp    $0x2f,%al
 58a:	7e 0a                	jle    596 <atoo+0x85>
 58c:	8b 45 08             	mov    0x8(%ebp),%eax
 58f:	0f b6 00             	movzbl (%eax),%eax
 592:	3c 39                	cmp    $0x39,%al
 594:	7e cb                	jle    561 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 596:	8b 45 f8             	mov    -0x8(%ebp),%eax
 599:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 59d:	c9                   	leave  
 59e:	c3                   	ret    

0000059f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 59f:	b8 01 00 00 00       	mov    $0x1,%eax
 5a4:	cd 40                	int    $0x40
 5a6:	c3                   	ret    

000005a7 <exit>:
SYSCALL(exit)
 5a7:	b8 02 00 00 00       	mov    $0x2,%eax
 5ac:	cd 40                	int    $0x40
 5ae:	c3                   	ret    

000005af <wait>:
SYSCALL(wait)
 5af:	b8 03 00 00 00       	mov    $0x3,%eax
 5b4:	cd 40                	int    $0x40
 5b6:	c3                   	ret    

000005b7 <pipe>:
SYSCALL(pipe)
 5b7:	b8 04 00 00 00       	mov    $0x4,%eax
 5bc:	cd 40                	int    $0x40
 5be:	c3                   	ret    

000005bf <read>:
SYSCALL(read)
 5bf:	b8 05 00 00 00       	mov    $0x5,%eax
 5c4:	cd 40                	int    $0x40
 5c6:	c3                   	ret    

000005c7 <write>:
SYSCALL(write)
 5c7:	b8 10 00 00 00       	mov    $0x10,%eax
 5cc:	cd 40                	int    $0x40
 5ce:	c3                   	ret    

000005cf <close>:
SYSCALL(close)
 5cf:	b8 15 00 00 00       	mov    $0x15,%eax
 5d4:	cd 40                	int    $0x40
 5d6:	c3                   	ret    

000005d7 <kill>:
SYSCALL(kill)
 5d7:	b8 06 00 00 00       	mov    $0x6,%eax
 5dc:	cd 40                	int    $0x40
 5de:	c3                   	ret    

000005df <exec>:
SYSCALL(exec)
 5df:	b8 07 00 00 00       	mov    $0x7,%eax
 5e4:	cd 40                	int    $0x40
 5e6:	c3                   	ret    

000005e7 <open>:
SYSCALL(open)
 5e7:	b8 0f 00 00 00       	mov    $0xf,%eax
 5ec:	cd 40                	int    $0x40
 5ee:	c3                   	ret    

000005ef <mknod>:
SYSCALL(mknod)
 5ef:	b8 11 00 00 00       	mov    $0x11,%eax
 5f4:	cd 40                	int    $0x40
 5f6:	c3                   	ret    

000005f7 <unlink>:
SYSCALL(unlink)
 5f7:	b8 12 00 00 00       	mov    $0x12,%eax
 5fc:	cd 40                	int    $0x40
 5fe:	c3                   	ret    

000005ff <fstat>:
SYSCALL(fstat)
 5ff:	b8 08 00 00 00       	mov    $0x8,%eax
 604:	cd 40                	int    $0x40
 606:	c3                   	ret    

00000607 <link>:
SYSCALL(link)
 607:	b8 13 00 00 00       	mov    $0x13,%eax
 60c:	cd 40                	int    $0x40
 60e:	c3                   	ret    

0000060f <mkdir>:
SYSCALL(mkdir)
 60f:	b8 14 00 00 00       	mov    $0x14,%eax
 614:	cd 40                	int    $0x40
 616:	c3                   	ret    

00000617 <chdir>:
SYSCALL(chdir)
 617:	b8 09 00 00 00       	mov    $0x9,%eax
 61c:	cd 40                	int    $0x40
 61e:	c3                   	ret    

0000061f <dup>:
SYSCALL(dup)
 61f:	b8 0a 00 00 00       	mov    $0xa,%eax
 624:	cd 40                	int    $0x40
 626:	c3                   	ret    

00000627 <getpid>:
SYSCALL(getpid)
 627:	b8 0b 00 00 00       	mov    $0xb,%eax
 62c:	cd 40                	int    $0x40
 62e:	c3                   	ret    

0000062f <sbrk>:
SYSCALL(sbrk)
 62f:	b8 0c 00 00 00       	mov    $0xc,%eax
 634:	cd 40                	int    $0x40
 636:	c3                   	ret    

00000637 <sleep>:
SYSCALL(sleep)
 637:	b8 0d 00 00 00       	mov    $0xd,%eax
 63c:	cd 40                	int    $0x40
 63e:	c3                   	ret    

0000063f <uptime>:
SYSCALL(uptime)
 63f:	b8 0e 00 00 00       	mov    $0xe,%eax
 644:	cd 40                	int    $0x40
 646:	c3                   	ret    

00000647 <halt>:
SYSCALL(halt)
 647:	b8 16 00 00 00       	mov    $0x16,%eax
 64c:	cd 40                	int    $0x40
 64e:	c3                   	ret    

0000064f <date>:
SYSCALL(date)
 64f:	b8 17 00 00 00       	mov    $0x17,%eax
 654:	cd 40                	int    $0x40
 656:	c3                   	ret    

00000657 <getuid>:
SYSCALL(getuid)
 657:	b8 18 00 00 00       	mov    $0x18,%eax
 65c:	cd 40                	int    $0x40
 65e:	c3                   	ret    

0000065f <getgid>:
SYSCALL(getgid)
 65f:	b8 19 00 00 00       	mov    $0x19,%eax
 664:	cd 40                	int    $0x40
 666:	c3                   	ret    

00000667 <getppid>:
SYSCALL(getppid)
 667:	b8 1a 00 00 00       	mov    $0x1a,%eax
 66c:	cd 40                	int    $0x40
 66e:	c3                   	ret    

0000066f <setuid>:
SYSCALL(setuid)
 66f:	b8 1b 00 00 00       	mov    $0x1b,%eax
 674:	cd 40                	int    $0x40
 676:	c3                   	ret    

00000677 <setgid>:
SYSCALL(setgid)
 677:	b8 1c 00 00 00       	mov    $0x1c,%eax
 67c:	cd 40                	int    $0x40
 67e:	c3                   	ret    

0000067f <getprocs>:
SYSCALL(getprocs)
 67f:	b8 1d 00 00 00       	mov    $0x1d,%eax
 684:	cd 40                	int    $0x40
 686:	c3                   	ret    

00000687 <setpriority>:
SYSCALL(setpriority)
 687:	b8 1e 00 00 00       	mov    $0x1e,%eax
 68c:	cd 40                	int    $0x40
 68e:	c3                   	ret    

0000068f <chmod>:
SYSCALL(chmod)
 68f:	b8 1f 00 00 00       	mov    $0x1f,%eax
 694:	cd 40                	int    $0x40
 696:	c3                   	ret    

00000697 <chown>:
SYSCALL(chown)
 697:	b8 20 00 00 00       	mov    $0x20,%eax
 69c:	cd 40                	int    $0x40
 69e:	c3                   	ret    

0000069f <chgrp>:
SYSCALL(chgrp)
 69f:	b8 21 00 00 00       	mov    $0x21,%eax
 6a4:	cd 40                	int    $0x40
 6a6:	c3                   	ret    

000006a7 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 6a7:	55                   	push   %ebp
 6a8:	89 e5                	mov    %esp,%ebp
 6aa:	83 ec 18             	sub    $0x18,%esp
 6ad:	8b 45 0c             	mov    0xc(%ebp),%eax
 6b0:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 6b3:	83 ec 04             	sub    $0x4,%esp
 6b6:	6a 01                	push   $0x1
 6b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
 6bb:	50                   	push   %eax
 6bc:	ff 75 08             	pushl  0x8(%ebp)
 6bf:	e8 03 ff ff ff       	call   5c7 <write>
 6c4:	83 c4 10             	add    $0x10,%esp
}
 6c7:	90                   	nop
 6c8:	c9                   	leave  
 6c9:	c3                   	ret    

000006ca <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6ca:	55                   	push   %ebp
 6cb:	89 e5                	mov    %esp,%ebp
 6cd:	53                   	push   %ebx
 6ce:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6d1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 6d8:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6dc:	74 17                	je     6f5 <printint+0x2b>
 6de:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6e2:	79 11                	jns    6f5 <printint+0x2b>
    neg = 1;
 6e4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6eb:	8b 45 0c             	mov    0xc(%ebp),%eax
 6ee:	f7 d8                	neg    %eax
 6f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6f3:	eb 06                	jmp    6fb <printint+0x31>
  } else {
    x = xx;
 6f5:	8b 45 0c             	mov    0xc(%ebp),%eax
 6f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 6fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 702:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 705:	8d 41 01             	lea    0x1(%ecx),%eax
 708:	89 45 f4             	mov    %eax,-0xc(%ebp)
 70b:	8b 5d 10             	mov    0x10(%ebp),%ebx
 70e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 711:	ba 00 00 00 00       	mov    $0x0,%edx
 716:	f7 f3                	div    %ebx
 718:	89 d0                	mov    %edx,%eax
 71a:	0f b6 80 54 10 00 00 	movzbl 0x1054(%eax),%eax
 721:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 725:	8b 5d 10             	mov    0x10(%ebp),%ebx
 728:	8b 45 ec             	mov    -0x14(%ebp),%eax
 72b:	ba 00 00 00 00       	mov    $0x0,%edx
 730:	f7 f3                	div    %ebx
 732:	89 45 ec             	mov    %eax,-0x14(%ebp)
 735:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 739:	75 c7                	jne    702 <printint+0x38>
  if(neg)
 73b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 73f:	74 2d                	je     76e <printint+0xa4>
    buf[i++] = '-';
 741:	8b 45 f4             	mov    -0xc(%ebp),%eax
 744:	8d 50 01             	lea    0x1(%eax),%edx
 747:	89 55 f4             	mov    %edx,-0xc(%ebp)
 74a:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 74f:	eb 1d                	jmp    76e <printint+0xa4>
    putc(fd, buf[i]);
 751:	8d 55 dc             	lea    -0x24(%ebp),%edx
 754:	8b 45 f4             	mov    -0xc(%ebp),%eax
 757:	01 d0                	add    %edx,%eax
 759:	0f b6 00             	movzbl (%eax),%eax
 75c:	0f be c0             	movsbl %al,%eax
 75f:	83 ec 08             	sub    $0x8,%esp
 762:	50                   	push   %eax
 763:	ff 75 08             	pushl  0x8(%ebp)
 766:	e8 3c ff ff ff       	call   6a7 <putc>
 76b:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 76e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 772:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 776:	79 d9                	jns    751 <printint+0x87>
    putc(fd, buf[i]);
}
 778:	90                   	nop
 779:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 77c:	c9                   	leave  
 77d:	c3                   	ret    

0000077e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 77e:	55                   	push   %ebp
 77f:	89 e5                	mov    %esp,%ebp
 781:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 784:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 78b:	8d 45 0c             	lea    0xc(%ebp),%eax
 78e:	83 c0 04             	add    $0x4,%eax
 791:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 794:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 79b:	e9 59 01 00 00       	jmp    8f9 <printf+0x17b>
    c = fmt[i] & 0xff;
 7a0:	8b 55 0c             	mov    0xc(%ebp),%edx
 7a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a6:	01 d0                	add    %edx,%eax
 7a8:	0f b6 00             	movzbl (%eax),%eax
 7ab:	0f be c0             	movsbl %al,%eax
 7ae:	25 ff 00 00 00       	and    $0xff,%eax
 7b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 7b6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7ba:	75 2c                	jne    7e8 <printf+0x6a>
      if(c == '%'){
 7bc:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7c0:	75 0c                	jne    7ce <printf+0x50>
        state = '%';
 7c2:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 7c9:	e9 27 01 00 00       	jmp    8f5 <printf+0x177>
      } else {
        putc(fd, c);
 7ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7d1:	0f be c0             	movsbl %al,%eax
 7d4:	83 ec 08             	sub    $0x8,%esp
 7d7:	50                   	push   %eax
 7d8:	ff 75 08             	pushl  0x8(%ebp)
 7db:	e8 c7 fe ff ff       	call   6a7 <putc>
 7e0:	83 c4 10             	add    $0x10,%esp
 7e3:	e9 0d 01 00 00       	jmp    8f5 <printf+0x177>
      }
    } else if(state == '%'){
 7e8:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 7ec:	0f 85 03 01 00 00    	jne    8f5 <printf+0x177>
      if(c == 'd'){
 7f2:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 7f6:	75 1e                	jne    816 <printf+0x98>
        printint(fd, *ap, 10, 1);
 7f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7fb:	8b 00                	mov    (%eax),%eax
 7fd:	6a 01                	push   $0x1
 7ff:	6a 0a                	push   $0xa
 801:	50                   	push   %eax
 802:	ff 75 08             	pushl  0x8(%ebp)
 805:	e8 c0 fe ff ff       	call   6ca <printint>
 80a:	83 c4 10             	add    $0x10,%esp
        ap++;
 80d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 811:	e9 d8 00 00 00       	jmp    8ee <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 816:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 81a:	74 06                	je     822 <printf+0xa4>
 81c:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 820:	75 1e                	jne    840 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 822:	8b 45 e8             	mov    -0x18(%ebp),%eax
 825:	8b 00                	mov    (%eax),%eax
 827:	6a 00                	push   $0x0
 829:	6a 10                	push   $0x10
 82b:	50                   	push   %eax
 82c:	ff 75 08             	pushl  0x8(%ebp)
 82f:	e8 96 fe ff ff       	call   6ca <printint>
 834:	83 c4 10             	add    $0x10,%esp
        ap++;
 837:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 83b:	e9 ae 00 00 00       	jmp    8ee <printf+0x170>
      } else if(c == 's'){
 840:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 844:	75 43                	jne    889 <printf+0x10b>
        s = (char*)*ap;
 846:	8b 45 e8             	mov    -0x18(%ebp),%eax
 849:	8b 00                	mov    (%eax),%eax
 84b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 84e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 852:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 856:	75 25                	jne    87d <printf+0xff>
          s = "(null)";
 858:	c7 45 f4 e5 0d 00 00 	movl   $0xde5,-0xc(%ebp)
        while(*s != 0){
 85f:	eb 1c                	jmp    87d <printf+0xff>
          putc(fd, *s);
 861:	8b 45 f4             	mov    -0xc(%ebp),%eax
 864:	0f b6 00             	movzbl (%eax),%eax
 867:	0f be c0             	movsbl %al,%eax
 86a:	83 ec 08             	sub    $0x8,%esp
 86d:	50                   	push   %eax
 86e:	ff 75 08             	pushl  0x8(%ebp)
 871:	e8 31 fe ff ff       	call   6a7 <putc>
 876:	83 c4 10             	add    $0x10,%esp
          s++;
 879:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 87d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 880:	0f b6 00             	movzbl (%eax),%eax
 883:	84 c0                	test   %al,%al
 885:	75 da                	jne    861 <printf+0xe3>
 887:	eb 65                	jmp    8ee <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 889:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 88d:	75 1d                	jne    8ac <printf+0x12e>
        putc(fd, *ap);
 88f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 892:	8b 00                	mov    (%eax),%eax
 894:	0f be c0             	movsbl %al,%eax
 897:	83 ec 08             	sub    $0x8,%esp
 89a:	50                   	push   %eax
 89b:	ff 75 08             	pushl  0x8(%ebp)
 89e:	e8 04 fe ff ff       	call   6a7 <putc>
 8a3:	83 c4 10             	add    $0x10,%esp
        ap++;
 8a6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8aa:	eb 42                	jmp    8ee <printf+0x170>
      } else if(c == '%'){
 8ac:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8b0:	75 17                	jne    8c9 <printf+0x14b>
        putc(fd, c);
 8b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8b5:	0f be c0             	movsbl %al,%eax
 8b8:	83 ec 08             	sub    $0x8,%esp
 8bb:	50                   	push   %eax
 8bc:	ff 75 08             	pushl  0x8(%ebp)
 8bf:	e8 e3 fd ff ff       	call   6a7 <putc>
 8c4:	83 c4 10             	add    $0x10,%esp
 8c7:	eb 25                	jmp    8ee <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8c9:	83 ec 08             	sub    $0x8,%esp
 8cc:	6a 25                	push   $0x25
 8ce:	ff 75 08             	pushl  0x8(%ebp)
 8d1:	e8 d1 fd ff ff       	call   6a7 <putc>
 8d6:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 8d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8dc:	0f be c0             	movsbl %al,%eax
 8df:	83 ec 08             	sub    $0x8,%esp
 8e2:	50                   	push   %eax
 8e3:	ff 75 08             	pushl  0x8(%ebp)
 8e6:	e8 bc fd ff ff       	call   6a7 <putc>
 8eb:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 8ee:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8f5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 8f9:	8b 55 0c             	mov    0xc(%ebp),%edx
 8fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ff:	01 d0                	add    %edx,%eax
 901:	0f b6 00             	movzbl (%eax),%eax
 904:	84 c0                	test   %al,%al
 906:	0f 85 94 fe ff ff    	jne    7a0 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 90c:	90                   	nop
 90d:	c9                   	leave  
 90e:	c3                   	ret    

0000090f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 90f:	55                   	push   %ebp
 910:	89 e5                	mov    %esp,%ebp
 912:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 915:	8b 45 08             	mov    0x8(%ebp),%eax
 918:	83 e8 08             	sub    $0x8,%eax
 91b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 91e:	a1 70 10 00 00       	mov    0x1070,%eax
 923:	89 45 fc             	mov    %eax,-0x4(%ebp)
 926:	eb 24                	jmp    94c <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 928:	8b 45 fc             	mov    -0x4(%ebp),%eax
 92b:	8b 00                	mov    (%eax),%eax
 92d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 930:	77 12                	ja     944 <free+0x35>
 932:	8b 45 f8             	mov    -0x8(%ebp),%eax
 935:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 938:	77 24                	ja     95e <free+0x4f>
 93a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93d:	8b 00                	mov    (%eax),%eax
 93f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 942:	77 1a                	ja     95e <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 944:	8b 45 fc             	mov    -0x4(%ebp),%eax
 947:	8b 00                	mov    (%eax),%eax
 949:	89 45 fc             	mov    %eax,-0x4(%ebp)
 94c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 94f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 952:	76 d4                	jbe    928 <free+0x19>
 954:	8b 45 fc             	mov    -0x4(%ebp),%eax
 957:	8b 00                	mov    (%eax),%eax
 959:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 95c:	76 ca                	jbe    928 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 95e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 961:	8b 40 04             	mov    0x4(%eax),%eax
 964:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 96b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 96e:	01 c2                	add    %eax,%edx
 970:	8b 45 fc             	mov    -0x4(%ebp),%eax
 973:	8b 00                	mov    (%eax),%eax
 975:	39 c2                	cmp    %eax,%edx
 977:	75 24                	jne    99d <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 979:	8b 45 f8             	mov    -0x8(%ebp),%eax
 97c:	8b 50 04             	mov    0x4(%eax),%edx
 97f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 982:	8b 00                	mov    (%eax),%eax
 984:	8b 40 04             	mov    0x4(%eax),%eax
 987:	01 c2                	add    %eax,%edx
 989:	8b 45 f8             	mov    -0x8(%ebp),%eax
 98c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 98f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 992:	8b 00                	mov    (%eax),%eax
 994:	8b 10                	mov    (%eax),%edx
 996:	8b 45 f8             	mov    -0x8(%ebp),%eax
 999:	89 10                	mov    %edx,(%eax)
 99b:	eb 0a                	jmp    9a7 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 99d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a0:	8b 10                	mov    (%eax),%edx
 9a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9a5:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 9a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9aa:	8b 40 04             	mov    0x4(%eax),%eax
 9ad:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b7:	01 d0                	add    %edx,%eax
 9b9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9bc:	75 20                	jne    9de <free+0xcf>
    p->s.size += bp->s.size;
 9be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c1:	8b 50 04             	mov    0x4(%eax),%edx
 9c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9c7:	8b 40 04             	mov    0x4(%eax),%eax
 9ca:	01 c2                	add    %eax,%edx
 9cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9cf:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9d5:	8b 10                	mov    (%eax),%edx
 9d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9da:	89 10                	mov    %edx,(%eax)
 9dc:	eb 08                	jmp    9e6 <free+0xd7>
  } else
    p->s.ptr = bp;
 9de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9e4:	89 10                	mov    %edx,(%eax)
  freep = p;
 9e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e9:	a3 70 10 00 00       	mov    %eax,0x1070
}
 9ee:	90                   	nop
 9ef:	c9                   	leave  
 9f0:	c3                   	ret    

000009f1 <morecore>:

static Header*
morecore(uint nu)
{
 9f1:	55                   	push   %ebp
 9f2:	89 e5                	mov    %esp,%ebp
 9f4:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 9f7:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9fe:	77 07                	ja     a07 <morecore+0x16>
    nu = 4096;
 a00:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a07:	8b 45 08             	mov    0x8(%ebp),%eax
 a0a:	c1 e0 03             	shl    $0x3,%eax
 a0d:	83 ec 0c             	sub    $0xc,%esp
 a10:	50                   	push   %eax
 a11:	e8 19 fc ff ff       	call   62f <sbrk>
 a16:	83 c4 10             	add    $0x10,%esp
 a19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a1c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a20:	75 07                	jne    a29 <morecore+0x38>
    return 0;
 a22:	b8 00 00 00 00       	mov    $0x0,%eax
 a27:	eb 26                	jmp    a4f <morecore+0x5e>
  hp = (Header*)p;
 a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a32:	8b 55 08             	mov    0x8(%ebp),%edx
 a35:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a38:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a3b:	83 c0 08             	add    $0x8,%eax
 a3e:	83 ec 0c             	sub    $0xc,%esp
 a41:	50                   	push   %eax
 a42:	e8 c8 fe ff ff       	call   90f <free>
 a47:	83 c4 10             	add    $0x10,%esp
  return freep;
 a4a:	a1 70 10 00 00       	mov    0x1070,%eax
}
 a4f:	c9                   	leave  
 a50:	c3                   	ret    

00000a51 <malloc>:

void*
malloc(uint nbytes)
{
 a51:	55                   	push   %ebp
 a52:	89 e5                	mov    %esp,%ebp
 a54:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a57:	8b 45 08             	mov    0x8(%ebp),%eax
 a5a:	83 c0 07             	add    $0x7,%eax
 a5d:	c1 e8 03             	shr    $0x3,%eax
 a60:	83 c0 01             	add    $0x1,%eax
 a63:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a66:	a1 70 10 00 00       	mov    0x1070,%eax
 a6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a6e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a72:	75 23                	jne    a97 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a74:	c7 45 f0 68 10 00 00 	movl   $0x1068,-0x10(%ebp)
 a7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a7e:	a3 70 10 00 00       	mov    %eax,0x1070
 a83:	a1 70 10 00 00       	mov    0x1070,%eax
 a88:	a3 68 10 00 00       	mov    %eax,0x1068
    base.s.size = 0;
 a8d:	c7 05 6c 10 00 00 00 	movl   $0x0,0x106c
 a94:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a97:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a9a:	8b 00                	mov    (%eax),%eax
 a9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa2:	8b 40 04             	mov    0x4(%eax),%eax
 aa5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 aa8:	72 4d                	jb     af7 <malloc+0xa6>
      if(p->s.size == nunits)
 aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aad:	8b 40 04             	mov    0x4(%eax),%eax
 ab0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 ab3:	75 0c                	jne    ac1 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab8:	8b 10                	mov    (%eax),%edx
 aba:	8b 45 f0             	mov    -0x10(%ebp),%eax
 abd:	89 10                	mov    %edx,(%eax)
 abf:	eb 26                	jmp    ae7 <malloc+0x96>
      else {
        p->s.size -= nunits;
 ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac4:	8b 40 04             	mov    0x4(%eax),%eax
 ac7:	2b 45 ec             	sub    -0x14(%ebp),%eax
 aca:	89 c2                	mov    %eax,%edx
 acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 acf:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad5:	8b 40 04             	mov    0x4(%eax),%eax
 ad8:	c1 e0 03             	shl    $0x3,%eax
 adb:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae1:	8b 55 ec             	mov    -0x14(%ebp),%edx
 ae4:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 ae7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aea:	a3 70 10 00 00       	mov    %eax,0x1070
      return (void*)(p + 1);
 aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 af2:	83 c0 08             	add    $0x8,%eax
 af5:	eb 3b                	jmp    b32 <malloc+0xe1>
    }
    if(p == freep)
 af7:	a1 70 10 00 00       	mov    0x1070,%eax
 afc:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 aff:	75 1e                	jne    b1f <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 b01:	83 ec 0c             	sub    $0xc,%esp
 b04:	ff 75 ec             	pushl  -0x14(%ebp)
 b07:	e8 e5 fe ff ff       	call   9f1 <morecore>
 b0c:	83 c4 10             	add    $0x10,%esp
 b0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b16:	75 07                	jne    b1f <malloc+0xce>
        return 0;
 b18:	b8 00 00 00 00       	mov    $0x0,%eax
 b1d:	eb 13                	jmp    b32 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b22:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b28:	8b 00                	mov    (%eax),%eax
 b2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 b2d:	e9 6d ff ff ff       	jmp    a9f <malloc+0x4e>
}
 b32:	c9                   	leave  
 b33:	c3                   	ret    
