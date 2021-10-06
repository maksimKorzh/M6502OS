;----------------------------------------------------------------------------------------------------------
;                                                    LDA
;----------------------------------------------------------------------------------------------------------
test_001:               mov byte [register_P], 0xa2         ; set zero and negative flags to true
                        mov word [test_program], 0x24a9     ; LDA #$24
                        mov si, test_program                ; point SI to test program
                        call load_program                   ; load test program to 6502 memory
                        mov si, test_ins_imm                ; print debugging string
                        call PROCEDURES:print_string        ; print debugging string    
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
test_002:               mov word [test_program], 0x00a9     ; LDA #$00
                        mov si, test_program                ; point SI to test program
                        call load_program                   ; load test program to 6502 memory
                        mov si, test_ins_imm                ; print debugging string
                        call PROCEDURES:print_string        ; print debugging string
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
                        mov si, test_ins_imm                ; print debugging string
                        call PROCEDURES:print_string        ; print debugging string
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
test_004:               mov word [test_program], 0x04a5     ; LDA $04
                        mov si, test_program                ; point SI to test program
                        call load_program                   ; load test program to 6502 memory
                        mov si, test_ins_zp                 ; print debugging string
                        call PROCEDURES:print_string        ; print debugging string
                        mov si, machine_code                ; point SI to machine_code string
                        call PROCEDURES:print_string        ; print machine code string
                        mov si, PROGRAM                     ; 6502 memory range starting point
                        mov di, PROGRAM + 0x08              ; 6502 memory range end point
                        call print_memory_range             ; print 6502 program source bytes
                        push ds                             ; preserve DS
                        xor ax, ax                          ; reset AX
                        mov ds, ax                          ; reset DS
                        mov si, MEMORY + 4                  ; point SI to 6502 simulated memory
                        mov byte [ds:si], 0x45              ; init value in 6502 simulated memory
                        pop ds                              ; hook up local variables
                        mov si, new_line                    ; point SI to new line
                        call PROCEDURES:print_string        ; print new line
                        mov si, memory_monitor              ; point SI to memory_monitor string
                        call PROCEDURES:print_string        ; print memory_monitor string
                        mov si, MEMORY                      ; 6502 memory range starting point
                        mov di, MEMORY + 0x08               ; 6502 memory range end point
                        call print_memory_range             ; print 6502 memory bytes
                        mov si, cpu_before_execution        ; point SI to cpu_before_execution string
                        call PROCEDURES:print_string        ; print cpu_before_execution
                        call print_debug_info               ; print registers
                        call execute                        ; execute instruction
                        mov si, cpu_after_execution         ; point SI to cpu_after_execution string
                        call PROCEDURES:print_string        ; print cpu_after_execution
                        call print_debug_info               ; print registers
                        cmp byte [register_A], 0x45         ; test A register
                        jne test_error_register             ; failure case, stop tests
                        cmp byte [register_P], 0x20         ; test processor flags
                        jne test_error_flags                ; failure case, stop tests
                        cmp byte [program_counter], 0x08    ; test program counter
                        jne test_error_pc                   ; failure case, stop tests
                        mov si, test_passed                 ; point SI to test_passed string
                        call PROCEDURES:print_string        ; print test_passed string
                        jmp test_005                        ; jump to next test
;----------------------------------------------------------------------------------------------------------
test_005:               mov word [test_program], 0x04b5     ; LDA $04,X
                        mov byte [register_X], 0x01         ; init offset of 0x01 in X register
                        mov si, test_program                ; point SI to test program
                        call load_program                   ; load test program to 6502 memory
                        mov si, test_ins_zpx                ; print debugging string
                        call PROCEDURES:print_string        ; print debugging string
                        mov si, machine_code                ; point SI to machine_code string
                        call PROCEDURES:print_string        ; print machine code string
                        mov si, PROGRAM                     ; 6502 memory range starting point
                        mov di, PROGRAM + 0x08              ; 6502 memory range end point
                        call print_memory_range             ; print 6502 program source bytes
                        push ds                             ; preserve DS
                        xor ax, ax                          ; reset AX
                        mov ds, ax                          ; reset DS
                        mov si, MEMORY + 5                  ; point SI to 6502 simulated memory
                        mov byte [ds:si], 0xf8              ; init value in 6502 simulated memory
                        pop ds                              ; hook up local variables
                        mov si, new_line                    ; point SI to new line
                        call PROCEDURES:print_string        ; print new line
                        mov si, memory_monitor              ; point SI to memory_monitor string
                        call PROCEDURES:print_string        ; print memory_monitor string
                        mov si, MEMORY                      ; 6502 memory range starting point
                        mov di, MEMORY + 0x08               ; 6502 memory range end point
                        call print_memory_range             ; print 6502 memory bytes
                        mov si, cpu_before_execution        ; point SI to cpu_before_execution string
                        call PROCEDURES:print_string        ; print cpu_before_execution
                        call print_debug_info               ; print registers
                        call execute                        ; execute instruction
                        mov si, cpu_after_execution         ; point SI to cpu_after_execution string
                        call PROCEDURES:print_string        ; print cpu_after_execution
                        call print_debug_info               ; print registers
                        cmp byte [register_A], 0xf8         ; test A register
                        jne test_error_register             ; failure case, stop tests
                        cmp byte [register_P], 0xa0         ; test processor flags
                        jne test_error_flags                ; failure case, stop tests
                        cmp byte [program_counter], 0x0a    ; test program counter
                        jne test_error_pc                   ; failure case, stop tests
                        mov si, test_passed                 ; point SI to test_passed string
                        call PROCEDURES:print_string        ; print test_passed string
                        jmp test_006                        ; jump to next test
