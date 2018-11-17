#I-CSRRC-01	forwarding
# Register initialization
li      x21, 0x12345678
li      x20, -1
csrrw   x0, mscratch, x20

# Test >> 0xEDCBA987	0xFFFFFFFF	0x00000000	0xFFFFFFFF	0xFFFFFFFF
csrrc   x22, mscratch, x21
csrrc   x21, mscratch, x22
csrrw   x23, mscratch, x20
csrrc   x24, mscratch, x23
csrrc x25, mscratch, x0



#I-CSRRCI-01	general test
# Register initialization
li      x8, -1
csrrw   x0, mscratch, x8

# Test >> 0xFFFFFFFF	0xFFFFFFFE	0xFFFFFFFE	0xFFFFFFE0	0xFFFFFFE0	0xFFFFFFE0	0xFFFFFFFF
csrrci  x11, mscratch, 1
csrrci  x12, mscratch, 0
csrrci  x13, mscratch, 0x1F
csrrci  x14, mscratch, 0x10
csrrci  x15, mscratch, 0xF
csrrci x16, mscratch, 0



#I-CSRRS-01	forwarding 
li      x21, 0x12345678
csrrw   x0, mscratch, x0

# Test	>> 0x12345678	0x00000000	0x12345678	0x00000000	0x12345678
csrrs   x22, mscratch, x21
csrrs   x23, mscratch, x22
csrrw   x23, mscratch, x0
csrrs   x24, mscratch, x23
csrrs x25, mscratch, x0




#I-CSRRSI-01	General
# Register initialization
csrrw   x0, mscratch, x0

# Test >> 0x00000000	0x00000000	0x00000001	0x00000001	0x0000001F	0x0000001F
csrrsi  x11, mscratch, 1
csrrsi  x12, mscratch, 0
csrrsi  x13, mscratch, 0x1F
csrrsi  x14, mscratch, 0x10
csrrsi  x15, mscratch, 0xF
csrrsi x16, mscratch, 0



#I-CSRRW-01	forwarding
# Register initialization
li      x1, 0x12345678
li      x2, 0x9ABCDEF0

# Test	>> 0x12345678	0x9ABCDEF0	0x00000000	0x9ABCDEF0
csrrw   x0, mscratch, x1
csrrw   x3, mscratch, x2
csrrw   x4, mscratch, x3
csrrw   x5, mscratch, x4
csrrw x6, mscratch, x0


#I-CSRRWI-01	General
csrrw   x0, mscratch, x0

# Test	>> 0x00000000	0x00000000	0x00000001	0x00000000	0x0000001F	0x0000001F	0x00000010
csrrwi  x2, mscratch, 1
csrrwi  x4, mscratch, 0
csrrwi  x6, mscratch, 0x1F
csrrwi  x28, mscratch, 0x0F
csrrwi  x30, mscratch, 0x10
csrrwi x31, mscratch, 0
