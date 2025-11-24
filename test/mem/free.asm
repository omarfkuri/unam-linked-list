section .data
    test_str db 'Testing "free"', 0x0A
    test_str_len equ $ - test_str

section .text
    global _start
    
    extern print_str
    extern mem_alloc
    extern mem_free

_start:
    mov ecx, test_str
    mov edx, test_str_len
    call print_str
    
    push 64
    call mem_alloc
    add esp, 4
    
    ; Llamada directamente porque
    ; mem_alloc regresa apuntador en eax
    call mem_free
    
    ; Exit
    mov eax, 1
    mov ebx, 0
    int 0x80