;----------------------------------------------------------------------------------------------------------
test_006:               mov byte [test_program], 0xad       ; LDA $0104
                        mov word [test_program + 1], 0x0104 ; little endian address: 04 01 
                        mov si, test_program                ; point SI to test program
                        call load_program                   ; load test program to 6502 memory
                        mov si, test_ins_abs                ; print debugging string
                        call PROCEDURES:print_string        ; print debugging string
                        mov si, machine_code                ; point SI to machine_code string
                        call PROCEDURES:print_string        ; print machine code string
                        mov si, PROGRAM                     ; 6502 memory range starting point
                        mov di, PROGRAM + 0x08              ; 6502 memory range end point
                        call print_memory_range             ; print 6502 program source bytes
                        push ds                             ; preserve DS
                        xor ax, ax                          ; reset AX
                        mov ds, ax                          ; reset DS
                        mov si, MEMORY + 0x104              ; point SI to 6502 simulated memory
                        mov byte [ds:si], 0x73              ; init value in 6502 simulated memory
                        pop ds                              ; hook up local variables
                        mov si, new_line                    ; point SI to new line
                        call PROCEDURES:print_string        ; print new line
                        mov si, memory_monitor              ; point SI to memory_monitor string
                        call PROCEDURES:print_string        ; print memory_monitor string
                        mov si, MEMORY + 0x100              ; 6502 memory range starting point
                        mov di, MEMORY + 0x108              ; 6502 memory range end point
                        call print_memory_range             ; print 6502 memory bytes
                        mov si, cpu_before_execution        ; point SI to cpu_before_execution string
                        call PROCEDURES:print_string        ; print cpu_before_execution
                        call print_debug_info               ; print registers
                        call execute                        ; execute instruction
                        mov si, cpu_after_execution         ; point SI to cpu_after_execution string
                        call PROCEDURES:print_string        ; print cpu_after_execution
                        call print_debug_info               ; print registers
                        cmp byte [register_A], 0x73         ; test A register
                        jne test_error_register             ; failure case, stop tests
                        cmp byte [register_P], 0x20         ; test processor flags
                        jne test_error_flags                ; failure case, stop tests
                        cmp byte [program_counter], 0x0d    ; test program counter
                        jne test_error_pc                   ; failure case, stop tests
                        mov si, test_passed                 ; point SI to test_passed string
                        call PROCEDURES:print_string        ; print test_passed string
                        jmp test_007                        ; jump to next test
;----------------------------------------------------------------------------------------------------------
test_007:               mov byte [test_program], 0xbd       ; LDA $0104,X
                        mov word [test_program + 1], 0x0104 ; little endian address: 04 01 
                        mov si, test_program                ; point SI to test program
                        call load_program                   ; load test program to 6502 memory
                        mov si, test_ins_abs_x              ; print debugging string
                        call PROCEDURES:print_string        ; print debugging string
                        mov si, machine_code                ; point SI to machine_code string
                        call PROCEDURES:print_string        ; print machine code string
                        mov si, PROGRAM                     ; 6502 memory range starting point
                        mov di, PROGRAM + 0x08              ; 6502 memory range end point
                        call print_memory_range             ; print 6502 program source bytes
                        push ds                             ; preserve DS
                        xor ax, ax                          ; reset AX
                        mov ds, ax                          ; reset DS
                        mov si, MEMORY + 0x105              ; point SI to 6502 simulated memory
                        mov byte [ds:si], 0x92              ; init value in 6502 simulated memory
                        pop ds                              ; hook up local variables
                        mov si, new_line                    ; point SI to new line
                        call PROCEDURES:print_string        ; print new line
                        mov si, memory_monitor              ; point SI to memory_monitor string
                        call PROCEDURES:print_string        ; print memory_monitor string
                        mov si, MEMORY + 0x100              ; 6502 memory range starting point
                        mov di, MEMORY + 0x108              ; 6502 memory range end point
                        call print_memory_range             ; print 6502 memory bytes
                        mov si, cpu_before_execution        ; point SI to cpu_before_execution string
                        call PROCEDURES:print_string        ; print cpu_before_execution
                        call print_debug_info               ; print registers
                        call execute                        ; execute instruction
                        mov si, cpu_after_execution         ; point SI to cpu_after_execution string
                        call PROCEDURES:print_string        ; print cpu_after_execution
                        call print_debug_info               ; print registers
                        cmp byte [register_A], 0x92         ; test A register
                        jne test_error_register             ; failure case, stop tests
                        cmp byte [register_P], 0xa0         ; test processor flags
                        jne test_error_flags                ; failure case, stop tests
                        cmp byte [program_counter], 0x10    ; test program counter
                        jne test_error_pc                   ; failure case, stop tests
                        mov si, test_passed                 ; point SI to test_passed string
                        call PROCEDURES:print_string        ; print test_passed string
                        jmp test_008                        ; jump to next test
