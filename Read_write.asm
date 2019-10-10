	#include p18f87k22.inc
	code
	org 0x0
	goto	start

	org 0x100		    ; Main code starts here at address 0x100

start
	movlw	0x20		    ; Set epoch
	movwf	0x06, ACCESS	    ; Store in data memory in the adress 0x06	
	movwf	0x07, ACCESS        ; Store in data memory in the adress 0x07
	movwf	0x08, ACCESS        ; Store in data memory in the adress 0x08
	lfsr	FSR0, 0x020         ;load adress 0x020 into FSR0
	movlw	0x0                 ;set w register to be zero
	movwf	TRISD, ACCESS
	movwf	TRISE, ACCESS	    ;move w to port E
	call	write              
;	movlw	0x10                ;set w register to be 0x10
	lfsr	FSR1, 0xF10	    ; load address 0x040 into FSR1
	call	read                
	movlw	0x0		    ; set w to 0
	
;	call compare
	goto 0x0

write
	movwf	PREINC0		    ;move value of W to the address in FSR0 with address plus 1
	call	delay, FAST
	addlw	0x1                 ; w register plus 1
	movwf	PORTD
	decfsz	0x06, f, ACCESS	    ; value at 0x06 - 1, store back to 0x06, skip if value is zero
	bra	write		    ; loop back    
	return                      ; jumps to line 16 if finishes
	
read
	movff	POSTDEC0, WREG         ; move values in SFR0 to w, with position decreament 1
	call	delay, FAST
	movwf	PORTE
	movwf	POSTINC1            ; move values from w to SFR1 with position increament 1
	decfsz	0x07, f,  ACCESS    ; value in 0x07 -1, store back to f, skip if value is zero
	bra	read                ; loop back
	return                      ; return to line 19 if finishes

delay
	movlw	0xFF
	movwf	0x09, ACCESS
dloop	call	delayx
	decfsz	0x09, f, ACCESS
	bra	dloop
	return	FAST
	
delayx
	movlw	0xFF
	movwf	0x10, ACCESS
dloopx	call	delayy
	decfsz	0x10, f, ACCESS
	bra	dloopx
	return
	
delayy
	movlw	0xF
	movwf	0x11, ACCESS
dloopy
	decfsz	0x11, f, ACCESS
	bra	dloopy
	return
	
	
;compare
;	movff	POSTDEC0, W        ; move values in SFR0 to w
;	subwf	POSTDEC1, 0        ; substract w from values in SFR1
;	movwf	PORTE              ; move w to port E
;	decfsz	0x08, ACCESS       ; values at 0x08 - 1, skip if 0
;	bra	compare
;	return
	
endProgram
	end
;read
	