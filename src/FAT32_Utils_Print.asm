.cpu "65816"

;-------------------------------------------------------------------------------
FAT32_Print_Cluster_HEX
              LDA #$0D
              JSL IPUTC
              LDY #0
              LDX #0
FAT32_Print_Clusterr_HEX_Byte
              LDA FAT32_DATA_ADDRESS_BUFFER_512,X
              JSL IPRINT_HEX
              LDA #$20
              JSL IPUTC
              INX
              INY
              CPY #$10
              BNE SKIP_CR_HEX
              LDA #$0D
              JSL IPUTC
              LDY #0
SKIP_CR_HEX:
              CPX #512
              BMI FAT32_Print_Clusterr_HEX_Byte
              RTL

;-------------------------------------------------------------------------------
FAT32_Print_Cluster
              LDA #$0D
              JSL IPUTC
              LDY #0
              LDX #0
FAT32_Print_Cluster_Byte
              LDA FAT32_DATA_ADDRESS_BUFFER_512,X
              JSL IPUTC
              INX
              INY
              CPY #$40
              BNE SKIP_CR
              LDA #$0D
              JSL IPUTC
              LDY #0
SKIP_CR:
              CPX #512
              BMI FAT32_Print_Cluster_Byte
              RTL
;-------------------------------------------------------------------------------
Wait_loop:
              PHX
              LDX #1000
              JSL ILOOP_MS
              PLX
              RTL
;-------------------------------------------------------------------------------
FAT32_Print_File_Name
                  PHX
                  PHA
                  LDA FAT32_Curent_Folder_entry_value
                  JSL IPUTC
                  LDA FAT32_Curent_Folder_entry_value +1
                  JSL IPUTC
                  LDA FAT32_Curent_Folder_entry_value +2
                  JSL IPUTC
                  LDA FAT32_Curent_Folder_entry_value +3
                  JSL IPUTC
                  LDA FAT32_Curent_Folder_entry_value +4
                  JSL IPUTC
                  LDA FAT32_Curent_Folder_entry_value +5
                  JSL IPUTC
                  LDA FAT32_Curent_Folder_entry_value +6
                  JSL IPUTC
                  LDA FAT32_Curent_Folder_entry_value +7
                  JSL IPUTC
                  LDA #'.'
                  JSL IPUTC
                  LDA FAT32_Curent_Folder_entry_value +8
                  JSL IPUTC
                  LDA FAT32_Curent_Folder_entry_value +9
                  JSL IPUTC
                  LDA FAT32_Curent_Folder_entry_value +10
                  JSL IPUTC
                  ;LDA #$0D
                  ;JSL IPUTC
                  PLA
                  PLX
                  RTL
;-------------------------------------------------------------------------------
;
; print the folder name from the curent folder entry
;
;-------------------------------------------------------------------------------
FAT32_Print_Folder_Name
                  PHX
                  LDX #0
FAT32_Print_Folder_Name__Print_char:
                  LDA FAT32_Curent_Folder_entry_value,x
                  JSL IPUTC
                  INX
                  CPX #$B
                  BNE FAT32_Print_Folder_Name__Print_char
                  PLX
                  RTL
;-------------------------------------------------------------------------------
;
; display the ROOT entry in hex and in ASCII
;
;-------------------------------------------------------------------------------
FAT32_PRINT_Root_entry_value
                  PHX
                  PHY
                  PHA
                  LDX #0
                  FAT32_PRINT_Root_entry_value_loop_1:
                  LDA @l FAT32_Curent_Folder_entry_value,x
                  JSL IPRINT_HEX
                  INX
                  CPX #32
                  BNE FAT32_PRINT_Root_entry_value_loop_1
                  LDA #$0D
                  JSL IPUTC
                  LDX #0
                  FAT32_PRINT_Root_entry_value_loop_2:
                  LDA @l FAT32_Curent_Folder_entry_value,x
                  JSL IPUTC
                  INX
                  CPX #32
                  BNE FAT32_PRINT_Root_entry_value_loop_2
                  LDA #$0D
                  JSL IPUTC
                  PLA
                  PLY
                  PLX
                  RTL

FAT32_PRINT_Root_entry_value_HEX
                  PHX
                  PHY
                  PHA
                  LDX #0
                  FAT32_PRINT_Root_entry_value_HEX_loop_1:
                  LDA @l FAT32_Curent_Folder_entry_value,x
                  JSL IPRINT_HEX
                  INX
                  CPX #32
                  BNE FAT32_PRINT_Root_entry_value_HEX_loop_1
                  LDA #$0D
                  JSL IPUTC
                  PLA
                  PLY
                  PLX
                  RTL