;----------------------------------------------------------------------------------------------------------
test_008:               mov byte [register_Y], 0x02         ; set register Y offset
                        mov byte [test_program], 0xb9       ; LDA $0104,Y
                        mov word [test_program + 1], 0x0102 ; little endian address: 04 01 
                        mov si, test_program                ; point SI to test program
                        call load_program                   ; load test program to 6502 memory
                        mov si, test_ins_abs_y              ; print debugging string
                        call PROCEDURES:print_string        ; print debugging string
                        mov si, machine_code                ; point SI to machine_code string
                        call PROCEDURES:print_string        ; print machine code string
                        mov si, PROGRAM                     ; 6502 memory range starting point
                        mov di, PROGRAM + 0x08              ; 6502 memory range end point
                        call print_memory_range             ; print 6502 program source bytes
                        push ds                             ; preserve DS
                        xor ax, ax                          ; reset AX
                        mov ds, ax                          ; reset DS
                        mov si, MEMORY + 0x105              ; point SI to 6502 simulated memory
                        mov byte [ds:si], 0x92              ; init value in 6502 simulated memory
                        pop ds                              ; hook up local variables
                        mov si, new_line                    ; point SI to new line
                        call PROCEDURES:print_string        ; print new line
                        mov si, memory_monitor              ; point SI to memory_monitor string
                        call PROCEDURES:print_string        ; print memory_monitor string
                        mov si, MEMORY + 0x100              ; 6502 memory range starting point
                        mov di, MEMORY + 0x108              ; 6502 memory range end point
                        call print_memory_range             ; print 6502 memory bytes
                        mov si, cpu_before_execution        ; point SI to cpu_before_execution string
                        call PROCEDURES:print_string        ; print cpu_before_execution
                        call print_debug_info               ; print registers
                        call execute                        ; execute instruction
                        mov si, cpu_after_execution         ; point SI to cpu_after_execution string
                        call PROCEDURES:print_string        ; print cpu_after_execution
                        call print_debug_info               ; print registers
                        cmp byte [register_A], 0x73         ; test A register
                        jne test_error_register             ; failure case, stop tests
                        cmp byte [register_P], 0x20         ; test processor flags
                        jne test_error_flags                ; failure case, stop tests
                        cmp byte [program_counter], 0x13    ; test program counter
                        jne test_error_pc                   ; failure case, stop tests
                        mov si, test_passed                 ; point SI to test_passed string
                        call PROCEDURES:print_string        ; print test_passed string
                        jmp test_009                        ; jump to next test
;----------------------------------------------------------------------------------------------------------
test_009:               mov byte [register_X], 0x04         ; set register Y offset
                        mov word [test_program], 0x20a1     ; little endian address: 04 01
                        mov byte [test_program + 2], 0x00   ; reset previous instructions
                        mov si, test_program                ; point SI to test program
                        call load_program                   ; load test program to 6502 memory
                        mov si, test_ins_indexed_indir      ; print debugging string
                        call PROCEDURES:print_string        ; print debugging string
                        mov si, machine_code                ; point SI to machine_code string
                        call PROCEDURES:print_string        ; print machine code string
                        mov si, PROGRAM                     ; 6502 memory range starting point
                        mov di, PROGRAM + 0x08              ; 6502 memory range end point
                        call print_memory_range             ; print 6502 program source bytes
                        push ds                             ; preserve DS
                        xor ax, ax                          ; reset AX
                        mov ds, ax                          ; reset DS
                        mov si, MEMORY + 0x24               ; point SI to 6502 simulated memory
                        mov word [ds:si], 0x1074            ; init value in 6502 simulated memory
                        mov si, MEMORY + 0x1074             ; point SI to indirect memory address
                        mov byte [ds:si], 0x93              ; set value at indirect memory address
                        pop ds                              ; hook up local variables
                        mov si, new_line                    ; point SI to new line
                        call PROCEDURES:print_string        ; print new line
                        mov si, memory_monitor              ; point SI to memory_monitor string
                        call PROCEDURES:print_string        ; print memory_monitor string
                        mov si, MEMORY                      ; 6502 memory range starting point
                        mov di, MEMORY + 0x28               ; 6502 memory range end point
                        call print_memory_range             ; print 6502 memory bytes
                        mov si, new_line                    ; point SI to new line
                        call PROCEDURES:print_string        ; print new line
                        mov si, memory_monitor              ; point SI to memory_monitor string
                        call PROCEDURES:print_string        ; print memory_monitor string
                        mov si, MEMORY + 0x1070             ; 6502 memory range starting point
                        mov di, MEMORY + 0x1078             ; 6502 memory range end point
                        call print_memory_range             ; print 6502 memory bytes
                        mov si, cpu_before_execution        ; point SI to cpu_before_execution string
                        call PROCEDURES:print_string        ; print cpu_before_execution
                        call print_debug_info               ; print registers
                        call execute                        ; execute instruction
                        mov si, cpu_after_execution         ; point SI to cpu_after_execution string
                        call PROCEDURES:print_string        ; print cpu_after_execution
                        call print_debug_info               ; print registers
                        cmp byte [register_A], 0x93         ; test A register
                        jne test_error_register             ; failure case, stop tests
                        cmp byte [register_P], 0xa0         ; test processor flags
                        jne test_error_flags                ; failure case, stop tests
                        cmp byte [program_counter], 0x15    ; test program counter
                        jne test_error_pc                   ; failure case, stop tests
                        mov si, test_passed                 ; point SI to test_passed string
                        call PROCEDURES:print_string        ; print test_passed string
                        jmp test_010                        ; jump to next text
