N, M = map(int, input().split())

basket = [i for i in range(1, N+1)]

for _ in range(M):
    i, j = map(input().split())
    i -= 1
    j -= 1

    basket[i], basket[j] = basket[j], basket[i]


print(*basket) # *가 리스트를 벗겨줌