FAT32_Print_FAT_ENTRY_INFO
                PHP
                PHA
                PHX
                PHY
                LDX #<>TEXT_FAT32___FAT_Entry
                LDA #`TEXT_FAT32___FAT_Entry
                JSL IPUTS_ABS       ; print the first line
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
                LDX #<>TEXT_FAT32___FAT_Next_Entry
                LDA #`TEXT_FAT32___FAT_Next_Entry
                JSL IPUTS_ABS       ; print the first line
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
                ;LDX #<>TEXT_FAT32___FAT_Linked_Entry
                ;LDA #`TEXT_FAT32___FAT_Linked_Entry
                ;JSL IPUTS_ABS       ; print the first line
                ;LDA FAT32_FAT_Linked_Entry+2
                ;XBA
                ;JSL IPRINT_HEX
                ;XBA
                ;JSL IPRINT_HEX
                ;LDA FAT32_FAT_Linked_Entry
                ;XBA
                ;JSL IPRINT_HEX
                ;XBA
                ;JSL IPRINT_HEX
                LDX #<>TEXT_FAT32___FAT32_FAT_Entry_Physical_Address
                LDA #`TEXT_FAT32___FAT32_FAT_Entry_Physical_Address
                JSL IPUTS_ABS       ; print the first line
                LDA FAT32_FAT_Entry_Physical_Address+2
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                LDA FAT32_FAT_Entry_Physical_Address
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                LDA #$0D
                JSL IPUTC
                PLY
                PLX
                PLA
                PLP
                RTL

FAT32_Print_FAT_STATE
                PHP
                PHA
                PHX
                PHY
                LDX #<>TEXT_FAT32___Byte_Per_Sector
                LDA #`TEXT_FAT32___Byte_Per_Sector
                JSL IPUTS_ABS       ; print the first line
                LDA FAT32_Byte_Per_Sector
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                LDX #<>TEXT_FAT32___Sector_Per_Cluster
                LDA #`TEXT_FAT32___Sector_Per_Cluster
                JSL IPUTS_ABS       ; print the first line
                LDA FAT32_Sector_Per_Cluster
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                LDX #<>TEXT_FAT32___Nb_Of_reserved_Cluster
                LDA #`TEXT_FAT32___Nb_Of_reserved_Cluster
                JSL IPUTS_ABS       ; print the first line
                LDA FAT32_Nb_Of_reserved_Cluster
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                LDX #<>TEXT_FAT32___Nb_Of_FAT
                LDA #`TEXT_FAT32___Nb_Of_FAT
                JSL IPUTS_ABS       ; print the first line
                LDA FAT32_Nb_Of_FAT
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                LDX #<>TEXT_FAT32___Max_Root_Entry
                LDA #`TEXT_FAT32___Max_Root_Entry
                JSL IPUTS_ABS       ; print the first line
                LDA FAT32_Max_Root_Entry
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                LDX #<>TEXT_FAT32___Total_Sector_Count
                LDA #`TEXT_FAT32___Total_Sector_Count
                JSL IPUTS_ABS       ; print the first line
                LDA FAT32_Total_Sector_Count
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                LDX #<>TEXT_FAT32___Sector_per_Fat
                LDA #`TEXT_FAT32___Sector_per_Fat
                JSL IPUTS_ABS       ; print the first line
                LDA FAT32_Sector_per_Fat+2
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                LDA FAT32_Sector_per_Fat
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                LDX #<>TEXT_FAT32___Sector_per_Track
                LDA #`TEXT_FAT32___Sector_per_Track
                JSL IPUTS_ABS       ; print the first line
                LDA FAT32_Sector_per_Track
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                LDX #<>TEXT_FAT32___Nb_of_Head
                LDA #`TEXT_FAT32___Nb_of_Head
                JSL IPUTS_ABS       ; print the first line
                LDA FAT32_Nb_of_Head
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                LDX #<>TEXT_FAT32___Nb_Of_Sector_In_Partition
                LDA #`TEXT_FAT32___Nb_Of_Sector_In_Partition
                JSL IPUTS_ABS       ; print the first line
                LDA FAT32_Nb_Of_Sector_In_Partition+2
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                LDA FAT32_Nb_Of_Sector_In_Partition
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                LDX #<>TEXT_FAT32___Boot_Signature
                LDA #`TEXT_FAT32___Boot_Signature
                JSL IPUTS_ABS       ; print the first line
                LDA FAT32_Boot_Signature
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                LDX #<>TEXT_FAT32___Volume_ID
                LDA #`TEXT_FAT32___Volume_ID
                JSL IPUTS_ABS       ; print the first line
                LDA FAT32_Volume_ID+2
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                LDA FAT32_Volume_ID
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                LDX #<>TEXT_FAT32___Volume_Label
                LDA #`TEXT_FAT32___Volume_Label
                JSL IPUTS_ABS       ; print the first line
                LDX #0