;----------------------------------------------------------------------------------------------------------
test_010:               mov byte [register_Y], 0x04         ; set register Y offset
                        mov word [test_program], 0x24b1     ; little endian address: 04 01
                        mov si, test_program                ; point SI to test program
                        call load_program                   ; load test program to 6502 memory
                        mov si, test_ins_indir_indexed      ; print debugging string
                        call PROCEDURES:print_string        ; print debugging string
                        mov si, machine_code                ; point SI to machine_code string
                        call PROCEDURES:print_string        ; print machine code string
                        mov si, PROGRAM                     ; 6502 memory range starting point
                        mov di, PROGRAM + 0x08              ; 6502 memory range end point
                        call print_memory_range             ; print 6502 program source bytes
                        push ds                             ; preserve DS
                        xor ax, ax                          ; reset AX
                        mov ds, ax                          ; reset DS
                        mov si, MEMORY + 0x24               ; point SI to 6502 simulated memory
                        mov word [ds:si], 0x1070            ; init value in 6502 simulated memory
                        mov si, MEMORY + 0x1074             ; point SI to indirect memory address
                        mov byte [ds:si], 0x45              ; set value at indirect memory address
                        pop ds                              ; hook up local variables
                        mov si, new_line                    ; point SI to new line
                        call PROCEDURES:print_string        ; print new line
                        mov si, memory_monitor              ; point SI to memory_monitor string
                        call PROCEDURES:print_string        ; print memory_monitor string
                        mov si, MEMORY                      ; 6502 memory range starting point
                        mov di, MEMORY + 0x28               ; 6502 memory range end point
                        call print_memory_range             ; print 6502 memory bytes
                        mov si, new_line                    ; point SI to new line
                        call PROCEDURES:print_string        ; print new line
                        mov si, memory_monitor              ; point SI to memory_monitor string
                        call PROCEDURES:print_string        ; print memory_monitor string
                        mov si, MEMORY + 0x1070             ; 6502 memory range starting point
                        mov di, MEMORY + 0x1078             ; 6502 memory range end point
                        call print_memory_range             ; print 6502 memory bytes
                        mov si, cpu_before_execution        ; point SI to cpu_before_execution string
                        call PROCEDURES:print_string        ; print cpu_before_execution
                        call print_debug_info               ; print registers
                        call execute                        ; execute instruction
                        mov si, cpu_after_execution         ; point SI to cpu_after_execution string
                        call PROCEDURES:print_string        ; print cpu_after_execution
                        call print_debug_info               ; print registers
                        cmp byte [register_A], 0x45         ; test A register
                        jne test_error_register             ; failure case, stop tests
                        cmp byte [register_P], 0x20         ; test processor flags
                        jne test_error_flags                ; failure case, stop tests
                        cmp byte [program_counter], 0x17    ; test program counter
                        jne test_error_pc                   ; failure case, stop tests
                        mov si, test_passed                 ; point SI to test_passed string
                        call PROCEDURES:print_string        ; print test_passed string
;----------------------------------------------------------------------------------------------------------
;                                                    LDX
;----------------------------------------------------------------------------------------------------------
test_001:               mov byte [register_P], 0xa2         ; set zero and negative flags to true
                        mov word [test_program], 0x24a2     ; LDX #$24
                        mov si, test_program                ; point SI to test program
                        call load_program                   ; load test program to 6502 memory
                        mov si, test_ins_imm                ; print debugging string
                        call PROCEDURES:print_string        ; print debugging string    
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
                        cmp byte [register_X], 0x24         ; test X register
                        jne test_error_register             ; failure case, stop tests
                        cmp byte [register_P], 0x20         ; test processor flags
                        jne test_error_flags                ; failure case, stop tests
                        cmp byte [program_counter], 0x02    ; test program counter
                        jne test_error_pc                   ; failure case, stop tests
                        mov si, test_passed                 ; point SI to test_passed string
                        call PROCEDURES:print_string        ; print test_passed string
                        jmp test_002                        ; jump to next test
