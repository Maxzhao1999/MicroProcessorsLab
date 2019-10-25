#include p18f87k22.inc

	global convert_to_decimal

acs0    udata_acs   ; named variables in access ram
ab	res 1   ; reserve 1 byte for variable LCD_cnt_l
cd	res 1   ; reserve 1 byte for variable LCD_cnt_h
ef	res 1   ; reserve 1 byte for ms counter
gh	res 1
ij	res 1
re0_0	res 1   ; reserve 1 byte for counting through nessage
re0_1	res 1
re0_2	res 1
re1_0	res 1
re1_1	res 1
re1_2	res 1
re1_3	res 1
dec_0	res 1
dec_1	res 1
dec_2	res 1
dec_3	res 1
	
acs_ovr	access_ovr
count res 1   ; reserve 1 byte for variable LCD_hex_tmp	


maffs	code

convert_to_decimal
	movlw	0x3
	movwf	count
	lfsr	FSR0, dec_0
	movff	ADRESH, gh
	movff	ADRESL, ab
	movlw	0x41
	movwf	cd
	movlw	0x8A
	movwf	ef
	call	m_16_16
loop	movff	re1_3, POSTDEC0
	movlw	0x0A
	movwf	ab
	movff	re1_0, ef
	movff	re1_1, cd
	movff	re1_2, ij
	call	m_8_24
	decfsz	count
	bra	loop
	return
	
m_8_16		;ab*cdef
	movff	ab, W
	mulwf	ef, ACCESS
	movff	PRODH, re0_1
	movff	PRODL, re0_0
	mulwf	cd, ACCESS
	movff	PRODH, re0_2
	movff	PRODL, W
	addwf	re0_1
	movlw	0x0
	addwfc	re0_2
	return

m_16_16		;ghab*cdef
	call	m_8_16
	movff	re0_0, re1_0
	movff	re0_1, re1_1
	movff	re0_2, re1_2
	movff	gh,ab
	call	m_8_16
	movff	re0_0, W
	addwf	re1_1, W
	movlw	0x0
	addwfc	re1_2
	movff	re0_1, W
	addwf	re1_2, W
	movlw	0x0
	movff	re0_2, re1_3
	addwfc	re1_3
	return
	
m_8_24		;ab*ijcdef
	call	m_8_16
	movff	re0_0, re1_0
	movff	re0_1, re1_1
	movff	re0_2, re1_2
	movff	ab, W
	mulwf	ij
	movff	PRODL, W
	addwf	re1_2
	movff	PRODH, re1_3
	movlw	0x0
	addwfc	re1_3
	return

end