PRINT_FAT32_Volume_Label:
                LDA @l FAT32_Volume_Label,x
                JSL IPUTC
                INX
                CPX #11
                BNE PRINT_FAT32_Volume_Label
                LDX #<>TEXT_FAT32___File_System_Type
                LDA #`TEXT_FAT32___File_System_Type
                JSL IPUTS_ABS       ; print the first line
                LDA FAT32_File_System_Type
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                LDX #<>TEXT_FAT32___Sector_loaded_in_ram
                LDA #`TEXT_FAT32___Sector_loaded_in_ram
                JSL IPUTS_ABS       ; print the first line
                LDA FAT32_Sector_loaded_in_ram+2
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                LDA FAT32_Sector_loaded_in_ram
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                LDX #<>TEXT_FAT32___Root_Sector_offset
                LDA #`TEXT_FAT32___Root_Sector_offset
                JSL IPUTS_ABS       ; print the first line
                LDA FAT32_Root_Sector_offset+2
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                LDA FAT32_Root_Sector_offset
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                LDX #<>TEXT_FAT32___Root_Base_Sector
                LDA #`TEXT_FAT32___Root_Base_Sector
                JSL IPUTS_ABS       ; print the first line
                LDA FAT32_Root_Base_Sector+2
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                LDA FAT32_Root_Base_Sector
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                LDX #<>TEXT_FAT32___Curent_Folder_Sector_loaded_in_ram
                LDA #`TEXT_FAT32___Curent_Folder_Sector_loaded_in_ram
                JSL IPUTS_ABS       ; print the first line
                LDA FAT32_Curent_Folder_Sector_loaded_in_ram+2
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                LDA FAT32_Curent_Folder_Sector_loaded_in_ram
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                LDX #<>TEXT_FAT32___Curent_Folder_entry_value
                LDA #`TEXT_FAT32___Curent_Folder_entry_value
                JSL IPUTS_ABS       ; print the first line
                LDA #$0D
                JSL IPUTC
                LDX #0
PRINT_FAT32_Root_entry_value:
                LDA @l FAT32_Curent_Folder_entry_value,x
                JSL IPRINT_HEX
                INX
                CPX #32
                BNE PRINT_FAT32_Root_entry_value
                LDA #$0D
                JSL IPUTC
                LDX #0
