
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <print_mode>:
#ifdef CS333_P5
// this is an ugly series of if statements but it works
void
print_mode(struct stat* st)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 08             	sub    $0x8,%esp
  switch (st->type) {
   6:	8b 45 08             	mov    0x8(%ebp),%eax
   9:	0f b7 00             	movzwl (%eax),%eax
   c:	98                   	cwtl   
   d:	83 f8 02             	cmp    $0x2,%eax
  10:	74 1e                	je     30 <print_mode+0x30>
  12:	83 f8 03             	cmp    $0x3,%eax
  15:	74 2d                	je     44 <print_mode+0x44>
  17:	83 f8 01             	cmp    $0x1,%eax
  1a:	75 3c                	jne    58 <print_mode+0x58>
    case T_DIR: printf(1, "d"); break;
  1c:	83 ec 08             	sub    $0x8,%esp
  1f:	68 cc 0e 00 00       	push   $0xecc
  24:	6a 01                	push   $0x1
  26:	e8 e8 0a 00 00       	call   b13 <printf>
  2b:	83 c4 10             	add    $0x10,%esp
  2e:	eb 3a                	jmp    6a <print_mode+0x6a>
    case T_FILE: printf(1, "-"); break;
  30:	83 ec 08             	sub    $0x8,%esp
  33:	68 ce 0e 00 00       	push   $0xece
  38:	6a 01                	push   $0x1
  3a:	e8 d4 0a 00 00       	call   b13 <printf>
  3f:	83 c4 10             	add    $0x10,%esp
  42:	eb 26                	jmp    6a <print_mode+0x6a>
    case T_DEV: printf(1, "c"); break;
  44:	83 ec 08             	sub    $0x8,%esp
  47:	68 d0 0e 00 00       	push   $0xed0
  4c:	6a 01                	push   $0x1
  4e:	e8 c0 0a 00 00       	call   b13 <printf>
  53:	83 c4 10             	add    $0x10,%esp
  56:	eb 12                	jmp    6a <print_mode+0x6a>
    default: printf(1, "?");
  58:	83 ec 08             	sub    $0x8,%esp
  5b:	68 d2 0e 00 00       	push   $0xed2
  60:	6a 01                	push   $0x1
  62:	e8 ac 0a 00 00       	call   b13 <printf>
  67:	83 c4 10             	add    $0x10,%esp
  }

  if (st->mode.flags.u_r)
  6a:	8b 45 08             	mov    0x8(%ebp),%eax
  6d:	0f b6 40 1d          	movzbl 0x1d(%eax),%eax
  71:	83 e0 01             	and    $0x1,%eax
  74:	84 c0                	test   %al,%al
  76:	74 14                	je     8c <print_mode+0x8c>
    printf(1, "r");
  78:	83 ec 08             	sub    $0x8,%esp
  7b:	68 d4 0e 00 00       	push   $0xed4
  80:	6a 01                	push   $0x1
  82:	e8 8c 0a 00 00       	call   b13 <printf>
  87:	83 c4 10             	add    $0x10,%esp
  8a:	eb 12                	jmp    9e <print_mode+0x9e>
  else
    printf(1, "-");
  8c:	83 ec 08             	sub    $0x8,%esp
  8f:	68 ce 0e 00 00       	push   $0xece
  94:	6a 01                	push   $0x1
  96:	e8 78 0a 00 00       	call   b13 <printf>
  9b:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.u_w)
  9e:	8b 45 08             	mov    0x8(%ebp),%eax
  a1:	0f b6 40 1c          	movzbl 0x1c(%eax),%eax
  a5:	83 e0 80             	and    $0xffffff80,%eax
  a8:	84 c0                	test   %al,%al
  aa:	74 14                	je     c0 <print_mode+0xc0>
    printf(1, "w");
  ac:	83 ec 08             	sub    $0x8,%esp
  af:	68 d6 0e 00 00       	push   $0xed6
  b4:	6a 01                	push   $0x1
  b6:	e8 58 0a 00 00       	call   b13 <printf>
  bb:	83 c4 10             	add    $0x10,%esp
  be:	eb 12                	jmp    d2 <print_mode+0xd2>
  else
    printf(1, "-");
  c0:	83 ec 08             	sub    $0x8,%esp
  c3:	68 ce 0e 00 00       	push   $0xece
  c8:	6a 01                	push   $0x1
  ca:	e8 44 0a 00 00       	call   b13 <printf>
  cf:	83 c4 10             	add    $0x10,%esp

  if ((st->mode.flags.u_x) & (st->mode.flags.setuid))
  d2:	8b 45 08             	mov    0x8(%ebp),%eax
  d5:	0f b6 40 1c          	movzbl 0x1c(%eax),%eax
  d9:	c0 e8 06             	shr    $0x6,%al
  dc:	83 e0 01             	and    $0x1,%eax
  df:	0f b6 d0             	movzbl %al,%edx
  e2:	8b 45 08             	mov    0x8(%ebp),%eax
  e5:	0f b6 40 1d          	movzbl 0x1d(%eax),%eax
  e9:	d0 e8                	shr    %al
  eb:	83 e0 01             	and    $0x1,%eax
  ee:	0f b6 c0             	movzbl %al,%eax
  f1:	21 d0                	and    %edx,%eax
  f3:	85 c0                	test   %eax,%eax
  f5:	74 14                	je     10b <print_mode+0x10b>
    printf(1, "S");
  f7:	83 ec 08             	sub    $0x8,%esp
  fa:	68 d8 0e 00 00       	push   $0xed8
  ff:	6a 01                	push   $0x1
 101:	e8 0d 0a 00 00       	call   b13 <printf>
 106:	83 c4 10             	add    $0x10,%esp
 109:	eb 34                	jmp    13f <print_mode+0x13f>
  else if (st->mode.flags.u_x)
 10b:	8b 45 08             	mov    0x8(%ebp),%eax
 10e:	0f b6 40 1c          	movzbl 0x1c(%eax),%eax
 112:	83 e0 40             	and    $0x40,%eax
 115:	84 c0                	test   %al,%al
 117:	74 14                	je     12d <print_mode+0x12d>
    printf(1, "x");
 119:	83 ec 08             	sub    $0x8,%esp
 11c:	68 da 0e 00 00       	push   $0xeda
 121:	6a 01                	push   $0x1
 123:	e8 eb 09 00 00       	call   b13 <printf>
 128:	83 c4 10             	add    $0x10,%esp
 12b:	eb 12                	jmp    13f <print_mode+0x13f>
  else
    printf(1, "-");
 12d:	83 ec 08             	sub    $0x8,%esp
 130:	68 ce 0e 00 00       	push   $0xece
 135:	6a 01                	push   $0x1
 137:	e8 d7 09 00 00       	call   b13 <printf>
 13c:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_r)
 13f:	8b 45 08             	mov    0x8(%ebp),%eax
 142:	0f b6 40 1c          	movzbl 0x1c(%eax),%eax
 146:	83 e0 20             	and    $0x20,%eax
 149:	84 c0                	test   %al,%al
 14b:	74 14                	je     161 <print_mode+0x161>
    printf(1, "r");
 14d:	83 ec 08             	sub    $0x8,%esp
 150:	68 d4 0e 00 00       	push   $0xed4
 155:	6a 01                	push   $0x1
 157:	e8 b7 09 00 00       	call   b13 <printf>
 15c:	83 c4 10             	add    $0x10,%esp
 15f:	eb 12                	jmp    173 <print_mode+0x173>
  else
    printf(1, "-");
 161:	83 ec 08             	sub    $0x8,%esp
 164:	68 ce 0e 00 00       	push   $0xece
 169:	6a 01                	push   $0x1
 16b:	e8 a3 09 00 00       	call   b13 <printf>
 170:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_w)
 173:	8b 45 08             	mov    0x8(%ebp),%eax
 176:	0f b6 40 1c          	movzbl 0x1c(%eax),%eax
 17a:	83 e0 10             	and    $0x10,%eax
 17d:	84 c0                	test   %al,%al
 17f:	74 14                	je     195 <print_mode+0x195>
    printf(1, "w");
 181:	83 ec 08             	sub    $0x8,%esp
 184:	68 d6 0e 00 00       	push   $0xed6
 189:	6a 01                	push   $0x1
 18b:	e8 83 09 00 00       	call   b13 <printf>
 190:	83 c4 10             	add    $0x10,%esp
 193:	eb 12                	jmp    1a7 <print_mode+0x1a7>
  else
    printf(1, "-");
 195:	83 ec 08             	sub    $0x8,%esp
 198:	68 ce 0e 00 00       	push   $0xece
 19d:	6a 01                	push   $0x1
 19f:	e8 6f 09 00 00       	call   b13 <printf>
 1a4:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_x)
 1a7:	8b 45 08             	mov    0x8(%ebp),%eax
 1aa:	0f b6 40 1c          	movzbl 0x1c(%eax),%eax
 1ae:	83 e0 08             	and    $0x8,%eax
 1b1:	84 c0                	test   %al,%al
 1b3:	74 14                	je     1c9 <print_mode+0x1c9>
    printf(1, "x");
 1b5:	83 ec 08             	sub    $0x8,%esp
 1b8:	68 da 0e 00 00       	push   $0xeda
 1bd:	6a 01                	push   $0x1
 1bf:	e8 4f 09 00 00       	call   b13 <printf>
 1c4:	83 c4 10             	add    $0x10,%esp
 1c7:	eb 12                	jmp    1db <print_mode+0x1db>
  else
    printf(1, "-");
 1c9:	83 ec 08             	sub    $0x8,%esp
 1cc:	68 ce 0e 00 00       	push   $0xece
 1d1:	6a 01                	push   $0x1
 1d3:	e8 3b 09 00 00       	call   b13 <printf>
 1d8:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_r)
 1db:	8b 45 08             	mov    0x8(%ebp),%eax
 1de:	0f b6 40 1c          	movzbl 0x1c(%eax),%eax
 1e2:	83 e0 04             	and    $0x4,%eax
 1e5:	84 c0                	test   %al,%al
 1e7:	74 14                	je     1fd <print_mode+0x1fd>
    printf(1, "r");
 1e9:	83 ec 08             	sub    $0x8,%esp
 1ec:	68 d4 0e 00 00       	push   $0xed4
 1f1:	6a 01                	push   $0x1
 1f3:	e8 1b 09 00 00       	call   b13 <printf>
 1f8:	83 c4 10             	add    $0x10,%esp
 1fb:	eb 12                	jmp    20f <print_mode+0x20f>
  else
    printf(1, "-");
 1fd:	83 ec 08             	sub    $0x8,%esp
 200:	68 ce 0e 00 00       	push   $0xece
 205:	6a 01                	push   $0x1
 207:	e8 07 09 00 00       	call   b13 <printf>
 20c:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_w)
 20f:	8b 45 08             	mov    0x8(%ebp),%eax
 212:	0f b6 40 1c          	movzbl 0x1c(%eax),%eax
 216:	83 e0 02             	and    $0x2,%eax
 219:	84 c0                	test   %al,%al
 21b:	74 14                	je     231 <print_mode+0x231>
    printf(1, "w");
 21d:	83 ec 08             	sub    $0x8,%esp
 220:	68 d6 0e 00 00       	push   $0xed6
 225:	6a 01                	push   $0x1
 227:	e8 e7 08 00 00       	call   b13 <printf>
 22c:	83 c4 10             	add    $0x10,%esp
 22f:	eb 12                	jmp    243 <print_mode+0x243>
  else
    printf(1, "-");
 231:	83 ec 08             	sub    $0x8,%esp
 234:	68 ce 0e 00 00       	push   $0xece
 239:	6a 01                	push   $0x1
 23b:	e8 d3 08 00 00       	call   b13 <printf>
 240:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_x)
 243:	8b 45 08             	mov    0x8(%ebp),%eax
 246:	0f b6 40 1c          	movzbl 0x1c(%eax),%eax
 24a:	83 e0 01             	and    $0x1,%eax
 24d:	84 c0                	test   %al,%al
 24f:	74 14                	je     265 <print_mode+0x265>
    printf(1, "x");
 251:	83 ec 08             	sub    $0x8,%esp
 254:	68 da 0e 00 00       	push   $0xeda
 259:	6a 01                	push   $0x1
 25b:	e8 b3 08 00 00       	call   b13 <printf>
 260:	83 c4 10             	add    $0x10,%esp
  else
    printf(1, "-");

  return;
 263:	eb 13                	jmp    278 <print_mode+0x278>
    printf(1, "-");

  if (st->mode.flags.o_x)
    printf(1, "x");
  else
    printf(1, "-");
 265:	83 ec 08             	sub    $0x8,%esp
 268:	68 ce 0e 00 00       	push   $0xece
 26d:	6a 01                	push   $0x1
 26f:	e8 9f 08 00 00       	call   b13 <printf>
 274:	83 c4 10             	add    $0x10,%esp

  return;
 277:	90                   	nop
}
 278:	c9                   	leave  
 279:	c3                   	ret    

