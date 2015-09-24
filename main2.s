.section .init
.globl _start
_start:

b main

/*
* Establece que el numero de pin ingresado, sera utilizado en el main.
*/
.macro SetPin puerto, valor
	mov r0, \puerto
	mov r1, \valor
	bl SetGpioFunction
.endm

/*
* Segun el numero ingresado de pin y la funcion (0 y 1) enciende o apaga el pin.
*/
.macro TurnLed puerto, valor
	mov r0, \puerto
	mov r1, \valor
	bl SetGpio
.endm

/*
* Segun el numero ingresado, es la frecuencia que la bocina va a hacer sonar.
*/
.macro TurnSpeaker puerto, valor
	mov r0, \puerto
	mov r1, \valor
	bl SetGpio
.endm

/*
* Comprueba que un boton sea presionado.
*/
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

	/*Se establecen los pines que se utilizaran*/
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
	
	inicioSerie:
	
		bl nuevoNivel
		bl contadorSegmento1
		bl displayTurn1
		bl contadorSegmento2
		bl displayTurn2
		
		
		bl random
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
			/* Comprueba que el boton presionado sea el que se debia para poder completar la secuencia correcta*/
				ldr r6, [r5], #4
				ldr r9, [r8], #4
				cmp r6, r9
				bne error
				bleq led6
				add r11, #1
				cmp r11, #4
				bne cicloPasarTurno
				beq inicioSerie


		
.section .data
.align 2

patronL:
	.word 0,0,0,0,0
	
patronB:
	.word 0,0,0,0,0

segmento1:
	.word 0
	
segmento2:
	.word 0
