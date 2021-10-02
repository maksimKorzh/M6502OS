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
%define                 PROCEDURES 0x7e0                    ; global procedures address
%define                 clear_screen 0x0004                 ; clear screen procedure local offset
%define                 print_string 0x0016                 ; print string procedure local offset
%define                 print_memory 0x0029                 ; hex to ascii procedure local offset
%define                 print_byte 0x0067                   ; print byte procedure local offset
%define                 print_word 0x0081                   ; print word procedure local offset
;==========================================================================================================
;                                                 OPCODES
;==========================================================================================================
;----------------------------------------------------------------------------------------------------------
;                                             LOAD OPERATIONS
;----------------------------------------------------------------------------------------------------------
%define                 INS_LDA_IM 0xA9
%define                 INS_LDA_ZP 0xA5
%define                 INS_LDA_ZPX 0xB5
%define                 INS_LDA_ABS 0xAD
%define                 INS_LDA_ABSX 0xBD
%define                 INS_LDA_ABSY 0xB9
%define                 INS_LDA_INDX 0xA1
%define                 INS_LDA_INDY 0xB1
;----------------------------------------------------------------------------------------------------------
%define                 INS_LDX_IM 0xA2
%define                 INS_LDX_ZP 0xA6
%define                 INS_LDX_ZPY 0xB6
%define                 INS_LDX_ABS 0xAE
%define                 INS_LDX_ABSY 0xBE
;----------------------------------------------------------------------------------------------------------
%define                 INS_LDY_IM 0xA0
%define                 INS_LDY_ZP 0xA4
%define                 INS_LDY_ZPX 0xB4
%define                 INS_LDY_ABS 0xAC
%define                 INS_LDY_ABSX 0xBC
;----------------------------------------------------------------------------------------------------------
;                                             SET OPERATIONS
;----------------------------------------------------------------------------------------------------------
%define                 INS_STA_ZP 0x85
%define                 INS_STA_ZPX 0x95
%define                 INS_STA_ABS 0x8D
%define                 INS_STA_ABSX 0x9D
%define                 INS_STA_ABSY 0x99
%define                 INS_STA_INDX 0x81
%define                 INS_STA_INDY 0x91
;----------------------------------------------------------------------------------------------------------
%define                 INS_STX_ZP 0x86
%define                 INS_STX_ZPY 0x96
%define                 INS_STX_ABS 0x8E
;----------------------------------------------------------------------------------------------------------
%define                 INS_STY_ZP 0x84
%define                 INS_STY_ZPX 0x94
%define                 INS_STY_ABS 0x8C
;----------------------------------------------------------------------------------------------------------
;                                            STACK OPERATIONS
;----------------------------------------------------------------------------------------------------------
%define                 INS_TXS 0x9A
%define                 INS_PHA 0x48
%define                 INS_PLA 0x68
%define                 INS_PHP 0x08
%define                 INS_PLP 0x28
;----------------------------------------------------------------------------------------------------------
;                                    INDIRECT JUMP & FUNCTION CALLS
;----------------------------------------------------------------------------------------------------------
%define                 INS_JMP_IND 0x6C
%define                 INS_JSR 0x20
%define                 INS_RTS 0x60
;----------------------------------------------------------------------------------------------------------
;                                           LOGICAL OPERATIONS
;----------------------------------------------------------------------------------------------------------
%define                 INS_AND_IM 0x29
%define                 INS_AND_ZP 0x25
%define                 INS_AND_ZPX 0x35
%define                 INS_AND_ABS 0x2D
%define                 INS_AND_ABSX 0x3D
%define                 INS_AND_ABSY 0x39
%define                 INS_AND_INDX 0x21
%define                 INS_AND_INDY 0x31
;----------------------------------------------------------------------------------------------------------
%define                 INS_ORA_IM 0x09
%define                 INS_ORA_ZP 0x05
%define                 INS_ORA_ZPX 0x15
%define                 INS_ORA_ABS 0x0D
%define                 INS_ORA_ABSX 0x1D
%define                 INS_ORA_ABSY 0x19
%define                 INS_ORA_INDX 0x01
%define                 INS_ORA_INDY 0x11
;----------------------------------------------------------------------------------------------------------
%define                 INS_EOR_IM 0x49
%define                 INS_EOR_ZP  0x45
%define                 INS_EOR_ZPX 0x55
%define                 INS_EOR_ABS 0x4D
%define                 INS_EOR_ABSX 0x5D
%define                 INS_EOR_ABSY 0x59
%define                 INS_EOR_INDX 0x41
%define                 INS_EOR_INDY 0x51
;----------------------------------------------------------------------------------------------------------
%define                 INS_BIT_ZP 0x24
%define                 INS_BIT_ABS 0x2C
;----------------------------------------------------------------------------------------------------------
;                                           TRANSFER REGISTERS
;----------------------------------------------------------------------------------------------------------
%define                 INS_TAX 0xAA
%define                 INS_TAY 0xA8
%define                 INS_TXA 0x8A
%define                 INS_TYA 0x98
;----------------------------------------------------------------------------------------------------------
;                                         INCREMENTS/DECREMENTS
;----------------------------------------------------------------------------------------------------------
%define                 INS_INX 0xE8
%define                 INS_INY 0xC8
%define                 INS_DEY 0x88
%define                 INS_DEX 0xCA
;----------------------------------------------------------------------------------------------------------
%define                 INS_DEC_ZP 0xC6
%define                 INS_DEC_ZPX 0xD6
%define                 INS_DEC_ABS 0xCE
%define                 INS_DEC_ABSX 0xDE
;----------------------------------------------------------------------------------------------------------
%define                 INS_INC_ZP 0xE6
%define                 INS_INC_ZPX 0xF6
%define                 INS_INC_ABS 0xEE
%define                 INS_INC_ABSX 0xFE
;----------------------------------------------------------------------------------------------------------
;                                               BRANCHES
;----------------------------------------------------------------------------------------------------------
%define                 INS_BEQ 0xF0
%define                 INS_BNE 0xD0
%define                 INS_BCS 0xB0
%define                 INS_BCC 0x90
%define                 INS_BMI 0x30
%define                 INS_BPL 0x10
%define                 INS_BVC 0x50
%define                 INS_BVS 0x70
;----------------------------------------------------------------------------------------------------------
;                                          STATUS FLAG CHANGES
;----------------------------------------------------------------------------------------------------------
%define                 INS_CLC 0x18
%define                 INS_SEC 0x38
%define                 INS_CLD 0xD8
%define                 INS_SED 0xF8
%define                 INS_CLI 0x58
%define                 INS_SEI 0x78
%define                 INS_CLV 0xB8
;----------------------------------------------------------------------------------------------------------
;                                              ARITHMETIC
;----------------------------------------------------------------------------------------------------------
%define                 INS_ADC 0x69
%define                 INS_ADC_ZP 0x65
%define                 INS_ADC_ZPX 0x75
%define                 INS_ADC_ABS 0x6D
%define                 INS_ADC_ABSX 0x7D
%define                 INS_ADC_ABSY 0x79
%define                 INS_ADC_INDX 0x61
%define                 INS_ADC_INDY 0x71
;----------------------------------------------------------------------------------------------------------
%define                 INS_SBC 0xE9
%define                 INS_SBC_ABS 0xED
%define                 INS_SBC_ZP 0xE5
%define                 INS_SBC_ZPX 0xF5
%define                 INS_SBC_ABSX 0xFD
%define                 INS_SBC_ABSY 0xF9
%define                 INS_SBC_INDX 0xE1
%define                 INS_SBC_INDY 0xF1
;----------------------------------------------------------------------------------------------------------
;                                          REGISTER COMPARISON
;----------------------------------------------------------------------------------------------------------
%define                 INS_CMP 0xC9
%define                 INS_CMP_ZP 0xC5
%define                 INS_CMP_ZPX 0xD5
%define                 INS_CMP_ABS 0xCD
%define                 INS_CMP_ABSX 0xDD
%define                 INS_CMP_ABSY 0xD9
%define                 INS_CMP_INDX 0xC1
%define                 INS_CMP_INDY 0xD1
;----------------------------------------------------------------------------------------------------------
%define                 INS_CPX 0xE0
%define                 INS_CPY 0xC0
%define                 INS_CPX_ZP 0xE4
%define                 INS_CPY_ZP 0xC4
%define                 INS_CPX_ABS 0xEC
;----------------------------------------------------------------------------------------------------------
;                                              BIT SHIFTS
;----------------------------------------------------------------------------------------------------------
%define                 INS_ASL 0x0A
%define                 INS_ASL_ZP 0x06
%define                 INS_ASL_ZPX 0x16
%define                 INS_ASL_ABS 0x0E
%define                 INS_ASL_ABSX 0x1E
;----------------------------------------------------------------------------------------------------------
%define                 INS_LSR 0x4A
%define                 INS_LSR_ZP 0x46
%define                 INS_LSR_ZPX 0x56
%define                 INS_LSR_ABS 0x4E
%define                 INS_LSR_ABSX 0x5E
;----------------------------------------------------------------------------------------------------------
%define                 INS_ROL 0x2A
%define                 INS_ROL_ZP 0x26
%define                 INS_ROL_ZPX 0x36
%define                 INS_ROL_ABS 0x2E
%define                 INS_ROL_ABSX 0x3E
;----------------------------------------------------------------------------------------------------------
%define                 INS_ROR 0x6A
%define                 INS_ROR_ZP 0x66
%define                 INS_ROR_ZPX 0x76
%define                 INS_ROR_ABS 0x6E
%define                 INS_ROR_ABSX 0x7E
;----------------------------------------------------------------------------------------------------------
;                                                MISC
;----------------------------------------------------------------------------------------------------------
%define                 INS_NOP 0xEA
%define                 INS_BRK 0x00
%define                 INS_RTI 0x40
;==========================================================================================================
;                                                 CPU
;==========================================================================================================
start:                  mov ax, cs                          ; init AX (BOOTSECTOR)
                        mov ds, ax                          ; hook up local variable addresses
                        call PROCEDURES:clear_screen        ; init 40 x 25 text video mode
