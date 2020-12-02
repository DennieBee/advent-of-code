#include <stdlib.h>
#include <stdio.h>
#include <string.h>

struct Password {
    int policy_min;
    int policy_max;
    char policy_char;
    char password[50];
    int password_length;
};

enum TokenType {
    tt_min = 0,
    tt_max = 1,
    tt_char = 2,
    tt_password = 3
};

struct ListItem {
    struct Password* data;
    struct ListItem* next;
};

int main() {
    char ch;
    FILE* file = fopen("day02_input", "r");
    struct Password password;
    enum TokenType token_type = tt_min;
    char token[50];
    int16_t token_index = tt_min;
    while((ch = fgetc(file)) != EOF) {
        switch (token_type)
        {
        case tt_min:
            if (ch == 45) {
                password.policy_min = atoi(token);
                printf("%i\n", password.policy_min);
                token_type = tt_max;
                token_index = 0;
                continue;
            }
            break;
        case tt_max:
            if (ch == 32) {
                password.policy_max = atoi(token);
                printf("%i\n", password.policy_max);
                token_type = tt_char;
                token_index = 0;
                continue;
            }
            break;
        case tt_char:
            if (ch == 58) {
                password.policy_char = token[0];
                printf("%c\n", password.policy_char);
                token_type = tt_password;
                token_index = 0;
                continue;
            }
            break;
        case tt_password:
            if (ch == 32) continue;
            if (ch == 10) {
                strcpy(password.password, token);
                password.password_length = token_index;
                for (size_t i = 0; i < token_index; i++) {
                    printf("%c", password.password[i]);
                }
                printf("\n");
                token_type = tt_min;
                token_index = 0;
                password.password_length = 0;
                continue;
            }
            break;
        default:
            token_index = 0;
            break;
        }

        token[token_index++] = ch;

        //printf("%i, %i, %c, %s", password.policy_min, password.policy_max, password.policy_char, password.password);
    }

    return 0;
}