0000027a <fmtname>:
#include "fs.h"
#include "print_mode.c"

char*
fmtname(char *path)
{
 27a:	55                   	push   %ebp
 27b:	89 e5                	mov    %esp,%ebp
 27d:	53                   	push   %ebx
 27e:	83 ec 14             	sub    $0x14,%esp
  static char buf[DIRSIZ+1];
  char *p;
  
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
 281:	83 ec 0c             	sub    $0xc,%esp
 284:	ff 75 08             	pushl  0x8(%ebp)
 287:	e8 1b 04 00 00       	call   6a7 <strlen>
 28c:	83 c4 10             	add    $0x10,%esp
 28f:	89 c2                	mov    %eax,%edx
 291:	8b 45 08             	mov    0x8(%ebp),%eax
 294:	01 d0                	add    %edx,%eax
 296:	89 45 f4             	mov    %eax,-0xc(%ebp)
 299:	eb 04                	jmp    29f <fmtname+0x25>
 29b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 29f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2a2:	3b 45 08             	cmp    0x8(%ebp),%eax
 2a5:	72 0a                	jb     2b1 <fmtname+0x37>
 2a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2aa:	0f b6 00             	movzbl (%eax),%eax
 2ad:	3c 2f                	cmp    $0x2f,%al
 2af:	75 ea                	jne    29b <fmtname+0x21>
    ;
  p++;
 2b1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
 2b5:	83 ec 0c             	sub    $0xc,%esp
 2b8:	ff 75 f4             	pushl  -0xc(%ebp)
 2bb:	e8 e7 03 00 00       	call   6a7 <strlen>
 2c0:	83 c4 10             	add    $0x10,%esp
 2c3:	83 f8 0d             	cmp    $0xd,%eax
 2c6:	76 05                	jbe    2cd <fmtname+0x53>
    return p;
 2c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2cb:	eb 60                	jmp    32d <fmtname+0xb3>
  memmove(buf, p, strlen(p));
 2cd:	83 ec 0c             	sub    $0xc,%esp
 2d0:	ff 75 f4             	pushl  -0xc(%ebp)
 2d3:	e8 cf 03 00 00       	call   6a7 <strlen>
 2d8:	83 c4 10             	add    $0x10,%esp
 2db:	83 ec 04             	sub    $0x4,%esp
 2de:	50                   	push   %eax
 2df:	ff 75 f4             	pushl  -0xc(%ebp)
 2e2:	68 44 12 00 00       	push   $0x1244
 2e7:	e8 7d 05 00 00       	call   869 <memmove>
 2ec:	83 c4 10             	add    $0x10,%esp
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
 2ef:	83 ec 0c             	sub    $0xc,%esp
 2f2:	ff 75 f4             	pushl  -0xc(%ebp)
 2f5:	e8 ad 03 00 00       	call   6a7 <strlen>
 2fa:	83 c4 10             	add    $0x10,%esp
 2fd:	ba 0e 00 00 00       	mov    $0xe,%edx
 302:	89 d3                	mov    %edx,%ebx
 304:	29 c3                	sub    %eax,%ebx
 306:	83 ec 0c             	sub    $0xc,%esp
 309:	ff 75 f4             	pushl  -0xc(%ebp)
 30c:	e8 96 03 00 00       	call   6a7 <strlen>
 311:	83 c4 10             	add    $0x10,%esp
 314:	05 44 12 00 00       	add    $0x1244,%eax
 319:	83 ec 04             	sub    $0x4,%esp
 31c:	53                   	push   %ebx
 31d:	6a 20                	push   $0x20
 31f:	50                   	push   %eax
 320:	e8 a9 03 00 00       	call   6ce <memset>
 325:	83 c4 10             	add    $0x10,%esp
  return buf;
 328:	b8 44 12 00 00       	mov    $0x1244,%eax
}
 32d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 330:	c9                   	leave  
 331:	c3                   	ret    

00000332 <ls>:

