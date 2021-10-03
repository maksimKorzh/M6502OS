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
;----------------------------------------------------------------------------------------------------------
;                                                PROCEDURES
;----------------------------------------------------------------------------------------------------------
%define                 PROCEDURES 0x7e0                    ; global procedures address
%define                 clear_screen 0x0004                 ; clear screen procedure local offset
%define                 print_string 0x0016                 ; print string procedure local offset
%define                 print_memory 0x0029                 ; hex to ascii procedure local offset
%define                 print_byte 0x0067                   ; print byte procedure local offset
%define                 print_word 0x0081                   ; print word procedure local offset
;----------------------------------------------------------------------------------------------------------
;                                                   LOCALS
;----------------------------------------------------------------------------------------------------------
%define                 PROGRAM 0xe600                      ; temp starting point for a 6502 program
%define                 MEMORY 0xe000                       ; 6502 simulated memory starting address
;==========================================================================================================
;                                                 OPCODES
;==========================================================================================================
;----------------------------------------------------------------------------------------------------------
;                                             LOAD OPERATIONS
;----------------------------------------------------------------------------------------------------------
%define                 INS_LDA_IM 0xa9
%define                 INS_LDA_ZP 0xa5
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
start:                  mov ax, cs                          ; init AX (CPU address)
                        mov ds, ax                          ; hook up local variable addresses
                        call PROCEDURES:clear_screen        ; init 40 x 25 text video mode
;----------------------------------------------------------------------------------------------------------

call unit_tests
jmp $

;==========================================================================================================
;                                             UNIT TESTING
;==========================================================================================================
;----------------------------------------------------------------------------------------------------------
;                                    LDA - immediate addressing mode
;----------------------------------------------------------------------------------------------------------

                        ;mov si, new_line                    ; point SI to new line
                        ;call PROCEDURES:print_string        ; print new line
                        ;mov si, memory_monitor              ; point SI to memory_monitor string
                        ;call PROCEDURES:print_string        ; print memory_monitor string
                        ;mov si, MEMORY                      ; 6502 memory range starting point
                        ;mov di, MEMORY + 0x28               ; 6502 memory range end point
                        ;call print_memory_range             ; print 6502 memory bytes


; LDA IMMEDIATE            
                        ; LDA ZERO PAGE
                        ;db 0xa5, 0x00                       ; LDA #$12
                        ;db 0xa5, 0x01                       ; LDA #$12
                        ;db 0xa5, 0x02                       ; LDA #$12
                        ;db 0xa5, 0x03                       ; LDA #$12
                        ;db 0xff                             ; program end

                        ;mov word [test_program + 6], 0x65a9 ; LDA #$65

unit_tests:             call reset_cpu                      ; reset 6502 CPU
                        call reset_memory                   ; reset 6502 memory
;----------------------------------------------------------------------------------------------------------
test_001:               mov byte [register_P], 0xa2         ; set zero and negative flags to true
                        mov word [test_program], 0x24a9     ; LDA #$00
                        mov si, test_program                ; point SI to test program
                        call load_program                   ; load test program to 6502 memory
                        mov si, test_lda_imm                ; point SI to test_lda_imm
                        call PROCEDURES:print_string        ; print test_lda_imm string
                        mov si, machine_code                ; point SI to machine_code string
                        call PROCEDURES:print_string        ; print machine code string
                        mov si, PROGRAM                     ; 6502 memory range starting point
                        mov di, PROGRAM + 0x08              ; 6502 memory range end point
                        call print_memory_range             ; print 6502 program source bytes
                        mov si, cpu_before_execution        ; point SI to cpu_before_execution string
                        call PROCEDURES:print_string        ; print cpu_before_execution
                        call print_debug_info               ; print registers
                        call execute                        ; execute instruction
                        mov si, cpu_after_execution         ; point SI to cpu_after_execution string
                        call PROCEDURES:print_string        ; print cpu_after_execution
                        call print_debug_info               ; print registers
                        cmp byte [register_A], 0x24         ; test A register
                        jne test_error_register             ; failure case, stop tests
                        cmp byte [register_P], 0x20         ; test processor flags
                        jne test_error_flags                ; failure case, stop tests
                        cmp byte [program_counter], 0x02    ; test program counter
                        jne test_error_pc                   ; failure case, stop tests
                        mov si, test_passed                 ; point SI to test_passed string
                        call PROCEDURES:print_string        ; print test_passed string
                        jmp test_002                        ; jump to next test
