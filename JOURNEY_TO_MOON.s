
	 AREA     factorial, CODE, READONLY
     IMPORT printMsg
	 IMPORT printComma
	 IMPORT printNextl
     IMPORT printMessage	 
	 EXPORT __main
	 EXPORT __COSINE
	 EXPORT __SINE
	 EXPORT __DRAWCIRC
	 EXPORT __DRAWCIRC2
		ENTRY 
;---------------------------------------------------------------------------------------------------------------------------------------------------

__SINE FUNCTION			;(INPUT S9=X | OUTPUT S5=SIN(X))
     				

        VLDR.F32 S1,=90.0

        VMOV.F32 S0,S9

        VCMP.F32 S9,S1

		VMRS APSR_nzcv, FPSCR

		BLT START

        VLDR.F32 S1,=180.0		

		VSUB.F32 S0,S1,S9

        VLDR.F32 S1,=270.0

		VCMP.F32 S9,S1

		VMRS APSR_nzcv, FPSCR

        BLT START

		VLDR.F32 S1,=360.0

        VSUB.F32 S0,S9,S1

											


START   VLDR.F32 S7,=3.14

		VLDR.F32 S8,=180.0

		VLDR.F32 S6,=1.0

		MOV R1,#20         					;NUMBER OF TERMS

		

		VMUL.F32 S1,S0,S7

		VDIV.F32 S1,S1,S8					;x=PI*(theta)/180

		VMUL.F32 S2,S1,S1					;x^2

		VNEG.F32 S2,S2						;-x^2

		VMOV.F32 S3,S1						;S3 stores the current term in the series

		VLDR.F32 S4,=2.0

		VMOV.F32 S5,S1		                ;SINX=X

		

L1	VMUL.F32 S3,S3,S2					;S3*(-x^2)

		VDIV.F32 S3,S3,S4					;S3/(2n)

		VADD.F32 S4,S4,S6					

		VDIV.F32 S3,S3,S4					;S3/(2n+1)

		VADD.F32 S4,S4,S6
		
		VADD.F32 S5,S5,S3					;S5 stores SIN(X)

		SUB R1,R1,#1						;R1-- 

		CMP R1,#0

		BNE L1							;Branch for next Term

		                                    ;S5 = SIN(X) 
		VMOV.F32 R0,S5

		BX lr

		
	ENDFUNC
;---------------------------------------------------------------------------------------------------------------------------------------------------
__COSINE FUNCTION							;(INPUT S9=X | OUTPUT S5=COS(X))
		
START2	VLDR.F32 S7,=3.141592654

		VLDR.F32 S8,=180.0

		VLDR.F32 S6,=1.0

		MOV R1,#20         					;NUMBER OF TERMS

		

		VMUL.F32 S1,S9,S7

		VDIV.F32 S1,S1,S8					;x=pi*(theta)/180

		VMUL.F32 S2,S1,S1					;x^2

		VNEG.F32 S2,S2						;-x^2
		
		VLDR.F32 S1,=1.0

		VMOV.F32 S3,S1						;S3 stores the current term in the series

		VLDR.F32 S4,=1.0

		VMOV.F32 S5,S1		                ;COSX=1

		

L2	VMUL.F32 S3,S3,S2					;S3*(-x^2)

		VDIV.F32 S3,S3,S4					;S3/(2n-1)

		VADD.F32 S4,S4,S6					

		VDIV.F32 S3,S3,S4					;S3/(2n)

		VADD.F32 S4,S4,S6					

		VADD.F32 S5,S5,S3					;S5 stores cos(X)

		
		SUB R1,R1,#1						;R1-- 

		CMP R1,#0

		BNE L2							;Branch for next Term

		                                    ;S5 = COS(X) 
	
		
		BX lr

		
	ENDFUNC	
;---------------------------------------------------------------------------------------------------------------------------------------------------	
__DRAWCIRC FUNCTION				
		VLDR.F32 S20,=1.0	
		VLDR.F32 S21,=315.0
		VLDR.F32 S28,=360	
		VLDR.F32 S30,=20
		VLDR.F32 S9,=0.0 					;ITERATES FROM 0->359 DEGREES
