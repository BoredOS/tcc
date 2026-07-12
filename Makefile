# Copyright (c) 2026 Christiaan (chris@boreddev.nl)
# Tiny C Compiler Standalone Makefile

CC = x86_64-boredos-gcc

DESTDIR ?= $(abspath build/dist)

APPS = tcc.elf

all: $(APPS) libtcc1.a

tcc.elf: tcc.c config.h tcc.h libtcc1.a
	$(CC) -O2 -m64 -march=x86-64 -fno-stack-protector \
	    -fno-stack-check -fno-lto -fno-pie -ffreestanding -static -no-pie \
	    -DONE_SOURCE=1 -DTARGETOS_BoredOS=1 -I. \
	    -Wl,-Ttext=0x40000000 tcc.c -o tcc.elf

libtcc1.a: build_libtcc1.sh
	CC="$(CC)" sh ./build_libtcc1.sh

install: all
	mkdir -p $(DESTDIR)/bin
	cp tcc.elf $(DESTDIR)/bin/
	# TCC support library copies
	mkdir -p $(DESTDIR)/usr/lib/tcc/include
	mkdir -p $(DESTDIR)/usr/lib
	cp libtcc1.a $(DESTDIR)/usr/lib/tcc/
	cp libtcc1.a $(DESTDIR)/usr/lib/
	cp include/*.h $(DESTDIR)/usr/lib/tcc/include/

.PHONY: bup
bup: all
	rm -rf build/package
	mkdir -p build/package/bin
	mkdir -p build/package/assets/lib/tcc/include
	cp tcc.elf build/package/bin/
	cp libtcc1.a build/package/assets/lib/tcc/
	cp libtcc1.a build/package/assets/lib/
	cp include/*.h build/package/assets/lib/tcc/include/
	cp MANIFEST.toml build/package/
	x86_64-boredos-strip --strip-unneeded build/package/bin/*.elf 2>/dev/null || true
	tar -cf build/tcc.tar -C build/package MANIFEST.toml bin assets
	lz4 -f build/tcc.tar build/tcc.bup
	rm -f build/tcc.tar
	rm -rf build/package

clean:
	rm -f tcc.elf libtcc1.a
	rm -rf build