PRINT_FAT32_Root_entry_value_ASCII:
                LDA @l FAT32_Curent_Folder_entry_value,x
                JSL IPUTC
                INX
                CPX #32
                BNE PRINT_FAT32_Root_entry_value_ASCII
                LDX #<>TEXT_FAT32___FAT_Base_Sector
                LDA #`TEXT_FAT32___FAT_Base_Sector
                JSL IPUTS_ABS       ; print the first line
                LDA FAT32_FAT_Base_Sector+2
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                LDA FAT32_FAT_Base_Sector
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                LDX #<>TEXT_FAT32___FAT_Sector_loaded_in_ram
                LDA #`TEXT_FAT32___FAT_Sector_loaded_in_ram
                JSL IPUTS_ABS       ; print the first line
                LDA FAT32_FAT_Sector_loaded_in_ram+2
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                LDA FAT32_FAT_Sector_loaded_in_ram
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                LDX #<>TEXT_FAT32___FAT_Entry
                LDA #`TEXT_FAT32___FAT_Entry
                JSL IPUTS_ABS       ; print the first line
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
                LDX #<>TEXT_FAT32___FAT_Next_Entry
                LDA #`TEXT_FAT32___FAT_Next_Entry
                JSL IPUTS_ABS       ; print the first line
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
                LDX #<>TEXT_FAT32___FAT_Linked_Entry
                LDA #`TEXT_FAT32___FAT_Linked_Entry
                JSL IPUTS_ABS       ; print the first line
                LDA FAT32_FAT_Linked_Entry+2
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                LDA FAT32_FAT_Linked_Entry
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                LDX #<>TEXT_FAT32___Data_Base_Sector
                LDA #`TEXT_FAT32___Data_Base_Sector
                JSL IPUTS_ABS       ; print the first line
                LDA FAT32_Data_Base_Sector+2
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                LDA FAT32_Data_Base_Sector
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                LDX #<>TEXT_FAT32___FAT_Partition_address
                LDA #`TEXT_FAT32___FAT_Partition_address
                JSL IPUTS_ABS       ; print the first line
                LDA FAT_Partition_address+2
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                LDA FAT_Partition_address
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                LDX #<>TEXT_FAT32___Curent_Folder_base_cluster
                LDA #`TEXT_FAT32___Curent_Folder_base_cluster
                JSL IPUTS_ABS       ; print the first line
                LDA FAT32_Curent_Folder_base_cluster+2
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                LDA FAT32_Curent_Folder_base_cluster
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                LDX #<>TEXT_FAT32___Curent_Folder_curent_cluster
                LDA #`TEXT_FAT32___Curent_Folder_curent_cluster
                JSL IPUTS_ABS       ; print the first line
                LDA FAT32_Curent_Folder_curent_cluster+2
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                LDA FAT32_Curent_Folder_curent_cluster
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                LDX #<>TEXT_FAT32___Curent_File_Cluster
                LDA #`TEXT_FAT32___Curent_File_Cluster
                JSL IPUTS_ABS       ; print the first line
                LDA FAT32_Curent_File_Cluster+2
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                LDA FAT32_Curent_File_Cluster
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                LDX #<>TEXT_FAT32___FAT32_Start_Of_The_file_Cluster
                LDA #`TEXT_FAT32___FAT32_Start_Of_The_file_Cluster
                JSL IPUTS_ABS       ; print the first line
                LDA FAT32_Start_Of_The_file_Cluster+2
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                LDA FAT32_Start_Of_The_file_Cluster
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                LDX #<>TEXT_FAT32___Sector_to_read
                LDA #`TEXT_FAT32___Sector_to_read
                JSL IPUTS_ABS       ; print the first line
                LDA FAT32_Sector_to_read+2
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                LDA FAT32_Sector_to_read
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                LDX #<>TEXT_FAT32___SD_FDD_HDD_Sell
                LDA #`TEXT_FAT32___SD_FDD_HDD_Sell
                JSL IPUTS_ABS       ; print the first line
                LDA FAT32_SD_FDD_HDD_Sell
                XBA
                JSL IPRINT_HEX
                XBA
                JSL IPRINT_HEX
                PLY
                PLX
                PLA
                PLP
                RTL


;----------------------------------------------------------------------------------------------------------
; EOF
;----------------------------------------------------------------------------------------------------------

* = $20425
Partition_ofset_text    .text "Partition ofset (in cluster) : ",0

