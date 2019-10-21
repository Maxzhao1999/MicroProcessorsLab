#include p18f87k22.inc
;	extern	LCD_delay_ms
	code
	org 0x0
	
acs0	udata_acs 
b03	    res	1
b47	    res	1
num	    res 1
rst	code	0    ; reset vector
	goto	start
	
;	org 0x100		    ; Main code starts here at address 0x100

start	setf	LATE
	banksel	PADCFG1
	bsf	PADCFG1, REPU, BANKED
	movlb	0x00
	clrf	LATE
;	clrf	LATC
;	clrf	LATH

read_row		;4-7
	movlw	b'11110000'
	movwf	TRISE
	call	delay
	call	delay
	movff	PORTE,	b47
;	setf	TRISC
;	movff	b47,	PORTC
;	clrf	TRISC
	return
	
read_col		;0-3
	movlw	b'00001111'
	movwf	TRISE
	call	delay
	call	delay
	movff	PORTE,	b03
	setf	TRISH
;	movff	b03,	PORTH
;	clrf	TRISH
;	call	delay
;	goto	start
	return

read
	call	read_row
	call	read_col
	movff	b47, W
	iorwf	b03, W
	negf	W
	decf	W
	return

decode
;	btfss	W,0
;	bra	col1
;	btfss	W,1
;	bra	col2
;	btfss	W,2
;	bra	col3
;	btfss	W,3
;	bra	col4
;	
;col1	
;	btfss	W,4
;	;it's 1
;	btfss	W,5
;	;it's 4
	
	
delay	decfsz	0xFF
	bra delay
	return
	
	end