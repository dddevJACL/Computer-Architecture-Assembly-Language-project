TITLE Low Level Calculator     (Proj6_dalindad.asm)



INCLUDE Irvine32.inc



;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

; Name:         mGetString

; Description:   Prompts user for a string, users Irvine ReadString Proc to get user string, stores user string and string length

; Preconditions: Strings are passed by reference. Prompt is valid string. Space and mempry is allocated for user string

; Receives:      getStringPrompt     = string to prompt user. OFFSET
;				 userStringBuffer    = Place in memory to store string recieved by Irvine ReadString Proc. OFFSET
;                maxUserStringLength = Maximum space allocated to input string. Used in conjunction with Irvin ReadString
;                bytesRead           = Number of bytes read by Irvine Readstring Proc

; Returns:       userStringBuffer now holds user string input.

;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

; 
mGetString	MACRO	getStringPrompt:REQ,	userStringBuffer:REQ,	maxUserStringLength:REQ,	bytesRead:REQ	
	
	; push relevant registers
	PUSH EAX
	PUSH ECX
	PUSH EDX
	
	MOV  EDX, getStringPrompt             ; prompt user for string
	CALL WriteString
	
	MOV  EDX, userStringBuffer
	MOV  ECX, maxUserStringLength         ; Prep for Irvine ReadString, call Irvine ReadString
	
	CALL ReadString

	MOV  bytesRead, EAX

	; pop relevant registers
	POP  EDX
	POP  ECX
	POP  EAX
ENDM



;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

; Name:          mDisplayString

; Description:   Recieves a string, and prints it to the terminal using the Irvine WriteString Procedure

; Preconditions: String must be passed by reference

; Receives:      stringAddress = string address in memory

; Returns:       stringAddress is printed to terminal     

;--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

; save EDX, move string offset to EDX, call Irvine WriteString, restore EDX
mDisplayString	MACRO	stringAddress:REQ
	PUSH EDX
	MOV  EDX,	stringAddress
	CALL WriteString
	;Call Crlf
	POP  EDX
ENDM



; (insert constant definitions here)

.data

programTitle        BYTE   "ASSIGNMENT 6: 'Low Level Calculator' by Daniel Dalinda", 13, 10, 0
programInstructions BYTE   13, 10, "Please enter 10 signed integers, that will each fit into a 32 bit register.", 13, 10, 
						   "Upon entering the digits, I will show you the digits you entered, their sum, and the truncated average.", 13, 10, 13, 10, 0

programFarewell     BYTE   13, 10, 13, 10, "Goodbye and thank you for using the 'Low Level Calculator' by Daniel Dalinda", 13, 10, 0

promptForSignedInt	BYTE   "Please enter a signed integer that will fit into a 32 bit register: ",0

extraCreditOne      BYTE   "**As per extra credit option 1, this program numbers lines, and prints running subtotal and average**", 13, 10, 13, 10, 0

userString			BYTE   13 DUP(?)
userStringMaxLen    DWORD  SIZEOF userString
userStringByteCount DWORD  ?
userInt             SDWORD 0

stringIntHolder     BYTE   13 DUP(?)

flagA               DWORD  1
flagB               DWORD  2
flagC               DWORD  3
periodSpace         BYTE   ".  ",0

userIntegerArray    SDWORD 12 DUP(0)
integerStringArray  SDWORD 12 DUP(?)

errorOverflow       BYTE   "ERROR! That number won't fit in a 32 bit register.", 13, 10, 0
errorInvalidInt     BYTE   "ERROR! That is not a valid integer. Please enter only digits. The first digit can be + or - eg. 512, +22, -99, etc.", 13, 10, 0
errorNoEntry        BYTE   "ERROR! You didn't enter anything", 13, 10, 0

counter             SDWORD 1
counterString       BYTE   13 DUP(?)
counterHolderString BYTE   "                        ", 0

runningSubTotal     BYTE   "The running subtotal is: ", 0
runningAverage      BYTE   "The running truncated average is: ", 0

arrayMessage        BYTE   13, 10, "You entered the following 10 valid signed integers:", 13, 10, 0
arrayTotal          BYTE   13, 10, "The total of all valid signed integers was: ", 0
arrayAverage        BYTE   13, 10, "The truncated average of all signed integers was: ",0

NumberHolder        BYTE   "                        ", 0
Reverse             BYTE   "                        ", 13, 10, 0
Blank               BYTE   25 DUP(" ")

lineCount           BYTE   2 DUP (?)
lineCountRev        BYTE   2 DUP (?)