;----------------------------------------------------------------------------------------------------------

call reset_cpu
call reset_memory
mov si, 0xe000
mov di, 0xffff
call print_memory_range
mov si, new_line
call PROCEDURES:print_string
call print_debug_info


jmp $
;----------------------------------------------------------------------------------------------------------
;                                   RESET MEMORY - ARGS: none
;----------------------------------------------------------------------------------------------------------
reset_memory:           mov di, 0xe000                      ; point DI to simulated memory starting point
                        mov si, 0xffff                      ; point SI to simulated memory end point
                        call reset_memory_range             ; reset simulated memory
                        ret                                 ; return from procedure
;----------------------------------------------------------------------------------------------------------
;                                     RESET CPU - ARGS: none
;----------------------------------------------------------------------------------------------------------
reset_cpu:              mov byte [register_A], 0x00         ; reset register A
                        mov byte [register_X], 0x00         ; reset register X
                        mov byte [register_Y], 0x00         ; reset register Y
                        mov byte [register_P], 0x20         ; reset processor flags (NV-BDIZC)
                        mov byte [stack_pointer], 0xff      ; reset stack pointer
                        mov word [program_counter], 0xE600  ; reset program counter
                        ret                                 ; return from procedure
;----------------------------------------------------------------------------------------------------------
;                   RESET MEMORY RANGE - ARGS: DI-start address, SI-end address
;----------------------------------------------------------------------------------------------------------
reset_memory_range:     push ds                             ; preserve DS
                        push es                             ; preserve ES
                        xor ax, ax                          ; set AX to 0
                        mov ds, ax                          ; set DS to 0
                        mov es, ax                          ; set ES to 0
                        mov al, 0x00                        ; reset value
