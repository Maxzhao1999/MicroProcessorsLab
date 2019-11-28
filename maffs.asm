#include p18f87k22.inc

	global convert_to_decimal, dec_0, dec_2, cpr1h, cpr1l, cpr2h, cpr2l, f_count, thresh, thresl, percent, copy1, copy2
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
copy1	 res 1   
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
	; this subroutine converts a hex number to decimal numbers by multiplying 0x042D, storing the first digit
	; then multiply the result with 0x0A three times, each time save the first digit, displaying those numbers in order
	; the result is the corrospoding decimal number, this method is only valid from 0000 to 9999.
	movlw	0x3? 
	movwf	count		
	lfsr	FSR0, dec_3	
	movff	copy2, gh
	movff	copy1, ab
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

	
percent	;eliminiting the 5% systematic error due to the microprocessor
	; this subroutine takes the value of frequency measured , then substract 5% from the original value
	; the value is first divided by 64(decimal) via the roll right operation
	; then the new value is multiplied by 0x03 and stroed to copy3 
	; in the end , the original value substract the value in copy3 and stored in copy2 and cpoy1, copy2 represents the higer digit of the frequency
	movf	fcounterh, W
	movwf	backuph	    
	movwf	copy2	    ; store the higher two digits of the frequency to backuph and copy2
	movf	fcounterl, W	
	movwf	backupl
	movwf	copy1	    ; store the lower two digits of the frequency to backupl and copy1
	movlw	0x6
	movwf	divcount	    
divi			    ; operate division by 2 six times, divison by 64 in total
	decf	divcount
	addwfc	blah
	rrcf	backuph,1,ACCESS
	rrcf	backupl,1,ACCESS
	tstfsz	divcount
	bra	divi
multi			    ; multiplication by 0x03, and substract the calculated value from the original value
	movlw	0x03
	mulwf	backupl
	movff	PRODL, backupl
	movff	PRODH, copy3	; lower digits multiplication, with carry
	movlw	0x03
	mulwf	backuph
	movff	PRODL, backuph
	movf	copy3, W
	addwf	backuph
	movf	backupl, W		 ; higher digits multiplication, add carry to the higher digits
	subwf	copy1
	bc	noborrow		; substract backupl from cpoy1, branch is no borrow
	movlw	0xFF
	subfwb	copy1
	movf	backuph, W
	subwfb	copy2		; if borrow, substract copy1 from 0xFF, then substract backuph and borrow from copy2
	return
noborrow				; if no borrow, substract backuph from copy2
	movf	backuph, W
	subwf	copy2
	return

	
end