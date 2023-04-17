#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[]) {
    int fd1[2], fd2[2];
    char buffer[10];
    pde_t pid;

    pipe(fd1);
    pipe(fd2);

    pid = fork();

    if (pid == 0) {
        read(fd1[0], buffer, 4);
        
        printf("%d: received %s\n", getpid(), buffer);

        write(fd2[1], "pong", 4);
        
    } else {
        write(fd1[1], "ping", 4);
        read(fd2[0], buffer, 4);
        
        printf("%d: received %s\n", getpid(), buffer);

    }
    exit(0);
}