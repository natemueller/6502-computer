  .org $8000

main:
  lda #<message
  sta $0000
  lda #>message
  sta $0001
  jsr NATEOS_PRINT

  wai

message: .asciiz "Hello, world!"

os: .include "nateos.s"
