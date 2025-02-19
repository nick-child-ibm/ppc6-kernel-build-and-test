obj-m += new_mod.o
KERN_BUILD?=/lib/modules/$(shell uname -r)/build

all:
	make -C $(KERN_BUILD) M=$(PWD)  ARCH=powerpc CROSS_COMPILE=ppc64le-linux-gnu- modules

clean:
	make  -C $(KERN_BUILD) M=$(PWD)  ARCH=powerpc CROSS_COMPILE=ppc64le-linux-gnu- clean
