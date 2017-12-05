
_p5-test:     file format elf32-i386


Disassembly of section .text:

00000000 <canRun>:
#include "stat.h"
#include "p5-test.h"

static int
canRun(char *name)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 38             	sub    $0x38,%esp
  int rc, uid, gid;
  struct stat st;

  uid = getuid();
       6:	e8 98 14 00 00       	call   14a3 <getuid>
       b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  gid = getgid();
       e:	e8 98 14 00 00       	call   14ab <getgid>
      13:	89 45 f0             	mov    %eax,-0x10(%ebp)
  check(stat(name, &st));
      16:	83 ec 08             	sub    $0x8,%esp
      19:	8d 45 cc             	lea    -0x34(%ebp),%eax
      1c:	50                   	push   %eax
      1d:	ff 75 08             	pushl  0x8(%ebp)
      20:	e8 1c 12 00 00       	call   1241 <stat>
      25:	83 c4 10             	add    $0x10,%esp
      28:	89 45 ec             	mov    %eax,-0x14(%ebp)
      2b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
      2f:	74 21                	je     52 <canRun+0x52>
      31:	83 ec 04             	sub    $0x4,%esp
      34:	68 80 19 00 00       	push   $0x1980
      39:	68 90 19 00 00       	push   $0x1990
      3e:	6a 02                	push   $0x2
      40:	e8 85 15 00 00       	call   15ca <printf>
      45:	83 c4 10             	add    $0x10,%esp
      48:	b8 00 00 00 00       	mov    $0x0,%eax
      4d:	e9 93 00 00 00       	jmp    e5 <canRun+0xe5>
  if (uid == st.uid) {
      52:	8b 55 e0             	mov    -0x20(%ebp),%edx
      55:	8b 45 f4             	mov    -0xc(%ebp),%eax
      58:	39 c2                	cmp    %eax,%edx
      5a:	75 2b                	jne    87 <canRun+0x87>
    if (st.mode.flags.u_x)
      5c:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
      60:	83 e0 40             	and    $0x40,%eax
      63:	84 c0                	test   %al,%al
      65:	74 07                	je     6e <canRun+0x6e>
      return TRUE;
      67:	b8 01 00 00 00       	mov    $0x1,%eax
      6c:	eb 77                	jmp    e5 <canRun+0xe5>
    else {
      printf(2, "UID match. Execute permission for user not set.\n");
      6e:	83 ec 08             	sub    $0x8,%esp
      71:	68 a4 19 00 00       	push   $0x19a4
      76:	6a 02                	push   $0x2
      78:	e8 4d 15 00 00       	call   15ca <printf>
      7d:	83 c4 10             	add    $0x10,%esp
      return FALSE;
      80:	b8 00 00 00 00       	mov    $0x0,%eax
      85:	eb 5e                	jmp    e5 <canRun+0xe5>
    }
  }
  if (gid == st.gid) {
      87:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
      8d:	39 c2                	cmp    %eax,%edx
      8f:	75 2b                	jne    bc <canRun+0xbc>
    if (st.mode.flags.g_x)
      91:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
      95:	83 e0 08             	and    $0x8,%eax
      98:	84 c0                	test   %al,%al
      9a:	74 07                	je     a3 <canRun+0xa3>
      return TRUE;
      9c:	b8 01 00 00 00       	mov    $0x1,%eax
      a1:	eb 42                	jmp    e5 <canRun+0xe5>
    else {
      printf(2, "GID match. Execute permission for group not set.\n");
      a3:	83 ec 08             	sub    $0x8,%esp
      a6:	68 d8 19 00 00       	push   $0x19d8
      ab:	6a 02                	push   $0x2
      ad:	e8 18 15 00 00       	call   15ca <printf>
      b2:	83 c4 10             	add    $0x10,%esp
      return FALSE;
      b5:	b8 00 00 00 00       	mov    $0x0,%eax
      ba:	eb 29                	jmp    e5 <canRun+0xe5>
    }
  }
  if (st.mode.flags.o_x) {
      bc:	0f b6 45 e8          	movzbl -0x18(%ebp),%eax
      c0:	83 e0 01             	and    $0x1,%eax
      c3:	84 c0                	test   %al,%al
      c5:	74 07                	je     ce <canRun+0xce>
    return TRUE;
      c7:	b8 01 00 00 00       	mov    $0x1,%eax
      cc:	eb 17                	jmp    e5 <canRun+0xe5>
  }

  printf(2, "Execute permission for other not set.\n");
      ce:	83 ec 08             	sub    $0x8,%esp
      d1:	68 0c 1a 00 00       	push   $0x1a0c
      d6:	6a 02                	push   $0x2
      d8:	e8 ed 14 00 00       	call   15ca <printf>
      dd:	83 c4 10             	add    $0x10,%esp
  return FALSE;  // failure. Can't run
      e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
      e5:	c9                   	leave  
      e6:	c3                   	ret    

000000e7 <doSetuidTest>:

static int
doSetuidTest (char **cmd)
{
      e7:	55                   	push   %ebp
      e8:	89 e5                	mov    %esp,%ebp
      ea:	53                   	push   %ebx
      eb:	83 ec 24             	sub    $0x24,%esp
  int rc, i;
  char *test[] = {"UID match", "GID match", "Other", "Should Fail"};
      ee:	c7 45 e0 33 1a 00 00 	movl   $0x1a33,-0x20(%ebp)
      f5:	c7 45 e4 3d 1a 00 00 	movl   $0x1a3d,-0x1c(%ebp)
      fc:	c7 45 e8 47 1a 00 00 	movl   $0x1a47,-0x18(%ebp)
     103:	c7 45 ec 4d 1a 00 00 	movl   $0x1a4d,-0x14(%ebp)

  printf(1, "\nTesting the set uid bit.\n\n");
     10a:	83 ec 08             	sub    $0x8,%esp
     10d:	68 59 1a 00 00       	push   $0x1a59
     112:	6a 01                	push   $0x1
     114:	e8 b1 14 00 00       	call   15ca <printf>
     119:	83 c4 10             	add    $0x10,%esp

  for (i=0; i<NUMPERMSTOCHECK; i++) {
     11c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     123:	e9 71 02 00 00       	jmp    399 <doSetuidTest+0x2b2>
    printf(1, "Starting test: %s.\n", test[i]);
     128:	8b 45 f4             	mov    -0xc(%ebp),%eax
     12b:	8b 44 85 e0          	mov    -0x20(%ebp,%eax,4),%eax
     12f:	83 ec 04             	sub    $0x4,%esp
     132:	50                   	push   %eax
     133:	68 75 1a 00 00       	push   $0x1a75
     138:	6a 01                	push   $0x1
     13a:	e8 8b 14 00 00       	call   15ca <printf>
     13f:	83 c4 10             	add    $0x10,%esp
    check(setuid(testperms[i][procuid]));
     142:	8b 45 f4             	mov    -0xc(%ebp),%eax
     145:	c1 e0 04             	shl    $0x4,%eax
     148:	05 40 26 00 00       	add    $0x2640,%eax
     14d:	8b 00                	mov    (%eax),%eax
     14f:	83 ec 0c             	sub    $0xc,%esp
     152:	50                   	push   %eax
     153:	e8 63 13 00 00       	call   14bb <setuid>
     158:	83 c4 10             	add    $0x10,%esp
     15b:	89 45 f0             	mov    %eax,-0x10(%ebp)
     15e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     162:	74 21                	je     185 <doSetuidTest+0x9e>
     164:	83 ec 04             	sub    $0x4,%esp
     167:	68 89 1a 00 00       	push   $0x1a89
     16c:	68 90 19 00 00       	push   $0x1990
     171:	6a 02                	push   $0x2
     173:	e8 52 14 00 00       	call   15ca <printf>
     178:	83 c4 10             	add    $0x10,%esp
     17b:	b8 00 00 00 00       	mov    $0x0,%eax
     180:	e9 4f 02 00 00       	jmp    3d4 <doSetuidTest+0x2ed>
    check(setgid(testperms[i][procgid]));
     185:	8b 45 f4             	mov    -0xc(%ebp),%eax
     188:	c1 e0 04             	shl    $0x4,%eax
     18b:	05 44 26 00 00       	add    $0x2644,%eax
     190:	8b 00                	mov    (%eax),%eax
     192:	83 ec 0c             	sub    $0xc,%esp
     195:	50                   	push   %eax
     196:	e8 28 13 00 00       	call   14c3 <setgid>
     19b:	83 c4 10             	add    $0x10,%esp
     19e:	89 45 f0             	mov    %eax,-0x10(%ebp)
     1a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     1a5:	74 21                	je     1c8 <doSetuidTest+0xe1>
     1a7:	83 ec 04             	sub    $0x4,%esp
     1aa:	68 a7 1a 00 00       	push   $0x1aa7
     1af:	68 90 19 00 00       	push   $0x1990
     1b4:	6a 02                	push   $0x2
     1b6:	e8 0f 14 00 00       	call   15ca <printf>
     1bb:	83 c4 10             	add    $0x10,%esp
     1be:	b8 00 00 00 00       	mov    $0x0,%eax
     1c3:	e9 0c 02 00 00       	jmp    3d4 <doSetuidTest+0x2ed>
    printf(1, "Process uid: %d, gid: %d\n", getuid(), getgid());
     1c8:	e8 de 12 00 00       	call   14ab <getgid>
     1cd:	89 c3                	mov    %eax,%ebx
     1cf:	e8 cf 12 00 00       	call   14a3 <getuid>
     1d4:	53                   	push   %ebx
     1d5:	50                   	push   %eax
     1d6:	68 c5 1a 00 00       	push   $0x1ac5
     1db:	6a 01                	push   $0x1
     1dd:	e8 e8 13 00 00       	call   15ca <printf>
     1e2:	83 c4 10             	add    $0x10,%esp
    check(chown(cmd[0], testperms[i][fileuid]));
     1e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     1e8:	c1 e0 04             	shl    $0x4,%eax
     1eb:	05 48 26 00 00       	add    $0x2648,%eax
     1f0:	8b 10                	mov    (%eax),%edx
     1f2:	8b 45 08             	mov    0x8(%ebp),%eax
     1f5:	8b 00                	mov    (%eax),%eax
     1f7:	83 ec 08             	sub    $0x8,%esp
     1fa:	52                   	push   %edx
     1fb:	50                   	push   %eax
     1fc:	e8 e2 12 00 00       	call   14e3 <chown>
     201:	83 c4 10             	add    $0x10,%esp
     204:	89 45 f0             	mov    %eax,-0x10(%ebp)
     207:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     20b:	74 21                	je     22e <doSetuidTest+0x147>
     20d:	83 ec 04             	sub    $0x4,%esp
     210:	68 e0 1a 00 00       	push   $0x1ae0
     215:	68 90 19 00 00       	push   $0x1990
     21a:	6a 02                	push   $0x2
     21c:	e8 a9 13 00 00       	call   15ca <printf>
     221:	83 c4 10             	add    $0x10,%esp
     224:	b8 00 00 00 00       	mov    $0x0,%eax
     229:	e9 a6 01 00 00       	jmp    3d4 <doSetuidTest+0x2ed>
    check(chgrp(cmd[0], testperms[i][filegid]));
     22e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     231:	c1 e0 04             	shl    $0x4,%eax
     234:	05 4c 26 00 00       	add    $0x264c,%eax
     239:	8b 10                	mov    (%eax),%edx
     23b:	8b 45 08             	mov    0x8(%ebp),%eax
     23e:	8b 00                	mov    (%eax),%eax
     240:	83 ec 08             	sub    $0x8,%esp
     243:	52                   	push   %edx
     244:	50                   	push   %eax
     245:	e8 a1 12 00 00       	call   14eb <chgrp>
     24a:	83 c4 10             	add    $0x10,%esp
     24d:	89 45 f0             	mov    %eax,-0x10(%ebp)
     250:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     254:	74 21                	je     277 <doSetuidTest+0x190>
     256:	83 ec 04             	sub    $0x4,%esp
     259:	68 08 1b 00 00       	push   $0x1b08
     25e:	68 90 19 00 00       	push   $0x1990
     263:	6a 02                	push   $0x2
     265:	e8 60 13 00 00       	call   15ca <printf>
     26a:	83 c4 10             	add    $0x10,%esp
     26d:	b8 00 00 00 00       	mov    $0x0,%eax
     272:	e9 5d 01 00 00       	jmp    3d4 <doSetuidTest+0x2ed>
    printf(1, "File uid: %d, gid: %d\n",
     277:	8b 45 f4             	mov    -0xc(%ebp),%eax
     27a:	c1 e0 04             	shl    $0x4,%eax
     27d:	05 4c 26 00 00       	add    $0x264c,%eax
     282:	8b 10                	mov    (%eax),%edx
     284:	8b 45 f4             	mov    -0xc(%ebp),%eax
     287:	c1 e0 04             	shl    $0x4,%eax
     28a:	05 48 26 00 00       	add    $0x2648,%eax
     28f:	8b 00                	mov    (%eax),%eax
     291:	52                   	push   %edx
     292:	50                   	push   %eax
     293:	68 2d 1b 00 00       	push   $0x1b2d
     298:	6a 01                	push   $0x1
     29a:	e8 2b 13 00 00       	call   15ca <printf>
     29f:	83 c4 10             	add    $0x10,%esp
		    testperms[i][fileuid], testperms[i][filegid]);
    check(chmod(cmd[0], perms[i]));
     2a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     2a5:	8b 14 85 24 26 00 00 	mov    0x2624(,%eax,4),%edx
     2ac:	8b 45 08             	mov    0x8(%ebp),%eax
     2af:	8b 00                	mov    (%eax),%eax
     2b1:	83 ec 08             	sub    $0x8,%esp
     2b4:	52                   	push   %edx
     2b5:	50                   	push   %eax
     2b6:	e8 20 12 00 00       	call   14db <chmod>
     2bb:	83 c4 10             	add    $0x10,%esp
     2be:	89 45 f0             	mov    %eax,-0x10(%ebp)
     2c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     2c5:	74 21                	je     2e8 <doSetuidTest+0x201>
     2c7:	83 ec 04             	sub    $0x4,%esp
     2ca:	68 44 1b 00 00       	push   $0x1b44
     2cf:	68 90 19 00 00       	push   $0x1990
     2d4:	6a 02                	push   $0x2
     2d6:	e8 ef 12 00 00       	call   15ca <printf>
     2db:	83 c4 10             	add    $0x10,%esp
     2de:	b8 00 00 00 00       	mov    $0x0,%eax
     2e3:	e9 ec 00 00 00       	jmp    3d4 <doSetuidTest+0x2ed>
    printf(1, "perms set to %d for %s\n", perms[i], cmd[0]);
     2e8:	8b 45 08             	mov    0x8(%ebp),%eax
     2eb:	8b 10                	mov    (%eax),%edx
     2ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
     2f0:	8b 04 85 24 26 00 00 	mov    0x2624(,%eax,4),%eax
     2f7:	52                   	push   %edx
     2f8:	50                   	push   %eax
     2f9:	68 5c 1b 00 00       	push   $0x1b5c
     2fe:	6a 01                	push   $0x1
     300:	e8 c5 12 00 00       	call   15ca <printf>
     305:	83 c4 10             	add    $0x10,%esp

    rc = fork();
     308:	e8 de 10 00 00       	call   13eb <fork>
     30d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (rc < 0) {    // fork failed
     310:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     314:	79 1c                	jns    332 <doSetuidTest+0x24b>
      printf(2, "The fork() system call failed. That's pretty catastrophic. Ending test\n");
     316:	83 ec 08             	sub    $0x8,%esp
     319:	68 74 1b 00 00       	push   $0x1b74
     31e:	6a 02                	push   $0x2
     320:	e8 a5 12 00 00       	call   15ca <printf>
     325:	83 c4 10             	add    $0x10,%esp
      return NOPASS;
     328:	b8 00 00 00 00       	mov    $0x0,%eax
     32d:	e9 a2 00 00 00       	jmp    3d4 <doSetuidTest+0x2ed>
    }
    if (rc == 0) {   // child
     332:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     336:	75 58                	jne    390 <doSetuidTest+0x2a9>
      exec(cmd[0], cmd);
     338:	8b 45 08             	mov    0x8(%ebp),%eax
     33b:	8b 00                	mov    (%eax),%eax
     33d:	83 ec 08             	sub    $0x8,%esp
     340:	ff 75 08             	pushl  0x8(%ebp)
     343:	50                   	push   %eax
     344:	e8 e2 10 00 00       	call   142b <exec>
     349:	83 c4 10             	add    $0x10,%esp
      if (i != NUMPERMSTOCHECK-1) printf(2, "**** exec call for %s **FAILED**.\n",  cmd[0]);
     34c:	a1 20 26 00 00       	mov    0x2620,%eax
     351:	83 e8 01             	sub    $0x1,%eax
     354:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     357:	74 1a                	je     373 <doSetuidTest+0x28c>
     359:	8b 45 08             	mov    0x8(%ebp),%eax
     35c:	8b 00                	mov    (%eax),%eax
     35e:	83 ec 04             	sub    $0x4,%esp
     361:	50                   	push   %eax
     362:	68 bc 1b 00 00       	push   $0x1bbc
     367:	6a 02                	push   $0x2
     369:	e8 5c 12 00 00       	call   15ca <printf>
     36e:	83 c4 10             	add    $0x10,%esp
     371:	eb 18                	jmp    38b <doSetuidTest+0x2a4>
      else printf(2, "**** exec call for %s **FAILED as expected.\n", cmd[0]);
     373:	8b 45 08             	mov    0x8(%ebp),%eax
     376:	8b 00                	mov    (%eax),%eax
     378:	83 ec 04             	sub    $0x4,%esp
     37b:	50                   	push   %eax
     37c:	68 e0 1b 00 00       	push   $0x1be0
     381:	6a 02                	push   $0x2
     383:	e8 42 12 00 00       	call   15ca <printf>
     388:	83 c4 10             	add    $0x10,%esp
      exit();
     38b:	e8 63 10 00 00       	call   13f3 <exit>
    }
    wait();
     390:	e8 66 10 00 00       	call   13fb <wait>
  int rc, i;
  char *test[] = {"UID match", "GID match", "Other", "Should Fail"};

  printf(1, "\nTesting the set uid bit.\n\n");

  for (i=0; i<NUMPERMSTOCHECK; i++) {
     395:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     399:	a1 20 26 00 00       	mov    0x2620,%eax
     39e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     3a1:	0f 8c 81 fd ff ff    	jl     128 <doSetuidTest+0x41>
      else printf(2, "**** exec call for %s **FAILED as expected.\n", cmd[0]);
      exit();
    }
    wait();
  }
  chmod(cmd[0], 00755);  // total hack but necessary. sigh
     3a7:	8b 45 08             	mov    0x8(%ebp),%eax
     3aa:	8b 00                	mov    (%eax),%eax
     3ac:	83 ec 08             	sub    $0x8,%esp
     3af:	68 ed 01 00 00       	push   $0x1ed
     3b4:	50                   	push   %eax
     3b5:	e8 21 11 00 00       	call   14db <chmod>
     3ba:	83 c4 10             	add    $0x10,%esp
  printf(1, "Test Passed\n");
     3bd:	83 ec 08             	sub    $0x8,%esp
     3c0:	68 0d 1c 00 00       	push   $0x1c0d
     3c5:	6a 01                	push   $0x1
     3c7:	e8 fe 11 00 00       	call   15ca <printf>
     3cc:	83 c4 10             	add    $0x10,%esp
  return PASS;
     3cf:	b8 01 00 00 00       	mov    $0x1,%eax
}
     3d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     3d7:	c9                   	leave  
     3d8:	c3                   	ret    

