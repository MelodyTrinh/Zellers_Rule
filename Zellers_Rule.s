	.syntax	unified
	.cpu		cortex-m4
	.text

/*Zeller1*/
	.global	Zeller1
	.thumb_func
	.align

//R0= k, R1= m, R2= D, R3= C

Zeller1:
	LDR		R12, =13
	MUL		R1, R1, R12			//R1= 13*m
	SUB		R1, R1, 1			//R1= (13*m)-1
	LDR		R12, =5
	UDIV	R1, R1, R12			//R1=((13*m)-1)/5
	ADD		R1, R1, R2			//R1=(((13*m)-1)/5)+D
	ADD		R0, R0, R1			//R0=(((13*m)-1)/5)+D+K 
	ADD		R0, R0, R2, ASR 2	//R0=(((13*m)-1)/5)+D+K+D/4
	ADD		R0, R0, R3, ASR 2	//R0=(((13*m)-1)/5)+D+K+(D/4)+(C/4)
	SUB		R0, R0, R3, LSL 1	//R0=(((13*m)-1)/5)+D+K+(D/4)+(C/4)-(2*C) = dividend
	LDR		R12, =7		
	SDIV	R1, R0, R12			//R1= R0/7 = quotient 
	MLS		R0, R12, R1, R0		//R0= dividend - (quotient*7)
	CMP		R0, 0
	IT		LT 	
	ADDLT	R0, R0, 7			//If R0 is negative, add 7
	BX		LR

/*Zeller2*/
	.global	Zeller2
	.thumb_func
	.align

//R0= k, R1= m, R2= D, R3= C

Zeller2:
	LSL		R12, R1, 3
	ADD		R12, R12, R1, LSL 2
	ADD		R1, R12, R1			//R1= 13*m
	SUB		R1, R1, 1			//R1= (13*m)-1
	LDR		R12, =5
	UDIV	R1, R1, R12			//R1=((13*m)-1)/5
	ADD		R1, R1, R2			//R1=(((13*m)-1)/5)+D
	ADD		R0, R0, R1			//R0=(((13*m)-1)/5)+D+K 
	ADD		R0, R0, R2, ASR 2	//R0=(((13*m)-1)/5)+D+K+D/4
	ADD		R0, R0, R3, ASR 2	//R0=(((13*m)-1)/5)+D+K+(D/4)+(C/4)
	SUB		R0, R0, R3, LSL 1	//R0=(((13*m)-1)/5)+D+K+(D/4)+(C/4)-(2*C) = dividend
	LDR		R12, =7
	SDIV	R1, R0, R12			//R1= R0/7 = quotient 
	RSB		R1, R1, R1, LSL 3	//R1= quotient*7
	SUB		R0, R0, R1			//R0= dividend - (quotient*7)
	CMP		R0, 0
	IT		LT 	
	ADDLT	R0, R0, 7			//If R0 is negative, add 7
	BX		LR
	
/*Zeller3*/
	.global	Zeller3
	.thumb_func
	.align

//R0= k, R1= m, R2= D, R3= C

Zeller3:
	
	LSL		R12, R1, 3
	ADD		R12, R12, R1, LSL 2
	ADD		R1, R12, R1			//R1= 13*m
	SUB		R1, R1, 1			//R1= (13*m)-1
	ADD		R2, R2, R2, ASR 2	//R2= D+(D/4)
	ADD		R2, R2, R3, ASR 2	//R2= D+(D/4)+(C/4)
	ADD		R2, R2, R0			//R2= D+(D/4)+(C/4)+K
	SUB		R2, R2, R3, LSL 1	//R2= D+(D/4)+(C/4)+K-((2*C)
	LDR		R12, =3435973837	//R1=((13*m)-1)/5
	UMULL	R0, R12, R12, R1
	LSR		R1, R12, 2
	ADD		R0, R1, R2			//R0= R1+R2 = (((13*m)-1)/5)+D+K+(D/4)+(C/4)-(2*C) = dividend
	LDR		R12, =2454267027	//R1= R0/7 = quotient
	SMMLA	R12, R12, R0, R0
	LSR		R3, R0, 31
	ADD		R1, R3, R12, ASR 2
	RSB		R1, R1, R1, LSL 3	//R1= quotient*7
	SUB		R0, R0, R1			//R0= dividend - (quotient*7)
	CMP		R0, 0
	IT		LT 					
	ADDLT	R0, R0, 7			//If R0 is negative, add 7
	BX		LR


	.end

