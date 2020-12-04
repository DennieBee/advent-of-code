#include <stdlib.h>
#include <stdio.h>
#include <regex.h>
#include <string.h>

int main() {
    // get input
    char* input = 0;
    long length;
    FILE* f = fopen("day04_input", "rb");
    if (f) {
        fseek(f, 0, SEEK_END);
        length = ftell(f);
        fseek(f, 0, SEEK_SET);
        input = malloc(length);
        if (input) {
            fread(input, 1, length, f);
        }
        fclose(f);
    }

    // get key value pairs
    regex_t regex;
    regcomp(&regex, "([a-z]|[0-9]|#)+:([a-z]|[0-9]|#)+", REG_EXTENDED);

    int16_t pos = 0;
    while (pos < length / sizeof(char)) {
        regmatch_t regmatch[1];
        int16_t value = regexec(&regex, &(input[pos]), 1, regmatch, 0);
        printf ("%.*s\n", regmatch[0].rm_eo - regmatch[0].rm_so, &input[regmatch[0].rm_so + pos]);
        pos += regmatch[0].rm_eo;
    }

    regfree(&regex);
    return 0;
}




    // if (value != 0) {
    //     char error_message[0x1000];
    //     regerror(value, &regex, error_message, 0x1000);
    //     printf ("ERROR: %s\n", error_message);
    // }