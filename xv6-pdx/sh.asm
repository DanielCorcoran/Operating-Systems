
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <runcmd>:
struct cmd *parsecmd(char*);

// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
       6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
       a:	75 05                	jne    11 <runcmd+0x11>
    exit();
       c:	e8 04 12 00 00       	call   1215 <exit>
  
  switch(cmd->type){
      11:	8b 45 08             	mov    0x8(%ebp),%eax
      14:	8b 00                	mov    (%eax),%eax
      16:	83 f8 05             	cmp    $0x5,%eax
      19:	77 09                	ja     24 <runcmd+0x24>
      1b:	8b 04 85 b0 17 00 00 	mov    0x17b0(,%eax,4),%eax
      22:	ff e0                	jmp    *%eax
  default:
    panic("runcmd");
      24:	83 ec 0c             	sub    $0xc,%esp
      27:	68 84 17 00 00       	push   $0x1784
      2c:	e8 66 06 00 00       	call   697 <panic>
      31:	83 c4 10             	add    $0x10,%esp

  case EXEC:
    ecmd = (struct execcmd*)cmd;
      34:	8b 45 08             	mov    0x8(%ebp),%eax
      37:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ecmd->argv[0] == 0)
      3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
      3d:	8b 40 04             	mov    0x4(%eax),%eax
      40:	85 c0                	test   %eax,%eax
      42:	75 05                	jne    49 <runcmd+0x49>
      exit();
      44:	e8 cc 11 00 00       	call   1215 <exit>
    exec(ecmd->argv[0], ecmd->argv);
      49:	8b 45 f4             	mov    -0xc(%ebp),%eax
      4c:	8d 50 04             	lea    0x4(%eax),%edx
      4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
      52:	8b 40 04             	mov    0x4(%eax),%eax
      55:	83 ec 08             	sub    $0x8,%esp
      58:	52                   	push   %edx
      59:	50                   	push   %eax
      5a:	e8 ee 11 00 00       	call   124d <exec>
      5f:	83 c4 10             	add    $0x10,%esp
    printf(2, "exec %s failed\n", ecmd->argv[0]);
      62:	8b 45 f4             	mov    -0xc(%ebp),%eax
      65:	8b 40 04             	mov    0x4(%eax),%eax
      68:	83 ec 04             	sub    $0x4,%esp
      6b:	50                   	push   %eax
      6c:	68 8b 17 00 00       	push   $0x178b
      71:	6a 02                	push   $0x2
      73:	e8 54 13 00 00       	call   13cc <printf>
      78:	83 c4 10             	add    $0x10,%esp
    break;
      7b:	e9 c6 01 00 00       	jmp    246 <runcmd+0x246>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
      80:	8b 45 08             	mov    0x8(%ebp),%eax
      83:	89 45 f0             	mov    %eax,-0x10(%ebp)
    close(rcmd->fd);
      86:	8b 45 f0             	mov    -0x10(%ebp),%eax
      89:	8b 40 14             	mov    0x14(%eax),%eax
      8c:	83 ec 0c             	sub    $0xc,%esp
      8f:	50                   	push   %eax
      90:	e8 a8 11 00 00       	call   123d <close>
      95:	83 c4 10             	add    $0x10,%esp
    if(open(rcmd->file, rcmd->mode) < 0){
      98:	8b 45 f0             	mov    -0x10(%ebp),%eax
      9b:	8b 50 10             	mov    0x10(%eax),%edx
      9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
      a1:	8b 40 08             	mov    0x8(%eax),%eax
      a4:	83 ec 08             	sub    $0x8,%esp
      a7:	52                   	push   %edx
      a8:	50                   	push   %eax
      a9:	e8 a7 11 00 00       	call   1255 <open>
      ae:	83 c4 10             	add    $0x10,%esp
      b1:	85 c0                	test   %eax,%eax
      b3:	79 1e                	jns    d3 <runcmd+0xd3>
      printf(2, "open %s failed\n", rcmd->file);
      b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
      b8:	8b 40 08             	mov    0x8(%eax),%eax
      bb:	83 ec 04             	sub    $0x4,%esp
      be:	50                   	push   %eax
      bf:	68 9b 17 00 00       	push   $0x179b
      c4:	6a 02                	push   $0x2
      c6:	e8 01 13 00 00       	call   13cc <printf>
      cb:	83 c4 10             	add    $0x10,%esp
      exit();
      ce:	e8 42 11 00 00       	call   1215 <exit>
    }
    runcmd(rcmd->cmd);
      d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
      d6:	8b 40 04             	mov    0x4(%eax),%eax
      d9:	83 ec 0c             	sub    $0xc,%esp
      dc:	50                   	push   %eax
      dd:	e8 1e ff ff ff       	call   0 <runcmd>
      e2:	83 c4 10             	add    $0x10,%esp
    break;
      e5:	e9 5c 01 00 00       	jmp    246 <runcmd+0x246>

  case LIST:
    lcmd = (struct listcmd*)cmd;
      ea:	8b 45 08             	mov    0x8(%ebp),%eax
      ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fork1() == 0)
      f0:	e8 c2 05 00 00       	call   6b7 <fork1>
      f5:	85 c0                	test   %eax,%eax
      f7:	75 12                	jne    10b <runcmd+0x10b>
      runcmd(lcmd->left);
      f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
      fc:	8b 40 04             	mov    0x4(%eax),%eax
      ff:	83 ec 0c             	sub    $0xc,%esp
     102:	50                   	push   %eax
     103:	e8 f8 fe ff ff       	call   0 <runcmd>
     108:	83 c4 10             	add    $0x10,%esp
    wait();
     10b:	e8 0d 11 00 00       	call   121d <wait>
    runcmd(lcmd->right);
     110:	8b 45 ec             	mov    -0x14(%ebp),%eax
     113:	8b 40 08             	mov    0x8(%eax),%eax
     116:	83 ec 0c             	sub    $0xc,%esp
     119:	50                   	push   %eax
     11a:	e8 e1 fe ff ff       	call   0 <runcmd>
     11f:	83 c4 10             	add    $0x10,%esp
    break;
     122:	e9 1f 01 00 00       	jmp    246 <runcmd+0x246>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     127:	8b 45 08             	mov    0x8(%ebp),%eax
     12a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pipe(p) < 0)
     12d:	83 ec 0c             	sub    $0xc,%esp
     130:	8d 45 dc             	lea    -0x24(%ebp),%eax
     133:	50                   	push   %eax
     134:	e8 ec 10 00 00       	call   1225 <pipe>
     139:	83 c4 10             	add    $0x10,%esp
     13c:	85 c0                	test   %eax,%eax
     13e:	79 10                	jns    150 <runcmd+0x150>
      panic("pipe");
     140:	83 ec 0c             	sub    $0xc,%esp
     143:	68 ab 17 00 00       	push   $0x17ab
     148:	e8 4a 05 00 00       	call   697 <panic>
     14d:	83 c4 10             	add    $0x10,%esp
    if(fork1() == 0){
     150:	e8 62 05 00 00       	call   6b7 <fork1>
     155:	85 c0                	test   %eax,%eax
     157:	75 4c                	jne    1a5 <runcmd+0x1a5>
      close(1);
     159:	83 ec 0c             	sub    $0xc,%esp
     15c:	6a 01                	push   $0x1
     15e:	e8 da 10 00 00       	call   123d <close>
     163:	83 c4 10             	add    $0x10,%esp
      dup(p[1]);
     166:	8b 45 e0             	mov    -0x20(%ebp),%eax
     169:	83 ec 0c             	sub    $0xc,%esp
     16c:	50                   	push   %eax
     16d:	e8 1b 11 00 00       	call   128d <dup>
     172:	83 c4 10             	add    $0x10,%esp
      close(p[0]);
     175:	8b 45 dc             	mov    -0x24(%ebp),%eax
     178:	83 ec 0c             	sub    $0xc,%esp
     17b:	50                   	push   %eax
     17c:	e8 bc 10 00 00       	call   123d <close>
     181:	83 c4 10             	add    $0x10,%esp
      close(p[1]);
     184:	8b 45 e0             	mov    -0x20(%ebp),%eax
     187:	83 ec 0c             	sub    $0xc,%esp
     18a:	50                   	push   %eax
     18b:	e8 ad 10 00 00       	call   123d <close>
     190:	83 c4 10             	add    $0x10,%esp
      runcmd(pcmd->left);
     193:	8b 45 e8             	mov    -0x18(%ebp),%eax
     196:	8b 40 04             	mov    0x4(%eax),%eax
     199:	83 ec 0c             	sub    $0xc,%esp
     19c:	50                   	push   %eax
     19d:	e8 5e fe ff ff       	call   0 <runcmd>
     1a2:	83 c4 10             	add    $0x10,%esp
    }
    if(fork1() == 0){
     1a5:	e8 0d 05 00 00       	call   6b7 <fork1>
     1aa:	85 c0                	test   %eax,%eax
     1ac:	75 4c                	jne    1fa <runcmd+0x1fa>
      close(0);
     1ae:	83 ec 0c             	sub    $0xc,%esp
     1b1:	6a 00                	push   $0x0
     1b3:	e8 85 10 00 00       	call   123d <close>
     1b8:	83 c4 10             	add    $0x10,%esp
      dup(p[0]);
     1bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1be:	83 ec 0c             	sub    $0xc,%esp
     1c1:	50                   	push   %eax
     1c2:	e8 c6 10 00 00       	call   128d <dup>
     1c7:	83 c4 10             	add    $0x10,%esp
      close(p[0]);
     1ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1cd:	83 ec 0c             	sub    $0xc,%esp
     1d0:	50                   	push   %eax
     1d1:	e8 67 10 00 00       	call   123d <close>
     1d6:	83 c4 10             	add    $0x10,%esp
      close(p[1]);
     1d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1dc:	83 ec 0c             	sub    $0xc,%esp
     1df:	50                   	push   %eax
     1e0:	e8 58 10 00 00       	call   123d <close>
     1e5:	83 c4 10             	add    $0x10,%esp
      runcmd(pcmd->right);
     1e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
     1eb:	8b 40 08             	mov    0x8(%eax),%eax
     1ee:	83 ec 0c             	sub    $0xc,%esp
     1f1:	50                   	push   %eax
     1f2:	e8 09 fe ff ff       	call   0 <runcmd>
     1f7:	83 c4 10             	add    $0x10,%esp
    }
    close(p[0]);
     1fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1fd:	83 ec 0c             	sub    $0xc,%esp
     200:	50                   	push   %eax
     201:	e8 37 10 00 00       	call   123d <close>
     206:	83 c4 10             	add    $0x10,%esp
    close(p[1]);
     209:	8b 45 e0             	mov    -0x20(%ebp),%eax
     20c:	83 ec 0c             	sub    $0xc,%esp
     20f:	50                   	push   %eax
     210:	e8 28 10 00 00       	call   123d <close>
     215:	83 c4 10             	add    $0x10,%esp
    wait();
     218:	e8 00 10 00 00       	call   121d <wait>
    wait();
     21d:	e8 fb 0f 00 00       	call   121d <wait>
    break;
     222:	eb 22                	jmp    246 <runcmd+0x246>
    
  case BACK:
    bcmd = (struct backcmd*)cmd;
     224:	8b 45 08             	mov    0x8(%ebp),%eax
     227:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(fork1() == 0)
     22a:	e8 88 04 00 00       	call   6b7 <fork1>
     22f:	85 c0                	test   %eax,%eax
     231:	75 12                	jne    245 <runcmd+0x245>
      runcmd(bcmd->cmd);
     233:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     236:	8b 40 04             	mov    0x4(%eax),%eax
     239:	83 ec 0c             	sub    $0xc,%esp
     23c:	50                   	push   %eax
     23d:	e8 be fd ff ff       	call   0 <runcmd>
     242:	83 c4 10             	add    $0x10,%esp
    break;
     245:	90                   	nop
  }
  exit();
     246:	e8 ca 0f 00 00       	call   1215 <exit>

0000024b <getcmd>:
}

int
getcmd(char *buf, int nbuf)
{
     24b:	55                   	push   %ebp
     24c:	89 e5                	mov    %esp,%ebp
     24e:	83 ec 08             	sub    $0x8,%esp
  printf(2, "$ ");
     251:	83 ec 08             	sub    $0x8,%esp
     254:	68 c8 17 00 00       	push   $0x17c8
     259:	6a 02                	push   $0x2
     25b:	e8 6c 11 00 00       	call   13cc <printf>
     260:	83 c4 10             	add    $0x10,%esp
  memset(buf, 0, nbuf);
     263:	8b 45 0c             	mov    0xc(%ebp),%eax
     266:	83 ec 04             	sub    $0x4,%esp
     269:	50                   	push   %eax
     26a:	6a 00                	push   $0x0
     26c:	ff 75 08             	pushl  0x8(%ebp)
     26f:	e8 c1 0d 00 00       	call   1035 <memset>
     274:	83 c4 10             	add    $0x10,%esp
  gets(buf, nbuf);
     277:	83 ec 08             	sub    $0x8,%esp
     27a:	ff 75 0c             	pushl  0xc(%ebp)
     27d:	ff 75 08             	pushl  0x8(%ebp)
     280:	e8 fd 0d 00 00       	call   1082 <gets>
     285:	83 c4 10             	add    $0x10,%esp
  if(buf[0] == 0) // EOF
     288:	8b 45 08             	mov    0x8(%ebp),%eax
     28b:	0f b6 00             	movzbl (%eax),%eax
     28e:	84 c0                	test   %al,%al
     290:	75 07                	jne    299 <getcmd+0x4e>
    return -1;
     292:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     297:	eb 05                	jmp    29e <getcmd+0x53>
  return 0;
     299:	b8 00 00 00 00       	mov    $0x0,%eax
}
     29e:	c9                   	leave  
     29f:	c3                   	ret    

000002a0 <strncmp>:
#ifdef USE_BUILTINS
// ***** processing for shell builtins begins here *****

