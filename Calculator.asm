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

;----------------------------------- Includes ------------------------------------
;               Other files which contain code that is called from this file      `
;                                                                                 |
%include "lib/LinuxMacros.asm"  ; Provides macros for the Linux kernel calls.
%include "lib/ASCII.asm"        ; Provides ASCII conversion.
%include "lib/Memory.asm"       ; Provides memory access functions

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
    pop ebx             ; Pointer to the block of memory that points to the
                        ; arguments.
    call NextArg        ; Get the next argument
    mov [No1], al       ; Copy the extracted value to the variable No1

    call NextArg        ; Get the next argument
    mov [OpIn], al      ; Save the extracted value to the variable OpIn
    
    call NextArg        ; Get the next argument
    mov [No2], al       ; Save the extracted value to the variable No2

    ;; Test for correct input values
    xor eax, eax        ; Clear EAX to make sure our values are copied correctly.
    mov al, [No1]       ; Copy the first numbers value to al.
    call TestASCIINumber     ; Call the test number routine.
    call ConvASCIIToNo  ; Convert the ASCII number to the actual numbeR
    mov [No1], al       ; Copy the converted number to No1
    mov al, [No2]       ; Copy the second numbers value to al.
    call TestASCIINumber     ; Call the test number routine.
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
    
    ; A invalid operator was entered Exit, FIXME: Display visual feedback
    jmp Exit
;; FIXME: Could we combine the TestASCIINumber and convert operations into One?
;; FIXME: Possibly not need ASCII conversion? becasuse arithmetic may still work?
; NextArg -----------------------------------------------------------------------
;               Get the next argument and store it in EAX.                       `
;                                                                                |
NextArg:
    add ebx, 0x04       ; Move to the next argument by incrementing our memory
                        ; location by 0x04
    mov ecx, [ebx]      ; Grab the pointer to the next argument
    xor eax, eax        ; Clear eax
    mov al, [ecx]       ; Get the first bit of the argument.
    ret 0               ; Return
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
    int kernel          ; Interrupt to call the Linux kernel.
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
    int kernel          ; Call the Linux kernel
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