;----------------------------------------------------------------------------------------------------------
test_002:               mov word [test_program], 0x04a6     ; LDX $04
                        mov si, test_program                ; point SI to test program
                        call load_program                   ; load test program to 6502 memory
                        mov si, test_ins_zp                 ; print debugging string
                        call PROCEDURES:print_string        ; print debugging string
                        mov si, machine_code                ; point SI to machine_code string
                        call PROCEDURES:print_string        ; print machine code string
                        mov si, PROGRAM                     ; 6502 memory range starting point
                        mov di, PROGRAM + 0x08              ; 6502 memory range end point
                        call print_memory_range             ; print 6502 program source bytes
                        push ds                             ; preserve DS
                        xor ax, ax                          ; reset AX
                        mov ds, ax                          ; reset DS
                        mov si, MEMORY + 4                  ; point SI to 6502 simulated memory
                        mov byte [ds:si], 0xe5              ; init value in 6502 simulated memory
                        pop ds                              ; hook up local variables
                        mov si, new_line                    ; point SI to new line
                        call PROCEDURES:print_string        ; print new line
                        mov si, memory_monitor              ; point SI to memory_monitor string
                        call PROCEDURES:print_string        ; print memory_monitor string
                        mov si, MEMORY                      ; 6502 memory range starting point
                        mov di, MEMORY + 0x08               ; 6502 memory range end point
                        call print_memory_range             ; print 6502 memory bytes
                        mov si, cpu_before_execution        ; point SI to cpu_before_execution string
                        call PROCEDURES:print_string        ; print cpu_before_execution
                        call print_debug_info               ; print registers
                        call execute                        ; execute instruction
                        mov si, cpu_after_execution         ; point SI to cpu_after_execution string
                        call PROCEDURES:print_string        ; print cpu_after_execution
                        call print_debug_info               ; print registers
                        cmp byte [register_X], 0xe5         ; test X register
                        jne test_error_register             ; failure case, stop tests
                        cmp byte [register_P], 0xA0         ; test processor flags
                        jne test_error_flags                ; failure case, stop tests
                        cmp byte [program_counter], 0x04    ; test program counter
                        jne test_error_pc                   ; failure case, stop tests
                        mov si, test_passed                 ; point SI to test_passed string
                        call PROCEDURES:print_string        ; print test_passed string
                        jmp test_003                        ; jump to next test
;----------------------------------------------------------------------------------------------------------
test_003:               mov word [test_program], 0x04b6     ; LDX $04,Y
                        mov byte [register_Y], 0x01         ; init offset of 0x01 in Y register
                        mov si, test_program                ; point SI to test program
                        call load_program                   ; load test program to 6502 memory
                        mov si, test_ins_zpy                ; print debugging string
                        call PROCEDURES:print_string        ; print debugging string
                        mov si, machine_code                ; point SI to machine_code string
                        call PROCEDURES:print_string        ; print machine code string
                        mov si, PROGRAM                     ; 6502 memory range starting point
                        mov di, PROGRAM + 0x08              ; 6502 memory range end point
                        call print_memory_range             ; print 6502 program source bytes
                        push ds                             ; preserve DS
                        xor ax, ax                          ; reset AX
                        mov ds, ax                          ; reset DS
                        mov si, MEMORY + 5                  ; point SI to 6502 simulated memory
                        mov byte [ds:si], 0xf8              ; init value in 6502 simulated memory
                        pop ds                              ; hook up local variables
                        mov si, new_line                    ; point SI to new line
                        call PROCEDURES:print_string        ; print new line
                        mov si, memory_monitor              ; point SI to memory_monitor string
                        call PROCEDURES:print_string        ; print memory_monitor string
                        mov si, MEMORY                      ; 6502 memory range starting point
                        mov di, MEMORY + 0x08               ; 6502 memory range end point
                        call print_memory_range             ; print 6502 memory bytes
                        mov si, cpu_before_execution        ; point SI to cpu_before_execution string
                        call PROCEDURES:print_string        ; print cpu_before_execution
                        call print_debug_info               ; print registers
                        call execute                        ; execute instruction
                        mov si, cpu_after_execution         ; point SI to cpu_after_execution string
                        call PROCEDURES:print_string        ; print cpu_after_execution
                        call print_debug_info               ; print registers
                        cmp byte [register_X], 0xf8         ; test X register
                        jne test_error_register             ; failure case, stop tests
                        cmp byte [register_P], 0xa0         ; test processor flags
                        jne test_error_flags                ; failure case, stop tests
                        cmp byte [program_counter], 0x06    ; test program counter
                        jne test_error_pc                   ; failure case, stop tests
                        mov si, test_passed                 ; point SI to test_passed string
                        call PROCEDURES:print_string        ; print test_passed string
                        jmp test_004                        ; jump to next test
