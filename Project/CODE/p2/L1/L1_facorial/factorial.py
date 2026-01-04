n = int(input().strip())

res = [1]
res_size = 1

x = 2
while x <= n:
    carry = 0
    i = 0
    while i < res_size:
        prod = res[i] * x + carry
        res[i] = prod % 10
        carry = prod // 10
        i = i + 1

    while carry > 0:
        res.append(carry % 10)
        carry = carry // 10
        res_size = res_size + 1

    x = x + 1

i = res_size - 1
while i >= 0:
    print(res[i], end="")
    i = i - 1

print()
