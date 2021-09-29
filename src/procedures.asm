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
%define          BOOTSECTOR 0x7c00                          ; boot sector address in RAM
%define          PROCEDURES 0x7e00                          ; global procedures address
%define           SIMULATOR 0x7d00                          ; CPU simulator address
;==========================================================================================================
;                                             GLOBAL PROCEDURES
;==========================================================================================================
start:                  mov ax, cs                          ; init AX (BOOTSECTOR)
                        mov ds, ax                          ; hook up local variable addresses
;----------------------------------------------------------------------------------------------------------
clear_screen:           xor ax, ax                          ; reset AX register
                     	mov ax, 0x0001                      ; set text-mode cursor shape
                        int 0x10                            ; (AX=0x0000) set video mode 40 x 25 text mode
                        mov ah, 0x01                        ; BIOS code to set cursor shape
                        mov cx, 0x0007                      ; set block cursor
                     	int 0x10                            ; update cursor
                        call set_attribute                  ; make character light green
                        retf                                ; return from procedure
;----------------------------------------------------------------------------------------------------------
print_string:           cld                                 ; clear direction flag
print_byte:             lodsb                               ; read next byte from SOURCE INDEX register
                        mov ah, 0x0e                        ; BIOS code for teletype output
                        cmp al, 0                           ; match the zero terminating char of the string
                        je print_return                     ; return if string doesn't contain any chars any more
                        call set_attribute                  ; make character light green
                        int 0x10                            ; assuming ah = 0x0e int 0x10 would print a single char
                        jmp print_byte                      ; repeat printing char until string is fully printed
print_return:           retf                                ; return from procedure
;----------------------------------------------------------------------------------------------------------
hex_to_ascii:           cmp al, 10                          ; distinguish between digits and letters
                        jl digit_to_ascii                   ; convert digit
                        cmp al, 10                          ; distinguish between digits and letters
                        jge letter_to_ascii                 ; convert letter  
digit_to_ascii:         add al, '0'                         ; convert integer to character (digits 0-9)
                        jmp print_nibble                    ; go and print it
letter_to_ascii:        add al, 'A' - 10                    ; convert integer to character (letters A-F)
                        jmp print_nibble                    ; go and print it
print_nibble:           mov ah, 0x0e                        ; BIOS code to print a char
                        int 0x10                            ; print character to screen
                        call set_attribute                  ; make character light green
                        retf                                ; return from the procedure
;----------------------------------------------------------------------------------------------------------

;----------------------------------------------------------------------------------------------------------
set_attribute:          push ax                             ; preserve character to print in stack
                        xor ax, ax                          ; reset AX
                        mov ah, 0x09                        ; write character and attribute at cursor position
                        mov bl, 0x0a                        ; green character on black background
                        int 0x10                            ; set character attribute
                        pop ax                              ; restore character to print from stack
                        ret                                 ; return to the procedure
;----------------------------------------------------------------------------------------------------------
read_error_message:     db 'Failed to load sector!'         ; read sector error message
;---------------------------------------------------------------------------------------------------------
                        times 512 - ($-$$) db 0x00          ; BIOS bytes padding
;==========================================================================================================

