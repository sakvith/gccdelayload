#include <iostream>
//#include <dlfcn.h>
#include "delay.h"

int main() {

	printf("Main executable\n");
	
	void *handle;
	//handle = dlopen("libdelay.so", RTLD_NOW | RTLD_GLOBAL);
	//if (!handle) {
	//	fputs(dlerror(), stderr);
	//	exit(1);
	//}

	printf("%d\n", test());

}
