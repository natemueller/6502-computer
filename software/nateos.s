NATEOS_CLEAR = $FF00
NATEOS_PRINT = $FF03

PORTB = $6000
PORTA = $6001
DDRB = $6002
DDRA = $6003

E  = %10000000
RW = %01000000
RS = %00100000

VECTORS = $FFFA

reset:
  ldx #$ff
  txs

  lda #%11111111 ; Set all pins on port B to output
  sta DDRB
  lda #%11100000 ; Set top 3 pins on port A to output
  sta DDRA

  lda #%00111000 ; Set 8-bit mode; 2-line display; 5x8 font
  jsr lcd_instruction
  lda #%00001110 ; Display on; cursor on; blink off
  jsr lcd_instruction
  lda #%00000110 ; Increment and shift cursor; don't shift display
  jsr lcd_instruction
  lda #$00000001 ; Clear display
  jsr lcd_instruction
  jmp main

  ;; print syscall
  ;;   $00/$01 is the MSB/LSB of a null-terminated string
nateos_print:
  pha
  phy

  ldy #00
.print:
  lda ($00),y
  beq .eos
  jsr print_char
  iny
  jmp .print
.eos:
  ply
  pla
  rts

  ;; clear syscall
nateos_clear:
  pha
  lda #$00000001 ; Clear display
  jsr lcd_instruction
  pla
  rts

lcd_wait:
  pha
  lda #%00000000  ; Port B is input
  sta DDRB
.lcdbusy:
  lda #RW
  sta PORTA
  lda #(RW | E)
  sta PORTA
  lda PORTB
  and #%10000000
  bne .lcdbusy

  lda #RW
  sta PORTA
  lda #%11111111  ; Port B is output
  sta DDRB
  pla
  rts

lcd_instruction:
  jsr lcd_wait
  sta PORTB
  lda #0         ; Clear RS/RW/E bits
  sta PORTA
  lda #E         ; Set E bit to send instruction
  sta PORTA
  lda #0         ; Clear RS/RW/E bits
  sta PORTA
  rts

print_char:
  jsr lcd_wait
  sta PORTB
  lda #RS         ; Set RS; Clear RW/E bits
  sta PORTA
  lda #(RS | E)   ; Set E bit to send instruction
  sta PORTA
  lda #RS         ; Clear E bits
  sta PORTA
  rts

  ;; "syscall" jump table
  .org NATEOS_CLEAR
  jmp nateos_clear

  .org NATEOS_PRINT
  jmp nateos_print

  ;; Interrupt vectors
  .org VECTORS
  .word $0000                   ; NMI
  .word reset
  .word $0000                   ; BRK/IRQ