int
strncmp(const char *p, const char *q, uint n)
{
     2a0:	55                   	push   %ebp
     2a1:	89 e5                	mov    %esp,%ebp
    while(n > 0 && *p && *p == *q)
     2a3:	eb 0c                	jmp    2b1 <strncmp+0x11>
      n--, p++, q++;
     2a5:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
     2a9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     2ad:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
// ***** processing for shell builtins begins here *****

int
strncmp(const char *p, const char *q, uint n)
{
    while(n > 0 && *p && *p == *q)
     2b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     2b5:	74 1a                	je     2d1 <strncmp+0x31>
     2b7:	8b 45 08             	mov    0x8(%ebp),%eax
     2ba:	0f b6 00             	movzbl (%eax),%eax
     2bd:	84 c0                	test   %al,%al
     2bf:	74 10                	je     2d1 <strncmp+0x31>
     2c1:	8b 45 08             	mov    0x8(%ebp),%eax
     2c4:	0f b6 10             	movzbl (%eax),%edx
     2c7:	8b 45 0c             	mov    0xc(%ebp),%eax
     2ca:	0f b6 00             	movzbl (%eax),%eax
     2cd:	38 c2                	cmp    %al,%dl
     2cf:	74 d4                	je     2a5 <strncmp+0x5>
      n--, p++, q++;
    if(n == 0)
     2d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     2d5:	75 07                	jne    2de <strncmp+0x3e>
      return 0;
     2d7:	b8 00 00 00 00       	mov    $0x0,%eax
     2dc:	eb 16                	jmp    2f4 <strncmp+0x54>
    return (uchar)*p - (uchar)*q;
     2de:	8b 45 08             	mov    0x8(%ebp),%eax
     2e1:	0f b6 00             	movzbl (%eax),%eax
     2e4:	0f b6 d0             	movzbl %al,%edx
     2e7:	8b 45 0c             	mov    0xc(%ebp),%eax
     2ea:	0f b6 00             	movzbl (%eax),%eax
     2ed:	0f b6 c0             	movzbl %al,%eax
     2f0:	29 c2                	sub    %eax,%edx
     2f2:	89 d0                	mov    %edx,%eax
}
     2f4:	5d                   	pop    %ebp
     2f5:	c3                   	ret    

000002f6 <makeint>:

int
makeint(char *p)
{
     2f6:	55                   	push   %ebp
     2f7:	89 e5                	mov    %esp,%ebp
     2f9:	83 ec 10             	sub    $0x10,%esp
  int val = 0;
     2fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

  while ((*p >= '0') && (*p <= '9')) {
     303:	eb 23                	jmp    328 <makeint+0x32>
    val = 10*val + (*p-'0');
     305:	8b 55 fc             	mov    -0x4(%ebp),%edx
     308:	89 d0                	mov    %edx,%eax
     30a:	c1 e0 02             	shl    $0x2,%eax
     30d:	01 d0                	add    %edx,%eax
     30f:	01 c0                	add    %eax,%eax
     311:	89 c2                	mov    %eax,%edx
     313:	8b 45 08             	mov    0x8(%ebp),%eax
     316:	0f b6 00             	movzbl (%eax),%eax
     319:	0f be c0             	movsbl %al,%eax
     31c:	83 e8 30             	sub    $0x30,%eax
     31f:	01 d0                	add    %edx,%eax
     321:	89 45 fc             	mov    %eax,-0x4(%ebp)
    ++p;
     324:	83 45 08 01          	addl   $0x1,0x8(%ebp)
int
makeint(char *p)
{
  int val = 0;

  while ((*p >= '0') && (*p <= '9')) {
     328:	8b 45 08             	mov    0x8(%ebp),%eax
     32b:	0f b6 00             	movzbl (%eax),%eax
     32e:	3c 2f                	cmp    $0x2f,%al
     330:	7e 0a                	jle    33c <makeint+0x46>
     332:	8b 45 08             	mov    0x8(%ebp),%eax
     335:	0f b6 00             	movzbl (%eax),%eax
     338:	3c 39                	cmp    $0x39,%al
     33a:	7e c9                	jle    305 <makeint+0xf>
    val = 10*val + (*p-'0');
    ++p;
  }
  return val;
     33c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     33f:	c9                   	leave  
     340:	c3                   	ret    

00000341 <setbuiltin>:

int
setbuiltin(char *p)
{
     341:	55                   	push   %ebp
     342:	89 e5                	mov    %esp,%ebp
     344:	83 ec 18             	sub    $0x18,%esp
  int i;

  p += strlen("_set");
     347:	83 ec 0c             	sub    $0xc,%esp
     34a:	68 cb 17 00 00       	push   $0x17cb
     34f:	e8 ba 0c 00 00       	call   100e <strlen>
     354:	83 c4 10             	add    $0x10,%esp
     357:	01 45 08             	add    %eax,0x8(%ebp)
  while (strncmp(p, " ", 1) == 0) p++; // chomp spaces
     35a:	eb 04                	jmp    360 <setbuiltin+0x1f>
     35c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     360:	83 ec 04             	sub    $0x4,%esp
     363:	6a 01                	push   $0x1
     365:	68 d0 17 00 00       	push   $0x17d0
     36a:	ff 75 08             	pushl  0x8(%ebp)
     36d:	e8 2e ff ff ff       	call   2a0 <strncmp>
     372:	83 c4 10             	add    $0x10,%esp
     375:	85 c0                	test   %eax,%eax
     377:	74 e3                	je     35c <setbuiltin+0x1b>
  if (strncmp("uid", p, 3) == 0) {
     379:	83 ec 04             	sub    $0x4,%esp
     37c:	6a 03                	push   $0x3
     37e:	ff 75 08             	pushl  0x8(%ebp)
     381:	68 d2 17 00 00       	push   $0x17d2
     386:	e8 15 ff ff ff       	call   2a0 <strncmp>
     38b:	83 c4 10             	add    $0x10,%esp
     38e:	85 c0                	test   %eax,%eax
     390:	75 57                	jne    3e9 <setbuiltin+0xa8>
    p += strlen("uid");
     392:	83 ec 0c             	sub    $0xc,%esp
     395:	68 d2 17 00 00       	push   $0x17d2
     39a:	e8 6f 0c 00 00       	call   100e <strlen>
     39f:	83 c4 10             	add    $0x10,%esp
     3a2:	01 45 08             	add    %eax,0x8(%ebp)
    while (strncmp(p, " ", 1) == 0) p++; // chomp spaces
     3a5:	eb 04                	jmp    3ab <setbuiltin+0x6a>
     3a7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     3ab:	83 ec 04             	sub    $0x4,%esp
     3ae:	6a 01                	push   $0x1
     3b0:	68 d0 17 00 00       	push   $0x17d0
     3b5:	ff 75 08             	pushl  0x8(%ebp)
     3b8:	e8 e3 fe ff ff       	call   2a0 <strncmp>
     3bd:	83 c4 10             	add    $0x10,%esp
     3c0:	85 c0                	test   %eax,%eax
     3c2:	74 e3                	je     3a7 <setbuiltin+0x66>
    i = makeint(p); // ugly
     3c4:	83 ec 0c             	sub    $0xc,%esp
     3c7:	ff 75 08             	pushl  0x8(%ebp)
     3ca:	e8 27 ff ff ff       	call   2f6 <makeint>
     3cf:	83 c4 10             	add    $0x10,%esp
     3d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return (setuid(i));
     3d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     3d8:	83 ec 0c             	sub    $0xc,%esp
     3db:	50                   	push   %eax
     3dc:	e8 fc 0e 00 00       	call   12dd <setuid>
     3e1:	83 c4 10             	add    $0x10,%esp
     3e4:	e9 84 00 00 00       	jmp    46d <setbuiltin+0x12c>
  } else 
  if (strncmp("gid", p, 3) == 0) {
     3e9:	83 ec 04             	sub    $0x4,%esp
     3ec:	6a 03                	push   $0x3
     3ee:	ff 75 08             	pushl  0x8(%ebp)
     3f1:	68 d6 17 00 00       	push   $0x17d6
     3f6:	e8 a5 fe ff ff       	call   2a0 <strncmp>
     3fb:	83 c4 10             	add    $0x10,%esp
     3fe:	85 c0                	test   %eax,%eax
     400:	75 54                	jne    456 <setbuiltin+0x115>
    p += strlen("gid");
     402:	83 ec 0c             	sub    $0xc,%esp
     405:	68 d6 17 00 00       	push   $0x17d6
     40a:	e8 ff 0b 00 00       	call   100e <strlen>
     40f:	83 c4 10             	add    $0x10,%esp
     412:	01 45 08             	add    %eax,0x8(%ebp)
    while (strncmp(p, " ", 1) == 0) p++; // chomp spaces
     415:	eb 04                	jmp    41b <setbuiltin+0xda>
     417:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     41b:	83 ec 04             	sub    $0x4,%esp
     41e:	6a 01                	push   $0x1
     420:	68 d0 17 00 00       	push   $0x17d0
     425:	ff 75 08             	pushl  0x8(%ebp)
     428:	e8 73 fe ff ff       	call   2a0 <strncmp>
     42d:	83 c4 10             	add    $0x10,%esp
     430:	85 c0                	test   %eax,%eax
     432:	74 e3                	je     417 <setbuiltin+0xd6>
    i = makeint(p); // ugly
     434:	83 ec 0c             	sub    $0xc,%esp
     437:	ff 75 08             	pushl  0x8(%ebp)
     43a:	e8 b7 fe ff ff       	call   2f6 <makeint>
     43f:	83 c4 10             	add    $0x10,%esp
     442:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return (setgid(i));
     445:	8b 45 f4             	mov    -0xc(%ebp),%eax
     448:	83 ec 0c             	sub    $0xc,%esp
     44b:	50                   	push   %eax
     44c:	e8 94 0e 00 00       	call   12e5 <setgid>
     451:	83 c4 10             	add    $0x10,%esp
     454:	eb 17                	jmp    46d <setbuiltin+0x12c>
  }
  printf(2, "Invalid _set parameter\n");
     456:	83 ec 08             	sub    $0x8,%esp
     459:	68 da 17 00 00       	push   $0x17da
     45e:	6a 02                	push   $0x2
     460:	e8 67 0f 00 00       	call   13cc <printf>
     465:	83 c4 10             	add    $0x10,%esp
  return -1;
     468:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     46d:	c9                   	leave  
     46e:	c3                   	ret    

0000046f <getbuiltin>:

int
getbuiltin(char *p)
{
     46f:	55                   	push   %ebp
     470:	89 e5                	mov    %esp,%ebp
     472:	83 ec 08             	sub    $0x8,%esp
  p += strlen("_get");
     475:	83 ec 0c             	sub    $0xc,%esp
     478:	68 f2 17 00 00       	push   $0x17f2
     47d:	e8 8c 0b 00 00       	call   100e <strlen>
     482:	83 c4 10             	add    $0x10,%esp
     485:	01 45 08             	add    %eax,0x8(%ebp)
  while (strncmp(p, " ", 1) == 0) p++; // chomp spaces
     488:	eb 04                	jmp    48e <getbuiltin+0x1f>
     48a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     48e:	83 ec 04             	sub    $0x4,%esp
     491:	6a 01                	push   $0x1
     493:	68 d0 17 00 00       	push   $0x17d0
     498:	ff 75 08             	pushl  0x8(%ebp)
     49b:	e8 00 fe ff ff       	call   2a0 <strncmp>
     4a0:	83 c4 10             	add    $0x10,%esp
     4a3:	85 c0                	test   %eax,%eax
     4a5:	74 e3                	je     48a <getbuiltin+0x1b>
  if (strncmp("uid", p, 3) == 0) {
     4a7:	83 ec 04             	sub    $0x4,%esp
     4aa:	6a 03                	push   $0x3
     4ac:	ff 75 08             	pushl  0x8(%ebp)
     4af:	68 d2 17 00 00       	push   $0x17d2
     4b4:	e8 e7 fd ff ff       	call   2a0 <strncmp>
     4b9:	83 c4 10             	add    $0x10,%esp
     4bc:	85 c0                	test   %eax,%eax
     4be:	75 1f                	jne    4df <getbuiltin+0x70>
    printf(2, "%d\n", getuid());
     4c0:	e8 00 0e 00 00       	call   12c5 <getuid>
     4c5:	83 ec 04             	sub    $0x4,%esp
     4c8:	50                   	push   %eax
     4c9:	68 f7 17 00 00       	push   $0x17f7
     4ce:	6a 02                	push   $0x2
     4d0:	e8 f7 0e 00 00       	call   13cc <printf>
     4d5:	83 c4 10             	add    $0x10,%esp
    return 0;
     4d8:	b8 00 00 00 00       	mov    $0x0,%eax
     4dd:	eb 4f                	jmp    52e <getbuiltin+0xbf>
  }
  if (strncmp("gid", p, 3) == 0) {
     4df:	83 ec 04             	sub    $0x4,%esp
     4e2:	6a 03                	push   $0x3
     4e4:	ff 75 08             	pushl  0x8(%ebp)
     4e7:	68 d6 17 00 00       	push   $0x17d6
     4ec:	e8 af fd ff ff       	call   2a0 <strncmp>
     4f1:	83 c4 10             	add    $0x10,%esp
     4f4:	85 c0                	test   %eax,%eax
     4f6:	75 1f                	jne    517 <getbuiltin+0xa8>
    printf(2, "%d\n", getgid());
     4f8:	e8 d0 0d 00 00       	call   12cd <getgid>
     4fd:	83 ec 04             	sub    $0x4,%esp
     500:	50                   	push   %eax
     501:	68 f7 17 00 00       	push   $0x17f7
     506:	6a 02                	push   $0x2
     508:	e8 bf 0e 00 00       	call   13cc <printf>
     50d:	83 c4 10             	add    $0x10,%esp
    return 0;
     510:	b8 00 00 00 00       	mov    $0x0,%eax
     515:	eb 17                	jmp    52e <getbuiltin+0xbf>
  }
  printf(2, "Invalid _get parameter\n");
     517:	83 ec 08             	sub    $0x8,%esp
     51a:	68 fb 17 00 00       	push   $0x17fb
     51f:	6a 02                	push   $0x2
     521:	e8 a6 0e 00 00       	call   13cc <printf>
     526:	83 c4 10             	add    $0x10,%esp
  return -1;
     529:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     52e:	c9                   	leave  
     52f:	c3                   	ret    

00000530 <dobuiltin>:
  {"_get", getbuiltin}
};
int FDTcount = sizeof(fdt) / sizeof(fdt[0]); // # entris in FDT

void
dobuiltin(char *cmd) {
     530:	55                   	push   %ebp
     531:	89 e5                	mov    %esp,%ebp
     533:	83 ec 18             	sub    $0x18,%esp
  int i;

  for (i=0; i<FDTcount; i++) 
     536:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     53d:	eb 4f                	jmp    58e <dobuiltin+0x5e>
    if (strncmp(cmd, fdt[i].cmd, strlen(fdt[i].cmd)) == 0) 
     53f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     542:	8b 04 c5 e8 1d 00 00 	mov    0x1de8(,%eax,8),%eax
     549:	83 ec 0c             	sub    $0xc,%esp
     54c:	50                   	push   %eax
     54d:	e8 bc 0a 00 00       	call   100e <strlen>
     552:	83 c4 10             	add    $0x10,%esp
     555:	89 c2                	mov    %eax,%edx
     557:	8b 45 f4             	mov    -0xc(%ebp),%eax
     55a:	8b 04 c5 e8 1d 00 00 	mov    0x1de8(,%eax,8),%eax
     561:	83 ec 04             	sub    $0x4,%esp
     564:	52                   	push   %edx
     565:	50                   	push   %eax
     566:	ff 75 08             	pushl  0x8(%ebp)
     569:	e8 32 fd ff ff       	call   2a0 <strncmp>
     56e:	83 c4 10             	add    $0x10,%esp
     571:	85 c0                	test   %eax,%eax
     573:	75 15                	jne    58a <dobuiltin+0x5a>
     (*fdt[i].name)(cmd);
     575:	8b 45 f4             	mov    -0xc(%ebp),%eax
     578:	8b 04 c5 ec 1d 00 00 	mov    0x1dec(,%eax,8),%eax
     57f:	83 ec 0c             	sub    $0xc,%esp
     582:	ff 75 08             	pushl  0x8(%ebp)
     585:	ff d0                	call   *%eax
     587:	83 c4 10             	add    $0x10,%esp

void
dobuiltin(char *cmd) {
  int i;

  for (i=0; i<FDTcount; i++) 
     58a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     58e:	a1 f8 1d 00 00       	mov    0x1df8,%eax
     593:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     596:	7c a7                	jl     53f <dobuiltin+0xf>
    if (strncmp(cmd, fdt[i].cmd, strlen(fdt[i].cmd)) == 0) 
     (*fdt[i].name)(cmd);
}
     598:	90                   	nop
     599:	c9                   	leave  
     59a:	c3                   	ret    

0000059b <main>:
// ***** processing for shell builtins ends here *****
#endif

int
main(void)
{
     59b:	8d 4c 24 04          	lea    0x4(%esp),%ecx
     59f:	83 e4 f0             	and    $0xfffffff0,%esp
     5a2:	ff 71 fc             	pushl  -0x4(%ecx)
     5a5:	55                   	push   %ebp
     5a6:	89 e5                	mov    %esp,%ebp
     5a8:	51                   	push   %ecx
     5a9:	83 ec 14             	sub    $0x14,%esp
  static char buf[100];
  int fd;
  
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
     5ac:	eb 16                	jmp    5c4 <main+0x29>
    if(fd >= 3){
     5ae:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
     5b2:	7e 10                	jle    5c4 <main+0x29>
      close(fd);
     5b4:	83 ec 0c             	sub    $0xc,%esp
     5b7:	ff 75 f4             	pushl  -0xc(%ebp)
     5ba:	e8 7e 0c 00 00       	call   123d <close>
     5bf:	83 c4 10             	add    $0x10,%esp
      break;
     5c2:	eb 1b                	jmp    5df <main+0x44>
{
  static char buf[100];
  int fd;
  
  // Assumes three file descriptors open.
  while((fd = open("console", O_RDWR)) >= 0){
     5c4:	83 ec 08             	sub    $0x8,%esp
     5c7:	6a 02                	push   $0x2
     5c9:	68 13 18 00 00       	push   $0x1813
     5ce:	e8 82 0c 00 00       	call   1255 <open>
     5d3:	83 c4 10             	add    $0x10,%esp
     5d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
     5d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     5dd:	79 cf                	jns    5ae <main+0x13>
      break;
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     5df:	e9 94 00 00 00       	jmp    678 <main+0xdd>
// add support for built-ins here. cd is a built-in
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     5e4:	0f b6 05 20 1e 00 00 	movzbl 0x1e20,%eax
     5eb:	3c 63                	cmp    $0x63,%al
     5ed:	75 5f                	jne    64e <main+0xb3>
     5ef:	0f b6 05 21 1e 00 00 	movzbl 0x1e21,%eax
     5f6:	3c 64                	cmp    $0x64,%al
     5f8:	75 54                	jne    64e <main+0xb3>
     5fa:	0f b6 05 22 1e 00 00 	movzbl 0x1e22,%eax
     601:	3c 20                	cmp    $0x20,%al
     603:	75 49                	jne    64e <main+0xb3>
      // Clumsy but will have to do for now.
      // Chdir has no effect on the parent if run in the child.
      buf[strlen(buf)-1] = 0;  // chop \n
     605:	83 ec 0c             	sub    $0xc,%esp
     608:	68 20 1e 00 00       	push   $0x1e20
     60d:	e8 fc 09 00 00       	call   100e <strlen>
     612:	83 c4 10             	add    $0x10,%esp
     615:	83 e8 01             	sub    $0x1,%eax
     618:	c6 80 20 1e 00 00 00 	movb   $0x0,0x1e20(%eax)
      if(chdir(buf+3) < 0)
     61f:	b8 23 1e 00 00       	mov    $0x1e23,%eax
     624:	83 ec 0c             	sub    $0xc,%esp
     627:	50                   	push   %eax
     628:	e8 58 0c 00 00       	call   1285 <chdir>
     62d:	83 c4 10             	add    $0x10,%esp
     630:	85 c0                	test   %eax,%eax
     632:	79 44                	jns    678 <main+0xdd>
        printf(2, "cannot cd %s\n", buf+3);
     634:	b8 23 1e 00 00       	mov    $0x1e23,%eax
     639:	83 ec 04             	sub    $0x4,%esp
     63c:	50                   	push   %eax
     63d:	68 1b 18 00 00       	push   $0x181b
     642:	6a 02                	push   $0x2
     644:	e8 83 0d 00 00       	call   13cc <printf>
     649:	83 c4 10             	add    $0x10,%esp
      continue;
     64c:	eb 2a                	jmp    678 <main+0xdd>
    if (buf[0]=='_') {     // assume it is a builtin command
      dobuiltin(buf);
      continue;
    }
#endif
    if(fork1() == 0)
     64e:	e8 64 00 00 00       	call   6b7 <fork1>
     653:	85 c0                	test   %eax,%eax
     655:	75 1c                	jne    673 <main+0xd8>
      runcmd(parsecmd(buf));
     657:	83 ec 0c             	sub    $0xc,%esp
     65a:	68 20 1e 00 00       	push   $0x1e20
     65f:	e8 ab 03 00 00       	call   a0f <parsecmd>
     664:	83 c4 10             	add    $0x10,%esp
     667:	83 ec 0c             	sub    $0xc,%esp
     66a:	50                   	push   %eax
     66b:	e8 90 f9 ff ff       	call   0 <runcmd>
     670:	83 c4 10             	add    $0x10,%esp
    wait();
     673:	e8 a5 0b 00 00       	call   121d <wait>
      break;
    }
  }
  
  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     678:	83 ec 08             	sub    $0x8,%esp
     67b:	6a 64                	push   $0x64
     67d:	68 20 1e 00 00       	push   $0x1e20
     682:	e8 c4 fb ff ff       	call   24b <getcmd>
     687:	83 c4 10             	add    $0x10,%esp
     68a:	85 c0                	test   %eax,%eax
     68c:	0f 89 52 ff ff ff    	jns    5e4 <main+0x49>
#endif
    if(fork1() == 0)
      runcmd(parsecmd(buf));
    wait();
  }
  exit();
     692:	e8 7e 0b 00 00       	call   1215 <exit>

00000697 <panic>:
}

void
panic(char *s)
{
     697:	55                   	push   %ebp
     698:	89 e5                	mov    %esp,%ebp
     69a:	83 ec 08             	sub    $0x8,%esp
  printf(2, "%s\n", s);
     69d:	83 ec 04             	sub    $0x4,%esp
     6a0:	ff 75 08             	pushl  0x8(%ebp)
     6a3:	68 29 18 00 00       	push   $0x1829
     6a8:	6a 02                	push   $0x2
     6aa:	e8 1d 0d 00 00       	call   13cc <printf>
     6af:	83 c4 10             	add    $0x10,%esp
  exit();
     6b2:	e8 5e 0b 00 00       	call   1215 <exit>

000006b7 <fork1>:
}

int
fork1(void)
{
     6b7:	55                   	push   %ebp
     6b8:	89 e5                	mov    %esp,%ebp
     6ba:	83 ec 18             	sub    $0x18,%esp
  int pid;
  
  pid = fork();
     6bd:	e8 4b 0b 00 00       	call   120d <fork>
     6c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid == -1)
     6c5:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     6c9:	75 10                	jne    6db <fork1+0x24>
    panic("fork");
     6cb:	83 ec 0c             	sub    $0xc,%esp
     6ce:	68 2d 18 00 00       	push   $0x182d
     6d3:	e8 bf ff ff ff       	call   697 <panic>
     6d8:	83 c4 10             	add    $0x10,%esp
  return pid;
     6db:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     6de:	c9                   	leave  
     6df:	c3                   	ret    

000006e0 <execcmd>:

// Constructors

struct cmd*
execcmd(void)
{
     6e0:	55                   	push   %ebp
     6e1:	89 e5                	mov    %esp,%ebp
     6e3:	83 ec 18             	sub    $0x18,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     6e6:	83 ec 0c             	sub    $0xc,%esp
     6e9:	6a 54                	push   $0x54
     6eb:	e8 af 0f 00 00       	call   169f <malloc>
     6f0:	83 c4 10             	add    $0x10,%esp
     6f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     6f6:	83 ec 04             	sub    $0x4,%esp
     6f9:	6a 54                	push   $0x54
     6fb:	6a 00                	push   $0x0
     6fd:	ff 75 f4             	pushl  -0xc(%ebp)
     700:	e8 30 09 00 00       	call   1035 <memset>
     705:	83 c4 10             	add    $0x10,%esp
  cmd->type = EXEC;
     708:	8b 45 f4             	mov    -0xc(%ebp),%eax
     70b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  return (struct cmd*)cmd;
     711:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     714:	c9                   	leave  
     715:	c3                   	ret    

00000716 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     716:	55                   	push   %ebp
     717:	89 e5                	mov    %esp,%ebp
     719:	83 ec 18             	sub    $0x18,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     71c:	83 ec 0c             	sub    $0xc,%esp
     71f:	6a 18                	push   $0x18
     721:	e8 79 0f 00 00       	call   169f <malloc>
     726:	83 c4 10             	add    $0x10,%esp
     729:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     72c:	83 ec 04             	sub    $0x4,%esp
     72f:	6a 18                	push   $0x18
     731:	6a 00                	push   $0x0
     733:	ff 75 f4             	pushl  -0xc(%ebp)
     736:	e8 fa 08 00 00       	call   1035 <memset>
     73b:	83 c4 10             	add    $0x10,%esp
  cmd->type = REDIR;
     73e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     741:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  cmd->cmd = subcmd;
     747:	8b 45 f4             	mov    -0xc(%ebp),%eax
     74a:	8b 55 08             	mov    0x8(%ebp),%edx
     74d:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->file = file;
     750:	8b 45 f4             	mov    -0xc(%ebp),%eax
     753:	8b 55 0c             	mov    0xc(%ebp),%edx
     756:	89 50 08             	mov    %edx,0x8(%eax)
  cmd->efile = efile;
     759:	8b 45 f4             	mov    -0xc(%ebp),%eax
     75c:	8b 55 10             	mov    0x10(%ebp),%edx
     75f:	89 50 0c             	mov    %edx,0xc(%eax)
  cmd->mode = mode;
     762:	8b 45 f4             	mov    -0xc(%ebp),%eax
     765:	8b 55 14             	mov    0x14(%ebp),%edx
     768:	89 50 10             	mov    %edx,0x10(%eax)
  cmd->fd = fd;
     76b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     76e:	8b 55 18             	mov    0x18(%ebp),%edx
     771:	89 50 14             	mov    %edx,0x14(%eax)
  return (struct cmd*)cmd;
     774:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     777:	c9                   	leave  
     778:	c3                   	ret    

00000779 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     779:	55                   	push   %ebp
     77a:	89 e5                	mov    %esp,%ebp
     77c:	83 ec 18             	sub    $0x18,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     77f:	83 ec 0c             	sub    $0xc,%esp
     782:	6a 0c                	push   $0xc
     784:	e8 16 0f 00 00       	call   169f <malloc>
     789:	83 c4 10             	add    $0x10,%esp
     78c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     78f:	83 ec 04             	sub    $0x4,%esp
     792:	6a 0c                	push   $0xc
     794:	6a 00                	push   $0x0
     796:	ff 75 f4             	pushl  -0xc(%ebp)
     799:	e8 97 08 00 00       	call   1035 <memset>
     79e:	83 c4 10             	add    $0x10,%esp
  cmd->type = PIPE;
     7a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7a4:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
  cmd->left = left;
     7aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7ad:	8b 55 08             	mov    0x8(%ebp),%edx
     7b0:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     7b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7b6:	8b 55 0c             	mov    0xc(%ebp),%edx
     7b9:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     7bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     7bf:	c9                   	leave  
     7c0:	c3                   	ret    

000007c1 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     7c1:	55                   	push   %ebp
     7c2:	89 e5                	mov    %esp,%ebp
     7c4:	83 ec 18             	sub    $0x18,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     7c7:	83 ec 0c             	sub    $0xc,%esp
     7ca:	6a 0c                	push   $0xc
     7cc:	e8 ce 0e 00 00       	call   169f <malloc>
     7d1:	83 c4 10             	add    $0x10,%esp
     7d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     7d7:	83 ec 04             	sub    $0x4,%esp
     7da:	6a 0c                	push   $0xc
     7dc:	6a 00                	push   $0x0
     7de:	ff 75 f4             	pushl  -0xc(%ebp)
     7e1:	e8 4f 08 00 00       	call   1035 <memset>
     7e6:	83 c4 10             	add    $0x10,%esp
  cmd->type = LIST;
     7e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7ec:	c7 00 04 00 00 00    	movl   $0x4,(%eax)
  cmd->left = left;
     7f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7f5:	8b 55 08             	mov    0x8(%ebp),%edx
     7f8:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     7fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7fe:	8b 55 0c             	mov    0xc(%ebp),%edx
     801:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     804:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     807:	c9                   	leave  
     808:	c3                   	ret    

00000809 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     809:	55                   	push   %ebp
     80a:	89 e5                	mov    %esp,%ebp
     80c:	83 ec 18             	sub    $0x18,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     80f:	83 ec 0c             	sub    $0xc,%esp
     812:	6a 08                	push   $0x8
     814:	e8 86 0e 00 00       	call   169f <malloc>
     819:	83 c4 10             	add    $0x10,%esp
     81c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     81f:	83 ec 04             	sub    $0x4,%esp
     822:	6a 08                	push   $0x8
     824:	6a 00                	push   $0x0
     826:	ff 75 f4             	pushl  -0xc(%ebp)
     829:	e8 07 08 00 00       	call   1035 <memset>
     82e:	83 c4 10             	add    $0x10,%esp
  cmd->type = BACK;
     831:	8b 45 f4             	mov    -0xc(%ebp),%eax
     834:	c7 00 05 00 00 00    	movl   $0x5,(%eax)
  cmd->cmd = subcmd;
     83a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     83d:	8b 55 08             	mov    0x8(%ebp),%edx
     840:	89 50 04             	mov    %edx,0x4(%eax)
  return (struct cmd*)cmd;
     843:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     846:	c9                   	leave  
     847:	c3                   	ret    

00000848 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     848:	55                   	push   %ebp
     849:	89 e5                	mov    %esp,%ebp
     84b:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int ret;
  
  s = *ps;
     84e:	8b 45 08             	mov    0x8(%ebp),%eax
     851:	8b 00                	mov    (%eax),%eax
     853:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     856:	eb 04                	jmp    85c <gettoken+0x14>
    s++;
     858:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
{
  char *s;
  int ret;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
     85c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     85f:	3b 45 0c             	cmp    0xc(%ebp),%eax
     862:	73 1e                	jae    882 <gettoken+0x3a>
     864:	8b 45 f4             	mov    -0xc(%ebp),%eax
     867:	0f b6 00             	movzbl (%eax),%eax
     86a:	0f be c0             	movsbl %al,%eax
     86d:	83 ec 08             	sub    $0x8,%esp
     870:	50                   	push   %eax
     871:	68 fc 1d 00 00       	push   $0x1dfc
     876:	e8 d4 07 00 00       	call   104f <strchr>
     87b:	83 c4 10             	add    $0x10,%esp
     87e:	85 c0                	test   %eax,%eax
     880:	75 d6                	jne    858 <gettoken+0x10>
    s++;
  if(q)
     882:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     886:	74 08                	je     890 <gettoken+0x48>
    *q = s;
     888:	8b 45 10             	mov    0x10(%ebp),%eax
     88b:	8b 55 f4             	mov    -0xc(%ebp),%edx
     88e:	89 10                	mov    %edx,(%eax)
  ret = *s;
     890:	8b 45 f4             	mov    -0xc(%ebp),%eax
     893:	0f b6 00             	movzbl (%eax),%eax
     896:	0f be c0             	movsbl %al,%eax
     899:	89 45 f0             	mov    %eax,-0x10(%ebp)
  switch(*s){
     89c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     89f:	0f b6 00             	movzbl (%eax),%eax
     8a2:	0f be c0             	movsbl %al,%eax
     8a5:	83 f8 29             	cmp    $0x29,%eax
     8a8:	7f 14                	jg     8be <gettoken+0x76>
     8aa:	83 f8 28             	cmp    $0x28,%eax
     8ad:	7d 28                	jge    8d7 <gettoken+0x8f>
     8af:	85 c0                	test   %eax,%eax
     8b1:	0f 84 94 00 00 00    	je     94b <gettoken+0x103>
     8b7:	83 f8 26             	cmp    $0x26,%eax
     8ba:	74 1b                	je     8d7 <gettoken+0x8f>
     8bc:	eb 3a                	jmp    8f8 <gettoken+0xb0>
     8be:	83 f8 3e             	cmp    $0x3e,%eax
     8c1:	74 1a                	je     8dd <gettoken+0x95>
     8c3:	83 f8 3e             	cmp    $0x3e,%eax
     8c6:	7f 0a                	jg     8d2 <gettoken+0x8a>
     8c8:	83 e8 3b             	sub    $0x3b,%eax
     8cb:	83 f8 01             	cmp    $0x1,%eax
     8ce:	77 28                	ja     8f8 <gettoken+0xb0>
     8d0:	eb 05                	jmp    8d7 <gettoken+0x8f>
     8d2:	83 f8 7c             	cmp    $0x7c,%eax
     8d5:	75 21                	jne    8f8 <gettoken+0xb0>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     8d7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    break;
     8db:	eb 75                	jmp    952 <gettoken+0x10a>
  case '>':
    s++;
     8dd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(*s == '>'){
     8e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8e4:	0f b6 00             	movzbl (%eax),%eax
     8e7:	3c 3e                	cmp    $0x3e,%al
     8e9:	75 63                	jne    94e <gettoken+0x106>
      ret = '+';
     8eb:	c7 45 f0 2b 00 00 00 	movl   $0x2b,-0x10(%ebp)
      s++;
     8f2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    }
    break;
     8f6:	eb 56                	jmp    94e <gettoken+0x106>
  default:
    ret = 'a';
     8f8:	c7 45 f0 61 00 00 00 	movl   $0x61,-0x10(%ebp)
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     8ff:	eb 04                	jmp    905 <gettoken+0xbd>
      s++;
     901:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     905:	8b 45 f4             	mov    -0xc(%ebp),%eax
     908:	3b 45 0c             	cmp    0xc(%ebp),%eax
     90b:	73 44                	jae    951 <gettoken+0x109>
     90d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     910:	0f b6 00             	movzbl (%eax),%eax
     913:	0f be c0             	movsbl %al,%eax
     916:	83 ec 08             	sub    $0x8,%esp
     919:	50                   	push   %eax
     91a:	68 fc 1d 00 00       	push   $0x1dfc
     91f:	e8 2b 07 00 00       	call   104f <strchr>
     924:	83 c4 10             	add    $0x10,%esp
     927:	85 c0                	test   %eax,%eax
     929:	75 26                	jne    951 <gettoken+0x109>
     92b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     92e:	0f b6 00             	movzbl (%eax),%eax
     931:	0f be c0             	movsbl %al,%eax
     934:	83 ec 08             	sub    $0x8,%esp
     937:	50                   	push   %eax
     938:	68 04 1e 00 00       	push   $0x1e04
     93d:	e8 0d 07 00 00       	call   104f <strchr>
     942:	83 c4 10             	add    $0x10,%esp
     945:	85 c0                	test   %eax,%eax
     947:	74 b8                	je     901 <gettoken+0xb9>
      s++;
    break;
     949:	eb 06                	jmp    951 <gettoken+0x109>
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
  case 0:
    break;
     94b:	90                   	nop
     94c:	eb 04                	jmp    952 <gettoken+0x10a>
    s++;
    if(*s == '>'){
      ret = '+';
      s++;
    }
    break;
     94e:	90                   	nop
     94f:	eb 01                	jmp    952 <gettoken+0x10a>
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
     951:	90                   	nop
  }
  if(eq)
     952:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     956:	74 0e                	je     966 <gettoken+0x11e>
    *eq = s;
     958:	8b 45 14             	mov    0x14(%ebp),%eax
     95b:	8b 55 f4             	mov    -0xc(%ebp),%edx
     95e:	89 10                	mov    %edx,(%eax)
  
  while(s < es && strchr(whitespace, *s))
     960:	eb 04                	jmp    966 <gettoken+0x11e>
    s++;
     962:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    break;
  }
  if(eq)
    *eq = s;
  
  while(s < es && strchr(whitespace, *s))
     966:	8b 45 f4             	mov    -0xc(%ebp),%eax
     969:	3b 45 0c             	cmp    0xc(%ebp),%eax
     96c:	73 1e                	jae    98c <gettoken+0x144>
     96e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     971:	0f b6 00             	movzbl (%eax),%eax
     974:	0f be c0             	movsbl %al,%eax
     977:	83 ec 08             	sub    $0x8,%esp
     97a:	50                   	push   %eax
     97b:	68 fc 1d 00 00       	push   $0x1dfc
     980:	e8 ca 06 00 00       	call   104f <strchr>
     985:	83 c4 10             	add    $0x10,%esp
     988:	85 c0                	test   %eax,%eax
     98a:	75 d6                	jne    962 <gettoken+0x11a>
    s++;
  *ps = s;
     98c:	8b 45 08             	mov    0x8(%ebp),%eax
     98f:	8b 55 f4             	mov    -0xc(%ebp),%edx
     992:	89 10                	mov    %edx,(%eax)
  return ret;
     994:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     997:	c9                   	leave  
     998:	c3                   	ret    

00000999 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     999:	55                   	push   %ebp
     99a:	89 e5                	mov    %esp,%ebp
     99c:	83 ec 18             	sub    $0x18,%esp
  char *s;
  
  s = *ps;
     99f:	8b 45 08             	mov    0x8(%ebp),%eax
     9a2:	8b 00                	mov    (%eax),%eax
     9a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     9a7:	eb 04                	jmp    9ad <peek+0x14>
    s++;
     9a9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
peek(char **ps, char *es, char *toks)
{
  char *s;
  
  s = *ps;
  while(s < es && strchr(whitespace, *s))
     9ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9b0:	3b 45 0c             	cmp    0xc(%ebp),%eax
     9b3:	73 1e                	jae    9d3 <peek+0x3a>
     9b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9b8:	0f b6 00             	movzbl (%eax),%eax
     9bb:	0f be c0             	movsbl %al,%eax
     9be:	83 ec 08             	sub    $0x8,%esp
     9c1:	50                   	push   %eax
     9c2:	68 fc 1d 00 00       	push   $0x1dfc
     9c7:	e8 83 06 00 00       	call   104f <strchr>
     9cc:	83 c4 10             	add    $0x10,%esp
     9cf:	85 c0                	test   %eax,%eax
     9d1:	75 d6                	jne    9a9 <peek+0x10>
    s++;
  *ps = s;
     9d3:	8b 45 08             	mov    0x8(%ebp),%eax
     9d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
     9d9:	89 10                	mov    %edx,(%eax)
  return *s && strchr(toks, *s);
     9db:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9de:	0f b6 00             	movzbl (%eax),%eax
     9e1:	84 c0                	test   %al,%al
     9e3:	74 23                	je     a08 <peek+0x6f>
     9e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9e8:	0f b6 00             	movzbl (%eax),%eax
     9eb:	0f be c0             	movsbl %al,%eax
     9ee:	83 ec 08             	sub    $0x8,%esp
     9f1:	50                   	push   %eax
     9f2:	ff 75 10             	pushl  0x10(%ebp)
     9f5:	e8 55 06 00 00       	call   104f <strchr>
     9fa:	83 c4 10             	add    $0x10,%esp
     9fd:	85 c0                	test   %eax,%eax
     9ff:	74 07                	je     a08 <peek+0x6f>
     a01:	b8 01 00 00 00       	mov    $0x1,%eax
     a06:	eb 05                	jmp    a0d <peek+0x74>
     a08:	b8 00 00 00 00       	mov    $0x0,%eax
}
     a0d:	c9                   	leave  
     a0e:	c3                   	ret    

00000a0f <parsecmd>:
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
     a0f:	55                   	push   %ebp
     a10:	89 e5                	mov    %esp,%ebp
     a12:	53                   	push   %ebx
     a13:	83 ec 14             	sub    $0x14,%esp
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
     a16:	8b 5d 08             	mov    0x8(%ebp),%ebx
     a19:	8b 45 08             	mov    0x8(%ebp),%eax
     a1c:	83 ec 0c             	sub    $0xc,%esp
     a1f:	50                   	push   %eax
     a20:	e8 e9 05 00 00       	call   100e <strlen>
     a25:	83 c4 10             	add    $0x10,%esp
     a28:	01 d8                	add    %ebx,%eax
     a2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cmd = parseline(&s, es);
     a2d:	83 ec 08             	sub    $0x8,%esp
     a30:	ff 75 f4             	pushl  -0xc(%ebp)
     a33:	8d 45 08             	lea    0x8(%ebp),%eax
     a36:	50                   	push   %eax
     a37:	e8 61 00 00 00       	call   a9d <parseline>
     a3c:	83 c4 10             	add    $0x10,%esp
     a3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  peek(&s, es, "");
     a42:	83 ec 04             	sub    $0x4,%esp
     a45:	68 32 18 00 00       	push   $0x1832
     a4a:	ff 75 f4             	pushl  -0xc(%ebp)
     a4d:	8d 45 08             	lea    0x8(%ebp),%eax
     a50:	50                   	push   %eax
     a51:	e8 43 ff ff ff       	call   999 <peek>
     a56:	83 c4 10             	add    $0x10,%esp
  if(s != es){
     a59:	8b 45 08             	mov    0x8(%ebp),%eax
     a5c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     a5f:	74 26                	je     a87 <parsecmd+0x78>
    printf(2, "leftovers: %s\n", s);
     a61:	8b 45 08             	mov    0x8(%ebp),%eax
     a64:	83 ec 04             	sub    $0x4,%esp
     a67:	50                   	push   %eax
     a68:	68 33 18 00 00       	push   $0x1833
     a6d:	6a 02                	push   $0x2
     a6f:	e8 58 09 00 00       	call   13cc <printf>
     a74:	83 c4 10             	add    $0x10,%esp
    panic("syntax");
     a77:	83 ec 0c             	sub    $0xc,%esp
     a7a:	68 42 18 00 00       	push   $0x1842
     a7f:	e8 13 fc ff ff       	call   697 <panic>
     a84:	83 c4 10             	add    $0x10,%esp
  }
  nulterminate(cmd);
     a87:	83 ec 0c             	sub    $0xc,%esp
     a8a:	ff 75 f0             	pushl  -0x10(%ebp)
     a8d:	e8 eb 03 00 00       	call   e7d <nulterminate>
     a92:	83 c4 10             	add    $0x10,%esp
  return cmd;
     a95:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     a98:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     a9b:	c9                   	leave  
     a9c:	c3                   	ret    

00000a9d <parseline>:

struct cmd*
parseline(char **ps, char *es)
{
     a9d:	55                   	push   %ebp
     a9e:	89 e5                	mov    %esp,%ebp
     aa0:	83 ec 18             	sub    $0x18,%esp
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
     aa3:	83 ec 08             	sub    $0x8,%esp
     aa6:	ff 75 0c             	pushl  0xc(%ebp)
     aa9:	ff 75 08             	pushl  0x8(%ebp)
     aac:	e8 99 00 00 00       	call   b4a <parsepipe>
     ab1:	83 c4 10             	add    $0x10,%esp
     ab4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(peek(ps, es, "&")){
     ab7:	eb 23                	jmp    adc <parseline+0x3f>
    gettoken(ps, es, 0, 0);
     ab9:	6a 00                	push   $0x0
     abb:	6a 00                	push   $0x0
     abd:	ff 75 0c             	pushl  0xc(%ebp)
     ac0:	ff 75 08             	pushl  0x8(%ebp)
     ac3:	e8 80 fd ff ff       	call   848 <gettoken>
     ac8:	83 c4 10             	add    $0x10,%esp
    cmd = backcmd(cmd);
     acb:	83 ec 0c             	sub    $0xc,%esp
     ace:	ff 75 f4             	pushl  -0xc(%ebp)
     ad1:	e8 33 fd ff ff       	call   809 <backcmd>
     ad6:	83 c4 10             	add    $0x10,%esp
     ad9:	89 45 f4             	mov    %eax,-0xc(%ebp)
parseline(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
  while(peek(ps, es, "&")){
     adc:	83 ec 04             	sub    $0x4,%esp
     adf:	68 49 18 00 00       	push   $0x1849
     ae4:	ff 75 0c             	pushl  0xc(%ebp)
     ae7:	ff 75 08             	pushl  0x8(%ebp)
     aea:	e8 aa fe ff ff       	call   999 <peek>
     aef:	83 c4 10             	add    $0x10,%esp
     af2:	85 c0                	test   %eax,%eax
     af4:	75 c3                	jne    ab9 <parseline+0x1c>
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
     af6:	83 ec 04             	sub    $0x4,%esp
     af9:	68 4b 18 00 00       	push   $0x184b
     afe:	ff 75 0c             	pushl  0xc(%ebp)
     b01:	ff 75 08             	pushl  0x8(%ebp)
     b04:	e8 90 fe ff ff       	call   999 <peek>
     b09:	83 c4 10             	add    $0x10,%esp
     b0c:	85 c0                	test   %eax,%eax
     b0e:	74 35                	je     b45 <parseline+0xa8>
    gettoken(ps, es, 0, 0);
     b10:	6a 00                	push   $0x0
     b12:	6a 00                	push   $0x0
     b14:	ff 75 0c             	pushl  0xc(%ebp)
     b17:	ff 75 08             	pushl  0x8(%ebp)
     b1a:	e8 29 fd ff ff       	call   848 <gettoken>
     b1f:	83 c4 10             	add    $0x10,%esp
    cmd = listcmd(cmd, parseline(ps, es));
     b22:	83 ec 08             	sub    $0x8,%esp
     b25:	ff 75 0c             	pushl  0xc(%ebp)
     b28:	ff 75 08             	pushl  0x8(%ebp)
     b2b:	e8 6d ff ff ff       	call   a9d <parseline>
     b30:	83 c4 10             	add    $0x10,%esp
     b33:	83 ec 08             	sub    $0x8,%esp
     b36:	50                   	push   %eax
     b37:	ff 75 f4             	pushl  -0xc(%ebp)
     b3a:	e8 82 fc ff ff       	call   7c1 <listcmd>
     b3f:	83 c4 10             	add    $0x10,%esp
     b42:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     b48:	c9                   	leave  
     b49:	c3                   	ret    

00000b4a <parsepipe>:

struct cmd*
parsepipe(char **ps, char *es)
{
     b4a:	55                   	push   %ebp
     b4b:	89 e5                	mov    %esp,%ebp
     b4d:	83 ec 18             	sub    $0x18,%esp
  struct cmd *cmd;

  cmd = parseexec(ps, es);
     b50:	83 ec 08             	sub    $0x8,%esp
     b53:	ff 75 0c             	pushl  0xc(%ebp)
     b56:	ff 75 08             	pushl  0x8(%ebp)
     b59:	e8 ec 01 00 00       	call   d4a <parseexec>
     b5e:	83 c4 10             	add    $0x10,%esp
     b61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(peek(ps, es, "|")){
     b64:	83 ec 04             	sub    $0x4,%esp
     b67:	68 4d 18 00 00       	push   $0x184d
     b6c:	ff 75 0c             	pushl  0xc(%ebp)
     b6f:	ff 75 08             	pushl  0x8(%ebp)
     b72:	e8 22 fe ff ff       	call   999 <peek>
     b77:	83 c4 10             	add    $0x10,%esp
     b7a:	85 c0                	test   %eax,%eax
     b7c:	74 35                	je     bb3 <parsepipe+0x69>
    gettoken(ps, es, 0, 0);
     b7e:	6a 00                	push   $0x0
     b80:	6a 00                	push   $0x0
     b82:	ff 75 0c             	pushl  0xc(%ebp)
     b85:	ff 75 08             	pushl  0x8(%ebp)
     b88:	e8 bb fc ff ff       	call   848 <gettoken>
     b8d:	83 c4 10             	add    $0x10,%esp
    cmd = pipecmd(cmd, parsepipe(ps, es));
     b90:	83 ec 08             	sub    $0x8,%esp
     b93:	ff 75 0c             	pushl  0xc(%ebp)
     b96:	ff 75 08             	pushl  0x8(%ebp)
     b99:	e8 ac ff ff ff       	call   b4a <parsepipe>
     b9e:	83 c4 10             	add    $0x10,%esp
     ba1:	83 ec 08             	sub    $0x8,%esp
     ba4:	50                   	push   %eax
     ba5:	ff 75 f4             	pushl  -0xc(%ebp)
     ba8:	e8 cc fb ff ff       	call   779 <pipecmd>
     bad:	83 c4 10             	add    $0x10,%esp
     bb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     bb6:	c9                   	leave  
     bb7:	c3                   	ret    

00000bb8 <parseredirs>:

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     bb8:	55                   	push   %ebp
     bb9:	89 e5                	mov    %esp,%ebp
     bbb:	83 ec 18             	sub    $0x18,%esp
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     bbe:	e9 b6 00 00 00       	jmp    c79 <parseredirs+0xc1>
    tok = gettoken(ps, es, 0, 0);
     bc3:	6a 00                	push   $0x0
     bc5:	6a 00                	push   $0x0
     bc7:	ff 75 10             	pushl  0x10(%ebp)
     bca:	ff 75 0c             	pushl  0xc(%ebp)
     bcd:	e8 76 fc ff ff       	call   848 <gettoken>
     bd2:	83 c4 10             	add    $0x10,%esp
     bd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(gettoken(ps, es, &q, &eq) != 'a')
     bd8:	8d 45 ec             	lea    -0x14(%ebp),%eax
     bdb:	50                   	push   %eax
     bdc:	8d 45 f0             	lea    -0x10(%ebp),%eax
     bdf:	50                   	push   %eax
     be0:	ff 75 10             	pushl  0x10(%ebp)
     be3:	ff 75 0c             	pushl  0xc(%ebp)
     be6:	e8 5d fc ff ff       	call   848 <gettoken>
     beb:	83 c4 10             	add    $0x10,%esp
     bee:	83 f8 61             	cmp    $0x61,%eax
     bf1:	74 10                	je     c03 <parseredirs+0x4b>
      panic("missing file for redirection");
     bf3:	83 ec 0c             	sub    $0xc,%esp
     bf6:	68 4f 18 00 00       	push   $0x184f
     bfb:	e8 97 fa ff ff       	call   697 <panic>
     c00:	83 c4 10             	add    $0x10,%esp
    switch(tok){
     c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c06:	83 f8 3c             	cmp    $0x3c,%eax
     c09:	74 0c                	je     c17 <parseredirs+0x5f>
     c0b:	83 f8 3e             	cmp    $0x3e,%eax
     c0e:	74 26                	je     c36 <parseredirs+0x7e>
     c10:	83 f8 2b             	cmp    $0x2b,%eax
     c13:	74 43                	je     c58 <parseredirs+0xa0>
     c15:	eb 62                	jmp    c79 <parseredirs+0xc1>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     c17:	8b 55 ec             	mov    -0x14(%ebp),%edx
     c1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c1d:	83 ec 0c             	sub    $0xc,%esp
     c20:	6a 00                	push   $0x0
     c22:	6a 00                	push   $0x0
     c24:	52                   	push   %edx
     c25:	50                   	push   %eax
     c26:	ff 75 08             	pushl  0x8(%ebp)
     c29:	e8 e8 fa ff ff       	call   716 <redircmd>
     c2e:	83 c4 20             	add    $0x20,%esp
     c31:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     c34:	eb 43                	jmp    c79 <parseredirs+0xc1>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     c36:	8b 55 ec             	mov    -0x14(%ebp),%edx
     c39:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c3c:	83 ec 0c             	sub    $0xc,%esp
     c3f:	6a 01                	push   $0x1
     c41:	68 01 02 00 00       	push   $0x201
     c46:	52                   	push   %edx
     c47:	50                   	push   %eax
     c48:	ff 75 08             	pushl  0x8(%ebp)
     c4b:	e8 c6 fa ff ff       	call   716 <redircmd>
     c50:	83 c4 20             	add    $0x20,%esp
     c53:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     c56:	eb 21                	jmp    c79 <parseredirs+0xc1>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     c58:	8b 55 ec             	mov    -0x14(%ebp),%edx
     c5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c5e:	83 ec 0c             	sub    $0xc,%esp
     c61:	6a 01                	push   $0x1
     c63:	68 01 02 00 00       	push   $0x201
     c68:	52                   	push   %edx
     c69:	50                   	push   %eax
     c6a:	ff 75 08             	pushl  0x8(%ebp)
     c6d:	e8 a4 fa ff ff       	call   716 <redircmd>
     c72:	83 c4 20             	add    $0x20,%esp
     c75:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     c78:	90                   	nop
parseredirs(struct cmd *cmd, char **ps, char *es)
{
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     c79:	83 ec 04             	sub    $0x4,%esp
     c7c:	68 6c 18 00 00       	push   $0x186c
     c81:	ff 75 10             	pushl  0x10(%ebp)
     c84:	ff 75 0c             	pushl  0xc(%ebp)
     c87:	e8 0d fd ff ff       	call   999 <peek>
     c8c:	83 c4 10             	add    $0x10,%esp
     c8f:	85 c0                	test   %eax,%eax
     c91:	0f 85 2c ff ff ff    	jne    bc3 <parseredirs+0xb>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    }
  }
  return cmd;
     c97:	8b 45 08             	mov    0x8(%ebp),%eax
}
     c9a:	c9                   	leave  
     c9b:	c3                   	ret    

00000c9c <parseblock>:

struct cmd*
parseblock(char **ps, char *es)
{
     c9c:	55                   	push   %ebp
     c9d:	89 e5                	mov    %esp,%ebp
     c9f:	83 ec 18             	sub    $0x18,%esp
  struct cmd *cmd;

  if(!peek(ps, es, "("))
     ca2:	83 ec 04             	sub    $0x4,%esp
     ca5:	68 6f 18 00 00       	push   $0x186f
     caa:	ff 75 0c             	pushl  0xc(%ebp)
     cad:	ff 75 08             	pushl  0x8(%ebp)
     cb0:	e8 e4 fc ff ff       	call   999 <peek>
     cb5:	83 c4 10             	add    $0x10,%esp
     cb8:	85 c0                	test   %eax,%eax
     cba:	75 10                	jne    ccc <parseblock+0x30>
    panic("parseblock");
     cbc:	83 ec 0c             	sub    $0xc,%esp
     cbf:	68 71 18 00 00       	push   $0x1871
     cc4:	e8 ce f9 ff ff       	call   697 <panic>
     cc9:	83 c4 10             	add    $0x10,%esp
  gettoken(ps, es, 0, 0);
     ccc:	6a 00                	push   $0x0
     cce:	6a 00                	push   $0x0
     cd0:	ff 75 0c             	pushl  0xc(%ebp)
     cd3:	ff 75 08             	pushl  0x8(%ebp)
     cd6:	e8 6d fb ff ff       	call   848 <gettoken>
     cdb:	83 c4 10             	add    $0x10,%esp
  cmd = parseline(ps, es);
     cde:	83 ec 08             	sub    $0x8,%esp
     ce1:	ff 75 0c             	pushl  0xc(%ebp)
     ce4:	ff 75 08             	pushl  0x8(%ebp)
     ce7:	e8 b1 fd ff ff       	call   a9d <parseline>
     cec:	83 c4 10             	add    $0x10,%esp
     cef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!peek(ps, es, ")"))
     cf2:	83 ec 04             	sub    $0x4,%esp
     cf5:	68 7c 18 00 00       	push   $0x187c
     cfa:	ff 75 0c             	pushl  0xc(%ebp)
     cfd:	ff 75 08             	pushl  0x8(%ebp)
     d00:	e8 94 fc ff ff       	call   999 <peek>
     d05:	83 c4 10             	add    $0x10,%esp
     d08:	85 c0                	test   %eax,%eax
     d0a:	75 10                	jne    d1c <parseblock+0x80>
    panic("syntax - missing )");
     d0c:	83 ec 0c             	sub    $0xc,%esp
     d0f:	68 7e 18 00 00       	push   $0x187e
     d14:	e8 7e f9 ff ff       	call   697 <panic>
     d19:	83 c4 10             	add    $0x10,%esp
  gettoken(ps, es, 0, 0);
     d1c:	6a 00                	push   $0x0
     d1e:	6a 00                	push   $0x0
     d20:	ff 75 0c             	pushl  0xc(%ebp)
     d23:	ff 75 08             	pushl  0x8(%ebp)
     d26:	e8 1d fb ff ff       	call   848 <gettoken>
     d2b:	83 c4 10             	add    $0x10,%esp
  cmd = parseredirs(cmd, ps, es);
     d2e:	83 ec 04             	sub    $0x4,%esp
     d31:	ff 75 0c             	pushl  0xc(%ebp)
     d34:	ff 75 08             	pushl  0x8(%ebp)
     d37:	ff 75 f4             	pushl  -0xc(%ebp)
     d3a:	e8 79 fe ff ff       	call   bb8 <parseredirs>
     d3f:	83 c4 10             	add    $0x10,%esp
     d42:	89 45 f4             	mov    %eax,-0xc(%ebp)
  return cmd;
     d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     d48:	c9                   	leave  
     d49:	c3                   	ret    

00000d4a <parseexec>:

struct cmd*
parseexec(char **ps, char *es)
{
     d4a:	55                   	push   %ebp
     d4b:	89 e5                	mov    %esp,%ebp
     d4d:	83 ec 28             	sub    $0x28,%esp
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;
  
  if(peek(ps, es, "("))
     d50:	83 ec 04             	sub    $0x4,%esp
     d53:	68 6f 18 00 00       	push   $0x186f
     d58:	ff 75 0c             	pushl  0xc(%ebp)
     d5b:	ff 75 08             	pushl  0x8(%ebp)
     d5e:	e8 36 fc ff ff       	call   999 <peek>
     d63:	83 c4 10             	add    $0x10,%esp
     d66:	85 c0                	test   %eax,%eax
     d68:	74 16                	je     d80 <parseexec+0x36>
    return parseblock(ps, es);
     d6a:	83 ec 08             	sub    $0x8,%esp
     d6d:	ff 75 0c             	pushl  0xc(%ebp)
     d70:	ff 75 08             	pushl  0x8(%ebp)
     d73:	e8 24 ff ff ff       	call   c9c <parseblock>
     d78:	83 c4 10             	add    $0x10,%esp
     d7b:	e9 fb 00 00 00       	jmp    e7b <parseexec+0x131>

  ret = execcmd();
     d80:	e8 5b f9 ff ff       	call   6e0 <execcmd>
     d85:	89 45 f0             	mov    %eax,-0x10(%ebp)
  cmd = (struct execcmd*)ret;
     d88:	8b 45 f0             	mov    -0x10(%ebp),%eax
     d8b:	89 45 ec             	mov    %eax,-0x14(%ebp)

  argc = 0;
     d8e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  ret = parseredirs(ret, ps, es);
     d95:	83 ec 04             	sub    $0x4,%esp
     d98:	ff 75 0c             	pushl  0xc(%ebp)
     d9b:	ff 75 08             	pushl  0x8(%ebp)
     d9e:	ff 75 f0             	pushl  -0x10(%ebp)
     da1:	e8 12 fe ff ff       	call   bb8 <parseredirs>
     da6:	83 c4 10             	add    $0x10,%esp
     da9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while(!peek(ps, es, "|)&;")){
     dac:	e9 87 00 00 00       	jmp    e38 <parseexec+0xee>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     db1:	8d 45 e0             	lea    -0x20(%ebp),%eax
     db4:	50                   	push   %eax
     db5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     db8:	50                   	push   %eax
     db9:	ff 75 0c             	pushl  0xc(%ebp)
     dbc:	ff 75 08             	pushl  0x8(%ebp)
     dbf:	e8 84 fa ff ff       	call   848 <gettoken>
     dc4:	83 c4 10             	add    $0x10,%esp
     dc7:	89 45 e8             	mov    %eax,-0x18(%ebp)
     dca:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     dce:	0f 84 84 00 00 00    	je     e58 <parseexec+0x10e>
      break;
    if(tok != 'a')
     dd4:	83 7d e8 61          	cmpl   $0x61,-0x18(%ebp)
     dd8:	74 10                	je     dea <parseexec+0xa0>
      panic("syntax");
     dda:	83 ec 0c             	sub    $0xc,%esp
     ddd:	68 42 18 00 00       	push   $0x1842
     de2:	e8 b0 f8 ff ff       	call   697 <panic>
     de7:	83 c4 10             	add    $0x10,%esp
    cmd->argv[argc] = q;
     dea:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
     ded:	8b 45 ec             	mov    -0x14(%ebp),%eax
     df0:	8b 55 f4             	mov    -0xc(%ebp),%edx
     df3:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
    cmd->eargv[argc] = eq;
     df7:	8b 55 e0             	mov    -0x20(%ebp),%edx
     dfa:	8b 45 ec             	mov    -0x14(%ebp),%eax
     dfd:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     e00:	83 c1 08             	add    $0x8,%ecx
     e03:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    argc++;
     e07:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(argc >= MAXARGS)
     e0b:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
     e0f:	7e 10                	jle    e21 <parseexec+0xd7>
      panic("too many args");
     e11:	83 ec 0c             	sub    $0xc,%esp
     e14:	68 91 18 00 00       	push   $0x1891
     e19:	e8 79 f8 ff ff       	call   697 <panic>
     e1e:	83 c4 10             	add    $0x10,%esp
    ret = parseredirs(ret, ps, es);
     e21:	83 ec 04             	sub    $0x4,%esp
     e24:	ff 75 0c             	pushl  0xc(%ebp)
     e27:	ff 75 08             	pushl  0x8(%ebp)
     e2a:	ff 75 f0             	pushl  -0x10(%ebp)
     e2d:	e8 86 fd ff ff       	call   bb8 <parseredirs>
     e32:	83 c4 10             	add    $0x10,%esp
     e35:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
     e38:	83 ec 04             	sub    $0x4,%esp
     e3b:	68 9f 18 00 00       	push   $0x189f
     e40:	ff 75 0c             	pushl  0xc(%ebp)
     e43:	ff 75 08             	pushl  0x8(%ebp)
     e46:	e8 4e fb ff ff       	call   999 <peek>
     e4b:	83 c4 10             	add    $0x10,%esp
     e4e:	85 c0                	test   %eax,%eax
     e50:	0f 84 5b ff ff ff    	je     db1 <parseexec+0x67>
     e56:	eb 01                	jmp    e59 <parseexec+0x10f>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
     e58:	90                   	nop
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
     e59:	8b 45 ec             	mov    -0x14(%ebp),%eax
     e5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
     e5f:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
     e66:	00 
  cmd->eargv[argc] = 0;
     e67:	8b 45 ec             	mov    -0x14(%ebp),%eax
     e6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
     e6d:	83 c2 08             	add    $0x8,%edx
     e70:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
     e77:	00 
  return ret;
     e78:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     e7b:	c9                   	leave  
     e7c:	c3                   	ret    

00000e7d <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     e7d:	55                   	push   %ebp
     e7e:	89 e5                	mov    %esp,%ebp
     e80:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     e83:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     e87:	75 0a                	jne    e93 <nulterminate+0x16>
    return 0;
     e89:	b8 00 00 00 00       	mov    $0x0,%eax
     e8e:	e9 e4 00 00 00       	jmp    f77 <nulterminate+0xfa>
  
  switch(cmd->type){
     e93:	8b 45 08             	mov    0x8(%ebp),%eax
     e96:	8b 00                	mov    (%eax),%eax
     e98:	83 f8 05             	cmp    $0x5,%eax
     e9b:	0f 87 d3 00 00 00    	ja     f74 <nulterminate+0xf7>
     ea1:	8b 04 85 a4 18 00 00 	mov    0x18a4(,%eax,4),%eax
     ea8:	ff e0                	jmp    *%eax
  case EXEC:
    ecmd = (struct execcmd*)cmd;
     eaa:	8b 45 08             	mov    0x8(%ebp),%eax
     ead:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for(i=0; ecmd->argv[i]; i++)
     eb0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     eb7:	eb 14                	jmp    ecd <nulterminate+0x50>
      *ecmd->eargv[i] = 0;
     eb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ebc:	8b 55 f4             	mov    -0xc(%ebp),%edx
     ebf:	83 c2 08             	add    $0x8,%edx
     ec2:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
     ec6:	c6 00 00             	movb   $0x0,(%eax)
    return 0;
  
  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     ec9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     ecd:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ed0:	8b 55 f4             	mov    -0xc(%ebp),%edx
     ed3:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
     ed7:	85 c0                	test   %eax,%eax
     ed9:	75 de                	jne    eb9 <nulterminate+0x3c>
      *ecmd->eargv[i] = 0;
    break;
     edb:	e9 94 00 00 00       	jmp    f74 <nulterminate+0xf7>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
     ee0:	8b 45 08             	mov    0x8(%ebp),%eax
     ee3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    nulterminate(rcmd->cmd);
     ee6:	8b 45 ec             	mov    -0x14(%ebp),%eax
     ee9:	8b 40 04             	mov    0x4(%eax),%eax
     eec:	83 ec 0c             	sub    $0xc,%esp
     eef:	50                   	push   %eax
     ef0:	e8 88 ff ff ff       	call   e7d <nulterminate>
     ef5:	83 c4 10             	add    $0x10,%esp
    *rcmd->efile = 0;
     ef8:	8b 45 ec             	mov    -0x14(%ebp),%eax
     efb:	8b 40 0c             	mov    0xc(%eax),%eax
     efe:	c6 00 00             	movb   $0x0,(%eax)
    break;
     f01:	eb 71                	jmp    f74 <nulterminate+0xf7>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     f03:	8b 45 08             	mov    0x8(%ebp),%eax
     f06:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nulterminate(pcmd->left);
     f09:	8b 45 e8             	mov    -0x18(%ebp),%eax
     f0c:	8b 40 04             	mov    0x4(%eax),%eax
     f0f:	83 ec 0c             	sub    $0xc,%esp
     f12:	50                   	push   %eax
     f13:	e8 65 ff ff ff       	call   e7d <nulterminate>
     f18:	83 c4 10             	add    $0x10,%esp
    nulterminate(pcmd->right);
     f1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
     f1e:	8b 40 08             	mov    0x8(%eax),%eax
     f21:	83 ec 0c             	sub    $0xc,%esp
     f24:	50                   	push   %eax
     f25:	e8 53 ff ff ff       	call   e7d <nulterminate>
     f2a:	83 c4 10             	add    $0x10,%esp
    break;
     f2d:	eb 45                	jmp    f74 <nulterminate+0xf7>
    
  case LIST:
    lcmd = (struct listcmd*)cmd;
     f2f:	8b 45 08             	mov    0x8(%ebp),%eax
     f32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nulterminate(lcmd->left);
     f35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     f38:	8b 40 04             	mov    0x4(%eax),%eax
     f3b:	83 ec 0c             	sub    $0xc,%esp
     f3e:	50                   	push   %eax
     f3f:	e8 39 ff ff ff       	call   e7d <nulterminate>
     f44:	83 c4 10             	add    $0x10,%esp
    nulterminate(lcmd->right);
     f47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     f4a:	8b 40 08             	mov    0x8(%eax),%eax
     f4d:	83 ec 0c             	sub    $0xc,%esp
     f50:	50                   	push   %eax
     f51:	e8 27 ff ff ff       	call   e7d <nulterminate>
     f56:	83 c4 10             	add    $0x10,%esp
    break;
     f59:	eb 19                	jmp    f74 <nulterminate+0xf7>

  case BACK:
    bcmd = (struct backcmd*)cmd;
     f5b:	8b 45 08             	mov    0x8(%ebp),%eax
     f5e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nulterminate(bcmd->cmd);
     f61:	8b 45 e0             	mov    -0x20(%ebp),%eax
     f64:	8b 40 04             	mov    0x4(%eax),%eax
     f67:	83 ec 0c             	sub    $0xc,%esp
     f6a:	50                   	push   %eax
     f6b:	e8 0d ff ff ff       	call   e7d <nulterminate>
     f70:	83 c4 10             	add    $0x10,%esp
    break;
     f73:	90                   	nop
  }
  return cmd;
     f74:	8b 45 08             	mov    0x8(%ebp),%eax
}
     f77:	c9                   	leave  
     f78:	c3                   	ret    

00000f79 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     f79:	55                   	push   %ebp
     f7a:	89 e5                	mov    %esp,%ebp
     f7c:	57                   	push   %edi
     f7d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     f7e:	8b 4d 08             	mov    0x8(%ebp),%ecx
     f81:	8b 55 10             	mov    0x10(%ebp),%edx
     f84:	8b 45 0c             	mov    0xc(%ebp),%eax
     f87:	89 cb                	mov    %ecx,%ebx
     f89:	89 df                	mov    %ebx,%edi
     f8b:	89 d1                	mov    %edx,%ecx
     f8d:	fc                   	cld    
     f8e:	f3 aa                	rep stos %al,%es:(%edi)
     f90:	89 ca                	mov    %ecx,%edx
     f92:	89 fb                	mov    %edi,%ebx
     f94:	89 5d 08             	mov    %ebx,0x8(%ebp)
     f97:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     f9a:	90                   	nop
     f9b:	5b                   	pop    %ebx
     f9c:	5f                   	pop    %edi
     f9d:	5d                   	pop    %ebp
     f9e:	c3                   	ret    

00000f9f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     f9f:	55                   	push   %ebp
     fa0:	89 e5                	mov    %esp,%ebp
     fa2:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     fa5:	8b 45 08             	mov    0x8(%ebp),%eax
     fa8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     fab:	90                   	nop
     fac:	8b 45 08             	mov    0x8(%ebp),%eax
     faf:	8d 50 01             	lea    0x1(%eax),%edx
     fb2:	89 55 08             	mov    %edx,0x8(%ebp)
     fb5:	8b 55 0c             	mov    0xc(%ebp),%edx
     fb8:	8d 4a 01             	lea    0x1(%edx),%ecx
     fbb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     fbe:	0f b6 12             	movzbl (%edx),%edx
     fc1:	88 10                	mov    %dl,(%eax)
     fc3:	0f b6 00             	movzbl (%eax),%eax
     fc6:	84 c0                	test   %al,%al
     fc8:	75 e2                	jne    fac <strcpy+0xd>
    ;
  return os;
     fca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     fcd:	c9                   	leave  
     fce:	c3                   	ret    

00000fcf <strcmp>:

int
strcmp(const char *p, const char *q)
{
     fcf:	55                   	push   %ebp
     fd0:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     fd2:	eb 08                	jmp    fdc <strcmp+0xd>
    p++, q++;
     fd4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     fd8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     fdc:	8b 45 08             	mov    0x8(%ebp),%eax
     fdf:	0f b6 00             	movzbl (%eax),%eax
     fe2:	84 c0                	test   %al,%al
     fe4:	74 10                	je     ff6 <strcmp+0x27>
     fe6:	8b 45 08             	mov    0x8(%ebp),%eax
     fe9:	0f b6 10             	movzbl (%eax),%edx
     fec:	8b 45 0c             	mov    0xc(%ebp),%eax
     fef:	0f b6 00             	movzbl (%eax),%eax
     ff2:	38 c2                	cmp    %al,%dl
     ff4:	74 de                	je     fd4 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     ff6:	8b 45 08             	mov    0x8(%ebp),%eax
     ff9:	0f b6 00             	movzbl (%eax),%eax
     ffc:	0f b6 d0             	movzbl %al,%edx
     fff:	8b 45 0c             	mov    0xc(%ebp),%eax
    1002:	0f b6 00             	movzbl (%eax),%eax
    1005:	0f b6 c0             	movzbl %al,%eax
    1008:	29 c2                	sub    %eax,%edx
    100a:	89 d0                	mov    %edx,%eax
}
    100c:	5d                   	pop    %ebp
    100d:	c3                   	ret    

0000100e <strlen>:

uint
strlen(char *s)
{
    100e:	55                   	push   %ebp
    100f:	89 e5                	mov    %esp,%ebp
    1011:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    1014:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    101b:	eb 04                	jmp    1021 <strlen+0x13>
    101d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    1021:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1024:	8b 45 08             	mov    0x8(%ebp),%eax
    1027:	01 d0                	add    %edx,%eax
    1029:	0f b6 00             	movzbl (%eax),%eax
    102c:	84 c0                	test   %al,%al
    102e:	75 ed                	jne    101d <strlen+0xf>
    ;
  return n;
    1030:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1033:	c9                   	leave  
    1034:	c3                   	ret    

00001035 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1035:	55                   	push   %ebp
    1036:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
    1038:	8b 45 10             	mov    0x10(%ebp),%eax
    103b:	50                   	push   %eax
    103c:	ff 75 0c             	pushl  0xc(%ebp)
    103f:	ff 75 08             	pushl  0x8(%ebp)
    1042:	e8 32 ff ff ff       	call   f79 <stosb>
    1047:	83 c4 0c             	add    $0xc,%esp
  return dst;
    104a:	8b 45 08             	mov    0x8(%ebp),%eax
}
    104d:	c9                   	leave  
    104e:	c3                   	ret    

0000104f <strchr>:

char*
strchr(const char *s, char c)
{
    104f:	55                   	push   %ebp
    1050:	89 e5                	mov    %esp,%ebp
    1052:	83 ec 04             	sub    $0x4,%esp
    1055:	8b 45 0c             	mov    0xc(%ebp),%eax
    1058:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    105b:	eb 14                	jmp    1071 <strchr+0x22>
    if(*s == c)
    105d:	8b 45 08             	mov    0x8(%ebp),%eax
    1060:	0f b6 00             	movzbl (%eax),%eax
    1063:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1066:	75 05                	jne    106d <strchr+0x1e>
      return (char*)s;
    1068:	8b 45 08             	mov    0x8(%ebp),%eax
    106b:	eb 13                	jmp    1080 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    106d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1071:	8b 45 08             	mov    0x8(%ebp),%eax
    1074:	0f b6 00             	movzbl (%eax),%eax
    1077:	84 c0                	test   %al,%al
    1079:	75 e2                	jne    105d <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    107b:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1080:	c9                   	leave  
    1081:	c3                   	ret    

00001082 <gets>:

char*
gets(char *buf, int max)
{
    1082:	55                   	push   %ebp
    1083:	89 e5                	mov    %esp,%ebp
    1085:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1088:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    108f:	eb 42                	jmp    10d3 <gets+0x51>
    cc = read(0, &c, 1);
    1091:	83 ec 04             	sub    $0x4,%esp
    1094:	6a 01                	push   $0x1
    1096:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1099:	50                   	push   %eax
    109a:	6a 00                	push   $0x0
    109c:	e8 8c 01 00 00       	call   122d <read>
    10a1:	83 c4 10             	add    $0x10,%esp
    10a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    10a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    10ab:	7e 33                	jle    10e0 <gets+0x5e>
      break;
    buf[i++] = c;
    10ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10b0:	8d 50 01             	lea    0x1(%eax),%edx
    10b3:	89 55 f4             	mov    %edx,-0xc(%ebp)
    10b6:	89 c2                	mov    %eax,%edx
    10b8:	8b 45 08             	mov    0x8(%ebp),%eax
    10bb:	01 c2                	add    %eax,%edx
    10bd:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    10c1:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    10c3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    10c7:	3c 0a                	cmp    $0xa,%al
    10c9:	74 16                	je     10e1 <gets+0x5f>
    10cb:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    10cf:	3c 0d                	cmp    $0xd,%al
    10d1:	74 0e                	je     10e1 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    10d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10d6:	83 c0 01             	add    $0x1,%eax
    10d9:	3b 45 0c             	cmp    0xc(%ebp),%eax
    10dc:	7c b3                	jl     1091 <gets+0xf>
    10de:	eb 01                	jmp    10e1 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    10e0:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    10e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
    10e4:	8b 45 08             	mov    0x8(%ebp),%eax
    10e7:	01 d0                	add    %edx,%eax
    10e9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    10ec:	8b 45 08             	mov    0x8(%ebp),%eax
}
    10ef:	c9                   	leave  
    10f0:	c3                   	ret    

000010f1 <stat>:

int
stat(char *n, struct stat *st)
{
    10f1:	55                   	push   %ebp
    10f2:	89 e5                	mov    %esp,%ebp
    10f4:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    10f7:	83 ec 08             	sub    $0x8,%esp
    10fa:	6a 00                	push   $0x0
    10fc:	ff 75 08             	pushl  0x8(%ebp)
    10ff:	e8 51 01 00 00       	call   1255 <open>
    1104:	83 c4 10             	add    $0x10,%esp
    1107:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    110a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    110e:	79 07                	jns    1117 <stat+0x26>
    return -1;
    1110:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1115:	eb 25                	jmp    113c <stat+0x4b>
  r = fstat(fd, st);
    1117:	83 ec 08             	sub    $0x8,%esp
    111a:	ff 75 0c             	pushl  0xc(%ebp)
    111d:	ff 75 f4             	pushl  -0xc(%ebp)
    1120:	e8 48 01 00 00       	call   126d <fstat>
    1125:	83 c4 10             	add    $0x10,%esp
    1128:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    112b:	83 ec 0c             	sub    $0xc,%esp
    112e:	ff 75 f4             	pushl  -0xc(%ebp)
    1131:	e8 07 01 00 00       	call   123d <close>
    1136:	83 c4 10             	add    $0x10,%esp
  return r;
    1139:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    113c:	c9                   	leave  
    113d:	c3                   	ret    

0000113e <atoi>:

int
atoi(const char *s)
{
    113e:	55                   	push   %ebp
    113f:	89 e5                	mov    %esp,%ebp
    1141:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
    1144:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
    114b:	eb 04                	jmp    1151 <atoi+0x13>
    114d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1151:	8b 45 08             	mov    0x8(%ebp),%eax
    1154:	0f b6 00             	movzbl (%eax),%eax
    1157:	3c 20                	cmp    $0x20,%al
    1159:	74 f2                	je     114d <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
    115b:	8b 45 08             	mov    0x8(%ebp),%eax
    115e:	0f b6 00             	movzbl (%eax),%eax
    1161:	3c 2d                	cmp    $0x2d,%al
    1163:	75 07                	jne    116c <atoi+0x2e>
    1165:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    116a:	eb 05                	jmp    1171 <atoi+0x33>
    116c:	b8 01 00 00 00       	mov    $0x1,%eax
    1171:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
    1174:	8b 45 08             	mov    0x8(%ebp),%eax
    1177:	0f b6 00             	movzbl (%eax),%eax
    117a:	3c 2b                	cmp    $0x2b,%al
    117c:	74 0a                	je     1188 <atoi+0x4a>
    117e:	8b 45 08             	mov    0x8(%ebp),%eax
    1181:	0f b6 00             	movzbl (%eax),%eax
    1184:	3c 2d                	cmp    $0x2d,%al
    1186:	75 2b                	jne    11b3 <atoi+0x75>
    s++;
    1188:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
    118c:	eb 25                	jmp    11b3 <atoi+0x75>
    n = n*10 + *s++ - '0';
    118e:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1191:	89 d0                	mov    %edx,%eax
    1193:	c1 e0 02             	shl    $0x2,%eax
    1196:	01 d0                	add    %edx,%eax
    1198:	01 c0                	add    %eax,%eax
    119a:	89 c1                	mov    %eax,%ecx
    119c:	8b 45 08             	mov    0x8(%ebp),%eax
    119f:	8d 50 01             	lea    0x1(%eax),%edx
    11a2:	89 55 08             	mov    %edx,0x8(%ebp)
    11a5:	0f b6 00             	movzbl (%eax),%eax
    11a8:	0f be c0             	movsbl %al,%eax
    11ab:	01 c8                	add    %ecx,%eax
    11ad:	83 e8 30             	sub    $0x30,%eax
    11b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
    11b3:	8b 45 08             	mov    0x8(%ebp),%eax
    11b6:	0f b6 00             	movzbl (%eax),%eax
    11b9:	3c 2f                	cmp    $0x2f,%al
    11bb:	7e 0a                	jle    11c7 <atoi+0x89>
    11bd:	8b 45 08             	mov    0x8(%ebp),%eax
    11c0:	0f b6 00             	movzbl (%eax),%eax
    11c3:	3c 39                	cmp    $0x39,%al
    11c5:	7e c7                	jle    118e <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
    11c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11ca:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
    11ce:	c9                   	leave  
    11cf:	c3                   	ret    

000011d0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    11d0:	55                   	push   %ebp
    11d1:	89 e5                	mov    %esp,%ebp
    11d3:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    11d6:	8b 45 08             	mov    0x8(%ebp),%eax
    11d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    11dc:	8b 45 0c             	mov    0xc(%ebp),%eax
    11df:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    11e2:	eb 17                	jmp    11fb <memmove+0x2b>
    *dst++ = *src++;
    11e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11e7:	8d 50 01             	lea    0x1(%eax),%edx
    11ea:	89 55 fc             	mov    %edx,-0x4(%ebp)
    11ed:	8b 55 f8             	mov    -0x8(%ebp),%edx
    11f0:	8d 4a 01             	lea    0x1(%edx),%ecx
    11f3:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    11f6:	0f b6 12             	movzbl (%edx),%edx
    11f9:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    11fb:	8b 45 10             	mov    0x10(%ebp),%eax
    11fe:	8d 50 ff             	lea    -0x1(%eax),%edx
    1201:	89 55 10             	mov    %edx,0x10(%ebp)
    1204:	85 c0                	test   %eax,%eax
    1206:	7f dc                	jg     11e4 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    1208:	8b 45 08             	mov    0x8(%ebp),%eax
}
    120b:	c9                   	leave  
    120c:	c3                   	ret    

0000120d <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    120d:	b8 01 00 00 00       	mov    $0x1,%eax
    1212:	cd 40                	int    $0x40
    1214:	c3                   	ret    

00001215 <exit>:
SYSCALL(exit)
    1215:	b8 02 00 00 00       	mov    $0x2,%eax
    121a:	cd 40                	int    $0x40
    121c:	c3                   	ret    

0000121d <wait>:
SYSCALL(wait)
    121d:	b8 03 00 00 00       	mov    $0x3,%eax
    1222:	cd 40                	int    $0x40
    1224:	c3                   	ret    

00001225 <pipe>:
SYSCALL(pipe)
    1225:	b8 04 00 00 00       	mov    $0x4,%eax
    122a:	cd 40                	int    $0x40
    122c:	c3                   	ret    

0000122d <read>:
SYSCALL(read)
    122d:	b8 05 00 00 00       	mov    $0x5,%eax
    1232:	cd 40                	int    $0x40
    1234:	c3                   	ret    

00001235 <write>:
SYSCALL(write)
    1235:	b8 10 00 00 00       	mov    $0x10,%eax
    123a:	cd 40                	int    $0x40
    123c:	c3                   	ret    

0000123d <close>:
SYSCALL(close)
    123d:	b8 15 00 00 00       	mov    $0x15,%eax
    1242:	cd 40                	int    $0x40
    1244:	c3                   	ret    

00001245 <kill>:
SYSCALL(kill)
    1245:	b8 06 00 00 00       	mov    $0x6,%eax
    124a:	cd 40                	int    $0x40
    124c:	c3                   	ret    

0000124d <exec>:
SYSCALL(exec)
    124d:	b8 07 00 00 00       	mov    $0x7,%eax
    1252:	cd 40                	int    $0x40
    1254:	c3                   	ret    

00001255 <open>:
SYSCALL(open)
    1255:	b8 0f 00 00 00       	mov    $0xf,%eax
    125a:	cd 40                	int    $0x40
    125c:	c3                   	ret    

0000125d <mknod>:
SYSCALL(mknod)
    125d:	b8 11 00 00 00       	mov    $0x11,%eax
    1262:	cd 40                	int    $0x40
    1264:	c3                   	ret    

00001265 <unlink>:
SYSCALL(unlink)
    1265:	b8 12 00 00 00       	mov    $0x12,%eax
    126a:	cd 40                	int    $0x40
    126c:	c3                   	ret    

0000126d <fstat>:
SYSCALL(fstat)
    126d:	b8 08 00 00 00       	mov    $0x8,%eax
    1272:	cd 40                	int    $0x40
    1274:	c3                   	ret    

00001275 <link>:
SYSCALL(link)
    1275:	b8 13 00 00 00       	mov    $0x13,%eax
    127a:	cd 40                	int    $0x40
    127c:	c3                   	ret    

0000127d <mkdir>:
SYSCALL(mkdir)
    127d:	b8 14 00 00 00       	mov    $0x14,%eax
    1282:	cd 40                	int    $0x40
    1284:	c3                   	ret    

00001285 <chdir>:
SYSCALL(chdir)
    1285:	b8 09 00 00 00       	mov    $0x9,%eax
    128a:	cd 40                	int    $0x40
    128c:	c3                   	ret    

0000128d <dup>:
SYSCALL(dup)
    128d:	b8 0a 00 00 00       	mov    $0xa,%eax
    1292:	cd 40                	int    $0x40
    1294:	c3                   	ret    

00001295 <getpid>:
SYSCALL(getpid)
    1295:	b8 0b 00 00 00       	mov    $0xb,%eax
    129a:	cd 40                	int    $0x40
    129c:	c3                   	ret    

0000129d <sbrk>:
SYSCALL(sbrk)
    129d:	b8 0c 00 00 00       	mov    $0xc,%eax
    12a2:	cd 40                	int    $0x40
    12a4:	c3                   	ret    

000012a5 <sleep>:
SYSCALL(sleep)
    12a5:	b8 0d 00 00 00       	mov    $0xd,%eax
    12aa:	cd 40                	int    $0x40
    12ac:	c3                   	ret    

000012ad <uptime>:
SYSCALL(uptime)
    12ad:	b8 0e 00 00 00       	mov    $0xe,%eax
    12b2:	cd 40                	int    $0x40
    12b4:	c3                   	ret    

000012b5 <halt>:
SYSCALL(halt)
    12b5:	b8 16 00 00 00       	mov    $0x16,%eax
    12ba:	cd 40                	int    $0x40
    12bc:	c3                   	ret    

000012bd <date>:
SYSCALL(date)
    12bd:	b8 17 00 00 00       	mov    $0x17,%eax
    12c2:	cd 40                	int    $0x40
    12c4:	c3                   	ret    

000012c5 <getuid>:
SYSCALL(getuid)
    12c5:	b8 18 00 00 00       	mov    $0x18,%eax
    12ca:	cd 40                	int    $0x40
    12cc:	c3                   	ret    

000012cd <getgid>:
SYSCALL(getgid)
    12cd:	b8 19 00 00 00       	mov    $0x19,%eax
    12d2:	cd 40                	int    $0x40
    12d4:	c3                   	ret    

000012d5 <getppid>:
SYSCALL(getppid)
    12d5:	b8 1a 00 00 00       	mov    $0x1a,%eax
    12da:	cd 40                	int    $0x40
    12dc:	c3                   	ret    

000012dd <setuid>:
SYSCALL(setuid)
    12dd:	b8 1b 00 00 00       	mov    $0x1b,%eax
    12e2:	cd 40                	int    $0x40
    12e4:	c3                   	ret    

000012e5 <setgid>:
SYSCALL(setgid)
    12e5:	b8 1c 00 00 00       	mov    $0x1c,%eax
    12ea:	cd 40                	int    $0x40
    12ec:	c3                   	ret    

000012ed <getprocs>:
SYSCALL(getprocs)
    12ed:	b8 1d 00 00 00       	mov    $0x1d,%eax
    12f2:	cd 40                	int    $0x40
    12f4:	c3                   	ret    

000012f5 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    12f5:	55                   	push   %ebp
    12f6:	89 e5                	mov    %esp,%ebp
    12f8:	83 ec 18             	sub    $0x18,%esp
    12fb:	8b 45 0c             	mov    0xc(%ebp),%eax
    12fe:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1301:	83 ec 04             	sub    $0x4,%esp
    1304:	6a 01                	push   $0x1
    1306:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1309:	50                   	push   %eax
    130a:	ff 75 08             	pushl  0x8(%ebp)
    130d:	e8 23 ff ff ff       	call   1235 <write>
    1312:	83 c4 10             	add    $0x10,%esp
}
    1315:	90                   	nop
    1316:	c9                   	leave  
    1317:	c3                   	ret    

00001318 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1318:	55                   	push   %ebp
    1319:	89 e5                	mov    %esp,%ebp
    131b:	53                   	push   %ebx
    131c:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    131f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1326:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    132a:	74 17                	je     1343 <printint+0x2b>
    132c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1330:	79 11                	jns    1343 <printint+0x2b>
    neg = 1;
    1332:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    1339:	8b 45 0c             	mov    0xc(%ebp),%eax
    133c:	f7 d8                	neg    %eax
    133e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1341:	eb 06                	jmp    1349 <printint+0x31>
  } else {
    x = xx;
    1343:	8b 45 0c             	mov    0xc(%ebp),%eax
    1346:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    1349:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    1350:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1353:	8d 41 01             	lea    0x1(%ecx),%eax
    1356:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1359:	8b 5d 10             	mov    0x10(%ebp),%ebx
    135c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    135f:	ba 00 00 00 00       	mov    $0x0,%edx
    1364:	f7 f3                	div    %ebx
    1366:	89 d0                	mov    %edx,%eax
    1368:	0f b6 80 0c 1e 00 00 	movzbl 0x1e0c(%eax),%eax
    136f:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    1373:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1376:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1379:	ba 00 00 00 00       	mov    $0x0,%edx
    137e:	f7 f3                	div    %ebx
    1380:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1383:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1387:	75 c7                	jne    1350 <printint+0x38>
  if(neg)
    1389:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    138d:	74 2d                	je     13bc <printint+0xa4>
    buf[i++] = '-';
    138f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1392:	8d 50 01             	lea    0x1(%eax),%edx
    1395:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1398:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    139d:	eb 1d                	jmp    13bc <printint+0xa4>
    putc(fd, buf[i]);
    139f:	8d 55 dc             	lea    -0x24(%ebp),%edx
    13a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13a5:	01 d0                	add    %edx,%eax
    13a7:	0f b6 00             	movzbl (%eax),%eax
    13aa:	0f be c0             	movsbl %al,%eax
    13ad:	83 ec 08             	sub    $0x8,%esp
    13b0:	50                   	push   %eax
    13b1:	ff 75 08             	pushl  0x8(%ebp)
    13b4:	e8 3c ff ff ff       	call   12f5 <putc>
    13b9:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    13bc:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    13c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    13c4:	79 d9                	jns    139f <printint+0x87>
    putc(fd, buf[i]);
}
    13c6:	90                   	nop
    13c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    13ca:	c9                   	leave  
    13cb:	c3                   	ret    

000013cc <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    13cc:	55                   	push   %ebp
    13cd:	89 e5                	mov    %esp,%ebp
    13cf:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    13d2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    13d9:	8d 45 0c             	lea    0xc(%ebp),%eax
    13dc:	83 c0 04             	add    $0x4,%eax
    13df:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    13e2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    13e9:	e9 59 01 00 00       	jmp    1547 <printf+0x17b>
    c = fmt[i] & 0xff;
    13ee:	8b 55 0c             	mov    0xc(%ebp),%edx
    13f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    13f4:	01 d0                	add    %edx,%eax
    13f6:	0f b6 00             	movzbl (%eax),%eax
    13f9:	0f be c0             	movsbl %al,%eax
    13fc:	25 ff 00 00 00       	and    $0xff,%eax
    1401:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1404:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1408:	75 2c                	jne    1436 <printf+0x6a>
      if(c == '%'){
    140a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    140e:	75 0c                	jne    141c <printf+0x50>
        state = '%';
    1410:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1417:	e9 27 01 00 00       	jmp    1543 <printf+0x177>
      } else {
        putc(fd, c);
    141c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    141f:	0f be c0             	movsbl %al,%eax
    1422:	83 ec 08             	sub    $0x8,%esp
    1425:	50                   	push   %eax
    1426:	ff 75 08             	pushl  0x8(%ebp)
    1429:	e8 c7 fe ff ff       	call   12f5 <putc>
    142e:	83 c4 10             	add    $0x10,%esp
    1431:	e9 0d 01 00 00       	jmp    1543 <printf+0x177>
      }
    } else if(state == '%'){
    1436:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    143a:	0f 85 03 01 00 00    	jne    1543 <printf+0x177>
      if(c == 'd'){
    1440:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    1444:	75 1e                	jne    1464 <printf+0x98>
        printint(fd, *ap, 10, 1);
    1446:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1449:	8b 00                	mov    (%eax),%eax
    144b:	6a 01                	push   $0x1
    144d:	6a 0a                	push   $0xa
    144f:	50                   	push   %eax
    1450:	ff 75 08             	pushl  0x8(%ebp)
    1453:	e8 c0 fe ff ff       	call   1318 <printint>
    1458:	83 c4 10             	add    $0x10,%esp
        ap++;
    145b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    145f:	e9 d8 00 00 00       	jmp    153c <printf+0x170>
      } else if(c == 'x' || c == 'p'){
    1464:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1468:	74 06                	je     1470 <printf+0xa4>
    146a:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    146e:	75 1e                	jne    148e <printf+0xc2>
        printint(fd, *ap, 16, 0);
    1470:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1473:	8b 00                	mov    (%eax),%eax
    1475:	6a 00                	push   $0x0
    1477:	6a 10                	push   $0x10
    1479:	50                   	push   %eax
    147a:	ff 75 08             	pushl  0x8(%ebp)
    147d:	e8 96 fe ff ff       	call   1318 <printint>
    1482:	83 c4 10             	add    $0x10,%esp
        ap++;
    1485:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1489:	e9 ae 00 00 00       	jmp    153c <printf+0x170>
      } else if(c == 's'){
    148e:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1492:	75 43                	jne    14d7 <printf+0x10b>
        s = (char*)*ap;
    1494:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1497:	8b 00                	mov    (%eax),%eax
    1499:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    149c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    14a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    14a4:	75 25                	jne    14cb <printf+0xff>
          s = "(null)";
    14a6:	c7 45 f4 bc 18 00 00 	movl   $0x18bc,-0xc(%ebp)
        while(*s != 0){
    14ad:	eb 1c                	jmp    14cb <printf+0xff>
          putc(fd, *s);
    14af:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14b2:	0f b6 00             	movzbl (%eax),%eax
    14b5:	0f be c0             	movsbl %al,%eax
    14b8:	83 ec 08             	sub    $0x8,%esp
    14bb:	50                   	push   %eax
    14bc:	ff 75 08             	pushl  0x8(%ebp)
    14bf:	e8 31 fe ff ff       	call   12f5 <putc>
    14c4:	83 c4 10             	add    $0x10,%esp
          s++;
    14c7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    14cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14ce:	0f b6 00             	movzbl (%eax),%eax
    14d1:	84 c0                	test   %al,%al
    14d3:	75 da                	jne    14af <printf+0xe3>
    14d5:	eb 65                	jmp    153c <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    14d7:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    14db:	75 1d                	jne    14fa <printf+0x12e>
        putc(fd, *ap);
    14dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
    14e0:	8b 00                	mov    (%eax),%eax
    14e2:	0f be c0             	movsbl %al,%eax
    14e5:	83 ec 08             	sub    $0x8,%esp
    14e8:	50                   	push   %eax
    14e9:	ff 75 08             	pushl  0x8(%ebp)
    14ec:	e8 04 fe ff ff       	call   12f5 <putc>
    14f1:	83 c4 10             	add    $0x10,%esp
        ap++;
    14f4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    14f8:	eb 42                	jmp    153c <printf+0x170>
      } else if(c == '%'){
    14fa:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    14fe:	75 17                	jne    1517 <printf+0x14b>
        putc(fd, c);
    1500:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1503:	0f be c0             	movsbl %al,%eax
    1506:	83 ec 08             	sub    $0x8,%esp
    1509:	50                   	push   %eax
    150a:	ff 75 08             	pushl  0x8(%ebp)
    150d:	e8 e3 fd ff ff       	call   12f5 <putc>
    1512:	83 c4 10             	add    $0x10,%esp
    1515:	eb 25                	jmp    153c <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1517:	83 ec 08             	sub    $0x8,%esp
    151a:	6a 25                	push   $0x25
    151c:	ff 75 08             	pushl  0x8(%ebp)
    151f:	e8 d1 fd ff ff       	call   12f5 <putc>
    1524:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
    1527:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    152a:	0f be c0             	movsbl %al,%eax
    152d:	83 ec 08             	sub    $0x8,%esp
    1530:	50                   	push   %eax
    1531:	ff 75 08             	pushl  0x8(%ebp)
    1534:	e8 bc fd ff ff       	call   12f5 <putc>
    1539:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    153c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1543:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1547:	8b 55 0c             	mov    0xc(%ebp),%edx
    154a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    154d:	01 d0                	add    %edx,%eax
    154f:	0f b6 00             	movzbl (%eax),%eax
    1552:	84 c0                	test   %al,%al
    1554:	0f 85 94 fe ff ff    	jne    13ee <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    155a:	90                   	nop
    155b:	c9                   	leave  
    155c:	c3                   	ret    

0000155d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    155d:	55                   	push   %ebp
    155e:	89 e5                	mov    %esp,%ebp
    1560:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1563:	8b 45 08             	mov    0x8(%ebp),%eax
    1566:	83 e8 08             	sub    $0x8,%eax
    1569:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    156c:	a1 8c 1e 00 00       	mov    0x1e8c,%eax
    1571:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1574:	eb 24                	jmp    159a <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1576:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1579:	8b 00                	mov    (%eax),%eax
    157b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    157e:	77 12                	ja     1592 <free+0x35>
    1580:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1583:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1586:	77 24                	ja     15ac <free+0x4f>
    1588:	8b 45 fc             	mov    -0x4(%ebp),%eax
    158b:	8b 00                	mov    (%eax),%eax
    158d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1590:	77 1a                	ja     15ac <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1592:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1595:	8b 00                	mov    (%eax),%eax
    1597:	89 45 fc             	mov    %eax,-0x4(%ebp)
    159a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    159d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    15a0:	76 d4                	jbe    1576 <free+0x19>
    15a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15a5:	8b 00                	mov    (%eax),%eax
    15a7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    15aa:	76 ca                	jbe    1576 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    15ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
    15af:	8b 40 04             	mov    0x4(%eax),%eax
    15b2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    15b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    15bc:	01 c2                	add    %eax,%edx
    15be:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15c1:	8b 00                	mov    (%eax),%eax
    15c3:	39 c2                	cmp    %eax,%edx
    15c5:	75 24                	jne    15eb <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    15c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    15ca:	8b 50 04             	mov    0x4(%eax),%edx
    15cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15d0:	8b 00                	mov    (%eax),%eax
    15d2:	8b 40 04             	mov    0x4(%eax),%eax
    15d5:	01 c2                	add    %eax,%edx
    15d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    15da:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    15dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15e0:	8b 00                	mov    (%eax),%eax
    15e2:	8b 10                	mov    (%eax),%edx
    15e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    15e7:	89 10                	mov    %edx,(%eax)
    15e9:	eb 0a                	jmp    15f5 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    15eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15ee:	8b 10                	mov    (%eax),%edx
    15f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
    15f3:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    15f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    15f8:	8b 40 04             	mov    0x4(%eax),%eax
    15fb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1602:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1605:	01 d0                	add    %edx,%eax
    1607:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    160a:	75 20                	jne    162c <free+0xcf>
    p->s.size += bp->s.size;
    160c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    160f:	8b 50 04             	mov    0x4(%eax),%edx
    1612:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1615:	8b 40 04             	mov    0x4(%eax),%eax
    1618:	01 c2                	add    %eax,%edx
    161a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    161d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1620:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1623:	8b 10                	mov    (%eax),%edx
    1625:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1628:	89 10                	mov    %edx,(%eax)
    162a:	eb 08                	jmp    1634 <free+0xd7>
  } else
    p->s.ptr = bp;
    162c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    162f:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1632:	89 10                	mov    %edx,(%eax)
  freep = p;
    1634:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1637:	a3 8c 1e 00 00       	mov    %eax,0x1e8c
}
    163c:	90                   	nop
    163d:	c9                   	leave  
    163e:	c3                   	ret    

0000163f <morecore>:

static Header*
morecore(uint nu)
{
    163f:	55                   	push   %ebp
    1640:	89 e5                	mov    %esp,%ebp
    1642:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1645:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    164c:	77 07                	ja     1655 <morecore+0x16>
    nu = 4096;
    164e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1655:	8b 45 08             	mov    0x8(%ebp),%eax
    1658:	c1 e0 03             	shl    $0x3,%eax
    165b:	83 ec 0c             	sub    $0xc,%esp
    165e:	50                   	push   %eax
    165f:	e8 39 fc ff ff       	call   129d <sbrk>
    1664:	83 c4 10             	add    $0x10,%esp
    1667:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    166a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    166e:	75 07                	jne    1677 <morecore+0x38>
    return 0;
    1670:	b8 00 00 00 00       	mov    $0x0,%eax
    1675:	eb 26                	jmp    169d <morecore+0x5e>
  hp = (Header*)p;
    1677:	8b 45 f4             	mov    -0xc(%ebp),%eax
    167a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    167d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1680:	8b 55 08             	mov    0x8(%ebp),%edx
    1683:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1686:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1689:	83 c0 08             	add    $0x8,%eax
    168c:	83 ec 0c             	sub    $0xc,%esp
    168f:	50                   	push   %eax
    1690:	e8 c8 fe ff ff       	call   155d <free>
    1695:	83 c4 10             	add    $0x10,%esp
  return freep;
    1698:	a1 8c 1e 00 00       	mov    0x1e8c,%eax
}
    169d:	c9                   	leave  
    169e:	c3                   	ret    

0000169f <malloc>:

void*
malloc(uint nbytes)
{
    169f:	55                   	push   %ebp
    16a0:	89 e5                	mov    %esp,%ebp
    16a2:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    16a5:	8b 45 08             	mov    0x8(%ebp),%eax
    16a8:	83 c0 07             	add    $0x7,%eax
    16ab:	c1 e8 03             	shr    $0x3,%eax
    16ae:	83 c0 01             	add    $0x1,%eax
    16b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    16b4:	a1 8c 1e 00 00       	mov    0x1e8c,%eax
    16b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    16bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    16c0:	75 23                	jne    16e5 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    16c2:	c7 45 f0 84 1e 00 00 	movl   $0x1e84,-0x10(%ebp)
    16c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    16cc:	a3 8c 1e 00 00       	mov    %eax,0x1e8c
    16d1:	a1 8c 1e 00 00       	mov    0x1e8c,%eax
    16d6:	a3 84 1e 00 00       	mov    %eax,0x1e84
    base.s.size = 0;
    16db:	c7 05 88 1e 00 00 00 	movl   $0x0,0x1e88
    16e2:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    16e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    16e8:	8b 00                	mov    (%eax),%eax
    16ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    16ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16f0:	8b 40 04             	mov    0x4(%eax),%eax
    16f3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    16f6:	72 4d                	jb     1745 <malloc+0xa6>
      if(p->s.size == nunits)
    16f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16fb:	8b 40 04             	mov    0x4(%eax),%eax
    16fe:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1701:	75 0c                	jne    170f <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1703:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1706:	8b 10                	mov    (%eax),%edx
    1708:	8b 45 f0             	mov    -0x10(%ebp),%eax
    170b:	89 10                	mov    %edx,(%eax)
    170d:	eb 26                	jmp    1735 <malloc+0x96>
      else {
        p->s.size -= nunits;
    170f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1712:	8b 40 04             	mov    0x4(%eax),%eax
    1715:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1718:	89 c2                	mov    %eax,%edx
    171a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    171d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1720:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1723:	8b 40 04             	mov    0x4(%eax),%eax
    1726:	c1 e0 03             	shl    $0x3,%eax
    1729:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    172c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    172f:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1732:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1735:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1738:	a3 8c 1e 00 00       	mov    %eax,0x1e8c
      return (void*)(p + 1);
    173d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1740:	83 c0 08             	add    $0x8,%eax
    1743:	eb 3b                	jmp    1780 <malloc+0xe1>
    }
    if(p == freep)
    1745:	a1 8c 1e 00 00       	mov    0x1e8c,%eax
    174a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    174d:	75 1e                	jne    176d <malloc+0xce>
      if((p = morecore(nunits)) == 0)
    174f:	83 ec 0c             	sub    $0xc,%esp
    1752:	ff 75 ec             	pushl  -0x14(%ebp)
    1755:	e8 e5 fe ff ff       	call   163f <morecore>
    175a:	83 c4 10             	add    $0x10,%esp
    175d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1760:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1764:	75 07                	jne    176d <malloc+0xce>
        return 0;
    1766:	b8 00 00 00 00       	mov    $0x0,%eax
    176b:	eb 13                	jmp    1780 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    176d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1770:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1773:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1776:	8b 00                	mov    (%eax),%eax
    1778:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    177b:	e9 6d ff ff ff       	jmp    16ed <malloc+0x4e>
}
    1780:	c9                   	leave  
    1781:	c3                   	ret    
