;=================================================================================
; Linux       | Macros to help dealing with the Linux kernel easier, e.g. kernel ;
; Macros      | call numbers, etc.                                               ;
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

; Functions ----------------------------------------------------------------------
;               Numbers of the system calls within the kernel.                    `
%define sys_exit  0x01 ; sys_exit function number see `man 2 exit`
%define sys_read  0x03 ; sys_read function number see `man 2 read`
%define sys_write 0x04 ; sys_write function number see `man 2 write`
%define sys_mmap  0x5A ; sys_mmap function number see `man 2 mmap`
; Files --------------------------------------------------------------------------
;               File descriptors to use.                                          `
%define STDIN     0x00 ; Standard input  buffer is 0, when using sys_* functions.
%define STDOUT    0x01 ; Standard output buffer is 1, when using sys_* functions.
; Interrupts ---------------------------------------------------------------------
;               Interrupts for the linux kernel.                                  `
%define kernel    0x80 ; Interrupt number for the Linux kernel.
