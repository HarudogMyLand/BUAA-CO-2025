num = int(input())

matrix1 = []
matrix2 = []

for i in range(num):
    for j in range(num):
        matrix1.append(int(input()))
        
for i in range(num):
    for j in range(num):
        matrix2.append(int(input()))
        
ans = []

for i in range(num):
    for j in range(num):
        ans = 0;
        for l in range(num):
            ans += matrix1[num * i + l] * matrix2[num * l + j]
        print(ans, end=" ")
    print()