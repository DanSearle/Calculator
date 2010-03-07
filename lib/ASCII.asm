;=================================================================================
; ASCII       | A library to to help with the conversion between ASCII.          ;
;---------------------------------------------------------------------------------
;                                                                                ;
; Provides functions in order to convert characters to/from ASCII.               ;
;                                                                                ;
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
section .text

; ConvNoToASCII -----------------------------------------------------------------
;               Converts a number into its ASCII representation, by adding 0x30  `
;               to the number. Input number to AL and Output value to AL         |
ConvNoToASCII:
    add al, 0x30
    ret 0

; ConvASCIIToNo -----------------------------------------------------------------
;               Converts a ASCII value of a number into the actual number, by    `
;               subtracting 0x30 from the number. Input value to AL and Output   | 
;               number to AL.                                                    | 
ConvASCIIToNo:
    sub al , 0x30       ; Subtract 0x30 from eax to get the actual number 
    ret 0               ; Return to who called us

; TestASCIINumber ---------------------------------------------------------------
;               Tests that the value in AL is a valid ASCII number.              `
;               Unsets the carry flag on valid sets it on invalid.               |
TestASCIINumber:
    cmp al, 0x30        ; ASCII value should not be below 0x30 Number 0.
    jb  .invalid        ; Jump to the invaild label if the number is not valid.
    cmp al, 0x39        ; ASCII value should not be below 0x39 Number 9.
    ja  .invalid        ; Jump to the invaild label if the number is not valid.
    CLC                 ; Clear the carry flag.
    ret 0               ; Return if the number was valid.
  .invalid:             ; Invalid ascii number.
    STC                 ; Set the carry flag.
    ret 0 
; TestASCIINumberString ---------------------------------------------------------
;               Test if a ASCII string is all numbers.                           `
;               Input -> EAX - Length of the string, EBX -> Start of the string. |
;               Output -> Sets the carry flag if anything in the string is       |
;               invalid.                                                         |
TestASCIINumberString:
    push ecx
    push edx
    xor  ecx, ecx
    mov  edx, eax       ; Use EDX for the length because we will over write EAX
  .next:
    mov  al, [ebx+ecx]
    call TestASCIINumber
    jc   .invalid
    inc  ecx
    cmp  ecx, edx
    jne  .next
    jmp  .exit
  .invalid:
    jmp  .exit
  .exit:
    pop  edx
    pop  ecx
    ret  0
; ASCIItoBCD --------------------------------------------------------------------
;               Converts an ASCII string to a BCD string.                        `
;               Input -> EAX - Length of the string, EBX - Start of the string,  |
;               EDX - Where to save the BCD string. Output -> The BCD string in  | 
;               the specified place. Carry flag set on error.                    |
ASCIItoBCD:
    push ecx            ; Push ECX onto the stack.
    xor  ecx, ecx       ; Clear ECX.
  .next:                ; Move onto the next character.
    mov  al, [ebx+ecx]  ; Copy the current ASCII character into AL.
    call TestASCIINumber; Test that the ASCII character is a number.
    jc   .exit          ; Jump to the error portion if the test failed.
    call ConvASCIIToNo  ; Convert the ASCII to a number.
    mov  [edx+ecx], al  ; Store the converted value.
    inc  ecx            ; Move onto the next character.
    cmp  ecx, eax       ; Make sure we are not at the end of the string.
    jne  .next          ; Continue if the end has not been met.
  .exit:
    pop  ecx            ; Pop ECX off of the stack.
    ret  0              ; Return.
