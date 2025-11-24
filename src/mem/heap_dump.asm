section .data
    heap_dump_msg db 'Heap Dump:', 0x0A
    heap_dump_msg_len equ $ - heap_dump_msg

    heap_dump_msg_1 db 'Dirección: '
    heap_dump_msg_1_len equ $ - heap_dump_msg_1

    heap_dump_msg_2 db 'Tamaño: '
    heap_dump_msg_2_len equ $ - heap_dump_msg_2

    heap_dump_msg_3 db 'Atributo: '
    heap_dump_msg_3_len equ $ - heap_dump_msg_3

    nl db 0x0A
    nl_len equ $ - nl

section .text
    global mem_heap_dump
    
    extern heap_start
    extern heap_end
    extern HEADER_SIZE
    extern print_str
    extern print_hex

; HeapDump() -> void
mem_heap_dump:
    push ebp
    mov ebp, esp
    push ebx
    push esi
    
    mov ecx, heap_dump_msg
    mov edx, heap_dump_msg_len
    call print_str
    
    ; Si heap_start == 0, retornar
    mov eax, [heap_start]
    cmp eax, 0
    jz .salida
    
    ; block <- heap_start
    mov esi, [heap_start]

.bucle_bloques:
    cmp esi, [heap_end]
    jae .salida

    mov ecx, nl
    mov edx, nl_len
    call print_str
    
    ; Imprimir la dirección
    mov ecx, heap_dump_msg_1
    mov edx, heap_dump_msg_1_len
    call print_str
    mov eax, esi
    call print_hex
    mov ecx, nl
    mov edx, nl_len
    call print_str
    
    ; print_hex(block_size) // eax = block_size
    mov ecx, heap_dump_msg_2
    mov edx, heap_dump_msg_2_len
    call print_str
    mov eax, [esi]
    call print_hex
    mov ecx, nl
    mov edx, nl_len
    call print_str
    
    ; print_hex(block_free_attr)
    mov ecx, heap_dump_msg_3
    mov edx, heap_dump_msg_3_len
    call print_str
    mov eax, [esi+4]
    call print_hex
    mov ecx, nl
    mov edx, nl_len
    call print_str
    
    ; block <- block + HEADER_SIZE + block_size_attr
    mov eax, [esi]       ; eax = block_size_attr
    add esi, HEADER_SIZE ; esi += HEADER_SIZE
    add esi, eax         ; esi += block_size_attr
    
    jmp .bucle_bloques

.salida:
    pop esi
    pop ebx
    pop ebp
    ret