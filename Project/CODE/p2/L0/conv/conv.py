# 0 < m1, n1, m2, n2 < 11
m1 = int(input())
n1 = int(input())

matrix = []

m2 = int(input())
n2 = int(input())

core = []

for i in range(m1):
    for j in range(n1):
        matrix.append(int(input()))
        
for i in range(m2):
    for j in range(n2):
        core.append(int(input()))

out = []

for i in range(m1 - m2 + 1):
    for j in range(n1 - n2 + 1):
        ans = 0
        for k in range(m2):
            for l in range(n2):
                matrix_idx = (i + k) * n1 + (j + l)
                core_idx = k * n2 + l
                ans += matrix[matrix_idx] * core[core_idx]
        out.append(ans)
        print(ans, end = " ")
    print()