void
ls(char *path)
{
 332:	55                   	push   %ebp
 333:	89 e5                	mov    %esp,%ebp
 335:	57                   	push   %edi
 336:	56                   	push   %esi
 337:	53                   	push   %ebx
 338:	81 ec 5c 02 00 00    	sub    $0x25c,%esp
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, 0)) < 0){
 33e:	83 ec 08             	sub    $0x8,%esp
 341:	6a 00                	push   $0x0
 343:	ff 75 08             	pushl  0x8(%ebp)
 346:	e8 31 06 00 00       	call   97c <open>
 34b:	83 c4 10             	add    $0x10,%esp
 34e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 351:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 355:	79 1a                	jns    371 <ls+0x3f>
    printf(2, "ls: cannot open %s\n", path);
 357:	83 ec 04             	sub    $0x4,%esp
 35a:	ff 75 08             	pushl  0x8(%ebp)
 35d:	68 dc 0e 00 00       	push   $0xedc
 362:	6a 02                	push   $0x2
 364:	e8 aa 07 00 00       	call   b13 <printf>
 369:	83 c4 10             	add    $0x10,%esp
    return;
 36c:	e9 23 02 00 00       	jmp    594 <ls+0x262>
  }
  
  if(fstat(fd, &st) < 0){
 371:	83 ec 08             	sub    $0x8,%esp
 374:	8d 85 b0 fd ff ff    	lea    -0x250(%ebp),%eax
 37a:	50                   	push   %eax
 37b:	ff 75 e4             	pushl  -0x1c(%ebp)
 37e:	e8 11 06 00 00       	call   994 <fstat>
 383:	83 c4 10             	add    $0x10,%esp
 386:	85 c0                	test   %eax,%eax
 388:	79 28                	jns    3b2 <ls+0x80>
    printf(2, "ls: cannot stat %s\n", path);
 38a:	83 ec 04             	sub    $0x4,%esp
 38d:	ff 75 08             	pushl  0x8(%ebp)
 390:	68 f0 0e 00 00       	push   $0xef0
 395:	6a 02                	push   $0x2
 397:	e8 77 07 00 00       	call   b13 <printf>
 39c:	83 c4 10             	add    $0x10,%esp
    close(fd);
 39f:	83 ec 0c             	sub    $0xc,%esp
 3a2:	ff 75 e4             	pushl  -0x1c(%ebp)
 3a5:	e8 ba 05 00 00       	call   964 <close>
 3aa:	83 c4 10             	add    $0x10,%esp
    return;
 3ad:	e9 e2 01 00 00       	jmp    594 <ls+0x262>
  }
  
  switch(st.type){
 3b2:	0f b7 85 b0 fd ff ff 	movzwl -0x250(%ebp),%eax
 3b9:	98                   	cwtl   
 3ba:	83 f8 01             	cmp    $0x1,%eax
 3bd:	74 68                	je     427 <ls+0xf5>
 3bf:	83 f8 02             	cmp    $0x2,%eax
 3c2:	0f 85 be 01 00 00    	jne    586 <ls+0x254>
  case T_FILE:
    #ifdef CS333_P5
    print_mode(&st);
 3c8:	83 ec 0c             	sub    $0xc,%esp
 3cb:	8d 85 b0 fd ff ff    	lea    -0x250(%ebp),%eax
 3d1:	50                   	push   %eax
 3d2:	e8 29 fc ff ff       	call   0 <print_mode>
 3d7:	83 c4 10             	add    $0x10,%esp
    printf(1, " %s %d\t%d\t%d\t%d\n",
 3da:	8b 85 c0 fd ff ff    	mov    -0x240(%ebp),%eax
 3e0:	89 85 a4 fd ff ff    	mov    %eax,-0x25c(%ebp)
 3e6:	8b bd b8 fd ff ff    	mov    -0x248(%ebp),%edi
 3ec:	8b b5 c8 fd ff ff    	mov    -0x238(%ebp),%esi
 3f2:	8b 9d c4 fd ff ff    	mov    -0x23c(%ebp),%ebx
 3f8:	83 ec 0c             	sub    $0xc,%esp
 3fb:	ff 75 08             	pushl  0x8(%ebp)
 3fe:	e8 77 fe ff ff       	call   27a <fmtname>
 403:	83 c4 10             	add    $0x10,%esp
 406:	83 ec 04             	sub    $0x4,%esp
 409:	ff b5 a4 fd ff ff    	pushl  -0x25c(%ebp)
 40f:	57                   	push   %edi
 410:	56                   	push   %esi
 411:	53                   	push   %ebx
 412:	50                   	push   %eax
 413:	68 04 0f 00 00       	push   $0xf04
 418:	6a 01                	push   $0x1
 41a:	e8 f4 06 00 00       	call   b13 <printf>
 41f:	83 c4 20             	add    $0x20,%esp
        fmtname(path), st.uid, st.gid, st.ino, st.size);
    #else
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
    #endif
    break;
 422:	e9 5f 01 00 00       	jmp    586 <ls+0x254>
  
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 427:	83 ec 0c             	sub    $0xc,%esp
 42a:	ff 75 08             	pushl  0x8(%ebp)
 42d:	e8 75 02 00 00       	call   6a7 <strlen>
 432:	83 c4 10             	add    $0x10,%esp
 435:	83 c0 10             	add    $0x10,%eax
 438:	3d 00 02 00 00       	cmp    $0x200,%eax
 43d:	76 17                	jbe    456 <ls+0x124>
      printf(1, "ls: path too long\n");
 43f:	83 ec 08             	sub    $0x8,%esp
 442:	68 15 0f 00 00       	push   $0xf15
 447:	6a 01                	push   $0x1
 449:	e8 c5 06 00 00       	call   b13 <printf>
 44e:	83 c4 10             	add    $0x10,%esp
      break;
 451:	e9 30 01 00 00       	jmp    586 <ls+0x254>
    }
    strcpy(buf, path);
 456:	83 ec 08             	sub    $0x8,%esp
 459:	ff 75 08             	pushl  0x8(%ebp)
 45c:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 462:	50                   	push   %eax
 463:	e8 d0 01 00 00       	call   638 <strcpy>
 468:	83 c4 10             	add    $0x10,%esp
    p = buf+strlen(buf);
 46b:	83 ec 0c             	sub    $0xc,%esp
 46e:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 474:	50                   	push   %eax
 475:	e8 2d 02 00 00       	call   6a7 <strlen>
 47a:	83 c4 10             	add    $0x10,%esp
 47d:	89 c2                	mov    %eax,%edx
 47f:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 485:	01 d0                	add    %edx,%eax
 487:	89 45 e0             	mov    %eax,-0x20(%ebp)
    *p++ = '/';
 48a:	8b 45 e0             	mov    -0x20(%ebp),%eax
 48d:	8d 50 01             	lea    0x1(%eax),%edx
 490:	89 55 e0             	mov    %edx,-0x20(%ebp)
 493:	c6 00 2f             	movb   $0x2f,(%eax)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 496:	e9 ca 00 00 00       	jmp    565 <ls+0x233>
      if(de.inum == 0)
 49b:	0f b7 85 d0 fd ff ff 	movzwl -0x230(%ebp),%eax
 4a2:	66 85 c0             	test   %ax,%ax
 4a5:	75 05                	jne    4ac <ls+0x17a>
        continue;
 4a7:	e9 b9 00 00 00       	jmp    565 <ls+0x233>
      memmove(p, de.name, DIRSIZ);
 4ac:	83 ec 04             	sub    $0x4,%esp
 4af:	6a 0e                	push   $0xe
 4b1:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 4b7:	83 c0 02             	add    $0x2,%eax
 4ba:	50                   	push   %eax
 4bb:	ff 75 e0             	pushl  -0x20(%ebp)
 4be:	e8 a6 03 00 00       	call   869 <memmove>
 4c3:	83 c4 10             	add    $0x10,%esp
      p[DIRSIZ] = 0;
 4c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
 4c9:	83 c0 0e             	add    $0xe,%eax
 4cc:	c6 00 00             	movb   $0x0,(%eax)
      if(stat(buf, &st) < 0){
 4cf:	83 ec 08             	sub    $0x8,%esp
 4d2:	8d 85 b0 fd ff ff    	lea    -0x250(%ebp),%eax
 4d8:	50                   	push   %eax
 4d9:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 4df:	50                   	push   %eax
 4e0:	e8 a5 02 00 00       	call   78a <stat>
 4e5:	83 c4 10             	add    $0x10,%esp
 4e8:	85 c0                	test   %eax,%eax
 4ea:	79 1b                	jns    507 <ls+0x1d5>
        printf(1, "ls: cannot stat %s\n", buf);
 4ec:	83 ec 04             	sub    $0x4,%esp
 4ef:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 4f5:	50                   	push   %eax
 4f6:	68 f0 0e 00 00       	push   $0xef0
 4fb:	6a 01                	push   $0x1
 4fd:	e8 11 06 00 00       	call   b13 <printf>
 502:	83 c4 10             	add    $0x10,%esp
        continue;
 505:	eb 5e                	jmp    565 <ls+0x233>
      }
      #ifdef CS333_P5
      print_mode(&st);
 507:	83 ec 0c             	sub    $0xc,%esp
 50a:	8d 85 b0 fd ff ff    	lea    -0x250(%ebp),%eax
 510:	50                   	push   %eax
 511:	e8 ea fa ff ff       	call   0 <print_mode>
 516:	83 c4 10             	add    $0x10,%esp
      printf(1, " %s %d\t%d\t%d\t%d\n",
 519:	8b 85 c0 fd ff ff    	mov    -0x240(%ebp),%eax
 51f:	89 85 a4 fd ff ff    	mov    %eax,-0x25c(%ebp)
 525:	8b bd b8 fd ff ff    	mov    -0x248(%ebp),%edi
 52b:	8b b5 c8 fd ff ff    	mov    -0x238(%ebp),%esi
 531:	8b 9d c4 fd ff ff    	mov    -0x23c(%ebp),%ebx
 537:	83 ec 0c             	sub    $0xc,%esp
 53a:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 540:	50                   	push   %eax
 541:	e8 34 fd ff ff       	call   27a <fmtname>
 546:	83 c4 10             	add    $0x10,%esp
 549:	83 ec 04             	sub    $0x4,%esp
 54c:	ff b5 a4 fd ff ff    	pushl  -0x25c(%ebp)
 552:	57                   	push   %edi
 553:	56                   	push   %esi
 554:	53                   	push   %ebx
 555:	50                   	push   %eax
 556:	68 04 0f 00 00       	push   $0xf04
 55b:	6a 01                	push   $0x1
 55d:	e8 b1 05 00 00       	call   b13 <printf>
 562:	83 c4 20             	add    $0x20,%esp
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 565:	83 ec 04             	sub    $0x4,%esp
 568:	6a 10                	push   $0x10
 56a:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 570:	50                   	push   %eax
 571:	ff 75 e4             	pushl  -0x1c(%ebp)
 574:	e8 db 03 00 00       	call   954 <read>
 579:	83 c4 10             	add    $0x10,%esp
 57c:	83 f8 10             	cmp    $0x10,%eax
 57f:	0f 84 16 ff ff ff    	je     49b <ls+0x169>
          fmtname(buf), st.uid, st.gid, st.ino, st.size);
      #else
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
      #endif
    }
    break;
 585:	90                   	nop
  }
  close(fd);
 586:	83 ec 0c             	sub    $0xc,%esp
 589:	ff 75 e4             	pushl  -0x1c(%ebp)
 58c:	e8 d3 03 00 00       	call   964 <close>
 591:	83 c4 10             	add    $0x10,%esp
}
 594:	8d 65 f4             	lea    -0xc(%ebp),%esp
 597:	5b                   	pop    %ebx
 598:	5e                   	pop    %esi
 599:	5f                   	pop    %edi
 59a:	5d                   	pop    %ebp
 59b:	c3                   	ret    

