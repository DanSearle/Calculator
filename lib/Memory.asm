;=================================================================================
; Memory      | Manage memory for variables.                                     ;
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

; Alloc --------------------------------------------------------------------------
;             Allocate memory for a variable, Input is ECX -> size to allocate,   `
;             EDX -> Protection flags (see `man 2 mmap`), ESI -> Visibility Flags |
;             (see `man 2 mmap`). Pointer to the memory address will be stored in |
;             ECX on return.                                                      |
Alloc:
    push ebx
    push eax
    mov  eax, sys_mmap2 ; MMAP2 system call
    mov  ebx, 0x00      ; Address = NULL
    mov  edi, 0x00      ; File Descriptor = 0
    int  kernel         ; Call the kernel
    ;; FIXME: Handle error
    mov  ecx, eax       ; Move the allocated memory into ecx
    pop  eax            ; Pop our stored value of eax into eax
    pop  ebx            ; Pop our stored value of ebx into ebx
    ret  0              ; Return
; UnAlloc ------------------------------------------------------------------------
;             Free memory for a variable so it can be used by another process.    `
;             Input is EBX -> Start address to free, ECX -> Length to free.       |
UnAlloc:
    push eax            ; Save eax to the stack before we change it
    mov  eax, sys_munmap; MUNMAP systen call
    int  kernel         ; Call the kernel
    ;; FIXME: Handle error
    pop  eax            ; Restore eax
    ret  0              ; Return
