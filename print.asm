section .data
    text db "Hello, world!", 10, 0

section .bss
    number_to_string_buffer resb 1024

section .text
    global _start

_start:
    call _testnumber_to_string

    mov rax, 60
    mov rdi, 0
    syscall

; input: RAX as a pointer to a string
; output: print string
; _print:


; Registers used: RAX
; input: RAX as a pointer to a null-terminated string
; output: RAX as the length of the string
string_len:
    ; rax = address of the string
    ; rsp[0] = counter
    push 0

    string_len_loop:
    inc qword [rsp]       ; Increment the counter
    inc rax               ; Increment the string pointer (move to the end)
    cmp byte [rax], 0     ; Compare the value of the character with 0
    jnz string_len_loop  ; If the value is not 0, jump to the loop label
    
    pop rax

    ret

; Registers used: RAX, RCX, RDX, R8, R9, R10
; input: RAX as the number to be converted
; output: 
; - RAX as a pointer to the generated string
; - RCX as the size of the string
number_to_string:
    ; Initial values
    mov rcx, 10   ; Divisor
    mov r8, 0     ; Digit counter
    mov r9, 1024  ; Index counter
    mov r10, 0    ; String size counter

    ; Clear the buffer
    .clear_the_buffer:
    dec r9                                    ; Decrementing the counter
    mov byte [number_to_string_buffer+r9], 0  ; Cleaning the cell. Note: r9 starts at 1023, because the buffer is already at cell 1
    cmp r9, 0
    jnz .clear_the_buffer

    ; Test for negative numbers
    cmp rax, 0
    jge .not_negative

    ; If it's negative
    neg rax                                 ; Inverting the number
    mov byte [number_to_string_buffer], 45  ; Pushing the negative sign as the first character
    mov r10, 1                              ; Incrementing the string size counter

    .not_negative:
    ; Test for zero
    cmp rax, 0
    jnz .not_zero

    ; If it's zero
    mov byte [number_to_string_buffer], 48
    inc r10
    jmp .skip_if_zero

    .not_zero:
    ; Looping to add each digit of the RAX to the stack
    .add_digit_to_stack:         ; DO WHILE the value of RAX is greater than 0
    call _module                 ; RDX = RAX % RCX (10) and RAX /= RCX (10)
    push rdx                     ; Pushing the remainder (digit) to the stack
    inc r8                       ; Incrementing the counter
    cmp rax, 0
    jnz .add_digit_to_stack

    ; For each digit stored in the stack, convert into character and add it to the buffer
    .push_digit_to_buffer:
    pop rax                                     ; Removing the value from the stack and storing at RAX
    dec r8                                      ; Decrementing the digit counter
    add rax, 48                                 ; Converting the number to an ASCII character
    mov byte [number_to_string_buffer+r10], al  ; Storing the character in the buffer
    inc r10                                     ; Incrementing the string size counter
    cmp r8, 0
    jnz .push_digit_to_buffer

    .skip_if_zero:
    ; Adding a null character to the end of the string
    mov byte [number_to_string_buffer+r10], 0
    inc r10

    ; Setting RAX as the buffer
    mov rax, number_to_string_buffer
    mov rcx, r10

    ret

; Registers used: RAX, RCX, RDX
; input: 
; - RAX as the number to be divided
; - RCX as the divisor
; output: 
; - RAX as the quotient
; - RDX as the remainder
_module:
    mov rdx, 0
    div rcx

    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;               UNIT TESTS               ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Expected output: 41
_test_module:
    mov rax, 14
    mov rcx, 10
    call _module

    add rax, 48
    add rdx, 48
    push rax
    push rdx

    mov rax, 1
    mov rdi, 1
    mov rdx, 1

    mov rsi, rsp
    syscall

    pop rsi
    mov rsi, rsp
    syscall
    pop rsi

    ret

; Expected output: 10
_testnumber_to_string:
    ; Normal test
    mov rax, 10
    call number_to_string
    push rax

    mov rax, 1
    mov rdi, 1
    mov rsi, [rsp]
    mov rdx, 2
    syscall

    pop rax

    ; New line
    push 10

    mov rax, 1
    mov rdi, 1
    mov rsi, rsp
    mov rdx, 1
    syscall

    pop rax

    ; Negative number
    mov rax, -1
    call number_to_string
    push rax

    mov rax, 1
    mov rdi, 1
    mov rsi, [rsp]
    mov rdx, 2
    syscall

    pop rax

    ; New line
    push 10

    mov rax, 1
    mov rdi, 1
    mov rsi, rsp
    mov rdx, 1
    syscall

    pop rax

    ; Zero
    mov rax, 0
    call number_to_string
    push rax

    mov rax, 1
    mov rdi, 1
    mov rsi, [rsp]
    mov rdx, 1
    syscall

    pop rax

    ; Floating point
    ; TODO

    ret
