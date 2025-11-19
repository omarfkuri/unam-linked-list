section .text
    global print_str

; PrintStr(ptr, int) -> void

; Params: 
;   ecx = string (ptr)
;   edx = length (int)
print_str:
    push ebp
    mov ebp, esp
    push eax
    push ebx
    push ecx
    push edx
    
    mov eax, 4
    mov ebx, 1
    int 0x80
    
    pop edx
    pop ecx
    pop ebx
    pop eax
    pop ebp
    ret