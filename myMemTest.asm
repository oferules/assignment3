
_myMemTest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#define PGSIZE 4096    // bytes mapped by a page
#define SLEEP 0
#define NUM_OF_PAGES 18
int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	8d 75 a0             	lea    -0x60(%ebp),%esi
  13:	8d 5d c4             	lea    -0x3c(%ebp),%ebx
  16:	83 ec 64             	sub    $0x64,%esp
    int i; 
    printf (1, "mem tests\n");
  19:	68 a0 08 00 00       	push   $0x8a0
  1e:	6a 01                	push   $0x1
  20:	e8 5b 05 00 00       	call   580 <printf>

    printf (1, "\nafter exec suppose to have more than 2 pages.\nsleeping, press ^P!\n\n");
  25:	58                   	pop    %eax
  26:	5a                   	pop    %edx
  27:	68 1c 09 00 00       	push   $0x91c
  2c:	6a 01                	push   $0x1
  2e:	e8 4d 05 00 00       	call   580 <printf>
    sleep(SLEEP);
  33:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  3a:	e8 83 04 00 00       	call   4c2 <sleep>

    char *pages[NUM_OF_PAGES];
    
    /// allocate NUM_OF_PAGES pages
    printf (1, "\nallocate %d pages",NUM_OF_PAGES/2);
  3f:	83 c4 0c             	add    $0xc,%esp
  42:	6a 09                	push   $0x9
  44:	68 ab 08 00 00       	push   $0x8ab
  49:	6a 01                	push   $0x1
  4b:	e8 30 05 00 00       	call   580 <printf>
  50:	83 c4 10             	add    $0x10,%esp
  53:	90                   	nop
  54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for (i= 0 ; i< NUM_OF_PAGES/2 ; i++){
        pages[i] = sbrk(PGSIZE);
  58:	83 ec 0c             	sub    $0xc,%esp
  5b:	83 c6 04             	add    $0x4,%esi
  5e:	68 00 10 00 00       	push   $0x1000
  63:	e8 52 04 00 00       	call   4ba <sbrk>
  68:	89 46 fc             	mov    %eax,-0x4(%esi)

    char *pages[NUM_OF_PAGES];
    
    /// allocate NUM_OF_PAGES pages
    printf (1, "\nallocate %d pages",NUM_OF_PAGES/2);
    for (i= 0 ; i< NUM_OF_PAGES/2 ; i++){
  6b:	83 c4 10             	add    $0x10,%esp
  6e:	39 f3                	cmp    %esi,%ebx
  70:	75 e6                	jne    58 <main+0x58>
        pages[i] = sbrk(PGSIZE);
    }
    printf (1, "\nsleeping, press ^P!\n\n");
  72:	83 ec 08             	sub    $0x8,%esp
  75:	8d 75 e8             	lea    -0x18(%ebp),%esi
  78:	68 be 08 00 00       	push   $0x8be
  7d:	6a 01                	push   $0x1
  7f:	e8 fc 04 00 00       	call   580 <printf>
    sleep(SLEEP);
  84:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8b:	e8 32 04 00 00       	call   4c2 <sleep>

    printf (1, "\nallocate %d pages",NUM_OF_PAGES/2);
  90:	83 c4 0c             	add    $0xc,%esp
  93:	6a 09                	push   $0x9
  95:	68 ab 08 00 00       	push   $0x8ab
  9a:	6a 01                	push   $0x1
  9c:	e8 df 04 00 00       	call   580 <printf>
  a1:	83 c4 10             	add    $0x10,%esp
  a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for (i= NUM_OF_PAGES/2 ; i< NUM_OF_PAGES ; i++){
        pages[i] = sbrk(PGSIZE);
  a8:	83 ec 0c             	sub    $0xc,%esp
  ab:	83 c3 04             	add    $0x4,%ebx
  ae:	68 00 10 00 00       	push   $0x1000
  b3:	e8 02 04 00 00       	call   4ba <sbrk>
  b8:	89 43 fc             	mov    %eax,-0x4(%ebx)
    }
    printf (1, "\nsleeping, press ^P!\n\n");
    sleep(SLEEP);

    printf (1, "\nallocate %d pages",NUM_OF_PAGES/2);
    for (i= NUM_OF_PAGES/2 ; i< NUM_OF_PAGES ; i++){
  bb:	83 c4 10             	add    $0x10,%esp
  be:	39 de                	cmp    %ebx,%esi
  c0:	75 e6                	jne    a8 <main+0xa8>
        pages[i] = sbrk(PGSIZE);
    }
    
    printf (1, "\nfinished allocating %d pages\n", NUM_OF_PAGES);
  c2:	83 ec 04             	sub    $0x4,%esp
    printf (1, "\nsleeping, press ^P!\n\n");
    sleep(SLEEP);
    
    for(i = 0 ; i < NUM_OF_PAGES ; i++){
  c5:	31 db                	xor    %ebx,%ebx
    printf (1, "\nallocate %d pages",NUM_OF_PAGES/2);
    for (i= NUM_OF_PAGES/2 ; i< NUM_OF_PAGES ; i++){
        pages[i] = sbrk(PGSIZE);
    }
    
    printf (1, "\nfinished allocating %d pages\n", NUM_OF_PAGES);
  c7:	6a 12                	push   $0x12
  c9:	68 64 09 00 00       	push   $0x964
  ce:	6a 01                	push   $0x1
  d0:	e8 ab 04 00 00       	call   580 <printf>
    printf (1, "\nsleeping, press ^P!\n\n");
  d5:	5e                   	pop    %esi
  d6:	58                   	pop    %eax
  d7:	68 be 08 00 00       	push   $0x8be
  dc:	6a 01                	push   $0x1
  de:	e8 9d 04 00 00       	call   580 <printf>
    sleep(SLEEP);
  e3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  ea:	e8 d3 03 00 00       	call   4c2 <sleep>
  ef:	83 c4 10             	add    $0x10,%esp
  f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    
    for(i = 0 ; i < NUM_OF_PAGES ; i++){
        printf(1, "accessing page: %d\n", i);
  f8:	83 ec 04             	sub    $0x4,%esp
  fb:	53                   	push   %ebx
  fc:	68 e7 08 00 00       	push   $0x8e7
 101:	6a 01                	push   $0x1
 103:	e8 78 04 00 00       	call   580 <printf>
        pages[i][3] = 12;
 108:	8b 44 9d a0          	mov    -0x60(%ebp,%ebx,4),%eax
    
    printf (1, "\nfinished allocating %d pages\n", NUM_OF_PAGES);
    printf (1, "\nsleeping, press ^P!\n\n");
    sleep(SLEEP);
    
    for(i = 0 ; i < NUM_OF_PAGES ; i++){
 10c:	83 c3 01             	add    $0x1,%ebx
 10f:	83 c4 10             	add    $0x10,%esp
 112:	83 fb 12             	cmp    $0x12,%ebx
        printf(1, "accessing page: %d\n", i);
        pages[i][3] = 12;
 115:	c6 40 03 0c          	movb   $0xc,0x3(%eax)
    
    printf (1, "\nfinished allocating %d pages\n", NUM_OF_PAGES);
    printf (1, "\nsleeping, press ^P!\n\n");
    sleep(SLEEP);
    
    for(i = 0 ; i < NUM_OF_PAGES ; i++){
 119:	75 dd                	jne    f8 <main+0xf8>
    // for(i = 17 ; i >= 0 ; i--){
    //     printf(1, "\nacceing page: %d (decsending)\n", i);
    //     *pages[i] = 12;
    // }

    printf (1, "\nsleeping, press ^P!\n\n");
 11b:	83 ec 08             	sub    $0x8,%esp
 11e:	68 be 08 00 00       	push   $0x8be
 123:	6a 01                	push   $0x1
 125:	e8 56 04 00 00       	call   580 <printf>
    sleep(SLEEP);
 12a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 131:	e8 8c 03 00 00       	call   4c2 <sleep>
    
    printf (1, "\nfork test\n");
 136:	59                   	pop    %ecx
 137:	5b                   	pop    %ebx
 138:	68 d5 08 00 00       	push   $0x8d5
 13d:	6a 01                	push   $0x1
 13f:	e8 3c 04 00 00       	call   580 <printf>
    
    int pid = fork();
 144:	e8 e1 02 00 00       	call   42a <fork>
    if (pid==0){
 149:	83 c4 10             	add    $0x10,%esp
 14c:	85 c0                	test   %eax,%eax
 14e:	0f 85 84 00 00 00    	jne    1d8 <main+0x1d8>
        printf (1, "\nchild suppose to have same memory as father but different statistics\n");
 154:	56                   	push   %esi
 155:	56                   	push   %esi
        printf (1, "\nsleeping, press ^P!\n\n");
        sleep(SLEEP);
        
        for(i = 0 ; i < NUM_OF_PAGES ; i++){
 156:	31 db                	xor    %ebx,%ebx
    
    printf (1, "\nfork test\n");
    
    int pid = fork();
    if (pid==0){
        printf (1, "\nchild suppose to have same memory as father but different statistics\n");
 158:	68 84 09 00 00       	push   $0x984
 15d:	6a 01                	push   $0x1
 15f:	e8 1c 04 00 00       	call   580 <printf>
        printf (1, "\nsleeping, press ^P!\n\n");
 164:	58                   	pop    %eax
 165:	5a                   	pop    %edx
 166:	68 be 08 00 00       	push   $0x8be
 16b:	6a 01                	push   $0x1
 16d:	e8 0e 04 00 00       	call   580 <printf>
        sleep(SLEEP);
 172:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 179:	e8 44 03 00 00       	call   4c2 <sleep>
 17e:	83 c4 10             	add    $0x10,%esp
 181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        
        for(i = 0 ; i < NUM_OF_PAGES ; i++){
            printf(1, "child accessing page: %d\n", i);
 188:	83 ec 04             	sub    $0x4,%esp
 18b:	53                   	push   %ebx
 18c:	68 e1 08 00 00       	push   $0x8e1
 191:	6a 01                	push   $0x1
 193:	e8 e8 03 00 00       	call   580 <printf>
            pages[i][3] = 12;
 198:	8b 44 9d a0          	mov    -0x60(%ebp,%ebx,4),%eax
    if (pid==0){
        printf (1, "\nchild suppose to have same memory as father but different statistics\n");
        printf (1, "\nsleeping, press ^P!\n\n");
        sleep(SLEEP);
        
        for(i = 0 ; i < NUM_OF_PAGES ; i++){
 19c:	83 c3 01             	add    $0x1,%ebx
 19f:	83 c4 10             	add    $0x10,%esp
 1a2:	83 fb 12             	cmp    $0x12,%ebx
            printf(1, "child accessing page: %d\n", i);
            pages[i][3] = 12;
 1a5:	c6 40 03 0c          	movb   $0xc,0x3(%eax)
    if (pid==0){
        printf (1, "\nchild suppose to have same memory as father but different statistics\n");
        printf (1, "\nsleeping, press ^P!\n\n");
        sleep(SLEEP);
        
        for(i = 0 ; i < NUM_OF_PAGES ; i++){
 1a9:	75 dd                	jne    188 <main+0x188>
            printf(1, "child accessing page: %d\n", i);
            pages[i][3] = 12;
        }
        printf (1, "\nsleeping, press ^P!\n\n");
 1ab:	52                   	push   %edx
 1ac:	52                   	push   %edx
 1ad:	68 be 08 00 00       	push   $0x8be
 1b2:	6a 01                	push   $0x1
 1b4:	e8 c7 03 00 00       	call   580 <printf>
        sleep(SLEEP);
 1b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1c0:	e8 fd 02 00 00       	call   4c2 <sleep>
        
        printf (1, "\nchild exit!\n");
 1c5:	59                   	pop    %ecx
 1c6:	5b                   	pop    %ebx
 1c7:	68 fb 08 00 00       	push   $0x8fb
 1cc:	6a 01                	push   $0x1
 1ce:	e8 ad 03 00 00       	call   580 <printf>
        exit();
 1d3:	e8 5a 02 00 00       	call   432 <exit>
    }
    wait();
 1d8:	e8 5d 02 00 00       	call   43a <wait>
    printf (1, "\nfather passed!\n\n");
 1dd:	50                   	push   %eax
 1de:	50                   	push   %eax
 1df:	68 09 09 00 00       	push   $0x909
 1e4:	6a 01                	push   $0x1
 1e6:	e8 95 03 00 00       	call   580 <printf>
    
    
    
    exit();
 1eb:	e8 42 02 00 00       	call   432 <exit>

000001f0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	53                   	push   %ebx
 1f4:	8b 45 08             	mov    0x8(%ebp),%eax
 1f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1fa:	89 c2                	mov    %eax,%edx
 1fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 200:	83 c1 01             	add    $0x1,%ecx
 203:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 207:	83 c2 01             	add    $0x1,%edx
 20a:	84 db                	test   %bl,%bl
 20c:	88 5a ff             	mov    %bl,-0x1(%edx)
 20f:	75 ef                	jne    200 <strcpy+0x10>
    ;
  return os;
}
 211:	5b                   	pop    %ebx
 212:	5d                   	pop    %ebp
 213:	c3                   	ret    
 214:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 21a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000220 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	56                   	push   %esi
 224:	53                   	push   %ebx
 225:	8b 55 08             	mov    0x8(%ebp),%edx
 228:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 22b:	0f b6 02             	movzbl (%edx),%eax
 22e:	0f b6 19             	movzbl (%ecx),%ebx
 231:	84 c0                	test   %al,%al
 233:	75 1e                	jne    253 <strcmp+0x33>
 235:	eb 29                	jmp    260 <strcmp+0x40>
 237:	89 f6                	mov    %esi,%esi
 239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 240:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 243:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 246:	8d 71 01             	lea    0x1(%ecx),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 249:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 24d:	84 c0                	test   %al,%al
 24f:	74 0f                	je     260 <strcmp+0x40>
 251:	89 f1                	mov    %esi,%ecx
 253:	38 d8                	cmp    %bl,%al
 255:	74 e9                	je     240 <strcmp+0x20>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 257:	29 d8                	sub    %ebx,%eax
}
 259:	5b                   	pop    %ebx
 25a:	5e                   	pop    %esi
 25b:	5d                   	pop    %ebp
 25c:	c3                   	ret    
 25d:	8d 76 00             	lea    0x0(%esi),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 260:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
 262:	29 d8                	sub    %ebx,%eax
}
 264:	5b                   	pop    %ebx
 265:	5e                   	pop    %esi
 266:	5d                   	pop    %ebp
 267:	c3                   	ret    
 268:	90                   	nop
 269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000270 <strlen>:

uint
strlen(char *s)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 276:	80 39 00             	cmpb   $0x0,(%ecx)
 279:	74 12                	je     28d <strlen+0x1d>
 27b:	31 d2                	xor    %edx,%edx
 27d:	8d 76 00             	lea    0x0(%esi),%esi
 280:	83 c2 01             	add    $0x1,%edx
 283:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 287:	89 d0                	mov    %edx,%eax
 289:	75 f5                	jne    280 <strlen+0x10>
    ;
  return n;
}
 28b:	5d                   	pop    %ebp
 28c:	c3                   	ret    
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 28d:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 28f:	5d                   	pop    %ebp
 290:	c3                   	ret    
 291:	eb 0d                	jmp    2a0 <memset>
 293:	90                   	nop
 294:	90                   	nop
 295:	90                   	nop
 296:	90                   	nop
 297:	90                   	nop
 298:	90                   	nop
 299:	90                   	nop
 29a:	90                   	nop
 29b:	90                   	nop
 29c:	90                   	nop
 29d:	90                   	nop
 29e:	90                   	nop
 29f:	90                   	nop

000002a0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	57                   	push   %edi
 2a4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 2a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 2aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ad:	89 d7                	mov    %edx,%edi
 2af:	fc                   	cld    
 2b0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 2b2:	89 d0                	mov    %edx,%eax
 2b4:	5f                   	pop    %edi
 2b5:	5d                   	pop    %ebp
 2b6:	c3                   	ret    
 2b7:	89 f6                	mov    %esi,%esi
 2b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002c0 <strchr>:

char*
strchr(const char *s, char c)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	53                   	push   %ebx
 2c4:	8b 45 08             	mov    0x8(%ebp),%eax
 2c7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 2ca:	0f b6 10             	movzbl (%eax),%edx
 2cd:	84 d2                	test   %dl,%dl
 2cf:	74 1d                	je     2ee <strchr+0x2e>
    if(*s == c)
 2d1:	38 d3                	cmp    %dl,%bl
 2d3:	89 d9                	mov    %ebx,%ecx
 2d5:	75 0d                	jne    2e4 <strchr+0x24>
 2d7:	eb 17                	jmp    2f0 <strchr+0x30>
 2d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2e0:	38 ca                	cmp    %cl,%dl
 2e2:	74 0c                	je     2f0 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2e4:	83 c0 01             	add    $0x1,%eax
 2e7:	0f b6 10             	movzbl (%eax),%edx
 2ea:	84 d2                	test   %dl,%dl
 2ec:	75 f2                	jne    2e0 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 2ee:	31 c0                	xor    %eax,%eax
}
 2f0:	5b                   	pop    %ebx
 2f1:	5d                   	pop    %ebp
 2f2:	c3                   	ret    
 2f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000300 <gets>:

char*
gets(char *buf, int max)
{
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	57                   	push   %edi
 304:	56                   	push   %esi
 305:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 306:	31 f6                	xor    %esi,%esi
    cc = read(0, &c, 1);
 308:	8d 7d e7             	lea    -0x19(%ebp),%edi
  return 0;
}

char*
gets(char *buf, int max)
{
 30b:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 30e:	eb 29                	jmp    339 <gets+0x39>
    cc = read(0, &c, 1);
 310:	83 ec 04             	sub    $0x4,%esp
 313:	6a 01                	push   $0x1
 315:	57                   	push   %edi
 316:	6a 00                	push   $0x0
 318:	e8 2d 01 00 00       	call   44a <read>
    if(cc < 1)
 31d:	83 c4 10             	add    $0x10,%esp
 320:	85 c0                	test   %eax,%eax
 322:	7e 1d                	jle    341 <gets+0x41>
      break;
    buf[i++] = c;
 324:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 328:	8b 55 08             	mov    0x8(%ebp),%edx
 32b:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 32d:	3c 0a                	cmp    $0xa,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 32f:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 333:	74 1b                	je     350 <gets+0x50>
 335:	3c 0d                	cmp    $0xd,%al
 337:	74 17                	je     350 <gets+0x50>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 339:	8d 5e 01             	lea    0x1(%esi),%ebx
 33c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 33f:	7c cf                	jl     310 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 341:	8b 45 08             	mov    0x8(%ebp),%eax
 344:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 348:	8d 65 f4             	lea    -0xc(%ebp),%esp
 34b:	5b                   	pop    %ebx
 34c:	5e                   	pop    %esi
 34d:	5f                   	pop    %edi
 34e:	5d                   	pop    %ebp
 34f:	c3                   	ret    
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 350:	8b 45 08             	mov    0x8(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 353:	89 de                	mov    %ebx,%esi
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 355:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 359:	8d 65 f4             	lea    -0xc(%ebp),%esp
 35c:	5b                   	pop    %ebx
 35d:	5e                   	pop    %esi
 35e:	5f                   	pop    %edi
 35f:	5d                   	pop    %ebp
 360:	c3                   	ret    
 361:	eb 0d                	jmp    370 <stat>
 363:	90                   	nop
 364:	90                   	nop
 365:	90                   	nop
 366:	90                   	nop
 367:	90                   	nop
 368:	90                   	nop
 369:	90                   	nop
 36a:	90                   	nop
 36b:	90                   	nop
 36c:	90                   	nop
 36d:	90                   	nop
 36e:	90                   	nop
 36f:	90                   	nop

00000370 <stat>:

int
stat(char *n, struct stat *st)
{
 370:	55                   	push   %ebp
 371:	89 e5                	mov    %esp,%ebp
 373:	56                   	push   %esi
 374:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 375:	83 ec 08             	sub    $0x8,%esp
 378:	6a 00                	push   $0x0
 37a:	ff 75 08             	pushl  0x8(%ebp)
 37d:	e8 f0 00 00 00       	call   472 <open>
  if(fd < 0)
 382:	83 c4 10             	add    $0x10,%esp
 385:	85 c0                	test   %eax,%eax
 387:	78 27                	js     3b0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 389:	83 ec 08             	sub    $0x8,%esp
 38c:	ff 75 0c             	pushl  0xc(%ebp)
 38f:	89 c3                	mov    %eax,%ebx
 391:	50                   	push   %eax
 392:	e8 f3 00 00 00       	call   48a <fstat>
 397:	89 c6                	mov    %eax,%esi
  close(fd);
 399:	89 1c 24             	mov    %ebx,(%esp)
 39c:	e8 b9 00 00 00       	call   45a <close>
  return r;
 3a1:	83 c4 10             	add    $0x10,%esp
 3a4:	89 f0                	mov    %esi,%eax
}
 3a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
 3a9:	5b                   	pop    %ebx
 3aa:	5e                   	pop    %esi
 3ab:	5d                   	pop    %ebp
 3ac:	c3                   	ret    
 3ad:	8d 76 00             	lea    0x0(%esi),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 3b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3b5:	eb ef                	jmp    3a6 <stat+0x36>
 3b7:	89 f6                	mov    %esi,%esi
 3b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003c0 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	53                   	push   %ebx
 3c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3c7:	0f be 11             	movsbl (%ecx),%edx
 3ca:	8d 42 d0             	lea    -0x30(%edx),%eax
 3cd:	3c 09                	cmp    $0x9,%al
 3cf:	b8 00 00 00 00       	mov    $0x0,%eax
 3d4:	77 1f                	ja     3f5 <atoi+0x35>
 3d6:	8d 76 00             	lea    0x0(%esi),%esi
 3d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 3e0:	8d 04 80             	lea    (%eax,%eax,4),%eax
 3e3:	83 c1 01             	add    $0x1,%ecx
 3e6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3ea:	0f be 11             	movsbl (%ecx),%edx
 3ed:	8d 5a d0             	lea    -0x30(%edx),%ebx
 3f0:	80 fb 09             	cmp    $0x9,%bl
 3f3:	76 eb                	jbe    3e0 <atoi+0x20>
    n = n*10 + *s++ - '0';
  return n;
}
 3f5:	5b                   	pop    %ebx
 3f6:	5d                   	pop    %ebp
 3f7:	c3                   	ret    
 3f8:	90                   	nop
 3f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000400 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	56                   	push   %esi
 404:	53                   	push   %ebx
 405:	8b 5d 10             	mov    0x10(%ebp),%ebx
 408:	8b 45 08             	mov    0x8(%ebp),%eax
 40b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 40e:	85 db                	test   %ebx,%ebx
 410:	7e 14                	jle    426 <memmove+0x26>
 412:	31 d2                	xor    %edx,%edx
 414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 418:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 41c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 41f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 422:	39 da                	cmp    %ebx,%edx
 424:	75 f2                	jne    418 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 426:	5b                   	pop    %ebx
 427:	5e                   	pop    %esi
 428:	5d                   	pop    %ebp
 429:	c3                   	ret    

0000042a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 42a:	b8 01 00 00 00       	mov    $0x1,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    

00000432 <exit>:
SYSCALL(exit)
 432:	b8 02 00 00 00       	mov    $0x2,%eax
 437:	cd 40                	int    $0x40
 439:	c3                   	ret    

0000043a <wait>:
SYSCALL(wait)
 43a:	b8 03 00 00 00       	mov    $0x3,%eax
 43f:	cd 40                	int    $0x40
 441:	c3                   	ret    

00000442 <pipe>:
SYSCALL(pipe)
 442:	b8 04 00 00 00       	mov    $0x4,%eax
 447:	cd 40                	int    $0x40
 449:	c3                   	ret    

0000044a <read>:
SYSCALL(read)
 44a:	b8 05 00 00 00       	mov    $0x5,%eax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret    

00000452 <write>:
SYSCALL(write)
 452:	b8 10 00 00 00       	mov    $0x10,%eax
 457:	cd 40                	int    $0x40
 459:	c3                   	ret    

0000045a <close>:
SYSCALL(close)
 45a:	b8 15 00 00 00       	mov    $0x15,%eax
 45f:	cd 40                	int    $0x40
 461:	c3                   	ret    

00000462 <kill>:
SYSCALL(kill)
 462:	b8 06 00 00 00       	mov    $0x6,%eax
 467:	cd 40                	int    $0x40
 469:	c3                   	ret    

0000046a <exec>:
SYSCALL(exec)
 46a:	b8 07 00 00 00       	mov    $0x7,%eax
 46f:	cd 40                	int    $0x40
 471:	c3                   	ret    

00000472 <open>:
SYSCALL(open)
 472:	b8 0f 00 00 00       	mov    $0xf,%eax
 477:	cd 40                	int    $0x40
 479:	c3                   	ret    

0000047a <mknod>:
SYSCALL(mknod)
 47a:	b8 11 00 00 00       	mov    $0x11,%eax
 47f:	cd 40                	int    $0x40
 481:	c3                   	ret    

00000482 <unlink>:
SYSCALL(unlink)
 482:	b8 12 00 00 00       	mov    $0x12,%eax
 487:	cd 40                	int    $0x40
 489:	c3                   	ret    

0000048a <fstat>:
SYSCALL(fstat)
 48a:	b8 08 00 00 00       	mov    $0x8,%eax
 48f:	cd 40                	int    $0x40
 491:	c3                   	ret    

00000492 <link>:
SYSCALL(link)
 492:	b8 13 00 00 00       	mov    $0x13,%eax
 497:	cd 40                	int    $0x40
 499:	c3                   	ret    

0000049a <mkdir>:
SYSCALL(mkdir)
 49a:	b8 14 00 00 00       	mov    $0x14,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    

000004a2 <chdir>:
SYSCALL(chdir)
 4a2:	b8 09 00 00 00       	mov    $0x9,%eax
 4a7:	cd 40                	int    $0x40
 4a9:	c3                   	ret    

000004aa <dup>:
SYSCALL(dup)
 4aa:	b8 0a 00 00 00       	mov    $0xa,%eax
 4af:	cd 40                	int    $0x40
 4b1:	c3                   	ret    

000004b2 <getpid>:
SYSCALL(getpid)
 4b2:	b8 0b 00 00 00       	mov    $0xb,%eax
 4b7:	cd 40                	int    $0x40
 4b9:	c3                   	ret    

000004ba <sbrk>:
SYSCALL(sbrk)
 4ba:	b8 0c 00 00 00       	mov    $0xc,%eax
 4bf:	cd 40                	int    $0x40
 4c1:	c3                   	ret    

000004c2 <sleep>:
SYSCALL(sleep)
 4c2:	b8 0d 00 00 00       	mov    $0xd,%eax
 4c7:	cd 40                	int    $0x40
 4c9:	c3                   	ret    

000004ca <uptime>:
SYSCALL(uptime)
 4ca:	b8 0e 00 00 00       	mov    $0xe,%eax
 4cf:	cd 40                	int    $0x40
 4d1:	c3                   	ret    
 4d2:	66 90                	xchg   %ax,%ax
 4d4:	66 90                	xchg   %ax,%ax
 4d6:	66 90                	xchg   %ax,%ax
 4d8:	66 90                	xchg   %ax,%ax
 4da:	66 90                	xchg   %ax,%ax
 4dc:	66 90                	xchg   %ax,%ax
 4de:	66 90                	xchg   %ax,%ax

000004e0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 4e0:	55                   	push   %ebp
 4e1:	89 e5                	mov    %esp,%ebp
 4e3:	57                   	push   %edi
 4e4:	56                   	push   %esi
 4e5:	53                   	push   %ebx
 4e6:	89 c6                	mov    %eax,%esi
 4e8:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
 4ee:	85 db                	test   %ebx,%ebx
 4f0:	74 7e                	je     570 <printint+0x90>
 4f2:	89 d0                	mov    %edx,%eax
 4f4:	c1 e8 1f             	shr    $0x1f,%eax
 4f7:	84 c0                	test   %al,%al
 4f9:	74 75                	je     570 <printint+0x90>
    neg = 1;
    x = -xx;
 4fb:	89 d0                	mov    %edx,%eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 4fd:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    x = -xx;
 504:	f7 d8                	neg    %eax
 506:	89 75 c0             	mov    %esi,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 509:	31 ff                	xor    %edi,%edi
 50b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 50e:	89 ce                	mov    %ecx,%esi
 510:	eb 08                	jmp    51a <printint+0x3a>
 512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 518:	89 cf                	mov    %ecx,%edi
 51a:	31 d2                	xor    %edx,%edx
 51c:	8d 4f 01             	lea    0x1(%edi),%ecx
 51f:	f7 f6                	div    %esi
 521:	0f b6 92 d4 09 00 00 	movzbl 0x9d4(%edx),%edx
  }while((x /= base) != 0);
 528:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 52a:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 52d:	75 e9                	jne    518 <printint+0x38>
  if(neg)
 52f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 532:	8b 75 c0             	mov    -0x40(%ebp),%esi
 535:	85 c0                	test   %eax,%eax
 537:	74 08                	je     541 <printint+0x61>
    buf[i++] = '-';
 539:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 53e:	8d 4f 02             	lea    0x2(%edi),%ecx
 541:	8d 7c 0d d7          	lea    -0x29(%ebp,%ecx,1),%edi
 545:	8d 76 00             	lea    0x0(%esi),%esi
 548:	0f b6 07             	movzbl (%edi),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 54b:	83 ec 04             	sub    $0x4,%esp
 54e:	83 ef 01             	sub    $0x1,%edi
 551:	6a 01                	push   $0x1
 553:	53                   	push   %ebx
 554:	56                   	push   %esi
 555:	88 45 d7             	mov    %al,-0x29(%ebp)
 558:	e8 f5 fe ff ff       	call   452 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 55d:	83 c4 10             	add    $0x10,%esp
 560:	39 df                	cmp    %ebx,%edi
 562:	75 e4                	jne    548 <printint+0x68>
    putc(fd, buf[i]);
}
 564:	8d 65 f4             	lea    -0xc(%ebp),%esp
 567:	5b                   	pop    %ebx
 568:	5e                   	pop    %esi
 569:	5f                   	pop    %edi
 56a:	5d                   	pop    %ebp
 56b:	c3                   	ret    
 56c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 570:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 572:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 579:	eb 8b                	jmp    506 <printint+0x26>
 57b:	90                   	nop
 57c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000580 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 580:	55                   	push   %ebp
 581:	89 e5                	mov    %esp,%ebp
 583:	57                   	push   %edi
 584:	56                   	push   %esi
 585:	53                   	push   %ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 586:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 589:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 58c:	8b 75 0c             	mov    0xc(%ebp),%esi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 58f:	8b 7d 08             	mov    0x8(%ebp),%edi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 592:	89 45 d0             	mov    %eax,-0x30(%ebp)
 595:	0f b6 1e             	movzbl (%esi),%ebx
 598:	83 c6 01             	add    $0x1,%esi
 59b:	84 db                	test   %bl,%bl
 59d:	0f 84 b0 00 00 00    	je     653 <printf+0xd3>
 5a3:	31 d2                	xor    %edx,%edx
 5a5:	eb 39                	jmp    5e0 <printf+0x60>
 5a7:	89 f6                	mov    %esi,%esi
 5a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 5b0:	83 f8 25             	cmp    $0x25,%eax
 5b3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        state = '%';
 5b6:	ba 25 00 00 00       	mov    $0x25,%edx
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 5bb:	74 18                	je     5d5 <printf+0x55>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5bd:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 5c0:	83 ec 04             	sub    $0x4,%esp
 5c3:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 5c6:	6a 01                	push   $0x1
 5c8:	50                   	push   %eax
 5c9:	57                   	push   %edi
 5ca:	e8 83 fe ff ff       	call   452 <write>
 5cf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 5d2:	83 c4 10             	add    $0x10,%esp
 5d5:	83 c6 01             	add    $0x1,%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5d8:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 5dc:	84 db                	test   %bl,%bl
 5de:	74 73                	je     653 <printf+0xd3>
    c = fmt[i] & 0xff;
    if(state == 0){
 5e0:	85 d2                	test   %edx,%edx
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 5e2:	0f be cb             	movsbl %bl,%ecx
 5e5:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 5e8:	74 c6                	je     5b0 <printf+0x30>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5ea:	83 fa 25             	cmp    $0x25,%edx
 5ed:	75 e6                	jne    5d5 <printf+0x55>
      if(c == 'd'){
 5ef:	83 f8 64             	cmp    $0x64,%eax
 5f2:	0f 84 f8 00 00 00    	je     6f0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 5f8:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 5fe:	83 f9 70             	cmp    $0x70,%ecx
 601:	74 5d                	je     660 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 603:	83 f8 73             	cmp    $0x73,%eax
 606:	0f 84 84 00 00 00    	je     690 <printf+0x110>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 60c:	83 f8 63             	cmp    $0x63,%eax
 60f:	0f 84 ea 00 00 00    	je     6ff <printf+0x17f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 615:	83 f8 25             	cmp    $0x25,%eax
 618:	0f 84 c2 00 00 00    	je     6e0 <printf+0x160>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 61e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 621:	83 ec 04             	sub    $0x4,%esp
 624:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 628:	6a 01                	push   $0x1
 62a:	50                   	push   %eax
 62b:	57                   	push   %edi
 62c:	e8 21 fe ff ff       	call   452 <write>
 631:	83 c4 0c             	add    $0xc,%esp
 634:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 637:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 63a:	6a 01                	push   $0x1
 63c:	50                   	push   %eax
 63d:	57                   	push   %edi
 63e:	83 c6 01             	add    $0x1,%esi
 641:	e8 0c fe ff ff       	call   452 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 646:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 64a:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 64d:	31 d2                	xor    %edx,%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 64f:	84 db                	test   %bl,%bl
 651:	75 8d                	jne    5e0 <printf+0x60>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 653:	8d 65 f4             	lea    -0xc(%ebp),%esp
 656:	5b                   	pop    %ebx
 657:	5e                   	pop    %esi
 658:	5f                   	pop    %edi
 659:	5d                   	pop    %ebp
 65a:	c3                   	ret    
 65b:	90                   	nop
 65c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 660:	83 ec 0c             	sub    $0xc,%esp
 663:	b9 10 00 00 00       	mov    $0x10,%ecx
 668:	6a 00                	push   $0x0
 66a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 66d:	89 f8                	mov    %edi,%eax
 66f:	8b 13                	mov    (%ebx),%edx
 671:	e8 6a fe ff ff       	call   4e0 <printint>
        ap++;
 676:	89 d8                	mov    %ebx,%eax
 678:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 67b:	31 d2                	xor    %edx,%edx
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
 67d:	83 c0 04             	add    $0x4,%eax
 680:	89 45 d0             	mov    %eax,-0x30(%ebp)
 683:	e9 4d ff ff ff       	jmp    5d5 <printf+0x55>
 688:	90                   	nop
 689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 690:	8b 45 d0             	mov    -0x30(%ebp),%eax
 693:	8b 18                	mov    (%eax),%ebx
        ap++;
 695:	83 c0 04             	add    $0x4,%eax
 698:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
          s = "(null)";
 69b:	b8 cc 09 00 00       	mov    $0x9cc,%eax
 6a0:	85 db                	test   %ebx,%ebx
 6a2:	0f 44 d8             	cmove  %eax,%ebx
        while(*s != 0){
 6a5:	0f b6 03             	movzbl (%ebx),%eax
 6a8:	84 c0                	test   %al,%al
 6aa:	74 23                	je     6cf <printf+0x14f>
 6ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6b0:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6b3:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 6b6:	83 ec 04             	sub    $0x4,%esp
 6b9:	6a 01                	push   $0x1
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 6bb:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6be:	50                   	push   %eax
 6bf:	57                   	push   %edi
 6c0:	e8 8d fd ff ff       	call   452 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6c5:	0f b6 03             	movzbl (%ebx),%eax
 6c8:	83 c4 10             	add    $0x10,%esp
 6cb:	84 c0                	test   %al,%al
 6cd:	75 e1                	jne    6b0 <printf+0x130>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6cf:	31 d2                	xor    %edx,%edx
 6d1:	e9 ff fe ff ff       	jmp    5d5 <printf+0x55>
 6d6:	8d 76 00             	lea    0x0(%esi),%esi
 6d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 6e0:	83 ec 04             	sub    $0x4,%esp
 6e3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 6e6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 6e9:	6a 01                	push   $0x1
 6eb:	e9 4c ff ff ff       	jmp    63c <printf+0xbc>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 6f0:	83 ec 0c             	sub    $0xc,%esp
 6f3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 6f8:	6a 01                	push   $0x1
 6fa:	e9 6b ff ff ff       	jmp    66a <printf+0xea>
 6ff:	8b 5d d0             	mov    -0x30(%ebp),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 702:	83 ec 04             	sub    $0x4,%esp
 705:	8b 03                	mov    (%ebx),%eax
 707:	6a 01                	push   $0x1
 709:	88 45 e4             	mov    %al,-0x1c(%ebp)
 70c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 70f:	50                   	push   %eax
 710:	57                   	push   %edi
 711:	e8 3c fd ff ff       	call   452 <write>
 716:	e9 5b ff ff ff       	jmp    676 <printf+0xf6>
 71b:	66 90                	xchg   %ax,%ax
 71d:	66 90                	xchg   %ax,%ax
 71f:	90                   	nop

00000720 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 720:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 721:	a1 74 0c 00 00       	mov    0xc74,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 726:	89 e5                	mov    %esp,%ebp
 728:	57                   	push   %edi
 729:	56                   	push   %esi
 72a:	53                   	push   %ebx
 72b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 72e:	8b 10                	mov    (%eax),%edx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 730:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 733:	39 c8                	cmp    %ecx,%eax
 735:	73 19                	jae    750 <free+0x30>
 737:	89 f6                	mov    %esi,%esi
 739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 740:	39 d1                	cmp    %edx,%ecx
 742:	72 1c                	jb     760 <free+0x40>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 744:	39 d0                	cmp    %edx,%eax
 746:	73 18                	jae    760 <free+0x40>
static Header base;
static Header *freep;

void
free(void *ap)
{
 748:	89 d0                	mov    %edx,%eax
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 74a:	39 c8                	cmp    %ecx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 74c:	8b 10                	mov    (%eax),%edx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 74e:	72 f0                	jb     740 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 750:	39 d0                	cmp    %edx,%eax
 752:	72 f4                	jb     748 <free+0x28>
 754:	39 d1                	cmp    %edx,%ecx
 756:	73 f0                	jae    748 <free+0x28>
 758:	90                   	nop
 759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
  if(bp + bp->s.size == p->s.ptr){
 760:	8b 73 fc             	mov    -0x4(%ebx),%esi
 763:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 766:	39 d7                	cmp    %edx,%edi
 768:	74 19                	je     783 <free+0x63>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 76a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 76d:	8b 50 04             	mov    0x4(%eax),%edx
 770:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 773:	39 f1                	cmp    %esi,%ecx
 775:	74 23                	je     79a <free+0x7a>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 777:	89 08                	mov    %ecx,(%eax)
  freep = p;
 779:	a3 74 0c 00 00       	mov    %eax,0xc74
}
 77e:	5b                   	pop    %ebx
 77f:	5e                   	pop    %esi
 780:	5f                   	pop    %edi
 781:	5d                   	pop    %ebp
 782:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 783:	03 72 04             	add    0x4(%edx),%esi
 786:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 789:	8b 10                	mov    (%eax),%edx
 78b:	8b 12                	mov    (%edx),%edx
 78d:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 790:	8b 50 04             	mov    0x4(%eax),%edx
 793:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 796:	39 f1                	cmp    %esi,%ecx
 798:	75 dd                	jne    777 <free+0x57>
    p->s.size += bp->s.size;
 79a:	03 53 fc             	add    -0x4(%ebx),%edx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 79d:	a3 74 0c 00 00       	mov    %eax,0xc74
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7a2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7a5:	8b 53 f8             	mov    -0x8(%ebx),%edx
 7a8:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 7aa:	5b                   	pop    %ebx
 7ab:	5e                   	pop    %esi
 7ac:	5f                   	pop    %edi
 7ad:	5d                   	pop    %ebp
 7ae:	c3                   	ret    
 7af:	90                   	nop

000007b0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7b0:	55                   	push   %ebp
 7b1:	89 e5                	mov    %esp,%ebp
 7b3:	57                   	push   %edi
 7b4:	56                   	push   %esi
 7b5:	53                   	push   %ebx
 7b6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7b9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 7bc:	8b 15 74 0c 00 00    	mov    0xc74,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7c2:	8d 78 07             	lea    0x7(%eax),%edi
 7c5:	c1 ef 03             	shr    $0x3,%edi
 7c8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 7cb:	85 d2                	test   %edx,%edx
 7cd:	0f 84 a3 00 00 00    	je     876 <malloc+0xc6>
 7d3:	8b 02                	mov    (%edx),%eax
 7d5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 7d8:	39 cf                	cmp    %ecx,%edi
 7da:	76 74                	jbe    850 <malloc+0xa0>
 7dc:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 7e2:	be 00 10 00 00       	mov    $0x1000,%esi
 7e7:	8d 1c fd 00 00 00 00 	lea    0x0(,%edi,8),%ebx
 7ee:	0f 43 f7             	cmovae %edi,%esi
 7f1:	ba 00 80 00 00       	mov    $0x8000,%edx
 7f6:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
 7fc:	0f 46 da             	cmovbe %edx,%ebx
 7ff:	eb 10                	jmp    811 <malloc+0x61>
 801:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 808:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 80a:	8b 48 04             	mov    0x4(%eax),%ecx
 80d:	39 cf                	cmp    %ecx,%edi
 80f:	76 3f                	jbe    850 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 811:	39 05 74 0c 00 00    	cmp    %eax,0xc74
 817:	89 c2                	mov    %eax,%edx
 819:	75 ed                	jne    808 <malloc+0x58>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 81b:	83 ec 0c             	sub    $0xc,%esp
 81e:	53                   	push   %ebx
 81f:	e8 96 fc ff ff       	call   4ba <sbrk>
  if(p == (char*)-1)
 824:	83 c4 10             	add    $0x10,%esp
 827:	83 f8 ff             	cmp    $0xffffffff,%eax
 82a:	74 1c                	je     848 <malloc+0x98>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 82c:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 82f:	83 ec 0c             	sub    $0xc,%esp
 832:	83 c0 08             	add    $0x8,%eax
 835:	50                   	push   %eax
 836:	e8 e5 fe ff ff       	call   720 <free>
  return freep;
 83b:	8b 15 74 0c 00 00    	mov    0xc74,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 841:	83 c4 10             	add    $0x10,%esp
 844:	85 d2                	test   %edx,%edx
 846:	75 c0                	jne    808 <malloc+0x58>
        return 0;
 848:	31 c0                	xor    %eax,%eax
 84a:	eb 1c                	jmp    868 <malloc+0xb8>
 84c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 850:	39 cf                	cmp    %ecx,%edi
 852:	74 1c                	je     870 <malloc+0xc0>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 854:	29 f9                	sub    %edi,%ecx
 856:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 859:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 85c:	89 78 04             	mov    %edi,0x4(%eax)
      }
      freep = prevp;
 85f:	89 15 74 0c 00 00    	mov    %edx,0xc74
      return (void*)(p + 1);
 865:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 868:	8d 65 f4             	lea    -0xc(%ebp),%esp
 86b:	5b                   	pop    %ebx
 86c:	5e                   	pop    %esi
 86d:	5f                   	pop    %edi
 86e:	5d                   	pop    %ebp
 86f:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 870:	8b 08                	mov    (%eax),%ecx
 872:	89 0a                	mov    %ecx,(%edx)
 874:	eb e9                	jmp    85f <malloc+0xaf>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 876:	c7 05 74 0c 00 00 78 	movl   $0xc78,0xc74
 87d:	0c 00 00 
 880:	c7 05 78 0c 00 00 78 	movl   $0xc78,0xc78
 887:	0c 00 00 
    base.s.size = 0;
 88a:	b8 78 0c 00 00       	mov    $0xc78,%eax
 88f:	c7 05 7c 0c 00 00 00 	movl   $0x0,0xc7c
 896:	00 00 00 
 899:	e9 3e ff ff ff       	jmp    7dc <malloc+0x2c>