reset_next_byte:        cmp di, si                          ; any more bytes to reset?
                        jg reset_memory_return              ; if not then stop
                        stosb                               ; set byte value at [ES:DI] to 0
                        jmp reset_next_byte                 ; otherwise reset next byte
reset_memory_return:    pop es                              ; restore ES
                        pop ds                              ; restore DS
                        ret                                 ; return from procedure
;----------------------------------------------------------------------------------------------------------
;                   PRINT MEMORY RANGE - ARGS: SI-start address, DI-end address
;----------------------------------------------------------------------------------------------------------
print_memory_range:     push ds                             ; preserve DS
                        push es                             ; preserve ES
                        xor ax, ax                          ; set AX to 0
                        mov ds, ax                          ; set DS to 0
                        mov es, ax                          ; set ES to 0
print_range_next_line:  cmp si, di                          ; any more lines to print?
                        jge  print_range_return             ; if not then stop
                        call PROCEDURES:print_memory        ; print 8 bytes
                        jmp print_range_next_line           ; otherwise continue 
print_range_return:     pop es                              ; restore ES
                        pop ds                              ; restore DS
                        ret                                 ; return from procedure
;----------------------------------------------------------------------------------------------------------
;                                  PRINT DEBUG INFO - ARGS: none
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
;                                             REGISTERS
;==========================================================================================================
register_A              db 0x00                             ; register A
register_X              db 0x00                             ; register X
register_Y              db 0x00                             ; register Y
register_P              db 0x20                             ; processor flags (NV-BDIZC)
stack_pointer           db 0xff                             ; stack pointer points to 0x01FF
program_counter         dw 0xE600                           ; address to get where the program code starts
;==========================================================================================================
;                                             VARIABLES
;==========================================================================================================
print_registers         db ' A  X  Y PF SP PC', 10, 13, 0  ; all register names
new_line                db 10, 13, 0                        ; new line
;---------------------------------------------------------------------------------------------------------
                        times 512 - ($-$$) db 0x00          ; BIOS bytes padding
;=========================================================================================================