ANGLE	VMOV.F32 R0,S9
		BL printMsg		
		BL printComma
		BL __SINE							
		VMUL.F32 S5,S5,S22					;S5=RADIUS*SIN (S9)
		VADD.F32 S5,S5,S27					;S5= CENTER_Y(S27) + RADIUS*SIN (S9)
		VMOV.F32 R0,S5
		BL printMsg		
		BL printComma
		BL __COSINE							
		VMUL.F32 S5,S5,S22					;S5=  RADIUS* COS(S9)
		VADD.F32 S5,S5,S26					;S5= CENTER_X(S26) + RADIUS* COS(S9)
		VMOV.F32 R0,S5
		BL printMsg
		BL printNextl
		VADD.F32 S9,S9,S20
		VCMP.F32 S9,S21
		VMRS APSR_nzcv, FPSCR
		IT EQ
		VSUBEQ.F32 S22, S22, S30   ;changing radius
		VCMP.F32 S9,S28            ;Comparing angle with 360
		VMRS APSR_nzcv, FPSCR
		IT EQ
		VLDREQ.F32 S9,=0.0 	
		VCMP.F32 S22,#0
		VMRS APSR_nzcv, FPSCR
		IT EQ
		BEQ stop
		B ANGLE
		BX lr
		
		ENDFUNC
;---------------------------------------------------------------------------------------------------------------------------------------------------
__DRAWCIRC2 FUNCTION							
		VLDR.F32 S20,=1.0	
		VLDR.F32 S21,=315.0
		VLDR.F32 S28,=360	
		VLDR.F32 S30,=20
		VLDR.F32 S9,=0.0 					
ANGLE1	VMOV.F32 R0,S9                      ;ITERATES FROM 0->359 DEGREES
		BL printMsg		
		BL printComma
		BL __SINE							
		VMUL.F32 S5,S5,S22					;S5=RADIUS*SIN (S9)
		VADD.F32 S5,S5,S29					;S5= CENTER_Y2(S29) + RADIUS*SIN (S9)
		VMOV.F32 R0,S5
		BL printMsg		
		BL printComma
		BL __COSINE							
		VMUL.F32 S5,S5,S22					;S5=  RADIUS* COS(S9)
		VADD.F32 S5,S5,S25					;S5= CENTER_X2(S25) + RADIUS* COS(S9)
		VMOV.F32 R0,S5
		BL printMsg
		BL printNextl
		VADD.F32 S9,S9,S20
		VCMP.F32 S9,S21
		VMRS APSR_nzcv, FPSCR
		IT EQ
		VSUBEQ.F32 S22, S22, S30    ;Changing radius by -20
		VCMP.F32 S9,S28             ;Comparing angle with 360
		VMRS APSR_nzcv, FPSCR
		IT EQ
		VLDREQ.F32 S9,=0.0 	
		VCMP.F32 S22,#0
		VMRS APSR_nzcv, FPSCR
		IT EQ
		BEQ stop
		B ANGLE1
		BX lr
		
		ENDFUNC
;---------------------------------------------------------------------------------------------------------------------------------------------------
__main  FUNCTION  				;x=0-360
		
		VLDR.F32 s22,=100.0				;radius
		VMOV.F32 R0,S22
		VLDR.F32 S26,=300.0				;X
		VMOV.F32 R1,S26
		VLDR.F32 S27,=200.0				;Y
		VMOV.F32 R2,S27
		VLDR.F32 S25,=600.0				;X2
	    VMOV.F32 R3,S25
		VLDR.F32 S29,=400.0				;Y2
		VMOV.F32 R4,S29
		BL printMessage
		
		BL __DRAWCIRC					;DRAWING CIRCLE OF RADIUS 100 AND CENTERED AR (300,200)
		BL __DRAWCIRC2					;DRAWING CIRCLE OF RADIUS 100 AND CENTERED AR (600,400)

stop    B stop                              ; stop program

     ENDFUNC
	 END
	