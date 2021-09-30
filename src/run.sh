# assemble files
nasm -f bin boot.asm -o boot.bin
nasm -f bin procedures.asm -o procedures.bin
nasm -f bin cpu.asm -o cpu.bin

# create bytes padding
dd if=/dev/zero of=floppy.img count=2880 bs=512

# create bootable image
cat boot.bin procedures.bin cpu.bin floppy.img > M6502OS.img

# clean up files
#rm -f boot.bin procedures.bin cpu.bin floppy.img

# run qemu
qemu-system-i386 -hda M6502OS.img

