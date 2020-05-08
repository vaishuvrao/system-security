section .data
	ask1 db 'Enter a 2-digit number single digit as 05' , 10, 13
	promptlen1 equ $-ask1

	end db ' ', 10, 13
	endlen equ $-end

	checker dw 1
	fibo dw 0
	temp dw 0
	temp1 dw 0
	temp2 dw 0

section .bss
	ent resb 1
	x1 resb 1
	x2 resb 1

section .text
	global _start
_start:

	mov eax, 4
	mov ebx, 1
	mov ecx, ask1
	mov edx, promptlen1
	int 80h

	mov eax, 3		
	mov ebx, 0
	mov ecx, x1							
	mov edx, 1
	int 80h
	sub byte [x1], 30h

	mov eax, 3
	mov ebx, 0
	mov ecx, x2					
	mov edx, 1
	int 80h
	sub byte [x2], 30h

	mov eax, 3
	mov ebx, 0
	mov ecx, ent
	mov edx, 1
	int 80h

	mov al, [x1]
	mov byte [temp], 10
	mul byte [temp]
	mov [x1], al
	add al, [x2]
	mov [fibo], al

	sub esp, 2
	push word[fibo]
	call computefibo
	pop word[fibo]

	mov bl, 10			
	mov al, [fibo]
	mov ah, 0
	div bl							
	
	mov [x1], al			
	add byte [x1], 30h							
	mov [x2], ah
	add byte[x2], 30h

	mov eax, 4
	mov ebx, 1
	mov ecx, x1
	mov edx, 1
	int 80h
	
	mov eax, 4
	mov ebx, 1
	mov ecx, x2
	mov edx, 1
	int 80h

	mov eax, 4
	mov ebx, 1
	mov ecx, end
	mov edx, endlen
	int 80h
	
	mov eax, 1
	mov ebx, 0
	int 80h

	computefibo:
		mov ebp, esp
		cmp word [ebp+4], 0
		je returnzero
		cmp word [ebp+4], 1
		je returnone


		mov ax, word[ebp+4]
		dec ax
		sub esp,2
		push ax
		call computefibo
		pop word[temp1]
		mov ebp, esp
		
		push word[temp1]	
		mov bx, word[ebp+4]
		sub bx, 2
		sub esp, 2
		push bx
		call computefibo
		pop word[temp2]
		pop word[temp1]		
		mov ebp, esp
		
		
		mov ax, word[temp1]
		add ax, word[temp2]	
		mov [ebp+6], ax
		jmp exit

		returnone:
		mov word[ebp+6], 1
		jmp exit

		returnzero:
		mov word[ebp+6], 0
		jmp exit

	exit:
	ret 2
