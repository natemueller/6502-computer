# 6502 Computer

[Ben Eater's 6502 computer](https://eater.net/6502) with enhanced I/O
and something approaching an OS.  My goal is to prove out these
enhancements before trying to build a 65C816 successor.

## Video modes

4k of video memory.  640x480 native resolution.  Either 40x30
character mode, 80x60 character mode or 80x60 graphics mode.  It would
be cool to do colored character mode, but save that for later.

## Keyboard input

PS/2 keyboard with hardware decoding.  Shift register and 4-bit
counter.  Serial data frame is 11 bits long, and then the host should
hold the clock low to block until the 8 data bits are read by the CPU.
Needs a 10-bit shift register and some inverters.  No parity checks.

## Storage

Interface for reading larger (like 4k) pages into RAM from some
external 1MB flash module.

## Software

Basic OS to handle I/O.  Reading from the keyboard and populating an
input buffer, printing, filesystem management, that sort of thing.

I originally wanted to use software interrupts to implement a syscall
interface but that proved to be more of a mess than I hoped.  It's
doable, but limitations in the 6502 addressing modes make it
inefficient.  There's also really no point, since I have no plans to
add virtual memory.  Instead, you jump to well-known addresses and use
$0000 - $000f for arguments.

## Memory map

| Address | Usage              |
|---------|--------------------|
| $0000   | Syscall Parameters |
| $000f   |                    |
|---------|--------------------|
| $0010   | RAM                |
| $00ff   |                    |
|---------|--------------------|
| $0100   | Stack              |
| $01ff   |                    |
|---------|--------------------|
| $0200   | RAM                |
| $3fff   |                    |
|---------|--------------------|
| $4000   | Not Wired          |
| $5fff   |                    |
|---------|--------------------|
| $6000   | WD65C2             |
| $7fff   |                    |
|---------|--------------------|
| $8000   | ROM                |
| $ffff   |                    |
|---------|--------------------|

## Build ROM image

```bash
docker build -t 6502-build .
docker run --rm -v $PWD:/project -w /project 6502-build -Fbin -dotdir -wdc02 -o hello-world.bin software/hello-world.s
minipro -p AT28C256 -w hello-world.bin
```
