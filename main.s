.section .init
.globl _start
_start:

b main

.macro SetPin puerto, valor
	mov r0, \puerto
	mov r1, \valor
	bl SetGpioFunction
.endm


.macro TurnLed puerto, valor
	mov r0, \puerto
	mov r1, \valor
	bl SetGpio
.endm

.macro TurnSpeaker puerto, valor
	mov r0, \puerto
	mov r1, \valor
	bl SetGpio
.endm


.macro stateButton puerto
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
	
	mov r10, #0
	
	pruebaMacros:
		bl nuevoNivel
		
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
		
		bl random
		mov r4, #20
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
		movne r10, #0
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
				moveq r11, #4
				beq pasarTurno
		
		pasarTurno:
			bl verificarPatron
			add r11, #4
			cmp r11, #24
			bne pasarTurno
			beq pruebaMacros
		
			

			
	verificarPatron:
		push {lr}
		ldr r5, = patronL
		ldr r6, [r5], r11
		ldr r8, = patronB
		ldr r9, [r8], r11
		cmp r6, r9
		bleq led6
		b error
		pop {pc}
		
	comprobarRandom:
		push {lr}
		cmp r0, #0
		bleq led1
		cmp r0, #1
		bleq led2
		cmp r0, #2
		bleq led3
		cmp r0, #3
		bleq led4
		pop {pc}
		

	led1:
		push {lr}  /*r4 viene la posicion*/
		
		mov r6, #21
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
		
		mov r6, #20
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
	
		mov r6, #16
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
	
		mov r6, #12
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
		mov r5, #0
		inicioStoreListButton:
			push {lr}
			ldr r0, = patronB
			ldr r1, [r0], r5
			cmp r1, #0 
			addne r5, r5, #4
			blne inicioStoreListButton
			beq storeListB
		storeListB:
			str r6, [r0], r5
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
		moveq r6, #21
		bleq storeListButton 
		bleq led5
		
		stateButton #14
		cmp r0, #1
		bleq led2
		moveq r6, #20
		bleq storeListButton 
		bleq led5
		
		stateButton #18
		cmp r0, #1
		bleq led3
		moveq r6, #16
		bleq storeListButton 
		bleq led5
		
		stateButton #23
		cmp r0, #1
		bleq led4
		moveq r6, #12
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
		
		TurnLed #19, #1
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
	
		
.section .data
.align 2

patronL:
	.word 0,0,0,0,0
	
patronB:
	.word 0,0,0,0,0
