;=================================================================================
; Calculator  | A simple calculator programmed in x86 assembly, for Linux.
;---------------------------------------------------------------------------------
;
; The calculator asks for inputs an operation then asks for 2 values for the
; operation to be performed on. Then the program returns the result of the
; equation.
;
;---------------------------------------------------------------------------------
; Licence     | This program is free software: you can redistribute it and/or
;             | modify it under the terms of the GNU General Public License as 
;             | published by the Free Software Foundation, either version 3 of the
;             | License, or (at your option) any later version.
;             |
;             | This program is distributed in the hope that it will be useful,
;             | but WITHOUT ANY WARRANTY; without even the implied warranty of
;             | MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;             | GNU General Public License for more details.
;             |
;             | You should have received a copy of the GNU General Public License
;             | along with this program.
;             | If not, see <http://www.gnu.org/licenses/>.
;             |
;             | See the LICENCE file for the full GNU General Public License.
;---------------------------------------------------------------------------------
; Authors     | Original Author: Daniel Searle <oss@d-searle.co.uk> 2010
;=================================================================================

;------------------------------------ Macros -------------------------------------
;               Below are macros in order to help us remember how to fill out the
;               'parameters' of a interrupt call.
;---------------------------------------------------------------------------------
; Functions   | Numbers which are used in order to call a function from the Linux
;             | kernel.
%define sys_exit  0x01 ; sys_exit function number See `man 2 exit`
%define sys_read  0x03 ; sys_read function number See `man 2 read`
%define sys_write 0x04 ; sys_write function number See `man 2 write`
;---------------------------------------------------------------------------------
; Files       | Number which are used for file descriptors.
;             |
%define STDIN     0x00 ; Standard input  buffer is 0, when using sys_* functions.
%define STDOUT    0x01 ; Standard output buffer is 1, when using sys_* functions.
;---------------------------------------------------------------------------------
; Interrupts  | Numbers which are used for interrupts.
;             |
%define Kernel    0x80 ; Interrupt number for the Linux kernel.
;=================================================================================

;--------------------------------- Text Section ----------------------------------
;               This Section is where the assembly code for the program is
;               written.
section .text
  global main           ; Allows the linker to 'see' our Main label.

; Main ---------------------------------------------------------------------------
;               Main is the entry point into our calculator application, these
;               Lines will get executed first
main:
    ; This section displays a prompt for our user to enter in a operation for our
    ; calculator to use.
    mov  edx, OpAskLen  ; Load the length of the message we are prompting to the
                        ; user.
    mov  ecx, OpAsk     ; Pointer to the start of the message.
    call Display        ; Display our string, See below for implementation.
    
    ; Read in the users input and store the value into the variable OpIn.
    mov  ecx, OpIn      ; Load the pointer to the OpIn variable.
    call Input          ; Go grab the input, See below for implementation.
    
    ; Make sure we exit cleanly
    call Exit           ;  Exit the application with the code 0

; Exit ---------------------------------------------------------------------------
;               Exit is the code that exits the application safely, this
;               calculator is dumb and always exits with the 0 (no error) error
;               code.
Exit: 
    xor ebx, ebx        ; XOR the ebx register with itself, effectively setting it
                        ; to 0.
                        ; If you have the binary string 0101 and you execute 
                        ; 0101 XOR 0101 you will get 0, because an XOR gate will
                        ; only return a 1 if the gates inputs are different.
    mov eax, sys_exit   ; Use the sys_exit system call from the kernel.
    int Kernel          ; Interrupt to call the Linux kernel.
    ret 0x00            ; Return - Should never reach here but as good practice.

; Display ------------------------------------------------------------------------
;               Display is a section which displays the text to STDOUT using the
;               sys_write function. The call uses the string pointed to by the 
;               ECX register, we do not have to worry about iterating over each
;               character because the sys_write function handles this for us.
;               The size of the string to output is stored in the EDX register.
Display: 
    mov ebx, STDOUT     ; Send the string to standard output.
    mov eax, sys_write  ; We want to use the sys_write Linux function.
    int Kernel          ; Call the Linux kernel
    ret 0               ; Return to the section of code that called us.

; Input --------------------------------------------------------------------------
;               Get the input from the user using standard input, the ASCII code
;               for the input is stored in *FIXME*. This particular code only 
;               grabs a character.
Input: 
    mov ebx, STDIN      ; Read from standard input.
    mov edx, 1          ; Read a character.
    mov eax, sys_read   ; Use the sys_read Linux function.
    int Kernel          ; Call the Linux kernel
    ret 0               ; Return to the section of code that called us.

;--------------------------------- Data Section ---------------------------------
;               Constant values which do not change during the execution of the
;               program.
section .data 
    ; String Asks the user to enter an operation
    OpAsk    db  'Enter an Operation: ' 
    OpAskLen equ $ - OpAsk ; Length of the text

;--------------------------------- BSS Section ----------------------------------
;               Variables which have not yet been assigned a value memory is only
;               allocated.
section .bss
    OpIn     resb 1     ; Reserve a Byte for the operation that the user entered
