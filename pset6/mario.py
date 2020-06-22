from cs50 import get_int    # importing cs50 library

while True:     # while loop to accept in range of 1 and 8 
    n = get_int("Height: ")
    if n >= 1 and n <= 8:
        break

for i in range(n):
    print(' ' * (n - i - 1), end="")    # same formula as of mario more comfortable in c++
    print('#' * (i + 1), end="")
    print('  ', end="")
    print('#' * (i + 1))
    
# end of the code