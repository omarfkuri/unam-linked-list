section .data
    heap_start dd 0
    heap_end dd 0
    HEADER_SIZE equ 8

section .text
    global mem_alloc

; MemAlloc(size) -> ptr
; Params: 
;   eax = size (int)
; Returns: 
;   ecx = value (ptr)
mem_alloc:
    push ebp
    mov ebp, esp
    push ebx ;Sirve pa la llamada a la interrupción
    push esi

    ; si size = 0 return NUll
    mov ecx, [ebp+8] ;cargamos el size
    cmp ecx, 0
    jz return_Null
    ;Si heap_start = 0 Entonces
    mov eax, [heap_start]
    cmp eax, 0
    jnz iniciado
    ;heap_start <- syscall_brk(0)  //Obtener el valor de inicio del heap
    ;heap_end <- heap_start
    mov eax, 45
    xor ebx, ebx
    int 0x80 ; eax ya tiene la dir del heap

    mov [heap_start], eax
    mov [heap_end], eax

iniciado:
    ; block <- heap_start //Asignamos el inicio del bloque nuevo
    mov esi, [heap_start]
    buscar_bloque:
    ;Mientras block < heap_end Hacer
    cmp esi, [heap_end]
    jae no_encontrado ;Si esi >= heap_end, rompemos el bucle (vamos a pedir memoria)

    ;block_size_payload <- block_size_attr // block_size = [block]
    mov eax, [esi]

    ;block_free <- block_free_attr // block_free = [block+4]
    mov edx, [esi+4] ; acá es pa ver el estado del bloque 

    ;Si block_free = 1 y block_size_payload >= size Entonces
    cmp edx, 1
    jne siguiente_bloque
    cmp eax, ecx
    jl siguiente_bloque

    ;block_free_attr <- 0  // [block +4] = 0 Marcar como ocupado
    mov dword [esi+4], 0

    ;old_ptr <- block + HEADER_SIZE 
    add esi, 8
    mov eax, esi
    jmp salida ;//Return

siguiente_bloque:
    ;block <- block + HEADER_SIZE + block_size_payload
    add esi, 8
    add esi, eax
    jmp buscar_bloque

no_encontrado:
;//Si no hay bloques libres -> pedir mas memoria al sistema
;old_end <- heap_end
    mov ebx, [heap_end]
    push ebx
;new_end <- old_end + size + HEADER_SIZE
    mov eax, ecx ;size
    add eax, 8       ;size + HEADER_SIZE
    add eax, ebx     ;old_end + size + HEADER_SIZE
;// Pedir la memoria
;new_end <-syscall_brk(new_end)	
    mov ebx, eax
    mov eax, 45
    int 0x80

;// Inicializar el encabezado del nuevo bloque
;block <- old_end // inicio del nuevo bloque
    pop esi              ; Recuperamos esi
;block_size_paylod <- size // [block] = size
    mov [esi], ecx
;block_free_attr <- 0  // [block + 4 ] = 0  ocupado
    mov dword [esi+4], 0
;heap_end <- new_end
    mov [heap_end], eax
;old_ptr <- block + HEADER_SIZE
    add esi, 8
;//return old_ptr
    mov eax, esi
    jmp salida

return_Null:
    xor eax, eax           ; EAX = 0 (NULL)

salida:
    pop esi
    pop ebx                
    mov esp, ebp
    pop ebp
    ret