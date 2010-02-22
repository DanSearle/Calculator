;=================================================================================
; Calculator  | A simple calculator programmed in x86 assembly, for Linux.       ;
;---------------------------------------------------------------------------------
;                                                                                ;
; The calculator asks for inputs an operation then asks for 2 values for the     ;
; operation to be performed on. Then the program returns the result of the       ;
; equation.                                                                      ;
;
;---------------------------------------------------------------------------------
; Licence     | This program is free software: you can redistribute it and/or    ;
;             | modify it under the terms of the GNU General Public License as   ;
;             | published by the Free Software Foundation, either version 3 of   ;
;             | the License, or (at your option) any later version.              ;
;             |                                                                  ;
;             | This program is distributed in the hope that it will be useful,  ;
;             | but WITHOUT ANY WARRANTY; without even the implied warranty of   ;
;             | MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the    ;
;             | GNU General Public License for more details.                     ;
;             |                                                                  ;
;             | You should have received a copy of the GNU General Public        ;
;             | Licence along with this program.                                 ;
;             | If not, see <http://www.gnu.org/licenses/>.                      ;
;             |                                                                  ;
;             | See the LICENCE file for the full GNUv3 General Public License.  ;
;---------------------------------------------------------------------------------
; Authors     | Original Author: Daniel Searle <oss@d-searle.co.uk> 2010         ;
;=================================================================================

;------------------------------------ Macros -------------------------------------
;               Below are macros in order to help us remember how to fill out the `
;               'parameters' of a interrupt call.                                 |
;---------------------------------------------------------------------------------
; Functions   | Numbers which are used in order to call a function from the Linux `
;             | kernel.                                                           |
%define sys_exit  0x01 ; sys_exit function number See `man 2 exit`
%define sys_read  0x03 ; sys_read function number See `man 2 read`
%define sys_write 0x04 ; sys_write function number See `man 2 write`
;---------------------------------------------------------------------------------
; Files       | Number which are used for file descriptors.                       `
;             |                                                                   |
%define STDIN     0x00 ; Standard input  buffer is 0, when using sys_* functions.
%define STDOUT    0x01 ; Standard output buffer is 1, when using sys_* functions.
;---------------------------------------------------------------------------------
; Interrupts  | Numbers which are used for interrupts.                            `
;             |                                                                   |
%define Kernel    0x80 ; Interrupt number for the Linux kernel.
;=================================================================================

