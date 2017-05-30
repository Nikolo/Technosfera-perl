import math

sas = [1, 2, 3, 4, 5, 6, 7, 8]
d = 0
test = 0

for i in sas:
    d = 2
    test = 0
    if i > 2:
        while d < i:
            if i % d == 0:
                test = 1
            elif d == i - 1 and test == 0:
                print(i)
            d += 1
