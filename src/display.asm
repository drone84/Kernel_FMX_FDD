INIT_DISPLAY
                .as
                ; set the display size - 128 x 64
                ;LDA #128
                ;STA COLS_PER_LINE
                ;LDA #64
                ;STA LINES_MAX

                ; set the visible display size - 80 x 60
                ;LDA #80
                ;STA COLS_VISIBLE
                ;LDA #60
                ;STA LINES_VISIBLE
                ;LDA #32
                ;STA BORDER_X_SIZE
                ;STA BORDER_Y_SIZE

                ; set the border to purple
                setas
                ;LDA #$20
                ;STA BORDER_COLOR_B
                ;STA BORDER_COLOR_R
                ;LDA #0
                ;STA BORDER_COLOR_G

                ; diable the border
                LDA #0
                STA BORDER_CTRL_REG

                ; enable graphics, tiles and sprites display
                LDA #Mstr_Ctrl_Graph_Mode_En + Mstr_Ctrl_Bitmap_En; + Mstr_Ctrl_TileMap_En + Mstr_Ctrl_Sprite_En ; + Mstr_Ctrl_Text_Mode_En + Mstr_Ctrl_Text_Overlay
                STA MASTER_CTRL_REG_L

                ; display intro screen
                ; wait for user to press a key or joystick button

                ; load tiles
                ;setaxl
                ;LDX #<>TILES
                ;LDY #0
                ;LDA #$2000 ; 256 * 32 - this is two rows of tiles
                ;MVN <`TILES,$B0

                setaxl
                LDX #<>$0

                LDX #<>$0
                LDA #$0
              erase_Byte_00:
                STA @l $B00000,x
                INX
                CPX #0
                BNE erase_Byte_00
              erase_Byte_01:
                STA @l $B10000,x
                INX
                CPX #0
                BNE erase_Byte_01
              erase_Byte_02:
                STA @l $B20000,x
                INX
                CPX #0
                BNE erase_Byte_02
              erase_Byte_03:
                STA @l $B30000,x
                INX
                CPX #0
                BNE erase_Byte_03
              erase_Byte_04:
                STA @l $B40000,x
                INX
                CPX #0
                BNE erase_Byte_04

                setaxl
                ; load LUT
                LDX #<>PALETTE
                LDY #<>GRPH_LUT0_PTR
                LDA #1024
                MVN <`PALETTE,<`GRPH_LUT0_PTR

                LDX #<>PALETTE
                LDY #<>GRPH_LUT1_PTR
                LDA #1024
                MVN <`PALETTE,<`GRPH_LUT1_PTR

                ;----------------------
                LDX #<>$1B0000
                LDY #<>$B00000
                LDA #$8000
                MVN <`$1B0000,<`$B00000

                LDX #<>$1B0000+$8000
                LDY #<>$B08000
                LDA #$8000
                MVN <`$1B0000,<`$B08000
                ;----------------------
                LDX #<>$1C0000
                LDY #<>$B10000
                LDA #$8000
                MVN <`$1C0000,<`$B10000

                LDX #<>$1C0000+$8000
                LDY #<>$B18000
                LDA #$8000
                MVN <`$1C0000,<`$B18000
                ;----------------------
                LDX #<>$1D0000
                LDY #<>$B20000
                LDA #$8000
                MVN <`$1D0000,<`$B20000

                LDX #<>$1D0000+$8000
                LDY #<>$B28000
                LDA #$8000
                MVN <`$1D0000,<`$B28000
                ;----------------------
                LDX #<>$1E0000
                LDY #<>$B30000
                LDA #$8000
                MVN <`$1E0000,<`$B30000

                LDX #<>$1E0000+$8000
                LDY #<>$B38000
                LDA #$8000
                MVN <`$1E0000,<`$B38000
                ;----------------------
                LDX #<>$1F0000
                LDY #<>$B40000
                LDA #$B000
                MVN <`$1F0000,<`$B40000
                ;----------------------

                setas
                LDA #1+2
                STA @l BM_CONTROL_REG

                LDA #00
                STA @l BM_START_ADDY_L
                STA @l BM_START_ADDY_M
                LDA #00
                STA @l BM_START_ADDY_H

                setal
                LDA #640
                STA @l BM_X_SIZE_L
                LDA #480
                STA @l BM_Y_SIZE_L
                ;setas
                RTS
PALETTE
.binary "assets/halflife.pal"
