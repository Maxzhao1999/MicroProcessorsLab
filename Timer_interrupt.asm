#include p18f87k22.inc
	
	global	Timer_Setup, loopsh, loopsl,fcounter	
	extern  calc, frequencyl, frequencyh
acs0    udata_acs   ; named variables in access ram
loopsl	res 1   ; reserve 1 byte for variable LCD_cnt_l
loopsh	res 1
fcounter    res 1
	
int_hi	code	0x0008	; high vector, no low vector
	btfsc	INTCON,TMR0IF ; check that this is timer0 interrupt
	bra	timer
	movf	fcounter, W, ACCESS
	addlw	0x01
	movwf	fcounter, ACCESS
	retfie	FAST		; fast return from interrupt
timer
	call	calc
	clrf	fcounter
	clrf	frequencyl
	clrf	frequencyh
	retfie	FAST
	

DAC	code
Timer_Setup
	clrf	TRISD		; Set PORTD as all outputs
	clrf	LATD		; Clear PORTD outputs
	movlw	b'10000110'	; Set timer0 to 16-bit, Fosc/4/256
	movwf	T0CON		; = 62.5KHz clock rate, approx 1sec rollover
	bsf	INTCON,TMR0IE	; Enable timer0 interrupt
	bsf	INTCON,GIE	; Enable all interrupts
	return
	
CM_Setup
	movlw	b'10001100'
	movwf	CM1CON
	end