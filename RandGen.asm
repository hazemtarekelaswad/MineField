MODEL SMALL
.Data
.code
Main PROC 

   MOV AH, 00h  ; interrupts to get system time        
   INT 1AH      ; CX:DX now hold number of clock ticks since midnight      

   mov  ax, dx
   xor  dx, dx
   mov  cx, 10    
   div  cx       ; here dx contains the remainder of the division - from 0 to 9

   add  dl, '0'  ; to ascii from '0' to '9'
   mov ah, 2h   ; call interrupt to display a value in DL
   int 21h    
Main ENDP
end main

    