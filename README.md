# gccdelayload

## Compiling the library

`gcc -c -fPIC libdelay.cpp
gcc -shared -o libdelay.so libdelay.o`

## Using Implib.so
`pytohn2.7 Implib.so.py libdelay.so`

## Compile with Implib (not working)
`gcc main.cpp libdelay.so.tramp.S libdelay.so.init.c`

## Compile with Implib (working)
`gcc main.cpp libdelay.so.tramp.S libdelay.so.init.c -ldl -lstdc++`

## trying to link without Implib.so
`gcc main.cpp -Wl,-z,nodefs`

Error: -z nodefs ignored

## trying to link without Implib.so
`gcc main.cpp -Wl,--unresolve-symbols=ignore-all`

Building Ok.
1. dlopen the lib, Ok.

2. Method call, Segment Fault (core dump)


