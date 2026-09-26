
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000180766680 <.text+0x765680>:
   180766680:	55                   	push   rbp
   180766681:	56                   	push   rsi
   180766682:	57                   	push   rdi
   180766683:	48 83 ec 50          	sub    rsp,0x50
   180766687:	48 8d 6c 24 50       	lea    rbp,[rsp+0x50]
   18076668c:	48 c7 45 f8 fe ff ff 	mov    QWORD PTR [rbp-0x8],0xfffffffffffffffe
   180766693:	ff 
   180766694:	48 89 ce             	mov    rsi,rcx
   180766697:	48 8d 7d d8          	lea    rdi,[rbp-0x28]
   18076669b:	48 89 f9             	mov    rcx,rdi
   18076669e:	e8 ed 97 e1 ff       	call   0x18057fe90
   1807666a3:	90                   	nop
   1807666a4:	48 89 f1             	mov    rcx,rsi
   1807666a7:	48 89 fa             	mov    rdx,rdi
   1807666aa:	e8 d1 00 00 00       	call   0x180766780
   1807666af:	90                   	nop
   1807666b0:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   1807666b4:	48 83 f8 10          	cmp    rax,0x10
   1807666b8:	72 31                	jb     0x1807666eb
   1807666ba:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   1807666be:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1807666c2:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1807666c9:	72 1b                	jb     0x1807666e6
   1807666cb:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1807666cf:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1807666d3:	4c 29 c1             	sub    rcx,r8
   1807666d6:	48 83 f9 20          	cmp    rcx,0x20
   1807666da:	73 61                	jae    0x18076673d
   1807666dc:	48 83 c0 28          	add    rax,0x28
   1807666e0:	48 89 c2             	mov    rdx,rax
   1807666e3:	4c 89 c1             	mov    rcx,r8
   1807666e6:	e8 f5 51 d4 06       	call   0x1874ab8e0
   1807666eb:	48 8d 05 96 ce 6e 08 	lea    rax,[rip+0x86ece96]        # 0x188e53588
   1807666f2:	48 89 06             	mov    QWORD PTR [rsi],rax
   1807666f5:	0f 57 c0             	xorps  xmm0,xmm0
   1807666f8:	0f 11 86 58 07 00 00 	movups XMMWORD PTR [rsi+0x758],xmm0
   1807666ff:	48 c7 86 68 07 00 00 	mov    QWORD PTR [rsi+0x768],0x0
   180766706:	00 00 00 00 
   18076670a:	48 c7 86 70 07 00 00 	mov    QWORD PTR [rsi+0x770],0xf
   180766711:	0f 00 00 00 
   180766715:	0f 11 86 78 07 00 00 	movups XMMWORD PTR [rsi+0x778],xmm0
   18076671c:	48 c7 86 88 07 00 00 	mov    QWORD PTR [rsi+0x788],0x0
   180766723:	00 00 00 00 
   180766727:	48 c7 86 90 07 00 00 	mov    QWORD PTR [rsi+0x790],0xf
   18076672e:	0f 00 00 00 
   180766732:	48 89 f0             	mov    rax,rsi
   180766735:	48 83 c4 50          	add    rsp,0x50
   180766739:	5f                   	pop    rdi
   18076673a:	5e                   	pop    rsi
   18076673b:	5d                   	pop    rbp
   18076673c:	c3                   	ret
   18076673d:	e8 4a 6c da 06       	call   0x18750d38c
   180766742:	cc                   	int3
   180766743:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
   18076674a:	84 00 00 00 00 00 
   180766750:	48 89 54 24 10       	mov    QWORD PTR [rsp+0x10],rdx
   180766755:	55                   	push   rbp
   180766756:	56                   	push   rsi
   180766757:	57                   	push   rdi
   180766758:	48 83 ec 20          	sub    rsp,0x20
   18076675c:	48 8d 6a 50          	lea    rbp,[rdx+0x50]
   180766760:	48 8d 4d d8          	lea    rcx,[rbp-0x28]
   180766764:	e8 a7 b8 89 ff       	call   0x180002010
   180766769:	90                   	nop
   18076676a:	48 83 c4 20          	add    rsp,0x20
   18076676e:	5f                   	pop    rdi
   18076676f:	5e                   	pop    rsi
   180766770:	5d                   	pop    rbp
   180766771:	c3                   	ret
   180766772:	cc                   	int3
   180766773:	cc                   	int3
   180766774:	cc                   	int3
   180766775:	cc                   	int3
   180766776:	cc                   	int3
   180766777:	cc                   	int3
   180766778:	cc                   	int3
   180766779:	cc                   	int3
   18076677a:	cc                   	int3
   18076677b:	cc                   	int3
   18076677c:	cc                   	int3
   18076677d:	cc                   	int3
   18076677e:	cc                   	int3
   18076677f:	cc                   	int3
