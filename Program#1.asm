TITLE Project #1     (Program#1.asm)

;-------------------------------------------------------------------------------------------------------------------;
; Author:Brandon Schultz                                                                                            ;
; First Modified: 4-5-20                             Last Modified: 4-8-20                                          ;
; OSU email address:                                 schulbra@oregonstate.edu                                       ;
; Course nBer/section:                             CS 271 400 Spring 2020                                         ;
; Project nBer: One                                Due Date: 4-12-20                                              ;
; Description: Contains MASM code that:                                                                             ;
;   1. Displays name of programmer and program's title.                                                             ;
;   2. Prompts user to enter three values (A > B > C) in descending order.                                          ;
;   3. Validates that A > B > C, then calculates and displays sum/difference values for all possible sets of A-B-C. ;
;   4. Prompts user to play again, or exit program before displaying a farewell message.                            ;
;-------------------------------------------------------------------------------------------------------------------;

INCLUDE Irvine32.inc

.386
.model flat, stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD

.data

;--------------------------------------------------------------------------------------------------------------------;
;									nA, nB, nC =  Values defined by user											 ;
;--------------------------------------------------------------------------------------------------------------------;

nA					SDWORD   ?
nB					SDWORD   ?
nC					SDWORD   ?
nQ					SDWORD   ?

;--------------------------------------------------------------------------------------------------------------------;
;	-Various, self-explanatory (hopefully) definitions.											                                 ;
;--------------------------------------------------------------------------------------------------------------------;

sumValue			SDWORD   0
ansValue			SDWORD   0
displayName			BYTE	"| Brandon Schultz                                                                    |", 0;
displayboardTOP		BYTE	"|------------------------------------------------------------------------------------|", 0;
displayProgram		BYTE	"| CS_271 Program #1 An Introduction to MASM assembly language.                       |", 0;
displayECPrompt1	BYTE	"|  ** EC1: Program repeats until user quits.                                         |", 0;
displayECPrompt2	BYTE	"|  ** EC2: Program validates that values are in descending order.                    |", 0;
displayECPrompt3	BYTE	"|  ** EC3: Program handles negative results and computes B-A, C-A, C-B and C-B-A.    |", 0;
displayRules		BYTE    "Enter 3 numbers where A > B > C, and I'll show you the truth.", 0;
askValueFirst		BYTE	"First number:  ", 0;
askValueSecond		BYTE	"Second number: ", 0;
askValueThird		BYTE	"Third number:  ", 0;
displayExitPrompt	BYTE	"To exit press 1.           	|            To play again, press any other key.", 0;
displayExitPrompt1	BYTE	"Thanks for playing!", 0;
diplayInvalidValInp	BYTE	"Values must be entered in descending order (A>B>C) ", 0;
plus	            BYTE	" + ", 0;
subt	            BYTE	" - ", 0;
equal	            BYTE	" = ", 0;

;--------------------------------------------------------------------------------------------------------------------;
;		a = answer |	A/B/C = user defined variable |	S = subtract |  P = add |  Ex: aAPB = answer of A + B		 ;
;--------------------------------------------------------------------------------------------------------------------;

aAPB				SDWORD	?
aASB				SDWORD	?
aAPC				SDWORD	?
aASC				SDWORD	?
aBPC				SDWORD	?
aBSC				SDWORD	?
aAPBPC				SDWORD	?
aBSA				SDWORD	?
aCSA				SDWORD	?
aCSB				SDWORD	?
aCSBSA				SDWORD	?

;--------------------------------------------------------------------------------------------------------------------;
;	-Procedure used to introduce program to user.                                                                    ;
;   -Contains author/s/program's name, features implemented for EC and instructions.								 ;
;--------------------------------------------------------------------------------------------------------------------;

.code
main PROC
		; Displays Boarder for top/bottom of assignment info template.
		mov		edx, OFFSET	displayboardTOP
		call	WriteString
		call	Crlf

		; Displays programmer's name.
		mov		edx, OFFSET	displayName
		call	WriteString
		call	Crlf

	    ; Displays project's name.
		mov		edx, OFFSET	displayProgram
		call	WriteString
		call	Crlf

		; Displays that EC option one was implemented.
		mov		edx, OFFSET	displayECPrompt1
		call	WriteString
		call	Crlf

		; Displays that EC option two was implemented.
		mov		edx, OFFSET	displayECPrompt2
		call	WriteString
		call	Crlf

		; Displays that EC option three was implemented.
		mov		edx, OFFSET	displayECPrompt3
		call	WriteString
		call	Crlf

		; Displays Boarder for top/bottom of assignment info template.
		mov		edx, OFFSET	displayboardTOP
		call	WriteString
		call	Crlf
		call	Crlf

		; Displays programs rules/purpose.
		mov		edx, OFFSET	displayRules
		call	WriteString
		call	Crlf


;--------------------------------------------------------------------------------------------------------------------;
;	-Methods for displaying prompts to and obtaining values A-C from user.											 ;
;--------------------------------------------------------------------------------------------------------------------;
BEGIN_PROMPT_LOOP:

		; Prompt for first of three values: A
		call	CrLf
		mov		edx, OFFSET askValueFirst
		call	WriteString
		call	ReadInt
		mov		nA, eax

		; Obtain 2nd: B
		mov		edx, OFFSET askValueSecond
		call	WriteString
		call	ReadInt
		mov		nB, eax

		; Obtain third: C
		mov		edx, OFFSET askValueThird
		call	WriteString
		call	ReadInt
		mov		nC, eax
		call	CrLf

		; Validate that A > B > C. If true, jump to BEGIN_MATH and solve for various A-B-C conditions.
		; If input doesnt pass validation check user is prompted to enter values again after jumping to INPUT_VALIDATION.
		mov		eax, nA
		cmp		eax, nB
		jbe		INPUT_ERROR
		mov		eax, nB
		cmp		eax, nC
		jbe		INPUT_ERROR
		jmp		CALCULATE

