	#include p18f87k22.inc
	code
	org 0x0
	goto	start

	org 0x100		    ; Main code starts here at address 0x100

start
	movlw	0x10		    ; Set epoch
	movwf	0x06, ACCESS	    ; Store in data memory
	movwf	0x07, ACCESS
	movwf	0x08, ACCESS
	lfsr	FSR0, 0x020
	movlw	0x0
	call	write
	movlw	0x10
	lfsr	FSR1, 0x040
	call	read
	movlw	0x0
	movwf	TRISE, ACCESS
	call compare
	goto 0x0

write
	movwf	POSTINC0
	addlw	0x1
	decfsz	0x06, ACCESS
	bra write
	return
	
read
	movff	POSTDEC0, W
	movwf	POSTINC1
	decfsz	0x07, ACCESS
	bra	read
	return
	
compare
	movff	POSTDEC0, W
	subwf	POSTINC1, 0
	movwf	PORTE
	decfsz	0x08, ACCESS
	bra	compare
	return
	
endProgram
	end
;read
	