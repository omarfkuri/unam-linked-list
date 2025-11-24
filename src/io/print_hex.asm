section .text
    global print_hex
    
section .data
    buffer_hex db '0x00000000', 0
    nl db 10    

; PrintHex(int) -> void

; Params: 
;   eax = value (int)
print_hex:
    push ebp
    mov ebp, esp
    push eax
    push ebx
    push ecx
    push edx
    push edi
    
    mov ecx, 8
    mov edi, buffer_hex + 9

    add ebx, '0'
    add ebx, 'x'
    
convertir_hex:
    mov ebx, eax
    and ebx, 0xF
    cmp ebx, 9
    jle digito_num
    add ebx, 55
    jmp almacenar
    
digito_num:
    add ebx, '0'
    
almacenar:
    mov [edi], bl
    dec edi
    shr eax, 4
    loop convertir_hex
    
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer_hex
    mov edx, 10
    int 0x80
    
    ; mov eax, 4
    ; mov ebx, 1
    ; mov ecx, nl
    ; mov edx, 1
    ; int 0x80
    
    pop edi
    pop edx
    pop ecx
    pop ebx
    pop eax
    pop ebp
    ret