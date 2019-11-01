#include p18f87k22.inc

	global convert_to_decimal, dec_0, dec_2, cpr1h, cpr1l, cpr2h, cpr2l, f_count, thresh, thresl

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
cpr1h	res 1
cpr1l	res 1
cpr2h	res 1
cpr2l	res 1
f_count	res 1
thresh	res 1
thresl	res 1
acs_ovr	access_ovr
count res 1   ; reserve 1 byte for variable LCD_hex_tmp	


maffs	code

convert_to_decimal
	movlw	0x3
	movwf	count
	lfsr	FSR0, dec_3
	movff	ADRESH, gh
	movff	ADRESL, ab
;	movlw	0x04
;	movwf	gh
;	movlw	0xD2
;	movwf	ab
	movlw	0x41
	movwf	cd
	movlw	0x8A
	movwf	ef
	call	m_16_16	
loop	movff	re1_3, POSTDEC0
	clrf	re1_3
	movlw	0x0A
	movwf	ab
	movff	re1_0, ef
	movff	re1_1, cd
	movff	re1_2, ij
	call	m_8_24
	decfsz	count
	bra	loop
	movff	re1_3, POSTDEC0
	swapf	dec_3, W
	iorwf	dec_2, F
	swapf	dec_1, W
	iorwf	dec_0, F
	return
	
m_8_16		;ab*cdef
	movf	ab, W
	mulwf	ef, ACCESS
	movff	PRODH, re0_1
	movff	PRODL, re0_0
	mulwf	cd, ACCESS
	movff	PRODH, re0_2
	movf	PRODL, W
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
	movf	re0_0, W
	addwf	re1_1
	movlw	0x0
	addwfc	re1_2
	movf	re0_1, W
	addwf	re1_2
	movlw	0x0
	movff	re0_2, re1_3
	addwfc	re1_3
	return
	
m_8_24		;ab*ijcdef
	call	m_8_16
	movff	re0_0, re1_0
	movff	re0_1, re1_1
	movff	re0_2, re1_2
	movf	ab, W
	mulwf	ij
	movf	PRODL, W
	addwf	re1_2
	movff	PRODH, re1_3
	movlw	0x0
	addwfc	re1_3
	return



fcounter
	incf	f_count
waittillow
	movf	thresh, W
	movff	ADRESH, cpr2h
	movff	ADRESL, cpr2l
	cpfseq	cpr2h
	bra	comp1
	movf	thresl, W
	cpfsgt	cpr2l
	bra	compare
	bra	waittillow

compare
	movff	ADRESH, cpr2h
	movff	ADRESL, cpr2l
	movf	thresh, W
	cpfseq	cpr2h
	bra	comp2
	movf	thresl, W
	cpfsgt	cpr2l
	bra	compare
	bra	fcounter
comp2
	movf	thresh, W
	cpfsgt	cpr2h
	bra	compare
	bra	fcounter
	
comp1
	movf	thresh, W
	cpfsgt	cpr2h
	bra	compare
	bra	waittillow

end