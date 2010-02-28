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
;             Allocate memory for a variable, Input is EBX -> size to allocate,   `
;             ECX -> Protection flags (see `man 2 mmap`), EDX -> Visibility Flags |
;             (see `man 2 mmap`). Pointer to the memory address will be stored in |
;             EBX on return.                                                      |
Alloc:
    mov  [mmapLen],  ebx; Store the length of memory to allocate
    mov  [mmapProt], ecx; Store the protection flags
    mov  [mmapFlags],edx; Store the visibility flags 
    
    mov  ebx,       0x00; Set our address to NULL we want to be given an address.
    mov  [mmapAddr],ebx ; ^^
    mov  [mmapFd],  ebx ; Set our file descriptor to NULL
    mov  [mmapOff], ebx ; Set our offset to NULL
    
    mov  ebx,[mmapAddr] ; Point our function to our arguments
    
    push eax            ; Push eax onto the stack so we can restore it later

    mov  eax, sys_mmap  ; Set our system call number in eax
    int  kernel         ; Call the kernel
    ;; FIXME: Handle error
    mov  ebx, eax       ; Store our pointer into ebx
    pop  eax            ; Pop our stored value of eax into eax

;--------------------------------- BSS Section ----------------------------------
;               Variables which have not yet been assigned a value memory is     `
;               only allocated.                                                  |
section .bss
  ; Variables for the mmap function call `man 2 mmap`
  mmapAddr   resw 1     ; Address to allocate memory to
  mmapLen    resw 1     ; Size to allocate
  mmapProt   resw 1     ; Protection flags for the memory
  mmapFlags  resw 1     ; Visibility flags for the memory
  mmapFd     resw 1     ; File descriptor
  mmapOff    resw 1     ; Memory Offset
