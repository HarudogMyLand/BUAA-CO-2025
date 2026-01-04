#include <stdio.h>
int main() {
    int num;
    scanf("%d", &num);
    char* str;
    scanf("%s", str);
    int ans = 1;
    for (int i = 0; i < num; i++) {
        if (str[i] != str[num - i - 1]) {
            ans = 0;
        }
    }
    printf("%d", ans);
}