	#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100

start
	movlw	0x0
	movwf	TRISD		    ;set port D as output
	movlw	0xFF
	movwf	TRISH	    ;set port F as input
	movwf	TRISC
	setf	TRISE		    ;tri-state port E
	banksel	PADCFG1		    ;define BSR PADCFG1
	bsf	PADCFG1, REPU, BANKED	;port E pull-up enabled
	movlb	0x00		    ;move 0x00 to BSR
	movlw	0xFF
	movwf   PORTD, ACCESS	    ;set OE1 OE2 to high, CP1 CP2 to low
	movwf	PORTE, ACCESS       ;ensure all port E high
	movlw	0xFF
	movwf	0x01, ACCESS
	movwf	PORTC, ACCESS
	call	controlwrite
	call	controlread
	movff	0x02, PORTH
	clrf	TRISC
	clrf	TRISH
	
	goto	0x0

	
controlwrite
	movlw	0x0
	movwf	TRISE		    ;set port E as output
	movlw	0xFA
	movwf	PORTD, ACCESS	    ;set cp1 to low
	movff	0x01, PORTE
	call	delay
	movlw	0xFF
	movwf	PORTD, ACCESS
	setf	TRISE
	return
	
controlread
	movlw	0xFF
	movwf	TRISE		    ;set port E to input
	movlw	0xF5
	movwf	PORTD, ACCESS	    ;set OE1 to low
	call	delay
	movff	PORTE, 0x02
	movlw	0xFF
	movwf	PORTD, ACCESS
	setf	TRISE
	return
	



	
	
delay	
	movlw	0x01
	movwf	0x09, ACCESS
dloop	
	decfsz	0x09, f, ACCESS
	bra	dloop
	return
	
	
	
	
	


end