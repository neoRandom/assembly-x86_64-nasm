%include "include/essential.inc"
%include "include/iolib/println.inc"
%include "include/iolib/print.inc"
%include "include/iolib/input.inc"

section .data
    title_label db "Brainfuck Interpreter Shell (Assembly x86_64 Linux/Unix Version) | 'e' or '0' to exit", 10
    input_label db "> ", 0
    max_block_size equ 32768

section .bss
    code resb max_block_size  ; Instructions array block
    data resb max_block_size  ; Data array block
    user resb max_block_size  ; Buffer for user input

section .text
    global _start

_start:
    println title_label, 86

    .main_loop:
        print input_label, 2   ; Printing the initial label
        input code, max_block_size  ; Receiving the code as input

        ; Exit conditional
        cmp byte [code], '0'
        jz .exit
        cmp byte [code], 'e'
        jz .exit

        ; Zeroing the instructions array
        mov rax, max_block_size
        mov rcx, 8
        mov rdx, 0
        div rcx
        mov rcx, rax        ; Number of qwords to write (32768 bytes / 8 bytes per qword)
        mov rdi, data       ; Destination address (start of the array)
        xor rax, rax        ; Value to fill (0 in this case)
        rep stosq           ; Fill the memory with zero

        ; Zeroing the user input buffer
        mov rax, max_block_size
        mov rcx, 8
        mov rdx, 0
        div rcx
        mov rcx, rax        ; Number of qwords to write (32768 bytes / 8 bytes per qword)
        mov rdi, user       ; Destination address (start of the array)
        xor rax, rax        ; Value to fill (0 in this case)
        rep stosq           ; Fill the memory with zero

        ; 'Variables'
        mov r15, 0  ; Instruction pointer
        mov r14, 0  ; Data pointer

        sub rsp, 8  ; Growing the stack

        mov qword r15, 0  

        .read_instruction:
            mov rax, [code+r15]  ; Operation value
            mov [rsp], rax
            call _operator

            inc r15
            cmp byte [code+r15], NULL
            jnz .read_instruction
        
        add rsp, 8  ; Shrinking the stack

        ; Printing a new line
        push 10
        print rsp, 1
        pop rax

        jmp .main_loop
    
    .exit:
        exit 0

; PARAMETERS:
; +8 - Operator value
_operator:
    ; Jump Table
    mov bl, byte [rsp+8]
    cmp bl, '+'    ; Case: '+' (increase cell value)
    je .inc_cell
    cmp bl, '-'    ; Case: '-' (decrease cell value)
    je .dec_cell
    cmp bl, '>'    ; Case: '>' (move pointer to right)
    je .inc_ptr
    cmp bl, '<'    ; Case: '<' (move pointer to left)
    je .dec_ptr
    cmp bl, '['    ; Case: '[' (start loop)
    je .start_rep
    cmp bl, ']'    ; Case: ']' (end loop)
    je .end_rep
    cmp bl, ','    ; Case: ',' (get input)
    je .input_cell
    cmp bl, '.'    ; Case: '.' (print cell value as ASCII)
    je .print_cell
    
    jmp .exit       ; Default

    .inc_cell:
        inc byte [data+r14]
        jmp .exit

    .dec_cell:
        dec byte [data+r14]
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
        jmp .exit

    .print_cell:
        mov rcx, data
        add rcx, r14
        print rcx, 1
        jmp .exit
    
    .exit:
        ret
