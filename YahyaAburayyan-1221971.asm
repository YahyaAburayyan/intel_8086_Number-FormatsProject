;Yahya Aburayyan - 1221971
;ENCS336 assembly project

.model small
.stack 100h
.data
   msg1 db 'Please enter a number between 0 and 999(as 3 digit format xxx) :    ','$'
 
   D_num dw 3 dup(?) 

   msg2 db 13,10,13,10,'1- The number in binary format is : $'
   msg3 db 13,10,'2- The number in hexadecimal format is : $'
   msg4 db 13,10,'3- The number in Roman format is : $'
   
   C db 'C$'
   CC db 'CC$'
   CCC db 'CCC$'
   CD db 'CD$'
   D db 'D$'
   DC db 'DC$'
   DCC db 'DCC$'
   DCCC db 'DCCC$'
   CM db 'CM$'
   X db 'X$'
   XX db 'XX$'
   XXX db 'XXX$'
   XL db 'XL$'
   L  db 'L$'
   LX db 'LX$'
   LXX db 'LXX$'
   LXXX db 'LXXX$'
   XC db 'XC$'
   I db 'I$'
   II db 'II$'
   III db 'III$'
   IV db 'IV$'
   V db 'V$'
   VI db 'VI$'
   VII db 'VII$'
   VIII db 'VIII$'
   IX db 'IX$'
.code 
START:
mov ax,@data
mov ds,ax



basefoure proc
mov ax,D_num 
mov cx,0
mov dx,0 

pushtostack:   
cmp ax,0
je finish 

mov bx,4
div bx
push dx
inc cx

xor dx,dx  

jmp pushtostack

finish:
cmp cx,0    
je done

pop dx  

numx:
add dx,30h      
;printing here
mov ah,02h
 
dec cx
jmp finish

donee:
ret
basefoure endp     


















; reading the num from the user
mov ah,09h
lea dx,msg1
int 21h

CALL readDecimal

; convert to binary :-
mov ah,09h
lea dx,msg2 
INT 21H
CALL binaryConvert

; convert to hexadecimal :-
mov ah,09h
lea dx,msg3
INT 21H
CALL hexaConvert

;; convert to Roman format:
mov ah,09h
lea dx,msg4
INT 21H
CALL roamanConvert

mov ax, 4C00h
int 21h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

; reading the num from the user subroutine
readDecimal proc 
xor cx,cx
xor si,si
      
read_digit:

mov ah,01h
int 21h
sub al,30h ; to get the actual decimal value not the ASCII

; cx is initialiy zero
cmp cx,0
je hunds

cmp cx,1
je tens

cmp cx,2
je ones


hunds:     ; for the hundreds digit
mov ah,0
mov bl,100
mul bl     ;AX=AL*BL
add si,ax
inc cx
jmp read_digit 

tens:      ; for the tens digit
mov ah,0
mov bl,10
mul bl
add si,ax
inc cx
jmp read_digit

ones:      ; for the ones digit
mov ah,0
add si,ax
inc cx
jmp endin

endin: 
      
mov dx,si 
mov D_num,dx ; save the num in the memory

ret
readDecimal endp



; convert to binary subroutine :-
binaryConvert Proc
xor bx,bx 
xor cx,cx ; counter

mov cx,10 ; the largest 3 digit num (999) can be reprsented in 10 bit     
      


shl si,6 ; to ignore the most 6-bits

while:
shl si,1 ; logical shift so the MSB go carry flag
jc one ; if there is carry then jump
; if not then contenue

mov ah,02h
mov dl,'0'; to print 0
dec cx
INT 21H
cmp cx,0 ; if counter is zero then finish
je n
jmp while ; else continue

one:
mov ah,02h
mov dl,'1' ; to print 1
dec cx
INT 21H
cmp cx,0
je n
jmp while
n:
ret
binaryConvert endp

;n:

; convert to hexadecimal :-
hexaConvert proc
mov ax,D_num ; or from memorey
mov cx,0 ; to count how many hex digit we need to represent the num 
mov dx,0 ; cuse the extended mul / div (DX:AX)

tostack:  ; keep divide and push the remainder to stack till qushient is zero 
cmp ax,0
je printing ; if the quchient became zero start printing the num 

mov bx,16
div bx
push dx
inc cx

xor dx,dx   ; cuse of DX:AX

jmp tostack

printing:
cmp cx,0   ; print the num of digit you get from above 
je nexxt

pop dx  ; to get the first hex digit 

