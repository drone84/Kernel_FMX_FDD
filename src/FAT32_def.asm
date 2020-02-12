;
FAT32_DATA_ADDRESS_BUFFER_512 = $10000         ; RAM address where to store the sector read by the floppy READ_DATA function
FAT32_FAT_ADDRESS_BUFFER_512 = $10200     ; RAM address where to store the sector read by the floppy READ_DATA function
FAT32_FOLDER_ADDRESS_BUFFER_512 = $10400

MBR_Partition_Entry = $01BE           ; beginning of the 4 16Byte partition entry block
MBR_Partition_Entry_size = 16         ; in Byte
MBR_Partition_LBA_Adress = #$8

FAT32_SD = #$1
FAT32_HDD = #$2
FAT32_FDD = #$3
