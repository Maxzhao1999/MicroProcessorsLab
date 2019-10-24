#include p18f87k22.inc

	global

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

m_8_16
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

m_16_16	
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
	addwfc	re1_3
	movff	re0_2, re1_3
	return
	
m_8_24





