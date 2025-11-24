section .text
    global mem_free
    
    ; Importamos las variables globales del heap
    extern heap_start
    extern heap_end

; MemFree(ptr) -> void
; Params: 
;   eax = puntero al payload (datos)
mem_free:
    push ebp
    mov ebp, esp
    push ebx
    push esi
    push edi
    push ecx
    push edx

    ; 1. Validación: Si ptr es NULL, no hacer nada
    test eax, eax
    jz .fin_free

    ; 2. Obtener el encabezado (Header)
    ; El puntero 'eax' apunta al dato. Restamos 8 para ir al inicio del bloque.
    sub eax, 8
    mov esi, eax        ; ESI será nuestro puntero al bloque actual

    ; 3. Marcar como LIBRE (Status = 1)
    ; Estructura: [ESI] = Size, [ESI+4] = Status
    mov dword [esi + 4], 1

    ; ---------------------------------------------------------
    ; 4. Coalescer NEXT (Fusionar con el siguiente)
    ; ---------------------------------------------------------
.coalesce_next:
    mov ebx, [esi]          ; Cargar tamaño actual
    lea edi, [esi + 8 + ebx]; Calcular dirección del bloque SIGUIENTE
                            ; (Inicio + 8 header + Tamaño payload)

    ; Verificar si el siguiente bloque está dentro del heap
    cmp edi, [heap_end]
    jae .coalesce_prev      ; Si llegamos al final, pasamos a revisar el anterior

    ; Verificar si el siguiente bloque es LIBRE (Status == 1)
    cmp dword [edi + 4], 1
    jne .coalesce_prev

    ; FUSIONAR:
    ; Nuevo Tamaño = Tamaño Actual + 8 (Header del sig) + Tamaño Siguiente
    mov ecx, [edi]          ; Tamaño del siguiente
    add ecx, 8              ; Sumar los 8 bytes del header que vamos a absorber
    add [esi], ecx          ; Actualizar el tamaño del bloque actual

    ; Repetir el ciclo por si hay OTRO bloque libre después
    jmp .coalesce_next

    ; ---------------------------------------------------------
    ; 5. Coalescer PREV (Fusionar con el anterior)
    ; ---------------------------------------------------------
.coalesce_prev:
    ; Si somos el primer bloque del heap, no hay anterior
    mov eax, [heap_start]
    cmp esi, eax
    je .check_shrink

    ; Buscar el bloque anterior escaneando desde el inicio (Lista simplemente enlazada)
    mov edi, eax            ; EDI iterador (empieza en heap_start)

.loop_find_prev:
    cmp edi, esi
    jae .check_shrink       ; Seguridad: si nos pasamos, paramos

    mov ebx, [edi]          ; Tamaño del iterador
    lea ecx, [edi + 8 + ebx]; Dirección del vecino derecho del iterador

    cmp ecx, esi            ; ¿Es el iterador nuestro vecino inmediato izquierdo?
    je .found_prev

    mov edi, ecx            ; Avanzar al siguiente bloque
    jmp .loop_find_prev

.found_prev:
    ; Verificar si el bloque anterior encontrado está LIBRE
    cmp dword [edi + 4], 1
    jne .check_shrink

    ; FUSIONAR CON ANTERIOR:
    ; Sumamos nuestro tamaño total al tamaño del anterior
    mov ebx, [esi]          ; Nuestro tamaño
    add ebx, 8              ; Nuestro header
    add [edi], ebx          ; Actualizar tamaño del ANTERIOR

    mov esi, edi            ; Ahora "nuestro bloque actual" es el bloque ANTERIOR extendido
    ; No hacemos loop aquí porque solo hay un vecino izquierdo inmediato.

    ; ---------------------------------------------------------
    ; 6. Shrink Heap (Devolver memoria al sistema)
    ; ---------------------------------------------------------
.check_shrink:
    ; Verificar si este bloque libre llega hasta el final del heap
    mov ebx, [esi]          ; Tamaño actual
    lea ecx, [esi + 8 + ebx]; Dirección final del bloque

    cmp ecx, [heap_end]
    jne .fin_free

    ; Si coincide con heap_end, reducimos el heap con sys_brk
    mov ebx, esi            ; Nueva dirección final (inicio de este bloque libre)
    mov eax, 45             ; syscall 45 = brk
    int 0x80

    ; Actualizar el puntero global heap_end
    mov [heap_end], eax

.fin_free:
    pop edx
    pop ecx
    pop edi
    pop esi
    pop ebx
    pop ebp
    ret