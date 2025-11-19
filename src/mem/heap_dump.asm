section .data
    heap_dump_msg db 'Heap Dump:', 0x0A
    heap_dump_msg_len equ $ - heap_dump_msg

section .text
    global mem_heap_dump

    extern print_str

; HeapDump() -> void
mem_heap_dump:
    push ebp
    mov ebp, esp

    mov ecx, heap_dump_msg
    mov edx, heap_dump_msg_len
    call print_str

    pop ebp
    ret