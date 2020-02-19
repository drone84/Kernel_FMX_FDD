.cpu "65816"
;-------------------------------------------------------------------------------
;----------- comput the real sector ofset of the curent fat entry --------------
;-------------------------------------------------------------------------------
FAT32_COMPUT_PHISICAL_CLUSTER
                  PHA
                  ; first operand
                  LDA FAT32_FAT_Entry ;
                  STA ADDER_A
                  LDA FAT32_FAT_Entry+2
                  STA ADDER_A+2
                  ; second operand Fat data location
                  LDA FAT32_Root_Base_Sector ; 32 byte number
                  STA ADDER_B
                  LDA FAT32_Root_Base_Sector+2
                  STA ADDER_B+2
                  ;------ remove 2 sector as the all fat is ofseted  ---------
                  ; first operand
                  LDA ADDER_R+2 ;
                  STA ADDER_A+2
                  LDA ADDER_R
                  STA ADDER_A
                  ; second operand remover 2 (comp2 2 => FFFFFFFE)
                  LDA #$FFFE
                  STA ADDER_B
                  LDA #$FFFF
                  STA ADDER_B+2

                  ; get the final result out of the hardware
                  LDA ADDER_R;
                  STA FAT32_FAT_Entry_PhisicalL_Address
                  LDA ADDER_R+2
                  STA FAT32_FAT_Entry_PhisicalL_Address+2
                  PLA
                  RTL

;-------------------------------------------------------------------------------
;------------ comput the real sector ofset of the next fat entry ---------------
;-------------------------------------------------------------------------------
FAT32_COMPUT_PHISICAL_CLUSTER_NEXT
                  PHA
                  ; first operand
                  LDA FAT32_FAT_Next_Entry ;
                  STA ADDER_A
                  LDA FAT32_FAT_Next_Entry+2
                  STA ADDER_A+2
                  ; second operand Fat data location
                  LDA FAT32_Root_Base_Sector ; 32 byte number
                  STA ADDER_B
                  LDA FAT32_Root_Base_Sector+2
                  STA ADDER_B+2
                  ;------ remove 2 sector as the all fat is ofseted  ---------
                  ; first operand
                  LDA ADDER_R+2 ;
                  STA ADDER_A+2
                  LDA ADDER_R
                  STA ADDER_A
                  ; second operand remover 2 (comp2 2 => FFFFFFFE)
                  LDA #$FFFE
                  STA ADDER_B
                  LDA #$FFFF
                  STA ADDER_B+2

                  ; get the final result out of the hardware
                  LDA ADDER_R;
                  STA FAT32_FAT_Entry_PhisicalL_Address_next
                  LDA ADDER_R+2
                  STA FAT32_FAT_Entry_PhisicalL_Address_next+2
                  PLA
                  RTL
;-------------------------------------------------------------------------------
;
; Test if the content of FAT32_FAT_Next_Entry is a usable sector o r not
;
; return value :
;  0  =>  sector contain valid data
; -1  =>  end of the file, no more sector
; -2  =>  bad sector
; -3  =>  reserved sector
;-------------------------------------------------------------------------------
FAT32_Test_Fat_Entry_Validity_Next
                  ;PLA
                  LDA FAT32_FAT_Next_Entry +2 ; test for EOC (End Of Cluster)
                  AND #$0FFF ; the 4 MSB are not used in the FAT32
                  CMP #$0FFF
                  BNE FAT32_Test_Fat_Entry_Validity_Next___TEST_NULL_VALUE
                  LDA FAT32_FAT_Next_Entry ; test for EOC (End Of Cluster)
                  AND #$FFF0
                  CMP #$FFF0
                  BNE FAT32_Test_Fat_Entry_Validity_Next___TEST_NULL_VALUE
                  ;------------------------------------------------------
                  ; if reach there entry = 0xXFFFFFFX
                  LDA FAT32_FAT_Next_Entry ; the cluster entry is not usable or its the last in the chaine
                  AND #$000F
                  CMP #8
                  BMI FAT32_Test_Fat_Entry_Validity_Next___NEXT_CLUSTER_RESERVED_OR_BAD
                  LDA #-1 ; end of the file
                  BRA FAT32_Test_Fat_Entry_Validity_Next_ERROR_EXIT
FAT32_Test_Fat_Entry_Validity_Next___NEXT_CLUSTER_RESERVED_OR_BAD
                  CMP #7
                  BNE FAT32_Test_Fat_Entry_Validity_Next___NEXT_CLUSTER_RESERVED
                  LDA #-2 ; Bad sector
                  BRA FAT32_Test_Fat_Entry_Validity_Next_ERROR_EXIT