cmp dx,9 
jle num  ; if lees or equal than 9

add dx,7  ; if not then its a Latter between (A-F) and A is after 7 characters from 9 in the ASCII table

num:
add dx,30h ; to convert it to ASCII to be able to print
mov ah ,02h
INT 21H     ; print it

dec cx
jmp printing

nexxt:
ret
hexaConvert endp     
     

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     
;; convert to Roman format:
roamanConvert proc

mov ax,D_num ; get the num from memorey

xor dx,dx  ; registers may be used 
xor cx,cx
xor si,si
xor di,di

;get the hundreds digit
mov bx,ax 
mov cx,100
div cx
mov si,ax
mov di,dx ; remainder is used for net div

; compare the digit to now what equivilant to it
cmp si,1
je printC
cmp si,2
je printCC
cmp si,3
je printCCC
cmp si,4
je printCD
cmp si,5
je printD
cmp si,6
je printDC
cmp si,7
je printDCC
cmp si,8
je printDCCC
cmp si,9
je printCM
jmp tensDigit ; if no one of them true the means the digit is zero so dont print any thing and jump to tens digit

;printing the equivilant to the digit
printC:
mov ah,09h
lea dx,C
INT 21H
jmp tensDigit ; after print go to the tens
printCC:
mov ah,09h
lea dx,CC
INT 21H
jmp tensDigit 
printCCC:
mov ah,09h
lea dx,CCC
INT 21H
jmp tensDigit 
printCD:
mov ah,09h
lea dx,CD
INT 21H
jmp tensDigit 
printD:
mov ah,09h
lea dx,D
INT 21H
jmp tensDigit 
printDC:
mov ah,09h
lea dx,DC
INT 21H
jmp tensDigit 
printDCC:
mov ah,09h
lea dx,DCC
INT 21H
jmp tensDigit 
printDCCC:
mov ah,09h
lea dx,DCCC
INT 21H
jmp tensDigit 
printCM:
mov ah,09h
lea dx,CM
INT 21H
jmp tensDigit



tensDigit:

mov ax,di
xor dx,dx
mov cx,10  ; to get tens digit 
div cx
mov di,dx
mov si,ax

cmp si,1
je printX
cmp si,2
je printXX
cmp si,3
je printXXX
cmp si,4
je printXL
cmp si,5
je printL
cmp si,6
je printLX
cmp si,7
je printLXX
cmp si,8
je printLXXX
cmp si,9
je printXC       
jmp onesDigit

printX:
mov ah,09h
lea dx,X
INT 21H
jmp onesDigit
printXX:
mov ah,09h
lea dx,XX
INT 21H
jmp onesDigit 
printXXX:
mov ah,09h
lea dx,XXX
INT 21H
jmp onesDigit 
printXL:
mov ah,09h
lea dx,XL
INT 21H
jmp onesDigit 
printL:
mov ah,09h
lea dx,L
INT 21H
jmp onesDigit 
printLX:
mov ah,09h
lea dx,LX
INT 21H
jmp onesDigit 
printLXX:
mov ah,09h
lea dx,LXX
INT 21H
jmp onesDigit 
printLXXX:
mov ah,09h
lea dx,LXXX
INT 21H
jmp onesDigit 
printXC:
mov ah,09h
lea dx,XC
INT 21H
jmp onesDigit

onesDigit:

mov si,di   ; the final remainder is the ones digit 

cmp si,1
je printI
cmp si,2
je printII
cmp si,3
je printIII
cmp si,4
je printIV
cmp si,5
je printV
cmp si,6
je printVI
cmp si,7
je printVII
cmp si,8
je printVIII
cmp si,9
je printIX
jmp done

printI:
mov ah,09h
lea dx,I
INT 21H
jmp done   ; after printing the ones digit there is no left digits so we are done 
printII:
mov ah,09h
lea dx,II
INT 21H
jmp done 
printIII:
mov ah,09h
lea dx,III
INT 21H
jmp done 
printIV:
mov ah,09h
lea dx,IV
INT 21H
jmp done 
printV:
mov ah,09h
lea dx,V
INT 21H
jmp done 
printVI:
mov ah,09h
lea dx,VI
INT 21H
jmp done 
printVII:
mov ah,09h
lea dx,VII
INT 21H
jmp done 
printVIII:
mov ah,09h
lea dx,VIII
INT 21H
jmp done 
printIX:
mov ah,09h
lea dx,IX
INT 21H
jmp done

done:

ret
roamanConvert endp     
     

 

end START