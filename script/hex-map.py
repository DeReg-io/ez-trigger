from string import hexdigits


def found(n):
    inds = {
        ord(c) % n
        for c in hexdigits
    }
    return len(inds) == len(hexdigits) and max(inds) <= 31


good_x = []

for x in range(1, 256):
    if found(x):
        print(f'x: {x}')
        good_x.append(x)

x = good_x[0]
cmap = {
    ord(c) % x: c
    for c in hexdigits
}

char_map = 0

for i in range(32):
    v = cmap.get(i, 'X')
    char_map <<= 8
    if x == 'X':
        char_map |= ord('0')
    else:
        char_map |= ord(v)
    print(f'{i:2} {v}')

print(hex(char_map))