TEXT_FAT32___Byte_Per_Sector		         .text   $0D, "FAT32 Byte Per Sector              ",0
TEXT_FAT32___Sector_Per_Cluster          .text   $0D, "FAT32 Sector Per Cluster           ",0
TEXT_FAT32___Nb_Of_reserved_Cluster      .text   $0D, "FAT32 Nb Of reserved Cluster       ",0
TEXT_FAT32___Nb_Of_FAT                   .text   $0D, "FAT32 Nb Of FAT                    ",0
TEXT_FAT32___Max_Root_Entry              .text   $0D, "FAT32 Max Root Entry               ",0
TEXT_FAT32___Total_Sector_Count          .text   $0D, "FAT32 Total_Sector_Count           ",0
TEXT_FAT32___Sector_per_Fat              .text   $0D, "FAT32 Sector per Fat               ",0
TEXT_FAT32___Sector_per_Track            .text   $0D, "FAT32 Sector per Track             ",0
TEXT_FAT32___Nb_of_Head                  .text   $0D, "FAT32 Nb of Head                   ",0
TEXT_FAT32___Nb_Of_Sector_In_Partition   .text   $0D, "FAT32 Nb Of Sector In Partition    ",0
TEXT_FAT32___Boot_Signature              .text   $0D, "FAT32 Boot Signature               ",0
TEXT_FAT32___Volume_ID                   .text   $0D, "FAT32 Volume ID                    ",0
TEXT_FAT32___Volume_Label                .text   $0D, "FAT32 Volume Label                 ",0
TEXT_FAT32___File_System_Type            .text   $0D, "FAT32 File System Type             ",0
TEXT_FAT32___Sector_loaded_in_ram        .text   $0D, "FAT32 Sector loaded in ram         ",0
TEXT_FAT32___Root_Sector_offset          .text   $0D, "FAT32 Root Sector offset           ",0
TEXT_FAT32___Root_Base_Sector            .text   $0D, "FAT32 Root Base Sector             ",0
TEXT_FAT32___Curent_Folder_Sector_loaded_in_ram   .text   $0D, "FAT32 Folder Sector loaded in ram  ",0
TEXT_FAT32___Curent_Folder_entry_value            .text   $0D, "FAT32 Folder entry value            ",0
TEXT_FAT32___FAT_Base_Sector             .text   $0D, "FAT32 FAT Base Sector              ",0
TEXT_FAT32___FAT_Sector_loaded_in_ram    .text   $0D, "FAT32 FAT Sector loaded in ram     ",0
TEXT_FAT32___FAT_Entry                   .text   $0D, "FAT32 FAT Entry                    ",0
TEXT_FAT32___FAT_Next_Entry              .text   $0D, "FAT32 FAT Next Entry               ",0
TEXT_FAT32___FAT_Linked_Entry            .text   $0D, "FAT32 FAT Linked Entry             ",0
TEXT_FAT32___FAT32_FAT_Entry_Physical_Address .text   $0D, "FAT32 FAT Entry Physical Address   ",0
TEXT_FAT32___Data_Base_Sector            .text   $0D, "FAT32 Data Base Sector             ",0
TEXT_FAT32___FAT_Partition_address       .text   $0D, "FAT Partition address              ",0
TEXT_FAT32___Curent_Folder_base_cluster   .text   $0D, "FAT32 Curent Folder base cluster   ",0
TEXT_FAT32___Curent_Folder_curent_cluster .text   $0D, "FAT32 Curent Folder curent cluster ",0
TEXT_FAT32___Curent_File_Cluster    .text   $0D, "FAT32 Curent File base cluster     ",0
TEXT_FAT32___FAT32_Start_Of_The_file_Cluster .text   $0D, "FAT32 Start Of The file cluster    ",0
TEXT_FAT32___Sector_to_read              .text   $0D, "FAT32 Sector to read               ",0
TEXT_FAT32___SD_FDD_HDD_Sell             .text   $0D, "FAT32 SD_FDD_HDD_Sell              ",0
TEXT_____Fat_size                        .text   $0D, "Fat_size                           ",0

TEXT__OPEN_FILE_SUCCESS                   .text "File open Sucsessfuly",$0D,0
TEXT__CANT_FIND_THE_FILE                 .text "Can't find or open the specified file",$0D,0

TEXT_____DEBUG                           .text   $0D, "DEBUG                              ",0
TEXT_____BREAK                           .text   $0D, "BREAK                              ",0
TEXT_____DEBUG_FOLDER_ENTRY_TO_READ      .text   $0D, "DEBUG  Folder Entry To Read        ",0
TEXT_____DEBUG_FAT_SECTOR_TO_READ        .text   $0D, "DEBUG  FAT Sector To Read          ",0
TEXT_____DEBUG_SECTOR_TO_READ            .text   $0D, "DEBUG  SECTOR_TO_READ              ",0
TEXT_____DEBUG______FAT_L_IN             .text   $0D, "*********** FAT L IN **************",$0D,0
TEXT_____DEBUG______FAT_L_OUT            .text   $0D, "----------- FAT L OUT -------------",$0D,0
TEXT_____DEBUG_____________              .text   $0D, "*********** FOLDER IN *************",$0D,0
TEXT_____DEBUG____________EX             .text   $0D, "----------- FOLDER OUT ------------",$0D,0
TEXT_____DEBUG_START_DIR                 .text   $0D, "__________ START DIR CMD __________",$0D,0
TEXT_____DEBUG_END_DIR                   .text   $0D, "___________ END DIR CMD ___________",$0D,0
TEXT_____DEBUG_START_Oppen               .text   $0D, "_________ START Oppen CMD _________",$0D,0
TEXT_____DEBUG_END_Oppen                 .text   $0D, "__________ END Oppen CMD __________",$0D,0
TEXT_____DEBUG_START_Read               .text   $0D, "__________ START Read CMD __________",$0D,0
TEXT_____DEBUG_END_Read                 .text   $0D, "___________ END Read CMD ___________",$0D,0
