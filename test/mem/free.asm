section .data
    test_str db 'Testing "free"', 0x0A
    test_str_len equ $ - test_str

section .text
    global _start
    
    extern print_str
    extern mem_free

_start:
    mov ecx, test_str
    mov edx, test_str_len
    call print_str

    ; call mem_free

    mov eax, 1
    mov ebx, 0
    int 0x80