#include "types.h"
#include "stat.h"
#include "user.h"
#include "syscall.h"

#define PGSIZE 4096    // bytes mapped by a page
#define SLEEP 0
int
main(int argc, char *argv[])
{
    int i; 
    sleep(SLEEP);

    char *pages[18];
    
    /// allocate 18 pages
    for (i= 0 ; i< 3 ; i++){
        printf (1, "allocate 6 pages d\n");
        pages[i] = sbrk(6*PGSIZE);
        sleep(SLEEP);
    }
    
    printf (1, "finished allocating\n");
    
    printf (1, "first addr %p\n" ,pages[0]);

    
    
    exit();
    
}
