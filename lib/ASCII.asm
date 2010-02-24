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


; ConvNoToASCII -----------------------------------------------------------------
;               Converts a number into its ASCII representation, by adding 0x30  `
;               to the number. Input number to EAX and Output value to EAX       |
ConvNoToASCII:
    add eax, 0x30
    ret 0
; ConvASCIIToNo -----------------------------------------------------------------
;               Converts a ASCII value of a number into the actual number, by    `
;               subtracting 0x30 from the number. Input value to EAX and Output  | 
;               number to EAX.                                                   | 
ConvASCIIToNo:
    sub eax, 0x30       ; Subtract 0x30 from eax to get the actual number 
    ret 0               ; Return to who called us