;----------------------------------------------------------------------------------------------------------                        
test_004:               mov byte [test_program], 0xae       ; LDX $0104
                        mov word [test_program + 1], 0x0104 ; little endian address: 04 01 
                        mov si, test_program                ; point SI to test program
                        call load_program                   ; load test program to 6502 memory
                        mov si, test_ins_abs                ; print debugging string
                        call PROCEDURES:print_string        ; print debugging string
                        mov si, machine_code                ; point SI to machine_code string
                        call PROCEDURES:print_string        ; print machine code string
                        mov si, PROGRAM                     ; 6502 memory range starting point
                        mov di, PROGRAM + 0x08              ; 6502 memory range end point
                        call print_memory_range             ; print 6502 program source bytes
                        push ds                             ; preserve DS
                        xor ax, ax                          ; reset AX
                        mov ds, ax                          ; reset DS
                        mov si, MEMORY + 0x104              ; point SI to 6502 simulated memory
                        mov byte [ds:si], 0x73              ; init value in 6502 simulated memory
                        pop ds                              ; hook up local variables
                        mov si, new_line                    ; point SI to new line
                        call PROCEDURES:print_string        ; print new line
                        mov si, memory_monitor              ; point SI to memory_monitor string
                        call PROCEDURES:print_string        ; print memory_monitor string
                        mov si, MEMORY + 0x100              ; 6502 memory range starting point
                        mov di, MEMORY + 0x108              ; 6502 memory range end point
                        call print_memory_range             ; print 6502 memory bytes
                        mov si, cpu_before_execution        ; point SI to cpu_before_execution string
                        call PROCEDURES:print_string        ; print cpu_before_execution
                        call print_debug_info               ; print registers
                        call execute                        ; execute instruction
                        mov si, cpu_after_execution         ; point SI to cpu_after_execution string
                        call PROCEDURES:print_string        ; print cpu_after_execution
                        call print_debug_info               ; print registers
                        cmp byte [register_X], 0x73         ; test X register
                        jne test_error_register             ; failure case, stop tests
                        cmp byte [register_P], 0x20         ; test processor flags
                        jne test_error_flags                ; failure case, stop tests
                        cmp byte [program_counter], 0x09    ; test program counter
                        jne test_error_pc                   ; failure case, stop tests
                        mov si, test_passed                 ; point SI to test_passed string
                        call PROCEDURES:print_string        ; print test_passed string
                        jmp test_005                        ; jump to next test
;----------------------------------------------------------------------------------------------------------
test_005:               mov byte [test_program], 0xbe       ; LDX $0104,Y
                        mov word [test_program + 1], 0x0104 ; little endian address: 04 01 
                        mov si, test_program                ; point SI to test program
                        call load_program                   ; load test program to 6502 memory
                        mov si, test_ins_abs_y              ; print debugging string
                        call PROCEDURES:print_string        ; print debugging string
                        mov si, machine_code                ; point SI to machine_code string
                        call PROCEDURES:print_string        ; print machine code string
                        mov si, PROGRAM                     ; 6502 memory range starting point
                        mov di, PROGRAM + 0x08              ; 6502 memory range end point
                        call print_memory_range             ; print 6502 program source bytes
                        push ds                             ; preserve DS
                        xor ax, ax                          ; reset AX
                        mov ds, ax                          ; reset DS
                        mov si, MEMORY + 0x105              ; point SI to 6502 simulated memory
                        mov byte [ds:si], 0x92              ; init value in 6502 simulated memory
                        pop ds                              ; hook up local variables
                        mov si, new_line                    ; point SI to new line
                        call PROCEDURES:print_string        ; print new line
                        mov si, memory_monitor              ; point SI to memory_monitor string
                        call PROCEDURES:print_string        ; print memory_monitor string
                        mov si, MEMORY + 0x100              ; 6502 memory range starting point
                        mov di, MEMORY + 0x108              ; 6502 memory range end point
                        call print_memory_range             ; print 6502 memory bytes
                        mov si, cpu_before_execution        ; point SI to cpu_before_execution string
                        call PROCEDURES:print_string        ; print cpu_before_execution
                        call print_debug_info               ; print registers
                        call execute                        ; execute instruction
                        mov si, cpu_after_execution         ; point SI to cpu_after_execution string
                        call PROCEDURES:print_string        ; print cpu_after_execution
                        call print_debug_info               ; print registers
                        cmp byte [register_X], 0x92         ; test X register
                        jne test_error_register             ; failure case, stop tests
                        cmp byte [register_P], 0xa0         ; test processor flags
                        jne test_error_flags                ; failure case, stop tests
                        cmp byte [program_counter], 0x0c    ; test program counter
                        jne test_error_pc                   ; failure case, stop tests
                        mov si, test_passed                 ; point SI to test_passed string
                        call PROCEDURES:print_string        ; print test_passed string
;----------------------------------------------------------------------------------------------------------
;                                                    LDY
;----------------------------------------------------------------------------------------------------------
test_001:               mov byte [register_P], 0xa2         ; set zero and negative flags to true
                        mov word [test_program], 0x24a0     ; LDY #$24
                        mov si, test_program                ; point SI to test program
                        call load_program                   ; load test program to 6502 memory
                        mov si, test_ins_imm                ; print debugging string
                        call PROCEDURES:print_string        ; print debugging string    
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
                        cmp byte [register_Y], 0x24         ; test Y register
                        jne test_error_register             ; failure case, stop tests
                        cmp byte [register_P], 0x20         ; test processor flags
                        jne test_error_flags                ; failure case, stop tests
                        cmp byte [program_counter], 0x02    ; test program counter
                        jne test_error_pc                   ; failure case, stop tests
                        mov si, test_passed                 ; point SI to test_passed string
                        call PROCEDURES:print_string        ; print test_passed string
                        jmp test_002                        ; jump to next test
