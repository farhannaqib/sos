CFILES = $(wildcard src/*/*.c)
SFILES = $(wildcard src/*/*.S)
COFILES = $(CFILES:.c=.co)
AOFILES = $(SFILES:.S=.ao)

kernel: LLVMPATH = /opt/homebrew/opt/llvm/bin/
kernel: LDPATH = /opt/homebrew/bin/
kernel: CLANGFLAGS = --target=aarch64-elf -Wall -ffreestanding -nostdinc -nostdlib -mcpu=cortex-a72+nosimd
kernel: CPPFLAGS = -Iinclude
kernel: LDFLAGS = -m aarch64elf -nostdlib -T link.ld --strip-all
kernel: clean kernel8.img

user: LLVMPATH = /usr/bin/
user: CLANGFLAGS = -Wall --sysroot=/usr/local/ -g
user: CPPFLAGS = -Iinclude -D USER=1
user: LDFLAGS = -L /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib
user: clean $(COFILES) $(AOFILES)
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib
	$(LLVMPATH)clang -o kernel.bin $(LDFLAGS) $(COFILES) $(AOFILES)

*/*/%.ao: src/*/%.S
	$(LLVMPATH)clang $(CLANGFLAGS) $(CPPFLAGS) -c $< -o $@

*/*/%.co: src/*/%.c
	$(LLVMPATH)clang $(CLANGFLAGS) $(CPPFLAGS) -c $< -o $@

kernel8.img: $(COFILES) $(AOFILES)
	$(LDPATH)ld.lld $(LDFLAGS) $(COFILES) $(AOFILES) -o kernel8.elf
	$(LLVMPATH)llvm-objcopy -O binary kernel8.elf kernel8.img

test: test/*/*.c
	$(LLVMPATH)clang $(CLANGFLAGS) $(CPPFLAGS) -c $^ test/utils.c -o $@

clean:
	/bin/rm *.elf */*/*.co */*/*.ao *.img *.bin > /dev/null 2> /dev/null || true
