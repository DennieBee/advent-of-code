#include <stdlib.h>
#include <stdio.h>
#include <regex.h>
#include <string.h>
#include "../include/strfun.h"

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
    int16_t extra_valid_count;
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
            passport = str_replace(passport, "\r\n", "");
            
            char pairs[8][200];
            char* pair = strtok(passport, " ");
            int pair_count;
            while (pair != NULL) {
                strcpy(pairs[pair_count], pair);
                pair_count++;
                pair = strtok(NULL, " ");
            }

            int16_t extra_valid = 1;
            for (size_t i = 0; i < pair_count; i++) {
                char* key = strtok(pairs[i], ":");
                char* value = strtok(NULL, ":");
                
                // byr
                if (strcmp(key, "byr") == 0) {
                    int year = atoi(value);
                    if (year < 1920 || year > 2002) {
                        extra_valid = 0;
                    }
                }

                // iyr
                if (strcmp(key, "iyr") == 0) {
                    int year = atoi(value);
                    if (year < 2010 || year > 2020) {
                        extra_valid = 0;
                    }
                }

                // eyr
                if (strcmp(key, "eyr") == 0) {
                    int year = atoi(value);
                    if (year < 2020 || year > 2030) {
                        extra_valid = 0;
                    }
                }

                if (strcmp(key, "hgt") == 0) {
                    char* cm = multi_tok(value, "cm");
                    if (cm != NULL) {
                        int cms = atoi(cm);
                        if (cms < 150 || cms > 193) {
                            extra_valid = 0;
                        }
                    } else {
                        char* in = multi_tok(value, "cm");
                        int ins = atoi(in);
                        if (ins < 59 || ins > 76) {
                            extra_valid = 0;
                        }
                    }
                }

                if (strcmp(key, "hcl") == 0) {
                    regex_t regex;
                    regcomp(&regex, "^#(?:[a-f]|[0-9]){6}", 0);
                    if (regexec(&regex, value, 0, NULL, 0) == REG_NOMATCH) {
                        extra_valid = 0;
                    }
                }

                if (strcmp(key, "ecl") == 0) {
                    regex_t regex;
                    regcomp(&regex, "amb|blu|brn|gry|grn|hzl|oth", 0);
                    if (regexec(&regex, value, 0, NULL, 0) == REG_NOMATCH) {
                        extra_valid = 0;
                    }
                }

                if (strcmp(key, "pid") == 0) {
                    regex_t regex;
                    regcomp(&regex, "[0-9]{9}", 0);
                    if (regexec(&regex, value, 0, NULL, 0) == REG_NOMATCH) {
                        extra_valid = 0;
                    }
                }
            }

            if (extra_valid > 0) {
                extra_valid_count++;
            }
            
            pair_count = 0;
            free(pair);
        } 

        passport_count++;
        passport = multi_tok(NULL,  "\r\n\r\n");
    } 

    printf("Number of passports: %i\n", passport_count);
    printf("Number of valid passports: %i\n", valid_count);
    printf("Number of extra valid passports: %i\n", extra_valid_count);

    return 0;
}