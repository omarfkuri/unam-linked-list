section .text
    global mem_alloc

; MemAlloc(size) -> ptr

; Params: 
;   eax = size (int)

; Returns: 
;   ecx = value (ptr)
mem_alloc:
    push ebp
    mov ebp, esp

    pop ebp
    ret