;----------------------------------------------------------------------------------------------------------
test_002:               mov word [test_program], 0x04a4     ; LDY $04
                        mov si, test_program                ; point SI to test program
                        call load_program                   ; load test program to 6502 memory
                        mov si, test_ins_zp                 ; print debugging string
                        call PROCEDURES:print_string        ; print debugging string
                        mov si, machine_code                ; point SI to machine_code string
                        call PROCEDURES:print_string        ; print machine code string
                        mov si, PROGRAM                     ; 6502 memory range starting point
                        mov di, PROGRAM + 0x08              ; 6502 memory range end point
                        call print_memory_range             ; print 6502 program source bytes
                        push ds                             ; preserve DS
                        xor ax, ax                          ; reset AX
                        mov ds, ax                          ; reset DS
                        mov si, MEMORY + 4                  ; point SI to 6502 simulated memory
                        mov byte [ds:si], 0xe5              ; init value in 6502 simulated memory
                        pop ds                              ; hook up local variables
                        mov si, new_line                    ; point SI to new line
                        call PROCEDURES:print_string        ; print new line
                        mov si, memory_monitor              ; point SI to memory_monitor string
                        call PROCEDURES:print_string        ; print memory_monitor string
                        mov si, MEMORY                      ; 6502 memory range starting point
                        mov di, MEMORY + 0x08               ; 6502 memory range end point
                        call print_memory_range             ; print 6502 memory bytes
                        mov si, cpu_before_execution        ; point SI to cpu_before_execution string
                        call PROCEDURES:print_string        ; print cpu_before_execution
                        call print_debug_info               ; print registers
                        call execute                        ; execute instruction
                        mov si, cpu_after_execution         ; point SI to cpu_after_execution string
                        call PROCEDURES:print_string        ; print cpu_after_execution
                        call print_debug_info               ; print registers
                        cmp byte [register_Y], 0xe5         ; test Y register
                        jne test_error_register             ; failure case, stop tests
                        cmp byte [register_P], 0xa0         ; test processor flags
                        jne test_error_flags                ; failure case, stop tests
                        cmp byte [program_counter], 0x04    ; test program counter
                        jne test_error_pc                   ; failure case, stop tests
                        mov si, test_passed                 ; point SI to test_passed string
                        call PROCEDURES:print_string        ; print test_passed string
                        jmp test_003                        ; jump to next test
;----------------------------------------------------------------------------------------------------------
test_003:               mov word [test_program], 0x04b4     ; LDY $04,X
                        mov byte [register_X], 0x01         ; init offset of 0x01 in X register
                        mov si, test_program                ; point SI to test program
                        call load_program                   ; load test program to 6502 memory
                        mov si, test_ins_zpx                ; print debugging string
                        call PROCEDURES:print_string        ; print debugging string
                        mov si, machine_code                ; point SI to machine_code string
                        call PROCEDURES:print_string        ; print machine code string
                        mov si, PROGRAM                     ; 6502 memory range starting point
                        mov di, PROGRAM + 0x08              ; 6502 memory range end point
                        call print_memory_range             ; print 6502 program source bytes
                        push ds                             ; preserve DS
                        xor ax, ax                          ; reset AX
                        mov ds, ax                          ; reset DS
                        mov si, MEMORY + 5                  ; point SI to 6502 simulated memory
                        mov byte [ds:si], 0xf8              ; init value in 6502 simulated memory
                        pop ds                              ; hook up local variables
                        mov si, new_line                    ; point SI to new line
                        call PROCEDURES:print_string        ; print new line
                        mov si, memory_monitor              ; point SI to memory_monitor string
                        call PROCEDURES:print_string        ; print memory_monitor string
                        mov si, MEMORY                      ; 6502 memory range starting point
                        mov di, MEMORY + 0x08               ; 6502 memory range end point
                        call print_memory_range             ; print 6502 memory bytes
                        mov si, cpu_before_execution        ; point SI to cpu_before_execution string
                        call PROCEDURES:print_string        ; print cpu_before_execution
                        call print_debug_info               ; print registers
                        call execute                        ; execute instruction
                        mov si, cpu_after_execution         ; point SI to cpu_after_execution string
                        call PROCEDURES:print_string        ; print cpu_after_execution
                        call print_debug_info               ; print registers
                        cmp byte [register_Y], 0xf8         ; test Y register
                        jne test_error_register             ; failure case, stop tests
                        cmp byte [register_P], 0xa0         ; test processor flags
                        jne test_error_flags                ; failure case, stop tests
                        cmp byte [program_counter], 0x06    ; test program counter
                        jne test_error_pc                   ; failure case, stop tests
                        mov si, test_passed                 ; point SI to test_passed string
                        call PROCEDURES:print_string        ; print test_passed string
                        jmp test_004                        ; jump to next test
