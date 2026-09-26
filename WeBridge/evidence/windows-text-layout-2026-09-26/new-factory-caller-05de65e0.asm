
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000185de65e0 <.text+0x5de55e0>:
   185de65e0:	55                   	push   rbp
   185de65e1:	41 57                	push   r15
   185de65e3:	41 56                	push   r14
   185de65e5:	56                   	push   rsi
   185de65e6:	57                   	push   rdi
   185de65e7:	53                   	push   rbx
   185de65e8:	48 81 ec a8 02 00 00 	sub    rsp,0x2a8
   185de65ef:	48 8d ac 24 80 00 00 	lea    rbp,[rsp+0x80]
   185de65f6:	00 
   185de65f7:	0f 29 bd 10 02 00 00 	movaps XMMWORD PTR [rbp+0x210],xmm7
   185de65fe:	0f 29 b5 00 02 00 00 	movaps XMMWORD PTR [rbp+0x200],xmm6
   185de6605:	48 c7 85 f8 01 00 00 	mov    QWORD PTR [rbp+0x1f8],0xfffffffffffffffe
   185de660c:	fe ff ff ff 
   185de6610:	48 89 d6             	mov    rsi,rdx
   185de6613:	49 89 cf             	mov    r15,rcx
   185de6616:	48 8b 0a             	mov    rcx,QWORD PTR [rdx]
   185de6619:	48 85 c9             	test   rcx,rcx
   185de661c:	0f 84 95 00 00 00    	je     0x185de66b7
   185de6622:	48 89 b5 c8 01 00 00 	mov    QWORD PTR [rbp+0x1c8],rsi
   185de6629:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   185de662c:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185de662f:	90                   	nop
   185de6630:	89 c6                	mov    esi,eax
   185de6632:	83 f8 07             	cmp    eax,0x7
   185de6635:	0f 87 dd 00 00 00    	ja     0x185de6718
   185de663b:	b8 98 00 00 00       	mov    eax,0x98
   185de6640:	0f a3 f0             	bt     eax,esi
   185de6643:	0f 83 cf 00 00 00    	jae    0x185de6718
   185de6649:	0f 57 c0             	xorps  xmm0,xmm0
   185de664c:	0f 29 85 40 01 00 00 	movaps XMMWORD PTR [rbp+0x140],xmm0
   185de6653:	48 c7 85 50 01 00 00 	mov    QWORD PTR [rbp+0x150],0x0
   185de665a:	00 00 00 00 
   185de665e:	48 c7 85 58 01 00 00 	mov    QWORD PTR [rbp+0x158],0xf
   185de6665:	0f 00 00 00 
   185de6669:	0f 28 35 40 f5 f5 02 	movaps xmm6,XMMWORD PTR [rip+0x2f5f540]        # 0x188d45bb0
   185de6670:	0f 29 b5 60 01 00 00 	movaps XMMWORD PTR [rbp+0x160],xmm6
   185de6677:	4c 8b b5 c8 01 00 00 	mov    r14,QWORD PTR [rbp+0x1c8]
   185de667e:	49 8b 0e             	mov    rcx,QWORD PTR [r14]
   185de6681:	c7 44 24 20 00 00 00 	mov    DWORD PTR [rsp+0x20],0x0
   185de6688:	00 
   185de6689:	4c 8d 05 30 fe 38 05 	lea    r8,[rip+0x538fe30]        # 0x18b1764c0
   185de6690:	4c 8d 0d 59 cf 56 05 	lea    r9,[rip+0x556cf59]        # 0x18b3535f0
   185de6697:	31 d2                	xor    edx,edx
   185de6699:	e8 4e d3 70 01       	call   0x1874f39ec
   185de669e:	90                   	nop
   185de669f:	48 85 c0             	test   rax,rax
   185de66a2:	74 1f                	je     0x185de66c3
   185de66a4:	49 8b 4e 08          	mov    rcx,QWORD PTR [r14+0x8]
   185de66a8:	48 85 c9             	test   rcx,rcx
   185de66ab:	74 7e                	je     0x185de672b
   185de66ad:	f0 ff 41 08          	lock inc DWORD PTR [rcx+0x8]
   185de66b1:	49 8b 4e 08          	mov    rcx,QWORD PTR [r14+0x8]
   185de66b5:	eb 76                	jmp    0x185de672d
   185de66b7:	0f 57 c0             	xorps  xmm0,xmm0
   185de66ba:	41 0f 11 07          	movups XMMWORD PTR [r15],xmm0
   185de66be:	e9 e8 0b 00 00       	jmp    0x185de72ab
   185de66c3:	0f 57 c0             	xorps  xmm0,xmm0
   185de66c6:	0f 29 85 60 01 00 00 	movaps XMMWORD PTR [rbp+0x160],xmm0
   185de66cd:	0f 29 b5 b0 01 00 00 	movaps XMMWORD PTR [rbp+0x1b0],xmm6
   185de66d4:	49 8b 0e             	mov    rcx,QWORD PTR [r14]
   185de66d7:	c7 44 24 20 00 00 00 	mov    DWORD PTR [rsp+0x20],0x0
   185de66de:	00 
   185de66df:	4c 8d 05 da fd 38 05 	lea    r8,[rip+0x538fdda]        # 0x18b1764c0
   185de66e6:	4c 8d 0d 13 e4 56 05 	lea    r9,[rip+0x556e413]        # 0x18b354b00
   185de66ed:	31 d2                	xor    edx,edx
   185de66ef:	e8 f8 d2 70 01       	call   0x1874f39ec
   185de66f4:	90                   	nop
   185de66f5:	48 85 c0             	test   rax,rax
   185de66f8:	0f 84 f8 00 00 00    	je     0x185de67f6
   185de66fe:	49 8b 4e 08          	mov    rcx,QWORD PTR [r14+0x8]
   185de6702:	48 85 c9             	test   rcx,rcx
   185de6705:	0f 84 00 0d 00 00    	je     0x185de740b
   185de670b:	f0 ff 41 08          	lock inc DWORD PTR [rcx+0x8]
   185de670f:	49 8b 4e 08          	mov    rcx,QWORD PTR [r14+0x8]
   185de6713:	e9 f5 0c 00 00       	jmp    0x185de740d
   185de6718:	0f 57 c0             	xorps  xmm0,xmm0
   185de671b:	41 0f 11 07          	movups XMMWORD PTR [r15],xmm0
   185de671f:	48 8b b5 c8 01 00 00 	mov    rsi,QWORD PTR [rbp+0x1c8]
   185de6726:	e9 80 0b 00 00       	jmp    0x185de72ab
   185de672b:	31 c9                	xor    ecx,ecx
   185de672d:	48 89 85 60 01 00 00 	mov    QWORD PTR [rbp+0x160],rax
   185de6734:	48 89 8d 68 01 00 00 	mov    QWORD PTR [rbp+0x168],rcx
   185de673b:	0f 29 b5 d0 01 00 00 	movaps XMMWORD PTR [rbp+0x1d0],xmm6
   185de6742:	48 8d 95 d0 01 00 00 	lea    rdx,[rbp+0x1d0]
   185de6749:	48 89 c1             	mov    rcx,rax
   185de674c:	e8 5f be 37 fc       	call   0x1821625b0
   185de6751:	90                   	nop
   185de6752:	48 8b 9d d0 01 00 00 	mov    rbx,QWORD PTR [rbp+0x1d0]
   185de6759:	48 85 db             	test   rbx,rbx
   185de675c:	74 1c                	je     0x185de677a
   185de675e:	0f 57 c0             	xorps  xmm0,xmm0
   185de6761:	0f 29 45 f0          	movaps XMMWORD PTR [rbp-0x10],xmm0
   185de6765:	0f 29 45 e0          	movaps XMMWORD PTR [rbp-0x20],xmm0
   185de6769:	48 8b 7b 60          	mov    rdi,QWORD PTR [rbx+0x60]
   185de676d:	48 83 7b 68 10       	cmp    QWORD PTR [rbx+0x68],0x10
   185de6772:	72 0d                	jb     0x185de6781
   185de6774:	48 8b 5b 50          	mov    rbx,QWORD PTR [rbx+0x50]
   185de6778:	eb 0b                	jmp    0x185de6785
   185de677a:	31 ff                	xor    edi,edi
   185de677c:	e9 11 03 00 00       	jmp    0x185de6a92
   185de6781:	48 83 c3 50          	add    rbx,0x50
   185de6785:	48 85 ff             	test   rdi,rdi
   185de6788:	0f 88 01 15 00 00    	js     0x185de7c8f
   185de678e:	48 83 ff 0f          	cmp    rdi,0xf
   185de6792:	77 21                	ja     0x185de67b5
   185de6794:	48 89 7d f0          	mov    QWORD PTR [rbp-0x10],rdi
   185de6798:	48 c7 45 f8 0f 00 00 	mov    QWORD PTR [rbp-0x8],0xf
   185de679f:	00 
   185de67a0:	0f 10 03             	movups xmm0,XMMWORD PTR [rbx]
   185de67a3:	0f 29 45 e0          	movaps XMMWORD PTR [rbp-0x20],xmm0
   185de67a7:	48 85 ff             	test   rdi,rdi
   185de67aa:	0f 85 cf 00 00 00    	jne    0x185de687f
   185de67b0:	e9 91 02 00 00       	jmp    0x185de6a46
   185de67b5:	48 89 f8             	mov    rax,rdi
   185de67b8:	48 83 c8 0f          	or     rax,0xf
   185de67bc:	48 83 f8 17          	cmp    rax,0x17
   185de67c0:	41 be 16 00 00 00    	mov    r14d,0x16
   185de67c6:	4c 0f 43 f0          	cmovae r14,rax
   185de67ca:	48 3d ff 0f 00 00    	cmp    rax,0xfff
   185de67d0:	72 79                	jb     0x185de684b
   185de67d2:	49 8d 4e 28          	lea    rcx,[r14+0x28]
   185de67d6:	e8 c1 50 6c 01       	call   0x1874ab89c
   185de67db:	90                   	nop
   185de67dc:	48 85 c0             	test   rax,rax
   185de67df:	0f 84 a4 14 00 00    	je     0x185de7c89
   185de67e5:	48 89 c1             	mov    rcx,rax
   185de67e8:	48 83 c0 27          	add    rax,0x27
   185de67ec:	48 83 e0 e0          	and    rax,0xffffffffffffffe0
   185de67f0:	48 89 48 f8          	mov    QWORD PTR [rax-0x8],rcx
   185de67f4:	eb 5f                	jmp    0x185de6855
   185de67f6:	0f 57 c0             	xorps  xmm0,xmm0
   185de67f9:	0f 29 85 b0 01 00 00 	movaps XMMWORD PTR [rbp+0x1b0],xmm0
   185de6800:	0f 29 b5 70 01 00 00 	movaps XMMWORD PTR [rbp+0x170],xmm6
   185de6807:	49 8b 0e             	mov    rcx,QWORD PTR [r14]
   185de680a:	c7 44 24 20 00 00 00 	mov    DWORD PTR [rsp+0x20],0x0
   185de6811:	00 
   185de6812:	4c 8d 05 a7 fc 38 05 	lea    r8,[rip+0x538fca7]        # 0x18b1764c0
   185de6819:	4c 8d 0d 90 ea 56 05 	lea    r9,[rip+0x556ea90]        # 0x18b3552b0
   185de6820:	31 d2                	xor    edx,edx
   185de6822:	e8 c5 d1 70 01       	call   0x1874f39ec
   185de6827:	90                   	nop
   185de6828:	48 85 c0             	test   rax,rax
   185de682b:	0f 84 b1 0c 00 00    	je     0x185de74e2
   185de6831:	49 8b 4e 08          	mov    rcx,QWORD PTR [r14+0x8]
   185de6835:	48 85 c9             	test   rcx,rcx
   185de6838:	0f 84 a6 0f 00 00    	je     0x185de77e4
   185de683e:	f0 ff 41 08          	lock inc DWORD PTR [rcx+0x8]
   185de6842:	49 8b 4e 08          	mov    rcx,QWORD PTR [r14+0x8]
   185de6846:	e9 9b 0f 00 00       	jmp    0x185de77e6
   185de684b:	49 8d 4e 01          	lea    rcx,[r14+0x1]
   185de684f:	e8 48 50 6c 01       	call   0x1874ab89c
   185de6854:	90                   	nop
   185de6855:	48 89 45 e0          	mov    QWORD PTR [rbp-0x20],rax
   185de6859:	48 89 7d f0          	mov    QWORD PTR [rbp-0x10],rdi
   185de685d:	4c 89 75 f8          	mov    QWORD PTR [rbp-0x8],r14
   185de6861:	48 ff c7             	inc    rdi
   185de6864:	48 89 c1             	mov    rcx,rax
   185de6867:	48 89 da             	mov    rdx,rbx
   185de686a:	49 89 f8             	mov    r8,rdi
   185de686d:	e8 de d7 75 01       	call   0x187544050
   185de6872:	48 8b 7d f0          	mov    rdi,QWORD PTR [rbp-0x10]
   185de6876:	48 85 ff             	test   rdi,rdi
   185de6879:	0f 84 c7 01 00 00    	je     0x185de6a46
   185de687f:	e8 8c f4 25 fa       	call   0x180045d10
   185de6884:	90                   	nop
   185de6885:	4c 8b 00             	mov    r8,QWORD PTR [rax]
   185de6888:	48 8d 95 70 01 00 00 	lea    rdx,[rbp+0x170]
   185de688f:	48 89 c1             	mov    rcx,rax
   185de6892:	41 ff 50 60          	call   QWORD PTR [r8+0x60]
   185de6896:	90                   	nop
   185de6897:	48 8b 8d 70 01 00 00 	mov    rcx,QWORD PTR [rbp+0x170]
   185de689e:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   185de68a1:	48 8d 95 b0 01 00 00 	lea    rdx,[rbp+0x1b0]
   185de68a8:	ff 50 30             	call   QWORD PTR [rax+0x30]
   185de68ab:	90                   	nop
   185de68ac:	48 8b 8d b0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1b0]
   185de68b3:	48 8d 05 1e c5 fa 02 	lea    rax,[rip+0x2fac51e]        # 0x188d92dd8
   185de68ba:	48 89 85 80 01 00 00 	mov    QWORD PTR [rbp+0x180],rax
   185de68c1:	0f 29 b5 f0 00 00 00 	movaps XMMWORD PTR [rbp+0xf0],xmm6
   185de68c8:	48 8d 95 f0 00 00 00 	lea    rdx,[rbp+0xf0]
   185de68cf:	4c 8d 85 80 01 00 00 	lea    r8,[rbp+0x180]
   185de68d6:	e8 a5 81 3b fa       	call   0x18019ea80
   185de68db:	90                   	nop
   185de68dc:	48 8b 85 f0 00 00 00 	mov    rax,QWORD PTR [rbp+0xf0]
   185de68e3:	48 8b 8d f8 00 00 00 	mov    rcx,QWORD PTR [rbp+0xf8]
   185de68ea:	48 85 c9             	test   rcx,rcx
   185de68ed:	74 3d                	je     0x185de692c
   185de68ef:	f0 ff 41 08          	lock inc DWORD PTR [rcx+0x8]
   185de68f3:	48 8b bd f8 00 00 00 	mov    rdi,QWORD PTR [rbp+0xf8]
   185de68fa:	48 89 85 90 01 00 00 	mov    QWORD PTR [rbp+0x190],rax
   185de6901:	48 89 bd 98 01 00 00 	mov    QWORD PTR [rbp+0x198],rdi
   185de6908:	48 85 ff             	test   rdi,rdi
   185de690b:	74 31                	je     0x185de693e
   185de690d:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   185de6911:	75 2b                	jne    0x185de693e
   185de6913:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185de6916:	48 89 f9             	mov    rcx,rdi
   185de6919:	ff 10                	call   QWORD PTR [rax]
   185de691b:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   185de691f:	75 1d                	jne    0x185de693e
   185de6921:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185de6924:	48 89 f9             	mov    rcx,rdi
   185de6927:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185de692a:	eb 12                	jmp    0x185de693e
   185de692c:	48 89 85 90 01 00 00 	mov    QWORD PTR [rbp+0x190],rax
   185de6933:	48 c7 85 98 01 00 00 	mov    QWORD PTR [rbp+0x198],0x0
   185de693a:	00 00 00 00 
   185de693e:	48 8b 8d 90 01 00 00 	mov    rcx,QWORD PTR [rbp+0x190]
   185de6945:	48 8d 55 70          	lea    rdx,[rbp+0x70]
   185de6949:	4c 8d 45 e0          	lea    r8,[rbp-0x20]
   185de694d:	e8 3e ac 8f fa       	call   0x1806e1590
   185de6952:	90                   	nop
   185de6953:	48 8b 85 58 01 00 00 	mov    rax,QWORD PTR [rbp+0x158]
   185de695a:	48 83 f8 10          	cmp    rax,0x10
   185de695e:	72 38                	jb     0x185de6998
   185de6960:	48 8b 8d 40 01 00 00 	mov    rcx,QWORD PTR [rbp+0x140]
   185de6967:	48 8d 50 01          	lea    rdx,[rax+0x1]
   185de696b:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185de6972:	72 1f                	jb     0x185de6993
   185de6974:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   185de6978:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   185de697c:	4c 29 c1             	sub    rcx,r8
   185de697f:	48 83 f9 20          	cmp    rcx,0x20
   185de6983:	0f 83 00 13 00 00    	jae    0x185de7c89
   185de6989:	48 83 c0 28          	add    rax,0x28
   185de698d:	48 89 c2             	mov    rdx,rax
   185de6990:	4c 89 c1             	mov    rcx,r8
   185de6993:	e8 48 4f 6c 01       	call   0x1874ab8e0
   185de6998:	0f 10 45 70          	movups xmm0,XMMWORD PTR [rbp+0x70]
   185de699c:	0f 10 8d 80 00 00 00 	movups xmm1,XMMWORD PTR [rbp+0x80]
   185de69a3:	0f 29 8d 50 01 00 00 	movaps XMMWORD PTR [rbp+0x150],xmm1
   185de69aa:	0f 29 85 40 01 00 00 	movaps XMMWORD PTR [rbp+0x140],xmm0
   185de69b1:	48 c7 85 80 00 00 00 	mov    QWORD PTR [rbp+0x80],0x0
   185de69b8:	00 00 00 00 
   185de69bc:	48 c7 85 88 00 00 00 	mov    QWORD PTR [rbp+0x88],0xf
   185de69c3:	0f 00 00 00 
   185de69c7:	c6 45 70 00          	mov    BYTE PTR [rbp+0x70],0x0
   185de69cb:	48 8b bd 98 01 00 00 	mov    rdi,QWORD PTR [rbp+0x198]
   185de69d2:	48 85 ff             	test   rdi,rdi
   185de69d5:	74 1d                	je     0x185de69f4
   185de69d7:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   185de69db:	75 17                	jne    0x185de69f4
   185de69dd:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185de69e0:	48 89 f9             	mov    rcx,rdi
   185de69e3:	ff 10                	call   QWORD PTR [rax]
   185de69e5:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   185de69e9:	75 09                	jne    0x185de69f4
   185de69eb:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185de69ee:	48 89 f9             	mov    rcx,rdi
   185de69f1:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185de69f4:	48 8b bd b8 01 00 00 	mov    rdi,QWORD PTR [rbp+0x1b8]
   185de69fb:	48 85 ff             	test   rdi,rdi
   185de69fe:	74 1d                	je     0x185de6a1d
   185de6a00:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   185de6a04:	75 17                	jne    0x185de6a1d
   185de6a06:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185de6a09:	48 89 f9             	mov    rcx,rdi
   185de6a0c:	ff 10                	call   QWORD PTR [rax]
   185de6a0e:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   185de6a12:	75 09                	jne    0x185de6a1d
   185de6a14:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185de6a17:	48 89 f9             	mov    rcx,rdi
   185de6a1a:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185de6a1d:	48 8b bd 78 01 00 00 	mov    rdi,QWORD PTR [rbp+0x178]
   185de6a24:	48 85 ff             	test   rdi,rdi
   185de6a27:	74 1d                	je     0x185de6a46
   185de6a29:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   185de6a2d:	75 17                	jne    0x185de6a46
   185de6a2f:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185de6a32:	48 89 f9             	mov    rcx,rdi
   185de6a35:	ff 10                	call   QWORD PTR [rax]
   185de6a37:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   185de6a3b:	75 09                	jne    0x185de6a46
   185de6a3d:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185de6a40:	48 89 f9             	mov    rcx,rdi
   185de6a43:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185de6a46:	48 8b 85 d0 01 00 00 	mov    rax,QWORD PTR [rbp+0x1d0]
   185de6a4d:	8b b8 d0 00 00 00    	mov    edi,DWORD PTR [rax+0xd0]
   185de6a53:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
   185de6a57:	48 83 f8 10          	cmp    rax,0x10
   185de6a5b:	72 35                	jb     0x185de6a92
   185de6a5d:	48 8b 4d e0          	mov    rcx,QWORD PTR [rbp-0x20]
   185de6a61:	48 8d 50 01          	lea    rdx,[rax+0x1]
   185de6a65:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185de6a6c:	72 1f                	jb     0x185de6a8d
   185de6a6e:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   185de6a72:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   185de6a76:	4c 29 c1             	sub    rcx,r8
   185de6a79:	48 83 f9 20          	cmp    rcx,0x20
   185de6a7d:	0f 83 06 12 00 00    	jae    0x185de7c89
   185de6a83:	48 83 c0 28          	add    rax,0x28
   185de6a87:	48 89 c2             	mov    rdx,rax
   185de6a8a:	4c 89 c1             	mov    rcx,r8
   185de6a8d:	e8 4e 4e 6c 01       	call   0x1874ab8e0
   185de6a92:	48 8b 9d d8 01 00 00 	mov    rbx,QWORD PTR [rbp+0x1d8]
   185de6a99:	48 85 db             	test   rbx,rbx
   185de6a9c:	74 1d                	je     0x185de6abb
   185de6a9e:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   185de6aa2:	75 17                	jne    0x185de6abb
   185de6aa4:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185de6aa7:	48 89 d9             	mov    rcx,rbx
   185de6aaa:	ff 10                	call   QWORD PTR [rax]
   185de6aac:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   185de6ab0:	75 09                	jne    0x185de6abb
   185de6ab2:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185de6ab5:	48 89 d9             	mov    rcx,rbx
   185de6ab8:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185de6abb:	4c 8b b5 c8 01 00 00 	mov    r14,QWORD PTR [rbp+0x1c8]
   185de6ac2:	48 8b 9d 68 01 00 00 	mov    rbx,QWORD PTR [rbp+0x168]
   185de6ac9:	48 85 db             	test   rbx,rbx
   185de6acc:	74 1d                	je     0x185de6aeb
   185de6ace:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   185de6ad2:	75 17                	jne    0x185de6aeb
   185de6ad4:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185de6ad7:	48 89 d9             	mov    rcx,rbx
   185de6ada:	ff 10                	call   QWORD PTR [rax]
   185de6adc:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   185de6ae0:	75 09                	jne    0x185de6aeb
   185de6ae2:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185de6ae5:	48 89 d9             	mov    rcx,rbx
   185de6ae8:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185de6aeb:	48 83 bd 50 01 00 00 	cmp    QWORD PTR [rbp+0x150],0x0
   185de6af2:	00 
   185de6af3:	0f 84 03 02 00 00    	je     0x185de6cfc
   185de6af9:	85 ff                	test   edi,edi
   185de6afb:	75 19                	jne    0x185de6b16
   185de6afd:	e8 0e f2 25 fa       	call   0x180045d10
   185de6b02:	90                   	nop
   185de6b03:	48 8b 10             	mov    rdx,QWORD PTR [rax]
   185de6b06:	48 89 c1             	mov    rcx,rax
   185de6b09:	ff 52 48             	call   QWORD PTR [rdx+0x48]
   185de6b0c:	90                   	nop
   185de6b0d:	89 c7                	mov    edi,eax
   185de6b0f:	4c 8b b5 c8 01 00 00 	mov    r14,QWORD PTR [rbp+0x1c8]
   185de6b16:	0f 57 ff             	xorps  xmm7,xmm7
   185de6b19:	0f 29 7d e0          	movaps XMMWORD PTR [rbp-0x20],xmm7
   185de6b1d:	48 c7 45 f0 00 00 00 	mov    QWORD PTR [rbp-0x10],0x0
   185de6b24:	00 
   185de6b25:	48 c7 45 f8 0f 00 00 	mov    QWORD PTR [rbp-0x8],0xf
   185de6b2c:	00 
   185de6b2d:	85 ff                	test   edi,edi
   185de6b2f:	0f 84 fe 00 00 00    	je     0x185de6c33
   185de6b35:	48 b8 aa aa aa aa aa 	movabs rax,0xaaaaaaaaaaaaaaaa
   185de6b3c:	aa aa aa 
   185de6b3f:	48 89 85 f0 00 00 00 	mov    QWORD PTR [rbp+0xf0],rax
   185de6b46:	89 fa                	mov    edx,edi
   185de6b48:	48 8d 8d f0 00 00 00 	lea    rcx,[rbp+0xf0]
   185de6b4f:	45 31 c0             	xor    r8d,r8d
   185de6b52:	45 31 c9             	xor    r9d,r9d
   185de6b55:	e8 56 8e 47 fa       	call   0x18025f9b0
   185de6b5a:	90                   	nop
   185de6b5b:	48 8d 8d d0 01 00 00 	lea    rcx,[rbp+0x1d0]
   185de6b62:	48 8d 95 f0 00 00 00 	lea    rdx,[rbp+0xf0]
   185de6b69:	45 31 c0             	xor    r8d,r8d
   185de6b6c:	41 b1 01             	mov    r9b,0x1
   185de6b6f:	e8 3c 19 10 fe       	call   0x183ee84b0
   185de6b74:	90                   	nop
   185de6b75:	48 8d 8d d0 01 00 00 	lea    rcx,[rbp+0x1d0]
   185de6b7c:	48 8d 55 70          	lea    rdx,[rbp+0x70]
   185de6b80:	e8 1b ec 29 fa       	call   0x1800857a0
   185de6b85:	90                   	nop
   185de6b86:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
   185de6b8a:	48 83 f8 10          	cmp    rax,0x10
   185de6b8e:	4c 8b b5 c8 01 00 00 	mov    r14,QWORD PTR [rbp+0x1c8]
   185de6b95:	72 35                	jb     0x185de6bcc
   185de6b97:	48 8b 4d e0          	mov    rcx,QWORD PTR [rbp-0x20]
   185de6b9b:	48 8d 50 01          	lea    rdx,[rax+0x1]
   185de6b9f:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185de6ba6:	72 1f                	jb     0x185de6bc7
   185de6ba8:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   185de6bac:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   185de6bb0:	4c 29 c1             	sub    rcx,r8
   185de6bb3:	48 83 f9 20          	cmp    rcx,0x20
   185de6bb7:	0f 83 cc 10 00 00    	jae    0x185de7c89
   185de6bbd:	48 83 c0 28          	add    rax,0x28
   185de6bc1:	48 89 c2             	mov    rdx,rax
   185de6bc4:	4c 89 c1             	mov    rcx,r8
   185de6bc7:	e8 14 4d 6c 01       	call   0x1874ab8e0
   185de6bcc:	0f 10 45 70          	movups xmm0,XMMWORD PTR [rbp+0x70]
   185de6bd0:	0f 10 8d 80 00 00 00 	movups xmm1,XMMWORD PTR [rbp+0x80]
   185de6bd7:	0f 29 4d f0          	movaps XMMWORD PTR [rbp-0x10],xmm1
   185de6bdb:	0f 29 45 e0          	movaps XMMWORD PTR [rbp-0x20],xmm0
   185de6bdf:	48 c7 85 80 00 00 00 	mov    QWORD PTR [rbp+0x80],0x0
   185de6be6:	00 00 00 00 
   185de6bea:	48 c7 85 88 00 00 00 	mov    QWORD PTR [rbp+0x88],0xf
   185de6bf1:	0f 00 00 00 
   185de6bf5:	c6 45 70 00          	mov    BYTE PTR [rbp+0x70],0x0
   185de6bf9:	48 8b 8d d0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1d0]
   185de6c00:	8b 01                	mov    eax,DWORD PTR [rcx]
   185de6c02:	83 f8 ff             	cmp    eax,0xffffffff
   185de6c05:	74 20                	je     0x185de6c27
   185de6c07:	85 c0                	test   eax,eax
   185de6c09:	74 0c                	je     0x185de6c17
   185de6c0b:	f0 ff 09             	lock dec DWORD PTR [rcx]
   185de6c0e:	75 17                	jne    0x185de6c27
   185de6c10:	48 8b 8d d0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1d0]
   185de6c17:	ba 02 00 00 00       	mov    edx,0x2
   185de6c1c:	41 b8 08 00 00 00    	mov    r8d,0x8
   185de6c22:	e8 09 1d 25 fa       	call   0x180038930
   185de6c27:	48 8d 8d f0 00 00 00 	lea    rcx,[rbp+0xf0]
   185de6c2e:	e8 5d f7 46 fa       	call   0x180256390
   185de6c33:	0f 29 7d 70          	movaps XMMWORD PTR [rbp+0x70],xmm7
   185de6c37:	48 c7 85 80 00 00 00 	mov    QWORD PTR [rbp+0x80],0x0
   185de6c3e:	00 00 00 00 
   185de6c42:	48 c7 85 88 00 00 00 	mov    QWORD PTR [rbp+0x88],0xf
   185de6c49:	0f 00 00 00 
   185de6c4d:	83 fe 07             	cmp    esi,0x7
   185de6c50:	0f 84 26 03 00 00    	je     0x185de6f7c
   185de6c56:	83 fe 04             	cmp    esi,0x4
   185de6c59:	0f 84 48 01 00 00    	je     0x185de6da7
   185de6c5f:	83 fe 03             	cmp    esi,0x3
   185de6c62:	0f 85 51 04 00 00    	jne    0x185de70b9
   185de6c68:	89 fa                	mov    edx,edi
   185de6c6a:	48 8d 8d 60 01 00 00 	lea    rcx,[rbp+0x160]
   185de6c71:	45 31 c0             	xor    r8d,r8d
   185de6c74:	45 31 c9             	xor    r9d,r9d
   185de6c77:	e8 34 8d 47 fa       	call   0x18025f9b0
   185de6c7c:	90                   	nop
   185de6c7d:	48 8d 0d 7c 3d b5 03 	lea    rcx,[rip+0x3b53d7c]        # 0x18993aa00
   185de6c84:	ba 0e 00 00 00       	mov    edx,0xe
   185de6c89:	e8 a2 11 24 fa       	call   0x180027e30
   185de6c8e:	90                   	nop
   185de6c8f:	48 89 85 b0 01 00 00 	mov    QWORD PTR [rbp+0x1b0],rax
   185de6c96:	48 8d 8d 60 01 00 00 	lea    rcx,[rbp+0x160]
   185de6c9d:	48 8d 95 90 01 00 00 	lea    rdx,[rbp+0x190]
   185de6ca4:	4c 8d 85 b0 01 00 00 	lea    r8,[rbp+0x1b0]
   185de6cab:	e8 00 75 47 fa       	call   0x18025e1b0
   185de6cb0:	90                   	nop
   185de6cb1:	48 8d 8d 90 01 00 00 	lea    rcx,[rbp+0x190]
   185de6cb8:	48 8d b5 d0 01 00 00 	lea    rsi,[rbp+0x1d0]
   185de6cbf:	48 89 f2             	mov    rdx,rsi
   185de6cc2:	e8 d9 ea 29 fa       	call   0x1800857a0
   185de6cc7:	90                   	nop
   185de6cc8:	48 8b bd d0 01 00 00 	mov    rdi,QWORD PTR [rbp+0x1d0]
   185de6ccf:	48 8b 9d e8 01 00 00 	mov    rbx,QWORD PTR [rbp+0x1e8]
   185de6cd6:	e8 85 66 2e fa       	call   0x1800cd360
   185de6cdb:	90                   	nop
   185de6cdc:	48 83 fb 10          	cmp    rbx,0x10
   185de6ce0:	48 0f 43 f7          	cmovae rsi,rdi
   185de6ce4:	48 8d 8d f0 00 00 00 	lea    rcx,[rbp+0xf0]
   185de6ceb:	48 89 c2             	mov    rdx,rax
   185de6cee:	49 89 f0             	mov    r8,rsi
   185de6cf1:	e8 4a 57 79 fa       	call   0x18057c440
   185de6cf6:	90                   	nop
   185de6cf7:	e9 3a 01 00 00       	jmp    0x185de6e36
   185de6cfc:	e8 0f f0 25 fa       	call   0x180045d10
   185de6d01:	90                   	nop
   185de6d02:	4c 8b 00             	mov    r8,QWORD PTR [rax]
   185de6d05:	48 8d 95 d0 01 00 00 	lea    rdx,[rbp+0x1d0]
   185de6d0c:	48 89 c1             	mov    rcx,rax
   185de6d0f:	41 ff 50 60          	call   QWORD PTR [r8+0x60]
   185de6d13:	90                   	nop
   185de6d14:	48 8b 8d d0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1d0]
   185de6d1b:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   185de6d1e:	48 8d 95 f0 00 00 00 	lea    rdx,[rbp+0xf0]
   185de6d25:	ff 50 30             	call   QWORD PTR [rax+0x30]
   185de6d28:	90                   	nop
   185de6d29:	48 8b 8d f0 00 00 00 	mov    rcx,QWORD PTR [rbp+0xf0]
   185de6d30:	48 8d 05 a1 c0 fa 02 	lea    rax,[rip+0x2fac0a1]        # 0x188d92dd8
   185de6d37:	48 89 85 90 01 00 00 	mov    QWORD PTR [rbp+0x190],rax
   185de6d3e:	0f 29 75 e0          	movaps XMMWORD PTR [rbp-0x20],xmm6
   185de6d42:	48 8d 55 e0          	lea    rdx,[rbp-0x20]
   185de6d46:	4c 8d 85 90 01 00 00 	lea    r8,[rbp+0x190]
   185de6d4d:	e8 2e 7d 3b fa       	call   0x18019ea80
   185de6d52:	90                   	nop
   185de6d53:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
   185de6d57:	48 8b 4d e8          	mov    rcx,QWORD PTR [rbp-0x18]
   185de6d5b:	48 85 c9             	test   rcx,rcx
   185de6d5e:	0f 84 8e 05 00 00    	je     0x185de72f2
   185de6d64:	f0 ff 41 08          	lock inc DWORD PTR [rcx+0x8]
   185de6d68:	48 8b 5d e8          	mov    rbx,QWORD PTR [rbp-0x18]
   185de6d6c:	48 89 45 70          	mov    QWORD PTR [rbp+0x70],rax
   185de6d70:	48 89 5d 78          	mov    QWORD PTR [rbp+0x78],rbx
   185de6d74:	48 85 db             	test   rbx,rbx
   185de6d77:	0f 84 81 05 00 00    	je     0x185de72fe
   185de6d7d:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   185de6d81:	0f 85 77 05 00 00    	jne    0x185de72fe
   185de6d87:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185de6d8a:	48 89 d9             	mov    rcx,rbx
   185de6d8d:	ff 10                	call   QWORD PTR [rax]
   185de6d8f:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   185de6d93:	0f 85 65 05 00 00    	jne    0x185de72fe
   185de6d99:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185de6d9c:	48 89 d9             	mov    rcx,rbx
   185de6d9f:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185de6da2:	e9 57 05 00 00       	jmp    0x185de72fe
   185de6da7:	89 fa                	mov    edx,edi
   185de6da9:	48 8d 8d 60 01 00 00 	lea    rcx,[rbp+0x160]
   185de6db0:	45 31 c0             	xor    r8d,r8d
   185de6db3:	45 31 c9             	xor    r9d,r9d
   185de6db6:	e8 f5 8b 47 fa       	call   0x18025f9b0
   185de6dbb:	90                   	nop
   185de6dbc:	48 8d 0d 3d 3c b5 03 	lea    rcx,[rip+0x3b53c3d]        # 0x18993aa00
   185de6dc3:	ba 0e 00 00 00       	mov    edx,0xe
   185de6dc8:	e8 63 10 24 fa       	call   0x180027e30
   185de6dcd:	90                   	nop
   185de6dce:	48 89 85 b0 01 00 00 	mov    QWORD PTR [rbp+0x1b0],rax
   185de6dd5:	48 8d 8d 60 01 00 00 	lea    rcx,[rbp+0x160]
   185de6ddc:	48 8d 95 90 01 00 00 	lea    rdx,[rbp+0x190]
   185de6de3:	4c 8d 85 b0 01 00 00 	lea    r8,[rbp+0x1b0]
   185de6dea:	e8 c1 73 47 fa       	call   0x18025e1b0
   185de6def:	90                   	nop
   185de6df0:	48 8d 8d 90 01 00 00 	lea    rcx,[rbp+0x190]
   185de6df7:	48 8d b5 d0 01 00 00 	lea    rsi,[rbp+0x1d0]
   185de6dfe:	48 89 f2             	mov    rdx,rsi
   185de6e01:	e8 9a e9 29 fa       	call   0x1800857a0
   185de6e06:	90                   	nop
   185de6e07:	48 8b bd d0 01 00 00 	mov    rdi,QWORD PTR [rbp+0x1d0]
   185de6e0e:	48 8b 9d e8 01 00 00 	mov    rbx,QWORD PTR [rbp+0x1e8]
   185de6e15:	e8 e6 67 2e fa       	call   0x1800cd600
   185de6e1a:	90                   	nop
   185de6e1b:	48 83 fb 10          	cmp    rbx,0x10
   185de6e1f:	48 0f 43 f7          	cmovae rsi,rdi
   185de6e23:	48 8d 8d f0 00 00 00 	lea    rcx,[rbp+0xf0]
   185de6e2a:	48 89 c2             	mov    rdx,rax
   185de6e2d:	49 89 f0             	mov    r8,rsi
   185de6e30:	e8 0b 56 79 fa       	call   0x18057c440
   185de6e35:	90                   	nop
   185de6e36:	48 8b 85 88 00 00 00 	mov    rax,QWORD PTR [rbp+0x88]
   185de6e3d:	48 83 f8 10          	cmp    rax,0x10
   185de6e41:	72 35                	jb     0x185de6e78
   185de6e43:	48 8b 4d 70          	mov    rcx,QWORD PTR [rbp+0x70]
   185de6e47:	48 8d 50 01          	lea    rdx,[rax+0x1]
   185de6e4b:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185de6e52:	72 1f                	jb     0x185de6e73
   185de6e54:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   185de6e58:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   185de6e5c:	4c 29 c1             	sub    rcx,r8
   185de6e5f:	48 83 f9 20          	cmp    rcx,0x20
   185de6e63:	0f 83 20 0e 00 00    	jae    0x185de7c89
   185de6e69:	48 83 c0 28          	add    rax,0x28
   185de6e6d:	48 89 c2             	mov    rdx,rax
   185de6e70:	4c 89 c1             	mov    rcx,r8
   185de6e73:	e8 68 4a 6c 01       	call   0x1874ab8e0
   185de6e78:	0f 10 85 f0 00 00 00 	movups xmm0,XMMWORD PTR [rbp+0xf0]
   185de6e7f:	0f 10 8d 00 01 00 00 	movups xmm1,XMMWORD PTR [rbp+0x100]
   185de6e86:	0f 29 8d 80 00 00 00 	movaps XMMWORD PTR [rbp+0x80],xmm1
   185de6e8d:	0f 29 45 70          	movaps XMMWORD PTR [rbp+0x70],xmm0
   185de6e91:	48 c7 85 00 01 00 00 	mov    QWORD PTR [rbp+0x100],0x0
   185de6e98:	00 00 00 00 
   185de6e9c:	48 c7 85 08 01 00 00 	mov    QWORD PTR [rbp+0x108],0xf
   185de6ea3:	0f 00 00 00 
   185de6ea7:	c6 85 f0 00 00 00 00 	mov    BYTE PTR [rbp+0xf0],0x0
   185de6eae:	48 8b 85 e8 01 00 00 	mov    rax,QWORD PTR [rbp+0x1e8]
   185de6eb5:	48 83 f8 10          	cmp    rax,0x10
   185de6eb9:	72 38                	jb     0x185de6ef3
   185de6ebb:	48 8b 8d d0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1d0]
   185de6ec2:	48 8d 50 01          	lea    rdx,[rax+0x1]
   185de6ec6:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185de6ecd:	72 1f                	jb     0x185de6eee
   185de6ecf:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   185de6ed3:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   185de6ed7:	4c 29 c1             	sub    rcx,r8
   185de6eda:	48 83 f9 20          	cmp    rcx,0x20
   185de6ede:	0f 83 a5 0d 00 00    	jae    0x185de7c89
   185de6ee4:	48 83 c0 28          	add    rax,0x28
   185de6ee8:	48 89 c2             	mov    rdx,rax
   185de6eeb:	4c 89 c1             	mov    rcx,r8
   185de6eee:	e8 ed 49 6c 01       	call   0x1874ab8e0
   185de6ef3:	48 8b 8d 90 01 00 00 	mov    rcx,QWORD PTR [rbp+0x190]
   185de6efa:	8b 01                	mov    eax,DWORD PTR [rcx]
   185de6efc:	83 f8 ff             	cmp    eax,0xffffffff
   185de6eff:	74 20                	je     0x185de6f21
   185de6f01:	85 c0                	test   eax,eax
   185de6f03:	74 0c                	je     0x185de6f11
   185de6f05:	f0 ff 09             	lock dec DWORD PTR [rcx]
   185de6f08:	75 17                	jne    0x185de6f21
   185de6f0a:	48 8b 8d 90 01 00 00 	mov    rcx,QWORD PTR [rbp+0x190]
   185de6f11:	ba 02 00 00 00       	mov    edx,0x2
   185de6f16:	41 b8 08 00 00 00    	mov    r8d,0x8
   185de6f1c:	e8 0f 1a 25 fa       	call   0x180038930
   185de6f21:	48 8b 8d b0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1b0]
   185de6f28:	8b 01                	mov    eax,DWORD PTR [rcx]
   185de6f2a:	83 f8 ff             	cmp    eax,0xffffffff
   185de6f2d:	74 20                	je     0x185de6f4f
   185de6f2f:	85 c0                	test   eax,eax
   185de6f31:	74 0c                	je     0x185de6f3f
   185de6f33:	f0 ff 09             	lock dec DWORD PTR [rcx]
   185de6f36:	75 17                	jne    0x185de6f4f
   185de6f38:	48 8b 8d b0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1b0]
   185de6f3f:	ba 02 00 00 00       	mov    edx,0x2
   185de6f44:	41 b8 08 00 00 00    	mov    r8d,0x8
   185de6f4a:	e8 e1 19 25 fa       	call   0x180038930
   185de6f4f:	48 8d 8d 60 01 00 00 	lea    rcx,[rbp+0x160]
   185de6f56:	e8 35 f4 46 fa       	call   0x180256390
   185de6f5b:	0f 29 b5 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm6
   185de6f62:	0f 29 b5 f0 00 00 00 	movaps XMMWORD PTR [rbp+0xf0],xmm6
   185de6f69:	48 83 bd 88 00 00 00 	cmp    QWORD PTR [rbp+0x88],0x10
   185de6f70:	10 
   185de6f71:	0f 83 20 01 00 00    	jae    0x185de7097
   185de6f77:	e9 59 01 00 00       	jmp    0x185de70d5
   185de6f7c:	49 8b 0e             	mov    rcx,QWORD PTR [r14]
   185de6f7f:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   185de6f82:	48 8d b5 d0 01 00 00 	lea    rsi,[rbp+0x1d0]
   185de6f89:	48 89 f2             	mov    rdx,rsi
   185de6f8c:	ff 90 88 00 00 00    	call   QWORD PTR [rax+0x88]
   185de6f92:	90                   	nop
   185de6f93:	48 8b bd d0 01 00 00 	mov    rdi,QWORD PTR [rbp+0x1d0]
   185de6f9a:	48 8b 9d e8 01 00 00 	mov    rbx,QWORD PTR [rbp+0x1e8]
   185de6fa1:	e8 5a 63 2e fa       	call   0x1800cd300
   185de6fa6:	90                   	nop
   185de6fa7:	48 83 fb 10          	cmp    rbx,0x10
   185de6fab:	48 0f 43 f7          	cmovae rsi,rdi
   185de6faf:	48 8d 8d f0 00 00 00 	lea    rcx,[rbp+0xf0]
   185de6fb6:	48 89 c2             	mov    rdx,rax
   185de6fb9:	49 89 f0             	mov    r8,rsi
   185de6fbc:	e8 7f 54 79 fa       	call   0x18057c440
   185de6fc1:	90                   	nop
   185de6fc2:	48 8b 85 88 00 00 00 	mov    rax,QWORD PTR [rbp+0x88]
   185de6fc9:	48 83 f8 10          	cmp    rax,0x10
   185de6fcd:	72 35                	jb     0x185de7004
   185de6fcf:	48 8b 4d 70          	mov    rcx,QWORD PTR [rbp+0x70]
   185de6fd3:	48 8d 50 01          	lea    rdx,[rax+0x1]
   185de6fd7:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185de6fde:	72 1f                	jb     0x185de6fff
   185de6fe0:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   185de6fe4:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   185de6fe8:	4c 29 c1             	sub    rcx,r8
   185de6feb:	48 83 f9 20          	cmp    rcx,0x20
   185de6fef:	0f 83 94 0c 00 00    	jae    0x185de7c89
   185de6ff5:	48 83 c0 28          	add    rax,0x28
   185de6ff9:	48 89 c2             	mov    rdx,rax
   185de6ffc:	4c 89 c1             	mov    rcx,r8
   185de6fff:	e8 dc 48 6c 01       	call   0x1874ab8e0
   185de7004:	0f 10 85 f0 00 00 00 	movups xmm0,XMMWORD PTR [rbp+0xf0]
   185de700b:	0f 10 8d 00 01 00 00 	movups xmm1,XMMWORD PTR [rbp+0x100]
   185de7012:	0f 29 8d 80 00 00 00 	movaps XMMWORD PTR [rbp+0x80],xmm1
   185de7019:	0f 29 45 70          	movaps XMMWORD PTR [rbp+0x70],xmm0
   185de701d:	48 c7 85 00 01 00 00 	mov    QWORD PTR [rbp+0x100],0x0
   185de7024:	00 00 00 00 
   185de7028:	48 c7 85 08 01 00 00 	mov    QWORD PTR [rbp+0x108],0xf
   185de702f:	0f 00 00 00 
   185de7033:	c6 85 f0 00 00 00 00 	mov    BYTE PTR [rbp+0xf0],0x0
   185de703a:	48 8b 85 e8 01 00 00 	mov    rax,QWORD PTR [rbp+0x1e8]
   185de7041:	48 83 f8 10          	cmp    rax,0x10
   185de7045:	72 38                	jb     0x185de707f
   185de7047:	48 8b 8d d0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1d0]
   185de704e:	48 8d 50 01          	lea    rdx,[rax+0x1]
   185de7052:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185de7059:	72 1f                	jb     0x185de707a
   185de705b:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   185de705f:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   185de7063:	4c 29 c1             	sub    rcx,r8
   185de7066:	48 83 f9 20          	cmp    rcx,0x20
   185de706a:	0f 83 19 0c 00 00    	jae    0x185de7c89
   185de7070:	48 83 c0 28          	add    rax,0x28
   185de7074:	48 89 c2             	mov    rdx,rax
   185de7077:	4c 89 c1             	mov    rcx,r8
   185de707a:	e8 61 48 6c 01       	call   0x1874ab8e0
   185de707f:	0f 29 b5 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm6
   185de7086:	0f 29 b5 f0 00 00 00 	movaps XMMWORD PTR [rbp+0xf0],xmm6
   185de708d:	48 83 bd 88 00 00 00 	cmp    QWORD PTR [rbp+0x88],0x10
   185de7094:	10 
   185de7095:	72 3e                	jb     0x185de70d5
   185de7097:	48 8b 45 70          	mov    rax,QWORD PTR [rbp+0x70]
   185de709b:	48 83 7d f8 10       	cmp    QWORD PTR [rbp-0x8],0x10
   185de70a0:	73 3e                	jae    0x185de70e0
   185de70a2:	4c 8d 4d e0          	lea    r9,[rbp-0x20]
   185de70a6:	48 83 bd 58 01 00 00 	cmp    QWORD PTR [rbp+0x158],0x10
   185de70ad:	10 
   185de70ae:	73 3e                	jae    0x185de70ee
   185de70b0:	4c 8d 85 40 01 00 00 	lea    r8,[rbp+0x140]
   185de70b7:	eb 3c                	jmp    0x185de70f5
   185de70b9:	c6 45 70 00          	mov    BYTE PTR [rbp+0x70],0x0
   185de70bd:	0f 29 b5 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm6
   185de70c4:	0f 29 b5 f0 00 00 00 	movaps XMMWORD PTR [rbp+0xf0],xmm6
   185de70cb:	48 83 bd 88 00 00 00 	cmp    QWORD PTR [rbp+0x88],0x10
   185de70d2:	10 
   185de70d3:	73 c2                	jae    0x185de7097
   185de70d5:	48 8d 45 70          	lea    rax,[rbp+0x70]
   185de70d9:	48 83 7d f8 10       	cmp    QWORD PTR [rbp-0x8],0x10
   185de70de:	72 c2                	jb     0x185de70a2
   185de70e0:	4c 8b 4d e0          	mov    r9,QWORD PTR [rbp-0x20]
   185de70e4:	48 83 bd 58 01 00 00 	cmp    QWORD PTR [rbp+0x158],0x10
   185de70eb:	10 
   185de70ec:	72 c2                	jb     0x185de70b0
   185de70ee:	4c 8b 85 40 01 00 00 	mov    r8,QWORD PTR [rbp+0x140]
   185de70f5:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   185de70fa:	48 8d 15 0f 39 b5 03 	lea    rdx,[rip+0x3b5390f]        # 0x18993aa10
   185de7101:	48 8d b5 f0 00 00 00 	lea    rsi,[rbp+0xf0]
   185de7108:	48 89 f1             	mov    rcx,rsi
   185de710b:	e8 30 53 79 fa       	call   0x18057c440
   185de7110:	90                   	nop
   185de7111:	41 0f 11 37          	movups XMMWORD PTR [r15],xmm6
   185de7115:	4c 89 f9             	mov    rcx,r15
   185de7118:	e8 53 db 90 fa       	call   0x1806f4c70
   185de711d:	90                   	nop
   185de711e:	49 8b 07             	mov    rax,QWORD PTR [r15]
   185de7121:	c7 80 18 01 00 00 01 	mov    DWORD PTR [rax+0x118],0x1
   185de7128:	00 00 00 
   185de712b:	4c 89 7d d8          	mov    QWORD PTR [rbp-0x28],r15
   185de712f:	49 8b 07             	mov    rax,QWORD PTR [r15]
   185de7132:	48 8d b8 58 07 00 00 	lea    rdi,[rax+0x758]
   185de7139:	48 39 f7             	cmp    rdi,rsi
   185de713c:	74 57                	je     0x185de7195
   185de713e:	48 8b 9d 00 01 00 00 	mov    rbx,QWORD PTR [rbp+0x100]
   185de7145:	48 83 bd 08 01 00 00 	cmp    QWORD PTR [rbp+0x108],0x10
   185de714c:	10 
   185de714d:	72 07                	jb     0x185de7156
   185de714f:	48 8b b5 f0 00 00 00 	mov    rsi,QWORD PTR [rbp+0xf0]
   185de7156:	48 8b 88 70 07 00 00 	mov    rcx,QWORD PTR [rax+0x770]
   185de715d:	48 39 cb             	cmp    rbx,rcx
   185de7160:	76 11                	jbe    0x185de7173
   185de7162:	48 89 f9             	mov    rcx,rdi
   185de7165:	48 89 da             	mov    rdx,rbx
   185de7168:	49 89 f1             	mov    r9,rsi
   185de716b:	e8 e0 6f 25 fa       	call   0x18003e150
   185de7170:	90                   	nop
   185de7171:	eb 22                	jmp    0x185de7195
   185de7173:	48 83 f9 10          	cmp    rcx,0x10
   185de7177:	72 03                	jb     0x185de717c
   185de7179:	48 8b 3f             	mov    rdi,QWORD PTR [rdi]
   185de717c:	48 89 98 68 07 00 00 	mov    QWORD PTR [rax+0x768],rbx
   185de7183:	48 89 f9             	mov    rcx,rdi
   185de7186:	48 89 f2             	mov    rdx,rsi
   185de7189:	49 89 d8             	mov    r8,rbx
   185de718c:	e8 bf ce 75 01       	call   0x187544050
   185de7191:	c6 04 1f 00          	mov    BYTE PTR [rdi+rbx*1],0x0
   185de7195:	48 8b 85 08 01 00 00 	mov    rax,QWORD PTR [rbp+0x108]
   185de719c:	48 83 f8 10          	cmp    rax,0x10
   185de71a0:	48 8b b5 c8 01 00 00 	mov    rsi,QWORD PTR [rbp+0x1c8]
   185de71a7:	4c 8b 7d d8          	mov    r15,QWORD PTR [rbp-0x28]
   185de71ab:	72 38                	jb     0x185de71e5
   185de71ad:	48 8b 8d f0 00 00 00 	mov    rcx,QWORD PTR [rbp+0xf0]
   185de71b4:	48 8d 50 01          	lea    rdx,[rax+0x1]
   185de71b8:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185de71bf:	72 1f                	jb     0x185de71e0
   185de71c1:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   185de71c5:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   185de71c9:	4c 29 c1             	sub    rcx,r8
   185de71cc:	48 83 f9 20          	cmp    rcx,0x20
   185de71d0:	0f 83 b3 0a 00 00    	jae    0x185de7c89
   185de71d6:	48 83 c0 28          	add    rax,0x28
   185de71da:	48 89 c2             	mov    rdx,rax
   185de71dd:	4c 89 c1             	mov    rcx,r8
   185de71e0:	e8 fb 46 6c 01       	call   0x1874ab8e0
   185de71e5:	48 8b 85 88 00 00 00 	mov    rax,QWORD PTR [rbp+0x88]
   185de71ec:	48 83 f8 10          	cmp    rax,0x10
   185de71f0:	72 35                	jb     0x185de7227
   185de71f2:	48 8b 4d 70          	mov    rcx,QWORD PTR [rbp+0x70]
   185de71f6:	48 8d 50 01          	lea    rdx,[rax+0x1]
   185de71fa:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185de7201:	72 1f                	jb     0x185de7222
   185de7203:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   185de7207:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   185de720b:	4c 29 c1             	sub    rcx,r8
   185de720e:	48 83 f9 20          	cmp    rcx,0x20
   185de7212:	0f 83 71 0a 00 00    	jae    0x185de7c89
   185de7218:	48 83 c0 28          	add    rax,0x28
   185de721c:	48 89 c2             	mov    rdx,rax
   185de721f:	4c 89 c1             	mov    rcx,r8
   185de7222:	e8 b9 46 6c 01       	call   0x1874ab8e0
   185de7227:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
   185de722b:	48 83 f8 10          	cmp    rax,0x10
   185de722f:	72 35                	jb     0x185de7266
   185de7231:	48 8b 4d e0          	mov    rcx,QWORD PTR [rbp-0x20]
   185de7235:	48 8d 50 01          	lea    rdx,[rax+0x1]
   185de7239:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185de7240:	72 1f                	jb     0x185de7261
   185de7242:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   185de7246:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   185de724a:	4c 29 c1             	sub    rcx,r8
   185de724d:	48 83 f9 20          	cmp    rcx,0x20
   185de7251:	0f 83 32 0a 00 00    	jae    0x185de7c89
   185de7257:	48 83 c0 28          	add    rax,0x28
   185de725b:	48 89 c2             	mov    rdx,rax
   185de725e:	4c 89 c1             	mov    rcx,r8
   185de7261:	e8 7a 46 6c 01       	call   0x1874ab8e0
   185de7266:	48 8b 85 58 01 00 00 	mov    rax,QWORD PTR [rbp+0x158]
   185de726d:	48 83 f8 10          	cmp    rax,0x10
   185de7271:	72 38                	jb     0x185de72ab
   185de7273:	48 8b 8d 40 01 00 00 	mov    rcx,QWORD PTR [rbp+0x140]
   185de727a:	48 8d 50 01          	lea    rdx,[rax+0x1]
   185de727e:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185de7285:	72 1f                	jb     0x185de72a6
   185de7287:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   185de728b:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   185de728f:	4c 29 c1             	sub    rcx,r8
   185de7292:	48 83 f9 20          	cmp    rcx,0x20
   185de7296:	0f 83 ed 09 00 00    	jae    0x185de7c89
   185de729c:	48 83 c0 28          	add    rax,0x28
   185de72a0:	48 89 c2             	mov    rdx,rax
   185de72a3:	4c 89 c1             	mov    rcx,r8
   185de72a6:	e8 35 46 6c 01       	call   0x1874ab8e0
   185de72ab:	48 8b 76 08          	mov    rsi,QWORD PTR [rsi+0x8]
   185de72af:	48 85 f6             	test   rsi,rsi
   185de72b2:	74 1d                	je     0x185de72d1
   185de72b4:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   185de72b8:	75 17                	jne    0x185de72d1
   185de72ba:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   185de72bd:	48 89 f1             	mov    rcx,rsi
   185de72c0:	ff 10                	call   QWORD PTR [rax]
   185de72c2:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   185de72c6:	75 09                	jne    0x185de72d1
   185de72c8:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   185de72cb:	48 89 f1             	mov    rcx,rsi
   185de72ce:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185de72d1:	4c 89 f8             	mov    rax,r15
   185de72d4:	0f 28 b5 00 02 00 00 	movaps xmm6,XMMWORD PTR [rbp+0x200]
   185de72db:	0f 28 bd 10 02 00 00 	movaps xmm7,XMMWORD PTR [rbp+0x210]
   185de72e2:	48 81 c4 a8 02 00 00 	add    rsp,0x2a8
   185de72e9:	5b                   	pop    rbx
   185de72ea:	5f                   	pop    rdi
   185de72eb:	5e                   	pop    rsi
   185de72ec:	41 5e                	pop    r14
   185de72ee:	41 5f                	pop    r15
   185de72f0:	5d                   	pop    rbp
   185de72f1:	c3                   	ret
   185de72f2:	48 89 45 70          	mov    QWORD PTR [rbp+0x70],rax
   185de72f6:	48 c7 45 78 00 00 00 	mov    QWORD PTR [rbp+0x78],0x0
   185de72fd:	00 
   185de72fe:	48 8b 4d 70          	mov    rcx,QWORD PTR [rbp+0x70]
   185de7302:	48 8d 55 e0          	lea    rdx,[rbp-0x20]
   185de7306:	e8 45 a5 90 fa       	call   0x1806f1850
   185de730b:	90                   	nop
   185de730c:	48 8b 85 58 01 00 00 	mov    rax,QWORD PTR [rbp+0x158]
   185de7313:	48 83 f8 10          	cmp    rax,0x10
   185de7317:	4c 8b b5 c8 01 00 00 	mov    r14,QWORD PTR [rbp+0x1c8]
   185de731e:	72 38                	jb     0x185de7358
   185de7320:	48 8b 8d 40 01 00 00 	mov    rcx,QWORD PTR [rbp+0x140]
   185de7327:	48 8d 50 01          	lea    rdx,[rax+0x1]
   185de732b:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185de7332:	72 1f                	jb     0x185de7353
   185de7334:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   185de7338:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   185de733c:	4c 29 c1             	sub    rcx,r8
   185de733f:	48 83 f9 20          	cmp    rcx,0x20
   185de7343:	0f 83 40 09 00 00    	jae    0x185de7c89
   185de7349:	48 83 c0 28          	add    rax,0x28
   185de734d:	48 89 c2             	mov    rdx,rax
   185de7350:	4c 89 c1             	mov    rcx,r8
   185de7353:	e8 88 45 6c 01       	call   0x1874ab8e0
   185de7358:	0f 10 45 e0          	movups xmm0,XMMWORD PTR [rbp-0x20]
   185de735c:	0f 10 4d f0          	movups xmm1,XMMWORD PTR [rbp-0x10]
   185de7360:	0f 29 8d 50 01 00 00 	movaps XMMWORD PTR [rbp+0x150],xmm1
   185de7367:	0f 29 85 40 01 00 00 	movaps XMMWORD PTR [rbp+0x140],xmm0
   185de736e:	48 c7 45 f0 00 00 00 	mov    QWORD PTR [rbp-0x10],0x0
   185de7375:	00 
   185de7376:	48 c7 45 f8 0f 00 00 	mov    QWORD PTR [rbp-0x8],0xf
   185de737d:	00 
   185de737e:	c6 45 e0 00          	mov    BYTE PTR [rbp-0x20],0x0
   185de7382:	48 8b 5d 78          	mov    rbx,QWORD PTR [rbp+0x78]
   185de7386:	48 85 db             	test   rbx,rbx
   185de7389:	74 1d                	je     0x185de73a8
   185de738b:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   185de738f:	75 17                	jne    0x185de73a8
   185de7391:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185de7394:	48 89 d9             	mov    rcx,rbx
   185de7397:	ff 10                	call   QWORD PTR [rax]
   185de7399:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   185de739d:	75 09                	jne    0x185de73a8
   185de739f:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185de73a2:	48 89 d9             	mov    rcx,rbx
   185de73a5:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185de73a8:	48 8b 9d f8 00 00 00 	mov    rbx,QWORD PTR [rbp+0xf8]
   185de73af:	48 85 db             	test   rbx,rbx
   185de73b2:	74 1d                	je     0x185de73d1
   185de73b4:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   185de73b8:	75 17                	jne    0x185de73d1
   185de73ba:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185de73bd:	48 89 d9             	mov    rcx,rbx
   185de73c0:	ff 10                	call   QWORD PTR [rax]
   185de73c2:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   185de73c6:	75 09                	jne    0x185de73d1
   185de73c8:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185de73cb:	48 89 d9             	mov    rcx,rbx
   185de73ce:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185de73d1:	48 8b 9d d8 01 00 00 	mov    rbx,QWORD PTR [rbp+0x1d8]
   185de73d8:	48 85 db             	test   rbx,rbx
   185de73db:	0f 84 18 f7 ff ff    	je     0x185de6af9
   185de73e1:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   185de73e5:	0f 85 0e f7 ff ff    	jne    0x185de6af9
   185de73eb:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185de73ee:	48 89 d9             	mov    rcx,rbx
   185de73f1:	ff 10                	call   QWORD PTR [rax]
   185de73f3:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   185de73f7:	0f 85 fc f6 ff ff    	jne    0x185de6af9
   185de73fd:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185de7400:	48 89 d9             	mov    rcx,rbx
   185de7403:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185de7406:	e9 ee f6 ff ff       	jmp    0x185de6af9
   185de740b:	31 c9                	xor    ecx,ecx
   185de740d:	48 89 85 b0 01 00 00 	mov    QWORD PTR [rbp+0x1b0],rax
   185de7414:	48 89 8d b8 01 00 00 	mov    QWORD PTR [rbp+0x1b8],rcx
   185de741b:	0f 29 b5 d0 01 00 00 	movaps XMMWORD PTR [rbp+0x1d0],xmm6
   185de7422:	48 8d 95 d0 01 00 00 	lea    rdx,[rbp+0x1d0]
   185de7429:	48 89 c1             	mov    rcx,rax
   185de742c:	e8 0f 53 58 fa       	call   0x18036c740
   185de7431:	90                   	nop
   185de7432:	48 8b 9d d0 01 00 00 	mov    rbx,QWORD PTR [rbp+0x1d0]
   185de7439:	48 85 db             	test   rbx,rbx
   185de743c:	74 25                	je     0x185de7463
   185de743e:	0f 57 c0             	xorps  xmm0,xmm0
   185de7441:	0f 29 45 f0          	movaps XMMWORD PTR [rbp-0x10],xmm0
   185de7445:	0f 29 45 e0          	movaps XMMWORD PTR [rbp-0x20],xmm0
   185de7449:	48 8b bb 70 07 00 00 	mov    rdi,QWORD PTR [rbx+0x770]
   185de7450:	48 83 bb 78 07 00 00 	cmp    QWORD PTR [rbx+0x778],0x10
   185de7457:	10 
   185de7458:	72 10                	jb     0x185de746a
   185de745a:	48 8b 9b 60 07 00 00 	mov    rbx,QWORD PTR [rbx+0x760]
   185de7461:	eb 0e                	jmp    0x185de7471
   185de7463:	31 ff                	xor    edi,edi
   185de7465:	e9 10 03 00 00       	jmp    0x185de777a
   185de746a:	48 81 c3 60 07 00 00 	add    rbx,0x760
   185de7471:	48 85 ff             	test   rdi,rdi
   185de7474:	0f 88 1b 08 00 00    	js     0x185de7c95
   185de747a:	48 83 ff 0f          	cmp    rdi,0xf
   185de747e:	77 21                	ja     0x185de74a1
   185de7480:	48 89 7d f0          	mov    QWORD PTR [rbp-0x10],rdi
   185de7484:	48 c7 45 f8 0f 00 00 	mov    QWORD PTR [rbp-0x8],0xf
   185de748b:	00 
   185de748c:	0f 10 03             	movups xmm0,XMMWORD PTR [rbx]
   185de748f:	0f 29 45 e0          	movaps XMMWORD PTR [rbp-0x20],xmm0
   185de7493:	48 85 ff             	test   rdi,rdi
   185de7496:	0f 85 d1 00 00 00    	jne    0x185de756d
   185de749c:	e9 8d 02 00 00       	jmp    0x185de772e
   185de74a1:	48 89 f8             	mov    rax,rdi
   185de74a4:	48 83 c8 0f          	or     rax,0xf
   185de74a8:	48 83 f8 17          	cmp    rax,0x17
   185de74ac:	41 be 16 00 00 00    	mov    r14d,0x16
   185de74b2:	4c 0f 43 f0          	cmovae r14,rax
   185de74b6:	48 3d ff 0f 00 00    	cmp    rax,0xfff
   185de74bc:	72 7b                	jb     0x185de7539
   185de74be:	49 8d 4e 28          	lea    rcx,[r14+0x28]
   185de74c2:	e8 d5 43 6c 01       	call   0x1874ab89c
   185de74c7:	90                   	nop
   185de74c8:	48 85 c0             	test   rax,rax
   185de74cb:	0f 84 b8 07 00 00    	je     0x185de7c89
   185de74d1:	48 89 c1             	mov    rcx,rax
   185de74d4:	48 83 c0 27          	add    rax,0x27
   185de74d8:	48 83 e0 e0          	and    rax,0xffffffffffffffe0
   185de74dc:	48 89 48 f8          	mov    QWORD PTR [rax-0x8],rcx
   185de74e0:	eb 61                	jmp    0x185de7543
   185de74e2:	0f 57 c0             	xorps  xmm0,xmm0
   185de74e5:	0f 29 85 70 01 00 00 	movaps XMMWORD PTR [rbp+0x170],xmm0
   185de74ec:	0f 29 b5 f0 00 00 00 	movaps XMMWORD PTR [rbp+0xf0],xmm6
   185de74f3:	49 8b 0e             	mov    rcx,QWORD PTR [r14]
   185de74f6:	c7 44 24 20 00 00 00 	mov    DWORD PTR [rsp+0x20],0x0
   185de74fd:	00 
   185de74fe:	4c 8d 05 bb ef 38 05 	lea    r8,[rip+0x538efbb]        # 0x18b1764c0
   185de7505:	4c 8d 0d d4 e4 56 05 	lea    r9,[rip+0x556e4d4]        # 0x18b3559e0
   185de750c:	31 ff                	xor    edi,edi
   185de750e:	31 d2                	xor    edx,edx
   185de7510:	e8 d7 c4 70 01       	call   0x1874f39ec
   185de7515:	90                   	nop
   185de7516:	48 85 c0             	test   rax,rax
   185de7519:	0f 84 c0 05 00 00    	je     0x185de7adf
   185de751f:	49 8b 4e 08          	mov    rcx,QWORD PTR [r14+0x8]
   185de7523:	48 85 c9             	test   rcx,rcx
   185de7526:	0f 84 ed 05 00 00    	je     0x185de7b19
   185de752c:	f0 ff 41 08          	lock inc DWORD PTR [rcx+0x8]
   185de7530:	49 8b 4e 08          	mov    rcx,QWORD PTR [r14+0x8]
   185de7534:	e9 e2 05 00 00       	jmp    0x185de7b1b
   185de7539:	49 8d 4e 01          	lea    rcx,[r14+0x1]
   185de753d:	e8 5a 43 6c 01       	call   0x1874ab89c
   185de7542:	90                   	nop
   185de7543:	48 89 45 e0          	mov    QWORD PTR [rbp-0x20],rax
   185de7547:	48 89 7d f0          	mov    QWORD PTR [rbp-0x10],rdi
   185de754b:	4c 89 75 f8          	mov    QWORD PTR [rbp-0x8],r14
   185de754f:	48 ff c7             	inc    rdi
   185de7552:	48 89 c1             	mov    rcx,rax
   185de7555:	48 89 da             	mov    rdx,rbx
   185de7558:	49 89 f8             	mov    r8,rdi
   185de755b:	e8 f0 ca 75 01       	call   0x187544050
   185de7560:	48 8b 7d f0          	mov    rdi,QWORD PTR [rbp-0x10]
   185de7564:	48 85 ff             	test   rdi,rdi
   185de7567:	0f 84 c1 01 00 00    	je     0x185de772e
   185de756d:	e8 9e e7 25 fa       	call   0x180045d10
   185de7572:	90                   	nop
   185de7573:	4c 8b 00             	mov    r8,QWORD PTR [rax]
   185de7576:	48 8d 95 80 01 00 00 	lea    rdx,[rbp+0x180]
   185de757d:	48 89 c1             	mov    rcx,rax
   185de7580:	41 ff 50 60          	call   QWORD PTR [r8+0x60]
   185de7584:	90                   	nop
   185de7585:	48 8b 8d 80 01 00 00 	mov    rcx,QWORD PTR [rbp+0x180]
   185de758c:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   185de758f:	48 8d 95 70 01 00 00 	lea    rdx,[rbp+0x170]
   185de7596:	ff 50 30             	call   QWORD PTR [rax+0x30]
   185de7599:	90                   	nop
   185de759a:	48 8b 8d 70 01 00 00 	mov    rcx,QWORD PTR [rbp+0x170]
   185de75a1:	48 8d 05 30 b8 fa 02 	lea    rax,[rip+0x2fab830]        # 0x188d92dd8
   185de75a8:	48 89 45 c8          	mov    QWORD PTR [rbp-0x38],rax
   185de75ac:	0f 29 b5 f0 00 00 00 	movaps XMMWORD PTR [rbp+0xf0],xmm6
   185de75b3:	48 8d 95 f0 00 00 00 	lea    rdx,[rbp+0xf0]
   185de75ba:	4c 8d 45 c8          	lea    r8,[rbp-0x38]
   185de75be:	e8 bd 74 3b fa       	call   0x18019ea80
   185de75c3:	90                   	nop
   185de75c4:	48 8b 85 f0 00 00 00 	mov    rax,QWORD PTR [rbp+0xf0]
   185de75cb:	48 8b 8d f8 00 00 00 	mov    rcx,QWORD PTR [rbp+0xf8]
   185de75d2:	48 85 c9             	test   rcx,rcx
   185de75d5:	74 3d                	je     0x185de7614
   185de75d7:	f0 ff 41 08          	lock inc DWORD PTR [rcx+0x8]
   185de75db:	48 8b bd f8 00 00 00 	mov    rdi,QWORD PTR [rbp+0xf8]
   185de75e2:	48 89 85 90 01 00 00 	mov    QWORD PTR [rbp+0x190],rax
   185de75e9:	48 89 bd 98 01 00 00 	mov    QWORD PTR [rbp+0x198],rdi
   185de75f0:	48 85 ff             	test   rdi,rdi
   185de75f3:	74 31                	je     0x185de7626
   185de75f5:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   185de75f9:	75 2b                	jne    0x185de7626
   185de75fb:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185de75fe:	48 89 f9             	mov    rcx,rdi
   185de7601:	ff 10                	call   QWORD PTR [rax]
   185de7603:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   185de7607:	75 1d                	jne    0x185de7626
   185de7609:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185de760c:	48 89 f9             	mov    rcx,rdi
   185de760f:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185de7612:	eb 12                	jmp    0x185de7626
   185de7614:	48 89 85 90 01 00 00 	mov    QWORD PTR [rbp+0x190],rax
   185de761b:	48 c7 85 98 01 00 00 	mov    QWORD PTR [rbp+0x198],0x0
   185de7622:	00 00 00 00 
   185de7626:	48 8b 8d 90 01 00 00 	mov    rcx,QWORD PTR [rbp+0x190]
   185de762d:	48 8d 55 70          	lea    rdx,[rbp+0x70]
   185de7631:	4c 8d 45 e0          	lea    r8,[rbp-0x20]
   185de7635:	e8 56 9f 8f fa       	call   0x1806e1590
   185de763a:	90                   	nop
   185de763b:	48 8b 85 58 01 00 00 	mov    rax,QWORD PTR [rbp+0x158]
   185de7642:	48 83 f8 10          	cmp    rax,0x10
   185de7646:	72 38                	jb     0x185de7680
   185de7648:	48 8b 8d 40 01 00 00 	mov    rcx,QWORD PTR [rbp+0x140]
   185de764f:	48 8d 50 01          	lea    rdx,[rax+0x1]
   185de7653:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185de765a:	72 1f                	jb     0x185de767b
   185de765c:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   185de7660:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   185de7664:	4c 29 c1             	sub    rcx,r8
   185de7667:	48 83 f9 20          	cmp    rcx,0x20
   185de766b:	0f 83 18 06 00 00    	jae    0x185de7c89
   185de7671:	48 83 c0 28          	add    rax,0x28
   185de7675:	48 89 c2             	mov    rdx,rax
   185de7678:	4c 89 c1             	mov    rcx,r8
   185de767b:	e8 60 42 6c 01       	call   0x1874ab8e0
   185de7680:	0f 10 45 70          	movups xmm0,XMMWORD PTR [rbp+0x70]
   185de7684:	0f 10 8d 80 00 00 00 	movups xmm1,XMMWORD PTR [rbp+0x80]
   185de768b:	0f 29 8d 50 01 00 00 	movaps XMMWORD PTR [rbp+0x150],xmm1
   185de7692:	0f 29 85 40 01 00 00 	movaps XMMWORD PTR [rbp+0x140],xmm0
   185de7699:	48 c7 85 80 00 00 00 	mov    QWORD PTR [rbp+0x80],0x0
   185de76a0:	00 00 00 00 
   185de76a4:	48 c7 85 88 00 00 00 	mov    QWORD PTR [rbp+0x88],0xf
   185de76ab:	0f 00 00 00 
   185de76af:	c6 45 70 00          	mov    BYTE PTR [rbp+0x70],0x0
   185de76b3:	48 8b bd 98 01 00 00 	mov    rdi,QWORD PTR [rbp+0x198]
   185de76ba:	48 85 ff             	test   rdi,rdi
   185de76bd:	74 1d                	je     0x185de76dc
   185de76bf:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   185de76c3:	75 17                	jne    0x185de76dc
   185de76c5:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185de76c8:	48 89 f9             	mov    rcx,rdi
   185de76cb:	ff 10                	call   QWORD PTR [rax]
   185de76cd:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   185de76d1:	75 09                	jne    0x185de76dc
   185de76d3:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185de76d6:	48 89 f9             	mov    rcx,rdi
   185de76d9:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185de76dc:	48 8b bd 78 01 00 00 	mov    rdi,QWORD PTR [rbp+0x178]
   185de76e3:	48 85 ff             	test   rdi,rdi
   185de76e6:	74 1d                	je     0x185de7705
   185de76e8:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   185de76ec:	75 17                	jne    0x185de7705
   185de76ee:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185de76f1:	48 89 f9             	mov    rcx,rdi
   185de76f4:	ff 10                	call   QWORD PTR [rax]
   185de76f6:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   185de76fa:	75 09                	jne    0x185de7705
   185de76fc:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185de76ff:	48 89 f9             	mov    rcx,rdi
   185de7702:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185de7705:	48 8b bd 88 01 00 00 	mov    rdi,QWORD PTR [rbp+0x188]
   185de770c:	48 85 ff             	test   rdi,rdi
   185de770f:	74 1d                	je     0x185de772e
   185de7711:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   185de7715:	75 17                	jne    0x185de772e
   185de7717:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185de771a:	48 89 f9             	mov    rcx,rdi
   185de771d:	ff 10                	call   QWORD PTR [rax]
   185de771f:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   185de7723:	75 09                	jne    0x185de772e
   185de7725:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185de7728:	48 89 f9             	mov    rcx,rdi
   185de772b:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185de772e:	48 8b 85 d0 01 00 00 	mov    rax,QWORD PTR [rbp+0x1d0]
   185de7735:	8b b8 14 07 00 00    	mov    edi,DWORD PTR [rax+0x714]
   185de773b:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
   185de773f:	48 83 f8 10          	cmp    rax,0x10
   185de7743:	72 35                	jb     0x185de777a
   185de7745:	48 8b 4d e0          	mov    rcx,QWORD PTR [rbp-0x20]
   185de7749:	48 8d 50 01          	lea    rdx,[rax+0x1]
   185de774d:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185de7754:	72 1f                	jb     0x185de7775
   185de7756:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   185de775a:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   185de775e:	4c 29 c1             	sub    rcx,r8
   185de7761:	48 83 f9 20          	cmp    rcx,0x20
   185de7765:	0f 83 1e 05 00 00    	jae    0x185de7c89
   185de776b:	48 83 c0 28          	add    rax,0x28
   185de776f:	48 89 c2             	mov    rdx,rax
   185de7772:	4c 89 c1             	mov    rcx,r8
   185de7775:	e8 66 41 6c 01       	call   0x1874ab8e0
   185de777a:	48 8b 9d d8 01 00 00 	mov    rbx,QWORD PTR [rbp+0x1d8]
   185de7781:	48 85 db             	test   rbx,rbx
   185de7784:	74 1d                	je     0x185de77a3
   185de7786:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   185de778a:	75 17                	jne    0x185de77a3
   185de778c:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185de778f:	48 89 d9             	mov    rcx,rbx
   185de7792:	ff 10                	call   QWORD PTR [rax]
   185de7794:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   185de7798:	75 09                	jne    0x185de77a3
   185de779a:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185de779d:	48 89 d9             	mov    rcx,rbx
   185de77a0:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185de77a3:	4c 8b b5 c8 01 00 00 	mov    r14,QWORD PTR [rbp+0x1c8]
   185de77aa:	48 8b 9d b8 01 00 00 	mov    rbx,QWORD PTR [rbp+0x1b8]
   185de77b1:	48 85 db             	test   rbx,rbx
   185de77b4:	0f 84 08 f3 ff ff    	je     0x185de6ac2
   185de77ba:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   185de77be:	0f 85 fe f2 ff ff    	jne    0x185de6ac2
   185de77c4:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185de77c7:	48 89 d9             	mov    rcx,rbx
   185de77ca:	ff 10                	call   QWORD PTR [rax]
   185de77cc:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   185de77d0:	0f 85 ec f2 ff ff    	jne    0x185de6ac2
   185de77d6:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185de77d9:	48 89 d9             	mov    rcx,rbx
   185de77dc:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185de77df:	e9 de f2 ff ff       	jmp    0x185de6ac2
   185de77e4:	31 c9                	xor    ecx,ecx
   185de77e6:	48 89 85 70 01 00 00 	mov    QWORD PTR [rbp+0x170],rax
   185de77ed:	48 89 8d 78 01 00 00 	mov    QWORD PTR [rbp+0x178],rcx
   185de77f4:	0f 29 b5 80 01 00 00 	movaps XMMWORD PTR [rbp+0x180],xmm6
   185de77fb:	48 8d 95 80 01 00 00 	lea    rdx,[rbp+0x180]
   185de7802:	48 89 c1             	mov    rcx,rax
   185de7805:	e8 06 a2 44 fc       	call   0x182231a10
   185de780a:	90                   	nop
   185de780b:	48 8b 85 80 01 00 00 	mov    rax,QWORD PTR [rbp+0x180]
   185de7812:	48 85 c0             	test   rax,rax
   185de7815:	0f 84 92 02 00 00    	je     0x185de7aad
   185de781b:	4c 8d 88 10 01 00 00 	lea    r9,[rax+0x110]
   185de7822:	48 8d 9d 40 01 00 00 	lea    rbx,[rbp+0x140]
   185de7829:	4c 39 cb             	cmp    rbx,r9
   185de782c:	74 5c                	je     0x185de788a
   185de782e:	48 8b b8 20 01 00 00 	mov    rdi,QWORD PTR [rax+0x120]
   185de7835:	48 83 b8 28 01 00 00 	cmp    QWORD PTR [rax+0x128],0x10
   185de783c:	10 
   185de783d:	72 07                	jb     0x185de7846
   185de783f:	4c 8b 88 10 01 00 00 	mov    r9,QWORD PTR [rax+0x110]
   185de7846:	48 8b 85 58 01 00 00 	mov    rax,QWORD PTR [rbp+0x158]
   185de784d:	48 39 c7             	cmp    rdi,rax
   185de7850:	76 12                	jbe    0x185de7864
   185de7852:	48 8d 8d 40 01 00 00 	lea    rcx,[rbp+0x140]
   185de7859:	48 89 fa             	mov    rdx,rdi
   185de785c:	e8 ef 68 25 fa       	call   0x18003e150
   185de7861:	90                   	nop
   185de7862:	eb 26                	jmp    0x185de788a
   185de7864:	48 83 f8 10          	cmp    rax,0x10
   185de7868:	72 07                	jb     0x185de7871
   185de786a:	48 8b 9d 40 01 00 00 	mov    rbx,QWORD PTR [rbp+0x140]
   185de7871:	48 89 bd 50 01 00 00 	mov    QWORD PTR [rbp+0x150],rdi
   185de7878:	48 89 d9             	mov    rcx,rbx
   185de787b:	4c 89 ca             	mov    rdx,r9
   185de787e:	49 89 f8             	mov    r8,rdi
   185de7881:	e8 ca c7 75 01       	call   0x187544050
   185de7886:	c6 04 3b 00          	mov    BYTE PTR [rbx+rdi*1],0x0
   185de788a:	48 8b bd 80 01 00 00 	mov    rdi,QWORD PTR [rbp+0x180]
   185de7891:	0f 57 c0             	xorps  xmm0,xmm0
   185de7894:	0f 29 85 d0 01 00 00 	movaps XMMWORD PTR [rbp+0x1d0],xmm0
   185de789b:	0f 29 85 e0 01 00 00 	movaps XMMWORD PTR [rbp+0x1e0],xmm0
   185de78a2:	48 8b 9f 80 01 00 00 	mov    rbx,QWORD PTR [rdi+0x180]
   185de78a9:	48 83 bf 88 01 00 00 	cmp    QWORD PTR [rdi+0x188],0x10
   185de78b0:	10 
   185de78b1:	72 09                	jb     0x185de78bc
   185de78b3:	48 8b bf 70 01 00 00 	mov    rdi,QWORD PTR [rdi+0x170]
   185de78ba:	eb 07                	jmp    0x185de78c3
   185de78bc:	48 81 c7 70 01 00 00 	add    rdi,0x170
   185de78c3:	48 85 db             	test   rbx,rbx
   185de78c6:	0f 88 cf 03 00 00    	js     0x185de7c9b
   185de78cc:	48 83 fb 0f          	cmp    rbx,0xf
   185de78d0:	77 1e                	ja     0x185de78f0
   185de78d2:	48 89 9d e0 01 00 00 	mov    QWORD PTR [rbp+0x1e0],rbx
   185de78d9:	48 c7 85 e8 01 00 00 	mov    QWORD PTR [rbp+0x1e8],0xf
   185de78e0:	0f 00 00 00 
   185de78e4:	0f 10 07             	movups xmm0,XMMWORD PTR [rdi]
   185de78e7:	0f 29 85 d0 01 00 00 	movaps XMMWORD PTR [rbp+0x1d0],xmm0
   185de78ee:	eb 71                	jmp    0x185de7961
   185de78f0:	48 89 d8             	mov    rax,rbx
   185de78f3:	48 83 c8 0f          	or     rax,0xf
   185de78f7:	48 83 f8 17          	cmp    rax,0x17
   185de78fb:	41 be 16 00 00 00    	mov    r14d,0x16
   185de7901:	4c 0f 43 f0          	cmovae r14,rax
   185de7905:	48 3d ff 0f 00 00    	cmp    rax,0xfff
   185de790b:	72 24                	jb     0x185de7931
   185de790d:	49 8d 4e 28          	lea    rcx,[r14+0x28]
   185de7911:	e8 86 3f 6c 01       	call   0x1874ab89c
   185de7916:	90                   	nop
   185de7917:	48 85 c0             	test   rax,rax
   185de791a:	0f 84 69 03 00 00    	je     0x185de7c89
   185de7920:	48 89 c1             	mov    rcx,rax
   185de7923:	48 83 c0 27          	add    rax,0x27
   185de7927:	48 83 e0 e0          	and    rax,0xffffffffffffffe0
   185de792b:	48 89 48 f8          	mov    QWORD PTR [rax-0x8],rcx
   185de792f:	eb 0a                	jmp    0x185de793b
   185de7931:	49 8d 4e 01          	lea    rcx,[r14+0x1]
   185de7935:	e8 62 3f 6c 01       	call   0x1874ab89c
   185de793a:	90                   	nop
   185de793b:	48 89 85 d0 01 00 00 	mov    QWORD PTR [rbp+0x1d0],rax
   185de7942:	48 89 9d e0 01 00 00 	mov    QWORD PTR [rbp+0x1e0],rbx
   185de7949:	4c 89 b5 e8 01 00 00 	mov    QWORD PTR [rbp+0x1e8],r14
   185de7950:	48 ff c3             	inc    rbx
   185de7953:	48 89 c1             	mov    rcx,rax
   185de7956:	48 89 fa             	mov    rdx,rdi
   185de7959:	49 89 d8             	mov    r8,rbx
   185de795c:	e8 ef c6 75 01       	call   0x187544050
   185de7961:	b9 02 00 00 00       	mov    ecx,0x2
   185de7966:	e8 75 54 28 fa       	call   0x18006cde0
   185de796b:	85 c0                	test   eax,eax
   185de796d:	0f 84 f5 00 00 00    	je     0x185de7a68
   185de7973:	48 8d bd 90 01 00 00 	lea    rdi,[rbp+0x190]
   185de797a:	48 89 f9             	mov    rcx,rdi
   185de797d:	e8 8e 55 28 fa       	call   0x18006cf10
   185de7982:	90                   	nop
   185de7983:	48 83 bd a8 01 00 00 	cmp    QWORD PTR [rbp+0x1a8],0x10
   185de798a:	10 
   185de798b:	72 07                	jb     0x185de7994
   185de798d:	48 8b bd 90 01 00 00 	mov    rdi,QWORD PTR [rbp+0x190]
   185de7994:	48 8d 05 d5 31 b5 03 	lea    rax,[rip+0x3b531d5]        # 0x18993ab70
   185de799b:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   185de79a0:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   185de79a7:	00 00 
   185de79a9:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   185de79ae:	c7 44 24 28 4e 00 00 	mov    DWORD PTR [rsp+0x28],0x4e
   185de79b5:	00 
   185de79b6:	4c 8d 0d 53 32 b5 03 	lea    r9,[rip+0x3b53253]        # 0x18993ac10
   185de79bd:	48 8d 4d e0          	lea    rcx,[rbp-0x20]
   185de79c1:	ba 02 00 00 00       	mov    edx,0x2
   185de79c6:	49 89 f8             	mov    r8,rdi
   185de79c9:	e8 a2 58 28 fa       	call   0x18006d270
   185de79ce:	90                   	nop
   185de79cf:	48 83 bd e8 01 00 00 	cmp    QWORD PTR [rbp+0x1e8],0x10
   185de79d6:	10 
   185de79d7:	72 09                	jb     0x185de79e2
   185de79d9:	48 8b 85 d0 01 00 00 	mov    rax,QWORD PTR [rbp+0x1d0]
   185de79e0:	eb 07                	jmp    0x185de79e9
   185de79e2:	48 8d 85 d0 01 00 00 	lea    rax,[rbp+0x1d0]
   185de79e9:	48 89 85 f0 00 00 00 	mov    QWORD PTR [rbp+0xf0],rax
   185de79f0:	c6 85 f8 00 00 00 00 	mov    BYTE PTR [rbp+0xf8],0x0
   185de79f7:	0f 57 c0             	xorps  xmm0,xmm0
   185de79fa:	0f 11 85 d8 00 00 00 	movups XMMWORD PTR [rbp+0xd8],xmm0
   185de7a01:	0f 11 85 c8 00 00 00 	movups XMMWORD PTR [rbp+0xc8],xmm0
   185de7a08:	0f 11 85 b8 00 00 00 	movups XMMWORD PTR [rbp+0xb8],xmm0
   185de7a0f:	0f 11 85 a8 00 00 00 	movups XMMWORD PTR [rbp+0xa8],xmm0
   185de7a16:	0f 11 85 98 00 00 00 	movups XMMWORD PTR [rbp+0x98],xmm0
   185de7a1d:	0f 11 85 88 00 00 00 	movups XMMWORD PTR [rbp+0x88],xmm0
   185de7a24:	0f 11 45 78          	movups XMMWORD PTR [rbp+0x78],xmm0
   185de7a28:	48 c7 85 e8 00 00 00 	mov    QWORD PTR [rbp+0xe8],0x0
   185de7a2f:	00 00 00 00 
   185de7a33:	48 8d 85 f0 00 00 00 	lea    rax,[rbp+0xf0]
   185de7a3a:	48 89 45 70          	mov    QWORD PTR [rbp+0x70],rax
   185de7a3e:	48 8d 15 ab 31 b5 03 	lea    rdx,[rip+0x3b531ab]        # 0x18993abf0
   185de7a45:	48 8d 4d e0          	lea    rcx,[rbp-0x20]
   185de7a49:	4c 8d 45 70          	lea    r8,[rbp+0x70]
   185de7a4d:	e8 be 5d 28 fa       	call   0x18006d810
   185de7a52:	90                   	nop
   185de7a53:	48 8d 4d e0          	lea    rcx,[rbp-0x20]
   185de7a57:	e8 14 59 28 fa       	call   0x18006d370
   185de7a5c:	48 8d 8d 90 01 00 00 	lea    rcx,[rbp+0x190]
   185de7a63:	e8 a8 a5 21 fa       	call   0x180002010
   185de7a68:	48 8b 85 e8 01 00 00 	mov    rax,QWORD PTR [rbp+0x1e8]
   185de7a6f:	48 83 f8 10          	cmp    rax,0x10
   185de7a73:	72 38                	jb     0x185de7aad
   185de7a75:	48 8b 8d d0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1d0]
   185de7a7c:	48 8d 50 01          	lea    rdx,[rax+0x1]
   185de7a80:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185de7a87:	72 1f                	jb     0x185de7aa8
   185de7a89:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   185de7a8d:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   185de7a91:	4c 29 c1             	sub    rcx,r8
   185de7a94:	48 83 f9 20          	cmp    rcx,0x20
   185de7a98:	0f 83 eb 01 00 00    	jae    0x185de7c89
   185de7a9e:	48 83 c0 28          	add    rax,0x28
   185de7aa2:	48 89 c2             	mov    rdx,rax
   185de7aa5:	4c 89 c1             	mov    rcx,r8
   185de7aa8:	e8 33 3e 6c 01       	call   0x1874ab8e0
   185de7aad:	48 8b bd 88 01 00 00 	mov    rdi,QWORD PTR [rbp+0x188]
   185de7ab4:	48 85 ff             	test   rdi,rdi
   185de7ab7:	74 1d                	je     0x185de7ad6
   185de7ab9:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   185de7abd:	75 17                	jne    0x185de7ad6
   185de7abf:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185de7ac2:	48 89 f9             	mov    rcx,rdi
   185de7ac5:	ff 10                	call   QWORD PTR [rax]
   185de7ac7:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   185de7acb:	75 09                	jne    0x185de7ad6
   185de7acd:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185de7ad0:	48 89 f9             	mov    rcx,rdi
   185de7ad3:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185de7ad6:	31 ff                	xor    edi,edi
   185de7ad8:	4c 8b b5 c8 01 00 00 	mov    r14,QWORD PTR [rbp+0x1c8]
   185de7adf:	48 8b 9d 78 01 00 00 	mov    rbx,QWORD PTR [rbp+0x178]
   185de7ae6:	48 85 db             	test   rbx,rbx
   185de7ae9:	0f 84 bb fc ff ff    	je     0x185de77aa
   185de7aef:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   185de7af3:	0f 85 b1 fc ff ff    	jne    0x185de77aa
   185de7af9:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185de7afc:	48 89 d9             	mov    rcx,rbx
   185de7aff:	ff 10                	call   QWORD PTR [rax]
   185de7b01:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   185de7b05:	0f 85 9f fc ff ff    	jne    0x185de77aa
   185de7b0b:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185de7b0e:	48 89 d9             	mov    rcx,rbx
   185de7b11:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185de7b14:	e9 91 fc ff ff       	jmp    0x185de77aa
   185de7b19:	31 c9                	xor    ecx,ecx
   185de7b1b:	48 89 85 f0 00 00 00 	mov    QWORD PTR [rbp+0xf0],rax
   185de7b22:	48 89 8d f8 00 00 00 	mov    QWORD PTR [rbp+0xf8],rcx
   185de7b29:	0f 29 b5 d0 01 00 00 	movaps XMMWORD PTR [rbp+0x1d0],xmm6
   185de7b30:	48 8d 95 d0 01 00 00 	lea    rdx,[rbp+0x1d0]
   185de7b37:	48 89 c1             	mov    rcx,rax
   185de7b3a:	e8 d1 9e 44 fc       	call   0x182231a10
   185de7b3f:	90                   	nop
   185de7b40:	48 8b 8d d0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1d0]
   185de7b47:	48 85 c9             	test   rcx,rcx
   185de7b4a:	0f 84 cd 00 00 00    	je     0x185de7c1d
   185de7b50:	0f 29 75 f0          	movaps XMMWORD PTR [rbp-0x10],xmm6
   185de7b54:	0f 29 75 e0          	movaps XMMWORD PTR [rbp-0x20],xmm6
   185de7b58:	e8 63 cc 0d fd       	call   0x182ec47c0
   185de7b5d:	90                   	nop
   185de7b5e:	48 8d 4d e0          	lea    rcx,[rbp-0x20]
   185de7b62:	48 89 c2             	mov    rdx,rax
   185de7b65:	e8 c2 42 6c 01       	call   0x1874abe2c
   185de7b6a:	90                   	nop
   185de7b6b:	48 83 7d f0 00       	cmp    QWORD PTR [rbp-0x10],0x0
   185de7b70:	0f 84 8c 00 00 00    	je     0x185de7c02
   185de7b76:	e8 95 e1 25 fa       	call   0x180045d10
   185de7b7b:	90                   	nop
   185de7b7c:	4c 8b 00             	mov    r8,QWORD PTR [rax]
   185de7b7f:	48 8d 55 c8          	lea    rdx,[rbp-0x38]
   185de7b83:	48 89 c1             	mov    rcx,rax
   185de7b86:	41 ff 50 60          	call   QWORD PTR [r8+0x60]
   185de7b8a:	90                   	nop
   185de7b8b:	48 8b 4d c8          	mov    rcx,QWORD PTR [rbp-0x38]
   185de7b8f:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   185de7b92:	48 8d 95 80 01 00 00 	lea    rdx,[rbp+0x180]
   185de7b99:	ff 50 30             	call   QWORD PTR [rax+0x30]
   185de7b9c:	90                   	nop
   185de7b9d:	48 8b 8d 80 01 00 00 	mov    rcx,QWORD PTR [rbp+0x180]
   185de7ba4:	48 8d 95 90 01 00 00 	lea    rdx,[rbp+0x190]
   185de7bab:	e8 40 ef 0c fe       	call   0x183eb6af0
   185de7bb0:	90                   	nop
   185de7bb1:	48 8b 8d 90 01 00 00 	mov    rcx,QWORD PTR [rbp+0x190]
   185de7bb8:	48 8d 55 70          	lea    rdx,[rbp+0x70]
   185de7bbc:	4c 8d 45 e0          	lea    r8,[rbp-0x20]
   185de7bc0:	e8 cb 99 8f fa       	call   0x1806e1590
   185de7bc5:	90                   	nop
   185de7bc6:	48 8d 8d 40 01 00 00 	lea    rcx,[rbp+0x140]
   185de7bcd:	48 8d 7d 70          	lea    rdi,[rbp+0x70]
   185de7bd1:	48 89 fa             	mov    rdx,rdi
   185de7bd4:	e8 47 ba 31 fa       	call   0x180103620
   185de7bd9:	48 89 f9             	mov    rcx,rdi
   185de7bdc:	e8 2f a4 21 fa       	call   0x180002010
   185de7be1:	48 8d 8d 90 01 00 00 	lea    rcx,[rbp+0x190]
   185de7be8:	e8 73 a4 21 fa       	call   0x180002060
   185de7bed:	48 8d 8d 80 01 00 00 	lea    rcx,[rbp+0x180]
   185de7bf4:	e8 67 a4 21 fa       	call   0x180002060
   185de7bf9:	48 8d 4d c8          	lea    rcx,[rbp-0x38]
   185de7bfd:	e8 5e a4 21 fa       	call   0x180002060
   185de7c02:	48 8b 8d d0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1d0]
   185de7c09:	e8 f2 28 76 fa       	call   0x18054a500
   185de7c0e:	90                   	nop
   185de7c0f:	48 89 c7             	mov    rdi,rax
   185de7c12:	48 8d 4d e0          	lea    rcx,[rbp-0x20]
   185de7c16:	e8 f5 a3 21 fa       	call   0x180002010
   185de7c1b:	eb 02                	jmp    0x185de7c1f
   185de7c1d:	31 ff                	xor    edi,edi
   185de7c1f:	48 8b 9d d8 01 00 00 	mov    rbx,QWORD PTR [rbp+0x1d8]
   185de7c26:	48 85 db             	test   rbx,rbx
   185de7c29:	4c 8b b5 c8 01 00 00 	mov    r14,QWORD PTR [rbp+0x1c8]
   185de7c30:	74 1d                	je     0x185de7c4f
   185de7c32:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   185de7c36:	75 17                	jne    0x185de7c4f
   185de7c38:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185de7c3b:	48 89 d9             	mov    rcx,rbx
   185de7c3e:	ff 10                	call   QWORD PTR [rax]
   185de7c40:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   185de7c44:	75 09                	jne    0x185de7c4f
   185de7c46:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185de7c49:	48 89 d9             	mov    rcx,rbx
   185de7c4c:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185de7c4f:	48 8b 9d f8 00 00 00 	mov    rbx,QWORD PTR [rbp+0xf8]
   185de7c56:	48 85 db             	test   rbx,rbx
   185de7c59:	0f 84 80 fe ff ff    	je     0x185de7adf
   185de7c5f:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   185de7c63:	0f 85 76 fe ff ff    	jne    0x185de7adf
   185de7c69:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185de7c6c:	48 89 d9             	mov    rcx,rbx
   185de7c6f:	ff 10                	call   QWORD PTR [rax]
   185de7c71:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   185de7c75:	0f 85 64 fe ff ff    	jne    0x185de7adf
   185de7c7b:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185de7c7e:	48 89 d9             	mov    rcx,rbx
   185de7c81:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185de7c84:	e9 56 fe ff ff       	jmp    0x185de7adf
   185de7c89:	e8 fe 56 72 01       	call   0x18750d38c
   185de7c8e:	90                   	nop
   185de7c8f:	e8 fc 0e 22 fa       	call   0x180008b90
   185de7c94:	90                   	nop
   185de7c95:	e8 f6 0e 22 fa       	call   0x180008b90
   185de7c9a:	90                   	nop
   185de7c9b:	e8 f0 0e 22 fa       	call   0x180008b90
   185de7ca0:	90                   	nop
   185de7ca1:	cc                   	int3
