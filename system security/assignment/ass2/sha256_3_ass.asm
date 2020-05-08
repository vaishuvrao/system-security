section .data

  msg_usage       db    'usage: sha2-256 <string to hash>', 0xa
  msg_usage_len   equ   $ - msg_usage

  i               dd    0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a, 0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19

  k               dd    0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5, 0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174, 0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da, 0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967, 0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85, 0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070, 0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3, 0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2


section .bss
  chk resd  64     
  stt resd  8      


section .text
  global _start               
_start:

  pop   eax                    
  cmp   eax, 2                  
  jne   help                   
  pop   esi                    
  pop   esi                    

  mov   edi, esi               
  mov   ecx, -1                
  mov   eax, 0                 
  cld
  repne scasb                  
  not   ecx                    
  dec   ecx                    


  call  pad

  shr   ecx, 4                 
  xor   ebx, ebx                
a0:
  call  extend
  call  compress
  inc   ebx
  cmp   ebx, ecx
  jne   a0


  mov   esi, i
  mov   ecx, 8
  call  print_memd
  jmp   exit


pad:
 
  mov   eax, ecx
  and   eax, 0x3f               
  cmp   eax, 56
  jb    m0
  mov   edx, 119               
  jmp   m1
m0:
  mov   edx, 55                 
m1:
  sub   edx, eax
  mov   ebx, 0                
  mov   eax, 45                 
  int   0x80
  mov   edi, eax               
  mov   ebx, eax             
  add   ebx, ecx                
  add   ebx, edx
  add   ebx, 9
  mov   eax, 45
  int   0x80
  xor   ebx, ebx                
m2:
  xor   eax, eax               
  mov   al, [esi+ebx]          
  shl   eax, 8                 
  inc   ebx
  cmp   ecx, ebx                
  jz    m3
  mov   al, [esi+ebx]          
  shl   eax, 8
  inc   ebx
  cmp   ecx, ebx
  jz    m4
  mov   al, [esi+ebx]          
  shl   eax, 8
  inc   ebx
  cmp   ecx, ebx
  jz    m5
  mov   al, [esi+ebx]          
  inc   ebx
  mov   [edi+ebx-4], eax        
  cmp   ecx, ebx
  jnz   m2
  mov   al, byte 0x80          
  shl   eax, 24                
  add   ebx, 4                 
  jmp   m6
m3:
  mov   al, byte 0x80          
  shl   eax, 16
  add   ebx, 3
  jmp   m6
m4:
  mov   al, byte 0x80         
  shl   eax, 8
  add   ebx, 2
  jmp   m6
m5:
  mov   al, byte 0x80          
  inc   ebx
m6:
  mov   [edi+ebx-4], eax       
  mov   esi, edi                
  add   edi, ebx               

  mov   ebx, ecx              
  mov   ecx, edx               
  shr   ecx, 2            
  xor   eax, eax               
  cld
  rep   stosd                

  shl   ebx, 3
  mov   [edi], eax              
  mov   [edi+4], ebx           
  add   edi, 8

  mov   ecx, edi
  sub   ecx, esi
  shr   ecx, 2

  ret


extend:
  
  pusha

 
  mov   ecx, 16                 
  shl   ebx, 6
  add   esi, ebx               
  mov   edi, chk              
  cld
  rep   movsd

 
s0:
  mov   eax, [chk+ecx*4+4]     
  mov   ebx, eax
  mov   edx, eax
  ror   eax, 7
  ror   ebx, 18
  shr   edx, 3
  xor   eax, ebx
  xor   eax, edx
  mov   ebx, [chk+ecx*4+56]     
  mov   edx, ebx
  mov   esi, ebx
  ror   ebx, 17
  ror   edx, 19
  shr   esi, 10
  xor   ebx, edx
  xor   ebx, esi
  add   eax, ebx                
  add   eax, [chk+ecx*4]
  add   eax, [chk+ecx*4+36]
  mov   [chk+ecx*4+64], eax
  inc   ecx
  cmp   ecx, 48              
  jnz   s0

  popa
  ret


compress:

p0:

  mov   eax, [stt]              
  mov   esi, eax
  mov   ebx, [stt+4]           
  mov   edx, [stt+8]      
  and   eax, ebx
  and   ebx, edx
  and   edx, esi
  xor   eax, ebx
  xor   eax, edx               

  mov   ebx, esi                
  ror   ebx, 2
  ror   edx, 13
  ror   esi, 22
  xor   ebx, edx
  xor   ebx, esi               

  add   eax, ebx               

  mov   ebx, [stt+16]          
  mov   edx, ebx
  mov   esi, ebx
  mov   edi, ebx
  ror   ebx, 6
  ror   edx, 11
  ror   esi, 25
  xor   ebx, edx
  xor   ebx, esi               

  mov   edx, edi               
  not   edx
  and   edi, [stt+20]          
  mov   esi, [stt+24]           
  and   edx, esi
  xor   edx, edi                

  add   ebx, edx
  add   ebx, [stt+28]        
  add   ebx, [chk+ecx*4]
  add   ebx, [k+ecx*4]        

  mov   [stt+28], esi         
  mov   edi, [stt+20]
  mov   [stt+24], edi
  mov   edx, [stt+16]
  mov   [stt+20], edx
  mov   edx, [stt+12]
  add   edx, ebx
  mov   [stt+16], edx
  mov   edx, [stt+8]
  mov   [stt+12], edx
  mov   edx, [stt+4]
  mov   [stt+8], edx
  add   eax, ebx
  mov   ebx, [stt]
  mov   [stt+4], ebx
  mov   [stt], eax

  inc   ecx
  cmp   ecx, 64
  jl    p0

  add   [i], eax
  add   [i+4], ebx
  mov   edx, [stt+8]
  add   [i+8], edx
  mov   edx, [stt+12]
  add   [i+12], edx
  mov   edx, [stt+16]
  add   [i+16], edx
  mov   edx, [stt+20]
  add   [i+20], edx          
  add   [i+24], edi
  add   [i+28], esi

  popa
  ret


print_memd:
 
  pusha

 
  mov   ebx, 0                 
  mov   eax, 45                 
  int   0x80
  mov   edi, eax               
  mov   ebx, eax               
  shl   ecx, 2
  add   ebx, ecx                
  add   ebx, 1                 
  mov   eax, 45
  int   0x80                   
  mov   [edi+ecx*2], byte 0xa  
  shl   ecx, 1
  inc   ecx
  push  ecx                     
  shr   ecx, 3
g0:
  dec   ecx
  mov   eax, [esi+ecx*4]       
  mov   edx, 8                 
g1:
  dec   edx                    
  mov   ebx, eax                
  and   ebx, 0xf                
  cmp   ebx, 10                
  jb    g2
  add   ebx, 0x27               
g2:
  add   ebx, 0x30               
  add   edi, edx
  mov   [edi+ecx*8], bl        
  sub   edi, edx
  shr   eax, 4                 
  cmp   edx, 0                 
  ja    g1
  test  ecx, ecx               
  jnz   g0


  pop   edx                   
  mov   ecx, edi               
  mov   ebx, 1                 
  mov   eax, 4                 
  int   0x80                   

  popa
  ret                          

help:

exit:

  mov   ebx, 0                 
  mov   eax, 1                 
  int   0x80                   
