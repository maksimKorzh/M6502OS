;==========================================================================================================
;----------------------------------------------------------------------------------------------------------
;
;                                      MOS 6502 processor simulator
;
;                                                   by
;
;                                            Code Monkey King
;
;----------------------------------------------------------------------------------------------------------
;==========================================================================================================
[bits 16]                                                   ; assemble 16-bit code
[org 0x0000]                                                ; local variable offset
;==========================================================================================================
;                                            GLOBAL DEFINITIONS
;==========================================================================================================
%define          BOOTSECTOR 0x7c0                           ; boot sector address in RAM
%define          PROCEDURES 0x7e0                           ; global procedures address
%define           SIMULATOR 0x1000                          ; CPU simulator address
;==========================================================================================================
;                                                BOOTLOADER
;==========================================================================================================
start:                  mov ax, cs                          ; init AX (BOOTSECTOR)
                        mov ds, ax                          ; hook up local variable addresses
stack:                  mov ss, ax                          ; set STACK SEGMENT to 0
                        mov bp, BOOTSECTOR                  ; set STACK BASE to 0x0000_7c00
                        mov sp, bp                          ; set STACK POINTER to 0x0000_7c00
;----------------------------------------------------------------------------------------------------------
load_procedures:        mov ax, PROCEDURES                  ; init AX segment
                        mov es, ax                          ; init ES register
                        mov bx, 0                           ; init local offset within the segment
                        mov cl, 2                           ; starting sector to load data from
                        mov al, 1                           ; number of sectors to read
                        call boot_load_sector               ; read sector from USB flash drive
;----------------------------------------------------------------------------------------------------------
load_simulator:         mov ax, SIMULATOR                   ; init AX segment
                        mov es, ax                          ; init ES register
                        mov bx, 0                           ; init local offset within the segment
                        mov cl, 3                           ; starting sector to load data from
                        mov al, 10                          ; number of sectors to read
                        call boot_load_sector               ; read sector from USB flash drive
;----------------------------------------------------------------------------------------------------------
run_simulator:          jmp SIMULATOR:0x0000                ; jump to SIMULATOR simulator code in RAM
;----------------------------------------------------------------------------------------------------------
boot_load_sector:       mov ah, 0x02                        ; BIOS code to READ from storage device
                        mov ch, 0                           ; specify celinder
                        mov dh, 0                           ; specify head
                        mov dl, 0x80                        ; specify HDD code
                        int 0x13                            ; read the sector from USB flash drive
                        ret                                 ; return from procedure
;---------------------------------------------------------------------------------------------------------
                        times 510 - ($-$$) db 0x00          ; BIOS bytes padding
                        dw 0xaa55                           ; BIOS boot signature
;==========================================================================================================
