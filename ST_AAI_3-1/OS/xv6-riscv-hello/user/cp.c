#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "user/user.h"

#define SIZE 512

int main(int argc, char *argv[]) 
{
    char buffer[SIZE];
    int src, dest, r, w=0;

    if (argc != 3) 
    {
        printf("Usage: cp <source_file> <destination_file>\n");
        exit(0);
    }

    src = open(argv[1], O_RDONLY);

    if (src < 0) 
    {
        printf("Error: Could not open source file %s\n", argv[1]);
        exit(1);
    }

    dest = open(argv[2], O_CREATE|O_WRONLY);
    if (dest < 0) 
    {
        printf("Error: Could not open destination file %s\n", argv[2]);
        exit(1);
    }

    while ((r = read(src, buffer, sizeof(buffer))) > 0) 
    {
        w = write(dest, buffer, r);
        if (w != r || w < 0) 
            break;
    }

    if (r < 0 || w < 0)
        printf("cp: error copying %s to %s\n", argv[1], argv[2]);

    close(src);
    close(dest);
    exit(0);
}