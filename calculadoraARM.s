@ falta validacion de signos 
	.data
n1:	.word 0x00000002
n2:	.word 0x0000000A

	.text
main:	ldr r0, =n1
	ldr r1, =n2

	ldr r0, [r0]
	ldr r1, [r1]

	bl suma
	bl resta
	bl mult
	@Se reinician los registros
	@para el cociente, la parte entera se almacena en r4 y primer decimal en r6, segundo decimal en r3
	ldr r0, =n1
	ldr r1, =n2
	ldr r0, [r0]
	ldr r1, [r1] 
	mov r2, #0
	mov r3, #0
	bl div
	mov r4, r3 @copia de la parte entera del cociente
	bl residuo @se calcula el residuo, se almacena en r4  
	mov r6, r3
	bl residuo
stop: 	wfi

suma:	add r2, r0, r1
      	mov pc, lr

resta:	sub r3, r0, r1
	mov pc, lr

mult:	mul r0, r0, r1
	mov pc, lr


div:	mov r2, r0 	
cont:	b restaS	@resta sucesiva
cte:	mov pc, lr	

restaS:	sub r2, r2, r1
	bmi cte    	@el contador no sigue sumando
	add r3, r3, #1	
	b cont

residuo: mul r3, r3, r1 
	 cmp r3, r0
         beq resulD	@como son iguales, el resultado es un cociente entero.
	 sub r5, r0, r3
	 mov r7, #10
	 mul r5, r5, r7
	 mov r3, #0
	 mov r0, r5
	 b div
resulD: mov r3, #0
	b stop
