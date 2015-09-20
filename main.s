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
				/*beq pasarTurno*/
				beq pruebaMacros
		
		/*		
		*mov r11, #4
		*pasarTurno:
		*	bl verificarPatron
		*	add r11, #4
		*	cmp r11, #24
		*	bne pasarTurno
		*	beq pruebaMacros
		*/
			

			
	verificarPatron:
		push {lr}
		ldr r5, = patron
		ldr r6, [r5], r11
		ldr r8, = temp
		ldr r9, [r8], r11
		cmp r6, r9
		bleq led5
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
		bl storeList
		
		TurnLed #21, #1
		ldr r0, = 500000
		bl Wait
		TurnLed #21, #0
		ldr r0, = 500000
		bl Wait
		pop {pc}
		
	led2:
		push {lr}
		
		mov r6, #20
		bl storeList
	
		TurnLed #20, #1
		ldr r0, = 500000
		bl Wait
		TurnLed #20, #0
		ldr r0, = 500000
		bl Wait
		pop {pc}
		
	led3:
		push {lr}
	
		mov r6, #16
		bl storeList
		
		TurnLed #16, #1
		ldr r0, = 500000
		bl Wait
		TurnLed #16, #0
		ldr r0, = 500000
		bl Wait
		pop {pc}
		
	led4:
		push {lr}
	
		mov r6, #12
		bl storeList
		
		TurnLed #12, #1
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
		
	storeList:
		push {lr}
		mov r5, r4
		ldr r0, = patron
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
		bleq led5
		
		stateButton #14
		cmp r0, #1
		bleq led2
		bleq led5
		
		stateButton #18
		cmp r0, #1
		bleq led3
		bleq led5
		
		stateButton #23
		cmp r0, #1
		bleq led4
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

patron:
	.word 0,0,0,0,0
	
patron1:
.word 21,21,21,21

temp:
.int 21,21,21,21
