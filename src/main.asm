section .data
    msg_start db '--- INICIO DEL TEST ---', 0xA, 0

section .text
    global _start

    extern print_str
    extern ll_new
    extern ll_add
    extern ll_show

    extern mem_heap_dump

_start:
    ; 1. Print Debug
    mov ecx, msg_start
    mov edx, 24
    call print_str

    ; 2. Crear Lista
    call ll_new
    ; SI TRUENA AQUÍ, es mem_alloc fallando al escribir heap_start
    
    mov esi, eax   ; Guardar puntero lista

    ; 3. Agregar nodos
    mov eax, esi
    mov ebx, 0xAA
    mov ecx, 0
    call ll_add

    mov eax, esi
    mov ebx, 0xBB
    mov ecx, 1
    call ll_add

    ; 4. Mostrar
    mov eax, esi
    call ll_show

    ; 5. Mostrar dump
    call mem_heap_dump

    ; Salir
    mov eax, 1
    xor ebx, ebx
    int 0x80