;----------------------------------------------------------------------------------------------------------
test_002:               mov word [test_program], 0x00a9     ; LDA #$24
                        mov si, test_program                ; point SI to test program
                        call load_program                   ; load test program to 6502 memory
                        mov si, test_lda_imm                ; point SI to test_lda_imm
                        call PROCEDURES:print_string        ; print test_lda_imm string
                        mov si, machine_code                ; point SI to machine_code string
                        call PROCEDURES:print_string        ; print machine code string
                        mov si, PROGRAM                     ; 6502 memory range starting point
                        mov di, PROGRAM + 0x08              ; 6502 memory range end point
                        call print_memory_range             ; print 6502 program source bytes
                        mov si, cpu_before_execution        ; point SI to cpu_before_execution string
                        call PROCEDURES:print_string        ; print cpu_before_execution
                        call print_debug_info               ; print registers
                        call execute                        ; execute instruction
                        mov si, cpu_after_execution         ; point SI to cpu_after_execution string
                        call PROCEDURES:print_string        ; print cpu_after_execution
                        call print_debug_info               ; print registers
                        cmp byte [register_A], 0x00         ; test A register
                        jne test_error_register             ; failure case, stop tests
                        cmp byte [register_P], 0x22         ; test processor flags
                        jne test_error_flags                ; failure case, stop tests
                        cmp byte [program_counter], 0x04    ; test program counter
                        jne test_error_pc                   ; failure case, stop tests
                        mov si, test_passed                 ; point SI to test_passed string
                        call PROCEDURES:print_string        ; print test_passed string
                        jmp test_003                        ; jump to next test
;----------------------------------------------------------------------------------------------------------
test_003:               mov word [test_program], 0xe5a9     ; LDA #$e5
                        mov si, test_program                ; point SI to test program
                        call load_program                   ; load test program to 6502 memory
                        mov si, test_lda_imm                ; point SI to test_lda_imm
                        call PROCEDURES:print_string        ; print test_lda_imm string
                        mov si, machine_code                ; point SI to machine_code string
                        call PROCEDURES:print_string        ; print machine code string
                        mov si, PROGRAM                     ; 6502 memory range starting point
                        mov di, PROGRAM + 0x08              ; 6502 memory range end point
                        call print_memory_range             ; print 6502 program source bytes
                        mov si, cpu_before_execution        ; point SI to cpu_before_execution string
                        call PROCEDURES:print_string        ; print cpu_before_execution
                        call print_debug_info               ; print registers
                        call execute                        ; execute instruction
                        mov si, cpu_after_execution         ; point SI to cpu_after_execution string
                        call PROCEDURES:print_string        ; print cpu_after_execution
                        call print_debug_info               ; print registers
                        cmp byte [register_A], 0xe5         ; test A register
                        jne test_error_register             ; failure case, stop tests
                        cmp byte [register_P], 0xa0         ; test processor flags
                        jne test_error_flags                ; failure case, stop tests
                        cmp byte [program_counter], 0x06    ; test program counter
                        jne test_error_pc                   ; failure case, stop tests
                        mov si, test_passed                 ; point SI to test_passed string
                        call PROCEDURES:print_string        ; print test_passed string
                        jmp test_004                        ; jump to next test
;----------------------------------------------------------------------------------------------------------
test_004:
;----------------------------------------------------------------------------------------------------------
tests_completed:        mov si, all_done                    ; point SI to success message
                        call PROCEDURES:print_string        ; print success message
                        ret                                 ; return from procedure
;----------------------------------------------------------------------------------------------------------
test_error_register:    mov si, test_failed_register        ; point SI to test_failed_register string
                        call PROCEDURES:print_string        ; print test_failed_register message
                        jmp $                               ; stop here
;----------------------------------------------------------------------------------------------------------
test_error_flags:       mov si, test_failed_flags           ; point SI to test_failed_flag string
                        call PROCEDURES:print_string        ; print test_failed_flags message
                        jmp $                               ; stop here
;----------------------------------------------------------------------------------------------------------
test_error_sp:          mov si, test_failed_SP              ; point SI to test_failed_SP string
                        call PROCEDURES:print_string        ; print test_failed_sp message
                        jmp $                               ; stop here
;----------------------------------------------------------------------------------------------------------
test_error_pc:          mov si, test_failed_PC              ; point SI to test_failed_PC string
                        call PROCEDURES:print_string        ; print test_failed_pc message
                        jmp $                               ; stop here
;----------------------------------------------------------------------------------------------------------

                        ;push es
                        ;xor ax, ax
                        ;mov es, ax
                        ;mov di, MEMORY

                        ;mov al, 0x23
                        ;stosb

                        ;mov al, 0xe3
                        ;stosb

                        ;mov al, 0x00
                        ;stosb

                        ;mov al, 0x45
                        ;stosb

                        ;pop es



                        ;mov si, PROGRAM
                        ;mov di, PROGRAM + 0x28
                        ;call print_memory_range

                        ;mov si, new_line
                        ;call PROCEDURES:print_string

                        ;mov si, MEMORY
                        ;mov di, MEMORY + 0x28
                        ;call print_memory_range

                        ;call print_debug_info

                        ;call execute
