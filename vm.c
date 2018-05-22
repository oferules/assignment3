#include "param.h"
#include "types.h"
#include "defs.h"
#include "x86.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "elf.h"

extern char end[];
extern char data[];  // defined by kernel.ld
pde_t *kpgdir;  // for use in scheduler()

void printDebugSFM(struct proc *p){
  cprintf("\n%s num of pages in swap file: %d\n",p->name, p->num_of_currently_swapped_out_pages);
      int j;
      for(j = 0 ; j < MAX_PSYC_PAGES ; j++){
        cprintf("i: %d, in_swap_file: %d, va: %x\n",j , p->sfm[j].in_swap_file, p->sfm[j].va);
      }
}

void printDebugMem(struct proc *p){
  cprintf("\n%s num of pages in memory:  %d\n",p->name, p->num_of_pages_in_memory);
      int j;
      for(j = 0 ; j < MAX_PSYC_PAGES ; j++){
        cprintf("i: %d, in_mem: %d, va: %x, mem: %x, age: %x\n",j , 
          p->mem_pages[j].in_mem, p->mem_pages[j].va, p->mem_pages[j].mem, p->mem_pages[j].aging);
      }
}

/// update the memory pages data of process according to the specified algorithm
/// on page addition
void updateMemPages(void* va, void* mem, struct proc *p){
  int i;
  for(i = 0; i < MAX_PSYC_PAGES; i++){
    if(p->mem_pages[i].in_mem == 0){
      break;
    }
  }

  if(i == MAX_PSYC_PAGES){
    panic("mem_pages is full but shouldn't");
  }

  p->mem_pages[i].in_mem = 1;
  p->mem_pages[i].va = va;
  p->mem_pages[i].mem = mem;
  p->num_of_pages_in_memory++;

  #ifdef NFUA
    p->mem_pages[i].aging = 0;
  #endif

  #ifdef LAPA
    p->mem_pages[i].aging = 0xffffffff;
  #endif

  // #ifdef SCFIFO
  //     if(p->num_of_pages_in_memory == 16){

  //     } else {

  //     }

  //     struct mem_page *curr = p->first;
  //     if(curr == 0){
  //       p->first = p->mem_pages[i];
  //     } else {
  //       while(curr->next != 0){
  //         curr = curr->next;
  //       }

  //       curr->next = p->mem_pages[i];
  //     }

  //     p->mem_pages[i]->next = 0;
  //     p->mem_pages[i]->prev = curr;
  // #endif
}

/// update the memory pages data of process according to the specified algorithm
/// on page removal
void updateMemPagesOnRemove(void* va, struct proc *p){
  #if defined(LAPA) || defined(NFUA) || defined(SCFIFO)
    int i;
    for(i = 0; i < MAX_PSYC_PAGES; i++){
      if(p->mem_pages[i].va == va){
        break;
      }
    }

    if(i == MAX_PSYC_PAGES){
      return;
    }

    if (p->mem_pages[i].in_mem == 1){
      p->mem_pages[i].in_mem = 0;
      p->mem_pages[i].va = 0;
      p->num_of_pages_in_memory--;
    }
  #endif

  #ifdef AQ

    /// look for the page to remove
    int i;
    for(i = 0 ; i < MAX_PSYC_PAGES ; i++){
      if(p->mem_pages[i].va == va){
        break;
      }
    }
    
    if (i >= p->num_of_pages_in_memory)
        panic("AQ found illegal index to remove");

        
    /// move left all the pages after the page to remove
    for(; i < p->num_of_pages_in_memory - 1; i++){
      p->mem_pages[i].va = p->mem_pages[i+1].va;
      p->mem_pages[i].mem = p->mem_pages[i+1].mem;
      if (p->mem_pages[i].in_mem == 0 || p->mem_pages[i+1].in_mem == 0 )
          panic("AQ not work correctly");
    }

    /// remove the last (duplicated) page 
    if (p->mem_pages[p->num_of_pages_in_memory - 1].in_mem == 1){
      p->mem_pages[p->num_of_pages_in_memory - 1].in_mem = 0;
      p->mem_pages[p->num_of_pages_in_memory - 1].va = 0;
      p->num_of_pages_in_memory--;
    }
    else{
        panic("AQ not work correctly 2");
    }

  #endif
}

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
  struct cpu *c;

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
  lgdt(c->gdt, sizeof(c->gdt));
}

// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}

pte_t* walkpgdir_noalloc(pde_t *pgdir, const void *va){
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
    return &pgtab[PTX(va)];
  }

  return 0;
}

// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}

