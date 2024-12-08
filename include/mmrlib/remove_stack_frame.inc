%ifndef MMRLIB_REMOVE_STACK_FRAME
%define MMRLIB_REMOVE_STACK_FRAME


; ================================================================
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
; ================================================================


%endif
