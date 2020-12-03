#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define SLOPE_RIGHT 3
#define SLOPE_DOWN 1

int get_line_length(FILE* file) {
    fpos_t file_pos;
    fgetpos(file, &file_pos);
    int16_t length = 0;
    while (fgetc(file) != 10) {
        length++;
    }
    fsetpos(file, &file_pos);
    return length;
}

int main() {
    FILE* file = fopen("day03_input", "r");
    const int line_length = get_line_length(file);
    char lines[1000][50];
    int16_t line_count;
    
    // fuck fgets, we'll do it live
    int char_index;
    char ch;
    while ((ch = fgetc(file)) != EOF) {
        if (ch == 10) {
            line_count++;
            char_index = 0;
            continue;
        }
        lines[line_count][char_index++] = ch;
    }
    
    // part 1
    int16_t tree_count;
    int pos_x = 0;
    int pos_y = 0;
    while (pos_y < line_count) {
        pos_x += SLOPE_RIGHT;
        pos_y += SLOPE_DOWN;
        if (lines[pos_y][pos_x % line_length] == 35) {
            tree_count++;
        }
    }
    printf("Part 1\n======\nNumber of trees encountered: %i\n\n", tree_count);

    // part 2
    int16_t slopes[5][2];
    slopes[0][0] = 1; slopes[0][1] = 1; 
    slopes[1][0] = 3; slopes[1][1] = 1;
    slopes[2][0] = 5; slopes[2][1] = 1;
    slopes[3][0] = 7; slopes[3][1] = 1;
    slopes[4][0] = 1; slopes[4][1] = 2;

    int64_t multiplication = 1;
    for (size_t i = 0; i < 5; i++) {
        tree_count = 0;
        pos_x = 0;
        pos_y = 0;
        while (pos_y < line_count) {
            pos_x += slopes[i][0];
            pos_y += slopes[i][1];
            if (lines[pos_y][pos_x % line_length] == 35) {
                tree_count++;
            }
        }
        multiplication = multiplication * tree_count;
    }
    printf("Part 2\n======\nMultiplication of slopes: %li\n", multiplication);

    return 0;
}