;----------------------------------------------------------------------------------------------------------
;                                  EXECUTE 6502 program - ARGS: none
;----------------------------------------------------------------------------------------------------------
execute:                mov si, PROGRAM                     ; point SI to 6502 program
execute_next:           push ds                             ; preserve current file's variables scope
                        xor ax, ax                          ; reset AX
                        mov ds, ax                          ; reset DS
                        lodsb                               ; load next 6502 program's opcode
;----------------------------------------------------------------------------------------------------------
                        cmp al, INS_LDA_IM                  ; LDA immediate addressing opcode?
                        je lda_imm                          ; if so then execute it
                        cmp al, INS_LDA_ZP                  ; LDA zero page addressing opcode?
                        je lda_zp                           ; if so then execute it
                        cmp al, 0x00                        ; if no more instructions available
                        je execute_return                   ; then stop execution
                        jmp execute_error                   ; otherwise we've got an error
;----------------------------------------------------------------------------------------------------------
execute_debug:          ;call break                          ; break point every instruction (debug only)
                        jmp execute_next                    ; execute next instruction
;----------------------------------------------------------------------------------------------------------
execute_error:          pop ds
                        push ax                             ; preserve error byte value
                        mov si, new_line                    ; point SI to new line
                        call PROCEDURES:print_string        ; print new line
                        pop ax                              ; restore error byte value
                        call PROCEDURES:print_byte          ; print byte resulting in error
                        mov si, instruction_error           ; point SI to instruction error
                        call PROCEDURES:print_string        ; print error
                        ret
;----------------------------------------------------------------------------------------------------------
execute_return:         pop ds                              ; restore current file's variables scope
                        ret                                 ; return from procedure
;----------------------------------------------------------------------------------------------------------
;                                  LDA - immediate addressing mode
;----------------------------------------------------------------------------------------------------------
lda_imm:                lodsb                               ; AL now holds the immediate data to load
                        pop ds                              ; hook up local variables
                        call clear_zero_flag                ; clear zero flag
                        call clear_negative_flag            ; clear negative flag
                        add byte [program_counter], 0x02    ; update program counter
                        mov byte [register_A], al           ; load immediate data to A register
                        cmp al, 0x00                        ; if AL is equal to 0
                        je set_flags_szf                    ; then set zero flag
                        test al, 0x80                       ; test negative
                        jne set_flags_snf                   ; then set negative flag
                        jmp execute_debug                   ; execute next instruction
;----------------------------------------------------------------------------------------------------------
;                                        LDA - zero page mode
;----------------------------------------------------------------------------------------------------------
lda_zp:                 lodsb                               ; AL holds ZP address to load value from
                        pop ds                              ; hook up local variables
                        call clear_zero_flag                ; clear zero flag
                        call clear_negative_flag            ; clear negative flag
                        add byte [program_counter], 0x02    ; update program counter
                        xor ah, ah                          ; reset AX
                        add ax, MEMORY                      ; get ZP address in simulated memory
                        push ds                             ; preserve DS
                        push ax                             ; preserve ZP address
                        xor ax, ax                          ; reset AX
                        mov ds, ax                          ; reset DS
                        pop ax                              ; restore ZP address
                        push si                             ; preserve current 6502 program byte pointer
                        mov si, ax                          ; point SI to ZP address
                        lodsb                               ; get byte from ZP address
                        pop si                              ; restore current 6502 program byte pointer
                        pop ds                              ; hook up local variables
                        mov byte [register_A], al           ; load ZP data to A register
                        cmp al, 0x00                        ; if AL is equal to 0
                        je set_flags_szf                    ; then set zero flag
                        test al, 0x80                       ; test negative
                        jne set_flags_snf                   ; then set negative flag
                        jmp execute_debug                   ; execute next instruction
;----------------------------------------------------------------------------------------------------------
;                                     SET ZERO/NEGATIVE FLAGS
;----------------------------------------------------------------------------------------------------------
set_flags_szf:          call set_zero_flag                  ; set zero flag
                        jmp execute_debug                   ; resume execution
set_flags_snf:          call set_negative_flag              ; set negative flag
                        jmp execute_debug                   ; resume execution
;----------------------------------------------------------------------------------------------------------
;                                          CLEAR ZERO FLAG
;----------------------------------------------------------------------------------------------------------
clear_zero_flag:        and byte [register_P], 0xfd         ; set zero flag
                        ret                                 ; return from procedure
