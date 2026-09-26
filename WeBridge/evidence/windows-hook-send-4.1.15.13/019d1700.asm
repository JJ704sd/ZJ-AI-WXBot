
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

00000001819d1700 <.text+0x19d0700>:
   1819d1700:	55                   	push   rbp
   1819d1701:	41 56                	push   r14
   1819d1703:	56                   	push   rsi
   1819d1704:	57                   	push   rdi
   1819d1705:	53                   	push   rbx
   1819d1706:	48 81 ec a0 00 00 00 	sub    rsp,0xa0
   1819d170d:	48 8d ac 24 80 00 00 	lea    rbp,[rsp+0x80]
   1819d1714:	00 
   1819d1715:	0f 29 75 10          	movaps XMMWORD PTR [rbp+0x10],xmm6
   1819d1719:	48 c7 45 08 fe ff ff 	mov    QWORD PTR [rbp+0x8],0xfffffffffffffffe
   1819d1720:	ff 
   1819d1721:	48 89 ca             	mov    rdx,rcx
   1819d1724:	48 8d 71 28          	lea    rsi,[rcx+0x28]
   1819d1728:	80 b9 10 01 00 00 01 	cmp    BYTE PTR [rcx+0x110],0x1
   1819d172f:	75 28                	jne    0x1819d1759
   1819d1731:	48 81 c2 10 01 00 00 	add    rdx,0x110
   1819d1738:	48 89 f1             	mov    rcx,rsi
   1819d173b:	e8 50 5f 68 fe       	call   0x180057690
   1819d1740:	48 89 f1             	mov    rcx,rsi
   1819d1743:	0f 28 75 10          	movaps xmm6,XMMWORD PTR [rbp+0x10]
   1819d1747:	48 81 c4 a0 00 00 00 	add    rsp,0xa0
   1819d174e:	5b                   	pop    rbx
   1819d174f:	5f                   	pop    rdi
   1819d1750:	5e                   	pop    rsi
   1819d1751:	41 5e                	pop    r14
   1819d1753:	5d                   	pop    rbp
   1819d1754:	e9 d7 e1 68 fe       	jmp    0x18005f930
   1819d1759:	48 83 ba 30 01 00 00 	cmp    QWORD PTR [rdx+0x130],0x10
   1819d1760:	10 
   1819d1761:	72 09                	jb     0x1819d176c
   1819d1763:	48 8b 82 18 01 00 00 	mov    rax,QWORD PTR [rdx+0x118]
   1819d176a:	eb 07                	jmp    0x1819d1773
   1819d176c:	48 8d 82 18 01 00 00 	lea    rax,[rdx+0x118]
   1819d1773:	48 8d 4d d0          	lea    rcx,[rbp-0x30]
   1819d1777:	0f 57 f6             	xorps  xmm6,xmm6
   1819d177a:	0f 11 75 d0          	movups XMMWORD PTR [rbp-0x30],xmm6
   1819d177e:	48 8d 1d 83 0b 47 07 	lea    rbx,[rip+0x7470b83]        # 0x188e42308
   1819d1785:	48 89 5d c8          	mov    QWORD PTR [rbp-0x38],rbx
   1819d1789:	48 8b 92 50 01 00 00 	mov    rdx,QWORD PTR [rdx+0x150]
   1819d1790:	48 89 55 e0          	mov    QWORD PTR [rbp-0x20],rdx
   1819d1794:	48 89 45 e8          	mov    QWORD PTR [rbp-0x18],rax
   1819d1798:	4c 8d 35 79 4a 37 07 	lea    r14,[rip+0x7374a79]        # 0x188d46218
   1819d179f:	4c 89 75 a0          	mov    QWORD PTR [rbp-0x60],r14
   1819d17a3:	48 8d 7d a8          	lea    rdi,[rbp-0x58]
   1819d17a7:	0f 11 75 a8          	movups XMMWORD PTR [rbp-0x58],xmm6
   1819d17ab:	48 89 fa             	mov    rdx,rdi
   1819d17ae:	e8 fd 29 b2 05       	call   0x1874f41b0
   1819d17b3:	48 89 5d a0          	mov    QWORD PTR [rbp-0x60],rbx
   1819d17b7:	0f 10 45 e0          	movups xmm0,XMMWORD PTR [rbp-0x20]
   1819d17bb:	0f 11 45 b8          	movups XMMWORD PTR [rbp-0x48],xmm0
   1819d17bf:	0f 29 75 f0          	movaps XMMWORD PTR [rbp-0x10],xmm6
   1819d17c3:	48 8d 5d f0          	lea    rbx,[rbp-0x10]
   1819d17c7:	48 89 d9             	mov    rcx,rbx
   1819d17ca:	e8 e9 20 ae 05       	call   0x1874b38b8
   1819d17cf:	4c 8d 05 62 52 3b 08 	lea    r8,[rip+0x83b5262]        # 0x189d86a38
   1819d17d6:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   1819d17da:	48 89 d9             	mov    rcx,rbx
   1819d17dd:	e8 26 23 ae 05       	call   0x1874b3b08
   1819d17e2:	4c 89 75 a0          	mov    QWORD PTR [rbp-0x60],r14
   1819d17e6:	48 89 f9             	mov    rcx,rdi
   1819d17e9:	e8 52 2a b2 05       	call   0x1874f4240
   1819d17ee:	90                   	nop
   1819d17ef:	48 89 f1             	mov    rcx,rsi
   1819d17f2:	48 89 da             	mov    rdx,rbx
   1819d17f5:	e8 46 e1 7f fe       	call   0x1801cf940
   1819d17fa:	90                   	nop
   1819d17fb:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1819d17ff:	e8 c0 20 ae 05       	call   0x1874b38c4
   1819d1804:	48 8d 05 0d 4a 37 07 	lea    rax,[rip+0x7374a0d]        # 0x188d46218
   1819d180b:	48 89 45 c8          	mov    QWORD PTR [rbp-0x38],rax
   1819d180f:	48 8d 4d d0          	lea    rcx,[rbp-0x30]
   1819d1813:	e8 28 2a b2 05       	call   0x1874f4240
   1819d1818:	0f 28 75 10          	movaps xmm6,XMMWORD PTR [rbp+0x10]
   1819d181c:	48 81 c4 a0 00 00 00 	add    rsp,0xa0
   1819d1823:	5b                   	pop    rbx
   1819d1824:	5f                   	pop    rdi
   1819d1825:	5e                   	pop    rsi
   1819d1826:	41 5e                	pop    r14
   1819d1828:	5d                   	pop    rbp
   1819d1829:	c3                   	ret
