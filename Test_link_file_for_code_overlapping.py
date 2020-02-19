import os;
import sys;

dirname, filename = os.path.split(os.path.abspath(sys.argv[0]))
print ('------------------------ oppening the dump file ---------------------------------------');
print("running from", dirname)
print ('------------------------------------------------------------------------------------------');

hex_data=[]
sub_folder = "\\"

offset_in_update_file = 0;


full_path = dirname + sub_folder + 'kernel.lst'
print ('Readding ' + full_path)

SD_CARD = open(full_path, "r");
#DATA = SD_CARD.read();
#SD_CARD.close();

MEMORY_MAP = []
for i in range(0,0x1000000):
	MEMORY_MAP.append([])
for line in SD_CARD: 
	word = line.split()
	
	#print(word)
	if(len(word)):
		if(len(word[0]) >= 4):
			address = []
			#if word[0][0] == '=':
			#	address = int(word[0][2:],16)
			if word[0][0] == '.':
				address = int(word[0][1:],16)
			
			if type(address) == int :
				test = MEMORY_MAP[address]
				if test != []:
					print("ERROR @ 0x%.6X\n%s\n%s" %(address,MEMORY_MAP[address][:-1],line[:-1]));
				else:
					MEMORY_MAP[address] = line

