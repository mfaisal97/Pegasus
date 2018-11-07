.option rvc

.text

#c.addi4spn a1, sp, 1020;
c.addi16sp sp, 496;
c.addi16sp sp, -512;



la a0,ten;
la a1,twenty;
c.lw a3, 0(a0);
c.sw a4, 0(a1);

c.addi a5, 1;
addi a0, a0, 1;
c.addi  a1, 1;


c.jal success;
c.addi  s1, 5;

success:
c.addi  s1, 10;

c.li s1, 7;
c.lui s1, 0xfffe1;

c.li s0, 1;
c.srli s0, 12;


c.li s0, -1;
c.srai s0, 12;


c.li s0, 1;
c.slli s0, 12;


#s0, ~0x11
c.li s0, -2;
c.andi s0, ~0x10;



#s1, 14
li s1, 20;
li a0, 6;
c.sub s1, a0;


#s1, 18
li s1, 20;
li a0, 6;
c.xor s1, a0;


#s1, 22
li s1, 20;
li a0, 6;
c.or s1, a0;


#s1,  4
li s1, 20;
li a0, 6;
c.and s1, a0;

c.j success2
li s1, 20;

success2: 
li s1, 30;


li a0, 0;
c.beqz a0, success3;
li s1, 20;

success3: 
li s1, 30;


li a0, 1;
c.bnez a0, success4;
li s1, 20;

success4: 
li s1, 30;


#a2, 0xfffffffffedcba99
c.lwsp a0, 12(sp);
addi a0, a0, 1;
c.swsp a1, 12(sp);
c.lwsp a2, 12(sp);



li a0, success5;
jr a0;
la a0, success5;

success5: 
li s1, 30;

c.li s0, 20;
c.li s1, 30;
c.mv s0,s1;


#t0, 0x246
li a0, 0x123;
c.mv t0, a0;
c.add t0, a0;


.data
ten :.long 0x55
twenty :.long 0x00