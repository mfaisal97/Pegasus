.option rvc
j 1f;


#eh dh?
addi a1, a1, 1;


li sp, 0x1234;


#a0, 0x1234 + 1020
c.addi4spn a0, sp, 1020;


#sp, 0x1234 + 496
c.addi16sp sp, 496;


#sp, 0x1234 + 496 - 512
c.addi16sp sp, -512;

#eh dh?
la a1, data;


#a2, 0xfffffffffedcba99
c.lw a0, 4(a1);
addi a0, a0, 1;
c.sw a0, 4(a1);
c.lw a2, 4(a1);



#a0, -15
ori a0, x0, 1;
c.addi a0, -16;


#a5, -16
ori a5, x0, 1;
c.li a5, -16;



#s0, 0xffffffffffffffe1
c.lui s0, 0xfffe1;
c.srai s0, 12;


#s0, 0x000fffe1
c.lui s0, 0xfffe1;
c.srli s0, 12;

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

#s0, 0x12340
li s0, 0x1234;
c.slli s0, 4;



#ra, 0
li ra, 0;
c.j 1f;
c.j 2f;
1:c.j 1f;
2:j fail;

#x0, 0
li a0, 0;
c.beqz a0, 1f;
c.j 2f;
1:c.j 1f;
2:j fail;



#x0, 0,
li a0, 1;
c.bnez a0, 1f;
c.j 2f;
1:c.j 1f;
2:j fail;
#1:)



#x0, 0,
li a0, 1;
c.beqz a0, 1f;
c.j 2f;
1:c.j fail;
#2:)



#x0, 0,
li a0, 0;
c.bnez a0, 1f;
c.j 2f;
1:c.j fail;
#2:)



#ra, 0,
la t0, 1f;
li ra, 0;
c.jr t0;
c.j 2f;
1:c.j 1f;
2:j fail;
#1:)



#ra, -2,
la t0, 1f;
li ra, 0;
c.jalr t0;
c.j 2f;
1:c.j 1f;
2:j fail;
1:sub ra, ra, t0;



#ra, -2,
la t0, 1f;
li ra, 0;
c.jal 1f;
c.j 2f;
1:c.j 1f;
2:j fail;
1:sub ra, ra, t0;



#eh dh?
la sp, data

#a2, 0xfffffffffedcba99
c.lwsp a0, 12(sp);
addi a0, a0, 1;
c.swsp a0, 12(sp);
c.lwsp a2, 12(sp);



#t0, 0x246
li a0, 0x123;
c.mv t0, a0;
c.add t0, a0;