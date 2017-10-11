
_testgetprocs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#include "uproc.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 28             	sub    $0x28,%esp
  14:	89 c8                	mov    %ecx,%eax
  int table_size = atoi(argv[1]);
  16:	8b 40 04             	mov    0x4(%eax),%eax
  19:	83 c0 04             	add    $0x4,%eax
  1c:	8b 00                	mov    (%eax),%eax
  1e:	83 ec 0c             	sub    $0xc,%esp
  21:	50                   	push   %eax
  22:	e8 e2 03 00 00       	call   409 <atoi>
  27:	83 c4 10             	add    $0x10,%esp
  2a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  int running_procs;

  struct uproc* table = malloc(sizeof(struct uproc)*table_size);
  2d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  30:	6b c0 5c             	imul   $0x5c,%eax,%eax
  33:	83 ec 0c             	sub    $0xc,%esp
  36:	50                   	push   %eax
  37:	e8 2e 09 00 00       	call   96a <malloc>
  3c:	83 c4 10             	add    $0x10,%esp
  3f:	89 45 d8             	mov    %eax,-0x28(%ebp)

  for(int i = 0; i < 72; i++){
  42:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  49:	eb 27                	jmp    72 <main+0x72>
    int pid = fork();
  4b:	e8 88 04 00 00       	call   4d8 <fork>
  50:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if(pid == 0){
  53:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  57:	75 15                	jne    6e <main+0x6e>
      sleep(100000);
  59:	83 ec 0c             	sub    $0xc,%esp
  5c:	68 a0 86 01 00       	push   $0x186a0
  61:	e8 0a 05 00 00       	call   570 <sleep>
  66:	83 c4 10             	add    $0x10,%esp
      exit();
  69:	e8 72 04 00 00       	call   4e0 <exit>
  int table_size = atoi(argv[1]);
  int running_procs;

  struct uproc* table = malloc(sizeof(struct uproc)*table_size);

  for(int i = 0; i < 72; i++){
  6e:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  72:	83 7d e4 47          	cmpl   $0x47,-0x1c(%ebp)
  76:	7e d3                	jle    4b <main+0x4b>
      sleep(100000);
      exit();
    }
  }

  running_procs = getprocs(table_size, table);
  78:	8b 45 dc             	mov    -0x24(%ebp),%eax
  7b:	83 ec 08             	sub    $0x8,%esp
  7e:	ff 75 d8             	pushl  -0x28(%ebp)
  81:	50                   	push   %eax
  82:	e8 31 05 00 00       	call   5b8 <getprocs>
  87:	83 c4 10             	add    $0x10,%esp
  8a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  if(running_procs == 0) {
  8d:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  91:	75 1b                	jne    ae <main+0xae>
    printf(2, "Error: ps call failed.  %s at line %d\n", __FILE__, __LINE__);
  93:	6a 19                	push   $0x19
  95:	68 50 0a 00 00       	push   $0xa50
  9a:	68 60 0a 00 00       	push   $0xa60
  9f:	6a 02                	push   $0x2
  a1:	e8 f1 05 00 00       	call   697 <printf>
  a6:	83 c4 10             	add    $0x10,%esp
    exit();
  a9:	e8 32 04 00 00       	call   4e0 <exit>
  }

  printf(1, "PID\tName\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\n");
  ae:	83 ec 08             	sub    $0x8,%esp
  b1:	68 88 0a 00 00       	push   $0xa88
  b6:	6a 01                	push   $0x1
  b8:	e8 da 05 00 00       	call   697 <printf>
  bd:	83 c4 10             	add    $0x10,%esp
  for(int i = 0; i < running_procs; i++){
  c0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  c7:	e9 c1 00 00 00       	jmp    18d <main+0x18d>
    printf(1, "%d\t%s\t%d\t%d\t%d\t", table[i].pid, table[i].name,
        table[i].uid, table[i].gid, table[i].ppid);
  cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  cf:	6b d0 5c             	imul   $0x5c,%eax,%edx
  d2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  d5:	01 d0                	add    %edx,%eax
    exit();
  }

  printf(1, "PID\tName\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\n");
  for(int i = 0; i < running_procs; i++){
    printf(1, "%d\t%s\t%d\t%d\t%d\t", table[i].pid, table[i].name,
  d7:	8b 58 0c             	mov    0xc(%eax),%ebx
        table[i].uid, table[i].gid, table[i].ppid);
  da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  dd:	6b d0 5c             	imul   $0x5c,%eax,%edx
  e0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  e3:	01 d0                	add    %edx,%eax
    exit();
  }

  printf(1, "PID\tName\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\n");
  for(int i = 0; i < running_procs; i++){
    printf(1, "%d\t%s\t%d\t%d\t%d\t", table[i].pid, table[i].name,
  e5:	8b 48 08             	mov    0x8(%eax),%ecx
        table[i].uid, table[i].gid, table[i].ppid);
  e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  eb:	6b d0 5c             	imul   $0x5c,%eax,%edx
  ee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  f1:	01 d0                	add    %edx,%eax
    exit();
  }

  printf(1, "PID\tName\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\n");
  for(int i = 0; i < running_procs; i++){
    printf(1, "%d\t%s\t%d\t%d\t%d\t", table[i].pid, table[i].name,
  f3:	8b 50 04             	mov    0x4(%eax),%edx
  f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  f9:	6b f0 5c             	imul   $0x5c,%eax,%esi
  fc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  ff:	01 f0                	add    %esi,%eax
 101:	8d 70 3c             	lea    0x3c(%eax),%esi
 104:	8b 45 e0             	mov    -0x20(%ebp),%eax
 107:	6b f8 5c             	imul   $0x5c,%eax,%edi
 10a:	8b 45 d8             	mov    -0x28(%ebp),%eax
 10d:	01 f8                	add    %edi,%eax
 10f:	8b 00                	mov    (%eax),%eax
 111:	83 ec 04             	sub    $0x4,%esp
 114:	53                   	push   %ebx
 115:	51                   	push   %ecx
 116:	52                   	push   %edx
 117:	56                   	push   %esi
 118:	50                   	push   %eax
 119:	68 b6 0a 00 00       	push   $0xab6
 11e:	6a 01                	push   $0x1
 120:	e8 72 05 00 00       	call   697 <printf>
 125:	83 c4 20             	add    $0x20,%esp
        table[i].uid, table[i].gid, table[i].ppid);
    calcelapsedtime(table[i].elapsed_ticks);
 128:	8b 45 e0             	mov    -0x20(%ebp),%eax
 12b:	6b d0 5c             	imul   $0x5c,%eax,%edx
 12e:	8b 45 d8             	mov    -0x28(%ebp),%eax
 131:	01 d0                	add    %edx,%eax
 133:	8b 40 10             	mov    0x10(%eax),%eax
 136:	83 ec 0c             	sub    $0xc,%esp
 139:	50                   	push   %eax
 13a:	e8 6d 00 00 00       	call   1ac <calcelapsedtime>
 13f:	83 c4 10             	add    $0x10,%esp
    calcelapsedtime(table[i].CPU_total_ticks);
 142:	8b 45 e0             	mov    -0x20(%ebp),%eax
 145:	6b d0 5c             	imul   $0x5c,%eax,%edx
 148:	8b 45 d8             	mov    -0x28(%ebp),%eax
 14b:	01 d0                	add    %edx,%eax
 14d:	8b 40 14             	mov    0x14(%eax),%eax
 150:	83 ec 0c             	sub    $0xc,%esp
 153:	50                   	push   %eax
 154:	e8 53 00 00 00       	call   1ac <calcelapsedtime>
 159:	83 c4 10             	add    $0x10,%esp
    printf(1, "%s\t%d\n", table[i].state, table[i].size);
 15c:	8b 45 e0             	mov    -0x20(%ebp),%eax
 15f:	6b d0 5c             	imul   $0x5c,%eax,%edx
 162:	8b 45 d8             	mov    -0x28(%ebp),%eax
 165:	01 d0                	add    %edx,%eax
 167:	8b 40 38             	mov    0x38(%eax),%eax
 16a:	8b 55 e0             	mov    -0x20(%ebp),%edx
 16d:	6b ca 5c             	imul   $0x5c,%edx,%ecx
 170:	8b 55 d8             	mov    -0x28(%ebp),%edx
 173:	01 ca                	add    %ecx,%edx
 175:	83 c2 18             	add    $0x18,%edx
 178:	50                   	push   %eax
 179:	52                   	push   %edx
 17a:	68 c6 0a 00 00       	push   $0xac6
 17f:	6a 01                	push   $0x1
 181:	e8 11 05 00 00       	call   697 <printf>
 186:	83 c4 10             	add    $0x10,%esp
    printf(2, "Error: ps call failed.  %s at line %d\n", __FILE__, __LINE__);
    exit();
  }

  printf(1, "PID\tName\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\n");
  for(int i = 0; i < running_procs; i++){
 189:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
 18d:	8b 45 e0             	mov    -0x20(%ebp),%eax
 190:	3b 45 d0             	cmp    -0x30(%ebp),%eax
 193:	0f 8c 33 ff ff ff    	jl     cc <main+0xcc>
    calcelapsedtime(table[i].elapsed_ticks);
    calcelapsedtime(table[i].CPU_total_ticks);
    printf(1, "%s\t%d\n", table[i].state, table[i].size);
  }

  free(table);
 199:	83 ec 0c             	sub    $0xc,%esp
 19c:	ff 75 d8             	pushl  -0x28(%ebp)
 19f:	e8 84 06 00 00       	call   828 <free>
 1a4:	83 c4 10             	add    $0x10,%esp
  exit();
 1a7:	e8 34 03 00 00       	call   4e0 <exit>

000001ac <calcelapsedtime>:

// Determines the seconds elapsed for a running process to the thousandth of a
// second and prints the result
void
calcelapsedtime(int ticks_in)
{
 1ac:	55                   	push   %ebp
 1ad:	89 e5                	mov    %esp,%ebp
 1af:	83 ec 18             	sub    $0x18,%esp
  int seconds = (ticks_in)/1000;
 1b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1b5:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
 1ba:	89 c8                	mov    %ecx,%eax
 1bc:	f7 ea                	imul   %edx
 1be:	c1 fa 06             	sar    $0x6,%edx
 1c1:	89 c8                	mov    %ecx,%eax
 1c3:	c1 f8 1f             	sar    $0x1f,%eax
 1c6:	29 c2                	sub    %eax,%edx
 1c8:	89 d0                	mov    %edx,%eax
 1ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int milliseconds = (ticks_in)%1000;
 1cd:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1d0:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
 1d5:	89 c8                	mov    %ecx,%eax
 1d7:	f7 ea                	imul   %edx
 1d9:	c1 fa 06             	sar    $0x6,%edx
 1dc:	89 c8                	mov    %ecx,%eax
 1de:	c1 f8 1f             	sar    $0x1f,%eax
 1e1:	29 c2                	sub    %eax,%edx
 1e3:	89 d0                	mov    %edx,%eax
 1e5:	69 c0 e8 03 00 00    	imul   $0x3e8,%eax,%eax
 1eb:	29 c1                	sub    %eax,%ecx
 1ed:	89 c8                	mov    %ecx,%eax
 1ef:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(milliseconds < 10)
 1f2:	83 7d f0 09          	cmpl   $0x9,-0x10(%ebp)
 1f6:	7f 17                	jg     20f <calcelapsedtime+0x63>
    printf(1, "%d.00%d\t", seconds, milliseconds);
 1f8:	ff 75 f0             	pushl  -0x10(%ebp)
 1fb:	ff 75 f4             	pushl  -0xc(%ebp)
 1fe:	68 cd 0a 00 00       	push   $0xacd
 203:	6a 01                	push   $0x1
 205:	e8 8d 04 00 00       	call   697 <printf>
 20a:	83 c4 10             	add    $0x10,%esp
  else if(milliseconds < 100)
    printf(1, "%d.0%d\t", seconds, milliseconds);
  else
    printf(1, "%d.%d\t", seconds, milliseconds);
}
 20d:	eb 32                	jmp    241 <calcelapsedtime+0x95>
  int seconds = (ticks_in)/1000;
  int milliseconds = (ticks_in)%1000;

  if(milliseconds < 10)
    printf(1, "%d.00%d\t", seconds, milliseconds);
  else if(milliseconds < 100)
 20f:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
 213:	7f 17                	jg     22c <calcelapsedtime+0x80>
    printf(1, "%d.0%d\t", seconds, milliseconds);
 215:	ff 75 f0             	pushl  -0x10(%ebp)
 218:	ff 75 f4             	pushl  -0xc(%ebp)
 21b:	68 d6 0a 00 00       	push   $0xad6
 220:	6a 01                	push   $0x1
 222:	e8 70 04 00 00       	call   697 <printf>
 227:	83 c4 10             	add    $0x10,%esp
  else
    printf(1, "%d.%d\t", seconds, milliseconds);
}
 22a:	eb 15                	jmp    241 <calcelapsedtime+0x95>
  if(milliseconds < 10)
    printf(1, "%d.00%d\t", seconds, milliseconds);
  else if(milliseconds < 100)
    printf(1, "%d.0%d\t", seconds, milliseconds);
  else
    printf(1, "%d.%d\t", seconds, milliseconds);
 22c:	ff 75 f0             	pushl  -0x10(%ebp)
 22f:	ff 75 f4             	pushl  -0xc(%ebp)
 232:	68 de 0a 00 00       	push   $0xade
 237:	6a 01                	push   $0x1
 239:	e8 59 04 00 00       	call   697 <printf>
 23e:	83 c4 10             	add    $0x10,%esp
}
 241:	90                   	nop
 242:	c9                   	leave  
 243:	c3                   	ret    