.code
main PROC



; ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

; In the main procedure, create a loop, in which: 
;                                                 #1: WriteVal writes line number
;                                                 #2: ReadVal gets user input, converts it to integer and stores in array, calculate total and average
;                                                 #3: WriteVal prints running subtotal and running truncted average

; End the loop, print out user inputs, the total, and truncated average, by calling WriteVal one last time.

; ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



; print greeting and instructions, extracredit 1 message
mDisplayString OFFSET programTitle
mDisplayString OFFSET programInstructions
mDisplayString OFFSET extraCreditOne

; Move 10 to ECX, to read 10 values from user
MOV ECX, 10

_readValLoop:
	

	; This call to WriteVal prits line numbers and ". " eg   1. 
	PUSH OFFSET lineCountRev
	PUSH OFFSET lineCount
	PUSH OFFSET Blank
	PUSH OFFSET Reverse
	PUSH OFFSET NumberHolder
	PUSH OFFSET counterString
	PUSH        counter
	PUSH        flagA
	PUSH OFFSET periodSpace
	PUSH OFFSET runningSubTotal
	PUSH OFFSET runningAverage
	PUSH OFFSET arrayMessage
	PUSH OFFSET arrayTotal
	PUSH OFFSET arrayAverage
	PUSH OFFSET stringIntHolder
	PUSH OFFSET userIntegerArray
	CALL WriteVal


	; Call ReadVal to get user input, convert to integer, store in array
	PUSH OFFSET userInt
	PUSH OFFSET errorNoEntry
	PUSH        counter
	PUSH OFFSET errorOverflow
	PUSH OFFSET errorInvalidInt
	PUSH OFFSET promptForSignedInt
	PUSH OFFSET userString
	PUSH        userStringMaxLen
	PUSH        userStringByteCount
	PUSH OFFSET userIntegerArray
	CALL ReadVal


	; Call Writeval to calculate subtotal and running average
	PUSH OFFSET lineCountRev
	PUSH OFFSET lineCount
	PUSH OFFSET Blank
	PUSH OFFSET Reverse
	PUSH OFFSET NumberHolder
	PUSH OFFSET counterString
	PUSH        counter
	PUSH        flagB
	PUSH OFFSET periodSpace
	PUSH OFFSET runningSubTotal
	PUSH OFFSET runningAverage
	PUSH OFFSET arrayMessage
	PUSH OFFSET arrayTotal
	PUSH OFFSET arrayAverage
	PUSH OFFSET stringIntHolder
	PUSH OFFSET userIntegerArray
	CALL WriteVal

	; Increment the counter used for line numbers and array positions, decrement ECX loop counter
	INC   counter
	DEC   ECX
	CMP   ECX, 0
	JNZ   _readValLoop

	; Final Call to WriteVal to print all valid integers, the final total, and the truncated average
	PUSH OFFSET lineCountRev
	PUSH OFFSET lineCount
	PUSH OFFSET Blank
	PUSH OFFSET Reverse
	PUSH OFFSET NumberHolder
	PUSH OFFSET counterString
	PUSH        counter
	PUSH        flagC
	PUSH OFFSET periodSpace
	PUSH OFFSET runningSubTotal
	PUSH OFFSET runningAverage
	PUSH OFFSET arrayMessage
	PUSH OFFSET arrayTotal
	PUSH OFFSET arrayAverage
	PUSH OFFSET stringIntHolder
	PUSH OFFSET userIntegerArray
	CALL WriteVal


	

; print farewell message
mDisplayString OFFSET programFarewell


	Invoke ExitProcess,0	; exit to operating system
main ENDP



; ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

; Below is the definition for all procedures, ReadVal and WriteVal

; ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



;---------------------------------------------------------------------------------------------------------------------------------------------------------------------


; Procedure Name: ReadVal

; Description:    This proc calls mGetString to get user integer string. It converts this string into a true integer, and stores it in an integer array
;                 It also calculates the running subtotal and running truncated average.

; Preconditions:  ReadVal is set up to be called only 10 times. There must be 12 empty spaces in the integer array, the first 10 for the first 10 inputs,
;                 the 11th space for the running subtotal and the 12th for the running average. Prompts and error messages are valid strings.

; Postconditions: All registers are restored. The array of integers provided is changed with each call. The memory reserved for user string is
;                 changed with each call.

; Receives:       An array meant to hold integrs, all required parameters for mGetString. A counter for calculating array positions. All prompts and error
;                 messages(invalid input).

; Returns:        An Array of integers, which is updated at each iteration with the new input, the running subtotal, and the running average 


