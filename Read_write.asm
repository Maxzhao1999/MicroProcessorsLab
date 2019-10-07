
	code
	org 0x0
	goto	start

	org 0x100		    ; Main code starts here at address 0x100

start
	movlw	0x10		    ; Set epoch
	movwf	0x06, Access	    ; Store in data memory
	lfsr	FSR0, 0x020
	movlw	0x0
	call	write
	end

write
	movwf	POSTINC0, f
	addlw	0x1
	decfsz	0x06, Access
	bra write
	return
	
;read
	