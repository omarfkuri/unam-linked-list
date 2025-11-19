section .text
    global mem_free
    
; MemFree(ptr) -> void

; Params: 
;   eax = value (ptr)
mem_free:
    push ebp
    mov ebp, esp

    pop ebp
    ret