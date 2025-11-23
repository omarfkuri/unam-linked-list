section .data
    ll_show_msg db 'Lista:', 0x0A
    ll_show_msg_len equ $ - ll_show_msg

section .text
    global ll_new
    global ll_add
    global ll_is_empty
    global ll_delete
    global ll_empty
    global ll_erase_pos
    global ll_erase_data
    global ll_find_pos
    global ll_find_data
    global ll_show

    extern ll_node_new
    extern ll_node_delete
    extern ll_node_show

    extern print_str
    extern print_hex

    extern mem_alloc
    extern mem_free
    extern mem_heap_dump

; CrearLista()  -> Lista

; Returns: 
;   eax = list (ptr)
ll_new:
    push ebp
    mov ebp, esp
    push ebx
    ;Pedimos memoria para el apuntador cabeza o headder
    ;Inicializamos los valores del nodo cabeza
    push 4
    call mem_alloc
    add esp, 4

    ;ahora eax tiene la direccion de la estructura lista
    ;hacemos vacía la lista
    mov dword [eax], 0    ; head = NULL

    pop ebx
    pop ebp
    ret

; AgregarLista(Lista, Dato, Posición)  -> Lista

; Params: 
;   eax = list (ptr)
;   ebx = data (ptr)
;   ecx = position (int)

; Returns: 
;   ecx = list (ptr)
ll_add:
    push ebp
    mov ebp, esp

    pop ebp
    ret

; EsVacia(Lista)  -> Booleano

; Params: 
;   eax = list (ptr)

; Returns: 
;   ecx = empty (bool)
ll_is_empty:
    push ebp
    mov ebp, esp

    ;sabemos que eax tiene la direccion de la estructura lista
    ;si esta vacia eax tiene un 0
    mov edx, [eax]  ; edx = head
    cmp edx, 0
    je .is_empty

    mov ecx, 0      ; vacía = false
    jmp .salida
.is_empty:
    mov ecx, 1      ; vacía = true

.salida:
    pop ebp
    ret

; BorrarLista(Lista) -> Boleano

; Params: 
;   eax = list (ptr)

; Returns: 
;   ecx = deleted (bool)
ll_delete:
    push ebp
    mov ebp, esp

    pop ebp
    ret

; Vacia(Lista) -> Lista

; Params: 
;   eax = list (ptr)

; Returns: 
;   ecx = list (ptr)
ll_empty:
    push ebp
    mov ebp, esp

    pop ebp
    ret

; BorrarPos(Lista, Posición) -> Booleano

; Params: 
;   eax = list (ptr)
;   ebx = position (int)

; Returns: 
;   ecx = deleted (bool)
ll_erase_pos:
    push ebp
    mov ebp, esp

    pop ebp
    ret

; BorrarDato(Lista, Dato) -> Booleano

; Params: 
;   eax = list (ptr)
;   ebx = data (ptr)

; Returns: 
;   ecx = deleted (bool)
ll_erase_data:
    push ebp
    mov ebp, esp

    pop ebp
    ret

; BuscarPos(Lista, Posición) -> Dato
ll_find_pos:
    push ebp
    mov ebp, esp
    push esi

    mov esi, [eax] ; esi = head
    test esi, esi
    jz .no_encontrado ; lista vacía

.forBuscar:
    cmp ecx, 0
    je .encontrado

    mov esi, [esi + 4] ; esi = nodo->siguiente

    test esi, esi
    jz .no_encontrado

    dec ecx
    jmp .forBuscar

.encontrado:
    mov eax, [esi] ; eax = nodo->dato
    jmp .finBuscar

.no_encontrado:
    mov eax, 0     ; no encontrado

.finBuscar:
    pop esi
    pop ebp
    ret

; BuscarDato(Lista, Dato) -> Posición
ll_find_data:
    push ebp
    mov ebp, esp
    push esi
    push ecx ; contador de posicion

    mov esi, [eax] ; esi = head
    xor ecx, ecx  ; ecx = 0 (posición)

.forBuscarDato:
    test esi, esi
    jz .dato_no_encontrado ; fin de lista

    mov eax, [esi] ; eax = nodo->dato
    cmp eax, ebx  ; comparar con dato buscado
    je .dato_encontrado

    mov esi, [esi + 4] ; esi = nodo->siguiente
    inc ecx
    jmp .forBuscarDato

.dato_encontrado:
    mov eax, ecx  ; eax = posición
    jmp .finBuscarDato

.dato_no_encontrado:
    mov eax, -1    ; no encontrado

.finBuscarDato:
    pop ecx
    pop esi
    pop ebp
    ret

; MostrarLista(Lista) -> Nada
ll_show:
    push ebp
    mov ebp, esp
    push esi
    push ebx

    push eax ; guardamos lista
    mov ecx, ll_show_msg
    mov edx, ll_show_msg_len
    call print_str
    pop eax ; recuperamos lista

    ;movemos la dirección del primer nodo para recorrer la lista
    mov esi, [eax] ; esi = head

.forNodos:
    test esi, esi
    jz .finNodos
    ;mostramos el nodo actual
    mov ecx, [esi] ; ecx = nodo->dato
    call print_hex
    ;avanzamos al siguiente nodo
    mov esi, [esi + 4] ; esi = nodo->siguiente
    jmp .forNodos

.finNodos:
    pop ebx
    pop esi
    pop ebp
    ret
