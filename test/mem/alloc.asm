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
