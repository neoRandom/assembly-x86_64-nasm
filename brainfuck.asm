%include "include/essential.inc"
%include "include/mathlib/module.inc"
%include "include/stringlib/number_to_string.inc"
%include "include/stringlib/string_len.inc"
%include "include/iolib/println.inc"
%include "include/iolib/print.inc"
%include "include/iolib/input.inc"
%include "include/iolib/put.inc"
%include "include/mmrlib/memset.inc"


section .data
    title_label db "Brainfuck Interpreter Shell (Assembly x86_64 Linux/Unix Version) | 'e' or '0' to exit", 0
    out_of_bounds_error_label db "Error: Out of bounds input", 0
    input_label db "> ", 0
    max_block_size equ 32768

section .bss
    code resb max_block_size  ; Instructions array block
    data resb max_block_size  ; Data array block
    user resb max_block_size  ; Buffer for user input

section .text
    global _start

_start:
    println title_label

    .main_loop:
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

        print input_label           ; Printing the initial label
        input code, max_block_size  ; Receiving the code as input

        ; Exit conditional
        cmp byte [code], '0'
        jz .exit
        cmp byte [code], 'e'
        jz .exit

        ; 'Variables'
        mov r15, 0  ; Instruction pointer (index)
        mov r14, 0  ; Data pointer (index)
        mov r13, 0  ; User input buffer pointer (index)

        sub rsp, 8  ; Growing the stack

        mov r15, 0  

        .read_instruction:
            mov rax, [code + r15]  ; Operation value
            mov [rsp], rax
            call operator

            inc r15
            cmp byte [code + r15], NULL
            jnz .read_instruction
        
        add rsp, 8  ; Shrinking the stack

        ; Printing a new line
        put byte 10

        jmp .main_loop
    
    .exit:
        exit 0

; PARAMETERS:
; +8 - Operator value
operator:
    ; Jump Table
    mov bl, byte [rsp + 8]
    cmp bl, '+'      ; Case: '+' (increase cell value)
    je .inc_cell
    cmp bl, '-'      ; Case: '-' (decrease cell value)
    je .dec_cell
    cmp bl, '>'      ; Case: '>' (move pointer to right)
    je .inc_ptr
    cmp bl, '<'      ; Case: '<' (move pointer to left)
    je .dec_ptr
    cmp bl, '['      ; Case: '[' (start loop)
    je .start_rep
    cmp bl, ']'      ; Case: ']' (end loop)
    je .end_rep
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
    
    .start_rep:
        ; TODO
        jmp .exit
    
    .end_rep:
        ; TODO
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

        .error_out_of_bounds:
            println out_of_bounds_error_label
            exit 1

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
        mov r12, rax
        println r12

        jmp .exit
    
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
