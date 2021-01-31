  .org $8000

main:
  lda #<message
  sta SYSCALL_ARG0
  lda #>message
  sta SYSCALL_ARG1
  jsr NATEOS_PRINT

  wai

message: .asciiz "Hello, world!"

os: .include "nateos.s"
