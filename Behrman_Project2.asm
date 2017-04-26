TITLE Behrman_Project2     (Behrman_Project2.asm)

; display user-requested number of fibonacci numbers

INCLUDE Irvine32.inc

.data

myName		BYTE	"Name: Alexandra Behrman", 0
myProgram	BYTE	"Title: Programming Assignment #2", 0
name_prompt	BYTE	"What's your name? ", 0
userName	BYTE	30 DUP(0)
hello		BYTE	"Hello, ", 0
goodbye		BYTE	"Goodbye, ", 0
period		BYTE	".", 0
num_prompt	BYTE	"Please enter the number of Fionacci terms you want to display.", 0
num_range	BYTE	"The number should be an integer between 1-46: ", 0
range_err	BYTE	"That number is out of range.", 0

count		DWORD	0 ;tracking number of terms on each line
five		DWORD	5 ;for determining if new line is needed
fib_num		DWORD	? ;number of fibonacci terms user wants to display
prev_num1	DWORD	? ;prior fibonacci number to be added
prev_num2	DWORD	? ;prior fibonacci number to be added
temp		DWORD	? ;holding variable

space		BYTE	"     ", 0
one			BYTE	"1", 0

UPPERLIMIT = 46
LOWERLIMIT = 1

.code
main PROC

;introduction
	mov		edx, OFFSET myName
	call	WriteString
	call	CrLf
	mov		edx, OFFSET myProgram
	call	WriteString
	call	CrLf
	call	CrLf

;getUserData
	mov		edx, OFFSET name_prompt
	call	WriteString
	mov		edx, OFFSET userName
	mov		ecx, SIZEOF userName
	call	ReadString

	;Greet User
	mov		edx, OFFSET hello
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	mov		edx, OFFSET period
	call	WriteString
	call	CrLf
	call	CrLf

;userInstructions
	mov		edx, OFFSET num_prompt
	call	WriteString
	call	CrLf

top:
	mov		edx, OFFSET num_range
	call	WriteString
	call	ReadInt
	mov		fib_num, eax
	call	CrLf

	;validation
	cmp		eax, UPPERLIMIT
	jg		RangeError
	cmp		eax, LOWERLIMIT
	jl		RangeError
	cmp		eax, 1
	je		NumIsOne
	cmp		eax, 2
	je		NumIsTwo

;displayFibs

	;load fib_num as loop counter and subtract two (1s will be displayed before loop starts)
	mov		ecx, fib_num
	sub		ecx, 2

	;display 1s
	mov		eax, 1
	call	WriteDec
	inc		count
	mov		prev_num2, eax
	mov		edx, OFFSET space
	call	WriteString
	mov		eax, 1
	call	WriteDec
	inc		count
	mov		prev_num1, eax
	mov		edx, OFFSET space
	call	WriteString

	;display remaining fib terms
L1:
	add		eax, prev_num2
	call	WriteDec
	inc		count
	mov		edx, OFFSET space
	call	WriteString

	mov		temp, eax
	mov		eax, prev_num1
	mov		prev_num2, eax
	mov		eax, temp
	mov		prev_num1, eax
	
	;determine if there are already 5 terms in the line
	mov		edx, 0
	mov		eax, count
	mov		ebx, five
	div		ebx
	cmp		edx, 0
	jne		NextNum
	call	CrLf

	;jump if there are less than 5 terms in the line
	NextNum:
		mov		eax, temp
		loop	L1
	
	jmp		ProgramEnd	

;if user input is out of range	
RangeError:
	mov		edx, OFFSET range_err
	call	WriteString
	call	CrLf
	jmp		top

;user wants to display one fibonacci term
NumIsOne:
	mov		edx, OFFSET one
	call	WriteString
	jmp		ProgramEnd

;user wants to display two fibonacci terms
NumIsTwo:
	mov		edx, OFFSET one
	call	WriteString
	mov		edx, OFFSET space
	call	WriteString
	mov		edx, OFFSET one
	call	WriteString
	jmp		ProgramEnd

;farewell
ProgramEnd:
	call	CrLf
	call	CrLf
	mov		edx, OFFSET goodbye
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	mov		edx, OFFSET period
	call	WriteString
	call	CrLf
	call	CrLf

	exit

main ENDP

END main
