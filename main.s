.section .init
.globl _start
_start:

b main
/* 
* Macro para codificar la funcion de un pin.
* Utiliza la funcion SetGpioFunction
* puerto = cualquier puerto 
* valor = 1 o 0
*/
.macro SetPin puerto, valor
	mov r0, \puerto
	mov r1, \valor
	bl SetGpioFunction
.endm

/*
* Macro para encender o apagar un led
* Utiliza la funcion SetGpio
* puerto = cualquier puerto de salida
* valor = 1 if HIGH; 0 if LOW
*/
.macro TurnLed puerto, valor
	mov r0, \puerto
	mov r1, \valor
	bl SetGpio
.endm


.section .text

main:
	/*Carga direccion de memoria*/
	mov sp, #0x8000
	
	/*
	*Configuracion de puertos GPIO
	*8 salida: 7 segmentos
	*1 salida: 1 bocina
	*4 salida: 4 leds
	*5 entrada: 5 boton
	*/
	
	/*
	*Botones:
	*	1: pin 14
	*	2: pin 15
	*	3: pin 18
	*	4: pin 23
	*/
	SetPin #14, #0
	SetPin #15, #0
	SetPin #18, #0
	SetPin #23, #0
	
	/*
	*LEDS:
	*	1: pin 21
	*	2: pin 20
	*	3: pin 16
	*	4: pin 12
	*/
	SetPin #21, #1
	SetPin #20, #1
	SetPin #16, #1
	SetPin #12, #1
	
	inicioDelJuego:
		/*jalar random*/
		/* ro = random*/
		bl random
		bl comprobarRandom
		bl comprobarBoton
		
		
		
		
	/*
	* Subrutina que genera un numero aleatorio entre 0 y 3.
	* Salida: r0 = numero aleatorio.
	*/
	random:
		push {lr}
		bl GetTimeStamp
		and r0,#3
		pop {pc}

	/*
	* Subrutina para ver cual es el numero aleatorio, para adherirlo a un numero de led
	* Entrada: r0 = numero aleatorio
	* Salida: r0 = numeroDePin
	* Numero y pin(led):
	*	0: LED 1, pin #21
	*	1: LED 2, pin #20
	*	2: LED 3, pin #16
	*	3: LED 4, pin #12
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
		
	/*
	* Subrutinas para encender cada LED. Sirven para cuando se salta desde comprobar Random
	*/
	led1:
		push {lr}
		TurnLed #21, #1
		ldr r0, = 500000
		bl Wait
		pop {pc}
	led2:
		push {lr}
		TurnLed #20, #1
		ldr r0, = 500000
		bl Wait
		pop {pc}
	led3:
		push {lr}
		TurnLed #16, #1
		ldr r0, = 500000
		bl Wait
		pop {pc}
	led4:
		push {lr}
		TurnLed #12, #1
		ldr r0, = 500000
		bl Wait
		pop {pc}
		
	/*
	* Subrutina para verificar que se presiona el boton indicado, segun el numero de led encendido
	* Entrada: r0 = numero de pin. (Determina el lsl y )
	* Salida: r0 = 1 if HIGH
	*/
	comprobarBoton:
		push {lr}
		mov r6, r0
		bl GetGpioAddress
		mov r4, r0
		ldr r5, [r4, #0x34]
		mov r0,#1
		lsl r0,r6
		and r5,r0
		teq r5, #0
		moveq r0, #1
		bne error
		pop {pc}
		
	/*
	* Subrutina para emitir un parpadeo de LEDS para informar al usuario que ha ingresado un patron incorrecto.
	*/
	error:
		TurnLed #7, #1
		TurnLed #8, #1
		TurnLed #9, #1
		TurnLed #10, #1
		ldr r0, = 500000
		bl Wait
		TurnLed #7, #0
		TurnLed #8, #0
		TurnLed #9, #0
		TurnLed #10, #0
		ldr r0, = 1000000
		bl Wait
		
		b inicioDelJuego
		
	
	
.section .data
.align 2

patron:
.word 1,2,3,4
	

	