000003d9 <doUidTest>:

static int
doUidTest (char **cmd)
{
     3d9:	55                   	push   %ebp
     3da:	89 e5                	mov    %esp,%ebp
     3dc:	83 ec 38             	sub    $0x38,%esp
  int i, rc, uid, startuid, testuid, baduidcount = 3;
     3df:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  int baduids[] = {32767+5, -41, ~0};  // 32767 is max value
     3e6:	c7 45 d4 04 80 00 00 	movl   $0x8004,-0x2c(%ebp)
     3ed:	c7 45 d8 d7 ff ff ff 	movl   $0xffffffd7,-0x28(%ebp)
     3f4:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)

  printf(1, "\nExecuting setuid() test.\n\n");
     3fb:	83 ec 08             	sub    $0x8,%esp
     3fe:	68 1a 1c 00 00       	push   $0x1c1a
     403:	6a 01                	push   $0x1
     405:	e8 c0 11 00 00       	call   15ca <printf>
     40a:	83 c4 10             	add    $0x10,%esp

  startuid = uid = getuid();
     40d:	e8 91 10 00 00       	call   14a3 <getuid>
     412:	89 45 ec             	mov    %eax,-0x14(%ebp)
     415:	8b 45 ec             	mov    -0x14(%ebp),%eax
     418:	89 45 e8             	mov    %eax,-0x18(%ebp)
  testuid = ++uid;
     41b:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
     41f:	8b 45 ec             	mov    -0x14(%ebp),%eax
     422:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  rc = setuid(testuid);
     425:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     428:	83 ec 0c             	sub    $0xc,%esp
     42b:	50                   	push   %eax
     42c:	e8 8a 10 00 00       	call   14bb <setuid>
     431:	83 c4 10             	add    $0x10,%esp
     434:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if (rc) {
     437:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     43b:	74 1c                	je     459 <doUidTest+0x80>
    printf(2, "setuid system call reports an error.\n");
     43d:	83 ec 08             	sub    $0x8,%esp
     440:	68 38 1c 00 00       	push   $0x1c38
     445:	6a 02                	push   $0x2
     447:	e8 7e 11 00 00       	call   15ca <printf>
     44c:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     44f:	b8 00 00 00 00       	mov    $0x0,%eax
     454:	e9 07 01 00 00       	jmp    560 <doUidTest+0x187>
  }
  uid = getuid();
     459:	e8 45 10 00 00       	call   14a3 <getuid>
     45e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if (uid != testuid) {
     461:	8b 45 ec             	mov    -0x14(%ebp),%eax
     464:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
     467:	74 31                	je     49a <doUidTest+0xc1>
    printf(2, "ERROR! setuid claims to have worked but really didn't!\n");
     469:	83 ec 08             	sub    $0x8,%esp
     46c:	68 60 1c 00 00       	push   $0x1c60
     471:	6a 02                	push   $0x2
     473:	e8 52 11 00 00       	call   15ca <printf>
     478:	83 c4 10             	add    $0x10,%esp
    printf(2, "uid should be %d but is instead %d\n", testuid, uid);
     47b:	ff 75 ec             	pushl  -0x14(%ebp)
     47e:	ff 75 e4             	pushl  -0x1c(%ebp)
     481:	68 98 1c 00 00       	push   $0x1c98
     486:	6a 02                	push   $0x2
     488:	e8 3d 11 00 00       	call   15ca <printf>
     48d:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     490:	b8 00 00 00 00       	mov    $0x0,%eax
     495:	e9 c6 00 00 00       	jmp    560 <doUidTest+0x187>
  }
  for (i=0; i<baduidcount; i++) {
     49a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     4a1:	e9 88 00 00 00       	jmp    52e <doUidTest+0x155>
    rc = setuid(baduids[i]);
     4a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4a9:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     4ad:	83 ec 0c             	sub    $0xc,%esp
     4b0:	50                   	push   %eax
     4b1:	e8 05 10 00 00       	call   14bb <setuid>
     4b6:	83 c4 10             	add    $0x10,%esp
     4b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (rc == 0) {
     4bc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     4c0:	75 21                	jne    4e3 <doUidTest+0x10a>
      printf(2, "Tried to set the uid to a bad value (%d) and setuid()failed to fail. rc == %d\n",
     4c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4c5:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     4c9:	ff 75 e0             	pushl  -0x20(%ebp)
     4cc:	50                   	push   %eax
     4cd:	68 bc 1c 00 00       	push   $0x1cbc
     4d2:	6a 02                	push   $0x2
     4d4:	e8 f1 10 00 00       	call   15ca <printf>
     4d9:	83 c4 10             	add    $0x10,%esp
                      baduids[i], rc);
      return NOPASS;
     4dc:	b8 00 00 00 00       	mov    $0x0,%eax
     4e1:	eb 7d                	jmp    560 <doUidTest+0x187>
    }
    rc = getuid();
     4e3:	e8 bb 0f 00 00       	call   14a3 <getuid>
     4e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (baduids[i] == rc) {
     4eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4ee:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     4f2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
     4f5:	75 33                	jne    52a <doUidTest+0x151>
      printf(2, "ERROR! Gave setuid() a bad value (%d) and it failed to fail. gid: %d\n",
     4f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4fa:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     4fe:	ff 75 e0             	pushl  -0x20(%ebp)
     501:	50                   	push   %eax
     502:	68 0c 1d 00 00       	push   $0x1d0c
     507:	6a 02                	push   $0x2
     509:	e8 bc 10 00 00       	call   15ca <printf>
     50e:	83 c4 10             	add    $0x10,%esp
		      baduids[i],rc);
      printf(2, "Valid UIDs are in the range [0, 32767] only!\n");
     511:	83 ec 08             	sub    $0x8,%esp
     514:	68 54 1d 00 00       	push   $0x1d54
     519:	6a 02                	push   $0x2
     51b:	e8 aa 10 00 00       	call   15ca <printf>
     520:	83 c4 10             	add    $0x10,%esp
      return NOPASS;
     523:	b8 00 00 00 00       	mov    $0x0,%eax
     528:	eb 36                	jmp    560 <doUidTest+0x187>
  if (uid != testuid) {
    printf(2, "ERROR! setuid claims to have worked but really didn't!\n");
    printf(2, "uid should be %d but is instead %d\n", testuid, uid);
    return NOPASS;
  }
  for (i=0; i<baduidcount; i++) {
     52a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     52e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     531:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     534:	0f 8c 6c ff ff ff    	jl     4a6 <doUidTest+0xcd>
		      baduids[i],rc);
      printf(2, "Valid UIDs are in the range [0, 32767] only!\n");
      return NOPASS;
    }
  }
  setuid(startuid);
     53a:	8b 45 e8             	mov    -0x18(%ebp),%eax
     53d:	83 ec 0c             	sub    $0xc,%esp
     540:	50                   	push   %eax
     541:	e8 75 0f 00 00       	call   14bb <setuid>
     546:	83 c4 10             	add    $0x10,%esp
  printf(1, "Test Passed\n");
     549:	83 ec 08             	sub    $0x8,%esp
     54c:	68 0d 1c 00 00       	push   $0x1c0d
     551:	6a 01                	push   $0x1
     553:	e8 72 10 00 00       	call   15ca <printf>
     558:	83 c4 10             	add    $0x10,%esp
  return PASS;
     55b:	b8 01 00 00 00       	mov    $0x1,%eax
}
     560:	c9                   	leave  
     561:	c3                   	ret    

00000562 <doGidTest>:

static int
doGidTest (char **cmd)
{
     562:	55                   	push   %ebp
     563:	89 e5                	mov    %esp,%ebp
     565:	83 ec 38             	sub    $0x38,%esp
  int i, rc, gid, startgid, testgid, badgidcount = 3;
     568:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  int badgids[] = {32767+5, -41, ~0};  // 32767 is max value
     56f:	c7 45 d4 04 80 00 00 	movl   $0x8004,-0x2c(%ebp)
     576:	c7 45 d8 d7 ff ff ff 	movl   $0xffffffd7,-0x28(%ebp)
     57d:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)

  printf(1, "\nExecuting setgid() test.\n\n");
     584:	83 ec 08             	sub    $0x8,%esp
     587:	68 82 1d 00 00       	push   $0x1d82
     58c:	6a 01                	push   $0x1
     58e:	e8 37 10 00 00       	call   15ca <printf>
     593:	83 c4 10             	add    $0x10,%esp

  startgid = gid = getgid();
     596:	e8 10 0f 00 00       	call   14ab <getgid>
     59b:	89 45 ec             	mov    %eax,-0x14(%ebp)
     59e:	8b 45 ec             	mov    -0x14(%ebp),%eax
     5a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  testgid = ++gid;
     5a4:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
     5a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
     5ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  rc = setgid(testgid);
     5ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     5b1:	83 ec 0c             	sub    $0xc,%esp
     5b4:	50                   	push   %eax
     5b5:	e8 09 0f 00 00       	call   14c3 <setgid>
     5ba:	83 c4 10             	add    $0x10,%esp
     5bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if (rc) {
     5c0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     5c4:	74 1c                	je     5e2 <doGidTest+0x80>
    printf(2, "setgid system call reports an error.\n");
     5c6:	83 ec 08             	sub    $0x8,%esp
     5c9:	68 a0 1d 00 00       	push   $0x1da0
     5ce:	6a 02                	push   $0x2
     5d0:	e8 f5 0f 00 00       	call   15ca <printf>
     5d5:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     5d8:	b8 00 00 00 00       	mov    $0x0,%eax
     5dd:	e9 07 01 00 00       	jmp    6e9 <doGidTest+0x187>
  }
  gid = getgid();
     5e2:	e8 c4 0e 00 00       	call   14ab <getgid>
     5e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if (gid != testgid) {
     5ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
     5ed:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
     5f0:	74 31                	je     623 <doGidTest+0xc1>
    printf(2, "ERROR! setgid claims to have worked but really didn't!\n");
     5f2:	83 ec 08             	sub    $0x8,%esp
     5f5:	68 c8 1d 00 00       	push   $0x1dc8
     5fa:	6a 02                	push   $0x2
     5fc:	e8 c9 0f 00 00       	call   15ca <printf>
     601:	83 c4 10             	add    $0x10,%esp
    printf(2, "gid should be %d but is instead %d\n", testgid, gid);
     604:	ff 75 ec             	pushl  -0x14(%ebp)
     607:	ff 75 e4             	pushl  -0x1c(%ebp)
     60a:	68 00 1e 00 00       	push   $0x1e00
     60f:	6a 02                	push   $0x2
     611:	e8 b4 0f 00 00       	call   15ca <printf>
     616:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     619:	b8 00 00 00 00       	mov    $0x0,%eax
     61e:	e9 c6 00 00 00       	jmp    6e9 <doGidTest+0x187>
  }
  for (i=0; i<badgidcount; i++) {
     623:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     62a:	e9 88 00 00 00       	jmp    6b7 <doGidTest+0x155>
    rc = setgid(badgids[i]); 
     62f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     632:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     636:	83 ec 0c             	sub    $0xc,%esp
     639:	50                   	push   %eax
     63a:	e8 84 0e 00 00       	call   14c3 <setgid>
     63f:	83 c4 10             	add    $0x10,%esp
     642:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (rc == 0) {
     645:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     649:	75 21                	jne    66c <doGidTest+0x10a>
      printf(2, "Tried to set the gid to a bad value (%d) and setgid()failed to fail. rc == %d\n",
     64b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     64e:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     652:	ff 75 e0             	pushl  -0x20(%ebp)
     655:	50                   	push   %eax
     656:	68 24 1e 00 00       	push   $0x1e24
     65b:	6a 02                	push   $0x2
     65d:	e8 68 0f 00 00       	call   15ca <printf>
     662:	83 c4 10             	add    $0x10,%esp
		      badgids[i], rc);
      return NOPASS;
     665:	b8 00 00 00 00       	mov    $0x0,%eax
     66a:	eb 7d                	jmp    6e9 <doGidTest+0x187>
    }
    rc = getgid();
     66c:	e8 3a 0e 00 00       	call   14ab <getgid>
     671:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (badgids[i] == rc) {
     674:	8b 45 f4             	mov    -0xc(%ebp),%eax
     677:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     67b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
     67e:	75 33                	jne    6b3 <doGidTest+0x151>
      printf(2, "ERROR! Gave setgid() a bad value (%d) and it failed to fail. gid: %d\n",
     680:	8b 45 f4             	mov    -0xc(%ebp),%eax
     683:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     687:	ff 75 e0             	pushl  -0x20(%ebp)
     68a:	50                   	push   %eax
     68b:	68 74 1e 00 00       	push   $0x1e74
     690:	6a 02                	push   $0x2
     692:	e8 33 0f 00 00       	call   15ca <printf>
     697:	83 c4 10             	add    $0x10,%esp
		      badgids[i], rc);
      printf(2, "Valid GIDs are in the range [0, 32767] only!\n");
     69a:	83 ec 08             	sub    $0x8,%esp
     69d:	68 bc 1e 00 00       	push   $0x1ebc
     6a2:	6a 02                	push   $0x2
     6a4:	e8 21 0f 00 00       	call   15ca <printf>
     6a9:	83 c4 10             	add    $0x10,%esp
      return NOPASS;
     6ac:	b8 00 00 00 00       	mov    $0x0,%eax
     6b1:	eb 36                	jmp    6e9 <doGidTest+0x187>
  if (gid != testgid) {
    printf(2, "ERROR! setgid claims to have worked but really didn't!\n");
    printf(2, "gid should be %d but is instead %d\n", testgid, gid);
    return NOPASS;
  }
  for (i=0; i<badgidcount; i++) {
     6b3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     6b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6ba:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     6bd:	0f 8c 6c ff ff ff    	jl     62f <doGidTest+0xcd>
		      badgids[i], rc);
      printf(2, "Valid GIDs are in the range [0, 32767] only!\n");
      return NOPASS;
    }
  }
  setgid(startgid);
     6c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
     6c6:	83 ec 0c             	sub    $0xc,%esp
     6c9:	50                   	push   %eax
     6ca:	e8 f4 0d 00 00       	call   14c3 <setgid>
     6cf:	83 c4 10             	add    $0x10,%esp
  printf(1, "Test Passed\n");
     6d2:	83 ec 08             	sub    $0x8,%esp
     6d5:	68 0d 1c 00 00       	push   $0x1c0d
     6da:	6a 01                	push   $0x1
     6dc:	e8 e9 0e 00 00       	call   15ca <printf>
     6e1:	83 c4 10             	add    $0x10,%esp
  return PASS;
     6e4:	b8 01 00 00 00       	mov    $0x1,%eax
}
     6e9:	c9                   	leave  
     6ea:	c3                   	ret    