;----------------------------------------------------------------------------------------------------------
;                                        CLEAR NEGATIVE FLAG
;----------------------------------------------------------------------------------------------------------
clear_negative_flag:    and byte [register_P], 0x7f         ; set negative flag
                        ret                                 ; return from procedure
;----------------------------------------------------------------------------------------------------------
;                                           SET ZERO FLAG
;----------------------------------------------------------------------------------------------------------
set_zero_flag:          or byte [register_P], 0x02          ; set zero flag
                        ret                                 ; return from procedure
;----------------------------------------------------------------------------------------------------------
;                                         SET NEGATIVE FLAG
;----------------------------------------------------------------------------------------------------------
set_negative_flag:      or byte [register_P], 0x80          ; set negative flag
                        ret                                 ; return from procedure
;----------------------------------------------------------------------------------------------------------
;                                BREAK AFTER INSTRUCTION - ARGS: none
;----------------------------------------------------------------------------------------------------------
break:                  pusha                               ; preserve all registers
                        mov ah, 0x00                        ; BIOS code to take user input
                        int 0x16                            ; wait for a key stroke
                        call print_debug_info               ; print registers
                        popa                                ; restore all registers
                        ret                                 ; return from procedure
;----------------------------------------------------------------------------------------------------------
;                         LOAD 6502 program - ARGS: SI points to program bytes
;----------------------------------------------------------------------------------------------------------
load_program:           push es                             ; preserve ES
                        xor ax, ax                          ; set AX to 0
                        mov es, ax                          ; set ES to 0
                        mov di, PROGRAM                     ; point DI to 6502 program start
load_program_next_byte: lodsb                               ; read next program byte
                        cmp al, 0xff                        ; any more bytes to load?
                        je load_program_return              ; if not then stop
                        stosb                               ; write next program byte to simulated memory
                        jmp load_program_next_byte          ; otherwise reset next byte
load_program_return:    pop es                              ; restore ES
                        ret                                 ; return from procedure
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
                        mov word [program_counter], PROGRAM ; reset program counter
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
print_debug_info:       mov si, new_line                    ; point SI to new_line variable
                        call PROCEDURES:print_string        ; print new line
                        mov si, print_registers             ; point SI to register names
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
program_counter         dw PROGRAM                          ; address to get where the program code starts
;==========================================================================================================
;                                             MESSAGES
;==========================================================================================================
print_registers         db ' A  X  Y PF SP PC'              ; all register names
                        db '    NV-BDIZC', 10, 13, 0        ; all flags
;----------------------------------------------------------------------------------------------------------
new_line                db 10, 13, 0                        ; new line
;----------------------------------------------------------------------------------------------------------
instruction_error       db ' is not supported!', 10, 13, 0  ; read instruction error
;----------------------------------------------------------------------------------------------------------
all_done                db 10, 13, 'All done!', 10, 13, 0   ; execution success message
;----------------------------------------------------------------------------------------------------------
machine_code            db '6502 machine code:', 10, 13, 0  ; debugging string
;----------------------------------------------------------------------------------------------------------
memory_monitor          db '6502 memory dump:', 10, 13, 0   ; debugging string
;----------------------------------------------------------------------------------------------------------
test_lda_imm            db 10, 13                           ; debugging string
                        db '-------------------------',     ; debugging string
                        db 10, 13                           ; debugging string
                        db 'LDA Immediate addressing:'      ; debugging string
                        db 10, 13                           ; debugging string
                        db '-------------------------'      ; debugging string
                        db 10, 13, 10, 13, 0                ; debugging string
;----------------------------------------------------------------------------------------------------------
test_passed             db 'ok', 10, 13, 0                  ; debugging string
;----------------------------------------------------------------------------------------------------------
test_failed_register    db 'register failed!', 10, 13, 0    ; debugging string
;----------------------------------------------------------------------------------------------------------
test_failed_flags       db 'flags failed!', 10, 13, 0       ; debugging string
;----------------------------------------------------------------------------------------------------------
test_failed_SP          db 'SP failed!', 10, 13, 0          ; debugging string
;----------------------------------------------------------------------------------------------------------
test_failed_PC          db 'PC failed!', 10, 13, 0          ; debugging string
;----------------------------------------------------------------------------------------------------------
cpu_before_execution    db 10, 13, 'Before execution:', 0   ; debugging string
;----------------------------------------------------------------------------------------------------------
cpu_after_execution     db 10, 13, 'After execution:', 0    ; debugging string
;----------------------------------------------------------------------------------------------------------
;                                           TEST PROGRAM
;----------------------------------------------------------------------------------------------------------
test_program:  times 16 db 0x00                             ; program bytes placeholder
                        db 0xff                             ; program end
;---------------------------------------------------------------------------------------------------------
                        times (512*3) - ($-$$) db 0x00      ; BIOS bytes padding
;=========================================================================================================
