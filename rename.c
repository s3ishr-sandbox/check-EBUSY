#include <stdio.h>
#include <stdlib.h>

int main(void) {
    FILE *fp;
    char *src = "rename.src";
    char *dst = "rename.dst";

    if ((fp = fopen(src, "w")) == NULL) {
        fprintf(stderr, "failed to open %s\n", src);
        exit(EXIT_FAILURE);
    }

    if (rename(src, dst) == 0) {
        printf("Success.\n");
    } else {
        printf("Failure.\n");
        exit(EXIT_FAILURE);
    }

    return 0;
}
