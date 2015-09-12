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
* valor = 1 o 0
*/
.macro SetLed puerto, valor
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
	
	SetPin #7, #1
	SetPin #8, #1
	SetPin #9, #1
	SetPin #10, #1
	SetPin #11, #1
	SetPin #12, #1
	SetPin #13, #1
	SetPin #14, #1
	SetPin #15, #1
	SetPin #16, #1
	SetPin #17, #1
	SetPin #18, #1
	SetPin #19, #1
	
	SetPin #20, #0
	SetPin #21, #0
	SetPin #22, #0
	SetPin #23, #0
	SetPin #24, #0
	
	inicioDelJuego:
		/*jalar random*/
		/* ro = random*/
		bl comprobarRandom
		bl comprobarBoton
		
		
		
		
		
		
		
		
		
		
	/*
	* Subrutina para ver cual es el numero aleatorio, para adherirlo a un numero de led
	* Entrada: r0 = numero aleatorio
	* Salida: r0 = numeroDePin
	* Numero y pin(led):
	*	0: LED 1, pin #7
	*	1: LED 2, pin #8
	*	2: LED 3, pin #9
	*	3: LED 4, pin #10
	comprobarRandom:
		push {lr}
		cmp r0, #0
		SetLedeq #7, #0
		moveq r0, #7
		cmp r0, #1
		SetLedeq #8, #0
		moveq r0, #8
		cmp r0, #2
		SetLedeq #9, #0
		moveq r0, #9
		cmp r0, #3
		SetLedeq #10, #0
		moveq r0, #10
		pop {pc}
		
	/*
	* Subrutina para verificar que se presiona el boton indicado, segun el numero de led encendido
	* Entrada: r0 = numero de pin
	*/
	comprobarBoton:
		push {lr}
		mov r6, r0
		bl GetGpioAddress
		mov r4, r0
		ldr r5, [r4, #0x34]
		mov r0,#1
		lsl r0,#14
		and r5,r0
		teq r5, 
		/*AQui hace falta ver puerto*/
		bne error
		pop {pc}
		
	error:
	/*Que todos los leds parpadeen y se regresa a inicio*/
		
		
	
	
	