;--------------------------------- Text Section ----------------------------------
;               This Section is where the assembly code for the program is        `
;               written.                                                          |
section .text
  global main           ; Allows the linker to 'see' our _start label.

; main ---------------------------------------------------------------------------
;               Main is the entry point into our calculator application, these    `
;               Lines will get executed first.                                    |
main:
    ; This section grabs the arguments that were passed to the program from the
    ; stack.
    pop eax             ; Pop the first item of of the stack (Gibberish?)
                        ; TODO Find out why
    pop eax             ; Pop the number of arguments off of the stack 
    ;; Could be more efficient if we subtract 4 instead of caring about
    ;; decrementing first
    dec eax             ; Decrement the number of arguments because we dont want
                        ; the program name
    sub eax, 0x03       ; Subtract 3 from the nuumber of arguments eax will be 
                        ; 0 if the number of args is equal to 3.
    jnz Exit            ; FIXME: Should jump to display an error
    pop eax             ; Pointer to the block of memory that points to the
                        ; arguments.
    add eax, 0x04       ; Add 4 bytes to the argument start location to not
                        ; include the program path.
    mov ebx, [eax]      ; Copy the data in the memory location given by EAX
                        ; to EBX - Pointer address of the first argument.
    mov ebx, [ebx]      ; Store the actual first argument to the eax register. FIXME: Copy to bl register?
    mov [No1], bl       ; Copy the extracted value to the variable No1

    add eax, 0x04       ; Move to the next argument by incrementing our memory
                        ; location by 0x04
    mov ebx, [eax]      ; Grab the pointer to the next argument
    mov ebx, [ebx]      ; Get the first bit of the argument. FIXME: Copy to bl register?
    mov [OpIn], bl      ; Save the extracted value to the variable OpIn
    
    add eax, 0x04       ; Move to the next argument pointer
    mov ebx, [eax]      ; Grab the pointer
    mov ebx, [ebx]      ; Get the argument
    mov [No2], bl       ; Save the extracted value to the variable No2

    ;; Test for correct input values
    xor eax, eax        ; Clear EAX to make sure our values are copied correctly.
    mov al, [No1]       ; Copy the first numbers value to al.
    call TestNumber     ; Call the test number routine.
    call ConvASCIIToNo  ; Convert the ASCII number to the actual numbeR
    mov [No1], al       ; Copy the converted number to No1
    mov al, [No2]       ; Copy the second numbers value to al.
    call TestNumber     ; Call the test number routine.
    call ConvASCIIToNo  ; Convert the ASCII number to the actual number
    mov [No2], al       ; Copy the converted number to  No2
    ;; We get here if the numbers were valid

    ;; Test the operator
    xor eax, eax
    mov al, [OpIn]      ; Load in the operator passed
    cmp al, 0x2A        ; Multiplication ASCII code (*)
    je Multiply         ; Jump to the Multiplication procedure if * was the op
    cmp al, 0x2B        ; Addition ASCII code (+)
    je Addition         ; Jump to the Addition procedure if + was the operator
    cmp al, 0x2D        ; Subtraction ASCII code (-)
    je Subtract         ; Jump to the subtract procedure if - was the operator
    cmp al, 0x2F        ; Division ASCII code (/)
    je Divide           ; Jump to the devide procedure if / was the operator
    
    ; A Valid operator was not entered Exit, FIXME: Display visual feedback
    jmp Exit
;; FIXME: Could we combine the TestNumber and convert operations into One?
;; FIXME: Possibly not need ASCII conversion? becasuse arithmetic may still work?
; TestNumber --------------------------------------------------------------------
;               Tests that the value in EAX is a valid ASCII number.             `
;                                                                                |
TestNumber:
    cmp eax, 0x30       ; ASCII value should not be below 0x30 Number 0.
    jb  Exit            ; Exit if it is FIXME: Display error.
    cmp eax, 0x39       ; ASCII value should not be below 0x39 Number 9.
    ja  Exit            ; Exit if it is FIXME: Display error.
    ret 0               ; Return if the number was valid.
; ConvNoToASCII -----------------------------------------------------------------
;               Converts a number into its ASCII representation, by adding 0x30  `
;               to the number. Input number to EAX and Output value to EAX       |
ConvNoToASCII:
    add eax, 0x30
    ret 0
; ConvertASCIIToNo --------------------------------------------------------------
;               Converts a ASCII value of a number into the actual number, by    `
;               subtracting 0x30 from the number. Input value to EAX and Output  | 
;               number to EAX.                                                   | 
ConvertASCIIToNo:
    sub eax, 0x30       ; Subtract 0x30 from eax to get the actual number 
    ret 0               ; Return to who called us
; StrValues ---------------------------------------------------------------------
;               Copy the grabbed values from memory into the AL and BL registers.`
;               Also clear EAX, EBX and EDX to make sure calculations are        |
;               correct.                                                         |
StrValues:  
    xor eax, eax        ; Clear the main registers to prevent our calculations 
    xor ebx, ebx        ; from breaking.
    xor edx, edx        ;

    mov al, [No1]       ; Copy the first number to the AL register.
    mov bl, [No2]       ; Copy the second number to the BL register.
    ret 0
; StrDispResult -----------------------------------------------------------------
;               Store the result of a calculation to the Result variable, add    `
;               an new line and output the value to the console.                 |
StrDispResult:
    mov [Result], eax   ; Copy the value in EAX to the Result variable.
    call DisplayResult  ; Display the result to the console
    ret 0
; Subtract ----------------------------------------------------------------------
;               Performs the calculation No1 - No2 = Result and displays the     `
;               result in ASCII to the terminal.                                 |
Subtract: 
    call StrValues      ; Copy the values over
    sub  al, bl         ; Subtract the second number from the first number
    call StrDispResult  ; Store the result
    call Exit           ; Exit the application safely
