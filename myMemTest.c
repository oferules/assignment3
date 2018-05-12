#include "types.h"
#include "stat.h"
#include "user.h"

#define PGSIZE 4096    // bytes mapped by a page
#define INTS_FILL(pages)   (pages*PGSIZE)/4

int
main(int argc, char *argv[])
{
    int twoPages [INTS_FILL(2)];
    int i;
    printf (1, "allocate 2 pages (%d ints) and sleep a little bit..\n" , INTS_FILL(2));
    sleep(300);
    
    
    for (i=0 ; i<INTS_FILL(2) ; i++){
        
        twoPages[i] = i;
        printf (1, "%d\n", twoPages[i]);
    }
    
    
    printf (1, "%d\n", twoPages[0]);
    
    
    exit();
    
}
