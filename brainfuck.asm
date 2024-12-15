%include "library/essential.inc"
%include "library/math/module.inc"
%include "library/string/number_to_string.inc"
%include "library/string/string_len.inc"
%include "library/io/println.inc"
%include "library/io/print.inc"
%include "library/io/input.inc"
%include "library/io/put.inc"
%include "library/memory/memset.inc"


max_block_size equ 32768
max_nested_loop equ 64

section .data
    title_label db "Brainfuck Interpreter Shell (Assembly x86_64 Linux/Unix Version) | 'e' or '0' to exit", 0
    out_of_bounds_error_label db "Error: Out of bounds operation", 0
    max_nested_loop_error_label db "Error: Max nested loop reached", 0
    input_label db "> ", 0

section .bss
    code resb max_block_size  ; Instructions array block
    data resb max_block_size  ; Data array block
    user resb max_block_size  ; Buffer for user input
    loop_stack resq max_nested_loop  ; Stack for nested loops

section .text
    global _start

_start:
    call shell_mode
    
    sys_exit 0


shell_mode:
    println title_label

    .main_loop:
        call clear_memory

        print input_label           ; Printing the initial label
        input code, max_block_size  ; Receiving the code as input

        ; Exit conditional
        cmp byte [code], '0'
        jz .exit
        cmp byte [code], 'e'
        je .exit

        call interpreter

        ; Printing a new line
        put 10

        jmp .main_loop
    
    .exit:
        ret


clear_memory:
    ; Zeroing the arrays
    mov rax, max_block_size
    mov rcx, 8
    mov rdx, 0
    div rcx
    push rax
    memset 0, code, [rsp]
    memset 0, data, [rsp]
    memset 0, user, [rsp]
    pop rax


interpreter:
    ; Setting the 'Variables'
    push r15
    push r14
    push r13
    push r12

    mov r15, 0  ; Instruction pointer
    mov r14, 0  ; Data pointer
    mov r13, 0  ; User input buffer pointer 
    mov r12, 0  ; Loop stack pointer

    ; Reading the instructions
    .read_instruction:
        call operator

        inc r15
        cmp byte [code + r15], NULL
        jnz .read_instruction
    
    ; Returning the original values of the registers
    pop r12
    pop r13
    pop r14
    pop r15
    
    ret


operator:
    ; Jump Table
    mov bl, byte [code + r15]
    cmp bl, '+'      ; Case: '+' (increase cell value)
    je .inc_cell
    cmp bl, '-'      ; Case: '-' (decrease cell value)
    je .dec_cell
    cmp bl, '>'      ; Case: '>' (move pointer to right)
    je .inc_ptr
    cmp bl, '<'      ; Case: '<' (move pointer to left)
    je .dec_ptr
    cmp bl, '['      ; Case: '[' (start loop)
    je .start_loop
    cmp bl, ']'      ; Case: ']' (end loop)
    je .end_loop
    cmp bl, ','      ; Case: ',' (get input)
    je .input_cell
    cmp bl, '.'      ; Case: '.' (print cell value as ASCII)
    je .print_cell
    cmp bl, '#'      ; Case: '#' (print cell value as number)
    je .print_debug

    jmp .exit        ; Default

    .inc_cell:
        inc byte [data + r14]
        jmp .exit

    .dec_cell:
        dec byte [data + r14]
        jmp .exit
    
    .inc_ptr:
        ; If the instruction pointer is MAX or greater, the increment should set it to 0
        cmp r14, max_block_size
        jge .set_ptr_to_zero

        ; Else, just increase it
        inc r14
        jmp .exit

        .set_ptr_to_zero:
        mov r14, 0
        jmp .exit
    
    .dec_ptr:
        ; If the instruction pointer is 0 or lesser, the decrement should MAX it
        cmp r14, 0
        jle .set_ptr_to_max

        ; Else, just decrease it
        dec r14
        jmp .exit

        .set_ptr_to_max:
        mov r14, max_block_size
        jmp .exit
    
    .start_loop:
        ; If the loop stack is full, throw an error
        cmp r12, max_nested_loop
        jge .error_max_nested_loop

        ; If the current cell value is zero, jump to the next instruction and push the instruction pointer to the loop stack
        cmp byte [data + r14], 0
        jnz .enter_loop

        ; If not, jump to the next instruction until it is the correspondent ']'
        ; Skipping the loop
        mov rax, 0  ; Depth of the search (increments by one with each '[' found)
        mov rbx, 0  ; Counter

        .loop_through_code:
            inc rbx
            ; Check for out of bounds
            mov rcx, r15
            add rcx, rbx
            cmp rcx, max_block_size
            jge .error_out_of_bounds

            ; Search
            mov cl, byte [code + r15 + rbx]
            cmp cl, '['
            je .increment_depth
            cmp cl, ']'
            je .decrement_depth

            ; Check for NULL character
            cmp cl, NULL
            je .exit
        
        .increment_depth:
            inc rax
            jmp .loop_through_code
        
        .decrement_depth:
            ; Check if the depth of search is 0
            ; If it is, exit the loop
            cmp rax, 0
            jz .finish_loop_skip

            ; Else, decrement and continue the search
            dec rax
            jmp .loop_through_code
        
        .finish_loop_skip:
            add r15, rbx
            jmp .exit

        .enter_loop:
            mov rax, r15
            inc r12  ; Increasing the loop stack pointer
            mov qword [r12 * 8 + loop_stack], rax  ; Pushing the instruction pointer to the loop stack
        
        jmp .exit
    
    .end_loop:
        cmp r12, 0
        jle .exit  ; If the loop stack is empty, just ignore

        ; If the current cell value is not zero, go back to the beginning of the looping
        cmp byte [data + r14], 0
        jnz .go_back

        ; Else, remove the last element of the loop stack
        dec r12
        jmp .exit

        .go_back:
            mov r15, qword [r12 * 8 + loop_stack]
            jmp .exit
    
    .input_cell:
        ; If the user buffer is empty, ask for input
        cmp r13, 0
        jnz .input_cell_skip_get_input
        input user, max_block_size

        ; Getting the size of the input
        ; NOTE: The null terminator count to the size of the input,
        ; beucause if the user haven't written anything, the cell
        ; value will be zero and the user buffer size should be
        ; decreased from 1 to 0
        xor r13, r13
        .input_cell_loop_through_input:
            inc r13
            cmp byte [user + r13], 0
            jz .input_cell_loop_done
            cmp r13, max_block_size
            jae .error_out_of_bounds
            jmp .input_cell_loop_through_input
        
        .input_cell_loop_done:
        
        ; Removing the new line, also correcting the size
        cmp r13, 0
        jle .input_cell_skip_get_input  ; If the size is 0 or less, there was no input at all
        mov byte [user + r13 - 1], 0

        .input_cell_skip_get_input:

        ; Setting the cell value
        mov al, byte [user]      ; Setting AL (8-bits RAX) as the first value of the user buffer
        mov byte [data+r14], al  ; Setting the current cell as the value of AL

        ; Shifting the array one to the left
        xor r8, r8  ; Counter
        .input_cell_shift_input:
            inc r8
            mov al, byte [user + r8]
            mov byte [user + r8 - 1], al  ; Setting value at R8-1 as the value at R8
            cmp r8, r13
            jge .input_cell_shift_done
            jmp .input_cell_shift_input
        
        .input_cell_shift_done:
        
        dec r13  ; Decreasing the value of the user buffer size
        
        jmp .exit

    .print_cell:
        mov rcx, data
        add rcx, r14
        put qword [rcx]

        jmp .exit
    
    .print_debug:
        mov rcx, data       ; Getting the cell address
        add rcx, r14        ; Adding the offset
        xor rax, rax        ; Zeroing the RAX register
        mov al, byte [rcx]  ; Setting the least byte of the RAX (AL) as the cell value (8 bits)
        call number_to_string
        mov r11, rax
        println r11

        jmp .exit

    .error_out_of_bounds:
        println out_of_bounds_error_label
        sys_exit 1
    
    .error_max_nested_loop:
        println max_nested_loop_error_label
        sys_exit 2
    
    .exit:
        ret


