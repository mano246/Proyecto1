.section .init
.globl _start
_start:

b main

.macro SetPin puerto, valor   @asigna la funcion especificada por el programa al pin deseado 
	mov r0, \puerto
	mov r1, \valor
	bl SetGpioFunction
.endm


.macro TurnLed puerto, valor   @recibe puerto y numero de led para encender un led deseado
	mov r0, \puerto
	mov r1, \valor
	bl SetGpio
.endm

.macro TurnSpeaker puerto, valor   @recibe puerto y el valor para hacer sonar la bocina 
	mov r0, \puerto
	mov r1, \valor
	bl SetGpio
.endm


.macro stateButton puerto       @recibe el valor que esta indicando el boton, si esta presionado o no
	ldr r5, [r4, #0x34]
	mov r0, #1
	lsl r0, \puerto
	and r5, r0
	teq r5, #0
	moveq r0, #0
	movne r0, #1
.endm

.section .text

main:
	mov sp, #0x8000
				@se les asigna la funcion indicada a cada pin para ser salida o entrada (4 entradas 15 salidas)
	SetPin #14, #0
	SetPin #15, #0
	SetPin #18, #0
	SetPin #23, #0
	

	SetPin #21, #1
	SetPin #20, #1
	SetPin #16, #1
	SetPin #12, #1
	SetPin #26, #1
	SetPin #19, #1
	SetPin #13, #1
	
	SetPin #2, #1
	SetPin #3, #1
	SetPin #4, #1
	SetPin #17, #1
	
	SetPin #27, #1
	SetPin #22, #1
	SetPin #10, #1
	SetPin #9, #1
	
	mov r10, #0
	
	pruebaMacros:   		  @inicia el ciclo donde se recorre todo el juego
		bl nuevoNivel
		
		bl random		@se generan los randoms para la primer secuencia a mostrar 
		mov r4, #0
		bl comprobarRandom
		
		bl random
		mov r4, #4
		bl comprobarRandom
		
		bl random
		mov r4, #8
		bl comprobarRandom
		
		bl random
		mov r4, #12
		bl comprobarRandom
		
		bl random
		mov r4, #16
		bl comprobarRandom
		
		
		add r10, #1
		cmp r10, #2
		ldreq r0, = 50000
		bleq Wait
		beq finTurno
		cmp r10, #3
		ldreq r0, = 30000
		bleq Wait
		beq finTurno
		moveq r10, #0
		bne finTurno
	
		
		finTurno:
			mov r9, #0
			ciclo:
				push {r9}
				bl comprobarBoton
				pop {r9}
				add r9, #1
				bl led5
				cmp r9, #20
				bne ciclo
				moveq r11, #0
				beq pasarTurno
		
		pasarTurno:
			ldr r5, = patronL
			ldr r8, = patronB
			cicloPasarTurno: 
				ldr r6, [r5], #4
				ldr r9, [r8], #4
				cmp r6, r9
				bne error
				bleq led6
				add r11, #1
				cmp r11, #4
				bne cicloPasarTurno
				beq pruebaMacros
		

	comprobarRandom:
		push {lr}
		cmp r0, #0
		bleq led1
		cmp r0, #1   /*aqui r0 ya se cambio*/
		bleq led2
		cmp r0, #2
		bleq led3
		cmp r0, #3
		bleq led4
		pop {pc}
		

	led1:
		push {lr}  /*r4 viene la posicion*/
		
		mov r6, #1
		bl storeListL
		
		TurnLed #21, #1
		bl sound1
		ldr r0, = 500000
		bl Wait
		TurnLed #21, #0
		ldr r0, = 500000
		bl Wait
		pop {pc}
		
	led2:
		push {lr}
		
		mov r6, #2
		bl storeListL
	
		TurnLed #20, #1
		bl sound2
		ldr r0, = 500000
		bl Wait
		TurnLed #20, #0
		ldr r0, = 500000
		bl Wait
		pop {pc}
		
	led3:
		push {lr}
	
		mov r6, #3
		bl storeListL
		
		TurnLed #16, #1
		bl sound3
		ldr r0, = 500000
		bl Wait
		TurnLed #16, #0
		ldr r0, = 500000
		bl Wait
		pop {pc}
		
	led4:
		push {lr}
	
		mov r6, #4
		bl storeListL
		
		TurnLed #12, #1
		bl sound4
		ldr r0, = 500000
		bl Wait
		TurnLed #12, #0
		ldr r0, = 500000
		bl Wait
		pop {pc}
	
	led5:
		push {lr}
		TurnLed #26, #1
		ldr r0, = 500000
		bl Wait
		TurnLed #26, #0
		pop {pc}
	
	led6:
		push {lr}
		TurnLed #19, #1
		ldr r0, = 500000
		bl Wait
		TurnLed #19, #0
		ldr r0, = 500000
		bl Wait
		pop {pc}
	
	sound1: 
		push {lr}
		TurnSpeaker #13, #1
		ldr r0, = 1911
		bl Wait
		
		TurnSpeaker #13, #0
		ldr r0, = 1911
		bl Wait
		
		add r5, #1
		ldr r6, =75
		cmp r5, r6
		ble	sound1
		mov r5,#0
		pop {pc}
		
	sound2:
		push {lr}
		TurnSpeaker #13, #1
		ldr r0, = 1703
		bl Wait
		
		TurnSpeaker #13, #0
		ldr r0, = 1703
		bl Wait
		
		add r5, #1
		ldr r6, =75
		cmp r5, r6
		ble	sound2
		mov r5,#0
		pop {pc}
		
	sound3:
		push {lr}
		TurnSpeaker #13, #1
		ldr r0, = 1517
		bl Wait
		
		TurnSpeaker #13, #0
		ldr r0, = 1517
		bl Wait
		
		add r5, #1
		ldr r6, =75
		cmp r5, r6
		ble	sound3
		mov r5,#0
		pop {pc}
		
	sound4:
		push {lr}
		TurnSpeaker #13, #1
		ldr r0, = 1452
		bl Wait
		
		TurnSpeaker #13, #0
		ldr r0, = 1452
		bl Wait
		
		add r5, #1
		ldr r6, =75
		cmp r5, r6
		ble	sound4
		mov r5,#0
		pop {pc}
		
	storeListL:
		push {lr}
		mov r5, r4
		ldr r0, = patronL
		str r6, [r0], r5
		pop {pc}
	
	storeListButton: /* Entrada: r6 = pin, r5= numero de posicion*/
		push {lr}
		ldr r0, = patronB
		inicioStoreListButton:
			ldr r1, [r0], #4			/*llegar al final del arreglo, y comparar*/
			cmp r1, #0 
			bne inicioStoreListButton
			beq storeListB
		storeListB:
			str r6, [r0]
			pop {pc}
		
	random:
		push {lr}
		bl GetTimeStamp
		and r0, #3		
		pop {pc}
			
	
	comprobarBoton:
		push {lr}
		bl GetGpioAddress
		mov r4, r0
		stateButton #15
		cmp r0, #1
		bleq led1
		moveq r6, #1
		bleq storeListButton 
		bleq led5
		
		stateButton #14
		cmp r0, #1
		bleq led2
		moveq r6, #2
		bleq storeListButton 
		bleq led5
		
		stateButton #18
		cmp r0, #1
		bleq led3
		moveq r6, #3
		bleq storeListButton 
		bleq led5
		
		stateButton #23
		cmp r0, #1
		bleq led4
		moveq r6, #4
		bleq storeListButton 
		bleq led5	
		pop {pc}
		
	error:
		TurnLed #21, #1
		TurnLed #20, #1
		TurnLed #16, #1
		TurnLed #12, #1
		ldr r0, = 300000
		bl Wait
		TurnLed #21, #0
		TurnLed #20, #0
		TurnLed #16, #0
		TurnLed #12, #0
		ldr r0, = 300000
		bl Wait
		TurnLed #21, #1
		TurnLed #20, #1
		TurnLed #16, #1
		TurnLed #12, #1
		ldr r0, = 300000
		bl Wait
		TurnLed #21, #0
		TurnLed #20, #0
		TurnLed #16, #0
		TurnLed #12, #0
		ldr r0, = 300000
		bl Wait
	
		bl led5
				
		bl sound1
		bl sound2
		bl sound3
		
		bl numero1
		b pruebaMacros
		
	nuevoNivel:
		push {lr}
		TurnLed #21, #1
		TurnLed #20, #1
		TurnLed #16, #1
		TurnLed #12, #1
		ldr r0, = 300000
		bl Wait
		TurnLed #21, #0
		TurnLed #20, #0
		TurnLed #16, #0
		TurnLed #12, #0
		ldr r0, = 300000
		bl Wait
		TurnLed #21, #1
		TurnLed #20, #1
		TurnLed #16, #1
		TurnLed #12, #1
		ldr r0, = 300000
		bl Wait
		TurnLed #21, #0
		TurnLed #20, #0
		TurnLed #16, #0
		TurnLed #12, #0
		ldr r0, = 300000
		bl Wait

		pop {pc}
	
	displayScore1:
		push {lr}
		cmp r9,#1
		bleq numero1
		
		cmp r9,#2
		beq numero2
		cmp r9,#3
		beq numero3
		cmp r9,#4
		beq numero4
		cmp r9,#5
		beq numero5
		cmp r9,#6
		beq numero6
		cmp r9,#7
		beq numero7
		cmp r9,#8
		beq numero8
		cmp r9, #9
		beq numero9
		pop {pc}
		
	numero1:
		push {lr}
		TurnLed #2, #1
		TurnLed #3, #0
		TurnLed #4, #0
		TurnLed #17, #0
		pop {pc}
	numero2:
		push {lr}
		TurnLed #2, #0
		TurnLed #3, #1
		TurnLed #4, #0
		TurnLed #17, #0
		pop {pc}

	numero3: 
		push {lr}
		TurnLed #2, #1
		TurnLed #3, #1
		TurnLed #4, #0
		TurnLed #17, #0
		pop {pc}
	numero4:
		push {lr}
		TurnLed #2, #0
		TurnLed #3, #0
		TurnLed #4, #1
		TurnLed #17, #0
		pop {pc}
	numero5:
		push {lr}
		TurnLed #2, #1
		TurnLed #3, #0
		TurnLed #4, #1
		TurnLed #17, #0
		pop {pc}
	numero6:
		push {lr}
		TurnLed #2, #0
		TurnLed #3, #1
		TurnLed #4, #1
		TurnLed #17, #0
		pop {pc}
	numero7:
		push {lr}
		TurnLed #2, #1
		TurnLed #3, #1
		TurnLed #4, #1
		TurnLed #17, #0
		pop {pc}
	numero8:
		push {lr}
		TurnLed #2, #0
		TurnLed #3, #0
		TurnLed #4, #0
		TurnLed #17, #1
		pop {pc}
	numero9:
		push {lr}
		TurnLed #2, #1
		TurnLed #3, #0
		TurnLed #4, #0
		TurnLed #17, #1
		pop {pc}
		
.section .data
.align 2

patronL:
	.word 0,0,0,0,0
	
patronB:
	.word 0,0,0,0,0
