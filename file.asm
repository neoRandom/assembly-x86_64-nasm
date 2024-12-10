%include "include/essential.inc"
%include "include/iolib/println.inc"


section .data
    content db "Hello, world!"
    content_size equ 13
    file_buffer_size equ 1024

section .bss
    file_buffer resb file_buffer_size

section .text
    global _start

_start:
    pop r15  ; Argument Count
    pop r14  ; Path
    pop r13  ; File path

    mov r8, r13
    mov r9, content
    mov r10, content_size
    call _write_file

    mov r8, r13
    call _read_file

    sys_exit 0

; input: R8 as the pointer to the path to file
; output: print the content on the default ouput
_read_file:
    ; Creating the stack frame
    push rbp
    mov rbp, rsp
    sub rsp, 8

    ; Opening the file
    mov rax, SYS_OPEN          ; Call ID
    mov rdi, r8                ; Path to file (pointer)
    mov rsi, O_RDONLY          ; Flag
    mov rdx, 0644o             ; Mode (permissions)
    syscall                    ; This is also 'int 80h' or 'int 0x80', I guess

    mov [rbp-8], rax           ; Saving the file descriptor

    ; Reading the file
    mov rax, SYS_READ          ; Call ID
    mov rdi, [rbp-8]           ; File Descriptor
    mov rsi, file_buffer       ; Buffer to store the content
    mov rdx, file_buffer_size  ; Size of the buffer
    syscall

    ; Closing the file
    mov rax, SYS_CLOSE         ; Call ID
    mov rdi, [rbp-8]           ; File Descriptor
    syscall

    ; Removing the stack frame
    add rsp, 8
    pop rbp

    println file_buffer, file_buffer_size

    ret

; input:
; - R8  as the pointer to the path to file
; - R9  as the pointer to the content to write
; - R10 as the size of the content
; output: None
_write_file:
    ; Creating the stack frame
    push rbp
    mov rbp, rsp
    sub rsp, 8

    ; Opening the file
    mov rax, SYS_OPEN          ; Call ID
    mov rdi, r8                ; Path to file (pointer)
    mov rsi, O_CREAT+O_WRONLY  ; Flag
    mov rdx, 0644o             ; Mode (permissions)
    syscall

    mov [rbp-8], rax           ; Saving the file descriptor

    ; Writing on the file
    mov rax, SYS_WRITE         ; Call ID
    mov rdi, [rbp-8]           ; File descriptor
    mov rsi, r9                ; Content buffer
    mov rdx, r10               ; Buffer size
    syscall

    ; Closing the file
    mov rax, SYS_CLOSE         ; Call ID
    mov rdi, [rbp-8]           ; File Descriptor
    syscall

    ; Removing the stack frame
    add rsp, 8
    pop rbp

    ret

; +16  Last pushed before call
; +8   Return address
; 0    RBP last value <- RBP pointed value during function
; -8   First 'variable'