// There is one page table per process, plus one that's used when
// a CPU is not running any process (kpgdir). The kernel uses the
// current process's page table during system calls and interrupts;
// page protection bits prevent user code from using the kernel's
// mappings.
//
// setupkvm() and exec() set up every page table like this:
//
//   0..KERNBASE: user memory (text+data+stack+heap), mapped to
//                phys memory allocated by the kernel
//   KERNBASE..KERNBASE+EXTMEM: mapped to 0..EXTMEM (for I/O space)
//   KERNBASE+EXTMEM..data: mapped to EXTMEM..V2P(data)
//                for the kernel's instructions and r/o data
//   data..KERNBASE+PHYSTOP: mapped to V2P(data)..PHYSTOP,
//                                  rw data + free physical memory
//   0xfe000000..0: mapped direct (devices such as ioapic)
//
// The kernel allocates physical memory for its heap and for user memory
// between V2P(end) and the end of physical memory (PHYSTOP)
// (directly addressable from end..P2V(PHYSTOP)).

// This table defines the kernel's mappings, which are present in
// every process's page table.
static struct kmap {
  void *virt;
  uint phys_start;
  uint phys_end;
  int perm;
} kmap[] = {
 { (void*)KERNBASE, 0,             EXTMEM,    PTE_W}, // I/O space
 { (void*)KERNLINK, V2P(KERNLINK), V2P(data), 0},     // kern text+rodata
 { (void*)data,     V2P(data),     PHYSTOP,   PTE_W}, // kern data+memory
 { (void*)DEVSPACE, DEVSPACE,      0,         PTE_W}, // more devices
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
  kpgdir = setupkvm();
  switchkvm();
}

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
}

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
}

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
    }


    #ifndef NONE
      //if((strcmp(myproc()->name, "init") && strcmp(myproc()->name, "sh"))){

        if(myproc()->num_of_pages_in_memory > MAX_PSYC_PAGES){
          panic("too many pages in memory, allocuvm");
        }

        /// check if there is enough memory for page
        if(myproc()->num_of_pages_in_memory == MAX_PSYC_PAGES){

          int swapOutIndex = selectPageToSwapOut(myproc());
          swapOut(swapOutIndex, myproc());
        }
        updateMemPages((void*) a, mem, myproc());
      //}
    #endif


  }

  return newsz;
}

// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");

      char *v = P2V(pa);
      kfree(v);
      *pte = 0;
      
      #ifndef NONE
        //if((strcmp(myproc()->name, "init") && strcmp(myproc()->name, "sh"))){
      if(myproc()->pgdir == pgdir){
        updateMemPagesOnRemove((void*) a, myproc());
      }
        //}
      #endif
    }
    #ifndef NONE
    /// check if the page is in swap file
    else if (*pte & PTE_PG && myproc()->pgdir == pgdir) {
        int i;
        for (i = 0; i < MAX_PSYC_PAGES; i++) {
          if (myproc()->sfm[i].va == (char*)a)
            break;
        }
        if (i == MAX_PSYC_PAGES || myproc()->sfm[i].in_swap_file == 0)
            panic("deallocuvm: PTE_PG is on but page is not in swap file");

        myproc()->sfm[i].in_swap_file = 0;
        myproc()->num_of_currently_swapped_out_pages--;
        *pte = 0;
    }
    #endif
  }

  return newsz;
}

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
}

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
  *pte &= ~PTE_U;
}

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P) && !(*pte & PTE_PG))
      panic("copyuvm: page not present");
    if(*pte & PTE_PG){
      pte_t * pte1 = walkpgdir(d, (void *) i, 1);
      flags = PTE_FLAGS(*pte);
      *pte1 = PTE_U | PTE_PG | PTE_W | PTE_ADDR(*pte) | (int) flags;
      *pte1 = *pte1 & ~PTE_P;
      continue;
    }
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
      goto bad;
  }
  return d;

bad:
  freevm(d);
  return 0;
}

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}

// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}

/// function to take a page from physical memory and put it in the swap file in the disc
void swapOut(int index, struct proc *p){
  pte_t* pte = walkpgdir(p->pgdir, p->mem_pages[index].va, 0);

  if(!*pte){
    panic("swapOut");
  }

  struct swapfile_metadata* sfm;
  int i = 0;
  for(sfm = p->sfm; sfm < &p->sfm[MAX_PSYC_PAGES] ; sfm++){
    if(!sfm->in_swap_file){
      break;
    }

    i++;
  }

  /// if all pages are in use
  if(sfm >= &p->sfm[MAX_PSYC_PAGES]){
    /// TODO panic or change 
    panic("swap file is full");
  }

  uint placeOnFile = i * PGSIZE;

  int j;
  for(j = 0 ; j < 4 ; j++){
    writeToSwapFile(p, p->mem_pages[index].mem + (j * PGSIZE/4), placeOnFile + (j * PGSIZE/4), PGSIZE/4);
  }

  /// update the swapfile metadata
  sfm->in_swap_file = 1;
  sfm->va = p->mem_pages[index].va;

  /// free the page from the memory
  kfree(p->mem_pages[index].mem);
  updateMemPagesOnRemove(p->mem_pages[index].va, p);

  /// update stats
  p->num_of_currently_swapped_out_pages++;
  p->num_of_total_swap_out_actions++;

  /// making flags that pages swapped out and not present
  *pte = (*pte | PTE_PG) & ~PTE_P;

  /// refresh the TLB
  lcr3(V2P(p->pgdir));  

}

