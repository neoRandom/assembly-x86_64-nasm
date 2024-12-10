%ifndef IOLIB_PRINT
%define IOLIB_PRINT


; ================================================================
; Wrapper of the (private) function __print
;
; PARAMETERS:
; 1 - Pointer of the content to write
; 
%macro print 1
    ; Setting the parameters
    push %1
    call __print
    pop rax
%endmacro
;
; ================================================================


; ================================================================
; Wrapper of the SYS_WRITE, prints a null-terminated string
;
; DEPENDENCIES: 'string_len' from 'stringlib'
; PARAMETERS:
; 1 - Pointer of the content to write
; 
__print:
    ; Getting the size of the string
    mov rax, [rsp+8]
    call string_len
    mov rdx, rax

    ; Printing the string
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, [rsp+8]
    syscall

    ret
;
; ================================================================


%endif