;---------------------------------------------------------------------------------------------------------------------------------------------------------------------


ReadVal PROC
    
	; push relevant registers
	PUSH EBP
	MOV  EBP, ESP
	
	PUSH EAX
	PUSH EBX
	PUSH ECX
	PUSH EDX
	PUSH ESI
	PUSH EDI

_getUserVal:
	
	mGetString [EBP + 24], [EBP + 20], [EBP + 16], [EBP + 12]


	; quick check if entered integer is evidently too small or too large for 32 bit register, or if there was no entry
	MOV  EAX, [EBP + 12]
	CMP  EAX, 11                 ; this is the longest string length an intetger can be, and only if it includes a + or - sign  (-2**31 <= n <=  2**31 - 1)
	JG   _invalidOverflow
	
	MOV  EAX, [EBP + 12]
	CMP  EAX, 0
	JE   _noEntry

	; Convert string to integer. Validate along the way for overflow, or invalid integers.
      
	; Move 0 into the current user integer holder
	MOV  EDI, [EBP + 44]
	MOV  ESI, [EBP + 44]
	MOV  EAX, 0
	MOV  [EDI], EAX

	MOV  EBX, [ESI]            ; store userint in EBX for calculations



	MOV  ECX, [EBP + 12]     ; move user inputted string length to ECX
	
	MOV  EDX, 0              ; flag to check if number is positive or negative, 0 for positive, 1 for negative
	
	; test if first char is a plus or minus sign
	
	DEC  ECX
	MOV  ESI, [EBP + 20]
	LODSB
	CMP  AL, 43
	JE _validateAndConvert      ; If first character is a plus sign, it an be ignored
	CMP  AL, 45
	JE _firstCharMinus

	; first char is neither plus nor minus, so reinitialize ESI and ECX
	INC ECX
	MOV  ESI, [EBP + 20]
	JMP _validateAndConvert


_firstCharMinus:

	MOV  EDX, 1   ; Number is negative, set a flag in EDX for use later
	


_validateAndConvert:
	
	; the algorithm 10 * NrunningTotal + (Nchar - 48) allows the conversion of string digits to integers
	; first 10 * NrunningTotal
	MOV  EAX, 10

	IMUL EBX, EAX
	JO _invalidOverflow                    ; confirm number isn't too big

	MOV  EAX, 0


	; load a character, check if its a valid digit, then use digit to add to running total of the integer
	LODSB
	CMP  AL, 48
	JL _invalidInt
	CMP  AL, 57
	JG _invalidInt

	SUB  AL, 48
	
	ADD EBX, EAX                          ; NrunningTotal + (Nchar - 48)

	JO _invalidOverflow                   ; confirm number isn't too big

	LOOP _validateAndConvert

	MOV  EAX, EDX
	CMP  EAX, 1
	JE   _numIsNegative
	
	JMP  _returnReadVal

_invalidOverflow:

	; if integer is too large or too small, display error message, and prompt user for another integer
	mDisplayString [EBP + 32]
	JMP  _getUserVal

_invalidInt:

    ; if integer is not a valid integer, display error message, and prompt user for another integer
	mDisplayString [EBP + 28]
	JMP  _getUserVal


_noEntry:

    ; if the user didnt enter anything, display error
	mDisplayString [EBP + 40]
	JMP  _getUserVal



_numIsNegative:
	
	; Number is negative,  convert the running total to a negative number
	MOV  EAX, EBX
	SUB  EAX, EBX
	SUB  EAX, EBX
	
	MOV  EBX, EAX     ; the next code block depends on the logic that the running total is held in EBX

_returnReadVal:
	
	; put the running total into the array of integers, calculate subtotal and running truncated average, restore registers and RET proc
	
	; Put running total into array, use the counter variable to determine the correct position in the array
	
	MOV  EDI, [EBP + 8]
	
	MOV  EAX,  [EBP + 36]
	DEC  EAX                   ; counter is 1 step ahead of correct array position

	MOV EDX, 4                 ; array of SDWORDS

	IMUL EAX, EDX              ; multiply counter by type

	ADD EDI, EAX               ; get correct position in EDI

	MOV [EDI], EBX             ; write the running average into the array
	

	; Calculate array running subtotal, which is held in the 10th index of the array
	MOV  ESI, [EBP + 8]
	MOV  EDI, [EBP + 8]

	MOV EAX, [ESI + 40]

	ADD EAX, EBX

	MOV [EDI + 40], EAX


	; Calculate array running truncated average, which is held in the 11th index of the array
	MOV  ESI, [EBP + 8]
	MOV  EDI, [EBP + 8]

	MOV EAX, [ESI + 40]        ; move running subtotal into EAX

	MOV  EBX,  [EBP + 36]      ; Move counter into EBX, which will be the divisor

	CDQ

	IDIV EBX

	MOV [EDI + 44], EAX        ; Move quotient to 11th position in array

	; pop relevant registers
	POP  EDI
	POP  ESI
	POP  EDX
	POP  ECX
	POP  EBX
	POP  EAX
	POP  EBP
	RET  40