;--------------------------------------------------------------------------------------------------------------------;
;	-If values A > B > C arent properly entered user is redirected to prompt loop above.							 ;
;--------------------------------------------------------------------------------------------------------------------;
INPUT_ERROR:

		mov		edx, OFFSET	diplayInvalidValInp
		call	WriteString
		call	Crlf
		jmp		BEGIN_PROMPT_LOOP

;--------------------------------------------------------------------------------------------------------------------;
;	-Methods used to obtain sum and difference values from 	 A > B > C                                               ;
;   -Each calculation is performed with nA-nC before having result stored  as come variant of a(ABC)(PS)(ABC)        ;
;   -or a (ABC)(PS)(ABC)(PS)(ABC).                                                                                   ;
;--------------------------------------------------------------------------------------------------------------------;
CALCULATE:

	;-----------------------------------------------------------------------------------------------------------;
	;	a = answer |	A/B/C = user defined variable |	S = subtract |  P = add |  Ex: aAPB = answer of A + B	;
	;-----------------------------------------------------------------------------------------------------------;
	mov		eax, nA		        ; Value A
	call	WriteInt
	mov		edx, OFFSET plus	; +
	call	WriteString
	mov		eax, nB				; Value B
	call	WriteInt
	mov		edx, OFFSET equal   ; Is equal to...
	call	WriteString
	add		eax, nA
	mov		aAPB, eax			; aAPB
	mov		eax, aAPB
	call	WriteInt			; so display aAPB
	call	CrLf

	mov		eax, nA
	call	WriteInt
	mov		edx, OFFSET subt
	call	WriteString
	mov		eax, nB
	call	WriteInt
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, nA
	sub		eax, nB
	mov		aASB, eax
	mov		eax, aASB
	call	WriteInt
	call	CrLf

	mov		eax, nA
	call	WriteInt
	mov		edx, OFFSET plus
	call	WriteString
	mov		eax, nC
	call	WriteInt
	mov		edx, OFFSET equal
	call	WriteString
	add		eax, nA
	mov		aAPC, eax
	mov		eax, aAPC
	call	WriteInt
	call	CrLf

	mov		eax, nA
	call	WriteInt
	mov		edx, OFFSET subt
	call	WriteString
	mov		eax, nC
	call	WriteInt
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, nA
	sub		eax, nC
	mov		aASC, eax
	mov		eax, aASC
	call	WriteInt
	call	CrLf

	mov		eax, nB
	call	WriteInt
	mov		edx, OFFSET plus
	call	WriteString
	mov		eax, nC
	call	WriteInt
	mov		edx, OFFSET equal
	call	WriteString
	add		eax, nB
	mov		aBPC, eax
	mov		eax, aBPC
	call	WriteInt
	call	CrLf

	mov		eax, nB
	call	WriteInt
	mov		edx, OFFSET subt
	call	WriteString
	mov		eax, nC
	call	WriteInt
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, nB
	sub		eax, nC
	mov		aBSC, eax
	mov		eax, aBSC
	call	WriteInt
	call	CrLf

	mov		eax, nA
	call	WriteInt
	mov		edx, OFFSET plus
	call	WriteString
	mov		eax, nB
	call	WriteInt
	mov		edx, OFFSET plus
	call	WriteString
	mov		eax, nC
	call	WriteInt
	mov		edx, OFFSET equal
	call	WriteString
	add		eax, aAPB
	mov		aAPBPC, eax
	mov		eax, aAPBPC
	call	WriteInt
	call	CrLf

	mov		eax, nB
	call	WriteInt
	mov		edx, OFFSET subt
	call	WriteString
	mov		eax, nA
	call	WriteInt
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, nB
	sub		eax, nA
	mov		aBSA, eax
	mov		eax, aBSA
	call	WriteInt
	call	CrLf

	mov		eax, nC
	call	WriteInt
	mov		edx, OFFSET subt
	call	WriteString
	mov		eax, nA
	call	WriteInt
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, nC
	sub		eax, nA
	mov		aCSA, eax
	mov		eax, aCSA
	call	WriteInt
	call	CrLf

	mov		eax, nC
	call	WriteInt
	mov		edx, OFFSET subt
	call	WriteString
	mov		eax, nB
	call	WriteInt
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, nC
	sub		eax, nB
	mov		aCSB, eax
	mov		eax, aCSB
	call	WriteInt
	call	CrLf

	mov		eax, nC
	call	WriteInt
	mov		edx, OFFSET subt
	call	WriteString
	mov		eax, nB
	call	WriteInt
	mov		edx, OFFSET subt
	call	WriteString
	mov		eax, nA
	call	WriteInt
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, aCSB
	sub		eax, nA
	mov		aCSBSA, eax
	mov		eax, aCSBSA
	call	WriteInt
	call	CrLf

	call	CrLf
	;-----------------------------------------------------------------------------------------------------------;
	;	Asks user to continue playing, or exit program. Displays exit prompt if user chooses to quit.	        ;
	;-----------------------------------------------------------------------------------------------------------;
	mov		edx, OFFSET displayExitPrompt
	call	WriteString
	call	ReadInt
	mov		nQ, eax
	cmp		nQ, 1
	JE		CONTINUE_PROGRAM
	jmp		BEGIN_PROMPT_LOOP

CONTINUE_PROGRAM:

	mov		edx, OFFSET displayExitPrompt1
	call	WriteString
	call	Crlf
	jmp		theEnd

theEnd:


	exit

main ENDP

END main