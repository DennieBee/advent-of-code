#include <stdlib.h>
#include <stdio.h>
#include <regex.h>
#include <string.h>

char* multi_tok(char *input, char *delimiter) {
    static char* string;
    if (input != NULL)
        string = input;

    if (string == NULL)
        return string;

    char* end = strstr(string, delimiter);
    if (end == NULL) {
        char *temp = string;
        string = NULL;
        return temp;
    }

    char* temp = string;

    *end = '\0';
    string = end + strlen(delimiter);
    return temp;
}

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

    int16_t valid_count;
    int16_t passport_count;
    char* passport = multi_tok(input, "\r\n\r\n");
    while (passport != NULL) { 
        char* byr = strstr(passport, "byr");
        char* iyr = strstr(passport, "iyr");
        char* eyr = strstr(passport, "eyr");
        char* hgt = strstr(passport, "hgt");
        char* hcl = strstr(passport, "hcl");
        char* ecl = strstr(passport, "ecl");
        char* pid = strstr(passport, "pid");
        if (byr != NULL && iyr != NULL && eyr != NULL && hgt != NULL && hcl != NULL && ecl != NULL && pid != NULL) {
            valid_count++;
        } 
        passport_count++;
        passport = multi_tok(NULL,  "\r\n\r\n");
    } 

    printf("Number of passports: %i\n", passport_count);

    printf("Number of valid passports: %i\n", valid_count);

    return 0;
}