#include p18f87k22.inc

	global convert_to_decimal, dec_0, dec_2, cpr1h, cpr1l, cpr2h, cpr2l, f_count, thresh, thresl, percent
	extern ADC_Read,fcounterl, fcounterh
acs0    udata_acs   ; named variables in access ram
ab	res 1   ; reserve 1 byte for variable LCD_cnt_l
cd	res 1   ; reserve 1 byte for variable LCD_cnt_h
ef	res 1   
gh	res 1
ij	res 1
re0_0	res 1  
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
bytef	res 1
divcount res 1
mulcount res 1
copy3	 res 1
copy2	 res 1
carry3	 res 1
carry2   res 1
blah   res 1      
backuph  res 1
backupl  res 1
acs_ovr	access_ovr
count res 1   ; reserve 1 byte for variable LCD_hex_tmp	


maffs	code

convert_to_decimal		; hex to decimal conversion 
	movlw	0x3
	movwf	count		
	lfsr	FSR0, dec_3	
	movff	fcounterh, gh
	movff	fcounterl, ab
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
	
m_8_16		;ab*cdef , 8 bit X 16 bit multiplication
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

m_16_16		;ghab*cdef, 16 bit X 16 bit multiplication
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
	
m_8_24		;ab*ijcdef, 8 X 24 multiplication
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

	
percent
	movf	fcounterh, W
	movwf	backuph
	movf	fcounterl, W
	movwf	backupl
	movlw	0x6
	movwf	divcount
divi
	decf	divcount
;	clrf	bytef
	addwfc	blah
	rrcf	backuph,1,ACCESS
	rrcf	backupl,1,ACCESS
;	rrcf	bytef
	tstfsz	divcount
	bra	divi
multi
;	movf	bytef, W
;	movwf	copy3
;	addwf	bytef
	clrf	W
;	clrf	carry3,0	;clear carry3 before storing new values to it
;	addwfc	carry3
;	movf	copy3, W
;	addwf	bytef
;	clrf	W
;	addwfc	carry3	;above calculates the last layer
;	movf	backupl, W
;	movwf	copy2
;	addwf	backupl
;	clrf	W
;	addwfc	carry2
;	movf	copy2, W
;	addwf	backupl
;	clrf	W
;	addwfc	carry2  ; above calculates the second last
;	movf	backuph, W
;	addwf	backuph, 0
;	addwf	backuph, 1 ; above calculates first layer
;	movf	carry3, W
;	addwf	backupl
;	clrf	W
;	addwfc	backuph  ; add carry to second layer, carry to 1st layer
;	movf	carry2, W
;	addwf	backuph  ; add carry to first layer
;	movf	backupl, W
;	subwf	fcounterl
;	bc	noborrow
;	movf	backuph, W
;	subwfb	fcounterh
	movlw	0x03
	mulwf	backupl
	movff	PRODL, backupl
	movff	PRODH, copy3
	movlw	0x03
	mulwf	backuph
	movff	PRODL, backuph
	movf	copy3, W
	addwf	backuph
	movf	backupl, W
	subwf	fcounterl
	bc	noborrow
	movf	backuph, W
	subwfb	fcounterh	
	
	return
noborrow
	movf	backuph, W
	subwf	fcounterh
	
	return
;fcounter
;	incf	f_count
;waittillow
;	movf	thresh, W
;	call	ADC_Read
;	movff	ADRESH, cpr2h
;	movff	ADRESL, cpr2l
;	cpfseq	cpr2h
;	goto	comp1
;	movf	thresl, W
;	cpfsgt	cpr2l
;	return
;	goto	waittillow
;
;compare
;	call	ADC_Read
;	movff	ADRESH, cpr2h
;	movff	ADRESL, cpr2l
;	movf	thresh, W
;	cpfseq	cpr2h
;	goto	comp2
;	movf	thresl, W
;	cpfsgt	cpr2l
;	goto	compare
;	goto	fcounter
;comp2
;	movf	thresh, W
;	cpfsgt	cpr2h
;	goto	compare
;	goto	fcounter
;	
;comp1
;	movf	thresh, W
;	cpfsgt	cpr2h
;	goto	compare
;	goto	waittillow

	
end