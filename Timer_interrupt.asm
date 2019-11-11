#include p18f87k22.inc
	
	global	Timer_Setup, loopsh, loopsl,fcounterl, fcounterh, CM_Setup	
	extern  calc
acs0    udata_acs   ; named variables in access ram
loopsl	res 1   ; reserve 1 byte for variable LCD_cnt_l
loopsh	res 1   ; reserve 1 byte for variable LCD_cnt_h
fcounterh    res 1  ; reserve 1 byte for counter high byte
fcounterl    res 1   ; reserve 1 byte for counter low byte
fcounter2    res 1  ; reserve 1 byte for counter 2
fcounter1    res 1  ; reserve 1 byte for variable LCD_cnt_l
    
	code
int_hi	code	0x0008	; high vector, no low vector
	btfsc	INTCON,TMR0IF ; check that this is timer0 interrupt
	bra	timer	      ; move to timer branch
	movlw	0x01	      ; put value 0x01 to  w register
	addwf	fcounter1, 1, ACCESS	; add 0x01 to fcounterl and stored back to fcounterl
	bc	carry		; branch to carry
	bcf	PIR6, CMP1IF	; reset comparator1 interrupt
	retfie	FAST		; fast return from interrupt
timer
	movf	fcounter1, W	; move founter1 to W register
	movwf	fcounterl		; store W register value to fcounterl
	movf	fcounter2, W	; move founter2 to W register
	movwf	fcounterh		; store W register value to fcounterh
	clrf	fcounter1		; reset fcounter1 value
	clrf	fcounter2		; reset fcounter2 value
	bcf	INTCON, TMR0IF	; timer0 did not overflow
	retfie	FAST
carry
	movlw	0x0		; move 0x0 to W register
	addwfc	fcounter2, 1	; add 0 to fcounter 2, stored back to fcounter 2
	clrf	fcounter1		; clear fcounter1 byte
	bcf	PIR6, CMP1IF	; reset comparator1 interrupt  
	retfie	FAST
	

DAC	
Timer_Setup
	clrf	TRISD		; Set PORTD as all outputs
	clrf	LATD		; Clear PORTD outputs
	movlw	b'10000111'	; Set timer0 to 16-bit, Fosc/4/256
	movwf	T0CON		; = 62.5KHz clock rate, approx 1sec rollover
	bsf	INTCON,TMR0IE	; Enable timer0 interrupt
	bsf	INTCON,GIE	; Enable all interrupts
	return
	
CM_Setup
	movlb	0xF		; call bank 15
	movlw	b'11001000'	; enable comparator1, interrupts are generate when low-to-high transition happens
	movwf	CM1CON, BANKED	; setup comparator1
	bcf	TRISF, 2		; set port f bit 2 to output
	movlb	0x0		; reset bank adress
	bsf	INTCON,PEIE	; enable peripheral interrupt
	bsf	PIE6, CMP1IE	; enable peripheral intterupt
	bcf	PIR6, CMP1IF	; reset comparator1 interrupt
	bsf	INTCON,GIE	; Enable all interrupts
	return
	end