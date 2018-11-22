#I-CSRRC-01	forwarding
# Register initialization
li      x21, 0x12345678				#x000	working
li      x20, -1						#x008	
csrrw   x0, 0xb03, x20				#x00c

# Test >> 0xFFFFFFFF	0xEDCBA987	0x00000000	0xFFFFFFFF	0xFFFFFFFF
# Test >> 0xEDCBA987	0xFFFFFFFF	0x00000000	0xFFFFFFFF	0xFFFFFFFF
csrrc   x22, 0xb03, x21
csrrc   x21, 0xb03, x22			
csrrw   x23, 0xb03, x20
csrrc   x24, 0xb03, x23
csrrc   x25, 0xb03, x0



#I-CSRRCI-01	general test
# Register initialization
li      x8, -1
csrrw   x0, 0xb03, x8


# Test >> 0xFFFFFFFF	0xFFFFFFFE	0xFFFFFFFE	0xFFFFFFE0	0xFFFFFFE0	0xFFFFFFE0
csrrci  x11, 0xb03, 1
csrrci  x12, 0xb03, 0			
csrrci  x13, 0xb03, 0x1F		
csrrci  x14, 0xb03, 0x10
csrrci  x15, 0xb03, 0xF
csrrci  x16, 0xb03, 0



#I-CSRRS-01	forwarding 
li      x21, 0x12345678
csrrw   x0, 0xb03, x0

# Test	>> 0x00000000				0x12345678	0x00000000	0x12345678
# Test	>> 0x12345678	0x00000000	0x12345678	0x00000000	0x12345678
csrrs   x22, 0xb03, x21
csrrs   x23, 0xb03, x22
csrrw   x23, 0xb03, x0
csrrs   x24, 0xb03, x23
csrrs   x25, 0xb03, x0




#I-CSRRSI-01	General
# Register initialization
csrrw   x0, 0xb03, x0

# Test >>0x00000000	0x00000001	0x00000001	0x0000001F	0x0000001F	0x0000001F
csrrsi  x11, 0xb03, 1
csrrsi  x12, 0xb03, 0		
csrrsi  x13, 0xb03, 0x1F	
csrrsi  x14, 0xb03, 0x10
csrrsi  x15, 0xb03, 0xF
csrrsi  x16, 0xb03, 0



#I-CSRRW-01	forwarding
# Register initialization
li      x1, 0x12345678
li      x2, 0x9ABCDEF0

# Test	>> 0x00000000	0x12345678	0x9ABCDEF0	0x12345678	0x9ABCDEF0
csrrw   x0, 0xb03, x1
csrrw   x3, 0xb03, x2
csrrw   x4, 0xb03, x3
csrrw   x5, 0xb03, x4		#working	not 0x00000000
csrrw   x6, 0xb03, x0


#I-CSRRWI-01	General
csrrw   x0, 0xb03, x0

# Test	>>	0x00000000	0x00000001	0x00000000	0x0000001F	0x0000000F	0x00000010
csrrwi  x2, 0xb03, 1
csrrwi  x4, 0xb03, 0		
csrrwi  x6, 0xb03, 0x1F		
csrrwi  x28, 0xb03, 0x0F	
csrrwi  x30, 0xb03, 0x10	
csrrwi  x31, 0xb03, 0		
