%ifndef MMRLIB
%define MMRLIB


; ===================================
; Creates a Stack Frame
;
; PARAMETERS:
; 1 - Bytes to allocate to the stack
;
%macro create_stack_frame 1
    push rbp
    mov rbp, rsp
    sub rsp, %1
%endmacro
;
; ===================================


; =================================
; Removes the Stack Frame
;
; PARAMETERS:
; 1 - Bytes allocated to the stack
;
%macro remove_stack_frame 1
    add rsp, %1
    pop rbp
%endmacro
;
; =================================
    
%endif
