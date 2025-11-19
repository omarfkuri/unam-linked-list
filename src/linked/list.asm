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

; CrearLista()  -> Lista

; Returns: 
;   ecx = list (ptr)
ll_new:
    push ebp
    mov ebp, esp

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

    pop ebp
    ret

; BuscarDato(Lista, Dato) -> Posición
ll_find_data:
    push ebp
    mov ebp, esp

    pop ebp
    ret

; MostrarLista(Lista) -> Nada
ll_show:
    push ebp
    mov ebp, esp

    mov ecx, ll_show_msg
    mov edx, ll_show_msg_len
    call print_str

    pop ebp
    ret