00000244 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 244:	55                   	push   %ebp
 245:	89 e5                	mov    %esp,%ebp
 247:	57                   	push   %edi
 248:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 249:	8b 4d 08             	mov    0x8(%ebp),%ecx
 24c:	8b 55 10             	mov    0x10(%ebp),%edx
 24f:	8b 45 0c             	mov    0xc(%ebp),%eax
 252:	89 cb                	mov    %ecx,%ebx
 254:	89 df                	mov    %ebx,%edi
 256:	89 d1                	mov    %edx,%ecx
 258:	fc                   	cld    
 259:	f3 aa                	rep stos %al,%es:(%edi)
 25b:	89 ca                	mov    %ecx,%edx
 25d:	89 fb                	mov    %edi,%ebx
 25f:	89 5d 08             	mov    %ebx,0x8(%ebp)
 262:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 265:	90                   	nop
 266:	5b                   	pop    %ebx
 267:	5f                   	pop    %edi
 268:	5d                   	pop    %ebp
 269:	c3                   	ret    

0000026a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 26a:	55                   	push   %ebp
 26b:	89 e5                	mov    %esp,%ebp
 26d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 270:	8b 45 08             	mov    0x8(%ebp),%eax
 273:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 276:	90                   	nop
 277:	8b 45 08             	mov    0x8(%ebp),%eax
 27a:	8d 50 01             	lea    0x1(%eax),%edx
 27d:	89 55 08             	mov    %edx,0x8(%ebp)
 280:	8b 55 0c             	mov    0xc(%ebp),%edx
 283:	8d 4a 01             	lea    0x1(%edx),%ecx
 286:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 289:	0f b6 12             	movzbl (%edx),%edx
 28c:	88 10                	mov    %dl,(%eax)
 28e:	0f b6 00             	movzbl (%eax),%eax
 291:	84 c0                	test   %al,%al
 293:	75 e2                	jne    277 <strcpy+0xd>
    ;
  return os;
 295:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 298:	c9                   	leave  
 299:	c3                   	ret    

