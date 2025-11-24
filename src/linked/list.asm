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
    push esi
    push edi
    push ebx

    mov ecx, ebx ; dato
    call ll_node_new

    mov ebx, eax ; nuevo nodo

    ;inicio
    cmp ecx, 0
    je .agregar_inicio

    mov edx, [esi]      ; edx = Head actual
    test edx, edx
    jz .agregar_inicio

    mov esi, eax
    mov edi, ecx ; posición

    dec edi

.forAgregar:
    cmp edi, 0
    jz .agregar_inicio

    cmp dword [edx + 4], 0
    je .agregar_enmedio

    mov edx, [edx + 4] ; edx = nodo->siguiente
    dec edi
    jmp .forAgregar

.agregar_enmedio:
    ; enlazamos el nuevo nodo
    mov eax, [edx+4]    ; Guardamos el 'Siguiente' del Anterior
    mov [ebx+4], eax    ; Nuevo->Siguiente = Viejo Siguiente
    mov [edx+4], ebx    ; Anterior->Siguiente = Nuevo
    jmp .fin_agregar

.agregar_inicio:
    mov eax, [esi]      ; Guardamos el Head actual
    mov [ebx+4], eax    ; Nuevo->Siguiente = Head actual
    mov [esi], ebx      ; Lista->Head = Nuevo

.fin_agregar:
    mov ecx, esi        ; Retornamos el puntero de la lista en ECX

    pop ebx             ; Restauramos registros
    pop edi
    pop esi
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
    push esi
    push edi
    
    ; Verificar si la lista es NULL
    test eax, eax
    jz .delete_failed
    
    mov esi, eax        ; Apuntador a lista
    mov edi, [eax]      ; edi = head
    
    ; Liberar todos los nodos
.delete_loop:
    test edi, edi
    jz .delete_list_struct
    
    mov ebx, [edi + 4]  ; ebx = siguiente nodo
    mov eax, edi        ; eax = nodo actual
    push ebx            ; Guardar siguiente
    call ll_node_delete
    pop edi             ; Recuperar siguiente como actual
    jmp .delete_loop
    
.delete_list_struct:
    ; Liberar la estructura de la lista
    mov eax, esi
    call mem_free
    
    ; Retornar 1
    mov ecx, 1
    jmp .delete_end
    
.delete_failed:
    ; Retornar 0
    xor ecx, ecx
    
.delete_end:
    pop edi
    pop esi
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
    push esi
    push edi
    
    ; Verificar si la lista es NULL
    test eax, eax
    jz .empty_end
    
    mov esi, eax        ; Guardar puntero a la lista
    mov edi, [eax]      ; edi = head
    
    ; Liberar todos los nodos
.empty_loop:
    test edi, edi
    jz .empty_list
    
    mov ebx, [edi + 4]  ; ebx = siguiente nodo
    mov eax, edi        ; eax = nodo actual
    push ebx            ; Guardar siguiente
    call ll_node_delete
    pop edi             ; Recuperar siguiente como actual
    jmp .empty_loop
    
.empty_list:
    ; Establecer head = NULL
    mov dword [esi], 0
    mov ecx, esi
    jmp .empty_end
    
.empty_end:
    pop edi
    pop esi
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
    push esi
    push edi
    
    ; Verificar si la lista es NULL
    test eax, eax
    jz .erase_pos_failed
    
    mov esi, [eax]      ; esi = head
    test esi, esi
    jz .erase_pos_failed ; Lista vacía
    
    ; Caso especial: borrar posición 0 (head)
    cmp ebx, 0
    je .erase_head
    
    ; Buscar el nodo anterior a la posición
    mov edi, esi        ; edi = nodo actual
    dec ebx             ; Ajustar para encontrar el anterior
    
.find_prev:
    cmp ebx, 0
    je .found_prev
    
    mov edi, [edi + 4]  ; edi = siguiente
    test edi, edi
    jz .erase_pos_failed ; Posición fuera de rango
    
    dec ebx
    jmp .find_prev
    
.found_prev:
    ; edi = nodo anterior
    mov esi, [edi + 4]  ; esi = nodo a borrar
    test esi, esi
    jz .erase_pos_failed ; No hay nodo en esa posición
    
    ; Desenlazar el nodo
    mov ebx, [esi + 4]  ; ebx = siguiente del nodo a borrar
    mov [edi + 4], ebx  ; Anterior->siguiente = siguiente del borrado
    
    ; Liberar el nodo
    mov eax, esi
    call ll_node_delete
    
    mov ecx, 1          ; Retornar éxito
    jmp .erase_pos_end
    
.erase_head:
    ; Borrar el head
    mov edi, [esi + 4]  ; edi = nuevo head
    mov [eax], edi      ; Lista->head = nuevo head
    
    ; Liberar el viejo head
    mov eax, esi
    call ll_node_delete
    
    mov ecx, 1
    jmp .erase_pos_end
    
.erase_pos_failed:
    xor ecx, ecx
    
.erase_pos_end:
    pop edi
    pop esi
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

    push esi
    push edi
    push edx
    
    ; Verificar si la lista es NULL
    test eax, eax
    jz .erase_data_failed
    
    mov esi, eax        ; esi = puntero a la lista
    mov edi, [eax]      ; edi = head
    test edi, edi
    jz .erase_data_failed ; Lista vacía
    
    ; Caso especial: el dato está en el head
    mov edx, [edi]      ; edx = dato del head
    cmp edx, ebx
    je .erase_data_head
    
    ; Buscar el nodo que contiene el dato
    mov edx, edi        ; edx = nodo de antes
    mov edi, [edi + 4]  ; edi = nodo actual
    
.find_data:
    test edi, edi
    jz .erase_data_failed ; No se encontró el dato
    
    mov eax, [edi]      ; eax = dato del nodo actual
    cmp eax, ebx
    je .found_data
    
    mov edx, edi
    mov edi, [edi + 4]
    jmp .find_data
    
.found_data:
    ; edx = nodo anterior, edi = nodo a borrar
    mov eax, [edi + 4]  ; eax = siguiente del nodo a borrar
    mov [edx + 4], eax  ; prev->siguiente = siguiente del borrado
    
    ; Liberar el nodo
    mov eax, edi
    call ll_node_delete
    
    mov ecx, 1          ; Retornar éxito
    jmp .erase_data_end
    
.erase_data_head:
    ; Borrar el head
    mov eax, [edi + 4]  ; eax = nuevo head
    mov [esi], eax      ; lista->head = nuevo head
    
    ; Liberar el viejo head
    mov eax, edi
    call ll_node_delete
    
    mov ecx, 1          ; Retornar éxito
    jmp .erase_data_end
    
.erase_data_failed:
    xor ecx, ecx        ; Retornar 0 (falló)
    
.erase_data_end:
    pop edx
    pop edi
    pop esi
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
    mov eax, [esi] ; eax = nodo->dato
    push esi
    call ll_node_show
    pop esi
    ;avanzamos al siguiente nodo
    mov esi, [esi + 4] ; esi = nodo->siguiente
    jmp .forNodos

.finNodos:
    pop ebx
    pop esi
    pop ebp
    ret
