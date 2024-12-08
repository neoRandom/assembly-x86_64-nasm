section .text
    global _start

_start:
    mov rax, 6
    mov rbx, 2
    div rbx

    call _printRAXnumber

    add rax, 2

    call _printRAXnumber

    mov rax, 60
    mov rdi, 0
    syscall

_printRAXnumber:

    add rax, 48
    push rax     ; Pushing the value of RAX to the stack

    mov rax, 1
    mov rdi, 1
    mov rsi, rsp
    mov rdx, 1
    syscall

    pop rax
    sub rax, 48

    ret
