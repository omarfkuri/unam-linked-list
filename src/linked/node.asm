section .data
    ll_node_show_msg db 'Nodo:', 0x0A
    ll_node_show_msg_len equ $ - ll_node_show_msg

section .text
    global ll_node_new
    global ll_node_delete
    global ll_node_show

    extern print_str
    extern mem_alloc
    extern mem_free

; CrearNodo(Dato) -> Nodo

; Params: 
;   ecx = size (int)

; Returns: 
;   eax = value (ptr)
ll_node_new:
    push ebp
    mov ebp, esp
    push ebx
    push ecx

    ; 1. Pedir memoria: 8 bytes (4 dato + 4 siguiente)
    push 8
    call mem_alloc
    add esp, 4

    pop ecx

    test eax, eax
    jz .fin_nuevo_nodo    ; Si es 0, retornamos error osea malloc no jala bien  
    
    mov [eax], ecx       ; guardamos el Dato
    mov dword [eax+4], 0 ; Siguiente = NULL

.fin_nuevo_nodo:
    pop ebx
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