#include <stdlib.h>
#include <stdio.h>
#include <string.h>

struct Password {
    int policy_a;
    int policy_b;
    char policy_char;
    char password[50];
    int password_length;
} password_t;

enum TokenType {
    tt_a = 0,
    tt_b = 1,
    tt_char = 2,
    tt_password = 3
};

int main() {
    char ch;
    FILE* file = fopen("day02_input", "r");
    struct Password* p;
    enum TokenType token_type = tt_a;
    char token[50];
    int16_t token_index = tt_a;
    int16_t correct_count = 0;
    int16_t valid_count = 0;
    while((ch = fgetc(file)) != EOF) {
        switch (token_type)
        {
        case tt_a:
            if (ch == 45) {
                p = malloc(sizeof(password_t));
                p->policy_a = atoi(token);
                token_type = tt_b;
                token_index = 0;
                continue;
            }
            break;
        case tt_b:
            if (ch == 32) {
                p->policy_b = atoi(token);
                token_type = tt_char;
                token_index = 0;
                continue;
            }
            break;
        case tt_char:
            if (ch == 58) {
                p->policy_char = token[0];
                token_type = tt_password;
                token_index = 0;
                continue;
            }
            break;
        case tt_password:
            if (ch == 32) continue;
            if (ch == 10) {
                strcpy(p->password, token);
                p->password_length = token_index;


                // part 1
                int16_t char_count = 0;
                for (size_t i = 0; i < p->password_length; i++) {
                    if (p->password[i] == p->policy_char) {
                        char_count++;
                    }
                }
                if (char_count >= p->policy_a && char_count <= p->policy_b) {
                    correct_count++;
                }

                // part 2
                if (p->password[p->policy_a - 1] == p->policy_char ^ p->password[p->policy_b - 1] == p->policy_char) {
                    valid_count++;
                }

                token_type = tt_a;
                token_index = 0;
                free(p);
                continue;
            }
            break;
        default:
            token_index = 0;
            break;
        }

        token[token_index++] = ch;   
    }
    fclose(file);
    printf("Part 1 | Number of correct passwords: %i\n", correct_count);
    printf("Part 2 | Number of valid passwords: %i\n", valid_count);
    return 0;
}