void swapIn(void* va, struct proc *p){
  struct swapfile_metadata* sfm;

  int i = 0;
  for(sfm = p->sfm; sfm < &p->sfm[MAX_PSYC_PAGES] ; sfm++){
    if(sfm->in_swap_file && sfm->va == va){
      break;
    }

    i++;
  }

  if(sfm >= &p->sfm[MAX_PSYC_PAGES]){
    /// TODO panic or change 
    panic("the requested page is not in the swapfile");
  }

  pte_t* pte = walkpgdir(p->pgdir, va, 1);

  if(!*pte){
    panic("swapIn");
  }

  /// allocate the page into the memory
  char* newMem = kalloc();
  uint placeOnFile = i * PGSIZE;

  int j;
  for(j = 0 ; j < 4 ; j++){
    readFromSwapFile(p, newMem + (j * PGSIZE/4), placeOnFile + (j * PGSIZE/4), PGSIZE/4);
  }

  /// making flags that pages swapped in and present
  *pte = (V2P(newMem) | PTE_P | PTE_U | PTE_W) & ~PTE_PG;

  /// update the swapfile metadata
  sfm->in_swap_file = 0;

  /// ****** TODO ***** check if its newVA or startOfVApage
  updateMemPages(va, newMem, p);

  /// update stats
  p->num_of_currently_swapped_out_pages--;

  /// refresh the TLB
  lcr3(V2P(p->pgdir));
}

/// return virtual address of the page to swap out
int selectPageToSwapOut(struct proc *p){

  int minIndex = -1;

  #ifdef NFUA
  int i;
  uint minAge = 0xffffffff;
  
  for(i = 0 ; i < MAX_PSYC_PAGES ; i++){
    if(!p->mem_pages[i].in_mem ){
      panic("should not swap out if there is room in memory");
    }

    pte_t* pte = walkpgdir_noalloc(p->pgdir, p->mem_pages[i].va);
    if(!(*pte & PTE_U)){
      continue;
    }
    
    /// check if the page is of the kernel
    //if((uint) p->mem_pages[i].va < (uint) end)
    //    continue;
    
    if(p->mem_pages[i].aging <= minAge){
      minAge = p->mem_pages[i].aging;
      minIndex = i;
    }
  }
    
  #endif

  #ifdef LAPA
  int i;
  uint minAge = 0xffffffff;
  uint minNumOfOnes = 0;
  for(i = 0 ; i < MAX_PSYC_PAGES ; i++){
    if(!p->mem_pages[i].in_mem){
      panic("should not swap out if there is room in memory");
    }

    pte_t* pte = walkpgdir_noalloc(p->pgdir, p->mem_pages[i].va);
    if(!(*pte & PTE_U)){
      continue;
    }

    uint currNumOfOnes = p->mem_pages[i].aging;
    int counter = 0;
    while(currNumOfOnes) {
        counter += currNumOfOnes % 2;
        currNumOfOnes >>= 1;
    }

    if(counter > minNumOfOnes || (counter == minNumOfOnes && p->mem_pages[i].aging <= minAge)){
      minAge = p->mem_pages[i].aging;
      minNumOfOnes = counter;
      minIndex = i;
    }
  }
  #endif

  #ifdef SCFIFO
    int isTrue;
    do{
      if(!p->mem_pages[p->first].in_mem){
        panic("should not swap out if there is room in memory");
      }

      pte_t* pte = walkpgdir_noalloc(p->pgdir, p->mem_pages[p->first].va);

      /// should not swap out pages that don't belong to the user
      if(!(*pte & PTE_U)){
        p->first = (p->first + 1) % MAX_PSYC_PAGES;
        continue;
      }

      isTrue = *pte & PTE_A;
      *pte = *pte & ~PTE_A;
      p->first = (p->first + 1) % MAX_PSYC_PAGES;
    } while(isTrue);

    minIndex = (p->first + MAX_PSYC_PAGES - 1) % MAX_PSYC_PAGES;
  #endif

  #ifdef AQ
    int i;
    for(i = 0 ; i < MAX_PSYC_PAGES ; i++){
      if(!p->mem_pages[i].in_mem){
        panic("should not swap out if there is room in memory");
      }
    }

    /// last is always at index 0
    // minIndex = p->last;
    // p->last = (p->last +1) % MAX_PSYC_PAGES;
    for(i = 0 ; i < MAX_PSYC_PAGES ; i++){
      pte_t* pte = walkpgdir_noalloc(p->pgdir, p->mem_pages[i].va);
      /// should not swap out pages that don't belong to the user
      if((*pte & PTE_U)){
        break;
      }
    }

    minIndex = i;
  #endif

  if(minIndex == -1){
    panic("no page was chosen to be swapped out");
  }
  
  if(minIndex >= MAX_PSYC_PAGES){
    panic("too large index for swap out");
  }

  return minIndex;
}

//PAGEBREAK!
// Blank page.
//PAGEBREAK!
// Blank page.
//PAGEBREAK!
// Blank page.

