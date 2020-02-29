.cpu "65816"


;-------------------------------------------------------------------------------
;
;
;
;-------------------------------------------------------------------------------
FAT_32_test_fat_code
                  PHX
                  PHA
                  LDA #$0000
                  STA FAT32_FAT_Entry
                  LDA #$D4F8
                  STA FAT32_FAT_Entry

                  ;----- debug -----

                  LDX #<>TEXT_FAT32___FAT_Entry
                  LDA #`TEXT_FAT32___FAT_Entry
                  JSL IPUTS_ABS       ; print the first line
                  LDA #$BD
                  JSL SET_COLOUR
                  LDA FAT32_FAT_Entry+2
                  XBA
                  JSL IPRINT_HEX
                  XBA
                  JSL IPRINT_HEX
                  LDA FAT32_FAT_Entry
                  XBA
                  JSL IPRINT_HEX
                  XBA
                  JSL IPRINT_HEX
                  LDA #$ED                  ; Set the default text color to light gray on dark gray
                  JSL SET_COLOUR

                  LDA #$0D
                  JSL IPUTC
                  LDX #<>TEXT_FAT32___FAT_Next_Entry
                  LDA #`TEXT_FAT32___FAT_Next_Entry
                  JSL IPUTS_ABS       ; print the first line
                  LDA #$BD
                  JSL SET_COLOUR
                  LDA FAT32_FAT_Next_Entry+2
                  XBA
                  JSL IPRINT_HEX
                  XBA
                  JSL IPRINT_HEX
                  LDA FAT32_FAT_Next_Entry
                  XBA
                  JSL IPRINT_HEX
                  XBA
                  JSL IPRINT_HEX
                  LDA #$ED                  ; Set the default text color to light gray on dark gray
                  JSL SET_COLOUR

                  LDA #$0D
                  JSL IPUTC

                  jSL FAT32_IFAT_GET_FAT_ENTRY

                  LDX #<>TEXT_FAT32___FAT_Next_Entry
                  LDA #`TEXT_FAT32___FAT_Next_Entry
                  JSL IPUTS_ABS       ; print the first line
                  LDA #$BD
                  JSL SET_COLOUR
                  LDA FAT32_FAT_Next_Entry+2
                  XBA
                  JSL IPRINT_HEX
                  XBA
                  JSL IPRINT_HEX
                  LDA FAT32_FAT_Next_Entry
                  XBA
                  JSL IPRINT_HEX
                  XBA
                  JSL IPRINT_HEX
                  LDA #$ED                  ; Set the default text color to light gray on dark gray
                  JSL SET_COLOUR

                  LDA #$0D
                  JSL IPUTC
                  PLA
                  PLX
                  RTL

;-------------------------------------------------------------------------------
; Search for the file name in the root directory
; Stack 0-1-3-4 pointer to the file name strings to load
; Stack 5-6-7-8 buffer where to load the file
;-------------------------------------------------------------------------------
FAT32_ILOAD_FILE ; the equivalent of Open + Read in one block
                  JSL IFAT32_READ_BOOT_SECTOR
                  CMP #$0001
                  BEQ ILOAD_FILE_FAT_32_BOOT_SECTOR_PARSING_OK
                  LDA #-1
                  BRA FAT32_ILOAD_FILE_RETURN_ERROR_temp
ILOAD_FILE_FAT_32_BOOT_SECTOR_PARSING_OK
                  JSL IFAT32_COMPUT_ROOT_DIR_POS
                  setaxl
                  LDA #$00 ; sellect the first entry
                  PHA
FAT32_ILOAD_FILE_READ_NEXT_ROOT_ENTRY
                  JSL IFAT32_GET_ROOT_DIRECTORY_ENTRY
                  LDA FAT32_Curent_Directory_entry_value + 11 ; get the flag Byte to test if it a file or a directory
                  AND #$10
                  CMP #$10
                  BNE FAT32_ILOAD_FILE_ENTRY ; if equal we read a directory so just read the next one
;;;;FAT32_ILOAD_FILE_STRING_NOT_MATCHED removed as we still need to test what type of entry it is befor trying to compare the file name
                  PLA   ; get the actual root entry
                  CMP FAT32_Max_Root_Entry ; prevent to loop forever so exit
                  BEQ FAT32_ILOAD_FILE_NO_FILE_MATCHED
                  INC A ; sellect the next root entry
                  PHA   ; save the next root entry to read
                  BRA FAT32_ILOAD_FILE_READ_NEXT_ROOT_ENTRY
FAT32_ILOAD_FILE_ENTRY
                  setaxl
                  PLA   ; get the actual root entry
                  CMP FAT32_Max_Root_Entry ; prevent to loop forever so exit
                  BEQ FAT32_ILOAD_FILE_NO_FILE_MATCHED
                  INC A ; sellect the next root entry in case the file name is wrong
                  PHA   ; save the next root entry to read

                  ; copare the file name we want to load and the root entry file name
                  LDX #-1
                  LDY #-1
FAT32_ILOAD_FILE_CHAR_MATCHING
                  INC X
                  INC Y
                  CPX #11 ; FAT12 file or folder size
                  BEQ FAT32_ILOAD_FILE_STRING_MATCHED
                  LDA (6,S),Y ; load the "y" char file name we want to read
                  CMP FAT32_Curent_Directory_entry_value,X
                  BEQ FAT32_ILOAD_FILE_CHAR_MATCHING
                  BRA FAT32_ILOAD_FILE_READ_NEXT_ROOT_ENTRY ;;; FAT32_ILOAD_FILE_STRING_NOT_MATCHED    emoved as we still need to test what type of entry it is befor trying to compare the file name
