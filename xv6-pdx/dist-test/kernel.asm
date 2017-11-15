
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 c0 10 00       	mov    $0x10c000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 70 e6 10 80       	mov    $0x8010e670,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 2d 39 10 80       	mov    $0x8010392d,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	83 ec 08             	sub    $0x8,%esp
8010003d:	68 40 98 10 80       	push   $0x80109840
80100042:	68 80 e6 10 80       	push   $0x8010e680
80100047:	e8 fd 60 00 00       	call   80106149 <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 90 25 11 80 84 	movl   $0x80112584,0x80112590
80100056:	25 11 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 94 25 11 80 84 	movl   $0x80112584,0x80112594
80100060:	25 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 b4 e6 10 80 	movl   $0x8010e6b4,-0xc(%ebp)
8010006a:	eb 3a                	jmp    801000a6 <binit+0x72>
    b->next = bcache.head.next;
8010006c:	8b 15 94 25 11 80    	mov    0x80112594,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 0c 84 25 11 80 	movl   $0x80112584,0xc(%eax)
    b->dev = -1;
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008c:	a1 94 25 11 80       	mov    0x80112594,%eax
80100091:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100094:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010009a:	a3 94 25 11 80       	mov    %eax,0x80112594
  initlock(&bcache.lock, "bcache");

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009f:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a6:	b8 84 25 11 80       	mov    $0x80112584,%eax
801000ab:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000ae:	72 bc                	jb     8010006c <binit+0x38>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000b0:	90                   	nop
801000b1:	c9                   	leave  
801000b2:	c3                   	ret    

801000b3 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000b3:	55                   	push   %ebp
801000b4:	89 e5                	mov    %esp,%ebp
801000b6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b9:	83 ec 0c             	sub    $0xc,%esp
801000bc:	68 80 e6 10 80       	push   $0x8010e680
801000c1:	e8 a5 60 00 00       	call   8010616b <acquire>
801000c6:	83 c4 10             	add    $0x10,%esp

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c9:	a1 94 25 11 80       	mov    0x80112594,%eax
801000ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000d1:	eb 67                	jmp    8010013a <bget+0x87>
    if(b->dev == dev && b->blockno == blockno){
801000d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000d6:	8b 40 04             	mov    0x4(%eax),%eax
801000d9:	3b 45 08             	cmp    0x8(%ebp),%eax
801000dc:	75 53                	jne    80100131 <bget+0x7e>
801000de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e1:	8b 40 08             	mov    0x8(%eax),%eax
801000e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e7:	75 48                	jne    80100131 <bget+0x7e>
      if(!(b->flags & B_BUSY)){
801000e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ec:	8b 00                	mov    (%eax),%eax
801000ee:	83 e0 01             	and    $0x1,%eax
801000f1:	85 c0                	test   %eax,%eax
801000f3:	75 27                	jne    8010011c <bget+0x69>
        b->flags |= B_BUSY;
801000f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f8:	8b 00                	mov    (%eax),%eax
801000fa:	83 c8 01             	or     $0x1,%eax
801000fd:	89 c2                	mov    %eax,%edx
801000ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100102:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
80100104:	83 ec 0c             	sub    $0xc,%esp
80100107:	68 80 e6 10 80       	push   $0x8010e680
8010010c:	e8 c1 60 00 00       	call   801061d2 <release>
80100111:	83 c4 10             	add    $0x10,%esp
        return b;
80100114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100117:	e9 98 00 00 00       	jmp    801001b4 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011c:	83 ec 08             	sub    $0x8,%esp
8010011f:	68 80 e6 10 80       	push   $0x8010e680
80100124:	ff 75 f4             	pushl  -0xc(%ebp)
80100127:	e8 d6 50 00 00       	call   80105202 <sleep>
8010012c:	83 c4 10             	add    $0x10,%esp
      goto loop;
8010012f:	eb 98                	jmp    801000c9 <bget+0x16>

  acquire(&bcache.lock);

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100131:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100134:	8b 40 10             	mov    0x10(%eax),%eax
80100137:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010013a:	81 7d f4 84 25 11 80 	cmpl   $0x80112584,-0xc(%ebp)
80100141:	75 90                	jne    801000d3 <bget+0x20>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100143:	a1 90 25 11 80       	mov    0x80112590,%eax
80100148:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010014b:	eb 51                	jmp    8010019e <bget+0xeb>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
8010014d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100150:	8b 00                	mov    (%eax),%eax
80100152:	83 e0 01             	and    $0x1,%eax
80100155:	85 c0                	test   %eax,%eax
80100157:	75 3c                	jne    80100195 <bget+0xe2>
80100159:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015c:	8b 00                	mov    (%eax),%eax
8010015e:	83 e0 04             	and    $0x4,%eax
80100161:	85 c0                	test   %eax,%eax
80100163:	75 30                	jne    80100195 <bget+0xe2>
      b->dev = dev;
80100165:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100168:	8b 55 08             	mov    0x8(%ebp),%edx
8010016b:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
8010016e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100171:	8b 55 0c             	mov    0xc(%ebp),%edx
80100174:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
80100177:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010017a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100180:	83 ec 0c             	sub    $0xc,%esp
80100183:	68 80 e6 10 80       	push   $0x8010e680
80100188:	e8 45 60 00 00       	call   801061d2 <release>
8010018d:	83 c4 10             	add    $0x10,%esp
      return b;
80100190:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100193:	eb 1f                	jmp    801001b4 <bget+0x101>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100195:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100198:	8b 40 0c             	mov    0xc(%eax),%eax
8010019b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010019e:	81 7d f4 84 25 11 80 	cmpl   $0x80112584,-0xc(%ebp)
801001a5:	75 a6                	jne    8010014d <bget+0x9a>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001a7:	83 ec 0c             	sub    $0xc,%esp
801001aa:	68 47 98 10 80       	push   $0x80109847
801001af:	e8 b2 03 00 00       	call   80100566 <panic>
}
801001b4:	c9                   	leave  
801001b5:	c3                   	ret    

801001b6 <bread>:

// Return a B_BUSY buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001b6:	55                   	push   %ebp
801001b7:	89 e5                	mov    %esp,%ebp
801001b9:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001bc:	83 ec 08             	sub    $0x8,%esp
801001bf:	ff 75 0c             	pushl  0xc(%ebp)
801001c2:	ff 75 08             	pushl  0x8(%ebp)
801001c5:	e8 e9 fe ff ff       	call   801000b3 <bget>
801001ca:	83 c4 10             	add    $0x10,%esp
801001cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID)) {
801001d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d3:	8b 00                	mov    (%eax),%eax
801001d5:	83 e0 02             	and    $0x2,%eax
801001d8:	85 c0                	test   %eax,%eax
801001da:	75 0e                	jne    801001ea <bread+0x34>
    iderw(b);
801001dc:	83 ec 0c             	sub    $0xc,%esp
801001df:	ff 75 f4             	pushl  -0xc(%ebp)
801001e2:	e8 c4 27 00 00       	call   801029ab <iderw>
801001e7:	83 c4 10             	add    $0x10,%esp
  }
  return b;
801001ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001ed:	c9                   	leave  
801001ee:	c3                   	ret    

801001ef <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001ef:	55                   	push   %ebp
801001f0:	89 e5                	mov    %esp,%ebp
801001f2:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
801001f5:	8b 45 08             	mov    0x8(%ebp),%eax
801001f8:	8b 00                	mov    (%eax),%eax
801001fa:	83 e0 01             	and    $0x1,%eax
801001fd:	85 c0                	test   %eax,%eax
801001ff:	75 0d                	jne    8010020e <bwrite+0x1f>
    panic("bwrite");
80100201:	83 ec 0c             	sub    $0xc,%esp
80100204:	68 58 98 10 80       	push   $0x80109858
80100209:	e8 58 03 00 00       	call   80100566 <panic>
  b->flags |= B_DIRTY;
8010020e:	8b 45 08             	mov    0x8(%ebp),%eax
80100211:	8b 00                	mov    (%eax),%eax
80100213:	83 c8 04             	or     $0x4,%eax
80100216:	89 c2                	mov    %eax,%edx
80100218:	8b 45 08             	mov    0x8(%ebp),%eax
8010021b:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010021d:	83 ec 0c             	sub    $0xc,%esp
80100220:	ff 75 08             	pushl  0x8(%ebp)
80100223:	e8 83 27 00 00       	call   801029ab <iderw>
80100228:	83 c4 10             	add    $0x10,%esp
}
8010022b:	90                   	nop
8010022c:	c9                   	leave  
8010022d:	c3                   	ret    

8010022e <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
8010022e:	55                   	push   %ebp
8010022f:	89 e5                	mov    %esp,%ebp
80100231:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
80100234:	8b 45 08             	mov    0x8(%ebp),%eax
80100237:	8b 00                	mov    (%eax),%eax
80100239:	83 e0 01             	and    $0x1,%eax
8010023c:	85 c0                	test   %eax,%eax
8010023e:	75 0d                	jne    8010024d <brelse+0x1f>
    panic("brelse");
80100240:	83 ec 0c             	sub    $0xc,%esp
80100243:	68 5f 98 10 80       	push   $0x8010985f
80100248:	e8 19 03 00 00       	call   80100566 <panic>

  acquire(&bcache.lock);
8010024d:	83 ec 0c             	sub    $0xc,%esp
80100250:	68 80 e6 10 80       	push   $0x8010e680
80100255:	e8 11 5f 00 00       	call   8010616b <acquire>
8010025a:	83 c4 10             	add    $0x10,%esp

  b->next->prev = b->prev;
8010025d:	8b 45 08             	mov    0x8(%ebp),%eax
80100260:	8b 40 10             	mov    0x10(%eax),%eax
80100263:	8b 55 08             	mov    0x8(%ebp),%edx
80100266:	8b 52 0c             	mov    0xc(%edx),%edx
80100269:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
8010026c:	8b 45 08             	mov    0x8(%ebp),%eax
8010026f:	8b 40 0c             	mov    0xc(%eax),%eax
80100272:	8b 55 08             	mov    0x8(%ebp),%edx
80100275:	8b 52 10             	mov    0x10(%edx),%edx
80100278:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010027b:	8b 15 94 25 11 80    	mov    0x80112594,%edx
80100281:	8b 45 08             	mov    0x8(%ebp),%eax
80100284:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
80100287:	8b 45 08             	mov    0x8(%ebp),%eax
8010028a:	c7 40 0c 84 25 11 80 	movl   $0x80112584,0xc(%eax)
  bcache.head.next->prev = b;
80100291:	a1 94 25 11 80       	mov    0x80112594,%eax
80100296:	8b 55 08             	mov    0x8(%ebp),%edx
80100299:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
8010029c:	8b 45 08             	mov    0x8(%ebp),%eax
8010029f:	a3 94 25 11 80       	mov    %eax,0x80112594

  b->flags &= ~B_BUSY;
801002a4:	8b 45 08             	mov    0x8(%ebp),%eax
801002a7:	8b 00                	mov    (%eax),%eax
801002a9:	83 e0 fe             	and    $0xfffffffe,%eax
801002ac:	89 c2                	mov    %eax,%edx
801002ae:	8b 45 08             	mov    0x8(%ebp),%eax
801002b1:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801002b3:	83 ec 0c             	sub    $0xc,%esp
801002b6:	ff 75 08             	pushl  0x8(%ebp)
801002b9:	e8 e5 50 00 00       	call   801053a3 <wakeup>
801002be:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002c1:	83 ec 0c             	sub    $0xc,%esp
801002c4:	68 80 e6 10 80       	push   $0x8010e680
801002c9:	e8 04 5f 00 00       	call   801061d2 <release>
801002ce:	83 c4 10             	add    $0x10,%esp
}
801002d1:	90                   	nop
801002d2:	c9                   	leave  
801002d3:	c3                   	ret    

801002d4 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
801002d4:	55                   	push   %ebp
801002d5:	89 e5                	mov    %esp,%ebp
801002d7:	83 ec 14             	sub    $0x14,%esp
801002da:	8b 45 08             	mov    0x8(%ebp),%eax
801002dd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002e1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002e5:	89 c2                	mov    %eax,%edx
801002e7:	ec                   	in     (%dx),%al
801002e8:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002eb:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002ef:	c9                   	leave  
801002f0:	c3                   	ret    

801002f1 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002f1:	55                   	push   %ebp
801002f2:	89 e5                	mov    %esp,%ebp
801002f4:	83 ec 08             	sub    $0x8,%esp
801002f7:	8b 55 08             	mov    0x8(%ebp),%edx
801002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
801002fd:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80100301:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100304:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80100308:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010030c:	ee                   	out    %al,(%dx)
}
8010030d:	90                   	nop
8010030e:	c9                   	leave  
8010030f:	c3                   	ret    

80100310 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80100310:	55                   	push   %ebp
80100311:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80100313:	fa                   	cli    
}
80100314:	90                   	nop
80100315:	5d                   	pop    %ebp
80100316:	c3                   	ret    

80100317 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100317:	55                   	push   %ebp
80100318:	89 e5                	mov    %esp,%ebp
8010031a:	53                   	push   %ebx
8010031b:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010031e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100322:	74 1c                	je     80100340 <printint+0x29>
80100324:	8b 45 08             	mov    0x8(%ebp),%eax
80100327:	c1 e8 1f             	shr    $0x1f,%eax
8010032a:	0f b6 c0             	movzbl %al,%eax
8010032d:	89 45 10             	mov    %eax,0x10(%ebp)
80100330:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100334:	74 0a                	je     80100340 <printint+0x29>
    x = -xx;
80100336:	8b 45 08             	mov    0x8(%ebp),%eax
80100339:	f7 d8                	neg    %eax
8010033b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010033e:	eb 06                	jmp    80100346 <printint+0x2f>
  else
    x = xx;
80100340:	8b 45 08             	mov    0x8(%ebp),%eax
80100343:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100346:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
8010034d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100350:	8d 41 01             	lea    0x1(%ecx),%eax
80100353:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100356:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100359:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010035c:	ba 00 00 00 00       	mov    $0x0,%edx
80100361:	f7 f3                	div    %ebx
80100363:	89 d0                	mov    %edx,%eax
80100365:	0f b6 80 04 b0 10 80 	movzbl -0x7fef4ffc(%eax),%eax
8010036c:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
80100370:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100373:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100376:	ba 00 00 00 00       	mov    $0x0,%edx
8010037b:	f7 f3                	div    %ebx
8010037d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100380:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100384:	75 c7                	jne    8010034d <printint+0x36>

  if(sign)
80100386:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010038a:	74 2a                	je     801003b6 <printint+0x9f>
    buf[i++] = '-';
8010038c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010038f:	8d 50 01             	lea    0x1(%eax),%edx
80100392:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100395:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
8010039a:	eb 1a                	jmp    801003b6 <printint+0x9f>
    consputc(buf[i]);
8010039c:	8d 55 e0             	lea    -0x20(%ebp),%edx
8010039f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003a2:	01 d0                	add    %edx,%eax
801003a4:	0f b6 00             	movzbl (%eax),%eax
801003a7:	0f be c0             	movsbl %al,%eax
801003aa:	83 ec 0c             	sub    $0xc,%esp
801003ad:	50                   	push   %eax
801003ae:	e8 df 03 00 00       	call   80100792 <consputc>
801003b3:	83 c4 10             	add    $0x10,%esp
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801003b6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003be:	79 dc                	jns    8010039c <printint+0x85>
    consputc(buf[i]);
}
801003c0:	90                   	nop
801003c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801003c4:	c9                   	leave  
801003c5:	c3                   	ret    

801003c6 <cprintf>:

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003c6:	55                   	push   %ebp
801003c7:	89 e5                	mov    %esp,%ebp
801003c9:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003cc:	a1 14 d6 10 80       	mov    0x8010d614,%eax
801003d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003d8:	74 10                	je     801003ea <cprintf+0x24>
    acquire(&cons.lock);
801003da:	83 ec 0c             	sub    $0xc,%esp
801003dd:	68 e0 d5 10 80       	push   $0x8010d5e0
801003e2:	e8 84 5d 00 00       	call   8010616b <acquire>
801003e7:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003ea:	8b 45 08             	mov    0x8(%ebp),%eax
801003ed:	85 c0                	test   %eax,%eax
801003ef:	75 0d                	jne    801003fe <cprintf+0x38>
    panic("null fmt");
801003f1:	83 ec 0c             	sub    $0xc,%esp
801003f4:	68 66 98 10 80       	push   $0x80109866
801003f9:	e8 68 01 00 00       	call   80100566 <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003fe:	8d 45 0c             	lea    0xc(%ebp),%eax
80100401:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100404:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010040b:	e9 1a 01 00 00       	jmp    8010052a <cprintf+0x164>
    if(c != '%'){
80100410:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
80100414:	74 13                	je     80100429 <cprintf+0x63>
      consputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	ff 75 e4             	pushl  -0x1c(%ebp)
8010041c:	e8 71 03 00 00       	call   80100792 <consputc>
80100421:	83 c4 10             	add    $0x10,%esp
      continue;
80100424:	e9 fd 00 00 00       	jmp    80100526 <cprintf+0x160>
    }
    c = fmt[++i] & 0xff;
80100429:	8b 55 08             	mov    0x8(%ebp),%edx
8010042c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100430:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100433:	01 d0                	add    %edx,%eax
80100435:	0f b6 00             	movzbl (%eax),%eax
80100438:	0f be c0             	movsbl %al,%eax
8010043b:	25 ff 00 00 00       	and    $0xff,%eax
80100440:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100443:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100447:	0f 84 ff 00 00 00    	je     8010054c <cprintf+0x186>
      break;
    switch(c){
8010044d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100450:	83 f8 70             	cmp    $0x70,%eax
80100453:	74 47                	je     8010049c <cprintf+0xd6>
80100455:	83 f8 70             	cmp    $0x70,%eax
80100458:	7f 13                	jg     8010046d <cprintf+0xa7>
8010045a:	83 f8 25             	cmp    $0x25,%eax
8010045d:	0f 84 98 00 00 00    	je     801004fb <cprintf+0x135>
80100463:	83 f8 64             	cmp    $0x64,%eax
80100466:	74 14                	je     8010047c <cprintf+0xb6>
80100468:	e9 9d 00 00 00       	jmp    8010050a <cprintf+0x144>
8010046d:	83 f8 73             	cmp    $0x73,%eax
80100470:	74 47                	je     801004b9 <cprintf+0xf3>
80100472:	83 f8 78             	cmp    $0x78,%eax
80100475:	74 25                	je     8010049c <cprintf+0xd6>
80100477:	e9 8e 00 00 00       	jmp    8010050a <cprintf+0x144>
    case 'd':
      printint(*argp++, 10, 1);
8010047c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010047f:	8d 50 04             	lea    0x4(%eax),%edx
80100482:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100485:	8b 00                	mov    (%eax),%eax
80100487:	83 ec 04             	sub    $0x4,%esp
8010048a:	6a 01                	push   $0x1
8010048c:	6a 0a                	push   $0xa
8010048e:	50                   	push   %eax
8010048f:	e8 83 fe ff ff       	call   80100317 <printint>
80100494:	83 c4 10             	add    $0x10,%esp
      break;
80100497:	e9 8a 00 00 00       	jmp    80100526 <cprintf+0x160>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010049c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010049f:	8d 50 04             	lea    0x4(%eax),%edx
801004a2:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004a5:	8b 00                	mov    (%eax),%eax
801004a7:	83 ec 04             	sub    $0x4,%esp
801004aa:	6a 00                	push   $0x0
801004ac:	6a 10                	push   $0x10
801004ae:	50                   	push   %eax
801004af:	e8 63 fe ff ff       	call   80100317 <printint>
801004b4:	83 c4 10             	add    $0x10,%esp
      break;
801004b7:	eb 6d                	jmp    80100526 <cprintf+0x160>
    case 's':
      if((s = (char*)*argp++) == 0)
801004b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004bc:	8d 50 04             	lea    0x4(%eax),%edx
801004bf:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004c2:	8b 00                	mov    (%eax),%eax
801004c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004cb:	75 22                	jne    801004ef <cprintf+0x129>
        s = "(null)";
801004cd:	c7 45 ec 6f 98 10 80 	movl   $0x8010986f,-0x14(%ebp)
      for(; *s; s++)
801004d4:	eb 19                	jmp    801004ef <cprintf+0x129>
        consputc(*s);
801004d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004d9:	0f b6 00             	movzbl (%eax),%eax
801004dc:	0f be c0             	movsbl %al,%eax
801004df:	83 ec 0c             	sub    $0xc,%esp
801004e2:	50                   	push   %eax
801004e3:	e8 aa 02 00 00       	call   80100792 <consputc>
801004e8:	83 c4 10             	add    $0x10,%esp
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004eb:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004f2:	0f b6 00             	movzbl (%eax),%eax
801004f5:	84 c0                	test   %al,%al
801004f7:	75 dd                	jne    801004d6 <cprintf+0x110>
        consputc(*s);
      break;
801004f9:	eb 2b                	jmp    80100526 <cprintf+0x160>
    case '%':
      consputc('%');
801004fb:	83 ec 0c             	sub    $0xc,%esp
801004fe:	6a 25                	push   $0x25
80100500:	e8 8d 02 00 00       	call   80100792 <consputc>
80100505:	83 c4 10             	add    $0x10,%esp
      break;
80100508:	eb 1c                	jmp    80100526 <cprintf+0x160>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
8010050a:	83 ec 0c             	sub    $0xc,%esp
8010050d:	6a 25                	push   $0x25
8010050f:	e8 7e 02 00 00       	call   80100792 <consputc>
80100514:	83 c4 10             	add    $0x10,%esp
      consputc(c);
80100517:	83 ec 0c             	sub    $0xc,%esp
8010051a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010051d:	e8 70 02 00 00       	call   80100792 <consputc>
80100522:	83 c4 10             	add    $0x10,%esp
      break;
80100525:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100526:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010052a:	8b 55 08             	mov    0x8(%ebp),%edx
8010052d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100530:	01 d0                	add    %edx,%eax
80100532:	0f b6 00             	movzbl (%eax),%eax
80100535:	0f be c0             	movsbl %al,%eax
80100538:	25 ff 00 00 00       	and    $0xff,%eax
8010053d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100540:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100544:	0f 85 c6 fe ff ff    	jne    80100410 <cprintf+0x4a>
8010054a:	eb 01                	jmp    8010054d <cprintf+0x187>
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
8010054c:	90                   	nop
      consputc(c);
      break;
    }
  }

  if(locking)
8010054d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100551:	74 10                	je     80100563 <cprintf+0x19d>
    release(&cons.lock);
80100553:	83 ec 0c             	sub    $0xc,%esp
80100556:	68 e0 d5 10 80       	push   $0x8010d5e0
8010055b:	e8 72 5c 00 00       	call   801061d2 <release>
80100560:	83 c4 10             	add    $0x10,%esp
}
80100563:	90                   	nop
80100564:	c9                   	leave  
80100565:	c3                   	ret    

80100566 <panic>:

void
panic(char *s)
{
80100566:	55                   	push   %ebp
80100567:	89 e5                	mov    %esp,%ebp
80100569:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];
  
  cli();
8010056c:	e8 9f fd ff ff       	call   80100310 <cli>
  cons.locking = 0;
80100571:	c7 05 14 d6 10 80 00 	movl   $0x0,0x8010d614
80100578:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010057b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100581:	0f b6 00             	movzbl (%eax),%eax
80100584:	0f b6 c0             	movzbl %al,%eax
80100587:	83 ec 08             	sub    $0x8,%esp
8010058a:	50                   	push   %eax
8010058b:	68 76 98 10 80       	push   $0x80109876
80100590:	e8 31 fe ff ff       	call   801003c6 <cprintf>
80100595:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
80100598:	8b 45 08             	mov    0x8(%ebp),%eax
8010059b:	83 ec 0c             	sub    $0xc,%esp
8010059e:	50                   	push   %eax
8010059f:	e8 22 fe ff ff       	call   801003c6 <cprintf>
801005a4:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801005a7:	83 ec 0c             	sub    $0xc,%esp
801005aa:	68 85 98 10 80       	push   $0x80109885
801005af:	e8 12 fe ff ff       	call   801003c6 <cprintf>
801005b4:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005b7:	83 ec 08             	sub    $0x8,%esp
801005ba:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005bd:	50                   	push   %eax
801005be:	8d 45 08             	lea    0x8(%ebp),%eax
801005c1:	50                   	push   %eax
801005c2:	e8 5d 5c 00 00       	call   80106224 <getcallerpcs>
801005c7:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005d1:	eb 1c                	jmp    801005ef <panic+0x89>
    cprintf(" %p", pcs[i]);
801005d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d6:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005da:	83 ec 08             	sub    $0x8,%esp
801005dd:	50                   	push   %eax
801005de:	68 87 98 10 80       	push   $0x80109887
801005e3:	e8 de fd ff ff       	call   801003c6 <cprintf>
801005e8:	83 c4 10             	add    $0x10,%esp
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005eb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005ef:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005f3:	7e de                	jle    801005d3 <panic+0x6d>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005f5:	c7 05 c0 d5 10 80 01 	movl   $0x1,0x8010d5c0
801005fc:	00 00 00 
  for(;;)
    ;
801005ff:	eb fe                	jmp    801005ff <panic+0x99>

80100601 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
80100601:	55                   	push   %ebp
80100602:	89 e5                	mov    %esp,%ebp
80100604:	83 ec 18             	sub    $0x18,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
80100607:	6a 0e                	push   $0xe
80100609:	68 d4 03 00 00       	push   $0x3d4
8010060e:	e8 de fc ff ff       	call   801002f1 <outb>
80100613:	83 c4 08             	add    $0x8,%esp
  pos = inb(CRTPORT+1) << 8;
80100616:	68 d5 03 00 00       	push   $0x3d5
8010061b:	e8 b4 fc ff ff       	call   801002d4 <inb>
80100620:	83 c4 04             	add    $0x4,%esp
80100623:	0f b6 c0             	movzbl %al,%eax
80100626:	c1 e0 08             	shl    $0x8,%eax
80100629:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
8010062c:	6a 0f                	push   $0xf
8010062e:	68 d4 03 00 00       	push   $0x3d4
80100633:	e8 b9 fc ff ff       	call   801002f1 <outb>
80100638:	83 c4 08             	add    $0x8,%esp
  pos |= inb(CRTPORT+1);
8010063b:	68 d5 03 00 00       	push   $0x3d5
80100640:	e8 8f fc ff ff       	call   801002d4 <inb>
80100645:	83 c4 04             	add    $0x4,%esp
80100648:	0f b6 c0             	movzbl %al,%eax
8010064b:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
8010064e:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100652:	75 30                	jne    80100684 <cgaputc+0x83>
    pos += 80 - pos%80;
80100654:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100657:	ba 67 66 66 66       	mov    $0x66666667,%edx
8010065c:	89 c8                	mov    %ecx,%eax
8010065e:	f7 ea                	imul   %edx
80100660:	c1 fa 05             	sar    $0x5,%edx
80100663:	89 c8                	mov    %ecx,%eax
80100665:	c1 f8 1f             	sar    $0x1f,%eax
80100668:	29 c2                	sub    %eax,%edx
8010066a:	89 d0                	mov    %edx,%eax
8010066c:	c1 e0 02             	shl    $0x2,%eax
8010066f:	01 d0                	add    %edx,%eax
80100671:	c1 e0 04             	shl    $0x4,%eax
80100674:	29 c1                	sub    %eax,%ecx
80100676:	89 ca                	mov    %ecx,%edx
80100678:	b8 50 00 00 00       	mov    $0x50,%eax
8010067d:	29 d0                	sub    %edx,%eax
8010067f:	01 45 f4             	add    %eax,-0xc(%ebp)
80100682:	eb 34                	jmp    801006b8 <cgaputc+0xb7>
  else if(c == BACKSPACE){
80100684:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010068b:	75 0c                	jne    80100699 <cgaputc+0x98>
    if(pos > 0) --pos;
8010068d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100691:	7e 25                	jle    801006b8 <cgaputc+0xb7>
80100693:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100697:	eb 1f                	jmp    801006b8 <cgaputc+0xb7>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100699:	8b 0d 00 b0 10 80    	mov    0x8010b000,%ecx
8010069f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006a2:	8d 50 01             	lea    0x1(%eax),%edx
801006a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
801006a8:	01 c0                	add    %eax,%eax
801006aa:	01 c8                	add    %ecx,%eax
801006ac:	8b 55 08             	mov    0x8(%ebp),%edx
801006af:	0f b6 d2             	movzbl %dl,%edx
801006b2:	80 ce 07             	or     $0x7,%dh
801006b5:	66 89 10             	mov    %dx,(%eax)

  if(pos < 0 || pos > 25*80)
801006b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801006bc:	78 09                	js     801006c7 <cgaputc+0xc6>
801006be:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
801006c5:	7e 0d                	jle    801006d4 <cgaputc+0xd3>
    panic("pos under/overflow");
801006c7:	83 ec 0c             	sub    $0xc,%esp
801006ca:	68 8b 98 10 80       	push   $0x8010988b
801006cf:	e8 92 fe ff ff       	call   80100566 <panic>
  
  if((pos/80) >= 24){  // Scroll up.
801006d4:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006db:	7e 4c                	jle    80100729 <cgaputc+0x128>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006dd:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801006e2:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006e8:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801006ed:	83 ec 04             	sub    $0x4,%esp
801006f0:	68 60 0e 00 00       	push   $0xe60
801006f5:	52                   	push   %edx
801006f6:	50                   	push   %eax
801006f7:	e8 91 5d 00 00       	call   8010648d <memmove>
801006fc:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
801006ff:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100703:	b8 80 07 00 00       	mov    $0x780,%eax
80100708:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010070b:	8d 14 00             	lea    (%eax,%eax,1),%edx
8010070e:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80100713:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100716:	01 c9                	add    %ecx,%ecx
80100718:	01 c8                	add    %ecx,%eax
8010071a:	83 ec 04             	sub    $0x4,%esp
8010071d:	52                   	push   %edx
8010071e:	6a 00                	push   $0x0
80100720:	50                   	push   %eax
80100721:	e8 a8 5c 00 00       	call   801063ce <memset>
80100726:	83 c4 10             	add    $0x10,%esp
  }
  
  outb(CRTPORT, 14);
80100729:	83 ec 08             	sub    $0x8,%esp
8010072c:	6a 0e                	push   $0xe
8010072e:	68 d4 03 00 00       	push   $0x3d4
80100733:	e8 b9 fb ff ff       	call   801002f1 <outb>
80100738:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos>>8);
8010073b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010073e:	c1 f8 08             	sar    $0x8,%eax
80100741:	0f b6 c0             	movzbl %al,%eax
80100744:	83 ec 08             	sub    $0x8,%esp
80100747:	50                   	push   %eax
80100748:	68 d5 03 00 00       	push   $0x3d5
8010074d:	e8 9f fb ff ff       	call   801002f1 <outb>
80100752:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT, 15);
80100755:	83 ec 08             	sub    $0x8,%esp
80100758:	6a 0f                	push   $0xf
8010075a:	68 d4 03 00 00       	push   $0x3d4
8010075f:	e8 8d fb ff ff       	call   801002f1 <outb>
80100764:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos);
80100767:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010076a:	0f b6 c0             	movzbl %al,%eax
8010076d:	83 ec 08             	sub    $0x8,%esp
80100770:	50                   	push   %eax
80100771:	68 d5 03 00 00       	push   $0x3d5
80100776:	e8 76 fb ff ff       	call   801002f1 <outb>
8010077b:	83 c4 10             	add    $0x10,%esp
  crt[pos] = ' ' | 0x0700;
8010077e:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80100783:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100786:	01 d2                	add    %edx,%edx
80100788:	01 d0                	add    %edx,%eax
8010078a:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
8010078f:	90                   	nop
80100790:	c9                   	leave  
80100791:	c3                   	ret    

80100792 <consputc>:

void
consputc(int c)
{
80100792:	55                   	push   %ebp
80100793:	89 e5                	mov    %esp,%ebp
80100795:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
80100798:	a1 c0 d5 10 80       	mov    0x8010d5c0,%eax
8010079d:	85 c0                	test   %eax,%eax
8010079f:	74 07                	je     801007a8 <consputc+0x16>
    cli();
801007a1:	e8 6a fb ff ff       	call   80100310 <cli>
    for(;;)
      ;
801007a6:	eb fe                	jmp    801007a6 <consputc+0x14>
  }

  if(c == BACKSPACE){
801007a8:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801007af:	75 29                	jne    801007da <consputc+0x48>
    uartputc('\b'); uartputc(' '); uartputc('\b');
801007b1:	83 ec 0c             	sub    $0xc,%esp
801007b4:	6a 08                	push   $0x8
801007b6:	e8 0d 77 00 00       	call   80107ec8 <uartputc>
801007bb:	83 c4 10             	add    $0x10,%esp
801007be:	83 ec 0c             	sub    $0xc,%esp
801007c1:	6a 20                	push   $0x20
801007c3:	e8 00 77 00 00       	call   80107ec8 <uartputc>
801007c8:	83 c4 10             	add    $0x10,%esp
801007cb:	83 ec 0c             	sub    $0xc,%esp
801007ce:	6a 08                	push   $0x8
801007d0:	e8 f3 76 00 00       	call   80107ec8 <uartputc>
801007d5:	83 c4 10             	add    $0x10,%esp
801007d8:	eb 0e                	jmp    801007e8 <consputc+0x56>
  } else
    uartputc(c);
801007da:	83 ec 0c             	sub    $0xc,%esp
801007dd:	ff 75 08             	pushl  0x8(%ebp)
801007e0:	e8 e3 76 00 00       	call   80107ec8 <uartputc>
801007e5:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	ff 75 08             	pushl  0x8(%ebp)
801007ee:	e8 0e fe ff ff       	call   80100601 <cgaputc>
801007f3:	83 c4 10             	add    $0x10,%esp
}
801007f6:	90                   	nop
801007f7:	c9                   	leave  
801007f8:	c3                   	ret    

801007f9 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f9:	55                   	push   %ebp
801007fa:	89 e5                	mov    %esp,%ebp
801007fc:	83 ec 28             	sub    $0x28,%esp
  int c, doprocdump = 0;
801007ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  #ifdef CS333_P3P4
  int doctrlr = 0, doctrlf = 0, doctrls = 0, doctrlz = 0;
80100806:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010080d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100814:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
8010081b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  #endif

  acquire(&cons.lock);
80100822:	83 ec 0c             	sub    $0xc,%esp
80100825:	68 e0 d5 10 80       	push   $0x8010d5e0
8010082a:	e8 3c 59 00 00       	call   8010616b <acquire>
8010082f:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
80100832:	e9 9a 01 00 00       	jmp    801009d1 <consoleintr+0x1d8>
    switch(c){
80100837:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010083a:	83 f8 12             	cmp    $0x12,%eax
8010083d:	74 50                	je     8010088f <consoleintr+0x96>
8010083f:	83 f8 12             	cmp    $0x12,%eax
80100842:	7f 18                	jg     8010085c <consoleintr+0x63>
80100844:	83 f8 08             	cmp    $0x8,%eax
80100847:	0f 84 bd 00 00 00    	je     8010090a <consoleintr+0x111>
8010084d:	83 f8 10             	cmp    $0x10,%eax
80100850:	74 31                	je     80100883 <consoleintr+0x8a>
80100852:	83 f8 06             	cmp    $0x6,%eax
80100855:	74 44                	je     8010089b <consoleintr+0xa2>
80100857:	e9 e3 00 00 00       	jmp    8010093f <consoleintr+0x146>
8010085c:	83 f8 15             	cmp    $0x15,%eax
8010085f:	74 7b                	je     801008dc <consoleintr+0xe3>
80100861:	83 f8 15             	cmp    $0x15,%eax
80100864:	7f 0a                	jg     80100870 <consoleintr+0x77>
80100866:	83 f8 13             	cmp    $0x13,%eax
80100869:	74 3c                	je     801008a7 <consoleintr+0xae>
8010086b:	e9 cf 00 00 00       	jmp    8010093f <consoleintr+0x146>
80100870:	83 f8 1a             	cmp    $0x1a,%eax
80100873:	74 3e                	je     801008b3 <consoleintr+0xba>
80100875:	83 f8 7f             	cmp    $0x7f,%eax
80100878:	0f 84 8c 00 00 00    	je     8010090a <consoleintr+0x111>
8010087e:	e9 bc 00 00 00       	jmp    8010093f <consoleintr+0x146>
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
80100883:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
8010088a:	e9 42 01 00 00       	jmp    801009d1 <consoleintr+0x1d8>
    #ifdef CS333_P3P4
    case C('R'):
      doctrlr = 1;
8010088f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      break;
80100896:	e9 36 01 00 00       	jmp    801009d1 <consoleintr+0x1d8>
    case C('F'):
      doctrlf = 1;
8010089b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
      break;
801008a2:	e9 2a 01 00 00       	jmp    801009d1 <consoleintr+0x1d8>
    case C('S'):
      doctrls = 1;
801008a7:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
      break;
801008ae:	e9 1e 01 00 00       	jmp    801009d1 <consoleintr+0x1d8>
    case C('Z'):
      doctrlz = 1;
801008b3:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
      break;
801008ba:	e9 12 01 00 00       	jmp    801009d1 <consoleintr+0x1d8>
    #endif
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801008bf:	a1 28 28 11 80       	mov    0x80112828,%eax
801008c4:	83 e8 01             	sub    $0x1,%eax
801008c7:	a3 28 28 11 80       	mov    %eax,0x80112828
        consputc(BACKSPACE);
801008cc:	83 ec 0c             	sub    $0xc,%esp
801008cf:	68 00 01 00 00       	push   $0x100
801008d4:	e8 b9 fe ff ff       	call   80100792 <consputc>
801008d9:	83 c4 10             	add    $0x10,%esp
    case C('Z'):
      doctrlz = 1;
      break;
    #endif
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008dc:	8b 15 28 28 11 80    	mov    0x80112828,%edx
801008e2:	a1 24 28 11 80       	mov    0x80112824,%eax
801008e7:	39 c2                	cmp    %eax,%edx
801008e9:	0f 84 e2 00 00 00    	je     801009d1 <consoleintr+0x1d8>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008ef:	a1 28 28 11 80       	mov    0x80112828,%eax
801008f4:	83 e8 01             	sub    $0x1,%eax
801008f7:	83 e0 7f             	and    $0x7f,%eax
801008fa:	0f b6 80 a0 27 11 80 	movzbl -0x7feed860(%eax),%eax
    case C('Z'):
      doctrlz = 1;
      break;
    #endif
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100901:	3c 0a                	cmp    $0xa,%al
80100903:	75 ba                	jne    801008bf <consoleintr+0xc6>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100905:	e9 c7 00 00 00       	jmp    801009d1 <consoleintr+0x1d8>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
8010090a:	8b 15 28 28 11 80    	mov    0x80112828,%edx
80100910:	a1 24 28 11 80       	mov    0x80112824,%eax
80100915:	39 c2                	cmp    %eax,%edx
80100917:	0f 84 b4 00 00 00    	je     801009d1 <consoleintr+0x1d8>
        input.e--;
8010091d:	a1 28 28 11 80       	mov    0x80112828,%eax
80100922:	83 e8 01             	sub    $0x1,%eax
80100925:	a3 28 28 11 80       	mov    %eax,0x80112828
        consputc(BACKSPACE);
8010092a:	83 ec 0c             	sub    $0xc,%esp
8010092d:	68 00 01 00 00       	push   $0x100
80100932:	e8 5b fe ff ff       	call   80100792 <consputc>
80100937:	83 c4 10             	add    $0x10,%esp
      }
      break;
8010093a:	e9 92 00 00 00       	jmp    801009d1 <consoleintr+0x1d8>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
8010093f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100943:	0f 84 87 00 00 00    	je     801009d0 <consoleintr+0x1d7>
80100949:	8b 15 28 28 11 80    	mov    0x80112828,%edx
8010094f:	a1 20 28 11 80       	mov    0x80112820,%eax
80100954:	29 c2                	sub    %eax,%edx
80100956:	89 d0                	mov    %edx,%eax
80100958:	83 f8 7f             	cmp    $0x7f,%eax
8010095b:	77 73                	ja     801009d0 <consoleintr+0x1d7>
        c = (c == '\r') ? '\n' : c;
8010095d:	83 7d e0 0d          	cmpl   $0xd,-0x20(%ebp)
80100961:	74 05                	je     80100968 <consoleintr+0x16f>
80100963:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100966:	eb 05                	jmp    8010096d <consoleintr+0x174>
80100968:	b8 0a 00 00 00       	mov    $0xa,%eax
8010096d:	89 45 e0             	mov    %eax,-0x20(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
80100970:	a1 28 28 11 80       	mov    0x80112828,%eax
80100975:	8d 50 01             	lea    0x1(%eax),%edx
80100978:	89 15 28 28 11 80    	mov    %edx,0x80112828
8010097e:	83 e0 7f             	and    $0x7f,%eax
80100981:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100984:	88 90 a0 27 11 80    	mov    %dl,-0x7feed860(%eax)
        consputc(c);
8010098a:	83 ec 0c             	sub    $0xc,%esp
8010098d:	ff 75 e0             	pushl  -0x20(%ebp)
80100990:	e8 fd fd ff ff       	call   80100792 <consputc>
80100995:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100998:	83 7d e0 0a          	cmpl   $0xa,-0x20(%ebp)
8010099c:	74 18                	je     801009b6 <consoleintr+0x1bd>
8010099e:	83 7d e0 04          	cmpl   $0x4,-0x20(%ebp)
801009a2:	74 12                	je     801009b6 <consoleintr+0x1bd>
801009a4:	a1 28 28 11 80       	mov    0x80112828,%eax
801009a9:	8b 15 20 28 11 80    	mov    0x80112820,%edx
801009af:	83 ea 80             	sub    $0xffffff80,%edx
801009b2:	39 d0                	cmp    %edx,%eax
801009b4:	75 1a                	jne    801009d0 <consoleintr+0x1d7>
          input.w = input.e;
801009b6:	a1 28 28 11 80       	mov    0x80112828,%eax
801009bb:	a3 24 28 11 80       	mov    %eax,0x80112824
          wakeup(&input.r);
801009c0:	83 ec 0c             	sub    $0xc,%esp
801009c3:	68 20 28 11 80       	push   $0x80112820
801009c8:	e8 d6 49 00 00       	call   801053a3 <wakeup>
801009cd:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
801009d0:	90                   	nop
  #ifdef CS333_P3P4
  int doctrlr = 0, doctrlf = 0, doctrls = 0, doctrlz = 0;
  #endif

  acquire(&cons.lock);
  while((c = getc()) >= 0){
801009d1:	8b 45 08             	mov    0x8(%ebp),%eax
801009d4:	ff d0                	call   *%eax
801009d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801009d9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801009dd:	0f 89 54 fe ff ff    	jns    80100837 <consoleintr+0x3e>
        }
      }
      break;
    }
  }
  release(&cons.lock);
801009e3:	83 ec 0c             	sub    $0xc,%esp
801009e6:	68 e0 d5 10 80       	push   $0x8010d5e0
801009eb:	e8 e2 57 00 00       	call   801061d2 <release>
801009f0:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
801009f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801009f7:	74 05                	je     801009fe <consoleintr+0x205>
    procdump();  // now call procdump() wo. cons.lock held
801009f9:	e8 05 4b 00 00       	call   80105503 <procdump>
  }
  #ifdef CS333_P3P4
  if(doctrlr) {
801009fe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100a02:	74 05                	je     80100a09 <consoleintr+0x210>
    printReadyList();
80100a04:	e8 b3 52 00 00       	call   80105cbc <printReadyList>
  }
  if(doctrlf) {
80100a09:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80100a0d:	74 05                	je     80100a14 <consoleintr+0x21b>
    printFree();
80100a0f:	e8 71 53 00 00       	call   80105d85 <printFree>
  }
  if(doctrls) {
80100a14:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100a18:	74 05                	je     80100a1f <consoleintr+0x226>
    printSleepList();
80100a1a:	e8 a9 53 00 00       	call   80105dc8 <printSleepList>
  }
  if(doctrlz) {
80100a1f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100a23:	74 05                	je     80100a2a <consoleintr+0x231>
    printZombieList();
80100a25:	e8 c8 53 00 00       	call   80105df2 <printZombieList>
  }
  #endif
}
80100a2a:	90                   	nop
80100a2b:	c9                   	leave  
80100a2c:	c3                   	ret    

80100a2d <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
80100a2d:	55                   	push   %ebp
80100a2e:	89 e5                	mov    %esp,%ebp
80100a30:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
80100a33:	83 ec 0c             	sub    $0xc,%esp
80100a36:	ff 75 08             	pushl  0x8(%ebp)
80100a39:	e8 28 11 00 00       	call   80101b66 <iunlock>
80100a3e:	83 c4 10             	add    $0x10,%esp
  target = n;
80100a41:	8b 45 10             	mov    0x10(%ebp),%eax
80100a44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
80100a47:	83 ec 0c             	sub    $0xc,%esp
80100a4a:	68 e0 d5 10 80       	push   $0x8010d5e0
80100a4f:	e8 17 57 00 00       	call   8010616b <acquire>
80100a54:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
80100a57:	e9 ac 00 00 00       	jmp    80100b08 <consoleread+0xdb>
    while(input.r == input.w){
      if(proc->killed){
80100a5c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100a62:	8b 40 24             	mov    0x24(%eax),%eax
80100a65:	85 c0                	test   %eax,%eax
80100a67:	74 28                	je     80100a91 <consoleread+0x64>
        release(&cons.lock);
80100a69:	83 ec 0c             	sub    $0xc,%esp
80100a6c:	68 e0 d5 10 80       	push   $0x8010d5e0
80100a71:	e8 5c 57 00 00       	call   801061d2 <release>
80100a76:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
80100a79:	83 ec 0c             	sub    $0xc,%esp
80100a7c:	ff 75 08             	pushl  0x8(%ebp)
80100a7f:	e8 84 0f 00 00       	call   80101a08 <ilock>
80100a84:	83 c4 10             	add    $0x10,%esp
        return -1;
80100a87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100a8c:	e9 ab 00 00 00       	jmp    80100b3c <consoleread+0x10f>
      }
      sleep(&input.r, &cons.lock);
80100a91:	83 ec 08             	sub    $0x8,%esp
80100a94:	68 e0 d5 10 80       	push   $0x8010d5e0
80100a99:	68 20 28 11 80       	push   $0x80112820
80100a9e:	e8 5f 47 00 00       	call   80105202 <sleep>
80100aa3:	83 c4 10             	add    $0x10,%esp

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
80100aa6:	8b 15 20 28 11 80    	mov    0x80112820,%edx
80100aac:	a1 24 28 11 80       	mov    0x80112824,%eax
80100ab1:	39 c2                	cmp    %eax,%edx
80100ab3:	74 a7                	je     80100a5c <consoleread+0x2f>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100ab5:	a1 20 28 11 80       	mov    0x80112820,%eax
80100aba:	8d 50 01             	lea    0x1(%eax),%edx
80100abd:	89 15 20 28 11 80    	mov    %edx,0x80112820
80100ac3:	83 e0 7f             	and    $0x7f,%eax
80100ac6:	0f b6 80 a0 27 11 80 	movzbl -0x7feed860(%eax),%eax
80100acd:	0f be c0             	movsbl %al,%eax
80100ad0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100ad3:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100ad7:	75 17                	jne    80100af0 <consoleread+0xc3>
      if(n < target){
80100ad9:	8b 45 10             	mov    0x10(%ebp),%eax
80100adc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100adf:	73 2f                	jae    80100b10 <consoleread+0xe3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100ae1:	a1 20 28 11 80       	mov    0x80112820,%eax
80100ae6:	83 e8 01             	sub    $0x1,%eax
80100ae9:	a3 20 28 11 80       	mov    %eax,0x80112820
      }
      break;
80100aee:	eb 20                	jmp    80100b10 <consoleread+0xe3>
    }
    *dst++ = c;
80100af0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100af3:	8d 50 01             	lea    0x1(%eax),%edx
80100af6:	89 55 0c             	mov    %edx,0xc(%ebp)
80100af9:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100afc:	88 10                	mov    %dl,(%eax)
    --n;
80100afe:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100b02:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100b06:	74 0b                	je     80100b13 <consoleread+0xe6>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100b08:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100b0c:	7f 98                	jg     80100aa6 <consoleread+0x79>
80100b0e:	eb 04                	jmp    80100b14 <consoleread+0xe7>
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
80100b10:	90                   	nop
80100b11:	eb 01                	jmp    80100b14 <consoleread+0xe7>
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
80100b13:	90                   	nop
  }
  release(&cons.lock);
80100b14:	83 ec 0c             	sub    $0xc,%esp
80100b17:	68 e0 d5 10 80       	push   $0x8010d5e0
80100b1c:	e8 b1 56 00 00       	call   801061d2 <release>
80100b21:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100b24:	83 ec 0c             	sub    $0xc,%esp
80100b27:	ff 75 08             	pushl  0x8(%ebp)
80100b2a:	e8 d9 0e 00 00       	call   80101a08 <ilock>
80100b2f:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100b32:	8b 45 10             	mov    0x10(%ebp),%eax
80100b35:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100b38:	29 c2                	sub    %eax,%edx
80100b3a:	89 d0                	mov    %edx,%eax
}
80100b3c:	c9                   	leave  
80100b3d:	c3                   	ret    

80100b3e <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100b3e:	55                   	push   %ebp
80100b3f:	89 e5                	mov    %esp,%ebp
80100b41:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100b44:	83 ec 0c             	sub    $0xc,%esp
80100b47:	ff 75 08             	pushl  0x8(%ebp)
80100b4a:	e8 17 10 00 00       	call   80101b66 <iunlock>
80100b4f:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100b52:	83 ec 0c             	sub    $0xc,%esp
80100b55:	68 e0 d5 10 80       	push   $0x8010d5e0
80100b5a:	e8 0c 56 00 00       	call   8010616b <acquire>
80100b5f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100b62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100b69:	eb 21                	jmp    80100b8c <consolewrite+0x4e>
    consputc(buf[i] & 0xff);
80100b6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100b6e:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b71:	01 d0                	add    %edx,%eax
80100b73:	0f b6 00             	movzbl (%eax),%eax
80100b76:	0f be c0             	movsbl %al,%eax
80100b79:	0f b6 c0             	movzbl %al,%eax
80100b7c:	83 ec 0c             	sub    $0xc,%esp
80100b7f:	50                   	push   %eax
80100b80:	e8 0d fc ff ff       	call   80100792 <consputc>
80100b85:	83 c4 10             	add    $0x10,%esp
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100b88:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100b8f:	3b 45 10             	cmp    0x10(%ebp),%eax
80100b92:	7c d7                	jl     80100b6b <consolewrite+0x2d>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100b94:	83 ec 0c             	sub    $0xc,%esp
80100b97:	68 e0 d5 10 80       	push   $0x8010d5e0
80100b9c:	e8 31 56 00 00       	call   801061d2 <release>
80100ba1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100ba4:	83 ec 0c             	sub    $0xc,%esp
80100ba7:	ff 75 08             	pushl  0x8(%ebp)
80100baa:	e8 59 0e 00 00       	call   80101a08 <ilock>
80100baf:	83 c4 10             	add    $0x10,%esp

  return n;
80100bb2:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100bb5:	c9                   	leave  
80100bb6:	c3                   	ret    

80100bb7 <consoleinit>:

void
consoleinit(void)
{
80100bb7:	55                   	push   %ebp
80100bb8:	89 e5                	mov    %esp,%ebp
80100bba:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100bbd:	83 ec 08             	sub    $0x8,%esp
80100bc0:	68 9e 98 10 80       	push   $0x8010989e
80100bc5:	68 e0 d5 10 80       	push   $0x8010d5e0
80100bca:	e8 7a 55 00 00       	call   80106149 <initlock>
80100bcf:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100bd2:	c7 05 ec 31 11 80 3e 	movl   $0x80100b3e,0x801131ec
80100bd9:	0b 10 80 
  devsw[CONSOLE].read = consoleread;
80100bdc:	c7 05 e8 31 11 80 2d 	movl   $0x80100a2d,0x801131e8
80100be3:	0a 10 80 
  cons.locking = 1;
80100be6:	c7 05 14 d6 10 80 01 	movl   $0x1,0x8010d614
80100bed:	00 00 00 

  picenable(IRQ_KBD);
80100bf0:	83 ec 0c             	sub    $0xc,%esp
80100bf3:	6a 01                	push   $0x1
80100bf5:	e8 cf 33 00 00       	call   80103fc9 <picenable>
80100bfa:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_KBD, 0);
80100bfd:	83 ec 08             	sub    $0x8,%esp
80100c00:	6a 00                	push   $0x0
80100c02:	6a 01                	push   $0x1
80100c04:	e8 6f 1f 00 00       	call   80102b78 <ioapicenable>
80100c09:	83 c4 10             	add    $0x10,%esp
}
80100c0c:	90                   	nop
80100c0d:	c9                   	leave  
80100c0e:	c3                   	ret    

80100c0f <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100c0f:	55                   	push   %ebp
80100c10:	89 e5                	mov    %esp,%ebp
80100c12:	81 ec 18 01 00 00    	sub    $0x118,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100c18:	e8 ce 29 00 00       	call   801035eb <begin_op>
  if((ip = namei(path)) == 0){
80100c1d:	83 ec 0c             	sub    $0xc,%esp
80100c20:	ff 75 08             	pushl  0x8(%ebp)
80100c23:	e8 9e 19 00 00       	call   801025c6 <namei>
80100c28:	83 c4 10             	add    $0x10,%esp
80100c2b:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100c2e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100c32:	75 0f                	jne    80100c43 <exec+0x34>
    end_op();
80100c34:	e8 3e 2a 00 00       	call   80103677 <end_op>
    return -1;
80100c39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c3e:	e9 ce 03 00 00       	jmp    80101011 <exec+0x402>
  }
  ilock(ip);
80100c43:	83 ec 0c             	sub    $0xc,%esp
80100c46:	ff 75 d8             	pushl  -0x28(%ebp)
80100c49:	e8 ba 0d 00 00       	call   80101a08 <ilock>
80100c4e:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100c51:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100c58:	6a 34                	push   $0x34
80100c5a:	6a 00                	push   $0x0
80100c5c:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100c62:	50                   	push   %eax
80100c63:	ff 75 d8             	pushl  -0x28(%ebp)
80100c66:	e8 0b 13 00 00       	call   80101f76 <readi>
80100c6b:	83 c4 10             	add    $0x10,%esp
80100c6e:	83 f8 33             	cmp    $0x33,%eax
80100c71:	0f 86 49 03 00 00    	jbe    80100fc0 <exec+0x3b1>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100c77:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100c7d:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100c82:	0f 85 3b 03 00 00    	jne    80100fc3 <exec+0x3b4>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100c88:	e8 90 83 00 00       	call   8010901d <setupkvm>
80100c8d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100c90:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100c94:	0f 84 2c 03 00 00    	je     80100fc6 <exec+0x3b7>
    goto bad;

  // Load program into memory.
  sz = 0;
80100c9a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ca1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100ca8:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100cae:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100cb1:	e9 ab 00 00 00       	jmp    80100d61 <exec+0x152>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100cb6:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100cb9:	6a 20                	push   $0x20
80100cbb:	50                   	push   %eax
80100cbc:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100cc2:	50                   	push   %eax
80100cc3:	ff 75 d8             	pushl  -0x28(%ebp)
80100cc6:	e8 ab 12 00 00       	call   80101f76 <readi>
80100ccb:	83 c4 10             	add    $0x10,%esp
80100cce:	83 f8 20             	cmp    $0x20,%eax
80100cd1:	0f 85 f2 02 00 00    	jne    80100fc9 <exec+0x3ba>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100cd7:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100cdd:	83 f8 01             	cmp    $0x1,%eax
80100ce0:	75 71                	jne    80100d53 <exec+0x144>
      continue;
    if(ph.memsz < ph.filesz)
80100ce2:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100ce8:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100cee:	39 c2                	cmp    %eax,%edx
80100cf0:	0f 82 d6 02 00 00    	jb     80100fcc <exec+0x3bd>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100cf6:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100cfc:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100d02:	01 d0                	add    %edx,%eax
80100d04:	83 ec 04             	sub    $0x4,%esp
80100d07:	50                   	push   %eax
80100d08:	ff 75 e0             	pushl  -0x20(%ebp)
80100d0b:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d0e:	e8 b1 86 00 00       	call   801093c4 <allocuvm>
80100d13:	83 c4 10             	add    $0x10,%esp
80100d16:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d19:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d1d:	0f 84 ac 02 00 00    	je     80100fcf <exec+0x3c0>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100d23:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100d29:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100d2f:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100d35:	83 ec 0c             	sub    $0xc,%esp
80100d38:	52                   	push   %edx
80100d39:	50                   	push   %eax
80100d3a:	ff 75 d8             	pushl  -0x28(%ebp)
80100d3d:	51                   	push   %ecx
80100d3e:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d41:	e8 a7 85 00 00       	call   801092ed <loaduvm>
80100d46:	83 c4 20             	add    $0x20,%esp
80100d49:	85 c0                	test   %eax,%eax
80100d4b:	0f 88 81 02 00 00    	js     80100fd2 <exec+0x3c3>
80100d51:	eb 01                	jmp    80100d54 <exec+0x145>
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
80100d53:	90                   	nop
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d54:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100d58:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100d5b:	83 c0 20             	add    $0x20,%eax
80100d5e:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100d61:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100d68:	0f b7 c0             	movzwl %ax,%eax
80100d6b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100d6e:	0f 8f 42 ff ff ff    	jg     80100cb6 <exec+0xa7>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100d74:	83 ec 0c             	sub    $0xc,%esp
80100d77:	ff 75 d8             	pushl  -0x28(%ebp)
80100d7a:	e8 49 0f 00 00       	call   80101cc8 <iunlockput>
80100d7f:	83 c4 10             	add    $0x10,%esp
  end_op();
80100d82:	e8 f0 28 00 00       	call   80103677 <end_op>
  ip = 0;
80100d87:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100d8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d91:	05 ff 0f 00 00       	add    $0xfff,%eax
80100d96:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100d9b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100da1:	05 00 20 00 00       	add    $0x2000,%eax
80100da6:	83 ec 04             	sub    $0x4,%esp
80100da9:	50                   	push   %eax
80100daa:	ff 75 e0             	pushl  -0x20(%ebp)
80100dad:	ff 75 d4             	pushl  -0x2c(%ebp)
80100db0:	e8 0f 86 00 00       	call   801093c4 <allocuvm>
80100db5:	83 c4 10             	add    $0x10,%esp
80100db8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100dbb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100dbf:	0f 84 10 02 00 00    	je     80100fd5 <exec+0x3c6>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100dc5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100dc8:	2d 00 20 00 00       	sub    $0x2000,%eax
80100dcd:	83 ec 08             	sub    $0x8,%esp
80100dd0:	50                   	push   %eax
80100dd1:	ff 75 d4             	pushl  -0x2c(%ebp)
80100dd4:	e8 11 88 00 00       	call   801095ea <clearpteu>
80100dd9:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100ddc:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ddf:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100de2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100de9:	e9 96 00 00 00       	jmp    80100e84 <exec+0x275>
    if(argc >= MAXARG)
80100dee:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100df2:	0f 87 e0 01 00 00    	ja     80100fd8 <exec+0x3c9>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100df8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dfb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e02:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e05:	01 d0                	add    %edx,%eax
80100e07:	8b 00                	mov    (%eax),%eax
80100e09:	83 ec 0c             	sub    $0xc,%esp
80100e0c:	50                   	push   %eax
80100e0d:	e8 09 58 00 00       	call   8010661b <strlen>
80100e12:	83 c4 10             	add    $0x10,%esp
80100e15:	89 c2                	mov    %eax,%edx
80100e17:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e1a:	29 d0                	sub    %edx,%eax
80100e1c:	83 e8 01             	sub    $0x1,%eax
80100e1f:	83 e0 fc             	and    $0xfffffffc,%eax
80100e22:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e28:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e2f:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e32:	01 d0                	add    %edx,%eax
80100e34:	8b 00                	mov    (%eax),%eax
80100e36:	83 ec 0c             	sub    $0xc,%esp
80100e39:	50                   	push   %eax
80100e3a:	e8 dc 57 00 00       	call   8010661b <strlen>
80100e3f:	83 c4 10             	add    $0x10,%esp
80100e42:	83 c0 01             	add    $0x1,%eax
80100e45:	89 c1                	mov    %eax,%ecx
80100e47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e4a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e51:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e54:	01 d0                	add    %edx,%eax
80100e56:	8b 00                	mov    (%eax),%eax
80100e58:	51                   	push   %ecx
80100e59:	50                   	push   %eax
80100e5a:	ff 75 dc             	pushl  -0x24(%ebp)
80100e5d:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e60:	e8 3c 89 00 00       	call   801097a1 <copyout>
80100e65:	83 c4 10             	add    $0x10,%esp
80100e68:	85 c0                	test   %eax,%eax
80100e6a:	0f 88 6b 01 00 00    	js     80100fdb <exec+0x3cc>
      goto bad;
    ustack[3+argc] = sp;
80100e70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e73:	8d 50 03             	lea    0x3(%eax),%edx
80100e76:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e79:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100e80:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100e84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e87:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e8e:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e91:	01 d0                	add    %edx,%eax
80100e93:	8b 00                	mov    (%eax),%eax
80100e95:	85 c0                	test   %eax,%eax
80100e97:	0f 85 51 ff ff ff    	jne    80100dee <exec+0x1df>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100e9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ea0:	83 c0 03             	add    $0x3,%eax
80100ea3:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100eaa:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100eae:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100eb5:	ff ff ff 
  ustack[1] = argc;
80100eb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ebb:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ec1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ec4:	83 c0 01             	add    $0x1,%eax
80100ec7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100ece:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100ed1:	29 d0                	sub    %edx,%eax
80100ed3:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100ed9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100edc:	83 c0 04             	add    $0x4,%eax
80100edf:	c1 e0 02             	shl    $0x2,%eax
80100ee2:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ee5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ee8:	83 c0 04             	add    $0x4,%eax
80100eeb:	c1 e0 02             	shl    $0x2,%eax
80100eee:	50                   	push   %eax
80100eef:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100ef5:	50                   	push   %eax
80100ef6:	ff 75 dc             	pushl  -0x24(%ebp)
80100ef9:	ff 75 d4             	pushl  -0x2c(%ebp)
80100efc:	e8 a0 88 00 00       	call   801097a1 <copyout>
80100f01:	83 c4 10             	add    $0x10,%esp
80100f04:	85 c0                	test   %eax,%eax
80100f06:	0f 88 d2 00 00 00    	js     80100fde <exec+0x3cf>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100f0c:	8b 45 08             	mov    0x8(%ebp),%eax
80100f0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f15:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100f18:	eb 17                	jmp    80100f31 <exec+0x322>
    if(*s == '/')
80100f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f1d:	0f b6 00             	movzbl (%eax),%eax
80100f20:	3c 2f                	cmp    $0x2f,%al
80100f22:	75 09                	jne    80100f2d <exec+0x31e>
      last = s+1;
80100f24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f27:	83 c0 01             	add    $0x1,%eax
80100f2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100f2d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f34:	0f b6 00             	movzbl (%eax),%eax
80100f37:	84 c0                	test   %al,%al
80100f39:	75 df                	jne    80100f1a <exec+0x30b>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100f3b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f41:	83 c0 6c             	add    $0x6c,%eax
80100f44:	83 ec 04             	sub    $0x4,%esp
80100f47:	6a 10                	push   $0x10
80100f49:	ff 75 f0             	pushl  -0x10(%ebp)
80100f4c:	50                   	push   %eax
80100f4d:	e8 7f 56 00 00       	call   801065d1 <safestrcpy>
80100f52:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100f55:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f5b:	8b 40 04             	mov    0x4(%eax),%eax
80100f5e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100f61:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f67:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100f6a:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100f6d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f73:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100f76:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100f78:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f7e:	8b 40 18             	mov    0x18(%eax),%eax
80100f81:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100f87:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100f8a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f90:	8b 40 18             	mov    0x18(%eax),%eax
80100f93:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100f96:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100f99:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f9f:	83 ec 0c             	sub    $0xc,%esp
80100fa2:	50                   	push   %eax
80100fa3:	e8 5c 81 00 00       	call   80109104 <switchuvm>
80100fa8:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100fab:	83 ec 0c             	sub    $0xc,%esp
80100fae:	ff 75 d0             	pushl  -0x30(%ebp)
80100fb1:	e8 94 85 00 00       	call   8010954a <freevm>
80100fb6:	83 c4 10             	add    $0x10,%esp
  return 0;
80100fb9:	b8 00 00 00 00       	mov    $0x0,%eax
80100fbe:	eb 51                	jmp    80101011 <exec+0x402>
  ilock(ip);
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
80100fc0:	90                   	nop
80100fc1:	eb 1c                	jmp    80100fdf <exec+0x3d0>
  if(elf.magic != ELF_MAGIC)
    goto bad;
80100fc3:	90                   	nop
80100fc4:	eb 19                	jmp    80100fdf <exec+0x3d0>

  if((pgdir = setupkvm()) == 0)
    goto bad;
80100fc6:	90                   	nop
80100fc7:	eb 16                	jmp    80100fdf <exec+0x3d0>

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
80100fc9:	90                   	nop
80100fca:	eb 13                	jmp    80100fdf <exec+0x3d0>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
80100fcc:	90                   	nop
80100fcd:	eb 10                	jmp    80100fdf <exec+0x3d0>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
80100fcf:	90                   	nop
80100fd0:	eb 0d                	jmp    80100fdf <exec+0x3d0>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
80100fd2:	90                   	nop
80100fd3:	eb 0a                	jmp    80100fdf <exec+0x3d0>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
80100fd5:	90                   	nop
80100fd6:	eb 07                	jmp    80100fdf <exec+0x3d0>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
80100fd8:	90                   	nop
80100fd9:	eb 04                	jmp    80100fdf <exec+0x3d0>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
80100fdb:	90                   	nop
80100fdc:	eb 01                	jmp    80100fdf <exec+0x3d0>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
80100fde:	90                   	nop
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
80100fdf:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100fe3:	74 0e                	je     80100ff3 <exec+0x3e4>
    freevm(pgdir);
80100fe5:	83 ec 0c             	sub    $0xc,%esp
80100fe8:	ff 75 d4             	pushl  -0x2c(%ebp)
80100feb:	e8 5a 85 00 00       	call   8010954a <freevm>
80100ff0:	83 c4 10             	add    $0x10,%esp
  if(ip){
80100ff3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100ff7:	74 13                	je     8010100c <exec+0x3fd>
    iunlockput(ip);
80100ff9:	83 ec 0c             	sub    $0xc,%esp
80100ffc:	ff 75 d8             	pushl  -0x28(%ebp)
80100fff:	e8 c4 0c 00 00       	call   80101cc8 <iunlockput>
80101004:	83 c4 10             	add    $0x10,%esp
    end_op();
80101007:	e8 6b 26 00 00       	call   80103677 <end_op>
  }
  return -1;
8010100c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101011:	c9                   	leave  
80101012:	c3                   	ret    

80101013 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101013:	55                   	push   %ebp
80101014:	89 e5                	mov    %esp,%ebp
80101016:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
80101019:	83 ec 08             	sub    $0x8,%esp
8010101c:	68 a6 98 10 80       	push   $0x801098a6
80101021:	68 40 28 11 80       	push   $0x80112840
80101026:	e8 1e 51 00 00       	call   80106149 <initlock>
8010102b:	83 c4 10             	add    $0x10,%esp
}
8010102e:	90                   	nop
8010102f:	c9                   	leave  
80101030:	c3                   	ret    

80101031 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101031:	55                   	push   %ebp
80101032:	89 e5                	mov    %esp,%ebp
80101034:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
80101037:	83 ec 0c             	sub    $0xc,%esp
8010103a:	68 40 28 11 80       	push   $0x80112840
8010103f:	e8 27 51 00 00       	call   8010616b <acquire>
80101044:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101047:	c7 45 f4 74 28 11 80 	movl   $0x80112874,-0xc(%ebp)
8010104e:	eb 2d                	jmp    8010107d <filealloc+0x4c>
    if(f->ref == 0){
80101050:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101053:	8b 40 04             	mov    0x4(%eax),%eax
80101056:	85 c0                	test   %eax,%eax
80101058:	75 1f                	jne    80101079 <filealloc+0x48>
      f->ref = 1;
8010105a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010105d:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80101064:	83 ec 0c             	sub    $0xc,%esp
80101067:	68 40 28 11 80       	push   $0x80112840
8010106c:	e8 61 51 00 00       	call   801061d2 <release>
80101071:	83 c4 10             	add    $0x10,%esp
      return f;
80101074:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101077:	eb 23                	jmp    8010109c <filealloc+0x6b>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101079:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
8010107d:	b8 d4 31 11 80       	mov    $0x801131d4,%eax
80101082:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80101085:	72 c9                	jb     80101050 <filealloc+0x1f>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80101087:	83 ec 0c             	sub    $0xc,%esp
8010108a:	68 40 28 11 80       	push   $0x80112840
8010108f:	e8 3e 51 00 00       	call   801061d2 <release>
80101094:	83 c4 10             	add    $0x10,%esp
  return 0;
80101097:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010109c:	c9                   	leave  
8010109d:	c3                   	ret    

8010109e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
8010109e:	55                   	push   %ebp
8010109f:	89 e5                	mov    %esp,%ebp
801010a1:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
801010a4:	83 ec 0c             	sub    $0xc,%esp
801010a7:	68 40 28 11 80       	push   $0x80112840
801010ac:	e8 ba 50 00 00       	call   8010616b <acquire>
801010b1:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801010b4:	8b 45 08             	mov    0x8(%ebp),%eax
801010b7:	8b 40 04             	mov    0x4(%eax),%eax
801010ba:	85 c0                	test   %eax,%eax
801010bc:	7f 0d                	jg     801010cb <filedup+0x2d>
    panic("filedup");
801010be:	83 ec 0c             	sub    $0xc,%esp
801010c1:	68 ad 98 10 80       	push   $0x801098ad
801010c6:	e8 9b f4 ff ff       	call   80100566 <panic>
  f->ref++;
801010cb:	8b 45 08             	mov    0x8(%ebp),%eax
801010ce:	8b 40 04             	mov    0x4(%eax),%eax
801010d1:	8d 50 01             	lea    0x1(%eax),%edx
801010d4:	8b 45 08             	mov    0x8(%ebp),%eax
801010d7:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
801010da:	83 ec 0c             	sub    $0xc,%esp
801010dd:	68 40 28 11 80       	push   $0x80112840
801010e2:	e8 eb 50 00 00       	call   801061d2 <release>
801010e7:	83 c4 10             	add    $0x10,%esp
  return f;
801010ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
801010ed:	c9                   	leave  
801010ee:	c3                   	ret    

801010ef <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801010ef:	55                   	push   %ebp
801010f0:	89 e5                	mov    %esp,%ebp
801010f2:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
801010f5:	83 ec 0c             	sub    $0xc,%esp
801010f8:	68 40 28 11 80       	push   $0x80112840
801010fd:	e8 69 50 00 00       	call   8010616b <acquire>
80101102:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101105:	8b 45 08             	mov    0x8(%ebp),%eax
80101108:	8b 40 04             	mov    0x4(%eax),%eax
8010110b:	85 c0                	test   %eax,%eax
8010110d:	7f 0d                	jg     8010111c <fileclose+0x2d>
    panic("fileclose");
8010110f:	83 ec 0c             	sub    $0xc,%esp
80101112:	68 b5 98 10 80       	push   $0x801098b5
80101117:	e8 4a f4 ff ff       	call   80100566 <panic>
  if(--f->ref > 0){
8010111c:	8b 45 08             	mov    0x8(%ebp),%eax
8010111f:	8b 40 04             	mov    0x4(%eax),%eax
80101122:	8d 50 ff             	lea    -0x1(%eax),%edx
80101125:	8b 45 08             	mov    0x8(%ebp),%eax
80101128:	89 50 04             	mov    %edx,0x4(%eax)
8010112b:	8b 45 08             	mov    0x8(%ebp),%eax
8010112e:	8b 40 04             	mov    0x4(%eax),%eax
80101131:	85 c0                	test   %eax,%eax
80101133:	7e 15                	jle    8010114a <fileclose+0x5b>
    release(&ftable.lock);
80101135:	83 ec 0c             	sub    $0xc,%esp
80101138:	68 40 28 11 80       	push   $0x80112840
8010113d:	e8 90 50 00 00       	call   801061d2 <release>
80101142:	83 c4 10             	add    $0x10,%esp
80101145:	e9 8b 00 00 00       	jmp    801011d5 <fileclose+0xe6>
    return;
  }
  ff = *f;
8010114a:	8b 45 08             	mov    0x8(%ebp),%eax
8010114d:	8b 10                	mov    (%eax),%edx
8010114f:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101152:	8b 50 04             	mov    0x4(%eax),%edx
80101155:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101158:	8b 50 08             	mov    0x8(%eax),%edx
8010115b:	89 55 e8             	mov    %edx,-0x18(%ebp)
8010115e:	8b 50 0c             	mov    0xc(%eax),%edx
80101161:	89 55 ec             	mov    %edx,-0x14(%ebp)
80101164:	8b 50 10             	mov    0x10(%eax),%edx
80101167:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010116a:	8b 40 14             	mov    0x14(%eax),%eax
8010116d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101170:	8b 45 08             	mov    0x8(%ebp),%eax
80101173:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
8010117a:	8b 45 08             	mov    0x8(%ebp),%eax
8010117d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101183:	83 ec 0c             	sub    $0xc,%esp
80101186:	68 40 28 11 80       	push   $0x80112840
8010118b:	e8 42 50 00 00       	call   801061d2 <release>
80101190:	83 c4 10             	add    $0x10,%esp
  
  if(ff.type == FD_PIPE)
80101193:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101196:	83 f8 01             	cmp    $0x1,%eax
80101199:	75 19                	jne    801011b4 <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
8010119b:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
8010119f:	0f be d0             	movsbl %al,%edx
801011a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801011a5:	83 ec 08             	sub    $0x8,%esp
801011a8:	52                   	push   %edx
801011a9:	50                   	push   %eax
801011aa:	e8 83 30 00 00       	call   80104232 <pipeclose>
801011af:	83 c4 10             	add    $0x10,%esp
801011b2:	eb 21                	jmp    801011d5 <fileclose+0xe6>
  else if(ff.type == FD_INODE){
801011b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011b7:	83 f8 02             	cmp    $0x2,%eax
801011ba:	75 19                	jne    801011d5 <fileclose+0xe6>
    begin_op();
801011bc:	e8 2a 24 00 00       	call   801035eb <begin_op>
    iput(ff.ip);
801011c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801011c4:	83 ec 0c             	sub    $0xc,%esp
801011c7:	50                   	push   %eax
801011c8:	e8 0b 0a 00 00       	call   80101bd8 <iput>
801011cd:	83 c4 10             	add    $0x10,%esp
    end_op();
801011d0:	e8 a2 24 00 00       	call   80103677 <end_op>
  }
}
801011d5:	c9                   	leave  
801011d6:	c3                   	ret    

801011d7 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801011d7:	55                   	push   %ebp
801011d8:	89 e5                	mov    %esp,%ebp
801011da:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
801011dd:	8b 45 08             	mov    0x8(%ebp),%eax
801011e0:	8b 00                	mov    (%eax),%eax
801011e2:	83 f8 02             	cmp    $0x2,%eax
801011e5:	75 40                	jne    80101227 <filestat+0x50>
    ilock(f->ip);
801011e7:	8b 45 08             	mov    0x8(%ebp),%eax
801011ea:	8b 40 10             	mov    0x10(%eax),%eax
801011ed:	83 ec 0c             	sub    $0xc,%esp
801011f0:	50                   	push   %eax
801011f1:	e8 12 08 00 00       	call   80101a08 <ilock>
801011f6:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
801011f9:	8b 45 08             	mov    0x8(%ebp),%eax
801011fc:	8b 40 10             	mov    0x10(%eax),%eax
801011ff:	83 ec 08             	sub    $0x8,%esp
80101202:	ff 75 0c             	pushl  0xc(%ebp)
80101205:	50                   	push   %eax
80101206:	e8 25 0d 00 00       	call   80101f30 <stati>
8010120b:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
8010120e:	8b 45 08             	mov    0x8(%ebp),%eax
80101211:	8b 40 10             	mov    0x10(%eax),%eax
80101214:	83 ec 0c             	sub    $0xc,%esp
80101217:	50                   	push   %eax
80101218:	e8 49 09 00 00       	call   80101b66 <iunlock>
8010121d:	83 c4 10             	add    $0x10,%esp
    return 0;
80101220:	b8 00 00 00 00       	mov    $0x0,%eax
80101225:	eb 05                	jmp    8010122c <filestat+0x55>
  }
  return -1;
80101227:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010122c:	c9                   	leave  
8010122d:	c3                   	ret    

8010122e <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
8010122e:	55                   	push   %ebp
8010122f:	89 e5                	mov    %esp,%ebp
80101231:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
80101234:	8b 45 08             	mov    0x8(%ebp),%eax
80101237:	0f b6 40 08          	movzbl 0x8(%eax),%eax
8010123b:	84 c0                	test   %al,%al
8010123d:	75 0a                	jne    80101249 <fileread+0x1b>
    return -1;
8010123f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101244:	e9 9b 00 00 00       	jmp    801012e4 <fileread+0xb6>
  if(f->type == FD_PIPE)
80101249:	8b 45 08             	mov    0x8(%ebp),%eax
8010124c:	8b 00                	mov    (%eax),%eax
8010124e:	83 f8 01             	cmp    $0x1,%eax
80101251:	75 1a                	jne    8010126d <fileread+0x3f>
    return piperead(f->pipe, addr, n);
80101253:	8b 45 08             	mov    0x8(%ebp),%eax
80101256:	8b 40 0c             	mov    0xc(%eax),%eax
80101259:	83 ec 04             	sub    $0x4,%esp
8010125c:	ff 75 10             	pushl  0x10(%ebp)
8010125f:	ff 75 0c             	pushl  0xc(%ebp)
80101262:	50                   	push   %eax
80101263:	e8 72 31 00 00       	call   801043da <piperead>
80101268:	83 c4 10             	add    $0x10,%esp
8010126b:	eb 77                	jmp    801012e4 <fileread+0xb6>
  if(f->type == FD_INODE){
8010126d:	8b 45 08             	mov    0x8(%ebp),%eax
80101270:	8b 00                	mov    (%eax),%eax
80101272:	83 f8 02             	cmp    $0x2,%eax
80101275:	75 60                	jne    801012d7 <fileread+0xa9>
    ilock(f->ip);
80101277:	8b 45 08             	mov    0x8(%ebp),%eax
8010127a:	8b 40 10             	mov    0x10(%eax),%eax
8010127d:	83 ec 0c             	sub    $0xc,%esp
80101280:	50                   	push   %eax
80101281:	e8 82 07 00 00       	call   80101a08 <ilock>
80101286:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101289:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010128c:	8b 45 08             	mov    0x8(%ebp),%eax
8010128f:	8b 50 14             	mov    0x14(%eax),%edx
80101292:	8b 45 08             	mov    0x8(%ebp),%eax
80101295:	8b 40 10             	mov    0x10(%eax),%eax
80101298:	51                   	push   %ecx
80101299:	52                   	push   %edx
8010129a:	ff 75 0c             	pushl  0xc(%ebp)
8010129d:	50                   	push   %eax
8010129e:	e8 d3 0c 00 00       	call   80101f76 <readi>
801012a3:	83 c4 10             	add    $0x10,%esp
801012a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801012a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801012ad:	7e 11                	jle    801012c0 <fileread+0x92>
      f->off += r;
801012af:	8b 45 08             	mov    0x8(%ebp),%eax
801012b2:	8b 50 14             	mov    0x14(%eax),%edx
801012b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012b8:	01 c2                	add    %eax,%edx
801012ba:	8b 45 08             	mov    0x8(%ebp),%eax
801012bd:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
801012c0:	8b 45 08             	mov    0x8(%ebp),%eax
801012c3:	8b 40 10             	mov    0x10(%eax),%eax
801012c6:	83 ec 0c             	sub    $0xc,%esp
801012c9:	50                   	push   %eax
801012ca:	e8 97 08 00 00       	call   80101b66 <iunlock>
801012cf:	83 c4 10             	add    $0x10,%esp
    return r;
801012d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012d5:	eb 0d                	jmp    801012e4 <fileread+0xb6>
  }
  panic("fileread");
801012d7:	83 ec 0c             	sub    $0xc,%esp
801012da:	68 bf 98 10 80       	push   $0x801098bf
801012df:	e8 82 f2 ff ff       	call   80100566 <panic>
}
801012e4:	c9                   	leave  
801012e5:	c3                   	ret    

801012e6 <filewrite>:

// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801012e6:	55                   	push   %ebp
801012e7:	89 e5                	mov    %esp,%ebp
801012e9:	53                   	push   %ebx
801012ea:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
801012ed:	8b 45 08             	mov    0x8(%ebp),%eax
801012f0:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801012f4:	84 c0                	test   %al,%al
801012f6:	75 0a                	jne    80101302 <filewrite+0x1c>
    return -1;
801012f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012fd:	e9 1b 01 00 00       	jmp    8010141d <filewrite+0x137>
  if(f->type == FD_PIPE)
80101302:	8b 45 08             	mov    0x8(%ebp),%eax
80101305:	8b 00                	mov    (%eax),%eax
80101307:	83 f8 01             	cmp    $0x1,%eax
8010130a:	75 1d                	jne    80101329 <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
8010130c:	8b 45 08             	mov    0x8(%ebp),%eax
8010130f:	8b 40 0c             	mov    0xc(%eax),%eax
80101312:	83 ec 04             	sub    $0x4,%esp
80101315:	ff 75 10             	pushl  0x10(%ebp)
80101318:	ff 75 0c             	pushl  0xc(%ebp)
8010131b:	50                   	push   %eax
8010131c:	e8 bb 2f 00 00       	call   801042dc <pipewrite>
80101321:	83 c4 10             	add    $0x10,%esp
80101324:	e9 f4 00 00 00       	jmp    8010141d <filewrite+0x137>
  if(f->type == FD_INODE){
80101329:	8b 45 08             	mov    0x8(%ebp),%eax
8010132c:	8b 00                	mov    (%eax),%eax
8010132e:	83 f8 02             	cmp    $0x2,%eax
80101331:	0f 85 d9 00 00 00    	jne    80101410 <filewrite+0x12a>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
80101337:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
8010133e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
80101345:	e9 a3 00 00 00       	jmp    801013ed <filewrite+0x107>
      int n1 = n - i;
8010134a:	8b 45 10             	mov    0x10(%ebp),%eax
8010134d:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101350:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101353:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101356:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101359:	7e 06                	jle    80101361 <filewrite+0x7b>
        n1 = max;
8010135b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010135e:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
80101361:	e8 85 22 00 00       	call   801035eb <begin_op>
      ilock(f->ip);
80101366:	8b 45 08             	mov    0x8(%ebp),%eax
80101369:	8b 40 10             	mov    0x10(%eax),%eax
8010136c:	83 ec 0c             	sub    $0xc,%esp
8010136f:	50                   	push   %eax
80101370:	e8 93 06 00 00       	call   80101a08 <ilock>
80101375:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101378:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010137b:	8b 45 08             	mov    0x8(%ebp),%eax
8010137e:	8b 50 14             	mov    0x14(%eax),%edx
80101381:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101384:	8b 45 0c             	mov    0xc(%ebp),%eax
80101387:	01 c3                	add    %eax,%ebx
80101389:	8b 45 08             	mov    0x8(%ebp),%eax
8010138c:	8b 40 10             	mov    0x10(%eax),%eax
8010138f:	51                   	push   %ecx
80101390:	52                   	push   %edx
80101391:	53                   	push   %ebx
80101392:	50                   	push   %eax
80101393:	e8 35 0d 00 00       	call   801020cd <writei>
80101398:	83 c4 10             	add    $0x10,%esp
8010139b:	89 45 e8             	mov    %eax,-0x18(%ebp)
8010139e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801013a2:	7e 11                	jle    801013b5 <filewrite+0xcf>
        f->off += r;
801013a4:	8b 45 08             	mov    0x8(%ebp),%eax
801013a7:	8b 50 14             	mov    0x14(%eax),%edx
801013aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013ad:	01 c2                	add    %eax,%edx
801013af:	8b 45 08             	mov    0x8(%ebp),%eax
801013b2:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801013b5:	8b 45 08             	mov    0x8(%ebp),%eax
801013b8:	8b 40 10             	mov    0x10(%eax),%eax
801013bb:	83 ec 0c             	sub    $0xc,%esp
801013be:	50                   	push   %eax
801013bf:	e8 a2 07 00 00       	call   80101b66 <iunlock>
801013c4:	83 c4 10             	add    $0x10,%esp
      end_op();
801013c7:	e8 ab 22 00 00       	call   80103677 <end_op>

      if(r < 0)
801013cc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801013d0:	78 29                	js     801013fb <filewrite+0x115>
        break;
      if(r != n1)
801013d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013d5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801013d8:	74 0d                	je     801013e7 <filewrite+0x101>
        panic("short filewrite");
801013da:	83 ec 0c             	sub    $0xc,%esp
801013dd:	68 c8 98 10 80       	push   $0x801098c8
801013e2:	e8 7f f1 ff ff       	call   80100566 <panic>
      i += r;
801013e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013ea:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801013ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013f0:	3b 45 10             	cmp    0x10(%ebp),%eax
801013f3:	0f 8c 51 ff ff ff    	jl     8010134a <filewrite+0x64>
801013f9:	eb 01                	jmp    801013fc <filewrite+0x116>
        f->off += r;
      iunlock(f->ip);
      end_op();

      if(r < 0)
        break;
801013fb:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801013fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013ff:	3b 45 10             	cmp    0x10(%ebp),%eax
80101402:	75 05                	jne    80101409 <filewrite+0x123>
80101404:	8b 45 10             	mov    0x10(%ebp),%eax
80101407:	eb 14                	jmp    8010141d <filewrite+0x137>
80101409:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010140e:	eb 0d                	jmp    8010141d <filewrite+0x137>
  }
  panic("filewrite");
80101410:	83 ec 0c             	sub    $0xc,%esp
80101413:	68 d8 98 10 80       	push   $0x801098d8
80101418:	e8 49 f1 ff ff       	call   80100566 <panic>
}
8010141d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101420:	c9                   	leave  
80101421:	c3                   	ret    

80101422 <readsb>:
struct superblock sb;   // there should be one per dev, but we run with one dev

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101422:	55                   	push   %ebp
80101423:	89 e5                	mov    %esp,%ebp
80101425:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
80101428:	8b 45 08             	mov    0x8(%ebp),%eax
8010142b:	83 ec 08             	sub    $0x8,%esp
8010142e:	6a 01                	push   $0x1
80101430:	50                   	push   %eax
80101431:	e8 80 ed ff ff       	call   801001b6 <bread>
80101436:	83 c4 10             	add    $0x10,%esp
80101439:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
8010143c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010143f:	83 c0 18             	add    $0x18,%eax
80101442:	83 ec 04             	sub    $0x4,%esp
80101445:	6a 1c                	push   $0x1c
80101447:	50                   	push   %eax
80101448:	ff 75 0c             	pushl  0xc(%ebp)
8010144b:	e8 3d 50 00 00       	call   8010648d <memmove>
80101450:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101453:	83 ec 0c             	sub    $0xc,%esp
80101456:	ff 75 f4             	pushl  -0xc(%ebp)
80101459:	e8 d0 ed ff ff       	call   8010022e <brelse>
8010145e:	83 c4 10             	add    $0x10,%esp
}
80101461:	90                   	nop
80101462:	c9                   	leave  
80101463:	c3                   	ret    

80101464 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101464:	55                   	push   %ebp
80101465:	89 e5                	mov    %esp,%ebp
80101467:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
8010146a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010146d:	8b 45 08             	mov    0x8(%ebp),%eax
80101470:	83 ec 08             	sub    $0x8,%esp
80101473:	52                   	push   %edx
80101474:	50                   	push   %eax
80101475:	e8 3c ed ff ff       	call   801001b6 <bread>
8010147a:	83 c4 10             	add    $0x10,%esp
8010147d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101480:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101483:	83 c0 18             	add    $0x18,%eax
80101486:	83 ec 04             	sub    $0x4,%esp
80101489:	68 00 02 00 00       	push   $0x200
8010148e:	6a 00                	push   $0x0
80101490:	50                   	push   %eax
80101491:	e8 38 4f 00 00       	call   801063ce <memset>
80101496:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
80101499:	83 ec 0c             	sub    $0xc,%esp
8010149c:	ff 75 f4             	pushl  -0xc(%ebp)
8010149f:	e8 7f 23 00 00       	call   80103823 <log_write>
801014a4:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801014a7:	83 ec 0c             	sub    $0xc,%esp
801014aa:	ff 75 f4             	pushl  -0xc(%ebp)
801014ad:	e8 7c ed ff ff       	call   8010022e <brelse>
801014b2:	83 c4 10             	add    $0x10,%esp
}
801014b5:	90                   	nop
801014b6:	c9                   	leave  
801014b7:	c3                   	ret    

801014b8 <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801014b8:	55                   	push   %ebp
801014b9:	89 e5                	mov    %esp,%ebp
801014bb:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
801014be:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801014c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801014cc:	e9 13 01 00 00       	jmp    801015e4 <balloc+0x12c>
    bp = bread(dev, BBLOCK(b, sb));
801014d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014d4:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801014da:	85 c0                	test   %eax,%eax
801014dc:	0f 48 c2             	cmovs  %edx,%eax
801014df:	c1 f8 0c             	sar    $0xc,%eax
801014e2:	89 c2                	mov    %eax,%edx
801014e4:	a1 58 32 11 80       	mov    0x80113258,%eax
801014e9:	01 d0                	add    %edx,%eax
801014eb:	83 ec 08             	sub    $0x8,%esp
801014ee:	50                   	push   %eax
801014ef:	ff 75 08             	pushl  0x8(%ebp)
801014f2:	e8 bf ec ff ff       	call   801001b6 <bread>
801014f7:	83 c4 10             	add    $0x10,%esp
801014fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014fd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101504:	e9 a6 00 00 00       	jmp    801015af <balloc+0xf7>
      m = 1 << (bi % 8);
80101509:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010150c:	99                   	cltd   
8010150d:	c1 ea 1d             	shr    $0x1d,%edx
80101510:	01 d0                	add    %edx,%eax
80101512:	83 e0 07             	and    $0x7,%eax
80101515:	29 d0                	sub    %edx,%eax
80101517:	ba 01 00 00 00       	mov    $0x1,%edx
8010151c:	89 c1                	mov    %eax,%ecx
8010151e:	d3 e2                	shl    %cl,%edx
80101520:	89 d0                	mov    %edx,%eax
80101522:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101525:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101528:	8d 50 07             	lea    0x7(%eax),%edx
8010152b:	85 c0                	test   %eax,%eax
8010152d:	0f 48 c2             	cmovs  %edx,%eax
80101530:	c1 f8 03             	sar    $0x3,%eax
80101533:	89 c2                	mov    %eax,%edx
80101535:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101538:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
8010153d:	0f b6 c0             	movzbl %al,%eax
80101540:	23 45 e8             	and    -0x18(%ebp),%eax
80101543:	85 c0                	test   %eax,%eax
80101545:	75 64                	jne    801015ab <balloc+0xf3>
        bp->data[bi/8] |= m;  // Mark block in use.
80101547:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010154a:	8d 50 07             	lea    0x7(%eax),%edx
8010154d:	85 c0                	test   %eax,%eax
8010154f:	0f 48 c2             	cmovs  %edx,%eax
80101552:	c1 f8 03             	sar    $0x3,%eax
80101555:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101558:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
8010155d:	89 d1                	mov    %edx,%ecx
8010155f:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101562:	09 ca                	or     %ecx,%edx
80101564:	89 d1                	mov    %edx,%ecx
80101566:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101569:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
8010156d:	83 ec 0c             	sub    $0xc,%esp
80101570:	ff 75 ec             	pushl  -0x14(%ebp)
80101573:	e8 ab 22 00 00       	call   80103823 <log_write>
80101578:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
8010157b:	83 ec 0c             	sub    $0xc,%esp
8010157e:	ff 75 ec             	pushl  -0x14(%ebp)
80101581:	e8 a8 ec ff ff       	call   8010022e <brelse>
80101586:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
80101589:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010158c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010158f:	01 c2                	add    %eax,%edx
80101591:	8b 45 08             	mov    0x8(%ebp),%eax
80101594:	83 ec 08             	sub    $0x8,%esp
80101597:	52                   	push   %edx
80101598:	50                   	push   %eax
80101599:	e8 c6 fe ff ff       	call   80101464 <bzero>
8010159e:	83 c4 10             	add    $0x10,%esp
        return b + bi;
801015a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015a7:	01 d0                	add    %edx,%eax
801015a9:	eb 57                	jmp    80101602 <balloc+0x14a>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801015ab:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801015af:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
801015b6:	7f 17                	jg     801015cf <balloc+0x117>
801015b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015be:	01 d0                	add    %edx,%eax
801015c0:	89 c2                	mov    %eax,%edx
801015c2:	a1 40 32 11 80       	mov    0x80113240,%eax
801015c7:	39 c2                	cmp    %eax,%edx
801015c9:	0f 82 3a ff ff ff    	jb     80101509 <balloc+0x51>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801015cf:	83 ec 0c             	sub    $0xc,%esp
801015d2:	ff 75 ec             	pushl  -0x14(%ebp)
801015d5:	e8 54 ec ff ff       	call   8010022e <brelse>
801015da:	83 c4 10             	add    $0x10,%esp
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801015dd:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801015e4:	8b 15 40 32 11 80    	mov    0x80113240,%edx
801015ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015ed:	39 c2                	cmp    %eax,%edx
801015ef:	0f 87 dc fe ff ff    	ja     801014d1 <balloc+0x19>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801015f5:	83 ec 0c             	sub    $0xc,%esp
801015f8:	68 e4 98 10 80       	push   $0x801098e4
801015fd:	e8 64 ef ff ff       	call   80100566 <panic>
}
80101602:	c9                   	leave  
80101603:	c3                   	ret    

80101604 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101604:	55                   	push   %ebp
80101605:	89 e5                	mov    %esp,%ebp
80101607:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
8010160a:	83 ec 08             	sub    $0x8,%esp
8010160d:	68 40 32 11 80       	push   $0x80113240
80101612:	ff 75 08             	pushl  0x8(%ebp)
80101615:	e8 08 fe ff ff       	call   80101422 <readsb>
8010161a:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
8010161d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101620:	c1 e8 0c             	shr    $0xc,%eax
80101623:	89 c2                	mov    %eax,%edx
80101625:	a1 58 32 11 80       	mov    0x80113258,%eax
8010162a:	01 c2                	add    %eax,%edx
8010162c:	8b 45 08             	mov    0x8(%ebp),%eax
8010162f:	83 ec 08             	sub    $0x8,%esp
80101632:	52                   	push   %edx
80101633:	50                   	push   %eax
80101634:	e8 7d eb ff ff       	call   801001b6 <bread>
80101639:	83 c4 10             	add    $0x10,%esp
8010163c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
8010163f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101642:	25 ff 0f 00 00       	and    $0xfff,%eax
80101647:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
8010164a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010164d:	99                   	cltd   
8010164e:	c1 ea 1d             	shr    $0x1d,%edx
80101651:	01 d0                	add    %edx,%eax
80101653:	83 e0 07             	and    $0x7,%eax
80101656:	29 d0                	sub    %edx,%eax
80101658:	ba 01 00 00 00       	mov    $0x1,%edx
8010165d:	89 c1                	mov    %eax,%ecx
8010165f:	d3 e2                	shl    %cl,%edx
80101661:	89 d0                	mov    %edx,%eax
80101663:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101666:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101669:	8d 50 07             	lea    0x7(%eax),%edx
8010166c:	85 c0                	test   %eax,%eax
8010166e:	0f 48 c2             	cmovs  %edx,%eax
80101671:	c1 f8 03             	sar    $0x3,%eax
80101674:	89 c2                	mov    %eax,%edx
80101676:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101679:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
8010167e:	0f b6 c0             	movzbl %al,%eax
80101681:	23 45 ec             	and    -0x14(%ebp),%eax
80101684:	85 c0                	test   %eax,%eax
80101686:	75 0d                	jne    80101695 <bfree+0x91>
    panic("freeing free block");
80101688:	83 ec 0c             	sub    $0xc,%esp
8010168b:	68 fa 98 10 80       	push   $0x801098fa
80101690:	e8 d1 ee ff ff       	call   80100566 <panic>
  bp->data[bi/8] &= ~m;
80101695:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101698:	8d 50 07             	lea    0x7(%eax),%edx
8010169b:	85 c0                	test   %eax,%eax
8010169d:	0f 48 c2             	cmovs  %edx,%eax
801016a0:	c1 f8 03             	sar    $0x3,%eax
801016a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016a6:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
801016ab:	89 d1                	mov    %edx,%ecx
801016ad:	8b 55 ec             	mov    -0x14(%ebp),%edx
801016b0:	f7 d2                	not    %edx
801016b2:	21 ca                	and    %ecx,%edx
801016b4:	89 d1                	mov    %edx,%ecx
801016b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016b9:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
801016bd:	83 ec 0c             	sub    $0xc,%esp
801016c0:	ff 75 f4             	pushl  -0xc(%ebp)
801016c3:	e8 5b 21 00 00       	call   80103823 <log_write>
801016c8:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801016cb:	83 ec 0c             	sub    $0xc,%esp
801016ce:	ff 75 f4             	pushl  -0xc(%ebp)
801016d1:	e8 58 eb ff ff       	call   8010022e <brelse>
801016d6:	83 c4 10             	add    $0x10,%esp
}
801016d9:	90                   	nop
801016da:	c9                   	leave  
801016db:	c3                   	ret    

801016dc <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
801016dc:	55                   	push   %ebp
801016dd:	89 e5                	mov    %esp,%ebp
801016df:	57                   	push   %edi
801016e0:	56                   	push   %esi
801016e1:	53                   	push   %ebx
801016e2:	83 ec 1c             	sub    $0x1c,%esp
  initlock(&icache.lock, "icache");
801016e5:	83 ec 08             	sub    $0x8,%esp
801016e8:	68 0d 99 10 80       	push   $0x8010990d
801016ed:	68 60 32 11 80       	push   $0x80113260
801016f2:	e8 52 4a 00 00       	call   80106149 <initlock>
801016f7:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
801016fa:	83 ec 08             	sub    $0x8,%esp
801016fd:	68 40 32 11 80       	push   $0x80113240
80101702:	ff 75 08             	pushl  0x8(%ebp)
80101705:	e8 18 fd ff ff       	call   80101422 <readsb>
8010170a:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d inodestart %d bmap start %d\n", sb.size,
8010170d:	a1 58 32 11 80       	mov    0x80113258,%eax
80101712:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101715:	8b 3d 54 32 11 80    	mov    0x80113254,%edi
8010171b:	8b 35 50 32 11 80    	mov    0x80113250,%esi
80101721:	8b 1d 4c 32 11 80    	mov    0x8011324c,%ebx
80101727:	8b 0d 48 32 11 80    	mov    0x80113248,%ecx
8010172d:	8b 15 44 32 11 80    	mov    0x80113244,%edx
80101733:	a1 40 32 11 80       	mov    0x80113240,%eax
80101738:	ff 75 e4             	pushl  -0x1c(%ebp)
8010173b:	57                   	push   %edi
8010173c:	56                   	push   %esi
8010173d:	53                   	push   %ebx
8010173e:	51                   	push   %ecx
8010173f:	52                   	push   %edx
80101740:	50                   	push   %eax
80101741:	68 14 99 10 80       	push   $0x80109914
80101746:	e8 7b ec ff ff       	call   801003c6 <cprintf>
8010174b:	83 c4 20             	add    $0x20,%esp
          sb.nblocks, sb.ninodes, sb.nlog, sb.logstart, sb.inodestart, sb.bmapstart);
}
8010174e:	90                   	nop
8010174f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101752:	5b                   	pop    %ebx
80101753:	5e                   	pop    %esi
80101754:	5f                   	pop    %edi
80101755:	5d                   	pop    %ebp
80101756:	c3                   	ret    

80101757 <ialloc>:

// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101757:	55                   	push   %ebp
80101758:	89 e5                	mov    %esp,%ebp
8010175a:	83 ec 28             	sub    $0x28,%esp
8010175d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101760:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101764:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
8010176b:	e9 9e 00 00 00       	jmp    8010180e <ialloc+0xb7>
    bp = bread(dev, IBLOCK(inum, sb));
80101770:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101773:	c1 e8 03             	shr    $0x3,%eax
80101776:	89 c2                	mov    %eax,%edx
80101778:	a1 54 32 11 80       	mov    0x80113254,%eax
8010177d:	01 d0                	add    %edx,%eax
8010177f:	83 ec 08             	sub    $0x8,%esp
80101782:	50                   	push   %eax
80101783:	ff 75 08             	pushl  0x8(%ebp)
80101786:	e8 2b ea ff ff       	call   801001b6 <bread>
8010178b:	83 c4 10             	add    $0x10,%esp
8010178e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101791:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101794:	8d 50 18             	lea    0x18(%eax),%edx
80101797:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010179a:	83 e0 07             	and    $0x7,%eax
8010179d:	c1 e0 06             	shl    $0x6,%eax
801017a0:	01 d0                	add    %edx,%eax
801017a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
801017a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801017a8:	0f b7 00             	movzwl (%eax),%eax
801017ab:	66 85 c0             	test   %ax,%ax
801017ae:	75 4c                	jne    801017fc <ialloc+0xa5>
      memset(dip, 0, sizeof(*dip));
801017b0:	83 ec 04             	sub    $0x4,%esp
801017b3:	6a 40                	push   $0x40
801017b5:	6a 00                	push   $0x0
801017b7:	ff 75 ec             	pushl  -0x14(%ebp)
801017ba:	e8 0f 4c 00 00       	call   801063ce <memset>
801017bf:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
801017c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801017c5:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
801017c9:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
801017cc:	83 ec 0c             	sub    $0xc,%esp
801017cf:	ff 75 f0             	pushl  -0x10(%ebp)
801017d2:	e8 4c 20 00 00       	call   80103823 <log_write>
801017d7:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
801017da:	83 ec 0c             	sub    $0xc,%esp
801017dd:	ff 75 f0             	pushl  -0x10(%ebp)
801017e0:	e8 49 ea ff ff       	call   8010022e <brelse>
801017e5:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
801017e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017eb:	83 ec 08             	sub    $0x8,%esp
801017ee:	50                   	push   %eax
801017ef:	ff 75 08             	pushl  0x8(%ebp)
801017f2:	e8 f8 00 00 00       	call   801018ef <iget>
801017f7:	83 c4 10             	add    $0x10,%esp
801017fa:	eb 30                	jmp    8010182c <ialloc+0xd5>
    }
    brelse(bp);
801017fc:	83 ec 0c             	sub    $0xc,%esp
801017ff:	ff 75 f0             	pushl  -0x10(%ebp)
80101802:	e8 27 ea ff ff       	call   8010022e <brelse>
80101807:	83 c4 10             	add    $0x10,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010180a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010180e:	8b 15 48 32 11 80    	mov    0x80113248,%edx
80101814:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101817:	39 c2                	cmp    %eax,%edx
80101819:	0f 87 51 ff ff ff    	ja     80101770 <ialloc+0x19>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
8010181f:	83 ec 0c             	sub    $0xc,%esp
80101822:	68 67 99 10 80       	push   $0x80109967
80101827:	e8 3a ed ff ff       	call   80100566 <panic>
}
8010182c:	c9                   	leave  
8010182d:	c3                   	ret    

8010182e <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
8010182e:	55                   	push   %ebp
8010182f:	89 e5                	mov    %esp,%ebp
80101831:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101834:	8b 45 08             	mov    0x8(%ebp),%eax
80101837:	8b 40 04             	mov    0x4(%eax),%eax
8010183a:	c1 e8 03             	shr    $0x3,%eax
8010183d:	89 c2                	mov    %eax,%edx
8010183f:	a1 54 32 11 80       	mov    0x80113254,%eax
80101844:	01 c2                	add    %eax,%edx
80101846:	8b 45 08             	mov    0x8(%ebp),%eax
80101849:	8b 00                	mov    (%eax),%eax
8010184b:	83 ec 08             	sub    $0x8,%esp
8010184e:	52                   	push   %edx
8010184f:	50                   	push   %eax
80101850:	e8 61 e9 ff ff       	call   801001b6 <bread>
80101855:	83 c4 10             	add    $0x10,%esp
80101858:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010185b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010185e:	8d 50 18             	lea    0x18(%eax),%edx
80101861:	8b 45 08             	mov    0x8(%ebp),%eax
80101864:	8b 40 04             	mov    0x4(%eax),%eax
80101867:	83 e0 07             	and    $0x7,%eax
8010186a:	c1 e0 06             	shl    $0x6,%eax
8010186d:	01 d0                	add    %edx,%eax
8010186f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101872:	8b 45 08             	mov    0x8(%ebp),%eax
80101875:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101879:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010187c:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010187f:	8b 45 08             	mov    0x8(%ebp),%eax
80101882:	0f b7 50 12          	movzwl 0x12(%eax),%edx
80101886:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101889:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
8010188d:	8b 45 08             	mov    0x8(%ebp),%eax
80101890:	0f b7 50 14          	movzwl 0x14(%eax),%edx
80101894:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101897:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
8010189b:	8b 45 08             	mov    0x8(%ebp),%eax
8010189e:	0f b7 50 16          	movzwl 0x16(%eax),%edx
801018a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018a5:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801018a9:	8b 45 08             	mov    0x8(%ebp),%eax
801018ac:	8b 50 18             	mov    0x18(%eax),%edx
801018af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018b2:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801018b5:	8b 45 08             	mov    0x8(%ebp),%eax
801018b8:	8d 50 1c             	lea    0x1c(%eax),%edx
801018bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018be:	83 c0 0c             	add    $0xc,%eax
801018c1:	83 ec 04             	sub    $0x4,%esp
801018c4:	6a 34                	push   $0x34
801018c6:	52                   	push   %edx
801018c7:	50                   	push   %eax
801018c8:	e8 c0 4b 00 00       	call   8010648d <memmove>
801018cd:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801018d0:	83 ec 0c             	sub    $0xc,%esp
801018d3:	ff 75 f4             	pushl  -0xc(%ebp)
801018d6:	e8 48 1f 00 00       	call   80103823 <log_write>
801018db:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801018de:	83 ec 0c             	sub    $0xc,%esp
801018e1:	ff 75 f4             	pushl  -0xc(%ebp)
801018e4:	e8 45 e9 ff ff       	call   8010022e <brelse>
801018e9:	83 c4 10             	add    $0x10,%esp
}
801018ec:	90                   	nop
801018ed:	c9                   	leave  
801018ee:	c3                   	ret    

801018ef <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801018ef:	55                   	push   %ebp
801018f0:	89 e5                	mov    %esp,%ebp
801018f2:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
801018f5:	83 ec 0c             	sub    $0xc,%esp
801018f8:	68 60 32 11 80       	push   $0x80113260
801018fd:	e8 69 48 00 00       	call   8010616b <acquire>
80101902:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
80101905:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010190c:	c7 45 f4 94 32 11 80 	movl   $0x80113294,-0xc(%ebp)
80101913:	eb 5d                	jmp    80101972 <iget+0x83>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101915:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101918:	8b 40 08             	mov    0x8(%eax),%eax
8010191b:	85 c0                	test   %eax,%eax
8010191d:	7e 39                	jle    80101958 <iget+0x69>
8010191f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101922:	8b 00                	mov    (%eax),%eax
80101924:	3b 45 08             	cmp    0x8(%ebp),%eax
80101927:	75 2f                	jne    80101958 <iget+0x69>
80101929:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010192c:	8b 40 04             	mov    0x4(%eax),%eax
8010192f:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101932:	75 24                	jne    80101958 <iget+0x69>
      ip->ref++;
80101934:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101937:	8b 40 08             	mov    0x8(%eax),%eax
8010193a:	8d 50 01             	lea    0x1(%eax),%edx
8010193d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101940:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101943:	83 ec 0c             	sub    $0xc,%esp
80101946:	68 60 32 11 80       	push   $0x80113260
8010194b:	e8 82 48 00 00       	call   801061d2 <release>
80101950:	83 c4 10             	add    $0x10,%esp
      return ip;
80101953:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101956:	eb 74                	jmp    801019cc <iget+0xdd>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101958:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010195c:	75 10                	jne    8010196e <iget+0x7f>
8010195e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101961:	8b 40 08             	mov    0x8(%eax),%eax
80101964:	85 c0                	test   %eax,%eax
80101966:	75 06                	jne    8010196e <iget+0x7f>
      empty = ip;
80101968:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010196b:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010196e:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
80101972:	81 7d f4 34 42 11 80 	cmpl   $0x80114234,-0xc(%ebp)
80101979:	72 9a                	jb     80101915 <iget+0x26>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
8010197b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010197f:	75 0d                	jne    8010198e <iget+0x9f>
    panic("iget: no inodes");
80101981:	83 ec 0c             	sub    $0xc,%esp
80101984:	68 79 99 10 80       	push   $0x80109979
80101989:	e8 d8 eb ff ff       	call   80100566 <panic>

  ip = empty;
8010198e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101991:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101994:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101997:	8b 55 08             	mov    0x8(%ebp),%edx
8010199a:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
8010199c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010199f:	8b 55 0c             	mov    0xc(%ebp),%edx
801019a2:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
801019a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019a8:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
801019af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019b2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
801019b9:	83 ec 0c             	sub    $0xc,%esp
801019bc:	68 60 32 11 80       	push   $0x80113260
801019c1:	e8 0c 48 00 00       	call   801061d2 <release>
801019c6:	83 c4 10             	add    $0x10,%esp

  return ip;
801019c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801019cc:	c9                   	leave  
801019cd:	c3                   	ret    

801019ce <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801019ce:	55                   	push   %ebp
801019cf:	89 e5                	mov    %esp,%ebp
801019d1:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
801019d4:	83 ec 0c             	sub    $0xc,%esp
801019d7:	68 60 32 11 80       	push   $0x80113260
801019dc:	e8 8a 47 00 00       	call   8010616b <acquire>
801019e1:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
801019e4:	8b 45 08             	mov    0x8(%ebp),%eax
801019e7:	8b 40 08             	mov    0x8(%eax),%eax
801019ea:	8d 50 01             	lea    0x1(%eax),%edx
801019ed:	8b 45 08             	mov    0x8(%ebp),%eax
801019f0:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
801019f3:	83 ec 0c             	sub    $0xc,%esp
801019f6:	68 60 32 11 80       	push   $0x80113260
801019fb:	e8 d2 47 00 00       	call   801061d2 <release>
80101a00:	83 c4 10             	add    $0x10,%esp
  return ip;
80101a03:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101a06:	c9                   	leave  
80101a07:	c3                   	ret    

80101a08 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101a08:	55                   	push   %ebp
80101a09:	89 e5                	mov    %esp,%ebp
80101a0b:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101a0e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a12:	74 0a                	je     80101a1e <ilock+0x16>
80101a14:	8b 45 08             	mov    0x8(%ebp),%eax
80101a17:	8b 40 08             	mov    0x8(%eax),%eax
80101a1a:	85 c0                	test   %eax,%eax
80101a1c:	7f 0d                	jg     80101a2b <ilock+0x23>
    panic("ilock");
80101a1e:	83 ec 0c             	sub    $0xc,%esp
80101a21:	68 89 99 10 80       	push   $0x80109989
80101a26:	e8 3b eb ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101a2b:	83 ec 0c             	sub    $0xc,%esp
80101a2e:	68 60 32 11 80       	push   $0x80113260
80101a33:	e8 33 47 00 00       	call   8010616b <acquire>
80101a38:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
80101a3b:	eb 13                	jmp    80101a50 <ilock+0x48>
    sleep(ip, &icache.lock);
80101a3d:	83 ec 08             	sub    $0x8,%esp
80101a40:	68 60 32 11 80       	push   $0x80113260
80101a45:	ff 75 08             	pushl  0x8(%ebp)
80101a48:	e8 b5 37 00 00       	call   80105202 <sleep>
80101a4d:	83 c4 10             	add    $0x10,%esp

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
80101a50:	8b 45 08             	mov    0x8(%ebp),%eax
80101a53:	8b 40 0c             	mov    0xc(%eax),%eax
80101a56:	83 e0 01             	and    $0x1,%eax
80101a59:	85 c0                	test   %eax,%eax
80101a5b:	75 e0                	jne    80101a3d <ilock+0x35>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
80101a5d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a60:	8b 40 0c             	mov    0xc(%eax),%eax
80101a63:	83 c8 01             	or     $0x1,%eax
80101a66:	89 c2                	mov    %eax,%edx
80101a68:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6b:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
80101a6e:	83 ec 0c             	sub    $0xc,%esp
80101a71:	68 60 32 11 80       	push   $0x80113260
80101a76:	e8 57 47 00 00       	call   801061d2 <release>
80101a7b:	83 c4 10             	add    $0x10,%esp

  if(!(ip->flags & I_VALID)){
80101a7e:	8b 45 08             	mov    0x8(%ebp),%eax
80101a81:	8b 40 0c             	mov    0xc(%eax),%eax
80101a84:	83 e0 02             	and    $0x2,%eax
80101a87:	85 c0                	test   %eax,%eax
80101a89:	0f 85 d4 00 00 00    	jne    80101b63 <ilock+0x15b>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a8f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a92:	8b 40 04             	mov    0x4(%eax),%eax
80101a95:	c1 e8 03             	shr    $0x3,%eax
80101a98:	89 c2                	mov    %eax,%edx
80101a9a:	a1 54 32 11 80       	mov    0x80113254,%eax
80101a9f:	01 c2                	add    %eax,%edx
80101aa1:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa4:	8b 00                	mov    (%eax),%eax
80101aa6:	83 ec 08             	sub    $0x8,%esp
80101aa9:	52                   	push   %edx
80101aaa:	50                   	push   %eax
80101aab:	e8 06 e7 ff ff       	call   801001b6 <bread>
80101ab0:	83 c4 10             	add    $0x10,%esp
80101ab3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ab9:	8d 50 18             	lea    0x18(%eax),%edx
80101abc:	8b 45 08             	mov    0x8(%ebp),%eax
80101abf:	8b 40 04             	mov    0x4(%eax),%eax
80101ac2:	83 e0 07             	and    $0x7,%eax
80101ac5:	c1 e0 06             	shl    $0x6,%eax
80101ac8:	01 d0                	add    %edx,%eax
80101aca:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101acd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ad0:	0f b7 10             	movzwl (%eax),%edx
80101ad3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad6:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
80101ada:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101add:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101ae1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae4:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
80101ae8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101aeb:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101aef:	8b 45 08             	mov    0x8(%ebp),%eax
80101af2:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80101af6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101af9:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101afd:	8b 45 08             	mov    0x8(%ebp),%eax
80101b00:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101b04:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b07:	8b 50 08             	mov    0x8(%eax),%edx
80101b0a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0d:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101b10:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b13:	8d 50 0c             	lea    0xc(%eax),%edx
80101b16:	8b 45 08             	mov    0x8(%ebp),%eax
80101b19:	83 c0 1c             	add    $0x1c,%eax
80101b1c:	83 ec 04             	sub    $0x4,%esp
80101b1f:	6a 34                	push   $0x34
80101b21:	52                   	push   %edx
80101b22:	50                   	push   %eax
80101b23:	e8 65 49 00 00       	call   8010648d <memmove>
80101b28:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101b2b:	83 ec 0c             	sub    $0xc,%esp
80101b2e:	ff 75 f4             	pushl  -0xc(%ebp)
80101b31:	e8 f8 e6 ff ff       	call   8010022e <brelse>
80101b36:	83 c4 10             	add    $0x10,%esp
    ip->flags |= I_VALID;
80101b39:	8b 45 08             	mov    0x8(%ebp),%eax
80101b3c:	8b 40 0c             	mov    0xc(%eax),%eax
80101b3f:	83 c8 02             	or     $0x2,%eax
80101b42:	89 c2                	mov    %eax,%edx
80101b44:	8b 45 08             	mov    0x8(%ebp),%eax
80101b47:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101b4a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b4d:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101b51:	66 85 c0             	test   %ax,%ax
80101b54:	75 0d                	jne    80101b63 <ilock+0x15b>
      panic("ilock: no type");
80101b56:	83 ec 0c             	sub    $0xc,%esp
80101b59:	68 8f 99 10 80       	push   $0x8010998f
80101b5e:	e8 03 ea ff ff       	call   80100566 <panic>
  }
}
80101b63:	90                   	nop
80101b64:	c9                   	leave  
80101b65:	c3                   	ret    

80101b66 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101b66:	55                   	push   %ebp
80101b67:	89 e5                	mov    %esp,%ebp
80101b69:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101b6c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101b70:	74 17                	je     80101b89 <iunlock+0x23>
80101b72:	8b 45 08             	mov    0x8(%ebp),%eax
80101b75:	8b 40 0c             	mov    0xc(%eax),%eax
80101b78:	83 e0 01             	and    $0x1,%eax
80101b7b:	85 c0                	test   %eax,%eax
80101b7d:	74 0a                	je     80101b89 <iunlock+0x23>
80101b7f:	8b 45 08             	mov    0x8(%ebp),%eax
80101b82:	8b 40 08             	mov    0x8(%eax),%eax
80101b85:	85 c0                	test   %eax,%eax
80101b87:	7f 0d                	jg     80101b96 <iunlock+0x30>
    panic("iunlock");
80101b89:	83 ec 0c             	sub    $0xc,%esp
80101b8c:	68 9e 99 10 80       	push   $0x8010999e
80101b91:	e8 d0 e9 ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101b96:	83 ec 0c             	sub    $0xc,%esp
80101b99:	68 60 32 11 80       	push   $0x80113260
80101b9e:	e8 c8 45 00 00       	call   8010616b <acquire>
80101ba3:	83 c4 10             	add    $0x10,%esp
  ip->flags &= ~I_BUSY;
80101ba6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ba9:	8b 40 0c             	mov    0xc(%eax),%eax
80101bac:	83 e0 fe             	and    $0xfffffffe,%eax
80101baf:	89 c2                	mov    %eax,%edx
80101bb1:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb4:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101bb7:	83 ec 0c             	sub    $0xc,%esp
80101bba:	ff 75 08             	pushl  0x8(%ebp)
80101bbd:	e8 e1 37 00 00       	call   801053a3 <wakeup>
80101bc2:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101bc5:	83 ec 0c             	sub    $0xc,%esp
80101bc8:	68 60 32 11 80       	push   $0x80113260
80101bcd:	e8 00 46 00 00       	call   801061d2 <release>
80101bd2:	83 c4 10             	add    $0x10,%esp
}
80101bd5:	90                   	nop
80101bd6:	c9                   	leave  
80101bd7:	c3                   	ret    

80101bd8 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101bd8:	55                   	push   %ebp
80101bd9:	89 e5                	mov    %esp,%ebp
80101bdb:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101bde:	83 ec 0c             	sub    $0xc,%esp
80101be1:	68 60 32 11 80       	push   $0x80113260
80101be6:	e8 80 45 00 00       	call   8010616b <acquire>
80101beb:	83 c4 10             	add    $0x10,%esp
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101bee:	8b 45 08             	mov    0x8(%ebp),%eax
80101bf1:	8b 40 08             	mov    0x8(%eax),%eax
80101bf4:	83 f8 01             	cmp    $0x1,%eax
80101bf7:	0f 85 a9 00 00 00    	jne    80101ca6 <iput+0xce>
80101bfd:	8b 45 08             	mov    0x8(%ebp),%eax
80101c00:	8b 40 0c             	mov    0xc(%eax),%eax
80101c03:	83 e0 02             	and    $0x2,%eax
80101c06:	85 c0                	test   %eax,%eax
80101c08:	0f 84 98 00 00 00    	je     80101ca6 <iput+0xce>
80101c0e:	8b 45 08             	mov    0x8(%ebp),%eax
80101c11:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101c15:	66 85 c0             	test   %ax,%ax
80101c18:	0f 85 88 00 00 00    	jne    80101ca6 <iput+0xce>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101c1e:	8b 45 08             	mov    0x8(%ebp),%eax
80101c21:	8b 40 0c             	mov    0xc(%eax),%eax
80101c24:	83 e0 01             	and    $0x1,%eax
80101c27:	85 c0                	test   %eax,%eax
80101c29:	74 0d                	je     80101c38 <iput+0x60>
      panic("iput busy");
80101c2b:	83 ec 0c             	sub    $0xc,%esp
80101c2e:	68 a6 99 10 80       	push   $0x801099a6
80101c33:	e8 2e e9 ff ff       	call   80100566 <panic>
    ip->flags |= I_BUSY;
80101c38:	8b 45 08             	mov    0x8(%ebp),%eax
80101c3b:	8b 40 0c             	mov    0xc(%eax),%eax
80101c3e:	83 c8 01             	or     $0x1,%eax
80101c41:	89 c2                	mov    %eax,%edx
80101c43:	8b 45 08             	mov    0x8(%ebp),%eax
80101c46:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101c49:	83 ec 0c             	sub    $0xc,%esp
80101c4c:	68 60 32 11 80       	push   $0x80113260
80101c51:	e8 7c 45 00 00       	call   801061d2 <release>
80101c56:	83 c4 10             	add    $0x10,%esp
    itrunc(ip);
80101c59:	83 ec 0c             	sub    $0xc,%esp
80101c5c:	ff 75 08             	pushl  0x8(%ebp)
80101c5f:	e8 a8 01 00 00       	call   80101e0c <itrunc>
80101c64:	83 c4 10             	add    $0x10,%esp
    ip->type = 0;
80101c67:	8b 45 08             	mov    0x8(%ebp),%eax
80101c6a:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101c70:	83 ec 0c             	sub    $0xc,%esp
80101c73:	ff 75 08             	pushl  0x8(%ebp)
80101c76:	e8 b3 fb ff ff       	call   8010182e <iupdate>
80101c7b:	83 c4 10             	add    $0x10,%esp
    acquire(&icache.lock);
80101c7e:	83 ec 0c             	sub    $0xc,%esp
80101c81:	68 60 32 11 80       	push   $0x80113260
80101c86:	e8 e0 44 00 00       	call   8010616b <acquire>
80101c8b:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101c8e:	8b 45 08             	mov    0x8(%ebp),%eax
80101c91:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101c98:	83 ec 0c             	sub    $0xc,%esp
80101c9b:	ff 75 08             	pushl  0x8(%ebp)
80101c9e:	e8 00 37 00 00       	call   801053a3 <wakeup>
80101ca3:	83 c4 10             	add    $0x10,%esp
  }
  ip->ref--;
80101ca6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ca9:	8b 40 08             	mov    0x8(%eax),%eax
80101cac:	8d 50 ff             	lea    -0x1(%eax),%edx
80101caf:	8b 45 08             	mov    0x8(%ebp),%eax
80101cb2:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101cb5:	83 ec 0c             	sub    $0xc,%esp
80101cb8:	68 60 32 11 80       	push   $0x80113260
80101cbd:	e8 10 45 00 00       	call   801061d2 <release>
80101cc2:	83 c4 10             	add    $0x10,%esp
}
80101cc5:	90                   	nop
80101cc6:	c9                   	leave  
80101cc7:	c3                   	ret    

80101cc8 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101cc8:	55                   	push   %ebp
80101cc9:	89 e5                	mov    %esp,%ebp
80101ccb:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101cce:	83 ec 0c             	sub    $0xc,%esp
80101cd1:	ff 75 08             	pushl  0x8(%ebp)
80101cd4:	e8 8d fe ff ff       	call   80101b66 <iunlock>
80101cd9:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101cdc:	83 ec 0c             	sub    $0xc,%esp
80101cdf:	ff 75 08             	pushl  0x8(%ebp)
80101ce2:	e8 f1 fe ff ff       	call   80101bd8 <iput>
80101ce7:	83 c4 10             	add    $0x10,%esp
}
80101cea:	90                   	nop
80101ceb:	c9                   	leave  
80101cec:	c3                   	ret    

80101ced <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101ced:	55                   	push   %ebp
80101cee:	89 e5                	mov    %esp,%ebp
80101cf0:	53                   	push   %ebx
80101cf1:	83 ec 14             	sub    $0x14,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101cf4:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101cf8:	77 42                	ja     80101d3c <bmap+0x4f>
    if((addr = ip->addrs[bn]) == 0)
80101cfa:	8b 45 08             	mov    0x8(%ebp),%eax
80101cfd:	8b 55 0c             	mov    0xc(%ebp),%edx
80101d00:	83 c2 04             	add    $0x4,%edx
80101d03:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d07:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d0e:	75 24                	jne    80101d34 <bmap+0x47>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101d10:	8b 45 08             	mov    0x8(%ebp),%eax
80101d13:	8b 00                	mov    (%eax),%eax
80101d15:	83 ec 0c             	sub    $0xc,%esp
80101d18:	50                   	push   %eax
80101d19:	e8 9a f7 ff ff       	call   801014b8 <balloc>
80101d1e:	83 c4 10             	add    $0x10,%esp
80101d21:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d24:	8b 45 08             	mov    0x8(%ebp),%eax
80101d27:	8b 55 0c             	mov    0xc(%ebp),%edx
80101d2a:	8d 4a 04             	lea    0x4(%edx),%ecx
80101d2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d30:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d37:	e9 cb 00 00 00       	jmp    80101e07 <bmap+0x11a>
  }
  bn -= NDIRECT;
80101d3c:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101d40:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101d44:	0f 87 b0 00 00 00    	ja     80101dfa <bmap+0x10d>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101d4a:	8b 45 08             	mov    0x8(%ebp),%eax
80101d4d:	8b 40 4c             	mov    0x4c(%eax),%eax
80101d50:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d53:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d57:	75 1d                	jne    80101d76 <bmap+0x89>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101d59:	8b 45 08             	mov    0x8(%ebp),%eax
80101d5c:	8b 00                	mov    (%eax),%eax
80101d5e:	83 ec 0c             	sub    $0xc,%esp
80101d61:	50                   	push   %eax
80101d62:	e8 51 f7 ff ff       	call   801014b8 <balloc>
80101d67:	83 c4 10             	add    $0x10,%esp
80101d6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d6d:	8b 45 08             	mov    0x8(%ebp),%eax
80101d70:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d73:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101d76:	8b 45 08             	mov    0x8(%ebp),%eax
80101d79:	8b 00                	mov    (%eax),%eax
80101d7b:	83 ec 08             	sub    $0x8,%esp
80101d7e:	ff 75 f4             	pushl  -0xc(%ebp)
80101d81:	50                   	push   %eax
80101d82:	e8 2f e4 ff ff       	call   801001b6 <bread>
80101d87:	83 c4 10             	add    $0x10,%esp
80101d8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101d8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d90:	83 c0 18             	add    $0x18,%eax
80101d93:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101d96:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d99:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101da0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101da3:	01 d0                	add    %edx,%eax
80101da5:	8b 00                	mov    (%eax),%eax
80101da7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101daa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101dae:	75 37                	jne    80101de7 <bmap+0xfa>
      a[bn] = addr = balloc(ip->dev);
80101db0:	8b 45 0c             	mov    0xc(%ebp),%eax
80101db3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101dba:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101dbd:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101dc0:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc3:	8b 00                	mov    (%eax),%eax
80101dc5:	83 ec 0c             	sub    $0xc,%esp
80101dc8:	50                   	push   %eax
80101dc9:	e8 ea f6 ff ff       	call   801014b8 <balloc>
80101dce:	83 c4 10             	add    $0x10,%esp
80101dd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101dd7:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101dd9:	83 ec 0c             	sub    $0xc,%esp
80101ddc:	ff 75 f0             	pushl  -0x10(%ebp)
80101ddf:	e8 3f 1a 00 00       	call   80103823 <log_write>
80101de4:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101de7:	83 ec 0c             	sub    $0xc,%esp
80101dea:	ff 75 f0             	pushl  -0x10(%ebp)
80101ded:	e8 3c e4 ff ff       	call   8010022e <brelse>
80101df2:	83 c4 10             	add    $0x10,%esp
    return addr;
80101df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101df8:	eb 0d                	jmp    80101e07 <bmap+0x11a>
  }

  panic("bmap: out of range");
80101dfa:	83 ec 0c             	sub    $0xc,%esp
80101dfd:	68 b0 99 10 80       	push   $0x801099b0
80101e02:	e8 5f e7 ff ff       	call   80100566 <panic>
}
80101e07:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101e0a:	c9                   	leave  
80101e0b:	c3                   	ret    

80101e0c <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101e0c:	55                   	push   %ebp
80101e0d:	89 e5                	mov    %esp,%ebp
80101e0f:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101e12:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101e19:	eb 45                	jmp    80101e60 <itrunc+0x54>
    if(ip->addrs[i]){
80101e1b:	8b 45 08             	mov    0x8(%ebp),%eax
80101e1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e21:	83 c2 04             	add    $0x4,%edx
80101e24:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101e28:	85 c0                	test   %eax,%eax
80101e2a:	74 30                	je     80101e5c <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101e2c:	8b 45 08             	mov    0x8(%ebp),%eax
80101e2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e32:	83 c2 04             	add    $0x4,%edx
80101e35:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101e39:	8b 55 08             	mov    0x8(%ebp),%edx
80101e3c:	8b 12                	mov    (%edx),%edx
80101e3e:	83 ec 08             	sub    $0x8,%esp
80101e41:	50                   	push   %eax
80101e42:	52                   	push   %edx
80101e43:	e8 bc f7 ff ff       	call   80101604 <bfree>
80101e48:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101e4b:	8b 45 08             	mov    0x8(%ebp),%eax
80101e4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e51:	83 c2 04             	add    $0x4,%edx
80101e54:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101e5b:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101e5c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101e60:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101e64:	7e b5                	jle    80101e1b <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101e66:	8b 45 08             	mov    0x8(%ebp),%eax
80101e69:	8b 40 4c             	mov    0x4c(%eax),%eax
80101e6c:	85 c0                	test   %eax,%eax
80101e6e:	0f 84 a1 00 00 00    	je     80101f15 <itrunc+0x109>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101e74:	8b 45 08             	mov    0x8(%ebp),%eax
80101e77:	8b 50 4c             	mov    0x4c(%eax),%edx
80101e7a:	8b 45 08             	mov    0x8(%ebp),%eax
80101e7d:	8b 00                	mov    (%eax),%eax
80101e7f:	83 ec 08             	sub    $0x8,%esp
80101e82:	52                   	push   %edx
80101e83:	50                   	push   %eax
80101e84:	e8 2d e3 ff ff       	call   801001b6 <bread>
80101e89:	83 c4 10             	add    $0x10,%esp
80101e8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101e8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e92:	83 c0 18             	add    $0x18,%eax
80101e95:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101e98:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101e9f:	eb 3c                	jmp    80101edd <itrunc+0xd1>
      if(a[j])
80101ea1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ea4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101eab:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101eae:	01 d0                	add    %edx,%eax
80101eb0:	8b 00                	mov    (%eax),%eax
80101eb2:	85 c0                	test   %eax,%eax
80101eb4:	74 23                	je     80101ed9 <itrunc+0xcd>
        bfree(ip->dev, a[j]);
80101eb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101eb9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101ec0:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101ec3:	01 d0                	add    %edx,%eax
80101ec5:	8b 00                	mov    (%eax),%eax
80101ec7:	8b 55 08             	mov    0x8(%ebp),%edx
80101eca:	8b 12                	mov    (%edx),%edx
80101ecc:	83 ec 08             	sub    $0x8,%esp
80101ecf:	50                   	push   %eax
80101ed0:	52                   	push   %edx
80101ed1:	e8 2e f7 ff ff       	call   80101604 <bfree>
80101ed6:	83 c4 10             	add    $0x10,%esp
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101ed9:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101edd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ee0:	83 f8 7f             	cmp    $0x7f,%eax
80101ee3:	76 bc                	jbe    80101ea1 <itrunc+0x95>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101ee5:	83 ec 0c             	sub    $0xc,%esp
80101ee8:	ff 75 ec             	pushl  -0x14(%ebp)
80101eeb:	e8 3e e3 ff ff       	call   8010022e <brelse>
80101ef0:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101ef3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ef6:	8b 40 4c             	mov    0x4c(%eax),%eax
80101ef9:	8b 55 08             	mov    0x8(%ebp),%edx
80101efc:	8b 12                	mov    (%edx),%edx
80101efe:	83 ec 08             	sub    $0x8,%esp
80101f01:	50                   	push   %eax
80101f02:	52                   	push   %edx
80101f03:	e8 fc f6 ff ff       	call   80101604 <bfree>
80101f08:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101f0b:	8b 45 08             	mov    0x8(%ebp),%eax
80101f0e:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101f15:	8b 45 08             	mov    0x8(%ebp),%eax
80101f18:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101f1f:	83 ec 0c             	sub    $0xc,%esp
80101f22:	ff 75 08             	pushl  0x8(%ebp)
80101f25:	e8 04 f9 ff ff       	call   8010182e <iupdate>
80101f2a:	83 c4 10             	add    $0x10,%esp
}
80101f2d:	90                   	nop
80101f2e:	c9                   	leave  
80101f2f:	c3                   	ret    

80101f30 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101f30:	55                   	push   %ebp
80101f31:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101f33:	8b 45 08             	mov    0x8(%ebp),%eax
80101f36:	8b 00                	mov    (%eax),%eax
80101f38:	89 c2                	mov    %eax,%edx
80101f3a:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f3d:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101f40:	8b 45 08             	mov    0x8(%ebp),%eax
80101f43:	8b 50 04             	mov    0x4(%eax),%edx
80101f46:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f49:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101f4c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f4f:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101f53:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f56:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101f59:	8b 45 08             	mov    0x8(%ebp),%eax
80101f5c:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101f60:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f63:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101f67:	8b 45 08             	mov    0x8(%ebp),%eax
80101f6a:	8b 50 18             	mov    0x18(%eax),%edx
80101f6d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f70:	89 50 10             	mov    %edx,0x10(%eax)
}
80101f73:	90                   	nop
80101f74:	5d                   	pop    %ebp
80101f75:	c3                   	ret    

80101f76 <readi>:

// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101f76:	55                   	push   %ebp
80101f77:	89 e5                	mov    %esp,%ebp
80101f79:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f7c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f7f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101f83:	66 83 f8 03          	cmp    $0x3,%ax
80101f87:	75 5c                	jne    80101fe5 <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101f89:	8b 45 08             	mov    0x8(%ebp),%eax
80101f8c:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f90:	66 85 c0             	test   %ax,%ax
80101f93:	78 20                	js     80101fb5 <readi+0x3f>
80101f95:	8b 45 08             	mov    0x8(%ebp),%eax
80101f98:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f9c:	66 83 f8 09          	cmp    $0x9,%ax
80101fa0:	7f 13                	jg     80101fb5 <readi+0x3f>
80101fa2:	8b 45 08             	mov    0x8(%ebp),%eax
80101fa5:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fa9:	98                   	cwtl   
80101faa:	8b 04 c5 e0 31 11 80 	mov    -0x7feece20(,%eax,8),%eax
80101fb1:	85 c0                	test   %eax,%eax
80101fb3:	75 0a                	jne    80101fbf <readi+0x49>
      return -1;
80101fb5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fba:	e9 0c 01 00 00       	jmp    801020cb <readi+0x155>
    return devsw[ip->major].read(ip, dst, n);
80101fbf:	8b 45 08             	mov    0x8(%ebp),%eax
80101fc2:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fc6:	98                   	cwtl   
80101fc7:	8b 04 c5 e0 31 11 80 	mov    -0x7feece20(,%eax,8),%eax
80101fce:	8b 55 14             	mov    0x14(%ebp),%edx
80101fd1:	83 ec 04             	sub    $0x4,%esp
80101fd4:	52                   	push   %edx
80101fd5:	ff 75 0c             	pushl  0xc(%ebp)
80101fd8:	ff 75 08             	pushl  0x8(%ebp)
80101fdb:	ff d0                	call   *%eax
80101fdd:	83 c4 10             	add    $0x10,%esp
80101fe0:	e9 e6 00 00 00       	jmp    801020cb <readi+0x155>
  }

  if(off > ip->size || off + n < off)
80101fe5:	8b 45 08             	mov    0x8(%ebp),%eax
80101fe8:	8b 40 18             	mov    0x18(%eax),%eax
80101feb:	3b 45 10             	cmp    0x10(%ebp),%eax
80101fee:	72 0d                	jb     80101ffd <readi+0x87>
80101ff0:	8b 55 10             	mov    0x10(%ebp),%edx
80101ff3:	8b 45 14             	mov    0x14(%ebp),%eax
80101ff6:	01 d0                	add    %edx,%eax
80101ff8:	3b 45 10             	cmp    0x10(%ebp),%eax
80101ffb:	73 0a                	jae    80102007 <readi+0x91>
    return -1;
80101ffd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102002:	e9 c4 00 00 00       	jmp    801020cb <readi+0x155>
  if(off + n > ip->size)
80102007:	8b 55 10             	mov    0x10(%ebp),%edx
8010200a:	8b 45 14             	mov    0x14(%ebp),%eax
8010200d:	01 c2                	add    %eax,%edx
8010200f:	8b 45 08             	mov    0x8(%ebp),%eax
80102012:	8b 40 18             	mov    0x18(%eax),%eax
80102015:	39 c2                	cmp    %eax,%edx
80102017:	76 0c                	jbe    80102025 <readi+0xaf>
    n = ip->size - off;
80102019:	8b 45 08             	mov    0x8(%ebp),%eax
8010201c:	8b 40 18             	mov    0x18(%eax),%eax
8010201f:	2b 45 10             	sub    0x10(%ebp),%eax
80102022:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102025:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010202c:	e9 8b 00 00 00       	jmp    801020bc <readi+0x146>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102031:	8b 45 10             	mov    0x10(%ebp),%eax
80102034:	c1 e8 09             	shr    $0x9,%eax
80102037:	83 ec 08             	sub    $0x8,%esp
8010203a:	50                   	push   %eax
8010203b:	ff 75 08             	pushl  0x8(%ebp)
8010203e:	e8 aa fc ff ff       	call   80101ced <bmap>
80102043:	83 c4 10             	add    $0x10,%esp
80102046:	89 c2                	mov    %eax,%edx
80102048:	8b 45 08             	mov    0x8(%ebp),%eax
8010204b:	8b 00                	mov    (%eax),%eax
8010204d:	83 ec 08             	sub    $0x8,%esp
80102050:	52                   	push   %edx
80102051:	50                   	push   %eax
80102052:	e8 5f e1 ff ff       	call   801001b6 <bread>
80102057:	83 c4 10             	add    $0x10,%esp
8010205a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
8010205d:	8b 45 10             	mov    0x10(%ebp),%eax
80102060:	25 ff 01 00 00       	and    $0x1ff,%eax
80102065:	ba 00 02 00 00       	mov    $0x200,%edx
8010206a:	29 c2                	sub    %eax,%edx
8010206c:	8b 45 14             	mov    0x14(%ebp),%eax
8010206f:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102072:	39 c2                	cmp    %eax,%edx
80102074:	0f 46 c2             	cmovbe %edx,%eax
80102077:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
8010207a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010207d:	8d 50 18             	lea    0x18(%eax),%edx
80102080:	8b 45 10             	mov    0x10(%ebp),%eax
80102083:	25 ff 01 00 00       	and    $0x1ff,%eax
80102088:	01 d0                	add    %edx,%eax
8010208a:	83 ec 04             	sub    $0x4,%esp
8010208d:	ff 75 ec             	pushl  -0x14(%ebp)
80102090:	50                   	push   %eax
80102091:	ff 75 0c             	pushl  0xc(%ebp)
80102094:	e8 f4 43 00 00       	call   8010648d <memmove>
80102099:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
8010209c:	83 ec 0c             	sub    $0xc,%esp
8010209f:	ff 75 f0             	pushl  -0x10(%ebp)
801020a2:	e8 87 e1 ff ff       	call   8010022e <brelse>
801020a7:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801020aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020ad:	01 45 f4             	add    %eax,-0xc(%ebp)
801020b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020b3:	01 45 10             	add    %eax,0x10(%ebp)
801020b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020b9:	01 45 0c             	add    %eax,0xc(%ebp)
801020bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020bf:	3b 45 14             	cmp    0x14(%ebp),%eax
801020c2:	0f 82 69 ff ff ff    	jb     80102031 <readi+0xbb>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
801020c8:	8b 45 14             	mov    0x14(%ebp),%eax
}
801020cb:	c9                   	leave  
801020cc:	c3                   	ret    

801020cd <writei>:

// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
801020cd:	55                   	push   %ebp
801020ce:	89 e5                	mov    %esp,%ebp
801020d0:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801020d3:	8b 45 08             	mov    0x8(%ebp),%eax
801020d6:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801020da:	66 83 f8 03          	cmp    $0x3,%ax
801020de:	75 5c                	jne    8010213c <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
801020e0:	8b 45 08             	mov    0x8(%ebp),%eax
801020e3:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020e7:	66 85 c0             	test   %ax,%ax
801020ea:	78 20                	js     8010210c <writei+0x3f>
801020ec:	8b 45 08             	mov    0x8(%ebp),%eax
801020ef:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020f3:	66 83 f8 09          	cmp    $0x9,%ax
801020f7:	7f 13                	jg     8010210c <writei+0x3f>
801020f9:	8b 45 08             	mov    0x8(%ebp),%eax
801020fc:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102100:	98                   	cwtl   
80102101:	8b 04 c5 e4 31 11 80 	mov    -0x7feece1c(,%eax,8),%eax
80102108:	85 c0                	test   %eax,%eax
8010210a:	75 0a                	jne    80102116 <writei+0x49>
      return -1;
8010210c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102111:	e9 3d 01 00 00       	jmp    80102253 <writei+0x186>
    return devsw[ip->major].write(ip, src, n);
80102116:	8b 45 08             	mov    0x8(%ebp),%eax
80102119:	0f b7 40 12          	movzwl 0x12(%eax),%eax
8010211d:	98                   	cwtl   
8010211e:	8b 04 c5 e4 31 11 80 	mov    -0x7feece1c(,%eax,8),%eax
80102125:	8b 55 14             	mov    0x14(%ebp),%edx
80102128:	83 ec 04             	sub    $0x4,%esp
8010212b:	52                   	push   %edx
8010212c:	ff 75 0c             	pushl  0xc(%ebp)
8010212f:	ff 75 08             	pushl  0x8(%ebp)
80102132:	ff d0                	call   *%eax
80102134:	83 c4 10             	add    $0x10,%esp
80102137:	e9 17 01 00 00       	jmp    80102253 <writei+0x186>
  }

  if(off > ip->size || off + n < off)
8010213c:	8b 45 08             	mov    0x8(%ebp),%eax
8010213f:	8b 40 18             	mov    0x18(%eax),%eax
80102142:	3b 45 10             	cmp    0x10(%ebp),%eax
80102145:	72 0d                	jb     80102154 <writei+0x87>
80102147:	8b 55 10             	mov    0x10(%ebp),%edx
8010214a:	8b 45 14             	mov    0x14(%ebp),%eax
8010214d:	01 d0                	add    %edx,%eax
8010214f:	3b 45 10             	cmp    0x10(%ebp),%eax
80102152:	73 0a                	jae    8010215e <writei+0x91>
    return -1;
80102154:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102159:	e9 f5 00 00 00       	jmp    80102253 <writei+0x186>
  if(off + n > MAXFILE*BSIZE)
8010215e:	8b 55 10             	mov    0x10(%ebp),%edx
80102161:	8b 45 14             	mov    0x14(%ebp),%eax
80102164:	01 d0                	add    %edx,%eax
80102166:	3d 00 18 01 00       	cmp    $0x11800,%eax
8010216b:	76 0a                	jbe    80102177 <writei+0xaa>
    return -1;
8010216d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102172:	e9 dc 00 00 00       	jmp    80102253 <writei+0x186>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102177:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010217e:	e9 99 00 00 00       	jmp    8010221c <writei+0x14f>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102183:	8b 45 10             	mov    0x10(%ebp),%eax
80102186:	c1 e8 09             	shr    $0x9,%eax
80102189:	83 ec 08             	sub    $0x8,%esp
8010218c:	50                   	push   %eax
8010218d:	ff 75 08             	pushl  0x8(%ebp)
80102190:	e8 58 fb ff ff       	call   80101ced <bmap>
80102195:	83 c4 10             	add    $0x10,%esp
80102198:	89 c2                	mov    %eax,%edx
8010219a:	8b 45 08             	mov    0x8(%ebp),%eax
8010219d:	8b 00                	mov    (%eax),%eax
8010219f:	83 ec 08             	sub    $0x8,%esp
801021a2:	52                   	push   %edx
801021a3:	50                   	push   %eax
801021a4:	e8 0d e0 ff ff       	call   801001b6 <bread>
801021a9:	83 c4 10             	add    $0x10,%esp
801021ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801021af:	8b 45 10             	mov    0x10(%ebp),%eax
801021b2:	25 ff 01 00 00       	and    $0x1ff,%eax
801021b7:	ba 00 02 00 00       	mov    $0x200,%edx
801021bc:	29 c2                	sub    %eax,%edx
801021be:	8b 45 14             	mov    0x14(%ebp),%eax
801021c1:	2b 45 f4             	sub    -0xc(%ebp),%eax
801021c4:	39 c2                	cmp    %eax,%edx
801021c6:	0f 46 c2             	cmovbe %edx,%eax
801021c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
801021cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801021cf:	8d 50 18             	lea    0x18(%eax),%edx
801021d2:	8b 45 10             	mov    0x10(%ebp),%eax
801021d5:	25 ff 01 00 00       	and    $0x1ff,%eax
801021da:	01 d0                	add    %edx,%eax
801021dc:	83 ec 04             	sub    $0x4,%esp
801021df:	ff 75 ec             	pushl  -0x14(%ebp)
801021e2:	ff 75 0c             	pushl  0xc(%ebp)
801021e5:	50                   	push   %eax
801021e6:	e8 a2 42 00 00       	call   8010648d <memmove>
801021eb:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
801021ee:	83 ec 0c             	sub    $0xc,%esp
801021f1:	ff 75 f0             	pushl  -0x10(%ebp)
801021f4:	e8 2a 16 00 00       	call   80103823 <log_write>
801021f9:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801021fc:	83 ec 0c             	sub    $0xc,%esp
801021ff:	ff 75 f0             	pushl  -0x10(%ebp)
80102202:	e8 27 e0 ff ff       	call   8010022e <brelse>
80102207:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010220a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010220d:	01 45 f4             	add    %eax,-0xc(%ebp)
80102210:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102213:	01 45 10             	add    %eax,0x10(%ebp)
80102216:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102219:	01 45 0c             	add    %eax,0xc(%ebp)
8010221c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010221f:	3b 45 14             	cmp    0x14(%ebp),%eax
80102222:	0f 82 5b ff ff ff    	jb     80102183 <writei+0xb6>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80102228:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010222c:	74 22                	je     80102250 <writei+0x183>
8010222e:	8b 45 08             	mov    0x8(%ebp),%eax
80102231:	8b 40 18             	mov    0x18(%eax),%eax
80102234:	3b 45 10             	cmp    0x10(%ebp),%eax
80102237:	73 17                	jae    80102250 <writei+0x183>
    ip->size = off;
80102239:	8b 45 08             	mov    0x8(%ebp),%eax
8010223c:	8b 55 10             	mov    0x10(%ebp),%edx
8010223f:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
80102242:	83 ec 0c             	sub    $0xc,%esp
80102245:	ff 75 08             	pushl  0x8(%ebp)
80102248:	e8 e1 f5 ff ff       	call   8010182e <iupdate>
8010224d:	83 c4 10             	add    $0x10,%esp
  }
  return n;
80102250:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102253:	c9                   	leave  
80102254:	c3                   	ret    

80102255 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
80102255:	55                   	push   %ebp
80102256:	89 e5                	mov    %esp,%ebp
80102258:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
8010225b:	83 ec 04             	sub    $0x4,%esp
8010225e:	6a 0e                	push   $0xe
80102260:	ff 75 0c             	pushl  0xc(%ebp)
80102263:	ff 75 08             	pushl  0x8(%ebp)
80102266:	e8 b8 42 00 00       	call   80106523 <strncmp>
8010226b:	83 c4 10             	add    $0x10,%esp
}
8010226e:	c9                   	leave  
8010226f:	c3                   	ret    

80102270 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102270:	55                   	push   %ebp
80102271:	89 e5                	mov    %esp,%ebp
80102273:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102276:	8b 45 08             	mov    0x8(%ebp),%eax
80102279:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010227d:	66 83 f8 01          	cmp    $0x1,%ax
80102281:	74 0d                	je     80102290 <dirlookup+0x20>
    panic("dirlookup not DIR");
80102283:	83 ec 0c             	sub    $0xc,%esp
80102286:	68 c3 99 10 80       	push   $0x801099c3
8010228b:	e8 d6 e2 ff ff       	call   80100566 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
80102290:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102297:	eb 7b                	jmp    80102314 <dirlookup+0xa4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102299:	6a 10                	push   $0x10
8010229b:	ff 75 f4             	pushl  -0xc(%ebp)
8010229e:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022a1:	50                   	push   %eax
801022a2:	ff 75 08             	pushl  0x8(%ebp)
801022a5:	e8 cc fc ff ff       	call   80101f76 <readi>
801022aa:	83 c4 10             	add    $0x10,%esp
801022ad:	83 f8 10             	cmp    $0x10,%eax
801022b0:	74 0d                	je     801022bf <dirlookup+0x4f>
      panic("dirlink read");
801022b2:	83 ec 0c             	sub    $0xc,%esp
801022b5:	68 d5 99 10 80       	push   $0x801099d5
801022ba:	e8 a7 e2 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
801022bf:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801022c3:	66 85 c0             	test   %ax,%ax
801022c6:	74 47                	je     8010230f <dirlookup+0x9f>
      continue;
    if(namecmp(name, de.name) == 0){
801022c8:	83 ec 08             	sub    $0x8,%esp
801022cb:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022ce:	83 c0 02             	add    $0x2,%eax
801022d1:	50                   	push   %eax
801022d2:	ff 75 0c             	pushl  0xc(%ebp)
801022d5:	e8 7b ff ff ff       	call   80102255 <namecmp>
801022da:	83 c4 10             	add    $0x10,%esp
801022dd:	85 c0                	test   %eax,%eax
801022df:	75 2f                	jne    80102310 <dirlookup+0xa0>
      // entry matches path element
      if(poff)
801022e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801022e5:	74 08                	je     801022ef <dirlookup+0x7f>
        *poff = off;
801022e7:	8b 45 10             	mov    0x10(%ebp),%eax
801022ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
801022ed:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
801022ef:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801022f3:	0f b7 c0             	movzwl %ax,%eax
801022f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
801022f9:	8b 45 08             	mov    0x8(%ebp),%eax
801022fc:	8b 00                	mov    (%eax),%eax
801022fe:	83 ec 08             	sub    $0x8,%esp
80102301:	ff 75 f0             	pushl  -0x10(%ebp)
80102304:	50                   	push   %eax
80102305:	e8 e5 f5 ff ff       	call   801018ef <iget>
8010230a:	83 c4 10             	add    $0x10,%esp
8010230d:	eb 19                	jmp    80102328 <dirlookup+0xb8>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
8010230f:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102310:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102314:	8b 45 08             	mov    0x8(%ebp),%eax
80102317:	8b 40 18             	mov    0x18(%eax),%eax
8010231a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010231d:	0f 87 76 ff ff ff    	ja     80102299 <dirlookup+0x29>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80102323:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102328:	c9                   	leave  
80102329:	c3                   	ret    

8010232a <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
8010232a:	55                   	push   %ebp
8010232b:	89 e5                	mov    %esp,%ebp
8010232d:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80102330:	83 ec 04             	sub    $0x4,%esp
80102333:	6a 00                	push   $0x0
80102335:	ff 75 0c             	pushl  0xc(%ebp)
80102338:	ff 75 08             	pushl  0x8(%ebp)
8010233b:	e8 30 ff ff ff       	call   80102270 <dirlookup>
80102340:	83 c4 10             	add    $0x10,%esp
80102343:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102346:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010234a:	74 18                	je     80102364 <dirlink+0x3a>
    iput(ip);
8010234c:	83 ec 0c             	sub    $0xc,%esp
8010234f:	ff 75 f0             	pushl  -0x10(%ebp)
80102352:	e8 81 f8 ff ff       	call   80101bd8 <iput>
80102357:	83 c4 10             	add    $0x10,%esp
    return -1;
8010235a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010235f:	e9 9c 00 00 00       	jmp    80102400 <dirlink+0xd6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102364:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010236b:	eb 39                	jmp    801023a6 <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010236d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102370:	6a 10                	push   $0x10
80102372:	50                   	push   %eax
80102373:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102376:	50                   	push   %eax
80102377:	ff 75 08             	pushl  0x8(%ebp)
8010237a:	e8 f7 fb ff ff       	call   80101f76 <readi>
8010237f:	83 c4 10             	add    $0x10,%esp
80102382:	83 f8 10             	cmp    $0x10,%eax
80102385:	74 0d                	je     80102394 <dirlink+0x6a>
      panic("dirlink read");
80102387:	83 ec 0c             	sub    $0xc,%esp
8010238a:	68 d5 99 10 80       	push   $0x801099d5
8010238f:	e8 d2 e1 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
80102394:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102398:	66 85 c0             	test   %ax,%ax
8010239b:	74 18                	je     801023b5 <dirlink+0x8b>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
8010239d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023a0:	83 c0 10             	add    $0x10,%eax
801023a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801023a6:	8b 45 08             	mov    0x8(%ebp),%eax
801023a9:	8b 50 18             	mov    0x18(%eax),%edx
801023ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023af:	39 c2                	cmp    %eax,%edx
801023b1:	77 ba                	ja     8010236d <dirlink+0x43>
801023b3:	eb 01                	jmp    801023b6 <dirlink+0x8c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
801023b5:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
801023b6:	83 ec 04             	sub    $0x4,%esp
801023b9:	6a 0e                	push   $0xe
801023bb:	ff 75 0c             	pushl  0xc(%ebp)
801023be:	8d 45 e0             	lea    -0x20(%ebp),%eax
801023c1:	83 c0 02             	add    $0x2,%eax
801023c4:	50                   	push   %eax
801023c5:	e8 af 41 00 00       	call   80106579 <strncpy>
801023ca:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
801023cd:	8b 45 10             	mov    0x10(%ebp),%eax
801023d0:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801023d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023d7:	6a 10                	push   $0x10
801023d9:	50                   	push   %eax
801023da:	8d 45 e0             	lea    -0x20(%ebp),%eax
801023dd:	50                   	push   %eax
801023de:	ff 75 08             	pushl  0x8(%ebp)
801023e1:	e8 e7 fc ff ff       	call   801020cd <writei>
801023e6:	83 c4 10             	add    $0x10,%esp
801023e9:	83 f8 10             	cmp    $0x10,%eax
801023ec:	74 0d                	je     801023fb <dirlink+0xd1>
    panic("dirlink");
801023ee:	83 ec 0c             	sub    $0xc,%esp
801023f1:	68 e2 99 10 80       	push   $0x801099e2
801023f6:	e8 6b e1 ff ff       	call   80100566 <panic>
  
  return 0;
801023fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102400:	c9                   	leave  
80102401:	c3                   	ret    

80102402 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80102402:	55                   	push   %ebp
80102403:	89 e5                	mov    %esp,%ebp
80102405:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
80102408:	eb 04                	jmp    8010240e <skipelem+0xc>
    path++;
8010240a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
8010240e:	8b 45 08             	mov    0x8(%ebp),%eax
80102411:	0f b6 00             	movzbl (%eax),%eax
80102414:	3c 2f                	cmp    $0x2f,%al
80102416:	74 f2                	je     8010240a <skipelem+0x8>
    path++;
  if(*path == 0)
80102418:	8b 45 08             	mov    0x8(%ebp),%eax
8010241b:	0f b6 00             	movzbl (%eax),%eax
8010241e:	84 c0                	test   %al,%al
80102420:	75 07                	jne    80102429 <skipelem+0x27>
    return 0;
80102422:	b8 00 00 00 00       	mov    $0x0,%eax
80102427:	eb 7b                	jmp    801024a4 <skipelem+0xa2>
  s = path;
80102429:	8b 45 08             	mov    0x8(%ebp),%eax
8010242c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
8010242f:	eb 04                	jmp    80102435 <skipelem+0x33>
    path++;
80102431:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80102435:	8b 45 08             	mov    0x8(%ebp),%eax
80102438:	0f b6 00             	movzbl (%eax),%eax
8010243b:	3c 2f                	cmp    $0x2f,%al
8010243d:	74 0a                	je     80102449 <skipelem+0x47>
8010243f:	8b 45 08             	mov    0x8(%ebp),%eax
80102442:	0f b6 00             	movzbl (%eax),%eax
80102445:	84 c0                	test   %al,%al
80102447:	75 e8                	jne    80102431 <skipelem+0x2f>
    path++;
  len = path - s;
80102449:	8b 55 08             	mov    0x8(%ebp),%edx
8010244c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010244f:	29 c2                	sub    %eax,%edx
80102451:	89 d0                	mov    %edx,%eax
80102453:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
80102456:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
8010245a:	7e 15                	jle    80102471 <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
8010245c:	83 ec 04             	sub    $0x4,%esp
8010245f:	6a 0e                	push   $0xe
80102461:	ff 75 f4             	pushl  -0xc(%ebp)
80102464:	ff 75 0c             	pushl  0xc(%ebp)
80102467:	e8 21 40 00 00       	call   8010648d <memmove>
8010246c:	83 c4 10             	add    $0x10,%esp
8010246f:	eb 26                	jmp    80102497 <skipelem+0x95>
  else {
    memmove(name, s, len);
80102471:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102474:	83 ec 04             	sub    $0x4,%esp
80102477:	50                   	push   %eax
80102478:	ff 75 f4             	pushl  -0xc(%ebp)
8010247b:	ff 75 0c             	pushl  0xc(%ebp)
8010247e:	e8 0a 40 00 00       	call   8010648d <memmove>
80102483:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
80102486:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102489:	8b 45 0c             	mov    0xc(%ebp),%eax
8010248c:	01 d0                	add    %edx,%eax
8010248e:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
80102491:	eb 04                	jmp    80102497 <skipelem+0x95>
    path++;
80102493:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102497:	8b 45 08             	mov    0x8(%ebp),%eax
8010249a:	0f b6 00             	movzbl (%eax),%eax
8010249d:	3c 2f                	cmp    $0x2f,%al
8010249f:	74 f2                	je     80102493 <skipelem+0x91>
    path++;
  return path;
801024a1:	8b 45 08             	mov    0x8(%ebp),%eax
}
801024a4:	c9                   	leave  
801024a5:	c3                   	ret    

801024a6 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801024a6:	55                   	push   %ebp
801024a7:	89 e5                	mov    %esp,%ebp
801024a9:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
801024ac:	8b 45 08             	mov    0x8(%ebp),%eax
801024af:	0f b6 00             	movzbl (%eax),%eax
801024b2:	3c 2f                	cmp    $0x2f,%al
801024b4:	75 17                	jne    801024cd <namex+0x27>
    ip = iget(ROOTDEV, ROOTINO);
801024b6:	83 ec 08             	sub    $0x8,%esp
801024b9:	6a 01                	push   $0x1
801024bb:	6a 01                	push   $0x1
801024bd:	e8 2d f4 ff ff       	call   801018ef <iget>
801024c2:	83 c4 10             	add    $0x10,%esp
801024c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801024c8:	e9 bb 00 00 00       	jmp    80102588 <namex+0xe2>
  else
    ip = idup(proc->cwd);
801024cd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801024d3:	8b 40 68             	mov    0x68(%eax),%eax
801024d6:	83 ec 0c             	sub    $0xc,%esp
801024d9:	50                   	push   %eax
801024da:	e8 ef f4 ff ff       	call   801019ce <idup>
801024df:	83 c4 10             	add    $0x10,%esp
801024e2:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
801024e5:	e9 9e 00 00 00       	jmp    80102588 <namex+0xe2>
    ilock(ip);
801024ea:	83 ec 0c             	sub    $0xc,%esp
801024ed:	ff 75 f4             	pushl  -0xc(%ebp)
801024f0:	e8 13 f5 ff ff       	call   80101a08 <ilock>
801024f5:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
801024f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024fb:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801024ff:	66 83 f8 01          	cmp    $0x1,%ax
80102503:	74 18                	je     8010251d <namex+0x77>
      iunlockput(ip);
80102505:	83 ec 0c             	sub    $0xc,%esp
80102508:	ff 75 f4             	pushl  -0xc(%ebp)
8010250b:	e8 b8 f7 ff ff       	call   80101cc8 <iunlockput>
80102510:	83 c4 10             	add    $0x10,%esp
      return 0;
80102513:	b8 00 00 00 00       	mov    $0x0,%eax
80102518:	e9 a7 00 00 00       	jmp    801025c4 <namex+0x11e>
    }
    if(nameiparent && *path == '\0'){
8010251d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102521:	74 20                	je     80102543 <namex+0x9d>
80102523:	8b 45 08             	mov    0x8(%ebp),%eax
80102526:	0f b6 00             	movzbl (%eax),%eax
80102529:	84 c0                	test   %al,%al
8010252b:	75 16                	jne    80102543 <namex+0x9d>
      // Stop one level early.
      iunlock(ip);
8010252d:	83 ec 0c             	sub    $0xc,%esp
80102530:	ff 75 f4             	pushl  -0xc(%ebp)
80102533:	e8 2e f6 ff ff       	call   80101b66 <iunlock>
80102538:	83 c4 10             	add    $0x10,%esp
      return ip;
8010253b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010253e:	e9 81 00 00 00       	jmp    801025c4 <namex+0x11e>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102543:	83 ec 04             	sub    $0x4,%esp
80102546:	6a 00                	push   $0x0
80102548:	ff 75 10             	pushl  0x10(%ebp)
8010254b:	ff 75 f4             	pushl  -0xc(%ebp)
8010254e:	e8 1d fd ff ff       	call   80102270 <dirlookup>
80102553:	83 c4 10             	add    $0x10,%esp
80102556:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102559:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010255d:	75 15                	jne    80102574 <namex+0xce>
      iunlockput(ip);
8010255f:	83 ec 0c             	sub    $0xc,%esp
80102562:	ff 75 f4             	pushl  -0xc(%ebp)
80102565:	e8 5e f7 ff ff       	call   80101cc8 <iunlockput>
8010256a:	83 c4 10             	add    $0x10,%esp
      return 0;
8010256d:	b8 00 00 00 00       	mov    $0x0,%eax
80102572:	eb 50                	jmp    801025c4 <namex+0x11e>
    }
    iunlockput(ip);
80102574:	83 ec 0c             	sub    $0xc,%esp
80102577:	ff 75 f4             	pushl  -0xc(%ebp)
8010257a:	e8 49 f7 ff ff       	call   80101cc8 <iunlockput>
8010257f:	83 c4 10             	add    $0x10,%esp
    ip = next;
80102582:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102585:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102588:	83 ec 08             	sub    $0x8,%esp
8010258b:	ff 75 10             	pushl  0x10(%ebp)
8010258e:	ff 75 08             	pushl  0x8(%ebp)
80102591:	e8 6c fe ff ff       	call   80102402 <skipelem>
80102596:	83 c4 10             	add    $0x10,%esp
80102599:	89 45 08             	mov    %eax,0x8(%ebp)
8010259c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801025a0:	0f 85 44 ff ff ff    	jne    801024ea <namex+0x44>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801025a6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801025aa:	74 15                	je     801025c1 <namex+0x11b>
    iput(ip);
801025ac:	83 ec 0c             	sub    $0xc,%esp
801025af:	ff 75 f4             	pushl  -0xc(%ebp)
801025b2:	e8 21 f6 ff ff       	call   80101bd8 <iput>
801025b7:	83 c4 10             	add    $0x10,%esp
    return 0;
801025ba:	b8 00 00 00 00       	mov    $0x0,%eax
801025bf:	eb 03                	jmp    801025c4 <namex+0x11e>
  }
  return ip;
801025c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801025c4:	c9                   	leave  
801025c5:	c3                   	ret    

801025c6 <namei>:

struct inode*
namei(char *path)
{
801025c6:	55                   	push   %ebp
801025c7:	89 e5                	mov    %esp,%ebp
801025c9:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
801025cc:	83 ec 04             	sub    $0x4,%esp
801025cf:	8d 45 ea             	lea    -0x16(%ebp),%eax
801025d2:	50                   	push   %eax
801025d3:	6a 00                	push   $0x0
801025d5:	ff 75 08             	pushl  0x8(%ebp)
801025d8:	e8 c9 fe ff ff       	call   801024a6 <namex>
801025dd:	83 c4 10             	add    $0x10,%esp
}
801025e0:	c9                   	leave  
801025e1:	c3                   	ret    

801025e2 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801025e2:	55                   	push   %ebp
801025e3:	89 e5                	mov    %esp,%ebp
801025e5:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
801025e8:	83 ec 04             	sub    $0x4,%esp
801025eb:	ff 75 0c             	pushl  0xc(%ebp)
801025ee:	6a 01                	push   $0x1
801025f0:	ff 75 08             	pushl  0x8(%ebp)
801025f3:	e8 ae fe ff ff       	call   801024a6 <namex>
801025f8:	83 c4 10             	add    $0x10,%esp
}
801025fb:	c9                   	leave  
801025fc:	c3                   	ret    

801025fd <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
801025fd:	55                   	push   %ebp
801025fe:	89 e5                	mov    %esp,%ebp
80102600:	83 ec 14             	sub    $0x14,%esp
80102603:	8b 45 08             	mov    0x8(%ebp),%eax
80102606:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010260a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010260e:	89 c2                	mov    %eax,%edx
80102610:	ec                   	in     (%dx),%al
80102611:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102614:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102618:	c9                   	leave  
80102619:	c3                   	ret    

8010261a <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
8010261a:	55                   	push   %ebp
8010261b:	89 e5                	mov    %esp,%ebp
8010261d:	57                   	push   %edi
8010261e:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
8010261f:	8b 55 08             	mov    0x8(%ebp),%edx
80102622:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102625:	8b 45 10             	mov    0x10(%ebp),%eax
80102628:	89 cb                	mov    %ecx,%ebx
8010262a:	89 df                	mov    %ebx,%edi
8010262c:	89 c1                	mov    %eax,%ecx
8010262e:	fc                   	cld    
8010262f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102631:	89 c8                	mov    %ecx,%eax
80102633:	89 fb                	mov    %edi,%ebx
80102635:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102638:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
8010263b:	90                   	nop
8010263c:	5b                   	pop    %ebx
8010263d:	5f                   	pop    %edi
8010263e:	5d                   	pop    %ebp
8010263f:	c3                   	ret    

80102640 <outb>:

static inline void
outb(ushort port, uchar data)
{
80102640:	55                   	push   %ebp
80102641:	89 e5                	mov    %esp,%ebp
80102643:	83 ec 08             	sub    $0x8,%esp
80102646:	8b 55 08             	mov    0x8(%ebp),%edx
80102649:	8b 45 0c             	mov    0xc(%ebp),%eax
8010264c:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102650:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102653:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102657:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010265b:	ee                   	out    %al,(%dx)
}
8010265c:	90                   	nop
8010265d:	c9                   	leave  
8010265e:	c3                   	ret    

8010265f <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
8010265f:	55                   	push   %ebp
80102660:	89 e5                	mov    %esp,%ebp
80102662:	56                   	push   %esi
80102663:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
80102664:	8b 55 08             	mov    0x8(%ebp),%edx
80102667:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010266a:	8b 45 10             	mov    0x10(%ebp),%eax
8010266d:	89 cb                	mov    %ecx,%ebx
8010266f:	89 de                	mov    %ebx,%esi
80102671:	89 c1                	mov    %eax,%ecx
80102673:	fc                   	cld    
80102674:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102676:	89 c8                	mov    %ecx,%eax
80102678:	89 f3                	mov    %esi,%ebx
8010267a:	89 5d 0c             	mov    %ebx,0xc(%ebp)
8010267d:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
80102680:	90                   	nop
80102681:	5b                   	pop    %ebx
80102682:	5e                   	pop    %esi
80102683:	5d                   	pop    %ebp
80102684:	c3                   	ret    

80102685 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102685:	55                   	push   %ebp
80102686:	89 e5                	mov    %esp,%ebp
80102688:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
8010268b:	90                   	nop
8010268c:	68 f7 01 00 00       	push   $0x1f7
80102691:	e8 67 ff ff ff       	call   801025fd <inb>
80102696:	83 c4 04             	add    $0x4,%esp
80102699:	0f b6 c0             	movzbl %al,%eax
8010269c:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010269f:	8b 45 fc             	mov    -0x4(%ebp),%eax
801026a2:	25 c0 00 00 00       	and    $0xc0,%eax
801026a7:	83 f8 40             	cmp    $0x40,%eax
801026aa:	75 e0                	jne    8010268c <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801026ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801026b0:	74 11                	je     801026c3 <idewait+0x3e>
801026b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801026b5:	83 e0 21             	and    $0x21,%eax
801026b8:	85 c0                	test   %eax,%eax
801026ba:	74 07                	je     801026c3 <idewait+0x3e>
    return -1;
801026bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801026c1:	eb 05                	jmp    801026c8 <idewait+0x43>
  return 0;
801026c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801026c8:	c9                   	leave  
801026c9:	c3                   	ret    

801026ca <ideinit>:

void
ideinit(void)
{
801026ca:	55                   	push   %ebp
801026cb:	89 e5                	mov    %esp,%ebp
801026cd:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  initlock(&idelock, "ide");
801026d0:	83 ec 08             	sub    $0x8,%esp
801026d3:	68 ea 99 10 80       	push   $0x801099ea
801026d8:	68 20 d6 10 80       	push   $0x8010d620
801026dd:	e8 67 3a 00 00       	call   80106149 <initlock>
801026e2:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
801026e5:	83 ec 0c             	sub    $0xc,%esp
801026e8:	6a 0e                	push   $0xe
801026ea:	e8 da 18 00 00       	call   80103fc9 <picenable>
801026ef:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
801026f2:	a1 60 49 11 80       	mov    0x80114960,%eax
801026f7:	83 e8 01             	sub    $0x1,%eax
801026fa:	83 ec 08             	sub    $0x8,%esp
801026fd:	50                   	push   %eax
801026fe:	6a 0e                	push   $0xe
80102700:	e8 73 04 00 00       	call   80102b78 <ioapicenable>
80102705:	83 c4 10             	add    $0x10,%esp
  idewait(0);
80102708:	83 ec 0c             	sub    $0xc,%esp
8010270b:	6a 00                	push   $0x0
8010270d:	e8 73 ff ff ff       	call   80102685 <idewait>
80102712:	83 c4 10             	add    $0x10,%esp
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
80102715:	83 ec 08             	sub    $0x8,%esp
80102718:	68 f0 00 00 00       	push   $0xf0
8010271d:	68 f6 01 00 00       	push   $0x1f6
80102722:	e8 19 ff ff ff       	call   80102640 <outb>
80102727:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
8010272a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102731:	eb 24                	jmp    80102757 <ideinit+0x8d>
    if(inb(0x1f7) != 0){
80102733:	83 ec 0c             	sub    $0xc,%esp
80102736:	68 f7 01 00 00       	push   $0x1f7
8010273b:	e8 bd fe ff ff       	call   801025fd <inb>
80102740:	83 c4 10             	add    $0x10,%esp
80102743:	84 c0                	test   %al,%al
80102745:	74 0c                	je     80102753 <ideinit+0x89>
      havedisk1 = 1;
80102747:	c7 05 58 d6 10 80 01 	movl   $0x1,0x8010d658
8010274e:	00 00 00 
      break;
80102751:	eb 0d                	jmp    80102760 <ideinit+0x96>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102753:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102757:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
8010275e:	7e d3                	jle    80102733 <ideinit+0x69>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
80102760:	83 ec 08             	sub    $0x8,%esp
80102763:	68 e0 00 00 00       	push   $0xe0
80102768:	68 f6 01 00 00       	push   $0x1f6
8010276d:	e8 ce fe ff ff       	call   80102640 <outb>
80102772:	83 c4 10             	add    $0x10,%esp
}
80102775:	90                   	nop
80102776:	c9                   	leave  
80102777:	c3                   	ret    

80102778 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102778:	55                   	push   %ebp
80102779:	89 e5                	mov    %esp,%ebp
8010277b:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
8010277e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102782:	75 0d                	jne    80102791 <idestart+0x19>
    panic("idestart");
80102784:	83 ec 0c             	sub    $0xc,%esp
80102787:	68 ee 99 10 80       	push   $0x801099ee
8010278c:	e8 d5 dd ff ff       	call   80100566 <panic>
  if(b->blockno >= FSSIZE)
80102791:	8b 45 08             	mov    0x8(%ebp),%eax
80102794:	8b 40 08             	mov    0x8(%eax),%eax
80102797:	3d cf 07 00 00       	cmp    $0x7cf,%eax
8010279c:	76 0d                	jbe    801027ab <idestart+0x33>
    panic("incorrect blockno");
8010279e:	83 ec 0c             	sub    $0xc,%esp
801027a1:	68 f7 99 10 80       	push   $0x801099f7
801027a6:	e8 bb dd ff ff       	call   80100566 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
801027ab:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
801027b2:	8b 45 08             	mov    0x8(%ebp),%eax
801027b5:	8b 50 08             	mov    0x8(%eax),%edx
801027b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027bb:	0f af c2             	imul   %edx,%eax
801027be:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if (sector_per_block > 7) panic("idestart");
801027c1:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
801027c5:	7e 0d                	jle    801027d4 <idestart+0x5c>
801027c7:	83 ec 0c             	sub    $0xc,%esp
801027ca:	68 ee 99 10 80       	push   $0x801099ee
801027cf:	e8 92 dd ff ff       	call   80100566 <panic>
  
  idewait(0);
801027d4:	83 ec 0c             	sub    $0xc,%esp
801027d7:	6a 00                	push   $0x0
801027d9:	e8 a7 fe ff ff       	call   80102685 <idewait>
801027de:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
801027e1:	83 ec 08             	sub    $0x8,%esp
801027e4:	6a 00                	push   $0x0
801027e6:	68 f6 03 00 00       	push   $0x3f6
801027eb:	e8 50 fe ff ff       	call   80102640 <outb>
801027f0:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
801027f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027f6:	0f b6 c0             	movzbl %al,%eax
801027f9:	83 ec 08             	sub    $0x8,%esp
801027fc:	50                   	push   %eax
801027fd:	68 f2 01 00 00       	push   $0x1f2
80102802:	e8 39 fe ff ff       	call   80102640 <outb>
80102807:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
8010280a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010280d:	0f b6 c0             	movzbl %al,%eax
80102810:	83 ec 08             	sub    $0x8,%esp
80102813:	50                   	push   %eax
80102814:	68 f3 01 00 00       	push   $0x1f3
80102819:	e8 22 fe ff ff       	call   80102640 <outb>
8010281e:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
80102821:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102824:	c1 f8 08             	sar    $0x8,%eax
80102827:	0f b6 c0             	movzbl %al,%eax
8010282a:	83 ec 08             	sub    $0x8,%esp
8010282d:	50                   	push   %eax
8010282e:	68 f4 01 00 00       	push   $0x1f4
80102833:	e8 08 fe ff ff       	call   80102640 <outb>
80102838:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
8010283b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010283e:	c1 f8 10             	sar    $0x10,%eax
80102841:	0f b6 c0             	movzbl %al,%eax
80102844:	83 ec 08             	sub    $0x8,%esp
80102847:	50                   	push   %eax
80102848:	68 f5 01 00 00       	push   $0x1f5
8010284d:	e8 ee fd ff ff       	call   80102640 <outb>
80102852:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102855:	8b 45 08             	mov    0x8(%ebp),%eax
80102858:	8b 40 04             	mov    0x4(%eax),%eax
8010285b:	83 e0 01             	and    $0x1,%eax
8010285e:	c1 e0 04             	shl    $0x4,%eax
80102861:	89 c2                	mov    %eax,%edx
80102863:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102866:	c1 f8 18             	sar    $0x18,%eax
80102869:	83 e0 0f             	and    $0xf,%eax
8010286c:	09 d0                	or     %edx,%eax
8010286e:	83 c8 e0             	or     $0xffffffe0,%eax
80102871:	0f b6 c0             	movzbl %al,%eax
80102874:	83 ec 08             	sub    $0x8,%esp
80102877:	50                   	push   %eax
80102878:	68 f6 01 00 00       	push   $0x1f6
8010287d:	e8 be fd ff ff       	call   80102640 <outb>
80102882:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
80102885:	8b 45 08             	mov    0x8(%ebp),%eax
80102888:	8b 00                	mov    (%eax),%eax
8010288a:	83 e0 04             	and    $0x4,%eax
8010288d:	85 c0                	test   %eax,%eax
8010288f:	74 30                	je     801028c1 <idestart+0x149>
    outb(0x1f7, IDE_CMD_WRITE);
80102891:	83 ec 08             	sub    $0x8,%esp
80102894:	6a 30                	push   $0x30
80102896:	68 f7 01 00 00       	push   $0x1f7
8010289b:	e8 a0 fd ff ff       	call   80102640 <outb>
801028a0:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
801028a3:	8b 45 08             	mov    0x8(%ebp),%eax
801028a6:	83 c0 18             	add    $0x18,%eax
801028a9:	83 ec 04             	sub    $0x4,%esp
801028ac:	68 80 00 00 00       	push   $0x80
801028b1:	50                   	push   %eax
801028b2:	68 f0 01 00 00       	push   $0x1f0
801028b7:	e8 a3 fd ff ff       	call   8010265f <outsl>
801028bc:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
801028bf:	eb 12                	jmp    801028d3 <idestart+0x15b>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, IDE_CMD_WRITE);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, IDE_CMD_READ);
801028c1:	83 ec 08             	sub    $0x8,%esp
801028c4:	6a 20                	push   $0x20
801028c6:	68 f7 01 00 00       	push   $0x1f7
801028cb:	e8 70 fd ff ff       	call   80102640 <outb>
801028d0:	83 c4 10             	add    $0x10,%esp
  }
}
801028d3:	90                   	nop
801028d4:	c9                   	leave  
801028d5:	c3                   	ret    

801028d6 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801028d6:	55                   	push   %ebp
801028d7:	89 e5                	mov    %esp,%ebp
801028d9:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801028dc:	83 ec 0c             	sub    $0xc,%esp
801028df:	68 20 d6 10 80       	push   $0x8010d620
801028e4:	e8 82 38 00 00       	call   8010616b <acquire>
801028e9:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
801028ec:	a1 54 d6 10 80       	mov    0x8010d654,%eax
801028f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801028f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801028f8:	75 15                	jne    8010290f <ideintr+0x39>
    release(&idelock);
801028fa:	83 ec 0c             	sub    $0xc,%esp
801028fd:	68 20 d6 10 80       	push   $0x8010d620
80102902:	e8 cb 38 00 00       	call   801061d2 <release>
80102907:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
8010290a:	e9 9a 00 00 00       	jmp    801029a9 <ideintr+0xd3>
  }
  idequeue = b->qnext;
8010290f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102912:	8b 40 14             	mov    0x14(%eax),%eax
80102915:	a3 54 d6 10 80       	mov    %eax,0x8010d654

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010291a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010291d:	8b 00                	mov    (%eax),%eax
8010291f:	83 e0 04             	and    $0x4,%eax
80102922:	85 c0                	test   %eax,%eax
80102924:	75 2d                	jne    80102953 <ideintr+0x7d>
80102926:	83 ec 0c             	sub    $0xc,%esp
80102929:	6a 01                	push   $0x1
8010292b:	e8 55 fd ff ff       	call   80102685 <idewait>
80102930:	83 c4 10             	add    $0x10,%esp
80102933:	85 c0                	test   %eax,%eax
80102935:	78 1c                	js     80102953 <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);
80102937:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010293a:	83 c0 18             	add    $0x18,%eax
8010293d:	83 ec 04             	sub    $0x4,%esp
80102940:	68 80 00 00 00       	push   $0x80
80102945:	50                   	push   %eax
80102946:	68 f0 01 00 00       	push   $0x1f0
8010294b:	e8 ca fc ff ff       	call   8010261a <insl>
80102950:	83 c4 10             	add    $0x10,%esp
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102953:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102956:	8b 00                	mov    (%eax),%eax
80102958:	83 c8 02             	or     $0x2,%eax
8010295b:	89 c2                	mov    %eax,%edx
8010295d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102960:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102962:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102965:	8b 00                	mov    (%eax),%eax
80102967:	83 e0 fb             	and    $0xfffffffb,%eax
8010296a:	89 c2                	mov    %eax,%edx
8010296c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010296f:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102971:	83 ec 0c             	sub    $0xc,%esp
80102974:	ff 75 f4             	pushl  -0xc(%ebp)
80102977:	e8 27 2a 00 00       	call   801053a3 <wakeup>
8010297c:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
8010297f:	a1 54 d6 10 80       	mov    0x8010d654,%eax
80102984:	85 c0                	test   %eax,%eax
80102986:	74 11                	je     80102999 <ideintr+0xc3>
    idestart(idequeue);
80102988:	a1 54 d6 10 80       	mov    0x8010d654,%eax
8010298d:	83 ec 0c             	sub    $0xc,%esp
80102990:	50                   	push   %eax
80102991:	e8 e2 fd ff ff       	call   80102778 <idestart>
80102996:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
80102999:	83 ec 0c             	sub    $0xc,%esp
8010299c:	68 20 d6 10 80       	push   $0x8010d620
801029a1:	e8 2c 38 00 00       	call   801061d2 <release>
801029a6:	83 c4 10             	add    $0x10,%esp
}
801029a9:	c9                   	leave  
801029aa:	c3                   	ret    

801029ab <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801029ab:	55                   	push   %ebp
801029ac:	89 e5                	mov    %esp,%ebp
801029ae:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
801029b1:	8b 45 08             	mov    0x8(%ebp),%eax
801029b4:	8b 00                	mov    (%eax),%eax
801029b6:	83 e0 01             	and    $0x1,%eax
801029b9:	85 c0                	test   %eax,%eax
801029bb:	75 0d                	jne    801029ca <iderw+0x1f>
    panic("iderw: buf not busy");
801029bd:	83 ec 0c             	sub    $0xc,%esp
801029c0:	68 09 9a 10 80       	push   $0x80109a09
801029c5:	e8 9c db ff ff       	call   80100566 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801029ca:	8b 45 08             	mov    0x8(%ebp),%eax
801029cd:	8b 00                	mov    (%eax),%eax
801029cf:	83 e0 06             	and    $0x6,%eax
801029d2:	83 f8 02             	cmp    $0x2,%eax
801029d5:	75 0d                	jne    801029e4 <iderw+0x39>
    panic("iderw: nothing to do");
801029d7:	83 ec 0c             	sub    $0xc,%esp
801029da:	68 1d 9a 10 80       	push   $0x80109a1d
801029df:	e8 82 db ff ff       	call   80100566 <panic>
  if(b->dev != 0 && !havedisk1)
801029e4:	8b 45 08             	mov    0x8(%ebp),%eax
801029e7:	8b 40 04             	mov    0x4(%eax),%eax
801029ea:	85 c0                	test   %eax,%eax
801029ec:	74 16                	je     80102a04 <iderw+0x59>
801029ee:	a1 58 d6 10 80       	mov    0x8010d658,%eax
801029f3:	85 c0                	test   %eax,%eax
801029f5:	75 0d                	jne    80102a04 <iderw+0x59>
    panic("iderw: ide disk 1 not present");
801029f7:	83 ec 0c             	sub    $0xc,%esp
801029fa:	68 32 9a 10 80       	push   $0x80109a32
801029ff:	e8 62 db ff ff       	call   80100566 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102a04:	83 ec 0c             	sub    $0xc,%esp
80102a07:	68 20 d6 10 80       	push   $0x8010d620
80102a0c:	e8 5a 37 00 00       	call   8010616b <acquire>
80102a11:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
80102a14:	8b 45 08             	mov    0x8(%ebp),%eax
80102a17:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102a1e:	c7 45 f4 54 d6 10 80 	movl   $0x8010d654,-0xc(%ebp)
80102a25:	eb 0b                	jmp    80102a32 <iderw+0x87>
80102a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a2a:	8b 00                	mov    (%eax),%eax
80102a2c:	83 c0 14             	add    $0x14,%eax
80102a2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a35:	8b 00                	mov    (%eax),%eax
80102a37:	85 c0                	test   %eax,%eax
80102a39:	75 ec                	jne    80102a27 <iderw+0x7c>
    ;
  *pp = b;
80102a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a3e:	8b 55 08             	mov    0x8(%ebp),%edx
80102a41:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102a43:	a1 54 d6 10 80       	mov    0x8010d654,%eax
80102a48:	3b 45 08             	cmp    0x8(%ebp),%eax
80102a4b:	75 23                	jne    80102a70 <iderw+0xc5>
    idestart(b);
80102a4d:	83 ec 0c             	sub    $0xc,%esp
80102a50:	ff 75 08             	pushl  0x8(%ebp)
80102a53:	e8 20 fd ff ff       	call   80102778 <idestart>
80102a58:	83 c4 10             	add    $0x10,%esp
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a5b:	eb 13                	jmp    80102a70 <iderw+0xc5>
    sleep(b, &idelock);
80102a5d:	83 ec 08             	sub    $0x8,%esp
80102a60:	68 20 d6 10 80       	push   $0x8010d620
80102a65:	ff 75 08             	pushl  0x8(%ebp)
80102a68:	e8 95 27 00 00       	call   80105202 <sleep>
80102a6d:	83 c4 10             	add    $0x10,%esp
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a70:	8b 45 08             	mov    0x8(%ebp),%eax
80102a73:	8b 00                	mov    (%eax),%eax
80102a75:	83 e0 06             	and    $0x6,%eax
80102a78:	83 f8 02             	cmp    $0x2,%eax
80102a7b:	75 e0                	jne    80102a5d <iderw+0xb2>
    sleep(b, &idelock);
  }

  release(&idelock);
80102a7d:	83 ec 0c             	sub    $0xc,%esp
80102a80:	68 20 d6 10 80       	push   $0x8010d620
80102a85:	e8 48 37 00 00       	call   801061d2 <release>
80102a8a:	83 c4 10             	add    $0x10,%esp
}
80102a8d:	90                   	nop
80102a8e:	c9                   	leave  
80102a8f:	c3                   	ret    

80102a90 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102a90:	55                   	push   %ebp
80102a91:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102a93:	a1 34 42 11 80       	mov    0x80114234,%eax
80102a98:	8b 55 08             	mov    0x8(%ebp),%edx
80102a9b:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102a9d:	a1 34 42 11 80       	mov    0x80114234,%eax
80102aa2:	8b 40 10             	mov    0x10(%eax),%eax
}
80102aa5:	5d                   	pop    %ebp
80102aa6:	c3                   	ret    

80102aa7 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102aa7:	55                   	push   %ebp
80102aa8:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102aaa:	a1 34 42 11 80       	mov    0x80114234,%eax
80102aaf:	8b 55 08             	mov    0x8(%ebp),%edx
80102ab2:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102ab4:	a1 34 42 11 80       	mov    0x80114234,%eax
80102ab9:	8b 55 0c             	mov    0xc(%ebp),%edx
80102abc:	89 50 10             	mov    %edx,0x10(%eax)
}
80102abf:	90                   	nop
80102ac0:	5d                   	pop    %ebp
80102ac1:	c3                   	ret    

80102ac2 <ioapicinit>:

void
ioapicinit(void)
{
80102ac2:	55                   	push   %ebp
80102ac3:	89 e5                	mov    %esp,%ebp
80102ac5:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if(!ismp)
80102ac8:	a1 64 43 11 80       	mov    0x80114364,%eax
80102acd:	85 c0                	test   %eax,%eax
80102acf:	0f 84 a0 00 00 00    	je     80102b75 <ioapicinit+0xb3>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102ad5:	c7 05 34 42 11 80 00 	movl   $0xfec00000,0x80114234
80102adc:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102adf:	6a 01                	push   $0x1
80102ae1:	e8 aa ff ff ff       	call   80102a90 <ioapicread>
80102ae6:	83 c4 04             	add    $0x4,%esp
80102ae9:	c1 e8 10             	shr    $0x10,%eax
80102aec:	25 ff 00 00 00       	and    $0xff,%eax
80102af1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102af4:	6a 00                	push   $0x0
80102af6:	e8 95 ff ff ff       	call   80102a90 <ioapicread>
80102afb:	83 c4 04             	add    $0x4,%esp
80102afe:	c1 e8 18             	shr    $0x18,%eax
80102b01:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102b04:	0f b6 05 60 43 11 80 	movzbl 0x80114360,%eax
80102b0b:	0f b6 c0             	movzbl %al,%eax
80102b0e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102b11:	74 10                	je     80102b23 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102b13:	83 ec 0c             	sub    $0xc,%esp
80102b16:	68 50 9a 10 80       	push   $0x80109a50
80102b1b:	e8 a6 d8 ff ff       	call   801003c6 <cprintf>
80102b20:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102b23:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102b2a:	eb 3f                	jmp    80102b6b <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b2f:	83 c0 20             	add    $0x20,%eax
80102b32:	0d 00 00 01 00       	or     $0x10000,%eax
80102b37:	89 c2                	mov    %eax,%edx
80102b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b3c:	83 c0 08             	add    $0x8,%eax
80102b3f:	01 c0                	add    %eax,%eax
80102b41:	83 ec 08             	sub    $0x8,%esp
80102b44:	52                   	push   %edx
80102b45:	50                   	push   %eax
80102b46:	e8 5c ff ff ff       	call   80102aa7 <ioapicwrite>
80102b4b:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b51:	83 c0 08             	add    $0x8,%eax
80102b54:	01 c0                	add    %eax,%eax
80102b56:	83 c0 01             	add    $0x1,%eax
80102b59:	83 ec 08             	sub    $0x8,%esp
80102b5c:	6a 00                	push   $0x0
80102b5e:	50                   	push   %eax
80102b5f:	e8 43 ff ff ff       	call   80102aa7 <ioapicwrite>
80102b64:	83 c4 10             	add    $0x10,%esp
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102b67:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b6e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102b71:	7e b9                	jle    80102b2c <ioapicinit+0x6a>
80102b73:	eb 01                	jmp    80102b76 <ioapicinit+0xb4>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
80102b75:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102b76:	c9                   	leave  
80102b77:	c3                   	ret    

80102b78 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102b78:	55                   	push   %ebp
80102b79:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102b7b:	a1 64 43 11 80       	mov    0x80114364,%eax
80102b80:	85 c0                	test   %eax,%eax
80102b82:	74 39                	je     80102bbd <ioapicenable+0x45>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102b84:	8b 45 08             	mov    0x8(%ebp),%eax
80102b87:	83 c0 20             	add    $0x20,%eax
80102b8a:	89 c2                	mov    %eax,%edx
80102b8c:	8b 45 08             	mov    0x8(%ebp),%eax
80102b8f:	83 c0 08             	add    $0x8,%eax
80102b92:	01 c0                	add    %eax,%eax
80102b94:	52                   	push   %edx
80102b95:	50                   	push   %eax
80102b96:	e8 0c ff ff ff       	call   80102aa7 <ioapicwrite>
80102b9b:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102b9e:	8b 45 0c             	mov    0xc(%ebp),%eax
80102ba1:	c1 e0 18             	shl    $0x18,%eax
80102ba4:	89 c2                	mov    %eax,%edx
80102ba6:	8b 45 08             	mov    0x8(%ebp),%eax
80102ba9:	83 c0 08             	add    $0x8,%eax
80102bac:	01 c0                	add    %eax,%eax
80102bae:	83 c0 01             	add    $0x1,%eax
80102bb1:	52                   	push   %edx
80102bb2:	50                   	push   %eax
80102bb3:	e8 ef fe ff ff       	call   80102aa7 <ioapicwrite>
80102bb8:	83 c4 08             	add    $0x8,%esp
80102bbb:	eb 01                	jmp    80102bbe <ioapicenable+0x46>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
80102bbd:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102bbe:	c9                   	leave  
80102bbf:	c3                   	ret    

80102bc0 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102bc0:	55                   	push   %ebp
80102bc1:	89 e5                	mov    %esp,%ebp
80102bc3:	8b 45 08             	mov    0x8(%ebp),%eax
80102bc6:	05 00 00 00 80       	add    $0x80000000,%eax
80102bcb:	5d                   	pop    %ebp
80102bcc:	c3                   	ret    

80102bcd <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102bcd:	55                   	push   %ebp
80102bce:	89 e5                	mov    %esp,%ebp
80102bd0:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102bd3:	83 ec 08             	sub    $0x8,%esp
80102bd6:	68 82 9a 10 80       	push   $0x80109a82
80102bdb:	68 40 42 11 80       	push   $0x80114240
80102be0:	e8 64 35 00 00       	call   80106149 <initlock>
80102be5:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102be8:	c7 05 74 42 11 80 00 	movl   $0x0,0x80114274
80102bef:	00 00 00 
  freerange(vstart, vend);
80102bf2:	83 ec 08             	sub    $0x8,%esp
80102bf5:	ff 75 0c             	pushl  0xc(%ebp)
80102bf8:	ff 75 08             	pushl  0x8(%ebp)
80102bfb:	e8 2a 00 00 00       	call   80102c2a <freerange>
80102c00:	83 c4 10             	add    $0x10,%esp
}
80102c03:	90                   	nop
80102c04:	c9                   	leave  
80102c05:	c3                   	ret    

80102c06 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102c06:	55                   	push   %ebp
80102c07:	89 e5                	mov    %esp,%ebp
80102c09:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102c0c:	83 ec 08             	sub    $0x8,%esp
80102c0f:	ff 75 0c             	pushl  0xc(%ebp)
80102c12:	ff 75 08             	pushl  0x8(%ebp)
80102c15:	e8 10 00 00 00       	call   80102c2a <freerange>
80102c1a:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102c1d:	c7 05 74 42 11 80 01 	movl   $0x1,0x80114274
80102c24:	00 00 00 
}
80102c27:	90                   	nop
80102c28:	c9                   	leave  
80102c29:	c3                   	ret    

80102c2a <freerange>:

void
freerange(void *vstart, void *vend)
{
80102c2a:	55                   	push   %ebp
80102c2b:	89 e5                	mov    %esp,%ebp
80102c2d:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102c30:	8b 45 08             	mov    0x8(%ebp),%eax
80102c33:	05 ff 0f 00 00       	add    $0xfff,%eax
80102c38:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102c3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c40:	eb 15                	jmp    80102c57 <freerange+0x2d>
    kfree(p);
80102c42:	83 ec 0c             	sub    $0xc,%esp
80102c45:	ff 75 f4             	pushl  -0xc(%ebp)
80102c48:	e8 1a 00 00 00       	call   80102c67 <kfree>
80102c4d:	83 c4 10             	add    $0x10,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c50:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c5a:	05 00 10 00 00       	add    $0x1000,%eax
80102c5f:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102c62:	76 de                	jbe    80102c42 <freerange+0x18>
    kfree(p);
}
80102c64:	90                   	nop
80102c65:	c9                   	leave  
80102c66:	c3                   	ret    

80102c67 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102c67:	55                   	push   %ebp
80102c68:	89 e5                	mov    %esp,%ebp
80102c6a:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102c6d:	8b 45 08             	mov    0x8(%ebp),%eax
80102c70:	25 ff 0f 00 00       	and    $0xfff,%eax
80102c75:	85 c0                	test   %eax,%eax
80102c77:	75 1b                	jne    80102c94 <kfree+0x2d>
80102c79:	81 7d 08 5c 79 11 80 	cmpl   $0x8011795c,0x8(%ebp)
80102c80:	72 12                	jb     80102c94 <kfree+0x2d>
80102c82:	ff 75 08             	pushl  0x8(%ebp)
80102c85:	e8 36 ff ff ff       	call   80102bc0 <v2p>
80102c8a:	83 c4 04             	add    $0x4,%esp
80102c8d:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102c92:	76 0d                	jbe    80102ca1 <kfree+0x3a>
    panic("kfree");
80102c94:	83 ec 0c             	sub    $0xc,%esp
80102c97:	68 87 9a 10 80       	push   $0x80109a87
80102c9c:	e8 c5 d8 ff ff       	call   80100566 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102ca1:	83 ec 04             	sub    $0x4,%esp
80102ca4:	68 00 10 00 00       	push   $0x1000
80102ca9:	6a 01                	push   $0x1
80102cab:	ff 75 08             	pushl  0x8(%ebp)
80102cae:	e8 1b 37 00 00       	call   801063ce <memset>
80102cb3:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102cb6:	a1 74 42 11 80       	mov    0x80114274,%eax
80102cbb:	85 c0                	test   %eax,%eax
80102cbd:	74 10                	je     80102ccf <kfree+0x68>
    acquire(&kmem.lock);
80102cbf:	83 ec 0c             	sub    $0xc,%esp
80102cc2:	68 40 42 11 80       	push   $0x80114240
80102cc7:	e8 9f 34 00 00       	call   8010616b <acquire>
80102ccc:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102ccf:	8b 45 08             	mov    0x8(%ebp),%eax
80102cd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102cd5:	8b 15 78 42 11 80    	mov    0x80114278,%edx
80102cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cde:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ce3:	a3 78 42 11 80       	mov    %eax,0x80114278
  if(kmem.use_lock)
80102ce8:	a1 74 42 11 80       	mov    0x80114274,%eax
80102ced:	85 c0                	test   %eax,%eax
80102cef:	74 10                	je     80102d01 <kfree+0x9a>
    release(&kmem.lock);
80102cf1:	83 ec 0c             	sub    $0xc,%esp
80102cf4:	68 40 42 11 80       	push   $0x80114240
80102cf9:	e8 d4 34 00 00       	call   801061d2 <release>
80102cfe:	83 c4 10             	add    $0x10,%esp
}
80102d01:	90                   	nop
80102d02:	c9                   	leave  
80102d03:	c3                   	ret    

80102d04 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102d04:	55                   	push   %ebp
80102d05:	89 e5                	mov    %esp,%ebp
80102d07:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102d0a:	a1 74 42 11 80       	mov    0x80114274,%eax
80102d0f:	85 c0                	test   %eax,%eax
80102d11:	74 10                	je     80102d23 <kalloc+0x1f>
    acquire(&kmem.lock);
80102d13:	83 ec 0c             	sub    $0xc,%esp
80102d16:	68 40 42 11 80       	push   $0x80114240
80102d1b:	e8 4b 34 00 00       	call   8010616b <acquire>
80102d20:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102d23:	a1 78 42 11 80       	mov    0x80114278,%eax
80102d28:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102d2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102d2f:	74 0a                	je     80102d3b <kalloc+0x37>
    kmem.freelist = r->next;
80102d31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d34:	8b 00                	mov    (%eax),%eax
80102d36:	a3 78 42 11 80       	mov    %eax,0x80114278
  if(kmem.use_lock)
80102d3b:	a1 74 42 11 80       	mov    0x80114274,%eax
80102d40:	85 c0                	test   %eax,%eax
80102d42:	74 10                	je     80102d54 <kalloc+0x50>
    release(&kmem.lock);
80102d44:	83 ec 0c             	sub    $0xc,%esp
80102d47:	68 40 42 11 80       	push   $0x80114240
80102d4c:	e8 81 34 00 00       	call   801061d2 <release>
80102d51:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102d57:	c9                   	leave  
80102d58:	c3                   	ret    

80102d59 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80102d59:	55                   	push   %ebp
80102d5a:	89 e5                	mov    %esp,%ebp
80102d5c:	83 ec 14             	sub    $0x14,%esp
80102d5f:	8b 45 08             	mov    0x8(%ebp),%eax
80102d62:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d66:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102d6a:	89 c2                	mov    %eax,%edx
80102d6c:	ec                   	in     (%dx),%al
80102d6d:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102d70:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102d74:	c9                   	leave  
80102d75:	c3                   	ret    

80102d76 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102d76:	55                   	push   %ebp
80102d77:	89 e5                	mov    %esp,%ebp
80102d79:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102d7c:	6a 64                	push   $0x64
80102d7e:	e8 d6 ff ff ff       	call   80102d59 <inb>
80102d83:	83 c4 04             	add    $0x4,%esp
80102d86:	0f b6 c0             	movzbl %al,%eax
80102d89:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d8f:	83 e0 01             	and    $0x1,%eax
80102d92:	85 c0                	test   %eax,%eax
80102d94:	75 0a                	jne    80102da0 <kbdgetc+0x2a>
    return -1;
80102d96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102d9b:	e9 23 01 00 00       	jmp    80102ec3 <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102da0:	6a 60                	push   $0x60
80102da2:	e8 b2 ff ff ff       	call   80102d59 <inb>
80102da7:	83 c4 04             	add    $0x4,%esp
80102daa:	0f b6 c0             	movzbl %al,%eax
80102dad:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102db0:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102db7:	75 17                	jne    80102dd0 <kbdgetc+0x5a>
    shift |= E0ESC;
80102db9:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102dbe:	83 c8 40             	or     $0x40,%eax
80102dc1:	a3 5c d6 10 80       	mov    %eax,0x8010d65c
    return 0;
80102dc6:	b8 00 00 00 00       	mov    $0x0,%eax
80102dcb:	e9 f3 00 00 00       	jmp    80102ec3 <kbdgetc+0x14d>
  } else if(data & 0x80){
80102dd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102dd3:	25 80 00 00 00       	and    $0x80,%eax
80102dd8:	85 c0                	test   %eax,%eax
80102dda:	74 45                	je     80102e21 <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102ddc:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102de1:	83 e0 40             	and    $0x40,%eax
80102de4:	85 c0                	test   %eax,%eax
80102de6:	75 08                	jne    80102df0 <kbdgetc+0x7a>
80102de8:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102deb:	83 e0 7f             	and    $0x7f,%eax
80102dee:	eb 03                	jmp    80102df3 <kbdgetc+0x7d>
80102df0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102df3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102df6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102df9:	05 20 b0 10 80       	add    $0x8010b020,%eax
80102dfe:	0f b6 00             	movzbl (%eax),%eax
80102e01:	83 c8 40             	or     $0x40,%eax
80102e04:	0f b6 c0             	movzbl %al,%eax
80102e07:	f7 d0                	not    %eax
80102e09:	89 c2                	mov    %eax,%edx
80102e0b:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102e10:	21 d0                	and    %edx,%eax
80102e12:	a3 5c d6 10 80       	mov    %eax,0x8010d65c
    return 0;
80102e17:	b8 00 00 00 00       	mov    $0x0,%eax
80102e1c:	e9 a2 00 00 00       	jmp    80102ec3 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102e21:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102e26:	83 e0 40             	and    $0x40,%eax
80102e29:	85 c0                	test   %eax,%eax
80102e2b:	74 14                	je     80102e41 <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102e2d:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102e34:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102e39:	83 e0 bf             	and    $0xffffffbf,%eax
80102e3c:	a3 5c d6 10 80       	mov    %eax,0x8010d65c
  }

  shift |= shiftcode[data];
80102e41:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e44:	05 20 b0 10 80       	add    $0x8010b020,%eax
80102e49:	0f b6 00             	movzbl (%eax),%eax
80102e4c:	0f b6 d0             	movzbl %al,%edx
80102e4f:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102e54:	09 d0                	or     %edx,%eax
80102e56:	a3 5c d6 10 80       	mov    %eax,0x8010d65c
  shift ^= togglecode[data];
80102e5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e5e:	05 20 b1 10 80       	add    $0x8010b120,%eax
80102e63:	0f b6 00             	movzbl (%eax),%eax
80102e66:	0f b6 d0             	movzbl %al,%edx
80102e69:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102e6e:	31 d0                	xor    %edx,%eax
80102e70:	a3 5c d6 10 80       	mov    %eax,0x8010d65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102e75:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102e7a:	83 e0 03             	and    $0x3,%eax
80102e7d:	8b 14 85 20 b5 10 80 	mov    -0x7fef4ae0(,%eax,4),%edx
80102e84:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e87:	01 d0                	add    %edx,%eax
80102e89:	0f b6 00             	movzbl (%eax),%eax
80102e8c:	0f b6 c0             	movzbl %al,%eax
80102e8f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102e92:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102e97:	83 e0 08             	and    $0x8,%eax
80102e9a:	85 c0                	test   %eax,%eax
80102e9c:	74 22                	je     80102ec0 <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102e9e:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102ea2:	76 0c                	jbe    80102eb0 <kbdgetc+0x13a>
80102ea4:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102ea8:	77 06                	ja     80102eb0 <kbdgetc+0x13a>
      c += 'A' - 'a';
80102eaa:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102eae:	eb 10                	jmp    80102ec0 <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102eb0:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102eb4:	76 0a                	jbe    80102ec0 <kbdgetc+0x14a>
80102eb6:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102eba:	77 04                	ja     80102ec0 <kbdgetc+0x14a>
      c += 'a' - 'A';
80102ebc:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102ec0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102ec3:	c9                   	leave  
80102ec4:	c3                   	ret    

80102ec5 <kbdintr>:

void
kbdintr(void)
{
80102ec5:	55                   	push   %ebp
80102ec6:	89 e5                	mov    %esp,%ebp
80102ec8:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102ecb:	83 ec 0c             	sub    $0xc,%esp
80102ece:	68 76 2d 10 80       	push   $0x80102d76
80102ed3:	e8 21 d9 ff ff       	call   801007f9 <consoleintr>
80102ed8:	83 c4 10             	add    $0x10,%esp
}
80102edb:	90                   	nop
80102edc:	c9                   	leave  
80102edd:	c3                   	ret    

80102ede <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80102ede:	55                   	push   %ebp
80102edf:	89 e5                	mov    %esp,%ebp
80102ee1:	83 ec 14             	sub    $0x14,%esp
80102ee4:	8b 45 08             	mov    0x8(%ebp),%eax
80102ee7:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102eeb:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102eef:	89 c2                	mov    %eax,%edx
80102ef1:	ec                   	in     (%dx),%al
80102ef2:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102ef5:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102ef9:	c9                   	leave  
80102efa:	c3                   	ret    

80102efb <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102efb:	55                   	push   %ebp
80102efc:	89 e5                	mov    %esp,%ebp
80102efe:	83 ec 08             	sub    $0x8,%esp
80102f01:	8b 55 08             	mov    0x8(%ebp),%edx
80102f04:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f07:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102f0b:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f0e:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102f12:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102f16:	ee                   	out    %al,(%dx)
}
80102f17:	90                   	nop
80102f18:	c9                   	leave  
80102f19:	c3                   	ret    

80102f1a <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102f1a:	55                   	push   %ebp
80102f1b:	89 e5                	mov    %esp,%ebp
80102f1d:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102f20:	9c                   	pushf  
80102f21:	58                   	pop    %eax
80102f22:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102f25:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102f28:	c9                   	leave  
80102f29:	c3                   	ret    

80102f2a <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102f2a:	55                   	push   %ebp
80102f2b:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102f2d:	a1 7c 42 11 80       	mov    0x8011427c,%eax
80102f32:	8b 55 08             	mov    0x8(%ebp),%edx
80102f35:	c1 e2 02             	shl    $0x2,%edx
80102f38:	01 c2                	add    %eax,%edx
80102f3a:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f3d:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102f3f:	a1 7c 42 11 80       	mov    0x8011427c,%eax
80102f44:	83 c0 20             	add    $0x20,%eax
80102f47:	8b 00                	mov    (%eax),%eax
}
80102f49:	90                   	nop
80102f4a:	5d                   	pop    %ebp
80102f4b:	c3                   	ret    

80102f4c <lapicinit>:

void
lapicinit(void)
{
80102f4c:	55                   	push   %ebp
80102f4d:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
80102f4f:	a1 7c 42 11 80       	mov    0x8011427c,%eax
80102f54:	85 c0                	test   %eax,%eax
80102f56:	0f 84 0b 01 00 00    	je     80103067 <lapicinit+0x11b>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102f5c:	68 3f 01 00 00       	push   $0x13f
80102f61:	6a 3c                	push   $0x3c
80102f63:	e8 c2 ff ff ff       	call   80102f2a <lapicw>
80102f68:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102f6b:	6a 0b                	push   $0xb
80102f6d:	68 f8 00 00 00       	push   $0xf8
80102f72:	e8 b3 ff ff ff       	call   80102f2a <lapicw>
80102f77:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102f7a:	68 20 00 02 00       	push   $0x20020
80102f7f:	68 c8 00 00 00       	push   $0xc8
80102f84:	e8 a1 ff ff ff       	call   80102f2a <lapicw>
80102f89:	83 c4 08             	add    $0x8,%esp
  // lapicw(TICR, 10000000); 
  lapicw(TICR, 1000000000/TPS); // PSU CS333. Makes ticks per second programmable
80102f8c:	68 40 42 0f 00       	push   $0xf4240
80102f91:	68 e0 00 00 00       	push   $0xe0
80102f96:	e8 8f ff ff ff       	call   80102f2a <lapicw>
80102f9b:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102f9e:	68 00 00 01 00       	push   $0x10000
80102fa3:	68 d4 00 00 00       	push   $0xd4
80102fa8:	e8 7d ff ff ff       	call   80102f2a <lapicw>
80102fad:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80102fb0:	68 00 00 01 00       	push   $0x10000
80102fb5:	68 d8 00 00 00       	push   $0xd8
80102fba:	e8 6b ff ff ff       	call   80102f2a <lapicw>
80102fbf:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102fc2:	a1 7c 42 11 80       	mov    0x8011427c,%eax
80102fc7:	83 c0 30             	add    $0x30,%eax
80102fca:	8b 00                	mov    (%eax),%eax
80102fcc:	c1 e8 10             	shr    $0x10,%eax
80102fcf:	0f b6 c0             	movzbl %al,%eax
80102fd2:	83 f8 03             	cmp    $0x3,%eax
80102fd5:	76 12                	jbe    80102fe9 <lapicinit+0x9d>
    lapicw(PCINT, MASKED);
80102fd7:	68 00 00 01 00       	push   $0x10000
80102fdc:	68 d0 00 00 00       	push   $0xd0
80102fe1:	e8 44 ff ff ff       	call   80102f2a <lapicw>
80102fe6:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102fe9:	6a 33                	push   $0x33
80102feb:	68 dc 00 00 00       	push   $0xdc
80102ff0:	e8 35 ff ff ff       	call   80102f2a <lapicw>
80102ff5:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102ff8:	6a 00                	push   $0x0
80102ffa:	68 a0 00 00 00       	push   $0xa0
80102fff:	e8 26 ff ff ff       	call   80102f2a <lapicw>
80103004:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80103007:	6a 00                	push   $0x0
80103009:	68 a0 00 00 00       	push   $0xa0
8010300e:	e8 17 ff ff ff       	call   80102f2a <lapicw>
80103013:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80103016:	6a 00                	push   $0x0
80103018:	6a 2c                	push   $0x2c
8010301a:	e8 0b ff ff ff       	call   80102f2a <lapicw>
8010301f:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80103022:	6a 00                	push   $0x0
80103024:	68 c4 00 00 00       	push   $0xc4
80103029:	e8 fc fe ff ff       	call   80102f2a <lapicw>
8010302e:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80103031:	68 00 85 08 00       	push   $0x88500
80103036:	68 c0 00 00 00       	push   $0xc0
8010303b:	e8 ea fe ff ff       	call   80102f2a <lapicw>
80103040:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80103043:	90                   	nop
80103044:	a1 7c 42 11 80       	mov    0x8011427c,%eax
80103049:	05 00 03 00 00       	add    $0x300,%eax
8010304e:	8b 00                	mov    (%eax),%eax
80103050:	25 00 10 00 00       	and    $0x1000,%eax
80103055:	85 c0                	test   %eax,%eax
80103057:	75 eb                	jne    80103044 <lapicinit+0xf8>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80103059:	6a 00                	push   $0x0
8010305b:	6a 20                	push   $0x20
8010305d:	e8 c8 fe ff ff       	call   80102f2a <lapicw>
80103062:	83 c4 08             	add    $0x8,%esp
80103065:	eb 01                	jmp    80103068 <lapicinit+0x11c>

void
lapicinit(void)
{
  if(!lapic) 
    return;
80103067:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80103068:	c9                   	leave  
80103069:	c3                   	ret    

8010306a <cpunum>:

int
cpunum(void)
{
8010306a:	55                   	push   %ebp
8010306b:	89 e5                	mov    %esp,%ebp
8010306d:	83 ec 08             	sub    $0x8,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80103070:	e8 a5 fe ff ff       	call   80102f1a <readeflags>
80103075:	25 00 02 00 00       	and    $0x200,%eax
8010307a:	85 c0                	test   %eax,%eax
8010307c:	74 26                	je     801030a4 <cpunum+0x3a>
    static int n;
    if(n++ == 0)
8010307e:	a1 60 d6 10 80       	mov    0x8010d660,%eax
80103083:	8d 50 01             	lea    0x1(%eax),%edx
80103086:	89 15 60 d6 10 80    	mov    %edx,0x8010d660
8010308c:	85 c0                	test   %eax,%eax
8010308e:	75 14                	jne    801030a4 <cpunum+0x3a>
      cprintf("cpu called from %x with interrupts enabled\n",
80103090:	8b 45 04             	mov    0x4(%ebp),%eax
80103093:	83 ec 08             	sub    $0x8,%esp
80103096:	50                   	push   %eax
80103097:	68 90 9a 10 80       	push   $0x80109a90
8010309c:	e8 25 d3 ff ff       	call   801003c6 <cprintf>
801030a1:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
801030a4:	a1 7c 42 11 80       	mov    0x8011427c,%eax
801030a9:	85 c0                	test   %eax,%eax
801030ab:	74 0f                	je     801030bc <cpunum+0x52>
    return lapic[ID]>>24;
801030ad:	a1 7c 42 11 80       	mov    0x8011427c,%eax
801030b2:	83 c0 20             	add    $0x20,%eax
801030b5:	8b 00                	mov    (%eax),%eax
801030b7:	c1 e8 18             	shr    $0x18,%eax
801030ba:	eb 05                	jmp    801030c1 <cpunum+0x57>
  return 0;
801030bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
801030c1:	c9                   	leave  
801030c2:	c3                   	ret    

801030c3 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
801030c3:	55                   	push   %ebp
801030c4:	89 e5                	mov    %esp,%ebp
  if(lapic)
801030c6:	a1 7c 42 11 80       	mov    0x8011427c,%eax
801030cb:	85 c0                	test   %eax,%eax
801030cd:	74 0c                	je     801030db <lapiceoi+0x18>
    lapicw(EOI, 0);
801030cf:	6a 00                	push   $0x0
801030d1:	6a 2c                	push   $0x2c
801030d3:	e8 52 fe ff ff       	call   80102f2a <lapicw>
801030d8:	83 c4 08             	add    $0x8,%esp
}
801030db:	90                   	nop
801030dc:	c9                   	leave  
801030dd:	c3                   	ret    

801030de <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801030de:	55                   	push   %ebp
801030df:	89 e5                	mov    %esp,%ebp
}
801030e1:	90                   	nop
801030e2:	5d                   	pop    %ebp
801030e3:	c3                   	ret    

801030e4 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801030e4:	55                   	push   %ebp
801030e5:	89 e5                	mov    %esp,%ebp
801030e7:	83 ec 14             	sub    $0x14,%esp
801030ea:	8b 45 08             	mov    0x8(%ebp),%eax
801030ed:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
801030f0:	6a 0f                	push   $0xf
801030f2:	6a 70                	push   $0x70
801030f4:	e8 02 fe ff ff       	call   80102efb <outb>
801030f9:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
801030fc:	6a 0a                	push   $0xa
801030fe:	6a 71                	push   $0x71
80103100:	e8 f6 fd ff ff       	call   80102efb <outb>
80103105:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80103108:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
8010310f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103112:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80103117:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010311a:	83 c0 02             	add    $0x2,%eax
8010311d:	8b 55 0c             	mov    0xc(%ebp),%edx
80103120:	c1 ea 04             	shr    $0x4,%edx
80103123:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103126:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
8010312a:	c1 e0 18             	shl    $0x18,%eax
8010312d:	50                   	push   %eax
8010312e:	68 c4 00 00 00       	push   $0xc4
80103133:	e8 f2 fd ff ff       	call   80102f2a <lapicw>
80103138:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
8010313b:	68 00 c5 00 00       	push   $0xc500
80103140:	68 c0 00 00 00       	push   $0xc0
80103145:	e8 e0 fd ff ff       	call   80102f2a <lapicw>
8010314a:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
8010314d:	68 c8 00 00 00       	push   $0xc8
80103152:	e8 87 ff ff ff       	call   801030de <microdelay>
80103157:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
8010315a:	68 00 85 00 00       	push   $0x8500
8010315f:	68 c0 00 00 00       	push   $0xc0
80103164:	e8 c1 fd ff ff       	call   80102f2a <lapicw>
80103169:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
8010316c:	6a 64                	push   $0x64
8010316e:	e8 6b ff ff ff       	call   801030de <microdelay>
80103173:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103176:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010317d:	eb 3d                	jmp    801031bc <lapicstartap+0xd8>
    lapicw(ICRHI, apicid<<24);
8010317f:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103183:	c1 e0 18             	shl    $0x18,%eax
80103186:	50                   	push   %eax
80103187:	68 c4 00 00 00       	push   $0xc4
8010318c:	e8 99 fd ff ff       	call   80102f2a <lapicw>
80103191:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
80103194:	8b 45 0c             	mov    0xc(%ebp),%eax
80103197:	c1 e8 0c             	shr    $0xc,%eax
8010319a:	80 cc 06             	or     $0x6,%ah
8010319d:	50                   	push   %eax
8010319e:	68 c0 00 00 00       	push   $0xc0
801031a3:	e8 82 fd ff ff       	call   80102f2a <lapicw>
801031a8:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
801031ab:	68 c8 00 00 00       	push   $0xc8
801031b0:	e8 29 ff ff ff       	call   801030de <microdelay>
801031b5:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801031b8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801031bc:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
801031c0:	7e bd                	jle    8010317f <lapicstartap+0x9b>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801031c2:	90                   	nop
801031c3:	c9                   	leave  
801031c4:	c3                   	ret    

801031c5 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
801031c5:	55                   	push   %ebp
801031c6:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
801031c8:	8b 45 08             	mov    0x8(%ebp),%eax
801031cb:	0f b6 c0             	movzbl %al,%eax
801031ce:	50                   	push   %eax
801031cf:	6a 70                	push   $0x70
801031d1:	e8 25 fd ff ff       	call   80102efb <outb>
801031d6:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
801031d9:	68 c8 00 00 00       	push   $0xc8
801031de:	e8 fb fe ff ff       	call   801030de <microdelay>
801031e3:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
801031e6:	6a 71                	push   $0x71
801031e8:	e8 f1 fc ff ff       	call   80102ede <inb>
801031ed:	83 c4 04             	add    $0x4,%esp
801031f0:	0f b6 c0             	movzbl %al,%eax
}
801031f3:	c9                   	leave  
801031f4:	c3                   	ret    

801031f5 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
801031f5:	55                   	push   %ebp
801031f6:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
801031f8:	6a 00                	push   $0x0
801031fa:	e8 c6 ff ff ff       	call   801031c5 <cmos_read>
801031ff:	83 c4 04             	add    $0x4,%esp
80103202:	89 c2                	mov    %eax,%edx
80103204:	8b 45 08             	mov    0x8(%ebp),%eax
80103207:	89 10                	mov    %edx,(%eax)
  r->minute = cmos_read(MINS);
80103209:	6a 02                	push   $0x2
8010320b:	e8 b5 ff ff ff       	call   801031c5 <cmos_read>
80103210:	83 c4 04             	add    $0x4,%esp
80103213:	89 c2                	mov    %eax,%edx
80103215:	8b 45 08             	mov    0x8(%ebp),%eax
80103218:	89 50 04             	mov    %edx,0x4(%eax)
  r->hour   = cmos_read(HOURS);
8010321b:	6a 04                	push   $0x4
8010321d:	e8 a3 ff ff ff       	call   801031c5 <cmos_read>
80103222:	83 c4 04             	add    $0x4,%esp
80103225:	89 c2                	mov    %eax,%edx
80103227:	8b 45 08             	mov    0x8(%ebp),%eax
8010322a:	89 50 08             	mov    %edx,0x8(%eax)
  r->day    = cmos_read(DAY);
8010322d:	6a 07                	push   $0x7
8010322f:	e8 91 ff ff ff       	call   801031c5 <cmos_read>
80103234:	83 c4 04             	add    $0x4,%esp
80103237:	89 c2                	mov    %eax,%edx
80103239:	8b 45 08             	mov    0x8(%ebp),%eax
8010323c:	89 50 0c             	mov    %edx,0xc(%eax)
  r->month  = cmos_read(MONTH);
8010323f:	6a 08                	push   $0x8
80103241:	e8 7f ff ff ff       	call   801031c5 <cmos_read>
80103246:	83 c4 04             	add    $0x4,%esp
80103249:	89 c2                	mov    %eax,%edx
8010324b:	8b 45 08             	mov    0x8(%ebp),%eax
8010324e:	89 50 10             	mov    %edx,0x10(%eax)
  r->year   = cmos_read(YEAR);
80103251:	6a 09                	push   $0x9
80103253:	e8 6d ff ff ff       	call   801031c5 <cmos_read>
80103258:	83 c4 04             	add    $0x4,%esp
8010325b:	89 c2                	mov    %eax,%edx
8010325d:	8b 45 08             	mov    0x8(%ebp),%eax
80103260:	89 50 14             	mov    %edx,0x14(%eax)
}
80103263:	90                   	nop
80103264:	c9                   	leave  
80103265:	c3                   	ret    

80103266 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80103266:	55                   	push   %ebp
80103267:	89 e5                	mov    %esp,%ebp
80103269:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
8010326c:	6a 0b                	push   $0xb
8010326e:	e8 52 ff ff ff       	call   801031c5 <cmos_read>
80103273:	83 c4 04             	add    $0x4,%esp
80103276:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
80103279:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010327c:	83 e0 04             	and    $0x4,%eax
8010327f:	85 c0                	test   %eax,%eax
80103281:	0f 94 c0             	sete   %al
80103284:	0f b6 c0             	movzbl %al,%eax
80103287:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
8010328a:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010328d:	50                   	push   %eax
8010328e:	e8 62 ff ff ff       	call   801031f5 <fill_rtcdate>
80103293:	83 c4 04             	add    $0x4,%esp
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
80103296:	6a 0a                	push   $0xa
80103298:	e8 28 ff ff ff       	call   801031c5 <cmos_read>
8010329d:	83 c4 04             	add    $0x4,%esp
801032a0:	25 80 00 00 00       	and    $0x80,%eax
801032a5:	85 c0                	test   %eax,%eax
801032a7:	75 27                	jne    801032d0 <cmostime+0x6a>
        continue;
    fill_rtcdate(&t2);
801032a9:	8d 45 c0             	lea    -0x40(%ebp),%eax
801032ac:	50                   	push   %eax
801032ad:	e8 43 ff ff ff       	call   801031f5 <fill_rtcdate>
801032b2:	83 c4 04             	add    $0x4,%esp
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
801032b5:	83 ec 04             	sub    $0x4,%esp
801032b8:	6a 18                	push   $0x18
801032ba:	8d 45 c0             	lea    -0x40(%ebp),%eax
801032bd:	50                   	push   %eax
801032be:	8d 45 d8             	lea    -0x28(%ebp),%eax
801032c1:	50                   	push   %eax
801032c2:	e8 6e 31 00 00       	call   80106435 <memcmp>
801032c7:	83 c4 10             	add    $0x10,%esp
801032ca:	85 c0                	test   %eax,%eax
801032cc:	74 05                	je     801032d3 <cmostime+0x6d>
801032ce:	eb ba                	jmp    8010328a <cmostime+0x24>

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
801032d0:	90                   	nop
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
801032d1:	eb b7                	jmp    8010328a <cmostime+0x24>
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
801032d3:	90                   	nop
  }

  // convert
  if (bcd) {
801032d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801032d8:	0f 84 b4 00 00 00    	je     80103392 <cmostime+0x12c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801032de:	8b 45 d8             	mov    -0x28(%ebp),%eax
801032e1:	c1 e8 04             	shr    $0x4,%eax
801032e4:	89 c2                	mov    %eax,%edx
801032e6:	89 d0                	mov    %edx,%eax
801032e8:	c1 e0 02             	shl    $0x2,%eax
801032eb:	01 d0                	add    %edx,%eax
801032ed:	01 c0                	add    %eax,%eax
801032ef:	89 c2                	mov    %eax,%edx
801032f1:	8b 45 d8             	mov    -0x28(%ebp),%eax
801032f4:	83 e0 0f             	and    $0xf,%eax
801032f7:	01 d0                	add    %edx,%eax
801032f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
801032fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
801032ff:	c1 e8 04             	shr    $0x4,%eax
80103302:	89 c2                	mov    %eax,%edx
80103304:	89 d0                	mov    %edx,%eax
80103306:	c1 e0 02             	shl    $0x2,%eax
80103309:	01 d0                	add    %edx,%eax
8010330b:	01 c0                	add    %eax,%eax
8010330d:	89 c2                	mov    %eax,%edx
8010330f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103312:	83 e0 0f             	and    $0xf,%eax
80103315:	01 d0                	add    %edx,%eax
80103317:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
8010331a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010331d:	c1 e8 04             	shr    $0x4,%eax
80103320:	89 c2                	mov    %eax,%edx
80103322:	89 d0                	mov    %edx,%eax
80103324:	c1 e0 02             	shl    $0x2,%eax
80103327:	01 d0                	add    %edx,%eax
80103329:	01 c0                	add    %eax,%eax
8010332b:	89 c2                	mov    %eax,%edx
8010332d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103330:	83 e0 0f             	and    $0xf,%eax
80103333:	01 d0                	add    %edx,%eax
80103335:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
80103338:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010333b:	c1 e8 04             	shr    $0x4,%eax
8010333e:	89 c2                	mov    %eax,%edx
80103340:	89 d0                	mov    %edx,%eax
80103342:	c1 e0 02             	shl    $0x2,%eax
80103345:	01 d0                	add    %edx,%eax
80103347:	01 c0                	add    %eax,%eax
80103349:	89 c2                	mov    %eax,%edx
8010334b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010334e:	83 e0 0f             	and    $0xf,%eax
80103351:	01 d0                	add    %edx,%eax
80103353:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
80103356:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103359:	c1 e8 04             	shr    $0x4,%eax
8010335c:	89 c2                	mov    %eax,%edx
8010335e:	89 d0                	mov    %edx,%eax
80103360:	c1 e0 02             	shl    $0x2,%eax
80103363:	01 d0                	add    %edx,%eax
80103365:	01 c0                	add    %eax,%eax
80103367:	89 c2                	mov    %eax,%edx
80103369:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010336c:	83 e0 0f             	and    $0xf,%eax
8010336f:	01 d0                	add    %edx,%eax
80103371:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
80103374:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103377:	c1 e8 04             	shr    $0x4,%eax
8010337a:	89 c2                	mov    %eax,%edx
8010337c:	89 d0                	mov    %edx,%eax
8010337e:	c1 e0 02             	shl    $0x2,%eax
80103381:	01 d0                	add    %edx,%eax
80103383:	01 c0                	add    %eax,%eax
80103385:	89 c2                	mov    %eax,%edx
80103387:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010338a:	83 e0 0f             	and    $0xf,%eax
8010338d:	01 d0                	add    %edx,%eax
8010338f:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
80103392:	8b 45 08             	mov    0x8(%ebp),%eax
80103395:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103398:	89 10                	mov    %edx,(%eax)
8010339a:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010339d:	89 50 04             	mov    %edx,0x4(%eax)
801033a0:	8b 55 e0             	mov    -0x20(%ebp),%edx
801033a3:	89 50 08             	mov    %edx,0x8(%eax)
801033a6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801033a9:	89 50 0c             	mov    %edx,0xc(%eax)
801033ac:	8b 55 e8             	mov    -0x18(%ebp),%edx
801033af:	89 50 10             	mov    %edx,0x10(%eax)
801033b2:	8b 55 ec             	mov    -0x14(%ebp),%edx
801033b5:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
801033b8:	8b 45 08             	mov    0x8(%ebp),%eax
801033bb:	8b 40 14             	mov    0x14(%eax),%eax
801033be:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
801033c4:	8b 45 08             	mov    0x8(%ebp),%eax
801033c7:	89 50 14             	mov    %edx,0x14(%eax)
}
801033ca:	90                   	nop
801033cb:	c9                   	leave  
801033cc:	c3                   	ret    

801033cd <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
801033cd:	55                   	push   %ebp
801033ce:	89 e5                	mov    %esp,%ebp
801033d0:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
801033d3:	83 ec 08             	sub    $0x8,%esp
801033d6:	68 bc 9a 10 80       	push   $0x80109abc
801033db:	68 80 42 11 80       	push   $0x80114280
801033e0:	e8 64 2d 00 00       	call   80106149 <initlock>
801033e5:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
801033e8:	83 ec 08             	sub    $0x8,%esp
801033eb:	8d 45 dc             	lea    -0x24(%ebp),%eax
801033ee:	50                   	push   %eax
801033ef:	ff 75 08             	pushl  0x8(%ebp)
801033f2:	e8 2b e0 ff ff       	call   80101422 <readsb>
801033f7:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
801033fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033fd:	a3 b4 42 11 80       	mov    %eax,0x801142b4
  log.size = sb.nlog;
80103402:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103405:	a3 b8 42 11 80       	mov    %eax,0x801142b8
  log.dev = dev;
8010340a:	8b 45 08             	mov    0x8(%ebp),%eax
8010340d:	a3 c4 42 11 80       	mov    %eax,0x801142c4
  recover_from_log();
80103412:	e8 b2 01 00 00       	call   801035c9 <recover_from_log>
}
80103417:	90                   	nop
80103418:	c9                   	leave  
80103419:	c3                   	ret    

8010341a <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
8010341a:	55                   	push   %ebp
8010341b:	89 e5                	mov    %esp,%ebp
8010341d:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103420:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103427:	e9 95 00 00 00       	jmp    801034c1 <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
8010342c:	8b 15 b4 42 11 80    	mov    0x801142b4,%edx
80103432:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103435:	01 d0                	add    %edx,%eax
80103437:	83 c0 01             	add    $0x1,%eax
8010343a:	89 c2                	mov    %eax,%edx
8010343c:	a1 c4 42 11 80       	mov    0x801142c4,%eax
80103441:	83 ec 08             	sub    $0x8,%esp
80103444:	52                   	push   %edx
80103445:	50                   	push   %eax
80103446:	e8 6b cd ff ff       	call   801001b6 <bread>
8010344b:	83 c4 10             	add    $0x10,%esp
8010344e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103451:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103454:	83 c0 10             	add    $0x10,%eax
80103457:	8b 04 85 8c 42 11 80 	mov    -0x7feebd74(,%eax,4),%eax
8010345e:	89 c2                	mov    %eax,%edx
80103460:	a1 c4 42 11 80       	mov    0x801142c4,%eax
80103465:	83 ec 08             	sub    $0x8,%esp
80103468:	52                   	push   %edx
80103469:	50                   	push   %eax
8010346a:	e8 47 cd ff ff       	call   801001b6 <bread>
8010346f:	83 c4 10             	add    $0x10,%esp
80103472:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103475:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103478:	8d 50 18             	lea    0x18(%eax),%edx
8010347b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010347e:	83 c0 18             	add    $0x18,%eax
80103481:	83 ec 04             	sub    $0x4,%esp
80103484:	68 00 02 00 00       	push   $0x200
80103489:	52                   	push   %edx
8010348a:	50                   	push   %eax
8010348b:	e8 fd 2f 00 00       	call   8010648d <memmove>
80103490:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
80103493:	83 ec 0c             	sub    $0xc,%esp
80103496:	ff 75 ec             	pushl  -0x14(%ebp)
80103499:	e8 51 cd ff ff       	call   801001ef <bwrite>
8010349e:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf); 
801034a1:	83 ec 0c             	sub    $0xc,%esp
801034a4:	ff 75 f0             	pushl  -0x10(%ebp)
801034a7:	e8 82 cd ff ff       	call   8010022e <brelse>
801034ac:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
801034af:	83 ec 0c             	sub    $0xc,%esp
801034b2:	ff 75 ec             	pushl  -0x14(%ebp)
801034b5:	e8 74 cd ff ff       	call   8010022e <brelse>
801034ba:	83 c4 10             	add    $0x10,%esp
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801034bd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801034c1:	a1 c8 42 11 80       	mov    0x801142c8,%eax
801034c6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801034c9:	0f 8f 5d ff ff ff    	jg     8010342c <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
801034cf:	90                   	nop
801034d0:	c9                   	leave  
801034d1:	c3                   	ret    

801034d2 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
801034d2:	55                   	push   %ebp
801034d3:	89 e5                	mov    %esp,%ebp
801034d5:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
801034d8:	a1 b4 42 11 80       	mov    0x801142b4,%eax
801034dd:	89 c2                	mov    %eax,%edx
801034df:	a1 c4 42 11 80       	mov    0x801142c4,%eax
801034e4:	83 ec 08             	sub    $0x8,%esp
801034e7:	52                   	push   %edx
801034e8:	50                   	push   %eax
801034e9:	e8 c8 cc ff ff       	call   801001b6 <bread>
801034ee:	83 c4 10             	add    $0x10,%esp
801034f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
801034f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034f7:	83 c0 18             	add    $0x18,%eax
801034fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
801034fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103500:	8b 00                	mov    (%eax),%eax
80103502:	a3 c8 42 11 80       	mov    %eax,0x801142c8
  for (i = 0; i < log.lh.n; i++) {
80103507:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010350e:	eb 1b                	jmp    8010352b <read_head+0x59>
    log.lh.block[i] = lh->block[i];
80103510:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103513:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103516:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
8010351a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010351d:	83 c2 10             	add    $0x10,%edx
80103520:	89 04 95 8c 42 11 80 	mov    %eax,-0x7feebd74(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80103527:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010352b:	a1 c8 42 11 80       	mov    0x801142c8,%eax
80103530:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103533:	7f db                	jg     80103510 <read_head+0x3e>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80103535:	83 ec 0c             	sub    $0xc,%esp
80103538:	ff 75 f0             	pushl  -0x10(%ebp)
8010353b:	e8 ee cc ff ff       	call   8010022e <brelse>
80103540:	83 c4 10             	add    $0x10,%esp
}
80103543:	90                   	nop
80103544:	c9                   	leave  
80103545:	c3                   	ret    

80103546 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103546:	55                   	push   %ebp
80103547:	89 e5                	mov    %esp,%ebp
80103549:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
8010354c:	a1 b4 42 11 80       	mov    0x801142b4,%eax
80103551:	89 c2                	mov    %eax,%edx
80103553:	a1 c4 42 11 80       	mov    0x801142c4,%eax
80103558:	83 ec 08             	sub    $0x8,%esp
8010355b:	52                   	push   %edx
8010355c:	50                   	push   %eax
8010355d:	e8 54 cc ff ff       	call   801001b6 <bread>
80103562:	83 c4 10             	add    $0x10,%esp
80103565:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
80103568:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010356b:	83 c0 18             	add    $0x18,%eax
8010356e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
80103571:	8b 15 c8 42 11 80    	mov    0x801142c8,%edx
80103577:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010357a:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
8010357c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103583:	eb 1b                	jmp    801035a0 <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
80103585:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103588:	83 c0 10             	add    $0x10,%eax
8010358b:	8b 0c 85 8c 42 11 80 	mov    -0x7feebd74(,%eax,4),%ecx
80103592:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103595:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103598:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
8010359c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801035a0:	a1 c8 42 11 80       	mov    0x801142c8,%eax
801035a5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801035a8:	7f db                	jg     80103585 <write_head+0x3f>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
801035aa:	83 ec 0c             	sub    $0xc,%esp
801035ad:	ff 75 f0             	pushl  -0x10(%ebp)
801035b0:	e8 3a cc ff ff       	call   801001ef <bwrite>
801035b5:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
801035b8:	83 ec 0c             	sub    $0xc,%esp
801035bb:	ff 75 f0             	pushl  -0x10(%ebp)
801035be:	e8 6b cc ff ff       	call   8010022e <brelse>
801035c3:	83 c4 10             	add    $0x10,%esp
}
801035c6:	90                   	nop
801035c7:	c9                   	leave  
801035c8:	c3                   	ret    

801035c9 <recover_from_log>:

static void
recover_from_log(void)
{
801035c9:	55                   	push   %ebp
801035ca:	89 e5                	mov    %esp,%ebp
801035cc:	83 ec 08             	sub    $0x8,%esp
  read_head();      
801035cf:	e8 fe fe ff ff       	call   801034d2 <read_head>
  install_trans(); // if committed, copy from log to disk
801035d4:	e8 41 fe ff ff       	call   8010341a <install_trans>
  log.lh.n = 0;
801035d9:	c7 05 c8 42 11 80 00 	movl   $0x0,0x801142c8
801035e0:	00 00 00 
  write_head(); // clear the log
801035e3:	e8 5e ff ff ff       	call   80103546 <write_head>
}
801035e8:	90                   	nop
801035e9:	c9                   	leave  
801035ea:	c3                   	ret    

801035eb <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
801035eb:	55                   	push   %ebp
801035ec:	89 e5                	mov    %esp,%ebp
801035ee:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
801035f1:	83 ec 0c             	sub    $0xc,%esp
801035f4:	68 80 42 11 80       	push   $0x80114280
801035f9:	e8 6d 2b 00 00       	call   8010616b <acquire>
801035fe:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
80103601:	a1 c0 42 11 80       	mov    0x801142c0,%eax
80103606:	85 c0                	test   %eax,%eax
80103608:	74 17                	je     80103621 <begin_op+0x36>
      sleep(&log, &log.lock);
8010360a:	83 ec 08             	sub    $0x8,%esp
8010360d:	68 80 42 11 80       	push   $0x80114280
80103612:	68 80 42 11 80       	push   $0x80114280
80103617:	e8 e6 1b 00 00       	call   80105202 <sleep>
8010361c:	83 c4 10             	add    $0x10,%esp
8010361f:	eb e0                	jmp    80103601 <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103621:	8b 0d c8 42 11 80    	mov    0x801142c8,%ecx
80103627:	a1 bc 42 11 80       	mov    0x801142bc,%eax
8010362c:	8d 50 01             	lea    0x1(%eax),%edx
8010362f:	89 d0                	mov    %edx,%eax
80103631:	c1 e0 02             	shl    $0x2,%eax
80103634:	01 d0                	add    %edx,%eax
80103636:	01 c0                	add    %eax,%eax
80103638:	01 c8                	add    %ecx,%eax
8010363a:	83 f8 1e             	cmp    $0x1e,%eax
8010363d:	7e 17                	jle    80103656 <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
8010363f:	83 ec 08             	sub    $0x8,%esp
80103642:	68 80 42 11 80       	push   $0x80114280
80103647:	68 80 42 11 80       	push   $0x80114280
8010364c:	e8 b1 1b 00 00       	call   80105202 <sleep>
80103651:	83 c4 10             	add    $0x10,%esp
80103654:	eb ab                	jmp    80103601 <begin_op+0x16>
    } else {
      log.outstanding += 1;
80103656:	a1 bc 42 11 80       	mov    0x801142bc,%eax
8010365b:	83 c0 01             	add    $0x1,%eax
8010365e:	a3 bc 42 11 80       	mov    %eax,0x801142bc
      release(&log.lock);
80103663:	83 ec 0c             	sub    $0xc,%esp
80103666:	68 80 42 11 80       	push   $0x80114280
8010366b:	e8 62 2b 00 00       	call   801061d2 <release>
80103670:	83 c4 10             	add    $0x10,%esp
      break;
80103673:	90                   	nop
    }
  }
}
80103674:	90                   	nop
80103675:	c9                   	leave  
80103676:	c3                   	ret    

80103677 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103677:	55                   	push   %ebp
80103678:	89 e5                	mov    %esp,%ebp
8010367a:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
8010367d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
80103684:	83 ec 0c             	sub    $0xc,%esp
80103687:	68 80 42 11 80       	push   $0x80114280
8010368c:	e8 da 2a 00 00       	call   8010616b <acquire>
80103691:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103694:	a1 bc 42 11 80       	mov    0x801142bc,%eax
80103699:	83 e8 01             	sub    $0x1,%eax
8010369c:	a3 bc 42 11 80       	mov    %eax,0x801142bc
  if(log.committing)
801036a1:	a1 c0 42 11 80       	mov    0x801142c0,%eax
801036a6:	85 c0                	test   %eax,%eax
801036a8:	74 0d                	je     801036b7 <end_op+0x40>
    panic("log.committing");
801036aa:	83 ec 0c             	sub    $0xc,%esp
801036ad:	68 c0 9a 10 80       	push   $0x80109ac0
801036b2:	e8 af ce ff ff       	call   80100566 <panic>
  if(log.outstanding == 0){
801036b7:	a1 bc 42 11 80       	mov    0x801142bc,%eax
801036bc:	85 c0                	test   %eax,%eax
801036be:	75 13                	jne    801036d3 <end_op+0x5c>
    do_commit = 1;
801036c0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
801036c7:	c7 05 c0 42 11 80 01 	movl   $0x1,0x801142c0
801036ce:	00 00 00 
801036d1:	eb 10                	jmp    801036e3 <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
801036d3:	83 ec 0c             	sub    $0xc,%esp
801036d6:	68 80 42 11 80       	push   $0x80114280
801036db:	e8 c3 1c 00 00       	call   801053a3 <wakeup>
801036e0:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
801036e3:	83 ec 0c             	sub    $0xc,%esp
801036e6:	68 80 42 11 80       	push   $0x80114280
801036eb:	e8 e2 2a 00 00       	call   801061d2 <release>
801036f0:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
801036f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801036f7:	74 3f                	je     80103738 <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
801036f9:	e8 f5 00 00 00       	call   801037f3 <commit>
    acquire(&log.lock);
801036fe:	83 ec 0c             	sub    $0xc,%esp
80103701:	68 80 42 11 80       	push   $0x80114280
80103706:	e8 60 2a 00 00       	call   8010616b <acquire>
8010370b:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
8010370e:	c7 05 c0 42 11 80 00 	movl   $0x0,0x801142c0
80103715:	00 00 00 
    wakeup(&log);
80103718:	83 ec 0c             	sub    $0xc,%esp
8010371b:	68 80 42 11 80       	push   $0x80114280
80103720:	e8 7e 1c 00 00       	call   801053a3 <wakeup>
80103725:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
80103728:	83 ec 0c             	sub    $0xc,%esp
8010372b:	68 80 42 11 80       	push   $0x80114280
80103730:	e8 9d 2a 00 00       	call   801061d2 <release>
80103735:	83 c4 10             	add    $0x10,%esp
  }
}
80103738:	90                   	nop
80103739:	c9                   	leave  
8010373a:	c3                   	ret    

8010373b <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
8010373b:	55                   	push   %ebp
8010373c:	89 e5                	mov    %esp,%ebp
8010373e:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103741:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103748:	e9 95 00 00 00       	jmp    801037e2 <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
8010374d:	8b 15 b4 42 11 80    	mov    0x801142b4,%edx
80103753:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103756:	01 d0                	add    %edx,%eax
80103758:	83 c0 01             	add    $0x1,%eax
8010375b:	89 c2                	mov    %eax,%edx
8010375d:	a1 c4 42 11 80       	mov    0x801142c4,%eax
80103762:	83 ec 08             	sub    $0x8,%esp
80103765:	52                   	push   %edx
80103766:	50                   	push   %eax
80103767:	e8 4a ca ff ff       	call   801001b6 <bread>
8010376c:	83 c4 10             	add    $0x10,%esp
8010376f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103772:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103775:	83 c0 10             	add    $0x10,%eax
80103778:	8b 04 85 8c 42 11 80 	mov    -0x7feebd74(,%eax,4),%eax
8010377f:	89 c2                	mov    %eax,%edx
80103781:	a1 c4 42 11 80       	mov    0x801142c4,%eax
80103786:	83 ec 08             	sub    $0x8,%esp
80103789:	52                   	push   %edx
8010378a:	50                   	push   %eax
8010378b:	e8 26 ca ff ff       	call   801001b6 <bread>
80103790:	83 c4 10             	add    $0x10,%esp
80103793:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
80103796:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103799:	8d 50 18             	lea    0x18(%eax),%edx
8010379c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010379f:	83 c0 18             	add    $0x18,%eax
801037a2:	83 ec 04             	sub    $0x4,%esp
801037a5:	68 00 02 00 00       	push   $0x200
801037aa:	52                   	push   %edx
801037ab:	50                   	push   %eax
801037ac:	e8 dc 2c 00 00       	call   8010648d <memmove>
801037b1:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
801037b4:	83 ec 0c             	sub    $0xc,%esp
801037b7:	ff 75 f0             	pushl  -0x10(%ebp)
801037ba:	e8 30 ca ff ff       	call   801001ef <bwrite>
801037bf:	83 c4 10             	add    $0x10,%esp
    brelse(from); 
801037c2:	83 ec 0c             	sub    $0xc,%esp
801037c5:	ff 75 ec             	pushl  -0x14(%ebp)
801037c8:	e8 61 ca ff ff       	call   8010022e <brelse>
801037cd:	83 c4 10             	add    $0x10,%esp
    brelse(to);
801037d0:	83 ec 0c             	sub    $0xc,%esp
801037d3:	ff 75 f0             	pushl  -0x10(%ebp)
801037d6:	e8 53 ca ff ff       	call   8010022e <brelse>
801037db:	83 c4 10             	add    $0x10,%esp
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801037de:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801037e2:	a1 c8 42 11 80       	mov    0x801142c8,%eax
801037e7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801037ea:	0f 8f 5d ff ff ff    	jg     8010374d <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
801037f0:	90                   	nop
801037f1:	c9                   	leave  
801037f2:	c3                   	ret    

801037f3 <commit>:

static void
commit()
{
801037f3:	55                   	push   %ebp
801037f4:	89 e5                	mov    %esp,%ebp
801037f6:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
801037f9:	a1 c8 42 11 80       	mov    0x801142c8,%eax
801037fe:	85 c0                	test   %eax,%eax
80103800:	7e 1e                	jle    80103820 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
80103802:	e8 34 ff ff ff       	call   8010373b <write_log>
    write_head();    // Write header to disk -- the real commit
80103807:	e8 3a fd ff ff       	call   80103546 <write_head>
    install_trans(); // Now install writes to home locations
8010380c:	e8 09 fc ff ff       	call   8010341a <install_trans>
    log.lh.n = 0; 
80103811:	c7 05 c8 42 11 80 00 	movl   $0x0,0x801142c8
80103818:	00 00 00 
    write_head();    // Erase the transaction from the log
8010381b:	e8 26 fd ff ff       	call   80103546 <write_head>
  }
}
80103820:	90                   	nop
80103821:	c9                   	leave  
80103822:	c3                   	ret    

80103823 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103823:	55                   	push   %ebp
80103824:	89 e5                	mov    %esp,%ebp
80103826:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103829:	a1 c8 42 11 80       	mov    0x801142c8,%eax
8010382e:	83 f8 1d             	cmp    $0x1d,%eax
80103831:	7f 12                	jg     80103845 <log_write+0x22>
80103833:	a1 c8 42 11 80       	mov    0x801142c8,%eax
80103838:	8b 15 b8 42 11 80    	mov    0x801142b8,%edx
8010383e:	83 ea 01             	sub    $0x1,%edx
80103841:	39 d0                	cmp    %edx,%eax
80103843:	7c 0d                	jl     80103852 <log_write+0x2f>
    panic("too big a transaction");
80103845:	83 ec 0c             	sub    $0xc,%esp
80103848:	68 cf 9a 10 80       	push   $0x80109acf
8010384d:	e8 14 cd ff ff       	call   80100566 <panic>
  if (log.outstanding < 1)
80103852:	a1 bc 42 11 80       	mov    0x801142bc,%eax
80103857:	85 c0                	test   %eax,%eax
80103859:	7f 0d                	jg     80103868 <log_write+0x45>
    panic("log_write outside of trans");
8010385b:	83 ec 0c             	sub    $0xc,%esp
8010385e:	68 e5 9a 10 80       	push   $0x80109ae5
80103863:	e8 fe cc ff ff       	call   80100566 <panic>

  acquire(&log.lock);
80103868:	83 ec 0c             	sub    $0xc,%esp
8010386b:	68 80 42 11 80       	push   $0x80114280
80103870:	e8 f6 28 00 00       	call   8010616b <acquire>
80103875:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
80103878:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010387f:	eb 1d                	jmp    8010389e <log_write+0x7b>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103881:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103884:	83 c0 10             	add    $0x10,%eax
80103887:	8b 04 85 8c 42 11 80 	mov    -0x7feebd74(,%eax,4),%eax
8010388e:	89 c2                	mov    %eax,%edx
80103890:	8b 45 08             	mov    0x8(%ebp),%eax
80103893:	8b 40 08             	mov    0x8(%eax),%eax
80103896:	39 c2                	cmp    %eax,%edx
80103898:	74 10                	je     801038aa <log_write+0x87>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
8010389a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010389e:	a1 c8 42 11 80       	mov    0x801142c8,%eax
801038a3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801038a6:	7f d9                	jg     80103881 <log_write+0x5e>
801038a8:	eb 01                	jmp    801038ab <log_write+0x88>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
801038aa:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
801038ab:	8b 45 08             	mov    0x8(%ebp),%eax
801038ae:	8b 40 08             	mov    0x8(%eax),%eax
801038b1:	89 c2                	mov    %eax,%edx
801038b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038b6:	83 c0 10             	add    $0x10,%eax
801038b9:	89 14 85 8c 42 11 80 	mov    %edx,-0x7feebd74(,%eax,4)
  if (i == log.lh.n)
801038c0:	a1 c8 42 11 80       	mov    0x801142c8,%eax
801038c5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801038c8:	75 0d                	jne    801038d7 <log_write+0xb4>
    log.lh.n++;
801038ca:	a1 c8 42 11 80       	mov    0x801142c8,%eax
801038cf:	83 c0 01             	add    $0x1,%eax
801038d2:	a3 c8 42 11 80       	mov    %eax,0x801142c8
  b->flags |= B_DIRTY; // prevent eviction
801038d7:	8b 45 08             	mov    0x8(%ebp),%eax
801038da:	8b 00                	mov    (%eax),%eax
801038dc:	83 c8 04             	or     $0x4,%eax
801038df:	89 c2                	mov    %eax,%edx
801038e1:	8b 45 08             	mov    0x8(%ebp),%eax
801038e4:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
801038e6:	83 ec 0c             	sub    $0xc,%esp
801038e9:	68 80 42 11 80       	push   $0x80114280
801038ee:	e8 df 28 00 00       	call   801061d2 <release>
801038f3:	83 c4 10             	add    $0x10,%esp
}
801038f6:	90                   	nop
801038f7:	c9                   	leave  
801038f8:	c3                   	ret    

801038f9 <v2p>:
801038f9:	55                   	push   %ebp
801038fa:	89 e5                	mov    %esp,%ebp
801038fc:	8b 45 08             	mov    0x8(%ebp),%eax
801038ff:	05 00 00 00 80       	add    $0x80000000,%eax
80103904:	5d                   	pop    %ebp
80103905:	c3                   	ret    

80103906 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80103906:	55                   	push   %ebp
80103907:	89 e5                	mov    %esp,%ebp
80103909:	8b 45 08             	mov    0x8(%ebp),%eax
8010390c:	05 00 00 00 80       	add    $0x80000000,%eax
80103911:	5d                   	pop    %ebp
80103912:	c3                   	ret    

80103913 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103913:	55                   	push   %ebp
80103914:	89 e5                	mov    %esp,%ebp
80103916:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103919:	8b 55 08             	mov    0x8(%ebp),%edx
8010391c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010391f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103922:	f0 87 02             	lock xchg %eax,(%edx)
80103925:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103928:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010392b:	c9                   	leave  
8010392c:	c3                   	ret    

8010392d <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
8010392d:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103931:	83 e4 f0             	and    $0xfffffff0,%esp
80103934:	ff 71 fc             	pushl  -0x4(%ecx)
80103937:	55                   	push   %ebp
80103938:	89 e5                	mov    %esp,%ebp
8010393a:	51                   	push   %ecx
8010393b:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010393e:	83 ec 08             	sub    $0x8,%esp
80103941:	68 00 00 40 80       	push   $0x80400000
80103946:	68 5c 79 11 80       	push   $0x8011795c
8010394b:	e8 7d f2 ff ff       	call   80102bcd <kinit1>
80103950:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103953:	e8 77 57 00 00       	call   801090cf <kvmalloc>
  mpinit();        // collect info about this machine
80103958:	e8 43 04 00 00       	call   80103da0 <mpinit>
  lapicinit();
8010395d:	e8 ea f5 ff ff       	call   80102f4c <lapicinit>
  seginit();       // set up segments
80103962:	e8 11 51 00 00       	call   80108a78 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80103967:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010396d:	0f b6 00             	movzbl (%eax),%eax
80103970:	0f b6 c0             	movzbl %al,%eax
80103973:	83 ec 08             	sub    $0x8,%esp
80103976:	50                   	push   %eax
80103977:	68 00 9b 10 80       	push   $0x80109b00
8010397c:	e8 45 ca ff ff       	call   801003c6 <cprintf>
80103981:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
80103984:	e8 6d 06 00 00       	call   80103ff6 <picinit>
  ioapicinit();    // another interrupt controller
80103989:	e8 34 f1 ff ff       	call   80102ac2 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
8010398e:	e8 24 d2 ff ff       	call   80100bb7 <consoleinit>
  uartinit();      // serial port
80103993:	e8 3c 44 00 00       	call   80107dd4 <uartinit>
  pinit();         // process table
80103998:	e8 56 0b 00 00       	call   801044f3 <pinit>
  tvinit();        // trap vectors
8010399d:	e8 0b 40 00 00       	call   801079ad <tvinit>
  binit();         // buffer cache
801039a2:	e8 8d c6 ff ff       	call   80100034 <binit>
  fileinit();      // file table
801039a7:	e8 67 d6 ff ff       	call   80101013 <fileinit>
  ideinit();       // disk
801039ac:	e8 19 ed ff ff       	call   801026ca <ideinit>
  if(!ismp)
801039b1:	a1 64 43 11 80       	mov    0x80114364,%eax
801039b6:	85 c0                	test   %eax,%eax
801039b8:	75 05                	jne    801039bf <main+0x92>
    timerinit();   // uniprocessor timer
801039ba:	e8 3f 3f 00 00       	call   801078fe <timerinit>
  startothers();   // start other processors
801039bf:	e8 7f 00 00 00       	call   80103a43 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801039c4:	83 ec 08             	sub    $0x8,%esp
801039c7:	68 00 00 00 8e       	push   $0x8e000000
801039cc:	68 00 00 40 80       	push   $0x80400000
801039d1:	e8 30 f2 ff ff       	call   80102c06 <kinit2>
801039d6:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
801039d9:	e8 92 0c 00 00       	call   80104670 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
801039de:	e8 1a 00 00 00       	call   801039fd <mpmain>

801039e3 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801039e3:	55                   	push   %ebp
801039e4:	89 e5                	mov    %esp,%ebp
801039e6:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
801039e9:	e8 f9 56 00 00       	call   801090e7 <switchkvm>
  seginit();
801039ee:	e8 85 50 00 00       	call   80108a78 <seginit>
  lapicinit();
801039f3:	e8 54 f5 ff ff       	call   80102f4c <lapicinit>
  mpmain();
801039f8:	e8 00 00 00 00       	call   801039fd <mpmain>

801039fd <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801039fd:	55                   	push   %ebp
801039fe:	89 e5                	mov    %esp,%ebp
80103a00:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpu->id);
80103a03:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103a09:	0f b6 00             	movzbl (%eax),%eax
80103a0c:	0f b6 c0             	movzbl %al,%eax
80103a0f:	83 ec 08             	sub    $0x8,%esp
80103a12:	50                   	push   %eax
80103a13:	68 17 9b 10 80       	push   $0x80109b17
80103a18:	e8 a9 c9 ff ff       	call   801003c6 <cprintf>
80103a1d:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103a20:	e8 e9 40 00 00       	call   80107b0e <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103a25:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103a2b:	05 a8 00 00 00       	add    $0xa8,%eax
80103a30:	83 ec 08             	sub    $0x8,%esp
80103a33:	6a 01                	push   $0x1
80103a35:	50                   	push   %eax
80103a36:	e8 d8 fe ff ff       	call   80103913 <xchg>
80103a3b:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103a3e:	e8 1b 14 00 00       	call   80104e5e <scheduler>

80103a43 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103a43:	55                   	push   %ebp
80103a44:	89 e5                	mov    %esp,%ebp
80103a46:	53                   	push   %ebx
80103a47:	83 ec 14             	sub    $0x14,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
80103a4a:	68 00 70 00 00       	push   $0x7000
80103a4f:	e8 b2 fe ff ff       	call   80103906 <p2v>
80103a54:	83 c4 04             	add    $0x4,%esp
80103a57:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103a5a:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103a5f:	83 ec 04             	sub    $0x4,%esp
80103a62:	50                   	push   %eax
80103a63:	68 2c d5 10 80       	push   $0x8010d52c
80103a68:	ff 75 f0             	pushl  -0x10(%ebp)
80103a6b:	e8 1d 2a 00 00       	call   8010648d <memmove>
80103a70:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103a73:	c7 45 f4 80 43 11 80 	movl   $0x80114380,-0xc(%ebp)
80103a7a:	e9 90 00 00 00       	jmp    80103b0f <startothers+0xcc>
    if(c == cpus+cpunum())  // We've started already.
80103a7f:	e8 e6 f5 ff ff       	call   8010306a <cpunum>
80103a84:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103a8a:	05 80 43 11 80       	add    $0x80114380,%eax
80103a8f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103a92:	74 73                	je     80103b07 <startothers+0xc4>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103a94:	e8 6b f2 ff ff       	call   80102d04 <kalloc>
80103a99:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103a9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a9f:	83 e8 04             	sub    $0x4,%eax
80103aa2:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103aa5:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103aab:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103aad:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ab0:	83 e8 08             	sub    $0x8,%eax
80103ab3:	c7 00 e3 39 10 80    	movl   $0x801039e3,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103ab9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103abc:	8d 58 f4             	lea    -0xc(%eax),%ebx
80103abf:	83 ec 0c             	sub    $0xc,%esp
80103ac2:	68 00 c0 10 80       	push   $0x8010c000
80103ac7:	e8 2d fe ff ff       	call   801038f9 <v2p>
80103acc:	83 c4 10             	add    $0x10,%esp
80103acf:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
80103ad1:	83 ec 0c             	sub    $0xc,%esp
80103ad4:	ff 75 f0             	pushl  -0x10(%ebp)
80103ad7:	e8 1d fe ff ff       	call   801038f9 <v2p>
80103adc:	83 c4 10             	add    $0x10,%esp
80103adf:	89 c2                	mov    %eax,%edx
80103ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ae4:	0f b6 00             	movzbl (%eax),%eax
80103ae7:	0f b6 c0             	movzbl %al,%eax
80103aea:	83 ec 08             	sub    $0x8,%esp
80103aed:	52                   	push   %edx
80103aee:	50                   	push   %eax
80103aef:	e8 f0 f5 ff ff       	call   801030e4 <lapicstartap>
80103af4:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103af7:	90                   	nop
80103af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103afb:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103b01:	85 c0                	test   %eax,%eax
80103b03:	74 f3                	je     80103af8 <startothers+0xb5>
80103b05:	eb 01                	jmp    80103b08 <startothers+0xc5>
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
80103b07:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103b08:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103b0f:	a1 60 49 11 80       	mov    0x80114960,%eax
80103b14:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103b1a:	05 80 43 11 80       	add    $0x80114380,%eax
80103b1f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103b22:	0f 87 57 ff ff ff    	ja     80103a7f <startothers+0x3c>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103b28:	90                   	nop
80103b29:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b2c:	c9                   	leave  
80103b2d:	c3                   	ret    

80103b2e <p2v>:
80103b2e:	55                   	push   %ebp
80103b2f:	89 e5                	mov    %esp,%ebp
80103b31:	8b 45 08             	mov    0x8(%ebp),%eax
80103b34:	05 00 00 00 80       	add    $0x80000000,%eax
80103b39:	5d                   	pop    %ebp
80103b3a:	c3                   	ret    

80103b3b <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80103b3b:	55                   	push   %ebp
80103b3c:	89 e5                	mov    %esp,%ebp
80103b3e:	83 ec 14             	sub    $0x14,%esp
80103b41:	8b 45 08             	mov    0x8(%ebp),%eax
80103b44:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103b48:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103b4c:	89 c2                	mov    %eax,%edx
80103b4e:	ec                   	in     (%dx),%al
80103b4f:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103b52:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103b56:	c9                   	leave  
80103b57:	c3                   	ret    

80103b58 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103b58:	55                   	push   %ebp
80103b59:	89 e5                	mov    %esp,%ebp
80103b5b:	83 ec 08             	sub    $0x8,%esp
80103b5e:	8b 55 08             	mov    0x8(%ebp),%edx
80103b61:	8b 45 0c             	mov    0xc(%ebp),%eax
80103b64:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103b68:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103b6b:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103b6f:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103b73:	ee                   	out    %al,(%dx)
}
80103b74:	90                   	nop
80103b75:	c9                   	leave  
80103b76:	c3                   	ret    

80103b77 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103b77:	55                   	push   %ebp
80103b78:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103b7a:	a1 64 d6 10 80       	mov    0x8010d664,%eax
80103b7f:	89 c2                	mov    %eax,%edx
80103b81:	b8 80 43 11 80       	mov    $0x80114380,%eax
80103b86:	29 c2                	sub    %eax,%edx
80103b88:	89 d0                	mov    %edx,%eax
80103b8a:	c1 f8 02             	sar    $0x2,%eax
80103b8d:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103b93:	5d                   	pop    %ebp
80103b94:	c3                   	ret    

80103b95 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103b95:	55                   	push   %ebp
80103b96:	89 e5                	mov    %esp,%ebp
80103b98:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103b9b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103ba2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103ba9:	eb 15                	jmp    80103bc0 <sum+0x2b>
    sum += addr[i];
80103bab:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103bae:	8b 45 08             	mov    0x8(%ebp),%eax
80103bb1:	01 d0                	add    %edx,%eax
80103bb3:	0f b6 00             	movzbl (%eax),%eax
80103bb6:	0f b6 c0             	movzbl %al,%eax
80103bb9:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103bbc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103bc0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103bc3:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103bc6:	7c e3                	jl     80103bab <sum+0x16>
    sum += addr[i];
  return sum;
80103bc8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103bcb:	c9                   	leave  
80103bcc:	c3                   	ret    

80103bcd <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103bcd:	55                   	push   %ebp
80103bce:	89 e5                	mov    %esp,%ebp
80103bd0:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103bd3:	ff 75 08             	pushl  0x8(%ebp)
80103bd6:	e8 53 ff ff ff       	call   80103b2e <p2v>
80103bdb:	83 c4 04             	add    $0x4,%esp
80103bde:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103be1:	8b 55 0c             	mov    0xc(%ebp),%edx
80103be4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103be7:	01 d0                	add    %edx,%eax
80103be9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103bec:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bef:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103bf2:	eb 36                	jmp    80103c2a <mpsearch1+0x5d>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103bf4:	83 ec 04             	sub    $0x4,%esp
80103bf7:	6a 04                	push   $0x4
80103bf9:	68 28 9b 10 80       	push   $0x80109b28
80103bfe:	ff 75 f4             	pushl  -0xc(%ebp)
80103c01:	e8 2f 28 00 00       	call   80106435 <memcmp>
80103c06:	83 c4 10             	add    $0x10,%esp
80103c09:	85 c0                	test   %eax,%eax
80103c0b:	75 19                	jne    80103c26 <mpsearch1+0x59>
80103c0d:	83 ec 08             	sub    $0x8,%esp
80103c10:	6a 10                	push   $0x10
80103c12:	ff 75 f4             	pushl  -0xc(%ebp)
80103c15:	e8 7b ff ff ff       	call   80103b95 <sum>
80103c1a:	83 c4 10             	add    $0x10,%esp
80103c1d:	84 c0                	test   %al,%al
80103c1f:	75 05                	jne    80103c26 <mpsearch1+0x59>
      return (struct mp*)p;
80103c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c24:	eb 11                	jmp    80103c37 <mpsearch1+0x6a>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103c26:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c2d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103c30:	72 c2                	jb     80103bf4 <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103c32:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103c37:	c9                   	leave  
80103c38:	c3                   	ret    

80103c39 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103c39:	55                   	push   %ebp
80103c3a:	89 e5                	mov    %esp,%ebp
80103c3c:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103c3f:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c49:	83 c0 0f             	add    $0xf,%eax
80103c4c:	0f b6 00             	movzbl (%eax),%eax
80103c4f:	0f b6 c0             	movzbl %al,%eax
80103c52:	c1 e0 08             	shl    $0x8,%eax
80103c55:	89 c2                	mov    %eax,%edx
80103c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c5a:	83 c0 0e             	add    $0xe,%eax
80103c5d:	0f b6 00             	movzbl (%eax),%eax
80103c60:	0f b6 c0             	movzbl %al,%eax
80103c63:	09 d0                	or     %edx,%eax
80103c65:	c1 e0 04             	shl    $0x4,%eax
80103c68:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103c6b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103c6f:	74 21                	je     80103c92 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103c71:	83 ec 08             	sub    $0x8,%esp
80103c74:	68 00 04 00 00       	push   $0x400
80103c79:	ff 75 f0             	pushl  -0x10(%ebp)
80103c7c:	e8 4c ff ff ff       	call   80103bcd <mpsearch1>
80103c81:	83 c4 10             	add    $0x10,%esp
80103c84:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103c87:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103c8b:	74 51                	je     80103cde <mpsearch+0xa5>
      return mp;
80103c8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c90:	eb 61                	jmp    80103cf3 <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c95:	83 c0 14             	add    $0x14,%eax
80103c98:	0f b6 00             	movzbl (%eax),%eax
80103c9b:	0f b6 c0             	movzbl %al,%eax
80103c9e:	c1 e0 08             	shl    $0x8,%eax
80103ca1:	89 c2                	mov    %eax,%edx
80103ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ca6:	83 c0 13             	add    $0x13,%eax
80103ca9:	0f b6 00             	movzbl (%eax),%eax
80103cac:	0f b6 c0             	movzbl %al,%eax
80103caf:	09 d0                	or     %edx,%eax
80103cb1:	c1 e0 0a             	shl    $0xa,%eax
80103cb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103cb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cba:	2d 00 04 00 00       	sub    $0x400,%eax
80103cbf:	83 ec 08             	sub    $0x8,%esp
80103cc2:	68 00 04 00 00       	push   $0x400
80103cc7:	50                   	push   %eax
80103cc8:	e8 00 ff ff ff       	call   80103bcd <mpsearch1>
80103ccd:	83 c4 10             	add    $0x10,%esp
80103cd0:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103cd3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103cd7:	74 05                	je     80103cde <mpsearch+0xa5>
      return mp;
80103cd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103cdc:	eb 15                	jmp    80103cf3 <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
80103cde:	83 ec 08             	sub    $0x8,%esp
80103ce1:	68 00 00 01 00       	push   $0x10000
80103ce6:	68 00 00 0f 00       	push   $0xf0000
80103ceb:	e8 dd fe ff ff       	call   80103bcd <mpsearch1>
80103cf0:	83 c4 10             	add    $0x10,%esp
}
80103cf3:	c9                   	leave  
80103cf4:	c3                   	ret    

80103cf5 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103cf5:	55                   	push   %ebp
80103cf6:	89 e5                	mov    %esp,%ebp
80103cf8:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103cfb:	e8 39 ff ff ff       	call   80103c39 <mpsearch>
80103d00:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103d03:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103d07:	74 0a                	je     80103d13 <mpconfig+0x1e>
80103d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d0c:	8b 40 04             	mov    0x4(%eax),%eax
80103d0f:	85 c0                	test   %eax,%eax
80103d11:	75 0a                	jne    80103d1d <mpconfig+0x28>
    return 0;
80103d13:	b8 00 00 00 00       	mov    $0x0,%eax
80103d18:	e9 81 00 00 00       	jmp    80103d9e <mpconfig+0xa9>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d20:	8b 40 04             	mov    0x4(%eax),%eax
80103d23:	83 ec 0c             	sub    $0xc,%esp
80103d26:	50                   	push   %eax
80103d27:	e8 02 fe ff ff       	call   80103b2e <p2v>
80103d2c:	83 c4 10             	add    $0x10,%esp
80103d2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103d32:	83 ec 04             	sub    $0x4,%esp
80103d35:	6a 04                	push   $0x4
80103d37:	68 2d 9b 10 80       	push   $0x80109b2d
80103d3c:	ff 75 f0             	pushl  -0x10(%ebp)
80103d3f:	e8 f1 26 00 00       	call   80106435 <memcmp>
80103d44:	83 c4 10             	add    $0x10,%esp
80103d47:	85 c0                	test   %eax,%eax
80103d49:	74 07                	je     80103d52 <mpconfig+0x5d>
    return 0;
80103d4b:	b8 00 00 00 00       	mov    $0x0,%eax
80103d50:	eb 4c                	jmp    80103d9e <mpconfig+0xa9>
  if(conf->version != 1 && conf->version != 4)
80103d52:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d55:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103d59:	3c 01                	cmp    $0x1,%al
80103d5b:	74 12                	je     80103d6f <mpconfig+0x7a>
80103d5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d60:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103d64:	3c 04                	cmp    $0x4,%al
80103d66:	74 07                	je     80103d6f <mpconfig+0x7a>
    return 0;
80103d68:	b8 00 00 00 00       	mov    $0x0,%eax
80103d6d:	eb 2f                	jmp    80103d9e <mpconfig+0xa9>
  if(sum((uchar*)conf, conf->length) != 0)
80103d6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d72:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103d76:	0f b7 c0             	movzwl %ax,%eax
80103d79:	83 ec 08             	sub    $0x8,%esp
80103d7c:	50                   	push   %eax
80103d7d:	ff 75 f0             	pushl  -0x10(%ebp)
80103d80:	e8 10 fe ff ff       	call   80103b95 <sum>
80103d85:	83 c4 10             	add    $0x10,%esp
80103d88:	84 c0                	test   %al,%al
80103d8a:	74 07                	je     80103d93 <mpconfig+0x9e>
    return 0;
80103d8c:	b8 00 00 00 00       	mov    $0x0,%eax
80103d91:	eb 0b                	jmp    80103d9e <mpconfig+0xa9>
  *pmp = mp;
80103d93:	8b 45 08             	mov    0x8(%ebp),%eax
80103d96:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103d99:	89 10                	mov    %edx,(%eax)
  return conf;
80103d9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103d9e:	c9                   	leave  
80103d9f:	c3                   	ret    

80103da0 <mpinit>:

void
mpinit(void)
{
80103da0:	55                   	push   %ebp
80103da1:	89 e5                	mov    %esp,%ebp
80103da3:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103da6:	c7 05 64 d6 10 80 80 	movl   $0x80114380,0x8010d664
80103dad:	43 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103db0:	83 ec 0c             	sub    $0xc,%esp
80103db3:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103db6:	50                   	push   %eax
80103db7:	e8 39 ff ff ff       	call   80103cf5 <mpconfig>
80103dbc:	83 c4 10             	add    $0x10,%esp
80103dbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103dc2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103dc6:	0f 84 96 01 00 00    	je     80103f62 <mpinit+0x1c2>
    return;
  ismp = 1;
80103dcc:	c7 05 64 43 11 80 01 	movl   $0x1,0x80114364
80103dd3:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103dd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103dd9:	8b 40 24             	mov    0x24(%eax),%eax
80103ddc:	a3 7c 42 11 80       	mov    %eax,0x8011427c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103de1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103de4:	83 c0 2c             	add    $0x2c,%eax
80103de7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103dea:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ded:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103df1:	0f b7 d0             	movzwl %ax,%edx
80103df4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103df7:	01 d0                	add    %edx,%eax
80103df9:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103dfc:	e9 f2 00 00 00       	jmp    80103ef3 <mpinit+0x153>
    switch(*p){
80103e01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e04:	0f b6 00             	movzbl (%eax),%eax
80103e07:	0f b6 c0             	movzbl %al,%eax
80103e0a:	83 f8 04             	cmp    $0x4,%eax
80103e0d:	0f 87 bc 00 00 00    	ja     80103ecf <mpinit+0x12f>
80103e13:	8b 04 85 70 9b 10 80 	mov    -0x7fef6490(,%eax,4),%eax
80103e1a:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e1f:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103e22:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103e25:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103e29:	0f b6 d0             	movzbl %al,%edx
80103e2c:	a1 60 49 11 80       	mov    0x80114960,%eax
80103e31:	39 c2                	cmp    %eax,%edx
80103e33:	74 2b                	je     80103e60 <mpinit+0xc0>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103e35:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103e38:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103e3c:	0f b6 d0             	movzbl %al,%edx
80103e3f:	a1 60 49 11 80       	mov    0x80114960,%eax
80103e44:	83 ec 04             	sub    $0x4,%esp
80103e47:	52                   	push   %edx
80103e48:	50                   	push   %eax
80103e49:	68 32 9b 10 80       	push   $0x80109b32
80103e4e:	e8 73 c5 ff ff       	call   801003c6 <cprintf>
80103e53:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
80103e56:	c7 05 64 43 11 80 00 	movl   $0x0,0x80114364
80103e5d:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103e60:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103e63:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103e67:	0f b6 c0             	movzbl %al,%eax
80103e6a:	83 e0 02             	and    $0x2,%eax
80103e6d:	85 c0                	test   %eax,%eax
80103e6f:	74 15                	je     80103e86 <mpinit+0xe6>
        bcpu = &cpus[ncpu];
80103e71:	a1 60 49 11 80       	mov    0x80114960,%eax
80103e76:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103e7c:	05 80 43 11 80       	add    $0x80114380,%eax
80103e81:	a3 64 d6 10 80       	mov    %eax,0x8010d664
      cpus[ncpu].id = ncpu;
80103e86:	a1 60 49 11 80       	mov    0x80114960,%eax
80103e8b:	8b 15 60 49 11 80    	mov    0x80114960,%edx
80103e91:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103e97:	05 80 43 11 80       	add    $0x80114380,%eax
80103e9c:	88 10                	mov    %dl,(%eax)
      ncpu++;
80103e9e:	a1 60 49 11 80       	mov    0x80114960,%eax
80103ea3:	83 c0 01             	add    $0x1,%eax
80103ea6:	a3 60 49 11 80       	mov    %eax,0x80114960
      p += sizeof(struct mpproc);
80103eab:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103eaf:	eb 42                	jmp    80103ef3 <mpinit+0x153>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103eb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103eb4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103eb7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103eba:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103ebe:	a2 60 43 11 80       	mov    %al,0x80114360
      p += sizeof(struct mpioapic);
80103ec3:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103ec7:	eb 2a                	jmp    80103ef3 <mpinit+0x153>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103ec9:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103ecd:	eb 24                	jmp    80103ef3 <mpinit+0x153>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ed2:	0f b6 00             	movzbl (%eax),%eax
80103ed5:	0f b6 c0             	movzbl %al,%eax
80103ed8:	83 ec 08             	sub    $0x8,%esp
80103edb:	50                   	push   %eax
80103edc:	68 50 9b 10 80       	push   $0x80109b50
80103ee1:	e8 e0 c4 ff ff       	call   801003c6 <cprintf>
80103ee6:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
80103ee9:	c7 05 64 43 11 80 00 	movl   $0x0,0x80114364
80103ef0:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ef6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103ef9:	0f 82 02 ff ff ff    	jb     80103e01 <mpinit+0x61>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103eff:	a1 64 43 11 80       	mov    0x80114364,%eax
80103f04:	85 c0                	test   %eax,%eax
80103f06:	75 1d                	jne    80103f25 <mpinit+0x185>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103f08:	c7 05 60 49 11 80 01 	movl   $0x1,0x80114960
80103f0f:	00 00 00 
    lapic = 0;
80103f12:	c7 05 7c 42 11 80 00 	movl   $0x0,0x8011427c
80103f19:	00 00 00 
    ioapicid = 0;
80103f1c:	c6 05 60 43 11 80 00 	movb   $0x0,0x80114360
    return;
80103f23:	eb 3e                	jmp    80103f63 <mpinit+0x1c3>
  }

  if(mp->imcrp){
80103f25:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103f28:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103f2c:	84 c0                	test   %al,%al
80103f2e:	74 33                	je     80103f63 <mpinit+0x1c3>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103f30:	83 ec 08             	sub    $0x8,%esp
80103f33:	6a 70                	push   $0x70
80103f35:	6a 22                	push   $0x22
80103f37:	e8 1c fc ff ff       	call   80103b58 <outb>
80103f3c:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103f3f:	83 ec 0c             	sub    $0xc,%esp
80103f42:	6a 23                	push   $0x23
80103f44:	e8 f2 fb ff ff       	call   80103b3b <inb>
80103f49:	83 c4 10             	add    $0x10,%esp
80103f4c:	83 c8 01             	or     $0x1,%eax
80103f4f:	0f b6 c0             	movzbl %al,%eax
80103f52:	83 ec 08             	sub    $0x8,%esp
80103f55:	50                   	push   %eax
80103f56:	6a 23                	push   $0x23
80103f58:	e8 fb fb ff ff       	call   80103b58 <outb>
80103f5d:	83 c4 10             	add    $0x10,%esp
80103f60:	eb 01                	jmp    80103f63 <mpinit+0x1c3>
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
80103f62:	90                   	nop
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
80103f63:	c9                   	leave  
80103f64:	c3                   	ret    

80103f65 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103f65:	55                   	push   %ebp
80103f66:	89 e5                	mov    %esp,%ebp
80103f68:	83 ec 08             	sub    $0x8,%esp
80103f6b:	8b 55 08             	mov    0x8(%ebp),%edx
80103f6e:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f71:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103f75:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103f78:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103f7c:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103f80:	ee                   	out    %al,(%dx)
}
80103f81:	90                   	nop
80103f82:	c9                   	leave  
80103f83:	c3                   	ret    

80103f84 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103f84:	55                   	push   %ebp
80103f85:	89 e5                	mov    %esp,%ebp
80103f87:	83 ec 04             	sub    $0x4,%esp
80103f8a:	8b 45 08             	mov    0x8(%ebp),%eax
80103f8d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103f91:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103f95:	66 a3 00 d0 10 80    	mov    %ax,0x8010d000
  outb(IO_PIC1+1, mask);
80103f9b:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103f9f:	0f b6 c0             	movzbl %al,%eax
80103fa2:	50                   	push   %eax
80103fa3:	6a 21                	push   $0x21
80103fa5:	e8 bb ff ff ff       	call   80103f65 <outb>
80103faa:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, mask >> 8);
80103fad:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103fb1:	66 c1 e8 08          	shr    $0x8,%ax
80103fb5:	0f b6 c0             	movzbl %al,%eax
80103fb8:	50                   	push   %eax
80103fb9:	68 a1 00 00 00       	push   $0xa1
80103fbe:	e8 a2 ff ff ff       	call   80103f65 <outb>
80103fc3:	83 c4 08             	add    $0x8,%esp
}
80103fc6:	90                   	nop
80103fc7:	c9                   	leave  
80103fc8:	c3                   	ret    

80103fc9 <picenable>:

void
picenable(int irq)
{
80103fc9:	55                   	push   %ebp
80103fca:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
80103fcc:	8b 45 08             	mov    0x8(%ebp),%eax
80103fcf:	ba 01 00 00 00       	mov    $0x1,%edx
80103fd4:	89 c1                	mov    %eax,%ecx
80103fd6:	d3 e2                	shl    %cl,%edx
80103fd8:	89 d0                	mov    %edx,%eax
80103fda:	f7 d0                	not    %eax
80103fdc:	89 c2                	mov    %eax,%edx
80103fde:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
80103fe5:	21 d0                	and    %edx,%eax
80103fe7:	0f b7 c0             	movzwl %ax,%eax
80103fea:	50                   	push   %eax
80103feb:	e8 94 ff ff ff       	call   80103f84 <picsetmask>
80103ff0:	83 c4 04             	add    $0x4,%esp
}
80103ff3:	90                   	nop
80103ff4:	c9                   	leave  
80103ff5:	c3                   	ret    

80103ff6 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103ff6:	55                   	push   %ebp
80103ff7:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103ff9:	68 ff 00 00 00       	push   $0xff
80103ffe:	6a 21                	push   $0x21
80104000:	e8 60 ff ff ff       	call   80103f65 <outb>
80104005:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80104008:	68 ff 00 00 00       	push   $0xff
8010400d:	68 a1 00 00 00       	push   $0xa1
80104012:	e8 4e ff ff ff       	call   80103f65 <outb>
80104017:	83 c4 08             	add    $0x8,%esp

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
8010401a:	6a 11                	push   $0x11
8010401c:	6a 20                	push   $0x20
8010401e:	e8 42 ff ff ff       	call   80103f65 <outb>
80104023:	83 c4 08             	add    $0x8,%esp

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80104026:	6a 20                	push   $0x20
80104028:	6a 21                	push   $0x21
8010402a:	e8 36 ff ff ff       	call   80103f65 <outb>
8010402f:	83 c4 08             	add    $0x8,%esp

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80104032:	6a 04                	push   $0x4
80104034:	6a 21                	push   $0x21
80104036:	e8 2a ff ff ff       	call   80103f65 <outb>
8010403b:	83 c4 08             	add    $0x8,%esp
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
8010403e:	6a 03                	push   $0x3
80104040:	6a 21                	push   $0x21
80104042:	e8 1e ff ff ff       	call   80103f65 <outb>
80104047:	83 c4 08             	add    $0x8,%esp

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
8010404a:	6a 11                	push   $0x11
8010404c:	68 a0 00 00 00       	push   $0xa0
80104051:	e8 0f ff ff ff       	call   80103f65 <outb>
80104056:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80104059:	6a 28                	push   $0x28
8010405b:	68 a1 00 00 00       	push   $0xa1
80104060:	e8 00 ff ff ff       	call   80103f65 <outb>
80104065:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80104068:	6a 02                	push   $0x2
8010406a:	68 a1 00 00 00       	push   $0xa1
8010406f:	e8 f1 fe ff ff       	call   80103f65 <outb>
80104074:	83 c4 08             	add    $0x8,%esp
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80104077:	6a 03                	push   $0x3
80104079:	68 a1 00 00 00       	push   $0xa1
8010407e:	e8 e2 fe ff ff       	call   80103f65 <outb>
80104083:	83 c4 08             	add    $0x8,%esp

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80104086:	6a 68                	push   $0x68
80104088:	6a 20                	push   $0x20
8010408a:	e8 d6 fe ff ff       	call   80103f65 <outb>
8010408f:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC1, 0x0a);             // read IRR by default
80104092:	6a 0a                	push   $0xa
80104094:	6a 20                	push   $0x20
80104096:	e8 ca fe ff ff       	call   80103f65 <outb>
8010409b:	83 c4 08             	add    $0x8,%esp

  outb(IO_PIC2, 0x68);             // OCW3
8010409e:	6a 68                	push   $0x68
801040a0:	68 a0 00 00 00       	push   $0xa0
801040a5:	e8 bb fe ff ff       	call   80103f65 <outb>
801040aa:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2, 0x0a);             // OCW3
801040ad:	6a 0a                	push   $0xa
801040af:	68 a0 00 00 00       	push   $0xa0
801040b4:	e8 ac fe ff ff       	call   80103f65 <outb>
801040b9:	83 c4 08             	add    $0x8,%esp

  if(irqmask != 0xFFFF)
801040bc:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
801040c3:	66 83 f8 ff          	cmp    $0xffff,%ax
801040c7:	74 13                	je     801040dc <picinit+0xe6>
    picsetmask(irqmask);
801040c9:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
801040d0:	0f b7 c0             	movzwl %ax,%eax
801040d3:	50                   	push   %eax
801040d4:	e8 ab fe ff ff       	call   80103f84 <picsetmask>
801040d9:	83 c4 04             	add    $0x4,%esp
}
801040dc:	90                   	nop
801040dd:	c9                   	leave  
801040de:	c3                   	ret    

801040df <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801040df:	55                   	push   %ebp
801040e0:	89 e5                	mov    %esp,%ebp
801040e2:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
801040e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
801040ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801040ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801040f5:	8b 45 0c             	mov    0xc(%ebp),%eax
801040f8:	8b 10                	mov    (%eax),%edx
801040fa:	8b 45 08             	mov    0x8(%ebp),%eax
801040fd:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801040ff:	e8 2d cf ff ff       	call   80101031 <filealloc>
80104104:	89 c2                	mov    %eax,%edx
80104106:	8b 45 08             	mov    0x8(%ebp),%eax
80104109:	89 10                	mov    %edx,(%eax)
8010410b:	8b 45 08             	mov    0x8(%ebp),%eax
8010410e:	8b 00                	mov    (%eax),%eax
80104110:	85 c0                	test   %eax,%eax
80104112:	0f 84 cb 00 00 00    	je     801041e3 <pipealloc+0x104>
80104118:	e8 14 cf ff ff       	call   80101031 <filealloc>
8010411d:	89 c2                	mov    %eax,%edx
8010411f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104122:	89 10                	mov    %edx,(%eax)
80104124:	8b 45 0c             	mov    0xc(%ebp),%eax
80104127:	8b 00                	mov    (%eax),%eax
80104129:	85 c0                	test   %eax,%eax
8010412b:	0f 84 b2 00 00 00    	je     801041e3 <pipealloc+0x104>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80104131:	e8 ce eb ff ff       	call   80102d04 <kalloc>
80104136:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104139:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010413d:	0f 84 9f 00 00 00    	je     801041e2 <pipealloc+0x103>
    goto bad;
  p->readopen = 1;
80104143:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104146:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010414d:	00 00 00 
  p->writeopen = 1;
80104150:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104153:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010415a:	00 00 00 
  p->nwrite = 0;
8010415d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104160:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80104167:	00 00 00 
  p->nread = 0;
8010416a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010416d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80104174:	00 00 00 
  initlock(&p->lock, "pipe");
80104177:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010417a:	83 ec 08             	sub    $0x8,%esp
8010417d:	68 84 9b 10 80       	push   $0x80109b84
80104182:	50                   	push   %eax
80104183:	e8 c1 1f 00 00       	call   80106149 <initlock>
80104188:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010418b:	8b 45 08             	mov    0x8(%ebp),%eax
8010418e:	8b 00                	mov    (%eax),%eax
80104190:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80104196:	8b 45 08             	mov    0x8(%ebp),%eax
80104199:	8b 00                	mov    (%eax),%eax
8010419b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010419f:	8b 45 08             	mov    0x8(%ebp),%eax
801041a2:	8b 00                	mov    (%eax),%eax
801041a4:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801041a8:	8b 45 08             	mov    0x8(%ebp),%eax
801041ab:	8b 00                	mov    (%eax),%eax
801041ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041b0:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
801041b3:	8b 45 0c             	mov    0xc(%ebp),%eax
801041b6:	8b 00                	mov    (%eax),%eax
801041b8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801041be:	8b 45 0c             	mov    0xc(%ebp),%eax
801041c1:	8b 00                	mov    (%eax),%eax
801041c3:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801041c7:	8b 45 0c             	mov    0xc(%ebp),%eax
801041ca:	8b 00                	mov    (%eax),%eax
801041cc:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801041d0:	8b 45 0c             	mov    0xc(%ebp),%eax
801041d3:	8b 00                	mov    (%eax),%eax
801041d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041d8:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
801041db:	b8 00 00 00 00       	mov    $0x0,%eax
801041e0:	eb 4e                	jmp    80104230 <pipealloc+0x151>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
801041e2:	90                   	nop
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;

 bad:
  if(p)
801041e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801041e7:	74 0e                	je     801041f7 <pipealloc+0x118>
    kfree((char*)p);
801041e9:	83 ec 0c             	sub    $0xc,%esp
801041ec:	ff 75 f4             	pushl  -0xc(%ebp)
801041ef:	e8 73 ea ff ff       	call   80102c67 <kfree>
801041f4:	83 c4 10             	add    $0x10,%esp
  if(*f0)
801041f7:	8b 45 08             	mov    0x8(%ebp),%eax
801041fa:	8b 00                	mov    (%eax),%eax
801041fc:	85 c0                	test   %eax,%eax
801041fe:	74 11                	je     80104211 <pipealloc+0x132>
    fileclose(*f0);
80104200:	8b 45 08             	mov    0x8(%ebp),%eax
80104203:	8b 00                	mov    (%eax),%eax
80104205:	83 ec 0c             	sub    $0xc,%esp
80104208:	50                   	push   %eax
80104209:	e8 e1 ce ff ff       	call   801010ef <fileclose>
8010420e:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80104211:	8b 45 0c             	mov    0xc(%ebp),%eax
80104214:	8b 00                	mov    (%eax),%eax
80104216:	85 c0                	test   %eax,%eax
80104218:	74 11                	je     8010422b <pipealloc+0x14c>
    fileclose(*f1);
8010421a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010421d:	8b 00                	mov    (%eax),%eax
8010421f:	83 ec 0c             	sub    $0xc,%esp
80104222:	50                   	push   %eax
80104223:	e8 c7 ce ff ff       	call   801010ef <fileclose>
80104228:	83 c4 10             	add    $0x10,%esp
  return -1;
8010422b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104230:	c9                   	leave  
80104231:	c3                   	ret    

80104232 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80104232:	55                   	push   %ebp
80104233:	89 e5                	mov    %esp,%ebp
80104235:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
80104238:	8b 45 08             	mov    0x8(%ebp),%eax
8010423b:	83 ec 0c             	sub    $0xc,%esp
8010423e:	50                   	push   %eax
8010423f:	e8 27 1f 00 00       	call   8010616b <acquire>
80104244:	83 c4 10             	add    $0x10,%esp
  if(writable){
80104247:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010424b:	74 23                	je     80104270 <pipeclose+0x3e>
    p->writeopen = 0;
8010424d:	8b 45 08             	mov    0x8(%ebp),%eax
80104250:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80104257:	00 00 00 
    wakeup(&p->nread);
8010425a:	8b 45 08             	mov    0x8(%ebp),%eax
8010425d:	05 34 02 00 00       	add    $0x234,%eax
80104262:	83 ec 0c             	sub    $0xc,%esp
80104265:	50                   	push   %eax
80104266:	e8 38 11 00 00       	call   801053a3 <wakeup>
8010426b:	83 c4 10             	add    $0x10,%esp
8010426e:	eb 21                	jmp    80104291 <pipeclose+0x5f>
  } else {
    p->readopen = 0;
80104270:	8b 45 08             	mov    0x8(%ebp),%eax
80104273:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
8010427a:	00 00 00 
    wakeup(&p->nwrite);
8010427d:	8b 45 08             	mov    0x8(%ebp),%eax
80104280:	05 38 02 00 00       	add    $0x238,%eax
80104285:	83 ec 0c             	sub    $0xc,%esp
80104288:	50                   	push   %eax
80104289:	e8 15 11 00 00       	call   801053a3 <wakeup>
8010428e:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
80104291:	8b 45 08             	mov    0x8(%ebp),%eax
80104294:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
8010429a:	85 c0                	test   %eax,%eax
8010429c:	75 2c                	jne    801042ca <pipeclose+0x98>
8010429e:	8b 45 08             	mov    0x8(%ebp),%eax
801042a1:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801042a7:	85 c0                	test   %eax,%eax
801042a9:	75 1f                	jne    801042ca <pipeclose+0x98>
    release(&p->lock);
801042ab:	8b 45 08             	mov    0x8(%ebp),%eax
801042ae:	83 ec 0c             	sub    $0xc,%esp
801042b1:	50                   	push   %eax
801042b2:	e8 1b 1f 00 00       	call   801061d2 <release>
801042b7:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
801042ba:	83 ec 0c             	sub    $0xc,%esp
801042bd:	ff 75 08             	pushl  0x8(%ebp)
801042c0:	e8 a2 e9 ff ff       	call   80102c67 <kfree>
801042c5:	83 c4 10             	add    $0x10,%esp
801042c8:	eb 0f                	jmp    801042d9 <pipeclose+0xa7>
  } else
    release(&p->lock);
801042ca:	8b 45 08             	mov    0x8(%ebp),%eax
801042cd:	83 ec 0c             	sub    $0xc,%esp
801042d0:	50                   	push   %eax
801042d1:	e8 fc 1e 00 00       	call   801061d2 <release>
801042d6:	83 c4 10             	add    $0x10,%esp
}
801042d9:	90                   	nop
801042da:	c9                   	leave  
801042db:	c3                   	ret    

801042dc <pipewrite>:

int
pipewrite(struct pipe *p, char *addr, int n)
{
801042dc:	55                   	push   %ebp
801042dd:	89 e5                	mov    %esp,%ebp
801042df:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
801042e2:	8b 45 08             	mov    0x8(%ebp),%eax
801042e5:	83 ec 0c             	sub    $0xc,%esp
801042e8:	50                   	push   %eax
801042e9:	e8 7d 1e 00 00       	call   8010616b <acquire>
801042ee:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
801042f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801042f8:	e9 ad 00 00 00       	jmp    801043aa <pipewrite+0xce>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
801042fd:	8b 45 08             	mov    0x8(%ebp),%eax
80104300:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104306:	85 c0                	test   %eax,%eax
80104308:	74 0d                	je     80104317 <pipewrite+0x3b>
8010430a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104310:	8b 40 24             	mov    0x24(%eax),%eax
80104313:	85 c0                	test   %eax,%eax
80104315:	74 19                	je     80104330 <pipewrite+0x54>
        release(&p->lock);
80104317:	8b 45 08             	mov    0x8(%ebp),%eax
8010431a:	83 ec 0c             	sub    $0xc,%esp
8010431d:	50                   	push   %eax
8010431e:	e8 af 1e 00 00       	call   801061d2 <release>
80104323:	83 c4 10             	add    $0x10,%esp
        return -1;
80104326:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010432b:	e9 a8 00 00 00       	jmp    801043d8 <pipewrite+0xfc>
      }
      wakeup(&p->nread);
80104330:	8b 45 08             	mov    0x8(%ebp),%eax
80104333:	05 34 02 00 00       	add    $0x234,%eax
80104338:	83 ec 0c             	sub    $0xc,%esp
8010433b:	50                   	push   %eax
8010433c:	e8 62 10 00 00       	call   801053a3 <wakeup>
80104341:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104344:	8b 45 08             	mov    0x8(%ebp),%eax
80104347:	8b 55 08             	mov    0x8(%ebp),%edx
8010434a:	81 c2 38 02 00 00    	add    $0x238,%edx
80104350:	83 ec 08             	sub    $0x8,%esp
80104353:	50                   	push   %eax
80104354:	52                   	push   %edx
80104355:	e8 a8 0e 00 00       	call   80105202 <sleep>
8010435a:	83 c4 10             	add    $0x10,%esp
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010435d:	8b 45 08             	mov    0x8(%ebp),%eax
80104360:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80104366:	8b 45 08             	mov    0x8(%ebp),%eax
80104369:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010436f:	05 00 02 00 00       	add    $0x200,%eax
80104374:	39 c2                	cmp    %eax,%edx
80104376:	74 85                	je     801042fd <pipewrite+0x21>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104378:	8b 45 08             	mov    0x8(%ebp),%eax
8010437b:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104381:	8d 48 01             	lea    0x1(%eax),%ecx
80104384:	8b 55 08             	mov    0x8(%ebp),%edx
80104387:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
8010438d:	25 ff 01 00 00       	and    $0x1ff,%eax
80104392:	89 c1                	mov    %eax,%ecx
80104394:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104397:	8b 45 0c             	mov    0xc(%ebp),%eax
8010439a:	01 d0                	add    %edx,%eax
8010439c:	0f b6 10             	movzbl (%eax),%edx
8010439f:	8b 45 08             	mov    0x8(%ebp),%eax
801043a2:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801043a6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801043aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043ad:	3b 45 10             	cmp    0x10(%ebp),%eax
801043b0:	7c ab                	jl     8010435d <pipewrite+0x81>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801043b2:	8b 45 08             	mov    0x8(%ebp),%eax
801043b5:	05 34 02 00 00       	add    $0x234,%eax
801043ba:	83 ec 0c             	sub    $0xc,%esp
801043bd:	50                   	push   %eax
801043be:	e8 e0 0f 00 00       	call   801053a3 <wakeup>
801043c3:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801043c6:	8b 45 08             	mov    0x8(%ebp),%eax
801043c9:	83 ec 0c             	sub    $0xc,%esp
801043cc:	50                   	push   %eax
801043cd:	e8 00 1e 00 00       	call   801061d2 <release>
801043d2:	83 c4 10             	add    $0x10,%esp
  return n;
801043d5:	8b 45 10             	mov    0x10(%ebp),%eax
}
801043d8:	c9                   	leave  
801043d9:	c3                   	ret    

801043da <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801043da:	55                   	push   %ebp
801043db:	89 e5                	mov    %esp,%ebp
801043dd:	53                   	push   %ebx
801043de:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
801043e1:	8b 45 08             	mov    0x8(%ebp),%eax
801043e4:	83 ec 0c             	sub    $0xc,%esp
801043e7:	50                   	push   %eax
801043e8:	e8 7e 1d 00 00       	call   8010616b <acquire>
801043ed:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801043f0:	eb 3f                	jmp    80104431 <piperead+0x57>
    if(proc->killed){
801043f2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043f8:	8b 40 24             	mov    0x24(%eax),%eax
801043fb:	85 c0                	test   %eax,%eax
801043fd:	74 19                	je     80104418 <piperead+0x3e>
      release(&p->lock);
801043ff:	8b 45 08             	mov    0x8(%ebp),%eax
80104402:	83 ec 0c             	sub    $0xc,%esp
80104405:	50                   	push   %eax
80104406:	e8 c7 1d 00 00       	call   801061d2 <release>
8010440b:	83 c4 10             	add    $0x10,%esp
      return -1;
8010440e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104413:	e9 bf 00 00 00       	jmp    801044d7 <piperead+0xfd>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104418:	8b 45 08             	mov    0x8(%ebp),%eax
8010441b:	8b 55 08             	mov    0x8(%ebp),%edx
8010441e:	81 c2 34 02 00 00    	add    $0x234,%edx
80104424:	83 ec 08             	sub    $0x8,%esp
80104427:	50                   	push   %eax
80104428:	52                   	push   %edx
80104429:	e8 d4 0d 00 00       	call   80105202 <sleep>
8010442e:	83 c4 10             	add    $0x10,%esp
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104431:	8b 45 08             	mov    0x8(%ebp),%eax
80104434:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
8010443a:	8b 45 08             	mov    0x8(%ebp),%eax
8010443d:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104443:	39 c2                	cmp    %eax,%edx
80104445:	75 0d                	jne    80104454 <piperead+0x7a>
80104447:	8b 45 08             	mov    0x8(%ebp),%eax
8010444a:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104450:	85 c0                	test   %eax,%eax
80104452:	75 9e                	jne    801043f2 <piperead+0x18>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104454:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010445b:	eb 49                	jmp    801044a6 <piperead+0xcc>
    if(p->nread == p->nwrite)
8010445d:	8b 45 08             	mov    0x8(%ebp),%eax
80104460:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104466:	8b 45 08             	mov    0x8(%ebp),%eax
80104469:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010446f:	39 c2                	cmp    %eax,%edx
80104471:	74 3d                	je     801044b0 <piperead+0xd6>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104473:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104476:	8b 45 0c             	mov    0xc(%ebp),%eax
80104479:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010447c:	8b 45 08             	mov    0x8(%ebp),%eax
8010447f:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104485:	8d 48 01             	lea    0x1(%eax),%ecx
80104488:	8b 55 08             	mov    0x8(%ebp),%edx
8010448b:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80104491:	25 ff 01 00 00       	and    $0x1ff,%eax
80104496:	89 c2                	mov    %eax,%edx
80104498:	8b 45 08             	mov    0x8(%ebp),%eax
8010449b:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
801044a0:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801044a2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801044a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044a9:	3b 45 10             	cmp    0x10(%ebp),%eax
801044ac:	7c af                	jl     8010445d <piperead+0x83>
801044ae:	eb 01                	jmp    801044b1 <piperead+0xd7>
    if(p->nread == p->nwrite)
      break;
801044b0:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801044b1:	8b 45 08             	mov    0x8(%ebp),%eax
801044b4:	05 38 02 00 00       	add    $0x238,%eax
801044b9:	83 ec 0c             	sub    $0xc,%esp
801044bc:	50                   	push   %eax
801044bd:	e8 e1 0e 00 00       	call   801053a3 <wakeup>
801044c2:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801044c5:	8b 45 08             	mov    0x8(%ebp),%eax
801044c8:	83 ec 0c             	sub    $0xc,%esp
801044cb:	50                   	push   %eax
801044cc:	e8 01 1d 00 00       	call   801061d2 <release>
801044d1:	83 c4 10             	add    $0x10,%esp
  return i;
801044d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801044d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044da:	c9                   	leave  
801044db:	c3                   	ret    

801044dc <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801044dc:	55                   	push   %ebp
801044dd:	89 e5                	mov    %esp,%ebp
801044df:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801044e2:	9c                   	pushf  
801044e3:	58                   	pop    %eax
801044e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801044e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801044ea:	c9                   	leave  
801044eb:	c3                   	ret    

801044ec <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
801044ec:	55                   	push   %ebp
801044ed:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801044ef:	fb                   	sti    
}
801044f0:	90                   	nop
801044f1:	5d                   	pop    %ebp
801044f2:	c3                   	ret    

801044f3 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
801044f3:	55                   	push   %ebp
801044f4:	89 e5                	mov    %esp,%ebp
801044f6:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
801044f9:	83 ec 08             	sub    $0x8,%esp
801044fc:	68 8c 9b 10 80       	push   $0x80109b8c
80104501:	68 80 49 11 80       	push   $0x80114980
80104506:	e8 3e 1c 00 00       	call   80106149 <initlock>
8010450b:	83 c4 10             	add    $0x10,%esp
}
8010450e:	90                   	nop
8010450f:	c9                   	leave  
80104510:	c3                   	ret    

80104511 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104511:	55                   	push   %ebp
80104512:	89 e5                	mov    %esp,%ebp
80104514:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80104517:	83 ec 0c             	sub    $0xc,%esp
8010451a:	68 80 49 11 80       	push   $0x80114980
8010451f:	e8 47 1c 00 00       	call   8010616b <acquire>
80104524:	83 c4 10             	add    $0x10,%esp
  #ifdef CS333_P3P4
  p = removeFromQueue(&ptable.pLists.free);
80104527:	83 ec 0c             	sub    $0xc,%esp
8010452a:	68 cc 70 11 80       	push   $0x801170cc
8010452f:	e8 8f 15 00 00       	call   80105ac3 <removeFromQueue>
80104534:	83 c4 10             	add    $0x10,%esp
80104537:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p)
8010453a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010453e:	75 1a                	jne    8010455a <allocproc+0x49>
  #else
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
  #endif
  release(&ptable.lock);
80104540:	83 ec 0c             	sub    $0xc,%esp
80104543:	68 80 49 11 80       	push   $0x80114980
80104548:	e8 85 1c 00 00       	call   801061d2 <release>
8010454d:	83 c4 10             	add    $0x10,%esp
  return 0;
80104550:	b8 00 00 00 00       	mov    $0x0,%eax
80104555:	e9 14 01 00 00       	jmp    8010466e <allocproc+0x15d>

  acquire(&ptable.lock);
  #ifdef CS333_P3P4
  p = removeFromQueue(&ptable.pLists.free);
  if(p)
    goto found;
8010455a:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  #ifdef CS333_P3P4
  assertState(p, UNUSED);
8010455b:	83 ec 08             	sub    $0x8,%esp
8010455e:	6a 00                	push   $0x0
80104560:	ff 75 f4             	pushl  -0xc(%ebp)
80104563:	e8 9b 15 00 00       	call   80105b03 <assertState>
80104568:	83 c4 10             	add    $0x10,%esp
  p->state = EMBRYO;
8010456b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010456e:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  addToListFront(&ptable.pLists.embryo, p);
80104575:	83 ec 08             	sub    $0x8,%esp
80104578:	ff 75 f4             	pushl  -0xc(%ebp)
8010457b:	68 dc 70 11 80       	push   $0x801170dc
80104580:	e8 f3 13 00 00       	call   80105978 <addToListFront>
80104585:	83 c4 10             	add    $0x10,%esp
  #else
  p->state = EMBRYO;
  #endif
  p->pid = nextpid++;
80104588:	a1 04 d0 10 80       	mov    0x8010d004,%eax
8010458d:	8d 50 01             	lea    0x1(%eax),%edx
80104590:	89 15 04 d0 10 80    	mov    %edx,0x8010d004
80104596:	89 c2                	mov    %eax,%edx
80104598:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010459b:	89 50 10             	mov    %edx,0x10(%eax)
  release(&ptable.lock);
8010459e:	83 ec 0c             	sub    $0xc,%esp
801045a1:	68 80 49 11 80       	push   $0x80114980
801045a6:	e8 27 1c 00 00       	call   801061d2 <release>
801045ab:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801045ae:	e8 51 e7 ff ff       	call   80102d04 <kalloc>
801045b3:	89 c2                	mov    %eax,%edx
801045b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045b8:	89 50 08             	mov    %edx,0x8(%eax)
801045bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045be:	8b 40 08             	mov    0x8(%eax),%eax
801045c1:	85 c0                	test   %eax,%eax
801045c3:	75 26                	jne    801045eb <allocproc+0xda>
    #ifdef CS333_P3P4
    switchStates(&ptable.pLists.embryo, &ptable.pLists.free, p,
801045c5:	83 ec 0c             	sub    $0xc,%esp
801045c8:	6a 00                	push   $0x0
801045ca:	6a 01                	push   $0x1
801045cc:	ff 75 f4             	pushl  -0xc(%ebp)
801045cf:	68 cc 70 11 80       	push   $0x801170cc
801045d4:	68 dc 70 11 80       	push   $0x801170dc
801045d9:	e8 62 15 00 00       	call   80105b40 <switchStates>
801045de:	83 c4 20             	add    $0x20,%esp
        EMBRYO, UNUSED);
    #else
    p->state = UNUSED;
    #endif
    return 0;
801045e1:	b8 00 00 00 00       	mov    $0x0,%eax
801045e6:	e9 83 00 00 00       	jmp    8010466e <allocproc+0x15d>
  }
  sp = p->kstack + KSTACKSIZE;
801045eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045ee:	8b 40 08             	mov    0x8(%eax),%eax
801045f1:	05 00 10 00 00       	add    $0x1000,%eax
801045f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801045f9:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
801045fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104600:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104603:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80104606:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
8010460a:	ba 5b 79 10 80       	mov    $0x8010795b,%edx
8010460f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104612:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80104614:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80104618:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010461b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010461e:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
80104621:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104624:	8b 40 1c             	mov    0x1c(%eax),%eax
80104627:	83 ec 04             	sub    $0x4,%esp
8010462a:	6a 14                	push   $0x14
8010462c:	6a 00                	push   $0x0
8010462e:	50                   	push   %eax
8010462f:	e8 9a 1d 00 00       	call   801063ce <memset>
80104634:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80104637:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010463a:	8b 40 1c             	mov    0x1c(%eax),%eax
8010463d:	ba bc 51 10 80       	mov    $0x801051bc,%edx
80104642:	89 50 10             	mov    %edx,0x10(%eax)

  #ifdef CS333_P1
  p->start_ticks = ticks;
80104645:	8b 15 00 79 11 80    	mov    0x80117900,%edx
8010464b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010464e:	89 50 7c             	mov    %edx,0x7c(%eax)
  #endif
  #ifdef CS333_P2
  p->cpu_ticks_total = 0;
80104651:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104654:	c7 80 88 00 00 00 00 	movl   $0x0,0x88(%eax)
8010465b:	00 00 00 
  p->cpu_ticks_in = 0;
8010465e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104661:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80104668:	00 00 00 
  #endif

  return p;
8010466b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010466e:	c9                   	leave  
8010466f:	c3                   	ret    

80104670 <userinit>:

// Set up first user process.
void
userinit(void)
{
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  #ifdef CS333_P3P4
  ptable.PromoteAtTime = TICKS_TO_PROMOTE;
80104676:	c7 05 e0 70 11 80 64 	movl   $0x64,0x801170e0
8010467d:	00 00 00 
  
  for(int i = 0; i <= MAX; i++){
80104680:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104687:	eb 17                	jmp    801046a0 <userinit+0x30>
    ptable.pLists.ready[i] = 0;
80104689:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010468c:	05 cc 09 00 00       	add    $0x9cc,%eax
80104691:	c7 04 85 84 49 11 80 	movl   $0x0,-0x7feeb67c(,%eax,4)
80104698:	00 00 00 00 
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  #ifdef CS333_P3P4
  ptable.PromoteAtTime = TICKS_TO_PROMOTE;
  
  for(int i = 0; i <= MAX; i++){
8010469c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801046a0:	83 7d f4 05          	cmpl   $0x5,-0xc(%ebp)
801046a4:	7e e3                	jle    80104689 <userinit+0x19>
    ptable.pLists.ready[i] = 0;
  }
  ptable.pLists.free = 0;
801046a6:	c7 05 cc 70 11 80 00 	movl   $0x0,0x801170cc
801046ad:	00 00 00 
  ptable.pLists.sleep = 0;
801046b0:	c7 05 d0 70 11 80 00 	movl   $0x0,0x801170d0
801046b7:	00 00 00 
  ptable.pLists.zombie = 0;
801046ba:	c7 05 d4 70 11 80 00 	movl   $0x0,0x801170d4
801046c1:	00 00 00 
  ptable.pLists.running = 0;
801046c4:	c7 05 d8 70 11 80 00 	movl   $0x0,0x801170d8
801046cb:	00 00 00 
  ptable.pLists.embryo = 0;
801046ce:	c7 05 dc 70 11 80 00 	movl   $0x0,0x801170dc
801046d5:	00 00 00 

  for(int i = 0; i < NPROC; i++){
801046d8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801046df:	eb 29                	jmp    8010470a <userinit+0x9a>
    addToListFront(&ptable.pLists.free, &ptable.proc[i]);
801046e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801046e4:	69 c0 9c 00 00 00    	imul   $0x9c,%eax,%eax
801046ea:	83 c0 30             	add    $0x30,%eax
801046ed:	05 80 49 11 80       	add    $0x80114980,%eax
801046f2:	83 c0 04             	add    $0x4,%eax
801046f5:	83 ec 08             	sub    $0x8,%esp
801046f8:	50                   	push   %eax
801046f9:	68 cc 70 11 80       	push   $0x801170cc
801046fe:	e8 75 12 00 00       	call   80105978 <addToListFront>
80104703:	83 c4 10             	add    $0x10,%esp
  ptable.pLists.sleep = 0;
  ptable.pLists.zombie = 0;
  ptable.pLists.running = 0;
  ptable.pLists.embryo = 0;

  for(int i = 0; i < NPROC; i++){
80104706:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010470a:	83 7d f0 3f          	cmpl   $0x3f,-0x10(%ebp)
8010470e:	7e d1                	jle    801046e1 <userinit+0x71>
    addToListFront(&ptable.pLists.free, &ptable.proc[i]);
  }
  #endif
  
  p = allocproc();
80104710:	e8 fc fd ff ff       	call   80104511 <allocproc>
80104715:	89 45 ec             	mov    %eax,-0x14(%ebp)
  initproc = p;
80104718:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010471b:	a3 68 d6 10 80       	mov    %eax,0x8010d668
  if((p->pgdir = setupkvm()) == 0)
80104720:	e8 f8 48 00 00       	call   8010901d <setupkvm>
80104725:	89 c2                	mov    %eax,%edx
80104727:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010472a:	89 50 04             	mov    %edx,0x4(%eax)
8010472d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104730:	8b 40 04             	mov    0x4(%eax),%eax
80104733:	85 c0                	test   %eax,%eax
80104735:	75 0d                	jne    80104744 <userinit+0xd4>
    panic("userinit: out of memory?");
80104737:	83 ec 0c             	sub    $0xc,%esp
8010473a:	68 93 9b 10 80       	push   $0x80109b93
8010473f:	e8 22 be ff ff       	call   80100566 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104744:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104749:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010474c:	8b 40 04             	mov    0x4(%eax),%eax
8010474f:	83 ec 04             	sub    $0x4,%esp
80104752:	52                   	push   %edx
80104753:	68 00 d5 10 80       	push   $0x8010d500
80104758:	50                   	push   %eax
80104759:	e8 19 4b 00 00       	call   80109277 <inituvm>
8010475e:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
80104761:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104764:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
8010476a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010476d:	8b 40 18             	mov    0x18(%eax),%eax
80104770:	83 ec 04             	sub    $0x4,%esp
80104773:	6a 4c                	push   $0x4c
80104775:	6a 00                	push   $0x0
80104777:	50                   	push   %eax
80104778:	e8 51 1c 00 00       	call   801063ce <memset>
8010477d:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104780:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104783:	8b 40 18             	mov    0x18(%eax),%eax
80104786:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010478c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010478f:	8b 40 18             	mov    0x18(%eax),%eax
80104792:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104798:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010479b:	8b 40 18             	mov    0x18(%eax),%eax
8010479e:	8b 55 ec             	mov    -0x14(%ebp),%edx
801047a1:	8b 52 18             	mov    0x18(%edx),%edx
801047a4:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801047a8:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801047ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047af:	8b 40 18             	mov    0x18(%eax),%eax
801047b2:	8b 55 ec             	mov    -0x14(%ebp),%edx
801047b5:	8b 52 18             	mov    0x18(%edx),%edx
801047b8:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801047bc:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801047c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047c3:	8b 40 18             	mov    0x18(%eax),%eax
801047c6:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801047cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047d0:	8b 40 18             	mov    0x18(%eax),%eax
801047d3:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801047da:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047dd:	8b 40 18             	mov    0x18(%eax),%eax
801047e0:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801047e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047ea:	83 c0 6c             	add    $0x6c,%eax
801047ed:	83 ec 04             	sub    $0x4,%esp
801047f0:	6a 10                	push   $0x10
801047f2:	68 ac 9b 10 80       	push   $0x80109bac
801047f7:	50                   	push   %eax
801047f8:	e8 d4 1d 00 00       	call   801065d1 <safestrcpy>
801047fd:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
80104800:	83 ec 0c             	sub    $0xc,%esp
80104803:	68 b5 9b 10 80       	push   $0x80109bb5
80104808:	e8 b9 dd ff ff       	call   801025c6 <namei>
8010480d:	83 c4 10             	add    $0x10,%esp
80104810:	89 c2                	mov    %eax,%edx
80104812:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104815:	89 50 68             	mov    %edx,0x68(%eax)

  #ifdef CS333_P2
  p->uid = DEFAULTUID;
80104818:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010481b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80104822:	00 00 00 
  p->gid = DEFAULTGID;
80104825:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104828:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
8010482f:	00 00 00 
  #endif
  #ifdef CS333_P3P4
  p->priority = 0;
80104832:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104835:	c7 80 94 00 00 00 00 	movl   $0x0,0x94(%eax)
8010483c:	00 00 00 
  p->budget = 50;
8010483f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104842:	c7 80 98 00 00 00 32 	movl   $0x32,0x98(%eax)
80104849:	00 00 00 
  switchToRunnable(&ptable.pLists.embryo, p, EMBRYO);
8010484c:	83 ec 04             	sub    $0x4,%esp
8010484f:	6a 01                	push   $0x1
80104851:	ff 75 ec             	pushl  -0x14(%ebp)
80104854:	68 dc 70 11 80       	push   $0x801170dc
80104859:	e8 27 13 00 00       	call   80105b85 <switchToRunnable>
8010485e:	83 c4 10             	add    $0x10,%esp
  #else
  p->state = RUNNABLE;
  #endif
}
80104861:	90                   	nop
80104862:	c9                   	leave  
80104863:	c3                   	ret    

80104864 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104864:	55                   	push   %ebp
80104865:	89 e5                	mov    %esp,%ebp
80104867:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  
  sz = proc->sz;
8010486a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104870:	8b 00                	mov    (%eax),%eax
80104872:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104875:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104879:	7e 31                	jle    801048ac <growproc+0x48>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
8010487b:	8b 55 08             	mov    0x8(%ebp),%edx
8010487e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104881:	01 c2                	add    %eax,%edx
80104883:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104889:	8b 40 04             	mov    0x4(%eax),%eax
8010488c:	83 ec 04             	sub    $0x4,%esp
8010488f:	52                   	push   %edx
80104890:	ff 75 f4             	pushl  -0xc(%ebp)
80104893:	50                   	push   %eax
80104894:	e8 2b 4b 00 00       	call   801093c4 <allocuvm>
80104899:	83 c4 10             	add    $0x10,%esp
8010489c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010489f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801048a3:	75 3e                	jne    801048e3 <growproc+0x7f>
      return -1;
801048a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048aa:	eb 59                	jmp    80104905 <growproc+0xa1>
  } else if(n < 0){
801048ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801048b0:	79 31                	jns    801048e3 <growproc+0x7f>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
801048b2:	8b 55 08             	mov    0x8(%ebp),%edx
801048b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048b8:	01 c2                	add    %eax,%edx
801048ba:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048c0:	8b 40 04             	mov    0x4(%eax),%eax
801048c3:	83 ec 04             	sub    $0x4,%esp
801048c6:	52                   	push   %edx
801048c7:	ff 75 f4             	pushl  -0xc(%ebp)
801048ca:	50                   	push   %eax
801048cb:	e8 bd 4b 00 00       	call   8010948d <deallocuvm>
801048d0:	83 c4 10             	add    $0x10,%esp
801048d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801048d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801048da:	75 07                	jne    801048e3 <growproc+0x7f>
      return -1;
801048dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048e1:	eb 22                	jmp    80104905 <growproc+0xa1>
  }
  proc->sz = sz;
801048e3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801048ec:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
801048ee:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048f4:	83 ec 0c             	sub    $0xc,%esp
801048f7:	50                   	push   %eax
801048f8:	e8 07 48 00 00       	call   80109104 <switchuvm>
801048fd:	83 c4 10             	add    $0x10,%esp
  return 0;
80104900:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104905:	c9                   	leave  
80104906:	c3                   	ret    

80104907 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104907:	55                   	push   %ebp
80104908:	89 e5                	mov    %esp,%ebp
8010490a:	57                   	push   %edi
8010490b:	56                   	push   %esi
8010490c:	53                   	push   %ebx
8010490d:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
80104910:	e8 fc fb ff ff       	call   80104511 <allocproc>
80104915:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104918:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010491c:	75 0a                	jne    80104928 <fork+0x21>
    return -1;
8010491e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104923:	e9 c9 01 00 00       	jmp    80104af1 <fork+0x1ea>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104928:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010492e:	8b 10                	mov    (%eax),%edx
80104930:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104936:	8b 40 04             	mov    0x4(%eax),%eax
80104939:	83 ec 08             	sub    $0x8,%esp
8010493c:	52                   	push   %edx
8010493d:	50                   	push   %eax
8010493e:	e8 e8 4c 00 00       	call   8010962b <copyuvm>
80104943:	83 c4 10             	add    $0x10,%esp
80104946:	89 c2                	mov    %eax,%edx
80104948:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010494b:	89 50 04             	mov    %edx,0x4(%eax)
8010494e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104951:	8b 40 04             	mov    0x4(%eax),%eax
80104954:	85 c0                	test   %eax,%eax
80104956:	75 42                	jne    8010499a <fork+0x93>
    kfree(np->kstack);
80104958:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010495b:	8b 40 08             	mov    0x8(%eax),%eax
8010495e:	83 ec 0c             	sub    $0xc,%esp
80104961:	50                   	push   %eax
80104962:	e8 00 e3 ff ff       	call   80102c67 <kfree>
80104967:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
8010496a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010496d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    #ifdef CS333_P3P4
    switchStates(&ptable.pLists.embryo, &ptable.pLists.free, np,
80104974:	83 ec 0c             	sub    $0xc,%esp
80104977:	6a 00                	push   $0x0
80104979:	6a 01                	push   $0x1
8010497b:	ff 75 e0             	pushl  -0x20(%ebp)
8010497e:	68 cc 70 11 80       	push   $0x801170cc
80104983:	68 dc 70 11 80       	push   $0x801170dc
80104988:	e8 b3 11 00 00       	call   80105b40 <switchStates>
8010498d:	83 c4 20             	add    $0x20,%esp
        EMBRYO, UNUSED);
    #else
    np->state = UNUSED;
    #endif
    return -1;
80104990:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104995:	e9 57 01 00 00       	jmp    80104af1 <fork+0x1ea>
  }
  np->sz = proc->sz;
8010499a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049a0:	8b 10                	mov    (%eax),%edx
801049a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049a5:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
801049a7:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801049ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049b1:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
801049b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049b7:	8b 50 18             	mov    0x18(%eax),%edx
801049ba:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049c0:	8b 40 18             	mov    0x18(%eax),%eax
801049c3:	89 c3                	mov    %eax,%ebx
801049c5:	b8 13 00 00 00       	mov    $0x13,%eax
801049ca:	89 d7                	mov    %edx,%edi
801049cc:	89 de                	mov    %ebx,%esi
801049ce:	89 c1                	mov    %eax,%ecx
801049d0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  #ifdef CS333_P2
  np->uid = proc->uid;
801049d2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049d8:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
801049de:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049e1:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  np->gid = proc->gid;
801049e7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049ed:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
801049f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049f6:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
  #endif

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801049fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049ff:	8b 40 18             	mov    0x18(%eax),%eax
80104a02:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104a09:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104a10:	eb 43                	jmp    80104a55 <fork+0x14e>
    if(proc->ofile[i])
80104a12:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a18:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104a1b:	83 c2 08             	add    $0x8,%edx
80104a1e:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104a22:	85 c0                	test   %eax,%eax
80104a24:	74 2b                	je     80104a51 <fork+0x14a>
      np->ofile[i] = filedup(proc->ofile[i]);
80104a26:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a2c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104a2f:	83 c2 08             	add    $0x8,%edx
80104a32:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104a36:	83 ec 0c             	sub    $0xc,%esp
80104a39:	50                   	push   %eax
80104a3a:	e8 5f c6 ff ff       	call   8010109e <filedup>
80104a3f:	83 c4 10             	add    $0x10,%esp
80104a42:	89 c1                	mov    %eax,%ecx
80104a44:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a47:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104a4a:	83 c2 08             	add    $0x8,%edx
80104a4d:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  #endif

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104a51:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104a55:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104a59:	7e b7                	jle    80104a12 <fork+0x10b>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80104a5b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a61:	8b 40 68             	mov    0x68(%eax),%eax
80104a64:	83 ec 0c             	sub    $0xc,%esp
80104a67:	50                   	push   %eax
80104a68:	e8 61 cf ff ff       	call   801019ce <idup>
80104a6d:	83 c4 10             	add    $0x10,%esp
80104a70:	89 c2                	mov    %eax,%edx
80104a72:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a75:	89 50 68             	mov    %edx,0x68(%eax)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104a78:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a7e:	8d 50 6c             	lea    0x6c(%eax),%edx
80104a81:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a84:	83 c0 6c             	add    $0x6c,%eax
80104a87:	83 ec 04             	sub    $0x4,%esp
80104a8a:	6a 10                	push   $0x10
80104a8c:	52                   	push   %edx
80104a8d:	50                   	push   %eax
80104a8e:	e8 3e 1b 00 00       	call   801065d1 <safestrcpy>
80104a93:	83 c4 10             	add    $0x10,%esp
 
  pid = np->pid;
80104a96:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a99:	8b 40 10             	mov    0x10(%eax),%eax
80104a9c:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
80104a9f:	83 ec 0c             	sub    $0xc,%esp
80104aa2:	68 80 49 11 80       	push   $0x80114980
80104aa7:	e8 bf 16 00 00       	call   8010616b <acquire>
80104aac:	83 c4 10             	add    $0x10,%esp
  #ifdef CS333_P3P4
  np->priority = 0;
80104aaf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ab2:	c7 80 94 00 00 00 00 	movl   $0x0,0x94(%eax)
80104ab9:	00 00 00 
  np->budget = 50;
80104abc:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104abf:	c7 80 98 00 00 00 32 	movl   $0x32,0x98(%eax)
80104ac6:	00 00 00 
  switchToRunnable(&ptable.pLists.embryo, np, EMBRYO);
80104ac9:	83 ec 04             	sub    $0x4,%esp
80104acc:	6a 01                	push   $0x1
80104ace:	ff 75 e0             	pushl  -0x20(%ebp)
80104ad1:	68 dc 70 11 80       	push   $0x801170dc
80104ad6:	e8 aa 10 00 00       	call   80105b85 <switchToRunnable>
80104adb:	83 c4 10             	add    $0x10,%esp
  #else
  np->state = RUNNABLE;
  #endif
  release(&ptable.lock);
80104ade:	83 ec 0c             	sub    $0xc,%esp
80104ae1:	68 80 49 11 80       	push   $0x80114980
80104ae6:	e8 e7 16 00 00       	call   801061d2 <release>
80104aeb:	83 c4 10             	add    $0x10,%esp
  
  return pid;
80104aee:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104af1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104af4:	5b                   	pop    %ebx
80104af5:	5e                   	pop    %esi
80104af6:	5f                   	pop    %edi
80104af7:	5d                   	pop    %ebp
80104af8:	c3                   	ret    

80104af9 <exit>:
  panic("zombie exit");
}
#else
void
exit(void)
{
80104af9:	55                   	push   %ebp
80104afa:	89 e5                	mov    %esp,%ebp
80104afc:	83 ec 18             	sub    $0x18,%esp
  int fd;

  if(proc == initproc)
80104aff:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104b06:	a1 68 d6 10 80       	mov    0x8010d668,%eax
80104b0b:	39 c2                	cmp    %eax,%edx
80104b0d:	75 0d                	jne    80104b1c <exit+0x23>
    panic("init exiting");
80104b0f:	83 ec 0c             	sub    $0xc,%esp
80104b12:	68 b7 9b 10 80       	push   $0x80109bb7
80104b17:	e8 4a ba ff ff       	call   80100566 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104b1c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104b23:	eb 48                	jmp    80104b6d <exit+0x74>
    if(proc->ofile[fd]){
80104b25:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104b2e:	83 c2 08             	add    $0x8,%edx
80104b31:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104b35:	85 c0                	test   %eax,%eax
80104b37:	74 30                	je     80104b69 <exit+0x70>
      fileclose(proc->ofile[fd]);
80104b39:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104b42:	83 c2 08             	add    $0x8,%edx
80104b45:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104b49:	83 ec 0c             	sub    $0xc,%esp
80104b4c:	50                   	push   %eax
80104b4d:	e8 9d c5 ff ff       	call   801010ef <fileclose>
80104b52:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
80104b55:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104b5e:	83 c2 08             	add    $0x8,%edx
80104b61:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104b68:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104b69:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104b6d:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104b71:	7e b2                	jle    80104b25 <exit+0x2c>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80104b73:	e8 73 ea ff ff       	call   801035eb <begin_op>
  iput(proc->cwd);
80104b78:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b7e:	8b 40 68             	mov    0x68(%eax),%eax
80104b81:	83 ec 0c             	sub    $0xc,%esp
80104b84:	50                   	push   %eax
80104b85:	e8 4e d0 ff ff       	call   80101bd8 <iput>
80104b8a:	83 c4 10             	add    $0x10,%esp
  end_op();
80104b8d:	e8 e5 ea ff ff       	call   80103677 <end_op>
  proc->cwd = 0;
80104b92:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b98:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104b9f:	83 ec 0c             	sub    $0xc,%esp
80104ba2:	68 80 49 11 80       	push   $0x80114980
80104ba7:	e8 bf 15 00 00       	call   8010616b <acquire>
80104bac:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104baf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bb5:	8b 40 14             	mov    0x14(%eax),%eax
80104bb8:	83 ec 0c             	sub    $0xc,%esp
80104bbb:	50                   	push   %eax
80104bbc:	e8 89 07 00 00       	call   8010534a <wakeup1>
80104bc1:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  passChildrenToInit(&ptable.pLists.embryo, proc);
80104bc4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bca:	83 ec 08             	sub    $0x8,%esp
80104bcd:	50                   	push   %eax
80104bce:	68 dc 70 11 80       	push   $0x801170dc
80104bd3:	e8 0a 10 00 00       	call   80105be2 <passChildrenToInit>
80104bd8:	83 c4 10             	add    $0x10,%esp
  for(int i = 0; i <= MAX; i++){
80104bdb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104be2:	eb 2c                	jmp    80104c10 <exit+0x117>
    passChildrenToInit(&ptable.pLists.ready[i], proc);
80104be4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bea:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104bed:	81 c2 cc 09 00 00    	add    $0x9cc,%edx
80104bf3:	c1 e2 02             	shl    $0x2,%edx
80104bf6:	81 c2 80 49 11 80    	add    $0x80114980,%edx
80104bfc:	83 c2 04             	add    $0x4,%edx
80104bff:	83 ec 08             	sub    $0x8,%esp
80104c02:	50                   	push   %eax
80104c03:	52                   	push   %edx
80104c04:	e8 d9 0f 00 00       	call   80105be2 <passChildrenToInit>
80104c09:	83 c4 10             	add    $0x10,%esp
  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  passChildrenToInit(&ptable.pLists.embryo, proc);
  for(int i = 0; i <= MAX; i++){
80104c0c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104c10:	83 7d f0 05          	cmpl   $0x5,-0x10(%ebp)
80104c14:	7e ce                	jle    80104be4 <exit+0xeb>
    passChildrenToInit(&ptable.pLists.ready[i], proc);
  }
  passChildrenToInit(&ptable.pLists.running, proc);
80104c16:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c1c:	83 ec 08             	sub    $0x8,%esp
80104c1f:	50                   	push   %eax
80104c20:	68 d8 70 11 80       	push   $0x801170d8
80104c25:	e8 b8 0f 00 00       	call   80105be2 <passChildrenToInit>
80104c2a:	83 c4 10             	add    $0x10,%esp
  passChildrenToInit(&ptable.pLists.sleep, proc);
80104c2d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c33:	83 ec 08             	sub    $0x8,%esp
80104c36:	50                   	push   %eax
80104c37:	68 d0 70 11 80       	push   $0x801170d0
80104c3c:	e8 a1 0f 00 00       	call   80105be2 <passChildrenToInit>
80104c41:	83 c4 10             	add    $0x10,%esp
  passChildrenToInit(&ptable.pLists.zombie, proc);
80104c44:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c4a:	83 ec 08             	sub    $0x8,%esp
80104c4d:	50                   	push   %eax
80104c4e:	68 d4 70 11 80       	push   $0x801170d4
80104c53:	e8 8a 0f 00 00       	call   80105be2 <passChildrenToInit>
80104c58:	83 c4 10             	add    $0x10,%esp

  // Jump into the scheduler, never to return.
  switchStates(&ptable.pLists.running, &ptable.pLists.zombie, proc, RUNNING,
80104c5b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c61:	83 ec 0c             	sub    $0xc,%esp
80104c64:	6a 05                	push   $0x5
80104c66:	6a 04                	push   $0x4
80104c68:	50                   	push   %eax
80104c69:	68 d4 70 11 80       	push   $0x801170d4
80104c6e:	68 d8 70 11 80       	push   $0x801170d8
80104c73:	e8 c8 0e 00 00       	call   80105b40 <switchStates>
80104c78:	83 c4 20             	add    $0x20,%esp
      ZOMBIE);
  sched();
80104c7b:	e8 73 03 00 00       	call   80104ff3 <sched>
  panic("zombie exit");
80104c80:	83 ec 0c             	sub    $0xc,%esp
80104c83:	68 c4 9b 10 80       	push   $0x80109bc4
80104c88:	e8 d9 b8 ff ff       	call   80100566 <panic>

80104c8d <wait>:
  }
}
#else
int
wait(void)
{
80104c8d:	55                   	push   %ebp
80104c8e:	89 e5                	mov    %esp,%ebp
80104c90:	83 ec 18             	sub    $0x18,%esp
  struct proc *p = 0;
80104c93:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  int havekids, pid;

  acquire(&ptable.lock);
80104c9a:	83 ec 0c             	sub    $0xc,%esp
80104c9d:	68 80 49 11 80       	push   $0x80114980
80104ca2:	e8 c4 14 00 00       	call   8010616b <acquire>
80104ca7:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104caa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    p = findChildren(&ptable.pLists.zombie, proc);
80104cb1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cb7:	83 ec 08             	sub    $0x8,%esp
80104cba:	50                   	push   %eax
80104cbb:	68 d4 70 11 80       	push   $0x801170d4
80104cc0:	e8 73 0f 00 00       	call   80105c38 <findChildren>
80104cc5:	83 c4 10             	add    $0x10,%esp
80104cc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p){
80104ccb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104ccf:	0f 84 90 00 00 00    	je     80104d65 <wait+0xd8>
      pid = p->pid;
80104cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cd8:	8b 40 10             	mov    0x10(%eax),%eax
80104cdb:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(p->kstack);
80104cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ce1:	8b 40 08             	mov    0x8(%eax),%eax
80104ce4:	83 ec 0c             	sub    $0xc,%esp
80104ce7:	50                   	push   %eax
80104ce8:	e8 7a df ff ff       	call   80102c67 <kfree>
80104ced:	83 c4 10             	add    $0x10,%esp
      p->kstack = 0;
80104cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cf3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
      freevm(p->pgdir);
80104cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cfd:	8b 40 04             	mov    0x4(%eax),%eax
80104d00:	83 ec 0c             	sub    $0xc,%esp
80104d03:	50                   	push   %eax
80104d04:	e8 41 48 00 00       	call   8010954a <freevm>
80104d09:	83 c4 10             	add    $0x10,%esp
      switchStates(&ptable.pLists.zombie, &ptable.pLists.free, p,
80104d0c:	83 ec 0c             	sub    $0xc,%esp
80104d0f:	6a 00                	push   $0x0
80104d11:	6a 05                	push   $0x5
80104d13:	ff 75 f4             	pushl  -0xc(%ebp)
80104d16:	68 cc 70 11 80       	push   $0x801170cc
80104d1b:	68 d4 70 11 80       	push   $0x801170d4
80104d20:	e8 1b 0e 00 00       	call   80105b40 <switchStates>
80104d25:	83 c4 20             	add    $0x20,%esp
          ZOMBIE, UNUSED);
      p->pid = 0;
80104d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d2b:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
      p->parent = 0;
80104d32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d35:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
      p->name[0] = 0;
80104d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d3f:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
      p->killed = 0;
80104d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d46:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
      release(&ptable.lock);
80104d4d:	83 ec 0c             	sub    $0xc,%esp
80104d50:	68 80 49 11 80       	push   $0x80114980
80104d55:	e8 78 14 00 00       	call   801061d2 <release>
80104d5a:	83 c4 10             	add    $0x10,%esp
      return pid;
80104d5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104d60:	e9 f7 00 00 00       	jmp    80104e5c <wait+0x1cf>
    }
    else{
      p = findChildren(&ptable.pLists.embryo, proc);
80104d65:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d6b:	83 ec 08             	sub    $0x8,%esp
80104d6e:	50                   	push   %eax
80104d6f:	68 dc 70 11 80       	push   $0x801170dc
80104d74:	e8 bf 0e 00 00       	call   80105c38 <findChildren>
80104d79:	83 c4 10             	add    $0x10,%esp
80104d7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
      if(!p){
80104d7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104d83:	75 44                	jne    80104dc9 <wait+0x13c>
        for(int i = 0; i <= MAX; i++){
80104d85:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80104d8c:	eb 35                	jmp    80104dc3 <wait+0x136>
          if(!p)
80104d8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104d92:	75 2b                	jne    80104dbf <wait+0x132>
            p = findChildren(&ptable.pLists.ready[i], proc);
80104d94:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d9a:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104d9d:	81 c2 cc 09 00 00    	add    $0x9cc,%edx
80104da3:	c1 e2 02             	shl    $0x2,%edx
80104da6:	81 c2 80 49 11 80    	add    $0x80114980,%edx
80104dac:	83 c2 04             	add    $0x4,%edx
80104daf:	83 ec 08             	sub    $0x8,%esp
80104db2:	50                   	push   %eax
80104db3:	52                   	push   %edx
80104db4:	e8 7f 0e 00 00       	call   80105c38 <findChildren>
80104db9:	83 c4 10             	add    $0x10,%esp
80104dbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return pid;
    }
    else{
      p = findChildren(&ptable.pLists.embryo, proc);
      if(!p){
        for(int i = 0; i <= MAX; i++){
80104dbf:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80104dc3:	83 7d ec 05          	cmpl   $0x5,-0x14(%ebp)
80104dc7:	7e c5                	jle    80104d8e <wait+0x101>
          if(!p)
            p = findChildren(&ptable.pLists.ready[i], proc);
        }
      }
      if(!p)
80104dc9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104dcd:	75 1a                	jne    80104de9 <wait+0x15c>
        p = findChildren(&ptable.pLists.sleep, proc);
80104dcf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104dd5:	83 ec 08             	sub    $0x8,%esp
80104dd8:	50                   	push   %eax
80104dd9:	68 d0 70 11 80       	push   $0x801170d0
80104dde:	e8 55 0e 00 00       	call   80105c38 <findChildren>
80104de3:	83 c4 10             	add    $0x10,%esp
80104de6:	89 45 f4             	mov    %eax,-0xc(%ebp)
      if(!p)
80104de9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104ded:	75 1a                	jne    80104e09 <wait+0x17c>
        p = findChildren(&ptable.pLists.running, proc);
80104def:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104df5:	83 ec 08             	sub    $0x8,%esp
80104df8:	50                   	push   %eax
80104df9:	68 d8 70 11 80       	push   $0x801170d8
80104dfe:	e8 35 0e 00 00       	call   80105c38 <findChildren>
80104e03:	83 c4 10             	add    $0x10,%esp
80104e06:	89 45 f4             	mov    %eax,-0xc(%ebp)
      if(p)
80104e09:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104e0d:	74 07                	je     80104e16 <wait+0x189>
        havekids = 1;
80104e0f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104e16:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104e1a:	74 0d                	je     80104e29 <wait+0x19c>
80104e1c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e22:	8b 40 24             	mov    0x24(%eax),%eax
80104e25:	85 c0                	test   %eax,%eax
80104e27:	74 17                	je     80104e40 <wait+0x1b3>
      release(&ptable.lock);
80104e29:	83 ec 0c             	sub    $0xc,%esp
80104e2c:	68 80 49 11 80       	push   $0x80114980
80104e31:	e8 9c 13 00 00       	call   801061d2 <release>
80104e36:	83 c4 10             	add    $0x10,%esp
      return -1;
80104e39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e3e:	eb 1c                	jmp    80104e5c <wait+0x1cf>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104e40:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e46:	83 ec 08             	sub    $0x8,%esp
80104e49:	68 80 49 11 80       	push   $0x80114980
80104e4e:	50                   	push   %eax
80104e4f:	e8 ae 03 00 00       	call   80105202 <sleep>
80104e54:	83 c4 10             	add    $0x10,%esp
  }
80104e57:	e9 4e fe ff ff       	jmp    80104caa <wait+0x1d>
}
80104e5c:	c9                   	leave  
80104e5d:	c3                   	ret    

80104e5e <scheduler>:
  }
}
#else
void
scheduler(void)
{
80104e5e:	55                   	push   %ebp
80104e5f:	89 e5                	mov    %esp,%ebp
80104e61:	83 ec 18             	sub    $0x18,%esp
  int idle;  // for checking if processor is idle
  int index;

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104e64:	e8 83 f6 ff ff       	call   801044ec <sti>

    idle = 1;  // assume idle unless we schedule a process
80104e69:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
    acquire(&ptable.lock);
80104e70:	83 ec 0c             	sub    $0xc,%esp
80104e73:	68 80 49 11 80       	push   $0x80114980
80104e78:	e8 ee 12 00 00       	call   8010616b <acquire>
80104e7d:	83 c4 10             	add    $0x10,%esp

    if(ptable.PromoteAtTime < ticks){
80104e80:	8b 15 e0 70 11 80    	mov    0x801170e0,%edx
80104e86:	a1 00 79 11 80       	mov    0x80117900,%eax
80104e8b:	39 c2                	cmp    %eax,%edx
80104e8d:	73 66                	jae    80104ef5 <scheduler+0x97>
      adjustPriority(&ptable.pLists.sleep, 0);
80104e8f:	83 ec 08             	sub    $0x8,%esp
80104e92:	6a 00                	push   $0x0
80104e94:	68 d0 70 11 80       	push   $0x801170d0
80104e99:	e8 4a 11 00 00       	call   80105fe8 <adjustPriority>
80104e9e:	83 c4 10             	add    $0x10,%esp
      adjustPriority(&ptable.pLists.running, 0);
80104ea1:	83 ec 08             	sub    $0x8,%esp
80104ea4:	6a 00                	push   $0x0
80104ea6:	68 d8 70 11 80       	push   $0x801170d8
80104eab:	e8 38 11 00 00       	call   80105fe8 <adjustPriority>
80104eb0:	83 c4 10             	add    $0x10,%esp
      for(int i = 1; i <= MAX; i++){
80104eb3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
80104eba:	eb 26                	jmp    80104ee2 <scheduler+0x84>
        adjustPriority(&ptable.pLists.ready[i], i);
80104ebc:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104ebf:	05 cc 09 00 00       	add    $0x9cc,%eax
80104ec4:	c1 e0 02             	shl    $0x2,%eax
80104ec7:	05 80 49 11 80       	add    $0x80114980,%eax
80104ecc:	83 c0 04             	add    $0x4,%eax
80104ecf:	83 ec 08             	sub    $0x8,%esp
80104ed2:	ff 75 ec             	pushl  -0x14(%ebp)
80104ed5:	50                   	push   %eax
80104ed6:	e8 0d 11 00 00       	call   80105fe8 <adjustPriority>
80104edb:	83 c4 10             	add    $0x10,%esp
    acquire(&ptable.lock);

    if(ptable.PromoteAtTime < ticks){
      adjustPriority(&ptable.pLists.sleep, 0);
      adjustPriority(&ptable.pLists.running, 0);
      for(int i = 1; i <= MAX; i++){
80104ede:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80104ee2:	83 7d ec 05          	cmpl   $0x5,-0x14(%ebp)
80104ee6:	7e d4                	jle    80104ebc <scheduler+0x5e>
        adjustPriority(&ptable.pLists.ready[i], i);
      }
      ptable.PromoteAtTime = ticks + TICKS_TO_PROMOTE;
80104ee8:	a1 00 79 11 80       	mov    0x80117900,%eax
80104eed:	83 c0 64             	add    $0x64,%eax
80104ef0:	a3 e0 70 11 80       	mov    %eax,0x801170e0
    }

    p = 0;
80104ef5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    index = 0;
80104efc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    while(ptable.pLists.ready[index] == 0 && index <= MAX){
80104f03:	eb 04                	jmp    80104f09 <scheduler+0xab>
      index++;
80104f05:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      ptable.PromoteAtTime = ticks + TICKS_TO_PROMOTE;
    }

    p = 0;
    index = 0;
    while(ptable.pLists.ready[index] == 0 && index <= MAX){
80104f09:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f0c:	05 cc 09 00 00       	add    $0x9cc,%eax
80104f11:	8b 04 85 84 49 11 80 	mov    -0x7feeb67c(,%eax,4),%eax
80104f18:	85 c0                	test   %eax,%eax
80104f1a:	75 06                	jne    80104f22 <scheduler+0xc4>
80104f1c:	83 7d f0 05          	cmpl   $0x5,-0x10(%ebp)
80104f20:	7e e3                	jle    80104f05 <scheduler+0xa7>
      index++;
    }
    if(index <= MAX)
80104f22:	83 7d f0 05          	cmpl   $0x5,-0x10(%ebp)
80104f26:	7f 22                	jg     80104f4a <scheduler+0xec>
      p = removeFromQueue(&ptable.pLists.ready[index]);
80104f28:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f2b:	05 cc 09 00 00       	add    $0x9cc,%eax
80104f30:	c1 e0 02             	shl    $0x2,%eax
80104f33:	05 80 49 11 80       	add    $0x80114980,%eax
80104f38:	83 c0 04             	add    $0x4,%eax
80104f3b:	83 ec 0c             	sub    $0xc,%esp
80104f3e:	50                   	push   %eax
80104f3f:	e8 7f 0b 00 00       	call   80105ac3 <removeFromQueue>
80104f44:	83 c4 10             	add    $0x10,%esp
80104f47:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p){
80104f4a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104f4e:	0f 84 8a 00 00 00    	je     80104fde <scheduler+0x180>
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      idle = 0;  // not idle this timeslice
80104f54:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
      proc = p;
80104f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f5e:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80104f64:	83 ec 0c             	sub    $0xc,%esp
80104f67:	ff 75 f4             	pushl  -0xc(%ebp)
80104f6a:	e8 95 41 00 00       	call   80109104 <switchuvm>
80104f6f:	83 c4 10             	add    $0x10,%esp
      assertState(p, RUNNABLE);
80104f72:	83 ec 08             	sub    $0x8,%esp
80104f75:	6a 03                	push   $0x3
80104f77:	ff 75 f4             	pushl  -0xc(%ebp)
80104f7a:	e8 84 0b 00 00       	call   80105b03 <assertState>
80104f7f:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80104f82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f85:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      addToListFront(&ptable.pLists.running, p);
80104f8c:	83 ec 08             	sub    $0x8,%esp
80104f8f:	ff 75 f4             	pushl  -0xc(%ebp)
80104f92:	68 d8 70 11 80       	push   $0x801170d8
80104f97:	e8 dc 09 00 00       	call   80105978 <addToListFront>
80104f9c:	83 c4 10             	add    $0x10,%esp
      #ifdef CS333_P2
      p->cpu_ticks_in = ticks;
80104f9f:	8b 15 00 79 11 80    	mov    0x80117900,%edx
80104fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fa8:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
      #endif
      swtch(&cpu->scheduler, proc->context);
80104fae:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fb4:	8b 40 1c             	mov    0x1c(%eax),%eax
80104fb7:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104fbe:	83 c2 04             	add    $0x4,%edx
80104fc1:	83 ec 08             	sub    $0x8,%esp
80104fc4:	50                   	push   %eax
80104fc5:	52                   	push   %edx
80104fc6:	e8 77 16 00 00       	call   80106642 <swtch>
80104fcb:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104fce:	e8 14 41 00 00       	call   801090e7 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80104fd3:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104fda:	00 00 00 00 
    }
    release(&ptable.lock);
80104fde:	83 ec 0c             	sub    $0xc,%esp
80104fe1:	68 80 49 11 80       	push   $0x80114980
80104fe6:	e8 e7 11 00 00       	call   801061d2 <release>
80104feb:	83 c4 10             	add    $0x10,%esp
  }
80104fee:	e9 71 fe ff ff       	jmp    80104e64 <scheduler+0x6>

80104ff3 <sched>:
  cpu->intena = intena;
}
#else
void
sched(void)
{
80104ff3:	55                   	push   %ebp
80104ff4:	89 e5                	mov    %esp,%ebp
80104ff6:	53                   	push   %ebx
80104ff7:	83 ec 14             	sub    $0x14,%esp
  int intena;
  
  if(!holding(&ptable.lock))
80104ffa:	83 ec 0c             	sub    $0xc,%esp
80104ffd:	68 80 49 11 80       	push   $0x80114980
80105002:	e8 97 12 00 00       	call   8010629e <holding>
80105007:	83 c4 10             	add    $0x10,%esp
8010500a:	85 c0                	test   %eax,%eax
8010500c:	75 0d                	jne    8010501b <sched+0x28>
    panic("sched ptable.lock");
8010500e:	83 ec 0c             	sub    $0xc,%esp
80105011:	68 d0 9b 10 80       	push   $0x80109bd0
80105016:	e8 4b b5 ff ff       	call   80100566 <panic>
  if(cpu->ncli != 1)
8010501b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105021:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105027:	83 f8 01             	cmp    $0x1,%eax
8010502a:	74 0d                	je     80105039 <sched+0x46>
    panic("sched locks");
8010502c:	83 ec 0c             	sub    $0xc,%esp
8010502f:	68 e2 9b 10 80       	push   $0x80109be2
80105034:	e8 2d b5 ff ff       	call   80100566 <panic>
  if(proc->state == RUNNING)
80105039:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010503f:	8b 40 0c             	mov    0xc(%eax),%eax
80105042:	83 f8 04             	cmp    $0x4,%eax
80105045:	75 0d                	jne    80105054 <sched+0x61>
    panic("sched running");
80105047:	83 ec 0c             	sub    $0xc,%esp
8010504a:	68 ee 9b 10 80       	push   $0x80109bee
8010504f:	e8 12 b5 ff ff       	call   80100566 <panic>
  if(readeflags()&FL_IF)
80105054:	e8 83 f4 ff ff       	call   801044dc <readeflags>
80105059:	25 00 02 00 00       	and    $0x200,%eax
8010505e:	85 c0                	test   %eax,%eax
80105060:	74 0d                	je     8010506f <sched+0x7c>
    panic("sched interruptible");
80105062:	83 ec 0c             	sub    $0xc,%esp
80105065:	68 fc 9b 10 80       	push   $0x80109bfc
8010506a:	e8 f7 b4 ff ff       	call   80100566 <panic>
  intena = cpu->intena;
8010506f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105075:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010507b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  #ifdef CS333_P2
  proc->cpu_ticks_total += ticks-proc->cpu_ticks_in;
8010507e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105084:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010508b:	8b 8a 88 00 00 00    	mov    0x88(%edx),%ecx
80105091:	8b 1d 00 79 11 80    	mov    0x80117900,%ebx
80105097:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010509e:	8b 92 8c 00 00 00    	mov    0x8c(%edx),%edx
801050a4:	29 d3                	sub    %edx,%ebx
801050a6:	89 da                	mov    %ebx,%edx
801050a8:	01 ca                	add    %ecx,%edx
801050aa:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
  #endif
  swtch(&proc->context, cpu->scheduler);
801050b0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801050b6:	8b 40 04             	mov    0x4(%eax),%eax
801050b9:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801050c0:	83 c2 1c             	add    $0x1c,%edx
801050c3:	83 ec 08             	sub    $0x8,%esp
801050c6:	50                   	push   %eax
801050c7:	52                   	push   %edx
801050c8:	e8 75 15 00 00       	call   80106642 <swtch>
801050cd:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
801050d0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801050d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050d9:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
801050df:	90                   	nop
801050e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050e3:	c9                   	leave  
801050e4:	c3                   	ret    

801050e5 <yield>:
#endif

// Give up the CPU for one scheduling round.
void
yield(void)
{
801050e5:	55                   	push   %ebp
801050e6:	89 e5                	mov    %esp,%ebp
801050e8:	53                   	push   %ebx
801050e9:	83 ec 04             	sub    $0x4,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801050ec:	83 ec 0c             	sub    $0xc,%esp
801050ef:	68 80 49 11 80       	push   $0x80114980
801050f4:	e8 72 10 00 00       	call   8010616b <acquire>
801050f9:	83 c4 10             	add    $0x10,%esp
  #ifdef CS333_P3P4
  switchToRunnable(&ptable.pLists.running, proc, RUNNING);
801050fc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105102:	83 ec 04             	sub    $0x4,%esp
80105105:	6a 04                	push   $0x4
80105107:	50                   	push   %eax
80105108:	68 d8 70 11 80       	push   $0x801170d8
8010510d:	e8 73 0a 00 00       	call   80105b85 <switchToRunnable>
80105112:	83 c4 10             	add    $0x10,%esp
  #else
  proc->state = RUNNABLE;
  #endif
  #ifdef CS333_P3P4
  proc->budget = proc->budget-(ticks-proc->cpu_ticks_in);
80105115:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010511b:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105122:	8b 92 98 00 00 00    	mov    0x98(%edx),%edx
80105128:	89 d3                	mov    %edx,%ebx
8010512a:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105131:	8b 8a 8c 00 00 00    	mov    0x8c(%edx),%ecx
80105137:	8b 15 00 79 11 80    	mov    0x80117900,%edx
8010513d:	29 d1                	sub    %edx,%ecx
8010513f:	89 ca                	mov    %ecx,%edx
80105141:	01 da                	add    %ebx,%edx
80105143:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
  if(proc->budget <= 0){
80105149:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010514f:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80105155:	85 c0                	test   %eax,%eax
80105157:	7f 48                	jg     801051a1 <yield+0xbc>
    if(proc->priority < MAX){
80105159:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010515f:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105165:	83 f8 04             	cmp    $0x4,%eax
80105168:	77 27                	ja     80105191 <yield+0xac>
      setpriority(proc->pid, proc->priority + 1);
8010516a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105170:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105176:	83 c0 01             	add    $0x1,%eax
80105179:	89 c2                	mov    %eax,%edx
8010517b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105181:	8b 40 10             	mov    0x10(%eax),%eax
80105184:	83 ec 08             	sub    $0x8,%esp
80105187:	52                   	push   %edx
80105188:	50                   	push   %eax
80105189:	e8 84 0d 00 00       	call   80105f12 <setpriority>
8010518e:	83 c4 10             	add    $0x10,%esp
    }
    proc->budget = 50;
80105191:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105197:	c7 80 98 00 00 00 32 	movl   $0x32,0x98(%eax)
8010519e:	00 00 00 
  }
  #endif
  sched();
801051a1:	e8 4d fe ff ff       	call   80104ff3 <sched>
  release(&ptable.lock);
801051a6:	83 ec 0c             	sub    $0xc,%esp
801051a9:	68 80 49 11 80       	push   $0x80114980
801051ae:	e8 1f 10 00 00       	call   801061d2 <release>
801051b3:	83 c4 10             	add    $0x10,%esp
}
801051b6:	90                   	nop
801051b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801051ba:	c9                   	leave  
801051bb:	c3                   	ret    

801051bc <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801051bc:	55                   	push   %ebp
801051bd:	89 e5                	mov    %esp,%ebp
801051bf:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801051c2:	83 ec 0c             	sub    $0xc,%esp
801051c5:	68 80 49 11 80       	push   $0x80114980
801051ca:	e8 03 10 00 00       	call   801061d2 <release>
801051cf:	83 c4 10             	add    $0x10,%esp

  if (first) {
801051d2:	a1 20 d0 10 80       	mov    0x8010d020,%eax
801051d7:	85 c0                	test   %eax,%eax
801051d9:	74 24                	je     801051ff <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
801051db:	c7 05 20 d0 10 80 00 	movl   $0x0,0x8010d020
801051e2:	00 00 00 
    iinit(ROOTDEV);
801051e5:	83 ec 0c             	sub    $0xc,%esp
801051e8:	6a 01                	push   $0x1
801051ea:	e8 ed c4 ff ff       	call   801016dc <iinit>
801051ef:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
801051f2:	83 ec 0c             	sub    $0xc,%esp
801051f5:	6a 01                	push   $0x1
801051f7:	e8 d1 e1 ff ff       	call   801033cd <initlog>
801051fc:	83 c4 10             	add    $0x10,%esp
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
801051ff:	90                   	nop
80105200:	c9                   	leave  
80105201:	c3                   	ret    

80105202 <sleep>:
// Reacquires lock when awakened.
// 2016/12/28: ticklock removed from xv6. sleep() changed to
// accept a NULL lock to accommodate.
void
sleep(void *chan, struct spinlock *lk)
{
80105202:	55                   	push   %ebp
80105203:	89 e5                	mov    %esp,%ebp
80105205:	53                   	push   %ebx
80105206:	83 ec 04             	sub    $0x4,%esp
  if(proc == 0)
80105209:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010520f:	85 c0                	test   %eax,%eax
80105211:	75 0d                	jne    80105220 <sleep+0x1e>
    panic("sleep");
80105213:	83 ec 0c             	sub    $0xc,%esp
80105216:	68 10 9c 10 80       	push   $0x80109c10
8010521b:	e8 46 b3 ff ff       	call   80100566 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){
80105220:	81 7d 0c 80 49 11 80 	cmpl   $0x80114980,0xc(%ebp)
80105227:	74 24                	je     8010524d <sleep+0x4b>
    acquire(&ptable.lock);
80105229:	83 ec 0c             	sub    $0xc,%esp
8010522c:	68 80 49 11 80       	push   $0x80114980
80105231:	e8 35 0f 00 00       	call   8010616b <acquire>
80105236:	83 c4 10             	add    $0x10,%esp
    if (lk) release(lk);
80105239:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010523d:	74 0e                	je     8010524d <sleep+0x4b>
8010523f:	83 ec 0c             	sub    $0xc,%esp
80105242:	ff 75 0c             	pushl  0xc(%ebp)
80105245:	e8 88 0f 00 00       	call   801061d2 <release>
8010524a:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
8010524d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105253:	8b 55 08             	mov    0x8(%ebp),%edx
80105256:	89 50 20             	mov    %edx,0x20(%eax)
  #ifdef CS333_P3P4
  switchStates(&ptable.pLists.running, &ptable.pLists.sleep, proc,
80105259:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010525f:	83 ec 0c             	sub    $0xc,%esp
80105262:	6a 02                	push   $0x2
80105264:	6a 04                	push   $0x4
80105266:	50                   	push   %eax
80105267:	68 d0 70 11 80       	push   $0x801170d0
8010526c:	68 d8 70 11 80       	push   $0x801170d8
80105271:	e8 ca 08 00 00       	call   80105b40 <switchStates>
80105276:	83 c4 20             	add    $0x20,%esp
      RUNNING, SLEEPING);
  #else
  proc->state = SLEEPING;
  #endif
  #ifdef CS333_P3P4
  proc->budget = proc->budget-(ticks-proc->cpu_ticks_in);
80105279:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010527f:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105286:	8b 92 98 00 00 00    	mov    0x98(%edx),%edx
8010528c:	89 d3                	mov    %edx,%ebx
8010528e:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105295:	8b 8a 8c 00 00 00    	mov    0x8c(%edx),%ecx
8010529b:	8b 15 00 79 11 80    	mov    0x80117900,%edx
801052a1:	29 d1                	sub    %edx,%ecx
801052a3:	89 ca                	mov    %ecx,%edx
801052a5:	01 da                	add    %ebx,%edx
801052a7:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
  if(proc->budget <= 0){
801052ad:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052b3:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
801052b9:	85 c0                	test   %eax,%eax
801052bb:	7f 48                	jg     80105305 <sleep+0x103>
    if(proc->priority < MAX){
801052bd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052c3:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801052c9:	83 f8 04             	cmp    $0x4,%eax
801052cc:	77 27                	ja     801052f5 <sleep+0xf3>
      setpriority(proc->pid, proc->priority + 1);
801052ce:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052d4:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801052da:	83 c0 01             	add    $0x1,%eax
801052dd:	89 c2                	mov    %eax,%edx
801052df:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052e5:	8b 40 10             	mov    0x10(%eax),%eax
801052e8:	83 ec 08             	sub    $0x8,%esp
801052eb:	52                   	push   %edx
801052ec:	50                   	push   %eax
801052ed:	e8 20 0c 00 00       	call   80105f12 <setpriority>
801052f2:	83 c4 10             	add    $0x10,%esp
    }
    proc->budget = 50;
801052f5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052fb:	c7 80 98 00 00 00 32 	movl   $0x32,0x98(%eax)
80105302:	00 00 00 
  }
  #endif
  sched();
80105305:	e8 e9 fc ff ff       	call   80104ff3 <sched>

  // Tidy up.
  proc->chan = 0;
8010530a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105310:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){ 
80105317:	81 7d 0c 80 49 11 80 	cmpl   $0x80114980,0xc(%ebp)
8010531e:	74 24                	je     80105344 <sleep+0x142>
    release(&ptable.lock);
80105320:	83 ec 0c             	sub    $0xc,%esp
80105323:	68 80 49 11 80       	push   $0x80114980
80105328:	e8 a5 0e 00 00       	call   801061d2 <release>
8010532d:	83 c4 10             	add    $0x10,%esp
    if (lk) acquire(lk);
80105330:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105334:	74 0e                	je     80105344 <sleep+0x142>
80105336:	83 ec 0c             	sub    $0xc,%esp
80105339:	ff 75 0c             	pushl  0xc(%ebp)
8010533c:	e8 2a 0e 00 00       	call   8010616b <acquire>
80105341:	83 c4 10             	add    $0x10,%esp
  }
}
80105344:	90                   	nop
80105345:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105348:	c9                   	leave  
80105349:	c3                   	ret    

8010534a <wakeup1>:
      p->state = RUNNABLE;
}
#else
static void
wakeup1(void *chan)
{
8010534a:	55                   	push   %ebp
8010534b:	89 e5                	mov    %esp,%ebp
8010534d:	83 ec 18             	sub    $0x18,%esp
  struct proc *current;
  struct proc *temp;

  current = ptable.pLists.sleep;
80105350:	a1 d0 70 11 80       	mov    0x801170d0,%eax
80105355:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(current){
80105358:	eb 40                	jmp    8010539a <wakeup1+0x50>
    if(current->chan == chan){
8010535a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010535d:	8b 40 20             	mov    0x20(%eax),%eax
80105360:	3b 45 08             	cmp    0x8(%ebp),%eax
80105363:	75 29                	jne    8010538e <wakeup1+0x44>
      temp = current;
80105365:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105368:	89 45 f0             	mov    %eax,-0x10(%ebp)
      current = current->next;
8010536b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010536e:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105374:	89 45 f4             	mov    %eax,-0xc(%ebp)
      switchToRunnable(&ptable.pLists.sleep, temp, SLEEPING);
80105377:	83 ec 04             	sub    $0x4,%esp
8010537a:	6a 02                	push   $0x2
8010537c:	ff 75 f0             	pushl  -0x10(%ebp)
8010537f:	68 d0 70 11 80       	push   $0x801170d0
80105384:	e8 fc 07 00 00       	call   80105b85 <switchToRunnable>
80105389:	83 c4 10             	add    $0x10,%esp
8010538c:	eb 0c                	jmp    8010539a <wakeup1+0x50>
    }
    else{
      current = current->next;
8010538e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105391:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105397:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
  struct proc *current;
  struct proc *temp;

  current = ptable.pLists.sleep;
  while(current){
8010539a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010539e:	75 ba                	jne    8010535a <wakeup1+0x10>
    }
    else{
      current = current->next;
    }
  }
  return;
801053a0:	90                   	nop
}
801053a1:	c9                   	leave  
801053a2:	c3                   	ret    

801053a3 <wakeup>:
#endif

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801053a3:	55                   	push   %ebp
801053a4:	89 e5                	mov    %esp,%ebp
801053a6:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
801053a9:	83 ec 0c             	sub    $0xc,%esp
801053ac:	68 80 49 11 80       	push   $0x80114980
801053b1:	e8 b5 0d 00 00       	call   8010616b <acquire>
801053b6:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
801053b9:	83 ec 0c             	sub    $0xc,%esp
801053bc:	ff 75 08             	pushl  0x8(%ebp)
801053bf:	e8 86 ff ff ff       	call   8010534a <wakeup1>
801053c4:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
801053c7:	83 ec 0c             	sub    $0xc,%esp
801053ca:	68 80 49 11 80       	push   $0x80114980
801053cf:	e8 fe 0d 00 00       	call   801061d2 <release>
801053d4:	83 c4 10             	add    $0x10,%esp
}
801053d7:	90                   	nop
801053d8:	c9                   	leave  
801053d9:	c3                   	ret    

801053da <kill>:
  return -1;
}
#else
int
kill(int pid)
{
801053da:	55                   	push   %ebp
801053db:	89 e5                	mov    %esp,%ebp
801053dd:	83 ec 18             	sub    $0x18,%esp
  struct proc *p = 0;
801053e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&ptable.lock);
801053e7:	83 ec 0c             	sub    $0xc,%esp
801053ea:	68 80 49 11 80       	push   $0x80114980
801053ef:	e8 77 0d 00 00       	call   8010616b <acquire>
801053f4:	83 c4 10             	add    $0x10,%esp
  p = findPid(&ptable.pLists.embryo, pid);
801053f7:	83 ec 08             	sub    $0x8,%esp
801053fa:	ff 75 08             	pushl  0x8(%ebp)
801053fd:	68 dc 70 11 80       	push   $0x801170dc
80105402:	e8 6a 08 00 00       	call   80105c71 <findPid>
80105407:	83 c4 10             	add    $0x10,%esp
8010540a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!p){
8010540d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105411:	75 3e                	jne    80105451 <kill+0x77>
    for(int i = 0; i <= MAX; i++){
80105413:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010541a:	eb 2f                	jmp    8010544b <kill+0x71>
      if(!p)
8010541c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105420:	75 25                	jne    80105447 <kill+0x6d>
        p = findPid(&ptable.pLists.ready[i], pid);
80105422:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105425:	05 cc 09 00 00       	add    $0x9cc,%eax
8010542a:	c1 e0 02             	shl    $0x2,%eax
8010542d:	05 80 49 11 80       	add    $0x80114980,%eax
80105432:	83 c0 04             	add    $0x4,%eax
80105435:	83 ec 08             	sub    $0x8,%esp
80105438:	ff 75 08             	pushl  0x8(%ebp)
8010543b:	50                   	push   %eax
8010543c:	e8 30 08 00 00       	call   80105c71 <findPid>
80105441:	83 c4 10             	add    $0x10,%esp
80105444:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct proc *p = 0;

  acquire(&ptable.lock);
  p = findPid(&ptable.pLists.embryo, pid);
  if(!p){
    for(int i = 0; i <= MAX; i++){
80105447:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010544b:	83 7d f0 05          	cmpl   $0x5,-0x10(%ebp)
8010544f:	7e cb                	jle    8010541c <kill+0x42>
      if(!p)
        p = findPid(&ptable.pLists.ready[i], pid);
    }
  }
  if(!p)
80105451:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105455:	75 16                	jne    8010546d <kill+0x93>
    p = findPid(&ptable.pLists.running, pid);
80105457:	83 ec 08             	sub    $0x8,%esp
8010545a:	ff 75 08             	pushl  0x8(%ebp)
8010545d:	68 d8 70 11 80       	push   $0x801170d8
80105462:	e8 0a 08 00 00       	call   80105c71 <findPid>
80105467:	83 c4 10             	add    $0x10,%esp
8010546a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!p)
8010546d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105471:	75 16                	jne    80105489 <kill+0xaf>
    p = findPid(&ptable.pLists.sleep, pid);
80105473:	83 ec 08             	sub    $0x8,%esp
80105476:	ff 75 08             	pushl  0x8(%ebp)
80105479:	68 d0 70 11 80       	push   $0x801170d0
8010547e:	e8 ee 07 00 00       	call   80105c71 <findPid>
80105483:	83 c4 10             	add    $0x10,%esp
80105486:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!p)
80105489:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010548d:	75 16                	jne    801054a5 <kill+0xcb>
    p = findPid(&ptable.pLists.zombie, pid);
8010548f:	83 ec 08             	sub    $0x8,%esp
80105492:	ff 75 08             	pushl  0x8(%ebp)
80105495:	68 d4 70 11 80       	push   $0x801170d4
8010549a:	e8 d2 07 00 00       	call   80105c71 <findPid>
8010549f:	83 c4 10             	add    $0x10,%esp
801054a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p){
801054a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801054a9:	74 41                	je     801054ec <kill+0x112>
    p->killed = 1;
801054ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054ae:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
    if(p->state == SLEEPING)
801054b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054b8:	8b 40 0c             	mov    0xc(%eax),%eax
801054bb:	83 f8 02             	cmp    $0x2,%eax
801054be:	75 15                	jne    801054d5 <kill+0xfb>
      switchToRunnable(&ptable.pLists.sleep, p, SLEEPING);
801054c0:	83 ec 04             	sub    $0x4,%esp
801054c3:	6a 02                	push   $0x2
801054c5:	ff 75 f4             	pushl  -0xc(%ebp)
801054c8:	68 d0 70 11 80       	push   $0x801170d0
801054cd:	e8 b3 06 00 00       	call   80105b85 <switchToRunnable>
801054d2:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
801054d5:	83 ec 0c             	sub    $0xc,%esp
801054d8:	68 80 49 11 80       	push   $0x80114980
801054dd:	e8 f0 0c 00 00       	call   801061d2 <release>
801054e2:	83 c4 10             	add    $0x10,%esp
    return 0;
801054e5:	b8 00 00 00 00       	mov    $0x0,%eax
801054ea:	eb 15                	jmp    80105501 <kill+0x127>
  }
  release(&ptable.lock);
801054ec:	83 ec 0c             	sub    $0xc,%esp
801054ef:	68 80 49 11 80       	push   $0x80114980
801054f4:	e8 d9 0c 00 00       	call   801061d2 <release>
801054f9:	83 c4 10             	add    $0x10,%esp
  return -1;
801054fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105501:	c9                   	leave  
80105502:	c3                   	ret    

80105503 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80105503:	55                   	push   %ebp
80105504:	89 e5                	mov    %esp,%ebp
80105506:	56                   	push   %esi
80105507:	53                   	push   %ebx
80105508:	83 ec 40             	sub    $0x40,%esp
  struct proc *p;
  char *state;
  uint pc[10];
 
  #ifdef CS333_P3P4
  cprintf("\nPID\tName\tUID\tGID\tPPID\tPrio\tElapsed\tCPU\tState\tSize\t PCs\n");
8010550b:	83 ec 0c             	sub    $0xc,%esp
8010550e:	68 40 9c 10 80       	push   $0x80109c40
80105513:	e8 ae ae ff ff       	call   801003c6 <cprintf>
80105518:	83 c4 10             	add    $0x10,%esp
  #elif defined CS333_P2
  cprintf("\nPID\tName\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\t PCs\n");
  #elif defined CS333_P1
  cprintf("\nPID\tState\tName\tElapsed\t PCs\n");
  #endif
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010551b:	c7 45 f0 b4 49 11 80 	movl   $0x801149b4,-0x10(%ebp)
80105522:	e9 64 01 00 00       	jmp    8010568b <procdump+0x188>
    if(p->state == UNUSED)
80105527:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010552a:	8b 40 0c             	mov    0xc(%eax),%eax
8010552d:	85 c0                	test   %eax,%eax
8010552f:	0f 84 4e 01 00 00    	je     80105683 <procdump+0x180>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80105535:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105538:	8b 40 0c             	mov    0xc(%eax),%eax
8010553b:	83 f8 05             	cmp    $0x5,%eax
8010553e:	77 23                	ja     80105563 <procdump+0x60>
80105540:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105543:	8b 40 0c             	mov    0xc(%eax),%eax
80105546:	8b 04 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%eax
8010554d:	85 c0                	test   %eax,%eax
8010554f:	74 12                	je     80105563 <procdump+0x60>
      state = states[p->state];
80105551:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105554:	8b 40 0c             	mov    0xc(%eax),%eax
80105557:	8b 04 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%eax
8010555e:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105561:	eb 07                	jmp    8010556a <procdump+0x67>
    else
      state = "???";
80105563:	c7 45 ec 79 9c 10 80 	movl   $0x80109c79,-0x14(%ebp)
    #ifdef CS333_P3P4
    int ppid;

    if(!p->parent)
8010556a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010556d:	8b 40 14             	mov    0x14(%eax),%eax
80105570:	85 c0                	test   %eax,%eax
80105572:	75 09                	jne    8010557d <procdump+0x7a>
      ppid = 1;
80105574:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
8010557b:	eb 0c                	jmp    80105589 <procdump+0x86>
    else
      ppid = p->parent->pid;
8010557d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105580:	8b 40 14             	mov    0x14(%eax),%eax
80105583:	8b 40 10             	mov    0x10(%eax),%eax
80105586:	89 45 e8             	mov    %eax,-0x18(%ebp)

    cprintf("%d\t%s\t%d\t%d\t%d\t%d\t",
80105589:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010558c:	8b 98 94 00 00 00    	mov    0x94(%eax),%ebx
80105592:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105595:	8b 88 84 00 00 00    	mov    0x84(%eax),%ecx
8010559b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010559e:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
        p->pid, p->name, p->uid, p->gid, ppid, p->priority);
801055a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055a7:	8d 70 6c             	lea    0x6c(%eax),%esi
    if(!p->parent)
      ppid = 1;
    else
      ppid = p->parent->pid;

    cprintf("%d\t%s\t%d\t%d\t%d\t%d\t",
801055aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055ad:	8b 40 10             	mov    0x10(%eax),%eax
801055b0:	83 ec 04             	sub    $0x4,%esp
801055b3:	53                   	push   %ebx
801055b4:	ff 75 e8             	pushl  -0x18(%ebp)
801055b7:	51                   	push   %ecx
801055b8:	52                   	push   %edx
801055b9:	56                   	push   %esi
801055ba:	50                   	push   %eax
801055bb:	68 7d 9c 10 80       	push   $0x80109c7d
801055c0:	e8 01 ae ff ff       	call   801003c6 <cprintf>
801055c5:	83 c4 20             	add    $0x20,%esp
        p->pid, p->name, p->uid, p->gid, ppid, p->priority);
    calcelapsedtime(ticks-p->start_ticks);
801055c8:	8b 15 00 79 11 80    	mov    0x80117900,%edx
801055ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055d1:	8b 40 7c             	mov    0x7c(%eax),%eax
801055d4:	29 c2                	sub    %eax,%edx
801055d6:	89 d0                	mov    %edx,%eax
801055d8:	83 ec 0c             	sub    $0xc,%esp
801055db:	50                   	push   %eax
801055dc:	e8 bf 00 00 00       	call   801056a0 <calcelapsedtime>
801055e1:	83 c4 10             	add    $0x10,%esp
    calcelapsedtime(p->cpu_ticks_total);
801055e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055e7:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
801055ed:	83 ec 0c             	sub    $0xc,%esp
801055f0:	50                   	push   %eax
801055f1:	e8 aa 00 00 00       	call   801056a0 <calcelapsedtime>
801055f6:	83 c4 10             	add    $0x10,%esp
    cprintf("%s\t%d\t", state, p->sz);
801055f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055fc:	8b 00                	mov    (%eax),%eax
801055fe:	83 ec 04             	sub    $0x4,%esp
80105601:	50                   	push   %eax
80105602:	ff 75 ec             	pushl  -0x14(%ebp)
80105605:	68 90 9c 10 80       	push   $0x80109c90
8010560a:	e8 b7 ad ff ff       	call   801003c6 <cprintf>
8010560f:	83 c4 10             	add    $0x10,%esp
    cprintf("%d\t%s\t%s\t", p->pid, state, p->name);
    calcelapsedtime(ticks-p->start_ticks);
    #else
    cprintf("%d %s %s", p->pid, state, p->name);
    #endif
    if(p->state == SLEEPING){
80105612:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105615:	8b 40 0c             	mov    0xc(%eax),%eax
80105618:	83 f8 02             	cmp    $0x2,%eax
8010561b:	75 54                	jne    80105671 <procdump+0x16e>
      getcallerpcs((uint*)p->context->ebp+2, pc);
8010561d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105620:	8b 40 1c             	mov    0x1c(%eax),%eax
80105623:	8b 40 0c             	mov    0xc(%eax),%eax
80105626:	83 c0 08             	add    $0x8,%eax
80105629:	89 c2                	mov    %eax,%edx
8010562b:	83 ec 08             	sub    $0x8,%esp
8010562e:	8d 45 c0             	lea    -0x40(%ebp),%eax
80105631:	50                   	push   %eax
80105632:	52                   	push   %edx
80105633:	e8 ec 0b 00 00       	call   80106224 <getcallerpcs>
80105638:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
8010563b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105642:	eb 1c                	jmp    80105660 <procdump+0x15d>
        cprintf(" %p", pc[i]);
80105644:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105647:	8b 44 85 c0          	mov    -0x40(%ebp,%eax,4),%eax
8010564b:	83 ec 08             	sub    $0x8,%esp
8010564e:	50                   	push   %eax
8010564f:	68 97 9c 10 80       	push   $0x80109c97
80105654:	e8 6d ad ff ff       	call   801003c6 <cprintf>
80105659:	83 c4 10             	add    $0x10,%esp
    #else
    cprintf("%d %s %s", p->pid, state, p->name);
    #endif
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
8010565c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105660:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80105664:	7f 0b                	jg     80105671 <procdump+0x16e>
80105666:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105669:	8b 44 85 c0          	mov    -0x40(%ebp,%eax,4),%eax
8010566d:	85 c0                	test   %eax,%eax
8010566f:	75 d3                	jne    80105644 <procdump+0x141>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80105671:	83 ec 0c             	sub    $0xc,%esp
80105674:	68 9b 9c 10 80       	push   $0x80109c9b
80105679:	e8 48 ad ff ff       	call   801003c6 <cprintf>
8010567e:	83 c4 10             	add    $0x10,%esp
80105681:	eb 01                	jmp    80105684 <procdump+0x181>
  #elif defined CS333_P1
  cprintf("\nPID\tState\tName\tElapsed\t PCs\n");
  #endif
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
80105683:	90                   	nop
  #elif defined CS333_P2
  cprintf("\nPID\tName\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\t PCs\n");
  #elif defined CS333_P1
  cprintf("\nPID\tState\tName\tElapsed\t PCs\n");
  #endif
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105684:	81 45 f0 9c 00 00 00 	addl   $0x9c,-0x10(%ebp)
8010568b:	81 7d f0 b4 70 11 80 	cmpl   $0x801170b4,-0x10(%ebp)
80105692:	0f 82 8f fe ff ff    	jb     80105527 <procdump+0x24>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80105698:	90                   	nop
80105699:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010569c:	5b                   	pop    %ebx
8010569d:	5e                   	pop    %esi
8010569e:	5d                   	pop    %ebp
8010569f:	c3                   	ret    

801056a0 <calcelapsedtime>:
// Determines the seconds elapsed for a running process to the thousandth of a
// second and prints the result
#ifdef CS333_P1
void
calcelapsedtime(int ticks_in)
{
801056a0:	55                   	push   %ebp
801056a1:	89 e5                	mov    %esp,%ebp
801056a3:	83 ec 18             	sub    $0x18,%esp
  int seconds = (ticks_in)/1000;
801056a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
801056a9:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
801056ae:	89 c8                	mov    %ecx,%eax
801056b0:	f7 ea                	imul   %edx
801056b2:	c1 fa 06             	sar    $0x6,%edx
801056b5:	89 c8                	mov    %ecx,%eax
801056b7:	c1 f8 1f             	sar    $0x1f,%eax
801056ba:	29 c2                	sub    %eax,%edx
801056bc:	89 d0                	mov    %edx,%eax
801056be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int milliseconds = (ticks_in)%1000;
801056c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
801056c4:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
801056c9:	89 c8                	mov    %ecx,%eax
801056cb:	f7 ea                	imul   %edx
801056cd:	c1 fa 06             	sar    $0x6,%edx
801056d0:	89 c8                	mov    %ecx,%eax
801056d2:	c1 f8 1f             	sar    $0x1f,%eax
801056d5:	29 c2                	sub    %eax,%edx
801056d7:	89 d0                	mov    %edx,%eax
801056d9:	69 c0 e8 03 00 00    	imul   $0x3e8,%eax,%eax
801056df:	29 c1                	sub    %eax,%ecx
801056e1:	89 c8                	mov    %ecx,%eax
801056e3:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(milliseconds < 10)
801056e6:	83 7d f0 09          	cmpl   $0x9,-0x10(%ebp)
801056ea:	7f 18                	jg     80105704 <calcelapsedtime+0x64>
    cprintf("%d.00%d\t", seconds, milliseconds);
801056ec:	83 ec 04             	sub    $0x4,%esp
801056ef:	ff 75 f0             	pushl  -0x10(%ebp)
801056f2:	ff 75 f4             	pushl  -0xc(%ebp)
801056f5:	68 9d 9c 10 80       	push   $0x80109c9d
801056fa:	e8 c7 ac ff ff       	call   801003c6 <cprintf>
801056ff:	83 c4 10             	add    $0x10,%esp
  else if(milliseconds < 100)
    cprintf("%d.0%d\t", seconds, milliseconds);
  else
    cprintf("%d.%d\t", seconds, milliseconds);
}
80105702:	eb 34                	jmp    80105738 <calcelapsedtime+0x98>
  int seconds = (ticks_in)/1000;
  int milliseconds = (ticks_in)%1000;

  if(milliseconds < 10)
    cprintf("%d.00%d\t", seconds, milliseconds);
  else if(milliseconds < 100)
80105704:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
80105708:	7f 18                	jg     80105722 <calcelapsedtime+0x82>
    cprintf("%d.0%d\t", seconds, milliseconds);
8010570a:	83 ec 04             	sub    $0x4,%esp
8010570d:	ff 75 f0             	pushl  -0x10(%ebp)
80105710:	ff 75 f4             	pushl  -0xc(%ebp)
80105713:	68 a6 9c 10 80       	push   $0x80109ca6
80105718:	e8 a9 ac ff ff       	call   801003c6 <cprintf>
8010571d:	83 c4 10             	add    $0x10,%esp
  else
    cprintf("%d.%d\t", seconds, milliseconds);
}
80105720:	eb 16                	jmp    80105738 <calcelapsedtime+0x98>
  if(milliseconds < 10)
    cprintf("%d.00%d\t", seconds, milliseconds);
  else if(milliseconds < 100)
    cprintf("%d.0%d\t", seconds, milliseconds);
  else
    cprintf("%d.%d\t", seconds, milliseconds);
80105722:	83 ec 04             	sub    $0x4,%esp
80105725:	ff 75 f0             	pushl  -0x10(%ebp)
80105728:	ff 75 f4             	pushl  -0xc(%ebp)
8010572b:	68 ae 9c 10 80       	push   $0x80109cae
80105730:	e8 91 ac ff ff       	call   801003c6 <cprintf>
80105735:	83 c4 10             	add    $0x10,%esp
}
80105738:	90                   	nop
80105739:	c9                   	leave  
8010573a:	c3                   	ret    

8010573b <getprocs>:

// Copies active processes in the ptable to the uproc table passed in
#ifdef CS333_P2
int
getprocs(uint max, struct uproc* table)
{
8010573b:	55                   	push   %ebp
8010573c:	89 e5                	mov    %esp,%ebp
8010573e:	83 ec 18             	sub    $0x18,%esp
  int uproc_table_index = 0;
80105741:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  for(int i = 0; i < NPROC; i++){
80105748:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010574f:	e9 15 02 00 00       	jmp    80105969 <getprocs+0x22e>
    if(ptable.proc[i].state == SLEEPING || ptable.proc[i].state == RUNNING ||
80105754:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105757:	69 c0 9c 00 00 00    	imul   $0x9c,%eax,%eax
8010575d:	05 c0 49 11 80       	add    $0x801149c0,%eax
80105762:	8b 00                	mov    (%eax),%eax
80105764:	83 f8 02             	cmp    $0x2,%eax
80105767:	74 2e                	je     80105797 <getprocs+0x5c>
80105769:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010576c:	69 c0 9c 00 00 00    	imul   $0x9c,%eax,%eax
80105772:	05 c0 49 11 80       	add    $0x801149c0,%eax
80105777:	8b 00                	mov    (%eax),%eax
80105779:	83 f8 04             	cmp    $0x4,%eax
8010577c:	74 19                	je     80105797 <getprocs+0x5c>
        ptable.proc[i].state == RUNNABLE){
8010577e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105781:	69 c0 9c 00 00 00    	imul   $0x9c,%eax,%eax
80105787:	05 c0 49 11 80       	add    $0x801149c0,%eax
8010578c:	8b 00                	mov    (%eax),%eax
getprocs(uint max, struct uproc* table)
{
  int uproc_table_index = 0;

  for(int i = 0; i < NPROC; i++){
    if(ptable.proc[i].state == SLEEPING || ptable.proc[i].state == RUNNING ||
8010578e:	83 f8 03             	cmp    $0x3,%eax
80105791:	0f 85 ce 01 00 00    	jne    80105965 <getprocs+0x22a>
        ptable.proc[i].state == RUNNABLE){
      if(uproc_table_index < max){
80105797:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010579a:	3b 45 08             	cmp    0x8(%ebp),%eax
8010579d:	0f 83 c2 01 00 00    	jae    80105965 <getprocs+0x22a>
        table[uproc_table_index].pid = ptable.proc[i].pid;
801057a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801057a6:	89 d0                	mov    %edx,%eax
801057a8:	01 c0                	add    %eax,%eax
801057aa:	01 d0                	add    %edx,%eax
801057ac:	c1 e0 05             	shl    $0x5,%eax
801057af:	89 c2                	mov    %eax,%edx
801057b1:	8b 45 0c             	mov    0xc(%ebp),%eax
801057b4:	01 c2                	add    %eax,%edx
801057b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057b9:	69 c0 9c 00 00 00    	imul   $0x9c,%eax,%eax
801057bf:	05 c4 49 11 80       	add    $0x801149c4,%eax
801057c4:	8b 00                	mov    (%eax),%eax
801057c6:	89 02                	mov    %eax,(%edx)
        table[uproc_table_index].uid = ptable.proc[i].uid;
801057c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801057cb:	89 d0                	mov    %edx,%eax
801057cd:	01 c0                	add    %eax,%eax
801057cf:	01 d0                	add    %edx,%eax
801057d1:	c1 e0 05             	shl    $0x5,%eax
801057d4:	89 c2                	mov    %eax,%edx
801057d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801057d9:	01 c2                	add    %eax,%edx
801057db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057de:	69 c0 9c 00 00 00    	imul   $0x9c,%eax,%eax
801057e4:	05 34 4a 11 80       	add    $0x80114a34,%eax
801057e9:	8b 00                	mov    (%eax),%eax
801057eb:	89 42 04             	mov    %eax,0x4(%edx)
        table[uproc_table_index].gid = ptable.proc[i].gid;
801057ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
801057f1:	89 d0                	mov    %edx,%eax
801057f3:	01 c0                	add    %eax,%eax
801057f5:	01 d0                	add    %edx,%eax
801057f7:	c1 e0 05             	shl    $0x5,%eax
801057fa:	89 c2                	mov    %eax,%edx
801057fc:	8b 45 0c             	mov    0xc(%ebp),%eax
801057ff:	01 c2                	add    %eax,%edx
80105801:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105804:	69 c0 9c 00 00 00    	imul   $0x9c,%eax,%eax
8010580a:	05 38 4a 11 80       	add    $0x80114a38,%eax
8010580f:	8b 00                	mov    (%eax),%eax
80105811:	89 42 08             	mov    %eax,0x8(%edx)
        table[uproc_table_index].elapsed_ticks =
80105814:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105817:	89 d0                	mov    %edx,%eax
80105819:	01 c0                	add    %eax,%eax
8010581b:	01 d0                	add    %edx,%eax
8010581d:	c1 e0 05             	shl    $0x5,%eax
80105820:	89 c2                	mov    %eax,%edx
80105822:	8b 45 0c             	mov    0xc(%ebp),%eax
80105825:	01 d0                	add    %edx,%eax
            ticks-ptable.proc[i].start_ticks;
80105827:	8b 0d 00 79 11 80    	mov    0x80117900,%ecx
8010582d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105830:	69 d2 9c 00 00 00    	imul   $0x9c,%edx,%edx
80105836:	81 c2 30 4a 11 80    	add    $0x80114a30,%edx
8010583c:	8b 12                	mov    (%edx),%edx
8010583e:	29 d1                	sub    %edx,%ecx
80105840:	89 ca                	mov    %ecx,%edx
        ptable.proc[i].state == RUNNABLE){
      if(uproc_table_index < max){
        table[uproc_table_index].pid = ptable.proc[i].pid;
        table[uproc_table_index].uid = ptable.proc[i].uid;
        table[uproc_table_index].gid = ptable.proc[i].gid;
        table[uproc_table_index].elapsed_ticks =
80105842:	89 50 10             	mov    %edx,0x10(%eax)
            ticks-ptable.proc[i].start_ticks;
        table[uproc_table_index].CPU_total_ticks =
80105845:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105848:	89 d0                	mov    %edx,%eax
8010584a:	01 c0                	add    %eax,%eax
8010584c:	01 d0                	add    %edx,%eax
8010584e:	c1 e0 05             	shl    $0x5,%eax
80105851:	89 c2                	mov    %eax,%edx
80105853:	8b 45 0c             	mov    0xc(%ebp),%eax
80105856:	01 c2                	add    %eax,%edx
            ptable.proc[i].cpu_ticks_total;
80105858:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010585b:	69 c0 9c 00 00 00    	imul   $0x9c,%eax,%eax
80105861:	05 3c 4a 11 80       	add    $0x80114a3c,%eax
80105866:	8b 00                	mov    (%eax),%eax
        table[uproc_table_index].pid = ptable.proc[i].pid;
        table[uproc_table_index].uid = ptable.proc[i].uid;
        table[uproc_table_index].gid = ptable.proc[i].gid;
        table[uproc_table_index].elapsed_ticks =
            ticks-ptable.proc[i].start_ticks;
        table[uproc_table_index].CPU_total_ticks =
80105868:	89 42 14             	mov    %eax,0x14(%edx)
            ptable.proc[i].cpu_ticks_total;
        safestrcpy(table[uproc_table_index].state,
            states[ptable.proc[i].state], STRMAX);
8010586b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010586e:	69 c0 9c 00 00 00    	imul   $0x9c,%eax,%eax
80105874:	05 c0 49 11 80       	add    $0x801149c0,%eax
80105879:	8b 00                	mov    (%eax),%eax
8010587b:	8b 0c 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%ecx
        table[uproc_table_index].gid = ptable.proc[i].gid;
        table[uproc_table_index].elapsed_ticks =
            ticks-ptable.proc[i].start_ticks;
        table[uproc_table_index].CPU_total_ticks =
            ptable.proc[i].cpu_ticks_total;
        safestrcpy(table[uproc_table_index].state,
80105882:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105885:	89 d0                	mov    %edx,%eax
80105887:	01 c0                	add    %eax,%eax
80105889:	01 d0                	add    %edx,%eax
8010588b:	c1 e0 05             	shl    $0x5,%eax
8010588e:	89 c2                	mov    %eax,%edx
80105890:	8b 45 0c             	mov    0xc(%ebp),%eax
80105893:	01 d0                	add    %edx,%eax
80105895:	83 c0 18             	add    $0x18,%eax
80105898:	83 ec 04             	sub    $0x4,%esp
8010589b:	6a 20                	push   $0x20
8010589d:	51                   	push   %ecx
8010589e:	50                   	push   %eax
8010589f:	e8 2d 0d 00 00       	call   801065d1 <safestrcpy>
801058a4:	83 c4 10             	add    $0x10,%esp
            states[ptable.proc[i].state], STRMAX);
        table[uproc_table_index].size = ptable.proc[i].sz;
801058a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801058aa:	89 d0                	mov    %edx,%eax
801058ac:	01 c0                	add    %eax,%eax
801058ae:	01 d0                	add    %edx,%eax
801058b0:	c1 e0 05             	shl    $0x5,%eax
801058b3:	89 c2                	mov    %eax,%edx
801058b5:	8b 45 0c             	mov    0xc(%ebp),%eax
801058b8:	01 c2                	add    %eax,%edx
801058ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058bd:	69 c0 9c 00 00 00    	imul   $0x9c,%eax,%eax
801058c3:	05 b4 49 11 80       	add    $0x801149b4,%eax
801058c8:	8b 00                	mov    (%eax),%eax
801058ca:	89 42 38             	mov    %eax,0x38(%edx)
        safestrcpy(table[uproc_table_index].name, ptable.proc[i].name, STRMAX);
801058cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058d0:	69 c0 9c 00 00 00    	imul   $0x9c,%eax,%eax
801058d6:	05 90 00 00 00       	add    $0x90,%eax
801058db:	05 80 49 11 80       	add    $0x80114980,%eax
801058e0:	8d 48 10             	lea    0x10(%eax),%ecx
801058e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801058e6:	89 d0                	mov    %edx,%eax
801058e8:	01 c0                	add    %eax,%eax
801058ea:	01 d0                	add    %edx,%eax
801058ec:	c1 e0 05             	shl    $0x5,%eax
801058ef:	89 c2                	mov    %eax,%edx
801058f1:	8b 45 0c             	mov    0xc(%ebp),%eax
801058f4:	01 d0                	add    %edx,%eax
801058f6:	83 c0 3c             	add    $0x3c,%eax
801058f9:	83 ec 04             	sub    $0x4,%esp
801058fc:	6a 20                	push   $0x20
801058fe:	51                   	push   %ecx
801058ff:	50                   	push   %eax
80105900:	e8 cc 0c 00 00       	call   801065d1 <safestrcpy>
80105905:	83 c4 10             	add    $0x10,%esp

        if(!ptable.proc[i].parent)
80105908:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010590b:	69 c0 9c 00 00 00    	imul   $0x9c,%eax,%eax
80105911:	05 c8 49 11 80       	add    $0x801149c8,%eax
80105916:	8b 00                	mov    (%eax),%eax
80105918:	85 c0                	test   %eax,%eax
8010591a:	75 1c                	jne    80105938 <getprocs+0x1fd>
          table[uproc_table_index].ppid = 1;
8010591c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010591f:	89 d0                	mov    %edx,%eax
80105921:	01 c0                	add    %eax,%eax
80105923:	01 d0                	add    %edx,%eax
80105925:	c1 e0 05             	shl    $0x5,%eax
80105928:	89 c2                	mov    %eax,%edx
8010592a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010592d:	01 d0                	add    %edx,%eax
8010592f:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
80105936:	eb 29                	jmp    80105961 <getprocs+0x226>
        else
          table[uproc_table_index].ppid = ptable.proc[i].parent->pid;
80105938:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010593b:	89 d0                	mov    %edx,%eax
8010593d:	01 c0                	add    %eax,%eax
8010593f:	01 d0                	add    %edx,%eax
80105941:	c1 e0 05             	shl    $0x5,%eax
80105944:	89 c2                	mov    %eax,%edx
80105946:	8b 45 0c             	mov    0xc(%ebp),%eax
80105949:	01 c2                	add    %eax,%edx
8010594b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010594e:	69 c0 9c 00 00 00    	imul   $0x9c,%eax,%eax
80105954:	05 c8 49 11 80       	add    $0x801149c8,%eax
80105959:	8b 00                	mov    (%eax),%eax
8010595b:	8b 40 10             	mov    0x10(%eax),%eax
8010595e:	89 42 0c             	mov    %eax,0xc(%edx)
        uproc_table_index++;
80105961:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
int
getprocs(uint max, struct uproc* table)
{
  int uproc_table_index = 0;

  for(int i = 0; i < NPROC; i++){
80105965:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80105969:	83 7d f0 3f          	cmpl   $0x3f,-0x10(%ebp)
8010596d:	0f 8e e1 fd ff ff    	jle    80105754 <getprocs+0x19>
          table[uproc_table_index].ppid = ptable.proc[i].parent->pid;
        uproc_table_index++;
      }
    }
  }
  return uproc_table_index;
80105973:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105976:	c9                   	leave  
80105977:	c3                   	ret    

80105978 <addToListFront>:

#ifdef CS333_P3P4
// Adds a process to the head of the list passed in
void
addToListFront(struct proc** sList, struct proc* p)
{
80105978:	55                   	push   %ebp
80105979:	89 e5                	mov    %esp,%ebp
  p->next = *sList;
8010597b:	8b 45 08             	mov    0x8(%ebp),%eax
8010597e:	8b 10                	mov    (%eax),%edx
80105980:	8b 45 0c             	mov    0xc(%ebp),%eax
80105983:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
  *sList = p;
80105989:	8b 45 08             	mov    0x8(%ebp),%eax
8010598c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010598f:	89 10                	mov    %edx,(%eax)
  return;
80105991:	90                   	nop
}
80105992:	5d                   	pop    %ebp
80105993:	c3                   	ret    

80105994 <addToListRear>:

// Adds a process to the rear of the list passed in
void
addToListRear(struct proc** sList, struct proc* p)
{
80105994:	55                   	push   %ebp
80105995:	89 e5                	mov    %esp,%ebp
80105997:	83 ec 10             	sub    $0x10,%esp
  if(!*sList){
8010599a:	8b 45 08             	mov    0x8(%ebp),%eax
8010599d:	8b 00                	mov    (%eax),%eax
8010599f:	85 c0                	test   %eax,%eax
801059a1:	75 17                	jne    801059ba <addToListRear+0x26>
    *sList = p;
801059a3:	8b 45 08             	mov    0x8(%ebp),%eax
801059a6:	8b 55 0c             	mov    0xc(%ebp),%edx
801059a9:	89 10                	mov    %edx,(%eax)
    p->next = 0;
801059ab:	8b 45 0c             	mov    0xc(%ebp),%eax
801059ae:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
801059b5:	00 00 00 
    }

    temp->next = p;
    p->next = 0;
  }
  return;
801059b8:	eb 3d                	jmp    801059f7 <addToListRear+0x63>
  if(!*sList){
    *sList = p;
    p->next = 0;
  }
  else{
    struct proc *temp = *sList;
801059ba:	8b 45 08             	mov    0x8(%ebp),%eax
801059bd:	8b 00                	mov    (%eax),%eax
801059bf:	89 45 fc             	mov    %eax,-0x4(%ebp)

    while(temp->next){
801059c2:	eb 0c                	jmp    801059d0 <addToListRear+0x3c>
      temp = temp->next;
801059c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801059c7:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801059cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
    p->next = 0;
  }
  else{
    struct proc *temp = *sList;

    while(temp->next){
801059d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801059d3:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801059d9:	85 c0                	test   %eax,%eax
801059db:	75 e7                	jne    801059c4 <addToListRear+0x30>
      temp = temp->next;
    }

    temp->next = p;
801059dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
801059e0:	8b 55 0c             	mov    0xc(%ebp),%edx
801059e3:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
    p->next = 0;
801059e9:	8b 45 0c             	mov    0xc(%ebp),%eax
801059ec:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
801059f3:	00 00 00 
  }
  return;
801059f6:	90                   	nop
}
801059f7:	c9                   	leave  
801059f8:	c3                   	ret    

801059f9 <removeFromStateList>:

// Checks if a process is in the given list, and if so, removes it
void
removeFromStateList(struct proc** sList, struct proc* p)
{
801059f9:	55                   	push   %ebp
801059fa:	89 e5                	mov    %esp,%ebp
801059fc:	83 ec 18             	sub    $0x18,%esp
  struct proc *current = *sList;
801059ff:	8b 45 08             	mov    0x8(%ebp),%eax
80105a02:	8b 00                	mov    (%eax),%eax
80105a04:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct proc *previous = *sList;
80105a07:	8b 45 08             	mov    0x8(%ebp),%eax
80105a0a:	8b 00                	mov    (%eax),%eax
80105a0c:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(!(*sList))
80105a0f:	8b 45 08             	mov    0x8(%ebp),%eax
80105a12:	8b 00                	mov    (%eax),%eax
80105a14:	85 c0                	test   %eax,%eax
80105a16:	75 0d                	jne    80105a25 <removeFromStateList+0x2c>
    panic("Cannot remove the process from an empty list!");
80105a18:	83 ec 0c             	sub    $0xc,%esp
80105a1b:	68 b8 9c 10 80       	push   $0x80109cb8
80105a20:	e8 41 ab ff ff       	call   80100566 <panic>
  if(*sList == p){
80105a25:	8b 45 08             	mov    0x8(%ebp),%eax
80105a28:	8b 00                	mov    (%eax),%eax
80105a2a:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105a2d:	75 1f                	jne    80105a4e <removeFromStateList+0x55>
    *sList = (*sList)->next;
80105a2f:	8b 45 08             	mov    0x8(%ebp),%eax
80105a32:	8b 00                	mov    (%eax),%eax
80105a34:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
80105a3a:	8b 45 08             	mov    0x8(%ebp),%eax
80105a3d:	89 10                	mov    %edx,(%eax)
    p->next = 0;
80105a3f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a42:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80105a49:	00 00 00 
    return;
80105a4c:	eb 73                	jmp    80105ac1 <removeFromStateList+0xc8>
  }
  current = current->next;
80105a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a51:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105a57:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(current){
80105a5a:	eb 3b                	jmp    80105a97 <removeFromStateList+0x9e>
    if(current == p){
80105a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a5f:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105a62:	75 21                	jne    80105a85 <removeFromStateList+0x8c>
      previous->next = current->next;
80105a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a67:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
80105a6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a70:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
      p->next = 0;
80105a76:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a79:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80105a80:	00 00 00 
      return;
80105a83:	eb 3c                	jmp    80105ac1 <removeFromStateList+0xc8>
    }
    else{
      previous = current;
80105a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a88:	89 45 f0             	mov    %eax,-0x10(%ebp)
      current = current->next;
80105a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a8e:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105a94:	89 45 f4             	mov    %eax,-0xc(%ebp)
    *sList = (*sList)->next;
    p->next = 0;
    return;
  }
  current = current->next;
  while(current){
80105a97:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a9b:	75 bf                	jne    80105a5c <removeFromStateList+0x63>
    else{
      previous = current;
      current = current->next;
    }
  }
  cprintf("Process %s is not in the list!", p->name);
80105a9d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105aa0:	83 c0 6c             	add    $0x6c,%eax
80105aa3:	83 ec 08             	sub    $0x8,%esp
80105aa6:	50                   	push   %eax
80105aa7:	68 e8 9c 10 80       	push   $0x80109ce8
80105aac:	e8 15 a9 ff ff       	call   801003c6 <cprintf>
80105ab1:	83 c4 10             	add    $0x10,%esp
  panic("Cannot remove the process from the list!");
80105ab4:	83 ec 0c             	sub    $0xc,%esp
80105ab7:	68 08 9d 10 80       	push   $0x80109d08
80105abc:	e8 a5 aa ff ff       	call   80100566 <panic>
}
80105ac1:	c9                   	leave  
80105ac2:	c3                   	ret    

80105ac3 <removeFromQueue>:

// Removes a process from the list passed in and
// returns it to the calling routine
struct proc*
removeFromQueue(struct proc** sList)
{
80105ac3:	55                   	push   %ebp
80105ac4:	89 e5                	mov    %esp,%ebp
80105ac6:	83 ec 10             	sub    $0x10,%esp
  if(!*sList)
80105ac9:	8b 45 08             	mov    0x8(%ebp),%eax
80105acc:	8b 00                	mov    (%eax),%eax
80105ace:	85 c0                	test   %eax,%eax
80105ad0:	75 07                	jne    80105ad9 <removeFromQueue+0x16>
    return 0;
80105ad2:	b8 00 00 00 00       	mov    $0x0,%eax
80105ad7:	eb 28                	jmp    80105b01 <removeFromQueue+0x3e>
  else{
    struct proc *temp = *sList;
80105ad9:	8b 45 08             	mov    0x8(%ebp),%eax
80105adc:	8b 00                	mov    (%eax),%eax
80105ade:	89 45 fc             	mov    %eax,-0x4(%ebp)
    *sList = (*sList)->next;
80105ae1:	8b 45 08             	mov    0x8(%ebp),%eax
80105ae4:	8b 00                	mov    (%eax),%eax
80105ae6:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
80105aec:	8b 45 08             	mov    0x8(%ebp),%eax
80105aef:	89 10                	mov    %edx,(%eax)
    temp->next = 0;
80105af1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105af4:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80105afb:	00 00 00 
    return temp;
80105afe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  }
}
80105b01:	c9                   	leave  
80105b02:	c3                   	ret    

80105b03 <assertState>:

// Checks if a process is in the state given and returns, otherwise panic
void
assertState(struct proc* p, int state)
{
80105b03:	55                   	push   %ebp
80105b04:	89 e5                	mov    %esp,%ebp
80105b06:	83 ec 08             	sub    $0x8,%esp
  if(p->state != state){
80105b09:	8b 45 08             	mov    0x8(%ebp),%eax
80105b0c:	8b 50 0c             	mov    0xc(%eax),%edx
80105b0f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b12:	39 c2                	cmp    %eax,%edx
80105b14:	74 27                	je     80105b3d <assertState+0x3a>
    cprintf("The state of %s does not match %s!", p->state, state);
80105b16:	8b 45 08             	mov    0x8(%ebp),%eax
80105b19:	8b 40 0c             	mov    0xc(%eax),%eax
80105b1c:	83 ec 04             	sub    $0x4,%esp
80105b1f:	ff 75 0c             	pushl  0xc(%ebp)
80105b22:	50                   	push   %eax
80105b23:	68 34 9d 10 80       	push   $0x80109d34
80105b28:	e8 99 a8 ff ff       	call   801003c6 <cprintf>
80105b2d:	83 c4 10             	add    $0x10,%esp
    panic("States do not match!");
80105b30:	83 ec 0c             	sub    $0xc,%esp
80105b33:	68 57 9d 10 80       	push   $0x80109d57
80105b38:	e8 29 aa ff ff       	call   80100566 <panic>
  }
  return;
80105b3d:	90                   	nop
}
80105b3e:	c9                   	leave  
80105b3f:	c3                   	ret    

80105b40 <switchStates>:
// Asserts that a process is in a state, removes it from that list,
// updates its state, and adds it to the new list
void
switchStates(struct proc** list_to_remove, struct proc** list_to_add,
    struct proc* p, int check_state, int add_state)
{
80105b40:	55                   	push   %ebp
80105b41:	89 e5                	mov    %esp,%ebp
80105b43:	83 ec 08             	sub    $0x8,%esp
  assertState(p, check_state);
80105b46:	83 ec 08             	sub    $0x8,%esp
80105b49:	ff 75 14             	pushl  0x14(%ebp)
80105b4c:	ff 75 10             	pushl  0x10(%ebp)
80105b4f:	e8 af ff ff ff       	call   80105b03 <assertState>
80105b54:	83 c4 10             	add    $0x10,%esp
  removeFromStateList(list_to_remove, p);
80105b57:	83 ec 08             	sub    $0x8,%esp
80105b5a:	ff 75 10             	pushl  0x10(%ebp)
80105b5d:	ff 75 08             	pushl  0x8(%ebp)
80105b60:	e8 94 fe ff ff       	call   801059f9 <removeFromStateList>
80105b65:	83 c4 10             	add    $0x10,%esp
  p->state = add_state;
80105b68:	8b 55 18             	mov    0x18(%ebp),%edx
80105b6b:	8b 45 10             	mov    0x10(%ebp),%eax
80105b6e:	89 50 0c             	mov    %edx,0xc(%eax)
  addToListFront(list_to_add, p);
80105b71:	83 ec 08             	sub    $0x8,%esp
80105b74:	ff 75 10             	pushl  0x10(%ebp)
80105b77:	ff 75 0c             	pushl  0xc(%ebp)
80105b7a:	e8 f9 fd ff ff       	call   80105978 <addToListFront>
80105b7f:	83 c4 10             	add    $0x10,%esp
  return;
80105b82:	90                   	nop
}
80105b83:	c9                   	leave  
80105b84:	c3                   	ret    

80105b85 <switchToRunnable>:

// Removes a process from the list passed in and adds it to the ready list
void
switchToRunnable(struct proc** sList, struct proc* p, int check_state)
{ 
80105b85:	55                   	push   %ebp
80105b86:	89 e5                	mov    %esp,%ebp
80105b88:	83 ec 08             	sub    $0x8,%esp
  assertState(p, check_state);
80105b8b:	83 ec 08             	sub    $0x8,%esp
80105b8e:	ff 75 10             	pushl  0x10(%ebp)
80105b91:	ff 75 0c             	pushl  0xc(%ebp)
80105b94:	e8 6a ff ff ff       	call   80105b03 <assertState>
80105b99:	83 c4 10             	add    $0x10,%esp
  removeFromStateList(sList, p);
80105b9c:	83 ec 08             	sub    $0x8,%esp
80105b9f:	ff 75 0c             	pushl  0xc(%ebp)
80105ba2:	ff 75 08             	pushl  0x8(%ebp)
80105ba5:	e8 4f fe ff ff       	call   801059f9 <removeFromStateList>
80105baa:	83 c4 10             	add    $0x10,%esp
  p->state = RUNNABLE;
80105bad:	8b 45 0c             	mov    0xc(%ebp),%eax
80105bb0:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  addToListRear(&ptable.pLists.ready[p->priority], p);
80105bb7:	8b 45 0c             	mov    0xc(%ebp),%eax
80105bba:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105bc0:	05 cc 09 00 00       	add    $0x9cc,%eax
80105bc5:	c1 e0 02             	shl    $0x2,%eax
80105bc8:	05 80 49 11 80       	add    $0x80114980,%eax
80105bcd:	83 c0 04             	add    $0x4,%eax
80105bd0:	83 ec 08             	sub    $0x8,%esp
80105bd3:	ff 75 0c             	pushl  0xc(%ebp)
80105bd6:	50                   	push   %eax
80105bd7:	e8 b8 fd ff ff       	call   80105994 <addToListRear>
80105bdc:	83 c4 10             	add    $0x10,%esp
  return;
80105bdf:	90                   	nop
}
80105be0:	c9                   	leave  
80105be1:	c3                   	ret    

80105be2 <passChildrenToInit>:

// Traverses the list passed in to find children of process p, and if found,
// sets their parent to initproc
void
passChildrenToInit(struct proc** sList, struct proc* p)
{
80105be2:	55                   	push   %ebp
80105be3:	89 e5                	mov    %esp,%ebp
80105be5:	83 ec 18             	sub    $0x18,%esp
  struct proc *current = *sList;
80105be8:	8b 45 08             	mov    0x8(%ebp),%eax
80105beb:	8b 00                	mov    (%eax),%eax
80105bed:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while(current){
80105bf0:	eb 3d                	jmp    80105c2f <passChildrenToInit+0x4d>
    if(current->parent == p){
80105bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bf5:	8b 40 14             	mov    0x14(%eax),%eax
80105bf8:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105bfb:	75 26                	jne    80105c23 <passChildrenToInit+0x41>
      current->parent = initproc;
80105bfd:	8b 15 68 d6 10 80    	mov    0x8010d668,%edx
80105c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c06:	89 50 14             	mov    %edx,0x14(%eax)
      if(&ptable.pLists.zombie == sList)
80105c09:	81 7d 08 d4 70 11 80 	cmpl   $0x801170d4,0x8(%ebp)
80105c10:	75 11                	jne    80105c23 <passChildrenToInit+0x41>
        wakeup1(initproc);
80105c12:	a1 68 d6 10 80       	mov    0x8010d668,%eax
80105c17:	83 ec 0c             	sub    $0xc,%esp
80105c1a:	50                   	push   %eax
80105c1b:	e8 2a f7 ff ff       	call   8010534a <wakeup1>
80105c20:	83 c4 10             	add    $0x10,%esp
    }
    current = current->next;
80105c23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c26:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105c2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
void
passChildrenToInit(struct proc** sList, struct proc* p)
{
  struct proc *current = *sList;

  while(current){
80105c2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c33:	75 bd                	jne    80105bf2 <passChildrenToInit+0x10>
      if(&ptable.pLists.zombie == sList)
        wakeup1(initproc);
    }
    current = current->next;
  }
  return;
80105c35:	90                   	nop
}
80105c36:	c9                   	leave  
80105c37:	c3                   	ret    

80105c38 <findChildren>:

// Searches a list for a child of process p, and returns that process if found.
// Otherwise return null
struct proc*
findChildren(struct proc** sList, struct proc* p)
{
80105c38:	55                   	push   %ebp
80105c39:	89 e5                	mov    %esp,%ebp
80105c3b:	83 ec 10             	sub    $0x10,%esp
  struct proc *current = *sList;
80105c3e:	8b 45 08             	mov    0x8(%ebp),%eax
80105c41:	8b 00                	mov    (%eax),%eax
80105c43:	89 45 fc             	mov    %eax,-0x4(%ebp)

  while(current){
80105c46:	eb 1c                	jmp    80105c64 <findChildren+0x2c>
    if(current->parent == p)
80105c48:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105c4b:	8b 40 14             	mov    0x14(%eax),%eax
80105c4e:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105c51:	75 05                	jne    80105c58 <findChildren+0x20>
      return current;
80105c53:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105c56:	eb 17                	jmp    80105c6f <findChildren+0x37>
    else
      current = current->next;
80105c58:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105c5b:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105c61:	89 45 fc             	mov    %eax,-0x4(%ebp)
struct proc*
findChildren(struct proc** sList, struct proc* p)
{
  struct proc *current = *sList;

  while(current){
80105c64:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105c68:	75 de                	jne    80105c48 <findChildren+0x10>
    if(current->parent == p)
      return current;
    else
      current = current->next;
  }
  return 0;
80105c6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105c6f:	c9                   	leave  
80105c70:	c3                   	ret    

80105c71 <findPid>:

// Searches a list for a process with the passed in pid, and returns that
// process if found
struct proc*
findPid(struct proc** sList, int pid)
{
80105c71:	55                   	push   %ebp
80105c72:	89 e5                	mov    %esp,%ebp
80105c74:	83 ec 10             	sub    $0x10,%esp
  struct proc *current;

  if(!*sList)
80105c77:	8b 45 08             	mov    0x8(%ebp),%eax
80105c7a:	8b 00                	mov    (%eax),%eax
80105c7c:	85 c0                	test   %eax,%eax
80105c7e:	75 07                	jne    80105c87 <findPid+0x16>
    return 0;
80105c80:	b8 00 00 00 00       	mov    $0x0,%eax
80105c85:	eb 33                	jmp    80105cba <findPid+0x49>
  current = *sList;
80105c87:	8b 45 08             	mov    0x8(%ebp),%eax
80105c8a:	8b 00                	mov    (%eax),%eax
80105c8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(current){
80105c8f:	eb 1e                	jmp    80105caf <findPid+0x3e>
    if(current->pid == pid)
80105c91:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105c94:	8b 50 10             	mov    0x10(%eax),%edx
80105c97:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c9a:	39 c2                	cmp    %eax,%edx
80105c9c:	75 05                	jne    80105ca3 <findPid+0x32>
      return current;
80105c9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105ca1:	eb 17                	jmp    80105cba <findPid+0x49>
    else
      current = current->next;
80105ca3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105ca6:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105cac:	89 45 fc             	mov    %eax,-0x4(%ebp)
  struct proc *current;

  if(!*sList)
    return 0;
  current = *sList;
  while(current){
80105caf:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105cb3:	75 dc                	jne    80105c91 <findPid+0x20>
    if(current->pid == pid)
      return current;
    else
      current = current->next;
  }
  return 0;
80105cb5:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105cba:	c9                   	leave  
80105cbb:	c3                   	ret    

80105cbc <printReadyList>:

// Prints all processes in the ready list by their PID
void
printReadyList(void)
{
80105cbc:	55                   	push   %ebp
80105cbd:	89 e5                	mov    %esp,%ebp
80105cbf:	83 ec 18             	sub    $0x18,%esp
  cprintf("Ready List Processes:\n");
80105cc2:	83 ec 0c             	sub    $0xc,%esp
80105cc5:	68 6c 9d 10 80       	push   $0x80109d6c
80105cca:	e8 f7 a6 ff ff       	call   801003c6 <cprintf>
80105ccf:	83 c4 10             	add    $0x10,%esp
  for(int i = 0; i <= MAX; i++){
80105cd2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105cd9:	e9 9a 00 00 00       	jmp    80105d78 <printReadyList+0xbc>
    cprintf("%d: ", i);
80105cde:	83 ec 08             	sub    $0x8,%esp
80105ce1:	ff 75 f4             	pushl  -0xc(%ebp)
80105ce4:	68 83 9d 10 80       	push   $0x80109d83
80105ce9:	e8 d8 a6 ff ff       	call   801003c6 <cprintf>
80105cee:	83 c4 10             	add    $0x10,%esp
    struct proc *current = ptable.pLists.ready[i];
80105cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cf4:	05 cc 09 00 00       	add    $0x9cc,%eax
80105cf9:	8b 04 85 84 49 11 80 	mov    -0x7feeb67c(,%eax,4),%eax
80105d00:	89 45 f0             	mov    %eax,-0x10(%ebp)

    if(!current){
80105d03:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d07:	75 55                	jne    80105d5e <printReadyList+0xa2>
      cprintf("There are no processes in the queue");
80105d09:	83 ec 0c             	sub    $0xc,%esp
80105d0c:	68 88 9d 10 80       	push   $0x80109d88
80105d11:	e8 b0 a6 ff ff       	call   801003c6 <cprintf>
80105d16:	83 c4 10             	add    $0x10,%esp
80105d19:	eb 49                	jmp    80105d64 <printReadyList+0xa8>
    }
    else{
      while(current){
        cprintf("(%d, %d)", current->pid, current->budget);
80105d1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d1e:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
80105d24:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d27:	8b 40 10             	mov    0x10(%eax),%eax
80105d2a:	83 ec 04             	sub    $0x4,%esp
80105d2d:	52                   	push   %edx
80105d2e:	50                   	push   %eax
80105d2f:	68 ac 9d 10 80       	push   $0x80109dac
80105d34:	e8 8d a6 ff ff       	call   801003c6 <cprintf>
80105d39:	83 c4 10             	add    $0x10,%esp
        current = current->next;
80105d3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d3f:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105d45:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if(current)
80105d48:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d4c:	74 10                	je     80105d5e <printReadyList+0xa2>
          cprintf("->");
80105d4e:	83 ec 0c             	sub    $0xc,%esp
80105d51:	68 b5 9d 10 80       	push   $0x80109db5
80105d56:	e8 6b a6 ff ff       	call   801003c6 <cprintf>
80105d5b:	83 c4 10             	add    $0x10,%esp

    if(!current){
      cprintf("There are no processes in the queue");
    }
    else{
      while(current){
80105d5e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105d62:	75 b7                	jne    80105d1b <printReadyList+0x5f>
        current = current->next;
        if(current)
          cprintf("->");
      }
    }
    cprintf("\n");
80105d64:	83 ec 0c             	sub    $0xc,%esp
80105d67:	68 9b 9c 10 80       	push   $0x80109c9b
80105d6c:	e8 55 a6 ff ff       	call   801003c6 <cprintf>
80105d71:	83 c4 10             	add    $0x10,%esp
// Prints all processes in the ready list by their PID
void
printReadyList(void)
{
  cprintf("Ready List Processes:\n");
  for(int i = 0; i <= MAX; i++){
80105d74:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105d78:	83 7d f4 05          	cmpl   $0x5,-0xc(%ebp)
80105d7c:	0f 8e 5c ff ff ff    	jle    80105cde <printReadyList+0x22>
          cprintf("->");
      }
    }
    cprintf("\n");
  }
  return;
80105d82:	90                   	nop
}
80105d83:	c9                   	leave  
80105d84:	c3                   	ret    

80105d85 <printFree>:

// Prints the number of unused processes
void
printFree(void)
{
80105d85:	55                   	push   %ebp
80105d86:	89 e5                	mov    %esp,%ebp
80105d88:	83 ec 18             	sub    $0x18,%esp
  int count = 0;
80105d8b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  struct proc *current = ptable.pLists.free;
80105d92:	a1 cc 70 11 80       	mov    0x801170cc,%eax
80105d97:	89 45 f0             	mov    %eax,-0x10(%ebp)

  while(current){
80105d9a:	eb 10                	jmp    80105dac <printFree+0x27>
    current = current->next;
80105d9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d9f:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105da5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    count++;
80105da8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
printFree(void)
{
  int count = 0;
  struct proc *current = ptable.pLists.free;

  while(current){
80105dac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105db0:	75 ea                	jne    80105d9c <printFree+0x17>
    current = current->next;
    count++;
  }

  cprintf("Free List Size: %d processes\n", count);
80105db2:	83 ec 08             	sub    $0x8,%esp
80105db5:	ff 75 f4             	pushl  -0xc(%ebp)
80105db8:	68 b8 9d 10 80       	push   $0x80109db8
80105dbd:	e8 04 a6 ff ff       	call   801003c6 <cprintf>
80105dc2:	83 c4 10             	add    $0x10,%esp
}
80105dc5:	90                   	nop
80105dc6:	c9                   	leave  
80105dc7:	c3                   	ret    

80105dc8 <printSleepList>:

// Prints all processes in the sleep list by their PID
void
printSleepList(void)
{
80105dc8:	55                   	push   %ebp
80105dc9:	89 e5                	mov    %esp,%ebp
80105dcb:	83 ec 08             	sub    $0x8,%esp
  cprintf("Sleep List Processes:\n");
80105dce:	83 ec 0c             	sub    $0xc,%esp
80105dd1:	68 d6 9d 10 80       	push   $0x80109dd6
80105dd6:	e8 eb a5 ff ff       	call   801003c6 <cprintf>
80105ddb:	83 c4 10             	add    $0x10,%esp
  printProcesses(ptable.pLists.sleep);
80105dde:	a1 d0 70 11 80       	mov    0x801170d0,%eax
80105de3:	83 ec 0c             	sub    $0xc,%esp
80105de6:	50                   	push   %eax
80105de7:	e8 b0 00 00 00       	call   80105e9c <printProcesses>
80105dec:	83 c4 10             	add    $0x10,%esp
  return;
80105def:	90                   	nop
}
80105df0:	c9                   	leave  
80105df1:	c3                   	ret    

80105df2 <printZombieList>:

// Prints all processes by their PID and their parent PID
void
printZombieList(void)
{
80105df2:	55                   	push   %ebp
80105df3:	89 e5                	mov    %esp,%ebp
80105df5:	83 ec 18             	sub    $0x18,%esp
  int ppid;
  struct proc *current = ptable.pLists.zombie;
80105df8:	a1 d4 70 11 80       	mov    0x801170d4,%eax
80105dfd:	89 45 f0             	mov    %eax,-0x10(%ebp)

  cprintf("Zombie List Processes:\n");
80105e00:	83 ec 0c             	sub    $0xc,%esp
80105e03:	68 ed 9d 10 80       	push   $0x80109ded
80105e08:	e8 b9 a5 ff ff       	call   801003c6 <cprintf>
80105e0d:	83 c4 10             	add    $0x10,%esp

  if(!current){
80105e10:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105e14:	75 6d                	jne    80105e83 <printZombieList+0x91>
    cprintf("There are no processes in the list\n");
80105e16:	83 ec 0c             	sub    $0xc,%esp
80105e19:	68 08 9e 10 80       	push   $0x80109e08
80105e1e:	e8 a3 a5 ff ff       	call   801003c6 <cprintf>
80105e23:	83 c4 10             	add    $0x10,%esp
    return;
80105e26:	eb 72                	jmp    80105e9a <printZombieList+0xa8>
  }
  while(current){
    if(!current->parent)
80105e28:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e2b:	8b 40 14             	mov    0x14(%eax),%eax
80105e2e:	85 c0                	test   %eax,%eax
80105e30:	75 09                	jne    80105e3b <printZombieList+0x49>
      ppid = 1;
80105e32:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80105e39:	eb 0c                	jmp    80105e47 <printZombieList+0x55>
    else
      ppid = current->parent->pid;
80105e3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e3e:	8b 40 14             	mov    0x14(%eax),%eax
80105e41:	8b 40 10             	mov    0x10(%eax),%eax
80105e44:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("(%d, %d)", current->pid, ppid);
80105e47:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e4a:	8b 40 10             	mov    0x10(%eax),%eax
80105e4d:	83 ec 04             	sub    $0x4,%esp
80105e50:	ff 75 f4             	pushl  -0xc(%ebp)
80105e53:	50                   	push   %eax
80105e54:	68 ac 9d 10 80       	push   $0x80109dac
80105e59:	e8 68 a5 ff ff       	call   801003c6 <cprintf>
80105e5e:	83 c4 10             	add    $0x10,%esp
    current = current->next;
80105e61:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e64:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105e6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(current)
80105e6d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105e71:	74 10                	je     80105e83 <printZombieList+0x91>
      cprintf("->");
80105e73:	83 ec 0c             	sub    $0xc,%esp
80105e76:	68 b5 9d 10 80       	push   $0x80109db5
80105e7b:	e8 46 a5 ff ff       	call   801003c6 <cprintf>
80105e80:	83 c4 10             	add    $0x10,%esp

  if(!current){
    cprintf("There are no processes in the list\n");
    return;
  }
  while(current){
80105e83:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105e87:	75 9f                	jne    80105e28 <printZombieList+0x36>
    cprintf("(%d, %d)", current->pid, ppid);
    current = current->next;
    if(current)
      cprintf("->");
  }
  cprintf("\n");
80105e89:	83 ec 0c             	sub    $0xc,%esp
80105e8c:	68 9b 9c 10 80       	push   $0x80109c9b
80105e91:	e8 30 a5 ff ff       	call   801003c6 <cprintf>
80105e96:	83 c4 10             	add    $0x10,%esp
  return;
80105e99:	90                   	nop

}
80105e9a:	c9                   	leave  
80105e9b:	c3                   	ret    

80105e9c <printProcesses>:

// Traverses the list passed in and prints corresponding processes by PID
void
printProcesses(struct proc* sList)
{
80105e9c:	55                   	push   %ebp
80105e9d:	89 e5                	mov    %esp,%ebp
80105e9f:	83 ec 18             	sub    $0x18,%esp
  struct proc *current = sList;
80105ea2:	8b 45 08             	mov    0x8(%ebp),%eax
80105ea5:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(!current){
80105ea8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105eac:	75 4b                	jne    80105ef9 <printProcesses+0x5d>
    cprintf("There are no processes in the list\n");
80105eae:	83 ec 0c             	sub    $0xc,%esp
80105eb1:	68 08 9e 10 80       	push   $0x80109e08
80105eb6:	e8 0b a5 ff ff       	call   801003c6 <cprintf>
80105ebb:	83 c4 10             	add    $0x10,%esp
    return;
80105ebe:	eb 50                	jmp    80105f10 <printProcesses+0x74>
  }
  while(current){
    cprintf("%d", current->pid);
80105ec0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ec3:	8b 40 10             	mov    0x10(%eax),%eax
80105ec6:	83 ec 08             	sub    $0x8,%esp
80105ec9:	50                   	push   %eax
80105eca:	68 2c 9e 10 80       	push   $0x80109e2c
80105ecf:	e8 f2 a4 ff ff       	call   801003c6 <cprintf>
80105ed4:	83 c4 10             	add    $0x10,%esp
    current = current->next;
80105ed7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105eda:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105ee0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(current)
80105ee3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ee7:	74 10                	je     80105ef9 <printProcesses+0x5d>
      cprintf("->");
80105ee9:	83 ec 0c             	sub    $0xc,%esp
80105eec:	68 b5 9d 10 80       	push   $0x80109db5
80105ef1:	e8 d0 a4 ff ff       	call   801003c6 <cprintf>
80105ef6:	83 c4 10             	add    $0x10,%esp

  if(!current){
    cprintf("There are no processes in the list\n");
    return;
  }
  while(current){
80105ef9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105efd:	75 c1                	jne    80105ec0 <printProcesses+0x24>
    cprintf("%d", current->pid);
    current = current->next;
    if(current)
      cprintf("->");
  }
  cprintf("\n");
80105eff:	83 ec 0c             	sub    $0xc,%esp
80105f02:	68 9b 9c 10 80       	push   $0x80109c9b
80105f07:	e8 ba a4 ff ff       	call   801003c6 <cprintf>
80105f0c:	83 c4 10             	add    $0x10,%esp
  return;
80105f0f:	90                   	nop
}
80105f10:	c9                   	leave  
80105f11:	c3                   	ret    

80105f12 <setpriority>:
#endif

#ifdef CS333_P3P4
int
setpriority(int pid, int priority)
{
80105f12:	55                   	push   %ebp
80105f13:	89 e5                	mov    %esp,%ebp
80105f15:	83 ec 10             	sub    $0x10,%esp
  struct proc *p = 0;
80105f18:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

  if(priority > MAX || priority < 0)
80105f1f:	83 7d 0c 05          	cmpl   $0x5,0xc(%ebp)
80105f23:	7f 06                	jg     80105f2b <setpriority+0x19>
80105f25:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105f29:	79 0a                	jns    80105f35 <setpriority+0x23>
    return -1;
80105f2b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f30:	e9 b1 00 00 00       	jmp    80105fe6 <setpriority+0xd4>
  p = findPid(&ptable.pLists.sleep, pid);
80105f35:	ff 75 08             	pushl  0x8(%ebp)
80105f38:	68 d0 70 11 80       	push   $0x801170d0
80105f3d:	e8 2f fd ff ff       	call   80105c71 <findPid>
80105f42:	83 c4 08             	add    $0x8,%esp
80105f45:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(p == 0)
80105f48:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105f4c:	75 13                	jne    80105f61 <setpriority+0x4f>
    p = findPid(&ptable.pLists.running, pid);
80105f4e:	ff 75 08             	pushl  0x8(%ebp)
80105f51:	68 d8 70 11 80       	push   $0x801170d8
80105f56:	e8 16 fd ff ff       	call   80105c71 <findPid>
80105f5b:	83 c4 08             	add    $0x8,%esp
80105f5e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(p == 0){
80105f61:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105f65:	75 54                	jne    80105fbb <setpriority+0xa9>
    for(int i = 0; i <= MAX; i++){
80105f67:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105f6e:	eb 45                	jmp    80105fb5 <setpriority+0xa3>
      if(p == 0){
80105f70:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105f74:	75 3b                	jne    80105fb1 <setpriority+0x9f>
        p = findPid(&ptable.pLists.ready[i], pid);
80105f76:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105f79:	05 cc 09 00 00       	add    $0x9cc,%eax
80105f7e:	c1 e0 02             	shl    $0x2,%eax
80105f81:	05 80 49 11 80       	add    $0x80114980,%eax
80105f86:	83 c0 04             	add    $0x4,%eax
80105f89:	ff 75 08             	pushl  0x8(%ebp)
80105f8c:	50                   	push   %eax
80105f8d:	e8 df fc ff ff       	call   80105c71 <findPid>
80105f92:	83 c4 08             	add    $0x8,%esp
80105f95:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if(p != 0 && i == 0 && priority == 0)
80105f98:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105f9c:	74 13                	je     80105fb1 <setpriority+0x9f>
80105f9e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
80105fa2:	75 0d                	jne    80105fb1 <setpriority+0x9f>
80105fa4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105fa8:	75 07                	jne    80105fb1 <setpriority+0x9f>
          return 0;
80105faa:	b8 00 00 00 00       	mov    $0x0,%eax
80105faf:	eb 35                	jmp    80105fe6 <setpriority+0xd4>
  p = findPid(&ptable.pLists.sleep, pid);

  if(p == 0)
    p = findPid(&ptable.pLists.running, pid);
  if(p == 0){
    for(int i = 0; i <= MAX; i++){
80105fb1:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105fb5:	83 7d f8 05          	cmpl   $0x5,-0x8(%ebp)
80105fb9:	7e b5                	jle    80105f70 <setpriority+0x5e>
          return 0;
      }
    }
  }

  if(p == 0)
80105fbb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105fbf:	75 07                	jne    80105fc8 <setpriority+0xb6>
    return -1;
80105fc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fc6:	eb 1e                	jmp    80105fe6 <setpriority+0xd4>
  else{
    p->priority = priority;
80105fc8:	8b 55 0c             	mov    0xc(%ebp),%edx
80105fcb:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105fce:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
    p->budget = 50;
80105fd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105fd7:	c7 80 98 00 00 00 32 	movl   $0x32,0x98(%eax)
80105fde:	00 00 00 
    return 0;
80105fe1:	b8 00 00 00 00       	mov    $0x0,%eax
  }
}
80105fe6:	c9                   	leave  
80105fe7:	c3                   	ret    

80105fe8 <adjustPriority>:

void
adjustPriority(struct proc** sList, int listPriority){
80105fe8:	55                   	push   %ebp
80105fe9:	89 e5                	mov    %esp,%ebp
80105feb:	83 ec 18             	sub    $0x18,%esp
  struct proc *current = *sList;
80105fee:	8b 45 08             	mov    0x8(%ebp),%eax
80105ff1:	8b 00                	mov    (%eax),%eax
80105ff3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct proc *temp;

  while(current){
80105ff6:	e9 09 01 00 00       	jmp    80106104 <adjustPriority+0x11c>
    if(current->priority > 0 &&
80105ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ffe:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80106004:	85 c0                	test   %eax,%eax
80106006:	74 45                	je     8010604d <adjustPriority+0x65>
80106008:	81 7d 08 d0 70 11 80 	cmpl   $0x801170d0,0x8(%ebp)
8010600f:	74 09                	je     8010601a <adjustPriority+0x32>
        (sList == &ptable.pLists.sleep || sList == &ptable.pLists.running)){
80106011:	81 7d 08 d8 70 11 80 	cmpl   $0x801170d8,0x8(%ebp)
80106018:	75 33                	jne    8010604d <adjustPriority+0x65>
      current->priority = (current->priority) - 1;
8010601a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010601d:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80106023:	8d 50 ff             	lea    -0x1(%eax),%edx
80106026:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106029:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
      current->budget = 50;
8010602f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106032:	c7 80 98 00 00 00 32 	movl   $0x32,0x98(%eax)
80106039:	00 00 00 
      current = current->next;
8010603c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010603f:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106045:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106048:	e9 b7 00 00 00       	jmp    80106104 <adjustPriority+0x11c>
    }
    else{
      if(current->priority != listPriority){
8010604d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106050:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
80106056:	8b 45 0c             	mov    0xc(%ebp),%eax
80106059:	39 c2                	cmp    %eax,%edx
8010605b:	74 1d                	je     8010607a <adjustPriority+0x92>
        cprintf("The priority of the process doesn't match its queue!");
8010605d:	83 ec 0c             	sub    $0xc,%esp
80106060:	68 30 9e 10 80       	push   $0x80109e30
80106065:	e8 5c a3 ff ff       	call   801003c6 <cprintf>
8010606a:	83 c4 10             	add    $0x10,%esp
        panic("Priorities don't match!");
8010606d:	83 ec 0c             	sub    $0xc,%esp
80106070:	68 65 9e 10 80       	push   $0x80109e65
80106075:	e8 ec a4 ff ff       	call   80100566 <panic>
      }
      else{
        temp = current;
8010607a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010607d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        current = current->next;
80106080:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106083:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106089:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if(temp->priority != 0){
8010608c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010608f:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80106095:	85 c0                	test   %eax,%eax
80106097:	74 6b                	je     80106104 <adjustPriority+0x11c>
          temp->priority = (temp->priority) - 1;
80106099:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010609c:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801060a2:	8d 50 ff             	lea    -0x1(%eax),%edx
801060a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060a8:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
          temp->budget = 50;
801060ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060b1:	c7 80 98 00 00 00 32 	movl   $0x32,0x98(%eax)
801060b8:	00 00 00 
          assertState(temp, RUNNABLE);
801060bb:	83 ec 08             	sub    $0x8,%esp
801060be:	6a 03                	push   $0x3
801060c0:	ff 75 f0             	pushl  -0x10(%ebp)
801060c3:	e8 3b fa ff ff       	call   80105b03 <assertState>
801060c8:	83 c4 10             	add    $0x10,%esp
          removeFromStateList(sList, temp);
801060cb:	83 ec 08             	sub    $0x8,%esp
801060ce:	ff 75 f0             	pushl  -0x10(%ebp)
801060d1:	ff 75 08             	pushl  0x8(%ebp)
801060d4:	e8 20 f9 ff ff       	call   801059f9 <removeFromStateList>
801060d9:	83 c4 10             	add    $0x10,%esp
          addToListRear(&ptable.pLists.ready[temp->priority], temp);
801060dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060df:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801060e5:	05 cc 09 00 00       	add    $0x9cc,%eax
801060ea:	c1 e0 02             	shl    $0x2,%eax
801060ed:	05 80 49 11 80       	add    $0x80114980,%eax
801060f2:	83 c0 04             	add    $0x4,%eax
801060f5:	83 ec 08             	sub    $0x8,%esp
801060f8:	ff 75 f0             	pushl  -0x10(%ebp)
801060fb:	50                   	push   %eax
801060fc:	e8 93 f8 ff ff       	call   80105994 <addToListRear>
80106101:	83 c4 10             	add    $0x10,%esp
void
adjustPriority(struct proc** sList, int listPriority){
  struct proc *current = *sList;
  struct proc *temp;

  while(current){
80106104:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106108:	0f 85 ed fe ff ff    	jne    80105ffb <adjustPriority+0x13>
          addToListRear(&ptable.pLists.ready[temp->priority], temp);
        }
      }
    }
  }
}
8010610e:	90                   	nop
8010610f:	c9                   	leave  
80106110:	c3                   	ret    

80106111 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80106111:	55                   	push   %ebp
80106112:	89 e5                	mov    %esp,%ebp
80106114:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80106117:	9c                   	pushf  
80106118:	58                   	pop    %eax
80106119:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010611c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010611f:	c9                   	leave  
80106120:	c3                   	ret    

80106121 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80106121:	55                   	push   %ebp
80106122:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80106124:	fa                   	cli    
}
80106125:	90                   	nop
80106126:	5d                   	pop    %ebp
80106127:	c3                   	ret    

80106128 <sti>:

static inline void
sti(void)
{
80106128:	55                   	push   %ebp
80106129:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010612b:	fb                   	sti    
}
8010612c:	90                   	nop
8010612d:	5d                   	pop    %ebp
8010612e:	c3                   	ret    

8010612f <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
8010612f:	55                   	push   %ebp
80106130:	89 e5                	mov    %esp,%ebp
80106132:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80106135:	8b 55 08             	mov    0x8(%ebp),%edx
80106138:	8b 45 0c             	mov    0xc(%ebp),%eax
8010613b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010613e:	f0 87 02             	lock xchg %eax,(%edx)
80106141:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80106144:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106147:	c9                   	leave  
80106148:	c3                   	ret    

80106149 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80106149:	55                   	push   %ebp
8010614a:	89 e5                	mov    %esp,%ebp
  lk->name = name;
8010614c:	8b 45 08             	mov    0x8(%ebp),%eax
8010614f:	8b 55 0c             	mov    0xc(%ebp),%edx
80106152:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80106155:	8b 45 08             	mov    0x8(%ebp),%eax
80106158:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
8010615e:	8b 45 08             	mov    0x8(%ebp),%eax
80106161:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80106168:	90                   	nop
80106169:	5d                   	pop    %ebp
8010616a:	c3                   	ret    

8010616b <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
8010616b:	55                   	push   %ebp
8010616c:	89 e5                	mov    %esp,%ebp
8010616e:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80106171:	e8 52 01 00 00       	call   801062c8 <pushcli>
  if(holding(lk))
80106176:	8b 45 08             	mov    0x8(%ebp),%eax
80106179:	83 ec 0c             	sub    $0xc,%esp
8010617c:	50                   	push   %eax
8010617d:	e8 1c 01 00 00       	call   8010629e <holding>
80106182:	83 c4 10             	add    $0x10,%esp
80106185:	85 c0                	test   %eax,%eax
80106187:	74 0d                	je     80106196 <acquire+0x2b>
    panic("acquire");
80106189:	83 ec 0c             	sub    $0xc,%esp
8010618c:	68 7d 9e 10 80       	push   $0x80109e7d
80106191:	e8 d0 a3 ff ff       	call   80100566 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80106196:	90                   	nop
80106197:	8b 45 08             	mov    0x8(%ebp),%eax
8010619a:	83 ec 08             	sub    $0x8,%esp
8010619d:	6a 01                	push   $0x1
8010619f:	50                   	push   %eax
801061a0:	e8 8a ff ff ff       	call   8010612f <xchg>
801061a5:	83 c4 10             	add    $0x10,%esp
801061a8:	85 c0                	test   %eax,%eax
801061aa:	75 eb                	jne    80106197 <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
801061ac:	8b 45 08             	mov    0x8(%ebp),%eax
801061af:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801061b6:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
801061b9:	8b 45 08             	mov    0x8(%ebp),%eax
801061bc:	83 c0 0c             	add    $0xc,%eax
801061bf:	83 ec 08             	sub    $0x8,%esp
801061c2:	50                   	push   %eax
801061c3:	8d 45 08             	lea    0x8(%ebp),%eax
801061c6:	50                   	push   %eax
801061c7:	e8 58 00 00 00       	call   80106224 <getcallerpcs>
801061cc:	83 c4 10             	add    $0x10,%esp
}
801061cf:	90                   	nop
801061d0:	c9                   	leave  
801061d1:	c3                   	ret    

801061d2 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
801061d2:	55                   	push   %ebp
801061d3:	89 e5                	mov    %esp,%ebp
801061d5:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
801061d8:	83 ec 0c             	sub    $0xc,%esp
801061db:	ff 75 08             	pushl  0x8(%ebp)
801061de:	e8 bb 00 00 00       	call   8010629e <holding>
801061e3:	83 c4 10             	add    $0x10,%esp
801061e6:	85 c0                	test   %eax,%eax
801061e8:	75 0d                	jne    801061f7 <release+0x25>
    panic("release");
801061ea:	83 ec 0c             	sub    $0xc,%esp
801061ed:	68 85 9e 10 80       	push   $0x80109e85
801061f2:	e8 6f a3 ff ff       	call   80100566 <panic>

  lk->pcs[0] = 0;
801061f7:	8b 45 08             	mov    0x8(%ebp),%eax
801061fa:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80106201:	8b 45 08             	mov    0x8(%ebp),%eax
80106204:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
8010620b:	8b 45 08             	mov    0x8(%ebp),%eax
8010620e:	83 ec 08             	sub    $0x8,%esp
80106211:	6a 00                	push   $0x0
80106213:	50                   	push   %eax
80106214:	e8 16 ff ff ff       	call   8010612f <xchg>
80106219:	83 c4 10             	add    $0x10,%esp

  popcli();
8010621c:	e8 ec 00 00 00       	call   8010630d <popcli>
}
80106221:	90                   	nop
80106222:	c9                   	leave  
80106223:	c3                   	ret    

80106224 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80106224:	55                   	push   %ebp
80106225:	89 e5                	mov    %esp,%ebp
80106227:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
8010622a:	8b 45 08             	mov    0x8(%ebp),%eax
8010622d:	83 e8 08             	sub    $0x8,%eax
80106230:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80106233:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
8010623a:	eb 38                	jmp    80106274 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010623c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80106240:	74 53                	je     80106295 <getcallerpcs+0x71>
80106242:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80106249:	76 4a                	jbe    80106295 <getcallerpcs+0x71>
8010624b:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
8010624f:	74 44                	je     80106295 <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
80106251:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106254:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010625b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010625e:	01 c2                	add    %eax,%edx
80106260:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106263:	8b 40 04             	mov    0x4(%eax),%eax
80106266:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80106268:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010626b:	8b 00                	mov    (%eax),%eax
8010626d:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80106270:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80106274:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80106278:	7e c2                	jle    8010623c <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010627a:	eb 19                	jmp    80106295 <getcallerpcs+0x71>
    pcs[i] = 0;
8010627c:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010627f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80106286:	8b 45 0c             	mov    0xc(%ebp),%eax
80106289:	01 d0                	add    %edx,%eax
8010628b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80106291:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80106295:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80106299:	7e e1                	jle    8010627c <getcallerpcs+0x58>
    pcs[i] = 0;
}
8010629b:	90                   	nop
8010629c:	c9                   	leave  
8010629d:	c3                   	ret    

8010629e <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
8010629e:	55                   	push   %ebp
8010629f:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
801062a1:	8b 45 08             	mov    0x8(%ebp),%eax
801062a4:	8b 00                	mov    (%eax),%eax
801062a6:	85 c0                	test   %eax,%eax
801062a8:	74 17                	je     801062c1 <holding+0x23>
801062aa:	8b 45 08             	mov    0x8(%ebp),%eax
801062ad:	8b 50 08             	mov    0x8(%eax),%edx
801062b0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801062b6:	39 c2                	cmp    %eax,%edx
801062b8:	75 07                	jne    801062c1 <holding+0x23>
801062ba:	b8 01 00 00 00       	mov    $0x1,%eax
801062bf:	eb 05                	jmp    801062c6 <holding+0x28>
801062c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801062c6:	5d                   	pop    %ebp
801062c7:	c3                   	ret    

801062c8 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801062c8:	55                   	push   %ebp
801062c9:	89 e5                	mov    %esp,%ebp
801062cb:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
801062ce:	e8 3e fe ff ff       	call   80106111 <readeflags>
801062d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
801062d6:	e8 46 fe ff ff       	call   80106121 <cli>
  if(cpu->ncli++ == 0)
801062db:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801062e2:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
801062e8:	8d 48 01             	lea    0x1(%eax),%ecx
801062eb:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
801062f1:	85 c0                	test   %eax,%eax
801062f3:	75 15                	jne    8010630a <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
801062f5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801062fb:	8b 55 fc             	mov    -0x4(%ebp),%edx
801062fe:	81 e2 00 02 00 00    	and    $0x200,%edx
80106304:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
8010630a:	90                   	nop
8010630b:	c9                   	leave  
8010630c:	c3                   	ret    

8010630d <popcli>:

void
popcli(void)
{
8010630d:	55                   	push   %ebp
8010630e:	89 e5                	mov    %esp,%ebp
80106310:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80106313:	e8 f9 fd ff ff       	call   80106111 <readeflags>
80106318:	25 00 02 00 00       	and    $0x200,%eax
8010631d:	85 c0                	test   %eax,%eax
8010631f:	74 0d                	je     8010632e <popcli+0x21>
    panic("popcli - interruptible");
80106321:	83 ec 0c             	sub    $0xc,%esp
80106324:	68 8d 9e 10 80       	push   $0x80109e8d
80106329:	e8 38 a2 ff ff       	call   80100566 <panic>
  if(--cpu->ncli < 0)
8010632e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106334:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
8010633a:	83 ea 01             	sub    $0x1,%edx
8010633d:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80106343:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80106349:	85 c0                	test   %eax,%eax
8010634b:	79 0d                	jns    8010635a <popcli+0x4d>
    panic("popcli");
8010634d:	83 ec 0c             	sub    $0xc,%esp
80106350:	68 a4 9e 10 80       	push   $0x80109ea4
80106355:	e8 0c a2 ff ff       	call   80100566 <panic>
  if(cpu->ncli == 0 && cpu->intena)
8010635a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106360:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80106366:	85 c0                	test   %eax,%eax
80106368:	75 15                	jne    8010637f <popcli+0x72>
8010636a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106370:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80106376:	85 c0                	test   %eax,%eax
80106378:	74 05                	je     8010637f <popcli+0x72>
    sti();
8010637a:	e8 a9 fd ff ff       	call   80106128 <sti>
}
8010637f:	90                   	nop
80106380:	c9                   	leave  
80106381:	c3                   	ret    

80106382 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80106382:	55                   	push   %ebp
80106383:	89 e5                	mov    %esp,%ebp
80106385:	57                   	push   %edi
80106386:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80106387:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010638a:	8b 55 10             	mov    0x10(%ebp),%edx
8010638d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106390:	89 cb                	mov    %ecx,%ebx
80106392:	89 df                	mov    %ebx,%edi
80106394:	89 d1                	mov    %edx,%ecx
80106396:	fc                   	cld    
80106397:	f3 aa                	rep stos %al,%es:(%edi)
80106399:	89 ca                	mov    %ecx,%edx
8010639b:	89 fb                	mov    %edi,%ebx
8010639d:	89 5d 08             	mov    %ebx,0x8(%ebp)
801063a0:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801063a3:	90                   	nop
801063a4:	5b                   	pop    %ebx
801063a5:	5f                   	pop    %edi
801063a6:	5d                   	pop    %ebp
801063a7:	c3                   	ret    

801063a8 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
801063a8:	55                   	push   %ebp
801063a9:	89 e5                	mov    %esp,%ebp
801063ab:	57                   	push   %edi
801063ac:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
801063ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
801063b0:	8b 55 10             	mov    0x10(%ebp),%edx
801063b3:	8b 45 0c             	mov    0xc(%ebp),%eax
801063b6:	89 cb                	mov    %ecx,%ebx
801063b8:	89 df                	mov    %ebx,%edi
801063ba:	89 d1                	mov    %edx,%ecx
801063bc:	fc                   	cld    
801063bd:	f3 ab                	rep stos %eax,%es:(%edi)
801063bf:	89 ca                	mov    %ecx,%edx
801063c1:	89 fb                	mov    %edi,%ebx
801063c3:	89 5d 08             	mov    %ebx,0x8(%ebp)
801063c6:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801063c9:	90                   	nop
801063ca:	5b                   	pop    %ebx
801063cb:	5f                   	pop    %edi
801063cc:	5d                   	pop    %ebp
801063cd:	c3                   	ret    

801063ce <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801063ce:	55                   	push   %ebp
801063cf:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
801063d1:	8b 45 08             	mov    0x8(%ebp),%eax
801063d4:	83 e0 03             	and    $0x3,%eax
801063d7:	85 c0                	test   %eax,%eax
801063d9:	75 43                	jne    8010641e <memset+0x50>
801063db:	8b 45 10             	mov    0x10(%ebp),%eax
801063de:	83 e0 03             	and    $0x3,%eax
801063e1:	85 c0                	test   %eax,%eax
801063e3:	75 39                	jne    8010641e <memset+0x50>
    c &= 0xFF;
801063e5:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801063ec:	8b 45 10             	mov    0x10(%ebp),%eax
801063ef:	c1 e8 02             	shr    $0x2,%eax
801063f2:	89 c1                	mov    %eax,%ecx
801063f4:	8b 45 0c             	mov    0xc(%ebp),%eax
801063f7:	c1 e0 18             	shl    $0x18,%eax
801063fa:	89 c2                	mov    %eax,%edx
801063fc:	8b 45 0c             	mov    0xc(%ebp),%eax
801063ff:	c1 e0 10             	shl    $0x10,%eax
80106402:	09 c2                	or     %eax,%edx
80106404:	8b 45 0c             	mov    0xc(%ebp),%eax
80106407:	c1 e0 08             	shl    $0x8,%eax
8010640a:	09 d0                	or     %edx,%eax
8010640c:	0b 45 0c             	or     0xc(%ebp),%eax
8010640f:	51                   	push   %ecx
80106410:	50                   	push   %eax
80106411:	ff 75 08             	pushl  0x8(%ebp)
80106414:	e8 8f ff ff ff       	call   801063a8 <stosl>
80106419:	83 c4 0c             	add    $0xc,%esp
8010641c:	eb 12                	jmp    80106430 <memset+0x62>
  } else
    stosb(dst, c, n);
8010641e:	8b 45 10             	mov    0x10(%ebp),%eax
80106421:	50                   	push   %eax
80106422:	ff 75 0c             	pushl  0xc(%ebp)
80106425:	ff 75 08             	pushl  0x8(%ebp)
80106428:	e8 55 ff ff ff       	call   80106382 <stosb>
8010642d:	83 c4 0c             	add    $0xc,%esp
  return dst;
80106430:	8b 45 08             	mov    0x8(%ebp),%eax
}
80106433:	c9                   	leave  
80106434:	c3                   	ret    

80106435 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80106435:	55                   	push   %ebp
80106436:	89 e5                	mov    %esp,%ebp
80106438:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
8010643b:	8b 45 08             	mov    0x8(%ebp),%eax
8010643e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80106441:	8b 45 0c             	mov    0xc(%ebp),%eax
80106444:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80106447:	eb 30                	jmp    80106479 <memcmp+0x44>
    if(*s1 != *s2)
80106449:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010644c:	0f b6 10             	movzbl (%eax),%edx
8010644f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106452:	0f b6 00             	movzbl (%eax),%eax
80106455:	38 c2                	cmp    %al,%dl
80106457:	74 18                	je     80106471 <memcmp+0x3c>
      return *s1 - *s2;
80106459:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010645c:	0f b6 00             	movzbl (%eax),%eax
8010645f:	0f b6 d0             	movzbl %al,%edx
80106462:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106465:	0f b6 00             	movzbl (%eax),%eax
80106468:	0f b6 c0             	movzbl %al,%eax
8010646b:	29 c2                	sub    %eax,%edx
8010646d:	89 d0                	mov    %edx,%eax
8010646f:	eb 1a                	jmp    8010648b <memcmp+0x56>
    s1++, s2++;
80106471:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106475:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80106479:	8b 45 10             	mov    0x10(%ebp),%eax
8010647c:	8d 50 ff             	lea    -0x1(%eax),%edx
8010647f:	89 55 10             	mov    %edx,0x10(%ebp)
80106482:	85 c0                	test   %eax,%eax
80106484:	75 c3                	jne    80106449 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80106486:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010648b:	c9                   	leave  
8010648c:	c3                   	ret    

8010648d <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
8010648d:	55                   	push   %ebp
8010648e:	89 e5                	mov    %esp,%ebp
80106490:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80106493:	8b 45 0c             	mov    0xc(%ebp),%eax
80106496:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80106499:	8b 45 08             	mov    0x8(%ebp),%eax
8010649c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
8010649f:	8b 45 fc             	mov    -0x4(%ebp),%eax
801064a2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801064a5:	73 54                	jae    801064fb <memmove+0x6e>
801064a7:	8b 55 fc             	mov    -0x4(%ebp),%edx
801064aa:	8b 45 10             	mov    0x10(%ebp),%eax
801064ad:	01 d0                	add    %edx,%eax
801064af:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801064b2:	76 47                	jbe    801064fb <memmove+0x6e>
    s += n;
801064b4:	8b 45 10             	mov    0x10(%ebp),%eax
801064b7:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
801064ba:	8b 45 10             	mov    0x10(%ebp),%eax
801064bd:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
801064c0:	eb 13                	jmp    801064d5 <memmove+0x48>
      *--d = *--s;
801064c2:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
801064c6:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
801064ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
801064cd:	0f b6 10             	movzbl (%eax),%edx
801064d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
801064d3:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801064d5:	8b 45 10             	mov    0x10(%ebp),%eax
801064d8:	8d 50 ff             	lea    -0x1(%eax),%edx
801064db:	89 55 10             	mov    %edx,0x10(%ebp)
801064de:	85 c0                	test   %eax,%eax
801064e0:	75 e0                	jne    801064c2 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801064e2:	eb 24                	jmp    80106508 <memmove+0x7b>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
801064e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
801064e7:	8d 50 01             	lea    0x1(%eax),%edx
801064ea:	89 55 f8             	mov    %edx,-0x8(%ebp)
801064ed:	8b 55 fc             	mov    -0x4(%ebp),%edx
801064f0:	8d 4a 01             	lea    0x1(%edx),%ecx
801064f3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
801064f6:	0f b6 12             	movzbl (%edx),%edx
801064f9:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801064fb:	8b 45 10             	mov    0x10(%ebp),%eax
801064fe:	8d 50 ff             	lea    -0x1(%eax),%edx
80106501:	89 55 10             	mov    %edx,0x10(%ebp)
80106504:	85 c0                	test   %eax,%eax
80106506:	75 dc                	jne    801064e4 <memmove+0x57>
      *d++ = *s++;

  return dst;
80106508:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010650b:	c9                   	leave  
8010650c:	c3                   	ret    

8010650d <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
8010650d:	55                   	push   %ebp
8010650e:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80106510:	ff 75 10             	pushl  0x10(%ebp)
80106513:	ff 75 0c             	pushl  0xc(%ebp)
80106516:	ff 75 08             	pushl  0x8(%ebp)
80106519:	e8 6f ff ff ff       	call   8010648d <memmove>
8010651e:	83 c4 0c             	add    $0xc,%esp
}
80106521:	c9                   	leave  
80106522:	c3                   	ret    

80106523 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80106523:	55                   	push   %ebp
80106524:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80106526:	eb 0c                	jmp    80106534 <strncmp+0x11>
    n--, p++, q++;
80106528:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010652c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80106530:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80106534:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106538:	74 1a                	je     80106554 <strncmp+0x31>
8010653a:	8b 45 08             	mov    0x8(%ebp),%eax
8010653d:	0f b6 00             	movzbl (%eax),%eax
80106540:	84 c0                	test   %al,%al
80106542:	74 10                	je     80106554 <strncmp+0x31>
80106544:	8b 45 08             	mov    0x8(%ebp),%eax
80106547:	0f b6 10             	movzbl (%eax),%edx
8010654a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010654d:	0f b6 00             	movzbl (%eax),%eax
80106550:	38 c2                	cmp    %al,%dl
80106552:	74 d4                	je     80106528 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80106554:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106558:	75 07                	jne    80106561 <strncmp+0x3e>
    return 0;
8010655a:	b8 00 00 00 00       	mov    $0x0,%eax
8010655f:	eb 16                	jmp    80106577 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80106561:	8b 45 08             	mov    0x8(%ebp),%eax
80106564:	0f b6 00             	movzbl (%eax),%eax
80106567:	0f b6 d0             	movzbl %al,%edx
8010656a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010656d:	0f b6 00             	movzbl (%eax),%eax
80106570:	0f b6 c0             	movzbl %al,%eax
80106573:	29 c2                	sub    %eax,%edx
80106575:	89 d0                	mov    %edx,%eax
}
80106577:	5d                   	pop    %ebp
80106578:	c3                   	ret    

80106579 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80106579:	55                   	push   %ebp
8010657a:	89 e5                	mov    %esp,%ebp
8010657c:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
8010657f:	8b 45 08             	mov    0x8(%ebp),%eax
80106582:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80106585:	90                   	nop
80106586:	8b 45 10             	mov    0x10(%ebp),%eax
80106589:	8d 50 ff             	lea    -0x1(%eax),%edx
8010658c:	89 55 10             	mov    %edx,0x10(%ebp)
8010658f:	85 c0                	test   %eax,%eax
80106591:	7e 2c                	jle    801065bf <strncpy+0x46>
80106593:	8b 45 08             	mov    0x8(%ebp),%eax
80106596:	8d 50 01             	lea    0x1(%eax),%edx
80106599:	89 55 08             	mov    %edx,0x8(%ebp)
8010659c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010659f:	8d 4a 01             	lea    0x1(%edx),%ecx
801065a2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801065a5:	0f b6 12             	movzbl (%edx),%edx
801065a8:	88 10                	mov    %dl,(%eax)
801065aa:	0f b6 00             	movzbl (%eax),%eax
801065ad:	84 c0                	test   %al,%al
801065af:	75 d5                	jne    80106586 <strncpy+0xd>
    ;
  while(n-- > 0)
801065b1:	eb 0c                	jmp    801065bf <strncpy+0x46>
    *s++ = 0;
801065b3:	8b 45 08             	mov    0x8(%ebp),%eax
801065b6:	8d 50 01             	lea    0x1(%eax),%edx
801065b9:	89 55 08             	mov    %edx,0x8(%ebp)
801065bc:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801065bf:	8b 45 10             	mov    0x10(%ebp),%eax
801065c2:	8d 50 ff             	lea    -0x1(%eax),%edx
801065c5:	89 55 10             	mov    %edx,0x10(%ebp)
801065c8:	85 c0                	test   %eax,%eax
801065ca:	7f e7                	jg     801065b3 <strncpy+0x3a>
    *s++ = 0;
  return os;
801065cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801065cf:	c9                   	leave  
801065d0:	c3                   	ret    

801065d1 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801065d1:	55                   	push   %ebp
801065d2:	89 e5                	mov    %esp,%ebp
801065d4:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801065d7:	8b 45 08             	mov    0x8(%ebp),%eax
801065da:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
801065dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801065e1:	7f 05                	jg     801065e8 <safestrcpy+0x17>
    return os;
801065e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801065e6:	eb 31                	jmp    80106619 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
801065e8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801065ec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801065f0:	7e 1e                	jle    80106610 <safestrcpy+0x3f>
801065f2:	8b 45 08             	mov    0x8(%ebp),%eax
801065f5:	8d 50 01             	lea    0x1(%eax),%edx
801065f8:	89 55 08             	mov    %edx,0x8(%ebp)
801065fb:	8b 55 0c             	mov    0xc(%ebp),%edx
801065fe:	8d 4a 01             	lea    0x1(%edx),%ecx
80106601:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80106604:	0f b6 12             	movzbl (%edx),%edx
80106607:	88 10                	mov    %dl,(%eax)
80106609:	0f b6 00             	movzbl (%eax),%eax
8010660c:	84 c0                	test   %al,%al
8010660e:	75 d8                	jne    801065e8 <safestrcpy+0x17>
    ;
  *s = 0;
80106610:	8b 45 08             	mov    0x8(%ebp),%eax
80106613:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80106616:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106619:	c9                   	leave  
8010661a:	c3                   	ret    

8010661b <strlen>:

int
strlen(const char *s)
{
8010661b:	55                   	push   %ebp
8010661c:	89 e5                	mov    %esp,%ebp
8010661e:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80106621:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80106628:	eb 04                	jmp    8010662e <strlen+0x13>
8010662a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010662e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106631:	8b 45 08             	mov    0x8(%ebp),%eax
80106634:	01 d0                	add    %edx,%eax
80106636:	0f b6 00             	movzbl (%eax),%eax
80106639:	84 c0                	test   %al,%al
8010663b:	75 ed                	jne    8010662a <strlen+0xf>
    ;
  return n;
8010663d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106640:	c9                   	leave  
80106641:	c3                   	ret    

80106642 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80106642:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80106646:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
8010664a:	55                   	push   %ebp
  pushl %ebx
8010664b:	53                   	push   %ebx
  pushl %esi
8010664c:	56                   	push   %esi
  pushl %edi
8010664d:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
8010664e:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80106650:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80106652:	5f                   	pop    %edi
  popl %esi
80106653:	5e                   	pop    %esi
  popl %ebx
80106654:	5b                   	pop    %ebx
  popl %ebp
80106655:	5d                   	pop    %ebp
  ret
80106656:	c3                   	ret    

80106657 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80106657:	55                   	push   %ebp
80106658:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
8010665a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106660:	8b 00                	mov    (%eax),%eax
80106662:	3b 45 08             	cmp    0x8(%ebp),%eax
80106665:	76 12                	jbe    80106679 <fetchint+0x22>
80106667:	8b 45 08             	mov    0x8(%ebp),%eax
8010666a:	8d 50 04             	lea    0x4(%eax),%edx
8010666d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106673:	8b 00                	mov    (%eax),%eax
80106675:	39 c2                	cmp    %eax,%edx
80106677:	76 07                	jbe    80106680 <fetchint+0x29>
    return -1;
80106679:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010667e:	eb 0f                	jmp    8010668f <fetchint+0x38>
  *ip = *(int*)(addr);
80106680:	8b 45 08             	mov    0x8(%ebp),%eax
80106683:	8b 10                	mov    (%eax),%edx
80106685:	8b 45 0c             	mov    0xc(%ebp),%eax
80106688:	89 10                	mov    %edx,(%eax)
  return 0;
8010668a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010668f:	5d                   	pop    %ebp
80106690:	c3                   	ret    

80106691 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80106691:	55                   	push   %ebp
80106692:	89 e5                	mov    %esp,%ebp
80106694:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
80106697:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010669d:	8b 00                	mov    (%eax),%eax
8010669f:	3b 45 08             	cmp    0x8(%ebp),%eax
801066a2:	77 07                	ja     801066ab <fetchstr+0x1a>
    return -1;
801066a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066a9:	eb 46                	jmp    801066f1 <fetchstr+0x60>
  *pp = (char*)addr;
801066ab:	8b 55 08             	mov    0x8(%ebp),%edx
801066ae:	8b 45 0c             	mov    0xc(%ebp),%eax
801066b1:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
801066b3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801066b9:	8b 00                	mov    (%eax),%eax
801066bb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
801066be:	8b 45 0c             	mov    0xc(%ebp),%eax
801066c1:	8b 00                	mov    (%eax),%eax
801066c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
801066c6:	eb 1c                	jmp    801066e4 <fetchstr+0x53>
    if(*s == 0)
801066c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801066cb:	0f b6 00             	movzbl (%eax),%eax
801066ce:	84 c0                	test   %al,%al
801066d0:	75 0e                	jne    801066e0 <fetchstr+0x4f>
      return s - *pp;
801066d2:	8b 55 fc             	mov    -0x4(%ebp),%edx
801066d5:	8b 45 0c             	mov    0xc(%ebp),%eax
801066d8:	8b 00                	mov    (%eax),%eax
801066da:	29 c2                	sub    %eax,%edx
801066dc:	89 d0                	mov    %edx,%eax
801066de:	eb 11                	jmp    801066f1 <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
801066e0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801066e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801066e7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801066ea:	72 dc                	jb     801066c8 <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
801066ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801066f1:	c9                   	leave  
801066f2:	c3                   	ret    

801066f3 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801066f3:	55                   	push   %ebp
801066f4:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801066f6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801066fc:	8b 40 18             	mov    0x18(%eax),%eax
801066ff:	8b 40 44             	mov    0x44(%eax),%eax
80106702:	8b 55 08             	mov    0x8(%ebp),%edx
80106705:	c1 e2 02             	shl    $0x2,%edx
80106708:	01 d0                	add    %edx,%eax
8010670a:	83 c0 04             	add    $0x4,%eax
8010670d:	ff 75 0c             	pushl  0xc(%ebp)
80106710:	50                   	push   %eax
80106711:	e8 41 ff ff ff       	call   80106657 <fetchint>
80106716:	83 c4 08             	add    $0x8,%esp
}
80106719:	c9                   	leave  
8010671a:	c3                   	ret    

8010671b <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
8010671b:	55                   	push   %ebp
8010671c:	89 e5                	mov    %esp,%ebp
8010671e:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
80106721:	8d 45 fc             	lea    -0x4(%ebp),%eax
80106724:	50                   	push   %eax
80106725:	ff 75 08             	pushl  0x8(%ebp)
80106728:	e8 c6 ff ff ff       	call   801066f3 <argint>
8010672d:	83 c4 08             	add    $0x8,%esp
80106730:	85 c0                	test   %eax,%eax
80106732:	79 07                	jns    8010673b <argptr+0x20>
    return -1;
80106734:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106739:	eb 3b                	jmp    80106776 <argptr+0x5b>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
8010673b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106741:	8b 00                	mov    (%eax),%eax
80106743:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106746:	39 d0                	cmp    %edx,%eax
80106748:	76 16                	jbe    80106760 <argptr+0x45>
8010674a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010674d:	89 c2                	mov    %eax,%edx
8010674f:	8b 45 10             	mov    0x10(%ebp),%eax
80106752:	01 c2                	add    %eax,%edx
80106754:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010675a:	8b 00                	mov    (%eax),%eax
8010675c:	39 c2                	cmp    %eax,%edx
8010675e:	76 07                	jbe    80106767 <argptr+0x4c>
    return -1;
80106760:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106765:	eb 0f                	jmp    80106776 <argptr+0x5b>
  *pp = (char*)i;
80106767:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010676a:	89 c2                	mov    %eax,%edx
8010676c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010676f:	89 10                	mov    %edx,(%eax)
  return 0;
80106771:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106776:	c9                   	leave  
80106777:	c3                   	ret    

80106778 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80106778:	55                   	push   %ebp
80106779:	89 e5                	mov    %esp,%ebp
8010677b:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010677e:	8d 45 fc             	lea    -0x4(%ebp),%eax
80106781:	50                   	push   %eax
80106782:	ff 75 08             	pushl  0x8(%ebp)
80106785:	e8 69 ff ff ff       	call   801066f3 <argint>
8010678a:	83 c4 08             	add    $0x8,%esp
8010678d:	85 c0                	test   %eax,%eax
8010678f:	79 07                	jns    80106798 <argstr+0x20>
    return -1;
80106791:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106796:	eb 0f                	jmp    801067a7 <argstr+0x2f>
  return fetchstr(addr, pp);
80106798:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010679b:	ff 75 0c             	pushl  0xc(%ebp)
8010679e:	50                   	push   %eax
8010679f:	e8 ed fe ff ff       	call   80106691 <fetchstr>
801067a4:	83 c4 08             	add    $0x8,%esp
}
801067a7:	c9                   	leave  
801067a8:	c3                   	ret    

801067a9 <syscall>:
};
#endif

void
syscall(void)
{
801067a9:	55                   	push   %ebp
801067aa:	89 e5                	mov    %esp,%ebp
801067ac:	53                   	push   %ebx
801067ad:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
801067b0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067b6:	8b 40 18             	mov    0x18(%eax),%eax
801067b9:	8b 40 1c             	mov    0x1c(%eax),%eax
801067bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801067bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801067c3:	7e 30                	jle    801067f5 <syscall+0x4c>
801067c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067c8:	83 f8 1e             	cmp    $0x1e,%eax
801067cb:	77 28                	ja     801067f5 <syscall+0x4c>
801067cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067d0:	8b 04 85 40 d0 10 80 	mov    -0x7fef2fc0(,%eax,4),%eax
801067d7:	85 c0                	test   %eax,%eax
801067d9:	74 1a                	je     801067f5 <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
801067db:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067e1:	8b 58 18             	mov    0x18(%eax),%ebx
801067e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067e7:	8b 04 85 40 d0 10 80 	mov    -0x7fef2fc0(,%eax,4),%eax
801067ee:	ff d0                	call   *%eax
801067f0:	89 43 1c             	mov    %eax,0x1c(%ebx)
801067f3:	eb 34                	jmp    80106829 <syscall+0x80>
    #ifdef PRINT_SYSCALLS
    cprintf("%s -> %d\n", syscallnames[num], proc->tf->eax);
    #endif    
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
801067f5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067fb:	8d 50 6c             	lea    0x6c(%eax),%edx
801067fe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// some code goes here
    #ifdef PRINT_SYSCALLS
    cprintf("%s -> %d\n", syscallnames[num], proc->tf->eax);
    #endif    
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80106804:	8b 40 10             	mov    0x10(%eax),%eax
80106807:	ff 75 f4             	pushl  -0xc(%ebp)
8010680a:	52                   	push   %edx
8010680b:	50                   	push   %eax
8010680c:	68 ab 9e 10 80       	push   $0x80109eab
80106811:	e8 b0 9b ff ff       	call   801003c6 <cprintf>
80106816:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80106819:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010681f:	8b 40 18             	mov    0x18(%eax),%eax
80106822:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80106829:	90                   	nop
8010682a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010682d:	c9                   	leave  
8010682e:	c3                   	ret    

8010682f <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
8010682f:	55                   	push   %ebp
80106830:	89 e5                	mov    %esp,%ebp
80106832:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80106835:	83 ec 08             	sub    $0x8,%esp
80106838:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010683b:	50                   	push   %eax
8010683c:	ff 75 08             	pushl  0x8(%ebp)
8010683f:	e8 af fe ff ff       	call   801066f3 <argint>
80106844:	83 c4 10             	add    $0x10,%esp
80106847:	85 c0                	test   %eax,%eax
80106849:	79 07                	jns    80106852 <argfd+0x23>
    return -1;
8010684b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106850:	eb 50                	jmp    801068a2 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80106852:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106855:	85 c0                	test   %eax,%eax
80106857:	78 21                	js     8010687a <argfd+0x4b>
80106859:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010685c:	83 f8 0f             	cmp    $0xf,%eax
8010685f:	7f 19                	jg     8010687a <argfd+0x4b>
80106861:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106867:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010686a:	83 c2 08             	add    $0x8,%edx
8010686d:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106871:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106874:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106878:	75 07                	jne    80106881 <argfd+0x52>
    return -1;
8010687a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010687f:	eb 21                	jmp    801068a2 <argfd+0x73>
  if(pfd)
80106881:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80106885:	74 08                	je     8010688f <argfd+0x60>
    *pfd = fd;
80106887:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010688a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010688d:	89 10                	mov    %edx,(%eax)
  if(pf)
8010688f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106893:	74 08                	je     8010689d <argfd+0x6e>
    *pf = f;
80106895:	8b 45 10             	mov    0x10(%ebp),%eax
80106898:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010689b:	89 10                	mov    %edx,(%eax)
  return 0;
8010689d:	b8 00 00 00 00       	mov    $0x0,%eax
}
801068a2:	c9                   	leave  
801068a3:	c3                   	ret    

801068a4 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801068a4:	55                   	push   %ebp
801068a5:	89 e5                	mov    %esp,%ebp
801068a7:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801068aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801068b1:	eb 30                	jmp    801068e3 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
801068b3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068b9:	8b 55 fc             	mov    -0x4(%ebp),%edx
801068bc:	83 c2 08             	add    $0x8,%edx
801068bf:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801068c3:	85 c0                	test   %eax,%eax
801068c5:	75 18                	jne    801068df <fdalloc+0x3b>
      proc->ofile[fd] = f;
801068c7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068cd:	8b 55 fc             	mov    -0x4(%ebp),%edx
801068d0:	8d 4a 08             	lea    0x8(%edx),%ecx
801068d3:	8b 55 08             	mov    0x8(%ebp),%edx
801068d6:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
801068da:	8b 45 fc             	mov    -0x4(%ebp),%eax
801068dd:	eb 0f                	jmp    801068ee <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801068df:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801068e3:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
801068e7:	7e ca                	jle    801068b3 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
801068e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801068ee:	c9                   	leave  
801068ef:	c3                   	ret    

801068f0 <sys_dup>:

int
sys_dup(void)
{
801068f0:	55                   	push   %ebp
801068f1:	89 e5                	mov    %esp,%ebp
801068f3:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
801068f6:	83 ec 04             	sub    $0x4,%esp
801068f9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801068fc:	50                   	push   %eax
801068fd:	6a 00                	push   $0x0
801068ff:	6a 00                	push   $0x0
80106901:	e8 29 ff ff ff       	call   8010682f <argfd>
80106906:	83 c4 10             	add    $0x10,%esp
80106909:	85 c0                	test   %eax,%eax
8010690b:	79 07                	jns    80106914 <sys_dup+0x24>
    return -1;
8010690d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106912:	eb 31                	jmp    80106945 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80106914:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106917:	83 ec 0c             	sub    $0xc,%esp
8010691a:	50                   	push   %eax
8010691b:	e8 84 ff ff ff       	call   801068a4 <fdalloc>
80106920:	83 c4 10             	add    $0x10,%esp
80106923:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106926:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010692a:	79 07                	jns    80106933 <sys_dup+0x43>
    return -1;
8010692c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106931:	eb 12                	jmp    80106945 <sys_dup+0x55>
  filedup(f);
80106933:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106936:	83 ec 0c             	sub    $0xc,%esp
80106939:	50                   	push   %eax
8010693a:	e8 5f a7 ff ff       	call   8010109e <filedup>
8010693f:	83 c4 10             	add    $0x10,%esp
  return fd;
80106942:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106945:	c9                   	leave  
80106946:	c3                   	ret    

80106947 <sys_read>:

int
sys_read(void)
{
80106947:	55                   	push   %ebp
80106948:	89 e5                	mov    %esp,%ebp
8010694a:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010694d:	83 ec 04             	sub    $0x4,%esp
80106950:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106953:	50                   	push   %eax
80106954:	6a 00                	push   $0x0
80106956:	6a 00                	push   $0x0
80106958:	e8 d2 fe ff ff       	call   8010682f <argfd>
8010695d:	83 c4 10             	add    $0x10,%esp
80106960:	85 c0                	test   %eax,%eax
80106962:	78 2e                	js     80106992 <sys_read+0x4b>
80106964:	83 ec 08             	sub    $0x8,%esp
80106967:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010696a:	50                   	push   %eax
8010696b:	6a 02                	push   $0x2
8010696d:	e8 81 fd ff ff       	call   801066f3 <argint>
80106972:	83 c4 10             	add    $0x10,%esp
80106975:	85 c0                	test   %eax,%eax
80106977:	78 19                	js     80106992 <sys_read+0x4b>
80106979:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010697c:	83 ec 04             	sub    $0x4,%esp
8010697f:	50                   	push   %eax
80106980:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106983:	50                   	push   %eax
80106984:	6a 01                	push   $0x1
80106986:	e8 90 fd ff ff       	call   8010671b <argptr>
8010698b:	83 c4 10             	add    $0x10,%esp
8010698e:	85 c0                	test   %eax,%eax
80106990:	79 07                	jns    80106999 <sys_read+0x52>
    return -1;
80106992:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106997:	eb 17                	jmp    801069b0 <sys_read+0x69>
  return fileread(f, p, n);
80106999:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010699c:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010699f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069a2:	83 ec 04             	sub    $0x4,%esp
801069a5:	51                   	push   %ecx
801069a6:	52                   	push   %edx
801069a7:	50                   	push   %eax
801069a8:	e8 81 a8 ff ff       	call   8010122e <fileread>
801069ad:	83 c4 10             	add    $0x10,%esp
}
801069b0:	c9                   	leave  
801069b1:	c3                   	ret    

801069b2 <sys_write>:

int
sys_write(void)
{
801069b2:	55                   	push   %ebp
801069b3:	89 e5                	mov    %esp,%ebp
801069b5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801069b8:	83 ec 04             	sub    $0x4,%esp
801069bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801069be:	50                   	push   %eax
801069bf:	6a 00                	push   $0x0
801069c1:	6a 00                	push   $0x0
801069c3:	e8 67 fe ff ff       	call   8010682f <argfd>
801069c8:	83 c4 10             	add    $0x10,%esp
801069cb:	85 c0                	test   %eax,%eax
801069cd:	78 2e                	js     801069fd <sys_write+0x4b>
801069cf:	83 ec 08             	sub    $0x8,%esp
801069d2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801069d5:	50                   	push   %eax
801069d6:	6a 02                	push   $0x2
801069d8:	e8 16 fd ff ff       	call   801066f3 <argint>
801069dd:	83 c4 10             	add    $0x10,%esp
801069e0:	85 c0                	test   %eax,%eax
801069e2:	78 19                	js     801069fd <sys_write+0x4b>
801069e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801069e7:	83 ec 04             	sub    $0x4,%esp
801069ea:	50                   	push   %eax
801069eb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801069ee:	50                   	push   %eax
801069ef:	6a 01                	push   $0x1
801069f1:	e8 25 fd ff ff       	call   8010671b <argptr>
801069f6:	83 c4 10             	add    $0x10,%esp
801069f9:	85 c0                	test   %eax,%eax
801069fb:	79 07                	jns    80106a04 <sys_write+0x52>
    return -1;
801069fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a02:	eb 17                	jmp    80106a1b <sys_write+0x69>
  return filewrite(f, p, n);
80106a04:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80106a07:	8b 55 ec             	mov    -0x14(%ebp),%edx
80106a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a0d:	83 ec 04             	sub    $0x4,%esp
80106a10:	51                   	push   %ecx
80106a11:	52                   	push   %edx
80106a12:	50                   	push   %eax
80106a13:	e8 ce a8 ff ff       	call   801012e6 <filewrite>
80106a18:	83 c4 10             	add    $0x10,%esp
}
80106a1b:	c9                   	leave  
80106a1c:	c3                   	ret    

80106a1d <sys_close>:

int
sys_close(void)
{
80106a1d:	55                   	push   %ebp
80106a1e:	89 e5                	mov    %esp,%ebp
80106a20:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80106a23:	83 ec 04             	sub    $0x4,%esp
80106a26:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106a29:	50                   	push   %eax
80106a2a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106a2d:	50                   	push   %eax
80106a2e:	6a 00                	push   $0x0
80106a30:	e8 fa fd ff ff       	call   8010682f <argfd>
80106a35:	83 c4 10             	add    $0x10,%esp
80106a38:	85 c0                	test   %eax,%eax
80106a3a:	79 07                	jns    80106a43 <sys_close+0x26>
    return -1;
80106a3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a41:	eb 28                	jmp    80106a6b <sys_close+0x4e>
  proc->ofile[fd] = 0;
80106a43:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a49:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106a4c:	83 c2 08             	add    $0x8,%edx
80106a4f:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106a56:	00 
  fileclose(f);
80106a57:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a5a:	83 ec 0c             	sub    $0xc,%esp
80106a5d:	50                   	push   %eax
80106a5e:	e8 8c a6 ff ff       	call   801010ef <fileclose>
80106a63:	83 c4 10             	add    $0x10,%esp
  return 0;
80106a66:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106a6b:	c9                   	leave  
80106a6c:	c3                   	ret    

80106a6d <sys_fstat>:

int
sys_fstat(void)
{
80106a6d:	55                   	push   %ebp
80106a6e:	89 e5                	mov    %esp,%ebp
80106a70:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80106a73:	83 ec 04             	sub    $0x4,%esp
80106a76:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106a79:	50                   	push   %eax
80106a7a:	6a 00                	push   $0x0
80106a7c:	6a 00                	push   $0x0
80106a7e:	e8 ac fd ff ff       	call   8010682f <argfd>
80106a83:	83 c4 10             	add    $0x10,%esp
80106a86:	85 c0                	test   %eax,%eax
80106a88:	78 17                	js     80106aa1 <sys_fstat+0x34>
80106a8a:	83 ec 04             	sub    $0x4,%esp
80106a8d:	6a 14                	push   $0x14
80106a8f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106a92:	50                   	push   %eax
80106a93:	6a 01                	push   $0x1
80106a95:	e8 81 fc ff ff       	call   8010671b <argptr>
80106a9a:	83 c4 10             	add    $0x10,%esp
80106a9d:	85 c0                	test   %eax,%eax
80106a9f:	79 07                	jns    80106aa8 <sys_fstat+0x3b>
    return -1;
80106aa1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106aa6:	eb 13                	jmp    80106abb <sys_fstat+0x4e>
  return filestat(f, st);
80106aa8:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106aae:	83 ec 08             	sub    $0x8,%esp
80106ab1:	52                   	push   %edx
80106ab2:	50                   	push   %eax
80106ab3:	e8 1f a7 ff ff       	call   801011d7 <filestat>
80106ab8:	83 c4 10             	add    $0x10,%esp
}
80106abb:	c9                   	leave  
80106abc:	c3                   	ret    

80106abd <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80106abd:	55                   	push   %ebp
80106abe:	89 e5                	mov    %esp,%ebp
80106ac0:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106ac3:	83 ec 08             	sub    $0x8,%esp
80106ac6:	8d 45 d8             	lea    -0x28(%ebp),%eax
80106ac9:	50                   	push   %eax
80106aca:	6a 00                	push   $0x0
80106acc:	e8 a7 fc ff ff       	call   80106778 <argstr>
80106ad1:	83 c4 10             	add    $0x10,%esp
80106ad4:	85 c0                	test   %eax,%eax
80106ad6:	78 15                	js     80106aed <sys_link+0x30>
80106ad8:	83 ec 08             	sub    $0x8,%esp
80106adb:	8d 45 dc             	lea    -0x24(%ebp),%eax
80106ade:	50                   	push   %eax
80106adf:	6a 01                	push   $0x1
80106ae1:	e8 92 fc ff ff       	call   80106778 <argstr>
80106ae6:	83 c4 10             	add    $0x10,%esp
80106ae9:	85 c0                	test   %eax,%eax
80106aeb:	79 0a                	jns    80106af7 <sys_link+0x3a>
    return -1;
80106aed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106af2:	e9 68 01 00 00       	jmp    80106c5f <sys_link+0x1a2>

  begin_op();
80106af7:	e8 ef ca ff ff       	call   801035eb <begin_op>
  if((ip = namei(old)) == 0){
80106afc:	8b 45 d8             	mov    -0x28(%ebp),%eax
80106aff:	83 ec 0c             	sub    $0xc,%esp
80106b02:	50                   	push   %eax
80106b03:	e8 be ba ff ff       	call   801025c6 <namei>
80106b08:	83 c4 10             	add    $0x10,%esp
80106b0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106b0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106b12:	75 0f                	jne    80106b23 <sys_link+0x66>
    end_op();
80106b14:	e8 5e cb ff ff       	call   80103677 <end_op>
    return -1;
80106b19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b1e:	e9 3c 01 00 00       	jmp    80106c5f <sys_link+0x1a2>
  }

  ilock(ip);
80106b23:	83 ec 0c             	sub    $0xc,%esp
80106b26:	ff 75 f4             	pushl  -0xc(%ebp)
80106b29:	e8 da ae ff ff       	call   80101a08 <ilock>
80106b2e:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80106b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b34:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106b38:	66 83 f8 01          	cmp    $0x1,%ax
80106b3c:	75 1d                	jne    80106b5b <sys_link+0x9e>
    iunlockput(ip);
80106b3e:	83 ec 0c             	sub    $0xc,%esp
80106b41:	ff 75 f4             	pushl  -0xc(%ebp)
80106b44:	e8 7f b1 ff ff       	call   80101cc8 <iunlockput>
80106b49:	83 c4 10             	add    $0x10,%esp
    end_op();
80106b4c:	e8 26 cb ff ff       	call   80103677 <end_op>
    return -1;
80106b51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b56:	e9 04 01 00 00       	jmp    80106c5f <sys_link+0x1a2>
  }

  ip->nlink++;
80106b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b5e:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106b62:	83 c0 01             	add    $0x1,%eax
80106b65:	89 c2                	mov    %eax,%edx
80106b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b6a:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80106b6e:	83 ec 0c             	sub    $0xc,%esp
80106b71:	ff 75 f4             	pushl  -0xc(%ebp)
80106b74:	e8 b5 ac ff ff       	call   8010182e <iupdate>
80106b79:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80106b7c:	83 ec 0c             	sub    $0xc,%esp
80106b7f:	ff 75 f4             	pushl  -0xc(%ebp)
80106b82:	e8 df af ff ff       	call   80101b66 <iunlock>
80106b87:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80106b8a:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106b8d:	83 ec 08             	sub    $0x8,%esp
80106b90:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80106b93:	52                   	push   %edx
80106b94:	50                   	push   %eax
80106b95:	e8 48 ba ff ff       	call   801025e2 <nameiparent>
80106b9a:	83 c4 10             	add    $0x10,%esp
80106b9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106ba0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106ba4:	74 71                	je     80106c17 <sys_link+0x15a>
    goto bad;
  ilock(dp);
80106ba6:	83 ec 0c             	sub    $0xc,%esp
80106ba9:	ff 75 f0             	pushl  -0x10(%ebp)
80106bac:	e8 57 ae ff ff       	call   80101a08 <ilock>
80106bb1:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80106bb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106bb7:	8b 10                	mov    (%eax),%edx
80106bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bbc:	8b 00                	mov    (%eax),%eax
80106bbe:	39 c2                	cmp    %eax,%edx
80106bc0:	75 1d                	jne    80106bdf <sys_link+0x122>
80106bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bc5:	8b 40 04             	mov    0x4(%eax),%eax
80106bc8:	83 ec 04             	sub    $0x4,%esp
80106bcb:	50                   	push   %eax
80106bcc:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80106bcf:	50                   	push   %eax
80106bd0:	ff 75 f0             	pushl  -0x10(%ebp)
80106bd3:	e8 52 b7 ff ff       	call   8010232a <dirlink>
80106bd8:	83 c4 10             	add    $0x10,%esp
80106bdb:	85 c0                	test   %eax,%eax
80106bdd:	79 10                	jns    80106bef <sys_link+0x132>
    iunlockput(dp);
80106bdf:	83 ec 0c             	sub    $0xc,%esp
80106be2:	ff 75 f0             	pushl  -0x10(%ebp)
80106be5:	e8 de b0 ff ff       	call   80101cc8 <iunlockput>
80106bea:	83 c4 10             	add    $0x10,%esp
    goto bad;
80106bed:	eb 29                	jmp    80106c18 <sys_link+0x15b>
  }
  iunlockput(dp);
80106bef:	83 ec 0c             	sub    $0xc,%esp
80106bf2:	ff 75 f0             	pushl  -0x10(%ebp)
80106bf5:	e8 ce b0 ff ff       	call   80101cc8 <iunlockput>
80106bfa:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80106bfd:	83 ec 0c             	sub    $0xc,%esp
80106c00:	ff 75 f4             	pushl  -0xc(%ebp)
80106c03:	e8 d0 af ff ff       	call   80101bd8 <iput>
80106c08:	83 c4 10             	add    $0x10,%esp

  end_op();
80106c0b:	e8 67 ca ff ff       	call   80103677 <end_op>

  return 0;
80106c10:	b8 00 00 00 00       	mov    $0x0,%eax
80106c15:	eb 48                	jmp    80106c5f <sys_link+0x1a2>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
80106c17:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
80106c18:	83 ec 0c             	sub    $0xc,%esp
80106c1b:	ff 75 f4             	pushl  -0xc(%ebp)
80106c1e:	e8 e5 ad ff ff       	call   80101a08 <ilock>
80106c23:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80106c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c29:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106c2d:	83 e8 01             	sub    $0x1,%eax
80106c30:	89 c2                	mov    %eax,%edx
80106c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c35:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80106c39:	83 ec 0c             	sub    $0xc,%esp
80106c3c:	ff 75 f4             	pushl  -0xc(%ebp)
80106c3f:	e8 ea ab ff ff       	call   8010182e <iupdate>
80106c44:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80106c47:	83 ec 0c             	sub    $0xc,%esp
80106c4a:	ff 75 f4             	pushl  -0xc(%ebp)
80106c4d:	e8 76 b0 ff ff       	call   80101cc8 <iunlockput>
80106c52:	83 c4 10             	add    $0x10,%esp
  end_op();
80106c55:	e8 1d ca ff ff       	call   80103677 <end_op>
  return -1;
80106c5a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106c5f:	c9                   	leave  
80106c60:	c3                   	ret    

80106c61 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80106c61:	55                   	push   %ebp
80106c62:	89 e5                	mov    %esp,%ebp
80106c64:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106c67:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80106c6e:	eb 40                	jmp    80106cb0 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c73:	6a 10                	push   $0x10
80106c75:	50                   	push   %eax
80106c76:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106c79:	50                   	push   %eax
80106c7a:	ff 75 08             	pushl  0x8(%ebp)
80106c7d:	e8 f4 b2 ff ff       	call   80101f76 <readi>
80106c82:	83 c4 10             	add    $0x10,%esp
80106c85:	83 f8 10             	cmp    $0x10,%eax
80106c88:	74 0d                	je     80106c97 <isdirempty+0x36>
      panic("isdirempty: readi");
80106c8a:	83 ec 0c             	sub    $0xc,%esp
80106c8d:	68 c7 9e 10 80       	push   $0x80109ec7
80106c92:	e8 cf 98 ff ff       	call   80100566 <panic>
    if(de.inum != 0)
80106c97:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80106c9b:	66 85 c0             	test   %ax,%ax
80106c9e:	74 07                	je     80106ca7 <isdirempty+0x46>
      return 0;
80106ca0:	b8 00 00 00 00       	mov    $0x0,%eax
80106ca5:	eb 1b                	jmp    80106cc2 <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106caa:	83 c0 10             	add    $0x10,%eax
80106cad:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106cb0:	8b 45 08             	mov    0x8(%ebp),%eax
80106cb3:	8b 50 18             	mov    0x18(%eax),%edx
80106cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106cb9:	39 c2                	cmp    %eax,%edx
80106cbb:	77 b3                	ja     80106c70 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80106cbd:	b8 01 00 00 00       	mov    $0x1,%eax
}
80106cc2:	c9                   	leave  
80106cc3:	c3                   	ret    

80106cc4 <sys_unlink>:

int
sys_unlink(void)
{
80106cc4:	55                   	push   %ebp
80106cc5:	89 e5                	mov    %esp,%ebp
80106cc7:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80106cca:	83 ec 08             	sub    $0x8,%esp
80106ccd:	8d 45 cc             	lea    -0x34(%ebp),%eax
80106cd0:	50                   	push   %eax
80106cd1:	6a 00                	push   $0x0
80106cd3:	e8 a0 fa ff ff       	call   80106778 <argstr>
80106cd8:	83 c4 10             	add    $0x10,%esp
80106cdb:	85 c0                	test   %eax,%eax
80106cdd:	79 0a                	jns    80106ce9 <sys_unlink+0x25>
    return -1;
80106cdf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ce4:	e9 bc 01 00 00       	jmp    80106ea5 <sys_unlink+0x1e1>

  begin_op();
80106ce9:	e8 fd c8 ff ff       	call   801035eb <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80106cee:	8b 45 cc             	mov    -0x34(%ebp),%eax
80106cf1:	83 ec 08             	sub    $0x8,%esp
80106cf4:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80106cf7:	52                   	push   %edx
80106cf8:	50                   	push   %eax
80106cf9:	e8 e4 b8 ff ff       	call   801025e2 <nameiparent>
80106cfe:	83 c4 10             	add    $0x10,%esp
80106d01:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106d04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106d08:	75 0f                	jne    80106d19 <sys_unlink+0x55>
    end_op();
80106d0a:	e8 68 c9 ff ff       	call   80103677 <end_op>
    return -1;
80106d0f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d14:	e9 8c 01 00 00       	jmp    80106ea5 <sys_unlink+0x1e1>
  }

  ilock(dp);
80106d19:	83 ec 0c             	sub    $0xc,%esp
80106d1c:	ff 75 f4             	pushl  -0xc(%ebp)
80106d1f:	e8 e4 ac ff ff       	call   80101a08 <ilock>
80106d24:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80106d27:	83 ec 08             	sub    $0x8,%esp
80106d2a:	68 d9 9e 10 80       	push   $0x80109ed9
80106d2f:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106d32:	50                   	push   %eax
80106d33:	e8 1d b5 ff ff       	call   80102255 <namecmp>
80106d38:	83 c4 10             	add    $0x10,%esp
80106d3b:	85 c0                	test   %eax,%eax
80106d3d:	0f 84 4a 01 00 00    	je     80106e8d <sys_unlink+0x1c9>
80106d43:	83 ec 08             	sub    $0x8,%esp
80106d46:	68 db 9e 10 80       	push   $0x80109edb
80106d4b:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106d4e:	50                   	push   %eax
80106d4f:	e8 01 b5 ff ff       	call   80102255 <namecmp>
80106d54:	83 c4 10             	add    $0x10,%esp
80106d57:	85 c0                	test   %eax,%eax
80106d59:	0f 84 2e 01 00 00    	je     80106e8d <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80106d5f:	83 ec 04             	sub    $0x4,%esp
80106d62:	8d 45 c8             	lea    -0x38(%ebp),%eax
80106d65:	50                   	push   %eax
80106d66:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106d69:	50                   	push   %eax
80106d6a:	ff 75 f4             	pushl  -0xc(%ebp)
80106d6d:	e8 fe b4 ff ff       	call   80102270 <dirlookup>
80106d72:	83 c4 10             	add    $0x10,%esp
80106d75:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106d78:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106d7c:	0f 84 0a 01 00 00    	je     80106e8c <sys_unlink+0x1c8>
    goto bad;
  ilock(ip);
80106d82:	83 ec 0c             	sub    $0xc,%esp
80106d85:	ff 75 f0             	pushl  -0x10(%ebp)
80106d88:	e8 7b ac ff ff       	call   80101a08 <ilock>
80106d8d:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80106d90:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106d93:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106d97:	66 85 c0             	test   %ax,%ax
80106d9a:	7f 0d                	jg     80106da9 <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
80106d9c:	83 ec 0c             	sub    $0xc,%esp
80106d9f:	68 de 9e 10 80       	push   $0x80109ede
80106da4:	e8 bd 97 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80106da9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106dac:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106db0:	66 83 f8 01          	cmp    $0x1,%ax
80106db4:	75 25                	jne    80106ddb <sys_unlink+0x117>
80106db6:	83 ec 0c             	sub    $0xc,%esp
80106db9:	ff 75 f0             	pushl  -0x10(%ebp)
80106dbc:	e8 a0 fe ff ff       	call   80106c61 <isdirempty>
80106dc1:	83 c4 10             	add    $0x10,%esp
80106dc4:	85 c0                	test   %eax,%eax
80106dc6:	75 13                	jne    80106ddb <sys_unlink+0x117>
    iunlockput(ip);
80106dc8:	83 ec 0c             	sub    $0xc,%esp
80106dcb:	ff 75 f0             	pushl  -0x10(%ebp)
80106dce:	e8 f5 ae ff ff       	call   80101cc8 <iunlockput>
80106dd3:	83 c4 10             	add    $0x10,%esp
    goto bad;
80106dd6:	e9 b2 00 00 00       	jmp    80106e8d <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
80106ddb:	83 ec 04             	sub    $0x4,%esp
80106dde:	6a 10                	push   $0x10
80106de0:	6a 00                	push   $0x0
80106de2:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106de5:	50                   	push   %eax
80106de6:	e8 e3 f5 ff ff       	call   801063ce <memset>
80106deb:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106dee:	8b 45 c8             	mov    -0x38(%ebp),%eax
80106df1:	6a 10                	push   $0x10
80106df3:	50                   	push   %eax
80106df4:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106df7:	50                   	push   %eax
80106df8:	ff 75 f4             	pushl  -0xc(%ebp)
80106dfb:	e8 cd b2 ff ff       	call   801020cd <writei>
80106e00:	83 c4 10             	add    $0x10,%esp
80106e03:	83 f8 10             	cmp    $0x10,%eax
80106e06:	74 0d                	je     80106e15 <sys_unlink+0x151>
    panic("unlink: writei");
80106e08:	83 ec 0c             	sub    $0xc,%esp
80106e0b:	68 f0 9e 10 80       	push   $0x80109ef0
80106e10:	e8 51 97 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR){
80106e15:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106e18:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106e1c:	66 83 f8 01          	cmp    $0x1,%ax
80106e20:	75 21                	jne    80106e43 <sys_unlink+0x17f>
    dp->nlink--;
80106e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e25:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106e29:	83 e8 01             	sub    $0x1,%eax
80106e2c:	89 c2                	mov    %eax,%edx
80106e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e31:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80106e35:	83 ec 0c             	sub    $0xc,%esp
80106e38:	ff 75 f4             	pushl  -0xc(%ebp)
80106e3b:	e8 ee a9 ff ff       	call   8010182e <iupdate>
80106e40:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80106e43:	83 ec 0c             	sub    $0xc,%esp
80106e46:	ff 75 f4             	pushl  -0xc(%ebp)
80106e49:	e8 7a ae ff ff       	call   80101cc8 <iunlockput>
80106e4e:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80106e51:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106e54:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106e58:	83 e8 01             	sub    $0x1,%eax
80106e5b:	89 c2                	mov    %eax,%edx
80106e5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106e60:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80106e64:	83 ec 0c             	sub    $0xc,%esp
80106e67:	ff 75 f0             	pushl  -0x10(%ebp)
80106e6a:	e8 bf a9 ff ff       	call   8010182e <iupdate>
80106e6f:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80106e72:	83 ec 0c             	sub    $0xc,%esp
80106e75:	ff 75 f0             	pushl  -0x10(%ebp)
80106e78:	e8 4b ae ff ff       	call   80101cc8 <iunlockput>
80106e7d:	83 c4 10             	add    $0x10,%esp

  end_op();
80106e80:	e8 f2 c7 ff ff       	call   80103677 <end_op>

  return 0;
80106e85:	b8 00 00 00 00       	mov    $0x0,%eax
80106e8a:	eb 19                	jmp    80106ea5 <sys_unlink+0x1e1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
80106e8c:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
80106e8d:	83 ec 0c             	sub    $0xc,%esp
80106e90:	ff 75 f4             	pushl  -0xc(%ebp)
80106e93:	e8 30 ae ff ff       	call   80101cc8 <iunlockput>
80106e98:	83 c4 10             	add    $0x10,%esp
  end_op();
80106e9b:	e8 d7 c7 ff ff       	call   80103677 <end_op>
  return -1;
80106ea0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ea5:	c9                   	leave  
80106ea6:	c3                   	ret    

80106ea7 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80106ea7:	55                   	push   %ebp
80106ea8:	89 e5                	mov    %esp,%ebp
80106eaa:	83 ec 38             	sub    $0x38,%esp
80106ead:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106eb0:	8b 55 10             	mov    0x10(%ebp),%edx
80106eb3:	8b 45 14             	mov    0x14(%ebp),%eax
80106eb6:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80106eba:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80106ebe:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80106ec2:	83 ec 08             	sub    $0x8,%esp
80106ec5:	8d 45 de             	lea    -0x22(%ebp),%eax
80106ec8:	50                   	push   %eax
80106ec9:	ff 75 08             	pushl  0x8(%ebp)
80106ecc:	e8 11 b7 ff ff       	call   801025e2 <nameiparent>
80106ed1:	83 c4 10             	add    $0x10,%esp
80106ed4:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106ed7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106edb:	75 0a                	jne    80106ee7 <create+0x40>
    return 0;
80106edd:	b8 00 00 00 00       	mov    $0x0,%eax
80106ee2:	e9 90 01 00 00       	jmp    80107077 <create+0x1d0>
  ilock(dp);
80106ee7:	83 ec 0c             	sub    $0xc,%esp
80106eea:	ff 75 f4             	pushl  -0xc(%ebp)
80106eed:	e8 16 ab ff ff       	call   80101a08 <ilock>
80106ef2:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
80106ef5:	83 ec 04             	sub    $0x4,%esp
80106ef8:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106efb:	50                   	push   %eax
80106efc:	8d 45 de             	lea    -0x22(%ebp),%eax
80106eff:	50                   	push   %eax
80106f00:	ff 75 f4             	pushl  -0xc(%ebp)
80106f03:	e8 68 b3 ff ff       	call   80102270 <dirlookup>
80106f08:	83 c4 10             	add    $0x10,%esp
80106f0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106f0e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106f12:	74 50                	je     80106f64 <create+0xbd>
    iunlockput(dp);
80106f14:	83 ec 0c             	sub    $0xc,%esp
80106f17:	ff 75 f4             	pushl  -0xc(%ebp)
80106f1a:	e8 a9 ad ff ff       	call   80101cc8 <iunlockput>
80106f1f:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80106f22:	83 ec 0c             	sub    $0xc,%esp
80106f25:	ff 75 f0             	pushl  -0x10(%ebp)
80106f28:	e8 db aa ff ff       	call   80101a08 <ilock>
80106f2d:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80106f30:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80106f35:	75 15                	jne    80106f4c <create+0xa5>
80106f37:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f3a:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106f3e:	66 83 f8 02          	cmp    $0x2,%ax
80106f42:	75 08                	jne    80106f4c <create+0xa5>
      return ip;
80106f44:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f47:	e9 2b 01 00 00       	jmp    80107077 <create+0x1d0>
    iunlockput(ip);
80106f4c:	83 ec 0c             	sub    $0xc,%esp
80106f4f:	ff 75 f0             	pushl  -0x10(%ebp)
80106f52:	e8 71 ad ff ff       	call   80101cc8 <iunlockput>
80106f57:	83 c4 10             	add    $0x10,%esp
    return 0;
80106f5a:	b8 00 00 00 00       	mov    $0x0,%eax
80106f5f:	e9 13 01 00 00       	jmp    80107077 <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80106f64:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80106f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f6b:	8b 00                	mov    (%eax),%eax
80106f6d:	83 ec 08             	sub    $0x8,%esp
80106f70:	52                   	push   %edx
80106f71:	50                   	push   %eax
80106f72:	e8 e0 a7 ff ff       	call   80101757 <ialloc>
80106f77:	83 c4 10             	add    $0x10,%esp
80106f7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106f7d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106f81:	75 0d                	jne    80106f90 <create+0xe9>
    panic("create: ialloc");
80106f83:	83 ec 0c             	sub    $0xc,%esp
80106f86:	68 ff 9e 10 80       	push   $0x80109eff
80106f8b:	e8 d6 95 ff ff       	call   80100566 <panic>

  ilock(ip);
80106f90:	83 ec 0c             	sub    $0xc,%esp
80106f93:	ff 75 f0             	pushl  -0x10(%ebp)
80106f96:	e8 6d aa ff ff       	call   80101a08 <ilock>
80106f9b:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80106f9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106fa1:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80106fa5:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80106fa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106fac:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80106fb0:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80106fb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106fb7:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80106fbd:	83 ec 0c             	sub    $0xc,%esp
80106fc0:	ff 75 f0             	pushl  -0x10(%ebp)
80106fc3:	e8 66 a8 ff ff       	call   8010182e <iupdate>
80106fc8:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80106fcb:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80106fd0:	75 6a                	jne    8010703c <create+0x195>
    dp->nlink++;  // for ".."
80106fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106fd5:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106fd9:	83 c0 01             	add    $0x1,%eax
80106fdc:	89 c2                	mov    %eax,%edx
80106fde:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106fe1:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80106fe5:	83 ec 0c             	sub    $0xc,%esp
80106fe8:	ff 75 f4             	pushl  -0xc(%ebp)
80106feb:	e8 3e a8 ff ff       	call   8010182e <iupdate>
80106ff0:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80106ff3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106ff6:	8b 40 04             	mov    0x4(%eax),%eax
80106ff9:	83 ec 04             	sub    $0x4,%esp
80106ffc:	50                   	push   %eax
80106ffd:	68 d9 9e 10 80       	push   $0x80109ed9
80107002:	ff 75 f0             	pushl  -0x10(%ebp)
80107005:	e8 20 b3 ff ff       	call   8010232a <dirlink>
8010700a:	83 c4 10             	add    $0x10,%esp
8010700d:	85 c0                	test   %eax,%eax
8010700f:	78 1e                	js     8010702f <create+0x188>
80107011:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107014:	8b 40 04             	mov    0x4(%eax),%eax
80107017:	83 ec 04             	sub    $0x4,%esp
8010701a:	50                   	push   %eax
8010701b:	68 db 9e 10 80       	push   $0x80109edb
80107020:	ff 75 f0             	pushl  -0x10(%ebp)
80107023:	e8 02 b3 ff ff       	call   8010232a <dirlink>
80107028:	83 c4 10             	add    $0x10,%esp
8010702b:	85 c0                	test   %eax,%eax
8010702d:	79 0d                	jns    8010703c <create+0x195>
      panic("create dots");
8010702f:	83 ec 0c             	sub    $0xc,%esp
80107032:	68 0e 9f 10 80       	push   $0x80109f0e
80107037:	e8 2a 95 ff ff       	call   80100566 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
8010703c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010703f:	8b 40 04             	mov    0x4(%eax),%eax
80107042:	83 ec 04             	sub    $0x4,%esp
80107045:	50                   	push   %eax
80107046:	8d 45 de             	lea    -0x22(%ebp),%eax
80107049:	50                   	push   %eax
8010704a:	ff 75 f4             	pushl  -0xc(%ebp)
8010704d:	e8 d8 b2 ff ff       	call   8010232a <dirlink>
80107052:	83 c4 10             	add    $0x10,%esp
80107055:	85 c0                	test   %eax,%eax
80107057:	79 0d                	jns    80107066 <create+0x1bf>
    panic("create: dirlink");
80107059:	83 ec 0c             	sub    $0xc,%esp
8010705c:	68 1a 9f 10 80       	push   $0x80109f1a
80107061:	e8 00 95 ff ff       	call   80100566 <panic>

  iunlockput(dp);
80107066:	83 ec 0c             	sub    $0xc,%esp
80107069:	ff 75 f4             	pushl  -0xc(%ebp)
8010706c:	e8 57 ac ff ff       	call   80101cc8 <iunlockput>
80107071:	83 c4 10             	add    $0x10,%esp

  return ip;
80107074:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107077:	c9                   	leave  
80107078:	c3                   	ret    

80107079 <sys_open>:

int
sys_open(void)
{
80107079:	55                   	push   %ebp
8010707a:	89 e5                	mov    %esp,%ebp
8010707c:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010707f:	83 ec 08             	sub    $0x8,%esp
80107082:	8d 45 e8             	lea    -0x18(%ebp),%eax
80107085:	50                   	push   %eax
80107086:	6a 00                	push   $0x0
80107088:	e8 eb f6 ff ff       	call   80106778 <argstr>
8010708d:	83 c4 10             	add    $0x10,%esp
80107090:	85 c0                	test   %eax,%eax
80107092:	78 15                	js     801070a9 <sys_open+0x30>
80107094:	83 ec 08             	sub    $0x8,%esp
80107097:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010709a:	50                   	push   %eax
8010709b:	6a 01                	push   $0x1
8010709d:	e8 51 f6 ff ff       	call   801066f3 <argint>
801070a2:	83 c4 10             	add    $0x10,%esp
801070a5:	85 c0                	test   %eax,%eax
801070a7:	79 0a                	jns    801070b3 <sys_open+0x3a>
    return -1;
801070a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801070ae:	e9 61 01 00 00       	jmp    80107214 <sys_open+0x19b>

  begin_op();
801070b3:	e8 33 c5 ff ff       	call   801035eb <begin_op>

  if(omode & O_CREATE){
801070b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801070bb:	25 00 02 00 00       	and    $0x200,%eax
801070c0:	85 c0                	test   %eax,%eax
801070c2:	74 2a                	je     801070ee <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
801070c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
801070c7:	6a 00                	push   $0x0
801070c9:	6a 00                	push   $0x0
801070cb:	6a 02                	push   $0x2
801070cd:	50                   	push   %eax
801070ce:	e8 d4 fd ff ff       	call   80106ea7 <create>
801070d3:	83 c4 10             	add    $0x10,%esp
801070d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
801070d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801070dd:	75 75                	jne    80107154 <sys_open+0xdb>
      end_op();
801070df:	e8 93 c5 ff ff       	call   80103677 <end_op>
      return -1;
801070e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801070e9:	e9 26 01 00 00       	jmp    80107214 <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
801070ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
801070f1:	83 ec 0c             	sub    $0xc,%esp
801070f4:	50                   	push   %eax
801070f5:	e8 cc b4 ff ff       	call   801025c6 <namei>
801070fa:	83 c4 10             	add    $0x10,%esp
801070fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107100:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107104:	75 0f                	jne    80107115 <sys_open+0x9c>
      end_op();
80107106:	e8 6c c5 ff ff       	call   80103677 <end_op>
      return -1;
8010710b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107110:	e9 ff 00 00 00       	jmp    80107214 <sys_open+0x19b>
    }
    ilock(ip);
80107115:	83 ec 0c             	sub    $0xc,%esp
80107118:	ff 75 f4             	pushl  -0xc(%ebp)
8010711b:	e8 e8 a8 ff ff       	call   80101a08 <ilock>
80107120:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80107123:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107126:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010712a:	66 83 f8 01          	cmp    $0x1,%ax
8010712e:	75 24                	jne    80107154 <sys_open+0xdb>
80107130:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107133:	85 c0                	test   %eax,%eax
80107135:	74 1d                	je     80107154 <sys_open+0xdb>
      iunlockput(ip);
80107137:	83 ec 0c             	sub    $0xc,%esp
8010713a:	ff 75 f4             	pushl  -0xc(%ebp)
8010713d:	e8 86 ab ff ff       	call   80101cc8 <iunlockput>
80107142:	83 c4 10             	add    $0x10,%esp
      end_op();
80107145:	e8 2d c5 ff ff       	call   80103677 <end_op>
      return -1;
8010714a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010714f:	e9 c0 00 00 00       	jmp    80107214 <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80107154:	e8 d8 9e ff ff       	call   80101031 <filealloc>
80107159:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010715c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107160:	74 17                	je     80107179 <sys_open+0x100>
80107162:	83 ec 0c             	sub    $0xc,%esp
80107165:	ff 75 f0             	pushl  -0x10(%ebp)
80107168:	e8 37 f7 ff ff       	call   801068a4 <fdalloc>
8010716d:	83 c4 10             	add    $0x10,%esp
80107170:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107173:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107177:	79 2e                	jns    801071a7 <sys_open+0x12e>
    if(f)
80107179:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010717d:	74 0e                	je     8010718d <sys_open+0x114>
      fileclose(f);
8010717f:	83 ec 0c             	sub    $0xc,%esp
80107182:	ff 75 f0             	pushl  -0x10(%ebp)
80107185:	e8 65 9f ff ff       	call   801010ef <fileclose>
8010718a:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010718d:	83 ec 0c             	sub    $0xc,%esp
80107190:	ff 75 f4             	pushl  -0xc(%ebp)
80107193:	e8 30 ab ff ff       	call   80101cc8 <iunlockput>
80107198:	83 c4 10             	add    $0x10,%esp
    end_op();
8010719b:	e8 d7 c4 ff ff       	call   80103677 <end_op>
    return -1;
801071a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801071a5:	eb 6d                	jmp    80107214 <sys_open+0x19b>
  }
  iunlock(ip);
801071a7:	83 ec 0c             	sub    $0xc,%esp
801071aa:	ff 75 f4             	pushl  -0xc(%ebp)
801071ad:	e8 b4 a9 ff ff       	call   80101b66 <iunlock>
801071b2:	83 c4 10             	add    $0x10,%esp
  end_op();
801071b5:	e8 bd c4 ff ff       	call   80103677 <end_op>

  f->type = FD_INODE;
801071ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
801071bd:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
801071c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801071c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801071c9:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
801071cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801071cf:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
801071d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801071d9:	83 e0 01             	and    $0x1,%eax
801071dc:	85 c0                	test   %eax,%eax
801071de:	0f 94 c0             	sete   %al
801071e1:	89 c2                	mov    %eax,%edx
801071e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801071e6:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801071e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801071ec:	83 e0 01             	and    $0x1,%eax
801071ef:	85 c0                	test   %eax,%eax
801071f1:	75 0a                	jne    801071fd <sys_open+0x184>
801071f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801071f6:	83 e0 02             	and    $0x2,%eax
801071f9:	85 c0                	test   %eax,%eax
801071fb:	74 07                	je     80107204 <sys_open+0x18b>
801071fd:	b8 01 00 00 00       	mov    $0x1,%eax
80107202:	eb 05                	jmp    80107209 <sys_open+0x190>
80107204:	b8 00 00 00 00       	mov    $0x0,%eax
80107209:	89 c2                	mov    %eax,%edx
8010720b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010720e:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80107211:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80107214:	c9                   	leave  
80107215:	c3                   	ret    

80107216 <sys_mkdir>:

int
sys_mkdir(void)
{
80107216:	55                   	push   %ebp
80107217:	89 e5                	mov    %esp,%ebp
80107219:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010721c:	e8 ca c3 ff ff       	call   801035eb <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80107221:	83 ec 08             	sub    $0x8,%esp
80107224:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107227:	50                   	push   %eax
80107228:	6a 00                	push   $0x0
8010722a:	e8 49 f5 ff ff       	call   80106778 <argstr>
8010722f:	83 c4 10             	add    $0x10,%esp
80107232:	85 c0                	test   %eax,%eax
80107234:	78 1b                	js     80107251 <sys_mkdir+0x3b>
80107236:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107239:	6a 00                	push   $0x0
8010723b:	6a 00                	push   $0x0
8010723d:	6a 01                	push   $0x1
8010723f:	50                   	push   %eax
80107240:	e8 62 fc ff ff       	call   80106ea7 <create>
80107245:	83 c4 10             	add    $0x10,%esp
80107248:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010724b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010724f:	75 0c                	jne    8010725d <sys_mkdir+0x47>
    end_op();
80107251:	e8 21 c4 ff ff       	call   80103677 <end_op>
    return -1;
80107256:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010725b:	eb 18                	jmp    80107275 <sys_mkdir+0x5f>
  }
  iunlockput(ip);
8010725d:	83 ec 0c             	sub    $0xc,%esp
80107260:	ff 75 f4             	pushl  -0xc(%ebp)
80107263:	e8 60 aa ff ff       	call   80101cc8 <iunlockput>
80107268:	83 c4 10             	add    $0x10,%esp
  end_op();
8010726b:	e8 07 c4 ff ff       	call   80103677 <end_op>
  return 0;
80107270:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107275:	c9                   	leave  
80107276:	c3                   	ret    

80107277 <sys_mknod>:

int
sys_mknod(void)
{
80107277:	55                   	push   %ebp
80107278:	89 e5                	mov    %esp,%ebp
8010727a:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
8010727d:	e8 69 c3 ff ff       	call   801035eb <begin_op>
  if((len=argstr(0, &path)) < 0 ||
80107282:	83 ec 08             	sub    $0x8,%esp
80107285:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107288:	50                   	push   %eax
80107289:	6a 00                	push   $0x0
8010728b:	e8 e8 f4 ff ff       	call   80106778 <argstr>
80107290:	83 c4 10             	add    $0x10,%esp
80107293:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107296:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010729a:	78 4f                	js     801072eb <sys_mknod+0x74>
     argint(1, &major) < 0 ||
8010729c:	83 ec 08             	sub    $0x8,%esp
8010729f:	8d 45 e8             	lea    -0x18(%ebp),%eax
801072a2:	50                   	push   %eax
801072a3:	6a 01                	push   $0x1
801072a5:	e8 49 f4 ff ff       	call   801066f3 <argint>
801072aa:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
801072ad:	85 c0                	test   %eax,%eax
801072af:	78 3a                	js     801072eb <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801072b1:	83 ec 08             	sub    $0x8,%esp
801072b4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801072b7:	50                   	push   %eax
801072b8:	6a 02                	push   $0x2
801072ba:	e8 34 f4 ff ff       	call   801066f3 <argint>
801072bf:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
801072c2:	85 c0                	test   %eax,%eax
801072c4:	78 25                	js     801072eb <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
801072c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072c9:	0f bf c8             	movswl %ax,%ecx
801072cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
801072cf:	0f bf d0             	movswl %ax,%edx
801072d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801072d5:	51                   	push   %ecx
801072d6:	52                   	push   %edx
801072d7:	6a 03                	push   $0x3
801072d9:	50                   	push   %eax
801072da:	e8 c8 fb ff ff       	call   80106ea7 <create>
801072df:	83 c4 10             	add    $0x10,%esp
801072e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
801072e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801072e9:	75 0c                	jne    801072f7 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801072eb:	e8 87 c3 ff ff       	call   80103677 <end_op>
    return -1;
801072f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801072f5:	eb 18                	jmp    8010730f <sys_mknod+0x98>
  }
  iunlockput(ip);
801072f7:	83 ec 0c             	sub    $0xc,%esp
801072fa:	ff 75 f0             	pushl  -0x10(%ebp)
801072fd:	e8 c6 a9 ff ff       	call   80101cc8 <iunlockput>
80107302:	83 c4 10             	add    $0x10,%esp
  end_op();
80107305:	e8 6d c3 ff ff       	call   80103677 <end_op>
  return 0;
8010730a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010730f:	c9                   	leave  
80107310:	c3                   	ret    

80107311 <sys_chdir>:

int
sys_chdir(void)
{
80107311:	55                   	push   %ebp
80107312:	89 e5                	mov    %esp,%ebp
80107314:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80107317:	e8 cf c2 ff ff       	call   801035eb <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
8010731c:	83 ec 08             	sub    $0x8,%esp
8010731f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107322:	50                   	push   %eax
80107323:	6a 00                	push   $0x0
80107325:	e8 4e f4 ff ff       	call   80106778 <argstr>
8010732a:	83 c4 10             	add    $0x10,%esp
8010732d:	85 c0                	test   %eax,%eax
8010732f:	78 18                	js     80107349 <sys_chdir+0x38>
80107331:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107334:	83 ec 0c             	sub    $0xc,%esp
80107337:	50                   	push   %eax
80107338:	e8 89 b2 ff ff       	call   801025c6 <namei>
8010733d:	83 c4 10             	add    $0x10,%esp
80107340:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107343:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107347:	75 0c                	jne    80107355 <sys_chdir+0x44>
    end_op();
80107349:	e8 29 c3 ff ff       	call   80103677 <end_op>
    return -1;
8010734e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107353:	eb 6e                	jmp    801073c3 <sys_chdir+0xb2>
  }
  ilock(ip);
80107355:	83 ec 0c             	sub    $0xc,%esp
80107358:	ff 75 f4             	pushl  -0xc(%ebp)
8010735b:	e8 a8 a6 ff ff       	call   80101a08 <ilock>
80107360:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80107363:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107366:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010736a:	66 83 f8 01          	cmp    $0x1,%ax
8010736e:	74 1a                	je     8010738a <sys_chdir+0x79>
    iunlockput(ip);
80107370:	83 ec 0c             	sub    $0xc,%esp
80107373:	ff 75 f4             	pushl  -0xc(%ebp)
80107376:	e8 4d a9 ff ff       	call   80101cc8 <iunlockput>
8010737b:	83 c4 10             	add    $0x10,%esp
    end_op();
8010737e:	e8 f4 c2 ff ff       	call   80103677 <end_op>
    return -1;
80107383:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107388:	eb 39                	jmp    801073c3 <sys_chdir+0xb2>
  }
  iunlock(ip);
8010738a:	83 ec 0c             	sub    $0xc,%esp
8010738d:	ff 75 f4             	pushl  -0xc(%ebp)
80107390:	e8 d1 a7 ff ff       	call   80101b66 <iunlock>
80107395:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
80107398:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010739e:	8b 40 68             	mov    0x68(%eax),%eax
801073a1:	83 ec 0c             	sub    $0xc,%esp
801073a4:	50                   	push   %eax
801073a5:	e8 2e a8 ff ff       	call   80101bd8 <iput>
801073aa:	83 c4 10             	add    $0x10,%esp
  end_op();
801073ad:	e8 c5 c2 ff ff       	call   80103677 <end_op>
  proc->cwd = ip;
801073b2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801073b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801073bb:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
801073be:	b8 00 00 00 00       	mov    $0x0,%eax
}
801073c3:	c9                   	leave  
801073c4:	c3                   	ret    

801073c5 <sys_exec>:

int
sys_exec(void)
{
801073c5:	55                   	push   %ebp
801073c6:	89 e5                	mov    %esp,%ebp
801073c8:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801073ce:	83 ec 08             	sub    $0x8,%esp
801073d1:	8d 45 f0             	lea    -0x10(%ebp),%eax
801073d4:	50                   	push   %eax
801073d5:	6a 00                	push   $0x0
801073d7:	e8 9c f3 ff ff       	call   80106778 <argstr>
801073dc:	83 c4 10             	add    $0x10,%esp
801073df:	85 c0                	test   %eax,%eax
801073e1:	78 18                	js     801073fb <sys_exec+0x36>
801073e3:	83 ec 08             	sub    $0x8,%esp
801073e6:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
801073ec:	50                   	push   %eax
801073ed:	6a 01                	push   $0x1
801073ef:	e8 ff f2 ff ff       	call   801066f3 <argint>
801073f4:	83 c4 10             	add    $0x10,%esp
801073f7:	85 c0                	test   %eax,%eax
801073f9:	79 0a                	jns    80107405 <sys_exec+0x40>
    return -1;
801073fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107400:	e9 c6 00 00 00       	jmp    801074cb <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80107405:	83 ec 04             	sub    $0x4,%esp
80107408:	68 80 00 00 00       	push   $0x80
8010740d:	6a 00                	push   $0x0
8010740f:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80107415:	50                   	push   %eax
80107416:	e8 b3 ef ff ff       	call   801063ce <memset>
8010741b:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
8010741e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80107425:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107428:	83 f8 1f             	cmp    $0x1f,%eax
8010742b:	76 0a                	jbe    80107437 <sys_exec+0x72>
      return -1;
8010742d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107432:	e9 94 00 00 00       	jmp    801074cb <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80107437:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010743a:	c1 e0 02             	shl    $0x2,%eax
8010743d:	89 c2                	mov    %eax,%edx
8010743f:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80107445:	01 c2                	add    %eax,%edx
80107447:	83 ec 08             	sub    $0x8,%esp
8010744a:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80107450:	50                   	push   %eax
80107451:	52                   	push   %edx
80107452:	e8 00 f2 ff ff       	call   80106657 <fetchint>
80107457:	83 c4 10             	add    $0x10,%esp
8010745a:	85 c0                	test   %eax,%eax
8010745c:	79 07                	jns    80107465 <sys_exec+0xa0>
      return -1;
8010745e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107463:	eb 66                	jmp    801074cb <sys_exec+0x106>
    if(uarg == 0){
80107465:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
8010746b:	85 c0                	test   %eax,%eax
8010746d:	75 27                	jne    80107496 <sys_exec+0xd1>
      argv[i] = 0;
8010746f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107472:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80107479:	00 00 00 00 
      break;
8010747d:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
8010747e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107481:	83 ec 08             	sub    $0x8,%esp
80107484:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
8010748a:	52                   	push   %edx
8010748b:	50                   	push   %eax
8010748c:	e8 7e 97 ff ff       	call   80100c0f <exec>
80107491:	83 c4 10             	add    $0x10,%esp
80107494:	eb 35                	jmp    801074cb <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80107496:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
8010749c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010749f:	c1 e2 02             	shl    $0x2,%edx
801074a2:	01 c2                	add    %eax,%edx
801074a4:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801074aa:	83 ec 08             	sub    $0x8,%esp
801074ad:	52                   	push   %edx
801074ae:	50                   	push   %eax
801074af:	e8 dd f1 ff ff       	call   80106691 <fetchstr>
801074b4:	83 c4 10             	add    $0x10,%esp
801074b7:	85 c0                	test   %eax,%eax
801074b9:	79 07                	jns    801074c2 <sys_exec+0xfd>
      return -1;
801074bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801074c0:	eb 09                	jmp    801074cb <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801074c2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
801074c6:	e9 5a ff ff ff       	jmp    80107425 <sys_exec+0x60>
  return exec(path, argv);
}
801074cb:	c9                   	leave  
801074cc:	c3                   	ret    

801074cd <sys_pipe>:

int
sys_pipe(void)
{
801074cd:	55                   	push   %ebp
801074ce:	89 e5                	mov    %esp,%ebp
801074d0:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801074d3:	83 ec 04             	sub    $0x4,%esp
801074d6:	6a 08                	push   $0x8
801074d8:	8d 45 ec             	lea    -0x14(%ebp),%eax
801074db:	50                   	push   %eax
801074dc:	6a 00                	push   $0x0
801074de:	e8 38 f2 ff ff       	call   8010671b <argptr>
801074e3:	83 c4 10             	add    $0x10,%esp
801074e6:	85 c0                	test   %eax,%eax
801074e8:	79 0a                	jns    801074f4 <sys_pipe+0x27>
    return -1;
801074ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801074ef:	e9 af 00 00 00       	jmp    801075a3 <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
801074f4:	83 ec 08             	sub    $0x8,%esp
801074f7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801074fa:	50                   	push   %eax
801074fb:	8d 45 e8             	lea    -0x18(%ebp),%eax
801074fe:	50                   	push   %eax
801074ff:	e8 db cb ff ff       	call   801040df <pipealloc>
80107504:	83 c4 10             	add    $0x10,%esp
80107507:	85 c0                	test   %eax,%eax
80107509:	79 0a                	jns    80107515 <sys_pipe+0x48>
    return -1;
8010750b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107510:	e9 8e 00 00 00       	jmp    801075a3 <sys_pipe+0xd6>
  fd0 = -1;
80107515:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010751c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010751f:	83 ec 0c             	sub    $0xc,%esp
80107522:	50                   	push   %eax
80107523:	e8 7c f3 ff ff       	call   801068a4 <fdalloc>
80107528:	83 c4 10             	add    $0x10,%esp
8010752b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010752e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107532:	78 18                	js     8010754c <sys_pipe+0x7f>
80107534:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107537:	83 ec 0c             	sub    $0xc,%esp
8010753a:	50                   	push   %eax
8010753b:	e8 64 f3 ff ff       	call   801068a4 <fdalloc>
80107540:	83 c4 10             	add    $0x10,%esp
80107543:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107546:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010754a:	79 3f                	jns    8010758b <sys_pipe+0xbe>
    if(fd0 >= 0)
8010754c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107550:	78 14                	js     80107566 <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
80107552:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107558:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010755b:	83 c2 08             	add    $0x8,%edx
8010755e:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80107565:	00 
    fileclose(rf);
80107566:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107569:	83 ec 0c             	sub    $0xc,%esp
8010756c:	50                   	push   %eax
8010756d:	e8 7d 9b ff ff       	call   801010ef <fileclose>
80107572:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80107575:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107578:	83 ec 0c             	sub    $0xc,%esp
8010757b:	50                   	push   %eax
8010757c:	e8 6e 9b ff ff       	call   801010ef <fileclose>
80107581:	83 c4 10             	add    $0x10,%esp
    return -1;
80107584:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107589:	eb 18                	jmp    801075a3 <sys_pipe+0xd6>
  }
  fd[0] = fd0;
8010758b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010758e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107591:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80107593:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107596:	8d 50 04             	lea    0x4(%eax),%edx
80107599:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010759c:	89 02                	mov    %eax,(%edx)
  return 0;
8010759e:	b8 00 00 00 00       	mov    $0x0,%eax
}
801075a3:	c9                   	leave  
801075a4:	c3                   	ret    

801075a5 <outw>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outw(ushort port, ushort data)
{
801075a5:	55                   	push   %ebp
801075a6:	89 e5                	mov    %esp,%ebp
801075a8:	83 ec 08             	sub    $0x8,%esp
801075ab:	8b 55 08             	mov    0x8(%ebp),%edx
801075ae:	8b 45 0c             	mov    0xc(%ebp),%eax
801075b1:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801075b5:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801075b9:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
801075bd:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801075c1:	66 ef                	out    %ax,(%dx)
}
801075c3:	90                   	nop
801075c4:	c9                   	leave  
801075c5:	c3                   	ret    

801075c6 <sys_fork>:
#include "uproc.h"
#endif

int
sys_fork(void)
{
801075c6:	55                   	push   %ebp
801075c7:	89 e5                	mov    %esp,%ebp
801075c9:	83 ec 08             	sub    $0x8,%esp
  return fork();
801075cc:	e8 36 d3 ff ff       	call   80104907 <fork>
}
801075d1:	c9                   	leave  
801075d2:	c3                   	ret    

801075d3 <sys_exit>:

int
sys_exit(void)
{
801075d3:	55                   	push   %ebp
801075d4:	89 e5                	mov    %esp,%ebp
801075d6:	83 ec 08             	sub    $0x8,%esp
  exit();
801075d9:	e8 1b d5 ff ff       	call   80104af9 <exit>
  return 0;  // not reached
801075de:	b8 00 00 00 00       	mov    $0x0,%eax
}
801075e3:	c9                   	leave  
801075e4:	c3                   	ret    

801075e5 <sys_wait>:

int
sys_wait(void)
{
801075e5:	55                   	push   %ebp
801075e6:	89 e5                	mov    %esp,%ebp
801075e8:	83 ec 08             	sub    $0x8,%esp
  return wait();
801075eb:	e8 9d d6 ff ff       	call   80104c8d <wait>
}
801075f0:	c9                   	leave  
801075f1:	c3                   	ret    

801075f2 <sys_kill>:

int
sys_kill(void)
{
801075f2:	55                   	push   %ebp
801075f3:	89 e5                	mov    %esp,%ebp
801075f5:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
801075f8:	83 ec 08             	sub    $0x8,%esp
801075fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801075fe:	50                   	push   %eax
801075ff:	6a 00                	push   $0x0
80107601:	e8 ed f0 ff ff       	call   801066f3 <argint>
80107606:	83 c4 10             	add    $0x10,%esp
80107609:	85 c0                	test   %eax,%eax
8010760b:	79 07                	jns    80107614 <sys_kill+0x22>
    return -1;
8010760d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107612:	eb 0f                	jmp    80107623 <sys_kill+0x31>
  return kill(pid);
80107614:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107617:	83 ec 0c             	sub    $0xc,%esp
8010761a:	50                   	push   %eax
8010761b:	e8 ba dd ff ff       	call   801053da <kill>
80107620:	83 c4 10             	add    $0x10,%esp
}
80107623:	c9                   	leave  
80107624:	c3                   	ret    

80107625 <sys_getpid>:

int
sys_getpid(void)
{
80107625:	55                   	push   %ebp
80107626:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80107628:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010762e:	8b 40 10             	mov    0x10(%eax),%eax
}
80107631:	5d                   	pop    %ebp
80107632:	c3                   	ret    

80107633 <sys_sbrk>:

int
sys_sbrk(void)
{
80107633:	55                   	push   %ebp
80107634:	89 e5                	mov    %esp,%ebp
80107636:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80107639:	83 ec 08             	sub    $0x8,%esp
8010763c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010763f:	50                   	push   %eax
80107640:	6a 00                	push   $0x0
80107642:	e8 ac f0 ff ff       	call   801066f3 <argint>
80107647:	83 c4 10             	add    $0x10,%esp
8010764a:	85 c0                	test   %eax,%eax
8010764c:	79 07                	jns    80107655 <sys_sbrk+0x22>
    return -1;
8010764e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107653:	eb 28                	jmp    8010767d <sys_sbrk+0x4a>
  addr = proc->sz;
80107655:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010765b:	8b 00                	mov    (%eax),%eax
8010765d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80107660:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107663:	83 ec 0c             	sub    $0xc,%esp
80107666:	50                   	push   %eax
80107667:	e8 f8 d1 ff ff       	call   80104864 <growproc>
8010766c:	83 c4 10             	add    $0x10,%esp
8010766f:	85 c0                	test   %eax,%eax
80107671:	79 07                	jns    8010767a <sys_sbrk+0x47>
    return -1;
80107673:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107678:	eb 03                	jmp    8010767d <sys_sbrk+0x4a>
  return addr;
8010767a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010767d:	c9                   	leave  
8010767e:	c3                   	ret    

8010767f <sys_sleep>:

int
sys_sleep(void)
{
8010767f:	55                   	push   %ebp
80107680:	89 e5                	mov    %esp,%ebp
80107682:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80107685:	83 ec 08             	sub    $0x8,%esp
80107688:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010768b:	50                   	push   %eax
8010768c:	6a 00                	push   $0x0
8010768e:	e8 60 f0 ff ff       	call   801066f3 <argint>
80107693:	83 c4 10             	add    $0x10,%esp
80107696:	85 c0                	test   %eax,%eax
80107698:	79 07                	jns    801076a1 <sys_sleep+0x22>
    return -1;
8010769a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010769f:	eb 44                	jmp    801076e5 <sys_sleep+0x66>
  ticks0 = ticks;
801076a1:	a1 00 79 11 80       	mov    0x80117900,%eax
801076a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
801076a9:	eb 26                	jmp    801076d1 <sys_sleep+0x52>
    if(proc->killed){
801076ab:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801076b1:	8b 40 24             	mov    0x24(%eax),%eax
801076b4:	85 c0                	test   %eax,%eax
801076b6:	74 07                	je     801076bf <sys_sleep+0x40>
      return -1;
801076b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801076bd:	eb 26                	jmp    801076e5 <sys_sleep+0x66>
    }
    sleep(&ticks, (struct spinlock *)0);
801076bf:	83 ec 08             	sub    $0x8,%esp
801076c2:	6a 00                	push   $0x0
801076c4:	68 00 79 11 80       	push   $0x80117900
801076c9:	e8 34 db ff ff       	call   80105202 <sleep>
801076ce:	83 c4 10             	add    $0x10,%esp
  uint ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801076d1:	a1 00 79 11 80       	mov    0x80117900,%eax
801076d6:	2b 45 f4             	sub    -0xc(%ebp),%eax
801076d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
801076dc:	39 d0                	cmp    %edx,%eax
801076de:	72 cb                	jb     801076ab <sys_sleep+0x2c>
    if(proc->killed){
      return -1;
    }
    sleep(&ticks, (struct spinlock *)0);
  }
  return 0;
801076e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801076e5:	c9                   	leave  
801076e6:	c3                   	ret    

801076e7 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start. 
int
sys_uptime(void)
{
801076e7:	55                   	push   %ebp
801076e8:	89 e5                	mov    %esp,%ebp
801076ea:	83 ec 10             	sub    $0x10,%esp
  uint xticks;
  
  xticks = ticks;
801076ed:	a1 00 79 11 80       	mov    0x80117900,%eax
801076f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return xticks;
801076f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801076f8:	c9                   	leave  
801076f9:	c3                   	ret    

801076fa <sys_halt>:

//Turn of the computer
int
sys_halt(void){
801076fa:	55                   	push   %ebp
801076fb:	89 e5                	mov    %esp,%ebp
801076fd:	83 ec 08             	sub    $0x8,%esp
  cprintf("Shutting down ...\n");
80107700:	83 ec 0c             	sub    $0xc,%esp
80107703:	68 2a 9f 10 80       	push   $0x80109f2a
80107708:	e8 b9 8c ff ff       	call   801003c6 <cprintf>
8010770d:	83 c4 10             	add    $0x10,%esp
  outw( 0x604, 0x0 | 0x2000);
80107710:	83 ec 08             	sub    $0x8,%esp
80107713:	68 00 20 00 00       	push   $0x2000
80107718:	68 04 06 00 00       	push   $0x604
8010771d:	e8 83 fe ff ff       	call   801075a5 <outw>
80107722:	83 c4 10             	add    $0x10,%esp
  return 0;
80107725:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010772a:	c9                   	leave  
8010772b:	c3                   	ret    

8010772c <sys_date>:

#ifdef CS333_P1
int
sys_date(void)
{
8010772c:	55                   	push   %ebp
8010772d:	89 e5                	mov    %esp,%ebp
8010772f:	83 ec 18             	sub    $0x18,%esp
  struct rtcdate *d;

  if(argptr(0, (void*)&d, sizeof(struct rtcdate)) < 0)
80107732:	83 ec 04             	sub    $0x4,%esp
80107735:	6a 18                	push   $0x18
80107737:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010773a:	50                   	push   %eax
8010773b:	6a 00                	push   $0x0
8010773d:	e8 d9 ef ff ff       	call   8010671b <argptr>
80107742:	83 c4 10             	add    $0x10,%esp
80107745:	85 c0                	test   %eax,%eax
80107747:	79 07                	jns    80107750 <sys_date+0x24>
    return -1;
80107749:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010774e:	eb 14                	jmp    80107764 <sys_date+0x38>
  cmostime(d);
80107750:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107753:	83 ec 0c             	sub    $0xc,%esp
80107756:	50                   	push   %eax
80107757:	e8 0a bb ff ff       	call   80103266 <cmostime>
8010775c:	83 c4 10             	add    $0x10,%esp
  return 0;
8010775f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107764:	c9                   	leave  
80107765:	c3                   	ret    

80107766 <sys_getuid>:

#ifdef CS333_P2
// gets process uid
uint
sys_getuid(void)
{
80107766:	55                   	push   %ebp
80107767:	89 e5                	mov    %esp,%ebp
  return proc->uid;
80107769:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010776f:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
}
80107775:	5d                   	pop    %ebp
80107776:	c3                   	ret    

80107777 <sys_getgid>:

// gets process gid
uint
sys_getgid(void)
{
80107777:	55                   	push   %ebp
80107778:	89 e5                	mov    %esp,%ebp
  return proc->gid;
8010777a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107780:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
}
80107786:	5d                   	pop    %ebp
80107787:	c3                   	ret    

80107788 <sys_getppid>:

// gets process ppid
uint
sys_getppid(void)
{
80107788:	55                   	push   %ebp
80107789:	89 e5                	mov    %esp,%ebp
  if(!proc->parent)
8010778b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107791:	8b 40 14             	mov    0x14(%eax),%eax
80107794:	85 c0                	test   %eax,%eax
80107796:	75 07                	jne    8010779f <sys_getppid+0x17>
    return 1;
80107798:	b8 01 00 00 00       	mov    $0x1,%eax
8010779d:	eb 0c                	jmp    801077ab <sys_getppid+0x23>
  return proc->parent->pid;
8010779f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801077a5:	8b 40 14             	mov    0x14(%eax),%eax
801077a8:	8b 40 10             	mov    0x10(%eax),%eax
}
801077ab:	5d                   	pop    %ebp
801077ac:	c3                   	ret    

801077ad <sys_setuid>:

// sets process uid
int
sys_setuid(void)
{
801077ad:	55                   	push   %ebp
801077ae:	89 e5                	mov    %esp,%ebp
801077b0:	83 ec 18             	sub    $0x18,%esp
  int n;

  if(argint(0, &n) < 0)
801077b3:	83 ec 08             	sub    $0x8,%esp
801077b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801077b9:	50                   	push   %eax
801077ba:	6a 00                	push   $0x0
801077bc:	e8 32 ef ff ff       	call   801066f3 <argint>
801077c1:	83 c4 10             	add    $0x10,%esp
801077c4:	85 c0                	test   %eax,%eax
801077c6:	79 07                	jns    801077cf <sys_setuid+0x22>
    return -1;
801077c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801077cd:	eb 2c                	jmp    801077fb <sys_setuid+0x4e>
  if(n < 0 || n > 32767)
801077cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077d2:	85 c0                	test   %eax,%eax
801077d4:	78 0a                	js     801077e0 <sys_setuid+0x33>
801077d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077d9:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
801077de:	7e 07                	jle    801077e7 <sys_setuid+0x3a>
    return -1;
801077e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801077e5:	eb 14                	jmp    801077fb <sys_setuid+0x4e>
  proc->uid = n;
801077e7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801077ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
801077f0:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  return 0;
801077f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801077fb:	c9                   	leave  
801077fc:	c3                   	ret    

801077fd <sys_setgid>:

// sets process gid
int
sys_setgid(void)
{
801077fd:	55                   	push   %ebp
801077fe:	89 e5                	mov    %esp,%ebp
80107800:	83 ec 18             	sub    $0x18,%esp
  int n;

  if(argint(0, &n) < 0)
80107803:	83 ec 08             	sub    $0x8,%esp
80107806:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107809:	50                   	push   %eax
8010780a:	6a 00                	push   $0x0
8010780c:	e8 e2 ee ff ff       	call   801066f3 <argint>
80107811:	83 c4 10             	add    $0x10,%esp
80107814:	85 c0                	test   %eax,%eax
80107816:	79 07                	jns    8010781f <sys_setgid+0x22>
    return -1;
80107818:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010781d:	eb 2c                	jmp    8010784b <sys_setgid+0x4e>
  if(n < 0 || n > 32767)
8010781f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107822:	85 c0                	test   %eax,%eax
80107824:	78 0a                	js     80107830 <sys_setgid+0x33>
80107826:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107829:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
8010782e:	7e 07                	jle    80107837 <sys_setgid+0x3a>
    return -1;
80107830:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107835:	eb 14                	jmp    8010784b <sys_setgid+0x4e>
  proc->gid = n;
80107837:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010783d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107840:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
  return 0;
80107846:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010784b:	c9                   	leave  
8010784c:	c3                   	ret    

8010784d <sys_getprocs>:

int
sys_getprocs(uint max, struct uproc* table)
{
8010784d:	55                   	push   %ebp
8010784e:	89 e5                	mov    %esp,%ebp
80107850:	83 ec 18             	sub    $0x18,%esp
  struct uproc *t;
  int n;

  if(argint(0, &n) < 0)
80107853:	83 ec 08             	sub    $0x8,%esp
80107856:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107859:	50                   	push   %eax
8010785a:	6a 00                	push   $0x0
8010785c:	e8 92 ee ff ff       	call   801066f3 <argint>
80107861:	83 c4 10             	add    $0x10,%esp
80107864:	85 c0                	test   %eax,%eax
80107866:	79 07                	jns    8010786f <sys_getprocs+0x22>
    return -1;
80107868:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010786d:	eb 31                	jmp    801078a0 <sys_getprocs+0x53>
  if(argptr(1, (void*)&t, sizeof(struct uproc)) < 0)
8010786f:	83 ec 04             	sub    $0x4,%esp
80107872:	6a 60                	push   $0x60
80107874:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107877:	50                   	push   %eax
80107878:	6a 01                	push   $0x1
8010787a:	e8 9c ee ff ff       	call   8010671b <argptr>
8010787f:	83 c4 10             	add    $0x10,%esp
80107882:	85 c0                	test   %eax,%eax
80107884:	79 07                	jns    8010788d <sys_getprocs+0x40>
    return -1;
80107886:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010788b:	eb 13                	jmp    801078a0 <sys_getprocs+0x53>
  return getprocs(n, t);
8010788d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107890:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107893:	83 ec 08             	sub    $0x8,%esp
80107896:	50                   	push   %eax
80107897:	52                   	push   %edx
80107898:	e8 9e de ff ff       	call   8010573b <getprocs>
8010789d:	83 c4 10             	add    $0x10,%esp
}
801078a0:	c9                   	leave  
801078a1:	c3                   	ret    

801078a2 <sys_setpriority>:
#endif

#ifdef CS333_P3P4
int
sys_setpriority(void)
{
801078a2:	55                   	push   %ebp
801078a3:	89 e5                	mov    %esp,%ebp
801078a5:	83 ec 18             	sub    $0x18,%esp
  int pid;
  int value;

  argint(0, &pid);
801078a8:	83 ec 08             	sub    $0x8,%esp
801078ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
801078ae:	50                   	push   %eax
801078af:	6a 00                	push   $0x0
801078b1:	e8 3d ee ff ff       	call   801066f3 <argint>
801078b6:	83 c4 10             	add    $0x10,%esp
  argint(1, &value);
801078b9:	83 ec 08             	sub    $0x8,%esp
801078bc:	8d 45 f0             	lea    -0x10(%ebp),%eax
801078bf:	50                   	push   %eax
801078c0:	6a 01                	push   $0x1
801078c2:	e8 2c ee ff ff       	call   801066f3 <argint>
801078c7:	83 c4 10             	add    $0x10,%esp
  return setpriority(pid, value);
801078ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
801078cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078d0:	83 ec 08             	sub    $0x8,%esp
801078d3:	52                   	push   %edx
801078d4:	50                   	push   %eax
801078d5:	e8 38 e6 ff ff       	call   80105f12 <setpriority>
801078da:	83 c4 10             	add    $0x10,%esp
}
801078dd:	c9                   	leave  
801078de:	c3                   	ret    

801078df <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801078df:	55                   	push   %ebp
801078e0:	89 e5                	mov    %esp,%ebp
801078e2:	83 ec 08             	sub    $0x8,%esp
801078e5:	8b 55 08             	mov    0x8(%ebp),%edx
801078e8:	8b 45 0c             	mov    0xc(%ebp),%eax
801078eb:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801078ef:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801078f2:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801078f6:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801078fa:	ee                   	out    %al,(%dx)
}
801078fb:	90                   	nop
801078fc:	c9                   	leave  
801078fd:	c3                   	ret    

801078fe <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
801078fe:	55                   	push   %ebp
801078ff:	89 e5                	mov    %esp,%ebp
80107901:	83 ec 08             	sub    $0x8,%esp
  // Interrupt TPS times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80107904:	6a 34                	push   $0x34
80107906:	6a 43                	push   $0x43
80107908:	e8 d2 ff ff ff       	call   801078df <outb>
8010790d:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(TPS) % 256);
80107910:	68 a9 00 00 00       	push   $0xa9
80107915:	6a 40                	push   $0x40
80107917:	e8 c3 ff ff ff       	call   801078df <outb>
8010791c:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(TPS) / 256);
8010791f:	6a 04                	push   $0x4
80107921:	6a 40                	push   $0x40
80107923:	e8 b7 ff ff ff       	call   801078df <outb>
80107928:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
8010792b:	83 ec 0c             	sub    $0xc,%esp
8010792e:	6a 00                	push   $0x0
80107930:	e8 94 c6 ff ff       	call   80103fc9 <picenable>
80107935:	83 c4 10             	add    $0x10,%esp
}
80107938:	90                   	nop
80107939:	c9                   	leave  
8010793a:	c3                   	ret    

8010793b <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010793b:	1e                   	push   %ds
  pushl %es
8010793c:	06                   	push   %es
  pushl %fs
8010793d:	0f a0                	push   %fs
  pushl %gs
8010793f:	0f a8                	push   %gs
  pushal
80107941:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80107942:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80107946:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80107948:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
8010794a:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
8010794e:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80107950:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80107952:	54                   	push   %esp
  call trap
80107953:	e8 ce 01 00 00       	call   80107b26 <trap>
  addl $4, %esp
80107958:	83 c4 04             	add    $0x4,%esp

8010795b <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010795b:	61                   	popa   
  popl %gs
8010795c:	0f a9                	pop    %gs
  popl %fs
8010795e:	0f a1                	pop    %fs
  popl %es
80107960:	07                   	pop    %es
  popl %ds
80107961:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80107962:	83 c4 08             	add    $0x8,%esp
  iret
80107965:	cf                   	iret   

80107966 <atom_inc>:

// Routines added for CS333
// atom_inc() added to simplify handling of ticks global
static inline void
atom_inc(volatile int *num)
{
80107966:	55                   	push   %ebp
80107967:	89 e5                	mov    %esp,%ebp
  asm volatile ( "lock incl %0" : "=m" (*num));
80107969:	8b 45 08             	mov    0x8(%ebp),%eax
8010796c:	f0 ff 00             	lock incl (%eax)
}
8010796f:	90                   	nop
80107970:	5d                   	pop    %ebp
80107971:	c3                   	ret    

80107972 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80107972:	55                   	push   %ebp
80107973:	89 e5                	mov    %esp,%ebp
80107975:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107978:	8b 45 0c             	mov    0xc(%ebp),%eax
8010797b:	83 e8 01             	sub    $0x1,%eax
8010797e:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107982:	8b 45 08             	mov    0x8(%ebp),%eax
80107985:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107989:	8b 45 08             	mov    0x8(%ebp),%eax
8010798c:	c1 e8 10             	shr    $0x10,%eax
8010798f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80107993:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107996:	0f 01 18             	lidtl  (%eax)
}
80107999:	90                   	nop
8010799a:	c9                   	leave  
8010799b:	c3                   	ret    

8010799c <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
8010799c:	55                   	push   %ebp
8010799d:	89 e5                	mov    %esp,%ebp
8010799f:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801079a2:	0f 20 d0             	mov    %cr2,%eax
801079a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
801079a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801079ab:	c9                   	leave  
801079ac:	c3                   	ret    

801079ad <tvinit>:
// Software Developer’s Manual, Vol 3A, 8.1.1 Guaranteed Atomic Operations.
uint ticks __attribute__ ((aligned (4)));

void
tvinit(void)
{
801079ad:	55                   	push   %ebp
801079ae:	89 e5                	mov    %esp,%ebp
801079b0:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
801079b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801079ba:	e9 c3 00 00 00       	jmp    80107a82 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801079bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
801079c2:	8b 04 85 bc d0 10 80 	mov    -0x7fef2f44(,%eax,4),%eax
801079c9:	89 c2                	mov    %eax,%edx
801079cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
801079ce:	66 89 14 c5 00 71 11 	mov    %dx,-0x7fee8f00(,%eax,8)
801079d5:	80 
801079d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801079d9:	66 c7 04 c5 02 71 11 	movw   $0x8,-0x7fee8efe(,%eax,8)
801079e0:	80 08 00 
801079e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801079e6:	0f b6 14 c5 04 71 11 	movzbl -0x7fee8efc(,%eax,8),%edx
801079ed:	80 
801079ee:	83 e2 e0             	and    $0xffffffe0,%edx
801079f1:	88 14 c5 04 71 11 80 	mov    %dl,-0x7fee8efc(,%eax,8)
801079f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801079fb:	0f b6 14 c5 04 71 11 	movzbl -0x7fee8efc(,%eax,8),%edx
80107a02:	80 
80107a03:	83 e2 1f             	and    $0x1f,%edx
80107a06:	88 14 c5 04 71 11 80 	mov    %dl,-0x7fee8efc(,%eax,8)
80107a0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107a10:	0f b6 14 c5 05 71 11 	movzbl -0x7fee8efb(,%eax,8),%edx
80107a17:	80 
80107a18:	83 e2 f0             	and    $0xfffffff0,%edx
80107a1b:	83 ca 0e             	or     $0xe,%edx
80107a1e:	88 14 c5 05 71 11 80 	mov    %dl,-0x7fee8efb(,%eax,8)
80107a25:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107a28:	0f b6 14 c5 05 71 11 	movzbl -0x7fee8efb(,%eax,8),%edx
80107a2f:	80 
80107a30:	83 e2 ef             	and    $0xffffffef,%edx
80107a33:	88 14 c5 05 71 11 80 	mov    %dl,-0x7fee8efb(,%eax,8)
80107a3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107a3d:	0f b6 14 c5 05 71 11 	movzbl -0x7fee8efb(,%eax,8),%edx
80107a44:	80 
80107a45:	83 e2 9f             	and    $0xffffff9f,%edx
80107a48:	88 14 c5 05 71 11 80 	mov    %dl,-0x7fee8efb(,%eax,8)
80107a4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107a52:	0f b6 14 c5 05 71 11 	movzbl -0x7fee8efb(,%eax,8),%edx
80107a59:	80 
80107a5a:	83 ca 80             	or     $0xffffff80,%edx
80107a5d:	88 14 c5 05 71 11 80 	mov    %dl,-0x7fee8efb(,%eax,8)
80107a64:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107a67:	8b 04 85 bc d0 10 80 	mov    -0x7fef2f44(,%eax,4),%eax
80107a6e:	c1 e8 10             	shr    $0x10,%eax
80107a71:	89 c2                	mov    %eax,%edx
80107a73:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107a76:	66 89 14 c5 06 71 11 	mov    %dx,-0x7fee8efa(,%eax,8)
80107a7d:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80107a7e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80107a82:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
80107a89:	0f 8e 30 ff ff ff    	jle    801079bf <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80107a8f:	a1 bc d1 10 80       	mov    0x8010d1bc,%eax
80107a94:	66 a3 00 73 11 80    	mov    %ax,0x80117300
80107a9a:	66 c7 05 02 73 11 80 	movw   $0x8,0x80117302
80107aa1:	08 00 
80107aa3:	0f b6 05 04 73 11 80 	movzbl 0x80117304,%eax
80107aaa:	83 e0 e0             	and    $0xffffffe0,%eax
80107aad:	a2 04 73 11 80       	mov    %al,0x80117304
80107ab2:	0f b6 05 04 73 11 80 	movzbl 0x80117304,%eax
80107ab9:	83 e0 1f             	and    $0x1f,%eax
80107abc:	a2 04 73 11 80       	mov    %al,0x80117304
80107ac1:	0f b6 05 05 73 11 80 	movzbl 0x80117305,%eax
80107ac8:	83 c8 0f             	or     $0xf,%eax
80107acb:	a2 05 73 11 80       	mov    %al,0x80117305
80107ad0:	0f b6 05 05 73 11 80 	movzbl 0x80117305,%eax
80107ad7:	83 e0 ef             	and    $0xffffffef,%eax
80107ada:	a2 05 73 11 80       	mov    %al,0x80117305
80107adf:	0f b6 05 05 73 11 80 	movzbl 0x80117305,%eax
80107ae6:	83 c8 60             	or     $0x60,%eax
80107ae9:	a2 05 73 11 80       	mov    %al,0x80117305
80107aee:	0f b6 05 05 73 11 80 	movzbl 0x80117305,%eax
80107af5:	83 c8 80             	or     $0xffffff80,%eax
80107af8:	a2 05 73 11 80       	mov    %al,0x80117305
80107afd:	a1 bc d1 10 80       	mov    0x8010d1bc,%eax
80107b02:	c1 e8 10             	shr    $0x10,%eax
80107b05:	66 a3 06 73 11 80    	mov    %ax,0x80117306
  
}
80107b0b:	90                   	nop
80107b0c:	c9                   	leave  
80107b0d:	c3                   	ret    

80107b0e <idtinit>:

void
idtinit(void)
{
80107b0e:	55                   	push   %ebp
80107b0f:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80107b11:	68 00 08 00 00       	push   $0x800
80107b16:	68 00 71 11 80       	push   $0x80117100
80107b1b:	e8 52 fe ff ff       	call   80107972 <lidt>
80107b20:	83 c4 08             	add    $0x8,%esp
}
80107b23:	90                   	nop
80107b24:	c9                   	leave  
80107b25:	c3                   	ret    

80107b26 <trap>:

void
trap(struct trapframe *tf)
{
80107b26:	55                   	push   %ebp
80107b27:	89 e5                	mov    %esp,%ebp
80107b29:	57                   	push   %edi
80107b2a:	56                   	push   %esi
80107b2b:	53                   	push   %ebx
80107b2c:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
80107b2f:	8b 45 08             	mov    0x8(%ebp),%eax
80107b32:	8b 40 30             	mov    0x30(%eax),%eax
80107b35:	83 f8 40             	cmp    $0x40,%eax
80107b38:	75 3e                	jne    80107b78 <trap+0x52>
    if(proc->killed)
80107b3a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107b40:	8b 40 24             	mov    0x24(%eax),%eax
80107b43:	85 c0                	test   %eax,%eax
80107b45:	74 05                	je     80107b4c <trap+0x26>
      exit();
80107b47:	e8 ad cf ff ff       	call   80104af9 <exit>
    proc->tf = tf;
80107b4c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107b52:	8b 55 08             	mov    0x8(%ebp),%edx
80107b55:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80107b58:	e8 4c ec ff ff       	call   801067a9 <syscall>
    if(proc->killed)
80107b5d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107b63:	8b 40 24             	mov    0x24(%eax),%eax
80107b66:	85 c0                	test   %eax,%eax
80107b68:	0f 84 21 02 00 00    	je     80107d8f <trap+0x269>
      exit();
80107b6e:	e8 86 cf ff ff       	call   80104af9 <exit>
    return;
80107b73:	e9 17 02 00 00       	jmp    80107d8f <trap+0x269>
  }

  switch(tf->trapno){
80107b78:	8b 45 08             	mov    0x8(%ebp),%eax
80107b7b:	8b 40 30             	mov    0x30(%eax),%eax
80107b7e:	83 e8 20             	sub    $0x20,%eax
80107b81:	83 f8 1f             	cmp    $0x1f,%eax
80107b84:	0f 87 a3 00 00 00    	ja     80107c2d <trap+0x107>
80107b8a:	8b 04 85 e0 9f 10 80 	mov    -0x7fef6020(,%eax,4),%eax
80107b91:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
   if(cpu->id == 0){
80107b93:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107b99:	0f b6 00             	movzbl (%eax),%eax
80107b9c:	84 c0                	test   %al,%al
80107b9e:	75 20                	jne    80107bc0 <trap+0x9a>
      atom_inc((int *)&ticks);   // guaranteed atomic so no lock necessary
80107ba0:	83 ec 0c             	sub    $0xc,%esp
80107ba3:	68 00 79 11 80       	push   $0x80117900
80107ba8:	e8 b9 fd ff ff       	call   80107966 <atom_inc>
80107bad:	83 c4 10             	add    $0x10,%esp
      wakeup(&ticks);
80107bb0:	83 ec 0c             	sub    $0xc,%esp
80107bb3:	68 00 79 11 80       	push   $0x80117900
80107bb8:	e8 e6 d7 ff ff       	call   801053a3 <wakeup>
80107bbd:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80107bc0:	e8 fe b4 ff ff       	call   801030c3 <lapiceoi>
    break;
80107bc5:	e9 1c 01 00 00       	jmp    80107ce6 <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80107bca:	e8 07 ad ff ff       	call   801028d6 <ideintr>
    lapiceoi();
80107bcf:	e8 ef b4 ff ff       	call   801030c3 <lapiceoi>
    break;
80107bd4:	e9 0d 01 00 00       	jmp    80107ce6 <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80107bd9:	e8 e7 b2 ff ff       	call   80102ec5 <kbdintr>
    lapiceoi();
80107bde:	e8 e0 b4 ff ff       	call   801030c3 <lapiceoi>
    break;
80107be3:	e9 fe 00 00 00       	jmp    80107ce6 <trap+0x1c0>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80107be8:	e8 83 03 00 00       	call   80107f70 <uartintr>
    lapiceoi();
80107bed:	e8 d1 b4 ff ff       	call   801030c3 <lapiceoi>
    break;
80107bf2:	e9 ef 00 00 00       	jmp    80107ce6 <trap+0x1c0>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107bf7:	8b 45 08             	mov    0x8(%ebp),%eax
80107bfa:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80107bfd:	8b 45 08             	mov    0x8(%ebp),%eax
80107c00:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107c04:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80107c07:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107c0d:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107c10:	0f b6 c0             	movzbl %al,%eax
80107c13:	51                   	push   %ecx
80107c14:	52                   	push   %edx
80107c15:	50                   	push   %eax
80107c16:	68 40 9f 10 80       	push   $0x80109f40
80107c1b:	e8 a6 87 ff ff       	call   801003c6 <cprintf>
80107c20:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80107c23:	e8 9b b4 ff ff       	call   801030c3 <lapiceoi>
    break;
80107c28:	e9 b9 00 00 00       	jmp    80107ce6 <trap+0x1c0>
   
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80107c2d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107c33:	85 c0                	test   %eax,%eax
80107c35:	74 11                	je     80107c48 <trap+0x122>
80107c37:	8b 45 08             	mov    0x8(%ebp),%eax
80107c3a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107c3e:	0f b7 c0             	movzwl %ax,%eax
80107c41:	83 e0 03             	and    $0x3,%eax
80107c44:	85 c0                	test   %eax,%eax
80107c46:	75 40                	jne    80107c88 <trap+0x162>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107c48:	e8 4f fd ff ff       	call   8010799c <rcr2>
80107c4d:	89 c3                	mov    %eax,%ebx
80107c4f:	8b 45 08             	mov    0x8(%ebp),%eax
80107c52:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
80107c55:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107c5b:	0f b6 00             	movzbl (%eax),%eax
    break;
   
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107c5e:	0f b6 d0             	movzbl %al,%edx
80107c61:	8b 45 08             	mov    0x8(%ebp),%eax
80107c64:	8b 40 30             	mov    0x30(%eax),%eax
80107c67:	83 ec 0c             	sub    $0xc,%esp
80107c6a:	53                   	push   %ebx
80107c6b:	51                   	push   %ecx
80107c6c:	52                   	push   %edx
80107c6d:	50                   	push   %eax
80107c6e:	68 64 9f 10 80       	push   $0x80109f64
80107c73:	e8 4e 87 ff ff       	call   801003c6 <cprintf>
80107c78:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80107c7b:	83 ec 0c             	sub    $0xc,%esp
80107c7e:	68 96 9f 10 80       	push   $0x80109f96
80107c83:	e8 de 88 ff ff       	call   80100566 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107c88:	e8 0f fd ff ff       	call   8010799c <rcr2>
80107c8d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107c90:	8b 45 08             	mov    0x8(%ebp),%eax
80107c93:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80107c96:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107c9c:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107c9f:	0f b6 d8             	movzbl %al,%ebx
80107ca2:	8b 45 08             	mov    0x8(%ebp),%eax
80107ca5:	8b 48 34             	mov    0x34(%eax),%ecx
80107ca8:	8b 45 08             	mov    0x8(%ebp),%eax
80107cab:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80107cae:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107cb4:	8d 78 6c             	lea    0x6c(%eax),%edi
80107cb7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107cbd:	8b 40 10             	mov    0x10(%eax),%eax
80107cc0:	ff 75 e4             	pushl  -0x1c(%ebp)
80107cc3:	56                   	push   %esi
80107cc4:	53                   	push   %ebx
80107cc5:	51                   	push   %ecx
80107cc6:	52                   	push   %edx
80107cc7:	57                   	push   %edi
80107cc8:	50                   	push   %eax
80107cc9:	68 9c 9f 10 80       	push   $0x80109f9c
80107cce:	e8 f3 86 ff ff       	call   801003c6 <cprintf>
80107cd3:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
80107cd6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107cdc:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80107ce3:	eb 01                	jmp    80107ce6 <trap+0x1c0>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80107ce5:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80107ce6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107cec:	85 c0                	test   %eax,%eax
80107cee:	74 24                	je     80107d14 <trap+0x1ee>
80107cf0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107cf6:	8b 40 24             	mov    0x24(%eax),%eax
80107cf9:	85 c0                	test   %eax,%eax
80107cfb:	74 17                	je     80107d14 <trap+0x1ee>
80107cfd:	8b 45 08             	mov    0x8(%ebp),%eax
80107d00:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107d04:	0f b7 c0             	movzwl %ax,%eax
80107d07:	83 e0 03             	and    $0x3,%eax
80107d0a:	83 f8 03             	cmp    $0x3,%eax
80107d0d:	75 05                	jne    80107d14 <trap+0x1ee>
    exit();
80107d0f:	e8 e5 cd ff ff       	call   80104af9 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING &&
80107d14:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107d1a:	85 c0                	test   %eax,%eax
80107d1c:	74 41                	je     80107d5f <trap+0x239>
80107d1e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107d24:	8b 40 0c             	mov    0xc(%eax),%eax
80107d27:	83 f8 04             	cmp    $0x4,%eax
80107d2a:	75 33                	jne    80107d5f <trap+0x239>
	  tf->trapno == T_IRQ0+IRQ_TIMER && ticks%SCHED_INTERVAL==0)
80107d2c:	8b 45 08             	mov    0x8(%ebp),%eax
80107d2f:	8b 40 30             	mov    0x30(%eax),%eax
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING &&
80107d32:	83 f8 20             	cmp    $0x20,%eax
80107d35:	75 28                	jne    80107d5f <trap+0x239>
	  tf->trapno == T_IRQ0+IRQ_TIMER && ticks%SCHED_INTERVAL==0)
80107d37:	8b 0d 00 79 11 80    	mov    0x80117900,%ecx
80107d3d:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80107d42:	89 c8                	mov    %ecx,%eax
80107d44:	f7 e2                	mul    %edx
80107d46:	c1 ea 03             	shr    $0x3,%edx
80107d49:	89 d0                	mov    %edx,%eax
80107d4b:	c1 e0 02             	shl    $0x2,%eax
80107d4e:	01 d0                	add    %edx,%eax
80107d50:	01 c0                	add    %eax,%eax
80107d52:	29 c1                	sub    %eax,%ecx
80107d54:	89 ca                	mov    %ecx,%edx
80107d56:	85 d2                	test   %edx,%edx
80107d58:	75 05                	jne    80107d5f <trap+0x239>
    yield();
80107d5a:	e8 86 d3 ff ff       	call   801050e5 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80107d5f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107d65:	85 c0                	test   %eax,%eax
80107d67:	74 27                	je     80107d90 <trap+0x26a>
80107d69:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107d6f:	8b 40 24             	mov    0x24(%eax),%eax
80107d72:	85 c0                	test   %eax,%eax
80107d74:	74 1a                	je     80107d90 <trap+0x26a>
80107d76:	8b 45 08             	mov    0x8(%ebp),%eax
80107d79:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107d7d:	0f b7 c0             	movzwl %ax,%eax
80107d80:	83 e0 03             	and    $0x3,%eax
80107d83:	83 f8 03             	cmp    $0x3,%eax
80107d86:	75 08                	jne    80107d90 <trap+0x26a>
    exit();
80107d88:	e8 6c cd ff ff       	call   80104af9 <exit>
80107d8d:	eb 01                	jmp    80107d90 <trap+0x26a>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
80107d8f:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80107d90:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d93:	5b                   	pop    %ebx
80107d94:	5e                   	pop    %esi
80107d95:	5f                   	pop    %edi
80107d96:	5d                   	pop    %ebp
80107d97:	c3                   	ret    

80107d98 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80107d98:	55                   	push   %ebp
80107d99:	89 e5                	mov    %esp,%ebp
80107d9b:	83 ec 14             	sub    $0x14,%esp
80107d9e:	8b 45 08             	mov    0x8(%ebp),%eax
80107da1:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107da5:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80107da9:	89 c2                	mov    %eax,%edx
80107dab:	ec                   	in     (%dx),%al
80107dac:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80107daf:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80107db3:	c9                   	leave  
80107db4:	c3                   	ret    

80107db5 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80107db5:	55                   	push   %ebp
80107db6:	89 e5                	mov    %esp,%ebp
80107db8:	83 ec 08             	sub    $0x8,%esp
80107dbb:	8b 55 08             	mov    0x8(%ebp),%edx
80107dbe:	8b 45 0c             	mov    0xc(%ebp),%eax
80107dc1:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107dc5:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107dc8:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107dcc:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107dd0:	ee                   	out    %al,(%dx)
}
80107dd1:	90                   	nop
80107dd2:	c9                   	leave  
80107dd3:	c3                   	ret    

80107dd4 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80107dd4:	55                   	push   %ebp
80107dd5:	89 e5                	mov    %esp,%ebp
80107dd7:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80107dda:	6a 00                	push   $0x0
80107ddc:	68 fa 03 00 00       	push   $0x3fa
80107de1:	e8 cf ff ff ff       	call   80107db5 <outb>
80107de6:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80107de9:	68 80 00 00 00       	push   $0x80
80107dee:	68 fb 03 00 00       	push   $0x3fb
80107df3:	e8 bd ff ff ff       	call   80107db5 <outb>
80107df8:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80107dfb:	6a 0c                	push   $0xc
80107dfd:	68 f8 03 00 00       	push   $0x3f8
80107e02:	e8 ae ff ff ff       	call   80107db5 <outb>
80107e07:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80107e0a:	6a 00                	push   $0x0
80107e0c:	68 f9 03 00 00       	push   $0x3f9
80107e11:	e8 9f ff ff ff       	call   80107db5 <outb>
80107e16:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80107e19:	6a 03                	push   $0x3
80107e1b:	68 fb 03 00 00       	push   $0x3fb
80107e20:	e8 90 ff ff ff       	call   80107db5 <outb>
80107e25:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80107e28:	6a 00                	push   $0x0
80107e2a:	68 fc 03 00 00       	push   $0x3fc
80107e2f:	e8 81 ff ff ff       	call   80107db5 <outb>
80107e34:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80107e37:	6a 01                	push   $0x1
80107e39:	68 f9 03 00 00       	push   $0x3f9
80107e3e:	e8 72 ff ff ff       	call   80107db5 <outb>
80107e43:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80107e46:	68 fd 03 00 00       	push   $0x3fd
80107e4b:	e8 48 ff ff ff       	call   80107d98 <inb>
80107e50:	83 c4 04             	add    $0x4,%esp
80107e53:	3c ff                	cmp    $0xff,%al
80107e55:	74 6e                	je     80107ec5 <uartinit+0xf1>
    return;
  uart = 1;
80107e57:	c7 05 6c d6 10 80 01 	movl   $0x1,0x8010d66c
80107e5e:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80107e61:	68 fa 03 00 00       	push   $0x3fa
80107e66:	e8 2d ff ff ff       	call   80107d98 <inb>
80107e6b:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80107e6e:	68 f8 03 00 00       	push   $0x3f8
80107e73:	e8 20 ff ff ff       	call   80107d98 <inb>
80107e78:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
80107e7b:	83 ec 0c             	sub    $0xc,%esp
80107e7e:	6a 04                	push   $0x4
80107e80:	e8 44 c1 ff ff       	call   80103fc9 <picenable>
80107e85:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
80107e88:	83 ec 08             	sub    $0x8,%esp
80107e8b:	6a 00                	push   $0x0
80107e8d:	6a 04                	push   $0x4
80107e8f:	e8 e4 ac ff ff       	call   80102b78 <ioapicenable>
80107e94:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107e97:	c7 45 f4 60 a0 10 80 	movl   $0x8010a060,-0xc(%ebp)
80107e9e:	eb 19                	jmp    80107eb9 <uartinit+0xe5>
    uartputc(*p);
80107ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ea3:	0f b6 00             	movzbl (%eax),%eax
80107ea6:	0f be c0             	movsbl %al,%eax
80107ea9:	83 ec 0c             	sub    $0xc,%esp
80107eac:	50                   	push   %eax
80107ead:	e8 16 00 00 00       	call   80107ec8 <uartputc>
80107eb2:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107eb5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ebc:	0f b6 00             	movzbl (%eax),%eax
80107ebf:	84 c0                	test   %al,%al
80107ec1:	75 dd                	jne    80107ea0 <uartinit+0xcc>
80107ec3:	eb 01                	jmp    80107ec6 <uartinit+0xf2>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
80107ec5:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
80107ec6:	c9                   	leave  
80107ec7:	c3                   	ret    

80107ec8 <uartputc>:

void
uartputc(int c)
{
80107ec8:	55                   	push   %ebp
80107ec9:	89 e5                	mov    %esp,%ebp
80107ecb:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
80107ece:	a1 6c d6 10 80       	mov    0x8010d66c,%eax
80107ed3:	85 c0                	test   %eax,%eax
80107ed5:	74 53                	je     80107f2a <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107ed7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107ede:	eb 11                	jmp    80107ef1 <uartputc+0x29>
    microdelay(10);
80107ee0:	83 ec 0c             	sub    $0xc,%esp
80107ee3:	6a 0a                	push   $0xa
80107ee5:	e8 f4 b1 ff ff       	call   801030de <microdelay>
80107eea:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107eed:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107ef1:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80107ef5:	7f 1a                	jg     80107f11 <uartputc+0x49>
80107ef7:	83 ec 0c             	sub    $0xc,%esp
80107efa:	68 fd 03 00 00       	push   $0x3fd
80107eff:	e8 94 fe ff ff       	call   80107d98 <inb>
80107f04:	83 c4 10             	add    $0x10,%esp
80107f07:	0f b6 c0             	movzbl %al,%eax
80107f0a:	83 e0 20             	and    $0x20,%eax
80107f0d:	85 c0                	test   %eax,%eax
80107f0f:	74 cf                	je     80107ee0 <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
80107f11:	8b 45 08             	mov    0x8(%ebp),%eax
80107f14:	0f b6 c0             	movzbl %al,%eax
80107f17:	83 ec 08             	sub    $0x8,%esp
80107f1a:	50                   	push   %eax
80107f1b:	68 f8 03 00 00       	push   $0x3f8
80107f20:	e8 90 fe ff ff       	call   80107db5 <outb>
80107f25:	83 c4 10             	add    $0x10,%esp
80107f28:	eb 01                	jmp    80107f2b <uartputc+0x63>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
80107f2a:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80107f2b:	c9                   	leave  
80107f2c:	c3                   	ret    

80107f2d <uartgetc>:

static int
uartgetc(void)
{
80107f2d:	55                   	push   %ebp
80107f2e:	89 e5                	mov    %esp,%ebp
  if(!uart)
80107f30:	a1 6c d6 10 80       	mov    0x8010d66c,%eax
80107f35:	85 c0                	test   %eax,%eax
80107f37:	75 07                	jne    80107f40 <uartgetc+0x13>
    return -1;
80107f39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107f3e:	eb 2e                	jmp    80107f6e <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
80107f40:	68 fd 03 00 00       	push   $0x3fd
80107f45:	e8 4e fe ff ff       	call   80107d98 <inb>
80107f4a:	83 c4 04             	add    $0x4,%esp
80107f4d:	0f b6 c0             	movzbl %al,%eax
80107f50:	83 e0 01             	and    $0x1,%eax
80107f53:	85 c0                	test   %eax,%eax
80107f55:	75 07                	jne    80107f5e <uartgetc+0x31>
    return -1;
80107f57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107f5c:	eb 10                	jmp    80107f6e <uartgetc+0x41>
  return inb(COM1+0);
80107f5e:	68 f8 03 00 00       	push   $0x3f8
80107f63:	e8 30 fe ff ff       	call   80107d98 <inb>
80107f68:	83 c4 04             	add    $0x4,%esp
80107f6b:	0f b6 c0             	movzbl %al,%eax
}
80107f6e:	c9                   	leave  
80107f6f:	c3                   	ret    

80107f70 <uartintr>:

void
uartintr(void)
{
80107f70:	55                   	push   %ebp
80107f71:	89 e5                	mov    %esp,%ebp
80107f73:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80107f76:	83 ec 0c             	sub    $0xc,%esp
80107f79:	68 2d 7f 10 80       	push   $0x80107f2d
80107f7e:	e8 76 88 ff ff       	call   801007f9 <consoleintr>
80107f83:	83 c4 10             	add    $0x10,%esp
}
80107f86:	90                   	nop
80107f87:	c9                   	leave  
80107f88:	c3                   	ret    

80107f89 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80107f89:	6a 00                	push   $0x0
  pushl $0
80107f8b:	6a 00                	push   $0x0
  jmp alltraps
80107f8d:	e9 a9 f9 ff ff       	jmp    8010793b <alltraps>

80107f92 <vector1>:
.globl vector1
vector1:
  pushl $0
80107f92:	6a 00                	push   $0x0
  pushl $1
80107f94:	6a 01                	push   $0x1
  jmp alltraps
80107f96:	e9 a0 f9 ff ff       	jmp    8010793b <alltraps>

80107f9b <vector2>:
.globl vector2
vector2:
  pushl $0
80107f9b:	6a 00                	push   $0x0
  pushl $2
80107f9d:	6a 02                	push   $0x2
  jmp alltraps
80107f9f:	e9 97 f9 ff ff       	jmp    8010793b <alltraps>

80107fa4 <vector3>:
.globl vector3
vector3:
  pushl $0
80107fa4:	6a 00                	push   $0x0
  pushl $3
80107fa6:	6a 03                	push   $0x3
  jmp alltraps
80107fa8:	e9 8e f9 ff ff       	jmp    8010793b <alltraps>

80107fad <vector4>:
.globl vector4
vector4:
  pushl $0
80107fad:	6a 00                	push   $0x0
  pushl $4
80107faf:	6a 04                	push   $0x4
  jmp alltraps
80107fb1:	e9 85 f9 ff ff       	jmp    8010793b <alltraps>

80107fb6 <vector5>:
.globl vector5
vector5:
  pushl $0
80107fb6:	6a 00                	push   $0x0
  pushl $5
80107fb8:	6a 05                	push   $0x5
  jmp alltraps
80107fba:	e9 7c f9 ff ff       	jmp    8010793b <alltraps>

80107fbf <vector6>:
.globl vector6
vector6:
  pushl $0
80107fbf:	6a 00                	push   $0x0
  pushl $6
80107fc1:	6a 06                	push   $0x6
  jmp alltraps
80107fc3:	e9 73 f9 ff ff       	jmp    8010793b <alltraps>

80107fc8 <vector7>:
.globl vector7
vector7:
  pushl $0
80107fc8:	6a 00                	push   $0x0
  pushl $7
80107fca:	6a 07                	push   $0x7
  jmp alltraps
80107fcc:	e9 6a f9 ff ff       	jmp    8010793b <alltraps>

80107fd1 <vector8>:
.globl vector8
vector8:
  pushl $8
80107fd1:	6a 08                	push   $0x8
  jmp alltraps
80107fd3:	e9 63 f9 ff ff       	jmp    8010793b <alltraps>

80107fd8 <vector9>:
.globl vector9
vector9:
  pushl $0
80107fd8:	6a 00                	push   $0x0
  pushl $9
80107fda:	6a 09                	push   $0x9
  jmp alltraps
80107fdc:	e9 5a f9 ff ff       	jmp    8010793b <alltraps>

80107fe1 <vector10>:
.globl vector10
vector10:
  pushl $10
80107fe1:	6a 0a                	push   $0xa
  jmp alltraps
80107fe3:	e9 53 f9 ff ff       	jmp    8010793b <alltraps>

80107fe8 <vector11>:
.globl vector11
vector11:
  pushl $11
80107fe8:	6a 0b                	push   $0xb
  jmp alltraps
80107fea:	e9 4c f9 ff ff       	jmp    8010793b <alltraps>

80107fef <vector12>:
.globl vector12
vector12:
  pushl $12
80107fef:	6a 0c                	push   $0xc
  jmp alltraps
80107ff1:	e9 45 f9 ff ff       	jmp    8010793b <alltraps>

80107ff6 <vector13>:
.globl vector13
vector13:
  pushl $13
80107ff6:	6a 0d                	push   $0xd
  jmp alltraps
80107ff8:	e9 3e f9 ff ff       	jmp    8010793b <alltraps>

80107ffd <vector14>:
.globl vector14
vector14:
  pushl $14
80107ffd:	6a 0e                	push   $0xe
  jmp alltraps
80107fff:	e9 37 f9 ff ff       	jmp    8010793b <alltraps>

80108004 <vector15>:
.globl vector15
vector15:
  pushl $0
80108004:	6a 00                	push   $0x0
  pushl $15
80108006:	6a 0f                	push   $0xf
  jmp alltraps
80108008:	e9 2e f9 ff ff       	jmp    8010793b <alltraps>

8010800d <vector16>:
.globl vector16
vector16:
  pushl $0
8010800d:	6a 00                	push   $0x0
  pushl $16
8010800f:	6a 10                	push   $0x10
  jmp alltraps
80108011:	e9 25 f9 ff ff       	jmp    8010793b <alltraps>

80108016 <vector17>:
.globl vector17
vector17:
  pushl $17
80108016:	6a 11                	push   $0x11
  jmp alltraps
80108018:	e9 1e f9 ff ff       	jmp    8010793b <alltraps>

8010801d <vector18>:
.globl vector18
vector18:
  pushl $0
8010801d:	6a 00                	push   $0x0
  pushl $18
8010801f:	6a 12                	push   $0x12
  jmp alltraps
80108021:	e9 15 f9 ff ff       	jmp    8010793b <alltraps>

80108026 <vector19>:
.globl vector19
vector19:
  pushl $0
80108026:	6a 00                	push   $0x0
  pushl $19
80108028:	6a 13                	push   $0x13
  jmp alltraps
8010802a:	e9 0c f9 ff ff       	jmp    8010793b <alltraps>

8010802f <vector20>:
.globl vector20
vector20:
  pushl $0
8010802f:	6a 00                	push   $0x0
  pushl $20
80108031:	6a 14                	push   $0x14
  jmp alltraps
80108033:	e9 03 f9 ff ff       	jmp    8010793b <alltraps>

80108038 <vector21>:
.globl vector21
vector21:
  pushl $0
80108038:	6a 00                	push   $0x0
  pushl $21
8010803a:	6a 15                	push   $0x15
  jmp alltraps
8010803c:	e9 fa f8 ff ff       	jmp    8010793b <alltraps>

80108041 <vector22>:
.globl vector22
vector22:
  pushl $0
80108041:	6a 00                	push   $0x0
  pushl $22
80108043:	6a 16                	push   $0x16
  jmp alltraps
80108045:	e9 f1 f8 ff ff       	jmp    8010793b <alltraps>

8010804a <vector23>:
.globl vector23
vector23:
  pushl $0
8010804a:	6a 00                	push   $0x0
  pushl $23
8010804c:	6a 17                	push   $0x17
  jmp alltraps
8010804e:	e9 e8 f8 ff ff       	jmp    8010793b <alltraps>

80108053 <vector24>:
.globl vector24
vector24:
  pushl $0
80108053:	6a 00                	push   $0x0
  pushl $24
80108055:	6a 18                	push   $0x18
  jmp alltraps
80108057:	e9 df f8 ff ff       	jmp    8010793b <alltraps>

8010805c <vector25>:
.globl vector25
vector25:
  pushl $0
8010805c:	6a 00                	push   $0x0
  pushl $25
8010805e:	6a 19                	push   $0x19
  jmp alltraps
80108060:	e9 d6 f8 ff ff       	jmp    8010793b <alltraps>

80108065 <vector26>:
.globl vector26
vector26:
  pushl $0
80108065:	6a 00                	push   $0x0
  pushl $26
80108067:	6a 1a                	push   $0x1a
  jmp alltraps
80108069:	e9 cd f8 ff ff       	jmp    8010793b <alltraps>

8010806e <vector27>:
.globl vector27
vector27:
  pushl $0
8010806e:	6a 00                	push   $0x0
  pushl $27
80108070:	6a 1b                	push   $0x1b
  jmp alltraps
80108072:	e9 c4 f8 ff ff       	jmp    8010793b <alltraps>

80108077 <vector28>:
.globl vector28
vector28:
  pushl $0
80108077:	6a 00                	push   $0x0
  pushl $28
80108079:	6a 1c                	push   $0x1c
  jmp alltraps
8010807b:	e9 bb f8 ff ff       	jmp    8010793b <alltraps>

80108080 <vector29>:
.globl vector29
vector29:
  pushl $0
80108080:	6a 00                	push   $0x0
  pushl $29
80108082:	6a 1d                	push   $0x1d
  jmp alltraps
80108084:	e9 b2 f8 ff ff       	jmp    8010793b <alltraps>

80108089 <vector30>:
.globl vector30
vector30:
  pushl $0
80108089:	6a 00                	push   $0x0
  pushl $30
8010808b:	6a 1e                	push   $0x1e
  jmp alltraps
8010808d:	e9 a9 f8 ff ff       	jmp    8010793b <alltraps>

80108092 <vector31>:
.globl vector31
vector31:
  pushl $0
80108092:	6a 00                	push   $0x0
  pushl $31
80108094:	6a 1f                	push   $0x1f
  jmp alltraps
80108096:	e9 a0 f8 ff ff       	jmp    8010793b <alltraps>

8010809b <vector32>:
.globl vector32
vector32:
  pushl $0
8010809b:	6a 00                	push   $0x0
  pushl $32
8010809d:	6a 20                	push   $0x20
  jmp alltraps
8010809f:	e9 97 f8 ff ff       	jmp    8010793b <alltraps>

801080a4 <vector33>:
.globl vector33
vector33:
  pushl $0
801080a4:	6a 00                	push   $0x0
  pushl $33
801080a6:	6a 21                	push   $0x21
  jmp alltraps
801080a8:	e9 8e f8 ff ff       	jmp    8010793b <alltraps>

801080ad <vector34>:
.globl vector34
vector34:
  pushl $0
801080ad:	6a 00                	push   $0x0
  pushl $34
801080af:	6a 22                	push   $0x22
  jmp alltraps
801080b1:	e9 85 f8 ff ff       	jmp    8010793b <alltraps>

801080b6 <vector35>:
.globl vector35
vector35:
  pushl $0
801080b6:	6a 00                	push   $0x0
  pushl $35
801080b8:	6a 23                	push   $0x23
  jmp alltraps
801080ba:	e9 7c f8 ff ff       	jmp    8010793b <alltraps>

801080bf <vector36>:
.globl vector36
vector36:
  pushl $0
801080bf:	6a 00                	push   $0x0
  pushl $36
801080c1:	6a 24                	push   $0x24
  jmp alltraps
801080c3:	e9 73 f8 ff ff       	jmp    8010793b <alltraps>

801080c8 <vector37>:
.globl vector37
vector37:
  pushl $0
801080c8:	6a 00                	push   $0x0
  pushl $37
801080ca:	6a 25                	push   $0x25
  jmp alltraps
801080cc:	e9 6a f8 ff ff       	jmp    8010793b <alltraps>

801080d1 <vector38>:
.globl vector38
vector38:
  pushl $0
801080d1:	6a 00                	push   $0x0
  pushl $38
801080d3:	6a 26                	push   $0x26
  jmp alltraps
801080d5:	e9 61 f8 ff ff       	jmp    8010793b <alltraps>

801080da <vector39>:
.globl vector39
vector39:
  pushl $0
801080da:	6a 00                	push   $0x0
  pushl $39
801080dc:	6a 27                	push   $0x27
  jmp alltraps
801080de:	e9 58 f8 ff ff       	jmp    8010793b <alltraps>

801080e3 <vector40>:
.globl vector40
vector40:
  pushl $0
801080e3:	6a 00                	push   $0x0
  pushl $40
801080e5:	6a 28                	push   $0x28
  jmp alltraps
801080e7:	e9 4f f8 ff ff       	jmp    8010793b <alltraps>

801080ec <vector41>:
.globl vector41
vector41:
  pushl $0
801080ec:	6a 00                	push   $0x0
  pushl $41
801080ee:	6a 29                	push   $0x29
  jmp alltraps
801080f0:	e9 46 f8 ff ff       	jmp    8010793b <alltraps>

801080f5 <vector42>:
.globl vector42
vector42:
  pushl $0
801080f5:	6a 00                	push   $0x0
  pushl $42
801080f7:	6a 2a                	push   $0x2a
  jmp alltraps
801080f9:	e9 3d f8 ff ff       	jmp    8010793b <alltraps>

801080fe <vector43>:
.globl vector43
vector43:
  pushl $0
801080fe:	6a 00                	push   $0x0
  pushl $43
80108100:	6a 2b                	push   $0x2b
  jmp alltraps
80108102:	e9 34 f8 ff ff       	jmp    8010793b <alltraps>

80108107 <vector44>:
.globl vector44
vector44:
  pushl $0
80108107:	6a 00                	push   $0x0
  pushl $44
80108109:	6a 2c                	push   $0x2c
  jmp alltraps
8010810b:	e9 2b f8 ff ff       	jmp    8010793b <alltraps>

80108110 <vector45>:
.globl vector45
vector45:
  pushl $0
80108110:	6a 00                	push   $0x0
  pushl $45
80108112:	6a 2d                	push   $0x2d
  jmp alltraps
80108114:	e9 22 f8 ff ff       	jmp    8010793b <alltraps>

80108119 <vector46>:
.globl vector46
vector46:
  pushl $0
80108119:	6a 00                	push   $0x0
  pushl $46
8010811b:	6a 2e                	push   $0x2e
  jmp alltraps
8010811d:	e9 19 f8 ff ff       	jmp    8010793b <alltraps>

80108122 <vector47>:
.globl vector47
vector47:
  pushl $0
80108122:	6a 00                	push   $0x0
  pushl $47
80108124:	6a 2f                	push   $0x2f
  jmp alltraps
80108126:	e9 10 f8 ff ff       	jmp    8010793b <alltraps>

8010812b <vector48>:
.globl vector48
vector48:
  pushl $0
8010812b:	6a 00                	push   $0x0
  pushl $48
8010812d:	6a 30                	push   $0x30
  jmp alltraps
8010812f:	e9 07 f8 ff ff       	jmp    8010793b <alltraps>

80108134 <vector49>:
.globl vector49
vector49:
  pushl $0
80108134:	6a 00                	push   $0x0
  pushl $49
80108136:	6a 31                	push   $0x31
  jmp alltraps
80108138:	e9 fe f7 ff ff       	jmp    8010793b <alltraps>

8010813d <vector50>:
.globl vector50
vector50:
  pushl $0
8010813d:	6a 00                	push   $0x0
  pushl $50
8010813f:	6a 32                	push   $0x32
  jmp alltraps
80108141:	e9 f5 f7 ff ff       	jmp    8010793b <alltraps>

80108146 <vector51>:
.globl vector51
vector51:
  pushl $0
80108146:	6a 00                	push   $0x0
  pushl $51
80108148:	6a 33                	push   $0x33
  jmp alltraps
8010814a:	e9 ec f7 ff ff       	jmp    8010793b <alltraps>

8010814f <vector52>:
.globl vector52
vector52:
  pushl $0
8010814f:	6a 00                	push   $0x0
  pushl $52
80108151:	6a 34                	push   $0x34
  jmp alltraps
80108153:	e9 e3 f7 ff ff       	jmp    8010793b <alltraps>

80108158 <vector53>:
.globl vector53
vector53:
  pushl $0
80108158:	6a 00                	push   $0x0
  pushl $53
8010815a:	6a 35                	push   $0x35
  jmp alltraps
8010815c:	e9 da f7 ff ff       	jmp    8010793b <alltraps>

80108161 <vector54>:
.globl vector54
vector54:
  pushl $0
80108161:	6a 00                	push   $0x0
  pushl $54
80108163:	6a 36                	push   $0x36
  jmp alltraps
80108165:	e9 d1 f7 ff ff       	jmp    8010793b <alltraps>

8010816a <vector55>:
.globl vector55
vector55:
  pushl $0
8010816a:	6a 00                	push   $0x0
  pushl $55
8010816c:	6a 37                	push   $0x37
  jmp alltraps
8010816e:	e9 c8 f7 ff ff       	jmp    8010793b <alltraps>

80108173 <vector56>:
.globl vector56
vector56:
  pushl $0
80108173:	6a 00                	push   $0x0
  pushl $56
80108175:	6a 38                	push   $0x38
  jmp alltraps
80108177:	e9 bf f7 ff ff       	jmp    8010793b <alltraps>

8010817c <vector57>:
.globl vector57
vector57:
  pushl $0
8010817c:	6a 00                	push   $0x0
  pushl $57
8010817e:	6a 39                	push   $0x39
  jmp alltraps
80108180:	e9 b6 f7 ff ff       	jmp    8010793b <alltraps>

80108185 <vector58>:
.globl vector58
vector58:
  pushl $0
80108185:	6a 00                	push   $0x0
  pushl $58
80108187:	6a 3a                	push   $0x3a
  jmp alltraps
80108189:	e9 ad f7 ff ff       	jmp    8010793b <alltraps>

8010818e <vector59>:
.globl vector59
vector59:
  pushl $0
8010818e:	6a 00                	push   $0x0
  pushl $59
80108190:	6a 3b                	push   $0x3b
  jmp alltraps
80108192:	e9 a4 f7 ff ff       	jmp    8010793b <alltraps>

80108197 <vector60>:
.globl vector60
vector60:
  pushl $0
80108197:	6a 00                	push   $0x0
  pushl $60
80108199:	6a 3c                	push   $0x3c
  jmp alltraps
8010819b:	e9 9b f7 ff ff       	jmp    8010793b <alltraps>

801081a0 <vector61>:
.globl vector61
vector61:
  pushl $0
801081a0:	6a 00                	push   $0x0
  pushl $61
801081a2:	6a 3d                	push   $0x3d
  jmp alltraps
801081a4:	e9 92 f7 ff ff       	jmp    8010793b <alltraps>

801081a9 <vector62>:
.globl vector62
vector62:
  pushl $0
801081a9:	6a 00                	push   $0x0
  pushl $62
801081ab:	6a 3e                	push   $0x3e
  jmp alltraps
801081ad:	e9 89 f7 ff ff       	jmp    8010793b <alltraps>

801081b2 <vector63>:
.globl vector63
vector63:
  pushl $0
801081b2:	6a 00                	push   $0x0
  pushl $63
801081b4:	6a 3f                	push   $0x3f
  jmp alltraps
801081b6:	e9 80 f7 ff ff       	jmp    8010793b <alltraps>

801081bb <vector64>:
.globl vector64
vector64:
  pushl $0
801081bb:	6a 00                	push   $0x0
  pushl $64
801081bd:	6a 40                	push   $0x40
  jmp alltraps
801081bf:	e9 77 f7 ff ff       	jmp    8010793b <alltraps>

801081c4 <vector65>:
.globl vector65
vector65:
  pushl $0
801081c4:	6a 00                	push   $0x0
  pushl $65
801081c6:	6a 41                	push   $0x41
  jmp alltraps
801081c8:	e9 6e f7 ff ff       	jmp    8010793b <alltraps>

801081cd <vector66>:
.globl vector66
vector66:
  pushl $0
801081cd:	6a 00                	push   $0x0
  pushl $66
801081cf:	6a 42                	push   $0x42
  jmp alltraps
801081d1:	e9 65 f7 ff ff       	jmp    8010793b <alltraps>

801081d6 <vector67>:
.globl vector67
vector67:
  pushl $0
801081d6:	6a 00                	push   $0x0
  pushl $67
801081d8:	6a 43                	push   $0x43
  jmp alltraps
801081da:	e9 5c f7 ff ff       	jmp    8010793b <alltraps>

801081df <vector68>:
.globl vector68
vector68:
  pushl $0
801081df:	6a 00                	push   $0x0
  pushl $68
801081e1:	6a 44                	push   $0x44
  jmp alltraps
801081e3:	e9 53 f7 ff ff       	jmp    8010793b <alltraps>

801081e8 <vector69>:
.globl vector69
vector69:
  pushl $0
801081e8:	6a 00                	push   $0x0
  pushl $69
801081ea:	6a 45                	push   $0x45
  jmp alltraps
801081ec:	e9 4a f7 ff ff       	jmp    8010793b <alltraps>

801081f1 <vector70>:
.globl vector70
vector70:
  pushl $0
801081f1:	6a 00                	push   $0x0
  pushl $70
801081f3:	6a 46                	push   $0x46
  jmp alltraps
801081f5:	e9 41 f7 ff ff       	jmp    8010793b <alltraps>

801081fa <vector71>:
.globl vector71
vector71:
  pushl $0
801081fa:	6a 00                	push   $0x0
  pushl $71
801081fc:	6a 47                	push   $0x47
  jmp alltraps
801081fe:	e9 38 f7 ff ff       	jmp    8010793b <alltraps>

80108203 <vector72>:
.globl vector72
vector72:
  pushl $0
80108203:	6a 00                	push   $0x0
  pushl $72
80108205:	6a 48                	push   $0x48
  jmp alltraps
80108207:	e9 2f f7 ff ff       	jmp    8010793b <alltraps>

8010820c <vector73>:
.globl vector73
vector73:
  pushl $0
8010820c:	6a 00                	push   $0x0
  pushl $73
8010820e:	6a 49                	push   $0x49
  jmp alltraps
80108210:	e9 26 f7 ff ff       	jmp    8010793b <alltraps>

80108215 <vector74>:
.globl vector74
vector74:
  pushl $0
80108215:	6a 00                	push   $0x0
  pushl $74
80108217:	6a 4a                	push   $0x4a
  jmp alltraps
80108219:	e9 1d f7 ff ff       	jmp    8010793b <alltraps>

8010821e <vector75>:
.globl vector75
vector75:
  pushl $0
8010821e:	6a 00                	push   $0x0
  pushl $75
80108220:	6a 4b                	push   $0x4b
  jmp alltraps
80108222:	e9 14 f7 ff ff       	jmp    8010793b <alltraps>

80108227 <vector76>:
.globl vector76
vector76:
  pushl $0
80108227:	6a 00                	push   $0x0
  pushl $76
80108229:	6a 4c                	push   $0x4c
  jmp alltraps
8010822b:	e9 0b f7 ff ff       	jmp    8010793b <alltraps>

80108230 <vector77>:
.globl vector77
vector77:
  pushl $0
80108230:	6a 00                	push   $0x0
  pushl $77
80108232:	6a 4d                	push   $0x4d
  jmp alltraps
80108234:	e9 02 f7 ff ff       	jmp    8010793b <alltraps>

80108239 <vector78>:
.globl vector78
vector78:
  pushl $0
80108239:	6a 00                	push   $0x0
  pushl $78
8010823b:	6a 4e                	push   $0x4e
  jmp alltraps
8010823d:	e9 f9 f6 ff ff       	jmp    8010793b <alltraps>

80108242 <vector79>:
.globl vector79
vector79:
  pushl $0
80108242:	6a 00                	push   $0x0
  pushl $79
80108244:	6a 4f                	push   $0x4f
  jmp alltraps
80108246:	e9 f0 f6 ff ff       	jmp    8010793b <alltraps>

8010824b <vector80>:
.globl vector80
vector80:
  pushl $0
8010824b:	6a 00                	push   $0x0
  pushl $80
8010824d:	6a 50                	push   $0x50
  jmp alltraps
8010824f:	e9 e7 f6 ff ff       	jmp    8010793b <alltraps>

80108254 <vector81>:
.globl vector81
vector81:
  pushl $0
80108254:	6a 00                	push   $0x0
  pushl $81
80108256:	6a 51                	push   $0x51
  jmp alltraps
80108258:	e9 de f6 ff ff       	jmp    8010793b <alltraps>

8010825d <vector82>:
.globl vector82
vector82:
  pushl $0
8010825d:	6a 00                	push   $0x0
  pushl $82
8010825f:	6a 52                	push   $0x52
  jmp alltraps
80108261:	e9 d5 f6 ff ff       	jmp    8010793b <alltraps>

80108266 <vector83>:
.globl vector83
vector83:
  pushl $0
80108266:	6a 00                	push   $0x0
  pushl $83
80108268:	6a 53                	push   $0x53
  jmp alltraps
8010826a:	e9 cc f6 ff ff       	jmp    8010793b <alltraps>

8010826f <vector84>:
.globl vector84
vector84:
  pushl $0
8010826f:	6a 00                	push   $0x0
  pushl $84
80108271:	6a 54                	push   $0x54
  jmp alltraps
80108273:	e9 c3 f6 ff ff       	jmp    8010793b <alltraps>

80108278 <vector85>:
.globl vector85
vector85:
  pushl $0
80108278:	6a 00                	push   $0x0
  pushl $85
8010827a:	6a 55                	push   $0x55
  jmp alltraps
8010827c:	e9 ba f6 ff ff       	jmp    8010793b <alltraps>

80108281 <vector86>:
.globl vector86
vector86:
  pushl $0
80108281:	6a 00                	push   $0x0
  pushl $86
80108283:	6a 56                	push   $0x56
  jmp alltraps
80108285:	e9 b1 f6 ff ff       	jmp    8010793b <alltraps>

8010828a <vector87>:
.globl vector87
vector87:
  pushl $0
8010828a:	6a 00                	push   $0x0
  pushl $87
8010828c:	6a 57                	push   $0x57
  jmp alltraps
8010828e:	e9 a8 f6 ff ff       	jmp    8010793b <alltraps>

80108293 <vector88>:
.globl vector88
vector88:
  pushl $0
80108293:	6a 00                	push   $0x0
  pushl $88
80108295:	6a 58                	push   $0x58
  jmp alltraps
80108297:	e9 9f f6 ff ff       	jmp    8010793b <alltraps>

8010829c <vector89>:
.globl vector89
vector89:
  pushl $0
8010829c:	6a 00                	push   $0x0
  pushl $89
8010829e:	6a 59                	push   $0x59
  jmp alltraps
801082a0:	e9 96 f6 ff ff       	jmp    8010793b <alltraps>

801082a5 <vector90>:
.globl vector90
vector90:
  pushl $0
801082a5:	6a 00                	push   $0x0
  pushl $90
801082a7:	6a 5a                	push   $0x5a
  jmp alltraps
801082a9:	e9 8d f6 ff ff       	jmp    8010793b <alltraps>

801082ae <vector91>:
.globl vector91
vector91:
  pushl $0
801082ae:	6a 00                	push   $0x0
  pushl $91
801082b0:	6a 5b                	push   $0x5b
  jmp alltraps
801082b2:	e9 84 f6 ff ff       	jmp    8010793b <alltraps>

801082b7 <vector92>:
.globl vector92
vector92:
  pushl $0
801082b7:	6a 00                	push   $0x0
  pushl $92
801082b9:	6a 5c                	push   $0x5c
  jmp alltraps
801082bb:	e9 7b f6 ff ff       	jmp    8010793b <alltraps>

801082c0 <vector93>:
.globl vector93
vector93:
  pushl $0
801082c0:	6a 00                	push   $0x0
  pushl $93
801082c2:	6a 5d                	push   $0x5d
  jmp alltraps
801082c4:	e9 72 f6 ff ff       	jmp    8010793b <alltraps>

801082c9 <vector94>:
.globl vector94
vector94:
  pushl $0
801082c9:	6a 00                	push   $0x0
  pushl $94
801082cb:	6a 5e                	push   $0x5e
  jmp alltraps
801082cd:	e9 69 f6 ff ff       	jmp    8010793b <alltraps>

801082d2 <vector95>:
.globl vector95
vector95:
  pushl $0
801082d2:	6a 00                	push   $0x0
  pushl $95
801082d4:	6a 5f                	push   $0x5f
  jmp alltraps
801082d6:	e9 60 f6 ff ff       	jmp    8010793b <alltraps>

801082db <vector96>:
.globl vector96
vector96:
  pushl $0
801082db:	6a 00                	push   $0x0
  pushl $96
801082dd:	6a 60                	push   $0x60
  jmp alltraps
801082df:	e9 57 f6 ff ff       	jmp    8010793b <alltraps>

801082e4 <vector97>:
.globl vector97
vector97:
  pushl $0
801082e4:	6a 00                	push   $0x0
  pushl $97
801082e6:	6a 61                	push   $0x61
  jmp alltraps
801082e8:	e9 4e f6 ff ff       	jmp    8010793b <alltraps>

801082ed <vector98>:
.globl vector98
vector98:
  pushl $0
801082ed:	6a 00                	push   $0x0
  pushl $98
801082ef:	6a 62                	push   $0x62
  jmp alltraps
801082f1:	e9 45 f6 ff ff       	jmp    8010793b <alltraps>

801082f6 <vector99>:
.globl vector99
vector99:
  pushl $0
801082f6:	6a 00                	push   $0x0
  pushl $99
801082f8:	6a 63                	push   $0x63
  jmp alltraps
801082fa:	e9 3c f6 ff ff       	jmp    8010793b <alltraps>

801082ff <vector100>:
.globl vector100
vector100:
  pushl $0
801082ff:	6a 00                	push   $0x0
  pushl $100
80108301:	6a 64                	push   $0x64
  jmp alltraps
80108303:	e9 33 f6 ff ff       	jmp    8010793b <alltraps>

80108308 <vector101>:
.globl vector101
vector101:
  pushl $0
80108308:	6a 00                	push   $0x0
  pushl $101
8010830a:	6a 65                	push   $0x65
  jmp alltraps
8010830c:	e9 2a f6 ff ff       	jmp    8010793b <alltraps>

80108311 <vector102>:
.globl vector102
vector102:
  pushl $0
80108311:	6a 00                	push   $0x0
  pushl $102
80108313:	6a 66                	push   $0x66
  jmp alltraps
80108315:	e9 21 f6 ff ff       	jmp    8010793b <alltraps>

8010831a <vector103>:
.globl vector103
vector103:
  pushl $0
8010831a:	6a 00                	push   $0x0
  pushl $103
8010831c:	6a 67                	push   $0x67
  jmp alltraps
8010831e:	e9 18 f6 ff ff       	jmp    8010793b <alltraps>

80108323 <vector104>:
.globl vector104
vector104:
  pushl $0
80108323:	6a 00                	push   $0x0
  pushl $104
80108325:	6a 68                	push   $0x68
  jmp alltraps
80108327:	e9 0f f6 ff ff       	jmp    8010793b <alltraps>

8010832c <vector105>:
.globl vector105
vector105:
  pushl $0
8010832c:	6a 00                	push   $0x0
  pushl $105
8010832e:	6a 69                	push   $0x69
  jmp alltraps
80108330:	e9 06 f6 ff ff       	jmp    8010793b <alltraps>

80108335 <vector106>:
.globl vector106
vector106:
  pushl $0
80108335:	6a 00                	push   $0x0
  pushl $106
80108337:	6a 6a                	push   $0x6a
  jmp alltraps
80108339:	e9 fd f5 ff ff       	jmp    8010793b <alltraps>

8010833e <vector107>:
.globl vector107
vector107:
  pushl $0
8010833e:	6a 00                	push   $0x0
  pushl $107
80108340:	6a 6b                	push   $0x6b
  jmp alltraps
80108342:	e9 f4 f5 ff ff       	jmp    8010793b <alltraps>

80108347 <vector108>:
.globl vector108
vector108:
  pushl $0
80108347:	6a 00                	push   $0x0
  pushl $108
80108349:	6a 6c                	push   $0x6c
  jmp alltraps
8010834b:	e9 eb f5 ff ff       	jmp    8010793b <alltraps>

80108350 <vector109>:
.globl vector109
vector109:
  pushl $0
80108350:	6a 00                	push   $0x0
  pushl $109
80108352:	6a 6d                	push   $0x6d
  jmp alltraps
80108354:	e9 e2 f5 ff ff       	jmp    8010793b <alltraps>

80108359 <vector110>:
.globl vector110
vector110:
  pushl $0
80108359:	6a 00                	push   $0x0
  pushl $110
8010835b:	6a 6e                	push   $0x6e
  jmp alltraps
8010835d:	e9 d9 f5 ff ff       	jmp    8010793b <alltraps>

80108362 <vector111>:
.globl vector111
vector111:
  pushl $0
80108362:	6a 00                	push   $0x0
  pushl $111
80108364:	6a 6f                	push   $0x6f
  jmp alltraps
80108366:	e9 d0 f5 ff ff       	jmp    8010793b <alltraps>

8010836b <vector112>:
.globl vector112
vector112:
  pushl $0
8010836b:	6a 00                	push   $0x0
  pushl $112
8010836d:	6a 70                	push   $0x70
  jmp alltraps
8010836f:	e9 c7 f5 ff ff       	jmp    8010793b <alltraps>

80108374 <vector113>:
.globl vector113
vector113:
  pushl $0
80108374:	6a 00                	push   $0x0
  pushl $113
80108376:	6a 71                	push   $0x71
  jmp alltraps
80108378:	e9 be f5 ff ff       	jmp    8010793b <alltraps>

8010837d <vector114>:
.globl vector114
vector114:
  pushl $0
8010837d:	6a 00                	push   $0x0
  pushl $114
8010837f:	6a 72                	push   $0x72
  jmp alltraps
80108381:	e9 b5 f5 ff ff       	jmp    8010793b <alltraps>

80108386 <vector115>:
.globl vector115
vector115:
  pushl $0
80108386:	6a 00                	push   $0x0
  pushl $115
80108388:	6a 73                	push   $0x73
  jmp alltraps
8010838a:	e9 ac f5 ff ff       	jmp    8010793b <alltraps>

8010838f <vector116>:
.globl vector116
vector116:
  pushl $0
8010838f:	6a 00                	push   $0x0
  pushl $116
80108391:	6a 74                	push   $0x74
  jmp alltraps
80108393:	e9 a3 f5 ff ff       	jmp    8010793b <alltraps>

80108398 <vector117>:
.globl vector117
vector117:
  pushl $0
80108398:	6a 00                	push   $0x0
  pushl $117
8010839a:	6a 75                	push   $0x75
  jmp alltraps
8010839c:	e9 9a f5 ff ff       	jmp    8010793b <alltraps>

801083a1 <vector118>:
.globl vector118
vector118:
  pushl $0
801083a1:	6a 00                	push   $0x0
  pushl $118
801083a3:	6a 76                	push   $0x76
  jmp alltraps
801083a5:	e9 91 f5 ff ff       	jmp    8010793b <alltraps>

801083aa <vector119>:
.globl vector119
vector119:
  pushl $0
801083aa:	6a 00                	push   $0x0
  pushl $119
801083ac:	6a 77                	push   $0x77
  jmp alltraps
801083ae:	e9 88 f5 ff ff       	jmp    8010793b <alltraps>

801083b3 <vector120>:
.globl vector120
vector120:
  pushl $0
801083b3:	6a 00                	push   $0x0
  pushl $120
801083b5:	6a 78                	push   $0x78
  jmp alltraps
801083b7:	e9 7f f5 ff ff       	jmp    8010793b <alltraps>

801083bc <vector121>:
.globl vector121
vector121:
  pushl $0
801083bc:	6a 00                	push   $0x0
  pushl $121
801083be:	6a 79                	push   $0x79
  jmp alltraps
801083c0:	e9 76 f5 ff ff       	jmp    8010793b <alltraps>

801083c5 <vector122>:
.globl vector122
vector122:
  pushl $0
801083c5:	6a 00                	push   $0x0
  pushl $122
801083c7:	6a 7a                	push   $0x7a
  jmp alltraps
801083c9:	e9 6d f5 ff ff       	jmp    8010793b <alltraps>

801083ce <vector123>:
.globl vector123
vector123:
  pushl $0
801083ce:	6a 00                	push   $0x0
  pushl $123
801083d0:	6a 7b                	push   $0x7b
  jmp alltraps
801083d2:	e9 64 f5 ff ff       	jmp    8010793b <alltraps>

801083d7 <vector124>:
.globl vector124
vector124:
  pushl $0
801083d7:	6a 00                	push   $0x0
  pushl $124
801083d9:	6a 7c                	push   $0x7c
  jmp alltraps
801083db:	e9 5b f5 ff ff       	jmp    8010793b <alltraps>

801083e0 <vector125>:
.globl vector125
vector125:
  pushl $0
801083e0:	6a 00                	push   $0x0
  pushl $125
801083e2:	6a 7d                	push   $0x7d
  jmp alltraps
801083e4:	e9 52 f5 ff ff       	jmp    8010793b <alltraps>

801083e9 <vector126>:
.globl vector126
vector126:
  pushl $0
801083e9:	6a 00                	push   $0x0
  pushl $126
801083eb:	6a 7e                	push   $0x7e
  jmp alltraps
801083ed:	e9 49 f5 ff ff       	jmp    8010793b <alltraps>

801083f2 <vector127>:
.globl vector127
vector127:
  pushl $0
801083f2:	6a 00                	push   $0x0
  pushl $127
801083f4:	6a 7f                	push   $0x7f
  jmp alltraps
801083f6:	e9 40 f5 ff ff       	jmp    8010793b <alltraps>

801083fb <vector128>:
.globl vector128
vector128:
  pushl $0
801083fb:	6a 00                	push   $0x0
  pushl $128
801083fd:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80108402:	e9 34 f5 ff ff       	jmp    8010793b <alltraps>

80108407 <vector129>:
.globl vector129
vector129:
  pushl $0
80108407:	6a 00                	push   $0x0
  pushl $129
80108409:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010840e:	e9 28 f5 ff ff       	jmp    8010793b <alltraps>

80108413 <vector130>:
.globl vector130
vector130:
  pushl $0
80108413:	6a 00                	push   $0x0
  pushl $130
80108415:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010841a:	e9 1c f5 ff ff       	jmp    8010793b <alltraps>

8010841f <vector131>:
.globl vector131
vector131:
  pushl $0
8010841f:	6a 00                	push   $0x0
  pushl $131
80108421:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80108426:	e9 10 f5 ff ff       	jmp    8010793b <alltraps>

8010842b <vector132>:
.globl vector132
vector132:
  pushl $0
8010842b:	6a 00                	push   $0x0
  pushl $132
8010842d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80108432:	e9 04 f5 ff ff       	jmp    8010793b <alltraps>

80108437 <vector133>:
.globl vector133
vector133:
  pushl $0
80108437:	6a 00                	push   $0x0
  pushl $133
80108439:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010843e:	e9 f8 f4 ff ff       	jmp    8010793b <alltraps>

80108443 <vector134>:
.globl vector134
vector134:
  pushl $0
80108443:	6a 00                	push   $0x0
  pushl $134
80108445:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010844a:	e9 ec f4 ff ff       	jmp    8010793b <alltraps>

8010844f <vector135>:
.globl vector135
vector135:
  pushl $0
8010844f:	6a 00                	push   $0x0
  pushl $135
80108451:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80108456:	e9 e0 f4 ff ff       	jmp    8010793b <alltraps>

8010845b <vector136>:
.globl vector136
vector136:
  pushl $0
8010845b:	6a 00                	push   $0x0
  pushl $136
8010845d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80108462:	e9 d4 f4 ff ff       	jmp    8010793b <alltraps>

80108467 <vector137>:
.globl vector137
vector137:
  pushl $0
80108467:	6a 00                	push   $0x0
  pushl $137
80108469:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010846e:	e9 c8 f4 ff ff       	jmp    8010793b <alltraps>

80108473 <vector138>:
.globl vector138
vector138:
  pushl $0
80108473:	6a 00                	push   $0x0
  pushl $138
80108475:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010847a:	e9 bc f4 ff ff       	jmp    8010793b <alltraps>

8010847f <vector139>:
.globl vector139
vector139:
  pushl $0
8010847f:	6a 00                	push   $0x0
  pushl $139
80108481:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80108486:	e9 b0 f4 ff ff       	jmp    8010793b <alltraps>

8010848b <vector140>:
.globl vector140
vector140:
  pushl $0
8010848b:	6a 00                	push   $0x0
  pushl $140
8010848d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80108492:	e9 a4 f4 ff ff       	jmp    8010793b <alltraps>

80108497 <vector141>:
.globl vector141
vector141:
  pushl $0
80108497:	6a 00                	push   $0x0
  pushl $141
80108499:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010849e:	e9 98 f4 ff ff       	jmp    8010793b <alltraps>

801084a3 <vector142>:
.globl vector142
vector142:
  pushl $0
801084a3:	6a 00                	push   $0x0
  pushl $142
801084a5:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801084aa:	e9 8c f4 ff ff       	jmp    8010793b <alltraps>

801084af <vector143>:
.globl vector143
vector143:
  pushl $0
801084af:	6a 00                	push   $0x0
  pushl $143
801084b1:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801084b6:	e9 80 f4 ff ff       	jmp    8010793b <alltraps>

801084bb <vector144>:
.globl vector144
vector144:
  pushl $0
801084bb:	6a 00                	push   $0x0
  pushl $144
801084bd:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801084c2:	e9 74 f4 ff ff       	jmp    8010793b <alltraps>

801084c7 <vector145>:
.globl vector145
vector145:
  pushl $0
801084c7:	6a 00                	push   $0x0
  pushl $145
801084c9:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801084ce:	e9 68 f4 ff ff       	jmp    8010793b <alltraps>

801084d3 <vector146>:
.globl vector146
vector146:
  pushl $0
801084d3:	6a 00                	push   $0x0
  pushl $146
801084d5:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801084da:	e9 5c f4 ff ff       	jmp    8010793b <alltraps>

801084df <vector147>:
.globl vector147
vector147:
  pushl $0
801084df:	6a 00                	push   $0x0
  pushl $147
801084e1:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801084e6:	e9 50 f4 ff ff       	jmp    8010793b <alltraps>

801084eb <vector148>:
.globl vector148
vector148:
  pushl $0
801084eb:	6a 00                	push   $0x0
  pushl $148
801084ed:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801084f2:	e9 44 f4 ff ff       	jmp    8010793b <alltraps>

801084f7 <vector149>:
.globl vector149
vector149:
  pushl $0
801084f7:	6a 00                	push   $0x0
  pushl $149
801084f9:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801084fe:	e9 38 f4 ff ff       	jmp    8010793b <alltraps>

80108503 <vector150>:
.globl vector150
vector150:
  pushl $0
80108503:	6a 00                	push   $0x0
  pushl $150
80108505:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010850a:	e9 2c f4 ff ff       	jmp    8010793b <alltraps>

8010850f <vector151>:
.globl vector151
vector151:
  pushl $0
8010850f:	6a 00                	push   $0x0
  pushl $151
80108511:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80108516:	e9 20 f4 ff ff       	jmp    8010793b <alltraps>

8010851b <vector152>:
.globl vector152
vector152:
  pushl $0
8010851b:	6a 00                	push   $0x0
  pushl $152
8010851d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80108522:	e9 14 f4 ff ff       	jmp    8010793b <alltraps>

80108527 <vector153>:
.globl vector153
vector153:
  pushl $0
80108527:	6a 00                	push   $0x0
  pushl $153
80108529:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010852e:	e9 08 f4 ff ff       	jmp    8010793b <alltraps>

80108533 <vector154>:
.globl vector154
vector154:
  pushl $0
80108533:	6a 00                	push   $0x0
  pushl $154
80108535:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010853a:	e9 fc f3 ff ff       	jmp    8010793b <alltraps>

8010853f <vector155>:
.globl vector155
vector155:
  pushl $0
8010853f:	6a 00                	push   $0x0
  pushl $155
80108541:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80108546:	e9 f0 f3 ff ff       	jmp    8010793b <alltraps>

8010854b <vector156>:
.globl vector156
vector156:
  pushl $0
8010854b:	6a 00                	push   $0x0
  pushl $156
8010854d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80108552:	e9 e4 f3 ff ff       	jmp    8010793b <alltraps>

80108557 <vector157>:
.globl vector157
vector157:
  pushl $0
80108557:	6a 00                	push   $0x0
  pushl $157
80108559:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010855e:	e9 d8 f3 ff ff       	jmp    8010793b <alltraps>

80108563 <vector158>:
.globl vector158
vector158:
  pushl $0
80108563:	6a 00                	push   $0x0
  pushl $158
80108565:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
8010856a:	e9 cc f3 ff ff       	jmp    8010793b <alltraps>

8010856f <vector159>:
.globl vector159
vector159:
  pushl $0
8010856f:	6a 00                	push   $0x0
  pushl $159
80108571:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80108576:	e9 c0 f3 ff ff       	jmp    8010793b <alltraps>

8010857b <vector160>:
.globl vector160
vector160:
  pushl $0
8010857b:	6a 00                	push   $0x0
  pushl $160
8010857d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80108582:	e9 b4 f3 ff ff       	jmp    8010793b <alltraps>

80108587 <vector161>:
.globl vector161
vector161:
  pushl $0
80108587:	6a 00                	push   $0x0
  pushl $161
80108589:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010858e:	e9 a8 f3 ff ff       	jmp    8010793b <alltraps>

80108593 <vector162>:
.globl vector162
vector162:
  pushl $0
80108593:	6a 00                	push   $0x0
  pushl $162
80108595:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010859a:	e9 9c f3 ff ff       	jmp    8010793b <alltraps>

8010859f <vector163>:
.globl vector163
vector163:
  pushl $0
8010859f:	6a 00                	push   $0x0
  pushl $163
801085a1:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801085a6:	e9 90 f3 ff ff       	jmp    8010793b <alltraps>

801085ab <vector164>:
.globl vector164
vector164:
  pushl $0
801085ab:	6a 00                	push   $0x0
  pushl $164
801085ad:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801085b2:	e9 84 f3 ff ff       	jmp    8010793b <alltraps>

801085b7 <vector165>:
.globl vector165
vector165:
  pushl $0
801085b7:	6a 00                	push   $0x0
  pushl $165
801085b9:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801085be:	e9 78 f3 ff ff       	jmp    8010793b <alltraps>

801085c3 <vector166>:
.globl vector166
vector166:
  pushl $0
801085c3:	6a 00                	push   $0x0
  pushl $166
801085c5:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801085ca:	e9 6c f3 ff ff       	jmp    8010793b <alltraps>

801085cf <vector167>:
.globl vector167
vector167:
  pushl $0
801085cf:	6a 00                	push   $0x0
  pushl $167
801085d1:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801085d6:	e9 60 f3 ff ff       	jmp    8010793b <alltraps>

801085db <vector168>:
.globl vector168
vector168:
  pushl $0
801085db:	6a 00                	push   $0x0
  pushl $168
801085dd:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801085e2:	e9 54 f3 ff ff       	jmp    8010793b <alltraps>

801085e7 <vector169>:
.globl vector169
vector169:
  pushl $0
801085e7:	6a 00                	push   $0x0
  pushl $169
801085e9:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801085ee:	e9 48 f3 ff ff       	jmp    8010793b <alltraps>

801085f3 <vector170>:
.globl vector170
vector170:
  pushl $0
801085f3:	6a 00                	push   $0x0
  pushl $170
801085f5:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801085fa:	e9 3c f3 ff ff       	jmp    8010793b <alltraps>

801085ff <vector171>:
.globl vector171
vector171:
  pushl $0
801085ff:	6a 00                	push   $0x0
  pushl $171
80108601:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80108606:	e9 30 f3 ff ff       	jmp    8010793b <alltraps>

8010860b <vector172>:
.globl vector172
vector172:
  pushl $0
8010860b:	6a 00                	push   $0x0
  pushl $172
8010860d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80108612:	e9 24 f3 ff ff       	jmp    8010793b <alltraps>

80108617 <vector173>:
.globl vector173
vector173:
  pushl $0
80108617:	6a 00                	push   $0x0
  pushl $173
80108619:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010861e:	e9 18 f3 ff ff       	jmp    8010793b <alltraps>

80108623 <vector174>:
.globl vector174
vector174:
  pushl $0
80108623:	6a 00                	push   $0x0
  pushl $174
80108625:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010862a:	e9 0c f3 ff ff       	jmp    8010793b <alltraps>

8010862f <vector175>:
.globl vector175
vector175:
  pushl $0
8010862f:	6a 00                	push   $0x0
  pushl $175
80108631:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80108636:	e9 00 f3 ff ff       	jmp    8010793b <alltraps>

8010863b <vector176>:
.globl vector176
vector176:
  pushl $0
8010863b:	6a 00                	push   $0x0
  pushl $176
8010863d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80108642:	e9 f4 f2 ff ff       	jmp    8010793b <alltraps>

80108647 <vector177>:
.globl vector177
vector177:
  pushl $0
80108647:	6a 00                	push   $0x0
  pushl $177
80108649:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010864e:	e9 e8 f2 ff ff       	jmp    8010793b <alltraps>

80108653 <vector178>:
.globl vector178
vector178:
  pushl $0
80108653:	6a 00                	push   $0x0
  pushl $178
80108655:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
8010865a:	e9 dc f2 ff ff       	jmp    8010793b <alltraps>

8010865f <vector179>:
.globl vector179
vector179:
  pushl $0
8010865f:	6a 00                	push   $0x0
  pushl $179
80108661:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80108666:	e9 d0 f2 ff ff       	jmp    8010793b <alltraps>

8010866b <vector180>:
.globl vector180
vector180:
  pushl $0
8010866b:	6a 00                	push   $0x0
  pushl $180
8010866d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80108672:	e9 c4 f2 ff ff       	jmp    8010793b <alltraps>

80108677 <vector181>:
.globl vector181
vector181:
  pushl $0
80108677:	6a 00                	push   $0x0
  pushl $181
80108679:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010867e:	e9 b8 f2 ff ff       	jmp    8010793b <alltraps>

80108683 <vector182>:
.globl vector182
vector182:
  pushl $0
80108683:	6a 00                	push   $0x0
  pushl $182
80108685:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010868a:	e9 ac f2 ff ff       	jmp    8010793b <alltraps>

8010868f <vector183>:
.globl vector183
vector183:
  pushl $0
8010868f:	6a 00                	push   $0x0
  pushl $183
80108691:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80108696:	e9 a0 f2 ff ff       	jmp    8010793b <alltraps>

8010869b <vector184>:
.globl vector184
vector184:
  pushl $0
8010869b:	6a 00                	push   $0x0
  pushl $184
8010869d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801086a2:	e9 94 f2 ff ff       	jmp    8010793b <alltraps>

801086a7 <vector185>:
.globl vector185
vector185:
  pushl $0
801086a7:	6a 00                	push   $0x0
  pushl $185
801086a9:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801086ae:	e9 88 f2 ff ff       	jmp    8010793b <alltraps>

801086b3 <vector186>:
.globl vector186
vector186:
  pushl $0
801086b3:	6a 00                	push   $0x0
  pushl $186
801086b5:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801086ba:	e9 7c f2 ff ff       	jmp    8010793b <alltraps>

801086bf <vector187>:
.globl vector187
vector187:
  pushl $0
801086bf:	6a 00                	push   $0x0
  pushl $187
801086c1:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801086c6:	e9 70 f2 ff ff       	jmp    8010793b <alltraps>

801086cb <vector188>:
.globl vector188
vector188:
  pushl $0
801086cb:	6a 00                	push   $0x0
  pushl $188
801086cd:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801086d2:	e9 64 f2 ff ff       	jmp    8010793b <alltraps>

801086d7 <vector189>:
.globl vector189
vector189:
  pushl $0
801086d7:	6a 00                	push   $0x0
  pushl $189
801086d9:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801086de:	e9 58 f2 ff ff       	jmp    8010793b <alltraps>

801086e3 <vector190>:
.globl vector190
vector190:
  pushl $0
801086e3:	6a 00                	push   $0x0
  pushl $190
801086e5:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801086ea:	e9 4c f2 ff ff       	jmp    8010793b <alltraps>

801086ef <vector191>:
.globl vector191
vector191:
  pushl $0
801086ef:	6a 00                	push   $0x0
  pushl $191
801086f1:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801086f6:	e9 40 f2 ff ff       	jmp    8010793b <alltraps>

801086fb <vector192>:
.globl vector192
vector192:
  pushl $0
801086fb:	6a 00                	push   $0x0
  pushl $192
801086fd:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80108702:	e9 34 f2 ff ff       	jmp    8010793b <alltraps>

80108707 <vector193>:
.globl vector193
vector193:
  pushl $0
80108707:	6a 00                	push   $0x0
  pushl $193
80108709:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010870e:	e9 28 f2 ff ff       	jmp    8010793b <alltraps>

80108713 <vector194>:
.globl vector194
vector194:
  pushl $0
80108713:	6a 00                	push   $0x0
  pushl $194
80108715:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
8010871a:	e9 1c f2 ff ff       	jmp    8010793b <alltraps>

8010871f <vector195>:
.globl vector195
vector195:
  pushl $0
8010871f:	6a 00                	push   $0x0
  pushl $195
80108721:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80108726:	e9 10 f2 ff ff       	jmp    8010793b <alltraps>

8010872b <vector196>:
.globl vector196
vector196:
  pushl $0
8010872b:	6a 00                	push   $0x0
  pushl $196
8010872d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80108732:	e9 04 f2 ff ff       	jmp    8010793b <alltraps>

80108737 <vector197>:
.globl vector197
vector197:
  pushl $0
80108737:	6a 00                	push   $0x0
  pushl $197
80108739:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010873e:	e9 f8 f1 ff ff       	jmp    8010793b <alltraps>

80108743 <vector198>:
.globl vector198
vector198:
  pushl $0
80108743:	6a 00                	push   $0x0
  pushl $198
80108745:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
8010874a:	e9 ec f1 ff ff       	jmp    8010793b <alltraps>

8010874f <vector199>:
.globl vector199
vector199:
  pushl $0
8010874f:	6a 00                	push   $0x0
  pushl $199
80108751:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80108756:	e9 e0 f1 ff ff       	jmp    8010793b <alltraps>

8010875b <vector200>:
.globl vector200
vector200:
  pushl $0
8010875b:	6a 00                	push   $0x0
  pushl $200
8010875d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80108762:	e9 d4 f1 ff ff       	jmp    8010793b <alltraps>

80108767 <vector201>:
.globl vector201
vector201:
  pushl $0
80108767:	6a 00                	push   $0x0
  pushl $201
80108769:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010876e:	e9 c8 f1 ff ff       	jmp    8010793b <alltraps>

80108773 <vector202>:
.globl vector202
vector202:
  pushl $0
80108773:	6a 00                	push   $0x0
  pushl $202
80108775:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010877a:	e9 bc f1 ff ff       	jmp    8010793b <alltraps>

8010877f <vector203>:
.globl vector203
vector203:
  pushl $0
8010877f:	6a 00                	push   $0x0
  pushl $203
80108781:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80108786:	e9 b0 f1 ff ff       	jmp    8010793b <alltraps>

8010878b <vector204>:
.globl vector204
vector204:
  pushl $0
8010878b:	6a 00                	push   $0x0
  pushl $204
8010878d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80108792:	e9 a4 f1 ff ff       	jmp    8010793b <alltraps>

80108797 <vector205>:
.globl vector205
vector205:
  pushl $0
80108797:	6a 00                	push   $0x0
  pushl $205
80108799:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010879e:	e9 98 f1 ff ff       	jmp    8010793b <alltraps>

801087a3 <vector206>:
.globl vector206
vector206:
  pushl $0
801087a3:	6a 00                	push   $0x0
  pushl $206
801087a5:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801087aa:	e9 8c f1 ff ff       	jmp    8010793b <alltraps>

801087af <vector207>:
.globl vector207
vector207:
  pushl $0
801087af:	6a 00                	push   $0x0
  pushl $207
801087b1:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801087b6:	e9 80 f1 ff ff       	jmp    8010793b <alltraps>

801087bb <vector208>:
.globl vector208
vector208:
  pushl $0
801087bb:	6a 00                	push   $0x0
  pushl $208
801087bd:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801087c2:	e9 74 f1 ff ff       	jmp    8010793b <alltraps>

801087c7 <vector209>:
.globl vector209
vector209:
  pushl $0
801087c7:	6a 00                	push   $0x0
  pushl $209
801087c9:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801087ce:	e9 68 f1 ff ff       	jmp    8010793b <alltraps>

801087d3 <vector210>:
.globl vector210
vector210:
  pushl $0
801087d3:	6a 00                	push   $0x0
  pushl $210
801087d5:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801087da:	e9 5c f1 ff ff       	jmp    8010793b <alltraps>

801087df <vector211>:
.globl vector211
vector211:
  pushl $0
801087df:	6a 00                	push   $0x0
  pushl $211
801087e1:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801087e6:	e9 50 f1 ff ff       	jmp    8010793b <alltraps>

801087eb <vector212>:
.globl vector212
vector212:
  pushl $0
801087eb:	6a 00                	push   $0x0
  pushl $212
801087ed:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801087f2:	e9 44 f1 ff ff       	jmp    8010793b <alltraps>

801087f7 <vector213>:
.globl vector213
vector213:
  pushl $0
801087f7:	6a 00                	push   $0x0
  pushl $213
801087f9:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801087fe:	e9 38 f1 ff ff       	jmp    8010793b <alltraps>

80108803 <vector214>:
.globl vector214
vector214:
  pushl $0
80108803:	6a 00                	push   $0x0
  pushl $214
80108805:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010880a:	e9 2c f1 ff ff       	jmp    8010793b <alltraps>

8010880f <vector215>:
.globl vector215
vector215:
  pushl $0
8010880f:	6a 00                	push   $0x0
  pushl $215
80108811:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80108816:	e9 20 f1 ff ff       	jmp    8010793b <alltraps>

8010881b <vector216>:
.globl vector216
vector216:
  pushl $0
8010881b:	6a 00                	push   $0x0
  pushl $216
8010881d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80108822:	e9 14 f1 ff ff       	jmp    8010793b <alltraps>

80108827 <vector217>:
.globl vector217
vector217:
  pushl $0
80108827:	6a 00                	push   $0x0
  pushl $217
80108829:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010882e:	e9 08 f1 ff ff       	jmp    8010793b <alltraps>

80108833 <vector218>:
.globl vector218
vector218:
  pushl $0
80108833:	6a 00                	push   $0x0
  pushl $218
80108835:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010883a:	e9 fc f0 ff ff       	jmp    8010793b <alltraps>

8010883f <vector219>:
.globl vector219
vector219:
  pushl $0
8010883f:	6a 00                	push   $0x0
  pushl $219
80108841:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80108846:	e9 f0 f0 ff ff       	jmp    8010793b <alltraps>

8010884b <vector220>:
.globl vector220
vector220:
  pushl $0
8010884b:	6a 00                	push   $0x0
  pushl $220
8010884d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80108852:	e9 e4 f0 ff ff       	jmp    8010793b <alltraps>

80108857 <vector221>:
.globl vector221
vector221:
  pushl $0
80108857:	6a 00                	push   $0x0
  pushl $221
80108859:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010885e:	e9 d8 f0 ff ff       	jmp    8010793b <alltraps>

80108863 <vector222>:
.globl vector222
vector222:
  pushl $0
80108863:	6a 00                	push   $0x0
  pushl $222
80108865:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010886a:	e9 cc f0 ff ff       	jmp    8010793b <alltraps>

8010886f <vector223>:
.globl vector223
vector223:
  pushl $0
8010886f:	6a 00                	push   $0x0
  pushl $223
80108871:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80108876:	e9 c0 f0 ff ff       	jmp    8010793b <alltraps>

8010887b <vector224>:
.globl vector224
vector224:
  pushl $0
8010887b:	6a 00                	push   $0x0
  pushl $224
8010887d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80108882:	e9 b4 f0 ff ff       	jmp    8010793b <alltraps>

80108887 <vector225>:
.globl vector225
vector225:
  pushl $0
80108887:	6a 00                	push   $0x0
  pushl $225
80108889:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010888e:	e9 a8 f0 ff ff       	jmp    8010793b <alltraps>

80108893 <vector226>:
.globl vector226
vector226:
  pushl $0
80108893:	6a 00                	push   $0x0
  pushl $226
80108895:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010889a:	e9 9c f0 ff ff       	jmp    8010793b <alltraps>

8010889f <vector227>:
.globl vector227
vector227:
  pushl $0
8010889f:	6a 00                	push   $0x0
  pushl $227
801088a1:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801088a6:	e9 90 f0 ff ff       	jmp    8010793b <alltraps>

801088ab <vector228>:
.globl vector228
vector228:
  pushl $0
801088ab:	6a 00                	push   $0x0
  pushl $228
801088ad:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801088b2:	e9 84 f0 ff ff       	jmp    8010793b <alltraps>

801088b7 <vector229>:
.globl vector229
vector229:
  pushl $0
801088b7:	6a 00                	push   $0x0
  pushl $229
801088b9:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801088be:	e9 78 f0 ff ff       	jmp    8010793b <alltraps>

801088c3 <vector230>:
.globl vector230
vector230:
  pushl $0
801088c3:	6a 00                	push   $0x0
  pushl $230
801088c5:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801088ca:	e9 6c f0 ff ff       	jmp    8010793b <alltraps>

801088cf <vector231>:
.globl vector231
vector231:
  pushl $0
801088cf:	6a 00                	push   $0x0
  pushl $231
801088d1:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801088d6:	e9 60 f0 ff ff       	jmp    8010793b <alltraps>

801088db <vector232>:
.globl vector232
vector232:
  pushl $0
801088db:	6a 00                	push   $0x0
  pushl $232
801088dd:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801088e2:	e9 54 f0 ff ff       	jmp    8010793b <alltraps>

801088e7 <vector233>:
.globl vector233
vector233:
  pushl $0
801088e7:	6a 00                	push   $0x0
  pushl $233
801088e9:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801088ee:	e9 48 f0 ff ff       	jmp    8010793b <alltraps>

801088f3 <vector234>:
.globl vector234
vector234:
  pushl $0
801088f3:	6a 00                	push   $0x0
  pushl $234
801088f5:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801088fa:	e9 3c f0 ff ff       	jmp    8010793b <alltraps>

801088ff <vector235>:
.globl vector235
vector235:
  pushl $0
801088ff:	6a 00                	push   $0x0
  pushl $235
80108901:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80108906:	e9 30 f0 ff ff       	jmp    8010793b <alltraps>

8010890b <vector236>:
.globl vector236
vector236:
  pushl $0
8010890b:	6a 00                	push   $0x0
  pushl $236
8010890d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80108912:	e9 24 f0 ff ff       	jmp    8010793b <alltraps>

80108917 <vector237>:
.globl vector237
vector237:
  pushl $0
80108917:	6a 00                	push   $0x0
  pushl $237
80108919:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010891e:	e9 18 f0 ff ff       	jmp    8010793b <alltraps>

80108923 <vector238>:
.globl vector238
vector238:
  pushl $0
80108923:	6a 00                	push   $0x0
  pushl $238
80108925:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010892a:	e9 0c f0 ff ff       	jmp    8010793b <alltraps>

8010892f <vector239>:
.globl vector239
vector239:
  pushl $0
8010892f:	6a 00                	push   $0x0
  pushl $239
80108931:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80108936:	e9 00 f0 ff ff       	jmp    8010793b <alltraps>

8010893b <vector240>:
.globl vector240
vector240:
  pushl $0
8010893b:	6a 00                	push   $0x0
  pushl $240
8010893d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80108942:	e9 f4 ef ff ff       	jmp    8010793b <alltraps>

80108947 <vector241>:
.globl vector241
vector241:
  pushl $0
80108947:	6a 00                	push   $0x0
  pushl $241
80108949:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010894e:	e9 e8 ef ff ff       	jmp    8010793b <alltraps>

80108953 <vector242>:
.globl vector242
vector242:
  pushl $0
80108953:	6a 00                	push   $0x0
  pushl $242
80108955:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010895a:	e9 dc ef ff ff       	jmp    8010793b <alltraps>

8010895f <vector243>:
.globl vector243
vector243:
  pushl $0
8010895f:	6a 00                	push   $0x0
  pushl $243
80108961:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80108966:	e9 d0 ef ff ff       	jmp    8010793b <alltraps>

8010896b <vector244>:
.globl vector244
vector244:
  pushl $0
8010896b:	6a 00                	push   $0x0
  pushl $244
8010896d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80108972:	e9 c4 ef ff ff       	jmp    8010793b <alltraps>

80108977 <vector245>:
.globl vector245
vector245:
  pushl $0
80108977:	6a 00                	push   $0x0
  pushl $245
80108979:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010897e:	e9 b8 ef ff ff       	jmp    8010793b <alltraps>

80108983 <vector246>:
.globl vector246
vector246:
  pushl $0
80108983:	6a 00                	push   $0x0
  pushl $246
80108985:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010898a:	e9 ac ef ff ff       	jmp    8010793b <alltraps>

8010898f <vector247>:
.globl vector247
vector247:
  pushl $0
8010898f:	6a 00                	push   $0x0
  pushl $247
80108991:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80108996:	e9 a0 ef ff ff       	jmp    8010793b <alltraps>

8010899b <vector248>:
.globl vector248
vector248:
  pushl $0
8010899b:	6a 00                	push   $0x0
  pushl $248
8010899d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801089a2:	e9 94 ef ff ff       	jmp    8010793b <alltraps>

801089a7 <vector249>:
.globl vector249
vector249:
  pushl $0
801089a7:	6a 00                	push   $0x0
  pushl $249
801089a9:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801089ae:	e9 88 ef ff ff       	jmp    8010793b <alltraps>

801089b3 <vector250>:
.globl vector250
vector250:
  pushl $0
801089b3:	6a 00                	push   $0x0
  pushl $250
801089b5:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801089ba:	e9 7c ef ff ff       	jmp    8010793b <alltraps>

801089bf <vector251>:
.globl vector251
vector251:
  pushl $0
801089bf:	6a 00                	push   $0x0
  pushl $251
801089c1:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801089c6:	e9 70 ef ff ff       	jmp    8010793b <alltraps>

801089cb <vector252>:
.globl vector252
vector252:
  pushl $0
801089cb:	6a 00                	push   $0x0
  pushl $252
801089cd:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801089d2:	e9 64 ef ff ff       	jmp    8010793b <alltraps>

801089d7 <vector253>:
.globl vector253
vector253:
  pushl $0
801089d7:	6a 00                	push   $0x0
  pushl $253
801089d9:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801089de:	e9 58 ef ff ff       	jmp    8010793b <alltraps>

801089e3 <vector254>:
.globl vector254
vector254:
  pushl $0
801089e3:	6a 00                	push   $0x0
  pushl $254
801089e5:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801089ea:	e9 4c ef ff ff       	jmp    8010793b <alltraps>

801089ef <vector255>:
.globl vector255
vector255:
  pushl $0
801089ef:	6a 00                	push   $0x0
  pushl $255
801089f1:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801089f6:	e9 40 ef ff ff       	jmp    8010793b <alltraps>

801089fb <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
801089fb:	55                   	push   %ebp
801089fc:	89 e5                	mov    %esp,%ebp
801089fe:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80108a01:	8b 45 0c             	mov    0xc(%ebp),%eax
80108a04:	83 e8 01             	sub    $0x1,%eax
80108a07:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80108a0b:	8b 45 08             	mov    0x8(%ebp),%eax
80108a0e:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80108a12:	8b 45 08             	mov    0x8(%ebp),%eax
80108a15:	c1 e8 10             	shr    $0x10,%eax
80108a18:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80108a1c:	8d 45 fa             	lea    -0x6(%ebp),%eax
80108a1f:	0f 01 10             	lgdtl  (%eax)
}
80108a22:	90                   	nop
80108a23:	c9                   	leave  
80108a24:	c3                   	ret    

80108a25 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80108a25:	55                   	push   %ebp
80108a26:	89 e5                	mov    %esp,%ebp
80108a28:	83 ec 04             	sub    $0x4,%esp
80108a2b:	8b 45 08             	mov    0x8(%ebp),%eax
80108a2e:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80108a32:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80108a36:	0f 00 d8             	ltr    %ax
}
80108a39:	90                   	nop
80108a3a:	c9                   	leave  
80108a3b:	c3                   	ret    

80108a3c <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80108a3c:	55                   	push   %ebp
80108a3d:	89 e5                	mov    %esp,%ebp
80108a3f:	83 ec 04             	sub    $0x4,%esp
80108a42:	8b 45 08             	mov    0x8(%ebp),%eax
80108a45:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80108a49:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80108a4d:	8e e8                	mov    %eax,%gs
}
80108a4f:	90                   	nop
80108a50:	c9                   	leave  
80108a51:	c3                   	ret    

80108a52 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80108a52:	55                   	push   %ebp
80108a53:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80108a55:	8b 45 08             	mov    0x8(%ebp),%eax
80108a58:	0f 22 d8             	mov    %eax,%cr3
}
80108a5b:	90                   	nop
80108a5c:	5d                   	pop    %ebp
80108a5d:	c3                   	ret    

80108a5e <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80108a5e:	55                   	push   %ebp
80108a5f:	89 e5                	mov    %esp,%ebp
80108a61:	8b 45 08             	mov    0x8(%ebp),%eax
80108a64:	05 00 00 00 80       	add    $0x80000000,%eax
80108a69:	5d                   	pop    %ebp
80108a6a:	c3                   	ret    

80108a6b <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80108a6b:	55                   	push   %ebp
80108a6c:	89 e5                	mov    %esp,%ebp
80108a6e:	8b 45 08             	mov    0x8(%ebp),%eax
80108a71:	05 00 00 00 80       	add    $0x80000000,%eax
80108a76:	5d                   	pop    %ebp
80108a77:	c3                   	ret    

80108a78 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80108a78:	55                   	push   %ebp
80108a79:	89 e5                	mov    %esp,%ebp
80108a7b:	53                   	push   %ebx
80108a7c:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80108a7f:	e8 e6 a5 ff ff       	call   8010306a <cpunum>
80108a84:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80108a8a:	05 80 43 11 80       	add    $0x80114380,%eax
80108a8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80108a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a95:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80108a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a9e:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80108aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108aa7:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80108aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108aae:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108ab2:	83 e2 f0             	and    $0xfffffff0,%edx
80108ab5:	83 ca 0a             	or     $0xa,%edx
80108ab8:	88 50 7d             	mov    %dl,0x7d(%eax)
80108abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108abe:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108ac2:	83 ca 10             	or     $0x10,%edx
80108ac5:	88 50 7d             	mov    %dl,0x7d(%eax)
80108ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108acb:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108acf:	83 e2 9f             	and    $0xffffff9f,%edx
80108ad2:	88 50 7d             	mov    %dl,0x7d(%eax)
80108ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ad8:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108adc:	83 ca 80             	or     $0xffffff80,%edx
80108adf:	88 50 7d             	mov    %dl,0x7d(%eax)
80108ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ae5:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108ae9:	83 ca 0f             	or     $0xf,%edx
80108aec:	88 50 7e             	mov    %dl,0x7e(%eax)
80108aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108af2:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108af6:	83 e2 ef             	and    $0xffffffef,%edx
80108af9:	88 50 7e             	mov    %dl,0x7e(%eax)
80108afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108aff:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108b03:	83 e2 df             	and    $0xffffffdf,%edx
80108b06:	88 50 7e             	mov    %dl,0x7e(%eax)
80108b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b0c:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108b10:	83 ca 40             	or     $0x40,%edx
80108b13:	88 50 7e             	mov    %dl,0x7e(%eax)
80108b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b19:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108b1d:	83 ca 80             	or     $0xffffff80,%edx
80108b20:	88 50 7e             	mov    %dl,0x7e(%eax)
80108b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b26:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80108b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b2d:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80108b34:	ff ff 
80108b36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b39:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80108b40:	00 00 
80108b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b45:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80108b4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b4f:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108b56:	83 e2 f0             	and    $0xfffffff0,%edx
80108b59:	83 ca 02             	or     $0x2,%edx
80108b5c:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108b62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b65:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108b6c:	83 ca 10             	or     $0x10,%edx
80108b6f:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b78:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108b7f:	83 e2 9f             	and    $0xffffff9f,%edx
80108b82:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b8b:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108b92:	83 ca 80             	or     $0xffffff80,%edx
80108b95:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b9e:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108ba5:	83 ca 0f             	or     $0xf,%edx
80108ba8:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bb1:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108bb8:	83 e2 ef             	and    $0xffffffef,%edx
80108bbb:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bc4:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108bcb:	83 e2 df             	and    $0xffffffdf,%edx
80108bce:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bd7:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108bde:	83 ca 40             	or     $0x40,%edx
80108be1:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bea:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108bf1:	83 ca 80             	or     $0xffffff80,%edx
80108bf4:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bfd:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80108c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c07:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80108c0e:	ff ff 
80108c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c13:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80108c1a:	00 00 
80108c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c1f:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80108c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c29:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108c30:	83 e2 f0             	and    $0xfffffff0,%edx
80108c33:	83 ca 0a             	or     $0xa,%edx
80108c36:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c3f:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108c46:	83 ca 10             	or     $0x10,%edx
80108c49:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c52:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108c59:	83 ca 60             	or     $0x60,%edx
80108c5c:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c65:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108c6c:	83 ca 80             	or     $0xffffff80,%edx
80108c6f:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c78:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108c7f:	83 ca 0f             	or     $0xf,%edx
80108c82:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c8b:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108c92:	83 e2 ef             	and    $0xffffffef,%edx
80108c95:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c9e:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108ca5:	83 e2 df             	and    $0xffffffdf,%edx
80108ca8:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cb1:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108cb8:	83 ca 40             	or     $0x40,%edx
80108cbb:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cc4:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108ccb:	83 ca 80             	or     $0xffffff80,%edx
80108cce:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cd7:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80108cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ce1:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80108ce8:	ff ff 
80108cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ced:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80108cf4:	00 00 
80108cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cf9:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80108d00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d03:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108d0a:	83 e2 f0             	and    $0xfffffff0,%edx
80108d0d:	83 ca 02             	or     $0x2,%edx
80108d10:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d19:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108d20:	83 ca 10             	or     $0x10,%edx
80108d23:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d2c:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108d33:	83 ca 60             	or     $0x60,%edx
80108d36:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d3f:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108d46:	83 ca 80             	or     $0xffffff80,%edx
80108d49:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d52:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108d59:	83 ca 0f             	or     $0xf,%edx
80108d5c:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d65:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108d6c:	83 e2 ef             	and    $0xffffffef,%edx
80108d6f:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d78:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108d7f:	83 e2 df             	and    $0xffffffdf,%edx
80108d82:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d8b:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108d92:	83 ca 40             	or     $0x40,%edx
80108d95:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d9e:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108da5:	83 ca 80             	or     $0xffffff80,%edx
80108da8:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108db1:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80108db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108dbb:	05 b4 00 00 00       	add    $0xb4,%eax
80108dc0:	89 c3                	mov    %eax,%ebx
80108dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108dc5:	05 b4 00 00 00       	add    $0xb4,%eax
80108dca:	c1 e8 10             	shr    $0x10,%eax
80108dcd:	89 c2                	mov    %eax,%edx
80108dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108dd2:	05 b4 00 00 00       	add    $0xb4,%eax
80108dd7:	c1 e8 18             	shr    $0x18,%eax
80108dda:	89 c1                	mov    %eax,%ecx
80108ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ddf:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80108de6:	00 00 
80108de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108deb:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80108df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108df5:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
80108dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108dfe:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108e05:	83 e2 f0             	and    $0xfffffff0,%edx
80108e08:	83 ca 02             	or     $0x2,%edx
80108e0b:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108e11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e14:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108e1b:	83 ca 10             	or     $0x10,%edx
80108e1e:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e27:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108e2e:	83 e2 9f             	and    $0xffffff9f,%edx
80108e31:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e3a:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108e41:	83 ca 80             	or     $0xffffff80,%edx
80108e44:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e4d:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108e54:	83 e2 f0             	and    $0xfffffff0,%edx
80108e57:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e60:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108e67:	83 e2 ef             	and    $0xffffffef,%edx
80108e6a:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e73:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108e7a:	83 e2 df             	and    $0xffffffdf,%edx
80108e7d:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e86:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108e8d:	83 ca 40             	or     $0x40,%edx
80108e90:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e99:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108ea0:	83 ca 80             	or     $0xffffff80,%edx
80108ea3:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108eac:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80108eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108eb5:	83 c0 70             	add    $0x70,%eax
80108eb8:	83 ec 08             	sub    $0x8,%esp
80108ebb:	6a 38                	push   $0x38
80108ebd:	50                   	push   %eax
80108ebe:	e8 38 fb ff ff       	call   801089fb <lgdt>
80108ec3:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
80108ec6:	83 ec 0c             	sub    $0xc,%esp
80108ec9:	6a 18                	push   $0x18
80108ecb:	e8 6c fb ff ff       	call   80108a3c <loadgs>
80108ed0:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
80108ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ed6:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80108edc:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80108ee3:	00 00 00 00 
}
80108ee7:	90                   	nop
80108ee8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108eeb:	c9                   	leave  
80108eec:	c3                   	ret    

80108eed <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80108eed:	55                   	push   %ebp
80108eee:	89 e5                	mov    %esp,%ebp
80108ef0:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80108ef3:	8b 45 0c             	mov    0xc(%ebp),%eax
80108ef6:	c1 e8 16             	shr    $0x16,%eax
80108ef9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108f00:	8b 45 08             	mov    0x8(%ebp),%eax
80108f03:	01 d0                	add    %edx,%eax
80108f05:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80108f08:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f0b:	8b 00                	mov    (%eax),%eax
80108f0d:	83 e0 01             	and    $0x1,%eax
80108f10:	85 c0                	test   %eax,%eax
80108f12:	74 18                	je     80108f2c <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80108f14:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f17:	8b 00                	mov    (%eax),%eax
80108f19:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108f1e:	50                   	push   %eax
80108f1f:	e8 47 fb ff ff       	call   80108a6b <p2v>
80108f24:	83 c4 04             	add    $0x4,%esp
80108f27:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108f2a:	eb 48                	jmp    80108f74 <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80108f2c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80108f30:	74 0e                	je     80108f40 <walkpgdir+0x53>
80108f32:	e8 cd 9d ff ff       	call   80102d04 <kalloc>
80108f37:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108f3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108f3e:	75 07                	jne    80108f47 <walkpgdir+0x5a>
      return 0;
80108f40:	b8 00 00 00 00       	mov    $0x0,%eax
80108f45:	eb 44                	jmp    80108f8b <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80108f47:	83 ec 04             	sub    $0x4,%esp
80108f4a:	68 00 10 00 00       	push   $0x1000
80108f4f:	6a 00                	push   $0x0
80108f51:	ff 75 f4             	pushl  -0xc(%ebp)
80108f54:	e8 75 d4 ff ff       	call   801063ce <memset>
80108f59:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80108f5c:	83 ec 0c             	sub    $0xc,%esp
80108f5f:	ff 75 f4             	pushl  -0xc(%ebp)
80108f62:	e8 f7 fa ff ff       	call   80108a5e <v2p>
80108f67:	83 c4 10             	add    $0x10,%esp
80108f6a:	83 c8 07             	or     $0x7,%eax
80108f6d:	89 c2                	mov    %eax,%edx
80108f6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f72:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80108f74:	8b 45 0c             	mov    0xc(%ebp),%eax
80108f77:	c1 e8 0c             	shr    $0xc,%eax
80108f7a:	25 ff 03 00 00       	and    $0x3ff,%eax
80108f7f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f89:	01 d0                	add    %edx,%eax
}
80108f8b:	c9                   	leave  
80108f8c:	c3                   	ret    

80108f8d <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80108f8d:	55                   	push   %ebp
80108f8e:	89 e5                	mov    %esp,%ebp
80108f90:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80108f93:	8b 45 0c             	mov    0xc(%ebp),%eax
80108f96:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108f9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80108f9e:	8b 55 0c             	mov    0xc(%ebp),%edx
80108fa1:	8b 45 10             	mov    0x10(%ebp),%eax
80108fa4:	01 d0                	add    %edx,%eax
80108fa6:	83 e8 01             	sub    $0x1,%eax
80108fa9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108fae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108fb1:	83 ec 04             	sub    $0x4,%esp
80108fb4:	6a 01                	push   $0x1
80108fb6:	ff 75 f4             	pushl  -0xc(%ebp)
80108fb9:	ff 75 08             	pushl  0x8(%ebp)
80108fbc:	e8 2c ff ff ff       	call   80108eed <walkpgdir>
80108fc1:	83 c4 10             	add    $0x10,%esp
80108fc4:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108fc7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108fcb:	75 07                	jne    80108fd4 <mappages+0x47>
      return -1;
80108fcd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108fd2:	eb 47                	jmp    8010901b <mappages+0x8e>
    if(*pte & PTE_P)
80108fd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108fd7:	8b 00                	mov    (%eax),%eax
80108fd9:	83 e0 01             	and    $0x1,%eax
80108fdc:	85 c0                	test   %eax,%eax
80108fde:	74 0d                	je     80108fed <mappages+0x60>
      panic("remap");
80108fe0:	83 ec 0c             	sub    $0xc,%esp
80108fe3:	68 68 a0 10 80       	push   $0x8010a068
80108fe8:	e8 79 75 ff ff       	call   80100566 <panic>
    *pte = pa | perm | PTE_P;
80108fed:	8b 45 18             	mov    0x18(%ebp),%eax
80108ff0:	0b 45 14             	or     0x14(%ebp),%eax
80108ff3:	83 c8 01             	or     $0x1,%eax
80108ff6:	89 c2                	mov    %eax,%edx
80108ff8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108ffb:	89 10                	mov    %edx,(%eax)
    if(a == last)
80108ffd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109000:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80109003:	74 10                	je     80109015 <mappages+0x88>
      break;
    a += PGSIZE;
80109005:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
8010900c:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80109013:	eb 9c                	jmp    80108fb1 <mappages+0x24>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
80109015:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80109016:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010901b:	c9                   	leave  
8010901c:	c3                   	ret    

8010901d <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
8010901d:	55                   	push   %ebp
8010901e:	89 e5                	mov    %esp,%ebp
80109020:	53                   	push   %ebx
80109021:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80109024:	e8 db 9c ff ff       	call   80102d04 <kalloc>
80109029:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010902c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109030:	75 0a                	jne    8010903c <setupkvm+0x1f>
    return 0;
80109032:	b8 00 00 00 00       	mov    $0x0,%eax
80109037:	e9 8e 00 00 00       	jmp    801090ca <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
8010903c:	83 ec 04             	sub    $0x4,%esp
8010903f:	68 00 10 00 00       	push   $0x1000
80109044:	6a 00                	push   $0x0
80109046:	ff 75 f0             	pushl  -0x10(%ebp)
80109049:	e8 80 d3 ff ff       	call   801063ce <memset>
8010904e:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80109051:	83 ec 0c             	sub    $0xc,%esp
80109054:	68 00 00 00 0e       	push   $0xe000000
80109059:	e8 0d fa ff ff       	call   80108a6b <p2v>
8010905e:	83 c4 10             	add    $0x10,%esp
80109061:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80109066:	76 0d                	jbe    80109075 <setupkvm+0x58>
    panic("PHYSTOP too high");
80109068:	83 ec 0c             	sub    $0xc,%esp
8010906b:	68 6e a0 10 80       	push   $0x8010a06e
80109070:	e8 f1 74 ff ff       	call   80100566 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80109075:	c7 45 f4 c0 d4 10 80 	movl   $0x8010d4c0,-0xc(%ebp)
8010907c:	eb 40                	jmp    801090be <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
8010907e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109081:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
80109084:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109087:	8b 50 04             	mov    0x4(%eax),%edx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
8010908a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010908d:	8b 58 08             	mov    0x8(%eax),%ebx
80109090:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109093:	8b 40 04             	mov    0x4(%eax),%eax
80109096:	29 c3                	sub    %eax,%ebx
80109098:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010909b:	8b 00                	mov    (%eax),%eax
8010909d:	83 ec 0c             	sub    $0xc,%esp
801090a0:	51                   	push   %ecx
801090a1:	52                   	push   %edx
801090a2:	53                   	push   %ebx
801090a3:	50                   	push   %eax
801090a4:	ff 75 f0             	pushl  -0x10(%ebp)
801090a7:	e8 e1 fe ff ff       	call   80108f8d <mappages>
801090ac:	83 c4 20             	add    $0x20,%esp
801090af:	85 c0                	test   %eax,%eax
801090b1:	79 07                	jns    801090ba <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
801090b3:	b8 00 00 00 00       	mov    $0x0,%eax
801090b8:	eb 10                	jmp    801090ca <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801090ba:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801090be:	81 7d f4 00 d5 10 80 	cmpl   $0x8010d500,-0xc(%ebp)
801090c5:	72 b7                	jb     8010907e <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
801090c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801090ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801090cd:	c9                   	leave  
801090ce:	c3                   	ret    

801090cf <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
801090cf:	55                   	push   %ebp
801090d0:	89 e5                	mov    %esp,%ebp
801090d2:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801090d5:	e8 43 ff ff ff       	call   8010901d <setupkvm>
801090da:	a3 58 79 11 80       	mov    %eax,0x80117958
  switchkvm();
801090df:	e8 03 00 00 00       	call   801090e7 <switchkvm>
}
801090e4:	90                   	nop
801090e5:	c9                   	leave  
801090e6:	c3                   	ret    

801090e7 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801090e7:	55                   	push   %ebp
801090e8:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
801090ea:	a1 58 79 11 80       	mov    0x80117958,%eax
801090ef:	50                   	push   %eax
801090f0:	e8 69 f9 ff ff       	call   80108a5e <v2p>
801090f5:	83 c4 04             	add    $0x4,%esp
801090f8:	50                   	push   %eax
801090f9:	e8 54 f9 ff ff       	call   80108a52 <lcr3>
801090fe:	83 c4 04             	add    $0x4,%esp
}
80109101:	90                   	nop
80109102:	c9                   	leave  
80109103:	c3                   	ret    

80109104 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80109104:	55                   	push   %ebp
80109105:	89 e5                	mov    %esp,%ebp
80109107:	56                   	push   %esi
80109108:	53                   	push   %ebx
  pushcli();
80109109:	e8 ba d1 ff ff       	call   801062c8 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
8010910e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109114:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010911b:	83 c2 08             	add    $0x8,%edx
8010911e:	89 d6                	mov    %edx,%esi
80109120:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80109127:	83 c2 08             	add    $0x8,%edx
8010912a:	c1 ea 10             	shr    $0x10,%edx
8010912d:	89 d3                	mov    %edx,%ebx
8010912f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80109136:	83 c2 08             	add    $0x8,%edx
80109139:	c1 ea 18             	shr    $0x18,%edx
8010913c:	89 d1                	mov    %edx,%ecx
8010913e:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80109145:	67 00 
80109147:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
8010914e:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
80109154:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010915b:	83 e2 f0             	and    $0xfffffff0,%edx
8010915e:	83 ca 09             	or     $0x9,%edx
80109161:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80109167:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010916e:	83 ca 10             	or     $0x10,%edx
80109171:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80109177:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010917e:	83 e2 9f             	and    $0xffffff9f,%edx
80109181:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80109187:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010918e:	83 ca 80             	or     $0xffffff80,%edx
80109191:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80109197:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010919e:	83 e2 f0             	and    $0xfffffff0,%edx
801091a1:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801091a7:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801091ae:	83 e2 ef             	and    $0xffffffef,%edx
801091b1:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801091b7:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801091be:	83 e2 df             	and    $0xffffffdf,%edx
801091c1:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801091c7:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801091ce:	83 ca 40             	or     $0x40,%edx
801091d1:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801091d7:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801091de:	83 e2 7f             	and    $0x7f,%edx
801091e1:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801091e7:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
801091ed:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801091f3:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801091fa:	83 e2 ef             	and    $0xffffffef,%edx
801091fd:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80109203:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109209:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
8010920f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109215:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010921c:	8b 52 08             	mov    0x8(%edx),%edx
8010921f:	81 c2 00 10 00 00    	add    $0x1000,%edx
80109225:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80109228:	83 ec 0c             	sub    $0xc,%esp
8010922b:	6a 30                	push   $0x30
8010922d:	e8 f3 f7 ff ff       	call   80108a25 <ltr>
80109232:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
80109235:	8b 45 08             	mov    0x8(%ebp),%eax
80109238:	8b 40 04             	mov    0x4(%eax),%eax
8010923b:	85 c0                	test   %eax,%eax
8010923d:	75 0d                	jne    8010924c <switchuvm+0x148>
    panic("switchuvm: no pgdir");
8010923f:	83 ec 0c             	sub    $0xc,%esp
80109242:	68 7f a0 10 80       	push   $0x8010a07f
80109247:	e8 1a 73 ff ff       	call   80100566 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
8010924c:	8b 45 08             	mov    0x8(%ebp),%eax
8010924f:	8b 40 04             	mov    0x4(%eax),%eax
80109252:	83 ec 0c             	sub    $0xc,%esp
80109255:	50                   	push   %eax
80109256:	e8 03 f8 ff ff       	call   80108a5e <v2p>
8010925b:	83 c4 10             	add    $0x10,%esp
8010925e:	83 ec 0c             	sub    $0xc,%esp
80109261:	50                   	push   %eax
80109262:	e8 eb f7 ff ff       	call   80108a52 <lcr3>
80109267:	83 c4 10             	add    $0x10,%esp
  popcli();
8010926a:	e8 9e d0 ff ff       	call   8010630d <popcli>
}
8010926f:	90                   	nop
80109270:	8d 65 f8             	lea    -0x8(%ebp),%esp
80109273:	5b                   	pop    %ebx
80109274:	5e                   	pop    %esi
80109275:	5d                   	pop    %ebp
80109276:	c3                   	ret    

80109277 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80109277:	55                   	push   %ebp
80109278:	89 e5                	mov    %esp,%ebp
8010927a:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
8010927d:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80109284:	76 0d                	jbe    80109293 <inituvm+0x1c>
    panic("inituvm: more than a page");
80109286:	83 ec 0c             	sub    $0xc,%esp
80109289:	68 93 a0 10 80       	push   $0x8010a093
8010928e:	e8 d3 72 ff ff       	call   80100566 <panic>
  mem = kalloc();
80109293:	e8 6c 9a ff ff       	call   80102d04 <kalloc>
80109298:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
8010929b:	83 ec 04             	sub    $0x4,%esp
8010929e:	68 00 10 00 00       	push   $0x1000
801092a3:	6a 00                	push   $0x0
801092a5:	ff 75 f4             	pushl  -0xc(%ebp)
801092a8:	e8 21 d1 ff ff       	call   801063ce <memset>
801092ad:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
801092b0:	83 ec 0c             	sub    $0xc,%esp
801092b3:	ff 75 f4             	pushl  -0xc(%ebp)
801092b6:	e8 a3 f7 ff ff       	call   80108a5e <v2p>
801092bb:	83 c4 10             	add    $0x10,%esp
801092be:	83 ec 0c             	sub    $0xc,%esp
801092c1:	6a 06                	push   $0x6
801092c3:	50                   	push   %eax
801092c4:	68 00 10 00 00       	push   $0x1000
801092c9:	6a 00                	push   $0x0
801092cb:	ff 75 08             	pushl  0x8(%ebp)
801092ce:	e8 ba fc ff ff       	call   80108f8d <mappages>
801092d3:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
801092d6:	83 ec 04             	sub    $0x4,%esp
801092d9:	ff 75 10             	pushl  0x10(%ebp)
801092dc:	ff 75 0c             	pushl  0xc(%ebp)
801092df:	ff 75 f4             	pushl  -0xc(%ebp)
801092e2:	e8 a6 d1 ff ff       	call   8010648d <memmove>
801092e7:	83 c4 10             	add    $0x10,%esp
}
801092ea:	90                   	nop
801092eb:	c9                   	leave  
801092ec:	c3                   	ret    

801092ed <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801092ed:	55                   	push   %ebp
801092ee:	89 e5                	mov    %esp,%ebp
801092f0:	53                   	push   %ebx
801092f1:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801092f4:	8b 45 0c             	mov    0xc(%ebp),%eax
801092f7:	25 ff 0f 00 00       	and    $0xfff,%eax
801092fc:	85 c0                	test   %eax,%eax
801092fe:	74 0d                	je     8010930d <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
80109300:	83 ec 0c             	sub    $0xc,%esp
80109303:	68 b0 a0 10 80       	push   $0x8010a0b0
80109308:	e8 59 72 ff ff       	call   80100566 <panic>
  for(i = 0; i < sz; i += PGSIZE){
8010930d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109314:	e9 95 00 00 00       	jmp    801093ae <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80109319:	8b 55 0c             	mov    0xc(%ebp),%edx
8010931c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010931f:	01 d0                	add    %edx,%eax
80109321:	83 ec 04             	sub    $0x4,%esp
80109324:	6a 00                	push   $0x0
80109326:	50                   	push   %eax
80109327:	ff 75 08             	pushl  0x8(%ebp)
8010932a:	e8 be fb ff ff       	call   80108eed <walkpgdir>
8010932f:	83 c4 10             	add    $0x10,%esp
80109332:	89 45 ec             	mov    %eax,-0x14(%ebp)
80109335:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109339:	75 0d                	jne    80109348 <loaduvm+0x5b>
      panic("loaduvm: address should exist");
8010933b:	83 ec 0c             	sub    $0xc,%esp
8010933e:	68 d3 a0 10 80       	push   $0x8010a0d3
80109343:	e8 1e 72 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80109348:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010934b:	8b 00                	mov    (%eax),%eax
8010934d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109352:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80109355:	8b 45 18             	mov    0x18(%ebp),%eax
80109358:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010935b:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80109360:	77 0b                	ja     8010936d <loaduvm+0x80>
      n = sz - i;
80109362:	8b 45 18             	mov    0x18(%ebp),%eax
80109365:	2b 45 f4             	sub    -0xc(%ebp),%eax
80109368:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010936b:	eb 07                	jmp    80109374 <loaduvm+0x87>
    else
      n = PGSIZE;
8010936d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80109374:	8b 55 14             	mov    0x14(%ebp),%edx
80109377:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010937a:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010937d:	83 ec 0c             	sub    $0xc,%esp
80109380:	ff 75 e8             	pushl  -0x18(%ebp)
80109383:	e8 e3 f6 ff ff       	call   80108a6b <p2v>
80109388:	83 c4 10             	add    $0x10,%esp
8010938b:	ff 75 f0             	pushl  -0x10(%ebp)
8010938e:	53                   	push   %ebx
8010938f:	50                   	push   %eax
80109390:	ff 75 10             	pushl  0x10(%ebp)
80109393:	e8 de 8b ff ff       	call   80101f76 <readi>
80109398:	83 c4 10             	add    $0x10,%esp
8010939b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010939e:	74 07                	je     801093a7 <loaduvm+0xba>
      return -1;
801093a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801093a5:	eb 18                	jmp    801093bf <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801093a7:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801093ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093b1:	3b 45 18             	cmp    0x18(%ebp),%eax
801093b4:	0f 82 5f ff ff ff    	jb     80109319 <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
801093ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
801093bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801093c2:	c9                   	leave  
801093c3:	c3                   	ret    

801093c4 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801093c4:	55                   	push   %ebp
801093c5:	89 e5                	mov    %esp,%ebp
801093c7:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
801093ca:	8b 45 10             	mov    0x10(%ebp),%eax
801093cd:	85 c0                	test   %eax,%eax
801093cf:	79 0a                	jns    801093db <allocuvm+0x17>
    return 0;
801093d1:	b8 00 00 00 00       	mov    $0x0,%eax
801093d6:	e9 b0 00 00 00       	jmp    8010948b <allocuvm+0xc7>
  if(newsz < oldsz)
801093db:	8b 45 10             	mov    0x10(%ebp),%eax
801093de:	3b 45 0c             	cmp    0xc(%ebp),%eax
801093e1:	73 08                	jae    801093eb <allocuvm+0x27>
    return oldsz;
801093e3:	8b 45 0c             	mov    0xc(%ebp),%eax
801093e6:	e9 a0 00 00 00       	jmp    8010948b <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
801093eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801093ee:	05 ff 0f 00 00       	add    $0xfff,%eax
801093f3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801093f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
801093fb:	eb 7f                	jmp    8010947c <allocuvm+0xb8>
    mem = kalloc();
801093fd:	e8 02 99 ff ff       	call   80102d04 <kalloc>
80109402:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80109405:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109409:	75 2b                	jne    80109436 <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
8010940b:	83 ec 0c             	sub    $0xc,%esp
8010940e:	68 f1 a0 10 80       	push   $0x8010a0f1
80109413:	e8 ae 6f ff ff       	call   801003c6 <cprintf>
80109418:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
8010941b:	83 ec 04             	sub    $0x4,%esp
8010941e:	ff 75 0c             	pushl  0xc(%ebp)
80109421:	ff 75 10             	pushl  0x10(%ebp)
80109424:	ff 75 08             	pushl  0x8(%ebp)
80109427:	e8 61 00 00 00       	call   8010948d <deallocuvm>
8010942c:	83 c4 10             	add    $0x10,%esp
      return 0;
8010942f:	b8 00 00 00 00       	mov    $0x0,%eax
80109434:	eb 55                	jmp    8010948b <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
80109436:	83 ec 04             	sub    $0x4,%esp
80109439:	68 00 10 00 00       	push   $0x1000
8010943e:	6a 00                	push   $0x0
80109440:	ff 75 f0             	pushl  -0x10(%ebp)
80109443:	e8 86 cf ff ff       	call   801063ce <memset>
80109448:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
8010944b:	83 ec 0c             	sub    $0xc,%esp
8010944e:	ff 75 f0             	pushl  -0x10(%ebp)
80109451:	e8 08 f6 ff ff       	call   80108a5e <v2p>
80109456:	83 c4 10             	add    $0x10,%esp
80109459:	89 c2                	mov    %eax,%edx
8010945b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010945e:	83 ec 0c             	sub    $0xc,%esp
80109461:	6a 06                	push   $0x6
80109463:	52                   	push   %edx
80109464:	68 00 10 00 00       	push   $0x1000
80109469:	50                   	push   %eax
8010946a:	ff 75 08             	pushl  0x8(%ebp)
8010946d:	e8 1b fb ff ff       	call   80108f8d <mappages>
80109472:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80109475:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010947c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010947f:	3b 45 10             	cmp    0x10(%ebp),%eax
80109482:	0f 82 75 ff ff ff    	jb     801093fd <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80109488:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010948b:	c9                   	leave  
8010948c:	c3                   	ret    

8010948d <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010948d:	55                   	push   %ebp
8010948e:	89 e5                	mov    %esp,%ebp
80109490:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80109493:	8b 45 10             	mov    0x10(%ebp),%eax
80109496:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109499:	72 08                	jb     801094a3 <deallocuvm+0x16>
    return oldsz;
8010949b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010949e:	e9 a5 00 00 00       	jmp    80109548 <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
801094a3:	8b 45 10             	mov    0x10(%ebp),%eax
801094a6:	05 ff 0f 00 00       	add    $0xfff,%eax
801094ab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801094b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801094b3:	e9 81 00 00 00       	jmp    80109539 <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
801094b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094bb:	83 ec 04             	sub    $0x4,%esp
801094be:	6a 00                	push   $0x0
801094c0:	50                   	push   %eax
801094c1:	ff 75 08             	pushl  0x8(%ebp)
801094c4:	e8 24 fa ff ff       	call   80108eed <walkpgdir>
801094c9:	83 c4 10             	add    $0x10,%esp
801094cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
801094cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801094d3:	75 09                	jne    801094de <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
801094d5:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
801094dc:	eb 54                	jmp    80109532 <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
801094de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801094e1:	8b 00                	mov    (%eax),%eax
801094e3:	83 e0 01             	and    $0x1,%eax
801094e6:	85 c0                	test   %eax,%eax
801094e8:	74 48                	je     80109532 <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
801094ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801094ed:	8b 00                	mov    (%eax),%eax
801094ef:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801094f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
801094f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801094fb:	75 0d                	jne    8010950a <deallocuvm+0x7d>
        panic("kfree");
801094fd:	83 ec 0c             	sub    $0xc,%esp
80109500:	68 09 a1 10 80       	push   $0x8010a109
80109505:	e8 5c 70 ff ff       	call   80100566 <panic>
      char *v = p2v(pa);
8010950a:	83 ec 0c             	sub    $0xc,%esp
8010950d:	ff 75 ec             	pushl  -0x14(%ebp)
80109510:	e8 56 f5 ff ff       	call   80108a6b <p2v>
80109515:	83 c4 10             	add    $0x10,%esp
80109518:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
8010951b:	83 ec 0c             	sub    $0xc,%esp
8010951e:	ff 75 e8             	pushl  -0x18(%ebp)
80109521:	e8 41 97 ff ff       	call   80102c67 <kfree>
80109526:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80109529:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010952c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80109532:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109539:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010953c:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010953f:	0f 82 73 ff ff ff    	jb     801094b8 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80109545:	8b 45 10             	mov    0x10(%ebp),%eax
}
80109548:	c9                   	leave  
80109549:	c3                   	ret    

8010954a <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
8010954a:	55                   	push   %ebp
8010954b:	89 e5                	mov    %esp,%ebp
8010954d:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80109550:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80109554:	75 0d                	jne    80109563 <freevm+0x19>
    panic("freevm: no pgdir");
80109556:	83 ec 0c             	sub    $0xc,%esp
80109559:	68 0f a1 10 80       	push   $0x8010a10f
8010955e:	e8 03 70 ff ff       	call   80100566 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80109563:	83 ec 04             	sub    $0x4,%esp
80109566:	6a 00                	push   $0x0
80109568:	68 00 00 00 80       	push   $0x80000000
8010956d:	ff 75 08             	pushl  0x8(%ebp)
80109570:	e8 18 ff ff ff       	call   8010948d <deallocuvm>
80109575:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80109578:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010957f:	eb 4f                	jmp    801095d0 <freevm+0x86>
    if(pgdir[i] & PTE_P){
80109581:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109584:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010958b:	8b 45 08             	mov    0x8(%ebp),%eax
8010958e:	01 d0                	add    %edx,%eax
80109590:	8b 00                	mov    (%eax),%eax
80109592:	83 e0 01             	and    $0x1,%eax
80109595:	85 c0                	test   %eax,%eax
80109597:	74 33                	je     801095cc <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80109599:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010959c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801095a3:	8b 45 08             	mov    0x8(%ebp),%eax
801095a6:	01 d0                	add    %edx,%eax
801095a8:	8b 00                	mov    (%eax),%eax
801095aa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801095af:	83 ec 0c             	sub    $0xc,%esp
801095b2:	50                   	push   %eax
801095b3:	e8 b3 f4 ff ff       	call   80108a6b <p2v>
801095b8:	83 c4 10             	add    $0x10,%esp
801095bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
801095be:	83 ec 0c             	sub    $0xc,%esp
801095c1:	ff 75 f0             	pushl  -0x10(%ebp)
801095c4:	e8 9e 96 ff ff       	call   80102c67 <kfree>
801095c9:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801095cc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801095d0:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
801095d7:	76 a8                	jbe    80109581 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801095d9:	83 ec 0c             	sub    $0xc,%esp
801095dc:	ff 75 08             	pushl  0x8(%ebp)
801095df:	e8 83 96 ff ff       	call   80102c67 <kfree>
801095e4:	83 c4 10             	add    $0x10,%esp
}
801095e7:	90                   	nop
801095e8:	c9                   	leave  
801095e9:	c3                   	ret    

801095ea <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801095ea:	55                   	push   %ebp
801095eb:	89 e5                	mov    %esp,%ebp
801095ed:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801095f0:	83 ec 04             	sub    $0x4,%esp
801095f3:	6a 00                	push   $0x0
801095f5:	ff 75 0c             	pushl  0xc(%ebp)
801095f8:	ff 75 08             	pushl  0x8(%ebp)
801095fb:	e8 ed f8 ff ff       	call   80108eed <walkpgdir>
80109600:	83 c4 10             	add    $0x10,%esp
80109603:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80109606:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010960a:	75 0d                	jne    80109619 <clearpteu+0x2f>
    panic("clearpteu");
8010960c:	83 ec 0c             	sub    $0xc,%esp
8010960f:	68 20 a1 10 80       	push   $0x8010a120
80109614:	e8 4d 6f ff ff       	call   80100566 <panic>
  *pte &= ~PTE_U;
80109619:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010961c:	8b 00                	mov    (%eax),%eax
8010961e:	83 e0 fb             	and    $0xfffffffb,%eax
80109621:	89 c2                	mov    %eax,%edx
80109623:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109626:	89 10                	mov    %edx,(%eax)
}
80109628:	90                   	nop
80109629:	c9                   	leave  
8010962a:	c3                   	ret    

8010962b <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
8010962b:	55                   	push   %ebp
8010962c:	89 e5                	mov    %esp,%ebp
8010962e:	53                   	push   %ebx
8010962f:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80109632:	e8 e6 f9 ff ff       	call   8010901d <setupkvm>
80109637:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010963a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010963e:	75 0a                	jne    8010964a <copyuvm+0x1f>
    return 0;
80109640:	b8 00 00 00 00       	mov    $0x0,%eax
80109645:	e9 f8 00 00 00       	jmp    80109742 <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
8010964a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109651:	e9 c4 00 00 00       	jmp    8010971a <copyuvm+0xef>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80109656:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109659:	83 ec 04             	sub    $0x4,%esp
8010965c:	6a 00                	push   $0x0
8010965e:	50                   	push   %eax
8010965f:	ff 75 08             	pushl  0x8(%ebp)
80109662:	e8 86 f8 ff ff       	call   80108eed <walkpgdir>
80109667:	83 c4 10             	add    $0x10,%esp
8010966a:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010966d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109671:	75 0d                	jne    80109680 <copyuvm+0x55>
      panic("copyuvm: pte should exist");
80109673:	83 ec 0c             	sub    $0xc,%esp
80109676:	68 2a a1 10 80       	push   $0x8010a12a
8010967b:	e8 e6 6e ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
80109680:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109683:	8b 00                	mov    (%eax),%eax
80109685:	83 e0 01             	and    $0x1,%eax
80109688:	85 c0                	test   %eax,%eax
8010968a:	75 0d                	jne    80109699 <copyuvm+0x6e>
      panic("copyuvm: page not present");
8010968c:	83 ec 0c             	sub    $0xc,%esp
8010968f:	68 44 a1 10 80       	push   $0x8010a144
80109694:	e8 cd 6e ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80109699:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010969c:	8b 00                	mov    (%eax),%eax
8010969e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801096a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
801096a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801096a9:	8b 00                	mov    (%eax),%eax
801096ab:	25 ff 0f 00 00       	and    $0xfff,%eax
801096b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801096b3:	e8 4c 96 ff ff       	call   80102d04 <kalloc>
801096b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
801096bb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801096bf:	74 6a                	je     8010972b <copyuvm+0x100>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
801096c1:	83 ec 0c             	sub    $0xc,%esp
801096c4:	ff 75 e8             	pushl  -0x18(%ebp)
801096c7:	e8 9f f3 ff ff       	call   80108a6b <p2v>
801096cc:	83 c4 10             	add    $0x10,%esp
801096cf:	83 ec 04             	sub    $0x4,%esp
801096d2:	68 00 10 00 00       	push   $0x1000
801096d7:	50                   	push   %eax
801096d8:	ff 75 e0             	pushl  -0x20(%ebp)
801096db:	e8 ad cd ff ff       	call   8010648d <memmove>
801096e0:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
801096e3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801096e6:	83 ec 0c             	sub    $0xc,%esp
801096e9:	ff 75 e0             	pushl  -0x20(%ebp)
801096ec:	e8 6d f3 ff ff       	call   80108a5e <v2p>
801096f1:	83 c4 10             	add    $0x10,%esp
801096f4:	89 c2                	mov    %eax,%edx
801096f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096f9:	83 ec 0c             	sub    $0xc,%esp
801096fc:	53                   	push   %ebx
801096fd:	52                   	push   %edx
801096fe:	68 00 10 00 00       	push   $0x1000
80109703:	50                   	push   %eax
80109704:	ff 75 f0             	pushl  -0x10(%ebp)
80109707:	e8 81 f8 ff ff       	call   80108f8d <mappages>
8010970c:	83 c4 20             	add    $0x20,%esp
8010970f:	85 c0                	test   %eax,%eax
80109711:	78 1b                	js     8010972e <copyuvm+0x103>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80109713:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010971a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010971d:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109720:	0f 82 30 ff ff ff    	jb     80109656 <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80109726:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109729:	eb 17                	jmp    80109742 <copyuvm+0x117>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
8010972b:	90                   	nop
8010972c:	eb 01                	jmp    8010972f <copyuvm+0x104>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
8010972e:	90                   	nop
  }
  return d;

bad:
  freevm(d);
8010972f:	83 ec 0c             	sub    $0xc,%esp
80109732:	ff 75 f0             	pushl  -0x10(%ebp)
80109735:	e8 10 fe ff ff       	call   8010954a <freevm>
8010973a:	83 c4 10             	add    $0x10,%esp
  return 0;
8010973d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109742:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109745:	c9                   	leave  
80109746:	c3                   	ret    

80109747 <uva2ka>:

// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80109747:	55                   	push   %ebp
80109748:	89 e5                	mov    %esp,%ebp
8010974a:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010974d:	83 ec 04             	sub    $0x4,%esp
80109750:	6a 00                	push   $0x0
80109752:	ff 75 0c             	pushl  0xc(%ebp)
80109755:	ff 75 08             	pushl  0x8(%ebp)
80109758:	e8 90 f7 ff ff       	call   80108eed <walkpgdir>
8010975d:	83 c4 10             	add    $0x10,%esp
80109760:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80109763:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109766:	8b 00                	mov    (%eax),%eax
80109768:	83 e0 01             	and    $0x1,%eax
8010976b:	85 c0                	test   %eax,%eax
8010976d:	75 07                	jne    80109776 <uva2ka+0x2f>
    return 0;
8010976f:	b8 00 00 00 00       	mov    $0x0,%eax
80109774:	eb 29                	jmp    8010979f <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
80109776:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109779:	8b 00                	mov    (%eax),%eax
8010977b:	83 e0 04             	and    $0x4,%eax
8010977e:	85 c0                	test   %eax,%eax
80109780:	75 07                	jne    80109789 <uva2ka+0x42>
    return 0;
80109782:	b8 00 00 00 00       	mov    $0x0,%eax
80109787:	eb 16                	jmp    8010979f <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
80109789:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010978c:	8b 00                	mov    (%eax),%eax
8010978e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109793:	83 ec 0c             	sub    $0xc,%esp
80109796:	50                   	push   %eax
80109797:	e8 cf f2 ff ff       	call   80108a6b <p2v>
8010979c:	83 c4 10             	add    $0x10,%esp
}
8010979f:	c9                   	leave  
801097a0:	c3                   	ret    

801097a1 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801097a1:	55                   	push   %ebp
801097a2:	89 e5                	mov    %esp,%ebp
801097a4:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
801097a7:	8b 45 10             	mov    0x10(%ebp),%eax
801097aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
801097ad:	eb 7f                	jmp    8010982e <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
801097af:	8b 45 0c             	mov    0xc(%ebp),%eax
801097b2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801097b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
801097ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
801097bd:	83 ec 08             	sub    $0x8,%esp
801097c0:	50                   	push   %eax
801097c1:	ff 75 08             	pushl  0x8(%ebp)
801097c4:	e8 7e ff ff ff       	call   80109747 <uva2ka>
801097c9:	83 c4 10             	add    $0x10,%esp
801097cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
801097cf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801097d3:	75 07                	jne    801097dc <copyout+0x3b>
      return -1;
801097d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801097da:	eb 61                	jmp    8010983d <copyout+0x9c>
    n = PGSIZE - (va - va0);
801097dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801097df:	2b 45 0c             	sub    0xc(%ebp),%eax
801097e2:	05 00 10 00 00       	add    $0x1000,%eax
801097e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
801097ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801097ed:	3b 45 14             	cmp    0x14(%ebp),%eax
801097f0:	76 06                	jbe    801097f8 <copyout+0x57>
      n = len;
801097f2:	8b 45 14             	mov    0x14(%ebp),%eax
801097f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
801097f8:	8b 45 0c             	mov    0xc(%ebp),%eax
801097fb:	2b 45 ec             	sub    -0x14(%ebp),%eax
801097fe:	89 c2                	mov    %eax,%edx
80109800:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109803:	01 d0                	add    %edx,%eax
80109805:	83 ec 04             	sub    $0x4,%esp
80109808:	ff 75 f0             	pushl  -0x10(%ebp)
8010980b:	ff 75 f4             	pushl  -0xc(%ebp)
8010980e:	50                   	push   %eax
8010980f:	e8 79 cc ff ff       	call   8010648d <memmove>
80109814:	83 c4 10             	add    $0x10,%esp
    len -= n;
80109817:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010981a:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
8010981d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109820:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80109823:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109826:	05 00 10 00 00       	add    $0x1000,%eax
8010982b:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
8010982e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80109832:	0f 85 77 ff ff ff    	jne    801097af <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80109838:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010983d:	c9                   	leave  
8010983e:	c3                   	ret    