; Addition ----------------------------------------------------------------------
;               Performs the calulation No1 + No2 = Result and displays the      `
;               result in ASCII to the terminal.                                 |
Addition: 
    call StrValues      ; Copy the values over
    add  al, bl         ; Add the first and second numbers together 
    call StrDispResult  ; Store the result
    call Exit           ; Exit the application safely.
; Multiply ----------------------------------------------------------------------
;               Performs the calculation No1 * No2 = Result and displays the     `
;               result in ASCII to the terminal.                                 |
Multiply: 
    call StrValues      ; Copy the values over
    mul  ebx            ; Multiply EAX(First number) by EBX(Second number)
    call StrDispResult  ; Store the result
    call Exit           ; Exit the application safely.
; Divide ------------------------------------------------------------------------
;               Performs the calculation No1/No2 = Result and displays the       `
;               result in ASCII to the terminal.                                 |
Divide: 
    call StrValues      ; Copy the values over
    idiv ebx            ; Integer Divide EDX:EAX(First number) by
                        ; EBX(Second Number).
    call StrDispResult  ; Store the result
    call Exit           ; Exit the application safely.
; Exit --------------------------------------------------------------------------
;               Exit is the code that exits the application safely, this         `
;               calculator is dumb and always exits with the 0 (no error) error  |
;               code.                                                            |
Exit: 
    xor ebx, ebx        ; XOR the ebx register with itself, effectively setting it
                        ; to 0.
                        ; If you have the binary string 0101 and you execute 
                        ; 0101 XOR 0101 you will get 0, because an XOR gate will
                        ; only return a 1 if the gates inputs are different.
    mov eax, sys_exit   ; Use the sys_exit system call from the kernel.
    int Kernel          ; Interrupt to call the Linux kernel.
    ret 0x00            ; Return - Should never reach here but as good practice.
; DisplayResult -----------------------------------------------------------------
;               Display the result of a calculation to the console               `
;                                                                                |
DisplayResult:
    mov  al, [Result]   ; Store the result to the eax register
    call ConvNoToASCII  ; Convert the number to an ASCII representation.
    mov  ah, 0x0A       ; Add a newline character to the bit stream.
    mov  [ResASCII], eax; Save the converted number to a variable
    mov  ecx, ResASCII  ; Point our ecx register at the ASCII result
    mov  edx, 2         ; Size of the output
    call Display        ; Call the display function
    ret  0
; Display -----------------------------------------------------------------------
;               Display is a section which displays the text to STDOUT using the `
;               sys_write function. The call uses the string pointed to by the   |
;               ECX register, we do not have to worry about iterating over each  |
;               character because the sys_write function handles this for us.    |
;               The size of the string to output is stored in the EDX register.  |
Display: 
    mov ebx, STDOUT     ; Send the string to standard output.
    mov eax, sys_write  ; We want to use the sys_write Linux function.
    int Kernel          ; Call the Linux kernel
    ret 0               ; Return to the section of code that called us.

;--------------------------------- Data Section ---------------------------------
;               Constant values which do not change during the execution of the  `
;               program.                                                         |
section .data 
    ; String Asks the user to enter an operation
    OpAsk    db  'Enter an Operation: ' 
    OpAskLen equ $ - OpAsk ; Length of the text

;--------------------------------- BSS Section ----------------------------------
;               Variables which have not yet been assigned a value memory is     `
;               only allocated.                                                  |
section .bss
    No1      resb 1     ; Reserve a byte for the first number pointer
    OpIn     resb 1     ; Reserve a byte for the operation pointer
    No2      resb 1     ; Reserve a byte for the second number pointer
    Result   resw 1     ; Reserve a word for the result as a pure binary number
    ResASCII resw 1     ; Reserve a word for the result in ASCII

