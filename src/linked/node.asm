section .data
    ll_node_show_msg_beg db 'Nodo{ '
    ll_node_show_msg_beg_len equ $ - ll_node_show_msg_beg

    ll_node_show_msg_end db ' }', 0x0A
    ll_node_show_msg_end_len equ $ - ll_node_show_msg_end

section .text
    global ll_node_new
    global ll_node_delete
    global ll_node_show

    extern print_str
    extern print_int
    extern print_hex
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
; Params: 
;   eax = nodo (ptr)
; Returns: 
;   eax = borrado (bool: 1 si se borró, 0 si falló)
ll_node_delete:
    push ebp
    mov ebp, esp
    push ebx
    
    ; Verificar si el nodo es NULL
    test eax, eax
    jz .nodo_null
    
    ; Liberar la memoria del nodo
    call mem_free
    
    ; Retornar 1
    mov eax, 1
    jmp .fin_borrar
    
.nodo_null:
    ; Retornar 0
    xor eax, eax
    
.fin_borrar:
    pop ebx
    pop ebp
    ret

; MostarNodo(Nodo) -> void

; Params: 
;   ecx = address (ptr)
ll_node_show:
    push ebp
    mov ebp, esp

    mov ecx, ll_node_show_msg_beg
    mov edx, ll_node_show_msg_beg_len
    call print_str

    push esi
    call print_hex
    pop esi

    mov ecx, ll_node_show_msg_end
    mov edx, ll_node_show_msg_end_len
    call print_str

    ; mov eax

    pop ebp
    ret