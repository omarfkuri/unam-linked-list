section .data
    welcome db 'Linked list', 0x0A
    welcome_len equ $ - welcome

    goodbye db 'Bye', 0x0A
    goodbye_len equ $ - goodbye

section .text
    global _start
    
    extern print_str
    extern print_hex

    extern ll_new
    extern ll_add
    extern ll_is_empty
    extern ll_delete
    extern ll_empty
    extern ll_erase_pos
    extern ll_erase_data
    extern ll_find_pos
    extern ll_find_data
    extern ll_show

_start:
    mov ecx, welcome
    mov edx, welcome_len
    call print_str

    call ll_show

    mov ecx, goodbye
    mov edx, goodbye_len
    call print_str

    mov eax, 1
    mov ebx, 0
    int 0x80