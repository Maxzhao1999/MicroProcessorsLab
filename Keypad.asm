#include p18f87k22.inc
;	extern	LCD_delay_ms
	code
	org 0x0
	
acs0	udata_acs 
b03	    res	1
b47	    res	1
rst	code	0    ; reset vector
	goto	start
	
;	org 0x100		    ; Main code starts here at address 0x100

start	setf	LATE
	banksel	PADCFG1
	bsf	PADCFG1, REPU, BANKED
	movlb	0x00
	clrf	LATE
	clrf	LATC
	clrf	LATH

read_03
	movlw	b'11110000'
	movwf	TRISE
	call	delay
	call	delay
	movff	PORTE,	b03
	setf	TRISC
	movff	b03,	PORTC
	clrf	TRISC

read_47
	movlw	b'00001111'
	movwf	TRISE
	call	delay
	call	delay
	movff	PORTE,	b47
	setf	TRISH
	movff	b47,	PORTH
	clrf	TRISH
	call	delay
	goto	start

delay	decfsz	0xFF
	bra delay
	return
	
	end