;----------------------------------------------------------------------------------------------------------
test_004:               mov byte [test_program], 0xac       ; LDY $0104
                        mov word [test_program + 1], 0x0104 ; little endian address: 04 01 
                        mov si, test_program                ; point SI to test program
                        call load_program                   ; load test program to 6502 memory
                        mov si, test_ins_abs                ; print debugging string
                        call PROCEDURES:print_string        ; print debugging string
                        mov si, machine_code                ; point SI to machine_code string
                        call PROCEDURES:print_string        ; print machine code string
                        mov si, PROGRAM                     ; 6502 memory range starting point
                        mov di, PROGRAM + 0x08              ; 6502 memory range end point
                        call print_memory_range             ; print 6502 program source bytes
                        push ds                             ; preserve DS
                        xor ax, ax                          ; reset AX
                        mov ds, ax                          ; reset DS
                        mov si, MEMORY + 0x104              ; point SI to 6502 simulated memory
                        mov byte [ds:si], 0x73              ; init value in 6502 simulated memory
                        pop ds                              ; hook up local variables
                        mov si, new_line                    ; point SI to new line
                        call PROCEDURES:print_string        ; print new line
                        mov si, memory_monitor              ; point SI to memory_monitor string
                        call PROCEDURES:print_string        ; print memory_monitor string
                        mov si, MEMORY + 0x100              ; 6502 memory range starting point
                        mov di, MEMORY + 0x108              ; 6502 memory range end point
                        call print_memory_range             ; print 6502 memory bytes
                        mov si, cpu_before_execution        ; point SI to cpu_before_execution string
                        call PROCEDURES:print_string        ; print cpu_before_execution
                        call print_debug_info               ; print registers
                        call execute                        ; execute instruction
                        mov si, cpu_after_execution         ; point SI to cpu_after_execution string
                        call PROCEDURES:print_string        ; print cpu_after_execution
                        call print_debug_info               ; print registers
                        cmp byte [register_Y], 0x73         ; test Y register
                        jne test_error_register             ; failure case, stop tests
                        cmp byte [register_P], 0x20         ; test processor flags
                        jne test_error_flags                ; failure case, stop tests
                        cmp byte [program_counter], 0x09    ; test program counter
                        jne test_error_pc                   ; failure case, stop tests
                        mov si, test_passed                 ; point SI to test_passed string
                        call PROCEDURES:print_string        ; print test_passed string
                        jmp test_005                        ; jump to next test
;----------------------------------------------------------------------------------------------------------
test_005:               mov byte [test_program], 0xbc       ; LDY $0104,X
                        mov word [test_program + 1], 0x0104 ; little endian address: 04 01 
                        mov si, test_program                ; point SI to test program
                        call load_program                   ; load test program to 6502 memory
                        mov si, test_ins_abs_x              ; print debugging string
                        call PROCEDURES:print_string        ; print debugging string
                        mov si, machine_code                ; point SI to machine_code string
                        call PROCEDURES:print_string        ; print machine code string
                        mov si, PROGRAM                     ; 6502 memory range starting point
                        mov di, PROGRAM + 0x08              ; 6502 memory range end point
                        call print_memory_range             ; print 6502 program source bytes
                        push ds                             ; preserve DS
                        xor ax, ax                          ; reset AX
                        mov ds, ax                          ; reset DS
                        mov si, MEMORY + 0x105              ; point SI to 6502 simulated memory
                        mov byte [ds:si], 0x92              ; init value in 6502 simulated memory
                        pop ds                              ; hook up local variables
                        mov si, new_line                    ; point SI to new line
                        call PROCEDURES:print_string        ; print new line
                        mov si, memory_monitor              ; point SI to memory_monitor string
                        call PROCEDURES:print_string        ; print memory_monitor string
                        mov si, MEMORY + 0x100              ; 6502 memory range starting point
                        mov di, MEMORY + 0x108              ; 6502 memory range end point
                        call print_memory_range             ; print 6502 memory bytes
                        mov si, cpu_before_execution        ; point SI to cpu_before_execution string
                        call PROCEDURES:print_string        ; print cpu_before_execution
                        call print_debug_info               ; print registers
                        call execute                        ; execute instruction
                        mov si, cpu_after_execution         ; point SI to cpu_after_execution string
                        call PROCEDURES:print_string        ; print cpu_after_execution
                        call print_debug_info               ; print registers
                        cmp byte [register_Y], 0x92         ; test Y register
                        jne test_error_register             ; failure case, stop tests
                        cmp byte [register_P], 0xa0         ; test processor flags
                        jne test_error_flags                ; failure case, stop tests
                        cmp byte [program_counter], 0x0c    ; test program counter
                        jne test_error_pc                   ; failure case, stop tests
                        mov si, test_passed                 ; point SI to test_passed string
                        call PROCEDURES:print_string        ; print test_passed string

