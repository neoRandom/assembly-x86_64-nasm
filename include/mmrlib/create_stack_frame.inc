%ifndef MMRLIB_CREATE_STACK_FRAME
%define MMRLIB_CREATE_STACK_FRAME


; ================================================================
; Creates a Stack Frame
;
; NOTE: The size in bytes allocated are stored at the top of the stack
; Return Address (if any) -> RBP last value -> Empty space -> Size allocated
; PARAMETERS:
; 1 - Bytes to allocate to the stack
;
%macro create_stack_frame 1
    push rbp
    mov rbp, rsp
    sub rsp, %1
    push %1
%endmacro
;
; ================================================================


%endif