0000059c <main>:

int
main(int argc, char *argv[])
{
 59c:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 5a0:	83 e4 f0             	and    $0xfffffff0,%esp
 5a3:	ff 71 fc             	pushl  -0x4(%ecx)
 5a6:	55                   	push   %ebp
 5a7:	89 e5                	mov    %esp,%ebp
 5a9:	53                   	push   %ebx
 5aa:	51                   	push   %ecx
 5ab:	83 ec 10             	sub    $0x10,%esp
 5ae:	89 cb                	mov    %ecx,%ebx
  int i;

  #ifdef CS333_P5
  printf(1, "mode\t\tname\tuid\tgid\tinode\tsize\n");
 5b0:	83 ec 08             	sub    $0x8,%esp
 5b3:	68 28 0f 00 00       	push   $0xf28
 5b8:	6a 01                	push   $0x1
 5ba:	e8 54 05 00 00       	call   b13 <printf>
 5bf:	83 c4 10             	add    $0x10,%esp
  #endif

  if(argc < 2){
 5c2:	83 3b 01             	cmpl   $0x1,(%ebx)
 5c5:	7f 15                	jg     5dc <main+0x40>
    ls(".");
 5c7:	83 ec 0c             	sub    $0xc,%esp
 5ca:	68 47 0f 00 00       	push   $0xf47
 5cf:	e8 5e fd ff ff       	call   332 <ls>
 5d4:	83 c4 10             	add    $0x10,%esp
    exit();
 5d7:	e8 60 03 00 00       	call   93c <exit>
  }
  for(i=1; i<argc; i++)
 5dc:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 5e3:	eb 21                	jmp    606 <main+0x6a>
    ls(argv[i]);
 5e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5e8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 5ef:	8b 43 04             	mov    0x4(%ebx),%eax
 5f2:	01 d0                	add    %edx,%eax
 5f4:	8b 00                	mov    (%eax),%eax
 5f6:	83 ec 0c             	sub    $0xc,%esp
 5f9:	50                   	push   %eax
 5fa:	e8 33 fd ff ff       	call   332 <ls>
 5ff:	83 c4 10             	add    $0x10,%esp

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
 602:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 606:	8b 45 f4             	mov    -0xc(%ebp),%eax
 609:	3b 03                	cmp    (%ebx),%eax
 60b:	7c d8                	jl     5e5 <main+0x49>
    ls(argv[i]);
  exit();
 60d:	e8 2a 03 00 00       	call   93c <exit>

00000612 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 612:	55                   	push   %ebp
 613:	89 e5                	mov    %esp,%ebp
 615:	57                   	push   %edi
 616:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 617:	8b 4d 08             	mov    0x8(%ebp),%ecx
 61a:	8b 55 10             	mov    0x10(%ebp),%edx
 61d:	8b 45 0c             	mov    0xc(%ebp),%eax
 620:	89 cb                	mov    %ecx,%ebx
 622:	89 df                	mov    %ebx,%edi
 624:	89 d1                	mov    %edx,%ecx
 626:	fc                   	cld    
 627:	f3 aa                	rep stos %al,%es:(%edi)
 629:	89 ca                	mov    %ecx,%edx
 62b:	89 fb                	mov    %edi,%ebx
 62d:	89 5d 08             	mov    %ebx,0x8(%ebp)
 630:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 633:	90                   	nop
 634:	5b                   	pop    %ebx
 635:	5f                   	pop    %edi
 636:	5d                   	pop    %ebp
 637:	c3                   	ret    

00000638 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 638:	55                   	push   %ebp
 639:	89 e5                	mov    %esp,%ebp
 63b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 63e:	8b 45 08             	mov    0x8(%ebp),%eax
 641:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 644:	90                   	nop
 645:	8b 45 08             	mov    0x8(%ebp),%eax
 648:	8d 50 01             	lea    0x1(%eax),%edx
 64b:	89 55 08             	mov    %edx,0x8(%ebp)
 64e:	8b 55 0c             	mov    0xc(%ebp),%edx
 651:	8d 4a 01             	lea    0x1(%edx),%ecx
 654:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 657:	0f b6 12             	movzbl (%edx),%edx
 65a:	88 10                	mov    %dl,(%eax)
 65c:	0f b6 00             	movzbl (%eax),%eax
 65f:	84 c0                	test   %al,%al
 661:	75 e2                	jne    645 <strcpy+0xd>
    ;
  return os;
 663:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 666:	c9                   	leave  
 667:	c3                   	ret    

00000668 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 668:	55                   	push   %ebp
 669:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 66b:	eb 08                	jmp    675 <strcmp+0xd>
    p++, q++;
 66d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 671:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 675:	8b 45 08             	mov    0x8(%ebp),%eax
 678:	0f b6 00             	movzbl (%eax),%eax
 67b:	84 c0                	test   %al,%al
 67d:	74 10                	je     68f <strcmp+0x27>
 67f:	8b 45 08             	mov    0x8(%ebp),%eax
 682:	0f b6 10             	movzbl (%eax),%edx
 685:	8b 45 0c             	mov    0xc(%ebp),%eax
 688:	0f b6 00             	movzbl (%eax),%eax
 68b:	38 c2                	cmp    %al,%dl
 68d:	74 de                	je     66d <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 68f:	8b 45 08             	mov    0x8(%ebp),%eax
 692:	0f b6 00             	movzbl (%eax),%eax
 695:	0f b6 d0             	movzbl %al,%edx
 698:	8b 45 0c             	mov    0xc(%ebp),%eax
 69b:	0f b6 00             	movzbl (%eax),%eax
 69e:	0f b6 c0             	movzbl %al,%eax
 6a1:	29 c2                	sub    %eax,%edx
 6a3:	89 d0                	mov    %edx,%eax
}
 6a5:	5d                   	pop    %ebp
 6a6:	c3                   	ret    

000006a7 <strlen>:

