section .text
  global main ; Define our entry point to the linker
;; Todo use constants
main: ;; Entry point
  ;; Ask the user for a operation
  mov  edx, oplen ; Message Length
  mov  ecx, op    ; Message to write
  call display    ; Display the message
  call exit       ; Exit the app

exit: ;; Exit the program safely
  mov eax, 1   ; System call number 1 = sys_exit
  int 0x80     ; Call the kernel from a interrupt
  ret 0        ; Return to where we got called from

display: ;; Display text that is in the ecx register with a length of edx
  mov ebx, 1    ; Send to STDOUT
  mov eax, 4    ; Call sys_write
  int 0x80      ; Call the kernel interrupt
  ret 0         ; Return to where we got called from

section .data ; Data section
  ;; Ask for a operation string
  op    db  'Enter a Operation: '
  oplen equ $ - op

