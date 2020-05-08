section .data
msg: db "enter the string",10,0
string:times 10 db 0

section .text
extern printf
extern scanf
extern strlen
global _main
_main:
	push ebp
	mov ebp, esp
	sub esp, 288
	lea edx, [ebp-224]
	mov eax, 0
	mov ecx, 25
	mov edi, edx
	rep stos
	lea eax, [ebp-288]
	mov edi, eax
	mov eax, 0
	call scanf
	lea eax, [ebp-288]
	mov edi, eax
	call strlen
	mov DWORD [ebp-12], eax
	mov DWORD  [ebp-4], 0
	jmp L2
L5:
	mov DWORD  [ebp-8], 0
	mov eax, DWORD  [ebp-4]
	cdq
	mov DWORD  [ebp-224+eax*4], 1
L4:
	add DWORD  [ebp-8], 1
	mov edx, DWORD  [ebp-4]
	mov eax, DWORD  [ebp-8]
	add eax, edx
	cdq
	movzx edx, BYTE  [ebp-288+eax]
	mov eax, DWORD  [ebp-4]
	cdq
	movzx eax, BYTE  [ebp-288+eax]
	cmp dl, al
	jne L3
	mov eax, DWORD  [ebp-4]
	cdq
	mov eax, DWORD  [ebp-224+eax*4]
	lea edx, [eax+1]
	mov eax, DWORD  [ebp-4]
	cdq
	mov DWORD  [ebp-224+eax*4], edx
L3:
	mov edx, DWORD  [ebp-4]
	mov eax, DWORD  [ebp-8]
	add eax, edx
	cdq
	movzx edx, BYTE  [ebp-288+eax]
	mov eax, DWORD  [ebp-4]
	cdq
	movzx eax, BYTE  [ebp-288+eax]
	cmp dl, al
	je L4
	mov eax, DWORD  [ebp-4]
	cdq
	movzx eax, BYTE  [ebp-288+eax]
	movsx edx, al
	mov eax, DWORD  [ebp-4]
	cdq
	mov eax, DWORD  [ebp-224+eax*4]
	mov esi, edx
	mov edi, eax
	call printf
	mov eax, DWORD  [ebp-4]
	cdq
	mov eax, DWORD  [ebp-224+eax*4]
	add DWORD  [ebp-4], eax
L2:
	mov eax, DWORD  [ebp-4]
	cmp eax, DWORD  [ebp-12]
	jl L5
	nop
	nop
	leave
	ret