FAT32_ILOAD_FILE_NO_FILE_MATCHED
                  PLA
                  LDA #-2
FAT32_ILOAD_FILE_RETURN_ERROR_temp
                  BRA FAT32_ILOAD_FILE_RETURN_ERROR
FAT32_ILOAD_FILE_STRING_MATCHED
                  PLA
                  LDA FAT32_Curent_Directory_entry_value + 26 ; get the first fat entry for the fil from the root directory entry we matched
                  STA FAT32_FAT_Next_Entry

FAT32_ILOAD_FILE_Read_next_sector; read sector function to call there
                  ;LDA #`FAT32_DATA_ADDRESS_BUFFER_512 ; load the byte nb 3 (bank byte)
                  ;PHA
                  ;LDA #<>FAT32_DATA_ADDRESS_BUFFER_512 ; load the low world part of the buffer address
                  ;PHA
                  LDA 10,S ; load the byte nb 3 (bank byte)
                  PHA
                  LDA 12,S ; load the low world part of the buffer address
                  PHA
                  LDA FAT32_FAT_Next_Entry ; sector to read
                  ADC #1+9+9+14 ; skip the reserved sector(MBR?) ,  the 2 fat and the root sector that will need to be computed  acording to the fat position if several partition are in the same hardrive, it for now hardcoded as one partition
                  LDX #0
                  JSL IFAT_READ_SECTOR
                  PLX
                  PLX
                  ; point to the next 512 byte in the buffer
                  LDA 12,S ; load the low world part of the buffer address
                  CLC
                  LDA #0
                  PHA ; save the cpt vale
                  PHA ; save the
FAT32_ILOAD_FILE_Add_More_Sector_Per_Cluster
                  LDA 4,S ; load the Byte per cluster value
                  ADC FAT32_Byte_Per_Sector
                  STA 4,S
                  LDA FAT32_Sector_Per_Cluster
                  CMP 2,S
                  BEQ FAT32_ILOAD_FILE_Read_Next_Data
                  LDA 2,S
                  INC A
                  STA 2,S
                  BRA FAT32_ILOAD_FILE_Add_More_Sector_Per_Cluster
FAT32_ILOAD_FILE_Read_Next_Data
                  PLX ; removing the compter valuer from the stack
                  ;-------------------------------------------------------------
                  ; compute the next buffer address to use to copy file
                  LDA 14,S ; load the low world part of the buffer address
                  CLC
                  ADC 2,S
                  BCC FAT32_ILOAD_FILE_New_Buffer_Address_computed
                  STA 14,S ; Save the low world part of the buffer address
                  LDA 12,S ; load the byte nb 3 (bank byte)
                  ADC #1
                  STA 12,S ; Save the byte nb 3 (bank byte)
FAT32_ILOAD_FILE_New_Buffer_Address_computed
                  PLX ; get the Byte per cluster count out of the stack
                  ;-------------------------------------------------------------
                  LDA FAT32_FAT_Next_Entry ; sector to read
                  JSL FAT32_IFAT_GET_FAT_ENTRY
                  LDA FAT32_FAT_Next_Entry
                  CMP #$FFE
                  BCS FAT32_ILOAD_FILE_END_OF_FILE
                  BRA FAT32_ILOAD_FILE_Read_next_sector
FAT32_ILOAD_FILE_END_OF_FILE
FAT32_ILOAD_FILE_RETURN_ERROR
                  RTL

;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------

FOENIX_SD_INIT_READ
                LDA #$01
                STA SDC_TRANS_TYPE_REG  ; Set Init SD

                LDA #$01
                STA SDC_TRANS_CONTROL_REG ; Let's Start the Process

 SDC_NOT_FINISHED
                LDA SDC_TRANS_STATUS_REG
                AND #SDC_TRANS_BUSY
                CMP #SDC_TRANS_BUSY
                BEQ SDC_NOT_FINISHED
                LDA SDC_TRANS_ERROR_REG
                STA $001000
                ;JSL IPRINT_HEX
                CMP #$00
                BNE SDISREADY
                LDA GABE_MSTR_CTRL
                AND #~GABE_CTRL_SDC_LED
                ORA GABE_CTRL_SDC_LED
                STA GABE_MSTR_CTRL

 SDISREADY
                LDA #$00
                STA SDC_SD_ADDR_7_0_REG
                LDA #$00
                STA SDC_SD_ADDR_15_8_REG
                LDA #$00
                STA SDC_SD_ADDR_23_16_REG
                LDA #$00
                STA SDC_SD_ADDR_31_24_REG

                LDA #SDC_TRANS_READ_BLK
                STA SDC_TRANS_TYPE_REG

                LDA #$01
                STA SDC_TRANS_CONTROL_REG ; Let's Start the Process

 SDC_NOT_FINISHED2
                LDA SDC_TRANS_STATUS_REG
                AND #SDC_TRANS_BUSY
                CMP #SDC_TRANS_BUSY
                BEQ SDC_NOT_FINISHED2

                LDA SDC_TRANS_ERROR_REG
                STA $001001

                LDA SDC_RX_FIFO_DATA_CNT_LO
                STA $001002
                ;JSL IPRINT_HEX
                LDA SDC_RX_FIFO_DATA_CNT_HI
                STA $001003
                ;JSL IPRINT_HEX
                ;LDA #$0D
                ;JSL IPUTC
                LDX #$0000
                ;LDA #$0D
                ;JSL IPUTC
 SDC_LOAD_BLOCK
                LDA SDC_RX_FIFO_DATA_REG
                ;JSL IPRINT_HEX
                ;STA SD_BLK_BEGIN, X
                INX
                CPX #$0200
                BNE SDC_LOAD_BLOCK
                RTL
