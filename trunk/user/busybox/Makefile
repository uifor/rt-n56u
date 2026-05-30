SRC_NAME=busybox-1.36.1

all:
	$(MAKE) -j1 -C $(SRC_NAME)

clean:
	$(MAKE) -C $(SRC_NAME) distclean

romfs:
	$(MAKE) -C $(SRC_NAME) CONFIG_PREFIX=$(ROMFSDIR) install