000006eb <doChmodTest>:

static int
doChmodTest(char **cmd) 
{
     6eb:	55                   	push   %ebp
     6ec:	89 e5                	mov    %esp,%ebp
     6ee:	83 ec 38             	sub    $0x38,%esp
  int i, rc, mode, testmode;
  struct stat st;

  printf(1, "\nExecuting chmod() test.\n\n");
     6f1:	83 ec 08             	sub    $0x8,%esp
     6f4:	68 ea 1e 00 00       	push   $0x1eea
     6f9:	6a 01                	push   $0x1
     6fb:	e8 ca 0e 00 00       	call   15ca <printf>
     700:	83 c4 10             	add    $0x10,%esp

  check(stat(cmd[0], &st));
     703:	8b 45 08             	mov    0x8(%ebp),%eax
     706:	8b 00                	mov    (%eax),%eax
     708:	83 ec 08             	sub    $0x8,%esp
     70b:	8d 55 c8             	lea    -0x38(%ebp),%edx
     70e:	52                   	push   %edx
     70f:	50                   	push   %eax
     710:	e8 2c 0b 00 00       	call   1241 <stat>
     715:	83 c4 10             	add    $0x10,%esp
     718:	89 45 f0             	mov    %eax,-0x10(%ebp)
     71b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     71f:	74 21                	je     742 <doChmodTest+0x57>
     721:	83 ec 04             	sub    $0x4,%esp
     724:	68 05 1f 00 00       	push   $0x1f05
     729:	68 90 19 00 00       	push   $0x1990
     72e:	6a 02                	push   $0x2
     730:	e8 95 0e 00 00       	call   15ca <printf>
     735:	83 c4 10             	add    $0x10,%esp
     738:	b8 00 00 00 00       	mov    $0x0,%eax
     73d:	e9 1e 01 00 00       	jmp    860 <doChmodTest+0x175>
  mode = st.mode.asInt;
     742:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     745:	89 45 ec             	mov    %eax,-0x14(%ebp)

  for (i=0; i<NUMPERMSTOCHECK; i++) {
     748:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     74f:	e9 d1 00 00 00       	jmp    825 <doChmodTest+0x13a>
    check(chmod(cmd[0], perms[i]));
     754:	8b 45 f4             	mov    -0xc(%ebp),%eax
     757:	8b 14 85 24 26 00 00 	mov    0x2624(,%eax,4),%edx
     75e:	8b 45 08             	mov    0x8(%ebp),%eax
     761:	8b 00                	mov    (%eax),%eax
     763:	83 ec 08             	sub    $0x8,%esp
     766:	52                   	push   %edx
     767:	50                   	push   %eax
     768:	e8 6e 0d 00 00       	call   14db <chmod>
     76d:	83 c4 10             	add    $0x10,%esp
     770:	89 45 f0             	mov    %eax,-0x10(%ebp)
     773:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     777:	74 21                	je     79a <doChmodTest+0xaf>
     779:	83 ec 04             	sub    $0x4,%esp
     77c:	68 44 1b 00 00       	push   $0x1b44
     781:	68 90 19 00 00       	push   $0x1990
     786:	6a 02                	push   $0x2
     788:	e8 3d 0e 00 00       	call   15ca <printf>
     78d:	83 c4 10             	add    $0x10,%esp
     790:	b8 00 00 00 00       	mov    $0x0,%eax
     795:	e9 c6 00 00 00       	jmp    860 <doChmodTest+0x175>
    check(stat(cmd[0], &st));
     79a:	8b 45 08             	mov    0x8(%ebp),%eax
     79d:	8b 00                	mov    (%eax),%eax
     79f:	83 ec 08             	sub    $0x8,%esp
     7a2:	8d 55 c8             	lea    -0x38(%ebp),%edx
     7a5:	52                   	push   %edx
     7a6:	50                   	push   %eax
     7a7:	e8 95 0a 00 00       	call   1241 <stat>
     7ac:	83 c4 10             	add    $0x10,%esp
     7af:	89 45 f0             	mov    %eax,-0x10(%ebp)
     7b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     7b6:	74 21                	je     7d9 <doChmodTest+0xee>
     7b8:	83 ec 04             	sub    $0x4,%esp
     7bb:	68 05 1f 00 00       	push   $0x1f05
     7c0:	68 90 19 00 00       	push   $0x1990
     7c5:	6a 02                	push   $0x2
     7c7:	e8 fe 0d 00 00       	call   15ca <printf>
     7cc:	83 c4 10             	add    $0x10,%esp
     7cf:	b8 00 00 00 00       	mov    $0x0,%eax
     7d4:	e9 87 00 00 00       	jmp    860 <doChmodTest+0x175>
    testmode = st.mode.asInt;
     7d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     7dc:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if (mode == testmode) {
     7df:	8b 45 ec             	mov    -0x14(%ebp),%eax
     7e2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
     7e5:	75 3a                	jne    821 <doChmodTest+0x136>
      printf(2, "Error! Unable to test.\n");
     7e7:	83 ec 08             	sub    $0x8,%esp
     7ea:	68 17 1f 00 00       	push   $0x1f17
     7ef:	6a 02                	push   $0x2
     7f1:	e8 d4 0d 00 00       	call   15ca <printf>
     7f6:	83 c4 10             	add    $0x10,%esp
      printf(2, "\tfile mode (%d) == testmode (%d) for file (%s) in test %d\n",
     7f9:	8b 45 08             	mov    0x8(%ebp),%eax
     7fc:	8b 00                	mov    (%eax),%eax
     7fe:	83 ec 08             	sub    $0x8,%esp
     801:	ff 75 f4             	pushl  -0xc(%ebp)
     804:	50                   	push   %eax
     805:	ff 75 e8             	pushl  -0x18(%ebp)
     808:	ff 75 ec             	pushl  -0x14(%ebp)
     80b:	68 30 1f 00 00       	push   $0x1f30
     810:	6a 02                	push   $0x2
     812:	e8 b3 0d 00 00       	call   15ca <printf>
     817:	83 c4 20             	add    $0x20,%esp
		     mode, testmode, cmd[0], i);
      return NOPASS;
     81a:	b8 00 00 00 00       	mov    $0x0,%eax
     81f:	eb 3f                	jmp    860 <doChmodTest+0x175>
  printf(1, "\nExecuting chmod() test.\n\n");

  check(stat(cmd[0], &st));
  mode = st.mode.asInt;

  for (i=0; i<NUMPERMSTOCHECK; i++) {
     821:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     825:	a1 20 26 00 00       	mov    0x2620,%eax
     82a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     82d:	0f 8c 21 ff ff ff    	jl     754 <doChmodTest+0x69>
      printf(2, "\tfile mode (%d) == testmode (%d) for file (%s) in test %d\n",
		     mode, testmode, cmd[0], i);
      return NOPASS;
    }
  }
  chmod(cmd[0], 00755); // hack
     833:	8b 45 08             	mov    0x8(%ebp),%eax
     836:	8b 00                	mov    (%eax),%eax
     838:	83 ec 08             	sub    $0x8,%esp
     83b:	68 ed 01 00 00       	push   $0x1ed
     840:	50                   	push   %eax
     841:	e8 95 0c 00 00       	call   14db <chmod>
     846:	83 c4 10             	add    $0x10,%esp
  printf(1, "Test Passed\n");
     849:	83 ec 08             	sub    $0x8,%esp
     84c:	68 0d 1c 00 00       	push   $0x1c0d
     851:	6a 01                	push   $0x1
     853:	e8 72 0d 00 00       	call   15ca <printf>
     858:	83 c4 10             	add    $0x10,%esp
  return PASS;
     85b:	b8 01 00 00 00       	mov    $0x1,%eax
}
     860:	c9                   	leave  
     861:	c3                   	ret    

00000862 <doChownTest>:

static int
doChownTest(char **cmd) 
{
     862:	55                   	push   %ebp
     863:	89 e5                	mov    %esp,%ebp
     865:	83 ec 38             	sub    $0x38,%esp
  int rc, uid1, uid2;
  struct stat st;

  printf(1, "\nExecuting chown test.\n\n");
     868:	83 ec 08             	sub    $0x8,%esp
     86b:	68 6b 1f 00 00       	push   $0x1f6b
     870:	6a 01                	push   $0x1
     872:	e8 53 0d 00 00       	call   15ca <printf>
     877:	83 c4 10             	add    $0x10,%esp

  stat(cmd[0], &st);
     87a:	8b 45 08             	mov    0x8(%ebp),%eax
     87d:	8b 00                	mov    (%eax),%eax
     87f:	83 ec 08             	sub    $0x8,%esp
     882:	8d 55 cc             	lea    -0x34(%ebp),%edx
     885:	52                   	push   %edx
     886:	50                   	push   %eax
     887:	e8 b5 09 00 00       	call   1241 <stat>
     88c:	83 c4 10             	add    $0x10,%esp
  uid1 = st.uid;
     88f:	8b 45 e0             	mov    -0x20(%ebp),%eax
     892:	89 45 f4             	mov    %eax,-0xc(%ebp)

  rc = chown(cmd[0], uid1+1);
     895:	8b 45 f4             	mov    -0xc(%ebp),%eax
     898:	8d 50 01             	lea    0x1(%eax),%edx
     89b:	8b 45 08             	mov    0x8(%ebp),%eax
     89e:	8b 00                	mov    (%eax),%eax
     8a0:	83 ec 08             	sub    $0x8,%esp
     8a3:	52                   	push   %edx
     8a4:	50                   	push   %eax
     8a5:	e8 39 0c 00 00       	call   14e3 <chown>
     8aa:	83 c4 10             	add    $0x10,%esp
     8ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if (rc != 0) {
     8b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     8b4:	74 1c                	je     8d2 <doChownTest+0x70>
    printf(2, "Error! chown() failed on setting new owner. %d as rc.\n", rc);
     8b6:	83 ec 04             	sub    $0x4,%esp
     8b9:	ff 75 f0             	pushl  -0x10(%ebp)
     8bc:	68 84 1f 00 00       	push   $0x1f84
     8c1:	6a 02                	push   $0x2
     8c3:	e8 02 0d 00 00       	call   15ca <printf>
     8c8:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     8cb:	b8 00 00 00 00       	mov    $0x0,%eax
     8d0:	eb 6a                	jmp    93c <doChownTest+0xda>
  }

  stat(cmd[0], &st);
     8d2:	8b 45 08             	mov    0x8(%ebp),%eax
     8d5:	8b 00                	mov    (%eax),%eax
     8d7:	83 ec 08             	sub    $0x8,%esp
     8da:	8d 55 cc             	lea    -0x34(%ebp),%edx
     8dd:	52                   	push   %edx
     8de:	50                   	push   %eax
     8df:	e8 5d 09 00 00       	call   1241 <stat>
     8e4:	83 c4 10             	add    $0x10,%esp
  uid2 = st.uid;
     8e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
     8ea:	89 45 ec             	mov    %eax,-0x14(%ebp)

  if (uid1 == uid2) {
     8ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8f0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     8f3:	75 1c                	jne    911 <doChownTest+0xaf>
    printf(2, "Error! test failed. Old uid: %d, new uid: uid2, should differ\n",
     8f5:	ff 75 ec             	pushl  -0x14(%ebp)
     8f8:	ff 75 f4             	pushl  -0xc(%ebp)
     8fb:	68 bc 1f 00 00       	push   $0x1fbc
     900:	6a 02                	push   $0x2
     902:	e8 c3 0c 00 00       	call   15ca <printf>
     907:	83 c4 10             	add    $0x10,%esp
		    uid1, uid2);
    return NOPASS;
     90a:	b8 00 00 00 00       	mov    $0x0,%eax
     90f:	eb 2b                	jmp    93c <doChownTest+0xda>
  }
  chown(cmd[0], uid1);  // put back the original
     911:	8b 45 08             	mov    0x8(%ebp),%eax
     914:	8b 00                	mov    (%eax),%eax
     916:	83 ec 08             	sub    $0x8,%esp
     919:	ff 75 f4             	pushl  -0xc(%ebp)
     91c:	50                   	push   %eax
     91d:	e8 c1 0b 00 00       	call   14e3 <chown>
     922:	83 c4 10             	add    $0x10,%esp
  printf(1, "Test Passed\n");
     925:	83 ec 08             	sub    $0x8,%esp
     928:	68 0d 1c 00 00       	push   $0x1c0d
     92d:	6a 01                	push   $0x1
     92f:	e8 96 0c 00 00       	call   15ca <printf>
     934:	83 c4 10             	add    $0x10,%esp
  return PASS;
     937:	b8 01 00 00 00       	mov    $0x1,%eax
}
     93c:	c9                   	leave  
     93d:	c3                   	ret    

0000093e <doChgrpTest>:

static int
doChgrpTest(char **cmd) 
{
     93e:	55                   	push   %ebp
     93f:	89 e5                	mov    %esp,%ebp
     941:	83 ec 38             	sub    $0x38,%esp
  int rc, gid1, gid2;
  struct stat st;

  printf(1, "\nExecuting chgrp test.\n\n");
     944:	83 ec 08             	sub    $0x8,%esp
     947:	68 fb 1f 00 00       	push   $0x1ffb
     94c:	6a 01                	push   $0x1
     94e:	e8 77 0c 00 00       	call   15ca <printf>
     953:	83 c4 10             	add    $0x10,%esp

  stat(cmd[0], &st);
     956:	8b 45 08             	mov    0x8(%ebp),%eax
     959:	8b 00                	mov    (%eax),%eax
     95b:	83 ec 08             	sub    $0x8,%esp
     95e:	8d 55 cc             	lea    -0x34(%ebp),%edx
     961:	52                   	push   %edx
     962:	50                   	push   %eax
     963:	e8 d9 08 00 00       	call   1241 <stat>
     968:	83 c4 10             	add    $0x10,%esp
  gid1 = st.gid;
     96b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     96e:	89 45 f4             	mov    %eax,-0xc(%ebp)

  rc = chgrp(cmd[0], gid1+1);
     971:	8b 45 f4             	mov    -0xc(%ebp),%eax
     974:	8d 50 01             	lea    0x1(%eax),%edx
     977:	8b 45 08             	mov    0x8(%ebp),%eax
     97a:	8b 00                	mov    (%eax),%eax
     97c:	83 ec 08             	sub    $0x8,%esp
     97f:	52                   	push   %edx
     980:	50                   	push   %eax
     981:	e8 65 0b 00 00       	call   14eb <chgrp>
     986:	83 c4 10             	add    $0x10,%esp
     989:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if (rc != 0) {
     98c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     990:	74 19                	je     9ab <doChgrpTest+0x6d>
    printf(2, "Error! chgrp() failed on setting new group.\n");
     992:	83 ec 08             	sub    $0x8,%esp
     995:	68 14 20 00 00       	push   $0x2014
     99a:	6a 02                	push   $0x2
     99c:	e8 29 0c 00 00       	call   15ca <printf>
     9a1:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     9a4:	b8 00 00 00 00       	mov    $0x0,%eax
     9a9:	eb 6a                	jmp    a15 <doChgrpTest+0xd7>
  }

  stat(cmd[0], &st);
     9ab:	8b 45 08             	mov    0x8(%ebp),%eax
     9ae:	8b 00                	mov    (%eax),%eax
     9b0:	83 ec 08             	sub    $0x8,%esp
     9b3:	8d 55 cc             	lea    -0x34(%ebp),%edx
     9b6:	52                   	push   %edx
     9b7:	50                   	push   %eax
     9b8:	e8 84 08 00 00       	call   1241 <stat>
     9bd:	83 c4 10             	add    $0x10,%esp
  gid2 = st.gid;
     9c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     9c3:	89 45 ec             	mov    %eax,-0x14(%ebp)

  if (gid1 == gid2) {
     9c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9c9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     9cc:	75 1c                	jne    9ea <doChgrpTest+0xac>
    printf(2, "Error! test failed. Old gid: %d, new gid: gid2, should differ\n",
     9ce:	ff 75 ec             	pushl  -0x14(%ebp)
     9d1:	ff 75 f4             	pushl  -0xc(%ebp)
     9d4:	68 44 20 00 00       	push   $0x2044
     9d9:	6a 02                	push   $0x2
     9db:	e8 ea 0b 00 00       	call   15ca <printf>
     9e0:	83 c4 10             	add    $0x10,%esp
                    gid1, gid2);
    return NOPASS;
     9e3:	b8 00 00 00 00       	mov    $0x0,%eax
     9e8:	eb 2b                	jmp    a15 <doChgrpTest+0xd7>
  }
  chgrp(cmd[0], gid1);  // put back the original
     9ea:	8b 45 08             	mov    0x8(%ebp),%eax
     9ed:	8b 00                	mov    (%eax),%eax
     9ef:	83 ec 08             	sub    $0x8,%esp
     9f2:	ff 75 f4             	pushl  -0xc(%ebp)
     9f5:	50                   	push   %eax
     9f6:	e8 f0 0a 00 00       	call   14eb <chgrp>
     9fb:	83 c4 10             	add    $0x10,%esp
  printf(1, "Test Passed\n");
     9fe:	83 ec 08             	sub    $0x8,%esp
     a01:	68 0d 1c 00 00       	push   $0x1c0d
     a06:	6a 01                	push   $0x1
     a08:	e8 bd 0b 00 00       	call   15ca <printf>
     a0d:	83 c4 10             	add    $0x10,%esp
  return PASS;
     a10:	b8 01 00 00 00       	mov    $0x1,%eax
}
     a15:	c9                   	leave  
     a16:	c3                   	ret    

00000a17 <doExecTest>:

static int
doExecTest(char **cmd) 
{
     a17:	55                   	push   %ebp
     a18:	89 e5                	mov    %esp,%ebp
     a1a:	83 ec 38             	sub    $0x38,%esp
  int i, rc, uid, gid;
  struct stat st;

  printf(1, "\nExecuting exec test.\n\n");
     a1d:	83 ec 08             	sub    $0x8,%esp
     a20:	68 83 20 00 00       	push   $0x2083
     a25:	6a 01                	push   $0x1
     a27:	e8 9e 0b 00 00       	call   15ca <printf>
     a2c:	83 c4 10             	add    $0x10,%esp

  if (!canRun(cmd[0])) {
     a2f:	8b 45 08             	mov    0x8(%ebp),%eax
     a32:	8b 00                	mov    (%eax),%eax
     a34:	83 ec 0c             	sub    $0xc,%esp
     a37:	50                   	push   %eax
     a38:	e8 c3 f5 ff ff       	call   0 <canRun>
     a3d:	83 c4 10             	add    $0x10,%esp
     a40:	85 c0                	test   %eax,%eax
     a42:	75 22                	jne    a66 <doExecTest+0x4f>
    printf(2, "Unable to run %s. test aborted.\n", cmd[0]);
     a44:	8b 45 08             	mov    0x8(%ebp),%eax
     a47:	8b 00                	mov    (%eax),%eax
     a49:	83 ec 04             	sub    $0x4,%esp
     a4c:	50                   	push   %eax
     a4d:	68 9c 20 00 00       	push   $0x209c
     a52:	6a 02                	push   $0x2
     a54:	e8 71 0b 00 00       	call   15ca <printf>
     a59:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     a5c:	b8 00 00 00 00       	mov    $0x0,%eax
     a61:	e9 dc 02 00 00       	jmp    d42 <doExecTest+0x32b>
  }

  check(stat(cmd[0], &st));
     a66:	8b 45 08             	mov    0x8(%ebp),%eax
     a69:	8b 00                	mov    (%eax),%eax
     a6b:	83 ec 08             	sub    $0x8,%esp
     a6e:	8d 55 c8             	lea    -0x38(%ebp),%edx
     a71:	52                   	push   %edx
     a72:	50                   	push   %eax
     a73:	e8 c9 07 00 00       	call   1241 <stat>
     a78:	83 c4 10             	add    $0x10,%esp
     a7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
     a7e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     a82:	74 21                	je     aa5 <doExecTest+0x8e>
     a84:	83 ec 04             	sub    $0x4,%esp
     a87:	68 05 1f 00 00       	push   $0x1f05
     a8c:	68 90 19 00 00       	push   $0x1990
     a91:	6a 02                	push   $0x2
     a93:	e8 32 0b 00 00       	call   15ca <printf>
     a98:	83 c4 10             	add    $0x10,%esp
     a9b:	b8 00 00 00 00       	mov    $0x0,%eax
     aa0:	e9 9d 02 00 00       	jmp    d42 <doExecTest+0x32b>
  uid = st.uid;
     aa5:	8b 45 dc             	mov    -0x24(%ebp),%eax
     aa8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  gid = st.gid;
     aab:	8b 45 e0             	mov    -0x20(%ebp),%eax
     aae:	89 45 e8             	mov    %eax,-0x18(%ebp)

  for (i=0; i<NUMPERMSTOCHECK; i++) {
     ab1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     ab8:	e9 22 02 00 00       	jmp    cdf <doExecTest+0x2c8>
    check(setuid(testperms[i][procuid]));
     abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ac0:	c1 e0 04             	shl    $0x4,%eax
     ac3:	05 40 26 00 00       	add    $0x2640,%eax
     ac8:	8b 00                	mov    (%eax),%eax
     aca:	83 ec 0c             	sub    $0xc,%esp
     acd:	50                   	push   %eax
     ace:	e8 e8 09 00 00       	call   14bb <setuid>
     ad3:	83 c4 10             	add    $0x10,%esp
     ad6:	89 45 f0             	mov    %eax,-0x10(%ebp)
     ad9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     add:	74 21                	je     b00 <doExecTest+0xe9>
     adf:	83 ec 04             	sub    $0x4,%esp
     ae2:	68 89 1a 00 00       	push   $0x1a89
     ae7:	68 90 19 00 00       	push   $0x1990
     aec:	6a 02                	push   $0x2
     aee:	e8 d7 0a 00 00       	call   15ca <printf>
     af3:	83 c4 10             	add    $0x10,%esp
     af6:	b8 00 00 00 00       	mov    $0x0,%eax
     afb:	e9 42 02 00 00       	jmp    d42 <doExecTest+0x32b>
    check(setgid(testperms[i][procgid]));
     b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b03:	c1 e0 04             	shl    $0x4,%eax
     b06:	05 44 26 00 00       	add    $0x2644,%eax
     b0b:	8b 00                	mov    (%eax),%eax
     b0d:	83 ec 0c             	sub    $0xc,%esp
     b10:	50                   	push   %eax
     b11:	e8 ad 09 00 00       	call   14c3 <setgid>
     b16:	83 c4 10             	add    $0x10,%esp
     b19:	89 45 f0             	mov    %eax,-0x10(%ebp)
     b1c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     b20:	74 21                	je     b43 <doExecTest+0x12c>
     b22:	83 ec 04             	sub    $0x4,%esp
     b25:	68 a7 1a 00 00       	push   $0x1aa7
     b2a:	68 90 19 00 00       	push   $0x1990
     b2f:	6a 02                	push   $0x2
     b31:	e8 94 0a 00 00       	call   15ca <printf>
     b36:	83 c4 10             	add    $0x10,%esp
     b39:	b8 00 00 00 00       	mov    $0x0,%eax
     b3e:	e9 ff 01 00 00       	jmp    d42 <doExecTest+0x32b>
    check(chown(cmd[0], testperms[i][fileuid]));
     b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b46:	c1 e0 04             	shl    $0x4,%eax
     b49:	05 48 26 00 00       	add    $0x2648,%eax
     b4e:	8b 10                	mov    (%eax),%edx
     b50:	8b 45 08             	mov    0x8(%ebp),%eax
     b53:	8b 00                	mov    (%eax),%eax
     b55:	83 ec 08             	sub    $0x8,%esp
     b58:	52                   	push   %edx
     b59:	50                   	push   %eax
     b5a:	e8 84 09 00 00       	call   14e3 <chown>
     b5f:	83 c4 10             	add    $0x10,%esp
     b62:	89 45 f0             	mov    %eax,-0x10(%ebp)
     b65:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     b69:	74 21                	je     b8c <doExecTest+0x175>
     b6b:	83 ec 04             	sub    $0x4,%esp
     b6e:	68 e0 1a 00 00       	push   $0x1ae0
     b73:	68 90 19 00 00       	push   $0x1990
     b78:	6a 02                	push   $0x2
     b7a:	e8 4b 0a 00 00       	call   15ca <printf>
     b7f:	83 c4 10             	add    $0x10,%esp
     b82:	b8 00 00 00 00       	mov    $0x0,%eax
     b87:	e9 b6 01 00 00       	jmp    d42 <doExecTest+0x32b>
    check(chgrp(cmd[0], testperms[i][filegid]));
     b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b8f:	c1 e0 04             	shl    $0x4,%eax
     b92:	05 4c 26 00 00       	add    $0x264c,%eax
     b97:	8b 10                	mov    (%eax),%edx
     b99:	8b 45 08             	mov    0x8(%ebp),%eax
     b9c:	8b 00                	mov    (%eax),%eax
     b9e:	83 ec 08             	sub    $0x8,%esp
     ba1:	52                   	push   %edx
     ba2:	50                   	push   %eax
     ba3:	e8 43 09 00 00       	call   14eb <chgrp>
     ba8:	83 c4 10             	add    $0x10,%esp
     bab:	89 45 f0             	mov    %eax,-0x10(%ebp)
     bae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     bb2:	74 21                	je     bd5 <doExecTest+0x1be>
     bb4:	83 ec 04             	sub    $0x4,%esp
     bb7:	68 08 1b 00 00       	push   $0x1b08
     bbc:	68 90 19 00 00       	push   $0x1990
     bc1:	6a 02                	push   $0x2
     bc3:	e8 02 0a 00 00       	call   15ca <printf>
     bc8:	83 c4 10             	add    $0x10,%esp
     bcb:	b8 00 00 00 00       	mov    $0x0,%eax
     bd0:	e9 6d 01 00 00       	jmp    d42 <doExecTest+0x32b>
    check(chmod(cmd[0], perms[i]));
     bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     bd8:	8b 14 85 24 26 00 00 	mov    0x2624(,%eax,4),%edx
     bdf:	8b 45 08             	mov    0x8(%ebp),%eax
     be2:	8b 00                	mov    (%eax),%eax
     be4:	83 ec 08             	sub    $0x8,%esp
     be7:	52                   	push   %edx
     be8:	50                   	push   %eax
     be9:	e8 ed 08 00 00       	call   14db <chmod>
     bee:	83 c4 10             	add    $0x10,%esp
     bf1:	89 45 f0             	mov    %eax,-0x10(%ebp)
     bf4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     bf8:	74 21                	je     c1b <doExecTest+0x204>
     bfa:	83 ec 04             	sub    $0x4,%esp
     bfd:	68 44 1b 00 00       	push   $0x1b44
     c02:	68 90 19 00 00       	push   $0x1990
     c07:	6a 02                	push   $0x2
     c09:	e8 bc 09 00 00       	call   15ca <printf>
     c0e:	83 c4 10             	add    $0x10,%esp
     c11:	b8 00 00 00 00       	mov    $0x0,%eax
     c16:	e9 27 01 00 00       	jmp    d42 <doExecTest+0x32b>
    if (i != NUMPERMSTOCHECK-1)
     c1b:	a1 20 26 00 00       	mov    0x2620,%eax
     c20:	83 e8 01             	sub    $0x1,%eax
     c23:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     c26:	74 14                	je     c3c <doExecTest+0x225>
      printf(2, "The following test should not produce an error.\n");
     c28:	83 ec 08             	sub    $0x8,%esp
     c2b:	68 c0 20 00 00       	push   $0x20c0
     c30:	6a 02                	push   $0x2
     c32:	e8 93 09 00 00       	call   15ca <printf>
     c37:	83 c4 10             	add    $0x10,%esp
     c3a:	eb 12                	jmp    c4e <doExecTest+0x237>
    else
      printf(2, "The following test should fail.\n");
     c3c:	83 ec 08             	sub    $0x8,%esp
     c3f:	68 f4 20 00 00       	push   $0x20f4
     c44:	6a 02                	push   $0x2
     c46:	e8 7f 09 00 00       	call   15ca <printf>
     c4b:	83 c4 10             	add    $0x10,%esp
    rc = fork();
     c4e:	e8 98 07 00 00       	call   13eb <fork>
     c53:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (rc < 0) {    // fork failed
     c56:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     c5a:	79 1c                	jns    c78 <doExecTest+0x261>
      printf(2, "The fork() system call failed. That's pretty catastrophic. Ending test\n");
     c5c:	83 ec 08             	sub    $0x8,%esp
     c5f:	68 74 1b 00 00       	push   $0x1b74
     c64:	6a 02                	push   $0x2
     c66:	e8 5f 09 00 00       	call   15ca <printf>
     c6b:	83 c4 10             	add    $0x10,%esp
      return NOPASS;
     c6e:	b8 00 00 00 00       	mov    $0x0,%eax
     c73:	e9 ca 00 00 00       	jmp    d42 <doExecTest+0x32b>
    }
    if (rc == 0) {   // child
     c78:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     c7c:	75 58                	jne    cd6 <doExecTest+0x2bf>
      exec(cmd[0], cmd);
     c7e:	8b 45 08             	mov    0x8(%ebp),%eax
     c81:	8b 00                	mov    (%eax),%eax
     c83:	83 ec 08             	sub    $0x8,%esp
     c86:	ff 75 08             	pushl  0x8(%ebp)
     c89:	50                   	push   %eax
     c8a:	e8 9c 07 00 00       	call   142b <exec>
     c8f:	83 c4 10             	add    $0x10,%esp
      if (i != NUMPERMSTOCHECK-1) printf(2, "**** exec call for %s **FAILED**.\n",  cmd[0]);
     c92:	a1 20 26 00 00       	mov    0x2620,%eax
     c97:	83 e8 01             	sub    $0x1,%eax
     c9a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     c9d:	74 1a                	je     cb9 <doExecTest+0x2a2>
     c9f:	8b 45 08             	mov    0x8(%ebp),%eax
     ca2:	8b 00                	mov    (%eax),%eax
     ca4:	83 ec 04             	sub    $0x4,%esp
     ca7:	50                   	push   %eax
     ca8:	68 bc 1b 00 00       	push   $0x1bbc
     cad:	6a 02                	push   $0x2
     caf:	e8 16 09 00 00       	call   15ca <printf>
     cb4:	83 c4 10             	add    $0x10,%esp
     cb7:	eb 18                	jmp    cd1 <doExecTest+0x2ba>
      else printf(2, "**** exec call for %s **FAILED as expected.\n", cmd[0]);
     cb9:	8b 45 08             	mov    0x8(%ebp),%eax
     cbc:	8b 00                	mov    (%eax),%eax
     cbe:	83 ec 04             	sub    $0x4,%esp
     cc1:	50                   	push   %eax
     cc2:	68 e0 1b 00 00       	push   $0x1be0
     cc7:	6a 02                	push   $0x2
     cc9:	e8 fc 08 00 00       	call   15ca <printf>
     cce:	83 c4 10             	add    $0x10,%esp
      exit();
     cd1:	e8 1d 07 00 00       	call   13f3 <exit>
    }
    wait();
     cd6:	e8 20 07 00 00       	call   13fb <wait>

  check(stat(cmd[0], &st));
  uid = st.uid;
  gid = st.gid;

  for (i=0; i<NUMPERMSTOCHECK; i++) {
     cdb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     cdf:	a1 20 26 00 00       	mov    0x2620,%eax
     ce4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     ce7:	0f 8c d0 fd ff ff    	jl     abd <doExecTest+0xa6>
      else printf(2, "**** exec call for %s **FAILED as expected.\n", cmd[0]);
      exit();
    }
    wait();
  }
  chown(cmd[0], uid);
     ced:	8b 45 08             	mov    0x8(%ebp),%eax
     cf0:	8b 00                	mov    (%eax),%eax
     cf2:	83 ec 08             	sub    $0x8,%esp
     cf5:	ff 75 ec             	pushl  -0x14(%ebp)
     cf8:	50                   	push   %eax
     cf9:	e8 e5 07 00 00       	call   14e3 <chown>
     cfe:	83 c4 10             	add    $0x10,%esp
  chgrp(cmd[0], gid);
     d01:	8b 45 08             	mov    0x8(%ebp),%eax
     d04:	8b 00                	mov    (%eax),%eax
     d06:	83 ec 08             	sub    $0x8,%esp
     d09:	ff 75 e8             	pushl  -0x18(%ebp)
     d0c:	50                   	push   %eax
     d0d:	e8 d9 07 00 00       	call   14eb <chgrp>
     d12:	83 c4 10             	add    $0x10,%esp
  chmod(cmd[0], 00755);
     d15:	8b 45 08             	mov    0x8(%ebp),%eax
     d18:	8b 00                	mov    (%eax),%eax
     d1a:	83 ec 08             	sub    $0x8,%esp
     d1d:	68 ed 01 00 00       	push   $0x1ed
     d22:	50                   	push   %eax
     d23:	e8 b3 07 00 00       	call   14db <chmod>
     d28:	83 c4 10             	add    $0x10,%esp
  printf(1, "Requires user visually confirms PASS/FAIL\n");
     d2b:	83 ec 08             	sub    $0x8,%esp
     d2e:	68 18 21 00 00       	push   $0x2118
     d33:	6a 01                	push   $0x1
     d35:	e8 90 08 00 00       	call   15ca <printf>
     d3a:	83 c4 10             	add    $0x10,%esp
  return PASS;
     d3d:	b8 01 00 00 00       	mov    $0x1,%eax
}
     d42:	c9                   	leave  
     d43:	c3                   	ret    

00000d44 <printMenu>:

void
printMenu(void)
{
     d44:	55                   	push   %ebp
     d45:	89 e5                	mov    %esp,%ebp
     d47:	83 ec 18             	sub    $0x18,%esp
  int i = 0;
     d4a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  printf(1, "\n");
     d51:	83 ec 08             	sub    $0x8,%esp
     d54:	68 43 21 00 00       	push   $0x2143
     d59:	6a 01                	push   $0x1
     d5b:	e8 6a 08 00 00       	call   15ca <printf>
     d60:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. exit program\n", i++);
     d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d66:	8d 50 01             	lea    0x1(%eax),%edx
     d69:	89 55 f4             	mov    %edx,-0xc(%ebp)
     d6c:	83 ec 04             	sub    $0x4,%esp
     d6f:	50                   	push   %eax
     d70:	68 45 21 00 00       	push   $0x2145
     d75:	6a 01                	push   $0x1
     d77:	e8 4e 08 00 00       	call   15ca <printf>
     d7c:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. Proc UID\n", i++);
     d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d82:	8d 50 01             	lea    0x1(%eax),%edx
     d85:	89 55 f4             	mov    %edx,-0xc(%ebp)
     d88:	83 ec 04             	sub    $0x4,%esp
     d8b:	50                   	push   %eax
     d8c:	68 57 21 00 00       	push   $0x2157
     d91:	6a 01                	push   $0x1
     d93:	e8 32 08 00 00       	call   15ca <printf>
     d98:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. Proc GID\n", i++);
     d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d9e:	8d 50 01             	lea    0x1(%eax),%edx
     da1:	89 55 f4             	mov    %edx,-0xc(%ebp)
     da4:	83 ec 04             	sub    $0x4,%esp
     da7:	50                   	push   %eax
     da8:	68 65 21 00 00       	push   $0x2165
     dad:	6a 01                	push   $0x1
     daf:	e8 16 08 00 00       	call   15ca <printf>
     db4:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. chmod()\n", i++);
     db7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     dba:	8d 50 01             	lea    0x1(%eax),%edx
     dbd:	89 55 f4             	mov    %edx,-0xc(%ebp)
     dc0:	83 ec 04             	sub    $0x4,%esp
     dc3:	50                   	push   %eax
     dc4:	68 73 21 00 00       	push   $0x2173
     dc9:	6a 01                	push   $0x1
     dcb:	e8 fa 07 00 00       	call   15ca <printf>
     dd0:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. chown()\n", i++);
     dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     dd6:	8d 50 01             	lea    0x1(%eax),%edx
     dd9:	89 55 f4             	mov    %edx,-0xc(%ebp)
     ddc:	83 ec 04             	sub    $0x4,%esp
     ddf:	50                   	push   %eax
     de0:	68 80 21 00 00       	push   $0x2180
     de5:	6a 01                	push   $0x1
     de7:	e8 de 07 00 00       	call   15ca <printf>
     dec:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. chgrp()\n", i++);
     def:	8b 45 f4             	mov    -0xc(%ebp),%eax
     df2:	8d 50 01             	lea    0x1(%eax),%edx
     df5:	89 55 f4             	mov    %edx,-0xc(%ebp)
     df8:	83 ec 04             	sub    $0x4,%esp
     dfb:	50                   	push   %eax
     dfc:	68 8d 21 00 00       	push   $0x218d
     e01:	6a 01                	push   $0x1
     e03:	e8 c2 07 00 00       	call   15ca <printf>
     e08:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. exec()\n", i++);
     e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e0e:	8d 50 01             	lea    0x1(%eax),%edx
     e11:	89 55 f4             	mov    %edx,-0xc(%ebp)
     e14:	83 ec 04             	sub    $0x4,%esp
     e17:	50                   	push   %eax
     e18:	68 9a 21 00 00       	push   $0x219a
     e1d:	6a 01                	push   $0x1
     e1f:	e8 a6 07 00 00       	call   15ca <printf>
     e24:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. setuid\n", i++);
     e27:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e2a:	8d 50 01             	lea    0x1(%eax),%edx
     e2d:	89 55 f4             	mov    %edx,-0xc(%ebp)
     e30:	83 ec 04             	sub    $0x4,%esp
     e33:	50                   	push   %eax
     e34:	68 a6 21 00 00       	push   $0x21a6
     e39:	6a 01                	push   $0x1
     e3b:	e8 8a 07 00 00       	call   15ca <printf>
     e40:	83 c4 10             	add    $0x10,%esp
}
     e43:	90                   	nop
     e44:	c9                   	leave  
     e45:	c3                   	ret    

00000e46 <main>:

int
main(int argc, char *argv[])
{
     e46:	8d 4c 24 04          	lea    0x4(%esp),%ecx
     e4a:	83 e4 f0             	and    $0xfffffff0,%esp
     e4d:	ff 71 fc             	pushl  -0x4(%ecx)
     e50:	55                   	push   %ebp
     e51:	89 e5                	mov    %esp,%ebp
     e53:	51                   	push   %ecx
     e54:	83 ec 24             	sub    $0x24,%esp
  int rc, select, done;
  char buf[5];

  // test strings
  char *t0[] = {'\0'}; // dummy
     e57:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  char *t1[] = {"testsetuid", '\0'};
     e5e:	c7 45 d8 b2 21 00 00 	movl   $0x21b2,-0x28(%ebp)
     e65:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

  while (1) {
    done = FALSE;
     e6c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    printMenu();
     e73:	e8 cc fe ff ff       	call   d44 <printMenu>
    printf(1, "Enter test number: ");
     e78:	83 ec 08             	sub    $0x8,%esp
     e7b:	68 bd 21 00 00       	push   $0x21bd
     e80:	6a 01                	push   $0x1
     e82:	e8 43 07 00 00       	call   15ca <printf>
     e87:	83 c4 10             	add    $0x10,%esp
    gets(buf, 5);
     e8a:	83 ec 08             	sub    $0x8,%esp
     e8d:	6a 05                	push   $0x5
     e8f:	8d 45 e7             	lea    -0x19(%ebp),%eax
     e92:	50                   	push   %eax
     e93:	e8 3a 03 00 00       	call   11d2 <gets>
     e98:	83 c4 10             	add    $0x10,%esp
    if ((buf[0] == '\n') || (buf[0] == '\0')) continue;
     e9b:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
     e9f:	3c 0a                	cmp    $0xa,%al
     ea1:	0f 84 f5 01 00 00    	je     109c <main+0x256>
     ea7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
     eab:	84 c0                	test   %al,%al
     ead:	0f 84 e9 01 00 00    	je     109c <main+0x256>
    select = atoi(buf);
     eb3:	83 ec 0c             	sub    $0xc,%esp
     eb6:	8d 45 e7             	lea    -0x19(%ebp),%eax
     eb9:	50                   	push   %eax
     eba:	e8 cf 03 00 00       	call   128e <atoi>
     ebf:	83 c4 10             	add    $0x10,%esp
     ec2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    switch (select) {
     ec5:	83 7d f0 07          	cmpl   $0x7,-0x10(%ebp)
     ec9:	0f 87 9b 01 00 00    	ja     106a <main+0x224>
     ecf:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ed2:	c1 e0 02             	shl    $0x2,%eax
     ed5:	05 60 22 00 00       	add    $0x2260,%eax
     eda:	8b 00                	mov    (%eax),%eax
     edc:	ff e0                	jmp    *%eax
	    case 0: done = TRUE; break;
     ede:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
     ee5:	e9 a7 01 00 00       	jmp    1091 <main+0x24b>
	    case 1:
		  doTest(doUidTest,    t0); break;
     eea:	83 ec 0c             	sub    $0xc,%esp
     eed:	8d 45 e0             	lea    -0x20(%ebp),%eax
     ef0:	50                   	push   %eax
     ef1:	e8 e3 f4 ff ff       	call   3d9 <doUidTest>
     ef6:	83 c4 10             	add    $0x10,%esp
     ef9:	89 45 ec             	mov    %eax,-0x14(%ebp)
     efc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     f00:	0f 85 78 01 00 00    	jne    107e <main+0x238>
     f06:	83 ec 04             	sub    $0x4,%esp
     f09:	68 d1 21 00 00       	push   $0x21d1
     f0e:	68 db 21 00 00       	push   $0x21db
     f13:	6a 02                	push   $0x2
     f15:	e8 b0 06 00 00       	call   15ca <printf>
     f1a:	83 c4 10             	add    $0x10,%esp
     f1d:	e8 d1 04 00 00       	call   13f3 <exit>
	    case 2:
		  doTest(doGidTest,    t0); break;
     f22:	83 ec 0c             	sub    $0xc,%esp
     f25:	8d 45 e0             	lea    -0x20(%ebp),%eax
     f28:	50                   	push   %eax
     f29:	e8 34 f6 ff ff       	call   562 <doGidTest>
     f2e:	83 c4 10             	add    $0x10,%esp
     f31:	89 45 ec             	mov    %eax,-0x14(%ebp)
     f34:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     f38:	0f 85 43 01 00 00    	jne    1081 <main+0x23b>
     f3e:	83 ec 04             	sub    $0x4,%esp
     f41:	68 ed 21 00 00       	push   $0x21ed
     f46:	68 db 21 00 00       	push   $0x21db
     f4b:	6a 02                	push   $0x2
     f4d:	e8 78 06 00 00       	call   15ca <printf>
     f52:	83 c4 10             	add    $0x10,%esp
     f55:	e8 99 04 00 00       	call   13f3 <exit>
	    case 3:
		  doTest(doChmodTest,  t1); break;
     f5a:	83 ec 0c             	sub    $0xc,%esp
     f5d:	8d 45 d8             	lea    -0x28(%ebp),%eax
     f60:	50                   	push   %eax
     f61:	e8 85 f7 ff ff       	call   6eb <doChmodTest>
     f66:	83 c4 10             	add    $0x10,%esp
     f69:	89 45 ec             	mov    %eax,-0x14(%ebp)
     f6c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     f70:	0f 85 0e 01 00 00    	jne    1084 <main+0x23e>
     f76:	83 ec 04             	sub    $0x4,%esp
     f79:	68 f7 21 00 00       	push   $0x21f7
     f7e:	68 db 21 00 00       	push   $0x21db
     f83:	6a 02                	push   $0x2
     f85:	e8 40 06 00 00       	call   15ca <printf>
     f8a:	83 c4 10             	add    $0x10,%esp
     f8d:	e8 61 04 00 00       	call   13f3 <exit>
	    case 4:
		  doTest(doChownTest,  t1); break;
     f92:	83 ec 0c             	sub    $0xc,%esp
     f95:	8d 45 d8             	lea    -0x28(%ebp),%eax
     f98:	50                   	push   %eax
     f99:	e8 c4 f8 ff ff       	call   862 <doChownTest>
     f9e:	83 c4 10             	add    $0x10,%esp
     fa1:	89 45 ec             	mov    %eax,-0x14(%ebp)
     fa4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     fa8:	0f 85 d9 00 00 00    	jne    1087 <main+0x241>
     fae:	83 ec 04             	sub    $0x4,%esp
     fb1:	68 03 22 00 00       	push   $0x2203
     fb6:	68 db 21 00 00       	push   $0x21db
     fbb:	6a 02                	push   $0x2
     fbd:	e8 08 06 00 00       	call   15ca <printf>
     fc2:	83 c4 10             	add    $0x10,%esp
     fc5:	e8 29 04 00 00       	call   13f3 <exit>
	    case 5:
		  doTest(doChgrpTest,  t1); break;
     fca:	83 ec 0c             	sub    $0xc,%esp
     fcd:	8d 45 d8             	lea    -0x28(%ebp),%eax
     fd0:	50                   	push   %eax
     fd1:	e8 68 f9 ff ff       	call   93e <doChgrpTest>
     fd6:	83 c4 10             	add    $0x10,%esp
     fd9:	89 45 ec             	mov    %eax,-0x14(%ebp)
     fdc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     fe0:	0f 85 a4 00 00 00    	jne    108a <main+0x244>
     fe6:	83 ec 04             	sub    $0x4,%esp
     fe9:	68 0f 22 00 00       	push   $0x220f
     fee:	68 db 21 00 00       	push   $0x21db
     ff3:	6a 02                	push   $0x2
     ff5:	e8 d0 05 00 00       	call   15ca <printf>
     ffa:	83 c4 10             	add    $0x10,%esp
     ffd:	e8 f1 03 00 00       	call   13f3 <exit>
	    case 6:
		  doTest(doExecTest,   t1); break;
    1002:	83 ec 0c             	sub    $0xc,%esp
    1005:	8d 45 d8             	lea    -0x28(%ebp),%eax
    1008:	50                   	push   %eax
    1009:	e8 09 fa ff ff       	call   a17 <doExecTest>
    100e:	83 c4 10             	add    $0x10,%esp
    1011:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1014:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1018:	75 73                	jne    108d <main+0x247>
    101a:	83 ec 04             	sub    $0x4,%esp
    101d:	68 1b 22 00 00       	push   $0x221b
    1022:	68 db 21 00 00       	push   $0x21db
    1027:	6a 02                	push   $0x2
    1029:	e8 9c 05 00 00       	call   15ca <printf>
    102e:	83 c4 10             	add    $0x10,%esp
    1031:	e8 bd 03 00 00       	call   13f3 <exit>
	    case 7:
		  doTest(doSetuidTest, t1); break;
    1036:	83 ec 0c             	sub    $0xc,%esp
    1039:	8d 45 d8             	lea    -0x28(%ebp),%eax
    103c:	50                   	push   %eax
    103d:	e8 a5 f0 ff ff       	call   e7 <doSetuidTest>
    1042:	83 c4 10             	add    $0x10,%esp
    1045:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1048:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    104c:	75 42                	jne    1090 <main+0x24a>
    104e:	83 ec 04             	sub    $0x4,%esp
    1051:	68 26 22 00 00       	push   $0x2226
    1056:	68 db 21 00 00       	push   $0x21db
    105b:	6a 02                	push   $0x2
    105d:	e8 68 05 00 00       	call   15ca <printf>
    1062:	83 c4 10             	add    $0x10,%esp
    1065:	e8 89 03 00 00       	call   13f3 <exit>
	    default:
		   printf(1, "Error:invalid test number.\n");
    106a:	83 ec 08             	sub    $0x8,%esp
    106d:	68 33 22 00 00       	push   $0x2233
    1072:	6a 01                	push   $0x1
    1074:	e8 51 05 00 00       	call   15ca <printf>
    1079:	83 c4 10             	add    $0x10,%esp
    107c:	eb 13                	jmp    1091 <main+0x24b>
    if ((buf[0] == '\n') || (buf[0] == '\0')) continue;
    select = atoi(buf);
    switch (select) {
	    case 0: done = TRUE; break;
	    case 1:
		  doTest(doUidTest,    t0); break;
    107e:	90                   	nop
    107f:	eb 10                	jmp    1091 <main+0x24b>
	    case 2:
		  doTest(doGidTest,    t0); break;
    1081:	90                   	nop
    1082:	eb 0d                	jmp    1091 <main+0x24b>
	    case 3:
		  doTest(doChmodTest,  t1); break;
    1084:	90                   	nop
    1085:	eb 0a                	jmp    1091 <main+0x24b>
	    case 4:
		  doTest(doChownTest,  t1); break;
    1087:	90                   	nop
    1088:	eb 07                	jmp    1091 <main+0x24b>
	    case 5:
		  doTest(doChgrpTest,  t1); break;
    108a:	90                   	nop
    108b:	eb 04                	jmp    1091 <main+0x24b>
	    case 6:
		  doTest(doExecTest,   t1); break;
    108d:	90                   	nop
    108e:	eb 01                	jmp    1091 <main+0x24b>
	    case 7:
		  doTest(doSetuidTest, t1); break;
    1090:	90                   	nop
	    default:
		   printf(1, "Error:invalid test number.\n");
    }

    if (done) break;
    1091:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1095:	75 0b                	jne    10a2 <main+0x25c>
    1097:	e9 d0 fd ff ff       	jmp    e6c <main+0x26>
  while (1) {
    done = FALSE;
    printMenu();
    printf(1, "Enter test number: ");
    gets(buf, 5);
    if ((buf[0] == '\n') || (buf[0] == '\0')) continue;
    109c:	90                   	nop
	    default:
		   printf(1, "Error:invalid test number.\n");
    }

    if (done) break;
  }
    109d:	e9 ca fd ff ff       	jmp    e6c <main+0x26>
		  doTest(doSetuidTest, t1); break;
	    default:
		   printf(1, "Error:invalid test number.\n");
    }

    if (done) break;
    10a2:	90                   	nop
  }

  printf(1, "\nDone for now\n");
    10a3:	83 ec 08             	sub    $0x8,%esp
    10a6:	68 4f 22 00 00       	push   $0x224f
    10ab:	6a 01                	push   $0x1
    10ad:	e8 18 05 00 00       	call   15ca <printf>
    10b2:	83 c4 10             	add    $0x10,%esp
  free(buf);
    10b5:	83 ec 0c             	sub    $0xc,%esp
    10b8:	8d 45 e7             	lea    -0x19(%ebp),%eax
    10bb:	50                   	push   %eax
    10bc:	e8 9a 06 00 00       	call   175b <free>
    10c1:	83 c4 10             	add    $0x10,%esp
  exit();
    10c4:	e8 2a 03 00 00       	call   13f3 <exit>

000010c9 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    10c9:	55                   	push   %ebp
    10ca:	89 e5                	mov    %esp,%ebp
    10cc:	57                   	push   %edi
    10cd:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    10ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
    10d1:	8b 55 10             	mov    0x10(%ebp),%edx
    10d4:	8b 45 0c             	mov    0xc(%ebp),%eax
    10d7:	89 cb                	mov    %ecx,%ebx
    10d9:	89 df                	mov    %ebx,%edi
    10db:	89 d1                	mov    %edx,%ecx
    10dd:	fc                   	cld    
    10de:	f3 aa                	rep stos %al,%es:(%edi)
    10e0:	89 ca                	mov    %ecx,%edx
    10e2:	89 fb                	mov    %edi,%ebx
    10e4:	89 5d 08             	mov    %ebx,0x8(%ebp)
    10e7:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    10ea:	90                   	nop
    10eb:	5b                   	pop    %ebx
    10ec:	5f                   	pop    %edi
    10ed:	5d                   	pop    %ebp
    10ee:	c3                   	ret    

000010ef <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    10ef:	55                   	push   %ebp
    10f0:	89 e5                	mov    %esp,%ebp
    10f2:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    10f5:	8b 45 08             	mov    0x8(%ebp),%eax
    10f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    10fb:	90                   	nop
    10fc:	8b 45 08             	mov    0x8(%ebp),%eax
    10ff:	8d 50 01             	lea    0x1(%eax),%edx
    1102:	89 55 08             	mov    %edx,0x8(%ebp)
    1105:	8b 55 0c             	mov    0xc(%ebp),%edx
    1108:	8d 4a 01             	lea    0x1(%edx),%ecx
    110b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    110e:	0f b6 12             	movzbl (%edx),%edx
    1111:	88 10                	mov    %dl,(%eax)
    1113:	0f b6 00             	movzbl (%eax),%eax
    1116:	84 c0                	test   %al,%al
    1118:	75 e2                	jne    10fc <strcpy+0xd>
    ;
  return os;
    111a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    111d:	c9                   	leave  
    111e:	c3                   	ret    

0000111f <strcmp>:

int
strcmp(const char *p, const char *q)
{
    111f:	55                   	push   %ebp
    1120:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    1122:	eb 08                	jmp    112c <strcmp+0xd>
    p++, q++;
    1124:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1128:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    112c:	8b 45 08             	mov    0x8(%ebp),%eax
    112f:	0f b6 00             	movzbl (%eax),%eax
    1132:	84 c0                	test   %al,%al
    1134:	74 10                	je     1146 <strcmp+0x27>
    1136:	8b 45 08             	mov    0x8(%ebp),%eax
    1139:	0f b6 10             	movzbl (%eax),%edx
    113c:	8b 45 0c             	mov    0xc(%ebp),%eax
    113f:	0f b6 00             	movzbl (%eax),%eax
    1142:	38 c2                	cmp    %al,%dl
    1144:	74 de                	je     1124 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    1146:	8b 45 08             	mov    0x8(%ebp),%eax
    1149:	0f b6 00             	movzbl (%eax),%eax
    114c:	0f b6 d0             	movzbl %al,%edx
    114f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1152:	0f b6 00             	movzbl (%eax),%eax
    1155:	0f b6 c0             	movzbl %al,%eax
    1158:	29 c2                	sub    %eax,%edx
    115a:	89 d0                	mov    %edx,%eax
}
    115c:	5d                   	pop    %ebp
    115d:	c3                   	ret    

0000115e <strlen>:

uint
strlen(char *s)
{
    115e:	55                   	push   %ebp
    115f:	89 e5                	mov    %esp,%ebp
    1161:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    1164:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    116b:	eb 04                	jmp    1171 <strlen+0x13>
    116d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    1171:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1174:	8b 45 08             	mov    0x8(%ebp),%eax
    1177:	01 d0                	add    %edx,%eax
    1179:	0f b6 00             	movzbl (%eax),%eax
    117c:	84 c0                	test   %al,%al
    117e:	75 ed                	jne    116d <strlen+0xf>
    ;
  return n;
    1180:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1183:	c9                   	leave  
    1184:	c3                   	ret    

00001185 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1185:	55                   	push   %ebp
    1186:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
    1188:	8b 45 10             	mov    0x10(%ebp),%eax
    118b:	50                   	push   %eax
    118c:	ff 75 0c             	pushl  0xc(%ebp)
    118f:	ff 75 08             	pushl  0x8(%ebp)
    1192:	e8 32 ff ff ff       	call   10c9 <stosb>
    1197:	83 c4 0c             	add    $0xc,%esp
  return dst;
    119a:	8b 45 08             	mov    0x8(%ebp),%eax
}
    119d:	c9                   	leave  
    119e:	c3                   	ret    

0000119f <strchr>:

char*
strchr(const char *s, char c)
{
    119f:	55                   	push   %ebp
    11a0:	89 e5                	mov    %esp,%ebp
    11a2:	83 ec 04             	sub    $0x4,%esp
    11a5:	8b 45 0c             	mov    0xc(%ebp),%eax
    11a8:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    11ab:	eb 14                	jmp    11c1 <strchr+0x22>
    if(*s == c)
    11ad:	8b 45 08             	mov    0x8(%ebp),%eax
    11b0:	0f b6 00             	movzbl (%eax),%eax
    11b3:	3a 45 fc             	cmp    -0x4(%ebp),%al
    11b6:	75 05                	jne    11bd <strchr+0x1e>
      return (char*)s;
    11b8:	8b 45 08             	mov    0x8(%ebp),%eax
    11bb:	eb 13                	jmp    11d0 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    11bd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    11c1:	8b 45 08             	mov    0x8(%ebp),%eax
    11c4:	0f b6 00             	movzbl (%eax),%eax
    11c7:	84 c0                	test   %al,%al
    11c9:	75 e2                	jne    11ad <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    11cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
    11d0:	c9                   	leave  
    11d1:	c3                   	ret    

000011d2 <gets>:

char*
gets(char *buf, int max)
{
    11d2:	55                   	push   %ebp
    11d3:	89 e5                	mov    %esp,%ebp
    11d5:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    11df:	eb 42                	jmp    1223 <gets+0x51>
    cc = read(0, &c, 1);
    11e1:	83 ec 04             	sub    $0x4,%esp
    11e4:	6a 01                	push   $0x1
    11e6:	8d 45 ef             	lea    -0x11(%ebp),%eax
    11e9:	50                   	push   %eax
    11ea:	6a 00                	push   $0x0
    11ec:	e8 1a 02 00 00       	call   140b <read>
    11f1:	83 c4 10             	add    $0x10,%esp
    11f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    11f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    11fb:	7e 33                	jle    1230 <gets+0x5e>
      break;
    buf[i++] = c;
    11fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1200:	8d 50 01             	lea    0x1(%eax),%edx
    1203:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1206:	89 c2                	mov    %eax,%edx
    1208:	8b 45 08             	mov    0x8(%ebp),%eax
    120b:	01 c2                	add    %eax,%edx
    120d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1211:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    1213:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1217:	3c 0a                	cmp    $0xa,%al
    1219:	74 16                	je     1231 <gets+0x5f>
    121b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    121f:	3c 0d                	cmp    $0xd,%al
    1221:	74 0e                	je     1231 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1223:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1226:	83 c0 01             	add    $0x1,%eax
    1229:	3b 45 0c             	cmp    0xc(%ebp),%eax
    122c:	7c b3                	jl     11e1 <gets+0xf>
    122e:	eb 01                	jmp    1231 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    1230:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1231:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1234:	8b 45 08             	mov    0x8(%ebp),%eax
    1237:	01 d0                	add    %edx,%eax
    1239:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    123c:	8b 45 08             	mov    0x8(%ebp),%eax
}
    123f:	c9                   	leave  
    1240:	c3                   	ret    

00001241 <stat>:

int
stat(char *n, struct stat *st)
{
    1241:	55                   	push   %ebp
    1242:	89 e5                	mov    %esp,%ebp
    1244:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1247:	83 ec 08             	sub    $0x8,%esp
    124a:	6a 00                	push   $0x0
    124c:	ff 75 08             	pushl  0x8(%ebp)
    124f:	e8 df 01 00 00       	call   1433 <open>
    1254:	83 c4 10             	add    $0x10,%esp
    1257:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    125a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    125e:	79 07                	jns    1267 <stat+0x26>
    return -1;
    1260:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1265:	eb 25                	jmp    128c <stat+0x4b>
  r = fstat(fd, st);
    1267:	83 ec 08             	sub    $0x8,%esp
    126a:	ff 75 0c             	pushl  0xc(%ebp)
    126d:	ff 75 f4             	pushl  -0xc(%ebp)
    1270:	e8 d6 01 00 00       	call   144b <fstat>
    1275:	83 c4 10             	add    $0x10,%esp
    1278:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    127b:	83 ec 0c             	sub    $0xc,%esp
    127e:	ff 75 f4             	pushl  -0xc(%ebp)
    1281:	e8 95 01 00 00       	call   141b <close>
    1286:	83 c4 10             	add    $0x10,%esp
  return r;
    1289:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    128c:	c9                   	leave  
    128d:	c3                   	ret    

0000128e <atoi>:

int
atoi(const char *s)
{
    128e:	55                   	push   %ebp
    128f:	89 e5                	mov    %esp,%ebp
    1291:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
    1294:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
    129b:	eb 04                	jmp    12a1 <atoi+0x13>
    129d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    12a1:	8b 45 08             	mov    0x8(%ebp),%eax
    12a4:	0f b6 00             	movzbl (%eax),%eax
    12a7:	3c 20                	cmp    $0x20,%al
    12a9:	74 f2                	je     129d <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
    12ab:	8b 45 08             	mov    0x8(%ebp),%eax
    12ae:	0f b6 00             	movzbl (%eax),%eax
    12b1:	3c 2d                	cmp    $0x2d,%al
    12b3:	75 07                	jne    12bc <atoi+0x2e>
    12b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    12ba:	eb 05                	jmp    12c1 <atoi+0x33>
    12bc:	b8 01 00 00 00       	mov    $0x1,%eax
    12c1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
    12c4:	8b 45 08             	mov    0x8(%ebp),%eax
    12c7:	0f b6 00             	movzbl (%eax),%eax
    12ca:	3c 2b                	cmp    $0x2b,%al
    12cc:	74 0a                	je     12d8 <atoi+0x4a>
    12ce:	8b 45 08             	mov    0x8(%ebp),%eax
    12d1:	0f b6 00             	movzbl (%eax),%eax
    12d4:	3c 2d                	cmp    $0x2d,%al
    12d6:	75 2b                	jne    1303 <atoi+0x75>
    s++;
    12d8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
    12dc:	eb 25                	jmp    1303 <atoi+0x75>
    n = n*10 + *s++ - '0';
    12de:	8b 55 fc             	mov    -0x4(%ebp),%edx
    12e1:	89 d0                	mov    %edx,%eax
    12e3:	c1 e0 02             	shl    $0x2,%eax
    12e6:	01 d0                	add    %edx,%eax
    12e8:	01 c0                	add    %eax,%eax
    12ea:	89 c1                	mov    %eax,%ecx
    12ec:	8b 45 08             	mov    0x8(%ebp),%eax
    12ef:	8d 50 01             	lea    0x1(%eax),%edx
    12f2:	89 55 08             	mov    %edx,0x8(%ebp)
    12f5:	0f b6 00             	movzbl (%eax),%eax
    12f8:	0f be c0             	movsbl %al,%eax
    12fb:	01 c8                	add    %ecx,%eax
    12fd:	83 e8 30             	sub    $0x30,%eax
    1300:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
    1303:	8b 45 08             	mov    0x8(%ebp),%eax
    1306:	0f b6 00             	movzbl (%eax),%eax
    1309:	3c 2f                	cmp    $0x2f,%al
    130b:	7e 0a                	jle    1317 <atoi+0x89>
    130d:	8b 45 08             	mov    0x8(%ebp),%eax
    1310:	0f b6 00             	movzbl (%eax),%eax
    1313:	3c 39                	cmp    $0x39,%al
    1315:	7e c7                	jle    12de <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
    1317:	8b 45 f8             	mov    -0x8(%ebp),%eax
    131a:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
    131e:	c9                   	leave  
    131f:	c3                   	ret    

00001320 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1320:	55                   	push   %ebp
    1321:	89 e5                	mov    %esp,%ebp
    1323:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    1326:	8b 45 08             	mov    0x8(%ebp),%eax
    1329:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    132c:	8b 45 0c             	mov    0xc(%ebp),%eax
    132f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1332:	eb 17                	jmp    134b <memmove+0x2b>
    *dst++ = *src++;
    1334:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1337:	8d 50 01             	lea    0x1(%eax),%edx
    133a:	89 55 fc             	mov    %edx,-0x4(%ebp)
    133d:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1340:	8d 4a 01             	lea    0x1(%edx),%ecx
    1343:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    1346:	0f b6 12             	movzbl (%edx),%edx
    1349:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    134b:	8b 45 10             	mov    0x10(%ebp),%eax
    134e:	8d 50 ff             	lea    -0x1(%eax),%edx
    1351:	89 55 10             	mov    %edx,0x10(%ebp)
    1354:	85 c0                	test   %eax,%eax
    1356:	7f dc                	jg     1334 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    1358:	8b 45 08             	mov    0x8(%ebp),%eax
}
    135b:	c9                   	leave  
    135c:	c3                   	ret    

0000135d <atoo>:

#ifdef CS333_P5
int
atoo(const char *s)
{
    135d:	55                   	push   %ebp
    135e:	89 e5                	mov    %esp,%ebp
    1360:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
    1363:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
    136a:	eb 04                	jmp    1370 <atoo+0x13>
    136c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1370:	8b 45 08             	mov    0x8(%ebp),%eax
    1373:	0f b6 00             	movzbl (%eax),%eax
    1376:	3c 20                	cmp    $0x20,%al
    1378:	74 f2                	je     136c <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
    137a:	8b 45 08             	mov    0x8(%ebp),%eax
    137d:	0f b6 00             	movzbl (%eax),%eax
    1380:	3c 2d                	cmp    $0x2d,%al
    1382:	75 07                	jne    138b <atoo+0x2e>
    1384:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1389:	eb 05                	jmp    1390 <atoo+0x33>
    138b:	b8 01 00 00 00       	mov    $0x1,%eax
    1390:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
    1393:	8b 45 08             	mov    0x8(%ebp),%eax
    1396:	0f b6 00             	movzbl (%eax),%eax
    1399:	3c 2b                	cmp    $0x2b,%al
    139b:	74 0a                	je     13a7 <atoo+0x4a>
    139d:	8b 45 08             	mov    0x8(%ebp),%eax
    13a0:	0f b6 00             	movzbl (%eax),%eax
    13a3:	3c 2d                	cmp    $0x2d,%al
    13a5:	75 27                	jne    13ce <atoo+0x71>
    s++;
    13a7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
    13ab:	eb 21                	jmp    13ce <atoo+0x71>
    n = n*8 + *s++ - '0';
    13ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
    13b0:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
    13b7:	8b 45 08             	mov    0x8(%ebp),%eax
    13ba:	8d 50 01             	lea    0x1(%eax),%edx
    13bd:	89 55 08             	mov    %edx,0x8(%ebp)
    13c0:	0f b6 00             	movzbl (%eax),%eax
    13c3:	0f be c0             	movsbl %al,%eax
    13c6:	01 c8                	add    %ecx,%eax
    13c8:	83 e8 30             	sub    $0x30,%eax
    13cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
    13ce:	8b 45 08             	mov    0x8(%ebp),%eax
    13d1:	0f b6 00             	movzbl (%eax),%eax
    13d4:	3c 2f                	cmp    $0x2f,%al
    13d6:	7e 0a                	jle    13e2 <atoo+0x85>
    13d8:	8b 45 08             	mov    0x8(%ebp),%eax
    13db:	0f b6 00             	movzbl (%eax),%eax
    13de:	3c 39                	cmp    $0x39,%al
    13e0:	7e cb                	jle    13ad <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
    13e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    13e5:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
    13e9:	c9                   	leave  
    13ea:	c3                   	ret    

000013eb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    13eb:	b8 01 00 00 00       	mov    $0x1,%eax
    13f0:	cd 40                	int    $0x40
    13f2:	c3                   	ret    

000013f3 <exit>:
SYSCALL(exit)
    13f3:	b8 02 00 00 00       	mov    $0x2,%eax
    13f8:	cd 40                	int    $0x40
    13fa:	c3                   	ret    

000013fb <wait>:
SYSCALL(wait)
    13fb:	b8 03 00 00 00       	mov    $0x3,%eax
    1400:	cd 40                	int    $0x40
    1402:	c3                   	ret    

00001403 <pipe>:
SYSCALL(pipe)
    1403:	b8 04 00 00 00       	mov    $0x4,%eax
    1408:	cd 40                	int    $0x40
    140a:	c3                   	ret    

0000140b <read>:
SYSCALL(read)
    140b:	b8 05 00 00 00       	mov    $0x5,%eax
    1410:	cd 40                	int    $0x40
    1412:	c3                   	ret    

00001413 <write>:
SYSCALL(write)
    1413:	b8 10 00 00 00       	mov    $0x10,%eax
    1418:	cd 40                	int    $0x40
    141a:	c3                   	ret    

0000141b <close>:
SYSCALL(close)
    141b:	b8 15 00 00 00       	mov    $0x15,%eax
    1420:	cd 40                	int    $0x40
    1422:	c3                   	ret    

00001423 <kill>:
SYSCALL(kill)
    1423:	b8 06 00 00 00       	mov    $0x6,%eax
    1428:	cd 40                	int    $0x40
    142a:	c3                   	ret    

0000142b <exec>:
SYSCALL(exec)
    142b:	b8 07 00 00 00       	mov    $0x7,%eax
    1430:	cd 40                	int    $0x40
    1432:	c3                   	ret    

00001433 <open>:
SYSCALL(open)
    1433:	b8 0f 00 00 00       	mov    $0xf,%eax
    1438:	cd 40                	int    $0x40
    143a:	c3                   	ret    

0000143b <mknod>:
SYSCALL(mknod)
    143b:	b8 11 00 00 00       	mov    $0x11,%eax
    1440:	cd 40                	int    $0x40
    1442:	c3                   	ret    

00001443 <unlink>:
SYSCALL(unlink)
    1443:	b8 12 00 00 00       	mov    $0x12,%eax
    1448:	cd 40                	int    $0x40
    144a:	c3                   	ret    

0000144b <fstat>:
SYSCALL(fstat)
    144b:	b8 08 00 00 00       	mov    $0x8,%eax
    1450:	cd 40                	int    $0x40
    1452:	c3                   	ret    

00001453 <link>:
SYSCALL(link)
    1453:	b8 13 00 00 00       	mov    $0x13,%eax
    1458:	cd 40                	int    $0x40
    145a:	c3                   	ret    

0000145b <mkdir>:
SYSCALL(mkdir)
    145b:	b8 14 00 00 00       	mov    $0x14,%eax
    1460:	cd 40                	int    $0x40
    1462:	c3                   	ret    

00001463 <chdir>:
SYSCALL(chdir)
    1463:	b8 09 00 00 00       	mov    $0x9,%eax
    1468:	cd 40                	int    $0x40
    146a:	c3                   	ret    

0000146b <dup>:
SYSCALL(dup)
    146b:	b8 0a 00 00 00       	mov    $0xa,%eax
    1470:	cd 40                	int    $0x40
    1472:	c3                   	ret    

00001473 <getpid>:
SYSCALL(getpid)
    1473:	b8 0b 00 00 00       	mov    $0xb,%eax
    1478:	cd 40                	int    $0x40
    147a:	c3                   	ret    

0000147b <sbrk>:
SYSCALL(sbrk)
    147b:	b8 0c 00 00 00       	mov    $0xc,%eax
    1480:	cd 40                	int    $0x40
    1482:	c3                   	ret    

00001483 <sleep>:
SYSCALL(sleep)
    1483:	b8 0d 00 00 00       	mov    $0xd,%eax
    1488:	cd 40                	int    $0x40
    148a:	c3                   	ret    

0000148b <uptime>:
SYSCALL(uptime)
    148b:	b8 0e 00 00 00       	mov    $0xe,%eax
    1490:	cd 40                	int    $0x40
    1492:	c3                   	ret    

00001493 <halt>:
SYSCALL(halt)
    1493:	b8 16 00 00 00       	mov    $0x16,%eax
    1498:	cd 40                	int    $0x40
    149a:	c3                   	ret    

0000149b <date>:
SYSCALL(date)
    149b:	b8 17 00 00 00       	mov    $0x17,%eax
    14a0:	cd 40                	int    $0x40
    14a2:	c3                   	ret    

000014a3 <getuid>:
SYSCALL(getuid)
    14a3:	b8 18 00 00 00       	mov    $0x18,%eax
    14a8:	cd 40                	int    $0x40
    14aa:	c3                   	ret    

000014ab <getgid>:
SYSCALL(getgid)
    14ab:	b8 19 00 00 00       	mov    $0x19,%eax
    14b0:	cd 40                	int    $0x40
    14b2:	c3                   	ret    

000014b3 <getppid>:
SYSCALL(getppid)
    14b3:	b8 1a 00 00 00       	mov    $0x1a,%eax
    14b8:	cd 40                	int    $0x40
    14ba:	c3                   	ret    

000014bb <setuid>:
SYSCALL(setuid)
    14bb:	b8 1b 00 00 00       	mov    $0x1b,%eax
    14c0:	cd 40                	int    $0x40
    14c2:	c3                   	ret    

000014c3 <setgid>:
SYSCALL(setgid)
    14c3:	b8 1c 00 00 00       	mov    $0x1c,%eax
    14c8:	cd 40                	int    $0x40
    14ca:	c3                   	ret    

000014cb <getprocs>:
SYSCALL(getprocs)
    14cb:	b8 1d 00 00 00       	mov    $0x1d,%eax
    14d0:	cd 40                	int    $0x40
    14d2:	c3                   	ret    

000014d3 <setpriority>:
SYSCALL(setpriority)
    14d3:	b8 1e 00 00 00       	mov    $0x1e,%eax
    14d8:	cd 40                	int    $0x40
    14da:	c3                   	ret    

000014db <chmod>:
SYSCALL(chmod)
    14db:	b8 1f 00 00 00       	mov    $0x1f,%eax
    14e0:	cd 40                	int    $0x40
    14e2:	c3                   	ret    

000014e3 <chown>:
SYSCALL(chown)
    14e3:	b8 20 00 00 00       	mov    $0x20,%eax
    14e8:	cd 40                	int    $0x40
    14ea:	c3                   	ret    

000014eb <chgrp>:
SYSCALL(chgrp)
    14eb:	b8 21 00 00 00       	mov    $0x21,%eax
    14f0:	cd 40                	int    $0x40
    14f2:	c3                   	ret    

000014f3 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    14f3:	55                   	push   %ebp
    14f4:	89 e5                	mov    %esp,%ebp
    14f6:	83 ec 18             	sub    $0x18,%esp
    14f9:	8b 45 0c             	mov    0xc(%ebp),%eax
    14fc:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    14ff:	83 ec 04             	sub    $0x4,%esp
    1502:	6a 01                	push   $0x1
    1504:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1507:	50                   	push   %eax
    1508:	ff 75 08             	pushl  0x8(%ebp)
    150b:	e8 03 ff ff ff       	call   1413 <write>
    1510:	83 c4 10             	add    $0x10,%esp
}
    1513:	90                   	nop
    1514:	c9                   	leave  
    1515:	c3                   	ret    

00001516 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1516:	55                   	push   %ebp
    1517:	89 e5                	mov    %esp,%ebp
    1519:	53                   	push   %ebx
    151a:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    151d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1524:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    1528:	74 17                	je     1541 <printint+0x2b>
    152a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    152e:	79 11                	jns    1541 <printint+0x2b>
    neg = 1;
    1530:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    1537:	8b 45 0c             	mov    0xc(%ebp),%eax
    153a:	f7 d8                	neg    %eax
    153c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    153f:	eb 06                	jmp    1547 <printint+0x31>
  } else {
    x = xx;
    1541:	8b 45 0c             	mov    0xc(%ebp),%eax
    1544:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    1547:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    154e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1551:	8d 41 01             	lea    0x1(%ecx),%eax
    1554:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1557:	8b 5d 10             	mov    0x10(%ebp),%ebx
    155a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    155d:	ba 00 00 00 00       	mov    $0x0,%edx
    1562:	f7 f3                	div    %ebx
    1564:	89 d0                	mov    %edx,%eax
    1566:	0f b6 80 80 26 00 00 	movzbl 0x2680(%eax),%eax
    156d:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    1571:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1574:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1577:	ba 00 00 00 00       	mov    $0x0,%edx
    157c:	f7 f3                	div    %ebx
    157e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1581:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1585:	75 c7                	jne    154e <printint+0x38>
  if(neg)
    1587:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    158b:	74 2d                	je     15ba <printint+0xa4>
    buf[i++] = '-';
    158d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1590:	8d 50 01             	lea    0x1(%eax),%edx
    1593:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1596:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    159b:	eb 1d                	jmp    15ba <printint+0xa4>
    putc(fd, buf[i]);
    159d:	8d 55 dc             	lea    -0x24(%ebp),%edx
    15a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15a3:	01 d0                	add    %edx,%eax
    15a5:	0f b6 00             	movzbl (%eax),%eax
    15a8:	0f be c0             	movsbl %al,%eax
    15ab:	83 ec 08             	sub    $0x8,%esp
    15ae:	50                   	push   %eax
    15af:	ff 75 08             	pushl  0x8(%ebp)
    15b2:	e8 3c ff ff ff       	call   14f3 <putc>
    15b7:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    15ba:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    15be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    15c2:	79 d9                	jns    159d <printint+0x87>
    putc(fd, buf[i]);
}
    15c4:	90                   	nop
    15c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    15c8:	c9                   	leave  
    15c9:	c3                   	ret    

000015ca <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    15ca:	55                   	push   %ebp
    15cb:	89 e5                	mov    %esp,%ebp
    15cd:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    15d0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    15d7:	8d 45 0c             	lea    0xc(%ebp),%eax
    15da:	83 c0 04             	add    $0x4,%eax
    15dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    15e0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    15e7:	e9 59 01 00 00       	jmp    1745 <printf+0x17b>
    c = fmt[i] & 0xff;
    15ec:	8b 55 0c             	mov    0xc(%ebp),%edx
    15ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
    15f2:	01 d0                	add    %edx,%eax
    15f4:	0f b6 00             	movzbl (%eax),%eax
    15f7:	0f be c0             	movsbl %al,%eax
    15fa:	25 ff 00 00 00       	and    $0xff,%eax
    15ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1602:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1606:	75 2c                	jne    1634 <printf+0x6a>
      if(c == '%'){
    1608:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    160c:	75 0c                	jne    161a <printf+0x50>
        state = '%';
    160e:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1615:	e9 27 01 00 00       	jmp    1741 <printf+0x177>
      } else {
        putc(fd, c);
    161a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    161d:	0f be c0             	movsbl %al,%eax
    1620:	83 ec 08             	sub    $0x8,%esp
    1623:	50                   	push   %eax
    1624:	ff 75 08             	pushl  0x8(%ebp)
    1627:	e8 c7 fe ff ff       	call   14f3 <putc>
    162c:	83 c4 10             	add    $0x10,%esp
    162f:	e9 0d 01 00 00       	jmp    1741 <printf+0x177>
      }
    } else if(state == '%'){
    1634:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    1638:	0f 85 03 01 00 00    	jne    1741 <printf+0x177>
      if(c == 'd'){
    163e:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    1642:	75 1e                	jne    1662 <printf+0x98>
        printint(fd, *ap, 10, 1);
    1644:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1647:	8b 00                	mov    (%eax),%eax
    1649:	6a 01                	push   $0x1
    164b:	6a 0a                	push   $0xa
    164d:	50                   	push   %eax
    164e:	ff 75 08             	pushl  0x8(%ebp)
    1651:	e8 c0 fe ff ff       	call   1516 <printint>
    1656:	83 c4 10             	add    $0x10,%esp
        ap++;
    1659:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    165d:	e9 d8 00 00 00       	jmp    173a <printf+0x170>
      } else if(c == 'x' || c == 'p'){
    1662:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1666:	74 06                	je     166e <printf+0xa4>
    1668:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    166c:	75 1e                	jne    168c <printf+0xc2>
        printint(fd, *ap, 16, 0);
    166e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1671:	8b 00                	mov    (%eax),%eax
    1673:	6a 00                	push   $0x0
    1675:	6a 10                	push   $0x10
    1677:	50                   	push   %eax
    1678:	ff 75 08             	pushl  0x8(%ebp)
    167b:	e8 96 fe ff ff       	call   1516 <printint>
    1680:	83 c4 10             	add    $0x10,%esp
        ap++;
    1683:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1687:	e9 ae 00 00 00       	jmp    173a <printf+0x170>
      } else if(c == 's'){
    168c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1690:	75 43                	jne    16d5 <printf+0x10b>
        s = (char*)*ap;
    1692:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1695:	8b 00                	mov    (%eax),%eax
    1697:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    169a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    169e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    16a2:	75 25                	jne    16c9 <printf+0xff>
          s = "(null)";
    16a4:	c7 45 f4 80 22 00 00 	movl   $0x2280,-0xc(%ebp)
        while(*s != 0){
    16ab:	eb 1c                	jmp    16c9 <printf+0xff>
          putc(fd, *s);
    16ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16b0:	0f b6 00             	movzbl (%eax),%eax
    16b3:	0f be c0             	movsbl %al,%eax
    16b6:	83 ec 08             	sub    $0x8,%esp
    16b9:	50                   	push   %eax
    16ba:	ff 75 08             	pushl  0x8(%ebp)
    16bd:	e8 31 fe ff ff       	call   14f3 <putc>
    16c2:	83 c4 10             	add    $0x10,%esp
          s++;
    16c5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    16c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16cc:	0f b6 00             	movzbl (%eax),%eax
    16cf:	84 c0                	test   %al,%al
    16d1:	75 da                	jne    16ad <printf+0xe3>
    16d3:	eb 65                	jmp    173a <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    16d5:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    16d9:	75 1d                	jne    16f8 <printf+0x12e>
        putc(fd, *ap);
    16db:	8b 45 e8             	mov    -0x18(%ebp),%eax
    16de:	8b 00                	mov    (%eax),%eax
    16e0:	0f be c0             	movsbl %al,%eax
    16e3:	83 ec 08             	sub    $0x8,%esp
    16e6:	50                   	push   %eax
    16e7:	ff 75 08             	pushl  0x8(%ebp)
    16ea:	e8 04 fe ff ff       	call   14f3 <putc>
    16ef:	83 c4 10             	add    $0x10,%esp
        ap++;
    16f2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    16f6:	eb 42                	jmp    173a <printf+0x170>
      } else if(c == '%'){
    16f8:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    16fc:	75 17                	jne    1715 <printf+0x14b>
        putc(fd, c);
    16fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1701:	0f be c0             	movsbl %al,%eax
    1704:	83 ec 08             	sub    $0x8,%esp
    1707:	50                   	push   %eax
    1708:	ff 75 08             	pushl  0x8(%ebp)
    170b:	e8 e3 fd ff ff       	call   14f3 <putc>
    1710:	83 c4 10             	add    $0x10,%esp
    1713:	eb 25                	jmp    173a <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1715:	83 ec 08             	sub    $0x8,%esp
    1718:	6a 25                	push   $0x25
    171a:	ff 75 08             	pushl  0x8(%ebp)
    171d:	e8 d1 fd ff ff       	call   14f3 <putc>
    1722:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
    1725:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1728:	0f be c0             	movsbl %al,%eax
    172b:	83 ec 08             	sub    $0x8,%esp
    172e:	50                   	push   %eax
    172f:	ff 75 08             	pushl  0x8(%ebp)
    1732:	e8 bc fd ff ff       	call   14f3 <putc>
    1737:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    173a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1741:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1745:	8b 55 0c             	mov    0xc(%ebp),%edx
    1748:	8b 45 f0             	mov    -0x10(%ebp),%eax
    174b:	01 d0                	add    %edx,%eax
    174d:	0f b6 00             	movzbl (%eax),%eax
    1750:	84 c0                	test   %al,%al
    1752:	0f 85 94 fe ff ff    	jne    15ec <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1758:	90                   	nop
    1759:	c9                   	leave  
    175a:	c3                   	ret    

0000175b <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    175b:	55                   	push   %ebp
    175c:	89 e5                	mov    %esp,%ebp
    175e:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1761:	8b 45 08             	mov    0x8(%ebp),%eax
    1764:	83 e8 08             	sub    $0x8,%eax
    1767:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    176a:	a1 9c 26 00 00       	mov    0x269c,%eax
    176f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1772:	eb 24                	jmp    1798 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1774:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1777:	8b 00                	mov    (%eax),%eax
    1779:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    177c:	77 12                	ja     1790 <free+0x35>
    177e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1781:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1784:	77 24                	ja     17aa <free+0x4f>
    1786:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1789:	8b 00                	mov    (%eax),%eax
    178b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    178e:	77 1a                	ja     17aa <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1790:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1793:	8b 00                	mov    (%eax),%eax
    1795:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1798:	8b 45 f8             	mov    -0x8(%ebp),%eax
    179b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    179e:	76 d4                	jbe    1774 <free+0x19>
    17a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17a3:	8b 00                	mov    (%eax),%eax
    17a5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    17a8:	76 ca                	jbe    1774 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    17aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17ad:	8b 40 04             	mov    0x4(%eax),%eax
    17b0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    17b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17ba:	01 c2                	add    %eax,%edx
    17bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17bf:	8b 00                	mov    (%eax),%eax
    17c1:	39 c2                	cmp    %eax,%edx
    17c3:	75 24                	jne    17e9 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    17c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17c8:	8b 50 04             	mov    0x4(%eax),%edx
    17cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17ce:	8b 00                	mov    (%eax),%eax
    17d0:	8b 40 04             	mov    0x4(%eax),%eax
    17d3:	01 c2                	add    %eax,%edx
    17d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17d8:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    17db:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17de:	8b 00                	mov    (%eax),%eax
    17e0:	8b 10                	mov    (%eax),%edx
    17e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17e5:	89 10                	mov    %edx,(%eax)
    17e7:	eb 0a                	jmp    17f3 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    17e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17ec:	8b 10                	mov    (%eax),%edx
    17ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17f1:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    17f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17f6:	8b 40 04             	mov    0x4(%eax),%eax
    17f9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1800:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1803:	01 d0                	add    %edx,%eax
    1805:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1808:	75 20                	jne    182a <free+0xcf>
    p->s.size += bp->s.size;
    180a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    180d:	8b 50 04             	mov    0x4(%eax),%edx
    1810:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1813:	8b 40 04             	mov    0x4(%eax),%eax
    1816:	01 c2                	add    %eax,%edx
    1818:	8b 45 fc             	mov    -0x4(%ebp),%eax
    181b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    181e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1821:	8b 10                	mov    (%eax),%edx
    1823:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1826:	89 10                	mov    %edx,(%eax)
    1828:	eb 08                	jmp    1832 <free+0xd7>
  } else
    p->s.ptr = bp;
    182a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    182d:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1830:	89 10                	mov    %edx,(%eax)
  freep = p;
    1832:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1835:	a3 9c 26 00 00       	mov    %eax,0x269c
}
    183a:	90                   	nop
    183b:	c9                   	leave  
    183c:	c3                   	ret    

0000183d <morecore>:

static Header*
morecore(uint nu)
{
    183d:	55                   	push   %ebp
    183e:	89 e5                	mov    %esp,%ebp
    1840:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1843:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    184a:	77 07                	ja     1853 <morecore+0x16>
    nu = 4096;
    184c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1853:	8b 45 08             	mov    0x8(%ebp),%eax
    1856:	c1 e0 03             	shl    $0x3,%eax
    1859:	83 ec 0c             	sub    $0xc,%esp
    185c:	50                   	push   %eax
    185d:	e8 19 fc ff ff       	call   147b <sbrk>
    1862:	83 c4 10             	add    $0x10,%esp
    1865:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1868:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    186c:	75 07                	jne    1875 <morecore+0x38>
    return 0;
    186e:	b8 00 00 00 00       	mov    $0x0,%eax
    1873:	eb 26                	jmp    189b <morecore+0x5e>
  hp = (Header*)p;
    1875:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1878:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    187b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    187e:	8b 55 08             	mov    0x8(%ebp),%edx
    1881:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1884:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1887:	83 c0 08             	add    $0x8,%eax
    188a:	83 ec 0c             	sub    $0xc,%esp
    188d:	50                   	push   %eax
    188e:	e8 c8 fe ff ff       	call   175b <free>
    1893:	83 c4 10             	add    $0x10,%esp
  return freep;
    1896:	a1 9c 26 00 00       	mov    0x269c,%eax
}
    189b:	c9                   	leave  
    189c:	c3                   	ret    

0000189d <malloc>:

void*
malloc(uint nbytes)
{
    189d:	55                   	push   %ebp
    189e:	89 e5                	mov    %esp,%ebp
    18a0:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    18a3:	8b 45 08             	mov    0x8(%ebp),%eax
    18a6:	83 c0 07             	add    $0x7,%eax
    18a9:	c1 e8 03             	shr    $0x3,%eax
    18ac:	83 c0 01             	add    $0x1,%eax
    18af:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    18b2:	a1 9c 26 00 00       	mov    0x269c,%eax
    18b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    18ba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    18be:	75 23                	jne    18e3 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    18c0:	c7 45 f0 94 26 00 00 	movl   $0x2694,-0x10(%ebp)
    18c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18ca:	a3 9c 26 00 00       	mov    %eax,0x269c
    18cf:	a1 9c 26 00 00       	mov    0x269c,%eax
    18d4:	a3 94 26 00 00       	mov    %eax,0x2694
    base.s.size = 0;
    18d9:	c7 05 98 26 00 00 00 	movl   $0x0,0x2698
    18e0:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    18e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18e6:	8b 00                	mov    (%eax),%eax
    18e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    18eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18ee:	8b 40 04             	mov    0x4(%eax),%eax
    18f1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    18f4:	72 4d                	jb     1943 <malloc+0xa6>
      if(p->s.size == nunits)
    18f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18f9:	8b 40 04             	mov    0x4(%eax),%eax
    18fc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    18ff:	75 0c                	jne    190d <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1901:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1904:	8b 10                	mov    (%eax),%edx
    1906:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1909:	89 10                	mov    %edx,(%eax)
    190b:	eb 26                	jmp    1933 <malloc+0x96>
      else {
        p->s.size -= nunits;
    190d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1910:	8b 40 04             	mov    0x4(%eax),%eax
    1913:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1916:	89 c2                	mov    %eax,%edx
    1918:	8b 45 f4             	mov    -0xc(%ebp),%eax
    191b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    191e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1921:	8b 40 04             	mov    0x4(%eax),%eax
    1924:	c1 e0 03             	shl    $0x3,%eax
    1927:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    192a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    192d:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1930:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1933:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1936:	a3 9c 26 00 00       	mov    %eax,0x269c
      return (void*)(p + 1);
    193b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    193e:	83 c0 08             	add    $0x8,%eax
    1941:	eb 3b                	jmp    197e <malloc+0xe1>
    }
    if(p == freep)
    1943:	a1 9c 26 00 00       	mov    0x269c,%eax
    1948:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    194b:	75 1e                	jne    196b <malloc+0xce>
      if((p = morecore(nunits)) == 0)
    194d:	83 ec 0c             	sub    $0xc,%esp
    1950:	ff 75 ec             	pushl  -0x14(%ebp)
    1953:	e8 e5 fe ff ff       	call   183d <morecore>
    1958:	83 c4 10             	add    $0x10,%esp
    195b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    195e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1962:	75 07                	jne    196b <malloc+0xce>
        return 0;
    1964:	b8 00 00 00 00       	mov    $0x0,%eax
    1969:	eb 13                	jmp    197e <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    196b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    196e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1971:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1974:	8b 00                	mov    (%eax),%eax
    1976:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1979:	e9 6d ff ff ff       	jmp    18eb <malloc+0x4e>
}
    197e:	c9                   	leave  
    197f:	c3                   	ret    
