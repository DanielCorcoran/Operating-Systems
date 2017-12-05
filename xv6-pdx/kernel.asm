
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
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
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
80100028:	bc 90 d6 10 80       	mov    $0x8010d690,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 6d 3b 10 80       	mov    $0x80103b6d,%eax
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
8010003d:	68 08 8f 10 80       	push   $0x80108f08
80100042:	68 a0 d6 10 80       	push   $0x8010d6a0
80100047:	e8 08 57 00 00       	call   80105754 <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 b0 15 11 80 a4 	movl   $0x801115a4,0x801115b0
80100056:	15 11 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 b4 15 11 80 a4 	movl   $0x801115a4,0x801115b4
80100060:	15 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 d4 d6 10 80 	movl   $0x8010d6d4,-0xc(%ebp)
8010006a:	eb 3a                	jmp    801000a6 <binit+0x72>
    b->next = bcache.head.next;
8010006c:	8b 15 b4 15 11 80    	mov    0x801115b4,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 0c a4 15 11 80 	movl   $0x801115a4,0xc(%eax)
    b->dev = -1;
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008c:	a1 b4 15 11 80       	mov    0x801115b4,%eax
80100091:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100094:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010009a:	a3 b4 15 11 80       	mov    %eax,0x801115b4
  initlock(&bcache.lock, "bcache");

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009f:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a6:	b8 a4 15 11 80       	mov    $0x801115a4,%eax
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
801000bc:	68 a0 d6 10 80       	push   $0x8010d6a0
801000c1:	e8 b0 56 00 00       	call   80105776 <acquire>
801000c6:	83 c4 10             	add    $0x10,%esp

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c9:	a1 b4 15 11 80       	mov    0x801115b4,%eax
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
80100107:	68 a0 d6 10 80       	push   $0x8010d6a0
8010010c:	e8 cc 56 00 00       	call   801057dd <release>
80100111:	83 c4 10             	add    $0x10,%esp
        return b;
80100114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100117:	e9 98 00 00 00       	jmp    801001b4 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011c:	83 ec 08             	sub    $0x8,%esp
8010011f:	68 a0 d6 10 80       	push   $0x8010d6a0
80100124:	ff 75 f4             	pushl  -0xc(%ebp)
80100127:	e8 a5 4f 00 00       	call   801050d1 <sleep>
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
8010013a:	81 7d f4 a4 15 11 80 	cmpl   $0x801115a4,-0xc(%ebp)
80100141:	75 90                	jne    801000d3 <bget+0x20>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100143:	a1 b0 15 11 80       	mov    0x801115b0,%eax
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
80100183:	68 a0 d6 10 80       	push   $0x8010d6a0
80100188:	e8 50 56 00 00       	call   801057dd <release>
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
8010019e:	81 7d f4 a4 15 11 80 	cmpl   $0x801115a4,-0xc(%ebp)
801001a5:	75 a6                	jne    8010014d <bget+0x9a>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001a7:	83 ec 0c             	sub    $0xc,%esp
801001aa:	68 0f 8f 10 80       	push   $0x80108f0f
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
801001e2:	e8 04 2a 00 00       	call   80102beb <iderw>
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
80100204:	68 20 8f 10 80       	push   $0x80108f20
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
80100223:	e8 c3 29 00 00       	call   80102beb <iderw>
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
80100243:	68 27 8f 10 80       	push   $0x80108f27
80100248:	e8 19 03 00 00       	call   80100566 <panic>

  acquire(&bcache.lock);
8010024d:	83 ec 0c             	sub    $0xc,%esp
80100250:	68 a0 d6 10 80       	push   $0x8010d6a0
80100255:	e8 1c 55 00 00       	call   80105776 <acquire>
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
8010027b:	8b 15 b4 15 11 80    	mov    0x801115b4,%edx
80100281:	8b 45 08             	mov    0x8(%ebp),%eax
80100284:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
80100287:	8b 45 08             	mov    0x8(%ebp),%eax
8010028a:	c7 40 0c a4 15 11 80 	movl   $0x801115a4,0xc(%eax)
  bcache.head.next->prev = b;
80100291:	a1 b4 15 11 80       	mov    0x801115b4,%eax
80100296:	8b 55 08             	mov    0x8(%ebp),%edx
80100299:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
8010029c:	8b 45 08             	mov    0x8(%ebp),%eax
8010029f:	a3 b4 15 11 80       	mov    %eax,0x801115b4

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
801002b9:	e8 fa 4e 00 00       	call   801051b8 <wakeup>
801002be:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002c1:	83 ec 0c             	sub    $0xc,%esp
801002c4:	68 a0 d6 10 80       	push   $0x8010d6a0
801002c9:	e8 0f 55 00 00       	call   801057dd <release>
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
80100365:	0f b6 80 04 a0 10 80 	movzbl -0x7fef5ffc(%eax),%eax
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
801003cc:	a1 34 c6 10 80       	mov    0x8010c634,%eax
801003d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003d8:	74 10                	je     801003ea <cprintf+0x24>
    acquire(&cons.lock);
801003da:	83 ec 0c             	sub    $0xc,%esp
801003dd:	68 00 c6 10 80       	push   $0x8010c600
801003e2:	e8 8f 53 00 00       	call   80105776 <acquire>
801003e7:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003ea:	8b 45 08             	mov    0x8(%ebp),%eax
801003ed:	85 c0                	test   %eax,%eax
801003ef:	75 0d                	jne    801003fe <cprintf+0x38>
    panic("null fmt");
801003f1:	83 ec 0c             	sub    $0xc,%esp
801003f4:	68 2e 8f 10 80       	push   $0x80108f2e
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
801004cd:	c7 45 ec 37 8f 10 80 	movl   $0x80108f37,-0x14(%ebp)
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
80100556:	68 00 c6 10 80       	push   $0x8010c600
8010055b:	e8 7d 52 00 00       	call   801057dd <release>
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
80100571:	c7 05 34 c6 10 80 00 	movl   $0x0,0x8010c634
80100578:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010057b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100581:	0f b6 00             	movzbl (%eax),%eax
80100584:	0f b6 c0             	movzbl %al,%eax
80100587:	83 ec 08             	sub    $0x8,%esp
8010058a:	50                   	push   %eax
8010058b:	68 3e 8f 10 80       	push   $0x80108f3e
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
801005aa:	68 4d 8f 10 80       	push   $0x80108f4d
801005af:	e8 12 fe ff ff       	call   801003c6 <cprintf>
801005b4:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005b7:	83 ec 08             	sub    $0x8,%esp
801005ba:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005bd:	50                   	push   %eax
801005be:	8d 45 08             	lea    0x8(%ebp),%eax
801005c1:	50                   	push   %eax
801005c2:	e8 68 52 00 00       	call   8010582f <getcallerpcs>
801005c7:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005d1:	eb 1c                	jmp    801005ef <panic+0x89>
    cprintf(" %p", pcs[i]);
801005d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d6:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005da:	83 ec 08             	sub    $0x8,%esp
801005dd:	50                   	push   %eax
801005de:	68 4f 8f 10 80       	push   $0x80108f4f
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
801005f5:	c7 05 e0 c5 10 80 01 	movl   $0x1,0x8010c5e0
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
80100699:	8b 0d 00 a0 10 80    	mov    0x8010a000,%ecx
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
801006ca:	68 53 8f 10 80       	push   $0x80108f53
801006cf:	e8 92 fe ff ff       	call   80100566 <panic>
  
  if((pos/80) >= 24){  // Scroll up.
801006d4:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006db:	7e 4c                	jle    80100729 <cgaputc+0x128>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006dd:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006e2:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006e8:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006ed:	83 ec 04             	sub    $0x4,%esp
801006f0:	68 60 0e 00 00       	push   $0xe60
801006f5:	52                   	push   %edx
801006f6:	50                   	push   %eax
801006f7:	e8 9c 53 00 00       	call   80105a98 <memmove>
801006fc:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
801006ff:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100703:	b8 80 07 00 00       	mov    $0x780,%eax
80100708:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010070b:	8d 14 00             	lea    (%eax,%eax,1),%edx
8010070e:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100713:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100716:	01 c9                	add    %ecx,%ecx
80100718:	01 c8                	add    %ecx,%eax
8010071a:	83 ec 04             	sub    $0x4,%esp
8010071d:	52                   	push   %edx
8010071e:	6a 00                	push   $0x0
80100720:	50                   	push   %eax
80100721:	e8 b3 52 00 00       	call   801059d9 <memset>
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
8010077e:	a1 00 a0 10 80       	mov    0x8010a000,%eax
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
80100798:	a1 e0 c5 10 80       	mov    0x8010c5e0,%eax
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
801007b6:	e8 d4 6d 00 00       	call   8010758f <uartputc>
801007bb:	83 c4 10             	add    $0x10,%esp
801007be:	83 ec 0c             	sub    $0xc,%esp
801007c1:	6a 20                	push   $0x20
801007c3:	e8 c7 6d 00 00       	call   8010758f <uartputc>
801007c8:	83 c4 10             	add    $0x10,%esp
801007cb:	83 ec 0c             	sub    $0xc,%esp
801007ce:	6a 08                	push   $0x8
801007d0:	e8 ba 6d 00 00       	call   8010758f <uartputc>
801007d5:	83 c4 10             	add    $0x10,%esp
801007d8:	eb 0e                	jmp    801007e8 <consputc+0x56>
  } else
    uartputc(c);
801007da:	83 ec 0c             	sub    $0xc,%esp
801007dd:	ff 75 08             	pushl  0x8(%ebp)
801007e0:	e8 aa 6d 00 00       	call   8010758f <uartputc>
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
801007fc:	83 ec 18             	sub    $0x18,%esp
  int c, doprocdump = 0;
801007ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  #ifdef CS333_P3P4
  int doctrlr = 0, doctrlf = 0, doctrls = 0, doctrlz = 0;
  #endif

  acquire(&cons.lock);
80100806:	83 ec 0c             	sub    $0xc,%esp
80100809:	68 00 c6 10 80       	push   $0x8010c600
8010080e:	e8 63 4f 00 00       	call   80105776 <acquire>
80100813:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
80100816:	e9 44 01 00 00       	jmp    8010095f <consoleintr+0x166>
    switch(c){
8010081b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010081e:	83 f8 10             	cmp    $0x10,%eax
80100821:	74 1e                	je     80100841 <consoleintr+0x48>
80100823:	83 f8 10             	cmp    $0x10,%eax
80100826:	7f 0a                	jg     80100832 <consoleintr+0x39>
80100828:	83 f8 08             	cmp    $0x8,%eax
8010082b:	74 6b                	je     80100898 <consoleintr+0x9f>
8010082d:	e9 9b 00 00 00       	jmp    801008cd <consoleintr+0xd4>
80100832:	83 f8 15             	cmp    $0x15,%eax
80100835:	74 33                	je     8010086a <consoleintr+0x71>
80100837:	83 f8 7f             	cmp    $0x7f,%eax
8010083a:	74 5c                	je     80100898 <consoleintr+0x9f>
8010083c:	e9 8c 00 00 00       	jmp    801008cd <consoleintr+0xd4>
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
80100841:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
80100848:	e9 12 01 00 00       	jmp    8010095f <consoleintr+0x166>
      break;
    #endif
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
8010084d:	a1 48 18 11 80       	mov    0x80111848,%eax
80100852:	83 e8 01             	sub    $0x1,%eax
80100855:	a3 48 18 11 80       	mov    %eax,0x80111848
        consputc(BACKSPACE);
8010085a:	83 ec 0c             	sub    $0xc,%esp
8010085d:	68 00 01 00 00       	push   $0x100
80100862:	e8 2b ff ff ff       	call   80100792 <consputc>
80100867:	83 c4 10             	add    $0x10,%esp
    case C('Z'):
      doctrlz = 1;
      break;
    #endif
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010086a:	8b 15 48 18 11 80    	mov    0x80111848,%edx
80100870:	a1 44 18 11 80       	mov    0x80111844,%eax
80100875:	39 c2                	cmp    %eax,%edx
80100877:	0f 84 e2 00 00 00    	je     8010095f <consoleintr+0x166>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010087d:	a1 48 18 11 80       	mov    0x80111848,%eax
80100882:	83 e8 01             	sub    $0x1,%eax
80100885:	83 e0 7f             	and    $0x7f,%eax
80100888:	0f b6 80 c0 17 11 80 	movzbl -0x7feee840(%eax),%eax
    case C('Z'):
      doctrlz = 1;
      break;
    #endif
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010088f:	3c 0a                	cmp    $0xa,%al
80100891:	75 ba                	jne    8010084d <consoleintr+0x54>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100893:	e9 c7 00 00 00       	jmp    8010095f <consoleintr+0x166>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100898:	8b 15 48 18 11 80    	mov    0x80111848,%edx
8010089e:	a1 44 18 11 80       	mov    0x80111844,%eax
801008a3:	39 c2                	cmp    %eax,%edx
801008a5:	0f 84 b4 00 00 00    	je     8010095f <consoleintr+0x166>
        input.e--;
801008ab:	a1 48 18 11 80       	mov    0x80111848,%eax
801008b0:	83 e8 01             	sub    $0x1,%eax
801008b3:	a3 48 18 11 80       	mov    %eax,0x80111848
        consputc(BACKSPACE);
801008b8:	83 ec 0c             	sub    $0xc,%esp
801008bb:	68 00 01 00 00       	push   $0x100
801008c0:	e8 cd fe ff ff       	call   80100792 <consputc>
801008c5:	83 c4 10             	add    $0x10,%esp
      }
      break;
801008c8:	e9 92 00 00 00       	jmp    8010095f <consoleintr+0x166>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801008d1:	0f 84 87 00 00 00    	je     8010095e <consoleintr+0x165>
801008d7:	8b 15 48 18 11 80    	mov    0x80111848,%edx
801008dd:	a1 40 18 11 80       	mov    0x80111840,%eax
801008e2:	29 c2                	sub    %eax,%edx
801008e4:	89 d0                	mov    %edx,%eax
801008e6:	83 f8 7f             	cmp    $0x7f,%eax
801008e9:	77 73                	ja     8010095e <consoleintr+0x165>
        c = (c == '\r') ? '\n' : c;
801008eb:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801008ef:	74 05                	je     801008f6 <consoleintr+0xfd>
801008f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801008f4:	eb 05                	jmp    801008fb <consoleintr+0x102>
801008f6:	b8 0a 00 00 00       	mov    $0xa,%eax
801008fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
801008fe:	a1 48 18 11 80       	mov    0x80111848,%eax
80100903:	8d 50 01             	lea    0x1(%eax),%edx
80100906:	89 15 48 18 11 80    	mov    %edx,0x80111848
8010090c:	83 e0 7f             	and    $0x7f,%eax
8010090f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100912:	88 90 c0 17 11 80    	mov    %dl,-0x7feee840(%eax)
        consputc(c);
80100918:	83 ec 0c             	sub    $0xc,%esp
8010091b:	ff 75 f0             	pushl  -0x10(%ebp)
8010091e:	e8 6f fe ff ff       	call   80100792 <consputc>
80100923:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100926:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
8010092a:	74 18                	je     80100944 <consoleintr+0x14b>
8010092c:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100930:	74 12                	je     80100944 <consoleintr+0x14b>
80100932:	a1 48 18 11 80       	mov    0x80111848,%eax
80100937:	8b 15 40 18 11 80    	mov    0x80111840,%edx
8010093d:	83 ea 80             	sub    $0xffffff80,%edx
80100940:	39 d0                	cmp    %edx,%eax
80100942:	75 1a                	jne    8010095e <consoleintr+0x165>
          input.w = input.e;
80100944:	a1 48 18 11 80       	mov    0x80111848,%eax
80100949:	a3 44 18 11 80       	mov    %eax,0x80111844
          wakeup(&input.r);
8010094e:	83 ec 0c             	sub    $0xc,%esp
80100951:	68 40 18 11 80       	push   $0x80111840
80100956:	e8 5d 48 00 00       	call   801051b8 <wakeup>
8010095b:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
8010095e:	90                   	nop
  #ifdef CS333_P3P4
  int doctrlr = 0, doctrlf = 0, doctrls = 0, doctrlz = 0;
  #endif

  acquire(&cons.lock);
  while((c = getc()) >= 0){
8010095f:	8b 45 08             	mov    0x8(%ebp),%eax
80100962:	ff d0                	call   *%eax
80100964:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100967:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010096b:	0f 89 aa fe ff ff    	jns    8010081b <consoleintr+0x22>
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100971:	83 ec 0c             	sub    $0xc,%esp
80100974:	68 00 c6 10 80       	push   $0x8010c600
80100979:	e8 5f 4e 00 00       	call   801057dd <release>
8010097e:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
80100981:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100985:	74 05                	je     8010098c <consoleintr+0x193>
    procdump();  // now call procdump() wo. cons.lock held
80100987:	e8 ec 48 00 00       	call   80105278 <procdump>
  }
  if(doctrlz) {
    printZombieList();
  }
  #endif
}
8010098c:	90                   	nop
8010098d:	c9                   	leave  
8010098e:	c3                   	ret    

8010098f <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
8010098f:	55                   	push   %ebp
80100990:	89 e5                	mov    %esp,%ebp
80100992:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
80100995:	83 ec 0c             	sub    $0xc,%esp
80100998:	ff 75 08             	pushl  0x8(%ebp)
8010099b:	e8 3c 12 00 00       	call   80101bdc <iunlock>
801009a0:	83 c4 10             	add    $0x10,%esp
  target = n;
801009a3:	8b 45 10             	mov    0x10(%ebp),%eax
801009a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
801009a9:	83 ec 0c             	sub    $0xc,%esp
801009ac:	68 00 c6 10 80       	push   $0x8010c600
801009b1:	e8 c0 4d 00 00       	call   80105776 <acquire>
801009b6:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
801009b9:	e9 ac 00 00 00       	jmp    80100a6a <consoleread+0xdb>
    while(input.r == input.w){
      if(proc->killed){
801009be:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801009c4:	8b 40 24             	mov    0x24(%eax),%eax
801009c7:	85 c0                	test   %eax,%eax
801009c9:	74 28                	je     801009f3 <consoleread+0x64>
        release(&cons.lock);
801009cb:	83 ec 0c             	sub    $0xc,%esp
801009ce:	68 00 c6 10 80       	push   $0x8010c600
801009d3:	e8 05 4e 00 00       	call   801057dd <release>
801009d8:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
801009db:	83 ec 0c             	sub    $0xc,%esp
801009de:	ff 75 08             	pushl  0x8(%ebp)
801009e1:	e8 70 10 00 00       	call   80101a56 <ilock>
801009e6:	83 c4 10             	add    $0x10,%esp
        return -1;
801009e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801009ee:	e9 ab 00 00 00       	jmp    80100a9e <consoleread+0x10f>
      }
      sleep(&input.r, &cons.lock);
801009f3:	83 ec 08             	sub    $0x8,%esp
801009f6:	68 00 c6 10 80       	push   $0x8010c600
801009fb:	68 40 18 11 80       	push   $0x80111840
80100a00:	e8 cc 46 00 00       	call   801050d1 <sleep>
80100a05:	83 c4 10             	add    $0x10,%esp

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
80100a08:	8b 15 40 18 11 80    	mov    0x80111840,%edx
80100a0e:	a1 44 18 11 80       	mov    0x80111844,%eax
80100a13:	39 c2                	cmp    %eax,%edx
80100a15:	74 a7                	je     801009be <consoleread+0x2f>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100a17:	a1 40 18 11 80       	mov    0x80111840,%eax
80100a1c:	8d 50 01             	lea    0x1(%eax),%edx
80100a1f:	89 15 40 18 11 80    	mov    %edx,0x80111840
80100a25:	83 e0 7f             	and    $0x7f,%eax
80100a28:	0f b6 80 c0 17 11 80 	movzbl -0x7feee840(%eax),%eax
80100a2f:	0f be c0             	movsbl %al,%eax
80100a32:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100a35:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a39:	75 17                	jne    80100a52 <consoleread+0xc3>
      if(n < target){
80100a3b:	8b 45 10             	mov    0x10(%ebp),%eax
80100a3e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100a41:	73 2f                	jae    80100a72 <consoleread+0xe3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100a43:	a1 40 18 11 80       	mov    0x80111840,%eax
80100a48:	83 e8 01             	sub    $0x1,%eax
80100a4b:	a3 40 18 11 80       	mov    %eax,0x80111840
      }
      break;
80100a50:	eb 20                	jmp    80100a72 <consoleread+0xe3>
    }
    *dst++ = c;
80100a52:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a55:	8d 50 01             	lea    0x1(%eax),%edx
80100a58:	89 55 0c             	mov    %edx,0xc(%ebp)
80100a5b:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a5e:	88 10                	mov    %dl,(%eax)
    --n;
80100a60:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100a64:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100a68:	74 0b                	je     80100a75 <consoleread+0xe6>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100a6a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100a6e:	7f 98                	jg     80100a08 <consoleread+0x79>
80100a70:	eb 04                	jmp    80100a76 <consoleread+0xe7>
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
80100a72:	90                   	nop
80100a73:	eb 01                	jmp    80100a76 <consoleread+0xe7>
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
80100a75:	90                   	nop
  }
  release(&cons.lock);
80100a76:	83 ec 0c             	sub    $0xc,%esp
80100a79:	68 00 c6 10 80       	push   $0x8010c600
80100a7e:	e8 5a 4d 00 00       	call   801057dd <release>
80100a83:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100a86:	83 ec 0c             	sub    $0xc,%esp
80100a89:	ff 75 08             	pushl  0x8(%ebp)
80100a8c:	e8 c5 0f 00 00       	call   80101a56 <ilock>
80100a91:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100a94:	8b 45 10             	mov    0x10(%ebp),%eax
80100a97:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a9a:	29 c2                	sub    %eax,%edx
80100a9c:	89 d0                	mov    %edx,%eax
}
80100a9e:	c9                   	leave  
80100a9f:	c3                   	ret    

80100aa0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100aa0:	55                   	push   %ebp
80100aa1:	89 e5                	mov    %esp,%ebp
80100aa3:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100aa6:	83 ec 0c             	sub    $0xc,%esp
80100aa9:	ff 75 08             	pushl  0x8(%ebp)
80100aac:	e8 2b 11 00 00       	call   80101bdc <iunlock>
80100ab1:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100ab4:	83 ec 0c             	sub    $0xc,%esp
80100ab7:	68 00 c6 10 80       	push   $0x8010c600
80100abc:	e8 b5 4c 00 00       	call   80105776 <acquire>
80100ac1:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100ac4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100acb:	eb 21                	jmp    80100aee <consolewrite+0x4e>
    consputc(buf[i] & 0xff);
80100acd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100ad0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ad3:	01 d0                	add    %edx,%eax
80100ad5:	0f b6 00             	movzbl (%eax),%eax
80100ad8:	0f be c0             	movsbl %al,%eax
80100adb:	0f b6 c0             	movzbl %al,%eax
80100ade:	83 ec 0c             	sub    $0xc,%esp
80100ae1:	50                   	push   %eax
80100ae2:	e8 ab fc ff ff       	call   80100792 <consputc>
80100ae7:	83 c4 10             	add    $0x10,%esp
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100aea:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100af1:	3b 45 10             	cmp    0x10(%ebp),%eax
80100af4:	7c d7                	jl     80100acd <consolewrite+0x2d>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100af6:	83 ec 0c             	sub    $0xc,%esp
80100af9:	68 00 c6 10 80       	push   $0x8010c600
80100afe:	e8 da 4c 00 00       	call   801057dd <release>
80100b03:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100b06:	83 ec 0c             	sub    $0xc,%esp
80100b09:	ff 75 08             	pushl  0x8(%ebp)
80100b0c:	e8 45 0f 00 00       	call   80101a56 <ilock>
80100b11:	83 c4 10             	add    $0x10,%esp

  return n;
80100b14:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100b17:	c9                   	leave  
80100b18:	c3                   	ret    

80100b19 <consoleinit>:

void
consoleinit(void)
{
80100b19:	55                   	push   %ebp
80100b1a:	89 e5                	mov    %esp,%ebp
80100b1c:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100b1f:	83 ec 08             	sub    $0x8,%esp
80100b22:	68 66 8f 10 80       	push   $0x80108f66
80100b27:	68 00 c6 10 80       	push   $0x8010c600
80100b2c:	e8 23 4c 00 00       	call   80105754 <initlock>
80100b31:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b34:	c7 05 0c 22 11 80 a0 	movl   $0x80100aa0,0x8011220c
80100b3b:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b3e:	c7 05 08 22 11 80 8f 	movl   $0x8010098f,0x80112208
80100b45:	09 10 80 
  cons.locking = 1;
80100b48:	c7 05 34 c6 10 80 01 	movl   $0x1,0x8010c634
80100b4f:	00 00 00 

  picenable(IRQ_KBD);
80100b52:	83 ec 0c             	sub    $0xc,%esp
80100b55:	6a 01                	push   $0x1
80100b57:	e8 ad 36 00 00       	call   80104209 <picenable>
80100b5c:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_KBD, 0);
80100b5f:	83 ec 08             	sub    $0x8,%esp
80100b62:	6a 00                	push   $0x0
80100b64:	6a 01                	push   $0x1
80100b66:	e8 4d 22 00 00       	call   80102db8 <ioapicenable>
80100b6b:	83 c4 10             	add    $0x10,%esp
}
80100b6e:	90                   	nop
80100b6f:	c9                   	leave  
80100b70:	c3                   	ret    

80100b71 <exec>:
#include "stat.h"
#endif

int
exec(char *path, char **argv)
{
80100b71:	55                   	push   %ebp
80100b72:	89 e5                	mov    %esp,%ebp
80100b74:	81 ec 38 01 00 00    	sub    $0x138,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100b7a:	e8 ac 2c 00 00       	call   8010382b <begin_op>
  if((ip = namei(path)) == 0){
80100b7f:	83 ec 0c             	sub    $0xc,%esp
80100b82:	ff 75 08             	pushl  0x8(%ebp)
80100b85:	e8 de 1a 00 00       	call   80102668 <namei>
80100b8a:	83 c4 10             	add    $0x10,%esp
80100b8d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b90:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b94:	75 0f                	jne    80100ba5 <exec+0x34>
    end_op();
80100b96:	e8 1c 2d 00 00       	call   801038b7 <end_op>
    return -1;
80100b9b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ba0:	e9 76 04 00 00       	jmp    8010101b <exec+0x4aa>
  }
  ilock(ip);
80100ba5:	83 ec 0c             	sub    $0xc,%esp
80100ba8:	ff 75 d8             	pushl  -0x28(%ebp)
80100bab:	e8 a6 0e 00 00       	call   80101a56 <ilock>
80100bb0:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100bb3:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  #ifdef CS333_P5
  struct stat access;
  int permission;

  stati(ip, &access);
80100bba:	83 ec 08             	sub    $0x8,%esp
80100bbd:	8d 85 c8 fe ff ff    	lea    -0x138(%ebp),%eax
80100bc3:	50                   	push   %eax
80100bc4:	ff 75 d8             	pushl  -0x28(%ebp)
80100bc7:	e8 da 13 00 00       	call   80101fa6 <stati>
80100bcc:	83 c4 10             	add    $0x10,%esp
  if(access.uid == proc->uid){
80100bcf:	8b 95 dc fe ff ff    	mov    -0x124(%ebp),%edx
80100bd5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100bdb:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80100be1:	39 c2                	cmp    %eax,%edx
80100be3:	75 15                	jne    80100bfa <exec+0x89>
    permission = access.mode.flags.u_x;
80100be5:	0f b6 85 e4 fe ff ff 	movzbl -0x11c(%ebp),%eax
80100bec:	c0 e8 06             	shr    $0x6,%al
80100bef:	83 e0 01             	and    $0x1,%eax
80100bf2:	0f b6 c0             	movzbl %al,%eax
80100bf5:	89 45 d0             	mov    %eax,-0x30(%ebp)
80100bf8:	eb 3b                	jmp    80100c35 <exec+0xc4>
  }
  else if(access.gid == proc->gid){
80100bfa:	8b 95 e0 fe ff ff    	mov    -0x120(%ebp),%edx
80100c00:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100c06:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80100c0c:	39 c2                	cmp    %eax,%edx
80100c0e:	75 15                	jne    80100c25 <exec+0xb4>
    permission = access.mode.flags.g_x;
80100c10:	0f b6 85 e4 fe ff ff 	movzbl -0x11c(%ebp),%eax
80100c17:	c0 e8 03             	shr    $0x3,%al
80100c1a:	83 e0 01             	and    $0x1,%eax
80100c1d:	0f b6 c0             	movzbl %al,%eax
80100c20:	89 45 d0             	mov    %eax,-0x30(%ebp)
80100c23:	eb 10                	jmp    80100c35 <exec+0xc4>
  }
  else{
    permission = access.mode.flags.o_x;
80100c25:	0f b6 85 e4 fe ff ff 	movzbl -0x11c(%ebp),%eax
80100c2c:	83 e0 01             	and    $0x1,%eax
80100c2f:	0f b6 c0             	movzbl %al,%eax
80100c32:	89 45 d0             	mov    %eax,-0x30(%ebp)
  }

  if(permission == 0)
80100c35:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
80100c39:	0f 84 88 03 00 00    	je     80100fc7 <exec+0x456>
    goto bad;
  #endif

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100c3f:	6a 34                	push   $0x34
80100c41:	6a 00                	push   $0x0
80100c43:	8d 85 08 ff ff ff    	lea    -0xf8(%ebp),%eax
80100c49:	50                   	push   %eax
80100c4a:	ff 75 d8             	pushl  -0x28(%ebp)
80100c4d:	e8 c6 13 00 00       	call   80102018 <readi>
80100c52:	83 c4 10             	add    $0x10,%esp
80100c55:	83 f8 33             	cmp    $0x33,%eax
80100c58:	0f 86 6c 03 00 00    	jbe    80100fca <exec+0x459>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100c5e:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
80100c64:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100c69:	0f 85 5e 03 00 00    	jne    80100fcd <exec+0x45c>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100c6f:	e8 70 7a 00 00       	call   801086e4 <setupkvm>
80100c74:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100c77:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100c7b:	0f 84 4f 03 00 00    	je     80100fd0 <exec+0x45f>
    goto bad;

  // Load program into memory.
  sz = 0;
80100c81:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c88:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100c8f:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
80100c95:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c98:	e9 ab 00 00 00       	jmp    80100d48 <exec+0x1d7>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100ca0:	6a 20                	push   $0x20
80100ca2:	50                   	push   %eax
80100ca3:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
80100ca9:	50                   	push   %eax
80100caa:	ff 75 d8             	pushl  -0x28(%ebp)
80100cad:	e8 66 13 00 00       	call   80102018 <readi>
80100cb2:	83 c4 10             	add    $0x10,%esp
80100cb5:	83 f8 20             	cmp    $0x20,%eax
80100cb8:	0f 85 15 03 00 00    	jne    80100fd3 <exec+0x462>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100cbe:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
80100cc4:	83 f8 01             	cmp    $0x1,%eax
80100cc7:	75 71                	jne    80100d3a <exec+0x1c9>
      continue;
    if(ph.memsz < ph.filesz)
80100cc9:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100ccf:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
80100cd5:	39 c2                	cmp    %eax,%edx
80100cd7:	0f 82 f9 02 00 00    	jb     80100fd6 <exec+0x465>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100cdd:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100ce3:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100ce9:	01 d0                	add    %edx,%eax
80100ceb:	83 ec 04             	sub    $0x4,%esp
80100cee:	50                   	push   %eax
80100cef:	ff 75 e0             	pushl  -0x20(%ebp)
80100cf2:	ff 75 d4             	pushl  -0x2c(%ebp)
80100cf5:	e8 91 7d 00 00       	call   80108a8b <allocuvm>
80100cfa:	83 c4 10             	add    $0x10,%esp
80100cfd:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d00:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d04:	0f 84 cf 02 00 00    	je     80100fd9 <exec+0x468>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100d0a:	8b 95 f8 fe ff ff    	mov    -0x108(%ebp),%edx
80100d10:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100d16:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100d1c:	83 ec 0c             	sub    $0xc,%esp
80100d1f:	52                   	push   %edx
80100d20:	50                   	push   %eax
80100d21:	ff 75 d8             	pushl  -0x28(%ebp)
80100d24:	51                   	push   %ecx
80100d25:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d28:	e8 87 7c 00 00       	call   801089b4 <loaduvm>
80100d2d:	83 c4 20             	add    $0x20,%esp
80100d30:	85 c0                	test   %eax,%eax
80100d32:	0f 88 a4 02 00 00    	js     80100fdc <exec+0x46b>
80100d38:	eb 01                	jmp    80100d3b <exec+0x1ca>
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
80100d3a:	90                   	nop
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d3b:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100d3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100d42:	83 c0 20             	add    $0x20,%eax
80100d45:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100d48:	0f b7 85 34 ff ff ff 	movzwl -0xcc(%ebp),%eax
80100d4f:	0f b7 c0             	movzwl %ax,%eax
80100d52:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100d55:	0f 8f 42 ff ff ff    	jg     80100c9d <exec+0x12c>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100d5b:	83 ec 0c             	sub    $0xc,%esp
80100d5e:	ff 75 d8             	pushl  -0x28(%ebp)
80100d61:	e8 d8 0f 00 00       	call   80101d3e <iunlockput>
80100d66:	83 c4 10             	add    $0x10,%esp
  end_op();
80100d69:	e8 49 2b 00 00       	call   801038b7 <end_op>
  ip = 0;
80100d6e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100d75:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d78:	05 ff 0f 00 00       	add    $0xfff,%eax
80100d7d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100d82:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d85:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d88:	05 00 20 00 00       	add    $0x2000,%eax
80100d8d:	83 ec 04             	sub    $0x4,%esp
80100d90:	50                   	push   %eax
80100d91:	ff 75 e0             	pushl  -0x20(%ebp)
80100d94:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d97:	e8 ef 7c 00 00       	call   80108a8b <allocuvm>
80100d9c:	83 c4 10             	add    $0x10,%esp
80100d9f:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100da2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100da6:	0f 84 33 02 00 00    	je     80100fdf <exec+0x46e>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100dac:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100daf:	2d 00 20 00 00       	sub    $0x2000,%eax
80100db4:	83 ec 08             	sub    $0x8,%esp
80100db7:	50                   	push   %eax
80100db8:	ff 75 d4             	pushl  -0x2c(%ebp)
80100dbb:	e8 f1 7e 00 00       	call   80108cb1 <clearpteu>
80100dc0:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100dc3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100dc6:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100dc9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100dd0:	e9 96 00 00 00       	jmp    80100e6b <exec+0x2fa>
    if(argc >= MAXARG)
80100dd5:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100dd9:	0f 87 03 02 00 00    	ja     80100fe2 <exec+0x471>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ddf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100de2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100de9:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dec:	01 d0                	add    %edx,%eax
80100dee:	8b 00                	mov    (%eax),%eax
80100df0:	83 ec 0c             	sub    $0xc,%esp
80100df3:	50                   	push   %eax
80100df4:	e8 2d 4e 00 00       	call   80105c26 <strlen>
80100df9:	83 c4 10             	add    $0x10,%esp
80100dfc:	89 c2                	mov    %eax,%edx
80100dfe:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e01:	29 d0                	sub    %edx,%eax
80100e03:	83 e8 01             	sub    $0x1,%eax
80100e06:	83 e0 fc             	and    $0xfffffffc,%eax
80100e09:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e0f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e16:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e19:	01 d0                	add    %edx,%eax
80100e1b:	8b 00                	mov    (%eax),%eax
80100e1d:	83 ec 0c             	sub    $0xc,%esp
80100e20:	50                   	push   %eax
80100e21:	e8 00 4e 00 00       	call   80105c26 <strlen>
80100e26:	83 c4 10             	add    $0x10,%esp
80100e29:	83 c0 01             	add    $0x1,%eax
80100e2c:	89 c1                	mov    %eax,%ecx
80100e2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e31:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e38:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e3b:	01 d0                	add    %edx,%eax
80100e3d:	8b 00                	mov    (%eax),%eax
80100e3f:	51                   	push   %ecx
80100e40:	50                   	push   %eax
80100e41:	ff 75 dc             	pushl  -0x24(%ebp)
80100e44:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e47:	e8 1c 80 00 00       	call   80108e68 <copyout>
80100e4c:	83 c4 10             	add    $0x10,%esp
80100e4f:	85 c0                	test   %eax,%eax
80100e51:	0f 88 8e 01 00 00    	js     80100fe5 <exec+0x474>
      goto bad;
    ustack[3+argc] = sp;
80100e57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e5a:	8d 50 03             	lea    0x3(%eax),%edx
80100e5d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e60:	89 84 95 3c ff ff ff 	mov    %eax,-0xc4(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100e67:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100e6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e6e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e75:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e78:	01 d0                	add    %edx,%eax
80100e7a:	8b 00                	mov    (%eax),%eax
80100e7c:	85 c0                	test   %eax,%eax
80100e7e:	0f 85 51 ff ff ff    	jne    80100dd5 <exec+0x264>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100e84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e87:	83 c0 03             	add    $0x3,%eax
80100e8a:	c7 84 85 3c ff ff ff 	movl   $0x0,-0xc4(%ebp,%eax,4)
80100e91:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100e95:	c7 85 3c ff ff ff ff 	movl   $0xffffffff,-0xc4(%ebp)
80100e9c:	ff ff ff 
  ustack[1] = argc;
80100e9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ea2:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ea8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100eab:	83 c0 01             	add    $0x1,%eax
80100eae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100eb5:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100eb8:	29 d0                	sub    %edx,%eax
80100eba:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

  sp -= (3+argc+1) * 4;
80100ec0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ec3:	83 c0 04             	add    $0x4,%eax
80100ec6:	c1 e0 02             	shl    $0x2,%eax
80100ec9:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ecc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ecf:	83 c0 04             	add    $0x4,%eax
80100ed2:	c1 e0 02             	shl    $0x2,%eax
80100ed5:	50                   	push   %eax
80100ed6:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
80100edc:	50                   	push   %eax
80100edd:	ff 75 dc             	pushl  -0x24(%ebp)
80100ee0:	ff 75 d4             	pushl  -0x2c(%ebp)
80100ee3:	e8 80 7f 00 00       	call   80108e68 <copyout>
80100ee8:	83 c4 10             	add    $0x10,%esp
80100eeb:	85 c0                	test   %eax,%eax
80100eed:	0f 88 f5 00 00 00    	js     80100fe8 <exec+0x477>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ef3:	8b 45 08             	mov    0x8(%ebp),%eax
80100ef6:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100efc:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100eff:	eb 17                	jmp    80100f18 <exec+0x3a7>
    if(*s == '/')
80100f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f04:	0f b6 00             	movzbl (%eax),%eax
80100f07:	3c 2f                	cmp    $0x2f,%al
80100f09:	75 09                	jne    80100f14 <exec+0x3a3>
      last = s+1;
80100f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f0e:	83 c0 01             	add    $0x1,%eax
80100f11:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100f14:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f1b:	0f b6 00             	movzbl (%eax),%eax
80100f1e:	84 c0                	test   %al,%al
80100f20:	75 df                	jne    80100f01 <exec+0x390>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100f22:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f28:	83 c0 6c             	add    $0x6c,%eax
80100f2b:	83 ec 04             	sub    $0x4,%esp
80100f2e:	6a 10                	push   $0x10
80100f30:	ff 75 f0             	pushl  -0x10(%ebp)
80100f33:	50                   	push   %eax
80100f34:	e8 a3 4c 00 00       	call   80105bdc <safestrcpy>
80100f39:	83 c4 10             	add    $0x10,%esp

  #ifdef CS333_P5
  if(access.mode.flags.setuid == 1)
80100f3c:	0f b6 85 e5 fe ff ff 	movzbl -0x11b(%ebp),%eax
80100f43:	83 e0 02             	and    $0x2,%eax
80100f46:	84 c0                	test   %al,%al
80100f48:	74 12                	je     80100f5c <exec+0x3eb>
    proc->uid = access.uid;
80100f4a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f50:	8b 95 dc fe ff ff    	mov    -0x124(%ebp),%edx
80100f56:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  #endif

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100f5c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f62:	8b 40 04             	mov    0x4(%eax),%eax
80100f65:	89 45 cc             	mov    %eax,-0x34(%ebp)
  proc->pgdir = pgdir;
80100f68:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f6e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100f71:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100f74:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f7a:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100f7d:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100f7f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f85:	8b 40 18             	mov    0x18(%eax),%eax
80100f88:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
80100f8e:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100f91:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f97:	8b 40 18             	mov    0x18(%eax),%eax
80100f9a:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100f9d:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100fa0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100fa6:	83 ec 0c             	sub    $0xc,%esp
80100fa9:	50                   	push   %eax
80100faa:	e8 1c 78 00 00       	call   801087cb <switchuvm>
80100faf:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100fb2:	83 ec 0c             	sub    $0xc,%esp
80100fb5:	ff 75 cc             	pushl  -0x34(%ebp)
80100fb8:	e8 54 7c 00 00       	call   80108c11 <freevm>
80100fbd:	83 c4 10             	add    $0x10,%esp
  return 0;
80100fc0:	b8 00 00 00 00       	mov    $0x0,%eax
80100fc5:	eb 54                	jmp    8010101b <exec+0x4aa>
  else{
    permission = access.mode.flags.o_x;
  }

  if(permission == 0)
    goto bad;
80100fc7:	90                   	nop
80100fc8:	eb 1f                	jmp    80100fe9 <exec+0x478>
  #endif

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
80100fca:	90                   	nop
80100fcb:	eb 1c                	jmp    80100fe9 <exec+0x478>
  if(elf.magic != ELF_MAGIC)
    goto bad;
80100fcd:	90                   	nop
80100fce:	eb 19                	jmp    80100fe9 <exec+0x478>

  if((pgdir = setupkvm()) == 0)
    goto bad;
80100fd0:	90                   	nop
80100fd1:	eb 16                	jmp    80100fe9 <exec+0x478>

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
80100fd3:	90                   	nop
80100fd4:	eb 13                	jmp    80100fe9 <exec+0x478>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
80100fd6:	90                   	nop
80100fd7:	eb 10                	jmp    80100fe9 <exec+0x478>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
80100fd9:	90                   	nop
80100fda:	eb 0d                	jmp    80100fe9 <exec+0x478>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
80100fdc:	90                   	nop
80100fdd:	eb 0a                	jmp    80100fe9 <exec+0x478>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
80100fdf:	90                   	nop
80100fe0:	eb 07                	jmp    80100fe9 <exec+0x478>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
80100fe2:	90                   	nop
80100fe3:	eb 04                	jmp    80100fe9 <exec+0x478>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
80100fe5:	90                   	nop
80100fe6:	eb 01                	jmp    80100fe9 <exec+0x478>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
80100fe8:	90                   	nop
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
80100fe9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100fed:	74 0e                	je     80100ffd <exec+0x48c>
    freevm(pgdir);
80100fef:	83 ec 0c             	sub    $0xc,%esp
80100ff2:	ff 75 d4             	pushl  -0x2c(%ebp)
80100ff5:	e8 17 7c 00 00       	call   80108c11 <freevm>
80100ffa:	83 c4 10             	add    $0x10,%esp
  if(ip){
80100ffd:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80101001:	74 13                	je     80101016 <exec+0x4a5>
    iunlockput(ip);
80101003:	83 ec 0c             	sub    $0xc,%esp
80101006:	ff 75 d8             	pushl  -0x28(%ebp)
80101009:	e8 30 0d 00 00       	call   80101d3e <iunlockput>
8010100e:	83 c4 10             	add    $0x10,%esp
    end_op();
80101011:	e8 a1 28 00 00       	call   801038b7 <end_op>
  }
  return -1;
80101016:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010101b:	c9                   	leave  
8010101c:	c3                   	ret    

8010101d <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
8010101d:	55                   	push   %ebp
8010101e:	89 e5                	mov    %esp,%ebp
80101020:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
80101023:	83 ec 08             	sub    $0x8,%esp
80101026:	68 6e 8f 10 80       	push   $0x80108f6e
8010102b:	68 60 18 11 80       	push   $0x80111860
80101030:	e8 1f 47 00 00       	call   80105754 <initlock>
80101035:	83 c4 10             	add    $0x10,%esp
}
80101038:	90                   	nop
80101039:	c9                   	leave  
8010103a:	c3                   	ret    

8010103b <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
8010103b:	55                   	push   %ebp
8010103c:	89 e5                	mov    %esp,%ebp
8010103e:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
80101041:	83 ec 0c             	sub    $0xc,%esp
80101044:	68 60 18 11 80       	push   $0x80111860
80101049:	e8 28 47 00 00       	call   80105776 <acquire>
8010104e:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101051:	c7 45 f4 94 18 11 80 	movl   $0x80111894,-0xc(%ebp)
80101058:	eb 2d                	jmp    80101087 <filealloc+0x4c>
    if(f->ref == 0){
8010105a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010105d:	8b 40 04             	mov    0x4(%eax),%eax
80101060:	85 c0                	test   %eax,%eax
80101062:	75 1f                	jne    80101083 <filealloc+0x48>
      f->ref = 1;
80101064:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101067:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
8010106e:	83 ec 0c             	sub    $0xc,%esp
80101071:	68 60 18 11 80       	push   $0x80111860
80101076:	e8 62 47 00 00       	call   801057dd <release>
8010107b:	83 c4 10             	add    $0x10,%esp
      return f;
8010107e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101081:	eb 23                	jmp    801010a6 <filealloc+0x6b>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101083:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80101087:	b8 f4 21 11 80       	mov    $0x801121f4,%eax
8010108c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
8010108f:	72 c9                	jb     8010105a <filealloc+0x1f>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80101091:	83 ec 0c             	sub    $0xc,%esp
80101094:	68 60 18 11 80       	push   $0x80111860
80101099:	e8 3f 47 00 00       	call   801057dd <release>
8010109e:	83 c4 10             	add    $0x10,%esp
  return 0;
801010a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801010a6:	c9                   	leave  
801010a7:	c3                   	ret    

801010a8 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
801010a8:	55                   	push   %ebp
801010a9:	89 e5                	mov    %esp,%ebp
801010ab:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
801010ae:	83 ec 0c             	sub    $0xc,%esp
801010b1:	68 60 18 11 80       	push   $0x80111860
801010b6:	e8 bb 46 00 00       	call   80105776 <acquire>
801010bb:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801010be:	8b 45 08             	mov    0x8(%ebp),%eax
801010c1:	8b 40 04             	mov    0x4(%eax),%eax
801010c4:	85 c0                	test   %eax,%eax
801010c6:	7f 0d                	jg     801010d5 <filedup+0x2d>
    panic("filedup");
801010c8:	83 ec 0c             	sub    $0xc,%esp
801010cb:	68 75 8f 10 80       	push   $0x80108f75
801010d0:	e8 91 f4 ff ff       	call   80100566 <panic>
  f->ref++;
801010d5:	8b 45 08             	mov    0x8(%ebp),%eax
801010d8:	8b 40 04             	mov    0x4(%eax),%eax
801010db:	8d 50 01             	lea    0x1(%eax),%edx
801010de:	8b 45 08             	mov    0x8(%ebp),%eax
801010e1:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
801010e4:	83 ec 0c             	sub    $0xc,%esp
801010e7:	68 60 18 11 80       	push   $0x80111860
801010ec:	e8 ec 46 00 00       	call   801057dd <release>
801010f1:	83 c4 10             	add    $0x10,%esp
  return f;
801010f4:	8b 45 08             	mov    0x8(%ebp),%eax
}
801010f7:	c9                   	leave  
801010f8:	c3                   	ret    

801010f9 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801010f9:	55                   	push   %ebp
801010fa:	89 e5                	mov    %esp,%ebp
801010fc:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 60 18 11 80       	push   $0x80111860
80101107:	e8 6a 46 00 00       	call   80105776 <acquire>
8010110c:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
8010110f:	8b 45 08             	mov    0x8(%ebp),%eax
80101112:	8b 40 04             	mov    0x4(%eax),%eax
80101115:	85 c0                	test   %eax,%eax
80101117:	7f 0d                	jg     80101126 <fileclose+0x2d>
    panic("fileclose");
80101119:	83 ec 0c             	sub    $0xc,%esp
8010111c:	68 7d 8f 10 80       	push   $0x80108f7d
80101121:	e8 40 f4 ff ff       	call   80100566 <panic>
  if(--f->ref > 0){
80101126:	8b 45 08             	mov    0x8(%ebp),%eax
80101129:	8b 40 04             	mov    0x4(%eax),%eax
8010112c:	8d 50 ff             	lea    -0x1(%eax),%edx
8010112f:	8b 45 08             	mov    0x8(%ebp),%eax
80101132:	89 50 04             	mov    %edx,0x4(%eax)
80101135:	8b 45 08             	mov    0x8(%ebp),%eax
80101138:	8b 40 04             	mov    0x4(%eax),%eax
8010113b:	85 c0                	test   %eax,%eax
8010113d:	7e 15                	jle    80101154 <fileclose+0x5b>
    release(&ftable.lock);
8010113f:	83 ec 0c             	sub    $0xc,%esp
80101142:	68 60 18 11 80       	push   $0x80111860
80101147:	e8 91 46 00 00       	call   801057dd <release>
8010114c:	83 c4 10             	add    $0x10,%esp
8010114f:	e9 8b 00 00 00       	jmp    801011df <fileclose+0xe6>
    return;
  }
  ff = *f;
80101154:	8b 45 08             	mov    0x8(%ebp),%eax
80101157:	8b 10                	mov    (%eax),%edx
80101159:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010115c:	8b 50 04             	mov    0x4(%eax),%edx
8010115f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101162:	8b 50 08             	mov    0x8(%eax),%edx
80101165:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101168:	8b 50 0c             	mov    0xc(%eax),%edx
8010116b:	89 55 ec             	mov    %edx,-0x14(%ebp)
8010116e:	8b 50 10             	mov    0x10(%eax),%edx
80101171:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101174:	8b 40 14             	mov    0x14(%eax),%eax
80101177:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
8010117a:	8b 45 08             	mov    0x8(%ebp),%eax
8010117d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101184:	8b 45 08             	mov    0x8(%ebp),%eax
80101187:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
8010118d:	83 ec 0c             	sub    $0xc,%esp
80101190:	68 60 18 11 80       	push   $0x80111860
80101195:	e8 43 46 00 00       	call   801057dd <release>
8010119a:	83 c4 10             	add    $0x10,%esp
  
  if(ff.type == FD_PIPE)
8010119d:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011a0:	83 f8 01             	cmp    $0x1,%eax
801011a3:	75 19                	jne    801011be <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
801011a5:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
801011a9:	0f be d0             	movsbl %al,%edx
801011ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
801011af:	83 ec 08             	sub    $0x8,%esp
801011b2:	52                   	push   %edx
801011b3:	50                   	push   %eax
801011b4:	e8 b9 32 00 00       	call   80104472 <pipeclose>
801011b9:	83 c4 10             	add    $0x10,%esp
801011bc:	eb 21                	jmp    801011df <fileclose+0xe6>
  else if(ff.type == FD_INODE){
801011be:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011c1:	83 f8 02             	cmp    $0x2,%eax
801011c4:	75 19                	jne    801011df <fileclose+0xe6>
    begin_op();
801011c6:	e8 60 26 00 00       	call   8010382b <begin_op>
    iput(ff.ip);
801011cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801011ce:	83 ec 0c             	sub    $0xc,%esp
801011d1:	50                   	push   %eax
801011d2:	e8 77 0a 00 00       	call   80101c4e <iput>
801011d7:	83 c4 10             	add    $0x10,%esp
    end_op();
801011da:	e8 d8 26 00 00       	call   801038b7 <end_op>
  }
}
801011df:	c9                   	leave  
801011e0:	c3                   	ret    

801011e1 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801011e1:	55                   	push   %ebp
801011e2:	89 e5                	mov    %esp,%ebp
801011e4:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
801011e7:	8b 45 08             	mov    0x8(%ebp),%eax
801011ea:	8b 00                	mov    (%eax),%eax
801011ec:	83 f8 02             	cmp    $0x2,%eax
801011ef:	75 40                	jne    80101231 <filestat+0x50>
    ilock(f->ip);
801011f1:	8b 45 08             	mov    0x8(%ebp),%eax
801011f4:	8b 40 10             	mov    0x10(%eax),%eax
801011f7:	83 ec 0c             	sub    $0xc,%esp
801011fa:	50                   	push   %eax
801011fb:	e8 56 08 00 00       	call   80101a56 <ilock>
80101200:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
80101203:	8b 45 08             	mov    0x8(%ebp),%eax
80101206:	8b 40 10             	mov    0x10(%eax),%eax
80101209:	83 ec 08             	sub    $0x8,%esp
8010120c:	ff 75 0c             	pushl  0xc(%ebp)
8010120f:	50                   	push   %eax
80101210:	e8 91 0d 00 00       	call   80101fa6 <stati>
80101215:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
80101218:	8b 45 08             	mov    0x8(%ebp),%eax
8010121b:	8b 40 10             	mov    0x10(%eax),%eax
8010121e:	83 ec 0c             	sub    $0xc,%esp
80101221:	50                   	push   %eax
80101222:	e8 b5 09 00 00       	call   80101bdc <iunlock>
80101227:	83 c4 10             	add    $0x10,%esp
    return 0;
8010122a:	b8 00 00 00 00       	mov    $0x0,%eax
8010122f:	eb 05                	jmp    80101236 <filestat+0x55>
  }
  return -1;
80101231:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101236:	c9                   	leave  
80101237:	c3                   	ret    

80101238 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101238:	55                   	push   %ebp
80101239:	89 e5                	mov    %esp,%ebp
8010123b:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
8010123e:	8b 45 08             	mov    0x8(%ebp),%eax
80101241:	0f b6 40 08          	movzbl 0x8(%eax),%eax
80101245:	84 c0                	test   %al,%al
80101247:	75 0a                	jne    80101253 <fileread+0x1b>
    return -1;
80101249:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010124e:	e9 9b 00 00 00       	jmp    801012ee <fileread+0xb6>
  if(f->type == FD_PIPE)
80101253:	8b 45 08             	mov    0x8(%ebp),%eax
80101256:	8b 00                	mov    (%eax),%eax
80101258:	83 f8 01             	cmp    $0x1,%eax
8010125b:	75 1a                	jne    80101277 <fileread+0x3f>
    return piperead(f->pipe, addr, n);
8010125d:	8b 45 08             	mov    0x8(%ebp),%eax
80101260:	8b 40 0c             	mov    0xc(%eax),%eax
80101263:	83 ec 04             	sub    $0x4,%esp
80101266:	ff 75 10             	pushl  0x10(%ebp)
80101269:	ff 75 0c             	pushl  0xc(%ebp)
8010126c:	50                   	push   %eax
8010126d:	e8 a8 33 00 00       	call   8010461a <piperead>
80101272:	83 c4 10             	add    $0x10,%esp
80101275:	eb 77                	jmp    801012ee <fileread+0xb6>
  if(f->type == FD_INODE){
80101277:	8b 45 08             	mov    0x8(%ebp),%eax
8010127a:	8b 00                	mov    (%eax),%eax
8010127c:	83 f8 02             	cmp    $0x2,%eax
8010127f:	75 60                	jne    801012e1 <fileread+0xa9>
    ilock(f->ip);
80101281:	8b 45 08             	mov    0x8(%ebp),%eax
80101284:	8b 40 10             	mov    0x10(%eax),%eax
80101287:	83 ec 0c             	sub    $0xc,%esp
8010128a:	50                   	push   %eax
8010128b:	e8 c6 07 00 00       	call   80101a56 <ilock>
80101290:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101293:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101296:	8b 45 08             	mov    0x8(%ebp),%eax
80101299:	8b 50 14             	mov    0x14(%eax),%edx
8010129c:	8b 45 08             	mov    0x8(%ebp),%eax
8010129f:	8b 40 10             	mov    0x10(%eax),%eax
801012a2:	51                   	push   %ecx
801012a3:	52                   	push   %edx
801012a4:	ff 75 0c             	pushl  0xc(%ebp)
801012a7:	50                   	push   %eax
801012a8:	e8 6b 0d 00 00       	call   80102018 <readi>
801012ad:	83 c4 10             	add    $0x10,%esp
801012b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801012b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801012b7:	7e 11                	jle    801012ca <fileread+0x92>
      f->off += r;
801012b9:	8b 45 08             	mov    0x8(%ebp),%eax
801012bc:	8b 50 14             	mov    0x14(%eax),%edx
801012bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012c2:	01 c2                	add    %eax,%edx
801012c4:	8b 45 08             	mov    0x8(%ebp),%eax
801012c7:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
801012ca:	8b 45 08             	mov    0x8(%ebp),%eax
801012cd:	8b 40 10             	mov    0x10(%eax),%eax
801012d0:	83 ec 0c             	sub    $0xc,%esp
801012d3:	50                   	push   %eax
801012d4:	e8 03 09 00 00       	call   80101bdc <iunlock>
801012d9:	83 c4 10             	add    $0x10,%esp
    return r;
801012dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012df:	eb 0d                	jmp    801012ee <fileread+0xb6>
  }
  panic("fileread");
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	68 87 8f 10 80       	push   $0x80108f87
801012e9:	e8 78 f2 ff ff       	call   80100566 <panic>
}
801012ee:	c9                   	leave  
801012ef:	c3                   	ret    

801012f0 <filewrite>:

// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801012f0:	55                   	push   %ebp
801012f1:	89 e5                	mov    %esp,%ebp
801012f3:	53                   	push   %ebx
801012f4:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
801012f7:	8b 45 08             	mov    0x8(%ebp),%eax
801012fa:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801012fe:	84 c0                	test   %al,%al
80101300:	75 0a                	jne    8010130c <filewrite+0x1c>
    return -1;
80101302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101307:	e9 1b 01 00 00       	jmp    80101427 <filewrite+0x137>
  if(f->type == FD_PIPE)
8010130c:	8b 45 08             	mov    0x8(%ebp),%eax
8010130f:	8b 00                	mov    (%eax),%eax
80101311:	83 f8 01             	cmp    $0x1,%eax
80101314:	75 1d                	jne    80101333 <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
80101316:	8b 45 08             	mov    0x8(%ebp),%eax
80101319:	8b 40 0c             	mov    0xc(%eax),%eax
8010131c:	83 ec 04             	sub    $0x4,%esp
8010131f:	ff 75 10             	pushl  0x10(%ebp)
80101322:	ff 75 0c             	pushl  0xc(%ebp)
80101325:	50                   	push   %eax
80101326:	e8 f1 31 00 00       	call   8010451c <pipewrite>
8010132b:	83 c4 10             	add    $0x10,%esp
8010132e:	e9 f4 00 00 00       	jmp    80101427 <filewrite+0x137>
  if(f->type == FD_INODE){
80101333:	8b 45 08             	mov    0x8(%ebp),%eax
80101336:	8b 00                	mov    (%eax),%eax
80101338:	83 f8 02             	cmp    $0x2,%eax
8010133b:	0f 85 d9 00 00 00    	jne    8010141a <filewrite+0x12a>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
80101341:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
80101348:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
8010134f:	e9 a3 00 00 00       	jmp    801013f7 <filewrite+0x107>
      int n1 = n - i;
80101354:	8b 45 10             	mov    0x10(%ebp),%eax
80101357:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010135a:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
8010135d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101360:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101363:	7e 06                	jle    8010136b <filewrite+0x7b>
        n1 = max;
80101365:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101368:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
8010136b:	e8 bb 24 00 00       	call   8010382b <begin_op>
      ilock(f->ip);
80101370:	8b 45 08             	mov    0x8(%ebp),%eax
80101373:	8b 40 10             	mov    0x10(%eax),%eax
80101376:	83 ec 0c             	sub    $0xc,%esp
80101379:	50                   	push   %eax
8010137a:	e8 d7 06 00 00       	call   80101a56 <ilock>
8010137f:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101382:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80101385:	8b 45 08             	mov    0x8(%ebp),%eax
80101388:	8b 50 14             	mov    0x14(%eax),%edx
8010138b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010138e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101391:	01 c3                	add    %eax,%ebx
80101393:	8b 45 08             	mov    0x8(%ebp),%eax
80101396:	8b 40 10             	mov    0x10(%eax),%eax
80101399:	51                   	push   %ecx
8010139a:	52                   	push   %edx
8010139b:	53                   	push   %ebx
8010139c:	50                   	push   %eax
8010139d:	e8 cd 0d 00 00       	call   8010216f <writei>
801013a2:	83 c4 10             	add    $0x10,%esp
801013a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
801013a8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801013ac:	7e 11                	jle    801013bf <filewrite+0xcf>
        f->off += r;
801013ae:	8b 45 08             	mov    0x8(%ebp),%eax
801013b1:	8b 50 14             	mov    0x14(%eax),%edx
801013b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013b7:	01 c2                	add    %eax,%edx
801013b9:	8b 45 08             	mov    0x8(%ebp),%eax
801013bc:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801013bf:	8b 45 08             	mov    0x8(%ebp),%eax
801013c2:	8b 40 10             	mov    0x10(%eax),%eax
801013c5:	83 ec 0c             	sub    $0xc,%esp
801013c8:	50                   	push   %eax
801013c9:	e8 0e 08 00 00       	call   80101bdc <iunlock>
801013ce:	83 c4 10             	add    $0x10,%esp
      end_op();
801013d1:	e8 e1 24 00 00       	call   801038b7 <end_op>

      if(r < 0)
801013d6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801013da:	78 29                	js     80101405 <filewrite+0x115>
        break;
      if(r != n1)
801013dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801013e2:	74 0d                	je     801013f1 <filewrite+0x101>
        panic("short filewrite");
801013e4:	83 ec 0c             	sub    $0xc,%esp
801013e7:	68 90 8f 10 80       	push   $0x80108f90
801013ec:	e8 75 f1 ff ff       	call   80100566 <panic>
      i += r;
801013f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013f4:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801013f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013fa:	3b 45 10             	cmp    0x10(%ebp),%eax
801013fd:	0f 8c 51 ff ff ff    	jl     80101354 <filewrite+0x64>
80101403:	eb 01                	jmp    80101406 <filewrite+0x116>
        f->off += r;
      iunlock(f->ip);
      end_op();

      if(r < 0)
        break;
80101405:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
80101406:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101409:	3b 45 10             	cmp    0x10(%ebp),%eax
8010140c:	75 05                	jne    80101413 <filewrite+0x123>
8010140e:	8b 45 10             	mov    0x10(%ebp),%eax
80101411:	eb 14                	jmp    80101427 <filewrite+0x137>
80101413:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101418:	eb 0d                	jmp    80101427 <filewrite+0x137>
  }
  panic("filewrite");
8010141a:	83 ec 0c             	sub    $0xc,%esp
8010141d:	68 a0 8f 10 80       	push   $0x80108fa0
80101422:	e8 3f f1 ff ff       	call   80100566 <panic>
}
80101427:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010142a:	c9                   	leave  
8010142b:	c3                   	ret    

8010142c <readsb>:
struct superblock sb;   // there should be one per dev, but we run with one dev

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
8010142c:	55                   	push   %ebp
8010142d:	89 e5                	mov    %esp,%ebp
8010142f:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
80101432:	8b 45 08             	mov    0x8(%ebp),%eax
80101435:	83 ec 08             	sub    $0x8,%esp
80101438:	6a 01                	push   $0x1
8010143a:	50                   	push   %eax
8010143b:	e8 76 ed ff ff       	call   801001b6 <bread>
80101440:	83 c4 10             	add    $0x10,%esp
80101443:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
80101446:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101449:	83 c0 18             	add    $0x18,%eax
8010144c:	83 ec 04             	sub    $0x4,%esp
8010144f:	6a 1c                	push   $0x1c
80101451:	50                   	push   %eax
80101452:	ff 75 0c             	pushl  0xc(%ebp)
80101455:	e8 3e 46 00 00       	call   80105a98 <memmove>
8010145a:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010145d:	83 ec 0c             	sub    $0xc,%esp
80101460:	ff 75 f4             	pushl  -0xc(%ebp)
80101463:	e8 c6 ed ff ff       	call   8010022e <brelse>
80101468:	83 c4 10             	add    $0x10,%esp
}
8010146b:	90                   	nop
8010146c:	c9                   	leave  
8010146d:	c3                   	ret    

8010146e <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
8010146e:	55                   	push   %ebp
8010146f:	89 e5                	mov    %esp,%ebp
80101471:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
80101474:	8b 55 0c             	mov    0xc(%ebp),%edx
80101477:	8b 45 08             	mov    0x8(%ebp),%eax
8010147a:	83 ec 08             	sub    $0x8,%esp
8010147d:	52                   	push   %edx
8010147e:	50                   	push   %eax
8010147f:	e8 32 ed ff ff       	call   801001b6 <bread>
80101484:	83 c4 10             	add    $0x10,%esp
80101487:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
8010148a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010148d:	83 c0 18             	add    $0x18,%eax
80101490:	83 ec 04             	sub    $0x4,%esp
80101493:	68 00 02 00 00       	push   $0x200
80101498:	6a 00                	push   $0x0
8010149a:	50                   	push   %eax
8010149b:	e8 39 45 00 00       	call   801059d9 <memset>
801014a0:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801014a3:	83 ec 0c             	sub    $0xc,%esp
801014a6:	ff 75 f4             	pushl  -0xc(%ebp)
801014a9:	e8 b5 25 00 00       	call   80103a63 <log_write>
801014ae:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801014b1:	83 ec 0c             	sub    $0xc,%esp
801014b4:	ff 75 f4             	pushl  -0xc(%ebp)
801014b7:	e8 72 ed ff ff       	call   8010022e <brelse>
801014bc:	83 c4 10             	add    $0x10,%esp
}
801014bf:	90                   	nop
801014c0:	c9                   	leave  
801014c1:	c3                   	ret    

801014c2 <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801014c2:	55                   	push   %ebp
801014c3:	89 e5                	mov    %esp,%ebp
801014c5:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
801014c8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801014cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801014d6:	e9 13 01 00 00       	jmp    801015ee <balloc+0x12c>
    bp = bread(dev, BBLOCK(b, sb));
801014db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014de:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801014e4:	85 c0                	test   %eax,%eax
801014e6:	0f 48 c2             	cmovs  %edx,%eax
801014e9:	c1 f8 0c             	sar    $0xc,%eax
801014ec:	89 c2                	mov    %eax,%edx
801014ee:	a1 78 22 11 80       	mov    0x80112278,%eax
801014f3:	01 d0                	add    %edx,%eax
801014f5:	83 ec 08             	sub    $0x8,%esp
801014f8:	50                   	push   %eax
801014f9:	ff 75 08             	pushl  0x8(%ebp)
801014fc:	e8 b5 ec ff ff       	call   801001b6 <bread>
80101501:	83 c4 10             	add    $0x10,%esp
80101504:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101507:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010150e:	e9 a6 00 00 00       	jmp    801015b9 <balloc+0xf7>
      m = 1 << (bi % 8);
80101513:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101516:	99                   	cltd   
80101517:	c1 ea 1d             	shr    $0x1d,%edx
8010151a:	01 d0                	add    %edx,%eax
8010151c:	83 e0 07             	and    $0x7,%eax
8010151f:	29 d0                	sub    %edx,%eax
80101521:	ba 01 00 00 00       	mov    $0x1,%edx
80101526:	89 c1                	mov    %eax,%ecx
80101528:	d3 e2                	shl    %cl,%edx
8010152a:	89 d0                	mov    %edx,%eax
8010152c:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010152f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101532:	8d 50 07             	lea    0x7(%eax),%edx
80101535:	85 c0                	test   %eax,%eax
80101537:	0f 48 c2             	cmovs  %edx,%eax
8010153a:	c1 f8 03             	sar    $0x3,%eax
8010153d:	89 c2                	mov    %eax,%edx
8010153f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101542:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
80101547:	0f b6 c0             	movzbl %al,%eax
8010154a:	23 45 e8             	and    -0x18(%ebp),%eax
8010154d:	85 c0                	test   %eax,%eax
8010154f:	75 64                	jne    801015b5 <balloc+0xf3>
        bp->data[bi/8] |= m;  // Mark block in use.
80101551:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101554:	8d 50 07             	lea    0x7(%eax),%edx
80101557:	85 c0                	test   %eax,%eax
80101559:	0f 48 c2             	cmovs  %edx,%eax
8010155c:	c1 f8 03             	sar    $0x3,%eax
8010155f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101562:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101567:	89 d1                	mov    %edx,%ecx
80101569:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010156c:	09 ca                	or     %ecx,%edx
8010156e:	89 d1                	mov    %edx,%ecx
80101570:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101573:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
80101577:	83 ec 0c             	sub    $0xc,%esp
8010157a:	ff 75 ec             	pushl  -0x14(%ebp)
8010157d:	e8 e1 24 00 00       	call   80103a63 <log_write>
80101582:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
80101585:	83 ec 0c             	sub    $0xc,%esp
80101588:	ff 75 ec             	pushl  -0x14(%ebp)
8010158b:	e8 9e ec ff ff       	call   8010022e <brelse>
80101590:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
80101593:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101596:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101599:	01 c2                	add    %eax,%edx
8010159b:	8b 45 08             	mov    0x8(%ebp),%eax
8010159e:	83 ec 08             	sub    $0x8,%esp
801015a1:	52                   	push   %edx
801015a2:	50                   	push   %eax
801015a3:	e8 c6 fe ff ff       	call   8010146e <bzero>
801015a8:	83 c4 10             	add    $0x10,%esp
        return b + bi;
801015ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015b1:	01 d0                	add    %edx,%eax
801015b3:	eb 57                	jmp    8010160c <balloc+0x14a>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801015b5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801015b9:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
801015c0:	7f 17                	jg     801015d9 <balloc+0x117>
801015c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015c8:	01 d0                	add    %edx,%eax
801015ca:	89 c2                	mov    %eax,%edx
801015cc:	a1 60 22 11 80       	mov    0x80112260,%eax
801015d1:	39 c2                	cmp    %eax,%edx
801015d3:	0f 82 3a ff ff ff    	jb     80101513 <balloc+0x51>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801015d9:	83 ec 0c             	sub    $0xc,%esp
801015dc:	ff 75 ec             	pushl  -0x14(%ebp)
801015df:	e8 4a ec ff ff       	call   8010022e <brelse>
801015e4:	83 c4 10             	add    $0x10,%esp
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801015e7:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801015ee:	8b 15 60 22 11 80    	mov    0x80112260,%edx
801015f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015f7:	39 c2                	cmp    %eax,%edx
801015f9:	0f 87 dc fe ff ff    	ja     801014db <balloc+0x19>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801015ff:	83 ec 0c             	sub    $0xc,%esp
80101602:	68 ac 8f 10 80       	push   $0x80108fac
80101607:	e8 5a ef ff ff       	call   80100566 <panic>
}
8010160c:	c9                   	leave  
8010160d:	c3                   	ret    

8010160e <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
8010160e:	55                   	push   %ebp
8010160f:	89 e5                	mov    %esp,%ebp
80101611:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
80101614:	83 ec 08             	sub    $0x8,%esp
80101617:	68 60 22 11 80       	push   $0x80112260
8010161c:	ff 75 08             	pushl  0x8(%ebp)
8010161f:	e8 08 fe ff ff       	call   8010142c <readsb>
80101624:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101627:	8b 45 0c             	mov    0xc(%ebp),%eax
8010162a:	c1 e8 0c             	shr    $0xc,%eax
8010162d:	89 c2                	mov    %eax,%edx
8010162f:	a1 78 22 11 80       	mov    0x80112278,%eax
80101634:	01 c2                	add    %eax,%edx
80101636:	8b 45 08             	mov    0x8(%ebp),%eax
80101639:	83 ec 08             	sub    $0x8,%esp
8010163c:	52                   	push   %edx
8010163d:	50                   	push   %eax
8010163e:	e8 73 eb ff ff       	call   801001b6 <bread>
80101643:	83 c4 10             	add    $0x10,%esp
80101646:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101649:	8b 45 0c             	mov    0xc(%ebp),%eax
8010164c:	25 ff 0f 00 00       	and    $0xfff,%eax
80101651:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
80101654:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101657:	99                   	cltd   
80101658:	c1 ea 1d             	shr    $0x1d,%edx
8010165b:	01 d0                	add    %edx,%eax
8010165d:	83 e0 07             	and    $0x7,%eax
80101660:	29 d0                	sub    %edx,%eax
80101662:	ba 01 00 00 00       	mov    $0x1,%edx
80101667:	89 c1                	mov    %eax,%ecx
80101669:	d3 e2                	shl    %cl,%edx
8010166b:	89 d0                	mov    %edx,%eax
8010166d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101670:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101673:	8d 50 07             	lea    0x7(%eax),%edx
80101676:	85 c0                	test   %eax,%eax
80101678:	0f 48 c2             	cmovs  %edx,%eax
8010167b:	c1 f8 03             	sar    $0x3,%eax
8010167e:	89 c2                	mov    %eax,%edx
80101680:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101683:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
80101688:	0f b6 c0             	movzbl %al,%eax
8010168b:	23 45 ec             	and    -0x14(%ebp),%eax
8010168e:	85 c0                	test   %eax,%eax
80101690:	75 0d                	jne    8010169f <bfree+0x91>
    panic("freeing free block");
80101692:	83 ec 0c             	sub    $0xc,%esp
80101695:	68 c2 8f 10 80       	push   $0x80108fc2
8010169a:	e8 c7 ee ff ff       	call   80100566 <panic>
  bp->data[bi/8] &= ~m;
8010169f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016a2:	8d 50 07             	lea    0x7(%eax),%edx
801016a5:	85 c0                	test   %eax,%eax
801016a7:	0f 48 c2             	cmovs  %edx,%eax
801016aa:	c1 f8 03             	sar    $0x3,%eax
801016ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016b0:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
801016b5:	89 d1                	mov    %edx,%ecx
801016b7:	8b 55 ec             	mov    -0x14(%ebp),%edx
801016ba:	f7 d2                	not    %edx
801016bc:	21 ca                	and    %ecx,%edx
801016be:	89 d1                	mov    %edx,%ecx
801016c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016c3:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
801016c7:	83 ec 0c             	sub    $0xc,%esp
801016ca:	ff 75 f4             	pushl  -0xc(%ebp)
801016cd:	e8 91 23 00 00       	call   80103a63 <log_write>
801016d2:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801016d5:	83 ec 0c             	sub    $0xc,%esp
801016d8:	ff 75 f4             	pushl  -0xc(%ebp)
801016db:	e8 4e eb ff ff       	call   8010022e <brelse>
801016e0:	83 c4 10             	add    $0x10,%esp
}
801016e3:	90                   	nop
801016e4:	c9                   	leave  
801016e5:	c3                   	ret    

801016e6 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
801016e6:	55                   	push   %ebp
801016e7:	89 e5                	mov    %esp,%ebp
801016e9:	57                   	push   %edi
801016ea:	56                   	push   %esi
801016eb:	53                   	push   %ebx
801016ec:	83 ec 1c             	sub    $0x1c,%esp
  initlock(&icache.lock, "icache");
801016ef:	83 ec 08             	sub    $0x8,%esp
801016f2:	68 d5 8f 10 80       	push   $0x80108fd5
801016f7:	68 80 22 11 80       	push   $0x80112280
801016fc:	e8 53 40 00 00       	call   80105754 <initlock>
80101701:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
80101704:	83 ec 08             	sub    $0x8,%esp
80101707:	68 60 22 11 80       	push   $0x80112260
8010170c:	ff 75 08             	pushl  0x8(%ebp)
8010170f:	e8 18 fd ff ff       	call   8010142c <readsb>
80101714:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d inodestart %d bmap start %d\n", sb.size,
80101717:	a1 78 22 11 80       	mov    0x80112278,%eax
8010171c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010171f:	8b 3d 74 22 11 80    	mov    0x80112274,%edi
80101725:	8b 35 70 22 11 80    	mov    0x80112270,%esi
8010172b:	8b 1d 6c 22 11 80    	mov    0x8011226c,%ebx
80101731:	8b 0d 68 22 11 80    	mov    0x80112268,%ecx
80101737:	8b 15 64 22 11 80    	mov    0x80112264,%edx
8010173d:	a1 60 22 11 80       	mov    0x80112260,%eax
80101742:	ff 75 e4             	pushl  -0x1c(%ebp)
80101745:	57                   	push   %edi
80101746:	56                   	push   %esi
80101747:	53                   	push   %ebx
80101748:	51                   	push   %ecx
80101749:	52                   	push   %edx
8010174a:	50                   	push   %eax
8010174b:	68 dc 8f 10 80       	push   $0x80108fdc
80101750:	e8 71 ec ff ff       	call   801003c6 <cprintf>
80101755:	83 c4 20             	add    $0x20,%esp
          sb.nblocks, sb.ninodes, sb.nlog, sb.logstart, sb.inodestart, sb.bmapstart);
}
80101758:	90                   	nop
80101759:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010175c:	5b                   	pop    %ebx
8010175d:	5e                   	pop    %esi
8010175e:	5f                   	pop    %edi
8010175f:	5d                   	pop    %ebp
80101760:	c3                   	ret    

80101761 <ialloc>:

// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101761:	55                   	push   %ebp
80101762:	89 e5                	mov    %esp,%ebp
80101764:	83 ec 28             	sub    $0x28,%esp
80101767:	8b 45 0c             	mov    0xc(%ebp),%eax
8010176a:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010176e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80101775:	e9 ba 00 00 00       	jmp    80101834 <ialloc+0xd3>
    bp = bread(dev, IBLOCK(inum, sb));
8010177a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010177d:	c1 e8 03             	shr    $0x3,%eax
80101780:	89 c2                	mov    %eax,%edx
80101782:	a1 74 22 11 80       	mov    0x80112274,%eax
80101787:	01 d0                	add    %edx,%eax
80101789:	83 ec 08             	sub    $0x8,%esp
8010178c:	50                   	push   %eax
8010178d:	ff 75 08             	pushl  0x8(%ebp)
80101790:	e8 21 ea ff ff       	call   801001b6 <bread>
80101795:	83 c4 10             	add    $0x10,%esp
80101798:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
8010179b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010179e:	8d 50 18             	lea    0x18(%eax),%edx
801017a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017a4:	83 e0 07             	and    $0x7,%eax
801017a7:	c1 e0 06             	shl    $0x6,%eax
801017aa:	01 d0                	add    %edx,%eax
801017ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
801017af:	8b 45 ec             	mov    -0x14(%ebp),%eax
801017b2:	0f b7 00             	movzwl (%eax),%eax
801017b5:	66 85 c0             	test   %ax,%ax
801017b8:	75 68                	jne    80101822 <ialloc+0xc1>
      memset(dip, 0, sizeof(*dip));
801017ba:	83 ec 04             	sub    $0x4,%esp
801017bd:	6a 40                	push   $0x40
801017bf:	6a 00                	push   $0x0
801017c1:	ff 75 ec             	pushl  -0x14(%ebp)
801017c4:	e8 10 42 00 00       	call   801059d9 <memset>
801017c9:	83 c4 10             	add    $0x10,%esp
      #ifdef CS333_P5
      dip->uid = DEFAULTUID;
801017cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801017cf:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
      dip->gid = DEFAULTGID;
801017d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801017d8:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
      dip->mode.asInt = DEFAULTMODE;
801017de:	8b 45 ec             	mov    -0x14(%ebp),%eax
801017e1:	c7 40 0c ed 01 00 00 	movl   $0x1ed,0xc(%eax)
      #endif
      dip->type = type;
801017e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801017eb:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
801017ef:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
801017f2:	83 ec 0c             	sub    $0xc,%esp
801017f5:	ff 75 f0             	pushl  -0x10(%ebp)
801017f8:	e8 66 22 00 00       	call   80103a63 <log_write>
801017fd:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
80101800:	83 ec 0c             	sub    $0xc,%esp
80101803:	ff 75 f0             	pushl  -0x10(%ebp)
80101806:	e8 23 ea ff ff       	call   8010022e <brelse>
8010180b:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
8010180e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101811:	83 ec 08             	sub    $0x8,%esp
80101814:	50                   	push   %eax
80101815:	ff 75 08             	pushl  0x8(%ebp)
80101818:	e8 20 01 00 00       	call   8010193d <iget>
8010181d:	83 c4 10             	add    $0x10,%esp
80101820:	eb 30                	jmp    80101852 <ialloc+0xf1>
    }
    brelse(bp);
80101822:	83 ec 0c             	sub    $0xc,%esp
80101825:	ff 75 f0             	pushl  -0x10(%ebp)
80101828:	e8 01 ea ff ff       	call   8010022e <brelse>
8010182d:	83 c4 10             	add    $0x10,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101830:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101834:	8b 15 68 22 11 80    	mov    0x80112268,%edx
8010183a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010183d:	39 c2                	cmp    %eax,%edx
8010183f:	0f 87 35 ff ff ff    	ja     8010177a <ialloc+0x19>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101845:	83 ec 0c             	sub    $0xc,%esp
80101848:	68 2f 90 10 80       	push   $0x8010902f
8010184d:	e8 14 ed ff ff       	call   80100566 <panic>
}
80101852:	c9                   	leave  
80101853:	c3                   	ret    

80101854 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
80101854:	55                   	push   %ebp
80101855:	89 e5                	mov    %esp,%ebp
80101857:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010185a:	8b 45 08             	mov    0x8(%ebp),%eax
8010185d:	8b 40 04             	mov    0x4(%eax),%eax
80101860:	c1 e8 03             	shr    $0x3,%eax
80101863:	89 c2                	mov    %eax,%edx
80101865:	a1 74 22 11 80       	mov    0x80112274,%eax
8010186a:	01 c2                	add    %eax,%edx
8010186c:	8b 45 08             	mov    0x8(%ebp),%eax
8010186f:	8b 00                	mov    (%eax),%eax
80101871:	83 ec 08             	sub    $0x8,%esp
80101874:	52                   	push   %edx
80101875:	50                   	push   %eax
80101876:	e8 3b e9 ff ff       	call   801001b6 <bread>
8010187b:	83 c4 10             	add    $0x10,%esp
8010187e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101881:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101884:	8d 50 18             	lea    0x18(%eax),%edx
80101887:	8b 45 08             	mov    0x8(%ebp),%eax
8010188a:	8b 40 04             	mov    0x4(%eax),%eax
8010188d:	83 e0 07             	and    $0x7,%eax
80101890:	c1 e0 06             	shl    $0x6,%eax
80101893:	01 d0                	add    %edx,%eax
80101895:	89 45 f0             	mov    %eax,-0x10(%ebp)
  #ifdef CS333_P5
  dip->uid = ip->uid;
80101898:	8b 45 08             	mov    0x8(%ebp),%eax
8010189b:	0f b7 50 18          	movzwl 0x18(%eax),%edx
8010189f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018a2:	66 89 50 08          	mov    %dx,0x8(%eax)
  dip->gid = ip->gid;
801018a6:	8b 45 08             	mov    0x8(%ebp),%eax
801018a9:	0f b7 50 1a          	movzwl 0x1a(%eax),%edx
801018ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018b0:	66 89 50 0a          	mov    %dx,0xa(%eax)
  dip->mode.asInt = ip->mode.asInt;
801018b4:	8b 45 08             	mov    0x8(%ebp),%eax
801018b7:	8b 50 1c             	mov    0x1c(%eax),%edx
801018ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018bd:	89 50 0c             	mov    %edx,0xc(%eax)
  #endif
  dip->type = ip->type;
801018c0:	8b 45 08             	mov    0x8(%ebp),%eax
801018c3:	0f b7 50 10          	movzwl 0x10(%eax),%edx
801018c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018ca:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801018cd:	8b 45 08             	mov    0x8(%ebp),%eax
801018d0:	0f b7 50 12          	movzwl 0x12(%eax),%edx
801018d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018d7:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
801018db:	8b 45 08             	mov    0x8(%ebp),%eax
801018de:	0f b7 50 14          	movzwl 0x14(%eax),%edx
801018e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018e5:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
801018e9:	8b 45 08             	mov    0x8(%ebp),%eax
801018ec:	0f b7 50 16          	movzwl 0x16(%eax),%edx
801018f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018f3:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801018f7:	8b 45 08             	mov    0x8(%ebp),%eax
801018fa:	8b 50 20             	mov    0x20(%eax),%edx
801018fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101900:	89 50 10             	mov    %edx,0x10(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101903:	8b 45 08             	mov    0x8(%ebp),%eax
80101906:	8d 50 24             	lea    0x24(%eax),%edx
80101909:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010190c:	83 c0 14             	add    $0x14,%eax
8010190f:	83 ec 04             	sub    $0x4,%esp
80101912:	6a 2c                	push   $0x2c
80101914:	52                   	push   %edx
80101915:	50                   	push   %eax
80101916:	e8 7d 41 00 00       	call   80105a98 <memmove>
8010191b:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
8010191e:	83 ec 0c             	sub    $0xc,%esp
80101921:	ff 75 f4             	pushl  -0xc(%ebp)
80101924:	e8 3a 21 00 00       	call   80103a63 <log_write>
80101929:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010192c:	83 ec 0c             	sub    $0xc,%esp
8010192f:	ff 75 f4             	pushl  -0xc(%ebp)
80101932:	e8 f7 e8 ff ff       	call   8010022e <brelse>
80101937:	83 c4 10             	add    $0x10,%esp
}
8010193a:	90                   	nop
8010193b:	c9                   	leave  
8010193c:	c3                   	ret    

8010193d <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010193d:	55                   	push   %ebp
8010193e:	89 e5                	mov    %esp,%ebp
80101940:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101943:	83 ec 0c             	sub    $0xc,%esp
80101946:	68 80 22 11 80       	push   $0x80112280
8010194b:	e8 26 3e 00 00       	call   80105776 <acquire>
80101950:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
80101953:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010195a:	c7 45 f4 b4 22 11 80 	movl   $0x801122b4,-0xc(%ebp)
80101961:	eb 5d                	jmp    801019c0 <iget+0x83>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101963:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101966:	8b 40 08             	mov    0x8(%eax),%eax
80101969:	85 c0                	test   %eax,%eax
8010196b:	7e 39                	jle    801019a6 <iget+0x69>
8010196d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101970:	8b 00                	mov    (%eax),%eax
80101972:	3b 45 08             	cmp    0x8(%ebp),%eax
80101975:	75 2f                	jne    801019a6 <iget+0x69>
80101977:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010197a:	8b 40 04             	mov    0x4(%eax),%eax
8010197d:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101980:	75 24                	jne    801019a6 <iget+0x69>
      ip->ref++;
80101982:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101985:	8b 40 08             	mov    0x8(%eax),%eax
80101988:	8d 50 01             	lea    0x1(%eax),%edx
8010198b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010198e:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101991:	83 ec 0c             	sub    $0xc,%esp
80101994:	68 80 22 11 80       	push   $0x80112280
80101999:	e8 3f 3e 00 00       	call   801057dd <release>
8010199e:	83 c4 10             	add    $0x10,%esp
      return ip;
801019a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019a4:	eb 74                	jmp    80101a1a <iget+0xdd>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801019a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801019aa:	75 10                	jne    801019bc <iget+0x7f>
801019ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019af:	8b 40 08             	mov    0x8(%eax),%eax
801019b2:	85 c0                	test   %eax,%eax
801019b4:	75 06                	jne    801019bc <iget+0x7f>
      empty = ip;
801019b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019b9:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801019bc:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
801019c0:	81 7d f4 54 32 11 80 	cmpl   $0x80113254,-0xc(%ebp)
801019c7:	72 9a                	jb     80101963 <iget+0x26>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801019c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801019cd:	75 0d                	jne    801019dc <iget+0x9f>
    panic("iget: no inodes");
801019cf:	83 ec 0c             	sub    $0xc,%esp
801019d2:	68 41 90 10 80       	push   $0x80109041
801019d7:	e8 8a eb ff ff       	call   80100566 <panic>

  ip = empty;
801019dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
801019e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019e5:	8b 55 08             	mov    0x8(%ebp),%edx
801019e8:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
801019ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019ed:	8b 55 0c             	mov    0xc(%ebp),%edx
801019f0:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
801019f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019f6:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
801019fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a00:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
80101a07:	83 ec 0c             	sub    $0xc,%esp
80101a0a:	68 80 22 11 80       	push   $0x80112280
80101a0f:	e8 c9 3d 00 00       	call   801057dd <release>
80101a14:	83 c4 10             	add    $0x10,%esp

  return ip;
80101a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101a1a:	c9                   	leave  
80101a1b:	c3                   	ret    

80101a1c <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101a1c:	55                   	push   %ebp
80101a1d:	89 e5                	mov    %esp,%ebp
80101a1f:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101a22:	83 ec 0c             	sub    $0xc,%esp
80101a25:	68 80 22 11 80       	push   $0x80112280
80101a2a:	e8 47 3d 00 00       	call   80105776 <acquire>
80101a2f:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
80101a32:	8b 45 08             	mov    0x8(%ebp),%eax
80101a35:	8b 40 08             	mov    0x8(%eax),%eax
80101a38:	8d 50 01             	lea    0x1(%eax),%edx
80101a3b:	8b 45 08             	mov    0x8(%ebp),%eax
80101a3e:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101a41:	83 ec 0c             	sub    $0xc,%esp
80101a44:	68 80 22 11 80       	push   $0x80112280
80101a49:	e8 8f 3d 00 00       	call   801057dd <release>
80101a4e:	83 c4 10             	add    $0x10,%esp
  return ip;
80101a51:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101a54:	c9                   	leave  
80101a55:	c3                   	ret    

80101a56 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101a56:	55                   	push   %ebp
80101a57:	89 e5                	mov    %esp,%ebp
80101a59:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101a5c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a60:	74 0a                	je     80101a6c <ilock+0x16>
80101a62:	8b 45 08             	mov    0x8(%ebp),%eax
80101a65:	8b 40 08             	mov    0x8(%eax),%eax
80101a68:	85 c0                	test   %eax,%eax
80101a6a:	7f 0d                	jg     80101a79 <ilock+0x23>
    panic("ilock");
80101a6c:	83 ec 0c             	sub    $0xc,%esp
80101a6f:	68 51 90 10 80       	push   $0x80109051
80101a74:	e8 ed ea ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101a79:	83 ec 0c             	sub    $0xc,%esp
80101a7c:	68 80 22 11 80       	push   $0x80112280
80101a81:	e8 f0 3c 00 00       	call   80105776 <acquire>
80101a86:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
80101a89:	eb 13                	jmp    80101a9e <ilock+0x48>
    sleep(ip, &icache.lock);
80101a8b:	83 ec 08             	sub    $0x8,%esp
80101a8e:	68 80 22 11 80       	push   $0x80112280
80101a93:	ff 75 08             	pushl  0x8(%ebp)
80101a96:	e8 36 36 00 00       	call   801050d1 <sleep>
80101a9b:	83 c4 10             	add    $0x10,%esp

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
80101a9e:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa1:	8b 40 0c             	mov    0xc(%eax),%eax
80101aa4:	83 e0 01             	and    $0x1,%eax
80101aa7:	85 c0                	test   %eax,%eax
80101aa9:	75 e0                	jne    80101a8b <ilock+0x35>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
80101aab:	8b 45 08             	mov    0x8(%ebp),%eax
80101aae:	8b 40 0c             	mov    0xc(%eax),%eax
80101ab1:	83 c8 01             	or     $0x1,%eax
80101ab4:	89 c2                	mov    %eax,%edx
80101ab6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab9:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
80101abc:	83 ec 0c             	sub    $0xc,%esp
80101abf:	68 80 22 11 80       	push   $0x80112280
80101ac4:	e8 14 3d 00 00       	call   801057dd <release>
80101ac9:	83 c4 10             	add    $0x10,%esp

  if(!(ip->flags & I_VALID)){
80101acc:	8b 45 08             	mov    0x8(%ebp),%eax
80101acf:	8b 40 0c             	mov    0xc(%eax),%eax
80101ad2:	83 e0 02             	and    $0x2,%eax
80101ad5:	85 c0                	test   %eax,%eax
80101ad7:	0f 85 fc 00 00 00    	jne    80101bd9 <ilock+0x183>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101add:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae0:	8b 40 04             	mov    0x4(%eax),%eax
80101ae3:	c1 e8 03             	shr    $0x3,%eax
80101ae6:	89 c2                	mov    %eax,%edx
80101ae8:	a1 74 22 11 80       	mov    0x80112274,%eax
80101aed:	01 c2                	add    %eax,%edx
80101aef:	8b 45 08             	mov    0x8(%ebp),%eax
80101af2:	8b 00                	mov    (%eax),%eax
80101af4:	83 ec 08             	sub    $0x8,%esp
80101af7:	52                   	push   %edx
80101af8:	50                   	push   %eax
80101af9:	e8 b8 e6 ff ff       	call   801001b6 <bread>
80101afe:	83 c4 10             	add    $0x10,%esp
80101b01:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b07:	8d 50 18             	lea    0x18(%eax),%edx
80101b0a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0d:	8b 40 04             	mov    0x4(%eax),%eax
80101b10:	83 e0 07             	and    $0x7,%eax
80101b13:	c1 e0 06             	shl    $0x6,%eax
80101b16:	01 d0                	add    %edx,%eax
80101b18:	89 45 f0             	mov    %eax,-0x10(%ebp)
    #ifdef CS333_P5
    ip->uid = dip->uid;
80101b1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b1e:	0f b7 50 08          	movzwl 0x8(%eax),%edx
80101b22:	8b 45 08             	mov    0x8(%ebp),%eax
80101b25:	66 89 50 18          	mov    %dx,0x18(%eax)
    ip->gid = dip->gid;
80101b29:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b2c:	0f b7 50 0a          	movzwl 0xa(%eax),%edx
80101b30:	8b 45 08             	mov    0x8(%ebp),%eax
80101b33:	66 89 50 1a          	mov    %dx,0x1a(%eax)
    ip->mode.asInt = dip->mode.asInt;
80101b37:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b3a:	8b 50 0c             	mov    0xc(%eax),%edx
80101b3d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b40:	89 50 1c             	mov    %edx,0x1c(%eax)
    #endif
    ip->type = dip->type;
80101b43:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b46:	0f b7 10             	movzwl (%eax),%edx
80101b49:	8b 45 08             	mov    0x8(%ebp),%eax
80101b4c:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
80101b50:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b53:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101b57:	8b 45 08             	mov    0x8(%ebp),%eax
80101b5a:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
80101b5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b61:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101b65:	8b 45 08             	mov    0x8(%ebp),%eax
80101b68:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80101b6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b6f:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101b73:	8b 45 08             	mov    0x8(%ebp),%eax
80101b76:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101b7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b7d:	8b 50 10             	mov    0x10(%eax),%edx
80101b80:	8b 45 08             	mov    0x8(%ebp),%eax
80101b83:	89 50 20             	mov    %edx,0x20(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101b86:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b89:	8d 50 14             	lea    0x14(%eax),%edx
80101b8c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8f:	83 c0 24             	add    $0x24,%eax
80101b92:	83 ec 04             	sub    $0x4,%esp
80101b95:	6a 2c                	push   $0x2c
80101b97:	52                   	push   %edx
80101b98:	50                   	push   %eax
80101b99:	e8 fa 3e 00 00       	call   80105a98 <memmove>
80101b9e:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101ba1:	83 ec 0c             	sub    $0xc,%esp
80101ba4:	ff 75 f4             	pushl  -0xc(%ebp)
80101ba7:	e8 82 e6 ff ff       	call   8010022e <brelse>
80101bac:	83 c4 10             	add    $0x10,%esp
    ip->flags |= I_VALID;
80101baf:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb2:	8b 40 0c             	mov    0xc(%eax),%eax
80101bb5:	83 c8 02             	or     $0x2,%eax
80101bb8:	89 c2                	mov    %eax,%edx
80101bba:	8b 45 08             	mov    0x8(%ebp),%eax
80101bbd:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101bc0:	8b 45 08             	mov    0x8(%ebp),%eax
80101bc3:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101bc7:	66 85 c0             	test   %ax,%ax
80101bca:	75 0d                	jne    80101bd9 <ilock+0x183>
      panic("ilock: no type");
80101bcc:	83 ec 0c             	sub    $0xc,%esp
80101bcf:	68 57 90 10 80       	push   $0x80109057
80101bd4:	e8 8d e9 ff ff       	call   80100566 <panic>
  }
}
80101bd9:	90                   	nop
80101bda:	c9                   	leave  
80101bdb:	c3                   	ret    

80101bdc <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101bdc:	55                   	push   %ebp
80101bdd:	89 e5                	mov    %esp,%ebp
80101bdf:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101be2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101be6:	74 17                	je     80101bff <iunlock+0x23>
80101be8:	8b 45 08             	mov    0x8(%ebp),%eax
80101beb:	8b 40 0c             	mov    0xc(%eax),%eax
80101bee:	83 e0 01             	and    $0x1,%eax
80101bf1:	85 c0                	test   %eax,%eax
80101bf3:	74 0a                	je     80101bff <iunlock+0x23>
80101bf5:	8b 45 08             	mov    0x8(%ebp),%eax
80101bf8:	8b 40 08             	mov    0x8(%eax),%eax
80101bfb:	85 c0                	test   %eax,%eax
80101bfd:	7f 0d                	jg     80101c0c <iunlock+0x30>
    panic("iunlock");
80101bff:	83 ec 0c             	sub    $0xc,%esp
80101c02:	68 66 90 10 80       	push   $0x80109066
80101c07:	e8 5a e9 ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101c0c:	83 ec 0c             	sub    $0xc,%esp
80101c0f:	68 80 22 11 80       	push   $0x80112280
80101c14:	e8 5d 3b 00 00       	call   80105776 <acquire>
80101c19:	83 c4 10             	add    $0x10,%esp
  ip->flags &= ~I_BUSY;
80101c1c:	8b 45 08             	mov    0x8(%ebp),%eax
80101c1f:	8b 40 0c             	mov    0xc(%eax),%eax
80101c22:	83 e0 fe             	and    $0xfffffffe,%eax
80101c25:	89 c2                	mov    %eax,%edx
80101c27:	8b 45 08             	mov    0x8(%ebp),%eax
80101c2a:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101c2d:	83 ec 0c             	sub    $0xc,%esp
80101c30:	ff 75 08             	pushl  0x8(%ebp)
80101c33:	e8 80 35 00 00       	call   801051b8 <wakeup>
80101c38:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101c3b:	83 ec 0c             	sub    $0xc,%esp
80101c3e:	68 80 22 11 80       	push   $0x80112280
80101c43:	e8 95 3b 00 00       	call   801057dd <release>
80101c48:	83 c4 10             	add    $0x10,%esp
}
80101c4b:	90                   	nop
80101c4c:	c9                   	leave  
80101c4d:	c3                   	ret    

80101c4e <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101c4e:	55                   	push   %ebp
80101c4f:	89 e5                	mov    %esp,%ebp
80101c51:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101c54:	83 ec 0c             	sub    $0xc,%esp
80101c57:	68 80 22 11 80       	push   $0x80112280
80101c5c:	e8 15 3b 00 00       	call   80105776 <acquire>
80101c61:	83 c4 10             	add    $0x10,%esp
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101c64:	8b 45 08             	mov    0x8(%ebp),%eax
80101c67:	8b 40 08             	mov    0x8(%eax),%eax
80101c6a:	83 f8 01             	cmp    $0x1,%eax
80101c6d:	0f 85 a9 00 00 00    	jne    80101d1c <iput+0xce>
80101c73:	8b 45 08             	mov    0x8(%ebp),%eax
80101c76:	8b 40 0c             	mov    0xc(%eax),%eax
80101c79:	83 e0 02             	and    $0x2,%eax
80101c7c:	85 c0                	test   %eax,%eax
80101c7e:	0f 84 98 00 00 00    	je     80101d1c <iput+0xce>
80101c84:	8b 45 08             	mov    0x8(%ebp),%eax
80101c87:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101c8b:	66 85 c0             	test   %ax,%ax
80101c8e:	0f 85 88 00 00 00    	jne    80101d1c <iput+0xce>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101c94:	8b 45 08             	mov    0x8(%ebp),%eax
80101c97:	8b 40 0c             	mov    0xc(%eax),%eax
80101c9a:	83 e0 01             	and    $0x1,%eax
80101c9d:	85 c0                	test   %eax,%eax
80101c9f:	74 0d                	je     80101cae <iput+0x60>
      panic("iput busy");
80101ca1:	83 ec 0c             	sub    $0xc,%esp
80101ca4:	68 6e 90 10 80       	push   $0x8010906e
80101ca9:	e8 b8 e8 ff ff       	call   80100566 <panic>
    ip->flags |= I_BUSY;
80101cae:	8b 45 08             	mov    0x8(%ebp),%eax
80101cb1:	8b 40 0c             	mov    0xc(%eax),%eax
80101cb4:	83 c8 01             	or     $0x1,%eax
80101cb7:	89 c2                	mov    %eax,%edx
80101cb9:	8b 45 08             	mov    0x8(%ebp),%eax
80101cbc:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101cbf:	83 ec 0c             	sub    $0xc,%esp
80101cc2:	68 80 22 11 80       	push   $0x80112280
80101cc7:	e8 11 3b 00 00       	call   801057dd <release>
80101ccc:	83 c4 10             	add    $0x10,%esp
    itrunc(ip);
80101ccf:	83 ec 0c             	sub    $0xc,%esp
80101cd2:	ff 75 08             	pushl  0x8(%ebp)
80101cd5:	e8 a8 01 00 00       	call   80101e82 <itrunc>
80101cda:	83 c4 10             	add    $0x10,%esp
    ip->type = 0;
80101cdd:	8b 45 08             	mov    0x8(%ebp),%eax
80101ce0:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101ce6:	83 ec 0c             	sub    $0xc,%esp
80101ce9:	ff 75 08             	pushl  0x8(%ebp)
80101cec:	e8 63 fb ff ff       	call   80101854 <iupdate>
80101cf1:	83 c4 10             	add    $0x10,%esp
    acquire(&icache.lock);
80101cf4:	83 ec 0c             	sub    $0xc,%esp
80101cf7:	68 80 22 11 80       	push   $0x80112280
80101cfc:	e8 75 3a 00 00       	call   80105776 <acquire>
80101d01:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101d04:	8b 45 08             	mov    0x8(%ebp),%eax
80101d07:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101d0e:	83 ec 0c             	sub    $0xc,%esp
80101d11:	ff 75 08             	pushl  0x8(%ebp)
80101d14:	e8 9f 34 00 00       	call   801051b8 <wakeup>
80101d19:	83 c4 10             	add    $0x10,%esp
  }
  ip->ref--;
80101d1c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d1f:	8b 40 08             	mov    0x8(%eax),%eax
80101d22:	8d 50 ff             	lea    -0x1(%eax),%edx
80101d25:	8b 45 08             	mov    0x8(%ebp),%eax
80101d28:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101d2b:	83 ec 0c             	sub    $0xc,%esp
80101d2e:	68 80 22 11 80       	push   $0x80112280
80101d33:	e8 a5 3a 00 00       	call   801057dd <release>
80101d38:	83 c4 10             	add    $0x10,%esp
}
80101d3b:	90                   	nop
80101d3c:	c9                   	leave  
80101d3d:	c3                   	ret    

80101d3e <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101d3e:	55                   	push   %ebp
80101d3f:	89 e5                	mov    %esp,%ebp
80101d41:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101d44:	83 ec 0c             	sub    $0xc,%esp
80101d47:	ff 75 08             	pushl  0x8(%ebp)
80101d4a:	e8 8d fe ff ff       	call   80101bdc <iunlock>
80101d4f:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101d52:	83 ec 0c             	sub    $0xc,%esp
80101d55:	ff 75 08             	pushl  0x8(%ebp)
80101d58:	e8 f1 fe ff ff       	call   80101c4e <iput>
80101d5d:	83 c4 10             	add    $0x10,%esp
}
80101d60:	90                   	nop
80101d61:	c9                   	leave  
80101d62:	c3                   	ret    

80101d63 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101d63:	55                   	push   %ebp
80101d64:	89 e5                	mov    %esp,%ebp
80101d66:	53                   	push   %ebx
80101d67:	83 ec 14             	sub    $0x14,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101d6a:	83 7d 0c 09          	cmpl   $0x9,0xc(%ebp)
80101d6e:	77 42                	ja     80101db2 <bmap+0x4f>
    if((addr = ip->addrs[bn]) == 0)
80101d70:	8b 45 08             	mov    0x8(%ebp),%eax
80101d73:	8b 55 0c             	mov    0xc(%ebp),%edx
80101d76:	83 c2 08             	add    $0x8,%edx
80101d79:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80101d7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d84:	75 24                	jne    80101daa <bmap+0x47>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101d86:	8b 45 08             	mov    0x8(%ebp),%eax
80101d89:	8b 00                	mov    (%eax),%eax
80101d8b:	83 ec 0c             	sub    $0xc,%esp
80101d8e:	50                   	push   %eax
80101d8f:	e8 2e f7 ff ff       	call   801014c2 <balloc>
80101d94:	83 c4 10             	add    $0x10,%esp
80101d97:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d9a:	8b 45 08             	mov    0x8(%ebp),%eax
80101d9d:	8b 55 0c             	mov    0xc(%ebp),%edx
80101da0:	8d 4a 08             	lea    0x8(%edx),%ecx
80101da3:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101da6:	89 54 88 04          	mov    %edx,0x4(%eax,%ecx,4)
    return addr;
80101daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101dad:	e9 cb 00 00 00       	jmp    80101e7d <bmap+0x11a>
  }
  bn -= NDIRECT;
80101db2:	83 6d 0c 0a          	subl   $0xa,0xc(%ebp)

  if(bn < NINDIRECT){
80101db6:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101dba:	0f 87 b0 00 00 00    	ja     80101e70 <bmap+0x10d>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101dc0:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc3:	8b 40 4c             	mov    0x4c(%eax),%eax
80101dc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101dc9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101dcd:	75 1d                	jne    80101dec <bmap+0x89>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101dcf:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd2:	8b 00                	mov    (%eax),%eax
80101dd4:	83 ec 0c             	sub    $0xc,%esp
80101dd7:	50                   	push   %eax
80101dd8:	e8 e5 f6 ff ff       	call   801014c2 <balloc>
80101ddd:	83 c4 10             	add    $0x10,%esp
80101de0:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101de3:	8b 45 08             	mov    0x8(%ebp),%eax
80101de6:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101de9:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101dec:	8b 45 08             	mov    0x8(%ebp),%eax
80101def:	8b 00                	mov    (%eax),%eax
80101df1:	83 ec 08             	sub    $0x8,%esp
80101df4:	ff 75 f4             	pushl  -0xc(%ebp)
80101df7:	50                   	push   %eax
80101df8:	e8 b9 e3 ff ff       	call   801001b6 <bread>
80101dfd:	83 c4 10             	add    $0x10,%esp
80101e00:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101e03:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e06:	83 c0 18             	add    $0x18,%eax
80101e09:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101e0c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e0f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e16:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e19:	01 d0                	add    %edx,%eax
80101e1b:	8b 00                	mov    (%eax),%eax
80101e1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101e20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101e24:	75 37                	jne    80101e5d <bmap+0xfa>
      a[bn] = addr = balloc(ip->dev);
80101e26:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e29:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e30:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e33:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101e36:	8b 45 08             	mov    0x8(%ebp),%eax
80101e39:	8b 00                	mov    (%eax),%eax
80101e3b:	83 ec 0c             	sub    $0xc,%esp
80101e3e:	50                   	push   %eax
80101e3f:	e8 7e f6 ff ff       	call   801014c2 <balloc>
80101e44:	83 c4 10             	add    $0x10,%esp
80101e47:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e4d:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101e4f:	83 ec 0c             	sub    $0xc,%esp
80101e52:	ff 75 f0             	pushl  -0x10(%ebp)
80101e55:	e8 09 1c 00 00       	call   80103a63 <log_write>
80101e5a:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101e5d:	83 ec 0c             	sub    $0xc,%esp
80101e60:	ff 75 f0             	pushl  -0x10(%ebp)
80101e63:	e8 c6 e3 ff ff       	call   8010022e <brelse>
80101e68:	83 c4 10             	add    $0x10,%esp
    return addr;
80101e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e6e:	eb 0d                	jmp    80101e7d <bmap+0x11a>
  }

  panic("bmap: out of range");
80101e70:	83 ec 0c             	sub    $0xc,%esp
80101e73:	68 78 90 10 80       	push   $0x80109078
80101e78:	e8 e9 e6 ff ff       	call   80100566 <panic>
}
80101e7d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101e80:	c9                   	leave  
80101e81:	c3                   	ret    

80101e82 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101e82:	55                   	push   %ebp
80101e83:	89 e5                	mov    %esp,%ebp
80101e85:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101e88:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101e8f:	eb 45                	jmp    80101ed6 <itrunc+0x54>
    if(ip->addrs[i]){
80101e91:	8b 45 08             	mov    0x8(%ebp),%eax
80101e94:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e97:	83 c2 08             	add    $0x8,%edx
80101e9a:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80101e9e:	85 c0                	test   %eax,%eax
80101ea0:	74 30                	je     80101ed2 <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101ea2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ea5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101ea8:	83 c2 08             	add    $0x8,%edx
80101eab:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80101eaf:	8b 55 08             	mov    0x8(%ebp),%edx
80101eb2:	8b 12                	mov    (%edx),%edx
80101eb4:	83 ec 08             	sub    $0x8,%esp
80101eb7:	50                   	push   %eax
80101eb8:	52                   	push   %edx
80101eb9:	e8 50 f7 ff ff       	call   8010160e <bfree>
80101ebe:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101ec1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ec4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101ec7:	83 c2 08             	add    $0x8,%edx
80101eca:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
80101ed1:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101ed2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101ed6:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80101eda:	7e b5                	jle    80101e91 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101edc:	8b 45 08             	mov    0x8(%ebp),%eax
80101edf:	8b 40 4c             	mov    0x4c(%eax),%eax
80101ee2:	85 c0                	test   %eax,%eax
80101ee4:	0f 84 a1 00 00 00    	je     80101f8b <itrunc+0x109>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101eea:	8b 45 08             	mov    0x8(%ebp),%eax
80101eed:	8b 50 4c             	mov    0x4c(%eax),%edx
80101ef0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ef3:	8b 00                	mov    (%eax),%eax
80101ef5:	83 ec 08             	sub    $0x8,%esp
80101ef8:	52                   	push   %edx
80101ef9:	50                   	push   %eax
80101efa:	e8 b7 e2 ff ff       	call   801001b6 <bread>
80101eff:	83 c4 10             	add    $0x10,%esp
80101f02:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101f05:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f08:	83 c0 18             	add    $0x18,%eax
80101f0b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101f0e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101f15:	eb 3c                	jmp    80101f53 <itrunc+0xd1>
      if(a[j])
80101f17:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f1a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101f21:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101f24:	01 d0                	add    %edx,%eax
80101f26:	8b 00                	mov    (%eax),%eax
80101f28:	85 c0                	test   %eax,%eax
80101f2a:	74 23                	je     80101f4f <itrunc+0xcd>
        bfree(ip->dev, a[j]);
80101f2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f2f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101f36:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101f39:	01 d0                	add    %edx,%eax
80101f3b:	8b 00                	mov    (%eax),%eax
80101f3d:	8b 55 08             	mov    0x8(%ebp),%edx
80101f40:	8b 12                	mov    (%edx),%edx
80101f42:	83 ec 08             	sub    $0x8,%esp
80101f45:	50                   	push   %eax
80101f46:	52                   	push   %edx
80101f47:	e8 c2 f6 ff ff       	call   8010160e <bfree>
80101f4c:	83 c4 10             	add    $0x10,%esp
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101f4f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101f53:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f56:	83 f8 7f             	cmp    $0x7f,%eax
80101f59:	76 bc                	jbe    80101f17 <itrunc+0x95>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101f5b:	83 ec 0c             	sub    $0xc,%esp
80101f5e:	ff 75 ec             	pushl  -0x14(%ebp)
80101f61:	e8 c8 e2 ff ff       	call   8010022e <brelse>
80101f66:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101f69:	8b 45 08             	mov    0x8(%ebp),%eax
80101f6c:	8b 40 4c             	mov    0x4c(%eax),%eax
80101f6f:	8b 55 08             	mov    0x8(%ebp),%edx
80101f72:	8b 12                	mov    (%edx),%edx
80101f74:	83 ec 08             	sub    $0x8,%esp
80101f77:	50                   	push   %eax
80101f78:	52                   	push   %edx
80101f79:	e8 90 f6 ff ff       	call   8010160e <bfree>
80101f7e:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101f81:	8b 45 08             	mov    0x8(%ebp),%eax
80101f84:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101f8b:	8b 45 08             	mov    0x8(%ebp),%eax
80101f8e:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
  iupdate(ip);
80101f95:	83 ec 0c             	sub    $0xc,%esp
80101f98:	ff 75 08             	pushl  0x8(%ebp)
80101f9b:	e8 b4 f8 ff ff       	call   80101854 <iupdate>
80101fa0:	83 c4 10             	add    $0x10,%esp
}
80101fa3:	90                   	nop
80101fa4:	c9                   	leave  
80101fa5:	c3                   	ret    

80101fa6 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101fa6:	55                   	push   %ebp
80101fa7:	89 e5                	mov    %esp,%ebp
  #ifdef CS333_P5
  st->uid = ip->uid;
80101fa9:	8b 45 08             	mov    0x8(%ebp),%eax
80101fac:	0f b7 40 18          	movzwl 0x18(%eax),%eax
80101fb0:	0f b7 d0             	movzwl %ax,%edx
80101fb3:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fb6:	89 50 14             	mov    %edx,0x14(%eax)
  st->gid = ip->gid;
80101fb9:	8b 45 08             	mov    0x8(%ebp),%eax
80101fbc:	0f b7 40 1a          	movzwl 0x1a(%eax),%eax
80101fc0:	0f b7 d0             	movzwl %ax,%edx
80101fc3:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fc6:	89 50 18             	mov    %edx,0x18(%eax)
  st->mode.asInt = ip->mode.asInt;
80101fc9:	8b 45 08             	mov    0x8(%ebp),%eax
80101fcc:	8b 50 1c             	mov    0x1c(%eax),%edx
80101fcf:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fd2:	89 50 1c             	mov    %edx,0x1c(%eax)
  #endif
  st->dev = ip->dev;
80101fd5:	8b 45 08             	mov    0x8(%ebp),%eax
80101fd8:	8b 00                	mov    (%eax),%eax
80101fda:	89 c2                	mov    %eax,%edx
80101fdc:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fdf:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101fe2:	8b 45 08             	mov    0x8(%ebp),%eax
80101fe5:	8b 50 04             	mov    0x4(%eax),%edx
80101fe8:	8b 45 0c             	mov    0xc(%ebp),%eax
80101feb:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101fee:	8b 45 08             	mov    0x8(%ebp),%eax
80101ff1:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101ff5:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ff8:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101ffb:	8b 45 08             	mov    0x8(%ebp),%eax
80101ffe:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80102002:	8b 45 0c             	mov    0xc(%ebp),%eax
80102005:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80102009:	8b 45 08             	mov    0x8(%ebp),%eax
8010200c:	8b 50 20             	mov    0x20(%eax),%edx
8010200f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102012:	89 50 10             	mov    %edx,0x10(%eax)
}
80102015:	90                   	nop
80102016:	5d                   	pop    %ebp
80102017:	c3                   	ret    

80102018 <readi>:

// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80102018:	55                   	push   %ebp
80102019:	89 e5                	mov    %esp,%ebp
8010201b:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
8010201e:	8b 45 08             	mov    0x8(%ebp),%eax
80102021:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102025:	66 83 f8 03          	cmp    $0x3,%ax
80102029:	75 5c                	jne    80102087 <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
8010202b:	8b 45 08             	mov    0x8(%ebp),%eax
8010202e:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102032:	66 85 c0             	test   %ax,%ax
80102035:	78 20                	js     80102057 <readi+0x3f>
80102037:	8b 45 08             	mov    0x8(%ebp),%eax
8010203a:	0f b7 40 12          	movzwl 0x12(%eax),%eax
8010203e:	66 83 f8 09          	cmp    $0x9,%ax
80102042:	7f 13                	jg     80102057 <readi+0x3f>
80102044:	8b 45 08             	mov    0x8(%ebp),%eax
80102047:	0f b7 40 12          	movzwl 0x12(%eax),%eax
8010204b:	98                   	cwtl   
8010204c:	8b 04 c5 00 22 11 80 	mov    -0x7feede00(,%eax,8),%eax
80102053:	85 c0                	test   %eax,%eax
80102055:	75 0a                	jne    80102061 <readi+0x49>
      return -1;
80102057:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010205c:	e9 0c 01 00 00       	jmp    8010216d <readi+0x155>
    return devsw[ip->major].read(ip, dst, n);
80102061:	8b 45 08             	mov    0x8(%ebp),%eax
80102064:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102068:	98                   	cwtl   
80102069:	8b 04 c5 00 22 11 80 	mov    -0x7feede00(,%eax,8),%eax
80102070:	8b 55 14             	mov    0x14(%ebp),%edx
80102073:	83 ec 04             	sub    $0x4,%esp
80102076:	52                   	push   %edx
80102077:	ff 75 0c             	pushl  0xc(%ebp)
8010207a:	ff 75 08             	pushl  0x8(%ebp)
8010207d:	ff d0                	call   *%eax
8010207f:	83 c4 10             	add    $0x10,%esp
80102082:	e9 e6 00 00 00       	jmp    8010216d <readi+0x155>
  }

  if(off > ip->size || off + n < off)
80102087:	8b 45 08             	mov    0x8(%ebp),%eax
8010208a:	8b 40 20             	mov    0x20(%eax),%eax
8010208d:	3b 45 10             	cmp    0x10(%ebp),%eax
80102090:	72 0d                	jb     8010209f <readi+0x87>
80102092:	8b 55 10             	mov    0x10(%ebp),%edx
80102095:	8b 45 14             	mov    0x14(%ebp),%eax
80102098:	01 d0                	add    %edx,%eax
8010209a:	3b 45 10             	cmp    0x10(%ebp),%eax
8010209d:	73 0a                	jae    801020a9 <readi+0x91>
    return -1;
8010209f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020a4:	e9 c4 00 00 00       	jmp    8010216d <readi+0x155>
  if(off + n > ip->size)
801020a9:	8b 55 10             	mov    0x10(%ebp),%edx
801020ac:	8b 45 14             	mov    0x14(%ebp),%eax
801020af:	01 c2                	add    %eax,%edx
801020b1:	8b 45 08             	mov    0x8(%ebp),%eax
801020b4:	8b 40 20             	mov    0x20(%eax),%eax
801020b7:	39 c2                	cmp    %eax,%edx
801020b9:	76 0c                	jbe    801020c7 <readi+0xaf>
    n = ip->size - off;
801020bb:	8b 45 08             	mov    0x8(%ebp),%eax
801020be:	8b 40 20             	mov    0x20(%eax),%eax
801020c1:	2b 45 10             	sub    0x10(%ebp),%eax
801020c4:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801020c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801020ce:	e9 8b 00 00 00       	jmp    8010215e <readi+0x146>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801020d3:	8b 45 10             	mov    0x10(%ebp),%eax
801020d6:	c1 e8 09             	shr    $0x9,%eax
801020d9:	83 ec 08             	sub    $0x8,%esp
801020dc:	50                   	push   %eax
801020dd:	ff 75 08             	pushl  0x8(%ebp)
801020e0:	e8 7e fc ff ff       	call   80101d63 <bmap>
801020e5:	83 c4 10             	add    $0x10,%esp
801020e8:	89 c2                	mov    %eax,%edx
801020ea:	8b 45 08             	mov    0x8(%ebp),%eax
801020ed:	8b 00                	mov    (%eax),%eax
801020ef:	83 ec 08             	sub    $0x8,%esp
801020f2:	52                   	push   %edx
801020f3:	50                   	push   %eax
801020f4:	e8 bd e0 ff ff       	call   801001b6 <bread>
801020f9:	83 c4 10             	add    $0x10,%esp
801020fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801020ff:	8b 45 10             	mov    0x10(%ebp),%eax
80102102:	25 ff 01 00 00       	and    $0x1ff,%eax
80102107:	ba 00 02 00 00       	mov    $0x200,%edx
8010210c:	29 c2                	sub    %eax,%edx
8010210e:	8b 45 14             	mov    0x14(%ebp),%eax
80102111:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102114:	39 c2                	cmp    %eax,%edx
80102116:	0f 46 c2             	cmovbe %edx,%eax
80102119:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
8010211c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010211f:	8d 50 18             	lea    0x18(%eax),%edx
80102122:	8b 45 10             	mov    0x10(%ebp),%eax
80102125:	25 ff 01 00 00       	and    $0x1ff,%eax
8010212a:	01 d0                	add    %edx,%eax
8010212c:	83 ec 04             	sub    $0x4,%esp
8010212f:	ff 75 ec             	pushl  -0x14(%ebp)
80102132:	50                   	push   %eax
80102133:	ff 75 0c             	pushl  0xc(%ebp)
80102136:	e8 5d 39 00 00       	call   80105a98 <memmove>
8010213b:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
8010213e:	83 ec 0c             	sub    $0xc,%esp
80102141:	ff 75 f0             	pushl  -0x10(%ebp)
80102144:	e8 e5 e0 ff ff       	call   8010022e <brelse>
80102149:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010214c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010214f:	01 45 f4             	add    %eax,-0xc(%ebp)
80102152:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102155:	01 45 10             	add    %eax,0x10(%ebp)
80102158:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010215b:	01 45 0c             	add    %eax,0xc(%ebp)
8010215e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102161:	3b 45 14             	cmp    0x14(%ebp),%eax
80102164:	0f 82 69 ff ff ff    	jb     801020d3 <readi+0xbb>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
8010216a:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010216d:	c9                   	leave  
8010216e:	c3                   	ret    

8010216f <writei>:

// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
8010216f:	55                   	push   %ebp
80102170:	89 e5                	mov    %esp,%ebp
80102172:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102175:	8b 45 08             	mov    0x8(%ebp),%eax
80102178:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010217c:	66 83 f8 03          	cmp    $0x3,%ax
80102180:	75 5c                	jne    801021de <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102182:	8b 45 08             	mov    0x8(%ebp),%eax
80102185:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102189:	66 85 c0             	test   %ax,%ax
8010218c:	78 20                	js     801021ae <writei+0x3f>
8010218e:	8b 45 08             	mov    0x8(%ebp),%eax
80102191:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102195:	66 83 f8 09          	cmp    $0x9,%ax
80102199:	7f 13                	jg     801021ae <writei+0x3f>
8010219b:	8b 45 08             	mov    0x8(%ebp),%eax
8010219e:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801021a2:	98                   	cwtl   
801021a3:	8b 04 c5 04 22 11 80 	mov    -0x7feeddfc(,%eax,8),%eax
801021aa:	85 c0                	test   %eax,%eax
801021ac:	75 0a                	jne    801021b8 <writei+0x49>
      return -1;
801021ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021b3:	e9 3d 01 00 00       	jmp    801022f5 <writei+0x186>
    return devsw[ip->major].write(ip, src, n);
801021b8:	8b 45 08             	mov    0x8(%ebp),%eax
801021bb:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801021bf:	98                   	cwtl   
801021c0:	8b 04 c5 04 22 11 80 	mov    -0x7feeddfc(,%eax,8),%eax
801021c7:	8b 55 14             	mov    0x14(%ebp),%edx
801021ca:	83 ec 04             	sub    $0x4,%esp
801021cd:	52                   	push   %edx
801021ce:	ff 75 0c             	pushl  0xc(%ebp)
801021d1:	ff 75 08             	pushl  0x8(%ebp)
801021d4:	ff d0                	call   *%eax
801021d6:	83 c4 10             	add    $0x10,%esp
801021d9:	e9 17 01 00 00       	jmp    801022f5 <writei+0x186>
  }

  if(off > ip->size || off + n < off)
801021de:	8b 45 08             	mov    0x8(%ebp),%eax
801021e1:	8b 40 20             	mov    0x20(%eax),%eax
801021e4:	3b 45 10             	cmp    0x10(%ebp),%eax
801021e7:	72 0d                	jb     801021f6 <writei+0x87>
801021e9:	8b 55 10             	mov    0x10(%ebp),%edx
801021ec:	8b 45 14             	mov    0x14(%ebp),%eax
801021ef:	01 d0                	add    %edx,%eax
801021f1:	3b 45 10             	cmp    0x10(%ebp),%eax
801021f4:	73 0a                	jae    80102200 <writei+0x91>
    return -1;
801021f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021fb:	e9 f5 00 00 00       	jmp    801022f5 <writei+0x186>
  if(off + n > MAXFILE*BSIZE)
80102200:	8b 55 10             	mov    0x10(%ebp),%edx
80102203:	8b 45 14             	mov    0x14(%ebp),%eax
80102206:	01 d0                	add    %edx,%eax
80102208:	3d 00 14 01 00       	cmp    $0x11400,%eax
8010220d:	76 0a                	jbe    80102219 <writei+0xaa>
    return -1;
8010220f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102214:	e9 dc 00 00 00       	jmp    801022f5 <writei+0x186>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102219:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102220:	e9 99 00 00 00       	jmp    801022be <writei+0x14f>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102225:	8b 45 10             	mov    0x10(%ebp),%eax
80102228:	c1 e8 09             	shr    $0x9,%eax
8010222b:	83 ec 08             	sub    $0x8,%esp
8010222e:	50                   	push   %eax
8010222f:	ff 75 08             	pushl  0x8(%ebp)
80102232:	e8 2c fb ff ff       	call   80101d63 <bmap>
80102237:	83 c4 10             	add    $0x10,%esp
8010223a:	89 c2                	mov    %eax,%edx
8010223c:	8b 45 08             	mov    0x8(%ebp),%eax
8010223f:	8b 00                	mov    (%eax),%eax
80102241:	83 ec 08             	sub    $0x8,%esp
80102244:	52                   	push   %edx
80102245:	50                   	push   %eax
80102246:	e8 6b df ff ff       	call   801001b6 <bread>
8010224b:	83 c4 10             	add    $0x10,%esp
8010224e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102251:	8b 45 10             	mov    0x10(%ebp),%eax
80102254:	25 ff 01 00 00       	and    $0x1ff,%eax
80102259:	ba 00 02 00 00       	mov    $0x200,%edx
8010225e:	29 c2                	sub    %eax,%edx
80102260:	8b 45 14             	mov    0x14(%ebp),%eax
80102263:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102266:	39 c2                	cmp    %eax,%edx
80102268:	0f 46 c2             	cmovbe %edx,%eax
8010226b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
8010226e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102271:	8d 50 18             	lea    0x18(%eax),%edx
80102274:	8b 45 10             	mov    0x10(%ebp),%eax
80102277:	25 ff 01 00 00       	and    $0x1ff,%eax
8010227c:	01 d0                	add    %edx,%eax
8010227e:	83 ec 04             	sub    $0x4,%esp
80102281:	ff 75 ec             	pushl  -0x14(%ebp)
80102284:	ff 75 0c             	pushl  0xc(%ebp)
80102287:	50                   	push   %eax
80102288:	e8 0b 38 00 00       	call   80105a98 <memmove>
8010228d:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
80102290:	83 ec 0c             	sub    $0xc,%esp
80102293:	ff 75 f0             	pushl  -0x10(%ebp)
80102296:	e8 c8 17 00 00       	call   80103a63 <log_write>
8010229b:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
8010229e:	83 ec 0c             	sub    $0xc,%esp
801022a1:	ff 75 f0             	pushl  -0x10(%ebp)
801022a4:	e8 85 df ff ff       	call   8010022e <brelse>
801022a9:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801022ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
801022af:	01 45 f4             	add    %eax,-0xc(%ebp)
801022b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801022b5:	01 45 10             	add    %eax,0x10(%ebp)
801022b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801022bb:	01 45 0c             	add    %eax,0xc(%ebp)
801022be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022c1:	3b 45 14             	cmp    0x14(%ebp),%eax
801022c4:	0f 82 5b ff ff ff    	jb     80102225 <writei+0xb6>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
801022ca:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801022ce:	74 22                	je     801022f2 <writei+0x183>
801022d0:	8b 45 08             	mov    0x8(%ebp),%eax
801022d3:	8b 40 20             	mov    0x20(%eax),%eax
801022d6:	3b 45 10             	cmp    0x10(%ebp),%eax
801022d9:	73 17                	jae    801022f2 <writei+0x183>
    ip->size = off;
801022db:	8b 45 08             	mov    0x8(%ebp),%eax
801022de:	8b 55 10             	mov    0x10(%ebp),%edx
801022e1:	89 50 20             	mov    %edx,0x20(%eax)
    iupdate(ip);
801022e4:	83 ec 0c             	sub    $0xc,%esp
801022e7:	ff 75 08             	pushl  0x8(%ebp)
801022ea:	e8 65 f5 ff ff       	call   80101854 <iupdate>
801022ef:	83 c4 10             	add    $0x10,%esp
  }
  return n;
801022f2:	8b 45 14             	mov    0x14(%ebp),%eax
}
801022f5:	c9                   	leave  
801022f6:	c3                   	ret    

801022f7 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
801022f7:	55                   	push   %ebp
801022f8:	89 e5                	mov    %esp,%ebp
801022fa:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
801022fd:	83 ec 04             	sub    $0x4,%esp
80102300:	6a 0e                	push   $0xe
80102302:	ff 75 0c             	pushl  0xc(%ebp)
80102305:	ff 75 08             	pushl  0x8(%ebp)
80102308:	e8 21 38 00 00       	call   80105b2e <strncmp>
8010230d:	83 c4 10             	add    $0x10,%esp
}
80102310:	c9                   	leave  
80102311:	c3                   	ret    

80102312 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102312:	55                   	push   %ebp
80102313:	89 e5                	mov    %esp,%ebp
80102315:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102318:	8b 45 08             	mov    0x8(%ebp),%eax
8010231b:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010231f:	66 83 f8 01          	cmp    $0x1,%ax
80102323:	74 0d                	je     80102332 <dirlookup+0x20>
    panic("dirlookup not DIR");
80102325:	83 ec 0c             	sub    $0xc,%esp
80102328:	68 8b 90 10 80       	push   $0x8010908b
8010232d:	e8 34 e2 ff ff       	call   80100566 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
80102332:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102339:	eb 7b                	jmp    801023b6 <dirlookup+0xa4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010233b:	6a 10                	push   $0x10
8010233d:	ff 75 f4             	pushl  -0xc(%ebp)
80102340:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102343:	50                   	push   %eax
80102344:	ff 75 08             	pushl  0x8(%ebp)
80102347:	e8 cc fc ff ff       	call   80102018 <readi>
8010234c:	83 c4 10             	add    $0x10,%esp
8010234f:	83 f8 10             	cmp    $0x10,%eax
80102352:	74 0d                	je     80102361 <dirlookup+0x4f>
      panic("dirlink read");
80102354:	83 ec 0c             	sub    $0xc,%esp
80102357:	68 9d 90 10 80       	push   $0x8010909d
8010235c:	e8 05 e2 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
80102361:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102365:	66 85 c0             	test   %ax,%ax
80102368:	74 47                	je     801023b1 <dirlookup+0x9f>
      continue;
    if(namecmp(name, de.name) == 0){
8010236a:	83 ec 08             	sub    $0x8,%esp
8010236d:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102370:	83 c0 02             	add    $0x2,%eax
80102373:	50                   	push   %eax
80102374:	ff 75 0c             	pushl  0xc(%ebp)
80102377:	e8 7b ff ff ff       	call   801022f7 <namecmp>
8010237c:	83 c4 10             	add    $0x10,%esp
8010237f:	85 c0                	test   %eax,%eax
80102381:	75 2f                	jne    801023b2 <dirlookup+0xa0>
      // entry matches path element
      if(poff)
80102383:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102387:	74 08                	je     80102391 <dirlookup+0x7f>
        *poff = off;
80102389:	8b 45 10             	mov    0x10(%ebp),%eax
8010238c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010238f:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
80102391:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102395:	0f b7 c0             	movzwl %ax,%eax
80102398:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
8010239b:	8b 45 08             	mov    0x8(%ebp),%eax
8010239e:	8b 00                	mov    (%eax),%eax
801023a0:	83 ec 08             	sub    $0x8,%esp
801023a3:	ff 75 f0             	pushl  -0x10(%ebp)
801023a6:	50                   	push   %eax
801023a7:	e8 91 f5 ff ff       	call   8010193d <iget>
801023ac:	83 c4 10             	add    $0x10,%esp
801023af:	eb 19                	jmp    801023ca <dirlookup+0xb8>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
801023b1:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801023b2:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801023b6:	8b 45 08             	mov    0x8(%ebp),%eax
801023b9:	8b 40 20             	mov    0x20(%eax),%eax
801023bc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801023bf:	0f 87 76 ff ff ff    	ja     8010233b <dirlookup+0x29>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
801023c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801023ca:	c9                   	leave  
801023cb:	c3                   	ret    

801023cc <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
801023cc:	55                   	push   %ebp
801023cd:	89 e5                	mov    %esp,%ebp
801023cf:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
801023d2:	83 ec 04             	sub    $0x4,%esp
801023d5:	6a 00                	push   $0x0
801023d7:	ff 75 0c             	pushl  0xc(%ebp)
801023da:	ff 75 08             	pushl  0x8(%ebp)
801023dd:	e8 30 ff ff ff       	call   80102312 <dirlookup>
801023e2:	83 c4 10             	add    $0x10,%esp
801023e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
801023e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801023ec:	74 18                	je     80102406 <dirlink+0x3a>
    iput(ip);
801023ee:	83 ec 0c             	sub    $0xc,%esp
801023f1:	ff 75 f0             	pushl  -0x10(%ebp)
801023f4:	e8 55 f8 ff ff       	call   80101c4e <iput>
801023f9:	83 c4 10             	add    $0x10,%esp
    return -1;
801023fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102401:	e9 9c 00 00 00       	jmp    801024a2 <dirlink+0xd6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102406:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010240d:	eb 39                	jmp    80102448 <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010240f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102412:	6a 10                	push   $0x10
80102414:	50                   	push   %eax
80102415:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102418:	50                   	push   %eax
80102419:	ff 75 08             	pushl  0x8(%ebp)
8010241c:	e8 f7 fb ff ff       	call   80102018 <readi>
80102421:	83 c4 10             	add    $0x10,%esp
80102424:	83 f8 10             	cmp    $0x10,%eax
80102427:	74 0d                	je     80102436 <dirlink+0x6a>
      panic("dirlink read");
80102429:	83 ec 0c             	sub    $0xc,%esp
8010242c:	68 9d 90 10 80       	push   $0x8010909d
80102431:	e8 30 e1 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
80102436:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010243a:	66 85 c0             	test   %ax,%ax
8010243d:	74 18                	je     80102457 <dirlink+0x8b>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
8010243f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102442:	83 c0 10             	add    $0x10,%eax
80102445:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102448:	8b 45 08             	mov    0x8(%ebp),%eax
8010244b:	8b 50 20             	mov    0x20(%eax),%edx
8010244e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102451:	39 c2                	cmp    %eax,%edx
80102453:	77 ba                	ja     8010240f <dirlink+0x43>
80102455:	eb 01                	jmp    80102458 <dirlink+0x8c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
80102457:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
80102458:	83 ec 04             	sub    $0x4,%esp
8010245b:	6a 0e                	push   $0xe
8010245d:	ff 75 0c             	pushl  0xc(%ebp)
80102460:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102463:	83 c0 02             	add    $0x2,%eax
80102466:	50                   	push   %eax
80102467:	e8 18 37 00 00       	call   80105b84 <strncpy>
8010246c:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
8010246f:	8b 45 10             	mov    0x10(%ebp),%eax
80102472:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102476:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102479:	6a 10                	push   $0x10
8010247b:	50                   	push   %eax
8010247c:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010247f:	50                   	push   %eax
80102480:	ff 75 08             	pushl  0x8(%ebp)
80102483:	e8 e7 fc ff ff       	call   8010216f <writei>
80102488:	83 c4 10             	add    $0x10,%esp
8010248b:	83 f8 10             	cmp    $0x10,%eax
8010248e:	74 0d                	je     8010249d <dirlink+0xd1>
    panic("dirlink");
80102490:	83 ec 0c             	sub    $0xc,%esp
80102493:	68 aa 90 10 80       	push   $0x801090aa
80102498:	e8 c9 e0 ff ff       	call   80100566 <panic>
  
  return 0;
8010249d:	b8 00 00 00 00       	mov    $0x0,%eax
}
801024a2:	c9                   	leave  
801024a3:	c3                   	ret    

801024a4 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
801024a4:	55                   	push   %ebp
801024a5:	89 e5                	mov    %esp,%ebp
801024a7:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
801024aa:	eb 04                	jmp    801024b0 <skipelem+0xc>
    path++;
801024ac:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
801024b0:	8b 45 08             	mov    0x8(%ebp),%eax
801024b3:	0f b6 00             	movzbl (%eax),%eax
801024b6:	3c 2f                	cmp    $0x2f,%al
801024b8:	74 f2                	je     801024ac <skipelem+0x8>
    path++;
  if(*path == 0)
801024ba:	8b 45 08             	mov    0x8(%ebp),%eax
801024bd:	0f b6 00             	movzbl (%eax),%eax
801024c0:	84 c0                	test   %al,%al
801024c2:	75 07                	jne    801024cb <skipelem+0x27>
    return 0;
801024c4:	b8 00 00 00 00       	mov    $0x0,%eax
801024c9:	eb 7b                	jmp    80102546 <skipelem+0xa2>
  s = path;
801024cb:	8b 45 08             	mov    0x8(%ebp),%eax
801024ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
801024d1:	eb 04                	jmp    801024d7 <skipelem+0x33>
    path++;
801024d3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
801024d7:	8b 45 08             	mov    0x8(%ebp),%eax
801024da:	0f b6 00             	movzbl (%eax),%eax
801024dd:	3c 2f                	cmp    $0x2f,%al
801024df:	74 0a                	je     801024eb <skipelem+0x47>
801024e1:	8b 45 08             	mov    0x8(%ebp),%eax
801024e4:	0f b6 00             	movzbl (%eax),%eax
801024e7:	84 c0                	test   %al,%al
801024e9:	75 e8                	jne    801024d3 <skipelem+0x2f>
    path++;
  len = path - s;
801024eb:	8b 55 08             	mov    0x8(%ebp),%edx
801024ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024f1:	29 c2                	sub    %eax,%edx
801024f3:	89 d0                	mov    %edx,%eax
801024f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
801024f8:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801024fc:	7e 15                	jle    80102513 <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
801024fe:	83 ec 04             	sub    $0x4,%esp
80102501:	6a 0e                	push   $0xe
80102503:	ff 75 f4             	pushl  -0xc(%ebp)
80102506:	ff 75 0c             	pushl  0xc(%ebp)
80102509:	e8 8a 35 00 00       	call   80105a98 <memmove>
8010250e:	83 c4 10             	add    $0x10,%esp
80102511:	eb 26                	jmp    80102539 <skipelem+0x95>
  else {
    memmove(name, s, len);
80102513:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102516:	83 ec 04             	sub    $0x4,%esp
80102519:	50                   	push   %eax
8010251a:	ff 75 f4             	pushl  -0xc(%ebp)
8010251d:	ff 75 0c             	pushl  0xc(%ebp)
80102520:	e8 73 35 00 00       	call   80105a98 <memmove>
80102525:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
80102528:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010252b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010252e:	01 d0                	add    %edx,%eax
80102530:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
80102533:	eb 04                	jmp    80102539 <skipelem+0x95>
    path++;
80102535:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102539:	8b 45 08             	mov    0x8(%ebp),%eax
8010253c:	0f b6 00             	movzbl (%eax),%eax
8010253f:	3c 2f                	cmp    $0x2f,%al
80102541:	74 f2                	je     80102535 <skipelem+0x91>
    path++;
  return path;
80102543:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102546:	c9                   	leave  
80102547:	c3                   	ret    

80102548 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102548:	55                   	push   %ebp
80102549:	89 e5                	mov    %esp,%ebp
8010254b:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010254e:	8b 45 08             	mov    0x8(%ebp),%eax
80102551:	0f b6 00             	movzbl (%eax),%eax
80102554:	3c 2f                	cmp    $0x2f,%al
80102556:	75 17                	jne    8010256f <namex+0x27>
    ip = iget(ROOTDEV, ROOTINO);
80102558:	83 ec 08             	sub    $0x8,%esp
8010255b:	6a 01                	push   $0x1
8010255d:	6a 01                	push   $0x1
8010255f:	e8 d9 f3 ff ff       	call   8010193d <iget>
80102564:	83 c4 10             	add    $0x10,%esp
80102567:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010256a:	e9 bb 00 00 00       	jmp    8010262a <namex+0xe2>
  else
    ip = idup(proc->cwd);
8010256f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80102575:	8b 40 68             	mov    0x68(%eax),%eax
80102578:	83 ec 0c             	sub    $0xc,%esp
8010257b:	50                   	push   %eax
8010257c:	e8 9b f4 ff ff       	call   80101a1c <idup>
80102581:	83 c4 10             	add    $0x10,%esp
80102584:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
80102587:	e9 9e 00 00 00       	jmp    8010262a <namex+0xe2>
    ilock(ip);
8010258c:	83 ec 0c             	sub    $0xc,%esp
8010258f:	ff 75 f4             	pushl  -0xc(%ebp)
80102592:	e8 bf f4 ff ff       	call   80101a56 <ilock>
80102597:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
8010259a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010259d:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801025a1:	66 83 f8 01          	cmp    $0x1,%ax
801025a5:	74 18                	je     801025bf <namex+0x77>
      iunlockput(ip);
801025a7:	83 ec 0c             	sub    $0xc,%esp
801025aa:	ff 75 f4             	pushl  -0xc(%ebp)
801025ad:	e8 8c f7 ff ff       	call   80101d3e <iunlockput>
801025b2:	83 c4 10             	add    $0x10,%esp
      return 0;
801025b5:	b8 00 00 00 00       	mov    $0x0,%eax
801025ba:	e9 a7 00 00 00       	jmp    80102666 <namex+0x11e>
    }
    if(nameiparent && *path == '\0'){
801025bf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801025c3:	74 20                	je     801025e5 <namex+0x9d>
801025c5:	8b 45 08             	mov    0x8(%ebp),%eax
801025c8:	0f b6 00             	movzbl (%eax),%eax
801025cb:	84 c0                	test   %al,%al
801025cd:	75 16                	jne    801025e5 <namex+0x9d>
      // Stop one level early.
      iunlock(ip);
801025cf:	83 ec 0c             	sub    $0xc,%esp
801025d2:	ff 75 f4             	pushl  -0xc(%ebp)
801025d5:	e8 02 f6 ff ff       	call   80101bdc <iunlock>
801025da:	83 c4 10             	add    $0x10,%esp
      return ip;
801025dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025e0:	e9 81 00 00 00       	jmp    80102666 <namex+0x11e>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801025e5:	83 ec 04             	sub    $0x4,%esp
801025e8:	6a 00                	push   $0x0
801025ea:	ff 75 10             	pushl  0x10(%ebp)
801025ed:	ff 75 f4             	pushl  -0xc(%ebp)
801025f0:	e8 1d fd ff ff       	call   80102312 <dirlookup>
801025f5:	83 c4 10             	add    $0x10,%esp
801025f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
801025fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801025ff:	75 15                	jne    80102616 <namex+0xce>
      iunlockput(ip);
80102601:	83 ec 0c             	sub    $0xc,%esp
80102604:	ff 75 f4             	pushl  -0xc(%ebp)
80102607:	e8 32 f7 ff ff       	call   80101d3e <iunlockput>
8010260c:	83 c4 10             	add    $0x10,%esp
      return 0;
8010260f:	b8 00 00 00 00       	mov    $0x0,%eax
80102614:	eb 50                	jmp    80102666 <namex+0x11e>
    }
    iunlockput(ip);
80102616:	83 ec 0c             	sub    $0xc,%esp
80102619:	ff 75 f4             	pushl  -0xc(%ebp)
8010261c:	e8 1d f7 ff ff       	call   80101d3e <iunlockput>
80102621:	83 c4 10             	add    $0x10,%esp
    ip = next;
80102624:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102627:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
8010262a:	83 ec 08             	sub    $0x8,%esp
8010262d:	ff 75 10             	pushl  0x10(%ebp)
80102630:	ff 75 08             	pushl  0x8(%ebp)
80102633:	e8 6c fe ff ff       	call   801024a4 <skipelem>
80102638:	83 c4 10             	add    $0x10,%esp
8010263b:	89 45 08             	mov    %eax,0x8(%ebp)
8010263e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102642:	0f 85 44 ff ff ff    	jne    8010258c <namex+0x44>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102648:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010264c:	74 15                	je     80102663 <namex+0x11b>
    iput(ip);
8010264e:	83 ec 0c             	sub    $0xc,%esp
80102651:	ff 75 f4             	pushl  -0xc(%ebp)
80102654:	e8 f5 f5 ff ff       	call   80101c4e <iput>
80102659:	83 c4 10             	add    $0x10,%esp
    return 0;
8010265c:	b8 00 00 00 00       	mov    $0x0,%eax
80102661:	eb 03                	jmp    80102666 <namex+0x11e>
  }
  return ip;
80102663:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102666:	c9                   	leave  
80102667:	c3                   	ret    

80102668 <namei>:

struct inode*
namei(char *path)
{
80102668:	55                   	push   %ebp
80102669:	89 e5                	mov    %esp,%ebp
8010266b:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
8010266e:	83 ec 04             	sub    $0x4,%esp
80102671:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102674:	50                   	push   %eax
80102675:	6a 00                	push   $0x0
80102677:	ff 75 08             	pushl  0x8(%ebp)
8010267a:	e8 c9 fe ff ff       	call   80102548 <namex>
8010267f:	83 c4 10             	add    $0x10,%esp
}
80102682:	c9                   	leave  
80102683:	c3                   	ret    

80102684 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102684:	55                   	push   %ebp
80102685:	89 e5                	mov    %esp,%ebp
80102687:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
8010268a:	83 ec 04             	sub    $0x4,%esp
8010268d:	ff 75 0c             	pushl  0xc(%ebp)
80102690:	6a 01                	push   $0x1
80102692:	ff 75 08             	pushl  0x8(%ebp)
80102695:	e8 ae fe ff ff       	call   80102548 <namex>
8010269a:	83 c4 10             	add    $0x10,%esp
}
8010269d:	c9                   	leave  
8010269e:	c3                   	ret    

8010269f <chmod>:

#ifdef CS333_P5
// Sets the mode bits (permissions) for a file or directory
int
chmod(char *pathname, int mode)
{
8010269f:	55                   	push   %ebp
801026a0:	89 e5                	mov    %esp,%ebp
801026a2:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;

  begin_op();
801026a5:	e8 81 11 00 00       	call   8010382b <begin_op>
  ip = namei (pathname);
801026aa:	83 ec 0c             	sub    $0xc,%esp
801026ad:	ff 75 08             	pushl  0x8(%ebp)
801026b0:	e8 b3 ff ff ff       	call   80102668 <namei>
801026b5:	83 c4 10             	add    $0x10,%esp
801026b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(ip == 0){
801026bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801026bf:	75 0c                	jne    801026cd <chmod+0x2e>
    end_op();
801026c1:	e8 f1 11 00 00       	call   801038b7 <end_op>
    return -1;
801026c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801026cb:	eb 58                	jmp    80102725 <chmod+0x86>
  }
  if(mode < 0 || mode > 1023){
801026cd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801026d1:	78 09                	js     801026dc <chmod+0x3d>
801026d3:	81 7d 0c ff 03 00 00 	cmpl   $0x3ff,0xc(%ebp)
801026da:	7e 0c                	jle    801026e8 <chmod+0x49>
    end_op();
801026dc:	e8 d6 11 00 00       	call   801038b7 <end_op>
    return -1;
801026e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801026e6:	eb 3d                	jmp    80102725 <chmod+0x86>
  }

  ilock(ip);
801026e8:	83 ec 0c             	sub    $0xc,%esp
801026eb:	ff 75 f4             	pushl  -0xc(%ebp)
801026ee:	e8 63 f3 ff ff       	call   80101a56 <ilock>
801026f3:	83 c4 10             	add    $0x10,%esp
  ip -> mode.asInt = mode;
801026f6:	8b 55 0c             	mov    0xc(%ebp),%edx
801026f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801026fc:	89 50 1c             	mov    %edx,0x1c(%eax)
  iupdate(ip);
801026ff:	83 ec 0c             	sub    $0xc,%esp
80102702:	ff 75 f4             	pushl  -0xc(%ebp)
80102705:	e8 4a f1 ff ff       	call   80101854 <iupdate>
8010270a:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
8010270d:	83 ec 0c             	sub    $0xc,%esp
80102710:	ff 75 f4             	pushl  -0xc(%ebp)
80102713:	e8 c4 f4 ff ff       	call   80101bdc <iunlock>
80102718:	83 c4 10             	add    $0x10,%esp
  end_op();
8010271b:	e8 97 11 00 00       	call   801038b7 <end_op>

  return 0;
80102720:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102725:	c9                   	leave  
80102726:	c3                   	ret    

80102727 <chown>:

// Sets the owner (UID) for a file or directory
int
chown(char *pathname, int owner)
{
80102727:	55                   	push   %ebp
80102728:	89 e5                	mov    %esp,%ebp
8010272a:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;

  begin_op();
8010272d:	e8 f9 10 00 00       	call   8010382b <begin_op>
  ip = namei (pathname);
80102732:	83 ec 0c             	sub    $0xc,%esp
80102735:	ff 75 08             	pushl  0x8(%ebp)
80102738:	e8 2b ff ff ff       	call   80102668 <namei>
8010273d:	83 c4 10             	add    $0x10,%esp
80102740:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(ip == 0){
80102743:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102747:	75 0c                	jne    80102755 <chown+0x2e>
    end_op();
80102749:	e8 69 11 00 00       	call   801038b7 <end_op>
    return -1;
8010274e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102753:	eb 5b                	jmp    801027b0 <chown+0x89>
  }
  if(owner < 0 || owner > 32767){
80102755:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102759:	78 09                	js     80102764 <chown+0x3d>
8010275b:	81 7d 0c ff 7f 00 00 	cmpl   $0x7fff,0xc(%ebp)
80102762:	7e 0c                	jle    80102770 <chown+0x49>
    end_op();
80102764:	e8 4e 11 00 00       	call   801038b7 <end_op>
    return -1;
80102769:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010276e:	eb 40                	jmp    801027b0 <chown+0x89>
  }

  ilock(ip);
80102770:	83 ec 0c             	sub    $0xc,%esp
80102773:	ff 75 f4             	pushl  -0xc(%ebp)
80102776:	e8 db f2 ff ff       	call   80101a56 <ilock>
8010277b:	83 c4 10             	add    $0x10,%esp
  ip -> uid = owner;
8010277e:	8b 45 0c             	mov    0xc(%ebp),%eax
80102781:	89 c2                	mov    %eax,%edx
80102783:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102786:	66 89 50 18          	mov    %dx,0x18(%eax)
  iupdate(ip);
8010278a:	83 ec 0c             	sub    $0xc,%esp
8010278d:	ff 75 f4             	pushl  -0xc(%ebp)
80102790:	e8 bf f0 ff ff       	call   80101854 <iupdate>
80102795:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80102798:	83 ec 0c             	sub    $0xc,%esp
8010279b:	ff 75 f4             	pushl  -0xc(%ebp)
8010279e:	e8 39 f4 ff ff       	call   80101bdc <iunlock>
801027a3:	83 c4 10             	add    $0x10,%esp
  end_op();
801027a6:	e8 0c 11 00 00       	call   801038b7 <end_op>

  return 0;
801027ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
801027b0:	c9                   	leave  
801027b1:	c3                   	ret    

801027b2 <chgrp>:

// Sets the group (GID) for a file or directory
int
chgrp(char *pathname, int group)
{
801027b2:	55                   	push   %ebp
801027b3:	89 e5                	mov    %esp,%ebp
801027b5:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;

  begin_op();
801027b8:	e8 6e 10 00 00       	call   8010382b <begin_op>
  ip = namei (pathname);
801027bd:	83 ec 0c             	sub    $0xc,%esp
801027c0:	ff 75 08             	pushl  0x8(%ebp)
801027c3:	e8 a0 fe ff ff       	call   80102668 <namei>
801027c8:	83 c4 10             	add    $0x10,%esp
801027cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(ip == 0){
801027ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801027d2:	75 0c                	jne    801027e0 <chgrp+0x2e>
    end_op();
801027d4:	e8 de 10 00 00       	call   801038b7 <end_op>
    return -1;
801027d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801027de:	eb 5b                	jmp    8010283b <chgrp+0x89>
  }
  if(group < 0 || group > 32767){
801027e0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801027e4:	78 09                	js     801027ef <chgrp+0x3d>
801027e6:	81 7d 0c ff 7f 00 00 	cmpl   $0x7fff,0xc(%ebp)
801027ed:	7e 0c                	jle    801027fb <chgrp+0x49>
    end_op();
801027ef:	e8 c3 10 00 00       	call   801038b7 <end_op>
    return -1;
801027f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801027f9:	eb 40                	jmp    8010283b <chgrp+0x89>
  }

  ilock(ip);
801027fb:	83 ec 0c             	sub    $0xc,%esp
801027fe:	ff 75 f4             	pushl  -0xc(%ebp)
80102801:	e8 50 f2 ff ff       	call   80101a56 <ilock>
80102806:	83 c4 10             	add    $0x10,%esp
  ip -> gid = group;
80102809:	8b 45 0c             	mov    0xc(%ebp),%eax
8010280c:	89 c2                	mov    %eax,%edx
8010280e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102811:	66 89 50 1a          	mov    %dx,0x1a(%eax)
  iupdate(ip);
80102815:	83 ec 0c             	sub    $0xc,%esp
80102818:	ff 75 f4             	pushl  -0xc(%ebp)
8010281b:	e8 34 f0 ff ff       	call   80101854 <iupdate>
80102820:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80102823:	83 ec 0c             	sub    $0xc,%esp
80102826:	ff 75 f4             	pushl  -0xc(%ebp)
80102829:	e8 ae f3 ff ff       	call   80101bdc <iunlock>
8010282e:	83 c4 10             	add    $0x10,%esp
  end_op();
80102831:	e8 81 10 00 00       	call   801038b7 <end_op>

  return 0;
80102836:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010283b:	c9                   	leave  
8010283c:	c3                   	ret    

8010283d <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
8010283d:	55                   	push   %ebp
8010283e:	89 e5                	mov    %esp,%ebp
80102840:	83 ec 14             	sub    $0x14,%esp
80102843:	8b 45 08             	mov    0x8(%ebp),%eax
80102846:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010284a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010284e:	89 c2                	mov    %eax,%edx
80102850:	ec                   	in     (%dx),%al
80102851:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102854:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102858:	c9                   	leave  
80102859:	c3                   	ret    

8010285a <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
8010285a:	55                   	push   %ebp
8010285b:	89 e5                	mov    %esp,%ebp
8010285d:	57                   	push   %edi
8010285e:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
8010285f:	8b 55 08             	mov    0x8(%ebp),%edx
80102862:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102865:	8b 45 10             	mov    0x10(%ebp),%eax
80102868:	89 cb                	mov    %ecx,%ebx
8010286a:	89 df                	mov    %ebx,%edi
8010286c:	89 c1                	mov    %eax,%ecx
8010286e:	fc                   	cld    
8010286f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102871:	89 c8                	mov    %ecx,%eax
80102873:	89 fb                	mov    %edi,%ebx
80102875:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102878:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
8010287b:	90                   	nop
8010287c:	5b                   	pop    %ebx
8010287d:	5f                   	pop    %edi
8010287e:	5d                   	pop    %ebp
8010287f:	c3                   	ret    

80102880 <outb>:

static inline void
outb(ushort port, uchar data)
{
80102880:	55                   	push   %ebp
80102881:	89 e5                	mov    %esp,%ebp
80102883:	83 ec 08             	sub    $0x8,%esp
80102886:	8b 55 08             	mov    0x8(%ebp),%edx
80102889:	8b 45 0c             	mov    0xc(%ebp),%eax
8010288c:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102890:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102893:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102897:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010289b:	ee                   	out    %al,(%dx)
}
8010289c:	90                   	nop
8010289d:	c9                   	leave  
8010289e:	c3                   	ret    

8010289f <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
8010289f:	55                   	push   %ebp
801028a0:	89 e5                	mov    %esp,%ebp
801028a2:	56                   	push   %esi
801028a3:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
801028a4:	8b 55 08             	mov    0x8(%ebp),%edx
801028a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801028aa:	8b 45 10             	mov    0x10(%ebp),%eax
801028ad:	89 cb                	mov    %ecx,%ebx
801028af:	89 de                	mov    %ebx,%esi
801028b1:	89 c1                	mov    %eax,%ecx
801028b3:	fc                   	cld    
801028b4:	f3 6f                	rep outsl %ds:(%esi),(%dx)
801028b6:	89 c8                	mov    %ecx,%eax
801028b8:	89 f3                	mov    %esi,%ebx
801028ba:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801028bd:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
801028c0:	90                   	nop
801028c1:	5b                   	pop    %ebx
801028c2:	5e                   	pop    %esi
801028c3:	5d                   	pop    %ebp
801028c4:	c3                   	ret    

801028c5 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
801028c5:	55                   	push   %ebp
801028c6:	89 e5                	mov    %esp,%ebp
801028c8:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
801028cb:	90                   	nop
801028cc:	68 f7 01 00 00       	push   $0x1f7
801028d1:	e8 67 ff ff ff       	call   8010283d <inb>
801028d6:	83 c4 04             	add    $0x4,%esp
801028d9:	0f b6 c0             	movzbl %al,%eax
801028dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
801028df:	8b 45 fc             	mov    -0x4(%ebp),%eax
801028e2:	25 c0 00 00 00       	and    $0xc0,%eax
801028e7:	83 f8 40             	cmp    $0x40,%eax
801028ea:	75 e0                	jne    801028cc <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801028ec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801028f0:	74 11                	je     80102903 <idewait+0x3e>
801028f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801028f5:	83 e0 21             	and    $0x21,%eax
801028f8:	85 c0                	test   %eax,%eax
801028fa:	74 07                	je     80102903 <idewait+0x3e>
    return -1;
801028fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102901:	eb 05                	jmp    80102908 <idewait+0x43>
  return 0;
80102903:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102908:	c9                   	leave  
80102909:	c3                   	ret    

8010290a <ideinit>:

void
ideinit(void)
{
8010290a:	55                   	push   %ebp
8010290b:	89 e5                	mov    %esp,%ebp
8010290d:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  initlock(&idelock, "ide");
80102910:	83 ec 08             	sub    $0x8,%esp
80102913:	68 b2 90 10 80       	push   $0x801090b2
80102918:	68 40 c6 10 80       	push   $0x8010c640
8010291d:	e8 32 2e 00 00       	call   80105754 <initlock>
80102922:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
80102925:	83 ec 0c             	sub    $0xc,%esp
80102928:	6a 0e                	push   $0xe
8010292a:	e8 da 18 00 00       	call   80104209 <picenable>
8010292f:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
80102932:	a1 80 39 11 80       	mov    0x80113980,%eax
80102937:	83 e8 01             	sub    $0x1,%eax
8010293a:	83 ec 08             	sub    $0x8,%esp
8010293d:	50                   	push   %eax
8010293e:	6a 0e                	push   $0xe
80102940:	e8 73 04 00 00       	call   80102db8 <ioapicenable>
80102945:	83 c4 10             	add    $0x10,%esp
  idewait(0);
80102948:	83 ec 0c             	sub    $0xc,%esp
8010294b:	6a 00                	push   $0x0
8010294d:	e8 73 ff ff ff       	call   801028c5 <idewait>
80102952:	83 c4 10             	add    $0x10,%esp
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
80102955:	83 ec 08             	sub    $0x8,%esp
80102958:	68 f0 00 00 00       	push   $0xf0
8010295d:	68 f6 01 00 00       	push   $0x1f6
80102962:	e8 19 ff ff ff       	call   80102880 <outb>
80102967:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
8010296a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102971:	eb 24                	jmp    80102997 <ideinit+0x8d>
    if(inb(0x1f7) != 0){
80102973:	83 ec 0c             	sub    $0xc,%esp
80102976:	68 f7 01 00 00       	push   $0x1f7
8010297b:	e8 bd fe ff ff       	call   8010283d <inb>
80102980:	83 c4 10             	add    $0x10,%esp
80102983:	84 c0                	test   %al,%al
80102985:	74 0c                	je     80102993 <ideinit+0x89>
      havedisk1 = 1;
80102987:	c7 05 78 c6 10 80 01 	movl   $0x1,0x8010c678
8010298e:	00 00 00 
      break;
80102991:	eb 0d                	jmp    801029a0 <ideinit+0x96>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102993:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102997:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
8010299e:	7e d3                	jle    80102973 <ideinit+0x69>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
801029a0:	83 ec 08             	sub    $0x8,%esp
801029a3:	68 e0 00 00 00       	push   $0xe0
801029a8:	68 f6 01 00 00       	push   $0x1f6
801029ad:	e8 ce fe ff ff       	call   80102880 <outb>
801029b2:	83 c4 10             	add    $0x10,%esp
}
801029b5:	90                   	nop
801029b6:	c9                   	leave  
801029b7:	c3                   	ret    

801029b8 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801029b8:	55                   	push   %ebp
801029b9:	89 e5                	mov    %esp,%ebp
801029bb:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
801029be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801029c2:	75 0d                	jne    801029d1 <idestart+0x19>
    panic("idestart");
801029c4:	83 ec 0c             	sub    $0xc,%esp
801029c7:	68 b6 90 10 80       	push   $0x801090b6
801029cc:	e8 95 db ff ff       	call   80100566 <panic>
  if(b->blockno >= FSSIZE)
801029d1:	8b 45 08             	mov    0x8(%ebp),%eax
801029d4:	8b 40 08             	mov    0x8(%eax),%eax
801029d7:	3d cf 07 00 00       	cmp    $0x7cf,%eax
801029dc:	76 0d                	jbe    801029eb <idestart+0x33>
    panic("incorrect blockno");
801029de:	83 ec 0c             	sub    $0xc,%esp
801029e1:	68 bf 90 10 80       	push   $0x801090bf
801029e6:	e8 7b db ff ff       	call   80100566 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
801029eb:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
801029f2:	8b 45 08             	mov    0x8(%ebp),%eax
801029f5:	8b 50 08             	mov    0x8(%eax),%edx
801029f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029fb:	0f af c2             	imul   %edx,%eax
801029fe:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if (sector_per_block > 7) panic("idestart");
80102a01:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
80102a05:	7e 0d                	jle    80102a14 <idestart+0x5c>
80102a07:	83 ec 0c             	sub    $0xc,%esp
80102a0a:	68 b6 90 10 80       	push   $0x801090b6
80102a0f:	e8 52 db ff ff       	call   80100566 <panic>
  
  idewait(0);
80102a14:	83 ec 0c             	sub    $0xc,%esp
80102a17:	6a 00                	push   $0x0
80102a19:	e8 a7 fe ff ff       	call   801028c5 <idewait>
80102a1e:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
80102a21:	83 ec 08             	sub    $0x8,%esp
80102a24:	6a 00                	push   $0x0
80102a26:	68 f6 03 00 00       	push   $0x3f6
80102a2b:	e8 50 fe ff ff       	call   80102880 <outb>
80102a30:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
80102a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a36:	0f b6 c0             	movzbl %al,%eax
80102a39:	83 ec 08             	sub    $0x8,%esp
80102a3c:	50                   	push   %eax
80102a3d:	68 f2 01 00 00       	push   $0x1f2
80102a42:	e8 39 fe ff ff       	call   80102880 <outb>
80102a47:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
80102a4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102a4d:	0f b6 c0             	movzbl %al,%eax
80102a50:	83 ec 08             	sub    $0x8,%esp
80102a53:	50                   	push   %eax
80102a54:	68 f3 01 00 00       	push   $0x1f3
80102a59:	e8 22 fe ff ff       	call   80102880 <outb>
80102a5e:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
80102a61:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102a64:	c1 f8 08             	sar    $0x8,%eax
80102a67:	0f b6 c0             	movzbl %al,%eax
80102a6a:	83 ec 08             	sub    $0x8,%esp
80102a6d:	50                   	push   %eax
80102a6e:	68 f4 01 00 00       	push   $0x1f4
80102a73:	e8 08 fe ff ff       	call   80102880 <outb>
80102a78:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
80102a7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102a7e:	c1 f8 10             	sar    $0x10,%eax
80102a81:	0f b6 c0             	movzbl %al,%eax
80102a84:	83 ec 08             	sub    $0x8,%esp
80102a87:	50                   	push   %eax
80102a88:	68 f5 01 00 00       	push   $0x1f5
80102a8d:	e8 ee fd ff ff       	call   80102880 <outb>
80102a92:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102a95:	8b 45 08             	mov    0x8(%ebp),%eax
80102a98:	8b 40 04             	mov    0x4(%eax),%eax
80102a9b:	83 e0 01             	and    $0x1,%eax
80102a9e:	c1 e0 04             	shl    $0x4,%eax
80102aa1:	89 c2                	mov    %eax,%edx
80102aa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102aa6:	c1 f8 18             	sar    $0x18,%eax
80102aa9:	83 e0 0f             	and    $0xf,%eax
80102aac:	09 d0                	or     %edx,%eax
80102aae:	83 c8 e0             	or     $0xffffffe0,%eax
80102ab1:	0f b6 c0             	movzbl %al,%eax
80102ab4:	83 ec 08             	sub    $0x8,%esp
80102ab7:	50                   	push   %eax
80102ab8:	68 f6 01 00 00       	push   $0x1f6
80102abd:	e8 be fd ff ff       	call   80102880 <outb>
80102ac2:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
80102ac5:	8b 45 08             	mov    0x8(%ebp),%eax
80102ac8:	8b 00                	mov    (%eax),%eax
80102aca:	83 e0 04             	and    $0x4,%eax
80102acd:	85 c0                	test   %eax,%eax
80102acf:	74 30                	je     80102b01 <idestart+0x149>
    outb(0x1f7, IDE_CMD_WRITE);
80102ad1:	83 ec 08             	sub    $0x8,%esp
80102ad4:	6a 30                	push   $0x30
80102ad6:	68 f7 01 00 00       	push   $0x1f7
80102adb:	e8 a0 fd ff ff       	call   80102880 <outb>
80102ae0:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
80102ae3:	8b 45 08             	mov    0x8(%ebp),%eax
80102ae6:	83 c0 18             	add    $0x18,%eax
80102ae9:	83 ec 04             	sub    $0x4,%esp
80102aec:	68 80 00 00 00       	push   $0x80
80102af1:	50                   	push   %eax
80102af2:	68 f0 01 00 00       	push   $0x1f0
80102af7:	e8 a3 fd ff ff       	call   8010289f <outsl>
80102afc:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
80102aff:	eb 12                	jmp    80102b13 <idestart+0x15b>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, IDE_CMD_WRITE);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, IDE_CMD_READ);
80102b01:	83 ec 08             	sub    $0x8,%esp
80102b04:	6a 20                	push   $0x20
80102b06:	68 f7 01 00 00       	push   $0x1f7
80102b0b:	e8 70 fd ff ff       	call   80102880 <outb>
80102b10:	83 c4 10             	add    $0x10,%esp
  }
}
80102b13:	90                   	nop
80102b14:	c9                   	leave  
80102b15:	c3                   	ret    

80102b16 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102b16:	55                   	push   %ebp
80102b17:	89 e5                	mov    %esp,%ebp
80102b19:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102b1c:	83 ec 0c             	sub    $0xc,%esp
80102b1f:	68 40 c6 10 80       	push   $0x8010c640
80102b24:	e8 4d 2c 00 00       	call   80105776 <acquire>
80102b29:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
80102b2c:	a1 74 c6 10 80       	mov    0x8010c674,%eax
80102b31:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102b34:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102b38:	75 15                	jne    80102b4f <ideintr+0x39>
    release(&idelock);
80102b3a:	83 ec 0c             	sub    $0xc,%esp
80102b3d:	68 40 c6 10 80       	push   $0x8010c640
80102b42:	e8 96 2c 00 00       	call   801057dd <release>
80102b47:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
80102b4a:	e9 9a 00 00 00       	jmp    80102be9 <ideintr+0xd3>
  }
  idequeue = b->qnext;
80102b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b52:	8b 40 14             	mov    0x14(%eax),%eax
80102b55:	a3 74 c6 10 80       	mov    %eax,0x8010c674

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b5d:	8b 00                	mov    (%eax),%eax
80102b5f:	83 e0 04             	and    $0x4,%eax
80102b62:	85 c0                	test   %eax,%eax
80102b64:	75 2d                	jne    80102b93 <ideintr+0x7d>
80102b66:	83 ec 0c             	sub    $0xc,%esp
80102b69:	6a 01                	push   $0x1
80102b6b:	e8 55 fd ff ff       	call   801028c5 <idewait>
80102b70:	83 c4 10             	add    $0x10,%esp
80102b73:	85 c0                	test   %eax,%eax
80102b75:	78 1c                	js     80102b93 <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);
80102b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b7a:	83 c0 18             	add    $0x18,%eax
80102b7d:	83 ec 04             	sub    $0x4,%esp
80102b80:	68 80 00 00 00       	push   $0x80
80102b85:	50                   	push   %eax
80102b86:	68 f0 01 00 00       	push   $0x1f0
80102b8b:	e8 ca fc ff ff       	call   8010285a <insl>
80102b90:	83 c4 10             	add    $0x10,%esp
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b96:	8b 00                	mov    (%eax),%eax
80102b98:	83 c8 02             	or     $0x2,%eax
80102b9b:	89 c2                	mov    %eax,%edx
80102b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ba0:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ba5:	8b 00                	mov    (%eax),%eax
80102ba7:	83 e0 fb             	and    $0xfffffffb,%eax
80102baa:	89 c2                	mov    %eax,%edx
80102bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102baf:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102bb1:	83 ec 0c             	sub    $0xc,%esp
80102bb4:	ff 75 f4             	pushl  -0xc(%ebp)
80102bb7:	e8 fc 25 00 00       	call   801051b8 <wakeup>
80102bbc:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102bbf:	a1 74 c6 10 80       	mov    0x8010c674,%eax
80102bc4:	85 c0                	test   %eax,%eax
80102bc6:	74 11                	je     80102bd9 <ideintr+0xc3>
    idestart(idequeue);
80102bc8:	a1 74 c6 10 80       	mov    0x8010c674,%eax
80102bcd:	83 ec 0c             	sub    $0xc,%esp
80102bd0:	50                   	push   %eax
80102bd1:	e8 e2 fd ff ff       	call   801029b8 <idestart>
80102bd6:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
80102bd9:	83 ec 0c             	sub    $0xc,%esp
80102bdc:	68 40 c6 10 80       	push   $0x8010c640
80102be1:	e8 f7 2b 00 00       	call   801057dd <release>
80102be6:	83 c4 10             	add    $0x10,%esp
}
80102be9:	c9                   	leave  
80102bea:	c3                   	ret    

80102beb <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102beb:	55                   	push   %ebp
80102bec:	89 e5                	mov    %esp,%ebp
80102bee:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
80102bf1:	8b 45 08             	mov    0x8(%ebp),%eax
80102bf4:	8b 00                	mov    (%eax),%eax
80102bf6:	83 e0 01             	and    $0x1,%eax
80102bf9:	85 c0                	test   %eax,%eax
80102bfb:	75 0d                	jne    80102c0a <iderw+0x1f>
    panic("iderw: buf not busy");
80102bfd:	83 ec 0c             	sub    $0xc,%esp
80102c00:	68 d1 90 10 80       	push   $0x801090d1
80102c05:	e8 5c d9 ff ff       	call   80100566 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102c0a:	8b 45 08             	mov    0x8(%ebp),%eax
80102c0d:	8b 00                	mov    (%eax),%eax
80102c0f:	83 e0 06             	and    $0x6,%eax
80102c12:	83 f8 02             	cmp    $0x2,%eax
80102c15:	75 0d                	jne    80102c24 <iderw+0x39>
    panic("iderw: nothing to do");
80102c17:	83 ec 0c             	sub    $0xc,%esp
80102c1a:	68 e5 90 10 80       	push   $0x801090e5
80102c1f:	e8 42 d9 ff ff       	call   80100566 <panic>
  if(b->dev != 0 && !havedisk1)
80102c24:	8b 45 08             	mov    0x8(%ebp),%eax
80102c27:	8b 40 04             	mov    0x4(%eax),%eax
80102c2a:	85 c0                	test   %eax,%eax
80102c2c:	74 16                	je     80102c44 <iderw+0x59>
80102c2e:	a1 78 c6 10 80       	mov    0x8010c678,%eax
80102c33:	85 c0                	test   %eax,%eax
80102c35:	75 0d                	jne    80102c44 <iderw+0x59>
    panic("iderw: ide disk 1 not present");
80102c37:	83 ec 0c             	sub    $0xc,%esp
80102c3a:	68 fa 90 10 80       	push   $0x801090fa
80102c3f:	e8 22 d9 ff ff       	call   80100566 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102c44:	83 ec 0c             	sub    $0xc,%esp
80102c47:	68 40 c6 10 80       	push   $0x8010c640
80102c4c:	e8 25 2b 00 00       	call   80105776 <acquire>
80102c51:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
80102c54:	8b 45 08             	mov    0x8(%ebp),%eax
80102c57:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102c5e:	c7 45 f4 74 c6 10 80 	movl   $0x8010c674,-0xc(%ebp)
80102c65:	eb 0b                	jmp    80102c72 <iderw+0x87>
80102c67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c6a:	8b 00                	mov    (%eax),%eax
80102c6c:	83 c0 14             	add    $0x14,%eax
80102c6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102c72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c75:	8b 00                	mov    (%eax),%eax
80102c77:	85 c0                	test   %eax,%eax
80102c79:	75 ec                	jne    80102c67 <iderw+0x7c>
    ;
  *pp = b;
80102c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c7e:	8b 55 08             	mov    0x8(%ebp),%edx
80102c81:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102c83:	a1 74 c6 10 80       	mov    0x8010c674,%eax
80102c88:	3b 45 08             	cmp    0x8(%ebp),%eax
80102c8b:	75 23                	jne    80102cb0 <iderw+0xc5>
    idestart(b);
80102c8d:	83 ec 0c             	sub    $0xc,%esp
80102c90:	ff 75 08             	pushl  0x8(%ebp)
80102c93:	e8 20 fd ff ff       	call   801029b8 <idestart>
80102c98:	83 c4 10             	add    $0x10,%esp
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102c9b:	eb 13                	jmp    80102cb0 <iderw+0xc5>
    sleep(b, &idelock);
80102c9d:	83 ec 08             	sub    $0x8,%esp
80102ca0:	68 40 c6 10 80       	push   $0x8010c640
80102ca5:	ff 75 08             	pushl  0x8(%ebp)
80102ca8:	e8 24 24 00 00       	call   801050d1 <sleep>
80102cad:	83 c4 10             	add    $0x10,%esp
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102cb0:	8b 45 08             	mov    0x8(%ebp),%eax
80102cb3:	8b 00                	mov    (%eax),%eax
80102cb5:	83 e0 06             	and    $0x6,%eax
80102cb8:	83 f8 02             	cmp    $0x2,%eax
80102cbb:	75 e0                	jne    80102c9d <iderw+0xb2>
    sleep(b, &idelock);
  }

  release(&idelock);
80102cbd:	83 ec 0c             	sub    $0xc,%esp
80102cc0:	68 40 c6 10 80       	push   $0x8010c640
80102cc5:	e8 13 2b 00 00       	call   801057dd <release>
80102cca:	83 c4 10             	add    $0x10,%esp
}
80102ccd:	90                   	nop
80102cce:	c9                   	leave  
80102ccf:	c3                   	ret    

80102cd0 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102cd0:	55                   	push   %ebp
80102cd1:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102cd3:	a1 54 32 11 80       	mov    0x80113254,%eax
80102cd8:	8b 55 08             	mov    0x8(%ebp),%edx
80102cdb:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102cdd:	a1 54 32 11 80       	mov    0x80113254,%eax
80102ce2:	8b 40 10             	mov    0x10(%eax),%eax
}
80102ce5:	5d                   	pop    %ebp
80102ce6:	c3                   	ret    

80102ce7 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102ce7:	55                   	push   %ebp
80102ce8:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102cea:	a1 54 32 11 80       	mov    0x80113254,%eax
80102cef:	8b 55 08             	mov    0x8(%ebp),%edx
80102cf2:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102cf4:	a1 54 32 11 80       	mov    0x80113254,%eax
80102cf9:	8b 55 0c             	mov    0xc(%ebp),%edx
80102cfc:	89 50 10             	mov    %edx,0x10(%eax)
}
80102cff:	90                   	nop
80102d00:	5d                   	pop    %ebp
80102d01:	c3                   	ret    

80102d02 <ioapicinit>:

void
ioapicinit(void)
{
80102d02:	55                   	push   %ebp
80102d03:	89 e5                	mov    %esp,%ebp
80102d05:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if(!ismp)
80102d08:	a1 84 33 11 80       	mov    0x80113384,%eax
80102d0d:	85 c0                	test   %eax,%eax
80102d0f:	0f 84 a0 00 00 00    	je     80102db5 <ioapicinit+0xb3>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102d15:	c7 05 54 32 11 80 00 	movl   $0xfec00000,0x80113254
80102d1c:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102d1f:	6a 01                	push   $0x1
80102d21:	e8 aa ff ff ff       	call   80102cd0 <ioapicread>
80102d26:	83 c4 04             	add    $0x4,%esp
80102d29:	c1 e8 10             	shr    $0x10,%eax
80102d2c:	25 ff 00 00 00       	and    $0xff,%eax
80102d31:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102d34:	6a 00                	push   $0x0
80102d36:	e8 95 ff ff ff       	call   80102cd0 <ioapicread>
80102d3b:	83 c4 04             	add    $0x4,%esp
80102d3e:	c1 e8 18             	shr    $0x18,%eax
80102d41:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102d44:	0f b6 05 80 33 11 80 	movzbl 0x80113380,%eax
80102d4b:	0f b6 c0             	movzbl %al,%eax
80102d4e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102d51:	74 10                	je     80102d63 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102d53:	83 ec 0c             	sub    $0xc,%esp
80102d56:	68 18 91 10 80       	push   $0x80109118
80102d5b:	e8 66 d6 ff ff       	call   801003c6 <cprintf>
80102d60:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102d63:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102d6a:	eb 3f                	jmp    80102dab <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102d6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d6f:	83 c0 20             	add    $0x20,%eax
80102d72:	0d 00 00 01 00       	or     $0x10000,%eax
80102d77:	89 c2                	mov    %eax,%edx
80102d79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d7c:	83 c0 08             	add    $0x8,%eax
80102d7f:	01 c0                	add    %eax,%eax
80102d81:	83 ec 08             	sub    $0x8,%esp
80102d84:	52                   	push   %edx
80102d85:	50                   	push   %eax
80102d86:	e8 5c ff ff ff       	call   80102ce7 <ioapicwrite>
80102d8b:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d91:	83 c0 08             	add    $0x8,%eax
80102d94:	01 c0                	add    %eax,%eax
80102d96:	83 c0 01             	add    $0x1,%eax
80102d99:	83 ec 08             	sub    $0x8,%esp
80102d9c:	6a 00                	push   $0x0
80102d9e:	50                   	push   %eax
80102d9f:	e8 43 ff ff ff       	call   80102ce7 <ioapicwrite>
80102da4:	83 c4 10             	add    $0x10,%esp
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102da7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102dae:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102db1:	7e b9                	jle    80102d6c <ioapicinit+0x6a>
80102db3:	eb 01                	jmp    80102db6 <ioapicinit+0xb4>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
80102db5:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102db6:	c9                   	leave  
80102db7:	c3                   	ret    

80102db8 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102db8:	55                   	push   %ebp
80102db9:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102dbb:	a1 84 33 11 80       	mov    0x80113384,%eax
80102dc0:	85 c0                	test   %eax,%eax
80102dc2:	74 39                	je     80102dfd <ioapicenable+0x45>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102dc4:	8b 45 08             	mov    0x8(%ebp),%eax
80102dc7:	83 c0 20             	add    $0x20,%eax
80102dca:	89 c2                	mov    %eax,%edx
80102dcc:	8b 45 08             	mov    0x8(%ebp),%eax
80102dcf:	83 c0 08             	add    $0x8,%eax
80102dd2:	01 c0                	add    %eax,%eax
80102dd4:	52                   	push   %edx
80102dd5:	50                   	push   %eax
80102dd6:	e8 0c ff ff ff       	call   80102ce7 <ioapicwrite>
80102ddb:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102dde:	8b 45 0c             	mov    0xc(%ebp),%eax
80102de1:	c1 e0 18             	shl    $0x18,%eax
80102de4:	89 c2                	mov    %eax,%edx
80102de6:	8b 45 08             	mov    0x8(%ebp),%eax
80102de9:	83 c0 08             	add    $0x8,%eax
80102dec:	01 c0                	add    %eax,%eax
80102dee:	83 c0 01             	add    $0x1,%eax
80102df1:	52                   	push   %edx
80102df2:	50                   	push   %eax
80102df3:	e8 ef fe ff ff       	call   80102ce7 <ioapicwrite>
80102df8:	83 c4 08             	add    $0x8,%esp
80102dfb:	eb 01                	jmp    80102dfe <ioapicenable+0x46>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
80102dfd:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102dfe:	c9                   	leave  
80102dff:	c3                   	ret    

80102e00 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102e00:	55                   	push   %ebp
80102e01:	89 e5                	mov    %esp,%ebp
80102e03:	8b 45 08             	mov    0x8(%ebp),%eax
80102e06:	05 00 00 00 80       	add    $0x80000000,%eax
80102e0b:	5d                   	pop    %ebp
80102e0c:	c3                   	ret    

80102e0d <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102e0d:	55                   	push   %ebp
80102e0e:	89 e5                	mov    %esp,%ebp
80102e10:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102e13:	83 ec 08             	sub    $0x8,%esp
80102e16:	68 4a 91 10 80       	push   $0x8010914a
80102e1b:	68 60 32 11 80       	push   $0x80113260
80102e20:	e8 2f 29 00 00       	call   80105754 <initlock>
80102e25:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102e28:	c7 05 94 32 11 80 00 	movl   $0x0,0x80113294
80102e2f:	00 00 00 
  freerange(vstart, vend);
80102e32:	83 ec 08             	sub    $0x8,%esp
80102e35:	ff 75 0c             	pushl  0xc(%ebp)
80102e38:	ff 75 08             	pushl  0x8(%ebp)
80102e3b:	e8 2a 00 00 00       	call   80102e6a <freerange>
80102e40:	83 c4 10             	add    $0x10,%esp
}
80102e43:	90                   	nop
80102e44:	c9                   	leave  
80102e45:	c3                   	ret    

80102e46 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102e46:	55                   	push   %ebp
80102e47:	89 e5                	mov    %esp,%ebp
80102e49:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102e4c:	83 ec 08             	sub    $0x8,%esp
80102e4f:	ff 75 0c             	pushl  0xc(%ebp)
80102e52:	ff 75 08             	pushl  0x8(%ebp)
80102e55:	e8 10 00 00 00       	call   80102e6a <freerange>
80102e5a:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102e5d:	c7 05 94 32 11 80 01 	movl   $0x1,0x80113294
80102e64:	00 00 00 
}
80102e67:	90                   	nop
80102e68:	c9                   	leave  
80102e69:	c3                   	ret    

80102e6a <freerange>:

void
freerange(void *vstart, void *vend)
{
80102e6a:	55                   	push   %ebp
80102e6b:	89 e5                	mov    %esp,%ebp
80102e6d:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102e70:	8b 45 08             	mov    0x8(%ebp),%eax
80102e73:	05 ff 0f 00 00       	add    $0xfff,%eax
80102e78:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102e7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e80:	eb 15                	jmp    80102e97 <freerange+0x2d>
    kfree(p);
80102e82:	83 ec 0c             	sub    $0xc,%esp
80102e85:	ff 75 f4             	pushl  -0xc(%ebp)
80102e88:	e8 1a 00 00 00       	call   80102ea7 <kfree>
80102e8d:	83 c4 10             	add    $0x10,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102e90:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102e97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e9a:	05 00 10 00 00       	add    $0x1000,%eax
80102e9f:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102ea2:	76 de                	jbe    80102e82 <freerange+0x18>
    kfree(p);
}
80102ea4:	90                   	nop
80102ea5:	c9                   	leave  
80102ea6:	c3                   	ret    

80102ea7 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102ea7:	55                   	push   %ebp
80102ea8:	89 e5                	mov    %esp,%ebp
80102eaa:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102ead:	8b 45 08             	mov    0x8(%ebp),%eax
80102eb0:	25 ff 0f 00 00       	and    $0xfff,%eax
80102eb5:	85 c0                	test   %eax,%eax
80102eb7:	75 1b                	jne    80102ed4 <kfree+0x2d>
80102eb9:	81 7d 08 3c 66 11 80 	cmpl   $0x8011663c,0x8(%ebp)
80102ec0:	72 12                	jb     80102ed4 <kfree+0x2d>
80102ec2:	ff 75 08             	pushl  0x8(%ebp)
80102ec5:	e8 36 ff ff ff       	call   80102e00 <v2p>
80102eca:	83 c4 04             	add    $0x4,%esp
80102ecd:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102ed2:	76 0d                	jbe    80102ee1 <kfree+0x3a>
    panic("kfree");
80102ed4:	83 ec 0c             	sub    $0xc,%esp
80102ed7:	68 4f 91 10 80       	push   $0x8010914f
80102edc:	e8 85 d6 ff ff       	call   80100566 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102ee1:	83 ec 04             	sub    $0x4,%esp
80102ee4:	68 00 10 00 00       	push   $0x1000
80102ee9:	6a 01                	push   $0x1
80102eeb:	ff 75 08             	pushl  0x8(%ebp)
80102eee:	e8 e6 2a 00 00       	call   801059d9 <memset>
80102ef3:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102ef6:	a1 94 32 11 80       	mov    0x80113294,%eax
80102efb:	85 c0                	test   %eax,%eax
80102efd:	74 10                	je     80102f0f <kfree+0x68>
    acquire(&kmem.lock);
80102eff:	83 ec 0c             	sub    $0xc,%esp
80102f02:	68 60 32 11 80       	push   $0x80113260
80102f07:	e8 6a 28 00 00       	call   80105776 <acquire>
80102f0c:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102f0f:	8b 45 08             	mov    0x8(%ebp),%eax
80102f12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102f15:	8b 15 98 32 11 80    	mov    0x80113298,%edx
80102f1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102f1e:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102f20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102f23:	a3 98 32 11 80       	mov    %eax,0x80113298
  if(kmem.use_lock)
80102f28:	a1 94 32 11 80       	mov    0x80113294,%eax
80102f2d:	85 c0                	test   %eax,%eax
80102f2f:	74 10                	je     80102f41 <kfree+0x9a>
    release(&kmem.lock);
80102f31:	83 ec 0c             	sub    $0xc,%esp
80102f34:	68 60 32 11 80       	push   $0x80113260
80102f39:	e8 9f 28 00 00       	call   801057dd <release>
80102f3e:	83 c4 10             	add    $0x10,%esp
}
80102f41:	90                   	nop
80102f42:	c9                   	leave  
80102f43:	c3                   	ret    

80102f44 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102f44:	55                   	push   %ebp
80102f45:	89 e5                	mov    %esp,%ebp
80102f47:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102f4a:	a1 94 32 11 80       	mov    0x80113294,%eax
80102f4f:	85 c0                	test   %eax,%eax
80102f51:	74 10                	je     80102f63 <kalloc+0x1f>
    acquire(&kmem.lock);
80102f53:	83 ec 0c             	sub    $0xc,%esp
80102f56:	68 60 32 11 80       	push   $0x80113260
80102f5b:	e8 16 28 00 00       	call   80105776 <acquire>
80102f60:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102f63:	a1 98 32 11 80       	mov    0x80113298,%eax
80102f68:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102f6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102f6f:	74 0a                	je     80102f7b <kalloc+0x37>
    kmem.freelist = r->next;
80102f71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102f74:	8b 00                	mov    (%eax),%eax
80102f76:	a3 98 32 11 80       	mov    %eax,0x80113298
  if(kmem.use_lock)
80102f7b:	a1 94 32 11 80       	mov    0x80113294,%eax
80102f80:	85 c0                	test   %eax,%eax
80102f82:	74 10                	je     80102f94 <kalloc+0x50>
    release(&kmem.lock);
80102f84:	83 ec 0c             	sub    $0xc,%esp
80102f87:	68 60 32 11 80       	push   $0x80113260
80102f8c:	e8 4c 28 00 00       	call   801057dd <release>
80102f91:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102f94:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102f97:	c9                   	leave  
80102f98:	c3                   	ret    

80102f99 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80102f99:	55                   	push   %ebp
80102f9a:	89 e5                	mov    %esp,%ebp
80102f9c:	83 ec 14             	sub    $0x14,%esp
80102f9f:	8b 45 08             	mov    0x8(%ebp),%eax
80102fa2:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102fa6:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102faa:	89 c2                	mov    %eax,%edx
80102fac:	ec                   	in     (%dx),%al
80102fad:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102fb0:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102fb4:	c9                   	leave  
80102fb5:	c3                   	ret    

80102fb6 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102fb6:	55                   	push   %ebp
80102fb7:	89 e5                	mov    %esp,%ebp
80102fb9:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102fbc:	6a 64                	push   $0x64
80102fbe:	e8 d6 ff ff ff       	call   80102f99 <inb>
80102fc3:	83 c4 04             	add    $0x4,%esp
80102fc6:	0f b6 c0             	movzbl %al,%eax
80102fc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102fcf:	83 e0 01             	and    $0x1,%eax
80102fd2:	85 c0                	test   %eax,%eax
80102fd4:	75 0a                	jne    80102fe0 <kbdgetc+0x2a>
    return -1;
80102fd6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102fdb:	e9 23 01 00 00       	jmp    80103103 <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102fe0:	6a 60                	push   $0x60
80102fe2:	e8 b2 ff ff ff       	call   80102f99 <inb>
80102fe7:	83 c4 04             	add    $0x4,%esp
80102fea:	0f b6 c0             	movzbl %al,%eax
80102fed:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102ff0:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102ff7:	75 17                	jne    80103010 <kbdgetc+0x5a>
    shift |= E0ESC;
80102ff9:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
80102ffe:	83 c8 40             	or     $0x40,%eax
80103001:	a3 7c c6 10 80       	mov    %eax,0x8010c67c
    return 0;
80103006:	b8 00 00 00 00       	mov    $0x0,%eax
8010300b:	e9 f3 00 00 00       	jmp    80103103 <kbdgetc+0x14d>
  } else if(data & 0x80){
80103010:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103013:	25 80 00 00 00       	and    $0x80,%eax
80103018:	85 c0                	test   %eax,%eax
8010301a:	74 45                	je     80103061 <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
8010301c:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
80103021:	83 e0 40             	and    $0x40,%eax
80103024:	85 c0                	test   %eax,%eax
80103026:	75 08                	jne    80103030 <kbdgetc+0x7a>
80103028:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010302b:	83 e0 7f             	and    $0x7f,%eax
8010302e:	eb 03                	jmp    80103033 <kbdgetc+0x7d>
80103030:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103033:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80103036:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103039:	05 20 a0 10 80       	add    $0x8010a020,%eax
8010303e:	0f b6 00             	movzbl (%eax),%eax
80103041:	83 c8 40             	or     $0x40,%eax
80103044:	0f b6 c0             	movzbl %al,%eax
80103047:	f7 d0                	not    %eax
80103049:	89 c2                	mov    %eax,%edx
8010304b:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
80103050:	21 d0                	and    %edx,%eax
80103052:	a3 7c c6 10 80       	mov    %eax,0x8010c67c
    return 0;
80103057:	b8 00 00 00 00       	mov    $0x0,%eax
8010305c:	e9 a2 00 00 00       	jmp    80103103 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80103061:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
80103066:	83 e0 40             	and    $0x40,%eax
80103069:	85 c0                	test   %eax,%eax
8010306b:	74 14                	je     80103081 <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010306d:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80103074:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
80103079:	83 e0 bf             	and    $0xffffffbf,%eax
8010307c:	a3 7c c6 10 80       	mov    %eax,0x8010c67c
  }

  shift |= shiftcode[data];
80103081:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103084:	05 20 a0 10 80       	add    $0x8010a020,%eax
80103089:	0f b6 00             	movzbl (%eax),%eax
8010308c:	0f b6 d0             	movzbl %al,%edx
8010308f:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
80103094:	09 d0                	or     %edx,%eax
80103096:	a3 7c c6 10 80       	mov    %eax,0x8010c67c
  shift ^= togglecode[data];
8010309b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010309e:	05 20 a1 10 80       	add    $0x8010a120,%eax
801030a3:	0f b6 00             	movzbl (%eax),%eax
801030a6:	0f b6 d0             	movzbl %al,%edx
801030a9:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
801030ae:	31 d0                	xor    %edx,%eax
801030b0:	a3 7c c6 10 80       	mov    %eax,0x8010c67c
  c = charcode[shift & (CTL | SHIFT)][data];
801030b5:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
801030ba:	83 e0 03             	and    $0x3,%eax
801030bd:	8b 14 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%edx
801030c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801030c7:	01 d0                	add    %edx,%eax
801030c9:	0f b6 00             	movzbl (%eax),%eax
801030cc:	0f b6 c0             	movzbl %al,%eax
801030cf:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
801030d2:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
801030d7:	83 e0 08             	and    $0x8,%eax
801030da:	85 c0                	test   %eax,%eax
801030dc:	74 22                	je     80103100 <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
801030de:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
801030e2:	76 0c                	jbe    801030f0 <kbdgetc+0x13a>
801030e4:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
801030e8:	77 06                	ja     801030f0 <kbdgetc+0x13a>
      c += 'A' - 'a';
801030ea:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
801030ee:	eb 10                	jmp    80103100 <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
801030f0:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
801030f4:	76 0a                	jbe    80103100 <kbdgetc+0x14a>
801030f6:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
801030fa:	77 04                	ja     80103100 <kbdgetc+0x14a>
      c += 'a' - 'A';
801030fc:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80103100:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103103:	c9                   	leave  
80103104:	c3                   	ret    

80103105 <kbdintr>:

void
kbdintr(void)
{
80103105:	55                   	push   %ebp
80103106:	89 e5                	mov    %esp,%ebp
80103108:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
8010310b:	83 ec 0c             	sub    $0xc,%esp
8010310e:	68 b6 2f 10 80       	push   $0x80102fb6
80103113:	e8 e1 d6 ff ff       	call   801007f9 <consoleintr>
80103118:	83 c4 10             	add    $0x10,%esp
}
8010311b:	90                   	nop
8010311c:	c9                   	leave  
8010311d:	c3                   	ret    

8010311e <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
8010311e:	55                   	push   %ebp
8010311f:	89 e5                	mov    %esp,%ebp
80103121:	83 ec 14             	sub    $0x14,%esp
80103124:	8b 45 08             	mov    0x8(%ebp),%eax
80103127:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010312b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010312f:	89 c2                	mov    %eax,%edx
80103131:	ec                   	in     (%dx),%al
80103132:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103135:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103139:	c9                   	leave  
8010313a:	c3                   	ret    

8010313b <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
8010313b:	55                   	push   %ebp
8010313c:	89 e5                	mov    %esp,%ebp
8010313e:	83 ec 08             	sub    $0x8,%esp
80103141:	8b 55 08             	mov    0x8(%ebp),%edx
80103144:	8b 45 0c             	mov    0xc(%ebp),%eax
80103147:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010314b:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010314e:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103152:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103156:	ee                   	out    %al,(%dx)
}
80103157:	90                   	nop
80103158:	c9                   	leave  
80103159:	c3                   	ret    

8010315a <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
8010315a:	55                   	push   %ebp
8010315b:	89 e5                	mov    %esp,%ebp
8010315d:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103160:	9c                   	pushf  
80103161:	58                   	pop    %eax
80103162:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80103165:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103168:	c9                   	leave  
80103169:	c3                   	ret    

8010316a <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
8010316a:	55                   	push   %ebp
8010316b:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
8010316d:	a1 9c 32 11 80       	mov    0x8011329c,%eax
80103172:	8b 55 08             	mov    0x8(%ebp),%edx
80103175:	c1 e2 02             	shl    $0x2,%edx
80103178:	01 c2                	add    %eax,%edx
8010317a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010317d:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
8010317f:	a1 9c 32 11 80       	mov    0x8011329c,%eax
80103184:	83 c0 20             	add    $0x20,%eax
80103187:	8b 00                	mov    (%eax),%eax
}
80103189:	90                   	nop
8010318a:	5d                   	pop    %ebp
8010318b:	c3                   	ret    

8010318c <lapicinit>:

void
lapicinit(void)
{
8010318c:	55                   	push   %ebp
8010318d:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
8010318f:	a1 9c 32 11 80       	mov    0x8011329c,%eax
80103194:	85 c0                	test   %eax,%eax
80103196:	0f 84 0b 01 00 00    	je     801032a7 <lapicinit+0x11b>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
8010319c:	68 3f 01 00 00       	push   $0x13f
801031a1:	6a 3c                	push   $0x3c
801031a3:	e8 c2 ff ff ff       	call   8010316a <lapicw>
801031a8:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
801031ab:	6a 0b                	push   $0xb
801031ad:	68 f8 00 00 00       	push   $0xf8
801031b2:	e8 b3 ff ff ff       	call   8010316a <lapicw>
801031b7:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
801031ba:	68 20 00 02 00       	push   $0x20020
801031bf:	68 c8 00 00 00       	push   $0xc8
801031c4:	e8 a1 ff ff ff       	call   8010316a <lapicw>
801031c9:	83 c4 08             	add    $0x8,%esp
  // lapicw(TICR, 10000000); 
  lapicw(TICR, 1000000000/TPS); // PSU CS333. Makes ticks per second programmable
801031cc:	68 40 42 0f 00       	push   $0xf4240
801031d1:	68 e0 00 00 00       	push   $0xe0
801031d6:	e8 8f ff ff ff       	call   8010316a <lapicw>
801031db:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
801031de:	68 00 00 01 00       	push   $0x10000
801031e3:	68 d4 00 00 00       	push   $0xd4
801031e8:	e8 7d ff ff ff       	call   8010316a <lapicw>
801031ed:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
801031f0:	68 00 00 01 00       	push   $0x10000
801031f5:	68 d8 00 00 00       	push   $0xd8
801031fa:	e8 6b ff ff ff       	call   8010316a <lapicw>
801031ff:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80103202:	a1 9c 32 11 80       	mov    0x8011329c,%eax
80103207:	83 c0 30             	add    $0x30,%eax
8010320a:	8b 00                	mov    (%eax),%eax
8010320c:	c1 e8 10             	shr    $0x10,%eax
8010320f:	0f b6 c0             	movzbl %al,%eax
80103212:	83 f8 03             	cmp    $0x3,%eax
80103215:	76 12                	jbe    80103229 <lapicinit+0x9d>
    lapicw(PCINT, MASKED);
80103217:	68 00 00 01 00       	push   $0x10000
8010321c:	68 d0 00 00 00       	push   $0xd0
80103221:	e8 44 ff ff ff       	call   8010316a <lapicw>
80103226:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80103229:	6a 33                	push   $0x33
8010322b:	68 dc 00 00 00       	push   $0xdc
80103230:	e8 35 ff ff ff       	call   8010316a <lapicw>
80103235:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80103238:	6a 00                	push   $0x0
8010323a:	68 a0 00 00 00       	push   $0xa0
8010323f:	e8 26 ff ff ff       	call   8010316a <lapicw>
80103244:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80103247:	6a 00                	push   $0x0
80103249:	68 a0 00 00 00       	push   $0xa0
8010324e:	e8 17 ff ff ff       	call   8010316a <lapicw>
80103253:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80103256:	6a 00                	push   $0x0
80103258:	6a 2c                	push   $0x2c
8010325a:	e8 0b ff ff ff       	call   8010316a <lapicw>
8010325f:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80103262:	6a 00                	push   $0x0
80103264:	68 c4 00 00 00       	push   $0xc4
80103269:	e8 fc fe ff ff       	call   8010316a <lapicw>
8010326e:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80103271:	68 00 85 08 00       	push   $0x88500
80103276:	68 c0 00 00 00       	push   $0xc0
8010327b:	e8 ea fe ff ff       	call   8010316a <lapicw>
80103280:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80103283:	90                   	nop
80103284:	a1 9c 32 11 80       	mov    0x8011329c,%eax
80103289:	05 00 03 00 00       	add    $0x300,%eax
8010328e:	8b 00                	mov    (%eax),%eax
80103290:	25 00 10 00 00       	and    $0x1000,%eax
80103295:	85 c0                	test   %eax,%eax
80103297:	75 eb                	jne    80103284 <lapicinit+0xf8>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80103299:	6a 00                	push   $0x0
8010329b:	6a 20                	push   $0x20
8010329d:	e8 c8 fe ff ff       	call   8010316a <lapicw>
801032a2:	83 c4 08             	add    $0x8,%esp
801032a5:	eb 01                	jmp    801032a8 <lapicinit+0x11c>

void
lapicinit(void)
{
  if(!lapic) 
    return;
801032a7:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801032a8:	c9                   	leave  
801032a9:	c3                   	ret    

801032aa <cpunum>:

int
cpunum(void)
{
801032aa:	55                   	push   %ebp
801032ab:	89 e5                	mov    %esp,%ebp
801032ad:	83 ec 08             	sub    $0x8,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
801032b0:	e8 a5 fe ff ff       	call   8010315a <readeflags>
801032b5:	25 00 02 00 00       	and    $0x200,%eax
801032ba:	85 c0                	test   %eax,%eax
801032bc:	74 26                	je     801032e4 <cpunum+0x3a>
    static int n;
    if(n++ == 0)
801032be:	a1 80 c6 10 80       	mov    0x8010c680,%eax
801032c3:	8d 50 01             	lea    0x1(%eax),%edx
801032c6:	89 15 80 c6 10 80    	mov    %edx,0x8010c680
801032cc:	85 c0                	test   %eax,%eax
801032ce:	75 14                	jne    801032e4 <cpunum+0x3a>
      cprintf("cpu called from %x with interrupts enabled\n",
801032d0:	8b 45 04             	mov    0x4(%ebp),%eax
801032d3:	83 ec 08             	sub    $0x8,%esp
801032d6:	50                   	push   %eax
801032d7:	68 58 91 10 80       	push   $0x80109158
801032dc:	e8 e5 d0 ff ff       	call   801003c6 <cprintf>
801032e1:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
801032e4:	a1 9c 32 11 80       	mov    0x8011329c,%eax
801032e9:	85 c0                	test   %eax,%eax
801032eb:	74 0f                	je     801032fc <cpunum+0x52>
    return lapic[ID]>>24;
801032ed:	a1 9c 32 11 80       	mov    0x8011329c,%eax
801032f2:	83 c0 20             	add    $0x20,%eax
801032f5:	8b 00                	mov    (%eax),%eax
801032f7:	c1 e8 18             	shr    $0x18,%eax
801032fa:	eb 05                	jmp    80103301 <cpunum+0x57>
  return 0;
801032fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103301:	c9                   	leave  
80103302:	c3                   	ret    

80103303 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80103303:	55                   	push   %ebp
80103304:	89 e5                	mov    %esp,%ebp
  if(lapic)
80103306:	a1 9c 32 11 80       	mov    0x8011329c,%eax
8010330b:	85 c0                	test   %eax,%eax
8010330d:	74 0c                	je     8010331b <lapiceoi+0x18>
    lapicw(EOI, 0);
8010330f:	6a 00                	push   $0x0
80103311:	6a 2c                	push   $0x2c
80103313:	e8 52 fe ff ff       	call   8010316a <lapicw>
80103318:	83 c4 08             	add    $0x8,%esp
}
8010331b:	90                   	nop
8010331c:	c9                   	leave  
8010331d:	c3                   	ret    

8010331e <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
8010331e:	55                   	push   %ebp
8010331f:	89 e5                	mov    %esp,%ebp
}
80103321:	90                   	nop
80103322:	5d                   	pop    %ebp
80103323:	c3                   	ret    

80103324 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103324:	55                   	push   %ebp
80103325:	89 e5                	mov    %esp,%ebp
80103327:	83 ec 14             	sub    $0x14,%esp
8010332a:	8b 45 08             	mov    0x8(%ebp),%eax
8010332d:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80103330:	6a 0f                	push   $0xf
80103332:	6a 70                	push   $0x70
80103334:	e8 02 fe ff ff       	call   8010313b <outb>
80103339:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
8010333c:	6a 0a                	push   $0xa
8010333e:	6a 71                	push   $0x71
80103340:	e8 f6 fd ff ff       	call   8010313b <outb>
80103345:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80103348:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
8010334f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103352:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80103357:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010335a:	83 c0 02             	add    $0x2,%eax
8010335d:	8b 55 0c             	mov    0xc(%ebp),%edx
80103360:	c1 ea 04             	shr    $0x4,%edx
80103363:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103366:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
8010336a:	c1 e0 18             	shl    $0x18,%eax
8010336d:	50                   	push   %eax
8010336e:	68 c4 00 00 00       	push   $0xc4
80103373:	e8 f2 fd ff ff       	call   8010316a <lapicw>
80103378:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
8010337b:	68 00 c5 00 00       	push   $0xc500
80103380:	68 c0 00 00 00       	push   $0xc0
80103385:	e8 e0 fd ff ff       	call   8010316a <lapicw>
8010338a:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
8010338d:	68 c8 00 00 00       	push   $0xc8
80103392:	e8 87 ff ff ff       	call   8010331e <microdelay>
80103397:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
8010339a:	68 00 85 00 00       	push   $0x8500
8010339f:	68 c0 00 00 00       	push   $0xc0
801033a4:	e8 c1 fd ff ff       	call   8010316a <lapicw>
801033a9:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
801033ac:	6a 64                	push   $0x64
801033ae:	e8 6b ff ff ff       	call   8010331e <microdelay>
801033b3:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801033b6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801033bd:	eb 3d                	jmp    801033fc <lapicstartap+0xd8>
    lapicw(ICRHI, apicid<<24);
801033bf:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
801033c3:	c1 e0 18             	shl    $0x18,%eax
801033c6:	50                   	push   %eax
801033c7:	68 c4 00 00 00       	push   $0xc4
801033cc:	e8 99 fd ff ff       	call   8010316a <lapicw>
801033d1:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
801033d4:	8b 45 0c             	mov    0xc(%ebp),%eax
801033d7:	c1 e8 0c             	shr    $0xc,%eax
801033da:	80 cc 06             	or     $0x6,%ah
801033dd:	50                   	push   %eax
801033de:	68 c0 00 00 00       	push   $0xc0
801033e3:	e8 82 fd ff ff       	call   8010316a <lapicw>
801033e8:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
801033eb:	68 c8 00 00 00       	push   $0xc8
801033f0:	e8 29 ff ff ff       	call   8010331e <microdelay>
801033f5:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801033f8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801033fc:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80103400:	7e bd                	jle    801033bf <lapicstartap+0x9b>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80103402:	90                   	nop
80103403:	c9                   	leave  
80103404:	c3                   	ret    

80103405 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
80103405:	55                   	push   %ebp
80103406:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
80103408:	8b 45 08             	mov    0x8(%ebp),%eax
8010340b:	0f b6 c0             	movzbl %al,%eax
8010340e:	50                   	push   %eax
8010340f:	6a 70                	push   $0x70
80103411:	e8 25 fd ff ff       	call   8010313b <outb>
80103416:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80103419:	68 c8 00 00 00       	push   $0xc8
8010341e:	e8 fb fe ff ff       	call   8010331e <microdelay>
80103423:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
80103426:	6a 71                	push   $0x71
80103428:	e8 f1 fc ff ff       	call   8010311e <inb>
8010342d:	83 c4 04             	add    $0x4,%esp
80103430:	0f b6 c0             	movzbl %al,%eax
}
80103433:	c9                   	leave  
80103434:	c3                   	ret    

80103435 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
80103435:	55                   	push   %ebp
80103436:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
80103438:	6a 00                	push   $0x0
8010343a:	e8 c6 ff ff ff       	call   80103405 <cmos_read>
8010343f:	83 c4 04             	add    $0x4,%esp
80103442:	89 c2                	mov    %eax,%edx
80103444:	8b 45 08             	mov    0x8(%ebp),%eax
80103447:	89 10                	mov    %edx,(%eax)
  r->minute = cmos_read(MINS);
80103449:	6a 02                	push   $0x2
8010344b:	e8 b5 ff ff ff       	call   80103405 <cmos_read>
80103450:	83 c4 04             	add    $0x4,%esp
80103453:	89 c2                	mov    %eax,%edx
80103455:	8b 45 08             	mov    0x8(%ebp),%eax
80103458:	89 50 04             	mov    %edx,0x4(%eax)
  r->hour   = cmos_read(HOURS);
8010345b:	6a 04                	push   $0x4
8010345d:	e8 a3 ff ff ff       	call   80103405 <cmos_read>
80103462:	83 c4 04             	add    $0x4,%esp
80103465:	89 c2                	mov    %eax,%edx
80103467:	8b 45 08             	mov    0x8(%ebp),%eax
8010346a:	89 50 08             	mov    %edx,0x8(%eax)
  r->day    = cmos_read(DAY);
8010346d:	6a 07                	push   $0x7
8010346f:	e8 91 ff ff ff       	call   80103405 <cmos_read>
80103474:	83 c4 04             	add    $0x4,%esp
80103477:	89 c2                	mov    %eax,%edx
80103479:	8b 45 08             	mov    0x8(%ebp),%eax
8010347c:	89 50 0c             	mov    %edx,0xc(%eax)
  r->month  = cmos_read(MONTH);
8010347f:	6a 08                	push   $0x8
80103481:	e8 7f ff ff ff       	call   80103405 <cmos_read>
80103486:	83 c4 04             	add    $0x4,%esp
80103489:	89 c2                	mov    %eax,%edx
8010348b:	8b 45 08             	mov    0x8(%ebp),%eax
8010348e:	89 50 10             	mov    %edx,0x10(%eax)
  r->year   = cmos_read(YEAR);
80103491:	6a 09                	push   $0x9
80103493:	e8 6d ff ff ff       	call   80103405 <cmos_read>
80103498:	83 c4 04             	add    $0x4,%esp
8010349b:	89 c2                	mov    %eax,%edx
8010349d:	8b 45 08             	mov    0x8(%ebp),%eax
801034a0:	89 50 14             	mov    %edx,0x14(%eax)
}
801034a3:	90                   	nop
801034a4:	c9                   	leave  
801034a5:	c3                   	ret    

801034a6 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801034a6:	55                   	push   %ebp
801034a7:	89 e5                	mov    %esp,%ebp
801034a9:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
801034ac:	6a 0b                	push   $0xb
801034ae:	e8 52 ff ff ff       	call   80103405 <cmos_read>
801034b3:	83 c4 04             	add    $0x4,%esp
801034b6:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
801034b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801034bc:	83 e0 04             	and    $0x4,%eax
801034bf:	85 c0                	test   %eax,%eax
801034c1:	0f 94 c0             	sete   %al
801034c4:	0f b6 c0             	movzbl %al,%eax
801034c7:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
801034ca:	8d 45 d8             	lea    -0x28(%ebp),%eax
801034cd:	50                   	push   %eax
801034ce:	e8 62 ff ff ff       	call   80103435 <fill_rtcdate>
801034d3:	83 c4 04             	add    $0x4,%esp
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
801034d6:	6a 0a                	push   $0xa
801034d8:	e8 28 ff ff ff       	call   80103405 <cmos_read>
801034dd:	83 c4 04             	add    $0x4,%esp
801034e0:	25 80 00 00 00       	and    $0x80,%eax
801034e5:	85 c0                	test   %eax,%eax
801034e7:	75 27                	jne    80103510 <cmostime+0x6a>
        continue;
    fill_rtcdate(&t2);
801034e9:	8d 45 c0             	lea    -0x40(%ebp),%eax
801034ec:	50                   	push   %eax
801034ed:	e8 43 ff ff ff       	call   80103435 <fill_rtcdate>
801034f2:	83 c4 04             	add    $0x4,%esp
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
801034f5:	83 ec 04             	sub    $0x4,%esp
801034f8:	6a 18                	push   $0x18
801034fa:	8d 45 c0             	lea    -0x40(%ebp),%eax
801034fd:	50                   	push   %eax
801034fe:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103501:	50                   	push   %eax
80103502:	e8 39 25 00 00       	call   80105a40 <memcmp>
80103507:	83 c4 10             	add    $0x10,%esp
8010350a:	85 c0                	test   %eax,%eax
8010350c:	74 05                	je     80103513 <cmostime+0x6d>
8010350e:	eb ba                	jmp    801034ca <cmostime+0x24>

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
80103510:	90                   	nop
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
80103511:	eb b7                	jmp    801034ca <cmostime+0x24>
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
80103513:	90                   	nop
  }

  // convert
  if (bcd) {
80103514:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103518:	0f 84 b4 00 00 00    	je     801035d2 <cmostime+0x12c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010351e:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103521:	c1 e8 04             	shr    $0x4,%eax
80103524:	89 c2                	mov    %eax,%edx
80103526:	89 d0                	mov    %edx,%eax
80103528:	c1 e0 02             	shl    $0x2,%eax
8010352b:	01 d0                	add    %edx,%eax
8010352d:	01 c0                	add    %eax,%eax
8010352f:	89 c2                	mov    %eax,%edx
80103531:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103534:	83 e0 0f             	and    $0xf,%eax
80103537:	01 d0                	add    %edx,%eax
80103539:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
8010353c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010353f:	c1 e8 04             	shr    $0x4,%eax
80103542:	89 c2                	mov    %eax,%edx
80103544:	89 d0                	mov    %edx,%eax
80103546:	c1 e0 02             	shl    $0x2,%eax
80103549:	01 d0                	add    %edx,%eax
8010354b:	01 c0                	add    %eax,%eax
8010354d:	89 c2                	mov    %eax,%edx
8010354f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103552:	83 e0 0f             	and    $0xf,%eax
80103555:	01 d0                	add    %edx,%eax
80103557:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
8010355a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010355d:	c1 e8 04             	shr    $0x4,%eax
80103560:	89 c2                	mov    %eax,%edx
80103562:	89 d0                	mov    %edx,%eax
80103564:	c1 e0 02             	shl    $0x2,%eax
80103567:	01 d0                	add    %edx,%eax
80103569:	01 c0                	add    %eax,%eax
8010356b:	89 c2                	mov    %eax,%edx
8010356d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103570:	83 e0 0f             	and    $0xf,%eax
80103573:	01 d0                	add    %edx,%eax
80103575:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
80103578:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010357b:	c1 e8 04             	shr    $0x4,%eax
8010357e:	89 c2                	mov    %eax,%edx
80103580:	89 d0                	mov    %edx,%eax
80103582:	c1 e0 02             	shl    $0x2,%eax
80103585:	01 d0                	add    %edx,%eax
80103587:	01 c0                	add    %eax,%eax
80103589:	89 c2                	mov    %eax,%edx
8010358b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010358e:	83 e0 0f             	and    $0xf,%eax
80103591:	01 d0                	add    %edx,%eax
80103593:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
80103596:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103599:	c1 e8 04             	shr    $0x4,%eax
8010359c:	89 c2                	mov    %eax,%edx
8010359e:	89 d0                	mov    %edx,%eax
801035a0:	c1 e0 02             	shl    $0x2,%eax
801035a3:	01 d0                	add    %edx,%eax
801035a5:	01 c0                	add    %eax,%eax
801035a7:	89 c2                	mov    %eax,%edx
801035a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
801035ac:	83 e0 0f             	and    $0xf,%eax
801035af:	01 d0                	add    %edx,%eax
801035b1:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
801035b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035b7:	c1 e8 04             	shr    $0x4,%eax
801035ba:	89 c2                	mov    %eax,%edx
801035bc:	89 d0                	mov    %edx,%eax
801035be:	c1 e0 02             	shl    $0x2,%eax
801035c1:	01 d0                	add    %edx,%eax
801035c3:	01 c0                	add    %eax,%eax
801035c5:	89 c2                	mov    %eax,%edx
801035c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035ca:	83 e0 0f             	and    $0xf,%eax
801035cd:	01 d0                	add    %edx,%eax
801035cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
801035d2:	8b 45 08             	mov    0x8(%ebp),%eax
801035d5:	8b 55 d8             	mov    -0x28(%ebp),%edx
801035d8:	89 10                	mov    %edx,(%eax)
801035da:	8b 55 dc             	mov    -0x24(%ebp),%edx
801035dd:	89 50 04             	mov    %edx,0x4(%eax)
801035e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
801035e3:	89 50 08             	mov    %edx,0x8(%eax)
801035e6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801035e9:	89 50 0c             	mov    %edx,0xc(%eax)
801035ec:	8b 55 e8             	mov    -0x18(%ebp),%edx
801035ef:	89 50 10             	mov    %edx,0x10(%eax)
801035f2:	8b 55 ec             	mov    -0x14(%ebp),%edx
801035f5:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
801035f8:	8b 45 08             	mov    0x8(%ebp),%eax
801035fb:	8b 40 14             	mov    0x14(%eax),%eax
801035fe:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
80103604:	8b 45 08             	mov    0x8(%ebp),%eax
80103607:	89 50 14             	mov    %edx,0x14(%eax)
}
8010360a:	90                   	nop
8010360b:	c9                   	leave  
8010360c:	c3                   	ret    

8010360d <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
8010360d:	55                   	push   %ebp
8010360e:	89 e5                	mov    %esp,%ebp
80103610:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80103613:	83 ec 08             	sub    $0x8,%esp
80103616:	68 84 91 10 80       	push   $0x80109184
8010361b:	68 a0 32 11 80       	push   $0x801132a0
80103620:	e8 2f 21 00 00       	call   80105754 <initlock>
80103625:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
80103628:	83 ec 08             	sub    $0x8,%esp
8010362b:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010362e:	50                   	push   %eax
8010362f:	ff 75 08             	pushl  0x8(%ebp)
80103632:	e8 f5 dd ff ff       	call   8010142c <readsb>
80103637:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
8010363a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010363d:	a3 d4 32 11 80       	mov    %eax,0x801132d4
  log.size = sb.nlog;
80103642:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103645:	a3 d8 32 11 80       	mov    %eax,0x801132d8
  log.dev = dev;
8010364a:	8b 45 08             	mov    0x8(%ebp),%eax
8010364d:	a3 e4 32 11 80       	mov    %eax,0x801132e4
  recover_from_log();
80103652:	e8 b2 01 00 00       	call   80103809 <recover_from_log>
}
80103657:	90                   	nop
80103658:	c9                   	leave  
80103659:	c3                   	ret    

8010365a <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
8010365a:	55                   	push   %ebp
8010365b:	89 e5                	mov    %esp,%ebp
8010365d:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103660:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103667:	e9 95 00 00 00       	jmp    80103701 <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
8010366c:	8b 15 d4 32 11 80    	mov    0x801132d4,%edx
80103672:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103675:	01 d0                	add    %edx,%eax
80103677:	83 c0 01             	add    $0x1,%eax
8010367a:	89 c2                	mov    %eax,%edx
8010367c:	a1 e4 32 11 80       	mov    0x801132e4,%eax
80103681:	83 ec 08             	sub    $0x8,%esp
80103684:	52                   	push   %edx
80103685:	50                   	push   %eax
80103686:	e8 2b cb ff ff       	call   801001b6 <bread>
8010368b:	83 c4 10             	add    $0x10,%esp
8010368e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103691:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103694:	83 c0 10             	add    $0x10,%eax
80103697:	8b 04 85 ac 32 11 80 	mov    -0x7feecd54(,%eax,4),%eax
8010369e:	89 c2                	mov    %eax,%edx
801036a0:	a1 e4 32 11 80       	mov    0x801132e4,%eax
801036a5:	83 ec 08             	sub    $0x8,%esp
801036a8:	52                   	push   %edx
801036a9:	50                   	push   %eax
801036aa:	e8 07 cb ff ff       	call   801001b6 <bread>
801036af:	83 c4 10             	add    $0x10,%esp
801036b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801036b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036b8:	8d 50 18             	lea    0x18(%eax),%edx
801036bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801036be:	83 c0 18             	add    $0x18,%eax
801036c1:	83 ec 04             	sub    $0x4,%esp
801036c4:	68 00 02 00 00       	push   $0x200
801036c9:	52                   	push   %edx
801036ca:	50                   	push   %eax
801036cb:	e8 c8 23 00 00       	call   80105a98 <memmove>
801036d0:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
801036d3:	83 ec 0c             	sub    $0xc,%esp
801036d6:	ff 75 ec             	pushl  -0x14(%ebp)
801036d9:	e8 11 cb ff ff       	call   801001ef <bwrite>
801036de:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf); 
801036e1:	83 ec 0c             	sub    $0xc,%esp
801036e4:	ff 75 f0             	pushl  -0x10(%ebp)
801036e7:	e8 42 cb ff ff       	call   8010022e <brelse>
801036ec:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
801036ef:	83 ec 0c             	sub    $0xc,%esp
801036f2:	ff 75 ec             	pushl  -0x14(%ebp)
801036f5:	e8 34 cb ff ff       	call   8010022e <brelse>
801036fa:	83 c4 10             	add    $0x10,%esp
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801036fd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103701:	a1 e8 32 11 80       	mov    0x801132e8,%eax
80103706:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103709:	0f 8f 5d ff ff ff    	jg     8010366c <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
8010370f:	90                   	nop
80103710:	c9                   	leave  
80103711:	c3                   	ret    

80103712 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80103712:	55                   	push   %ebp
80103713:	89 e5                	mov    %esp,%ebp
80103715:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103718:	a1 d4 32 11 80       	mov    0x801132d4,%eax
8010371d:	89 c2                	mov    %eax,%edx
8010371f:	a1 e4 32 11 80       	mov    0x801132e4,%eax
80103724:	83 ec 08             	sub    $0x8,%esp
80103727:	52                   	push   %edx
80103728:	50                   	push   %eax
80103729:	e8 88 ca ff ff       	call   801001b6 <bread>
8010372e:	83 c4 10             	add    $0x10,%esp
80103731:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
80103734:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103737:	83 c0 18             	add    $0x18,%eax
8010373a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
8010373d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103740:	8b 00                	mov    (%eax),%eax
80103742:	a3 e8 32 11 80       	mov    %eax,0x801132e8
  for (i = 0; i < log.lh.n; i++) {
80103747:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010374e:	eb 1b                	jmp    8010376b <read_head+0x59>
    log.lh.block[i] = lh->block[i];
80103750:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103753:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103756:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
8010375a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010375d:	83 c2 10             	add    $0x10,%edx
80103760:	89 04 95 ac 32 11 80 	mov    %eax,-0x7feecd54(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80103767:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010376b:	a1 e8 32 11 80       	mov    0x801132e8,%eax
80103770:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103773:	7f db                	jg     80103750 <read_head+0x3e>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80103775:	83 ec 0c             	sub    $0xc,%esp
80103778:	ff 75 f0             	pushl  -0x10(%ebp)
8010377b:	e8 ae ca ff ff       	call   8010022e <brelse>
80103780:	83 c4 10             	add    $0x10,%esp
}
80103783:	90                   	nop
80103784:	c9                   	leave  
80103785:	c3                   	ret    

80103786 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103786:	55                   	push   %ebp
80103787:	89 e5                	mov    %esp,%ebp
80103789:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
8010378c:	a1 d4 32 11 80       	mov    0x801132d4,%eax
80103791:	89 c2                	mov    %eax,%edx
80103793:	a1 e4 32 11 80       	mov    0x801132e4,%eax
80103798:	83 ec 08             	sub    $0x8,%esp
8010379b:	52                   	push   %edx
8010379c:	50                   	push   %eax
8010379d:	e8 14 ca ff ff       	call   801001b6 <bread>
801037a2:	83 c4 10             	add    $0x10,%esp
801037a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
801037a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037ab:	83 c0 18             	add    $0x18,%eax
801037ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
801037b1:	8b 15 e8 32 11 80    	mov    0x801132e8,%edx
801037b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801037ba:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
801037bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801037c3:	eb 1b                	jmp    801037e0 <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
801037c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037c8:	83 c0 10             	add    $0x10,%eax
801037cb:	8b 0c 85 ac 32 11 80 	mov    -0x7feecd54(,%eax,4),%ecx
801037d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801037d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801037d8:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801037dc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801037e0:	a1 e8 32 11 80       	mov    0x801132e8,%eax
801037e5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801037e8:	7f db                	jg     801037c5 <write_head+0x3f>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
801037ea:	83 ec 0c             	sub    $0xc,%esp
801037ed:	ff 75 f0             	pushl  -0x10(%ebp)
801037f0:	e8 fa c9 ff ff       	call   801001ef <bwrite>
801037f5:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
801037f8:	83 ec 0c             	sub    $0xc,%esp
801037fb:	ff 75 f0             	pushl  -0x10(%ebp)
801037fe:	e8 2b ca ff ff       	call   8010022e <brelse>
80103803:	83 c4 10             	add    $0x10,%esp
}
80103806:	90                   	nop
80103807:	c9                   	leave  
80103808:	c3                   	ret    

80103809 <recover_from_log>:

static void
recover_from_log(void)
{
80103809:	55                   	push   %ebp
8010380a:	89 e5                	mov    %esp,%ebp
8010380c:	83 ec 08             	sub    $0x8,%esp
  read_head();      
8010380f:	e8 fe fe ff ff       	call   80103712 <read_head>
  install_trans(); // if committed, copy from log to disk
80103814:	e8 41 fe ff ff       	call   8010365a <install_trans>
  log.lh.n = 0;
80103819:	c7 05 e8 32 11 80 00 	movl   $0x0,0x801132e8
80103820:	00 00 00 
  write_head(); // clear the log
80103823:	e8 5e ff ff ff       	call   80103786 <write_head>
}
80103828:	90                   	nop
80103829:	c9                   	leave  
8010382a:	c3                   	ret    

8010382b <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
8010382b:	55                   	push   %ebp
8010382c:	89 e5                	mov    %esp,%ebp
8010382e:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
80103831:	83 ec 0c             	sub    $0xc,%esp
80103834:	68 a0 32 11 80       	push   $0x801132a0
80103839:	e8 38 1f 00 00       	call   80105776 <acquire>
8010383e:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
80103841:	a1 e0 32 11 80       	mov    0x801132e0,%eax
80103846:	85 c0                	test   %eax,%eax
80103848:	74 17                	je     80103861 <begin_op+0x36>
      sleep(&log, &log.lock);
8010384a:	83 ec 08             	sub    $0x8,%esp
8010384d:	68 a0 32 11 80       	push   $0x801132a0
80103852:	68 a0 32 11 80       	push   $0x801132a0
80103857:	e8 75 18 00 00       	call   801050d1 <sleep>
8010385c:	83 c4 10             	add    $0x10,%esp
8010385f:	eb e0                	jmp    80103841 <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103861:	8b 0d e8 32 11 80    	mov    0x801132e8,%ecx
80103867:	a1 dc 32 11 80       	mov    0x801132dc,%eax
8010386c:	8d 50 01             	lea    0x1(%eax),%edx
8010386f:	89 d0                	mov    %edx,%eax
80103871:	c1 e0 02             	shl    $0x2,%eax
80103874:	01 d0                	add    %edx,%eax
80103876:	01 c0                	add    %eax,%eax
80103878:	01 c8                	add    %ecx,%eax
8010387a:	83 f8 1e             	cmp    $0x1e,%eax
8010387d:	7e 17                	jle    80103896 <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
8010387f:	83 ec 08             	sub    $0x8,%esp
80103882:	68 a0 32 11 80       	push   $0x801132a0
80103887:	68 a0 32 11 80       	push   $0x801132a0
8010388c:	e8 40 18 00 00       	call   801050d1 <sleep>
80103891:	83 c4 10             	add    $0x10,%esp
80103894:	eb ab                	jmp    80103841 <begin_op+0x16>
    } else {
      log.outstanding += 1;
80103896:	a1 dc 32 11 80       	mov    0x801132dc,%eax
8010389b:	83 c0 01             	add    $0x1,%eax
8010389e:	a3 dc 32 11 80       	mov    %eax,0x801132dc
      release(&log.lock);
801038a3:	83 ec 0c             	sub    $0xc,%esp
801038a6:	68 a0 32 11 80       	push   $0x801132a0
801038ab:	e8 2d 1f 00 00       	call   801057dd <release>
801038b0:	83 c4 10             	add    $0x10,%esp
      break;
801038b3:	90                   	nop
    }
  }
}
801038b4:	90                   	nop
801038b5:	c9                   	leave  
801038b6:	c3                   	ret    

801038b7 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801038b7:	55                   	push   %ebp
801038b8:	89 e5                	mov    %esp,%ebp
801038ba:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
801038bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
801038c4:	83 ec 0c             	sub    $0xc,%esp
801038c7:	68 a0 32 11 80       	push   $0x801132a0
801038cc:	e8 a5 1e 00 00       	call   80105776 <acquire>
801038d1:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801038d4:	a1 dc 32 11 80       	mov    0x801132dc,%eax
801038d9:	83 e8 01             	sub    $0x1,%eax
801038dc:	a3 dc 32 11 80       	mov    %eax,0x801132dc
  if(log.committing)
801038e1:	a1 e0 32 11 80       	mov    0x801132e0,%eax
801038e6:	85 c0                	test   %eax,%eax
801038e8:	74 0d                	je     801038f7 <end_op+0x40>
    panic("log.committing");
801038ea:	83 ec 0c             	sub    $0xc,%esp
801038ed:	68 88 91 10 80       	push   $0x80109188
801038f2:	e8 6f cc ff ff       	call   80100566 <panic>
  if(log.outstanding == 0){
801038f7:	a1 dc 32 11 80       	mov    0x801132dc,%eax
801038fc:	85 c0                	test   %eax,%eax
801038fe:	75 13                	jne    80103913 <end_op+0x5c>
    do_commit = 1;
80103900:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
80103907:	c7 05 e0 32 11 80 01 	movl   $0x1,0x801132e0
8010390e:	00 00 00 
80103911:	eb 10                	jmp    80103923 <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
80103913:	83 ec 0c             	sub    $0xc,%esp
80103916:	68 a0 32 11 80       	push   $0x801132a0
8010391b:	e8 98 18 00 00       	call   801051b8 <wakeup>
80103920:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
80103923:	83 ec 0c             	sub    $0xc,%esp
80103926:	68 a0 32 11 80       	push   $0x801132a0
8010392b:	e8 ad 1e 00 00       	call   801057dd <release>
80103930:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
80103933:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103937:	74 3f                	je     80103978 <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
80103939:	e8 f5 00 00 00       	call   80103a33 <commit>
    acquire(&log.lock);
8010393e:	83 ec 0c             	sub    $0xc,%esp
80103941:	68 a0 32 11 80       	push   $0x801132a0
80103946:	e8 2b 1e 00 00       	call   80105776 <acquire>
8010394b:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
8010394e:	c7 05 e0 32 11 80 00 	movl   $0x0,0x801132e0
80103955:	00 00 00 
    wakeup(&log);
80103958:	83 ec 0c             	sub    $0xc,%esp
8010395b:	68 a0 32 11 80       	push   $0x801132a0
80103960:	e8 53 18 00 00       	call   801051b8 <wakeup>
80103965:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
80103968:	83 ec 0c             	sub    $0xc,%esp
8010396b:	68 a0 32 11 80       	push   $0x801132a0
80103970:	e8 68 1e 00 00       	call   801057dd <release>
80103975:	83 c4 10             	add    $0x10,%esp
  }
}
80103978:	90                   	nop
80103979:	c9                   	leave  
8010397a:	c3                   	ret    

8010397b <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
8010397b:	55                   	push   %ebp
8010397c:	89 e5                	mov    %esp,%ebp
8010397e:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103981:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103988:	e9 95 00 00 00       	jmp    80103a22 <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
8010398d:	8b 15 d4 32 11 80    	mov    0x801132d4,%edx
80103993:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103996:	01 d0                	add    %edx,%eax
80103998:	83 c0 01             	add    $0x1,%eax
8010399b:	89 c2                	mov    %eax,%edx
8010399d:	a1 e4 32 11 80       	mov    0x801132e4,%eax
801039a2:	83 ec 08             	sub    $0x8,%esp
801039a5:	52                   	push   %edx
801039a6:	50                   	push   %eax
801039a7:	e8 0a c8 ff ff       	call   801001b6 <bread>
801039ac:	83 c4 10             	add    $0x10,%esp
801039af:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801039b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039b5:	83 c0 10             	add    $0x10,%eax
801039b8:	8b 04 85 ac 32 11 80 	mov    -0x7feecd54(,%eax,4),%eax
801039bf:	89 c2                	mov    %eax,%edx
801039c1:	a1 e4 32 11 80       	mov    0x801132e4,%eax
801039c6:	83 ec 08             	sub    $0x8,%esp
801039c9:	52                   	push   %edx
801039ca:	50                   	push   %eax
801039cb:	e8 e6 c7 ff ff       	call   801001b6 <bread>
801039d0:	83 c4 10             	add    $0x10,%esp
801039d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
801039d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801039d9:	8d 50 18             	lea    0x18(%eax),%edx
801039dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039df:	83 c0 18             	add    $0x18,%eax
801039e2:	83 ec 04             	sub    $0x4,%esp
801039e5:	68 00 02 00 00       	push   $0x200
801039ea:	52                   	push   %edx
801039eb:	50                   	push   %eax
801039ec:	e8 a7 20 00 00       	call   80105a98 <memmove>
801039f1:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
801039f4:	83 ec 0c             	sub    $0xc,%esp
801039f7:	ff 75 f0             	pushl  -0x10(%ebp)
801039fa:	e8 f0 c7 ff ff       	call   801001ef <bwrite>
801039ff:	83 c4 10             	add    $0x10,%esp
    brelse(from); 
80103a02:	83 ec 0c             	sub    $0xc,%esp
80103a05:	ff 75 ec             	pushl  -0x14(%ebp)
80103a08:	e8 21 c8 ff ff       	call   8010022e <brelse>
80103a0d:	83 c4 10             	add    $0x10,%esp
    brelse(to);
80103a10:	83 ec 0c             	sub    $0xc,%esp
80103a13:	ff 75 f0             	pushl  -0x10(%ebp)
80103a16:	e8 13 c8 ff ff       	call   8010022e <brelse>
80103a1b:	83 c4 10             	add    $0x10,%esp
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103a1e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103a22:	a1 e8 32 11 80       	mov    0x801132e8,%eax
80103a27:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103a2a:	0f 8f 5d ff ff ff    	jg     8010398d <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
80103a30:	90                   	nop
80103a31:	c9                   	leave  
80103a32:	c3                   	ret    

80103a33 <commit>:

static void
commit()
{
80103a33:	55                   	push   %ebp
80103a34:	89 e5                	mov    %esp,%ebp
80103a36:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103a39:	a1 e8 32 11 80       	mov    0x801132e8,%eax
80103a3e:	85 c0                	test   %eax,%eax
80103a40:	7e 1e                	jle    80103a60 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
80103a42:	e8 34 ff ff ff       	call   8010397b <write_log>
    write_head();    // Write header to disk -- the real commit
80103a47:	e8 3a fd ff ff       	call   80103786 <write_head>
    install_trans(); // Now install writes to home locations
80103a4c:	e8 09 fc ff ff       	call   8010365a <install_trans>
    log.lh.n = 0; 
80103a51:	c7 05 e8 32 11 80 00 	movl   $0x0,0x801132e8
80103a58:	00 00 00 
    write_head();    // Erase the transaction from the log
80103a5b:	e8 26 fd ff ff       	call   80103786 <write_head>
  }
}
80103a60:	90                   	nop
80103a61:	c9                   	leave  
80103a62:	c3                   	ret    

80103a63 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103a63:	55                   	push   %ebp
80103a64:	89 e5                	mov    %esp,%ebp
80103a66:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103a69:	a1 e8 32 11 80       	mov    0x801132e8,%eax
80103a6e:	83 f8 1d             	cmp    $0x1d,%eax
80103a71:	7f 12                	jg     80103a85 <log_write+0x22>
80103a73:	a1 e8 32 11 80       	mov    0x801132e8,%eax
80103a78:	8b 15 d8 32 11 80    	mov    0x801132d8,%edx
80103a7e:	83 ea 01             	sub    $0x1,%edx
80103a81:	39 d0                	cmp    %edx,%eax
80103a83:	7c 0d                	jl     80103a92 <log_write+0x2f>
    panic("too big a transaction");
80103a85:	83 ec 0c             	sub    $0xc,%esp
80103a88:	68 97 91 10 80       	push   $0x80109197
80103a8d:	e8 d4 ca ff ff       	call   80100566 <panic>
  if (log.outstanding < 1)
80103a92:	a1 dc 32 11 80       	mov    0x801132dc,%eax
80103a97:	85 c0                	test   %eax,%eax
80103a99:	7f 0d                	jg     80103aa8 <log_write+0x45>
    panic("log_write outside of trans");
80103a9b:	83 ec 0c             	sub    $0xc,%esp
80103a9e:	68 ad 91 10 80       	push   $0x801091ad
80103aa3:	e8 be ca ff ff       	call   80100566 <panic>

  acquire(&log.lock);
80103aa8:	83 ec 0c             	sub    $0xc,%esp
80103aab:	68 a0 32 11 80       	push   $0x801132a0
80103ab0:	e8 c1 1c 00 00       	call   80105776 <acquire>
80103ab5:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
80103ab8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103abf:	eb 1d                	jmp    80103ade <log_write+0x7b>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ac4:	83 c0 10             	add    $0x10,%eax
80103ac7:	8b 04 85 ac 32 11 80 	mov    -0x7feecd54(,%eax,4),%eax
80103ace:	89 c2                	mov    %eax,%edx
80103ad0:	8b 45 08             	mov    0x8(%ebp),%eax
80103ad3:	8b 40 08             	mov    0x8(%eax),%eax
80103ad6:	39 c2                	cmp    %eax,%edx
80103ad8:	74 10                	je     80103aea <log_write+0x87>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103ada:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103ade:	a1 e8 32 11 80       	mov    0x801132e8,%eax
80103ae3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103ae6:	7f d9                	jg     80103ac1 <log_write+0x5e>
80103ae8:	eb 01                	jmp    80103aeb <log_write+0x88>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
80103aea:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
80103aeb:	8b 45 08             	mov    0x8(%ebp),%eax
80103aee:	8b 40 08             	mov    0x8(%eax),%eax
80103af1:	89 c2                	mov    %eax,%edx
80103af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103af6:	83 c0 10             	add    $0x10,%eax
80103af9:	89 14 85 ac 32 11 80 	mov    %edx,-0x7feecd54(,%eax,4)
  if (i == log.lh.n)
80103b00:	a1 e8 32 11 80       	mov    0x801132e8,%eax
80103b05:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103b08:	75 0d                	jne    80103b17 <log_write+0xb4>
    log.lh.n++;
80103b0a:	a1 e8 32 11 80       	mov    0x801132e8,%eax
80103b0f:	83 c0 01             	add    $0x1,%eax
80103b12:	a3 e8 32 11 80       	mov    %eax,0x801132e8
  b->flags |= B_DIRTY; // prevent eviction
80103b17:	8b 45 08             	mov    0x8(%ebp),%eax
80103b1a:	8b 00                	mov    (%eax),%eax
80103b1c:	83 c8 04             	or     $0x4,%eax
80103b1f:	89 c2                	mov    %eax,%edx
80103b21:	8b 45 08             	mov    0x8(%ebp),%eax
80103b24:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
80103b26:	83 ec 0c             	sub    $0xc,%esp
80103b29:	68 a0 32 11 80       	push   $0x801132a0
80103b2e:	e8 aa 1c 00 00       	call   801057dd <release>
80103b33:	83 c4 10             	add    $0x10,%esp
}
80103b36:	90                   	nop
80103b37:	c9                   	leave  
80103b38:	c3                   	ret    

80103b39 <v2p>:
80103b39:	55                   	push   %ebp
80103b3a:	89 e5                	mov    %esp,%ebp
80103b3c:	8b 45 08             	mov    0x8(%ebp),%eax
80103b3f:	05 00 00 00 80       	add    $0x80000000,%eax
80103b44:	5d                   	pop    %ebp
80103b45:	c3                   	ret    

80103b46 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80103b46:	55                   	push   %ebp
80103b47:	89 e5                	mov    %esp,%ebp
80103b49:	8b 45 08             	mov    0x8(%ebp),%eax
80103b4c:	05 00 00 00 80       	add    $0x80000000,%eax
80103b51:	5d                   	pop    %ebp
80103b52:	c3                   	ret    

80103b53 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103b53:	55                   	push   %ebp
80103b54:	89 e5                	mov    %esp,%ebp
80103b56:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103b59:	8b 55 08             	mov    0x8(%ebp),%edx
80103b5c:	8b 45 0c             	mov    0xc(%ebp),%eax
80103b5f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103b62:	f0 87 02             	lock xchg %eax,(%edx)
80103b65:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103b68:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103b6b:	c9                   	leave  
80103b6c:	c3                   	ret    

80103b6d <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103b6d:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103b71:	83 e4 f0             	and    $0xfffffff0,%esp
80103b74:	ff 71 fc             	pushl  -0x4(%ecx)
80103b77:	55                   	push   %ebp
80103b78:	89 e5                	mov    %esp,%ebp
80103b7a:	51                   	push   %ecx
80103b7b:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103b7e:	83 ec 08             	sub    $0x8,%esp
80103b81:	68 00 00 40 80       	push   $0x80400000
80103b86:	68 3c 66 11 80       	push   $0x8011663c
80103b8b:	e8 7d f2 ff ff       	call   80102e0d <kinit1>
80103b90:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103b93:	e8 fe 4b 00 00       	call   80108796 <kvmalloc>
  mpinit();        // collect info about this machine
80103b98:	e8 43 04 00 00       	call   80103fe0 <mpinit>
  lapicinit();
80103b9d:	e8 ea f5 ff ff       	call   8010318c <lapicinit>
  seginit();       // set up segments
80103ba2:	e8 98 45 00 00       	call   8010813f <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80103ba7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103bad:	0f b6 00             	movzbl (%eax),%eax
80103bb0:	0f b6 c0             	movzbl %al,%eax
80103bb3:	83 ec 08             	sub    $0x8,%esp
80103bb6:	50                   	push   %eax
80103bb7:	68 c8 91 10 80       	push   $0x801091c8
80103bbc:	e8 05 c8 ff ff       	call   801003c6 <cprintf>
80103bc1:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
80103bc4:	e8 6d 06 00 00       	call   80104236 <picinit>
  ioapicinit();    // another interrupt controller
80103bc9:	e8 34 f1 ff ff       	call   80102d02 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103bce:	e8 46 cf ff ff       	call   80100b19 <consoleinit>
  uartinit();      // serial port
80103bd3:	e8 c3 38 00 00       	call   8010749b <uartinit>
  pinit();         // process table
80103bd8:	e8 5d 0b 00 00       	call   8010473a <pinit>
  tvinit();        // trap vectors
80103bdd:	e8 92 34 00 00       	call   80107074 <tvinit>
  binit();         // buffer cache
80103be2:	e8 4d c4 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103be7:	e8 31 d4 ff ff       	call   8010101d <fileinit>
  ideinit();       // disk
80103bec:	e8 19 ed ff ff       	call   8010290a <ideinit>
  if(!ismp)
80103bf1:	a1 84 33 11 80       	mov    0x80113384,%eax
80103bf6:	85 c0                	test   %eax,%eax
80103bf8:	75 05                	jne    80103bff <main+0x92>
    timerinit();   // uniprocessor timer
80103bfa:	e8 c6 33 00 00       	call   80106fc5 <timerinit>
  startothers();   // start other processors
80103bff:	e8 7f 00 00 00       	call   80103c83 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103c04:	83 ec 08             	sub    $0x8,%esp
80103c07:	68 00 00 00 8e       	push   $0x8e000000
80103c0c:	68 00 00 40 80       	push   $0x80400000
80103c11:	e8 30 f2 ff ff       	call   80102e46 <kinit2>
80103c16:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
80103c19:	e8 6e 0c 00 00       	call   8010488c <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
80103c1e:	e8 1a 00 00 00       	call   80103c3d <mpmain>

80103c23 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103c23:	55                   	push   %ebp
80103c24:	89 e5                	mov    %esp,%ebp
80103c26:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
80103c29:	e8 80 4b 00 00       	call   801087ae <switchkvm>
  seginit();
80103c2e:	e8 0c 45 00 00       	call   8010813f <seginit>
  lapicinit();
80103c33:	e8 54 f5 ff ff       	call   8010318c <lapicinit>
  mpmain();
80103c38:	e8 00 00 00 00       	call   80103c3d <mpmain>

80103c3d <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103c3d:	55                   	push   %ebp
80103c3e:	89 e5                	mov    %esp,%ebp
80103c40:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpu->id);
80103c43:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103c49:	0f b6 00             	movzbl (%eax),%eax
80103c4c:	0f b6 c0             	movzbl %al,%eax
80103c4f:	83 ec 08             	sub    $0x8,%esp
80103c52:	50                   	push   %eax
80103c53:	68 df 91 10 80       	push   $0x801091df
80103c58:	e8 69 c7 ff ff       	call   801003c6 <cprintf>
80103c5d:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103c60:	e8 70 35 00 00       	call   801071d5 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103c65:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103c6b:	05 a8 00 00 00       	add    $0xa8,%eax
80103c70:	83 ec 08             	sub    $0x8,%esp
80103c73:	6a 01                	push   $0x1
80103c75:	50                   	push   %eax
80103c76:	e8 d8 fe ff ff       	call   80103b53 <xchg>
80103c7b:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103c7e:	e8 fe 11 00 00       	call   80104e81 <scheduler>

80103c83 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103c83:	55                   	push   %ebp
80103c84:	89 e5                	mov    %esp,%ebp
80103c86:	53                   	push   %ebx
80103c87:	83 ec 14             	sub    $0x14,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
80103c8a:	68 00 70 00 00       	push   $0x7000
80103c8f:	e8 b2 fe ff ff       	call   80103b46 <p2v>
80103c94:	83 c4 04             	add    $0x4,%esp
80103c97:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103c9a:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103c9f:	83 ec 04             	sub    $0x4,%esp
80103ca2:	50                   	push   %eax
80103ca3:	68 4c c5 10 80       	push   $0x8010c54c
80103ca8:	ff 75 f0             	pushl  -0x10(%ebp)
80103cab:	e8 e8 1d 00 00       	call   80105a98 <memmove>
80103cb0:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103cb3:	c7 45 f4 a0 33 11 80 	movl   $0x801133a0,-0xc(%ebp)
80103cba:	e9 90 00 00 00       	jmp    80103d4f <startothers+0xcc>
    if(c == cpus+cpunum())  // We've started already.
80103cbf:	e8 e6 f5 ff ff       	call   801032aa <cpunum>
80103cc4:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103cca:	05 a0 33 11 80       	add    $0x801133a0,%eax
80103ccf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103cd2:	74 73                	je     80103d47 <startothers+0xc4>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103cd4:	e8 6b f2 ff ff       	call   80102f44 <kalloc>
80103cd9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103cdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cdf:	83 e8 04             	sub    $0x4,%eax
80103ce2:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103ce5:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103ceb:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103ced:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cf0:	83 e8 08             	sub    $0x8,%eax
80103cf3:	c7 00 23 3c 10 80    	movl   $0x80103c23,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103cf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cfc:	8d 58 f4             	lea    -0xc(%eax),%ebx
80103cff:	83 ec 0c             	sub    $0xc,%esp
80103d02:	68 00 b0 10 80       	push   $0x8010b000
80103d07:	e8 2d fe ff ff       	call   80103b39 <v2p>
80103d0c:	83 c4 10             	add    $0x10,%esp
80103d0f:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
80103d11:	83 ec 0c             	sub    $0xc,%esp
80103d14:	ff 75 f0             	pushl  -0x10(%ebp)
80103d17:	e8 1d fe ff ff       	call   80103b39 <v2p>
80103d1c:	83 c4 10             	add    $0x10,%esp
80103d1f:	89 c2                	mov    %eax,%edx
80103d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d24:	0f b6 00             	movzbl (%eax),%eax
80103d27:	0f b6 c0             	movzbl %al,%eax
80103d2a:	83 ec 08             	sub    $0x8,%esp
80103d2d:	52                   	push   %edx
80103d2e:	50                   	push   %eax
80103d2f:	e8 f0 f5 ff ff       	call   80103324 <lapicstartap>
80103d34:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103d37:	90                   	nop
80103d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d3b:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103d41:	85 c0                	test   %eax,%eax
80103d43:	74 f3                	je     80103d38 <startothers+0xb5>
80103d45:	eb 01                	jmp    80103d48 <startothers+0xc5>
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
80103d47:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103d48:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103d4f:	a1 80 39 11 80       	mov    0x80113980,%eax
80103d54:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103d5a:	05 a0 33 11 80       	add    $0x801133a0,%eax
80103d5f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103d62:	0f 87 57 ff ff ff    	ja     80103cbf <startothers+0x3c>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103d68:	90                   	nop
80103d69:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d6c:	c9                   	leave  
80103d6d:	c3                   	ret    

80103d6e <p2v>:
80103d6e:	55                   	push   %ebp
80103d6f:	89 e5                	mov    %esp,%ebp
80103d71:	8b 45 08             	mov    0x8(%ebp),%eax
80103d74:	05 00 00 00 80       	add    $0x80000000,%eax
80103d79:	5d                   	pop    %ebp
80103d7a:	c3                   	ret    

80103d7b <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80103d7b:	55                   	push   %ebp
80103d7c:	89 e5                	mov    %esp,%ebp
80103d7e:	83 ec 14             	sub    $0x14,%esp
80103d81:	8b 45 08             	mov    0x8(%ebp),%eax
80103d84:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103d88:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103d8c:	89 c2                	mov    %eax,%edx
80103d8e:	ec                   	in     (%dx),%al
80103d8f:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103d92:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103d96:	c9                   	leave  
80103d97:	c3                   	ret    

80103d98 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103d98:	55                   	push   %ebp
80103d99:	89 e5                	mov    %esp,%ebp
80103d9b:	83 ec 08             	sub    $0x8,%esp
80103d9e:	8b 55 08             	mov    0x8(%ebp),%edx
80103da1:	8b 45 0c             	mov    0xc(%ebp),%eax
80103da4:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103da8:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103dab:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103daf:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103db3:	ee                   	out    %al,(%dx)
}
80103db4:	90                   	nop
80103db5:	c9                   	leave  
80103db6:	c3                   	ret    

80103db7 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103db7:	55                   	push   %ebp
80103db8:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103dba:	a1 84 c6 10 80       	mov    0x8010c684,%eax
80103dbf:	89 c2                	mov    %eax,%edx
80103dc1:	b8 a0 33 11 80       	mov    $0x801133a0,%eax
80103dc6:	29 c2                	sub    %eax,%edx
80103dc8:	89 d0                	mov    %edx,%eax
80103dca:	c1 f8 02             	sar    $0x2,%eax
80103dcd:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103dd3:	5d                   	pop    %ebp
80103dd4:	c3                   	ret    

80103dd5 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103dd5:	55                   	push   %ebp
80103dd6:	89 e5                	mov    %esp,%ebp
80103dd8:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103ddb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103de2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103de9:	eb 15                	jmp    80103e00 <sum+0x2b>
    sum += addr[i];
80103deb:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103dee:	8b 45 08             	mov    0x8(%ebp),%eax
80103df1:	01 d0                	add    %edx,%eax
80103df3:	0f b6 00             	movzbl (%eax),%eax
80103df6:	0f b6 c0             	movzbl %al,%eax
80103df9:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103dfc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103e00:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103e03:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103e06:	7c e3                	jl     80103deb <sum+0x16>
    sum += addr[i];
  return sum;
80103e08:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103e0b:	c9                   	leave  
80103e0c:	c3                   	ret    

80103e0d <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103e0d:	55                   	push   %ebp
80103e0e:	89 e5                	mov    %esp,%ebp
80103e10:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103e13:	ff 75 08             	pushl  0x8(%ebp)
80103e16:	e8 53 ff ff ff       	call   80103d6e <p2v>
80103e1b:	83 c4 04             	add    $0x4,%esp
80103e1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103e21:	8b 55 0c             	mov    0xc(%ebp),%edx
80103e24:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e27:	01 d0                	add    %edx,%eax
80103e29:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103e2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103e32:	eb 36                	jmp    80103e6a <mpsearch1+0x5d>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103e34:	83 ec 04             	sub    $0x4,%esp
80103e37:	6a 04                	push   $0x4
80103e39:	68 f0 91 10 80       	push   $0x801091f0
80103e3e:	ff 75 f4             	pushl  -0xc(%ebp)
80103e41:	e8 fa 1b 00 00       	call   80105a40 <memcmp>
80103e46:	83 c4 10             	add    $0x10,%esp
80103e49:	85 c0                	test   %eax,%eax
80103e4b:	75 19                	jne    80103e66 <mpsearch1+0x59>
80103e4d:	83 ec 08             	sub    $0x8,%esp
80103e50:	6a 10                	push   $0x10
80103e52:	ff 75 f4             	pushl  -0xc(%ebp)
80103e55:	e8 7b ff ff ff       	call   80103dd5 <sum>
80103e5a:	83 c4 10             	add    $0x10,%esp
80103e5d:	84 c0                	test   %al,%al
80103e5f:	75 05                	jne    80103e66 <mpsearch1+0x59>
      return (struct mp*)p;
80103e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e64:	eb 11                	jmp    80103e77 <mpsearch1+0x6a>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103e66:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e6d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103e70:	72 c2                	jb     80103e34 <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103e72:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103e77:	c9                   	leave  
80103e78:	c3                   	ret    

80103e79 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103e79:	55                   	push   %ebp
80103e7a:	89 e5                	mov    %esp,%ebp
80103e7c:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103e7f:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e89:	83 c0 0f             	add    $0xf,%eax
80103e8c:	0f b6 00             	movzbl (%eax),%eax
80103e8f:	0f b6 c0             	movzbl %al,%eax
80103e92:	c1 e0 08             	shl    $0x8,%eax
80103e95:	89 c2                	mov    %eax,%edx
80103e97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e9a:	83 c0 0e             	add    $0xe,%eax
80103e9d:	0f b6 00             	movzbl (%eax),%eax
80103ea0:	0f b6 c0             	movzbl %al,%eax
80103ea3:	09 d0                	or     %edx,%eax
80103ea5:	c1 e0 04             	shl    $0x4,%eax
80103ea8:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103eab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103eaf:	74 21                	je     80103ed2 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103eb1:	83 ec 08             	sub    $0x8,%esp
80103eb4:	68 00 04 00 00       	push   $0x400
80103eb9:	ff 75 f0             	pushl  -0x10(%ebp)
80103ebc:	e8 4c ff ff ff       	call   80103e0d <mpsearch1>
80103ec1:	83 c4 10             	add    $0x10,%esp
80103ec4:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103ec7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103ecb:	74 51                	je     80103f1e <mpsearch+0xa5>
      return mp;
80103ecd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103ed0:	eb 61                	jmp    80103f33 <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ed5:	83 c0 14             	add    $0x14,%eax
80103ed8:	0f b6 00             	movzbl (%eax),%eax
80103edb:	0f b6 c0             	movzbl %al,%eax
80103ede:	c1 e0 08             	shl    $0x8,%eax
80103ee1:	89 c2                	mov    %eax,%edx
80103ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ee6:	83 c0 13             	add    $0x13,%eax
80103ee9:	0f b6 00             	movzbl (%eax),%eax
80103eec:	0f b6 c0             	movzbl %al,%eax
80103eef:	09 d0                	or     %edx,%eax
80103ef1:	c1 e0 0a             	shl    $0xa,%eax
80103ef4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103ef7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103efa:	2d 00 04 00 00       	sub    $0x400,%eax
80103eff:	83 ec 08             	sub    $0x8,%esp
80103f02:	68 00 04 00 00       	push   $0x400
80103f07:	50                   	push   %eax
80103f08:	e8 00 ff ff ff       	call   80103e0d <mpsearch1>
80103f0d:	83 c4 10             	add    $0x10,%esp
80103f10:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103f13:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103f17:	74 05                	je     80103f1e <mpsearch+0xa5>
      return mp;
80103f19:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f1c:	eb 15                	jmp    80103f33 <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
80103f1e:	83 ec 08             	sub    $0x8,%esp
80103f21:	68 00 00 01 00       	push   $0x10000
80103f26:	68 00 00 0f 00       	push   $0xf0000
80103f2b:	e8 dd fe ff ff       	call   80103e0d <mpsearch1>
80103f30:	83 c4 10             	add    $0x10,%esp
}
80103f33:	c9                   	leave  
80103f34:	c3                   	ret    

80103f35 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103f35:	55                   	push   %ebp
80103f36:	89 e5                	mov    %esp,%ebp
80103f38:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103f3b:	e8 39 ff ff ff       	call   80103e79 <mpsearch>
80103f40:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103f43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103f47:	74 0a                	je     80103f53 <mpconfig+0x1e>
80103f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f4c:	8b 40 04             	mov    0x4(%eax),%eax
80103f4f:	85 c0                	test   %eax,%eax
80103f51:	75 0a                	jne    80103f5d <mpconfig+0x28>
    return 0;
80103f53:	b8 00 00 00 00       	mov    $0x0,%eax
80103f58:	e9 81 00 00 00       	jmp    80103fde <mpconfig+0xa9>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f60:	8b 40 04             	mov    0x4(%eax),%eax
80103f63:	83 ec 0c             	sub    $0xc,%esp
80103f66:	50                   	push   %eax
80103f67:	e8 02 fe ff ff       	call   80103d6e <p2v>
80103f6c:	83 c4 10             	add    $0x10,%esp
80103f6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103f72:	83 ec 04             	sub    $0x4,%esp
80103f75:	6a 04                	push   $0x4
80103f77:	68 f5 91 10 80       	push   $0x801091f5
80103f7c:	ff 75 f0             	pushl  -0x10(%ebp)
80103f7f:	e8 bc 1a 00 00       	call   80105a40 <memcmp>
80103f84:	83 c4 10             	add    $0x10,%esp
80103f87:	85 c0                	test   %eax,%eax
80103f89:	74 07                	je     80103f92 <mpconfig+0x5d>
    return 0;
80103f8b:	b8 00 00 00 00       	mov    $0x0,%eax
80103f90:	eb 4c                	jmp    80103fde <mpconfig+0xa9>
  if(conf->version != 1 && conf->version != 4)
80103f92:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103f95:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103f99:	3c 01                	cmp    $0x1,%al
80103f9b:	74 12                	je     80103faf <mpconfig+0x7a>
80103f9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103fa0:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103fa4:	3c 04                	cmp    $0x4,%al
80103fa6:	74 07                	je     80103faf <mpconfig+0x7a>
    return 0;
80103fa8:	b8 00 00 00 00       	mov    $0x0,%eax
80103fad:	eb 2f                	jmp    80103fde <mpconfig+0xa9>
  if(sum((uchar*)conf, conf->length) != 0)
80103faf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103fb2:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103fb6:	0f b7 c0             	movzwl %ax,%eax
80103fb9:	83 ec 08             	sub    $0x8,%esp
80103fbc:	50                   	push   %eax
80103fbd:	ff 75 f0             	pushl  -0x10(%ebp)
80103fc0:	e8 10 fe ff ff       	call   80103dd5 <sum>
80103fc5:	83 c4 10             	add    $0x10,%esp
80103fc8:	84 c0                	test   %al,%al
80103fca:	74 07                	je     80103fd3 <mpconfig+0x9e>
    return 0;
80103fcc:	b8 00 00 00 00       	mov    $0x0,%eax
80103fd1:	eb 0b                	jmp    80103fde <mpconfig+0xa9>
  *pmp = mp;
80103fd3:	8b 45 08             	mov    0x8(%ebp),%eax
80103fd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103fd9:	89 10                	mov    %edx,(%eax)
  return conf;
80103fdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103fde:	c9                   	leave  
80103fdf:	c3                   	ret    

80103fe0 <mpinit>:

void
mpinit(void)
{
80103fe0:	55                   	push   %ebp
80103fe1:	89 e5                	mov    %esp,%ebp
80103fe3:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103fe6:	c7 05 84 c6 10 80 a0 	movl   $0x801133a0,0x8010c684
80103fed:	33 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103ff0:	83 ec 0c             	sub    $0xc,%esp
80103ff3:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103ff6:	50                   	push   %eax
80103ff7:	e8 39 ff ff ff       	call   80103f35 <mpconfig>
80103ffc:	83 c4 10             	add    $0x10,%esp
80103fff:	89 45 f0             	mov    %eax,-0x10(%ebp)
80104002:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104006:	0f 84 96 01 00 00    	je     801041a2 <mpinit+0x1c2>
    return;
  ismp = 1;
8010400c:	c7 05 84 33 11 80 01 	movl   $0x1,0x80113384
80104013:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80104016:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104019:	8b 40 24             	mov    0x24(%eax),%eax
8010401c:	a3 9c 32 11 80       	mov    %eax,0x8011329c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80104021:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104024:	83 c0 2c             	add    $0x2c,%eax
80104027:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010402a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010402d:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80104031:	0f b7 d0             	movzwl %ax,%edx
80104034:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104037:	01 d0                	add    %edx,%eax
80104039:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010403c:	e9 f2 00 00 00       	jmp    80104133 <mpinit+0x153>
    switch(*p){
80104041:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104044:	0f b6 00             	movzbl (%eax),%eax
80104047:	0f b6 c0             	movzbl %al,%eax
8010404a:	83 f8 04             	cmp    $0x4,%eax
8010404d:	0f 87 bc 00 00 00    	ja     8010410f <mpinit+0x12f>
80104053:	8b 04 85 38 92 10 80 	mov    -0x7fef6dc8(,%eax,4),%eax
8010405a:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
8010405c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010405f:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80104062:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104065:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80104069:	0f b6 d0             	movzbl %al,%edx
8010406c:	a1 80 39 11 80       	mov    0x80113980,%eax
80104071:	39 c2                	cmp    %eax,%edx
80104073:	74 2b                	je     801040a0 <mpinit+0xc0>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80104075:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104078:	0f b6 40 01          	movzbl 0x1(%eax),%eax
8010407c:	0f b6 d0             	movzbl %al,%edx
8010407f:	a1 80 39 11 80       	mov    0x80113980,%eax
80104084:	83 ec 04             	sub    $0x4,%esp
80104087:	52                   	push   %edx
80104088:	50                   	push   %eax
80104089:	68 fa 91 10 80       	push   $0x801091fa
8010408e:	e8 33 c3 ff ff       	call   801003c6 <cprintf>
80104093:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
80104096:	c7 05 84 33 11 80 00 	movl   $0x0,0x80113384
8010409d:	00 00 00 
      }
      if(proc->flags & MPBOOT)
801040a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
801040a3:	0f b6 40 03          	movzbl 0x3(%eax),%eax
801040a7:	0f b6 c0             	movzbl %al,%eax
801040aa:	83 e0 02             	and    $0x2,%eax
801040ad:	85 c0                	test   %eax,%eax
801040af:	74 15                	je     801040c6 <mpinit+0xe6>
        bcpu = &cpus[ncpu];
801040b1:	a1 80 39 11 80       	mov    0x80113980,%eax
801040b6:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801040bc:	05 a0 33 11 80       	add    $0x801133a0,%eax
801040c1:	a3 84 c6 10 80       	mov    %eax,0x8010c684
      cpus[ncpu].id = ncpu;
801040c6:	a1 80 39 11 80       	mov    0x80113980,%eax
801040cb:	8b 15 80 39 11 80    	mov    0x80113980,%edx
801040d1:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801040d7:	05 a0 33 11 80       	add    $0x801133a0,%eax
801040dc:	88 10                	mov    %dl,(%eax)
      ncpu++;
801040de:	a1 80 39 11 80       	mov    0x80113980,%eax
801040e3:	83 c0 01             	add    $0x1,%eax
801040e6:	a3 80 39 11 80       	mov    %eax,0x80113980
      p += sizeof(struct mpproc);
801040eb:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
801040ef:	eb 42                	jmp    80104133 <mpinit+0x153>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
801040f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
801040f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801040fa:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801040fe:	a2 80 33 11 80       	mov    %al,0x80113380
      p += sizeof(struct mpioapic);
80104103:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80104107:	eb 2a                	jmp    80104133 <mpinit+0x153>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80104109:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
8010410d:	eb 24                	jmp    80104133 <mpinit+0x153>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
8010410f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104112:	0f b6 00             	movzbl (%eax),%eax
80104115:	0f b6 c0             	movzbl %al,%eax
80104118:	83 ec 08             	sub    $0x8,%esp
8010411b:	50                   	push   %eax
8010411c:	68 18 92 10 80       	push   $0x80109218
80104121:	e8 a0 c2 ff ff       	call   801003c6 <cprintf>
80104126:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
80104129:	c7 05 84 33 11 80 00 	movl   $0x0,0x80113384
80104130:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80104133:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104136:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80104139:	0f 82 02 ff ff ff    	jb     80104041 <mpinit+0x61>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
8010413f:	a1 84 33 11 80       	mov    0x80113384,%eax
80104144:	85 c0                	test   %eax,%eax
80104146:	75 1d                	jne    80104165 <mpinit+0x185>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80104148:	c7 05 80 39 11 80 01 	movl   $0x1,0x80113980
8010414f:	00 00 00 
    lapic = 0;
80104152:	c7 05 9c 32 11 80 00 	movl   $0x0,0x8011329c
80104159:	00 00 00 
    ioapicid = 0;
8010415c:	c6 05 80 33 11 80 00 	movb   $0x0,0x80113380
    return;
80104163:	eb 3e                	jmp    801041a3 <mpinit+0x1c3>
  }

  if(mp->imcrp){
80104165:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104168:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
8010416c:	84 c0                	test   %al,%al
8010416e:	74 33                	je     801041a3 <mpinit+0x1c3>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80104170:	83 ec 08             	sub    $0x8,%esp
80104173:	6a 70                	push   $0x70
80104175:	6a 22                	push   $0x22
80104177:	e8 1c fc ff ff       	call   80103d98 <outb>
8010417c:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010417f:	83 ec 0c             	sub    $0xc,%esp
80104182:	6a 23                	push   $0x23
80104184:	e8 f2 fb ff ff       	call   80103d7b <inb>
80104189:	83 c4 10             	add    $0x10,%esp
8010418c:	83 c8 01             	or     $0x1,%eax
8010418f:	0f b6 c0             	movzbl %al,%eax
80104192:	83 ec 08             	sub    $0x8,%esp
80104195:	50                   	push   %eax
80104196:	6a 23                	push   $0x23
80104198:	e8 fb fb ff ff       	call   80103d98 <outb>
8010419d:	83 c4 10             	add    $0x10,%esp
801041a0:	eb 01                	jmp    801041a3 <mpinit+0x1c3>
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
801041a2:	90                   	nop
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
801041a3:	c9                   	leave  
801041a4:	c3                   	ret    

801041a5 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801041a5:	55                   	push   %ebp
801041a6:	89 e5                	mov    %esp,%ebp
801041a8:	83 ec 08             	sub    $0x8,%esp
801041ab:	8b 55 08             	mov    0x8(%ebp),%edx
801041ae:	8b 45 0c             	mov    0xc(%ebp),%eax
801041b1:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801041b5:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801041b8:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801041bc:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801041c0:	ee                   	out    %al,(%dx)
}
801041c1:	90                   	nop
801041c2:	c9                   	leave  
801041c3:	c3                   	ret    

801041c4 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
801041c4:	55                   	push   %ebp
801041c5:	89 e5                	mov    %esp,%ebp
801041c7:	83 ec 04             	sub    $0x4,%esp
801041ca:	8b 45 08             	mov    0x8(%ebp),%eax
801041cd:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
801041d1:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801041d5:	66 a3 00 c0 10 80    	mov    %ax,0x8010c000
  outb(IO_PIC1+1, mask);
801041db:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801041df:	0f b6 c0             	movzbl %al,%eax
801041e2:	50                   	push   %eax
801041e3:	6a 21                	push   $0x21
801041e5:	e8 bb ff ff ff       	call   801041a5 <outb>
801041ea:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, mask >> 8);
801041ed:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801041f1:	66 c1 e8 08          	shr    $0x8,%ax
801041f5:	0f b6 c0             	movzbl %al,%eax
801041f8:	50                   	push   %eax
801041f9:	68 a1 00 00 00       	push   $0xa1
801041fe:	e8 a2 ff ff ff       	call   801041a5 <outb>
80104203:	83 c4 08             	add    $0x8,%esp
}
80104206:	90                   	nop
80104207:	c9                   	leave  
80104208:	c3                   	ret    

80104209 <picenable>:

void
picenable(int irq)
{
80104209:	55                   	push   %ebp
8010420a:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
8010420c:	8b 45 08             	mov    0x8(%ebp),%eax
8010420f:	ba 01 00 00 00       	mov    $0x1,%edx
80104214:	89 c1                	mov    %eax,%ecx
80104216:	d3 e2                	shl    %cl,%edx
80104218:	89 d0                	mov    %edx,%eax
8010421a:	f7 d0                	not    %eax
8010421c:	89 c2                	mov    %eax,%edx
8010421e:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80104225:	21 d0                	and    %edx,%eax
80104227:	0f b7 c0             	movzwl %ax,%eax
8010422a:	50                   	push   %eax
8010422b:	e8 94 ff ff ff       	call   801041c4 <picsetmask>
80104230:	83 c4 04             	add    $0x4,%esp
}
80104233:	90                   	nop
80104234:	c9                   	leave  
80104235:	c3                   	ret    

80104236 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80104236:	55                   	push   %ebp
80104237:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80104239:	68 ff 00 00 00       	push   $0xff
8010423e:	6a 21                	push   $0x21
80104240:	e8 60 ff ff ff       	call   801041a5 <outb>
80104245:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80104248:	68 ff 00 00 00       	push   $0xff
8010424d:	68 a1 00 00 00       	push   $0xa1
80104252:	e8 4e ff ff ff       	call   801041a5 <outb>
80104257:	83 c4 08             	add    $0x8,%esp

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
8010425a:	6a 11                	push   $0x11
8010425c:	6a 20                	push   $0x20
8010425e:	e8 42 ff ff ff       	call   801041a5 <outb>
80104263:	83 c4 08             	add    $0x8,%esp

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80104266:	6a 20                	push   $0x20
80104268:	6a 21                	push   $0x21
8010426a:	e8 36 ff ff ff       	call   801041a5 <outb>
8010426f:	83 c4 08             	add    $0x8,%esp

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80104272:	6a 04                	push   $0x4
80104274:	6a 21                	push   $0x21
80104276:	e8 2a ff ff ff       	call   801041a5 <outb>
8010427b:	83 c4 08             	add    $0x8,%esp
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
8010427e:	6a 03                	push   $0x3
80104280:	6a 21                	push   $0x21
80104282:	e8 1e ff ff ff       	call   801041a5 <outb>
80104287:	83 c4 08             	add    $0x8,%esp

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
8010428a:	6a 11                	push   $0x11
8010428c:	68 a0 00 00 00       	push   $0xa0
80104291:	e8 0f ff ff ff       	call   801041a5 <outb>
80104296:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80104299:	6a 28                	push   $0x28
8010429b:	68 a1 00 00 00       	push   $0xa1
801042a0:	e8 00 ff ff ff       	call   801041a5 <outb>
801042a5:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
801042a8:	6a 02                	push   $0x2
801042aa:	68 a1 00 00 00       	push   $0xa1
801042af:	e8 f1 fe ff ff       	call   801041a5 <outb>
801042b4:	83 c4 08             	add    $0x8,%esp
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
801042b7:	6a 03                	push   $0x3
801042b9:	68 a1 00 00 00       	push   $0xa1
801042be:	e8 e2 fe ff ff       	call   801041a5 <outb>
801042c3:	83 c4 08             	add    $0x8,%esp

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
801042c6:	6a 68                	push   $0x68
801042c8:	6a 20                	push   $0x20
801042ca:	e8 d6 fe ff ff       	call   801041a5 <outb>
801042cf:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC1, 0x0a);             // read IRR by default
801042d2:	6a 0a                	push   $0xa
801042d4:	6a 20                	push   $0x20
801042d6:	e8 ca fe ff ff       	call   801041a5 <outb>
801042db:	83 c4 08             	add    $0x8,%esp

  outb(IO_PIC2, 0x68);             // OCW3
801042de:	6a 68                	push   $0x68
801042e0:	68 a0 00 00 00       	push   $0xa0
801042e5:	e8 bb fe ff ff       	call   801041a5 <outb>
801042ea:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2, 0x0a);             // OCW3
801042ed:	6a 0a                	push   $0xa
801042ef:	68 a0 00 00 00       	push   $0xa0
801042f4:	e8 ac fe ff ff       	call   801041a5 <outb>
801042f9:	83 c4 08             	add    $0x8,%esp

  if(irqmask != 0xFFFF)
801042fc:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80104303:	66 83 f8 ff          	cmp    $0xffff,%ax
80104307:	74 13                	je     8010431c <picinit+0xe6>
    picsetmask(irqmask);
80104309:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80104310:	0f b7 c0             	movzwl %ax,%eax
80104313:	50                   	push   %eax
80104314:	e8 ab fe ff ff       	call   801041c4 <picsetmask>
80104319:	83 c4 04             	add    $0x4,%esp
}
8010431c:	90                   	nop
8010431d:	c9                   	leave  
8010431e:	c3                   	ret    

8010431f <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
8010431f:	55                   	push   %ebp
80104320:	89 e5                	mov    %esp,%ebp
80104322:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
80104325:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
8010432c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010432f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104335:	8b 45 0c             	mov    0xc(%ebp),%eax
80104338:	8b 10                	mov    (%eax),%edx
8010433a:	8b 45 08             	mov    0x8(%ebp),%eax
8010433d:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010433f:	e8 f7 cc ff ff       	call   8010103b <filealloc>
80104344:	89 c2                	mov    %eax,%edx
80104346:	8b 45 08             	mov    0x8(%ebp),%eax
80104349:	89 10                	mov    %edx,(%eax)
8010434b:	8b 45 08             	mov    0x8(%ebp),%eax
8010434e:	8b 00                	mov    (%eax),%eax
80104350:	85 c0                	test   %eax,%eax
80104352:	0f 84 cb 00 00 00    	je     80104423 <pipealloc+0x104>
80104358:	e8 de cc ff ff       	call   8010103b <filealloc>
8010435d:	89 c2                	mov    %eax,%edx
8010435f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104362:	89 10                	mov    %edx,(%eax)
80104364:	8b 45 0c             	mov    0xc(%ebp),%eax
80104367:	8b 00                	mov    (%eax),%eax
80104369:	85 c0                	test   %eax,%eax
8010436b:	0f 84 b2 00 00 00    	je     80104423 <pipealloc+0x104>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80104371:	e8 ce eb ff ff       	call   80102f44 <kalloc>
80104376:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104379:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010437d:	0f 84 9f 00 00 00    	je     80104422 <pipealloc+0x103>
    goto bad;
  p->readopen = 1;
80104383:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104386:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010438d:	00 00 00 
  p->writeopen = 1;
80104390:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104393:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010439a:	00 00 00 
  p->nwrite = 0;
8010439d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043a0:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801043a7:	00 00 00 
  p->nread = 0;
801043aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043ad:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801043b4:	00 00 00 
  initlock(&p->lock, "pipe");
801043b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043ba:	83 ec 08             	sub    $0x8,%esp
801043bd:	68 4c 92 10 80       	push   $0x8010924c
801043c2:	50                   	push   %eax
801043c3:	e8 8c 13 00 00       	call   80105754 <initlock>
801043c8:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801043cb:	8b 45 08             	mov    0x8(%ebp),%eax
801043ce:	8b 00                	mov    (%eax),%eax
801043d0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801043d6:	8b 45 08             	mov    0x8(%ebp),%eax
801043d9:	8b 00                	mov    (%eax),%eax
801043db:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801043df:	8b 45 08             	mov    0x8(%ebp),%eax
801043e2:	8b 00                	mov    (%eax),%eax
801043e4:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801043e8:	8b 45 08             	mov    0x8(%ebp),%eax
801043eb:	8b 00                	mov    (%eax),%eax
801043ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043f0:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
801043f3:	8b 45 0c             	mov    0xc(%ebp),%eax
801043f6:	8b 00                	mov    (%eax),%eax
801043f8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801043fe:	8b 45 0c             	mov    0xc(%ebp),%eax
80104401:	8b 00                	mov    (%eax),%eax
80104403:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80104407:	8b 45 0c             	mov    0xc(%ebp),%eax
8010440a:	8b 00                	mov    (%eax),%eax
8010440c:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80104410:	8b 45 0c             	mov    0xc(%ebp),%eax
80104413:	8b 00                	mov    (%eax),%eax
80104415:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104418:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
8010441b:	b8 00 00 00 00       	mov    $0x0,%eax
80104420:	eb 4e                	jmp    80104470 <pipealloc+0x151>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
80104422:	90                   	nop
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;

 bad:
  if(p)
80104423:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104427:	74 0e                	je     80104437 <pipealloc+0x118>
    kfree((char*)p);
80104429:	83 ec 0c             	sub    $0xc,%esp
8010442c:	ff 75 f4             	pushl  -0xc(%ebp)
8010442f:	e8 73 ea ff ff       	call   80102ea7 <kfree>
80104434:	83 c4 10             	add    $0x10,%esp
  if(*f0)
80104437:	8b 45 08             	mov    0x8(%ebp),%eax
8010443a:	8b 00                	mov    (%eax),%eax
8010443c:	85 c0                	test   %eax,%eax
8010443e:	74 11                	je     80104451 <pipealloc+0x132>
    fileclose(*f0);
80104440:	8b 45 08             	mov    0x8(%ebp),%eax
80104443:	8b 00                	mov    (%eax),%eax
80104445:	83 ec 0c             	sub    $0xc,%esp
80104448:	50                   	push   %eax
80104449:	e8 ab cc ff ff       	call   801010f9 <fileclose>
8010444e:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80104451:	8b 45 0c             	mov    0xc(%ebp),%eax
80104454:	8b 00                	mov    (%eax),%eax
80104456:	85 c0                	test   %eax,%eax
80104458:	74 11                	je     8010446b <pipealloc+0x14c>
    fileclose(*f1);
8010445a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010445d:	8b 00                	mov    (%eax),%eax
8010445f:	83 ec 0c             	sub    $0xc,%esp
80104462:	50                   	push   %eax
80104463:	e8 91 cc ff ff       	call   801010f9 <fileclose>
80104468:	83 c4 10             	add    $0x10,%esp
  return -1;
8010446b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104470:	c9                   	leave  
80104471:	c3                   	ret    

80104472 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80104472:	55                   	push   %ebp
80104473:	89 e5                	mov    %esp,%ebp
80104475:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
80104478:	8b 45 08             	mov    0x8(%ebp),%eax
8010447b:	83 ec 0c             	sub    $0xc,%esp
8010447e:	50                   	push   %eax
8010447f:	e8 f2 12 00 00       	call   80105776 <acquire>
80104484:	83 c4 10             	add    $0x10,%esp
  if(writable){
80104487:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010448b:	74 23                	je     801044b0 <pipeclose+0x3e>
    p->writeopen = 0;
8010448d:	8b 45 08             	mov    0x8(%ebp),%eax
80104490:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80104497:	00 00 00 
    wakeup(&p->nread);
8010449a:	8b 45 08             	mov    0x8(%ebp),%eax
8010449d:	05 34 02 00 00       	add    $0x234,%eax
801044a2:	83 ec 0c             	sub    $0xc,%esp
801044a5:	50                   	push   %eax
801044a6:	e8 0d 0d 00 00       	call   801051b8 <wakeup>
801044ab:	83 c4 10             	add    $0x10,%esp
801044ae:	eb 21                	jmp    801044d1 <pipeclose+0x5f>
  } else {
    p->readopen = 0;
801044b0:	8b 45 08             	mov    0x8(%ebp),%eax
801044b3:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
801044ba:	00 00 00 
    wakeup(&p->nwrite);
801044bd:	8b 45 08             	mov    0x8(%ebp),%eax
801044c0:	05 38 02 00 00       	add    $0x238,%eax
801044c5:	83 ec 0c             	sub    $0xc,%esp
801044c8:	50                   	push   %eax
801044c9:	e8 ea 0c 00 00       	call   801051b8 <wakeup>
801044ce:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
801044d1:	8b 45 08             	mov    0x8(%ebp),%eax
801044d4:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801044da:	85 c0                	test   %eax,%eax
801044dc:	75 2c                	jne    8010450a <pipeclose+0x98>
801044de:	8b 45 08             	mov    0x8(%ebp),%eax
801044e1:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801044e7:	85 c0                	test   %eax,%eax
801044e9:	75 1f                	jne    8010450a <pipeclose+0x98>
    release(&p->lock);
801044eb:	8b 45 08             	mov    0x8(%ebp),%eax
801044ee:	83 ec 0c             	sub    $0xc,%esp
801044f1:	50                   	push   %eax
801044f2:	e8 e6 12 00 00       	call   801057dd <release>
801044f7:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
801044fa:	83 ec 0c             	sub    $0xc,%esp
801044fd:	ff 75 08             	pushl  0x8(%ebp)
80104500:	e8 a2 e9 ff ff       	call   80102ea7 <kfree>
80104505:	83 c4 10             	add    $0x10,%esp
80104508:	eb 0f                	jmp    80104519 <pipeclose+0xa7>
  } else
    release(&p->lock);
8010450a:	8b 45 08             	mov    0x8(%ebp),%eax
8010450d:	83 ec 0c             	sub    $0xc,%esp
80104510:	50                   	push   %eax
80104511:	e8 c7 12 00 00       	call   801057dd <release>
80104516:	83 c4 10             	add    $0x10,%esp
}
80104519:	90                   	nop
8010451a:	c9                   	leave  
8010451b:	c3                   	ret    

8010451c <pipewrite>:

int
pipewrite(struct pipe *p, char *addr, int n)
{
8010451c:	55                   	push   %ebp
8010451d:	89 e5                	mov    %esp,%ebp
8010451f:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
80104522:	8b 45 08             	mov    0x8(%ebp),%eax
80104525:	83 ec 0c             	sub    $0xc,%esp
80104528:	50                   	push   %eax
80104529:	e8 48 12 00 00       	call   80105776 <acquire>
8010452e:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
80104531:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104538:	e9 ad 00 00 00       	jmp    801045ea <pipewrite+0xce>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
8010453d:	8b 45 08             	mov    0x8(%ebp),%eax
80104540:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104546:	85 c0                	test   %eax,%eax
80104548:	74 0d                	je     80104557 <pipewrite+0x3b>
8010454a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104550:	8b 40 24             	mov    0x24(%eax),%eax
80104553:	85 c0                	test   %eax,%eax
80104555:	74 19                	je     80104570 <pipewrite+0x54>
        release(&p->lock);
80104557:	8b 45 08             	mov    0x8(%ebp),%eax
8010455a:	83 ec 0c             	sub    $0xc,%esp
8010455d:	50                   	push   %eax
8010455e:	e8 7a 12 00 00       	call   801057dd <release>
80104563:	83 c4 10             	add    $0x10,%esp
        return -1;
80104566:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010456b:	e9 a8 00 00 00       	jmp    80104618 <pipewrite+0xfc>
      }
      wakeup(&p->nread);
80104570:	8b 45 08             	mov    0x8(%ebp),%eax
80104573:	05 34 02 00 00       	add    $0x234,%eax
80104578:	83 ec 0c             	sub    $0xc,%esp
8010457b:	50                   	push   %eax
8010457c:	e8 37 0c 00 00       	call   801051b8 <wakeup>
80104581:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104584:	8b 45 08             	mov    0x8(%ebp),%eax
80104587:	8b 55 08             	mov    0x8(%ebp),%edx
8010458a:	81 c2 38 02 00 00    	add    $0x238,%edx
80104590:	83 ec 08             	sub    $0x8,%esp
80104593:	50                   	push   %eax
80104594:	52                   	push   %edx
80104595:	e8 37 0b 00 00       	call   801050d1 <sleep>
8010459a:	83 c4 10             	add    $0x10,%esp
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010459d:	8b 45 08             	mov    0x8(%ebp),%eax
801045a0:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
801045a6:	8b 45 08             	mov    0x8(%ebp),%eax
801045a9:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801045af:	05 00 02 00 00       	add    $0x200,%eax
801045b4:	39 c2                	cmp    %eax,%edx
801045b6:	74 85                	je     8010453d <pipewrite+0x21>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801045b8:	8b 45 08             	mov    0x8(%ebp),%eax
801045bb:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801045c1:	8d 48 01             	lea    0x1(%eax),%ecx
801045c4:	8b 55 08             	mov    0x8(%ebp),%edx
801045c7:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
801045cd:	25 ff 01 00 00       	and    $0x1ff,%eax
801045d2:	89 c1                	mov    %eax,%ecx
801045d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045d7:	8b 45 0c             	mov    0xc(%ebp),%eax
801045da:	01 d0                	add    %edx,%eax
801045dc:	0f b6 10             	movzbl (%eax),%edx
801045df:	8b 45 08             	mov    0x8(%ebp),%eax
801045e2:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801045e6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801045ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045ed:	3b 45 10             	cmp    0x10(%ebp),%eax
801045f0:	7c ab                	jl     8010459d <pipewrite+0x81>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801045f2:	8b 45 08             	mov    0x8(%ebp),%eax
801045f5:	05 34 02 00 00       	add    $0x234,%eax
801045fa:	83 ec 0c             	sub    $0xc,%esp
801045fd:	50                   	push   %eax
801045fe:	e8 b5 0b 00 00       	call   801051b8 <wakeup>
80104603:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104606:	8b 45 08             	mov    0x8(%ebp),%eax
80104609:	83 ec 0c             	sub    $0xc,%esp
8010460c:	50                   	push   %eax
8010460d:	e8 cb 11 00 00       	call   801057dd <release>
80104612:	83 c4 10             	add    $0x10,%esp
  return n;
80104615:	8b 45 10             	mov    0x10(%ebp),%eax
}
80104618:	c9                   	leave  
80104619:	c3                   	ret    

8010461a <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
8010461a:	55                   	push   %ebp
8010461b:	89 e5                	mov    %esp,%ebp
8010461d:	53                   	push   %ebx
8010461e:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
80104621:	8b 45 08             	mov    0x8(%ebp),%eax
80104624:	83 ec 0c             	sub    $0xc,%esp
80104627:	50                   	push   %eax
80104628:	e8 49 11 00 00       	call   80105776 <acquire>
8010462d:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104630:	eb 3f                	jmp    80104671 <piperead+0x57>
    if(proc->killed){
80104632:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104638:	8b 40 24             	mov    0x24(%eax),%eax
8010463b:	85 c0                	test   %eax,%eax
8010463d:	74 19                	je     80104658 <piperead+0x3e>
      release(&p->lock);
8010463f:	8b 45 08             	mov    0x8(%ebp),%eax
80104642:	83 ec 0c             	sub    $0xc,%esp
80104645:	50                   	push   %eax
80104646:	e8 92 11 00 00       	call   801057dd <release>
8010464b:	83 c4 10             	add    $0x10,%esp
      return -1;
8010464e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104653:	e9 bf 00 00 00       	jmp    80104717 <piperead+0xfd>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104658:	8b 45 08             	mov    0x8(%ebp),%eax
8010465b:	8b 55 08             	mov    0x8(%ebp),%edx
8010465e:	81 c2 34 02 00 00    	add    $0x234,%edx
80104664:	83 ec 08             	sub    $0x8,%esp
80104667:	50                   	push   %eax
80104668:	52                   	push   %edx
80104669:	e8 63 0a 00 00       	call   801050d1 <sleep>
8010466e:	83 c4 10             	add    $0x10,%esp
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104671:	8b 45 08             	mov    0x8(%ebp),%eax
80104674:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
8010467a:	8b 45 08             	mov    0x8(%ebp),%eax
8010467d:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104683:	39 c2                	cmp    %eax,%edx
80104685:	75 0d                	jne    80104694 <piperead+0x7a>
80104687:	8b 45 08             	mov    0x8(%ebp),%eax
8010468a:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104690:	85 c0                	test   %eax,%eax
80104692:	75 9e                	jne    80104632 <piperead+0x18>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104694:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010469b:	eb 49                	jmp    801046e6 <piperead+0xcc>
    if(p->nread == p->nwrite)
8010469d:	8b 45 08             	mov    0x8(%ebp),%eax
801046a0:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801046a6:	8b 45 08             	mov    0x8(%ebp),%eax
801046a9:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801046af:	39 c2                	cmp    %eax,%edx
801046b1:	74 3d                	je     801046f0 <piperead+0xd6>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801046b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801046b6:	8b 45 0c             	mov    0xc(%ebp),%eax
801046b9:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801046bc:	8b 45 08             	mov    0x8(%ebp),%eax
801046bf:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801046c5:	8d 48 01             	lea    0x1(%eax),%ecx
801046c8:	8b 55 08             	mov    0x8(%ebp),%edx
801046cb:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
801046d1:	25 ff 01 00 00       	and    $0x1ff,%eax
801046d6:	89 c2                	mov    %eax,%edx
801046d8:	8b 45 08             	mov    0x8(%ebp),%eax
801046db:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
801046e0:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801046e2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801046e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046e9:	3b 45 10             	cmp    0x10(%ebp),%eax
801046ec:	7c af                	jl     8010469d <piperead+0x83>
801046ee:	eb 01                	jmp    801046f1 <piperead+0xd7>
    if(p->nread == p->nwrite)
      break;
801046f0:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801046f1:	8b 45 08             	mov    0x8(%ebp),%eax
801046f4:	05 38 02 00 00       	add    $0x238,%eax
801046f9:	83 ec 0c             	sub    $0xc,%esp
801046fc:	50                   	push   %eax
801046fd:	e8 b6 0a 00 00       	call   801051b8 <wakeup>
80104702:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104705:	8b 45 08             	mov    0x8(%ebp),%eax
80104708:	83 ec 0c             	sub    $0xc,%esp
8010470b:	50                   	push   %eax
8010470c:	e8 cc 10 00 00       	call   801057dd <release>
80104711:	83 c4 10             	add    $0x10,%esp
  return i;
80104714:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104717:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010471a:	c9                   	leave  
8010471b:	c3                   	ret    

8010471c <hlt>:
}

// hlt() added by Noah Zentzis, Fall 2016.
static inline void
hlt()
{
8010471c:	55                   	push   %ebp
8010471d:	89 e5                	mov    %esp,%ebp
  asm volatile("hlt");
8010471f:	f4                   	hlt    
}
80104720:	90                   	nop
80104721:	5d                   	pop    %ebp
80104722:	c3                   	ret    

80104723 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104723:	55                   	push   %ebp
80104724:	89 e5                	mov    %esp,%ebp
80104726:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104729:	9c                   	pushf  
8010472a:	58                   	pop    %eax
8010472b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010472e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104731:	c9                   	leave  
80104732:	c3                   	ret    

80104733 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
80104733:	55                   	push   %ebp
80104734:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104736:	fb                   	sti    
}
80104737:	90                   	nop
80104738:	5d                   	pop    %ebp
80104739:	c3                   	ret    

8010473a <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
8010473a:	55                   	push   %ebp
8010473b:	89 e5                	mov    %esp,%ebp
8010473d:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
80104740:	83 ec 08             	sub    $0x8,%esp
80104743:	68 54 92 10 80       	push   $0x80109254
80104748:	68 a0 39 11 80       	push   $0x801139a0
8010474d:	e8 02 10 00 00       	call   80105754 <initlock>
80104752:	83 c4 10             	add    $0x10,%esp
}
80104755:	90                   	nop
80104756:	c9                   	leave  
80104757:	c3                   	ret    

80104758 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104758:	55                   	push   %ebp
80104759:	89 e5                	mov    %esp,%ebp
8010475b:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010475e:	83 ec 0c             	sub    $0xc,%esp
80104761:	68 a0 39 11 80       	push   $0x801139a0
80104766:	e8 0b 10 00 00       	call   80105776 <acquire>
8010476b:	83 c4 10             	add    $0x10,%esp
  #ifdef CS333_P3P4
  p = removeFromQueue(&ptable.pLists.free);
  if(p)
    goto found;
  #else
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010476e:	c7 45 f4 d4 39 11 80 	movl   $0x801139d4,-0xc(%ebp)
80104775:	eb 11                	jmp    80104788 <allocproc+0x30>
    if(p->state == UNUSED)
80104777:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010477a:	8b 40 0c             	mov    0xc(%eax),%eax
8010477d:	85 c0                	test   %eax,%eax
8010477f:	74 2a                	je     801047ab <allocproc+0x53>
  #ifdef CS333_P3P4
  p = removeFromQueue(&ptable.pLists.free);
  if(p)
    goto found;
  #else
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104781:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
80104788:	81 7d f4 d4 5d 11 80 	cmpl   $0x80115dd4,-0xc(%ebp)
8010478f:	72 e6                	jb     80104777 <allocproc+0x1f>
    if(p->state == UNUSED)
      goto found;
  #endif
  release(&ptable.lock);
80104791:	83 ec 0c             	sub    $0xc,%esp
80104794:	68 a0 39 11 80       	push   $0x801139a0
80104799:	e8 3f 10 00 00       	call   801057dd <release>
8010479e:	83 c4 10             	add    $0x10,%esp
  return 0;
801047a1:	b8 00 00 00 00       	mov    $0x0,%eax
801047a6:	e9 df 00 00 00       	jmp    8010488a <allocproc+0x132>
  if(p)
    goto found;
  #else
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
801047ab:	90                   	nop
  #ifdef CS333_P3P4
  assertState(p, UNUSED);
  p->state = EMBRYO;
  addToListFront(&ptable.pLists.embryo, p);
  #else
  p->state = EMBRYO;
801047ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047af:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  #endif
  p->pid = nextpid++;
801047b6:	a1 04 c0 10 80       	mov    0x8010c004,%eax
801047bb:	8d 50 01             	lea    0x1(%eax),%edx
801047be:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
801047c4:	89 c2                	mov    %eax,%edx
801047c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047c9:	89 50 10             	mov    %edx,0x10(%eax)
  release(&ptable.lock);
801047cc:	83 ec 0c             	sub    $0xc,%esp
801047cf:	68 a0 39 11 80       	push   $0x801139a0
801047d4:	e8 04 10 00 00       	call   801057dd <release>
801047d9:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801047dc:	e8 63 e7 ff ff       	call   80102f44 <kalloc>
801047e1:	89 c2                	mov    %eax,%edx
801047e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047e6:	89 50 08             	mov    %edx,0x8(%eax)
801047e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047ec:	8b 40 08             	mov    0x8(%eax),%eax
801047ef:	85 c0                	test   %eax,%eax
801047f1:	75 14                	jne    80104807 <allocproc+0xaf>
    #ifdef CS333_P3P4
    switchStates(&ptable.pLists.embryo, &ptable.pLists.free, p,
        EMBRYO, UNUSED);
    #else
    p->state = UNUSED;
801047f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047f6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    #endif
    return 0;
801047fd:	b8 00 00 00 00       	mov    $0x0,%eax
80104802:	e9 83 00 00 00       	jmp    8010488a <allocproc+0x132>
  }
  sp = p->kstack + KSTACKSIZE;
80104807:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010480a:	8b 40 08             	mov    0x8(%eax),%eax
8010480d:	05 00 10 00 00       	add    $0x1000,%eax
80104812:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104815:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
80104819:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010481c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010481f:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80104822:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
80104826:	ba 22 70 10 80       	mov    $0x80107022,%edx
8010482b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010482e:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80104830:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80104834:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104837:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010483a:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
8010483d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104840:	8b 40 1c             	mov    0x1c(%eax),%eax
80104843:	83 ec 04             	sub    $0x4,%esp
80104846:	6a 14                	push   $0x14
80104848:	6a 00                	push   $0x0
8010484a:	50                   	push   %eax
8010484b:	e8 89 11 00 00       	call   801059d9 <memset>
80104850:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80104853:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104856:	8b 40 1c             	mov    0x1c(%eax),%eax
80104859:	ba 8b 50 10 80       	mov    $0x8010508b,%edx
8010485e:	89 50 10             	mov    %edx,0x10(%eax)

  #ifdef CS333_P1
  p->start_ticks = ticks;
80104861:	8b 15 e0 65 11 80    	mov    0x801165e0,%edx
80104867:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010486a:	89 50 7c             	mov    %edx,0x7c(%eax)
  #endif
  #ifdef CS333_P2
  p->cpu_ticks_total = 0;
8010486d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104870:	c7 80 88 00 00 00 00 	movl   $0x0,0x88(%eax)
80104877:	00 00 00 
  p->cpu_ticks_in = 0;
8010487a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010487d:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80104884:	00 00 00 
  #endif

  return p;
80104887:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010488a:	c9                   	leave  
8010488b:	c3                   	ret    

8010488c <userinit>:

// Set up first user process.
void
userinit(void)
{
8010488c:	55                   	push   %ebp
8010488d:	89 e5                	mov    %esp,%ebp
8010488f:	83 ec 18             	sub    $0x18,%esp
  for(int i = 0; i < NPROC; i++){
    addToListFront(&ptable.pLists.free, &ptable.proc[i]);
  }
  #endif
  
  p = allocproc();
80104892:	e8 c1 fe ff ff       	call   80104758 <allocproc>
80104897:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
8010489a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010489d:	a3 88 c6 10 80       	mov    %eax,0x8010c688
  if((p->pgdir = setupkvm()) == 0)
801048a2:	e8 3d 3e 00 00       	call   801086e4 <setupkvm>
801048a7:	89 c2                	mov    %eax,%edx
801048a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048ac:	89 50 04             	mov    %edx,0x4(%eax)
801048af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048b2:	8b 40 04             	mov    0x4(%eax),%eax
801048b5:	85 c0                	test   %eax,%eax
801048b7:	75 0d                	jne    801048c6 <userinit+0x3a>
    panic("userinit: out of memory?");
801048b9:	83 ec 0c             	sub    $0xc,%esp
801048bc:	68 5b 92 10 80       	push   $0x8010925b
801048c1:	e8 a0 bc ff ff       	call   80100566 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801048c6:	ba 2c 00 00 00       	mov    $0x2c,%edx
801048cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048ce:	8b 40 04             	mov    0x4(%eax),%eax
801048d1:	83 ec 04             	sub    $0x4,%esp
801048d4:	52                   	push   %edx
801048d5:	68 20 c5 10 80       	push   $0x8010c520
801048da:	50                   	push   %eax
801048db:	e8 5e 40 00 00       	call   8010893e <inituvm>
801048e0:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
801048e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048e6:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
801048ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048ef:	8b 40 18             	mov    0x18(%eax),%eax
801048f2:	83 ec 04             	sub    $0x4,%esp
801048f5:	6a 4c                	push   $0x4c
801048f7:	6a 00                	push   $0x0
801048f9:	50                   	push   %eax
801048fa:	e8 da 10 00 00       	call   801059d9 <memset>
801048ff:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104902:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104905:	8b 40 18             	mov    0x18(%eax),%eax
80104908:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010490e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104911:	8b 40 18             	mov    0x18(%eax),%eax
80104914:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010491a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010491d:	8b 40 18             	mov    0x18(%eax),%eax
80104920:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104923:	8b 52 18             	mov    0x18(%edx),%edx
80104926:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010492a:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010492e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104931:	8b 40 18             	mov    0x18(%eax),%eax
80104934:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104937:	8b 52 18             	mov    0x18(%edx),%edx
8010493a:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010493e:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104942:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104945:	8b 40 18             	mov    0x18(%eax),%eax
80104948:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010494f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104952:	8b 40 18             	mov    0x18(%eax),%eax
80104955:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010495c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010495f:	8b 40 18             	mov    0x18(%eax),%eax
80104962:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80104969:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010496c:	83 c0 6c             	add    $0x6c,%eax
8010496f:	83 ec 04             	sub    $0x4,%esp
80104972:	6a 10                	push   $0x10
80104974:	68 74 92 10 80       	push   $0x80109274
80104979:	50                   	push   %eax
8010497a:	e8 5d 12 00 00       	call   80105bdc <safestrcpy>
8010497f:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
80104982:	83 ec 0c             	sub    $0xc,%esp
80104985:	68 7d 92 10 80       	push   $0x8010927d
8010498a:	e8 d9 dc ff ff       	call   80102668 <namei>
8010498f:	83 c4 10             	add    $0x10,%esp
80104992:	89 c2                	mov    %eax,%edx
80104994:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104997:	89 50 68             	mov    %edx,0x68(%eax)

  #ifdef CS333_P2
  p->uid = DEFAULTUID;
8010499a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010499d:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801049a4:	00 00 00 
  p->gid = DEFAULTGID;
801049a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049aa:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
801049b1:	00 00 00 
  #ifdef CS333_P3P4
  p->priority = 0;
  p->budget = 50;
  switchToRunnable(&ptable.pLists.embryo, p, EMBRYO);
  #else
  p->state = RUNNABLE;
801049b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049b7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  #endif
}
801049be:	90                   	nop
801049bf:	c9                   	leave  
801049c0:	c3                   	ret    

801049c1 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801049c1:	55                   	push   %ebp
801049c2:	89 e5                	mov    %esp,%ebp
801049c4:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  
  sz = proc->sz;
801049c7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049cd:	8b 00                	mov    (%eax),%eax
801049cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
801049d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801049d6:	7e 31                	jle    80104a09 <growproc+0x48>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
801049d8:	8b 55 08             	mov    0x8(%ebp),%edx
801049db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049de:	01 c2                	add    %eax,%edx
801049e0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049e6:	8b 40 04             	mov    0x4(%eax),%eax
801049e9:	83 ec 04             	sub    $0x4,%esp
801049ec:	52                   	push   %edx
801049ed:	ff 75 f4             	pushl  -0xc(%ebp)
801049f0:	50                   	push   %eax
801049f1:	e8 95 40 00 00       	call   80108a8b <allocuvm>
801049f6:	83 c4 10             	add    $0x10,%esp
801049f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801049fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104a00:	75 3e                	jne    80104a40 <growproc+0x7f>
      return -1;
80104a02:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a07:	eb 59                	jmp    80104a62 <growproc+0xa1>
  } else if(n < 0){
80104a09:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104a0d:	79 31                	jns    80104a40 <growproc+0x7f>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80104a0f:	8b 55 08             	mov    0x8(%ebp),%edx
80104a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a15:	01 c2                	add    %eax,%edx
80104a17:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a1d:	8b 40 04             	mov    0x4(%eax),%eax
80104a20:	83 ec 04             	sub    $0x4,%esp
80104a23:	52                   	push   %edx
80104a24:	ff 75 f4             	pushl  -0xc(%ebp)
80104a27:	50                   	push   %eax
80104a28:	e8 27 41 00 00       	call   80108b54 <deallocuvm>
80104a2d:	83 c4 10             	add    $0x10,%esp
80104a30:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104a33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104a37:	75 07                	jne    80104a40 <growproc+0x7f>
      return -1;
80104a39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a3e:	eb 22                	jmp    80104a62 <growproc+0xa1>
  }
  proc->sz = sz;
80104a40:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a46:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104a49:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
80104a4b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a51:	83 ec 0c             	sub    $0xc,%esp
80104a54:	50                   	push   %eax
80104a55:	e8 71 3d 00 00       	call   801087cb <switchuvm>
80104a5a:	83 c4 10             	add    $0x10,%esp
  return 0;
80104a5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104a62:	c9                   	leave  
80104a63:	c3                   	ret    

80104a64 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104a64:	55                   	push   %ebp
80104a65:	89 e5                	mov    %esp,%ebp
80104a67:	57                   	push   %edi
80104a68:	56                   	push   %esi
80104a69:	53                   	push   %ebx
80104a6a:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
80104a6d:	e8 e6 fc ff ff       	call   80104758 <allocproc>
80104a72:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104a75:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104a79:	75 0a                	jne    80104a85 <fork+0x21>
    return -1;
80104a7b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a80:	e9 92 01 00 00       	jmp    80104c17 <fork+0x1b3>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104a85:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a8b:	8b 10                	mov    (%eax),%edx
80104a8d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a93:	8b 40 04             	mov    0x4(%eax),%eax
80104a96:	83 ec 08             	sub    $0x8,%esp
80104a99:	52                   	push   %edx
80104a9a:	50                   	push   %eax
80104a9b:	e8 52 42 00 00       	call   80108cf2 <copyuvm>
80104aa0:	83 c4 10             	add    $0x10,%esp
80104aa3:	89 c2                	mov    %eax,%edx
80104aa5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104aa8:	89 50 04             	mov    %edx,0x4(%eax)
80104aab:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104aae:	8b 40 04             	mov    0x4(%eax),%eax
80104ab1:	85 c0                	test   %eax,%eax
80104ab3:	75 30                	jne    80104ae5 <fork+0x81>
    kfree(np->kstack);
80104ab5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ab8:	8b 40 08             	mov    0x8(%eax),%eax
80104abb:	83 ec 0c             	sub    $0xc,%esp
80104abe:	50                   	push   %eax
80104abf:	e8 e3 e3 ff ff       	call   80102ea7 <kfree>
80104ac4:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80104ac7:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104aca:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    #ifdef CS333_P3P4
    switchStates(&ptable.pLists.embryo, &ptable.pLists.free, np,
        EMBRYO, UNUSED);
    #else
    np->state = UNUSED;
80104ad1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ad4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    #endif
    return -1;
80104adb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ae0:	e9 32 01 00 00       	jmp    80104c17 <fork+0x1b3>
  }
  np->sz = proc->sz;
80104ae5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104aeb:	8b 10                	mov    (%eax),%edx
80104aed:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104af0:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80104af2:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104af9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104afc:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104aff:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b02:	8b 50 18             	mov    0x18(%eax),%edx
80104b05:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b0b:	8b 40 18             	mov    0x18(%eax),%eax
80104b0e:	89 c3                	mov    %eax,%ebx
80104b10:	b8 13 00 00 00       	mov    $0x13,%eax
80104b15:	89 d7                	mov    %edx,%edi
80104b17:	89 de                	mov    %ebx,%esi
80104b19:	89 c1                	mov    %eax,%ecx
80104b1b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  #ifdef CS333_P2
  np->uid = proc->uid;
80104b1d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b23:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80104b29:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b2c:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  np->gid = proc->gid;
80104b32:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b38:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80104b3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b41:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
  #endif

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104b47:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b4a:	8b 40 18             	mov    0x18(%eax),%eax
80104b4d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104b54:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104b5b:	eb 43                	jmp    80104ba0 <fork+0x13c>
    if(proc->ofile[i])
80104b5d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b63:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104b66:	83 c2 08             	add    $0x8,%edx
80104b69:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104b6d:	85 c0                	test   %eax,%eax
80104b6f:	74 2b                	je     80104b9c <fork+0x138>
      np->ofile[i] = filedup(proc->ofile[i]);
80104b71:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b77:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104b7a:	83 c2 08             	add    $0x8,%edx
80104b7d:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104b81:	83 ec 0c             	sub    $0xc,%esp
80104b84:	50                   	push   %eax
80104b85:	e8 1e c5 ff ff       	call   801010a8 <filedup>
80104b8a:	83 c4 10             	add    $0x10,%esp
80104b8d:	89 c1                	mov    %eax,%ecx
80104b8f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b92:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104b95:	83 c2 08             	add    $0x8,%edx
80104b98:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  #endif

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104b9c:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104ba0:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104ba4:	7e b7                	jle    80104b5d <fork+0xf9>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80104ba6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bac:	8b 40 68             	mov    0x68(%eax),%eax
80104baf:	83 ec 0c             	sub    $0xc,%esp
80104bb2:	50                   	push   %eax
80104bb3:	e8 64 ce ff ff       	call   80101a1c <idup>
80104bb8:	83 c4 10             	add    $0x10,%esp
80104bbb:	89 c2                	mov    %eax,%edx
80104bbd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104bc0:	89 50 68             	mov    %edx,0x68(%eax)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104bc3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bc9:	8d 50 6c             	lea    0x6c(%eax),%edx
80104bcc:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104bcf:	83 c0 6c             	add    $0x6c,%eax
80104bd2:	83 ec 04             	sub    $0x4,%esp
80104bd5:	6a 10                	push   $0x10
80104bd7:	52                   	push   %edx
80104bd8:	50                   	push   %eax
80104bd9:	e8 fe 0f 00 00       	call   80105bdc <safestrcpy>
80104bde:	83 c4 10             	add    $0x10,%esp
 
  pid = np->pid;
80104be1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104be4:	8b 40 10             	mov    0x10(%eax),%eax
80104be7:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
80104bea:	83 ec 0c             	sub    $0xc,%esp
80104bed:	68 a0 39 11 80       	push   $0x801139a0
80104bf2:	e8 7f 0b 00 00       	call   80105776 <acquire>
80104bf7:	83 c4 10             	add    $0x10,%esp
  #ifdef CS333_P3P4
  np->priority = 0;
  np->budget = 50;
  switchToRunnable(&ptable.pLists.embryo, np, EMBRYO);
  #else
  np->state = RUNNABLE;
80104bfa:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104bfd:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  #endif
  release(&ptable.lock);
80104c04:	83 ec 0c             	sub    $0xc,%esp
80104c07:	68 a0 39 11 80       	push   $0x801139a0
80104c0c:	e8 cc 0b 00 00       	call   801057dd <release>
80104c11:	83 c4 10             	add    $0x10,%esp
  
  return pid;
80104c14:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104c17:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c1a:	5b                   	pop    %ebx
80104c1b:	5e                   	pop    %esi
80104c1c:	5f                   	pop    %edi
80104c1d:	5d                   	pop    %ebp
80104c1e:	c3                   	ret    

80104c1f <exit>:
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
#ifndef CS333_P3P4
void
exit(void)
{
80104c1f:	55                   	push   %ebp
80104c20:	89 e5                	mov    %esp,%ebp
80104c22:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
80104c25:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104c2c:	a1 88 c6 10 80       	mov    0x8010c688,%eax
80104c31:	39 c2                	cmp    %eax,%edx
80104c33:	75 0d                	jne    80104c42 <exit+0x23>
    panic("init exiting");
80104c35:	83 ec 0c             	sub    $0xc,%esp
80104c38:	68 7f 92 10 80       	push   $0x8010927f
80104c3d:	e8 24 b9 ff ff       	call   80100566 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104c42:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104c49:	eb 48                	jmp    80104c93 <exit+0x74>
    if(proc->ofile[fd]){
80104c4b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c51:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c54:	83 c2 08             	add    $0x8,%edx
80104c57:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104c5b:	85 c0                	test   %eax,%eax
80104c5d:	74 30                	je     80104c8f <exit+0x70>
      fileclose(proc->ofile[fd]);
80104c5f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c65:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c68:	83 c2 08             	add    $0x8,%edx
80104c6b:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104c6f:	83 ec 0c             	sub    $0xc,%esp
80104c72:	50                   	push   %eax
80104c73:	e8 81 c4 ff ff       	call   801010f9 <fileclose>
80104c78:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
80104c7b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c81:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c84:	83 c2 08             	add    $0x8,%edx
80104c87:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104c8e:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104c8f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104c93:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104c97:	7e b2                	jle    80104c4b <exit+0x2c>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80104c99:	e8 8d eb ff ff       	call   8010382b <begin_op>
  iput(proc->cwd);
80104c9e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ca4:	8b 40 68             	mov    0x68(%eax),%eax
80104ca7:	83 ec 0c             	sub    $0xc,%esp
80104caa:	50                   	push   %eax
80104cab:	e8 9e cf ff ff       	call   80101c4e <iput>
80104cb0:	83 c4 10             	add    $0x10,%esp
  end_op();
80104cb3:	e8 ff eb ff ff       	call   801038b7 <end_op>
  proc->cwd = 0;
80104cb8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cbe:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104cc5:	83 ec 0c             	sub    $0xc,%esp
80104cc8:	68 a0 39 11 80       	push   $0x801139a0
80104ccd:	e8 a4 0a 00 00       	call   80105776 <acquire>
80104cd2:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104cd5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cdb:	8b 40 14             	mov    0x14(%eax),%eax
80104cde:	83 ec 0c             	sub    $0xc,%esp
80104ce1:	50                   	push   %eax
80104ce2:	e8 8f 04 00 00       	call   80105176 <wakeup1>
80104ce7:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104cea:	c7 45 f4 d4 39 11 80 	movl   $0x801139d4,-0xc(%ebp)
80104cf1:	eb 3f                	jmp    80104d32 <exit+0x113>
    if(p->parent == proc){
80104cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cf6:	8b 50 14             	mov    0x14(%eax),%edx
80104cf9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cff:	39 c2                	cmp    %eax,%edx
80104d01:	75 28                	jne    80104d2b <exit+0x10c>
      p->parent = initproc;
80104d03:	8b 15 88 c6 10 80    	mov    0x8010c688,%edx
80104d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d0c:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d12:	8b 40 0c             	mov    0xc(%eax),%eax
80104d15:	83 f8 05             	cmp    $0x5,%eax
80104d18:	75 11                	jne    80104d2b <exit+0x10c>
        wakeup1(initproc);
80104d1a:	a1 88 c6 10 80       	mov    0x8010c688,%eax
80104d1f:	83 ec 0c             	sub    $0xc,%esp
80104d22:	50                   	push   %eax
80104d23:	e8 4e 04 00 00       	call   80105176 <wakeup1>
80104d28:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d2b:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
80104d32:	81 7d f4 d4 5d 11 80 	cmpl   $0x80115dd4,-0xc(%ebp)
80104d39:	72 b8                	jb     80104cf3 <exit+0xd4>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104d3b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d41:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104d48:	e8 11 02 00 00       	call   80104f5e <sched>
  panic("zombie exit");
80104d4d:	83 ec 0c             	sub    $0xc,%esp
80104d50:	68 8c 92 10 80       	push   $0x8010928c
80104d55:	e8 0c b8 ff ff       	call   80100566 <panic>

80104d5a <wait>:
// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
#ifndef CS333_P3P4
int
wait(void)
{
80104d5a:	55                   	push   %ebp
80104d5b:	89 e5                	mov    %esp,%ebp
80104d5d:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104d60:	83 ec 0c             	sub    $0xc,%esp
80104d63:	68 a0 39 11 80       	push   $0x801139a0
80104d68:	e8 09 0a 00 00       	call   80105776 <acquire>
80104d6d:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104d70:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d77:	c7 45 f4 d4 39 11 80 	movl   $0x801139d4,-0xc(%ebp)
80104d7e:	e9 a9 00 00 00       	jmp    80104e2c <wait+0xd2>
      if(p->parent != proc)
80104d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d86:	8b 50 14             	mov    0x14(%eax),%edx
80104d89:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d8f:	39 c2                	cmp    %eax,%edx
80104d91:	0f 85 8d 00 00 00    	jne    80104e24 <wait+0xca>
        continue;
      havekids = 1;
80104d97:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104da1:	8b 40 0c             	mov    0xc(%eax),%eax
80104da4:	83 f8 05             	cmp    $0x5,%eax
80104da7:	75 7c                	jne    80104e25 <wait+0xcb>
        // Found one.
        pid = p->pid;
80104da9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dac:	8b 40 10             	mov    0x10(%eax),%eax
80104daf:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104db2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104db5:	8b 40 08             	mov    0x8(%eax),%eax
80104db8:	83 ec 0c             	sub    $0xc,%esp
80104dbb:	50                   	push   %eax
80104dbc:	e8 e6 e0 ff ff       	call   80102ea7 <kfree>
80104dc1:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dc7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dd1:	8b 40 04             	mov    0x4(%eax),%eax
80104dd4:	83 ec 0c             	sub    $0xc,%esp
80104dd7:	50                   	push   %eax
80104dd8:	e8 34 3e 00 00       	call   80108c11 <freevm>
80104ddd:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
80104de0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104de3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ded:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104df4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104df7:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104dfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e01:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e08:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104e0f:	83 ec 0c             	sub    $0xc,%esp
80104e12:	68 a0 39 11 80       	push   $0x801139a0
80104e17:	e8 c1 09 00 00       	call   801057dd <release>
80104e1c:	83 c4 10             	add    $0x10,%esp
        return pid;
80104e1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104e22:	eb 5b                	jmp    80104e7f <wait+0x125>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
80104e24:	90                   	nop

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e25:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
80104e2c:	81 7d f4 d4 5d 11 80 	cmpl   $0x80115dd4,-0xc(%ebp)
80104e33:	0f 82 4a ff ff ff    	jb     80104d83 <wait+0x29>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104e39:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104e3d:	74 0d                	je     80104e4c <wait+0xf2>
80104e3f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e45:	8b 40 24             	mov    0x24(%eax),%eax
80104e48:	85 c0                	test   %eax,%eax
80104e4a:	74 17                	je     80104e63 <wait+0x109>
      release(&ptable.lock);
80104e4c:	83 ec 0c             	sub    $0xc,%esp
80104e4f:	68 a0 39 11 80       	push   $0x801139a0
80104e54:	e8 84 09 00 00       	call   801057dd <release>
80104e59:	83 c4 10             	add    $0x10,%esp
      return -1;
80104e5c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e61:	eb 1c                	jmp    80104e7f <wait+0x125>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104e63:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e69:	83 ec 08             	sub    $0x8,%esp
80104e6c:	68 a0 39 11 80       	push   $0x801139a0
80104e71:	50                   	push   %eax
80104e72:	e8 5a 02 00 00       	call   801050d1 <sleep>
80104e77:	83 c4 10             	add    $0x10,%esp
  }
80104e7a:	e9 f1 fe ff ff       	jmp    80104d70 <wait+0x16>
}
80104e7f:	c9                   	leave  
80104e80:	c3                   	ret    

80104e81 <scheduler>:
//      via swtch back to the scheduler.
#ifndef CS333_P3P4
// original xv6 scheduler. Use if CS333_P3P4 NOT defined.
void
scheduler(void)
{
80104e81:	55                   	push   %ebp
80104e82:	89 e5                	mov    %esp,%ebp
80104e84:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int idle;  // for checking if processor is idle

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104e87:	e8 a7 f8 ff ff       	call   80104733 <sti>

    idle = 1;  // assume idle unless we schedule a process
80104e8c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104e93:	83 ec 0c             	sub    $0xc,%esp
80104e96:	68 a0 39 11 80       	push   $0x801139a0
80104e9b:	e8 d6 08 00 00       	call   80105776 <acquire>
80104ea0:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ea3:	c7 45 f4 d4 39 11 80 	movl   $0x801139d4,-0xc(%ebp)
80104eaa:	eb 7c                	jmp    80104f28 <scheduler+0xa7>
      if(p->state != RUNNABLE)
80104eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eaf:	8b 40 0c             	mov    0xc(%eax),%eax
80104eb2:	83 f8 03             	cmp    $0x3,%eax
80104eb5:	75 69                	jne    80104f20 <scheduler+0x9f>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      idle = 0;  // not idle this timeslice
80104eb7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
      proc = p;
80104ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ec1:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80104ec7:	83 ec 0c             	sub    $0xc,%esp
80104eca:	ff 75 f4             	pushl  -0xc(%ebp)
80104ecd:	e8 f9 38 00 00       	call   801087cb <switchuvm>
80104ed2:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80104ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ed8:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      #ifdef CS333_P2
      p->cpu_ticks_in = ticks;
80104edf:	8b 15 e0 65 11 80    	mov    0x801165e0,%edx
80104ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ee8:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
      #endif
      swtch(&cpu->scheduler, proc->context);
80104eee:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ef4:	8b 40 1c             	mov    0x1c(%eax),%eax
80104ef7:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104efe:	83 c2 04             	add    $0x4,%edx
80104f01:	83 ec 08             	sub    $0x8,%esp
80104f04:	50                   	push   %eax
80104f05:	52                   	push   %edx
80104f06:	e8 42 0d 00 00       	call   80105c4d <swtch>
80104f0b:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104f0e:	e8 9b 38 00 00       	call   801087ae <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80104f13:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104f1a:	00 00 00 00 
80104f1e:	eb 01                	jmp    80104f21 <scheduler+0xa0>
    idle = 1;  // assume idle unless we schedule a process
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;
80104f20:	90                   	nop
    sti();

    idle = 1;  // assume idle unless we schedule a process
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f21:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
80104f28:	81 7d f4 d4 5d 11 80 	cmpl   $0x80115dd4,-0xc(%ebp)
80104f2f:	0f 82 77 ff ff ff    	jb     80104eac <scheduler+0x2b>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80104f35:	83 ec 0c             	sub    $0xc,%esp
80104f38:	68 a0 39 11 80       	push   $0x801139a0
80104f3d:	e8 9b 08 00 00       	call   801057dd <release>
80104f42:	83 c4 10             	add    $0x10,%esp
    // if idle, wait for next interrupt
    if (idle) {
80104f45:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104f49:	0f 84 38 ff ff ff    	je     80104e87 <scheduler+0x6>
      sti();
80104f4f:	e8 df f7 ff ff       	call   80104733 <sti>
      hlt();
80104f54:	e8 c3 f7 ff ff       	call   8010471c <hlt>
    }
  }
80104f59:	e9 29 ff ff ff       	jmp    80104e87 <scheduler+0x6>

80104f5e <sched>:
// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
#ifndef CS333_P3P4
void
sched(void)
{
80104f5e:	55                   	push   %ebp
80104f5f:	89 e5                	mov    %esp,%ebp
80104f61:	53                   	push   %ebx
80104f62:	83 ec 14             	sub    $0x14,%esp
  int intena;

  if(!holding(&ptable.lock))
80104f65:	83 ec 0c             	sub    $0xc,%esp
80104f68:	68 a0 39 11 80       	push   $0x801139a0
80104f6d:	e8 37 09 00 00       	call   801058a9 <holding>
80104f72:	83 c4 10             	add    $0x10,%esp
80104f75:	85 c0                	test   %eax,%eax
80104f77:	75 0d                	jne    80104f86 <sched+0x28>
    panic("sched ptable.lock");
80104f79:	83 ec 0c             	sub    $0xc,%esp
80104f7c:	68 98 92 10 80       	push   $0x80109298
80104f81:	e8 e0 b5 ff ff       	call   80100566 <panic>
  if(cpu->ncli != 1)
80104f86:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104f8c:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104f92:	83 f8 01             	cmp    $0x1,%eax
80104f95:	74 0d                	je     80104fa4 <sched+0x46>
    panic("sched locks");
80104f97:	83 ec 0c             	sub    $0xc,%esp
80104f9a:	68 aa 92 10 80       	push   $0x801092aa
80104f9f:	e8 c2 b5 ff ff       	call   80100566 <panic>
  if(proc->state == RUNNING)
80104fa4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104faa:	8b 40 0c             	mov    0xc(%eax),%eax
80104fad:	83 f8 04             	cmp    $0x4,%eax
80104fb0:	75 0d                	jne    80104fbf <sched+0x61>
    panic("sched running");
80104fb2:	83 ec 0c             	sub    $0xc,%esp
80104fb5:	68 b6 92 10 80       	push   $0x801092b6
80104fba:	e8 a7 b5 ff ff       	call   80100566 <panic>
  if(readeflags()&FL_IF)
80104fbf:	e8 5f f7 ff ff       	call   80104723 <readeflags>
80104fc4:	25 00 02 00 00       	and    $0x200,%eax
80104fc9:	85 c0                	test   %eax,%eax
80104fcb:	74 0d                	je     80104fda <sched+0x7c>
    panic("sched interruptible");
80104fcd:	83 ec 0c             	sub    $0xc,%esp
80104fd0:	68 c4 92 10 80       	push   $0x801092c4
80104fd5:	e8 8c b5 ff ff       	call   80100566 <panic>
  intena = cpu->intena;
80104fda:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104fe0:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104fe6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  #ifdef CS333_P2
  proc->cpu_ticks_total += ticks-proc->cpu_ticks_in;
80104fe9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fef:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104ff6:	8b 8a 88 00 00 00    	mov    0x88(%edx),%ecx
80104ffc:	8b 1d e0 65 11 80    	mov    0x801165e0,%ebx
80105002:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105009:	8b 92 8c 00 00 00    	mov    0x8c(%edx),%edx
8010500f:	29 d3                	sub    %edx,%ebx
80105011:	89 da                	mov    %ebx,%edx
80105013:	01 ca                	add    %ecx,%edx
80105015:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
  #endif
  swtch(&proc->context, cpu->scheduler);
8010501b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105021:	8b 40 04             	mov    0x4(%eax),%eax
80105024:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010502b:	83 c2 1c             	add    $0x1c,%edx
8010502e:	83 ec 08             	sub    $0x8,%esp
80105031:	50                   	push   %eax
80105032:	52                   	push   %edx
80105033:	e8 15 0c 00 00       	call   80105c4d <swtch>
80105038:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
8010503b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105041:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105044:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
8010504a:	90                   	nop
8010504b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010504e:	c9                   	leave  
8010504f:	c3                   	ret    

80105050 <yield>:
#endif

// Give up the CPU for one scheduling round.
void
yield(void)
{
80105050:	55                   	push   %ebp
80105051:	89 e5                	mov    %esp,%ebp
80105053:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80105056:	83 ec 0c             	sub    $0xc,%esp
80105059:	68 a0 39 11 80       	push   $0x801139a0
8010505e:	e8 13 07 00 00       	call   80105776 <acquire>
80105063:	83 c4 10             	add    $0x10,%esp
  #ifdef CS333_P3P4
  switchToRunnable(&ptable.pLists.running, proc, RUNNING);
  #else
  proc->state = RUNNABLE;
80105066:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010506c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      setpriority(proc->pid, proc->priority + 1);
    }
    proc->budget = 50;
  }
  #endif
  sched();
80105073:	e8 e6 fe ff ff       	call   80104f5e <sched>
  release(&ptable.lock);
80105078:	83 ec 0c             	sub    $0xc,%esp
8010507b:	68 a0 39 11 80       	push   $0x801139a0
80105080:	e8 58 07 00 00       	call   801057dd <release>
80105085:	83 c4 10             	add    $0x10,%esp
}
80105088:	90                   	nop
80105089:	c9                   	leave  
8010508a:	c3                   	ret    

8010508b <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
8010508b:	55                   	push   %ebp
8010508c:	89 e5                	mov    %esp,%ebp
8010508e:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80105091:	83 ec 0c             	sub    $0xc,%esp
80105094:	68 a0 39 11 80       	push   $0x801139a0
80105099:	e8 3f 07 00 00       	call   801057dd <release>
8010509e:	83 c4 10             	add    $0x10,%esp

  if (first) {
801050a1:	a1 20 c0 10 80       	mov    0x8010c020,%eax
801050a6:	85 c0                	test   %eax,%eax
801050a8:	74 24                	je     801050ce <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
801050aa:	c7 05 20 c0 10 80 00 	movl   $0x0,0x8010c020
801050b1:	00 00 00 
    iinit(ROOTDEV);
801050b4:	83 ec 0c             	sub    $0xc,%esp
801050b7:	6a 01                	push   $0x1
801050b9:	e8 28 c6 ff ff       	call   801016e6 <iinit>
801050be:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
801050c1:	83 ec 0c             	sub    $0xc,%esp
801050c4:	6a 01                	push   $0x1
801050c6:	e8 42 e5 ff ff       	call   8010360d <initlog>
801050cb:	83 c4 10             	add    $0x10,%esp
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
801050ce:	90                   	nop
801050cf:	c9                   	leave  
801050d0:	c3                   	ret    

801050d1 <sleep>:
// Reacquires lock when awakened.
// 2016/12/28: ticklock removed from xv6. sleep() changed to
// accept a NULL lock to accommodate.
void
sleep(void *chan, struct spinlock *lk)
{
801050d1:	55                   	push   %ebp
801050d2:	89 e5                	mov    %esp,%ebp
801050d4:	83 ec 08             	sub    $0x8,%esp
  if(proc == 0)
801050d7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050dd:	85 c0                	test   %eax,%eax
801050df:	75 0d                	jne    801050ee <sleep+0x1d>
    panic("sleep");
801050e1:	83 ec 0c             	sub    $0xc,%esp
801050e4:	68 d8 92 10 80       	push   $0x801092d8
801050e9:	e8 78 b4 ff ff       	call   80100566 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){
801050ee:	81 7d 0c a0 39 11 80 	cmpl   $0x801139a0,0xc(%ebp)
801050f5:	74 24                	je     8010511b <sleep+0x4a>
    acquire(&ptable.lock);
801050f7:	83 ec 0c             	sub    $0xc,%esp
801050fa:	68 a0 39 11 80       	push   $0x801139a0
801050ff:	e8 72 06 00 00       	call   80105776 <acquire>
80105104:	83 c4 10             	add    $0x10,%esp
    if (lk) release(lk);
80105107:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010510b:	74 0e                	je     8010511b <sleep+0x4a>
8010510d:	83 ec 0c             	sub    $0xc,%esp
80105110:	ff 75 0c             	pushl  0xc(%ebp)
80105113:	e8 c5 06 00 00       	call   801057dd <release>
80105118:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
8010511b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105121:	8b 55 08             	mov    0x8(%ebp),%edx
80105124:	89 50 20             	mov    %edx,0x20(%eax)
  #ifdef CS333_P3P4
  switchStates(&ptable.pLists.running, &ptable.pLists.sleep, proc,
      RUNNING, SLEEPING);
  #else
  proc->state = SLEEPING;
80105127:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010512d:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
      setpriority(proc->pid, proc->priority + 1);
    }
    proc->budget = 50;
  }
  #endif
  sched();
80105134:	e8 25 fe ff ff       	call   80104f5e <sched>

  // Tidy up.
  proc->chan = 0;
80105139:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010513f:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){ 
80105146:	81 7d 0c a0 39 11 80 	cmpl   $0x801139a0,0xc(%ebp)
8010514d:	74 24                	je     80105173 <sleep+0xa2>
    release(&ptable.lock);
8010514f:	83 ec 0c             	sub    $0xc,%esp
80105152:	68 a0 39 11 80       	push   $0x801139a0
80105157:	e8 81 06 00 00       	call   801057dd <release>
8010515c:	83 c4 10             	add    $0x10,%esp
    if (lk) acquire(lk);
8010515f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105163:	74 0e                	je     80105173 <sleep+0xa2>
80105165:	83 ec 0c             	sub    $0xc,%esp
80105168:	ff 75 0c             	pushl  0xc(%ebp)
8010516b:	e8 06 06 00 00       	call   80105776 <acquire>
80105170:	83 c4 10             	add    $0x10,%esp
  }
}
80105173:	90                   	nop
80105174:	c9                   	leave  
80105175:	c3                   	ret    

80105176 <wakeup1>:
#ifndef CS333_P3P4
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80105176:	55                   	push   %ebp
80105177:	89 e5                	mov    %esp,%ebp
80105179:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010517c:	c7 45 fc d4 39 11 80 	movl   $0x801139d4,-0x4(%ebp)
80105183:	eb 27                	jmp    801051ac <wakeup1+0x36>
    if(p->state == SLEEPING && p->chan == chan)
80105185:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105188:	8b 40 0c             	mov    0xc(%eax),%eax
8010518b:	83 f8 02             	cmp    $0x2,%eax
8010518e:	75 15                	jne    801051a5 <wakeup1+0x2f>
80105190:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105193:	8b 40 20             	mov    0x20(%eax),%eax
80105196:	3b 45 08             	cmp    0x8(%ebp),%eax
80105199:	75 0a                	jne    801051a5 <wakeup1+0x2f>
      p->state = RUNNABLE;
8010519b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010519e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801051a5:	81 45 fc 90 00 00 00 	addl   $0x90,-0x4(%ebp)
801051ac:	81 7d fc d4 5d 11 80 	cmpl   $0x80115dd4,-0x4(%ebp)
801051b3:	72 d0                	jb     80105185 <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
801051b5:	90                   	nop
801051b6:	c9                   	leave  
801051b7:	c3                   	ret    

801051b8 <wakeup>:
#endif

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801051b8:	55                   	push   %ebp
801051b9:	89 e5                	mov    %esp,%ebp
801051bb:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
801051be:	83 ec 0c             	sub    $0xc,%esp
801051c1:	68 a0 39 11 80       	push   $0x801139a0
801051c6:	e8 ab 05 00 00       	call   80105776 <acquire>
801051cb:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
801051ce:	83 ec 0c             	sub    $0xc,%esp
801051d1:	ff 75 08             	pushl  0x8(%ebp)
801051d4:	e8 9d ff ff ff       	call   80105176 <wakeup1>
801051d9:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
801051dc:	83 ec 0c             	sub    $0xc,%esp
801051df:	68 a0 39 11 80       	push   $0x801139a0
801051e4:	e8 f4 05 00 00       	call   801057dd <release>
801051e9:	83 c4 10             	add    $0x10,%esp
}
801051ec:	90                   	nop
801051ed:	c9                   	leave  
801051ee:	c3                   	ret    

801051ef <kill>:
// Process won't exit until it returns
// to user space (see trap in trap.c).
#ifndef CS333_P3P4
int
kill(int pid)
{
801051ef:	55                   	push   %ebp
801051f0:	89 e5                	mov    %esp,%ebp
801051f2:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
801051f5:	83 ec 0c             	sub    $0xc,%esp
801051f8:	68 a0 39 11 80       	push   $0x801139a0
801051fd:	e8 74 05 00 00       	call   80105776 <acquire>
80105202:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105205:	c7 45 f4 d4 39 11 80 	movl   $0x801139d4,-0xc(%ebp)
8010520c:	eb 4a                	jmp    80105258 <kill+0x69>
    if(p->pid == pid){
8010520e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105211:	8b 50 10             	mov    0x10(%eax),%edx
80105214:	8b 45 08             	mov    0x8(%ebp),%eax
80105217:	39 c2                	cmp    %eax,%edx
80105219:	75 36                	jne    80105251 <kill+0x62>
      p->killed = 1;
8010521b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010521e:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80105225:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105228:	8b 40 0c             	mov    0xc(%eax),%eax
8010522b:	83 f8 02             	cmp    $0x2,%eax
8010522e:	75 0a                	jne    8010523a <kill+0x4b>
        p->state = RUNNABLE;
80105230:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105233:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
8010523a:	83 ec 0c             	sub    $0xc,%esp
8010523d:	68 a0 39 11 80       	push   $0x801139a0
80105242:	e8 96 05 00 00       	call   801057dd <release>
80105247:	83 c4 10             	add    $0x10,%esp
      return 0;
8010524a:	b8 00 00 00 00       	mov    $0x0,%eax
8010524f:	eb 25                	jmp    80105276 <kill+0x87>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105251:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
80105258:	81 7d f4 d4 5d 11 80 	cmpl   $0x80115dd4,-0xc(%ebp)
8010525f:	72 ad                	jb     8010520e <kill+0x1f>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80105261:	83 ec 0c             	sub    $0xc,%esp
80105264:	68 a0 39 11 80       	push   $0x801139a0
80105269:	e8 6f 05 00 00       	call   801057dd <release>
8010526e:	83 c4 10             	add    $0x10,%esp
  return -1;
80105271:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105276:	c9                   	leave  
80105277:	c3                   	ret    

80105278 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80105278:	55                   	push   %ebp
80105279:	89 e5                	mov    %esp,%ebp
8010527b:	53                   	push   %ebx
8010527c:	83 ec 44             	sub    $0x44,%esp
  uint pc[10];
 
  #ifdef CS333_P3P4
  cprintf("\nPID\tName\tUID\tGID\tPPID\tPrio\tElapsed\tCPU\tState\tSize\t PCs\n");
  #elif defined CS333_P2
  cprintf("\nPID\tName\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\t PCs\n");
8010527f:	83 ec 0c             	sub    $0xc,%esp
80105282:	68 08 93 10 80       	push   $0x80109308
80105287:	e8 3a b1 ff ff       	call   801003c6 <cprintf>
8010528c:	83 c4 10             	add    $0x10,%esp
  #elif defined CS333_P1
  cprintf("\nPID\tState\tName\tElapsed\t PCs\n");
  #endif
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010528f:	c7 45 f0 d4 39 11 80 	movl   $0x801139d4,-0x10(%ebp)
80105296:	e9 5a 01 00 00       	jmp    801053f5 <procdump+0x17d>
    if(p->state == UNUSED)
8010529b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010529e:	8b 40 0c             	mov    0xc(%eax),%eax
801052a1:	85 c0                	test   %eax,%eax
801052a3:	0f 84 44 01 00 00    	je     801053ed <procdump+0x175>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801052a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052ac:	8b 40 0c             	mov    0xc(%eax),%eax
801052af:	83 f8 05             	cmp    $0x5,%eax
801052b2:	77 23                	ja     801052d7 <procdump+0x5f>
801052b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052b7:	8b 40 0c             	mov    0xc(%eax),%eax
801052ba:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
801052c1:	85 c0                	test   %eax,%eax
801052c3:	74 12                	je     801052d7 <procdump+0x5f>
      state = states[p->state];
801052c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052c8:	8b 40 0c             	mov    0xc(%eax),%eax
801052cb:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
801052d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
801052d5:	eb 07                	jmp    801052de <procdump+0x66>
    else
      state = "???";
801052d7:	c7 45 ec 3c 93 10 80 	movl   $0x8010933c,-0x14(%ebp)
    calcelapsedtime(p->cpu_ticks_total);
    cprintf("%s\t%d\t", state, p->sz);
    #elif defined CS333_P2
    int ppid;

    if(!p->parent)
801052de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052e1:	8b 40 14             	mov    0x14(%eax),%eax
801052e4:	85 c0                	test   %eax,%eax
801052e6:	75 09                	jne    801052f1 <procdump+0x79>
      ppid = 1;
801052e8:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
801052ef:	eb 0c                	jmp    801052fd <procdump+0x85>
    else
      ppid = p->parent->pid;
801052f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052f4:	8b 40 14             	mov    0x14(%eax),%eax
801052f7:	8b 40 10             	mov    0x10(%eax),%eax
801052fa:	89 45 e8             	mov    %eax,-0x18(%ebp)

    cprintf("%d\t%s\t%d\t%d\t%d\t", p->pid, p->name, p->uid, p->gid, ppid);
801052fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105300:	8b 88 84 00 00 00    	mov    0x84(%eax),%ecx
80105306:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105309:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
8010530f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105312:	8d 58 6c             	lea    0x6c(%eax),%ebx
80105315:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105318:	8b 40 10             	mov    0x10(%eax),%eax
8010531b:	83 ec 08             	sub    $0x8,%esp
8010531e:	ff 75 e8             	pushl  -0x18(%ebp)
80105321:	51                   	push   %ecx
80105322:	52                   	push   %edx
80105323:	53                   	push   %ebx
80105324:	50                   	push   %eax
80105325:	68 40 93 10 80       	push   $0x80109340
8010532a:	e8 97 b0 ff ff       	call   801003c6 <cprintf>
8010532f:	83 c4 20             	add    $0x20,%esp
    calcelapsedtime(ticks-p->start_ticks);
80105332:	8b 15 e0 65 11 80    	mov    0x801165e0,%edx
80105338:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010533b:	8b 40 7c             	mov    0x7c(%eax),%eax
8010533e:	29 c2                	sub    %eax,%edx
80105340:	89 d0                	mov    %edx,%eax
80105342:	83 ec 0c             	sub    $0xc,%esp
80105345:	50                   	push   %eax
80105346:	e8 bd 00 00 00       	call   80105408 <calcelapsedtime>
8010534b:	83 c4 10             	add    $0x10,%esp
    calcelapsedtime(p->cpu_ticks_total);
8010534e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105351:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80105357:	83 ec 0c             	sub    $0xc,%esp
8010535a:	50                   	push   %eax
8010535b:	e8 a8 00 00 00       	call   80105408 <calcelapsedtime>
80105360:	83 c4 10             	add    $0x10,%esp
    cprintf("%s\t%d\t", state, p->sz);
80105363:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105366:	8b 00                	mov    (%eax),%eax
80105368:	83 ec 04             	sub    $0x4,%esp
8010536b:	50                   	push   %eax
8010536c:	ff 75 ec             	pushl  -0x14(%ebp)
8010536f:	68 50 93 10 80       	push   $0x80109350
80105374:	e8 4d b0 ff ff       	call   801003c6 <cprintf>
80105379:	83 c4 10             	add    $0x10,%esp
    cprintf("%d\t%s\t%s\t", p->pid, state, p->name);
    calcelapsedtime(ticks-p->start_ticks);
    #else
    cprintf("%d %s %s", p->pid, state, p->name);
    #endif
    if(p->state == SLEEPING){
8010537c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010537f:	8b 40 0c             	mov    0xc(%eax),%eax
80105382:	83 f8 02             	cmp    $0x2,%eax
80105385:	75 54                	jne    801053db <procdump+0x163>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80105387:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010538a:	8b 40 1c             	mov    0x1c(%eax),%eax
8010538d:	8b 40 0c             	mov    0xc(%eax),%eax
80105390:	83 c0 08             	add    $0x8,%eax
80105393:	89 c2                	mov    %eax,%edx
80105395:	83 ec 08             	sub    $0x8,%esp
80105398:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010539b:	50                   	push   %eax
8010539c:	52                   	push   %edx
8010539d:	e8 8d 04 00 00       	call   8010582f <getcallerpcs>
801053a2:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801053a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801053ac:	eb 1c                	jmp    801053ca <procdump+0x152>
        cprintf(" %p", pc[i]);
801053ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053b1:	8b 44 85 c0          	mov    -0x40(%ebp,%eax,4),%eax
801053b5:	83 ec 08             	sub    $0x8,%esp
801053b8:	50                   	push   %eax
801053b9:	68 57 93 10 80       	push   $0x80109357
801053be:	e8 03 b0 ff ff       	call   801003c6 <cprintf>
801053c3:	83 c4 10             	add    $0x10,%esp
    #else
    cprintf("%d %s %s", p->pid, state, p->name);
    #endif
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
801053c6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801053ca:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801053ce:	7f 0b                	jg     801053db <procdump+0x163>
801053d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053d3:	8b 44 85 c0          	mov    -0x40(%ebp,%eax,4),%eax
801053d7:	85 c0                	test   %eax,%eax
801053d9:	75 d3                	jne    801053ae <procdump+0x136>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801053db:	83 ec 0c             	sub    $0xc,%esp
801053de:	68 5b 93 10 80       	push   $0x8010935b
801053e3:	e8 de af ff ff       	call   801003c6 <cprintf>
801053e8:	83 c4 10             	add    $0x10,%esp
801053eb:	eb 01                	jmp    801053ee <procdump+0x176>
  #elif defined CS333_P1
  cprintf("\nPID\tState\tName\tElapsed\t PCs\n");
  #endif
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
801053ed:	90                   	nop
  #elif defined CS333_P2
  cprintf("\nPID\tName\tUID\tGID\tPPID\tElapsed\tCPU\tState\tSize\t PCs\n");
  #elif defined CS333_P1
  cprintf("\nPID\tState\tName\tElapsed\t PCs\n");
  #endif
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801053ee:	81 45 f0 90 00 00 00 	addl   $0x90,-0x10(%ebp)
801053f5:	81 7d f0 d4 5d 11 80 	cmpl   $0x80115dd4,-0x10(%ebp)
801053fc:	0f 82 99 fe ff ff    	jb     8010529b <procdump+0x23>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80105402:	90                   	nop
80105403:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105406:	c9                   	leave  
80105407:	c3                   	ret    

80105408 <calcelapsedtime>:
// Determines the seconds elapsed for a running process to the thousandth of a
// second and prints the result
#ifdef CS333_P1
void
calcelapsedtime(int ticks_in)
{
80105408:	55                   	push   %ebp
80105409:	89 e5                	mov    %esp,%ebp
8010540b:	83 ec 18             	sub    $0x18,%esp
  int seconds = (ticks_in)/1000;
8010540e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105411:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
80105416:	89 c8                	mov    %ecx,%eax
80105418:	f7 ea                	imul   %edx
8010541a:	c1 fa 06             	sar    $0x6,%edx
8010541d:	89 c8                	mov    %ecx,%eax
8010541f:	c1 f8 1f             	sar    $0x1f,%eax
80105422:	29 c2                	sub    %eax,%edx
80105424:	89 d0                	mov    %edx,%eax
80105426:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int milliseconds = (ticks_in)%1000;
80105429:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010542c:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
80105431:	89 c8                	mov    %ecx,%eax
80105433:	f7 ea                	imul   %edx
80105435:	c1 fa 06             	sar    $0x6,%edx
80105438:	89 c8                	mov    %ecx,%eax
8010543a:	c1 f8 1f             	sar    $0x1f,%eax
8010543d:	29 c2                	sub    %eax,%edx
8010543f:	89 d0                	mov    %edx,%eax
80105441:	69 c0 e8 03 00 00    	imul   $0x3e8,%eax,%eax
80105447:	29 c1                	sub    %eax,%ecx
80105449:	89 c8                	mov    %ecx,%eax
8010544b:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(milliseconds < 10)
8010544e:	83 7d f0 09          	cmpl   $0x9,-0x10(%ebp)
80105452:	7f 18                	jg     8010546c <calcelapsedtime+0x64>
    cprintf("%d.00%d\t", seconds, milliseconds);
80105454:	83 ec 04             	sub    $0x4,%esp
80105457:	ff 75 f0             	pushl  -0x10(%ebp)
8010545a:	ff 75 f4             	pushl  -0xc(%ebp)
8010545d:	68 5d 93 10 80       	push   $0x8010935d
80105462:	e8 5f af ff ff       	call   801003c6 <cprintf>
80105467:	83 c4 10             	add    $0x10,%esp
  else if(milliseconds < 100)
    cprintf("%d.0%d\t", seconds, milliseconds);
  else
    cprintf("%d.%d\t", seconds, milliseconds);
}
8010546a:	eb 34                	jmp    801054a0 <calcelapsedtime+0x98>
  int seconds = (ticks_in)/1000;
  int milliseconds = (ticks_in)%1000;

  if(milliseconds < 10)
    cprintf("%d.00%d\t", seconds, milliseconds);
  else if(milliseconds < 100)
8010546c:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
80105470:	7f 18                	jg     8010548a <calcelapsedtime+0x82>
    cprintf("%d.0%d\t", seconds, milliseconds);
80105472:	83 ec 04             	sub    $0x4,%esp
80105475:	ff 75 f0             	pushl  -0x10(%ebp)
80105478:	ff 75 f4             	pushl  -0xc(%ebp)
8010547b:	68 66 93 10 80       	push   $0x80109366
80105480:	e8 41 af ff ff       	call   801003c6 <cprintf>
80105485:	83 c4 10             	add    $0x10,%esp
  else
    cprintf("%d.%d\t", seconds, milliseconds);
}
80105488:	eb 16                	jmp    801054a0 <calcelapsedtime+0x98>
  if(milliseconds < 10)
    cprintf("%d.00%d\t", seconds, milliseconds);
  else if(milliseconds < 100)
    cprintf("%d.0%d\t", seconds, milliseconds);
  else
    cprintf("%d.%d\t", seconds, milliseconds);
8010548a:	83 ec 04             	sub    $0x4,%esp
8010548d:	ff 75 f0             	pushl  -0x10(%ebp)
80105490:	ff 75 f4             	pushl  -0xc(%ebp)
80105493:	68 6e 93 10 80       	push   $0x8010936e
80105498:	e8 29 af ff ff       	call   801003c6 <cprintf>
8010549d:	83 c4 10             	add    $0x10,%esp
}
801054a0:	90                   	nop
801054a1:	c9                   	leave  
801054a2:	c3                   	ret    

801054a3 <getprocs>:

// Copies active processes in the ptable to the uproc table passed in
#ifdef CS333_P2
int
getprocs(uint max, struct uproc* table)
{
801054a3:	55                   	push   %ebp
801054a4:	89 e5                	mov    %esp,%ebp
801054a6:	53                   	push   %ebx
801054a7:	83 ec 14             	sub    $0x14,%esp
  int uproc_table_index = 0;
801054aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  for(int i = 0; i < NPROC; i++){
801054b1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801054b8:	e9 4d 02 00 00       	jmp    8010570a <getprocs+0x267>
    if(ptable.proc[i].state == SLEEPING || ptable.proc[i].state == RUNNING ||
801054bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
801054c0:	89 d0                	mov    %edx,%eax
801054c2:	c1 e0 03             	shl    $0x3,%eax
801054c5:	01 d0                	add    %edx,%eax
801054c7:	c1 e0 04             	shl    $0x4,%eax
801054ca:	05 e0 39 11 80       	add    $0x801139e0,%eax
801054cf:	8b 00                	mov    (%eax),%eax
801054d1:	83 f8 02             	cmp    $0x2,%eax
801054d4:	74 36                	je     8010550c <getprocs+0x69>
801054d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
801054d9:	89 d0                	mov    %edx,%eax
801054db:	c1 e0 03             	shl    $0x3,%eax
801054de:	01 d0                	add    %edx,%eax
801054e0:	c1 e0 04             	shl    $0x4,%eax
801054e3:	05 e0 39 11 80       	add    $0x801139e0,%eax
801054e8:	8b 00                	mov    (%eax),%eax
801054ea:	83 f8 04             	cmp    $0x4,%eax
801054ed:	74 1d                	je     8010550c <getprocs+0x69>
        ptable.proc[i].state == RUNNABLE){
801054ef:	8b 55 f0             	mov    -0x10(%ebp),%edx
801054f2:	89 d0                	mov    %edx,%eax
801054f4:	c1 e0 03             	shl    $0x3,%eax
801054f7:	01 d0                	add    %edx,%eax
801054f9:	c1 e0 04             	shl    $0x4,%eax
801054fc:	05 e0 39 11 80       	add    $0x801139e0,%eax
80105501:	8b 00                	mov    (%eax),%eax
getprocs(uint max, struct uproc* table)
{
  int uproc_table_index = 0;

  for(int i = 0; i < NPROC; i++){
    if(ptable.proc[i].state == SLEEPING || ptable.proc[i].state == RUNNING ||
80105503:	83 f8 03             	cmp    $0x3,%eax
80105506:	0f 85 fa 01 00 00    	jne    80105706 <getprocs+0x263>
        ptable.proc[i].state == RUNNABLE){
      if(uproc_table_index < max){
8010550c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010550f:	3b 45 08             	cmp    0x8(%ebp),%eax
80105512:	0f 83 ee 01 00 00    	jae    80105706 <getprocs+0x263>
        table[uproc_table_index].pid = ptable.proc[i].pid;
80105518:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010551b:	89 d0                	mov    %edx,%eax
8010551d:	01 c0                	add    %eax,%eax
8010551f:	01 d0                	add    %edx,%eax
80105521:	c1 e0 05             	shl    $0x5,%eax
80105524:	89 c2                	mov    %eax,%edx
80105526:	8b 45 0c             	mov    0xc(%ebp),%eax
80105529:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
8010552c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010552f:	89 d0                	mov    %edx,%eax
80105531:	c1 e0 03             	shl    $0x3,%eax
80105534:	01 d0                	add    %edx,%eax
80105536:	c1 e0 04             	shl    $0x4,%eax
80105539:	05 e4 39 11 80       	add    $0x801139e4,%eax
8010553e:	8b 00                	mov    (%eax),%eax
80105540:	89 01                	mov    %eax,(%ecx)
        table[uproc_table_index].uid = ptable.proc[i].uid;
80105542:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105545:	89 d0                	mov    %edx,%eax
80105547:	01 c0                	add    %eax,%eax
80105549:	01 d0                	add    %edx,%eax
8010554b:	c1 e0 05             	shl    $0x5,%eax
8010554e:	89 c2                	mov    %eax,%edx
80105550:	8b 45 0c             	mov    0xc(%ebp),%eax
80105553:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80105556:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105559:	89 d0                	mov    %edx,%eax
8010555b:	c1 e0 03             	shl    $0x3,%eax
8010555e:	01 d0                	add    %edx,%eax
80105560:	c1 e0 04             	shl    $0x4,%eax
80105563:	05 54 3a 11 80       	add    $0x80113a54,%eax
80105568:	8b 00                	mov    (%eax),%eax
8010556a:	89 41 04             	mov    %eax,0x4(%ecx)
        table[uproc_table_index].gid = ptable.proc[i].gid;
8010556d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105570:	89 d0                	mov    %edx,%eax
80105572:	01 c0                	add    %eax,%eax
80105574:	01 d0                	add    %edx,%eax
80105576:	c1 e0 05             	shl    $0x5,%eax
80105579:	89 c2                	mov    %eax,%edx
8010557b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010557e:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80105581:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105584:	89 d0                	mov    %edx,%eax
80105586:	c1 e0 03             	shl    $0x3,%eax
80105589:	01 d0                	add    %edx,%eax
8010558b:	c1 e0 04             	shl    $0x4,%eax
8010558e:	05 58 3a 11 80       	add    $0x80113a58,%eax
80105593:	8b 00                	mov    (%eax),%eax
80105595:	89 41 08             	mov    %eax,0x8(%ecx)
        table[uproc_table_index].elapsed_ticks =
80105598:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010559b:	89 d0                	mov    %edx,%eax
8010559d:	01 c0                	add    %eax,%eax
8010559f:	01 d0                	add    %edx,%eax
801055a1:	c1 e0 05             	shl    $0x5,%eax
801055a4:	89 c2                	mov    %eax,%edx
801055a6:	8b 45 0c             	mov    0xc(%ebp),%eax
801055a9:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
            ticks-ptable.proc[i].start_ticks;
801055ac:	8b 1d e0 65 11 80    	mov    0x801165e0,%ebx
801055b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
801055b5:	89 d0                	mov    %edx,%eax
801055b7:	c1 e0 03             	shl    $0x3,%eax
801055ba:	01 d0                	add    %edx,%eax
801055bc:	c1 e0 04             	shl    $0x4,%eax
801055bf:	05 50 3a 11 80       	add    $0x80113a50,%eax
801055c4:	8b 00                	mov    (%eax),%eax
801055c6:	29 c3                	sub    %eax,%ebx
801055c8:	89 d8                	mov    %ebx,%eax
        ptable.proc[i].state == RUNNABLE){
      if(uproc_table_index < max){
        table[uproc_table_index].pid = ptable.proc[i].pid;
        table[uproc_table_index].uid = ptable.proc[i].uid;
        table[uproc_table_index].gid = ptable.proc[i].gid;
        table[uproc_table_index].elapsed_ticks =
801055ca:	89 41 10             	mov    %eax,0x10(%ecx)
            ticks-ptable.proc[i].start_ticks;
        table[uproc_table_index].CPU_total_ticks =
801055cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801055d0:	89 d0                	mov    %edx,%eax
801055d2:	01 c0                	add    %eax,%eax
801055d4:	01 d0                	add    %edx,%eax
801055d6:	c1 e0 05             	shl    $0x5,%eax
801055d9:	89 c2                	mov    %eax,%edx
801055db:	8b 45 0c             	mov    0xc(%ebp),%eax
801055de:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
            ptable.proc[i].cpu_ticks_total;
801055e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
801055e4:	89 d0                	mov    %edx,%eax
801055e6:	c1 e0 03             	shl    $0x3,%eax
801055e9:	01 d0                	add    %edx,%eax
801055eb:	c1 e0 04             	shl    $0x4,%eax
801055ee:	05 5c 3a 11 80       	add    $0x80113a5c,%eax
801055f3:	8b 00                	mov    (%eax),%eax
        table[uproc_table_index].pid = ptable.proc[i].pid;
        table[uproc_table_index].uid = ptable.proc[i].uid;
        table[uproc_table_index].gid = ptable.proc[i].gid;
        table[uproc_table_index].elapsed_ticks =
            ticks-ptable.proc[i].start_ticks;
        table[uproc_table_index].CPU_total_ticks =
801055f5:	89 41 14             	mov    %eax,0x14(%ecx)
            ptable.proc[i].cpu_ticks_total;
        safestrcpy(table[uproc_table_index].state,
            states[ptable.proc[i].state], STRMAX);
801055f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
801055fb:	89 d0                	mov    %edx,%eax
801055fd:	c1 e0 03             	shl    $0x3,%eax
80105600:	01 d0                	add    %edx,%eax
80105602:	c1 e0 04             	shl    $0x4,%eax
80105605:	05 e0 39 11 80       	add    $0x801139e0,%eax
8010560a:	8b 00                	mov    (%eax),%eax
8010560c:	8b 0c 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%ecx
        table[uproc_table_index].gid = ptable.proc[i].gid;
        table[uproc_table_index].elapsed_ticks =
            ticks-ptable.proc[i].start_ticks;
        table[uproc_table_index].CPU_total_ticks =
            ptable.proc[i].cpu_ticks_total;
        safestrcpy(table[uproc_table_index].state,
80105613:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105616:	89 d0                	mov    %edx,%eax
80105618:	01 c0                	add    %eax,%eax
8010561a:	01 d0                	add    %edx,%eax
8010561c:	c1 e0 05             	shl    $0x5,%eax
8010561f:	89 c2                	mov    %eax,%edx
80105621:	8b 45 0c             	mov    0xc(%ebp),%eax
80105624:	01 d0                	add    %edx,%eax
80105626:	83 c0 18             	add    $0x18,%eax
80105629:	83 ec 04             	sub    $0x4,%esp
8010562c:	6a 20                	push   $0x20
8010562e:	51                   	push   %ecx
8010562f:	50                   	push   %eax
80105630:	e8 a7 05 00 00       	call   80105bdc <safestrcpy>
80105635:	83 c4 10             	add    $0x10,%esp
            states[ptable.proc[i].state], STRMAX);
        table[uproc_table_index].size = ptable.proc[i].sz;
80105638:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010563b:	89 d0                	mov    %edx,%eax
8010563d:	01 c0                	add    %eax,%eax
8010563f:	01 d0                	add    %edx,%eax
80105641:	c1 e0 05             	shl    $0x5,%eax
80105644:	89 c2                	mov    %eax,%edx
80105646:	8b 45 0c             	mov    0xc(%ebp),%eax
80105649:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
8010564c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010564f:	89 d0                	mov    %edx,%eax
80105651:	c1 e0 03             	shl    $0x3,%eax
80105654:	01 d0                	add    %edx,%eax
80105656:	c1 e0 04             	shl    $0x4,%eax
80105659:	05 d4 39 11 80       	add    $0x801139d4,%eax
8010565e:	8b 00                	mov    (%eax),%eax
80105660:	89 41 38             	mov    %eax,0x38(%ecx)
        safestrcpy(table[uproc_table_index].name, ptable.proc[i].name, STRMAX);
80105663:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105666:	8d 50 01             	lea    0x1(%eax),%edx
80105669:	89 d0                	mov    %edx,%eax
8010566b:	c1 e0 03             	shl    $0x3,%eax
8010566e:	01 d0                	add    %edx,%eax
80105670:	c1 e0 04             	shl    $0x4,%eax
80105673:	05 a0 39 11 80       	add    $0x801139a0,%eax
80105678:	8d 48 10             	lea    0x10(%eax),%ecx
8010567b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010567e:	89 d0                	mov    %edx,%eax
80105680:	01 c0                	add    %eax,%eax
80105682:	01 d0                	add    %edx,%eax
80105684:	c1 e0 05             	shl    $0x5,%eax
80105687:	89 c2                	mov    %eax,%edx
80105689:	8b 45 0c             	mov    0xc(%ebp),%eax
8010568c:	01 d0                	add    %edx,%eax
8010568e:	83 c0 3c             	add    $0x3c,%eax
80105691:	83 ec 04             	sub    $0x4,%esp
80105694:	6a 20                	push   $0x20
80105696:	51                   	push   %ecx
80105697:	50                   	push   %eax
80105698:	e8 3f 05 00 00       	call   80105bdc <safestrcpy>
8010569d:	83 c4 10             	add    $0x10,%esp

        if(!ptable.proc[i].parent)
801056a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801056a3:	89 d0                	mov    %edx,%eax
801056a5:	c1 e0 03             	shl    $0x3,%eax
801056a8:	01 d0                	add    %edx,%eax
801056aa:	c1 e0 04             	shl    $0x4,%eax
801056ad:	05 e8 39 11 80       	add    $0x801139e8,%eax
801056b2:	8b 00                	mov    (%eax),%eax
801056b4:	85 c0                	test   %eax,%eax
801056b6:	75 1c                	jne    801056d4 <getprocs+0x231>
          table[uproc_table_index].ppid = 1;
801056b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801056bb:	89 d0                	mov    %edx,%eax
801056bd:	01 c0                	add    %eax,%eax
801056bf:	01 d0                	add    %edx,%eax
801056c1:	c1 e0 05             	shl    $0x5,%eax
801056c4:	89 c2                	mov    %eax,%edx
801056c6:	8b 45 0c             	mov    0xc(%ebp),%eax
801056c9:	01 d0                	add    %edx,%eax
801056cb:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
801056d2:	eb 2e                	jmp    80105702 <getprocs+0x25f>
        else
          table[uproc_table_index].ppid = ptable.proc[i].parent->pid;
801056d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801056d7:	89 d0                	mov    %edx,%eax
801056d9:	01 c0                	add    %eax,%eax
801056db:	01 d0                	add    %edx,%eax
801056dd:	c1 e0 05             	shl    $0x5,%eax
801056e0:	89 c2                	mov    %eax,%edx
801056e2:	8b 45 0c             	mov    0xc(%ebp),%eax
801056e5:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
801056e8:	8b 55 f0             	mov    -0x10(%ebp),%edx
801056eb:	89 d0                	mov    %edx,%eax
801056ed:	c1 e0 03             	shl    $0x3,%eax
801056f0:	01 d0                	add    %edx,%eax
801056f2:	c1 e0 04             	shl    $0x4,%eax
801056f5:	05 e8 39 11 80       	add    $0x801139e8,%eax
801056fa:	8b 00                	mov    (%eax),%eax
801056fc:	8b 40 10             	mov    0x10(%eax),%eax
801056ff:	89 41 0c             	mov    %eax,0xc(%ecx)
        uproc_table_index++;
80105702:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
int
getprocs(uint max, struct uproc* table)
{
  int uproc_table_index = 0;

  for(int i = 0; i < NPROC; i++){
80105706:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010570a:	83 7d f0 3f          	cmpl   $0x3f,-0x10(%ebp)
8010570e:	0f 8e a9 fd ff ff    	jle    801054bd <getprocs+0x1a>
          table[uproc_table_index].ppid = ptable.proc[i].parent->pid;
        uproc_table_index++;
      }
    }
  }
  return uproc_table_index;
80105714:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105717:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010571a:	c9                   	leave  
8010571b:	c3                   	ret    

8010571c <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
8010571c:	55                   	push   %ebp
8010571d:	89 e5                	mov    %esp,%ebp
8010571f:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105722:	9c                   	pushf  
80105723:	58                   	pop    %eax
80105724:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80105727:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010572a:	c9                   	leave  
8010572b:	c3                   	ret    

8010572c <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
8010572c:	55                   	push   %ebp
8010572d:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
8010572f:	fa                   	cli    
}
80105730:	90                   	nop
80105731:	5d                   	pop    %ebp
80105732:	c3                   	ret    

80105733 <sti>:

static inline void
sti(void)
{
80105733:	55                   	push   %ebp
80105734:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80105736:	fb                   	sti    
}
80105737:	90                   	nop
80105738:	5d                   	pop    %ebp
80105739:	c3                   	ret    

8010573a <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
8010573a:	55                   	push   %ebp
8010573b:	89 e5                	mov    %esp,%ebp
8010573d:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80105740:	8b 55 08             	mov    0x8(%ebp),%edx
80105743:	8b 45 0c             	mov    0xc(%ebp),%eax
80105746:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105749:	f0 87 02             	lock xchg %eax,(%edx)
8010574c:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
8010574f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105752:	c9                   	leave  
80105753:	c3                   	ret    

80105754 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105754:	55                   	push   %ebp
80105755:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80105757:	8b 45 08             	mov    0x8(%ebp),%eax
8010575a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010575d:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80105760:	8b 45 08             	mov    0x8(%ebp),%eax
80105763:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80105769:	8b 45 08             	mov    0x8(%ebp),%eax
8010576c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105773:	90                   	nop
80105774:	5d                   	pop    %ebp
80105775:	c3                   	ret    

80105776 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80105776:	55                   	push   %ebp
80105777:	89 e5                	mov    %esp,%ebp
80105779:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
8010577c:	e8 52 01 00 00       	call   801058d3 <pushcli>
  if(holding(lk))
80105781:	8b 45 08             	mov    0x8(%ebp),%eax
80105784:	83 ec 0c             	sub    $0xc,%esp
80105787:	50                   	push   %eax
80105788:	e8 1c 01 00 00       	call   801058a9 <holding>
8010578d:	83 c4 10             	add    $0x10,%esp
80105790:	85 c0                	test   %eax,%eax
80105792:	74 0d                	je     801057a1 <acquire+0x2b>
    panic("acquire");
80105794:	83 ec 0c             	sub    $0xc,%esp
80105797:	68 75 93 10 80       	push   $0x80109375
8010579c:	e8 c5 ad ff ff       	call   80100566 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
801057a1:	90                   	nop
801057a2:	8b 45 08             	mov    0x8(%ebp),%eax
801057a5:	83 ec 08             	sub    $0x8,%esp
801057a8:	6a 01                	push   $0x1
801057aa:	50                   	push   %eax
801057ab:	e8 8a ff ff ff       	call   8010573a <xchg>
801057b0:	83 c4 10             	add    $0x10,%esp
801057b3:	85 c0                	test   %eax,%eax
801057b5:	75 eb                	jne    801057a2 <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
801057b7:	8b 45 08             	mov    0x8(%ebp),%eax
801057ba:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801057c1:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
801057c4:	8b 45 08             	mov    0x8(%ebp),%eax
801057c7:	83 c0 0c             	add    $0xc,%eax
801057ca:	83 ec 08             	sub    $0x8,%esp
801057cd:	50                   	push   %eax
801057ce:	8d 45 08             	lea    0x8(%ebp),%eax
801057d1:	50                   	push   %eax
801057d2:	e8 58 00 00 00       	call   8010582f <getcallerpcs>
801057d7:	83 c4 10             	add    $0x10,%esp
}
801057da:	90                   	nop
801057db:	c9                   	leave  
801057dc:	c3                   	ret    

801057dd <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
801057dd:	55                   	push   %ebp
801057de:	89 e5                	mov    %esp,%ebp
801057e0:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
801057e3:	83 ec 0c             	sub    $0xc,%esp
801057e6:	ff 75 08             	pushl  0x8(%ebp)
801057e9:	e8 bb 00 00 00       	call   801058a9 <holding>
801057ee:	83 c4 10             	add    $0x10,%esp
801057f1:	85 c0                	test   %eax,%eax
801057f3:	75 0d                	jne    80105802 <release+0x25>
    panic("release");
801057f5:	83 ec 0c             	sub    $0xc,%esp
801057f8:	68 7d 93 10 80       	push   $0x8010937d
801057fd:	e8 64 ad ff ff       	call   80100566 <panic>

  lk->pcs[0] = 0;
80105802:	8b 45 08             	mov    0x8(%ebp),%eax
80105805:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
8010580c:	8b 45 08             	mov    0x8(%ebp),%eax
8010580f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80105816:	8b 45 08             	mov    0x8(%ebp),%eax
80105819:	83 ec 08             	sub    $0x8,%esp
8010581c:	6a 00                	push   $0x0
8010581e:	50                   	push   %eax
8010581f:	e8 16 ff ff ff       	call   8010573a <xchg>
80105824:	83 c4 10             	add    $0x10,%esp

  popcli();
80105827:	e8 ec 00 00 00       	call   80105918 <popcli>
}
8010582c:	90                   	nop
8010582d:	c9                   	leave  
8010582e:	c3                   	ret    

8010582f <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
8010582f:	55                   	push   %ebp
80105830:	89 e5                	mov    %esp,%ebp
80105832:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80105835:	8b 45 08             	mov    0x8(%ebp),%eax
80105838:	83 e8 08             	sub    $0x8,%eax
8010583b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
8010583e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105845:	eb 38                	jmp    8010587f <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105847:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
8010584b:	74 53                	je     801058a0 <getcallerpcs+0x71>
8010584d:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80105854:	76 4a                	jbe    801058a0 <getcallerpcs+0x71>
80105856:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
8010585a:	74 44                	je     801058a0 <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010585c:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010585f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105866:	8b 45 0c             	mov    0xc(%ebp),%eax
80105869:	01 c2                	add    %eax,%edx
8010586b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010586e:	8b 40 04             	mov    0x4(%eax),%eax
80105871:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80105873:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105876:	8b 00                	mov    (%eax),%eax
80105878:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
8010587b:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010587f:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105883:	7e c2                	jle    80105847 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105885:	eb 19                	jmp    801058a0 <getcallerpcs+0x71>
    pcs[i] = 0;
80105887:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010588a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105891:	8b 45 0c             	mov    0xc(%ebp),%eax
80105894:	01 d0                	add    %edx,%eax
80105896:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010589c:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801058a0:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801058a4:	7e e1                	jle    80105887 <getcallerpcs+0x58>
    pcs[i] = 0;
}
801058a6:	90                   	nop
801058a7:	c9                   	leave  
801058a8:	c3                   	ret    

801058a9 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801058a9:	55                   	push   %ebp
801058aa:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
801058ac:	8b 45 08             	mov    0x8(%ebp),%eax
801058af:	8b 00                	mov    (%eax),%eax
801058b1:	85 c0                	test   %eax,%eax
801058b3:	74 17                	je     801058cc <holding+0x23>
801058b5:	8b 45 08             	mov    0x8(%ebp),%eax
801058b8:	8b 50 08             	mov    0x8(%eax),%edx
801058bb:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801058c1:	39 c2                	cmp    %eax,%edx
801058c3:	75 07                	jne    801058cc <holding+0x23>
801058c5:	b8 01 00 00 00       	mov    $0x1,%eax
801058ca:	eb 05                	jmp    801058d1 <holding+0x28>
801058cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
801058d1:	5d                   	pop    %ebp
801058d2:	c3                   	ret    

801058d3 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801058d3:	55                   	push   %ebp
801058d4:	89 e5                	mov    %esp,%ebp
801058d6:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
801058d9:	e8 3e fe ff ff       	call   8010571c <readeflags>
801058de:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
801058e1:	e8 46 fe ff ff       	call   8010572c <cli>
  if(cpu->ncli++ == 0)
801058e6:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801058ed:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
801058f3:	8d 48 01             	lea    0x1(%eax),%ecx
801058f6:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
801058fc:	85 c0                	test   %eax,%eax
801058fe:	75 15                	jne    80105915 <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
80105900:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105906:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105909:	81 e2 00 02 00 00    	and    $0x200,%edx
8010590f:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80105915:	90                   	nop
80105916:	c9                   	leave  
80105917:	c3                   	ret    

80105918 <popcli>:

void
popcli(void)
{
80105918:	55                   	push   %ebp
80105919:	89 e5                	mov    %esp,%ebp
8010591b:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
8010591e:	e8 f9 fd ff ff       	call   8010571c <readeflags>
80105923:	25 00 02 00 00       	and    $0x200,%eax
80105928:	85 c0                	test   %eax,%eax
8010592a:	74 0d                	je     80105939 <popcli+0x21>
    panic("popcli - interruptible");
8010592c:	83 ec 0c             	sub    $0xc,%esp
8010592f:	68 85 93 10 80       	push   $0x80109385
80105934:	e8 2d ac ff ff       	call   80100566 <panic>
  if(--cpu->ncli < 0)
80105939:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010593f:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105945:	83 ea 01             	sub    $0x1,%edx
80105948:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
8010594e:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105954:	85 c0                	test   %eax,%eax
80105956:	79 0d                	jns    80105965 <popcli+0x4d>
    panic("popcli");
80105958:	83 ec 0c             	sub    $0xc,%esp
8010595b:	68 9c 93 10 80       	push   $0x8010939c
80105960:	e8 01 ac ff ff       	call   80100566 <panic>
  if(cpu->ncli == 0 && cpu->intena)
80105965:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010596b:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105971:	85 c0                	test   %eax,%eax
80105973:	75 15                	jne    8010598a <popcli+0x72>
80105975:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010597b:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80105981:	85 c0                	test   %eax,%eax
80105983:	74 05                	je     8010598a <popcli+0x72>
    sti();
80105985:	e8 a9 fd ff ff       	call   80105733 <sti>
}
8010598a:	90                   	nop
8010598b:	c9                   	leave  
8010598c:	c3                   	ret    

8010598d <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
8010598d:	55                   	push   %ebp
8010598e:	89 e5                	mov    %esp,%ebp
80105990:	57                   	push   %edi
80105991:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80105992:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105995:	8b 55 10             	mov    0x10(%ebp),%edx
80105998:	8b 45 0c             	mov    0xc(%ebp),%eax
8010599b:	89 cb                	mov    %ecx,%ebx
8010599d:	89 df                	mov    %ebx,%edi
8010599f:	89 d1                	mov    %edx,%ecx
801059a1:	fc                   	cld    
801059a2:	f3 aa                	rep stos %al,%es:(%edi)
801059a4:	89 ca                	mov    %ecx,%edx
801059a6:	89 fb                	mov    %edi,%ebx
801059a8:	89 5d 08             	mov    %ebx,0x8(%ebp)
801059ab:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801059ae:	90                   	nop
801059af:	5b                   	pop    %ebx
801059b0:	5f                   	pop    %edi
801059b1:	5d                   	pop    %ebp
801059b2:	c3                   	ret    

801059b3 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
801059b3:	55                   	push   %ebp
801059b4:	89 e5                	mov    %esp,%ebp
801059b6:	57                   	push   %edi
801059b7:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
801059b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
801059bb:	8b 55 10             	mov    0x10(%ebp),%edx
801059be:	8b 45 0c             	mov    0xc(%ebp),%eax
801059c1:	89 cb                	mov    %ecx,%ebx
801059c3:	89 df                	mov    %ebx,%edi
801059c5:	89 d1                	mov    %edx,%ecx
801059c7:	fc                   	cld    
801059c8:	f3 ab                	rep stos %eax,%es:(%edi)
801059ca:	89 ca                	mov    %ecx,%edx
801059cc:	89 fb                	mov    %edi,%ebx
801059ce:	89 5d 08             	mov    %ebx,0x8(%ebp)
801059d1:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801059d4:	90                   	nop
801059d5:	5b                   	pop    %ebx
801059d6:	5f                   	pop    %edi
801059d7:	5d                   	pop    %ebp
801059d8:	c3                   	ret    

801059d9 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801059d9:	55                   	push   %ebp
801059da:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
801059dc:	8b 45 08             	mov    0x8(%ebp),%eax
801059df:	83 e0 03             	and    $0x3,%eax
801059e2:	85 c0                	test   %eax,%eax
801059e4:	75 43                	jne    80105a29 <memset+0x50>
801059e6:	8b 45 10             	mov    0x10(%ebp),%eax
801059e9:	83 e0 03             	and    $0x3,%eax
801059ec:	85 c0                	test   %eax,%eax
801059ee:	75 39                	jne    80105a29 <memset+0x50>
    c &= 0xFF;
801059f0:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801059f7:	8b 45 10             	mov    0x10(%ebp),%eax
801059fa:	c1 e8 02             	shr    $0x2,%eax
801059fd:	89 c1                	mov    %eax,%ecx
801059ff:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a02:	c1 e0 18             	shl    $0x18,%eax
80105a05:	89 c2                	mov    %eax,%edx
80105a07:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a0a:	c1 e0 10             	shl    $0x10,%eax
80105a0d:	09 c2                	or     %eax,%edx
80105a0f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a12:	c1 e0 08             	shl    $0x8,%eax
80105a15:	09 d0                	or     %edx,%eax
80105a17:	0b 45 0c             	or     0xc(%ebp),%eax
80105a1a:	51                   	push   %ecx
80105a1b:	50                   	push   %eax
80105a1c:	ff 75 08             	pushl  0x8(%ebp)
80105a1f:	e8 8f ff ff ff       	call   801059b3 <stosl>
80105a24:	83 c4 0c             	add    $0xc,%esp
80105a27:	eb 12                	jmp    80105a3b <memset+0x62>
  } else
    stosb(dst, c, n);
80105a29:	8b 45 10             	mov    0x10(%ebp),%eax
80105a2c:	50                   	push   %eax
80105a2d:	ff 75 0c             	pushl  0xc(%ebp)
80105a30:	ff 75 08             	pushl  0x8(%ebp)
80105a33:	e8 55 ff ff ff       	call   8010598d <stosb>
80105a38:	83 c4 0c             	add    $0xc,%esp
  return dst;
80105a3b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105a3e:	c9                   	leave  
80105a3f:	c3                   	ret    

80105a40 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105a40:	55                   	push   %ebp
80105a41:	89 e5                	mov    %esp,%ebp
80105a43:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80105a46:	8b 45 08             	mov    0x8(%ebp),%eax
80105a49:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80105a4c:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a4f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80105a52:	eb 30                	jmp    80105a84 <memcmp+0x44>
    if(*s1 != *s2)
80105a54:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a57:	0f b6 10             	movzbl (%eax),%edx
80105a5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105a5d:	0f b6 00             	movzbl (%eax),%eax
80105a60:	38 c2                	cmp    %al,%dl
80105a62:	74 18                	je     80105a7c <memcmp+0x3c>
      return *s1 - *s2;
80105a64:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a67:	0f b6 00             	movzbl (%eax),%eax
80105a6a:	0f b6 d0             	movzbl %al,%edx
80105a6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105a70:	0f b6 00             	movzbl (%eax),%eax
80105a73:	0f b6 c0             	movzbl %al,%eax
80105a76:	29 c2                	sub    %eax,%edx
80105a78:	89 d0                	mov    %edx,%eax
80105a7a:	eb 1a                	jmp    80105a96 <memcmp+0x56>
    s1++, s2++;
80105a7c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105a80:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105a84:	8b 45 10             	mov    0x10(%ebp),%eax
80105a87:	8d 50 ff             	lea    -0x1(%eax),%edx
80105a8a:	89 55 10             	mov    %edx,0x10(%ebp)
80105a8d:	85 c0                	test   %eax,%eax
80105a8f:	75 c3                	jne    80105a54 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80105a91:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105a96:	c9                   	leave  
80105a97:	c3                   	ret    

80105a98 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105a98:	55                   	push   %ebp
80105a99:	89 e5                	mov    %esp,%ebp
80105a9b:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80105a9e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105aa1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80105aa4:	8b 45 08             	mov    0x8(%ebp),%eax
80105aa7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80105aaa:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105aad:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105ab0:	73 54                	jae    80105b06 <memmove+0x6e>
80105ab2:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105ab5:	8b 45 10             	mov    0x10(%ebp),%eax
80105ab8:	01 d0                	add    %edx,%eax
80105aba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105abd:	76 47                	jbe    80105b06 <memmove+0x6e>
    s += n;
80105abf:	8b 45 10             	mov    0x10(%ebp),%eax
80105ac2:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80105ac5:	8b 45 10             	mov    0x10(%ebp),%eax
80105ac8:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80105acb:	eb 13                	jmp    80105ae0 <memmove+0x48>
      *--d = *--s;
80105acd:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80105ad1:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80105ad5:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105ad8:	0f b6 10             	movzbl (%eax),%edx
80105adb:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105ade:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80105ae0:	8b 45 10             	mov    0x10(%ebp),%eax
80105ae3:	8d 50 ff             	lea    -0x1(%eax),%edx
80105ae6:	89 55 10             	mov    %edx,0x10(%ebp)
80105ae9:	85 c0                	test   %eax,%eax
80105aeb:	75 e0                	jne    80105acd <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105aed:	eb 24                	jmp    80105b13 <memmove+0x7b>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
80105aef:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105af2:	8d 50 01             	lea    0x1(%eax),%edx
80105af5:	89 55 f8             	mov    %edx,-0x8(%ebp)
80105af8:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105afb:	8d 4a 01             	lea    0x1(%edx),%ecx
80105afe:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80105b01:	0f b6 12             	movzbl (%edx),%edx
80105b04:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105b06:	8b 45 10             	mov    0x10(%ebp),%eax
80105b09:	8d 50 ff             	lea    -0x1(%eax),%edx
80105b0c:	89 55 10             	mov    %edx,0x10(%ebp)
80105b0f:	85 c0                	test   %eax,%eax
80105b11:	75 dc                	jne    80105aef <memmove+0x57>
      *d++ = *s++;

  return dst;
80105b13:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105b16:	c9                   	leave  
80105b17:	c3                   	ret    

80105b18 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105b18:	55                   	push   %ebp
80105b19:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80105b1b:	ff 75 10             	pushl  0x10(%ebp)
80105b1e:	ff 75 0c             	pushl  0xc(%ebp)
80105b21:	ff 75 08             	pushl  0x8(%ebp)
80105b24:	e8 6f ff ff ff       	call   80105a98 <memmove>
80105b29:	83 c4 0c             	add    $0xc,%esp
}
80105b2c:	c9                   	leave  
80105b2d:	c3                   	ret    

80105b2e <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105b2e:	55                   	push   %ebp
80105b2f:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80105b31:	eb 0c                	jmp    80105b3f <strncmp+0x11>
    n--, p++, q++;
80105b33:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105b37:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105b3b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80105b3f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105b43:	74 1a                	je     80105b5f <strncmp+0x31>
80105b45:	8b 45 08             	mov    0x8(%ebp),%eax
80105b48:	0f b6 00             	movzbl (%eax),%eax
80105b4b:	84 c0                	test   %al,%al
80105b4d:	74 10                	je     80105b5f <strncmp+0x31>
80105b4f:	8b 45 08             	mov    0x8(%ebp),%eax
80105b52:	0f b6 10             	movzbl (%eax),%edx
80105b55:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b58:	0f b6 00             	movzbl (%eax),%eax
80105b5b:	38 c2                	cmp    %al,%dl
80105b5d:	74 d4                	je     80105b33 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80105b5f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105b63:	75 07                	jne    80105b6c <strncmp+0x3e>
    return 0;
80105b65:	b8 00 00 00 00       	mov    $0x0,%eax
80105b6a:	eb 16                	jmp    80105b82 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80105b6c:	8b 45 08             	mov    0x8(%ebp),%eax
80105b6f:	0f b6 00             	movzbl (%eax),%eax
80105b72:	0f b6 d0             	movzbl %al,%edx
80105b75:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b78:	0f b6 00             	movzbl (%eax),%eax
80105b7b:	0f b6 c0             	movzbl %al,%eax
80105b7e:	29 c2                	sub    %eax,%edx
80105b80:	89 d0                	mov    %edx,%eax
}
80105b82:	5d                   	pop    %ebp
80105b83:	c3                   	ret    

80105b84 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105b84:	55                   	push   %ebp
80105b85:	89 e5                	mov    %esp,%ebp
80105b87:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105b8a:	8b 45 08             	mov    0x8(%ebp),%eax
80105b8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80105b90:	90                   	nop
80105b91:	8b 45 10             	mov    0x10(%ebp),%eax
80105b94:	8d 50 ff             	lea    -0x1(%eax),%edx
80105b97:	89 55 10             	mov    %edx,0x10(%ebp)
80105b9a:	85 c0                	test   %eax,%eax
80105b9c:	7e 2c                	jle    80105bca <strncpy+0x46>
80105b9e:	8b 45 08             	mov    0x8(%ebp),%eax
80105ba1:	8d 50 01             	lea    0x1(%eax),%edx
80105ba4:	89 55 08             	mov    %edx,0x8(%ebp)
80105ba7:	8b 55 0c             	mov    0xc(%ebp),%edx
80105baa:	8d 4a 01             	lea    0x1(%edx),%ecx
80105bad:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105bb0:	0f b6 12             	movzbl (%edx),%edx
80105bb3:	88 10                	mov    %dl,(%eax)
80105bb5:	0f b6 00             	movzbl (%eax),%eax
80105bb8:	84 c0                	test   %al,%al
80105bba:	75 d5                	jne    80105b91 <strncpy+0xd>
    ;
  while(n-- > 0)
80105bbc:	eb 0c                	jmp    80105bca <strncpy+0x46>
    *s++ = 0;
80105bbe:	8b 45 08             	mov    0x8(%ebp),%eax
80105bc1:	8d 50 01             	lea    0x1(%eax),%edx
80105bc4:	89 55 08             	mov    %edx,0x8(%ebp)
80105bc7:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80105bca:	8b 45 10             	mov    0x10(%ebp),%eax
80105bcd:	8d 50 ff             	lea    -0x1(%eax),%edx
80105bd0:	89 55 10             	mov    %edx,0x10(%ebp)
80105bd3:	85 c0                	test   %eax,%eax
80105bd5:	7f e7                	jg     80105bbe <strncpy+0x3a>
    *s++ = 0;
  return os;
80105bd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105bda:	c9                   	leave  
80105bdb:	c3                   	ret    

80105bdc <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105bdc:	55                   	push   %ebp
80105bdd:	89 e5                	mov    %esp,%ebp
80105bdf:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105be2:	8b 45 08             	mov    0x8(%ebp),%eax
80105be5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80105be8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105bec:	7f 05                	jg     80105bf3 <safestrcpy+0x17>
    return os;
80105bee:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105bf1:	eb 31                	jmp    80105c24 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
80105bf3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105bf7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105bfb:	7e 1e                	jle    80105c1b <safestrcpy+0x3f>
80105bfd:	8b 45 08             	mov    0x8(%ebp),%eax
80105c00:	8d 50 01             	lea    0x1(%eax),%edx
80105c03:	89 55 08             	mov    %edx,0x8(%ebp)
80105c06:	8b 55 0c             	mov    0xc(%ebp),%edx
80105c09:	8d 4a 01             	lea    0x1(%edx),%ecx
80105c0c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105c0f:	0f b6 12             	movzbl (%edx),%edx
80105c12:	88 10                	mov    %dl,(%eax)
80105c14:	0f b6 00             	movzbl (%eax),%eax
80105c17:	84 c0                	test   %al,%al
80105c19:	75 d8                	jne    80105bf3 <safestrcpy+0x17>
    ;
  *s = 0;
80105c1b:	8b 45 08             	mov    0x8(%ebp),%eax
80105c1e:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105c21:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105c24:	c9                   	leave  
80105c25:	c3                   	ret    

80105c26 <strlen>:

int
strlen(const char *s)
{
80105c26:	55                   	push   %ebp
80105c27:	89 e5                	mov    %esp,%ebp
80105c29:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105c2c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105c33:	eb 04                	jmp    80105c39 <strlen+0x13>
80105c35:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105c39:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105c3c:	8b 45 08             	mov    0x8(%ebp),%eax
80105c3f:	01 d0                	add    %edx,%eax
80105c41:	0f b6 00             	movzbl (%eax),%eax
80105c44:	84 c0                	test   %al,%al
80105c46:	75 ed                	jne    80105c35 <strlen+0xf>
    ;
  return n;
80105c48:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105c4b:	c9                   	leave  
80105c4c:	c3                   	ret    

80105c4d <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105c4d:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105c51:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80105c55:	55                   	push   %ebp
  pushl %ebx
80105c56:	53                   	push   %ebx
  pushl %esi
80105c57:	56                   	push   %esi
  pushl %edi
80105c58:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105c59:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105c5b:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80105c5d:	5f                   	pop    %edi
  popl %esi
80105c5e:	5e                   	pop    %esi
  popl %ebx
80105c5f:	5b                   	pop    %ebx
  popl %ebp
80105c60:	5d                   	pop    %ebp
  ret
80105c61:	c3                   	ret    

80105c62 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105c62:	55                   	push   %ebp
80105c63:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80105c65:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c6b:	8b 00                	mov    (%eax),%eax
80105c6d:	3b 45 08             	cmp    0x8(%ebp),%eax
80105c70:	76 12                	jbe    80105c84 <fetchint+0x22>
80105c72:	8b 45 08             	mov    0x8(%ebp),%eax
80105c75:	8d 50 04             	lea    0x4(%eax),%edx
80105c78:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c7e:	8b 00                	mov    (%eax),%eax
80105c80:	39 c2                	cmp    %eax,%edx
80105c82:	76 07                	jbe    80105c8b <fetchint+0x29>
    return -1;
80105c84:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c89:	eb 0f                	jmp    80105c9a <fetchint+0x38>
  *ip = *(int*)(addr);
80105c8b:	8b 45 08             	mov    0x8(%ebp),%eax
80105c8e:	8b 10                	mov    (%eax),%edx
80105c90:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c93:	89 10                	mov    %edx,(%eax)
  return 0;
80105c95:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105c9a:	5d                   	pop    %ebp
80105c9b:	c3                   	ret    

80105c9c <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105c9c:	55                   	push   %ebp
80105c9d:	89 e5                	mov    %esp,%ebp
80105c9f:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
80105ca2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ca8:	8b 00                	mov    (%eax),%eax
80105caa:	3b 45 08             	cmp    0x8(%ebp),%eax
80105cad:	77 07                	ja     80105cb6 <fetchstr+0x1a>
    return -1;
80105caf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cb4:	eb 46                	jmp    80105cfc <fetchstr+0x60>
  *pp = (char*)addr;
80105cb6:	8b 55 08             	mov    0x8(%ebp),%edx
80105cb9:	8b 45 0c             	mov    0xc(%ebp),%eax
80105cbc:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80105cbe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105cc4:	8b 00                	mov    (%eax),%eax
80105cc6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80105cc9:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ccc:	8b 00                	mov    (%eax),%eax
80105cce:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105cd1:	eb 1c                	jmp    80105cef <fetchstr+0x53>
    if(*s == 0)
80105cd3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105cd6:	0f b6 00             	movzbl (%eax),%eax
80105cd9:	84 c0                	test   %al,%al
80105cdb:	75 0e                	jne    80105ceb <fetchstr+0x4f>
      return s - *pp;
80105cdd:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105ce0:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ce3:	8b 00                	mov    (%eax),%eax
80105ce5:	29 c2                	sub    %eax,%edx
80105ce7:	89 d0                	mov    %edx,%eax
80105ce9:	eb 11                	jmp    80105cfc <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80105ceb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105cef:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105cf2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105cf5:	72 dc                	jb     80105cd3 <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
80105cf7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cfc:	c9                   	leave  
80105cfd:	c3                   	ret    

80105cfe <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105cfe:	55                   	push   %ebp
80105cff:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105d01:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d07:	8b 40 18             	mov    0x18(%eax),%eax
80105d0a:	8b 40 44             	mov    0x44(%eax),%eax
80105d0d:	8b 55 08             	mov    0x8(%ebp),%edx
80105d10:	c1 e2 02             	shl    $0x2,%edx
80105d13:	01 d0                	add    %edx,%eax
80105d15:	83 c0 04             	add    $0x4,%eax
80105d18:	ff 75 0c             	pushl  0xc(%ebp)
80105d1b:	50                   	push   %eax
80105d1c:	e8 41 ff ff ff       	call   80105c62 <fetchint>
80105d21:	83 c4 08             	add    $0x8,%esp
}
80105d24:	c9                   	leave  
80105d25:	c3                   	ret    

80105d26 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105d26:	55                   	push   %ebp
80105d27:	89 e5                	mov    %esp,%ebp
80105d29:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
80105d2c:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105d2f:	50                   	push   %eax
80105d30:	ff 75 08             	pushl  0x8(%ebp)
80105d33:	e8 c6 ff ff ff       	call   80105cfe <argint>
80105d38:	83 c4 08             	add    $0x8,%esp
80105d3b:	85 c0                	test   %eax,%eax
80105d3d:	79 07                	jns    80105d46 <argptr+0x20>
    return -1;
80105d3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d44:	eb 3b                	jmp    80105d81 <argptr+0x5b>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80105d46:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d4c:	8b 00                	mov    (%eax),%eax
80105d4e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105d51:	39 d0                	cmp    %edx,%eax
80105d53:	76 16                	jbe    80105d6b <argptr+0x45>
80105d55:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105d58:	89 c2                	mov    %eax,%edx
80105d5a:	8b 45 10             	mov    0x10(%ebp),%eax
80105d5d:	01 c2                	add    %eax,%edx
80105d5f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d65:	8b 00                	mov    (%eax),%eax
80105d67:	39 c2                	cmp    %eax,%edx
80105d69:	76 07                	jbe    80105d72 <argptr+0x4c>
    return -1;
80105d6b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d70:	eb 0f                	jmp    80105d81 <argptr+0x5b>
  *pp = (char*)i;
80105d72:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105d75:	89 c2                	mov    %eax,%edx
80105d77:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d7a:	89 10                	mov    %edx,(%eax)
  return 0;
80105d7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105d81:	c9                   	leave  
80105d82:	c3                   	ret    

80105d83 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105d83:	55                   	push   %ebp
80105d84:	89 e5                	mov    %esp,%ebp
80105d86:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105d89:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105d8c:	50                   	push   %eax
80105d8d:	ff 75 08             	pushl  0x8(%ebp)
80105d90:	e8 69 ff ff ff       	call   80105cfe <argint>
80105d95:	83 c4 08             	add    $0x8,%esp
80105d98:	85 c0                	test   %eax,%eax
80105d9a:	79 07                	jns    80105da3 <argstr+0x20>
    return -1;
80105d9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105da1:	eb 0f                	jmp    80105db2 <argstr+0x2f>
  return fetchstr(addr, pp);
80105da3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105da6:	ff 75 0c             	pushl  0xc(%ebp)
80105da9:	50                   	push   %eax
80105daa:	e8 ed fe ff ff       	call   80105c9c <fetchstr>
80105daf:	83 c4 08             	add    $0x8,%esp
}
80105db2:	c9                   	leave  
80105db3:	c3                   	ret    

80105db4 <syscall>:
};
#endif

void
syscall(void)
{
80105db4:	55                   	push   %ebp
80105db5:	89 e5                	mov    %esp,%ebp
80105db7:	53                   	push   %ebx
80105db8:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
80105dbb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105dc1:	8b 40 18             	mov    0x18(%eax),%eax
80105dc4:	8b 40 1c             	mov    0x1c(%eax),%eax
80105dc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105dca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105dce:	7e 30                	jle    80105e00 <syscall+0x4c>
80105dd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dd3:	83 f8 21             	cmp    $0x21,%eax
80105dd6:	77 28                	ja     80105e00 <syscall+0x4c>
80105dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ddb:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105de2:	85 c0                	test   %eax,%eax
80105de4:	74 1a                	je     80105e00 <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
80105de6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105dec:	8b 58 18             	mov    0x18(%eax),%ebx
80105def:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105df2:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105df9:	ff d0                	call   *%eax
80105dfb:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105dfe:	eb 34                	jmp    80105e34 <syscall+0x80>
    #ifdef PRINT_SYSCALLS
    cprintf("%s -> %d\n", syscallnames[num], proc->tf->eax);
    #endif    
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105e00:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e06:	8d 50 6c             	lea    0x6c(%eax),%edx
80105e09:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// some code goes here
    #ifdef PRINT_SYSCALLS
    cprintf("%s -> %d\n", syscallnames[num], proc->tf->eax);
    #endif    
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105e0f:	8b 40 10             	mov    0x10(%eax),%eax
80105e12:	ff 75 f4             	pushl  -0xc(%ebp)
80105e15:	52                   	push   %edx
80105e16:	50                   	push   %eax
80105e17:	68 a3 93 10 80       	push   $0x801093a3
80105e1c:	e8 a5 a5 ff ff       	call   801003c6 <cprintf>
80105e21:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80105e24:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e2a:	8b 40 18             	mov    0x18(%eax),%eax
80105e2d:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105e34:	90                   	nop
80105e35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e38:	c9                   	leave  
80105e39:	c3                   	ret    

80105e3a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105e3a:	55                   	push   %ebp
80105e3b:	89 e5                	mov    %esp,%ebp
80105e3d:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105e40:	83 ec 08             	sub    $0x8,%esp
80105e43:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e46:	50                   	push   %eax
80105e47:	ff 75 08             	pushl  0x8(%ebp)
80105e4a:	e8 af fe ff ff       	call   80105cfe <argint>
80105e4f:	83 c4 10             	add    $0x10,%esp
80105e52:	85 c0                	test   %eax,%eax
80105e54:	79 07                	jns    80105e5d <argfd+0x23>
    return -1;
80105e56:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e5b:	eb 50                	jmp    80105ead <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105e5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e60:	85 c0                	test   %eax,%eax
80105e62:	78 21                	js     80105e85 <argfd+0x4b>
80105e64:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e67:	83 f8 0f             	cmp    $0xf,%eax
80105e6a:	7f 19                	jg     80105e85 <argfd+0x4b>
80105e6c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e72:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105e75:	83 c2 08             	add    $0x8,%edx
80105e78:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105e7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e83:	75 07                	jne    80105e8c <argfd+0x52>
    return -1;
80105e85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e8a:	eb 21                	jmp    80105ead <argfd+0x73>
  if(pfd)
80105e8c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105e90:	74 08                	je     80105e9a <argfd+0x60>
    *pfd = fd;
80105e92:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105e95:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e98:	89 10                	mov    %edx,(%eax)
  if(pf)
80105e9a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105e9e:	74 08                	je     80105ea8 <argfd+0x6e>
    *pf = f;
80105ea0:	8b 45 10             	mov    0x10(%ebp),%eax
80105ea3:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ea6:	89 10                	mov    %edx,(%eax)
  return 0;
80105ea8:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105ead:	c9                   	leave  
80105eae:	c3                   	ret    

80105eaf <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105eaf:	55                   	push   %ebp
80105eb0:	89 e5                	mov    %esp,%ebp
80105eb2:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105eb5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105ebc:	eb 30                	jmp    80105eee <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80105ebe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ec4:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105ec7:	83 c2 08             	add    $0x8,%edx
80105eca:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105ece:	85 c0                	test   %eax,%eax
80105ed0:	75 18                	jne    80105eea <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105ed2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ed8:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105edb:	8d 4a 08             	lea    0x8(%edx),%ecx
80105ede:	8b 55 08             	mov    0x8(%ebp),%edx
80105ee1:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105ee5:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105ee8:	eb 0f                	jmp    80105ef9 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105eea:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105eee:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105ef2:	7e ca                	jle    80105ebe <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80105ef4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ef9:	c9                   	leave  
80105efa:	c3                   	ret    

80105efb <sys_dup>:

int
sys_dup(void)
{
80105efb:	55                   	push   %ebp
80105efc:	89 e5                	mov    %esp,%ebp
80105efe:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105f01:	83 ec 04             	sub    $0x4,%esp
80105f04:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f07:	50                   	push   %eax
80105f08:	6a 00                	push   $0x0
80105f0a:	6a 00                	push   $0x0
80105f0c:	e8 29 ff ff ff       	call   80105e3a <argfd>
80105f11:	83 c4 10             	add    $0x10,%esp
80105f14:	85 c0                	test   %eax,%eax
80105f16:	79 07                	jns    80105f1f <sys_dup+0x24>
    return -1;
80105f18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f1d:	eb 31                	jmp    80105f50 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105f1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f22:	83 ec 0c             	sub    $0xc,%esp
80105f25:	50                   	push   %eax
80105f26:	e8 84 ff ff ff       	call   80105eaf <fdalloc>
80105f2b:	83 c4 10             	add    $0x10,%esp
80105f2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f35:	79 07                	jns    80105f3e <sys_dup+0x43>
    return -1;
80105f37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f3c:	eb 12                	jmp    80105f50 <sys_dup+0x55>
  filedup(f);
80105f3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f41:	83 ec 0c             	sub    $0xc,%esp
80105f44:	50                   	push   %eax
80105f45:	e8 5e b1 ff ff       	call   801010a8 <filedup>
80105f4a:	83 c4 10             	add    $0x10,%esp
  return fd;
80105f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105f50:	c9                   	leave  
80105f51:	c3                   	ret    

80105f52 <sys_read>:

int
sys_read(void)
{
80105f52:	55                   	push   %ebp
80105f53:	89 e5                	mov    %esp,%ebp
80105f55:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105f58:	83 ec 04             	sub    $0x4,%esp
80105f5b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f5e:	50                   	push   %eax
80105f5f:	6a 00                	push   $0x0
80105f61:	6a 00                	push   $0x0
80105f63:	e8 d2 fe ff ff       	call   80105e3a <argfd>
80105f68:	83 c4 10             	add    $0x10,%esp
80105f6b:	85 c0                	test   %eax,%eax
80105f6d:	78 2e                	js     80105f9d <sys_read+0x4b>
80105f6f:	83 ec 08             	sub    $0x8,%esp
80105f72:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f75:	50                   	push   %eax
80105f76:	6a 02                	push   $0x2
80105f78:	e8 81 fd ff ff       	call   80105cfe <argint>
80105f7d:	83 c4 10             	add    $0x10,%esp
80105f80:	85 c0                	test   %eax,%eax
80105f82:	78 19                	js     80105f9d <sys_read+0x4b>
80105f84:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f87:	83 ec 04             	sub    $0x4,%esp
80105f8a:	50                   	push   %eax
80105f8b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105f8e:	50                   	push   %eax
80105f8f:	6a 01                	push   $0x1
80105f91:	e8 90 fd ff ff       	call   80105d26 <argptr>
80105f96:	83 c4 10             	add    $0x10,%esp
80105f99:	85 c0                	test   %eax,%eax
80105f9b:	79 07                	jns    80105fa4 <sys_read+0x52>
    return -1;
80105f9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fa2:	eb 17                	jmp    80105fbb <sys_read+0x69>
  return fileread(f, p, n);
80105fa4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105fa7:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105faa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fad:	83 ec 04             	sub    $0x4,%esp
80105fb0:	51                   	push   %ecx
80105fb1:	52                   	push   %edx
80105fb2:	50                   	push   %eax
80105fb3:	e8 80 b2 ff ff       	call   80101238 <fileread>
80105fb8:	83 c4 10             	add    $0x10,%esp
}
80105fbb:	c9                   	leave  
80105fbc:	c3                   	ret    

80105fbd <sys_write>:

int
sys_write(void)
{
80105fbd:	55                   	push   %ebp
80105fbe:	89 e5                	mov    %esp,%ebp
80105fc0:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105fc3:	83 ec 04             	sub    $0x4,%esp
80105fc6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fc9:	50                   	push   %eax
80105fca:	6a 00                	push   $0x0
80105fcc:	6a 00                	push   $0x0
80105fce:	e8 67 fe ff ff       	call   80105e3a <argfd>
80105fd3:	83 c4 10             	add    $0x10,%esp
80105fd6:	85 c0                	test   %eax,%eax
80105fd8:	78 2e                	js     80106008 <sys_write+0x4b>
80105fda:	83 ec 08             	sub    $0x8,%esp
80105fdd:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105fe0:	50                   	push   %eax
80105fe1:	6a 02                	push   $0x2
80105fe3:	e8 16 fd ff ff       	call   80105cfe <argint>
80105fe8:	83 c4 10             	add    $0x10,%esp
80105feb:	85 c0                	test   %eax,%eax
80105fed:	78 19                	js     80106008 <sys_write+0x4b>
80105fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ff2:	83 ec 04             	sub    $0x4,%esp
80105ff5:	50                   	push   %eax
80105ff6:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105ff9:	50                   	push   %eax
80105ffa:	6a 01                	push   $0x1
80105ffc:	e8 25 fd ff ff       	call   80105d26 <argptr>
80106001:	83 c4 10             	add    $0x10,%esp
80106004:	85 c0                	test   %eax,%eax
80106006:	79 07                	jns    8010600f <sys_write+0x52>
    return -1;
80106008:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010600d:	eb 17                	jmp    80106026 <sys_write+0x69>
  return filewrite(f, p, n);
8010600f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80106012:	8b 55 ec             	mov    -0x14(%ebp),%edx
80106015:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106018:	83 ec 04             	sub    $0x4,%esp
8010601b:	51                   	push   %ecx
8010601c:	52                   	push   %edx
8010601d:	50                   	push   %eax
8010601e:	e8 cd b2 ff ff       	call   801012f0 <filewrite>
80106023:	83 c4 10             	add    $0x10,%esp
}
80106026:	c9                   	leave  
80106027:	c3                   	ret    

80106028 <sys_close>:

int
sys_close(void)
{
80106028:	55                   	push   %ebp
80106029:	89 e5                	mov    %esp,%ebp
8010602b:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
8010602e:	83 ec 04             	sub    $0x4,%esp
80106031:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106034:	50                   	push   %eax
80106035:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106038:	50                   	push   %eax
80106039:	6a 00                	push   $0x0
8010603b:	e8 fa fd ff ff       	call   80105e3a <argfd>
80106040:	83 c4 10             	add    $0x10,%esp
80106043:	85 c0                	test   %eax,%eax
80106045:	79 07                	jns    8010604e <sys_close+0x26>
    return -1;
80106047:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010604c:	eb 28                	jmp    80106076 <sys_close+0x4e>
  proc->ofile[fd] = 0;
8010604e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106054:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106057:	83 c2 08             	add    $0x8,%edx
8010605a:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106061:	00 
  fileclose(f);
80106062:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106065:	83 ec 0c             	sub    $0xc,%esp
80106068:	50                   	push   %eax
80106069:	e8 8b b0 ff ff       	call   801010f9 <fileclose>
8010606e:	83 c4 10             	add    $0x10,%esp
  return 0;
80106071:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106076:	c9                   	leave  
80106077:	c3                   	ret    

80106078 <sys_fstat>:

int
sys_fstat(void)
{
80106078:	55                   	push   %ebp
80106079:	89 e5                	mov    %esp,%ebp
8010607b:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010607e:	83 ec 04             	sub    $0x4,%esp
80106081:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106084:	50                   	push   %eax
80106085:	6a 00                	push   $0x0
80106087:	6a 00                	push   $0x0
80106089:	e8 ac fd ff ff       	call   80105e3a <argfd>
8010608e:	83 c4 10             	add    $0x10,%esp
80106091:	85 c0                	test   %eax,%eax
80106093:	78 17                	js     801060ac <sys_fstat+0x34>
80106095:	83 ec 04             	sub    $0x4,%esp
80106098:	6a 20                	push   $0x20
8010609a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010609d:	50                   	push   %eax
8010609e:	6a 01                	push   $0x1
801060a0:	e8 81 fc ff ff       	call   80105d26 <argptr>
801060a5:	83 c4 10             	add    $0x10,%esp
801060a8:	85 c0                	test   %eax,%eax
801060aa:	79 07                	jns    801060b3 <sys_fstat+0x3b>
    return -1;
801060ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060b1:	eb 13                	jmp    801060c6 <sys_fstat+0x4e>
  return filestat(f, st);
801060b3:	8b 55 f0             	mov    -0x10(%ebp),%edx
801060b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060b9:	83 ec 08             	sub    $0x8,%esp
801060bc:	52                   	push   %edx
801060bd:	50                   	push   %eax
801060be:	e8 1e b1 ff ff       	call   801011e1 <filestat>
801060c3:	83 c4 10             	add    $0x10,%esp
}
801060c6:	c9                   	leave  
801060c7:	c3                   	ret    

801060c8 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801060c8:	55                   	push   %ebp
801060c9:	89 e5                	mov    %esp,%ebp
801060cb:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801060ce:	83 ec 08             	sub    $0x8,%esp
801060d1:	8d 45 d8             	lea    -0x28(%ebp),%eax
801060d4:	50                   	push   %eax
801060d5:	6a 00                	push   $0x0
801060d7:	e8 a7 fc ff ff       	call   80105d83 <argstr>
801060dc:	83 c4 10             	add    $0x10,%esp
801060df:	85 c0                	test   %eax,%eax
801060e1:	78 15                	js     801060f8 <sys_link+0x30>
801060e3:	83 ec 08             	sub    $0x8,%esp
801060e6:	8d 45 dc             	lea    -0x24(%ebp),%eax
801060e9:	50                   	push   %eax
801060ea:	6a 01                	push   $0x1
801060ec:	e8 92 fc ff ff       	call   80105d83 <argstr>
801060f1:	83 c4 10             	add    $0x10,%esp
801060f4:	85 c0                	test   %eax,%eax
801060f6:	79 0a                	jns    80106102 <sys_link+0x3a>
    return -1;
801060f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060fd:	e9 68 01 00 00       	jmp    8010626a <sys_link+0x1a2>

  begin_op();
80106102:	e8 24 d7 ff ff       	call   8010382b <begin_op>
  if((ip = namei(old)) == 0){
80106107:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010610a:	83 ec 0c             	sub    $0xc,%esp
8010610d:	50                   	push   %eax
8010610e:	e8 55 c5 ff ff       	call   80102668 <namei>
80106113:	83 c4 10             	add    $0x10,%esp
80106116:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106119:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010611d:	75 0f                	jne    8010612e <sys_link+0x66>
    end_op();
8010611f:	e8 93 d7 ff ff       	call   801038b7 <end_op>
    return -1;
80106124:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106129:	e9 3c 01 00 00       	jmp    8010626a <sys_link+0x1a2>
  }

  ilock(ip);
8010612e:	83 ec 0c             	sub    $0xc,%esp
80106131:	ff 75 f4             	pushl  -0xc(%ebp)
80106134:	e8 1d b9 ff ff       	call   80101a56 <ilock>
80106139:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
8010613c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010613f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106143:	66 83 f8 01          	cmp    $0x1,%ax
80106147:	75 1d                	jne    80106166 <sys_link+0x9e>
    iunlockput(ip);
80106149:	83 ec 0c             	sub    $0xc,%esp
8010614c:	ff 75 f4             	pushl  -0xc(%ebp)
8010614f:	e8 ea bb ff ff       	call   80101d3e <iunlockput>
80106154:	83 c4 10             	add    $0x10,%esp
    end_op();
80106157:	e8 5b d7 ff ff       	call   801038b7 <end_op>
    return -1;
8010615c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106161:	e9 04 01 00 00       	jmp    8010626a <sys_link+0x1a2>
  }

  ip->nlink++;
80106166:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106169:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010616d:	83 c0 01             	add    $0x1,%eax
80106170:	89 c2                	mov    %eax,%edx
80106172:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106175:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80106179:	83 ec 0c             	sub    $0xc,%esp
8010617c:	ff 75 f4             	pushl  -0xc(%ebp)
8010617f:	e8 d0 b6 ff ff       	call   80101854 <iupdate>
80106184:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80106187:	83 ec 0c             	sub    $0xc,%esp
8010618a:	ff 75 f4             	pushl  -0xc(%ebp)
8010618d:	e8 4a ba ff ff       	call   80101bdc <iunlock>
80106192:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80106195:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106198:	83 ec 08             	sub    $0x8,%esp
8010619b:	8d 55 e2             	lea    -0x1e(%ebp),%edx
8010619e:	52                   	push   %edx
8010619f:	50                   	push   %eax
801061a0:	e8 df c4 ff ff       	call   80102684 <nameiparent>
801061a5:	83 c4 10             	add    $0x10,%esp
801061a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
801061ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801061af:	74 71                	je     80106222 <sys_link+0x15a>
    goto bad;
  ilock(dp);
801061b1:	83 ec 0c             	sub    $0xc,%esp
801061b4:	ff 75 f0             	pushl  -0x10(%ebp)
801061b7:	e8 9a b8 ff ff       	call   80101a56 <ilock>
801061bc:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801061bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061c2:	8b 10                	mov    (%eax),%edx
801061c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061c7:	8b 00                	mov    (%eax),%eax
801061c9:	39 c2                	cmp    %eax,%edx
801061cb:	75 1d                	jne    801061ea <sys_link+0x122>
801061cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061d0:	8b 40 04             	mov    0x4(%eax),%eax
801061d3:	83 ec 04             	sub    $0x4,%esp
801061d6:	50                   	push   %eax
801061d7:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801061da:	50                   	push   %eax
801061db:	ff 75 f0             	pushl  -0x10(%ebp)
801061de:	e8 e9 c1 ff ff       	call   801023cc <dirlink>
801061e3:	83 c4 10             	add    $0x10,%esp
801061e6:	85 c0                	test   %eax,%eax
801061e8:	79 10                	jns    801061fa <sys_link+0x132>
    iunlockput(dp);
801061ea:	83 ec 0c             	sub    $0xc,%esp
801061ed:	ff 75 f0             	pushl  -0x10(%ebp)
801061f0:	e8 49 bb ff ff       	call   80101d3e <iunlockput>
801061f5:	83 c4 10             	add    $0x10,%esp
    goto bad;
801061f8:	eb 29                	jmp    80106223 <sys_link+0x15b>
  }
  iunlockput(dp);
801061fa:	83 ec 0c             	sub    $0xc,%esp
801061fd:	ff 75 f0             	pushl  -0x10(%ebp)
80106200:	e8 39 bb ff ff       	call   80101d3e <iunlockput>
80106205:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80106208:	83 ec 0c             	sub    $0xc,%esp
8010620b:	ff 75 f4             	pushl  -0xc(%ebp)
8010620e:	e8 3b ba ff ff       	call   80101c4e <iput>
80106213:	83 c4 10             	add    $0x10,%esp

  end_op();
80106216:	e8 9c d6 ff ff       	call   801038b7 <end_op>

  return 0;
8010621b:	b8 00 00 00 00       	mov    $0x0,%eax
80106220:	eb 48                	jmp    8010626a <sys_link+0x1a2>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
80106222:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
80106223:	83 ec 0c             	sub    $0xc,%esp
80106226:	ff 75 f4             	pushl  -0xc(%ebp)
80106229:	e8 28 b8 ff ff       	call   80101a56 <ilock>
8010622e:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80106231:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106234:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106238:	83 e8 01             	sub    $0x1,%eax
8010623b:	89 c2                	mov    %eax,%edx
8010623d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106240:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80106244:	83 ec 0c             	sub    $0xc,%esp
80106247:	ff 75 f4             	pushl  -0xc(%ebp)
8010624a:	e8 05 b6 ff ff       	call   80101854 <iupdate>
8010624f:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80106252:	83 ec 0c             	sub    $0xc,%esp
80106255:	ff 75 f4             	pushl  -0xc(%ebp)
80106258:	e8 e1 ba ff ff       	call   80101d3e <iunlockput>
8010625d:	83 c4 10             	add    $0x10,%esp
  end_op();
80106260:	e8 52 d6 ff ff       	call   801038b7 <end_op>
  return -1;
80106265:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010626a:	c9                   	leave  
8010626b:	c3                   	ret    

8010626c <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
8010626c:	55                   	push   %ebp
8010626d:	89 e5                	mov    %esp,%ebp
8010626f:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106272:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80106279:	eb 40                	jmp    801062bb <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010627b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010627e:	6a 10                	push   $0x10
80106280:	50                   	push   %eax
80106281:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106284:	50                   	push   %eax
80106285:	ff 75 08             	pushl  0x8(%ebp)
80106288:	e8 8b bd ff ff       	call   80102018 <readi>
8010628d:	83 c4 10             	add    $0x10,%esp
80106290:	83 f8 10             	cmp    $0x10,%eax
80106293:	74 0d                	je     801062a2 <isdirempty+0x36>
      panic("isdirempty: readi");
80106295:	83 ec 0c             	sub    $0xc,%esp
80106298:	68 bf 93 10 80       	push   $0x801093bf
8010629d:	e8 c4 a2 ff ff       	call   80100566 <panic>
    if(de.inum != 0)
801062a2:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801062a6:	66 85 c0             	test   %ax,%ax
801062a9:	74 07                	je     801062b2 <isdirempty+0x46>
      return 0;
801062ab:	b8 00 00 00 00       	mov    $0x0,%eax
801062b0:	eb 1b                	jmp    801062cd <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801062b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062b5:	83 c0 10             	add    $0x10,%eax
801062b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
801062bb:	8b 45 08             	mov    0x8(%ebp),%eax
801062be:	8b 50 20             	mov    0x20(%eax),%edx
801062c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062c4:	39 c2                	cmp    %eax,%edx
801062c6:	77 b3                	ja     8010627b <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
801062c8:	b8 01 00 00 00       	mov    $0x1,%eax
}
801062cd:	c9                   	leave  
801062ce:	c3                   	ret    

801062cf <sys_unlink>:

int
sys_unlink(void)
{
801062cf:	55                   	push   %ebp
801062d0:	89 e5                	mov    %esp,%ebp
801062d2:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801062d5:	83 ec 08             	sub    $0x8,%esp
801062d8:	8d 45 cc             	lea    -0x34(%ebp),%eax
801062db:	50                   	push   %eax
801062dc:	6a 00                	push   $0x0
801062de:	e8 a0 fa ff ff       	call   80105d83 <argstr>
801062e3:	83 c4 10             	add    $0x10,%esp
801062e6:	85 c0                	test   %eax,%eax
801062e8:	79 0a                	jns    801062f4 <sys_unlink+0x25>
    return -1;
801062ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062ef:	e9 bc 01 00 00       	jmp    801064b0 <sys_unlink+0x1e1>

  begin_op();
801062f4:	e8 32 d5 ff ff       	call   8010382b <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801062f9:	8b 45 cc             	mov    -0x34(%ebp),%eax
801062fc:	83 ec 08             	sub    $0x8,%esp
801062ff:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80106302:	52                   	push   %edx
80106303:	50                   	push   %eax
80106304:	e8 7b c3 ff ff       	call   80102684 <nameiparent>
80106309:	83 c4 10             	add    $0x10,%esp
8010630c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010630f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106313:	75 0f                	jne    80106324 <sys_unlink+0x55>
    end_op();
80106315:	e8 9d d5 ff ff       	call   801038b7 <end_op>
    return -1;
8010631a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010631f:	e9 8c 01 00 00       	jmp    801064b0 <sys_unlink+0x1e1>
  }

  ilock(dp);
80106324:	83 ec 0c             	sub    $0xc,%esp
80106327:	ff 75 f4             	pushl  -0xc(%ebp)
8010632a:	e8 27 b7 ff ff       	call   80101a56 <ilock>
8010632f:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80106332:	83 ec 08             	sub    $0x8,%esp
80106335:	68 d1 93 10 80       	push   $0x801093d1
8010633a:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010633d:	50                   	push   %eax
8010633e:	e8 b4 bf ff ff       	call   801022f7 <namecmp>
80106343:	83 c4 10             	add    $0x10,%esp
80106346:	85 c0                	test   %eax,%eax
80106348:	0f 84 4a 01 00 00    	je     80106498 <sys_unlink+0x1c9>
8010634e:	83 ec 08             	sub    $0x8,%esp
80106351:	68 d3 93 10 80       	push   $0x801093d3
80106356:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106359:	50                   	push   %eax
8010635a:	e8 98 bf ff ff       	call   801022f7 <namecmp>
8010635f:	83 c4 10             	add    $0x10,%esp
80106362:	85 c0                	test   %eax,%eax
80106364:	0f 84 2e 01 00 00    	je     80106498 <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010636a:	83 ec 04             	sub    $0x4,%esp
8010636d:	8d 45 c8             	lea    -0x38(%ebp),%eax
80106370:	50                   	push   %eax
80106371:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106374:	50                   	push   %eax
80106375:	ff 75 f4             	pushl  -0xc(%ebp)
80106378:	e8 95 bf ff ff       	call   80102312 <dirlookup>
8010637d:	83 c4 10             	add    $0x10,%esp
80106380:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106383:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106387:	0f 84 0a 01 00 00    	je     80106497 <sys_unlink+0x1c8>
    goto bad;
  ilock(ip);
8010638d:	83 ec 0c             	sub    $0xc,%esp
80106390:	ff 75 f0             	pushl  -0x10(%ebp)
80106393:	e8 be b6 ff ff       	call   80101a56 <ilock>
80106398:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
8010639b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010639e:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801063a2:	66 85 c0             	test   %ax,%ax
801063a5:	7f 0d                	jg     801063b4 <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
801063a7:	83 ec 0c             	sub    $0xc,%esp
801063aa:	68 d6 93 10 80       	push   $0x801093d6
801063af:	e8 b2 a1 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
801063b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063b7:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801063bb:	66 83 f8 01          	cmp    $0x1,%ax
801063bf:	75 25                	jne    801063e6 <sys_unlink+0x117>
801063c1:	83 ec 0c             	sub    $0xc,%esp
801063c4:	ff 75 f0             	pushl  -0x10(%ebp)
801063c7:	e8 a0 fe ff ff       	call   8010626c <isdirempty>
801063cc:	83 c4 10             	add    $0x10,%esp
801063cf:	85 c0                	test   %eax,%eax
801063d1:	75 13                	jne    801063e6 <sys_unlink+0x117>
    iunlockput(ip);
801063d3:	83 ec 0c             	sub    $0xc,%esp
801063d6:	ff 75 f0             	pushl  -0x10(%ebp)
801063d9:	e8 60 b9 ff ff       	call   80101d3e <iunlockput>
801063de:	83 c4 10             	add    $0x10,%esp
    goto bad;
801063e1:	e9 b2 00 00 00       	jmp    80106498 <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
801063e6:	83 ec 04             	sub    $0x4,%esp
801063e9:	6a 10                	push   $0x10
801063eb:	6a 00                	push   $0x0
801063ed:	8d 45 e0             	lea    -0x20(%ebp),%eax
801063f0:	50                   	push   %eax
801063f1:	e8 e3 f5 ff ff       	call   801059d9 <memset>
801063f6:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801063f9:	8b 45 c8             	mov    -0x38(%ebp),%eax
801063fc:	6a 10                	push   $0x10
801063fe:	50                   	push   %eax
801063ff:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106402:	50                   	push   %eax
80106403:	ff 75 f4             	pushl  -0xc(%ebp)
80106406:	e8 64 bd ff ff       	call   8010216f <writei>
8010640b:	83 c4 10             	add    $0x10,%esp
8010640e:	83 f8 10             	cmp    $0x10,%eax
80106411:	74 0d                	je     80106420 <sys_unlink+0x151>
    panic("unlink: writei");
80106413:	83 ec 0c             	sub    $0xc,%esp
80106416:	68 e8 93 10 80       	push   $0x801093e8
8010641b:	e8 46 a1 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR){
80106420:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106423:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106427:	66 83 f8 01          	cmp    $0x1,%ax
8010642b:	75 21                	jne    8010644e <sys_unlink+0x17f>
    dp->nlink--;
8010642d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106430:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106434:	83 e8 01             	sub    $0x1,%eax
80106437:	89 c2                	mov    %eax,%edx
80106439:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010643c:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80106440:	83 ec 0c             	sub    $0xc,%esp
80106443:	ff 75 f4             	pushl  -0xc(%ebp)
80106446:	e8 09 b4 ff ff       	call   80101854 <iupdate>
8010644b:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
8010644e:	83 ec 0c             	sub    $0xc,%esp
80106451:	ff 75 f4             	pushl  -0xc(%ebp)
80106454:	e8 e5 b8 ff ff       	call   80101d3e <iunlockput>
80106459:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
8010645c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010645f:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106463:	83 e8 01             	sub    $0x1,%eax
80106466:	89 c2                	mov    %eax,%edx
80106468:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010646b:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
8010646f:	83 ec 0c             	sub    $0xc,%esp
80106472:	ff 75 f0             	pushl  -0x10(%ebp)
80106475:	e8 da b3 ff ff       	call   80101854 <iupdate>
8010647a:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
8010647d:	83 ec 0c             	sub    $0xc,%esp
80106480:	ff 75 f0             	pushl  -0x10(%ebp)
80106483:	e8 b6 b8 ff ff       	call   80101d3e <iunlockput>
80106488:	83 c4 10             	add    $0x10,%esp

  end_op();
8010648b:	e8 27 d4 ff ff       	call   801038b7 <end_op>

  return 0;
80106490:	b8 00 00 00 00       	mov    $0x0,%eax
80106495:	eb 19                	jmp    801064b0 <sys_unlink+0x1e1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
80106497:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
80106498:	83 ec 0c             	sub    $0xc,%esp
8010649b:	ff 75 f4             	pushl  -0xc(%ebp)
8010649e:	e8 9b b8 ff ff       	call   80101d3e <iunlockput>
801064a3:	83 c4 10             	add    $0x10,%esp
  end_op();
801064a6:	e8 0c d4 ff ff       	call   801038b7 <end_op>
  return -1;
801064ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801064b0:	c9                   	leave  
801064b1:	c3                   	ret    

801064b2 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
801064b2:	55                   	push   %ebp
801064b3:	89 e5                	mov    %esp,%ebp
801064b5:	83 ec 38             	sub    $0x38,%esp
801064b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801064bb:	8b 55 10             	mov    0x10(%ebp),%edx
801064be:	8b 45 14             	mov    0x14(%ebp),%eax
801064c1:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
801064c5:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
801064c9:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801064cd:	83 ec 08             	sub    $0x8,%esp
801064d0:	8d 45 de             	lea    -0x22(%ebp),%eax
801064d3:	50                   	push   %eax
801064d4:	ff 75 08             	pushl  0x8(%ebp)
801064d7:	e8 a8 c1 ff ff       	call   80102684 <nameiparent>
801064dc:	83 c4 10             	add    $0x10,%esp
801064df:	89 45 f4             	mov    %eax,-0xc(%ebp)
801064e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064e6:	75 0a                	jne    801064f2 <create+0x40>
    return 0;
801064e8:	b8 00 00 00 00       	mov    $0x0,%eax
801064ed:	e9 90 01 00 00       	jmp    80106682 <create+0x1d0>
  ilock(dp);
801064f2:	83 ec 0c             	sub    $0xc,%esp
801064f5:	ff 75 f4             	pushl  -0xc(%ebp)
801064f8:	e8 59 b5 ff ff       	call   80101a56 <ilock>
801064fd:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
80106500:	83 ec 04             	sub    $0x4,%esp
80106503:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106506:	50                   	push   %eax
80106507:	8d 45 de             	lea    -0x22(%ebp),%eax
8010650a:	50                   	push   %eax
8010650b:	ff 75 f4             	pushl  -0xc(%ebp)
8010650e:	e8 ff bd ff ff       	call   80102312 <dirlookup>
80106513:	83 c4 10             	add    $0x10,%esp
80106516:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106519:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010651d:	74 50                	je     8010656f <create+0xbd>
    iunlockput(dp);
8010651f:	83 ec 0c             	sub    $0xc,%esp
80106522:	ff 75 f4             	pushl  -0xc(%ebp)
80106525:	e8 14 b8 ff ff       	call   80101d3e <iunlockput>
8010652a:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
8010652d:	83 ec 0c             	sub    $0xc,%esp
80106530:	ff 75 f0             	pushl  -0x10(%ebp)
80106533:	e8 1e b5 ff ff       	call   80101a56 <ilock>
80106538:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
8010653b:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80106540:	75 15                	jne    80106557 <create+0xa5>
80106542:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106545:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106549:	66 83 f8 02          	cmp    $0x2,%ax
8010654d:	75 08                	jne    80106557 <create+0xa5>
      return ip;
8010654f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106552:	e9 2b 01 00 00       	jmp    80106682 <create+0x1d0>
    iunlockput(ip);
80106557:	83 ec 0c             	sub    $0xc,%esp
8010655a:	ff 75 f0             	pushl  -0x10(%ebp)
8010655d:	e8 dc b7 ff ff       	call   80101d3e <iunlockput>
80106562:	83 c4 10             	add    $0x10,%esp
    return 0;
80106565:	b8 00 00 00 00       	mov    $0x0,%eax
8010656a:	e9 13 01 00 00       	jmp    80106682 <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
8010656f:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80106573:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106576:	8b 00                	mov    (%eax),%eax
80106578:	83 ec 08             	sub    $0x8,%esp
8010657b:	52                   	push   %edx
8010657c:	50                   	push   %eax
8010657d:	e8 df b1 ff ff       	call   80101761 <ialloc>
80106582:	83 c4 10             	add    $0x10,%esp
80106585:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106588:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010658c:	75 0d                	jne    8010659b <create+0xe9>
    panic("create: ialloc");
8010658e:	83 ec 0c             	sub    $0xc,%esp
80106591:	68 f7 93 10 80       	push   $0x801093f7
80106596:	e8 cb 9f ff ff       	call   80100566 <panic>

  ilock(ip);
8010659b:	83 ec 0c             	sub    $0xc,%esp
8010659e:	ff 75 f0             	pushl  -0x10(%ebp)
801065a1:	e8 b0 b4 ff ff       	call   80101a56 <ilock>
801065a6:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
801065a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065ac:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
801065b0:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
801065b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065b7:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
801065bb:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
801065bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065c2:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
801065c8:	83 ec 0c             	sub    $0xc,%esp
801065cb:	ff 75 f0             	pushl  -0x10(%ebp)
801065ce:	e8 81 b2 ff ff       	call   80101854 <iupdate>
801065d3:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
801065d6:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801065db:	75 6a                	jne    80106647 <create+0x195>
    dp->nlink++;  // for ".."
801065dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065e0:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801065e4:	83 c0 01             	add    $0x1,%eax
801065e7:	89 c2                	mov    %eax,%edx
801065e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065ec:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
801065f0:	83 ec 0c             	sub    $0xc,%esp
801065f3:	ff 75 f4             	pushl  -0xc(%ebp)
801065f6:	e8 59 b2 ff ff       	call   80101854 <iupdate>
801065fb:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801065fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106601:	8b 40 04             	mov    0x4(%eax),%eax
80106604:	83 ec 04             	sub    $0x4,%esp
80106607:	50                   	push   %eax
80106608:	68 d1 93 10 80       	push   $0x801093d1
8010660d:	ff 75 f0             	pushl  -0x10(%ebp)
80106610:	e8 b7 bd ff ff       	call   801023cc <dirlink>
80106615:	83 c4 10             	add    $0x10,%esp
80106618:	85 c0                	test   %eax,%eax
8010661a:	78 1e                	js     8010663a <create+0x188>
8010661c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010661f:	8b 40 04             	mov    0x4(%eax),%eax
80106622:	83 ec 04             	sub    $0x4,%esp
80106625:	50                   	push   %eax
80106626:	68 d3 93 10 80       	push   $0x801093d3
8010662b:	ff 75 f0             	pushl  -0x10(%ebp)
8010662e:	e8 99 bd ff ff       	call   801023cc <dirlink>
80106633:	83 c4 10             	add    $0x10,%esp
80106636:	85 c0                	test   %eax,%eax
80106638:	79 0d                	jns    80106647 <create+0x195>
      panic("create dots");
8010663a:	83 ec 0c             	sub    $0xc,%esp
8010663d:	68 06 94 10 80       	push   $0x80109406
80106642:	e8 1f 9f ff ff       	call   80100566 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80106647:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010664a:	8b 40 04             	mov    0x4(%eax),%eax
8010664d:	83 ec 04             	sub    $0x4,%esp
80106650:	50                   	push   %eax
80106651:	8d 45 de             	lea    -0x22(%ebp),%eax
80106654:	50                   	push   %eax
80106655:	ff 75 f4             	pushl  -0xc(%ebp)
80106658:	e8 6f bd ff ff       	call   801023cc <dirlink>
8010665d:	83 c4 10             	add    $0x10,%esp
80106660:	85 c0                	test   %eax,%eax
80106662:	79 0d                	jns    80106671 <create+0x1bf>
    panic("create: dirlink");
80106664:	83 ec 0c             	sub    $0xc,%esp
80106667:	68 12 94 10 80       	push   $0x80109412
8010666c:	e8 f5 9e ff ff       	call   80100566 <panic>

  iunlockput(dp);
80106671:	83 ec 0c             	sub    $0xc,%esp
80106674:	ff 75 f4             	pushl  -0xc(%ebp)
80106677:	e8 c2 b6 ff ff       	call   80101d3e <iunlockput>
8010667c:	83 c4 10             	add    $0x10,%esp

  return ip;
8010667f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80106682:	c9                   	leave  
80106683:	c3                   	ret    

80106684 <sys_open>:

int
sys_open(void)
{
80106684:	55                   	push   %ebp
80106685:	89 e5                	mov    %esp,%ebp
80106687:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010668a:	83 ec 08             	sub    $0x8,%esp
8010668d:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106690:	50                   	push   %eax
80106691:	6a 00                	push   $0x0
80106693:	e8 eb f6 ff ff       	call   80105d83 <argstr>
80106698:	83 c4 10             	add    $0x10,%esp
8010669b:	85 c0                	test   %eax,%eax
8010669d:	78 15                	js     801066b4 <sys_open+0x30>
8010669f:	83 ec 08             	sub    $0x8,%esp
801066a2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801066a5:	50                   	push   %eax
801066a6:	6a 01                	push   $0x1
801066a8:	e8 51 f6 ff ff       	call   80105cfe <argint>
801066ad:	83 c4 10             	add    $0x10,%esp
801066b0:	85 c0                	test   %eax,%eax
801066b2:	79 0a                	jns    801066be <sys_open+0x3a>
    return -1;
801066b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066b9:	e9 61 01 00 00       	jmp    8010681f <sys_open+0x19b>

  begin_op();
801066be:	e8 68 d1 ff ff       	call   8010382b <begin_op>

  if(omode & O_CREATE){
801066c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801066c6:	25 00 02 00 00       	and    $0x200,%eax
801066cb:	85 c0                	test   %eax,%eax
801066cd:	74 2a                	je     801066f9 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
801066cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
801066d2:	6a 00                	push   $0x0
801066d4:	6a 00                	push   $0x0
801066d6:	6a 02                	push   $0x2
801066d8:	50                   	push   %eax
801066d9:	e8 d4 fd ff ff       	call   801064b2 <create>
801066de:	83 c4 10             	add    $0x10,%esp
801066e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
801066e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801066e8:	75 75                	jne    8010675f <sys_open+0xdb>
      end_op();
801066ea:	e8 c8 d1 ff ff       	call   801038b7 <end_op>
      return -1;
801066ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066f4:	e9 26 01 00 00       	jmp    8010681f <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
801066f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
801066fc:	83 ec 0c             	sub    $0xc,%esp
801066ff:	50                   	push   %eax
80106700:	e8 63 bf ff ff       	call   80102668 <namei>
80106705:	83 c4 10             	add    $0x10,%esp
80106708:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010670b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010670f:	75 0f                	jne    80106720 <sys_open+0x9c>
      end_op();
80106711:	e8 a1 d1 ff ff       	call   801038b7 <end_op>
      return -1;
80106716:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010671b:	e9 ff 00 00 00       	jmp    8010681f <sys_open+0x19b>
    }
    ilock(ip);
80106720:	83 ec 0c             	sub    $0xc,%esp
80106723:	ff 75 f4             	pushl  -0xc(%ebp)
80106726:	e8 2b b3 ff ff       	call   80101a56 <ilock>
8010672b:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
8010672e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106731:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106735:	66 83 f8 01          	cmp    $0x1,%ax
80106739:	75 24                	jne    8010675f <sys_open+0xdb>
8010673b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010673e:	85 c0                	test   %eax,%eax
80106740:	74 1d                	je     8010675f <sys_open+0xdb>
      iunlockput(ip);
80106742:	83 ec 0c             	sub    $0xc,%esp
80106745:	ff 75 f4             	pushl  -0xc(%ebp)
80106748:	e8 f1 b5 ff ff       	call   80101d3e <iunlockput>
8010674d:	83 c4 10             	add    $0x10,%esp
      end_op();
80106750:	e8 62 d1 ff ff       	call   801038b7 <end_op>
      return -1;
80106755:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010675a:	e9 c0 00 00 00       	jmp    8010681f <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010675f:	e8 d7 a8 ff ff       	call   8010103b <filealloc>
80106764:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106767:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010676b:	74 17                	je     80106784 <sys_open+0x100>
8010676d:	83 ec 0c             	sub    $0xc,%esp
80106770:	ff 75 f0             	pushl  -0x10(%ebp)
80106773:	e8 37 f7 ff ff       	call   80105eaf <fdalloc>
80106778:	83 c4 10             	add    $0x10,%esp
8010677b:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010677e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80106782:	79 2e                	jns    801067b2 <sys_open+0x12e>
    if(f)
80106784:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106788:	74 0e                	je     80106798 <sys_open+0x114>
      fileclose(f);
8010678a:	83 ec 0c             	sub    $0xc,%esp
8010678d:	ff 75 f0             	pushl  -0x10(%ebp)
80106790:	e8 64 a9 ff ff       	call   801010f9 <fileclose>
80106795:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80106798:	83 ec 0c             	sub    $0xc,%esp
8010679b:	ff 75 f4             	pushl  -0xc(%ebp)
8010679e:	e8 9b b5 ff ff       	call   80101d3e <iunlockput>
801067a3:	83 c4 10             	add    $0x10,%esp
    end_op();
801067a6:	e8 0c d1 ff ff       	call   801038b7 <end_op>
    return -1;
801067ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067b0:	eb 6d                	jmp    8010681f <sys_open+0x19b>
  }
  iunlock(ip);
801067b2:	83 ec 0c             	sub    $0xc,%esp
801067b5:	ff 75 f4             	pushl  -0xc(%ebp)
801067b8:	e8 1f b4 ff ff       	call   80101bdc <iunlock>
801067bd:	83 c4 10             	add    $0x10,%esp
  end_op();
801067c0:	e8 f2 d0 ff ff       	call   801038b7 <end_op>

  f->type = FD_INODE;
801067c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801067c8:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
801067ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801067d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801067d4:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
801067d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801067da:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
801067e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801067e4:	83 e0 01             	and    $0x1,%eax
801067e7:	85 c0                	test   %eax,%eax
801067e9:	0f 94 c0             	sete   %al
801067ec:	89 c2                	mov    %eax,%edx
801067ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801067f1:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801067f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801067f7:	83 e0 01             	and    $0x1,%eax
801067fa:	85 c0                	test   %eax,%eax
801067fc:	75 0a                	jne    80106808 <sys_open+0x184>
801067fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106801:	83 e0 02             	and    $0x2,%eax
80106804:	85 c0                	test   %eax,%eax
80106806:	74 07                	je     8010680f <sys_open+0x18b>
80106808:	b8 01 00 00 00       	mov    $0x1,%eax
8010680d:	eb 05                	jmp    80106814 <sys_open+0x190>
8010680f:	b8 00 00 00 00       	mov    $0x0,%eax
80106814:	89 c2                	mov    %eax,%edx
80106816:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106819:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
8010681c:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
8010681f:	c9                   	leave  
80106820:	c3                   	ret    

80106821 <sys_mkdir>:

int
sys_mkdir(void)
{
80106821:	55                   	push   %ebp
80106822:	89 e5                	mov    %esp,%ebp
80106824:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106827:	e8 ff cf ff ff       	call   8010382b <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010682c:	83 ec 08             	sub    $0x8,%esp
8010682f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106832:	50                   	push   %eax
80106833:	6a 00                	push   $0x0
80106835:	e8 49 f5 ff ff       	call   80105d83 <argstr>
8010683a:	83 c4 10             	add    $0x10,%esp
8010683d:	85 c0                	test   %eax,%eax
8010683f:	78 1b                	js     8010685c <sys_mkdir+0x3b>
80106841:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106844:	6a 00                	push   $0x0
80106846:	6a 00                	push   $0x0
80106848:	6a 01                	push   $0x1
8010684a:	50                   	push   %eax
8010684b:	e8 62 fc ff ff       	call   801064b2 <create>
80106850:	83 c4 10             	add    $0x10,%esp
80106853:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106856:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010685a:	75 0c                	jne    80106868 <sys_mkdir+0x47>
    end_op();
8010685c:	e8 56 d0 ff ff       	call   801038b7 <end_op>
    return -1;
80106861:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106866:	eb 18                	jmp    80106880 <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80106868:	83 ec 0c             	sub    $0xc,%esp
8010686b:	ff 75 f4             	pushl  -0xc(%ebp)
8010686e:	e8 cb b4 ff ff       	call   80101d3e <iunlockput>
80106873:	83 c4 10             	add    $0x10,%esp
  end_op();
80106876:	e8 3c d0 ff ff       	call   801038b7 <end_op>
  return 0;
8010687b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106880:	c9                   	leave  
80106881:	c3                   	ret    

80106882 <sys_mknod>:

int
sys_mknod(void)
{
80106882:	55                   	push   %ebp
80106883:	89 e5                	mov    %esp,%ebp
80106885:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
80106888:	e8 9e cf ff ff       	call   8010382b <begin_op>
  if((len=argstr(0, &path)) < 0 ||
8010688d:	83 ec 08             	sub    $0x8,%esp
80106890:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106893:	50                   	push   %eax
80106894:	6a 00                	push   $0x0
80106896:	e8 e8 f4 ff ff       	call   80105d83 <argstr>
8010689b:	83 c4 10             	add    $0x10,%esp
8010689e:	89 45 f4             	mov    %eax,-0xc(%ebp)
801068a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801068a5:	78 4f                	js     801068f6 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
801068a7:	83 ec 08             	sub    $0x8,%esp
801068aa:	8d 45 e8             	lea    -0x18(%ebp),%eax
801068ad:	50                   	push   %eax
801068ae:	6a 01                	push   $0x1
801068b0:	e8 49 f4 ff ff       	call   80105cfe <argint>
801068b5:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
801068b8:	85 c0                	test   %eax,%eax
801068ba:	78 3a                	js     801068f6 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801068bc:	83 ec 08             	sub    $0x8,%esp
801068bf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801068c2:	50                   	push   %eax
801068c3:	6a 02                	push   $0x2
801068c5:	e8 34 f4 ff ff       	call   80105cfe <argint>
801068ca:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
801068cd:	85 c0                	test   %eax,%eax
801068cf:	78 25                	js     801068f6 <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
801068d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801068d4:	0f bf c8             	movswl %ax,%ecx
801068d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801068da:	0f bf d0             	movswl %ax,%edx
801068dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801068e0:	51                   	push   %ecx
801068e1:	52                   	push   %edx
801068e2:	6a 03                	push   $0x3
801068e4:	50                   	push   %eax
801068e5:	e8 c8 fb ff ff       	call   801064b2 <create>
801068ea:	83 c4 10             	add    $0x10,%esp
801068ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
801068f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801068f4:	75 0c                	jne    80106902 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801068f6:	e8 bc cf ff ff       	call   801038b7 <end_op>
    return -1;
801068fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106900:	eb 18                	jmp    8010691a <sys_mknod+0x98>
  }
  iunlockput(ip);
80106902:	83 ec 0c             	sub    $0xc,%esp
80106905:	ff 75 f0             	pushl  -0x10(%ebp)
80106908:	e8 31 b4 ff ff       	call   80101d3e <iunlockput>
8010690d:	83 c4 10             	add    $0x10,%esp
  end_op();
80106910:	e8 a2 cf ff ff       	call   801038b7 <end_op>
  return 0;
80106915:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010691a:	c9                   	leave  
8010691b:	c3                   	ret    

8010691c <sys_chdir>:

int
sys_chdir(void)
{
8010691c:	55                   	push   %ebp
8010691d:	89 e5                	mov    %esp,%ebp
8010691f:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106922:	e8 04 cf ff ff       	call   8010382b <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106927:	83 ec 08             	sub    $0x8,%esp
8010692a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010692d:	50                   	push   %eax
8010692e:	6a 00                	push   $0x0
80106930:	e8 4e f4 ff ff       	call   80105d83 <argstr>
80106935:	83 c4 10             	add    $0x10,%esp
80106938:	85 c0                	test   %eax,%eax
8010693a:	78 18                	js     80106954 <sys_chdir+0x38>
8010693c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010693f:	83 ec 0c             	sub    $0xc,%esp
80106942:	50                   	push   %eax
80106943:	e8 20 bd ff ff       	call   80102668 <namei>
80106948:	83 c4 10             	add    $0x10,%esp
8010694b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010694e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106952:	75 0c                	jne    80106960 <sys_chdir+0x44>
    end_op();
80106954:	e8 5e cf ff ff       	call   801038b7 <end_op>
    return -1;
80106959:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010695e:	eb 6e                	jmp    801069ce <sys_chdir+0xb2>
  }
  ilock(ip);
80106960:	83 ec 0c             	sub    $0xc,%esp
80106963:	ff 75 f4             	pushl  -0xc(%ebp)
80106966:	e8 eb b0 ff ff       	call   80101a56 <ilock>
8010696b:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
8010696e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106971:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106975:	66 83 f8 01          	cmp    $0x1,%ax
80106979:	74 1a                	je     80106995 <sys_chdir+0x79>
    iunlockput(ip);
8010697b:	83 ec 0c             	sub    $0xc,%esp
8010697e:	ff 75 f4             	pushl  -0xc(%ebp)
80106981:	e8 b8 b3 ff ff       	call   80101d3e <iunlockput>
80106986:	83 c4 10             	add    $0x10,%esp
    end_op();
80106989:	e8 29 cf ff ff       	call   801038b7 <end_op>
    return -1;
8010698e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106993:	eb 39                	jmp    801069ce <sys_chdir+0xb2>
  }
  iunlock(ip);
80106995:	83 ec 0c             	sub    $0xc,%esp
80106998:	ff 75 f4             	pushl  -0xc(%ebp)
8010699b:	e8 3c b2 ff ff       	call   80101bdc <iunlock>
801069a0:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
801069a3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069a9:	8b 40 68             	mov    0x68(%eax),%eax
801069ac:	83 ec 0c             	sub    $0xc,%esp
801069af:	50                   	push   %eax
801069b0:	e8 99 b2 ff ff       	call   80101c4e <iput>
801069b5:	83 c4 10             	add    $0x10,%esp
  end_op();
801069b8:	e8 fa ce ff ff       	call   801038b7 <end_op>
  proc->cwd = ip;
801069bd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801069c6:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
801069c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801069ce:	c9                   	leave  
801069cf:	c3                   	ret    

801069d0 <sys_exec>:

int
sys_exec(void)
{
801069d0:	55                   	push   %ebp
801069d1:	89 e5                	mov    %esp,%ebp
801069d3:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801069d9:	83 ec 08             	sub    $0x8,%esp
801069dc:	8d 45 f0             	lea    -0x10(%ebp),%eax
801069df:	50                   	push   %eax
801069e0:	6a 00                	push   $0x0
801069e2:	e8 9c f3 ff ff       	call   80105d83 <argstr>
801069e7:	83 c4 10             	add    $0x10,%esp
801069ea:	85 c0                	test   %eax,%eax
801069ec:	78 18                	js     80106a06 <sys_exec+0x36>
801069ee:	83 ec 08             	sub    $0x8,%esp
801069f1:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
801069f7:	50                   	push   %eax
801069f8:	6a 01                	push   $0x1
801069fa:	e8 ff f2 ff ff       	call   80105cfe <argint>
801069ff:	83 c4 10             	add    $0x10,%esp
80106a02:	85 c0                	test   %eax,%eax
80106a04:	79 0a                	jns    80106a10 <sys_exec+0x40>
    return -1;
80106a06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a0b:	e9 c6 00 00 00       	jmp    80106ad6 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80106a10:	83 ec 04             	sub    $0x4,%esp
80106a13:	68 80 00 00 00       	push   $0x80
80106a18:	6a 00                	push   $0x0
80106a1a:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106a20:	50                   	push   %eax
80106a21:	e8 b3 ef ff ff       	call   801059d9 <memset>
80106a26:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80106a29:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80106a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a33:	83 f8 1f             	cmp    $0x1f,%eax
80106a36:	76 0a                	jbe    80106a42 <sys_exec+0x72>
      return -1;
80106a38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a3d:	e9 94 00 00 00       	jmp    80106ad6 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a45:	c1 e0 02             	shl    $0x2,%eax
80106a48:	89 c2                	mov    %eax,%edx
80106a4a:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80106a50:	01 c2                	add    %eax,%edx
80106a52:	83 ec 08             	sub    $0x8,%esp
80106a55:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106a5b:	50                   	push   %eax
80106a5c:	52                   	push   %edx
80106a5d:	e8 00 f2 ff ff       	call   80105c62 <fetchint>
80106a62:	83 c4 10             	add    $0x10,%esp
80106a65:	85 c0                	test   %eax,%eax
80106a67:	79 07                	jns    80106a70 <sys_exec+0xa0>
      return -1;
80106a69:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a6e:	eb 66                	jmp    80106ad6 <sys_exec+0x106>
    if(uarg == 0){
80106a70:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106a76:	85 c0                	test   %eax,%eax
80106a78:	75 27                	jne    80106aa1 <sys_exec+0xd1>
      argv[i] = 0;
80106a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a7d:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80106a84:	00 00 00 00 
      break;
80106a88:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106a89:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a8c:	83 ec 08             	sub    $0x8,%esp
80106a8f:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80106a95:	52                   	push   %edx
80106a96:	50                   	push   %eax
80106a97:	e8 d5 a0 ff ff       	call   80100b71 <exec>
80106a9c:	83 c4 10             	add    $0x10,%esp
80106a9f:	eb 35                	jmp    80106ad6 <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106aa1:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106aa7:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106aaa:	c1 e2 02             	shl    $0x2,%edx
80106aad:	01 c2                	add    %eax,%edx
80106aaf:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106ab5:	83 ec 08             	sub    $0x8,%esp
80106ab8:	52                   	push   %edx
80106ab9:	50                   	push   %eax
80106aba:	e8 dd f1 ff ff       	call   80105c9c <fetchstr>
80106abf:	83 c4 10             	add    $0x10,%esp
80106ac2:	85 c0                	test   %eax,%eax
80106ac4:	79 07                	jns    80106acd <sys_exec+0xfd>
      return -1;
80106ac6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106acb:	eb 09                	jmp    80106ad6 <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106acd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80106ad1:	e9 5a ff ff ff       	jmp    80106a30 <sys_exec+0x60>
  return exec(path, argv);
}
80106ad6:	c9                   	leave  
80106ad7:	c3                   	ret    

80106ad8 <sys_pipe>:

int
sys_pipe(void)
{
80106ad8:	55                   	push   %ebp
80106ad9:	89 e5                	mov    %esp,%ebp
80106adb:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106ade:	83 ec 04             	sub    $0x4,%esp
80106ae1:	6a 08                	push   $0x8
80106ae3:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106ae6:	50                   	push   %eax
80106ae7:	6a 00                	push   $0x0
80106ae9:	e8 38 f2 ff ff       	call   80105d26 <argptr>
80106aee:	83 c4 10             	add    $0x10,%esp
80106af1:	85 c0                	test   %eax,%eax
80106af3:	79 0a                	jns    80106aff <sys_pipe+0x27>
    return -1;
80106af5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106afa:	e9 af 00 00 00       	jmp    80106bae <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
80106aff:	83 ec 08             	sub    $0x8,%esp
80106b02:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106b05:	50                   	push   %eax
80106b06:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106b09:	50                   	push   %eax
80106b0a:	e8 10 d8 ff ff       	call   8010431f <pipealloc>
80106b0f:	83 c4 10             	add    $0x10,%esp
80106b12:	85 c0                	test   %eax,%eax
80106b14:	79 0a                	jns    80106b20 <sys_pipe+0x48>
    return -1;
80106b16:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b1b:	e9 8e 00 00 00       	jmp    80106bae <sys_pipe+0xd6>
  fd0 = -1;
80106b20:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106b27:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106b2a:	83 ec 0c             	sub    $0xc,%esp
80106b2d:	50                   	push   %eax
80106b2e:	e8 7c f3 ff ff       	call   80105eaf <fdalloc>
80106b33:	83 c4 10             	add    $0x10,%esp
80106b36:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106b39:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106b3d:	78 18                	js     80106b57 <sys_pipe+0x7f>
80106b3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b42:	83 ec 0c             	sub    $0xc,%esp
80106b45:	50                   	push   %eax
80106b46:	e8 64 f3 ff ff       	call   80105eaf <fdalloc>
80106b4b:	83 c4 10             	add    $0x10,%esp
80106b4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106b51:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106b55:	79 3f                	jns    80106b96 <sys_pipe+0xbe>
    if(fd0 >= 0)
80106b57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106b5b:	78 14                	js     80106b71 <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
80106b5d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b63:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106b66:	83 c2 08             	add    $0x8,%edx
80106b69:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106b70:	00 
    fileclose(rf);
80106b71:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106b74:	83 ec 0c             	sub    $0xc,%esp
80106b77:	50                   	push   %eax
80106b78:	e8 7c a5 ff ff       	call   801010f9 <fileclose>
80106b7d:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80106b80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b83:	83 ec 0c             	sub    $0xc,%esp
80106b86:	50                   	push   %eax
80106b87:	e8 6d a5 ff ff       	call   801010f9 <fileclose>
80106b8c:	83 c4 10             	add    $0x10,%esp
    return -1;
80106b8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b94:	eb 18                	jmp    80106bae <sys_pipe+0xd6>
  }
  fd[0] = fd0;
80106b96:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106b99:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106b9c:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80106b9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106ba1:	8d 50 04             	lea    0x4(%eax),%edx
80106ba4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106ba7:	89 02                	mov    %eax,(%edx)
  return 0;
80106ba9:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106bae:	c9                   	leave  
80106baf:	c3                   	ret    

80106bb0 <sys_chmod>:

#ifdef CS333_P5
int
sys_chmod(void)
{
80106bb0:	55                   	push   %ebp
80106bb1:	89 e5                	mov    %esp,%ebp
80106bb3:	83 ec 18             	sub    $0x18,%esp
  char *n;
  int m;

  if(argstr(0, &n) < 0)
80106bb6:	83 ec 08             	sub    $0x8,%esp
80106bb9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106bbc:	50                   	push   %eax
80106bbd:	6a 00                	push   $0x0
80106bbf:	e8 bf f1 ff ff       	call   80105d83 <argstr>
80106bc4:	83 c4 10             	add    $0x10,%esp
80106bc7:	85 c0                	test   %eax,%eax
80106bc9:	79 07                	jns    80106bd2 <sys_chmod+0x22>
    return -1;
80106bcb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bd0:	eb 2f                	jmp    80106c01 <sys_chmod+0x51>
  if(argint(1, &m) < 0)
80106bd2:	83 ec 08             	sub    $0x8,%esp
80106bd5:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106bd8:	50                   	push   %eax
80106bd9:	6a 01                	push   $0x1
80106bdb:	e8 1e f1 ff ff       	call   80105cfe <argint>
80106be0:	83 c4 10             	add    $0x10,%esp
80106be3:	85 c0                	test   %eax,%eax
80106be5:	79 07                	jns    80106bee <sys_chmod+0x3e>
    return -1;
80106be7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bec:	eb 13                	jmp    80106c01 <sys_chmod+0x51>

  return chmod(n, m);
80106bee:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bf4:	83 ec 08             	sub    $0x8,%esp
80106bf7:	52                   	push   %edx
80106bf8:	50                   	push   %eax
80106bf9:	e8 a1 ba ff ff       	call   8010269f <chmod>
80106bfe:	83 c4 10             	add    $0x10,%esp
}
80106c01:	c9                   	leave  
80106c02:	c3                   	ret    

80106c03 <sys_chown>:

int
sys_chown(void)
{
80106c03:	55                   	push   %ebp
80106c04:	89 e5                	mov    %esp,%ebp
80106c06:	83 ec 18             	sub    $0x18,%esp
  char *n;
  int m;

  if(argstr(0, &n) < 0)
80106c09:	83 ec 08             	sub    $0x8,%esp
80106c0c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106c0f:	50                   	push   %eax
80106c10:	6a 00                	push   $0x0
80106c12:	e8 6c f1 ff ff       	call   80105d83 <argstr>
80106c17:	83 c4 10             	add    $0x10,%esp
80106c1a:	85 c0                	test   %eax,%eax
80106c1c:	79 07                	jns    80106c25 <sys_chown+0x22>
    return -1;
80106c1e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c23:	eb 2f                	jmp    80106c54 <sys_chown+0x51>
  if(argint(1, &m) < 0)
80106c25:	83 ec 08             	sub    $0x8,%esp
80106c28:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106c2b:	50                   	push   %eax
80106c2c:	6a 01                	push   $0x1
80106c2e:	e8 cb f0 ff ff       	call   80105cfe <argint>
80106c33:	83 c4 10             	add    $0x10,%esp
80106c36:	85 c0                	test   %eax,%eax
80106c38:	79 07                	jns    80106c41 <sys_chown+0x3e>
    return -1;
80106c3a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c3f:	eb 13                	jmp    80106c54 <sys_chown+0x51>

  return chown(n, m);
80106c41:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c47:	83 ec 08             	sub    $0x8,%esp
80106c4a:	52                   	push   %edx
80106c4b:	50                   	push   %eax
80106c4c:	e8 d6 ba ff ff       	call   80102727 <chown>
80106c51:	83 c4 10             	add    $0x10,%esp
}
80106c54:	c9                   	leave  
80106c55:	c3                   	ret    

80106c56 <sys_chgrp>:

int
sys_chgrp(void)
{
80106c56:	55                   	push   %ebp
80106c57:	89 e5                	mov    %esp,%ebp
80106c59:	83 ec 18             	sub    $0x18,%esp
  char *n;
  int m;

  if(argstr(0, &n) < 0)
80106c5c:	83 ec 08             	sub    $0x8,%esp
80106c5f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106c62:	50                   	push   %eax
80106c63:	6a 00                	push   $0x0
80106c65:	e8 19 f1 ff ff       	call   80105d83 <argstr>
80106c6a:	83 c4 10             	add    $0x10,%esp
80106c6d:	85 c0                	test   %eax,%eax
80106c6f:	79 07                	jns    80106c78 <sys_chgrp+0x22>
    return -1;
80106c71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c76:	eb 2f                	jmp    80106ca7 <sys_chgrp+0x51>
  if(argint(1, &m) < 0)
80106c78:	83 ec 08             	sub    $0x8,%esp
80106c7b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106c7e:	50                   	push   %eax
80106c7f:	6a 01                	push   $0x1
80106c81:	e8 78 f0 ff ff       	call   80105cfe <argint>
80106c86:	83 c4 10             	add    $0x10,%esp
80106c89:	85 c0                	test   %eax,%eax
80106c8b:	79 07                	jns    80106c94 <sys_chgrp+0x3e>
    return -1;
80106c8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c92:	eb 13                	jmp    80106ca7 <sys_chgrp+0x51>

  return chgrp(n, m);
80106c94:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c9a:	83 ec 08             	sub    $0x8,%esp
80106c9d:	52                   	push   %edx
80106c9e:	50                   	push   %eax
80106c9f:	e8 0e bb ff ff       	call   801027b2 <chgrp>
80106ca4:	83 c4 10             	add    $0x10,%esp
}
80106ca7:	c9                   	leave  
80106ca8:	c3                   	ret    

80106ca9 <outw>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outw(ushort port, ushort data)
{
80106ca9:	55                   	push   %ebp
80106caa:	89 e5                	mov    %esp,%ebp
80106cac:	83 ec 08             	sub    $0x8,%esp
80106caf:	8b 55 08             	mov    0x8(%ebp),%edx
80106cb2:	8b 45 0c             	mov    0xc(%ebp),%eax
80106cb5:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106cb9:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106cbd:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
80106cc1:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106cc5:	66 ef                	out    %ax,(%dx)
}
80106cc7:	90                   	nop
80106cc8:	c9                   	leave  
80106cc9:	c3                   	ret    

80106cca <sys_fork>:
#include "uproc.h"
#endif

int
sys_fork(void)
{
80106cca:	55                   	push   %ebp
80106ccb:	89 e5                	mov    %esp,%ebp
80106ccd:	83 ec 08             	sub    $0x8,%esp
  return fork();
80106cd0:	e8 8f dd ff ff       	call   80104a64 <fork>
}
80106cd5:	c9                   	leave  
80106cd6:	c3                   	ret    

80106cd7 <sys_exit>:

int
sys_exit(void)
{
80106cd7:	55                   	push   %ebp
80106cd8:	89 e5                	mov    %esp,%ebp
80106cda:	83 ec 08             	sub    $0x8,%esp
  exit();
80106cdd:	e8 3d df ff ff       	call   80104c1f <exit>
  return 0;  // not reached
80106ce2:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106ce7:	c9                   	leave  
80106ce8:	c3                   	ret    

80106ce9 <sys_wait>:

int
sys_wait(void)
{
80106ce9:	55                   	push   %ebp
80106cea:	89 e5                	mov    %esp,%ebp
80106cec:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106cef:	e8 66 e0 ff ff       	call   80104d5a <wait>
}
80106cf4:	c9                   	leave  
80106cf5:	c3                   	ret    

80106cf6 <sys_kill>:

int
sys_kill(void)
{
80106cf6:	55                   	push   %ebp
80106cf7:	89 e5                	mov    %esp,%ebp
80106cf9:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106cfc:	83 ec 08             	sub    $0x8,%esp
80106cff:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106d02:	50                   	push   %eax
80106d03:	6a 00                	push   $0x0
80106d05:	e8 f4 ef ff ff       	call   80105cfe <argint>
80106d0a:	83 c4 10             	add    $0x10,%esp
80106d0d:	85 c0                	test   %eax,%eax
80106d0f:	79 07                	jns    80106d18 <sys_kill+0x22>
    return -1;
80106d11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d16:	eb 0f                	jmp    80106d27 <sys_kill+0x31>
  return kill(pid);
80106d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d1b:	83 ec 0c             	sub    $0xc,%esp
80106d1e:	50                   	push   %eax
80106d1f:	e8 cb e4 ff ff       	call   801051ef <kill>
80106d24:	83 c4 10             	add    $0x10,%esp
}
80106d27:	c9                   	leave  
80106d28:	c3                   	ret    

80106d29 <sys_getpid>:

int
sys_getpid(void)
{
80106d29:	55                   	push   %ebp
80106d2a:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80106d2c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d32:	8b 40 10             	mov    0x10(%eax),%eax
}
80106d35:	5d                   	pop    %ebp
80106d36:	c3                   	ret    

80106d37 <sys_sbrk>:

int
sys_sbrk(void)
{
80106d37:	55                   	push   %ebp
80106d38:	89 e5                	mov    %esp,%ebp
80106d3a:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106d3d:	83 ec 08             	sub    $0x8,%esp
80106d40:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106d43:	50                   	push   %eax
80106d44:	6a 00                	push   $0x0
80106d46:	e8 b3 ef ff ff       	call   80105cfe <argint>
80106d4b:	83 c4 10             	add    $0x10,%esp
80106d4e:	85 c0                	test   %eax,%eax
80106d50:	79 07                	jns    80106d59 <sys_sbrk+0x22>
    return -1;
80106d52:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d57:	eb 28                	jmp    80106d81 <sys_sbrk+0x4a>
  addr = proc->sz;
80106d59:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d5f:	8b 00                	mov    (%eax),%eax
80106d61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106d64:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106d67:	83 ec 0c             	sub    $0xc,%esp
80106d6a:	50                   	push   %eax
80106d6b:	e8 51 dc ff ff       	call   801049c1 <growproc>
80106d70:	83 c4 10             	add    $0x10,%esp
80106d73:	85 c0                	test   %eax,%eax
80106d75:	79 07                	jns    80106d7e <sys_sbrk+0x47>
    return -1;
80106d77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d7c:	eb 03                	jmp    80106d81 <sys_sbrk+0x4a>
  return addr;
80106d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106d81:	c9                   	leave  
80106d82:	c3                   	ret    

80106d83 <sys_sleep>:

int
sys_sleep(void)
{
80106d83:	55                   	push   %ebp
80106d84:	89 e5                	mov    %esp,%ebp
80106d86:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80106d89:	83 ec 08             	sub    $0x8,%esp
80106d8c:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106d8f:	50                   	push   %eax
80106d90:	6a 00                	push   $0x0
80106d92:	e8 67 ef ff ff       	call   80105cfe <argint>
80106d97:	83 c4 10             	add    $0x10,%esp
80106d9a:	85 c0                	test   %eax,%eax
80106d9c:	79 07                	jns    80106da5 <sys_sleep+0x22>
    return -1;
80106d9e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106da3:	eb 44                	jmp    80106de9 <sys_sleep+0x66>
  ticks0 = ticks;
80106da5:	a1 e0 65 11 80       	mov    0x801165e0,%eax
80106daa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106dad:	eb 26                	jmp    80106dd5 <sys_sleep+0x52>
    if(proc->killed){
80106daf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106db5:	8b 40 24             	mov    0x24(%eax),%eax
80106db8:	85 c0                	test   %eax,%eax
80106dba:	74 07                	je     80106dc3 <sys_sleep+0x40>
      return -1;
80106dbc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106dc1:	eb 26                	jmp    80106de9 <sys_sleep+0x66>
    }
    sleep(&ticks, (struct spinlock *)0);
80106dc3:	83 ec 08             	sub    $0x8,%esp
80106dc6:	6a 00                	push   $0x0
80106dc8:	68 e0 65 11 80       	push   $0x801165e0
80106dcd:	e8 ff e2 ff ff       	call   801050d1 <sleep>
80106dd2:	83 c4 10             	add    $0x10,%esp
  uint ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106dd5:	a1 e0 65 11 80       	mov    0x801165e0,%eax
80106dda:	2b 45 f4             	sub    -0xc(%ebp),%eax
80106ddd:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106de0:	39 d0                	cmp    %edx,%eax
80106de2:	72 cb                	jb     80106daf <sys_sleep+0x2c>
    if(proc->killed){
      return -1;
    }
    sleep(&ticks, (struct spinlock *)0);
  }
  return 0;
80106de4:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106de9:	c9                   	leave  
80106dea:	c3                   	ret    

80106deb <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start. 
int
sys_uptime(void)
{
80106deb:	55                   	push   %ebp
80106dec:	89 e5                	mov    %esp,%ebp
80106dee:	83 ec 10             	sub    $0x10,%esp
  uint xticks;
  
  xticks = ticks;
80106df1:	a1 e0 65 11 80       	mov    0x801165e0,%eax
80106df6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return xticks;
80106df9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106dfc:	c9                   	leave  
80106dfd:	c3                   	ret    

80106dfe <sys_halt>:

//Turn of the computer
int
sys_halt(void){
80106dfe:	55                   	push   %ebp
80106dff:	89 e5                	mov    %esp,%ebp
80106e01:	83 ec 08             	sub    $0x8,%esp
  cprintf("Shutting down ...\n");
80106e04:	83 ec 0c             	sub    $0xc,%esp
80106e07:	68 22 94 10 80       	push   $0x80109422
80106e0c:	e8 b5 95 ff ff       	call   801003c6 <cprintf>
80106e11:	83 c4 10             	add    $0x10,%esp
  outw( 0x604, 0x0 | 0x2000);
80106e14:	83 ec 08             	sub    $0x8,%esp
80106e17:	68 00 20 00 00       	push   $0x2000
80106e1c:	68 04 06 00 00       	push   $0x604
80106e21:	e8 83 fe ff ff       	call   80106ca9 <outw>
80106e26:	83 c4 10             	add    $0x10,%esp
  return 0;
80106e29:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106e2e:	c9                   	leave  
80106e2f:	c3                   	ret    

80106e30 <sys_date>:

#ifdef CS333_P1
int
sys_date(void)
{
80106e30:	55                   	push   %ebp
80106e31:	89 e5                	mov    %esp,%ebp
80106e33:	83 ec 18             	sub    $0x18,%esp
  struct rtcdate *d;

  if(argptr(0, (void*)&d, sizeof(struct rtcdate)) < 0)
80106e36:	83 ec 04             	sub    $0x4,%esp
80106e39:	6a 18                	push   $0x18
80106e3b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106e3e:	50                   	push   %eax
80106e3f:	6a 00                	push   $0x0
80106e41:	e8 e0 ee ff ff       	call   80105d26 <argptr>
80106e46:	83 c4 10             	add    $0x10,%esp
80106e49:	85 c0                	test   %eax,%eax
80106e4b:	79 07                	jns    80106e54 <sys_date+0x24>
    return -1;
80106e4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e52:	eb 14                	jmp    80106e68 <sys_date+0x38>
  cmostime(d);
80106e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e57:	83 ec 0c             	sub    $0xc,%esp
80106e5a:	50                   	push   %eax
80106e5b:	e8 46 c6 ff ff       	call   801034a6 <cmostime>
80106e60:	83 c4 10             	add    $0x10,%esp
  return 0;
80106e63:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106e68:	c9                   	leave  
80106e69:	c3                   	ret    

80106e6a <sys_getuid>:

#ifdef CS333_P2
// gets process uid
uint
sys_getuid(void)
{
80106e6a:	55                   	push   %ebp
80106e6b:	89 e5                	mov    %esp,%ebp
  return proc->uid;
80106e6d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e73:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
}
80106e79:	5d                   	pop    %ebp
80106e7a:	c3                   	ret    

80106e7b <sys_getgid>:

// gets process gid
uint
sys_getgid(void)
{
80106e7b:	55                   	push   %ebp
80106e7c:	89 e5                	mov    %esp,%ebp
  return proc->gid;
80106e7e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e84:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
}
80106e8a:	5d                   	pop    %ebp
80106e8b:	c3                   	ret    

80106e8c <sys_getppid>:

// gets process ppid
uint
sys_getppid(void)
{
80106e8c:	55                   	push   %ebp
80106e8d:	89 e5                	mov    %esp,%ebp
  if(!proc->parent)
80106e8f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e95:	8b 40 14             	mov    0x14(%eax),%eax
80106e98:	85 c0                	test   %eax,%eax
80106e9a:	75 07                	jne    80106ea3 <sys_getppid+0x17>
    return 1;
80106e9c:	b8 01 00 00 00       	mov    $0x1,%eax
80106ea1:	eb 0c                	jmp    80106eaf <sys_getppid+0x23>
  return proc->parent->pid;
80106ea3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ea9:	8b 40 14             	mov    0x14(%eax),%eax
80106eac:	8b 40 10             	mov    0x10(%eax),%eax
}
80106eaf:	5d                   	pop    %ebp
80106eb0:	c3                   	ret    

80106eb1 <sys_setuid>:

// sets process uid
int
sys_setuid(void)
{
80106eb1:	55                   	push   %ebp
80106eb2:	89 e5                	mov    %esp,%ebp
80106eb4:	83 ec 18             	sub    $0x18,%esp
  int n;

  if(argint(0, &n) < 0)
80106eb7:	83 ec 08             	sub    $0x8,%esp
80106eba:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106ebd:	50                   	push   %eax
80106ebe:	6a 00                	push   $0x0
80106ec0:	e8 39 ee ff ff       	call   80105cfe <argint>
80106ec5:	83 c4 10             	add    $0x10,%esp
80106ec8:	85 c0                	test   %eax,%eax
80106eca:	79 07                	jns    80106ed3 <sys_setuid+0x22>
    return -1;
80106ecc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ed1:	eb 2c                	jmp    80106eff <sys_setuid+0x4e>
  if(n < 0 || n > 32767)
80106ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ed6:	85 c0                	test   %eax,%eax
80106ed8:	78 0a                	js     80106ee4 <sys_setuid+0x33>
80106eda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106edd:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80106ee2:	7e 07                	jle    80106eeb <sys_setuid+0x3a>
    return -1;
80106ee4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ee9:	eb 14                	jmp    80106eff <sys_setuid+0x4e>
  proc->uid = n;
80106eeb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ef1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106ef4:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  return 0;
80106efa:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106eff:	c9                   	leave  
80106f00:	c3                   	ret    

80106f01 <sys_setgid>:

// sets process gid
int
sys_setgid(void)
{
80106f01:	55                   	push   %ebp
80106f02:	89 e5                	mov    %esp,%ebp
80106f04:	83 ec 18             	sub    $0x18,%esp
  int n;

  if(argint(0, &n) < 0)
80106f07:	83 ec 08             	sub    $0x8,%esp
80106f0a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106f0d:	50                   	push   %eax
80106f0e:	6a 00                	push   $0x0
80106f10:	e8 e9 ed ff ff       	call   80105cfe <argint>
80106f15:	83 c4 10             	add    $0x10,%esp
80106f18:	85 c0                	test   %eax,%eax
80106f1a:	79 07                	jns    80106f23 <sys_setgid+0x22>
    return -1;
80106f1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f21:	eb 2c                	jmp    80106f4f <sys_setgid+0x4e>
  if(n < 0 || n > 32767)
80106f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f26:	85 c0                	test   %eax,%eax
80106f28:	78 0a                	js     80106f34 <sys_setgid+0x33>
80106f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f2d:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80106f32:	7e 07                	jle    80106f3b <sys_setgid+0x3a>
    return -1;
80106f34:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f39:	eb 14                	jmp    80106f4f <sys_setgid+0x4e>
  proc->gid = n;
80106f3b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f41:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106f44:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
  return 0;
80106f4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106f4f:	c9                   	leave  
80106f50:	c3                   	ret    

80106f51 <sys_getprocs>:

int
sys_getprocs(uint max, struct uproc* table)
{
80106f51:	55                   	push   %ebp
80106f52:	89 e5                	mov    %esp,%ebp
80106f54:	83 ec 18             	sub    $0x18,%esp
  struct uproc *t;
  int n;

  if(argint(0, &n) < 0)
80106f57:	83 ec 08             	sub    $0x8,%esp
80106f5a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106f5d:	50                   	push   %eax
80106f5e:	6a 00                	push   $0x0
80106f60:	e8 99 ed ff ff       	call   80105cfe <argint>
80106f65:	83 c4 10             	add    $0x10,%esp
80106f68:	85 c0                	test   %eax,%eax
80106f6a:	79 07                	jns    80106f73 <sys_getprocs+0x22>
    return -1;
80106f6c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f71:	eb 31                	jmp    80106fa4 <sys_getprocs+0x53>
  if(argptr(1, (void*)&t, sizeof(struct uproc)) < 0)
80106f73:	83 ec 04             	sub    $0x4,%esp
80106f76:	6a 60                	push   $0x60
80106f78:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106f7b:	50                   	push   %eax
80106f7c:	6a 01                	push   $0x1
80106f7e:	e8 a3 ed ff ff       	call   80105d26 <argptr>
80106f83:	83 c4 10             	add    $0x10,%esp
80106f86:	85 c0                	test   %eax,%eax
80106f88:	79 07                	jns    80106f91 <sys_getprocs+0x40>
    return -1;
80106f8a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f8f:	eb 13                	jmp    80106fa4 <sys_getprocs+0x53>
  return getprocs(n, t);
80106f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f94:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106f97:	83 ec 08             	sub    $0x8,%esp
80106f9a:	50                   	push   %eax
80106f9b:	52                   	push   %edx
80106f9c:	e8 02 e5 ff ff       	call   801054a3 <getprocs>
80106fa1:	83 c4 10             	add    $0x10,%esp
}
80106fa4:	c9                   	leave  
80106fa5:	c3                   	ret    

80106fa6 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106fa6:	55                   	push   %ebp
80106fa7:	89 e5                	mov    %esp,%ebp
80106fa9:	83 ec 08             	sub    $0x8,%esp
80106fac:	8b 55 08             	mov    0x8(%ebp),%edx
80106faf:	8b 45 0c             	mov    0xc(%ebp),%eax
80106fb2:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106fb6:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106fb9:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106fbd:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106fc1:	ee                   	out    %al,(%dx)
}
80106fc2:	90                   	nop
80106fc3:	c9                   	leave  
80106fc4:	c3                   	ret    

80106fc5 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106fc5:	55                   	push   %ebp
80106fc6:	89 e5                	mov    %esp,%ebp
80106fc8:	83 ec 08             	sub    $0x8,%esp
  // Interrupt TPS times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106fcb:	6a 34                	push   $0x34
80106fcd:	6a 43                	push   $0x43
80106fcf:	e8 d2 ff ff ff       	call   80106fa6 <outb>
80106fd4:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(TPS) % 256);
80106fd7:	68 a9 00 00 00       	push   $0xa9
80106fdc:	6a 40                	push   $0x40
80106fde:	e8 c3 ff ff ff       	call   80106fa6 <outb>
80106fe3:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(TPS) / 256);
80106fe6:	6a 04                	push   $0x4
80106fe8:	6a 40                	push   $0x40
80106fea:	e8 b7 ff ff ff       	call   80106fa6 <outb>
80106fef:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
80106ff2:	83 ec 0c             	sub    $0xc,%esp
80106ff5:	6a 00                	push   $0x0
80106ff7:	e8 0d d2 ff ff       	call   80104209 <picenable>
80106ffc:	83 c4 10             	add    $0x10,%esp
}
80106fff:	90                   	nop
80107000:	c9                   	leave  
80107001:	c3                   	ret    

80107002 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80107002:	1e                   	push   %ds
  pushl %es
80107003:	06                   	push   %es
  pushl %fs
80107004:	0f a0                	push   %fs
  pushl %gs
80107006:	0f a8                	push   %gs
  pushal
80107008:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80107009:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010700d:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010700f:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80107011:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80107015:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80107017:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80107019:	54                   	push   %esp
  call trap
8010701a:	e8 ce 01 00 00       	call   801071ed <trap>
  addl $4, %esp
8010701f:	83 c4 04             	add    $0x4,%esp

80107022 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80107022:	61                   	popa   
  popl %gs
80107023:	0f a9                	pop    %gs
  popl %fs
80107025:	0f a1                	pop    %fs
  popl %es
80107027:	07                   	pop    %es
  popl %ds
80107028:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80107029:	83 c4 08             	add    $0x8,%esp
  iret
8010702c:	cf                   	iret   

8010702d <atom_inc>:

// Routines added for CS333
// atom_inc() added to simplify handling of ticks global
static inline void
atom_inc(volatile int *num)
{
8010702d:	55                   	push   %ebp
8010702e:	89 e5                	mov    %esp,%ebp
  asm volatile ( "lock incl %0" : "=m" (*num));
80107030:	8b 45 08             	mov    0x8(%ebp),%eax
80107033:	f0 ff 00             	lock incl (%eax)
}
80107036:	90                   	nop
80107037:	5d                   	pop    %ebp
80107038:	c3                   	ret    

80107039 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80107039:	55                   	push   %ebp
8010703a:	89 e5                	mov    %esp,%ebp
8010703c:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
8010703f:	8b 45 0c             	mov    0xc(%ebp),%eax
80107042:	83 e8 01             	sub    $0x1,%eax
80107045:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107049:	8b 45 08             	mov    0x8(%ebp),%eax
8010704c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107050:	8b 45 08             	mov    0x8(%ebp),%eax
80107053:	c1 e8 10             	shr    $0x10,%eax
80107056:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010705a:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010705d:	0f 01 18             	lidtl  (%eax)
}
80107060:	90                   	nop
80107061:	c9                   	leave  
80107062:	c3                   	ret    

80107063 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80107063:	55                   	push   %ebp
80107064:	89 e5                	mov    %esp,%ebp
80107066:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80107069:	0f 20 d0             	mov    %cr2,%eax
8010706c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
8010706f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80107072:	c9                   	leave  
80107073:	c3                   	ret    

80107074 <tvinit>:
// Software Developer’s Manual, Vol 3A, 8.1.1 Guaranteed Atomic Operations.
uint ticks __attribute__ ((aligned (4)));

void
tvinit(void)
{
80107074:	55                   	push   %ebp
80107075:	89 e5                	mov    %esp,%ebp
80107077:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
8010707a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80107081:	e9 c3 00 00 00       	jmp    80107149 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80107086:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107089:	8b 04 85 c8 c0 10 80 	mov    -0x7fef3f38(,%eax,4),%eax
80107090:	89 c2                	mov    %eax,%edx
80107092:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107095:	66 89 14 c5 e0 5d 11 	mov    %dx,-0x7feea220(,%eax,8)
8010709c:	80 
8010709d:	8b 45 fc             	mov    -0x4(%ebp),%eax
801070a0:	66 c7 04 c5 e2 5d 11 	movw   $0x8,-0x7feea21e(,%eax,8)
801070a7:	80 08 00 
801070aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
801070ad:	0f b6 14 c5 e4 5d 11 	movzbl -0x7feea21c(,%eax,8),%edx
801070b4:	80 
801070b5:	83 e2 e0             	and    $0xffffffe0,%edx
801070b8:	88 14 c5 e4 5d 11 80 	mov    %dl,-0x7feea21c(,%eax,8)
801070bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
801070c2:	0f b6 14 c5 e4 5d 11 	movzbl -0x7feea21c(,%eax,8),%edx
801070c9:	80 
801070ca:	83 e2 1f             	and    $0x1f,%edx
801070cd:	88 14 c5 e4 5d 11 80 	mov    %dl,-0x7feea21c(,%eax,8)
801070d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801070d7:	0f b6 14 c5 e5 5d 11 	movzbl -0x7feea21b(,%eax,8),%edx
801070de:	80 
801070df:	83 e2 f0             	and    $0xfffffff0,%edx
801070e2:	83 ca 0e             	or     $0xe,%edx
801070e5:	88 14 c5 e5 5d 11 80 	mov    %dl,-0x7feea21b(,%eax,8)
801070ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
801070ef:	0f b6 14 c5 e5 5d 11 	movzbl -0x7feea21b(,%eax,8),%edx
801070f6:	80 
801070f7:	83 e2 ef             	and    $0xffffffef,%edx
801070fa:	88 14 c5 e5 5d 11 80 	mov    %dl,-0x7feea21b(,%eax,8)
80107101:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107104:	0f b6 14 c5 e5 5d 11 	movzbl -0x7feea21b(,%eax,8),%edx
8010710b:	80 
8010710c:	83 e2 9f             	and    $0xffffff9f,%edx
8010710f:	88 14 c5 e5 5d 11 80 	mov    %dl,-0x7feea21b(,%eax,8)
80107116:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107119:	0f b6 14 c5 e5 5d 11 	movzbl -0x7feea21b(,%eax,8),%edx
80107120:	80 
80107121:	83 ca 80             	or     $0xffffff80,%edx
80107124:	88 14 c5 e5 5d 11 80 	mov    %dl,-0x7feea21b(,%eax,8)
8010712b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010712e:	8b 04 85 c8 c0 10 80 	mov    -0x7fef3f38(,%eax,4),%eax
80107135:	c1 e8 10             	shr    $0x10,%eax
80107138:	89 c2                	mov    %eax,%edx
8010713a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010713d:	66 89 14 c5 e6 5d 11 	mov    %dx,-0x7feea21a(,%eax,8)
80107144:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80107145:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80107149:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
80107150:	0f 8e 30 ff ff ff    	jle    80107086 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80107156:	a1 c8 c1 10 80       	mov    0x8010c1c8,%eax
8010715b:	66 a3 e0 5f 11 80    	mov    %ax,0x80115fe0
80107161:	66 c7 05 e2 5f 11 80 	movw   $0x8,0x80115fe2
80107168:	08 00 
8010716a:	0f b6 05 e4 5f 11 80 	movzbl 0x80115fe4,%eax
80107171:	83 e0 e0             	and    $0xffffffe0,%eax
80107174:	a2 e4 5f 11 80       	mov    %al,0x80115fe4
80107179:	0f b6 05 e4 5f 11 80 	movzbl 0x80115fe4,%eax
80107180:	83 e0 1f             	and    $0x1f,%eax
80107183:	a2 e4 5f 11 80       	mov    %al,0x80115fe4
80107188:	0f b6 05 e5 5f 11 80 	movzbl 0x80115fe5,%eax
8010718f:	83 c8 0f             	or     $0xf,%eax
80107192:	a2 e5 5f 11 80       	mov    %al,0x80115fe5
80107197:	0f b6 05 e5 5f 11 80 	movzbl 0x80115fe5,%eax
8010719e:	83 e0 ef             	and    $0xffffffef,%eax
801071a1:	a2 e5 5f 11 80       	mov    %al,0x80115fe5
801071a6:	0f b6 05 e5 5f 11 80 	movzbl 0x80115fe5,%eax
801071ad:	83 c8 60             	or     $0x60,%eax
801071b0:	a2 e5 5f 11 80       	mov    %al,0x80115fe5
801071b5:	0f b6 05 e5 5f 11 80 	movzbl 0x80115fe5,%eax
801071bc:	83 c8 80             	or     $0xffffff80,%eax
801071bf:	a2 e5 5f 11 80       	mov    %al,0x80115fe5
801071c4:	a1 c8 c1 10 80       	mov    0x8010c1c8,%eax
801071c9:	c1 e8 10             	shr    $0x10,%eax
801071cc:	66 a3 e6 5f 11 80    	mov    %ax,0x80115fe6
  
}
801071d2:	90                   	nop
801071d3:	c9                   	leave  
801071d4:	c3                   	ret    

801071d5 <idtinit>:

void
idtinit(void)
{
801071d5:	55                   	push   %ebp
801071d6:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
801071d8:	68 00 08 00 00       	push   $0x800
801071dd:	68 e0 5d 11 80       	push   $0x80115de0
801071e2:	e8 52 fe ff ff       	call   80107039 <lidt>
801071e7:	83 c4 08             	add    $0x8,%esp
}
801071ea:	90                   	nop
801071eb:	c9                   	leave  
801071ec:	c3                   	ret    

801071ed <trap>:

void
trap(struct trapframe *tf)
{
801071ed:	55                   	push   %ebp
801071ee:	89 e5                	mov    %esp,%ebp
801071f0:	57                   	push   %edi
801071f1:	56                   	push   %esi
801071f2:	53                   	push   %ebx
801071f3:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
801071f6:	8b 45 08             	mov    0x8(%ebp),%eax
801071f9:	8b 40 30             	mov    0x30(%eax),%eax
801071fc:	83 f8 40             	cmp    $0x40,%eax
801071ff:	75 3e                	jne    8010723f <trap+0x52>
    if(proc->killed)
80107201:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107207:	8b 40 24             	mov    0x24(%eax),%eax
8010720a:	85 c0                	test   %eax,%eax
8010720c:	74 05                	je     80107213 <trap+0x26>
      exit();
8010720e:	e8 0c da ff ff       	call   80104c1f <exit>
    proc->tf = tf;
80107213:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107219:	8b 55 08             	mov    0x8(%ebp),%edx
8010721c:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
8010721f:	e8 90 eb ff ff       	call   80105db4 <syscall>
    if(proc->killed)
80107224:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010722a:	8b 40 24             	mov    0x24(%eax),%eax
8010722d:	85 c0                	test   %eax,%eax
8010722f:	0f 84 21 02 00 00    	je     80107456 <trap+0x269>
      exit();
80107235:	e8 e5 d9 ff ff       	call   80104c1f <exit>
    return;
8010723a:	e9 17 02 00 00       	jmp    80107456 <trap+0x269>
  }

  switch(tf->trapno){
8010723f:	8b 45 08             	mov    0x8(%ebp),%eax
80107242:	8b 40 30             	mov    0x30(%eax),%eax
80107245:	83 e8 20             	sub    $0x20,%eax
80107248:	83 f8 1f             	cmp    $0x1f,%eax
8010724b:	0f 87 a3 00 00 00    	ja     801072f4 <trap+0x107>
80107251:	8b 04 85 d8 94 10 80 	mov    -0x7fef6b28(,%eax,4),%eax
80107258:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
   if(cpu->id == 0){
8010725a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107260:	0f b6 00             	movzbl (%eax),%eax
80107263:	84 c0                	test   %al,%al
80107265:	75 20                	jne    80107287 <trap+0x9a>
      atom_inc((int *)&ticks);   // guaranteed atomic so no lock necessary
80107267:	83 ec 0c             	sub    $0xc,%esp
8010726a:	68 e0 65 11 80       	push   $0x801165e0
8010726f:	e8 b9 fd ff ff       	call   8010702d <atom_inc>
80107274:	83 c4 10             	add    $0x10,%esp
      wakeup(&ticks);
80107277:	83 ec 0c             	sub    $0xc,%esp
8010727a:	68 e0 65 11 80       	push   $0x801165e0
8010727f:	e8 34 df ff ff       	call   801051b8 <wakeup>
80107284:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80107287:	e8 77 c0 ff ff       	call   80103303 <lapiceoi>
    break;
8010728c:	e9 1c 01 00 00       	jmp    801073ad <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80107291:	e8 80 b8 ff ff       	call   80102b16 <ideintr>
    lapiceoi();
80107296:	e8 68 c0 ff ff       	call   80103303 <lapiceoi>
    break;
8010729b:	e9 0d 01 00 00       	jmp    801073ad <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801072a0:	e8 60 be ff ff       	call   80103105 <kbdintr>
    lapiceoi();
801072a5:	e8 59 c0 ff ff       	call   80103303 <lapiceoi>
    break;
801072aa:	e9 fe 00 00 00       	jmp    801073ad <trap+0x1c0>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801072af:	e8 83 03 00 00       	call   80107637 <uartintr>
    lapiceoi();
801072b4:	e8 4a c0 ff ff       	call   80103303 <lapiceoi>
    break;
801072b9:	e9 ef 00 00 00       	jmp    801073ad <trap+0x1c0>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801072be:	8b 45 08             	mov    0x8(%ebp),%eax
801072c1:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
801072c4:	8b 45 08             	mov    0x8(%ebp),%eax
801072c7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801072cb:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
801072ce:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801072d4:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801072d7:	0f b6 c0             	movzbl %al,%eax
801072da:	51                   	push   %ecx
801072db:	52                   	push   %edx
801072dc:	50                   	push   %eax
801072dd:	68 38 94 10 80       	push   $0x80109438
801072e2:	e8 df 90 ff ff       	call   801003c6 <cprintf>
801072e7:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
801072ea:	e8 14 c0 ff ff       	call   80103303 <lapiceoi>
    break;
801072ef:	e9 b9 00 00 00       	jmp    801073ad <trap+0x1c0>
   
  default:
    if(proc == 0 || (tf->cs&3) == 0){
801072f4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801072fa:	85 c0                	test   %eax,%eax
801072fc:	74 11                	je     8010730f <trap+0x122>
801072fe:	8b 45 08             	mov    0x8(%ebp),%eax
80107301:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107305:	0f b7 c0             	movzwl %ax,%eax
80107308:	83 e0 03             	and    $0x3,%eax
8010730b:	85 c0                	test   %eax,%eax
8010730d:	75 40                	jne    8010734f <trap+0x162>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010730f:	e8 4f fd ff ff       	call   80107063 <rcr2>
80107314:	89 c3                	mov    %eax,%ebx
80107316:	8b 45 08             	mov    0x8(%ebp),%eax
80107319:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
8010731c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107322:	0f b6 00             	movzbl (%eax),%eax
    break;
   
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107325:	0f b6 d0             	movzbl %al,%edx
80107328:	8b 45 08             	mov    0x8(%ebp),%eax
8010732b:	8b 40 30             	mov    0x30(%eax),%eax
8010732e:	83 ec 0c             	sub    $0xc,%esp
80107331:	53                   	push   %ebx
80107332:	51                   	push   %ecx
80107333:	52                   	push   %edx
80107334:	50                   	push   %eax
80107335:	68 5c 94 10 80       	push   $0x8010945c
8010733a:	e8 87 90 ff ff       	call   801003c6 <cprintf>
8010733f:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80107342:	83 ec 0c             	sub    $0xc,%esp
80107345:	68 8e 94 10 80       	push   $0x8010948e
8010734a:	e8 17 92 ff ff       	call   80100566 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010734f:	e8 0f fd ff ff       	call   80107063 <rcr2>
80107354:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107357:	8b 45 08             	mov    0x8(%ebp),%eax
8010735a:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
8010735d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107363:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107366:	0f b6 d8             	movzbl %al,%ebx
80107369:	8b 45 08             	mov    0x8(%ebp),%eax
8010736c:	8b 48 34             	mov    0x34(%eax),%ecx
8010736f:	8b 45 08             	mov    0x8(%ebp),%eax
80107372:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80107375:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010737b:	8d 78 6c             	lea    0x6c(%eax),%edi
8010737e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107384:	8b 40 10             	mov    0x10(%eax),%eax
80107387:	ff 75 e4             	pushl  -0x1c(%ebp)
8010738a:	56                   	push   %esi
8010738b:	53                   	push   %ebx
8010738c:	51                   	push   %ecx
8010738d:	52                   	push   %edx
8010738e:	57                   	push   %edi
8010738f:	50                   	push   %eax
80107390:	68 94 94 10 80       	push   $0x80109494
80107395:	e8 2c 90 ff ff       	call   801003c6 <cprintf>
8010739a:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
8010739d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801073a3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801073aa:	eb 01                	jmp    801073ad <trap+0x1c0>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
801073ac:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801073ad:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801073b3:	85 c0                	test   %eax,%eax
801073b5:	74 24                	je     801073db <trap+0x1ee>
801073b7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801073bd:	8b 40 24             	mov    0x24(%eax),%eax
801073c0:	85 c0                	test   %eax,%eax
801073c2:	74 17                	je     801073db <trap+0x1ee>
801073c4:	8b 45 08             	mov    0x8(%ebp),%eax
801073c7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801073cb:	0f b7 c0             	movzwl %ax,%eax
801073ce:	83 e0 03             	and    $0x3,%eax
801073d1:	83 f8 03             	cmp    $0x3,%eax
801073d4:	75 05                	jne    801073db <trap+0x1ee>
    exit();
801073d6:	e8 44 d8 ff ff       	call   80104c1f <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING &&
801073db:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801073e1:	85 c0                	test   %eax,%eax
801073e3:	74 41                	je     80107426 <trap+0x239>
801073e5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801073eb:	8b 40 0c             	mov    0xc(%eax),%eax
801073ee:	83 f8 04             	cmp    $0x4,%eax
801073f1:	75 33                	jne    80107426 <trap+0x239>
	  tf->trapno == T_IRQ0+IRQ_TIMER && ticks%SCHED_INTERVAL==0)
801073f3:	8b 45 08             	mov    0x8(%ebp),%eax
801073f6:	8b 40 30             	mov    0x30(%eax),%eax
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING &&
801073f9:	83 f8 20             	cmp    $0x20,%eax
801073fc:	75 28                	jne    80107426 <trap+0x239>
	  tf->trapno == T_IRQ0+IRQ_TIMER && ticks%SCHED_INTERVAL==0)
801073fe:	8b 0d e0 65 11 80    	mov    0x801165e0,%ecx
80107404:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80107409:	89 c8                	mov    %ecx,%eax
8010740b:	f7 e2                	mul    %edx
8010740d:	c1 ea 03             	shr    $0x3,%edx
80107410:	89 d0                	mov    %edx,%eax
80107412:	c1 e0 02             	shl    $0x2,%eax
80107415:	01 d0                	add    %edx,%eax
80107417:	01 c0                	add    %eax,%eax
80107419:	29 c1                	sub    %eax,%ecx
8010741b:	89 ca                	mov    %ecx,%edx
8010741d:	85 d2                	test   %edx,%edx
8010741f:	75 05                	jne    80107426 <trap+0x239>
    yield();
80107421:	e8 2a dc ff ff       	call   80105050 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80107426:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010742c:	85 c0                	test   %eax,%eax
8010742e:	74 27                	je     80107457 <trap+0x26a>
80107430:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107436:	8b 40 24             	mov    0x24(%eax),%eax
80107439:	85 c0                	test   %eax,%eax
8010743b:	74 1a                	je     80107457 <trap+0x26a>
8010743d:	8b 45 08             	mov    0x8(%ebp),%eax
80107440:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107444:	0f b7 c0             	movzwl %ax,%eax
80107447:	83 e0 03             	and    $0x3,%eax
8010744a:	83 f8 03             	cmp    $0x3,%eax
8010744d:	75 08                	jne    80107457 <trap+0x26a>
    exit();
8010744f:	e8 cb d7 ff ff       	call   80104c1f <exit>
80107454:	eb 01                	jmp    80107457 <trap+0x26a>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
80107456:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80107457:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010745a:	5b                   	pop    %ebx
8010745b:	5e                   	pop    %esi
8010745c:	5f                   	pop    %edi
8010745d:	5d                   	pop    %ebp
8010745e:	c3                   	ret    

8010745f <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
8010745f:	55                   	push   %ebp
80107460:	89 e5                	mov    %esp,%ebp
80107462:	83 ec 14             	sub    $0x14,%esp
80107465:	8b 45 08             	mov    0x8(%ebp),%eax
80107468:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010746c:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80107470:	89 c2                	mov    %eax,%edx
80107472:	ec                   	in     (%dx),%al
80107473:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80107476:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
8010747a:	c9                   	leave  
8010747b:	c3                   	ret    

8010747c <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
8010747c:	55                   	push   %ebp
8010747d:	89 e5                	mov    %esp,%ebp
8010747f:	83 ec 08             	sub    $0x8,%esp
80107482:	8b 55 08             	mov    0x8(%ebp),%edx
80107485:	8b 45 0c             	mov    0xc(%ebp),%eax
80107488:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010748c:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010748f:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107493:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107497:	ee                   	out    %al,(%dx)
}
80107498:	90                   	nop
80107499:	c9                   	leave  
8010749a:	c3                   	ret    

8010749b <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
8010749b:	55                   	push   %ebp
8010749c:	89 e5                	mov    %esp,%ebp
8010749e:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
801074a1:	6a 00                	push   $0x0
801074a3:	68 fa 03 00 00       	push   $0x3fa
801074a8:	e8 cf ff ff ff       	call   8010747c <outb>
801074ad:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
801074b0:	68 80 00 00 00       	push   $0x80
801074b5:	68 fb 03 00 00       	push   $0x3fb
801074ba:	e8 bd ff ff ff       	call   8010747c <outb>
801074bf:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
801074c2:	6a 0c                	push   $0xc
801074c4:	68 f8 03 00 00       	push   $0x3f8
801074c9:	e8 ae ff ff ff       	call   8010747c <outb>
801074ce:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
801074d1:	6a 00                	push   $0x0
801074d3:	68 f9 03 00 00       	push   $0x3f9
801074d8:	e8 9f ff ff ff       	call   8010747c <outb>
801074dd:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
801074e0:	6a 03                	push   $0x3
801074e2:	68 fb 03 00 00       	push   $0x3fb
801074e7:	e8 90 ff ff ff       	call   8010747c <outb>
801074ec:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
801074ef:	6a 00                	push   $0x0
801074f1:	68 fc 03 00 00       	push   $0x3fc
801074f6:	e8 81 ff ff ff       	call   8010747c <outb>
801074fb:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
801074fe:	6a 01                	push   $0x1
80107500:	68 f9 03 00 00       	push   $0x3f9
80107505:	e8 72 ff ff ff       	call   8010747c <outb>
8010750a:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
8010750d:	68 fd 03 00 00       	push   $0x3fd
80107512:	e8 48 ff ff ff       	call   8010745f <inb>
80107517:	83 c4 04             	add    $0x4,%esp
8010751a:	3c ff                	cmp    $0xff,%al
8010751c:	74 6e                	je     8010758c <uartinit+0xf1>
    return;
  uart = 1;
8010751e:	c7 05 8c c6 10 80 01 	movl   $0x1,0x8010c68c
80107525:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80107528:	68 fa 03 00 00       	push   $0x3fa
8010752d:	e8 2d ff ff ff       	call   8010745f <inb>
80107532:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80107535:	68 f8 03 00 00       	push   $0x3f8
8010753a:	e8 20 ff ff ff       	call   8010745f <inb>
8010753f:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
80107542:	83 ec 0c             	sub    $0xc,%esp
80107545:	6a 04                	push   $0x4
80107547:	e8 bd cc ff ff       	call   80104209 <picenable>
8010754c:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
8010754f:	83 ec 08             	sub    $0x8,%esp
80107552:	6a 00                	push   $0x0
80107554:	6a 04                	push   $0x4
80107556:	e8 5d b8 ff ff       	call   80102db8 <ioapicenable>
8010755b:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010755e:	c7 45 f4 58 95 10 80 	movl   $0x80109558,-0xc(%ebp)
80107565:	eb 19                	jmp    80107580 <uartinit+0xe5>
    uartputc(*p);
80107567:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010756a:	0f b6 00             	movzbl (%eax),%eax
8010756d:	0f be c0             	movsbl %al,%eax
80107570:	83 ec 0c             	sub    $0xc,%esp
80107573:	50                   	push   %eax
80107574:	e8 16 00 00 00       	call   8010758f <uartputc>
80107579:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010757c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107580:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107583:	0f b6 00             	movzbl (%eax),%eax
80107586:	84 c0                	test   %al,%al
80107588:	75 dd                	jne    80107567 <uartinit+0xcc>
8010758a:	eb 01                	jmp    8010758d <uartinit+0xf2>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
8010758c:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
8010758d:	c9                   	leave  
8010758e:	c3                   	ret    

8010758f <uartputc>:

void
uartputc(int c)
{
8010758f:	55                   	push   %ebp
80107590:	89 e5                	mov    %esp,%ebp
80107592:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
80107595:	a1 8c c6 10 80       	mov    0x8010c68c,%eax
8010759a:	85 c0                	test   %eax,%eax
8010759c:	74 53                	je     801075f1 <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010759e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801075a5:	eb 11                	jmp    801075b8 <uartputc+0x29>
    microdelay(10);
801075a7:	83 ec 0c             	sub    $0xc,%esp
801075aa:	6a 0a                	push   $0xa
801075ac:	e8 6d bd ff ff       	call   8010331e <microdelay>
801075b1:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801075b4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801075b8:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
801075bc:	7f 1a                	jg     801075d8 <uartputc+0x49>
801075be:	83 ec 0c             	sub    $0xc,%esp
801075c1:	68 fd 03 00 00       	push   $0x3fd
801075c6:	e8 94 fe ff ff       	call   8010745f <inb>
801075cb:	83 c4 10             	add    $0x10,%esp
801075ce:	0f b6 c0             	movzbl %al,%eax
801075d1:	83 e0 20             	and    $0x20,%eax
801075d4:	85 c0                	test   %eax,%eax
801075d6:	74 cf                	je     801075a7 <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
801075d8:	8b 45 08             	mov    0x8(%ebp),%eax
801075db:	0f b6 c0             	movzbl %al,%eax
801075de:	83 ec 08             	sub    $0x8,%esp
801075e1:	50                   	push   %eax
801075e2:	68 f8 03 00 00       	push   $0x3f8
801075e7:	e8 90 fe ff ff       	call   8010747c <outb>
801075ec:	83 c4 10             	add    $0x10,%esp
801075ef:	eb 01                	jmp    801075f2 <uartputc+0x63>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
801075f1:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
801075f2:	c9                   	leave  
801075f3:	c3                   	ret    

801075f4 <uartgetc>:

static int
uartgetc(void)
{
801075f4:	55                   	push   %ebp
801075f5:	89 e5                	mov    %esp,%ebp
  if(!uart)
801075f7:	a1 8c c6 10 80       	mov    0x8010c68c,%eax
801075fc:	85 c0                	test   %eax,%eax
801075fe:	75 07                	jne    80107607 <uartgetc+0x13>
    return -1;
80107600:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107605:	eb 2e                	jmp    80107635 <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
80107607:	68 fd 03 00 00       	push   $0x3fd
8010760c:	e8 4e fe ff ff       	call   8010745f <inb>
80107611:	83 c4 04             	add    $0x4,%esp
80107614:	0f b6 c0             	movzbl %al,%eax
80107617:	83 e0 01             	and    $0x1,%eax
8010761a:	85 c0                	test   %eax,%eax
8010761c:	75 07                	jne    80107625 <uartgetc+0x31>
    return -1;
8010761e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107623:	eb 10                	jmp    80107635 <uartgetc+0x41>
  return inb(COM1+0);
80107625:	68 f8 03 00 00       	push   $0x3f8
8010762a:	e8 30 fe ff ff       	call   8010745f <inb>
8010762f:	83 c4 04             	add    $0x4,%esp
80107632:	0f b6 c0             	movzbl %al,%eax
}
80107635:	c9                   	leave  
80107636:	c3                   	ret    

80107637 <uartintr>:

void
uartintr(void)
{
80107637:	55                   	push   %ebp
80107638:	89 e5                	mov    %esp,%ebp
8010763a:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
8010763d:	83 ec 0c             	sub    $0xc,%esp
80107640:	68 f4 75 10 80       	push   $0x801075f4
80107645:	e8 af 91 ff ff       	call   801007f9 <consoleintr>
8010764a:	83 c4 10             	add    $0x10,%esp
}
8010764d:	90                   	nop
8010764e:	c9                   	leave  
8010764f:	c3                   	ret    

80107650 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80107650:	6a 00                	push   $0x0
  pushl $0
80107652:	6a 00                	push   $0x0
  jmp alltraps
80107654:	e9 a9 f9 ff ff       	jmp    80107002 <alltraps>

80107659 <vector1>:
.globl vector1
vector1:
  pushl $0
80107659:	6a 00                	push   $0x0
  pushl $1
8010765b:	6a 01                	push   $0x1
  jmp alltraps
8010765d:	e9 a0 f9 ff ff       	jmp    80107002 <alltraps>

80107662 <vector2>:
.globl vector2
vector2:
  pushl $0
80107662:	6a 00                	push   $0x0
  pushl $2
80107664:	6a 02                	push   $0x2
  jmp alltraps
80107666:	e9 97 f9 ff ff       	jmp    80107002 <alltraps>

8010766b <vector3>:
.globl vector3
vector3:
  pushl $0
8010766b:	6a 00                	push   $0x0
  pushl $3
8010766d:	6a 03                	push   $0x3
  jmp alltraps
8010766f:	e9 8e f9 ff ff       	jmp    80107002 <alltraps>

80107674 <vector4>:
.globl vector4
vector4:
  pushl $0
80107674:	6a 00                	push   $0x0
  pushl $4
80107676:	6a 04                	push   $0x4
  jmp alltraps
80107678:	e9 85 f9 ff ff       	jmp    80107002 <alltraps>

8010767d <vector5>:
.globl vector5
vector5:
  pushl $0
8010767d:	6a 00                	push   $0x0
  pushl $5
8010767f:	6a 05                	push   $0x5
  jmp alltraps
80107681:	e9 7c f9 ff ff       	jmp    80107002 <alltraps>

80107686 <vector6>:
.globl vector6
vector6:
  pushl $0
80107686:	6a 00                	push   $0x0
  pushl $6
80107688:	6a 06                	push   $0x6
  jmp alltraps
8010768a:	e9 73 f9 ff ff       	jmp    80107002 <alltraps>

8010768f <vector7>:
.globl vector7
vector7:
  pushl $0
8010768f:	6a 00                	push   $0x0
  pushl $7
80107691:	6a 07                	push   $0x7
  jmp alltraps
80107693:	e9 6a f9 ff ff       	jmp    80107002 <alltraps>

80107698 <vector8>:
.globl vector8
vector8:
  pushl $8
80107698:	6a 08                	push   $0x8
  jmp alltraps
8010769a:	e9 63 f9 ff ff       	jmp    80107002 <alltraps>

8010769f <vector9>:
.globl vector9
vector9:
  pushl $0
8010769f:	6a 00                	push   $0x0
  pushl $9
801076a1:	6a 09                	push   $0x9
  jmp alltraps
801076a3:	e9 5a f9 ff ff       	jmp    80107002 <alltraps>

801076a8 <vector10>:
.globl vector10
vector10:
  pushl $10
801076a8:	6a 0a                	push   $0xa
  jmp alltraps
801076aa:	e9 53 f9 ff ff       	jmp    80107002 <alltraps>

801076af <vector11>:
.globl vector11
vector11:
  pushl $11
801076af:	6a 0b                	push   $0xb
  jmp alltraps
801076b1:	e9 4c f9 ff ff       	jmp    80107002 <alltraps>

801076b6 <vector12>:
.globl vector12
vector12:
  pushl $12
801076b6:	6a 0c                	push   $0xc
  jmp alltraps
801076b8:	e9 45 f9 ff ff       	jmp    80107002 <alltraps>

801076bd <vector13>:
.globl vector13
vector13:
  pushl $13
801076bd:	6a 0d                	push   $0xd
  jmp alltraps
801076bf:	e9 3e f9 ff ff       	jmp    80107002 <alltraps>

801076c4 <vector14>:
.globl vector14
vector14:
  pushl $14
801076c4:	6a 0e                	push   $0xe
  jmp alltraps
801076c6:	e9 37 f9 ff ff       	jmp    80107002 <alltraps>

801076cb <vector15>:
.globl vector15
vector15:
  pushl $0
801076cb:	6a 00                	push   $0x0
  pushl $15
801076cd:	6a 0f                	push   $0xf
  jmp alltraps
801076cf:	e9 2e f9 ff ff       	jmp    80107002 <alltraps>

801076d4 <vector16>:
.globl vector16
vector16:
  pushl $0
801076d4:	6a 00                	push   $0x0
  pushl $16
801076d6:	6a 10                	push   $0x10
  jmp alltraps
801076d8:	e9 25 f9 ff ff       	jmp    80107002 <alltraps>

801076dd <vector17>:
.globl vector17
vector17:
  pushl $17
801076dd:	6a 11                	push   $0x11
  jmp alltraps
801076df:	e9 1e f9 ff ff       	jmp    80107002 <alltraps>

801076e4 <vector18>:
.globl vector18
vector18:
  pushl $0
801076e4:	6a 00                	push   $0x0
  pushl $18
801076e6:	6a 12                	push   $0x12
  jmp alltraps
801076e8:	e9 15 f9 ff ff       	jmp    80107002 <alltraps>

801076ed <vector19>:
.globl vector19
vector19:
  pushl $0
801076ed:	6a 00                	push   $0x0
  pushl $19
801076ef:	6a 13                	push   $0x13
  jmp alltraps
801076f1:	e9 0c f9 ff ff       	jmp    80107002 <alltraps>

801076f6 <vector20>:
.globl vector20
vector20:
  pushl $0
801076f6:	6a 00                	push   $0x0
  pushl $20
801076f8:	6a 14                	push   $0x14
  jmp alltraps
801076fa:	e9 03 f9 ff ff       	jmp    80107002 <alltraps>

801076ff <vector21>:
.globl vector21
vector21:
  pushl $0
801076ff:	6a 00                	push   $0x0
  pushl $21
80107701:	6a 15                	push   $0x15
  jmp alltraps
80107703:	e9 fa f8 ff ff       	jmp    80107002 <alltraps>

80107708 <vector22>:
.globl vector22
vector22:
  pushl $0
80107708:	6a 00                	push   $0x0
  pushl $22
8010770a:	6a 16                	push   $0x16
  jmp alltraps
8010770c:	e9 f1 f8 ff ff       	jmp    80107002 <alltraps>

80107711 <vector23>:
.globl vector23
vector23:
  pushl $0
80107711:	6a 00                	push   $0x0
  pushl $23
80107713:	6a 17                	push   $0x17
  jmp alltraps
80107715:	e9 e8 f8 ff ff       	jmp    80107002 <alltraps>

8010771a <vector24>:
.globl vector24
vector24:
  pushl $0
8010771a:	6a 00                	push   $0x0
  pushl $24
8010771c:	6a 18                	push   $0x18
  jmp alltraps
8010771e:	e9 df f8 ff ff       	jmp    80107002 <alltraps>

80107723 <vector25>:
.globl vector25
vector25:
  pushl $0
80107723:	6a 00                	push   $0x0
  pushl $25
80107725:	6a 19                	push   $0x19
  jmp alltraps
80107727:	e9 d6 f8 ff ff       	jmp    80107002 <alltraps>

8010772c <vector26>:
.globl vector26
vector26:
  pushl $0
8010772c:	6a 00                	push   $0x0
  pushl $26
8010772e:	6a 1a                	push   $0x1a
  jmp alltraps
80107730:	e9 cd f8 ff ff       	jmp    80107002 <alltraps>

80107735 <vector27>:
.globl vector27
vector27:
  pushl $0
80107735:	6a 00                	push   $0x0
  pushl $27
80107737:	6a 1b                	push   $0x1b
  jmp alltraps
80107739:	e9 c4 f8 ff ff       	jmp    80107002 <alltraps>

8010773e <vector28>:
.globl vector28
vector28:
  pushl $0
8010773e:	6a 00                	push   $0x0
  pushl $28
80107740:	6a 1c                	push   $0x1c
  jmp alltraps
80107742:	e9 bb f8 ff ff       	jmp    80107002 <alltraps>

80107747 <vector29>:
.globl vector29
vector29:
  pushl $0
80107747:	6a 00                	push   $0x0
  pushl $29
80107749:	6a 1d                	push   $0x1d
  jmp alltraps
8010774b:	e9 b2 f8 ff ff       	jmp    80107002 <alltraps>

80107750 <vector30>:
.globl vector30
vector30:
  pushl $0
80107750:	6a 00                	push   $0x0
  pushl $30
80107752:	6a 1e                	push   $0x1e
  jmp alltraps
80107754:	e9 a9 f8 ff ff       	jmp    80107002 <alltraps>

80107759 <vector31>:
.globl vector31
vector31:
  pushl $0
80107759:	6a 00                	push   $0x0
  pushl $31
8010775b:	6a 1f                	push   $0x1f
  jmp alltraps
8010775d:	e9 a0 f8 ff ff       	jmp    80107002 <alltraps>

80107762 <vector32>:
.globl vector32
vector32:
  pushl $0
80107762:	6a 00                	push   $0x0
  pushl $32
80107764:	6a 20                	push   $0x20
  jmp alltraps
80107766:	e9 97 f8 ff ff       	jmp    80107002 <alltraps>

8010776b <vector33>:
.globl vector33
vector33:
  pushl $0
8010776b:	6a 00                	push   $0x0
  pushl $33
8010776d:	6a 21                	push   $0x21
  jmp alltraps
8010776f:	e9 8e f8 ff ff       	jmp    80107002 <alltraps>

80107774 <vector34>:
.globl vector34
vector34:
  pushl $0
80107774:	6a 00                	push   $0x0
  pushl $34
80107776:	6a 22                	push   $0x22
  jmp alltraps
80107778:	e9 85 f8 ff ff       	jmp    80107002 <alltraps>

8010777d <vector35>:
.globl vector35
vector35:
  pushl $0
8010777d:	6a 00                	push   $0x0
  pushl $35
8010777f:	6a 23                	push   $0x23
  jmp alltraps
80107781:	e9 7c f8 ff ff       	jmp    80107002 <alltraps>

80107786 <vector36>:
.globl vector36
vector36:
  pushl $0
80107786:	6a 00                	push   $0x0
  pushl $36
80107788:	6a 24                	push   $0x24
  jmp alltraps
8010778a:	e9 73 f8 ff ff       	jmp    80107002 <alltraps>

8010778f <vector37>:
.globl vector37
vector37:
  pushl $0
8010778f:	6a 00                	push   $0x0
  pushl $37
80107791:	6a 25                	push   $0x25
  jmp alltraps
80107793:	e9 6a f8 ff ff       	jmp    80107002 <alltraps>

80107798 <vector38>:
.globl vector38
vector38:
  pushl $0
80107798:	6a 00                	push   $0x0
  pushl $38
8010779a:	6a 26                	push   $0x26
  jmp alltraps
8010779c:	e9 61 f8 ff ff       	jmp    80107002 <alltraps>

801077a1 <vector39>:
.globl vector39
vector39:
  pushl $0
801077a1:	6a 00                	push   $0x0
  pushl $39
801077a3:	6a 27                	push   $0x27
  jmp alltraps
801077a5:	e9 58 f8 ff ff       	jmp    80107002 <alltraps>

801077aa <vector40>:
.globl vector40
vector40:
  pushl $0
801077aa:	6a 00                	push   $0x0
  pushl $40
801077ac:	6a 28                	push   $0x28
  jmp alltraps
801077ae:	e9 4f f8 ff ff       	jmp    80107002 <alltraps>

801077b3 <vector41>:
.globl vector41
vector41:
  pushl $0
801077b3:	6a 00                	push   $0x0
  pushl $41
801077b5:	6a 29                	push   $0x29
  jmp alltraps
801077b7:	e9 46 f8 ff ff       	jmp    80107002 <alltraps>

801077bc <vector42>:
.globl vector42
vector42:
  pushl $0
801077bc:	6a 00                	push   $0x0
  pushl $42
801077be:	6a 2a                	push   $0x2a
  jmp alltraps
801077c0:	e9 3d f8 ff ff       	jmp    80107002 <alltraps>

801077c5 <vector43>:
.globl vector43
vector43:
  pushl $0
801077c5:	6a 00                	push   $0x0
  pushl $43
801077c7:	6a 2b                	push   $0x2b
  jmp alltraps
801077c9:	e9 34 f8 ff ff       	jmp    80107002 <alltraps>

801077ce <vector44>:
.globl vector44
vector44:
  pushl $0
801077ce:	6a 00                	push   $0x0
  pushl $44
801077d0:	6a 2c                	push   $0x2c
  jmp alltraps
801077d2:	e9 2b f8 ff ff       	jmp    80107002 <alltraps>

801077d7 <vector45>:
.globl vector45
vector45:
  pushl $0
801077d7:	6a 00                	push   $0x0
  pushl $45
801077d9:	6a 2d                	push   $0x2d
  jmp alltraps
801077db:	e9 22 f8 ff ff       	jmp    80107002 <alltraps>

801077e0 <vector46>:
.globl vector46
vector46:
  pushl $0
801077e0:	6a 00                	push   $0x0
  pushl $46
801077e2:	6a 2e                	push   $0x2e
  jmp alltraps
801077e4:	e9 19 f8 ff ff       	jmp    80107002 <alltraps>

801077e9 <vector47>:
.globl vector47
vector47:
  pushl $0
801077e9:	6a 00                	push   $0x0
  pushl $47
801077eb:	6a 2f                	push   $0x2f
  jmp alltraps
801077ed:	e9 10 f8 ff ff       	jmp    80107002 <alltraps>

801077f2 <vector48>:
.globl vector48
vector48:
  pushl $0
801077f2:	6a 00                	push   $0x0
  pushl $48
801077f4:	6a 30                	push   $0x30
  jmp alltraps
801077f6:	e9 07 f8 ff ff       	jmp    80107002 <alltraps>

801077fb <vector49>:
.globl vector49
vector49:
  pushl $0
801077fb:	6a 00                	push   $0x0
  pushl $49
801077fd:	6a 31                	push   $0x31
  jmp alltraps
801077ff:	e9 fe f7 ff ff       	jmp    80107002 <alltraps>

80107804 <vector50>:
.globl vector50
vector50:
  pushl $0
80107804:	6a 00                	push   $0x0
  pushl $50
80107806:	6a 32                	push   $0x32
  jmp alltraps
80107808:	e9 f5 f7 ff ff       	jmp    80107002 <alltraps>

8010780d <vector51>:
.globl vector51
vector51:
  pushl $0
8010780d:	6a 00                	push   $0x0
  pushl $51
8010780f:	6a 33                	push   $0x33
  jmp alltraps
80107811:	e9 ec f7 ff ff       	jmp    80107002 <alltraps>

80107816 <vector52>:
.globl vector52
vector52:
  pushl $0
80107816:	6a 00                	push   $0x0
  pushl $52
80107818:	6a 34                	push   $0x34
  jmp alltraps
8010781a:	e9 e3 f7 ff ff       	jmp    80107002 <alltraps>

8010781f <vector53>:
.globl vector53
vector53:
  pushl $0
8010781f:	6a 00                	push   $0x0
  pushl $53
80107821:	6a 35                	push   $0x35
  jmp alltraps
80107823:	e9 da f7 ff ff       	jmp    80107002 <alltraps>

80107828 <vector54>:
.globl vector54
vector54:
  pushl $0
80107828:	6a 00                	push   $0x0
  pushl $54
8010782a:	6a 36                	push   $0x36
  jmp alltraps
8010782c:	e9 d1 f7 ff ff       	jmp    80107002 <alltraps>

80107831 <vector55>:
.globl vector55
vector55:
  pushl $0
80107831:	6a 00                	push   $0x0
  pushl $55
80107833:	6a 37                	push   $0x37
  jmp alltraps
80107835:	e9 c8 f7 ff ff       	jmp    80107002 <alltraps>

8010783a <vector56>:
.globl vector56
vector56:
  pushl $0
8010783a:	6a 00                	push   $0x0
  pushl $56
8010783c:	6a 38                	push   $0x38
  jmp alltraps
8010783e:	e9 bf f7 ff ff       	jmp    80107002 <alltraps>

80107843 <vector57>:
.globl vector57
vector57:
  pushl $0
80107843:	6a 00                	push   $0x0
  pushl $57
80107845:	6a 39                	push   $0x39
  jmp alltraps
80107847:	e9 b6 f7 ff ff       	jmp    80107002 <alltraps>

8010784c <vector58>:
.globl vector58
vector58:
  pushl $0
8010784c:	6a 00                	push   $0x0
  pushl $58
8010784e:	6a 3a                	push   $0x3a
  jmp alltraps
80107850:	e9 ad f7 ff ff       	jmp    80107002 <alltraps>

80107855 <vector59>:
.globl vector59
vector59:
  pushl $0
80107855:	6a 00                	push   $0x0
  pushl $59
80107857:	6a 3b                	push   $0x3b
  jmp alltraps
80107859:	e9 a4 f7 ff ff       	jmp    80107002 <alltraps>

8010785e <vector60>:
.globl vector60
vector60:
  pushl $0
8010785e:	6a 00                	push   $0x0
  pushl $60
80107860:	6a 3c                	push   $0x3c
  jmp alltraps
80107862:	e9 9b f7 ff ff       	jmp    80107002 <alltraps>

80107867 <vector61>:
.globl vector61
vector61:
  pushl $0
80107867:	6a 00                	push   $0x0
  pushl $61
80107869:	6a 3d                	push   $0x3d
  jmp alltraps
8010786b:	e9 92 f7 ff ff       	jmp    80107002 <alltraps>

80107870 <vector62>:
.globl vector62
vector62:
  pushl $0
80107870:	6a 00                	push   $0x0
  pushl $62
80107872:	6a 3e                	push   $0x3e
  jmp alltraps
80107874:	e9 89 f7 ff ff       	jmp    80107002 <alltraps>

80107879 <vector63>:
.globl vector63
vector63:
  pushl $0
80107879:	6a 00                	push   $0x0
  pushl $63
8010787b:	6a 3f                	push   $0x3f
  jmp alltraps
8010787d:	e9 80 f7 ff ff       	jmp    80107002 <alltraps>

80107882 <vector64>:
.globl vector64
vector64:
  pushl $0
80107882:	6a 00                	push   $0x0
  pushl $64
80107884:	6a 40                	push   $0x40
  jmp alltraps
80107886:	e9 77 f7 ff ff       	jmp    80107002 <alltraps>

8010788b <vector65>:
.globl vector65
vector65:
  pushl $0
8010788b:	6a 00                	push   $0x0
  pushl $65
8010788d:	6a 41                	push   $0x41
  jmp alltraps
8010788f:	e9 6e f7 ff ff       	jmp    80107002 <alltraps>

80107894 <vector66>:
.globl vector66
vector66:
  pushl $0
80107894:	6a 00                	push   $0x0
  pushl $66
80107896:	6a 42                	push   $0x42
  jmp alltraps
80107898:	e9 65 f7 ff ff       	jmp    80107002 <alltraps>

8010789d <vector67>:
.globl vector67
vector67:
  pushl $0
8010789d:	6a 00                	push   $0x0
  pushl $67
8010789f:	6a 43                	push   $0x43
  jmp alltraps
801078a1:	e9 5c f7 ff ff       	jmp    80107002 <alltraps>

801078a6 <vector68>:
.globl vector68
vector68:
  pushl $0
801078a6:	6a 00                	push   $0x0
  pushl $68
801078a8:	6a 44                	push   $0x44
  jmp alltraps
801078aa:	e9 53 f7 ff ff       	jmp    80107002 <alltraps>

801078af <vector69>:
.globl vector69
vector69:
  pushl $0
801078af:	6a 00                	push   $0x0
  pushl $69
801078b1:	6a 45                	push   $0x45
  jmp alltraps
801078b3:	e9 4a f7 ff ff       	jmp    80107002 <alltraps>

801078b8 <vector70>:
.globl vector70
vector70:
  pushl $0
801078b8:	6a 00                	push   $0x0
  pushl $70
801078ba:	6a 46                	push   $0x46
  jmp alltraps
801078bc:	e9 41 f7 ff ff       	jmp    80107002 <alltraps>

801078c1 <vector71>:
.globl vector71
vector71:
  pushl $0
801078c1:	6a 00                	push   $0x0
  pushl $71
801078c3:	6a 47                	push   $0x47
  jmp alltraps
801078c5:	e9 38 f7 ff ff       	jmp    80107002 <alltraps>

801078ca <vector72>:
.globl vector72
vector72:
  pushl $0
801078ca:	6a 00                	push   $0x0
  pushl $72
801078cc:	6a 48                	push   $0x48
  jmp alltraps
801078ce:	e9 2f f7 ff ff       	jmp    80107002 <alltraps>

801078d3 <vector73>:
.globl vector73
vector73:
  pushl $0
801078d3:	6a 00                	push   $0x0
  pushl $73
801078d5:	6a 49                	push   $0x49
  jmp alltraps
801078d7:	e9 26 f7 ff ff       	jmp    80107002 <alltraps>

801078dc <vector74>:
.globl vector74
vector74:
  pushl $0
801078dc:	6a 00                	push   $0x0
  pushl $74
801078de:	6a 4a                	push   $0x4a
  jmp alltraps
801078e0:	e9 1d f7 ff ff       	jmp    80107002 <alltraps>

801078e5 <vector75>:
.globl vector75
vector75:
  pushl $0
801078e5:	6a 00                	push   $0x0
  pushl $75
801078e7:	6a 4b                	push   $0x4b
  jmp alltraps
801078e9:	e9 14 f7 ff ff       	jmp    80107002 <alltraps>

801078ee <vector76>:
.globl vector76
vector76:
  pushl $0
801078ee:	6a 00                	push   $0x0
  pushl $76
801078f0:	6a 4c                	push   $0x4c
  jmp alltraps
801078f2:	e9 0b f7 ff ff       	jmp    80107002 <alltraps>

801078f7 <vector77>:
.globl vector77
vector77:
  pushl $0
801078f7:	6a 00                	push   $0x0
  pushl $77
801078f9:	6a 4d                	push   $0x4d
  jmp alltraps
801078fb:	e9 02 f7 ff ff       	jmp    80107002 <alltraps>

80107900 <vector78>:
.globl vector78
vector78:
  pushl $0
80107900:	6a 00                	push   $0x0
  pushl $78
80107902:	6a 4e                	push   $0x4e
  jmp alltraps
80107904:	e9 f9 f6 ff ff       	jmp    80107002 <alltraps>

80107909 <vector79>:
.globl vector79
vector79:
  pushl $0
80107909:	6a 00                	push   $0x0
  pushl $79
8010790b:	6a 4f                	push   $0x4f
  jmp alltraps
8010790d:	e9 f0 f6 ff ff       	jmp    80107002 <alltraps>

80107912 <vector80>:
.globl vector80
vector80:
  pushl $0
80107912:	6a 00                	push   $0x0
  pushl $80
80107914:	6a 50                	push   $0x50
  jmp alltraps
80107916:	e9 e7 f6 ff ff       	jmp    80107002 <alltraps>

8010791b <vector81>:
.globl vector81
vector81:
  pushl $0
8010791b:	6a 00                	push   $0x0
  pushl $81
8010791d:	6a 51                	push   $0x51
  jmp alltraps
8010791f:	e9 de f6 ff ff       	jmp    80107002 <alltraps>

80107924 <vector82>:
.globl vector82
vector82:
  pushl $0
80107924:	6a 00                	push   $0x0
  pushl $82
80107926:	6a 52                	push   $0x52
  jmp alltraps
80107928:	e9 d5 f6 ff ff       	jmp    80107002 <alltraps>

8010792d <vector83>:
.globl vector83
vector83:
  pushl $0
8010792d:	6a 00                	push   $0x0
  pushl $83
8010792f:	6a 53                	push   $0x53
  jmp alltraps
80107931:	e9 cc f6 ff ff       	jmp    80107002 <alltraps>

80107936 <vector84>:
.globl vector84
vector84:
  pushl $0
80107936:	6a 00                	push   $0x0
  pushl $84
80107938:	6a 54                	push   $0x54
  jmp alltraps
8010793a:	e9 c3 f6 ff ff       	jmp    80107002 <alltraps>

8010793f <vector85>:
.globl vector85
vector85:
  pushl $0
8010793f:	6a 00                	push   $0x0
  pushl $85
80107941:	6a 55                	push   $0x55
  jmp alltraps
80107943:	e9 ba f6 ff ff       	jmp    80107002 <alltraps>

80107948 <vector86>:
.globl vector86
vector86:
  pushl $0
80107948:	6a 00                	push   $0x0
  pushl $86
8010794a:	6a 56                	push   $0x56
  jmp alltraps
8010794c:	e9 b1 f6 ff ff       	jmp    80107002 <alltraps>

80107951 <vector87>:
.globl vector87
vector87:
  pushl $0
80107951:	6a 00                	push   $0x0
  pushl $87
80107953:	6a 57                	push   $0x57
  jmp alltraps
80107955:	e9 a8 f6 ff ff       	jmp    80107002 <alltraps>

8010795a <vector88>:
.globl vector88
vector88:
  pushl $0
8010795a:	6a 00                	push   $0x0
  pushl $88
8010795c:	6a 58                	push   $0x58
  jmp alltraps
8010795e:	e9 9f f6 ff ff       	jmp    80107002 <alltraps>

80107963 <vector89>:
.globl vector89
vector89:
  pushl $0
80107963:	6a 00                	push   $0x0
  pushl $89
80107965:	6a 59                	push   $0x59
  jmp alltraps
80107967:	e9 96 f6 ff ff       	jmp    80107002 <alltraps>

8010796c <vector90>:
.globl vector90
vector90:
  pushl $0
8010796c:	6a 00                	push   $0x0
  pushl $90
8010796e:	6a 5a                	push   $0x5a
  jmp alltraps
80107970:	e9 8d f6 ff ff       	jmp    80107002 <alltraps>

80107975 <vector91>:
.globl vector91
vector91:
  pushl $0
80107975:	6a 00                	push   $0x0
  pushl $91
80107977:	6a 5b                	push   $0x5b
  jmp alltraps
80107979:	e9 84 f6 ff ff       	jmp    80107002 <alltraps>

8010797e <vector92>:
.globl vector92
vector92:
  pushl $0
8010797e:	6a 00                	push   $0x0
  pushl $92
80107980:	6a 5c                	push   $0x5c
  jmp alltraps
80107982:	e9 7b f6 ff ff       	jmp    80107002 <alltraps>

80107987 <vector93>:
.globl vector93
vector93:
  pushl $0
80107987:	6a 00                	push   $0x0
  pushl $93
80107989:	6a 5d                	push   $0x5d
  jmp alltraps
8010798b:	e9 72 f6 ff ff       	jmp    80107002 <alltraps>

80107990 <vector94>:
.globl vector94
vector94:
  pushl $0
80107990:	6a 00                	push   $0x0
  pushl $94
80107992:	6a 5e                	push   $0x5e
  jmp alltraps
80107994:	e9 69 f6 ff ff       	jmp    80107002 <alltraps>

80107999 <vector95>:
.globl vector95
vector95:
  pushl $0
80107999:	6a 00                	push   $0x0
  pushl $95
8010799b:	6a 5f                	push   $0x5f
  jmp alltraps
8010799d:	e9 60 f6 ff ff       	jmp    80107002 <alltraps>

801079a2 <vector96>:
.globl vector96
vector96:
  pushl $0
801079a2:	6a 00                	push   $0x0
  pushl $96
801079a4:	6a 60                	push   $0x60
  jmp alltraps
801079a6:	e9 57 f6 ff ff       	jmp    80107002 <alltraps>

801079ab <vector97>:
.globl vector97
vector97:
  pushl $0
801079ab:	6a 00                	push   $0x0
  pushl $97
801079ad:	6a 61                	push   $0x61
  jmp alltraps
801079af:	e9 4e f6 ff ff       	jmp    80107002 <alltraps>

801079b4 <vector98>:
.globl vector98
vector98:
  pushl $0
801079b4:	6a 00                	push   $0x0
  pushl $98
801079b6:	6a 62                	push   $0x62
  jmp alltraps
801079b8:	e9 45 f6 ff ff       	jmp    80107002 <alltraps>

801079bd <vector99>:
.globl vector99
vector99:
  pushl $0
801079bd:	6a 00                	push   $0x0
  pushl $99
801079bf:	6a 63                	push   $0x63
  jmp alltraps
801079c1:	e9 3c f6 ff ff       	jmp    80107002 <alltraps>

801079c6 <vector100>:
.globl vector100
vector100:
  pushl $0
801079c6:	6a 00                	push   $0x0
  pushl $100
801079c8:	6a 64                	push   $0x64
  jmp alltraps
801079ca:	e9 33 f6 ff ff       	jmp    80107002 <alltraps>

801079cf <vector101>:
.globl vector101
vector101:
  pushl $0
801079cf:	6a 00                	push   $0x0
  pushl $101
801079d1:	6a 65                	push   $0x65
  jmp alltraps
801079d3:	e9 2a f6 ff ff       	jmp    80107002 <alltraps>

801079d8 <vector102>:
.globl vector102
vector102:
  pushl $0
801079d8:	6a 00                	push   $0x0
  pushl $102
801079da:	6a 66                	push   $0x66
  jmp alltraps
801079dc:	e9 21 f6 ff ff       	jmp    80107002 <alltraps>

801079e1 <vector103>:
.globl vector103
vector103:
  pushl $0
801079e1:	6a 00                	push   $0x0
  pushl $103
801079e3:	6a 67                	push   $0x67
  jmp alltraps
801079e5:	e9 18 f6 ff ff       	jmp    80107002 <alltraps>

801079ea <vector104>:
.globl vector104
vector104:
  pushl $0
801079ea:	6a 00                	push   $0x0
  pushl $104
801079ec:	6a 68                	push   $0x68
  jmp alltraps
801079ee:	e9 0f f6 ff ff       	jmp    80107002 <alltraps>

801079f3 <vector105>:
.globl vector105
vector105:
  pushl $0
801079f3:	6a 00                	push   $0x0
  pushl $105
801079f5:	6a 69                	push   $0x69
  jmp alltraps
801079f7:	e9 06 f6 ff ff       	jmp    80107002 <alltraps>

801079fc <vector106>:
.globl vector106
vector106:
  pushl $0
801079fc:	6a 00                	push   $0x0
  pushl $106
801079fe:	6a 6a                	push   $0x6a
  jmp alltraps
80107a00:	e9 fd f5 ff ff       	jmp    80107002 <alltraps>

80107a05 <vector107>:
.globl vector107
vector107:
  pushl $0
80107a05:	6a 00                	push   $0x0
  pushl $107
80107a07:	6a 6b                	push   $0x6b
  jmp alltraps
80107a09:	e9 f4 f5 ff ff       	jmp    80107002 <alltraps>

80107a0e <vector108>:
.globl vector108
vector108:
  pushl $0
80107a0e:	6a 00                	push   $0x0
  pushl $108
80107a10:	6a 6c                	push   $0x6c
  jmp alltraps
80107a12:	e9 eb f5 ff ff       	jmp    80107002 <alltraps>

80107a17 <vector109>:
.globl vector109
vector109:
  pushl $0
80107a17:	6a 00                	push   $0x0
  pushl $109
80107a19:	6a 6d                	push   $0x6d
  jmp alltraps
80107a1b:	e9 e2 f5 ff ff       	jmp    80107002 <alltraps>

80107a20 <vector110>:
.globl vector110
vector110:
  pushl $0
80107a20:	6a 00                	push   $0x0
  pushl $110
80107a22:	6a 6e                	push   $0x6e
  jmp alltraps
80107a24:	e9 d9 f5 ff ff       	jmp    80107002 <alltraps>

80107a29 <vector111>:
.globl vector111
vector111:
  pushl $0
80107a29:	6a 00                	push   $0x0
  pushl $111
80107a2b:	6a 6f                	push   $0x6f
  jmp alltraps
80107a2d:	e9 d0 f5 ff ff       	jmp    80107002 <alltraps>

80107a32 <vector112>:
.globl vector112
vector112:
  pushl $0
80107a32:	6a 00                	push   $0x0
  pushl $112
80107a34:	6a 70                	push   $0x70
  jmp alltraps
80107a36:	e9 c7 f5 ff ff       	jmp    80107002 <alltraps>

80107a3b <vector113>:
.globl vector113
vector113:
  pushl $0
80107a3b:	6a 00                	push   $0x0
  pushl $113
80107a3d:	6a 71                	push   $0x71
  jmp alltraps
80107a3f:	e9 be f5 ff ff       	jmp    80107002 <alltraps>

80107a44 <vector114>:
.globl vector114
vector114:
  pushl $0
80107a44:	6a 00                	push   $0x0
  pushl $114
80107a46:	6a 72                	push   $0x72
  jmp alltraps
80107a48:	e9 b5 f5 ff ff       	jmp    80107002 <alltraps>

80107a4d <vector115>:
.globl vector115
vector115:
  pushl $0
80107a4d:	6a 00                	push   $0x0
  pushl $115
80107a4f:	6a 73                	push   $0x73
  jmp alltraps
80107a51:	e9 ac f5 ff ff       	jmp    80107002 <alltraps>

80107a56 <vector116>:
.globl vector116
vector116:
  pushl $0
80107a56:	6a 00                	push   $0x0
  pushl $116
80107a58:	6a 74                	push   $0x74
  jmp alltraps
80107a5a:	e9 a3 f5 ff ff       	jmp    80107002 <alltraps>

80107a5f <vector117>:
.globl vector117
vector117:
  pushl $0
80107a5f:	6a 00                	push   $0x0
  pushl $117
80107a61:	6a 75                	push   $0x75
  jmp alltraps
80107a63:	e9 9a f5 ff ff       	jmp    80107002 <alltraps>

80107a68 <vector118>:
.globl vector118
vector118:
  pushl $0
80107a68:	6a 00                	push   $0x0
  pushl $118
80107a6a:	6a 76                	push   $0x76
  jmp alltraps
80107a6c:	e9 91 f5 ff ff       	jmp    80107002 <alltraps>

80107a71 <vector119>:
.globl vector119
vector119:
  pushl $0
80107a71:	6a 00                	push   $0x0
  pushl $119
80107a73:	6a 77                	push   $0x77
  jmp alltraps
80107a75:	e9 88 f5 ff ff       	jmp    80107002 <alltraps>

80107a7a <vector120>:
.globl vector120
vector120:
  pushl $0
80107a7a:	6a 00                	push   $0x0
  pushl $120
80107a7c:	6a 78                	push   $0x78
  jmp alltraps
80107a7e:	e9 7f f5 ff ff       	jmp    80107002 <alltraps>

80107a83 <vector121>:
.globl vector121
vector121:
  pushl $0
80107a83:	6a 00                	push   $0x0
  pushl $121
80107a85:	6a 79                	push   $0x79
  jmp alltraps
80107a87:	e9 76 f5 ff ff       	jmp    80107002 <alltraps>

80107a8c <vector122>:
.globl vector122
vector122:
  pushl $0
80107a8c:	6a 00                	push   $0x0
  pushl $122
80107a8e:	6a 7a                	push   $0x7a
  jmp alltraps
80107a90:	e9 6d f5 ff ff       	jmp    80107002 <alltraps>

80107a95 <vector123>:
.globl vector123
vector123:
  pushl $0
80107a95:	6a 00                	push   $0x0
  pushl $123
80107a97:	6a 7b                	push   $0x7b
  jmp alltraps
80107a99:	e9 64 f5 ff ff       	jmp    80107002 <alltraps>

80107a9e <vector124>:
.globl vector124
vector124:
  pushl $0
80107a9e:	6a 00                	push   $0x0
  pushl $124
80107aa0:	6a 7c                	push   $0x7c
  jmp alltraps
80107aa2:	e9 5b f5 ff ff       	jmp    80107002 <alltraps>

80107aa7 <vector125>:
.globl vector125
vector125:
  pushl $0
80107aa7:	6a 00                	push   $0x0
  pushl $125
80107aa9:	6a 7d                	push   $0x7d
  jmp alltraps
80107aab:	e9 52 f5 ff ff       	jmp    80107002 <alltraps>

80107ab0 <vector126>:
.globl vector126
vector126:
  pushl $0
80107ab0:	6a 00                	push   $0x0
  pushl $126
80107ab2:	6a 7e                	push   $0x7e
  jmp alltraps
80107ab4:	e9 49 f5 ff ff       	jmp    80107002 <alltraps>

80107ab9 <vector127>:
.globl vector127
vector127:
  pushl $0
80107ab9:	6a 00                	push   $0x0
  pushl $127
80107abb:	6a 7f                	push   $0x7f
  jmp alltraps
80107abd:	e9 40 f5 ff ff       	jmp    80107002 <alltraps>

80107ac2 <vector128>:
.globl vector128
vector128:
  pushl $0
80107ac2:	6a 00                	push   $0x0
  pushl $128
80107ac4:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107ac9:	e9 34 f5 ff ff       	jmp    80107002 <alltraps>

80107ace <vector129>:
.globl vector129
vector129:
  pushl $0
80107ace:	6a 00                	push   $0x0
  pushl $129
80107ad0:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80107ad5:	e9 28 f5 ff ff       	jmp    80107002 <alltraps>

80107ada <vector130>:
.globl vector130
vector130:
  pushl $0
80107ada:	6a 00                	push   $0x0
  pushl $130
80107adc:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107ae1:	e9 1c f5 ff ff       	jmp    80107002 <alltraps>

80107ae6 <vector131>:
.globl vector131
vector131:
  pushl $0
80107ae6:	6a 00                	push   $0x0
  pushl $131
80107ae8:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107aed:	e9 10 f5 ff ff       	jmp    80107002 <alltraps>

80107af2 <vector132>:
.globl vector132
vector132:
  pushl $0
80107af2:	6a 00                	push   $0x0
  pushl $132
80107af4:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107af9:	e9 04 f5 ff ff       	jmp    80107002 <alltraps>

80107afe <vector133>:
.globl vector133
vector133:
  pushl $0
80107afe:	6a 00                	push   $0x0
  pushl $133
80107b00:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80107b05:	e9 f8 f4 ff ff       	jmp    80107002 <alltraps>

80107b0a <vector134>:
.globl vector134
vector134:
  pushl $0
80107b0a:	6a 00                	push   $0x0
  pushl $134
80107b0c:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107b11:	e9 ec f4 ff ff       	jmp    80107002 <alltraps>

80107b16 <vector135>:
.globl vector135
vector135:
  pushl $0
80107b16:	6a 00                	push   $0x0
  pushl $135
80107b18:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107b1d:	e9 e0 f4 ff ff       	jmp    80107002 <alltraps>

80107b22 <vector136>:
.globl vector136
vector136:
  pushl $0
80107b22:	6a 00                	push   $0x0
  pushl $136
80107b24:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107b29:	e9 d4 f4 ff ff       	jmp    80107002 <alltraps>

80107b2e <vector137>:
.globl vector137
vector137:
  pushl $0
80107b2e:	6a 00                	push   $0x0
  pushl $137
80107b30:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80107b35:	e9 c8 f4 ff ff       	jmp    80107002 <alltraps>

80107b3a <vector138>:
.globl vector138
vector138:
  pushl $0
80107b3a:	6a 00                	push   $0x0
  pushl $138
80107b3c:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107b41:	e9 bc f4 ff ff       	jmp    80107002 <alltraps>

80107b46 <vector139>:
.globl vector139
vector139:
  pushl $0
80107b46:	6a 00                	push   $0x0
  pushl $139
80107b48:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107b4d:	e9 b0 f4 ff ff       	jmp    80107002 <alltraps>

80107b52 <vector140>:
.globl vector140
vector140:
  pushl $0
80107b52:	6a 00                	push   $0x0
  pushl $140
80107b54:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107b59:	e9 a4 f4 ff ff       	jmp    80107002 <alltraps>

80107b5e <vector141>:
.globl vector141
vector141:
  pushl $0
80107b5e:	6a 00                	push   $0x0
  pushl $141
80107b60:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80107b65:	e9 98 f4 ff ff       	jmp    80107002 <alltraps>

80107b6a <vector142>:
.globl vector142
vector142:
  pushl $0
80107b6a:	6a 00                	push   $0x0
  pushl $142
80107b6c:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107b71:	e9 8c f4 ff ff       	jmp    80107002 <alltraps>

80107b76 <vector143>:
.globl vector143
vector143:
  pushl $0
80107b76:	6a 00                	push   $0x0
  pushl $143
80107b78:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107b7d:	e9 80 f4 ff ff       	jmp    80107002 <alltraps>

80107b82 <vector144>:
.globl vector144
vector144:
  pushl $0
80107b82:	6a 00                	push   $0x0
  pushl $144
80107b84:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107b89:	e9 74 f4 ff ff       	jmp    80107002 <alltraps>

80107b8e <vector145>:
.globl vector145
vector145:
  pushl $0
80107b8e:	6a 00                	push   $0x0
  pushl $145
80107b90:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107b95:	e9 68 f4 ff ff       	jmp    80107002 <alltraps>

80107b9a <vector146>:
.globl vector146
vector146:
  pushl $0
80107b9a:	6a 00                	push   $0x0
  pushl $146
80107b9c:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107ba1:	e9 5c f4 ff ff       	jmp    80107002 <alltraps>

80107ba6 <vector147>:
.globl vector147
vector147:
  pushl $0
80107ba6:	6a 00                	push   $0x0
  pushl $147
80107ba8:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107bad:	e9 50 f4 ff ff       	jmp    80107002 <alltraps>

80107bb2 <vector148>:
.globl vector148
vector148:
  pushl $0
80107bb2:	6a 00                	push   $0x0
  pushl $148
80107bb4:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107bb9:	e9 44 f4 ff ff       	jmp    80107002 <alltraps>

80107bbe <vector149>:
.globl vector149
vector149:
  pushl $0
80107bbe:	6a 00                	push   $0x0
  pushl $149
80107bc0:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107bc5:	e9 38 f4 ff ff       	jmp    80107002 <alltraps>

80107bca <vector150>:
.globl vector150
vector150:
  pushl $0
80107bca:	6a 00                	push   $0x0
  pushl $150
80107bcc:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107bd1:	e9 2c f4 ff ff       	jmp    80107002 <alltraps>

80107bd6 <vector151>:
.globl vector151
vector151:
  pushl $0
80107bd6:	6a 00                	push   $0x0
  pushl $151
80107bd8:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107bdd:	e9 20 f4 ff ff       	jmp    80107002 <alltraps>

80107be2 <vector152>:
.globl vector152
vector152:
  pushl $0
80107be2:	6a 00                	push   $0x0
  pushl $152
80107be4:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107be9:	e9 14 f4 ff ff       	jmp    80107002 <alltraps>

80107bee <vector153>:
.globl vector153
vector153:
  pushl $0
80107bee:	6a 00                	push   $0x0
  pushl $153
80107bf0:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80107bf5:	e9 08 f4 ff ff       	jmp    80107002 <alltraps>

80107bfa <vector154>:
.globl vector154
vector154:
  pushl $0
80107bfa:	6a 00                	push   $0x0
  pushl $154
80107bfc:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107c01:	e9 fc f3 ff ff       	jmp    80107002 <alltraps>

80107c06 <vector155>:
.globl vector155
vector155:
  pushl $0
80107c06:	6a 00                	push   $0x0
  pushl $155
80107c08:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107c0d:	e9 f0 f3 ff ff       	jmp    80107002 <alltraps>

80107c12 <vector156>:
.globl vector156
vector156:
  pushl $0
80107c12:	6a 00                	push   $0x0
  pushl $156
80107c14:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107c19:	e9 e4 f3 ff ff       	jmp    80107002 <alltraps>

80107c1e <vector157>:
.globl vector157
vector157:
  pushl $0
80107c1e:	6a 00                	push   $0x0
  pushl $157
80107c20:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80107c25:	e9 d8 f3 ff ff       	jmp    80107002 <alltraps>

80107c2a <vector158>:
.globl vector158
vector158:
  pushl $0
80107c2a:	6a 00                	push   $0x0
  pushl $158
80107c2c:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107c31:	e9 cc f3 ff ff       	jmp    80107002 <alltraps>

80107c36 <vector159>:
.globl vector159
vector159:
  pushl $0
80107c36:	6a 00                	push   $0x0
  pushl $159
80107c38:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107c3d:	e9 c0 f3 ff ff       	jmp    80107002 <alltraps>

80107c42 <vector160>:
.globl vector160
vector160:
  pushl $0
80107c42:	6a 00                	push   $0x0
  pushl $160
80107c44:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107c49:	e9 b4 f3 ff ff       	jmp    80107002 <alltraps>

80107c4e <vector161>:
.globl vector161
vector161:
  pushl $0
80107c4e:	6a 00                	push   $0x0
  pushl $161
80107c50:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80107c55:	e9 a8 f3 ff ff       	jmp    80107002 <alltraps>

80107c5a <vector162>:
.globl vector162
vector162:
  pushl $0
80107c5a:	6a 00                	push   $0x0
  pushl $162
80107c5c:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107c61:	e9 9c f3 ff ff       	jmp    80107002 <alltraps>

80107c66 <vector163>:
.globl vector163
vector163:
  pushl $0
80107c66:	6a 00                	push   $0x0
  pushl $163
80107c68:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107c6d:	e9 90 f3 ff ff       	jmp    80107002 <alltraps>

80107c72 <vector164>:
.globl vector164
vector164:
  pushl $0
80107c72:	6a 00                	push   $0x0
  pushl $164
80107c74:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107c79:	e9 84 f3 ff ff       	jmp    80107002 <alltraps>

80107c7e <vector165>:
.globl vector165
vector165:
  pushl $0
80107c7e:	6a 00                	push   $0x0
  pushl $165
80107c80:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107c85:	e9 78 f3 ff ff       	jmp    80107002 <alltraps>

80107c8a <vector166>:
.globl vector166
vector166:
  pushl $0
80107c8a:	6a 00                	push   $0x0
  pushl $166
80107c8c:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107c91:	e9 6c f3 ff ff       	jmp    80107002 <alltraps>

80107c96 <vector167>:
.globl vector167
vector167:
  pushl $0
80107c96:	6a 00                	push   $0x0
  pushl $167
80107c98:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107c9d:	e9 60 f3 ff ff       	jmp    80107002 <alltraps>

80107ca2 <vector168>:
.globl vector168
vector168:
  pushl $0
80107ca2:	6a 00                	push   $0x0
  pushl $168
80107ca4:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107ca9:	e9 54 f3 ff ff       	jmp    80107002 <alltraps>

80107cae <vector169>:
.globl vector169
vector169:
  pushl $0
80107cae:	6a 00                	push   $0x0
  pushl $169
80107cb0:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107cb5:	e9 48 f3 ff ff       	jmp    80107002 <alltraps>

80107cba <vector170>:
.globl vector170
vector170:
  pushl $0
80107cba:	6a 00                	push   $0x0
  pushl $170
80107cbc:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107cc1:	e9 3c f3 ff ff       	jmp    80107002 <alltraps>

80107cc6 <vector171>:
.globl vector171
vector171:
  pushl $0
80107cc6:	6a 00                	push   $0x0
  pushl $171
80107cc8:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107ccd:	e9 30 f3 ff ff       	jmp    80107002 <alltraps>

80107cd2 <vector172>:
.globl vector172
vector172:
  pushl $0
80107cd2:	6a 00                	push   $0x0
  pushl $172
80107cd4:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107cd9:	e9 24 f3 ff ff       	jmp    80107002 <alltraps>

80107cde <vector173>:
.globl vector173
vector173:
  pushl $0
80107cde:	6a 00                	push   $0x0
  pushl $173
80107ce0:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107ce5:	e9 18 f3 ff ff       	jmp    80107002 <alltraps>

80107cea <vector174>:
.globl vector174
vector174:
  pushl $0
80107cea:	6a 00                	push   $0x0
  pushl $174
80107cec:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107cf1:	e9 0c f3 ff ff       	jmp    80107002 <alltraps>

80107cf6 <vector175>:
.globl vector175
vector175:
  pushl $0
80107cf6:	6a 00                	push   $0x0
  pushl $175
80107cf8:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107cfd:	e9 00 f3 ff ff       	jmp    80107002 <alltraps>

80107d02 <vector176>:
.globl vector176
vector176:
  pushl $0
80107d02:	6a 00                	push   $0x0
  pushl $176
80107d04:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107d09:	e9 f4 f2 ff ff       	jmp    80107002 <alltraps>

80107d0e <vector177>:
.globl vector177
vector177:
  pushl $0
80107d0e:	6a 00                	push   $0x0
  pushl $177
80107d10:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107d15:	e9 e8 f2 ff ff       	jmp    80107002 <alltraps>

80107d1a <vector178>:
.globl vector178
vector178:
  pushl $0
80107d1a:	6a 00                	push   $0x0
  pushl $178
80107d1c:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107d21:	e9 dc f2 ff ff       	jmp    80107002 <alltraps>

80107d26 <vector179>:
.globl vector179
vector179:
  pushl $0
80107d26:	6a 00                	push   $0x0
  pushl $179
80107d28:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107d2d:	e9 d0 f2 ff ff       	jmp    80107002 <alltraps>

80107d32 <vector180>:
.globl vector180
vector180:
  pushl $0
80107d32:	6a 00                	push   $0x0
  pushl $180
80107d34:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107d39:	e9 c4 f2 ff ff       	jmp    80107002 <alltraps>

80107d3e <vector181>:
.globl vector181
vector181:
  pushl $0
80107d3e:	6a 00                	push   $0x0
  pushl $181
80107d40:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107d45:	e9 b8 f2 ff ff       	jmp    80107002 <alltraps>

80107d4a <vector182>:
.globl vector182
vector182:
  pushl $0
80107d4a:	6a 00                	push   $0x0
  pushl $182
80107d4c:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107d51:	e9 ac f2 ff ff       	jmp    80107002 <alltraps>

80107d56 <vector183>:
.globl vector183
vector183:
  pushl $0
80107d56:	6a 00                	push   $0x0
  pushl $183
80107d58:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107d5d:	e9 a0 f2 ff ff       	jmp    80107002 <alltraps>

80107d62 <vector184>:
.globl vector184
vector184:
  pushl $0
80107d62:	6a 00                	push   $0x0
  pushl $184
80107d64:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107d69:	e9 94 f2 ff ff       	jmp    80107002 <alltraps>

80107d6e <vector185>:
.globl vector185
vector185:
  pushl $0
80107d6e:	6a 00                	push   $0x0
  pushl $185
80107d70:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107d75:	e9 88 f2 ff ff       	jmp    80107002 <alltraps>

80107d7a <vector186>:
.globl vector186
vector186:
  pushl $0
80107d7a:	6a 00                	push   $0x0
  pushl $186
80107d7c:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107d81:	e9 7c f2 ff ff       	jmp    80107002 <alltraps>

80107d86 <vector187>:
.globl vector187
vector187:
  pushl $0
80107d86:	6a 00                	push   $0x0
  pushl $187
80107d88:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107d8d:	e9 70 f2 ff ff       	jmp    80107002 <alltraps>

80107d92 <vector188>:
.globl vector188
vector188:
  pushl $0
80107d92:	6a 00                	push   $0x0
  pushl $188
80107d94:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107d99:	e9 64 f2 ff ff       	jmp    80107002 <alltraps>

80107d9e <vector189>:
.globl vector189
vector189:
  pushl $0
80107d9e:	6a 00                	push   $0x0
  pushl $189
80107da0:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107da5:	e9 58 f2 ff ff       	jmp    80107002 <alltraps>

80107daa <vector190>:
.globl vector190
vector190:
  pushl $0
80107daa:	6a 00                	push   $0x0
  pushl $190
80107dac:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107db1:	e9 4c f2 ff ff       	jmp    80107002 <alltraps>

80107db6 <vector191>:
.globl vector191
vector191:
  pushl $0
80107db6:	6a 00                	push   $0x0
  pushl $191
80107db8:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107dbd:	e9 40 f2 ff ff       	jmp    80107002 <alltraps>

80107dc2 <vector192>:
.globl vector192
vector192:
  pushl $0
80107dc2:	6a 00                	push   $0x0
  pushl $192
80107dc4:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107dc9:	e9 34 f2 ff ff       	jmp    80107002 <alltraps>

80107dce <vector193>:
.globl vector193
vector193:
  pushl $0
80107dce:	6a 00                	push   $0x0
  pushl $193
80107dd0:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107dd5:	e9 28 f2 ff ff       	jmp    80107002 <alltraps>

80107dda <vector194>:
.globl vector194
vector194:
  pushl $0
80107dda:	6a 00                	push   $0x0
  pushl $194
80107ddc:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107de1:	e9 1c f2 ff ff       	jmp    80107002 <alltraps>

80107de6 <vector195>:
.globl vector195
vector195:
  pushl $0
80107de6:	6a 00                	push   $0x0
  pushl $195
80107de8:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107ded:	e9 10 f2 ff ff       	jmp    80107002 <alltraps>

80107df2 <vector196>:
.globl vector196
vector196:
  pushl $0
80107df2:	6a 00                	push   $0x0
  pushl $196
80107df4:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107df9:	e9 04 f2 ff ff       	jmp    80107002 <alltraps>

80107dfe <vector197>:
.globl vector197
vector197:
  pushl $0
80107dfe:	6a 00                	push   $0x0
  pushl $197
80107e00:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107e05:	e9 f8 f1 ff ff       	jmp    80107002 <alltraps>

80107e0a <vector198>:
.globl vector198
vector198:
  pushl $0
80107e0a:	6a 00                	push   $0x0
  pushl $198
80107e0c:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107e11:	e9 ec f1 ff ff       	jmp    80107002 <alltraps>

80107e16 <vector199>:
.globl vector199
vector199:
  pushl $0
80107e16:	6a 00                	push   $0x0
  pushl $199
80107e18:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107e1d:	e9 e0 f1 ff ff       	jmp    80107002 <alltraps>

80107e22 <vector200>:
.globl vector200
vector200:
  pushl $0
80107e22:	6a 00                	push   $0x0
  pushl $200
80107e24:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107e29:	e9 d4 f1 ff ff       	jmp    80107002 <alltraps>

80107e2e <vector201>:
.globl vector201
vector201:
  pushl $0
80107e2e:	6a 00                	push   $0x0
  pushl $201
80107e30:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107e35:	e9 c8 f1 ff ff       	jmp    80107002 <alltraps>

80107e3a <vector202>:
.globl vector202
vector202:
  pushl $0
80107e3a:	6a 00                	push   $0x0
  pushl $202
80107e3c:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107e41:	e9 bc f1 ff ff       	jmp    80107002 <alltraps>

80107e46 <vector203>:
.globl vector203
vector203:
  pushl $0
80107e46:	6a 00                	push   $0x0
  pushl $203
80107e48:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107e4d:	e9 b0 f1 ff ff       	jmp    80107002 <alltraps>

80107e52 <vector204>:
.globl vector204
vector204:
  pushl $0
80107e52:	6a 00                	push   $0x0
  pushl $204
80107e54:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107e59:	e9 a4 f1 ff ff       	jmp    80107002 <alltraps>

80107e5e <vector205>:
.globl vector205
vector205:
  pushl $0
80107e5e:	6a 00                	push   $0x0
  pushl $205
80107e60:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107e65:	e9 98 f1 ff ff       	jmp    80107002 <alltraps>

80107e6a <vector206>:
.globl vector206
vector206:
  pushl $0
80107e6a:	6a 00                	push   $0x0
  pushl $206
80107e6c:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107e71:	e9 8c f1 ff ff       	jmp    80107002 <alltraps>

80107e76 <vector207>:
.globl vector207
vector207:
  pushl $0
80107e76:	6a 00                	push   $0x0
  pushl $207
80107e78:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107e7d:	e9 80 f1 ff ff       	jmp    80107002 <alltraps>

80107e82 <vector208>:
.globl vector208
vector208:
  pushl $0
80107e82:	6a 00                	push   $0x0
  pushl $208
80107e84:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107e89:	e9 74 f1 ff ff       	jmp    80107002 <alltraps>

80107e8e <vector209>:
.globl vector209
vector209:
  pushl $0
80107e8e:	6a 00                	push   $0x0
  pushl $209
80107e90:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107e95:	e9 68 f1 ff ff       	jmp    80107002 <alltraps>

80107e9a <vector210>:
.globl vector210
vector210:
  pushl $0
80107e9a:	6a 00                	push   $0x0
  pushl $210
80107e9c:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107ea1:	e9 5c f1 ff ff       	jmp    80107002 <alltraps>

80107ea6 <vector211>:
.globl vector211
vector211:
  pushl $0
80107ea6:	6a 00                	push   $0x0
  pushl $211
80107ea8:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107ead:	e9 50 f1 ff ff       	jmp    80107002 <alltraps>

80107eb2 <vector212>:
.globl vector212
vector212:
  pushl $0
80107eb2:	6a 00                	push   $0x0
  pushl $212
80107eb4:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107eb9:	e9 44 f1 ff ff       	jmp    80107002 <alltraps>

80107ebe <vector213>:
.globl vector213
vector213:
  pushl $0
80107ebe:	6a 00                	push   $0x0
  pushl $213
80107ec0:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107ec5:	e9 38 f1 ff ff       	jmp    80107002 <alltraps>

80107eca <vector214>:
.globl vector214
vector214:
  pushl $0
80107eca:	6a 00                	push   $0x0
  pushl $214
80107ecc:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107ed1:	e9 2c f1 ff ff       	jmp    80107002 <alltraps>

80107ed6 <vector215>:
.globl vector215
vector215:
  pushl $0
80107ed6:	6a 00                	push   $0x0
  pushl $215
80107ed8:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107edd:	e9 20 f1 ff ff       	jmp    80107002 <alltraps>

80107ee2 <vector216>:
.globl vector216
vector216:
  pushl $0
80107ee2:	6a 00                	push   $0x0
  pushl $216
80107ee4:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107ee9:	e9 14 f1 ff ff       	jmp    80107002 <alltraps>

80107eee <vector217>:
.globl vector217
vector217:
  pushl $0
80107eee:	6a 00                	push   $0x0
  pushl $217
80107ef0:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107ef5:	e9 08 f1 ff ff       	jmp    80107002 <alltraps>

80107efa <vector218>:
.globl vector218
vector218:
  pushl $0
80107efa:	6a 00                	push   $0x0
  pushl $218
80107efc:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107f01:	e9 fc f0 ff ff       	jmp    80107002 <alltraps>

80107f06 <vector219>:
.globl vector219
vector219:
  pushl $0
80107f06:	6a 00                	push   $0x0
  pushl $219
80107f08:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107f0d:	e9 f0 f0 ff ff       	jmp    80107002 <alltraps>

80107f12 <vector220>:
.globl vector220
vector220:
  pushl $0
80107f12:	6a 00                	push   $0x0
  pushl $220
80107f14:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107f19:	e9 e4 f0 ff ff       	jmp    80107002 <alltraps>

80107f1e <vector221>:
.globl vector221
vector221:
  pushl $0
80107f1e:	6a 00                	push   $0x0
  pushl $221
80107f20:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107f25:	e9 d8 f0 ff ff       	jmp    80107002 <alltraps>

80107f2a <vector222>:
.globl vector222
vector222:
  pushl $0
80107f2a:	6a 00                	push   $0x0
  pushl $222
80107f2c:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107f31:	e9 cc f0 ff ff       	jmp    80107002 <alltraps>

80107f36 <vector223>:
.globl vector223
vector223:
  pushl $0
80107f36:	6a 00                	push   $0x0
  pushl $223
80107f38:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107f3d:	e9 c0 f0 ff ff       	jmp    80107002 <alltraps>

80107f42 <vector224>:
.globl vector224
vector224:
  pushl $0
80107f42:	6a 00                	push   $0x0
  pushl $224
80107f44:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107f49:	e9 b4 f0 ff ff       	jmp    80107002 <alltraps>

80107f4e <vector225>:
.globl vector225
vector225:
  pushl $0
80107f4e:	6a 00                	push   $0x0
  pushl $225
80107f50:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107f55:	e9 a8 f0 ff ff       	jmp    80107002 <alltraps>

80107f5a <vector226>:
.globl vector226
vector226:
  pushl $0
80107f5a:	6a 00                	push   $0x0
  pushl $226
80107f5c:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107f61:	e9 9c f0 ff ff       	jmp    80107002 <alltraps>

80107f66 <vector227>:
.globl vector227
vector227:
  pushl $0
80107f66:	6a 00                	push   $0x0
  pushl $227
80107f68:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107f6d:	e9 90 f0 ff ff       	jmp    80107002 <alltraps>

80107f72 <vector228>:
.globl vector228
vector228:
  pushl $0
80107f72:	6a 00                	push   $0x0
  pushl $228
80107f74:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107f79:	e9 84 f0 ff ff       	jmp    80107002 <alltraps>

80107f7e <vector229>:
.globl vector229
vector229:
  pushl $0
80107f7e:	6a 00                	push   $0x0
  pushl $229
80107f80:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107f85:	e9 78 f0 ff ff       	jmp    80107002 <alltraps>

80107f8a <vector230>:
.globl vector230
vector230:
  pushl $0
80107f8a:	6a 00                	push   $0x0
  pushl $230
80107f8c:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107f91:	e9 6c f0 ff ff       	jmp    80107002 <alltraps>

80107f96 <vector231>:
.globl vector231
vector231:
  pushl $0
80107f96:	6a 00                	push   $0x0
  pushl $231
80107f98:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107f9d:	e9 60 f0 ff ff       	jmp    80107002 <alltraps>

80107fa2 <vector232>:
.globl vector232
vector232:
  pushl $0
80107fa2:	6a 00                	push   $0x0
  pushl $232
80107fa4:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107fa9:	e9 54 f0 ff ff       	jmp    80107002 <alltraps>

80107fae <vector233>:
.globl vector233
vector233:
  pushl $0
80107fae:	6a 00                	push   $0x0
  pushl $233
80107fb0:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107fb5:	e9 48 f0 ff ff       	jmp    80107002 <alltraps>

80107fba <vector234>:
.globl vector234
vector234:
  pushl $0
80107fba:	6a 00                	push   $0x0
  pushl $234
80107fbc:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107fc1:	e9 3c f0 ff ff       	jmp    80107002 <alltraps>

80107fc6 <vector235>:
.globl vector235
vector235:
  pushl $0
80107fc6:	6a 00                	push   $0x0
  pushl $235
80107fc8:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107fcd:	e9 30 f0 ff ff       	jmp    80107002 <alltraps>

80107fd2 <vector236>:
.globl vector236
vector236:
  pushl $0
80107fd2:	6a 00                	push   $0x0
  pushl $236
80107fd4:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107fd9:	e9 24 f0 ff ff       	jmp    80107002 <alltraps>

80107fde <vector237>:
.globl vector237
vector237:
  pushl $0
80107fde:	6a 00                	push   $0x0
  pushl $237
80107fe0:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107fe5:	e9 18 f0 ff ff       	jmp    80107002 <alltraps>

80107fea <vector238>:
.globl vector238
vector238:
  pushl $0
80107fea:	6a 00                	push   $0x0
  pushl $238
80107fec:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107ff1:	e9 0c f0 ff ff       	jmp    80107002 <alltraps>

80107ff6 <vector239>:
.globl vector239
vector239:
  pushl $0
80107ff6:	6a 00                	push   $0x0
  pushl $239
80107ff8:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107ffd:	e9 00 f0 ff ff       	jmp    80107002 <alltraps>

80108002 <vector240>:
.globl vector240
vector240:
  pushl $0
80108002:	6a 00                	push   $0x0
  pushl $240
80108004:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80108009:	e9 f4 ef ff ff       	jmp    80107002 <alltraps>

8010800e <vector241>:
.globl vector241
vector241:
  pushl $0
8010800e:	6a 00                	push   $0x0
  pushl $241
80108010:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80108015:	e9 e8 ef ff ff       	jmp    80107002 <alltraps>

8010801a <vector242>:
.globl vector242
vector242:
  pushl $0
8010801a:	6a 00                	push   $0x0
  pushl $242
8010801c:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80108021:	e9 dc ef ff ff       	jmp    80107002 <alltraps>

80108026 <vector243>:
.globl vector243
vector243:
  pushl $0
80108026:	6a 00                	push   $0x0
  pushl $243
80108028:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
8010802d:	e9 d0 ef ff ff       	jmp    80107002 <alltraps>

80108032 <vector244>:
.globl vector244
vector244:
  pushl $0
80108032:	6a 00                	push   $0x0
  pushl $244
80108034:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80108039:	e9 c4 ef ff ff       	jmp    80107002 <alltraps>

8010803e <vector245>:
.globl vector245
vector245:
  pushl $0
8010803e:	6a 00                	push   $0x0
  pushl $245
80108040:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80108045:	e9 b8 ef ff ff       	jmp    80107002 <alltraps>

8010804a <vector246>:
.globl vector246
vector246:
  pushl $0
8010804a:	6a 00                	push   $0x0
  pushl $246
8010804c:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80108051:	e9 ac ef ff ff       	jmp    80107002 <alltraps>

80108056 <vector247>:
.globl vector247
vector247:
  pushl $0
80108056:	6a 00                	push   $0x0
  pushl $247
80108058:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
8010805d:	e9 a0 ef ff ff       	jmp    80107002 <alltraps>

80108062 <vector248>:
.globl vector248
vector248:
  pushl $0
80108062:	6a 00                	push   $0x0
  pushl $248
80108064:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80108069:	e9 94 ef ff ff       	jmp    80107002 <alltraps>

8010806e <vector249>:
.globl vector249
vector249:
  pushl $0
8010806e:	6a 00                	push   $0x0
  pushl $249
80108070:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80108075:	e9 88 ef ff ff       	jmp    80107002 <alltraps>

8010807a <vector250>:
.globl vector250
vector250:
  pushl $0
8010807a:	6a 00                	push   $0x0
  pushl $250
8010807c:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80108081:	e9 7c ef ff ff       	jmp    80107002 <alltraps>

80108086 <vector251>:
.globl vector251
vector251:
  pushl $0
80108086:	6a 00                	push   $0x0
  pushl $251
80108088:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
8010808d:	e9 70 ef ff ff       	jmp    80107002 <alltraps>

80108092 <vector252>:
.globl vector252
vector252:
  pushl $0
80108092:	6a 00                	push   $0x0
  pushl $252
80108094:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80108099:	e9 64 ef ff ff       	jmp    80107002 <alltraps>

8010809e <vector253>:
.globl vector253
vector253:
  pushl $0
8010809e:	6a 00                	push   $0x0
  pushl $253
801080a0:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801080a5:	e9 58 ef ff ff       	jmp    80107002 <alltraps>

801080aa <vector254>:
.globl vector254
vector254:
  pushl $0
801080aa:	6a 00                	push   $0x0
  pushl $254
801080ac:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801080b1:	e9 4c ef ff ff       	jmp    80107002 <alltraps>

801080b6 <vector255>:
.globl vector255
vector255:
  pushl $0
801080b6:	6a 00                	push   $0x0
  pushl $255
801080b8:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801080bd:	e9 40 ef ff ff       	jmp    80107002 <alltraps>

801080c2 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
801080c2:	55                   	push   %ebp
801080c3:	89 e5                	mov    %esp,%ebp
801080c5:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801080c8:	8b 45 0c             	mov    0xc(%ebp),%eax
801080cb:	83 e8 01             	sub    $0x1,%eax
801080ce:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801080d2:	8b 45 08             	mov    0x8(%ebp),%eax
801080d5:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801080d9:	8b 45 08             	mov    0x8(%ebp),%eax
801080dc:	c1 e8 10             	shr    $0x10,%eax
801080df:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
801080e3:	8d 45 fa             	lea    -0x6(%ebp),%eax
801080e6:	0f 01 10             	lgdtl  (%eax)
}
801080e9:	90                   	nop
801080ea:	c9                   	leave  
801080eb:	c3                   	ret    

801080ec <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
801080ec:	55                   	push   %ebp
801080ed:	89 e5                	mov    %esp,%ebp
801080ef:	83 ec 04             	sub    $0x4,%esp
801080f2:	8b 45 08             	mov    0x8(%ebp),%eax
801080f5:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
801080f9:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801080fd:	0f 00 d8             	ltr    %ax
}
80108100:	90                   	nop
80108101:	c9                   	leave  
80108102:	c3                   	ret    

80108103 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80108103:	55                   	push   %ebp
80108104:	89 e5                	mov    %esp,%ebp
80108106:	83 ec 04             	sub    $0x4,%esp
80108109:	8b 45 08             	mov    0x8(%ebp),%eax
8010810c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80108110:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80108114:	8e e8                	mov    %eax,%gs
}
80108116:	90                   	nop
80108117:	c9                   	leave  
80108118:	c3                   	ret    

80108119 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80108119:	55                   	push   %ebp
8010811a:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010811c:	8b 45 08             	mov    0x8(%ebp),%eax
8010811f:	0f 22 d8             	mov    %eax,%cr3
}
80108122:	90                   	nop
80108123:	5d                   	pop    %ebp
80108124:	c3                   	ret    

80108125 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80108125:	55                   	push   %ebp
80108126:	89 e5                	mov    %esp,%ebp
80108128:	8b 45 08             	mov    0x8(%ebp),%eax
8010812b:	05 00 00 00 80       	add    $0x80000000,%eax
80108130:	5d                   	pop    %ebp
80108131:	c3                   	ret    

80108132 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80108132:	55                   	push   %ebp
80108133:	89 e5                	mov    %esp,%ebp
80108135:	8b 45 08             	mov    0x8(%ebp),%eax
80108138:	05 00 00 00 80       	add    $0x80000000,%eax
8010813d:	5d                   	pop    %ebp
8010813e:	c3                   	ret    

8010813f <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
8010813f:	55                   	push   %ebp
80108140:	89 e5                	mov    %esp,%ebp
80108142:	53                   	push   %ebx
80108143:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80108146:	e8 5f b1 ff ff       	call   801032aa <cpunum>
8010814b:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80108151:	05 a0 33 11 80       	add    $0x801133a0,%eax
80108156:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80108159:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010815c:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80108162:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108165:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
8010816b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010816e:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80108172:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108175:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108179:	83 e2 f0             	and    $0xfffffff0,%edx
8010817c:	83 ca 0a             	or     $0xa,%edx
8010817f:	88 50 7d             	mov    %dl,0x7d(%eax)
80108182:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108185:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108189:	83 ca 10             	or     $0x10,%edx
8010818c:	88 50 7d             	mov    %dl,0x7d(%eax)
8010818f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108192:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108196:	83 e2 9f             	and    $0xffffff9f,%edx
80108199:	88 50 7d             	mov    %dl,0x7d(%eax)
8010819c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010819f:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801081a3:	83 ca 80             	or     $0xffffff80,%edx
801081a6:	88 50 7d             	mov    %dl,0x7d(%eax)
801081a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081ac:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801081b0:	83 ca 0f             	or     $0xf,%edx
801081b3:	88 50 7e             	mov    %dl,0x7e(%eax)
801081b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081b9:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801081bd:	83 e2 ef             	and    $0xffffffef,%edx
801081c0:	88 50 7e             	mov    %dl,0x7e(%eax)
801081c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081c6:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801081ca:	83 e2 df             	and    $0xffffffdf,%edx
801081cd:	88 50 7e             	mov    %dl,0x7e(%eax)
801081d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081d3:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801081d7:	83 ca 40             	or     $0x40,%edx
801081da:	88 50 7e             	mov    %dl,0x7e(%eax)
801081dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081e0:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801081e4:	83 ca 80             	or     $0xffffff80,%edx
801081e7:	88 50 7e             	mov    %dl,0x7e(%eax)
801081ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081ed:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801081f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081f4:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
801081fb:	ff ff 
801081fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108200:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80108207:	00 00 
80108209:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010820c:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80108213:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108216:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010821d:	83 e2 f0             	and    $0xfffffff0,%edx
80108220:	83 ca 02             	or     $0x2,%edx
80108223:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108229:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010822c:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108233:	83 ca 10             	or     $0x10,%edx
80108236:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010823c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010823f:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108246:	83 e2 9f             	and    $0xffffff9f,%edx
80108249:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010824f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108252:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108259:	83 ca 80             	or     $0xffffff80,%edx
8010825c:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108262:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108265:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010826c:	83 ca 0f             	or     $0xf,%edx
8010826f:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108275:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108278:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010827f:	83 e2 ef             	and    $0xffffffef,%edx
80108282:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108288:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010828b:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108292:	83 e2 df             	and    $0xffffffdf,%edx
80108295:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010829b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010829e:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801082a5:	83 ca 40             	or     $0x40,%edx
801082a8:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801082ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082b1:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801082b8:	83 ca 80             	or     $0xffffff80,%edx
801082bb:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801082c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082c4:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801082cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082ce:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
801082d5:	ff ff 
801082d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082da:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
801082e1:	00 00 
801082e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082e6:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
801082ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082f0:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801082f7:	83 e2 f0             	and    $0xfffffff0,%edx
801082fa:	83 ca 0a             	or     $0xa,%edx
801082fd:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108303:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108306:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010830d:	83 ca 10             	or     $0x10,%edx
80108310:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108316:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108319:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108320:	83 ca 60             	or     $0x60,%edx
80108323:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108329:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010832c:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108333:	83 ca 80             	or     $0xffffff80,%edx
80108336:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010833c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010833f:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108346:	83 ca 0f             	or     $0xf,%edx
80108349:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010834f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108352:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108359:	83 e2 ef             	and    $0xffffffef,%edx
8010835c:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108362:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108365:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010836c:	83 e2 df             	and    $0xffffffdf,%edx
8010836f:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108375:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108378:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010837f:	83 ca 40             	or     $0x40,%edx
80108382:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108388:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010838b:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108392:	83 ca 80             	or     $0xffffff80,%edx
80108395:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010839b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010839e:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801083a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083a8:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
801083af:	ff ff 
801083b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083b4:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
801083bb:	00 00 
801083bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083c0:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
801083c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083ca:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801083d1:	83 e2 f0             	and    $0xfffffff0,%edx
801083d4:	83 ca 02             	or     $0x2,%edx
801083d7:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801083dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083e0:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801083e7:	83 ca 10             	or     $0x10,%edx
801083ea:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801083f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083f3:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801083fa:	83 ca 60             	or     $0x60,%edx
801083fd:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108403:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108406:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010840d:	83 ca 80             	or     $0xffffff80,%edx
80108410:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108416:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108419:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108420:	83 ca 0f             	or     $0xf,%edx
80108423:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108429:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010842c:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108433:	83 e2 ef             	and    $0xffffffef,%edx
80108436:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010843c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010843f:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108446:	83 e2 df             	and    $0xffffffdf,%edx
80108449:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010844f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108452:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108459:	83 ca 40             	or     $0x40,%edx
8010845c:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108462:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108465:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010846c:	83 ca 80             	or     $0xffffff80,%edx
8010846f:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108475:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108478:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
8010847f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108482:	05 b4 00 00 00       	add    $0xb4,%eax
80108487:	89 c3                	mov    %eax,%ebx
80108489:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010848c:	05 b4 00 00 00       	add    $0xb4,%eax
80108491:	c1 e8 10             	shr    $0x10,%eax
80108494:	89 c2                	mov    %eax,%edx
80108496:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108499:	05 b4 00 00 00       	add    $0xb4,%eax
8010849e:	c1 e8 18             	shr    $0x18,%eax
801084a1:	89 c1                	mov    %eax,%ecx
801084a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084a6:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
801084ad:	00 00 
801084af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084b2:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
801084b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084bc:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
801084c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084c5:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801084cc:	83 e2 f0             	and    $0xfffffff0,%edx
801084cf:	83 ca 02             	or     $0x2,%edx
801084d2:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801084d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084db:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801084e2:	83 ca 10             	or     $0x10,%edx
801084e5:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801084eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084ee:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801084f5:	83 e2 9f             	and    $0xffffff9f,%edx
801084f8:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801084fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108501:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108508:	83 ca 80             	or     $0xffffff80,%edx
8010850b:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108511:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108514:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010851b:	83 e2 f0             	and    $0xfffffff0,%edx
8010851e:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108524:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108527:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010852e:	83 e2 ef             	and    $0xffffffef,%edx
80108531:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108537:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010853a:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108541:	83 e2 df             	and    $0xffffffdf,%edx
80108544:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010854a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010854d:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108554:	83 ca 40             	or     $0x40,%edx
80108557:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010855d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108560:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108567:	83 ca 80             	or     $0xffffff80,%edx
8010856a:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108570:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108573:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80108579:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010857c:	83 c0 70             	add    $0x70,%eax
8010857f:	83 ec 08             	sub    $0x8,%esp
80108582:	6a 38                	push   $0x38
80108584:	50                   	push   %eax
80108585:	e8 38 fb ff ff       	call   801080c2 <lgdt>
8010858a:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
8010858d:	83 ec 0c             	sub    $0xc,%esp
80108590:	6a 18                	push   $0x18
80108592:	e8 6c fb ff ff       	call   80108103 <loadgs>
80108597:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
8010859a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010859d:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
801085a3:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801085aa:	00 00 00 00 
}
801085ae:	90                   	nop
801085af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801085b2:	c9                   	leave  
801085b3:	c3                   	ret    

801085b4 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801085b4:	55                   	push   %ebp
801085b5:	89 e5                	mov    %esp,%ebp
801085b7:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801085ba:	8b 45 0c             	mov    0xc(%ebp),%eax
801085bd:	c1 e8 16             	shr    $0x16,%eax
801085c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801085c7:	8b 45 08             	mov    0x8(%ebp),%eax
801085ca:	01 d0                	add    %edx,%eax
801085cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
801085cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801085d2:	8b 00                	mov    (%eax),%eax
801085d4:	83 e0 01             	and    $0x1,%eax
801085d7:	85 c0                	test   %eax,%eax
801085d9:	74 18                	je     801085f3 <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
801085db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801085de:	8b 00                	mov    (%eax),%eax
801085e0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801085e5:	50                   	push   %eax
801085e6:	e8 47 fb ff ff       	call   80108132 <p2v>
801085eb:	83 c4 04             	add    $0x4,%esp
801085ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
801085f1:	eb 48                	jmp    8010863b <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801085f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801085f7:	74 0e                	je     80108607 <walkpgdir+0x53>
801085f9:	e8 46 a9 ff ff       	call   80102f44 <kalloc>
801085fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108601:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108605:	75 07                	jne    8010860e <walkpgdir+0x5a>
      return 0;
80108607:	b8 00 00 00 00       	mov    $0x0,%eax
8010860c:	eb 44                	jmp    80108652 <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010860e:	83 ec 04             	sub    $0x4,%esp
80108611:	68 00 10 00 00       	push   $0x1000
80108616:	6a 00                	push   $0x0
80108618:	ff 75 f4             	pushl  -0xc(%ebp)
8010861b:	e8 b9 d3 ff ff       	call   801059d9 <memset>
80108620:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80108623:	83 ec 0c             	sub    $0xc,%esp
80108626:	ff 75 f4             	pushl  -0xc(%ebp)
80108629:	e8 f7 fa ff ff       	call   80108125 <v2p>
8010862e:	83 c4 10             	add    $0x10,%esp
80108631:	83 c8 07             	or     $0x7,%eax
80108634:	89 c2                	mov    %eax,%edx
80108636:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108639:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
8010863b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010863e:	c1 e8 0c             	shr    $0xc,%eax
80108641:	25 ff 03 00 00       	and    $0x3ff,%eax
80108646:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010864d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108650:	01 d0                	add    %edx,%eax
}
80108652:	c9                   	leave  
80108653:	c3                   	ret    

80108654 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80108654:	55                   	push   %ebp
80108655:	89 e5                	mov    %esp,%ebp
80108657:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
8010865a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010865d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108662:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80108665:	8b 55 0c             	mov    0xc(%ebp),%edx
80108668:	8b 45 10             	mov    0x10(%ebp),%eax
8010866b:	01 d0                	add    %edx,%eax
8010866d:	83 e8 01             	sub    $0x1,%eax
80108670:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108675:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108678:	83 ec 04             	sub    $0x4,%esp
8010867b:	6a 01                	push   $0x1
8010867d:	ff 75 f4             	pushl  -0xc(%ebp)
80108680:	ff 75 08             	pushl  0x8(%ebp)
80108683:	e8 2c ff ff ff       	call   801085b4 <walkpgdir>
80108688:	83 c4 10             	add    $0x10,%esp
8010868b:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010868e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108692:	75 07                	jne    8010869b <mappages+0x47>
      return -1;
80108694:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108699:	eb 47                	jmp    801086e2 <mappages+0x8e>
    if(*pte & PTE_P)
8010869b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010869e:	8b 00                	mov    (%eax),%eax
801086a0:	83 e0 01             	and    $0x1,%eax
801086a3:	85 c0                	test   %eax,%eax
801086a5:	74 0d                	je     801086b4 <mappages+0x60>
      panic("remap");
801086a7:	83 ec 0c             	sub    $0xc,%esp
801086aa:	68 60 95 10 80       	push   $0x80109560
801086af:	e8 b2 7e ff ff       	call   80100566 <panic>
    *pte = pa | perm | PTE_P;
801086b4:	8b 45 18             	mov    0x18(%ebp),%eax
801086b7:	0b 45 14             	or     0x14(%ebp),%eax
801086ba:	83 c8 01             	or     $0x1,%eax
801086bd:	89 c2                	mov    %eax,%edx
801086bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
801086c2:	89 10                	mov    %edx,(%eax)
    if(a == last)
801086c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086c7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801086ca:	74 10                	je     801086dc <mappages+0x88>
      break;
    a += PGSIZE;
801086cc:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
801086d3:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
801086da:	eb 9c                	jmp    80108678 <mappages+0x24>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
801086dc:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
801086dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
801086e2:	c9                   	leave  
801086e3:	c3                   	ret    

801086e4 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801086e4:	55                   	push   %ebp
801086e5:	89 e5                	mov    %esp,%ebp
801086e7:	53                   	push   %ebx
801086e8:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801086eb:	e8 54 a8 ff ff       	call   80102f44 <kalloc>
801086f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
801086f3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801086f7:	75 0a                	jne    80108703 <setupkvm+0x1f>
    return 0;
801086f9:	b8 00 00 00 00       	mov    $0x0,%eax
801086fe:	e9 8e 00 00 00       	jmp    80108791 <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
80108703:	83 ec 04             	sub    $0x4,%esp
80108706:	68 00 10 00 00       	push   $0x1000
8010870b:	6a 00                	push   $0x0
8010870d:	ff 75 f0             	pushl  -0x10(%ebp)
80108710:	e8 c4 d2 ff ff       	call   801059d9 <memset>
80108715:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80108718:	83 ec 0c             	sub    $0xc,%esp
8010871b:	68 00 00 00 0e       	push   $0xe000000
80108720:	e8 0d fa ff ff       	call   80108132 <p2v>
80108725:	83 c4 10             	add    $0x10,%esp
80108728:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
8010872d:	76 0d                	jbe    8010873c <setupkvm+0x58>
    panic("PHYSTOP too high");
8010872f:	83 ec 0c             	sub    $0xc,%esp
80108732:	68 66 95 10 80       	push   $0x80109566
80108737:	e8 2a 7e ff ff       	call   80100566 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010873c:	c7 45 f4 e0 c4 10 80 	movl   $0x8010c4e0,-0xc(%ebp)
80108743:	eb 40                	jmp    80108785 <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80108745:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108748:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
8010874b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010874e:	8b 50 04             	mov    0x4(%eax),%edx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80108751:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108754:	8b 58 08             	mov    0x8(%eax),%ebx
80108757:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010875a:	8b 40 04             	mov    0x4(%eax),%eax
8010875d:	29 c3                	sub    %eax,%ebx
8010875f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108762:	8b 00                	mov    (%eax),%eax
80108764:	83 ec 0c             	sub    $0xc,%esp
80108767:	51                   	push   %ecx
80108768:	52                   	push   %edx
80108769:	53                   	push   %ebx
8010876a:	50                   	push   %eax
8010876b:	ff 75 f0             	pushl  -0x10(%ebp)
8010876e:	e8 e1 fe ff ff       	call   80108654 <mappages>
80108773:	83 c4 20             	add    $0x20,%esp
80108776:	85 c0                	test   %eax,%eax
80108778:	79 07                	jns    80108781 <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
8010877a:	b8 00 00 00 00       	mov    $0x0,%eax
8010877f:	eb 10                	jmp    80108791 <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108781:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80108785:	81 7d f4 20 c5 10 80 	cmpl   $0x8010c520,-0xc(%ebp)
8010878c:	72 b7                	jb     80108745 <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
8010878e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80108791:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108794:	c9                   	leave  
80108795:	c3                   	ret    

80108796 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80108796:	55                   	push   %ebp
80108797:	89 e5                	mov    %esp,%ebp
80108799:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010879c:	e8 43 ff ff ff       	call   801086e4 <setupkvm>
801087a1:	a3 38 66 11 80       	mov    %eax,0x80116638
  switchkvm();
801087a6:	e8 03 00 00 00       	call   801087ae <switchkvm>
}
801087ab:	90                   	nop
801087ac:	c9                   	leave  
801087ad:	c3                   	ret    

801087ae <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801087ae:	55                   	push   %ebp
801087af:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
801087b1:	a1 38 66 11 80       	mov    0x80116638,%eax
801087b6:	50                   	push   %eax
801087b7:	e8 69 f9 ff ff       	call   80108125 <v2p>
801087bc:	83 c4 04             	add    $0x4,%esp
801087bf:	50                   	push   %eax
801087c0:	e8 54 f9 ff ff       	call   80108119 <lcr3>
801087c5:	83 c4 04             	add    $0x4,%esp
}
801087c8:	90                   	nop
801087c9:	c9                   	leave  
801087ca:	c3                   	ret    

801087cb <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801087cb:	55                   	push   %ebp
801087cc:	89 e5                	mov    %esp,%ebp
801087ce:	56                   	push   %esi
801087cf:	53                   	push   %ebx
  pushcli();
801087d0:	e8 fe d0 ff ff       	call   801058d3 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
801087d5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801087db:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801087e2:	83 c2 08             	add    $0x8,%edx
801087e5:	89 d6                	mov    %edx,%esi
801087e7:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801087ee:	83 c2 08             	add    $0x8,%edx
801087f1:	c1 ea 10             	shr    $0x10,%edx
801087f4:	89 d3                	mov    %edx,%ebx
801087f6:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801087fd:	83 c2 08             	add    $0x8,%edx
80108800:	c1 ea 18             	shr    $0x18,%edx
80108803:	89 d1                	mov    %edx,%ecx
80108805:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
8010880c:	67 00 
8010880e:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
80108815:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
8010881b:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108822:	83 e2 f0             	and    $0xfffffff0,%edx
80108825:	83 ca 09             	or     $0x9,%edx
80108828:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
8010882e:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108835:	83 ca 10             	or     $0x10,%edx
80108838:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
8010883e:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108845:	83 e2 9f             	and    $0xffffff9f,%edx
80108848:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
8010884e:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108855:	83 ca 80             	or     $0xffffff80,%edx
80108858:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
8010885e:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108865:	83 e2 f0             	and    $0xfffffff0,%edx
80108868:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010886e:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108875:	83 e2 ef             	and    $0xffffffef,%edx
80108878:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010887e:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108885:	83 e2 df             	and    $0xffffffdf,%edx
80108888:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010888e:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80108895:	83 ca 40             	or     $0x40,%edx
80108898:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010889e:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801088a5:	83 e2 7f             	and    $0x7f,%edx
801088a8:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801088ae:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
801088b4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801088ba:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801088c1:	83 e2 ef             	and    $0xffffffef,%edx
801088c4:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
801088ca:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801088d0:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
801088d6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801088dc:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801088e3:	8b 52 08             	mov    0x8(%edx),%edx
801088e6:	81 c2 00 10 00 00    	add    $0x1000,%edx
801088ec:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
801088ef:	83 ec 0c             	sub    $0xc,%esp
801088f2:	6a 30                	push   $0x30
801088f4:	e8 f3 f7 ff ff       	call   801080ec <ltr>
801088f9:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
801088fc:	8b 45 08             	mov    0x8(%ebp),%eax
801088ff:	8b 40 04             	mov    0x4(%eax),%eax
80108902:	85 c0                	test   %eax,%eax
80108904:	75 0d                	jne    80108913 <switchuvm+0x148>
    panic("switchuvm: no pgdir");
80108906:	83 ec 0c             	sub    $0xc,%esp
80108909:	68 77 95 10 80       	push   $0x80109577
8010890e:	e8 53 7c ff ff       	call   80100566 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80108913:	8b 45 08             	mov    0x8(%ebp),%eax
80108916:	8b 40 04             	mov    0x4(%eax),%eax
80108919:	83 ec 0c             	sub    $0xc,%esp
8010891c:	50                   	push   %eax
8010891d:	e8 03 f8 ff ff       	call   80108125 <v2p>
80108922:	83 c4 10             	add    $0x10,%esp
80108925:	83 ec 0c             	sub    $0xc,%esp
80108928:	50                   	push   %eax
80108929:	e8 eb f7 ff ff       	call   80108119 <lcr3>
8010892e:	83 c4 10             	add    $0x10,%esp
  popcli();
80108931:	e8 e2 cf ff ff       	call   80105918 <popcli>
}
80108936:	90                   	nop
80108937:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010893a:	5b                   	pop    %ebx
8010893b:	5e                   	pop    %esi
8010893c:	5d                   	pop    %ebp
8010893d:	c3                   	ret    

8010893e <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
8010893e:	55                   	push   %ebp
8010893f:	89 e5                	mov    %esp,%ebp
80108941:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80108944:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
8010894b:	76 0d                	jbe    8010895a <inituvm+0x1c>
    panic("inituvm: more than a page");
8010894d:	83 ec 0c             	sub    $0xc,%esp
80108950:	68 8b 95 10 80       	push   $0x8010958b
80108955:	e8 0c 7c ff ff       	call   80100566 <panic>
  mem = kalloc();
8010895a:	e8 e5 a5 ff ff       	call   80102f44 <kalloc>
8010895f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80108962:	83 ec 04             	sub    $0x4,%esp
80108965:	68 00 10 00 00       	push   $0x1000
8010896a:	6a 00                	push   $0x0
8010896c:	ff 75 f4             	pushl  -0xc(%ebp)
8010896f:	e8 65 d0 ff ff       	call   801059d9 <memset>
80108974:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108977:	83 ec 0c             	sub    $0xc,%esp
8010897a:	ff 75 f4             	pushl  -0xc(%ebp)
8010897d:	e8 a3 f7 ff ff       	call   80108125 <v2p>
80108982:	83 c4 10             	add    $0x10,%esp
80108985:	83 ec 0c             	sub    $0xc,%esp
80108988:	6a 06                	push   $0x6
8010898a:	50                   	push   %eax
8010898b:	68 00 10 00 00       	push   $0x1000
80108990:	6a 00                	push   $0x0
80108992:	ff 75 08             	pushl  0x8(%ebp)
80108995:	e8 ba fc ff ff       	call   80108654 <mappages>
8010899a:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
8010899d:	83 ec 04             	sub    $0x4,%esp
801089a0:	ff 75 10             	pushl  0x10(%ebp)
801089a3:	ff 75 0c             	pushl  0xc(%ebp)
801089a6:	ff 75 f4             	pushl  -0xc(%ebp)
801089a9:	e8 ea d0 ff ff       	call   80105a98 <memmove>
801089ae:	83 c4 10             	add    $0x10,%esp
}
801089b1:	90                   	nop
801089b2:	c9                   	leave  
801089b3:	c3                   	ret    

801089b4 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801089b4:	55                   	push   %ebp
801089b5:	89 e5                	mov    %esp,%ebp
801089b7:	53                   	push   %ebx
801089b8:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801089bb:	8b 45 0c             	mov    0xc(%ebp),%eax
801089be:	25 ff 0f 00 00       	and    $0xfff,%eax
801089c3:	85 c0                	test   %eax,%eax
801089c5:	74 0d                	je     801089d4 <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
801089c7:	83 ec 0c             	sub    $0xc,%esp
801089ca:	68 a8 95 10 80       	push   $0x801095a8
801089cf:	e8 92 7b ff ff       	call   80100566 <panic>
  for(i = 0; i < sz; i += PGSIZE){
801089d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801089db:	e9 95 00 00 00       	jmp    80108a75 <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801089e0:	8b 55 0c             	mov    0xc(%ebp),%edx
801089e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089e6:	01 d0                	add    %edx,%eax
801089e8:	83 ec 04             	sub    $0x4,%esp
801089eb:	6a 00                	push   $0x0
801089ed:	50                   	push   %eax
801089ee:	ff 75 08             	pushl  0x8(%ebp)
801089f1:	e8 be fb ff ff       	call   801085b4 <walkpgdir>
801089f6:	83 c4 10             	add    $0x10,%esp
801089f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
801089fc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108a00:	75 0d                	jne    80108a0f <loaduvm+0x5b>
      panic("loaduvm: address should exist");
80108a02:	83 ec 0c             	sub    $0xc,%esp
80108a05:	68 cb 95 10 80       	push   $0x801095cb
80108a0a:	e8 57 7b ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80108a0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a12:	8b 00                	mov    (%eax),%eax
80108a14:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108a19:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80108a1c:	8b 45 18             	mov    0x18(%ebp),%eax
80108a1f:	2b 45 f4             	sub    -0xc(%ebp),%eax
80108a22:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80108a27:	77 0b                	ja     80108a34 <loaduvm+0x80>
      n = sz - i;
80108a29:	8b 45 18             	mov    0x18(%ebp),%eax
80108a2c:	2b 45 f4             	sub    -0xc(%ebp),%eax
80108a2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108a32:	eb 07                	jmp    80108a3b <loaduvm+0x87>
    else
      n = PGSIZE;
80108a34:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80108a3b:	8b 55 14             	mov    0x14(%ebp),%edx
80108a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a41:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80108a44:	83 ec 0c             	sub    $0xc,%esp
80108a47:	ff 75 e8             	pushl  -0x18(%ebp)
80108a4a:	e8 e3 f6 ff ff       	call   80108132 <p2v>
80108a4f:	83 c4 10             	add    $0x10,%esp
80108a52:	ff 75 f0             	pushl  -0x10(%ebp)
80108a55:	53                   	push   %ebx
80108a56:	50                   	push   %eax
80108a57:	ff 75 10             	pushl  0x10(%ebp)
80108a5a:	e8 b9 95 ff ff       	call   80102018 <readi>
80108a5f:	83 c4 10             	add    $0x10,%esp
80108a62:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108a65:	74 07                	je     80108a6e <loaduvm+0xba>
      return -1;
80108a67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108a6c:	eb 18                	jmp    80108a86 <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80108a6e:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a78:	3b 45 18             	cmp    0x18(%ebp),%eax
80108a7b:	0f 82 5f ff ff ff    	jb     801089e0 <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80108a81:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108a86:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108a89:	c9                   	leave  
80108a8a:	c3                   	ret    

80108a8b <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108a8b:	55                   	push   %ebp
80108a8c:	89 e5                	mov    %esp,%ebp
80108a8e:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80108a91:	8b 45 10             	mov    0x10(%ebp),%eax
80108a94:	85 c0                	test   %eax,%eax
80108a96:	79 0a                	jns    80108aa2 <allocuvm+0x17>
    return 0;
80108a98:	b8 00 00 00 00       	mov    $0x0,%eax
80108a9d:	e9 b0 00 00 00       	jmp    80108b52 <allocuvm+0xc7>
  if(newsz < oldsz)
80108aa2:	8b 45 10             	mov    0x10(%ebp),%eax
80108aa5:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108aa8:	73 08                	jae    80108ab2 <allocuvm+0x27>
    return oldsz;
80108aaa:	8b 45 0c             	mov    0xc(%ebp),%eax
80108aad:	e9 a0 00 00 00       	jmp    80108b52 <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
80108ab2:	8b 45 0c             	mov    0xc(%ebp),%eax
80108ab5:	05 ff 0f 00 00       	add    $0xfff,%eax
80108aba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108abf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80108ac2:	eb 7f                	jmp    80108b43 <allocuvm+0xb8>
    mem = kalloc();
80108ac4:	e8 7b a4 ff ff       	call   80102f44 <kalloc>
80108ac9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80108acc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108ad0:	75 2b                	jne    80108afd <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
80108ad2:	83 ec 0c             	sub    $0xc,%esp
80108ad5:	68 e9 95 10 80       	push   $0x801095e9
80108ada:	e8 e7 78 ff ff       	call   801003c6 <cprintf>
80108adf:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80108ae2:	83 ec 04             	sub    $0x4,%esp
80108ae5:	ff 75 0c             	pushl  0xc(%ebp)
80108ae8:	ff 75 10             	pushl  0x10(%ebp)
80108aeb:	ff 75 08             	pushl  0x8(%ebp)
80108aee:	e8 61 00 00 00       	call   80108b54 <deallocuvm>
80108af3:	83 c4 10             	add    $0x10,%esp
      return 0;
80108af6:	b8 00 00 00 00       	mov    $0x0,%eax
80108afb:	eb 55                	jmp    80108b52 <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
80108afd:	83 ec 04             	sub    $0x4,%esp
80108b00:	68 00 10 00 00       	push   $0x1000
80108b05:	6a 00                	push   $0x0
80108b07:	ff 75 f0             	pushl  -0x10(%ebp)
80108b0a:	e8 ca ce ff ff       	call   801059d9 <memset>
80108b0f:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108b12:	83 ec 0c             	sub    $0xc,%esp
80108b15:	ff 75 f0             	pushl  -0x10(%ebp)
80108b18:	e8 08 f6 ff ff       	call   80108125 <v2p>
80108b1d:	83 c4 10             	add    $0x10,%esp
80108b20:	89 c2                	mov    %eax,%edx
80108b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b25:	83 ec 0c             	sub    $0xc,%esp
80108b28:	6a 06                	push   $0x6
80108b2a:	52                   	push   %edx
80108b2b:	68 00 10 00 00       	push   $0x1000
80108b30:	50                   	push   %eax
80108b31:	ff 75 08             	pushl  0x8(%ebp)
80108b34:	e8 1b fb ff ff       	call   80108654 <mappages>
80108b39:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80108b3c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b46:	3b 45 10             	cmp    0x10(%ebp),%eax
80108b49:	0f 82 75 ff ff ff    	jb     80108ac4 <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80108b4f:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108b52:	c9                   	leave  
80108b53:	c3                   	ret    

80108b54 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108b54:	55                   	push   %ebp
80108b55:	89 e5                	mov    %esp,%ebp
80108b57:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80108b5a:	8b 45 10             	mov    0x10(%ebp),%eax
80108b5d:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108b60:	72 08                	jb     80108b6a <deallocuvm+0x16>
    return oldsz;
80108b62:	8b 45 0c             	mov    0xc(%ebp),%eax
80108b65:	e9 a5 00 00 00       	jmp    80108c0f <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
80108b6a:	8b 45 10             	mov    0x10(%ebp),%eax
80108b6d:	05 ff 0f 00 00       	add    $0xfff,%eax
80108b72:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108b77:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108b7a:	e9 81 00 00 00       	jmp    80108c00 <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
80108b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b82:	83 ec 04             	sub    $0x4,%esp
80108b85:	6a 00                	push   $0x0
80108b87:	50                   	push   %eax
80108b88:	ff 75 08             	pushl  0x8(%ebp)
80108b8b:	e8 24 fa ff ff       	call   801085b4 <walkpgdir>
80108b90:	83 c4 10             	add    $0x10,%esp
80108b93:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80108b96:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108b9a:	75 09                	jne    80108ba5 <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
80108b9c:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80108ba3:	eb 54                	jmp    80108bf9 <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
80108ba5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ba8:	8b 00                	mov    (%eax),%eax
80108baa:	83 e0 01             	and    $0x1,%eax
80108bad:	85 c0                	test   %eax,%eax
80108baf:	74 48                	je     80108bf9 <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
80108bb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108bb4:	8b 00                	mov    (%eax),%eax
80108bb6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108bbb:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80108bbe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108bc2:	75 0d                	jne    80108bd1 <deallocuvm+0x7d>
        panic("kfree");
80108bc4:	83 ec 0c             	sub    $0xc,%esp
80108bc7:	68 01 96 10 80       	push   $0x80109601
80108bcc:	e8 95 79 ff ff       	call   80100566 <panic>
      char *v = p2v(pa);
80108bd1:	83 ec 0c             	sub    $0xc,%esp
80108bd4:	ff 75 ec             	pushl  -0x14(%ebp)
80108bd7:	e8 56 f5 ff ff       	call   80108132 <p2v>
80108bdc:	83 c4 10             	add    $0x10,%esp
80108bdf:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80108be2:	83 ec 0c             	sub    $0xc,%esp
80108be5:	ff 75 e8             	pushl  -0x18(%ebp)
80108be8:	e8 ba a2 ff ff       	call   80102ea7 <kfree>
80108bed:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80108bf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108bf3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80108bf9:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c03:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108c06:	0f 82 73 ff ff ff    	jb     80108b7f <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80108c0c:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108c0f:	c9                   	leave  
80108c10:	c3                   	ret    

80108c11 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108c11:	55                   	push   %ebp
80108c12:	89 e5                	mov    %esp,%ebp
80108c14:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80108c17:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108c1b:	75 0d                	jne    80108c2a <freevm+0x19>
    panic("freevm: no pgdir");
80108c1d:	83 ec 0c             	sub    $0xc,%esp
80108c20:	68 07 96 10 80       	push   $0x80109607
80108c25:	e8 3c 79 ff ff       	call   80100566 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108c2a:	83 ec 04             	sub    $0x4,%esp
80108c2d:	6a 00                	push   $0x0
80108c2f:	68 00 00 00 80       	push   $0x80000000
80108c34:	ff 75 08             	pushl  0x8(%ebp)
80108c37:	e8 18 ff ff ff       	call   80108b54 <deallocuvm>
80108c3c:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108c3f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108c46:	eb 4f                	jmp    80108c97 <freevm+0x86>
    if(pgdir[i] & PTE_P){
80108c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c4b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108c52:	8b 45 08             	mov    0x8(%ebp),%eax
80108c55:	01 d0                	add    %edx,%eax
80108c57:	8b 00                	mov    (%eax),%eax
80108c59:	83 e0 01             	and    $0x1,%eax
80108c5c:	85 c0                	test   %eax,%eax
80108c5e:	74 33                	je     80108c93 <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80108c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c63:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108c6a:	8b 45 08             	mov    0x8(%ebp),%eax
80108c6d:	01 d0                	add    %edx,%eax
80108c6f:	8b 00                	mov    (%eax),%eax
80108c71:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108c76:	83 ec 0c             	sub    $0xc,%esp
80108c79:	50                   	push   %eax
80108c7a:	e8 b3 f4 ff ff       	call   80108132 <p2v>
80108c7f:	83 c4 10             	add    $0x10,%esp
80108c82:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80108c85:	83 ec 0c             	sub    $0xc,%esp
80108c88:	ff 75 f0             	pushl  -0x10(%ebp)
80108c8b:	e8 17 a2 ff ff       	call   80102ea7 <kfree>
80108c90:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108c93:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108c97:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108c9e:	76 a8                	jbe    80108c48 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80108ca0:	83 ec 0c             	sub    $0xc,%esp
80108ca3:	ff 75 08             	pushl  0x8(%ebp)
80108ca6:	e8 fc a1 ff ff       	call   80102ea7 <kfree>
80108cab:	83 c4 10             	add    $0x10,%esp
}
80108cae:	90                   	nop
80108caf:	c9                   	leave  
80108cb0:	c3                   	ret    

80108cb1 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108cb1:	55                   	push   %ebp
80108cb2:	89 e5                	mov    %esp,%ebp
80108cb4:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108cb7:	83 ec 04             	sub    $0x4,%esp
80108cba:	6a 00                	push   $0x0
80108cbc:	ff 75 0c             	pushl  0xc(%ebp)
80108cbf:	ff 75 08             	pushl  0x8(%ebp)
80108cc2:	e8 ed f8 ff ff       	call   801085b4 <walkpgdir>
80108cc7:	83 c4 10             	add    $0x10,%esp
80108cca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108ccd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108cd1:	75 0d                	jne    80108ce0 <clearpteu+0x2f>
    panic("clearpteu");
80108cd3:	83 ec 0c             	sub    $0xc,%esp
80108cd6:	68 18 96 10 80       	push   $0x80109618
80108cdb:	e8 86 78 ff ff       	call   80100566 <panic>
  *pte &= ~PTE_U;
80108ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ce3:	8b 00                	mov    (%eax),%eax
80108ce5:	83 e0 fb             	and    $0xfffffffb,%eax
80108ce8:	89 c2                	mov    %eax,%edx
80108cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ced:	89 10                	mov    %edx,(%eax)
}
80108cef:	90                   	nop
80108cf0:	c9                   	leave  
80108cf1:	c3                   	ret    

80108cf2 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108cf2:	55                   	push   %ebp
80108cf3:	89 e5                	mov    %esp,%ebp
80108cf5:	53                   	push   %ebx
80108cf6:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108cf9:	e8 e6 f9 ff ff       	call   801086e4 <setupkvm>
80108cfe:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108d01:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108d05:	75 0a                	jne    80108d11 <copyuvm+0x1f>
    return 0;
80108d07:	b8 00 00 00 00       	mov    $0x0,%eax
80108d0c:	e9 f8 00 00 00       	jmp    80108e09 <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
80108d11:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108d18:	e9 c4 00 00 00       	jmp    80108de1 <copyuvm+0xef>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d20:	83 ec 04             	sub    $0x4,%esp
80108d23:	6a 00                	push   $0x0
80108d25:	50                   	push   %eax
80108d26:	ff 75 08             	pushl  0x8(%ebp)
80108d29:	e8 86 f8 ff ff       	call   801085b4 <walkpgdir>
80108d2e:	83 c4 10             	add    $0x10,%esp
80108d31:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108d34:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108d38:	75 0d                	jne    80108d47 <copyuvm+0x55>
      panic("copyuvm: pte should exist");
80108d3a:	83 ec 0c             	sub    $0xc,%esp
80108d3d:	68 22 96 10 80       	push   $0x80109622
80108d42:	e8 1f 78 ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
80108d47:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108d4a:	8b 00                	mov    (%eax),%eax
80108d4c:	83 e0 01             	and    $0x1,%eax
80108d4f:	85 c0                	test   %eax,%eax
80108d51:	75 0d                	jne    80108d60 <copyuvm+0x6e>
      panic("copyuvm: page not present");
80108d53:	83 ec 0c             	sub    $0xc,%esp
80108d56:	68 3c 96 10 80       	push   $0x8010963c
80108d5b:	e8 06 78 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80108d60:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108d63:	8b 00                	mov    (%eax),%eax
80108d65:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108d6a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108d6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108d70:	8b 00                	mov    (%eax),%eax
80108d72:	25 ff 0f 00 00       	and    $0xfff,%eax
80108d77:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108d7a:	e8 c5 a1 ff ff       	call   80102f44 <kalloc>
80108d7f:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108d82:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108d86:	74 6a                	je     80108df2 <copyuvm+0x100>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
80108d88:	83 ec 0c             	sub    $0xc,%esp
80108d8b:	ff 75 e8             	pushl  -0x18(%ebp)
80108d8e:	e8 9f f3 ff ff       	call   80108132 <p2v>
80108d93:	83 c4 10             	add    $0x10,%esp
80108d96:	83 ec 04             	sub    $0x4,%esp
80108d99:	68 00 10 00 00       	push   $0x1000
80108d9e:	50                   	push   %eax
80108d9f:	ff 75 e0             	pushl  -0x20(%ebp)
80108da2:	e8 f1 cc ff ff       	call   80105a98 <memmove>
80108da7:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80108daa:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80108dad:	83 ec 0c             	sub    $0xc,%esp
80108db0:	ff 75 e0             	pushl  -0x20(%ebp)
80108db3:	e8 6d f3 ff ff       	call   80108125 <v2p>
80108db8:	83 c4 10             	add    $0x10,%esp
80108dbb:	89 c2                	mov    %eax,%edx
80108dbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108dc0:	83 ec 0c             	sub    $0xc,%esp
80108dc3:	53                   	push   %ebx
80108dc4:	52                   	push   %edx
80108dc5:	68 00 10 00 00       	push   $0x1000
80108dca:	50                   	push   %eax
80108dcb:	ff 75 f0             	pushl  -0x10(%ebp)
80108dce:	e8 81 f8 ff ff       	call   80108654 <mappages>
80108dd3:	83 c4 20             	add    $0x20,%esp
80108dd6:	85 c0                	test   %eax,%eax
80108dd8:	78 1b                	js     80108df5 <copyuvm+0x103>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108dda:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108de4:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108de7:	0f 82 30 ff ff ff    	jb     80108d1d <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80108ded:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108df0:	eb 17                	jmp    80108e09 <copyuvm+0x117>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
80108df2:	90                   	nop
80108df3:	eb 01                	jmp    80108df6 <copyuvm+0x104>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
80108df5:	90                   	nop
  }
  return d;

bad:
  freevm(d);
80108df6:	83 ec 0c             	sub    $0xc,%esp
80108df9:	ff 75 f0             	pushl  -0x10(%ebp)
80108dfc:	e8 10 fe ff ff       	call   80108c11 <freevm>
80108e01:	83 c4 10             	add    $0x10,%esp
  return 0;
80108e04:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108e09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108e0c:	c9                   	leave  
80108e0d:	c3                   	ret    

80108e0e <uva2ka>:

// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108e0e:	55                   	push   %ebp
80108e0f:	89 e5                	mov    %esp,%ebp
80108e11:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108e14:	83 ec 04             	sub    $0x4,%esp
80108e17:	6a 00                	push   $0x0
80108e19:	ff 75 0c             	pushl  0xc(%ebp)
80108e1c:	ff 75 08             	pushl  0x8(%ebp)
80108e1f:	e8 90 f7 ff ff       	call   801085b4 <walkpgdir>
80108e24:	83 c4 10             	add    $0x10,%esp
80108e27:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108e2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e2d:	8b 00                	mov    (%eax),%eax
80108e2f:	83 e0 01             	and    $0x1,%eax
80108e32:	85 c0                	test   %eax,%eax
80108e34:	75 07                	jne    80108e3d <uva2ka+0x2f>
    return 0;
80108e36:	b8 00 00 00 00       	mov    $0x0,%eax
80108e3b:	eb 29                	jmp    80108e66 <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
80108e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e40:	8b 00                	mov    (%eax),%eax
80108e42:	83 e0 04             	and    $0x4,%eax
80108e45:	85 c0                	test   %eax,%eax
80108e47:	75 07                	jne    80108e50 <uva2ka+0x42>
    return 0;
80108e49:	b8 00 00 00 00       	mov    $0x0,%eax
80108e4e:	eb 16                	jmp    80108e66 <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
80108e50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e53:	8b 00                	mov    (%eax),%eax
80108e55:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108e5a:	83 ec 0c             	sub    $0xc,%esp
80108e5d:	50                   	push   %eax
80108e5e:	e8 cf f2 ff ff       	call   80108132 <p2v>
80108e63:	83 c4 10             	add    $0x10,%esp
}
80108e66:	c9                   	leave  
80108e67:	c3                   	ret    

80108e68 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108e68:	55                   	push   %ebp
80108e69:	89 e5                	mov    %esp,%ebp
80108e6b:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108e6e:	8b 45 10             	mov    0x10(%ebp),%eax
80108e71:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108e74:	eb 7f                	jmp    80108ef5 <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80108e76:	8b 45 0c             	mov    0xc(%ebp),%eax
80108e79:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108e7e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108e81:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108e84:	83 ec 08             	sub    $0x8,%esp
80108e87:	50                   	push   %eax
80108e88:	ff 75 08             	pushl  0x8(%ebp)
80108e8b:	e8 7e ff ff ff       	call   80108e0e <uva2ka>
80108e90:	83 c4 10             	add    $0x10,%esp
80108e93:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108e96:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108e9a:	75 07                	jne    80108ea3 <copyout+0x3b>
      return -1;
80108e9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108ea1:	eb 61                	jmp    80108f04 <copyout+0x9c>
    n = PGSIZE - (va - va0);
80108ea3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108ea6:	2b 45 0c             	sub    0xc(%ebp),%eax
80108ea9:	05 00 10 00 00       	add    $0x1000,%eax
80108eae:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108eb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108eb4:	3b 45 14             	cmp    0x14(%ebp),%eax
80108eb7:	76 06                	jbe    80108ebf <copyout+0x57>
      n = len;
80108eb9:	8b 45 14             	mov    0x14(%ebp),%eax
80108ebc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108ebf:	8b 45 0c             	mov    0xc(%ebp),%eax
80108ec2:	2b 45 ec             	sub    -0x14(%ebp),%eax
80108ec5:	89 c2                	mov    %eax,%edx
80108ec7:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108eca:	01 d0                	add    %edx,%eax
80108ecc:	83 ec 04             	sub    $0x4,%esp
80108ecf:	ff 75 f0             	pushl  -0x10(%ebp)
80108ed2:	ff 75 f4             	pushl  -0xc(%ebp)
80108ed5:	50                   	push   %eax
80108ed6:	e8 bd cb ff ff       	call   80105a98 <memmove>
80108edb:	83 c4 10             	add    $0x10,%esp
    len -= n;
80108ede:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ee1:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108ee4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ee7:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108eea:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108eed:	05 00 10 00 00       	add    $0x1000,%eax
80108ef2:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108ef5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108ef9:	0f 85 77 ff ff ff    	jne    80108e76 <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80108eff:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108f04:	c9                   	leave  
80108f05:	c3                   	ret    