ReadVal ENDP  




;---------------------------------------------------------------------------------------------------------------------------------------------------------------------


; Procedure Name: WriteVal

; Description:    The proc writeVal has three different functions depending on the flag it recieves. If it recieves FlagA, it prints the line number.
;                 If it recieves flagB, it prints the running subtotal and running average.
;                 If it recieves flagC, it prints out all 10 user inputs, the total, and the truncated average.

; Preconditions:  An array of integers that has been updated by ReadVal has been pushed on the stack. The counter reflects the current state of the loop.
;                 The appropriate flag has been pushed onto the stack, to indicate which function WriteVal should carry out.

; Postconditions: The string OFFSETs that are allocated to hold converted strings for printing are changed. This inculdes string offsets for printing line
;                 numbers, and string offsets used for holding reversed strings and the final printed string.

; Receives:       A flag(1, 2, 3), All string messages used to indicate what is being printed, an array of integers, the current counter.

; Returns:        Prints either the line number, the running subtotal and average, or all 10 user inputs, the total, and the truncated average.


;---------------------------------------------------------------------------------------------------------------------------------------------------------------------


WriteVal PROC
      
	; push relevant registers
	PUSH EBP
	MOV  EBP, ESP
	
	PUSH EAX
	PUSH EBX
	PUSH ECX
	PUSH EDX
	PUSH ESI
	PUSH EDI 
	
	; Check which version of WriteVal should run
	MOV  EAX, [EBP + 40]
	CMP  EAX, 3
	JE   _flagC
	
	CMP  EAX, 2
	JE   _flagB

	
_flagA:

	; This code block numbers user input before entering the input

	
	MOV  EAX, [EBP + 44]               ; Move counter into EAX, Move placeholder string into EDI
	MOV  EDI, [EBP + 64]
	
	MOV ECX, 0
	
	

_flagAprintLoop:	
	
	; calculate number on the principle that the remainder of n / 10   + 48 will give the string for desired digit, to be reversed later

	INC ECX
	MOV EDX, 0
	
	MOV EBX, 10

	DIV EBX

	MOV EBX, EAX                              ; store EAX in EBX. If the quotient that was in EAX is 0, the loop can end.

	MOV EAX, EDX
	ADD EAX, 48                                ; add 48 to get Ascii code for digit
	STOSB
	MOV EAX, EBX
	CMP EAX, 0
	JNZ _flagAprintLoop                       ; if quotient is 0, loop can end

	MOV  ESI, [EBP + 64]                      ; prepare ESI, EDI, and ECX for reversing a string
	MOV  EDI, [EBP + 68]
	ADD  ESI, ECX
	DEC  ESI
	

_flagArevLoop:
	
	; The string that was stored above is in reverse order; reverse the strings, then print with mDisplayString 
	
	STD
	LODSB
	CLD
	STOSB
	LOOP _flagArevLoop
	


	mDisplayString [EBP + 68]                              ; Display the counter string, and the string ". "
	mDisplayString [EBP + 36]


	JMP  _returnWriteVal

_flagB:

	; This code block calculates and prints the running subtotal and running average

	                            
	MOV EBX, 10              ; Move 10 to EBX, this is used to integate to code below that only the running total and average are to be printed,
	JMP _loadLoop            ; and not the whole array


_subTotal:
	
	mDisplayString [EBP + 32]     ; print message and running subtotal, jump to load loop for calculating running truncated average
	mDisplayString [EBP + 52]
	JMP  _loadLoop

_runningAverage:
	

	mDisplayString [EBP + 28]
	mDisplayString [EBP + 52]     ; print message and running truncated average, jump to end of Proc

	JMP  _returnWriteVal

_flagC:
	
	; This code block prints the whole array, including the total and truncated average

	mDisplayString [EBP + 24]
	
	MOV  EBX, 0
	
