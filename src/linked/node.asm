section .data
    ll_node_show_msg db 'Nodo:', 0x0A
    ll_node_show_msg_len equ $ - ll_node_show_msg

section .text
    global ll_node_new
    global ll_node_delete
    global ll_node_show

    extern print_str

; CrearNodo(Dato) -> Nodo

; Params: 
;   eax = size (int)

; Returns: 
;   ecx = value (ptr)
ll_node_new:
    push ebp
    mov ebp, esp

    pop ebp
    ret

; BorrarNodo(Nodo) -> Booleano
ll_node_delete:
    push ebp
    mov ebp, esp

    pop ebp
    ret

; MostarNodo(Nodo) -> void
ll_node_show:
    push ebp
    mov ebp, esp

    mov ecx, ll_node_show_msg
    mov edx, ll_node_show_msg_len
    call print_str

    pop ebp
    ret