
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
8010002d:	b8 d0 32 10 80       	mov    $0x801032d0,%eax
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
8010004c:	68 00 80 10 80       	push   $0x80108000
80100051:	68 c0 c5 10 80       	push   $0x8010c5c0
80100056:	e8 45 4b 00 00       	call   80104ba0 <initlock>

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
80100092:	68 07 80 10 80       	push   $0x80108007
80100097:	50                   	push   %eax
80100098:	e8 f3 49 00 00       	call   80104a90 <initsleeplock>
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
801000e4:	e8 b7 4b 00 00       	call   80104ca0 <acquire>

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
80100162:	e8 79 4c 00 00       	call   80104de0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 5e 49 00 00       	call   80104ad0 <acquiresleep>
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
8010017e:	e8 9d 23 00 00       	call   80102520 <iderw>
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
80100193:	68 0e 80 10 80       	push   $0x8010800e
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
801001ae:	e8 bd 49 00 00       	call   80104b70 <holdingsleep>
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
801001c4:	e9 57 23 00 00       	jmp    80102520 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 1f 80 10 80       	push   $0x8010801f
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
801001ef:	e8 7c 49 00 00       	call   80104b70 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 2c 49 00 00       	call   80104b30 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010020b:	e8 90 4a 00 00       	call   80104ca0 <acquire>
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
8010025c:	e9 7f 4b 00 00       	jmp    80104de0 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 26 80 10 80       	push   $0x80108026
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
80100280:	e8 5b 15 00 00       	call   801017e0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 0f 4a 00 00       	call   80104ca0 <acquire>
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
801002bd:	e8 ae 40 00 00       	call   80104370 <sleep>

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
801002d2:	e8 a9 39 00 00       	call   80103c80 <myproc>
801002d7:	8b 40 24             	mov    0x24(%eax),%eax
801002da:	85 c0                	test   %eax,%eax
801002dc:	74 d2                	je     801002b0 <consoleread+0x40>
        release(&cons.lock);
801002de:	83 ec 0c             	sub    $0xc,%esp
801002e1:	68 20 b5 10 80       	push   $0x8010b520
801002e6:	e8 f5 4a 00 00       	call   80104de0 <release>
        ilock(ip);
801002eb:	89 3c 24             	mov    %edi,(%esp)
801002ee:	e8 0d 14 00 00       	call   80101700 <ilock>
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
80100346:	e8 95 4a 00 00       	call   80104de0 <release>
  ilock(ip);
8010034b:	89 3c 24             	mov    %edi,(%esp)
8010034e:	e8 ad 13 00 00       	call   80101700 <ilock>

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
80100389:	e8 d2 27 00 00       	call   80102b60 <lapicid>
8010038e:	83 ec 08             	sub    $0x8,%esp
80100391:	50                   	push   %eax
80100392:	68 2d 80 10 80       	push   $0x8010802d
80100397:	e8 c4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
8010039c:	58                   	pop    %eax
8010039d:	ff 75 08             	pushl  0x8(%ebp)
801003a0:	e8 bb 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003a5:	c7 04 24 6f 8b 10 80 	movl   $0x80108b6f,(%esp)
801003ac:	e8 af 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003b1:	5a                   	pop    %edx
801003b2:	8d 45 08             	lea    0x8(%ebp),%eax
801003b5:	59                   	pop    %ecx
801003b6:	53                   	push   %ebx
801003b7:	50                   	push   %eax
801003b8:	e8 03 48 00 00       	call   80104bc0 <getcallerpcs>
801003bd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003c0:	83 ec 08             	sub    $0x8,%esp
801003c3:	ff 33                	pushl  (%ebx)
801003c5:	83 c3 04             	add    $0x4,%ebx
801003c8:	68 41 80 10 80       	push   $0x80108041
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
8010041a:	e8 91 61 00 00       	call   801065b0 <uartputc>
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
801004d3:	e8 d8 60 00 00       	call   801065b0 <uartputc>
801004d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004df:	e8 cc 60 00 00       	call   801065b0 <uartputc>
801004e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004eb:	e8 c0 60 00 00       	call   801065b0 <uartputc>
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
80100514:	e8 c7 49 00 00       	call   80104ee0 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100519:	b8 80 07 00 00       	mov    $0x780,%eax
8010051e:	83 c4 0c             	add    $0xc,%esp
80100521:	29 d8                	sub    %ebx,%eax
80100523:	01 c0                	add    %eax,%eax
80100525:	50                   	push   %eax
80100526:	6a 00                	push   $0x0
80100528:	56                   	push   %esi
80100529:	e8 02 49 00 00       	call   80104e30 <memset>
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
80100540:	68 45 80 10 80       	push   $0x80108045
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
801005b1:	0f b6 92 70 80 10 80 	movzbl -0x7fef7f90(%edx),%edx
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
8010060f:	e8 cc 11 00 00       	call   801017e0 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 80 46 00 00       	call   80104ca0 <acquire>
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
80100647:	e8 94 47 00 00       	call   80104de0 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 ab 10 00 00       	call   80101700 <ilock>

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
8010070d:	e8 ce 46 00 00       	call   80104de0 <release>
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
80100788:	b8 58 80 10 80       	mov    $0x80108058,%eax
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
801007c8:	e8 d3 44 00 00       	call   80104ca0 <acquire>
801007cd:	83 c4 10             	add    $0x10,%esp
801007d0:	e9 a4 fe ff ff       	jmp    80100679 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007d5:	83 ec 0c             	sub    $0xc,%esp
801007d8:	68 5f 80 10 80       	push   $0x8010805f
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
80100803:	e8 98 44 00 00       	call   80104ca0 <acquire>
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
80100868:	e8 73 45 00 00       	call   80104de0 <release>
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
801008f6:	e8 35 3c 00 00       	call   80104530 <wakeup>
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
80100977:	e9 a4 3c 00 00       	jmp    80104620 <procdump>
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
801009a6:	68 68 80 10 80       	push   $0x80108068
801009ab:	68 20 b5 10 80       	push   $0x8010b520
801009b0:	e8 eb 41 00 00       	call   80104ba0 <initlock>

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
801009d9:	e8 f2 1c 00 00       	call   801026d0 <ioapicenable>
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
801009fc:	e8 7f 32 00 00       	call   80103c80 <myproc>
80100a01:	89 c6                	mov    %eax,%esi

  begin_op();
80100a03:	e8 b8 25 00 00       	call   80102fc0 <begin_op>

  if((ip = namei(path)) == 0){
80100a08:	83 ec 0c             	sub    $0xc,%esp
80100a0b:	ff 75 08             	pushl  0x8(%ebp)
80100a0e:	e8 3d 15 00 00       	call   80101f50 <namei>
80100a13:	83 c4 10             	add    $0x10,%esp
80100a16:	85 c0                	test   %eax,%eax
80100a18:	0f 84 22 02 00 00    	je     80100c40 <exec+0x250>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a1e:	83 ec 0c             	sub    $0xc,%esp
80100a21:	89 c3                	mov    %eax,%ebx
80100a23:	50                   	push   %eax
80100a24:	e8 d7 0c 00 00       	call   80101700 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a29:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a2f:	6a 34                	push   $0x34
80100a31:	6a 00                	push   $0x0
80100a33:	50                   	push   %eax
80100a34:	53                   	push   %ebx
80100a35:	e8 a6 0f 00 00       	call   801019e0 <readi>
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
80100a46:	e8 45 0f 00 00       	call   80101990 <iunlockput>
    end_op();
80100a4b:	e8 e0 25 00 00       	call   80103030 <end_op>
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
80100a6c:	e8 0f 6e 00 00       	call   80107880 <setupkvm>
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
80100aba:	8d 86 24 01 00 00    	lea    0x124(%esi),%eax
80100ac0:	8d 96 a4 02 00 00    	lea    0x2a4(%esi),%edx
80100ac6:	8d 76 00             	lea    0x0(%esi),%esi
80100ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    curproc->sfm[i].in_swap_file = 0;
  }

  for(i = 0 ; i < MAX_PSYC_PAGES ; i++){
    curproc->mem_pages[i].in_mem = 0;
80100ad0:	c6 00 00             	movb   $0x0,(%eax)
80100ad3:	83 c0 18             	add    $0x18,%eax

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
80100ae2:	c7 86 90 02 00 00 00 	movl   $0x0,0x290(%esi)
80100ae9:	00 00 00 
  curproc->last = 0;
80100aec:	c7 86 94 02 00 00 00 	movl   $0x0,0x294(%esi)
80100af3:	00 00 00 

  #endif

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100af6:	8b bd 40 ff ff ff    	mov    -0xc0(%ebp),%edi
80100afc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b03:	00 00 00 
80100b06:	0f 84 d8 00 00 00    	je     80100be4 <exec+0x1f4>
80100b0c:	31 c0                	xor    %eax,%eax
80100b0e:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100b14:	89 c6                	mov    %eax,%esi
80100b16:	eb 1d                	jmp    80100b35 <exec+0x145>
80100b18:	90                   	nop
80100b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b20:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b27:	83 c6 01             	add    $0x1,%esi
80100b2a:	83 c7 20             	add    $0x20,%edi
80100b2d:	39 f0                	cmp    %esi,%eax
80100b2f:	0f 8e a9 00 00 00    	jle    80100bde <exec+0x1ee>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b35:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b3b:	6a 20                	push   $0x20
80100b3d:	57                   	push   %edi
80100b3e:	50                   	push   %eax
80100b3f:	53                   	push   %ebx
80100b40:	e8 9b 0e 00 00       	call   801019e0 <readi>
80100b45:	83 c4 10             	add    $0x10,%esp
80100b48:	83 f8 20             	cmp    $0x20,%eax
80100b4b:	75 7b                	jne    80100bc8 <exec+0x1d8>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100b4d:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b54:	75 ca                	jne    80100b20 <exec+0x130>
      continue;
    if(ph.memsz < ph.filesz)
80100b56:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b5c:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b62:	72 64                	jb     80100bc8 <exec+0x1d8>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b64:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b6a:	72 5c                	jb     80100bc8 <exec+0x1d8>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b6c:	83 ec 04             	sub    $0x4,%esp
80100b6f:	50                   	push   %eax
80100b70:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b76:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b7c:	e8 ff 72 00 00       	call   80107e80 <allocuvm>
80100b81:	83 c4 10             	add    $0x10,%esp
80100b84:	85 c0                	test   %eax,%eax
80100b86:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b8c:	74 3a                	je     80100bc8 <exec+0x1d8>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100b8e:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b94:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b99:	75 2d                	jne    80100bc8 <exec+0x1d8>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b9b:	83 ec 0c             	sub    $0xc,%esp
80100b9e:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100ba4:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100baa:	53                   	push   %ebx
80100bab:	50                   	push   %eax
80100bac:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100bb2:	e8 59 6b 00 00       	call   80107710 <loaduvm>
80100bb7:	83 c4 20             	add    $0x20,%esp
80100bba:	85 c0                	test   %eax,%eax
80100bbc:	0f 89 5e ff ff ff    	jns    80100b20 <exec+0x130>
80100bc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100bc8:	83 ec 0c             	sub    $0xc,%esp
80100bcb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100bd1:	e8 2a 6c 00 00       	call   80107800 <freevm>
80100bd6:	83 c4 10             	add    $0x10,%esp
80100bd9:	e9 64 fe ff ff       	jmp    80100a42 <exec+0x52>
80100bde:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100be4:	83 ec 0c             	sub    $0xc,%esp
80100be7:	53                   	push   %ebx
80100be8:	e8 a3 0d 00 00       	call   80101990 <iunlockput>
  end_op();
80100bed:	e8 3e 24 00 00       	call   80103030 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100bf2:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100bf8:	83 c4 0c             	add    $0xc,%esp
  end_op();
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100bfb:	05 ff 0f 00 00       	add    $0xfff,%eax
80100c00:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c05:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100c0b:	52                   	push   %edx
80100c0c:	50                   	push   %eax
80100c0d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c13:	e8 68 72 00 00       	call   80107e80 <allocuvm>
80100c18:	83 c4 10             	add    $0x10,%esp
80100c1b:	85 c0                	test   %eax,%eax
80100c1d:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100c23:	75 3a                	jne    80100c5f <exec+0x26f>

  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100c25:	83 ec 0c             	sub    $0xc,%esp
80100c28:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c2e:	e8 cd 6b 00 00       	call   80107800 <freevm>
80100c33:	83 c4 10             	add    $0x10,%esp
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100c36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c3b:	e9 18 fe ff ff       	jmp    80100a58 <exec+0x68>
  struct proc *curproc = myproc();

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
80100c40:	e8 eb 23 00 00       	call   80103030 <end_op>
    cprintf("exec: fail\n");
80100c45:	83 ec 0c             	sub    $0xc,%esp
80100c48:	68 81 80 10 80       	push   $0x80108081
80100c4d:	e8 0e fa ff ff       	call   80100660 <cprintf>
    return -1;
80100c52:	83 c4 10             	add    $0x10,%esp
80100c55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c5a:	e9 f9 fd ff ff       	jmp    80100a58 <exec+0x68>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c5f:	8b 9d f0 fe ff ff    	mov    -0x110(%ebp),%ebx
80100c65:	83 ec 08             	sub    $0x8,%esp
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c68:	31 ff                	xor    %edi,%edi
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c6a:	89 d8                	mov    %ebx,%eax
80100c6c:	2d 00 20 00 00       	sub    $0x2000,%eax
80100c71:	50                   	push   %eax
80100c72:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c78:	e8 a3 6c 00 00       	call   80107920 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c7d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c80:	83 c4 10             	add    $0x10,%esp
80100c83:	8b 00                	mov    (%eax),%eax
80100c85:	85 c0                	test   %eax,%eax
80100c87:	0f 84 3c 01 00 00    	je     80100dc9 <exec+0x3d9>
80100c8d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c93:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c99:	eb 0a                	jmp    80100ca5 <exec+0x2b5>
80100c9b:	90                   	nop
80100c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100ca0:	83 ff 20             	cmp    $0x20,%edi
80100ca3:	74 80                	je     80100c25 <exec+0x235>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ca5:	83 ec 0c             	sub    $0xc,%esp
80100ca8:	50                   	push   %eax
80100ca9:	e8 c2 43 00 00       	call   80105070 <strlen>
80100cae:	f7 d0                	not    %eax
80100cb0:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb2:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cb5:	5a                   	pop    %edx

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb6:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb9:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cbc:	e8 af 43 00 00       	call   80105070 <strlen>
80100cc1:	83 c0 01             	add    $0x1,%eax
80100cc4:	50                   	push   %eax
80100cc5:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc8:	ff 34 b8             	pushl  (%eax,%edi,4)
80100ccb:	53                   	push   %ebx
80100ccc:	56                   	push   %esi
80100ccd:	e8 de 6d 00 00       	call   80107ab0 <copyout>
80100cd2:	83 c4 20             	add    $0x20,%esp
80100cd5:	85 c0                	test   %eax,%eax
80100cd7:	0f 88 48 ff ff ff    	js     80100c25 <exec+0x235>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100ce0:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100ce7:	83 c7 01             	add    $0x1,%edi
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100cea:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100cf0:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cf3:	85 c0                	test   %eax,%eax
80100cf5:	75 a9                	jne    80100ca0 <exec+0x2b0>
80100cf7:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cfd:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d04:	89 d9                	mov    %ebx,%ecx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100d06:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d0d:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100d11:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d18:	ff ff ff 
  ustack[1] = argc;
80100d1b:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d21:	29 c1                	sub    %eax,%ecx

  sp -= (3+argc+1) * 4;
80100d23:	83 c0 0c             	add    $0xc,%eax
80100d26:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d28:	50                   	push   %eax
80100d29:	52                   	push   %edx
80100d2a:	53                   	push   %ebx
80100d2b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d31:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d37:	e8 74 6d 00 00       	call   80107ab0 <copyout>
80100d3c:	83 c4 10             	add    $0x10,%esp
80100d3f:	85 c0                	test   %eax,%eax
80100d41:	0f 88 de fe ff ff    	js     80100c25 <exec+0x235>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100d47:	8b 45 08             	mov    0x8(%ebp),%eax
80100d4a:	0f b6 10             	movzbl (%eax),%edx
80100d4d:	84 d2                	test   %dl,%dl
80100d4f:	74 19                	je     80100d6a <exec+0x37a>
80100d51:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100d54:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
80100d57:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100d5a:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100d5d:	0f 44 c8             	cmove  %eax,%ecx
80100d60:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100d63:	84 d2                	test   %dl,%dl
80100d65:	75 f0                	jne    80100d57 <exec+0x367>
80100d67:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d6a:	50                   	push   %eax
80100d6b:	8d 46 6c             	lea    0x6c(%esi),%eax
80100d6e:	6a 10                	push   $0x10
80100d70:	ff 75 08             	pushl  0x8(%ebp)
80100d73:	50                   	push   %eax
80100d74:	e8 b7 42 00 00       	call   80105030 <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100d79:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100d7f:	8b 7e 04             	mov    0x4(%esi),%edi
  curproc->pgdir = pgdir;
80100d82:	89 46 04             	mov    %eax,0x4(%esi)
  curproc->sz = sz;
80100d85:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100d8b:	89 06                	mov    %eax,(%esi)
  curproc->tf->eip = elf.entry;  // main
80100d8d:	8b 46 18             	mov    0x18(%esi),%eax
80100d90:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d96:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d99:	8b 46 18             	mov    0x18(%esi),%eax
80100d9c:	89 58 44             	mov    %ebx,0x44(%eax)

  #ifndef NONE
  /// create new swapfile for process
  removeSwapFile(curproc);
80100d9f:	89 34 24             	mov    %esi,(%esp)
80100da2:	e8 89 12 00 00       	call   80102030 <removeSwapFile>
  createSwapFile(curproc);
80100da7:	89 34 24             	mov    %esi,(%esp)
80100daa:	e8 81 14 00 00       	call   80102230 <createSwapFile>
  #endif

  switchuvm(curproc);
80100daf:	89 34 24             	mov    %esi,(%esp)
80100db2:	e8 c9 67 00 00       	call   80107580 <switchuvm>
  freevm(oldpgdir);
80100db7:	89 3c 24             	mov    %edi,(%esp)
80100dba:	e8 41 6a 00 00       	call   80107800 <freevm>

  return 0;
80100dbf:	83 c4 10             	add    $0x10,%esp
80100dc2:	31 c0                	xor    %eax,%eax
80100dc4:	e9 8f fc ff ff       	jmp    80100a58 <exec+0x68>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100dc9:	8b 9d f0 fe ff ff    	mov    -0x110(%ebp),%ebx
80100dcf:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100dd5:	e9 23 ff ff ff       	jmp    80100cfd <exec+0x30d>
80100dda:	66 90                	xchg   %ax,%ax
80100ddc:	66 90                	xchg   %ax,%ax
80100dde:	66 90                	xchg   %ax,%ax

80100de0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100de0:	55                   	push   %ebp
80100de1:	89 e5                	mov    %esp,%ebp
80100de3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100de6:	68 8d 80 10 80       	push   $0x8010808d
80100deb:	68 c0 0f 11 80       	push   $0x80110fc0
80100df0:	e8 ab 3d 00 00       	call   80104ba0 <initlock>
}
80100df5:	83 c4 10             	add    $0x10,%esp
80100df8:	c9                   	leave  
80100df9:	c3                   	ret    
80100dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e00 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e00:	55                   	push   %ebp
80100e01:	89 e5                	mov    %esp,%ebp
80100e03:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e04:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e09:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100e0c:	68 c0 0f 11 80       	push   $0x80110fc0
80100e11:	e8 8a 3e 00 00       	call   80104ca0 <acquire>
80100e16:	83 c4 10             	add    $0x10,%esp
80100e19:	eb 10                	jmp    80100e2b <filealloc+0x2b>
80100e1b:	90                   	nop
80100e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e20:	83 c3 18             	add    $0x18,%ebx
80100e23:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
80100e29:	74 25                	je     80100e50 <filealloc+0x50>
    if(f->ref == 0){
80100e2b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e2e:	85 c0                	test   %eax,%eax
80100e30:	75 ee                	jne    80100e20 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e32:	83 ec 0c             	sub    $0xc,%esp
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100e35:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e3c:	68 c0 0f 11 80       	push   $0x80110fc0
80100e41:	e8 9a 3f 00 00       	call   80104de0 <release>
      return f;
80100e46:	89 d8                	mov    %ebx,%eax
80100e48:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e4e:	c9                   	leave  
80100e4f:	c3                   	ret    
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100e50:	83 ec 0c             	sub    $0xc,%esp
80100e53:	68 c0 0f 11 80       	push   $0x80110fc0
80100e58:	e8 83 3f 00 00       	call   80104de0 <release>
  return 0;
80100e5d:	83 c4 10             	add    $0x10,%esp
80100e60:	31 c0                	xor    %eax,%eax
}
80100e62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e65:	c9                   	leave  
80100e66:	c3                   	ret    
80100e67:	89 f6                	mov    %esi,%esi
80100e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e70 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e70:	55                   	push   %ebp
80100e71:	89 e5                	mov    %esp,%ebp
80100e73:	53                   	push   %ebx
80100e74:	83 ec 10             	sub    $0x10,%esp
80100e77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e7a:	68 c0 0f 11 80       	push   $0x80110fc0
80100e7f:	e8 1c 3e 00 00       	call   80104ca0 <acquire>
  if(f->ref < 1)
80100e84:	8b 43 04             	mov    0x4(%ebx),%eax
80100e87:	83 c4 10             	add    $0x10,%esp
80100e8a:	85 c0                	test   %eax,%eax
80100e8c:	7e 1a                	jle    80100ea8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e8e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e91:	83 ec 0c             	sub    $0xc,%esp
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  f->ref++;
80100e94:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e97:	68 c0 0f 11 80       	push   $0x80110fc0
80100e9c:	e8 3f 3f 00 00       	call   80104de0 <release>
  return f;
}
80100ea1:	89 d8                	mov    %ebx,%eax
80100ea3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ea6:	c9                   	leave  
80100ea7:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100ea8:	83 ec 0c             	sub    $0xc,%esp
80100eab:	68 94 80 10 80       	push   $0x80108094
80100eb0:	e8 bb f4 ff ff       	call   80100370 <panic>
80100eb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100ec0 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ec0:	55                   	push   %ebp
80100ec1:	89 e5                	mov    %esp,%ebp
80100ec3:	57                   	push   %edi
80100ec4:	56                   	push   %esi
80100ec5:	53                   	push   %ebx
80100ec6:	83 ec 28             	sub    $0x28,%esp
80100ec9:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100ecc:	68 c0 0f 11 80       	push   $0x80110fc0
80100ed1:	e8 ca 3d 00 00       	call   80104ca0 <acquire>
  if(f->ref < 1)
80100ed6:	8b 47 04             	mov    0x4(%edi),%eax
80100ed9:	83 c4 10             	add    $0x10,%esp
80100edc:	85 c0                	test   %eax,%eax
80100ede:	0f 8e 9b 00 00 00    	jle    80100f7f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100ee4:	83 e8 01             	sub    $0x1,%eax
80100ee7:	85 c0                	test   %eax,%eax
80100ee9:	89 47 04             	mov    %eax,0x4(%edi)
80100eec:	74 1a                	je     80100f08 <fileclose+0x48>
    release(&ftable.lock);
80100eee:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100ef5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ef8:	5b                   	pop    %ebx
80100ef9:	5e                   	pop    %esi
80100efa:	5f                   	pop    %edi
80100efb:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100efc:	e9 df 3e 00 00       	jmp    80104de0 <release>
80100f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  ff = *f;
80100f08:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100f0c:	8b 1f                	mov    (%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f0e:	83 ec 0c             	sub    $0xc,%esp
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f11:	8b 77 0c             	mov    0xc(%edi),%esi
  f->ref = 0;
  f->type = FD_NONE;
80100f14:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f1a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f1d:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f20:	68 c0 0f 11 80       	push   $0x80110fc0
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f25:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f28:	e8 b3 3e 00 00       	call   80104de0 <release>

  if(ff.type == FD_PIPE)
80100f2d:	83 c4 10             	add    $0x10,%esp
80100f30:	83 fb 01             	cmp    $0x1,%ebx
80100f33:	74 13                	je     80100f48 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f35:	83 fb 02             	cmp    $0x2,%ebx
80100f38:	74 26                	je     80100f60 <fileclose+0xa0>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f3d:	5b                   	pop    %ebx
80100f3e:	5e                   	pop    %esi
80100f3f:	5f                   	pop    %edi
80100f40:	5d                   	pop    %ebp
80100f41:	c3                   	ret    
80100f42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100f48:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f4c:	83 ec 08             	sub    $0x8,%esp
80100f4f:	53                   	push   %ebx
80100f50:	56                   	push   %esi
80100f51:	e8 0a 28 00 00       	call   80103760 <pipeclose>
80100f56:	83 c4 10             	add    $0x10,%esp
80100f59:	eb df                	jmp    80100f3a <fileclose+0x7a>
80100f5b:	90                   	nop
80100f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100f60:	e8 5b 20 00 00       	call   80102fc0 <begin_op>
    iput(ff.ip);
80100f65:	83 ec 0c             	sub    $0xc,%esp
80100f68:	ff 75 e0             	pushl  -0x20(%ebp)
80100f6b:	e8 c0 08 00 00       	call   80101830 <iput>
    end_op();
80100f70:	83 c4 10             	add    $0x10,%esp
  }
}
80100f73:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f76:	5b                   	pop    %ebx
80100f77:	5e                   	pop    %esi
80100f78:	5f                   	pop    %edi
80100f79:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100f7a:	e9 b1 20 00 00       	jmp    80103030 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100f7f:	83 ec 0c             	sub    $0xc,%esp
80100f82:	68 9c 80 10 80       	push   $0x8010809c
80100f87:	e8 e4 f3 ff ff       	call   80100370 <panic>
80100f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f90 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f90:	55                   	push   %ebp
80100f91:	89 e5                	mov    %esp,%ebp
80100f93:	53                   	push   %ebx
80100f94:	83 ec 04             	sub    $0x4,%esp
80100f97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f9a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f9d:	75 31                	jne    80100fd0 <filestat+0x40>
    ilock(f->ip);
80100f9f:	83 ec 0c             	sub    $0xc,%esp
80100fa2:	ff 73 10             	pushl  0x10(%ebx)
80100fa5:	e8 56 07 00 00       	call   80101700 <ilock>
    stati(f->ip, st);
80100faa:	58                   	pop    %eax
80100fab:	5a                   	pop    %edx
80100fac:	ff 75 0c             	pushl  0xc(%ebp)
80100faf:	ff 73 10             	pushl  0x10(%ebx)
80100fb2:	e8 f9 09 00 00       	call   801019b0 <stati>
    iunlock(f->ip);
80100fb7:	59                   	pop    %ecx
80100fb8:	ff 73 10             	pushl  0x10(%ebx)
80100fbb:	e8 20 08 00 00       	call   801017e0 <iunlock>
    return 0;
80100fc0:	83 c4 10             	add    $0x10,%esp
80100fc3:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100fc5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fc8:	c9                   	leave  
80100fc9:	c3                   	ret    
80100fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100fd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fd5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fd8:	c9                   	leave  
80100fd9:	c3                   	ret    
80100fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100fe0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	57                   	push   %edi
80100fe4:	56                   	push   %esi
80100fe5:	53                   	push   %ebx
80100fe6:	83 ec 0c             	sub    $0xc,%esp
80100fe9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100fec:	8b 75 0c             	mov    0xc(%ebp),%esi
80100fef:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100ff2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100ff6:	74 60                	je     80101058 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100ff8:	8b 03                	mov    (%ebx),%eax
80100ffa:	83 f8 01             	cmp    $0x1,%eax
80100ffd:	74 41                	je     80101040 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100fff:	83 f8 02             	cmp    $0x2,%eax
80101002:	75 5b                	jne    8010105f <fileread+0x7f>
    ilock(f->ip);
80101004:	83 ec 0c             	sub    $0xc,%esp
80101007:	ff 73 10             	pushl  0x10(%ebx)
8010100a:	e8 f1 06 00 00       	call   80101700 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010100f:	57                   	push   %edi
80101010:	ff 73 14             	pushl  0x14(%ebx)
80101013:	56                   	push   %esi
80101014:	ff 73 10             	pushl  0x10(%ebx)
80101017:	e8 c4 09 00 00       	call   801019e0 <readi>
8010101c:	83 c4 20             	add    $0x20,%esp
8010101f:	85 c0                	test   %eax,%eax
80101021:	89 c6                	mov    %eax,%esi
80101023:	7e 03                	jle    80101028 <fileread+0x48>
      f->off += r;
80101025:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101028:	83 ec 0c             	sub    $0xc,%esp
8010102b:	ff 73 10             	pushl  0x10(%ebx)
8010102e:	e8 ad 07 00 00       	call   801017e0 <iunlock>
    return r;
80101033:	83 c4 10             	add    $0x10,%esp
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101036:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80101038:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010103b:	5b                   	pop    %ebx
8010103c:	5e                   	pop    %esi
8010103d:	5f                   	pop    %edi
8010103e:	5d                   	pop    %ebp
8010103f:	c3                   	ret    
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80101040:	8b 43 0c             	mov    0xc(%ebx),%eax
80101043:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80101046:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101049:	5b                   	pop    %ebx
8010104a:	5e                   	pop    %esi
8010104b:	5f                   	pop    %edi
8010104c:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
8010104d:	e9 ae 28 00 00       	jmp    80103900 <piperead>
80101052:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80101058:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010105d:	eb d9                	jmp    80101038 <fileread+0x58>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
8010105f:	83 ec 0c             	sub    $0xc,%esp
80101062:	68 a6 80 10 80       	push   $0x801080a6
80101067:	e8 04 f3 ff ff       	call   80100370 <panic>
8010106c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101070 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101070:	55                   	push   %ebp
80101071:	89 e5                	mov    %esp,%ebp
80101073:	57                   	push   %edi
80101074:	56                   	push   %esi
80101075:	53                   	push   %ebx
80101076:	83 ec 1c             	sub    $0x1c,%esp
80101079:	8b 75 08             	mov    0x8(%ebp),%esi
8010107c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010107f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101083:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101086:	8b 45 10             	mov    0x10(%ebp),%eax
80101089:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
8010108c:	0f 84 aa 00 00 00    	je     8010113c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101092:	8b 06                	mov    (%esi),%eax
80101094:	83 f8 01             	cmp    $0x1,%eax
80101097:	0f 84 c2 00 00 00    	je     8010115f <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010109d:	83 f8 02             	cmp    $0x2,%eax
801010a0:	0f 85 d8 00 00 00    	jne    8010117e <filewrite+0x10e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801010a9:	31 ff                	xor    %edi,%edi
801010ab:	85 c0                	test   %eax,%eax
801010ad:	7f 34                	jg     801010e3 <filewrite+0x73>
801010af:	e9 9c 00 00 00       	jmp    80101150 <filewrite+0xe0>
801010b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010b8:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801010bb:	83 ec 0c             	sub    $0xc,%esp
801010be:	ff 76 10             	pushl  0x10(%esi)
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010c4:	e8 17 07 00 00       	call   801017e0 <iunlock>
      end_op();
801010c9:	e8 62 1f 00 00       	call   80103030 <end_op>
801010ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010d1:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
801010d4:	39 d8                	cmp    %ebx,%eax
801010d6:	0f 85 95 00 00 00    	jne    80101171 <filewrite+0x101>
        panic("short filewrite");
      i += r;
801010dc:	01 c7                	add    %eax,%edi
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010de:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010e1:	7e 6d                	jle    80101150 <filewrite+0xe0>
      int n1 = n - i;
801010e3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801010e6:	b8 00 06 00 00       	mov    $0x600,%eax
801010eb:	29 fb                	sub    %edi,%ebx
801010ed:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
801010f3:	0f 4f d8             	cmovg  %eax,%ebx
      if(n1 > max)
        n1 = max;

      begin_op();
801010f6:	e8 c5 1e 00 00       	call   80102fc0 <begin_op>
      ilock(f->ip);
801010fb:	83 ec 0c             	sub    $0xc,%esp
801010fe:	ff 76 10             	pushl  0x10(%esi)
80101101:	e8 fa 05 00 00       	call   80101700 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101106:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101109:	53                   	push   %ebx
8010110a:	ff 76 14             	pushl  0x14(%esi)
8010110d:	01 f8                	add    %edi,%eax
8010110f:	50                   	push   %eax
80101110:	ff 76 10             	pushl  0x10(%esi)
80101113:	e8 c8 09 00 00       	call   80101ae0 <writei>
80101118:	83 c4 20             	add    $0x20,%esp
8010111b:	85 c0                	test   %eax,%eax
8010111d:	7f 99                	jg     801010b8 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
8010111f:	83 ec 0c             	sub    $0xc,%esp
80101122:	ff 76 10             	pushl  0x10(%esi)
80101125:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101128:	e8 b3 06 00 00       	call   801017e0 <iunlock>
      end_op();
8010112d:	e8 fe 1e 00 00       	call   80103030 <end_op>

      if(r < 0)
80101132:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101135:	83 c4 10             	add    $0x10,%esp
80101138:	85 c0                	test   %eax,%eax
8010113a:	74 98                	je     801010d4 <filewrite+0x64>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010113c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
8010113f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101144:	5b                   	pop    %ebx
80101145:	5e                   	pop    %esi
80101146:	5f                   	pop    %edi
80101147:	5d                   	pop    %ebp
80101148:	c3                   	ret    
80101149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
80101150:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101153:	75 e7                	jne    8010113c <filewrite+0xcc>
  }
  panic("filewrite");
}
80101155:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101158:	89 f8                	mov    %edi,%eax
8010115a:	5b                   	pop    %ebx
8010115b:	5e                   	pop    %esi
8010115c:	5f                   	pop    %edi
8010115d:	5d                   	pop    %ebp
8010115e:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
8010115f:	8b 46 0c             	mov    0xc(%esi),%eax
80101162:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
80101165:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101168:	5b                   	pop    %ebx
80101169:	5e                   	pop    %esi
8010116a:	5f                   	pop    %edi
8010116b:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
8010116c:	e9 8f 26 00 00       	jmp    80103800 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
80101171:	83 ec 0c             	sub    $0xc,%esp
80101174:	68 af 80 10 80       	push   $0x801080af
80101179:	e8 f2 f1 ff ff       	call   80100370 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
8010117e:	83 ec 0c             	sub    $0xc,%esp
80101181:	68 b5 80 10 80       	push   $0x801080b5
80101186:	e8 e5 f1 ff ff       	call   80100370 <panic>
8010118b:	66 90                	xchg   %ax,%ax
8010118d:	66 90                	xchg   %ax,%ax
8010118f:	90                   	nop

80101190 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101190:	55                   	push   %ebp
80101191:	89 e5                	mov    %esp,%ebp
80101193:	57                   	push   %edi
80101194:	56                   	push   %esi
80101195:	53                   	push   %ebx
80101196:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101199:	8b 0d c0 19 11 80    	mov    0x801119c0,%ecx
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010119f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801011a2:	85 c9                	test   %ecx,%ecx
801011a4:	0f 84 85 00 00 00    	je     8010122f <balloc+0x9f>
801011aa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011b1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011b4:	83 ec 08             	sub    $0x8,%esp
801011b7:	89 f0                	mov    %esi,%eax
801011b9:	c1 f8 0c             	sar    $0xc,%eax
801011bc:	03 05 d8 19 11 80    	add    0x801119d8,%eax
801011c2:	50                   	push   %eax
801011c3:	ff 75 d8             	pushl  -0x28(%ebp)
801011c6:	e8 05 ef ff ff       	call   801000d0 <bread>
801011cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801011ce:	a1 c0 19 11 80       	mov    0x801119c0,%eax
801011d3:	83 c4 10             	add    $0x10,%esp
801011d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011d9:	31 c0                	xor    %eax,%eax
801011db:	eb 2d                	jmp    8010120a <balloc+0x7a>
801011dd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801011e0:	89 c1                	mov    %eax,%ecx
801011e2:	ba 01 00 00 00       	mov    $0x1,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011e7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
801011ea:	83 e1 07             	and    $0x7,%ecx
801011ed:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011ef:	89 c1                	mov    %eax,%ecx
801011f1:	c1 f9 03             	sar    $0x3,%ecx
801011f4:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
801011f9:	85 d7                	test   %edx,%edi
801011fb:	74 43                	je     80101240 <balloc+0xb0>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011fd:	83 c0 01             	add    $0x1,%eax
80101200:	83 c6 01             	add    $0x1,%esi
80101203:	3d 00 10 00 00       	cmp    $0x1000,%eax
80101208:	74 05                	je     8010120f <balloc+0x7f>
8010120a:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010120d:	72 d1                	jb     801011e0 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
8010120f:	83 ec 0c             	sub    $0xc,%esp
80101212:	ff 75 e4             	pushl  -0x1c(%ebp)
80101215:	e8 c6 ef ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010121a:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101221:	83 c4 10             	add    $0x10,%esp
80101224:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101227:	39 05 c0 19 11 80    	cmp    %eax,0x801119c0
8010122d:	77 82                	ja     801011b1 <balloc+0x21>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010122f:	83 ec 0c             	sub    $0xc,%esp
80101232:	68 bf 80 10 80       	push   $0x801080bf
80101237:	e8 34 f1 ff ff       	call   80100370 <panic>
8010123c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101240:	09 fa                	or     %edi,%edx
80101242:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101245:	83 ec 0c             	sub    $0xc,%esp
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101248:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010124c:	57                   	push   %edi
8010124d:	e8 4e 1f 00 00       	call   801031a0 <log_write>
        brelse(bp);
80101252:	89 3c 24             	mov    %edi,(%esp)
80101255:	e8 86 ef ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
8010125a:	58                   	pop    %eax
8010125b:	5a                   	pop    %edx
8010125c:	56                   	push   %esi
8010125d:	ff 75 d8             	pushl  -0x28(%ebp)
80101260:	e8 6b ee ff ff       	call   801000d0 <bread>
80101265:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101267:	8d 40 5c             	lea    0x5c(%eax),%eax
8010126a:	83 c4 0c             	add    $0xc,%esp
8010126d:	68 00 02 00 00       	push   $0x200
80101272:	6a 00                	push   $0x0
80101274:	50                   	push   %eax
80101275:	e8 b6 3b 00 00       	call   80104e30 <memset>
  log_write(bp);
8010127a:	89 1c 24             	mov    %ebx,(%esp)
8010127d:	e8 1e 1f 00 00       	call   801031a0 <log_write>
  brelse(bp);
80101282:	89 1c 24             	mov    %ebx,(%esp)
80101285:	e8 56 ef ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
8010128a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010128d:	89 f0                	mov    %esi,%eax
8010128f:	5b                   	pop    %ebx
80101290:	5e                   	pop    %esi
80101291:	5f                   	pop    %edi
80101292:	5d                   	pop    %ebp
80101293:	c3                   	ret    
80101294:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010129a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801012a0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012a0:	55                   	push   %ebp
801012a1:	89 e5                	mov    %esp,%ebp
801012a3:	57                   	push   %edi
801012a4:	56                   	push   %esi
801012a5:	53                   	push   %ebx
801012a6:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801012a8:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012aa:	bb 14 1a 11 80       	mov    $0x80111a14,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012af:	83 ec 28             	sub    $0x28,%esp
801012b2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
801012b5:	68 e0 19 11 80       	push   $0x801119e0
801012ba:	e8 e1 39 00 00       	call   80104ca0 <acquire>
801012bf:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012c2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012c5:	eb 1b                	jmp    801012e2 <iget+0x42>
801012c7:	89 f6                	mov    %esi,%esi
801012c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012d0:	85 f6                	test   %esi,%esi
801012d2:	74 44                	je     80101318 <iget+0x78>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012d4:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012da:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
801012e0:	74 4e                	je     80101330 <iget+0x90>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012e2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012e5:	85 c9                	test   %ecx,%ecx
801012e7:	7e e7                	jle    801012d0 <iget+0x30>
801012e9:	39 3b                	cmp    %edi,(%ebx)
801012eb:	75 e3                	jne    801012d0 <iget+0x30>
801012ed:	39 53 04             	cmp    %edx,0x4(%ebx)
801012f0:	75 de                	jne    801012d0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
801012f2:	83 ec 0c             	sub    $0xc,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
801012f5:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
801012f8:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
801012fa:	68 e0 19 11 80       	push   $0x801119e0

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
801012ff:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101302:	e8 d9 3a 00 00       	call   80104de0 <release>
      return ip;
80101307:	83 c4 10             	add    $0x10,%esp
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
8010130a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010130d:	89 f0                	mov    %esi,%eax
8010130f:	5b                   	pop    %ebx
80101310:	5e                   	pop    %esi
80101311:	5f                   	pop    %edi
80101312:	5d                   	pop    %ebp
80101313:	c3                   	ret    
80101314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101318:	85 c9                	test   %ecx,%ecx
8010131a:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010131d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101323:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
80101329:	75 b7                	jne    801012e2 <iget+0x42>
8010132b:	90                   	nop
8010132c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101330:	85 f6                	test   %esi,%esi
80101332:	74 2d                	je     80101361 <iget+0xc1>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101334:	83 ec 0c             	sub    $0xc,%esp
  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
80101337:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101339:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010133c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101343:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010134a:	68 e0 19 11 80       	push   $0x801119e0
8010134f:	e8 8c 3a 00 00       	call   80104de0 <release>

  return ip;
80101354:	83 c4 10             	add    $0x10,%esp
}
80101357:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010135a:	89 f0                	mov    %esi,%eax
8010135c:	5b                   	pop    %ebx
8010135d:	5e                   	pop    %esi
8010135e:	5f                   	pop    %edi
8010135f:	5d                   	pop    %ebp
80101360:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
80101361:	83 ec 0c             	sub    $0xc,%esp
80101364:	68 d5 80 10 80       	push   $0x801080d5
80101369:	e8 02 f0 ff ff       	call   80100370 <panic>
8010136e:	66 90                	xchg   %ax,%ax

80101370 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101370:	55                   	push   %ebp
80101371:	89 e5                	mov    %esp,%ebp
80101373:	57                   	push   %edi
80101374:	56                   	push   %esi
80101375:	53                   	push   %ebx
80101376:	89 c6                	mov    %eax,%esi
80101378:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010137b:	83 fa 0b             	cmp    $0xb,%edx
8010137e:	77 18                	ja     80101398 <bmap+0x28>
80101380:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    if((addr = ip->addrs[bn]) == 0)
80101383:	8b 43 5c             	mov    0x5c(%ebx),%eax
80101386:	85 c0                	test   %eax,%eax
80101388:	74 76                	je     80101400 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010138a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010138d:	5b                   	pop    %ebx
8010138e:	5e                   	pop    %esi
8010138f:	5f                   	pop    %edi
80101390:	5d                   	pop    %ebp
80101391:	c3                   	ret    
80101392:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101398:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
8010139b:	83 fb 7f             	cmp    $0x7f,%ebx
8010139e:	0f 87 83 00 00 00    	ja     80101427 <bmap+0xb7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801013a4:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801013aa:	85 c0                	test   %eax,%eax
801013ac:	74 6a                	je     80101418 <bmap+0xa8>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801013ae:	83 ec 08             	sub    $0x8,%esp
801013b1:	50                   	push   %eax
801013b2:	ff 36                	pushl  (%esi)
801013b4:	e8 17 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801013b9:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801013bd:	83 c4 10             	add    $0x10,%esp

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801013c0:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801013c2:	8b 1a                	mov    (%edx),%ebx
801013c4:	85 db                	test   %ebx,%ebx
801013c6:	75 1d                	jne    801013e5 <bmap+0x75>
      a[bn] = addr = balloc(ip->dev);
801013c8:	8b 06                	mov    (%esi),%eax
801013ca:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013cd:	e8 be fd ff ff       	call   80101190 <balloc>
801013d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801013d5:	83 ec 0c             	sub    $0xc,%esp
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
801013d8:	89 c3                	mov    %eax,%ebx
801013da:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801013dc:	57                   	push   %edi
801013dd:	e8 be 1d 00 00       	call   801031a0 <log_write>
801013e2:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
801013e5:	83 ec 0c             	sub    $0xc,%esp
801013e8:	57                   	push   %edi
801013e9:	e8 f2 ed ff ff       	call   801001e0 <brelse>
801013ee:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801013f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801013f4:	89 d8                	mov    %ebx,%eax
    return addr;
  }

  panic("bmap: out of range");
}
801013f6:	5b                   	pop    %ebx
801013f7:	5e                   	pop    %esi
801013f8:	5f                   	pop    %edi
801013f9:	5d                   	pop    %ebp
801013fa:	c3                   	ret    
801013fb:	90                   	nop
801013fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101400:	8b 06                	mov    (%esi),%eax
80101402:	e8 89 fd ff ff       	call   80101190 <balloc>
80101407:	89 43 5c             	mov    %eax,0x5c(%ebx)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010140a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010140d:	5b                   	pop    %ebx
8010140e:	5e                   	pop    %esi
8010140f:	5f                   	pop    %edi
80101410:	5d                   	pop    %ebp
80101411:	c3                   	ret    
80101412:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101418:	8b 06                	mov    (%esi),%eax
8010141a:	e8 71 fd ff ff       	call   80101190 <balloc>
8010141f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101425:	eb 87                	jmp    801013ae <bmap+0x3e>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
80101427:	83 ec 0c             	sub    $0xc,%esp
8010142a:	68 e5 80 10 80       	push   $0x801080e5
8010142f:	e8 3c ef ff ff       	call   80100370 <panic>
80101434:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010143a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101440 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101440:	55                   	push   %ebp
80101441:	89 e5                	mov    %esp,%ebp
80101443:	56                   	push   %esi
80101444:	53                   	push   %ebx
80101445:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
80101448:	83 ec 08             	sub    $0x8,%esp
8010144b:	6a 01                	push   $0x1
8010144d:	ff 75 08             	pushl  0x8(%ebp)
80101450:	e8 7b ec ff ff       	call   801000d0 <bread>
80101455:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101457:	8d 40 5c             	lea    0x5c(%eax),%eax
8010145a:	83 c4 0c             	add    $0xc,%esp
8010145d:	6a 1c                	push   $0x1c
8010145f:	50                   	push   %eax
80101460:	56                   	push   %esi
80101461:	e8 7a 3a 00 00       	call   80104ee0 <memmove>
  brelse(bp);
80101466:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101469:	83 c4 10             	add    $0x10,%esp
}
8010146c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010146f:	5b                   	pop    %ebx
80101470:	5e                   	pop    %esi
80101471:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
80101472:	e9 69 ed ff ff       	jmp    801001e0 <brelse>
80101477:	89 f6                	mov    %esi,%esi
80101479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101480 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101480:	55                   	push   %ebp
80101481:	89 e5                	mov    %esp,%ebp
80101483:	56                   	push   %esi
80101484:	53                   	push   %ebx
80101485:	89 d3                	mov    %edx,%ebx
80101487:	89 c6                	mov    %eax,%esi
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
80101489:	83 ec 08             	sub    $0x8,%esp
8010148c:	68 c0 19 11 80       	push   $0x801119c0
80101491:	50                   	push   %eax
80101492:	e8 a9 ff ff ff       	call   80101440 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101497:	58                   	pop    %eax
80101498:	5a                   	pop    %edx
80101499:	89 da                	mov    %ebx,%edx
8010149b:	c1 ea 0c             	shr    $0xc,%edx
8010149e:	03 15 d8 19 11 80    	add    0x801119d8,%edx
801014a4:	52                   	push   %edx
801014a5:	56                   	push   %esi
801014a6:	e8 25 ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801014ab:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801014ad:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
801014b3:	ba 01 00 00 00       	mov    $0x1,%edx
801014b8:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801014bb:	c1 fb 03             	sar    $0x3,%ebx
801014be:	83 c4 10             	add    $0x10,%esp
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
801014c1:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801014c3:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801014c8:	85 d1                	test   %edx,%ecx
801014ca:	74 27                	je     801014f3 <bfree+0x73>
801014cc:	89 c6                	mov    %eax,%esi
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801014ce:	f7 d2                	not    %edx
801014d0:	89 c8                	mov    %ecx,%eax
  log_write(bp);
801014d2:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801014d5:	21 d0                	and    %edx,%eax
801014d7:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
801014db:	56                   	push   %esi
801014dc:	e8 bf 1c 00 00       	call   801031a0 <log_write>
  brelse(bp);
801014e1:	89 34 24             	mov    %esi,(%esp)
801014e4:	e8 f7 ec ff ff       	call   801001e0 <brelse>
}
801014e9:	83 c4 10             	add    $0x10,%esp
801014ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014ef:	5b                   	pop    %ebx
801014f0:	5e                   	pop    %esi
801014f1:	5d                   	pop    %ebp
801014f2:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
801014f3:	83 ec 0c             	sub    $0xc,%esp
801014f6:	68 f8 80 10 80       	push   $0x801080f8
801014fb:	e8 70 ee ff ff       	call   80100370 <panic>

80101500 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101500:	55                   	push   %ebp
80101501:	89 e5                	mov    %esp,%ebp
80101503:	53                   	push   %ebx
80101504:	bb 20 1a 11 80       	mov    $0x80111a20,%ebx
80101509:	83 ec 0c             	sub    $0xc,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010150c:	68 0b 81 10 80       	push   $0x8010810b
80101511:	68 e0 19 11 80       	push   $0x801119e0
80101516:	e8 85 36 00 00       	call   80104ba0 <initlock>
8010151b:	83 c4 10             	add    $0x10,%esp
8010151e:	66 90                	xchg   %ax,%ax
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101520:	83 ec 08             	sub    $0x8,%esp
80101523:	68 12 81 10 80       	push   $0x80108112
80101528:	53                   	push   %ebx
80101529:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010152f:	e8 5c 35 00 00       	call   80104a90 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
80101534:	83 c4 10             	add    $0x10,%esp
80101537:	81 fb 40 36 11 80    	cmp    $0x80113640,%ebx
8010153d:	75 e1                	jne    80101520 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
8010153f:	83 ec 08             	sub    $0x8,%esp
80101542:	68 c0 19 11 80       	push   $0x801119c0
80101547:	ff 75 08             	pushl  0x8(%ebp)
8010154a:	e8 f1 fe ff ff       	call   80101440 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010154f:	ff 35 d8 19 11 80    	pushl  0x801119d8
80101555:	ff 35 d4 19 11 80    	pushl  0x801119d4
8010155b:	ff 35 d0 19 11 80    	pushl  0x801119d0
80101561:	ff 35 cc 19 11 80    	pushl  0x801119cc
80101567:	ff 35 c8 19 11 80    	pushl  0x801119c8
8010156d:	ff 35 c4 19 11 80    	pushl  0x801119c4
80101573:	ff 35 c0 19 11 80    	pushl  0x801119c0
80101579:	68 bc 81 10 80       	push   $0x801081bc
8010157e:	e8 dd f0 ff ff       	call   80100660 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
80101583:	83 c4 30             	add    $0x30,%esp
80101586:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101589:	c9                   	leave  
8010158a:	c3                   	ret    
8010158b:	90                   	nop
8010158c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101590 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101590:	55                   	push   %ebp
80101591:	89 e5                	mov    %esp,%ebp
80101593:	57                   	push   %edi
80101594:	56                   	push   %esi
80101595:	53                   	push   %ebx
80101596:	83 ec 1c             	sub    $0x1c,%esp
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101599:	83 3d c8 19 11 80 01 	cmpl   $0x1,0x801119c8
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
801015a0:	8b 45 0c             	mov    0xc(%ebp),%eax
801015a3:	8b 75 08             	mov    0x8(%ebp),%esi
801015a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801015a9:	0f 86 91 00 00 00    	jbe    80101640 <ialloc+0xb0>
801015af:	bb 01 00 00 00       	mov    $0x1,%ebx
801015b4:	eb 21                	jmp    801015d7 <ialloc+0x47>
801015b6:	8d 76 00             	lea    0x0(%esi),%esi
801015b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
801015c0:	83 ec 0c             	sub    $0xc,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801015c3:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
801015c6:	57                   	push   %edi
801015c7:	e8 14 ec ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801015cc:	83 c4 10             	add    $0x10,%esp
801015cf:	39 1d c8 19 11 80    	cmp    %ebx,0x801119c8
801015d5:	76 69                	jbe    80101640 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801015d7:	89 d8                	mov    %ebx,%eax
801015d9:	83 ec 08             	sub    $0x8,%esp
801015dc:	c1 e8 03             	shr    $0x3,%eax
801015df:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801015e5:	50                   	push   %eax
801015e6:	56                   	push   %esi
801015e7:	e8 e4 ea ff ff       	call   801000d0 <bread>
801015ec:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
801015ee:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
801015f0:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
801015f3:	83 e0 07             	and    $0x7,%eax
801015f6:	c1 e0 06             	shl    $0x6,%eax
801015f9:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801015fd:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101601:	75 bd                	jne    801015c0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101603:	83 ec 04             	sub    $0x4,%esp
80101606:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101609:	6a 40                	push   $0x40
8010160b:	6a 00                	push   $0x0
8010160d:	51                   	push   %ecx
8010160e:	e8 1d 38 00 00       	call   80104e30 <memset>
      dip->type = type;
80101613:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101617:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010161a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010161d:	89 3c 24             	mov    %edi,(%esp)
80101620:	e8 7b 1b 00 00       	call   801031a0 <log_write>
      brelse(bp);
80101625:	89 3c 24             	mov    %edi,(%esp)
80101628:	e8 b3 eb ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010162d:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101630:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
80101633:	89 da                	mov    %ebx,%edx
80101635:	89 f0                	mov    %esi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101637:	5b                   	pop    %ebx
80101638:	5e                   	pop    %esi
80101639:	5f                   	pop    %edi
8010163a:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
8010163b:	e9 60 fc ff ff       	jmp    801012a0 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101640:	83 ec 0c             	sub    $0xc,%esp
80101643:	68 18 81 10 80       	push   $0x80108118
80101648:	e8 23 ed ff ff       	call   80100370 <panic>
8010164d:	8d 76 00             	lea    0x0(%esi),%esi

80101650 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
80101650:	55                   	push   %ebp
80101651:	89 e5                	mov    %esp,%ebp
80101653:	56                   	push   %esi
80101654:	53                   	push   %ebx
80101655:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101658:	83 ec 08             	sub    $0x8,%esp
8010165b:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010165e:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101661:	c1 e8 03             	shr    $0x3,%eax
80101664:	03 05 d4 19 11 80    	add    0x801119d4,%eax
8010166a:	50                   	push   %eax
8010166b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010166e:	e8 5d ea ff ff       	call   801000d0 <bread>
80101673:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101675:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101678:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010167c:	83 c4 0c             	add    $0xc,%esp
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010167f:	83 e0 07             	and    $0x7,%eax
80101682:	c1 e0 06             	shl    $0x6,%eax
80101685:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101689:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010168c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101690:	83 c0 0c             	add    $0xc,%eax
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
80101693:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101697:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010169b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010169f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801016a3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801016a7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801016aa:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016ad:	6a 34                	push   $0x34
801016af:	53                   	push   %ebx
801016b0:	50                   	push   %eax
801016b1:	e8 2a 38 00 00       	call   80104ee0 <memmove>
  log_write(bp);
801016b6:	89 34 24             	mov    %esi,(%esp)
801016b9:	e8 e2 1a 00 00       	call   801031a0 <log_write>
  brelse(bp);
801016be:	89 75 08             	mov    %esi,0x8(%ebp)
801016c1:	83 c4 10             	add    $0x10,%esp
}
801016c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016c7:	5b                   	pop    %ebx
801016c8:	5e                   	pop    %esi
801016c9:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
801016ca:	e9 11 eb ff ff       	jmp    801001e0 <brelse>
801016cf:	90                   	nop

801016d0 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801016d0:	55                   	push   %ebp
801016d1:	89 e5                	mov    %esp,%ebp
801016d3:	53                   	push   %ebx
801016d4:	83 ec 10             	sub    $0x10,%esp
801016d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801016da:	68 e0 19 11 80       	push   $0x801119e0
801016df:	e8 bc 35 00 00       	call   80104ca0 <acquire>
  ip->ref++;
801016e4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801016e8:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801016ef:	e8 ec 36 00 00       	call   80104de0 <release>
  return ip;
}
801016f4:	89 d8                	mov    %ebx,%eax
801016f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801016f9:	c9                   	leave  
801016fa:	c3                   	ret    
801016fb:	90                   	nop
801016fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101700 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101700:	55                   	push   %ebp
80101701:	89 e5                	mov    %esp,%ebp
80101703:	56                   	push   %esi
80101704:	53                   	push   %ebx
80101705:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101708:	85 db                	test   %ebx,%ebx
8010170a:	0f 84 b7 00 00 00    	je     801017c7 <ilock+0xc7>
80101710:	8b 53 08             	mov    0x8(%ebx),%edx
80101713:	85 d2                	test   %edx,%edx
80101715:	0f 8e ac 00 00 00    	jle    801017c7 <ilock+0xc7>
    panic("ilock");

  acquiresleep(&ip->lock);
8010171b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010171e:	83 ec 0c             	sub    $0xc,%esp
80101721:	50                   	push   %eax
80101722:	e8 a9 33 00 00       	call   80104ad0 <acquiresleep>

  if(ip->valid == 0){
80101727:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010172a:	83 c4 10             	add    $0x10,%esp
8010172d:	85 c0                	test   %eax,%eax
8010172f:	74 0f                	je     80101740 <ilock+0x40>
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
80101731:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101734:	5b                   	pop    %ebx
80101735:	5e                   	pop    %esi
80101736:	5d                   	pop    %ebp
80101737:	c3                   	ret    
80101738:	90                   	nop
80101739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101740:	8b 43 04             	mov    0x4(%ebx),%eax
80101743:	83 ec 08             	sub    $0x8,%esp
80101746:	c1 e8 03             	shr    $0x3,%eax
80101749:	03 05 d4 19 11 80    	add    0x801119d4,%eax
8010174f:	50                   	push   %eax
80101750:	ff 33                	pushl  (%ebx)
80101752:	e8 79 e9 ff ff       	call   801000d0 <bread>
80101757:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101759:	8b 43 04             	mov    0x4(%ebx),%eax
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010175c:	83 c4 0c             	add    $0xc,%esp

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010175f:	83 e0 07             	and    $0x7,%eax
80101762:	c1 e0 06             	shl    $0x6,%eax
80101765:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101769:	0f b7 10             	movzwl (%eax),%edx
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010176c:	83 c0 0c             	add    $0xc,%eax
  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
8010176f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101773:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101777:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010177b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010177f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101783:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101787:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010178b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010178e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101791:	6a 34                	push   $0x34
80101793:	50                   	push   %eax
80101794:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101797:	50                   	push   %eax
80101798:	e8 43 37 00 00       	call   80104ee0 <memmove>
    brelse(bp);
8010179d:	89 34 24             	mov    %esi,(%esp)
801017a0:	e8 3b ea ff ff       	call   801001e0 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
801017a5:	83 c4 10             	add    $0x10,%esp
801017a8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
801017ad:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801017b4:	0f 85 77 ff ff ff    	jne    80101731 <ilock+0x31>
      panic("ilock: no type");
801017ba:	83 ec 0c             	sub    $0xc,%esp
801017bd:	68 30 81 10 80       	push   $0x80108130
801017c2:	e8 a9 eb ff ff       	call   80100370 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
801017c7:	83 ec 0c             	sub    $0xc,%esp
801017ca:	68 2a 81 10 80       	push   $0x8010812a
801017cf:	e8 9c eb ff ff       	call   80100370 <panic>
801017d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801017da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801017e0 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
801017e0:	55                   	push   %ebp
801017e1:	89 e5                	mov    %esp,%ebp
801017e3:	56                   	push   %esi
801017e4:	53                   	push   %ebx
801017e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801017e8:	85 db                	test   %ebx,%ebx
801017ea:	74 28                	je     80101814 <iunlock+0x34>
801017ec:	8d 73 0c             	lea    0xc(%ebx),%esi
801017ef:	83 ec 0c             	sub    $0xc,%esp
801017f2:	56                   	push   %esi
801017f3:	e8 78 33 00 00       	call   80104b70 <holdingsleep>
801017f8:	83 c4 10             	add    $0x10,%esp
801017fb:	85 c0                	test   %eax,%eax
801017fd:	74 15                	je     80101814 <iunlock+0x34>
801017ff:	8b 43 08             	mov    0x8(%ebx),%eax
80101802:	85 c0                	test   %eax,%eax
80101804:	7e 0e                	jle    80101814 <iunlock+0x34>
    panic("iunlock");

  releasesleep(&ip->lock);
80101806:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101809:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010180c:	5b                   	pop    %ebx
8010180d:	5e                   	pop    %esi
8010180e:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
8010180f:	e9 1c 33 00 00       	jmp    80104b30 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
80101814:	83 ec 0c             	sub    $0xc,%esp
80101817:	68 3f 81 10 80       	push   $0x8010813f
8010181c:	e8 4f eb ff ff       	call   80100370 <panic>
80101821:	eb 0d                	jmp    80101830 <iput>
80101823:	90                   	nop
80101824:	90                   	nop
80101825:	90                   	nop
80101826:	90                   	nop
80101827:	90                   	nop
80101828:	90                   	nop
80101829:	90                   	nop
8010182a:	90                   	nop
8010182b:	90                   	nop
8010182c:	90                   	nop
8010182d:	90                   	nop
8010182e:	90                   	nop
8010182f:	90                   	nop

80101830 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101830:	55                   	push   %ebp
80101831:	89 e5                	mov    %esp,%ebp
80101833:	57                   	push   %edi
80101834:	56                   	push   %esi
80101835:	53                   	push   %ebx
80101836:	83 ec 28             	sub    $0x28,%esp
80101839:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
8010183c:	8d 7e 0c             	lea    0xc(%esi),%edi
8010183f:	57                   	push   %edi
80101840:	e8 8b 32 00 00       	call   80104ad0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101845:	8b 56 4c             	mov    0x4c(%esi),%edx
80101848:	83 c4 10             	add    $0x10,%esp
8010184b:	85 d2                	test   %edx,%edx
8010184d:	74 07                	je     80101856 <iput+0x26>
8010184f:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
80101854:	74 32                	je     80101888 <iput+0x58>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
80101856:	83 ec 0c             	sub    $0xc,%esp
80101859:	57                   	push   %edi
8010185a:	e8 d1 32 00 00       	call   80104b30 <releasesleep>

  acquire(&icache.lock);
8010185f:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101866:	e8 35 34 00 00       	call   80104ca0 <acquire>
  ip->ref--;
8010186b:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
8010186f:	83 c4 10             	add    $0x10,%esp
80101872:	c7 45 08 e0 19 11 80 	movl   $0x801119e0,0x8(%ebp)
}
80101879:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010187c:	5b                   	pop    %ebx
8010187d:	5e                   	pop    %esi
8010187e:	5f                   	pop    %edi
8010187f:	5d                   	pop    %ebp
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
80101880:	e9 5b 35 00 00       	jmp    80104de0 <release>
80101885:	8d 76 00             	lea    0x0(%esi),%esi
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
80101888:	83 ec 0c             	sub    $0xc,%esp
8010188b:	68 e0 19 11 80       	push   $0x801119e0
80101890:	e8 0b 34 00 00       	call   80104ca0 <acquire>
    int r = ip->ref;
80101895:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
80101898:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
8010189f:	e8 3c 35 00 00       	call   80104de0 <release>
    if(r == 1){
801018a4:	83 c4 10             	add    $0x10,%esp
801018a7:	83 fb 01             	cmp    $0x1,%ebx
801018aa:	75 aa                	jne    80101856 <iput+0x26>
801018ac:	8d 8e 8c 00 00 00    	lea    0x8c(%esi),%ecx
801018b2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801018b5:	8d 5e 5c             	lea    0x5c(%esi),%ebx
801018b8:	89 cf                	mov    %ecx,%edi
801018ba:	eb 0b                	jmp    801018c7 <iput+0x97>
801018bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018c0:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801018c3:	39 fb                	cmp    %edi,%ebx
801018c5:	74 19                	je     801018e0 <iput+0xb0>
    if(ip->addrs[i]){
801018c7:	8b 13                	mov    (%ebx),%edx
801018c9:	85 d2                	test   %edx,%edx
801018cb:	74 f3                	je     801018c0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
801018cd:	8b 06                	mov    (%esi),%eax
801018cf:	e8 ac fb ff ff       	call   80101480 <bfree>
      ip->addrs[i] = 0;
801018d4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801018da:	eb e4                	jmp    801018c0 <iput+0x90>
801018dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801018e0:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
801018e6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801018e9:	85 c0                	test   %eax,%eax
801018eb:	75 33                	jne    80101920 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801018ed:	83 ec 0c             	sub    $0xc,%esp
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
801018f0:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
801018f7:	56                   	push   %esi
801018f8:	e8 53 fd ff ff       	call   80101650 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
801018fd:	31 c0                	xor    %eax,%eax
801018ff:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
80101903:	89 34 24             	mov    %esi,(%esp)
80101906:	e8 45 fd ff ff       	call   80101650 <iupdate>
      ip->valid = 0;
8010190b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101912:	83 c4 10             	add    $0x10,%esp
80101915:	e9 3c ff ff ff       	jmp    80101856 <iput+0x26>
8010191a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101920:	83 ec 08             	sub    $0x8,%esp
80101923:	50                   	push   %eax
80101924:	ff 36                	pushl  (%esi)
80101926:	e8 a5 e7 ff ff       	call   801000d0 <bread>
8010192b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101931:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101934:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101937:	8d 58 5c             	lea    0x5c(%eax),%ebx
8010193a:	83 c4 10             	add    $0x10,%esp
8010193d:	89 cf                	mov    %ecx,%edi
8010193f:	eb 0e                	jmp    8010194f <iput+0x11f>
80101941:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101948:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
8010194b:	39 fb                	cmp    %edi,%ebx
8010194d:	74 0f                	je     8010195e <iput+0x12e>
      if(a[j])
8010194f:	8b 13                	mov    (%ebx),%edx
80101951:	85 d2                	test   %edx,%edx
80101953:	74 f3                	je     80101948 <iput+0x118>
        bfree(ip->dev, a[j]);
80101955:	8b 06                	mov    (%esi),%eax
80101957:	e8 24 fb ff ff       	call   80101480 <bfree>
8010195c:	eb ea                	jmp    80101948 <iput+0x118>
    }
    brelse(bp);
8010195e:	83 ec 0c             	sub    $0xc,%esp
80101961:	ff 75 e4             	pushl  -0x1c(%ebp)
80101964:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101967:	e8 74 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010196c:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101972:	8b 06                	mov    (%esi),%eax
80101974:	e8 07 fb ff ff       	call   80101480 <bfree>
    ip->addrs[NDIRECT] = 0;
80101979:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101980:	00 00 00 
80101983:	83 c4 10             	add    $0x10,%esp
80101986:	e9 62 ff ff ff       	jmp    801018ed <iput+0xbd>
8010198b:	90                   	nop
8010198c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101990 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101990:	55                   	push   %ebp
80101991:	89 e5                	mov    %esp,%ebp
80101993:	53                   	push   %ebx
80101994:	83 ec 10             	sub    $0x10,%esp
80101997:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010199a:	53                   	push   %ebx
8010199b:	e8 40 fe ff ff       	call   801017e0 <iunlock>
  iput(ip);
801019a0:	89 5d 08             	mov    %ebx,0x8(%ebp)
801019a3:	83 c4 10             	add    $0x10,%esp
}
801019a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801019a9:	c9                   	leave  
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
801019aa:	e9 81 fe ff ff       	jmp    80101830 <iput>
801019af:	90                   	nop

801019b0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
801019b0:	55                   	push   %ebp
801019b1:	89 e5                	mov    %esp,%ebp
801019b3:	8b 55 08             	mov    0x8(%ebp),%edx
801019b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801019b9:	8b 0a                	mov    (%edx),%ecx
801019bb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801019be:	8b 4a 04             	mov    0x4(%edx),%ecx
801019c1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801019c4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
801019c8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801019cb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
801019cf:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801019d3:	8b 52 58             	mov    0x58(%edx),%edx
801019d6:	89 50 10             	mov    %edx,0x10(%eax)
}
801019d9:	5d                   	pop    %ebp
801019da:	c3                   	ret    
801019db:	90                   	nop
801019dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801019e0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801019e0:	55                   	push   %ebp
801019e1:	89 e5                	mov    %esp,%ebp
801019e3:	57                   	push   %edi
801019e4:	56                   	push   %esi
801019e5:	53                   	push   %ebx
801019e6:	83 ec 1c             	sub    $0x1c,%esp
801019e9:	8b 45 08             	mov    0x8(%ebp),%eax
801019ec:	8b 7d 0c             	mov    0xc(%ebp),%edi
801019ef:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801019f2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801019f7:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019fa:	8b 7d 14             	mov    0x14(%ebp),%edi
801019fd:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a00:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a03:	0f 84 a7 00 00 00    	je     80101ab0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a09:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a0c:	8b 40 58             	mov    0x58(%eax),%eax
80101a0f:	39 f0                	cmp    %esi,%eax
80101a11:	0f 82 c1 00 00 00    	jb     80101ad8 <readi+0xf8>
80101a17:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a1a:	89 fa                	mov    %edi,%edx
80101a1c:	01 f2                	add    %esi,%edx
80101a1e:	0f 82 b4 00 00 00    	jb     80101ad8 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101a24:	89 c1                	mov    %eax,%ecx
80101a26:	29 f1                	sub    %esi,%ecx
80101a28:	39 d0                	cmp    %edx,%eax
80101a2a:	0f 43 cf             	cmovae %edi,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a2d:	31 ff                	xor    %edi,%edi
80101a2f:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101a31:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a34:	74 6d                	je     80101aa3 <readi+0xc3>
80101a36:	8d 76 00             	lea    0x0(%esi),%esi
80101a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a40:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101a43:	89 f2                	mov    %esi,%edx
80101a45:	c1 ea 09             	shr    $0x9,%edx
80101a48:	89 d8                	mov    %ebx,%eax
80101a4a:	e8 21 f9 ff ff       	call   80101370 <bmap>
80101a4f:	83 ec 08             	sub    $0x8,%esp
80101a52:	50                   	push   %eax
80101a53:	ff 33                	pushl  (%ebx)
    m = min(n - tot, BSIZE - off%BSIZE);
80101a55:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a5a:	e8 71 e6 ff ff       	call   801000d0 <bread>
80101a5f:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101a64:	89 f1                	mov    %esi,%ecx
80101a66:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101a6c:	83 c4 0c             	add    $0xc,%esp
    memmove(dst, bp->data + off%BSIZE, m);
80101a6f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101a72:	29 cb                	sub    %ecx,%ebx
80101a74:	29 f8                	sub    %edi,%eax
80101a76:	39 c3                	cmp    %eax,%ebx
80101a78:	0f 47 d8             	cmova  %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a7b:	8d 44 0a 5c          	lea    0x5c(%edx,%ecx,1),%eax
80101a7f:	53                   	push   %ebx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a80:	01 df                	add    %ebx,%edi
80101a82:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
80101a84:	50                   	push   %eax
80101a85:	ff 75 e0             	pushl  -0x20(%ebp)
80101a88:	e8 53 34 00 00       	call   80104ee0 <memmove>
    brelse(bp);
80101a8d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a90:	89 14 24             	mov    %edx,(%esp)
80101a93:	e8 48 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a98:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a9b:	83 c4 10             	add    $0x10,%esp
80101a9e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101aa1:	77 9d                	ja     80101a40 <readi+0x60>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101aa3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101aa6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101aa9:	5b                   	pop    %ebx
80101aaa:	5e                   	pop    %esi
80101aab:	5f                   	pop    %edi
80101aac:	5d                   	pop    %ebp
80101aad:	c3                   	ret    
80101aae:	66 90                	xchg   %ax,%ax
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101ab0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101ab4:	66 83 f8 09          	cmp    $0x9,%ax
80101ab8:	77 1e                	ja     80101ad8 <readi+0xf8>
80101aba:	8b 04 c5 60 19 11 80 	mov    -0x7feee6a0(,%eax,8),%eax
80101ac1:	85 c0                	test   %eax,%eax
80101ac3:	74 13                	je     80101ad8 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101ac5:	89 7d 10             	mov    %edi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101ac8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101acb:	5b                   	pop    %ebx
80101acc:	5e                   	pop    %esi
80101acd:	5f                   	pop    %edi
80101ace:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101acf:	ff e0                	jmp    *%eax
80101ad1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101ad8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101add:	eb c7                	jmp    80101aa6 <readi+0xc6>
80101adf:	90                   	nop

80101ae0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ae0:	55                   	push   %ebp
80101ae1:	89 e5                	mov    %esp,%ebp
80101ae3:	57                   	push   %edi
80101ae4:	56                   	push   %esi
80101ae5:	53                   	push   %ebx
80101ae6:	83 ec 1c             	sub    $0x1c,%esp
80101ae9:	8b 45 08             	mov    0x8(%ebp),%eax
80101aec:	8b 75 0c             	mov    0xc(%ebp),%esi
80101aef:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101af2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101af7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101afa:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101afd:	8b 75 10             	mov    0x10(%ebp),%esi
80101b00:	89 7d e0             	mov    %edi,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b03:	0f 84 b7 00 00 00    	je     80101bc0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b09:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b0c:	39 70 58             	cmp    %esi,0x58(%eax)
80101b0f:	0f 82 eb 00 00 00    	jb     80101c00 <writei+0x120>
80101b15:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b18:	89 f8                	mov    %edi,%eax
80101b1a:	01 f0                	add    %esi,%eax
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b1c:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101b21:	0f 87 d9 00 00 00    	ja     80101c00 <writei+0x120>
80101b27:	39 c6                	cmp    %eax,%esi
80101b29:	0f 87 d1 00 00 00    	ja     80101c00 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b2f:	85 ff                	test   %edi,%edi
80101b31:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101b38:	74 78                	je     80101bb2 <writei+0xd2>
80101b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b40:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101b43:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b45:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b4a:	c1 ea 09             	shr    $0x9,%edx
80101b4d:	89 f8                	mov    %edi,%eax
80101b4f:	e8 1c f8 ff ff       	call   80101370 <bmap>
80101b54:	83 ec 08             	sub    $0x8,%esp
80101b57:	50                   	push   %eax
80101b58:	ff 37                	pushl  (%edi)
80101b5a:	e8 71 e5 ff ff       	call   801000d0 <bread>
80101b5f:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b61:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101b64:	2b 45 e4             	sub    -0x1c(%ebp),%eax
80101b67:	89 f1                	mov    %esi,%ecx
80101b69:	83 c4 0c             	add    $0xc,%esp
80101b6c:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101b72:	29 cb                	sub    %ecx,%ebx
80101b74:	39 c3                	cmp    %eax,%ebx
80101b76:	0f 47 d8             	cmova  %eax,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b79:	8d 44 0f 5c          	lea    0x5c(%edi,%ecx,1),%eax
80101b7d:	53                   	push   %ebx
80101b7e:	ff 75 dc             	pushl  -0x24(%ebp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b81:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101b83:	50                   	push   %eax
80101b84:	e8 57 33 00 00       	call   80104ee0 <memmove>
    log_write(bp);
80101b89:	89 3c 24             	mov    %edi,(%esp)
80101b8c:	e8 0f 16 00 00       	call   801031a0 <log_write>
    brelse(bp);
80101b91:	89 3c 24             	mov    %edi,(%esp)
80101b94:	e8 47 e6 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b99:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b9c:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b9f:	83 c4 10             	add    $0x10,%esp
80101ba2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101ba5:	39 55 e0             	cmp    %edx,-0x20(%ebp)
80101ba8:	77 96                	ja     80101b40 <writei+0x60>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101baa:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bad:	3b 70 58             	cmp    0x58(%eax),%esi
80101bb0:	77 36                	ja     80101be8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101bb2:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101bb5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bb8:	5b                   	pop    %ebx
80101bb9:	5e                   	pop    %esi
80101bba:	5f                   	pop    %edi
80101bbb:	5d                   	pop    %ebp
80101bbc:	c3                   	ret    
80101bbd:	8d 76 00             	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101bc0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101bc4:	66 83 f8 09          	cmp    $0x9,%ax
80101bc8:	77 36                	ja     80101c00 <writei+0x120>
80101bca:	8b 04 c5 64 19 11 80 	mov    -0x7feee69c(,%eax,8),%eax
80101bd1:	85 c0                	test   %eax,%eax
80101bd3:	74 2b                	je     80101c00 <writei+0x120>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101bd5:	89 7d 10             	mov    %edi,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101bd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bdb:	5b                   	pop    %ebx
80101bdc:	5e                   	pop    %esi
80101bdd:	5f                   	pop    %edi
80101bde:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101bdf:	ff e0                	jmp    *%eax
80101be1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101be8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101beb:	83 ec 0c             	sub    $0xc,%esp
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101bee:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101bf1:	50                   	push   %eax
80101bf2:	e8 59 fa ff ff       	call   80101650 <iupdate>
80101bf7:	83 c4 10             	add    $0x10,%esp
80101bfa:	eb b6                	jmp    80101bb2 <writei+0xd2>
80101bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101c00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c05:	eb ae                	jmp    80101bb5 <writei+0xd5>
80101c07:	89 f6                	mov    %esi,%esi
80101c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c10 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c10:	55                   	push   %ebp
80101c11:	89 e5                	mov    %esp,%ebp
80101c13:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c16:	6a 0e                	push   $0xe
80101c18:	ff 75 0c             	pushl  0xc(%ebp)
80101c1b:	ff 75 08             	pushl  0x8(%ebp)
80101c1e:	e8 3d 33 00 00       	call   80104f60 <strncmp>
}
80101c23:	c9                   	leave  
80101c24:	c3                   	ret    
80101c25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c30 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101c30:	55                   	push   %ebp
80101c31:	89 e5                	mov    %esp,%ebp
80101c33:	57                   	push   %edi
80101c34:	56                   	push   %esi
80101c35:	53                   	push   %ebx
80101c36:	83 ec 1c             	sub    $0x1c,%esp
80101c39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101c3c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101c41:	0f 85 80 00 00 00    	jne    80101cc7 <dirlookup+0x97>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101c47:	8b 53 58             	mov    0x58(%ebx),%edx
80101c4a:	31 ff                	xor    %edi,%edi
80101c4c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c4f:	85 d2                	test   %edx,%edx
80101c51:	75 0d                	jne    80101c60 <dirlookup+0x30>
80101c53:	eb 5b                	jmp    80101cb0 <dirlookup+0x80>
80101c55:	8d 76 00             	lea    0x0(%esi),%esi
80101c58:	83 c7 10             	add    $0x10,%edi
80101c5b:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101c5e:	76 50                	jbe    80101cb0 <dirlookup+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c60:	6a 10                	push   $0x10
80101c62:	57                   	push   %edi
80101c63:	56                   	push   %esi
80101c64:	53                   	push   %ebx
80101c65:	e8 76 fd ff ff       	call   801019e0 <readi>
80101c6a:	83 c4 10             	add    $0x10,%esp
80101c6d:	83 f8 10             	cmp    $0x10,%eax
80101c70:	75 48                	jne    80101cba <dirlookup+0x8a>
      panic("dirlookup read");
    if(de.inum == 0)
80101c72:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c77:	74 df                	je     80101c58 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101c79:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c7c:	83 ec 04             	sub    $0x4,%esp
80101c7f:	6a 0e                	push   $0xe
80101c81:	50                   	push   %eax
80101c82:	ff 75 0c             	pushl  0xc(%ebp)
80101c85:	e8 d6 32 00 00       	call   80104f60 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101c8a:	83 c4 10             	add    $0x10,%esp
80101c8d:	85 c0                	test   %eax,%eax
80101c8f:	75 c7                	jne    80101c58 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c91:	8b 45 10             	mov    0x10(%ebp),%eax
80101c94:	85 c0                	test   %eax,%eax
80101c96:	74 05                	je     80101c9d <dirlookup+0x6d>
        *poff = off;
80101c98:	8b 45 10             	mov    0x10(%ebp),%eax
80101c9b:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
      return iget(dp->dev, inum);
80101c9d:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101ca1:	8b 03                	mov    (%ebx),%eax
80101ca3:	e8 f8 f5 ff ff       	call   801012a0 <iget>
    }
  }

  return 0;
}
80101ca8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cab:	5b                   	pop    %ebx
80101cac:	5e                   	pop    %esi
80101cad:	5f                   	pop    %edi
80101cae:	5d                   	pop    %ebp
80101caf:	c3                   	ret    
80101cb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101cb3:	31 c0                	xor    %eax,%eax
}
80101cb5:	5b                   	pop    %ebx
80101cb6:	5e                   	pop    %esi
80101cb7:	5f                   	pop    %edi
80101cb8:	5d                   	pop    %ebp
80101cb9:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
80101cba:	83 ec 0c             	sub    $0xc,%esp
80101cbd:	68 59 81 10 80       	push   $0x80108159
80101cc2:	e8 a9 e6 ff ff       	call   80100370 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101cc7:	83 ec 0c             	sub    $0xc,%esp
80101cca:	68 47 81 10 80       	push   $0x80108147
80101ccf:	e8 9c e6 ff ff       	call   80100370 <panic>
80101cd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101cda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101ce0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101ce0:	55                   	push   %ebp
80101ce1:	89 e5                	mov    %esp,%ebp
80101ce3:	57                   	push   %edi
80101ce4:	56                   	push   %esi
80101ce5:	53                   	push   %ebx
80101ce6:	89 cf                	mov    %ecx,%edi
80101ce8:	89 c3                	mov    %eax,%ebx
80101cea:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101ced:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101cf0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101cf3:	0f 84 53 01 00 00    	je     80101e4c <namex+0x16c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101cf9:	e8 82 1f 00 00       	call   80103c80 <myproc>
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101cfe:	83 ec 0c             	sub    $0xc,%esp
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d01:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101d04:	68 e0 19 11 80       	push   $0x801119e0
80101d09:	e8 92 2f 00 00       	call   80104ca0 <acquire>
  ip->ref++;
80101d0e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101d12:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101d19:	e8 c2 30 00 00       	call   80104de0 <release>
80101d1e:	83 c4 10             	add    $0x10,%esp
80101d21:	eb 08                	jmp    80101d2b <namex+0x4b>
80101d23:	90                   	nop
80101d24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101d28:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101d2b:	0f b6 03             	movzbl (%ebx),%eax
80101d2e:	3c 2f                	cmp    $0x2f,%al
80101d30:	74 f6                	je     80101d28 <namex+0x48>
    path++;
  if(*path == 0)
80101d32:	84 c0                	test   %al,%al
80101d34:	0f 84 e3 00 00 00    	je     80101e1d <namex+0x13d>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d3a:	0f b6 03             	movzbl (%ebx),%eax
80101d3d:	89 da                	mov    %ebx,%edx
80101d3f:	84 c0                	test   %al,%al
80101d41:	0f 84 ac 00 00 00    	je     80101df3 <namex+0x113>
80101d47:	3c 2f                	cmp    $0x2f,%al
80101d49:	75 09                	jne    80101d54 <namex+0x74>
80101d4b:	e9 a3 00 00 00       	jmp    80101df3 <namex+0x113>
80101d50:	84 c0                	test   %al,%al
80101d52:	74 0a                	je     80101d5e <namex+0x7e>
    path++;
80101d54:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d57:	0f b6 02             	movzbl (%edx),%eax
80101d5a:	3c 2f                	cmp    $0x2f,%al
80101d5c:	75 f2                	jne    80101d50 <namex+0x70>
80101d5e:	89 d1                	mov    %edx,%ecx
80101d60:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101d62:	83 f9 0d             	cmp    $0xd,%ecx
80101d65:	0f 8e 8d 00 00 00    	jle    80101df8 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101d6b:	83 ec 04             	sub    $0x4,%esp
80101d6e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d71:	6a 0e                	push   $0xe
80101d73:	53                   	push   %ebx
80101d74:	57                   	push   %edi
80101d75:	e8 66 31 00 00       	call   80104ee0 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101d7a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
80101d7d:	83 c4 10             	add    $0x10,%esp
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101d80:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d82:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d85:	75 11                	jne    80101d98 <namex+0xb8>
80101d87:	89 f6                	mov    %esi,%esi
80101d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d90:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d93:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d96:	74 f8                	je     80101d90 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d98:	83 ec 0c             	sub    $0xc,%esp
80101d9b:	56                   	push   %esi
80101d9c:	e8 5f f9 ff ff       	call   80101700 <ilock>
    if(ip->type != T_DIR){
80101da1:	83 c4 10             	add    $0x10,%esp
80101da4:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101da9:	0f 85 7f 00 00 00    	jne    80101e2e <namex+0x14e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101daf:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101db2:	85 d2                	test   %edx,%edx
80101db4:	74 09                	je     80101dbf <namex+0xdf>
80101db6:	80 3b 00             	cmpb   $0x0,(%ebx)
80101db9:	0f 84 a3 00 00 00    	je     80101e62 <namex+0x182>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101dbf:	83 ec 04             	sub    $0x4,%esp
80101dc2:	6a 00                	push   $0x0
80101dc4:	57                   	push   %edi
80101dc5:	56                   	push   %esi
80101dc6:	e8 65 fe ff ff       	call   80101c30 <dirlookup>
80101dcb:	83 c4 10             	add    $0x10,%esp
80101dce:	85 c0                	test   %eax,%eax
80101dd0:	74 5c                	je     80101e2e <namex+0x14e>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101dd2:	83 ec 0c             	sub    $0xc,%esp
80101dd5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101dd8:	56                   	push   %esi
80101dd9:	e8 02 fa ff ff       	call   801017e0 <iunlock>
  iput(ip);
80101dde:	89 34 24             	mov    %esi,(%esp)
80101de1:	e8 4a fa ff ff       	call   80101830 <iput>
80101de6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101de9:	83 c4 10             	add    $0x10,%esp
80101dec:	89 c6                	mov    %eax,%esi
80101dee:	e9 38 ff ff ff       	jmp    80101d2b <namex+0x4b>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101df3:	31 c9                	xor    %ecx,%ecx
80101df5:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101df8:	83 ec 04             	sub    $0x4,%esp
80101dfb:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101dfe:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101e01:	51                   	push   %ecx
80101e02:	53                   	push   %ebx
80101e03:	57                   	push   %edi
80101e04:	e8 d7 30 00 00       	call   80104ee0 <memmove>
    name[len] = 0;
80101e09:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101e0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101e0f:	83 c4 10             	add    $0x10,%esp
80101e12:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101e16:	89 d3                	mov    %edx,%ebx
80101e18:	e9 65 ff ff ff       	jmp    80101d82 <namex+0xa2>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101e1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101e20:	85 c0                	test   %eax,%eax
80101e22:	75 54                	jne    80101e78 <namex+0x198>
80101e24:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101e26:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e29:	5b                   	pop    %ebx
80101e2a:	5e                   	pop    %esi
80101e2b:	5f                   	pop    %edi
80101e2c:	5d                   	pop    %ebp
80101e2d:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101e2e:	83 ec 0c             	sub    $0xc,%esp
80101e31:	56                   	push   %esi
80101e32:	e8 a9 f9 ff ff       	call   801017e0 <iunlock>
  iput(ip);
80101e37:	89 34 24             	mov    %esi,(%esp)
80101e3a:	e8 f1 f9 ff ff       	call   80101830 <iput>
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101e3f:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e42:	8d 65 f4             	lea    -0xc(%ebp),%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101e45:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e47:	5b                   	pop    %ebx
80101e48:	5e                   	pop    %esi
80101e49:	5f                   	pop    %edi
80101e4a:	5d                   	pop    %ebp
80101e4b:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101e4c:	ba 01 00 00 00       	mov    $0x1,%edx
80101e51:	b8 01 00 00 00       	mov    $0x1,%eax
80101e56:	e8 45 f4 ff ff       	call   801012a0 <iget>
80101e5b:	89 c6                	mov    %eax,%esi
80101e5d:	e9 c9 fe ff ff       	jmp    80101d2b <namex+0x4b>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101e62:	83 ec 0c             	sub    $0xc,%esp
80101e65:	56                   	push   %esi
80101e66:	e8 75 f9 ff ff       	call   801017e0 <iunlock>
      return ip;
80101e6b:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101e71:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e73:	5b                   	pop    %ebx
80101e74:	5e                   	pop    %esi
80101e75:	5f                   	pop    %edi
80101e76:	5d                   	pop    %ebp
80101e77:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101e78:	83 ec 0c             	sub    $0xc,%esp
80101e7b:	56                   	push   %esi
80101e7c:	e8 af f9 ff ff       	call   80101830 <iput>
    return 0;
80101e81:	83 c4 10             	add    $0x10,%esp
80101e84:	31 c0                	xor    %eax,%eax
80101e86:	eb 9e                	jmp    80101e26 <namex+0x146>
80101e88:	90                   	nop
80101e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101e90 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101e90:	55                   	push   %ebp
80101e91:	89 e5                	mov    %esp,%ebp
80101e93:	57                   	push   %edi
80101e94:	56                   	push   %esi
80101e95:	53                   	push   %ebx
80101e96:	83 ec 20             	sub    $0x20,%esp
80101e99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e9c:	6a 00                	push   $0x0
80101e9e:	ff 75 0c             	pushl  0xc(%ebp)
80101ea1:	53                   	push   %ebx
80101ea2:	e8 89 fd ff ff       	call   80101c30 <dirlookup>
80101ea7:	83 c4 10             	add    $0x10,%esp
80101eaa:	85 c0                	test   %eax,%eax
80101eac:	75 67                	jne    80101f15 <dirlink+0x85>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101eae:	8b 7b 58             	mov    0x58(%ebx),%edi
80101eb1:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101eb4:	85 ff                	test   %edi,%edi
80101eb6:	74 29                	je     80101ee1 <dirlink+0x51>
80101eb8:	31 ff                	xor    %edi,%edi
80101eba:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101ebd:	eb 09                	jmp    80101ec8 <dirlink+0x38>
80101ebf:	90                   	nop
80101ec0:	83 c7 10             	add    $0x10,%edi
80101ec3:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101ec6:	76 19                	jbe    80101ee1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ec8:	6a 10                	push   $0x10
80101eca:	57                   	push   %edi
80101ecb:	56                   	push   %esi
80101ecc:	53                   	push   %ebx
80101ecd:	e8 0e fb ff ff       	call   801019e0 <readi>
80101ed2:	83 c4 10             	add    $0x10,%esp
80101ed5:	83 f8 10             	cmp    $0x10,%eax
80101ed8:	75 4e                	jne    80101f28 <dirlink+0x98>
      panic("dirlink read");
    if(de.inum == 0)
80101eda:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101edf:	75 df                	jne    80101ec0 <dirlink+0x30>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101ee1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101ee4:	83 ec 04             	sub    $0x4,%esp
80101ee7:	6a 0e                	push   $0xe
80101ee9:	ff 75 0c             	pushl  0xc(%ebp)
80101eec:	50                   	push   %eax
80101eed:	e8 de 30 00 00       	call   80104fd0 <strncpy>
  de.inum = inum;
80101ef2:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ef5:	6a 10                	push   $0x10
80101ef7:	57                   	push   %edi
80101ef8:	56                   	push   %esi
80101ef9:	53                   	push   %ebx
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101efa:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101efe:	e8 dd fb ff ff       	call   80101ae0 <writei>
80101f03:	83 c4 20             	add    $0x20,%esp
80101f06:	83 f8 10             	cmp    $0x10,%eax
80101f09:	75 2a                	jne    80101f35 <dirlink+0xa5>
    panic("dirlink");

  return 0;
80101f0b:	31 c0                	xor    %eax,%eax
}
80101f0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f10:	5b                   	pop    %ebx
80101f11:	5e                   	pop    %esi
80101f12:	5f                   	pop    %edi
80101f13:	5d                   	pop    %ebp
80101f14:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101f15:	83 ec 0c             	sub    $0xc,%esp
80101f18:	50                   	push   %eax
80101f19:	e8 12 f9 ff ff       	call   80101830 <iput>
    return -1;
80101f1e:	83 c4 10             	add    $0x10,%esp
80101f21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f26:	eb e5                	jmp    80101f0d <dirlink+0x7d>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101f28:	83 ec 0c             	sub    $0xc,%esp
80101f2b:	68 68 81 10 80       	push   $0x80108168
80101f30:	e8 3b e4 ff ff       	call   80100370 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101f35:	83 ec 0c             	sub    $0xc,%esp
80101f38:	68 b1 88 10 80       	push   $0x801088b1
80101f3d:	e8 2e e4 ff ff       	call   80100370 <panic>
80101f42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f50 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101f50:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f51:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101f53:	89 e5                	mov    %esp,%ebp
80101f55:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f58:	8b 45 08             	mov    0x8(%ebp),%eax
80101f5b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f5e:	e8 7d fd ff ff       	call   80101ce0 <namex>
}
80101f63:	c9                   	leave  
80101f64:	c3                   	ret    
80101f65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f70 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f70:	55                   	push   %ebp
  return namex(path, 1, name);
80101f71:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101f76:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f78:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f7b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f7e:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101f7f:	e9 5c fd ff ff       	jmp    80101ce0 <namex>
80101f84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101f8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101f90 <itoa>:


#include "fcntl.h"
#define DIGITS 14

char* itoa(int i, char b[]){
80101f90:	55                   	push   %ebp
    char const digit[] = "0123456789";
80101f91:	b8 38 39 00 00       	mov    $0x3938,%eax


#include "fcntl.h"
#define DIGITS 14

char* itoa(int i, char b[]){
80101f96:	89 e5                	mov    %esp,%ebp
80101f98:	57                   	push   %edi
80101f99:	56                   	push   %esi
80101f9a:	53                   	push   %ebx
80101f9b:	83 ec 10             	sub    $0x10,%esp
80101f9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
    char const digit[] = "0123456789";
80101fa1:	c7 45 e9 30 31 32 33 	movl   $0x33323130,-0x17(%ebp)
80101fa8:	c7 45 ed 34 35 36 37 	movl   $0x37363534,-0x13(%ebp)
80101faf:	66 89 45 f1          	mov    %ax,-0xf(%ebp)
80101fb3:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
80101fb7:	8b 75 0c             	mov    0xc(%ebp),%esi
    char* p = b;
    if(i<0){
80101fba:	85 c9                	test   %ecx,%ecx
80101fbc:	78 62                	js     80102020 <itoa+0x90>
        *p++ = '-';
        i *= -1;
    }
    int shifter = i;
80101fbe:	89 cb                	mov    %ecx,%ebx
    do{ //Move to where representation ends
        ++p;
        shifter = shifter/10;
80101fc0:	bf 67 66 66 66       	mov    $0x66666667,%edi
80101fc5:	8d 76 00             	lea    0x0(%esi),%esi
80101fc8:	89 d8                	mov    %ebx,%eax
80101fca:	c1 fb 1f             	sar    $0x1f,%ebx
        *p++ = '-';
        i *= -1;
    }
    int shifter = i;
    do{ //Move to where representation ends
        ++p;
80101fcd:	83 c6 01             	add    $0x1,%esi
        shifter = shifter/10;
80101fd0:	f7 ef                	imul   %edi
80101fd2:	c1 fa 02             	sar    $0x2,%edx
    }while(shifter);
80101fd5:	29 da                	sub    %ebx,%edx
80101fd7:	89 d3                	mov    %edx,%ebx
80101fd9:	75 ed                	jne    80101fc8 <itoa+0x38>
    *p = '\0';
80101fdb:	c6 06 00             	movb   $0x0,(%esi)
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
80101fde:	bb 67 66 66 66       	mov    $0x66666667,%ebx
80101fe3:	90                   	nop
80101fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fe8:	89 c8                	mov    %ecx,%eax
80101fea:	83 ee 01             	sub    $0x1,%esi
80101fed:	f7 eb                	imul   %ebx
80101fef:	89 c8                	mov    %ecx,%eax
80101ff1:	c1 f8 1f             	sar    $0x1f,%eax
80101ff4:	c1 fa 02             	sar    $0x2,%edx
80101ff7:	29 c2                	sub    %eax,%edx
80101ff9:	8d 04 92             	lea    (%edx,%edx,4),%eax
80101ffc:	01 c0                	add    %eax,%eax
80101ffe:	29 c1                	sub    %eax,%ecx
        i = i/10;
    }while(i);
80102000:	85 d2                	test   %edx,%edx
        ++p;
        shifter = shifter/10;
    }while(shifter);
    *p = '\0';
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
80102002:	0f b6 44 0d e9       	movzbl -0x17(%ebp,%ecx,1),%eax
        i = i/10;
80102007:	89 d1                	mov    %edx,%ecx
        ++p;
        shifter = shifter/10;
    }while(shifter);
    *p = '\0';
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
80102009:	88 06                	mov    %al,(%esi)
        i = i/10;
    }while(i);
8010200b:	75 db                	jne    80101fe8 <itoa+0x58>
    return b;
}
8010200d:	8b 45 0c             	mov    0xc(%ebp),%eax
80102010:	83 c4 10             	add    $0x10,%esp
80102013:	5b                   	pop    %ebx
80102014:	5e                   	pop    %esi
80102015:	5f                   	pop    %edi
80102016:	5d                   	pop    %ebp
80102017:	c3                   	ret    
80102018:	90                   	nop
80102019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

char* itoa(int i, char b[]){
    char const digit[] = "0123456789";
    char* p = b;
    if(i<0){
        *p++ = '-';
80102020:	89 f0                	mov    %esi,%eax
        i *= -1;
80102022:	f7 d9                	neg    %ecx

char* itoa(int i, char b[]){
    char const digit[] = "0123456789";
    char* p = b;
    if(i<0){
        *p++ = '-';
80102024:	8d 76 01             	lea    0x1(%esi),%esi
80102027:	c6 00 2d             	movb   $0x2d,(%eax)
8010202a:	eb 92                	jmp    80101fbe <itoa+0x2e>
8010202c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102030 <removeSwapFile>:
    return b;
}
//remove swap file of proc p;
int
removeSwapFile(struct proc* p)
{
80102030:	55                   	push   %ebp
80102031:	89 e5                	mov    %esp,%ebp
80102033:	57                   	push   %edi
80102034:	56                   	push   %esi
80102035:	53                   	push   %ebx
  //path of proccess
  char path[DIGITS];
  memmove(path,"/.swap", 6);
80102036:	8d 75 bc             	lea    -0x44(%ebp),%esi
    return b;
}
//remove swap file of proc p;
int
removeSwapFile(struct proc* p)
{
80102039:	83 ec 40             	sub    $0x40,%esp
8010203c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  //path of proccess
  char path[DIGITS];
  memmove(path,"/.swap", 6);
8010203f:	6a 06                	push   $0x6
80102041:	68 75 81 10 80       	push   $0x80108175
80102046:	56                   	push   %esi
80102047:	e8 94 2e 00 00       	call   80104ee0 <memmove>
  itoa(p->pid, path+ 6);
8010204c:	58                   	pop    %eax
8010204d:	8d 45 c2             	lea    -0x3e(%ebp),%eax
80102050:	5a                   	pop    %edx
80102051:	50                   	push   %eax
80102052:	ff 73 10             	pushl  0x10(%ebx)
80102055:	e8 36 ff ff ff       	call   80101f90 <itoa>
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ];
  uint off;

  if(0 == p->swapFile)
8010205a:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010205d:	83 c4 10             	add    $0x10,%esp
80102060:	85 c0                	test   %eax,%eax
80102062:	0f 84 88 01 00 00    	je     801021f0 <removeSwapFile+0x1c0>
  {
    return -1;
  }
  fileclose(p->swapFile);
80102068:	83 ec 0c             	sub    $0xc,%esp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
8010206b:	8d 5d ca             	lea    -0x36(%ebp),%ebx

  if(0 == p->swapFile)
  {
    return -1;
  }
  fileclose(p->swapFile);
8010206e:	50                   	push   %eax
8010206f:	e8 4c ee ff ff       	call   80100ec0 <fileclose>

  begin_op();
80102074:	e8 47 0f 00 00       	call   80102fc0 <begin_op>
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80102079:	89 f0                	mov    %esi,%eax
8010207b:	89 d9                	mov    %ebx,%ecx
8010207d:	ba 01 00 00 00       	mov    $0x1,%edx
80102082:	e8 59 fc ff ff       	call   80101ce0 <namex>
    return -1;
  }
  fileclose(p->swapFile);

  begin_op();
  if((dp = nameiparent(path, name)) == 0)
80102087:	83 c4 10             	add    $0x10,%esp
8010208a:	85 c0                	test   %eax,%eax
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
8010208c:	89 c6                	mov    %eax,%esi
    return -1;
  }
  fileclose(p->swapFile);

  begin_op();
  if((dp = nameiparent(path, name)) == 0)
8010208e:	0f 84 66 01 00 00    	je     801021fa <removeSwapFile+0x1ca>
  {
    end_op();
    return -1;
  }

  ilock(dp);
80102094:	83 ec 0c             	sub    $0xc,%esp
80102097:	50                   	push   %eax
80102098:	e8 63 f6 ff ff       	call   80101700 <ilock>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
8010209d:	83 c4 0c             	add    $0xc,%esp
801020a0:	6a 0e                	push   $0xe
801020a2:	68 7d 81 10 80       	push   $0x8010817d
801020a7:	53                   	push   %ebx
801020a8:	e8 b3 2e 00 00       	call   80104f60 <strncmp>
  }

  ilock(dp);

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801020ad:	83 c4 10             	add    $0x10,%esp
801020b0:	85 c0                	test   %eax,%eax
801020b2:	0f 84 f0 00 00 00    	je     801021a8 <removeSwapFile+0x178>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
801020b8:	83 ec 04             	sub    $0x4,%esp
801020bb:	6a 0e                	push   $0xe
801020bd:	68 7c 81 10 80       	push   $0x8010817c
801020c2:	53                   	push   %ebx
801020c3:	e8 98 2e 00 00       	call   80104f60 <strncmp>
  }

  ilock(dp);

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801020c8:	83 c4 10             	add    $0x10,%esp
801020cb:	85 c0                	test   %eax,%eax
801020cd:	0f 84 d5 00 00 00    	je     801021a8 <removeSwapFile+0x178>
     goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801020d3:	8d 45 b8             	lea    -0x48(%ebp),%eax
801020d6:	83 ec 04             	sub    $0x4,%esp
801020d9:	50                   	push   %eax
801020da:	53                   	push   %ebx
801020db:	56                   	push   %esi
801020dc:	e8 4f fb ff ff       	call   80101c30 <dirlookup>
801020e1:	83 c4 10             	add    $0x10,%esp
801020e4:	85 c0                	test   %eax,%eax
801020e6:	89 c3                	mov    %eax,%ebx
801020e8:	0f 84 ba 00 00 00    	je     801021a8 <removeSwapFile+0x178>
    goto bad;
  ilock(ip);
801020ee:	83 ec 0c             	sub    $0xc,%esp
801020f1:	50                   	push   %eax
801020f2:	e8 09 f6 ff ff       	call   80101700 <ilock>

  if(ip->nlink < 1)
801020f7:	83 c4 10             	add    $0x10,%esp
801020fa:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801020ff:	0f 8e 11 01 00 00    	jle    80102216 <removeSwapFile+0x1e6>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80102105:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010210a:	74 74                	je     80102180 <removeSwapFile+0x150>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
8010210c:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010210f:	83 ec 04             	sub    $0x4,%esp
80102112:	6a 10                	push   $0x10
80102114:	6a 00                	push   $0x0
80102116:	57                   	push   %edi
80102117:	e8 14 2d 00 00       	call   80104e30 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010211c:	6a 10                	push   $0x10
8010211e:	ff 75 b8             	pushl  -0x48(%ebp)
80102121:	57                   	push   %edi
80102122:	56                   	push   %esi
80102123:	e8 b8 f9 ff ff       	call   80101ae0 <writei>
80102128:	83 c4 20             	add    $0x20,%esp
8010212b:	83 f8 10             	cmp    $0x10,%eax
8010212e:	0f 85 d5 00 00 00    	jne    80102209 <removeSwapFile+0x1d9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80102134:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102139:	0f 84 91 00 00 00    	je     801021d0 <removeSwapFile+0x1a0>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
8010213f:	83 ec 0c             	sub    $0xc,%esp
80102142:	56                   	push   %esi
80102143:	e8 98 f6 ff ff       	call   801017e0 <iunlock>
  iput(ip);
80102148:	89 34 24             	mov    %esi,(%esp)
8010214b:	e8 e0 f6 ff ff       	call   80101830 <iput>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);

  ip->nlink--;
80102150:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80102155:	89 1c 24             	mov    %ebx,(%esp)
80102158:	e8 f3 f4 ff ff       	call   80101650 <iupdate>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
8010215d:	89 1c 24             	mov    %ebx,(%esp)
80102160:	e8 7b f6 ff ff       	call   801017e0 <iunlock>
  iput(ip);
80102165:	89 1c 24             	mov    %ebx,(%esp)
80102168:	e8 c3 f6 ff ff       	call   80101830 <iput>

  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);

  end_op();
8010216d:	e8 be 0e 00 00       	call   80103030 <end_op>

  return 0;
80102172:	83 c4 10             	add    $0x10,%esp
80102175:	31 c0                	xor    %eax,%eax
  bad:
    iunlockput(dp);
    end_op();
    return -1;

}
80102177:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010217a:	5b                   	pop    %ebx
8010217b:	5e                   	pop    %esi
8010217c:	5f                   	pop    %edi
8010217d:	5d                   	pop    %ebp
8010217e:	c3                   	ret    
8010217f:	90                   	nop
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80102180:	83 ec 0c             	sub    $0xc,%esp
80102183:	53                   	push   %ebx
80102184:	e8 07 35 00 00       	call   80105690 <isdirempty>
80102189:	83 c4 10             	add    $0x10,%esp
8010218c:	85 c0                	test   %eax,%eax
8010218e:	0f 85 78 ff ff ff    	jne    8010210c <removeSwapFile+0xdc>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80102194:	83 ec 0c             	sub    $0xc,%esp
80102197:	53                   	push   %ebx
80102198:	e8 43 f6 ff ff       	call   801017e0 <iunlock>
  iput(ip);
8010219d:	89 1c 24             	mov    %ebx,(%esp)
801021a0:	e8 8b f6 ff ff       	call   80101830 <iput>
801021a5:	83 c4 10             	add    $0x10,%esp

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
801021a8:	83 ec 0c             	sub    $0xc,%esp
801021ab:	56                   	push   %esi
801021ac:	e8 2f f6 ff ff       	call   801017e0 <iunlock>
  iput(ip);
801021b1:	89 34 24             	mov    %esi,(%esp)
801021b4:	e8 77 f6 ff ff       	call   80101830 <iput>

  return 0;

  bad:
    iunlockput(dp);
    end_op();
801021b9:	e8 72 0e 00 00       	call   80103030 <end_op>
    return -1;
801021be:	83 c4 10             	add    $0x10,%esp

}
801021c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

  bad:
    iunlockput(dp);
    end_op();
    return -1;
801021c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

}
801021c9:	5b                   	pop    %ebx
801021ca:	5e                   	pop    %esi
801021cb:	5f                   	pop    %edi
801021cc:	5d                   	pop    %ebp
801021cd:	c3                   	ret    
801021ce:	66 90                	xchg   %ax,%ax

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
801021d0:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801021d5:	83 ec 0c             	sub    $0xc,%esp
801021d8:	56                   	push   %esi
801021d9:	e8 72 f4 ff ff       	call   80101650 <iupdate>
801021de:	83 c4 10             	add    $0x10,%esp
801021e1:	e9 59 ff ff ff       	jmp    8010213f <removeSwapFile+0x10f>
801021e6:	8d 76 00             	lea    0x0(%esi),%esi
801021e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  char name[DIRSIZ];
  uint off;

  if(0 == p->swapFile)
  {
    return -1;
801021f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021f5:	e9 7d ff ff ff       	jmp    80102177 <removeSwapFile+0x147>
  fileclose(p->swapFile);

  begin_op();
  if((dp = nameiparent(path, name)) == 0)
  {
    end_op();
801021fa:	e8 31 0e 00 00       	call   80103030 <end_op>
    return -1;
801021ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102204:	e9 6e ff ff ff       	jmp    80102177 <removeSwapFile+0x147>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80102209:	83 ec 0c             	sub    $0xc,%esp
8010220c:	68 91 81 10 80       	push   $0x80108191
80102211:	e8 5a e1 ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80102216:	83 ec 0c             	sub    $0xc,%esp
80102219:	68 7f 81 10 80       	push   $0x8010817f
8010221e:	e8 4d e1 ff ff       	call   80100370 <panic>
80102223:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102230 <createSwapFile>:


//return 0 on success
int
createSwapFile(struct proc* p)
{
80102230:	55                   	push   %ebp
80102231:	89 e5                	mov    %esp,%ebp
80102233:	56                   	push   %esi
80102234:	53                   	push   %ebx

  char path[DIGITS];
  memmove(path,"/.swap", 6);
80102235:	8d 75 ea             	lea    -0x16(%ebp),%esi


//return 0 on success
int
createSwapFile(struct proc* p)
{
80102238:	83 ec 14             	sub    $0x14,%esp
8010223b:	8b 5d 08             	mov    0x8(%ebp),%ebx

  char path[DIGITS];
  memmove(path,"/.swap", 6);
8010223e:	6a 06                	push   $0x6
80102240:	68 75 81 10 80       	push   $0x80108175
80102245:	56                   	push   %esi
80102246:	e8 95 2c 00 00       	call   80104ee0 <memmove>
  itoa(p->pid, path+ 6);
8010224b:	58                   	pop    %eax
8010224c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010224f:	5a                   	pop    %edx
80102250:	50                   	push   %eax
80102251:	ff 73 10             	pushl  0x10(%ebx)
80102254:	e8 37 fd ff ff       	call   80101f90 <itoa>

    begin_op();
80102259:	e8 62 0d 00 00       	call   80102fc0 <begin_op>
    struct inode * in = create(path, T_FILE, 0, 0);
8010225e:	6a 00                	push   $0x0
80102260:	6a 00                	push   $0x0
80102262:	6a 02                	push   $0x2
80102264:	56                   	push   %esi
80102265:	e8 36 36 00 00       	call   801058a0 <create>
  iunlock(in);
8010226a:	83 c4 14             	add    $0x14,%esp
  char path[DIGITS];
  memmove(path,"/.swap", 6);
  itoa(p->pid, path+ 6);

    begin_op();
    struct inode * in = create(path, T_FILE, 0, 0);
8010226d:	89 c6                	mov    %eax,%esi
  iunlock(in);
8010226f:	50                   	push   %eax
80102270:	e8 6b f5 ff ff       	call   801017e0 <iunlock>

  p->swapFile = filealloc();
80102275:	e8 86 eb ff ff       	call   80100e00 <filealloc>
  if (p->swapFile == 0)
8010227a:	83 c4 10             	add    $0x10,%esp
8010227d:	85 c0                	test   %eax,%eax

    begin_op();
    struct inode * in = create(path, T_FILE, 0, 0);
  iunlock(in);

  p->swapFile = filealloc();
8010227f:	89 43 7c             	mov    %eax,0x7c(%ebx)
  if (p->swapFile == 0)
80102282:	74 32                	je     801022b6 <createSwapFile+0x86>
    panic("no slot for files on /store");

  p->swapFile->ip = in;
80102284:	89 70 10             	mov    %esi,0x10(%eax)
  p->swapFile->type = FD_INODE;
80102287:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010228a:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  p->swapFile->off = 0;
80102290:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102293:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  p->swapFile->readable = O_WRONLY;
8010229a:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010229d:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  p->swapFile->writable = O_RDWR;
801022a1:	8b 43 7c             	mov    0x7c(%ebx),%eax
801022a4:	c6 40 09 02          	movb   $0x2,0x9(%eax)
    end_op();
801022a8:	e8 83 0d 00 00       	call   80103030 <end_op>

    return 0;
}
801022ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022b0:	31 c0                	xor    %eax,%eax
801022b2:	5b                   	pop    %ebx
801022b3:	5e                   	pop    %esi
801022b4:	5d                   	pop    %ebp
801022b5:	c3                   	ret    
    struct inode * in = create(path, T_FILE, 0, 0);
  iunlock(in);

  p->swapFile = filealloc();
  if (p->swapFile == 0)
    panic("no slot for files on /store");
801022b6:	83 ec 0c             	sub    $0xc,%esp
801022b9:	68 a0 81 10 80       	push   $0x801081a0
801022be:	e8 ad e0 ff ff       	call   80100370 <panic>
801022c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801022c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022d0 <writeToSwapFile>:
}

//return as sys_write (-1 when error)
int
writeToSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
801022d0:	55                   	push   %ebp
801022d1:	89 e5                	mov    %esp,%ebp
801022d3:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
801022d6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801022d9:	8b 50 7c             	mov    0x7c(%eax),%edx
801022dc:	89 4a 14             	mov    %ecx,0x14(%edx)

  return filewrite(p->swapFile, buffer, size);
801022df:	8b 55 14             	mov    0x14(%ebp),%edx
801022e2:	89 55 10             	mov    %edx,0x10(%ebp)
801022e5:	8b 40 7c             	mov    0x7c(%eax),%eax
801022e8:	89 45 08             	mov    %eax,0x8(%ebp)

}
801022eb:	5d                   	pop    %ebp
int
writeToSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
  p->swapFile->off = placeOnFile;

  return filewrite(p->swapFile, buffer, size);
801022ec:	e9 7f ed ff ff       	jmp    80101070 <filewrite>
801022f1:	eb 0d                	jmp    80102300 <readFromSwapFile>
801022f3:	90                   	nop
801022f4:	90                   	nop
801022f5:	90                   	nop
801022f6:	90                   	nop
801022f7:	90                   	nop
801022f8:	90                   	nop
801022f9:	90                   	nop
801022fa:	90                   	nop
801022fb:	90                   	nop
801022fc:	90                   	nop
801022fd:	90                   	nop
801022fe:	90                   	nop
801022ff:	90                   	nop

80102300 <readFromSwapFile>:
}

//return as sys_read (-1 when error)
int
readFromSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
80102300:	55                   	push   %ebp
80102301:	89 e5                	mov    %esp,%ebp
80102303:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
80102306:	8b 4d 10             	mov    0x10(%ebp),%ecx
80102309:	8b 50 7c             	mov    0x7c(%eax),%edx
8010230c:	89 4a 14             	mov    %ecx,0x14(%edx)

  return fileread(p->swapFile, buffer,  size);
8010230f:	8b 55 14             	mov    0x14(%ebp),%edx
80102312:	89 55 10             	mov    %edx,0x10(%ebp)
80102315:	8b 40 7c             	mov    0x7c(%eax),%eax
80102318:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010231b:	5d                   	pop    %ebp
int
readFromSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
  p->swapFile->off = placeOnFile;

  return fileread(p->swapFile, buffer,  size);
8010231c:	e9 bf ec ff ff       	jmp    80100fe0 <fileread>
80102321:	66 90                	xchg   %ax,%ax
80102323:	66 90                	xchg   %ax,%ax
80102325:	66 90                	xchg   %ax,%ax
80102327:	66 90                	xchg   %ax,%ax
80102329:	66 90                	xchg   %ax,%ax
8010232b:	66 90                	xchg   %ax,%ax
8010232d:	66 90                	xchg   %ax,%ax
8010232f:	90                   	nop

80102330 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102330:	55                   	push   %ebp
  if(b == 0)
80102331:	85 c0                	test   %eax,%eax
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102333:	89 e5                	mov    %esp,%ebp
80102335:	56                   	push   %esi
80102336:	53                   	push   %ebx
  if(b == 0)
80102337:	0f 84 ad 00 00 00    	je     801023ea <idestart+0xba>
    panic("idestart");
  if(b->blockno >= FSSIZE)
8010233d:	8b 58 08             	mov    0x8(%eax),%ebx
80102340:	89 c1                	mov    %eax,%ecx
80102342:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80102348:	0f 87 8f 00 00 00    	ja     801023dd <idestart+0xad>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010234e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102353:	90                   	nop
80102354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102358:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102359:	83 e0 c0             	and    $0xffffffc0,%eax
8010235c:	3c 40                	cmp    $0x40,%al
8010235e:	75 f8                	jne    80102358 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102360:	31 f6                	xor    %esi,%esi
80102362:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102367:	89 f0                	mov    %esi,%eax
80102369:	ee                   	out    %al,(%dx)
8010236a:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010236f:	b8 01 00 00 00       	mov    $0x1,%eax
80102374:	ee                   	out    %al,(%dx)
80102375:	ba f3 01 00 00       	mov    $0x1f3,%edx
8010237a:	89 d8                	mov    %ebx,%eax
8010237c:	ee                   	out    %al,(%dx)
8010237d:	89 d8                	mov    %ebx,%eax
8010237f:	ba f4 01 00 00       	mov    $0x1f4,%edx
80102384:	c1 f8 08             	sar    $0x8,%eax
80102387:	ee                   	out    %al,(%dx)
80102388:	ba f5 01 00 00       	mov    $0x1f5,%edx
8010238d:	89 f0                	mov    %esi,%eax
8010238f:	ee                   	out    %al,(%dx)
80102390:	0f b6 41 04          	movzbl 0x4(%ecx),%eax
80102394:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102399:	83 e0 01             	and    $0x1,%eax
8010239c:	c1 e0 04             	shl    $0x4,%eax
8010239f:	83 c8 e0             	or     $0xffffffe0,%eax
801023a2:	ee                   	out    %al,(%dx)
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
801023a3:	f6 01 04             	testb  $0x4,(%ecx)
801023a6:	ba f7 01 00 00       	mov    $0x1f7,%edx
801023ab:	75 13                	jne    801023c0 <idestart+0x90>
801023ad:	b8 20 00 00 00       	mov    $0x20,%eax
801023b2:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801023b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023b6:	5b                   	pop    %ebx
801023b7:	5e                   	pop    %esi
801023b8:	5d                   	pop    %ebp
801023b9:	c3                   	ret    
801023ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801023c0:	b8 30 00 00 00       	mov    $0x30,%eax
801023c5:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
801023c6:	ba f0 01 00 00       	mov    $0x1f0,%edx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
801023cb:	8d 71 5c             	lea    0x5c(%ecx),%esi
801023ce:	b9 80 00 00 00       	mov    $0x80,%ecx
801023d3:	fc                   	cld    
801023d4:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
801023d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023d9:	5b                   	pop    %ebx
801023da:	5e                   	pop    %esi
801023db:	5d                   	pop    %ebp
801023dc:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
801023dd:	83 ec 0c             	sub    $0xc,%esp
801023e0:	68 18 82 10 80       	push   $0x80108218
801023e5:	e8 86 df ff ff       	call   80100370 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
801023ea:	83 ec 0c             	sub    $0xc,%esp
801023ed:	68 0f 82 10 80       	push   $0x8010820f
801023f2:	e8 79 df ff ff       	call   80100370 <panic>
801023f7:	89 f6                	mov    %esi,%esi
801023f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102400 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80102400:	55                   	push   %ebp
80102401:	89 e5                	mov    %esp,%ebp
80102403:	83 ec 10             	sub    $0x10,%esp
  int i;

  initlock(&idelock, "ide");
80102406:	68 2a 82 10 80       	push   $0x8010822a
8010240b:	68 80 b5 10 80       	push   $0x8010b580
80102410:	e8 8b 27 00 00       	call   80104ba0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102415:	58                   	pop    %eax
80102416:	a1 20 3d 11 80       	mov    0x80113d20,%eax
8010241b:	5a                   	pop    %edx
8010241c:	83 e8 01             	sub    $0x1,%eax
8010241f:	50                   	push   %eax
80102420:	6a 0e                	push   $0xe
80102422:	e8 a9 02 00 00       	call   801026d0 <ioapicenable>
80102427:	83 c4 10             	add    $0x10,%esp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010242a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010242f:	90                   	nop
80102430:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102431:	83 e0 c0             	and    $0xffffffc0,%eax
80102434:	3c 40                	cmp    $0x40,%al
80102436:	75 f8                	jne    80102430 <ideinit+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102438:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010243d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102442:	ee                   	out    %al,(%dx)
80102443:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102448:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010244d:	eb 06                	jmp    80102455 <ideinit+0x55>
8010244f:	90                   	nop
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102450:	83 e9 01             	sub    $0x1,%ecx
80102453:	74 0f                	je     80102464 <ideinit+0x64>
80102455:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102456:	84 c0                	test   %al,%al
80102458:	74 f6                	je     80102450 <ideinit+0x50>
      havedisk1 = 1;
8010245a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102461:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102464:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102469:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
8010246e:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
8010246f:	c9                   	leave  
80102470:	c3                   	ret    
80102471:	eb 0d                	jmp    80102480 <ideintr>
80102473:	90                   	nop
80102474:	90                   	nop
80102475:	90                   	nop
80102476:	90                   	nop
80102477:	90                   	nop
80102478:	90                   	nop
80102479:	90                   	nop
8010247a:	90                   	nop
8010247b:	90                   	nop
8010247c:	90                   	nop
8010247d:	90                   	nop
8010247e:	90                   	nop
8010247f:	90                   	nop

80102480 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102480:	55                   	push   %ebp
80102481:	89 e5                	mov    %esp,%ebp
80102483:	57                   	push   %edi
80102484:	56                   	push   %esi
80102485:	53                   	push   %ebx
80102486:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102489:	68 80 b5 10 80       	push   $0x8010b580
8010248e:	e8 0d 28 00 00       	call   80104ca0 <acquire>

  if((b = idequeue) == 0){
80102493:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
80102499:	83 c4 10             	add    $0x10,%esp
8010249c:	85 db                	test   %ebx,%ebx
8010249e:	74 34                	je     801024d4 <ideintr+0x54>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801024a0:	8b 43 58             	mov    0x58(%ebx),%eax
801024a3:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801024a8:	8b 33                	mov    (%ebx),%esi
801024aa:	f7 c6 04 00 00 00    	test   $0x4,%esi
801024b0:	74 3e                	je     801024f0 <ideintr+0x70>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801024b2:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801024b5:	83 ec 0c             	sub    $0xc,%esp
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801024b8:	83 ce 02             	or     $0x2,%esi
801024bb:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801024bd:	53                   	push   %ebx
801024be:	e8 6d 20 00 00       	call   80104530 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801024c3:	a1 64 b5 10 80       	mov    0x8010b564,%eax
801024c8:	83 c4 10             	add    $0x10,%esp
801024cb:	85 c0                	test   %eax,%eax
801024cd:	74 05                	je     801024d4 <ideintr+0x54>
    idestart(idequeue);
801024cf:	e8 5c fe ff ff       	call   80102330 <idestart>

  // First queued buffer is the active request.
  acquire(&idelock);

  if((b = idequeue) == 0){
    release(&idelock);
801024d4:	83 ec 0c             	sub    $0xc,%esp
801024d7:	68 80 b5 10 80       	push   $0x8010b580
801024dc:	e8 ff 28 00 00       	call   80104de0 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
801024e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024e4:	5b                   	pop    %ebx
801024e5:	5e                   	pop    %esi
801024e6:	5f                   	pop    %edi
801024e7:	5d                   	pop    %ebp
801024e8:	c3                   	ret    
801024e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024f0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801024f5:	8d 76 00             	lea    0x0(%esi),%esi
801024f8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801024f9:	89 c1                	mov    %eax,%ecx
801024fb:	83 e1 c0             	and    $0xffffffc0,%ecx
801024fe:	80 f9 40             	cmp    $0x40,%cl
80102501:	75 f5                	jne    801024f8 <ideintr+0x78>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102503:	a8 21                	test   $0x21,%al
80102505:	75 ab                	jne    801024b2 <ideintr+0x32>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
80102507:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
8010250a:	b9 80 00 00 00       	mov    $0x80,%ecx
8010250f:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102514:	fc                   	cld    
80102515:	f3 6d                	rep insl (%dx),%es:(%edi)
80102517:	8b 33                	mov    (%ebx),%esi
80102519:	eb 97                	jmp    801024b2 <ideintr+0x32>
8010251b:	90                   	nop
8010251c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102520 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102520:	55                   	push   %ebp
80102521:	89 e5                	mov    %esp,%ebp
80102523:	53                   	push   %ebx
80102524:	83 ec 10             	sub    $0x10,%esp
80102527:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010252a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010252d:	50                   	push   %eax
8010252e:	e8 3d 26 00 00       	call   80104b70 <holdingsleep>
80102533:	83 c4 10             	add    $0x10,%esp
80102536:	85 c0                	test   %eax,%eax
80102538:	0f 84 ad 00 00 00    	je     801025eb <iderw+0xcb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010253e:	8b 03                	mov    (%ebx),%eax
80102540:	83 e0 06             	and    $0x6,%eax
80102543:	83 f8 02             	cmp    $0x2,%eax
80102546:	0f 84 b9 00 00 00    	je     80102605 <iderw+0xe5>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010254c:	8b 53 04             	mov    0x4(%ebx),%edx
8010254f:	85 d2                	test   %edx,%edx
80102551:	74 0d                	je     80102560 <iderw+0x40>
80102553:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102558:	85 c0                	test   %eax,%eax
8010255a:	0f 84 98 00 00 00    	je     801025f8 <iderw+0xd8>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102560:	83 ec 0c             	sub    $0xc,%esp
80102563:	68 80 b5 10 80       	push   $0x8010b580
80102568:	e8 33 27 00 00       	call   80104ca0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010256d:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
80102573:	83 c4 10             	add    $0x10,%esp
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
80102576:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010257d:	85 d2                	test   %edx,%edx
8010257f:	75 09                	jne    8010258a <iderw+0x6a>
80102581:	eb 58                	jmp    801025db <iderw+0xbb>
80102583:	90                   	nop
80102584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102588:	89 c2                	mov    %eax,%edx
8010258a:	8b 42 58             	mov    0x58(%edx),%eax
8010258d:	85 c0                	test   %eax,%eax
8010258f:	75 f7                	jne    80102588 <iderw+0x68>
80102591:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102594:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102596:	3b 1d 64 b5 10 80    	cmp    0x8010b564,%ebx
8010259c:	74 44                	je     801025e2 <iderw+0xc2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010259e:	8b 03                	mov    (%ebx),%eax
801025a0:	83 e0 06             	and    $0x6,%eax
801025a3:	83 f8 02             	cmp    $0x2,%eax
801025a6:	74 23                	je     801025cb <iderw+0xab>
801025a8:	90                   	nop
801025a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801025b0:	83 ec 08             	sub    $0x8,%esp
801025b3:	68 80 b5 10 80       	push   $0x8010b580
801025b8:	53                   	push   %ebx
801025b9:	e8 b2 1d 00 00       	call   80104370 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801025be:	8b 03                	mov    (%ebx),%eax
801025c0:	83 c4 10             	add    $0x10,%esp
801025c3:	83 e0 06             	and    $0x6,%eax
801025c6:	83 f8 02             	cmp    $0x2,%eax
801025c9:	75 e5                	jne    801025b0 <iderw+0x90>
    sleep(b, &idelock);
  }


  release(&idelock);
801025cb:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
801025d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025d5:	c9                   	leave  
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
801025d6:	e9 05 28 00 00       	jmp    80104de0 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801025db:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
801025e0:	eb b2                	jmp    80102594 <iderw+0x74>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
801025e2:	89 d8                	mov    %ebx,%eax
801025e4:	e8 47 fd ff ff       	call   80102330 <idestart>
801025e9:	eb b3                	jmp    8010259e <iderw+0x7e>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
801025eb:	83 ec 0c             	sub    $0xc,%esp
801025ee:	68 2e 82 10 80       	push   $0x8010822e
801025f3:	e8 78 dd ff ff       	call   80100370 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
801025f8:	83 ec 0c             	sub    $0xc,%esp
801025fb:	68 59 82 10 80       	push   $0x80108259
80102600:	e8 6b dd ff ff       	call   80100370 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
80102605:	83 ec 0c             	sub    $0xc,%esp
80102608:	68 44 82 10 80       	push   $0x80108244
8010260d:	e8 5e dd ff ff       	call   80100370 <panic>
80102612:	66 90                	xchg   %ax,%ax
80102614:	66 90                	xchg   %ax,%ax
80102616:	66 90                	xchg   %ax,%ax
80102618:	66 90                	xchg   %ax,%ax
8010261a:	66 90                	xchg   %ax,%ax
8010261c:	66 90                	xchg   %ax,%ax
8010261e:	66 90                	xchg   %ax,%ax

80102620 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102620:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102621:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
80102628:	00 c0 fe 
  ioapic->data = data;
}

void
ioapicinit(void)
{
8010262b:	89 e5                	mov    %esp,%ebp
8010262d:	56                   	push   %esi
8010262e:	53                   	push   %ebx
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
8010262f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102636:	00 00 00 
  return ioapic->data;
80102639:	8b 15 34 36 11 80    	mov    0x80113634,%edx
8010263f:	8b 72 10             	mov    0x10(%edx),%esi
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102642:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102648:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010264e:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102655:	89 f0                	mov    %esi,%eax
80102657:	c1 e8 10             	shr    $0x10,%eax
8010265a:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
8010265d:	8b 41 10             	mov    0x10(%ecx),%eax
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102660:	c1 e8 18             	shr    $0x18,%eax
80102663:	39 d0                	cmp    %edx,%eax
80102665:	74 16                	je     8010267d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102667:	83 ec 0c             	sub    $0xc,%esp
8010266a:	68 78 82 10 80       	push   $0x80108278
8010266f:	e8 ec df ff ff       	call   80100660 <cprintf>
80102674:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
8010267a:	83 c4 10             	add    $0x10,%esp
8010267d:	83 c6 21             	add    $0x21,%esi
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102680:	ba 10 00 00 00       	mov    $0x10,%edx
80102685:	b8 20 00 00 00       	mov    $0x20,%eax
8010268a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102690:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102692:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102698:	89 c3                	mov    %eax,%ebx
8010269a:	81 cb 00 00 01 00    	or     $0x10000,%ebx
801026a0:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801026a3:	89 59 10             	mov    %ebx,0x10(%ecx)
801026a6:	8d 5a 01             	lea    0x1(%edx),%ebx
801026a9:	83 c2 02             	add    $0x2,%edx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801026ac:	39 f0                	cmp    %esi,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801026ae:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
801026b0:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
801026b6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801026bd:	75 d1                	jne    80102690 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801026bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026c2:	5b                   	pop    %ebx
801026c3:	5e                   	pop    %esi
801026c4:	5d                   	pop    %ebp
801026c5:	c3                   	ret    
801026c6:	8d 76 00             	lea    0x0(%esi),%esi
801026c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026d0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801026d0:	55                   	push   %ebp
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801026d1:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  }
}

void
ioapicenable(int irq, int cpunum)
{
801026d7:	89 e5                	mov    %esp,%ebp
801026d9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801026dc:	8d 50 20             	lea    0x20(%eax),%edx
801026df:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801026e3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801026e5:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801026eb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801026ee:	89 51 10             	mov    %edx,0x10(%ecx)
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801026f1:	8b 55 0c             	mov    0xc(%ebp),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801026f4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801026f6:	a1 34 36 11 80       	mov    0x80113634,%eax
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801026fb:	c1 e2 18             	shl    $0x18,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801026fe:	89 50 10             	mov    %edx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102701:	5d                   	pop    %ebp
80102702:	c3                   	ret    
80102703:	66 90                	xchg   %ax,%ax
80102705:	66 90                	xchg   %ax,%ax
80102707:	66 90                	xchg   %ax,%ax
80102709:	66 90                	xchg   %ax,%ax
8010270b:	66 90                	xchg   %ax,%ax
8010270d:	66 90                	xchg   %ax,%ax
8010270f:	90                   	nop

80102710 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102710:	55                   	push   %ebp
80102711:	89 e5                	mov    %esp,%ebp
80102713:	53                   	push   %ebx
80102714:	83 ec 04             	sub    $0x4,%esp
80102717:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;
  
  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP){
8010271a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102720:	0f 85 7c 00 00 00    	jne    801027a2 <kfree+0x92>
80102726:	81 fb c8 eb 11 80    	cmp    $0x8011ebc8,%ebx
8010272c:	72 74                	jb     801027a2 <kfree+0x92>
8010272e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102734:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102739:	77 67                	ja     801027a2 <kfree+0x92>
    panic("kfree");
  }
  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
8010273b:	83 ec 04             	sub    $0x4,%esp
8010273e:	68 00 10 00 00       	push   $0x1000
80102743:	6a 01                	push   $0x1
80102745:	53                   	push   %ebx
80102746:	e8 e5 26 00 00       	call   80104e30 <memset>
  if(kmem.use_lock)
8010274b:	8b 15 74 36 11 80    	mov    0x80113674,%edx
80102751:	83 c4 10             	add    $0x10,%esp
80102754:	85 d2                	test   %edx,%edx
80102756:	75 38                	jne    80102790 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102758:	a1 78 36 11 80       	mov    0x80113678,%eax
8010275d:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  freePages++;

  if(kmem.use_lock)
8010275f:	a1 74 36 11 80       	mov    0x80113674,%eax
  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  freePages++;
80102764:	83 05 80 36 11 80 01 	addl   $0x1,0x80113680
  memset(v, 1, PGSIZE);
  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
8010276b:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
  freePages++;

  if(kmem.use_lock)
80102771:	85 c0                	test   %eax,%eax
80102773:	75 0b                	jne    80102780 <kfree+0x70>
    release(&kmem.lock);
}
80102775:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102778:	c9                   	leave  
80102779:	c3                   	ret    
8010277a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r->next = kmem.freelist;
  kmem.freelist = r;
  freePages++;

  if(kmem.use_lock)
    release(&kmem.lock);
80102780:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
80102787:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010278a:	c9                   	leave  
  r->next = kmem.freelist;
  kmem.freelist = r;
  freePages++;

  if(kmem.use_lock)
    release(&kmem.lock);
8010278b:	e9 50 26 00 00       	jmp    80104de0 <release>
    panic("kfree");
  }
  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
  if(kmem.use_lock)
    acquire(&kmem.lock);
80102790:	83 ec 0c             	sub    $0xc,%esp
80102793:	68 40 36 11 80       	push   $0x80113640
80102798:	e8 03 25 00 00       	call   80104ca0 <acquire>
8010279d:	83 c4 10             	add    $0x10,%esp
801027a0:	eb b6                	jmp    80102758 <kfree+0x48>
kfree(char *v)
{
  struct run *r;
  
  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP){
    panic("kfree");
801027a2:	83 ec 0c             	sub    $0xc,%esp
801027a5:	68 aa 82 10 80       	push   $0x801082aa
801027aa:	e8 c1 db ff ff       	call   80100370 <panic>
801027af:	90                   	nop

801027b0 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
801027b0:	55                   	push   %ebp
801027b1:	89 e5                	mov    %esp,%ebp
801027b3:	56                   	push   %esi
801027b4:	53                   	push   %ebx
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801027b5:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
801027b8:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801027bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801027c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801027c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801027cd:	39 de                	cmp    %ebx,%esi
801027cf:	72 2a                	jb     801027fb <freerange+0x4b>
801027d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    totalPages++;
    kfree(p);
801027d8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801027de:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801027e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    totalPages++;
801027e7:	83 05 7c 36 11 80 01 	addl   $0x1,0x8011367c
    kfree(p);
801027ee:	50                   	push   %eax
801027ef:	e8 1c ff ff ff       	call   80102710 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801027f4:	83 c4 10             	add    $0x10,%esp
801027f7:	39 f3                	cmp    %esi,%ebx
801027f9:	76 dd                	jbe    801027d8 <freerange+0x28>
    totalPages++;
    kfree(p);
  }
}
801027fb:	8d 65 f8             	lea    -0x8(%ebp),%esp
801027fe:	5b                   	pop    %ebx
801027ff:	5e                   	pop    %esi
80102800:	5d                   	pop    %ebp
80102801:	c3                   	ret    
80102802:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102810 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102810:	55                   	push   %ebp
  freePages = 0;
80102811:	c7 05 80 36 11 80 00 	movl   $0x0,0x80113680
80102818:	00 00 00 
  totalPages = 0;
8010281b:	c7 05 7c 36 11 80 00 	movl   $0x0,0x8011367c
80102822:	00 00 00 
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102825:	89 e5                	mov    %esp,%ebp
80102827:	56                   	push   %esi
80102828:	53                   	push   %ebx
80102829:	8b 75 0c             	mov    0xc(%ebp),%esi
  freePages = 0;
  totalPages = 0;
  initlock(&kmem.lock, "kmem");
8010282c:	83 ec 08             	sub    $0x8,%esp
8010282f:	68 b0 82 10 80       	push   $0x801082b0
80102834:	68 40 36 11 80       	push   $0x80113640
80102839:	e8 62 23 00 00       	call   80104ba0 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010283e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102841:	83 c4 10             	add    $0x10,%esp
kinit1(void *vstart, void *vend)
{
  freePages = 0;
  totalPages = 0;
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
80102844:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
8010284b:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010284e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102854:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
8010285a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102860:	39 de                	cmp    %ebx,%esi
80102862:	72 27                	jb     8010288b <kinit1+0x7b>
80102864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    totalPages++;
    kfree(p);
80102868:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010286e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102871:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    totalPages++;
80102877:	83 05 7c 36 11 80 01 	addl   $0x1,0x8011367c
    kfree(p);
8010287e:	50                   	push   %eax
8010287f:	e8 8c fe ff ff       	call   80102710 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
80102884:	83 c4 10             	add    $0x10,%esp
80102887:	39 de                	cmp    %ebx,%esi
80102889:	73 dd                	jae    80102868 <kinit1+0x58>
  freePages = 0;
  totalPages = 0;
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
8010288b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010288e:	5b                   	pop    %ebx
8010288f:	5e                   	pop    %esi
80102890:	5d                   	pop    %ebp
80102891:	c3                   	ret    
80102892:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801028a0 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
801028a0:	55                   	push   %ebp
801028a1:	89 e5                	mov    %esp,%ebp
801028a3:	56                   	push   %esi
801028a4:	53                   	push   %ebx

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801028a5:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
801028a8:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801028ab:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801028b1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801028b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801028bd:	39 de                	cmp    %ebx,%esi
801028bf:	72 2a                	jb     801028eb <kinit2+0x4b>
801028c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    totalPages++;
    kfree(p);
801028c8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801028ce:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801028d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    totalPages++;
801028d7:	83 05 7c 36 11 80 01 	addl   $0x1,0x8011367c
    kfree(p);
801028de:	50                   	push   %eax
801028df:	e8 2c fe ff ff       	call   80102710 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE){
801028e4:	83 c4 10             	add    $0x10,%esp
801028e7:	39 de                	cmp    %ebx,%esi
801028e9:	73 dd                	jae    801028c8 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
801028eb:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
801028f2:	00 00 00 
}
801028f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801028f8:	5b                   	pop    %ebx
801028f9:	5e                   	pop    %esi
801028fa:	5d                   	pop    %ebp
801028fb:	c3                   	ret    
801028fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102900 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102900:	55                   	push   %ebp
80102901:	89 e5                	mov    %esp,%ebp
80102903:	53                   	push   %ebx
80102904:	83 ec 04             	sub    $0x4,%esp
  struct run *r;
    
  if(kmem.use_lock)
80102907:	a1 74 36 11 80       	mov    0x80113674,%eax
8010290c:	85 c0                	test   %eax,%eax
8010290e:	75 38                	jne    80102948 <kalloc+0x48>
    acquire(&kmem.lock);
  
  r = kmem.freelist;
80102910:	8b 1d 78 36 11 80    	mov    0x80113678,%ebx
  
  if(r){
80102916:	85 db                	test   %ebx,%ebx
80102918:	74 23                	je     8010293d <kalloc+0x3d>
    kmem.freelist = r->next;
8010291a:	8b 13                	mov    (%ebx),%edx
    freePages--;
8010291c:	83 2d 80 36 11 80 01 	subl   $0x1,0x80113680
    acquire(&kmem.lock);
  
  r = kmem.freelist;
  
  if(r){
    kmem.freelist = r->next;
80102923:	89 15 78 36 11 80    	mov    %edx,0x80113678
    freePages--;
  }
  
  if(kmem.use_lock)
80102929:	85 c0                	test   %eax,%eax
8010292b:	74 10                	je     8010293d <kalloc+0x3d>
    release(&kmem.lock);
8010292d:	83 ec 0c             	sub    $0xc,%esp
80102930:	68 40 36 11 80       	push   $0x80113640
80102935:	e8 a6 24 00 00       	call   80104de0 <release>
8010293a:	83 c4 10             	add    $0x10,%esp

  return (char*)r;
}
8010293d:	89 d8                	mov    %ebx,%eax
8010293f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102942:	c9                   	leave  
80102943:	c3                   	ret    
80102944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
kalloc(void)
{
  struct run *r;
    
  if(kmem.use_lock)
    acquire(&kmem.lock);
80102948:	83 ec 0c             	sub    $0xc,%esp
8010294b:	68 40 36 11 80       	push   $0x80113640
80102950:	e8 4b 23 00 00       	call   80104ca0 <acquire>
  
  r = kmem.freelist;
80102955:	8b 1d 78 36 11 80    	mov    0x80113678,%ebx
  
  if(r){
8010295b:	83 c4 10             	add    $0x10,%esp
8010295e:	a1 74 36 11 80       	mov    0x80113674,%eax
80102963:	85 db                	test   %ebx,%ebx
80102965:	75 b3                	jne    8010291a <kalloc+0x1a>
80102967:	eb c0                	jmp    80102929 <kalloc+0x29>
80102969:	66 90                	xchg   %ax,%ax
8010296b:	66 90                	xchg   %ax,%ax
8010296d:	66 90                	xchg   %ax,%ax
8010296f:	90                   	nop

80102970 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102970:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102971:	ba 64 00 00 00       	mov    $0x64,%edx
80102976:	89 e5                	mov    %esp,%ebp
80102978:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102979:	a8 01                	test   $0x1,%al
8010297b:	0f 84 af 00 00 00    	je     80102a30 <kbdgetc+0xc0>
80102981:	ba 60 00 00 00       	mov    $0x60,%edx
80102986:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102987:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
8010298a:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102990:	74 7e                	je     80102a10 <kbdgetc+0xa0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102992:	84 c0                	test   %al,%al
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102994:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
8010299a:	79 24                	jns    801029c0 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
8010299c:	f6 c1 40             	test   $0x40,%cl
8010299f:	75 05                	jne    801029a6 <kbdgetc+0x36>
801029a1:	89 c2                	mov    %eax,%edx
801029a3:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801029a6:	0f b6 82 e0 83 10 80 	movzbl -0x7fef7c20(%edx),%eax
801029ad:	83 c8 40             	or     $0x40,%eax
801029b0:	0f b6 c0             	movzbl %al,%eax
801029b3:	f7 d0                	not    %eax
801029b5:	21 c8                	and    %ecx,%eax
801029b7:	a3 b4 b5 10 80       	mov    %eax,0x8010b5b4
    return 0;
801029bc:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801029be:	5d                   	pop    %ebp
801029bf:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801029c0:	f6 c1 40             	test   $0x40,%cl
801029c3:	74 09                	je     801029ce <kbdgetc+0x5e>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801029c5:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801029c8:	83 e1 bf             	and    $0xffffffbf,%ecx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801029cb:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
801029ce:	0f b6 82 e0 83 10 80 	movzbl -0x7fef7c20(%edx),%eax
801029d5:	09 c1                	or     %eax,%ecx
801029d7:	0f b6 82 e0 82 10 80 	movzbl -0x7fef7d20(%edx),%eax
801029de:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801029e0:	89 c8                	mov    %ecx,%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
801029e2:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801029e8:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801029eb:	83 e1 08             	and    $0x8,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
801029ee:	8b 04 85 c0 82 10 80 	mov    -0x7fef7d40(,%eax,4),%eax
801029f5:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801029f9:	74 c3                	je     801029be <kbdgetc+0x4e>
    if('a' <= c && c <= 'z')
801029fb:	8d 50 9f             	lea    -0x61(%eax),%edx
801029fe:	83 fa 19             	cmp    $0x19,%edx
80102a01:	77 1d                	ja     80102a20 <kbdgetc+0xb0>
      c += 'A' - 'a';
80102a03:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102a06:	5d                   	pop    %ebp
80102a07:	c3                   	ret    
80102a08:	90                   	nop
80102a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
80102a10:	31 c0                	xor    %eax,%eax
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102a12:	83 0d b4 b5 10 80 40 	orl    $0x40,0x8010b5b4
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102a19:	5d                   	pop    %ebp
80102a1a:	c3                   	ret    
80102a1b:	90                   	nop
80102a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
80102a20:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102a23:	8d 50 20             	lea    0x20(%eax),%edx
  }
  return c;
}
80102a26:	5d                   	pop    %ebp
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
80102a27:	83 f9 19             	cmp    $0x19,%ecx
80102a2a:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
}
80102a2d:	c3                   	ret    
80102a2e:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
80102a30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102a35:	5d                   	pop    %ebp
80102a36:	c3                   	ret    
80102a37:	89 f6                	mov    %esi,%esi
80102a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a40 <kbdintr>:

void
kbdintr(void)
{
80102a40:	55                   	push   %ebp
80102a41:	89 e5                	mov    %esp,%ebp
80102a43:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102a46:	68 70 29 10 80       	push   $0x80102970
80102a4b:	e8 a0 dd ff ff       	call   801007f0 <consoleintr>
}
80102a50:	83 c4 10             	add    $0x10,%esp
80102a53:	c9                   	leave  
80102a54:	c3                   	ret    
80102a55:	66 90                	xchg   %ax,%ax
80102a57:	66 90                	xchg   %ax,%ax
80102a59:	66 90                	xchg   %ax,%ax
80102a5b:	66 90                	xchg   %ax,%ax
80102a5d:	66 90                	xchg   %ax,%ax
80102a5f:	90                   	nop

80102a60 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102a60:	a1 84 36 11 80       	mov    0x80113684,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102a65:	55                   	push   %ebp
80102a66:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102a68:	85 c0                	test   %eax,%eax
80102a6a:	0f 84 c8 00 00 00    	je     80102b38 <lapicinit+0xd8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a70:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102a77:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a7a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a7d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102a84:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a87:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a8a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102a91:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102a94:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102a97:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102a9e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102aa1:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102aa4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102aab:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102aae:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102ab1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102ab8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102abb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102abe:	8b 50 30             	mov    0x30(%eax),%edx
80102ac1:	c1 ea 10             	shr    $0x10,%edx
80102ac4:	80 fa 03             	cmp    $0x3,%dl
80102ac7:	77 77                	ja     80102b40 <lapicinit+0xe0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102ac9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102ad0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ad3:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102ad6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102add:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ae0:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102ae3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102aea:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102aed:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102af0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102af7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102afa:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102afd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102b04:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b07:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b0a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102b11:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102b14:	8b 50 20             	mov    0x20(%eax),%edx
80102b17:	89 f6                	mov    %esi,%esi
80102b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102b20:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102b26:	80 e6 10             	and    $0x10,%dh
80102b29:	75 f5                	jne    80102b20 <lapicinit+0xc0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b2b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102b32:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b35:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102b38:	5d                   	pop    %ebp
80102b39:	c3                   	ret    
80102b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b40:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102b47:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102b4a:	8b 50 20             	mov    0x20(%eax),%edx
80102b4d:	e9 77 ff ff ff       	jmp    80102ac9 <lapicinit+0x69>
80102b52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b60 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
80102b60:	a1 84 36 11 80       	mov    0x80113684,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
80102b65:	55                   	push   %ebp
80102b66:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102b68:	85 c0                	test   %eax,%eax
80102b6a:	74 0c                	je     80102b78 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
80102b6c:	8b 40 20             	mov    0x20(%eax),%eax
}
80102b6f:	5d                   	pop    %ebp
int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
80102b70:	c1 e8 18             	shr    $0x18,%eax
}
80102b73:	c3                   	ret    
80102b74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int
lapicid(void)
{
  if (!lapic)
    return 0;
80102b78:	31 c0                	xor    %eax,%eax
  return lapic[ID] >> 24;
}
80102b7a:	5d                   	pop    %ebp
80102b7b:	c3                   	ret    
80102b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b80 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102b80:	a1 84 36 11 80       	mov    0x80113684,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102b85:	55                   	push   %ebp
80102b86:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102b88:	85 c0                	test   %eax,%eax
80102b8a:	74 0d                	je     80102b99 <lapiceoi+0x19>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102b8c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102b93:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b96:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102b99:	5d                   	pop    %ebp
80102b9a:	c3                   	ret    
80102b9b:	90                   	nop
80102b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102ba0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102ba0:	55                   	push   %ebp
80102ba1:	89 e5                	mov    %esp,%ebp
}
80102ba3:	5d                   	pop    %ebp
80102ba4:	c3                   	ret    
80102ba5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102bb0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102bb0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bb1:	ba 70 00 00 00       	mov    $0x70,%edx
80102bb6:	b8 0f 00 00 00       	mov    $0xf,%eax
80102bbb:	89 e5                	mov    %esp,%ebp
80102bbd:	53                   	push   %ebx
80102bbe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102bc1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102bc4:	ee                   	out    %al,(%dx)
80102bc5:	ba 71 00 00 00       	mov    $0x71,%edx
80102bca:	b8 0a 00 00 00       	mov    $0xa,%eax
80102bcf:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102bd0:	31 c0                	xor    %eax,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102bd2:	c1 e3 18             	shl    $0x18,%ebx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102bd5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102bdb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102bdd:	c1 e9 0c             	shr    $0xc,%ecx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102be0:	c1 e8 04             	shr    $0x4,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102be3:	89 da                	mov    %ebx,%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102be5:	80 cd 06             	or     $0x6,%ch
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102be8:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102bee:	a1 84 36 11 80       	mov    0x80113684,%eax
80102bf3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bf9:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102bfc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102c03:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c06:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102c09:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102c10:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c13:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102c16:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c1c:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102c1f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c25:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102c28:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c2e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102c31:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c37:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80102c3a:	5b                   	pop    %ebx
80102c3b:	5d                   	pop    %ebp
80102c3c:	c3                   	ret    
80102c3d:	8d 76 00             	lea    0x0(%esi),%esi

80102c40 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102c40:	55                   	push   %ebp
80102c41:	ba 70 00 00 00       	mov    $0x70,%edx
80102c46:	b8 0b 00 00 00       	mov    $0xb,%eax
80102c4b:	89 e5                	mov    %esp,%ebp
80102c4d:	57                   	push   %edi
80102c4e:	56                   	push   %esi
80102c4f:	53                   	push   %ebx
80102c50:	83 ec 4c             	sub    $0x4c,%esp
80102c53:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c54:	ba 71 00 00 00       	mov    $0x71,%edx
80102c59:	ec                   	in     (%dx),%al
80102c5a:	83 e0 04             	and    $0x4,%eax
80102c5d:	8d 75 d0             	lea    -0x30(%ebp),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c60:	31 db                	xor    %ebx,%ebx
80102c62:	88 45 b7             	mov    %al,-0x49(%ebp)
80102c65:	bf 70 00 00 00       	mov    $0x70,%edi
80102c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102c70:	89 d8                	mov    %ebx,%eax
80102c72:	89 fa                	mov    %edi,%edx
80102c74:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c75:	b9 71 00 00 00       	mov    $0x71,%ecx
80102c7a:	89 ca                	mov    %ecx,%edx
80102c7c:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
80102c7d:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c80:	89 fa                	mov    %edi,%edx
80102c82:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102c85:	b8 02 00 00 00       	mov    $0x2,%eax
80102c8a:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c8b:	89 ca                	mov    %ecx,%edx
80102c8d:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102c8e:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c91:	89 fa                	mov    %edi,%edx
80102c93:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102c96:	b8 04 00 00 00       	mov    $0x4,%eax
80102c9b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c9c:	89 ca                	mov    %ecx,%edx
80102c9e:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102c9f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ca2:	89 fa                	mov    %edi,%edx
80102ca4:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102ca7:	b8 07 00 00 00       	mov    $0x7,%eax
80102cac:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cad:	89 ca                	mov    %ecx,%edx
80102caf:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102cb0:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cb3:	89 fa                	mov    %edi,%edx
80102cb5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102cb8:	b8 08 00 00 00       	mov    $0x8,%eax
80102cbd:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cbe:	89 ca                	mov    %ecx,%edx
80102cc0:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102cc1:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cc4:	89 fa                	mov    %edi,%edx
80102cc6:	89 45 c8             	mov    %eax,-0x38(%ebp)
80102cc9:	b8 09 00 00 00       	mov    $0x9,%eax
80102cce:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ccf:	89 ca                	mov    %ecx,%edx
80102cd1:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102cd2:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cd5:	89 fa                	mov    %edi,%edx
80102cd7:	89 45 cc             	mov    %eax,-0x34(%ebp)
80102cda:	b8 0a 00 00 00       	mov    $0xa,%eax
80102cdf:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ce0:	89 ca                	mov    %ecx,%edx
80102ce2:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102ce3:	84 c0                	test   %al,%al
80102ce5:	78 89                	js     80102c70 <cmostime+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ce7:	89 d8                	mov    %ebx,%eax
80102ce9:	89 fa                	mov    %edi,%edx
80102ceb:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cec:	89 ca                	mov    %ecx,%edx
80102cee:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
80102cef:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cf2:	89 fa                	mov    %edi,%edx
80102cf4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102cf7:	b8 02 00 00 00       	mov    $0x2,%eax
80102cfc:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cfd:	89 ca                	mov    %ecx,%edx
80102cff:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102d00:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d03:	89 fa                	mov    %edi,%edx
80102d05:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102d08:	b8 04 00 00 00       	mov    $0x4,%eax
80102d0d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d0e:	89 ca                	mov    %ecx,%edx
80102d10:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102d11:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d14:	89 fa                	mov    %edi,%edx
80102d16:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102d19:	b8 07 00 00 00       	mov    $0x7,%eax
80102d1e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d1f:	89 ca                	mov    %ecx,%edx
80102d21:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102d22:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d25:	89 fa                	mov    %edi,%edx
80102d27:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102d2a:	b8 08 00 00 00       	mov    $0x8,%eax
80102d2f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d30:	89 ca                	mov    %ecx,%edx
80102d32:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102d33:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d36:	89 fa                	mov    %edi,%edx
80102d38:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102d3b:	b8 09 00 00 00       	mov    $0x9,%eax
80102d40:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d41:	89 ca                	mov    %ecx,%edx
80102d43:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102d44:	0f b6 c0             	movzbl %al,%eax
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102d47:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
80102d4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102d4d:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102d50:	6a 18                	push   $0x18
80102d52:	56                   	push   %esi
80102d53:	50                   	push   %eax
80102d54:	e8 27 21 00 00       	call   80104e80 <memcmp>
80102d59:	83 c4 10             	add    $0x10,%esp
80102d5c:	85 c0                	test   %eax,%eax
80102d5e:	0f 85 0c ff ff ff    	jne    80102c70 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102d64:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102d68:	75 78                	jne    80102de2 <cmostime+0x1a2>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102d6a:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d6d:	89 c2                	mov    %eax,%edx
80102d6f:	83 e0 0f             	and    $0xf,%eax
80102d72:	c1 ea 04             	shr    $0x4,%edx
80102d75:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d78:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d7b:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102d7e:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d81:	89 c2                	mov    %eax,%edx
80102d83:	83 e0 0f             	and    $0xf,%eax
80102d86:	c1 ea 04             	shr    $0x4,%edx
80102d89:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d8c:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d8f:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102d92:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d95:	89 c2                	mov    %eax,%edx
80102d97:	83 e0 0f             	and    $0xf,%eax
80102d9a:	c1 ea 04             	shr    $0x4,%edx
80102d9d:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102da0:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102da3:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102da6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102da9:	89 c2                	mov    %eax,%edx
80102dab:	83 e0 0f             	and    $0xf,%eax
80102dae:	c1 ea 04             	shr    $0x4,%edx
80102db1:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102db4:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102db7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102dba:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102dbd:	89 c2                	mov    %eax,%edx
80102dbf:	83 e0 0f             	and    $0xf,%eax
80102dc2:	c1 ea 04             	shr    $0x4,%edx
80102dc5:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102dc8:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102dcb:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102dce:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102dd1:	89 c2                	mov    %eax,%edx
80102dd3:	83 e0 0f             	and    $0xf,%eax
80102dd6:	c1 ea 04             	shr    $0x4,%edx
80102dd9:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ddc:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ddf:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102de2:	8b 75 08             	mov    0x8(%ebp),%esi
80102de5:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102de8:	89 06                	mov    %eax,(%esi)
80102dea:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ded:	89 46 04             	mov    %eax,0x4(%esi)
80102df0:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102df3:	89 46 08             	mov    %eax,0x8(%esi)
80102df6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102df9:	89 46 0c             	mov    %eax,0xc(%esi)
80102dfc:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102dff:	89 46 10             	mov    %eax,0x10(%esi)
80102e02:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102e05:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102e08:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102e0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e12:	5b                   	pop    %ebx
80102e13:	5e                   	pop    %esi
80102e14:	5f                   	pop    %edi
80102e15:	5d                   	pop    %ebp
80102e16:	c3                   	ret    
80102e17:	66 90                	xchg   %ax,%ax
80102e19:	66 90                	xchg   %ax,%ax
80102e1b:	66 90                	xchg   %ax,%ax
80102e1d:	66 90                	xchg   %ax,%ax
80102e1f:	90                   	nop

80102e20 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102e20:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80102e26:	85 c9                	test   %ecx,%ecx
80102e28:	0f 8e 85 00 00 00    	jle    80102eb3 <install_trans+0x93>
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102e2e:	55                   	push   %ebp
80102e2f:	89 e5                	mov    %esp,%ebp
80102e31:	57                   	push   %edi
80102e32:	56                   	push   %esi
80102e33:	53                   	push   %ebx
80102e34:	31 db                	xor    %ebx,%ebx
80102e36:	83 ec 0c             	sub    $0xc,%esp
80102e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102e40:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102e45:	83 ec 08             	sub    $0x8,%esp
80102e48:	01 d8                	add    %ebx,%eax
80102e4a:	83 c0 01             	add    $0x1,%eax
80102e4d:	50                   	push   %eax
80102e4e:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102e54:	e8 77 d2 ff ff       	call   801000d0 <bread>
80102e59:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102e5b:	58                   	pop    %eax
80102e5c:	5a                   	pop    %edx
80102e5d:	ff 34 9d ec 36 11 80 	pushl  -0x7feec914(,%ebx,4)
80102e64:	ff 35 e4 36 11 80    	pushl  0x801136e4
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102e6a:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102e6d:	e8 5e d2 ff ff       	call   801000d0 <bread>
80102e72:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102e74:	8d 47 5c             	lea    0x5c(%edi),%eax
80102e77:	83 c4 0c             	add    $0xc,%esp
80102e7a:	68 00 02 00 00       	push   $0x200
80102e7f:	50                   	push   %eax
80102e80:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e83:	50                   	push   %eax
80102e84:	e8 57 20 00 00       	call   80104ee0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102e89:	89 34 24             	mov    %esi,(%esp)
80102e8c:	e8 0f d3 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102e91:	89 3c 24             	mov    %edi,(%esp)
80102e94:	e8 47 d3 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102e99:	89 34 24             	mov    %esi,(%esp)
80102e9c:	e8 3f d3 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ea1:	83 c4 10             	add    $0x10,%esp
80102ea4:	39 1d e8 36 11 80    	cmp    %ebx,0x801136e8
80102eaa:	7f 94                	jg     80102e40 <install_trans+0x20>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102eac:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eaf:	5b                   	pop    %ebx
80102eb0:	5e                   	pop    %esi
80102eb1:	5f                   	pop    %edi
80102eb2:	5d                   	pop    %ebp
80102eb3:	f3 c3                	repz ret 
80102eb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ec0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ec0:	55                   	push   %ebp
80102ec1:	89 e5                	mov    %esp,%ebp
80102ec3:	53                   	push   %ebx
80102ec4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ec7:	ff 35 d4 36 11 80    	pushl  0x801136d4
80102ecd:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102ed3:	e8 f8 d1 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102ed8:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102ede:	83 c4 10             	add    $0x10,%esp
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102ee1:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102ee3:	85 c9                	test   %ecx,%ecx
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102ee5:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102ee8:	7e 1f                	jle    80102f09 <write_head+0x49>
80102eea:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
80102ef1:	31 d2                	xor    %edx,%edx
80102ef3:	90                   	nop
80102ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102ef8:	8b 8a ec 36 11 80    	mov    -0x7feec914(%edx),%ecx
80102efe:	89 4c 13 60          	mov    %ecx,0x60(%ebx,%edx,1)
80102f02:	83 c2 04             	add    $0x4,%edx
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102f05:	39 c2                	cmp    %eax,%edx
80102f07:	75 ef                	jne    80102ef8 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102f09:	83 ec 0c             	sub    $0xc,%esp
80102f0c:	53                   	push   %ebx
80102f0d:	e8 8e d2 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102f12:	89 1c 24             	mov    %ebx,(%esp)
80102f15:	e8 c6 d2 ff ff       	call   801001e0 <brelse>
}
80102f1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f1d:	c9                   	leave  
80102f1e:	c3                   	ret    
80102f1f:	90                   	nop

80102f20 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102f20:	55                   	push   %ebp
80102f21:	89 e5                	mov    %esp,%ebp
80102f23:	53                   	push   %ebx
80102f24:	83 ec 2c             	sub    $0x2c,%esp
80102f27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102f2a:	68 e0 84 10 80       	push   $0x801084e0
80102f2f:	68 a0 36 11 80       	push   $0x801136a0
80102f34:	e8 67 1c 00 00       	call   80104ba0 <initlock>
  readsb(dev, &sb);
80102f39:	58                   	pop    %eax
80102f3a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102f3d:	5a                   	pop    %edx
80102f3e:	50                   	push   %eax
80102f3f:	53                   	push   %ebx
80102f40:	e8 fb e4 ff ff       	call   80101440 <readsb>
  log.start = sb.logstart;
  log.size = sb.nlog;
80102f45:	8b 55 e8             	mov    -0x18(%ebp),%edx
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102f48:	8b 45 ec             	mov    -0x14(%ebp),%eax

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102f4b:	59                   	pop    %ecx
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102f4c:	89 1d e4 36 11 80    	mov    %ebx,0x801136e4

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102f52:	89 15 d8 36 11 80    	mov    %edx,0x801136d8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102f58:	a3 d4 36 11 80       	mov    %eax,0x801136d4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102f5d:	5a                   	pop    %edx
80102f5e:	50                   	push   %eax
80102f5f:	53                   	push   %ebx
80102f60:	e8 6b d1 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102f65:	8b 48 5c             	mov    0x5c(%eax),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f68:	83 c4 10             	add    $0x10,%esp
80102f6b:	85 c9                	test   %ecx,%ecx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102f6d:	89 0d e8 36 11 80    	mov    %ecx,0x801136e8
  for (i = 0; i < log.lh.n; i++) {
80102f73:	7e 1c                	jle    80102f91 <initlog+0x71>
80102f75:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
80102f7c:	31 d2                	xor    %edx,%edx
80102f7e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102f80:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102f84:	83 c2 04             	add    $0x4,%edx
80102f87:	89 8a e8 36 11 80    	mov    %ecx,-0x7feec918(%edx)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102f8d:	39 da                	cmp    %ebx,%edx
80102f8f:	75 ef                	jne    80102f80 <initlog+0x60>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102f91:	83 ec 0c             	sub    $0xc,%esp
80102f94:	50                   	push   %eax
80102f95:	e8 46 d2 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102f9a:	e8 81 fe ff ff       	call   80102e20 <install_trans>
  log.lh.n = 0;
80102f9f:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
80102fa6:	00 00 00 
  write_head(); // clear the log
80102fa9:	e8 12 ff ff ff       	call   80102ec0 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102fae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102fb1:	c9                   	leave  
80102fb2:	c3                   	ret    
80102fb3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102fc0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102fc0:	55                   	push   %ebp
80102fc1:	89 e5                	mov    %esp,%ebp
80102fc3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102fc6:	68 a0 36 11 80       	push   $0x801136a0
80102fcb:	e8 d0 1c 00 00       	call   80104ca0 <acquire>
80102fd0:	83 c4 10             	add    $0x10,%esp
80102fd3:	eb 18                	jmp    80102fed <begin_op+0x2d>
80102fd5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102fd8:	83 ec 08             	sub    $0x8,%esp
80102fdb:	68 a0 36 11 80       	push   $0x801136a0
80102fe0:	68 a0 36 11 80       	push   $0x801136a0
80102fe5:	e8 86 13 00 00       	call   80104370 <sleep>
80102fea:	83 c4 10             	add    $0x10,%esp
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102fed:	a1 e0 36 11 80       	mov    0x801136e0,%eax
80102ff2:	85 c0                	test   %eax,%eax
80102ff4:	75 e2                	jne    80102fd8 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102ff6:	a1 dc 36 11 80       	mov    0x801136dc,%eax
80102ffb:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
80103001:	83 c0 01             	add    $0x1,%eax
80103004:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80103007:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010300a:	83 fa 1e             	cmp    $0x1e,%edx
8010300d:	7f c9                	jg     80102fd8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
8010300f:	83 ec 0c             	sub    $0xc,%esp
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80103012:	a3 dc 36 11 80       	mov    %eax,0x801136dc
      release(&log.lock);
80103017:	68 a0 36 11 80       	push   $0x801136a0
8010301c:	e8 bf 1d 00 00       	call   80104de0 <release>
      break;
    }
  }
}
80103021:	83 c4 10             	add    $0x10,%esp
80103024:	c9                   	leave  
80103025:	c3                   	ret    
80103026:	8d 76 00             	lea    0x0(%esi),%esi
80103029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103030 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103030:	55                   	push   %ebp
80103031:	89 e5                	mov    %esp,%ebp
80103033:	57                   	push   %edi
80103034:	56                   	push   %esi
80103035:	53                   	push   %ebx
80103036:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103039:	68 a0 36 11 80       	push   $0x801136a0
8010303e:	e8 5d 1c 00 00       	call   80104ca0 <acquire>
  log.outstanding -= 1;
80103043:	a1 dc 36 11 80       	mov    0x801136dc,%eax
  if(log.committing)
80103048:	8b 1d e0 36 11 80    	mov    0x801136e0,%ebx
8010304e:	83 c4 10             	add    $0x10,%esp
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80103051:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80103054:	85 db                	test   %ebx,%ebx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80103056:	a3 dc 36 11 80       	mov    %eax,0x801136dc
  if(log.committing)
8010305b:	0f 85 23 01 00 00    	jne    80103184 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103061:	85 c0                	test   %eax,%eax
80103063:	0f 85 f7 00 00 00    	jne    80103160 <end_op+0x130>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103069:	83 ec 0c             	sub    $0xc,%esp
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
8010306c:	c7 05 e0 36 11 80 01 	movl   $0x1,0x801136e0
80103073:	00 00 00 
}

static void
commit()
{
  if (log.lh.n > 0) {
80103076:	31 db                	xor    %ebx,%ebx
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103078:	68 a0 36 11 80       	push   $0x801136a0
8010307d:	e8 5e 1d 00 00       	call   80104de0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103082:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80103088:	83 c4 10             	add    $0x10,%esp
8010308b:	85 c9                	test   %ecx,%ecx
8010308d:	0f 8e 8a 00 00 00    	jle    8010311d <end_op+0xed>
80103093:	90                   	nop
80103094:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103098:	a1 d4 36 11 80       	mov    0x801136d4,%eax
8010309d:	83 ec 08             	sub    $0x8,%esp
801030a0:	01 d8                	add    %ebx,%eax
801030a2:	83 c0 01             	add    $0x1,%eax
801030a5:	50                   	push   %eax
801030a6:	ff 35 e4 36 11 80    	pushl  0x801136e4
801030ac:	e8 1f d0 ff ff       	call   801000d0 <bread>
801030b1:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801030b3:	58                   	pop    %eax
801030b4:	5a                   	pop    %edx
801030b5:	ff 34 9d ec 36 11 80 	pushl  -0x7feec914(,%ebx,4)
801030bc:	ff 35 e4 36 11 80    	pushl  0x801136e4
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801030c2:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801030c5:	e8 06 d0 ff ff       	call   801000d0 <bread>
801030ca:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801030cc:	8d 40 5c             	lea    0x5c(%eax),%eax
801030cf:	83 c4 0c             	add    $0xc,%esp
801030d2:	68 00 02 00 00       	push   $0x200
801030d7:	50                   	push   %eax
801030d8:	8d 46 5c             	lea    0x5c(%esi),%eax
801030db:	50                   	push   %eax
801030dc:	e8 ff 1d 00 00       	call   80104ee0 <memmove>
    bwrite(to);  // write the log
801030e1:	89 34 24             	mov    %esi,(%esp)
801030e4:	e8 b7 d0 ff ff       	call   801001a0 <bwrite>
    brelse(from);
801030e9:	89 3c 24             	mov    %edi,(%esp)
801030ec:	e8 ef d0 ff ff       	call   801001e0 <brelse>
    brelse(to);
801030f1:	89 34 24             	mov    %esi,(%esp)
801030f4:	e8 e7 d0 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801030f9:	83 c4 10             	add    $0x10,%esp
801030fc:	3b 1d e8 36 11 80    	cmp    0x801136e8,%ebx
80103102:	7c 94                	jl     80103098 <end_op+0x68>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80103104:	e8 b7 fd ff ff       	call   80102ec0 <write_head>
    install_trans(); // Now install writes to home locations
80103109:	e8 12 fd ff ff       	call   80102e20 <install_trans>
    log.lh.n = 0;
8010310e:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
80103115:	00 00 00 
    write_head();    // Erase the transaction from the log
80103118:	e8 a3 fd ff ff       	call   80102ec0 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
8010311d:	83 ec 0c             	sub    $0xc,%esp
80103120:	68 a0 36 11 80       	push   $0x801136a0
80103125:	e8 76 1b 00 00       	call   80104ca0 <acquire>
    log.committing = 0;
    wakeup(&log);
8010312a:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
    log.committing = 0;
80103131:	c7 05 e0 36 11 80 00 	movl   $0x0,0x801136e0
80103138:	00 00 00 
    wakeup(&log);
8010313b:	e8 f0 13 00 00       	call   80104530 <wakeup>
    release(&log.lock);
80103140:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80103147:	e8 94 1c 00 00       	call   80104de0 <release>
8010314c:	83 c4 10             	add    $0x10,%esp
  }
}
8010314f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103152:	5b                   	pop    %ebx
80103153:	5e                   	pop    %esi
80103154:	5f                   	pop    %edi
80103155:	5d                   	pop    %ebp
80103156:	c3                   	ret    
80103157:	89 f6                	mov    %esi,%esi
80103159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
80103160:	83 ec 0c             	sub    $0xc,%esp
80103163:	68 a0 36 11 80       	push   $0x801136a0
80103168:	e8 c3 13 00 00       	call   80104530 <wakeup>
  }
  release(&log.lock);
8010316d:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80103174:	e8 67 1c 00 00       	call   80104de0 <release>
80103179:	83 c4 10             	add    $0x10,%esp
    acquire(&log.lock);
    log.committing = 0;
    wakeup(&log);
    release(&log.lock);
  }
}
8010317c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010317f:	5b                   	pop    %ebx
80103180:	5e                   	pop    %esi
80103181:	5f                   	pop    %edi
80103182:	5d                   	pop    %ebp
80103183:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80103184:	83 ec 0c             	sub    $0xc,%esp
80103187:	68 e4 84 10 80       	push   $0x801084e4
8010318c:	e8 df d1 ff ff       	call   80100370 <panic>
80103191:	eb 0d                	jmp    801031a0 <log_write>
80103193:	90                   	nop
80103194:	90                   	nop
80103195:	90                   	nop
80103196:	90                   	nop
80103197:	90                   	nop
80103198:	90                   	nop
80103199:	90                   	nop
8010319a:	90                   	nop
8010319b:	90                   	nop
8010319c:	90                   	nop
8010319d:	90                   	nop
8010319e:	90                   	nop
8010319f:	90                   	nop

801031a0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801031a0:	55                   	push   %ebp
801031a1:	89 e5                	mov    %esp,%ebp
801031a3:	53                   	push   %ebx
801031a4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801031a7:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801031ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801031b0:	83 fa 1d             	cmp    $0x1d,%edx
801031b3:	0f 8f 97 00 00 00    	jg     80103250 <log_write+0xb0>
801031b9:	a1 d8 36 11 80       	mov    0x801136d8,%eax
801031be:	83 e8 01             	sub    $0x1,%eax
801031c1:	39 c2                	cmp    %eax,%edx
801031c3:	0f 8d 87 00 00 00    	jge    80103250 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
801031c9:	a1 dc 36 11 80       	mov    0x801136dc,%eax
801031ce:	85 c0                	test   %eax,%eax
801031d0:	0f 8e 87 00 00 00    	jle    8010325d <log_write+0xbd>
    panic("log_write outside of trans");

  acquire(&log.lock);
801031d6:	83 ec 0c             	sub    $0xc,%esp
801031d9:	68 a0 36 11 80       	push   $0x801136a0
801031de:	e8 bd 1a 00 00       	call   80104ca0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801031e3:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
801031e9:	83 c4 10             	add    $0x10,%esp
801031ec:	83 fa 00             	cmp    $0x0,%edx
801031ef:	7e 50                	jle    80103241 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801031f1:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
801031f4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801031f6:	3b 0d ec 36 11 80    	cmp    0x801136ec,%ecx
801031fc:	75 0b                	jne    80103209 <log_write+0x69>
801031fe:	eb 38                	jmp    80103238 <log_write+0x98>
80103200:	39 0c 85 ec 36 11 80 	cmp    %ecx,-0x7feec914(,%eax,4)
80103207:	74 2f                	je     80103238 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103209:	83 c0 01             	add    $0x1,%eax
8010320c:	39 d0                	cmp    %edx,%eax
8010320e:	75 f0                	jne    80103200 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80103210:	89 0c 95 ec 36 11 80 	mov    %ecx,-0x7feec914(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80103217:	83 c2 01             	add    $0x1,%edx
8010321a:	89 15 e8 36 11 80    	mov    %edx,0x801136e8
  b->flags |= B_DIRTY; // prevent eviction
80103220:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80103223:	c7 45 08 a0 36 11 80 	movl   $0x801136a0,0x8(%ebp)
}
8010322a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010322d:	c9                   	leave  
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
8010322e:	e9 ad 1b 00 00       	jmp    80104de0 <release>
80103233:	90                   	nop
80103234:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80103238:	89 0c 85 ec 36 11 80 	mov    %ecx,-0x7feec914(,%eax,4)
8010323f:	eb df                	jmp    80103220 <log_write+0x80>
80103241:	8b 43 08             	mov    0x8(%ebx),%eax
80103244:	a3 ec 36 11 80       	mov    %eax,0x801136ec
  if (i == log.lh.n)
80103249:	75 d5                	jne    80103220 <log_write+0x80>
8010324b:	eb ca                	jmp    80103217 <log_write+0x77>
8010324d:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80103250:	83 ec 0c             	sub    $0xc,%esp
80103253:	68 f3 84 10 80       	push   $0x801084f3
80103258:	e8 13 d1 ff ff       	call   80100370 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
8010325d:	83 ec 0c             	sub    $0xc,%esp
80103260:	68 09 85 10 80       	push   $0x80108509
80103265:	e8 06 d1 ff ff       	call   80100370 <panic>
8010326a:	66 90                	xchg   %ax,%ax
8010326c:	66 90                	xchg   %ax,%ax
8010326e:	66 90                	xchg   %ax,%ax

80103270 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103270:	55                   	push   %ebp
80103271:	89 e5                	mov    %esp,%ebp
80103273:	53                   	push   %ebx
80103274:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103277:	e8 e4 09 00 00       	call   80103c60 <cpuid>
8010327c:	89 c3                	mov    %eax,%ebx
8010327e:	e8 dd 09 00 00       	call   80103c60 <cpuid>
80103283:	83 ec 04             	sub    $0x4,%esp
80103286:	53                   	push   %ebx
80103287:	50                   	push   %eax
80103288:	68 24 85 10 80       	push   $0x80108524
8010328d:	e8 ce d3 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80103292:	e8 c9 2e 00 00       	call   80106160 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103297:	e8 44 09 00 00       	call   80103be0 <mycpu>
8010329c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010329e:	b8 01 00 00 00       	mov    $0x1,%eax
801032a3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801032aa:	e8 21 17 00 00       	call   801049d0 <scheduler>
801032af:	90                   	nop

801032b0 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801032b0:	55                   	push   %ebp
801032b1:	89 e5                	mov    %esp,%ebp
801032b3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801032b6:	e8 a5 42 00 00       	call   80107560 <switchkvm>
  seginit();
801032bb:	e8 60 41 00 00       	call   80107420 <seginit>
  lapicinit();
801032c0:	e8 9b f7 ff ff       	call   80102a60 <lapicinit>
  mpmain();
801032c5:	e8 a6 ff ff ff       	call   80103270 <mpmain>
801032ca:	66 90                	xchg   %ax,%ax
801032cc:	66 90                	xchg   %ax,%ax
801032ce:	66 90                	xchg   %ax,%ax

801032d0 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
801032d0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801032d4:	83 e4 f0             	and    $0xfffffff0,%esp
801032d7:	ff 71 fc             	pushl  -0x4(%ecx)
801032da:	55                   	push   %ebp
801032db:	89 e5                	mov    %esp,%ebp
801032dd:	53                   	push   %ebx
801032de:	51                   	push   %ecx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
801032df:	bb a0 37 11 80       	mov    $0x801137a0,%ebx
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801032e4:	83 ec 08             	sub    $0x8,%esp
801032e7:	68 00 00 40 80       	push   $0x80400000
801032ec:	68 c8 eb 11 80       	push   $0x8011ebc8
801032f1:	e8 1a f5 ff ff       	call   80102810 <kinit1>
  kvmalloc();      // kernel page table
801032f6:	e8 05 46 00 00       	call   80107900 <kvmalloc>
  mpinit();        // detect other processors
801032fb:	e8 70 01 00 00       	call   80103470 <mpinit>
  lapicinit();     // interrupt controller
80103300:	e8 5b f7 ff ff       	call   80102a60 <lapicinit>
  seginit();       // segment descriptors
80103305:	e8 16 41 00 00       	call   80107420 <seginit>
  picinit();       // disable pic
8010330a:	e8 31 03 00 00       	call   80103640 <picinit>
  ioapicinit();    // another interrupt controller
8010330f:	e8 0c f3 ff ff       	call   80102620 <ioapicinit>
  consoleinit();   // console hardware
80103314:	e8 87 d6 ff ff       	call   801009a0 <consoleinit>
  uartinit();      // serial port
80103319:	e8 d2 31 00 00       	call   801064f0 <uartinit>
  pinit();         // process table
8010331e:	e8 9d 08 00 00       	call   80103bc0 <pinit>
  tvinit();        // trap vectors
80103323:	e8 98 2d 00 00       	call   801060c0 <tvinit>
  binit();         // buffer cache
80103328:	e8 13 cd ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010332d:	e8 ae da ff ff       	call   80100de0 <fileinit>
  ideinit();       // disk 
80103332:	e8 c9 f0 ff ff       	call   80102400 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103337:	83 c4 0c             	add    $0xc,%esp
8010333a:	68 8a 00 00 00       	push   $0x8a
8010333f:	68 8c b4 10 80       	push   $0x8010b48c
80103344:	68 00 70 00 80       	push   $0x80007000
80103349:	e8 92 1b 00 00       	call   80104ee0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010334e:	69 05 20 3d 11 80 b0 	imul   $0xb0,0x80113d20,%eax
80103355:	00 00 00 
80103358:	83 c4 10             	add    $0x10,%esp
8010335b:	05 a0 37 11 80       	add    $0x801137a0,%eax
80103360:	39 d8                	cmp    %ebx,%eax
80103362:	76 6f                	jbe    801033d3 <main+0x103>
80103364:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80103368:	e8 73 08 00 00       	call   80103be0 <mycpu>
8010336d:	39 d8                	cmp    %ebx,%eax
8010336f:	74 49                	je     801033ba <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103371:	e8 8a f5 ff ff       	call   80102900 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80103376:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
8010337b:	c7 05 f8 6f 00 80 b0 	movl   $0x801032b0,0x80006ff8
80103382:	32 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103385:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010338c:	a0 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
8010338f:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103394:	0f b6 03             	movzbl (%ebx),%eax
80103397:	83 ec 08             	sub    $0x8,%esp
8010339a:	68 00 70 00 00       	push   $0x7000
8010339f:	50                   	push   %eax
801033a0:	e8 0b f8 ff ff       	call   80102bb0 <lapicstartap>
801033a5:	83 c4 10             	add    $0x10,%esp
801033a8:	90                   	nop
801033a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801033b0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801033b6:	85 c0                	test   %eax,%eax
801033b8:	74 f6                	je     801033b0 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
801033ba:	69 05 20 3d 11 80 b0 	imul   $0xb0,0x80113d20,%eax
801033c1:	00 00 00 
801033c4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801033ca:	05 a0 37 11 80       	add    $0x801137a0,%eax
801033cf:	39 c3                	cmp    %eax,%ebx
801033d1:	72 95                	jb     80103368 <main+0x98>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801033d3:	83 ec 08             	sub    $0x8,%esp
801033d6:	68 00 00 00 8e       	push   $0x8e000000
801033db:	68 00 00 40 80       	push   $0x80400000
801033e0:	e8 bb f4 ff ff       	call   801028a0 <kinit2>
  userinit();      // first user process
801033e5:	e8 c6 08 00 00       	call   80103cb0 <userinit>
  mpmain();        // finish this processor's setup
801033ea:	e8 81 fe ff ff       	call   80103270 <mpmain>
801033ef:	90                   	nop

801033f0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801033f0:	55                   	push   %ebp
801033f1:	89 e5                	mov    %esp,%ebp
801033f3:	57                   	push   %edi
801033f4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801033f5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801033fb:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
801033fc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801033ff:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103402:	39 de                	cmp    %ebx,%esi
80103404:	73 48                	jae    8010344e <mpsearch1+0x5e>
80103406:	8d 76 00             	lea    0x0(%esi),%esi
80103409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103410:	83 ec 04             	sub    $0x4,%esp
80103413:	8d 7e 10             	lea    0x10(%esi),%edi
80103416:	6a 04                	push   $0x4
80103418:	68 38 85 10 80       	push   $0x80108538
8010341d:	56                   	push   %esi
8010341e:	e8 5d 1a 00 00       	call   80104e80 <memcmp>
80103423:	83 c4 10             	add    $0x10,%esp
80103426:	85 c0                	test   %eax,%eax
80103428:	75 1e                	jne    80103448 <mpsearch1+0x58>
8010342a:	8d 7e 10             	lea    0x10(%esi),%edi
8010342d:	89 f2                	mov    %esi,%edx
8010342f:	31 c9                	xor    %ecx,%ecx
80103431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80103438:	0f b6 02             	movzbl (%edx),%eax
8010343b:	83 c2 01             	add    $0x1,%edx
8010343e:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103440:	39 fa                	cmp    %edi,%edx
80103442:	75 f4                	jne    80103438 <mpsearch1+0x48>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103444:	84 c9                	test   %cl,%cl
80103446:	74 10                	je     80103458 <mpsearch1+0x68>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103448:	39 fb                	cmp    %edi,%ebx
8010344a:	89 fe                	mov    %edi,%esi
8010344c:	77 c2                	ja     80103410 <mpsearch1+0x20>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
8010344e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103451:	31 c0                	xor    %eax,%eax
}
80103453:	5b                   	pop    %ebx
80103454:	5e                   	pop    %esi
80103455:	5f                   	pop    %edi
80103456:	5d                   	pop    %ebp
80103457:	c3                   	ret    
80103458:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010345b:	89 f0                	mov    %esi,%eax
8010345d:	5b                   	pop    %ebx
8010345e:	5e                   	pop    %esi
8010345f:	5f                   	pop    %edi
80103460:	5d                   	pop    %ebp
80103461:	c3                   	ret    
80103462:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103470 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103470:	55                   	push   %ebp
80103471:	89 e5                	mov    %esp,%ebp
80103473:	57                   	push   %edi
80103474:	56                   	push   %esi
80103475:	53                   	push   %ebx
80103476:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103479:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103480:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103487:	c1 e0 08             	shl    $0x8,%eax
8010348a:	09 d0                	or     %edx,%eax
8010348c:	c1 e0 04             	shl    $0x4,%eax
8010348f:	85 c0                	test   %eax,%eax
80103491:	75 1b                	jne    801034ae <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
80103493:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010349a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801034a1:	c1 e0 08             	shl    $0x8,%eax
801034a4:	09 d0                	or     %edx,%eax
801034a6:	c1 e0 0a             	shl    $0xa,%eax
801034a9:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
801034ae:	ba 00 04 00 00       	mov    $0x400,%edx
801034b3:	e8 38 ff ff ff       	call   801033f0 <mpsearch1>
801034b8:	85 c0                	test   %eax,%eax
801034ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801034bd:	0f 84 37 01 00 00    	je     801035fa <mpinit+0x18a>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801034c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801034c6:	8b 58 04             	mov    0x4(%eax),%ebx
801034c9:	85 db                	test   %ebx,%ebx
801034cb:	0f 84 43 01 00 00    	je     80103614 <mpinit+0x1a4>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801034d1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801034d7:	83 ec 04             	sub    $0x4,%esp
801034da:	6a 04                	push   $0x4
801034dc:	68 3d 85 10 80       	push   $0x8010853d
801034e1:	56                   	push   %esi
801034e2:	e8 99 19 00 00       	call   80104e80 <memcmp>
801034e7:	83 c4 10             	add    $0x10,%esp
801034ea:	85 c0                	test   %eax,%eax
801034ec:	0f 85 22 01 00 00    	jne    80103614 <mpinit+0x1a4>
    return 0;
  if(conf->version != 1 && conf->version != 4)
801034f2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801034f9:	3c 01                	cmp    $0x1,%al
801034fb:	74 08                	je     80103505 <mpinit+0x95>
801034fd:	3c 04                	cmp    $0x4,%al
801034ff:	0f 85 0f 01 00 00    	jne    80103614 <mpinit+0x1a4>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103505:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010350c:	85 ff                	test   %edi,%edi
8010350e:	74 21                	je     80103531 <mpinit+0xc1>
80103510:	31 d2                	xor    %edx,%edx
80103512:	31 c0                	xor    %eax,%eax
80103514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103518:	0f b6 8c 03 00 00 00 	movzbl -0x80000000(%ebx,%eax,1),%ecx
8010351f:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103520:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103523:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103525:	39 c7                	cmp    %eax,%edi
80103527:	75 ef                	jne    80103518 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103529:	84 d2                	test   %dl,%dl
8010352b:	0f 85 e3 00 00 00    	jne    80103614 <mpinit+0x1a4>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103531:	85 f6                	test   %esi,%esi
80103533:	0f 84 db 00 00 00    	je     80103614 <mpinit+0x1a4>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103539:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010353f:	a3 84 36 11 80       	mov    %eax,0x80113684
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103544:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
8010354b:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
80103551:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103556:	01 d6                	add    %edx,%esi
80103558:	90                   	nop
80103559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103560:	39 c6                	cmp    %eax,%esi
80103562:	76 23                	jbe    80103587 <mpinit+0x117>
80103564:	0f b6 10             	movzbl (%eax),%edx
    switch(*p){
80103567:	80 fa 04             	cmp    $0x4,%dl
8010356a:	0f 87 c0 00 00 00    	ja     80103630 <mpinit+0x1c0>
80103570:	ff 24 95 7c 85 10 80 	jmp    *-0x7fef7a84(,%edx,4)
80103577:	89 f6                	mov    %esi,%esi
80103579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103580:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103583:	39 c6                	cmp    %eax,%esi
80103585:	77 dd                	ja     80103564 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103587:	85 db                	test   %ebx,%ebx
80103589:	0f 84 92 00 00 00    	je     80103621 <mpinit+0x1b1>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010358f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103592:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103596:	74 15                	je     801035ad <mpinit+0x13d>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103598:	ba 22 00 00 00       	mov    $0x22,%edx
8010359d:	b8 70 00 00 00       	mov    $0x70,%eax
801035a2:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801035a3:	ba 23 00 00 00       	mov    $0x23,%edx
801035a8:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801035a9:	83 c8 01             	or     $0x1,%eax
801035ac:	ee                   	out    %al,(%dx)
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
801035ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035b0:	5b                   	pop    %ebx
801035b1:	5e                   	pop    %esi
801035b2:	5f                   	pop    %edi
801035b3:	5d                   	pop    %ebp
801035b4:	c3                   	ret    
801035b5:	8d 76 00             	lea    0x0(%esi),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
801035b8:	8b 0d 20 3d 11 80    	mov    0x80113d20,%ecx
801035be:	83 f9 07             	cmp    $0x7,%ecx
801035c1:	7f 19                	jg     801035dc <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801035c3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801035c7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801035cd:	83 c1 01             	add    $0x1,%ecx
801035d0:	89 0d 20 3d 11 80    	mov    %ecx,0x80113d20
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801035d6:	88 97 a0 37 11 80    	mov    %dl,-0x7feec860(%edi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
801035dc:	83 c0 14             	add    $0x14,%eax
      continue;
801035df:	e9 7c ff ff ff       	jmp    80103560 <mpinit+0xf0>
801035e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
801035e8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801035ec:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
801035ef:	88 15 80 37 11 80    	mov    %dl,0x80113780
      p += sizeof(struct mpioapic);
      continue;
801035f5:	e9 66 ff ff ff       	jmp    80103560 <mpinit+0xf0>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
801035fa:	ba 00 00 01 00       	mov    $0x10000,%edx
801035ff:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103604:	e8 e7 fd ff ff       	call   801033f0 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103609:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010360b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010360e:	0f 85 af fe ff ff    	jne    801034c3 <mpinit+0x53>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
80103614:	83 ec 0c             	sub    $0xc,%esp
80103617:	68 42 85 10 80       	push   $0x80108542
8010361c:	e8 4f cd ff ff       	call   80100370 <panic>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
80103621:	83 ec 0c             	sub    $0xc,%esp
80103624:	68 5c 85 10 80       	push   $0x8010855c
80103629:	e8 42 cd ff ff       	call   80100370 <panic>
8010362e:	66 90                	xchg   %ax,%ax
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
80103630:	31 db                	xor    %ebx,%ebx
80103632:	e9 30 ff ff ff       	jmp    80103567 <mpinit+0xf7>
80103637:	66 90                	xchg   %ax,%ax
80103639:	66 90                	xchg   %ax,%ax
8010363b:	66 90                	xchg   %ax,%ax
8010363d:	66 90                	xchg   %ax,%ax
8010363f:	90                   	nop

80103640 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103640:	55                   	push   %ebp
80103641:	ba 21 00 00 00       	mov    $0x21,%edx
80103646:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010364b:	89 e5                	mov    %esp,%ebp
8010364d:	ee                   	out    %al,(%dx)
8010364e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103653:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103654:	5d                   	pop    %ebp
80103655:	c3                   	ret    
80103656:	66 90                	xchg   %ax,%ax
80103658:	66 90                	xchg   %ax,%ax
8010365a:	66 90                	xchg   %ax,%ax
8010365c:	66 90                	xchg   %ax,%ax
8010365e:	66 90                	xchg   %ax,%ax

80103660 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103660:	55                   	push   %ebp
80103661:	89 e5                	mov    %esp,%ebp
80103663:	57                   	push   %edi
80103664:	56                   	push   %esi
80103665:	53                   	push   %ebx
80103666:	83 ec 0c             	sub    $0xc,%esp
80103669:	8b 75 08             	mov    0x8(%ebp),%esi
8010366c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010366f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103675:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010367b:	e8 80 d7 ff ff       	call   80100e00 <filealloc>
80103680:	85 c0                	test   %eax,%eax
80103682:	89 06                	mov    %eax,(%esi)
80103684:	0f 84 a8 00 00 00    	je     80103732 <pipealloc+0xd2>
8010368a:	e8 71 d7 ff ff       	call   80100e00 <filealloc>
8010368f:	85 c0                	test   %eax,%eax
80103691:	89 03                	mov    %eax,(%ebx)
80103693:	0f 84 87 00 00 00    	je     80103720 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103699:	e8 62 f2 ff ff       	call   80102900 <kalloc>
8010369e:	85 c0                	test   %eax,%eax
801036a0:	89 c7                	mov    %eax,%edi
801036a2:	0f 84 b0 00 00 00    	je     80103758 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801036a8:	83 ec 08             	sub    $0x8,%esp
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
  p->readopen = 1;
801036ab:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801036b2:	00 00 00 
  p->writeopen = 1;
801036b5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801036bc:	00 00 00 
  p->nwrite = 0;
801036bf:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801036c6:	00 00 00 
  p->nread = 0;
801036c9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801036d0:	00 00 00 
  initlock(&p->lock, "pipe");
801036d3:	68 90 85 10 80       	push   $0x80108590
801036d8:	50                   	push   %eax
801036d9:	e8 c2 14 00 00       	call   80104ba0 <initlock>
  (*f0)->type = FD_PIPE;
801036de:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801036e0:	83 c4 10             	add    $0x10,%esp
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
801036e3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801036e9:	8b 06                	mov    (%esi),%eax
801036eb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801036ef:	8b 06                	mov    (%esi),%eax
801036f1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801036f5:	8b 06                	mov    (%esi),%eax
801036f7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801036fa:	8b 03                	mov    (%ebx),%eax
801036fc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103702:	8b 03                	mov    (%ebx),%eax
80103704:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103708:	8b 03                	mov    (%ebx),%eax
8010370a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010370e:	8b 03                	mov    (%ebx),%eax
80103710:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103713:	8d 65 f4             	lea    -0xc(%ebp),%esp
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103716:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103718:	5b                   	pop    %ebx
80103719:	5e                   	pop    %esi
8010371a:	5f                   	pop    %edi
8010371b:	5d                   	pop    %ebp
8010371c:	c3                   	ret    
8010371d:	8d 76 00             	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103720:	8b 06                	mov    (%esi),%eax
80103722:	85 c0                	test   %eax,%eax
80103724:	74 1e                	je     80103744 <pipealloc+0xe4>
    fileclose(*f0);
80103726:	83 ec 0c             	sub    $0xc,%esp
80103729:	50                   	push   %eax
8010372a:	e8 91 d7 ff ff       	call   80100ec0 <fileclose>
8010372f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103732:	8b 03                	mov    (%ebx),%eax
80103734:	85 c0                	test   %eax,%eax
80103736:	74 0c                	je     80103744 <pipealloc+0xe4>
    fileclose(*f1);
80103738:	83 ec 0c             	sub    $0xc,%esp
8010373b:	50                   	push   %eax
8010373c:	e8 7f d7 ff ff       	call   80100ec0 <fileclose>
80103741:	83 c4 10             	add    $0x10,%esp
  return -1;
}
80103744:	8d 65 f4             	lea    -0xc(%ebp),%esp
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
80103747:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010374c:	5b                   	pop    %ebx
8010374d:	5e                   	pop    %esi
8010374e:	5f                   	pop    %edi
8010374f:	5d                   	pop    %ebp
80103750:	c3                   	ret    
80103751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103758:	8b 06                	mov    (%esi),%eax
8010375a:	85 c0                	test   %eax,%eax
8010375c:	75 c8                	jne    80103726 <pipealloc+0xc6>
8010375e:	eb d2                	jmp    80103732 <pipealloc+0xd2>

80103760 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
80103760:	55                   	push   %ebp
80103761:	89 e5                	mov    %esp,%ebp
80103763:	56                   	push   %esi
80103764:	53                   	push   %ebx
80103765:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103768:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010376b:	83 ec 0c             	sub    $0xc,%esp
8010376e:	53                   	push   %ebx
8010376f:	e8 2c 15 00 00       	call   80104ca0 <acquire>
  if(writable){
80103774:	83 c4 10             	add    $0x10,%esp
80103777:	85 f6                	test   %esi,%esi
80103779:	74 45                	je     801037c0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010377b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103781:	83 ec 0c             	sub    $0xc,%esp
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
80103784:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010378b:	00 00 00 
    wakeup(&p->nread);
8010378e:	50                   	push   %eax
8010378f:	e8 9c 0d 00 00       	call   80104530 <wakeup>
80103794:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103797:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010379d:	85 d2                	test   %edx,%edx
8010379f:	75 0a                	jne    801037ab <pipeclose+0x4b>
801037a1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801037a7:	85 c0                	test   %eax,%eax
801037a9:	74 35                	je     801037e0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801037ab:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801037ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037b1:	5b                   	pop    %ebx
801037b2:	5e                   	pop    %esi
801037b3:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801037b4:	e9 27 16 00 00       	jmp    80104de0 <release>
801037b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
801037c0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801037c6:	83 ec 0c             	sub    $0xc,%esp
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
801037c9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801037d0:	00 00 00 
    wakeup(&p->nwrite);
801037d3:	50                   	push   %eax
801037d4:	e8 57 0d 00 00       	call   80104530 <wakeup>
801037d9:	83 c4 10             	add    $0x10,%esp
801037dc:	eb b9                	jmp    80103797 <pipeclose+0x37>
801037de:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
801037e0:	83 ec 0c             	sub    $0xc,%esp
801037e3:	53                   	push   %ebx
801037e4:	e8 f7 15 00 00       	call   80104de0 <release>
    kfree((char*)p);
801037e9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801037ec:	83 c4 10             	add    $0x10,%esp
  } else
    release(&p->lock);
}
801037ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037f2:	5b                   	pop    %ebx
801037f3:	5e                   	pop    %esi
801037f4:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
801037f5:	e9 16 ef ff ff       	jmp    80102710 <kfree>
801037fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103800 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103800:	55                   	push   %ebp
80103801:	89 e5                	mov    %esp,%ebp
80103803:	57                   	push   %edi
80103804:	56                   	push   %esi
80103805:	53                   	push   %ebx
80103806:	83 ec 28             	sub    $0x28,%esp
80103809:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010380c:	53                   	push   %ebx
8010380d:	e8 8e 14 00 00       	call   80104ca0 <acquire>
  for(i = 0; i < n; i++){
80103812:	8b 45 10             	mov    0x10(%ebp),%eax
80103815:	83 c4 10             	add    $0x10,%esp
80103818:	85 c0                	test   %eax,%eax
8010381a:	0f 8e b9 00 00 00    	jle    801038d9 <pipewrite+0xd9>
80103820:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103823:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103829:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010382f:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103835:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103838:	03 4d 10             	add    0x10(%ebp),%ecx
8010383b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010383e:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103844:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
8010384a:	39 d0                	cmp    %edx,%eax
8010384c:	74 38                	je     80103886 <pipewrite+0x86>
8010384e:	eb 59                	jmp    801038a9 <pipewrite+0xa9>
      if(p->readopen == 0 || myproc()->killed){
80103850:	e8 2b 04 00 00       	call   80103c80 <myproc>
80103855:	8b 48 24             	mov    0x24(%eax),%ecx
80103858:	85 c9                	test   %ecx,%ecx
8010385a:	75 34                	jne    80103890 <pipewrite+0x90>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010385c:	83 ec 0c             	sub    $0xc,%esp
8010385f:	57                   	push   %edi
80103860:	e8 cb 0c 00 00       	call   80104530 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103865:	58                   	pop    %eax
80103866:	5a                   	pop    %edx
80103867:	53                   	push   %ebx
80103868:	56                   	push   %esi
80103869:	e8 02 0b 00 00       	call   80104370 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010386e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103874:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010387a:	83 c4 10             	add    $0x10,%esp
8010387d:	05 00 02 00 00       	add    $0x200,%eax
80103882:	39 c2                	cmp    %eax,%edx
80103884:	75 2a                	jne    801038b0 <pipewrite+0xb0>
      if(p->readopen == 0 || myproc()->killed){
80103886:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010388c:	85 c0                	test   %eax,%eax
8010388e:	75 c0                	jne    80103850 <pipewrite+0x50>
        release(&p->lock);
80103890:	83 ec 0c             	sub    $0xc,%esp
80103893:	53                   	push   %ebx
80103894:	e8 47 15 00 00       	call   80104de0 <release>
        return -1;
80103899:	83 c4 10             	add    $0x10,%esp
8010389c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801038a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038a4:	5b                   	pop    %ebx
801038a5:	5e                   	pop    %esi
801038a6:	5f                   	pop    %edi
801038a7:	5d                   	pop    %ebp
801038a8:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801038a9:	89 c2                	mov    %eax,%edx
801038ab:	90                   	nop
801038ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801038b0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801038b3:	8d 42 01             	lea    0x1(%edx),%eax
801038b6:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801038ba:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801038c0:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801038c6:	0f b6 09             	movzbl (%ecx),%ecx
801038c9:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
801038cd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801038d0:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
801038d3:	0f 85 65 ff ff ff    	jne    8010383e <pipewrite+0x3e>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801038d9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801038df:	83 ec 0c             	sub    $0xc,%esp
801038e2:	50                   	push   %eax
801038e3:	e8 48 0c 00 00       	call   80104530 <wakeup>
  release(&p->lock);
801038e8:	89 1c 24             	mov    %ebx,(%esp)
801038eb:	e8 f0 14 00 00       	call   80104de0 <release>
  return n;
801038f0:	83 c4 10             	add    $0x10,%esp
801038f3:	8b 45 10             	mov    0x10(%ebp),%eax
801038f6:	eb a9                	jmp    801038a1 <pipewrite+0xa1>
801038f8:	90                   	nop
801038f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103900 <piperead>:
}

int
piperead(struct pipe *p, char *addr, int n)
{
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	57                   	push   %edi
80103904:	56                   	push   %esi
80103905:	53                   	push   %ebx
80103906:	83 ec 18             	sub    $0x18,%esp
80103909:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010390c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010390f:	53                   	push   %ebx
80103910:	e8 8b 13 00 00       	call   80104ca0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103915:	83 c4 10             	add    $0x10,%esp
80103918:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010391e:	39 83 38 02 00 00    	cmp    %eax,0x238(%ebx)
80103924:	75 6a                	jne    80103990 <piperead+0x90>
80103926:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
8010392c:	85 f6                	test   %esi,%esi
8010392e:	0f 84 cc 00 00 00    	je     80103a00 <piperead+0x100>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103934:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
8010393a:	eb 2d                	jmp    80103969 <piperead+0x69>
8010393c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103940:	83 ec 08             	sub    $0x8,%esp
80103943:	53                   	push   %ebx
80103944:	56                   	push   %esi
80103945:	e8 26 0a 00 00       	call   80104370 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010394a:	83 c4 10             	add    $0x10,%esp
8010394d:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103953:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80103959:	75 35                	jne    80103990 <piperead+0x90>
8010395b:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
80103961:	85 d2                	test   %edx,%edx
80103963:	0f 84 97 00 00 00    	je     80103a00 <piperead+0x100>
    if(myproc()->killed){
80103969:	e8 12 03 00 00       	call   80103c80 <myproc>
8010396e:	8b 48 24             	mov    0x24(%eax),%ecx
80103971:	85 c9                	test   %ecx,%ecx
80103973:	74 cb                	je     80103940 <piperead+0x40>
      release(&p->lock);
80103975:	83 ec 0c             	sub    $0xc,%esp
80103978:	53                   	push   %ebx
80103979:	e8 62 14 00 00       	call   80104de0 <release>
      return -1;
8010397e:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103981:	8d 65 f4             	lea    -0xc(%ebp),%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
      return -1;
80103984:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103989:	5b                   	pop    %ebx
8010398a:	5e                   	pop    %esi
8010398b:	5f                   	pop    %edi
8010398c:	5d                   	pop    %ebp
8010398d:	c3                   	ret    
8010398e:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103990:	8b 45 10             	mov    0x10(%ebp),%eax
80103993:	85 c0                	test   %eax,%eax
80103995:	7e 69                	jle    80103a00 <piperead+0x100>
    if(p->nread == p->nwrite)
80103997:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010399d:	31 c9                	xor    %ecx,%ecx
8010399f:	eb 15                	jmp    801039b6 <piperead+0xb6>
801039a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039a8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801039ae:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
801039b4:	74 5a                	je     80103a10 <piperead+0x110>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801039b6:	8d 70 01             	lea    0x1(%eax),%esi
801039b9:	25 ff 01 00 00       	and    $0x1ff,%eax
801039be:	89 b3 34 02 00 00    	mov    %esi,0x234(%ebx)
801039c4:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
801039c9:	88 04 0f             	mov    %al,(%edi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801039cc:	83 c1 01             	add    $0x1,%ecx
801039cf:	39 4d 10             	cmp    %ecx,0x10(%ebp)
801039d2:	75 d4                	jne    801039a8 <piperead+0xa8>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801039d4:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801039da:	83 ec 0c             	sub    $0xc,%esp
801039dd:	50                   	push   %eax
801039de:	e8 4d 0b 00 00       	call   80104530 <wakeup>
  release(&p->lock);
801039e3:	89 1c 24             	mov    %ebx,(%esp)
801039e6:	e8 f5 13 00 00       	call   80104de0 <release>
  return i;
801039eb:	8b 45 10             	mov    0x10(%ebp),%eax
801039ee:	83 c4 10             	add    $0x10,%esp
}
801039f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039f4:	5b                   	pop    %ebx
801039f5:	5e                   	pop    %esi
801039f6:	5f                   	pop    %edi
801039f7:	5d                   	pop    %ebp
801039f8:	c3                   	ret    
801039f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103a00:	c7 45 10 00 00 00 00 	movl   $0x0,0x10(%ebp)
80103a07:	eb cb                	jmp    801039d4 <piperead+0xd4>
80103a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a10:	89 4d 10             	mov    %ecx,0x10(%ebp)
80103a13:	eb bf                	jmp    801039d4 <piperead+0xd4>
80103a15:	66 90                	xchg   %ax,%ax
80103a17:	66 90                	xchg   %ax,%ax
80103a19:	66 90                	xchg   %ax,%ax
80103a1b:	66 90                	xchg   %ax,%ax
80103a1d:	66 90                	xchg   %ax,%ax
80103a1f:	90                   	nop

80103a20 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103a20:	55                   	push   %ebp
80103a21:	89 e5                	mov    %esp,%ebp
80103a23:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a24:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103a29:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80103a2c:	68 40 3d 11 80       	push   $0x80113d40
80103a31:	e8 6a 12 00 00       	call   80104ca0 <acquire>
80103a36:	83 c4 10             	add    $0x10,%esp
80103a39:	eb 17                	jmp    80103a52 <allocproc+0x32>
80103a3b:	90                   	nop
80103a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a40:	81 c3 98 02 00 00    	add    $0x298,%ebx
80103a46:	81 fb 74 e3 11 80    	cmp    $0x8011e374,%ebx
80103a4c:	0f 84 f6 00 00 00    	je     80103b48 <allocproc+0x128>
    if(p->state == UNUSED)
80103a52:	8b 43 0c             	mov    0xc(%ebx),%eax
80103a55:	85 c0                	test   %eax,%eax
80103a57:	75 e7                	jne    80103a40 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103a59:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103a5e:	83 ec 0c             	sub    $0xc,%esp

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80103a61:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;

  release(&ptable.lock);
80103a68:	68 40 3d 11 80       	push   $0x80113d40
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103a6d:	8d 50 01             	lea    0x1(%eax),%edx
80103a70:	89 43 10             	mov    %eax,0x10(%ebx)
80103a73:	89 15 04 b0 10 80    	mov    %edx,0x8010b004

  release(&ptable.lock);
80103a79:	e8 62 13 00 00       	call   80104de0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103a7e:	e8 7d ee ff ff       	call   80102900 <kalloc>
80103a83:	83 c4 10             	add    $0x10,%esp
80103a86:	85 c0                	test   %eax,%eax
80103a88:	89 43 08             	mov    %eax,0x8(%ebx)
80103a8b:	0f 84 ce 00 00 00    	je     80103b5f <allocproc+0x13f>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103a91:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103a97:	83 ec 04             	sub    $0x4,%esp
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
80103a9a:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103a9f:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
80103aa2:	c7 40 14 b2 60 10 80 	movl   $0x801060b2,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103aa9:	6a 14                	push   $0x14
80103aab:	6a 00                	push   $0x0
80103aad:	50                   	push   %eax
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
80103aae:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103ab1:	e8 7a 13 00 00       	call   80104e30 <memset>
  p->context->eip = (uint)forkret;
80103ab6:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103ab9:	8d 93 14 01 00 00    	lea    0x114(%ebx),%edx
80103abf:	83 c4 10             	add    $0x10,%esp
80103ac2:	c7 40 10 70 3b 10 80 	movl   $0x80103b70,0x10(%eax)
80103ac9:	8d 83 94 00 00 00    	lea    0x94(%ebx),%eax

  #ifndef NONE
  int i;

  /// paging infrastructure
  p->num_of_pages_in_memory = 0;
80103acf:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80103ad6:	00 00 00 
  p->num_of_page_faults = 0;
80103ad9:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80103ae0:	00 00 00 
  p->num_of_currently_swapped_out_pages = 0;
80103ae3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80103aea:	00 00 00 
  p->num_of_total_swap_out_actions = 0;
80103aed:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80103af4:	00 00 00 
80103af7:	89 f6                	mov    %esi,%esi
80103af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  for(i = 0 ; i < MAX_PSYC_PAGES ; i++){
    p->sfm[i].in_swap_file = 0;
80103b00:	c6 00 00             	movb   $0x0,(%eax)
80103b03:	83 c0 08             	add    $0x8,%eax
  p->num_of_pages_in_memory = 0;
  p->num_of_page_faults = 0;
  p->num_of_currently_swapped_out_pages = 0;
  p->num_of_total_swap_out_actions = 0;

  for(i = 0 ; i < MAX_PSYC_PAGES ; i++){
80103b06:	39 d0                	cmp    %edx,%eax
80103b08:	75 f6                	jne    80103b00 <allocproc+0xe0>
80103b0a:	8d 83 24 01 00 00    	lea    0x124(%ebx),%eax
80103b10:	8d 93 a4 02 00 00    	lea    0x2a4(%ebx),%edx
80103b16:	8d 76 00             	lea    0x0(%esi),%esi
80103b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p->sfm[i].in_swap_file = 0;
  }

  for(i = 0 ; i < MAX_PSYC_PAGES ; i++){
    p->mem_pages[i].in_mem = 0;
80103b20:	c6 00 00             	movb   $0x0,(%eax)
80103b23:	83 c0 18             	add    $0x18,%eax

  for(i = 0 ; i < MAX_PSYC_PAGES ; i++){
    p->sfm[i].in_swap_file = 0;
  }

  for(i = 0 ; i < MAX_PSYC_PAGES ; i++){
80103b26:	39 d0                	cmp    %edx,%eax
80103b28:	75 f6                	jne    80103b20 <allocproc+0x100>
    p->mem_pages[i].in_mem = 0;
  }

  p->first = 0;
80103b2a:	c7 83 90 02 00 00 00 	movl   $0x0,0x290(%ebx)
80103b31:	00 00 00 
  p->last = 0;
80103b34:	c7 83 94 02 00 00 00 	movl   $0x0,0x294(%ebx)
80103b3b:	00 00 00 

  #endif

  return p;
80103b3e:	89 d8                	mov    %ebx,%eax
}
80103b40:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b43:	c9                   	leave  
80103b44:	c3                   	ret    
80103b45:	8d 76 00             	lea    0x0(%esi),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80103b48:	83 ec 0c             	sub    $0xc,%esp
80103b4b:	68 40 3d 11 80       	push   $0x80113d40
80103b50:	e8 8b 12 00 00       	call   80104de0 <release>
  return 0;
80103b55:	83 c4 10             	add    $0x10,%esp
80103b58:	31 c0                	xor    %eax,%eax
  p->last = 0;

  #endif

  return p;
}
80103b5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b5d:	c9                   	leave  
80103b5e:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
80103b5f:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103b66:	eb d8                	jmp    80103b40 <allocproc+0x120>
80103b68:	90                   	nop
80103b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103b70 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103b70:	55                   	push   %ebp
80103b71:	89 e5                	mov    %esp,%ebp
80103b73:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103b76:	68 40 3d 11 80       	push   $0x80113d40
80103b7b:	e8 60 12 00 00       	call   80104de0 <release>

  if (first) {
80103b80:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103b85:	83 c4 10             	add    $0x10,%esp
80103b88:	85 c0                	test   %eax,%eax
80103b8a:	75 04                	jne    80103b90 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103b8c:	c9                   	leave  
80103b8d:	c3                   	ret    
80103b8e:	66 90                	xchg   %ax,%ax
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
80103b90:	83 ec 0c             	sub    $0xc,%esp

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80103b93:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103b9a:	00 00 00 
    iinit(ROOTDEV);
80103b9d:	6a 01                	push   $0x1
80103b9f:	e8 5c d9 ff ff       	call   80101500 <iinit>
    initlog(ROOTDEV);
80103ba4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103bab:	e8 70 f3 ff ff       	call   80102f20 <initlog>
80103bb0:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103bb3:	c9                   	leave  
80103bb4:	c3                   	ret    
80103bb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103bc0 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103bc0:	55                   	push   %ebp
80103bc1:	89 e5                	mov    %esp,%ebp
80103bc3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103bc6:	68 95 85 10 80       	push   $0x80108595
80103bcb:	68 40 3d 11 80       	push   $0x80113d40
80103bd0:	e8 cb 0f 00 00       	call   80104ba0 <initlock>
}
80103bd5:	83 c4 10             	add    $0x10,%esp
80103bd8:	c9                   	leave  
80103bd9:	c3                   	ret    
80103bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103be0 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80103be0:	55                   	push   %ebp
80103be1:	89 e5                	mov    %esp,%ebp
80103be3:	56                   	push   %esi
80103be4:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103be5:	9c                   	pushf  
80103be6:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
80103be7:	f6 c4 02             	test   $0x2,%ah
80103bea:	75 5b                	jne    80103c47 <mycpu+0x67>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
80103bec:	e8 6f ef ff ff       	call   80102b60 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103bf1:	8b 35 20 3d 11 80    	mov    0x80113d20,%esi
80103bf7:	85 f6                	test   %esi,%esi
80103bf9:	7e 3f                	jle    80103c3a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103bfb:	0f b6 15 a0 37 11 80 	movzbl 0x801137a0,%edx
80103c02:	39 d0                	cmp    %edx,%eax
80103c04:	74 30                	je     80103c36 <mycpu+0x56>
80103c06:	b9 50 38 11 80       	mov    $0x80113850,%ecx
80103c0b:	31 d2                	xor    %edx,%edx
80103c0d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103c10:	83 c2 01             	add    $0x1,%edx
80103c13:	39 f2                	cmp    %esi,%edx
80103c15:	74 23                	je     80103c3a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103c17:	0f b6 19             	movzbl (%ecx),%ebx
80103c1a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103c20:	39 d8                	cmp    %ebx,%eax
80103c22:	75 ec                	jne    80103c10 <mycpu+0x30>
      return &cpus[i];
80103c24:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
  }
  panic("unknown apicid\n");
}
80103c2a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c2d:	5b                   	pop    %ebx
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
80103c2e:	05 a0 37 11 80       	add    $0x801137a0,%eax
  }
  panic("unknown apicid\n");
}
80103c33:	5e                   	pop    %esi
80103c34:	5d                   	pop    %ebp
80103c35:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103c36:	31 d2                	xor    %edx,%edx
80103c38:	eb ea                	jmp    80103c24 <mycpu+0x44>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
80103c3a:	83 ec 0c             	sub    $0xc,%esp
80103c3d:	68 9c 85 10 80       	push   $0x8010859c
80103c42:	e8 29 c7 ff ff       	call   80100370 <panic>
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
80103c47:	83 ec 0c             	sub    $0xc,%esp
80103c4a:	68 fc 86 10 80       	push   $0x801086fc
80103c4f:	e8 1c c7 ff ff       	call   80100370 <panic>
80103c54:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103c5a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103c60 <cpuid>:
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
80103c60:	55                   	push   %ebp
80103c61:	89 e5                	mov    %esp,%ebp
80103c63:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103c66:	e8 75 ff ff ff       	call   80103be0 <mycpu>
80103c6b:	2d a0 37 11 80       	sub    $0x801137a0,%eax
}
80103c70:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
80103c71:	c1 f8 04             	sar    $0x4,%eax
80103c74:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103c7a:	c3                   	ret    
80103c7b:	90                   	nop
80103c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103c80 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
80103c80:	55                   	push   %ebp
80103c81:	89 e5                	mov    %esp,%ebp
80103c83:	53                   	push   %ebx
80103c84:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80103c87:	e8 d4 0f 00 00       	call   80104c60 <pushcli>
  c = mycpu();
80103c8c:	e8 4f ff ff ff       	call   80103be0 <mycpu>
  p = c->proc;
80103c91:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c97:	e8 d4 10 00 00       	call   80104d70 <popcli>
  return p;
}
80103c9c:	83 c4 04             	add    $0x4,%esp
80103c9f:	89 d8                	mov    %ebx,%eax
80103ca1:	5b                   	pop    %ebx
80103ca2:	5d                   	pop    %ebp
80103ca3:	c3                   	ret    
80103ca4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103caa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103cb0 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103cb0:	55                   	push   %ebp
80103cb1:	89 e5                	mov    %esp,%ebp
80103cb3:	53                   	push   %ebx
80103cb4:	83 ec 04             	sub    $0x4,%esp
  #endif

  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80103cb7:	e8 64 fd ff ff       	call   80103a20 <allocproc>
80103cbc:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
80103cbe:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103cc3:	e8 b8 3b 00 00       	call   80107880 <setupkvm>
80103cc8:	85 c0                	test   %eax,%eax
80103cca:	89 43 04             	mov    %eax,0x4(%ebx)
80103ccd:	0f 84 bd 00 00 00    	je     80103d90 <userinit+0xe0>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103cd3:	83 ec 04             	sub    $0x4,%esp
80103cd6:	68 2c 00 00 00       	push   $0x2c
80103cdb:	68 60 b4 10 80       	push   $0x8010b460
80103ce0:	50                   	push   %eax
80103ce1:	e8 aa 39 00 00       	call   80107690 <inituvm>
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
80103ce6:	83 c4 0c             	add    $0xc,%esp
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
80103ce9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103cef:	6a 4c                	push   $0x4c
80103cf1:	6a 00                	push   $0x0
80103cf3:	ff 73 18             	pushl  0x18(%ebx)
80103cf6:	e8 35 11 00 00       	call   80104e30 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103cfb:	8b 43 18             	mov    0x18(%ebx),%eax
80103cfe:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103d03:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103d08:	83 c4 0c             	add    $0xc,%esp
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103d0b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103d0f:	8b 43 18             	mov    0x18(%ebx),%eax
80103d12:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103d16:	8b 43 18             	mov    0x18(%ebx),%eax
80103d19:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103d1d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103d21:	8b 43 18             	mov    0x18(%ebx),%eax
80103d24:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103d28:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103d2c:	8b 43 18             	mov    0x18(%ebx),%eax
80103d2f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103d36:	8b 43 18             	mov    0x18(%ebx),%eax
80103d39:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103d40:	8b 43 18             	mov    0x18(%ebx),%eax
80103d43:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103d4a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103d4d:	6a 10                	push   $0x10
80103d4f:	68 c5 85 10 80       	push   $0x801085c5
80103d54:	50                   	push   %eax
80103d55:	e8 d6 12 00 00       	call   80105030 <safestrcpy>
  p->cwd = namei("/");
80103d5a:	c7 04 24 ce 85 10 80 	movl   $0x801085ce,(%esp)
80103d61:	e8 ea e1 ff ff       	call   80101f50 <namei>
80103d66:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103d69:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80103d70:	e8 2b 0f 00 00       	call   80104ca0 <acquire>

  p->state = RUNNABLE;
80103d75:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
80103d7c:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80103d83:	e8 58 10 00 00       	call   80104de0 <release>
}
80103d88:	83 c4 10             	add    $0x10,%esp
80103d8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d8e:	c9                   	leave  
80103d8f:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
80103d90:	83 ec 0c             	sub    $0xc,%esp
80103d93:	68 ac 85 10 80       	push   $0x801085ac
80103d98:	e8 d3 c5 ff ff       	call   80100370 <panic>
80103d9d:	8d 76 00             	lea    0x0(%esi),%esi

80103da0 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103da0:	55                   	push   %ebp
80103da1:	89 e5                	mov    %esp,%ebp
80103da3:	56                   	push   %esi
80103da4:	53                   	push   %ebx
80103da5:	8b 75 08             	mov    0x8(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103da8:	e8 b3 0e 00 00       	call   80104c60 <pushcli>
  c = mycpu();
80103dad:	e8 2e fe ff ff       	call   80103be0 <mycpu>
  p = c->proc;
80103db2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103db8:	e8 b3 0f 00 00       	call   80104d70 <popcli>
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
80103dbd:	83 fe 00             	cmp    $0x0,%esi
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
80103dc0:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103dc2:	7e 34                	jle    80103df8 <growproc+0x58>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0){
80103dc4:	83 ec 04             	sub    $0x4,%esp
80103dc7:	01 c6                	add    %eax,%esi
80103dc9:	56                   	push   %esi
80103dca:	50                   	push   %eax
80103dcb:	ff 73 04             	pushl  0x4(%ebx)
80103dce:	e8 ad 40 00 00       	call   80107e80 <allocuvm>
80103dd3:	83 c4 10             	add    $0x10,%esp
80103dd6:	85 c0                	test   %eax,%eax
80103dd8:	74 36                	je     80103e10 <growproc+0x70>
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
80103dda:	83 ec 0c             	sub    $0xc,%esp
    }
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
80103ddd:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103ddf:	53                   	push   %ebx
80103de0:	e8 9b 37 00 00       	call   80107580 <switchuvm>
  return 0;
80103de5:	83 c4 10             	add    $0x10,%esp
80103de8:	31 c0                	xor    %eax,%eax
}
80103dea:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ded:	5b                   	pop    %ebx
80103dee:	5e                   	pop    %esi
80103def:	5d                   	pop    %ebp
80103df0:	c3                   	ret    
80103df1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0){
      return -1;
    }
  } else if(n < 0){
80103df8:	74 e0                	je     80103dda <growproc+0x3a>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103dfa:	83 ec 04             	sub    $0x4,%esp
80103dfd:	01 c6                	add    %eax,%esi
80103dff:	56                   	push   %esi
80103e00:	50                   	push   %eax
80103e01:	ff 73 04             	pushl  0x4(%ebx)
80103e04:	e8 c7 39 00 00       	call   801077d0 <deallocuvm>
80103e09:	83 c4 10             	add    $0x10,%esp
80103e0c:	85 c0                	test   %eax,%eax
80103e0e:	75 ca                	jne    80103dda <growproc+0x3a>
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0){
      return -1;
80103e10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e15:	eb d3                	jmp    80103dea <growproc+0x4a>
80103e17:	89 f6                	mov    %esi,%esi
80103e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e20 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103e20:	55                   	push   %ebp
80103e21:	89 e5                	mov    %esp,%ebp
80103e23:	57                   	push   %edi
80103e24:	56                   	push   %esi
80103e25:	53                   	push   %ebx
80103e26:	81 ec 1c 04 00 00    	sub    $0x41c,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103e2c:	e8 2f 0e 00 00       	call   80104c60 <pushcli>
  c = mycpu();
80103e31:	e8 aa fd ff ff       	call   80103be0 <mycpu>
  p = c->proc;
80103e36:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e3c:	e8 2f 0f 00 00       	call   80104d70 <popcli>
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
80103e41:	e8 da fb ff ff       	call   80103a20 <allocproc>
80103e46:	85 c0                	test   %eax,%eax
80103e48:	89 c7                	mov    %eax,%edi
80103e4a:	89 85 e4 fb ff ff    	mov    %eax,-0x41c(%ebp)
80103e50:	0f 84 28 02 00 00    	je     8010407e <fork+0x25e>
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103e56:	83 ec 08             	sub    $0x8,%esp
80103e59:	ff 33                	pushl  (%ebx)
80103e5b:	ff 73 04             	pushl  0x4(%ebx)
80103e5e:	e8 ed 3a 00 00       	call   80107950 <copyuvm>
80103e63:	83 c4 10             	add    $0x10,%esp
80103e66:	85 c0                	test   %eax,%eax
80103e68:	89 47 04             	mov    %eax,0x4(%edi)
80103e6b:	0f 84 17 02 00 00    	je     80104088 <fork+0x268>
    np->state = UNUSED;
    return -1;
  }

  #ifndef NONE
  np->num_of_pages_in_memory = curproc->num_of_pages_in_memory;
80103e71:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
80103e77:	8b bd e4 fb ff ff    	mov    -0x41c(%ebp),%edi
  np->num_of_currently_swapped_out_pages = curproc->num_of_currently_swapped_out_pages;
  
  createSwapFile(np);
80103e7d:	83 ec 0c             	sub    $0xc,%esp
    np->state = UNUSED;
    return -1;
  }

  #ifndef NONE
  np->num_of_pages_in_memory = curproc->num_of_pages_in_memory;
80103e80:	89 87 80 00 00 00    	mov    %eax,0x80(%edi)
  np->num_of_currently_swapped_out_pages = curproc->num_of_currently_swapped_out_pages;
80103e86:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
80103e8c:	89 87 84 00 00 00    	mov    %eax,0x84(%edi)
  
  createSwapFile(np);
80103e92:	57                   	push   %edi
  char transport[PGSIZE/4] = "";
80103e93:	8d bd ec fb ff ff    	lea    -0x414(%ebp),%edi

  #ifndef NONE
  np->num_of_pages_in_memory = curproc->num_of_pages_in_memory;
  np->num_of_currently_swapped_out_pages = curproc->num_of_currently_swapped_out_pages;
  
  createSwapFile(np);
80103e99:	e8 92 e3 ff ff       	call   80102230 <createSwapFile>
  char transport[PGSIZE/4] = "";
80103e9e:	31 c0                	xor    %eax,%eax
80103ea0:	b9 ff 00 00 00       	mov    $0xff,%ecx
80103ea5:	c7 85 e8 fb ff ff 00 	movl   $0x0,-0x418(%ebp)
80103eac:	00 00 00 
80103eaf:	f3 ab                	rep stos %eax,%es:(%edi)
  int offset = 0;
  int bytesRead = 0;

  /// copy parent's swapfile
  if(strcmp(curproc->name, "init") && strcmp(curproc->name, "sh")){
80103eb1:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103eb4:	5a                   	pop    %edx
80103eb5:	59                   	pop    %ecx
80103eb6:	68 d0 85 10 80       	push   $0x801085d0
80103ebb:	50                   	push   %eax
80103ebc:	89 85 dc fb ff ff    	mov    %eax,-0x424(%ebp)
80103ec2:	e8 c9 11 00 00       	call   80105090 <strcmp>
80103ec7:	83 c4 10             	add    $0x10,%esp
80103eca:	85 c0                	test   %eax,%eax
80103ecc:	0f 85 3e 01 00 00    	jne    80104010 <fork+0x1f0>
80103ed2:	8b 85 e4 fb ff ff    	mov    -0x41c(%ebp),%eax
80103ed8:	8d 93 90 00 00 00    	lea    0x90(%ebx),%edx
80103ede:	8d b0 90 00 00 00    	lea    0x90(%eax),%esi
80103ee4:	8d 83 10 01 00 00    	lea    0x110(%ebx),%eax
80103eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      offset += bytesRead;
    }
  }

  for(i = 0; i < MAX_PSYC_PAGES ; i++){
    np->sfm[i].va = curproc->sfm[i].va;
80103ef0:	8b 0a                	mov    (%edx),%ecx
80103ef2:	83 c2 08             	add    $0x8,%edx
80103ef5:	83 c6 08             	add    $0x8,%esi
80103ef8:	89 4e f8             	mov    %ecx,-0x8(%esi)
    np->sfm[i].in_swap_file = curproc->sfm[i].in_swap_file;
80103efb:	0f b6 4a fc          	movzbl -0x4(%edx),%ecx
80103eff:	88 4e fc             	mov    %cl,-0x4(%esi)

      offset += bytesRead;
    }
  }

  for(i = 0; i < MAX_PSYC_PAGES ; i++){
80103f02:	39 c2                	cmp    %eax,%edx
80103f04:	75 ea                	jne    80103ef0 <fork+0xd0>
80103f06:	8b bd e4 fb ff ff    	mov    -0x41c(%ebp),%edi
80103f0c:	8d b3 90 02 00 00    	lea    0x290(%ebx),%esi
80103f12:	8d 97 10 01 00 00    	lea    0x110(%edi),%edx
80103f18:	90                   	nop
80103f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    np->sfm[i].va = curproc->sfm[i].va;
    np->sfm[i].in_swap_file = curproc->sfm[i].in_swap_file;
  }

  for(i = 0 ; i < MAX_TOTAL_PAGES - MAX_PSYC_PAGES ; i++){
    np->mem_pages[i].next = curproc->mem_pages[i].next;
80103f20:	8b 08                	mov    (%eax),%ecx
80103f22:	83 c0 18             	add    $0x18,%eax
80103f25:	83 c2 18             	add    $0x18,%edx
80103f28:	89 4a e8             	mov    %ecx,-0x18(%edx)
    np->mem_pages[i].prev = curproc->mem_pages[i].prev;
80103f2b:	8b 48 ec             	mov    -0x14(%eax),%ecx
80103f2e:	89 4a ec             	mov    %ecx,-0x14(%edx)
    np->mem_pages[i].aging = curproc->mem_pages[i].aging;
80103f31:	8b 48 f0             	mov    -0x10(%eax),%ecx
80103f34:	89 4a f0             	mov    %ecx,-0x10(%edx)
    np->mem_pages[i].va = curproc->mem_pages[i].va;
80103f37:	8b 48 f4             	mov    -0xc(%eax),%ecx
80103f3a:	89 4a f4             	mov    %ecx,-0xc(%edx)
    np->mem_pages[i].mem = curproc->mem_pages[i].mem;
80103f3d:	8b 48 f8             	mov    -0x8(%eax),%ecx
80103f40:	89 4a f8             	mov    %ecx,-0x8(%edx)
    np->mem_pages[i].in_mem = curproc->mem_pages[i].in_mem;
80103f43:	0f b6 48 fc          	movzbl -0x4(%eax),%ecx
80103f47:	88 4a fc             	mov    %cl,-0x4(%edx)
  for(i = 0; i < MAX_PSYC_PAGES ; i++){
    np->sfm[i].va = curproc->sfm[i].va;
    np->sfm[i].in_swap_file = curproc->sfm[i].in_swap_file;
  }

  for(i = 0 ; i < MAX_TOTAL_PAGES - MAX_PSYC_PAGES ; i++){
80103f4a:	39 f0                	cmp    %esi,%eax
80103f4c:	75 d2                	jne    80103f20 <fork+0x100>
    np->mem_pages[i].va = curproc->mem_pages[i].va;
    np->mem_pages[i].mem = curproc->mem_pages[i].mem;
    np->mem_pages[i].in_mem = curproc->mem_pages[i].in_mem;
  }

  np->first = curproc->first;
80103f4e:	8b 83 90 02 00 00    	mov    0x290(%ebx),%eax
80103f54:	8b bd e4 fb ff ff    	mov    -0x41c(%ebp),%edi

  #endif

  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;
80103f5a:	b9 13 00 00 00       	mov    $0x13,%ecx
    np->mem_pages[i].va = curproc->mem_pages[i].va;
    np->mem_pages[i].mem = curproc->mem_pages[i].mem;
    np->mem_pages[i].in_mem = curproc->mem_pages[i].in_mem;
  }

  np->first = curproc->first;
80103f5f:	89 87 90 02 00 00    	mov    %eax,0x290(%edi)
  np->last = curproc->last;
80103f65:	8b 83 94 02 00 00    	mov    0x294(%ebx),%eax
80103f6b:	89 87 94 02 00 00    	mov    %eax,0x294(%edi)

  #endif

  np->sz = curproc->sz;
80103f71:	8b 03                	mov    (%ebx),%eax
  np->parent = curproc;
80103f73:	89 5f 14             	mov    %ebx,0x14(%edi)
  np->first = curproc->first;
  np->last = curproc->last;

  #endif

  np->sz = curproc->sz;
80103f76:	89 07                	mov    %eax,(%edi)
  np->parent = curproc;
  *np->tf = *curproc->tf;
80103f78:	89 f8                	mov    %edi,%eax
80103f7a:	8b 73 18             	mov    0x18(%ebx),%esi
80103f7d:	8b 7f 18             	mov    0x18(%edi),%edi
80103f80:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103f82:	89 c7                	mov    %eax,%edi

  for(i = 0; i < NOFILE; i++)
80103f84:	31 f6                	xor    %esi,%esi
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103f86:	8b 40 18             	mov    0x18(%eax),%eax
80103f89:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
80103f90:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103f94:	85 c0                	test   %eax,%eax
80103f96:	74 10                	je     80103fa8 <fork+0x188>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103f98:	83 ec 0c             	sub    $0xc,%esp
80103f9b:	50                   	push   %eax
80103f9c:	e8 cf ce ff ff       	call   80100e70 <filedup>
80103fa1:	83 c4 10             	add    $0x10,%esp
80103fa4:	89 44 b7 28          	mov    %eax,0x28(%edi,%esi,4)
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103fa8:	83 c6 01             	add    $0x1,%esi
80103fab:	83 fe 10             	cmp    $0x10,%esi
80103fae:	75 e0                	jne    80103f90 <fork+0x170>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103fb0:	83 ec 0c             	sub    $0xc,%esp
80103fb3:	ff 73 68             	pushl  0x68(%ebx)
80103fb6:	e8 15 d7 ff ff       	call   801016d0 <idup>
80103fbb:	8b bd e4 fb ff ff    	mov    -0x41c(%ebp),%edi

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103fc1:	83 c4 0c             	add    $0xc,%esp
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103fc4:	89 47 68             	mov    %eax,0x68(%edi)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103fc7:	8d 47 6c             	lea    0x6c(%edi),%eax
80103fca:	6a 10                	push   $0x10
80103fcc:	ff b5 dc fb ff ff    	pushl  -0x424(%ebp)
80103fd2:	50                   	push   %eax
80103fd3:	e8 58 10 00 00       	call   80105030 <safestrcpy>

  pid = np->pid;
80103fd8:	8b 5f 10             	mov    0x10(%edi),%ebx

  acquire(&ptable.lock);
80103fdb:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80103fe2:	e8 b9 0c 00 00       	call   80104ca0 <acquire>

  np->state = RUNNABLE;
80103fe7:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)

  release(&ptable.lock);
80103fee:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80103ff5:	e8 e6 0d 00 00       	call   80104de0 <release>

  return pid;
80103ffa:	83 c4 10             	add    $0x10,%esp
80103ffd:	89 d8                	mov    %ebx,%eax
}
80103fff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104002:	5b                   	pop    %ebx
80104003:	5e                   	pop    %esi
80104004:	5f                   	pop    %edi
80104005:	5d                   	pop    %ebp
80104006:	c3                   	ret    
80104007:	89 f6                	mov    %esi,%esi
80104009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  char transport[PGSIZE/4] = "";
  int offset = 0;
  int bytesRead = 0;

  /// copy parent's swapfile
  if(strcmp(curproc->name, "init") && strcmp(curproc->name, "sh")){
80104010:	83 ec 08             	sub    $0x8,%esp
80104013:	68 d5 85 10 80       	push   $0x801085d5
80104018:	ff b5 dc fb ff ff    	pushl  -0x424(%ebp)
8010401e:	e8 6d 10 00 00       	call   80105090 <strcmp>
80104023:	83 c4 10             	add    $0x10,%esp
80104026:	85 c0                	test   %eax,%eax
80104028:	0f 84 a4 fe ff ff    	je     80103ed2 <fork+0xb2>
8010402e:	31 f6                	xor    %esi,%esi
80104030:	8d bd e8 fb ff ff    	lea    -0x418(%ebp),%edi
80104036:	89 9d e0 fb ff ff    	mov    %ebx,-0x420(%ebp)
8010403c:	eb 1a                	jmp    80104058 <fork+0x238>
8010403e:	66 90                	xchg   %ax,%ax
    while((bytesRead = readFromSwapFile(curproc, transport, offset, PGSIZE/4))){
      if(writeToSwapFile(np, transport, offset, bytesRead) == -1){
80104040:	53                   	push   %ebx
80104041:	56                   	push   %esi
80104042:	57                   	push   %edi
80104043:	ff b5 e4 fb ff ff    	pushl  -0x41c(%ebp)
80104049:	e8 82 e2 ff ff       	call   801022d0 <writeToSwapFile>
8010404e:	83 c4 10             	add    $0x10,%esp
80104051:	83 f8 ff             	cmp    $0xffffffff,%eax
80104054:	74 5e                	je     801040b4 <fork+0x294>
        panic("copying swapfile failed");
      }

      offset += bytesRead;
80104056:	01 de                	add    %ebx,%esi
  int offset = 0;
  int bytesRead = 0;

  /// copy parent's swapfile
  if(strcmp(curproc->name, "init") && strcmp(curproc->name, "sh")){
    while((bytesRead = readFromSwapFile(curproc, transport, offset, PGSIZE/4))){
80104058:	68 00 04 00 00       	push   $0x400
8010405d:	56                   	push   %esi
8010405e:	57                   	push   %edi
8010405f:	ff b5 e0 fb ff ff    	pushl  -0x420(%ebp)
80104065:	e8 96 e2 ff ff       	call   80102300 <readFromSwapFile>
8010406a:	83 c4 10             	add    $0x10,%esp
8010406d:	85 c0                	test   %eax,%eax
8010406f:	89 c3                	mov    %eax,%ebx
80104071:	75 cd                	jne    80104040 <fork+0x220>
80104073:	8b 9d e0 fb ff ff    	mov    -0x420(%ebp),%ebx
80104079:	e9 54 fe ff ff       	jmp    80103ed2 <fork+0xb2>
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
8010407e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104083:	e9 77 ff ff ff       	jmp    80103fff <fork+0x1df>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
80104088:	8b 9d e4 fb ff ff    	mov    -0x41c(%ebp),%ebx
8010408e:	83 ec 0c             	sub    $0xc,%esp
80104091:	ff 73 08             	pushl  0x8(%ebx)
80104094:	e8 77 e6 ff ff       	call   80102710 <kfree>
    np->kstack = 0;
80104099:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
801040a0:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
801040a7:	83 c4 10             	add    $0x10,%esp
801040aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801040af:	e9 4b ff ff ff       	jmp    80103fff <fork+0x1df>

  /// copy parent's swapfile
  if(strcmp(curproc->name, "init") && strcmp(curproc->name, "sh")){
    while((bytesRead = readFromSwapFile(curproc, transport, offset, PGSIZE/4))){
      if(writeToSwapFile(np, transport, offset, bytesRead) == -1){
        panic("copying swapfile failed");
801040b4:	83 ec 0c             	sub    $0xc,%esp
801040b7:	68 d8 85 10 80       	push   $0x801085d8
801040bc:	e8 af c2 ff ff       	call   80100370 <panic>
801040c1:	eb 0d                	jmp    801040d0 <sched>
801040c3:	90                   	nop
801040c4:	90                   	nop
801040c5:	90                   	nop
801040c6:	90                   	nop
801040c7:	90                   	nop
801040c8:	90                   	nop
801040c9:	90                   	nop
801040ca:	90                   	nop
801040cb:	90                   	nop
801040cc:	90                   	nop
801040cd:	90                   	nop
801040ce:	90                   	nop
801040cf:	90                   	nop

801040d0 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
801040d0:	55                   	push   %ebp
801040d1:	89 e5                	mov    %esp,%ebp
801040d3:	56                   	push   %esi
801040d4:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801040d5:	e8 86 0b 00 00       	call   80104c60 <pushcli>
  c = mycpu();
801040da:	e8 01 fb ff ff       	call   80103be0 <mycpu>
  p = c->proc;
801040df:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040e5:	e8 86 0c 00 00       	call   80104d70 <popcli>
void
sched(void)
{
  int intena;
  struct proc *p = myproc();
  if(!holding(&ptable.lock))
801040ea:	83 ec 0c             	sub    $0xc,%esp
801040ed:	68 40 3d 11 80       	push   $0x80113d40
801040f2:	e8 29 0b 00 00       	call   80104c20 <holding>
801040f7:	83 c4 10             	add    $0x10,%esp
801040fa:	85 c0                	test   %eax,%eax
801040fc:	74 4f                	je     8010414d <sched+0x7d>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
801040fe:	e8 dd fa ff ff       	call   80103be0 <mycpu>
80104103:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010410a:	75 68                	jne    80104174 <sched+0xa4>
    panic("sched locks");
  if(p->state == RUNNING)
8010410c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104110:	74 55                	je     80104167 <sched+0x97>
80104112:	9c                   	pushf  
80104113:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
80104114:	f6 c4 02             	test   $0x2,%ah
80104117:	75 41                	jne    8010415a <sched+0x8a>
    panic("sched interruptible");
  intena = mycpu()->intena;
80104119:	e8 c2 fa ff ff       	call   80103be0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010411e:	83 c3 1c             	add    $0x1c,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
80104121:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104127:	e8 b4 fa ff ff       	call   80103be0 <mycpu>
8010412c:	83 ec 08             	sub    $0x8,%esp
8010412f:	ff 70 04             	pushl  0x4(%eax)
80104132:	53                   	push   %ebx
80104133:	e8 a0 0f 00 00       	call   801050d8 <swtch>
  mycpu()->intena = intena;
80104138:	e8 a3 fa ff ff       	call   80103be0 <mycpu>
}
8010413d:	83 c4 10             	add    $0x10,%esp
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
80104140:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104146:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104149:	5b                   	pop    %ebx
8010414a:	5e                   	pop    %esi
8010414b:	5d                   	pop    %ebp
8010414c:	c3                   	ret    
sched(void)
{
  int intena;
  struct proc *p = myproc();
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
8010414d:	83 ec 0c             	sub    $0xc,%esp
80104150:	68 f0 85 10 80       	push   $0x801085f0
80104155:	e8 16 c2 ff ff       	call   80100370 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
8010415a:	83 ec 0c             	sub    $0xc,%esp
8010415d:	68 1c 86 10 80       	push   $0x8010861c
80104162:	e8 09 c2 ff ff       	call   80100370 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
80104167:	83 ec 0c             	sub    $0xc,%esp
8010416a:	68 0e 86 10 80       	push   $0x8010860e
8010416f:	e8 fc c1 ff ff       	call   80100370 <panic>
  int intena;
  struct proc *p = myproc();
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
80104174:	83 ec 0c             	sub    $0xc,%esp
80104177:	68 02 86 10 80       	push   $0x80108602
8010417c:	e8 ef c1 ff ff       	call   80100370 <panic>
80104181:	eb 0d                	jmp    80104190 <exit>
80104183:	90                   	nop
80104184:	90                   	nop
80104185:	90                   	nop
80104186:	90                   	nop
80104187:	90                   	nop
80104188:	90                   	nop
80104189:	90                   	nop
8010418a:	90                   	nop
8010418b:	90                   	nop
8010418c:	90                   	nop
8010418d:	90                   	nop
8010418e:	90                   	nop
8010418f:	90                   	nop

80104190 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104190:	55                   	push   %ebp
80104191:	89 e5                	mov    %esp,%ebp
80104193:	57                   	push   %edi
80104194:	56                   	push   %esi
80104195:	53                   	push   %ebx
80104196:	83 ec 0c             	sub    $0xc,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104199:	e8 c2 0a 00 00       	call   80104c60 <pushcli>
  c = mycpu();
8010419e:	e8 3d fa ff ff       	call   80103be0 <mycpu>
  p = c->proc;
801041a3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801041a9:	e8 c2 0b 00 00       	call   80104d70 <popcli>
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
801041ae:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
801041b4:	0f 84 54 01 00 00    	je     8010430e <exit+0x17e>
    panic("init exiting");


  #ifdef TRUE
    cprintf("process %s, pid %d ended, page statistics: %d %d %d %d\n",curproc->name, curproc->pid, curproc->num_of_pages_in_memory + curproc->num_of_currently_swapped_out_pages, curproc->num_of_currently_swapped_out_pages, 
801041ba:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
801041c0:	83 ec 04             	sub    $0x4,%esp
801041c3:	ff b6 88 00 00 00    	pushl  0x88(%esi)
801041c9:	ff b6 8c 00 00 00    	pushl  0x8c(%esi)
801041cf:	8d 5e 28             	lea    0x28(%esi),%ebx
801041d2:	8d 7e 68             	lea    0x68(%esi),%edi
801041d5:	50                   	push   %eax
801041d6:	03 86 80 00 00 00    	add    0x80(%esi),%eax
801041dc:	50                   	push   %eax
801041dd:	8d 46 6c             	lea    0x6c(%esi),%eax
801041e0:	ff 76 10             	pushl  0x10(%esi)
801041e3:	50                   	push   %eax
801041e4:	68 24 87 10 80       	push   $0x80108724
801041e9:	e8 72 c4 ff ff       	call   80100660 <cprintf>
801041ee:	83 c4 20             	add    $0x20,%esp
801041f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    curproc->num_of_page_faults, curproc->num_of_total_swap_out_actions);
  #endif
  
  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
801041f8:	8b 03                	mov    (%ebx),%eax
801041fa:	85 c0                	test   %eax,%eax
801041fc:	74 12                	je     80104210 <exit+0x80>
      fileclose(curproc->ofile[fd]);
801041fe:	83 ec 0c             	sub    $0xc,%esp
80104201:	50                   	push   %eax
80104202:	e8 b9 cc ff ff       	call   80100ec0 <fileclose>
      curproc->ofile[fd] = 0;
80104207:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010420d:	83 c4 10             	add    $0x10,%esp
80104210:	83 c3 04             	add    $0x4,%ebx
    cprintf("process %s, pid %d ended, page statistics: %d %d %d %d\n",curproc->name, curproc->pid, curproc->num_of_pages_in_memory + curproc->num_of_currently_swapped_out_pages, curproc->num_of_currently_swapped_out_pages, 
    curproc->num_of_page_faults, curproc->num_of_total_swap_out_actions);
  #endif
  
  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104213:	39 fb                	cmp    %edi,%ebx
80104215:	75 e1                	jne    801041f8 <exit+0x68>
  }
  

  /// remove swap file
  #ifndef NONE
  if(removeSwapFile(curproc) != 0){
80104217:	83 ec 0c             	sub    $0xc,%esp
8010421a:	56                   	push   %esi
8010421b:	e8 10 de ff ff       	call   80102030 <removeSwapFile>
80104220:	83 c4 10             	add    $0x10,%esp
80104223:	85 c0                	test   %eax,%eax
80104225:	0f 85 bd 00 00 00    	jne    801042e8 <exit+0x158>
    panic("wait: remove swapfile failed");
  }
  #endif 
  
  begin_op();
8010422b:	e8 90 ed ff ff       	call   80102fc0 <begin_op>
  iput(curproc->cwd);
80104230:	83 ec 0c             	sub    $0xc,%esp
80104233:	ff 76 68             	pushl  0x68(%esi)
80104236:	e8 f5 d5 ff ff       	call   80101830 <iput>
  end_op();
8010423b:	e8 f0 ed ff ff       	call   80103030 <end_op>
  curproc->cwd = 0;
80104240:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  
  acquire(&ptable.lock);
80104247:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
8010424e:	e8 4d 0a 00 00       	call   80104ca0 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80104253:	8b 56 14             	mov    0x14(%esi),%edx
80104256:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104259:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
8010425e:	eb 0c                	jmp    8010426c <exit+0xdc>
80104260:	05 98 02 00 00       	add    $0x298,%eax
80104265:	3d 74 e3 11 80       	cmp    $0x8011e374,%eax
8010426a:	74 1e                	je     8010428a <exit+0xfa>
    if(p->state == SLEEPING && p->chan == chan)
8010426c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104270:	75 ee                	jne    80104260 <exit+0xd0>
80104272:	3b 50 20             	cmp    0x20(%eax),%edx
80104275:	75 e9                	jne    80104260 <exit+0xd0>
      p->state = RUNNABLE;
80104277:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010427e:	05 98 02 00 00       	add    $0x298,%eax
80104283:	3d 74 e3 11 80       	cmp    $0x8011e374,%eax
80104288:	75 e2                	jne    8010426c <exit+0xdc>
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
8010428a:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
80104290:	ba 74 3d 11 80       	mov    $0x80113d74,%edx
80104295:	eb 17                	jmp    801042ae <exit+0x11e>
80104297:	89 f6                	mov    %esi,%esi
80104299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042a0:	81 c2 98 02 00 00    	add    $0x298,%edx
801042a6:	81 fa 74 e3 11 80    	cmp    $0x8011e374,%edx
801042ac:	74 47                	je     801042f5 <exit+0x165>
    if(p->parent == curproc){
801042ae:	39 72 14             	cmp    %esi,0x14(%edx)
801042b1:	75 ed                	jne    801042a0 <exit+0x110>
      p->parent = initproc;
      if(p->state == ZOMBIE)
801042b3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
801042b7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801042ba:	75 e4                	jne    801042a0 <exit+0x110>
801042bc:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
801042c1:	eb 11                	jmp    801042d4 <exit+0x144>
801042c3:	90                   	nop
801042c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042c8:	05 98 02 00 00       	add    $0x298,%eax
801042cd:	3d 74 e3 11 80       	cmp    $0x8011e374,%eax
801042d2:	74 cc                	je     801042a0 <exit+0x110>
    if(p->state == SLEEPING && p->chan == chan)
801042d4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801042d8:	75 ee                	jne    801042c8 <exit+0x138>
801042da:	3b 48 20             	cmp    0x20(%eax),%ecx
801042dd:	75 e9                	jne    801042c8 <exit+0x138>
      p->state = RUNNABLE;
801042df:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801042e6:	eb e0                	jmp    801042c8 <exit+0x138>
  

  /// remove swap file
  #ifndef NONE
  if(removeSwapFile(curproc) != 0){
    panic("wait: remove swapfile failed");
801042e8:	83 ec 0c             	sub    $0xc,%esp
801042eb:	68 3d 86 10 80       	push   $0x8010863d
801042f0:	e8 7b c0 ff ff       	call   80100370 <panic>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
801042f5:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
801042fc:	e8 cf fd ff ff       	call   801040d0 <sched>
  panic("zombie exit");
80104301:	83 ec 0c             	sub    $0xc,%esp
80104304:	68 5a 86 10 80       	push   $0x8010865a
80104309:	e8 62 c0 ff ff       	call   80100370 <panic>
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");
8010430e:	83 ec 0c             	sub    $0xc,%esp
80104311:	68 30 86 10 80       	push   $0x80108630
80104316:	e8 55 c0 ff ff       	call   80100370 <panic>
8010431b:	90                   	nop
8010431c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104320 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104320:	55                   	push   %ebp
80104321:	89 e5                	mov    %esp,%ebp
80104323:	53                   	push   %ebx
80104324:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104327:	68 40 3d 11 80       	push   $0x80113d40
8010432c:	e8 6f 09 00 00       	call   80104ca0 <acquire>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104331:	e8 2a 09 00 00       	call   80104c60 <pushcli>
  c = mycpu();
80104336:	e8 a5 f8 ff ff       	call   80103be0 <mycpu>
  p = c->proc;
8010433b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104341:	e8 2a 0a 00 00       	call   80104d70 <popcli>
// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
80104346:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010434d:	e8 7e fd ff ff       	call   801040d0 <sched>
  release(&ptable.lock);
80104352:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80104359:	e8 82 0a 00 00       	call   80104de0 <release>
}
8010435e:	83 c4 10             	add    $0x10,%esp
80104361:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104364:	c9                   	leave  
80104365:	c3                   	ret    
80104366:	8d 76 00             	lea    0x0(%esi),%esi
80104369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104370 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104370:	55                   	push   %ebp
80104371:	89 e5                	mov    %esp,%ebp
80104373:	57                   	push   %edi
80104374:	56                   	push   %esi
80104375:	53                   	push   %ebx
80104376:	83 ec 0c             	sub    $0xc,%esp
80104379:	8b 7d 08             	mov    0x8(%ebp),%edi
8010437c:	8b 75 0c             	mov    0xc(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
8010437f:	e8 dc 08 00 00       	call   80104c60 <pushcli>
  c = mycpu();
80104384:	e8 57 f8 ff ff       	call   80103be0 <mycpu>
  p = c->proc;
80104389:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010438f:	e8 dc 09 00 00       	call   80104d70 <popcli>
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
80104394:	85 db                	test   %ebx,%ebx
80104396:	0f 84 87 00 00 00    	je     80104423 <sleep+0xb3>
    panic("sleep");

  if(lk == 0)
8010439c:	85 f6                	test   %esi,%esi
8010439e:	74 76                	je     80104416 <sleep+0xa6>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
801043a0:	81 fe 40 3d 11 80    	cmp    $0x80113d40,%esi
801043a6:	74 50                	je     801043f8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801043a8:	83 ec 0c             	sub    $0xc,%esp
801043ab:	68 40 3d 11 80       	push   $0x80113d40
801043b0:	e8 eb 08 00 00       	call   80104ca0 <acquire>
    release(lk);
801043b5:	89 34 24             	mov    %esi,(%esp)
801043b8:	e8 23 0a 00 00       	call   80104de0 <release>
  }
  // Go to sleep.
  p->chan = chan;
801043bd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801043c0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
801043c7:	e8 04 fd ff ff       	call   801040d0 <sched>

  // Tidy up.
  p->chan = 0;
801043cc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
801043d3:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
801043da:	e8 01 0a 00 00       	call   80104de0 <release>
    acquire(lk);
801043df:	89 75 08             	mov    %esi,0x8(%ebp)
801043e2:	83 c4 10             	add    $0x10,%esp
  }
}
801043e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043e8:	5b                   	pop    %ebx
801043e9:	5e                   	pop    %esi
801043ea:	5f                   	pop    %edi
801043eb:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
801043ec:	e9 af 08 00 00       	jmp    80104ca0 <acquire>
801043f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
801043f8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801043fb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80104402:	e8 c9 fc ff ff       	call   801040d0 <sched>

  // Tidy up.
  p->chan = 0;
80104407:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
8010440e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104411:	5b                   	pop    %ebx
80104412:	5e                   	pop    %esi
80104413:	5f                   	pop    %edi
80104414:	5d                   	pop    %ebp
80104415:	c3                   	ret    
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80104416:	83 ec 0c             	sub    $0xc,%esp
80104419:	68 6c 86 10 80       	push   $0x8010866c
8010441e:	e8 4d bf ff ff       	call   80100370 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");
80104423:	83 ec 0c             	sub    $0xc,%esp
80104426:	68 66 86 10 80       	push   $0x80108666
8010442b:	e8 40 bf ff ff       	call   80100370 <panic>

80104430 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104430:	55                   	push   %ebp
80104431:	89 e5                	mov    %esp,%ebp
80104433:	56                   	push   %esi
80104434:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80104435:	e8 26 08 00 00       	call   80104c60 <pushcli>
  c = mycpu();
8010443a:	e8 a1 f7 ff ff       	call   80103be0 <mycpu>
  p = c->proc;
8010443f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104445:	e8 26 09 00 00       	call   80104d70 <popcli>
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
8010444a:	83 ec 0c             	sub    $0xc,%esp
8010444d:	68 40 3d 11 80       	push   $0x80113d40
80104452:	e8 49 08 00 00       	call   80104ca0 <acquire>
80104457:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
8010445a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010445c:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
80104461:	eb 13                	jmp    80104476 <wait+0x46>
80104463:	90                   	nop
80104464:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104468:	81 c3 98 02 00 00    	add    $0x298,%ebx
8010446e:	81 fb 74 e3 11 80    	cmp    $0x8011e374,%ebx
80104474:	74 22                	je     80104498 <wait+0x68>
      if(p->parent != curproc)
80104476:	39 73 14             	cmp    %esi,0x14(%ebx)
80104479:	75 ed                	jne    80104468 <wait+0x38>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
8010447b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010447f:	74 35                	je     801044b6 <wait+0x86>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104481:	81 c3 98 02 00 00    	add    $0x298,%ebx
      if(p->parent != curproc)
        continue;
      havekids = 1;
80104487:	b8 01 00 00 00       	mov    $0x1,%eax
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010448c:	81 fb 74 e3 11 80    	cmp    $0x8011e374,%ebx
80104492:	75 e2                	jne    80104476 <wait+0x46>
80104494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80104498:	85 c0                	test   %eax,%eax
8010449a:	74 70                	je     8010450c <wait+0xdc>
8010449c:	8b 46 24             	mov    0x24(%esi),%eax
8010449f:	85 c0                	test   %eax,%eax
801044a1:	75 69                	jne    8010450c <wait+0xdc>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801044a3:	83 ec 08             	sub    $0x8,%esp
801044a6:	68 40 3d 11 80       	push   $0x80113d40
801044ab:	56                   	push   %esi
801044ac:	e8 bf fe ff ff       	call   80104370 <sleep>
  }
801044b1:	83 c4 10             	add    $0x10,%esp
801044b4:	eb a4                	jmp    8010445a <wait+0x2a>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
801044b6:	83 ec 0c             	sub    $0xc,%esp
801044b9:	ff 73 08             	pushl  0x8(%ebx)
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
801044bc:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801044bf:	e8 4c e2 ff ff       	call   80102710 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
801044c4:	5a                   	pop    %edx
801044c5:	ff 73 04             	pushl  0x4(%ebx)
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
801044c8:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801044cf:	e8 2c 33 00 00       	call   80107800 <freevm>
        p->pid = 0;
801044d4:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801044db:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801044e2:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801044e6:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801044ed:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801044f4:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
801044fb:	e8 e0 08 00 00       	call   80104de0 <release>
        return pid;
80104500:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104503:	8d 65 f8             	lea    -0x8(%ebp),%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
80104506:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104508:	5b                   	pop    %ebx
80104509:	5e                   	pop    %esi
8010450a:	5d                   	pop    %ebp
8010450b:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
8010450c:	83 ec 0c             	sub    $0xc,%esp
8010450f:	68 40 3d 11 80       	push   $0x80113d40
80104514:	e8 c7 08 00 00       	call   80104de0 <release>
      return -1;
80104519:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
8010451c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
8010451f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80104524:	5b                   	pop    %ebx
80104525:	5e                   	pop    %esi
80104526:	5d                   	pop    %ebp
80104527:	c3                   	ret    
80104528:	90                   	nop
80104529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104530 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	53                   	push   %ebx
80104534:	83 ec 10             	sub    $0x10,%esp
80104537:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010453a:	68 40 3d 11 80       	push   $0x80113d40
8010453f:	e8 5c 07 00 00       	call   80104ca0 <acquire>
80104544:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104547:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
8010454c:	eb 0e                	jmp    8010455c <wakeup+0x2c>
8010454e:	66 90                	xchg   %ax,%ax
80104550:	05 98 02 00 00       	add    $0x298,%eax
80104555:	3d 74 e3 11 80       	cmp    $0x8011e374,%eax
8010455a:	74 1e                	je     8010457a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010455c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104560:	75 ee                	jne    80104550 <wakeup+0x20>
80104562:	3b 58 20             	cmp    0x20(%eax),%ebx
80104565:	75 e9                	jne    80104550 <wakeup+0x20>
      p->state = RUNNABLE;
80104567:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010456e:	05 98 02 00 00       	add    $0x298,%eax
80104573:	3d 74 e3 11 80       	cmp    $0x8011e374,%eax
80104578:	75 e2                	jne    8010455c <wakeup+0x2c>
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
8010457a:	c7 45 08 40 3d 11 80 	movl   $0x80113d40,0x8(%ebp)
}
80104581:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104584:	c9                   	leave  
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80104585:	e9 56 08 00 00       	jmp    80104de0 <release>
8010458a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104590 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	53                   	push   %ebx
80104594:	83 ec 10             	sub    $0x10,%esp
80104597:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010459a:	68 40 3d 11 80       	push   $0x80113d40
8010459f:	e8 fc 06 00 00       	call   80104ca0 <acquire>
801045a4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045a7:	b8 74 3d 11 80       	mov    $0x80113d74,%eax
801045ac:	eb 0e                	jmp    801045bc <kill+0x2c>
801045ae:	66 90                	xchg   %ax,%ax
801045b0:	05 98 02 00 00       	add    $0x298,%eax
801045b5:	3d 74 e3 11 80       	cmp    $0x8011e374,%eax
801045ba:	74 3c                	je     801045f8 <kill+0x68>
    if(p->pid == pid){
801045bc:	39 58 10             	cmp    %ebx,0x10(%eax)
801045bf:	75 ef                	jne    801045b0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801045c1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
801045c5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801045cc:	74 1a                	je     801045e8 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
801045ce:	83 ec 0c             	sub    $0xc,%esp
801045d1:	68 40 3d 11 80       	push   $0x80113d40
801045d6:	e8 05 08 00 00       	call   80104de0 <release>
      return 0;
801045db:	83 c4 10             	add    $0x10,%esp
801045de:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801045e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045e3:	c9                   	leave  
801045e4:	c3                   	ret    
801045e5:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
801045e8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801045ef:	eb dd                	jmp    801045ce <kill+0x3e>
801045f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
801045f8:	83 ec 0c             	sub    $0xc,%esp
801045fb:	68 40 3d 11 80       	push   $0x80113d40
80104600:	e8 db 07 00 00       	call   80104de0 <release>
  return -1;
80104605:	83 c4 10             	add    $0x10,%esp
80104608:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010460d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104610:	c9                   	leave  
80104611:	c3                   	ret    
80104612:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104620 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	57                   	push   %edi
80104624:	56                   	push   %esi
80104625:	53                   	push   %ebx
80104626:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104629:	bb e0 3d 11 80       	mov    $0x80113de0,%ebx
8010462e:	83 ec 3c             	sub    $0x3c,%esp
80104631:	eb 27                	jmp    8010465a <procdump+0x3a>
80104633:	90                   	nop
80104634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104638:	83 ec 0c             	sub    $0xc,%esp
8010463b:	68 6f 8b 10 80       	push   $0x80108b6f
80104640:	e8 1b c0 ff ff       	call   80100660 <cprintf>
80104645:	83 c4 10             	add    $0x10,%esp
80104648:	81 c3 98 02 00 00    	add    $0x298,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010464e:	81 fb e0 e3 11 80    	cmp    $0x8011e3e0,%ebx
80104654:	0f 84 a6 00 00 00    	je     80104700 <procdump+0xe0>
    if(p->state == UNUSED)
8010465a:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010465d:	85 c0                	test   %eax,%eax
8010465f:	74 e7                	je     80104648 <procdump+0x28>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104661:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
80104664:	ba 7d 86 10 80       	mov    $0x8010867d,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104669:	77 11                	ja     8010467c <procdump+0x5c>
8010466b:	8b 14 85 80 87 10 80 	mov    -0x7fef7880(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
80104672:	b8 7d 86 10 80       	mov    $0x8010867d,%eax
80104677:	85 d2                	test   %edx,%edx
80104679:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010467c:	53                   	push   %ebx
8010467d:	52                   	push   %edx
8010467e:	ff 73 a4             	pushl  -0x5c(%ebx)
80104681:	68 81 86 10 80       	push   $0x80108681
80104686:	e8 d5 bf ff ff       	call   80100660 <cprintf>

    #ifndef NONE
    cprintf(" %d %d %d %d", p->num_of_pages_in_memory+ p->num_of_currently_swapped_out_pages, p->num_of_currently_swapped_out_pages, 
8010468b:	8b 43 18             	mov    0x18(%ebx),%eax
8010468e:	5a                   	pop    %edx
8010468f:	ff 73 1c             	pushl  0x1c(%ebx)
80104692:	ff 73 20             	pushl  0x20(%ebx)
80104695:	50                   	push   %eax
80104696:	03 43 14             	add    0x14(%ebx),%eax
80104699:	50                   	push   %eax
8010469a:	68 8a 86 10 80       	push   $0x8010868a
8010469f:	e8 bc bf ff ff       	call   80100660 <cprintf>
      p->num_of_page_faults, p->num_of_total_swap_out_actions);
    #endif

    if(p->state == SLEEPING){
801046a4:	83 c4 20             	add    $0x20,%esp
801046a7:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801046ab:	75 8b                	jne    80104638 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801046ad:	8d 45 c0             	lea    -0x40(%ebp),%eax
801046b0:	83 ec 08             	sub    $0x8,%esp
801046b3:	8d 7d c0             	lea    -0x40(%ebp),%edi
801046b6:	50                   	push   %eax
801046b7:	8b 43 b0             	mov    -0x50(%ebx),%eax
801046ba:	8b 40 0c             	mov    0xc(%eax),%eax
801046bd:	83 c0 08             	add    $0x8,%eax
801046c0:	50                   	push   %eax
801046c1:	e8 fa 04 00 00       	call   80104bc0 <getcallerpcs>
801046c6:	83 c4 10             	add    $0x10,%esp
801046c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
801046d0:	8b 17                	mov    (%edi),%edx
801046d2:	85 d2                	test   %edx,%edx
801046d4:	0f 84 5e ff ff ff    	je     80104638 <procdump+0x18>
        cprintf(" %p", pc[i]);
801046da:	83 ec 08             	sub    $0x8,%esp
801046dd:	83 c7 04             	add    $0x4,%edi
801046e0:	52                   	push   %edx
801046e1:	68 41 80 10 80       	push   $0x80108041
801046e6:	e8 75 bf ff ff       	call   80100660 <cprintf>
      p->num_of_page_faults, p->num_of_total_swap_out_actions);
    #endif

    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
801046eb:	83 c4 10             	add    $0x10,%esp
801046ee:	39 f7                	cmp    %esi,%edi
801046f0:	75 de                	jne    801046d0 <procdump+0xb0>
801046f2:	e9 41 ff ff ff       	jmp    80104638 <procdump+0x18>
801046f7:	89 f6                	mov    %esi,%esi
801046f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    }
    cprintf("\n");
  }

  #ifndef NONE
  cprintf("%d / %d free pages in the system\n", freePages, totalPages);
80104700:	83 ec 04             	sub    $0x4,%esp
80104703:	ff 35 7c 36 11 80    	pushl  0x8011367c
80104709:	ff 35 80 36 11 80    	pushl  0x80113680
8010470f:	68 5c 87 10 80       	push   $0x8010875c
80104714:	e8 47 bf ff ff       	call   80100660 <cprintf>
  #endif
}
80104719:	83 c4 10             	add    $0x10,%esp
8010471c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010471f:	5b                   	pop    %ebx
80104720:	5e                   	pop    %esi
80104721:	5f                   	pop    %edi
80104722:	5d                   	pop    %ebp
80104723:	c3                   	ret    
80104724:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010472a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104730 <updateAQ>:

void updateAQ(){
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	57                   	push   %edi
80104734:	56                   	push   %esi
80104735:	53                   	push   %ebx
  struct proc* p;
  int i;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104736:	be 74 3d 11 80       	mov    $0x80113d74,%esi
  #ifndef NONE
  cprintf("%d / %d free pages in the system\n", freePages, totalPages);
  #endif
}

void updateAQ(){
8010473b:	83 ec 2c             	sub    $0x2c,%esp
8010473e:	eb 12                	jmp    80104752 <updateAQ+0x22>
  struct proc* p;
  int i;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104740:	81 c6 98 02 00 00    	add    $0x298,%esi
80104746:	81 fe 74 e3 11 80    	cmp    $0x8011e374,%esi
8010474c:	0f 84 8e 01 00 00    	je     801048e0 <updateAQ+0x1b0>
    if((p->state == RUNNING || p->state == RUNNABLE || p->state == SLEEPING)
80104752:	8b 46 0c             	mov    0xc(%esi),%eax
80104755:	83 e8 02             	sub    $0x2,%eax
80104758:	83 f8 02             	cmp    $0x2,%eax
8010475b:	77 e3                	ja     80104740 <updateAQ+0x10>
8010475d:	8d 5e 6c             	lea    0x6c(%esi),%ebx
      && (strcmp(p->name, "init") && strcmp(p->name, "sh"))){
80104760:	83 ec 08             	sub    $0x8,%esp
80104763:	68 d0 85 10 80       	push   $0x801085d0
80104768:	53                   	push   %ebx
80104769:	e8 22 09 00 00       	call   80105090 <strcmp>
8010476e:	83 c4 10             	add    $0x10,%esp
80104771:	85 c0                	test   %eax,%eax
80104773:	74 cb                	je     80104740 <updateAQ+0x10>
80104775:	83 ec 08             	sub    $0x8,%esp
80104778:	68 d5 85 10 80       	push   $0x801085d5
8010477d:	53                   	push   %ebx
8010477e:	e8 0d 09 00 00       	call   80105090 <strcmp>
80104783:	83 c4 10             	add    $0x10,%esp
80104786:	85 c0                	test   %eax,%eax
80104788:	74 b6                	je     80104740 <updateAQ+0x10>
      //   i = p->num_of_pages_in_memory - 1;
      //   loopSize = p->num_of_pages_in_memory - 1;
      // }


      for(i = p->num_of_pages_in_memory - 1 ; i > 0 ; i--){
8010478a:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
80104790:	8d 48 ff             	lea    -0x1(%eax),%ecx
80104793:	85 c9                	test   %ecx,%ecx
80104795:	7e a9                	jle    80104740 <updateAQ+0x10>
        if(!p->mem_pages[i].in_mem){
80104797:	8d 14 49             	lea    (%ecx,%ecx,2),%edx
8010479a:	80 bc d6 24 01 00 00 	cmpb   $0x0,0x124(%esi,%edx,8)
801047a1:	00 
801047a2:	0f 84 27 01 00 00    	je     801048cf <updateAQ+0x19f>
801047a8:	8d 04 40             	lea    (%eax,%eax,2),%eax
801047ab:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801047ae:	8d 3c c6             	lea    (%esi,%eax,8),%edi
801047b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
          panic("updateAQ bad loop");
        }

        pte_t* pte1 = walkpgdir_noalloc(p->pgdir, p->mem_pages[i].va);
801047b8:	83 ec 08             	sub    $0x8,%esp
801047bb:	ff b7 04 01 00 00    	pushl  0x104(%edi)
801047c1:	ff 76 04             	pushl  0x4(%esi)
801047c4:	e8 57 2d 00 00       	call   80107520 <walkpgdir_noalloc>
        pte_t* pte2 = walkpgdir_noalloc(p->pgdir, p->mem_pages[i - 1].va);
801047c9:	5a                   	pop    %edx
801047ca:	59                   	pop    %ecx
801047cb:	ff b7 ec 00 00 00    	pushl  0xec(%edi)
801047d1:	ff 76 04             	pushl  0x4(%esi)
801047d4:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
      for(i = p->num_of_pages_in_memory - 1 ; i > 0 ; i--){
        if(!p->mem_pages[i].in_mem){
          panic("updateAQ bad loop");
        }

        pte_t* pte1 = walkpgdir_noalloc(p->pgdir, p->mem_pages[i].va);
801047d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
        pte_t* pte2 = walkpgdir_noalloc(p->pgdir, p->mem_pages[i - 1].va);
801047db:	e8 40 2d 00 00       	call   80107520 <walkpgdir_noalloc>

        if(!pte1 || !pte2){
801047e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
801047e3:	83 c4 10             	add    $0x10,%esp
801047e6:	85 d2                	test   %edx,%edx
801047e8:	0f 84 fa 00 00 00    	je     801048e8 <updateAQ+0x1b8>
801047ee:	85 c0                	test   %eax,%eax
801047f0:	0f 84 f2 00 00 00    	je     801048e8 <updateAQ+0x1b8>
          panic("updateAQ failed");
        }

        if(!(*pte1 & PTE_A) && (*pte2 & PTE_A)){
801047f6:	f6 02 20             	testb  $0x20,(%edx)
801047f9:	0f 85 b5 00 00 00    	jne    801048b4 <updateAQ+0x184>
801047ff:	f6 00 20             	testb  $0x20,(%eax)
80104802:	0f 84 ac 00 00 00    	je     801048b4 <updateAQ+0x184>
          struct mem_page temp = p->mem_pages[i];
          p->mem_pages[i] = p->mem_pages[i - 1];
80104808:	8b 9f e0 00 00 00    	mov    0xe0(%edi),%ebx
        if(!pte1 || !pte2){
          panic("updateAQ failed");
        }

        if(!(*pte1 & PTE_A) && (*pte2 & PTE_A)){
          struct mem_page temp = p->mem_pages[i];
8010480e:	8b 97 fc 00 00 00    	mov    0xfc(%edi),%edx
80104814:	8b 8f f8 00 00 00    	mov    0xf8(%edi),%ecx
          p->mem_pages[i] = p->mem_pages[i - 1];
8010481a:	89 9f f8 00 00 00    	mov    %ebx,0xf8(%edi)
80104820:	8b 9f e4 00 00 00    	mov    0xe4(%edi),%ebx
        if(!pte1 || !pte2){
          panic("updateAQ failed");
        }

        if(!(*pte1 & PTE_A) && (*pte2 & PTE_A)){
          struct mem_page temp = p->mem_pages[i];
80104826:	89 55 e0             	mov    %edx,-0x20(%ebp)
80104829:	8b 97 00 01 00 00    	mov    0x100(%edi),%edx
          p->mem_pages[i] = p->mem_pages[i - 1];
          p->mem_pages[i - 1] = temp;
8010482f:	89 8f e0 00 00 00    	mov    %ecx,0xe0(%edi)
80104835:	8b 4d e0             	mov    -0x20(%ebp),%ecx
          panic("updateAQ failed");
        }

        if(!(*pte1 & PTE_A) && (*pte2 & PTE_A)){
          struct mem_page temp = p->mem_pages[i];
          p->mem_pages[i] = p->mem_pages[i - 1];
80104838:	89 9f fc 00 00 00    	mov    %ebx,0xfc(%edi)
8010483e:	8b 9f e8 00 00 00    	mov    0xe8(%edi),%ebx
        if(!pte1 || !pte2){
          panic("updateAQ failed");
        }

        if(!(*pte1 & PTE_A) && (*pte2 & PTE_A)){
          struct mem_page temp = p->mem_pages[i];
80104844:	89 55 dc             	mov    %edx,-0x24(%ebp)
80104847:	8b 97 04 01 00 00    	mov    0x104(%edi),%edx
          p->mem_pages[i] = p->mem_pages[i - 1];
          p->mem_pages[i - 1] = temp;
8010484d:	89 8f e4 00 00 00    	mov    %ecx,0xe4(%edi)
80104853:	8b 4d dc             	mov    -0x24(%ebp),%ecx
          panic("updateAQ failed");
        }

        if(!(*pte1 & PTE_A) && (*pte2 & PTE_A)){
          struct mem_page temp = p->mem_pages[i];
          p->mem_pages[i] = p->mem_pages[i - 1];
80104856:	89 9f 00 01 00 00    	mov    %ebx,0x100(%edi)
8010485c:	8b 9f ec 00 00 00    	mov    0xec(%edi),%ebx
        if(!pte1 || !pte2){
          panic("updateAQ failed");
        }

        if(!(*pte1 & PTE_A) && (*pte2 & PTE_A)){
          struct mem_page temp = p->mem_pages[i];
80104862:	89 55 d8             	mov    %edx,-0x28(%ebp)
80104865:	8b 97 08 01 00 00    	mov    0x108(%edi),%edx
          p->mem_pages[i] = p->mem_pages[i - 1];
          p->mem_pages[i - 1] = temp;
8010486b:	89 8f e8 00 00 00    	mov    %ecx,0xe8(%edi)
80104871:	8b 4d d8             	mov    -0x28(%ebp),%ecx
          panic("updateAQ failed");
        }

        if(!(*pte1 & PTE_A) && (*pte2 & PTE_A)){
          struct mem_page temp = p->mem_pages[i];
          p->mem_pages[i] = p->mem_pages[i - 1];
80104874:	89 9f 04 01 00 00    	mov    %ebx,0x104(%edi)
8010487a:	8b 9f f0 00 00 00    	mov    0xf0(%edi),%ebx
        if(!pte1 || !pte2){
          panic("updateAQ failed");
        }

        if(!(*pte1 & PTE_A) && (*pte2 & PTE_A)){
          struct mem_page temp = p->mem_pages[i];
80104880:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104883:	0f b6 97 0c 01 00 00 	movzbl 0x10c(%edi),%edx
          p->mem_pages[i] = p->mem_pages[i - 1];
          p->mem_pages[i - 1] = temp;
8010488a:	89 8f ec 00 00 00    	mov    %ecx,0xec(%edi)
80104890:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
          panic("updateAQ failed");
        }

        if(!(*pte1 & PTE_A) && (*pte2 & PTE_A)){
          struct mem_page temp = p->mem_pages[i];
          p->mem_pages[i] = p->mem_pages[i - 1];
80104893:	89 9f 08 01 00 00    	mov    %ebx,0x108(%edi)
80104899:	8b 9f f4 00 00 00    	mov    0xf4(%edi),%ebx
          p->mem_pages[i - 1] = temp;
8010489f:	89 8f f0 00 00 00    	mov    %ecx,0xf0(%edi)
801048a5:	88 97 f4 00 00 00    	mov    %dl,0xf4(%edi)
          panic("updateAQ failed");
        }

        if(!(*pte1 & PTE_A) && (*pte2 & PTE_A)){
          struct mem_page temp = p->mem_pages[i];
          p->mem_pages[i] = p->mem_pages[i - 1];
801048ab:	89 9f 0c 01 00 00    	mov    %ebx,0x10c(%edi)
          p->mem_pages[i - 1] = temp;

          *pte2 = *pte2 & ~PTE_A;
801048b1:	83 20 df             	andl   $0xffffffdf,(%eax)
      //   i = p->num_of_pages_in_memory - 1;
      //   loopSize = p->num_of_pages_in_memory - 1;
      // }


      for(i = p->num_of_pages_in_memory - 1 ; i > 0 ; i--){
801048b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801048b7:	85 c0                	test   %eax,%eax
801048b9:	0f 84 81 fe ff ff    	je     80104740 <updateAQ+0x10>
801048bf:	83 ef 18             	sub    $0x18,%edi
        if(!p->mem_pages[i].in_mem){
801048c2:	80 bf 0c 01 00 00 00 	cmpb   $0x0,0x10c(%edi)
801048c9:	0f 85 e9 fe ff ff    	jne    801047b8 <updateAQ+0x88>
          panic("updateAQ bad loop");
801048cf:	83 ec 0c             	sub    $0xc,%esp
801048d2:	68 97 86 10 80       	push   $0x80108697
801048d7:	e8 94 ba ff ff       	call   80100370 <panic>
801048dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
          *pte2 = *pte2 & ~PTE_A;
        } 
      }
    }
  }
}
801048e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048e3:	5b                   	pop    %ebx
801048e4:	5e                   	pop    %esi
801048e5:	5f                   	pop    %edi
801048e6:	5d                   	pop    %ebp
801048e7:	c3                   	ret    

        pte_t* pte1 = walkpgdir_noalloc(p->pgdir, p->mem_pages[i].va);
        pte_t* pte2 = walkpgdir_noalloc(p->pgdir, p->mem_pages[i - 1].va);

        if(!pte1 || !pte2){
          panic("updateAQ failed");
801048e8:	83 ec 0c             	sub    $0xc,%esp
801048eb:	68 a9 86 10 80       	push   $0x801086a9
801048f0:	e8 7b ba ff ff       	call   80100370 <panic>
801048f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104900 <updateNFUAandLAPA>:
      }
    }
  }
}

void updateNFUAandLAPA(){
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	56                   	push   %esi
80104904:	53                   	push   %ebx
80104905:	bb 0c 40 11 80       	mov    $0x8011400c,%ebx
8010490a:	eb 16                	jmp    80104922 <updateNFUAandLAPA+0x22>
8010490c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104910:	81 c3 98 02 00 00    	add    $0x298,%ebx
  struct proc* p;
  int i;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104916:	81 fb 0c e6 11 80    	cmp    $0x8011e60c,%ebx
8010491c:	0f 84 8e 00 00 00    	je     801049b0 <updateNFUAandLAPA+0xb0>
    if((p->state == RUNNING || p->state == RUNNABLE || p->state == SLEEPING)
80104922:	8b 83 74 fd ff ff    	mov    -0x28c(%ebx),%eax
80104928:	83 e8 02             	sub    $0x2,%eax
8010492b:	83 f8 02             	cmp    $0x2,%eax
8010492e:	77 e0                	ja     80104910 <updateNFUAandLAPA+0x10>
80104930:	8d b3 d4 fd ff ff    	lea    -0x22c(%ebx),%esi
      && (strcmp(p->name, "init") && strcmp(p->name, "sh"))){
80104936:	83 ec 08             	sub    $0x8,%esp
80104939:	68 d0 85 10 80       	push   $0x801085d0
8010493e:	56                   	push   %esi
8010493f:	e8 4c 07 00 00       	call   80105090 <strcmp>
80104944:	83 c4 10             	add    $0x10,%esp
80104947:	85 c0                	test   %eax,%eax
80104949:	74 c5                	je     80104910 <updateNFUAandLAPA+0x10>
8010494b:	83 ec 08             	sub    $0x8,%esp
8010494e:	68 d5 85 10 80       	push   $0x801085d5
80104953:	56                   	push   %esi
80104954:	e8 37 07 00 00       	call   80105090 <strcmp>
80104959:	83 c4 10             	add    $0x10,%esp
8010495c:	85 c0                	test   %eax,%eax
8010495e:	74 b0                	je     80104910 <updateNFUAandLAPA+0x10>
80104960:	8d b3 80 fe ff ff    	lea    -0x180(%ebx),%esi
80104966:	eb 0f                	jmp    80104977 <updateNFUAandLAPA+0x77>
80104968:	90                   	nop
80104969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104970:	83 c6 18             	add    $0x18,%esi
      for(i = 0 ; i < MAX_PSYC_PAGES ; i++){
80104973:	39 de                	cmp    %ebx,%esi
80104975:	74 99                	je     80104910 <updateNFUAandLAPA+0x10>
        if(p->mem_pages[i].in_mem){
80104977:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
8010497b:	74 f3                	je     80104970 <updateNFUAandLAPA+0x70>
          pte_t* pte = walkpgdir_noalloc(p->pgdir, p->mem_pages[i].mem);
8010497d:	83 ec 08             	sub    $0x8,%esp
80104980:	ff 76 08             	pushl  0x8(%esi)
80104983:	ff b3 6c fd ff ff    	pushl  -0x294(%ebx)
80104989:	e8 92 2b 00 00       	call   80107520 <walkpgdir_noalloc>
          
          if(!pte){
8010498e:	83 c4 10             	add    $0x10,%esp
80104991:	85 c0                	test   %eax,%eax
80104993:	74 22                	je     801049b7 <updateNFUAandLAPA+0xb7>
            panic("updateNFUAandLAPA failed");
          }

          p->mem_pages[i].aging = p->mem_pages[i].aging >> 1;
80104995:	8b 16                	mov    (%esi),%edx
80104997:	d1 ea                	shr    %edx
80104999:	89 16                	mov    %edx,(%esi)
          if(*pte & PTE_A){
8010499b:	f6 00 20             	testb  $0x20,(%eax)
8010499e:	74 d0                	je     80104970 <updateNFUAandLAPA+0x70>
            p->mem_pages[i].aging |= 0x80000000;
801049a0:	81 ca 00 00 00 80    	or     $0x80000000,%edx
801049a6:	89 16                	mov    %edx,(%esi)
            *pte = *pte & ~PTE_A;
801049a8:	83 20 df             	andl   $0xffffffdf,(%eax)
801049ab:	eb c3                	jmp    80104970 <updateNFUAandLAPA+0x70>
801049ad:	8d 76 00             	lea    0x0(%esi),%esi
          }
        }
      }
    }
  }
}
801049b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049b3:	5b                   	pop    %ebx
801049b4:	5e                   	pop    %esi
801049b5:	5d                   	pop    %ebp
801049b6:	c3                   	ret    
      for(i = 0 ; i < MAX_PSYC_PAGES ; i++){
        if(p->mem_pages[i].in_mem){
          pte_t* pte = walkpgdir_noalloc(p->pgdir, p->mem_pages[i].mem);
          
          if(!pte){
            panic("updateNFUAandLAPA failed");
801049b7:	83 ec 0c             	sub    $0xc,%esp
801049ba:	68 b9 86 10 80       	push   $0x801086b9
801049bf:	e8 ac b9 ff ff       	call   80100370 <panic>
801049c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801049d0 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	57                   	push   %edi
801049d4:	56                   	push   %esi
801049d5:	53                   	push   %ebx
801049d6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p;
  struct cpu *c = mycpu();
801049d9:	e8 02 f2 ff ff       	call   80103be0 <mycpu>
801049de:	8d 78 04             	lea    0x4(%eax),%edi
801049e1:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801049e3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801049ea:	00 00 00 
801049ed:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
801049f0:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
801049f1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049f4:	bb 74 3d 11 80       	mov    $0x80113d74,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
801049f9:	68 40 3d 11 80       	push   $0x80113d40
801049fe:	e8 9d 02 00 00       	call   80104ca0 <acquire>
80104a03:	83 c4 10             	add    $0x10,%esp
80104a06:	eb 16                	jmp    80104a1e <scheduler+0x4e>
80104a08:	90                   	nop
80104a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a10:	81 c3 98 02 00 00    	add    $0x298,%ebx
80104a16:	81 fb 74 e3 11 80    	cmp    $0x8011e374,%ebx
80104a1c:	74 52                	je     80104a70 <scheduler+0xa0>
      if(p->state != RUNNABLE)
80104a1e:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104a22:	75 ec                	jne    80104a10 <scheduler+0x40>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80104a24:	83 ec 0c             	sub    $0xc,%esp


      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80104a27:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80104a2d:	53                   	push   %ebx
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a2e:	81 c3 98 02 00 00    	add    $0x298,%ebx

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80104a34:	e8 47 2b 00 00       	call   80107580 <switchuvm>
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
80104a39:	58                   	pop    %eax
80104a3a:	5a                   	pop    %edx
80104a3b:	ff b3 84 fd ff ff    	pushl  -0x27c(%ebx)
80104a41:	57                   	push   %edi
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
80104a42:	c7 83 74 fd ff ff 04 	movl   $0x4,-0x28c(%ebx)
80104a49:	00 00 00 

      swtch(&(c->scheduler), p->context);
80104a4c:	e8 87 06 00 00       	call   801050d8 <swtch>
      switchkvm();
80104a51:	e8 0a 2b 00 00       	call   80107560 <switchkvm>

      /// update aging, PTE_A
      #if defined(NFUA) || defined(LAPA)
        updateNFUAandLAPA();
80104a56:	e8 a5 fe ff ff       	call   80104900 <updateNFUAandLAPA>
        updateAQ();
      #endif

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80104a5b:	83 c4 10             	add    $0x10,%esp
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a5e:	81 fb 74 e3 11 80    	cmp    $0x8011e374,%ebx
        updateAQ();
      #endif

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80104a64:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104a6b:	00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a6e:	75 ae                	jne    80104a1e <scheduler+0x4e>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
80104a70:	83 ec 0c             	sub    $0xc,%esp
80104a73:	68 40 3d 11 80       	push   $0x80113d40
80104a78:	e8 63 03 00 00       	call   80104de0 <release>

  }
80104a7d:	83 c4 10             	add    $0x10,%esp
80104a80:	e9 6b ff ff ff       	jmp    801049f0 <scheduler+0x20>
80104a85:	66 90                	xchg   %ax,%ax
80104a87:	66 90                	xchg   %ax,%ax
80104a89:	66 90                	xchg   %ax,%ax
80104a8b:	66 90                	xchg   %ax,%ax
80104a8d:	66 90                	xchg   %ax,%ax
80104a8f:	90                   	nop

80104a90 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	53                   	push   %ebx
80104a94:	83 ec 0c             	sub    $0xc,%esp
80104a97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104a9a:	68 98 87 10 80       	push   $0x80108798
80104a9f:	8d 43 04             	lea    0x4(%ebx),%eax
80104aa2:	50                   	push   %eax
80104aa3:	e8 f8 00 00 00       	call   80104ba0 <initlock>
  lk->name = name;
80104aa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104aab:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104ab1:	83 c4 10             	add    $0x10,%esp
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
80104ab4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
80104abb:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
80104abe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ac1:	c9                   	leave  
80104ac2:	c3                   	ret    
80104ac3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ad0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	56                   	push   %esi
80104ad4:	53                   	push   %ebx
80104ad5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104ad8:	83 ec 0c             	sub    $0xc,%esp
80104adb:	8d 73 04             	lea    0x4(%ebx),%esi
80104ade:	56                   	push   %esi
80104adf:	e8 bc 01 00 00       	call   80104ca0 <acquire>
  while (lk->locked) {
80104ae4:	8b 13                	mov    (%ebx),%edx
80104ae6:	83 c4 10             	add    $0x10,%esp
80104ae9:	85 d2                	test   %edx,%edx
80104aeb:	74 16                	je     80104b03 <acquiresleep+0x33>
80104aed:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104af0:	83 ec 08             	sub    $0x8,%esp
80104af3:	56                   	push   %esi
80104af4:	53                   	push   %ebx
80104af5:	e8 76 f8 ff ff       	call   80104370 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
80104afa:	8b 03                	mov    (%ebx),%eax
80104afc:	83 c4 10             	add    $0x10,%esp
80104aff:	85 c0                	test   %eax,%eax
80104b01:	75 ed                	jne    80104af0 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80104b03:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104b09:	e8 72 f1 ff ff       	call   80103c80 <myproc>
80104b0e:	8b 40 10             	mov    0x10(%eax),%eax
80104b11:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104b14:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104b17:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b1a:	5b                   	pop    %ebx
80104b1b:	5e                   	pop    %esi
80104b1c:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
80104b1d:	e9 be 02 00 00       	jmp    80104de0 <release>
80104b22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b30 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
80104b30:	55                   	push   %ebp
80104b31:	89 e5                	mov    %esp,%ebp
80104b33:	56                   	push   %esi
80104b34:	53                   	push   %ebx
80104b35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104b38:	83 ec 0c             	sub    $0xc,%esp
80104b3b:	8d 73 04             	lea    0x4(%ebx),%esi
80104b3e:	56                   	push   %esi
80104b3f:	e8 5c 01 00 00       	call   80104ca0 <acquire>
  lk->locked = 0;
80104b44:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104b4a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104b51:	89 1c 24             	mov    %ebx,(%esp)
80104b54:	e8 d7 f9 ff ff       	call   80104530 <wakeup>
  release(&lk->lk);
80104b59:	89 75 08             	mov    %esi,0x8(%ebp)
80104b5c:	83 c4 10             	add    $0x10,%esp
}
80104b5f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b62:	5b                   	pop    %ebx
80104b63:	5e                   	pop    %esi
80104b64:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104b65:	e9 76 02 00 00       	jmp    80104de0 <release>
80104b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b70 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	56                   	push   %esi
80104b74:	53                   	push   %ebx
80104b75:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80104b78:	83 ec 0c             	sub    $0xc,%esp
80104b7b:	8d 5e 04             	lea    0x4(%esi),%ebx
80104b7e:	53                   	push   %ebx
80104b7f:	e8 1c 01 00 00       	call   80104ca0 <acquire>
  r = lk->locked;
80104b84:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
80104b86:	89 1c 24             	mov    %ebx,(%esp)
80104b89:	e8 52 02 00 00       	call   80104de0 <release>
  return r;
}
80104b8e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b91:	89 f0                	mov    %esi,%eax
80104b93:	5b                   	pop    %ebx
80104b94:	5e                   	pop    %esi
80104b95:	5d                   	pop    %ebp
80104b96:	c3                   	ret    
80104b97:	66 90                	xchg   %ax,%ax
80104b99:	66 90                	xchg   %ax,%ax
80104b9b:	66 90                	xchg   %ax,%ax
80104b9d:	66 90                	xchg   %ax,%ax
80104b9f:	90                   	nop

80104ba0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104ba0:	55                   	push   %ebp
80104ba1:	89 e5                	mov    %esp,%ebp
80104ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104ba6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104ba9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
80104baf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104bb2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104bb9:	5d                   	pop    %ebp
80104bba:	c3                   	ret    
80104bbb:	90                   	nop
80104bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104bc0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104bc4:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104bc7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104bca:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
80104bcd:	31 c0                	xor    %eax,%eax
80104bcf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104bd0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104bd6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104bdc:	77 1a                	ja     80104bf8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104bde:	8b 5a 04             	mov    0x4(%edx),%ebx
80104be1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104be4:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104be7:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104be9:	83 f8 0a             	cmp    $0xa,%eax
80104bec:	75 e2                	jne    80104bd0 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104bee:	5b                   	pop    %ebx
80104bef:	5d                   	pop    %ebp
80104bf0:	c3                   	ret    
80104bf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104bf8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104bff:	83 c0 01             	add    $0x1,%eax
80104c02:	83 f8 0a             	cmp    $0xa,%eax
80104c05:	74 e7                	je     80104bee <getcallerpcs+0x2e>
    pcs[i] = 0;
80104c07:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104c0e:	83 c0 01             	add    $0x1,%eax
80104c11:	83 f8 0a             	cmp    $0xa,%eax
80104c14:	75 e2                	jne    80104bf8 <getcallerpcs+0x38>
80104c16:	eb d6                	jmp    80104bee <getcallerpcs+0x2e>
80104c18:	90                   	nop
80104c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104c20 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104c20:	55                   	push   %ebp
80104c21:	89 e5                	mov    %esp,%ebp
80104c23:	53                   	push   %ebx
80104c24:	83 ec 04             	sub    $0x4,%esp
80104c27:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
80104c2a:	8b 02                	mov    (%edx),%eax
80104c2c:	85 c0                	test   %eax,%eax
80104c2e:	75 10                	jne    80104c40 <holding+0x20>
}
80104c30:	83 c4 04             	add    $0x4,%esp
80104c33:	31 c0                	xor    %eax,%eax
80104c35:	5b                   	pop    %ebx
80104c36:	5d                   	pop    %ebp
80104c37:	c3                   	ret    
80104c38:	90                   	nop
80104c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104c40:	8b 5a 08             	mov    0x8(%edx),%ebx
80104c43:	e8 98 ef ff ff       	call   80103be0 <mycpu>
80104c48:	39 c3                	cmp    %eax,%ebx
80104c4a:	0f 94 c0             	sete   %al
}
80104c4d:	83 c4 04             	add    $0x4,%esp

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104c50:	0f b6 c0             	movzbl %al,%eax
}
80104c53:	5b                   	pop    %ebx
80104c54:	5d                   	pop    %ebp
80104c55:	c3                   	ret    
80104c56:	8d 76 00             	lea    0x0(%esi),%esi
80104c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c60 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104c60:	55                   	push   %ebp
80104c61:	89 e5                	mov    %esp,%ebp
80104c63:	53                   	push   %ebx
80104c64:	83 ec 04             	sub    $0x4,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104c67:	9c                   	pushf  
80104c68:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104c69:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104c6a:	e8 71 ef ff ff       	call   80103be0 <mycpu>
80104c6f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104c75:	85 c0                	test   %eax,%eax
80104c77:	75 11                	jne    80104c8a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104c79:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104c7f:	e8 5c ef ff ff       	call   80103be0 <mycpu>
80104c84:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104c8a:	e8 51 ef ff ff       	call   80103be0 <mycpu>
80104c8f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104c96:	83 c4 04             	add    $0x4,%esp
80104c99:	5b                   	pop    %ebx
80104c9a:	5d                   	pop    %ebp
80104c9b:	c3                   	ret    
80104c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ca0 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104ca0:	55                   	push   %ebp
80104ca1:	89 e5                	mov    %esp,%ebp
80104ca3:	56                   	push   %esi
80104ca4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104ca5:	e8 b6 ff ff ff       	call   80104c60 <pushcli>
  if(holding(lk)){
80104caa:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104cad:	8b 03                	mov    (%ebx),%eax
80104caf:	85 c0                	test   %eax,%eax
80104cb1:	75 7d                	jne    80104d30 <acquire+0x90>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104cb3:	ba 01 00 00 00       	mov    $0x1,%edx
80104cb8:	eb 09                	jmp    80104cc3 <acquire+0x23>
80104cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104cc0:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104cc3:	89 d0                	mov    %edx,%eax
80104cc5:	f0 87 03             	lock xchg %eax,(%ebx)
    cprintf("lk->name = %s, proc name: %s\n", lk->name, mycpu()->proc->name);
    panic("acquire");
  }

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104cc8:	85 c0                	test   %eax,%eax
80104cca:	75 f4                	jne    80104cc0 <acquire+0x20>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80104ccc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104cd1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104cd4:	e8 07 ef ff ff       	call   80103be0 <mycpu>
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104cd9:	89 ea                	mov    %ebp,%edx
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
80104cdb:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104cde:	89 43 08             	mov    %eax,0x8(%ebx)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104ce1:	31 c0                	xor    %eax,%eax
80104ce3:	90                   	nop
80104ce4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104ce8:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104cee:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104cf4:	77 1a                	ja     80104d10 <acquire+0x70>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104cf6:	8b 5a 04             	mov    0x4(%edx),%ebx
80104cf9:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104cfc:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104cff:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104d01:	83 f8 0a             	cmp    $0xa,%eax
80104d04:	75 e2                	jne    80104ce8 <acquire+0x48>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
}
80104d06:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d09:	5b                   	pop    %ebx
80104d0a:	5e                   	pop    %esi
80104d0b:	5d                   	pop    %ebp
80104d0c:	c3                   	ret    
80104d0d:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104d10:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104d17:	83 c0 01             	add    $0x1,%eax
80104d1a:	83 f8 0a             	cmp    $0xa,%eax
80104d1d:	74 e7                	je     80104d06 <acquire+0x66>
    pcs[i] = 0;
80104d1f:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80104d26:	83 c0 01             	add    $0x1,%eax
80104d29:	83 f8 0a             	cmp    $0xa,%eax
80104d2c:	75 e2                	jne    80104d10 <acquire+0x70>
80104d2e:	eb d6                	jmp    80104d06 <acquire+0x66>

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104d30:	8b 73 08             	mov    0x8(%ebx),%esi
80104d33:	e8 a8 ee ff ff       	call   80103be0 <mycpu>
80104d38:	39 c6                	cmp    %eax,%esi
80104d3a:	0f 85 73 ff ff ff    	jne    80104cb3 <acquire+0x13>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk)){
    cprintf("lk->name = %s, proc name: %s\n", lk->name, mycpu()->proc->name);
80104d40:	e8 9b ee ff ff       	call   80103be0 <mycpu>
80104d45:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104d4b:	83 ec 04             	sub    $0x4,%esp
80104d4e:	83 c0 6c             	add    $0x6c,%eax
80104d51:	50                   	push   %eax
80104d52:	ff 73 04             	pushl  0x4(%ebx)
80104d55:	68 a3 87 10 80       	push   $0x801087a3
80104d5a:	e8 01 b9 ff ff       	call   80100660 <cprintf>
    panic("acquire");
80104d5f:	c7 04 24 c1 87 10 80 	movl   $0x801087c1,(%esp)
80104d66:	e8 05 b6 ff ff       	call   80100370 <panic>
80104d6b:	90                   	nop
80104d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d70 <popcli>:
  mycpu()->ncli += 1;
}

void
popcli(void)
{
80104d70:	55                   	push   %ebp
80104d71:	89 e5                	mov    %esp,%ebp
80104d73:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104d76:	9c                   	pushf  
80104d77:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104d78:	f6 c4 02             	test   $0x2,%ah
80104d7b:	75 52                	jne    80104dcf <popcli+0x5f>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104d7d:	e8 5e ee ff ff       	call   80103be0 <mycpu>
80104d82:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104d88:	8d 51 ff             	lea    -0x1(%ecx),%edx
80104d8b:	85 d2                	test   %edx,%edx
80104d8d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104d93:	78 2d                	js     80104dc2 <popcli+0x52>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104d95:	e8 46 ee ff ff       	call   80103be0 <mycpu>
80104d9a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104da0:	85 d2                	test   %edx,%edx
80104da2:	74 0c                	je     80104db0 <popcli+0x40>
    sti();
}
80104da4:	c9                   	leave  
80104da5:	c3                   	ret    
80104da6:	8d 76 00             	lea    0x0(%esi),%esi
80104da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104db0:	e8 2b ee ff ff       	call   80103be0 <mycpu>
80104db5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104dbb:	85 c0                	test   %eax,%eax
80104dbd:	74 e5                	je     80104da4 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
80104dbf:	fb                   	sti    
    sti();
}
80104dc0:	c9                   	leave  
80104dc1:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
80104dc2:	83 ec 0c             	sub    $0xc,%esp
80104dc5:	68 e0 87 10 80       	push   $0x801087e0
80104dca:	e8 a1 b5 ff ff       	call   80100370 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
80104dcf:	83 ec 0c             	sub    $0xc,%esp
80104dd2:	68 c9 87 10 80       	push   $0x801087c9
80104dd7:	e8 94 b5 ff ff       	call   80100370 <panic>
80104ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104de0 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
80104de3:	56                   	push   %esi
80104de4:	53                   	push   %ebx
80104de5:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104de8:	8b 03                	mov    (%ebx),%eax
80104dea:	85 c0                	test   %eax,%eax
80104dec:	75 12                	jne    80104e00 <release+0x20>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
80104dee:	83 ec 0c             	sub    $0xc,%esp
80104df1:	68 e7 87 10 80       	push   $0x801087e7
80104df6:	e8 75 b5 ff ff       	call   80100370 <panic>
80104dfb:	90                   	nop
80104dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104e00:	8b 73 08             	mov    0x8(%ebx),%esi
80104e03:	e8 d8 ed ff ff       	call   80103be0 <mycpu>
80104e08:	39 c6                	cmp    %eax,%esi
80104e0a:	75 e2                	jne    80104dee <release+0xe>
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");

  lk->pcs[0] = 0;
80104e0c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104e13:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104e1a:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104e1f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
80104e25:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e28:	5b                   	pop    %ebx
80104e29:	5e                   	pop    %esi
80104e2a:	5d                   	pop    %ebp
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
80104e2b:	e9 40 ff ff ff       	jmp    80104d70 <popcli>

80104e30 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104e30:	55                   	push   %ebp
80104e31:	89 e5                	mov    %esp,%ebp
80104e33:	57                   	push   %edi
80104e34:	53                   	push   %ebx
80104e35:	8b 55 08             	mov    0x8(%ebp),%edx
80104e38:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104e3b:	f6 c2 03             	test   $0x3,%dl
80104e3e:	75 05                	jne    80104e45 <memset+0x15>
80104e40:	f6 c1 03             	test   $0x3,%cl
80104e43:	74 13                	je     80104e58 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104e45:	89 d7                	mov    %edx,%edi
80104e47:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e4a:	fc                   	cld    
80104e4b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104e4d:	5b                   	pop    %ebx
80104e4e:	89 d0                	mov    %edx,%eax
80104e50:	5f                   	pop    %edi
80104e51:	5d                   	pop    %ebp
80104e52:	c3                   	ret    
80104e53:	90                   	nop
80104e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104e58:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
80104e5c:	c1 e9 02             	shr    $0x2,%ecx
80104e5f:	89 fb                	mov    %edi,%ebx
80104e61:	89 f8                	mov    %edi,%eax
80104e63:	c1 e3 18             	shl    $0x18,%ebx
80104e66:	c1 e0 10             	shl    $0x10,%eax
80104e69:	09 d8                	or     %ebx,%eax
80104e6b:	09 f8                	or     %edi,%eax
80104e6d:	c1 e7 08             	shl    $0x8,%edi
80104e70:	09 f8                	or     %edi,%eax
80104e72:	89 d7                	mov    %edx,%edi
80104e74:	fc                   	cld    
80104e75:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104e77:	5b                   	pop    %ebx
80104e78:	89 d0                	mov    %edx,%eax
80104e7a:	5f                   	pop    %edi
80104e7b:	5d                   	pop    %ebp
80104e7c:	c3                   	ret    
80104e7d:	8d 76 00             	lea    0x0(%esi),%esi

80104e80 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104e80:	55                   	push   %ebp
80104e81:	89 e5                	mov    %esp,%ebp
80104e83:	57                   	push   %edi
80104e84:	56                   	push   %esi
80104e85:	8b 45 10             	mov    0x10(%ebp),%eax
80104e88:	53                   	push   %ebx
80104e89:	8b 75 0c             	mov    0xc(%ebp),%esi
80104e8c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104e8f:	85 c0                	test   %eax,%eax
80104e91:	74 29                	je     80104ebc <memcmp+0x3c>
    if(*s1 != *s2)
80104e93:	0f b6 13             	movzbl (%ebx),%edx
80104e96:	0f b6 0e             	movzbl (%esi),%ecx
80104e99:	38 d1                	cmp    %dl,%cl
80104e9b:	75 2b                	jne    80104ec8 <memcmp+0x48>
80104e9d:	8d 78 ff             	lea    -0x1(%eax),%edi
80104ea0:	31 c0                	xor    %eax,%eax
80104ea2:	eb 14                	jmp    80104eb8 <memcmp+0x38>
80104ea4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ea8:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
80104ead:	83 c0 01             	add    $0x1,%eax
80104eb0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104eb4:	38 ca                	cmp    %cl,%dl
80104eb6:	75 10                	jne    80104ec8 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104eb8:	39 f8                	cmp    %edi,%eax
80104eba:	75 ec                	jne    80104ea8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104ebc:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80104ebd:	31 c0                	xor    %eax,%eax
}
80104ebf:	5e                   	pop    %esi
80104ec0:	5f                   	pop    %edi
80104ec1:	5d                   	pop    %ebp
80104ec2:	c3                   	ret    
80104ec3:	90                   	nop
80104ec4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104ec8:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
80104ecb:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104ecc:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
80104ece:	5e                   	pop    %esi
80104ecf:	5f                   	pop    %edi
80104ed0:	5d                   	pop    %ebp
80104ed1:	c3                   	ret    
80104ed2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ee0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	56                   	push   %esi
80104ee4:	53                   	push   %ebx
80104ee5:	8b 45 08             	mov    0x8(%ebp),%eax
80104ee8:	8b 75 0c             	mov    0xc(%ebp),%esi
80104eeb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104eee:	39 c6                	cmp    %eax,%esi
80104ef0:	73 2e                	jae    80104f20 <memmove+0x40>
80104ef2:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104ef5:	39 c8                	cmp    %ecx,%eax
80104ef7:	73 27                	jae    80104f20 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
80104ef9:	85 db                	test   %ebx,%ebx
80104efb:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104efe:	74 17                	je     80104f17 <memmove+0x37>
      *--d = *--s;
80104f00:	29 d9                	sub    %ebx,%ecx
80104f02:	89 cb                	mov    %ecx,%ebx
80104f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f08:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104f0c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80104f0f:	83 ea 01             	sub    $0x1,%edx
80104f12:	83 fa ff             	cmp    $0xffffffff,%edx
80104f15:	75 f1                	jne    80104f08 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104f17:	5b                   	pop    %ebx
80104f18:	5e                   	pop    %esi
80104f19:	5d                   	pop    %ebp
80104f1a:	c3                   	ret    
80104f1b:	90                   	nop
80104f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104f20:	31 d2                	xor    %edx,%edx
80104f22:	85 db                	test   %ebx,%ebx
80104f24:	74 f1                	je     80104f17 <memmove+0x37>
80104f26:	8d 76 00             	lea    0x0(%esi),%esi
80104f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
80104f30:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104f34:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104f37:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104f3a:	39 d3                	cmp    %edx,%ebx
80104f3c:	75 f2                	jne    80104f30 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
80104f3e:	5b                   	pop    %ebx
80104f3f:	5e                   	pop    %esi
80104f40:	5d                   	pop    %ebp
80104f41:	c3                   	ret    
80104f42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f50 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104f50:	55                   	push   %ebp
80104f51:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104f53:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104f54:	eb 8a                	jmp    80104ee0 <memmove>
80104f56:	8d 76 00             	lea    0x0(%esi),%esi
80104f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f60 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104f60:	55                   	push   %ebp
80104f61:	89 e5                	mov    %esp,%ebp
80104f63:	57                   	push   %edi
80104f64:	56                   	push   %esi
80104f65:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104f68:	53                   	push   %ebx
80104f69:	8b 7d 08             	mov    0x8(%ebp),%edi
80104f6c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104f6f:	85 c9                	test   %ecx,%ecx
80104f71:	74 37                	je     80104faa <strncmp+0x4a>
80104f73:	0f b6 17             	movzbl (%edi),%edx
80104f76:	0f b6 1e             	movzbl (%esi),%ebx
80104f79:	84 d2                	test   %dl,%dl
80104f7b:	74 3f                	je     80104fbc <strncmp+0x5c>
80104f7d:	38 d3                	cmp    %dl,%bl
80104f7f:	75 3b                	jne    80104fbc <strncmp+0x5c>
80104f81:	8d 47 01             	lea    0x1(%edi),%eax
80104f84:	01 cf                	add    %ecx,%edi
80104f86:	eb 1b                	jmp    80104fa3 <strncmp+0x43>
80104f88:	90                   	nop
80104f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f90:	0f b6 10             	movzbl (%eax),%edx
80104f93:	84 d2                	test   %dl,%dl
80104f95:	74 21                	je     80104fb8 <strncmp+0x58>
80104f97:	0f b6 19             	movzbl (%ecx),%ebx
80104f9a:	83 c0 01             	add    $0x1,%eax
80104f9d:	89 ce                	mov    %ecx,%esi
80104f9f:	38 da                	cmp    %bl,%dl
80104fa1:	75 19                	jne    80104fbc <strncmp+0x5c>
80104fa3:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
80104fa5:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104fa8:	75 e6                	jne    80104f90 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104faa:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
80104fab:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
80104fad:	5e                   	pop    %esi
80104fae:	5f                   	pop    %edi
80104faf:	5d                   	pop    %ebp
80104fb0:	c3                   	ret    
80104fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fb8:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104fbc:	0f b6 c2             	movzbl %dl,%eax
80104fbf:	29 d8                	sub    %ebx,%eax
}
80104fc1:	5b                   	pop    %ebx
80104fc2:	5e                   	pop    %esi
80104fc3:	5f                   	pop    %edi
80104fc4:	5d                   	pop    %ebp
80104fc5:	c3                   	ret    
80104fc6:	8d 76 00             	lea    0x0(%esi),%esi
80104fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fd0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104fd0:	55                   	push   %ebp
80104fd1:	89 e5                	mov    %esp,%ebp
80104fd3:	56                   	push   %esi
80104fd4:	53                   	push   %ebx
80104fd5:	8b 45 08             	mov    0x8(%ebp),%eax
80104fd8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104fdb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104fde:	89 c2                	mov    %eax,%edx
80104fe0:	eb 19                	jmp    80104ffb <strncpy+0x2b>
80104fe2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104fe8:	83 c3 01             	add    $0x1,%ebx
80104feb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104fef:	83 c2 01             	add    $0x1,%edx
80104ff2:	84 c9                	test   %cl,%cl
80104ff4:	88 4a ff             	mov    %cl,-0x1(%edx)
80104ff7:	74 09                	je     80105002 <strncpy+0x32>
80104ff9:	89 f1                	mov    %esi,%ecx
80104ffb:	85 c9                	test   %ecx,%ecx
80104ffd:	8d 71 ff             	lea    -0x1(%ecx),%esi
80105000:	7f e6                	jg     80104fe8 <strncpy+0x18>
    ;
  while(n-- > 0)
80105002:	31 c9                	xor    %ecx,%ecx
80105004:	85 f6                	test   %esi,%esi
80105006:	7e 17                	jle    8010501f <strncpy+0x4f>
80105008:	90                   	nop
80105009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105010:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80105014:	89 f3                	mov    %esi,%ebx
80105016:	83 c1 01             	add    $0x1,%ecx
80105019:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
8010501b:	85 db                	test   %ebx,%ebx
8010501d:	7f f1                	jg     80105010 <strncpy+0x40>
    *s++ = 0;
  return os;
}
8010501f:	5b                   	pop    %ebx
80105020:	5e                   	pop    %esi
80105021:	5d                   	pop    %ebp
80105022:	c3                   	ret    
80105023:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105030 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105030:	55                   	push   %ebp
80105031:	89 e5                	mov    %esp,%ebp
80105033:	56                   	push   %esi
80105034:	53                   	push   %ebx
80105035:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105038:	8b 45 08             	mov    0x8(%ebp),%eax
8010503b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010503e:	85 c9                	test   %ecx,%ecx
80105040:	7e 26                	jle    80105068 <safestrcpy+0x38>
80105042:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80105046:	89 c1                	mov    %eax,%ecx
80105048:	eb 17                	jmp    80105061 <safestrcpy+0x31>
8010504a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105050:	83 c2 01             	add    $0x1,%edx
80105053:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80105057:	83 c1 01             	add    $0x1,%ecx
8010505a:	84 db                	test   %bl,%bl
8010505c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010505f:	74 04                	je     80105065 <safestrcpy+0x35>
80105061:	39 f2                	cmp    %esi,%edx
80105063:	75 eb                	jne    80105050 <safestrcpy+0x20>
    ;
  *s = 0;
80105065:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80105068:	5b                   	pop    %ebx
80105069:	5e                   	pop    %esi
8010506a:	5d                   	pop    %ebp
8010506b:	c3                   	ret    
8010506c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105070 <strlen>:

int
strlen(const char *s)
{
80105070:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105071:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80105073:	89 e5                	mov    %esp,%ebp
80105075:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80105078:	80 3a 00             	cmpb   $0x0,(%edx)
8010507b:	74 0c                	je     80105089 <strlen+0x19>
8010507d:	8d 76 00             	lea    0x0(%esi),%esi
80105080:	83 c0 01             	add    $0x1,%eax
80105083:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105087:	75 f7                	jne    80105080 <strlen+0x10>
    ;
  return n;
}
80105089:	5d                   	pop    %ebp
8010508a:	c3                   	ret    
8010508b:	90                   	nop
8010508c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105090 <strcmp>:

int
strcmp(const char *p, const char *q)
{
80105090:	55                   	push   %ebp
80105091:	89 e5                	mov    %esp,%ebp
80105093:	56                   	push   %esi
80105094:	53                   	push   %ebx
80105095:	8b 55 08             	mov    0x8(%ebp),%edx
80105098:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
8010509b:	0f b6 02             	movzbl (%edx),%eax
8010509e:	0f b6 19             	movzbl (%ecx),%ebx
801050a1:	84 c0                	test   %al,%al
801050a3:	75 1e                	jne    801050c3 <strcmp+0x33>
801050a5:	eb 29                	jmp    801050d0 <strcmp+0x40>
801050a7:	89 f6                	mov    %esi,%esi
801050a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
801050b0:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
801050b3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
801050b6:	8d 71 01             	lea    0x1(%ecx),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
801050b9:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
801050bd:	84 c0                	test   %al,%al
801050bf:	74 0f                	je     801050d0 <strcmp+0x40>
801050c1:	89 f1                	mov    %esi,%ecx
801050c3:	38 d8                	cmp    %bl,%al
801050c5:	74 e9                	je     801050b0 <strcmp+0x20>
    p++, q++;
  return (uchar)*p - (uchar)*q;
801050c7:	29 d8                	sub    %ebx,%eax
}
801050c9:	5b                   	pop    %ebx
801050ca:	5e                   	pop    %esi
801050cb:	5d                   	pop    %ebp
801050cc:	c3                   	ret    
801050cd:	8d 76 00             	lea    0x0(%esi),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
801050d0:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
801050d2:	29 d8                	sub    %ebx,%eax
}
801050d4:	5b                   	pop    %ebx
801050d5:	5e                   	pop    %esi
801050d6:	5d                   	pop    %ebp
801050d7:	c3                   	ret    

801050d8 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801050d8:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801050dc:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801050e0:	55                   	push   %ebp
  pushl %ebx
801050e1:	53                   	push   %ebx
  pushl %esi
801050e2:	56                   	push   %esi
  pushl %edi
801050e3:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801050e4:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801050e6:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801050e8:	5f                   	pop    %edi
  popl %esi
801050e9:	5e                   	pop    %esi
  popl %ebx
801050ea:	5b                   	pop    %ebx
  popl %ebp
801050eb:	5d                   	pop    %ebp
  ret
801050ec:	c3                   	ret    
801050ed:	66 90                	xchg   %ax,%ax
801050ef:	90                   	nop

801050f0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801050f0:	55                   	push   %ebp
801050f1:	89 e5                	mov    %esp,%ebp
801050f3:	53                   	push   %ebx
801050f4:	83 ec 04             	sub    $0x4,%esp
801050f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801050fa:	e8 81 eb ff ff       	call   80103c80 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801050ff:	8b 00                	mov    (%eax),%eax
80105101:	39 d8                	cmp    %ebx,%eax
80105103:	76 1b                	jbe    80105120 <fetchint+0x30>
80105105:	8d 53 04             	lea    0x4(%ebx),%edx
80105108:	39 d0                	cmp    %edx,%eax
8010510a:	72 14                	jb     80105120 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010510c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010510f:	8b 13                	mov    (%ebx),%edx
80105111:	89 10                	mov    %edx,(%eax)
  return 0;
80105113:	31 c0                	xor    %eax,%eax
}
80105115:	83 c4 04             	add    $0x4,%esp
80105118:	5b                   	pop    %ebx
80105119:	5d                   	pop    %ebp
8010511a:	c3                   	ret    
8010511b:	90                   	nop
8010511c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80105120:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105125:	eb ee                	jmp    80105115 <fetchint+0x25>
80105127:	89 f6                	mov    %esi,%esi
80105129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105130 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105130:	55                   	push   %ebp
80105131:	89 e5                	mov    %esp,%ebp
80105133:	53                   	push   %ebx
80105134:	83 ec 04             	sub    $0x4,%esp
80105137:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010513a:	e8 41 eb ff ff       	call   80103c80 <myproc>

  if(addr >= curproc->sz)
8010513f:	39 18                	cmp    %ebx,(%eax)
80105141:	76 29                	jbe    8010516c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80105143:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105146:	89 da                	mov    %ebx,%edx
80105148:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010514a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010514c:	39 c3                	cmp    %eax,%ebx
8010514e:	73 1c                	jae    8010516c <fetchstr+0x3c>
    if(*s == 0)
80105150:	80 3b 00             	cmpb   $0x0,(%ebx)
80105153:	75 10                	jne    80105165 <fetchstr+0x35>
80105155:	eb 29                	jmp    80105180 <fetchstr+0x50>
80105157:	89 f6                	mov    %esi,%esi
80105159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105160:	80 3a 00             	cmpb   $0x0,(%edx)
80105163:	74 1b                	je     80105180 <fetchstr+0x50>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
80105165:	83 c2 01             	add    $0x1,%edx
80105168:	39 d0                	cmp    %edx,%eax
8010516a:	77 f4                	ja     80105160 <fetchstr+0x30>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
8010516c:	83 c4 04             	add    $0x4,%esp
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;
8010516f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80105174:	5b                   	pop    %ebx
80105175:	5d                   	pop    %ebp
80105176:	c3                   	ret    
80105177:	89 f6                	mov    %esi,%esi
80105179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105180:	83 c4 04             	add    $0x4,%esp
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
80105183:	89 d0                	mov    %edx,%eax
80105185:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80105187:	5b                   	pop    %ebx
80105188:	5d                   	pop    %ebp
80105189:	c3                   	ret    
8010518a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105190 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105190:	55                   	push   %ebp
80105191:	89 e5                	mov    %esp,%ebp
80105193:	56                   	push   %esi
80105194:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105195:	e8 e6 ea ff ff       	call   80103c80 <myproc>
8010519a:	8b 40 18             	mov    0x18(%eax),%eax
8010519d:	8b 55 08             	mov    0x8(%ebp),%edx
801051a0:	8b 40 44             	mov    0x44(%eax),%eax
801051a3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();
801051a6:	e8 d5 ea ff ff       	call   80103c80 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801051ab:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801051ad:	8d 73 04             	lea    0x4(%ebx),%esi
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801051b0:	39 c6                	cmp    %eax,%esi
801051b2:	73 1c                	jae    801051d0 <argint+0x40>
801051b4:	8d 53 08             	lea    0x8(%ebx),%edx
801051b7:	39 d0                	cmp    %edx,%eax
801051b9:	72 15                	jb     801051d0 <argint+0x40>
    return -1;
  *ip = *(int*)(addr);
801051bb:	8b 45 0c             	mov    0xc(%ebp),%eax
801051be:	8b 53 04             	mov    0x4(%ebx),%edx
801051c1:	89 10                	mov    %edx,(%eax)
  return 0;
801051c3:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
}
801051c5:	5b                   	pop    %ebx
801051c6:	5e                   	pop    %esi
801051c7:	5d                   	pop    %ebp
801051c8:	c3                   	ret    
801051c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
801051d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051d5:	eb ee                	jmp    801051c5 <argint+0x35>
801051d7:	89 f6                	mov    %esi,%esi
801051d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051e0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801051e0:	55                   	push   %ebp
801051e1:	89 e5                	mov    %esp,%ebp
801051e3:	56                   	push   %esi
801051e4:	53                   	push   %ebx
801051e5:	83 ec 10             	sub    $0x10,%esp
801051e8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801051eb:	e8 90 ea ff ff       	call   80103c80 <myproc>
801051f0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
801051f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051f5:	83 ec 08             	sub    $0x8,%esp
801051f8:	50                   	push   %eax
801051f9:	ff 75 08             	pushl  0x8(%ebp)
801051fc:	e8 8f ff ff ff       	call   80105190 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105201:	c1 e8 1f             	shr    $0x1f,%eax
80105204:	83 c4 10             	add    $0x10,%esp
80105207:	84 c0                	test   %al,%al
80105209:	75 2d                	jne    80105238 <argptr+0x58>
8010520b:	89 d8                	mov    %ebx,%eax
8010520d:	c1 e8 1f             	shr    $0x1f,%eax
80105210:	84 c0                	test   %al,%al
80105212:	75 24                	jne    80105238 <argptr+0x58>
80105214:	8b 16                	mov    (%esi),%edx
80105216:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105219:	39 c2                	cmp    %eax,%edx
8010521b:	76 1b                	jbe    80105238 <argptr+0x58>
8010521d:	01 c3                	add    %eax,%ebx
8010521f:	39 da                	cmp    %ebx,%edx
80105221:	72 15                	jb     80105238 <argptr+0x58>
    return -1;
  *pp = (char*)i;
80105223:	8b 55 0c             	mov    0xc(%ebp),%edx
80105226:	89 02                	mov    %eax,(%edx)
  return 0;
80105228:	31 c0                	xor    %eax,%eax
}
8010522a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010522d:	5b                   	pop    %ebx
8010522e:	5e                   	pop    %esi
8010522f:	5d                   	pop    %ebp
80105230:	c3                   	ret    
80105231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
80105238:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010523d:	eb eb                	jmp    8010522a <argptr+0x4a>
8010523f:	90                   	nop

80105240 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105240:	55                   	push   %ebp
80105241:	89 e5                	mov    %esp,%ebp
80105243:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105246:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105249:	50                   	push   %eax
8010524a:	ff 75 08             	pushl  0x8(%ebp)
8010524d:	e8 3e ff ff ff       	call   80105190 <argint>
80105252:	83 c4 10             	add    $0x10,%esp
80105255:	85 c0                	test   %eax,%eax
80105257:	78 17                	js     80105270 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105259:	83 ec 08             	sub    $0x8,%esp
8010525c:	ff 75 0c             	pushl  0xc(%ebp)
8010525f:	ff 75 f4             	pushl  -0xc(%ebp)
80105262:	e8 c9 fe ff ff       	call   80105130 <fetchstr>
80105267:	83 c4 10             	add    $0x10,%esp
}
8010526a:	c9                   	leave  
8010526b:	c3                   	ret    
8010526c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80105270:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
80105275:	c9                   	leave  
80105276:	c3                   	ret    
80105277:	89 f6                	mov    %esi,%esi
80105279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105280 <syscall>:
[SYS_yield]   sys_yield,
};

void
syscall(void)
{
80105280:	55                   	push   %ebp
80105281:	89 e5                	mov    %esp,%ebp
80105283:	56                   	push   %esi
80105284:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80105285:	e8 f6 e9 ff ff       	call   80103c80 <myproc>

  num = curproc->tf->eax;
8010528a:	8b 70 18             	mov    0x18(%eax),%esi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
8010528d:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010528f:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105292:	8d 50 ff             	lea    -0x1(%eax),%edx
80105295:	83 fa 15             	cmp    $0x15,%edx
80105298:	77 1e                	ja     801052b8 <syscall+0x38>
8010529a:	8b 14 85 20 88 10 80 	mov    -0x7fef77e0(,%eax,4),%edx
801052a1:	85 d2                	test   %edx,%edx
801052a3:	74 13                	je     801052b8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
801052a5:	ff d2                	call   *%edx
801052a7:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801052aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052ad:	5b                   	pop    %ebx
801052ae:	5e                   	pop    %esi
801052af:	5d                   	pop    %ebp
801052b0:	c3                   	ret    
801052b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801052b8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801052b9:	8d 43 6c             	lea    0x6c(%ebx),%eax

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801052bc:	50                   	push   %eax
801052bd:	ff 73 10             	pushl  0x10(%ebx)
801052c0:	68 ef 87 10 80       	push   $0x801087ef
801052c5:	e8 96 b3 ff ff       	call   80100660 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
801052ca:	8b 43 18             	mov    0x18(%ebx),%eax
801052cd:	83 c4 10             	add    $0x10,%esp
801052d0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801052d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052da:	5b                   	pop    %ebx
801052db:	5e                   	pop    %esi
801052dc:	5d                   	pop    %ebp
801052dd:	c3                   	ret    
801052de:	66 90                	xchg   %ax,%ax

801052e0 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
801052e0:	55                   	push   %ebp
801052e1:	89 e5                	mov    %esp,%ebp
801052e3:	56                   	push   %esi
801052e4:	53                   	push   %ebx
801052e5:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801052e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
801052ea:	89 d3                	mov    %edx,%ebx
801052ec:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801052ef:	50                   	push   %eax
801052f0:	6a 00                	push   $0x0
801052f2:	e8 99 fe ff ff       	call   80105190 <argint>
801052f7:	83 c4 10             	add    $0x10,%esp
801052fa:	85 c0                	test   %eax,%eax
801052fc:	78 32                	js     80105330 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801052fe:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105302:	77 2c                	ja     80105330 <argfd.constprop.0+0x50>
80105304:	e8 77 e9 ff ff       	call   80103c80 <myproc>
80105309:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010530c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105310:	85 c0                	test   %eax,%eax
80105312:	74 1c                	je     80105330 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
80105314:	85 f6                	test   %esi,%esi
80105316:	74 02                	je     8010531a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105318:	89 16                	mov    %edx,(%esi)
  if(pf)
8010531a:	85 db                	test   %ebx,%ebx
8010531c:	74 22                	je     80105340 <argfd.constprop.0+0x60>
    *pf = f;
8010531e:	89 03                	mov    %eax,(%ebx)
  return 0;
80105320:	31 c0                	xor    %eax,%eax
}
80105322:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105325:	5b                   	pop    %ebx
80105326:	5e                   	pop    %esi
80105327:	5d                   	pop    %ebp
80105328:	c3                   	ret    
80105329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105330:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80105333:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
80105338:	5b                   	pop    %ebx
80105339:	5e                   	pop    %esi
8010533a:	5d                   	pop    %ebp
8010533b:	c3                   	ret    
8010533c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80105340:	31 c0                	xor    %eax,%eax
80105342:	eb de                	jmp    80105322 <argfd.constprop.0+0x42>
80105344:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010534a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105350 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80105350:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105351:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80105353:	89 e5                	mov    %esp,%ebp
80105355:	56                   	push   %esi
80105356:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105357:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
8010535a:	83 ec 10             	sub    $0x10,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
8010535d:	e8 7e ff ff ff       	call   801052e0 <argfd.constprop.0>
80105362:	85 c0                	test   %eax,%eax
80105364:	78 1a                	js     80105380 <sys_dup+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105366:	31 db                	xor    %ebx,%ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
80105368:	8b 75 f4             	mov    -0xc(%ebp),%esi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
8010536b:	e8 10 e9 ff ff       	call   80103c80 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105370:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105374:	85 d2                	test   %edx,%edx
80105376:	74 18                	je     80105390 <sys_dup+0x40>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105378:	83 c3 01             	add    $0x1,%ebx
8010537b:	83 fb 10             	cmp    $0x10,%ebx
8010537e:	75 f0                	jne    80105370 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80105380:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80105383:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80105388:	5b                   	pop    %ebx
80105389:	5e                   	pop    %esi
8010538a:	5d                   	pop    %ebp
8010538b:	c3                   	ret    
8010538c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105390:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80105394:	83 ec 0c             	sub    $0xc,%esp
80105397:	ff 75 f4             	pushl  -0xc(%ebp)
8010539a:	e8 d1 ba ff ff       	call   80100e70 <filedup>
  return fd;
8010539f:	83 c4 10             	add    $0x10,%esp
}
801053a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
801053a5:	89 d8                	mov    %ebx,%eax
}
801053a7:	5b                   	pop    %ebx
801053a8:	5e                   	pop    %esi
801053a9:	5d                   	pop    %ebp
801053aa:	c3                   	ret    
801053ab:	90                   	nop
801053ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053b0 <sys_read>:

int
sys_read(void)
{
801053b0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801053b1:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
801053b3:	89 e5                	mov    %esp,%ebp
801053b5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801053b8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801053bb:	e8 20 ff ff ff       	call   801052e0 <argfd.constprop.0>
801053c0:	85 c0                	test   %eax,%eax
801053c2:	78 4c                	js     80105410 <sys_read+0x60>
801053c4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053c7:	83 ec 08             	sub    $0x8,%esp
801053ca:	50                   	push   %eax
801053cb:	6a 02                	push   $0x2
801053cd:	e8 be fd ff ff       	call   80105190 <argint>
801053d2:	83 c4 10             	add    $0x10,%esp
801053d5:	85 c0                	test   %eax,%eax
801053d7:	78 37                	js     80105410 <sys_read+0x60>
801053d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053dc:	83 ec 04             	sub    $0x4,%esp
801053df:	ff 75 f0             	pushl  -0x10(%ebp)
801053e2:	50                   	push   %eax
801053e3:	6a 01                	push   $0x1
801053e5:	e8 f6 fd ff ff       	call   801051e0 <argptr>
801053ea:	83 c4 10             	add    $0x10,%esp
801053ed:	85 c0                	test   %eax,%eax
801053ef:	78 1f                	js     80105410 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
801053f1:	83 ec 04             	sub    $0x4,%esp
801053f4:	ff 75 f0             	pushl  -0x10(%ebp)
801053f7:	ff 75 f4             	pushl  -0xc(%ebp)
801053fa:	ff 75 ec             	pushl  -0x14(%ebp)
801053fd:	e8 de bb ff ff       	call   80100fe0 <fileread>
80105402:	83 c4 10             	add    $0x10,%esp
}
80105405:	c9                   	leave  
80105406:	c3                   	ret    
80105407:	89 f6                	mov    %esi,%esi
80105409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80105410:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80105415:	c9                   	leave  
80105416:	c3                   	ret    
80105417:	89 f6                	mov    %esi,%esi
80105419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105420 <sys_write>:

int
sys_write(void)
{
80105420:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105421:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80105423:	89 e5                	mov    %esp,%ebp
80105425:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105428:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010542b:	e8 b0 fe ff ff       	call   801052e0 <argfd.constprop.0>
80105430:	85 c0                	test   %eax,%eax
80105432:	78 4c                	js     80105480 <sys_write+0x60>
80105434:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105437:	83 ec 08             	sub    $0x8,%esp
8010543a:	50                   	push   %eax
8010543b:	6a 02                	push   $0x2
8010543d:	e8 4e fd ff ff       	call   80105190 <argint>
80105442:	83 c4 10             	add    $0x10,%esp
80105445:	85 c0                	test   %eax,%eax
80105447:	78 37                	js     80105480 <sys_write+0x60>
80105449:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010544c:	83 ec 04             	sub    $0x4,%esp
8010544f:	ff 75 f0             	pushl  -0x10(%ebp)
80105452:	50                   	push   %eax
80105453:	6a 01                	push   $0x1
80105455:	e8 86 fd ff ff       	call   801051e0 <argptr>
8010545a:	83 c4 10             	add    $0x10,%esp
8010545d:	85 c0                	test   %eax,%eax
8010545f:	78 1f                	js     80105480 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80105461:	83 ec 04             	sub    $0x4,%esp
80105464:	ff 75 f0             	pushl  -0x10(%ebp)
80105467:	ff 75 f4             	pushl  -0xc(%ebp)
8010546a:	ff 75 ec             	pushl  -0x14(%ebp)
8010546d:	e8 fe bb ff ff       	call   80101070 <filewrite>
80105472:	83 c4 10             	add    $0x10,%esp
}
80105475:	c9                   	leave  
80105476:	c3                   	ret    
80105477:	89 f6                	mov    %esi,%esi
80105479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80105480:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80105485:	c9                   	leave  
80105486:	c3                   	ret    
80105487:	89 f6                	mov    %esi,%esi
80105489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105490 <sys_close>:

int
sys_close(void)
{
80105490:	55                   	push   %ebp
80105491:	89 e5                	mov    %esp,%ebp
80105493:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105496:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105499:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010549c:	e8 3f fe ff ff       	call   801052e0 <argfd.constprop.0>
801054a1:	85 c0                	test   %eax,%eax
801054a3:	78 2b                	js     801054d0 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
801054a5:	e8 d6 e7 ff ff       	call   80103c80 <myproc>
801054aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801054ad:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
801054b0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801054b7:	00 
  fileclose(f);
801054b8:	ff 75 f4             	pushl  -0xc(%ebp)
801054bb:	e8 00 ba ff ff       	call   80100ec0 <fileclose>
  return 0;
801054c0:	83 c4 10             	add    $0x10,%esp
801054c3:	31 c0                	xor    %eax,%eax
}
801054c5:	c9                   	leave  
801054c6:	c3                   	ret    
801054c7:	89 f6                	mov    %esi,%esi
801054c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
801054d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
801054d5:	c9                   	leave  
801054d6:	c3                   	ret    
801054d7:	89 f6                	mov    %esi,%esi
801054d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054e0 <sys_fstat>:

int
sys_fstat(void)
{
801054e0:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801054e1:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
801054e3:	89 e5                	mov    %esp,%ebp
801054e5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801054e8:	8d 55 f0             	lea    -0x10(%ebp),%edx
801054eb:	e8 f0 fd ff ff       	call   801052e0 <argfd.constprop.0>
801054f0:	85 c0                	test   %eax,%eax
801054f2:	78 2c                	js     80105520 <sys_fstat+0x40>
801054f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054f7:	83 ec 04             	sub    $0x4,%esp
801054fa:	6a 14                	push   $0x14
801054fc:	50                   	push   %eax
801054fd:	6a 01                	push   $0x1
801054ff:	e8 dc fc ff ff       	call   801051e0 <argptr>
80105504:	83 c4 10             	add    $0x10,%esp
80105507:	85 c0                	test   %eax,%eax
80105509:	78 15                	js     80105520 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
8010550b:	83 ec 08             	sub    $0x8,%esp
8010550e:	ff 75 f4             	pushl  -0xc(%ebp)
80105511:	ff 75 f0             	pushl  -0x10(%ebp)
80105514:	e8 77 ba ff ff       	call   80100f90 <filestat>
80105519:	83 c4 10             	add    $0x10,%esp
}
8010551c:	c9                   	leave  
8010551d:	c3                   	ret    
8010551e:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80105520:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80105525:	c9                   	leave  
80105526:	c3                   	ret    
80105527:	89 f6                	mov    %esi,%esi
80105529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105530 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
80105533:	57                   	push   %edi
80105534:	56                   	push   %esi
80105535:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105536:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105539:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010553c:	50                   	push   %eax
8010553d:	6a 00                	push   $0x0
8010553f:	e8 fc fc ff ff       	call   80105240 <argstr>
80105544:	83 c4 10             	add    $0x10,%esp
80105547:	85 c0                	test   %eax,%eax
80105549:	0f 88 fb 00 00 00    	js     8010564a <sys_link+0x11a>
8010554f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105552:	83 ec 08             	sub    $0x8,%esp
80105555:	50                   	push   %eax
80105556:	6a 01                	push   $0x1
80105558:	e8 e3 fc ff ff       	call   80105240 <argstr>
8010555d:	83 c4 10             	add    $0x10,%esp
80105560:	85 c0                	test   %eax,%eax
80105562:	0f 88 e2 00 00 00    	js     8010564a <sys_link+0x11a>
    return -1;

  begin_op();
80105568:	e8 53 da ff ff       	call   80102fc0 <begin_op>
  if((ip = namei(old)) == 0){
8010556d:	83 ec 0c             	sub    $0xc,%esp
80105570:	ff 75 d4             	pushl  -0x2c(%ebp)
80105573:	e8 d8 c9 ff ff       	call   80101f50 <namei>
80105578:	83 c4 10             	add    $0x10,%esp
8010557b:	85 c0                	test   %eax,%eax
8010557d:	89 c3                	mov    %eax,%ebx
8010557f:	0f 84 f3 00 00 00    	je     80105678 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
80105585:	83 ec 0c             	sub    $0xc,%esp
80105588:	50                   	push   %eax
80105589:	e8 72 c1 ff ff       	call   80101700 <ilock>
  if(ip->type == T_DIR){
8010558e:	83 c4 10             	add    $0x10,%esp
80105591:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105596:	0f 84 c4 00 00 00    	je     80105660 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
8010559c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
801055a1:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
801055a4:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
801055a7:	53                   	push   %ebx
801055a8:	e8 a3 c0 ff ff       	call   80101650 <iupdate>
  iunlock(ip);
801055ad:	89 1c 24             	mov    %ebx,(%esp)
801055b0:	e8 2b c2 ff ff       	call   801017e0 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
801055b5:	58                   	pop    %eax
801055b6:	5a                   	pop    %edx
801055b7:	57                   	push   %edi
801055b8:	ff 75 d0             	pushl  -0x30(%ebp)
801055bb:	e8 b0 c9 ff ff       	call   80101f70 <nameiparent>
801055c0:	83 c4 10             	add    $0x10,%esp
801055c3:	85 c0                	test   %eax,%eax
801055c5:	89 c6                	mov    %eax,%esi
801055c7:	74 5b                	je     80105624 <sys_link+0xf4>
    goto bad;
  ilock(dp);
801055c9:	83 ec 0c             	sub    $0xc,%esp
801055cc:	50                   	push   %eax
801055cd:	e8 2e c1 ff ff       	call   80101700 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801055d2:	83 c4 10             	add    $0x10,%esp
801055d5:	8b 03                	mov    (%ebx),%eax
801055d7:	39 06                	cmp    %eax,(%esi)
801055d9:	75 3d                	jne    80105618 <sys_link+0xe8>
801055db:	83 ec 04             	sub    $0x4,%esp
801055de:	ff 73 04             	pushl  0x4(%ebx)
801055e1:	57                   	push   %edi
801055e2:	56                   	push   %esi
801055e3:	e8 a8 c8 ff ff       	call   80101e90 <dirlink>
801055e8:	83 c4 10             	add    $0x10,%esp
801055eb:	85 c0                	test   %eax,%eax
801055ed:	78 29                	js     80105618 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
801055ef:	83 ec 0c             	sub    $0xc,%esp
801055f2:	56                   	push   %esi
801055f3:	e8 98 c3 ff ff       	call   80101990 <iunlockput>
  iput(ip);
801055f8:	89 1c 24             	mov    %ebx,(%esp)
801055fb:	e8 30 c2 ff ff       	call   80101830 <iput>

  end_op();
80105600:	e8 2b da ff ff       	call   80103030 <end_op>

  return 0;
80105605:	83 c4 10             	add    $0x10,%esp
80105608:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
8010560a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010560d:	5b                   	pop    %ebx
8010560e:	5e                   	pop    %esi
8010560f:	5f                   	pop    %edi
80105610:	5d                   	pop    %ebp
80105611:	c3                   	ret    
80105612:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80105618:	83 ec 0c             	sub    $0xc,%esp
8010561b:	56                   	push   %esi
8010561c:	e8 6f c3 ff ff       	call   80101990 <iunlockput>
    goto bad;
80105621:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
80105624:	83 ec 0c             	sub    $0xc,%esp
80105627:	53                   	push   %ebx
80105628:	e8 d3 c0 ff ff       	call   80101700 <ilock>
  ip->nlink--;
8010562d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105632:	89 1c 24             	mov    %ebx,(%esp)
80105635:	e8 16 c0 ff ff       	call   80101650 <iupdate>
  iunlockput(ip);
8010563a:	89 1c 24             	mov    %ebx,(%esp)
8010563d:	e8 4e c3 ff ff       	call   80101990 <iunlockput>
  end_op();
80105642:	e8 e9 d9 ff ff       	call   80103030 <end_op>
  return -1;
80105647:	83 c4 10             	add    $0x10,%esp
}
8010564a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
8010564d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105652:	5b                   	pop    %ebx
80105653:	5e                   	pop    %esi
80105654:	5f                   	pop    %edi
80105655:	5d                   	pop    %ebp
80105656:	c3                   	ret    
80105657:	89 f6                	mov    %esi,%esi
80105659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
80105660:	83 ec 0c             	sub    $0xc,%esp
80105663:	53                   	push   %ebx
80105664:	e8 27 c3 ff ff       	call   80101990 <iunlockput>
    end_op();
80105669:	e8 c2 d9 ff ff       	call   80103030 <end_op>
    return -1;
8010566e:	83 c4 10             	add    $0x10,%esp
80105671:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105676:	eb 92                	jmp    8010560a <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
80105678:	e8 b3 d9 ff ff       	call   80103030 <end_op>
    return -1;
8010567d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105682:	eb 86                	jmp    8010560a <sys_link+0xda>
80105684:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010568a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105690 <isdirempty>:
}

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
80105690:	55                   	push   %ebp
80105691:	89 e5                	mov    %esp,%ebp
80105693:	57                   	push   %edi
80105694:	56                   	push   %esi
80105695:	53                   	push   %ebx
80105696:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105699:	bb 20 00 00 00       	mov    $0x20,%ebx
8010569e:	83 ec 1c             	sub    $0x1c,%esp
801056a1:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801056a4:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
801056a8:	77 0e                	ja     801056b8 <isdirempty+0x28>
801056aa:	eb 34                	jmp    801056e0 <isdirempty+0x50>
801056ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056b0:	83 c3 10             	add    $0x10,%ebx
801056b3:	39 5e 58             	cmp    %ebx,0x58(%esi)
801056b6:	76 28                	jbe    801056e0 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801056b8:	6a 10                	push   $0x10
801056ba:	53                   	push   %ebx
801056bb:	57                   	push   %edi
801056bc:	56                   	push   %esi
801056bd:	e8 1e c3 ff ff       	call   801019e0 <readi>
801056c2:	83 c4 10             	add    $0x10,%esp
801056c5:	83 f8 10             	cmp    $0x10,%eax
801056c8:	75 23                	jne    801056ed <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
801056ca:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801056cf:	74 df                	je     801056b0 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
801056d1:	8d 65 f4             	lea    -0xc(%ebp),%esp

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
801056d4:	31 c0                	xor    %eax,%eax
  }
  return 1;
}
801056d6:	5b                   	pop    %ebx
801056d7:	5e                   	pop    %esi
801056d8:	5f                   	pop    %edi
801056d9:	5d                   	pop    %ebp
801056da:	c3                   	ret    
801056db:	90                   	nop
801056dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
801056e3:	b8 01 00 00 00       	mov    $0x1,%eax
}
801056e8:	5b                   	pop    %ebx
801056e9:	5e                   	pop    %esi
801056ea:	5f                   	pop    %edi
801056eb:	5d                   	pop    %ebp
801056ec:	c3                   	ret    
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
801056ed:	83 ec 0c             	sub    $0xc,%esp
801056f0:	68 7c 88 10 80       	push   $0x8010887c
801056f5:	e8 76 ac ff ff       	call   80100370 <panic>
801056fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105700 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105700:	55                   	push   %ebp
80105701:	89 e5                	mov    %esp,%ebp
80105703:	57                   	push   %edi
80105704:	56                   	push   %esi
80105705:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105706:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
80105709:	83 ec 44             	sub    $0x44,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
8010570c:	50                   	push   %eax
8010570d:	6a 00                	push   $0x0
8010570f:	e8 2c fb ff ff       	call   80105240 <argstr>
80105714:	83 c4 10             	add    $0x10,%esp
80105717:	85 c0                	test   %eax,%eax
80105719:	0f 88 51 01 00 00    	js     80105870 <sys_unlink+0x170>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
8010571f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
80105722:	e8 99 d8 ff ff       	call   80102fc0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105727:	83 ec 08             	sub    $0x8,%esp
8010572a:	53                   	push   %ebx
8010572b:	ff 75 c0             	pushl  -0x40(%ebp)
8010572e:	e8 3d c8 ff ff       	call   80101f70 <nameiparent>
80105733:	83 c4 10             	add    $0x10,%esp
80105736:	85 c0                	test   %eax,%eax
80105738:	89 c6                	mov    %eax,%esi
8010573a:	0f 84 37 01 00 00    	je     80105877 <sys_unlink+0x177>
    end_op();
    return -1;
  }

  ilock(dp);
80105740:	83 ec 0c             	sub    $0xc,%esp
80105743:	50                   	push   %eax
80105744:	e8 b7 bf ff ff       	call   80101700 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105749:	58                   	pop    %eax
8010574a:	5a                   	pop    %edx
8010574b:	68 7d 81 10 80       	push   $0x8010817d
80105750:	53                   	push   %ebx
80105751:	e8 ba c4 ff ff       	call   80101c10 <namecmp>
80105756:	83 c4 10             	add    $0x10,%esp
80105759:	85 c0                	test   %eax,%eax
8010575b:	0f 84 d3 00 00 00    	je     80105834 <sys_unlink+0x134>
80105761:	83 ec 08             	sub    $0x8,%esp
80105764:	68 7c 81 10 80       	push   $0x8010817c
80105769:	53                   	push   %ebx
8010576a:	e8 a1 c4 ff ff       	call   80101c10 <namecmp>
8010576f:	83 c4 10             	add    $0x10,%esp
80105772:	85 c0                	test   %eax,%eax
80105774:	0f 84 ba 00 00 00    	je     80105834 <sys_unlink+0x134>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010577a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010577d:	83 ec 04             	sub    $0x4,%esp
80105780:	50                   	push   %eax
80105781:	53                   	push   %ebx
80105782:	56                   	push   %esi
80105783:	e8 a8 c4 ff ff       	call   80101c30 <dirlookup>
80105788:	83 c4 10             	add    $0x10,%esp
8010578b:	85 c0                	test   %eax,%eax
8010578d:	89 c3                	mov    %eax,%ebx
8010578f:	0f 84 9f 00 00 00    	je     80105834 <sys_unlink+0x134>
    goto bad;
  ilock(ip);
80105795:	83 ec 0c             	sub    $0xc,%esp
80105798:	50                   	push   %eax
80105799:	e8 62 bf ff ff       	call   80101700 <ilock>

  if(ip->nlink < 1)
8010579e:	83 c4 10             	add    $0x10,%esp
801057a1:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801057a6:	0f 8e e4 00 00 00    	jle    80105890 <sys_unlink+0x190>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
801057ac:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801057b1:	74 65                	je     80105818 <sys_unlink+0x118>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
801057b3:	8d 7d d8             	lea    -0x28(%ebp),%edi
801057b6:	83 ec 04             	sub    $0x4,%esp
801057b9:	6a 10                	push   $0x10
801057bb:	6a 00                	push   $0x0
801057bd:	57                   	push   %edi
801057be:	e8 6d f6 ff ff       	call   80104e30 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801057c3:	6a 10                	push   $0x10
801057c5:	ff 75 c4             	pushl  -0x3c(%ebp)
801057c8:	57                   	push   %edi
801057c9:	56                   	push   %esi
801057ca:	e8 11 c3 ff ff       	call   80101ae0 <writei>
801057cf:	83 c4 20             	add    $0x20,%esp
801057d2:	83 f8 10             	cmp    $0x10,%eax
801057d5:	0f 85 a8 00 00 00    	jne    80105883 <sys_unlink+0x183>
    panic("unlink: writei");
  if(ip->type == T_DIR){
801057db:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801057e0:	74 76                	je     80105858 <sys_unlink+0x158>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
801057e2:	83 ec 0c             	sub    $0xc,%esp
801057e5:	56                   	push   %esi
801057e6:	e8 a5 c1 ff ff       	call   80101990 <iunlockput>

  ip->nlink--;
801057eb:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801057f0:	89 1c 24             	mov    %ebx,(%esp)
801057f3:	e8 58 be ff ff       	call   80101650 <iupdate>
  iunlockput(ip);
801057f8:	89 1c 24             	mov    %ebx,(%esp)
801057fb:	e8 90 c1 ff ff       	call   80101990 <iunlockput>

  end_op();
80105800:	e8 2b d8 ff ff       	call   80103030 <end_op>

  return 0;
80105805:	83 c4 10             	add    $0x10,%esp
80105808:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
8010580a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010580d:	5b                   	pop    %ebx
8010580e:	5e                   	pop    %esi
8010580f:	5f                   	pop    %edi
80105810:	5d                   	pop    %ebp
80105811:	c3                   	ret    
80105812:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80105818:	83 ec 0c             	sub    $0xc,%esp
8010581b:	53                   	push   %ebx
8010581c:	e8 6f fe ff ff       	call   80105690 <isdirempty>
80105821:	83 c4 10             	add    $0x10,%esp
80105824:	85 c0                	test   %eax,%eax
80105826:	75 8b                	jne    801057b3 <sys_unlink+0xb3>
    iunlockput(ip);
80105828:	83 ec 0c             	sub    $0xc,%esp
8010582b:	53                   	push   %ebx
8010582c:	e8 5f c1 ff ff       	call   80101990 <iunlockput>
    goto bad;
80105831:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
80105834:	83 ec 0c             	sub    $0xc,%esp
80105837:	56                   	push   %esi
80105838:	e8 53 c1 ff ff       	call   80101990 <iunlockput>
  end_op();
8010583d:	e8 ee d7 ff ff       	call   80103030 <end_op>
  return -1;
80105842:	83 c4 10             	add    $0x10,%esp
}
80105845:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80105848:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010584d:	5b                   	pop    %ebx
8010584e:	5e                   	pop    %esi
8010584f:	5f                   	pop    %edi
80105850:	5d                   	pop    %ebp
80105851:	c3                   	ret    
80105852:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80105858:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
8010585d:	83 ec 0c             	sub    $0xc,%esp
80105860:	56                   	push   %esi
80105861:	e8 ea bd ff ff       	call   80101650 <iupdate>
80105866:	83 c4 10             	add    $0x10,%esp
80105869:	e9 74 ff ff ff       	jmp    801057e2 <sys_unlink+0xe2>
8010586e:	66 90                	xchg   %ax,%ax
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
80105870:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105875:	eb 93                	jmp    8010580a <sys_unlink+0x10a>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
80105877:	e8 b4 d7 ff ff       	call   80103030 <end_op>
    return -1;
8010587c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105881:	eb 87                	jmp    8010580a <sys_unlink+0x10a>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80105883:	83 ec 0c             	sub    $0xc,%esp
80105886:	68 91 81 10 80       	push   $0x80108191
8010588b:	e8 e0 aa ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80105890:	83 ec 0c             	sub    $0xc,%esp
80105893:	68 7f 81 10 80       	push   $0x8010817f
80105898:	e8 d3 aa ff ff       	call   80100370 <panic>
8010589d:	8d 76 00             	lea    0x0(%esi),%esi

801058a0 <create>:
  return -1;
}

struct inode*
create(char *path, short type, short major, short minor)
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	57                   	push   %edi
801058a4:	56                   	push   %esi
801058a5:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801058a6:	8d 75 da             	lea    -0x26(%ebp),%esi
  return -1;
}

struct inode*
create(char *path, short type, short major, short minor)
{
801058a9:	83 ec 44             	sub    $0x44,%esp
801058ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801058af:	8b 55 10             	mov    0x10(%ebp),%edx
801058b2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801058b5:	56                   	push   %esi
801058b6:	ff 75 08             	pushl  0x8(%ebp)
  return -1;
}

struct inode*
create(char *path, short type, short major, short minor)
{
801058b9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801058bc:	89 55 c0             	mov    %edx,-0x40(%ebp)
801058bf:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801058c2:	e8 a9 c6 ff ff       	call   80101f70 <nameiparent>
801058c7:	83 c4 10             	add    $0x10,%esp
801058ca:	85 c0                	test   %eax,%eax
801058cc:	0f 84 ee 00 00 00    	je     801059c0 <create+0x120>
    return 0;
  ilock(dp);
801058d2:	83 ec 0c             	sub    $0xc,%esp
801058d5:	89 c7                	mov    %eax,%edi
801058d7:	50                   	push   %eax
801058d8:	e8 23 be ff ff       	call   80101700 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801058dd:	8d 45 d4             	lea    -0x2c(%ebp),%eax
801058e0:	83 c4 0c             	add    $0xc,%esp
801058e3:	50                   	push   %eax
801058e4:	56                   	push   %esi
801058e5:	57                   	push   %edi
801058e6:	e8 45 c3 ff ff       	call   80101c30 <dirlookup>
801058eb:	83 c4 10             	add    $0x10,%esp
801058ee:	85 c0                	test   %eax,%eax
801058f0:	89 c3                	mov    %eax,%ebx
801058f2:	74 4c                	je     80105940 <create+0xa0>
    iunlockput(dp);
801058f4:	83 ec 0c             	sub    $0xc,%esp
801058f7:	57                   	push   %edi
801058f8:	e8 93 c0 ff ff       	call   80101990 <iunlockput>
    ilock(ip);
801058fd:	89 1c 24             	mov    %ebx,(%esp)
80105900:	e8 fb bd ff ff       	call   80101700 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105905:	83 c4 10             	add    $0x10,%esp
80105908:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
8010590d:	75 11                	jne    80105920 <create+0x80>
8010590f:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
80105914:	89 d8                	mov    %ebx,%eax
80105916:	75 08                	jne    80105920 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105918:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010591b:	5b                   	pop    %ebx
8010591c:	5e                   	pop    %esi
8010591d:	5f                   	pop    %edi
8010591e:	5d                   	pop    %ebp
8010591f:	c3                   	ret    
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80105920:	83 ec 0c             	sub    $0xc,%esp
80105923:	53                   	push   %ebx
80105924:	e8 67 c0 ff ff       	call   80101990 <iunlockput>
    return 0;
80105929:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010592c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
8010592f:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105931:	5b                   	pop    %ebx
80105932:	5e                   	pop    %esi
80105933:	5f                   	pop    %edi
80105934:	5d                   	pop    %ebp
80105935:	c3                   	ret    
80105936:	8d 76 00             	lea    0x0(%esi),%esi
80105939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105940:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80105944:	83 ec 08             	sub    $0x8,%esp
80105947:	50                   	push   %eax
80105948:	ff 37                	pushl  (%edi)
8010594a:	e8 41 bc ff ff       	call   80101590 <ialloc>
8010594f:	83 c4 10             	add    $0x10,%esp
80105952:	85 c0                	test   %eax,%eax
80105954:	89 c3                	mov    %eax,%ebx
80105956:	0f 84 cc 00 00 00    	je     80105a28 <create+0x188>
    panic("create: ialloc");

  ilock(ip);
8010595c:	83 ec 0c             	sub    $0xc,%esp
8010595f:	50                   	push   %eax
80105960:	e8 9b bd ff ff       	call   80101700 <ilock>
  ip->major = major;
80105965:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80105969:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
8010596d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80105971:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
80105975:	b8 01 00 00 00       	mov    $0x1,%eax
8010597a:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
8010597e:	89 1c 24             	mov    %ebx,(%esp)
80105981:	e8 ca bc ff ff       	call   80101650 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105986:	83 c4 10             	add    $0x10,%esp
80105989:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010598e:	74 40                	je     801059d0 <create+0x130>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105990:	83 ec 04             	sub    $0x4,%esp
80105993:	ff 73 04             	pushl  0x4(%ebx)
80105996:	56                   	push   %esi
80105997:	57                   	push   %edi
80105998:	e8 f3 c4 ff ff       	call   80101e90 <dirlink>
8010599d:	83 c4 10             	add    $0x10,%esp
801059a0:	85 c0                	test   %eax,%eax
801059a2:	78 77                	js     80105a1b <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
801059a4:	83 ec 0c             	sub    $0xc,%esp
801059a7:	57                   	push   %edi
801059a8:	e8 e3 bf ff ff       	call   80101990 <iunlockput>

  return ip;
801059ad:	83 c4 10             	add    $0x10,%esp
}
801059b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
801059b3:	89 d8                	mov    %ebx,%eax
}
801059b5:	5b                   	pop    %ebx
801059b6:	5e                   	pop    %esi
801059b7:	5f                   	pop    %edi
801059b8:	5d                   	pop    %ebp
801059b9:	c3                   	ret    
801059ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
801059c0:	31 c0                	xor    %eax,%eax
801059c2:	e9 51 ff ff ff       	jmp    80105918 <create+0x78>
801059c7:	89 f6                	mov    %esi,%esi
801059c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
801059d0:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
801059d5:	83 ec 0c             	sub    $0xc,%esp
801059d8:	57                   	push   %edi
801059d9:	e8 72 bc ff ff       	call   80101650 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801059de:	83 c4 0c             	add    $0xc,%esp
801059e1:	ff 73 04             	pushl  0x4(%ebx)
801059e4:	68 7d 81 10 80       	push   $0x8010817d
801059e9:	53                   	push   %ebx
801059ea:	e8 a1 c4 ff ff       	call   80101e90 <dirlink>
801059ef:	83 c4 10             	add    $0x10,%esp
801059f2:	85 c0                	test   %eax,%eax
801059f4:	78 18                	js     80105a0e <create+0x16e>
801059f6:	83 ec 04             	sub    $0x4,%esp
801059f9:	ff 77 04             	pushl  0x4(%edi)
801059fc:	68 7c 81 10 80       	push   $0x8010817c
80105a01:	53                   	push   %ebx
80105a02:	e8 89 c4 ff ff       	call   80101e90 <dirlink>
80105a07:	83 c4 10             	add    $0x10,%esp
80105a0a:	85 c0                	test   %eax,%eax
80105a0c:	79 82                	jns    80105990 <create+0xf0>
      panic("create dots");
80105a0e:	83 ec 0c             	sub    $0xc,%esp
80105a11:	68 9d 88 10 80       	push   $0x8010889d
80105a16:	e8 55 a9 ff ff       	call   80100370 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
80105a1b:	83 ec 0c             	sub    $0xc,%esp
80105a1e:	68 a9 88 10 80       	push   $0x801088a9
80105a23:	e8 48 a9 ff ff       	call   80100370 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80105a28:	83 ec 0c             	sub    $0xc,%esp
80105a2b:	68 8e 88 10 80       	push   $0x8010888e
80105a30:	e8 3b a9 ff ff       	call   80100370 <panic>
80105a35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a40 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80105a40:	55                   	push   %ebp
80105a41:	89 e5                	mov    %esp,%ebp
80105a43:	57                   	push   %edi
80105a44:	56                   	push   %esi
80105a45:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105a46:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
80105a49:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105a4c:	50                   	push   %eax
80105a4d:	6a 00                	push   $0x0
80105a4f:	e8 ec f7 ff ff       	call   80105240 <argstr>
80105a54:	83 c4 10             	add    $0x10,%esp
80105a57:	85 c0                	test   %eax,%eax
80105a59:	0f 88 9e 00 00 00    	js     80105afd <sys_open+0xbd>
80105a5f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105a62:	83 ec 08             	sub    $0x8,%esp
80105a65:	50                   	push   %eax
80105a66:	6a 01                	push   $0x1
80105a68:	e8 23 f7 ff ff       	call   80105190 <argint>
80105a6d:	83 c4 10             	add    $0x10,%esp
80105a70:	85 c0                	test   %eax,%eax
80105a72:	0f 88 85 00 00 00    	js     80105afd <sys_open+0xbd>
    return -1;

  begin_op();
80105a78:	e8 43 d5 ff ff       	call   80102fc0 <begin_op>

  if(omode & O_CREATE){
80105a7d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105a81:	0f 85 89 00 00 00    	jne    80105b10 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105a87:	83 ec 0c             	sub    $0xc,%esp
80105a8a:	ff 75 e0             	pushl  -0x20(%ebp)
80105a8d:	e8 be c4 ff ff       	call   80101f50 <namei>
80105a92:	83 c4 10             	add    $0x10,%esp
80105a95:	85 c0                	test   %eax,%eax
80105a97:	89 c6                	mov    %eax,%esi
80105a99:	0f 84 88 00 00 00    	je     80105b27 <sys_open+0xe7>
      end_op();
      return -1;
    }
    ilock(ip);
80105a9f:	83 ec 0c             	sub    $0xc,%esp
80105aa2:	50                   	push   %eax
80105aa3:	e8 58 bc ff ff       	call   80101700 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105aa8:	83 c4 10             	add    $0x10,%esp
80105aab:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105ab0:	0f 84 ca 00 00 00    	je     80105b80 <sys_open+0x140>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105ab6:	e8 45 b3 ff ff       	call   80100e00 <filealloc>
80105abb:	85 c0                	test   %eax,%eax
80105abd:	89 c7                	mov    %eax,%edi
80105abf:	74 2b                	je     80105aec <sys_open+0xac>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105ac1:	31 db                	xor    %ebx,%ebx
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105ac3:	e8 b8 e1 ff ff       	call   80103c80 <myproc>
80105ac8:	90                   	nop
80105ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105ad0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105ad4:	85 d2                	test   %edx,%edx
80105ad6:	74 60                	je     80105b38 <sys_open+0xf8>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105ad8:	83 c3 01             	add    $0x1,%ebx
80105adb:	83 fb 10             	cmp    $0x10,%ebx
80105ade:	75 f0                	jne    80105ad0 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80105ae0:	83 ec 0c             	sub    $0xc,%esp
80105ae3:	57                   	push   %edi
80105ae4:	e8 d7 b3 ff ff       	call   80100ec0 <fileclose>
80105ae9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105aec:	83 ec 0c             	sub    $0xc,%esp
80105aef:	56                   	push   %esi
80105af0:	e8 9b be ff ff       	call   80101990 <iunlockput>
    end_op();
80105af5:	e8 36 d5 ff ff       	call   80103030 <end_op>
    return -1;
80105afa:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80105afd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80105b00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80105b05:	5b                   	pop    %ebx
80105b06:	5e                   	pop    %esi
80105b07:	5f                   	pop    %edi
80105b08:	5d                   	pop    %ebp
80105b09:	c3                   	ret    
80105b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105b10:	6a 00                	push   $0x0
80105b12:	6a 00                	push   $0x0
80105b14:	6a 02                	push   $0x2
80105b16:	ff 75 e0             	pushl  -0x20(%ebp)
80105b19:	e8 82 fd ff ff       	call   801058a0 <create>
    if(ip == 0){
80105b1e:	83 c4 10             	add    $0x10,%esp
80105b21:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105b23:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105b25:	75 8f                	jne    80105ab6 <sys_open+0x76>
      end_op();
80105b27:	e8 04 d5 ff ff       	call   80103030 <end_op>
      return -1;
80105b2c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b31:	eb 41                	jmp    80105b74 <sys_open+0x134>
80105b33:	90                   	nop
80105b34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105b38:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105b3b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105b3f:	56                   	push   %esi
80105b40:	e8 9b bc ff ff       	call   801017e0 <iunlock>
  end_op();
80105b45:	e8 e6 d4 ff ff       	call   80103030 <end_op>

  f->type = FD_INODE;
80105b4a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105b50:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b53:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
80105b56:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105b59:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105b60:	89 d0                	mov    %edx,%eax
80105b62:	83 e0 01             	and    $0x1,%eax
80105b65:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b68:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105b6b:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105b6e:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
80105b72:	89 d8                	mov    %ebx,%eax
}
80105b74:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b77:	5b                   	pop    %ebx
80105b78:	5e                   	pop    %esi
80105b79:	5f                   	pop    %edi
80105b7a:	5d                   	pop    %ebp
80105b7b:	c3                   	ret    
80105b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80105b80:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105b83:	85 c9                	test   %ecx,%ecx
80105b85:	0f 84 2b ff ff ff    	je     80105ab6 <sys_open+0x76>
80105b8b:	e9 5c ff ff ff       	jmp    80105aec <sys_open+0xac>

80105b90 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80105b90:	55                   	push   %ebp
80105b91:	89 e5                	mov    %esp,%ebp
80105b93:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105b96:	e8 25 d4 ff ff       	call   80102fc0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105b9b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b9e:	83 ec 08             	sub    $0x8,%esp
80105ba1:	50                   	push   %eax
80105ba2:	6a 00                	push   $0x0
80105ba4:	e8 97 f6 ff ff       	call   80105240 <argstr>
80105ba9:	83 c4 10             	add    $0x10,%esp
80105bac:	85 c0                	test   %eax,%eax
80105bae:	78 30                	js     80105be0 <sys_mkdir+0x50>
80105bb0:	6a 00                	push   $0x0
80105bb2:	6a 00                	push   $0x0
80105bb4:	6a 01                	push   $0x1
80105bb6:	ff 75 f4             	pushl  -0xc(%ebp)
80105bb9:	e8 e2 fc ff ff       	call   801058a0 <create>
80105bbe:	83 c4 10             	add    $0x10,%esp
80105bc1:	85 c0                	test   %eax,%eax
80105bc3:	74 1b                	je     80105be0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105bc5:	83 ec 0c             	sub    $0xc,%esp
80105bc8:	50                   	push   %eax
80105bc9:	e8 c2 bd ff ff       	call   80101990 <iunlockput>
  end_op();
80105bce:	e8 5d d4 ff ff       	call   80103030 <end_op>
  return 0;
80105bd3:	83 c4 10             	add    $0x10,%esp
80105bd6:	31 c0                	xor    %eax,%eax
}
80105bd8:	c9                   	leave  
80105bd9:	c3                   	ret    
80105bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
80105be0:	e8 4b d4 ff ff       	call   80103030 <end_op>
    return -1;
80105be5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
80105bea:	c9                   	leave  
80105beb:	c3                   	ret    
80105bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105bf0 <sys_mknod>:

int
sys_mknod(void)
{
80105bf0:	55                   	push   %ebp
80105bf1:	89 e5                	mov    %esp,%ebp
80105bf3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105bf6:	e8 c5 d3 ff ff       	call   80102fc0 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105bfb:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105bfe:	83 ec 08             	sub    $0x8,%esp
80105c01:	50                   	push   %eax
80105c02:	6a 00                	push   $0x0
80105c04:	e8 37 f6 ff ff       	call   80105240 <argstr>
80105c09:	83 c4 10             	add    $0x10,%esp
80105c0c:	85 c0                	test   %eax,%eax
80105c0e:	78 60                	js     80105c70 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105c10:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c13:	83 ec 08             	sub    $0x8,%esp
80105c16:	50                   	push   %eax
80105c17:	6a 01                	push   $0x1
80105c19:	e8 72 f5 ff ff       	call   80105190 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
80105c1e:	83 c4 10             	add    $0x10,%esp
80105c21:	85 c0                	test   %eax,%eax
80105c23:	78 4b                	js     80105c70 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105c25:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c28:	83 ec 08             	sub    $0x8,%esp
80105c2b:	50                   	push   %eax
80105c2c:	6a 02                	push   $0x2
80105c2e:	e8 5d f5 ff ff       	call   80105190 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105c33:	83 c4 10             	add    $0x10,%esp
80105c36:	85 c0                	test   %eax,%eax
80105c38:	78 36                	js     80105c70 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105c3a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105c3e:	50                   	push   %eax
80105c3f:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
80105c43:	50                   	push   %eax
80105c44:	6a 03                	push   $0x3
80105c46:	ff 75 ec             	pushl  -0x14(%ebp)
80105c49:	e8 52 fc ff ff       	call   801058a0 <create>
80105c4e:	83 c4 10             	add    $0x10,%esp
80105c51:	85 c0                	test   %eax,%eax
80105c53:	74 1b                	je     80105c70 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
80105c55:	83 ec 0c             	sub    $0xc,%esp
80105c58:	50                   	push   %eax
80105c59:	e8 32 bd ff ff       	call   80101990 <iunlockput>
  end_op();
80105c5e:	e8 cd d3 ff ff       	call   80103030 <end_op>
  return 0;
80105c63:	83 c4 10             	add    $0x10,%esp
80105c66:	31 c0                	xor    %eax,%eax
}
80105c68:	c9                   	leave  
80105c69:	c3                   	ret    
80105c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105c70:	e8 bb d3 ff ff       	call   80103030 <end_op>
    return -1;
80105c75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
80105c7a:	c9                   	leave  
80105c7b:	c3                   	ret    
80105c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c80 <sys_chdir>:

int
sys_chdir(void)
{
80105c80:	55                   	push   %ebp
80105c81:	89 e5                	mov    %esp,%ebp
80105c83:	56                   	push   %esi
80105c84:	53                   	push   %ebx
80105c85:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105c88:	e8 f3 df ff ff       	call   80103c80 <myproc>
80105c8d:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105c8f:	e8 2c d3 ff ff       	call   80102fc0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105c94:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c97:	83 ec 08             	sub    $0x8,%esp
80105c9a:	50                   	push   %eax
80105c9b:	6a 00                	push   $0x0
80105c9d:	e8 9e f5 ff ff       	call   80105240 <argstr>
80105ca2:	83 c4 10             	add    $0x10,%esp
80105ca5:	85 c0                	test   %eax,%eax
80105ca7:	78 77                	js     80105d20 <sys_chdir+0xa0>
80105ca9:	83 ec 0c             	sub    $0xc,%esp
80105cac:	ff 75 f4             	pushl  -0xc(%ebp)
80105caf:	e8 9c c2 ff ff       	call   80101f50 <namei>
80105cb4:	83 c4 10             	add    $0x10,%esp
80105cb7:	85 c0                	test   %eax,%eax
80105cb9:	89 c3                	mov    %eax,%ebx
80105cbb:	74 63                	je     80105d20 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105cbd:	83 ec 0c             	sub    $0xc,%esp
80105cc0:	50                   	push   %eax
80105cc1:	e8 3a ba ff ff       	call   80101700 <ilock>
  if(ip->type != T_DIR){
80105cc6:	83 c4 10             	add    $0x10,%esp
80105cc9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105cce:	75 30                	jne    80105d00 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105cd0:	83 ec 0c             	sub    $0xc,%esp
80105cd3:	53                   	push   %ebx
80105cd4:	e8 07 bb ff ff       	call   801017e0 <iunlock>
  iput(curproc->cwd);
80105cd9:	58                   	pop    %eax
80105cda:	ff 76 68             	pushl  0x68(%esi)
80105cdd:	e8 4e bb ff ff       	call   80101830 <iput>
  end_op();
80105ce2:	e8 49 d3 ff ff       	call   80103030 <end_op>
  curproc->cwd = ip;
80105ce7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105cea:	83 c4 10             	add    $0x10,%esp
80105ced:	31 c0                	xor    %eax,%eax
}
80105cef:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105cf2:	5b                   	pop    %ebx
80105cf3:	5e                   	pop    %esi
80105cf4:	5d                   	pop    %ebp
80105cf5:	c3                   	ret    
80105cf6:	8d 76 00             	lea    0x0(%esi),%esi
80105cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80105d00:	83 ec 0c             	sub    $0xc,%esp
80105d03:	53                   	push   %ebx
80105d04:	e8 87 bc ff ff       	call   80101990 <iunlockput>
    end_op();
80105d09:	e8 22 d3 ff ff       	call   80103030 <end_op>
    return -1;
80105d0e:	83 c4 10             	add    $0x10,%esp
80105d11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d16:	eb d7                	jmp    80105cef <sys_chdir+0x6f>
80105d18:	90                   	nop
80105d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct inode *ip;
  struct proc *curproc = myproc();
  
  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
80105d20:	e8 0b d3 ff ff       	call   80103030 <end_op>
    return -1;
80105d25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d2a:	eb c3                	jmp    80105cef <sys_chdir+0x6f>
80105d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d30 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
80105d30:	55                   	push   %ebp
80105d31:	89 e5                	mov    %esp,%ebp
80105d33:	57                   	push   %edi
80105d34:	56                   	push   %esi
80105d35:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105d36:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
80105d3c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105d42:	50                   	push   %eax
80105d43:	6a 00                	push   $0x0
80105d45:	e8 f6 f4 ff ff       	call   80105240 <argstr>
80105d4a:	83 c4 10             	add    $0x10,%esp
80105d4d:	85 c0                	test   %eax,%eax
80105d4f:	78 7f                	js     80105dd0 <sys_exec+0xa0>
80105d51:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105d57:	83 ec 08             	sub    $0x8,%esp
80105d5a:	50                   	push   %eax
80105d5b:	6a 01                	push   $0x1
80105d5d:	e8 2e f4 ff ff       	call   80105190 <argint>
80105d62:	83 c4 10             	add    $0x10,%esp
80105d65:	85 c0                	test   %eax,%eax
80105d67:	78 67                	js     80105dd0 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105d69:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105d6f:	83 ec 04             	sub    $0x4,%esp
80105d72:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80105d78:	68 80 00 00 00       	push   $0x80
80105d7d:	6a 00                	push   $0x0
80105d7f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105d85:	50                   	push   %eax
80105d86:	31 db                	xor    %ebx,%ebx
80105d88:	e8 a3 f0 ff ff       	call   80104e30 <memset>
80105d8d:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105d90:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105d96:	83 ec 08             	sub    $0x8,%esp
80105d99:	57                   	push   %edi
80105d9a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80105d9d:	50                   	push   %eax
80105d9e:	e8 4d f3 ff ff       	call   801050f0 <fetchint>
80105da3:	83 c4 10             	add    $0x10,%esp
80105da6:	85 c0                	test   %eax,%eax
80105da8:	78 26                	js     80105dd0 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
80105daa:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105db0:	85 c0                	test   %eax,%eax
80105db2:	74 2c                	je     80105de0 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105db4:	83 ec 08             	sub    $0x8,%esp
80105db7:	56                   	push   %esi
80105db8:	50                   	push   %eax
80105db9:	e8 72 f3 ff ff       	call   80105130 <fetchstr>
80105dbe:	83 c4 10             	add    $0x10,%esp
80105dc1:	85 c0                	test   %eax,%eax
80105dc3:	78 0b                	js     80105dd0 <sys_exec+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105dc5:	83 c3 01             	add    $0x1,%ebx
80105dc8:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
80105dcb:	83 fb 20             	cmp    $0x20,%ebx
80105dce:	75 c0                	jne    80105d90 <sys_exec+0x60>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105dd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80105dd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105dd8:	5b                   	pop    %ebx
80105dd9:	5e                   	pop    %esi
80105dda:	5f                   	pop    %edi
80105ddb:	5d                   	pop    %ebp
80105ddc:	c3                   	ret    
80105ddd:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105de0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105de6:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105de9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105df0:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105df4:	50                   	push   %eax
80105df5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105dfb:	e8 f0 ab ff ff       	call   801009f0 <exec>
80105e00:	83 c4 10             	add    $0x10,%esp
}
80105e03:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e06:	5b                   	pop    %ebx
80105e07:	5e                   	pop    %esi
80105e08:	5f                   	pop    %edi
80105e09:	5d                   	pop    %ebp
80105e0a:	c3                   	ret    
80105e0b:	90                   	nop
80105e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e10 <sys_pipe>:

int
sys_pipe(void)
{
80105e10:	55                   	push   %ebp
80105e11:	89 e5                	mov    %esp,%ebp
80105e13:	57                   	push   %edi
80105e14:	56                   	push   %esi
80105e15:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105e16:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
80105e19:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105e1c:	6a 08                	push   $0x8
80105e1e:	50                   	push   %eax
80105e1f:	6a 00                	push   $0x0
80105e21:	e8 ba f3 ff ff       	call   801051e0 <argptr>
80105e26:	83 c4 10             	add    $0x10,%esp
80105e29:	85 c0                	test   %eax,%eax
80105e2b:	78 4a                	js     80105e77 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105e2d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105e30:	83 ec 08             	sub    $0x8,%esp
80105e33:	50                   	push   %eax
80105e34:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105e37:	50                   	push   %eax
80105e38:	e8 23 d8 ff ff       	call   80103660 <pipealloc>
80105e3d:	83 c4 10             	add    $0x10,%esp
80105e40:	85 c0                	test   %eax,%eax
80105e42:	78 33                	js     80105e77 <sys_pipe+0x67>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105e44:	31 db                	xor    %ebx,%ebx
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105e46:	8b 7d e0             	mov    -0x20(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105e49:	e8 32 de ff ff       	call   80103c80 <myproc>
80105e4e:	66 90                	xchg   %ax,%ax

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105e50:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105e54:	85 f6                	test   %esi,%esi
80105e56:	74 30                	je     80105e88 <sys_pipe+0x78>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105e58:	83 c3 01             	add    $0x1,%ebx
80105e5b:	83 fb 10             	cmp    $0x10,%ebx
80105e5e:	75 f0                	jne    80105e50 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105e60:	83 ec 0c             	sub    $0xc,%esp
80105e63:	ff 75 e0             	pushl  -0x20(%ebp)
80105e66:	e8 55 b0 ff ff       	call   80100ec0 <fileclose>
    fileclose(wf);
80105e6b:	58                   	pop    %eax
80105e6c:	ff 75 e4             	pushl  -0x1c(%ebp)
80105e6f:	e8 4c b0 ff ff       	call   80100ec0 <fileclose>
    return -1;
80105e74:	83 c4 10             	add    $0x10,%esp
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105e77:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
80105e7a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105e7f:	5b                   	pop    %ebx
80105e80:	5e                   	pop    %esi
80105e81:	5f                   	pop    %edi
80105e82:	5d                   	pop    %ebp
80105e83:	c3                   	ret    
80105e84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105e88:	8d 73 08             	lea    0x8(%ebx),%esi
80105e8b:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105e8f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105e92:	e8 e9 dd ff ff       	call   80103c80 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
80105e97:	31 d2                	xor    %edx,%edx
80105e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105ea0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105ea4:	85 c9                	test   %ecx,%ecx
80105ea6:	74 18                	je     80105ec0 <sys_pipe+0xb0>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105ea8:	83 c2 01             	add    $0x1,%edx
80105eab:	83 fa 10             	cmp    $0x10,%edx
80105eae:	75 f0                	jne    80105ea0 <sys_pipe+0x90>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105eb0:	e8 cb dd ff ff       	call   80103c80 <myproc>
80105eb5:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105ebc:	00 
80105ebd:	eb a1                	jmp    80105e60 <sys_pipe+0x50>
80105ebf:	90                   	nop
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105ec0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105ec4:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105ec7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105ec9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105ecc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
80105ecf:	8d 65 f4             	lea    -0xc(%ebp),%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
80105ed2:	31 c0                	xor    %eax,%eax
}
80105ed4:	5b                   	pop    %ebx
80105ed5:	5e                   	pop    %esi
80105ed6:	5f                   	pop    %edi
80105ed7:	5d                   	pop    %ebp
80105ed8:	c3                   	ret    
80105ed9:	66 90                	xchg   %ax,%ax
80105edb:	66 90                	xchg   %ax,%ax
80105edd:	66 90                	xchg   %ax,%ax
80105edf:	90                   	nop

80105ee0 <sys_yield>:
#include "mmu.h"
#include "proc.h"


int sys_yield(void)
{
80105ee0:	55                   	push   %ebp
80105ee1:	89 e5                	mov    %esp,%ebp
80105ee3:	83 ec 08             	sub    $0x8,%esp
  yield(); 
80105ee6:	e8 35 e4 ff ff       	call   80104320 <yield>
  return 0;
}
80105eeb:	31 c0                	xor    %eax,%eax
80105eed:	c9                   	leave  
80105eee:	c3                   	ret    
80105eef:	90                   	nop

80105ef0 <sys_fork>:

int
sys_fork(void)
{
80105ef0:	55                   	push   %ebp
80105ef1:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105ef3:	5d                   	pop    %ebp
}

int
sys_fork(void)
{
  return fork();
80105ef4:	e9 27 df ff ff       	jmp    80103e20 <fork>
80105ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f00 <sys_exit>:
}

int
sys_exit(void)
{
80105f00:	55                   	push   %ebp
80105f01:	89 e5                	mov    %esp,%ebp
80105f03:	83 ec 08             	sub    $0x8,%esp
  exit();
80105f06:	e8 85 e2 ff ff       	call   80104190 <exit>
  return 0;  // not reached
}
80105f0b:	31 c0                	xor    %eax,%eax
80105f0d:	c9                   	leave  
80105f0e:	c3                   	ret    
80105f0f:	90                   	nop

80105f10 <sys_wait>:

int
sys_wait(void)
{
80105f10:	55                   	push   %ebp
80105f11:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105f13:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105f14:	e9 17 e5 ff ff       	jmp    80104430 <wait>
80105f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f20 <sys_kill>:
}

int
sys_kill(void)
{
80105f20:	55                   	push   %ebp
80105f21:	89 e5                	mov    %esp,%ebp
80105f23:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105f26:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f29:	50                   	push   %eax
80105f2a:	6a 00                	push   $0x0
80105f2c:	e8 5f f2 ff ff       	call   80105190 <argint>
80105f31:	83 c4 10             	add    $0x10,%esp
80105f34:	85 c0                	test   %eax,%eax
80105f36:	78 18                	js     80105f50 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105f38:	83 ec 0c             	sub    $0xc,%esp
80105f3b:	ff 75 f4             	pushl  -0xc(%ebp)
80105f3e:	e8 4d e6 ff ff       	call   80104590 <kill>
80105f43:	83 c4 10             	add    $0x10,%esp
}
80105f46:	c9                   	leave  
80105f47:	c3                   	ret    
80105f48:	90                   	nop
80105f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105f55:	c9                   	leave  
80105f56:	c3                   	ret    
80105f57:	89 f6                	mov    %esi,%esi
80105f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f60 <sys_getpid>:

int
sys_getpid(void)
{
80105f60:	55                   	push   %ebp
80105f61:	89 e5                	mov    %esp,%ebp
80105f63:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105f66:	e8 15 dd ff ff       	call   80103c80 <myproc>
80105f6b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105f6e:	c9                   	leave  
80105f6f:	c3                   	ret    

80105f70 <sys_sbrk>:

int
sys_sbrk(void)
{
80105f70:	55                   	push   %ebp
80105f71:	89 e5                	mov    %esp,%ebp
80105f73:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105f74:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return myproc()->pid;
}

int
sys_sbrk(void)
{
80105f77:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105f7a:	50                   	push   %eax
80105f7b:	6a 00                	push   $0x0
80105f7d:	e8 0e f2 ff ff       	call   80105190 <argint>
80105f82:	83 c4 10             	add    $0x10,%esp
80105f85:	85 c0                	test   %eax,%eax
80105f87:	78 27                	js     80105fb0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105f89:	e8 f2 dc ff ff       	call   80103c80 <myproc>
  if(growproc(n) < 0)
80105f8e:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
80105f91:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105f93:	ff 75 f4             	pushl  -0xc(%ebp)
80105f96:	e8 05 de ff ff       	call   80103da0 <growproc>
80105f9b:	83 c4 10             	add    $0x10,%esp
80105f9e:	85 c0                	test   %eax,%eax
80105fa0:	78 0e                	js     80105fb0 <sys_sbrk+0x40>
    return -1;
  return addr;
80105fa2:	89 d8                	mov    %ebx,%eax
}
80105fa4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105fa7:	c9                   	leave  
80105fa8:	c3                   	ret    
80105fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105fb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fb5:	eb ed                	jmp    80105fa4 <sys_sbrk+0x34>
80105fb7:	89 f6                	mov    %esi,%esi
80105fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105fc0 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105fc0:	55                   	push   %ebp
80105fc1:	89 e5                	mov    %esp,%ebp
80105fc3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105fc4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return addr;
}

int
sys_sleep(void)
{
80105fc7:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105fca:	50                   	push   %eax
80105fcb:	6a 00                	push   $0x0
80105fcd:	e8 be f1 ff ff       	call   80105190 <argint>
80105fd2:	83 c4 10             	add    $0x10,%esp
80105fd5:	85 c0                	test   %eax,%eax
80105fd7:	0f 88 8a 00 00 00    	js     80106067 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105fdd:	83 ec 0c             	sub    $0xc,%esp
80105fe0:	68 80 e3 11 80       	push   $0x8011e380
80105fe5:	e8 b6 ec ff ff       	call   80104ca0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105fea:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105fed:	83 c4 10             	add    $0x10,%esp
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80105ff0:	8b 1d c0 eb 11 80    	mov    0x8011ebc0,%ebx
  while(ticks - ticks0 < n){
80105ff6:	85 d2                	test   %edx,%edx
80105ff8:	75 27                	jne    80106021 <sys_sleep+0x61>
80105ffa:	eb 54                	jmp    80106050 <sys_sleep+0x90>
80105ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106000:	83 ec 08             	sub    $0x8,%esp
80106003:	68 80 e3 11 80       	push   $0x8011e380
80106008:	68 c0 eb 11 80       	push   $0x8011ebc0
8010600d:	e8 5e e3 ff ff       	call   80104370 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106012:	a1 c0 eb 11 80       	mov    0x8011ebc0,%eax
80106017:	83 c4 10             	add    $0x10,%esp
8010601a:	29 d8                	sub    %ebx,%eax
8010601c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010601f:	73 2f                	jae    80106050 <sys_sleep+0x90>
    if(myproc()->killed){
80106021:	e8 5a dc ff ff       	call   80103c80 <myproc>
80106026:	8b 40 24             	mov    0x24(%eax),%eax
80106029:	85 c0                	test   %eax,%eax
8010602b:	74 d3                	je     80106000 <sys_sleep+0x40>
      release(&tickslock);
8010602d:	83 ec 0c             	sub    $0xc,%esp
80106030:	68 80 e3 11 80       	push   $0x8011e380
80106035:	e8 a6 ed ff ff       	call   80104de0 <release>
      return -1;
8010603a:	83 c4 10             	add    $0x10,%esp
8010603d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
80106042:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106045:	c9                   	leave  
80106046:	c3                   	ret    
80106047:	89 f6                	mov    %esi,%esi
80106049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106050:	83 ec 0c             	sub    $0xc,%esp
80106053:	68 80 e3 11 80       	push   $0x8011e380
80106058:	e8 83 ed ff ff       	call   80104de0 <release>
  return 0;
8010605d:	83 c4 10             	add    $0x10,%esp
80106060:	31 c0                	xor    %eax,%eax
}
80106062:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106065:	c9                   	leave  
80106066:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
80106067:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010606c:	eb d4                	jmp    80106042 <sys_sleep+0x82>
8010606e:	66 90                	xchg   %ax,%ax

80106070 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106070:	55                   	push   %ebp
80106071:	89 e5                	mov    %esp,%ebp
80106073:	53                   	push   %ebx
80106074:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106077:	68 80 e3 11 80       	push   $0x8011e380
8010607c:	e8 1f ec ff ff       	call   80104ca0 <acquire>
  xticks = ticks;
80106081:	8b 1d c0 eb 11 80    	mov    0x8011ebc0,%ebx
  release(&tickslock);
80106087:	c7 04 24 80 e3 11 80 	movl   $0x8011e380,(%esp)
8010608e:	e8 4d ed ff ff       	call   80104de0 <release>
  return xticks;
}
80106093:	89 d8                	mov    %ebx,%eax
80106095:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106098:	c9                   	leave  
80106099:	c3                   	ret    

8010609a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010609a:	1e                   	push   %ds
  pushl %es
8010609b:	06                   	push   %es
  pushl %fs
8010609c:	0f a0                	push   %fs
  pushl %gs
8010609e:	0f a8                	push   %gs
  pushal
801060a0:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801060a1:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801060a5:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801060a7:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801060a9:	54                   	push   %esp
  call trap
801060aa:	e8 e1 00 00 00       	call   80106190 <trap>
  addl $4, %esp
801060af:	83 c4 04             	add    $0x4,%esp

801060b2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801060b2:	61                   	popa   
  popl %gs
801060b3:	0f a9                	pop    %gs
  popl %fs
801060b5:	0f a1                	pop    %fs
  popl %es
801060b7:	07                   	pop    %es
  popl %ds
801060b8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801060b9:	83 c4 08             	add    $0x8,%esp
  iret
801060bc:	cf                   	iret   
801060bd:	66 90                	xchg   %ax,%ax
801060bf:	90                   	nop

801060c0 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801060c0:	31 c0                	xor    %eax,%eax
801060c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801060c8:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
801060cf:	b9 08 00 00 00       	mov    $0x8,%ecx
801060d4:	c6 04 c5 c4 e3 11 80 	movb   $0x0,-0x7fee1c3c(,%eax,8)
801060db:	00 
801060dc:	66 89 0c c5 c2 e3 11 	mov    %cx,-0x7fee1c3e(,%eax,8)
801060e3:	80 
801060e4:	c6 04 c5 c5 e3 11 80 	movb   $0x8e,-0x7fee1c3b(,%eax,8)
801060eb:	8e 
801060ec:	66 89 14 c5 c0 e3 11 	mov    %dx,-0x7fee1c40(,%eax,8)
801060f3:	80 
801060f4:	c1 ea 10             	shr    $0x10,%edx
801060f7:	66 89 14 c5 c6 e3 11 	mov    %dx,-0x7fee1c3a(,%eax,8)
801060fe:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801060ff:	83 c0 01             	add    $0x1,%eax
80106102:	3d 00 01 00 00       	cmp    $0x100,%eax
80106107:	75 bf                	jne    801060c8 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106109:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010610a:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
8010610f:	89 e5                	mov    %esp,%ebp
80106111:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106114:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
80106119:	68 b9 88 10 80       	push   $0x801088b9
8010611e:	68 80 e3 11 80       	push   $0x8011e380
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106123:	66 89 15 c2 e5 11 80 	mov    %dx,0x8011e5c2
8010612a:	c6 05 c4 e5 11 80 00 	movb   $0x0,0x8011e5c4
80106131:	66 a3 c0 e5 11 80    	mov    %ax,0x8011e5c0
80106137:	c1 e8 10             	shr    $0x10,%eax
8010613a:	c6 05 c5 e5 11 80 ef 	movb   $0xef,0x8011e5c5
80106141:	66 a3 c6 e5 11 80    	mov    %ax,0x8011e5c6

  initlock(&tickslock, "time");
80106147:	e8 54 ea ff ff       	call   80104ba0 <initlock>
}
8010614c:	83 c4 10             	add    $0x10,%esp
8010614f:	c9                   	leave  
80106150:	c3                   	ret    
80106151:	eb 0d                	jmp    80106160 <idtinit>
80106153:	90                   	nop
80106154:	90                   	nop
80106155:	90                   	nop
80106156:	90                   	nop
80106157:	90                   	nop
80106158:	90                   	nop
80106159:	90                   	nop
8010615a:	90                   	nop
8010615b:	90                   	nop
8010615c:	90                   	nop
8010615d:	90                   	nop
8010615e:	90                   	nop
8010615f:	90                   	nop

80106160 <idtinit>:

void
idtinit(void)
{
80106160:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106161:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106166:	89 e5                	mov    %esp,%ebp
80106168:	83 ec 10             	sub    $0x10,%esp
8010616b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010616f:	b8 c0 e3 11 80       	mov    $0x8011e3c0,%eax
80106174:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106178:	c1 e8 10             	shr    $0x10,%eax
8010617b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010617f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106182:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106185:	c9                   	leave  
80106186:	c3                   	ret    
80106187:	89 f6                	mov    %esi,%esi
80106189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106190 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106190:	55                   	push   %ebp
80106191:	89 e5                	mov    %esp,%ebp
80106193:	57                   	push   %edi
80106194:	56                   	push   %esi
80106195:	53                   	push   %ebx
80106196:	83 ec 1c             	sub    $0x1c,%esp
80106199:	8b 7d 08             	mov    0x8(%ebp),%edi
  pte_t* pte;
  uint va;
  int swapOutIndex;
  #endif

  if(tf->trapno == T_SYSCALL){
8010619c:	8b 47 30             	mov    0x30(%edi),%eax
8010619f:	83 f8 40             	cmp    $0x40,%eax
801061a2:	0f 84 a8 01 00 00    	je     80106350 <trap+0x1c0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801061a8:	83 e8 0e             	sub    $0xe,%eax
801061ab:	83 f8 31             	cmp    $0x31,%eax
801061ae:	77 38                	ja     801061e8 <trap+0x58>
801061b0:	ff 24 85 80 89 10 80 	jmp    *-0x7fef7680(,%eax,4)
801061b7:	89 f6                	mov    %esi,%esi
801061b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801061c0:	0f 20 d3             	mov    %cr2,%ebx

  #ifndef NONE
  /// check if pg fault or seg fault
  case T_PGFLT:
    va = PGROUNDDOWN(rcr2());
    pte = walkpgdir_noalloc(myproc()->pgdir, (void*) va);
801061c3:	e8 b8 da ff ff       	call   80103c80 <myproc>
801061c8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801061ce:	83 ec 08             	sub    $0x8,%esp
801061d1:	53                   	push   %ebx
801061d2:	ff 70 04             	pushl  0x4(%eax)
801061d5:	e8 46 13 00 00       	call   80107520 <walkpgdir_noalloc>
    //cprintf("%s num of memory %d",myproc()->name, myproc()->num_of_pages_in_memory);
    if(((uint)*pte) & PTE_PG){
801061da:	8b 00                	mov    (%eax),%eax
801061dc:	83 c4 10             	add    $0x10,%esp
801061df:	f6 c4 02             	test   $0x2,%ah
801061e2:	0f 85 e0 01 00 00    	jne    801063c8 <trap+0x238>

  #endif

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801061e8:	e8 93 da ff ff       	call   80103c80 <myproc>
801061ed:	85 c0                	test   %eax,%eax
801061ef:	0f 84 35 02 00 00    	je     8010642a <trap+0x29a>
801061f5:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
801061f9:	0f 84 2b 02 00 00    	je     8010642a <trap+0x29a>
801061ff:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106202:	8b 57 38             	mov    0x38(%edi),%edx
80106205:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80106208:	89 55 dc             	mov    %edx,-0x24(%ebp)
8010620b:	e8 50 da ff ff       	call   80103c60 <cpuid>
80106210:	8b 77 34             	mov    0x34(%edi),%esi
80106213:	8b 5f 30             	mov    0x30(%edi),%ebx
80106216:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106219:	e8 62 da ff ff       	call   80103c80 <myproc>
8010621e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106221:	e8 5a da ff ff       	call   80103c80 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106226:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106229:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010622c:	51                   	push   %ecx
8010622d:	52                   	push   %edx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010622e:	8b 55 e0             	mov    -0x20(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106231:	ff 75 e4             	pushl  -0x1c(%ebp)
80106234:	56                   	push   %esi
80106235:	53                   	push   %ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106236:	83 c2 6c             	add    $0x6c,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106239:	52                   	push   %edx
8010623a:	ff 70 10             	pushl  0x10(%eax)
8010623d:	68 3c 89 10 80       	push   $0x8010893c
80106242:	e8 19 a4 ff ff       	call   80100660 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80106247:	83 c4 20             	add    $0x20,%esp
8010624a:	e8 31 da ff ff       	call   80103c80 <myproc>
8010624f:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106256:	e8 25 da ff ff       	call   80103c80 <myproc>
8010625b:	85 c0                	test   %eax,%eax
8010625d:	74 0c                	je     8010626b <trap+0xdb>
8010625f:	e8 1c da ff ff       	call   80103c80 <myproc>
80106264:	8b 50 24             	mov    0x24(%eax),%edx
80106267:	85 d2                	test   %edx,%edx
80106269:	75 45                	jne    801062b0 <trap+0x120>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
8010626b:	e8 10 da ff ff       	call   80103c80 <myproc>
80106270:	85 c0                	test   %eax,%eax
80106272:	74 0b                	je     8010627f <trap+0xef>
80106274:	e8 07 da ff ff       	call   80103c80 <myproc>
80106279:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
8010627d:	74 49                	je     801062c8 <trap+0x138>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010627f:	e8 fc d9 ff ff       	call   80103c80 <myproc>
80106284:	85 c0                	test   %eax,%eax
80106286:	74 1d                	je     801062a5 <trap+0x115>
80106288:	e8 f3 d9 ff ff       	call   80103c80 <myproc>
8010628d:	8b 40 24             	mov    0x24(%eax),%eax
80106290:	85 c0                	test   %eax,%eax
80106292:	74 11                	je     801062a5 <trap+0x115>
80106294:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106298:	83 e0 03             	and    $0x3,%eax
8010629b:	66 83 f8 03          	cmp    $0x3,%ax
8010629f:	0f 84 d4 00 00 00    	je     80106379 <trap+0x1e9>
    exit();
}
801062a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062a8:	5b                   	pop    %ebx
801062a9:	5e                   	pop    %esi
801062aa:	5f                   	pop    %edi
801062ab:	5d                   	pop    %ebp
801062ac:	c3                   	ret    
801062ad:	8d 76 00             	lea    0x0(%esi),%esi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062b0:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801062b4:	83 e0 03             	and    $0x3,%eax
801062b7:	66 83 f8 03          	cmp    $0x3,%ax
801062bb:	75 ae                	jne    8010626b <trap+0xdb>
    exit();
801062bd:	e8 ce de ff ff       	call   80104190 <exit>
801062c2:	eb a7                	jmp    8010626b <trap+0xdb>
801062c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801062c8:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
801062cc:	75 b1                	jne    8010627f <trap+0xef>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
801062ce:	e8 4d e0 ff ff       	call   80104320 <yield>
801062d3:	eb aa                	jmp    8010627f <trap+0xef>
801062d5:	8d 76 00             	lea    0x0(%esi),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
801062d8:	e8 83 d9 ff ff       	call   80103c60 <cpuid>
801062dd:	85 c0                	test   %eax,%eax
801062df:	0f 84 ab 00 00 00    	je     80106390 <trap+0x200>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
801062e5:	e8 96 c8 ff ff       	call   80102b80 <lapiceoi>
    break;
801062ea:	e9 67 ff ff ff       	jmp    80106256 <trap+0xc6>
801062ef:	90                   	nop
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801062f0:	e8 4b c7 ff ff       	call   80102a40 <kbdintr>
    lapiceoi();
801062f5:	e8 86 c8 ff ff       	call   80102b80 <lapiceoi>
    break;
801062fa:	e9 57 ff ff ff       	jmp    80106256 <trap+0xc6>
801062ff:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106300:	e8 db 02 00 00       	call   801065e0 <uartintr>
    lapiceoi();
80106305:	e8 76 c8 ff ff       	call   80102b80 <lapiceoi>
    break;
8010630a:	e9 47 ff ff ff       	jmp    80106256 <trap+0xc6>
8010630f:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106310:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80106314:	8b 77 38             	mov    0x38(%edi),%esi
80106317:	e8 44 d9 ff ff       	call   80103c60 <cpuid>
8010631c:	56                   	push   %esi
8010631d:	53                   	push   %ebx
8010631e:	50                   	push   %eax
8010631f:	68 c4 88 10 80       	push   $0x801088c4
80106324:	e8 37 a3 ff ff       	call   80100660 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80106329:	e8 52 c8 ff ff       	call   80102b80 <lapiceoi>
    break;
8010632e:	83 c4 10             	add    $0x10,%esp
80106331:	e9 20 ff ff ff       	jmp    80106256 <trap+0xc6>
80106336:	8d 76 00             	lea    0x0(%esi),%esi
80106339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106340:	e8 3b c1 ff ff       	call   80102480 <ideintr>
80106345:	eb 9e                	jmp    801062e5 <trap+0x155>
80106347:	89 f6                	mov    %esi,%esi
80106349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  uint va;
  int swapOutIndex;
  #endif

  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
80106350:	e8 2b d9 ff ff       	call   80103c80 <myproc>
80106355:	8b 40 24             	mov    0x24(%eax),%eax
80106358:	85 c0                	test   %eax,%eax
8010635a:	75 2c                	jne    80106388 <trap+0x1f8>
      exit();
    myproc()->tf = tf;
8010635c:	e8 1f d9 ff ff       	call   80103c80 <myproc>
80106361:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80106364:	e8 17 ef ff ff       	call   80105280 <syscall>
    if(myproc()->killed)
80106369:	e8 12 d9 ff ff       	call   80103c80 <myproc>
8010636e:	8b 40 24             	mov    0x24(%eax),%eax
80106371:	85 c0                	test   %eax,%eax
80106373:	0f 84 2c ff ff ff    	je     801062a5 <trap+0x115>
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80106379:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010637c:	5b                   	pop    %ebx
8010637d:	5e                   	pop    %esi
8010637e:	5f                   	pop    %edi
8010637f:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
80106380:	e9 0b de ff ff       	jmp    80104190 <exit>
80106385:	8d 76 00             	lea    0x0(%esi),%esi
  int swapOutIndex;
  #endif

  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
80106388:	e8 03 de ff ff       	call   80104190 <exit>
8010638d:	eb cd                	jmp    8010635c <trap+0x1cc>
8010638f:	90                   	nop
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
80106390:	83 ec 0c             	sub    $0xc,%esp
80106393:	68 80 e3 11 80       	push   $0x8011e380
80106398:	e8 03 e9 ff ff       	call   80104ca0 <acquire>
      ticks++;
      wakeup(&ticks);
8010639d:	c7 04 24 c0 eb 11 80 	movl   $0x8011ebc0,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
801063a4:	83 05 c0 eb 11 80 01 	addl   $0x1,0x8011ebc0
      wakeup(&ticks);
801063ab:	e8 80 e1 ff ff       	call   80104530 <wakeup>
      release(&tickslock);
801063b0:	c7 04 24 80 e3 11 80 	movl   $0x8011e380,(%esp)
801063b7:	e8 24 ea ff ff       	call   80104de0 <release>
801063bc:	83 c4 10             	add    $0x10,%esp
801063bf:	e9 21 ff ff ff       	jmp    801062e5 <trap+0x155>
801063c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  case T_PGFLT:
    va = PGROUNDDOWN(rcr2());
    pte = walkpgdir_noalloc(myproc()->pgdir, (void*) va);
    //cprintf("%s num of memory %d",myproc()->name, myproc()->num_of_pages_in_memory);
    if(((uint)*pte) & PTE_PG){
      myproc()->num_of_page_faults++;
801063c8:	e8 b3 d8 ff ff       	call   80103c80 <myproc>
801063cd:	83 80 8c 00 00 00 01 	addl   $0x1,0x8c(%eax)

      if(myproc()->num_of_pages_in_memory > MAX_PSYC_PAGES){
801063d4:	e8 a7 d8 ff ff       	call   80103c80 <myproc>
801063d9:	83 b8 80 00 00 00 10 	cmpl   $0x10,0x80(%eax)
801063e0:	7f 73                	jg     80106455 <trap+0x2c5>
        panic("too many pages in memory, trap");
      }	

      /// the page was swapped out check if there is enough space in the memory for it
      if(myproc()->num_of_pages_in_memory == MAX_PSYC_PAGES){
801063e2:	e8 99 d8 ff ff       	call   80103c80 <myproc>
801063e7:	83 b8 80 00 00 00 10 	cmpl   $0x10,0x80(%eax)
801063ee:	74 17                	je     80106407 <trap+0x277>
        // uncomment below to fix the call to swap out from here
        // popcli();
        swapOut(swapOutIndex, myproc());
      }

      swapIn((void*) va, myproc());
801063f0:	e8 8b d8 ff ff       	call   80103c80 <myproc>
801063f5:	83 ec 08             	sub    $0x8,%esp
801063f8:	50                   	push   %eax
801063f9:	53                   	push   %ebx
801063fa:	e8 d1 18 00 00       	call   80107cd0 <swapIn>
      // lapiceoi();
      return;
801063ff:	83 c4 10             	add    $0x10,%esp
80106402:	e9 9e fe ff ff       	jmp    801062a5 <trap+0x115>
        panic("too many pages in memory, trap");
      }	

      /// the page was swapped out check if there is enough space in the memory for it
      if(myproc()->num_of_pages_in_memory == MAX_PSYC_PAGES){
        swapOutIndex = selectPageToSwapOut(myproc());
80106407:	e8 74 d8 ff ff       	call   80103c80 <myproc>
8010640c:	83 ec 0c             	sub    $0xc,%esp
8010640f:	50                   	push   %eax
80106410:	e8 bb 19 00 00       	call   80107dd0 <selectPageToSwapOut>
80106415:	89 c6                	mov    %eax,%esi
        
        // uncomment below to fix the call to swap out from here
        // popcli();
        swapOut(swapOutIndex, myproc());
80106417:	e8 64 d8 ff ff       	call   80103c80 <myproc>
8010641c:	59                   	pop    %ecx
8010641d:	5f                   	pop    %edi
8010641e:	50                   	push   %eax
8010641f:	56                   	push   %esi
80106420:	e8 2b 17 00 00       	call   80107b50 <swapOut>
80106425:	83 c4 10             	add    $0x10,%esp
80106428:	eb c6                	jmp    801063f0 <trap+0x260>
8010642a:	0f 20 d6             	mov    %cr2,%esi

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010642d:	8b 5f 38             	mov    0x38(%edi),%ebx
80106430:	e8 2b d8 ff ff       	call   80103c60 <cpuid>
80106435:	83 ec 0c             	sub    $0xc,%esp
80106438:	56                   	push   %esi
80106439:	53                   	push   %ebx
8010643a:	50                   	push   %eax
8010643b:	ff 77 30             	pushl  0x30(%edi)
8010643e:	68 08 89 10 80       	push   $0x80108908
80106443:	e8 18 a2 ff ff       	call   80100660 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80106448:	83 c4 14             	add    $0x14,%esp
8010644b:	68 be 88 10 80       	push   $0x801088be
80106450:	e8 1b 9f ff ff       	call   80100370 <panic>
    //cprintf("%s num of memory %d",myproc()->name, myproc()->num_of_pages_in_memory);
    if(((uint)*pte) & PTE_PG){
      myproc()->num_of_page_faults++;

      if(myproc()->num_of_pages_in_memory > MAX_PSYC_PAGES){
        panic("too many pages in memory, trap");
80106455:	83 ec 0c             	sub    $0xc,%esp
80106458:	68 e8 88 10 80       	push   $0x801088e8
8010645d:	e8 0e 9f ff ff       	call   80100370 <panic>
80106462:	66 90                	xchg   %ax,%ax
80106464:	66 90                	xchg   %ax,%ax
80106466:	66 90                	xchg   %ax,%ax
80106468:	66 90                	xchg   %ax,%ax
8010646a:	66 90                	xchg   %ax,%ax
8010646c:	66 90                	xchg   %ax,%ax
8010646e:	66 90                	xchg   %ax,%ax

80106470 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106470:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106475:	55                   	push   %ebp
80106476:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106478:	85 c0                	test   %eax,%eax
8010647a:	74 1c                	je     80106498 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010647c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106481:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106482:	a8 01                	test   $0x1,%al
80106484:	74 12                	je     80106498 <uartgetc+0x28>
80106486:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010648b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010648c:	0f b6 c0             	movzbl %al,%eax
}
8010648f:	5d                   	pop    %ebp
80106490:	c3                   	ret    
80106491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80106498:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
8010649d:	5d                   	pop    %ebp
8010649e:	c3                   	ret    
8010649f:	90                   	nop

801064a0 <uartputc.part.0>:
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}

void
uartputc(int c)
801064a0:	55                   	push   %ebp
801064a1:	89 e5                	mov    %esp,%ebp
801064a3:	57                   	push   %edi
801064a4:	56                   	push   %esi
801064a5:	53                   	push   %ebx
801064a6:	89 c7                	mov    %eax,%edi
801064a8:	bb 80 00 00 00       	mov    $0x80,%ebx
801064ad:	be fd 03 00 00       	mov    $0x3fd,%esi
801064b2:	83 ec 0c             	sub    $0xc,%esp
801064b5:	eb 1b                	jmp    801064d2 <uartputc.part.0+0x32>
801064b7:	89 f6                	mov    %esi,%esi
801064b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
801064c0:	83 ec 0c             	sub    $0xc,%esp
801064c3:	6a 0a                	push   $0xa
801064c5:	e8 d6 c6 ff ff       	call   80102ba0 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801064ca:	83 c4 10             	add    $0x10,%esp
801064cd:	83 eb 01             	sub    $0x1,%ebx
801064d0:	74 07                	je     801064d9 <uartputc.part.0+0x39>
801064d2:	89 f2                	mov    %esi,%edx
801064d4:	ec                   	in     (%dx),%al
801064d5:	a8 20                	test   $0x20,%al
801064d7:	74 e7                	je     801064c0 <uartputc.part.0+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801064d9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801064de:	89 f8                	mov    %edi,%eax
801064e0:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
801064e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064e4:	5b                   	pop    %ebx
801064e5:	5e                   	pop    %esi
801064e6:	5f                   	pop    %edi
801064e7:	5d                   	pop    %ebp
801064e8:	c3                   	ret    
801064e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801064f0 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801064f0:	55                   	push   %ebp
801064f1:	31 c9                	xor    %ecx,%ecx
801064f3:	89 c8                	mov    %ecx,%eax
801064f5:	89 e5                	mov    %esp,%ebp
801064f7:	57                   	push   %edi
801064f8:	56                   	push   %esi
801064f9:	53                   	push   %ebx
801064fa:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801064ff:	89 da                	mov    %ebx,%edx
80106501:	83 ec 0c             	sub    $0xc,%esp
80106504:	ee                   	out    %al,(%dx)
80106505:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010650a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010650f:	89 fa                	mov    %edi,%edx
80106511:	ee                   	out    %al,(%dx)
80106512:	b8 0c 00 00 00       	mov    $0xc,%eax
80106517:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010651c:	ee                   	out    %al,(%dx)
8010651d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106522:	89 c8                	mov    %ecx,%eax
80106524:	89 f2                	mov    %esi,%edx
80106526:	ee                   	out    %al,(%dx)
80106527:	b8 03 00 00 00       	mov    $0x3,%eax
8010652c:	89 fa                	mov    %edi,%edx
8010652e:	ee                   	out    %al,(%dx)
8010652f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106534:	89 c8                	mov    %ecx,%eax
80106536:	ee                   	out    %al,(%dx)
80106537:	b8 01 00 00 00       	mov    $0x1,%eax
8010653c:	89 f2                	mov    %esi,%edx
8010653e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010653f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106544:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106545:	3c ff                	cmp    $0xff,%al
80106547:	74 5a                	je     801065a3 <uartinit+0xb3>
    return;
  uart = 1;
80106549:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106550:	00 00 00 
80106553:	89 da                	mov    %ebx,%edx
80106555:	ec                   	in     (%dx),%al
80106556:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010655b:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
8010655c:	83 ec 08             	sub    $0x8,%esp
8010655f:	bb 48 8a 10 80       	mov    $0x80108a48,%ebx
80106564:	6a 00                	push   $0x0
80106566:	6a 04                	push   $0x4
80106568:	e8 63 c1 ff ff       	call   801026d0 <ioapicenable>
8010656d:	83 c4 10             	add    $0x10,%esp
80106570:	b8 78 00 00 00       	mov    $0x78,%eax
80106575:	eb 13                	jmp    8010658a <uartinit+0x9a>
80106577:	89 f6                	mov    %esi,%esi
80106579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106580:	83 c3 01             	add    $0x1,%ebx
80106583:	0f be 03             	movsbl (%ebx),%eax
80106586:	84 c0                	test   %al,%al
80106588:	74 19                	je     801065a3 <uartinit+0xb3>
void
uartputc(int c)
{
  int i;

  if(!uart)
8010658a:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80106590:	85 d2                	test   %edx,%edx
80106592:	74 ec                	je     80106580 <uartinit+0x90>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106594:	83 c3 01             	add    $0x1,%ebx
80106597:	e8 04 ff ff ff       	call   801064a0 <uartputc.part.0>
8010659c:	0f be 03             	movsbl (%ebx),%eax
8010659f:	84 c0                	test   %al,%al
801065a1:	75 e7                	jne    8010658a <uartinit+0x9a>
    uartputc(*p);
}
801065a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065a6:	5b                   	pop    %ebx
801065a7:	5e                   	pop    %esi
801065a8:	5f                   	pop    %edi
801065a9:	5d                   	pop    %ebp
801065aa:	c3                   	ret    
801065ab:	90                   	nop
801065ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801065b0 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
801065b0:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
801065b6:	55                   	push   %ebp
801065b7:	89 e5                	mov    %esp,%ebp
  int i;

  if(!uart)
801065b9:	85 d2                	test   %edx,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
801065bb:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;

  if(!uart)
801065be:	74 10                	je     801065d0 <uartputc+0x20>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
801065c0:	5d                   	pop    %ebp
801065c1:	e9 da fe ff ff       	jmp    801064a0 <uartputc.part.0>
801065c6:	8d 76 00             	lea    0x0(%esi),%esi
801065c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801065d0:	5d                   	pop    %ebp
801065d1:	c3                   	ret    
801065d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801065e0 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
801065e0:	55                   	push   %ebp
801065e1:	89 e5                	mov    %esp,%ebp
801065e3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801065e6:	68 70 64 10 80       	push   $0x80106470
801065eb:	e8 00 a2 ff ff       	call   801007f0 <consoleintr>
}
801065f0:	83 c4 10             	add    $0x10,%esp
801065f3:	c9                   	leave  
801065f4:	c3                   	ret    

801065f5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801065f5:	6a 00                	push   $0x0
  pushl $0
801065f7:	6a 00                	push   $0x0
  jmp alltraps
801065f9:	e9 9c fa ff ff       	jmp    8010609a <alltraps>

801065fe <vector1>:
.globl vector1
vector1:
  pushl $0
801065fe:	6a 00                	push   $0x0
  pushl $1
80106600:	6a 01                	push   $0x1
  jmp alltraps
80106602:	e9 93 fa ff ff       	jmp    8010609a <alltraps>

80106607 <vector2>:
.globl vector2
vector2:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $2
80106609:	6a 02                	push   $0x2
  jmp alltraps
8010660b:	e9 8a fa ff ff       	jmp    8010609a <alltraps>

80106610 <vector3>:
.globl vector3
vector3:
  pushl $0
80106610:	6a 00                	push   $0x0
  pushl $3
80106612:	6a 03                	push   $0x3
  jmp alltraps
80106614:	e9 81 fa ff ff       	jmp    8010609a <alltraps>

80106619 <vector4>:
.globl vector4
vector4:
  pushl $0
80106619:	6a 00                	push   $0x0
  pushl $4
8010661b:	6a 04                	push   $0x4
  jmp alltraps
8010661d:	e9 78 fa ff ff       	jmp    8010609a <alltraps>

80106622 <vector5>:
.globl vector5
vector5:
  pushl $0
80106622:	6a 00                	push   $0x0
  pushl $5
80106624:	6a 05                	push   $0x5
  jmp alltraps
80106626:	e9 6f fa ff ff       	jmp    8010609a <alltraps>

8010662b <vector6>:
.globl vector6
vector6:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $6
8010662d:	6a 06                	push   $0x6
  jmp alltraps
8010662f:	e9 66 fa ff ff       	jmp    8010609a <alltraps>

80106634 <vector7>:
.globl vector7
vector7:
  pushl $0
80106634:	6a 00                	push   $0x0
  pushl $7
80106636:	6a 07                	push   $0x7
  jmp alltraps
80106638:	e9 5d fa ff ff       	jmp    8010609a <alltraps>

8010663d <vector8>:
.globl vector8
vector8:
  pushl $8
8010663d:	6a 08                	push   $0x8
  jmp alltraps
8010663f:	e9 56 fa ff ff       	jmp    8010609a <alltraps>

80106644 <vector9>:
.globl vector9
vector9:
  pushl $0
80106644:	6a 00                	push   $0x0
  pushl $9
80106646:	6a 09                	push   $0x9
  jmp alltraps
80106648:	e9 4d fa ff ff       	jmp    8010609a <alltraps>

8010664d <vector10>:
.globl vector10
vector10:
  pushl $10
8010664d:	6a 0a                	push   $0xa
  jmp alltraps
8010664f:	e9 46 fa ff ff       	jmp    8010609a <alltraps>

80106654 <vector11>:
.globl vector11
vector11:
  pushl $11
80106654:	6a 0b                	push   $0xb
  jmp alltraps
80106656:	e9 3f fa ff ff       	jmp    8010609a <alltraps>

8010665b <vector12>:
.globl vector12
vector12:
  pushl $12
8010665b:	6a 0c                	push   $0xc
  jmp alltraps
8010665d:	e9 38 fa ff ff       	jmp    8010609a <alltraps>

80106662 <vector13>:
.globl vector13
vector13:
  pushl $13
80106662:	6a 0d                	push   $0xd
  jmp alltraps
80106664:	e9 31 fa ff ff       	jmp    8010609a <alltraps>

80106669 <vector14>:
.globl vector14
vector14:
  pushl $14
80106669:	6a 0e                	push   $0xe
  jmp alltraps
8010666b:	e9 2a fa ff ff       	jmp    8010609a <alltraps>

80106670 <vector15>:
.globl vector15
vector15:
  pushl $0
80106670:	6a 00                	push   $0x0
  pushl $15
80106672:	6a 0f                	push   $0xf
  jmp alltraps
80106674:	e9 21 fa ff ff       	jmp    8010609a <alltraps>

80106679 <vector16>:
.globl vector16
vector16:
  pushl $0
80106679:	6a 00                	push   $0x0
  pushl $16
8010667b:	6a 10                	push   $0x10
  jmp alltraps
8010667d:	e9 18 fa ff ff       	jmp    8010609a <alltraps>

80106682 <vector17>:
.globl vector17
vector17:
  pushl $17
80106682:	6a 11                	push   $0x11
  jmp alltraps
80106684:	e9 11 fa ff ff       	jmp    8010609a <alltraps>

80106689 <vector18>:
.globl vector18
vector18:
  pushl $0
80106689:	6a 00                	push   $0x0
  pushl $18
8010668b:	6a 12                	push   $0x12
  jmp alltraps
8010668d:	e9 08 fa ff ff       	jmp    8010609a <alltraps>

80106692 <vector19>:
.globl vector19
vector19:
  pushl $0
80106692:	6a 00                	push   $0x0
  pushl $19
80106694:	6a 13                	push   $0x13
  jmp alltraps
80106696:	e9 ff f9 ff ff       	jmp    8010609a <alltraps>

8010669b <vector20>:
.globl vector20
vector20:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $20
8010669d:	6a 14                	push   $0x14
  jmp alltraps
8010669f:	e9 f6 f9 ff ff       	jmp    8010609a <alltraps>

801066a4 <vector21>:
.globl vector21
vector21:
  pushl $0
801066a4:	6a 00                	push   $0x0
  pushl $21
801066a6:	6a 15                	push   $0x15
  jmp alltraps
801066a8:	e9 ed f9 ff ff       	jmp    8010609a <alltraps>

801066ad <vector22>:
.globl vector22
vector22:
  pushl $0
801066ad:	6a 00                	push   $0x0
  pushl $22
801066af:	6a 16                	push   $0x16
  jmp alltraps
801066b1:	e9 e4 f9 ff ff       	jmp    8010609a <alltraps>

801066b6 <vector23>:
.globl vector23
vector23:
  pushl $0
801066b6:	6a 00                	push   $0x0
  pushl $23
801066b8:	6a 17                	push   $0x17
  jmp alltraps
801066ba:	e9 db f9 ff ff       	jmp    8010609a <alltraps>

801066bf <vector24>:
.globl vector24
vector24:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $24
801066c1:	6a 18                	push   $0x18
  jmp alltraps
801066c3:	e9 d2 f9 ff ff       	jmp    8010609a <alltraps>

801066c8 <vector25>:
.globl vector25
vector25:
  pushl $0
801066c8:	6a 00                	push   $0x0
  pushl $25
801066ca:	6a 19                	push   $0x19
  jmp alltraps
801066cc:	e9 c9 f9 ff ff       	jmp    8010609a <alltraps>

801066d1 <vector26>:
.globl vector26
vector26:
  pushl $0
801066d1:	6a 00                	push   $0x0
  pushl $26
801066d3:	6a 1a                	push   $0x1a
  jmp alltraps
801066d5:	e9 c0 f9 ff ff       	jmp    8010609a <alltraps>

801066da <vector27>:
.globl vector27
vector27:
  pushl $0
801066da:	6a 00                	push   $0x0
  pushl $27
801066dc:	6a 1b                	push   $0x1b
  jmp alltraps
801066de:	e9 b7 f9 ff ff       	jmp    8010609a <alltraps>

801066e3 <vector28>:
.globl vector28
vector28:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $28
801066e5:	6a 1c                	push   $0x1c
  jmp alltraps
801066e7:	e9 ae f9 ff ff       	jmp    8010609a <alltraps>

801066ec <vector29>:
.globl vector29
vector29:
  pushl $0
801066ec:	6a 00                	push   $0x0
  pushl $29
801066ee:	6a 1d                	push   $0x1d
  jmp alltraps
801066f0:	e9 a5 f9 ff ff       	jmp    8010609a <alltraps>

801066f5 <vector30>:
.globl vector30
vector30:
  pushl $0
801066f5:	6a 00                	push   $0x0
  pushl $30
801066f7:	6a 1e                	push   $0x1e
  jmp alltraps
801066f9:	e9 9c f9 ff ff       	jmp    8010609a <alltraps>

801066fe <vector31>:
.globl vector31
vector31:
  pushl $0
801066fe:	6a 00                	push   $0x0
  pushl $31
80106700:	6a 1f                	push   $0x1f
  jmp alltraps
80106702:	e9 93 f9 ff ff       	jmp    8010609a <alltraps>

80106707 <vector32>:
.globl vector32
vector32:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $32
80106709:	6a 20                	push   $0x20
  jmp alltraps
8010670b:	e9 8a f9 ff ff       	jmp    8010609a <alltraps>

80106710 <vector33>:
.globl vector33
vector33:
  pushl $0
80106710:	6a 00                	push   $0x0
  pushl $33
80106712:	6a 21                	push   $0x21
  jmp alltraps
80106714:	e9 81 f9 ff ff       	jmp    8010609a <alltraps>

80106719 <vector34>:
.globl vector34
vector34:
  pushl $0
80106719:	6a 00                	push   $0x0
  pushl $34
8010671b:	6a 22                	push   $0x22
  jmp alltraps
8010671d:	e9 78 f9 ff ff       	jmp    8010609a <alltraps>

80106722 <vector35>:
.globl vector35
vector35:
  pushl $0
80106722:	6a 00                	push   $0x0
  pushl $35
80106724:	6a 23                	push   $0x23
  jmp alltraps
80106726:	e9 6f f9 ff ff       	jmp    8010609a <alltraps>

8010672b <vector36>:
.globl vector36
vector36:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $36
8010672d:	6a 24                	push   $0x24
  jmp alltraps
8010672f:	e9 66 f9 ff ff       	jmp    8010609a <alltraps>

80106734 <vector37>:
.globl vector37
vector37:
  pushl $0
80106734:	6a 00                	push   $0x0
  pushl $37
80106736:	6a 25                	push   $0x25
  jmp alltraps
80106738:	e9 5d f9 ff ff       	jmp    8010609a <alltraps>

8010673d <vector38>:
.globl vector38
vector38:
  pushl $0
8010673d:	6a 00                	push   $0x0
  pushl $38
8010673f:	6a 26                	push   $0x26
  jmp alltraps
80106741:	e9 54 f9 ff ff       	jmp    8010609a <alltraps>

80106746 <vector39>:
.globl vector39
vector39:
  pushl $0
80106746:	6a 00                	push   $0x0
  pushl $39
80106748:	6a 27                	push   $0x27
  jmp alltraps
8010674a:	e9 4b f9 ff ff       	jmp    8010609a <alltraps>

8010674f <vector40>:
.globl vector40
vector40:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $40
80106751:	6a 28                	push   $0x28
  jmp alltraps
80106753:	e9 42 f9 ff ff       	jmp    8010609a <alltraps>

80106758 <vector41>:
.globl vector41
vector41:
  pushl $0
80106758:	6a 00                	push   $0x0
  pushl $41
8010675a:	6a 29                	push   $0x29
  jmp alltraps
8010675c:	e9 39 f9 ff ff       	jmp    8010609a <alltraps>

80106761 <vector42>:
.globl vector42
vector42:
  pushl $0
80106761:	6a 00                	push   $0x0
  pushl $42
80106763:	6a 2a                	push   $0x2a
  jmp alltraps
80106765:	e9 30 f9 ff ff       	jmp    8010609a <alltraps>

8010676a <vector43>:
.globl vector43
vector43:
  pushl $0
8010676a:	6a 00                	push   $0x0
  pushl $43
8010676c:	6a 2b                	push   $0x2b
  jmp alltraps
8010676e:	e9 27 f9 ff ff       	jmp    8010609a <alltraps>

80106773 <vector44>:
.globl vector44
vector44:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $44
80106775:	6a 2c                	push   $0x2c
  jmp alltraps
80106777:	e9 1e f9 ff ff       	jmp    8010609a <alltraps>

8010677c <vector45>:
.globl vector45
vector45:
  pushl $0
8010677c:	6a 00                	push   $0x0
  pushl $45
8010677e:	6a 2d                	push   $0x2d
  jmp alltraps
80106780:	e9 15 f9 ff ff       	jmp    8010609a <alltraps>

80106785 <vector46>:
.globl vector46
vector46:
  pushl $0
80106785:	6a 00                	push   $0x0
  pushl $46
80106787:	6a 2e                	push   $0x2e
  jmp alltraps
80106789:	e9 0c f9 ff ff       	jmp    8010609a <alltraps>

8010678e <vector47>:
.globl vector47
vector47:
  pushl $0
8010678e:	6a 00                	push   $0x0
  pushl $47
80106790:	6a 2f                	push   $0x2f
  jmp alltraps
80106792:	e9 03 f9 ff ff       	jmp    8010609a <alltraps>

80106797 <vector48>:
.globl vector48
vector48:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $48
80106799:	6a 30                	push   $0x30
  jmp alltraps
8010679b:	e9 fa f8 ff ff       	jmp    8010609a <alltraps>

801067a0 <vector49>:
.globl vector49
vector49:
  pushl $0
801067a0:	6a 00                	push   $0x0
  pushl $49
801067a2:	6a 31                	push   $0x31
  jmp alltraps
801067a4:	e9 f1 f8 ff ff       	jmp    8010609a <alltraps>

801067a9 <vector50>:
.globl vector50
vector50:
  pushl $0
801067a9:	6a 00                	push   $0x0
  pushl $50
801067ab:	6a 32                	push   $0x32
  jmp alltraps
801067ad:	e9 e8 f8 ff ff       	jmp    8010609a <alltraps>

801067b2 <vector51>:
.globl vector51
vector51:
  pushl $0
801067b2:	6a 00                	push   $0x0
  pushl $51
801067b4:	6a 33                	push   $0x33
  jmp alltraps
801067b6:	e9 df f8 ff ff       	jmp    8010609a <alltraps>

801067bb <vector52>:
.globl vector52
vector52:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $52
801067bd:	6a 34                	push   $0x34
  jmp alltraps
801067bf:	e9 d6 f8 ff ff       	jmp    8010609a <alltraps>

801067c4 <vector53>:
.globl vector53
vector53:
  pushl $0
801067c4:	6a 00                	push   $0x0
  pushl $53
801067c6:	6a 35                	push   $0x35
  jmp alltraps
801067c8:	e9 cd f8 ff ff       	jmp    8010609a <alltraps>

801067cd <vector54>:
.globl vector54
vector54:
  pushl $0
801067cd:	6a 00                	push   $0x0
  pushl $54
801067cf:	6a 36                	push   $0x36
  jmp alltraps
801067d1:	e9 c4 f8 ff ff       	jmp    8010609a <alltraps>

801067d6 <vector55>:
.globl vector55
vector55:
  pushl $0
801067d6:	6a 00                	push   $0x0
  pushl $55
801067d8:	6a 37                	push   $0x37
  jmp alltraps
801067da:	e9 bb f8 ff ff       	jmp    8010609a <alltraps>

801067df <vector56>:
.globl vector56
vector56:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $56
801067e1:	6a 38                	push   $0x38
  jmp alltraps
801067e3:	e9 b2 f8 ff ff       	jmp    8010609a <alltraps>

801067e8 <vector57>:
.globl vector57
vector57:
  pushl $0
801067e8:	6a 00                	push   $0x0
  pushl $57
801067ea:	6a 39                	push   $0x39
  jmp alltraps
801067ec:	e9 a9 f8 ff ff       	jmp    8010609a <alltraps>

801067f1 <vector58>:
.globl vector58
vector58:
  pushl $0
801067f1:	6a 00                	push   $0x0
  pushl $58
801067f3:	6a 3a                	push   $0x3a
  jmp alltraps
801067f5:	e9 a0 f8 ff ff       	jmp    8010609a <alltraps>

801067fa <vector59>:
.globl vector59
vector59:
  pushl $0
801067fa:	6a 00                	push   $0x0
  pushl $59
801067fc:	6a 3b                	push   $0x3b
  jmp alltraps
801067fe:	e9 97 f8 ff ff       	jmp    8010609a <alltraps>

80106803 <vector60>:
.globl vector60
vector60:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $60
80106805:	6a 3c                	push   $0x3c
  jmp alltraps
80106807:	e9 8e f8 ff ff       	jmp    8010609a <alltraps>

8010680c <vector61>:
.globl vector61
vector61:
  pushl $0
8010680c:	6a 00                	push   $0x0
  pushl $61
8010680e:	6a 3d                	push   $0x3d
  jmp alltraps
80106810:	e9 85 f8 ff ff       	jmp    8010609a <alltraps>

80106815 <vector62>:
.globl vector62
vector62:
  pushl $0
80106815:	6a 00                	push   $0x0
  pushl $62
80106817:	6a 3e                	push   $0x3e
  jmp alltraps
80106819:	e9 7c f8 ff ff       	jmp    8010609a <alltraps>

8010681e <vector63>:
.globl vector63
vector63:
  pushl $0
8010681e:	6a 00                	push   $0x0
  pushl $63
80106820:	6a 3f                	push   $0x3f
  jmp alltraps
80106822:	e9 73 f8 ff ff       	jmp    8010609a <alltraps>

80106827 <vector64>:
.globl vector64
vector64:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $64
80106829:	6a 40                	push   $0x40
  jmp alltraps
8010682b:	e9 6a f8 ff ff       	jmp    8010609a <alltraps>

80106830 <vector65>:
.globl vector65
vector65:
  pushl $0
80106830:	6a 00                	push   $0x0
  pushl $65
80106832:	6a 41                	push   $0x41
  jmp alltraps
80106834:	e9 61 f8 ff ff       	jmp    8010609a <alltraps>

80106839 <vector66>:
.globl vector66
vector66:
  pushl $0
80106839:	6a 00                	push   $0x0
  pushl $66
8010683b:	6a 42                	push   $0x42
  jmp alltraps
8010683d:	e9 58 f8 ff ff       	jmp    8010609a <alltraps>

80106842 <vector67>:
.globl vector67
vector67:
  pushl $0
80106842:	6a 00                	push   $0x0
  pushl $67
80106844:	6a 43                	push   $0x43
  jmp alltraps
80106846:	e9 4f f8 ff ff       	jmp    8010609a <alltraps>

8010684b <vector68>:
.globl vector68
vector68:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $68
8010684d:	6a 44                	push   $0x44
  jmp alltraps
8010684f:	e9 46 f8 ff ff       	jmp    8010609a <alltraps>

80106854 <vector69>:
.globl vector69
vector69:
  pushl $0
80106854:	6a 00                	push   $0x0
  pushl $69
80106856:	6a 45                	push   $0x45
  jmp alltraps
80106858:	e9 3d f8 ff ff       	jmp    8010609a <alltraps>

8010685d <vector70>:
.globl vector70
vector70:
  pushl $0
8010685d:	6a 00                	push   $0x0
  pushl $70
8010685f:	6a 46                	push   $0x46
  jmp alltraps
80106861:	e9 34 f8 ff ff       	jmp    8010609a <alltraps>

80106866 <vector71>:
.globl vector71
vector71:
  pushl $0
80106866:	6a 00                	push   $0x0
  pushl $71
80106868:	6a 47                	push   $0x47
  jmp alltraps
8010686a:	e9 2b f8 ff ff       	jmp    8010609a <alltraps>

8010686f <vector72>:
.globl vector72
vector72:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $72
80106871:	6a 48                	push   $0x48
  jmp alltraps
80106873:	e9 22 f8 ff ff       	jmp    8010609a <alltraps>

80106878 <vector73>:
.globl vector73
vector73:
  pushl $0
80106878:	6a 00                	push   $0x0
  pushl $73
8010687a:	6a 49                	push   $0x49
  jmp alltraps
8010687c:	e9 19 f8 ff ff       	jmp    8010609a <alltraps>

80106881 <vector74>:
.globl vector74
vector74:
  pushl $0
80106881:	6a 00                	push   $0x0
  pushl $74
80106883:	6a 4a                	push   $0x4a
  jmp alltraps
80106885:	e9 10 f8 ff ff       	jmp    8010609a <alltraps>

8010688a <vector75>:
.globl vector75
vector75:
  pushl $0
8010688a:	6a 00                	push   $0x0
  pushl $75
8010688c:	6a 4b                	push   $0x4b
  jmp alltraps
8010688e:	e9 07 f8 ff ff       	jmp    8010609a <alltraps>

80106893 <vector76>:
.globl vector76
vector76:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $76
80106895:	6a 4c                	push   $0x4c
  jmp alltraps
80106897:	e9 fe f7 ff ff       	jmp    8010609a <alltraps>

8010689c <vector77>:
.globl vector77
vector77:
  pushl $0
8010689c:	6a 00                	push   $0x0
  pushl $77
8010689e:	6a 4d                	push   $0x4d
  jmp alltraps
801068a0:	e9 f5 f7 ff ff       	jmp    8010609a <alltraps>

801068a5 <vector78>:
.globl vector78
vector78:
  pushl $0
801068a5:	6a 00                	push   $0x0
  pushl $78
801068a7:	6a 4e                	push   $0x4e
  jmp alltraps
801068a9:	e9 ec f7 ff ff       	jmp    8010609a <alltraps>

801068ae <vector79>:
.globl vector79
vector79:
  pushl $0
801068ae:	6a 00                	push   $0x0
  pushl $79
801068b0:	6a 4f                	push   $0x4f
  jmp alltraps
801068b2:	e9 e3 f7 ff ff       	jmp    8010609a <alltraps>

801068b7 <vector80>:
.globl vector80
vector80:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $80
801068b9:	6a 50                	push   $0x50
  jmp alltraps
801068bb:	e9 da f7 ff ff       	jmp    8010609a <alltraps>

801068c0 <vector81>:
.globl vector81
vector81:
  pushl $0
801068c0:	6a 00                	push   $0x0
  pushl $81
801068c2:	6a 51                	push   $0x51
  jmp alltraps
801068c4:	e9 d1 f7 ff ff       	jmp    8010609a <alltraps>

801068c9 <vector82>:
.globl vector82
vector82:
  pushl $0
801068c9:	6a 00                	push   $0x0
  pushl $82
801068cb:	6a 52                	push   $0x52
  jmp alltraps
801068cd:	e9 c8 f7 ff ff       	jmp    8010609a <alltraps>

801068d2 <vector83>:
.globl vector83
vector83:
  pushl $0
801068d2:	6a 00                	push   $0x0
  pushl $83
801068d4:	6a 53                	push   $0x53
  jmp alltraps
801068d6:	e9 bf f7 ff ff       	jmp    8010609a <alltraps>

801068db <vector84>:
.globl vector84
vector84:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $84
801068dd:	6a 54                	push   $0x54
  jmp alltraps
801068df:	e9 b6 f7 ff ff       	jmp    8010609a <alltraps>

801068e4 <vector85>:
.globl vector85
vector85:
  pushl $0
801068e4:	6a 00                	push   $0x0
  pushl $85
801068e6:	6a 55                	push   $0x55
  jmp alltraps
801068e8:	e9 ad f7 ff ff       	jmp    8010609a <alltraps>

801068ed <vector86>:
.globl vector86
vector86:
  pushl $0
801068ed:	6a 00                	push   $0x0
  pushl $86
801068ef:	6a 56                	push   $0x56
  jmp alltraps
801068f1:	e9 a4 f7 ff ff       	jmp    8010609a <alltraps>

801068f6 <vector87>:
.globl vector87
vector87:
  pushl $0
801068f6:	6a 00                	push   $0x0
  pushl $87
801068f8:	6a 57                	push   $0x57
  jmp alltraps
801068fa:	e9 9b f7 ff ff       	jmp    8010609a <alltraps>

801068ff <vector88>:
.globl vector88
vector88:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $88
80106901:	6a 58                	push   $0x58
  jmp alltraps
80106903:	e9 92 f7 ff ff       	jmp    8010609a <alltraps>

80106908 <vector89>:
.globl vector89
vector89:
  pushl $0
80106908:	6a 00                	push   $0x0
  pushl $89
8010690a:	6a 59                	push   $0x59
  jmp alltraps
8010690c:	e9 89 f7 ff ff       	jmp    8010609a <alltraps>

80106911 <vector90>:
.globl vector90
vector90:
  pushl $0
80106911:	6a 00                	push   $0x0
  pushl $90
80106913:	6a 5a                	push   $0x5a
  jmp alltraps
80106915:	e9 80 f7 ff ff       	jmp    8010609a <alltraps>

8010691a <vector91>:
.globl vector91
vector91:
  pushl $0
8010691a:	6a 00                	push   $0x0
  pushl $91
8010691c:	6a 5b                	push   $0x5b
  jmp alltraps
8010691e:	e9 77 f7 ff ff       	jmp    8010609a <alltraps>

80106923 <vector92>:
.globl vector92
vector92:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $92
80106925:	6a 5c                	push   $0x5c
  jmp alltraps
80106927:	e9 6e f7 ff ff       	jmp    8010609a <alltraps>

8010692c <vector93>:
.globl vector93
vector93:
  pushl $0
8010692c:	6a 00                	push   $0x0
  pushl $93
8010692e:	6a 5d                	push   $0x5d
  jmp alltraps
80106930:	e9 65 f7 ff ff       	jmp    8010609a <alltraps>

80106935 <vector94>:
.globl vector94
vector94:
  pushl $0
80106935:	6a 00                	push   $0x0
  pushl $94
80106937:	6a 5e                	push   $0x5e
  jmp alltraps
80106939:	e9 5c f7 ff ff       	jmp    8010609a <alltraps>

8010693e <vector95>:
.globl vector95
vector95:
  pushl $0
8010693e:	6a 00                	push   $0x0
  pushl $95
80106940:	6a 5f                	push   $0x5f
  jmp alltraps
80106942:	e9 53 f7 ff ff       	jmp    8010609a <alltraps>

80106947 <vector96>:
.globl vector96
vector96:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $96
80106949:	6a 60                	push   $0x60
  jmp alltraps
8010694b:	e9 4a f7 ff ff       	jmp    8010609a <alltraps>

80106950 <vector97>:
.globl vector97
vector97:
  pushl $0
80106950:	6a 00                	push   $0x0
  pushl $97
80106952:	6a 61                	push   $0x61
  jmp alltraps
80106954:	e9 41 f7 ff ff       	jmp    8010609a <alltraps>

80106959 <vector98>:
.globl vector98
vector98:
  pushl $0
80106959:	6a 00                	push   $0x0
  pushl $98
8010695b:	6a 62                	push   $0x62
  jmp alltraps
8010695d:	e9 38 f7 ff ff       	jmp    8010609a <alltraps>

80106962 <vector99>:
.globl vector99
vector99:
  pushl $0
80106962:	6a 00                	push   $0x0
  pushl $99
80106964:	6a 63                	push   $0x63
  jmp alltraps
80106966:	e9 2f f7 ff ff       	jmp    8010609a <alltraps>

8010696b <vector100>:
.globl vector100
vector100:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $100
8010696d:	6a 64                	push   $0x64
  jmp alltraps
8010696f:	e9 26 f7 ff ff       	jmp    8010609a <alltraps>

80106974 <vector101>:
.globl vector101
vector101:
  pushl $0
80106974:	6a 00                	push   $0x0
  pushl $101
80106976:	6a 65                	push   $0x65
  jmp alltraps
80106978:	e9 1d f7 ff ff       	jmp    8010609a <alltraps>

8010697d <vector102>:
.globl vector102
vector102:
  pushl $0
8010697d:	6a 00                	push   $0x0
  pushl $102
8010697f:	6a 66                	push   $0x66
  jmp alltraps
80106981:	e9 14 f7 ff ff       	jmp    8010609a <alltraps>

80106986 <vector103>:
.globl vector103
vector103:
  pushl $0
80106986:	6a 00                	push   $0x0
  pushl $103
80106988:	6a 67                	push   $0x67
  jmp alltraps
8010698a:	e9 0b f7 ff ff       	jmp    8010609a <alltraps>

8010698f <vector104>:
.globl vector104
vector104:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $104
80106991:	6a 68                	push   $0x68
  jmp alltraps
80106993:	e9 02 f7 ff ff       	jmp    8010609a <alltraps>

80106998 <vector105>:
.globl vector105
vector105:
  pushl $0
80106998:	6a 00                	push   $0x0
  pushl $105
8010699a:	6a 69                	push   $0x69
  jmp alltraps
8010699c:	e9 f9 f6 ff ff       	jmp    8010609a <alltraps>

801069a1 <vector106>:
.globl vector106
vector106:
  pushl $0
801069a1:	6a 00                	push   $0x0
  pushl $106
801069a3:	6a 6a                	push   $0x6a
  jmp alltraps
801069a5:	e9 f0 f6 ff ff       	jmp    8010609a <alltraps>

801069aa <vector107>:
.globl vector107
vector107:
  pushl $0
801069aa:	6a 00                	push   $0x0
  pushl $107
801069ac:	6a 6b                	push   $0x6b
  jmp alltraps
801069ae:	e9 e7 f6 ff ff       	jmp    8010609a <alltraps>

801069b3 <vector108>:
.globl vector108
vector108:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $108
801069b5:	6a 6c                	push   $0x6c
  jmp alltraps
801069b7:	e9 de f6 ff ff       	jmp    8010609a <alltraps>

801069bc <vector109>:
.globl vector109
vector109:
  pushl $0
801069bc:	6a 00                	push   $0x0
  pushl $109
801069be:	6a 6d                	push   $0x6d
  jmp alltraps
801069c0:	e9 d5 f6 ff ff       	jmp    8010609a <alltraps>

801069c5 <vector110>:
.globl vector110
vector110:
  pushl $0
801069c5:	6a 00                	push   $0x0
  pushl $110
801069c7:	6a 6e                	push   $0x6e
  jmp alltraps
801069c9:	e9 cc f6 ff ff       	jmp    8010609a <alltraps>

801069ce <vector111>:
.globl vector111
vector111:
  pushl $0
801069ce:	6a 00                	push   $0x0
  pushl $111
801069d0:	6a 6f                	push   $0x6f
  jmp alltraps
801069d2:	e9 c3 f6 ff ff       	jmp    8010609a <alltraps>

801069d7 <vector112>:
.globl vector112
vector112:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $112
801069d9:	6a 70                	push   $0x70
  jmp alltraps
801069db:	e9 ba f6 ff ff       	jmp    8010609a <alltraps>

801069e0 <vector113>:
.globl vector113
vector113:
  pushl $0
801069e0:	6a 00                	push   $0x0
  pushl $113
801069e2:	6a 71                	push   $0x71
  jmp alltraps
801069e4:	e9 b1 f6 ff ff       	jmp    8010609a <alltraps>

801069e9 <vector114>:
.globl vector114
vector114:
  pushl $0
801069e9:	6a 00                	push   $0x0
  pushl $114
801069eb:	6a 72                	push   $0x72
  jmp alltraps
801069ed:	e9 a8 f6 ff ff       	jmp    8010609a <alltraps>

801069f2 <vector115>:
.globl vector115
vector115:
  pushl $0
801069f2:	6a 00                	push   $0x0
  pushl $115
801069f4:	6a 73                	push   $0x73
  jmp alltraps
801069f6:	e9 9f f6 ff ff       	jmp    8010609a <alltraps>

801069fb <vector116>:
.globl vector116
vector116:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $116
801069fd:	6a 74                	push   $0x74
  jmp alltraps
801069ff:	e9 96 f6 ff ff       	jmp    8010609a <alltraps>

80106a04 <vector117>:
.globl vector117
vector117:
  pushl $0
80106a04:	6a 00                	push   $0x0
  pushl $117
80106a06:	6a 75                	push   $0x75
  jmp alltraps
80106a08:	e9 8d f6 ff ff       	jmp    8010609a <alltraps>

80106a0d <vector118>:
.globl vector118
vector118:
  pushl $0
80106a0d:	6a 00                	push   $0x0
  pushl $118
80106a0f:	6a 76                	push   $0x76
  jmp alltraps
80106a11:	e9 84 f6 ff ff       	jmp    8010609a <alltraps>

80106a16 <vector119>:
.globl vector119
vector119:
  pushl $0
80106a16:	6a 00                	push   $0x0
  pushl $119
80106a18:	6a 77                	push   $0x77
  jmp alltraps
80106a1a:	e9 7b f6 ff ff       	jmp    8010609a <alltraps>

80106a1f <vector120>:
.globl vector120
vector120:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $120
80106a21:	6a 78                	push   $0x78
  jmp alltraps
80106a23:	e9 72 f6 ff ff       	jmp    8010609a <alltraps>

80106a28 <vector121>:
.globl vector121
vector121:
  pushl $0
80106a28:	6a 00                	push   $0x0
  pushl $121
80106a2a:	6a 79                	push   $0x79
  jmp alltraps
80106a2c:	e9 69 f6 ff ff       	jmp    8010609a <alltraps>

80106a31 <vector122>:
.globl vector122
vector122:
  pushl $0
80106a31:	6a 00                	push   $0x0
  pushl $122
80106a33:	6a 7a                	push   $0x7a
  jmp alltraps
80106a35:	e9 60 f6 ff ff       	jmp    8010609a <alltraps>

80106a3a <vector123>:
.globl vector123
vector123:
  pushl $0
80106a3a:	6a 00                	push   $0x0
  pushl $123
80106a3c:	6a 7b                	push   $0x7b
  jmp alltraps
80106a3e:	e9 57 f6 ff ff       	jmp    8010609a <alltraps>

80106a43 <vector124>:
.globl vector124
vector124:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $124
80106a45:	6a 7c                	push   $0x7c
  jmp alltraps
80106a47:	e9 4e f6 ff ff       	jmp    8010609a <alltraps>

80106a4c <vector125>:
.globl vector125
vector125:
  pushl $0
80106a4c:	6a 00                	push   $0x0
  pushl $125
80106a4e:	6a 7d                	push   $0x7d
  jmp alltraps
80106a50:	e9 45 f6 ff ff       	jmp    8010609a <alltraps>

80106a55 <vector126>:
.globl vector126
vector126:
  pushl $0
80106a55:	6a 00                	push   $0x0
  pushl $126
80106a57:	6a 7e                	push   $0x7e
  jmp alltraps
80106a59:	e9 3c f6 ff ff       	jmp    8010609a <alltraps>

80106a5e <vector127>:
.globl vector127
vector127:
  pushl $0
80106a5e:	6a 00                	push   $0x0
  pushl $127
80106a60:	6a 7f                	push   $0x7f
  jmp alltraps
80106a62:	e9 33 f6 ff ff       	jmp    8010609a <alltraps>

80106a67 <vector128>:
.globl vector128
vector128:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $128
80106a69:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106a6e:	e9 27 f6 ff ff       	jmp    8010609a <alltraps>

80106a73 <vector129>:
.globl vector129
vector129:
  pushl $0
80106a73:	6a 00                	push   $0x0
  pushl $129
80106a75:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106a7a:	e9 1b f6 ff ff       	jmp    8010609a <alltraps>

80106a7f <vector130>:
.globl vector130
vector130:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $130
80106a81:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106a86:	e9 0f f6 ff ff       	jmp    8010609a <alltraps>

80106a8b <vector131>:
.globl vector131
vector131:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $131
80106a8d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106a92:	e9 03 f6 ff ff       	jmp    8010609a <alltraps>

80106a97 <vector132>:
.globl vector132
vector132:
  pushl $0
80106a97:	6a 00                	push   $0x0
  pushl $132
80106a99:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106a9e:	e9 f7 f5 ff ff       	jmp    8010609a <alltraps>

80106aa3 <vector133>:
.globl vector133
vector133:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $133
80106aa5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106aaa:	e9 eb f5 ff ff       	jmp    8010609a <alltraps>

80106aaf <vector134>:
.globl vector134
vector134:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $134
80106ab1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106ab6:	e9 df f5 ff ff       	jmp    8010609a <alltraps>

80106abb <vector135>:
.globl vector135
vector135:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $135
80106abd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106ac2:	e9 d3 f5 ff ff       	jmp    8010609a <alltraps>

80106ac7 <vector136>:
.globl vector136
vector136:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $136
80106ac9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106ace:	e9 c7 f5 ff ff       	jmp    8010609a <alltraps>

80106ad3 <vector137>:
.globl vector137
vector137:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $137
80106ad5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106ada:	e9 bb f5 ff ff       	jmp    8010609a <alltraps>

80106adf <vector138>:
.globl vector138
vector138:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $138
80106ae1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106ae6:	e9 af f5 ff ff       	jmp    8010609a <alltraps>

80106aeb <vector139>:
.globl vector139
vector139:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $139
80106aed:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106af2:	e9 a3 f5 ff ff       	jmp    8010609a <alltraps>

80106af7 <vector140>:
.globl vector140
vector140:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $140
80106af9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106afe:	e9 97 f5 ff ff       	jmp    8010609a <alltraps>

80106b03 <vector141>:
.globl vector141
vector141:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $141
80106b05:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106b0a:	e9 8b f5 ff ff       	jmp    8010609a <alltraps>

80106b0f <vector142>:
.globl vector142
vector142:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $142
80106b11:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106b16:	e9 7f f5 ff ff       	jmp    8010609a <alltraps>

80106b1b <vector143>:
.globl vector143
vector143:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $143
80106b1d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106b22:	e9 73 f5 ff ff       	jmp    8010609a <alltraps>

80106b27 <vector144>:
.globl vector144
vector144:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $144
80106b29:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106b2e:	e9 67 f5 ff ff       	jmp    8010609a <alltraps>

80106b33 <vector145>:
.globl vector145
vector145:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $145
80106b35:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106b3a:	e9 5b f5 ff ff       	jmp    8010609a <alltraps>

80106b3f <vector146>:
.globl vector146
vector146:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $146
80106b41:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106b46:	e9 4f f5 ff ff       	jmp    8010609a <alltraps>

80106b4b <vector147>:
.globl vector147
vector147:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $147
80106b4d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106b52:	e9 43 f5 ff ff       	jmp    8010609a <alltraps>

80106b57 <vector148>:
.globl vector148
vector148:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $148
80106b59:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106b5e:	e9 37 f5 ff ff       	jmp    8010609a <alltraps>

80106b63 <vector149>:
.globl vector149
vector149:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $149
80106b65:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106b6a:	e9 2b f5 ff ff       	jmp    8010609a <alltraps>

80106b6f <vector150>:
.globl vector150
vector150:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $150
80106b71:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106b76:	e9 1f f5 ff ff       	jmp    8010609a <alltraps>

80106b7b <vector151>:
.globl vector151
vector151:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $151
80106b7d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106b82:	e9 13 f5 ff ff       	jmp    8010609a <alltraps>

80106b87 <vector152>:
.globl vector152
vector152:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $152
80106b89:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106b8e:	e9 07 f5 ff ff       	jmp    8010609a <alltraps>

80106b93 <vector153>:
.globl vector153
vector153:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $153
80106b95:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106b9a:	e9 fb f4 ff ff       	jmp    8010609a <alltraps>

80106b9f <vector154>:
.globl vector154
vector154:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $154
80106ba1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106ba6:	e9 ef f4 ff ff       	jmp    8010609a <alltraps>

80106bab <vector155>:
.globl vector155
vector155:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $155
80106bad:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106bb2:	e9 e3 f4 ff ff       	jmp    8010609a <alltraps>

80106bb7 <vector156>:
.globl vector156
vector156:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $156
80106bb9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106bbe:	e9 d7 f4 ff ff       	jmp    8010609a <alltraps>

80106bc3 <vector157>:
.globl vector157
vector157:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $157
80106bc5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106bca:	e9 cb f4 ff ff       	jmp    8010609a <alltraps>

80106bcf <vector158>:
.globl vector158
vector158:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $158
80106bd1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106bd6:	e9 bf f4 ff ff       	jmp    8010609a <alltraps>

80106bdb <vector159>:
.globl vector159
vector159:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $159
80106bdd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106be2:	e9 b3 f4 ff ff       	jmp    8010609a <alltraps>

80106be7 <vector160>:
.globl vector160
vector160:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $160
80106be9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106bee:	e9 a7 f4 ff ff       	jmp    8010609a <alltraps>

80106bf3 <vector161>:
.globl vector161
vector161:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $161
80106bf5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106bfa:	e9 9b f4 ff ff       	jmp    8010609a <alltraps>

80106bff <vector162>:
.globl vector162
vector162:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $162
80106c01:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106c06:	e9 8f f4 ff ff       	jmp    8010609a <alltraps>

80106c0b <vector163>:
.globl vector163
vector163:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $163
80106c0d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106c12:	e9 83 f4 ff ff       	jmp    8010609a <alltraps>

80106c17 <vector164>:
.globl vector164
vector164:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $164
80106c19:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106c1e:	e9 77 f4 ff ff       	jmp    8010609a <alltraps>

80106c23 <vector165>:
.globl vector165
vector165:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $165
80106c25:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106c2a:	e9 6b f4 ff ff       	jmp    8010609a <alltraps>

80106c2f <vector166>:
.globl vector166
vector166:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $166
80106c31:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106c36:	e9 5f f4 ff ff       	jmp    8010609a <alltraps>

80106c3b <vector167>:
.globl vector167
vector167:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $167
80106c3d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106c42:	e9 53 f4 ff ff       	jmp    8010609a <alltraps>

80106c47 <vector168>:
.globl vector168
vector168:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $168
80106c49:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106c4e:	e9 47 f4 ff ff       	jmp    8010609a <alltraps>

80106c53 <vector169>:
.globl vector169
vector169:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $169
80106c55:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106c5a:	e9 3b f4 ff ff       	jmp    8010609a <alltraps>

80106c5f <vector170>:
.globl vector170
vector170:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $170
80106c61:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106c66:	e9 2f f4 ff ff       	jmp    8010609a <alltraps>

80106c6b <vector171>:
.globl vector171
vector171:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $171
80106c6d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106c72:	e9 23 f4 ff ff       	jmp    8010609a <alltraps>

80106c77 <vector172>:
.globl vector172
vector172:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $172
80106c79:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106c7e:	e9 17 f4 ff ff       	jmp    8010609a <alltraps>

80106c83 <vector173>:
.globl vector173
vector173:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $173
80106c85:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106c8a:	e9 0b f4 ff ff       	jmp    8010609a <alltraps>

80106c8f <vector174>:
.globl vector174
vector174:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $174
80106c91:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106c96:	e9 ff f3 ff ff       	jmp    8010609a <alltraps>

80106c9b <vector175>:
.globl vector175
vector175:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $175
80106c9d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106ca2:	e9 f3 f3 ff ff       	jmp    8010609a <alltraps>

80106ca7 <vector176>:
.globl vector176
vector176:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $176
80106ca9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106cae:	e9 e7 f3 ff ff       	jmp    8010609a <alltraps>

80106cb3 <vector177>:
.globl vector177
vector177:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $177
80106cb5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106cba:	e9 db f3 ff ff       	jmp    8010609a <alltraps>

80106cbf <vector178>:
.globl vector178
vector178:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $178
80106cc1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106cc6:	e9 cf f3 ff ff       	jmp    8010609a <alltraps>

80106ccb <vector179>:
.globl vector179
vector179:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $179
80106ccd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106cd2:	e9 c3 f3 ff ff       	jmp    8010609a <alltraps>

80106cd7 <vector180>:
.globl vector180
vector180:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $180
80106cd9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106cde:	e9 b7 f3 ff ff       	jmp    8010609a <alltraps>

80106ce3 <vector181>:
.globl vector181
vector181:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $181
80106ce5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106cea:	e9 ab f3 ff ff       	jmp    8010609a <alltraps>

80106cef <vector182>:
.globl vector182
vector182:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $182
80106cf1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106cf6:	e9 9f f3 ff ff       	jmp    8010609a <alltraps>

80106cfb <vector183>:
.globl vector183
vector183:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $183
80106cfd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106d02:	e9 93 f3 ff ff       	jmp    8010609a <alltraps>

80106d07 <vector184>:
.globl vector184
vector184:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $184
80106d09:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106d0e:	e9 87 f3 ff ff       	jmp    8010609a <alltraps>

80106d13 <vector185>:
.globl vector185
vector185:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $185
80106d15:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106d1a:	e9 7b f3 ff ff       	jmp    8010609a <alltraps>

80106d1f <vector186>:
.globl vector186
vector186:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $186
80106d21:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106d26:	e9 6f f3 ff ff       	jmp    8010609a <alltraps>

80106d2b <vector187>:
.globl vector187
vector187:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $187
80106d2d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106d32:	e9 63 f3 ff ff       	jmp    8010609a <alltraps>

80106d37 <vector188>:
.globl vector188
vector188:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $188
80106d39:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106d3e:	e9 57 f3 ff ff       	jmp    8010609a <alltraps>

80106d43 <vector189>:
.globl vector189
vector189:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $189
80106d45:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106d4a:	e9 4b f3 ff ff       	jmp    8010609a <alltraps>

80106d4f <vector190>:
.globl vector190
vector190:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $190
80106d51:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106d56:	e9 3f f3 ff ff       	jmp    8010609a <alltraps>

80106d5b <vector191>:
.globl vector191
vector191:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $191
80106d5d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106d62:	e9 33 f3 ff ff       	jmp    8010609a <alltraps>

80106d67 <vector192>:
.globl vector192
vector192:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $192
80106d69:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106d6e:	e9 27 f3 ff ff       	jmp    8010609a <alltraps>

80106d73 <vector193>:
.globl vector193
vector193:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $193
80106d75:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106d7a:	e9 1b f3 ff ff       	jmp    8010609a <alltraps>

80106d7f <vector194>:
.globl vector194
vector194:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $194
80106d81:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106d86:	e9 0f f3 ff ff       	jmp    8010609a <alltraps>

80106d8b <vector195>:
.globl vector195
vector195:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $195
80106d8d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106d92:	e9 03 f3 ff ff       	jmp    8010609a <alltraps>

80106d97 <vector196>:
.globl vector196
vector196:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $196
80106d99:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106d9e:	e9 f7 f2 ff ff       	jmp    8010609a <alltraps>

80106da3 <vector197>:
.globl vector197
vector197:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $197
80106da5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106daa:	e9 eb f2 ff ff       	jmp    8010609a <alltraps>

80106daf <vector198>:
.globl vector198
vector198:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $198
80106db1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106db6:	e9 df f2 ff ff       	jmp    8010609a <alltraps>

80106dbb <vector199>:
.globl vector199
vector199:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $199
80106dbd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106dc2:	e9 d3 f2 ff ff       	jmp    8010609a <alltraps>

80106dc7 <vector200>:
.globl vector200
vector200:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $200
80106dc9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106dce:	e9 c7 f2 ff ff       	jmp    8010609a <alltraps>

80106dd3 <vector201>:
.globl vector201
vector201:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $201
80106dd5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106dda:	e9 bb f2 ff ff       	jmp    8010609a <alltraps>

80106ddf <vector202>:
.globl vector202
vector202:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $202
80106de1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106de6:	e9 af f2 ff ff       	jmp    8010609a <alltraps>

80106deb <vector203>:
.globl vector203
vector203:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $203
80106ded:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106df2:	e9 a3 f2 ff ff       	jmp    8010609a <alltraps>

80106df7 <vector204>:
.globl vector204
vector204:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $204
80106df9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106dfe:	e9 97 f2 ff ff       	jmp    8010609a <alltraps>

80106e03 <vector205>:
.globl vector205
vector205:
  pushl $0
80106e03:	6a 00                	push   $0x0
  pushl $205
80106e05:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106e0a:	e9 8b f2 ff ff       	jmp    8010609a <alltraps>

80106e0f <vector206>:
.globl vector206
vector206:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $206
80106e11:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106e16:	e9 7f f2 ff ff       	jmp    8010609a <alltraps>

80106e1b <vector207>:
.globl vector207
vector207:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $207
80106e1d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106e22:	e9 73 f2 ff ff       	jmp    8010609a <alltraps>

80106e27 <vector208>:
.globl vector208
vector208:
  pushl $0
80106e27:	6a 00                	push   $0x0
  pushl $208
80106e29:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106e2e:	e9 67 f2 ff ff       	jmp    8010609a <alltraps>

80106e33 <vector209>:
.globl vector209
vector209:
  pushl $0
80106e33:	6a 00                	push   $0x0
  pushl $209
80106e35:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106e3a:	e9 5b f2 ff ff       	jmp    8010609a <alltraps>

80106e3f <vector210>:
.globl vector210
vector210:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $210
80106e41:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106e46:	e9 4f f2 ff ff       	jmp    8010609a <alltraps>

80106e4b <vector211>:
.globl vector211
vector211:
  pushl $0
80106e4b:	6a 00                	push   $0x0
  pushl $211
80106e4d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106e52:	e9 43 f2 ff ff       	jmp    8010609a <alltraps>

80106e57 <vector212>:
.globl vector212
vector212:
  pushl $0
80106e57:	6a 00                	push   $0x0
  pushl $212
80106e59:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106e5e:	e9 37 f2 ff ff       	jmp    8010609a <alltraps>

80106e63 <vector213>:
.globl vector213
vector213:
  pushl $0
80106e63:	6a 00                	push   $0x0
  pushl $213
80106e65:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106e6a:	e9 2b f2 ff ff       	jmp    8010609a <alltraps>

80106e6f <vector214>:
.globl vector214
vector214:
  pushl $0
80106e6f:	6a 00                	push   $0x0
  pushl $214
80106e71:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106e76:	e9 1f f2 ff ff       	jmp    8010609a <alltraps>

80106e7b <vector215>:
.globl vector215
vector215:
  pushl $0
80106e7b:	6a 00                	push   $0x0
  pushl $215
80106e7d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106e82:	e9 13 f2 ff ff       	jmp    8010609a <alltraps>

80106e87 <vector216>:
.globl vector216
vector216:
  pushl $0
80106e87:	6a 00                	push   $0x0
  pushl $216
80106e89:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106e8e:	e9 07 f2 ff ff       	jmp    8010609a <alltraps>

80106e93 <vector217>:
.globl vector217
vector217:
  pushl $0
80106e93:	6a 00                	push   $0x0
  pushl $217
80106e95:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106e9a:	e9 fb f1 ff ff       	jmp    8010609a <alltraps>

80106e9f <vector218>:
.globl vector218
vector218:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $218
80106ea1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106ea6:	e9 ef f1 ff ff       	jmp    8010609a <alltraps>

80106eab <vector219>:
.globl vector219
vector219:
  pushl $0
80106eab:	6a 00                	push   $0x0
  pushl $219
80106ead:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106eb2:	e9 e3 f1 ff ff       	jmp    8010609a <alltraps>

80106eb7 <vector220>:
.globl vector220
vector220:
  pushl $0
80106eb7:	6a 00                	push   $0x0
  pushl $220
80106eb9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106ebe:	e9 d7 f1 ff ff       	jmp    8010609a <alltraps>

80106ec3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $221
80106ec5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106eca:	e9 cb f1 ff ff       	jmp    8010609a <alltraps>

80106ecf <vector222>:
.globl vector222
vector222:
  pushl $0
80106ecf:	6a 00                	push   $0x0
  pushl $222
80106ed1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106ed6:	e9 bf f1 ff ff       	jmp    8010609a <alltraps>

80106edb <vector223>:
.globl vector223
vector223:
  pushl $0
80106edb:	6a 00                	push   $0x0
  pushl $223
80106edd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106ee2:	e9 b3 f1 ff ff       	jmp    8010609a <alltraps>

80106ee7 <vector224>:
.globl vector224
vector224:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $224
80106ee9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106eee:	e9 a7 f1 ff ff       	jmp    8010609a <alltraps>

80106ef3 <vector225>:
.globl vector225
vector225:
  pushl $0
80106ef3:	6a 00                	push   $0x0
  pushl $225
80106ef5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106efa:	e9 9b f1 ff ff       	jmp    8010609a <alltraps>

80106eff <vector226>:
.globl vector226
vector226:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $226
80106f01:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106f06:	e9 8f f1 ff ff       	jmp    8010609a <alltraps>

80106f0b <vector227>:
.globl vector227
vector227:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $227
80106f0d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106f12:	e9 83 f1 ff ff       	jmp    8010609a <alltraps>

80106f17 <vector228>:
.globl vector228
vector228:
  pushl $0
80106f17:	6a 00                	push   $0x0
  pushl $228
80106f19:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106f1e:	e9 77 f1 ff ff       	jmp    8010609a <alltraps>

80106f23 <vector229>:
.globl vector229
vector229:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $229
80106f25:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106f2a:	e9 6b f1 ff ff       	jmp    8010609a <alltraps>

80106f2f <vector230>:
.globl vector230
vector230:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $230
80106f31:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106f36:	e9 5f f1 ff ff       	jmp    8010609a <alltraps>

80106f3b <vector231>:
.globl vector231
vector231:
  pushl $0
80106f3b:	6a 00                	push   $0x0
  pushl $231
80106f3d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106f42:	e9 53 f1 ff ff       	jmp    8010609a <alltraps>

80106f47 <vector232>:
.globl vector232
vector232:
  pushl $0
80106f47:	6a 00                	push   $0x0
  pushl $232
80106f49:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106f4e:	e9 47 f1 ff ff       	jmp    8010609a <alltraps>

80106f53 <vector233>:
.globl vector233
vector233:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $233
80106f55:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106f5a:	e9 3b f1 ff ff       	jmp    8010609a <alltraps>

80106f5f <vector234>:
.globl vector234
vector234:
  pushl $0
80106f5f:	6a 00                	push   $0x0
  pushl $234
80106f61:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106f66:	e9 2f f1 ff ff       	jmp    8010609a <alltraps>

80106f6b <vector235>:
.globl vector235
vector235:
  pushl $0
80106f6b:	6a 00                	push   $0x0
  pushl $235
80106f6d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106f72:	e9 23 f1 ff ff       	jmp    8010609a <alltraps>

80106f77 <vector236>:
.globl vector236
vector236:
  pushl $0
80106f77:	6a 00                	push   $0x0
  pushl $236
80106f79:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106f7e:	e9 17 f1 ff ff       	jmp    8010609a <alltraps>

80106f83 <vector237>:
.globl vector237
vector237:
  pushl $0
80106f83:	6a 00                	push   $0x0
  pushl $237
80106f85:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106f8a:	e9 0b f1 ff ff       	jmp    8010609a <alltraps>

80106f8f <vector238>:
.globl vector238
vector238:
  pushl $0
80106f8f:	6a 00                	push   $0x0
  pushl $238
80106f91:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106f96:	e9 ff f0 ff ff       	jmp    8010609a <alltraps>

80106f9b <vector239>:
.globl vector239
vector239:
  pushl $0
80106f9b:	6a 00                	push   $0x0
  pushl $239
80106f9d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106fa2:	e9 f3 f0 ff ff       	jmp    8010609a <alltraps>

80106fa7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106fa7:	6a 00                	push   $0x0
  pushl $240
80106fa9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106fae:	e9 e7 f0 ff ff       	jmp    8010609a <alltraps>

80106fb3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106fb3:	6a 00                	push   $0x0
  pushl $241
80106fb5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106fba:	e9 db f0 ff ff       	jmp    8010609a <alltraps>

80106fbf <vector242>:
.globl vector242
vector242:
  pushl $0
80106fbf:	6a 00                	push   $0x0
  pushl $242
80106fc1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106fc6:	e9 cf f0 ff ff       	jmp    8010609a <alltraps>

80106fcb <vector243>:
.globl vector243
vector243:
  pushl $0
80106fcb:	6a 00                	push   $0x0
  pushl $243
80106fcd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106fd2:	e9 c3 f0 ff ff       	jmp    8010609a <alltraps>

80106fd7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106fd7:	6a 00                	push   $0x0
  pushl $244
80106fd9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106fde:	e9 b7 f0 ff ff       	jmp    8010609a <alltraps>

80106fe3 <vector245>:
.globl vector245
vector245:
  pushl $0
80106fe3:	6a 00                	push   $0x0
  pushl $245
80106fe5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106fea:	e9 ab f0 ff ff       	jmp    8010609a <alltraps>

80106fef <vector246>:
.globl vector246
vector246:
  pushl $0
80106fef:	6a 00                	push   $0x0
  pushl $246
80106ff1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106ff6:	e9 9f f0 ff ff       	jmp    8010609a <alltraps>

80106ffb <vector247>:
.globl vector247
vector247:
  pushl $0
80106ffb:	6a 00                	push   $0x0
  pushl $247
80106ffd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107002:	e9 93 f0 ff ff       	jmp    8010609a <alltraps>

80107007 <vector248>:
.globl vector248
vector248:
  pushl $0
80107007:	6a 00                	push   $0x0
  pushl $248
80107009:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010700e:	e9 87 f0 ff ff       	jmp    8010609a <alltraps>

80107013 <vector249>:
.globl vector249
vector249:
  pushl $0
80107013:	6a 00                	push   $0x0
  pushl $249
80107015:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010701a:	e9 7b f0 ff ff       	jmp    8010609a <alltraps>

8010701f <vector250>:
.globl vector250
vector250:
  pushl $0
8010701f:	6a 00                	push   $0x0
  pushl $250
80107021:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107026:	e9 6f f0 ff ff       	jmp    8010609a <alltraps>

8010702b <vector251>:
.globl vector251
vector251:
  pushl $0
8010702b:	6a 00                	push   $0x0
  pushl $251
8010702d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107032:	e9 63 f0 ff ff       	jmp    8010609a <alltraps>

80107037 <vector252>:
.globl vector252
vector252:
  pushl $0
80107037:	6a 00                	push   $0x0
  pushl $252
80107039:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010703e:	e9 57 f0 ff ff       	jmp    8010609a <alltraps>

80107043 <vector253>:
.globl vector253
vector253:
  pushl $0
80107043:	6a 00                	push   $0x0
  pushl $253
80107045:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010704a:	e9 4b f0 ff ff       	jmp    8010609a <alltraps>

8010704f <vector254>:
.globl vector254
vector254:
  pushl $0
8010704f:	6a 00                	push   $0x0
  pushl $254
80107051:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107056:	e9 3f f0 ff ff       	jmp    8010609a <alltraps>

8010705b <vector255>:
.globl vector255
vector255:
  pushl $0
8010705b:	6a 00                	push   $0x0
  pushl $255
8010705d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107062:	e9 33 f0 ff ff       	jmp    8010609a <alltraps>
80107067:	66 90                	xchg   %ax,%ax
80107069:	66 90                	xchg   %ax,%ax
8010706b:	66 90                	xchg   %ax,%ax
8010706d:	66 90                	xchg   %ax,%ax
8010706f:	90                   	nop

80107070 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107070:	55                   	push   %ebp
80107071:	89 e5                	mov    %esp,%ebp
80107073:	57                   	push   %edi
80107074:	56                   	push   %esi
80107075:	53                   	push   %ebx
80107076:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107078:	c1 ea 16             	shr    $0x16,%edx
8010707b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010707e:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80107081:	8b 07                	mov    (%edi),%eax
80107083:	a8 01                	test   $0x1,%al
80107085:	74 29                	je     801070b0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107087:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010708c:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80107092:	8d 65 f4             	lea    -0xc(%ebp),%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107095:	c1 eb 0a             	shr    $0xa,%ebx
80107098:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
8010709e:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
801070a1:	5b                   	pop    %ebx
801070a2:	5e                   	pop    %esi
801070a3:	5f                   	pop    %edi
801070a4:	5d                   	pop    %ebp
801070a5:	c3                   	ret    
801070a6:	8d 76 00             	lea    0x0(%esi),%esi
801070a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801070b0:	85 c9                	test   %ecx,%ecx
801070b2:	74 2c                	je     801070e0 <walkpgdir+0x70>
801070b4:	e8 47 b8 ff ff       	call   80102900 <kalloc>
801070b9:	85 c0                	test   %eax,%eax
801070bb:	89 c6                	mov    %eax,%esi
801070bd:	74 21                	je     801070e0 <walkpgdir+0x70>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801070bf:	83 ec 04             	sub    $0x4,%esp
801070c2:	68 00 10 00 00       	push   $0x1000
801070c7:	6a 00                	push   $0x0
801070c9:	50                   	push   %eax
801070ca:	e8 61 dd ff ff       	call   80104e30 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801070cf:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801070d5:	83 c4 10             	add    $0x10,%esp
801070d8:	83 c8 07             	or     $0x7,%eax
801070db:	89 07                	mov    %eax,(%edi)
801070dd:	eb b3                	jmp    80107092 <walkpgdir+0x22>
801070df:	90                   	nop
  }
  return &pgtab[PTX(va)];
}
801070e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
801070e3:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
801070e5:	5b                   	pop    %ebx
801070e6:	5e                   	pop    %esi
801070e7:	5f                   	pop    %edi
801070e8:	5d                   	pop    %ebp
801070e9:	c3                   	ret    
801070ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801070f0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801070f0:	55                   	push   %ebp
801070f1:	89 e5                	mov    %esp,%ebp
801070f3:	57                   	push   %edi
801070f4:	56                   	push   %esi
801070f5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801070f6:	89 d3                	mov    %edx,%ebx
801070f8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801070fe:	83 ec 1c             	sub    $0x1c,%esp
80107101:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107104:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107108:	8b 7d 08             	mov    0x8(%ebp),%edi
8010710b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107110:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80107113:	8b 45 0c             	mov    0xc(%ebp),%eax
80107116:	29 df                	sub    %ebx,%edi
80107118:	83 c8 01             	or     $0x1,%eax
8010711b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010711e:	eb 15                	jmp    80107135 <mappages+0x45>
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80107120:	f6 00 01             	testb  $0x1,(%eax)
80107123:	75 45                	jne    8010716a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80107125:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80107128:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
8010712b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010712d:	74 31                	je     80107160 <mappages+0x70>
      break;
    a += PGSIZE;
8010712f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107135:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107138:	b9 01 00 00 00       	mov    $0x1,%ecx
8010713d:	89 da                	mov    %ebx,%edx
8010713f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80107142:	e8 29 ff ff ff       	call   80107070 <walkpgdir>
80107147:	85 c0                	test   %eax,%eax
80107149:	75 d5                	jne    80107120 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
8010714b:	8d 65 f4             	lea    -0xc(%ebp),%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
8010714e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80107153:	5b                   	pop    %ebx
80107154:	5e                   	pop    %esi
80107155:	5f                   	pop    %edi
80107156:	5d                   	pop    %ebp
80107157:	c3                   	ret    
80107158:	90                   	nop
80107159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107160:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80107163:	31 c0                	xor    %eax,%eax
}
80107165:	5b                   	pop    %ebx
80107166:	5e                   	pop    %esi
80107167:	5f                   	pop    %edi
80107168:	5d                   	pop    %ebp
80107169:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
8010716a:	83 ec 0c             	sub    $0xc,%esp
8010716d:	68 50 8a 10 80       	push   $0x80108a50
80107172:	e8 f9 91 ff ff       	call   80100370 <panic>
80107177:	89 f6                	mov    %esi,%esi
80107179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107180 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107180:	55                   	push   %ebp
80107181:	89 e5                	mov    %esp,%ebp
80107183:	57                   	push   %edi
80107184:	56                   	push   %esi
80107185:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107186:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
8010718c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107192:	83 ec 1c             	sub    $0x1c,%esp
80107195:	89 45 e4             	mov    %eax,-0x1c(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80107198:	39 d3                	cmp    %edx,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010719a:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010719d:	89 4d dc             	mov    %ecx,-0x24(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801071a0:	72 4c                	jb     801071ee <deallocuvm.part.0+0x6e>
801071a2:	eb 73                	jmp    80107217 <deallocuvm.part.0+0x97>
801071a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801071a8:	8b 30                	mov    (%eax),%esi
801071aa:	f7 c6 01 00 00 00    	test   $0x1,%esi
801071b0:	74 31                	je     801071e3 <deallocuvm.part.0+0x63>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801071b2:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
801071b8:	0f 84 c1 00 00 00    	je     8010727f <deallocuvm.part.0+0xff>
        panic("kfree");

      #ifndef NONE
        //if((strcmp(myproc()->name, "init") && strcmp(myproc()->name, "sh"))){
        if(myproc()->pgdir == pgdir){
801071be:	e8 bd ca ff ff       	call   80103c80 <myproc>
801071c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801071c6:	3b 50 04             	cmp    0x4(%eax),%edx
801071c9:	74 5d                	je     80107228 <deallocuvm.part.0+0xa8>
        }
        //}
      #endif

      char *v = P2V(pa);
      kfree(v);
801071cb:	83 ec 0c             	sub    $0xc,%esp
801071ce:	81 c6 00 00 00 80    	add    $0x80000000,%esi
801071d4:	56                   	push   %esi
801071d5:	e8 36 b5 ff ff       	call   80102710 <kfree>
      *pte = 0;
801071da:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
801071e0:	83 c4 10             	add    $0x10,%esp

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801071e3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801071e9:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
801071ec:	73 29                	jae    80107217 <deallocuvm.part.0+0x97>
    pte = walkpgdir(pgdir, (char*)a, 0);
801071ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801071f1:	31 c9                	xor    %ecx,%ecx
801071f3:	89 da                	mov    %ebx,%edx
801071f5:	e8 76 fe ff ff       	call   80107070 <walkpgdir>
    if(!pte)
801071fa:	85 c0                	test   %eax,%eax
  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
    pte = walkpgdir(pgdir, (char*)a, 0);
801071fc:	89 c7                	mov    %eax,%edi
    if(!pte)
801071fe:	75 a8                	jne    801071a8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107200:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80107206:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010720c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107212:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
80107215:	72 d7                	jb     801071ee <deallocuvm.part.0+0x6e>
      *pte = 0;
    }
  }

  return newsz;
}
80107217:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010721a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010721d:	5b                   	pop    %ebx
8010721e:	5e                   	pop    %esi
8010721f:	5f                   	pop    %edi
80107220:	5d                   	pop    %ebp
80107221:	c3                   	ret    
80107222:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        panic("kfree");

      #ifndef NONE
        //if((strcmp(myproc()->name, "init") && strcmp(myproc()->name, "sh"))){
        if(myproc()->pgdir == pgdir){
          updateMemPagesOnRemove((void*) a, myproc());
80107228:	e8 53 ca ff ff       	call   80103c80 <myproc>
8010722d:	89 c2                	mov    %eax,%edx
8010722f:	8d 88 1c 01 00 00    	lea    0x11c(%eax),%ecx
/// update the memory pages data of process according to the specified algorithm
/// on page removal
void updateMemPagesOnRemove(void* va, struct proc *p){
  #if defined(LAPA) || defined(NFUA) || defined(SCFIFO)
    int i;
    for(i = 0; i < MAX_PSYC_PAGES; i++){
80107235:	31 c0                	xor    %eax,%eax
80107237:	eb 12                	jmp    8010724b <deallocuvm.part.0+0xcb>
80107239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107240:	83 c0 01             	add    $0x1,%eax
80107243:	83 c1 18             	add    $0x18,%ecx
80107246:	83 f8 10             	cmp    $0x10,%eax
80107249:	74 80                	je     801071cb <deallocuvm.part.0+0x4b>
      if(p->mem_pages[i].va == va){
8010724b:	3b 19                	cmp    (%ecx),%ebx
8010724d:	75 f1                	jne    80107240 <deallocuvm.part.0+0xc0>

    if(i == MAX_PSYC_PAGES){
      return;
    }

    if (p->mem_pages[i].in_mem == 1){
8010724f:	8d 04 40             	lea    (%eax,%eax,2),%eax
80107252:	8d 04 c2             	lea    (%edx,%eax,8),%eax
80107255:	80 b8 24 01 00 00 01 	cmpb   $0x1,0x124(%eax)
8010725c:	0f 85 69 ff ff ff    	jne    801071cb <deallocuvm.part.0+0x4b>
      p->mem_pages[i].in_mem = 0;
80107262:	c6 80 24 01 00 00 00 	movb   $0x0,0x124(%eax)
      p->mem_pages[i].va = 0;
80107269:	c7 80 1c 01 00 00 00 	movl   $0x0,0x11c(%eax)
80107270:	00 00 00 
      p->num_of_pages_in_memory--;
80107273:	83 aa 80 00 00 00 01 	subl   $0x1,0x80(%edx)
8010727a:	e9 4c ff ff ff       	jmp    801071cb <deallocuvm.part.0+0x4b>
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
8010727f:	83 ec 0c             	sub    $0xc,%esp
80107282:	68 aa 82 10 80       	push   $0x801082aa
80107287:	e8 e4 90 ff ff       	call   80100370 <panic>
8010728c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107290 <printDebugSFM>:

extern char end[];
extern char data[];  // defined by kernel.ld
pde_t *kpgdir;  // for use in scheduler()

void printDebugSFM(struct proc *p){
80107290:	55                   	push   %ebp
80107291:	89 e5                	mov    %esp,%ebp
80107293:	56                   	push   %esi
80107294:	53                   	push   %ebx
80107295:	8b 5d 08             	mov    0x8(%ebp),%ebx
  cprintf("\n%s num of pages in swap file: %d\n",p->name, p->num_of_currently_swapped_out_pages);
      int j;
      for(j = 0 ; j < MAX_PSYC_PAGES ; j++){
80107298:	31 f6                	xor    %esi,%esi
extern char end[];
extern char data[];  // defined by kernel.ld
pde_t *kpgdir;  // for use in scheduler()

void printDebugSFM(struct proc *p){
  cprintf("\n%s num of pages in swap file: %d\n",p->name, p->num_of_currently_swapped_out_pages);
8010729a:	83 ec 04             	sub    $0x4,%esp
8010729d:	8d 43 6c             	lea    0x6c(%ebx),%eax
801072a0:	ff b3 84 00 00 00    	pushl  0x84(%ebx)
801072a6:	81 c3 90 00 00 00    	add    $0x90,%ebx
801072ac:	50                   	push   %eax
801072ad:	68 74 8b 10 80       	push   $0x80108b74
801072b2:	e8 a9 93 ff ff       	call   80100660 <cprintf>
801072b7:	83 c4 10             	add    $0x10,%esp
801072ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      int j;
      for(j = 0 ; j < MAX_PSYC_PAGES ; j++){
        cprintf("i: %d, in_swap_file: %d, va: %x\n",j , p->sfm[j].in_swap_file, p->sfm[j].va);
801072c0:	ff 33                	pushl  (%ebx)
801072c2:	0f be 43 04          	movsbl 0x4(%ebx),%eax
801072c6:	83 c3 08             	add    $0x8,%ebx
801072c9:	50                   	push   %eax
801072ca:	56                   	push   %esi
pde_t *kpgdir;  // for use in scheduler()

void printDebugSFM(struct proc *p){
  cprintf("\n%s num of pages in swap file: %d\n",p->name, p->num_of_currently_swapped_out_pages);
      int j;
      for(j = 0 ; j < MAX_PSYC_PAGES ; j++){
801072cb:	83 c6 01             	add    $0x1,%esi
        cprintf("i: %d, in_swap_file: %d, va: %x\n",j , p->sfm[j].in_swap_file, p->sfm[j].va);
801072ce:	68 98 8b 10 80       	push   $0x80108b98
801072d3:	e8 88 93 ff ff       	call   80100660 <cprintf>
pde_t *kpgdir;  // for use in scheduler()

void printDebugSFM(struct proc *p){
  cprintf("\n%s num of pages in swap file: %d\n",p->name, p->num_of_currently_swapped_out_pages);
      int j;
      for(j = 0 ; j < MAX_PSYC_PAGES ; j++){
801072d8:	83 c4 10             	add    $0x10,%esp
801072db:	83 fe 10             	cmp    $0x10,%esi
801072de:	75 e0                	jne    801072c0 <printDebugSFM+0x30>
        cprintf("i: %d, in_swap_file: %d, va: %x\n",j , p->sfm[j].in_swap_file, p->sfm[j].va);
      }
}
801072e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801072e3:	5b                   	pop    %ebx
801072e4:	5e                   	pop    %esi
801072e5:	5d                   	pop    %ebp
801072e6:	c3                   	ret    
801072e7:	89 f6                	mov    %esi,%esi
801072e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801072f0 <printDebugMem>:

void printDebugMem(struct proc *p){
801072f0:	55                   	push   %ebp
801072f1:	89 e5                	mov    %esp,%ebp
801072f3:	56                   	push   %esi
801072f4:	53                   	push   %ebx
801072f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  cprintf("\n%s num of pages in memory:  %d\n",p->name, p->num_of_pages_in_memory);
      int j;
      for(j = 0 ; j < MAX_PSYC_PAGES ; j++){
801072f8:	31 f6                	xor    %esi,%esi
        cprintf("i: %d, in_swap_file: %d, va: %x\n",j , p->sfm[j].in_swap_file, p->sfm[j].va);
      }
}

void printDebugMem(struct proc *p){
  cprintf("\n%s num of pages in memory:  %d\n",p->name, p->num_of_pages_in_memory);
801072fa:	83 ec 04             	sub    $0x4,%esp
801072fd:	8d 43 6c             	lea    0x6c(%ebx),%eax
80107300:	ff b3 80 00 00 00    	pushl  0x80(%ebx)
80107306:	81 c3 18 01 00 00    	add    $0x118,%ebx
8010730c:	50                   	push   %eax
8010730d:	68 bc 8b 10 80       	push   $0x80108bbc
80107312:	e8 49 93 ff ff       	call   80100660 <cprintf>
80107317:	83 c4 10             	add    $0x10,%esp
8010731a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      int j;
      for(j = 0 ; j < MAX_PSYC_PAGES ; j++){
        cprintf("i: %d, in_mem: %d, va: %x, mem: %x, age: %x\n",j , 
80107320:	83 ec 08             	sub    $0x8,%esp
80107323:	ff 33                	pushl  (%ebx)
80107325:	ff 73 08             	pushl  0x8(%ebx)
80107328:	ff 73 04             	pushl  0x4(%ebx)
8010732b:	0f be 43 0c          	movsbl 0xc(%ebx),%eax
8010732f:	83 c3 18             	add    $0x18,%ebx
80107332:	50                   	push   %eax
80107333:	56                   	push   %esi
}

void printDebugMem(struct proc *p){
  cprintf("\n%s num of pages in memory:  %d\n",p->name, p->num_of_pages_in_memory);
      int j;
      for(j = 0 ; j < MAX_PSYC_PAGES ; j++){
80107334:	83 c6 01             	add    $0x1,%esi
        cprintf("i: %d, in_mem: %d, va: %x, mem: %x, age: %x\n",j , 
80107337:	68 e0 8b 10 80       	push   $0x80108be0
8010733c:	e8 1f 93 ff ff       	call   80100660 <cprintf>
}

void printDebugMem(struct proc *p){
  cprintf("\n%s num of pages in memory:  %d\n",p->name, p->num_of_pages_in_memory);
      int j;
      for(j = 0 ; j < MAX_PSYC_PAGES ; j++){
80107341:	83 c4 20             	add    $0x20,%esp
80107344:	83 fe 10             	cmp    $0x10,%esi
80107347:	75 d7                	jne    80107320 <printDebugMem+0x30>
        cprintf("i: %d, in_mem: %d, va: %x, mem: %x, age: %x\n",j , 
          p->mem_pages[j].in_mem, p->mem_pages[j].va, p->mem_pages[j].mem, p->mem_pages[j].aging);
      }
}
80107349:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010734c:	5b                   	pop    %ebx
8010734d:	5e                   	pop    %esi
8010734e:	5d                   	pop    %ebp
8010734f:	c3                   	ret    

80107350 <updateMemPages>:

/// update the memory pages data of process according to the specified algorithm
/// on page addition
void updateMemPages(void* va, void* mem, struct proc *p){
80107350:	55                   	push   %ebp
  int i;
  for(i = 0; i < MAX_PSYC_PAGES; i++){
80107351:	31 c0                	xor    %eax,%eax
      }
}

/// update the memory pages data of process according to the specified algorithm
/// on page addition
void updateMemPages(void* va, void* mem, struct proc *p){
80107353:	89 e5                	mov    %esp,%ebp
80107355:	83 ec 08             	sub    $0x8,%esp
80107358:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010735b:	8d 91 24 01 00 00    	lea    0x124(%ecx),%edx
80107361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int i;
  for(i = 0; i < MAX_PSYC_PAGES; i++){
    if(p->mem_pages[i].in_mem == 0){
80107368:	80 3a 00             	cmpb   $0x0,(%edx)
8010736b:	74 1b                	je     80107388 <updateMemPages+0x38>

/// update the memory pages data of process according to the specified algorithm
/// on page addition
void updateMemPages(void* va, void* mem, struct proc *p){
  int i;
  for(i = 0; i < MAX_PSYC_PAGES; i++){
8010736d:	83 c0 01             	add    $0x1,%eax
80107370:	83 c2 18             	add    $0x18,%edx
80107373:	83 f8 10             	cmp    $0x10,%eax
80107376:	75 f0                	jne    80107368 <updateMemPages+0x18>
      break;
    }
  }

  if(i == MAX_PSYC_PAGES){
    panic("mem_pages is full but shouldn't");
80107378:	83 ec 0c             	sub    $0xc,%esp
8010737b:	68 10 8c 10 80       	push   $0x80108c10
80107380:	e8 eb 8f ff ff       	call   80100370 <panic>
80107385:	8d 76 00             	lea    0x0(%esi),%esi
  }

  p->mem_pages[i].in_mem = 1;
80107388:	8d 04 40             	lea    (%eax,%eax,2),%eax
  p->mem_pages[i].va = va;
8010738b:	8b 55 08             	mov    0x8(%ebp),%edx

  if(i == MAX_PSYC_PAGES){
    panic("mem_pages is full but shouldn't");
  }

  p->mem_pages[i].in_mem = 1;
8010738e:	8d 04 c1             	lea    (%ecx,%eax,8),%eax
  p->mem_pages[i].va = va;
80107391:	89 90 1c 01 00 00    	mov    %edx,0x11c(%eax)
  p->mem_pages[i].mem = mem;
80107397:	8b 55 0c             	mov    0xc(%ebp),%edx

  if(i == MAX_PSYC_PAGES){
    panic("mem_pages is full but shouldn't");
  }

  p->mem_pages[i].in_mem = 1;
8010739a:	c6 80 24 01 00 00 01 	movb   $0x1,0x124(%eax)
  p->mem_pages[i].va = va;
  p->mem_pages[i].mem = mem;
801073a1:	89 90 20 01 00 00    	mov    %edx,0x120(%eax)
  p->num_of_pages_in_memory++;
801073a7:	83 81 80 00 00 00 01 	addl   $0x1,0x80(%ecx)

  #ifdef NFUA
    p->mem_pages[i].aging = 0;
801073ae:	c7 80 18 01 00 00 00 	movl   $0x0,0x118(%eax)
801073b5:	00 00 00 
  //     }

  //     p->mem_pages[i]->next = 0;
  //     p->mem_pages[i]->prev = curr;
  // #endif
}
801073b8:	c9                   	leave  
801073b9:	c3                   	ret    
801073ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801073c0 <updateMemPagesOnRemove>:

/// update the memory pages data of process according to the specified algorithm
/// on page removal
void updateMemPagesOnRemove(void* va, struct proc *p){
801073c0:	55                   	push   %ebp
  #if defined(LAPA) || defined(NFUA) || defined(SCFIFO)
    int i;
    for(i = 0; i < MAX_PSYC_PAGES; i++){
801073c1:	31 c0                	xor    %eax,%eax
  // #endif
}

/// update the memory pages data of process according to the specified algorithm
/// on page removal
void updateMemPagesOnRemove(void* va, struct proc *p){
801073c3:	89 e5                	mov    %esp,%ebp
801073c5:	53                   	push   %ebx
801073c6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801073c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
801073cc:	8d 93 1c 01 00 00    	lea    0x11c(%ebx),%edx
801073d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  #if defined(LAPA) || defined(NFUA) || defined(SCFIFO)
    int i;
    for(i = 0; i < MAX_PSYC_PAGES; i++){
      if(p->mem_pages[i].va == va){
801073d8:	39 0a                	cmp    %ecx,(%edx)
801073da:	74 14                	je     801073f0 <updateMemPagesOnRemove+0x30>
/// update the memory pages data of process according to the specified algorithm
/// on page removal
void updateMemPagesOnRemove(void* va, struct proc *p){
  #if defined(LAPA) || defined(NFUA) || defined(SCFIFO)
    int i;
    for(i = 0; i < MAX_PSYC_PAGES; i++){
801073dc:	83 c0 01             	add    $0x1,%eax
801073df:	83 c2 18             	add    $0x18,%edx
801073e2:	83 f8 10             	cmp    $0x10,%eax
801073e5:	75 f1                	jne    801073d8 <updateMemPagesOnRemove+0x18>
      p->mem_pages[p->num_of_pages_in_memory - 1].in_mem = 0;
      p->mem_pages[p->num_of_pages_in_memory - 1].va = 0;
      p->num_of_pages_in_memory--;
    }
  #endif
}
801073e7:	5b                   	pop    %ebx
801073e8:	5d                   	pop    %ebp
801073e9:	c3                   	ret    
801073ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

    if(i == MAX_PSYC_PAGES){
      return;
    }

    if (p->mem_pages[i].in_mem == 1){
801073f0:	8d 04 40             	lea    (%eax,%eax,2),%eax
801073f3:	8d 04 c3             	lea    (%ebx,%eax,8),%eax
801073f6:	80 b8 24 01 00 00 01 	cmpb   $0x1,0x124(%eax)
801073fd:	75 e8                	jne    801073e7 <updateMemPagesOnRemove+0x27>
      p->mem_pages[i].in_mem = 0;
801073ff:	c6 80 24 01 00 00 00 	movb   $0x0,0x124(%eax)
      p->mem_pages[i].va = 0;
80107406:	c7 80 1c 01 00 00 00 	movl   $0x0,0x11c(%eax)
8010740d:	00 00 00 
      p->num_of_pages_in_memory--;
80107410:	83 ab 80 00 00 00 01 	subl   $0x1,0x80(%ebx)
      p->mem_pages[p->num_of_pages_in_memory - 1].in_mem = 0;
      p->mem_pages[p->num_of_pages_in_memory - 1].va = 0;
      p->num_of_pages_in_memory--;
    }
  #endif
}
80107417:	5b                   	pop    %ebx
80107418:	5d                   	pop    %ebp
80107419:	c3                   	ret    
8010741a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107420 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107420:	55                   	push   %ebp
80107421:	89 e5                	mov    %esp,%ebp
80107423:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80107426:	e8 35 c8 ff ff       	call   80103c60 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010742b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107431:	31 c9                	xor    %ecx,%ecx
80107433:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80107438:	66 89 90 18 38 11 80 	mov    %dx,-0x7feec7e8(%eax)
8010743f:	66 89 88 1a 38 11 80 	mov    %cx,-0x7feec7e6(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107446:	ba ff ff ff ff       	mov    $0xffffffff,%edx
8010744b:	31 c9                	xor    %ecx,%ecx
8010744d:	66 89 90 20 38 11 80 	mov    %dx,-0x7feec7e0(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107454:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107459:	66 89 88 22 38 11 80 	mov    %cx,-0x7feec7de(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107460:	31 c9                	xor    %ecx,%ecx
80107462:	66 89 90 28 38 11 80 	mov    %dx,-0x7feec7d8(%eax)
80107469:	66 89 88 2a 38 11 80 	mov    %cx,-0x7feec7d6(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107470:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80107475:	31 c9                	xor    %ecx,%ecx
80107477:	66 89 90 30 38 11 80 	mov    %dx,-0x7feec7d0(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010747e:	c6 80 1c 38 11 80 00 	movb   $0x0,-0x7feec7e4(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80107485:	ba 2f 00 00 00       	mov    $0x2f,%edx
8010748a:	c6 80 1d 38 11 80 9a 	movb   $0x9a,-0x7feec7e3(%eax)
80107491:	c6 80 1e 38 11 80 cf 	movb   $0xcf,-0x7feec7e2(%eax)
80107498:	c6 80 1f 38 11 80 00 	movb   $0x0,-0x7feec7e1(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010749f:	c6 80 24 38 11 80 00 	movb   $0x0,-0x7feec7dc(%eax)
801074a6:	c6 80 25 38 11 80 92 	movb   $0x92,-0x7feec7db(%eax)
801074ad:	c6 80 26 38 11 80 cf 	movb   $0xcf,-0x7feec7da(%eax)
801074b4:	c6 80 27 38 11 80 00 	movb   $0x0,-0x7feec7d9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801074bb:	c6 80 2c 38 11 80 00 	movb   $0x0,-0x7feec7d4(%eax)
801074c2:	c6 80 2d 38 11 80 fa 	movb   $0xfa,-0x7feec7d3(%eax)
801074c9:	c6 80 2e 38 11 80 cf 	movb   $0xcf,-0x7feec7d2(%eax)
801074d0:	c6 80 2f 38 11 80 00 	movb   $0x0,-0x7feec7d1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801074d7:	66 89 88 32 38 11 80 	mov    %cx,-0x7feec7ce(%eax)
801074de:	c6 80 34 38 11 80 00 	movb   $0x0,-0x7feec7cc(%eax)
801074e5:	c6 80 35 38 11 80 f2 	movb   $0xf2,-0x7feec7cb(%eax)
801074ec:	c6 80 36 38 11 80 cf 	movb   $0xcf,-0x7feec7ca(%eax)
801074f3:	c6 80 37 38 11 80 00 	movb   $0x0,-0x7feec7c9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
801074fa:	05 10 38 11 80       	add    $0x80113810,%eax
801074ff:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
80107503:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107507:	c1 e8 10             	shr    $0x10,%eax
8010750a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
8010750e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107511:	0f 01 10             	lgdtl  (%eax)
}
80107514:	c9                   	leave  
80107515:	c3                   	ret    
80107516:	8d 76 00             	lea    0x0(%esi),%esi
80107519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107520 <walkpgdir_noalloc>:
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}

pte_t* walkpgdir_noalloc(pde_t *pgdir, const void *va){
80107520:	55                   	push   %ebp
80107521:	89 e5                	mov    %esp,%ebp
80107523:	8b 45 0c             	mov    0xc(%ebp),%eax
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80107526:	8b 55 08             	mov    0x8(%ebp),%edx
80107529:	89 c1                	mov    %eax,%ecx
8010752b:	c1 e9 16             	shr    $0x16,%ecx
8010752e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107531:	f6 c2 01             	test   $0x1,%dl
80107534:	74 1a                	je     80107550 <walkpgdir_noalloc+0x30>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
    return &pgtab[PTX(va)];
80107536:	c1 e8 0a             	shr    $0xa,%eax
80107539:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
8010753f:	25 fc 0f 00 00       	and    $0xffc,%eax
80107544:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  }

  return 0;
}
8010754b:	5d                   	pop    %ebp
8010754c:	c3                   	ret    
8010754d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
    return &pgtab[PTX(va)];
  }

  return 0;
80107550:	31 c0                	xor    %eax,%eax
}
80107552:	5d                   	pop    %ebp
80107553:	c3                   	ret    
80107554:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010755a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107560 <switchkvm>:
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107560:	a1 c4 eb 11 80       	mov    0x8011ebc4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107565:	55                   	push   %ebp
80107566:	89 e5                	mov    %esp,%ebp
80107568:	05 00 00 00 80       	add    $0x80000000,%eax
8010756d:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
80107570:	5d                   	pop    %ebp
80107571:	c3                   	ret    
80107572:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107580 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107580:	55                   	push   %ebp
80107581:	89 e5                	mov    %esp,%ebp
80107583:	57                   	push   %edi
80107584:	56                   	push   %esi
80107585:	53                   	push   %ebx
80107586:	83 ec 1c             	sub    $0x1c,%esp
80107589:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010758c:	85 f6                	test   %esi,%esi
8010758e:	0f 84 cd 00 00 00    	je     80107661 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80107594:	8b 46 08             	mov    0x8(%esi),%eax
80107597:	85 c0                	test   %eax,%eax
80107599:	0f 84 dc 00 00 00    	je     8010767b <switchuvm+0xfb>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
8010759f:	8b 7e 04             	mov    0x4(%esi),%edi
801075a2:	85 ff                	test   %edi,%edi
801075a4:	0f 84 c4 00 00 00    	je     8010766e <switchuvm+0xee>
    panic("switchuvm: no pgdir");

  pushcli();
801075aa:	e8 b1 d6 ff ff       	call   80104c60 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801075af:	e8 2c c6 ff ff       	call   80103be0 <mycpu>
801075b4:	89 c3                	mov    %eax,%ebx
801075b6:	e8 25 c6 ff ff       	call   80103be0 <mycpu>
801075bb:	89 c7                	mov    %eax,%edi
801075bd:	e8 1e c6 ff ff       	call   80103be0 <mycpu>
801075c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801075c5:	83 c7 08             	add    $0x8,%edi
801075c8:	e8 13 c6 ff ff       	call   80103be0 <mycpu>
801075cd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801075d0:	83 c0 08             	add    $0x8,%eax
801075d3:	ba 67 00 00 00       	mov    $0x67,%edx
801075d8:	c1 e8 18             	shr    $0x18,%eax
801075db:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
801075e2:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801075e9:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
801075f0:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
801075f7:	83 c1 08             	add    $0x8,%ecx
801075fa:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80107600:	c1 e9 10             	shr    $0x10,%ecx
80107603:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107609:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
8010760e:	e8 cd c5 ff ff       	call   80103be0 <mycpu>
80107613:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010761a:	e8 c1 c5 ff ff       	call   80103be0 <mycpu>
8010761f:	b9 10 00 00 00       	mov    $0x10,%ecx
80107624:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107628:	e8 b3 c5 ff ff       	call   80103be0 <mycpu>
8010762d:	8b 56 08             	mov    0x8(%esi),%edx
80107630:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80107636:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107639:	e8 a2 c5 ff ff       	call   80103be0 <mycpu>
8010763e:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80107642:	b8 28 00 00 00       	mov    $0x28,%eax
80107647:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010764a:	8b 46 04             	mov    0x4(%esi),%eax
8010764d:	05 00 00 00 80       	add    $0x80000000,%eax
80107652:	0f 22 d8             	mov    %eax,%cr3
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
80107655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107658:	5b                   	pop    %ebx
80107659:	5e                   	pop    %esi
8010765a:	5f                   	pop    %edi
8010765b:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
8010765c:	e9 0f d7 ff ff       	jmp    80104d70 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
80107661:	83 ec 0c             	sub    $0xc,%esp
80107664:	68 56 8a 10 80       	push   $0x80108a56
80107669:	e8 02 8d ff ff       	call   80100370 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
8010766e:	83 ec 0c             	sub    $0xc,%esp
80107671:	68 81 8a 10 80       	push   $0x80108a81
80107676:	e8 f5 8c ff ff       	call   80100370 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
8010767b:	83 ec 0c             	sub    $0xc,%esp
8010767e:	68 6c 8a 10 80       	push   $0x80108a6c
80107683:	e8 e8 8c ff ff       	call   80100370 <panic>
80107688:	90                   	nop
80107689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107690 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107690:	55                   	push   %ebp
80107691:	89 e5                	mov    %esp,%ebp
80107693:	57                   	push   %edi
80107694:	56                   	push   %esi
80107695:	53                   	push   %ebx
80107696:	83 ec 1c             	sub    $0x1c,%esp
80107699:	8b 75 10             	mov    0x10(%ebp),%esi
8010769c:	8b 45 08             	mov    0x8(%ebp),%eax
8010769f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
801076a2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801076a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
801076ab:	77 49                	ja     801076f6 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
801076ad:	e8 4e b2 ff ff       	call   80102900 <kalloc>
  memset(mem, 0, PGSIZE);
801076b2:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
801076b5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801076b7:	68 00 10 00 00       	push   $0x1000
801076bc:	6a 00                	push   $0x0
801076be:	50                   	push   %eax
801076bf:	e8 6c d7 ff ff       	call   80104e30 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801076c4:	58                   	pop    %eax
801076c5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801076cb:	b9 00 10 00 00       	mov    $0x1000,%ecx
801076d0:	5a                   	pop    %edx
801076d1:	6a 06                	push   $0x6
801076d3:	50                   	push   %eax
801076d4:	31 d2                	xor    %edx,%edx
801076d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801076d9:	e8 12 fa ff ff       	call   801070f0 <mappages>
  memmove(mem, init, sz);
801076de:	89 75 10             	mov    %esi,0x10(%ebp)
801076e1:	89 7d 0c             	mov    %edi,0xc(%ebp)
801076e4:	83 c4 10             	add    $0x10,%esp
801076e7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801076ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076ed:	5b                   	pop    %ebx
801076ee:	5e                   	pop    %esi
801076ef:	5f                   	pop    %edi
801076f0:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
801076f1:	e9 ea d7 ff ff       	jmp    80104ee0 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
801076f6:	83 ec 0c             	sub    $0xc,%esp
801076f9:	68 95 8a 10 80       	push   $0x80108a95
801076fe:	e8 6d 8c ff ff       	call   80100370 <panic>
80107703:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107710 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107710:	55                   	push   %ebp
80107711:	89 e5                	mov    %esp,%ebp
80107713:	57                   	push   %edi
80107714:	56                   	push   %esi
80107715:	53                   	push   %ebx
80107716:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107719:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107720:	0f 85 91 00 00 00    	jne    801077b7 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107726:	8b 75 18             	mov    0x18(%ebp),%esi
80107729:	31 db                	xor    %ebx,%ebx
8010772b:	85 f6                	test   %esi,%esi
8010772d:	75 1a                	jne    80107749 <loaduvm+0x39>
8010772f:	eb 6f                	jmp    801077a0 <loaduvm+0x90>
80107731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107738:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010773e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107744:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107747:	76 57                	jbe    801077a0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107749:	8b 55 0c             	mov    0xc(%ebp),%edx
8010774c:	8b 45 08             	mov    0x8(%ebp),%eax
8010774f:	31 c9                	xor    %ecx,%ecx
80107751:	01 da                	add    %ebx,%edx
80107753:	e8 18 f9 ff ff       	call   80107070 <walkpgdir>
80107758:	85 c0                	test   %eax,%eax
8010775a:	74 4e                	je     801077aa <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
8010775c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010775e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
80107761:	bf 00 10 00 00       	mov    $0x1000,%edi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80107766:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010776b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107771:	0f 46 fe             	cmovbe %esi,%edi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107774:	01 d9                	add    %ebx,%ecx
80107776:	05 00 00 00 80       	add    $0x80000000,%eax
8010777b:	57                   	push   %edi
8010777c:	51                   	push   %ecx
8010777d:	50                   	push   %eax
8010777e:	ff 75 10             	pushl  0x10(%ebp)
80107781:	e8 5a a2 ff ff       	call   801019e0 <readi>
80107786:	83 c4 10             	add    $0x10,%esp
80107789:	39 c7                	cmp    %eax,%edi
8010778b:	74 ab                	je     80107738 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
8010778d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80107790:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80107795:	5b                   	pop    %ebx
80107796:	5e                   	pop    %esi
80107797:	5f                   	pop    %edi
80107798:	5d                   	pop    %ebp
80107799:	c3                   	ret    
8010779a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801077a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
801077a3:	31 c0                	xor    %eax,%eax
}
801077a5:	5b                   	pop    %ebx
801077a6:	5e                   	pop    %esi
801077a7:	5f                   	pop    %edi
801077a8:	5d                   	pop    %ebp
801077a9:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
801077aa:	83 ec 0c             	sub    $0xc,%esp
801077ad:	68 af 8a 10 80       	push   $0x80108aaf
801077b2:	e8 b9 8b ff ff       	call   80100370 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
801077b7:	83 ec 0c             	sub    $0xc,%esp
801077ba:	68 30 8c 10 80       	push   $0x80108c30
801077bf:	e8 ac 8b ff ff       	call   80100370 <panic>
801077c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801077ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801077d0 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801077d0:	55                   	push   %ebp
801077d1:	89 e5                	mov    %esp,%ebp
801077d3:	8b 55 0c             	mov    0xc(%ebp),%edx
801077d6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801077d9:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801077dc:	39 d1                	cmp    %edx,%ecx
801077de:	73 10                	jae    801077f0 <deallocuvm+0x20>
      *pte = 0;
    }
  }

  return newsz;
}
801077e0:	5d                   	pop    %ebp
801077e1:	e9 9a f9 ff ff       	jmp    80107180 <deallocuvm.part.0>
801077e6:	8d 76 00             	lea    0x0(%esi),%esi
801077e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801077f0:	89 d0                	mov    %edx,%eax
801077f2:	5d                   	pop    %ebp
801077f3:	c3                   	ret    
801077f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801077fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107800 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107800:	55                   	push   %ebp
80107801:	89 e5                	mov    %esp,%ebp
80107803:	57                   	push   %edi
80107804:	56                   	push   %esi
80107805:	53                   	push   %ebx
80107806:	83 ec 0c             	sub    $0xc,%esp
80107809:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010780c:	85 f6                	test   %esi,%esi
8010780e:	74 59                	je     80107869 <freevm+0x69>
80107810:	31 c9                	xor    %ecx,%ecx
80107812:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107817:	89 f0                	mov    %esi,%eax
80107819:	e8 62 f9 ff ff       	call   80107180 <deallocuvm.part.0>
8010781e:	89 f3                	mov    %esi,%ebx
80107820:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107826:	eb 0f                	jmp    80107837 <freevm+0x37>
80107828:	90                   	nop
80107829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107830:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107833:	39 fb                	cmp    %edi,%ebx
80107835:	74 23                	je     8010785a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107837:	8b 03                	mov    (%ebx),%eax
80107839:	a8 01                	test   $0x1,%al
8010783b:	74 f3                	je     80107830 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
8010783d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107842:	83 ec 0c             	sub    $0xc,%esp
80107845:	83 c3 04             	add    $0x4,%ebx
80107848:	05 00 00 00 80       	add    $0x80000000,%eax
8010784d:	50                   	push   %eax
8010784e:	e8 bd ae ff ff       	call   80102710 <kfree>
80107853:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107856:	39 fb                	cmp    %edi,%ebx
80107858:	75 dd                	jne    80107837 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
8010785a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010785d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107860:	5b                   	pop    %ebx
80107861:	5e                   	pop    %esi
80107862:	5f                   	pop    %edi
80107863:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80107864:	e9 a7 ae ff ff       	jmp    80102710 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80107869:	83 ec 0c             	sub    $0xc,%esp
8010786c:	68 cd 8a 10 80       	push   $0x80108acd
80107871:	e8 fa 8a ff ff       	call   80100370 <panic>
80107876:	8d 76 00             	lea    0x0(%esi),%esi
80107879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107880 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107880:	55                   	push   %ebp
80107881:	89 e5                	mov    %esp,%ebp
80107883:	56                   	push   %esi
80107884:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107885:	e8 76 b0 ff ff       	call   80102900 <kalloc>
8010788a:	85 c0                	test   %eax,%eax
8010788c:	74 6a                	je     801078f8 <setupkvm+0x78>
    return 0;
  memset(pgdir, 0, PGSIZE);
8010788e:	83 ec 04             	sub    $0x4,%esp
80107891:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107893:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80107898:	68 00 10 00 00       	push   $0x1000
8010789d:	6a 00                	push   $0x0
8010789f:	50                   	push   %eax
801078a0:	e8 8b d5 ff ff       	call   80104e30 <memset>
801078a5:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801078a8:	8b 43 04             	mov    0x4(%ebx),%eax
801078ab:	8b 4b 08             	mov    0x8(%ebx),%ecx
801078ae:	83 ec 08             	sub    $0x8,%esp
801078b1:	8b 13                	mov    (%ebx),%edx
801078b3:	ff 73 0c             	pushl  0xc(%ebx)
801078b6:	50                   	push   %eax
801078b7:	29 c1                	sub    %eax,%ecx
801078b9:	89 f0                	mov    %esi,%eax
801078bb:	e8 30 f8 ff ff       	call   801070f0 <mappages>
801078c0:	83 c4 10             	add    $0x10,%esp
801078c3:	85 c0                	test   %eax,%eax
801078c5:	78 19                	js     801078e0 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801078c7:	83 c3 10             	add    $0x10,%ebx
801078ca:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801078d0:	75 d6                	jne    801078a8 <setupkvm+0x28>
801078d2:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
801078d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801078d7:	5b                   	pop    %ebx
801078d8:	5e                   	pop    %esi
801078d9:	5d                   	pop    %ebp
801078da:	c3                   	ret    
801078db:	90                   	nop
801078dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
801078e0:	83 ec 0c             	sub    $0xc,%esp
801078e3:	56                   	push   %esi
801078e4:	e8 17 ff ff ff       	call   80107800 <freevm>
      return 0;
801078e9:	83 c4 10             	add    $0x10,%esp
    }
  return pgdir;
}
801078ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
801078ef:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
801078f1:	5b                   	pop    %ebx
801078f2:	5e                   	pop    %esi
801078f3:	5d                   	pop    %ebp
801078f4:	c3                   	ret    
801078f5:	8d 76 00             	lea    0x0(%esi),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
801078f8:	31 c0                	xor    %eax,%eax
801078fa:	eb d8                	jmp    801078d4 <setupkvm+0x54>
801078fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107900 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107900:	55                   	push   %ebp
80107901:	89 e5                	mov    %esp,%ebp
80107903:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107906:	e8 75 ff ff ff       	call   80107880 <setupkvm>
8010790b:	a3 c4 eb 11 80       	mov    %eax,0x8011ebc4
80107910:	05 00 00 00 80       	add    $0x80000000,%eax
80107915:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
80107918:	c9                   	leave  
80107919:	c3                   	ret    
8010791a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107920 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107920:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107921:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107923:	89 e5                	mov    %esp,%ebp
80107925:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107928:	8b 55 0c             	mov    0xc(%ebp),%edx
8010792b:	8b 45 08             	mov    0x8(%ebp),%eax
8010792e:	e8 3d f7 ff ff       	call   80107070 <walkpgdir>
  if(pte == 0)
80107933:	85 c0                	test   %eax,%eax
80107935:	74 05                	je     8010793c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107937:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010793a:	c9                   	leave  
8010793b:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
8010793c:	83 ec 0c             	sub    $0xc,%esp
8010793f:	68 de 8a 10 80       	push   $0x80108ade
80107944:	e8 27 8a ff ff       	call   80100370 <panic>
80107949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107950 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107950:	55                   	push   %ebp
80107951:	89 e5                	mov    %esp,%ebp
80107953:	57                   	push   %edi
80107954:	56                   	push   %esi
80107955:	53                   	push   %ebx
80107956:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107959:	e8 22 ff ff ff       	call   80107880 <setupkvm>
8010795e:	85 c0                	test   %eax,%eax
80107960:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107963:	0f 84 e2 00 00 00    	je     80107a4b <copyuvm+0xfb>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107969:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010796c:	85 c9                	test   %ecx,%ecx
8010796e:	0f 84 cc 00 00 00    	je     80107a40 <copyuvm+0xf0>
80107974:	31 f6                	xor    %esi,%esi
80107976:	eb 2c                	jmp    801079a4 <copyuvm+0x54>
80107978:	90                   	nop
80107979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P) && !(*pte & PTE_PG))
      panic("copyuvm: page not present");
    if(*pte & PTE_PG){
        pte=walkpgdir(d,(void*)i,1);
80107980:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107983:	b9 01 00 00 00       	mov    $0x1,%ecx
80107988:	89 f2                	mov    %esi,%edx
8010798a:	e8 e1 f6 ff ff       	call   80107070 <walkpgdir>
        *pte= PTE_U | PTE_W | PTE_PG ;
8010798f:	c7 00 06 02 00 00    	movl   $0x206,(%eax)
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107995:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010799b:	39 75 0c             	cmp    %esi,0xc(%ebp)
8010799e:	0f 86 9c 00 00 00    	jbe    80107a40 <copyuvm+0xf0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801079a4:	8b 45 08             	mov    0x8(%ebp),%eax
801079a7:	31 c9                	xor    %ecx,%ecx
801079a9:	89 f2                	mov    %esi,%edx
801079ab:	e8 c0 f6 ff ff       	call   80107070 <walkpgdir>
801079b0:	85 c0                	test   %eax,%eax
801079b2:	0f 84 a4 00 00 00    	je     80107a5c <copyuvm+0x10c>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P) && !(*pte & PTE_PG))
801079b8:	8b 18                	mov    (%eax),%ebx
801079ba:	f7 c3 01 02 00 00    	test   $0x201,%ebx
801079c0:	0f 84 89 00 00 00    	je     80107a4f <copyuvm+0xff>
      panic("copyuvm: page not present");
    if(*pte & PTE_PG){
801079c6:	f6 c7 02             	test   $0x2,%bh
801079c9:	75 b5                	jne    80107980 <copyuvm+0x30>
        pte=walkpgdir(d,(void*)i,1);
        *pte= PTE_U | PTE_W | PTE_PG ;
        continue;
    }
    pa = PTE_ADDR(*pte);
801079cb:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
801079cd:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
801079d3:	89 5d e0             	mov    %ebx,-0x20(%ebp)
    if(*pte & PTE_PG){
        pte=walkpgdir(d,(void*)i,1);
        *pte= PTE_U | PTE_W | PTE_PG ;
        continue;
    }
    pa = PTE_ADDR(*pte);
801079d6:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
801079dc:	e8 1f af ff ff       	call   80102900 <kalloc>
801079e1:	85 c0                	test   %eax,%eax
801079e3:	89 c3                	mov    %eax,%ebx
801079e5:	74 3b                	je     80107a22 <copyuvm+0xd2>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801079e7:	83 ec 04             	sub    $0x4,%esp
801079ea:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801079f0:	68 00 10 00 00       	push   $0x1000
801079f5:	57                   	push   %edi
801079f6:	50                   	push   %eax
801079f7:	e8 e4 d4 ff ff       	call   80104ee0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
801079fc:	58                   	pop    %eax
801079fd:	5a                   	pop    %edx
801079fe:	8d 93 00 00 00 80    	lea    -0x80000000(%ebx),%edx
80107a04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107a07:	ff 75 e0             	pushl  -0x20(%ebp)
80107a0a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107a0f:	52                   	push   %edx
80107a10:	89 f2                	mov    %esi,%edx
80107a12:	e8 d9 f6 ff ff       	call   801070f0 <mappages>
80107a17:	83 c4 10             	add    $0x10,%esp
80107a1a:	85 c0                	test   %eax,%eax
80107a1c:	0f 89 73 ff ff ff    	jns    80107995 <copyuvm+0x45>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80107a22:	83 ec 0c             	sub    $0xc,%esp
80107a25:	ff 75 e4             	pushl  -0x1c(%ebp)
80107a28:	e8 d3 fd ff ff       	call   80107800 <freevm>
  return 0;
80107a2d:	83 c4 10             	add    $0x10,%esp
80107a30:	31 c0                	xor    %eax,%eax
}
80107a32:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a35:	5b                   	pop    %ebx
80107a36:	5e                   	pop    %esi
80107a37:	5f                   	pop    %edi
80107a38:	5d                   	pop    %ebp
80107a39:	c3                   	ret    
80107a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107a40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  return d;

bad:
  freevm(d);
  return 0;
}
80107a43:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a46:	5b                   	pop    %ebx
80107a47:	5e                   	pop    %esi
80107a48:	5f                   	pop    %edi
80107a49:	5d                   	pop    %ebp
80107a4a:	c3                   	ret    
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
80107a4b:	31 c0                	xor    %eax,%eax
80107a4d:	eb e3                	jmp    80107a32 <copyuvm+0xe2>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P) && !(*pte & PTE_PG))
      panic("copyuvm: page not present");
80107a4f:	83 ec 0c             	sub    $0xc,%esp
80107a52:	68 02 8b 10 80       	push   $0x80108b02
80107a57:	e8 14 89 ff ff       	call   80100370 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80107a5c:	83 ec 0c             	sub    $0xc,%esp
80107a5f:	68 e8 8a 10 80       	push   $0x80108ae8
80107a64:	e8 07 89 ff ff       	call   80100370 <panic>
80107a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107a70 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107a70:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107a71:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107a73:	89 e5                	mov    %esp,%ebp
80107a75:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107a78:	8b 55 0c             	mov    0xc(%ebp),%edx
80107a7b:	8b 45 08             	mov    0x8(%ebp),%eax
80107a7e:	e8 ed f5 ff ff       	call   80107070 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107a83:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80107a85:	89 c2                	mov    %eax,%edx
80107a87:	83 e2 05             	and    $0x5,%edx
80107a8a:	83 fa 05             	cmp    $0x5,%edx
80107a8d:	75 11                	jne    80107aa0 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80107a8f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
80107a94:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80107a95:	05 00 00 00 80       	add    $0x80000000,%eax
}
80107a9a:	c3                   	ret    
80107a9b:	90                   	nop
80107a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80107aa0:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80107aa2:	c9                   	leave  
80107aa3:	c3                   	ret    
80107aa4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107aaa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107ab0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107ab0:	55                   	push   %ebp
80107ab1:	89 e5                	mov    %esp,%ebp
80107ab3:	57                   	push   %edi
80107ab4:	56                   	push   %esi
80107ab5:	53                   	push   %ebx
80107ab6:	83 ec 1c             	sub    $0x1c,%esp
80107ab9:	8b 5d 14             	mov    0x14(%ebp),%ebx
80107abc:	8b 55 0c             	mov    0xc(%ebp),%edx
80107abf:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107ac2:	85 db                	test   %ebx,%ebx
80107ac4:	75 40                	jne    80107b06 <copyout+0x56>
80107ac6:	eb 70                	jmp    80107b38 <copyout+0x88>
80107ac8:	90                   	nop
80107ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107ad0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107ad3:	89 f1                	mov    %esi,%ecx
80107ad5:	29 d1                	sub    %edx,%ecx
80107ad7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80107add:	39 d9                	cmp    %ebx,%ecx
80107adf:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107ae2:	29 f2                	sub    %esi,%edx
80107ae4:	83 ec 04             	sub    $0x4,%esp
80107ae7:	01 d0                	add    %edx,%eax
80107ae9:	51                   	push   %ecx
80107aea:	57                   	push   %edi
80107aeb:	50                   	push   %eax
80107aec:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107aef:	e8 ec d3 ff ff       	call   80104ee0 <memmove>
    len -= n;
    buf += n;
80107af4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107af7:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
80107afa:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80107b00:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107b02:	29 cb                	sub    %ecx,%ebx
80107b04:	74 32                	je     80107b38 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107b06:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107b08:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80107b0b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107b0e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107b14:	56                   	push   %esi
80107b15:	ff 75 08             	pushl  0x8(%ebp)
80107b18:	e8 53 ff ff ff       	call   80107a70 <uva2ka>
    if(pa0 == 0)
80107b1d:	83 c4 10             	add    $0x10,%esp
80107b20:	85 c0                	test   %eax,%eax
80107b22:	75 ac                	jne    80107ad0 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80107b24:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80107b27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80107b2c:	5b                   	pop    %ebx
80107b2d:	5e                   	pop    %esi
80107b2e:	5f                   	pop    %edi
80107b2f:	5d                   	pop    %ebp
80107b30:	c3                   	ret    
80107b31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b38:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80107b3b:	31 c0                	xor    %eax,%eax
}
80107b3d:	5b                   	pop    %ebx
80107b3e:	5e                   	pop    %esi
80107b3f:	5f                   	pop    %edi
80107b40:	5d                   	pop    %ebp
80107b41:	c3                   	ret    
80107b42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107b50 <swapOut>:

/// function to take a page from physical memory and put it in the swap file in the disc
void swapOut(int index, struct proc *p){
80107b50:	55                   	push   %ebp

  pte_t* pte = walkpgdir(p->pgdir, p->mem_pages[index].va, 0);
80107b51:	31 c9                	xor    %ecx,%ecx
  }
  return 0;
}

/// function to take a page from physical memory and put it in the swap file in the disc
void swapOut(int index, struct proc *p){
80107b53:	89 e5                	mov    %esp,%ebp
80107b55:	57                   	push   %edi
80107b56:	56                   	push   %esi
80107b57:	53                   	push   %ebx
80107b58:	83 ec 2c             	sub    $0x2c,%esp
80107b5b:	8b 7d 08             	mov    0x8(%ebp),%edi
80107b5e:	8b 75 0c             	mov    0xc(%ebp),%esi

  pte_t* pte = walkpgdir(p->pgdir, p->mem_pages[index].va, 0);
80107b61:	8d 14 7f             	lea    (%edi,%edi,2),%edx
80107b64:	8b 46 04             	mov    0x4(%esi),%eax
80107b67:	8b 94 d6 1c 01 00 00 	mov    0x11c(%esi,%edx,8),%edx
80107b6e:	e8 fd f4 ff ff       	call   80107070 <walkpgdir>
80107b73:	89 45 dc             	mov    %eax,-0x24(%ebp)

  if(!*pte){
80107b76:	8b 00                	mov    (%eax),%eax
80107b78:	85 c0                	test   %eax,%eax
80107b7a:	0f 84 3d 01 00 00    	je     80107cbd <swapOut+0x16d>
  }

  struct swapfile_metadata* sfm;
  int i = 0;
  for(sfm = p->sfm; sfm < &p->sfm[MAX_PSYC_PAGES] ; sfm++){
    if(!sfm->in_swap_file){
80107b80:	80 be 94 00 00 00 00 	cmpb   $0x0,0x94(%esi)
    panic("swapOut");
  }

  struct swapfile_metadata* sfm;
  int i = 0;
  for(sfm = p->sfm; sfm < &p->sfm[MAX_PSYC_PAGES] ; sfm++){
80107b87:	8d 9e 90 00 00 00    	lea    0x90(%esi),%ebx
80107b8d:	8d 96 10 01 00 00    	lea    0x110(%esi),%edx
    if(!sfm->in_swap_file){
80107b93:	0f 84 18 01 00 00    	je     80107cb1 <swapOut+0x161>
80107b99:	31 c0                	xor    %eax,%eax
80107b9b:	eb 09                	jmp    80107ba6 <swapOut+0x56>
80107b9d:	8d 76 00             	lea    0x0(%esi),%esi
80107ba0:	80 7b 04 00          	cmpb   $0x0,0x4(%ebx)
80107ba4:	74 1a                	je     80107bc0 <swapOut+0x70>
    panic("swapOut");
  }

  struct swapfile_metadata* sfm;
  int i = 0;
  for(sfm = p->sfm; sfm < &p->sfm[MAX_PSYC_PAGES] ; sfm++){
80107ba6:	83 c3 08             	add    $0x8,%ebx
    if(!sfm->in_swap_file){
      break;
    }

    i++;
80107ba9:	83 c0 01             	add    $0x1,%eax
    panic("swapOut");
  }

  struct swapfile_metadata* sfm;
  int i = 0;
  for(sfm = p->sfm; sfm < &p->sfm[MAX_PSYC_PAGES] ; sfm++){
80107bac:	39 d3                	cmp    %edx,%ebx
80107bae:	72 f0                	jb     80107ba0 <swapOut+0x50>
  }

  /// if all pages are in use
  if(sfm >= &p->sfm[MAX_PSYC_PAGES]){
    /// TODO panic or change 
    panic("swap file is full");
80107bb0:	83 ec 0c             	sub    $0xc,%esp
80107bb3:	68 24 8b 10 80       	push   $0x80108b24
80107bb8:	e8 b3 87 ff ff       	call   80100370 <panic>
80107bbd:	8d 76 00             	lea    0x0(%esi),%esi
80107bc0:	c1 e0 0c             	shl    $0xc,%eax
80107bc3:	89 45 e0             	mov    %eax,-0x20(%ebp)

  uint placeOnFile = i * PGSIZE;

  int j;
  for(j = 0 ; j < 4 ; j++){
    writeToSwapFile(p, p->mem_pages[index].mem + (j * PGSIZE/4), placeOnFile + (j * PGSIZE/4), PGSIZE/4);
80107bc6:	8d 04 7f             	lea    (%edi,%edi,2),%eax
  }

  struct swapfile_metadata* sfm;
  int i = 0;
  for(sfm = p->sfm; sfm < &p->sfm[MAX_PSYC_PAGES] ; sfm++){
    if(!sfm->in_swap_file){
80107bc9:	31 d2                	xor    %edx,%edx
80107bcb:	89 5d d4             	mov    %ebx,-0x2c(%ebp)

  uint placeOnFile = i * PGSIZE;

  int j;
  for(j = 0 ; j < 4 ; j++){
    writeToSwapFile(p, p->mem_pages[index].mem + (j * PGSIZE/4), placeOnFile + (j * PGSIZE/4), PGSIZE/4);
80107bce:	8d 3c c6             	lea    (%esi,%eax,8),%edi
80107bd1:	89 45 d8             	mov    %eax,-0x28(%ebp)
80107bd4:	89 fb                	mov    %edi,%ebx
80107bd6:	89 d7                	mov    %edx,%edi
80107bd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107bdb:	68 00 04 00 00       	push   $0x400
80107be0:	01 f8                	add    %edi,%eax
80107be2:	50                   	push   %eax
80107be3:	8d 83 20 01 00 00    	lea    0x120(%ebx),%eax
80107be9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107bec:	8b 83 20 01 00 00    	mov    0x120(%ebx),%eax
80107bf2:	01 f8                	add    %edi,%eax
80107bf4:	81 c7 00 04 00 00    	add    $0x400,%edi
80107bfa:	50                   	push   %eax
80107bfb:	56                   	push   %esi
80107bfc:	e8 cf a6 ff ff       	call   801022d0 <writeToSwapFile>
  }

  uint placeOnFile = i * PGSIZE;

  int j;
  for(j = 0 ; j < 4 ; j++){
80107c01:	83 c4 10             	add    $0x10,%esp
80107c04:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
80107c0a:	75 cc                	jne    80107bd8 <swapOut+0x88>
80107c0c:	89 df                	mov    %ebx,%edi
80107c0e:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  /// update the swapfile metadata
  sfm->in_swap_file = 1;
  sfm->va = p->mem_pages[index].va;

  /// free the page from the memory
  kfree(p->mem_pages[index].mem);
80107c11:	83 ec 0c             	sub    $0xc,%esp
  for(j = 0 ; j < 4 ; j++){
    writeToSwapFile(p, p->mem_pages[index].mem + (j * PGSIZE/4), placeOnFile + (j * PGSIZE/4), PGSIZE/4);
  }

  /// update the swapfile metadata
  sfm->in_swap_file = 1;
80107c14:	c6 43 04 01          	movb   $0x1,0x4(%ebx)
  sfm->va = p->mem_pages[index].va;
80107c18:	8b 87 1c 01 00 00    	mov    0x11c(%edi),%eax
80107c1e:	89 03                	mov    %eax,(%ebx)

  /// free the page from the memory
  kfree(p->mem_pages[index].mem);
80107c20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107c23:	ff 30                	pushl  (%eax)
80107c25:	e8 e6 aa ff ff       	call   80102710 <kfree>
  updateMemPagesOnRemove(p->mem_pages[index].va, p);
80107c2a:	8b 45 d8             	mov    -0x28(%ebp),%eax
80107c2d:	8d 96 1c 01 00 00    	lea    0x11c(%esi),%edx
80107c33:	83 c4 10             	add    $0x10,%esp
80107c36:	8b 8c c6 1c 01 00 00 	mov    0x11c(%esi,%eax,8),%ecx
/// update the memory pages data of process according to the specified algorithm
/// on page removal
void updateMemPagesOnRemove(void* va, struct proc *p){
  #if defined(LAPA) || defined(NFUA) || defined(SCFIFO)
    int i;
    for(i = 0; i < MAX_PSYC_PAGES; i++){
80107c3d:	31 c0                	xor    %eax,%eax
80107c3f:	90                   	nop
      if(p->mem_pages[i].va == va){
80107c40:	3b 0a                	cmp    (%edx),%ecx
80107c42:	74 44                	je     80107c88 <swapOut+0x138>
/// update the memory pages data of process according to the specified algorithm
/// on page removal
void updateMemPagesOnRemove(void* va, struct proc *p){
  #if defined(LAPA) || defined(NFUA) || defined(SCFIFO)
    int i;
    for(i = 0; i < MAX_PSYC_PAGES; i++){
80107c44:	83 c0 01             	add    $0x1,%eax
80107c47:	83 c2 18             	add    $0x18,%edx
80107c4a:	83 f8 10             	cmp    $0x10,%eax
80107c4d:	75 f1                	jne    80107c40 <swapOut+0xf0>
  /// update stats
  p->num_of_currently_swapped_out_pages++;
  p->num_of_total_swap_out_actions++;

  /// making flags that pages swapped out and not present
  *pte = (*pte | PTE_PG) & ~PTE_P;
80107c4f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  /// free the page from the memory
  kfree(p->mem_pages[index].mem);
  updateMemPagesOnRemove(p->mem_pages[index].va, p);

  /// update stats
  p->num_of_currently_swapped_out_pages++;
80107c52:	83 86 84 00 00 00 01 	addl   $0x1,0x84(%esi)
  p->num_of_total_swap_out_actions++;
80107c59:	83 86 88 00 00 00 01 	addl   $0x1,0x88(%esi)

  /// making flags that pages swapped out and not present
  *pte = (*pte | PTE_PG) & ~PTE_P;
80107c60:	8b 01                	mov    (%ecx),%eax
80107c62:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107c65:	25 fe fd ff ff       	and    $0xfffffdfe,%eax
80107c6a:	80 cc 02             	or     $0x2,%ah
80107c6d:	89 01                	mov    %eax,(%ecx)
80107c6f:	8b 46 04             	mov    0x4(%esi),%eax
80107c72:	05 00 00 00 80       	add    $0x80000000,%eax
80107c77:	0f 22 d8             	mov    %eax,%cr3

  /// refresh the TLB
  lcr3(V2P(p->pgdir));  

 // printDebugMem(p);
}
80107c7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c7d:	5b                   	pop    %ebx
80107c7e:	5e                   	pop    %esi
80107c7f:	5f                   	pop    %edi
80107c80:	5d                   	pop    %ebp
80107c81:	c3                   	ret    
80107c82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

    if(i == MAX_PSYC_PAGES){
      return;
    }

    if (p->mem_pages[i].in_mem == 1){
80107c88:	8d 04 40             	lea    (%eax,%eax,2),%eax
80107c8b:	8d 04 c6             	lea    (%esi,%eax,8),%eax
80107c8e:	80 b8 24 01 00 00 01 	cmpb   $0x1,0x124(%eax)
80107c95:	75 b8                	jne    80107c4f <swapOut+0xff>
      p->mem_pages[i].in_mem = 0;
80107c97:	c6 80 24 01 00 00 00 	movb   $0x0,0x124(%eax)
      p->mem_pages[i].va = 0;
80107c9e:	c7 80 1c 01 00 00 00 	movl   $0x0,0x11c(%eax)
80107ca5:	00 00 00 
      p->num_of_pages_in_memory--;
80107ca8:	83 ae 80 00 00 00 01 	subl   $0x1,0x80(%esi)
80107caf:	eb 9e                	jmp    80107c4f <swapOut+0xff>
  }

  struct swapfile_metadata* sfm;
  int i = 0;
  for(sfm = p->sfm; sfm < &p->sfm[MAX_PSYC_PAGES] ; sfm++){
    if(!sfm->in_swap_file){
80107cb1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107cb8:	e9 09 ff ff ff       	jmp    80107bc6 <swapOut+0x76>
void swapOut(int index, struct proc *p){

  pte_t* pte = walkpgdir(p->pgdir, p->mem_pages[index].va, 0);

  if(!*pte){
    panic("swapOut");
80107cbd:	83 ec 0c             	sub    $0xc,%esp
80107cc0:	68 1c 8b 10 80       	push   $0x80108b1c
80107cc5:	e8 a6 86 ff ff       	call   80100370 <panic>
80107cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107cd0 <swapIn>:
  lcr3(V2P(p->pgdir));  

 // printDebugMem(p);
}

void swapIn(void* va, struct proc *p){
80107cd0:	55                   	push   %ebp
80107cd1:	89 e5                	mov    %esp,%ebp
80107cd3:	57                   	push   %edi
80107cd4:	56                   	push   %esi
80107cd5:	53                   	push   %ebx
  struct swapfile_metadata* sfm;

  int i = 0;
  for(sfm = p->sfm; sfm < &p->sfm[MAX_PSYC_PAGES] ; sfm++){
80107cd6:	31 f6                	xor    %esi,%esi
  lcr3(V2P(p->pgdir));  

 // printDebugMem(p);
}

void swapIn(void* va, struct proc *p){
80107cd8:	83 ec 1c             	sub    $0x1c,%esp
80107cdb:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct swapfile_metadata* sfm;

  int i = 0;
  for(sfm = p->sfm; sfm < &p->sfm[MAX_PSYC_PAGES] ; sfm++){
80107cde:	8b 55 08             	mov    0x8(%ebp),%edx
80107ce1:	8d 9f 90 00 00 00    	lea    0x90(%edi),%ebx
80107ce7:	8d 87 10 01 00 00    	lea    0x110(%edi),%eax
80107ced:	8d 76 00             	lea    0x0(%esi),%esi
    if(sfm->in_swap_file && sfm->va == va){
80107cf0:	80 7b 04 00          	cmpb   $0x0,0x4(%ebx)
80107cf4:	74 04                	je     80107cfa <swapIn+0x2a>
80107cf6:	39 13                	cmp    %edx,(%ebx)
80107cf8:	74 1e                	je     80107d18 <swapIn+0x48>

void swapIn(void* va, struct proc *p){
  struct swapfile_metadata* sfm;

  int i = 0;
  for(sfm = p->sfm; sfm < &p->sfm[MAX_PSYC_PAGES] ; sfm++){
80107cfa:	83 c3 08             	add    $0x8,%ebx
    if(sfm->in_swap_file && sfm->va == va){
      break;
    }

    i++;
80107cfd:	83 c6 01             	add    $0x1,%esi

void swapIn(void* va, struct proc *p){
  struct swapfile_metadata* sfm;

  int i = 0;
  for(sfm = p->sfm; sfm < &p->sfm[MAX_PSYC_PAGES] ; sfm++){
80107d00:	39 c3                	cmp    %eax,%ebx
80107d02:	72 ec                	jb     80107cf0 <swapIn+0x20>
    i++;
  }

  if(sfm >= &p->sfm[MAX_PSYC_PAGES]){
    /// TODO panic or change 
    panic("the requested page is not in the swapfile");
80107d04:	83 ec 0c             	sub    $0xc,%esp
80107d07:	68 54 8c 10 80       	push   $0x80108c54
80107d0c:	e8 5f 86 ff ff       	call   80100370 <panic>
80107d11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }

    i++;
  }

  if(sfm >= &p->sfm[MAX_PSYC_PAGES]){
80107d18:	39 c3                	cmp    %eax,%ebx
80107d1a:	73 e8                	jae    80107d04 <swapIn+0x34>
    /// TODO panic or change 
    panic("the requested page is not in the swapfile");
  }

  pte_t* pte = walkpgdir(p->pgdir, va, 1);
80107d1c:	8b 47 04             	mov    0x4(%edi),%eax
80107d1f:	8b 55 08             	mov    0x8(%ebp),%edx
80107d22:	b9 01 00 00 00       	mov    $0x1,%ecx
80107d27:	e8 44 f3 ff ff       	call   80107070 <walkpgdir>
80107d2c:	89 45 d8             	mov    %eax,-0x28(%ebp)

  if(!*pte){
80107d2f:	8b 00                	mov    (%eax),%eax
80107d31:	85 c0                	test   %eax,%eax
80107d33:	74 7f                	je     80107db4 <swapIn+0xe4>
    panic("swapIn");
  }

  /// allocate the page into the memory
  char* newMem = kalloc();
  uint placeOnFile = i * PGSIZE;
80107d35:	c1 e6 0c             	shl    $0xc,%esi
  if(!*pte){
    panic("swapIn");
  }

  /// allocate the page into the memory
  char* newMem = kalloc();
80107d38:	e8 c3 ab ff ff       	call   80102900 <kalloc>
80107d3d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107d40:	8d 86 00 10 00 00    	lea    0x1000(%esi),%eax
  uint placeOnFile = i * PGSIZE;
80107d46:	89 75 e0             	mov    %esi,-0x20(%ebp)
80107d49:	89 45 dc             	mov    %eax,-0x24(%ebp)

  int j;
  for(j = 0 ; j < 4 ; j++){
    readFromSwapFile(p, newMem + (j * PGSIZE/4), placeOnFile + (j * PGSIZE/4), PGSIZE/4);
80107d4c:	89 f0                	mov    %esi,%eax
80107d4e:	2b 45 e0             	sub    -0x20(%ebp),%eax
80107d51:	68 00 04 00 00       	push   $0x400
80107d56:	03 45 e4             	add    -0x1c(%ebp),%eax
80107d59:	56                   	push   %esi
80107d5a:	81 c6 00 04 00 00    	add    $0x400,%esi
80107d60:	50                   	push   %eax
80107d61:	57                   	push   %edi
80107d62:	e8 99 a5 ff ff       	call   80102300 <readFromSwapFile>
  /// allocate the page into the memory
  char* newMem = kalloc();
  uint placeOnFile = i * PGSIZE;

  int j;
  for(j = 0 ; j < 4 ; j++){
80107d67:	83 c4 10             	add    $0x10,%esp
80107d6a:	3b 75 dc             	cmp    -0x24(%ebp),%esi
80107d6d:	75 dd                	jne    80107d4c <swapIn+0x7c>
    readFromSwapFile(p, newMem + (j * PGSIZE/4), placeOnFile + (j * PGSIZE/4), PGSIZE/4);
  }

  /// making flags that pages swapped in and present
  *pte = (V2P(newMem) | PTE_P | PTE_U | PTE_W) & ~PTE_PG;
80107d6f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107d72:	8b 4d d8             	mov    -0x28(%ebp),%ecx

  /// update the swapfile metadata
  sfm->in_swap_file = 0;

  /// ****** TODO ***** check if its newVA or startOfVApage
  updateMemPages(va, newMem, p);
80107d75:	83 ec 04             	sub    $0x4,%esp
  for(j = 0 ; j < 4 ; j++){
    readFromSwapFile(p, newMem + (j * PGSIZE/4), placeOnFile + (j * PGSIZE/4), PGSIZE/4);
  }

  /// making flags that pages swapped in and present
  *pte = (V2P(newMem) | PTE_P | PTE_U | PTE_W) & ~PTE_PG;
80107d78:	89 d0                	mov    %edx,%eax
80107d7a:	05 00 00 00 80       	add    $0x80000000,%eax
80107d7f:	25 f8 fd ff ff       	and    $0xfffffdf8,%eax
80107d84:	83 c8 07             	or     $0x7,%eax
80107d87:	89 01                	mov    %eax,(%ecx)

  /// update the swapfile metadata
  sfm->in_swap_file = 0;
80107d89:	c6 43 04 00          	movb   $0x0,0x4(%ebx)

  /// ****** TODO ***** check if its newVA or startOfVApage
  updateMemPages(va, newMem, p);
80107d8d:	57                   	push   %edi
80107d8e:	52                   	push   %edx
80107d8f:	ff 75 08             	pushl  0x8(%ebp)
80107d92:	e8 b9 f5 ff ff       	call   80107350 <updateMemPages>
80107d97:	8b 47 04             	mov    0x4(%edi),%eax

  /// update stats
  p->num_of_currently_swapped_out_pages--;
80107d9a:	83 af 84 00 00 00 01 	subl   $0x1,0x84(%edi)
80107da1:	05 00 00 00 80       	add    $0x80000000,%eax
80107da6:	0f 22 d8             	mov    %eax,%cr3

  /// refresh the TLB
  lcr3(V2P(p->pgdir));
}
80107da9:	83 c4 10             	add    $0x10,%esp
80107dac:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107daf:	5b                   	pop    %ebx
80107db0:	5e                   	pop    %esi
80107db1:	5f                   	pop    %edi
80107db2:	5d                   	pop    %ebp
80107db3:	c3                   	ret    
  }

  pte_t* pte = walkpgdir(p->pgdir, va, 1);

  if(!*pte){
    panic("swapIn");
80107db4:	83 ec 0c             	sub    $0xc,%esp
80107db7:	68 36 8b 10 80       	push   $0x80108b36
80107dbc:	e8 af 85 ff ff       	call   80100370 <panic>
80107dc1:	eb 0d                	jmp    80107dd0 <selectPageToSwapOut>
80107dc3:	90                   	nop
80107dc4:	90                   	nop
80107dc5:	90                   	nop
80107dc6:	90                   	nop
80107dc7:	90                   	nop
80107dc8:	90                   	nop
80107dc9:	90                   	nop
80107dca:	90                   	nop
80107dcb:	90                   	nop
80107dcc:	90                   	nop
80107dcd:	90                   	nop
80107dce:	90                   	nop
80107dcf:	90                   	nop

80107dd0 <selectPageToSwapOut>:
  /// refresh the TLB
  lcr3(V2P(p->pgdir));
}

/// return virtual address of the page to swap out
int selectPageToSwapOut(struct proc *p){
80107dd0:	55                   	push   %ebp
  #ifdef NFUA
  int i;
  uint minAge = 0xffffffff;
  
    //printDebugMem(p);
  for(i = 0 ; i < MAX_PSYC_PAGES ; i++){
80107dd1:	31 c9                	xor    %ecx,%ecx
  /// refresh the TLB
  lcr3(V2P(p->pgdir));
}

/// return virtual address of the page to swap out
int selectPageToSwapOut(struct proc *p){
80107dd3:	89 e5                	mov    %esp,%ebp
80107dd5:	57                   	push   %edi
80107dd6:	56                   	push   %esi
80107dd7:	53                   	push   %ebx

  int minIndex = -1;

  #ifdef NFUA
  int i;
  uint minAge = 0xffffffff;
80107dd8:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  /// refresh the TLB
  lcr3(V2P(p->pgdir));
}

/// return virtual address of the page to swap out
int selectPageToSwapOut(struct proc *p){
80107ddd:	83 ec 1c             	sub    $0x1c,%esp
80107de0:	8b 75 08             	mov    0x8(%ebp),%esi

  int minIndex = -1;
80107de3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
80107dea:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107ded:	8d 96 24 01 00 00    	lea    0x124(%esi),%edx
80107df3:	eb 34                	jmp    80107e29 <selectPageToSwapOut+0x59>
80107df5:	8d 76 00             	lea    0x0(%esi),%esi
    if(!p->mem_pages[i].in_mem ){
      panic("should not swap out if there is room in memory");
    }

    pte_t* pte = walkpgdir_noalloc(p->pgdir, p->mem_pages[i].va);
    if(!(*pte & PTE_U)){
80107df8:	c1 e8 0c             	shr    $0xc,%eax
80107dfb:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107e01:	25 ff 03 00 00       	and    $0x3ff,%eax
80107e06:	f6 84 83 00 00 00 80 	testb  $0x4,-0x80000000(%ebx,%eax,4)
80107e0d:	04 
80107e0e:	74 0e                	je     80107e1e <selectPageToSwapOut+0x4e>
    
    /// check if the page is of the kernel
    //if((uint) p->mem_pages[i].va < (uint) end)
    //    continue;
    
    if(p->mem_pages[i].aging <= minAge){
80107e10:	8b 42 f4             	mov    -0xc(%edx),%eax
80107e13:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
80107e16:	77 06                	ja     80107e1e <selectPageToSwapOut+0x4e>
80107e18:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107e1b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  #ifdef NFUA
  int i;
  uint minAge = 0xffffffff;
  
    //printDebugMem(p);
  for(i = 0 ; i < MAX_PSYC_PAGES ; i++){
80107e1e:	83 c1 01             	add    $0x1,%ecx
80107e21:	83 c2 18             	add    $0x18,%edx
80107e24:	83 f9 10             	cmp    $0x10,%ecx
80107e27:	74 27                	je     80107e50 <selectPageToSwapOut+0x80>
    if(!p->mem_pages[i].in_mem ){
80107e29:	80 3a 00             	cmpb   $0x0,(%edx)
80107e2c:	74 33                	je     80107e61 <selectPageToSwapOut+0x91>

pte_t* walkpgdir_noalloc(pde_t *pgdir, const void *va){
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107e2e:	8b 42 f8             	mov    -0x8(%edx),%eax
  if(*pde & PTE_P){
80107e31:	8b 5e 04             	mov    0x4(%esi),%ebx
80107e34:	89 c7                	mov    %eax,%edi
80107e36:	c1 ef 16             	shr    $0x16,%edi
80107e39:	8b 1c bb             	mov    (%ebx,%edi,4),%ebx
80107e3c:	f6 c3 01             	test   $0x1,%bl
80107e3f:	75 b7                	jne    80107df8 <selectPageToSwapOut+0x28>
    if(!p->mem_pages[i].in_mem ){
      panic("should not swap out if there is room in memory");
    }

    pte_t* pte = walkpgdir_noalloc(p->pgdir, p->mem_pages[i].va);
    if(!(*pte & PTE_U)){
80107e41:	a1 00 00 00 00       	mov    0x0,%eax
80107e46:	0f 0b                	ud2    
80107e48:	90                   	nop
80107e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }

    minIndex = i;
  #endif

  if(minIndex == -1){
80107e50:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
80107e54:	74 18                	je     80107e6e <selectPageToSwapOut+0x9e>
    panic("no page was chosen to be swapped out");
  }

  return minIndex;
}
80107e56:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107e59:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107e5c:	5b                   	pop    %ebx
80107e5d:	5e                   	pop    %esi
80107e5e:	5f                   	pop    %edi
80107e5f:	5d                   	pop    %ebp
80107e60:	c3                   	ret    
  uint minAge = 0xffffffff;
  
    //printDebugMem(p);
  for(i = 0 ; i < MAX_PSYC_PAGES ; i++){
    if(!p->mem_pages[i].in_mem ){
      panic("should not swap out if there is room in memory");
80107e61:	83 ec 0c             	sub    $0xc,%esp
80107e64:	68 80 8c 10 80       	push   $0x80108c80
80107e69:	e8 02 85 ff ff       	call   80100370 <panic>

    minIndex = i;
  #endif

  if(minIndex == -1){
    panic("no page was chosen to be swapped out");
80107e6e:	83 ec 0c             	sub    $0xc,%esp
80107e71:	68 b0 8c 10 80       	push   $0x80108cb0
80107e76:	e8 f5 84 ff ff       	call   80100370 <panic>
80107e7b:	90                   	nop
80107e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107e80 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107e80:	55                   	push   %ebp
80107e81:	89 e5                	mov    %esp,%ebp
80107e83:	57                   	push   %edi
80107e84:	56                   	push   %esi
80107e85:	53                   	push   %ebx
80107e86:	83 ec 1c             	sub    $0x1c,%esp
80107e89:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80107e8c:	85 ff                	test   %edi,%edi
80107e8e:	0f 88 3a 01 00 00    	js     80107fce <allocuvm+0x14e>
    return 0;
  if(newsz < oldsz)
80107e94:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80107e97:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
80107e9a:	0f 82 f4 00 00 00    	jb     80107f94 <allocuvm+0x114>
    return oldsz;

  a = PGROUNDUP(oldsz);
80107ea0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107ea6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80107eac:	39 df                	cmp    %ebx,%edi
80107eae:	77 29                	ja     80107ed9 <allocuvm+0x59>
80107eb0:	e9 2b 01 00 00       	jmp    80107fe0 <allocuvm+0x160>
80107eb5:	8d 76 00             	lea    0x0(%esi),%esi
        if(myproc()->num_of_pages_in_memory == MAX_PSYC_PAGES){

          int swapOutIndex = selectPageToSwapOut(myproc());
          swapOut(swapOutIndex, myproc());
        }
        updateMemPages((void*) a, mem, myproc());
80107eb8:	e8 c3 bd ff ff       	call   80103c80 <myproc>
80107ebd:	83 ec 04             	sub    $0x4,%esp
80107ec0:	50                   	push   %eax
80107ec1:	56                   	push   %esi
80107ec2:	53                   	push   %ebx
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107ec3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
        if(myproc()->num_of_pages_in_memory == MAX_PSYC_PAGES){

          int swapOutIndex = selectPageToSwapOut(myproc());
          swapOut(swapOutIndex, myproc());
        }
        updateMemPages((void*) a, mem, myproc());
80107ec9:	e8 82 f4 ff ff       	call   80107350 <updateMemPages>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107ece:	83 c4 10             	add    $0x10,%esp
80107ed1:	39 df                	cmp    %ebx,%edi
80107ed3:	0f 86 07 01 00 00    	jbe    80107fe0 <allocuvm+0x160>
    mem = kalloc();
80107ed9:	e8 22 aa ff ff       	call   80102900 <kalloc>
    if(mem == 0){
80107ede:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
80107ee0:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107ee2:	0f 84 88 00 00 00    	je     80107f70 <allocuvm+0xf0>
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80107ee8:	83 ec 04             	sub    $0x4,%esp
80107eeb:	68 00 10 00 00       	push   $0x1000
80107ef0:	6a 00                	push   $0x0
80107ef2:	50                   	push   %eax
80107ef3:	e8 38 cf ff ff       	call   80104e30 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107ef8:	58                   	pop    %eax
80107ef9:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107eff:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107f04:	5a                   	pop    %edx
80107f05:	6a 06                	push   $0x6
80107f07:	50                   	push   %eax
80107f08:	89 da                	mov    %ebx,%edx
80107f0a:	8b 45 08             	mov    0x8(%ebp),%eax
80107f0d:	e8 de f1 ff ff       	call   801070f0 <mappages>
80107f12:	83 c4 10             	add    $0x10,%esp
80107f15:	85 c0                	test   %eax,%eax
80107f17:	0f 88 83 00 00 00    	js     80107fa0 <allocuvm+0x120>


    #ifndef NONE
      //if((strcmp(myproc()->name, "init") && strcmp(myproc()->name, "sh"))){

        if(myproc()->num_of_pages_in_memory > MAX_PSYC_PAGES){
80107f1d:	e8 5e bd ff ff       	call   80103c80 <myproc>
80107f22:	83 b8 80 00 00 00 10 	cmpl   $0x10,0x80(%eax)
80107f29:	0f 8f bb 00 00 00    	jg     80107fea <allocuvm+0x16a>
          panic("too many pages in memory, allocuvm");
        }

        /// check if there is enough memory for page
        if(myproc()->num_of_pages_in_memory == MAX_PSYC_PAGES){
80107f2f:	e8 4c bd ff ff       	call   80103c80 <myproc>
80107f34:	83 b8 80 00 00 00 10 	cmpl   $0x10,0x80(%eax)
80107f3b:	0f 85 77 ff ff ff    	jne    80107eb8 <allocuvm+0x38>

          int swapOutIndex = selectPageToSwapOut(myproc());
80107f41:	e8 3a bd ff ff       	call   80103c80 <myproc>
80107f46:	83 ec 0c             	sub    $0xc,%esp
80107f49:	50                   	push   %eax
80107f4a:	e8 81 fe ff ff       	call   80107dd0 <selectPageToSwapOut>
80107f4f:	83 c4 10             	add    $0x10,%esp
80107f52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
          swapOut(swapOutIndex, myproc());
80107f55:	e8 26 bd ff ff       	call   80103c80 <myproc>
80107f5a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107f5d:	83 ec 08             	sub    $0x8,%esp
80107f60:	50                   	push   %eax
80107f61:	52                   	push   %edx
80107f62:	e8 e9 fb ff ff       	call   80107b50 <swapOut>
80107f67:	83 c4 10             	add    $0x10,%esp
80107f6a:	e9 49 ff ff ff       	jmp    80107eb8 <allocuvm+0x38>
80107f6f:	90                   	nop

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
80107f70:	83 ec 0c             	sub    $0xc,%esp
80107f73:	68 3d 8b 10 80       	push   $0x80108b3d
80107f78:	e8 e3 86 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80107f7d:	83 c4 10             	add    $0x10,%esp
80107f80:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107f83:	76 49                	jbe    80107fce <allocuvm+0x14e>
80107f85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107f88:	8b 45 08             	mov    0x8(%ebp),%eax
80107f8b:	89 fa                	mov    %edi,%edx
80107f8d:	e8 ee f1 ff ff       	call   80107180 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80107f92:	31 c0                	xor    %eax,%eax


  }

  return newsz;
}
80107f94:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f97:	5b                   	pop    %ebx
80107f98:	5e                   	pop    %esi
80107f99:	5f                   	pop    %edi
80107f9a:	5d                   	pop    %ebp
80107f9b:	c3                   	ret    
80107f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80107fa0:	83 ec 0c             	sub    $0xc,%esp
80107fa3:	68 55 8b 10 80       	push   $0x80108b55
80107fa8:	e8 b3 86 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80107fad:	83 c4 10             	add    $0x10,%esp
80107fb0:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107fb3:	76 0d                	jbe    80107fc2 <allocuvm+0x142>
80107fb5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107fb8:	8b 45 08             	mov    0x8(%ebp),%eax
80107fbb:	89 fa                	mov    %edi,%edx
80107fbd:	e8 be f1 ff ff       	call   80107180 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80107fc2:	83 ec 0c             	sub    $0xc,%esp
80107fc5:	56                   	push   %esi
80107fc6:	e8 45 a7 ff ff       	call   80102710 <kfree>
      return 0;
80107fcb:	83 c4 10             	add    $0x10,%esp


  }

  return newsz;
}
80107fce:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80107fd1:	31 c0                	xor    %eax,%eax


  }

  return newsz;
}
80107fd3:	5b                   	pop    %ebx
80107fd4:	5e                   	pop    %esi
80107fd5:	5f                   	pop    %edi
80107fd6:	5d                   	pop    %ebp
80107fd7:	c3                   	ret    
80107fd8:	90                   	nop
80107fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107fe0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80107fe3:	89 f8                	mov    %edi,%eax


  }

  return newsz;
}
80107fe5:	5b                   	pop    %ebx
80107fe6:	5e                   	pop    %esi
80107fe7:	5f                   	pop    %edi
80107fe8:	5d                   	pop    %ebp
80107fe9:	c3                   	ret    

    #ifndef NONE
      //if((strcmp(myproc()->name, "init") && strcmp(myproc()->name, "sh"))){

        if(myproc()->num_of_pages_in_memory > MAX_PSYC_PAGES){
          panic("too many pages in memory, allocuvm");
80107fea:	83 ec 0c             	sub    $0xc,%esp
80107fed:	68 d8 8c 10 80       	push   $0x80108cd8
80107ff2:	e8 79 83 ff ff       	call   80100370 <panic>
