#include "types.h"
#include "stat.h"
#include "user.h"
#include "syscall.h"

#define PGSIZE 4096    // bytes mapped by a page
#define SLEEP 0
#define NUM_OF_PAGES 18
#define VALUE 12
int
main(int argc, char *argv[])
{
    int i; 
    printf (1, "mem tests\n");

    printf (1, "\nafter exec suppose to have more than 2 pages.\nsleeping, press ^P!\n\n");
    sleep(SLEEP);

    char *pages[NUM_OF_PAGES];
    
    /// allocate NUM_OF_PAGES pages
    printf (1, "\nallocate %d pages",NUM_OF_PAGES/2);
    for (i= 0 ; i< NUM_OF_PAGES/2 ; i++){
        pages[i] = sbrk(PGSIZE);
    }
    printf (1, "\nsleeping, press ^P!\n\n");
    sleep(SLEEP);

    printf (1, "\nallocate %d pages",NUM_OF_PAGES/2);
    for (i= NUM_OF_PAGES/2 ; i< NUM_OF_PAGES ; i++){
        pages[i] = sbrk(PGSIZE);
    }
    
    printf (1, "\nfinished allocating %d pages\n", NUM_OF_PAGES);
    printf (1, "\nsleeping, press ^P!\n\n");
    sleep(SLEEP);
    
    printf (1, "\nGoing to write a value to each page in accending order\n");
    
    for(i = 0 ; i < NUM_OF_PAGES ; i++){
        printf(1, "writing value %d to page: %d in offset 3\n", VALUE, i);
        pages[i][3] = VALUE;
    }
    
    printf (1, "\nsleeping, press ^P!\n\n");
    sleep(SLEEP);
    
    printf (1, "\nGoing to read the values from each page in deccending order\n");

    for(i = 17 ; i >= 0 ; i--){
        printf(1, "\nReading from page: %d the value: %d\n", i, pages[i][3]);
    }

    printf (1, "\nsleeping, press ^P!\n\n");
    sleep(SLEEP);
    
    printf (1, "\nfork test, father wait for child..\n");
    
    int pid = fork();
    if (pid==0){
        printf (1, "\nchild suppose to have same memory as father but different statistics\n");
        printf (1, "\nsleeping, press ^P!\n\n");
        sleep(SLEEP);
        
        printf (1, "\nChild is going to read the values from each page in accending order\n");
        
        for(i = 0 ; i < NUM_OF_PAGES ; i++){
            printf(1, "\nReading from page: %d the value: %d\n", i, pages[i][3]);
        }
        printf (1, "\nsleeping, press ^P!\n\n");
        sleep(SLEEP);
        
        printf (1, "\nchild exit!\n");
        exit();
    }
    wait();
   
    printf (1, "\nfather returned from wait!\n");
        
    exit();
    
}