uint
strlen(char *s)
{
 6a7:	55                   	push   %ebp
 6a8:	89 e5                	mov    %esp,%ebp
 6aa:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 6ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 6b4:	eb 04                	jmp    6ba <strlen+0x13>
 6b6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 6ba:	8b 55 fc             	mov    -0x4(%ebp),%edx
 6bd:	8b 45 08             	mov    0x8(%ebp),%eax
 6c0:	01 d0                	add    %edx,%eax
 6c2:	0f b6 00             	movzbl (%eax),%eax
 6c5:	84 c0                	test   %al,%al
 6c7:	75 ed                	jne    6b6 <strlen+0xf>
    ;
  return n;
 6c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 6cc:	c9                   	leave  
 6cd:	c3                   	ret    

000006ce <memset>:

void*
memset(void *dst, int c, uint n)
{
 6ce:	55                   	push   %ebp
 6cf:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 6d1:	8b 45 10             	mov    0x10(%ebp),%eax
 6d4:	50                   	push   %eax
 6d5:	ff 75 0c             	pushl  0xc(%ebp)
 6d8:	ff 75 08             	pushl  0x8(%ebp)
 6db:	e8 32 ff ff ff       	call   612 <stosb>
 6e0:	83 c4 0c             	add    $0xc,%esp
  return dst;
 6e3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 6e6:	c9                   	leave  
 6e7:	c3                   	ret    

000006e8 <strchr>:

char*
strchr(const char *s, char c)
{
 6e8:	55                   	push   %ebp
 6e9:	89 e5                	mov    %esp,%ebp
 6eb:	83 ec 04             	sub    $0x4,%esp
 6ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 6f1:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 6f4:	eb 14                	jmp    70a <strchr+0x22>
    if(*s == c)
 6f6:	8b 45 08             	mov    0x8(%ebp),%eax
 6f9:	0f b6 00             	movzbl (%eax),%eax
 6fc:	3a 45 fc             	cmp    -0x4(%ebp),%al
 6ff:	75 05                	jne    706 <strchr+0x1e>
      return (char*)s;
 701:	8b 45 08             	mov    0x8(%ebp),%eax
 704:	eb 13                	jmp    719 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 706:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 70a:	8b 45 08             	mov    0x8(%ebp),%eax
 70d:	0f b6 00             	movzbl (%eax),%eax
 710:	84 c0                	test   %al,%al
 712:	75 e2                	jne    6f6 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 714:	b8 00 00 00 00       	mov    $0x0,%eax
}
 719:	c9                   	leave  
 71a:	c3                   	ret    

0000071b <gets>:

char*
gets(char *buf, int max)
{
 71b:	55                   	push   %ebp
 71c:	89 e5                	mov    %esp,%ebp
 71e:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 721:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 728:	eb 42                	jmp    76c <gets+0x51>
    cc = read(0, &c, 1);
 72a:	83 ec 04             	sub    $0x4,%esp
 72d:	6a 01                	push   $0x1
 72f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 732:	50                   	push   %eax
 733:	6a 00                	push   $0x0
 735:	e8 1a 02 00 00       	call   954 <read>
 73a:	83 c4 10             	add    $0x10,%esp
 73d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 740:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 744:	7e 33                	jle    779 <gets+0x5e>
      break;
    buf[i++] = c;
 746:	8b 45 f4             	mov    -0xc(%ebp),%eax
 749:	8d 50 01             	lea    0x1(%eax),%edx
 74c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 74f:	89 c2                	mov    %eax,%edx
 751:	8b 45 08             	mov    0x8(%ebp),%eax
 754:	01 c2                	add    %eax,%edx
 756:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 75a:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 75c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 760:	3c 0a                	cmp    $0xa,%al
 762:	74 16                	je     77a <gets+0x5f>
 764:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 768:	3c 0d                	cmp    $0xd,%al
 76a:	74 0e                	je     77a <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 76c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76f:	83 c0 01             	add    $0x1,%eax
 772:	3b 45 0c             	cmp    0xc(%ebp),%eax
 775:	7c b3                	jl     72a <gets+0xf>
 777:	eb 01                	jmp    77a <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 779:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 77a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 77d:	8b 45 08             	mov    0x8(%ebp),%eax
 780:	01 d0                	add    %edx,%eax
 782:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 785:	8b 45 08             	mov    0x8(%ebp),%eax
}
 788:	c9                   	leave  
 789:	c3                   	ret    

0000078a <stat>:

int
stat(char *n, struct stat *st)
{
 78a:	55                   	push   %ebp
 78b:	89 e5                	mov    %esp,%ebp
 78d:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 790:	83 ec 08             	sub    $0x8,%esp
 793:	6a 00                	push   $0x0
 795:	ff 75 08             	pushl  0x8(%ebp)
 798:	e8 df 01 00 00       	call   97c <open>
 79d:	83 c4 10             	add    $0x10,%esp
 7a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 7a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7a7:	79 07                	jns    7b0 <stat+0x26>
    return -1;
 7a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 7ae:	eb 25                	jmp    7d5 <stat+0x4b>
  r = fstat(fd, st);
 7b0:	83 ec 08             	sub    $0x8,%esp
 7b3:	ff 75 0c             	pushl  0xc(%ebp)
 7b6:	ff 75 f4             	pushl  -0xc(%ebp)
 7b9:	e8 d6 01 00 00       	call   994 <fstat>
 7be:	83 c4 10             	add    $0x10,%esp
 7c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 7c4:	83 ec 0c             	sub    $0xc,%esp
 7c7:	ff 75 f4             	pushl  -0xc(%ebp)
 7ca:	e8 95 01 00 00       	call   964 <close>
 7cf:	83 c4 10             	add    $0x10,%esp
  return r;
 7d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 7d5:	c9                   	leave  
 7d6:	c3                   	ret    

000007d7 <atoi>:

int
atoi(const char *s)
{
 7d7:	55                   	push   %ebp
 7d8:	89 e5                	mov    %esp,%ebp
 7da:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 7dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 7e4:	eb 04                	jmp    7ea <atoi+0x13>
 7e6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 7ea:	8b 45 08             	mov    0x8(%ebp),%eax
 7ed:	0f b6 00             	movzbl (%eax),%eax
 7f0:	3c 20                	cmp    $0x20,%al
 7f2:	74 f2                	je     7e6 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 7f4:	8b 45 08             	mov    0x8(%ebp),%eax
 7f7:	0f b6 00             	movzbl (%eax),%eax
 7fa:	3c 2d                	cmp    $0x2d,%al
 7fc:	75 07                	jne    805 <atoi+0x2e>
 7fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 803:	eb 05                	jmp    80a <atoi+0x33>
 805:	b8 01 00 00 00       	mov    $0x1,%eax
 80a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 80d:	8b 45 08             	mov    0x8(%ebp),%eax
 810:	0f b6 00             	movzbl (%eax),%eax
 813:	3c 2b                	cmp    $0x2b,%al
 815:	74 0a                	je     821 <atoi+0x4a>
 817:	8b 45 08             	mov    0x8(%ebp),%eax
 81a:	0f b6 00             	movzbl (%eax),%eax
 81d:	3c 2d                	cmp    $0x2d,%al
 81f:	75 2b                	jne    84c <atoi+0x75>
    s++;
 821:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 825:	eb 25                	jmp    84c <atoi+0x75>
    n = n*10 + *s++ - '0';
 827:	8b 55 fc             	mov    -0x4(%ebp),%edx
 82a:	89 d0                	mov    %edx,%eax
 82c:	c1 e0 02             	shl    $0x2,%eax
 82f:	01 d0                	add    %edx,%eax
 831:	01 c0                	add    %eax,%eax
 833:	89 c1                	mov    %eax,%ecx
 835:	8b 45 08             	mov    0x8(%ebp),%eax
 838:	8d 50 01             	lea    0x1(%eax),%edx
 83b:	89 55 08             	mov    %edx,0x8(%ebp)
 83e:	0f b6 00             	movzbl (%eax),%eax
 841:	0f be c0             	movsbl %al,%eax
 844:	01 c8                	add    %ecx,%eax
 846:	83 e8 30             	sub    $0x30,%eax
 849:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 84c:	8b 45 08             	mov    0x8(%ebp),%eax
 84f:	0f b6 00             	movzbl (%eax),%eax
 852:	3c 2f                	cmp    $0x2f,%al
 854:	7e 0a                	jle    860 <atoi+0x89>
 856:	8b 45 08             	mov    0x8(%ebp),%eax
 859:	0f b6 00             	movzbl (%eax),%eax
 85c:	3c 39                	cmp    $0x39,%al
 85e:	7e c7                	jle    827 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 860:	8b 45 f8             	mov    -0x8(%ebp),%eax
 863:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 867:	c9                   	leave  
 868:	c3                   	ret    

00000869 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 869:	55                   	push   %ebp
 86a:	89 e5                	mov    %esp,%ebp
 86c:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 86f:	8b 45 08             	mov    0x8(%ebp),%eax
 872:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 875:	8b 45 0c             	mov    0xc(%ebp),%eax
 878:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 87b:	eb 17                	jmp    894 <memmove+0x2b>
    *dst++ = *src++;
 87d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 880:	8d 50 01             	lea    0x1(%eax),%edx
 883:	89 55 fc             	mov    %edx,-0x4(%ebp)
 886:	8b 55 f8             	mov    -0x8(%ebp),%edx
 889:	8d 4a 01             	lea    0x1(%edx),%ecx
 88c:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 88f:	0f b6 12             	movzbl (%edx),%edx
 892:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 894:	8b 45 10             	mov    0x10(%ebp),%eax
 897:	8d 50 ff             	lea    -0x1(%eax),%edx
 89a:	89 55 10             	mov    %edx,0x10(%ebp)
 89d:	85 c0                	test   %eax,%eax
 89f:	7f dc                	jg     87d <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 8a1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 8a4:	c9                   	leave  
 8a5:	c3                   	ret    

000008a6 <atoo>:

#ifdef CS333_P5
int
atoo(const char *s)
{
 8a6:	55                   	push   %ebp
 8a7:	89 e5                	mov    %esp,%ebp
 8a9:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 8ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 8b3:	eb 04                	jmp    8b9 <atoo+0x13>
 8b5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 8b9:	8b 45 08             	mov    0x8(%ebp),%eax
 8bc:	0f b6 00             	movzbl (%eax),%eax
 8bf:	3c 20                	cmp    $0x20,%al
 8c1:	74 f2                	je     8b5 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 8c3:	8b 45 08             	mov    0x8(%ebp),%eax
 8c6:	0f b6 00             	movzbl (%eax),%eax
 8c9:	3c 2d                	cmp    $0x2d,%al
 8cb:	75 07                	jne    8d4 <atoo+0x2e>
 8cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8d2:	eb 05                	jmp    8d9 <atoo+0x33>
 8d4:	b8 01 00 00 00       	mov    $0x1,%eax
 8d9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 8dc:	8b 45 08             	mov    0x8(%ebp),%eax
 8df:	0f b6 00             	movzbl (%eax),%eax
 8e2:	3c 2b                	cmp    $0x2b,%al
 8e4:	74 0a                	je     8f0 <atoo+0x4a>
 8e6:	8b 45 08             	mov    0x8(%ebp),%eax
 8e9:	0f b6 00             	movzbl (%eax),%eax
 8ec:	3c 2d                	cmp    $0x2d,%al
 8ee:	75 27                	jne    917 <atoo+0x71>
    s++;
 8f0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 8f4:	eb 21                	jmp    917 <atoo+0x71>
    n = n*8 + *s++ - '0';
 8f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f9:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 900:	8b 45 08             	mov    0x8(%ebp),%eax
 903:	8d 50 01             	lea    0x1(%eax),%edx
 906:	89 55 08             	mov    %edx,0x8(%ebp)
 909:	0f b6 00             	movzbl (%eax),%eax
 90c:	0f be c0             	movsbl %al,%eax
 90f:	01 c8                	add    %ecx,%eax
 911:	83 e8 30             	sub    $0x30,%eax
 914:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 917:	8b 45 08             	mov    0x8(%ebp),%eax
 91a:	0f b6 00             	movzbl (%eax),%eax
 91d:	3c 2f                	cmp    $0x2f,%al
 91f:	7e 0a                	jle    92b <atoo+0x85>
 921:	8b 45 08             	mov    0x8(%ebp),%eax
 924:	0f b6 00             	movzbl (%eax),%eax
 927:	3c 39                	cmp    $0x39,%al
 929:	7e cb                	jle    8f6 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 92b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 92e:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 932:	c9                   	leave  
 933:	c3                   	ret    

00000934 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 934:	b8 01 00 00 00       	mov    $0x1,%eax
 939:	cd 40                	int    $0x40
 93b:	c3                   	ret    

0000093c <exit>:
SYSCALL(exit)
 93c:	b8 02 00 00 00       	mov    $0x2,%eax
 941:	cd 40                	int    $0x40
 943:	c3                   	ret    

00000944 <wait>:
SYSCALL(wait)
 944:	b8 03 00 00 00       	mov    $0x3,%eax
 949:	cd 40                	int    $0x40
 94b:	c3                   	ret    

0000094c <pipe>:
SYSCALL(pipe)
 94c:	b8 04 00 00 00       	mov    $0x4,%eax
 951:	cd 40                	int    $0x40
 953:	c3                   	ret    

00000954 <read>:
SYSCALL(read)
 954:	b8 05 00 00 00       	mov    $0x5,%eax
 959:	cd 40                	int    $0x40
 95b:	c3                   	ret    

0000095c <write>:
SYSCALL(write)
 95c:	b8 10 00 00 00       	mov    $0x10,%eax
 961:	cd 40                	int    $0x40
 963:	c3                   	ret    

00000964 <close>:
SYSCALL(close)
 964:	b8 15 00 00 00       	mov    $0x15,%eax
 969:	cd 40                	int    $0x40
 96b:	c3                   	ret    

0000096c <kill>:
SYSCALL(kill)
 96c:	b8 06 00 00 00       	mov    $0x6,%eax
 971:	cd 40                	int    $0x40
 973:	c3                   	ret    

00000974 <exec>:
SYSCALL(exec)
 974:	b8 07 00 00 00       	mov    $0x7,%eax
 979:	cd 40                	int    $0x40
 97b:	c3                   	ret    

0000097c <open>:
SYSCALL(open)
 97c:	b8 0f 00 00 00       	mov    $0xf,%eax
 981:	cd 40                	int    $0x40
 983:	c3                   	ret    

00000984 <mknod>:
SYSCALL(mknod)
 984:	b8 11 00 00 00       	mov    $0x11,%eax
 989:	cd 40                	int    $0x40
 98b:	c3                   	ret    

0000098c <unlink>:
SYSCALL(unlink)
 98c:	b8 12 00 00 00       	mov    $0x12,%eax
 991:	cd 40                	int    $0x40
 993:	c3                   	ret    

00000994 <fstat>:
SYSCALL(fstat)
 994:	b8 08 00 00 00       	mov    $0x8,%eax
 999:	cd 40                	int    $0x40
 99b:	c3                   	ret    

0000099c <link>:
SYSCALL(link)
 99c:	b8 13 00 00 00       	mov    $0x13,%eax
 9a1:	cd 40                	int    $0x40
 9a3:	c3                   	ret    

000009a4 <mkdir>:
SYSCALL(mkdir)
 9a4:	b8 14 00 00 00       	mov    $0x14,%eax
 9a9:	cd 40                	int    $0x40
 9ab:	c3                   	ret    

000009ac <chdir>:
SYSCALL(chdir)
 9ac:	b8 09 00 00 00       	mov    $0x9,%eax
 9b1:	cd 40                	int    $0x40
 9b3:	c3                   	ret    

000009b4 <dup>:
SYSCALL(dup)
 9b4:	b8 0a 00 00 00       	mov    $0xa,%eax
 9b9:	cd 40                	int    $0x40
 9bb:	c3                   	ret    

000009bc <getpid>:
SYSCALL(getpid)
 9bc:	b8 0b 00 00 00       	mov    $0xb,%eax
 9c1:	cd 40                	int    $0x40
 9c3:	c3                   	ret    

000009c4 <sbrk>:
SYSCALL(sbrk)
 9c4:	b8 0c 00 00 00       	mov    $0xc,%eax
 9c9:	cd 40                	int    $0x40
 9cb:	c3                   	ret    

000009cc <sleep>:
SYSCALL(sleep)
 9cc:	b8 0d 00 00 00       	mov    $0xd,%eax
 9d1:	cd 40                	int    $0x40
 9d3:	c3                   	ret    

000009d4 <uptime>:
SYSCALL(uptime)
 9d4:	b8 0e 00 00 00       	mov    $0xe,%eax
 9d9:	cd 40                	int    $0x40
 9db:	c3                   	ret    

000009dc <halt>:
SYSCALL(halt)
 9dc:	b8 16 00 00 00       	mov    $0x16,%eax
 9e1:	cd 40                	int    $0x40
 9e3:	c3                   	ret    

000009e4 <date>:
SYSCALL(date)
 9e4:	b8 17 00 00 00       	mov    $0x17,%eax
 9e9:	cd 40                	int    $0x40
 9eb:	c3                   	ret    

000009ec <getuid>:
SYSCALL(getuid)
 9ec:	b8 18 00 00 00       	mov    $0x18,%eax
 9f1:	cd 40                	int    $0x40
 9f3:	c3                   	ret    

000009f4 <getgid>:
SYSCALL(getgid)
 9f4:	b8 19 00 00 00       	mov    $0x19,%eax
 9f9:	cd 40                	int    $0x40
 9fb:	c3                   	ret    

000009fc <getppid>:
SYSCALL(getppid)
 9fc:	b8 1a 00 00 00       	mov    $0x1a,%eax
 a01:	cd 40                	int    $0x40
 a03:	c3                   	ret    

00000a04 <setuid>:
SYSCALL(setuid)
 a04:	b8 1b 00 00 00       	mov    $0x1b,%eax
 a09:	cd 40                	int    $0x40
 a0b:	c3                   	ret    

00000a0c <setgid>:
SYSCALL(setgid)
 a0c:	b8 1c 00 00 00       	mov    $0x1c,%eax
 a11:	cd 40                	int    $0x40
 a13:	c3                   	ret    

00000a14 <getprocs>:
SYSCALL(getprocs)
 a14:	b8 1d 00 00 00       	mov    $0x1d,%eax
 a19:	cd 40                	int    $0x40
 a1b:	c3                   	ret    

00000a1c <setpriority>:
SYSCALL(setpriority)
 a1c:	b8 1e 00 00 00       	mov    $0x1e,%eax
 a21:	cd 40                	int    $0x40
 a23:	c3                   	ret    

00000a24 <chmod>:
SYSCALL(chmod)
 a24:	b8 1f 00 00 00       	mov    $0x1f,%eax
 a29:	cd 40                	int    $0x40
 a2b:	c3                   	ret    

00000a2c <chown>:
SYSCALL(chown)
 a2c:	b8 20 00 00 00       	mov    $0x20,%eax
 a31:	cd 40                	int    $0x40
 a33:	c3                   	ret    

00000a34 <chgrp>:
SYSCALL(chgrp)
 a34:	b8 21 00 00 00       	mov    $0x21,%eax
 a39:	cd 40                	int    $0x40
 a3b:	c3                   	ret    

00000a3c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 a3c:	55                   	push   %ebp
 a3d:	89 e5                	mov    %esp,%ebp
 a3f:	83 ec 18             	sub    $0x18,%esp
 a42:	8b 45 0c             	mov    0xc(%ebp),%eax
 a45:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 a48:	83 ec 04             	sub    $0x4,%esp
 a4b:	6a 01                	push   $0x1
 a4d:	8d 45 f4             	lea    -0xc(%ebp),%eax
 a50:	50                   	push   %eax
 a51:	ff 75 08             	pushl  0x8(%ebp)
 a54:	e8 03 ff ff ff       	call   95c <write>
 a59:	83 c4 10             	add    $0x10,%esp
}
 a5c:	90                   	nop
 a5d:	c9                   	leave  
 a5e:	c3                   	ret    

00000a5f <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 a5f:	55                   	push   %ebp
 a60:	89 e5                	mov    %esp,%ebp
 a62:	53                   	push   %ebx
 a63:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 a66:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 a6d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 a71:	74 17                	je     a8a <printint+0x2b>
 a73:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 a77:	79 11                	jns    a8a <printint+0x2b>
    neg = 1;
 a79:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 a80:	8b 45 0c             	mov    0xc(%ebp),%eax
 a83:	f7 d8                	neg    %eax
 a85:	89 45 ec             	mov    %eax,-0x14(%ebp)
 a88:	eb 06                	jmp    a90 <printint+0x31>
  } else {
    x = xx;
 a8a:	8b 45 0c             	mov    0xc(%ebp),%eax
 a8d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 a90:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 a97:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 a9a:	8d 41 01             	lea    0x1(%ecx),%eax
 a9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 aa0:	8b 5d 10             	mov    0x10(%ebp),%ebx
 aa3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 aa6:	ba 00 00 00 00       	mov    $0x0,%edx
 aab:	f7 f3                	div    %ebx
 aad:	89 d0                	mov    %edx,%eax
 aaf:	0f b6 80 30 12 00 00 	movzbl 0x1230(%eax),%eax
 ab6:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 aba:	8b 5d 10             	mov    0x10(%ebp),%ebx
 abd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 ac0:	ba 00 00 00 00       	mov    $0x0,%edx
 ac5:	f7 f3                	div    %ebx
 ac7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 aca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 ace:	75 c7                	jne    a97 <printint+0x38>
  if(neg)
 ad0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 ad4:	74 2d                	je     b03 <printint+0xa4>
    buf[i++] = '-';
 ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad9:	8d 50 01             	lea    0x1(%eax),%edx
 adc:	89 55 f4             	mov    %edx,-0xc(%ebp)
 adf:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 ae4:	eb 1d                	jmp    b03 <printint+0xa4>
    putc(fd, buf[i]);
 ae6:	8d 55 dc             	lea    -0x24(%ebp),%edx
 ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aec:	01 d0                	add    %edx,%eax
 aee:	0f b6 00             	movzbl (%eax),%eax
 af1:	0f be c0             	movsbl %al,%eax
 af4:	83 ec 08             	sub    $0x8,%esp
 af7:	50                   	push   %eax
 af8:	ff 75 08             	pushl  0x8(%ebp)
 afb:	e8 3c ff ff ff       	call   a3c <putc>
 b00:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 b03:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 b07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b0b:	79 d9                	jns    ae6 <printint+0x87>
    putc(fd, buf[i]);
}
 b0d:	90                   	nop
 b0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 b11:	c9                   	leave  
 b12:	c3                   	ret    

00000b13 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 b13:	55                   	push   %ebp
 b14:	89 e5                	mov    %esp,%ebp
 b16:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 b19:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 b20:	8d 45 0c             	lea    0xc(%ebp),%eax
 b23:	83 c0 04             	add    $0x4,%eax
 b26:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 b29:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 b30:	e9 59 01 00 00       	jmp    c8e <printf+0x17b>
    c = fmt[i] & 0xff;
 b35:	8b 55 0c             	mov    0xc(%ebp),%edx
 b38:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b3b:	01 d0                	add    %edx,%eax
 b3d:	0f b6 00             	movzbl (%eax),%eax
 b40:	0f be c0             	movsbl %al,%eax
 b43:	25 ff 00 00 00       	and    $0xff,%eax
 b48:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 b4b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 b4f:	75 2c                	jne    b7d <printf+0x6a>
      if(c == '%'){
 b51:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 b55:	75 0c                	jne    b63 <printf+0x50>
        state = '%';
 b57:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 b5e:	e9 27 01 00 00       	jmp    c8a <printf+0x177>
      } else {
        putc(fd, c);
 b63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b66:	0f be c0             	movsbl %al,%eax
 b69:	83 ec 08             	sub    $0x8,%esp
 b6c:	50                   	push   %eax
 b6d:	ff 75 08             	pushl  0x8(%ebp)
 b70:	e8 c7 fe ff ff       	call   a3c <putc>
 b75:	83 c4 10             	add    $0x10,%esp
 b78:	e9 0d 01 00 00       	jmp    c8a <printf+0x177>
      }
    } else if(state == '%'){
 b7d:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 b81:	0f 85 03 01 00 00    	jne    c8a <printf+0x177>
      if(c == 'd'){
 b87:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 b8b:	75 1e                	jne    bab <printf+0x98>
        printint(fd, *ap, 10, 1);
 b8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b90:	8b 00                	mov    (%eax),%eax
 b92:	6a 01                	push   $0x1
 b94:	6a 0a                	push   $0xa
 b96:	50                   	push   %eax
 b97:	ff 75 08             	pushl  0x8(%ebp)
 b9a:	e8 c0 fe ff ff       	call   a5f <printint>
 b9f:	83 c4 10             	add    $0x10,%esp
        ap++;
 ba2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 ba6:	e9 d8 00 00 00       	jmp    c83 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 bab:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 baf:	74 06                	je     bb7 <printf+0xa4>
 bb1:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 bb5:	75 1e                	jne    bd5 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 bb7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 bba:	8b 00                	mov    (%eax),%eax
 bbc:	6a 00                	push   $0x0
 bbe:	6a 10                	push   $0x10
 bc0:	50                   	push   %eax
 bc1:	ff 75 08             	pushl  0x8(%ebp)
 bc4:	e8 96 fe ff ff       	call   a5f <printint>
 bc9:	83 c4 10             	add    $0x10,%esp
        ap++;
 bcc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 bd0:	e9 ae 00 00 00       	jmp    c83 <printf+0x170>
      } else if(c == 's'){
 bd5:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 bd9:	75 43                	jne    c1e <printf+0x10b>
        s = (char*)*ap;
 bdb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 bde:	8b 00                	mov    (%eax),%eax
 be0:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 be3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 be7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 beb:	75 25                	jne    c12 <printf+0xff>
          s = "(null)";
 bed:	c7 45 f4 49 0f 00 00 	movl   $0xf49,-0xc(%ebp)
        while(*s != 0){
 bf4:	eb 1c                	jmp    c12 <printf+0xff>
          putc(fd, *s);
 bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bf9:	0f b6 00             	movzbl (%eax),%eax
 bfc:	0f be c0             	movsbl %al,%eax
 bff:	83 ec 08             	sub    $0x8,%esp
 c02:	50                   	push   %eax
 c03:	ff 75 08             	pushl  0x8(%ebp)
 c06:	e8 31 fe ff ff       	call   a3c <putc>
 c0b:	83 c4 10             	add    $0x10,%esp
          s++;
 c0e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 c12:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c15:	0f b6 00             	movzbl (%eax),%eax
 c18:	84 c0                	test   %al,%al
 c1a:	75 da                	jne    bf6 <printf+0xe3>
 c1c:	eb 65                	jmp    c83 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 c1e:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 c22:	75 1d                	jne    c41 <printf+0x12e>
        putc(fd, *ap);
 c24:	8b 45 e8             	mov    -0x18(%ebp),%eax
 c27:	8b 00                	mov    (%eax),%eax
 c29:	0f be c0             	movsbl %al,%eax
 c2c:	83 ec 08             	sub    $0x8,%esp
 c2f:	50                   	push   %eax
 c30:	ff 75 08             	pushl  0x8(%ebp)
 c33:	e8 04 fe ff ff       	call   a3c <putc>
 c38:	83 c4 10             	add    $0x10,%esp
        ap++;
 c3b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 c3f:	eb 42                	jmp    c83 <printf+0x170>
      } else if(c == '%'){
 c41:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 c45:	75 17                	jne    c5e <printf+0x14b>
        putc(fd, c);
 c47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 c4a:	0f be c0             	movsbl %al,%eax
 c4d:	83 ec 08             	sub    $0x8,%esp
 c50:	50                   	push   %eax
 c51:	ff 75 08             	pushl  0x8(%ebp)
 c54:	e8 e3 fd ff ff       	call   a3c <putc>
 c59:	83 c4 10             	add    $0x10,%esp
 c5c:	eb 25                	jmp    c83 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 c5e:	83 ec 08             	sub    $0x8,%esp
 c61:	6a 25                	push   $0x25
 c63:	ff 75 08             	pushl  0x8(%ebp)
 c66:	e8 d1 fd ff ff       	call   a3c <putc>
 c6b:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 c6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 c71:	0f be c0             	movsbl %al,%eax
 c74:	83 ec 08             	sub    $0x8,%esp
 c77:	50                   	push   %eax
 c78:	ff 75 08             	pushl  0x8(%ebp)
 c7b:	e8 bc fd ff ff       	call   a3c <putc>
 c80:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 c83:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 c8a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 c8e:	8b 55 0c             	mov    0xc(%ebp),%edx
 c91:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c94:	01 d0                	add    %edx,%eax
 c96:	0f b6 00             	movzbl (%eax),%eax
 c99:	84 c0                	test   %al,%al
 c9b:	0f 85 94 fe ff ff    	jne    b35 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 ca1:	90                   	nop
 ca2:	c9                   	leave  
 ca3:	c3                   	ret    

00000ca4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ca4:	55                   	push   %ebp
 ca5:	89 e5                	mov    %esp,%ebp
 ca7:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 caa:	8b 45 08             	mov    0x8(%ebp),%eax
 cad:	83 e8 08             	sub    $0x8,%eax
 cb0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 cb3:	a1 5c 12 00 00       	mov    0x125c,%eax
 cb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 cbb:	eb 24                	jmp    ce1 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 cbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cc0:	8b 00                	mov    (%eax),%eax
 cc2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 cc5:	77 12                	ja     cd9 <free+0x35>
 cc7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cca:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 ccd:	77 24                	ja     cf3 <free+0x4f>
 ccf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cd2:	8b 00                	mov    (%eax),%eax
 cd4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 cd7:	77 1a                	ja     cf3 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 cd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cdc:	8b 00                	mov    (%eax),%eax
 cde:	89 45 fc             	mov    %eax,-0x4(%ebp)
 ce1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ce4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 ce7:	76 d4                	jbe    cbd <free+0x19>
 ce9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cec:	8b 00                	mov    (%eax),%eax
 cee:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 cf1:	76 ca                	jbe    cbd <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 cf3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cf6:	8b 40 04             	mov    0x4(%eax),%eax
 cf9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 d00:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d03:	01 c2                	add    %eax,%edx
 d05:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d08:	8b 00                	mov    (%eax),%eax
 d0a:	39 c2                	cmp    %eax,%edx
 d0c:	75 24                	jne    d32 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 d0e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d11:	8b 50 04             	mov    0x4(%eax),%edx
 d14:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d17:	8b 00                	mov    (%eax),%eax
 d19:	8b 40 04             	mov    0x4(%eax),%eax
 d1c:	01 c2                	add    %eax,%edx
 d1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d21:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 d24:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d27:	8b 00                	mov    (%eax),%eax
 d29:	8b 10                	mov    (%eax),%edx
 d2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d2e:	89 10                	mov    %edx,(%eax)
 d30:	eb 0a                	jmp    d3c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 d32:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d35:	8b 10                	mov    (%eax),%edx
 d37:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d3a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 d3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d3f:	8b 40 04             	mov    0x4(%eax),%eax
 d42:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 d49:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d4c:	01 d0                	add    %edx,%eax
 d4e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 d51:	75 20                	jne    d73 <free+0xcf>
    p->s.size += bp->s.size;
 d53:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d56:	8b 50 04             	mov    0x4(%eax),%edx
 d59:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d5c:	8b 40 04             	mov    0x4(%eax),%eax
 d5f:	01 c2                	add    %eax,%edx
 d61:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d64:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 d67:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d6a:	8b 10                	mov    (%eax),%edx
 d6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d6f:	89 10                	mov    %edx,(%eax)
 d71:	eb 08                	jmp    d7b <free+0xd7>
  } else
    p->s.ptr = bp;
 d73:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d76:	8b 55 f8             	mov    -0x8(%ebp),%edx
 d79:	89 10                	mov    %edx,(%eax)
  freep = p;
 d7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d7e:	a3 5c 12 00 00       	mov    %eax,0x125c
}
 d83:	90                   	nop
 d84:	c9                   	leave  
 d85:	c3                   	ret    

00000d86 <morecore>:

static Header*
morecore(uint nu)
{
 d86:	55                   	push   %ebp
 d87:	89 e5                	mov    %esp,%ebp
 d89:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 d8c:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 d93:	77 07                	ja     d9c <morecore+0x16>
    nu = 4096;
 d95:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 d9c:	8b 45 08             	mov    0x8(%ebp),%eax
 d9f:	c1 e0 03             	shl    $0x3,%eax
 da2:	83 ec 0c             	sub    $0xc,%esp
 da5:	50                   	push   %eax
 da6:	e8 19 fc ff ff       	call   9c4 <sbrk>
 dab:	83 c4 10             	add    $0x10,%esp
 dae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 db1:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 db5:	75 07                	jne    dbe <morecore+0x38>
    return 0;
 db7:	b8 00 00 00 00       	mov    $0x0,%eax
 dbc:	eb 26                	jmp    de4 <morecore+0x5e>
  hp = (Header*)p;
 dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 dc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 dc7:	8b 55 08             	mov    0x8(%ebp),%edx
 dca:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 dd0:	83 c0 08             	add    $0x8,%eax
 dd3:	83 ec 0c             	sub    $0xc,%esp
 dd6:	50                   	push   %eax
 dd7:	e8 c8 fe ff ff       	call   ca4 <free>
 ddc:	83 c4 10             	add    $0x10,%esp
  return freep;
 ddf:	a1 5c 12 00 00       	mov    0x125c,%eax
}
 de4:	c9                   	leave  
 de5:	c3                   	ret    

00000de6 <malloc>:

void*
malloc(uint nbytes)
{
 de6:	55                   	push   %ebp
 de7:	89 e5                	mov    %esp,%ebp
 de9:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 dec:	8b 45 08             	mov    0x8(%ebp),%eax
 def:	83 c0 07             	add    $0x7,%eax
 df2:	c1 e8 03             	shr    $0x3,%eax
 df5:	83 c0 01             	add    $0x1,%eax
 df8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 dfb:	a1 5c 12 00 00       	mov    0x125c,%eax
 e00:	89 45 f0             	mov    %eax,-0x10(%ebp)
 e03:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 e07:	75 23                	jne    e2c <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 e09:	c7 45 f0 54 12 00 00 	movl   $0x1254,-0x10(%ebp)
 e10:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e13:	a3 5c 12 00 00       	mov    %eax,0x125c
 e18:	a1 5c 12 00 00       	mov    0x125c,%eax
 e1d:	a3 54 12 00 00       	mov    %eax,0x1254
    base.s.size = 0;
 e22:	c7 05 58 12 00 00 00 	movl   $0x0,0x1258
 e29:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e2f:	8b 00                	mov    (%eax),%eax
 e31:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 e34:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e37:	8b 40 04             	mov    0x4(%eax),%eax
 e3a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 e3d:	72 4d                	jb     e8c <malloc+0xa6>
      if(p->s.size == nunits)
 e3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e42:	8b 40 04             	mov    0x4(%eax),%eax
 e45:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 e48:	75 0c                	jne    e56 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e4d:	8b 10                	mov    (%eax),%edx
 e4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e52:	89 10                	mov    %edx,(%eax)
 e54:	eb 26                	jmp    e7c <malloc+0x96>
      else {
        p->s.size -= nunits;
 e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e59:	8b 40 04             	mov    0x4(%eax),%eax
 e5c:	2b 45 ec             	sub    -0x14(%ebp),%eax
 e5f:	89 c2                	mov    %eax,%edx
 e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e64:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e6a:	8b 40 04             	mov    0x4(%eax),%eax
 e6d:	c1 e0 03             	shl    $0x3,%eax
 e70:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e76:	8b 55 ec             	mov    -0x14(%ebp),%edx
 e79:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 e7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e7f:	a3 5c 12 00 00       	mov    %eax,0x125c
      return (void*)(p + 1);
 e84:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e87:	83 c0 08             	add    $0x8,%eax
 e8a:	eb 3b                	jmp    ec7 <malloc+0xe1>
    }
    if(p == freep)
 e8c:	a1 5c 12 00 00       	mov    0x125c,%eax
 e91:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 e94:	75 1e                	jne    eb4 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 e96:	83 ec 0c             	sub    $0xc,%esp
 e99:	ff 75 ec             	pushl  -0x14(%ebp)
 e9c:	e8 e5 fe ff ff       	call   d86 <morecore>
 ea1:	83 c4 10             	add    $0x10,%esp
 ea4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 ea7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 eab:	75 07                	jne    eb4 <malloc+0xce>
        return 0;
 ead:	b8 00 00 00 00       	mov    $0x0,%eax
 eb2:	eb 13                	jmp    ec7 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 eb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
 eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ebd:	8b 00                	mov    (%eax),%eax
 ebf:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 ec2:	e9 6d ff ff ff       	jmp    e34 <malloc+0x4e>
}
 ec7:	c9                   	leave  
 ec8:	c3                   	ret    
