#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100


start
	bcf	TRISD, ACCESS
ZZJ	call	SPI_MasterInit
	call	delay,FAST
	movlw	0xAA
	call	SPI_MasterTransmit
	movlw	0x55
	call	delay,FAST
	call	SPI_MasterTransmit
	bra	ZZJ
	

	goto	0x0
	
	
	
	
	
	
	
SPI_MasterInit ; Set Clock edge to negative
    bcf SSP2STAT, CKE
    ; MSSP enable; CKP=1; SPI master, clock=Fosc/64 (1MHz)
    movlw (1<<SSPEN)|(1<<CKP)|(0x02)
    movwf SSP2CON1
    ; SDO2 output; SCK2 output
    bcf TRISD, SDO2
    bcf TRISD, SCK2
    return

SPI_MasterTransmit ; Start transmission of data (held in W)
    movwf SSP2BUF
    call    delay
Wait_Transmit ; Wait for transmission to complete
    btfss PIR2, SSP2IF
    bra Wait_Transmit
    bcf PIR2, SSP2IF ; clear interrupt flag
    return

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
    

	end    



