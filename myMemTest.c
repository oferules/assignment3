#include "types.h"
#include "stat.h"
#include "user.h"
#include "syscall.h"

#define PGSIZE 4096    // bytes mapped by a page
#define SLEEP 300
int
main(int argc, char *argv[])
{
    int i; 
    printf (1, "mem tests, sleep a while...\n");

    sleep(SLEEP);

    char *pages[18];
    
    /// allocate 18 pages
    for (i= 0 ; i< 9 ; i++){
        printf (1, "allocate 1 page, page num: %d\n",i);
        pages[i] = sbrk(PGSIZE);
        
    }
    printf (1, "allocated 9 pages, sleep a while...\n");
    sleep(SLEEP);

    for (i= 9 ; i< 18 ; i++){
        printf (1, "allocate 1 page, page num: %d\n",i);
        pages[i] = sbrk(PGSIZE);
    }
    
    printf (1, "finished allocating 18 pages\n");
    
    for(i = 0 ; i < 18 ; i++){
        printf(1, "\nacceing page: %d\n", i);
        pages[i][3] = 12;
    }

    // for(i = 17 ; i >= 0 ; i--){
    //     printf(1, "\nacceing page: %d (decsending)\n", i);
    //     *pages[i] = 12;
    // }

    sleep(SLEEP*2);
    exit();
    
}
