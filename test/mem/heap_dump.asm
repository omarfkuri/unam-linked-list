section .data
    test_str db 'Testing "heap_dump"', 0x0A
    test_str_len equ $ - test_str

section .text
    global _start
    
    extern print_str
    extern mem_alloc
    extern mem_heap_dump

_start:
    mov ecx, test_str
    mov edx, test_str_len
    call print_str
    
    push 64
    call mem_alloc
    add esp, 4
    
    push 64
    call mem_alloc
    add esp, 4

    call mem_heap_dump

    mov eax, 1
    mov ebx, 0
    int 0x80