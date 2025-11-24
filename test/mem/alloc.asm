section .data
    test_str db 'Testing "alloc"', 0x0A
    test_str_len equ $ - test_str

section .text
    global _start
    
    extern print_str
    extern mem_alloc

_start:
    mov ecx, test_str
    mov edx, test_str_len
    call print_str

    push 64          ; size
    call mem_alloc
    add esp, 4       ; clean up stack

    mov eax, 1
    mov ebx, 0
    int 0x80