0000029a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 29a:	55                   	push   %ebp
 29b:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 29d:	eb 08                	jmp    2a7 <strcmp+0xd>
    p++, q++;
 29f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2a3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 2a7:	8b 45 08             	mov    0x8(%ebp),%eax
 2aa:	0f b6 00             	movzbl (%eax),%eax
 2ad:	84 c0                	test   %al,%al
 2af:	74 10                	je     2c1 <strcmp+0x27>
 2b1:	8b 45 08             	mov    0x8(%ebp),%eax
 2b4:	0f b6 10             	movzbl (%eax),%edx
 2b7:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ba:	0f b6 00             	movzbl (%eax),%eax
 2bd:	38 c2                	cmp    %al,%dl
 2bf:	74 de                	je     29f <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 2c1:	8b 45 08             	mov    0x8(%ebp),%eax
 2c4:	0f b6 00             	movzbl (%eax),%eax
 2c7:	0f b6 d0             	movzbl %al,%edx
 2ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 2cd:	0f b6 00             	movzbl (%eax),%eax
 2d0:	0f b6 c0             	movzbl %al,%eax
 2d3:	29 c2                	sub    %eax,%edx
 2d5:	89 d0                	mov    %edx,%eax
}
 2d7:	5d                   	pop    %ebp
 2d8:	c3                   	ret    

000002d9 <strlen>:

