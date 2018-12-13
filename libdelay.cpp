#include <iostream>

extern "C" {

	int test() {
		return 1;
	}
}


static void lib_load() __attribute__((constructor));
void lib_load() {
	printf("Library loaded\n");
}
