# assemble files
nasm -f bin boot.asm -o boot.bin
nasm -f bin procedures.asm -o procedures.bin
nasm -f bin cpu.asm -o cpu.bin

# create bootable image
cat boot.bin procedures.bin cpu.bin > M6502OS.img

# clean up files
rm -f boot.bin procedures.bin cpu.bin

# run qemu
qemu-system-i386 -hda M6502OS.img

