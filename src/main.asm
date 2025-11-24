section .data
    msg_start db '--- INICIO DEL TEST ---', 0xA
    msg_start_len equ $ - msg_start
    msg_crear db '=== Creando lista ===', 0xA
    msg_crear_len equ $ - msg_crear
    msg_agregar db '=== Agregando nodos ===', 0xA
    msg_agregar_len equ $ - msg_agregar
    msg_mostrar db '=== Mostrando lista ===', 0xA
    msg_mostrar_len equ $ - msg_mostrar
    msg_buscar_pos db '=== Buscando por posicion ===', 0xA
    msg_buscar_pos_len equ $ - msg_buscar_pos
    msg_buscar_dato db '=== Buscando por dato ===', 0xA
    msg_buscar_dato_len equ $ - msg_buscar_dato
    msg_borrar_pos db '=== Borrando posicion 1 ===', 0xA
    msg_borrar_pos_len equ $ - msg_borrar_pos
    msg_borrar_dato db '=== Borrando dato 0xAA ===', 0xA
    msg_borrar_dato_len equ $ - msg_borrar_dato
    msg_vaciar db '=== Vaciando lista ===', 0xA
    msg_vaciar_len equ $ - msg_vaciar
    msg_es_vacia db '=== Comprobando si esta vacia ===', 0xA
    msg_es_vacia_len equ $ - msg_es_vacia
    msg_borrar_lista db '=== Borrando lista ===', 0xA
    msg_borrar_lista_len equ $ - msg_borrar_lista
    msg_heap db '=== HEAP DUMP ===', 0xA
    msg_heap_len equ $ - msg_heap
    msg_fin db '--- FIN DEL TEST ---', 0xA
    msg_fin_len equ $ - msg_fin
    msg_resultado db 'Resultado: '
    msg_resultado_len equ $ - msg_resultado
    newline db 0xA
    newline_len equ $ - newline

section .text
    global _start
    extern print_str
    extern print_hex
    extern print_int
    extern ll_new
    extern ll_add
    extern ll_show
    extern ll_is_empty
    extern ll_delete
    extern ll_empty
    extern ll_erase_pos
    extern ll_erase_data
    extern ll_find_pos
    extern ll_find_data
    extern mem_heap_dump

_start:
    ; 1. Print inicio
    mov ecx, msg_start
    mov edx, msg_start_len
    call print_str

    ; 2. Crear Lista
    mov ecx, msg_crear
    mov edx, msg_crear_len
    call print_str
    
    call ll_new
    mov esi, eax   ; Guardar puntero lista

    ; 3. Agregar nodos (0xAA, 0xBB, 0xCC, 0xDD)
    mov ecx, msg_agregar
    mov edx, msg_agregar_len
    call print_str

    mov eax, esi
    mov ebx, 0xAA
    mov ecx, 0
    call ll_add

    mov eax, esi
    mov ebx, 0xBB
    mov ecx, 1
    call ll_add

    mov eax, esi
    mov ebx, 0xCC
    mov ecx, 2
    call ll_add

    mov eax, esi
    mov ebx, 0xDD
    mov ecx, 3
    call ll_add

    ; 4. Mostrar lista
    mov ecx, msg_mostrar
    mov edx, msg_mostrar_len
    call print_str
    
    mov eax, esi
    call ll_show

    ; 5. Heap dump
    mov ecx, msg_heap
    mov edx, msg_heap_len
    call print_str
    call mem_heap_dump

    ; 6. Comprobar si está vacía
    mov ecx, msg_es_vacia
    mov edx, msg_es_vacia_len
    call print_str
    
    mov eax, esi
    call ll_is_empty
    
    mov ecx, msg_resultado
    mov edx, msg_resultado_len
    call print_str
    mov eax, ecx
    call print_int
    mov ecx, newline
    mov edx, newline_len
    call print_str

    ; 7. Buscar por posición (pos 2, debería ser 0xCC)
    mov ecx, msg_buscar_pos
    mov edx, msg_buscar_pos_len
    call print_str
    
    mov eax, esi
    mov ecx, 2
    call ll_find_pos
    
    mov ecx, msg_resultado
    mov edx, msg_resultado_len
    call print_str
    call print_hex
    mov ecx, newline
    mov edx, newline_len
    call print_str

    ; 8. Buscar por dato (0xBB, debería estar en pos 1)
    mov ecx, msg_buscar_dato
    mov edx, msg_buscar_dato_len
    call print_str
    
    mov eax, esi
    mov ebx, 0xBB
    call ll_find_data
    
    mov ecx, msg_resultado
    mov edx, msg_resultado_len
    call print_str
    call print_int
    mov ecx, newline
    mov edx, newline_len
    call print_str

    ; 9. Borrar posición 1 (0xBB)
    mov ecx, msg_borrar_pos
    mov edx, msg_borrar_pos_len
    call print_str
    
    mov eax, esi
    mov ebx, 1
    call ll_erase_pos
    
    mov ecx, msg_resultado
    mov edx, msg_resultado_len
    call print_str
    mov eax, ecx
    call print_int
    mov ecx, newline
    mov edx, newline_len
    call print_str
    
    mov eax, esi
    call ll_show

    ; 10. Borrar dato 0xAA
    mov ecx, msg_borrar_dato
    mov edx, msg_borrar_dato_len
    call print_str
    
    mov eax, esi
    mov ebx, 0xAA
    call ll_erase_data
    
    mov ecx, msg_resultado
    mov edx, msg_resultado_len
    call print_str
    mov eax, ecx
    call print_int
    mov ecx, newline
    mov edx, newline_len
    call print_str
    
    mov eax, esi
    call ll_show

    ; 11. Heap dump después de borrados
    mov ecx, msg_heap
    mov edx, msg_heap_len
    call print_str
    call mem_heap_dump

    ; 12. Vaciar lista
    mov ecx, msg_vaciar
    mov edx, msg_vaciar_len
    call print_str
    
    mov eax, esi
    call ll_empty
    
    mov eax, esi
    call ll_show

    ; 13. Comprobar si está vacía después de vaciar
    mov ecx, msg_es_vacia
    mov edx, msg_es_vacia_len
    call print_str
    
    mov eax, esi
    call ll_is_empty
    
    mov ecx, msg_resultado
    mov edx, msg_resultado_len
    call print_str
    mov eax, ecx
    call print_int
    mov ecx, newline
    mov edx, newline_len
    call print_str

    ; 14. Agregar más nodos para probar ll_delete
    mov ecx, msg_agregar
    mov edx, msg_agregar_len
    call print_str

    mov eax, esi
    mov ebx, 0x11
    mov ecx, 0
    call ll_add

    mov eax, esi
    mov ebx, 0x22
    mov ecx, 1
    call ll_add

    mov eax, esi
    call ll_show

    ; 15. Borrar lista completa
    mov ecx, msg_borrar_lista
    mov edx, msg_borrar_lista_len
    call print_str
    
    mov eax, esi
    call ll_delete
    
    mov ecx, msg_resultado
    mov edx, msg_resultado_len
    call print_str
    mov eax, ecx
    call print_int
    mov ecx, newline
    mov edx, newline_len
    call print_str

    ; 16. Heap dump final
    mov ecx, msg_heap
    mov edx, msg_heap_len
    call print_str
    call mem_heap_dump

    ; 17. Fin del test
    mov ecx, msg_fin
    mov edx, msg_fin_len
    call print_str

    ; Salir
    mov eax, 1
    xor ebx, ebx
    int 0x80