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
	
	/*Contadores respectivos, para los displays y para un delay entre cada secuencia*/
	mov r10, #0
	mov r11,#1
	mov r3, #0
	inicioSerie:
	
		bl nuevoNivel
		bl displayTurn1
		add r11, r11, #1
		cmp r11, #10			/* Si el contador del segmento 1, llega a 10 quiere decir que hay que sumarle un 1 al segmento 2*/
		moveq r11, #0
		bleq contadorSegment2
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
		
		/*Delay entre cada repeticion de la serie, esto es para no perder la aleatoriedad*/
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
		
	/*
	* Entrada: r0 = valor aleatorio generado por la subrutina random.
	* Segun la entrada en r0, se crea un salto para poder hacer parpadear un LED.
	*/
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
		
	/*
	* Hace parpadear un LED, además guarda en el arreglo un numero segun el LED (1-4), en una posicion vacia, esto para despues comprobar que se presiono el boton adecuado.*/
	* Esto aplica para las subrutinas led1, led2, led3 y led4
	*/
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
	/*
	*ingresa un valor especifico de frecuencia para cada sonido y su duracion especifica 
	*/
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
	/*
	*ciclo que guarda los valores generados al azar para una lista de la secuencia
	*/
	storeListL:
		push {lr}
		mov r5, r4
		ldr r0, = patronL
		str r6, [r0], r5
		pop {pc}
	
	/*
	*ciclo que guarda en el arreglo especifico el valor correspondiente a cada boton
	*/
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
	/*
	*genera random de 0-3
	*/
	random:
		push {lr}
		bl GetTimeStamp
		and r0, #3		
		pop {pc}
	/*
	*recibe el boton presionado y lo guarda en su arreglo especifico
	*/
	
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
	/*
	*despliega la secuencia de leds para indicar el cambio de nivel
	*/
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
		
		mov r11, #0
		mov r3, #0
		b inicioSerie
	/*
	*despliega la secuencia de leds para indicar el cambio de nivel
	*/
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
	/*
	*Entrada: r3 contador de turno
 	*compara contadores para evaluar  en que nivel se encuentra el juego
	*/
	displayTurn1:
		push {lr}
		cmp r11,#1
		bleq numero1
		cmp r11,#2
		beq numero2
		cmp r11,#3
		beq numero3
		cmp r11,#4
		beq numero4
		cmp r11,#5
		beq numero5
		cmp r11,#6
		beq numero6
		cmp r11,#7
		beq numero7
		cmp r11,#8
		beq numero8
		cmp r11, #9
		beq numero9
		pop {pc}
		
	displayTurn2:
		push {lr}
		cmp r3,#1
		bleq numero11
		cmp r3,#2
		beq numero22
		cmp r3,#3
		beq numero33
		cmp r3,#4
		beq numero44
		cmp r3,#5
		beq numero55
		cmp r3,#6
		beq numero66
		cmp r3,#7
		beq numero77
		cmp r3,#8
		beq numero88
		cmp r3, #9
		beq numero99
		pop {pc}
	/*
	*combinacio de salidas especificas para desplegar los numeros del nivel correspondiente al nivel
	*/
	numero1:
		push {lr}
		TurnLed #2, #1
		TurnLed #3, #0
		TurnLed #4, #0
		TurnLed #17, #0
		pop {pc}
	numero11:
		push {lr}
		TurnLed #27, #1
		TurnLed #22, #0
		TurnLed #10, #0
		TurnLed #9, #0
		pop {pc}
	numero2:
		push {lr}
		TurnLed #2, #0
		TurnLed #3, #1
		TurnLed #4, #0
		TurnLed #17, #0
		pop {pc}
	numero22:
		push {lr}
		TurnLed #27, #0
		TurnLed #22, #1
		TurnLed #10, #0
		TurnLed #9, #0
		pop {pc}
	numero3: 
		push {lr}
		TurnLed #2, #1
		TurnLed #3, #1
		TurnLed #4, #0
		TurnLed #17, #0
		pop {pc}
	numero33: 
		push {lr}
		TurnLed #27, #1
		TurnLed #22, #1
		TurnLed #10, #0
		TurnLed #9, #0
		pop {pc}
	numero4:
		push {lr}
		TurnLed #2, #0
		TurnLed #3, #0
		TurnLed #4, #1
		TurnLed #17, #0
		pop {pc}
	numero44:
		push {lr}
		TurnLed #27, #0
		TurnLed #22, #0
		TurnLed #10, #1
		TurnLed #9, #0
		pop {pc}
	numero5:
		push {lr}
		TurnLed #2, #1
		TurnLed #3, #0
		TurnLed #4, #1
		TurnLed #17, #0
		pop {pc}
	numero55:
		push {lr}
		TurnLed #27, #1
		TurnLed #22, #0
		TurnLed #10, #1
		TurnLed #9, #0
		pop {pc}
	numero6:
		push {lr}
		TurnLed #2, #0
		TurnLed #3, #1
		TurnLed #4, #1
		TurnLed #17, #0
		pop {pc}
	numero66:
		push {lr}
		TurnLed #27, #0
		TurnLed #22, #1
		TurnLed #10, #1
		TurnLed #9, #0
		pop {pc}
	numero7:
		push {lr}
		TurnLed #2, #1
		TurnLed #3, #1
		TurnLed #4, #1
		TurnLed #17, #0
		pop {pc}
	numero77:
		push {lr}
		TurnLed #27, #1
		TurnLed #22, #1
		TurnLed #10, #1
		TurnLed #9, #0
		pop {pc}
	numero8:
		push {lr}
		TurnLed #2, #0
		TurnLed #3, #0
		TurnLed #4, #0
		TurnLed #17, #1
		pop {pc}
	numero88:
		push {lr}
		TurnLed #27, #0
		TurnLed #22, #0
		TurnLed #10, #0
		TurnLed #9, #1
		pop {pc}
	numero9:
		push {lr}
		TurnLed #2, #1
		TurnLed #3, #0
		TurnLed #4, #0
		TurnLed #17, #1
		pop {pc}
	numero99:
		push {lr}
		TurnLed #27, #1
		TurnLed #22, #0
		TurnLed #10, #0
		TurnLed #9, #1
		pop {pc}
	/*
 	*Entrada: r3 cuenta 
	*Salida: r3 valor
 	*crea un espacio para llevar la cuenta del display2 
 	*/
	contadorSegment2:
		push {lr}
		ldr r0, =segmento2
		ldr r1, [r0]
		add r1, r1, #1
		cmp r1, #10
		moveq r1, #0
		str r1, [r0]
		mov r3, r1
		pop {pc}
		
.section .data
.align 2

patronL:
	.word 0,0,0,0,0
	
patronB:
	.word 0,0,0,0,0

segmento2:
	.word 0