_loadLoop:	
	
	; Wipe all used string placeholders with blank spaces, from [EBP + 60]
	MOV  ESI, [EBP + 60]
	MOV  EDI, [EBP + 52]
	MOV  ECX, 25
	REP  MOVSB

	MOV  ESI, [EBP + 60]
	MOV  EDI, [EBP + 56]
	MOV  ECX, 25
	REP  MOVSB

	MOV  ESI, [EBP + 60]
	MOV  EDI, [EBP + 48]
	MOV  ECX, 25
	REP  MOVSB
	
	
	; put integer in ESI, string to write to in EDI, get proper position in arry by multiplying 4 by EBX, and adding EAX to ESI
	MOV  ESI, [EBP + 8]              
	MOV  EDI, [EBP + 48]          
	MOV  EAX, 4
	MUL  EBX
	ADD ESI, EAX

	; Move 0 to counter, increment array counter (EBX) and push it onto the stack, load SDWORD into EAX
	MOV ECX, 0
	INC EBX
	PUSH EBX
	LODSD
	CMP EAX, 0                ; if number is not negtive, proceed normally to print loop
	JNL _printLoop
	
	MOV EBX, EAX               ; if number is negtive, convert it to a positive number, and jump to negativePrintLoop
	SUB EAX, EBX
	SUB EAX, EBX
	JMP _negativePrintLoop

_printLoop:	

	; calculate number on the principle that the remainder of n / 10   + 48 will give the string for desired digit, to be reversed later

	; Increment ECX, which is a counter for string length
	INC ECX
	
	
	MOV EDX, 0
	MOV EBX, 10
	DIV EBX

	MOV EBX, EAX                 ; store EAX in EBX. If the quotient that was in EAX is 0, the loop can end.

	MOV EAX, EDX
	ADD EAX, 48                     ; add 48 to get Ascii code for digit
	STOSB
	MOV EAX, EBX
	CMP EAX, 0
	JNZ _printLoop              ; if quotient is 0, loop can end

	MOV  ESI, [EBP + 48]           ; prepare ESI, EDI, and ECX for reversing a string, jump to reverse loop
	MOV  EDI, [EBP + 52]
	ADD  ESI, ECX
	DEC  ESI
	JMP _revLoop


_negativePrintLoop:
	
	; This code block functions identically to the positive print loop above, 
	; except in the final itertion its uses STOSB to write " - " (45), and increments ECX by one more accordingly
	
	
	; same as print loop
	INC ECX
	MOV EDX, 0
	
	MOV EBX, 10

	DIV EBX

	MOV EBX, EAX

	MOV EAX, EDX
	ADD EAX, 48
	STOSB
	MOV EAX, EBX
	CMP EAX, 0
	JNZ _negativePrintLoop

	MOV EAX, 0
	MOV EAX, 45                 ;  write " - ", increment string length counter ECX
	STOSB
	INC ECX

	; same as print loop
	MOV  ESI, [EBP + 48]
	MOV  EDI, [EBP + 52]
	ADD  ESI, ECX
	DEC  ESI
	JMP _revLoop

_revLoop:

	; The string that was stored above is in reverse order; reverse the strings, then print with mDisplayString 
	STD
	LODSB
	CLD
	STOSB
	LOOP _revLoop
	
	POP EBX
	CMP EBX, 11                          ; if EBX is 11, then the total or the running total should be printed, along with the appropriate message
	JE  _Total

	CMP EBX, 12
	JE  _Average                         ; if EBX is 12, then the truncated average or the running truncated average should be printed, 
	                                     ; along with the appropriate message


	mDisplayString [EBP + 52]            ; print the current user input that has been reconverted to  string
	
	
	JMP _loadLoop


_Total:
	
	; Check if the subtotal (flagB, 2) or the final total (flagC, 3) should be printed
	MOV  EAX, [EBP + 40]
	CMP  EAX, 2
	JE   _subTotal                ; move back up to appropriate code block if this is a flagB call

	mDisplayString [EBP + 20]
	mDisplayString [EBP + 52]
	JMP _loadLoop

_Average:
	
	; Check if the running truncated average (flagB, 2) or the final truncated average (flagC, 3) should be printed
	MOV  EAX, [EBP + 40]
	CMP  EAX, 2
	JE   _runningAverage             ; move back up to appropriate code block if this is a flagB call

	mDisplayString [EBP + 16]
	mDisplayString [EBP + 52]
	

_returnWriteVal:

	; pop relevant registers
	POP  EDI
	POP  ESI
	POP  EDX
	POP  ECX
	POP  EBX
	POP  EAX
	POP  EBP
	RET  64


WriteVal ENDP  

END main
