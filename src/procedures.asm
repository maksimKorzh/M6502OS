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
print_string:           cld                                 ; SI points to string to print
print_string_next:      lodsb                               ; read next byte from SOURCE INDEX register
                        mov ah, 0x0e                        ; BIOS code for teletype output
                        cmp al, 0                           ; match the zero terminating char of the string
                        je print_string_return              ; return if string doesn't contain any chars any more
                        call set_attribute                  ; make character light green
                        int 0x10                            ; assuming ah = 0x0e int 0x10 would print a single char
                        jmp print_string_next               ; repeat printing char until string is fully printed
print_string_return:    
                        call set_attribute                  ; make cursor light green
                        retf                                ; return from procedure
;----------------------------------------------------------------------------------------------------------
print_memory:           cld                                 ; SI holds the starting address
                        call print_address                  ; print hex value stored at SI
                        mov ax, 0x0e3a                      ; colon character
                        int 0x10                            ; print it
                        mov ax, 0x0e20                      ; space character
                        int 0x10                            ; print it
                        mov ch, 0                           ; CH serves as a byte counter, init it
print_memory_next:      lodsb                               ; read next byte where SI is pointing to, increment SI register
                        cmp ch, 8                           ; is there any more bytes left to print
                        je print_memory_return              ; go to .continue label
                        mov dl, al                          ; temp store AL to DL
                        and al, 0xf0                        ; extract 1st nibble => 0xF0 => 1111 0000
                        shr al, 4                           ; shift 1st nibble 4 bits to the right 1111 0000 => 0000 1111
                        call print_hex                      ; print 1st nibble
                        mov al, dl                          ; restore byte value from cl back to al
                        and al, 0x0f                        ; extract 2nd nibble => 0x0F => 0000 1111
                        call print_hex                      ; print 2nd nibble
                        mov ax, 0x0e20                      ; space character
                        int 0x10                            ; print it
                        inc ch                              ; increment byte counter
                        jmp print_memory_next               ; process next byte
print_memory_return:    mov ax, 0x0e0a                      ; new line character
                        int 0x10                            ; print it
                        mov ax, 0x0e0d                      ; carriage return
                        int 0x10                            ; print it
                        call set_attribute                  ; ensure cursor is green
                        retf                                ; return to edit loop
;----------------------------------------------------------------------------------------------------------
print_byte:             mov dl, al                          ; AL holds the argument to print
                        and al, 0xf0                        ; extract 1st nibble => 0xF0 => 1111 0000
                        shr al, 4                           ; shift 1st nibble 4 bits to the right 1111 0000 => 0000 1111
                        call print_hex                      ; print 1st nibble
                        mov al, dl                          ; restore byte value from cl back to al
                        and al, 0x0f                        ; extract 2nd nibble => 0x0F => 0000 1111
                        call print_hex                      ; print 2nd nibble
                        mov ax, 0x0e20                      ; space character
                        int 0x10                            ; print it
                        call set_attribute                  ; ensure cursor is green
                        retf                                ; return from procedure
;----------------------------------------------------------------------------------------------------------
print_word:             mov si, ax                          ; AX holds the argument to print
                        call print_address                  ; print word at DS:SI
                        call set_attribute                  ; ensure cursor is green
                        retf                                ; return from the procedure
;==========================================================================================================
;                                              LOCAL PROCEDURES
;==========================================================================================================
set_attribute:          push ax                             ; preserve character to print in stack
                        xor ax, ax                          ; reset AX
                        mov ah, 0x09                        ; write character and attribute at cursor position
                        mov bl, 0x0a                        ; green character on black background
                        int 0x10                            ; set character attribute
                        pop ax                              ; restore character to print from stack
                        ret                                 ; return to the procedure
;----------------------------------------------------------------------------------------------------------
print_hex:              cmp al, 10                          ; distinguish between digits and letters
                        jl digit_to_ascii                   ; convert digit
                        cmp al, 10                          ; distinguish between digits and letters
                        jge letter_to_ascii                 ; convert letter  
digit_to_ascii:         add al, '0'                         ; convert integer to character (digits 0-9)
                        jmp print_nibble                    ; go and print it
letter_to_ascii:        add al, 'A' - 10                    ; convert integer to character (letters A-F)
                        jmp print_nibble                    ; go and print it
print_nibble:           call set_attribute                  ; make character light green
                        mov ah, 0x0e                        ; BIOS code to print a char
                        int 0x10                            ; print character to screen
                        ret                                 ; return from the procedure
;----------------------------------------------------------------------------------------------------------
print_address:          mov dx, si                          ; preserve address stored in SI to DX
                        mov ax, dx                          ; transfer address from DX to AX
                        and ax, 0xf000                      ; mask 1st digit of address
                        shr ax, 12                          ; shift right the rest of address
                        call print_hex                      ; print 1st digit of address
                        mov ax, dx                          ; transfer address from DX to AX
                        and ax, 0x0f00                      ; mask 2nd digit of address
                        shr ax, 8                           ; shift right the rest of address
                        call print_hex                      ; print 2nd digit of address
                        mov ax, dx                          ; transfer address from DX to AX
                        and ax, 0x00f0                      ; mask 3rd digit of address
                        shr ax, 4                           ; shift right the rest of address
                        call print_hex                      ; print 3rd digit of address
                        mov ax, dx                          ; transfer address from DX to AX
                        and ax, 0x000f                      ; shift right the rest of address
                        call print_hex                      ; print 4th digit of address
                        ret                                 ; return from procedure
;==========================================================================================================
;                                                  VARIABLES
;==========================================================================================================
read_error_message:     db 'Failed to load sector!'         ; read sector error message
;---------------------------------------------------------------------------------------------------------
                        times 512 - ($-$$) db 0x00          ; BIOS bytes padding
;==========================================================================================================

