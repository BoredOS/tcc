# Tiny C Compiler (tcc) for BoredOS

This repository houses the port of the Tiny C Compiler (`tcc`) for BoredOS, providing on-device C compilation capability. It compiles `tcc.elf` along with standard support libraries (`libtcc1.a`) and standard headers.

## Decoupled Building

This repository is designed to compile **either within the main BoredOS tree OR completely standalone**.

### 1. Integrated Build (Within BoredOS)
If built from the BoredOS root tree, the build system passes `BOREDOS_SDK` to the Makefile. It immediately compiles TCC against the shared pre-built SDK:
```bash
make BOREDOS_SDK=/path/to/shared/sdk
```

### 2. Standalone Build (Isolated Clone)
If cloned completely separately in isolation, running `make` will **automatically bootstrap standard dependencies**:
```bash
make
```
If `build/sdk` is missing, the Makefile automatically clones the pure standard library dependency from `https://github.com/boredos/libc.git`, compiles it, installs it to `build/sdk`, and builds TCC cleanly in full isolation!

## Staging Installation
To stage the compiled TCC binary, support libraries, and headers into your target initrd root filesystem directory:
```bash
make DESTDIR=/path/to/initrd/root install
```
- Binary is routed to `/bin/tcc.elf`
- Support libraries are routed to `/usr/lib/` and `/usr/lib/tcc/`
- Support headers are routed to `/usr/lib/tcc/include/`
