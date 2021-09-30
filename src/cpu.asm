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
%define          PROCEDURES 0x7e00                          ; global procedures address
%define        clear_screen 0x0004                          ; clear screen procedure local offset
%define        print_string 0x0016                          ; print string procedure local offset
%define        print_memory 0x0026                          ; hex to ascii procedure local offset
;==========================================================================================================
;                                                  CPU
;==========================================================================================================
start:                  mov ax, cs                          ; init AX (BOOTSECTOR)
                        mov ds, ax                          ; hook up local variable addresses
                        call PROCEDURES:clear_screen        ; init 40 x 25 text video mode
;----------------------------------------------------------------------------------------------------------

;mov si, text
;call PROCEDURES:print_string

mov ax, 0x7c00
mov ax, es
mov di, 0x00
mov ax, 0x1234
stosw
mov ax, 0xabcd
stosw




push ds
xor ax,ax
mov ds,ax
mov si, 0x7c00
call PROCEDURES:print_memory
pop ds




jmp $
text db 'hello',10,13,0
;==========================================================================================================
;                                               REGISTERS
;==========================================================================================================
register_a              db 0                                ; register A
register_x              db 0                                ; register B
register_y              db 0                                ; register C
register_p              db 0x20                             ; processor flags (NV-BDIZC)
stack_pointer           db 0xff                             ; stack pointer points to 0x01FF
program_counter         dw 0x0000                           ; address to get where the program code starts
;---------------------------------------------------------------------------------------------------------
                        times 512 - ($-$$) db 0x00          ; BIOS bytes padding
;=========================================================================================================
