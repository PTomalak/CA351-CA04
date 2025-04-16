; fibb.asm - Compute and print the first 13 Fibonacci numbers (8-bit arithmetic)    
; Using F(1)=1, F(2)=1, compute further values until the 13th Fibonacci number.     
; Each Fibonacci number is printed on its own line.                                 
;                                                                                   
; Macros from macros.inc:                                                            
.macro lsrn    Oper, Count                                                          
    .repeat Count                                                                   
        lsr Oper                                                                    
    .endrepeat
.endmacro

.macro printbitn   Val, N
    lda Val
    lsrn A, N
    and #1
    clc
    adc #'0'
    printchar
.endmacro

printflags_opcode = $32
getnum_opcode     = $52
printnum_opcode   = $72
getchar_opcode    = $92
printchar_opcode  = $B2
endprog_opcode    = $D2

.macro printflags character
  .byte printflags_opcode
.endmacro
.macro getnum character
  .byte getnum_opcode
.endmacro
.macro printnum character
  .byte printnum_opcode
.endmacro
.macro getchar character
  .byte getchar_opcode
.endmacro
.macro printchar character
  .byte printchar_opcode
.endmacro
.macro endprog
  .byte endprog_opcode
.endmacro

        .org $0801

start:
        ; Initialize Fibonacci numbers: f1 = 1, f2 = 1
        LDA #$01
        STA f1
        LDA #$01
        STA f2

        ; Print the first Fibonacci number:
        LDA f1
        printnum          ; Print f1
        LDA #$0A          ; Newline character (LF)
        printchar

        ; Print the second Fibonacci number:
        LDA f2
        printnum          ; Print f2
        LDA #$0A
        printchar

        ; Set loop counter to 11 (we already printed 2; 11 more yields 13 numbers)
        LDA #$0B          ; 11 in decimal
        STA counter

fib_loop:
        ; Compute next Fibonacci: next = f1 + f2 (8-bit addition)
        LDA f1
        CLC
        ADC f2
        STA temp

        ; Update: f1 = f2, f2 = temp
        LDA f2
        STA f1
        LDA temp
        STA f2

        ; Print the new Fibonacci number (f2) followed by a newline.
        LDA f2
        printnum
        LDA #$0A
        printchar

        DEC counter
        BNE fib_loop

        endprog           ; End the program

;-------------------------
; Data Storage
;-------------------------
f1:      .res 1      ; Previous Fibonacci number
f2:      .res 1      ; Current Fibonacci number
temp:    .res 1      ; Temporary storage for the computed sum
counter: .res 1      ; Loop counter

        .end
