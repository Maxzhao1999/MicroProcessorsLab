	#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100

start
	movlw	0x0
	movwf	TRISD
	setf	TRISE
	banksel	PADCFG1
	bsf	PADCFG1, REPU, BANKED
	movlb	0x00
	
	
	end


