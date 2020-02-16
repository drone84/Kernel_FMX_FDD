                ; code to place right after : 
				; 'JSL ICOLORFLAG 
                ; setdp 0	'
				
				LDA #$4D                  ; Set the default text color to light gray on dark gray
                STA @l CURCOLOR
                LDX 0
Loop_text:
                LDA #$5544
                XBA
                JSL IPUTC
                XBA
                JSL IPUTC
                LDA #$4455
                XBA
                JSL IPUTC
                XBA
                JSL IPUTC
                INX
                CPX #$65
                BNE Loop_text
                LDA #$FD                  ; Set the default text color to light gray on dark gray
                STA @l CURCOLOR
                ;----- got the r in default grey color and get the first char of the previous line in white ------
                LDA #$0D
                JSL IPUTC
                LDA #$FD                  ; Set the default text color to light gray on dark gray
                STA @l CURCOLOR
                lda #'r'
                JSL IPUTC
                ;----- got the 2 first r in default grey color and get the first char of the previous line in green ------
                ;LDA #$0D
                ;JSL IPUTC
                ;LDA #$FD                  ; Set the default text color to light gray on dark gray
                ;STA @l CURCOLOR
                ;lda #'r'
                ;JSL IPUTC
                ;LDA #$2D                  ; Set the default text color to light gray on dark gray
                ;STA @l CURCOLOR
                ;lda #'r'
                ;JSL IPUTC
                ;lda #'r'
                ;JSL IPUTC
                ;----- work as expected------
                ; get the first char of the line and the r with the new colour
                ;lda #'r'
                ;JSL IPUTC
                ;LDA #$0D
                ;JSL IPUTC
                ;----- work as expected------
                ;LDA #$0D
                ;JSL IPUTC
                ;lda #'r'
                ;JSL IPUTC
  test_end_loop              BRL test_end_loop