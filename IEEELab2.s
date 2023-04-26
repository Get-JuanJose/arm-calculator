	.data
word1:	.word 0x4209B000 @4209B000en binario en decimal 34.432175
word2:	.word 0x496A54A0 @el positivo es 496A54A0 - C96A54A0 en binario 1100 1001 0110 1010 0101 0100 1010 0000 en decimal -959818
				
	.text
	@Se mueven datos entre registros
main:	ldr r0, =word1 	@Se almacena la direccion de memoria del dato en el registro r0.
	ldr r1, =word2 
	ldr r3, =0x80000000
	ldr r0, [r0]	@Se obtiene el dato almacenado en la direccion de memoria dentro de r0.
	ldr r1, [r1]

	@Se comienza el movimiento SIGNO
	lsl r0,r0, #1	@Se mueve a la izquierda una vez.
	lsl r1,r1, #1
	@Se comienza el movimiento mantizaspara poder comparar exponentes
	lsr r0,r0, #24	@Se mueve 24 veces a la derecha, para determinar el mayor exponente.
	lsr r1,r1, #24
	@se dejan solos los exponentes de cada uno

	
	cmp r0,r1	@Compara cual exponente es mayor
	beq suma	@iguales exponentes
	cmp r0,r1
	bne detEM 	@Determina exponente menor


detEM: 	cmp r0,r1
	bmi pMenor 	@el primer exponente es menor
	cmp r0,r1
	bpl sMenor	@El segundo exponente es menor


	@SE igualan exponentes al mayor
pMenor:	sub r2, r1,r0 	@se pone primero el menor para que el resultado de positivo y lo almacenamos en otra registro
	@Se mueven datos del registro menor.
	ldr r0, =word1 	@Se almacena la direccion de memoria del dato en el registro r0.	
	ldr r0, [r0]	@Se obtiene el dato almacenado en la direccion de memoria dentro de r0.
	
	lsl r0, #9	@se corre la mantisa al principio
	lsr r0, #1	@se corre la mantisa a la derecha para poder sumar el 1
	add r0, r0, r3	@se suma un uno en el bit 32
	lsr r0, #9	@Se mueven los 8 bits del exponente a la derecha
	sub r2, r2, #1  @Como añadimos el uno cuenta como haber movido la mantisa 1 vez
	lsr r0, r2	@se igualan las mantisas
		
	ldr r1, =word2
	ldr r1, [r1]
	
	mov r5, r1	@se crea una copia de r1 en otro registro 
	
	lsl r1, #9	@se corre para la derecha 9 veces para borrar el signo y el exponente
	lsr r1, #9	@se corre para la derecha para quedar al mismo nivel la mantisa


	lsr r5, #23	@Se corre 23 veces a la derecha para borrar la mantisa
	lsl r5, #23 	@Se corre 23 veces a la izquierda para que quede el signo y el exp al principiio
	
	@signos iguales se suman y se conserva el signo. Signos diferentes se restan y se pone el signo del mayor
	ldr r6, =word1
	ldr r7, =word2 
	ldr r6, [r6]
	ldr r7, [r7]

	lsr r6, #31
	lsr r7, #31

	cmp r6, r7
	bmi sMayorResta @negativo
	cmp r6, r7
	beq sumaDirecta
	

	@SE igualan exponentes al mayor
sMenor:	sub r2, r0,r1	@almacenamos el resultado de la resta en otro registro para saber cuanto se va a mover
	ldr r1, =word2 	@Se almacena la direccion de memoria del dato en el registro r0.	
	ldr r1, [r1]	@Se obtiene el dato almacenado en la direccion de memoria dentro de r0.
	
	lsl r1, #9	@se corre la mantisa al principio
	lsr r1, #1	@se corre la mantisa a la derecha para poder sumar el 1
	add r1, r1, r3	@se suma un uno en el bit 32
	lsr r1, #9	@Se mueven los 8 bits del exponente a la derecha
	sub r2, r2, #1
	lsr r1, r2

	ldr r0, =word1 	@Se extrae el dato del registro del mayor exp
	ldr r0, [r0]	@se extrae el dato y se almacena en un registro
	
	mov r5, r0	@se crea una copia de r1 en otro registro 
	
	lsl r0, #9	@se corre para la derecha 9 veces para borrar el signo y el exponente
	lsr r0, #9	@se corre para la derecha para quedar al mismo nivel la mantisa

	add r4, r1, r0  @obtenemos la suma de mantisas

	lsr r5, #23	@Se corre 23 veces a la derecha para borrar la mantisa
	lsl r5, #23 	@Se corre 23 veces a la izquierda para que quede el signo y el exp al principiio
	
	ldr r6, =word1
	ldr r7, =word2 
	ldr r6, [r6]
	ldr r7, [r7]

	lsr r6, #31
	lsr r7, #31

	cmp r6, r7
	bpl pMayorResta @positivo
	cmp r6, r7
	beq sumaDirecta
	add r5, r5, r4 @Se suman las mantisas, teniendo en cuenta que r1, almacena solo y solo la mantisa
			
suma: 	ldr r0, =word1 	
	ldr r1, =word2 
	ldr r0, [r0]
	ldr r1, [r1]
	
	lsl r0, #9
	lsr r0, #9
	lsl r1, #9 
	lsr r1, #9	

	add r2, r0, r1

	ldr r4, =word1
	ldr r4, [r4]
	
	lsr r4, #23
	lsl r4, #23
	
	add r4, r4, r2
	
	
sMayorResta: 	sub r4, r1, r0  
		add r5, r5, r4

pMayorResta: 	sub r4, r0, r1 @cambio  
		add r5, r5, r4

sumaDirecta:	add r4, r1, r0  
		add r5, r5, r4

stop:	wfi