uint
strlen(char *s)
{
 2d9:	55                   	push   %ebp
 2da:	89 e5                	mov    %esp,%ebp
 2dc:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 2df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 2e6:	eb 04                	jmp    2ec <strlen+0x13>
 2e8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 2ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2ef:	8b 45 08             	mov    0x8(%ebp),%eax
 2f2:	01 d0                	add    %edx,%eax
 2f4:	0f b6 00             	movzbl (%eax),%eax
 2f7:	84 c0                	test   %al,%al
 2f9:	75 ed                	jne    2e8 <strlen+0xf>
    ;
  return n;
 2fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2fe:	c9                   	leave  
 2ff:	c3                   	ret    

00000300 <memset>:

void*
memset(void *dst, int c, uint n)
{
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 303:	8b 45 10             	mov    0x10(%ebp),%eax
 306:	50                   	push   %eax
 307:	ff 75 0c             	pushl  0xc(%ebp)
 30a:	ff 75 08             	pushl  0x8(%ebp)
 30d:	e8 32 ff ff ff       	call   244 <stosb>
 312:	83 c4 0c             	add    $0xc,%esp
  return dst;
 315:	8b 45 08             	mov    0x8(%ebp),%eax
}
 318:	c9                   	leave  
 319:	c3                   	ret    

0000031a <strchr>:

char*
strchr(const char *s, char c)
{
 31a:	55                   	push   %ebp
 31b:	89 e5                	mov    %esp,%ebp
 31d:	83 ec 04             	sub    $0x4,%esp
 320:	8b 45 0c             	mov    0xc(%ebp),%eax
 323:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 326:	eb 14                	jmp    33c <strchr+0x22>
    if(*s == c)
 328:	8b 45 08             	mov    0x8(%ebp),%eax
 32b:	0f b6 00             	movzbl (%eax),%eax
 32e:	3a 45 fc             	cmp    -0x4(%ebp),%al
 331:	75 05                	jne    338 <strchr+0x1e>
      return (char*)s;
 333:	8b 45 08             	mov    0x8(%ebp),%eax
 336:	eb 13                	jmp    34b <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 338:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 33c:	8b 45 08             	mov    0x8(%ebp),%eax
 33f:	0f b6 00             	movzbl (%eax),%eax
 342:	84 c0                	test   %al,%al
 344:	75 e2                	jne    328 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 346:	b8 00 00 00 00       	mov    $0x0,%eax
}
 34b:	c9                   	leave  
 34c:	c3                   	ret    

0000034d <gets>:

char*
gets(char *buf, int max)
{
 34d:	55                   	push   %ebp
 34e:	89 e5                	mov    %esp,%ebp
 350:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 353:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 35a:	eb 42                	jmp    39e <gets+0x51>
    cc = read(0, &c, 1);
 35c:	83 ec 04             	sub    $0x4,%esp
 35f:	6a 01                	push   $0x1
 361:	8d 45 ef             	lea    -0x11(%ebp),%eax
 364:	50                   	push   %eax
 365:	6a 00                	push   $0x0
 367:	e8 8c 01 00 00       	call   4f8 <read>
 36c:	83 c4 10             	add    $0x10,%esp
 36f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 372:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 376:	7e 33                	jle    3ab <gets+0x5e>
      break;
    buf[i++] = c;
 378:	8b 45 f4             	mov    -0xc(%ebp),%eax
 37b:	8d 50 01             	lea    0x1(%eax),%edx
 37e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 381:	89 c2                	mov    %eax,%edx
 383:	8b 45 08             	mov    0x8(%ebp),%eax
 386:	01 c2                	add    %eax,%edx
 388:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 38c:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 38e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 392:	3c 0a                	cmp    $0xa,%al
 394:	74 16                	je     3ac <gets+0x5f>
 396:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 39a:	3c 0d                	cmp    $0xd,%al
 39c:	74 0e                	je     3ac <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 39e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3a1:	83 c0 01             	add    $0x1,%eax
 3a4:	3b 45 0c             	cmp    0xc(%ebp),%eax
 3a7:	7c b3                	jl     35c <gets+0xf>
 3a9:	eb 01                	jmp    3ac <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 3ab:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 3ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3af:	8b 45 08             	mov    0x8(%ebp),%eax
 3b2:	01 d0                	add    %edx,%eax
 3b4:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 3b7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3ba:	c9                   	leave  
 3bb:	c3                   	ret    

000003bc <stat>:

int
stat(char *n, struct stat *st)
{
 3bc:	55                   	push   %ebp
 3bd:	89 e5                	mov    %esp,%ebp
 3bf:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3c2:	83 ec 08             	sub    $0x8,%esp
 3c5:	6a 00                	push   $0x0
 3c7:	ff 75 08             	pushl  0x8(%ebp)
 3ca:	e8 51 01 00 00       	call   520 <open>
 3cf:	83 c4 10             	add    $0x10,%esp
 3d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 3d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3d9:	79 07                	jns    3e2 <stat+0x26>
    return -1;
 3db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3e0:	eb 25                	jmp    407 <stat+0x4b>
  r = fstat(fd, st);
 3e2:	83 ec 08             	sub    $0x8,%esp
 3e5:	ff 75 0c             	pushl  0xc(%ebp)
 3e8:	ff 75 f4             	pushl  -0xc(%ebp)
 3eb:	e8 48 01 00 00       	call   538 <fstat>
 3f0:	83 c4 10             	add    $0x10,%esp
 3f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 3f6:	83 ec 0c             	sub    $0xc,%esp
 3f9:	ff 75 f4             	pushl  -0xc(%ebp)
 3fc:	e8 07 01 00 00       	call   508 <close>
 401:	83 c4 10             	add    $0x10,%esp
  return r;
 404:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 407:	c9                   	leave  
 408:	c3                   	ret    

00000409 <atoi>:

int
atoi(const char *s)
{
 409:	55                   	push   %ebp
 40a:	89 e5                	mov    %esp,%ebp
 40c:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 40f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 416:	eb 04                	jmp    41c <atoi+0x13>
 418:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 41c:	8b 45 08             	mov    0x8(%ebp),%eax
 41f:	0f b6 00             	movzbl (%eax),%eax
 422:	3c 20                	cmp    $0x20,%al
 424:	74 f2                	je     418 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 426:	8b 45 08             	mov    0x8(%ebp),%eax
 429:	0f b6 00             	movzbl (%eax),%eax
 42c:	3c 2d                	cmp    $0x2d,%al
 42e:	75 07                	jne    437 <atoi+0x2e>
 430:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 435:	eb 05                	jmp    43c <atoi+0x33>
 437:	b8 01 00 00 00       	mov    $0x1,%eax
 43c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 43f:	8b 45 08             	mov    0x8(%ebp),%eax
 442:	0f b6 00             	movzbl (%eax),%eax
 445:	3c 2b                	cmp    $0x2b,%al
 447:	74 0a                	je     453 <atoi+0x4a>
 449:	8b 45 08             	mov    0x8(%ebp),%eax
 44c:	0f b6 00             	movzbl (%eax),%eax
 44f:	3c 2d                	cmp    $0x2d,%al
 451:	75 2b                	jne    47e <atoi+0x75>
    s++;
 453:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 457:	eb 25                	jmp    47e <atoi+0x75>
    n = n*10 + *s++ - '0';
 459:	8b 55 fc             	mov    -0x4(%ebp),%edx
 45c:	89 d0                	mov    %edx,%eax
 45e:	c1 e0 02             	shl    $0x2,%eax
 461:	01 d0                	add    %edx,%eax
 463:	01 c0                	add    %eax,%eax
 465:	89 c1                	mov    %eax,%ecx
 467:	8b 45 08             	mov    0x8(%ebp),%eax
 46a:	8d 50 01             	lea    0x1(%eax),%edx
 46d:	89 55 08             	mov    %edx,0x8(%ebp)
 470:	0f b6 00             	movzbl (%eax),%eax
 473:	0f be c0             	movsbl %al,%eax
 476:	01 c8                	add    %ecx,%eax
 478:	83 e8 30             	sub    $0x30,%eax
 47b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 47e:	8b 45 08             	mov    0x8(%ebp),%eax
 481:	0f b6 00             	movzbl (%eax),%eax
 484:	3c 2f                	cmp    $0x2f,%al
 486:	7e 0a                	jle    492 <atoi+0x89>
 488:	8b 45 08             	mov    0x8(%ebp),%eax
 48b:	0f b6 00             	movzbl (%eax),%eax
 48e:	3c 39                	cmp    $0x39,%al
 490:	7e c7                	jle    459 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 492:	8b 45 f8             	mov    -0x8(%ebp),%eax
 495:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 499:	c9                   	leave  
 49a:	c3                   	ret    

0000049b <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 49b:	55                   	push   %ebp
 49c:	89 e5                	mov    %esp,%ebp
 49e:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 4a1:	8b 45 08             	mov    0x8(%ebp),%eax
 4a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 4a7:	8b 45 0c             	mov    0xc(%ebp),%eax
 4aa:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 4ad:	eb 17                	jmp    4c6 <memmove+0x2b>
    *dst++ = *src++;
 4af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4b2:	8d 50 01             	lea    0x1(%eax),%edx
 4b5:	89 55 fc             	mov    %edx,-0x4(%ebp)
 4b8:	8b 55 f8             	mov    -0x8(%ebp),%edx
 4bb:	8d 4a 01             	lea    0x1(%edx),%ecx
 4be:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 4c1:	0f b6 12             	movzbl (%edx),%edx
 4c4:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4c6:	8b 45 10             	mov    0x10(%ebp),%eax
 4c9:	8d 50 ff             	lea    -0x1(%eax),%edx
 4cc:	89 55 10             	mov    %edx,0x10(%ebp)
 4cf:	85 c0                	test   %eax,%eax
 4d1:	7f dc                	jg     4af <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 4d3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4d6:	c9                   	leave  
 4d7:	c3                   	ret    

000004d8 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4d8:	b8 01 00 00 00       	mov    $0x1,%eax
 4dd:	cd 40                	int    $0x40
 4df:	c3                   	ret    

000004e0 <exit>:
SYSCALL(exit)
 4e0:	b8 02 00 00 00       	mov    $0x2,%eax
 4e5:	cd 40                	int    $0x40
 4e7:	c3                   	ret    

000004e8 <wait>:
SYSCALL(wait)
 4e8:	b8 03 00 00 00       	mov    $0x3,%eax
 4ed:	cd 40                	int    $0x40
 4ef:	c3                   	ret    

000004f0 <pipe>:
SYSCALL(pipe)
 4f0:	b8 04 00 00 00       	mov    $0x4,%eax
 4f5:	cd 40                	int    $0x40
 4f7:	c3                   	ret    

000004f8 <read>:
SYSCALL(read)
 4f8:	b8 05 00 00 00       	mov    $0x5,%eax
 4fd:	cd 40                	int    $0x40
 4ff:	c3                   	ret    

00000500 <write>:
SYSCALL(write)
 500:	b8 10 00 00 00       	mov    $0x10,%eax
 505:	cd 40                	int    $0x40
 507:	c3                   	ret    

00000508 <close>:
SYSCALL(close)
 508:	b8 15 00 00 00       	mov    $0x15,%eax
 50d:	cd 40                	int    $0x40
 50f:	c3                   	ret    

00000510 <kill>:
SYSCALL(kill)
 510:	b8 06 00 00 00       	mov    $0x6,%eax
 515:	cd 40                	int    $0x40
 517:	c3                   	ret    

00000518 <exec>:
SYSCALL(exec)
 518:	b8 07 00 00 00       	mov    $0x7,%eax
 51d:	cd 40                	int    $0x40
 51f:	c3                   	ret    

00000520 <open>:
SYSCALL(open)
 520:	b8 0f 00 00 00       	mov    $0xf,%eax
 525:	cd 40                	int    $0x40
 527:	c3                   	ret    

00000528 <mknod>:
SYSCALL(mknod)
 528:	b8 11 00 00 00       	mov    $0x11,%eax
 52d:	cd 40                	int    $0x40
 52f:	c3                   	ret    

00000530 <unlink>:
SYSCALL(unlink)
 530:	b8 12 00 00 00       	mov    $0x12,%eax
 535:	cd 40                	int    $0x40
 537:	c3                   	ret    

00000538 <fstat>:
SYSCALL(fstat)
 538:	b8 08 00 00 00       	mov    $0x8,%eax
 53d:	cd 40                	int    $0x40
 53f:	c3                   	ret    

00000540 <link>:
SYSCALL(link)
 540:	b8 13 00 00 00       	mov    $0x13,%eax
 545:	cd 40                	int    $0x40
 547:	c3                   	ret    

00000548 <mkdir>:
SYSCALL(mkdir)
 548:	b8 14 00 00 00       	mov    $0x14,%eax
 54d:	cd 40                	int    $0x40
 54f:	c3                   	ret    

00000550 <chdir>:
SYSCALL(chdir)
 550:	b8 09 00 00 00       	mov    $0x9,%eax
 555:	cd 40                	int    $0x40
 557:	c3                   	ret    

00000558 <dup>:
SYSCALL(dup)
 558:	b8 0a 00 00 00       	mov    $0xa,%eax
 55d:	cd 40                	int    $0x40
 55f:	c3                   	ret    

00000560 <getpid>:
SYSCALL(getpid)
 560:	b8 0b 00 00 00       	mov    $0xb,%eax
 565:	cd 40                	int    $0x40
 567:	c3                   	ret    

00000568 <sbrk>:
SYSCALL(sbrk)
 568:	b8 0c 00 00 00       	mov    $0xc,%eax
 56d:	cd 40                	int    $0x40
 56f:	c3                   	ret    

00000570 <sleep>:
SYSCALL(sleep)
 570:	b8 0d 00 00 00       	mov    $0xd,%eax
 575:	cd 40                	int    $0x40
 577:	c3                   	ret    

00000578 <uptime>:
SYSCALL(uptime)
 578:	b8 0e 00 00 00       	mov    $0xe,%eax
 57d:	cd 40                	int    $0x40
 57f:	c3                   	ret    

00000580 <halt>:
SYSCALL(halt)
 580:	b8 16 00 00 00       	mov    $0x16,%eax
 585:	cd 40                	int    $0x40
 587:	c3                   	ret    

00000588 <date>:
SYSCALL(date)
 588:	b8 17 00 00 00       	mov    $0x17,%eax
 58d:	cd 40                	int    $0x40
 58f:	c3                   	ret    

00000590 <getuid>:
SYSCALL(getuid)
 590:	b8 18 00 00 00       	mov    $0x18,%eax
 595:	cd 40                	int    $0x40
 597:	c3                   	ret    

00000598 <getgid>:
SYSCALL(getgid)
 598:	b8 19 00 00 00       	mov    $0x19,%eax
 59d:	cd 40                	int    $0x40
 59f:	c3                   	ret    

000005a0 <getppid>:
SYSCALL(getppid)
 5a0:	b8 1a 00 00 00       	mov    $0x1a,%eax
 5a5:	cd 40                	int    $0x40
 5a7:	c3                   	ret    

000005a8 <setuid>:
SYSCALL(setuid)
 5a8:	b8 1b 00 00 00       	mov    $0x1b,%eax
 5ad:	cd 40                	int    $0x40
 5af:	c3                   	ret    

000005b0 <setgid>:
SYSCALL(setgid)
 5b0:	b8 1c 00 00 00       	mov    $0x1c,%eax
 5b5:	cd 40                	int    $0x40
 5b7:	c3                   	ret    

000005b8 <getprocs>:
SYSCALL(getprocs)
 5b8:	b8 1d 00 00 00       	mov    $0x1d,%eax
 5bd:	cd 40                	int    $0x40
 5bf:	c3                   	ret    

000005c0 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 5c0:	55                   	push   %ebp
 5c1:	89 e5                	mov    %esp,%ebp
 5c3:	83 ec 18             	sub    $0x18,%esp
 5c6:	8b 45 0c             	mov    0xc(%ebp),%eax
 5c9:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 5cc:	83 ec 04             	sub    $0x4,%esp
 5cf:	6a 01                	push   $0x1
 5d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
 5d4:	50                   	push   %eax
 5d5:	ff 75 08             	pushl  0x8(%ebp)
 5d8:	e8 23 ff ff ff       	call   500 <write>
 5dd:	83 c4 10             	add    $0x10,%esp
}
 5e0:	90                   	nop
 5e1:	c9                   	leave  
 5e2:	c3                   	ret    

000005e3 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5e3:	55                   	push   %ebp
 5e4:	89 e5                	mov    %esp,%ebp
 5e6:	53                   	push   %ebx
 5e7:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5ea:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 5f1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 5f5:	74 17                	je     60e <printint+0x2b>
 5f7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5fb:	79 11                	jns    60e <printint+0x2b>
    neg = 1;
 5fd:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 604:	8b 45 0c             	mov    0xc(%ebp),%eax
 607:	f7 d8                	neg    %eax
 609:	89 45 ec             	mov    %eax,-0x14(%ebp)
 60c:	eb 06                	jmp    614 <printint+0x31>
  } else {
    x = xx;
 60e:	8b 45 0c             	mov    0xc(%ebp),%eax
 611:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 614:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 61b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 61e:	8d 41 01             	lea    0x1(%ecx),%eax
 621:	89 45 f4             	mov    %eax,-0xc(%ebp)
 624:	8b 5d 10             	mov    0x10(%ebp),%ebx
 627:	8b 45 ec             	mov    -0x14(%ebp),%eax
 62a:	ba 00 00 00 00       	mov    $0x0,%edx
 62f:	f7 f3                	div    %ebx
 631:	89 d0                	mov    %edx,%eax
 633:	0f b6 80 60 0d 00 00 	movzbl 0xd60(%eax),%eax
 63a:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 63e:	8b 5d 10             	mov    0x10(%ebp),%ebx
 641:	8b 45 ec             	mov    -0x14(%ebp),%eax
 644:	ba 00 00 00 00       	mov    $0x0,%edx
 649:	f7 f3                	div    %ebx
 64b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 64e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 652:	75 c7                	jne    61b <printint+0x38>
  if(neg)
 654:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 658:	74 2d                	je     687 <printint+0xa4>
    buf[i++] = '-';
 65a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 65d:	8d 50 01             	lea    0x1(%eax),%edx
 660:	89 55 f4             	mov    %edx,-0xc(%ebp)
 663:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 668:	eb 1d                	jmp    687 <printint+0xa4>
    putc(fd, buf[i]);
 66a:	8d 55 dc             	lea    -0x24(%ebp),%edx
 66d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 670:	01 d0                	add    %edx,%eax
 672:	0f b6 00             	movzbl (%eax),%eax
 675:	0f be c0             	movsbl %al,%eax
 678:	83 ec 08             	sub    $0x8,%esp
 67b:	50                   	push   %eax
 67c:	ff 75 08             	pushl  0x8(%ebp)
 67f:	e8 3c ff ff ff       	call   5c0 <putc>
 684:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 687:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 68b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 68f:	79 d9                	jns    66a <printint+0x87>
    putc(fd, buf[i]);
}
 691:	90                   	nop
 692:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 695:	c9                   	leave  
 696:	c3                   	ret    

00000697 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 697:	55                   	push   %ebp
 698:	89 e5                	mov    %esp,%ebp
 69a:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 69d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 6a4:	8d 45 0c             	lea    0xc(%ebp),%eax
 6a7:	83 c0 04             	add    $0x4,%eax
 6aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 6ad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 6b4:	e9 59 01 00 00       	jmp    812 <printf+0x17b>
    c = fmt[i] & 0xff;
 6b9:	8b 55 0c             	mov    0xc(%ebp),%edx
 6bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6bf:	01 d0                	add    %edx,%eax
 6c1:	0f b6 00             	movzbl (%eax),%eax
 6c4:	0f be c0             	movsbl %al,%eax
 6c7:	25 ff 00 00 00       	and    $0xff,%eax
 6cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 6cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6d3:	75 2c                	jne    701 <printf+0x6a>
      if(c == '%'){
 6d5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6d9:	75 0c                	jne    6e7 <printf+0x50>
        state = '%';
 6db:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 6e2:	e9 27 01 00 00       	jmp    80e <printf+0x177>
      } else {
        putc(fd, c);
 6e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6ea:	0f be c0             	movsbl %al,%eax
 6ed:	83 ec 08             	sub    $0x8,%esp
 6f0:	50                   	push   %eax
 6f1:	ff 75 08             	pushl  0x8(%ebp)
 6f4:	e8 c7 fe ff ff       	call   5c0 <putc>
 6f9:	83 c4 10             	add    $0x10,%esp
 6fc:	e9 0d 01 00 00       	jmp    80e <printf+0x177>
      }
    } else if(state == '%'){
 701:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 705:	0f 85 03 01 00 00    	jne    80e <printf+0x177>
      if(c == 'd'){
 70b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 70f:	75 1e                	jne    72f <printf+0x98>
        printint(fd, *ap, 10, 1);
 711:	8b 45 e8             	mov    -0x18(%ebp),%eax
 714:	8b 00                	mov    (%eax),%eax
 716:	6a 01                	push   $0x1
 718:	6a 0a                	push   $0xa
 71a:	50                   	push   %eax
 71b:	ff 75 08             	pushl  0x8(%ebp)
 71e:	e8 c0 fe ff ff       	call   5e3 <printint>
 723:	83 c4 10             	add    $0x10,%esp
        ap++;
 726:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 72a:	e9 d8 00 00 00       	jmp    807 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 72f:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 733:	74 06                	je     73b <printf+0xa4>
 735:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 739:	75 1e                	jne    759 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 73b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 73e:	8b 00                	mov    (%eax),%eax
 740:	6a 00                	push   $0x0
 742:	6a 10                	push   $0x10
 744:	50                   	push   %eax
 745:	ff 75 08             	pushl  0x8(%ebp)
 748:	e8 96 fe ff ff       	call   5e3 <printint>
 74d:	83 c4 10             	add    $0x10,%esp
        ap++;
 750:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 754:	e9 ae 00 00 00       	jmp    807 <printf+0x170>
      } else if(c == 's'){
 759:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 75d:	75 43                	jne    7a2 <printf+0x10b>
        s = (char*)*ap;
 75f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 762:	8b 00                	mov    (%eax),%eax
 764:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 767:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 76b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 76f:	75 25                	jne    796 <printf+0xff>
          s = "(null)";
 771:	c7 45 f4 e5 0a 00 00 	movl   $0xae5,-0xc(%ebp)
        while(*s != 0){
 778:	eb 1c                	jmp    796 <printf+0xff>
          putc(fd, *s);
 77a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77d:	0f b6 00             	movzbl (%eax),%eax
 780:	0f be c0             	movsbl %al,%eax
 783:	83 ec 08             	sub    $0x8,%esp
 786:	50                   	push   %eax
 787:	ff 75 08             	pushl  0x8(%ebp)
 78a:	e8 31 fe ff ff       	call   5c0 <putc>
 78f:	83 c4 10             	add    $0x10,%esp
          s++;
 792:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 796:	8b 45 f4             	mov    -0xc(%ebp),%eax
 799:	0f b6 00             	movzbl (%eax),%eax
 79c:	84 c0                	test   %al,%al
 79e:	75 da                	jne    77a <printf+0xe3>
 7a0:	eb 65                	jmp    807 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7a2:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 7a6:	75 1d                	jne    7c5 <printf+0x12e>
        putc(fd, *ap);
 7a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7ab:	8b 00                	mov    (%eax),%eax
 7ad:	0f be c0             	movsbl %al,%eax
 7b0:	83 ec 08             	sub    $0x8,%esp
 7b3:	50                   	push   %eax
 7b4:	ff 75 08             	pushl  0x8(%ebp)
 7b7:	e8 04 fe ff ff       	call   5c0 <putc>
 7bc:	83 c4 10             	add    $0x10,%esp
        ap++;
 7bf:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7c3:	eb 42                	jmp    807 <printf+0x170>
      } else if(c == '%'){
 7c5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7c9:	75 17                	jne    7e2 <printf+0x14b>
        putc(fd, c);
 7cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7ce:	0f be c0             	movsbl %al,%eax
 7d1:	83 ec 08             	sub    $0x8,%esp
 7d4:	50                   	push   %eax
 7d5:	ff 75 08             	pushl  0x8(%ebp)
 7d8:	e8 e3 fd ff ff       	call   5c0 <putc>
 7dd:	83 c4 10             	add    $0x10,%esp
 7e0:	eb 25                	jmp    807 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7e2:	83 ec 08             	sub    $0x8,%esp
 7e5:	6a 25                	push   $0x25
 7e7:	ff 75 08             	pushl  0x8(%ebp)
 7ea:	e8 d1 fd ff ff       	call   5c0 <putc>
 7ef:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 7f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7f5:	0f be c0             	movsbl %al,%eax
 7f8:	83 ec 08             	sub    $0x8,%esp
 7fb:	50                   	push   %eax
 7fc:	ff 75 08             	pushl  0x8(%ebp)
 7ff:	e8 bc fd ff ff       	call   5c0 <putc>
 804:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 807:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 80e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 812:	8b 55 0c             	mov    0xc(%ebp),%edx
 815:	8b 45 f0             	mov    -0x10(%ebp),%eax
 818:	01 d0                	add    %edx,%eax
 81a:	0f b6 00             	movzbl (%eax),%eax
 81d:	84 c0                	test   %al,%al
 81f:	0f 85 94 fe ff ff    	jne    6b9 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 825:	90                   	nop
 826:	c9                   	leave  
 827:	c3                   	ret    

00000828 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 828:	55                   	push   %ebp
 829:	89 e5                	mov    %esp,%ebp
 82b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 82e:	8b 45 08             	mov    0x8(%ebp),%eax
 831:	83 e8 08             	sub    $0x8,%eax
 834:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 837:	a1 7c 0d 00 00       	mov    0xd7c,%eax
 83c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 83f:	eb 24                	jmp    865 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 841:	8b 45 fc             	mov    -0x4(%ebp),%eax
 844:	8b 00                	mov    (%eax),%eax
 846:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 849:	77 12                	ja     85d <free+0x35>
 84b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 84e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 851:	77 24                	ja     877 <free+0x4f>
 853:	8b 45 fc             	mov    -0x4(%ebp),%eax
 856:	8b 00                	mov    (%eax),%eax
 858:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 85b:	77 1a                	ja     877 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 85d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 860:	8b 00                	mov    (%eax),%eax
 862:	89 45 fc             	mov    %eax,-0x4(%ebp)
 865:	8b 45 f8             	mov    -0x8(%ebp),%eax
 868:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 86b:	76 d4                	jbe    841 <free+0x19>
 86d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 870:	8b 00                	mov    (%eax),%eax
 872:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 875:	76 ca                	jbe    841 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 877:	8b 45 f8             	mov    -0x8(%ebp),%eax
 87a:	8b 40 04             	mov    0x4(%eax),%eax
 87d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 884:	8b 45 f8             	mov    -0x8(%ebp),%eax
 887:	01 c2                	add    %eax,%edx
 889:	8b 45 fc             	mov    -0x4(%ebp),%eax
 88c:	8b 00                	mov    (%eax),%eax
 88e:	39 c2                	cmp    %eax,%edx
 890:	75 24                	jne    8b6 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 892:	8b 45 f8             	mov    -0x8(%ebp),%eax
 895:	8b 50 04             	mov    0x4(%eax),%edx
 898:	8b 45 fc             	mov    -0x4(%ebp),%eax
 89b:	8b 00                	mov    (%eax),%eax
 89d:	8b 40 04             	mov    0x4(%eax),%eax
 8a0:	01 c2                	add    %eax,%edx
 8a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8a5:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 8a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ab:	8b 00                	mov    (%eax),%eax
 8ad:	8b 10                	mov    (%eax),%edx
 8af:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8b2:	89 10                	mov    %edx,(%eax)
 8b4:	eb 0a                	jmp    8c0 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 8b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b9:	8b 10                	mov    (%eax),%edx
 8bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8be:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 8c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c3:	8b 40 04             	mov    0x4(%eax),%eax
 8c6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d0:	01 d0                	add    %edx,%eax
 8d2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8d5:	75 20                	jne    8f7 <free+0xcf>
    p->s.size += bp->s.size;
 8d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8da:	8b 50 04             	mov    0x4(%eax),%edx
 8dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8e0:	8b 40 04             	mov    0x4(%eax),%eax
 8e3:	01 c2                	add    %eax,%edx
 8e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e8:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ee:	8b 10                	mov    (%eax),%edx
 8f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f3:	89 10                	mov    %edx,(%eax)
 8f5:	eb 08                	jmp    8ff <free+0xd7>
  } else
    p->s.ptr = bp;
 8f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8fa:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8fd:	89 10                	mov    %edx,(%eax)
  freep = p;
 8ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 902:	a3 7c 0d 00 00       	mov    %eax,0xd7c
}
 907:	90                   	nop
 908:	c9                   	leave  
 909:	c3                   	ret    

0000090a <morecore>:

static Header*
morecore(uint nu)
{
 90a:	55                   	push   %ebp
 90b:	89 e5                	mov    %esp,%ebp
 90d:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 910:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 917:	77 07                	ja     920 <morecore+0x16>
    nu = 4096;
 919:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 920:	8b 45 08             	mov    0x8(%ebp),%eax
 923:	c1 e0 03             	shl    $0x3,%eax
 926:	83 ec 0c             	sub    $0xc,%esp
 929:	50                   	push   %eax
 92a:	e8 39 fc ff ff       	call   568 <sbrk>
 92f:	83 c4 10             	add    $0x10,%esp
 932:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 935:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 939:	75 07                	jne    942 <morecore+0x38>
    return 0;
 93b:	b8 00 00 00 00       	mov    $0x0,%eax
 940:	eb 26                	jmp    968 <morecore+0x5e>
  hp = (Header*)p;
 942:	8b 45 f4             	mov    -0xc(%ebp),%eax
 945:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 948:	8b 45 f0             	mov    -0x10(%ebp),%eax
 94b:	8b 55 08             	mov    0x8(%ebp),%edx
 94e:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 951:	8b 45 f0             	mov    -0x10(%ebp),%eax
 954:	83 c0 08             	add    $0x8,%eax
 957:	83 ec 0c             	sub    $0xc,%esp
 95a:	50                   	push   %eax
 95b:	e8 c8 fe ff ff       	call   828 <free>
 960:	83 c4 10             	add    $0x10,%esp
  return freep;
 963:	a1 7c 0d 00 00       	mov    0xd7c,%eax
}
 968:	c9                   	leave  
 969:	c3                   	ret    

0000096a <malloc>:

void*
malloc(uint nbytes)
{
 96a:	55                   	push   %ebp
 96b:	89 e5                	mov    %esp,%ebp
 96d:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 970:	8b 45 08             	mov    0x8(%ebp),%eax
 973:	83 c0 07             	add    $0x7,%eax
 976:	c1 e8 03             	shr    $0x3,%eax
 979:	83 c0 01             	add    $0x1,%eax
 97c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 97f:	a1 7c 0d 00 00       	mov    0xd7c,%eax
 984:	89 45 f0             	mov    %eax,-0x10(%ebp)
 987:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 98b:	75 23                	jne    9b0 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 98d:	c7 45 f0 74 0d 00 00 	movl   $0xd74,-0x10(%ebp)
 994:	8b 45 f0             	mov    -0x10(%ebp),%eax
 997:	a3 7c 0d 00 00       	mov    %eax,0xd7c
 99c:	a1 7c 0d 00 00       	mov    0xd7c,%eax
 9a1:	a3 74 0d 00 00       	mov    %eax,0xd74
    base.s.size = 0;
 9a6:	c7 05 78 0d 00 00 00 	movl   $0x0,0xd78
 9ad:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9b3:	8b 00                	mov    (%eax),%eax
 9b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9bb:	8b 40 04             	mov    0x4(%eax),%eax
 9be:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9c1:	72 4d                	jb     a10 <malloc+0xa6>
      if(p->s.size == nunits)
 9c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c6:	8b 40 04             	mov    0x4(%eax),%eax
 9c9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9cc:	75 0c                	jne    9da <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 9ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d1:	8b 10                	mov    (%eax),%edx
 9d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9d6:	89 10                	mov    %edx,(%eax)
 9d8:	eb 26                	jmp    a00 <malloc+0x96>
      else {
        p->s.size -= nunits;
 9da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9dd:	8b 40 04             	mov    0x4(%eax),%eax
 9e0:	2b 45 ec             	sub    -0x14(%ebp),%eax
 9e3:	89 c2                	mov    %eax,%edx
 9e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e8:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 9eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ee:	8b 40 04             	mov    0x4(%eax),%eax
 9f1:	c1 e0 03             	shl    $0x3,%eax
 9f4:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 9f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9fa:	8b 55 ec             	mov    -0x14(%ebp),%edx
 9fd:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a00:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a03:	a3 7c 0d 00 00       	mov    %eax,0xd7c
      return (void*)(p + 1);
 a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a0b:	83 c0 08             	add    $0x8,%eax
 a0e:	eb 3b                	jmp    a4b <malloc+0xe1>
    }
    if(p == freep)
 a10:	a1 7c 0d 00 00       	mov    0xd7c,%eax
 a15:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a18:	75 1e                	jne    a38 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a1a:	83 ec 0c             	sub    $0xc,%esp
 a1d:	ff 75 ec             	pushl  -0x14(%ebp)
 a20:	e8 e5 fe ff ff       	call   90a <morecore>
 a25:	83 c4 10             	add    $0x10,%esp
 a28:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a2f:	75 07                	jne    a38 <malloc+0xce>
        return 0;
 a31:	b8 00 00 00 00       	mov    $0x0,%eax
 a36:	eb 13                	jmp    a4b <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a41:	8b 00                	mov    (%eax),%eax
 a43:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a46:	e9 6d ff ff ff       	jmp    9b8 <malloc+0x4e>
}
 a4b:	c9                   	leave  
 a4c:	c3                   	ret    