; ============================================================================
; ================================ UNIT TESTS ================================
; ============================================================================

; There isn't some sort of automated unit test, because it's already hard in
; high-level languages, in assembly it's a shit. Also, it needs modularization,
; something that i didn't implement yet.
; So here is some manual tests


; ======= Initial Test ===========================================
;
; Code: 
;     ++++++++++++++++++++++++++++++++++++++++++++++++.
; Expected output: 
;     0
;


; ======= Ignore characters other than operators =================
;
; Code: 
;     ++++++++++++++++++++++++ this should not modify the output 
;     ++++++++++++++++++++++++ or should it? .
; Expected output: 
;     0
;


; ======= Cell Overflow (upwards) ================================
;
; Code: 
;     +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;     +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;     +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;     +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;     +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;     +++++++++.
; Expected output: 
;     0
;


; ======= Cell Overflow (downwards) ==============================
;
; Code: 
;     -----------------------------------------------------------
;     -----------------------------------------------------------
;     ----------------.
; Expected output: 
;     z
;


; ======= Move data pointer ======================================
;
; Code: 
;     ++++++++++++++++++++++++++++++++++++++++++++++++>++++++++++
;     +++++++++++++++++++++++++++++++++++++++.<.
; Expected output: 
;     10
;


; ======= Data pointer overflow ==================================
;
; Code: 
;     <++++++++++++++++++++++++++++++++++++++++++++++++.>++++++++
;     +++++++++++++++++++++++++++++++++++++++++.
; Expected output: 
;     01
;


; ======= Input test =============================================
;
; Code: 
;     ,.
; Input:
;     abc
; Expected output: 
;     a
;


; ======= Input value test =======================================
;
; Code: 
;     ,#
; Input:
;     0
; Expected output: 
;     48
;


; ======= Complex input (normal) =================================
;
; Code: 
;     ,,,.
; Input:
;     aaa
; Expected output: 
;     a
;


; ======= Complex input (including the null terminator) ==========
;
; Code: 
;     ,,,,.
; Input:
;     aaa
; Expected output: 
;     (null value)
;


; ======= Input with multiple calls ==============================
;
; Code: 
;     ,.,.,,.
; Input:
;     abcd
; Expected output: 
;     abd
;


; ======= Basic loop ==============
;
; Code:
;     +[#+]
; Expected output:
;     (all numbers from 1 to 255)
;


; ======= Basic math ==============
;
; Code:
;     +++[>++<-]>#
; Expected output:
;     6
;


; ======= Advanced math (nested loop) ==============
;
; Code:
;     ++++[>+++[>++<-]<-]>>#
; Expected output:
;     24
;