FAT32_Test_Fat_Entry_Validity_Next___NEXT_CLUSTER_RESERVED
                  LDA #-3 ; reserved sector
                  BRA FAT32_Test_Fat_Entry_Validity_Next_ERROR_EXIT
                  ;------------------------------------------------------
                  ; if  jump here, the cluster is at lest not reserved or bad
FAT32_Test_Fat_Entry_Validity_Next___TEST_NULL_VALUE
                  LDA FAT32_FAT_Next_Entry ; test for EOC (End Of Cluster)
                  CMP #0
                  BNE FAT32_Test_Fat_Entry_Validity_Next___EXIT
                  LDA FAT32_FAT_Next_Entry + 2 ; test for EOC (End Of Cluster)
                  CMP #0
                  BNE FAT32_Test_Fat_Entry_Validity_Next___EXIT
                  LDA #-4 ; empty sector
                  BRA FAT32_Test_Fat_Entry_Validity_Next_ERROR_EXIT
FAT32_Test_Fat_Entry_Validity_Next___EXIT:
                  LDA #1
FAT32_Test_Fat_Entry_Validity_Next_ERROR_EXIT:
                  ;PHA
                  RTL
;-------------------------------------------------------------
;-------------------------------------------------------------------------------
;
; Test if the content of FAT32_FAT_Next_Entry is a usable sector o r not
;
; return value :
;  0  =>  sector contain valid data
; -1  =>  end of the file, no more sector
; -2  =>  bad sector
; -3  =>  reserved sector
;-------------------------------------------------------------------------------
FAT32_Test_Fat_Entry_Validity
                  ;PHA
                  LDA FAT32_FAT_Entry +2 ; test for EOC (End Of Cluster)
                  AND #$0FFF ; the 4 MSB are not used in the FAT32
                  CMP #$0FFF
                  BNE FAT32_Test_Fat_Entry_Validity___TEST_NULL_VALUE
                  LDA FAT32_FAT_Entry ; test for EOC (End Of Cluster)
                  AND #$FFF0
                  CMP #$FFF0
                  BNE FAT32_Test_Fat_Entry_Validity___TEST_NULL_VALUE
                  ;------------------------------------------------------
                  ; if reach there entry = 0xXFFFFFFX
                  LDA FAT32_FAT_Entry ; the cluster entry is not usable or its the last in the chaine
                  AND #$000F
                  CMP #8
                  BMI FAT32_Test_Fat_Entry_Validity___NEXT_CLUSTER_RESERVED_OR_BAD
                  LDA #-1 ; end of the file
                  BRL FAT32_Test_Fat_Entry_Validity_ERROR_EXIT
                  FAT32_Test_Fat_Entry_Validity___NEXT_CLUSTER_RESERVED_OR_BAD
                  CMP #7
                  BNE FAT32_Test_Fat_Entry_Validity___NEXT_CLUSTER_RESERVED
                  LDA #-2 ; Bad sector
                  BRL FAT32_Test_Fat_Entry_Validity_ERROR_EXIT
                  FAT32_Test_Fat_Entry_Validity___NEXT_CLUSTER_RESERVED
                  LDA #-3 ; reserved sector
                  BRL FAT32_Test_Fat_Entry_Validity_ERROR_EXIT
                  ;------------------------------------------------------
                  ; if  jump here, the cluster is at lest not reserved or bad
                  FAT32_Test_Fat_Entry_Validity___TEST_NULL_VALUE
                  LDA FAT32_FAT_Entry ; test for EOC (End Of Cluster)
                  CMP #0
                  BNE FAT32_Test_Fat_Entry_Validity___EXIT
                  LDA FAT32_FAT_Entry + 2 ; test for EOC (End Of Cluster)
                  CMP #0
                  BNE FAT32_Test_Fat_Entry_Validity___EXIT
                  LDA #-4 ; empty sector
                  BRL FAT32_Test_Fat_Entry_Validity_ERROR_EXIT
                  FAT32_Test_Fat_Entry_Validity___EXIT:
                  LDA #1
                  FAT32_Test_Fat_Entry_Validity_ERROR_EXIT:
                  ;PLA
PHX
PHA
BRA _TEST_TEXT_8
_text_8 .text "---- Entry validity ",0
_TEST_TEXT_8:
LDX #<>_text_8
LDA #`_text_8
JSL IPUTS_ABS
LDA FAT32_FAT_Entry +2 ; test for EOC (End Of Cluster)
XBA
JSL IPRINT_HEX
XBA
JSL IPRINT_HEX
LDA FAT32_FAT_Entry ; test for EOC (End Of Cluster)
XBA
JSL IPRINT_HEX
XBA
JSL IPRINT_HEX
LDA #$00
JSL IPUTC
PLA
PHA
XBA
JSL IPRINT_HEX
XBA
JSL IPRINT_HEX
LDA #$0D
JSL IPUTC
PLA
PLX
                  RTL
                  ;-------------------------------------------------------------
