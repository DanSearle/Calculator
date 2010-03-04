;=================================================================================
; Strings     | Library to handle strings.                                       ;
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
; StrLen -------------------------------------------------------------------------
;               Get the length of a string. EDI -> pointer to the start of the    `
;               string, Returns ECX -> Size of the string.                        |
;               *WARNING*, the pointer at EDI is destroyed.                       |
StrLen:
    xor  ecx, ecx       ; Clear ECX
    not  ecx            ; Make ECX -1
    xor  al, al         ; Clear al
    cld                 ; Clear the flag registers
    repne scasb         ; Repeat the execution of the scasb function while CX != 0
                        ; and the Zero flag is clear. The scasb string function
                        ; Compares the value in al to the value at the memory
                        ; locatiion given at EDI.
    not  ecx            ; Invert the result
    sub  ecx, 1         ; Minus 1 from the result
    ret 0
