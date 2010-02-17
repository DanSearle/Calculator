section .text
  global main ; Define our entry point to the linker

;; TODO use constants
main: ;; Entry point
  ;; Ask the user for a operation
  mov  edx, oplen ; Message Length
  mov  ecx, op    ; Message to write
  call display    ; Display the message
  mov  ecx, operation ; Read into the operation byte
  call input      ; Get the Operation input
  mov  edx, 1     ; Length of the operation
  call display
  call exit       ; Exit the app

exit: ;; Exit the program safely
  mov eax, 1   ; System call number 1 = sys_exit
  int 0x80     ; Call the kernel from a interrupt
  ret 0        ; Return to where we got called from

display: ;; Display text that is in the ecx register with a length of edx
  mov ebx, 1    ; Send to STDOUT
  mov eax, 0x04 ; Call sys_write
  int 0x80      ; Call the kernel interrupt
  ret 0         ; Return to where we got called from

input: ;; Get the input
  mov ebx, 0    ; Read STDIN
  mov edx, 1    ; Read one character
  mov eax, 0x03 ; Call sys_read
  int 0x80      ; Call the kernel
  ret 0         ; Return

section .data ; Data section
  ;; Ask for a operation string
  op    db  'Enter a Operation: '
  oplen equ $ - op
section .bss ; 'Variable Section'
  operation resb 1 ; Reserve a byte for the operation
