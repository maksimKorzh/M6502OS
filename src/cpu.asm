;==========================================================================================================
;----------------------------------------------------------------------------------------------------------
;
;                                     MOS 6502 processor simulator
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
%define        print_memory 0x0029                          ; hex to ascii procedure local offset
%define          print_byte 0x0067                          ; print byte procedure local offset
%define          print_word 0x0081                          ; print word procedure local offset
;==========================================================================================================
;                                                  CPU
;==========================================================================================================
start:                  mov ax, cs                          ; init AX (BOOTSECTOR)
                        mov ds, ax                          ; hook up local variable addresses
                        call PROCEDURES:clear_screen        ; init 40 x 25 text video mode
;----------------------------------------------------------------------------------------------------------


call print_debug_info
call print_debug_info
call print_debug_info
call print_debug_info
call PROCEDURES:print_memory

jmp $
;----------------------------------------------------------------------------------------------------------
print_debug_info:       mov si, print_registers             ; point SI to register names
                        call PROCEDURES:print_string        ; print register names
                        mov al, byte [register_A]           ; move value of A register to AL
                        call PROCEDURES:print_byte          ; print value of A register
                        mov al, byte [register_X]           ; move value of X register to AL
                        call PROCEDURES:print_byte          ; print value of X register
                        mov al, byte [register_Y]           ; move value of Y register to AL
                        call PROCEDURES:print_byte          ; print value of Y register
                        mov al, byte [register_P]           ; move value of processor flags to AL
                        call PROCEDURES:print_byte          ; print processor flags
                        mov al, byte [stack_pointer]        ; move value of stack pointer to AL
                        call PROCEDURES:print_byte          ; print stack pointer
                        mov ax, word [program_counter]      ; move value of program counter to AL
                        call PROCEDURES:print_word          ; print program counter
                        mov si, new_line                    ; point SI to new_line variable
                        call PROCEDURES:print_string        ; print new line
                        ret                                 ; return from procedure
;==========================================================================================================
;                                               REGISTERS
;==========================================================================================================
register_A              db 0x00                             ; register A
register_X              db 0x00                             ; register B
register_Y              db 0x00                             ; register C
register_P              db 0x00                             ; processor flags (NV-BDIZC)
stack_pointer           db 0x00                             ; stack pointer points to 0x01FF
program_counter         dw 0x0000                           ; address to get where the program code starts
;==========================================================================================================
;                                               VARIABLES
;==========================================================================================================
print_registers         db ' A  X  Y PF SP PC', 10, 13, 0  ; all register names
new_line                db 10, 13, 0                        ; new line
;---------------------------------------------------------------------------------------------------------
                        times 512 - ($-$$) db 0x00          ; BIOS bytes padding
;=========================================================================================================
