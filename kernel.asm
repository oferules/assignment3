
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
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
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
80100028:	bc c0 c5 10 80       	mov    $0x8010c5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 c0 32 10 80       	mov    $0x801032c0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 c5 10 80       	mov    $0x8010c5f4,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	68 80 7c 10 80       	push   $0x80107c80
80100051:	68 c0 c5 10 80       	push   $0x8010c5c0
80100056:	e8 f5 48 00 00       	call   80104950 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c 0d 11 80 bc 	movl   $0x80110cbc,0x80110d0c
80100062:	0c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 0d 11 80 bc 	movl   $0x80110cbc,0x80110d10
8010006c:	0c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc 0c 11 80       	mov    $0x80110cbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 87 7c 10 80       	push   $0x80107c87
80100097:	50                   	push   %eax
80100098:	e8 a3 47 00 00       	call   80104840 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 0d 11 80       	mov    0x80110d10,%eax

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b0:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc 0c 11 80       	cmp    $0x80110cbc,%eax
801000bb:	75 c3                	jne    80100080 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000df:	68 c0 c5 10 80       	push   $0x8010c5c0
801000e4:	e8 67 49 00 00       	call   80104a50 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 0d 11 80    	mov    0x80110d10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c 0d 11 80    	mov    0x80110d0c,%ebx
80100126:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 c5 10 80       	push   $0x8010c5c0
80100162:	e8 29 4a 00 00       	call   80104b90 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 0e 47 00 00       	call   80104880 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 8d 23 00 00       	call   80102510 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 8e 7c 10 80       	push   $0x80107c8e
80100198:	e8 d3 01 00 00       	call   80100370 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 6d 47 00 00       	call   80104920 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001c4:	e9 47 23 00 00       	jmp    80102510 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 9f 7c 10 80       	push   $0x80107c9f
801001d1:	e8 9a 01 00 00       	call   80100370 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 2c 47 00 00       	call   80104920 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 dc 46 00 00       	call   801048e0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010020b:	e8 40 48 00 00       	call   80104a50 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 10 0d 11 80       	mov    0x80110d10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
80100241:	a1 10 0d 11 80       	mov    0x80110d10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 c5 10 80 	movl   $0x8010c5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
8010025c:	e9 2f 49 00 00       	jmp    80104b90 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 a6 7c 10 80       	push   $0x80107ca6
80100269:	e8 02 01 00 00       	call   80100370 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 4b 15 00 00       	call   801017d0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 bf 47 00 00       	call   80104a50 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e 9a 00 00 00    	jle    8010033b <consoleread+0xcb>
    while(input.r == input.w){
801002a1:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002a6:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002ac:	74 24                	je     801002d2 <consoleread+0x62>
801002ae:	eb 58                	jmp    80100308 <consoleread+0x98>
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b0:	83 ec 08             	sub    $0x8,%esp
801002b3:	68 20 b5 10 80       	push   $0x8010b520
801002b8:	68 a0 0f 11 80       	push   $0x80110fa0
801002bd:	e8 de 40 00 00       	call   801043a0 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c2:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002c7:	83 c4 10             	add    $0x10,%esp
801002ca:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002d0:	75 36                	jne    80100308 <consoleread+0x98>
      if(myproc()->killed){
801002d2:	e8 89 39 00 00       	call   80103c60 <myproc>
801002d7:	8b 40 24             	mov    0x24(%eax),%eax
801002da:	85 c0                	test   %eax,%eax
801002dc:	74 d2                	je     801002b0 <consoleread+0x40>
        release(&cons.lock);
801002de:	83 ec 0c             	sub    $0xc,%esp
801002e1:	68 20 b5 10 80       	push   $0x8010b520
801002e6:	e8 a5 48 00 00       	call   80104b90 <release>
        ilock(ip);
801002eb:	89 3c 24             	mov    %edi,(%esp)
801002ee:	e8 fd 13 00 00       	call   801016f0 <ilock>
        return -1;
801002f3:	83 c4 10             	add    $0x10,%esp
801002f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002fe:	5b                   	pop    %ebx
801002ff:	5e                   	pop    %esi
80100300:	5f                   	pop    %edi
80100301:	5d                   	pop    %ebp
80100302:	c3                   	ret    
80100303:	90                   	nop
80100304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100308:	8d 50 01             	lea    0x1(%eax),%edx
8010030b:	89 15 a0 0f 11 80    	mov    %edx,0x80110fa0
80100311:	89 c2                	mov    %eax,%edx
80100313:	83 e2 7f             	and    $0x7f,%edx
80100316:	0f be 92 20 0f 11 80 	movsbl -0x7feef0e0(%edx),%edx
    if(c == C('D')){  // EOF
8010031d:	83 fa 04             	cmp    $0x4,%edx
80100320:	74 39                	je     8010035b <consoleread+0xeb>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
80100322:	83 c6 01             	add    $0x1,%esi
    --n;
80100325:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
80100328:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
8010032b:	88 56 ff             	mov    %dl,-0x1(%esi)
    --n;
    if(c == '\n')
8010032e:	74 35                	je     80100365 <consoleread+0xf5>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100330:	85 db                	test   %ebx,%ebx
80100332:	0f 85 69 ff ff ff    	jne    801002a1 <consoleread+0x31>
80100338:	8b 45 10             	mov    0x10(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
8010033b:	83 ec 0c             	sub    $0xc,%esp
8010033e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100341:	68 20 b5 10 80       	push   $0x8010b520
80100346:	e8 45 48 00 00       	call   80104b90 <release>
  ilock(ip);
8010034b:	89 3c 24             	mov    %edi,(%esp)
8010034e:	e8 9d 13 00 00       	call   801016f0 <ilock>

  return target - n;
80100353:	83 c4 10             	add    $0x10,%esp
80100356:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100359:	eb a0                	jmp    801002fb <consoleread+0x8b>
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
8010035b:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010035e:	76 05                	jbe    80100365 <consoleread+0xf5>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100360:	a3 a0 0f 11 80       	mov    %eax,0x80110fa0
80100365:	8b 45 10             	mov    0x10(%ebp),%eax
80100368:	29 d8                	sub    %ebx,%eax
8010036a:	eb cf                	jmp    8010033b <consoleread+0xcb>
8010036c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100370 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
80100370:	55                   	push   %ebp
80100371:	89 e5                	mov    %esp,%ebp
80100373:	56                   	push   %esi
80100374:	53                   	push   %ebx
80100375:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100378:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
80100379:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
80100380:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
80100383:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100386:	8d 75 f8             	lea    -0x8(%ebp),%esi
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
80100389:	e8 c2 27 00 00       	call   80102b50 <lapicid>
8010038e:	83 ec 08             	sub    $0x8,%esp
80100391:	50                   	push   %eax
80100392:	68 ad 7c 10 80       	push   $0x80107cad
80100397:	e8 c4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
8010039c:	58                   	pop    %eax
8010039d:	ff 75 08             	pushl  0x8(%ebp)
801003a0:	e8 bb 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003a5:	c7 04 24 c3 87 10 80 	movl   $0x801087c3,(%esp)
801003ac:	e8 af 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003b1:	5a                   	pop    %edx
801003b2:	8d 45 08             	lea    0x8(%ebp),%eax
801003b5:	59                   	pop    %ecx
801003b6:	53                   	push   %ebx
801003b7:	50                   	push   %eax
801003b8:	e8 b3 45 00 00       	call   80104970 <getcallerpcs>
801003bd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003c0:	83 ec 08             	sub    $0x8,%esp
801003c3:	ff 33                	pushl  (%ebx)
801003c5:	83 c3 04             	add    $0x4,%ebx
801003c8:	68 c1 7c 10 80       	push   $0x80107cc1
801003cd:	e8 8e 02 00 00       	call   80100660 <cprintf>
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003d2:	83 c4 10             	add    $0x10,%esp
801003d5:	39 f3                	cmp    %esi,%ebx
801003d7:	75 e7                	jne    801003c0 <panic+0x50>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003d9:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
801003e0:	00 00 00 
801003e3:	eb fe                	jmp    801003e3 <panic+0x73>
801003e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801003e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801003f0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003f0:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
801003f6:	85 d2                	test   %edx,%edx
801003f8:	74 06                	je     80100400 <consputc+0x10>
801003fa:	fa                   	cli    
801003fb:	eb fe                	jmp    801003fb <consputc+0xb>
801003fd:	8d 76 00             	lea    0x0(%esi),%esi
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 0c             	sub    $0xc,%esp
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 b8 00 00 00    	je     801004ce <consputc+0xde>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 41 5f 00 00       	call   80106360 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	c1 e0 08             	shl    $0x8,%eax
8010043f:	89 c1                	mov    %eax,%ecx
80100441:	b8 0f 00 00 00       	mov    $0xf,%eax
80100446:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100447:	89 f2                	mov    %esi,%edx
80100449:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
8010044a:	0f b6 c0             	movzbl %al,%eax
8010044d:	09 c8                	or     %ecx,%eax

  if(c == '\n')
8010044f:	83 fb 0a             	cmp    $0xa,%ebx
80100452:	0f 84 0b 01 00 00    	je     80100563 <consputc+0x173>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
80100458:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045e:	0f 84 e6 00 00 00    	je     8010054a <consputc+0x15a>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100464:	0f b6 d3             	movzbl %bl,%edx
80100467:	8d 78 01             	lea    0x1(%eax),%edi
8010046a:	80 ce 07             	or     $0x7,%dh
8010046d:	66 89 94 00 00 80 0b 	mov    %dx,-0x7ff48000(%eax,%eax,1)
80100474:	80 

  if(pos < 0 || pos > 25*80)
80100475:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
8010047b:	0f 8f bc 00 00 00    	jg     8010053d <consputc+0x14d>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
80100481:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100487:	7f 6f                	jg     801004f8 <consputc+0x108>
80100489:	89 f8                	mov    %edi,%eax
8010048b:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
80100492:	89 fb                	mov    %edi,%ebx
80100494:	c1 e8 08             	shr    $0x8,%eax
80100497:	89 c6                	mov    %eax,%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100499:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010049e:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a3:	89 fa                	mov    %edi,%edx
801004a5:	ee                   	out    %al,(%dx)
801004a6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004ab:	89 f0                	mov    %esi,%eax
801004ad:	ee                   	out    %al,(%dx)
801004ae:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b3:	89 fa                	mov    %edi,%edx
801004b5:	ee                   	out    %al,(%dx)
801004b6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004bb:	89 d8                	mov    %ebx,%eax
801004bd:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
801004be:	b8 20 07 00 00       	mov    $0x720,%eax
801004c3:	66 89 01             	mov    %ax,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
801004c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c9:	5b                   	pop    %ebx
801004ca:	5e                   	pop    %esi
801004cb:	5f                   	pop    %edi
801004cc:	5d                   	pop    %ebp
801004cd:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004ce:	83 ec 0c             	sub    $0xc,%esp
801004d1:	6a 08                	push   $0x8
801004d3:	e8 88 5e 00 00       	call   80106360 <uartputc>
801004d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004df:	e8 7c 5e 00 00       	call   80106360 <uartputc>
801004e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004eb:	e8 70 5e 00 00       	call   80106360 <uartputc>
801004f0:	83 c4 10             	add    $0x10,%esp
801004f3:	e9 2a ff ff ff       	jmp    80100422 <consputc+0x32>

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f8:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
801004fb:	8d 5f b0             	lea    -0x50(%edi),%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004fe:	68 60 0e 00 00       	push   $0xe60
80100503:	68 a0 80 0b 80       	push   $0x800b80a0
80100508:	68 00 80 0b 80       	push   $0x800b8000
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010050d:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100514:	e8 77 47 00 00       	call   80104c90 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100519:	b8 80 07 00 00       	mov    $0x780,%eax
8010051e:	83 c4 0c             	add    $0xc,%esp
80100521:	29 d8                	sub    %ebx,%eax
80100523:	01 c0                	add    %eax,%eax
80100525:	50                   	push   %eax
80100526:	6a 00                	push   $0x0
80100528:	56                   	push   %esi
80100529:	e8 b2 46 00 00       	call   80104be0 <memset>
8010052e:	89 f1                	mov    %esi,%ecx
80100530:	83 c4 10             	add    $0x10,%esp
80100533:	be 07 00 00 00       	mov    $0x7,%esi
80100538:	e9 5c ff ff ff       	jmp    80100499 <consputc+0xa9>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010053d:	83 ec 0c             	sub    $0xc,%esp
80100540:	68 c5 7c 10 80       	push   $0x80107cc5
80100545:	e8 26 fe ff ff       	call   80100370 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
8010054a:	85 c0                	test   %eax,%eax
8010054c:	8d 78 ff             	lea    -0x1(%eax),%edi
8010054f:	0f 85 20 ff ff ff    	jne    80100475 <consputc+0x85>
80100555:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
8010055a:	31 db                	xor    %ebx,%ebx
8010055c:	31 f6                	xor    %esi,%esi
8010055e:	e9 36 ff ff ff       	jmp    80100499 <consputc+0xa9>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
80100563:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100568:	f7 ea                	imul   %edx
8010056a:	89 d0                	mov    %edx,%eax
8010056c:	c1 e8 05             	shr    $0x5,%eax
8010056f:	8d 04 80             	lea    (%eax,%eax,4),%eax
80100572:	c1 e0 04             	shl    $0x4,%eax
80100575:	8d 78 50             	lea    0x50(%eax),%edi
80100578:	e9 f8 fe ff ff       	jmp    80100475 <consputc+0x85>
8010057d:	8d 76 00             	lea    0x0(%esi),%esi

80100580 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d6                	mov    %edx,%esi
80100588:	83 ec 2c             	sub    $0x2c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100590:	74 0c                	je     8010059e <printint+0x1e>
80100592:	89 c7                	mov    %eax,%edi
80100594:	c1 ef 1f             	shr    $0x1f,%edi
80100597:	85 c0                	test   %eax,%eax
80100599:	89 7d d4             	mov    %edi,-0x2c(%ebp)
8010059c:	78 51                	js     801005ef <printint+0x6f>
    x = -xx;
  else
    x = xx;

  i = 0;
8010059e:	31 ff                	xor    %edi,%edi
801005a0:	8d 5d d7             	lea    -0x29(%ebp),%ebx
801005a3:	eb 05                	jmp    801005aa <printint+0x2a>
801005a5:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
801005a8:	89 cf                	mov    %ecx,%edi
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 4f 01             	lea    0x1(%edi),%ecx
801005af:	f7 f6                	div    %esi
801005b1:	0f b6 92 f0 7c 10 80 	movzbl -0x7fef8310(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005ba:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>

  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
801005cb:	8d 4f 02             	lea    0x2(%edi),%ecx
801005ce:	8d 74 0d d7          	lea    -0x29(%ebp,%ecx,1),%esi
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  while(--i >= 0)
    consputc(buf[i]);
801005d8:	0f be 06             	movsbl (%esi),%eax
801005db:	83 ee 01             	sub    $0x1,%esi
801005de:	e8 0d fe ff ff       	call   801003f0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005e3:	39 de                	cmp    %ebx,%esi
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
    consputc(buf[i]);
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
801005ef:	f7 d8                	neg    %eax
801005f1:	eb ab                	jmp    8010059e <printint+0x1e>
801005f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100600 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100609:	ff 75 08             	pushl  0x8(%ebp)
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
8010060c:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060f:	e8 bc 11 00 00       	call   801017d0 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 30 44 00 00       	call   80104a50 <acquire>
80100620:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100623:	83 c4 10             	add    $0x10,%esp
80100626:	85 f6                	test   %esi,%esi
80100628:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062b:	7e 12                	jle    8010063f <consolewrite+0x3f>
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 b5 fd ff ff       	call   801003f0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
8010063b:	39 df                	cmp    %ebx,%edi
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 b5 10 80       	push   $0x8010b520
80100647:	e8 44 45 00 00       	call   80104b90 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 9b 10 00 00       	call   801016f0 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100669:	a1 54 b5 10 80       	mov    0x8010b554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100670:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100673:	0f 85 47 01 00 00    	jne    801007c0 <cprintf+0x160>
    acquire(&cons.lock);

  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c1                	mov    %eax,%ecx
80100680:	0f 84 4f 01 00 00    	je     801007d5 <cprintf+0x175>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
80100689:	31 db                	xor    %ebx,%ebx
8010068b:	8d 75 0c             	lea    0xc(%ebp),%esi
8010068e:	89 cf                	mov    %ecx,%edi
80100690:	85 c0                	test   %eax,%eax
80100692:	75 55                	jne    801006e9 <cprintf+0x89>
80100694:	eb 68                	jmp    801006fe <cprintf+0x9e>
80100696:	8d 76 00             	lea    0x0(%esi),%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
801006a0:	83 c3 01             	add    $0x1,%ebx
801006a3:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
801006a7:	85 d2                	test   %edx,%edx
801006a9:	74 53                	je     801006fe <cprintf+0x9e>
      break;
    switch(c){
801006ab:	83 fa 70             	cmp    $0x70,%edx
801006ae:	74 7a                	je     8010072a <cprintf+0xca>
801006b0:	7f 6e                	jg     80100720 <cprintf+0xc0>
801006b2:	83 fa 25             	cmp    $0x25,%edx
801006b5:	0f 84 ad 00 00 00    	je     80100768 <cprintf+0x108>
801006bb:	83 fa 64             	cmp    $0x64,%edx
801006be:	0f 85 84 00 00 00    	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
801006c4:	8d 46 04             	lea    0x4(%esi),%eax
801006c7:	b9 01 00 00 00       	mov    $0x1,%ecx
801006cc:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d4:	8b 06                	mov    (%esi),%eax
801006d6:	e8 a5 fe ff ff       	call   80100580 <printint>
801006db:	8b 75 e4             	mov    -0x1c(%ebp),%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006de:	83 c3 01             	add    $0x1,%ebx
801006e1:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e5:	85 c0                	test   %eax,%eax
801006e7:	74 15                	je     801006fe <cprintf+0x9e>
    if(c != '%'){
801006e9:	83 f8 25             	cmp    $0x25,%eax
801006ec:	74 b2                	je     801006a0 <cprintf+0x40>
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
801006ee:	e8 fd fc ff ff       	call   801003f0 <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006f3:	83 c3 01             	add    $0x1,%ebx
801006f6:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006fa:	85 c0                	test   %eax,%eax
801006fc:	75 eb                	jne    801006e9 <cprintf+0x89>
      consputc(c);
      break;
    }
  }

  if(locking)
801006fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100701:	85 c0                	test   %eax,%eax
80100703:	74 10                	je     80100715 <cprintf+0xb5>
    release(&cons.lock);
80100705:	83 ec 0c             	sub    $0xc,%esp
80100708:	68 20 b5 10 80       	push   $0x8010b520
8010070d:	e8 7e 44 00 00       	call   80104b90 <release>
80100712:	83 c4 10             	add    $0x10,%esp
}
80100715:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100718:	5b                   	pop    %ebx
80100719:	5e                   	pop    %esi
8010071a:	5f                   	pop    %edi
8010071b:	5d                   	pop    %ebp
8010071c:	c3                   	ret    
8010071d:	8d 76 00             	lea    0x0(%esi),%esi
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100720:	83 fa 73             	cmp    $0x73,%edx
80100723:	74 5b                	je     80100780 <cprintf+0x120>
80100725:	83 fa 78             	cmp    $0x78,%edx
80100728:	75 1e                	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010072a:	8d 46 04             	lea    0x4(%esi),%eax
8010072d:	31 c9                	xor    %ecx,%ecx
8010072f:	ba 10 00 00 00       	mov    $0x10,%edx
80100734:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100737:	8b 06                	mov    (%esi),%eax
80100739:	e8 42 fe ff ff       	call   80100580 <printint>
8010073e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100741:	eb 9b                	jmp    801006de <cprintf+0x7e>
80100743:	90                   	nop
80100744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100750:	e8 9b fc ff ff       	call   801003f0 <consputc>
      consputc(c);
80100755:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100758:	89 d0                	mov    %edx,%eax
8010075a:	e8 91 fc ff ff       	call   801003f0 <consputc>
      break;
8010075f:	e9 7a ff ff ff       	jmp    801006de <cprintf+0x7e>
80100764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100768:	b8 25 00 00 00       	mov    $0x25,%eax
8010076d:	e8 7e fc ff ff       	call   801003f0 <consputc>
80100772:	e9 7c ff ff ff       	jmp    801006f3 <cprintf+0x93>
80100777:	89 f6                	mov    %esi,%esi
80100779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100780:	8d 46 04             	lea    0x4(%esi),%eax
80100783:	8b 36                	mov    (%esi),%esi
80100785:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100788:	b8 d8 7c 10 80       	mov    $0x80107cd8,%eax
8010078d:	85 f6                	test   %esi,%esi
8010078f:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
80100792:	0f be 06             	movsbl (%esi),%eax
80100795:	84 c0                	test   %al,%al
80100797:	74 16                	je     801007af <cprintf+0x14f>
80100799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007a0:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
801007a3:	e8 48 fc ff ff       	call   801003f0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801007a8:	0f be 06             	movsbl (%esi),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
801007af:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801007b2:	e9 27 ff ff ff       	jmp    801006de <cprintf+0x7e>
801007b7:	89 f6                	mov    %esi,%esi
801007b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
801007c0:	83 ec 0c             	sub    $0xc,%esp
801007c3:	68 20 b5 10 80       	push   $0x8010b520
801007c8:	e8 83 42 00 00       	call   80104a50 <acquire>
801007cd:	83 c4 10             	add    $0x10,%esp
801007d0:	e9 a4 fe ff ff       	jmp    80100679 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007d5:	83 ec 0c             	sub    $0xc,%esp
801007d8:	68 df 7c 10 80       	push   $0x80107cdf
801007dd:	e8 8e fb ff ff       	call   80100370 <panic>
801007e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801007f0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f0:	55                   	push   %ebp
801007f1:	89 e5                	mov    %esp,%ebp
801007f3:	57                   	push   %edi
801007f4:	56                   	push   %esi
801007f5:	53                   	push   %ebx
  int c, doprocdump = 0;
801007f6:	31 f6                	xor    %esi,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f8:	83 ec 18             	sub    $0x18,%esp
801007fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
801007fe:	68 20 b5 10 80       	push   $0x8010b520
80100803:	e8 48 42 00 00       	call   80104a50 <acquire>
  while((c = getc()) >= 0){
80100808:	83 c4 10             	add    $0x10,%esp
8010080b:	90                   	nop
8010080c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100810:	ff d3                	call   *%ebx
80100812:	85 c0                	test   %eax,%eax
80100814:	89 c7                	mov    %eax,%edi
80100816:	78 48                	js     80100860 <consoleintr+0x70>
    switch(c){
80100818:	83 ff 10             	cmp    $0x10,%edi
8010081b:	0f 84 3f 01 00 00    	je     80100960 <consoleintr+0x170>
80100821:	7e 5d                	jle    80100880 <consoleintr+0x90>
80100823:	83 ff 15             	cmp    $0x15,%edi
80100826:	0f 84 dc 00 00 00    	je     80100908 <consoleintr+0x118>
8010082c:	83 ff 7f             	cmp    $0x7f,%edi
8010082f:	75 54                	jne    80100885 <consoleintr+0x95>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100831:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100836:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010083c:	74 d2                	je     80100810 <consoleintr+0x20>
        input.e--;
8010083e:	83 e8 01             	sub    $0x1,%eax
80100841:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
        consputc(BACKSPACE);
80100846:	b8 00 01 00 00       	mov    $0x100,%eax
8010084b:	e8 a0 fb ff ff       	call   801003f0 <consputc>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100850:	ff d3                	call   *%ebx
80100852:	85 c0                	test   %eax,%eax
80100854:	89 c7                	mov    %eax,%edi
80100856:	79 c0                	jns    80100818 <consoleintr+0x28>
80100858:	90                   	nop
80100859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100860:	83 ec 0c             	sub    $0xc,%esp
80100863:	68 20 b5 10 80       	push   $0x8010b520
80100868:	e8 23 43 00 00       	call   80104b90 <release>
  if(doprocdump) {
8010086d:	83 c4 10             	add    $0x10,%esp
80100870:	85 f6                	test   %esi,%esi
80100872:	0f 85 f8 00 00 00    	jne    80100970 <consoleintr+0x180>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100878:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010087b:	5b                   	pop    %ebx
8010087c:	5e                   	pop    %esi
8010087d:	5f                   	pop    %edi
8010087e:	5d                   	pop    %ebp
8010087f:	c3                   	ret    
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100880:	83 ff 08             	cmp    $0x8,%edi
80100883:	74 ac                	je     80100831 <consoleintr+0x41>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100885:	85 ff                	test   %edi,%edi
80100887:	74 87                	je     80100810 <consoleintr+0x20>
80100889:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010088e:	89 c2                	mov    %eax,%edx
80100890:	2b 15 a0 0f 11 80    	sub    0x80110fa0,%edx
80100896:	83 fa 7f             	cmp    $0x7f,%edx
80100899:	0f 87 71 ff ff ff    	ja     80100810 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010089f:	8d 50 01             	lea    0x1(%eax),%edx
801008a2:	83 e0 7f             	and    $0x7f,%eax
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008a5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008a8:	89 15 a8 0f 11 80    	mov    %edx,0x80110fa8
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008ae:	0f 84 c8 00 00 00    	je     8010097c <consoleintr+0x18c>
        input.buf[input.e++ % INPUT_BUF] = c;
801008b4:	89 f9                	mov    %edi,%ecx
801008b6:	88 88 20 0f 11 80    	mov    %cl,-0x7feef0e0(%eax)
        consputc(c);
801008bc:	89 f8                	mov    %edi,%eax
801008be:	e8 2d fb ff ff       	call   801003f0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c3:	83 ff 0a             	cmp    $0xa,%edi
801008c6:	0f 84 c1 00 00 00    	je     8010098d <consoleintr+0x19d>
801008cc:	83 ff 04             	cmp    $0x4,%edi
801008cf:	0f 84 b8 00 00 00    	je     8010098d <consoleintr+0x19d>
801008d5:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801008da:	83 e8 80             	sub    $0xffffff80,%eax
801008dd:	39 05 a8 0f 11 80    	cmp    %eax,0x80110fa8
801008e3:	0f 85 27 ff ff ff    	jne    80100810 <consoleintr+0x20>
          input.w = input.e;
          wakeup(&input.r);
801008e9:	83 ec 0c             	sub    $0xc,%esp
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
801008ec:	a3 a4 0f 11 80       	mov    %eax,0x80110fa4
          wakeup(&input.r);
801008f1:	68 a0 0f 11 80       	push   $0x80110fa0
801008f6:	e8 85 3c 00 00       	call   80104580 <wakeup>
801008fb:	83 c4 10             	add    $0x10,%esp
801008fe:	e9 0d ff ff ff       	jmp    80100810 <consoleintr+0x20>
80100903:	90                   	nop
80100904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100908:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010090d:	39 05 a4 0f 11 80    	cmp    %eax,0x80110fa4
80100913:	75 2b                	jne    80100940 <consoleintr+0x150>
80100915:	e9 f6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100920:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
        consputc(BACKSPACE);
80100925:	b8 00 01 00 00       	mov    $0x100,%eax
8010092a:	e8 c1 fa ff ff       	call   801003f0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010092f:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100934:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010093a:	0f 84 d0 fe ff ff    	je     80100810 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100940:	83 e8 01             	sub    $0x1,%eax
80100943:	89 c2                	mov    %eax,%edx
80100945:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100948:	80 ba 20 0f 11 80 0a 	cmpb   $0xa,-0x7feef0e0(%edx)
8010094f:	75 cf                	jne    80100920 <consoleintr+0x130>
80100951:	e9 ba fe ff ff       	jmp    80100810 <consoleintr+0x20>
80100956:	8d 76 00             	lea    0x0(%esi),%esi
80100959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100960:	be 01 00 00 00       	mov    $0x1,%esi
80100965:	e9 a6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010096a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100970:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100973:	5b                   	pop    %ebx
80100974:	5e                   	pop    %esi
80100975:	5f                   	pop    %edi
80100976:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
80100977:	e9 f4 3c 00 00       	jmp    80104670 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010097c:	c6 80 20 0f 11 80 0a 	movb   $0xa,-0x7feef0e0(%eax)
        consputc(c);
80100983:	b8 0a 00 00 00       	mov    $0xa,%eax
80100988:	e8 63 fa ff ff       	call   801003f0 <consputc>
8010098d:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100992:	e9 52 ff ff ff       	jmp    801008e9 <consoleintr+0xf9>
80100997:	89 f6                	mov    %esi,%esi
80100999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801009a0 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009a6:	68 e8 7c 10 80       	push   $0x80107ce8
801009ab:	68 20 b5 10 80       	push   $0x8010b520
801009b0:	e8 9b 3f 00 00       	call   80104950 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009b5:	58                   	pop    %eax
801009b6:	5a                   	pop    %edx
801009b7:	6a 00                	push   $0x0
801009b9:	6a 01                	push   $0x1
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
801009bb:	c7 05 6c 19 11 80 00 	movl   $0x80100600,0x8011196c
801009c2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009c5:	c7 05 68 19 11 80 70 	movl   $0x80100270,0x80111968
801009cc:	02 10 80 
  cons.locking = 1;
801009cf:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
801009d6:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
801009d9:	e8 e2 1c 00 00       	call   801026c0 <ioapicenable>
}
801009de:	83 c4 10             	add    $0x10,%esp
801009e1:	c9                   	leave  
801009e2:	c3                   	ret    
801009e3:	66 90                	xchg   %ax,%ax
801009e5:	66 90                	xchg   %ax,%ax
801009e7:	66 90                	xchg   %ax,%ax
801009e9:	66 90                	xchg   %ax,%ax
801009eb:	66 90                	xchg   %ax,%ax
801009ed:	66 90                	xchg   %ax,%ax
801009ef:	90                   	nop

801009f0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009f0:	55                   	push   %ebp
801009f1:	89 e5                	mov    %esp,%ebp
801009f3:	57                   	push   %edi
801009f4:	56                   	push   %esi
801009f5:	53                   	push   %ebx
801009f6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009fc:	e8 5f 32 00 00       	call   80103c60 <myproc>
80100a01:	89 c6                	mov    %eax,%esi

  begin_op();
80100a03:	e8 a8 25 00 00       	call   80102fb0 <begin_op>

  if((ip = namei(path)) == 0){
80100a08:	83 ec 0c             	sub    $0xc,%esp
80100a0b:	ff 75 08             	pushl  0x8(%ebp)
80100a0e:	e8 2d 15 00 00       	call   80101f40 <namei>
80100a13:	83 c4 10             	add    $0x10,%esp
80100a16:	85 c0                	test   %eax,%eax
80100a18:	0f 84 12 02 00 00    	je     80100c30 <exec+0x240>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a1e:	83 ec 0c             	sub    $0xc,%esp
80100a21:	89 c3                	mov    %eax,%ebx
80100a23:	50                   	push   %eax
80100a24:	e8 c7 0c 00 00       	call   801016f0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a29:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a2f:	6a 34                	push   $0x34
80100a31:	6a 00                	push   $0x0
80100a33:	50                   	push   %eax
80100a34:	53                   	push   %ebx
80100a35:	e8 96 0f 00 00       	call   801019d0 <readi>
80100a3a:	83 c4 20             	add    $0x20,%esp
80100a3d:	83 f8 34             	cmp    $0x34,%eax
80100a40:	74 1e                	je     80100a60 <exec+0x70>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a42:	83 ec 0c             	sub    $0xc,%esp
80100a45:	53                   	push   %ebx
80100a46:	e8 35 0f 00 00       	call   80101980 <iunlockput>
    end_op();
80100a4b:	e8 d0 25 00 00       	call   80103020 <end_op>
80100a50:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a5b:	5b                   	pop    %ebx
80100a5c:	5e                   	pop    %esi
80100a5d:	5f                   	pop    %edi
80100a5e:	5d                   	pop    %ebp
80100a5f:	c3                   	ret    
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a60:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a67:	45 4c 46 
80100a6a:	75 d6                	jne    80100a42 <exec+0x52>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a6c:	e8 9f 6a 00 00       	call   80107510 <setupkvm>
80100a71:	85 c0                	test   %eax,%eax
80100a73:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100a79:	74 c7                	je     80100a42 <exec+0x52>
80100a7b:	8d 86 94 00 00 00    	lea    0x94(%esi),%eax
80100a81:	8d 96 14 01 00 00    	lea    0x114(%esi),%edx
    goto bad;

  #ifndef NONE
  /// clean paging metadata
  curproc->num_of_pages_in_memory = 0;
80100a87:	c7 86 80 00 00 00 00 	movl   $0x0,0x80(%esi)
80100a8e:	00 00 00 
  curproc->num_of_currently_swapped_out_pages = 0;
80100a91:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
80100a98:	00 00 00 
  curproc->num_of_total_swap_out_actions = 0;
80100a9b:	c7 86 88 00 00 00 00 	movl   $0x0,0x88(%esi)
80100aa2:	00 00 00 
  curproc->num_of_page_faults = 0;
80100aa5:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80100aac:	00 00 00 
80100aaf:	90                   	nop

  for(i = 0 ; i < MAX_PSYC_PAGES ; i++){
    curproc->sfm[i].in_swap_file = 0;
80100ab0:	c6 00 00             	movb   $0x0,(%eax)
80100ab3:	83 c0 08             	add    $0x8,%eax
  curproc->num_of_pages_in_memory = 0;
  curproc->num_of_currently_swapped_out_pages = 0;
  curproc->num_of_total_swap_out_actions = 0;
  curproc->num_of_page_faults = 0;

  for(i = 0 ; i < MAX_PSYC_PAGES ; i++){
80100ab6:	39 c2                	cmp    %eax,%edx
80100ab8:	75 f6                	jne    80100ab0 <exec+0xc0>
80100aba:	8d 86 20 01 00 00    	lea    0x120(%esi),%eax
80100ac0:	8d 96 60 02 00 00    	lea    0x260(%esi),%edx
80100ac6:	8d 76 00             	lea    0x0(%esi),%esi
80100ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    curproc->sfm[i].in_swap_file = 0;
  }

  for(i = 0 ; i < MAX_PSYC_PAGES ; i++){
    curproc->mem_pages[i].in_mem = 0;
80100ad0:	c6 00 00             	movb   $0x0,(%eax)
80100ad3:	83 c0 14             	add    $0x14,%eax

  for(i = 0 ; i < MAX_PSYC_PAGES ; i++){
    curproc->sfm[i].in_swap_file = 0;
  }

  for(i = 0 ; i < MAX_PSYC_PAGES ; i++){
80100ad6:	39 d0                	cmp    %edx,%eax
80100ad8:	75 f6                	jne    80100ad0 <exec+0xe0>

  #endif

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ada:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100ae1:	00 

  for(i = 0 ; i < MAX_PSYC_PAGES ; i++){
    curproc->mem_pages[i].in_mem = 0;
  }

  curproc->first = 0;
80100ae2:	c7 86 50 02 00 00 00 	movl   $0x0,0x250(%esi)
80100ae9:	00 00 00 

  #endif

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100aec:	8b bd 40 ff ff ff    	mov    -0xc0(%ebp),%edi
80100af2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100af9:	00 00 00 
80100afc:	0f 84 d2 00 00 00    	je     80100bd4 <exec+0x1e4>
80100b02:	31 c0                	xor    %eax,%eax
80100b04:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100b0a:	89 c6                	mov    %eax,%esi
80100b0c:	eb 17                	jmp    80100b25 <exec+0x135>
80100b0e:	66 90                	xchg   %ax,%ax
80100b10:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b17:	83 c6 01             	add    $0x1,%esi
80100b1a:	83 c7 20             	add    $0x20,%edi
80100b1d:	39 f0                	cmp    %esi,%eax
80100b1f:	0f 8e a9 00 00 00    	jle    80100bce <exec+0x1de>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b25:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b2b:	6a 20                	push   $0x20
80100b2d:	57                   	push   %edi
80100b2e:	50                   	push   %eax
80100b2f:	53                   	push   %ebx
80100b30:	e8 9b 0e 00 00       	call   801019d0 <readi>
80100b35:	83 c4 10             	add    $0x10,%esp
80100b38:	83 f8 20             	cmp    $0x20,%eax
80100b3b:	75 7b                	jne    80100bb8 <exec+0x1c8>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100b3d:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b44:	75 ca                	jne    80100b10 <exec+0x120>
      continue;
    if(ph.memsz < ph.filesz)
80100b46:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b4c:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b52:	72 64                	jb     80100bb8 <exec+0x1c8>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b54:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b5a:	72 5c                	jb     80100bb8 <exec+0x1c8>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b5c:	83 ec 04             	sub    $0x4,%esp
80100b5f:	50                   	push   %eax
80100b60:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b66:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b6c:	e8 7f 6f 00 00       	call   80107af0 <allocuvm>
80100b71:	83 c4 10             	add    $0x10,%esp
80100b74:	85 c0                	test   %eax,%eax
80100b76:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b7c:	74 3a                	je     80100bb8 <exec+0x1c8>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100b7e:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b84:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b89:	75 2d                	jne    80100bb8 <exec+0x1c8>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b8b:	83 ec 0c             	sub    $0xc,%esp
80100b8e:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b94:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b9a:	53                   	push   %ebx
80100b9b:	50                   	push   %eax
80100b9c:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ba2:	e8 f9 67 00 00       	call   801073a0 <loaduvm>
80100ba7:	83 c4 20             	add    $0x20,%esp
80100baa:	85 c0                	test   %eax,%eax
80100bac:	0f 89 5e ff ff ff    	jns    80100b10 <exec+0x120>
80100bb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100bc1:	e8 ca 68 00 00       	call   80107490 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
80100bc9:	e9 74 fe ff ff       	jmp    80100a42 <exec+0x52>
80100bce:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100bd4:	83 ec 0c             	sub    $0xc,%esp
80100bd7:	53                   	push   %ebx
80100bd8:	e8 a3 0d 00 00       	call   80101980 <iunlockput>
  end_op();
80100bdd:	e8 3e 24 00 00       	call   80103020 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100be2:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100be8:	83 c4 0c             	add    $0xc,%esp
  end_op();
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100beb:	05 ff 0f 00 00       	add    $0xfff,%eax
80100bf0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100bf5:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100bfb:	52                   	push   %edx
80100bfc:	50                   	push   %eax
80100bfd:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c03:	e8 e8 6e 00 00       	call   80107af0 <allocuvm>
80100c08:	83 c4 10             	add    $0x10,%esp
80100c0b:	85 c0                	test   %eax,%eax
80100c0d:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100c13:	75 3a                	jne    80100c4f <exec+0x25f>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100c15:	83 ec 0c             	sub    $0xc,%esp
80100c18:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c1e:	e8 6d 68 00 00       	call   80107490 <freevm>
80100c23:	83 c4 10             	add    $0x10,%esp
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100c26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c2b:	e9 28 fe ff ff       	jmp    80100a58 <exec+0x68>
  struct proc *curproc = myproc();

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
80100c30:	e8 eb 23 00 00       	call   80103020 <end_op>
    cprintf("exec: fail\n");
80100c35:	83 ec 0c             	sub    $0xc,%esp
80100c38:	68 01 7d 10 80       	push   $0x80107d01
80100c3d:	e8 1e fa ff ff       	call   80100660 <cprintf>
    return -1;
80100c42:	83 c4 10             	add    $0x10,%esp
80100c45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c4a:	e9 09 fe ff ff       	jmp    80100a58 <exec+0x68>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c4f:	8b 9d f0 fe ff ff    	mov    -0x110(%ebp),%ebx
80100c55:	83 ec 08             	sub    $0x8,%esp
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c58:	31 ff                	xor    %edi,%edi
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c5a:	89 d8                	mov    %ebx,%eax
80100c5c:	2d 00 20 00 00       	sub    $0x2000,%eax
80100c61:	50                   	push   %eax
80100c62:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c68:	e8 43 69 00 00       	call   801075b0 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c70:	83 c4 10             	add    $0x10,%esp
80100c73:	8b 00                	mov    (%eax),%eax
80100c75:	85 c0                	test   %eax,%eax
80100c77:	0f 84 3c 01 00 00    	je     80100db9 <exec+0x3c9>
80100c7d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c83:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c89:	eb 0a                	jmp    80100c95 <exec+0x2a5>
80100c8b:	90                   	nop
80100c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c90:	83 ff 20             	cmp    $0x20,%edi
80100c93:	74 80                	je     80100c15 <exec+0x225>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c95:	83 ec 0c             	sub    $0xc,%esp
80100c98:	50                   	push   %eax
80100c99:	e8 82 41 00 00       	call   80104e20 <strlen>
80100c9e:	f7 d0                	not    %eax
80100ca0:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ca2:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ca5:	5a                   	pop    %edx

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ca6:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ca9:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cac:	e8 6f 41 00 00       	call   80104e20 <strlen>
80100cb1:	83 c0 01             	add    $0x1,%eax
80100cb4:	50                   	push   %eax
80100cb5:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cb8:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cbb:	53                   	push   %ebx
80100cbc:	56                   	push   %esi
80100cbd:	e8 4e 6a 00 00       	call   80107710 <copyout>
80100cc2:	83 c4 20             	add    $0x20,%esp
80100cc5:	85 c0                	test   %eax,%eax
80100cc7:	0f 88 48 ff ff ff    	js     80100c15 <exec+0x225>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100ccd:	8b 45 0c             	mov    0xc(%ebp),%eax
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100cd0:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100cd7:	83 c7 01             	add    $0x1,%edi
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100cda:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100ce0:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100ce3:	85 c0                	test   %eax,%eax
80100ce5:	75 a9                	jne    80100c90 <exec+0x2a0>
80100ce7:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ced:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100cf4:	89 d9                	mov    %ebx,%ecx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100cf6:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100cfd:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100d01:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d08:	ff ff ff 
  ustack[1] = argc;
80100d0b:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d11:	29 c1                	sub    %eax,%ecx

  sp -= (3+argc+1) * 4;
80100d13:	83 c0 0c             	add    $0xc,%eax
80100d16:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d18:	50                   	push   %eax
80100d19:	52                   	push   %edx
80100d1a:	53                   	push   %ebx
80100d1b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d21:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d27:	e8 e4 69 00 00       	call   80107710 <copyout>
80100d2c:	83 c4 10             	add    $0x10,%esp
80100d2f:	85 c0                	test   %eax,%eax
80100d31:	0f 88 de fe ff ff    	js     80100c15 <exec+0x225>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100d37:	8b 45 08             	mov    0x8(%ebp),%eax
80100d3a:	0f b6 10             	movzbl (%eax),%edx
80100d3d:	84 d2                	test   %dl,%dl
80100d3f:	74 19                	je     80100d5a <exec+0x36a>
80100d41:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100d44:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
80100d47:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100d4a:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100d4d:	0f 44 c8             	cmove  %eax,%ecx
80100d50:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100d53:	84 d2                	test   %dl,%dl
80100d55:	75 f0                	jne    80100d47 <exec+0x357>
80100d57:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d5a:	50                   	push   %eax
80100d5b:	8d 46 6c             	lea    0x6c(%esi),%eax
80100d5e:	6a 10                	push   $0x10
80100d60:	ff 75 08             	pushl  0x8(%ebp)
80100d63:	50                   	push   %eax
80100d64:	e8 77 40 00 00       	call   80104de0 <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100d69:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100d6f:	8b 7e 04             	mov    0x4(%esi),%edi
  curproc->pgdir = pgdir;
80100d72:	89 46 04             	mov    %eax,0x4(%esi)
  curproc->sz = sz;
80100d75:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100d7b:	89 06                	mov    %eax,(%esi)
  curproc->tf->eip = elf.entry;  // main
80100d7d:	8b 46 18             	mov    0x18(%esi),%eax
80100d80:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d86:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d89:	8b 46 18             	mov    0x18(%esi),%eax
80100d8c:	89 58 44             	mov    %ebx,0x44(%eax)

  #ifndef NONE
  /// create new swapfile for process
  removeSwapFile(curproc);
80100d8f:	89 34 24             	mov    %esi,(%esp)
80100d92:	e8 89 12 00 00       	call   80102020 <removeSwapFile>
  createSwapFile(curproc);
80100d97:	89 34 24             	mov    %esi,(%esp)
80100d9a:	e8 81 14 00 00       	call   80102220 <createSwapFile>
  #endif

  switchuvm(curproc);
80100d9f:	89 34 24             	mov    %esi,(%esp)
80100da2:	e8 69 64 00 00       	call   80107210 <switchuvm>
  freevm(oldpgdir);
80100da7:	89 3c 24             	mov    %edi,(%esp)
80100daa:	e8 e1 66 00 00       	call   80107490 <freevm>
  return 0;
80100daf:	83 c4 10             	add    $0x10,%esp
80100db2:	31 c0                	xor    %eax,%eax
80100db4:	e9 9f fc ff ff       	jmp    80100a58 <exec+0x68>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100db9:	8b 9d f0 fe ff ff    	mov    -0x110(%ebp),%ebx
80100dbf:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100dc5:	e9 23 ff ff ff       	jmp    80100ced <exec+0x2fd>
80100dca:	66 90                	xchg   %ax,%ax
80100dcc:	66 90                	xchg   %ax,%ax
80100dce:	66 90                	xchg   %ax,%ax

80100dd0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100dd0:	55                   	push   %ebp
80100dd1:	89 e5                	mov    %esp,%ebp
80100dd3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100dd6:	68 0d 7d 10 80       	push   $0x80107d0d
80100ddb:	68 c0 0f 11 80       	push   $0x80110fc0
80100de0:	e8 6b 3b 00 00       	call   80104950 <initlock>
}
80100de5:	83 c4 10             	add    $0x10,%esp
80100de8:	c9                   	leave  
80100de9:	c3                   	ret    
80100dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100df0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100df4:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100df9:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100dfc:	68 c0 0f 11 80       	push   $0x80110fc0
80100e01:	e8 4a 3c 00 00       	call   80104a50 <acquire>
80100e06:	83 c4 10             	add    $0x10,%esp
80100e09:	eb 10                	jmp    80100e1b <filealloc+0x2b>
80100e0b:	90                   	nop
80100e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e10:	83 c3 18             	add    $0x18,%ebx
80100e13:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
80100e19:	74 25                	je     80100e40 <filealloc+0x50>
    if(f->ref == 0){
80100e1b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e1e:	85 c0                	test   %eax,%eax
80100e20:	75 ee                	jne    80100e10 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e22:	83 ec 0c             	sub    $0xc,%esp
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100e25:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e2c:	68 c0 0f 11 80       	push   $0x80110fc0
80100e31:	e8 5a 3d 00 00       	call   80104b90 <release>
      return f;
80100e36:	89 d8                	mov    %ebx,%eax
80100e38:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e3e:	c9                   	leave  
80100e3f:	c3                   	ret    
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100e40:	83 ec 0c             	sub    $0xc,%esp
80100e43:	68 c0 0f 11 80       	push   $0x80110fc0
80100e48:	e8 43 3d 00 00       	call   80104b90 <release>
  return 0;
80100e4d:	83 c4 10             	add    $0x10,%esp
80100e50:	31 c0                	xor    %eax,%eax
}
80100e52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e55:	c9                   	leave  
80100e56:	c3                   	ret    
80100e57:	89 f6                	mov    %esi,%esi
80100e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e60 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e60:	55                   	push   %ebp
80100e61:	89 e5                	mov    %esp,%ebp
80100e63:	53                   	push   %ebx
80100e64:	83 ec 10             	sub    $0x10,%esp
80100e67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e6a:	68 c0 0f 11 80       	push   $0x80110fc0
80100e6f:	e8 dc 3b 00 00       	call   80104a50 <acquire>
  if(f->ref < 1)
80100e74:	8b 43 04             	mov    0x4(%ebx),%eax
80100e77:	83 c4 10             	add    $0x10,%esp
80100e7a:	85 c0                	test   %eax,%eax
80100e7c:	7e 1a                	jle    80100e98 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e7e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e81:	83 ec 0c             	sub    $0xc,%esp
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  f->ref++;
80100e84:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e87:	68 c0 0f 11 80       	push   $0x80110fc0
80100e8c:	e8 ff 3c 00 00       	call   80104b90 <release>
  return f;
}
80100e91:	89 d8                	mov    %ebx,%eax
80100e93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e96:	c9                   	leave  
80100e97:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100e98:	83 ec 0c             	sub    $0xc,%esp
80100e9b:	68 14 7d 10 80       	push   $0x80107d14
80100ea0:	e8 cb f4 ff ff       	call   80100370 <panic>
80100ea5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100eb0 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100eb0:	55                   	push   %ebp
80100eb1:	89 e5                	mov    %esp,%ebp
80100eb3:	57                   	push   %edi
80100eb4:	56                   	push   %esi
80100eb5:	53                   	push   %ebx
80100eb6:	83 ec 28             	sub    $0x28,%esp
80100eb9:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100ebc:	68 c0 0f 11 80       	push   $0x80110fc0
80100ec1:	e8 8a 3b 00 00       	call   80104a50 <acquire>
  if(f->ref < 1)
80100ec6:	8b 47 04             	mov    0x4(%edi),%eax
80100ec9:	83 c4 10             	add    $0x10,%esp
80100ecc:	85 c0                	test   %eax,%eax
80100ece:	0f 8e 9b 00 00 00    	jle    80100f6f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100ed4:	83 e8 01             	sub    $0x1,%eax
80100ed7:	85 c0                	test   %eax,%eax
80100ed9:	89 47 04             	mov    %eax,0x4(%edi)
80100edc:	74 1a                	je     80100ef8 <fileclose+0x48>
    release(&ftable.lock);
80100ede:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100ee5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ee8:	5b                   	pop    %ebx
80100ee9:	5e                   	pop    %esi
80100eea:	5f                   	pop    %edi
80100eeb:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100eec:	e9 9f 3c 00 00       	jmp    80104b90 <release>
80100ef1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  ff = *f;
80100ef8:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100efc:	8b 1f                	mov    (%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100efe:	83 ec 0c             	sub    $0xc,%esp
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f01:	8b 77 0c             	mov    0xc(%edi),%esi
  f->ref = 0;
  f->type = FD_NONE;
80100f04:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f0a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f0d:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f10:	68 c0 0f 11 80       	push   $0x80110fc0
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f15:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f18:	e8 73 3c 00 00       	call   80104b90 <release>

  if(ff.type == FD_PIPE)
80100f1d:	83 c4 10             	add    $0x10,%esp
80100f20:	83 fb 01             	cmp    $0x1,%ebx
80100f23:	74 13                	je     80100f38 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f25:	83 fb 02             	cmp    $0x2,%ebx
80100f28:	74 26                	je     80100f50 <fileclose+0xa0>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f2d:	5b                   	pop    %ebx
80100f2e:	5e                   	pop    %esi
80100f2f:	5f                   	pop    %edi
80100f30:	5d                   	pop    %ebp
80100f31:	c3                   	ret    
80100f32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100f38:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f3c:	83 ec 08             	sub    $0x8,%esp
80100f3f:	53                   	push   %ebx
80100f40:	56                   	push   %esi
80100f41:	e8 0a 28 00 00       	call   80103750 <pipeclose>
80100f46:	83 c4 10             	add    $0x10,%esp
80100f49:	eb df                	jmp    80100f2a <fileclose+0x7a>
80100f4b:	90                   	nop
80100f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100f50:	e8 5b 20 00 00       	call   80102fb0 <begin_op>
    iput(ff.ip);
80100f55:	83 ec 0c             	sub    $0xc,%esp
80100f58:	ff 75 e0             	pushl  -0x20(%ebp)
80100f5b:	e8 c0 08 00 00       	call   80101820 <iput>
    end_op();
80100f60:	83 c4 10             	add    $0x10,%esp
  }
}
80100f63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f66:	5b                   	pop    %ebx
80100f67:	5e                   	pop    %esi
80100f68:	5f                   	pop    %edi
80100f69:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100f6a:	e9 b1 20 00 00       	jmp    80103020 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100f6f:	83 ec 0c             	sub    $0xc,%esp
80100f72:	68 1c 7d 10 80       	push   $0x80107d1c
80100f77:	e8 f4 f3 ff ff       	call   80100370 <panic>
80100f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f80 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f80:	55                   	push   %ebp
80100f81:	89 e5                	mov    %esp,%ebp
80100f83:	53                   	push   %ebx
80100f84:	83 ec 04             	sub    $0x4,%esp
80100f87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f8a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f8d:	75 31                	jne    80100fc0 <filestat+0x40>
    ilock(f->ip);
80100f8f:	83 ec 0c             	sub    $0xc,%esp
80100f92:	ff 73 10             	pushl  0x10(%ebx)
80100f95:	e8 56 07 00 00       	call   801016f0 <ilock>
    stati(f->ip, st);
80100f9a:	58                   	pop    %eax
80100f9b:	5a                   	pop    %edx
80100f9c:	ff 75 0c             	pushl  0xc(%ebp)
80100f9f:	ff 73 10             	pushl  0x10(%ebx)
80100fa2:	e8 f9 09 00 00       	call   801019a0 <stati>
    iunlock(f->ip);
80100fa7:	59                   	pop    %ecx
80100fa8:	ff 73 10             	pushl  0x10(%ebx)
80100fab:	e8 20 08 00 00       	call   801017d0 <iunlock>
    return 0;
80100fb0:	83 c4 10             	add    $0x10,%esp
80100fb3:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100fb5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fb8:	c9                   	leave  
80100fb9:	c3                   	ret    
80100fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fc5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fc8:	c9                   	leave  
80100fc9:	c3                   	ret    
80100fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100fd0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	57                   	push   %edi
80100fd4:	56                   	push   %esi
80100fd5:	53                   	push   %ebx
80100fd6:	83 ec 0c             	sub    $0xc,%esp
80100fd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100fdc:	8b 75 0c             	mov    0xc(%ebp),%esi
80100fdf:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100fe2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100fe6:	74 60                	je     80101048 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100fe8:	8b 03                	mov    (%ebx),%eax
80100fea:	83 f8 01             	cmp    $0x1,%eax
80100fed:	74 41                	je     80101030 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100fef:	83 f8 02             	cmp    $0x2,%eax
80100ff2:	75 5b                	jne    8010104f <fileread+0x7f>
    ilock(f->ip);
80100ff4:	83 ec 0c             	sub    $0xc,%esp
80100ff7:	ff 73 10             	pushl  0x10(%ebx)
80100ffa:	e8 f1 06 00 00       	call   801016f0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100fff:	57                   	push   %edi
80101000:	ff 73 14             	pushl  0x14(%ebx)
80101003:	56                   	push   %esi
80101004:	ff 73 10             	pushl  0x10(%ebx)
80101007:	e8 c4 09 00 00       	call   801019d0 <readi>
8010100c:	83 c4 20             	add    $0x20,%esp
8010100f:	85 c0                	test   %eax,%eax
80101011:	89 c6                	mov    %eax,%esi
80101013:	7e 03                	jle    80101018 <fileread+0x48>
      f->off += r;
80101015:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101018:	83 ec 0c             	sub    $0xc,%esp
8010101b:	ff 73 10             	pushl  0x10(%ebx)
8010101e:	e8 ad 07 00 00       	call   801017d0 <iunlock>
    return r;
80101023:	83 c4 10             	add    $0x10,%esp
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101026:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80101028:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010102b:	5b                   	pop    %ebx
8010102c:	5e                   	pop    %esi
8010102d:	5f                   	pop    %edi
8010102e:	5d                   	pop    %ebp
8010102f:	c3                   	ret    
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80101030:	8b 43 0c             	mov    0xc(%ebx),%eax
80101033:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80101036:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101039:	5b                   	pop    %ebx
8010103a:	5e                   	pop    %esi
8010103b:	5f                   	pop    %edi
8010103c:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
8010103d:	e9 ae 28 00 00       	jmp    801038f0 <piperead>
80101042:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80101048:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010104d:	eb d9                	jmp    80101028 <fileread+0x58>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
8010104f:	83 ec 0c             	sub    $0xc,%esp
80101052:	68 26 7d 10 80       	push   $0x80107d26
80101057:	e8 14 f3 ff ff       	call   80100370 <panic>
8010105c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101060 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101060:	55                   	push   %ebp
80101061:	89 e5                	mov    %esp,%ebp
80101063:	57                   	push   %edi
80101064:	56                   	push   %esi
80101065:	53                   	push   %ebx
80101066:	83 ec 1c             	sub    $0x1c,%esp
80101069:	8b 75 08             	mov    0x8(%ebp),%esi
8010106c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010106f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101073:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101076:	8b 45 10             	mov    0x10(%ebp),%eax
80101079:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
8010107c:	0f 84 aa 00 00 00    	je     8010112c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101082:	8b 06                	mov    (%esi),%eax
80101084:	83 f8 01             	cmp    $0x1,%eax
80101087:	0f 84 c2 00 00 00    	je     8010114f <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010108d:	83 f8 02             	cmp    $0x2,%eax
80101090:	0f 85 d8 00 00 00    	jne    8010116e <filewrite+0x10e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101096:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101099:	31 ff                	xor    %edi,%edi
8010109b:	85 c0                	test   %eax,%eax
8010109d:	7f 34                	jg     801010d3 <filewrite+0x73>
8010109f:	e9 9c 00 00 00       	jmp    80101140 <filewrite+0xe0>
801010a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010a8:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801010ab:	83 ec 0c             	sub    $0xc,%esp
801010ae:	ff 76 10             	pushl  0x10(%esi)
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010b4:	e8 17 07 00 00       	call   801017d0 <iunlock>
      end_op();
801010b9:	e8 62 1f 00 00       	call   80103020 <end_op>
801010be:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010c1:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
801010c4:	39 d8                	cmp    %ebx,%eax
801010c6:	0f 85 95 00 00 00    	jne    80101161 <filewrite+0x101>
        panic("short filewrite");
      i += r;
801010cc:	01 c7                	add    %eax,%edi
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010ce:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010d1:	7e 6d                	jle    80101140 <filewrite+0xe0>
      int n1 = n - i;
801010d3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801010d6:	b8 00 06 00 00       	mov    $0x600,%eax
801010db:	29 fb                	sub    %edi,%ebx
801010dd:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
801010e3:	0f 4f d8             	cmovg  %eax,%ebx
      if(n1 > max)
        n1 = max;

      begin_op();
801010e6:	e8 c5 1e 00 00       	call   80102fb0 <begin_op>
      ilock(f->ip);
801010eb:	83 ec 0c             	sub    $0xc,%esp
801010ee:	ff 76 10             	pushl  0x10(%esi)
801010f1:	e8 fa 05 00 00       	call   801016f0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801010f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801010f9:	53                   	push   %ebx
801010fa:	ff 76 14             	pushl  0x14(%esi)
801010fd:	01 f8                	add    %edi,%eax
801010ff:	50                   	push   %eax
80101100:	ff 76 10             	pushl  0x10(%esi)
80101103:	e8 c8 09 00 00       	call   80101ad0 <writei>
80101108:	83 c4 20             	add    $0x20,%esp
8010110b:	85 c0                	test   %eax,%eax
8010110d:	7f 99                	jg     801010a8 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
8010110f:	83 ec 0c             	sub    $0xc,%esp
80101112:	ff 76 10             	pushl  0x10(%esi)
80101115:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101118:	e8 b3 06 00 00       	call   801017d0 <iunlock>
      end_op();
8010111d:	e8 fe 1e 00 00       	call   80103020 <end_op>

      if(r < 0)
80101122:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101125:	83 c4 10             	add    $0x10,%esp
80101128:	85 c0                	test   %eax,%eax
8010112a:	74 98                	je     801010c4 <filewrite+0x64>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010112c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
8010112f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101134:	5b                   	pop    %ebx
80101135:	5e                   	pop    %esi
80101136:	5f                   	pop    %edi
80101137:	5d                   	pop    %ebp
80101138:	c3                   	ret    
80101139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
80101140:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101143:	75 e7                	jne    8010112c <filewrite+0xcc>
  }
  panic("filewrite");
}
80101145:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101148:	89 f8                	mov    %edi,%eax
8010114a:	5b                   	pop    %ebx
8010114b:	5e                   	pop    %esi
8010114c:	5f                   	pop    %edi
8010114d:	5d                   	pop    %ebp
8010114e:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
8010114f:	8b 46 0c             	mov    0xc(%esi),%eax
80101152:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
80101155:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101158:	5b                   	pop    %ebx
80101159:	5e                   	pop    %esi
8010115a:	5f                   	pop    %edi
8010115b:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
8010115c:	e9 8f 26 00 00       	jmp    801037f0 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
80101161:	83 ec 0c             	sub    $0xc,%esp
80101164:	68 2f 7d 10 80       	push   $0x80107d2f
80101169:	e8 02 f2 ff ff       	call   80100370 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
8010116e:	83 ec 0c             	sub    $0xc,%esp
80101171:	68 35 7d 10 80       	push   $0x80107d35
80101176:	e8 f5 f1 ff ff       	call   80100370 <panic>
8010117b:	66 90                	xchg   %ax,%ax
8010117d:	66 90                	xchg   %ax,%ax
8010117f:	90                   	nop

80101180 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101180:	55                   	push   %ebp
80101181:	89 e5                	mov    %esp,%ebp
80101183:	57                   	push   %edi
80101184:	56                   	push   %esi
80101185:	53                   	push   %ebx
80101186:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101189:	8b 0d c0 19 11 80    	mov    0x801119c0,%ecx
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010118f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101192:	85 c9                	test   %ecx,%ecx
80101194:	0f 84 85 00 00 00    	je     8010121f <balloc+0x9f>
8010119a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011a1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011a4:	83 ec 08             	sub    $0x8,%esp
801011a7:	89 f0                	mov    %esi,%eax
801011a9:	c1 f8 0c             	sar    $0xc,%eax
801011ac:	03 05 d8 19 11 80    	add    0x801119d8,%eax
801011b2:	50                   	push   %eax
801011b3:	ff 75 d8             	pushl  -0x28(%ebp)
801011b6:	e8 15 ef ff ff       	call   801000d0 <bread>
801011bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801011be:	a1 c0 19 11 80       	mov    0x801119c0,%eax
801011c3:	83 c4 10             	add    $0x10,%esp
801011c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011c9:	31 c0                	xor    %eax,%eax
801011cb:	eb 2d                	jmp    801011fa <balloc+0x7a>
801011cd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801011d0:	89 c1                	mov    %eax,%ecx
801011d2:	ba 01 00 00 00       	mov    $0x1,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011d7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
801011da:	83 e1 07             	and    $0x7,%ecx
801011dd:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011df:	89 c1                	mov    %eax,%ecx
801011e1:	c1 f9 03             	sar    $0x3,%ecx
801011e4:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
801011e9:	85 d7                	test   %edx,%edi
801011eb:	74 43                	je     80101230 <balloc+0xb0>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011ed:	83 c0 01             	add    $0x1,%eax
801011f0:	83 c6 01             	add    $0x1,%esi
801011f3:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011f8:	74 05                	je     801011ff <balloc+0x7f>
801011fa:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801011fd:	72 d1                	jb     801011d0 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801011ff:	83 ec 0c             	sub    $0xc,%esp
80101202:	ff 75 e4             	pushl  -0x1c(%ebp)
80101205:	e8 d6 ef ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010120a:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101211:	83 c4 10             	add    $0x10,%esp
80101214:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101217:	39 05 c0 19 11 80    	cmp    %eax,0x801119c0
8010121d:	77 82                	ja     801011a1 <balloc+0x21>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010121f:	83 ec 0c             	sub    $0xc,%esp
80101222:	68 3f 7d 10 80       	push   $0x80107d3f
80101227:	e8 44 f1 ff ff       	call   80100370 <panic>
8010122c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101230:	09 fa                	or     %edi,%edx
80101232:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101235:	83 ec 0c             	sub    $0xc,%esp
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101238:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010123c:	57                   	push   %edi
8010123d:	e8 4e 1f 00 00       	call   80103190 <log_write>
        brelse(bp);
80101242:	89 3c 24             	mov    %edi,(%esp)
80101245:	e8 96 ef ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
8010124a:	58                   	pop    %eax
8010124b:	5a                   	pop    %edx
8010124c:	56                   	push   %esi
8010124d:	ff 75 d8             	pushl  -0x28(%ebp)
80101250:	e8 7b ee ff ff       	call   801000d0 <bread>
80101255:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101257:	8d 40 5c             	lea    0x5c(%eax),%eax
8010125a:	83 c4 0c             	add    $0xc,%esp
8010125d:	68 00 02 00 00       	push   $0x200
80101262:	6a 00                	push   $0x0
80101264:	50                   	push   %eax
80101265:	e8 76 39 00 00       	call   80104be0 <memset>
  log_write(bp);
8010126a:	89 1c 24             	mov    %ebx,(%esp)
8010126d:	e8 1e 1f 00 00       	call   80103190 <log_write>
  brelse(bp);
80101272:	89 1c 24             	mov    %ebx,(%esp)
80101275:	e8 66 ef ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
8010127a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010127d:	89 f0                	mov    %esi,%eax
8010127f:	5b                   	pop    %ebx
80101280:	5e                   	pop    %esi
80101281:	5f                   	pop    %edi
80101282:	5d                   	pop    %ebp
80101283:	c3                   	ret    
80101284:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010128a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101290 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101290:	55                   	push   %ebp
80101291:	89 e5                	mov    %esp,%ebp
80101293:	57                   	push   %edi
80101294:	56                   	push   %esi
80101295:	53                   	push   %ebx
80101296:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101298:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010129a:	bb 14 1a 11 80       	mov    $0x80111a14,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010129f:	83 ec 28             	sub    $0x28,%esp
801012a2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
801012a5:	68 e0 19 11 80       	push   $0x801119e0
801012aa:	e8 a1 37 00 00       	call   80104a50 <acquire>
801012af:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012b5:	eb 1b                	jmp    801012d2 <iget+0x42>
801012b7:	89 f6                	mov    %esi,%esi
801012b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012c0:	85 f6                	test   %esi,%esi
801012c2:	74 44                	je     80101308 <iget+0x78>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012c4:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012ca:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
801012d0:	74 4e                	je     80101320 <iget+0x90>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012d2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012d5:	85 c9                	test   %ecx,%ecx
801012d7:	7e e7                	jle    801012c0 <iget+0x30>
801012d9:	39 3b                	cmp    %edi,(%ebx)
801012db:	75 e3                	jne    801012c0 <iget+0x30>
801012dd:	39 53 04             	cmp    %edx,0x4(%ebx)
801012e0:	75 de                	jne    801012c0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
801012e2:	83 ec 0c             	sub    $0xc,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
801012e5:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
801012e8:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
801012ea:	68 e0 19 11 80       	push   $0x801119e0

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
801012ef:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012f2:	e8 99 38 00 00       	call   80104b90 <release>
      return ip;
801012f7:	83 c4 10             	add    $0x10,%esp
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
801012fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012fd:	89 f0                	mov    %esi,%eax
801012ff:	5b                   	pop    %ebx
80101300:	5e                   	pop    %esi
80101301:	5f                   	pop    %edi
80101302:	5d                   	pop    %ebp
80101303:	c3                   	ret    
80101304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101308:	85 c9                	test   %ecx,%ecx
8010130a:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010130d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101313:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
80101319:	75 b7                	jne    801012d2 <iget+0x42>
8010131b:	90                   	nop
8010131c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101320:	85 f6                	test   %esi,%esi
80101322:	74 2d                	je     80101351 <iget+0xc1>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101324:	83 ec 0c             	sub    $0xc,%esp
  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
80101327:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101329:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010132c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101333:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010133a:	68 e0 19 11 80       	push   $0x801119e0
8010133f:	e8 4c 38 00 00       	call   80104b90 <release>

  return ip;
80101344:	83 c4 10             	add    $0x10,%esp
}
80101347:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010134a:	89 f0                	mov    %esi,%eax
8010134c:	5b                   	pop    %ebx
8010134d:	5e                   	pop    %esi
8010134e:	5f                   	pop    %edi
8010134f:	5d                   	pop    %ebp
80101350:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
80101351:	83 ec 0c             	sub    $0xc,%esp
80101354:	68 55 7d 10 80       	push   $0x80107d55
80101359:	e8 12 f0 ff ff       	call   80100370 <panic>
8010135e:	66 90                	xchg   %ax,%ax

80101360 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	57                   	push   %edi
80101364:	56                   	push   %esi
80101365:	53                   	push   %ebx
80101366:	89 c6                	mov    %eax,%esi
80101368:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010136b:	83 fa 0b             	cmp    $0xb,%edx
8010136e:	77 18                	ja     80101388 <bmap+0x28>
80101370:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    if((addr = ip->addrs[bn]) == 0)
80101373:	8b 43 5c             	mov    0x5c(%ebx),%eax
80101376:	85 c0                	test   %eax,%eax
80101378:	74 76                	je     801013f0 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010137a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010137d:	5b                   	pop    %ebx
8010137e:	5e                   	pop    %esi
8010137f:	5f                   	pop    %edi
80101380:	5d                   	pop    %ebp
80101381:	c3                   	ret    
80101382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101388:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
8010138b:	83 fb 7f             	cmp    $0x7f,%ebx
8010138e:	0f 87 83 00 00 00    	ja     80101417 <bmap+0xb7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101394:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
8010139a:	85 c0                	test   %eax,%eax
8010139c:	74 6a                	je     80101408 <bmap+0xa8>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010139e:	83 ec 08             	sub    $0x8,%esp
801013a1:	50                   	push   %eax
801013a2:	ff 36                	pushl  (%esi)
801013a4:	e8 27 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801013a9:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801013ad:	83 c4 10             	add    $0x10,%esp

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801013b0:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801013b2:	8b 1a                	mov    (%edx),%ebx
801013b4:	85 db                	test   %ebx,%ebx
801013b6:	75 1d                	jne    801013d5 <bmap+0x75>
      a[bn] = addr = balloc(ip->dev);
801013b8:	8b 06                	mov    (%esi),%eax
801013ba:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013bd:	e8 be fd ff ff       	call   80101180 <balloc>
801013c2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801013c5:	83 ec 0c             	sub    $0xc,%esp
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
801013c8:	89 c3                	mov    %eax,%ebx
801013ca:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801013cc:	57                   	push   %edi
801013cd:	e8 be 1d 00 00       	call   80103190 <log_write>
801013d2:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
801013d5:	83 ec 0c             	sub    $0xc,%esp
801013d8:	57                   	push   %edi
801013d9:	e8 02 ee ff ff       	call   801001e0 <brelse>
801013de:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801013e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801013e4:	89 d8                	mov    %ebx,%eax
    return addr;
  }

  panic("bmap: out of range");
}
801013e6:	5b                   	pop    %ebx
801013e7:	5e                   	pop    %esi
801013e8:	5f                   	pop    %edi
801013e9:	5d                   	pop    %ebp
801013ea:	c3                   	ret    
801013eb:	90                   	nop
801013ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
801013f0:	8b 06                	mov    (%esi),%eax
801013f2:	e8 89 fd ff ff       	call   80101180 <balloc>
801013f7:	89 43 5c             	mov    %eax,0x5c(%ebx)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801013fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013fd:	5b                   	pop    %ebx
801013fe:	5e                   	pop    %esi
801013ff:	5f                   	pop    %edi
80101400:	5d                   	pop    %ebp
80101401:	c3                   	ret    
80101402:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101408:	8b 06                	mov    (%esi),%eax
8010140a:	e8 71 fd ff ff       	call   80101180 <balloc>
8010140f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101415:	eb 87                	jmp    8010139e <bmap+0x3e>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
80101417:	83 ec 0c             	sub    $0xc,%esp
8010141a:	68 65 7d 10 80       	push   $0x80107d65
8010141f:	e8 4c ef ff ff       	call   80100370 <panic>
80101424:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010142a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101430 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101430:	55                   	push   %ebp
80101431:	89 e5                	mov    %esp,%ebp
80101433:	56                   	push   %esi
80101434:	53                   	push   %ebx
80101435:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
80101438:	83 ec 08             	sub    $0x8,%esp
8010143b:	6a 01                	push   $0x1
8010143d:	ff 75 08             	pushl  0x8(%ebp)
80101440:	e8 8b ec ff ff       	call   801000d0 <bread>
80101445:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101447:	8d 40 5c             	lea    0x5c(%eax),%eax
8010144a:	83 c4 0c             	add    $0xc,%esp
8010144d:	6a 1c                	push   $0x1c
8010144f:	50                   	push   %eax
80101450:	56                   	push   %esi
80101451:	e8 3a 38 00 00       	call   80104c90 <memmove>
  brelse(bp);
80101456:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101459:	83 c4 10             	add    $0x10,%esp
}
8010145c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010145f:	5b                   	pop    %ebx
80101460:	5e                   	pop    %esi
80101461:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
80101462:	e9 79 ed ff ff       	jmp    801001e0 <brelse>
80101467:	89 f6                	mov    %esi,%esi
80101469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101470 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	56                   	push   %esi
80101474:	53                   	push   %ebx
80101475:	89 d3                	mov    %edx,%ebx
80101477:	89 c6                	mov    %eax,%esi
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
80101479:	83 ec 08             	sub    $0x8,%esp
8010147c:	68 c0 19 11 80       	push   $0x801119c0
80101481:	50                   	push   %eax
80101482:	e8 a9 ff ff ff       	call   80101430 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101487:	58                   	pop    %eax
80101488:	5a                   	pop    %edx
80101489:	89 da                	mov    %ebx,%edx
8010148b:	c1 ea 0c             	shr    $0xc,%edx
8010148e:	03 15 d8 19 11 80    	add    0x801119d8,%edx
80101494:	52                   	push   %edx
80101495:	56                   	push   %esi
80101496:	e8 35 ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010149b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010149d:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
801014a3:	ba 01 00 00 00       	mov    $0x1,%edx
801014a8:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801014ab:	c1 fb 03             	sar    $0x3,%ebx
801014ae:	83 c4 10             	add    $0x10,%esp
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
801014b1:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801014b3:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801014b8:	85 d1                	test   %edx,%ecx
801014ba:	74 27                	je     801014e3 <bfree+0x73>
801014bc:	89 c6                	mov    %eax,%esi
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801014be:	f7 d2                	not    %edx
801014c0:	89 c8                	mov    %ecx,%eax
  log_write(bp);
801014c2:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801014c5:	21 d0                	and    %edx,%eax
801014c7:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
801014cb:	56                   	push   %esi
801014cc:	e8 bf 1c 00 00       	call   80103190 <log_write>
  brelse(bp);
801014d1:	89 34 24             	mov    %esi,(%esp)
801014d4:	e8 07 ed ff ff       	call   801001e0 <brelse>
}
801014d9:	83 c4 10             	add    $0x10,%esp
801014dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014df:	5b                   	pop    %ebx
801014e0:	5e                   	pop    %esi
801014e1:	5d                   	pop    %ebp
801014e2:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
801014e3:	83 ec 0c             	sub    $0xc,%esp
801014e6:	68 78 7d 10 80       	push   $0x80107d78
801014eb:	e8 80 ee ff ff       	call   80100370 <panic>

801014f0 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
801014f0:	55                   	push   %ebp
801014f1:	89 e5                	mov    %esp,%ebp
801014f3:	53                   	push   %ebx
801014f4:	bb 20 1a 11 80       	mov    $0x80111a20,%ebx
801014f9:	83 ec 0c             	sub    $0xc,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
801014fc:	68 8b 7d 10 80       	push   $0x80107d8b
80101501:	68 e0 19 11 80       	push   $0x801119e0
80101506:	e8 45 34 00 00       	call   80104950 <initlock>
8010150b:	83 c4 10             	add    $0x10,%esp
8010150e:	66 90                	xchg   %ax,%ax
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101510:	83 ec 08             	sub    $0x8,%esp
80101513:	68 92 7d 10 80       	push   $0x80107d92
80101518:	53                   	push   %ebx
80101519:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010151f:	e8 1c 33 00 00       	call   80104840 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
80101524:	83 c4 10             	add    $0x10,%esp
80101527:	81 fb 40 36 11 80    	cmp    $0x80113640,%ebx
8010152d:	75 e1                	jne    80101510 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
8010152f:	83 ec 08             	sub    $0x8,%esp
80101532:	68 c0 19 11 80       	push   $0x801119c0
80101537:	ff 75 08             	pushl  0x8(%ebp)
8010153a:	e8 f1 fe ff ff       	call   80101430 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010153f:	ff 35 d8 19 11 80    	pushl  0x801119d8
80101545:	ff 35 d4 19 11 80    	pushl  0x801119d4
8010154b:	ff 35 d0 19 11 80    	pushl  0x801119d0
80101551:	ff 35 cc 19 11 80    	pushl  0x801119cc
80101557:	ff 35 c8 19 11 80    	pushl  0x801119c8
8010155d:	ff 35 c4 19 11 80    	pushl  0x801119c4
80101563:	ff 35 c0 19 11 80    	pushl  0x801119c0
80101569:	68 3c 7e 10 80       	push   $0x80107e3c
8010156e:	e8 ed f0 ff ff       	call   80100660 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
80101573:	83 c4 30             	add    $0x30,%esp
80101576:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101579:	c9                   	leave  
8010157a:	c3                   	ret    
8010157b:	90                   	nop
8010157c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101580 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101580:	55                   	push   %ebp
80101581:	89 e5                	mov    %esp,%ebp
80101583:	57                   	push   %edi
80101584:	56                   	push   %esi
80101585:	53                   	push   %ebx
80101586:	83 ec 1c             	sub    $0x1c,%esp
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101589:	83 3d c8 19 11 80 01 	cmpl   $0x1,0x801119c8
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101590:	8b 45 0c             	mov    0xc(%ebp),%eax
80101593:	8b 75 08             	mov    0x8(%ebp),%esi
80101596:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101599:	0f 86 91 00 00 00    	jbe    80101630 <ialloc+0xb0>
8010159f:	bb 01 00 00 00       	mov    $0x1,%ebx
801015a4:	eb 21                	jmp    801015c7 <ialloc+0x47>
801015a6:	8d 76 00             	lea    0x0(%esi),%esi
801015a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
801015b0:	83 ec 0c             	sub    $0xc,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801015b3:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
801015b6:	57                   	push   %edi
801015b7:	e8 24 ec ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801015bc:	83 c4 10             	add    $0x10,%esp
801015bf:	39 1d c8 19 11 80    	cmp    %ebx,0x801119c8
801015c5:	76 69                	jbe    80101630 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801015c7:	89 d8                	mov    %ebx,%eax
801015c9:	83 ec 08             	sub    $0x8,%esp
801015cc:	c1 e8 03             	shr    $0x3,%eax
801015cf:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801015d5:	50                   	push   %eax
801015d6:	56                   	push   %esi
801015d7:	e8 f4 ea ff ff       	call   801000d0 <bread>
801015dc:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
801015de:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
801015e0:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
801015e3:	83 e0 07             	and    $0x7,%eax
801015e6:	c1 e0 06             	shl    $0x6,%eax
801015e9:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801015ed:	66 83 39 00          	cmpw   $0x0,(%ecx)
801015f1:	75 bd                	jne    801015b0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801015f3:	83 ec 04             	sub    $0x4,%esp
801015f6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015f9:	6a 40                	push   $0x40
801015fb:	6a 00                	push   $0x0
801015fd:	51                   	push   %ecx
801015fe:	e8 dd 35 00 00       	call   80104be0 <memset>
      dip->type = type;
80101603:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101607:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010160a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010160d:	89 3c 24             	mov    %edi,(%esp)
80101610:	e8 7b 1b 00 00       	call   80103190 <log_write>
      brelse(bp);
80101615:	89 3c 24             	mov    %edi,(%esp)
80101618:	e8 c3 eb ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010161d:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101620:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
80101623:	89 da                	mov    %ebx,%edx
80101625:	89 f0                	mov    %esi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101627:	5b                   	pop    %ebx
80101628:	5e                   	pop    %esi
80101629:	5f                   	pop    %edi
8010162a:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
8010162b:	e9 60 fc ff ff       	jmp    80101290 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101630:	83 ec 0c             	sub    $0xc,%esp
80101633:	68 98 7d 10 80       	push   $0x80107d98
80101638:	e8 33 ed ff ff       	call   80100370 <panic>
8010163d:	8d 76 00             	lea    0x0(%esi),%esi

80101640 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
80101640:	55                   	push   %ebp
80101641:	89 e5                	mov    %esp,%ebp
80101643:	56                   	push   %esi
80101644:	53                   	push   %ebx
80101645:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101648:	83 ec 08             	sub    $0x8,%esp
8010164b:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010164e:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101651:	c1 e8 03             	shr    $0x3,%eax
80101654:	03 05 d4 19 11 80    	add    0x801119d4,%eax
8010165a:	50                   	push   %eax
8010165b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010165e:	e8 6d ea ff ff       	call   801000d0 <bread>
80101663:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101665:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101668:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010166c:	83 c4 0c             	add    $0xc,%esp
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010166f:	83 e0 07             	and    $0x7,%eax
80101672:	c1 e0 06             	shl    $0x6,%eax
80101675:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101679:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010167c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101680:	83 c0 0c             	add    $0xc,%eax
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
80101683:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101687:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010168b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010168f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101693:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101697:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010169a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010169d:	6a 34                	push   $0x34
8010169f:	53                   	push   %ebx
801016a0:	50                   	push   %eax
801016a1:	e8 ea 35 00 00       	call   80104c90 <memmove>
  log_write(bp);
801016a6:	89 34 24             	mov    %esi,(%esp)
801016a9:	e8 e2 1a 00 00       	call   80103190 <log_write>
  brelse(bp);
801016ae:	89 75 08             	mov    %esi,0x8(%ebp)
801016b1:	83 c4 10             	add    $0x10,%esp
}
801016b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016b7:	5b                   	pop    %ebx
801016b8:	5e                   	pop    %esi
801016b9:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
801016ba:	e9 21 eb ff ff       	jmp    801001e0 <brelse>
801016bf:	90                   	nop

801016c0 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801016c0:	55                   	push   %ebp
801016c1:	89 e5                	mov    %esp,%ebp
801016c3:	53                   	push   %ebx
801016c4:	83 ec 10             	sub    $0x10,%esp
801016c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801016ca:	68 e0 19 11 80       	push   $0x801119e0
801016cf:	e8 7c 33 00 00       	call   80104a50 <acquire>
  ip->ref++;
801016d4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801016d8:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801016df:	e8 ac 34 00 00       	call   80104b90 <release>
  return ip;
}
801016e4:	89 d8                	mov    %ebx,%eax
801016e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801016e9:	c9                   	leave  
801016ea:	c3                   	ret    
801016eb:	90                   	nop
801016ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801016f0 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801016f0:	55                   	push   %ebp
801016f1:	89 e5                	mov    %esp,%ebp
801016f3:	56                   	push   %esi
801016f4:	53                   	push   %ebx
801016f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801016f8:	85 db                	test   %ebx,%ebx
801016fa:	0f 84 b7 00 00 00    	je     801017b7 <ilock+0xc7>
80101700:	8b 53 08             	mov    0x8(%ebx),%edx
80101703:	85 d2                	test   %edx,%edx
80101705:	0f 8e ac 00 00 00    	jle    801017b7 <ilock+0xc7>
    panic("ilock");

  acquiresleep(&ip->lock);
8010170b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010170e:	83 ec 0c             	sub    $0xc,%esp
80101711:	50                   	push   %eax
80101712:	e8 69 31 00 00       	call   80104880 <acquiresleep>

  if(ip->valid == 0){
80101717:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010171a:	83 c4 10             	add    $0x10,%esp
8010171d:	85 c0                	test   %eax,%eax
8010171f:	74 0f                	je     80101730 <ilock+0x40>
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
80101721:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101724:	5b                   	pop    %ebx
80101725:	5e                   	pop    %esi
80101726:	5d                   	pop    %ebp
80101727:	c3                   	ret    
80101728:	90                   	nop
80101729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101730:	8b 43 04             	mov    0x4(%ebx),%eax
80101733:	83 ec 08             	sub    $0x8,%esp
80101736:	c1 e8 03             	shr    $0x3,%eax
80101739:	03 05 d4 19 11 80    	add    0x801119d4,%eax
8010173f:	50                   	push   %eax
80101740:	ff 33                	pushl  (%ebx)
80101742:	e8 89 e9 ff ff       	call   801000d0 <bread>
80101747:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101749:	8b 43 04             	mov    0x4(%ebx),%eax
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010174c:	83 c4 0c             	add    $0xc,%esp

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010174f:	83 e0 07             	and    $0x7,%eax
80101752:	c1 e0 06             	shl    $0x6,%eax
80101755:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101759:	0f b7 10             	movzwl (%eax),%edx
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010175c:	83 c0 0c             	add    $0xc,%eax
  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
8010175f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101763:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101767:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010176b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010176f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101773:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101777:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010177b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010177e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101781:	6a 34                	push   $0x34
80101783:	50                   	push   %eax
80101784:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101787:	50                   	push   %eax
80101788:	e8 03 35 00 00       	call   80104c90 <memmove>
    brelse(bp);
8010178d:	89 34 24             	mov    %esi,(%esp)
80101790:	e8 4b ea ff ff       	call   801001e0 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
80101795:	83 c4 10             	add    $0x10,%esp
80101798:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
8010179d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801017a4:	0f 85 77 ff ff ff    	jne    80101721 <ilock+0x31>
      panic("ilock: no type");
801017aa:	83 ec 0c             	sub    $0xc,%esp
801017ad:	68 b0 7d 10 80       	push   $0x80107db0
801017b2:	e8 b9 eb ff ff       	call   80100370 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
801017b7:	83 ec 0c             	sub    $0xc,%esp
801017ba:	68 aa 7d 10 80       	push   $0x80107daa
801017bf:	e8 ac eb ff ff       	call   80100370 <panic>
801017c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801017ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801017d0 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
801017d0:	55                   	push   %ebp
801017d1:	89 e5                	mov    %esp,%ebp
801017d3:	56                   	push   %esi
801017d4:	53                   	push   %ebx
801017d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801017d8:	85 db                	test   %ebx,%ebx
801017da:	74 28                	je     80101804 <iunlock+0x34>
801017dc:	8d 73 0c             	lea    0xc(%ebx),%esi
801017df:	83 ec 0c             	sub    $0xc,%esp
801017e2:	56                   	push   %esi
801017e3:	e8 38 31 00 00       	call   80104920 <holdingsleep>
801017e8:	83 c4 10             	add    $0x10,%esp
801017eb:	85 c0                	test   %eax,%eax
801017ed:	74 15                	je     80101804 <iunlock+0x34>
801017ef:	8b 43 08             	mov    0x8(%ebx),%eax
801017f2:	85 c0                	test   %eax,%eax
801017f4:	7e 0e                	jle    80101804 <iunlock+0x34>
    panic("iunlock");

  releasesleep(&ip->lock);
801017f6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017fc:	5b                   	pop    %ebx
801017fd:	5e                   	pop    %esi
801017fe:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
801017ff:	e9 dc 30 00 00       	jmp    801048e0 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
80101804:	83 ec 0c             	sub    $0xc,%esp
80101807:	68 bf 7d 10 80       	push   $0x80107dbf
8010180c:	e8 5f eb ff ff       	call   80100370 <panic>
80101811:	eb 0d                	jmp    80101820 <iput>
80101813:	90                   	nop
80101814:	90                   	nop
80101815:	90                   	nop
80101816:	90                   	nop
80101817:	90                   	nop
80101818:	90                   	nop
80101819:	90                   	nop
8010181a:	90                   	nop
8010181b:	90                   	nop
8010181c:	90                   	nop
8010181d:	90                   	nop
8010181e:	90                   	nop
8010181f:	90                   	nop

80101820 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101820:	55                   	push   %ebp
80101821:	89 e5                	mov    %esp,%ebp
80101823:	57                   	push   %edi
80101824:	56                   	push   %esi
80101825:	53                   	push   %ebx
80101826:	83 ec 28             	sub    $0x28,%esp
80101829:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
8010182c:	8d 7e 0c             	lea    0xc(%esi),%edi
8010182f:	57                   	push   %edi
80101830:	e8 4b 30 00 00       	call   80104880 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101835:	8b 56 4c             	mov    0x4c(%esi),%edx
80101838:	83 c4 10             	add    $0x10,%esp
8010183b:	85 d2                	test   %edx,%edx
8010183d:	74 07                	je     80101846 <iput+0x26>
8010183f:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
80101844:	74 32                	je     80101878 <iput+0x58>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
80101846:	83 ec 0c             	sub    $0xc,%esp
80101849:	57                   	push   %edi
8010184a:	e8 91 30 00 00       	call   801048e0 <releasesleep>

  acquire(&icache.lock);
8010184f:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101856:	e8 f5 31 00 00       	call   80104a50 <acquire>
  ip->ref--;
8010185b:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
8010185f:	83 c4 10             	add    $0x10,%esp
80101862:	c7 45 08 e0 19 11 80 	movl   $0x801119e0,0x8(%ebp)
}
80101869:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010186c:	5b                   	pop    %ebx
8010186d:	5e                   	pop    %esi
8010186e:	5f                   	pop    %edi
8010186f:	5d                   	pop    %ebp
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
80101870:	e9 1b 33 00 00       	jmp    80104b90 <release>
80101875:	8d 76 00             	lea    0x0(%esi),%esi
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
80101878:	83 ec 0c             	sub    $0xc,%esp
8010187b:	68 e0 19 11 80       	push   $0x801119e0
80101880:	e8 cb 31 00 00       	call   80104a50 <acquire>
    int r = ip->ref;
80101885:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
80101888:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
8010188f:	e8 fc 32 00 00       	call   80104b90 <release>
    if(r == 1){
80101894:	83 c4 10             	add    $0x10,%esp
80101897:	83 fb 01             	cmp    $0x1,%ebx
8010189a:	75 aa                	jne    80101846 <iput+0x26>
8010189c:	8d 8e 8c 00 00 00    	lea    0x8c(%esi),%ecx
801018a2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801018a5:	8d 5e 5c             	lea    0x5c(%esi),%ebx
801018a8:	89 cf                	mov    %ecx,%edi
801018aa:	eb 0b                	jmp    801018b7 <iput+0x97>
801018ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018b0:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801018b3:	39 fb                	cmp    %edi,%ebx
801018b5:	74 19                	je     801018d0 <iput+0xb0>
    if(ip->addrs[i]){
801018b7:	8b 13                	mov    (%ebx),%edx
801018b9:	85 d2                	test   %edx,%edx
801018bb:	74 f3                	je     801018b0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
801018bd:	8b 06                	mov    (%esi),%eax
801018bf:	e8 ac fb ff ff       	call   80101470 <bfree>
      ip->addrs[i] = 0;
801018c4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801018ca:	eb e4                	jmp    801018b0 <iput+0x90>
801018cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801018d0:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
801018d6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801018d9:	85 c0                	test   %eax,%eax
801018db:	75 33                	jne    80101910 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801018dd:	83 ec 0c             	sub    $0xc,%esp
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
801018e0:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
801018e7:	56                   	push   %esi
801018e8:	e8 53 fd ff ff       	call   80101640 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
801018ed:	31 c0                	xor    %eax,%eax
801018ef:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
801018f3:	89 34 24             	mov    %esi,(%esp)
801018f6:	e8 45 fd ff ff       	call   80101640 <iupdate>
      ip->valid = 0;
801018fb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101902:	83 c4 10             	add    $0x10,%esp
80101905:	e9 3c ff ff ff       	jmp    80101846 <iput+0x26>
8010190a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101910:	83 ec 08             	sub    $0x8,%esp
80101913:	50                   	push   %eax
80101914:	ff 36                	pushl  (%esi)
80101916:	e8 b5 e7 ff ff       	call   801000d0 <bread>
8010191b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101921:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101924:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101927:	8d 58 5c             	lea    0x5c(%eax),%ebx
8010192a:	83 c4 10             	add    $0x10,%esp
8010192d:	89 cf                	mov    %ecx,%edi
8010192f:	eb 0e                	jmp    8010193f <iput+0x11f>
80101931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101938:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
8010193b:	39 fb                	cmp    %edi,%ebx
8010193d:	74 0f                	je     8010194e <iput+0x12e>
      if(a[j])
8010193f:	8b 13                	mov    (%ebx),%edx
80101941:	85 d2                	test   %edx,%edx
80101943:	74 f3                	je     80101938 <iput+0x118>
        bfree(ip->dev, a[j]);
80101945:	8b 06                	mov    (%esi),%eax
80101947:	e8 24 fb ff ff       	call   80101470 <bfree>
8010194c:	eb ea                	jmp    80101938 <iput+0x118>
    }
    brelse(bp);
8010194e:	83 ec 0c             	sub    $0xc,%esp
80101951:	ff 75 e4             	pushl  -0x1c(%ebp)
80101954:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101957:	e8 84 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010195c:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101962:	8b 06                	mov    (%esi),%eax
80101964:	e8 07 fb ff ff       	call   80101470 <bfree>
    ip->addrs[NDIRECT] = 0;
80101969:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101970:	00 00 00 
80101973:	83 c4 10             	add    $0x10,%esp
80101976:	e9 62 ff ff ff       	jmp    801018dd <iput+0xbd>
8010197b:	90                   	nop
8010197c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101980 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101980:	55                   	push   %ebp
80101981:	89 e5                	mov    %esp,%ebp
80101983:	53                   	push   %ebx
80101984:	83 ec 10             	sub    $0x10,%esp
80101987:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010198a:	53                   	push   %ebx
8010198b:	e8 40 fe ff ff       	call   801017d0 <iunlock>
  iput(ip);
80101990:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101993:	83 c4 10             	add    $0x10,%esp
}
80101996:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101999:	c9                   	leave  
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
8010199a:	e9 81 fe ff ff       	jmp    80101820 <iput>
8010199f:	90                   	nop

801019a0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
801019a0:	55                   	push   %ebp
801019a1:	89 e5                	mov    %esp,%ebp
801019a3:	8b 55 08             	mov    0x8(%ebp),%edx
801019a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801019a9:	8b 0a                	mov    (%edx),%ecx
801019ab:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801019ae:	8b 4a 04             	mov    0x4(%edx),%ecx
801019b1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801019b4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
801019b8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801019bb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
801019bf:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801019c3:	8b 52 58             	mov    0x58(%edx),%edx
801019c6:	89 50 10             	mov    %edx,0x10(%eax)
}
801019c9:	5d                   	pop    %ebp
801019ca:	c3                   	ret    
801019cb:	90                   	nop
801019cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801019d0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801019d0:	55                   	push   %ebp
801019d1:	89 e5                	mov    %esp,%ebp
801019d3:	57                   	push   %edi
801019d4:	56                   	push   %esi
801019d5:	53                   	push   %ebx
801019d6:	83 ec 1c             	sub    $0x1c,%esp
801019d9:	8b 45 08             	mov    0x8(%ebp),%eax
801019dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
801019df:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801019e2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801019e7:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019ea:	8b 7d 14             	mov    0x14(%ebp),%edi
801019ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
801019f0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801019f3:	0f 84 a7 00 00 00    	je     80101aa0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
801019f9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801019fc:	8b 40 58             	mov    0x58(%eax),%eax
801019ff:	39 f0                	cmp    %esi,%eax
80101a01:	0f 82 c1 00 00 00    	jb     80101ac8 <readi+0xf8>
80101a07:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a0a:	89 fa                	mov    %edi,%edx
80101a0c:	01 f2                	add    %esi,%edx
80101a0e:	0f 82 b4 00 00 00    	jb     80101ac8 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101a14:	89 c1                	mov    %eax,%ecx
80101a16:	29 f1                	sub    %esi,%ecx
80101a18:	39 d0                	cmp    %edx,%eax
80101a1a:	0f 43 cf             	cmovae %edi,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a1d:	31 ff                	xor    %edi,%edi
80101a1f:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101a21:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a24:	74 6d                	je     80101a93 <readi+0xc3>
80101a26:	8d 76 00             	lea    0x0(%esi),%esi
80101a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a30:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101a33:	89 f2                	mov    %esi,%edx
80101a35:	c1 ea 09             	shr    $0x9,%edx
80101a38:	89 d8                	mov    %ebx,%eax
80101a3a:	e8 21 f9 ff ff       	call   80101360 <bmap>
80101a3f:	83 ec 08             	sub    $0x8,%esp
80101a42:	50                   	push   %eax
80101a43:	ff 33                	pushl  (%ebx)
    m = min(n - tot, BSIZE - off%BSIZE);
80101a45:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a4a:	e8 81 e6 ff ff       	call   801000d0 <bread>
80101a4f:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101a54:	89 f1                	mov    %esi,%ecx
80101a56:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101a5c:	83 c4 0c             	add    $0xc,%esp
    memmove(dst, bp->data + off%BSIZE, m);
80101a5f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101a62:	29 cb                	sub    %ecx,%ebx
80101a64:	29 f8                	sub    %edi,%eax
80101a66:	39 c3                	cmp    %eax,%ebx
80101a68:	0f 47 d8             	cmova  %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a6b:	8d 44 0a 5c          	lea    0x5c(%edx,%ecx,1),%eax
80101a6f:	53                   	push   %ebx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a70:	01 df                	add    %ebx,%edi
80101a72:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
80101a74:	50                   	push   %eax
80101a75:	ff 75 e0             	pushl  -0x20(%ebp)
80101a78:	e8 13 32 00 00       	call   80104c90 <memmove>
    brelse(bp);
80101a7d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a80:	89 14 24             	mov    %edx,(%esp)
80101a83:	e8 58 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a88:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a8b:	83 c4 10             	add    $0x10,%esp
80101a8e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a91:	77 9d                	ja     80101a30 <readi+0x60>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101a93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a96:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a99:	5b                   	pop    %ebx
80101a9a:	5e                   	pop    %esi
80101a9b:	5f                   	pop    %edi
80101a9c:	5d                   	pop    %ebp
80101a9d:	c3                   	ret    
80101a9e:	66 90                	xchg   %ax,%ax
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101aa0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101aa4:	66 83 f8 09          	cmp    $0x9,%ax
80101aa8:	77 1e                	ja     80101ac8 <readi+0xf8>
80101aaa:	8b 04 c5 60 19 11 80 	mov    -0x7feee6a0(,%eax,8),%eax
80101ab1:	85 c0                	test   %eax,%eax
80101ab3:	74 13                	je     80101ac8 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101ab5:	89 7d 10             	mov    %edi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101ab8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101abb:	5b                   	pop    %ebx
80101abc:	5e                   	pop    %esi
80101abd:	5f                   	pop    %edi
80101abe:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101abf:	ff e0                	jmp    *%eax
80101ac1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101ac8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101acd:	eb c7                	jmp    80101a96 <readi+0xc6>
80101acf:	90                   	nop

80101ad0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ad0:	55                   	push   %ebp
80101ad1:	89 e5                	mov    %esp,%ebp
80101ad3:	57                   	push   %edi
80101ad4:	56                   	push   %esi
80101ad5:	53                   	push   %ebx
80101ad6:	83 ec 1c             	sub    $0x1c,%esp
80101ad9:	8b 45 08             	mov    0x8(%ebp),%eax
80101adc:	8b 75 0c             	mov    0xc(%ebp),%esi
80101adf:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ae2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ae7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101aea:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101aed:	8b 75 10             	mov    0x10(%ebp),%esi
80101af0:	89 7d e0             	mov    %edi,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101af3:	0f 84 b7 00 00 00    	je     80101bb0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101af9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101afc:	39 70 58             	cmp    %esi,0x58(%eax)
80101aff:	0f 82 eb 00 00 00    	jb     80101bf0 <writei+0x120>
80101b05:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b08:	89 f8                	mov    %edi,%eax
80101b0a:	01 f0                	add    %esi,%eax
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b0c:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101b11:	0f 87 d9 00 00 00    	ja     80101bf0 <writei+0x120>
80101b17:	39 c6                	cmp    %eax,%esi
80101b19:	0f 87 d1 00 00 00    	ja     80101bf0 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b1f:	85 ff                	test   %edi,%edi
80101b21:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101b28:	74 78                	je     80101ba2 <writei+0xd2>
80101b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b30:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101b33:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b35:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b3a:	c1 ea 09             	shr    $0x9,%edx
80101b3d:	89 f8                	mov    %edi,%eax
80101b3f:	e8 1c f8 ff ff       	call   80101360 <bmap>
80101b44:	83 ec 08             	sub    $0x8,%esp
80101b47:	50                   	push   %eax
80101b48:	ff 37                	pushl  (%edi)
80101b4a:	e8 81 e5 ff ff       	call   801000d0 <bread>
80101b4f:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b51:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101b54:	2b 45 e4             	sub    -0x1c(%ebp),%eax
80101b57:	89 f1                	mov    %esi,%ecx
80101b59:	83 c4 0c             	add    $0xc,%esp
80101b5c:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101b62:	29 cb                	sub    %ecx,%ebx
80101b64:	39 c3                	cmp    %eax,%ebx
80101b66:	0f 47 d8             	cmova  %eax,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b69:	8d 44 0f 5c          	lea    0x5c(%edi,%ecx,1),%eax
80101b6d:	53                   	push   %ebx
80101b6e:	ff 75 dc             	pushl  -0x24(%ebp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b71:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101b73:	50                   	push   %eax
80101b74:	e8 17 31 00 00       	call   80104c90 <memmove>
    log_write(bp);
80101b79:	89 3c 24             	mov    %edi,(%esp)
80101b7c:	e8 0f 16 00 00       	call   80103190 <log_write>
    brelse(bp);
80101b81:	89 3c 24             	mov    %edi,(%esp)
80101b84:	e8 57 e6 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b89:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b8c:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b8f:	83 c4 10             	add    $0x10,%esp
80101b92:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101b95:	39 55 e0             	cmp    %edx,-0x20(%ebp)
80101b98:	77 96                	ja     80101b30 <writei+0x60>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101b9a:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b9d:	3b 70 58             	cmp    0x58(%eax),%esi
80101ba0:	77 36                	ja     80101bd8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101ba2:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101ba5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ba8:	5b                   	pop    %ebx
80101ba9:	5e                   	pop    %esi
80101baa:	5f                   	pop    %edi
80101bab:	5d                   	pop    %ebp
80101bac:	c3                   	ret    
80101bad:	8d 76 00             	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101bb0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101bb4:	66 83 f8 09          	cmp    $0x9,%ax
80101bb8:	77 36                	ja     80101bf0 <writei+0x120>
80101bba:	8b 04 c5 64 19 11 80 	mov    -0x7feee69c(,%eax,8),%eax
80101bc1:	85 c0                	test   %eax,%eax
80101bc3:	74 2b                	je     80101bf0 <writei+0x120>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101bc5:	89 7d 10             	mov    %edi,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101bc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bcb:	5b                   	pop    %ebx
80101bcc:	5e                   	pop    %esi
80101bcd:	5f                   	pop    %edi
80101bce:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101bcf:	ff e0                	jmp    *%eax
80101bd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101bd8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101bdb:	83 ec 0c             	sub    $0xc,%esp
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101bde:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101be1:	50                   	push   %eax
80101be2:	e8 59 fa ff ff       	call   80101640 <iupdate>
80101be7:	83 c4 10             	add    $0x10,%esp
80101bea:	eb b6                	jmp    80101ba2 <writei+0xd2>
80101bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101bf0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101bf5:	eb ae                	jmp    80101ba5 <writei+0xd5>
80101bf7:	89 f6                	mov    %esi,%esi
80101bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c00 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c00:	55                   	push   %ebp
80101c01:	89 e5                	mov    %esp,%ebp
80101c03:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c06:	6a 0e                	push   $0xe
80101c08:	ff 75 0c             	pushl  0xc(%ebp)
80101c0b:	ff 75 08             	pushl  0x8(%ebp)
80101c0e:	e8 fd 30 00 00       	call   80104d10 <strncmp>
}
80101c13:	c9                   	leave  
80101c14:	c3                   	ret    
80101c15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c20 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101c20:	55                   	push   %ebp
80101c21:	89 e5                	mov    %esp,%ebp
80101c23:	57                   	push   %edi
80101c24:	56                   	push   %esi
80101c25:	53                   	push   %ebx
80101c26:	83 ec 1c             	sub    $0x1c,%esp
80101c29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101c2c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101c31:	0f 85 80 00 00 00    	jne    80101cb7 <dirlookup+0x97>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101c37:	8b 53 58             	mov    0x58(%ebx),%edx
80101c3a:	31 ff                	xor    %edi,%edi
80101c3c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c3f:	85 d2                	test   %edx,%edx
80101c41:	75 0d                	jne    80101c50 <dirlookup+0x30>
80101c43:	eb 5b                	jmp    80101ca0 <dirlookup+0x80>
80101c45:	8d 76 00             	lea    0x0(%esi),%esi
80101c48:	83 c7 10             	add    $0x10,%edi
80101c4b:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101c4e:	76 50                	jbe    80101ca0 <dirlookup+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c50:	6a 10                	push   $0x10
80101c52:	57                   	push   %edi
80101c53:	56                   	push   %esi
80101c54:	53                   	push   %ebx
80101c55:	e8 76 fd ff ff       	call   801019d0 <readi>
80101c5a:	83 c4 10             	add    $0x10,%esp
80101c5d:	83 f8 10             	cmp    $0x10,%eax
80101c60:	75 48                	jne    80101caa <dirlookup+0x8a>
      panic("dirlookup read");
    if(de.inum == 0)
80101c62:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c67:	74 df                	je     80101c48 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101c69:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c6c:	83 ec 04             	sub    $0x4,%esp
80101c6f:	6a 0e                	push   $0xe
80101c71:	50                   	push   %eax
80101c72:	ff 75 0c             	pushl  0xc(%ebp)
80101c75:	e8 96 30 00 00       	call   80104d10 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101c7a:	83 c4 10             	add    $0x10,%esp
80101c7d:	85 c0                	test   %eax,%eax
80101c7f:	75 c7                	jne    80101c48 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c81:	8b 45 10             	mov    0x10(%ebp),%eax
80101c84:	85 c0                	test   %eax,%eax
80101c86:	74 05                	je     80101c8d <dirlookup+0x6d>
        *poff = off;
80101c88:	8b 45 10             	mov    0x10(%ebp),%eax
80101c8b:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
      return iget(dp->dev, inum);
80101c8d:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101c91:	8b 03                	mov    (%ebx),%eax
80101c93:	e8 f8 f5 ff ff       	call   80101290 <iget>
    }
  }

  return 0;
}
80101c98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c9b:	5b                   	pop    %ebx
80101c9c:	5e                   	pop    %esi
80101c9d:	5f                   	pop    %edi
80101c9e:	5d                   	pop    %ebp
80101c9f:	c3                   	ret    
80101ca0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101ca3:	31 c0                	xor    %eax,%eax
}
80101ca5:	5b                   	pop    %ebx
80101ca6:	5e                   	pop    %esi
80101ca7:	5f                   	pop    %edi
80101ca8:	5d                   	pop    %ebp
80101ca9:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
80101caa:	83 ec 0c             	sub    $0xc,%esp
80101cad:	68 d9 7d 10 80       	push   $0x80107dd9
80101cb2:	e8 b9 e6 ff ff       	call   80100370 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101cb7:	83 ec 0c             	sub    $0xc,%esp
80101cba:	68 c7 7d 10 80       	push   $0x80107dc7
80101cbf:	e8 ac e6 ff ff       	call   80100370 <panic>
80101cc4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101cca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101cd0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101cd0:	55                   	push   %ebp
80101cd1:	89 e5                	mov    %esp,%ebp
80101cd3:	57                   	push   %edi
80101cd4:	56                   	push   %esi
80101cd5:	53                   	push   %ebx
80101cd6:	89 cf                	mov    %ecx,%edi
80101cd8:	89 c3                	mov    %eax,%ebx
80101cda:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101cdd:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101ce0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101ce3:	0f 84 53 01 00 00    	je     80101e3c <namex+0x16c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101ce9:	e8 72 1f 00 00       	call   80103c60 <myproc>
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101cee:	83 ec 0c             	sub    $0xc,%esp
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101cf1:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101cf4:	68 e0 19 11 80       	push   $0x801119e0
80101cf9:	e8 52 2d 00 00       	call   80104a50 <acquire>
  ip->ref++;
80101cfe:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101d02:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101d09:	e8 82 2e 00 00       	call   80104b90 <release>
80101d0e:	83 c4 10             	add    $0x10,%esp
80101d11:	eb 08                	jmp    80101d1b <namex+0x4b>
80101d13:	90                   	nop
80101d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101d18:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101d1b:	0f b6 03             	movzbl (%ebx),%eax
80101d1e:	3c 2f                	cmp    $0x2f,%al
80101d20:	74 f6                	je     80101d18 <namex+0x48>
    path++;
  if(*path == 0)
80101d22:	84 c0                	test   %al,%al
80101d24:	0f 84 e3 00 00 00    	je     80101e0d <namex+0x13d>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d2a:	0f b6 03             	movzbl (%ebx),%eax
80101d2d:	89 da                	mov    %ebx,%edx
80101d2f:	84 c0                	test   %al,%al
80101d31:	0f 84 ac 00 00 00    	je     80101de3 <namex+0x113>
80101d37:	3c 2f                	cmp    $0x2f,%al
80101d39:	75 09                	jne    80101d44 <namex+0x74>
80101d3b:	e9 a3 00 00 00       	jmp    80101de3 <namex+0x113>
80101d40:	84 c0                	test   %al,%al
80101d42:	74 0a                	je     80101d4e <namex+0x7e>
    path++;
80101d44:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d47:	0f b6 02             	movzbl (%edx),%eax
80101d4a:	3c 2f                	cmp    $0x2f,%al
80101d4c:	75 f2                	jne    80101d40 <namex+0x70>
80101d4e:	89 d1                	mov    %edx,%ecx
80101d50:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101d52:	83 f9 0d             	cmp    $0xd,%ecx
80101d55:	0f 8e 8d 00 00 00    	jle    80101de8 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101d5b:	83 ec 04             	sub    $0x4,%esp
80101d5e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d61:	6a 0e                	push   $0xe
80101d63:	53                   	push   %ebx
80101d64:	57                   	push   %edi
80101d65:	e8 26 2f 00 00       	call   80104c90 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101d6a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
80101d6d:	83 c4 10             	add    $0x10,%esp
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101d70:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d72:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d75:	75 11                	jne    80101d88 <namex+0xb8>
80101d77:	89 f6                	mov    %esi,%esi
80101d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d80:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d83:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d86:	74 f8                	je     80101d80 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d88:	83 ec 0c             	sub    $0xc,%esp
80101d8b:	56                   	push   %esi
80101d8c:	e8 5f f9 ff ff       	call   801016f0 <ilock>
    if(ip->type != T_DIR){
80101d91:	83 c4 10             	add    $0x10,%esp
80101d94:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d99:	0f 85 7f 00 00 00    	jne    80101e1e <namex+0x14e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d9f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101da2:	85 d2                	test   %edx,%edx
80101da4:	74 09                	je     80101daf <namex+0xdf>
80101da6:	80 3b 00             	cmpb   $0x0,(%ebx)
80101da9:	0f 84 a3 00 00 00    	je     80101e52 <namex+0x182>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101daf:	83 ec 04             	sub    $0x4,%esp
80101db2:	6a 00                	push   $0x0
80101db4:	57                   	push   %edi
80101db5:	56                   	push   %esi
80101db6:	e8 65 fe ff ff       	call   80101c20 <dirlookup>
80101dbb:	83 c4 10             	add    $0x10,%esp
80101dbe:	85 c0                	test   %eax,%eax
80101dc0:	74 5c                	je     80101e1e <namex+0x14e>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101dc2:	83 ec 0c             	sub    $0xc,%esp
80101dc5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101dc8:	56                   	push   %esi
80101dc9:	e8 02 fa ff ff       	call   801017d0 <iunlock>
  iput(ip);
80101dce:	89 34 24             	mov    %esi,(%esp)
80101dd1:	e8 4a fa ff ff       	call   80101820 <iput>
80101dd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101dd9:	83 c4 10             	add    $0x10,%esp
80101ddc:	89 c6                	mov    %eax,%esi
80101dde:	e9 38 ff ff ff       	jmp    80101d1b <namex+0x4b>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101de3:	31 c9                	xor    %ecx,%ecx
80101de5:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101de8:	83 ec 04             	sub    $0x4,%esp
80101deb:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101dee:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101df1:	51                   	push   %ecx
80101df2:	53                   	push   %ebx
80101df3:	57                   	push   %edi
80101df4:	e8 97 2e 00 00       	call   80104c90 <memmove>
    name[len] = 0;
80101df9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101dfc:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101dff:	83 c4 10             	add    $0x10,%esp
80101e02:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101e06:	89 d3                	mov    %edx,%ebx
80101e08:	e9 65 ff ff ff       	jmp    80101d72 <namex+0xa2>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101e0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101e10:	85 c0                	test   %eax,%eax
80101e12:	75 54                	jne    80101e68 <namex+0x198>
80101e14:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101e16:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e19:	5b                   	pop    %ebx
80101e1a:	5e                   	pop    %esi
80101e1b:	5f                   	pop    %edi
80101e1c:	5d                   	pop    %ebp
80101e1d:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101e1e:	83 ec 0c             	sub    $0xc,%esp
80101e21:	56                   	push   %esi
80101e22:	e8 a9 f9 ff ff       	call   801017d0 <iunlock>
  iput(ip);
80101e27:	89 34 24             	mov    %esi,(%esp)
80101e2a:	e8 f1 f9 ff ff       	call   80101820 <iput>
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101e2f:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e32:	8d 65 f4             	lea    -0xc(%ebp),%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101e35:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e37:	5b                   	pop    %ebx
80101e38:	5e                   	pop    %esi
80101e39:	5f                   	pop    %edi
80101e3a:	5d                   	pop    %ebp
80101e3b:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101e3c:	ba 01 00 00 00       	mov    $0x1,%edx
80101e41:	b8 01 00 00 00       	mov    $0x1,%eax
80101e46:	e8 45 f4 ff ff       	call   80101290 <iget>
80101e4b:	89 c6                	mov    %eax,%esi
80101e4d:	e9 c9 fe ff ff       	jmp    80101d1b <namex+0x4b>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101e52:	83 ec 0c             	sub    $0xc,%esp
80101e55:	56                   	push   %esi
80101e56:	e8 75 f9 ff ff       	call   801017d0 <iunlock>
      return ip;
80101e5b:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101e61:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e63:	5b                   	pop    %ebx
80101e64:	5e                   	pop    %esi
80101e65:	5f                   	pop    %edi
80101e66:	5d                   	pop    %ebp
80101e67:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101e68:	83 ec 0c             	sub    $0xc,%esp
80101e6b:	56                   	push   %esi
80101e6c:	e8 af f9 ff ff       	call   80101820 <iput>
    return 0;
80101e71:	83 c4 10             	add    $0x10,%esp
80101e74:	31 c0                	xor    %eax,%eax
80101e76:	eb 9e                	jmp    80101e16 <namex+0x146>
80101e78:	90                   	nop
80101e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101e80 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101e80:	55                   	push   %ebp
80101e81:	89 e5                	mov    %esp,%ebp
80101e83:	57                   	push   %edi
80101e84:	56                   	push   %esi
80101e85:	53                   	push   %ebx
80101e86:	83 ec 20             	sub    $0x20,%esp
80101e89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e8c:	6a 00                	push   $0x0
80101e8e:	ff 75 0c             	pushl  0xc(%ebp)
80101e91:	53                   	push   %ebx
80101e92:	e8 89 fd ff ff       	call   80101c20 <dirlookup>
80101e97:	83 c4 10             	add    $0x10,%esp
80101e9a:	85 c0                	test   %eax,%eax
80101e9c:	75 67                	jne    80101f05 <dirlink+0x85>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e9e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101ea1:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101ea4:	85 ff                	test   %edi,%edi
80101ea6:	74 29                	je     80101ed1 <dirlink+0x51>
80101ea8:	31 ff                	xor    %edi,%edi
80101eaa:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101ead:	eb 09                	jmp    80101eb8 <dirlink+0x38>
80101eaf:	90                   	nop
80101eb0:	83 c7 10             	add    $0x10,%edi
80101eb3:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101eb6:	76 19                	jbe    80101ed1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101eb8:	6a 10                	push   $0x10
80101eba:	57                   	push   %edi
80101ebb:	56                   	push   %esi
80101ebc:	53                   	push   %ebx
80101ebd:	e8 0e fb ff ff       	call   801019d0 <readi>
80101ec2:	83 c4 10             	add    $0x10,%esp
80101ec5:	83 f8 10             	cmp    $0x10,%eax
80101ec8:	75 4e                	jne    80101f18 <dirlink+0x98>
      panic("dirlink read");
    if(de.inum == 0)
80101eca:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101ecf:	75 df                	jne    80101eb0 <dirlink+0x30>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101ed1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101ed4:	83 ec 04             	sub    $0x4,%esp
80101ed7:	6a 0e                	push   $0xe
80101ed9:	ff 75 0c             	pushl  0xc(%ebp)
80101edc:	50                   	push   %eax
80101edd:	e8 9e 2e 00 00       	call   80104d80 <strncpy>
  de.inum = inum;
80101ee2:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ee5:	6a 10                	push   $0x10
80101ee7:	57                   	push   %edi
80101ee8:	56                   	push   %esi
80101ee9:	53                   	push   %ebx
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101eea:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101eee:	e8 dd fb ff ff       	call   80101ad0 <writei>
80101ef3:	83 c4 20             	add    $0x20,%esp
80101ef6:	83 f8 10             	cmp    $0x10,%eax
80101ef9:	75 2a                	jne    80101f25 <dirlink+0xa5>
    panic("dirlink");

  return 0;
80101efb:	31 c0                	xor    %eax,%eax
}
80101efd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f00:	5b                   	pop    %ebx
80101f01:	5e                   	pop    %esi
80101f02:	5f                   	pop    %edi
80101f03:	5d                   	pop    %ebp
80101f04:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101f05:	83 ec 0c             	sub    $0xc,%esp
80101f08:	50                   	push   %eax
80101f09:	e8 12 f9 ff ff       	call   80101820 <iput>
    return -1;
80101f0e:	83 c4 10             	add    $0x10,%esp
80101f11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f16:	eb e5                	jmp    80101efd <dirlink+0x7d>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101f18:	83 ec 0c             	sub    $0xc,%esp
80101f1b:	68 e8 7d 10 80       	push   $0x80107de8
80101f20:	e8 4b e4 ff ff       	call   80100370 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101f25:	83 ec 0c             	sub    $0xc,%esp
80101f28:	68 d1 84 10 80       	push   $0x801084d1
80101f2d:	e8 3e e4 ff ff       	call   80100370 <panic>
80101f32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f40 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101f40:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f41:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101f43:	89 e5                	mov    %esp,%ebp
80101f45:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f48:	8b 45 08             	mov    0x8(%ebp),%eax
80101f4b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f4e:	e8 7d fd ff ff       	call   80101cd0 <namex>
}
80101f53:	c9                   	leave  
80101f54:	c3                   	ret    
80101f55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f60 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f60:	55                   	push   %ebp
  return namex(path, 1, name);
80101f61:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101f66:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f68:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f6b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f6e:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101f6f:	e9 5c fd ff ff       	jmp    80101cd0 <namex>
80101f74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101f7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101f80 <itoa>:


#include "fcntl.h"
#define DIGITS 14

char* itoa(int i, char b[]){
80101f80:	55                   	push   %ebp
    char const digit[] = "0123456789";
80101f81:	b8 38 39 00 00       	mov    $0x3938,%eax


#include "fcntl.h"
#define DIGITS 14

char* itoa(int i, char b[]){
80101f86:	89 e5                	mov    %esp,%ebp
80101f88:	57                   	push   %edi
80101f89:	56                   	push   %esi
80101f8a:	53                   	push   %ebx
80101f8b:	83 ec 10             	sub    $0x10,%esp
80101f8e:	8b 4d 08             	mov    0x8(%ebp),%ecx
    char const digit[] = "0123456789";
80101f91:	c7 45 e9 30 31 32 33 	movl   $0x33323130,-0x17(%ebp)
80101f98:	c7 45 ed 34 35 36 37 	movl   $0x37363534,-0x13(%ebp)
80101f9f:	66 89 45 f1          	mov    %ax,-0xf(%ebp)
80101fa3:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
80101fa7:	8b 75 0c             	mov    0xc(%ebp),%esi
    char* p = b;
    if(i<0){
80101faa:	85 c9                	test   %ecx,%ecx
80101fac:	78 62                	js     80102010 <itoa+0x90>
        *p++ = '-';
        i *= -1;
    }
    int shifter = i;
80101fae:	89 cb                	mov    %ecx,%ebx
    do{ //Move to where representation ends
        ++p;
        shifter = shifter/10;
80101fb0:	bf 67 66 66 66       	mov    $0x66666667,%edi
80101fb5:	8d 76 00             	lea    0x0(%esi),%esi
80101fb8:	89 d8                	mov    %ebx,%eax
80101fba:	c1 fb 1f             	sar    $0x1f,%ebx
        *p++ = '-';
        i *= -1;
    }
    int shifter = i;
    do{ //Move to where representation ends
        ++p;
80101fbd:	83 c6 01             	add    $0x1,%esi
        shifter = shifter/10;
80101fc0:	f7 ef                	imul   %edi
80101fc2:	c1 fa 02             	sar    $0x2,%edx
    }while(shifter);
80101fc5:	29 da                	sub    %ebx,%edx
80101fc7:	89 d3                	mov    %edx,%ebx
80101fc9:	75 ed                	jne    80101fb8 <itoa+0x38>
    *p = '\0';
80101fcb:	c6 06 00             	movb   $0x0,(%esi)
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
80101fce:	bb 67 66 66 66       	mov    $0x66666667,%ebx
80101fd3:	90                   	nop
80101fd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fd8:	89 c8                	mov    %ecx,%eax
80101fda:	83 ee 01             	sub    $0x1,%esi
80101fdd:	f7 eb                	imul   %ebx
80101fdf:	89 c8                	mov    %ecx,%eax
80101fe1:	c1 f8 1f             	sar    $0x1f,%eax
80101fe4:	c1 fa 02             	sar    $0x2,%edx
80101fe7:	29 c2                	sub    %eax,%edx
80101fe9:	8d 04 92             	lea    (%edx,%edx,4),%eax
80101fec:	01 c0                	add    %eax,%eax
80101fee:	29 c1                	sub    %eax,%ecx
        i = i/10;
    }while(i);
80101ff0:	85 d2                	test   %edx,%edx
        ++p;
        shifter = shifter/10;
    }while(shifter);
    *p = '\0';
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
80101ff2:	0f b6 44 0d e9       	movzbl -0x17(%ebp,%ecx,1),%eax
        i = i/10;
80101ff7:	89 d1                	mov    %edx,%ecx
        ++p;
        shifter = shifter/10;
    }while(shifter);
    *p = '\0';
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
80101ff9:	88 06                	mov    %al,(%esi)
        i = i/10;
    }while(i);
80101ffb:	75 db                	jne    80101fd8 <itoa+0x58>
    return b;
}
80101ffd:	8b 45 0c             	mov    0xc(%ebp),%eax
80102000:	83 c4 10             	add    $0x10,%esp
80102003:	5b                   	pop    %ebx
80102004:	5e                   	pop    %esi
80102005:	5f                   	pop    %edi
80102006:	5d                   	pop    %ebp
80102007:	c3                   	ret    
80102008:	90                   	nop
80102009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

char* itoa(int i, char b[]){
    char const digit[] = "0123456789";
    char* p = b;
    if(i<0){
        *p++ = '-';
80102010:	89 f0                	mov    %esi,%eax
        i *= -1;
80102012:	f7 d9                	neg    %ecx

char* itoa(int i, char b[]){
    char const digit[] = "0123456789";
    char* p = b;
    if(i<0){
        *p++ = '-';
80102014:	8d 76 01             	lea    0x1(%esi),%esi
80102017:	c6 00 2d             	movb   $0x2d,(%eax)
8010201a:	eb 92                	jmp    80101fae <itoa+0x2e>
8010201c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102020 <removeSwapFile>:
    return b;
}
//remove swap file of proc p;
int
removeSwapFile(struct proc* p)
{
80102020:	55                   	push   %ebp
80102021:	89 e5                	mov    %esp,%ebp
80102023:	57                   	push   %edi
80102024:	56                   	push   %esi
80102025:	53                   	push   %ebx
  //path of proccess
  char path[DIGITS];
  memmove(path,"/.swap", 6);
80102026:	8d 75 bc             	lea    -0x44(%ebp),%esi
    return b;
}
//remove swap file of proc p;
int
removeSwapFile(struct proc* p)
{
80102029:	83 ec 40             	sub    $0x40,%esp
8010202c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  //path of proccess
  char path[DIGITS];
  memmove(path,"/.swap", 6);
8010202f:	6a 06                	push   $0x6
80102031:	68 f5 7d 10 80       	push   $0x80107df5
80102036:	56                   	push   %esi
80102037:	e8 54 2c 00 00       	call   80104c90 <memmove>
  itoa(p->pid, path+ 6);
8010203c:	58                   	pop    %eax
8010203d:	8d 45 c2             	lea    -0x3e(%ebp),%eax
80102040:	5a                   	pop    %edx
80102041:	50                   	push   %eax
80102042:	ff 73 10             	pushl  0x10(%ebx)
80102045:	e8 36 ff ff ff       	call   80101f80 <itoa>
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ];
  uint off;

  if(0 == p->swapFile)
8010204a:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010204d:	83 c4 10             	add    $0x10,%esp
80102050:	85 c0                	test   %eax,%eax
80102052:	0f 84 88 01 00 00    	je     801021e0 <removeSwapFile+0x1c0>
  {
    return -1;
  }
  fileclose(p->swapFile);
80102058:	83 ec 0c             	sub    $0xc,%esp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
8010205b:	8d 5d ca             	lea    -0x36(%ebp),%ebx

  if(0 == p->swapFile)
  {
    return -1;
  }
  fileclose(p->swapFile);
8010205e:	50                   	push   %eax
8010205f:	e8 4c ee ff ff       	call   80100eb0 <fileclose>

  begin_op();
80102064:	e8 47 0f 00 00       	call   80102fb0 <begin_op>
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80102069:	89 f0                	mov    %esi,%eax
8010206b:	89 d9                	mov    %ebx,%ecx
8010206d:	ba 01 00 00 00       	mov    $0x1,%edx
80102072:	e8 59 fc ff ff       	call   80101cd0 <namex>
    return -1;
  }
  fileclose(p->swapFile);

  begin_op();
  if((dp = nameiparent(path, name)) == 0)
80102077:	83 c4 10             	add    $0x10,%esp
8010207a:	85 c0                	test   %eax,%eax
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
8010207c:	89 c6                	mov    %eax,%esi
    return -1;
  }
  fileclose(p->swapFile);

  begin_op();
  if((dp = nameiparent(path, name)) == 0)
8010207e:	0f 84 66 01 00 00    	je     801021ea <removeSwapFile+0x1ca>
  {
    end_op();
    return -1;
  }

  ilock(dp);
80102084:	83 ec 0c             	sub    $0xc,%esp
80102087:	50                   	push   %eax
80102088:	e8 63 f6 ff ff       	call   801016f0 <ilock>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
8010208d:	83 c4 0c             	add    $0xc,%esp
80102090:	6a 0e                	push   $0xe
80102092:	68 fd 7d 10 80       	push   $0x80107dfd
80102097:	53                   	push   %ebx
80102098:	e8 73 2c 00 00       	call   80104d10 <strncmp>
  }

  ilock(dp);

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010209d:	83 c4 10             	add    $0x10,%esp
801020a0:	85 c0                	test   %eax,%eax
801020a2:	0f 84 f0 00 00 00    	je     80102198 <removeSwapFile+0x178>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
801020a8:	83 ec 04             	sub    $0x4,%esp
801020ab:	6a 0e                	push   $0xe
801020ad:	68 fc 7d 10 80       	push   $0x80107dfc
801020b2:	53                   	push   %ebx
801020b3:	e8 58 2c 00 00       	call   80104d10 <strncmp>
  }

  ilock(dp);

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801020b8:	83 c4 10             	add    $0x10,%esp
801020bb:	85 c0                	test   %eax,%eax
801020bd:	0f 84 d5 00 00 00    	je     80102198 <removeSwapFile+0x178>
     goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801020c3:	8d 45 b8             	lea    -0x48(%ebp),%eax
801020c6:	83 ec 04             	sub    $0x4,%esp
801020c9:	50                   	push   %eax
801020ca:	53                   	push   %ebx
801020cb:	56                   	push   %esi
801020cc:	e8 4f fb ff ff       	call   80101c20 <dirlookup>
801020d1:	83 c4 10             	add    $0x10,%esp
801020d4:	85 c0                	test   %eax,%eax
801020d6:	89 c3                	mov    %eax,%ebx
801020d8:	0f 84 ba 00 00 00    	je     80102198 <removeSwapFile+0x178>
    goto bad;
  ilock(ip);
801020de:	83 ec 0c             	sub    $0xc,%esp
801020e1:	50                   	push   %eax
801020e2:	e8 09 f6 ff ff       	call   801016f0 <ilock>

  if(ip->nlink < 1)
801020e7:	83 c4 10             	add    $0x10,%esp
801020ea:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801020ef:	0f 8e 11 01 00 00    	jle    80102206 <removeSwapFile+0x1e6>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
801020f5:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801020fa:	74 74                	je     80102170 <removeSwapFile+0x150>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
801020fc:	8d 7d d8             	lea    -0x28(%ebp),%edi
801020ff:	83 ec 04             	sub    $0x4,%esp
80102102:	6a 10                	push   $0x10
80102104:	6a 00                	push   $0x0
80102106:	57                   	push   %edi
80102107:	e8 d4 2a 00 00       	call   80104be0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010210c:	6a 10                	push   $0x10
8010210e:	ff 75 b8             	pushl  -0x48(%ebp)
80102111:	57                   	push   %edi
80102112:	56                   	push   %esi
80102113:	e8 b8 f9 ff ff       	call   80101ad0 <writei>
80102118:	83 c4 20             	add    $0x20,%esp
8010211b:	83 f8 10             	cmp    $0x10,%eax
8010211e:	0f 85 d5 00 00 00    	jne    801021f9 <removeSwapFile+0x1d9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80102124:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102129:	0f 84 91 00 00 00    	je     801021c0 <removeSwapFile+0x1a0>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
8010212f:	83 ec 0c             	sub    $0xc,%esp
80102132:	56                   	push   %esi
80102133:	e8 98 f6 ff ff       	call   801017d0 <iunlock>
  iput(ip);
80102138:	89 34 24             	mov    %esi,(%esp)
8010213b:	e8 e0 f6 ff ff       	call   80101820 <iput>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);

  ip->nlink--;
80102140:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80102145:	89 1c 24             	mov    %ebx,(%esp)
80102148:	e8 f3 f4 ff ff       	call   80101640 <iupdate>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
8010214d:	89 1c 24             	mov    %ebx,(%esp)
80102150:	e8 7b f6 ff ff       	call   801017d0 <iunlock>
  iput(ip);
80102155:	89 1c 24             	mov    %ebx,(%esp)
80102158:	e8 c3 f6 ff ff       	call   80101820 <iput>

  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);

  end_op();
8010215d:	e8 be 0e 00 00       	call   80103020 <end_op>

  return 0;
80102162:	83 c4 10             	add    $0x10,%esp
80102165:	31 c0                	xor    %eax,%eax
  bad:
    iunlockput(dp);
    end_op();
    return -1;

}
80102167:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010216a:	5b                   	pop    %ebx
8010216b:	5e                   	pop    %esi
8010216c:	5f                   	pop    %edi
8010216d:	5d                   	pop    %ebp
8010216e:	c3                   	ret    
8010216f:	90                   	nop
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80102170:	83 ec 0c             	sub    $0xc,%esp
80102173:	53                   	push   %ebx
80102174:	e8 c7 32 00 00       	call   80105440 <isdirempty>
80102179:	83 c4 10             	add    $0x10,%esp
8010217c:	85 c0                	test   %eax,%eax
8010217e:	0f 85 78 ff ff ff    	jne    801020fc <removeSwapFile+0xdc>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80102184:	83 ec 0c             	sub    $0xc,%esp
80102187:	53                   	push   %ebx
80102188:	e8 43 f6 ff ff       	call   801017d0 <iunlock>
  iput(ip);
8010218d:	89 1c 24             	mov    %ebx,(%esp)
80102190:	e8 8b f6 ff ff       	call   80101820 <iput>
80102195:	83 c4 10             	add    $0x10,%esp

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80102198:	83 ec 0c             	sub    $0xc,%esp
8010219b:	56                   	push   %esi
8010219c:	e8 2f f6 ff ff       	call   801017d0 <iunlock>
  iput(ip);
801021a1:	89 34 24             	mov    %esi,(%esp)
801021a4:	e8 77 f6 ff ff       	call   80101820 <iput>

  return 0;

  bad:
    iunlockput(dp);
    end_op();
801021a9:	e8 72 0e 00 00       	call   80103020 <end_op>
    return -1;
801021ae:	83 c4 10             	add    $0x10,%esp

}
801021b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

  bad:
    iunlockput(dp);
    end_op();
    return -1;
801021b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

}
801021b9:	5b                   	pop    %ebx
801021ba:	5e                   	pop    %esi
801021bb:	5f                   	pop    %edi
801021bc:	5d                   	pop    %ebp
801021bd:	c3                   	ret    
801021be:	66 90                	xchg   %ax,%ax

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
801021c0:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801021c5:	83 ec 0c             	sub    $0xc,%esp
801021c8:	56                   	push   %esi
801021c9:	e8 72 f4 ff ff       	call   80101640 <iupdate>
801021ce:	83 c4 10             	add    $0x10,%esp
801021d1:	e9 59 ff ff ff       	jmp    8010212f <removeSwapFile+0x10f>
801021d6:	8d 76 00             	lea    0x0(%esi),%esi
801021d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  char name[DIRSIZ];
  uint off;

  if(0 == p->swapFile)
  {
    return -1;
801021e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021e5:	e9 7d ff ff ff       	jmp    80102167 <removeSwapFile+0x147>
  fileclose(p->swapFile);

  begin_op();
  if((dp = nameiparent(path, name)) == 0)
  {
    end_op();
801021ea:	e8 31 0e 00 00       	call   80103020 <end_op>
    return -1;
801021ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021f4:	e9 6e ff ff ff       	jmp    80102167 <removeSwapFile+0x147>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
801021f9:	83 ec 0c             	sub    $0xc,%esp
801021fc:	68 11 7e 10 80       	push   $0x80107e11
80102201:	e8 6a e1 ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80102206:	83 ec 0c             	sub    $0xc,%esp
80102209:	68 ff 7d 10 80       	push   $0x80107dff
8010220e:	e8 5d e1 ff ff       	call   80100370 <panic>
80102213:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102220 <createSwapFile>:


//return 0 on success
int
createSwapFile(struct proc* p)
{
80102220:	55                   	push   %ebp
80102221:	89 e5                	mov    %esp,%ebp
80102223:	56                   	push   %esi
80102224:	53                   	push   %ebx

  char path[DIGITS];
  memmove(path,"/.swap", 6);
80102225:	8d 75 ea             	lea    -0x16(%ebp),%esi


//return 0 on success
int
createSwapFile(struct proc* p)
{
80102228:	83 ec 14             	sub    $0x14,%esp
8010222b:	8b 5d 08             	mov    0x8(%ebp),%ebx

  char path[DIGITS];
  memmove(path,"/.swap", 6);
8010222e:	6a 06                	push   $0x6
80102230:	68 f5 7d 10 80       	push   $0x80107df5
80102235:	56                   	push   %esi
80102236:	e8 55 2a 00 00       	call   80104c90 <memmove>
  itoa(p->pid, path+ 6);
8010223b:	58                   	pop    %eax
8010223c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010223f:	5a                   	pop    %edx
80102240:	50                   	push   %eax
80102241:	ff 73 10             	pushl  0x10(%ebx)
80102244:	e8 37 fd ff ff       	call   80101f80 <itoa>

    begin_op();
80102249:	e8 62 0d 00 00       	call   80102fb0 <begin_op>
    struct inode * in = create(path, T_FILE, 0, 0);
8010224e:	6a 00                	push   $0x0
80102250:	6a 00                	push   $0x0
80102252:	6a 02                	push   $0x2
80102254:	56                   	push   %esi
80102255:	e8 f6 33 00 00       	call   80105650 <create>
  iunlock(in);
8010225a:	83 c4 14             	add    $0x14,%esp
  char path[DIGITS];
  memmove(path,"/.swap", 6);
  itoa(p->pid, path+ 6);

    begin_op();
    struct inode * in = create(path, T_FILE, 0, 0);
8010225d:	89 c6                	mov    %eax,%esi
  iunlock(in);
8010225f:	50                   	push   %eax
80102260:	e8 6b f5 ff ff       	call   801017d0 <iunlock>

  p->swapFile = filealloc();
80102265:	e8 86 eb ff ff       	call   80100df0 <filealloc>
  if (p->swapFile == 0)
8010226a:	83 c4 10             	add    $0x10,%esp
8010226d:	85 c0                	test   %eax,%eax

    begin_op();
    struct inode * in = create(path, T_FILE, 0, 0);
  iunlock(in);

  p->swapFile = filealloc();
8010226f:	89 43 7c             	mov    %eax,0x7c(%ebx)
  if (p->swapFile == 0)
80102272:	74 32                	je     801022a6 <createSwapFile+0x86>
    panic("no slot for files on /store");

  p->swapFile->ip = in;
80102274:	89 70 10             	mov    %esi,0x10(%eax)
  p->swapFile->type = FD_INODE;
80102277:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010227a:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  p->swapFile->off = 0;
80102280:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102283:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  p->swapFile->readable = O_WRONLY;
8010228a:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010228d:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  p->swapFile->writable = O_RDWR;
80102291:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102294:	c6 40 09 02          	movb   $0x2,0x9(%eax)
    end_op();
80102298:	e8 83 0d 00 00       	call   80103020 <end_op>

    return 0;
}
8010229d:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022a0:	31 c0                	xor    %eax,%eax
801022a2:	5b                   	pop    %ebx
801022a3:	5e                   	pop    %esi
801022a4:	5d                   	pop    %ebp
801022a5:	c3                   	ret    
    struct inode * in = create(path, T_FILE, 0, 0);
  iunlock(in);

  p->swapFile = filealloc();
  if (p->swapFile == 0)
    panic("no slot for files on /store");
801022a6:	83 ec 0c             	sub    $0xc,%esp
801022a9:	68 20 7e 10 80       	push   $0x80107e20
801022ae:	e8 bd e0 ff ff       	call   80100370 <panic>
801022b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801022b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022c0 <writeToSwapFile>:
}

//return as sys_write (-1 when error)
int
writeToSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
801022c0:	55                   	push   %ebp
801022c1:	89 e5                	mov    %esp,%ebp
801022c3:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
801022c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801022c9:	8b 50 7c             	mov    0x7c(%eax),%edx
801022cc:	89 4a 14             	mov    %ecx,0x14(%edx)

  return filewrite(p->swapFile, buffer, size);
801022cf:	8b 55 14             	mov    0x14(%ebp),%edx
801022d2:	89 55 10             	mov    %edx,0x10(%ebp)
801022d5:	8b 40 7c             	mov    0x7c(%eax),%eax
801022d8:	89 45 08             	mov    %eax,0x8(%ebp)

}
801022db:	5d                   	pop    %ebp
int
writeToSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
  p->swapFile->off = placeOnFile;

  return filewrite(p->swapFile, buffer, size);
801022dc:	e9 7f ed ff ff       	jmp    80101060 <filewrite>
801022e1:	eb 0d                	jmp    801022f0 <readFromSwapFile>
801022e3:	90                   	nop
801022e4:	90                   	nop
801022e5:	90                   	nop
801022e6:	90                   	nop
801022e7:	90                   	nop
801022e8:	90                   	nop
801022e9:	90                   	nop
801022ea:	90                   	nop
801022eb:	90                   	nop
801022ec:	90                   	nop
801022ed:	90                   	nop
801022ee:	90                   	nop
801022ef:	90                   	nop

801022f0 <readFromSwapFile>:
}

//return as sys_read (-1 when error)
int
readFromSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
801022f0:	55                   	push   %ebp
801022f1:	89 e5                	mov    %esp,%ebp
801022f3:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
801022f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801022f9:	8b 50 7c             	mov    0x7c(%eax),%edx
801022fc:	89 4a 14             	mov    %ecx,0x14(%edx)

  return fileread(p->swapFile, buffer,  size);
801022ff:	8b 55 14             	mov    0x14(%ebp),%edx
80102302:	89 55 10             	mov    %edx,0x10(%ebp)
80102305:	8b 40 7c             	mov    0x7c(%eax),%eax
80102308:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010230b:	5d                   	pop    %ebp
int
readFromSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
  p->swapFile->off = placeOnFile;

  return fileread(p->swapFile, buffer,  size);
8010230c:	e9 bf ec ff ff       	jmp    80100fd0 <fileread>
80102311:	66 90                	xchg   %ax,%ax
80102313:	66 90                	xchg   %ax,%ax
80102315:	66 90                	xchg   %ax,%ax
80102317:	66 90                	xchg   %ax,%ax
80102319:	66 90                	xchg   %ax,%ax
8010231b:	66 90                	xchg   %ax,%ax
8010231d:	66 90                	xchg   %ax,%ax
8010231f:	90                   	nop

80102320 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102320:	55                   	push   %ebp
  if(b == 0)
80102321:	85 c0                	test   %eax,%eax
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102323:	89 e5                	mov    %esp,%ebp
80102325:	56                   	push   %esi
80102326:	53                   	push   %ebx
  if(b == 0)
80102327:	0f 84 ad 00 00 00    	je     801023da <idestart+0xba>
    panic("idestart");
  if(b->blockno >= FSSIZE)
8010232d:	8b 58 08             	mov    0x8(%eax),%ebx
80102330:	89 c1                	mov    %eax,%ecx
80102332:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80102338:	0f 87 8f 00 00 00    	ja     801023cd <idestart+0xad>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010233e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102343:	90                   	nop
80102344:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102348:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102349:	83 e0 c0             	and    $0xffffffc0,%eax
8010234c:	3c 40                	cmp    $0x40,%al
8010234e:	75 f8                	jne    80102348 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102350:	31 f6                	xor    %esi,%esi
80102352:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102357:	89 f0                	mov    %esi,%eax
80102359:	ee                   	out    %al,(%dx)
8010235a:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010235f:	b8 01 00 00 00       	mov    $0x1,%eax
80102364:	ee                   	out    %al,(%dx)
80102365:	ba f3 01 00 00       	mov    $0x1f3,%edx
8010236a:	89 d8                	mov    %ebx,%eax
8010236c:	ee                   	out    %al,(%dx)
8010236d:	89 d8                	mov    %ebx,%eax
8010236f:	ba f4 01 00 00       	mov    $0x1f4,%edx
80102374:	c1 f8 08             	sar    $0x8,%eax
80102377:	ee                   	out    %al,(%dx)
80102378:	ba f5 01 00 00       	mov    $0x1f5,%edx
8010237d:	89 f0                	mov    %esi,%eax
8010237f:	ee                   	out    %al,(%dx)
80102380:	0f b6 41 04          	movzbl 0x4(%ecx),%eax
80102384:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102389:	83 e0 01             	and    $0x1,%eax
8010238c:	c1 e0 04             	shl    $0x4,%eax
8010238f:	83 c8 e0             	or     $0xffffffe0,%eax
80102392:	ee                   	out    %al,(%dx)
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
80102393:	f6 01 04             	testb  $0x4,(%ecx)
80102396:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010239b:	75 13                	jne    801023b0 <idestart+0x90>
8010239d:	b8 20 00 00 00       	mov    $0x20,%eax
801023a2:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801023a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023a6:	5b                   	pop    %ebx
801023a7:	5e                   	pop    %esi
801023a8:	5d                   	pop    %ebp
801023a9:	c3                   	ret    
801023aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801023b0:	b8 30 00 00 00       	mov    $0x30,%eax
801023b5:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
801023b6:	ba f0 01 00 00       	mov    $0x1f0,%edx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
801023bb:	8d 71 5c             	lea    0x5c(%ecx),%esi
801023be:	b9 80 00 00 00       	mov    $0x80,%ecx
801023c3:	fc                   	cld    
801023c4:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
801023c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023c9:	5b                   	pop    %ebx
801023ca:	5e                   	pop    %esi
801023cb:	5d                   	pop    %ebp
801023cc:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
801023cd:	83 ec 0c             	sub    $0xc,%esp
801023d0:	68 98 7e 10 80       	push   $0x80107e98
801023d5:	e8 96 df ff ff       	call   80100370 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
801023da:	83 ec 0c             	sub    $0xc,%esp
801023dd:	68 8f 7e 10 80       	push   $0x80107e8f
801023e2:	e8 89 df ff ff       	call   80100370 <panic>
801023e7:	89 f6                	mov    %esi,%esi
801023e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023f0 <ideinit>:
  return 0;
}

void
ideinit(void)
{
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	83 ec 10             	sub    $0x10,%esp
  int i;

  initlock(&idelock, "ide");
801023f6:	68 aa 7e 10 80       	push   $0x80107eaa
801023fb:	68 80 b5 10 80       	push   $0x8010b580
80102400:	e8 4b 25 00 00       	call   80104950 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102405:	58                   	pop    %eax
80102406:	a1 20 3d 11 80       	mov    0x80113d20,%eax
8010240b:	5a                   	pop    %edx
8010240c:	83 e8 01             	sub    $0x1,%eax
8010240f:	50                   	push   %eax
80102410:	6a 0e                	push   $0xe
80102412:	e8 a9 02 00 00       	call   801026c0 <ioapicenable>
80102417:	83 c4 10             	add    $0x10,%esp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010241a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010241f:	90                   	nop
80102420:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102421:	83 e0 c0             	and    $0xffffffc0,%eax
80102424:	3c 40                	cmp    $0x40,%al
80102426:	75 f8                	jne    80102420 <ideinit+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102428:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010242d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102432:	ee                   	out    %al,(%dx)
80102433:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102438:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010243d:	eb 06                	jmp    80102445 <ideinit+0x55>
8010243f:	90                   	nop
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102440:	83 e9 01             	sub    $0x1,%ecx
80102443:	74 0f                	je     80102454 <ideinit+0x64>
80102445:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102446:	84 c0                	test   %al,%al
80102448:	74 f6                	je     80102440 <ideinit+0x50>
      havedisk1 = 1;
8010244a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102451:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102454:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102459:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
8010245e:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
8010245f:	c9                   	leave  
80102460:	c3                   	ret    
80102461:	eb 0d                	jmp    80102470 <ideintr>
80102463:	90                   	nop
80102464:	90                   	nop
80102465:	90                   	nop
80102466:	90                   	nop
80102467:	90                   	nop
80102468:	90                   	nop
80102469:	90                   	nop
8010246a:	90                   	nop
8010246b:	90                   	nop
8010246c:	90                   	nop
8010246d:	90                   	nop
8010246e:	90                   	nop
8010246f:	90                   	nop

80102470 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102470:	55                   	push   %ebp
80102471:	89 e5                	mov    %esp,%ebp
80102473:	57                   	push   %edi
80102474:	56                   	push   %esi
80102475:	53                   	push   %ebx
80102476:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102479:	68 80 b5 10 80       	push   $0x8010b580
8010247e:	e8 cd 25 00 00       	call   80104a50 <acquire>

  if((b = idequeue) == 0){
80102483:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
80102489:	83 c4 10             	add    $0x10,%esp
8010248c:	85 db                	test   %ebx,%ebx
8010248e:	74 34                	je     801024c4 <ideintr+0x54>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102490:	8b 43 58             	mov    0x58(%ebx),%eax
80102493:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102498:	8b 33                	mov    (%ebx),%esi
8010249a:	f7 c6 04 00 00 00    	test   $0x4,%esi
801024a0:	74 3e                	je     801024e0 <ideintr+0x70>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801024a2:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801024a5:	83 ec 0c             	sub    $0xc,%esp
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801024a8:	83 ce 02             	or     $0x2,%esi
801024ab:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801024ad:	53                   	push   %ebx
801024ae:	e8 cd 20 00 00       	call   80104580 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801024b3:	a1 64 b5 10 80       	mov    0x8010b564,%eax
801024b8:	83 c4 10             	add    $0x10,%esp
801024bb:	85 c0                	test   %eax,%eax
801024bd:	74 05                	je     801024c4 <ideintr+0x54>
    idestart(idequeue);
801024bf:	e8 5c fe ff ff       	call   80102320 <idestart>

  // First queued buffer is the active request.
  acquire(&idelock);

  if((b = idequeue) == 0){
    release(&idelock);
801024c4:	83 ec 0c             	sub    $0xc,%esp
801024c7:	68 80 b5 10 80       	push   $0x8010b580
801024cc:	e8 bf 26 00 00       	call   80104b90 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
801024d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024d4:	5b                   	pop    %ebx
801024d5:	5e                   	pop    %esi
801024d6:	5f                   	pop    %edi
801024d7:	5d                   	pop    %ebp
801024d8:	c3                   	ret    
801024d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024e0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801024e5:	8d 76 00             	lea    0x0(%esi),%esi
801024e8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801024e9:	89 c1                	mov    %eax,%ecx
801024eb:	83 e1 c0             	and    $0xffffffc0,%ecx
801024ee:	80 f9 40             	cmp    $0x40,%cl
801024f1:	75 f5                	jne    801024e8 <ideintr+0x78>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801024f3:	a8 21                	test   $0x21,%al
801024f5:	75 ab                	jne    801024a2 <ideintr+0x32>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
801024f7:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
801024fa:	b9 80 00 00 00       	mov    $0x80,%ecx
801024ff:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102504:	fc                   	cld    
80102505:	f3 6d                	rep insl (%dx),%es:(%edi)
80102507:	8b 33                	mov    (%ebx),%esi
80102509:	eb 97                	jmp    801024a2 <ideintr+0x32>
8010250b:	90                   	nop
8010250c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102510 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102510:	55                   	push   %ebp
80102511:	89 e5                	mov    %esp,%ebp
80102513:	53                   	push   %ebx
80102514:	83 ec 10             	sub    $0x10,%esp
80102517:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010251a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010251d:	50                   	push   %eax
8010251e:	e8 fd 23 00 00       	call   80104920 <holdingsleep>
80102523:	83 c4 10             	add    $0x10,%esp
80102526:	85 c0                	test   %eax,%eax
80102528:	0f 84 ad 00 00 00    	je     801025db <iderw+0xcb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010252e:	8b 03                	mov    (%ebx),%eax
80102530:	83 e0 06             	and    $0x6,%eax
80102533:	83 f8 02             	cmp    $0x2,%eax
80102536:	0f 84 b9 00 00 00    	je     801025f5 <iderw+0xe5>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010253c:	8b 53 04             	mov    0x4(%ebx),%edx
8010253f:	85 d2                	test   %edx,%edx
80102541:	74 0d                	je     80102550 <iderw+0x40>
80102543:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102548:	85 c0                	test   %eax,%eax
8010254a:	0f 84 98 00 00 00    	je     801025e8 <iderw+0xd8>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102550:	83 ec 0c             	sub    $0xc,%esp
80102553:	68 80 b5 10 80       	push   $0x8010b580
80102558:	e8 f3 24 00 00       	call   80104a50 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010255d:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
80102563:	83 c4 10             	add    $0x10,%esp
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
80102566:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010256d:	85 d2                	test   %edx,%edx
8010256f:	75 09                	jne    8010257a <iderw+0x6a>
80102571:	eb 58                	jmp    801025cb <iderw+0xbb>
80102573:	90                   	nop
80102574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102578:	89 c2                	mov    %eax,%edx
8010257a:	8b 42 58             	mov    0x58(%edx),%eax
8010257d:	85 c0                	test   %eax,%eax
8010257f:	75 f7                	jne    80102578 <iderw+0x68>
80102581:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102584:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102586:	3b 1d 64 b5 10 80    	cmp    0x8010b564,%ebx
8010258c:	74 44                	je     801025d2 <iderw+0xc2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010258e:	8b 03                	mov    (%ebx),%eax
80102590:	83 e0 06             	and    $0x6,%eax
80102593:	83 f8 02             	cmp    $0x2,%eax
80102596:	74 23                	je     801025bb <iderw+0xab>
80102598:	90                   	nop
80102599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801025a0:	83 ec 08             	sub    $0x8,%esp
801025a3:	68 80 b5 10 80       	push   $0x8010b580
801025a8:	53                   	push   %ebx
801025a9:	e8 f2 1d 00 00       	call   801043a0 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801025ae:	8b 03                	mov    (%ebx),%eax
801025b0:	83 c4 10             	add    $0x10,%esp
801025b3:	83 e0 06             	and    $0x6,%eax
801025b6:	83 f8 02             	cmp    $0x2,%eax
801025b9:	75 e5                	jne    801025a0 <iderw+0x90>
    sleep(b, &idelock);
  }


  release(&idelock);
801025bb:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
801025c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025c5:	c9                   	leave  
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
801025c6:	e9 c5 25 00 00       	jmp    80104b90 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801025cb:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
801025d0:	eb b2                	jmp    80102584 <iderw+0x74>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
801025d2:	89 d8                	mov    %ebx,%eax
801025d4:	e8 47 fd ff ff       	call   80102320 <idestart>
801025d9:	eb b3                	jmp    8010258e <iderw+0x7e>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
801025db:	83 ec 0c             	sub    $0xc,%esp
801025de:	68 ae 7e 10 80       	push   $0x80107eae
801025e3:	e8 88 dd ff ff       	call   80100370 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
801025e8:	83 ec 0c             	sub    $0xc,%esp
801025eb:	68 d9 7e 10 80       	push   $0x80107ed9
801025f0:	e8 7b dd ff ff       	call   80100370 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
801025f5:	83 ec 0c             	sub    $0xc,%esp
801025f8:	68 c4 7e 10 80       	push   $0x80107ec4
801025fd:	e8 6e dd ff ff       	call   80100370 <panic>
80102602:	66 90                	xchg   %ax,%ax
80102604:	66 90                	xchg   %ax,%ax
80102606:	66 90                	xchg   %ax,%ax
80102608:	66 90                	xchg   %ax,%ax
8010260a:	66 90                	xchg   %ax,%ax
8010260c:	66 90                	xchg   %ax,%ax
8010260e:	66 90                	xchg   %ax,%ax

80102610 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102610:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102611:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
80102618:	00 c0 fe 
  ioapic->data = data;
}

void
ioapicinit(void)
{
8010261b:	89 e5                	mov    %esp,%ebp
8010261d:	56                   	push   %esi
8010261e:	53                   	push   %ebx
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
8010261f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102626:	00 00 00 
  return ioapic->data;
80102629:	8b 15 34 36 11 80    	mov    0x80113634,%edx
8010262f:	8b 72 10             	mov    0x10(%edx),%esi
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102632:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102638:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010263e:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102645:	89 f0                	mov    %esi,%eax
80102647:	c1 e8 10             	shr    $0x10,%eax
8010264a:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
8010264d:	8b 41 10             	mov    0x10(%ecx),%eax
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102650:	c1 e8 18             	shr    $0x18,%eax
80102653:	39 d0                	cmp    %edx,%eax
80102655:	74 16                	je     8010266d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102657:	83 ec 0c             	sub    $0xc,%esp
8010265a:	68 f8 7e 10 80       	push   $0x80107ef8
8010265f:	e8 fc df ff ff       	call   80100660 <cprintf>
80102664:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
8010266a:	83 c4 10             	add    $0x10,%esp
8010266d:	83 c6 21             	add    $0x21,%esi
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102670:	ba 10 00 00 00       	mov    $0x10,%edx
80102675:	b8 20 00 00 00       	mov    $0x20,%eax
8010267a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102680:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102682:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102688:	89 c3                	mov    %eax,%ebx
8010268a:	81 cb 00 00 01 00    	or     $0x10000,%ebx
80102690:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102693:	89 59 10             	mov    %ebx,0x10(%ecx)
80102696:	8d 5a 01             	lea    0x1(%edx),%ebx
80102699:	83 c2 02             	add    $0x2,%edx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010269c:	39 f0                	cmp    %esi,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010269e:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
801026a0:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
801026a6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801026ad:	75 d1                	jne    80102680 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801026af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026b2:	5b                   	pop    %ebx
801026b3:	5e                   	pop    %esi
801026b4:	5d                   	pop    %ebp
801026b5:	c3                   	ret    
801026b6:	8d 76 00             	lea    0x0(%esi),%esi
801026b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026c0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801026c0:	55                   	push   %ebp
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801026c1:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  }
}

void
ioapicenable(int irq, int cpunum)
{
801026c7:	89 e5                	mov    %esp,%ebp
801026c9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801026cc:	8d 50 20             	lea    0x20(%eax),%edx
801026cf:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801026d3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801026d5:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801026db:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801026de:	89 51 10             	mov    %edx,0x10(%ecx)
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801026e1:	8b 55 0c             	mov    0xc(%ebp),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801026e4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801026e6:	a1 34 36 11 80       	mov    0x80113634,%eax
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801026eb:	c1 e2 18             	shl    $0x18,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801026ee:	89 50 10             	mov    %edx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
801026f1:	5d                   	pop    %ebp
801026f2:	c3                   	ret    
801026f3:	66 90                	xchg   %ax,%ax
801026f5:	66 90                	xchg   %ax,%ax
801026f7:	66 90                	xchg   %ax,%ax
801026f9:	66 90                	xchg   %ax,%ax
801026fb:	66 90                	xchg   %ax,%ax
801026fd:	66 90                	xchg   %ax,%ax
801026ff:	90                   	nop

80102700 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102700:	55                   	push   %ebp
80102701:	89 e5                	mov    %esp,%ebp
80102703:	53                   	push   %ebx
80102704:	83 ec 04             	sub    $0x4,%esp
80102707:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010270a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102710:	0f 85 7c 00 00 00    	jne    80102792 <kfree+0x92>
80102716:	81 fb c8 da 11 80    	cmp    $0x8011dac8,%ebx
8010271c:	72 74                	jb     80102792 <kfree+0x92>
8010271e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102724:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102729:	77 67                	ja     80102792 <kfree+0x92>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
8010272b:	83 ec 04             	sub    $0x4,%esp
8010272e:	68 00 10 00 00       	push   $0x1000
80102733:	6a 01                	push   $0x1
80102735:	53                   	push   %ebx
80102736:	e8 a5 24 00 00       	call   80104be0 <memset>

  if(kmem.use_lock)
8010273b:	8b 15 74 36 11 80    	mov    0x80113674,%edx
80102741:	83 c4 10             	add    $0x10,%esp
80102744:	85 d2                	test   %edx,%edx
80102746:	75 38                	jne    80102780 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102748:	a1 78 36 11 80       	mov    0x80113678,%eax
8010274d:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  freePages++;

  if(kmem.use_lock)
8010274f:	a1 74 36 11 80       	mov    0x80113674,%eax
  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  freePages++;
80102754:	83 05 80 36 11 80 01 	addl   $0x1,0x80113680

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
8010275b:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
  freePages++;

  if(kmem.use_lock)
80102761:	85 c0                	test   %eax,%eax
80102763:	75 0b                	jne    80102770 <kfree+0x70>
    release(&kmem.lock);
}
80102765:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102768:	c9                   	leave  
80102769:	c3                   	ret    
8010276a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r->next = kmem.freelist;
  kmem.freelist = r;
  freePages++;

  if(kmem.use_lock)
    release(&kmem.lock);
80102770:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
80102777:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010277a:	c9                   	leave  
  r->next = kmem.freelist;
  kmem.freelist = r;
  freePages++;

  if(kmem.use_lock)
    release(&kmem.lock);
8010277b:	e9 10 24 00 00       	jmp    80104b90 <release>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102780:	83 ec 0c             	sub    $0xc,%esp
80102783:	68 40 36 11 80       	push   $0x80113640
80102788:	e8 c3 22 00 00       	call   80104a50 <acquire>
8010278d:	83 c4 10             	add    $0x10,%esp
80102790:	eb b6                	jmp    80102748 <kfree+0x48>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
80102792:	83 ec 0c             	sub    $0xc,%esp
80102795:	68 2a 7f 10 80       	push   $0x80107f2a
8010279a:	e8 d1 db ff ff       	call   80100370 <panic>
8010279f:	90                   	nop

801027a0 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
801027a0:	55                   	push   %ebp
801027a1:	89 e5                	mov    %esp,%ebp
801027a3:	56                   	push   %esi
801027a4:	53                   	push   %ebx
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801027a5:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
801027a8:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801027ab:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801027b1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801027b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801027bd:	39 de                	cmp    %ebx,%esi
801027bf:	72 2a                	jb     801027eb <freerange+0x4b>
801027c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    totalPages++;
    kfree(p);
801027c8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801027ce:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801027d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    totalPages++;
801027d7:	83 05 7c 36 11 80 01 	addl   $0x1,0x8011367c
    kfree(p);
801027de:	50                   	push   %eax
801027df:	e8 1c ff ff ff       	call   80102700 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801027e4:	83 c4 10             	add    $0x10,%esp
801027e7:	39 f3                	cmp    %esi,%ebx
801027e9:	76 dd                	jbe    801027c8 <freerange+0x28>
    totalPages++;
    kfree(p);
  }
}
801027eb:	8d 65 f8             	lea    -0x8(%ebp),%esp
801027ee:	5b                   	pop    %ebx
801027ef:	5e                   	pop    %esi
801027f0:	5d                   	pop    %ebp
801027f1:	c3                   	ret    
801027f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102800 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102800:	55                   	push   %ebp
  freePages = 0;
80102801:	c7 05 80 36 11 80 00 	movl   $0x0,0x80113680
80102808:	00 00 00 
  totalPages = 0;
8010280b:	c7 05 7c 36 11 80 00 	movl   $0x0,0x8011367c
80102812:	00 00 00 
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102815:	89 e5                	mov    %esp,%ebp
80102817:	56                   	push   %esi
80102818:	53                   	push   %ebx
80102819:	8b 75 0c             	mov    0xc(%ebp),%esi
  freePages = 0;
  totalPages = 0;
  initlock(&kmem.lock, "kmem");
8010281c:	83 ec 08             	sub    $0x8,%esp
8010281f:	68 30 7f 10 80       	push   $0x80107f30
80102824:	68 40 36 11 80       	push   $0x80113640
80102829:	e8 22 21 00 00       	call   80104950 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010282e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102831:	83 c4 10             	add    $0x10,%esp
kinit1(void *vstart, void *vend)
{
  freePages = 0;
  totalPages = 0;
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
80102834:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
8010283b:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010283e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102844:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
8010284a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102850:	39 de                	cmp    %ebx,%esi
80102852:	72 27                	jb     8010287b <kinit1+0x7b>
80102854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    totalPages++;
    kfree(p);
80102858:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010285e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102861:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    totalPages++;
80102867:	83 05 7c 36 11 80 01 	addl   $0x1,0x8011367c
    kfree(p);
8010286e:	50                   	push   %eax
8010286f:	e8 8c fe ff ff       	call   80102700 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102874:	83 c4 10             	add    $0x10,%esp
80102877:	39 de                	cmp    %ebx,%esi
80102879:	73 dd                	jae    80102858 <kinit1+0x58>
  freePages = 0;
  totalPages = 0;
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
8010287b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010287e:	5b                   	pop    %ebx
8010287f:	5e                   	pop    %esi
80102880:	5d                   	pop    %ebp
80102881:	c3                   	ret    
80102882:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102890 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102890:	55                   	push   %ebp
80102891:	89 e5                	mov    %esp,%ebp
80102893:	56                   	push   %esi
80102894:	53                   	push   %ebx

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102895:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
80102898:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010289b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801028a1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801028a7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801028ad:	39 de                	cmp    %ebx,%esi
801028af:	72 2a                	jb     801028db <kinit2+0x4b>
801028b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    totalPages++;
    kfree(p);
801028b8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801028be:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801028c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    totalPages++;
801028c7:	83 05 7c 36 11 80 01 	addl   $0x1,0x8011367c
    kfree(p);
801028ce:	50                   	push   %eax
801028cf:	e8 2c fe ff ff       	call   80102700 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801028d4:	83 c4 10             	add    $0x10,%esp
801028d7:	39 de                	cmp    %ebx,%esi
801028d9:	73 dd                	jae    801028b8 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
801028db:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
801028e2:	00 00 00 
}
801028e5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801028e8:	5b                   	pop    %ebx
801028e9:	5e                   	pop    %esi
801028ea:	5d                   	pop    %ebp
801028eb:	c3                   	ret    
801028ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801028f0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801028f0:	55                   	push   %ebp
801028f1:	89 e5                	mov    %esp,%ebp
801028f3:	53                   	push   %ebx
801028f4:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
801028f7:	a1 74 36 11 80       	mov    0x80113674,%eax
801028fc:	85 c0                	test   %eax,%eax
801028fe:	75 38                	jne    80102938 <kalloc+0x48>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102900:	8b 1d 78 36 11 80    	mov    0x80113678,%ebx
  if(r){
80102906:	85 db                	test   %ebx,%ebx
80102908:	74 23                	je     8010292d <kalloc+0x3d>
    kmem.freelist = r->next;
8010290a:	8b 13                	mov    (%ebx),%edx
    freePages--;
8010290c:	83 2d 80 36 11 80 01 	subl   $0x1,0x80113680

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = kmem.freelist;
  if(r){
    kmem.freelist = r->next;
80102913:	89 15 78 36 11 80    	mov    %edx,0x80113678
    freePages--;
  }
  if(kmem.use_lock)
80102919:	85 c0                	test   %eax,%eax
8010291b:	74 10                	je     8010292d <kalloc+0x3d>
    release(&kmem.lock);
8010291d:	83 ec 0c             	sub    $0xc,%esp
80102920:	68 40 36 11 80       	push   $0x80113640
80102925:	e8 66 22 00 00       	call   80104b90 <release>
8010292a:	83 c4 10             	add    $0x10,%esp

  return (char*)r;
}
8010292d:	89 d8                	mov    %ebx,%eax
8010292f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102932:	c9                   	leave  
80102933:	c3                   	ret    
80102934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102938:	83 ec 0c             	sub    $0xc,%esp
8010293b:	68 40 36 11 80       	push   $0x80113640
80102940:	e8 0b 21 00 00       	call   80104a50 <acquire>
  r = kmem.freelist;
80102945:	8b 1d 78 36 11 80    	mov    0x80113678,%ebx
  if(r){
8010294b:	83 c4 10             	add    $0x10,%esp
8010294e:	a1 74 36 11 80       	mov    0x80113674,%eax
80102953:	85 db                	test   %ebx,%ebx
80102955:	75 b3                	jne    8010290a <kalloc+0x1a>
80102957:	eb c0                	jmp    80102919 <kalloc+0x29>
80102959:	66 90                	xchg   %ax,%ax
8010295b:	66 90                	xchg   %ax,%ax
8010295d:	66 90                	xchg   %ax,%ax
8010295f:	90                   	nop

80102960 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102960:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102961:	ba 64 00 00 00       	mov    $0x64,%edx
80102966:	89 e5                	mov    %esp,%ebp
80102968:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102969:	a8 01                	test   $0x1,%al
8010296b:	0f 84 af 00 00 00    	je     80102a20 <kbdgetc+0xc0>
80102971:	ba 60 00 00 00       	mov    $0x60,%edx
80102976:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102977:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
8010297a:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102980:	74 7e                	je     80102a00 <kbdgetc+0xa0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102982:	84 c0                	test   %al,%al
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102984:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
8010298a:	79 24                	jns    801029b0 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
8010298c:	f6 c1 40             	test   $0x40,%cl
8010298f:	75 05                	jne    80102996 <kbdgetc+0x36>
80102991:	89 c2                	mov    %eax,%edx
80102993:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102996:	0f b6 82 60 80 10 80 	movzbl -0x7fef7fa0(%edx),%eax
8010299d:	83 c8 40             	or     $0x40,%eax
801029a0:	0f b6 c0             	movzbl %al,%eax
801029a3:	f7 d0                	not    %eax
801029a5:	21 c8                	and    %ecx,%eax
801029a7:	a3 b4 b5 10 80       	mov    %eax,0x8010b5b4
    return 0;
801029ac:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801029ae:	5d                   	pop    %ebp
801029af:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801029b0:	f6 c1 40             	test   $0x40,%cl
801029b3:	74 09                	je     801029be <kbdgetc+0x5e>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801029b5:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801029b8:	83 e1 bf             	and    $0xffffffbf,%ecx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801029bb:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
801029be:	0f b6 82 60 80 10 80 	movzbl -0x7fef7fa0(%edx),%eax
801029c5:	09 c1                	or     %eax,%ecx
801029c7:	0f b6 82 60 7f 10 80 	movzbl -0x7fef80a0(%edx),%eax
801029ce:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801029d0:	89 c8                	mov    %ecx,%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
801029d2:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801029d8:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801029db:	83 e1 08             	and    $0x8,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
801029de:	8b 04 85 40 7f 10 80 	mov    -0x7fef80c0(,%eax,4),%eax
801029e5:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801029e9:	74 c3                	je     801029ae <kbdgetc+0x4e>
    if('a' <= c && c <= 'z')
801029eb:	8d 50 9f             	lea    -0x61(%eax),%edx
801029ee:	83 fa 19             	cmp    $0x19,%edx
801029f1:	77 1d                	ja     80102a10 <kbdgetc+0xb0>
      c += 'A' - 'a';
801029f3:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801029f6:	5d                   	pop    %ebp
801029f7:	c3                   	ret    
801029f8:	90                   	nop
801029f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
80102a00:	31 c0                	xor    %eax,%eax
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102a02:	83 0d b4 b5 10 80 40 	orl    $0x40,0x8010b5b4
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102a09:	5d                   	pop    %ebp
80102a0a:	c3                   	ret    
80102a0b:	90                   	nop
80102a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
80102a10:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102a13:	8d 50 20             	lea    0x20(%eax),%edx
  }
  return c;
}
80102a16:	5d                   	pop    %ebp
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
80102a17:	83 f9 19             	cmp    $0x19,%ecx
80102a1a:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
}
80102a1d:	c3                   	ret    
80102a1e:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
80102a20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102a25:	5d                   	pop    %ebp
80102a26:	c3                   	ret    
80102a27:	89 f6                	mov    %esi,%esi
80102a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a30 <kbdintr>:

void
kbdintr(void)
{
80102a30:	55                   	push   %ebp
80102a31:	89 e5                	mov    %esp,%ebp
80102a33:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102a36:	68 60 29 10 80       	push   $0x80102960
80102a3b:	e8 b0 dd ff ff       	call   801007f0 <consoleintr>
}
80102a40:	83 c4 10             	add    $0x10,%esp
80102a43:	c9                   	leave  
80102a44:	c3                   	ret    
80102a45:	66 90                	xchg   %ax,%ax
80102a47:	66 90                	xchg   %ax,%ax
80102a49:	66 90                	xchg   %ax,%ax
80102a4b:	66 90                	xchg   %ax,%ax
80102a4d:	66 90                	xchg   %ax,%ax
80102a4f:	90                   	nop

80102a50 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102a50:	a1 84 36 11 80       	mov    0x80113684,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102a55:	55                   	push   %ebp
80102a56:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102a58:	85 c0                	test   %eax,%eax
80102a5a:	0f 84 c8 00 00 00    	je     80102b28 <lapicinit+0xd8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a60:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102a67:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a6a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a6d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102a74:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a77:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a7a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102a81:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102a84:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a87:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102a8e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102a91:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a94:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102a9b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a9e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102aa1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102aa8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102aab:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102aae:	8b 50 30             	mov    0x30(%eax),%edx
80102ab1:	c1 ea 10             	shr    $0x10,%edx
80102ab4:	80 fa 03             	cmp    $0x3,%dl
80102ab7:	77 77                	ja     80102b30 <lapicinit+0xe0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102ab9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102ac0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ac3:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102ac6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102acd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ad0:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102ad3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102ada:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102add:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102ae0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102ae7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102aea:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102aed:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102af4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102af7:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102afa:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102b01:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102b04:	8b 50 20             	mov    0x20(%eax),%edx
80102b07:	89 f6                	mov    %esi,%esi
80102b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102b10:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102b16:	80 e6 10             	and    $0x10,%dh
80102b19:	75 f5                	jne    80102b10 <lapicinit+0xc0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b1b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102b22:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b25:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102b28:	5d                   	pop    %ebp
80102b29:	c3                   	ret    
80102b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b30:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102b37:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102b3a:	8b 50 20             	mov    0x20(%eax),%edx
80102b3d:	e9 77 ff ff ff       	jmp    80102ab9 <lapicinit+0x69>
80102b42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b50 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
80102b50:	a1 84 36 11 80       	mov    0x80113684,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
80102b55:	55                   	push   %ebp
80102b56:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102b58:	85 c0                	test   %eax,%eax
80102b5a:	74 0c                	je     80102b68 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
80102b5c:	8b 40 20             	mov    0x20(%eax),%eax
}
80102b5f:	5d                   	pop    %ebp
int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
80102b60:	c1 e8 18             	shr    $0x18,%eax
}
80102b63:	c3                   	ret    
80102b64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int
lapicid(void)
{
  if (!lapic)
    return 0;
80102b68:	31 c0                	xor    %eax,%eax
  return lapic[ID] >> 24;
}
80102b6a:	5d                   	pop    %ebp
80102b6b:	c3                   	ret    
80102b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b70 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102b70:	a1 84 36 11 80       	mov    0x80113684,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102b75:	55                   	push   %ebp
80102b76:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102b78:	85 c0                	test   %eax,%eax
80102b7a:	74 0d                	je     80102b89 <lapiceoi+0x19>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b7c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102b83:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b86:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102b89:	5d                   	pop    %ebp
80102b8a:	c3                   	ret    
80102b8b:	90                   	nop
80102b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b90 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102b90:	55                   	push   %ebp
80102b91:	89 e5                	mov    %esp,%ebp
}
80102b93:	5d                   	pop    %ebp
80102b94:	c3                   	ret    
80102b95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ba0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102ba0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ba1:	ba 70 00 00 00       	mov    $0x70,%edx
80102ba6:	b8 0f 00 00 00       	mov    $0xf,%eax
80102bab:	89 e5                	mov    %esp,%ebp
80102bad:	53                   	push   %ebx
80102bae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102bb1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102bb4:	ee                   	out    %al,(%dx)
80102bb5:	ba 71 00 00 00       	mov    $0x71,%edx
80102bba:	b8 0a 00 00 00       	mov    $0xa,%eax
80102bbf:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102bc0:	31 c0                	xor    %eax,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102bc2:	c1 e3 18             	shl    $0x18,%ebx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102bc5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102bcb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102bcd:	c1 e9 0c             	shr    $0xc,%ecx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102bd0:	c1 e8 04             	shr    $0x4,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102bd3:	89 da                	mov    %ebx,%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102bd5:	80 cd 06             	or     $0x6,%ch
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102bd8:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102bde:	a1 84 36 11 80       	mov    0x80113684,%eax
80102be3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102be9:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102bec:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102bf3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bf6:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102bf9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102c00:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c03:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102c06:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c0c:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102c0f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c15:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102c18:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c1e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102c21:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c27:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80102c2a:	5b                   	pop    %ebx
80102c2b:	5d                   	pop    %ebp
80102c2c:	c3                   	ret    
80102c2d:	8d 76 00             	lea    0x0(%esi),%esi

80102c30 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102c30:	55                   	push   %ebp
80102c31:	ba 70 00 00 00       	mov    $0x70,%edx
80102c36:	b8 0b 00 00 00       	mov    $0xb,%eax
80102c3b:	89 e5                	mov    %esp,%ebp
80102c3d:	57                   	push   %edi
80102c3e:	56                   	push   %esi
80102c3f:	53                   	push   %ebx
80102c40:	83 ec 4c             	sub    $0x4c,%esp
80102c43:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c44:	ba 71 00 00 00       	mov    $0x71,%edx
80102c49:	ec                   	in     (%dx),%al
80102c4a:	83 e0 04             	and    $0x4,%eax
80102c4d:	8d 75 d0             	lea    -0x30(%ebp),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c50:	31 db                	xor    %ebx,%ebx
80102c52:	88 45 b7             	mov    %al,-0x49(%ebp)
80102c55:	bf 70 00 00 00       	mov    $0x70,%edi
80102c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102c60:	89 d8                	mov    %ebx,%eax
80102c62:	89 fa                	mov    %edi,%edx
80102c64:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c65:	b9 71 00 00 00       	mov    $0x71,%ecx
80102c6a:	89 ca                	mov    %ecx,%edx
80102c6c:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
80102c6d:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c70:	89 fa                	mov    %edi,%edx
80102c72:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102c75:	b8 02 00 00 00       	mov    $0x2,%eax
80102c7a:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c7b:	89 ca                	mov    %ecx,%edx
80102c7d:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102c7e:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c81:	89 fa                	mov    %edi,%edx
80102c83:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102c86:	b8 04 00 00 00       	mov    $0x4,%eax
80102c8b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c8c:	89 ca                	mov    %ecx,%edx
80102c8e:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102c8f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c92:	89 fa                	mov    %edi,%edx
80102c94:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102c97:	b8 07 00 00 00       	mov    $0x7,%eax
80102c9c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c9d:	89 ca                	mov    %ecx,%edx
80102c9f:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102ca0:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ca3:	89 fa                	mov    %edi,%edx
80102ca5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102ca8:	b8 08 00 00 00       	mov    $0x8,%eax
80102cad:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cae:	89 ca                	mov    %ecx,%edx
80102cb0:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102cb1:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cb4:	89 fa                	mov    %edi,%edx
80102cb6:	89 45 c8             	mov    %eax,-0x38(%ebp)
80102cb9:	b8 09 00 00 00       	mov    $0x9,%eax
80102cbe:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cbf:	89 ca                	mov    %ecx,%edx
80102cc1:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102cc2:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cc5:	89 fa                	mov    %edi,%edx
80102cc7:	89 45 cc             	mov    %eax,-0x34(%ebp)
80102cca:	b8 0a 00 00 00       	mov    $0xa,%eax
80102ccf:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cd0:	89 ca                	mov    %ecx,%edx
80102cd2:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102cd3:	84 c0                	test   %al,%al
80102cd5:	78 89                	js     80102c60 <cmostime+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cd7:	89 d8                	mov    %ebx,%eax
80102cd9:	89 fa                	mov    %edi,%edx
80102cdb:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cdc:	89 ca                	mov    %ecx,%edx
80102cde:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
80102cdf:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ce2:	89 fa                	mov    %edi,%edx
80102ce4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102ce7:	b8 02 00 00 00       	mov    $0x2,%eax
80102cec:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ced:	89 ca                	mov    %ecx,%edx
80102cef:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102cf0:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cf3:	89 fa                	mov    %edi,%edx
80102cf5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102cf8:	b8 04 00 00 00       	mov    $0x4,%eax
80102cfd:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cfe:	89 ca                	mov    %ecx,%edx
80102d00:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102d01:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d04:	89 fa                	mov    %edi,%edx
80102d06:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102d09:	b8 07 00 00 00       	mov    $0x7,%eax
80102d0e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d0f:	89 ca                	mov    %ecx,%edx
80102d11:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102d12:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d15:	89 fa                	mov    %edi,%edx
80102d17:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102d1a:	b8 08 00 00 00       	mov    $0x8,%eax
80102d1f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d20:	89 ca                	mov    %ecx,%edx
80102d22:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102d23:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d26:	89 fa                	mov    %edi,%edx
80102d28:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102d2b:	b8 09 00 00 00       	mov    $0x9,%eax
80102d30:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d31:	89 ca                	mov    %ecx,%edx
80102d33:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102d34:	0f b6 c0             	movzbl %al,%eax
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102d37:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
80102d3a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102d3d:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102d40:	6a 18                	push   $0x18
80102d42:	56                   	push   %esi
80102d43:	50                   	push   %eax
80102d44:	e8 e7 1e 00 00       	call   80104c30 <memcmp>
80102d49:	83 c4 10             	add    $0x10,%esp
80102d4c:	85 c0                	test   %eax,%eax
80102d4e:	0f 85 0c ff ff ff    	jne    80102c60 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102d54:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102d58:	75 78                	jne    80102dd2 <cmostime+0x1a2>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102d5a:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d5d:	89 c2                	mov    %eax,%edx
80102d5f:	83 e0 0f             	and    $0xf,%eax
80102d62:	c1 ea 04             	shr    $0x4,%edx
80102d65:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d68:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d6b:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102d6e:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d71:	89 c2                	mov    %eax,%edx
80102d73:	83 e0 0f             	and    $0xf,%eax
80102d76:	c1 ea 04             	shr    $0x4,%edx
80102d79:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d7c:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d7f:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102d82:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d85:	89 c2                	mov    %eax,%edx
80102d87:	83 e0 0f             	and    $0xf,%eax
80102d8a:	c1 ea 04             	shr    $0x4,%edx
80102d8d:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d90:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d93:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102d96:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d99:	89 c2                	mov    %eax,%edx
80102d9b:	83 e0 0f             	and    $0xf,%eax
80102d9e:	c1 ea 04             	shr    $0x4,%edx
80102da1:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102da4:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102da7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102daa:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102dad:	89 c2                	mov    %eax,%edx
80102daf:	83 e0 0f             	and    $0xf,%eax
80102db2:	c1 ea 04             	shr    $0x4,%edx
80102db5:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102db8:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102dbb:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102dbe:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102dc1:	89 c2                	mov    %eax,%edx
80102dc3:	83 e0 0f             	and    $0xf,%eax
80102dc6:	c1 ea 04             	shr    $0x4,%edx
80102dc9:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102dcc:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102dcf:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102dd2:	8b 75 08             	mov    0x8(%ebp),%esi
80102dd5:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102dd8:	89 06                	mov    %eax,(%esi)
80102dda:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ddd:	89 46 04             	mov    %eax,0x4(%esi)
80102de0:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102de3:	89 46 08             	mov    %eax,0x8(%esi)
80102de6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102de9:	89 46 0c             	mov    %eax,0xc(%esi)
80102dec:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102def:	89 46 10             	mov    %eax,0x10(%esi)
80102df2:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102df5:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102df8:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102dff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e02:	5b                   	pop    %ebx
80102e03:	5e                   	pop    %esi
80102e04:	5f                   	pop    %edi
80102e05:	5d                   	pop    %ebp
80102e06:	c3                   	ret    
80102e07:	66 90                	xchg   %ax,%ax
80102e09:	66 90                	xchg   %ax,%ax
80102e0b:	66 90                	xchg   %ax,%ax
80102e0d:	66 90                	xchg   %ax,%ax
80102e0f:	90                   	nop

80102e10 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102e10:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80102e16:	85 c9                	test   %ecx,%ecx
80102e18:	0f 8e 85 00 00 00    	jle    80102ea3 <install_trans+0x93>
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102e1e:	55                   	push   %ebp
80102e1f:	89 e5                	mov    %esp,%ebp
80102e21:	57                   	push   %edi
80102e22:	56                   	push   %esi
80102e23:	53                   	push   %ebx
80102e24:	31 db                	xor    %ebx,%ebx
80102e26:	83 ec 0c             	sub    $0xc,%esp
80102e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102e30:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102e35:	83 ec 08             	sub    $0x8,%esp
80102e38:	01 d8                	add    %ebx,%eax
80102e3a:	83 c0 01             	add    $0x1,%eax
80102e3d:	50                   	push   %eax
80102e3e:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102e44:	e8 87 d2 ff ff       	call   801000d0 <bread>
80102e49:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102e4b:	58                   	pop    %eax
80102e4c:	5a                   	pop    %edx
80102e4d:	ff 34 9d ec 36 11 80 	pushl  -0x7feec914(,%ebx,4)
80102e54:	ff 35 e4 36 11 80    	pushl  0x801136e4
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102e5a:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102e5d:	e8 6e d2 ff ff       	call   801000d0 <bread>
80102e62:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102e64:	8d 47 5c             	lea    0x5c(%edi),%eax
80102e67:	83 c4 0c             	add    $0xc,%esp
80102e6a:	68 00 02 00 00       	push   $0x200
80102e6f:	50                   	push   %eax
80102e70:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e73:	50                   	push   %eax
80102e74:	e8 17 1e 00 00       	call   80104c90 <memmove>
    bwrite(dbuf);  // write dst to disk
80102e79:	89 34 24             	mov    %esi,(%esp)
80102e7c:	e8 1f d3 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102e81:	89 3c 24             	mov    %edi,(%esp)
80102e84:	e8 57 d3 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102e89:	89 34 24             	mov    %esi,(%esp)
80102e8c:	e8 4f d3 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102e91:	83 c4 10             	add    $0x10,%esp
80102e94:	39 1d e8 36 11 80    	cmp    %ebx,0x801136e8
80102e9a:	7f 94                	jg     80102e30 <install_trans+0x20>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102e9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e9f:	5b                   	pop    %ebx
80102ea0:	5e                   	pop    %esi
80102ea1:	5f                   	pop    %edi
80102ea2:	5d                   	pop    %ebp
80102ea3:	f3 c3                	repz ret 
80102ea5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102eb0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102eb0:	55                   	push   %ebp
80102eb1:	89 e5                	mov    %esp,%ebp
80102eb3:	53                   	push   %ebx
80102eb4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102eb7:	ff 35 d4 36 11 80    	pushl  0x801136d4
80102ebd:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102ec3:	e8 08 d2 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102ec8:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102ece:	83 c4 10             	add    $0x10,%esp
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102ed1:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102ed3:	85 c9                	test   %ecx,%ecx
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102ed5:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102ed8:	7e 1f                	jle    80102ef9 <write_head+0x49>
80102eda:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
80102ee1:	31 d2                	xor    %edx,%edx
80102ee3:	90                   	nop
80102ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102ee8:	8b 8a ec 36 11 80    	mov    -0x7feec914(%edx),%ecx
80102eee:	89 4c 13 60          	mov    %ecx,0x60(%ebx,%edx,1)
80102ef2:	83 c2 04             	add    $0x4,%edx
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102ef5:	39 c2                	cmp    %eax,%edx
80102ef7:	75 ef                	jne    80102ee8 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102ef9:	83 ec 0c             	sub    $0xc,%esp
80102efc:	53                   	push   %ebx
80102efd:	e8 9e d2 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102f02:	89 1c 24             	mov    %ebx,(%esp)
80102f05:	e8 d6 d2 ff ff       	call   801001e0 <brelse>
}
80102f0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f0d:	c9                   	leave  
80102f0e:	c3                   	ret    
80102f0f:	90                   	nop

80102f10 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102f10:	55                   	push   %ebp
80102f11:	89 e5                	mov    %esp,%ebp
80102f13:	53                   	push   %ebx
80102f14:	83 ec 2c             	sub    $0x2c,%esp
80102f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102f1a:	68 60 81 10 80       	push   $0x80108160
80102f1f:	68 a0 36 11 80       	push   $0x801136a0
80102f24:	e8 27 1a 00 00       	call   80104950 <initlock>
  readsb(dev, &sb);
80102f29:	58                   	pop    %eax
80102f2a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102f2d:	5a                   	pop    %edx
80102f2e:	50                   	push   %eax
80102f2f:	53                   	push   %ebx
80102f30:	e8 fb e4 ff ff       	call   80101430 <readsb>
  log.start = sb.logstart;
  log.size = sb.nlog;
80102f35:	8b 55 e8             	mov    -0x18(%ebp),%edx
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102f38:	8b 45 ec             	mov    -0x14(%ebp),%eax

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102f3b:	59                   	pop    %ecx
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102f3c:	89 1d e4 36 11 80    	mov    %ebx,0x801136e4

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102f42:	89 15 d8 36 11 80    	mov    %edx,0x801136d8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102f48:	a3 d4 36 11 80       	mov    %eax,0x801136d4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102f4d:	5a                   	pop    %edx
80102f4e:	50                   	push   %eax
80102f4f:	53                   	push   %ebx
80102f50:	e8 7b d1 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102f55:	8b 48 5c             	mov    0x5c(%eax),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f58:	83 c4 10             	add    $0x10,%esp
80102f5b:	85 c9                	test   %ecx,%ecx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102f5d:	89 0d e8 36 11 80    	mov    %ecx,0x801136e8
  for (i = 0; i < log.lh.n; i++) {
80102f63:	7e 1c                	jle    80102f81 <initlog+0x71>
80102f65:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
80102f6c:	31 d2                	xor    %edx,%edx
80102f6e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102f70:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102f74:	83 c2 04             	add    $0x4,%edx
80102f77:	89 8a e8 36 11 80    	mov    %ecx,-0x7feec918(%edx)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102f7d:	39 da                	cmp    %ebx,%edx
80102f7f:	75 ef                	jne    80102f70 <initlog+0x60>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102f81:	83 ec 0c             	sub    $0xc,%esp
80102f84:	50                   	push   %eax
80102f85:	e8 56 d2 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102f8a:	e8 81 fe ff ff       	call   80102e10 <install_trans>
  log.lh.n = 0;
80102f8f:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
80102f96:	00 00 00 
  write_head(); // clear the log
80102f99:	e8 12 ff ff ff       	call   80102eb0 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102f9e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102fa1:	c9                   	leave  
80102fa2:	c3                   	ret    
80102fa3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102fb0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102fb0:	55                   	push   %ebp
80102fb1:	89 e5                	mov    %esp,%ebp
80102fb3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102fb6:	68 a0 36 11 80       	push   $0x801136a0
80102fbb:	e8 90 1a 00 00       	call   80104a50 <acquire>
80102fc0:	83 c4 10             	add    $0x10,%esp
80102fc3:	eb 18                	jmp    80102fdd <begin_op+0x2d>
80102fc5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102fc8:	83 ec 08             	sub    $0x8,%esp
80102fcb:	68 a0 36 11 80       	push   $0x801136a0
80102fd0:	68 a0 36 11 80       	push   $0x801136a0
80102fd5:	e8 c6 13 00 00       	call   801043a0 <sleep>
80102fda:	83 c4 10             	add    $0x10,%esp
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102fdd:	a1 e0 36 11 80       	mov    0x801136e0,%eax
80102fe2:	85 c0                	test   %eax,%eax
80102fe4:	75 e2                	jne    80102fc8 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102fe6:	a1 dc 36 11 80       	mov    0x801136dc,%eax
80102feb:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
80102ff1:	83 c0 01             	add    $0x1,%eax
80102ff4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102ff7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102ffa:	83 fa 1e             	cmp    $0x1e,%edx
80102ffd:	7f c9                	jg     80102fc8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102fff:	83 ec 0c             	sub    $0xc,%esp
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80103002:	a3 dc 36 11 80       	mov    %eax,0x801136dc
      release(&log.lock);
80103007:	68 a0 36 11 80       	push   $0x801136a0
8010300c:	e8 7f 1b 00 00       	call   80104b90 <release>
      break;
    }
  }
}
80103011:	83 c4 10             	add    $0x10,%esp
80103014:	c9                   	leave  
80103015:	c3                   	ret    
80103016:	8d 76 00             	lea    0x0(%esi),%esi
80103019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103020 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103020:	55                   	push   %ebp
80103021:	89 e5                	mov    %esp,%ebp
80103023:	57                   	push   %edi
80103024:	56                   	push   %esi
80103025:	53                   	push   %ebx
80103026:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103029:	68 a0 36 11 80       	push   $0x801136a0
8010302e:	e8 1d 1a 00 00       	call   80104a50 <acquire>
  log.outstanding -= 1;
80103033:	a1 dc 36 11 80       	mov    0x801136dc,%eax
  if(log.committing)
80103038:	8b 1d e0 36 11 80    	mov    0x801136e0,%ebx
8010303e:	83 c4 10             	add    $0x10,%esp
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80103041:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80103044:	85 db                	test   %ebx,%ebx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80103046:	a3 dc 36 11 80       	mov    %eax,0x801136dc
  if(log.committing)
8010304b:	0f 85 23 01 00 00    	jne    80103174 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103051:	85 c0                	test   %eax,%eax
80103053:	0f 85 f7 00 00 00    	jne    80103150 <end_op+0x130>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103059:	83 ec 0c             	sub    $0xc,%esp
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
8010305c:	c7 05 e0 36 11 80 01 	movl   $0x1,0x801136e0
80103063:	00 00 00 
}

static void
commit()
{
  if (log.lh.n > 0) {
80103066:	31 db                	xor    %ebx,%ebx
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103068:	68 a0 36 11 80       	push   $0x801136a0
8010306d:	e8 1e 1b 00 00       	call   80104b90 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103072:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80103078:	83 c4 10             	add    $0x10,%esp
8010307b:	85 c9                	test   %ecx,%ecx
8010307d:	0f 8e 8a 00 00 00    	jle    8010310d <end_op+0xed>
80103083:	90                   	nop
80103084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103088:	a1 d4 36 11 80       	mov    0x801136d4,%eax
8010308d:	83 ec 08             	sub    $0x8,%esp
80103090:	01 d8                	add    %ebx,%eax
80103092:	83 c0 01             	add    $0x1,%eax
80103095:	50                   	push   %eax
80103096:	ff 35 e4 36 11 80    	pushl  0x801136e4
8010309c:	e8 2f d0 ff ff       	call   801000d0 <bread>
801030a1:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801030a3:	58                   	pop    %eax
801030a4:	5a                   	pop    %edx
801030a5:	ff 34 9d ec 36 11 80 	pushl  -0x7feec914(,%ebx,4)
801030ac:	ff 35 e4 36 11 80    	pushl  0x801136e4
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801030b2:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801030b5:	e8 16 d0 ff ff       	call   801000d0 <bread>
801030ba:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801030bc:	8d 40 5c             	lea    0x5c(%eax),%eax
801030bf:	83 c4 0c             	add    $0xc,%esp
801030c2:	68 00 02 00 00       	push   $0x200
801030c7:	50                   	push   %eax
801030c8:	8d 46 5c             	lea    0x5c(%esi),%eax
801030cb:	50                   	push   %eax
801030cc:	e8 bf 1b 00 00       	call   80104c90 <memmove>
    bwrite(to);  // write the log
801030d1:	89 34 24             	mov    %esi,(%esp)
801030d4:	e8 c7 d0 ff ff       	call   801001a0 <bwrite>
    brelse(from);
801030d9:	89 3c 24             	mov    %edi,(%esp)
801030dc:	e8 ff d0 ff ff       	call   801001e0 <brelse>
    brelse(to);
801030e1:	89 34 24             	mov    %esi,(%esp)
801030e4:	e8 f7 d0 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801030e9:	83 c4 10             	add    $0x10,%esp
801030ec:	3b 1d e8 36 11 80    	cmp    0x801136e8,%ebx
801030f2:	7c 94                	jl     80103088 <end_op+0x68>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801030f4:	e8 b7 fd ff ff       	call   80102eb0 <write_head>
    install_trans(); // Now install writes to home locations
801030f9:	e8 12 fd ff ff       	call   80102e10 <install_trans>
    log.lh.n = 0;
801030fe:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
80103105:	00 00 00 
    write_head();    // Erase the transaction from the log
80103108:	e8 a3 fd ff ff       	call   80102eb0 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
8010310d:	83 ec 0c             	sub    $0xc,%esp
80103110:	68 a0 36 11 80       	push   $0x801136a0
80103115:	e8 36 19 00 00       	call   80104a50 <acquire>
    log.committing = 0;
    wakeup(&log);
8010311a:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
    log.committing = 0;
80103121:	c7 05 e0 36 11 80 00 	movl   $0x0,0x801136e0
80103128:	00 00 00 
    wakeup(&log);
8010312b:	e8 50 14 00 00       	call   80104580 <wakeup>
    release(&log.lock);
80103130:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80103137:	e8 54 1a 00 00       	call   80104b90 <release>
8010313c:	83 c4 10             	add    $0x10,%esp
  }
}
8010313f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103142:	5b                   	pop    %ebx
80103143:	5e                   	pop    %esi
80103144:	5f                   	pop    %edi
80103145:	5d                   	pop    %ebp
80103146:	c3                   	ret    
80103147:	89 f6                	mov    %esi,%esi
80103149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
80103150:	83 ec 0c             	sub    $0xc,%esp
80103153:	68 a0 36 11 80       	push   $0x801136a0
80103158:	e8 23 14 00 00       	call   80104580 <wakeup>
  }
  release(&log.lock);
8010315d:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80103164:	e8 27 1a 00 00       	call   80104b90 <release>
80103169:	83 c4 10             	add    $0x10,%esp
    acquire(&log.lock);
    log.committing = 0;
    wakeup(&log);
    release(&log.lock);
  }
}
8010316c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010316f:	5b                   	pop    %ebx
80103170:	5e                   	pop    %esi
80103171:	5f                   	pop    %edi
80103172:	5d                   	pop    %ebp
80103173:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80103174:	83 ec 0c             	sub    $0xc,%esp
80103177:	68 64 81 10 80       	push   $0x80108164
8010317c:	e8 ef d1 ff ff       	call   80100370 <panic>
80103181:	eb 0d                	jmp    80103190 <log_write>
80103183:	90                   	nop
80103184:	90                   	nop
80103185:	90                   	nop
80103186:	90                   	nop
80103187:	90                   	nop
80103188:	90                   	nop
80103189:	90                   	nop
8010318a:	90                   	nop
8010318b:	90                   	nop
8010318c:	90                   	nop
8010318d:	90                   	nop
8010318e:	90                   	nop
8010318f:	90                   	nop

80103190 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103190:	55                   	push   %ebp
80103191:	89 e5                	mov    %esp,%ebp
80103193:	53                   	push   %ebx
80103194:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103197:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
8010319d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801031a0:	83 fa 1d             	cmp    $0x1d,%edx
801031a3:	0f 8f 97 00 00 00    	jg     80103240 <log_write+0xb0>
801031a9:	a1 d8 36 11 80       	mov    0x801136d8,%eax
801031ae:	83 e8 01             	sub    $0x1,%eax
801031b1:	39 c2                	cmp    %eax,%edx
801031b3:	0f 8d 87 00 00 00    	jge    80103240 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
801031b9:	a1 dc 36 11 80       	mov    0x801136dc,%eax
801031be:	85 c0                	test   %eax,%eax
801031c0:	0f 8e 87 00 00 00    	jle    8010324d <log_write+0xbd>
    panic("log_write outside of trans");

  acquire(&log.lock);
801031c6:	83 ec 0c             	sub    $0xc,%esp
801031c9:	68 a0 36 11 80       	push   $0x801136a0
801031ce:	e8 7d 18 00 00       	call   80104a50 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801031d3:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
801031d9:	83 c4 10             	add    $0x10,%esp
801031dc:	83 fa 00             	cmp    $0x0,%edx
801031df:	7e 50                	jle    80103231 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801031e1:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
801031e4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801031e6:	3b 0d ec 36 11 80    	cmp    0x801136ec,%ecx
801031ec:	75 0b                	jne    801031f9 <log_write+0x69>
801031ee:	eb 38                	jmp    80103228 <log_write+0x98>
801031f0:	39 0c 85 ec 36 11 80 	cmp    %ecx,-0x7feec914(,%eax,4)
801031f7:	74 2f                	je     80103228 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
801031f9:	83 c0 01             	add    $0x1,%eax
801031fc:	39 d0                	cmp    %edx,%eax
801031fe:	75 f0                	jne    801031f0 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80103200:	89 0c 95 ec 36 11 80 	mov    %ecx,-0x7feec914(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80103207:	83 c2 01             	add    $0x1,%edx
8010320a:	89 15 e8 36 11 80    	mov    %edx,0x801136e8
  b->flags |= B_DIRTY; // prevent eviction
80103210:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80103213:	c7 45 08 a0 36 11 80 	movl   $0x801136a0,0x8(%ebp)
}
8010321a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010321d:	c9                   	leave  
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
8010321e:	e9 6d 19 00 00       	jmp    80104b90 <release>
80103223:	90                   	nop
80103224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80103228:	89 0c 85 ec 36 11 80 	mov    %ecx,-0x7feec914(,%eax,4)
8010322f:	eb df                	jmp    80103210 <log_write+0x80>
80103231:	8b 43 08             	mov    0x8(%ebx),%eax
80103234:	a3 ec 36 11 80       	mov    %eax,0x801136ec
  if (i == log.lh.n)
80103239:	75 d5                	jne    80103210 <log_write+0x80>
8010323b:	eb ca                	jmp    80103207 <log_write+0x77>
8010323d:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80103240:	83 ec 0c             	sub    $0xc,%esp
80103243:	68 73 81 10 80       	push   $0x80108173
80103248:	e8 23 d1 ff ff       	call   80100370 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
8010324d:	83 ec 0c             	sub    $0xc,%esp
80103250:	68 89 81 10 80       	push   $0x80108189
80103255:	e8 16 d1 ff ff       	call   80100370 <panic>
8010325a:	66 90                	xchg   %ax,%ax
8010325c:	66 90                	xchg   %ax,%ax
8010325e:	66 90                	xchg   %ax,%ax

80103260 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103260:	55                   	push   %ebp
80103261:	89 e5                	mov    %esp,%ebp
80103263:	53                   	push   %ebx
80103264:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103267:	e8 d4 09 00 00       	call   80103c40 <cpuid>
8010326c:	89 c3                	mov    %eax,%ebx
8010326e:	e8 cd 09 00 00       	call   80103c40 <cpuid>
80103273:	83 ec 04             	sub    $0x4,%esp
80103276:	53                   	push   %ebx
80103277:	50                   	push   %eax
80103278:	68 a4 81 10 80       	push   $0x801081a4
8010327d:	e8 de d3 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80103282:	e8 89 2c 00 00       	call   80105f10 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103287:	e8 34 09 00 00       	call   80103bc0 <mycpu>
8010328c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010328e:	b8 01 00 00 00       	mov    $0x1,%eax
80103293:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010329a:	e8 01 0e 00 00       	call   801040a0 <scheduler>
8010329f:	90                   	nop

801032a0 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801032a0:	55                   	push   %ebp
801032a1:	89 e5                	mov    %esp,%ebp
801032a3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801032a6:	e8 45 3f 00 00       	call   801071f0 <switchkvm>
  seginit();
801032ab:	e8 00 3e 00 00       	call   801070b0 <seginit>
  lapicinit();
801032b0:	e8 9b f7 ff ff       	call   80102a50 <lapicinit>
  mpmain();
801032b5:	e8 a6 ff ff ff       	call   80103260 <mpmain>
801032ba:	66 90                	xchg   %ax,%ax
801032bc:	66 90                	xchg   %ax,%ax
801032be:	66 90                	xchg   %ax,%ax

801032c0 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
801032c0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801032c4:	83 e4 f0             	and    $0xfffffff0,%esp
801032c7:	ff 71 fc             	pushl  -0x4(%ecx)
801032ca:	55                   	push   %ebp
801032cb:	89 e5                	mov    %esp,%ebp
801032cd:	53                   	push   %ebx
801032ce:	51                   	push   %ecx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
801032cf:	bb a0 37 11 80       	mov    $0x801137a0,%ebx
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801032d4:	83 ec 08             	sub    $0x8,%esp
801032d7:	68 00 00 40 80       	push   $0x80400000
801032dc:	68 c8 da 11 80       	push   $0x8011dac8
801032e1:	e8 1a f5 ff ff       	call   80102800 <kinit1>
  kvmalloc();      // kernel page table
801032e6:	e8 a5 42 00 00       	call   80107590 <kvmalloc>
  mpinit();        // detect other processors
801032eb:	e8 70 01 00 00       	call   80103460 <mpinit>
  lapicinit();     // interrupt controller
801032f0:	e8 5b f7 ff ff       	call   80102a50 <lapicinit>
  seginit();       // segment descriptors
801032f5:	e8 b6 3d 00 00       	call   801070b0 <seginit>
  picinit();       // disable pic
801032fa:	e8 31 03 00 00       	call   80103630 <picinit>
  ioapicinit();    // another interrupt controller
801032ff:	e8 0c f3 ff ff       	call   80102610 <ioapicinit>
  consoleinit();   // console hardware
80103304:	e8 97 d6 ff ff       	call   801009a0 <consoleinit>
  uartinit();      // serial port
80103309:	e8 92 2f 00 00       	call   801062a0 <uartinit>
  pinit();         // process table
8010330e:	e8 8d 08 00 00       	call   80103ba0 <pinit>
  tvinit();        // trap vectors
80103313:	e8 58 2b 00 00       	call   80105e70 <tvinit>
  binit();         // buffer cache
80103318:	e8 23 cd ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010331d:	e8 ae da ff ff       	call   80100dd0 <fileinit>
  ideinit();       // disk 
80103322:	e8 c9 f0 ff ff       	call   801023f0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103327:	83 c4 0c             	add    $0xc,%esp
8010332a:	68 8a 00 00 00       	push   $0x8a
8010332f:	68 8c b4 10 80       	push   $0x8010b48c
80103334:	68 00 70 00 80       	push   $0x80007000
80103339:	e8 52 19 00 00       	call   80104c90 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010333e:	69 05 20 3d 11 80 b0 	imul   $0xb0,0x80113d20,%eax
80103345:	00 00 00 
80103348:	83 c4 10             	add    $0x10,%esp
8010334b:	05 a0 37 11 80       	add    $0x801137a0,%eax
80103350:	39 d8                	cmp    %ebx,%eax
80103352:	76 6f                	jbe    801033c3 <main+0x103>
80103354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80103358:	e8 63 08 00 00       	call   80103bc0 <mycpu>
8010335d:	39 d8                	cmp    %ebx,%eax
8010335f:	74 49                	je     801033aa <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103361:	e8 8a f5 ff ff       	call   801028f0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80103366:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
8010336b:	c7 05 f8 6f 00 80 a0 	movl   $0x801032a0,0x80006ff8
80103372:	32 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103375:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010337c:	a0 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
8010337f:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103384:	0f b6 03             	movzbl (%ebx),%eax
80103387:	83 ec 08             	sub    $0x8,%esp
8010338a:	68 00 70 00 00       	push   $0x7000
8010338f:	50                   	push   %eax
80103390:	e8 0b f8 ff ff       	call   80102ba0 <lapicstartap>
80103395:	83 c4 10             	add    $0x10,%esp
80103398:	90                   	nop
80103399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801033a0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801033a6:	85 c0                	test   %eax,%eax
801033a8:	74 f6                	je     801033a0 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
801033aa:	69 05 20 3d 11 80 b0 	imul   $0xb0,0x80113d20,%eax
801033b1:	00 00 00 
801033b4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801033ba:	05 a0 37 11 80       	add    $0x801137a0,%eax
801033bf:	39 c3                	cmp    %eax,%ebx
801033c1:	72 95                	jb     80103358 <main+0x98>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801033c3:	83 ec 08             	sub    $0x8,%esp
801033c6:	68 00 00 00 8e       	push   $0x8e000000
801033cb:	68 00 00 40 80       	push   $0x80400000
801033d0:	e8 bb f4 ff ff       	call   80102890 <kinit2>
  userinit();      // first user process
801033d5:	e8 b6 08 00 00       	call   80103c90 <userinit>
  mpmain();        // finish this processor's setup
801033da:	e8 81 fe ff ff       	call   80103260 <mpmain>
801033df:	90                   	nop

801033e0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801033e0:	55                   	push   %ebp
801033e1:	89 e5                	mov    %esp,%ebp
801033e3:	57                   	push   %edi
801033e4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801033e5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801033eb:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
801033ec:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801033ef:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
801033f2:	39 de                	cmp    %ebx,%esi
801033f4:	73 48                	jae    8010343e <mpsearch1+0x5e>
801033f6:	8d 76 00             	lea    0x0(%esi),%esi
801033f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103400:	83 ec 04             	sub    $0x4,%esp
80103403:	8d 7e 10             	lea    0x10(%esi),%edi
80103406:	6a 04                	push   $0x4
80103408:	68 b8 81 10 80       	push   $0x801081b8
8010340d:	56                   	push   %esi
8010340e:	e8 1d 18 00 00       	call   80104c30 <memcmp>
80103413:	83 c4 10             	add    $0x10,%esp
80103416:	85 c0                	test   %eax,%eax
80103418:	75 1e                	jne    80103438 <mpsearch1+0x58>
8010341a:	8d 7e 10             	lea    0x10(%esi),%edi
8010341d:	89 f2                	mov    %esi,%edx
8010341f:	31 c9                	xor    %ecx,%ecx
80103421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80103428:	0f b6 02             	movzbl (%edx),%eax
8010342b:	83 c2 01             	add    $0x1,%edx
8010342e:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103430:	39 fa                	cmp    %edi,%edx
80103432:	75 f4                	jne    80103428 <mpsearch1+0x48>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103434:	84 c9                	test   %cl,%cl
80103436:	74 10                	je     80103448 <mpsearch1+0x68>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103438:	39 fb                	cmp    %edi,%ebx
8010343a:	89 fe                	mov    %edi,%esi
8010343c:	77 c2                	ja     80103400 <mpsearch1+0x20>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
8010343e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103441:	31 c0                	xor    %eax,%eax
}
80103443:	5b                   	pop    %ebx
80103444:	5e                   	pop    %esi
80103445:	5f                   	pop    %edi
80103446:	5d                   	pop    %ebp
80103447:	c3                   	ret    
80103448:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010344b:	89 f0                	mov    %esi,%eax
8010344d:	5b                   	pop    %ebx
8010344e:	5e                   	pop    %esi
8010344f:	5f                   	pop    %edi
80103450:	5d                   	pop    %ebp
80103451:	c3                   	ret    
80103452:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103460 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103460:	55                   	push   %ebp
80103461:	89 e5                	mov    %esp,%ebp
80103463:	57                   	push   %edi
80103464:	56                   	push   %esi
80103465:	53                   	push   %ebx
80103466:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103469:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103470:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103477:	c1 e0 08             	shl    $0x8,%eax
8010347a:	09 d0                	or     %edx,%eax
8010347c:	c1 e0 04             	shl    $0x4,%eax
8010347f:	85 c0                	test   %eax,%eax
80103481:	75 1b                	jne    8010349e <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
80103483:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010348a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103491:	c1 e0 08             	shl    $0x8,%eax
80103494:	09 d0                	or     %edx,%eax
80103496:	c1 e0 0a             	shl    $0xa,%eax
80103499:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
8010349e:	ba 00 04 00 00       	mov    $0x400,%edx
801034a3:	e8 38 ff ff ff       	call   801033e0 <mpsearch1>
801034a8:	85 c0                	test   %eax,%eax
801034aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801034ad:	0f 84 37 01 00 00    	je     801035ea <mpinit+0x18a>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801034b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801034b6:	8b 58 04             	mov    0x4(%eax),%ebx
801034b9:	85 db                	test   %ebx,%ebx
801034bb:	0f 84 43 01 00 00    	je     80103604 <mpinit+0x1a4>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801034c1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801034c7:	83 ec 04             	sub    $0x4,%esp
801034ca:	6a 04                	push   $0x4
801034cc:	68 bd 81 10 80       	push   $0x801081bd
801034d1:	56                   	push   %esi
801034d2:	e8 59 17 00 00       	call   80104c30 <memcmp>
801034d7:	83 c4 10             	add    $0x10,%esp
801034da:	85 c0                	test   %eax,%eax
801034dc:	0f 85 22 01 00 00    	jne    80103604 <mpinit+0x1a4>
    return 0;
  if(conf->version != 1 && conf->version != 4)
801034e2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801034e9:	3c 01                	cmp    $0x1,%al
801034eb:	74 08                	je     801034f5 <mpinit+0x95>
801034ed:	3c 04                	cmp    $0x4,%al
801034ef:	0f 85 0f 01 00 00    	jne    80103604 <mpinit+0x1a4>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
801034f5:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801034fc:	85 ff                	test   %edi,%edi
801034fe:	74 21                	je     80103521 <mpinit+0xc1>
80103500:	31 d2                	xor    %edx,%edx
80103502:	31 c0                	xor    %eax,%eax
80103504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103508:	0f b6 8c 03 00 00 00 	movzbl -0x80000000(%ebx,%eax,1),%ecx
8010350f:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103510:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103513:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103515:	39 c7                	cmp    %eax,%edi
80103517:	75 ef                	jne    80103508 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103519:	84 d2                	test   %dl,%dl
8010351b:	0f 85 e3 00 00 00    	jne    80103604 <mpinit+0x1a4>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103521:	85 f6                	test   %esi,%esi
80103523:	0f 84 db 00 00 00    	je     80103604 <mpinit+0x1a4>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103529:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010352f:	a3 84 36 11 80       	mov    %eax,0x80113684
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103534:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
8010353b:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
80103541:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103546:	01 d6                	add    %edx,%esi
80103548:	90                   	nop
80103549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103550:	39 c6                	cmp    %eax,%esi
80103552:	76 23                	jbe    80103577 <mpinit+0x117>
80103554:	0f b6 10             	movzbl (%eax),%edx
    switch(*p){
80103557:	80 fa 04             	cmp    $0x4,%dl
8010355a:	0f 87 c0 00 00 00    	ja     80103620 <mpinit+0x1c0>
80103560:	ff 24 95 fc 81 10 80 	jmp    *-0x7fef7e04(,%edx,4)
80103567:	89 f6                	mov    %esi,%esi
80103569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103570:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103573:	39 c6                	cmp    %eax,%esi
80103575:	77 dd                	ja     80103554 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103577:	85 db                	test   %ebx,%ebx
80103579:	0f 84 92 00 00 00    	je     80103611 <mpinit+0x1b1>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010357f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103582:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103586:	74 15                	je     8010359d <mpinit+0x13d>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103588:	ba 22 00 00 00       	mov    $0x22,%edx
8010358d:	b8 70 00 00 00       	mov    $0x70,%eax
80103592:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103593:	ba 23 00 00 00       	mov    $0x23,%edx
80103598:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103599:	83 c8 01             	or     $0x1,%eax
8010359c:	ee                   	out    %al,(%dx)
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
8010359d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035a0:	5b                   	pop    %ebx
801035a1:	5e                   	pop    %esi
801035a2:	5f                   	pop    %edi
801035a3:	5d                   	pop    %ebp
801035a4:	c3                   	ret    
801035a5:	8d 76 00             	lea    0x0(%esi),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
801035a8:	8b 0d 20 3d 11 80    	mov    0x80113d20,%ecx
801035ae:	83 f9 07             	cmp    $0x7,%ecx
801035b1:	7f 19                	jg     801035cc <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801035b3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801035b7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801035bd:	83 c1 01             	add    $0x1,%ecx
801035c0:	89 0d 20 3d 11 80    	mov    %ecx,0x80113d20
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801035c6:	88 97 a0 37 11 80    	mov    %dl,-0x7feec860(%edi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
801035cc:	83 c0 14             	add    $0x14,%eax
      continue;
801035cf:	e9 7c ff ff ff       	jmp    80103550 <mpinit+0xf0>
801035d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
801035d8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801035dc:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
801035df:	88 15 80 37 11 80    	mov    %dl,0x80113780
      p += sizeof(struct mpioapic);
      continue;
801035e5:	e9 66 ff ff ff       	jmp    80103550 <mpinit+0xf0>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
801035ea:	ba 00 00 01 00       	mov    $0x10000,%edx
801035ef:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801035f4:	e8 e7 fd ff ff       	call   801033e0 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801035f9:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
801035fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801035fe:	0f 85 af fe ff ff    	jne    801034b3 <mpinit+0x53>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
80103604:	83 ec 0c             	sub    $0xc,%esp
80103607:	68 c2 81 10 80       	push   $0x801081c2
8010360c:	e8 5f cd ff ff       	call   80100370 <panic>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
80103611:	83 ec 0c             	sub    $0xc,%esp
80103614:	68 dc 81 10 80       	push   $0x801081dc
80103619:	e8 52 cd ff ff       	call   80100370 <panic>
8010361e:	66 90                	xchg   %ax,%ax
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
80103620:	31 db                	xor    %ebx,%ebx
80103622:	e9 30 ff ff ff       	jmp    80103557 <mpinit+0xf7>
80103627:	66 90                	xchg   %ax,%ax
80103629:	66 90                	xchg   %ax,%ax
8010362b:	66 90                	xchg   %ax,%ax
8010362d:	66 90                	xchg   %ax,%ax
8010362f:	90                   	nop

80103630 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103630:	55                   	push   %ebp
80103631:	ba 21 00 00 00       	mov    $0x21,%edx
80103636:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010363b:	89 e5                	mov    %esp,%ebp
8010363d:	ee                   	out    %al,(%dx)
8010363e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103643:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103644:	5d                   	pop    %ebp
80103645:	c3                   	ret    
80103646:	66 90                	xchg   %ax,%ax
80103648:	66 90                	xchg   %ax,%ax
8010364a:	66 90                	xchg   %ax,%ax
8010364c:	66 90                	xchg   %ax,%ax
8010364e:	66 90                	xchg   %ax,%ax

80103650 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103650:	55                   	push   %ebp
80103651:	89 e5                	mov    %esp,%ebp
80103653:	57                   	push   %edi
80103654:	56                   	push   %esi
80103655:	53                   	push   %ebx
80103656:	83 ec 0c             	sub    $0xc,%esp
80103659:	8b 75 08             	mov    0x8(%ebp),%esi
8010365c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010365f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103665:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010366b:	e8 80 d7 ff ff       	call   80100df0 <filealloc>
80103670:	85 c0                	test   %eax,%eax
80103672:	89 06                	mov    %eax,(%esi)
80103674:	0f 84 a8 00 00 00    	je     80103722 <pipealloc+0xd2>
8010367a:	e8 71 d7 ff ff       	call   80100df0 <filealloc>
8010367f:	85 c0                	test   %eax,%eax
80103681:	89 03                	mov    %eax,(%ebx)
80103683:	0f 84 87 00 00 00    	je     80103710 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103689:	e8 62 f2 ff ff       	call   801028f0 <kalloc>
8010368e:	85 c0                	test   %eax,%eax
80103690:	89 c7                	mov    %eax,%edi
80103692:	0f 84 b0 00 00 00    	je     80103748 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103698:	83 ec 08             	sub    $0x8,%esp
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
  p->readopen = 1;
8010369b:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801036a2:	00 00 00 
  p->writeopen = 1;
801036a5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801036ac:	00 00 00 
  p->nwrite = 0;
801036af:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801036b6:	00 00 00 
  p->nread = 0;
801036b9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801036c0:	00 00 00 
  initlock(&p->lock, "pipe");
801036c3:	68 10 82 10 80       	push   $0x80108210
801036c8:	50                   	push   %eax
801036c9:	e8 82 12 00 00       	call   80104950 <initlock>
  (*f0)->type = FD_PIPE;
801036ce:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801036d0:	83 c4 10             	add    $0x10,%esp
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
801036d3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801036d9:	8b 06                	mov    (%esi),%eax
801036db:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801036df:	8b 06                	mov    (%esi),%eax
801036e1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801036e5:	8b 06                	mov    (%esi),%eax
801036e7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801036ea:	8b 03                	mov    (%ebx),%eax
801036ec:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801036f2:	8b 03                	mov    (%ebx),%eax
801036f4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801036f8:	8b 03                	mov    (%ebx),%eax
801036fa:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801036fe:	8b 03                	mov    (%ebx),%eax
80103700:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103703:	8d 65 f4             	lea    -0xc(%ebp),%esp
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103706:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103708:	5b                   	pop    %ebx
80103709:	5e                   	pop    %esi
8010370a:	5f                   	pop    %edi
8010370b:	5d                   	pop    %ebp
8010370c:	c3                   	ret    
8010370d:	8d 76 00             	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103710:	8b 06                	mov    (%esi),%eax
80103712:	85 c0                	test   %eax,%eax
80103714:	74 1e                	je     80103734 <pipealloc+0xe4>
    fileclose(*f0);
80103716:	83 ec 0c             	sub    $0xc,%esp
80103719:	50                   	push   %eax
8010371a:	e8 91 d7 ff ff       	call   80100eb0 <fileclose>
8010371f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103722:	8b 03                	mov    (%ebx),%eax
80103724:	85 c0                	test   %eax,%eax
80103726:	74 0c                	je     80103734 <pipealloc+0xe4>
    fileclose(*f1);
80103728:	83 ec 0c             	sub    $0xc,%esp
8010372b:	50                   	push   %eax
8010372c:	e8 7f d7 ff ff       	call   80100eb0 <fileclose>
80103731:	83 c4 10             	add    $0x10,%esp
  return -1;
}
80103734:	8d 65 f4             	lea    -0xc(%ebp),%esp
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
80103737:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010373c:	5b                   	pop    %ebx
8010373d:	5e                   	pop    %esi
8010373e:	5f                   	pop    %edi
8010373f:	5d                   	pop    %ebp
80103740:	c3                   	ret    
80103741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103748:	8b 06                	mov    (%esi),%eax
8010374a:	85 c0                	test   %eax,%eax
8010374c:	75 c8                	jne    80103716 <pipealloc+0xc6>
8010374e:	eb d2                	jmp    80103722 <pipealloc+0xd2>

80103750 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
80103750:	55                   	push   %ebp
80103751:	89 e5                	mov    %esp,%ebp
80103753:	56                   	push   %esi
80103754:	53                   	push   %ebx
80103755:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103758:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010375b:	83 ec 0c             	sub    $0xc,%esp
8010375e:	53                   	push   %ebx
8010375f:	e8 ec 12 00 00       	call   80104a50 <acquire>
  if(writable){
80103764:	83 c4 10             	add    $0x10,%esp
80103767:	85 f6                	test   %esi,%esi
80103769:	74 45                	je     801037b0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010376b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103771:	83 ec 0c             	sub    $0xc,%esp
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
80103774:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010377b:	00 00 00 
    wakeup(&p->nread);
8010377e:	50                   	push   %eax
8010377f:	e8 fc 0d 00 00       	call   80104580 <wakeup>
80103784:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103787:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010378d:	85 d2                	test   %edx,%edx
8010378f:	75 0a                	jne    8010379b <pipeclose+0x4b>
80103791:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103797:	85 c0                	test   %eax,%eax
80103799:	74 35                	je     801037d0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010379b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010379e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037a1:	5b                   	pop    %ebx
801037a2:	5e                   	pop    %esi
801037a3:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801037a4:	e9 e7 13 00 00       	jmp    80104b90 <release>
801037a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
801037b0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801037b6:	83 ec 0c             	sub    $0xc,%esp
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
801037b9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801037c0:	00 00 00 
    wakeup(&p->nwrite);
801037c3:	50                   	push   %eax
801037c4:	e8 b7 0d 00 00       	call   80104580 <wakeup>
801037c9:	83 c4 10             	add    $0x10,%esp
801037cc:	eb b9                	jmp    80103787 <pipeclose+0x37>
801037ce:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
801037d0:	83 ec 0c             	sub    $0xc,%esp
801037d3:	53                   	push   %ebx
801037d4:	e8 b7 13 00 00       	call   80104b90 <release>
    kfree((char*)p);
801037d9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801037dc:	83 c4 10             	add    $0x10,%esp
  } else
    release(&p->lock);
}
801037df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037e2:	5b                   	pop    %ebx
801037e3:	5e                   	pop    %esi
801037e4:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
801037e5:	e9 16 ef ff ff       	jmp    80102700 <kfree>
801037ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801037f0 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801037f0:	55                   	push   %ebp
801037f1:	89 e5                	mov    %esp,%ebp
801037f3:	57                   	push   %edi
801037f4:	56                   	push   %esi
801037f5:	53                   	push   %ebx
801037f6:	83 ec 28             	sub    $0x28,%esp
801037f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801037fc:	53                   	push   %ebx
801037fd:	e8 4e 12 00 00       	call   80104a50 <acquire>
  for(i = 0; i < n; i++){
80103802:	8b 45 10             	mov    0x10(%ebp),%eax
80103805:	83 c4 10             	add    $0x10,%esp
80103808:	85 c0                	test   %eax,%eax
8010380a:	0f 8e b9 00 00 00    	jle    801038c9 <pipewrite+0xd9>
80103810:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103813:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103819:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010381f:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103825:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103828:	03 4d 10             	add    0x10(%ebp),%ecx
8010382b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010382e:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103834:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
8010383a:	39 d0                	cmp    %edx,%eax
8010383c:	74 38                	je     80103876 <pipewrite+0x86>
8010383e:	eb 59                	jmp    80103899 <pipewrite+0xa9>
      if(p->readopen == 0 || myproc()->killed){
80103840:	e8 1b 04 00 00       	call   80103c60 <myproc>
80103845:	8b 48 24             	mov    0x24(%eax),%ecx
80103848:	85 c9                	test   %ecx,%ecx
8010384a:	75 34                	jne    80103880 <pipewrite+0x90>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010384c:	83 ec 0c             	sub    $0xc,%esp
8010384f:	57                   	push   %edi
80103850:	e8 2b 0d 00 00       	call   80104580 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103855:	58                   	pop    %eax
80103856:	5a                   	pop    %edx
80103857:	53                   	push   %ebx
80103858:	56                   	push   %esi
80103859:	e8 42 0b 00 00       	call   801043a0 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010385e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103864:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010386a:	83 c4 10             	add    $0x10,%esp
8010386d:	05 00 02 00 00       	add    $0x200,%eax
80103872:	39 c2                	cmp    %eax,%edx
80103874:	75 2a                	jne    801038a0 <pipewrite+0xb0>
      if(p->readopen == 0 || myproc()->killed){
80103876:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010387c:	85 c0                	test   %eax,%eax
8010387e:	75 c0                	jne    80103840 <pipewrite+0x50>
        release(&p->lock);
80103880:	83 ec 0c             	sub    $0xc,%esp
80103883:	53                   	push   %ebx
80103884:	e8 07 13 00 00       	call   80104b90 <release>
        return -1;
80103889:	83 c4 10             	add    $0x10,%esp
8010388c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103891:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103894:	5b                   	pop    %ebx
80103895:	5e                   	pop    %esi
80103896:	5f                   	pop    %edi
80103897:	5d                   	pop    %ebp
80103898:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103899:	89 c2                	mov    %eax,%edx
8010389b:	90                   	nop
8010389c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801038a0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801038a3:	8d 42 01             	lea    0x1(%edx),%eax
801038a6:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801038aa:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801038b0:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801038b6:	0f b6 09             	movzbl (%ecx),%ecx
801038b9:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
801038bd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801038c0:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
801038c3:	0f 85 65 ff ff ff    	jne    8010382e <pipewrite+0x3e>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801038c9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801038cf:	83 ec 0c             	sub    $0xc,%esp
801038d2:	50                   	push   %eax
801038d3:	e8 a8 0c 00 00       	call   80104580 <wakeup>
  release(&p->lock);
801038d8:	89 1c 24             	mov    %ebx,(%esp)
801038db:	e8 b0 12 00 00       	call   80104b90 <release>
  return n;
801038e0:	83 c4 10             	add    $0x10,%esp
801038e3:	8b 45 10             	mov    0x10(%ebp),%eax
801038e6:	eb a9                	jmp    80103891 <pipewrite+0xa1>
801038e8:	90                   	nop
801038e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801038f0 <piperead>:
}

int
piperead(struct pipe *p, char *addr, int n)
{
801038f0:	55                   	push   %ebp
801038f1:	89 e5                	mov    %esp,%ebp
801038f3:	57                   	push   %edi
801038f4:	56                   	push   %esi
801038f5:	53                   	push   %ebx
801038f6:	83 ec 18             	sub    $0x18,%esp
801038f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801038fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801038ff:	53                   	push   %ebx
80103900:	e8 4b 11 00 00       	call   80104a50 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103905:	83 c4 10             	add    $0x10,%esp
80103908:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010390e:	39 83 38 02 00 00    	cmp    %eax,0x238(%ebx)
80103914:	75 6a                	jne    80103980 <piperead+0x90>
80103916:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
8010391c:	85 f6                	test   %esi,%esi
8010391e:	0f 84 cc 00 00 00    	je     801039f0 <piperead+0x100>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103924:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
8010392a:	eb 2d                	jmp    80103959 <piperead+0x69>
8010392c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103930:	83 ec 08             	sub    $0x8,%esp
80103933:	53                   	push   %ebx
80103934:	56                   	push   %esi
80103935:	e8 66 0a 00 00       	call   801043a0 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010393a:	83 c4 10             	add    $0x10,%esp
8010393d:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103943:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80103949:	75 35                	jne    80103980 <piperead+0x90>
8010394b:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
80103951:	85 d2                	test   %edx,%edx
80103953:	0f 84 97 00 00 00    	je     801039f0 <piperead+0x100>
    if(myproc()->killed){
80103959:	e8 02 03 00 00       	call   80103c60 <myproc>
8010395e:	8b 48 24             	mov    0x24(%eax),%ecx
80103961:	85 c9                	test   %ecx,%ecx
80103963:	74 cb                	je     80103930 <piperead+0x40>
      release(&p->lock);
80103965:	83 ec 0c             	sub    $0xc,%esp
80103968:	53                   	push   %ebx
80103969:	e8 22 12 00 00       	call   80104b90 <release>
      return -1;
8010396e:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103971:	8d 65 f4             	lea    -0xc(%ebp),%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
      return -1;
80103974:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103979:	5b                   	pop    %ebx
8010397a:	5e                   	pop    %esi
8010397b:	5f                   	pop    %edi
8010397c:	5d                   	pop    %ebp
8010397d:	c3                   	ret    
8010397e:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103980:	8b 45 10             	mov    0x10(%ebp),%eax
80103983:	85 c0                	test   %eax,%eax
80103985:	7e 69                	jle    801039f0 <piperead+0x100>
    if(p->nread == p->nwrite)
80103987:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010398d:	31 c9                	xor    %ecx,%ecx
8010398f:	eb 15                	jmp    801039a6 <piperead+0xb6>
80103991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103998:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010399e:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
801039a4:	74 5a                	je     80103a00 <piperead+0x110>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801039a6:	8d 70 01             	lea    0x1(%eax),%esi
801039a9:	25 ff 01 00 00       	and    $0x1ff,%eax
801039ae:	89 b3 34 02 00 00    	mov    %esi,0x234(%ebx)
801039b4:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
801039b9:	88 04 0f             	mov    %al,(%edi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801039bc:	83 c1 01             	add    $0x1,%ecx
801039bf:	39 4d 10             	cmp    %ecx,0x10(%ebp)
801039c2:	75 d4                	jne    80103998 <piperead+0xa8>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801039c4:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801039ca:	83 ec 0c             	sub    $0xc,%esp
801039cd:	50                   	push   %eax
801039ce:	e8 ad 0b 00 00       	call   80104580 <wakeup>
  release(&p->lock);
801039d3:	89 1c 24             	mov    %ebx,(%esp)
801039d6:	e8 b5 11 00 00       	call   80104b90 <release>
  return i;
801039db:	8b 45 10             	mov    0x10(%ebp),%eax
801039de:	83 c4 10             	add    $0x10,%esp
}
801039e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039e4:	5b                   	pop    %ebx
801039e5:	5e                   	pop    %esi
801039e6:	5f                   	pop    %edi
801039e7:	5d                   	pop    %ebp
801039e8:	c3                   	ret    
801039e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801039f0:	c7 45 10 00 00 00 00 	movl   $0x0,0x10(%ebp)
801039f7:	eb cb                	jmp    801039c4 <piperead+0xd4>
801039f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a00:	89 4d 10             	mov    %ecx,0x10(%ebp)
80103a03:	eb bf                	jmp    801039c4 <piperead+0xd4>
80103a05:	66 90                	xchg   %ax,%ax
80103a07:	66 90                	xchg   %ax,%ax
80103a09:	66 90                	xchg   %ax,%ax
80103a0b:	66 90                	xchg   %ax,%ax
80103a0d:	66 90                	xchg   %ax,%ax
80103a0f:	90                   	nop

80103a10 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103a10:	55                   	push   %ebp
80103a11:	89 e5                	mov    %esp,%ebp
80103a13:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a14:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103a19:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80103a1c:	68 40 3d 11 80       	push   $0x80113d40
80103a21:	e8 2a 10 00 00       	call   80104a50 <acquire>
80103a26:	83 c4 10             	add    $0x10,%esp
80103a29:	eb 17                	jmp    80103a42 <allocproc+0x32>
80103a2b:	90                   	nop
80103a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a30:	81 c3 54 02 00 00    	add    $0x254,%ebx
80103a36:	81 fb 74 d2 11 80    	cmp    $0x8011d274,%ebx
80103a3c:	0f 84 ee 00 00 00    	je     80103b30 <allocproc+0x120>
    if(p->state == UNUSED)
80103a42:	8b 43 0c             	mov    0xc(%ebx),%eax
80103a45:	85 c0                	test   %eax,%eax
80103a47:	75 e7                	jne    80103a30 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103a49:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103a4e:	83 ec 0c             	sub    $0xc,%esp

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80103a51:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;

  release(&ptable.lock);
80103a58:	68 40 3d 11 80       	push   $0x80113d40
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103a5d:	8d 50 01             	lea    0x1(%eax),%edx
80103a60:	89 43 10             	mov    %eax,0x10(%ebx)
80103a63:	89 15 04 b0 10 80    	mov    %edx,0x8010b004

  release(&ptable.lock);
80103a69:	e8 22 11 00 00       	call   80104b90 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103a6e:	e8 7d ee ff ff       	call   801028f0 <kalloc>
80103a73:	83 c4 10             	add    $0x10,%esp
80103a76:	85 c0                	test   %eax,%eax
80103a78:	89 43 08             	mov    %eax,0x8(%ebx)
80103a7b:	0f 84 c6 00 00 00    	je     80103b47 <allocproc+0x137>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103a81:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103a87:	83 ec 04             	sub    $0x4,%esp
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
80103a8a:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103a8f:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
80103a92:	c7 40 14 62 5e 10 80 	movl   $0x80105e62,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103a99:	6a 14                	push   $0x14
80103a9b:	6a 00                	push   $0x0
80103a9d:	50                   	push   %eax
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
80103a9e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103aa1:	e8 3a 11 00 00       	call   80104be0 <memset>
  p->context->eip = (uint)forkret;
80103aa6:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103aa9:	8d 93 14 01 00 00    	lea    0x114(%ebx),%edx
80103aaf:	83 c4 10             	add    $0x10,%esp
80103ab2:	c7 40 10 50 3b 10 80 	movl   $0x80103b50,0x10(%eax)
80103ab9:	8d 83 94 00 00 00    	lea    0x94(%ebx),%eax

  #ifndef NONE
  int i;

  /// paging infrastructure
  p->num_of_pages_in_memory = 0;
80103abf:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80103ac6:	00 00 00 
  p->num_of_page_faults = 0;
80103ac9:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80103ad0:	00 00 00 
  p->num_of_currently_swapped_out_pages = 0;
80103ad3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80103ada:	00 00 00 
  p->num_of_total_swap_out_actions = 0;
80103add:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80103ae4:	00 00 00 
80103ae7:	89 f6                	mov    %esi,%esi
80103ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  for(i = 0 ; i < MAX_PSYC_PAGES ; i++){
    p->sfm[i].in_swap_file = 0;
80103af0:	c6 00 00             	movb   $0x0,(%eax)
80103af3:	83 c0 08             	add    $0x8,%eax
  p->num_of_pages_in_memory = 0;
  p->num_of_page_faults = 0;
  p->num_of_currently_swapped_out_pages = 0;
  p->num_of_total_swap_out_actions = 0;

  for(i = 0 ; i < MAX_PSYC_PAGES ; i++){
80103af6:	39 d0                	cmp    %edx,%eax
80103af8:	75 f6                	jne    80103af0 <allocproc+0xe0>
80103afa:	8d 83 20 01 00 00    	lea    0x120(%ebx),%eax
80103b00:	8d 93 60 02 00 00    	lea    0x260(%ebx),%edx
80103b06:	8d 76 00             	lea    0x0(%esi),%esi
80103b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p->sfm[i].in_swap_file = 0;
  }

  for(i = 0 ; i < MAX_PSYC_PAGES ; i++){
    p->mem_pages[i].in_mem = 0;
80103b10:	c6 00 00             	movb   $0x0,(%eax)
80103b13:	83 c0 14             	add    $0x14,%eax

  for(i = 0 ; i < MAX_PSYC_PAGES ; i++){
    p->sfm[i].in_swap_file = 0;
  }

  for(i = 0 ; i < MAX_PSYC_PAGES ; i++){
80103b16:	39 d0                	cmp    %edx,%eax
80103b18:	75 f6                	jne    80103b10 <allocproc+0x100>
    p->mem_pages[i].in_mem = 0;
  }

  p->first = 0;
80103b1a:	c7 83 50 02 00 00 00 	movl   $0x0,0x250(%ebx)
80103b21:	00 00 00 

  #endif

  return p;
80103b24:	89 d8                	mov    %ebx,%eax
}
80103b26:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b29:	c9                   	leave  
80103b2a:	c3                   	ret    
80103b2b:	90                   	nop
80103b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80103b30:	83 ec 0c             	sub    $0xc,%esp
80103b33:	68 40 3d 11 80       	push   $0x80113d40
80103b38:	e8 53 10 00 00       	call   80104b90 <release>
  return 0;
80103b3d:	83 c4 10             	add    $0x10,%esp
80103b40:	31 c0                	xor    %eax,%eax
  p->first = 0;

  #endif

  return p;
}
80103b42:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b45:	c9                   	leave  
80103b46:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
80103b47:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103b4e:	eb d6                	jmp    80103b26 <allocproc+0x116>

80103b50 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103b50:	55                   	push   %ebp
80103b51:	89 e5                	mov    %esp,%ebp
80103b53:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103b56:	68 40 3d 11 80       	push   $0x80113d40
80103b5b:	e8 30 10 00 00       	call   80104b90 <release>

  if (first) {
80103b60:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103b65:	83 c4 10             	add    $0x10,%esp
80103b68:	85 c0                	test   %eax,%eax
80103b6a:	75 04                	jne    80103b70 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103b6c:	c9                   	leave  
80103b6d:	c3                   	ret    
80103b6e:	66 90                	xchg   %ax,%ax
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
80103b70:	83 ec 0c             	sub    $0xc,%esp

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80103b73:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103b7a:	00 00 00 
    iinit(ROOTDEV);
80103b7d:	6a 01                	push   $0x1
80103b7f:	e8 6c d9 ff ff       	call   801014f0 <iinit>
    initlog(ROOTDEV);
80103b84:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103b8b:	e8 80 f3 ff ff       	call   80102f10 <initlog>
80103b90:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103b93:	c9                   	leave  
80103b94:	c3                   	ret    
80103b95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ba0 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103ba0:	55                   	push   %ebp
80103ba1:	89 e5                	mov    %esp,%ebp
80103ba3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103ba6:	68 15 82 10 80       	push   $0x80108215
80103bab:	68 40 3d 11 80       	push   $0x80113d40
80103bb0:	e8 9b 0d 00 00       	call   80104950 <initlock>
}
80103bb5:	83 c4 10             	add    $0x10,%esp
80103bb8:	c9                   	leave  
80103bb9:	c3                   	ret    
80103bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103bc0 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80103bc0:	55                   	push   %ebp
80103bc1:	89 e5                	mov    %esp,%ebp
80103bc3:	56                   	push   %esi
80103bc4:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103bc5:	9c                   	pushf  
80103bc6:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
80103bc7:	f6 c4 02             	test   $0x2,%ah
80103bca:	75 5b                	jne    80103c27 <mycpu+0x67>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
80103bcc:	e8 7f ef ff ff       	call   80102b50 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103bd1:	8b 35 20 3d 11 80    	mov    0x80113d20,%esi
80103bd7:	85 f6                	test   %esi,%esi
80103bd9:	7e 3f                	jle    80103c1a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103bdb:	0f b6 15 a0 37 11 80 	movzbl 0x801137a0,%edx
80103be2:	39 d0                	cmp    %edx,%eax
80103be4:	74 30                	je     80103c16 <mycpu+0x56>
80103be6:	b9 50 38 11 80       	mov    $0x80113850,%ecx
80103beb:	31 d2                	xor    %edx,%edx
80103bed:	8d 76 00             	lea    0x0(%esi),%esi
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103bf0:	83 c2 01             	add    $0x1,%edx
80103bf3:	39 f2                	cmp    %esi,%edx
80103bf5:	74 23                	je     80103c1a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103bf7:	0f b6 19             	movzbl (%ecx),%ebx
80103bfa:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103c00:	39 d8                	cmp    %ebx,%eax
80103c02:	75 ec                	jne    80103bf0 <mycpu+0x30>
      return &cpus[i];
80103c04:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
  }
  panic("unknown apicid\n");
}
80103c0a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c0d:	5b                   	pop    %ebx
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
80103c0e:	05 a0 37 11 80       	add    $0x801137a0,%eax
  }
  panic("unknown apicid\n");
}
80103c13:	5e                   	pop    %esi
80103c14:	5d                   	pop    %ebp
80103c15:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103c16:	31 d2                	xor    %edx,%edx
80103c18:	eb ea                	jmp    80103c04 <mycpu+0x44>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
80103c1a:	83 ec 0c             	sub    $0xc,%esp
80103c1d:	68 1c 82 10 80       	push   $0x8010821c
80103c22:	e8 49 c7 ff ff       	call   80100370 <panic>
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
80103c27:	83 ec 0c             	sub    $0xc,%esp
80103c2a:	68 54 83 10 80       	push   $0x80108354
80103c2f:	e8 3c c7 ff ff       	call   80100370 <panic>
80103c34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103c3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103c40 <cpuid>:
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
80103c40:	55                   	push   %ebp
80103c41:	89 e5                	mov    %esp,%ebp
80103c43:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103c46:	e8 75 ff ff ff       	call   80103bc0 <mycpu>
80103c4b:	2d a0 37 11 80       	sub    $0x801137a0,%eax
}
80103c50:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
80103c51:	c1 f8 04             	sar    $0x4,%eax
80103c54:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103c5a:	c3                   	ret    
80103c5b:	90                   	nop
80103c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103c60 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
80103c60:	55                   	push   %ebp
80103c61:	89 e5                	mov    %esp,%ebp
80103c63:	53                   	push   %ebx
80103c64:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80103c67:	e8 a4 0d 00 00       	call   80104a10 <pushcli>
  c = mycpu();
80103c6c:	e8 4f ff ff ff       	call   80103bc0 <mycpu>
  p = c->proc;
80103c71:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c77:	e8 a4 0e 00 00       	call   80104b20 <popcli>
  return p;
}
80103c7c:	83 c4 04             	add    $0x4,%esp
80103c7f:	89 d8                	mov    %ebx,%eax
80103c81:	5b                   	pop    %ebx
80103c82:	5d                   	pop    %ebp
80103c83:	c3                   	ret    
80103c84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103c8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103c90 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103c90:	55                   	push   %ebp
80103c91:	89 e5                	mov    %esp,%ebp
80103c93:	53                   	push   %ebx
80103c94:	83 ec 04             	sub    $0x4,%esp
  #endif

  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80103c97:	e8 74 fd ff ff       	call   80103a10 <allocproc>
80103c9c:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
80103c9e:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103ca3:	e8 68 38 00 00       	call   80107510 <setupkvm>
80103ca8:	85 c0                	test   %eax,%eax
80103caa:	89 43 04             	mov    %eax,0x4(%ebx)
80103cad:	0f 84 bd 00 00 00    	je     80103d70 <userinit+0xe0>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103cb3:	83 ec 04             	sub    $0x4,%esp
80103cb6:	68 2c 00 00 00       	push   $0x2c
80103cbb:	68 60 b4 10 80       	push   $0x8010b460
80103cc0:	50                   	push   %eax
80103cc1:	e8 5a 36 00 00       	call   80107320 <inituvm>
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
80103cc6:	83 c4 0c             	add    $0xc,%esp
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
80103cc9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103ccf:	6a 4c                	push   $0x4c
80103cd1:	6a 00                	push   $0x0
80103cd3:	ff 73 18             	pushl  0x18(%ebx)
80103cd6:	e8 05 0f 00 00       	call   80104be0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103cdb:	8b 43 18             	mov    0x18(%ebx),%eax
80103cde:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103ce3:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103ce8:	83 c4 0c             	add    $0xc,%esp
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103ceb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103cef:	8b 43 18             	mov    0x18(%ebx),%eax
80103cf2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103cf6:	8b 43 18             	mov    0x18(%ebx),%eax
80103cf9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103cfd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103d01:	8b 43 18             	mov    0x18(%ebx),%eax
80103d04:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103d08:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103d0c:	8b 43 18             	mov    0x18(%ebx),%eax
80103d0f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103d16:	8b 43 18             	mov    0x18(%ebx),%eax
80103d19:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103d20:	8b 43 18             	mov    0x18(%ebx),%eax
80103d23:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103d2a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103d2d:	6a 10                	push   $0x10
80103d2f:	68 45 82 10 80       	push   $0x80108245
80103d34:	50                   	push   %eax
80103d35:	e8 a6 10 00 00       	call   80104de0 <safestrcpy>
  p->cwd = namei("/");
80103d3a:	c7 04 24 4e 82 10 80 	movl   $0x8010824e,(%esp)
80103d41:	e8 fa e1 ff ff       	call   80101f40 <namei>
80103d46:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103d49:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80103d50:	e8 fb 0c 00 00       	call   80104a50 <acquire>

  p->state = RUNNABLE;
80103d55:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
80103d5c:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80103d63:	e8 28 0e 00 00       	call   80104b90 <release>
}
80103d68:	83 c4 10             	add    $0x10,%esp
80103d6b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d6e:	c9                   	leave  
80103d6f:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
80103d70:	83 ec 0c             	sub    $0xc,%esp
80103d73:	68 2c 82 10 80       	push   $0x8010822c
80103d78:	e8 f3 c5 ff ff       	call   80100370 <panic>
80103d7d:	8d 76 00             	lea    0x0(%esi),%esi

80103d80 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103d80:	55                   	push   %ebp
80103d81:	89 e5                	mov    %esp,%ebp
80103d83:	56                   	push   %esi
80103d84:	53                   	push   %ebx
80103d85:	8b 75 08             	mov    0x8(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103d88:	e8 83 0c 00 00       	call   80104a10 <pushcli>
  c = mycpu();
80103d8d:	e8 2e fe ff ff       	call   80103bc0 <mycpu>
  p = c->proc;
80103d92:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d98:	e8 83 0d 00 00       	call   80104b20 <popcli>
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
80103d9d:	83 fe 00             	cmp    $0x0,%esi
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
80103da0:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103da2:	7e 34                	jle    80103dd8 <growproc+0x58>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103da4:	83 ec 04             	sub    $0x4,%esp
80103da7:	01 c6                	add    %eax,%esi
80103da9:	56                   	push   %esi
80103daa:	50                   	push   %eax
80103dab:	ff 73 04             	pushl  0x4(%ebx)
80103dae:	e8 3d 3d 00 00       	call   80107af0 <allocuvm>
80103db3:	83 c4 10             	add    $0x10,%esp
80103db6:	85 c0                	test   %eax,%eax
80103db8:	74 36                	je     80103df0 <growproc+0x70>
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
80103dba:	83 ec 0c             	sub    $0xc,%esp
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
80103dbd:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103dbf:	53                   	push   %ebx
80103dc0:	e8 4b 34 00 00       	call   80107210 <switchuvm>
  return 0;
80103dc5:	83 c4 10             	add    $0x10,%esp
80103dc8:	31 c0                	xor    %eax,%eax
}
80103dca:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103dcd:	5b                   	pop    %ebx
80103dce:	5e                   	pop    %esi
80103dcf:	5d                   	pop    %ebp
80103dd0:	c3                   	ret    
80103dd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
80103dd8:	74 e0                	je     80103dba <growproc+0x3a>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103dda:	83 ec 04             	sub    $0x4,%esp
80103ddd:	01 c6                	add    %eax,%esi
80103ddf:	56                   	push   %esi
80103de0:	50                   	push   %eax
80103de1:	ff 73 04             	pushl  0x4(%ebx)
80103de4:	e8 77 36 00 00       	call   80107460 <deallocuvm>
80103de9:	83 c4 10             	add    $0x10,%esp
80103dec:	85 c0                	test   %eax,%eax
80103dee:	75 ca                	jne    80103dba <growproc+0x3a>
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
80103df0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103df5:	eb d3                	jmp    80103dca <growproc+0x4a>
80103df7:	89 f6                	mov    %esi,%esi
80103df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e00 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103e00:	55                   	push   %ebp
80103e01:	89 e5                	mov    %esp,%ebp
80103e03:	57                   	push   %edi
80103e04:	56                   	push   %esi
80103e05:	53                   	push   %ebx
80103e06:	81 ec 1c 04 00 00    	sub    $0x41c,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103e0c:	e8 ff 0b 00 00       	call   80104a10 <pushcli>
  c = mycpu();
80103e11:	e8 aa fd ff ff       	call   80103bc0 <mycpu>
  p = c->proc;
80103e16:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e1c:	e8 ff 0c 00 00       	call   80104b20 <popcli>
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
80103e21:	e8 ea fb ff ff       	call   80103a10 <allocproc>
80103e26:	85 c0                	test   %eax,%eax
80103e28:	89 c7                	mov    %eax,%edi
80103e2a:	89 85 e4 fb ff ff    	mov    %eax,-0x41c(%ebp)
80103e30:	0f 84 18 02 00 00    	je     8010404e <fork+0x24e>
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103e36:	83 ec 08             	sub    $0x8,%esp
80103e39:	ff 33                	pushl  (%ebx)
80103e3b:	ff 73 04             	pushl  0x4(%ebx)
80103e3e:	e8 9d 37 00 00       	call   801075e0 <copyuvm>
80103e43:	83 c4 10             	add    $0x10,%esp
80103e46:	85 c0                	test   %eax,%eax
80103e48:	89 47 04             	mov    %eax,0x4(%edi)
80103e4b:	0f 84 07 02 00 00    	je     80104058 <fork+0x258>
    np->state = UNUSED;
    return -1;
  }

  #ifndef NONE
  np->num_of_pages_in_memory = curproc->num_of_pages_in_memory;
80103e51:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
80103e57:	8b bd e4 fb ff ff    	mov    -0x41c(%ebp),%edi
  np->num_of_currently_swapped_out_pages = curproc->num_of_currently_swapped_out_pages;
  
  createSwapFile(np);
80103e5d:	83 ec 0c             	sub    $0xc,%esp
    np->state = UNUSED;
    return -1;
  }

  #ifndef NONE
  np->num_of_pages_in_memory = curproc->num_of_pages_in_memory;
80103e60:	89 87 80 00 00 00    	mov    %eax,0x80(%edi)
  np->num_of_currently_swapped_out_pages = curproc->num_of_currently_swapped_out_pages;
80103e66:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
80103e6c:	89 87 84 00 00 00    	mov    %eax,0x84(%edi)
  
  createSwapFile(np);
80103e72:	57                   	push   %edi
  char transport[PGSIZE/4] = "";
80103e73:	8d bd ec fb ff ff    	lea    -0x414(%ebp),%edi

  #ifndef NONE
  np->num_of_pages_in_memory = curproc->num_of_pages_in_memory;
  np->num_of_currently_swapped_out_pages = curproc->num_of_currently_swapped_out_pages;
  
  createSwapFile(np);
80103e79:	e8 a2 e3 ff ff       	call   80102220 <createSwapFile>
  char transport[PGSIZE/4] = "";
80103e7e:	31 c0                	xor    %eax,%eax
80103e80:	b9 ff 00 00 00       	mov    $0xff,%ecx
80103e85:	c7 85 e8 fb ff ff 00 	movl   $0x0,-0x418(%ebp)
80103e8c:	00 00 00 
80103e8f:	f3 ab                	rep stos %eax,%es:(%edi)
  int offset = 0;
  int bytesRead = 0;

  /// copy parent's swapfile
  if(strcmp(curproc->name, "init") && strcmp(curproc->name, "sh")){
80103e91:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103e94:	5a                   	pop    %edx
80103e95:	59                   	pop    %ecx
80103e96:	68 50 82 10 80       	push   $0x80108250
80103e9b:	50                   	push   %eax
80103e9c:	89 85 dc fb ff ff    	mov    %eax,-0x424(%ebp)
80103ea2:	e8 99 0f 00 00       	call   80104e40 <strcmp>
80103ea7:	83 c4 10             	add    $0x10,%esp
80103eaa:	85 c0                	test   %eax,%eax
80103eac:	0f 85 2e 01 00 00    	jne    80103fe0 <fork+0x1e0>
80103eb2:	8b 85 e4 fb ff ff    	mov    -0x41c(%ebp),%eax
80103eb8:	8d 93 90 00 00 00    	lea    0x90(%ebx),%edx
80103ebe:	8d b0 90 00 00 00    	lea    0x90(%eax),%esi
80103ec4:	8d 83 10 01 00 00    	lea    0x110(%ebx),%eax
80103eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      offset += bytesRead;
    }
  }

  for(i = 0; i < MAX_PSYC_PAGES ; i++){
    np->sfm[i].va = curproc->sfm[i].va;
80103ed0:	8b 0a                	mov    (%edx),%ecx
80103ed2:	83 c2 08             	add    $0x8,%edx
80103ed5:	83 c6 08             	add    $0x8,%esi
80103ed8:	89 4e f8             	mov    %ecx,-0x8(%esi)
    np->sfm[i].in_swap_file = curproc->sfm[i].in_swap_file;
80103edb:	0f b6 4a fc          	movzbl -0x4(%edx),%ecx
80103edf:	88 4e fc             	mov    %cl,-0x4(%esi)

      offset += bytesRead;
    }
  }

  for(i = 0; i < MAX_PSYC_PAGES ; i++){
80103ee2:	39 c2                	cmp    %eax,%edx
80103ee4:	75 ea                	jne    80103ed0 <fork+0xd0>
80103ee6:	8b bd e4 fb ff ff    	mov    -0x41c(%ebp),%edi
80103eec:	8d b3 50 02 00 00    	lea    0x250(%ebx),%esi
80103ef2:	8d 97 10 01 00 00    	lea    0x110(%edi),%edx
80103ef8:	90                   	nop
80103ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    np->sfm[i].va = curproc->sfm[i].va;
    np->sfm[i].in_swap_file = curproc->sfm[i].in_swap_file;
  }

  for(i = 0 ; i < MAX_TOTAL_PAGES - MAX_PSYC_PAGES ; i++){
    np->mem_pages[i].next = curproc->mem_pages[i].next;
80103f00:	8b 08                	mov    (%eax),%ecx
80103f02:	83 c0 14             	add    $0x14,%eax
80103f05:	83 c2 14             	add    $0x14,%edx
80103f08:	89 4a ec             	mov    %ecx,-0x14(%edx)
    np->mem_pages[i].prev = curproc->mem_pages[i].prev;
80103f0b:	8b 48 f0             	mov    -0x10(%eax),%ecx
80103f0e:	89 4a f0             	mov    %ecx,-0x10(%edx)
    np->mem_pages[i].aging = curproc->mem_pages[i].aging;
80103f11:	8b 48 f4             	mov    -0xc(%eax),%ecx
80103f14:	89 4a f4             	mov    %ecx,-0xc(%edx)
    np->mem_pages[i].va = curproc->mem_pages[i].va;
80103f17:	8b 48 f8             	mov    -0x8(%eax),%ecx
80103f1a:	89 4a f8             	mov    %ecx,-0x8(%edx)
    np->mem_pages[i].in_mem = curproc->mem_pages[i].in_mem;
80103f1d:	0f b6 48 fc          	movzbl -0x4(%eax),%ecx
80103f21:	88 4a fc             	mov    %cl,-0x4(%edx)
  for(i = 0; i < MAX_PSYC_PAGES ; i++){
    np->sfm[i].va = curproc->sfm[i].va;
    np->sfm[i].in_swap_file = curproc->sfm[i].in_swap_file;
  }

  for(i = 0 ; i < MAX_TOTAL_PAGES - MAX_PSYC_PAGES ; i++){
80103f24:	39 f0                	cmp    %esi,%eax
80103f26:	75 d8                	jne    80103f00 <fork+0x100>
    np->mem_pages[i].aging = curproc->mem_pages[i].aging;
    np->mem_pages[i].va = curproc->mem_pages[i].va;
    np->mem_pages[i].in_mem = curproc->mem_pages[i].in_mem;
  }

  np->first = curproc->first;
80103f28:	8b 83 50 02 00 00    	mov    0x250(%ebx),%eax
80103f2e:	8b bd e4 fb ff ff    	mov    -0x41c(%ebp),%edi

  #endif

  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;
80103f34:	b9 13 00 00 00       	mov    $0x13,%ecx
    np->mem_pages[i].aging = curproc->mem_pages[i].aging;
    np->mem_pages[i].va = curproc->mem_pages[i].va;
    np->mem_pages[i].in_mem = curproc->mem_pages[i].in_mem;
  }

  np->first = curproc->first;
80103f39:	89 87 50 02 00 00    	mov    %eax,0x250(%edi)

  #endif

  np->sz = curproc->sz;
80103f3f:	8b 03                	mov    (%ebx),%eax
  np->parent = curproc;
80103f41:	89 5f 14             	mov    %ebx,0x14(%edi)

  np->first = curproc->first;

  #endif

  np->sz = curproc->sz;
80103f44:	89 07                	mov    %eax,(%edi)
  np->parent = curproc;
  *np->tf = *curproc->tf;
80103f46:	89 f8                	mov    %edi,%eax
80103f48:	8b 73 18             	mov    0x18(%ebx),%esi
80103f4b:	8b 7f 18             	mov    0x18(%edi),%edi
80103f4e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103f50:	89 c7                	mov    %eax,%edi

  for(i = 0; i < NOFILE; i++)
80103f52:	31 f6                	xor    %esi,%esi
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103f54:	8b 40 18             	mov    0x18(%eax),%eax
80103f57:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103f5e:	66 90                	xchg   %ax,%ax

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
80103f60:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103f64:	85 c0                	test   %eax,%eax
80103f66:	74 10                	je     80103f78 <fork+0x178>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103f68:	83 ec 0c             	sub    $0xc,%esp
80103f6b:	50                   	push   %eax
80103f6c:	e8 ef ce ff ff       	call   80100e60 <filedup>
80103f71:	83 c4 10             	add    $0x10,%esp
80103f74:	89 44 b7 28          	mov    %eax,0x28(%edi,%esi,4)
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103f78:	83 c6 01             	add    $0x1,%esi
80103f7b:	83 fe 10             	cmp    $0x10,%esi
80103f7e:	75 e0                	jne    80103f60 <fork+0x160>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103f80:	83 ec 0c             	sub    $0xc,%esp
80103f83:	ff 73 68             	pushl  0x68(%ebx)
80103f86:	e8 35 d7 ff ff       	call   801016c0 <idup>
80103f8b:	8b bd e4 fb ff ff    	mov    -0x41c(%ebp),%edi

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f91:	83 c4 0c             	add    $0xc,%esp
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103f94:	89 47 68             	mov    %eax,0x68(%edi)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103f97:	8d 47 6c             	lea    0x6c(%edi),%eax
80103f9a:	6a 10                	push   $0x10
80103f9c:	ff b5 dc fb ff ff    	pushl  -0x424(%ebp)
80103fa2:	50                   	push   %eax
80103fa3:	e8 38 0e 00 00       	call   80104de0 <safestrcpy>

  pid = np->pid;
80103fa8:	8b 5f 10             	mov    0x10(%edi),%ebx

  acquire(&ptable.lock);
80103fab:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80103fb2:	e8 99 0a 00 00       	call   80104a50 <acquire>

  np->state = RUNNABLE;
80103fb7:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)

  release(&ptable.lock);
80103fbe:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80103fc5:	e8 c6 0b 00 00       	call   80104b90 <release>

  return pid;
80103fca:	83 c4 10             	add    $0x10,%esp
80103fcd:	89 d8                	mov    %ebx,%eax
}
80103fcf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fd2:	5b                   	pop    %ebx
80103fd3:	5e                   	pop    %esi
80103fd4:	5f                   	pop    %edi
80103fd5:	5d                   	pop    %ebp
80103fd6:	c3                   	ret    
80103fd7:	89 f6                	mov    %esi,%esi
80103fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  char transport[PGSIZE/4] = "";
  int offset = 0;
  int bytesRead = 0;

  /// copy parent's swapfile
  if(strcmp(curproc->name, "init") && strcmp(curproc->name, "sh")){
80103fe0:	83 ec 08             	sub    $0x8,%esp
80103fe3:	68 55 82 10 80       	push   $0x80108255
80103fe8:	ff b5 dc fb ff ff    	pushl  -0x424(%ebp)
80103fee:	e8 4d 0e 00 00       	call   80104e40 <strcmp>
80103ff3:	83 c4 10             	add    $0x10,%esp
80103ff6:	85 c0                	test   %eax,%eax
80103ff8:	0f 84 b4 fe ff ff    	je     80103eb2 <fork+0xb2>
80103ffe:	31 f6                	xor    %esi,%esi
80104000:	8d bd e8 fb ff ff    	lea    -0x418(%ebp),%edi
80104006:	89 9d e0 fb ff ff    	mov    %ebx,-0x420(%ebp)
8010400c:	eb 1a                	jmp    80104028 <fork+0x228>
8010400e:	66 90                	xchg   %ax,%ax
    while((bytesRead = readFromSwapFile(curproc, transport, offset, PGSIZE/4))){
      if(writeToSwapFile(np, transport, offset, bytesRead) == -1){
80104010:	53                   	push   %ebx
80104011:	56                   	push   %esi
80104012:	57                   	push   %edi
80104013:	ff b5 e4 fb ff ff    	pushl  -0x41c(%ebp)
80104019:	e8 a2 e2 ff ff       	call   801022c0 <writeToSwapFile>
8010401e:	83 c4 10             	add    $0x10,%esp
80104021:	83 f8 ff             	cmp    $0xffffffff,%eax
80104024:	74 5e                	je     80104084 <fork+0x284>
        panic("copying swapfile failed");
      }

      offset += bytesRead;
80104026:	01 de                	add    %ebx,%esi
  int offset = 0;
  int bytesRead = 0;

  /// copy parent's swapfile
  if(strcmp(curproc->name, "init") && strcmp(curproc->name, "sh")){
    while((bytesRead = readFromSwapFile(curproc, transport, offset, PGSIZE/4))){
80104028:	68 00 04 00 00       	push   $0x400
8010402d:	56                   	push   %esi
8010402e:	57                   	push   %edi
8010402f:	ff b5 e0 fb ff ff    	pushl  -0x420(%ebp)
80104035:	e8 b6 e2 ff ff       	call   801022f0 <readFromSwapFile>
8010403a:	83 c4 10             	add    $0x10,%esp
8010403d:	85 c0                	test   %eax,%eax
8010403f:	89 c3                	mov    %eax,%ebx
80104041:	75 cd                	jne    80104010 <fork+0x210>
80104043:	8b 9d e0 fb ff ff    	mov    -0x420(%ebp),%ebx
80104049:	e9 64 fe ff ff       	jmp    80103eb2 <fork+0xb2>
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
8010404e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104053:	e9 77 ff ff ff       	jmp    80103fcf <fork+0x1cf>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
80104058:	8b 9d e4 fb ff ff    	mov    -0x41c(%ebp),%ebx
8010405e:	83 ec 0c             	sub    $0xc,%esp
80104061:	ff 73 08             	pushl  0x8(%ebx)
80104064:	e8 97 e6 ff ff       	call   80102700 <kfree>
    np->kstack = 0;
80104069:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80104070:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80104077:	83 c4 10             	add    $0x10,%esp
8010407a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010407f:	e9 4b ff ff ff       	jmp    80103fcf <fork+0x1cf>

  /// copy parent's swapfile
  if(strcmp(curproc->name, "init") && strcmp(curproc->name, "sh")){
    while((bytesRead = readFromSwapFile(curproc, transport, offset, PGSIZE/4))){
      if(writeToSwapFile(np, transport, offset, bytesRead) == -1){
        panic("copying swapfile failed");
80104084:	83 ec 0c             	sub    $0xc,%esp
80104087:	68 58 82 10 80       	push   $0x80108258
8010408c:	e8 df c2 ff ff       	call   80100370 <panic>
80104091:	eb 0d                	jmp    801040a0 <scheduler>
80104093:	90                   	nop
80104094:	90                   	nop
80104095:	90                   	nop
80104096:	90                   	nop
80104097:	90                   	nop
80104098:	90                   	nop
80104099:	90                   	nop
8010409a:	90                   	nop
8010409b:	90                   	nop
8010409c:	90                   	nop
8010409d:	90                   	nop
8010409e:	90                   	nop
8010409f:	90                   	nop

801040a0 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
801040a0:	55                   	push   %ebp
801040a1:	89 e5                	mov    %esp,%ebp
801040a3:	57                   	push   %edi
801040a4:	56                   	push   %esi
801040a5:	53                   	push   %ebx
801040a6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p;
  struct cpu *c = mycpu();
801040a9:	e8 12 fb ff ff       	call   80103bc0 <mycpu>
801040ae:	8d 78 04             	lea    0x4(%eax),%edi
801040b1:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801040b3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801040ba:	00 00 00 
801040bd:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
801040c0:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
801040c1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040c4:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
801040c9:	68 40 3d 11 80       	push   $0x80113d40
801040ce:	e8 7d 09 00 00       	call   80104a50 <acquire>
801040d3:	83 c4 10             	add    $0x10,%esp
801040d6:	eb 16                	jmp    801040ee <scheduler+0x4e>
801040d8:	90                   	nop
801040d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040e0:	81 c3 54 02 00 00    	add    $0x254,%ebx
801040e6:	81 fb 74 d2 11 80    	cmp    $0x8011d274,%ebx
801040ec:	74 52                	je     80104140 <scheduler+0xa0>
      if(p->state != RUNNABLE)
801040ee:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801040f2:	75 ec                	jne    801040e0 <scheduler+0x40>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
801040f4:	83 ec 0c             	sub    $0xc,%esp


      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
801040f7:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
801040fd:	53                   	push   %ebx
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040fe:	81 c3 54 02 00 00    	add    $0x254,%ebx

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80104104:	e8 07 31 00 00       	call   80107210 <switchuvm>
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
80104109:	58                   	pop    %eax
8010410a:	5a                   	pop    %edx
8010410b:	ff b3 c8 fd ff ff    	pushl  -0x238(%ebx)
80104111:	57                   	push   %edi
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
80104112:	c7 83 b8 fd ff ff 04 	movl   $0x4,-0x248(%ebx)
80104119:	00 00 00 

      swtch(&(c->scheduler), p->context);
8010411c:	e8 67 0d 00 00       	call   80104e88 <swtch>
      switchkvm();
80104121:	e8 ca 30 00 00       	call   801071f0 <switchkvm>
      //  updateNFUA();
      #endif

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80104126:	83 c4 10             	add    $0x10,%esp
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104129:	81 fb 74 d2 11 80    	cmp    $0x8011d274,%ebx
      //  updateNFUA();
      #endif

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
8010412f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104136:	00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104139:	75 b3                	jne    801040ee <scheduler+0x4e>
8010413b:	90                   	nop
8010413c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
80104140:	83 ec 0c             	sub    $0xc,%esp
80104143:	68 40 3d 11 80       	push   $0x80113d40
80104148:	e8 43 0a 00 00       	call   80104b90 <release>

  }
8010414d:	83 c4 10             	add    $0x10,%esp
80104150:	e9 6b ff ff ff       	jmp    801040c0 <scheduler+0x20>
80104155:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104160 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80104160:	55                   	push   %ebp
80104161:	89 e5                	mov    %esp,%ebp
80104163:	56                   	push   %esi
80104164:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104165:	e8 a6 08 00 00       	call   80104a10 <pushcli>
  c = mycpu();
8010416a:	e8 51 fa ff ff       	call   80103bc0 <mycpu>
  p = c->proc;
8010416f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104175:	e8 a6 09 00 00       	call   80104b20 <popcli>
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
8010417a:	83 ec 0c             	sub    $0xc,%esp
8010417d:	68 40 3d 11 80       	push   $0x80113d40
80104182:	e8 49 08 00 00       	call   801049d0 <holding>
80104187:	83 c4 10             	add    $0x10,%esp
8010418a:	85 c0                	test   %eax,%eax
8010418c:	74 4f                	je     801041dd <sched+0x7d>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
8010418e:	e8 2d fa ff ff       	call   80103bc0 <mycpu>
80104193:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010419a:	75 68                	jne    80104204 <sched+0xa4>
    panic("sched locks");
  if(p->state == RUNNING)
8010419c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801041a0:	74 55                	je     801041f7 <sched+0x97>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801041a2:	9c                   	pushf  
801041a3:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
801041a4:	f6 c4 02             	test   $0x2,%ah
801041a7:	75 41                	jne    801041ea <sched+0x8a>
    panic("sched interruptible");
  intena = mycpu()->intena;
801041a9:	e8 12 fa ff ff       	call   80103bc0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801041ae:	83 c3 1c             	add    $0x1c,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
801041b1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801041b7:	e8 04 fa ff ff       	call   80103bc0 <mycpu>
801041bc:	83 ec 08             	sub    $0x8,%esp
801041bf:	ff 70 04             	pushl  0x4(%eax)
801041c2:	53                   	push   %ebx
801041c3:	e8 c0 0c 00 00       	call   80104e88 <swtch>
  mycpu()->intena = intena;
801041c8:	e8 f3 f9 ff ff       	call   80103bc0 <mycpu>
}
801041cd:	83 c4 10             	add    $0x10,%esp
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
801041d0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801041d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041d9:	5b                   	pop    %ebx
801041da:	5e                   	pop    %esi
801041db:	5d                   	pop    %ebp
801041dc:	c3                   	ret    
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
801041dd:	83 ec 0c             	sub    $0xc,%esp
801041e0:	68 70 82 10 80       	push   $0x80108270
801041e5:	e8 86 c1 ff ff       	call   80100370 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
801041ea:	83 ec 0c             	sub    $0xc,%esp
801041ed:	68 9c 82 10 80       	push   $0x8010829c
801041f2:	e8 79 c1 ff ff       	call   80100370 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
801041f7:	83 ec 0c             	sub    $0xc,%esp
801041fa:	68 8e 82 10 80       	push   $0x8010828e
801041ff:	e8 6c c1 ff ff       	call   80100370 <panic>
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
80104204:	83 ec 0c             	sub    $0xc,%esp
80104207:	68 82 82 10 80       	push   $0x80108282
8010420c:	e8 5f c1 ff ff       	call   80100370 <panic>
80104211:	eb 0d                	jmp    80104220 <exit>
80104213:	90                   	nop
80104214:	90                   	nop
80104215:	90                   	nop
80104216:	90                   	nop
80104217:	90                   	nop
80104218:	90                   	nop
80104219:	90                   	nop
8010421a:	90                   	nop
8010421b:	90                   	nop
8010421c:	90                   	nop
8010421d:	90                   	nop
8010421e:	90                   	nop
8010421f:	90                   	nop

80104220 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	57                   	push   %edi
80104224:	56                   	push   %esi
80104225:	53                   	push   %ebx
80104226:	83 ec 0c             	sub    $0xc,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104229:	e8 e2 07 00 00       	call   80104a10 <pushcli>
  c = mycpu();
8010422e:	e8 8d f9 ff ff       	call   80103bc0 <mycpu>
  p = c->proc;
80104233:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104239:	e8 e2 08 00 00       	call   80104b20 <popcli>
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
8010423e:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
80104244:	8d 5e 28             	lea    0x28(%esi),%ebx
80104247:	8d 7e 68             	lea    0x68(%esi),%edi
8010424a:	0f 84 f1 00 00 00    	je     80104341 <exit+0x121>
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
80104250:	8b 03                	mov    (%ebx),%eax
80104252:	85 c0                	test   %eax,%eax
80104254:	74 12                	je     80104268 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80104256:	83 ec 0c             	sub    $0xc,%esp
80104259:	50                   	push   %eax
8010425a:	e8 51 cc ff ff       	call   80100eb0 <fileclose>
      curproc->ofile[fd] = 0;
8010425f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104265:	83 c4 10             	add    $0x10,%esp
80104268:	83 c3 04             	add    $0x4,%ebx

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
8010426b:	39 df                	cmp    %ebx,%edi
8010426d:	75 e1                	jne    80104250 <exit+0x30>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
8010426f:	e8 3c ed ff ff       	call   80102fb0 <begin_op>
  iput(curproc->cwd);
80104274:	83 ec 0c             	sub    $0xc,%esp
80104277:	ff 76 68             	pushl  0x68(%esi)
8010427a:	e8 a1 d5 ff ff       	call   80101820 <iput>
  end_op();
8010427f:	e8 9c ed ff ff       	call   80103020 <end_op>
  curproc->cwd = 0;
80104284:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)

  acquire(&ptable.lock);
8010428b:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80104292:	e8 b9 07 00 00       	call   80104a50 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80104297:	8b 56 14             	mov    0x14(%esi),%edx
8010429a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010429d:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
801042a2:	eb 10                	jmp    801042b4 <exit+0x94>
801042a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042a8:	05 54 02 00 00       	add    $0x254,%eax
801042ad:	3d 74 d2 11 80       	cmp    $0x8011d274,%eax
801042b2:	74 1e                	je     801042d2 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
801042b4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801042b8:	75 ee                	jne    801042a8 <exit+0x88>
801042ba:	3b 50 20             	cmp    0x20(%eax),%edx
801042bd:	75 e9                	jne    801042a8 <exit+0x88>
      p->state = RUNNABLE;
801042bf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042c6:	05 54 02 00 00       	add    $0x254,%eax
801042cb:	3d 74 d2 11 80       	cmp    $0x8011d274,%eax
801042d0:	75 e2                	jne    801042b4 <exit+0x94>
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
801042d2:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
801042d8:	ba 74 3d 11 80       	mov    $0x80113d74,%edx
801042dd:	eb 0f                	jmp    801042ee <exit+0xce>
801042df:	90                   	nop

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042e0:	81 c2 54 02 00 00    	add    $0x254,%edx
801042e6:	81 fa 74 d2 11 80    	cmp    $0x8011d274,%edx
801042ec:	74 3a                	je     80104328 <exit+0x108>
    if(p->parent == curproc){
801042ee:	39 72 14             	cmp    %esi,0x14(%edx)
801042f1:	75 ed                	jne    801042e0 <exit+0xc0>
      p->parent = initproc;
      if(p->state == ZOMBIE)
801042f3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
801042f7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801042fa:	75 e4                	jne    801042e0 <exit+0xc0>
801042fc:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
80104301:	eb 11                	jmp    80104314 <exit+0xf4>
80104303:	90                   	nop
80104304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104308:	05 54 02 00 00       	add    $0x254,%eax
8010430d:	3d 74 d2 11 80       	cmp    $0x8011d274,%eax
80104312:	74 cc                	je     801042e0 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80104314:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104318:	75 ee                	jne    80104308 <exit+0xe8>
8010431a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010431d:	75 e9                	jne    80104308 <exit+0xe8>
      p->state = RUNNABLE;
8010431f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104326:	eb e0                	jmp    80104308 <exit+0xe8>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80104328:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
8010432f:	e8 2c fe ff ff       	call   80104160 <sched>
  panic("zombie exit");
80104334:	83 ec 0c             	sub    $0xc,%esp
80104337:	68 bd 82 10 80       	push   $0x801082bd
8010433c:	e8 2f c0 ff ff       	call   80100370 <panic>
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");
80104341:	83 ec 0c             	sub    $0xc,%esp
80104344:	68 b0 82 10 80       	push   $0x801082b0
80104349:	e8 22 c0 ff ff       	call   80100370 <panic>
8010434e:	66 90                	xchg   %ax,%ax

80104350 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	53                   	push   %ebx
80104354:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104357:	68 40 3d 11 80       	push   $0x80113d40
8010435c:	e8 ef 06 00 00       	call   80104a50 <acquire>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104361:	e8 aa 06 00 00       	call   80104a10 <pushcli>
  c = mycpu();
80104366:	e8 55 f8 ff ff       	call   80103bc0 <mycpu>
  p = c->proc;
8010436b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104371:	e8 aa 07 00 00       	call   80104b20 <popcli>
// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
80104376:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010437d:	e8 de fd ff ff       	call   80104160 <sched>
  release(&ptable.lock);
80104382:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80104389:	e8 02 08 00 00       	call   80104b90 <release>
}
8010438e:	83 c4 10             	add    $0x10,%esp
80104391:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104394:	c9                   	leave  
80104395:	c3                   	ret    
80104396:	8d 76 00             	lea    0x0(%esi),%esi
80104399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043a0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	57                   	push   %edi
801043a4:	56                   	push   %esi
801043a5:	53                   	push   %ebx
801043a6:	83 ec 0c             	sub    $0xc,%esp
801043a9:	8b 7d 08             	mov    0x8(%ebp),%edi
801043ac:	8b 75 0c             	mov    0xc(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801043af:	e8 5c 06 00 00       	call   80104a10 <pushcli>
  c = mycpu();
801043b4:	e8 07 f8 ff ff       	call   80103bc0 <mycpu>
  p = c->proc;
801043b9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043bf:	e8 5c 07 00 00       	call   80104b20 <popcli>
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
801043c4:	85 db                	test   %ebx,%ebx
801043c6:	0f 84 87 00 00 00    	je     80104453 <sleep+0xb3>
    panic("sleep");

  if(lk == 0)
801043cc:	85 f6                	test   %esi,%esi
801043ce:	74 76                	je     80104446 <sleep+0xa6>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
801043d0:	81 fe 40 3d 11 80    	cmp    $0x80113d40,%esi
801043d6:	74 50                	je     80104428 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801043d8:	83 ec 0c             	sub    $0xc,%esp
801043db:	68 40 3d 11 80       	push   $0x80113d40
801043e0:	e8 6b 06 00 00       	call   80104a50 <acquire>
    release(lk);
801043e5:	89 34 24             	mov    %esi,(%esp)
801043e8:	e8 a3 07 00 00       	call   80104b90 <release>
  }
  // Go to sleep.
  p->chan = chan;
801043ed:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801043f0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
801043f7:	e8 64 fd ff ff       	call   80104160 <sched>

  // Tidy up.
  p->chan = 0;
801043fc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80104403:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
8010440a:	e8 81 07 00 00       	call   80104b90 <release>
    acquire(lk);
8010440f:	89 75 08             	mov    %esi,0x8(%ebp)
80104412:	83 c4 10             	add    $0x10,%esp
  }
}
80104415:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104418:	5b                   	pop    %ebx
80104419:	5e                   	pop    %esi
8010441a:	5f                   	pop    %edi
8010441b:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
8010441c:	e9 2f 06 00 00       	jmp    80104a50 <acquire>
80104421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
80104428:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010442b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80104432:	e8 29 fd ff ff       	call   80104160 <sched>

  // Tidy up.
  p->chan = 0;
80104437:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
8010443e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104441:	5b                   	pop    %ebx
80104442:	5e                   	pop    %esi
80104443:	5f                   	pop    %edi
80104444:	5d                   	pop    %ebp
80104445:	c3                   	ret    
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80104446:	83 ec 0c             	sub    $0xc,%esp
80104449:	68 cf 82 10 80       	push   $0x801082cf
8010444e:	e8 1d bf ff ff       	call   80100370 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");
80104453:	83 ec 0c             	sub    $0xc,%esp
80104456:	68 c9 82 10 80       	push   $0x801082c9
8010445b:	e8 10 bf ff ff       	call   80100370 <panic>

80104460 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	56                   	push   %esi
80104464:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104465:	e8 a6 05 00 00       	call   80104a10 <pushcli>
  c = mycpu();
8010446a:	e8 51 f7 ff ff       	call   80103bc0 <mycpu>
  p = c->proc;
8010446f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104475:	e8 a6 06 00 00       	call   80104b20 <popcli>
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
8010447a:	83 ec 0c             	sub    $0xc,%esp
8010447d:	68 40 3d 11 80       	push   $0x80113d40
80104482:	e8 c9 05 00 00       	call   80104a50 <acquire>
80104487:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
8010448a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010448c:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
80104491:	eb 13                	jmp    801044a6 <wait+0x46>
80104493:	90                   	nop
80104494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104498:	81 c3 54 02 00 00    	add    $0x254,%ebx
8010449e:	81 fb 74 d2 11 80    	cmp    $0x8011d274,%ebx
801044a4:	74 22                	je     801044c8 <wait+0x68>
      if(p->parent != curproc)
801044a6:	39 73 14             	cmp    %esi,0x14(%ebx)
801044a9:	75 ed                	jne    80104498 <wait+0x38>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
801044ab:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801044af:	74 39                	je     801044ea <wait+0x8a>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044b1:	81 c3 54 02 00 00    	add    $0x254,%ebx
      if(p->parent != curproc)
        continue;
      havekids = 1;
801044b7:	b8 01 00 00 00       	mov    $0x1,%eax
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044bc:	81 fb 74 d2 11 80    	cmp    $0x8011d274,%ebx
801044c2:	75 e2                	jne    801044a6 <wait+0x46>
801044c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
801044c8:	85 c0                	test   %eax,%eax
801044ca:	0f 84 80 00 00 00    	je     80104550 <wait+0xf0>
801044d0:	8b 46 24             	mov    0x24(%esi),%eax
801044d3:	85 c0                	test   %eax,%eax
801044d5:	75 79                	jne    80104550 <wait+0xf0>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801044d7:	83 ec 08             	sub    $0x8,%esp
801044da:	68 40 3d 11 80       	push   $0x80113d40
801044df:	56                   	push   %esi
801044e0:	e8 bb fe ff ff       	call   801043a0 <sleep>
  }
801044e5:	83 c4 10             	add    $0x10,%esp
801044e8:	eb a0                	jmp    8010448a <wait+0x2a>
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;

        #ifndef NONE
        if(!removeSwapFile(p)){
801044ea:	83 ec 0c             	sub    $0xc,%esp
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
801044ed:	8b 73 10             	mov    0x10(%ebx),%esi

        #ifndef NONE
        if(!removeSwapFile(p)){
801044f0:	53                   	push   %ebx
801044f1:	e8 2a db ff ff       	call   80102020 <removeSwapFile>
801044f6:	83 c4 10             	add    $0x10,%esp
801044f9:	85 c0                	test   %eax,%eax
801044fb:	74 6f                	je     8010456c <wait+0x10c>
          p->num_of_page_faults, p->num_of_total_swap_out_actions);
        #endif

        #endif

        kfree(p->kstack);
801044fd:	83 ec 0c             	sub    $0xc,%esp
80104500:	ff 73 08             	pushl  0x8(%ebx)
80104503:	e8 f8 e1 ff ff       	call   80102700 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80104508:	5a                   	pop    %edx
80104509:	ff 73 04             	pushl  0x4(%ebx)
        #endif

        #endif

        kfree(p->kstack);
        p->kstack = 0;
8010450c:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104513:	e8 78 2f 00 00       	call   80107490 <freevm>
        p->pid = 0;
80104518:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010451f:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104526:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
8010452a:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104531:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104538:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
8010453f:	e8 4c 06 00 00       	call   80104b90 <release>
        return pid;
80104544:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104547:	8d 65 f8             	lea    -0x8(%ebp),%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
8010454a:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
8010454c:	5b                   	pop    %ebx
8010454d:	5e                   	pop    %esi
8010454e:	5d                   	pop    %ebp
8010454f:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
80104550:	83 ec 0c             	sub    $0xc,%esp
80104553:	68 40 3d 11 80       	push   $0x80113d40
80104558:	e8 33 06 00 00       	call   80104b90 <release>
      return -1;
8010455d:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104560:	8d 65 f8             	lea    -0x8(%ebp),%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
80104563:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104568:	5b                   	pop    %ebx
80104569:	5e                   	pop    %esi
8010456a:	5d                   	pop    %ebp
8010456b:	c3                   	ret    
        // Found one.
        pid = p->pid;

        #ifndef NONE
        if(!removeSwapFile(p)){
          panic("wait: remove swapfile failed");
8010456c:	83 ec 0c             	sub    $0xc,%esp
8010456f:	68 e0 82 10 80       	push   $0x801082e0
80104574:	e8 f7 bd ff ff       	call   80100370 <panic>
80104579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104580 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104580:	55                   	push   %ebp
80104581:	89 e5                	mov    %esp,%ebp
80104583:	53                   	push   %ebx
80104584:	83 ec 10             	sub    $0x10,%esp
80104587:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010458a:	68 40 3d 11 80       	push   $0x80113d40
8010458f:	e8 bc 04 00 00       	call   80104a50 <acquire>
80104594:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104597:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
8010459c:	eb 0e                	jmp    801045ac <wakeup+0x2c>
8010459e:	66 90                	xchg   %ax,%ax
801045a0:	05 54 02 00 00       	add    $0x254,%eax
801045a5:	3d 74 d2 11 80       	cmp    $0x8011d274,%eax
801045aa:	74 1e                	je     801045ca <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
801045ac:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801045b0:	75 ee                	jne    801045a0 <wakeup+0x20>
801045b2:	3b 58 20             	cmp    0x20(%eax),%ebx
801045b5:	75 e9                	jne    801045a0 <wakeup+0x20>
      p->state = RUNNABLE;
801045b7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801045be:	05 54 02 00 00       	add    $0x254,%eax
801045c3:	3d 74 d2 11 80       	cmp    $0x8011d274,%eax
801045c8:	75 e2                	jne    801045ac <wakeup+0x2c>
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
801045ca:	c7 45 08 40 3d 11 80 	movl   $0x80113d40,0x8(%ebp)
}
801045d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045d4:	c9                   	leave  
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
801045d5:	e9 b6 05 00 00       	jmp    80104b90 <release>
801045da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045e0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
801045e3:	53                   	push   %ebx
801045e4:	83 ec 10             	sub    $0x10,%esp
801045e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801045ea:	68 40 3d 11 80       	push   $0x80113d40
801045ef:	e8 5c 04 00 00       	call   80104a50 <acquire>
801045f4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045f7:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
801045fc:	eb 0e                	jmp    8010460c <kill+0x2c>
801045fe:	66 90                	xchg   %ax,%ax
80104600:	05 54 02 00 00       	add    $0x254,%eax
80104605:	3d 74 d2 11 80       	cmp    $0x8011d274,%eax
8010460a:	74 3c                	je     80104648 <kill+0x68>
    if(p->pid == pid){
8010460c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010460f:	75 ef                	jne    80104600 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104611:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80104615:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010461c:	74 1a                	je     80104638 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
8010461e:	83 ec 0c             	sub    $0xc,%esp
80104621:	68 40 3d 11 80       	push   $0x80113d40
80104626:	e8 65 05 00 00       	call   80104b90 <release>
      return 0;
8010462b:	83 c4 10             	add    $0x10,%esp
8010462e:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104630:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104633:	c9                   	leave  
80104634:	c3                   	ret    
80104635:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80104638:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010463f:	eb dd                	jmp    8010461e <kill+0x3e>
80104641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104648:	83 ec 0c             	sub    $0xc,%esp
8010464b:	68 40 3d 11 80       	push   $0x80113d40
80104650:	e8 3b 05 00 00       	call   80104b90 <release>
  return -1;
80104655:	83 c4 10             	add    $0x10,%esp
80104658:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010465d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104660:	c9                   	leave  
80104661:	c3                   	ret    
80104662:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104670 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	57                   	push   %edi
80104674:	56                   	push   %esi
80104675:	53                   	push   %ebx
80104676:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104679:	bb e0 3d 11 80       	mov    $0x80113de0,%ebx
8010467e:	83 ec 3c             	sub    $0x3c,%esp
80104681:	eb 27                	jmp    801046aa <procdump+0x3a>
80104683:	90                   	nop
80104684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104688:	83 ec 0c             	sub    $0xc,%esp
8010468b:	68 c3 87 10 80       	push   $0x801087c3
80104690:	e8 cb bf ff ff       	call   80100660 <cprintf>
80104695:	83 c4 10             	add    $0x10,%esp
80104698:	81 c3 54 02 00 00    	add    $0x254,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010469e:	81 fb e0 d2 11 80    	cmp    $0x8011d2e0,%ebx
801046a4:	0f 84 a6 00 00 00    	je     80104750 <procdump+0xe0>
    if(p->state == UNUSED)
801046aa:	8b 43 a0             	mov    -0x60(%ebx),%eax
801046ad:	85 c0                	test   %eax,%eax
801046af:	74 e7                	je     80104698 <procdump+0x28>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801046b1:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
801046b4:	ba fd 82 10 80       	mov    $0x801082fd,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801046b9:	77 11                	ja     801046cc <procdump+0x5c>
801046bb:	8b 14 85 a0 83 10 80 	mov    -0x7fef7c60(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
801046c2:	b8 fd 82 10 80       	mov    $0x801082fd,%eax
801046c7:	85 d2                	test   %edx,%edx
801046c9:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801046cc:	53                   	push   %ebx
801046cd:	52                   	push   %edx
801046ce:	ff 73 a4             	pushl  -0x5c(%ebx)
801046d1:	68 01 83 10 80       	push   $0x80108301
801046d6:	e8 85 bf ff ff       	call   80100660 <cprintf>

    #ifndef NONE
    cprintf("%d %d %d %d", p->num_of_pages_in_memory, p->num_of_currently_swapped_out_pages, 
801046db:	58                   	pop    %eax
801046dc:	ff 73 1c             	pushl  0x1c(%ebx)
801046df:	ff 73 20             	pushl  0x20(%ebx)
801046e2:	ff 73 18             	pushl  0x18(%ebx)
801046e5:	ff 73 14             	pushl  0x14(%ebx)
801046e8:	68 0a 83 10 80       	push   $0x8010830a
801046ed:	e8 6e bf ff ff       	call   80100660 <cprintf>
      p->num_of_page_faults, p->num_of_total_swap_out_actions);
    #endif

    if(p->state == SLEEPING){
801046f2:	83 c4 20             	add    $0x20,%esp
801046f5:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801046f9:	75 8d                	jne    80104688 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801046fb:	8d 45 c0             	lea    -0x40(%ebp),%eax
801046fe:	83 ec 08             	sub    $0x8,%esp
80104701:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104704:	50                   	push   %eax
80104705:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104708:	8b 40 0c             	mov    0xc(%eax),%eax
8010470b:	83 c0 08             	add    $0x8,%eax
8010470e:	50                   	push   %eax
8010470f:	e8 5c 02 00 00       	call   80104970 <getcallerpcs>
80104714:	83 c4 10             	add    $0x10,%esp
80104717:	89 f6                	mov    %esi,%esi
80104719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      for(i=0; i<10 && pc[i] != 0; i++)
80104720:	8b 17                	mov    (%edi),%edx
80104722:	85 d2                	test   %edx,%edx
80104724:	0f 84 5e ff ff ff    	je     80104688 <procdump+0x18>
        cprintf(" %p", pc[i]);
8010472a:	83 ec 08             	sub    $0x8,%esp
8010472d:	83 c7 04             	add    $0x4,%edi
80104730:	52                   	push   %edx
80104731:	68 c1 7c 10 80       	push   $0x80107cc1
80104736:	e8 25 bf ff ff       	call   80100660 <cprintf>
      p->num_of_page_faults, p->num_of_total_swap_out_actions);
    #endif

    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
8010473b:	83 c4 10             	add    $0x10,%esp
8010473e:	39 f7                	cmp    %esi,%edi
80104740:	75 de                	jne    80104720 <procdump+0xb0>
80104742:	e9 41 ff ff ff       	jmp    80104688 <procdump+0x18>
80104747:	89 f6                	mov    %esi,%esi
80104749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    }
    cprintf("\n");
  }

  #ifndef NONE
  cprintf("%d / %d free pages in the system\n", freePages, totalPages);
80104750:	83 ec 04             	sub    $0x4,%esp
80104753:	ff 35 7c 36 11 80    	pushl  0x8011367c
80104759:	ff 35 80 36 11 80    	pushl  0x80113680
8010475f:	68 7c 83 10 80       	push   $0x8010837c
80104764:	e8 f7 be ff ff       	call   80100660 <cprintf>
  #endif
}
80104769:	83 c4 10             	add    $0x10,%esp
8010476c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010476f:	5b                   	pop    %ebx
80104770:	5e                   	pop    %esi
80104771:	5f                   	pop    %edi
80104772:	5d                   	pop    %ebp
80104773:	c3                   	ret    
80104774:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010477a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104780 <updateNFUA>:

void updateNFUA(){
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	57                   	push   %edi
80104784:	56                   	push   %esi
80104785:	53                   	push   %ebx
80104786:	bb e0 3d 11 80       	mov    $0x80113de0,%ebx
8010478b:	83 ec 0c             	sub    $0xc,%esp
8010478e:	eb 12                	jmp    801047a2 <updateNFUA+0x22>
80104790:	81 c3 54 02 00 00    	add    $0x254,%ebx
  struct proc* p;
  int i;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104796:	81 fb e0 d2 11 80    	cmp    $0x8011d2e0,%ebx
8010479c:	0f 84 86 00 00 00    	je     80104828 <updateNFUA+0xa8>
    if((p->state == RUNNING || p->state == RUNNABLE || p->state == SLEEPING)
801047a2:	8b 43 a0             	mov    -0x60(%ebx),%eax
801047a5:	83 e8 02             	sub    $0x2,%eax
801047a8:	83 f8 02             	cmp    $0x2,%eax
801047ab:	77 e3                	ja     80104790 <updateNFUA+0x10>
      && (strcmp(p->name, "init") && strcmp(p->name, "sh"))){
801047ad:	83 ec 08             	sub    $0x8,%esp
801047b0:	68 50 82 10 80       	push   $0x80108250
801047b5:	53                   	push   %ebx
801047b6:	e8 85 06 00 00       	call   80104e40 <strcmp>
801047bb:	83 c4 10             	add    $0x10,%esp
801047be:	85 c0                	test   %eax,%eax
801047c0:	74 ce                	je     80104790 <updateNFUA+0x10>
801047c2:	83 ec 08             	sub    $0x8,%esp
801047c5:	68 55 82 10 80       	push   $0x80108255
801047ca:	53                   	push   %ebx
801047cb:	e8 70 06 00 00       	call   80104e40 <strcmp>
801047d0:	83 c4 10             	add    $0x10,%esp
801047d3:	85 c0                	test   %eax,%eax
801047d5:	74 b9                	je     80104790 <updateNFUA+0x10>
801047d7:	8d b3 ac 00 00 00    	lea    0xac(%ebx),%esi
801047dd:	8d bb ec 01 00 00    	lea    0x1ec(%ebx),%edi
801047e3:	eb 0a                	jmp    801047ef <updateNFUA+0x6f>
801047e5:	8d 76 00             	lea    0x0(%esi),%esi
801047e8:	83 c6 14             	add    $0x14,%esi
      for(i = 0 ; i < MAX_PSYC_PAGES ; i++){
801047eb:	39 fe                	cmp    %edi,%esi
801047ed:	74 a1                	je     80104790 <updateNFUA+0x10>
        if(p->mem_pages[i].in_mem){
801047ef:	80 7e 08 00          	cmpb   $0x0,0x8(%esi)
801047f3:	74 f3                	je     801047e8 <updateNFUA+0x68>
          pte_t* pte = walkpgdir_noalloc(p->pgdir, p->mem_pages[i].va);
801047f5:	83 ec 08             	sub    $0x8,%esp
801047f8:	ff 76 04             	pushl  0x4(%esi)
801047fb:	ff 73 98             	pushl  -0x68(%ebx)
801047fe:	e8 ad 29 00 00       	call   801071b0 <walkpgdir_noalloc>

          if(!pte){
80104803:	83 c4 10             	add    $0x10,%esp
80104806:	85 c0                	test   %eax,%eax
80104808:	74 26                	je     80104830 <updateNFUA+0xb0>
            panic("updateNFUA failed");
          }

          p->mem_pages[i].aging = p->mem_pages[i].aging >> 1;
8010480a:	8b 16                	mov    (%esi),%edx
8010480c:	d1 ea                	shr    %edx
8010480e:	89 16                	mov    %edx,(%esi)
          if(*pte & PTE_A){
80104810:	f6 00 20             	testb  $0x20,(%eax)
80104813:	74 d3                	je     801047e8 <updateNFUA+0x68>
            p->mem_pages[i].aging |= 0x80000000;
80104815:	81 ca 00 00 00 80    	or     $0x80000000,%edx
8010481b:	89 16                	mov    %edx,(%esi)

            /// turn off the access bit
            *pte = *pte & ~PTE_A;
8010481d:	83 20 df             	andl   $0xffffffdf,(%eax)
80104820:	eb c6                	jmp    801047e8 <updateNFUA+0x68>
80104822:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          }
        }
      }
    }
  }
}
80104828:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010482b:	5b                   	pop    %ebx
8010482c:	5e                   	pop    %esi
8010482d:	5f                   	pop    %edi
8010482e:	5d                   	pop    %ebp
8010482f:	c3                   	ret    
      for(i = 0 ; i < MAX_PSYC_PAGES ; i++){
        if(p->mem_pages[i].in_mem){
          pte_t* pte = walkpgdir_noalloc(p->pgdir, p->mem_pages[i].va);

          if(!pte){
            panic("updateNFUA failed");
80104830:	83 ec 0c             	sub    $0xc,%esp
80104833:	68 16 83 10 80       	push   $0x80108316
80104838:	e8 33 bb ff ff       	call   80100370 <panic>
8010483d:	66 90                	xchg   %ax,%ax
8010483f:	90                   	nop

80104840 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	53                   	push   %ebx
80104844:	83 ec 0c             	sub    $0xc,%esp
80104847:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010484a:	68 b8 83 10 80       	push   $0x801083b8
8010484f:	8d 43 04             	lea    0x4(%ebx),%eax
80104852:	50                   	push   %eax
80104853:	e8 f8 00 00 00       	call   80104950 <initlock>
  lk->name = name;
80104858:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010485b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104861:	83 c4 10             	add    $0x10,%esp
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
80104864:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
8010486b:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
8010486e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104871:	c9                   	leave  
80104872:	c3                   	ret    
80104873:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104880 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104880:	55                   	push   %ebp
80104881:	89 e5                	mov    %esp,%ebp
80104883:	56                   	push   %esi
80104884:	53                   	push   %ebx
80104885:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104888:	83 ec 0c             	sub    $0xc,%esp
8010488b:	8d 73 04             	lea    0x4(%ebx),%esi
8010488e:	56                   	push   %esi
8010488f:	e8 bc 01 00 00       	call   80104a50 <acquire>
  while (lk->locked) {
80104894:	8b 13                	mov    (%ebx),%edx
80104896:	83 c4 10             	add    $0x10,%esp
80104899:	85 d2                	test   %edx,%edx
8010489b:	74 16                	je     801048b3 <acquiresleep+0x33>
8010489d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801048a0:	83 ec 08             	sub    $0x8,%esp
801048a3:	56                   	push   %esi
801048a4:	53                   	push   %ebx
801048a5:	e8 f6 fa ff ff       	call   801043a0 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
801048aa:	8b 03                	mov    (%ebx),%eax
801048ac:	83 c4 10             	add    $0x10,%esp
801048af:	85 c0                	test   %eax,%eax
801048b1:	75 ed                	jne    801048a0 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
801048b3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801048b9:	e8 a2 f3 ff ff       	call   80103c60 <myproc>
801048be:	8b 40 10             	mov    0x10(%eax),%eax
801048c1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801048c4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801048c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048ca:	5b                   	pop    %ebx
801048cb:	5e                   	pop    %esi
801048cc:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
801048cd:	e9 be 02 00 00       	jmp    80104b90 <release>
801048d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048e0 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	56                   	push   %esi
801048e4:	53                   	push   %ebx
801048e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801048e8:	83 ec 0c             	sub    $0xc,%esp
801048eb:	8d 73 04             	lea    0x4(%ebx),%esi
801048ee:	56                   	push   %esi
801048ef:	e8 5c 01 00 00       	call   80104a50 <acquire>
  lk->locked = 0;
801048f4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801048fa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104901:	89 1c 24             	mov    %ebx,(%esp)
80104904:	e8 77 fc ff ff       	call   80104580 <wakeup>
  release(&lk->lk);
80104909:	89 75 08             	mov    %esi,0x8(%ebp)
8010490c:	83 c4 10             	add    $0x10,%esp
}
8010490f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104912:	5b                   	pop    %ebx
80104913:	5e                   	pop    %esi
80104914:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104915:	e9 76 02 00 00       	jmp    80104b90 <release>
8010491a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104920 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
80104920:	55                   	push   %ebp
80104921:	89 e5                	mov    %esp,%ebp
80104923:	56                   	push   %esi
80104924:	53                   	push   %ebx
80104925:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80104928:	83 ec 0c             	sub    $0xc,%esp
8010492b:	8d 5e 04             	lea    0x4(%esi),%ebx
8010492e:	53                   	push   %ebx
8010492f:	e8 1c 01 00 00       	call   80104a50 <acquire>
  r = lk->locked;
80104934:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
80104936:	89 1c 24             	mov    %ebx,(%esp)
80104939:	e8 52 02 00 00       	call   80104b90 <release>
  return r;
}
8010493e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104941:	89 f0                	mov    %esi,%eax
80104943:	5b                   	pop    %ebx
80104944:	5e                   	pop    %esi
80104945:	5d                   	pop    %ebp
80104946:	c3                   	ret    
80104947:	66 90                	xchg   %ax,%ax
80104949:	66 90                	xchg   %ax,%ax
8010494b:	66 90                	xchg   %ax,%ax
8010494d:	66 90                	xchg   %ax,%ax
8010494f:	90                   	nop

80104950 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104956:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104959:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
8010495f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104962:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104969:	5d                   	pop    %ebp
8010496a:	c3                   	ret    
8010496b:	90                   	nop
8010496c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104970 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104974:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104977:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010497a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010497d:	31 c0                	xor    %eax,%eax
8010497f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104980:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104986:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010498c:	77 1a                	ja     801049a8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010498e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104991:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104994:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104997:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104999:	83 f8 0a             	cmp    $0xa,%eax
8010499c:	75 e2                	jne    80104980 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010499e:	5b                   	pop    %ebx
8010499f:	5d                   	pop    %ebp
801049a0:	c3                   	ret    
801049a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801049a8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801049af:	83 c0 01             	add    $0x1,%eax
801049b2:	83 f8 0a             	cmp    $0xa,%eax
801049b5:	74 e7                	je     8010499e <getcallerpcs+0x2e>
    pcs[i] = 0;
801049b7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801049be:	83 c0 01             	add    $0x1,%eax
801049c1:	83 f8 0a             	cmp    $0xa,%eax
801049c4:	75 e2                	jne    801049a8 <getcallerpcs+0x38>
801049c6:	eb d6                	jmp    8010499e <getcallerpcs+0x2e>
801049c8:	90                   	nop
801049c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801049d0 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	53                   	push   %ebx
801049d4:	83 ec 04             	sub    $0x4,%esp
801049d7:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
801049da:	8b 02                	mov    (%edx),%eax
801049dc:	85 c0                	test   %eax,%eax
801049de:	75 10                	jne    801049f0 <holding+0x20>
}
801049e0:	83 c4 04             	add    $0x4,%esp
801049e3:	31 c0                	xor    %eax,%eax
801049e5:	5b                   	pop    %ebx
801049e6:	5d                   	pop    %ebp
801049e7:	c3                   	ret    
801049e8:	90                   	nop
801049e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
801049f0:	8b 5a 08             	mov    0x8(%edx),%ebx
801049f3:	e8 c8 f1 ff ff       	call   80103bc0 <mycpu>
801049f8:	39 c3                	cmp    %eax,%ebx
801049fa:	0f 94 c0             	sete   %al
}
801049fd:	83 c4 04             	add    $0x4,%esp

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104a00:	0f b6 c0             	movzbl %al,%eax
}
80104a03:	5b                   	pop    %ebx
80104a04:	5d                   	pop    %ebp
80104a05:	c3                   	ret    
80104a06:	8d 76 00             	lea    0x0(%esi),%esi
80104a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a10 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	53                   	push   %ebx
80104a14:	83 ec 04             	sub    $0x4,%esp
80104a17:	9c                   	pushf  
80104a18:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104a19:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104a1a:	e8 a1 f1 ff ff       	call   80103bc0 <mycpu>
80104a1f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104a25:	85 c0                	test   %eax,%eax
80104a27:	75 11                	jne    80104a3a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104a29:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104a2f:	e8 8c f1 ff ff       	call   80103bc0 <mycpu>
80104a34:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104a3a:	e8 81 f1 ff ff       	call   80103bc0 <mycpu>
80104a3f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104a46:	83 c4 04             	add    $0x4,%esp
80104a49:	5b                   	pop    %ebx
80104a4a:	5d                   	pop    %ebp
80104a4b:	c3                   	ret    
80104a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a50 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	56                   	push   %esi
80104a54:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104a55:	e8 b6 ff ff ff       	call   80104a10 <pushcli>
  if(holding(lk)){
80104a5a:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104a5d:	8b 03                	mov    (%ebx),%eax
80104a5f:	85 c0                	test   %eax,%eax
80104a61:	75 7d                	jne    80104ae0 <acquire+0x90>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104a63:	ba 01 00 00 00       	mov    $0x1,%edx
80104a68:	eb 09                	jmp    80104a73 <acquire+0x23>
80104a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a70:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104a73:	89 d0                	mov    %edx,%eax
80104a75:	f0 87 03             	lock xchg %eax,(%ebx)
    cprintf("lk->name = %s, proc name: %s\n", lk->name, mycpu()->proc->name);
    panic("acquire");
  }

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104a78:	85 c0                	test   %eax,%eax
80104a7a:	75 f4                	jne    80104a70 <acquire+0x20>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80104a7c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104a81:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104a84:	e8 37 f1 ff ff       	call   80103bc0 <mycpu>
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104a89:	89 ea                	mov    %ebp,%edx
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
80104a8b:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104a8e:	89 43 08             	mov    %eax,0x8(%ebx)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104a91:	31 c0                	xor    %eax,%eax
80104a93:	90                   	nop
80104a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104a98:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104a9e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104aa4:	77 1a                	ja     80104ac0 <acquire+0x70>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104aa6:	8b 5a 04             	mov    0x4(%edx),%ebx
80104aa9:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104aac:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104aaf:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104ab1:	83 f8 0a             	cmp    $0xa,%eax
80104ab4:	75 e2                	jne    80104a98 <acquire+0x48>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
}
80104ab6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ab9:	5b                   	pop    %ebx
80104aba:	5e                   	pop    %esi
80104abb:	5d                   	pop    %ebp
80104abc:	c3                   	ret    
80104abd:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104ac0:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104ac7:	83 c0 01             	add    $0x1,%eax
80104aca:	83 f8 0a             	cmp    $0xa,%eax
80104acd:	74 e7                	je     80104ab6 <acquire+0x66>
    pcs[i] = 0;
80104acf:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104ad6:	83 c0 01             	add    $0x1,%eax
80104ad9:	83 f8 0a             	cmp    $0xa,%eax
80104adc:	75 e2                	jne    80104ac0 <acquire+0x70>
80104ade:	eb d6                	jmp    80104ab6 <acquire+0x66>

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104ae0:	8b 73 08             	mov    0x8(%ebx),%esi
80104ae3:	e8 d8 f0 ff ff       	call   80103bc0 <mycpu>
80104ae8:	39 c6                	cmp    %eax,%esi
80104aea:	0f 85 73 ff ff ff    	jne    80104a63 <acquire+0x13>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk)){
    cprintf("lk->name = %s, proc name: %s\n", lk->name, mycpu()->proc->name);
80104af0:	e8 cb f0 ff ff       	call   80103bc0 <mycpu>
80104af5:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104afb:	83 ec 04             	sub    $0x4,%esp
80104afe:	83 c0 6c             	add    $0x6c,%eax
80104b01:	50                   	push   %eax
80104b02:	ff 73 04             	pushl  0x4(%ebx)
80104b05:	68 c3 83 10 80       	push   $0x801083c3
80104b0a:	e8 51 bb ff ff       	call   80100660 <cprintf>
    panic("acquire");
80104b0f:	c7 04 24 e1 83 10 80 	movl   $0x801083e1,(%esp)
80104b16:	e8 55 b8 ff ff       	call   80100370 <panic>
80104b1b:	90                   	nop
80104b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b20 <popcli>:
  mycpu()->ncli += 1;
}

void
popcli(void)
{
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104b26:	9c                   	pushf  
80104b27:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104b28:	f6 c4 02             	test   $0x2,%ah
80104b2b:	75 52                	jne    80104b7f <popcli+0x5f>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104b2d:	e8 8e f0 ff ff       	call   80103bc0 <mycpu>
80104b32:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104b38:	8d 51 ff             	lea    -0x1(%ecx),%edx
80104b3b:	85 d2                	test   %edx,%edx
80104b3d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104b43:	78 2d                	js     80104b72 <popcli+0x52>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104b45:	e8 76 f0 ff ff       	call   80103bc0 <mycpu>
80104b4a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104b50:	85 d2                	test   %edx,%edx
80104b52:	74 0c                	je     80104b60 <popcli+0x40>
    sti();
}
80104b54:	c9                   	leave  
80104b55:	c3                   	ret    
80104b56:	8d 76 00             	lea    0x0(%esi),%esi
80104b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104b60:	e8 5b f0 ff ff       	call   80103bc0 <mycpu>
80104b65:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104b6b:	85 c0                	test   %eax,%eax
80104b6d:	74 e5                	je     80104b54 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
80104b6f:	fb                   	sti    
    sti();
}
80104b70:	c9                   	leave  
80104b71:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
80104b72:	83 ec 0c             	sub    $0xc,%esp
80104b75:	68 00 84 10 80       	push   $0x80108400
80104b7a:	e8 f1 b7 ff ff       	call   80100370 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
80104b7f:	83 ec 0c             	sub    $0xc,%esp
80104b82:	68 e9 83 10 80       	push   $0x801083e9
80104b87:	e8 e4 b7 ff ff       	call   80100370 <panic>
80104b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b90 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	56                   	push   %esi
80104b94:	53                   	push   %ebx
80104b95:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104b98:	8b 03                	mov    (%ebx),%eax
80104b9a:	85 c0                	test   %eax,%eax
80104b9c:	75 12                	jne    80104bb0 <release+0x20>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
80104b9e:	83 ec 0c             	sub    $0xc,%esp
80104ba1:	68 07 84 10 80       	push   $0x80108407
80104ba6:	e8 c5 b7 ff ff       	call   80100370 <panic>
80104bab:	90                   	nop
80104bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104bb0:	8b 73 08             	mov    0x8(%ebx),%esi
80104bb3:	e8 08 f0 ff ff       	call   80103bc0 <mycpu>
80104bb8:	39 c6                	cmp    %eax,%esi
80104bba:	75 e2                	jne    80104b9e <release+0xe>
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");

  lk->pcs[0] = 0;
80104bbc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104bc3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104bca:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104bcf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
80104bd5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104bd8:	5b                   	pop    %ebx
80104bd9:	5e                   	pop    %esi
80104bda:	5d                   	pop    %ebp
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
80104bdb:	e9 40 ff ff ff       	jmp    80104b20 <popcli>

80104be0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104be0:	55                   	push   %ebp
80104be1:	89 e5                	mov    %esp,%ebp
80104be3:	57                   	push   %edi
80104be4:	53                   	push   %ebx
80104be5:	8b 55 08             	mov    0x8(%ebp),%edx
80104be8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104beb:	f6 c2 03             	test   $0x3,%dl
80104bee:	75 05                	jne    80104bf5 <memset+0x15>
80104bf0:	f6 c1 03             	test   $0x3,%cl
80104bf3:	74 13                	je     80104c08 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104bf5:	89 d7                	mov    %edx,%edi
80104bf7:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bfa:	fc                   	cld    
80104bfb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104bfd:	5b                   	pop    %ebx
80104bfe:	89 d0                	mov    %edx,%eax
80104c00:	5f                   	pop    %edi
80104c01:	5d                   	pop    %ebp
80104c02:	c3                   	ret    
80104c03:	90                   	nop
80104c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104c08:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
80104c0c:	c1 e9 02             	shr    $0x2,%ecx
80104c0f:	89 fb                	mov    %edi,%ebx
80104c11:	89 f8                	mov    %edi,%eax
80104c13:	c1 e3 18             	shl    $0x18,%ebx
80104c16:	c1 e0 10             	shl    $0x10,%eax
80104c19:	09 d8                	or     %ebx,%eax
80104c1b:	09 f8                	or     %edi,%eax
80104c1d:	c1 e7 08             	shl    $0x8,%edi
80104c20:	09 f8                	or     %edi,%eax
80104c22:	89 d7                	mov    %edx,%edi
80104c24:	fc                   	cld    
80104c25:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104c27:	5b                   	pop    %ebx
80104c28:	89 d0                	mov    %edx,%eax
80104c2a:	5f                   	pop    %edi
80104c2b:	5d                   	pop    %ebp
80104c2c:	c3                   	ret    
80104c2d:	8d 76 00             	lea    0x0(%esi),%esi

80104c30 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	57                   	push   %edi
80104c34:	56                   	push   %esi
80104c35:	8b 45 10             	mov    0x10(%ebp),%eax
80104c38:	53                   	push   %ebx
80104c39:	8b 75 0c             	mov    0xc(%ebp),%esi
80104c3c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104c3f:	85 c0                	test   %eax,%eax
80104c41:	74 29                	je     80104c6c <memcmp+0x3c>
    if(*s1 != *s2)
80104c43:	0f b6 13             	movzbl (%ebx),%edx
80104c46:	0f b6 0e             	movzbl (%esi),%ecx
80104c49:	38 d1                	cmp    %dl,%cl
80104c4b:	75 2b                	jne    80104c78 <memcmp+0x48>
80104c4d:	8d 78 ff             	lea    -0x1(%eax),%edi
80104c50:	31 c0                	xor    %eax,%eax
80104c52:	eb 14                	jmp    80104c68 <memcmp+0x38>
80104c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c58:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
80104c5d:	83 c0 01             	add    $0x1,%eax
80104c60:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104c64:	38 ca                	cmp    %cl,%dl
80104c66:	75 10                	jne    80104c78 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104c68:	39 f8                	cmp    %edi,%eax
80104c6a:	75 ec                	jne    80104c58 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104c6c:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80104c6d:	31 c0                	xor    %eax,%eax
}
80104c6f:	5e                   	pop    %esi
80104c70:	5f                   	pop    %edi
80104c71:	5d                   	pop    %ebp
80104c72:	c3                   	ret    
80104c73:	90                   	nop
80104c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104c78:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
80104c7b:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104c7c:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
80104c7e:	5e                   	pop    %esi
80104c7f:	5f                   	pop    %edi
80104c80:	5d                   	pop    %ebp
80104c81:	c3                   	ret    
80104c82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c90 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	56                   	push   %esi
80104c94:	53                   	push   %ebx
80104c95:	8b 45 08             	mov    0x8(%ebp),%eax
80104c98:	8b 75 0c             	mov    0xc(%ebp),%esi
80104c9b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104c9e:	39 c6                	cmp    %eax,%esi
80104ca0:	73 2e                	jae    80104cd0 <memmove+0x40>
80104ca2:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104ca5:	39 c8                	cmp    %ecx,%eax
80104ca7:	73 27                	jae    80104cd0 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
80104ca9:	85 db                	test   %ebx,%ebx
80104cab:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104cae:	74 17                	je     80104cc7 <memmove+0x37>
      *--d = *--s;
80104cb0:	29 d9                	sub    %ebx,%ecx
80104cb2:	89 cb                	mov    %ecx,%ebx
80104cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104cb8:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104cbc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104cbf:	83 ea 01             	sub    $0x1,%edx
80104cc2:	83 fa ff             	cmp    $0xffffffff,%edx
80104cc5:	75 f1                	jne    80104cb8 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104cc7:	5b                   	pop    %ebx
80104cc8:	5e                   	pop    %esi
80104cc9:	5d                   	pop    %ebp
80104cca:	c3                   	ret    
80104ccb:	90                   	nop
80104ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104cd0:	31 d2                	xor    %edx,%edx
80104cd2:	85 db                	test   %ebx,%ebx
80104cd4:	74 f1                	je     80104cc7 <memmove+0x37>
80104cd6:	8d 76 00             	lea    0x0(%esi),%esi
80104cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
80104ce0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104ce4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104ce7:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104cea:	39 d3                	cmp    %edx,%ebx
80104cec:	75 f2                	jne    80104ce0 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
80104cee:	5b                   	pop    %ebx
80104cef:	5e                   	pop    %esi
80104cf0:	5d                   	pop    %ebp
80104cf1:	c3                   	ret    
80104cf2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d00 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104d00:	55                   	push   %ebp
80104d01:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104d03:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104d04:	eb 8a                	jmp    80104c90 <memmove>
80104d06:	8d 76 00             	lea    0x0(%esi),%esi
80104d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d10 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104d10:	55                   	push   %ebp
80104d11:	89 e5                	mov    %esp,%ebp
80104d13:	57                   	push   %edi
80104d14:	56                   	push   %esi
80104d15:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104d18:	53                   	push   %ebx
80104d19:	8b 7d 08             	mov    0x8(%ebp),%edi
80104d1c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104d1f:	85 c9                	test   %ecx,%ecx
80104d21:	74 37                	je     80104d5a <strncmp+0x4a>
80104d23:	0f b6 17             	movzbl (%edi),%edx
80104d26:	0f b6 1e             	movzbl (%esi),%ebx
80104d29:	84 d2                	test   %dl,%dl
80104d2b:	74 3f                	je     80104d6c <strncmp+0x5c>
80104d2d:	38 d3                	cmp    %dl,%bl
80104d2f:	75 3b                	jne    80104d6c <strncmp+0x5c>
80104d31:	8d 47 01             	lea    0x1(%edi),%eax
80104d34:	01 cf                	add    %ecx,%edi
80104d36:	eb 1b                	jmp    80104d53 <strncmp+0x43>
80104d38:	90                   	nop
80104d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d40:	0f b6 10             	movzbl (%eax),%edx
80104d43:	84 d2                	test   %dl,%dl
80104d45:	74 21                	je     80104d68 <strncmp+0x58>
80104d47:	0f b6 19             	movzbl (%ecx),%ebx
80104d4a:	83 c0 01             	add    $0x1,%eax
80104d4d:	89 ce                	mov    %ecx,%esi
80104d4f:	38 da                	cmp    %bl,%dl
80104d51:	75 19                	jne    80104d6c <strncmp+0x5c>
80104d53:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
80104d55:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104d58:	75 e6                	jne    80104d40 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104d5a:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
80104d5b:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
80104d5d:	5e                   	pop    %esi
80104d5e:	5f                   	pop    %edi
80104d5f:	5d                   	pop    %ebp
80104d60:	c3                   	ret    
80104d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d68:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104d6c:	0f b6 c2             	movzbl %dl,%eax
80104d6f:	29 d8                	sub    %ebx,%eax
}
80104d71:	5b                   	pop    %ebx
80104d72:	5e                   	pop    %esi
80104d73:	5f                   	pop    %edi
80104d74:	5d                   	pop    %ebp
80104d75:	c3                   	ret    
80104d76:	8d 76 00             	lea    0x0(%esi),%esi
80104d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d80 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104d80:	55                   	push   %ebp
80104d81:	89 e5                	mov    %esp,%ebp
80104d83:	56                   	push   %esi
80104d84:	53                   	push   %ebx
80104d85:	8b 45 08             	mov    0x8(%ebp),%eax
80104d88:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104d8b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104d8e:	89 c2                	mov    %eax,%edx
80104d90:	eb 19                	jmp    80104dab <strncpy+0x2b>
80104d92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d98:	83 c3 01             	add    $0x1,%ebx
80104d9b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104d9f:	83 c2 01             	add    $0x1,%edx
80104da2:	84 c9                	test   %cl,%cl
80104da4:	88 4a ff             	mov    %cl,-0x1(%edx)
80104da7:	74 09                	je     80104db2 <strncpy+0x32>
80104da9:	89 f1                	mov    %esi,%ecx
80104dab:	85 c9                	test   %ecx,%ecx
80104dad:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104db0:	7f e6                	jg     80104d98 <strncpy+0x18>
    ;
  while(n-- > 0)
80104db2:	31 c9                	xor    %ecx,%ecx
80104db4:	85 f6                	test   %esi,%esi
80104db6:	7e 17                	jle    80104dcf <strncpy+0x4f>
80104db8:	90                   	nop
80104db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104dc0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104dc4:	89 f3                	mov    %esi,%ebx
80104dc6:	83 c1 01             	add    $0x1,%ecx
80104dc9:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80104dcb:	85 db                	test   %ebx,%ebx
80104dcd:	7f f1                	jg     80104dc0 <strncpy+0x40>
    *s++ = 0;
  return os;
}
80104dcf:	5b                   	pop    %ebx
80104dd0:	5e                   	pop    %esi
80104dd1:	5d                   	pop    %ebp
80104dd2:	c3                   	ret    
80104dd3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104de0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
80104de3:	56                   	push   %esi
80104de4:	53                   	push   %ebx
80104de5:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104de8:	8b 45 08             	mov    0x8(%ebp),%eax
80104deb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104dee:	85 c9                	test   %ecx,%ecx
80104df0:	7e 26                	jle    80104e18 <safestrcpy+0x38>
80104df2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104df6:	89 c1                	mov    %eax,%ecx
80104df8:	eb 17                	jmp    80104e11 <safestrcpy+0x31>
80104dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104e00:	83 c2 01             	add    $0x1,%edx
80104e03:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104e07:	83 c1 01             	add    $0x1,%ecx
80104e0a:	84 db                	test   %bl,%bl
80104e0c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104e0f:	74 04                	je     80104e15 <safestrcpy+0x35>
80104e11:	39 f2                	cmp    %esi,%edx
80104e13:	75 eb                	jne    80104e00 <safestrcpy+0x20>
    ;
  *s = 0;
80104e15:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104e18:	5b                   	pop    %ebx
80104e19:	5e                   	pop    %esi
80104e1a:	5d                   	pop    %ebp
80104e1b:	c3                   	ret    
80104e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e20 <strlen>:

int
strlen(const char *s)
{
80104e20:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104e21:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104e23:	89 e5                	mov    %esp,%ebp
80104e25:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104e28:	80 3a 00             	cmpb   $0x0,(%edx)
80104e2b:	74 0c                	je     80104e39 <strlen+0x19>
80104e2d:	8d 76 00             	lea    0x0(%esi),%esi
80104e30:	83 c0 01             	add    $0x1,%eax
80104e33:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104e37:	75 f7                	jne    80104e30 <strlen+0x10>
    ;
  return n;
}
80104e39:	5d                   	pop    %ebp
80104e3a:	c3                   	ret    
80104e3b:	90                   	nop
80104e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e40 <strcmp>:

int
strcmp(const char *p, const char *q)
{
80104e40:	55                   	push   %ebp
80104e41:	89 e5                	mov    %esp,%ebp
80104e43:	56                   	push   %esi
80104e44:	53                   	push   %ebx
80104e45:	8b 55 08             	mov    0x8(%ebp),%edx
80104e48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
80104e4b:	0f b6 02             	movzbl (%edx),%eax
80104e4e:	0f b6 19             	movzbl (%ecx),%ebx
80104e51:	84 c0                	test   %al,%al
80104e53:	75 1e                	jne    80104e73 <strcmp+0x33>
80104e55:	eb 29                	jmp    80104e80 <strcmp+0x40>
80104e57:	89 f6                	mov    %esi,%esi
80104e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
80104e60:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
80104e63:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
80104e66:	8d 71 01             	lea    0x1(%ecx),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
80104e69:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
80104e6d:	84 c0                	test   %al,%al
80104e6f:	74 0f                	je     80104e80 <strcmp+0x40>
80104e71:	89 f1                	mov    %esi,%ecx
80104e73:	38 d8                	cmp    %bl,%al
80104e75:	74 e9                	je     80104e60 <strcmp+0x20>
    p++, q++;
  return (uchar)*p - (uchar)*q;
80104e77:	29 d8                	sub    %ebx,%eax
}
80104e79:	5b                   	pop    %ebx
80104e7a:	5e                   	pop    %esi
80104e7b:	5d                   	pop    %ebp
80104e7c:	c3                   	ret    
80104e7d:	8d 76 00             	lea    0x0(%esi),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
80104e80:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
80104e82:	29 d8                	sub    %ebx,%eax
}
80104e84:	5b                   	pop    %ebx
80104e85:	5e                   	pop    %esi
80104e86:	5d                   	pop    %ebp
80104e87:	c3                   	ret    

80104e88 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104e88:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104e8c:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104e90:	55                   	push   %ebp
  pushl %ebx
80104e91:	53                   	push   %ebx
  pushl %esi
80104e92:	56                   	push   %esi
  pushl %edi
80104e93:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104e94:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104e96:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104e98:	5f                   	pop    %edi
  popl %esi
80104e99:	5e                   	pop    %esi
  popl %ebx
80104e9a:	5b                   	pop    %ebx
  popl %ebp
80104e9b:	5d                   	pop    %ebp
  ret
80104e9c:	c3                   	ret    
80104e9d:	66 90                	xchg   %ax,%ax
80104e9f:	90                   	nop

80104ea0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	53                   	push   %ebx
80104ea4:	83 ec 04             	sub    $0x4,%esp
80104ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104eaa:	e8 b1 ed ff ff       	call   80103c60 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104eaf:	8b 00                	mov    (%eax),%eax
80104eb1:	39 d8                	cmp    %ebx,%eax
80104eb3:	76 1b                	jbe    80104ed0 <fetchint+0x30>
80104eb5:	8d 53 04             	lea    0x4(%ebx),%edx
80104eb8:	39 d0                	cmp    %edx,%eax
80104eba:	72 14                	jb     80104ed0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104ebc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ebf:	8b 13                	mov    (%ebx),%edx
80104ec1:	89 10                	mov    %edx,(%eax)
  return 0;
80104ec3:	31 c0                	xor    %eax,%eax
}
80104ec5:	83 c4 04             	add    $0x4,%esp
80104ec8:	5b                   	pop    %ebx
80104ec9:	5d                   	pop    %ebp
80104eca:	c3                   	ret    
80104ecb:	90                   	nop
80104ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104ed0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ed5:	eb ee                	jmp    80104ec5 <fetchint+0x25>
80104ed7:	89 f6                	mov    %esi,%esi
80104ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ee0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	53                   	push   %ebx
80104ee4:	83 ec 04             	sub    $0x4,%esp
80104ee7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104eea:	e8 71 ed ff ff       	call   80103c60 <myproc>

  if(addr >= curproc->sz)
80104eef:	39 18                	cmp    %ebx,(%eax)
80104ef1:	76 29                	jbe    80104f1c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104ef3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104ef6:	89 da                	mov    %ebx,%edx
80104ef8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104efa:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104efc:	39 c3                	cmp    %eax,%ebx
80104efe:	73 1c                	jae    80104f1c <fetchstr+0x3c>
    if(*s == 0)
80104f00:	80 3b 00             	cmpb   $0x0,(%ebx)
80104f03:	75 10                	jne    80104f15 <fetchstr+0x35>
80104f05:	eb 29                	jmp    80104f30 <fetchstr+0x50>
80104f07:	89 f6                	mov    %esi,%esi
80104f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104f10:	80 3a 00             	cmpb   $0x0,(%edx)
80104f13:	74 1b                	je     80104f30 <fetchstr+0x50>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
80104f15:	83 c2 01             	add    $0x1,%edx
80104f18:	39 d0                	cmp    %edx,%eax
80104f1a:	77 f4                	ja     80104f10 <fetchstr+0x30>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104f1c:	83 c4 04             	add    $0x4,%esp
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;
80104f1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104f24:	5b                   	pop    %ebx
80104f25:	5d                   	pop    %ebp
80104f26:	c3                   	ret    
80104f27:	89 f6                	mov    %esi,%esi
80104f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104f30:	83 c4 04             	add    $0x4,%esp
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
80104f33:	89 d0                	mov    %edx,%eax
80104f35:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104f37:	5b                   	pop    %ebx
80104f38:	5d                   	pop    %ebp
80104f39:	c3                   	ret    
80104f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104f40 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104f40:	55                   	push   %ebp
80104f41:	89 e5                	mov    %esp,%ebp
80104f43:	56                   	push   %esi
80104f44:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f45:	e8 16 ed ff ff       	call   80103c60 <myproc>
80104f4a:	8b 40 18             	mov    0x18(%eax),%eax
80104f4d:	8b 55 08             	mov    0x8(%ebp),%edx
80104f50:	8b 40 44             	mov    0x44(%eax),%eax
80104f53:	8d 1c 90             	lea    (%eax,%edx,4),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();
80104f56:	e8 05 ed ff ff       	call   80103c60 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f5b:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f5d:	8d 73 04             	lea    0x4(%ebx),%esi
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f60:	39 c6                	cmp    %eax,%esi
80104f62:	73 1c                	jae    80104f80 <argint+0x40>
80104f64:	8d 53 08             	lea    0x8(%ebx),%edx
80104f67:	39 d0                	cmp    %edx,%eax
80104f69:	72 15                	jb     80104f80 <argint+0x40>
    return -1;
  *ip = *(int*)(addr);
80104f6b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f6e:	8b 53 04             	mov    0x4(%ebx),%edx
80104f71:	89 10                	mov    %edx,(%eax)
  return 0;
80104f73:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
}
80104f75:	5b                   	pop    %ebx
80104f76:	5e                   	pop    %esi
80104f77:	5d                   	pop    %ebp
80104f78:	c3                   	ret    
80104f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104f80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f85:	eb ee                	jmp    80104f75 <argint+0x35>
80104f87:	89 f6                	mov    %esi,%esi
80104f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f90 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104f90:	55                   	push   %ebp
80104f91:	89 e5                	mov    %esp,%ebp
80104f93:	56                   	push   %esi
80104f94:	53                   	push   %ebx
80104f95:	83 ec 10             	sub    $0x10,%esp
80104f98:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104f9b:	e8 c0 ec ff ff       	call   80103c60 <myproc>
80104fa0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104fa2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fa5:	83 ec 08             	sub    $0x8,%esp
80104fa8:	50                   	push   %eax
80104fa9:	ff 75 08             	pushl  0x8(%ebp)
80104fac:	e8 8f ff ff ff       	call   80104f40 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104fb1:	c1 e8 1f             	shr    $0x1f,%eax
80104fb4:	83 c4 10             	add    $0x10,%esp
80104fb7:	84 c0                	test   %al,%al
80104fb9:	75 2d                	jne    80104fe8 <argptr+0x58>
80104fbb:	89 d8                	mov    %ebx,%eax
80104fbd:	c1 e8 1f             	shr    $0x1f,%eax
80104fc0:	84 c0                	test   %al,%al
80104fc2:	75 24                	jne    80104fe8 <argptr+0x58>
80104fc4:	8b 16                	mov    (%esi),%edx
80104fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fc9:	39 c2                	cmp    %eax,%edx
80104fcb:	76 1b                	jbe    80104fe8 <argptr+0x58>
80104fcd:	01 c3                	add    %eax,%ebx
80104fcf:	39 da                	cmp    %ebx,%edx
80104fd1:	72 15                	jb     80104fe8 <argptr+0x58>
    return -1;
  *pp = (char*)i;
80104fd3:	8b 55 0c             	mov    0xc(%ebp),%edx
80104fd6:	89 02                	mov    %eax,(%edx)
  return 0;
80104fd8:	31 c0                	xor    %eax,%eax
}
80104fda:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fdd:	5b                   	pop    %ebx
80104fde:	5e                   	pop    %esi
80104fdf:	5d                   	pop    %ebp
80104fe0:	c3                   	ret    
80104fe1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
80104fe8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fed:	eb eb                	jmp    80104fda <argptr+0x4a>
80104fef:	90                   	nop

80104ff0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104ff0:	55                   	push   %ebp
80104ff1:	89 e5                	mov    %esp,%ebp
80104ff3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104ff6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ff9:	50                   	push   %eax
80104ffa:	ff 75 08             	pushl  0x8(%ebp)
80104ffd:	e8 3e ff ff ff       	call   80104f40 <argint>
80105002:	83 c4 10             	add    $0x10,%esp
80105005:	85 c0                	test   %eax,%eax
80105007:	78 17                	js     80105020 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105009:	83 ec 08             	sub    $0x8,%esp
8010500c:	ff 75 0c             	pushl  0xc(%ebp)
8010500f:	ff 75 f4             	pushl  -0xc(%ebp)
80105012:	e8 c9 fe ff ff       	call   80104ee0 <fetchstr>
80105017:	83 c4 10             	add    $0x10,%esp
}
8010501a:	c9                   	leave  
8010501b:	c3                   	ret    
8010501c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80105020:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
80105025:	c9                   	leave  
80105026:	c3                   	ret    
80105027:	89 f6                	mov    %esi,%esi
80105029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105030 <syscall>:
[SYS_yield]   sys_yield,
};

void
syscall(void)
{
80105030:	55                   	push   %ebp
80105031:	89 e5                	mov    %esp,%ebp
80105033:	56                   	push   %esi
80105034:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80105035:	e8 26 ec ff ff       	call   80103c60 <myproc>

  num = curproc->tf->eax;
8010503a:	8b 70 18             	mov    0x18(%eax),%esi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
8010503d:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010503f:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105042:	8d 50 ff             	lea    -0x1(%eax),%edx
80105045:	83 fa 15             	cmp    $0x15,%edx
80105048:	77 1e                	ja     80105068 <syscall+0x38>
8010504a:	8b 14 85 40 84 10 80 	mov    -0x7fef7bc0(,%eax,4),%edx
80105051:	85 d2                	test   %edx,%edx
80105053:	74 13                	je     80105068 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80105055:	ff d2                	call   *%edx
80105057:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010505a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010505d:	5b                   	pop    %ebx
8010505e:	5e                   	pop    %esi
8010505f:	5d                   	pop    %ebp
80105060:	c3                   	ret    
80105061:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105068:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105069:	8d 43 6c             	lea    0x6c(%ebx),%eax

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
8010506c:	50                   	push   %eax
8010506d:	ff 73 10             	pushl  0x10(%ebx)
80105070:	68 0f 84 10 80       	push   $0x8010840f
80105075:	e8 e6 b5 ff ff       	call   80100660 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
8010507a:	8b 43 18             	mov    0x18(%ebx),%eax
8010507d:	83 c4 10             	add    $0x10,%esp
80105080:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105087:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010508a:	5b                   	pop    %ebx
8010508b:	5e                   	pop    %esi
8010508c:	5d                   	pop    %ebp
8010508d:	c3                   	ret    
8010508e:	66 90                	xchg   %ax,%ax

80105090 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80105090:	55                   	push   %ebp
80105091:	89 e5                	mov    %esp,%ebp
80105093:	56                   	push   %esi
80105094:	53                   	push   %ebx
80105095:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105097:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
8010509a:	89 d3                	mov    %edx,%ebx
8010509c:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010509f:	50                   	push   %eax
801050a0:	6a 00                	push   $0x0
801050a2:	e8 99 fe ff ff       	call   80104f40 <argint>
801050a7:	83 c4 10             	add    $0x10,%esp
801050aa:	85 c0                	test   %eax,%eax
801050ac:	78 32                	js     801050e0 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801050ae:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801050b2:	77 2c                	ja     801050e0 <argfd.constprop.0+0x50>
801050b4:	e8 a7 eb ff ff       	call   80103c60 <myproc>
801050b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050bc:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801050c0:	85 c0                	test   %eax,%eax
801050c2:	74 1c                	je     801050e0 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
801050c4:	85 f6                	test   %esi,%esi
801050c6:	74 02                	je     801050ca <argfd.constprop.0+0x3a>
    *pfd = fd;
801050c8:	89 16                	mov    %edx,(%esi)
  if(pf)
801050ca:	85 db                	test   %ebx,%ebx
801050cc:	74 22                	je     801050f0 <argfd.constprop.0+0x60>
    *pf = f;
801050ce:	89 03                	mov    %eax,(%ebx)
  return 0;
801050d0:	31 c0                	xor    %eax,%eax
}
801050d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050d5:	5b                   	pop    %ebx
801050d6:	5e                   	pop    %esi
801050d7:	5d                   	pop    %ebp
801050d8:	c3                   	ret    
801050d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
801050e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
801050e8:	5b                   	pop    %ebx
801050e9:	5e                   	pop    %esi
801050ea:	5d                   	pop    %ebp
801050eb:	c3                   	ret    
801050ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
801050f0:	31 c0                	xor    %eax,%eax
801050f2:	eb de                	jmp    801050d2 <argfd.constprop.0+0x42>
801050f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801050fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105100 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80105100:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105101:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80105103:	89 e5                	mov    %esp,%ebp
80105105:	56                   	push   %esi
80105106:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105107:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
8010510a:	83 ec 10             	sub    $0x10,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
8010510d:	e8 7e ff ff ff       	call   80105090 <argfd.constprop.0>
80105112:	85 c0                	test   %eax,%eax
80105114:	78 1a                	js     80105130 <sys_dup+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105116:	31 db                	xor    %ebx,%ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
80105118:	8b 75 f4             	mov    -0xc(%ebp),%esi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
8010511b:	e8 40 eb ff ff       	call   80103c60 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105120:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105124:	85 d2                	test   %edx,%edx
80105126:	74 18                	je     80105140 <sys_dup+0x40>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105128:	83 c3 01             	add    $0x1,%ebx
8010512b:	83 fb 10             	cmp    $0x10,%ebx
8010512e:	75 f0                	jne    80105120 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80105130:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80105133:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80105138:	5b                   	pop    %ebx
80105139:	5e                   	pop    %esi
8010513a:	5d                   	pop    %ebp
8010513b:	c3                   	ret    
8010513c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105140:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80105144:	83 ec 0c             	sub    $0xc,%esp
80105147:	ff 75 f4             	pushl  -0xc(%ebp)
8010514a:	e8 11 bd ff ff       	call   80100e60 <filedup>
  return fd;
8010514f:	83 c4 10             	add    $0x10,%esp
}
80105152:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
80105155:	89 d8                	mov    %ebx,%eax
}
80105157:	5b                   	pop    %ebx
80105158:	5e                   	pop    %esi
80105159:	5d                   	pop    %ebp
8010515a:	c3                   	ret    
8010515b:	90                   	nop
8010515c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105160 <sys_read>:

int
sys_read(void)
{
80105160:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105161:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80105163:	89 e5                	mov    %esp,%ebp
80105165:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105168:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010516b:	e8 20 ff ff ff       	call   80105090 <argfd.constprop.0>
80105170:	85 c0                	test   %eax,%eax
80105172:	78 4c                	js     801051c0 <sys_read+0x60>
80105174:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105177:	83 ec 08             	sub    $0x8,%esp
8010517a:	50                   	push   %eax
8010517b:	6a 02                	push   $0x2
8010517d:	e8 be fd ff ff       	call   80104f40 <argint>
80105182:	83 c4 10             	add    $0x10,%esp
80105185:	85 c0                	test   %eax,%eax
80105187:	78 37                	js     801051c0 <sys_read+0x60>
80105189:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010518c:	83 ec 04             	sub    $0x4,%esp
8010518f:	ff 75 f0             	pushl  -0x10(%ebp)
80105192:	50                   	push   %eax
80105193:	6a 01                	push   $0x1
80105195:	e8 f6 fd ff ff       	call   80104f90 <argptr>
8010519a:	83 c4 10             	add    $0x10,%esp
8010519d:	85 c0                	test   %eax,%eax
8010519f:	78 1f                	js     801051c0 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
801051a1:	83 ec 04             	sub    $0x4,%esp
801051a4:	ff 75 f0             	pushl  -0x10(%ebp)
801051a7:	ff 75 f4             	pushl  -0xc(%ebp)
801051aa:	ff 75 ec             	pushl  -0x14(%ebp)
801051ad:	e8 1e be ff ff       	call   80100fd0 <fileread>
801051b2:	83 c4 10             	add    $0x10,%esp
}
801051b5:	c9                   	leave  
801051b6:	c3                   	ret    
801051b7:	89 f6                	mov    %esi,%esi
801051b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
801051c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
801051c5:	c9                   	leave  
801051c6:	c3                   	ret    
801051c7:	89 f6                	mov    %esi,%esi
801051c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051d0 <sys_write>:

int
sys_write(void)
{
801051d0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801051d1:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
801051d3:	89 e5                	mov    %esp,%ebp
801051d5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801051d8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801051db:	e8 b0 fe ff ff       	call   80105090 <argfd.constprop.0>
801051e0:	85 c0                	test   %eax,%eax
801051e2:	78 4c                	js     80105230 <sys_write+0x60>
801051e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051e7:	83 ec 08             	sub    $0x8,%esp
801051ea:	50                   	push   %eax
801051eb:	6a 02                	push   $0x2
801051ed:	e8 4e fd ff ff       	call   80104f40 <argint>
801051f2:	83 c4 10             	add    $0x10,%esp
801051f5:	85 c0                	test   %eax,%eax
801051f7:	78 37                	js     80105230 <sys_write+0x60>
801051f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051fc:	83 ec 04             	sub    $0x4,%esp
801051ff:	ff 75 f0             	pushl  -0x10(%ebp)
80105202:	50                   	push   %eax
80105203:	6a 01                	push   $0x1
80105205:	e8 86 fd ff ff       	call   80104f90 <argptr>
8010520a:	83 c4 10             	add    $0x10,%esp
8010520d:	85 c0                	test   %eax,%eax
8010520f:	78 1f                	js     80105230 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80105211:	83 ec 04             	sub    $0x4,%esp
80105214:	ff 75 f0             	pushl  -0x10(%ebp)
80105217:	ff 75 f4             	pushl  -0xc(%ebp)
8010521a:	ff 75 ec             	pushl  -0x14(%ebp)
8010521d:	e8 3e be ff ff       	call   80101060 <filewrite>
80105222:	83 c4 10             	add    $0x10,%esp
}
80105225:	c9                   	leave  
80105226:	c3                   	ret    
80105227:	89 f6                	mov    %esi,%esi
80105229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80105230:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80105235:	c9                   	leave  
80105236:	c3                   	ret    
80105237:	89 f6                	mov    %esi,%esi
80105239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105240 <sys_close>:

int
sys_close(void)
{
80105240:	55                   	push   %ebp
80105241:	89 e5                	mov    %esp,%ebp
80105243:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105246:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105249:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010524c:	e8 3f fe ff ff       	call   80105090 <argfd.constprop.0>
80105251:	85 c0                	test   %eax,%eax
80105253:	78 2b                	js     80105280 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80105255:	e8 06 ea ff ff       	call   80103c60 <myproc>
8010525a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010525d:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
80105260:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105267:	00 
  fileclose(f);
80105268:	ff 75 f4             	pushl  -0xc(%ebp)
8010526b:	e8 40 bc ff ff       	call   80100eb0 <fileclose>
  return 0;
80105270:	83 c4 10             	add    $0x10,%esp
80105273:	31 c0                	xor    %eax,%eax
}
80105275:	c9                   	leave  
80105276:	c3                   	ret    
80105277:	89 f6                	mov    %esi,%esi
80105279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80105280:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80105285:	c9                   	leave  
80105286:	c3                   	ret    
80105287:	89 f6                	mov    %esi,%esi
80105289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105290 <sys_fstat>:

int
sys_fstat(void)
{
80105290:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105291:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80105293:	89 e5                	mov    %esp,%ebp
80105295:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105298:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010529b:	e8 f0 fd ff ff       	call   80105090 <argfd.constprop.0>
801052a0:	85 c0                	test   %eax,%eax
801052a2:	78 2c                	js     801052d0 <sys_fstat+0x40>
801052a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052a7:	83 ec 04             	sub    $0x4,%esp
801052aa:	6a 14                	push   $0x14
801052ac:	50                   	push   %eax
801052ad:	6a 01                	push   $0x1
801052af:	e8 dc fc ff ff       	call   80104f90 <argptr>
801052b4:	83 c4 10             	add    $0x10,%esp
801052b7:	85 c0                	test   %eax,%eax
801052b9:	78 15                	js     801052d0 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
801052bb:	83 ec 08             	sub    $0x8,%esp
801052be:	ff 75 f4             	pushl  -0xc(%ebp)
801052c1:	ff 75 f0             	pushl  -0x10(%ebp)
801052c4:	e8 b7 bc ff ff       	call   80100f80 <filestat>
801052c9:	83 c4 10             	add    $0x10,%esp
}
801052cc:	c9                   	leave  
801052cd:	c3                   	ret    
801052ce:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
801052d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
801052d5:	c9                   	leave  
801052d6:	c3                   	ret    
801052d7:	89 f6                	mov    %esi,%esi
801052d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052e0 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801052e0:	55                   	push   %ebp
801052e1:	89 e5                	mov    %esp,%ebp
801052e3:	57                   	push   %edi
801052e4:	56                   	push   %esi
801052e5:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801052e6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801052e9:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801052ec:	50                   	push   %eax
801052ed:	6a 00                	push   $0x0
801052ef:	e8 fc fc ff ff       	call   80104ff0 <argstr>
801052f4:	83 c4 10             	add    $0x10,%esp
801052f7:	85 c0                	test   %eax,%eax
801052f9:	0f 88 fb 00 00 00    	js     801053fa <sys_link+0x11a>
801052ff:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105302:	83 ec 08             	sub    $0x8,%esp
80105305:	50                   	push   %eax
80105306:	6a 01                	push   $0x1
80105308:	e8 e3 fc ff ff       	call   80104ff0 <argstr>
8010530d:	83 c4 10             	add    $0x10,%esp
80105310:	85 c0                	test   %eax,%eax
80105312:	0f 88 e2 00 00 00    	js     801053fa <sys_link+0x11a>
    return -1;

  begin_op();
80105318:	e8 93 dc ff ff       	call   80102fb0 <begin_op>
  if((ip = namei(old)) == 0){
8010531d:	83 ec 0c             	sub    $0xc,%esp
80105320:	ff 75 d4             	pushl  -0x2c(%ebp)
80105323:	e8 18 cc ff ff       	call   80101f40 <namei>
80105328:	83 c4 10             	add    $0x10,%esp
8010532b:	85 c0                	test   %eax,%eax
8010532d:	89 c3                	mov    %eax,%ebx
8010532f:	0f 84 f3 00 00 00    	je     80105428 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
80105335:	83 ec 0c             	sub    $0xc,%esp
80105338:	50                   	push   %eax
80105339:	e8 b2 c3 ff ff       	call   801016f0 <ilock>
  if(ip->type == T_DIR){
8010533e:	83 c4 10             	add    $0x10,%esp
80105341:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105346:	0f 84 c4 00 00 00    	je     80105410 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
8010534c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105351:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80105354:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80105357:	53                   	push   %ebx
80105358:	e8 e3 c2 ff ff       	call   80101640 <iupdate>
  iunlock(ip);
8010535d:	89 1c 24             	mov    %ebx,(%esp)
80105360:	e8 6b c4 ff ff       	call   801017d0 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105365:	58                   	pop    %eax
80105366:	5a                   	pop    %edx
80105367:	57                   	push   %edi
80105368:	ff 75 d0             	pushl  -0x30(%ebp)
8010536b:	e8 f0 cb ff ff       	call   80101f60 <nameiparent>
80105370:	83 c4 10             	add    $0x10,%esp
80105373:	85 c0                	test   %eax,%eax
80105375:	89 c6                	mov    %eax,%esi
80105377:	74 5b                	je     801053d4 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80105379:	83 ec 0c             	sub    $0xc,%esp
8010537c:	50                   	push   %eax
8010537d:	e8 6e c3 ff ff       	call   801016f0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105382:	83 c4 10             	add    $0x10,%esp
80105385:	8b 03                	mov    (%ebx),%eax
80105387:	39 06                	cmp    %eax,(%esi)
80105389:	75 3d                	jne    801053c8 <sys_link+0xe8>
8010538b:	83 ec 04             	sub    $0x4,%esp
8010538e:	ff 73 04             	pushl  0x4(%ebx)
80105391:	57                   	push   %edi
80105392:	56                   	push   %esi
80105393:	e8 e8 ca ff ff       	call   80101e80 <dirlink>
80105398:	83 c4 10             	add    $0x10,%esp
8010539b:	85 c0                	test   %eax,%eax
8010539d:	78 29                	js     801053c8 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
8010539f:	83 ec 0c             	sub    $0xc,%esp
801053a2:	56                   	push   %esi
801053a3:	e8 d8 c5 ff ff       	call   80101980 <iunlockput>
  iput(ip);
801053a8:	89 1c 24             	mov    %ebx,(%esp)
801053ab:	e8 70 c4 ff ff       	call   80101820 <iput>

  end_op();
801053b0:	e8 6b dc ff ff       	call   80103020 <end_op>

  return 0;
801053b5:	83 c4 10             	add    $0x10,%esp
801053b8:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
801053ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053bd:	5b                   	pop    %ebx
801053be:	5e                   	pop    %esi
801053bf:	5f                   	pop    %edi
801053c0:	5d                   	pop    %ebp
801053c1:	c3                   	ret    
801053c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
801053c8:	83 ec 0c             	sub    $0xc,%esp
801053cb:	56                   	push   %esi
801053cc:	e8 af c5 ff ff       	call   80101980 <iunlockput>
    goto bad;
801053d1:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
801053d4:	83 ec 0c             	sub    $0xc,%esp
801053d7:	53                   	push   %ebx
801053d8:	e8 13 c3 ff ff       	call   801016f0 <ilock>
  ip->nlink--;
801053dd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801053e2:	89 1c 24             	mov    %ebx,(%esp)
801053e5:	e8 56 c2 ff ff       	call   80101640 <iupdate>
  iunlockput(ip);
801053ea:	89 1c 24             	mov    %ebx,(%esp)
801053ed:	e8 8e c5 ff ff       	call   80101980 <iunlockput>
  end_op();
801053f2:	e8 29 dc ff ff       	call   80103020 <end_op>
  return -1;
801053f7:	83 c4 10             	add    $0x10,%esp
}
801053fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
801053fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105402:	5b                   	pop    %ebx
80105403:	5e                   	pop    %esi
80105404:	5f                   	pop    %edi
80105405:	5d                   	pop    %ebp
80105406:	c3                   	ret    
80105407:	89 f6                	mov    %esi,%esi
80105409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
80105410:	83 ec 0c             	sub    $0xc,%esp
80105413:	53                   	push   %ebx
80105414:	e8 67 c5 ff ff       	call   80101980 <iunlockput>
    end_op();
80105419:	e8 02 dc ff ff       	call   80103020 <end_op>
    return -1;
8010541e:	83 c4 10             	add    $0x10,%esp
80105421:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105426:	eb 92                	jmp    801053ba <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
80105428:	e8 f3 db ff ff       	call   80103020 <end_op>
    return -1;
8010542d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105432:	eb 86                	jmp    801053ba <sys_link+0xda>
80105434:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010543a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105440 <isdirempty>:
}

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
80105440:	55                   	push   %ebp
80105441:	89 e5                	mov    %esp,%ebp
80105443:	57                   	push   %edi
80105444:	56                   	push   %esi
80105445:	53                   	push   %ebx
80105446:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105449:	bb 20 00 00 00       	mov    $0x20,%ebx
8010544e:	83 ec 1c             	sub    $0x1c,%esp
80105451:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105454:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
80105458:	77 0e                	ja     80105468 <isdirempty+0x28>
8010545a:	eb 34                	jmp    80105490 <isdirempty+0x50>
8010545c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105460:	83 c3 10             	add    $0x10,%ebx
80105463:	39 5e 58             	cmp    %ebx,0x58(%esi)
80105466:	76 28                	jbe    80105490 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105468:	6a 10                	push   $0x10
8010546a:	53                   	push   %ebx
8010546b:	57                   	push   %edi
8010546c:	56                   	push   %esi
8010546d:	e8 5e c5 ff ff       	call   801019d0 <readi>
80105472:	83 c4 10             	add    $0x10,%esp
80105475:	83 f8 10             	cmp    $0x10,%eax
80105478:	75 23                	jne    8010549d <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010547a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010547f:	74 df                	je     80105460 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
80105481:	8d 65 f4             	lea    -0xc(%ebp),%esp

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
80105484:	31 c0                	xor    %eax,%eax
  }
  return 1;
}
80105486:	5b                   	pop    %ebx
80105487:	5e                   	pop    %esi
80105488:	5f                   	pop    %edi
80105489:	5d                   	pop    %ebp
8010548a:	c3                   	ret    
8010548b:	90                   	nop
8010548c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105490:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105493:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105498:	5b                   	pop    %ebx
80105499:	5e                   	pop    %esi
8010549a:	5f                   	pop    %edi
8010549b:	5d                   	pop    %ebp
8010549c:	c3                   	ret    
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
8010549d:	83 ec 0c             	sub    $0xc,%esp
801054a0:	68 9c 84 10 80       	push   $0x8010849c
801054a5:	e8 c6 ae ff ff       	call   80100370 <panic>
801054aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801054b0 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
801054b0:	55                   	push   %ebp
801054b1:	89 e5                	mov    %esp,%ebp
801054b3:	57                   	push   %edi
801054b4:	56                   	push   %esi
801054b5:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801054b6:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
801054b9:	83 ec 44             	sub    $0x44,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801054bc:	50                   	push   %eax
801054bd:	6a 00                	push   $0x0
801054bf:	e8 2c fb ff ff       	call   80104ff0 <argstr>
801054c4:	83 c4 10             	add    $0x10,%esp
801054c7:	85 c0                	test   %eax,%eax
801054c9:	0f 88 51 01 00 00    	js     80105620 <sys_unlink+0x170>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
801054cf:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
801054d2:	e8 d9 da ff ff       	call   80102fb0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801054d7:	83 ec 08             	sub    $0x8,%esp
801054da:	53                   	push   %ebx
801054db:	ff 75 c0             	pushl  -0x40(%ebp)
801054de:	e8 7d ca ff ff       	call   80101f60 <nameiparent>
801054e3:	83 c4 10             	add    $0x10,%esp
801054e6:	85 c0                	test   %eax,%eax
801054e8:	89 c6                	mov    %eax,%esi
801054ea:	0f 84 37 01 00 00    	je     80105627 <sys_unlink+0x177>
    end_op();
    return -1;
  }

  ilock(dp);
801054f0:	83 ec 0c             	sub    $0xc,%esp
801054f3:	50                   	push   %eax
801054f4:	e8 f7 c1 ff ff       	call   801016f0 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801054f9:	58                   	pop    %eax
801054fa:	5a                   	pop    %edx
801054fb:	68 fd 7d 10 80       	push   $0x80107dfd
80105500:	53                   	push   %ebx
80105501:	e8 fa c6 ff ff       	call   80101c00 <namecmp>
80105506:	83 c4 10             	add    $0x10,%esp
80105509:	85 c0                	test   %eax,%eax
8010550b:	0f 84 d3 00 00 00    	je     801055e4 <sys_unlink+0x134>
80105511:	83 ec 08             	sub    $0x8,%esp
80105514:	68 fc 7d 10 80       	push   $0x80107dfc
80105519:	53                   	push   %ebx
8010551a:	e8 e1 c6 ff ff       	call   80101c00 <namecmp>
8010551f:	83 c4 10             	add    $0x10,%esp
80105522:	85 c0                	test   %eax,%eax
80105524:	0f 84 ba 00 00 00    	je     801055e4 <sys_unlink+0x134>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010552a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010552d:	83 ec 04             	sub    $0x4,%esp
80105530:	50                   	push   %eax
80105531:	53                   	push   %ebx
80105532:	56                   	push   %esi
80105533:	e8 e8 c6 ff ff       	call   80101c20 <dirlookup>
80105538:	83 c4 10             	add    $0x10,%esp
8010553b:	85 c0                	test   %eax,%eax
8010553d:	89 c3                	mov    %eax,%ebx
8010553f:	0f 84 9f 00 00 00    	je     801055e4 <sys_unlink+0x134>
    goto bad;
  ilock(ip);
80105545:	83 ec 0c             	sub    $0xc,%esp
80105548:	50                   	push   %eax
80105549:	e8 a2 c1 ff ff       	call   801016f0 <ilock>

  if(ip->nlink < 1)
8010554e:	83 c4 10             	add    $0x10,%esp
80105551:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105556:	0f 8e e4 00 00 00    	jle    80105640 <sys_unlink+0x190>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
8010555c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105561:	74 65                	je     801055c8 <sys_unlink+0x118>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80105563:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105566:	83 ec 04             	sub    $0x4,%esp
80105569:	6a 10                	push   $0x10
8010556b:	6a 00                	push   $0x0
8010556d:	57                   	push   %edi
8010556e:	e8 6d f6 ff ff       	call   80104be0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105573:	6a 10                	push   $0x10
80105575:	ff 75 c4             	pushl  -0x3c(%ebp)
80105578:	57                   	push   %edi
80105579:	56                   	push   %esi
8010557a:	e8 51 c5 ff ff       	call   80101ad0 <writei>
8010557f:	83 c4 20             	add    $0x20,%esp
80105582:	83 f8 10             	cmp    $0x10,%eax
80105585:	0f 85 a8 00 00 00    	jne    80105633 <sys_unlink+0x183>
    panic("unlink: writei");
  if(ip->type == T_DIR){
8010558b:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105590:	74 76                	je     80105608 <sys_unlink+0x158>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80105592:	83 ec 0c             	sub    $0xc,%esp
80105595:	56                   	push   %esi
80105596:	e8 e5 c3 ff ff       	call   80101980 <iunlockput>

  ip->nlink--;
8010559b:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801055a0:	89 1c 24             	mov    %ebx,(%esp)
801055a3:	e8 98 c0 ff ff       	call   80101640 <iupdate>
  iunlockput(ip);
801055a8:	89 1c 24             	mov    %ebx,(%esp)
801055ab:	e8 d0 c3 ff ff       	call   80101980 <iunlockput>

  end_op();
801055b0:	e8 6b da ff ff       	call   80103020 <end_op>

  return 0;
801055b5:	83 c4 10             	add    $0x10,%esp
801055b8:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
801055ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055bd:	5b                   	pop    %ebx
801055be:	5e                   	pop    %esi
801055bf:	5f                   	pop    %edi
801055c0:	5d                   	pop    %ebp
801055c1:	c3                   	ret    
801055c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
801055c8:	83 ec 0c             	sub    $0xc,%esp
801055cb:	53                   	push   %ebx
801055cc:	e8 6f fe ff ff       	call   80105440 <isdirempty>
801055d1:	83 c4 10             	add    $0x10,%esp
801055d4:	85 c0                	test   %eax,%eax
801055d6:	75 8b                	jne    80105563 <sys_unlink+0xb3>
    iunlockput(ip);
801055d8:	83 ec 0c             	sub    $0xc,%esp
801055db:	53                   	push   %ebx
801055dc:	e8 9f c3 ff ff       	call   80101980 <iunlockput>
    goto bad;
801055e1:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
801055e4:	83 ec 0c             	sub    $0xc,%esp
801055e7:	56                   	push   %esi
801055e8:	e8 93 c3 ff ff       	call   80101980 <iunlockput>
  end_op();
801055ed:	e8 2e da ff ff       	call   80103020 <end_op>
  return -1;
801055f2:	83 c4 10             	add    $0x10,%esp
}
801055f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
801055f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055fd:	5b                   	pop    %ebx
801055fe:	5e                   	pop    %esi
801055ff:	5f                   	pop    %edi
80105600:	5d                   	pop    %ebp
80105601:	c3                   	ret    
80105602:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80105608:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
8010560d:	83 ec 0c             	sub    $0xc,%esp
80105610:	56                   	push   %esi
80105611:	e8 2a c0 ff ff       	call   80101640 <iupdate>
80105616:	83 c4 10             	add    $0x10,%esp
80105619:	e9 74 ff ff ff       	jmp    80105592 <sys_unlink+0xe2>
8010561e:	66 90                	xchg   %ax,%ax
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
80105620:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105625:	eb 93                	jmp    801055ba <sys_unlink+0x10a>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
80105627:	e8 f4 d9 ff ff       	call   80103020 <end_op>
    return -1;
8010562c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105631:	eb 87                	jmp    801055ba <sys_unlink+0x10a>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80105633:	83 ec 0c             	sub    $0xc,%esp
80105636:	68 11 7e 10 80       	push   $0x80107e11
8010563b:	e8 30 ad ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80105640:	83 ec 0c             	sub    $0xc,%esp
80105643:	68 ff 7d 10 80       	push   $0x80107dff
80105648:	e8 23 ad ff ff       	call   80100370 <panic>
8010564d:	8d 76 00             	lea    0x0(%esi),%esi

80105650 <create>:
  return -1;
}

struct inode*
create(char *path, short type, short major, short minor)
{
80105650:	55                   	push   %ebp
80105651:	89 e5                	mov    %esp,%ebp
80105653:	57                   	push   %edi
80105654:	56                   	push   %esi
80105655:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105656:	8d 75 da             	lea    -0x26(%ebp),%esi
  return -1;
}

struct inode*
create(char *path, short type, short major, short minor)
{
80105659:	83 ec 44             	sub    $0x44,%esp
8010565c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010565f:	8b 55 10             	mov    0x10(%ebp),%edx
80105662:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105665:	56                   	push   %esi
80105666:	ff 75 08             	pushl  0x8(%ebp)
  return -1;
}

struct inode*
create(char *path, short type, short major, short minor)
{
80105669:	89 45 c4             	mov    %eax,-0x3c(%ebp)
8010566c:	89 55 c0             	mov    %edx,-0x40(%ebp)
8010566f:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105672:	e8 e9 c8 ff ff       	call   80101f60 <nameiparent>
80105677:	83 c4 10             	add    $0x10,%esp
8010567a:	85 c0                	test   %eax,%eax
8010567c:	0f 84 ee 00 00 00    	je     80105770 <create+0x120>
    return 0;
  ilock(dp);
80105682:	83 ec 0c             	sub    $0xc,%esp
80105685:	89 c7                	mov    %eax,%edi
80105687:	50                   	push   %eax
80105688:	e8 63 c0 ff ff       	call   801016f0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
8010568d:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80105690:	83 c4 0c             	add    $0xc,%esp
80105693:	50                   	push   %eax
80105694:	56                   	push   %esi
80105695:	57                   	push   %edi
80105696:	e8 85 c5 ff ff       	call   80101c20 <dirlookup>
8010569b:	83 c4 10             	add    $0x10,%esp
8010569e:	85 c0                	test   %eax,%eax
801056a0:	89 c3                	mov    %eax,%ebx
801056a2:	74 4c                	je     801056f0 <create+0xa0>
    iunlockput(dp);
801056a4:	83 ec 0c             	sub    $0xc,%esp
801056a7:	57                   	push   %edi
801056a8:	e8 d3 c2 ff ff       	call   80101980 <iunlockput>
    ilock(ip);
801056ad:	89 1c 24             	mov    %ebx,(%esp)
801056b0:	e8 3b c0 ff ff       	call   801016f0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801056b5:	83 c4 10             	add    $0x10,%esp
801056b8:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
801056bd:	75 11                	jne    801056d0 <create+0x80>
801056bf:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
801056c4:	89 d8                	mov    %ebx,%eax
801056c6:	75 08                	jne    801056d0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801056c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056cb:	5b                   	pop    %ebx
801056cc:	5e                   	pop    %esi
801056cd:	5f                   	pop    %edi
801056ce:	5d                   	pop    %ebp
801056cf:	c3                   	ret    
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
801056d0:	83 ec 0c             	sub    $0xc,%esp
801056d3:	53                   	push   %ebx
801056d4:	e8 a7 c2 ff ff       	call   80101980 <iunlockput>
    return 0;
801056d9:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801056dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
801056df:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801056e1:	5b                   	pop    %ebx
801056e2:	5e                   	pop    %esi
801056e3:	5f                   	pop    %edi
801056e4:	5d                   	pop    %ebp
801056e5:	c3                   	ret    
801056e6:	8d 76 00             	lea    0x0(%esi),%esi
801056e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801056f0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
801056f4:	83 ec 08             	sub    $0x8,%esp
801056f7:	50                   	push   %eax
801056f8:	ff 37                	pushl  (%edi)
801056fa:	e8 81 be ff ff       	call   80101580 <ialloc>
801056ff:	83 c4 10             	add    $0x10,%esp
80105702:	85 c0                	test   %eax,%eax
80105704:	89 c3                	mov    %eax,%ebx
80105706:	0f 84 cc 00 00 00    	je     801057d8 <create+0x188>
    panic("create: ialloc");

  ilock(ip);
8010570c:	83 ec 0c             	sub    $0xc,%esp
8010570f:	50                   	push   %eax
80105710:	e8 db bf ff ff       	call   801016f0 <ilock>
  ip->major = major;
80105715:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80105719:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
8010571d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80105721:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
80105725:	b8 01 00 00 00       	mov    $0x1,%eax
8010572a:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
8010572e:	89 1c 24             	mov    %ebx,(%esp)
80105731:	e8 0a bf ff ff       	call   80101640 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105736:	83 c4 10             	add    $0x10,%esp
80105739:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010573e:	74 40                	je     80105780 <create+0x130>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105740:	83 ec 04             	sub    $0x4,%esp
80105743:	ff 73 04             	pushl  0x4(%ebx)
80105746:	56                   	push   %esi
80105747:	57                   	push   %edi
80105748:	e8 33 c7 ff ff       	call   80101e80 <dirlink>
8010574d:	83 c4 10             	add    $0x10,%esp
80105750:	85 c0                	test   %eax,%eax
80105752:	78 77                	js     801057cb <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
80105754:	83 ec 0c             	sub    $0xc,%esp
80105757:	57                   	push   %edi
80105758:	e8 23 c2 ff ff       	call   80101980 <iunlockput>

  return ip;
8010575d:	83 c4 10             	add    $0x10,%esp
}
80105760:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
80105763:	89 d8                	mov    %ebx,%eax
}
80105765:	5b                   	pop    %ebx
80105766:	5e                   	pop    %esi
80105767:	5f                   	pop    %edi
80105768:	5d                   	pop    %ebp
80105769:	c3                   	ret    
8010576a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80105770:	31 c0                	xor    %eax,%eax
80105772:	e9 51 ff ff ff       	jmp    801056c8 <create+0x78>
80105777:	89 f6                	mov    %esi,%esi
80105779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80105780:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80105785:	83 ec 0c             	sub    $0xc,%esp
80105788:	57                   	push   %edi
80105789:	e8 b2 be ff ff       	call   80101640 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010578e:	83 c4 0c             	add    $0xc,%esp
80105791:	ff 73 04             	pushl  0x4(%ebx)
80105794:	68 fd 7d 10 80       	push   $0x80107dfd
80105799:	53                   	push   %ebx
8010579a:	e8 e1 c6 ff ff       	call   80101e80 <dirlink>
8010579f:	83 c4 10             	add    $0x10,%esp
801057a2:	85 c0                	test   %eax,%eax
801057a4:	78 18                	js     801057be <create+0x16e>
801057a6:	83 ec 04             	sub    $0x4,%esp
801057a9:	ff 77 04             	pushl  0x4(%edi)
801057ac:	68 fc 7d 10 80       	push   $0x80107dfc
801057b1:	53                   	push   %ebx
801057b2:	e8 c9 c6 ff ff       	call   80101e80 <dirlink>
801057b7:	83 c4 10             	add    $0x10,%esp
801057ba:	85 c0                	test   %eax,%eax
801057bc:	79 82                	jns    80105740 <create+0xf0>
      panic("create dots");
801057be:	83 ec 0c             	sub    $0xc,%esp
801057c1:	68 bd 84 10 80       	push   $0x801084bd
801057c6:	e8 a5 ab ff ff       	call   80100370 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
801057cb:	83 ec 0c             	sub    $0xc,%esp
801057ce:	68 c9 84 10 80       	push   $0x801084c9
801057d3:	e8 98 ab ff ff       	call   80100370 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
801057d8:	83 ec 0c             	sub    $0xc,%esp
801057db:	68 ae 84 10 80       	push   $0x801084ae
801057e0:	e8 8b ab ff ff       	call   80100370 <panic>
801057e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801057e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057f0 <sys_open>:
  return ip;
}

int
sys_open(void)
{
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	57                   	push   %edi
801057f4:	56                   	push   %esi
801057f5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801057f6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
801057f9:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801057fc:	50                   	push   %eax
801057fd:	6a 00                	push   $0x0
801057ff:	e8 ec f7 ff ff       	call   80104ff0 <argstr>
80105804:	83 c4 10             	add    $0x10,%esp
80105807:	85 c0                	test   %eax,%eax
80105809:	0f 88 9e 00 00 00    	js     801058ad <sys_open+0xbd>
8010580f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105812:	83 ec 08             	sub    $0x8,%esp
80105815:	50                   	push   %eax
80105816:	6a 01                	push   $0x1
80105818:	e8 23 f7 ff ff       	call   80104f40 <argint>
8010581d:	83 c4 10             	add    $0x10,%esp
80105820:	85 c0                	test   %eax,%eax
80105822:	0f 88 85 00 00 00    	js     801058ad <sys_open+0xbd>
    return -1;

  begin_op();
80105828:	e8 83 d7 ff ff       	call   80102fb0 <begin_op>

  if(omode & O_CREATE){
8010582d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105831:	0f 85 89 00 00 00    	jne    801058c0 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105837:	83 ec 0c             	sub    $0xc,%esp
8010583a:	ff 75 e0             	pushl  -0x20(%ebp)
8010583d:	e8 fe c6 ff ff       	call   80101f40 <namei>
80105842:	83 c4 10             	add    $0x10,%esp
80105845:	85 c0                	test   %eax,%eax
80105847:	89 c6                	mov    %eax,%esi
80105849:	0f 84 88 00 00 00    	je     801058d7 <sys_open+0xe7>
      end_op();
      return -1;
    }
    ilock(ip);
8010584f:	83 ec 0c             	sub    $0xc,%esp
80105852:	50                   	push   %eax
80105853:	e8 98 be ff ff       	call   801016f0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105858:	83 c4 10             	add    $0x10,%esp
8010585b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105860:	0f 84 ca 00 00 00    	je     80105930 <sys_open+0x140>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105866:	e8 85 b5 ff ff       	call   80100df0 <filealloc>
8010586b:	85 c0                	test   %eax,%eax
8010586d:	89 c7                	mov    %eax,%edi
8010586f:	74 2b                	je     8010589c <sys_open+0xac>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105871:	31 db                	xor    %ebx,%ebx
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105873:	e8 e8 e3 ff ff       	call   80103c60 <myproc>
80105878:	90                   	nop
80105879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105880:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105884:	85 d2                	test   %edx,%edx
80105886:	74 60                	je     801058e8 <sys_open+0xf8>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105888:	83 c3 01             	add    $0x1,%ebx
8010588b:	83 fb 10             	cmp    $0x10,%ebx
8010588e:	75 f0                	jne    80105880 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80105890:	83 ec 0c             	sub    $0xc,%esp
80105893:	57                   	push   %edi
80105894:	e8 17 b6 ff ff       	call   80100eb0 <fileclose>
80105899:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010589c:	83 ec 0c             	sub    $0xc,%esp
8010589f:	56                   	push   %esi
801058a0:	e8 db c0 ff ff       	call   80101980 <iunlockput>
    end_op();
801058a5:	e8 76 d7 ff ff       	call   80103020 <end_op>
    return -1;
801058aa:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
801058ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
801058b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
801058b5:	5b                   	pop    %ebx
801058b6:	5e                   	pop    %esi
801058b7:	5f                   	pop    %edi
801058b8:	5d                   	pop    %ebp
801058b9:	c3                   	ret    
801058ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
801058c0:	6a 00                	push   $0x0
801058c2:	6a 00                	push   $0x0
801058c4:	6a 02                	push   $0x2
801058c6:	ff 75 e0             	pushl  -0x20(%ebp)
801058c9:	e8 82 fd ff ff       	call   80105650 <create>
    if(ip == 0){
801058ce:	83 c4 10             	add    $0x10,%esp
801058d1:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
801058d3:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801058d5:	75 8f                	jne    80105866 <sys_open+0x76>
      end_op();
801058d7:	e8 44 d7 ff ff       	call   80103020 <end_op>
      return -1;
801058dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058e1:	eb 41                	jmp    80105924 <sys_open+0x134>
801058e3:	90                   	nop
801058e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801058e8:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
801058eb:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801058ef:	56                   	push   %esi
801058f0:	e8 db be ff ff       	call   801017d0 <iunlock>
  end_op();
801058f5:	e8 26 d7 ff ff       	call   80103020 <end_op>

  f->type = FD_INODE;
801058fa:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105900:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105903:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
80105906:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105909:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105910:	89 d0                	mov    %edx,%eax
80105912:	83 e0 01             	and    $0x1,%eax
80105915:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105918:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010591b:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010591e:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
80105922:	89 d8                	mov    %ebx,%eax
}
80105924:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105927:	5b                   	pop    %ebx
80105928:	5e                   	pop    %esi
80105929:	5f                   	pop    %edi
8010592a:	5d                   	pop    %ebp
8010592b:	c3                   	ret    
8010592c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80105930:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105933:	85 c9                	test   %ecx,%ecx
80105935:	0f 84 2b ff ff ff    	je     80105866 <sys_open+0x76>
8010593b:	e9 5c ff ff ff       	jmp    8010589c <sys_open+0xac>

80105940 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80105940:	55                   	push   %ebp
80105941:	89 e5                	mov    %esp,%ebp
80105943:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105946:	e8 65 d6 ff ff       	call   80102fb0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010594b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010594e:	83 ec 08             	sub    $0x8,%esp
80105951:	50                   	push   %eax
80105952:	6a 00                	push   $0x0
80105954:	e8 97 f6 ff ff       	call   80104ff0 <argstr>
80105959:	83 c4 10             	add    $0x10,%esp
8010595c:	85 c0                	test   %eax,%eax
8010595e:	78 30                	js     80105990 <sys_mkdir+0x50>
80105960:	6a 00                	push   $0x0
80105962:	6a 00                	push   $0x0
80105964:	6a 01                	push   $0x1
80105966:	ff 75 f4             	pushl  -0xc(%ebp)
80105969:	e8 e2 fc ff ff       	call   80105650 <create>
8010596e:	83 c4 10             	add    $0x10,%esp
80105971:	85 c0                	test   %eax,%eax
80105973:	74 1b                	je     80105990 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105975:	83 ec 0c             	sub    $0xc,%esp
80105978:	50                   	push   %eax
80105979:	e8 02 c0 ff ff       	call   80101980 <iunlockput>
  end_op();
8010597e:	e8 9d d6 ff ff       	call   80103020 <end_op>
  return 0;
80105983:	83 c4 10             	add    $0x10,%esp
80105986:	31 c0                	xor    %eax,%eax
}
80105988:	c9                   	leave  
80105989:	c3                   	ret    
8010598a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
80105990:	e8 8b d6 ff ff       	call   80103020 <end_op>
    return -1;
80105995:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010599a:	c9                   	leave  
8010599b:	c3                   	ret    
8010599c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059a0 <sys_mknod>:

int
sys_mknod(void)
{
801059a0:	55                   	push   %ebp
801059a1:	89 e5                	mov    %esp,%ebp
801059a3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801059a6:	e8 05 d6 ff ff       	call   80102fb0 <begin_op>
  if((argstr(0, &path)) < 0 ||
801059ab:	8d 45 ec             	lea    -0x14(%ebp),%eax
801059ae:	83 ec 08             	sub    $0x8,%esp
801059b1:	50                   	push   %eax
801059b2:	6a 00                	push   $0x0
801059b4:	e8 37 f6 ff ff       	call   80104ff0 <argstr>
801059b9:	83 c4 10             	add    $0x10,%esp
801059bc:	85 c0                	test   %eax,%eax
801059be:	78 60                	js     80105a20 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801059c0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059c3:	83 ec 08             	sub    $0x8,%esp
801059c6:	50                   	push   %eax
801059c7:	6a 01                	push   $0x1
801059c9:	e8 72 f5 ff ff       	call   80104f40 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
801059ce:	83 c4 10             	add    $0x10,%esp
801059d1:	85 c0                	test   %eax,%eax
801059d3:	78 4b                	js     80105a20 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801059d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059d8:	83 ec 08             	sub    $0x8,%esp
801059db:	50                   	push   %eax
801059dc:	6a 02                	push   $0x2
801059de:	e8 5d f5 ff ff       	call   80104f40 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
801059e3:	83 c4 10             	add    $0x10,%esp
801059e6:	85 c0                	test   %eax,%eax
801059e8:	78 36                	js     80105a20 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801059ea:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801059ee:	50                   	push   %eax
801059ef:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
801059f3:	50                   	push   %eax
801059f4:	6a 03                	push   $0x3
801059f6:	ff 75 ec             	pushl  -0x14(%ebp)
801059f9:	e8 52 fc ff ff       	call   80105650 <create>
801059fe:	83 c4 10             	add    $0x10,%esp
80105a01:	85 c0                	test   %eax,%eax
80105a03:	74 1b                	je     80105a20 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
80105a05:	83 ec 0c             	sub    $0xc,%esp
80105a08:	50                   	push   %eax
80105a09:	e8 72 bf ff ff       	call   80101980 <iunlockput>
  end_op();
80105a0e:	e8 0d d6 ff ff       	call   80103020 <end_op>
  return 0;
80105a13:	83 c4 10             	add    $0x10,%esp
80105a16:	31 c0                	xor    %eax,%eax
}
80105a18:	c9                   	leave  
80105a19:	c3                   	ret    
80105a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105a20:	e8 fb d5 ff ff       	call   80103020 <end_op>
    return -1;
80105a25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
80105a2a:	c9                   	leave  
80105a2b:	c3                   	ret    
80105a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a30 <sys_chdir>:

int
sys_chdir(void)
{
80105a30:	55                   	push   %ebp
80105a31:	89 e5                	mov    %esp,%ebp
80105a33:	56                   	push   %esi
80105a34:	53                   	push   %ebx
80105a35:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105a38:	e8 23 e2 ff ff       	call   80103c60 <myproc>
80105a3d:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105a3f:	e8 6c d5 ff ff       	call   80102fb0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105a44:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a47:	83 ec 08             	sub    $0x8,%esp
80105a4a:	50                   	push   %eax
80105a4b:	6a 00                	push   $0x0
80105a4d:	e8 9e f5 ff ff       	call   80104ff0 <argstr>
80105a52:	83 c4 10             	add    $0x10,%esp
80105a55:	85 c0                	test   %eax,%eax
80105a57:	78 77                	js     80105ad0 <sys_chdir+0xa0>
80105a59:	83 ec 0c             	sub    $0xc,%esp
80105a5c:	ff 75 f4             	pushl  -0xc(%ebp)
80105a5f:	e8 dc c4 ff ff       	call   80101f40 <namei>
80105a64:	83 c4 10             	add    $0x10,%esp
80105a67:	85 c0                	test   %eax,%eax
80105a69:	89 c3                	mov    %eax,%ebx
80105a6b:	74 63                	je     80105ad0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105a6d:	83 ec 0c             	sub    $0xc,%esp
80105a70:	50                   	push   %eax
80105a71:	e8 7a bc ff ff       	call   801016f0 <ilock>
  if(ip->type != T_DIR){
80105a76:	83 c4 10             	add    $0x10,%esp
80105a79:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105a7e:	75 30                	jne    80105ab0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105a80:	83 ec 0c             	sub    $0xc,%esp
80105a83:	53                   	push   %ebx
80105a84:	e8 47 bd ff ff       	call   801017d0 <iunlock>
  iput(curproc->cwd);
80105a89:	58                   	pop    %eax
80105a8a:	ff 76 68             	pushl  0x68(%esi)
80105a8d:	e8 8e bd ff ff       	call   80101820 <iput>
  end_op();
80105a92:	e8 89 d5 ff ff       	call   80103020 <end_op>
  curproc->cwd = ip;
80105a97:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105a9a:	83 c4 10             	add    $0x10,%esp
80105a9d:	31 c0                	xor    %eax,%eax
}
80105a9f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105aa2:	5b                   	pop    %ebx
80105aa3:	5e                   	pop    %esi
80105aa4:	5d                   	pop    %ebp
80105aa5:	c3                   	ret    
80105aa6:	8d 76 00             	lea    0x0(%esi),%esi
80105aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80105ab0:	83 ec 0c             	sub    $0xc,%esp
80105ab3:	53                   	push   %ebx
80105ab4:	e8 c7 be ff ff       	call   80101980 <iunlockput>
    end_op();
80105ab9:	e8 62 d5 ff ff       	call   80103020 <end_op>
    return -1;
80105abe:	83 c4 10             	add    $0x10,%esp
80105ac1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ac6:	eb d7                	jmp    80105a9f <sys_chdir+0x6f>
80105ac8:	90                   	nop
80105ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct inode *ip;
  struct proc *curproc = myproc();
  
  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
80105ad0:	e8 4b d5 ff ff       	call   80103020 <end_op>
    return -1;
80105ad5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ada:	eb c3                	jmp    80105a9f <sys_chdir+0x6f>
80105adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ae0 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
80105ae0:	55                   	push   %ebp
80105ae1:	89 e5                	mov    %esp,%ebp
80105ae3:	57                   	push   %edi
80105ae4:	56                   	push   %esi
80105ae5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105ae6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
80105aec:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105af2:	50                   	push   %eax
80105af3:	6a 00                	push   $0x0
80105af5:	e8 f6 f4 ff ff       	call   80104ff0 <argstr>
80105afa:	83 c4 10             	add    $0x10,%esp
80105afd:	85 c0                	test   %eax,%eax
80105aff:	78 7f                	js     80105b80 <sys_exec+0xa0>
80105b01:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105b07:	83 ec 08             	sub    $0x8,%esp
80105b0a:	50                   	push   %eax
80105b0b:	6a 01                	push   $0x1
80105b0d:	e8 2e f4 ff ff       	call   80104f40 <argint>
80105b12:	83 c4 10             	add    $0x10,%esp
80105b15:	85 c0                	test   %eax,%eax
80105b17:	78 67                	js     80105b80 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105b19:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105b1f:	83 ec 04             	sub    $0x4,%esp
80105b22:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80105b28:	68 80 00 00 00       	push   $0x80
80105b2d:	6a 00                	push   $0x0
80105b2f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105b35:	50                   	push   %eax
80105b36:	31 db                	xor    %ebx,%ebx
80105b38:	e8 a3 f0 ff ff       	call   80104be0 <memset>
80105b3d:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105b40:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105b46:	83 ec 08             	sub    $0x8,%esp
80105b49:	57                   	push   %edi
80105b4a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80105b4d:	50                   	push   %eax
80105b4e:	e8 4d f3 ff ff       	call   80104ea0 <fetchint>
80105b53:	83 c4 10             	add    $0x10,%esp
80105b56:	85 c0                	test   %eax,%eax
80105b58:	78 26                	js     80105b80 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
80105b5a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105b60:	85 c0                	test   %eax,%eax
80105b62:	74 2c                	je     80105b90 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105b64:	83 ec 08             	sub    $0x8,%esp
80105b67:	56                   	push   %esi
80105b68:	50                   	push   %eax
80105b69:	e8 72 f3 ff ff       	call   80104ee0 <fetchstr>
80105b6e:	83 c4 10             	add    $0x10,%esp
80105b71:	85 c0                	test   %eax,%eax
80105b73:	78 0b                	js     80105b80 <sys_exec+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105b75:	83 c3 01             	add    $0x1,%ebx
80105b78:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
80105b7b:	83 fb 20             	cmp    $0x20,%ebx
80105b7e:	75 c0                	jne    80105b40 <sys_exec+0x60>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105b80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80105b83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105b88:	5b                   	pop    %ebx
80105b89:	5e                   	pop    %esi
80105b8a:	5f                   	pop    %edi
80105b8b:	5d                   	pop    %ebp
80105b8c:	c3                   	ret    
80105b8d:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105b90:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105b96:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105b99:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105ba0:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105ba4:	50                   	push   %eax
80105ba5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105bab:	e8 40 ae ff ff       	call   801009f0 <exec>
80105bb0:	83 c4 10             	add    $0x10,%esp
}
80105bb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bb6:	5b                   	pop    %ebx
80105bb7:	5e                   	pop    %esi
80105bb8:	5f                   	pop    %edi
80105bb9:	5d                   	pop    %ebp
80105bba:	c3                   	ret    
80105bbb:	90                   	nop
80105bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105bc0 <sys_pipe>:

int
sys_pipe(void)
{
80105bc0:	55                   	push   %ebp
80105bc1:	89 e5                	mov    %esp,%ebp
80105bc3:	57                   	push   %edi
80105bc4:	56                   	push   %esi
80105bc5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105bc6:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
80105bc9:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105bcc:	6a 08                	push   $0x8
80105bce:	50                   	push   %eax
80105bcf:	6a 00                	push   $0x0
80105bd1:	e8 ba f3 ff ff       	call   80104f90 <argptr>
80105bd6:	83 c4 10             	add    $0x10,%esp
80105bd9:	85 c0                	test   %eax,%eax
80105bdb:	78 4a                	js     80105c27 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105bdd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105be0:	83 ec 08             	sub    $0x8,%esp
80105be3:	50                   	push   %eax
80105be4:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105be7:	50                   	push   %eax
80105be8:	e8 63 da ff ff       	call   80103650 <pipealloc>
80105bed:	83 c4 10             	add    $0x10,%esp
80105bf0:	85 c0                	test   %eax,%eax
80105bf2:	78 33                	js     80105c27 <sys_pipe+0x67>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105bf4:	31 db                	xor    %ebx,%ebx
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105bf6:	8b 7d e0             	mov    -0x20(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105bf9:	e8 62 e0 ff ff       	call   80103c60 <myproc>
80105bfe:	66 90                	xchg   %ax,%ax

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105c00:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105c04:	85 f6                	test   %esi,%esi
80105c06:	74 30                	je     80105c38 <sys_pipe+0x78>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105c08:	83 c3 01             	add    $0x1,%ebx
80105c0b:	83 fb 10             	cmp    $0x10,%ebx
80105c0e:	75 f0                	jne    80105c00 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105c10:	83 ec 0c             	sub    $0xc,%esp
80105c13:	ff 75 e0             	pushl  -0x20(%ebp)
80105c16:	e8 95 b2 ff ff       	call   80100eb0 <fileclose>
    fileclose(wf);
80105c1b:	58                   	pop    %eax
80105c1c:	ff 75 e4             	pushl  -0x1c(%ebp)
80105c1f:	e8 8c b2 ff ff       	call   80100eb0 <fileclose>
    return -1;
80105c24:	83 c4 10             	add    $0x10,%esp
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105c27:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
80105c2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105c2f:	5b                   	pop    %ebx
80105c30:	5e                   	pop    %esi
80105c31:	5f                   	pop    %edi
80105c32:	5d                   	pop    %ebp
80105c33:	c3                   	ret    
80105c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105c38:	8d 73 08             	lea    0x8(%ebx),%esi
80105c3b:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105c3f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105c42:	e8 19 e0 ff ff       	call   80103c60 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
80105c47:	31 d2                	xor    %edx,%edx
80105c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105c50:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105c54:	85 c9                	test   %ecx,%ecx
80105c56:	74 18                	je     80105c70 <sys_pipe+0xb0>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105c58:	83 c2 01             	add    $0x1,%edx
80105c5b:	83 fa 10             	cmp    $0x10,%edx
80105c5e:	75 f0                	jne    80105c50 <sys_pipe+0x90>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105c60:	e8 fb df ff ff       	call   80103c60 <myproc>
80105c65:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105c6c:	00 
80105c6d:	eb a1                	jmp    80105c10 <sys_pipe+0x50>
80105c6f:	90                   	nop
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105c70:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105c74:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105c77:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105c79:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105c7c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
80105c7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
80105c82:	31 c0                	xor    %eax,%eax
}
80105c84:	5b                   	pop    %ebx
80105c85:	5e                   	pop    %esi
80105c86:	5f                   	pop    %edi
80105c87:	5d                   	pop    %ebp
80105c88:	c3                   	ret    
80105c89:	66 90                	xchg   %ax,%ax
80105c8b:	66 90                	xchg   %ax,%ax
80105c8d:	66 90                	xchg   %ax,%ax
80105c8f:	90                   	nop

80105c90 <sys_yield>:
#include "mmu.h"
#include "proc.h"


int sys_yield(void)
{
80105c90:	55                   	push   %ebp
80105c91:	89 e5                	mov    %esp,%ebp
80105c93:	83 ec 08             	sub    $0x8,%esp
  yield(); 
80105c96:	e8 b5 e6 ff ff       	call   80104350 <yield>
  return 0;
}
80105c9b:	31 c0                	xor    %eax,%eax
80105c9d:	c9                   	leave  
80105c9e:	c3                   	ret    
80105c9f:	90                   	nop

80105ca0 <sys_fork>:

int
sys_fork(void)
{
80105ca0:	55                   	push   %ebp
80105ca1:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105ca3:	5d                   	pop    %ebp
}

int
sys_fork(void)
{
  return fork();
80105ca4:	e9 57 e1 ff ff       	jmp    80103e00 <fork>
80105ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105cb0 <sys_exit>:
}

int
sys_exit(void)
{
80105cb0:	55                   	push   %ebp
80105cb1:	89 e5                	mov    %esp,%ebp
80105cb3:	83 ec 08             	sub    $0x8,%esp
  exit();
80105cb6:	e8 65 e5 ff ff       	call   80104220 <exit>
  return 0;  // not reached
}
80105cbb:	31 c0                	xor    %eax,%eax
80105cbd:	c9                   	leave  
80105cbe:	c3                   	ret    
80105cbf:	90                   	nop

80105cc0 <sys_wait>:

int
sys_wait(void)
{
80105cc0:	55                   	push   %ebp
80105cc1:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105cc3:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105cc4:	e9 97 e7 ff ff       	jmp    80104460 <wait>
80105cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105cd0 <sys_kill>:
}

int
sys_kill(void)
{
80105cd0:	55                   	push   %ebp
80105cd1:	89 e5                	mov    %esp,%ebp
80105cd3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105cd6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105cd9:	50                   	push   %eax
80105cda:	6a 00                	push   $0x0
80105cdc:	e8 5f f2 ff ff       	call   80104f40 <argint>
80105ce1:	83 c4 10             	add    $0x10,%esp
80105ce4:	85 c0                	test   %eax,%eax
80105ce6:	78 18                	js     80105d00 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105ce8:	83 ec 0c             	sub    $0xc,%esp
80105ceb:	ff 75 f4             	pushl  -0xc(%ebp)
80105cee:	e8 ed e8 ff ff       	call   801045e0 <kill>
80105cf3:	83 c4 10             	add    $0x10,%esp
}
80105cf6:	c9                   	leave  
80105cf7:	c3                   	ret    
80105cf8:	90                   	nop
80105cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105d00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105d05:	c9                   	leave  
80105d06:	c3                   	ret    
80105d07:	89 f6                	mov    %esi,%esi
80105d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d10 <sys_getpid>:

int
sys_getpid(void)
{
80105d10:	55                   	push   %ebp
80105d11:	89 e5                	mov    %esp,%ebp
80105d13:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105d16:	e8 45 df ff ff       	call   80103c60 <myproc>
80105d1b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105d1e:	c9                   	leave  
80105d1f:	c3                   	ret    

80105d20 <sys_sbrk>:

int
sys_sbrk(void)
{
80105d20:	55                   	push   %ebp
80105d21:	89 e5                	mov    %esp,%ebp
80105d23:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105d24:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return myproc()->pid;
}

int
sys_sbrk(void)
{
80105d27:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105d2a:	50                   	push   %eax
80105d2b:	6a 00                	push   $0x0
80105d2d:	e8 0e f2 ff ff       	call   80104f40 <argint>
80105d32:	83 c4 10             	add    $0x10,%esp
80105d35:	85 c0                	test   %eax,%eax
80105d37:	78 27                	js     80105d60 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105d39:	e8 22 df ff ff       	call   80103c60 <myproc>
  if(growproc(n) < 0)
80105d3e:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
80105d41:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105d43:	ff 75 f4             	pushl  -0xc(%ebp)
80105d46:	e8 35 e0 ff ff       	call   80103d80 <growproc>
80105d4b:	83 c4 10             	add    $0x10,%esp
80105d4e:	85 c0                	test   %eax,%eax
80105d50:	78 0e                	js     80105d60 <sys_sbrk+0x40>
    return -1;
  return addr;
80105d52:	89 d8                	mov    %ebx,%eax
}
80105d54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d57:	c9                   	leave  
80105d58:	c3                   	ret    
80105d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105d60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d65:	eb ed                	jmp    80105d54 <sys_sbrk+0x34>
80105d67:	89 f6                	mov    %esi,%esi
80105d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d70 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105d70:	55                   	push   %ebp
80105d71:	89 e5                	mov    %esp,%ebp
80105d73:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105d74:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return addr;
}

int
sys_sleep(void)
{
80105d77:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105d7a:	50                   	push   %eax
80105d7b:	6a 00                	push   $0x0
80105d7d:	e8 be f1 ff ff       	call   80104f40 <argint>
80105d82:	83 c4 10             	add    $0x10,%esp
80105d85:	85 c0                	test   %eax,%eax
80105d87:	0f 88 8a 00 00 00    	js     80105e17 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105d8d:	83 ec 0c             	sub    $0xc,%esp
80105d90:	68 80 d2 11 80       	push   $0x8011d280
80105d95:	e8 b6 ec ff ff       	call   80104a50 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105d9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d9d:	83 c4 10             	add    $0x10,%esp
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80105da0:	8b 1d c0 da 11 80    	mov    0x8011dac0,%ebx
  while(ticks - ticks0 < n){
80105da6:	85 d2                	test   %edx,%edx
80105da8:	75 27                	jne    80105dd1 <sys_sleep+0x61>
80105daa:	eb 54                	jmp    80105e00 <sys_sleep+0x90>
80105dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105db0:	83 ec 08             	sub    $0x8,%esp
80105db3:	68 80 d2 11 80       	push   $0x8011d280
80105db8:	68 c0 da 11 80       	push   $0x8011dac0
80105dbd:	e8 de e5 ff ff       	call   801043a0 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105dc2:	a1 c0 da 11 80       	mov    0x8011dac0,%eax
80105dc7:	83 c4 10             	add    $0x10,%esp
80105dca:	29 d8                	sub    %ebx,%eax
80105dcc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105dcf:	73 2f                	jae    80105e00 <sys_sleep+0x90>
    if(myproc()->killed){
80105dd1:	e8 8a de ff ff       	call   80103c60 <myproc>
80105dd6:	8b 40 24             	mov    0x24(%eax),%eax
80105dd9:	85 c0                	test   %eax,%eax
80105ddb:	74 d3                	je     80105db0 <sys_sleep+0x40>
      release(&tickslock);
80105ddd:	83 ec 0c             	sub    $0xc,%esp
80105de0:	68 80 d2 11 80       	push   $0x8011d280
80105de5:	e8 a6 ed ff ff       	call   80104b90 <release>
      return -1;
80105dea:	83 c4 10             	add    $0x10,%esp
80105ded:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
80105df2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105df5:	c9                   	leave  
80105df6:	c3                   	ret    
80105df7:	89 f6                	mov    %esi,%esi
80105df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105e00:	83 ec 0c             	sub    $0xc,%esp
80105e03:	68 80 d2 11 80       	push   $0x8011d280
80105e08:	e8 83 ed ff ff       	call   80104b90 <release>
  return 0;
80105e0d:	83 c4 10             	add    $0x10,%esp
80105e10:	31 c0                	xor    %eax,%eax
}
80105e12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e15:	c9                   	leave  
80105e16:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
80105e17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e1c:	eb d4                	jmp    80105df2 <sys_sleep+0x82>
80105e1e:	66 90                	xchg   %ax,%ax

80105e20 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105e20:	55                   	push   %ebp
80105e21:	89 e5                	mov    %esp,%ebp
80105e23:	53                   	push   %ebx
80105e24:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105e27:	68 80 d2 11 80       	push   $0x8011d280
80105e2c:	e8 1f ec ff ff       	call   80104a50 <acquire>
  xticks = ticks;
80105e31:	8b 1d c0 da 11 80    	mov    0x8011dac0,%ebx
  release(&tickslock);
80105e37:	c7 04 24 80 d2 11 80 	movl   $0x8011d280,(%esp)
80105e3e:	e8 4d ed ff ff       	call   80104b90 <release>
  return xticks;
}
80105e43:	89 d8                	mov    %ebx,%eax
80105e45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e48:	c9                   	leave  
80105e49:	c3                   	ret    

80105e4a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105e4a:	1e                   	push   %ds
  pushl %es
80105e4b:	06                   	push   %es
  pushl %fs
80105e4c:	0f a0                	push   %fs
  pushl %gs
80105e4e:	0f a8                	push   %gs
  pushal
80105e50:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105e51:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105e55:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105e57:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105e59:	54                   	push   %esp
  call trap
80105e5a:	e8 e1 00 00 00       	call   80105f40 <trap>
  addl $4, %esp
80105e5f:	83 c4 04             	add    $0x4,%esp

80105e62 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105e62:	61                   	popa   
  popl %gs
80105e63:	0f a9                	pop    %gs
  popl %fs
80105e65:	0f a1                	pop    %fs
  popl %es
80105e67:	07                   	pop    %es
  popl %ds
80105e68:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105e69:	83 c4 08             	add    $0x8,%esp
  iret
80105e6c:	cf                   	iret   
80105e6d:	66 90                	xchg   %ax,%ax
80105e6f:	90                   	nop

80105e70 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105e70:	31 c0                	xor    %eax,%eax
80105e72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105e78:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105e7f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105e84:	c6 04 c5 c4 d2 11 80 	movb   $0x0,-0x7fee2d3c(,%eax,8)
80105e8b:	00 
80105e8c:	66 89 0c c5 c2 d2 11 	mov    %cx,-0x7fee2d3e(,%eax,8)
80105e93:	80 
80105e94:	c6 04 c5 c5 d2 11 80 	movb   $0x8e,-0x7fee2d3b(,%eax,8)
80105e9b:	8e 
80105e9c:	66 89 14 c5 c0 d2 11 	mov    %dx,-0x7fee2d40(,%eax,8)
80105ea3:	80 
80105ea4:	c1 ea 10             	shr    $0x10,%edx
80105ea7:	66 89 14 c5 c6 d2 11 	mov    %dx,-0x7fee2d3a(,%eax,8)
80105eae:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105eaf:	83 c0 01             	add    $0x1,%eax
80105eb2:	3d 00 01 00 00       	cmp    $0x100,%eax
80105eb7:	75 bf                	jne    80105e78 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105eb9:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105eba:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105ebf:	89 e5                	mov    %esp,%ebp
80105ec1:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105ec4:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
80105ec9:	68 d9 84 10 80       	push   $0x801084d9
80105ece:	68 80 d2 11 80       	push   $0x8011d280
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105ed3:	66 89 15 c2 d4 11 80 	mov    %dx,0x8011d4c2
80105eda:	c6 05 c4 d4 11 80 00 	movb   $0x0,0x8011d4c4
80105ee1:	66 a3 c0 d4 11 80    	mov    %ax,0x8011d4c0
80105ee7:	c1 e8 10             	shr    $0x10,%eax
80105eea:	c6 05 c5 d4 11 80 ef 	movb   $0xef,0x8011d4c5
80105ef1:	66 a3 c6 d4 11 80    	mov    %ax,0x8011d4c6

  initlock(&tickslock, "time");
80105ef7:	e8 54 ea ff ff       	call   80104950 <initlock>
}
80105efc:	83 c4 10             	add    $0x10,%esp
80105eff:	c9                   	leave  
80105f00:	c3                   	ret    
80105f01:	eb 0d                	jmp    80105f10 <idtinit>
80105f03:	90                   	nop
80105f04:	90                   	nop
80105f05:	90                   	nop
80105f06:	90                   	nop
80105f07:	90                   	nop
80105f08:	90                   	nop
80105f09:	90                   	nop
80105f0a:	90                   	nop
80105f0b:	90                   	nop
80105f0c:	90                   	nop
80105f0d:	90                   	nop
80105f0e:	90                   	nop
80105f0f:	90                   	nop

80105f10 <idtinit>:

void
idtinit(void)
{
80105f10:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80105f11:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105f16:	89 e5                	mov    %esp,%ebp
80105f18:	83 ec 10             	sub    $0x10,%esp
80105f1b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105f1f:	b8 c0 d2 11 80       	mov    $0x8011d2c0,%eax
80105f24:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105f28:	c1 e8 10             	shr    $0x10,%eax
80105f2b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80105f2f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105f32:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105f35:	c9                   	leave  
80105f36:	c3                   	ret    
80105f37:	89 f6                	mov    %esi,%esi
80105f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f40 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105f40:	55                   	push   %ebp
80105f41:	89 e5                	mov    %esp,%ebp
80105f43:	57                   	push   %edi
80105f44:	56                   	push   %esi
80105f45:	53                   	push   %ebx
80105f46:	83 ec 1c             	sub    $0x1c,%esp
80105f49:	8b 7d 08             	mov    0x8(%ebp),%edi
  pte_t* pte;
  uint va;
  void* swapOutVa;
  #endif

  if(tf->trapno == T_SYSCALL){
80105f4c:	8b 47 30             	mov    0x30(%edi),%eax
80105f4f:	83 f8 40             	cmp    $0x40,%eax
80105f52:	0f 84 a8 01 00 00    	je     80106100 <trap+0x1c0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105f58:	83 e8 0e             	sub    $0xe,%eax
80105f5b:	83 f8 31             	cmp    $0x31,%eax
80105f5e:	77 32                	ja     80105f92 <trap+0x52>
80105f60:	ff 24 85 a0 85 10 80 	jmp    *-0x7fef7a60(,%eax,4)
80105f67:	89 f6                	mov    %esi,%esi
80105f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105f70:	0f 20 d3             	mov    %cr2,%ebx

  #ifndef NONE
  /// check if pg fault or seg fault
  case T_PGFLT:
    va = rcr2();
    pte = walkpgdir_noalloc(myproc()->pgdir, (void*) va);
80105f73:	e8 e8 dc ff ff       	call   80103c60 <myproc>
80105f78:	83 ec 08             	sub    $0x8,%esp
80105f7b:	53                   	push   %ebx
80105f7c:	ff 70 04             	pushl  0x4(%eax)
80105f7f:	e8 2c 12 00 00       	call   801071b0 <walkpgdir_noalloc>

    if(((uint)*pte) & PTE_PG){
80105f84:	8b 00                	mov    (%eax),%eax
80105f86:	83 c4 10             	add    $0x10,%esp
80105f89:	f6 c4 02             	test   $0x2,%ah
80105f8c:	0f 85 e6 01 00 00    	jne    80106178 <trap+0x238>

  #endif

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105f92:	e8 c9 dc ff ff       	call   80103c60 <myproc>
80105f97:	85 c0                	test   %eax,%eax
80105f99:	0f 84 42 02 00 00    	je     801061e1 <trap+0x2a1>
80105f9f:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105fa3:	0f 84 38 02 00 00    	je     801061e1 <trap+0x2a1>
80105fa9:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105fac:	8b 57 38             	mov    0x38(%edi),%edx
80105faf:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105fb2:	89 55 dc             	mov    %edx,-0x24(%ebp)
80105fb5:	e8 86 dc ff ff       	call   80103c40 <cpuid>
80105fba:	8b 77 34             	mov    0x34(%edi),%esi
80105fbd:	8b 5f 30             	mov    0x30(%edi),%ebx
80105fc0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105fc3:	e8 98 dc ff ff       	call   80103c60 <myproc>
80105fc8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105fcb:	e8 90 dc ff ff       	call   80103c60 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105fd0:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105fd3:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105fd6:	51                   	push   %ecx
80105fd7:	52                   	push   %edx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105fd8:	8b 55 e0             	mov    -0x20(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105fdb:	ff 75 e4             	pushl  -0x1c(%ebp)
80105fde:	56                   	push   %esi
80105fdf:	53                   	push   %ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105fe0:	83 c2 6c             	add    $0x6c,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105fe3:	52                   	push   %edx
80105fe4:	ff 70 10             	pushl  0x10(%eax)
80105fe7:	68 5c 85 10 80       	push   $0x8010855c
80105fec:	e8 6f a6 ff ff       	call   80100660 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105ff1:	83 c4 20             	add    $0x20,%esp
80105ff4:	e8 67 dc ff ff       	call   80103c60 <myproc>
80105ff9:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106000:	e8 5b dc ff ff       	call   80103c60 <myproc>
80106005:	85 c0                	test   %eax,%eax
80106007:	74 0c                	je     80106015 <trap+0xd5>
80106009:	e8 52 dc ff ff       	call   80103c60 <myproc>
8010600e:	8b 50 24             	mov    0x24(%eax),%edx
80106011:	85 d2                	test   %edx,%edx
80106013:	75 4b                	jne    80106060 <trap+0x120>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106015:	e8 46 dc ff ff       	call   80103c60 <myproc>
8010601a:	85 c0                	test   %eax,%eax
8010601c:	74 0b                	je     80106029 <trap+0xe9>
8010601e:	e8 3d dc ff ff       	call   80103c60 <myproc>
80106023:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106027:	74 4f                	je     80106078 <trap+0x138>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106029:	e8 32 dc ff ff       	call   80103c60 <myproc>
8010602e:	85 c0                	test   %eax,%eax
80106030:	74 1d                	je     8010604f <trap+0x10f>
80106032:	e8 29 dc ff ff       	call   80103c60 <myproc>
80106037:	8b 40 24             	mov    0x24(%eax),%eax
8010603a:	85 c0                	test   %eax,%eax
8010603c:	74 11                	je     8010604f <trap+0x10f>
8010603e:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106042:	83 e0 03             	and    $0x3,%eax
80106045:	66 83 f8 03          	cmp    $0x3,%ax
80106049:	0f 84 da 00 00 00    	je     80106129 <trap+0x1e9>
    exit();
}
8010604f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106052:	5b                   	pop    %ebx
80106053:	5e                   	pop    %esi
80106054:	5f                   	pop    %edi
80106055:	5d                   	pop    %ebp
80106056:	c3                   	ret    
80106057:	89 f6                	mov    %esi,%esi
80106059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106060:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106064:	83 e0 03             	and    $0x3,%eax
80106067:	66 83 f8 03          	cmp    $0x3,%ax
8010606b:	75 a8                	jne    80106015 <trap+0xd5>
    exit();
8010606d:	e8 ae e1 ff ff       	call   80104220 <exit>
80106072:	eb a1                	jmp    80106015 <trap+0xd5>
80106074:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106078:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
8010607c:	75 ab                	jne    80106029 <trap+0xe9>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
8010607e:	e8 cd e2 ff ff       	call   80104350 <yield>
80106083:	eb a4                	jmp    80106029 <trap+0xe9>
80106085:	8d 76 00             	lea    0x0(%esi),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80106088:	e8 b3 db ff ff       	call   80103c40 <cpuid>
8010608d:	85 c0                	test   %eax,%eax
8010608f:	0f 84 ab 00 00 00    	je     80106140 <trap+0x200>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80106095:	e8 d6 ca ff ff       	call   80102b70 <lapiceoi>
    break;
8010609a:	e9 61 ff ff ff       	jmp    80106000 <trap+0xc0>
8010609f:	90                   	nop
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801060a0:	e8 8b c9 ff ff       	call   80102a30 <kbdintr>
    lapiceoi();
801060a5:	e8 c6 ca ff ff       	call   80102b70 <lapiceoi>
    break;
801060aa:	e9 51 ff ff ff       	jmp    80106000 <trap+0xc0>
801060af:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801060b0:	e8 db 02 00 00       	call   80106390 <uartintr>
    lapiceoi();
801060b5:	e8 b6 ca ff ff       	call   80102b70 <lapiceoi>
    break;
801060ba:	e9 41 ff ff ff       	jmp    80106000 <trap+0xc0>
801060bf:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801060c0:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
801060c4:	8b 77 38             	mov    0x38(%edi),%esi
801060c7:	e8 74 db ff ff       	call   80103c40 <cpuid>
801060cc:	56                   	push   %esi
801060cd:	53                   	push   %ebx
801060ce:	50                   	push   %eax
801060cf:	68 e4 84 10 80       	push   $0x801084e4
801060d4:	e8 87 a5 ff ff       	call   80100660 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
801060d9:	e8 92 ca ff ff       	call   80102b70 <lapiceoi>
    break;
801060de:	83 c4 10             	add    $0x10,%esp
801060e1:	e9 1a ff ff ff       	jmp    80106000 <trap+0xc0>
801060e6:	8d 76 00             	lea    0x0(%esi),%esi
801060e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801060f0:	e8 7b c3 ff ff       	call   80102470 <ideintr>
801060f5:	eb 9e                	jmp    80106095 <trap+0x155>
801060f7:	89 f6                	mov    %esi,%esi
801060f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  uint va;
  void* swapOutVa;
  #endif

  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
80106100:	e8 5b db ff ff       	call   80103c60 <myproc>
80106105:	8b 40 24             	mov    0x24(%eax),%eax
80106108:	85 c0                	test   %eax,%eax
8010610a:	75 2c                	jne    80106138 <trap+0x1f8>
      exit();
    myproc()->tf = tf;
8010610c:	e8 4f db ff ff       	call   80103c60 <myproc>
80106111:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80106114:	e8 17 ef ff ff       	call   80105030 <syscall>
    if(myproc()->killed)
80106119:	e8 42 db ff ff       	call   80103c60 <myproc>
8010611e:	8b 40 24             	mov    0x24(%eax),%eax
80106121:	85 c0                	test   %eax,%eax
80106123:	0f 84 26 ff ff ff    	je     8010604f <trap+0x10f>
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80106129:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010612c:	5b                   	pop    %ebx
8010612d:	5e                   	pop    %esi
8010612e:	5f                   	pop    %edi
8010612f:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
80106130:	e9 eb e0 ff ff       	jmp    80104220 <exit>
80106135:	8d 76 00             	lea    0x0(%esi),%esi
  void* swapOutVa;
  #endif

  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
80106138:	e8 e3 e0 ff ff       	call   80104220 <exit>
8010613d:	eb cd                	jmp    8010610c <trap+0x1cc>
8010613f:	90                   	nop
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
80106140:	83 ec 0c             	sub    $0xc,%esp
80106143:	68 80 d2 11 80       	push   $0x8011d280
80106148:	e8 03 e9 ff ff       	call   80104a50 <acquire>
      ticks++;
      wakeup(&ticks);
8010614d:	c7 04 24 c0 da 11 80 	movl   $0x8011dac0,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
80106154:	83 05 c0 da 11 80 01 	addl   $0x1,0x8011dac0
      wakeup(&ticks);
8010615b:	e8 20 e4 ff ff       	call   80104580 <wakeup>
      release(&tickslock);
80106160:	c7 04 24 80 d2 11 80 	movl   $0x8011d280,(%esp)
80106167:	e8 24 ea ff ff       	call   80104b90 <release>
8010616c:	83 c4 10             	add    $0x10,%esp
8010616f:	e9 21 ff ff ff       	jmp    80106095 <trap+0x155>
80106174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  case T_PGFLT:
    va = rcr2();
    pte = walkpgdir_noalloc(myproc()->pgdir, (void*) va);

    if(((uint)*pte) & PTE_PG){
      myproc()->num_of_page_faults++;
80106178:	e8 e3 da ff ff       	call   80103c60 <myproc>
8010617d:	83 80 8c 00 00 00 01 	addl   $0x1,0x8c(%eax)

      if(myproc()->num_of_pages_in_memory > MAX_PSYC_PAGES){
80106184:	e8 d7 da ff ff       	call   80103c60 <myproc>
80106189:	83 b8 80 00 00 00 10 	cmpl   $0x10,0x80(%eax)
80106190:	7f 7a                	jg     8010620c <trap+0x2cc>
        panic("too many pages in memory, trap");
      }	

      /// the page was swapped out check if there is enough space in the memory for it
      if(myproc()->num_of_pages_in_memory == MAX_PSYC_PAGES){
80106192:	e8 c9 da ff ff       	call   80103c60 <myproc>
80106197:	83 b8 80 00 00 00 10 	cmpl   $0x10,0x80(%eax)
8010619e:	74 1e                	je     801061be <trap+0x27e>
        swapOutVa = selectPageToSwapOut(myproc());
        swapOut(swapOutVa, myproc());
      }

      swapIn((void*) va, myproc());
801061a0:	e8 bb da ff ff       	call   80103c60 <myproc>
801061a5:	83 ec 08             	sub    $0x8,%esp
801061a8:	50                   	push   %eax
801061a9:	53                   	push   %ebx
801061aa:	e8 91 17 00 00       	call   80107940 <swapIn>
      lapiceoi();
801061af:	83 c4 10             	add    $0x10,%esp
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
801061b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061b5:	5b                   	pop    %ebx
801061b6:	5e                   	pop    %esi
801061b7:	5f                   	pop    %edi
801061b8:	5d                   	pop    %ebp
        swapOutVa = selectPageToSwapOut(myproc());
        swapOut(swapOutVa, myproc());
      }

      swapIn((void*) va, myproc());
      lapiceoi();
801061b9:	e9 b2 c9 ff ff       	jmp    80102b70 <lapiceoi>
        panic("too many pages in memory, trap");
      }	

      /// the page was swapped out check if there is enough space in the memory for it
      if(myproc()->num_of_pages_in_memory == MAX_PSYC_PAGES){
        swapOutVa = selectPageToSwapOut(myproc());
801061be:	e8 9d da ff ff       	call   80103c60 <myproc>
801061c3:	83 ec 0c             	sub    $0xc,%esp
801061c6:	50                   	push   %eax
801061c7:	e8 a4 18 00 00       	call   80107a70 <selectPageToSwapOut>
801061cc:	89 c6                	mov    %eax,%esi
        swapOut(swapOutVa, myproc());
801061ce:	e8 8d da ff ff       	call   80103c60 <myproc>
801061d3:	59                   	pop    %ecx
801061d4:	5f                   	pop    %edi
801061d5:	50                   	push   %eax
801061d6:	56                   	push   %esi
801061d7:	e8 d4 15 00 00       	call   801077b0 <swapOut>
801061dc:	83 c4 10             	add    $0x10,%esp
801061df:	eb bf                	jmp    801061a0 <trap+0x260>
801061e1:	0f 20 d6             	mov    %cr2,%esi

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801061e4:	8b 5f 38             	mov    0x38(%edi),%ebx
801061e7:	e8 54 da ff ff       	call   80103c40 <cpuid>
801061ec:	83 ec 0c             	sub    $0xc,%esp
801061ef:	56                   	push   %esi
801061f0:	53                   	push   %ebx
801061f1:	50                   	push   %eax
801061f2:	ff 77 30             	pushl  0x30(%edi)
801061f5:	68 28 85 10 80       	push   $0x80108528
801061fa:	e8 61 a4 ff ff       	call   80100660 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
801061ff:	83 c4 14             	add    $0x14,%esp
80106202:	68 de 84 10 80       	push   $0x801084de
80106207:	e8 64 a1 ff ff       	call   80100370 <panic>

    if(((uint)*pte) & PTE_PG){
      myproc()->num_of_page_faults++;

      if(myproc()->num_of_pages_in_memory > MAX_PSYC_PAGES){
        panic("too many pages in memory, trap");
8010620c:	83 ec 0c             	sub    $0xc,%esp
8010620f:	68 08 85 10 80       	push   $0x80108508
80106214:	e8 57 a1 ff ff       	call   80100370 <panic>
80106219:	66 90                	xchg   %ax,%ax
8010621b:	66 90                	xchg   %ax,%ax
8010621d:	66 90                	xchg   %ax,%ax
8010621f:	90                   	nop

80106220 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106220:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106225:	55                   	push   %ebp
80106226:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106228:	85 c0                	test   %eax,%eax
8010622a:	74 1c                	je     80106248 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010622c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106231:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106232:	a8 01                	test   $0x1,%al
80106234:	74 12                	je     80106248 <uartgetc+0x28>
80106236:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010623b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010623c:	0f b6 c0             	movzbl %al,%eax
}
8010623f:	5d                   	pop    %ebp
80106240:	c3                   	ret    
80106241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80106248:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
8010624d:	5d                   	pop    %ebp
8010624e:	c3                   	ret    
8010624f:	90                   	nop

80106250 <uartputc.part.0>:
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}

void
uartputc(int c)
80106250:	55                   	push   %ebp
80106251:	89 e5                	mov    %esp,%ebp
80106253:	57                   	push   %edi
80106254:	56                   	push   %esi
80106255:	53                   	push   %ebx
80106256:	89 c7                	mov    %eax,%edi
80106258:	bb 80 00 00 00       	mov    $0x80,%ebx
8010625d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106262:	83 ec 0c             	sub    $0xc,%esp
80106265:	eb 1b                	jmp    80106282 <uartputc.part.0+0x32>
80106267:	89 f6                	mov    %esi,%esi
80106269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80106270:	83 ec 0c             	sub    $0xc,%esp
80106273:	6a 0a                	push   $0xa
80106275:	e8 16 c9 ff ff       	call   80102b90 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010627a:	83 c4 10             	add    $0x10,%esp
8010627d:	83 eb 01             	sub    $0x1,%ebx
80106280:	74 07                	je     80106289 <uartputc.part.0+0x39>
80106282:	89 f2                	mov    %esi,%edx
80106284:	ec                   	in     (%dx),%al
80106285:	a8 20                	test   $0x20,%al
80106287:	74 e7                	je     80106270 <uartputc.part.0+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106289:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010628e:	89 f8                	mov    %edi,%eax
80106290:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
80106291:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106294:	5b                   	pop    %ebx
80106295:	5e                   	pop    %esi
80106296:	5f                   	pop    %edi
80106297:	5d                   	pop    %ebp
80106298:	c3                   	ret    
80106299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801062a0 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801062a0:	55                   	push   %ebp
801062a1:	31 c9                	xor    %ecx,%ecx
801062a3:	89 c8                	mov    %ecx,%eax
801062a5:	89 e5                	mov    %esp,%ebp
801062a7:	57                   	push   %edi
801062a8:	56                   	push   %esi
801062a9:	53                   	push   %ebx
801062aa:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801062af:	89 da                	mov    %ebx,%edx
801062b1:	83 ec 0c             	sub    $0xc,%esp
801062b4:	ee                   	out    %al,(%dx)
801062b5:	bf fb 03 00 00       	mov    $0x3fb,%edi
801062ba:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801062bf:	89 fa                	mov    %edi,%edx
801062c1:	ee                   	out    %al,(%dx)
801062c2:	b8 0c 00 00 00       	mov    $0xc,%eax
801062c7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801062cc:	ee                   	out    %al,(%dx)
801062cd:	be f9 03 00 00       	mov    $0x3f9,%esi
801062d2:	89 c8                	mov    %ecx,%eax
801062d4:	89 f2                	mov    %esi,%edx
801062d6:	ee                   	out    %al,(%dx)
801062d7:	b8 03 00 00 00       	mov    $0x3,%eax
801062dc:	89 fa                	mov    %edi,%edx
801062de:	ee                   	out    %al,(%dx)
801062df:	ba fc 03 00 00       	mov    $0x3fc,%edx
801062e4:	89 c8                	mov    %ecx,%eax
801062e6:	ee                   	out    %al,(%dx)
801062e7:	b8 01 00 00 00       	mov    $0x1,%eax
801062ec:	89 f2                	mov    %esi,%edx
801062ee:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801062ef:	ba fd 03 00 00       	mov    $0x3fd,%edx
801062f4:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801062f5:	3c ff                	cmp    $0xff,%al
801062f7:	74 5a                	je     80106353 <uartinit+0xb3>
    return;
  uart = 1;
801062f9:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106300:	00 00 00 
80106303:	89 da                	mov    %ebx,%edx
80106305:	ec                   	in     (%dx),%al
80106306:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010630b:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
8010630c:	83 ec 08             	sub    $0x8,%esp
8010630f:	bb 68 86 10 80       	mov    $0x80108668,%ebx
80106314:	6a 00                	push   $0x0
80106316:	6a 04                	push   $0x4
80106318:	e8 a3 c3 ff ff       	call   801026c0 <ioapicenable>
8010631d:	83 c4 10             	add    $0x10,%esp
80106320:	b8 78 00 00 00       	mov    $0x78,%eax
80106325:	eb 13                	jmp    8010633a <uartinit+0x9a>
80106327:	89 f6                	mov    %esi,%esi
80106329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106330:	83 c3 01             	add    $0x1,%ebx
80106333:	0f be 03             	movsbl (%ebx),%eax
80106336:	84 c0                	test   %al,%al
80106338:	74 19                	je     80106353 <uartinit+0xb3>
void
uartputc(int c)
{
  int i;

  if(!uart)
8010633a:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80106340:	85 d2                	test   %edx,%edx
80106342:	74 ec                	je     80106330 <uartinit+0x90>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106344:	83 c3 01             	add    $0x1,%ebx
80106347:	e8 04 ff ff ff       	call   80106250 <uartputc.part.0>
8010634c:	0f be 03             	movsbl (%ebx),%eax
8010634f:	84 c0                	test   %al,%al
80106351:	75 e7                	jne    8010633a <uartinit+0x9a>
    uartputc(*p);
}
80106353:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106356:	5b                   	pop    %ebx
80106357:	5e                   	pop    %esi
80106358:	5f                   	pop    %edi
80106359:	5d                   	pop    %ebp
8010635a:	c3                   	ret    
8010635b:	90                   	nop
8010635c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106360 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80106360:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80106366:	55                   	push   %ebp
80106367:	89 e5                	mov    %esp,%ebp
  int i;

  if(!uart)
80106369:	85 d2                	test   %edx,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
8010636b:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;

  if(!uart)
8010636e:	74 10                	je     80106380 <uartputc+0x20>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80106370:	5d                   	pop    %ebp
80106371:	e9 da fe ff ff       	jmp    80106250 <uartputc.part.0>
80106376:	8d 76 00             	lea    0x0(%esi),%esi
80106379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106380:	5d                   	pop    %ebp
80106381:	c3                   	ret    
80106382:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106390 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80106390:	55                   	push   %ebp
80106391:	89 e5                	mov    %esp,%ebp
80106393:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106396:	68 20 62 10 80       	push   $0x80106220
8010639b:	e8 50 a4 ff ff       	call   801007f0 <consoleintr>
}
801063a0:	83 c4 10             	add    $0x10,%esp
801063a3:	c9                   	leave  
801063a4:	c3                   	ret    

801063a5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801063a5:	6a 00                	push   $0x0
  pushl $0
801063a7:	6a 00                	push   $0x0
  jmp alltraps
801063a9:	e9 9c fa ff ff       	jmp    80105e4a <alltraps>

801063ae <vector1>:
.globl vector1
vector1:
  pushl $0
801063ae:	6a 00                	push   $0x0
  pushl $1
801063b0:	6a 01                	push   $0x1
  jmp alltraps
801063b2:	e9 93 fa ff ff       	jmp    80105e4a <alltraps>

801063b7 <vector2>:
.globl vector2
vector2:
  pushl $0
801063b7:	6a 00                	push   $0x0
  pushl $2
801063b9:	6a 02                	push   $0x2
  jmp alltraps
801063bb:	e9 8a fa ff ff       	jmp    80105e4a <alltraps>

801063c0 <vector3>:
.globl vector3
vector3:
  pushl $0
801063c0:	6a 00                	push   $0x0
  pushl $3
801063c2:	6a 03                	push   $0x3
  jmp alltraps
801063c4:	e9 81 fa ff ff       	jmp    80105e4a <alltraps>

801063c9 <vector4>:
.globl vector4
vector4:
  pushl $0
801063c9:	6a 00                	push   $0x0
  pushl $4
801063cb:	6a 04                	push   $0x4
  jmp alltraps
801063cd:	e9 78 fa ff ff       	jmp    80105e4a <alltraps>

801063d2 <vector5>:
.globl vector5
vector5:
  pushl $0
801063d2:	6a 00                	push   $0x0
  pushl $5
801063d4:	6a 05                	push   $0x5
  jmp alltraps
801063d6:	e9 6f fa ff ff       	jmp    80105e4a <alltraps>

801063db <vector6>:
.globl vector6
vector6:
  pushl $0
801063db:	6a 00                	push   $0x0
  pushl $6
801063dd:	6a 06                	push   $0x6
  jmp alltraps
801063df:	e9 66 fa ff ff       	jmp    80105e4a <alltraps>

801063e4 <vector7>:
.globl vector7
vector7:
  pushl $0
801063e4:	6a 00                	push   $0x0
  pushl $7
801063e6:	6a 07                	push   $0x7
  jmp alltraps
801063e8:	e9 5d fa ff ff       	jmp    80105e4a <alltraps>

801063ed <vector8>:
.globl vector8
vector8:
  pushl $8
801063ed:	6a 08                	push   $0x8
  jmp alltraps
801063ef:	e9 56 fa ff ff       	jmp    80105e4a <alltraps>

801063f4 <vector9>:
.globl vector9
vector9:
  pushl $0
801063f4:	6a 00                	push   $0x0
  pushl $9
801063f6:	6a 09                	push   $0x9
  jmp alltraps
801063f8:	e9 4d fa ff ff       	jmp    80105e4a <alltraps>

801063fd <vector10>:
.globl vector10
vector10:
  pushl $10
801063fd:	6a 0a                	push   $0xa
  jmp alltraps
801063ff:	e9 46 fa ff ff       	jmp    80105e4a <alltraps>

80106404 <vector11>:
.globl vector11
vector11:
  pushl $11
80106404:	6a 0b                	push   $0xb
  jmp alltraps
80106406:	e9 3f fa ff ff       	jmp    80105e4a <alltraps>

8010640b <vector12>:
.globl vector12
vector12:
  pushl $12
8010640b:	6a 0c                	push   $0xc
  jmp alltraps
8010640d:	e9 38 fa ff ff       	jmp    80105e4a <alltraps>

80106412 <vector13>:
.globl vector13
vector13:
  pushl $13
80106412:	6a 0d                	push   $0xd
  jmp alltraps
80106414:	e9 31 fa ff ff       	jmp    80105e4a <alltraps>

80106419 <vector14>:
.globl vector14
vector14:
  pushl $14
80106419:	6a 0e                	push   $0xe
  jmp alltraps
8010641b:	e9 2a fa ff ff       	jmp    80105e4a <alltraps>

80106420 <vector15>:
.globl vector15
vector15:
  pushl $0
80106420:	6a 00                	push   $0x0
  pushl $15
80106422:	6a 0f                	push   $0xf
  jmp alltraps
80106424:	e9 21 fa ff ff       	jmp    80105e4a <alltraps>

80106429 <vector16>:
.globl vector16
vector16:
  pushl $0
80106429:	6a 00                	push   $0x0
  pushl $16
8010642b:	6a 10                	push   $0x10
  jmp alltraps
8010642d:	e9 18 fa ff ff       	jmp    80105e4a <alltraps>

80106432 <vector17>:
.globl vector17
vector17:
  pushl $17
80106432:	6a 11                	push   $0x11
  jmp alltraps
80106434:	e9 11 fa ff ff       	jmp    80105e4a <alltraps>

80106439 <vector18>:
.globl vector18
vector18:
  pushl $0
80106439:	6a 00                	push   $0x0
  pushl $18
8010643b:	6a 12                	push   $0x12
  jmp alltraps
8010643d:	e9 08 fa ff ff       	jmp    80105e4a <alltraps>

80106442 <vector19>:
.globl vector19
vector19:
  pushl $0
80106442:	6a 00                	push   $0x0
  pushl $19
80106444:	6a 13                	push   $0x13
  jmp alltraps
80106446:	e9 ff f9 ff ff       	jmp    80105e4a <alltraps>

8010644b <vector20>:
.globl vector20
vector20:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $20
8010644d:	6a 14                	push   $0x14
  jmp alltraps
8010644f:	e9 f6 f9 ff ff       	jmp    80105e4a <alltraps>

80106454 <vector21>:
.globl vector21
vector21:
  pushl $0
80106454:	6a 00                	push   $0x0
  pushl $21
80106456:	6a 15                	push   $0x15
  jmp alltraps
80106458:	e9 ed f9 ff ff       	jmp    80105e4a <alltraps>

8010645d <vector22>:
.globl vector22
vector22:
  pushl $0
8010645d:	6a 00                	push   $0x0
  pushl $22
8010645f:	6a 16                	push   $0x16
  jmp alltraps
80106461:	e9 e4 f9 ff ff       	jmp    80105e4a <alltraps>

80106466 <vector23>:
.globl vector23
vector23:
  pushl $0
80106466:	6a 00                	push   $0x0
  pushl $23
80106468:	6a 17                	push   $0x17
  jmp alltraps
8010646a:	e9 db f9 ff ff       	jmp    80105e4a <alltraps>

8010646f <vector24>:
.globl vector24
vector24:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $24
80106471:	6a 18                	push   $0x18
  jmp alltraps
80106473:	e9 d2 f9 ff ff       	jmp    80105e4a <alltraps>

80106478 <vector25>:
.globl vector25
vector25:
  pushl $0
80106478:	6a 00                	push   $0x0
  pushl $25
8010647a:	6a 19                	push   $0x19
  jmp alltraps
8010647c:	e9 c9 f9 ff ff       	jmp    80105e4a <alltraps>

80106481 <vector26>:
.globl vector26
vector26:
  pushl $0
80106481:	6a 00                	push   $0x0
  pushl $26
80106483:	6a 1a                	push   $0x1a
  jmp alltraps
80106485:	e9 c0 f9 ff ff       	jmp    80105e4a <alltraps>

8010648a <vector27>:
.globl vector27
vector27:
  pushl $0
8010648a:	6a 00                	push   $0x0
  pushl $27
8010648c:	6a 1b                	push   $0x1b
  jmp alltraps
8010648e:	e9 b7 f9 ff ff       	jmp    80105e4a <alltraps>

80106493 <vector28>:
.globl vector28
vector28:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $28
80106495:	6a 1c                	push   $0x1c
  jmp alltraps
80106497:	e9 ae f9 ff ff       	jmp    80105e4a <alltraps>

8010649c <vector29>:
.globl vector29
vector29:
  pushl $0
8010649c:	6a 00                	push   $0x0
  pushl $29
8010649e:	6a 1d                	push   $0x1d
  jmp alltraps
801064a0:	e9 a5 f9 ff ff       	jmp    80105e4a <alltraps>

801064a5 <vector30>:
.globl vector30
vector30:
  pushl $0
801064a5:	6a 00                	push   $0x0
  pushl $30
801064a7:	6a 1e                	push   $0x1e
  jmp alltraps
801064a9:	e9 9c f9 ff ff       	jmp    80105e4a <alltraps>

801064ae <vector31>:
.globl vector31
vector31:
  pushl $0
801064ae:	6a 00                	push   $0x0
  pushl $31
801064b0:	6a 1f                	push   $0x1f
  jmp alltraps
801064b2:	e9 93 f9 ff ff       	jmp    80105e4a <alltraps>

801064b7 <vector32>:
.globl vector32
vector32:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $32
801064b9:	6a 20                	push   $0x20
  jmp alltraps
801064bb:	e9 8a f9 ff ff       	jmp    80105e4a <alltraps>

801064c0 <vector33>:
.globl vector33
vector33:
  pushl $0
801064c0:	6a 00                	push   $0x0
  pushl $33
801064c2:	6a 21                	push   $0x21
  jmp alltraps
801064c4:	e9 81 f9 ff ff       	jmp    80105e4a <alltraps>

801064c9 <vector34>:
.globl vector34
vector34:
  pushl $0
801064c9:	6a 00                	push   $0x0
  pushl $34
801064cb:	6a 22                	push   $0x22
  jmp alltraps
801064cd:	e9 78 f9 ff ff       	jmp    80105e4a <alltraps>

801064d2 <vector35>:
.globl vector35
vector35:
  pushl $0
801064d2:	6a 00                	push   $0x0
  pushl $35
801064d4:	6a 23                	push   $0x23
  jmp alltraps
801064d6:	e9 6f f9 ff ff       	jmp    80105e4a <alltraps>

801064db <vector36>:
.globl vector36
vector36:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $36
801064dd:	6a 24                	push   $0x24
  jmp alltraps
801064df:	e9 66 f9 ff ff       	jmp    80105e4a <alltraps>

801064e4 <vector37>:
.globl vector37
vector37:
  pushl $0
801064e4:	6a 00                	push   $0x0
  pushl $37
801064e6:	6a 25                	push   $0x25
  jmp alltraps
801064e8:	e9 5d f9 ff ff       	jmp    80105e4a <alltraps>

801064ed <vector38>:
.globl vector38
vector38:
  pushl $0
801064ed:	6a 00                	push   $0x0
  pushl $38
801064ef:	6a 26                	push   $0x26
  jmp alltraps
801064f1:	e9 54 f9 ff ff       	jmp    80105e4a <alltraps>

801064f6 <vector39>:
.globl vector39
vector39:
  pushl $0
801064f6:	6a 00                	push   $0x0
  pushl $39
801064f8:	6a 27                	push   $0x27
  jmp alltraps
801064fa:	e9 4b f9 ff ff       	jmp    80105e4a <alltraps>

801064ff <vector40>:
.globl vector40
vector40:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $40
80106501:	6a 28                	push   $0x28
  jmp alltraps
80106503:	e9 42 f9 ff ff       	jmp    80105e4a <alltraps>

80106508 <vector41>:
.globl vector41
vector41:
  pushl $0
80106508:	6a 00                	push   $0x0
  pushl $41
8010650a:	6a 29                	push   $0x29
  jmp alltraps
8010650c:	e9 39 f9 ff ff       	jmp    80105e4a <alltraps>

80106511 <vector42>:
.globl vector42
vector42:
  pushl $0
80106511:	6a 00                	push   $0x0
  pushl $42
80106513:	6a 2a                	push   $0x2a
  jmp alltraps
80106515:	e9 30 f9 ff ff       	jmp    80105e4a <alltraps>

8010651a <vector43>:
.globl vector43
vector43:
  pushl $0
8010651a:	6a 00                	push   $0x0
  pushl $43
8010651c:	6a 2b                	push   $0x2b
  jmp alltraps
8010651e:	e9 27 f9 ff ff       	jmp    80105e4a <alltraps>

80106523 <vector44>:
.globl vector44
vector44:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $44
80106525:	6a 2c                	push   $0x2c
  jmp alltraps
80106527:	e9 1e f9 ff ff       	jmp    80105e4a <alltraps>

8010652c <vector45>:
.globl vector45
vector45:
  pushl $0
8010652c:	6a 00                	push   $0x0
  pushl $45
8010652e:	6a 2d                	push   $0x2d
  jmp alltraps
80106530:	e9 15 f9 ff ff       	jmp    80105e4a <alltraps>

80106535 <vector46>:
.globl vector46
vector46:
  pushl $0
80106535:	6a 00                	push   $0x0
  pushl $46
80106537:	6a 2e                	push   $0x2e
  jmp alltraps
80106539:	e9 0c f9 ff ff       	jmp    80105e4a <alltraps>

8010653e <vector47>:
.globl vector47
vector47:
  pushl $0
8010653e:	6a 00                	push   $0x0
  pushl $47
80106540:	6a 2f                	push   $0x2f
  jmp alltraps
80106542:	e9 03 f9 ff ff       	jmp    80105e4a <alltraps>

80106547 <vector48>:
.globl vector48
vector48:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $48
80106549:	6a 30                	push   $0x30
  jmp alltraps
8010654b:	e9 fa f8 ff ff       	jmp    80105e4a <alltraps>

80106550 <vector49>:
.globl vector49
vector49:
  pushl $0
80106550:	6a 00                	push   $0x0
  pushl $49
80106552:	6a 31                	push   $0x31
  jmp alltraps
80106554:	e9 f1 f8 ff ff       	jmp    80105e4a <alltraps>

80106559 <vector50>:
.globl vector50
vector50:
  pushl $0
80106559:	6a 00                	push   $0x0
  pushl $50
8010655b:	6a 32                	push   $0x32
  jmp alltraps
8010655d:	e9 e8 f8 ff ff       	jmp    80105e4a <alltraps>

80106562 <vector51>:
.globl vector51
vector51:
  pushl $0
80106562:	6a 00                	push   $0x0
  pushl $51
80106564:	6a 33                	push   $0x33
  jmp alltraps
80106566:	e9 df f8 ff ff       	jmp    80105e4a <alltraps>

8010656b <vector52>:
.globl vector52
vector52:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $52
8010656d:	6a 34                	push   $0x34
  jmp alltraps
8010656f:	e9 d6 f8 ff ff       	jmp    80105e4a <alltraps>

80106574 <vector53>:
.globl vector53
vector53:
  pushl $0
80106574:	6a 00                	push   $0x0
  pushl $53
80106576:	6a 35                	push   $0x35
  jmp alltraps
80106578:	e9 cd f8 ff ff       	jmp    80105e4a <alltraps>

8010657d <vector54>:
.globl vector54
vector54:
  pushl $0
8010657d:	6a 00                	push   $0x0
  pushl $54
8010657f:	6a 36                	push   $0x36
  jmp alltraps
80106581:	e9 c4 f8 ff ff       	jmp    80105e4a <alltraps>

80106586 <vector55>:
.globl vector55
vector55:
  pushl $0
80106586:	6a 00                	push   $0x0
  pushl $55
80106588:	6a 37                	push   $0x37
  jmp alltraps
8010658a:	e9 bb f8 ff ff       	jmp    80105e4a <alltraps>

8010658f <vector56>:
.globl vector56
vector56:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $56
80106591:	6a 38                	push   $0x38
  jmp alltraps
80106593:	e9 b2 f8 ff ff       	jmp    80105e4a <alltraps>

80106598 <vector57>:
.globl vector57
vector57:
  pushl $0
80106598:	6a 00                	push   $0x0
  pushl $57
8010659a:	6a 39                	push   $0x39
  jmp alltraps
8010659c:	e9 a9 f8 ff ff       	jmp    80105e4a <alltraps>

801065a1 <vector58>:
.globl vector58
vector58:
  pushl $0
801065a1:	6a 00                	push   $0x0
  pushl $58
801065a3:	6a 3a                	push   $0x3a
  jmp alltraps
801065a5:	e9 a0 f8 ff ff       	jmp    80105e4a <alltraps>

801065aa <vector59>:
.globl vector59
vector59:
  pushl $0
801065aa:	6a 00                	push   $0x0
  pushl $59
801065ac:	6a 3b                	push   $0x3b
  jmp alltraps
801065ae:	e9 97 f8 ff ff       	jmp    80105e4a <alltraps>

801065b3 <vector60>:
.globl vector60
vector60:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $60
801065b5:	6a 3c                	push   $0x3c
  jmp alltraps
801065b7:	e9 8e f8 ff ff       	jmp    80105e4a <alltraps>

801065bc <vector61>:
.globl vector61
vector61:
  pushl $0
801065bc:	6a 00                	push   $0x0
  pushl $61
801065be:	6a 3d                	push   $0x3d
  jmp alltraps
801065c0:	e9 85 f8 ff ff       	jmp    80105e4a <alltraps>

801065c5 <vector62>:
.globl vector62
vector62:
  pushl $0
801065c5:	6a 00                	push   $0x0
  pushl $62
801065c7:	6a 3e                	push   $0x3e
  jmp alltraps
801065c9:	e9 7c f8 ff ff       	jmp    80105e4a <alltraps>

801065ce <vector63>:
.globl vector63
vector63:
  pushl $0
801065ce:	6a 00                	push   $0x0
  pushl $63
801065d0:	6a 3f                	push   $0x3f
  jmp alltraps
801065d2:	e9 73 f8 ff ff       	jmp    80105e4a <alltraps>

801065d7 <vector64>:
.globl vector64
vector64:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $64
801065d9:	6a 40                	push   $0x40
  jmp alltraps
801065db:	e9 6a f8 ff ff       	jmp    80105e4a <alltraps>

801065e0 <vector65>:
.globl vector65
vector65:
  pushl $0
801065e0:	6a 00                	push   $0x0
  pushl $65
801065e2:	6a 41                	push   $0x41
  jmp alltraps
801065e4:	e9 61 f8 ff ff       	jmp    80105e4a <alltraps>

801065e9 <vector66>:
.globl vector66
vector66:
  pushl $0
801065e9:	6a 00                	push   $0x0
  pushl $66
801065eb:	6a 42                	push   $0x42
  jmp alltraps
801065ed:	e9 58 f8 ff ff       	jmp    80105e4a <alltraps>

801065f2 <vector67>:
.globl vector67
vector67:
  pushl $0
801065f2:	6a 00                	push   $0x0
  pushl $67
801065f4:	6a 43                	push   $0x43
  jmp alltraps
801065f6:	e9 4f f8 ff ff       	jmp    80105e4a <alltraps>

801065fb <vector68>:
.globl vector68
vector68:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $68
801065fd:	6a 44                	push   $0x44
  jmp alltraps
801065ff:	e9 46 f8 ff ff       	jmp    80105e4a <alltraps>

80106604 <vector69>:
.globl vector69
vector69:
  pushl $0
80106604:	6a 00                	push   $0x0
  pushl $69
80106606:	6a 45                	push   $0x45
  jmp alltraps
80106608:	e9 3d f8 ff ff       	jmp    80105e4a <alltraps>

8010660d <vector70>:
.globl vector70
vector70:
  pushl $0
8010660d:	6a 00                	push   $0x0
  pushl $70
8010660f:	6a 46                	push   $0x46
  jmp alltraps
80106611:	e9 34 f8 ff ff       	jmp    80105e4a <alltraps>

80106616 <vector71>:
.globl vector71
vector71:
  pushl $0
80106616:	6a 00                	push   $0x0
  pushl $71
80106618:	6a 47                	push   $0x47
  jmp alltraps
8010661a:	e9 2b f8 ff ff       	jmp    80105e4a <alltraps>

8010661f <vector72>:
.globl vector72
vector72:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $72
80106621:	6a 48                	push   $0x48
  jmp alltraps
80106623:	e9 22 f8 ff ff       	jmp    80105e4a <alltraps>

80106628 <vector73>:
.globl vector73
vector73:
  pushl $0
80106628:	6a 00                	push   $0x0
  pushl $73
8010662a:	6a 49                	push   $0x49
  jmp alltraps
8010662c:	e9 19 f8 ff ff       	jmp    80105e4a <alltraps>

80106631 <vector74>:
.globl vector74
vector74:
  pushl $0
80106631:	6a 00                	push   $0x0
  pushl $74
80106633:	6a 4a                	push   $0x4a
  jmp alltraps
80106635:	e9 10 f8 ff ff       	jmp    80105e4a <alltraps>

8010663a <vector75>:
.globl vector75
vector75:
  pushl $0
8010663a:	6a 00                	push   $0x0
  pushl $75
8010663c:	6a 4b                	push   $0x4b
  jmp alltraps
8010663e:	e9 07 f8 ff ff       	jmp    80105e4a <alltraps>

80106643 <vector76>:
.globl vector76
vector76:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $76
80106645:	6a 4c                	push   $0x4c
  jmp alltraps
80106647:	e9 fe f7 ff ff       	jmp    80105e4a <alltraps>

8010664c <vector77>:
.globl vector77
vector77:
  pushl $0
8010664c:	6a 00                	push   $0x0
  pushl $77
8010664e:	6a 4d                	push   $0x4d
  jmp alltraps
80106650:	e9 f5 f7 ff ff       	jmp    80105e4a <alltraps>

80106655 <vector78>:
.globl vector78
vector78:
  pushl $0
80106655:	6a 00                	push   $0x0
  pushl $78
80106657:	6a 4e                	push   $0x4e
  jmp alltraps
80106659:	e9 ec f7 ff ff       	jmp    80105e4a <alltraps>

8010665e <vector79>:
.globl vector79
vector79:
  pushl $0
8010665e:	6a 00                	push   $0x0
  pushl $79
80106660:	6a 4f                	push   $0x4f
  jmp alltraps
80106662:	e9 e3 f7 ff ff       	jmp    80105e4a <alltraps>

80106667 <vector80>:
.globl vector80
vector80:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $80
80106669:	6a 50                	push   $0x50
  jmp alltraps
8010666b:	e9 da f7 ff ff       	jmp    80105e4a <alltraps>

80106670 <vector81>:
.globl vector81
vector81:
  pushl $0
80106670:	6a 00                	push   $0x0
  pushl $81
80106672:	6a 51                	push   $0x51
  jmp alltraps
80106674:	e9 d1 f7 ff ff       	jmp    80105e4a <alltraps>

80106679 <vector82>:
.globl vector82
vector82:
  pushl $0
80106679:	6a 00                	push   $0x0
  pushl $82
8010667b:	6a 52                	push   $0x52
  jmp alltraps
8010667d:	e9 c8 f7 ff ff       	jmp    80105e4a <alltraps>

80106682 <vector83>:
.globl vector83
vector83:
  pushl $0
80106682:	6a 00                	push   $0x0
  pushl $83
80106684:	6a 53                	push   $0x53
  jmp alltraps
80106686:	e9 bf f7 ff ff       	jmp    80105e4a <alltraps>

8010668b <vector84>:
.globl vector84
vector84:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $84
8010668d:	6a 54                	push   $0x54
  jmp alltraps
8010668f:	e9 b6 f7 ff ff       	jmp    80105e4a <alltraps>

80106694 <vector85>:
.globl vector85
vector85:
  pushl $0
80106694:	6a 00                	push   $0x0
  pushl $85
80106696:	6a 55                	push   $0x55
  jmp alltraps
80106698:	e9 ad f7 ff ff       	jmp    80105e4a <alltraps>

8010669d <vector86>:
.globl vector86
vector86:
  pushl $0
8010669d:	6a 00                	push   $0x0
  pushl $86
8010669f:	6a 56                	push   $0x56
  jmp alltraps
801066a1:	e9 a4 f7 ff ff       	jmp    80105e4a <alltraps>

801066a6 <vector87>:
.globl vector87
vector87:
  pushl $0
801066a6:	6a 00                	push   $0x0
  pushl $87
801066a8:	6a 57                	push   $0x57
  jmp alltraps
801066aa:	e9 9b f7 ff ff       	jmp    80105e4a <alltraps>

801066af <vector88>:
.globl vector88
vector88:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $88
801066b1:	6a 58                	push   $0x58
  jmp alltraps
801066b3:	e9 92 f7 ff ff       	jmp    80105e4a <alltraps>

801066b8 <vector89>:
.globl vector89
vector89:
  pushl $0
801066b8:	6a 00                	push   $0x0
  pushl $89
801066ba:	6a 59                	push   $0x59
  jmp alltraps
801066bc:	e9 89 f7 ff ff       	jmp    80105e4a <alltraps>

801066c1 <vector90>:
.globl vector90
vector90:
  pushl $0
801066c1:	6a 00                	push   $0x0
  pushl $90
801066c3:	6a 5a                	push   $0x5a
  jmp alltraps
801066c5:	e9 80 f7 ff ff       	jmp    80105e4a <alltraps>

801066ca <vector91>:
.globl vector91
vector91:
  pushl $0
801066ca:	6a 00                	push   $0x0
  pushl $91
801066cc:	6a 5b                	push   $0x5b
  jmp alltraps
801066ce:	e9 77 f7 ff ff       	jmp    80105e4a <alltraps>

801066d3 <vector92>:
.globl vector92
vector92:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $92
801066d5:	6a 5c                	push   $0x5c
  jmp alltraps
801066d7:	e9 6e f7 ff ff       	jmp    80105e4a <alltraps>

801066dc <vector93>:
.globl vector93
vector93:
  pushl $0
801066dc:	6a 00                	push   $0x0
  pushl $93
801066de:	6a 5d                	push   $0x5d
  jmp alltraps
801066e0:	e9 65 f7 ff ff       	jmp    80105e4a <alltraps>

801066e5 <vector94>:
.globl vector94
vector94:
  pushl $0
801066e5:	6a 00                	push   $0x0
  pushl $94
801066e7:	6a 5e                	push   $0x5e
  jmp alltraps
801066e9:	e9 5c f7 ff ff       	jmp    80105e4a <alltraps>

801066ee <vector95>:
.globl vector95
vector95:
  pushl $0
801066ee:	6a 00                	push   $0x0
  pushl $95
801066f0:	6a 5f                	push   $0x5f
  jmp alltraps
801066f2:	e9 53 f7 ff ff       	jmp    80105e4a <alltraps>

801066f7 <vector96>:
.globl vector96
vector96:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $96
801066f9:	6a 60                	push   $0x60
  jmp alltraps
801066fb:	e9 4a f7 ff ff       	jmp    80105e4a <alltraps>

80106700 <vector97>:
.globl vector97
vector97:
  pushl $0
80106700:	6a 00                	push   $0x0
  pushl $97
80106702:	6a 61                	push   $0x61
  jmp alltraps
80106704:	e9 41 f7 ff ff       	jmp    80105e4a <alltraps>

80106709 <vector98>:
.globl vector98
vector98:
  pushl $0
80106709:	6a 00                	push   $0x0
  pushl $98
8010670b:	6a 62                	push   $0x62
  jmp alltraps
8010670d:	e9 38 f7 ff ff       	jmp    80105e4a <alltraps>

80106712 <vector99>:
.globl vector99
vector99:
  pushl $0
80106712:	6a 00                	push   $0x0
  pushl $99
80106714:	6a 63                	push   $0x63
  jmp alltraps
80106716:	e9 2f f7 ff ff       	jmp    80105e4a <alltraps>

8010671b <vector100>:
.globl vector100
vector100:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $100
8010671d:	6a 64                	push   $0x64
  jmp alltraps
8010671f:	e9 26 f7 ff ff       	jmp    80105e4a <alltraps>

80106724 <vector101>:
.globl vector101
vector101:
  pushl $0
80106724:	6a 00                	push   $0x0
  pushl $101
80106726:	6a 65                	push   $0x65
  jmp alltraps
80106728:	e9 1d f7 ff ff       	jmp    80105e4a <alltraps>

8010672d <vector102>:
.globl vector102
vector102:
  pushl $0
8010672d:	6a 00                	push   $0x0
  pushl $102
8010672f:	6a 66                	push   $0x66
  jmp alltraps
80106731:	e9 14 f7 ff ff       	jmp    80105e4a <alltraps>

80106736 <vector103>:
.globl vector103
vector103:
  pushl $0
80106736:	6a 00                	push   $0x0
  pushl $103
80106738:	6a 67                	push   $0x67
  jmp alltraps
8010673a:	e9 0b f7 ff ff       	jmp    80105e4a <alltraps>

8010673f <vector104>:
.globl vector104
vector104:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $104
80106741:	6a 68                	push   $0x68
  jmp alltraps
80106743:	e9 02 f7 ff ff       	jmp    80105e4a <alltraps>

80106748 <vector105>:
.globl vector105
vector105:
  pushl $0
80106748:	6a 00                	push   $0x0
  pushl $105
8010674a:	6a 69                	push   $0x69
  jmp alltraps
8010674c:	e9 f9 f6 ff ff       	jmp    80105e4a <alltraps>

80106751 <vector106>:
.globl vector106
vector106:
  pushl $0
80106751:	6a 00                	push   $0x0
  pushl $106
80106753:	6a 6a                	push   $0x6a
  jmp alltraps
80106755:	e9 f0 f6 ff ff       	jmp    80105e4a <alltraps>

8010675a <vector107>:
.globl vector107
vector107:
  pushl $0
8010675a:	6a 00                	push   $0x0
  pushl $107
8010675c:	6a 6b                	push   $0x6b
  jmp alltraps
8010675e:	e9 e7 f6 ff ff       	jmp    80105e4a <alltraps>

80106763 <vector108>:
.globl vector108
vector108:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $108
80106765:	6a 6c                	push   $0x6c
  jmp alltraps
80106767:	e9 de f6 ff ff       	jmp    80105e4a <alltraps>

8010676c <vector109>:
.globl vector109
vector109:
  pushl $0
8010676c:	6a 00                	push   $0x0
  pushl $109
8010676e:	6a 6d                	push   $0x6d
  jmp alltraps
80106770:	e9 d5 f6 ff ff       	jmp    80105e4a <alltraps>

80106775 <vector110>:
.globl vector110
vector110:
  pushl $0
80106775:	6a 00                	push   $0x0
  pushl $110
80106777:	6a 6e                	push   $0x6e
  jmp alltraps
80106779:	e9 cc f6 ff ff       	jmp    80105e4a <alltraps>

8010677e <vector111>:
.globl vector111
vector111:
  pushl $0
8010677e:	6a 00                	push   $0x0
  pushl $111
80106780:	6a 6f                	push   $0x6f
  jmp alltraps
80106782:	e9 c3 f6 ff ff       	jmp    80105e4a <alltraps>

80106787 <vector112>:
.globl vector112
vector112:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $112
80106789:	6a 70                	push   $0x70
  jmp alltraps
8010678b:	e9 ba f6 ff ff       	jmp    80105e4a <alltraps>

80106790 <vector113>:
.globl vector113
vector113:
  pushl $0
80106790:	6a 00                	push   $0x0
  pushl $113
80106792:	6a 71                	push   $0x71
  jmp alltraps
80106794:	e9 b1 f6 ff ff       	jmp    80105e4a <alltraps>

80106799 <vector114>:
.globl vector114
vector114:
  pushl $0
80106799:	6a 00                	push   $0x0
  pushl $114
8010679b:	6a 72                	push   $0x72
  jmp alltraps
8010679d:	e9 a8 f6 ff ff       	jmp    80105e4a <alltraps>

801067a2 <vector115>:
.globl vector115
vector115:
  pushl $0
801067a2:	6a 00                	push   $0x0
  pushl $115
801067a4:	6a 73                	push   $0x73
  jmp alltraps
801067a6:	e9 9f f6 ff ff       	jmp    80105e4a <alltraps>

801067ab <vector116>:
.globl vector116
vector116:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $116
801067ad:	6a 74                	push   $0x74
  jmp alltraps
801067af:	e9 96 f6 ff ff       	jmp    80105e4a <alltraps>

801067b4 <vector117>:
.globl vector117
vector117:
  pushl $0
801067b4:	6a 00                	push   $0x0
  pushl $117
801067b6:	6a 75                	push   $0x75
  jmp alltraps
801067b8:	e9 8d f6 ff ff       	jmp    80105e4a <alltraps>

801067bd <vector118>:
.globl vector118
vector118:
  pushl $0
801067bd:	6a 00                	push   $0x0
  pushl $118
801067bf:	6a 76                	push   $0x76
  jmp alltraps
801067c1:	e9 84 f6 ff ff       	jmp    80105e4a <alltraps>

801067c6 <vector119>:
.globl vector119
vector119:
  pushl $0
801067c6:	6a 00                	push   $0x0
  pushl $119
801067c8:	6a 77                	push   $0x77
  jmp alltraps
801067ca:	e9 7b f6 ff ff       	jmp    80105e4a <alltraps>

801067cf <vector120>:
.globl vector120
vector120:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $120
801067d1:	6a 78                	push   $0x78
  jmp alltraps
801067d3:	e9 72 f6 ff ff       	jmp    80105e4a <alltraps>

801067d8 <vector121>:
.globl vector121
vector121:
  pushl $0
801067d8:	6a 00                	push   $0x0
  pushl $121
801067da:	6a 79                	push   $0x79
  jmp alltraps
801067dc:	e9 69 f6 ff ff       	jmp    80105e4a <alltraps>

801067e1 <vector122>:
.globl vector122
vector122:
  pushl $0
801067e1:	6a 00                	push   $0x0
  pushl $122
801067e3:	6a 7a                	push   $0x7a
  jmp alltraps
801067e5:	e9 60 f6 ff ff       	jmp    80105e4a <alltraps>

801067ea <vector123>:
.globl vector123
vector123:
  pushl $0
801067ea:	6a 00                	push   $0x0
  pushl $123
801067ec:	6a 7b                	push   $0x7b
  jmp alltraps
801067ee:	e9 57 f6 ff ff       	jmp    80105e4a <alltraps>

801067f3 <vector124>:
.globl vector124
vector124:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $124
801067f5:	6a 7c                	push   $0x7c
  jmp alltraps
801067f7:	e9 4e f6 ff ff       	jmp    80105e4a <alltraps>

801067fc <vector125>:
.globl vector125
vector125:
  pushl $0
801067fc:	6a 00                	push   $0x0
  pushl $125
801067fe:	6a 7d                	push   $0x7d
  jmp alltraps
80106800:	e9 45 f6 ff ff       	jmp    80105e4a <alltraps>

80106805 <vector126>:
.globl vector126
vector126:
  pushl $0
80106805:	6a 00                	push   $0x0
  pushl $126
80106807:	6a 7e                	push   $0x7e
  jmp alltraps
80106809:	e9 3c f6 ff ff       	jmp    80105e4a <alltraps>

8010680e <vector127>:
.globl vector127
vector127:
  pushl $0
8010680e:	6a 00                	push   $0x0
  pushl $127
80106810:	6a 7f                	push   $0x7f
  jmp alltraps
80106812:	e9 33 f6 ff ff       	jmp    80105e4a <alltraps>

80106817 <vector128>:
.globl vector128
vector128:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $128
80106819:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010681e:	e9 27 f6 ff ff       	jmp    80105e4a <alltraps>

80106823 <vector129>:
.globl vector129
vector129:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $129
80106825:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010682a:	e9 1b f6 ff ff       	jmp    80105e4a <alltraps>

8010682f <vector130>:
.globl vector130
vector130:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $130
80106831:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106836:	e9 0f f6 ff ff       	jmp    80105e4a <alltraps>

8010683b <vector131>:
.globl vector131
vector131:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $131
8010683d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106842:	e9 03 f6 ff ff       	jmp    80105e4a <alltraps>

80106847 <vector132>:
.globl vector132
vector132:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $132
80106849:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010684e:	e9 f7 f5 ff ff       	jmp    80105e4a <alltraps>

80106853 <vector133>:
.globl vector133
vector133:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $133
80106855:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010685a:	e9 eb f5 ff ff       	jmp    80105e4a <alltraps>

8010685f <vector134>:
.globl vector134
vector134:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $134
80106861:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106866:	e9 df f5 ff ff       	jmp    80105e4a <alltraps>

8010686b <vector135>:
.globl vector135
vector135:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $135
8010686d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106872:	e9 d3 f5 ff ff       	jmp    80105e4a <alltraps>

80106877 <vector136>:
.globl vector136
vector136:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $136
80106879:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010687e:	e9 c7 f5 ff ff       	jmp    80105e4a <alltraps>

80106883 <vector137>:
.globl vector137
vector137:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $137
80106885:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010688a:	e9 bb f5 ff ff       	jmp    80105e4a <alltraps>

8010688f <vector138>:
.globl vector138
vector138:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $138
80106891:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106896:	e9 af f5 ff ff       	jmp    80105e4a <alltraps>

8010689b <vector139>:
.globl vector139
vector139:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $139
8010689d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801068a2:	e9 a3 f5 ff ff       	jmp    80105e4a <alltraps>

801068a7 <vector140>:
.globl vector140
vector140:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $140
801068a9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801068ae:	e9 97 f5 ff ff       	jmp    80105e4a <alltraps>

801068b3 <vector141>:
.globl vector141
vector141:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $141
801068b5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801068ba:	e9 8b f5 ff ff       	jmp    80105e4a <alltraps>

801068bf <vector142>:
.globl vector142
vector142:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $142
801068c1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801068c6:	e9 7f f5 ff ff       	jmp    80105e4a <alltraps>

801068cb <vector143>:
.globl vector143
vector143:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $143
801068cd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801068d2:	e9 73 f5 ff ff       	jmp    80105e4a <alltraps>

801068d7 <vector144>:
.globl vector144
vector144:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $144
801068d9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801068de:	e9 67 f5 ff ff       	jmp    80105e4a <alltraps>

801068e3 <vector145>:
.globl vector145
vector145:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $145
801068e5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801068ea:	e9 5b f5 ff ff       	jmp    80105e4a <alltraps>

801068ef <vector146>:
.globl vector146
vector146:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $146
801068f1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801068f6:	e9 4f f5 ff ff       	jmp    80105e4a <alltraps>

801068fb <vector147>:
.globl vector147
vector147:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $147
801068fd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106902:	e9 43 f5 ff ff       	jmp    80105e4a <alltraps>

80106907 <vector148>:
.globl vector148
vector148:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $148
80106909:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010690e:	e9 37 f5 ff ff       	jmp    80105e4a <alltraps>

80106913 <vector149>:
.globl vector149
vector149:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $149
80106915:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010691a:	e9 2b f5 ff ff       	jmp    80105e4a <alltraps>

8010691f <vector150>:
.globl vector150
vector150:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $150
80106921:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106926:	e9 1f f5 ff ff       	jmp    80105e4a <alltraps>

8010692b <vector151>:
.globl vector151
vector151:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $151
8010692d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106932:	e9 13 f5 ff ff       	jmp    80105e4a <alltraps>

80106937 <vector152>:
.globl vector152
vector152:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $152
80106939:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010693e:	e9 07 f5 ff ff       	jmp    80105e4a <alltraps>

80106943 <vector153>:
.globl vector153
vector153:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $153
80106945:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010694a:	e9 fb f4 ff ff       	jmp    80105e4a <alltraps>

8010694f <vector154>:
.globl vector154
vector154:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $154
80106951:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106956:	e9 ef f4 ff ff       	jmp    80105e4a <alltraps>

8010695b <vector155>:
.globl vector155
vector155:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $155
8010695d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106962:	e9 e3 f4 ff ff       	jmp    80105e4a <alltraps>

80106967 <vector156>:
.globl vector156
vector156:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $156
80106969:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010696e:	e9 d7 f4 ff ff       	jmp    80105e4a <alltraps>

80106973 <vector157>:
.globl vector157
vector157:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $157
80106975:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010697a:	e9 cb f4 ff ff       	jmp    80105e4a <alltraps>

8010697f <vector158>:
.globl vector158
vector158:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $158
80106981:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106986:	e9 bf f4 ff ff       	jmp    80105e4a <alltraps>

8010698b <vector159>:
.globl vector159
vector159:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $159
8010698d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106992:	e9 b3 f4 ff ff       	jmp    80105e4a <alltraps>

80106997 <vector160>:
.globl vector160
vector160:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $160
80106999:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010699e:	e9 a7 f4 ff ff       	jmp    80105e4a <alltraps>

801069a3 <vector161>:
.globl vector161
vector161:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $161
801069a5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801069aa:	e9 9b f4 ff ff       	jmp    80105e4a <alltraps>

801069af <vector162>:
.globl vector162
vector162:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $162
801069b1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801069b6:	e9 8f f4 ff ff       	jmp    80105e4a <alltraps>

801069bb <vector163>:
.globl vector163
vector163:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $163
801069bd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801069c2:	e9 83 f4 ff ff       	jmp    80105e4a <alltraps>

801069c7 <vector164>:
.globl vector164
vector164:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $164
801069c9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801069ce:	e9 77 f4 ff ff       	jmp    80105e4a <alltraps>

801069d3 <vector165>:
.globl vector165
vector165:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $165
801069d5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801069da:	e9 6b f4 ff ff       	jmp    80105e4a <alltraps>

801069df <vector166>:
.globl vector166
vector166:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $166
801069e1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801069e6:	e9 5f f4 ff ff       	jmp    80105e4a <alltraps>

801069eb <vector167>:
.globl vector167
vector167:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $167
801069ed:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801069f2:	e9 53 f4 ff ff       	jmp    80105e4a <alltraps>

801069f7 <vector168>:
.globl vector168
vector168:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $168
801069f9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801069fe:	e9 47 f4 ff ff       	jmp    80105e4a <alltraps>

80106a03 <vector169>:
.globl vector169
vector169:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $169
80106a05:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106a0a:	e9 3b f4 ff ff       	jmp    80105e4a <alltraps>

80106a0f <vector170>:
.globl vector170
vector170:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $170
80106a11:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106a16:	e9 2f f4 ff ff       	jmp    80105e4a <alltraps>

80106a1b <vector171>:
.globl vector171
vector171:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $171
80106a1d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106a22:	e9 23 f4 ff ff       	jmp    80105e4a <alltraps>

80106a27 <vector172>:
.globl vector172
vector172:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $172
80106a29:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106a2e:	e9 17 f4 ff ff       	jmp    80105e4a <alltraps>

80106a33 <vector173>:
.globl vector173
vector173:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $173
80106a35:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106a3a:	e9 0b f4 ff ff       	jmp    80105e4a <alltraps>

80106a3f <vector174>:
.globl vector174
vector174:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $174
80106a41:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106a46:	e9 ff f3 ff ff       	jmp    80105e4a <alltraps>

80106a4b <vector175>:
.globl vector175
vector175:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $175
80106a4d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106a52:	e9 f3 f3 ff ff       	jmp    80105e4a <alltraps>

80106a57 <vector176>:
.globl vector176
vector176:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $176
80106a59:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106a5e:	e9 e7 f3 ff ff       	jmp    80105e4a <alltraps>

80106a63 <vector177>:
.globl vector177
vector177:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $177
80106a65:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106a6a:	e9 db f3 ff ff       	jmp    80105e4a <alltraps>

80106a6f <vector178>:
.globl vector178
vector178:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $178
80106a71:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106a76:	e9 cf f3 ff ff       	jmp    80105e4a <alltraps>

80106a7b <vector179>:
.globl vector179
vector179:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $179
80106a7d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106a82:	e9 c3 f3 ff ff       	jmp    80105e4a <alltraps>

80106a87 <vector180>:
.globl vector180
vector180:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $180
80106a89:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106a8e:	e9 b7 f3 ff ff       	jmp    80105e4a <alltraps>

80106a93 <vector181>:
.globl vector181
vector181:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $181
80106a95:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106a9a:	e9 ab f3 ff ff       	jmp    80105e4a <alltraps>

80106a9f <vector182>:
.globl vector182
vector182:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $182
80106aa1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106aa6:	e9 9f f3 ff ff       	jmp    80105e4a <alltraps>

80106aab <vector183>:
.globl vector183
vector183:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $183
80106aad:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106ab2:	e9 93 f3 ff ff       	jmp    80105e4a <alltraps>

80106ab7 <vector184>:
.globl vector184
vector184:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $184
80106ab9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106abe:	e9 87 f3 ff ff       	jmp    80105e4a <alltraps>

80106ac3 <vector185>:
.globl vector185
vector185:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $185
80106ac5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106aca:	e9 7b f3 ff ff       	jmp    80105e4a <alltraps>

80106acf <vector186>:
.globl vector186
vector186:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $186
80106ad1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106ad6:	e9 6f f3 ff ff       	jmp    80105e4a <alltraps>

80106adb <vector187>:
.globl vector187
vector187:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $187
80106add:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106ae2:	e9 63 f3 ff ff       	jmp    80105e4a <alltraps>

80106ae7 <vector188>:
.globl vector188
vector188:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $188
80106ae9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106aee:	e9 57 f3 ff ff       	jmp    80105e4a <alltraps>

80106af3 <vector189>:
.globl vector189
vector189:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $189
80106af5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106afa:	e9 4b f3 ff ff       	jmp    80105e4a <alltraps>

80106aff <vector190>:
.globl vector190
vector190:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $190
80106b01:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106b06:	e9 3f f3 ff ff       	jmp    80105e4a <alltraps>

80106b0b <vector191>:
.globl vector191
vector191:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $191
80106b0d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106b12:	e9 33 f3 ff ff       	jmp    80105e4a <alltraps>

80106b17 <vector192>:
.globl vector192
vector192:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $192
80106b19:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106b1e:	e9 27 f3 ff ff       	jmp    80105e4a <alltraps>

80106b23 <vector193>:
.globl vector193
vector193:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $193
80106b25:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106b2a:	e9 1b f3 ff ff       	jmp    80105e4a <alltraps>

80106b2f <vector194>:
.globl vector194
vector194:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $194
80106b31:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106b36:	e9 0f f3 ff ff       	jmp    80105e4a <alltraps>

80106b3b <vector195>:
.globl vector195
vector195:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $195
80106b3d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106b42:	e9 03 f3 ff ff       	jmp    80105e4a <alltraps>

80106b47 <vector196>:
.globl vector196
vector196:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $196
80106b49:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106b4e:	e9 f7 f2 ff ff       	jmp    80105e4a <alltraps>

80106b53 <vector197>:
.globl vector197
vector197:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $197
80106b55:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106b5a:	e9 eb f2 ff ff       	jmp    80105e4a <alltraps>

80106b5f <vector198>:
.globl vector198
vector198:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $198
80106b61:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106b66:	e9 df f2 ff ff       	jmp    80105e4a <alltraps>

80106b6b <vector199>:
.globl vector199
vector199:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $199
80106b6d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106b72:	e9 d3 f2 ff ff       	jmp    80105e4a <alltraps>

80106b77 <vector200>:
.globl vector200
vector200:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $200
80106b79:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106b7e:	e9 c7 f2 ff ff       	jmp    80105e4a <alltraps>

80106b83 <vector201>:
.globl vector201
vector201:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $201
80106b85:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106b8a:	e9 bb f2 ff ff       	jmp    80105e4a <alltraps>

80106b8f <vector202>:
.globl vector202
vector202:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $202
80106b91:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106b96:	e9 af f2 ff ff       	jmp    80105e4a <alltraps>

80106b9b <vector203>:
.globl vector203
vector203:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $203
80106b9d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106ba2:	e9 a3 f2 ff ff       	jmp    80105e4a <alltraps>

80106ba7 <vector204>:
.globl vector204
vector204:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $204
80106ba9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106bae:	e9 97 f2 ff ff       	jmp    80105e4a <alltraps>

80106bb3 <vector205>:
.globl vector205
vector205:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $205
80106bb5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106bba:	e9 8b f2 ff ff       	jmp    80105e4a <alltraps>

80106bbf <vector206>:
.globl vector206
vector206:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $206
80106bc1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106bc6:	e9 7f f2 ff ff       	jmp    80105e4a <alltraps>

80106bcb <vector207>:
.globl vector207
vector207:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $207
80106bcd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106bd2:	e9 73 f2 ff ff       	jmp    80105e4a <alltraps>

80106bd7 <vector208>:
.globl vector208
vector208:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $208
80106bd9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106bde:	e9 67 f2 ff ff       	jmp    80105e4a <alltraps>

80106be3 <vector209>:
.globl vector209
vector209:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $209
80106be5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106bea:	e9 5b f2 ff ff       	jmp    80105e4a <alltraps>

80106bef <vector210>:
.globl vector210
vector210:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $210
80106bf1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106bf6:	e9 4f f2 ff ff       	jmp    80105e4a <alltraps>

80106bfb <vector211>:
.globl vector211
vector211:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $211
80106bfd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106c02:	e9 43 f2 ff ff       	jmp    80105e4a <alltraps>

80106c07 <vector212>:
.globl vector212
vector212:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $212
80106c09:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106c0e:	e9 37 f2 ff ff       	jmp    80105e4a <alltraps>

80106c13 <vector213>:
.globl vector213
vector213:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $213
80106c15:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106c1a:	e9 2b f2 ff ff       	jmp    80105e4a <alltraps>

80106c1f <vector214>:
.globl vector214
vector214:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $214
80106c21:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106c26:	e9 1f f2 ff ff       	jmp    80105e4a <alltraps>

80106c2b <vector215>:
.globl vector215
vector215:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $215
80106c2d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106c32:	e9 13 f2 ff ff       	jmp    80105e4a <alltraps>

80106c37 <vector216>:
.globl vector216
vector216:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $216
80106c39:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106c3e:	e9 07 f2 ff ff       	jmp    80105e4a <alltraps>

80106c43 <vector217>:
.globl vector217
vector217:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $217
80106c45:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106c4a:	e9 fb f1 ff ff       	jmp    80105e4a <alltraps>

80106c4f <vector218>:
.globl vector218
vector218:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $218
80106c51:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106c56:	e9 ef f1 ff ff       	jmp    80105e4a <alltraps>

80106c5b <vector219>:
.globl vector219
vector219:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $219
80106c5d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106c62:	e9 e3 f1 ff ff       	jmp    80105e4a <alltraps>

80106c67 <vector220>:
.globl vector220
vector220:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $220
80106c69:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106c6e:	e9 d7 f1 ff ff       	jmp    80105e4a <alltraps>

80106c73 <vector221>:
.globl vector221
vector221:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $221
80106c75:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106c7a:	e9 cb f1 ff ff       	jmp    80105e4a <alltraps>

80106c7f <vector222>:
.globl vector222
vector222:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $222
80106c81:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106c86:	e9 bf f1 ff ff       	jmp    80105e4a <alltraps>

80106c8b <vector223>:
.globl vector223
vector223:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $223
80106c8d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106c92:	e9 b3 f1 ff ff       	jmp    80105e4a <alltraps>

80106c97 <vector224>:
.globl vector224
vector224:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $224
80106c99:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106c9e:	e9 a7 f1 ff ff       	jmp    80105e4a <alltraps>

80106ca3 <vector225>:
.globl vector225
vector225:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $225
80106ca5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106caa:	e9 9b f1 ff ff       	jmp    80105e4a <alltraps>

80106caf <vector226>:
.globl vector226
vector226:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $226
80106cb1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106cb6:	e9 8f f1 ff ff       	jmp    80105e4a <alltraps>

80106cbb <vector227>:
.globl vector227
vector227:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $227
80106cbd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106cc2:	e9 83 f1 ff ff       	jmp    80105e4a <alltraps>

80106cc7 <vector228>:
.globl vector228
vector228:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $228
80106cc9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106cce:	e9 77 f1 ff ff       	jmp    80105e4a <alltraps>

80106cd3 <vector229>:
.globl vector229
vector229:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $229
80106cd5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106cda:	e9 6b f1 ff ff       	jmp    80105e4a <alltraps>

80106cdf <vector230>:
.globl vector230
vector230:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $230
80106ce1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106ce6:	e9 5f f1 ff ff       	jmp    80105e4a <alltraps>

80106ceb <vector231>:
.globl vector231
vector231:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $231
80106ced:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106cf2:	e9 53 f1 ff ff       	jmp    80105e4a <alltraps>

80106cf7 <vector232>:
.globl vector232
vector232:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $232
80106cf9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106cfe:	e9 47 f1 ff ff       	jmp    80105e4a <alltraps>

80106d03 <vector233>:
.globl vector233
vector233:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $233
80106d05:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106d0a:	e9 3b f1 ff ff       	jmp    80105e4a <alltraps>

80106d0f <vector234>:
.globl vector234
vector234:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $234
80106d11:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106d16:	e9 2f f1 ff ff       	jmp    80105e4a <alltraps>

80106d1b <vector235>:
.globl vector235
vector235:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $235
80106d1d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106d22:	e9 23 f1 ff ff       	jmp    80105e4a <alltraps>

80106d27 <vector236>:
.globl vector236
vector236:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $236
80106d29:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106d2e:	e9 17 f1 ff ff       	jmp    80105e4a <alltraps>

80106d33 <vector237>:
.globl vector237
vector237:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $237
80106d35:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106d3a:	e9 0b f1 ff ff       	jmp    80105e4a <alltraps>

80106d3f <vector238>:
.globl vector238
vector238:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $238
80106d41:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106d46:	e9 ff f0 ff ff       	jmp    80105e4a <alltraps>

80106d4b <vector239>:
.globl vector239
vector239:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $239
80106d4d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106d52:	e9 f3 f0 ff ff       	jmp    80105e4a <alltraps>

80106d57 <vector240>:
.globl vector240
vector240:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $240
80106d59:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106d5e:	e9 e7 f0 ff ff       	jmp    80105e4a <alltraps>

80106d63 <vector241>:
.globl vector241
vector241:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $241
80106d65:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106d6a:	e9 db f0 ff ff       	jmp    80105e4a <alltraps>

80106d6f <vector242>:
.globl vector242
vector242:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $242
80106d71:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106d76:	e9 cf f0 ff ff       	jmp    80105e4a <alltraps>

80106d7b <vector243>:
.globl vector243
vector243:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $243
80106d7d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106d82:	e9 c3 f0 ff ff       	jmp    80105e4a <alltraps>

80106d87 <vector244>:
.globl vector244
vector244:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $244
80106d89:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106d8e:	e9 b7 f0 ff ff       	jmp    80105e4a <alltraps>

80106d93 <vector245>:
.globl vector245
vector245:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $245
80106d95:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106d9a:	e9 ab f0 ff ff       	jmp    80105e4a <alltraps>

80106d9f <vector246>:
.globl vector246
vector246:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $246
80106da1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106da6:	e9 9f f0 ff ff       	jmp    80105e4a <alltraps>

80106dab <vector247>:
.globl vector247
vector247:
  pushl $0
80106dab:	6a 00                	push   $0x0
  pushl $247
80106dad:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106db2:	e9 93 f0 ff ff       	jmp    80105e4a <alltraps>

80106db7 <vector248>:
.globl vector248
vector248:
  pushl $0
80106db7:	6a 00                	push   $0x0
  pushl $248
80106db9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106dbe:	e9 87 f0 ff ff       	jmp    80105e4a <alltraps>

80106dc3 <vector249>:
.globl vector249
vector249:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $249
80106dc5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106dca:	e9 7b f0 ff ff       	jmp    80105e4a <alltraps>

80106dcf <vector250>:
.globl vector250
vector250:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $250
80106dd1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106dd6:	e9 6f f0 ff ff       	jmp    80105e4a <alltraps>

80106ddb <vector251>:
.globl vector251
vector251:
  pushl $0
80106ddb:	6a 00                	push   $0x0
  pushl $251
80106ddd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106de2:	e9 63 f0 ff ff       	jmp    80105e4a <alltraps>

80106de7 <vector252>:
.globl vector252
vector252:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $252
80106de9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106dee:	e9 57 f0 ff ff       	jmp    80105e4a <alltraps>

80106df3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106df3:	6a 00                	push   $0x0
  pushl $253
80106df5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106dfa:	e9 4b f0 ff ff       	jmp    80105e4a <alltraps>

80106dff <vector254>:
.globl vector254
vector254:
  pushl $0
80106dff:	6a 00                	push   $0x0
  pushl $254
80106e01:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106e06:	e9 3f f0 ff ff       	jmp    80105e4a <alltraps>

80106e0b <vector255>:
.globl vector255
vector255:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $255
80106e0d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106e12:	e9 33 f0 ff ff       	jmp    80105e4a <alltraps>
80106e17:	66 90                	xchg   %ax,%ax
80106e19:	66 90                	xchg   %ax,%ax
80106e1b:	66 90                	xchg   %ax,%ax
80106e1d:	66 90                	xchg   %ax,%ax
80106e1f:	90                   	nop

80106e20 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106e20:	55                   	push   %ebp
80106e21:	89 e5                	mov    %esp,%ebp
80106e23:	57                   	push   %edi
80106e24:	56                   	push   %esi
80106e25:	53                   	push   %ebx
80106e26:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106e28:	c1 ea 16             	shr    $0x16,%edx
80106e2b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106e2e:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80106e31:	8b 07                	mov    (%edi),%eax
80106e33:	a8 01                	test   $0x1,%al
80106e35:	74 29                	je     80106e60 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106e37:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106e3c:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106e42:	8d 65 f4             	lea    -0xc(%ebp),%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106e45:	c1 eb 0a             	shr    $0xa,%ebx
80106e48:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
80106e4e:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
80106e51:	5b                   	pop    %ebx
80106e52:	5e                   	pop    %esi
80106e53:	5f                   	pop    %edi
80106e54:	5d                   	pop    %ebp
80106e55:	c3                   	ret    
80106e56:	8d 76 00             	lea    0x0(%esi),%esi
80106e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106e60:	85 c9                	test   %ecx,%ecx
80106e62:	74 2c                	je     80106e90 <walkpgdir+0x70>
80106e64:	e8 87 ba ff ff       	call   801028f0 <kalloc>
80106e69:	85 c0                	test   %eax,%eax
80106e6b:	89 c6                	mov    %eax,%esi
80106e6d:	74 21                	je     80106e90 <walkpgdir+0x70>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80106e6f:	83 ec 04             	sub    $0x4,%esp
80106e72:	68 00 10 00 00       	push   $0x1000
80106e77:	6a 00                	push   $0x0
80106e79:	50                   	push   %eax
80106e7a:	e8 61 dd ff ff       	call   80104be0 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106e7f:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106e85:	83 c4 10             	add    $0x10,%esp
80106e88:	83 c8 07             	or     $0x7,%eax
80106e8b:	89 07                	mov    %eax,(%edi)
80106e8d:	eb b3                	jmp    80106e42 <walkpgdir+0x22>
80106e8f:	90                   	nop
  }
  return &pgtab[PTX(va)];
}
80106e90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
80106e93:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106e95:	5b                   	pop    %ebx
80106e96:	5e                   	pop    %esi
80106e97:	5f                   	pop    %edi
80106e98:	5d                   	pop    %ebp
80106e99:	c3                   	ret    
80106e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ea0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106ea0:	55                   	push   %ebp
80106ea1:	89 e5                	mov    %esp,%ebp
80106ea3:	57                   	push   %edi
80106ea4:	56                   	push   %esi
80106ea5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106ea6:	89 d3                	mov    %edx,%ebx
80106ea8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106eae:	83 ec 1c             	sub    $0x1c,%esp
80106eb1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106eb4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106eb8:	8b 7d 08             	mov    0x8(%ebp),%edi
80106ebb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106ec0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106ec3:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ec6:	29 df                	sub    %ebx,%edi
80106ec8:	83 c8 01             	or     $0x1,%eax
80106ecb:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106ece:	eb 15                	jmp    80106ee5 <mappages+0x45>
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106ed0:	f6 00 01             	testb  $0x1,(%eax)
80106ed3:	75 45                	jne    80106f1a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106ed5:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106ed8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106edb:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106edd:	74 31                	je     80106f10 <mappages+0x70>
      break;
    a += PGSIZE;
80106edf:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106ee5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ee8:	b9 01 00 00 00       	mov    $0x1,%ecx
80106eed:	89 da                	mov    %ebx,%edx
80106eef:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106ef2:	e8 29 ff ff ff       	call   80106e20 <walkpgdir>
80106ef7:	85 c0                	test   %eax,%eax
80106ef9:	75 d5                	jne    80106ed0 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106efb:	8d 65 f4             	lea    -0xc(%ebp),%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
80106efe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106f03:	5b                   	pop    %ebx
80106f04:	5e                   	pop    %esi
80106f05:	5f                   	pop    %edi
80106f06:	5d                   	pop    %ebp
80106f07:	c3                   	ret    
80106f08:	90                   	nop
80106f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f10:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80106f13:	31 c0                	xor    %eax,%eax
}
80106f15:	5b                   	pop    %ebx
80106f16:	5e                   	pop    %esi
80106f17:	5f                   	pop    %edi
80106f18:	5d                   	pop    %ebp
80106f19:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
80106f1a:	83 ec 0c             	sub    $0xc,%esp
80106f1d:	68 70 86 10 80       	push   $0x80108670
80106f22:	e8 49 94 ff ff       	call   80100370 <panic>
80106f27:	89 f6                	mov    %esi,%esi
80106f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f30 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106f30:	55                   	push   %ebp
80106f31:	89 e5                	mov    %esp,%ebp
80106f33:	57                   	push   %edi
80106f34:	56                   	push   %esi
80106f35:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106f36:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106f3c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106f42:	83 ec 1c             	sub    $0x1c,%esp
80106f45:	89 45 e4             	mov    %eax,-0x1c(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106f48:	39 d3                	cmp    %edx,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106f4a:	89 55 e0             	mov    %edx,-0x20(%ebp)
80106f4d:	89 4d dc             	mov    %ecx,-0x24(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106f50:	73 7c                	jae    80106fce <deallocuvm.part.0+0x9e>
80106f52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
80106f58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f5b:	31 c9                	xor    %ecx,%ecx
80106f5d:	89 da                	mov    %ebx,%edx
80106f5f:	e8 bc fe ff ff       	call   80106e20 <walkpgdir>
    if(!pte)
80106f64:	85 c0                	test   %eax,%eax
  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
    pte = walkpgdir(pgdir, (char*)a, 0);
80106f66:	89 c7                	mov    %eax,%edi
    if(!pte)
80106f68:	0f 84 82 00 00 00    	je     80106ff0 <deallocuvm.part.0+0xc0>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106f6e:	8b 30                	mov    (%eax),%esi
80106f70:	f7 c6 01 00 00 00    	test   $0x1,%esi
80106f76:	74 4b                	je     80106fc3 <deallocuvm.part.0+0x93>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106f78:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80106f7e:	74 7e                	je     80106ffe <deallocuvm.part.0+0xce>
        panic("kfree");

      #ifndef NONE
        //if((strcmp(myproc()->name, "init") && strcmp(myproc()->name, "sh"))){
          updateMemPagesOnRemove((void*) a, myproc());
80106f80:	e8 db cc ff ff       	call   80103c60 <myproc>
80106f85:	8d 88 1c 01 00 00    	lea    0x11c(%eax),%ecx
/// update the memory pages data of process according to the specified algorithm
/// on page removal
void updateMemPagesOnRemove(void* va, struct proc *p){
  #ifdef NFUA
  int i;
  for(i = 0; i < MAX_PSYC_PAGES; i++){
80106f8b:	31 d2                	xor    %edx,%edx
80106f8d:	8d 76 00             	lea    0x0(%esi),%esi
    if(/*p->mem_pages[i].in_mem == 1 && */p->mem_pages[i].va == va){
80106f90:	3b 19                	cmp    (%ecx),%ebx
80106f92:	74 4c                	je     80106fe0 <deallocuvm.part.0+0xb0>
/// update the memory pages data of process according to the specified algorithm
/// on page removal
void updateMemPagesOnRemove(void* va, struct proc *p){
  #ifdef NFUA
  int i;
  for(i = 0; i < MAX_PSYC_PAGES; i++){
80106f94:	83 c2 01             	add    $0x1,%edx
80106f97:	83 c1 14             	add    $0x14,%ecx
80106f9a:	83 fa 10             	cmp    $0x10,%edx
80106f9d:	75 f1                	jne    80106f90 <deallocuvm.part.0+0x60>
        panic("kfree");

      #ifndef NONE
        //if((strcmp(myproc()->name, "init") && strcmp(myproc()->name, "sh"))){
          updateMemPagesOnRemove((void*) a, myproc());
          myproc()->num_of_pages_in_memory--;
80106f9f:	e8 bc cc ff ff       	call   80103c60 <myproc>
80106fa4:	83 a8 80 00 00 00 01 	subl   $0x1,0x80(%eax)
        //}
      #endif

      char *v = P2V(pa);
      kfree(v);
80106fab:	83 ec 0c             	sub    $0xc,%esp
80106fae:	81 c6 00 00 00 80    	add    $0x80000000,%esi
80106fb4:	56                   	push   %esi
80106fb5:	e8 46 b7 ff ff       	call   80102700 <kfree>
      *pte = 0;
80106fba:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80106fc0:	83 c4 10             	add    $0x10,%esp

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106fc3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106fc9:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
80106fcc:	72 8a                	jb     80106f58 <deallocuvm.part.0+0x28>
      *pte = 0;
    }
  }

  return newsz;
}
80106fce:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106fd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fd4:	5b                   	pop    %ebx
80106fd5:	5e                   	pop    %esi
80106fd6:	5f                   	pop    %edi
80106fd7:	5d                   	pop    %ebp
80106fd8:	c3                   	ret    
80106fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(i == MAX_PSYC_PAGES){
    return;
    panic(" on remove");
  }

  p->mem_pages[i].in_mem = 0;
80106fe0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80106fe3:	c6 84 90 20 01 00 00 	movb   $0x0,0x120(%eax,%edx,4)
80106fea:	00 
80106feb:	eb b2                	jmp    80106f9f <deallocuvm.part.0+0x6f>
80106fed:	8d 76 00             	lea    0x0(%esi),%esi

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106ff0:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106ff6:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
80106ffc:	eb c5                	jmp    80106fc3 <deallocuvm.part.0+0x93>
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
80106ffe:	83 ec 0c             	sub    $0xc,%esp
80107001:	68 2a 7f 10 80       	push   $0x80107f2a
80107006:	e8 65 93 ff ff       	call   80100370 <panic>
8010700b:	90                   	nop
8010700c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107010 <updateMemPages>:
extern char data[];  // defined by kernel.ld
pde_t *kpgdir;  // for use in scheduler()

/// update the memory pages data of process according to the specified algorithm
/// on page addition
void updateMemPages(void* va, struct proc *p){
80107010:	55                   	push   %ebp
  #ifdef NFUA
  int i;
  for(i = 0; i < MAX_PSYC_PAGES; i++){
80107011:	31 c0                	xor    %eax,%eax
extern char data[];  // defined by kernel.ld
pde_t *kpgdir;  // for use in scheduler()

/// update the memory pages data of process according to the specified algorithm
/// on page addition
void updateMemPages(void* va, struct proc *p){
80107013:	89 e5                	mov    %esp,%ebp
80107015:	83 ec 08             	sub    $0x8,%esp
80107018:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010701b:	8d 91 20 01 00 00    	lea    0x120(%ecx),%edx
80107021:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  #ifdef NFUA
  int i;
  for(i = 0; i < MAX_PSYC_PAGES; i++){
    if(p->mem_pages[i].in_mem == 0){
80107028:	80 3a 00             	cmpb   $0x0,(%edx)
8010702b:	74 1b                	je     80107048 <updateMemPages+0x38>
/// update the memory pages data of process according to the specified algorithm
/// on page addition
void updateMemPages(void* va, struct proc *p){
  #ifdef NFUA
  int i;
  for(i = 0; i < MAX_PSYC_PAGES; i++){
8010702d:	83 c0 01             	add    $0x1,%eax
80107030:	83 c2 14             	add    $0x14,%edx
80107033:	83 f8 10             	cmp    $0x10,%eax
80107036:	75 f0                	jne    80107028 <updateMemPages+0x18>
      break;
    }
  }

  if(i == MAX_PSYC_PAGES){
    panic("mem_pages is full but shouldn't");
80107038:	83 ec 0c             	sub    $0xc,%esp
8010703b:	68 c8 87 10 80       	push   $0x801087c8
80107040:	e8 2b 93 ff ff       	call   80100370 <panic>
80107045:	8d 76 00             	lea    0x0(%esi),%esi
  }

  p->mem_pages[i].in_mem = 1;
80107048:	8d 04 80             	lea    (%eax,%eax,4),%eax
  p->mem_pages[i].aging = 0;
  p->mem_pages[i].va = va;
8010704b:	8b 55 08             	mov    0x8(%ebp),%edx

  if(i == MAX_PSYC_PAGES){
    panic("mem_pages is full but shouldn't");
  }

  p->mem_pages[i].in_mem = 1;
8010704e:	8d 04 81             	lea    (%ecx,%eax,4),%eax
80107051:	c6 80 20 01 00 00 01 	movb   $0x1,0x120(%eax)
  p->mem_pages[i].aging = 0;
80107058:	c7 80 18 01 00 00 00 	movl   $0x0,0x118(%eax)
8010705f:	00 00 00 
  p->mem_pages[i].va = va;
80107062:	89 90 1c 01 00 00    	mov    %edx,0x11c(%eax)
  
  #endif
}
80107068:	c9                   	leave  
80107069:	c3                   	ret    
8010706a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107070 <updateMemPagesOnRemove>:

/// update the memory pages data of process according to the specified algorithm
/// on page removal
void updateMemPagesOnRemove(void* va, struct proc *p){
80107070:	55                   	push   %ebp
  #ifdef NFUA
  int i;
  for(i = 0; i < MAX_PSYC_PAGES; i++){
80107071:	31 c0                	xor    %eax,%eax
  #endif
}

/// update the memory pages data of process according to the specified algorithm
/// on page removal
void updateMemPagesOnRemove(void* va, struct proc *p){
80107073:	89 e5                	mov    %esp,%ebp
80107075:	53                   	push   %ebx
80107076:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80107079:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010707c:	8d 93 1c 01 00 00    	lea    0x11c(%ebx),%edx
80107082:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  #ifdef NFUA
  int i;
  for(i = 0; i < MAX_PSYC_PAGES; i++){
    if(/*p->mem_pages[i].in_mem == 1 && */p->mem_pages[i].va == va){
80107088:	39 0a                	cmp    %ecx,(%edx)
8010708a:	74 14                	je     801070a0 <updateMemPagesOnRemove+0x30>
/// update the memory pages data of process according to the specified algorithm
/// on page removal
void updateMemPagesOnRemove(void* va, struct proc *p){
  #ifdef NFUA
  int i;
  for(i = 0; i < MAX_PSYC_PAGES; i++){
8010708c:	83 c0 01             	add    $0x1,%eax
8010708f:	83 c2 14             	add    $0x14,%edx
80107092:	83 f8 10             	cmp    $0x10,%eax
80107095:	75 f1                	jne    80107088 <updateMemPagesOnRemove+0x18>
    panic(" on remove");
  }

  p->mem_pages[i].in_mem = 0;
  #endif
}
80107097:	5b                   	pop    %ebx
80107098:	5d                   	pop    %ebp
80107099:	c3                   	ret    
8010709a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(i == MAX_PSYC_PAGES){
    return;
    panic(" on remove");
  }

  p->mem_pages[i].in_mem = 0;
801070a0:	8d 04 80             	lea    (%eax,%eax,4),%eax
801070a3:	c6 84 83 20 01 00 00 	movb   $0x0,0x120(%ebx,%eax,4)
801070aa:	00 
  #endif
}
801070ab:	5b                   	pop    %ebx
801070ac:	5d                   	pop    %ebp
801070ad:	c3                   	ret    
801070ae:	66 90                	xchg   %ax,%ax

801070b0 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801070b0:	55                   	push   %ebp
801070b1:	89 e5                	mov    %esp,%ebp
801070b3:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
801070b6:	e8 85 cb ff ff       	call   80103c40 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801070bb:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801070c1:	31 c9                	xor    %ecx,%ecx
801070c3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
801070c8:	66 89 90 18 38 11 80 	mov    %dx,-0x7feec7e8(%eax)
801070cf:	66 89 88 1a 38 11 80 	mov    %cx,-0x7feec7e6(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801070d6:	ba ff ff ff ff       	mov    $0xffffffff,%edx
801070db:	31 c9                	xor    %ecx,%ecx
801070dd:	66 89 90 20 38 11 80 	mov    %dx,-0x7feec7e0(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801070e4:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801070e9:	66 89 88 22 38 11 80 	mov    %cx,-0x7feec7de(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801070f0:	31 c9                	xor    %ecx,%ecx
801070f2:	66 89 90 28 38 11 80 	mov    %dx,-0x7feec7d8(%eax)
801070f9:	66 89 88 2a 38 11 80 	mov    %cx,-0x7feec7d6(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107100:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80107105:	31 c9                	xor    %ecx,%ecx
80107107:	66 89 90 30 38 11 80 	mov    %dx,-0x7feec7d0(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010710e:	c6 80 1c 38 11 80 00 	movb   $0x0,-0x7feec7e4(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80107115:	ba 2f 00 00 00       	mov    $0x2f,%edx
8010711a:	c6 80 1d 38 11 80 9a 	movb   $0x9a,-0x7feec7e3(%eax)
80107121:	c6 80 1e 38 11 80 cf 	movb   $0xcf,-0x7feec7e2(%eax)
80107128:	c6 80 1f 38 11 80 00 	movb   $0x0,-0x7feec7e1(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010712f:	c6 80 24 38 11 80 00 	movb   $0x0,-0x7feec7dc(%eax)
80107136:	c6 80 25 38 11 80 92 	movb   $0x92,-0x7feec7db(%eax)
8010713d:	c6 80 26 38 11 80 cf 	movb   $0xcf,-0x7feec7da(%eax)
80107144:	c6 80 27 38 11 80 00 	movb   $0x0,-0x7feec7d9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010714b:	c6 80 2c 38 11 80 00 	movb   $0x0,-0x7feec7d4(%eax)
80107152:	c6 80 2d 38 11 80 fa 	movb   $0xfa,-0x7feec7d3(%eax)
80107159:	c6 80 2e 38 11 80 cf 	movb   $0xcf,-0x7feec7d2(%eax)
80107160:	c6 80 2f 38 11 80 00 	movb   $0x0,-0x7feec7d1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107167:	66 89 88 32 38 11 80 	mov    %cx,-0x7feec7ce(%eax)
8010716e:	c6 80 34 38 11 80 00 	movb   $0x0,-0x7feec7cc(%eax)
80107175:	c6 80 35 38 11 80 f2 	movb   $0xf2,-0x7feec7cb(%eax)
8010717c:	c6 80 36 38 11 80 cf 	movb   $0xcf,-0x7feec7ca(%eax)
80107183:	c6 80 37 38 11 80 00 	movb   $0x0,-0x7feec7c9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
8010718a:	05 10 38 11 80       	add    $0x80113810,%eax
8010718f:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
80107193:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107197:	c1 e8 10             	shr    $0x10,%eax
8010719a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
8010719e:	8d 45 f2             	lea    -0xe(%ebp),%eax
801071a1:	0f 01 10             	lgdtl  (%eax)
}
801071a4:	c9                   	leave  
801071a5:	c3                   	ret    
801071a6:	8d 76 00             	lea    0x0(%esi),%esi
801071a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801071b0 <walkpgdir_noalloc>:
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}

pte_t* walkpgdir_noalloc(pde_t *pgdir, const void *va){
801071b0:	55                   	push   %ebp
801071b1:	89 e5                	mov    %esp,%ebp
801071b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
801071b6:	8b 55 08             	mov    0x8(%ebp),%edx
801071b9:	89 c1                	mov    %eax,%ecx
801071bb:	c1 e9 16             	shr    $0x16,%ecx
801071be:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801071c1:	f6 c2 01             	test   $0x1,%dl
801071c4:	74 1a                	je     801071e0 <walkpgdir_noalloc+0x30>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
    return &pgtab[PTX(va)];
801071c6:	c1 e8 0a             	shr    $0xa,%eax
801071c9:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801071cf:	25 fc 0f 00 00       	and    $0xffc,%eax
801071d4:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  }

  return 0;
}
801071db:	5d                   	pop    %ebp
801071dc:	c3                   	ret    
801071dd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
    return &pgtab[PTX(va)];
  }

  return 0;
801071e0:	31 c0                	xor    %eax,%eax
}
801071e2:	5d                   	pop    %ebp
801071e3:	c3                   	ret    
801071e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801071ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801071f0 <switchkvm>:
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801071f0:	a1 c4 da 11 80       	mov    0x8011dac4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801071f5:	55                   	push   %ebp
801071f6:	89 e5                	mov    %esp,%ebp
801071f8:	05 00 00 00 80       	add    $0x80000000,%eax
801071fd:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
80107200:	5d                   	pop    %ebp
80107201:	c3                   	ret    
80107202:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107210 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107210:	55                   	push   %ebp
80107211:	89 e5                	mov    %esp,%ebp
80107213:	57                   	push   %edi
80107214:	56                   	push   %esi
80107215:	53                   	push   %ebx
80107216:	83 ec 1c             	sub    $0x1c,%esp
80107219:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010721c:	85 f6                	test   %esi,%esi
8010721e:	0f 84 cd 00 00 00    	je     801072f1 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80107224:	8b 46 08             	mov    0x8(%esi),%eax
80107227:	85 c0                	test   %eax,%eax
80107229:	0f 84 dc 00 00 00    	je     8010730b <switchuvm+0xfb>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
8010722f:	8b 7e 04             	mov    0x4(%esi),%edi
80107232:	85 ff                	test   %edi,%edi
80107234:	0f 84 c4 00 00 00    	je     801072fe <switchuvm+0xee>
    panic("switchuvm: no pgdir");

  pushcli();
8010723a:	e8 d1 d7 ff ff       	call   80104a10 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010723f:	e8 7c c9 ff ff       	call   80103bc0 <mycpu>
80107244:	89 c3                	mov    %eax,%ebx
80107246:	e8 75 c9 ff ff       	call   80103bc0 <mycpu>
8010724b:	89 c7                	mov    %eax,%edi
8010724d:	e8 6e c9 ff ff       	call   80103bc0 <mycpu>
80107252:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107255:	83 c7 08             	add    $0x8,%edi
80107258:	e8 63 c9 ff ff       	call   80103bc0 <mycpu>
8010725d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107260:	83 c0 08             	add    $0x8,%eax
80107263:	ba 67 00 00 00       	mov    $0x67,%edx
80107268:	c1 e8 18             	shr    $0x18,%eax
8010726b:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80107272:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107279:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80107280:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80107287:	83 c1 08             	add    $0x8,%ecx
8010728a:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80107290:	c1 e9 10             	shr    $0x10,%ecx
80107293:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107299:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
8010729e:	e8 1d c9 ff ff       	call   80103bc0 <mycpu>
801072a3:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801072aa:	e8 11 c9 ff ff       	call   80103bc0 <mycpu>
801072af:	b9 10 00 00 00       	mov    $0x10,%ecx
801072b4:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801072b8:	e8 03 c9 ff ff       	call   80103bc0 <mycpu>
801072bd:	8b 56 08             	mov    0x8(%esi),%edx
801072c0:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
801072c6:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801072c9:	e8 f2 c8 ff ff       	call   80103bc0 <mycpu>
801072ce:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
801072d2:	b8 28 00 00 00       	mov    $0x28,%eax
801072d7:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801072da:	8b 46 04             	mov    0x4(%esi),%eax
801072dd:	05 00 00 00 80       	add    $0x80000000,%eax
801072e2:	0f 22 d8             	mov    %eax,%cr3
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
801072e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072e8:	5b                   	pop    %ebx
801072e9:	5e                   	pop    %esi
801072ea:	5f                   	pop    %edi
801072eb:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
801072ec:	e9 2f d8 ff ff       	jmp    80104b20 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
801072f1:	83 ec 0c             	sub    $0xc,%esp
801072f4:	68 76 86 10 80       	push   $0x80108676
801072f9:	e8 72 90 ff ff       	call   80100370 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
801072fe:	83 ec 0c             	sub    $0xc,%esp
80107301:	68 a1 86 10 80       	push   $0x801086a1
80107306:	e8 65 90 ff ff       	call   80100370 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
8010730b:	83 ec 0c             	sub    $0xc,%esp
8010730e:	68 8c 86 10 80       	push   $0x8010868c
80107313:	e8 58 90 ff ff       	call   80100370 <panic>
80107318:	90                   	nop
80107319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107320 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107320:	55                   	push   %ebp
80107321:	89 e5                	mov    %esp,%ebp
80107323:	57                   	push   %edi
80107324:	56                   	push   %esi
80107325:	53                   	push   %ebx
80107326:	83 ec 1c             	sub    $0x1c,%esp
80107329:	8b 75 10             	mov    0x10(%ebp),%esi
8010732c:	8b 45 08             	mov    0x8(%ebp),%eax
8010732f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80107332:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107338:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
8010733b:	77 49                	ja     80107386 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
8010733d:	e8 ae b5 ff ff       	call   801028f0 <kalloc>
  memset(mem, 0, PGSIZE);
80107342:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80107345:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107347:	68 00 10 00 00       	push   $0x1000
8010734c:	6a 00                	push   $0x0
8010734e:	50                   	push   %eax
8010734f:	e8 8c d8 ff ff       	call   80104be0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107354:	58                   	pop    %eax
80107355:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010735b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107360:	5a                   	pop    %edx
80107361:	6a 06                	push   $0x6
80107363:	50                   	push   %eax
80107364:	31 d2                	xor    %edx,%edx
80107366:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107369:	e8 32 fb ff ff       	call   80106ea0 <mappages>
  memmove(mem, init, sz);
8010736e:	89 75 10             	mov    %esi,0x10(%ebp)
80107371:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107374:	83 c4 10             	add    $0x10,%esp
80107377:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010737a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010737d:	5b                   	pop    %ebx
8010737e:	5e                   	pop    %esi
8010737f:	5f                   	pop    %edi
80107380:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80107381:	e9 0a d9 ff ff       	jmp    80104c90 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80107386:	83 ec 0c             	sub    $0xc,%esp
80107389:	68 b5 86 10 80       	push   $0x801086b5
8010738e:	e8 dd 8f ff ff       	call   80100370 <panic>
80107393:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801073a0 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801073a0:	55                   	push   %ebp
801073a1:	89 e5                	mov    %esp,%ebp
801073a3:	57                   	push   %edi
801073a4:	56                   	push   %esi
801073a5:	53                   	push   %ebx
801073a6:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801073a9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801073b0:	0f 85 91 00 00 00    	jne    80107447 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801073b6:	8b 75 18             	mov    0x18(%ebp),%esi
801073b9:	31 db                	xor    %ebx,%ebx
801073bb:	85 f6                	test   %esi,%esi
801073bd:	75 1a                	jne    801073d9 <loaduvm+0x39>
801073bf:	eb 6f                	jmp    80107430 <loaduvm+0x90>
801073c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073c8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801073ce:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801073d4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801073d7:	76 57                	jbe    80107430 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801073d9:	8b 55 0c             	mov    0xc(%ebp),%edx
801073dc:	8b 45 08             	mov    0x8(%ebp),%eax
801073df:	31 c9                	xor    %ecx,%ecx
801073e1:	01 da                	add    %ebx,%edx
801073e3:	e8 38 fa ff ff       	call   80106e20 <walkpgdir>
801073e8:	85 c0                	test   %eax,%eax
801073ea:	74 4e                	je     8010743a <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
801073ec:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
801073ee:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
801073f1:	bf 00 10 00 00       	mov    $0x1000,%edi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
801073f6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801073fb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107401:	0f 46 fe             	cmovbe %esi,%edi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107404:	01 d9                	add    %ebx,%ecx
80107406:	05 00 00 00 80       	add    $0x80000000,%eax
8010740b:	57                   	push   %edi
8010740c:	51                   	push   %ecx
8010740d:	50                   	push   %eax
8010740e:	ff 75 10             	pushl  0x10(%ebp)
80107411:	e8 ba a5 ff ff       	call   801019d0 <readi>
80107416:	83 c4 10             	add    $0x10,%esp
80107419:	39 c7                	cmp    %eax,%edi
8010741b:	74 ab                	je     801073c8 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
8010741d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80107420:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80107425:	5b                   	pop    %ebx
80107426:	5e                   	pop    %esi
80107427:	5f                   	pop    %edi
80107428:	5d                   	pop    %ebp
80107429:	c3                   	ret    
8010742a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107430:	8d 65 f4             	lea    -0xc(%ebp),%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80107433:	31 c0                	xor    %eax,%eax
}
80107435:	5b                   	pop    %ebx
80107436:	5e                   	pop    %esi
80107437:	5f                   	pop    %edi
80107438:	5d                   	pop    %ebp
80107439:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
8010743a:	83 ec 0c             	sub    $0xc,%esp
8010743d:	68 cf 86 10 80       	push   $0x801086cf
80107442:	e8 29 8f ff ff       	call   80100370 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80107447:	83 ec 0c             	sub    $0xc,%esp
8010744a:	68 e8 87 10 80       	push   $0x801087e8
8010744f:	e8 1c 8f ff ff       	call   80100370 <panic>
80107454:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010745a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107460 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107460:	55                   	push   %ebp
80107461:	89 e5                	mov    %esp,%ebp
80107463:	8b 55 0c             	mov    0xc(%ebp),%edx
80107466:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107469:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010746c:	39 d1                	cmp    %edx,%ecx
8010746e:	73 10                	jae    80107480 <deallocuvm+0x20>
      *pte = 0;
    }
  }

  return newsz;
}
80107470:	5d                   	pop    %ebp
80107471:	e9 ba fa ff ff       	jmp    80106f30 <deallocuvm.part.0>
80107476:	8d 76 00             	lea    0x0(%esi),%esi
80107479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107480:	89 d0                	mov    %edx,%eax
80107482:	5d                   	pop    %ebp
80107483:	c3                   	ret    
80107484:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010748a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107490 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107490:	55                   	push   %ebp
80107491:	89 e5                	mov    %esp,%ebp
80107493:	57                   	push   %edi
80107494:	56                   	push   %esi
80107495:	53                   	push   %ebx
80107496:	83 ec 0c             	sub    $0xc,%esp
80107499:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010749c:	85 f6                	test   %esi,%esi
8010749e:	74 59                	je     801074f9 <freevm+0x69>
801074a0:	31 c9                	xor    %ecx,%ecx
801074a2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801074a7:	89 f0                	mov    %esi,%eax
801074a9:	e8 82 fa ff ff       	call   80106f30 <deallocuvm.part.0>
801074ae:	89 f3                	mov    %esi,%ebx
801074b0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801074b6:	eb 0f                	jmp    801074c7 <freevm+0x37>
801074b8:	90                   	nop
801074b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074c0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801074c3:	39 fb                	cmp    %edi,%ebx
801074c5:	74 23                	je     801074ea <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801074c7:	8b 03                	mov    (%ebx),%eax
801074c9:	a8 01                	test   $0x1,%al
801074cb:	74 f3                	je     801074c0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
801074cd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801074d2:	83 ec 0c             	sub    $0xc,%esp
801074d5:	83 c3 04             	add    $0x4,%ebx
801074d8:	05 00 00 00 80       	add    $0x80000000,%eax
801074dd:	50                   	push   %eax
801074de:	e8 1d b2 ff ff       	call   80102700 <kfree>
801074e3:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801074e6:	39 fb                	cmp    %edi,%ebx
801074e8:	75 dd                	jne    801074c7 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801074ea:	89 75 08             	mov    %esi,0x8(%ebp)
}
801074ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074f0:	5b                   	pop    %ebx
801074f1:	5e                   	pop    %esi
801074f2:	5f                   	pop    %edi
801074f3:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
801074f4:	e9 07 b2 ff ff       	jmp    80102700 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
801074f9:	83 ec 0c             	sub    $0xc,%esp
801074fc:	68 ed 86 10 80       	push   $0x801086ed
80107501:	e8 6a 8e ff ff       	call   80100370 <panic>
80107506:	8d 76 00             	lea    0x0(%esi),%esi
80107509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107510 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107510:	55                   	push   %ebp
80107511:	89 e5                	mov    %esp,%ebp
80107513:	56                   	push   %esi
80107514:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107515:	e8 d6 b3 ff ff       	call   801028f0 <kalloc>
8010751a:	85 c0                	test   %eax,%eax
8010751c:	74 6a                	je     80107588 <setupkvm+0x78>
    return 0;
  memset(pgdir, 0, PGSIZE);
8010751e:	83 ec 04             	sub    $0x4,%esp
80107521:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107523:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80107528:	68 00 10 00 00       	push   $0x1000
8010752d:	6a 00                	push   $0x0
8010752f:	50                   	push   %eax
80107530:	e8 ab d6 ff ff       	call   80104be0 <memset>
80107535:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107538:	8b 43 04             	mov    0x4(%ebx),%eax
8010753b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010753e:	83 ec 08             	sub    $0x8,%esp
80107541:	8b 13                	mov    (%ebx),%edx
80107543:	ff 73 0c             	pushl  0xc(%ebx)
80107546:	50                   	push   %eax
80107547:	29 c1                	sub    %eax,%ecx
80107549:	89 f0                	mov    %esi,%eax
8010754b:	e8 50 f9 ff ff       	call   80106ea0 <mappages>
80107550:	83 c4 10             	add    $0x10,%esp
80107553:	85 c0                	test   %eax,%eax
80107555:	78 19                	js     80107570 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107557:	83 c3 10             	add    $0x10,%ebx
8010755a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107560:	75 d6                	jne    80107538 <setupkvm+0x28>
80107562:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80107564:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107567:	5b                   	pop    %ebx
80107568:	5e                   	pop    %esi
80107569:	5d                   	pop    %ebp
8010756a:	c3                   	ret    
8010756b:	90                   	nop
8010756c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80107570:	83 ec 0c             	sub    $0xc,%esp
80107573:	56                   	push   %esi
80107574:	e8 17 ff ff ff       	call   80107490 <freevm>
      return 0;
80107579:	83 c4 10             	add    $0x10,%esp
    }
  return pgdir;
}
8010757c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
8010757f:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
80107581:	5b                   	pop    %ebx
80107582:	5e                   	pop    %esi
80107583:	5d                   	pop    %ebp
80107584:	c3                   	ret    
80107585:	8d 76 00             	lea    0x0(%esi),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80107588:	31 c0                	xor    %eax,%eax
8010758a:	eb d8                	jmp    80107564 <setupkvm+0x54>
8010758c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107590 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107590:	55                   	push   %ebp
80107591:	89 e5                	mov    %esp,%ebp
80107593:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107596:	e8 75 ff ff ff       	call   80107510 <setupkvm>
8010759b:	a3 c4 da 11 80       	mov    %eax,0x8011dac4
801075a0:	05 00 00 00 80       	add    $0x80000000,%eax
801075a5:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
801075a8:	c9                   	leave  
801075a9:	c3                   	ret    
801075aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801075b0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801075b0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801075b1:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801075b3:	89 e5                	mov    %esp,%ebp
801075b5:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801075b8:	8b 55 0c             	mov    0xc(%ebp),%edx
801075bb:	8b 45 08             	mov    0x8(%ebp),%eax
801075be:	e8 5d f8 ff ff       	call   80106e20 <walkpgdir>
  if(pte == 0)
801075c3:	85 c0                	test   %eax,%eax
801075c5:	74 05                	je     801075cc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
801075c7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801075ca:	c9                   	leave  
801075cb:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801075cc:	83 ec 0c             	sub    $0xc,%esp
801075cf:	68 fe 86 10 80       	push   $0x801086fe
801075d4:	e8 97 8d ff ff       	call   80100370 <panic>
801075d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801075e0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801075e0:	55                   	push   %ebp
801075e1:	89 e5                	mov    %esp,%ebp
801075e3:	57                   	push   %edi
801075e4:	56                   	push   %esi
801075e5:	53                   	push   %ebx
801075e6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801075e9:	e8 22 ff ff ff       	call   80107510 <setupkvm>
801075ee:	85 c0                	test   %eax,%eax
801075f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801075f3:	0f 84 b2 00 00 00    	je     801076ab <copyuvm+0xcb>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801075f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801075fc:	85 c9                	test   %ecx,%ecx
801075fe:	0f 84 9c 00 00 00    	je     801076a0 <copyuvm+0xc0>
80107604:	31 f6                	xor    %esi,%esi
80107606:	eb 4a                	jmp    80107652 <copyuvm+0x72>
80107608:	90                   	nop
80107609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107610:	83 ec 04             	sub    $0x4,%esp
80107613:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107619:	68 00 10 00 00       	push   $0x1000
8010761e:	57                   	push   %edi
8010761f:	50                   	push   %eax
80107620:	e8 6b d6 ff ff       	call   80104c90 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107625:	58                   	pop    %eax
80107626:	5a                   	pop    %edx
80107627:	8d 93 00 00 00 80    	lea    -0x80000000(%ebx),%edx
8010762d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107630:	ff 75 e4             	pushl  -0x1c(%ebp)
80107633:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107638:	52                   	push   %edx
80107639:	89 f2                	mov    %esi,%edx
8010763b:	e8 60 f8 ff ff       	call   80106ea0 <mappages>
80107640:	83 c4 10             	add    $0x10,%esp
80107643:	85 c0                	test   %eax,%eax
80107645:	78 3e                	js     80107685 <copyuvm+0xa5>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107647:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010764d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107650:	76 4e                	jbe    801076a0 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107652:	8b 45 08             	mov    0x8(%ebp),%eax
80107655:	31 c9                	xor    %ecx,%ecx
80107657:	89 f2                	mov    %esi,%edx
80107659:	e8 c2 f7 ff ff       	call   80106e20 <walkpgdir>
8010765e:	85 c0                	test   %eax,%eax
80107660:	74 5a                	je     801076bc <copyuvm+0xdc>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80107662:	8b 18                	mov    (%eax),%ebx
80107664:	f6 c3 01             	test   $0x1,%bl
80107667:	74 46                	je     801076af <copyuvm+0xcf>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107669:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
8010766b:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
80107671:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107674:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
8010767a:	e8 71 b2 ff ff       	call   801028f0 <kalloc>
8010767f:	85 c0                	test   %eax,%eax
80107681:	89 c3                	mov    %eax,%ebx
80107683:	75 8b                	jne    80107610 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80107685:	83 ec 0c             	sub    $0xc,%esp
80107688:	ff 75 e0             	pushl  -0x20(%ebp)
8010768b:	e8 00 fe ff ff       	call   80107490 <freevm>
  return 0;
80107690:	83 c4 10             	add    $0x10,%esp
80107693:	31 c0                	xor    %eax,%eax
}
80107695:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107698:	5b                   	pop    %ebx
80107699:	5e                   	pop    %esi
8010769a:	5f                   	pop    %edi
8010769b:	5d                   	pop    %ebp
8010769c:	c3                   	ret    
8010769d:	8d 76 00             	lea    0x0(%esi),%esi
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801076a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  return d;

bad:
  freevm(d);
  return 0;
}
801076a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076a6:	5b                   	pop    %ebx
801076a7:	5e                   	pop    %esi
801076a8:	5f                   	pop    %edi
801076a9:	5d                   	pop    %ebp
801076aa:	c3                   	ret    
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
801076ab:	31 c0                	xor    %eax,%eax
801076ad:	eb e6                	jmp    80107695 <copyuvm+0xb5>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
801076af:	83 ec 0c             	sub    $0xc,%esp
801076b2:	68 22 87 10 80       	push   $0x80108722
801076b7:	e8 b4 8c ff ff       	call   80100370 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801076bc:	83 ec 0c             	sub    $0xc,%esp
801076bf:	68 08 87 10 80       	push   $0x80108708
801076c4:	e8 a7 8c ff ff       	call   80100370 <panic>
801076c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801076d0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801076d0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801076d1:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801076d3:	89 e5                	mov    %esp,%ebp
801076d5:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801076d8:	8b 55 0c             	mov    0xc(%ebp),%edx
801076db:	8b 45 08             	mov    0x8(%ebp),%eax
801076de:	e8 3d f7 ff ff       	call   80106e20 <walkpgdir>
  if((*pte & PTE_P) == 0)
801076e3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
801076e5:	89 c2                	mov    %eax,%edx
801076e7:	83 e2 05             	and    $0x5,%edx
801076ea:	83 fa 05             	cmp    $0x5,%edx
801076ed:	75 11                	jne    80107700 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
801076ef:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
801076f4:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
801076f5:	05 00 00 00 80       	add    $0x80000000,%eax
}
801076fa:	c3                   	ret    
801076fb:	90                   	nop
801076fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80107700:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80107702:	c9                   	leave  
80107703:	c3                   	ret    
80107704:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010770a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107710 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107710:	55                   	push   %ebp
80107711:	89 e5                	mov    %esp,%ebp
80107713:	57                   	push   %edi
80107714:	56                   	push   %esi
80107715:	53                   	push   %ebx
80107716:	83 ec 1c             	sub    $0x1c,%esp
80107719:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010771c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010771f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107722:	85 db                	test   %ebx,%ebx
80107724:	75 40                	jne    80107766 <copyout+0x56>
80107726:	eb 70                	jmp    80107798 <copyout+0x88>
80107728:	90                   	nop
80107729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107730:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107733:	89 f1                	mov    %esi,%ecx
80107735:	29 d1                	sub    %edx,%ecx
80107737:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010773d:	39 d9                	cmp    %ebx,%ecx
8010773f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107742:	29 f2                	sub    %esi,%edx
80107744:	83 ec 04             	sub    $0x4,%esp
80107747:	01 d0                	add    %edx,%eax
80107749:	51                   	push   %ecx
8010774a:	57                   	push   %edi
8010774b:	50                   	push   %eax
8010774c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010774f:	e8 3c d5 ff ff       	call   80104c90 <memmove>
    len -= n;
    buf += n;
80107754:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107757:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
8010775a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80107760:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107762:	29 cb                	sub    %ecx,%ebx
80107764:	74 32                	je     80107798 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107766:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107768:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
8010776b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010776e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107774:	56                   	push   %esi
80107775:	ff 75 08             	pushl  0x8(%ebp)
80107778:	e8 53 ff ff ff       	call   801076d0 <uva2ka>
    if(pa0 == 0)
8010777d:	83 c4 10             	add    $0x10,%esp
80107780:	85 c0                	test   %eax,%eax
80107782:	75 ac                	jne    80107730 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80107784:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80107787:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
8010778c:	5b                   	pop    %ebx
8010778d:	5e                   	pop    %esi
8010778e:	5f                   	pop    %edi
8010778f:	5d                   	pop    %ebp
80107790:	c3                   	ret    
80107791:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107798:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
8010779b:	31 c0                	xor    %eax,%eax
}
8010779d:	5b                   	pop    %ebx
8010779e:	5e                   	pop    %esi
8010779f:	5f                   	pop    %edi
801077a0:	5d                   	pop    %ebp
801077a1:	c3                   	ret    
801077a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801077b0 <swapOut>:

/// function to take a page from physical memory and put it in the swap file in the disc
void swapOut(void* va, struct proc *p){
801077b0:	55                   	push   %ebp
801077b1:	89 e5                	mov    %esp,%ebp
801077b3:	57                   	push   %edi
801077b4:	56                   	push   %esi
801077b5:	53                   	push   %ebx
801077b6:	83 ec 28             	sub    $0x28,%esp
801077b9:	8b 75 0c             	mov    0xc(%ebp),%esi
801077bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  cprintf("un swapout\n");
801077bf:	68 3c 87 10 80       	push   $0x8010873c
801077c4:	e8 97 8e ff ff       	call   80100660 <cprintf>
  pte_t* pte = walkpgdir(p->pgdir, va, 0);
801077c9:	8b 46 04             	mov    0x4(%esi),%eax
801077cc:	31 c9                	xor    %ecx,%ecx
801077ce:	89 da                	mov    %ebx,%edx
  void* startOfVApage = (void*) PGROUNDDOWN((uint) va);
801077d0:	89 df                	mov    %ebx,%edi
801077d2:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
}

/// function to take a page from physical memory and put it in the swap file in the disc
void swapOut(void* va, struct proc *p){
  cprintf("un swapout\n");
  pte_t* pte = walkpgdir(p->pgdir, va, 0);
801077d8:	e8 43 f6 ff ff       	call   80106e20 <walkpgdir>
  void* startOfVApage = (void*) PGROUNDDOWN((uint) va);

  if(!*pte){
801077dd:	8b 10                	mov    (%eax),%edx
801077df:	83 c4 10             	add    $0x10,%esp
801077e2:	85 d2                	test   %edx,%edx
801077e4:	0f 84 3d 01 00 00    	je     80107927 <swapOut+0x177>
  }

  struct swapfile_metadata* sfm;
  int i = 0;
  for(sfm = p->sfm; sfm < &p->sfm[MAX_PSYC_PAGES] ; sfm++){
    if(!sfm->in_swap_file){
801077ea:	80 be 94 00 00 00 00 	cmpb   $0x0,0x94(%esi)
801077f1:	89 c2                	mov    %eax,%edx
    panic("swapOut");
  }

  struct swapfile_metadata* sfm;
  int i = 0;
  for(sfm = p->sfm; sfm < &p->sfm[MAX_PSYC_PAGES] ; sfm++){
801077f3:	8d 8e 90 00 00 00    	lea    0x90(%esi),%ecx
801077f9:	8d 9e 10 01 00 00    	lea    0x110(%esi),%ebx
    if(!sfm->in_swap_file){
801077ff:	0f 84 08 01 00 00    	je     8010790d <swapOut+0x15d>
80107805:	31 c0                	xor    %eax,%eax
80107807:	eb 0d                	jmp    80107816 <swapOut+0x66>
80107809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107810:	80 79 04 00          	cmpb   $0x0,0x4(%ecx)
80107814:	74 1a                	je     80107830 <swapOut+0x80>
    panic("swapOut");
  }

  struct swapfile_metadata* sfm;
  int i = 0;
  for(sfm = p->sfm; sfm < &p->sfm[MAX_PSYC_PAGES] ; sfm++){
80107816:	83 c1 08             	add    $0x8,%ecx
    if(!sfm->in_swap_file){
      break;
    }

    i++;
80107819:	83 c0 01             	add    $0x1,%eax
    panic("swapOut");
  }

  struct swapfile_metadata* sfm;
  int i = 0;
  for(sfm = p->sfm; sfm < &p->sfm[MAX_PSYC_PAGES] ; sfm++){
8010781c:	39 d9                	cmp    %ebx,%ecx
8010781e:	72 f0                	jb     80107810 <swapOut+0x60>
  }

  /// if all pages are in use
  if(sfm >= &p->sfm[MAX_PSYC_PAGES]){
    /// TODO panic or change 
    panic("swap file is full");
80107820:	83 ec 0c             	sub    $0xc,%esp
80107823:	68 50 87 10 80       	push   $0x80108750
80107828:	e8 43 8b ff ff       	call   80100370 <panic>
8010782d:	8d 76 00             	lea    0x0(%esi),%esi
80107830:	c1 e0 0c             	shl    $0xc,%eax
80107833:	8d 98 00 04 00 00    	lea    0x400(%eax),%ebx
80107839:	89 5d dc             	mov    %ebx,-0x24(%ebp)
8010783c:	8d 98 00 08 00 00    	lea    0x800(%eax),%ebx
80107842:	89 5d d8             	mov    %ebx,-0x28(%ebp)
80107845:	8d 98 00 0c 00 00    	lea    0xc00(%eax),%ebx
  uint placeOnFile = i * PGSIZE;
  ///char* physicalAddress = (char*) PTE_ADDR(*pte);

  /// maybe p2v on the address
  /// divide to 2 chuncks so we dont get panic
  writeToSwapFile(p, startOfVApage, placeOnFile, PGSIZE/4);
8010784b:	68 00 04 00 00       	push   $0x400
80107850:	50                   	push   %eax
80107851:	57                   	push   %edi
80107852:	56                   	push   %esi
80107853:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80107856:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107859:	e8 62 aa ff ff       	call   801022c0 <writeToSwapFile>
  placeOnFile += PGSIZE/4;
  writeToSwapFile(p, startOfVApage, placeOnFile, PGSIZE/4);
8010785e:	68 00 04 00 00       	push   $0x400
80107863:	ff 75 dc             	pushl  -0x24(%ebp)
80107866:	57                   	push   %edi
80107867:	56                   	push   %esi
80107868:	e8 53 aa ff ff       	call   801022c0 <writeToSwapFile>
  placeOnFile += PGSIZE/4;
  writeToSwapFile(p, startOfVApage, placeOnFile, PGSIZE/4);
8010786d:	83 c4 20             	add    $0x20,%esp
80107870:	68 00 04 00 00       	push   $0x400
80107875:	ff 75 d8             	pushl  -0x28(%ebp)
80107878:	57                   	push   %edi
80107879:	56                   	push   %esi
8010787a:	e8 41 aa ff ff       	call   801022c0 <writeToSwapFile>
  placeOnFile += PGSIZE/4;
  writeToSwapFile(p, startOfVApage, placeOnFile, PGSIZE/4);
8010787f:	68 00 04 00 00       	push   $0x400
80107884:	53                   	push   %ebx
80107885:	8d 9e 1c 01 00 00    	lea    0x11c(%esi),%ebx
8010788b:	57                   	push   %edi
8010788c:	56                   	push   %esi
8010788d:	e8 2e aa ff ff       	call   801022c0 <writeToSwapFile>

  /// making flags that pages swapped out and not present
  *pte = (*pte | PTE_PG) & ~PTE_P;
80107892:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  p->num_of_pages_in_memory--;

  cprintf("bug is in swapout?\n");
80107895:	83 c4 14             	add    $0x14,%esp
  writeToSwapFile(p, startOfVApage, placeOnFile, PGSIZE/4);
  placeOnFile += PGSIZE/4;
  writeToSwapFile(p, startOfVApage, placeOnFile, PGSIZE/4);

  /// making flags that pages swapped out and not present
  *pte = (*pte | PTE_PG) & ~PTE_P;
80107898:	8b 02                	mov    (%edx),%eax
8010789a:	25 fe fd ff ff       	and    $0xfffffdfe,%eax
8010789f:	80 cc 02             	or     $0x2,%ah
801078a2:	89 02                	mov    %eax,(%edx)
  p->num_of_pages_in_memory--;
801078a4:	83 ae 80 00 00 00 01 	subl   $0x1,0x80(%esi)

  cprintf("bug is in swapout?\n");
801078ab:	68 62 87 10 80       	push   $0x80108762
801078b0:	e8 ab 8d ff ff       	call   80100660 <cprintf>
801078b5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801078b8:	83 c4 10             	add    $0x10,%esp
/// update the memory pages data of process according to the specified algorithm
/// on page removal
void updateMemPagesOnRemove(void* va, struct proc *p){
  #ifdef NFUA
  int i;
  for(i = 0; i < MAX_PSYC_PAGES; i++){
801078bb:	31 c0                	xor    %eax,%eax
801078bd:	8d 76 00             	lea    0x0(%esi),%esi
    if(/*p->mem_pages[i].in_mem == 1 && */p->mem_pages[i].va == va){
801078c0:	3b 3b                	cmp    (%ebx),%edi
801078c2:	74 3c                	je     80107900 <swapOut+0x150>
/// update the memory pages data of process according to the specified algorithm
/// on page removal
void updateMemPagesOnRemove(void* va, struct proc *p){
  #ifdef NFUA
  int i;
  for(i = 0; i < MAX_PSYC_PAGES; i++){
801078c4:	83 c0 01             	add    $0x1,%eax
801078c7:	83 c3 14             	add    $0x14,%ebx
801078ca:	83 f8 10             	cmp    $0x10,%eax
801078cd:	75 f1                	jne    801078c0 <swapOut+0x110>
  /// update the swapfile metadata
  sfm->in_swap_file = 1;
  sfm->va = startOfVApage;

  /// free the page from the memory
  kfree(startOfVApage);
801078cf:	83 ec 0c             	sub    $0xc,%esp

  cprintf("bug is in swapout?\n");
  updateMemPagesOnRemove(startOfVApage, p);

  /// update the swapfile metadata
  sfm->in_swap_file = 1;
801078d2:	c6 41 04 01          	movb   $0x1,0x4(%ecx)
  sfm->va = startOfVApage;
801078d6:	89 39                	mov    %edi,(%ecx)

  /// free the page from the memory
  kfree(startOfVApage);
801078d8:	57                   	push   %edi
801078d9:	e8 22 ae ff ff       	call   80102700 <kfree>
801078de:	8b 46 04             	mov    0x4(%esi),%eax

  /// update stats
  p->num_of_currently_swapped_out_pages++;
801078e1:	83 86 84 00 00 00 01 	addl   $0x1,0x84(%esi)
  p->num_of_total_swap_out_actions++;
801078e8:	83 86 88 00 00 00 01 	addl   $0x1,0x88(%esi)
801078ef:	05 00 00 00 80       	add    $0x80000000,%eax
801078f4:	0f 22 d8             	mov    %eax,%cr3

  /// refresh the TLB
  lcr3(V2P(p->pgdir));
}
801078f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078fa:	5b                   	pop    %ebx
801078fb:	5e                   	pop    %esi
801078fc:	5f                   	pop    %edi
801078fd:	5d                   	pop    %ebp
801078fe:	c3                   	ret    
801078ff:	90                   	nop
  if(i == MAX_PSYC_PAGES){
    return;
    panic(" on remove");
  }

  p->mem_pages[i].in_mem = 0;
80107900:	8d 04 80             	lea    (%eax,%eax,4),%eax
80107903:	c6 84 86 20 01 00 00 	movb   $0x0,0x120(%esi,%eax,4)
8010790a:	00 
8010790b:	eb c2                	jmp    801078cf <swapOut+0x11f>
  }

  struct swapfile_metadata* sfm;
  int i = 0;
  for(sfm = p->sfm; sfm < &p->sfm[MAX_PSYC_PAGES] ; sfm++){
    if(!sfm->in_swap_file){
8010790d:	bb 00 0c 00 00       	mov    $0xc00,%ebx
80107912:	c7 45 d8 00 08 00 00 	movl   $0x800,-0x28(%ebp)
80107919:	c7 45 dc 00 04 00 00 	movl   $0x400,-0x24(%ebp)
80107920:	31 c0                	xor    %eax,%eax
80107922:	e9 24 ff ff ff       	jmp    8010784b <swapOut+0x9b>
  cprintf("un swapout\n");
  pte_t* pte = walkpgdir(p->pgdir, va, 0);
  void* startOfVApage = (void*) PGROUNDDOWN((uint) va);

  if(!*pte){
    panic("swapOut");
80107927:	83 ec 0c             	sub    $0xc,%esp
8010792a:	68 48 87 10 80       	push   $0x80108748
8010792f:	e8 3c 8a ff ff       	call   80100370 <panic>
80107934:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010793a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107940 <swapIn>:

  /// refresh the TLB
  lcr3(V2P(p->pgdir));
}

void swapIn(void* va, struct proc *p){
80107940:	55                   	push   %ebp
80107941:	89 e5                	mov    %esp,%ebp
80107943:	57                   	push   %edi
80107944:	56                   	push   %esi
80107945:	53                   	push   %ebx
  struct swapfile_metadata* sfm;
  void* startOfVApage = (void*) PGROUNDDOWN((uint) va);

  int i = 0;
  for(sfm = p->sfm; sfm < &p->sfm[MAX_PSYC_PAGES] ; sfm++){
80107946:	31 f6                	xor    %esi,%esi

  /// refresh the TLB
  lcr3(V2P(p->pgdir));
}

void swapIn(void* va, struct proc *p){
80107948:	83 ec 1c             	sub    $0x1c,%esp
8010794b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010794e:	8b 55 08             	mov    0x8(%ebp),%edx
  struct swapfile_metadata* sfm;
  void* startOfVApage = (void*) PGROUNDDOWN((uint) va);

  int i = 0;
  for(sfm = p->sfm; sfm < &p->sfm[MAX_PSYC_PAGES] ; sfm++){
80107951:	8d 9f 90 00 00 00    	lea    0x90(%edi),%ebx
  lcr3(V2P(p->pgdir));
}

void swapIn(void* va, struct proc *p){
  struct swapfile_metadata* sfm;
  void* startOfVApage = (void*) PGROUNDDOWN((uint) va);
80107957:	89 d1                	mov    %edx,%ecx

  int i = 0;
  for(sfm = p->sfm; sfm < &p->sfm[MAX_PSYC_PAGES] ; sfm++){
80107959:	8d 87 10 01 00 00    	lea    0x110(%edi),%eax
  lcr3(V2P(p->pgdir));
}

void swapIn(void* va, struct proc *p){
  struct swapfile_metadata* sfm;
  void* startOfVApage = (void*) PGROUNDDOWN((uint) va);
8010795f:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
80107965:	8d 76 00             	lea    0x0(%esi),%esi

  int i = 0;
  for(sfm = p->sfm; sfm < &p->sfm[MAX_PSYC_PAGES] ; sfm++){
    if(sfm->in_swap_file && sfm->va == startOfVApage){
80107968:	80 7b 04 00          	cmpb   $0x0,0x4(%ebx)
8010796c:	74 04                	je     80107972 <swapIn+0x32>
8010796e:	3b 0b                	cmp    (%ebx),%ecx
80107970:	74 1e                	je     80107990 <swapIn+0x50>
void swapIn(void* va, struct proc *p){
  struct swapfile_metadata* sfm;
  void* startOfVApage = (void*) PGROUNDDOWN((uint) va);

  int i = 0;
  for(sfm = p->sfm; sfm < &p->sfm[MAX_PSYC_PAGES] ; sfm++){
80107972:	83 c3 08             	add    $0x8,%ebx
    if(sfm->in_swap_file && sfm->va == startOfVApage){
      break;
    }

    i++;
80107975:	83 c6 01             	add    $0x1,%esi
void swapIn(void* va, struct proc *p){
  struct swapfile_metadata* sfm;
  void* startOfVApage = (void*) PGROUNDDOWN((uint) va);

  int i = 0;
  for(sfm = p->sfm; sfm < &p->sfm[MAX_PSYC_PAGES] ; sfm++){
80107978:	39 c3                	cmp    %eax,%ebx
8010797a:	72 ec                	jb     80107968 <swapIn+0x28>
    i++;
  }

  if(sfm >= &p->sfm[MAX_PSYC_PAGES]){
    /// TODO panic or change 
    panic("the requested page is not in the swapfile");
8010797c:	83 ec 0c             	sub    $0xc,%esp
8010797f:	68 0c 88 10 80       	push   $0x8010880c
80107984:	e8 e7 89 ff ff       	call   80100370 <panic>
80107989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }

    i++;
  }

  if(sfm >= &p->sfm[MAX_PSYC_PAGES]){
80107990:	39 d8                	cmp    %ebx,%eax
80107992:	76 e8                	jbe    8010797c <swapIn+0x3c>
    /// TODO panic or change 
    panic("the requested page is not in the swapfile");
  }

  pte_t* pte = walkpgdir(p->pgdir, va, 1);
80107994:	8b 47 04             	mov    0x4(%edi),%eax
80107997:	b9 01 00 00 00       	mov    $0x1,%ecx
8010799c:	e8 7f f4 ff ff       	call   80106e20 <walkpgdir>

  if(!*pte){
801079a1:	8b 08                	mov    (%eax),%ecx
801079a3:	85 c9                	test   %ecx,%ecx
801079a5:	0f 84 b0 00 00 00    	je     80107a5b <swapIn+0x11b>
  }

  /// allocate the page into the memory
  char* newVA = kalloc();

  uint placeOnFile = i * PGSIZE;
801079ab:	c1 e6 0c             	shl    $0xc,%esi
801079ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(!*pte){
    panic("swapIn");
  }

  /// allocate the page into the memory
  char* newVA = kalloc();
801079b1:	e8 3a af ff ff       	call   801028f0 <kalloc>

  uint placeOnFile = i * PGSIZE;

  /// divide to 2 chuncks so we dont get panic
  readFromSwapFile(p, newVA, placeOnFile, PGSIZE/4);
801079b6:	68 00 04 00 00       	push   $0x400
801079bb:	56                   	push   %esi
801079bc:	50                   	push   %eax
801079bd:	57                   	push   %edi
801079be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801079c1:	e8 2a a9 ff ff       	call   801022f0 <readFromSwapFile>
  placeOnFile += PGSIZE/4;
  readFromSwapFile(p, newVA, placeOnFile, PGSIZE/4);
801079c6:	8d 86 00 04 00 00    	lea    0x400(%esi),%eax
801079cc:	68 00 04 00 00       	push   $0x400
801079d1:	50                   	push   %eax
801079d2:	ff 75 e4             	pushl  -0x1c(%ebp)
801079d5:	57                   	push   %edi
801079d6:	e8 15 a9 ff ff       	call   801022f0 <readFromSwapFile>
  placeOnFile += PGSIZE/4;
  readFromSwapFile(p, newVA, placeOnFile, PGSIZE/4);
801079db:	8d 86 00 08 00 00    	lea    0x800(%esi),%eax
801079e1:	83 c4 20             	add    $0x20,%esp
  placeOnFile += PGSIZE/4;
  readFromSwapFile(p, newVA, placeOnFile, PGSIZE/4);
801079e4:	81 c6 00 0c 00 00    	add    $0xc00,%esi
  /// divide to 2 chuncks so we dont get panic
  readFromSwapFile(p, newVA, placeOnFile, PGSIZE/4);
  placeOnFile += PGSIZE/4;
  readFromSwapFile(p, newVA, placeOnFile, PGSIZE/4);
  placeOnFile += PGSIZE/4;
  readFromSwapFile(p, newVA, placeOnFile, PGSIZE/4);
801079ea:	68 00 04 00 00       	push   $0x400
801079ef:	50                   	push   %eax
801079f0:	ff 75 e4             	pushl  -0x1c(%ebp)
801079f3:	57                   	push   %edi
801079f4:	e8 f7 a8 ff ff       	call   801022f0 <readFromSwapFile>
  placeOnFile += PGSIZE/4;
  readFromSwapFile(p, newVA, placeOnFile, PGSIZE/4);
801079f9:	68 00 04 00 00       	push   $0x400
801079fe:	56                   	push   %esi
801079ff:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80107a02:	56                   	push   %esi
80107a03:	57                   	push   %edi
80107a04:	e8 e7 a8 ff ff       	call   801022f0 <readFromSwapFile>

  /// making flags that pages swapped in and present
  *pte = (V2P(newVA) | PTE_P | PTE_U | PTE_W) & ~PTE_PG;
80107a09:	89 f0                	mov    %esi,%eax
80107a0b:	8b 55 e0             	mov    -0x20(%ebp),%edx

  /// update the swapfile metadata
  sfm->in_swap_file = 0;

  /// ****** TODO ***** check if its newVA or startOfVApage
  cprintf("swapIn before bug?\n");
80107a0e:	83 c4 14             	add    $0x14,%esp
  readFromSwapFile(p, newVA, placeOnFile, PGSIZE/4);
  placeOnFile += PGSIZE/4;
  readFromSwapFile(p, newVA, placeOnFile, PGSIZE/4);

  /// making flags that pages swapped in and present
  *pte = (V2P(newVA) | PTE_P | PTE_U | PTE_W) & ~PTE_PG;
80107a11:	05 00 00 00 80       	add    $0x80000000,%eax
80107a16:	25 f8 fd ff ff       	and    $0xfffffdf8,%eax
80107a1b:	83 c8 07             	or     $0x7,%eax
80107a1e:	89 02                	mov    %eax,(%edx)
  p->num_of_pages_in_memory++;
80107a20:	83 87 80 00 00 00 01 	addl   $0x1,0x80(%edi)

  /// update the swapfile metadata
  sfm->in_swap_file = 0;
80107a27:	c6 43 04 00          	movb   $0x0,0x4(%ebx)

  /// ****** TODO ***** check if its newVA or startOfVApage
  cprintf("swapIn before bug?\n");
80107a2b:	68 7d 87 10 80       	push   $0x8010877d
80107a30:	e8 2b 8c ff ff       	call   80100660 <cprintf>
  updateMemPages(newVA, p);
80107a35:	58                   	pop    %eax
80107a36:	5a                   	pop    %edx
80107a37:	57                   	push   %edi
80107a38:	56                   	push   %esi
80107a39:	e8 d2 f5 ff ff       	call   80107010 <updateMemPages>
80107a3e:	8b 47 04             	mov    0x4(%edi),%eax

  /// update stats
  p->num_of_currently_swapped_out_pages--;
80107a41:	83 af 84 00 00 00 01 	subl   $0x1,0x84(%edi)
80107a48:	05 00 00 00 80       	add    $0x80000000,%eax
80107a4d:	0f 22 d8             	mov    %eax,%cr3

  /// refresh the TLB
  lcr3(V2P(p->pgdir));
}
80107a50:	83 c4 10             	add    $0x10,%esp
80107a53:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a56:	5b                   	pop    %ebx
80107a57:	5e                   	pop    %esi
80107a58:	5f                   	pop    %edi
80107a59:	5d                   	pop    %ebp
80107a5a:	c3                   	ret    
  }

  pte_t* pte = walkpgdir(p->pgdir, va, 1);

  if(!*pte){
    panic("swapIn");
80107a5b:	83 ec 0c             	sub    $0xc,%esp
80107a5e:	68 76 87 10 80       	push   $0x80108776
80107a63:	e8 08 89 ff ff       	call   80100370 <panic>
80107a68:	90                   	nop
80107a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107a70 <selectPageToSwapOut>:
  /// refresh the TLB
  lcr3(V2P(p->pgdir));
}

/// return virtual address of the page to swap out
void* selectPageToSwapOut(struct proc *p){
80107a70:	55                   	push   %ebp
  int minIndex = -1;

  #ifdef NFUA
  int i;
  uint minAge = 0xffffffff;
  for(i = 0 ; i < MAX_PSYC_PAGES ; i++){
80107a71:	31 d2                	xor    %edx,%edx
  /// refresh the TLB
  lcr3(V2P(p->pgdir));
}

/// return virtual address of the page to swap out
void* selectPageToSwapOut(struct proc *p){
80107a73:	89 e5                	mov    %esp,%ebp
80107a75:	57                   	push   %edi
80107a76:	56                   	push   %esi
80107a77:	53                   	push   %ebx

  int minIndex = -1;
80107a78:	be ff ff ff ff       	mov    $0xffffffff,%esi

  #ifdef NFUA
  int i;
  uint minAge = 0xffffffff;
80107a7d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  /// refresh the TLB
  lcr3(V2P(p->pgdir));
}

/// return virtual address of the page to swap out
void* selectPageToSwapOut(struct proc *p){
80107a82:	83 ec 0c             	sub    $0xc,%esp
80107a85:	8b 7d 08             	mov    0x8(%ebp),%edi
80107a88:	8d 87 20 01 00 00    	lea    0x120(%edi),%eax
80107a8e:	66 90                	xchg   %ax,%ax

  #ifdef NFUA
  int i;
  uint minAge = 0xffffffff;
  for(i = 0 ; i < MAX_PSYC_PAGES ; i++){
    if(!p->mem_pages[i].in_mem){
80107a90:	80 38 00             	cmpb   $0x0,(%eax)
80107a93:	74 36                	je     80107acb <selectPageToSwapOut+0x5b>
      panic("should not swap out if there is room in memory");
    }

    if(p->mem_pages[i].aging <= minAge){
80107a95:	8b 48 f8             	mov    -0x8(%eax),%ecx
80107a98:	39 d9                	cmp    %ebx,%ecx
80107a9a:	77 04                	ja     80107aa0 <selectPageToSwapOut+0x30>
80107a9c:	89 cb                	mov    %ecx,%ebx
80107a9e:	89 d6                	mov    %edx,%esi
  int minIndex = -1;

  #ifdef NFUA
  int i;
  uint minAge = 0xffffffff;
  for(i = 0 ; i < MAX_PSYC_PAGES ; i++){
80107aa0:	83 c2 01             	add    $0x1,%edx
80107aa3:	83 c0 14             	add    $0x14,%eax
80107aa6:	83 fa 10             	cmp    $0x10,%edx
80107aa9:	75 e5                	jne    80107a90 <selectPageToSwapOut+0x20>
    }
  }

  #endif

  if(minIndex == -1){
80107aab:	83 fe ff             	cmp    $0xffffffff,%esi
80107aae:	74 28                	je     80107ad8 <selectPageToSwapOut+0x68>
    panic("no page was chosen to be swapped out");
  }

  p->mem_pages[minIndex].in_mem = 0;
80107ab0:	8d 04 b6             	lea    (%esi,%esi,4),%eax
80107ab3:	8d 04 87             	lea    (%edi,%eax,4),%eax
80107ab6:	c6 80 20 01 00 00 00 	movb   $0x0,0x120(%eax)
  return p->mem_pages[minIndex].va;
80107abd:	8b 80 1c 01 00 00    	mov    0x11c(%eax),%eax
}
80107ac3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ac6:	5b                   	pop    %ebx
80107ac7:	5e                   	pop    %esi
80107ac8:	5f                   	pop    %edi
80107ac9:	5d                   	pop    %ebp
80107aca:	c3                   	ret    
  #ifdef NFUA
  int i;
  uint minAge = 0xffffffff;
  for(i = 0 ; i < MAX_PSYC_PAGES ; i++){
    if(!p->mem_pages[i].in_mem){
      panic("should not swap out if there is room in memory");
80107acb:	83 ec 0c             	sub    $0xc,%esp
80107ace:	68 38 88 10 80       	push   $0x80108838
80107ad3:	e8 98 88 ff ff       	call   80100370 <panic>
  }

  #endif

  if(minIndex == -1){
    panic("no page was chosen to be swapped out");
80107ad8:	83 ec 0c             	sub    $0xc,%esp
80107adb:	68 68 88 10 80       	push   $0x80108868
80107ae0:	e8 8b 88 ff ff       	call   80100370 <panic>
80107ae5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107af0 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107af0:	55                   	push   %ebp
80107af1:	89 e5                	mov    %esp,%ebp
80107af3:	57                   	push   %edi
80107af4:	56                   	push   %esi
80107af5:	53                   	push   %ebx
80107af6:	83 ec 0c             	sub    $0xc,%esp
80107af9:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80107afc:	85 ff                	test   %edi,%edi
80107afe:	0f 88 3a 01 00 00    	js     80107c3e <allocuvm+0x14e>
    return 0;
  if(newsz < oldsz)
80107b04:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80107b07:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
80107b0a:	0f 82 f4 00 00 00    	jb     80107c04 <allocuvm+0x114>
    return oldsz;

  a = PGROUNDUP(oldsz);
80107b10:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107b16:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80107b1c:	39 df                	cmp    %ebx,%edi
80107b1e:	77 34                	ja     80107b54 <allocuvm+0x64>
80107b20:	e9 2b 01 00 00       	jmp    80107c50 <allocuvm+0x160>
80107b25:	8d 76 00             	lea    0x0(%esi),%esi
        if(myproc()->num_of_pages_in_memory == MAX_PSYC_PAGES){
          void* swapOutVa = selectPageToSwapOut(myproc());
          swapOut(swapOutVa, myproc());
        }

        updateMemPages((void*) a, myproc());
80107b28:	e8 33 c1 ff ff       	call   80103c60 <myproc>
80107b2d:	83 ec 08             	sub    $0x8,%esp
80107b30:	50                   	push   %eax
80107b31:	53                   	push   %ebx
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107b32:	81 c3 00 10 00 00    	add    $0x1000,%ebx
        if(myproc()->num_of_pages_in_memory == MAX_PSYC_PAGES){
          void* swapOutVa = selectPageToSwapOut(myproc());
          swapOut(swapOutVa, myproc());
        }

        updateMemPages((void*) a, myproc());
80107b38:	e8 d3 f4 ff ff       	call   80107010 <updateMemPages>
        myproc()->num_of_pages_in_memory++;
80107b3d:	e8 1e c1 ff ff       	call   80103c60 <myproc>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107b42:	83 c4 10             	add    $0x10,%esp
          void* swapOutVa = selectPageToSwapOut(myproc());
          swapOut(swapOutVa, myproc());
        }

        updateMemPages((void*) a, myproc());
        myproc()->num_of_pages_in_memory++;
80107b45:	83 80 80 00 00 00 01 	addl   $0x1,0x80(%eax)
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107b4c:	39 df                	cmp    %ebx,%edi
80107b4e:	0f 86 fc 00 00 00    	jbe    80107c50 <allocuvm+0x160>
    mem = kalloc();
80107b54:	e8 97 ad ff ff       	call   801028f0 <kalloc>
    if(mem == 0){
80107b59:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
80107b5b:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107b5d:	0f 84 7d 00 00 00    	je     80107be0 <allocuvm+0xf0>
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80107b63:	83 ec 04             	sub    $0x4,%esp
80107b66:	68 00 10 00 00       	push   $0x1000
80107b6b:	6a 00                	push   $0x0
80107b6d:	50                   	push   %eax
80107b6e:	e8 6d d0 ff ff       	call   80104be0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107b73:	58                   	pop    %eax
80107b74:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107b7a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107b7f:	5a                   	pop    %edx
80107b80:	6a 06                	push   $0x6
80107b82:	50                   	push   %eax
80107b83:	89 da                	mov    %ebx,%edx
80107b85:	8b 45 08             	mov    0x8(%ebp),%eax
80107b88:	e8 13 f3 ff ff       	call   80106ea0 <mappages>
80107b8d:	83 c4 10             	add    $0x10,%esp
80107b90:	85 c0                	test   %eax,%eax
80107b92:	78 7c                	js     80107c10 <allocuvm+0x120>


    #ifndef NONE
      //if((strcmp(myproc()->name, "init") && strcmp(myproc()->name, "sh"))){

        if(myproc()->num_of_pages_in_memory > MAX_PSYC_PAGES){
80107b94:	e8 c7 c0 ff ff       	call   80103c60 <myproc>
80107b99:	83 b8 80 00 00 00 10 	cmpl   $0x10,0x80(%eax)
80107ba0:	0f 8f b4 00 00 00    	jg     80107c5a <allocuvm+0x16a>
          panic("too many pages in memory, allocuvm");
        }

        /// check if there is enough memory for page
        if(myproc()->num_of_pages_in_memory == MAX_PSYC_PAGES){
80107ba6:	e8 b5 c0 ff ff       	call   80103c60 <myproc>
80107bab:	83 b8 80 00 00 00 10 	cmpl   $0x10,0x80(%eax)
80107bb2:	0f 85 70 ff ff ff    	jne    80107b28 <allocuvm+0x38>
          void* swapOutVa = selectPageToSwapOut(myproc());
80107bb8:	e8 a3 c0 ff ff       	call   80103c60 <myproc>
80107bbd:	83 ec 0c             	sub    $0xc,%esp
80107bc0:	50                   	push   %eax
80107bc1:	e8 aa fe ff ff       	call   80107a70 <selectPageToSwapOut>
80107bc6:	89 c6                	mov    %eax,%esi
          swapOut(swapOutVa, myproc());
80107bc8:	e8 93 c0 ff ff       	call   80103c60 <myproc>
80107bcd:	5a                   	pop    %edx
80107bce:	59                   	pop    %ecx
80107bcf:	50                   	push   %eax
80107bd0:	56                   	push   %esi
80107bd1:	e8 da fb ff ff       	call   801077b0 <swapOut>
80107bd6:	83 c4 10             	add    $0x10,%esp
80107bd9:	e9 4a ff ff ff       	jmp    80107b28 <allocuvm+0x38>
80107bde:	66 90                	xchg   %ax,%ax

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
80107be0:	83 ec 0c             	sub    $0xc,%esp
80107be3:	68 91 87 10 80       	push   $0x80108791
80107be8:	e8 73 8a ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80107bed:	83 c4 10             	add    $0x10,%esp
80107bf0:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107bf3:	76 49                	jbe    80107c3e <allocuvm+0x14e>
80107bf5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107bf8:	8b 45 08             	mov    0x8(%ebp),%eax
80107bfb:	89 fa                	mov    %edi,%edx
80107bfd:	e8 2e f3 ff ff       	call   80106f30 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80107c02:	31 c0                	xor    %eax,%eax


  }

  return newsz;
}
80107c04:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c07:	5b                   	pop    %ebx
80107c08:	5e                   	pop    %esi
80107c09:	5f                   	pop    %edi
80107c0a:	5d                   	pop    %ebp
80107c0b:	c3                   	ret    
80107c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80107c10:	83 ec 0c             	sub    $0xc,%esp
80107c13:	68 a9 87 10 80       	push   $0x801087a9
80107c18:	e8 43 8a ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80107c1d:	83 c4 10             	add    $0x10,%esp
80107c20:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107c23:	76 0d                	jbe    80107c32 <allocuvm+0x142>
80107c25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107c28:	8b 45 08             	mov    0x8(%ebp),%eax
80107c2b:	89 fa                	mov    %edi,%edx
80107c2d:	e8 fe f2 ff ff       	call   80106f30 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80107c32:	83 ec 0c             	sub    $0xc,%esp
80107c35:	56                   	push   %esi
80107c36:	e8 c5 aa ff ff       	call   80102700 <kfree>
      return 0;
80107c3b:	83 c4 10             	add    $0x10,%esp


  }

  return newsz;
}
80107c3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80107c41:	31 c0                	xor    %eax,%eax


  }

  return newsz;
}
80107c43:	5b                   	pop    %ebx
80107c44:	5e                   	pop    %esi
80107c45:	5f                   	pop    %edi
80107c46:	5d                   	pop    %ebp
80107c47:	c3                   	ret    
80107c48:	90                   	nop
80107c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c50:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107c53:	89 f8                	mov    %edi,%eax


  }

  return newsz;
}
80107c55:	5b                   	pop    %ebx
80107c56:	5e                   	pop    %esi
80107c57:	5f                   	pop    %edi
80107c58:	5d                   	pop    %ebp
80107c59:	c3                   	ret    

    #ifndef NONE
      //if((strcmp(myproc()->name, "init") && strcmp(myproc()->name, "sh"))){

        if(myproc()->num_of_pages_in_memory > MAX_PSYC_PAGES){
          panic("too many pages in memory, allocuvm");
80107c5a:	83 ec 0c             	sub    $0xc,%esp
80107c5d:	68 90 88 10 80       	push   $0x80108890
80107c62:	e8 09 87 ff ff       	call   80100370 <panic>
