
section .data
    question: db "What is your name? "
    answer: db "Hello, "

section .bss
    name: resb 1024

section .text
    global _start

_start:
    mov r15, question
    mov r14, 19
    call _print

    mov r15, name
    mov r14, 1024
    call _input


    mov r15, answer
    mov r14, 7
    call _print

    mov r15, name
    mov r14, 1024
    call _print

    call _exit

_print:
    mov rax, 1
    mov rdi, 1
    mov rsi, r15
    mov rdx, r14
    syscall
    ret

_input:
    mov rax, 0
    mov rdi, 0
    mov rsi, r15
    mov rdx, r14
    syscall
    ret

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
