
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

000000018483c560 <.text+0x483b560>:
   18483c560:	55                   	push   rbp
   18483c561:	41 57                	push   r15
   18483c563:	41 56                	push   r14
   18483c565:	56                   	push   rsi
   18483c566:	57                   	push   rdi
   18483c567:	53                   	push   rbx
   18483c568:	48 81 ec 98 03 00 00 	sub    rsp,0x398
   18483c56f:	48 8d ac 24 80 00 00 	lea    rbp,[rsp+0x80]
   18483c576:	00 
   18483c577:	0f 29 b5 00 03 00 00 	movaps XMMWORD PTR [rbp+0x300],xmm6
   18483c57e:	48 c7 85 f8 02 00 00 	mov    QWORD PTR [rbp+0x2f8],0xfffffffffffffffe
   18483c585:	fe ff ff ff 
   18483c589:	4c 89 85 d8 02 00 00 	mov    QWORD PTR [rbp+0x2d8],r8
   18483c590:	48 89 95 d0 02 00 00 	mov    QWORD PTR [rbp+0x2d0],rdx
   18483c597:	48 89 ce             	mov    rsi,rcx
   18483c59a:	0f 57 c0             	xorps  xmm0,xmm0
   18483c59d:	0f 29 85 b0 02 00 00 	movaps XMMWORD PTR [rbp+0x2b0],xmm0
   18483c5a4:	48 c7 85 c0 02 00 00 	mov    QWORD PTR [rbp+0x2c0],0x0
   18483c5ab:	00 00 00 00 
   18483c5af:	0f 28 35 fa 95 50 04 	movaps xmm6,XMMWORD PTR [rip+0x45095fa]        # 0x188d45bb0
   18483c5b6:	0f 29 b5 e0 02 00 00 	movaps XMMWORD PTR [rbp+0x2e0],xmm6
   18483c5bd:	48 8d 8d e0 02 00 00 	lea    rcx,[rbp+0x2e0]
   18483c5c4:	e8 a7 86 eb fb       	call   0x1806f4c70
   18483c5c9:	90                   	nop
   18483c5ca:	48 8b 85 e0 02 00 00 	mov    rax,QWORD PTR [rbp+0x2e0]
   18483c5d1:	c7 80 18 01 00 00 01 	mov    DWORD PTR [rax+0x118],0x1
   18483c5d8:	00 00 00 
   18483c5db:	48 8d b8 58 07 00 00 	lea    rdi,[rax+0x758]
   18483c5e2:	48 39 f7             	cmp    rdi,rsi
   18483c5e5:	74 4d                	je     0x18483c634
   18483c5e7:	48 8b 5e 10          	mov    rbx,QWORD PTR [rsi+0x10]
   18483c5eb:	48 83 7e 18 10       	cmp    QWORD PTR [rsi+0x18],0x10
   18483c5f0:	49 89 f1             	mov    r9,rsi
   18483c5f3:	72 03                	jb     0x18483c5f8
   18483c5f5:	4c 8b 0e             	mov    r9,QWORD PTR [rsi]
   18483c5f8:	48 8b 88 70 07 00 00 	mov    rcx,QWORD PTR [rax+0x770]
   18483c5ff:	48 39 cb             	cmp    rbx,rcx
   18483c602:	76 0e                	jbe    0x18483c612
   18483c604:	48 89 f9             	mov    rcx,rdi
   18483c607:	48 89 da             	mov    rdx,rbx
   18483c60a:	e8 41 1b 80 fb       	call   0x18003e150
   18483c60f:	90                   	nop
   18483c610:	eb 22                	jmp    0x18483c634
   18483c612:	48 83 f9 10          	cmp    rcx,0x10
   18483c616:	72 03                	jb     0x18483c61b
   18483c618:	48 8b 3f             	mov    rdi,QWORD PTR [rdi]
   18483c61b:	48 89 98 68 07 00 00 	mov    QWORD PTR [rax+0x768],rbx
   18483c622:	48 89 f9             	mov    rcx,rdi
   18483c625:	4c 89 ca             	mov    rdx,r9
   18483c628:	49 89 d8             	mov    r8,rbx
   18483c62b:	e8 20 7a d0 02       	call   0x187544050
   18483c630:	c6 04 1f 00          	mov    BYTE PTR [rdi+rbx*1],0x0
   18483c634:	48 8b 4e 10          	mov    rcx,QWORD PTR [rsi+0x10]
   18483c638:	48 8b 85 e0 02 00 00 	mov    rax,QWORD PTR [rbp+0x2e0]
   18483c63f:	48 89 88 c8 01 00 00 	mov    QWORD PTR [rax+0x1c8],rcx
   18483c646:	0f 57 c0             	xorps  xmm0,xmm0
   18483c649:	0f 29 45 a0          	movaps XMMWORD PTR [rbp-0x60],xmm0
   18483c64d:	48 8b 8d e8 02 00 00 	mov    rcx,QWORD PTR [rbp+0x2e8]
   18483c654:	48 85 c9             	test   rcx,rcx
   18483c657:	74 14                	je     0x18483c66d
   18483c659:	f0 ff 41 08          	lock inc DWORD PTR [rcx+0x8]
   18483c65d:	48 8b 85 e0 02 00 00 	mov    rax,QWORD PTR [rbp+0x2e0]
   18483c664:	48 8b 8d e8 02 00 00 	mov    rcx,QWORD PTR [rbp+0x2e8]
   18483c66b:	eb 02                	jmp    0x18483c66f
   18483c66d:	31 c9                	xor    ecx,ecx
   18483c66f:	48 89 45 a0          	mov    QWORD PTR [rbp-0x60],rax
   18483c673:	48 89 4d a8          	mov    QWORD PTR [rbp-0x58],rcx
   18483c677:	48 8b 95 b8 02 00 00 	mov    rdx,QWORD PTR [rbp+0x2b8]
   18483c67e:	48 3b 95 c0 02 00 00 	cmp    rdx,QWORD PTR [rbp+0x2c0]
   18483c685:	74 41                	je     0x18483c6c8
   18483c687:	48 8b 45 a0          	mov    rax,QWORD PTR [rbp-0x60]
   18483c68b:	48 89 02             	mov    QWORD PTR [rdx],rax
   18483c68e:	48 8b 45 a8          	mov    rax,QWORD PTR [rbp-0x58]
   18483c692:	48 89 42 08          	mov    QWORD PTR [rdx+0x8],rax
   18483c696:	48 83 85 b8 02 00 00 	add    QWORD PTR [rbp+0x2b8],0x10
   18483c69d:	10 
   18483c69e:	0f 57 c0             	xorps  xmm0,xmm0
   18483c6a1:	0f 29 85 50 02 00 00 	movaps XMMWORD PTR [rbp+0x250],xmm0
   18483c6a8:	48 8b 85 e8 02 00 00 	mov    rax,QWORD PTR [rbp+0x2e8]
   18483c6af:	48 85 c0             	test   rax,rax
   18483c6b2:	48 8b 95 d0 02 00 00 	mov    rdx,QWORD PTR [rbp+0x2d0]
   18483c6b9:	74 46                	je     0x18483c701
   18483c6bb:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   18483c6bf:	48 8b 85 e8 02 00 00 	mov    rax,QWORD PTR [rbp+0x2e8]
   18483c6c6:	eb 3b                	jmp    0x18483c703
   18483c6c8:	48 8d 8d b0 02 00 00 	lea    rcx,[rbp+0x2b0]
   18483c6cf:	4c 8d 45 a0          	lea    r8,[rbp-0x60]
   18483c6d3:	e8 88 58 87 fc       	call   0x1810b1f60
   18483c6d8:	90                   	nop
   18483c6d9:	48 8b 75 a8          	mov    rsi,QWORD PTR [rbp-0x58]
   18483c6dd:	48 85 f6             	test   rsi,rsi
   18483c6e0:	74 bc                	je     0x18483c69e
   18483c6e2:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   18483c6e6:	75 b6                	jne    0x18483c69e
   18483c6e8:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   18483c6eb:	48 89 f1             	mov    rcx,rsi
   18483c6ee:	ff 10                	call   QWORD PTR [rax]
   18483c6f0:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   18483c6f4:	75 a8                	jne    0x18483c69e
   18483c6f6:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   18483c6f9:	48 89 f1             	mov    rcx,rsi
   18483c6fc:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18483c6ff:	eb 9d                	jmp    0x18483c69e
   18483c701:	31 c0                	xor    eax,eax
   18483c703:	48 8b 8d e0 02 00 00 	mov    rcx,QWORD PTR [rbp+0x2e0]
   18483c70a:	48 89 8d 50 02 00 00 	mov    QWORD PTR [rbp+0x250],rcx
   18483c711:	48 89 85 58 02 00 00 	mov    QWORD PTR [rbp+0x258],rax
   18483c718:	48 8d 8d 50 02 00 00 	lea    rcx,[rbp+0x250]
   18483c71f:	e8 4c a3 0d 00       	call   0x184916a70
   18483c724:	90                   	nop
   18483c725:	0f 29 b5 30 02 00 00 	movaps XMMWORD PTR [rbp+0x230],xmm6
   18483c72c:	0f 29 b5 20 02 00 00 	movaps XMMWORD PTR [rbp+0x220],xmm6
   18483c733:	0f 29 b5 10 02 00 00 	movaps XMMWORD PTR [rbp+0x210],xmm6
   18483c73a:	0f 29 b5 00 02 00 00 	movaps XMMWORD PTR [rbp+0x200],xmm6
   18483c741:	0f 29 b5 f0 01 00 00 	movaps XMMWORD PTR [rbp+0x1f0],xmm6
   18483c748:	0f 29 b5 e0 01 00 00 	movaps XMMWORD PTR [rbp+0x1e0],xmm6
   18483c74f:	0f 29 b5 d0 01 00 00 	movaps XMMWORD PTR [rbp+0x1d0],xmm6
   18483c756:	0f 29 b5 c0 01 00 00 	movaps XMMWORD PTR [rbp+0x1c0],xmm6
   18483c75d:	0f 29 b5 b0 01 00 00 	movaps XMMWORD PTR [rbp+0x1b0],xmm6
   18483c764:	0f 29 b5 a0 01 00 00 	movaps XMMWORD PTR [rbp+0x1a0],xmm6
   18483c76b:	0f 29 b5 90 01 00 00 	movaps XMMWORD PTR [rbp+0x190],xmm6
   18483c772:	0f 29 b5 80 01 00 00 	movaps XMMWORD PTR [rbp+0x180],xmm6
   18483c779:	0f 29 b5 70 01 00 00 	movaps XMMWORD PTR [rbp+0x170],xmm6
   18483c780:	0f 29 b5 60 01 00 00 	movaps XMMWORD PTR [rbp+0x160],xmm6
   18483c787:	0f 57 c0             	xorps  xmm0,xmm0
   18483c78a:	0f 29 85 50 01 00 00 	movaps XMMWORD PTR [rbp+0x150],xmm0
   18483c791:	48 8b 85 e8 02 00 00 	mov    rax,QWORD PTR [rbp+0x2e8]
   18483c798:	48 85 c0             	test   rax,rax
   18483c79b:	74 0d                	je     0x18483c7aa
   18483c79d:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   18483c7a1:	48 8b 85 e8 02 00 00 	mov    rax,QWORD PTR [rbp+0x2e8]
   18483c7a8:	eb 02                	jmp    0x18483c7ac
   18483c7aa:	31 c0                	xor    eax,eax
   18483c7ac:	4c 8b 85 d8 02 00 00 	mov    r8,QWORD PTR [rbp+0x2d8]
   18483c7b3:	48 8b 95 d0 02 00 00 	mov    rdx,QWORD PTR [rbp+0x2d0]
   18483c7ba:	48 8b 8d e0 02 00 00 	mov    rcx,QWORD PTR [rbp+0x2e0]
   18483c7c1:	48 89 8d 50 01 00 00 	mov    QWORD PTR [rbp+0x150],rcx
   18483c7c8:	48 89 85 58 01 00 00 	mov    QWORD PTR [rbp+0x158],rax
   18483c7cf:	48 8d 9d 60 01 00 00 	lea    rbx,[rbp+0x160]
   18483c7d6:	c6 85 f8 01 00 00 00 	mov    BYTE PTR [rbp+0x1f8],0x0
   18483c7dd:	80 ba 98 00 00 00 01 	cmp    BYTE PTR [rdx+0x98],0x1
   18483c7e4:	75 17                	jne    0x18483c7fd
   18483c7e6:	48 89 d9             	mov    rcx,rbx
   18483c7e9:	e8 d2 92 94 fd       	call   0x182185ac0
   18483c7ee:	90                   	nop
   18483c7ef:	c6 85 f8 01 00 00 01 	mov    BYTE PTR [rbp+0x1f8],0x1
   18483c7f6:	4c 8b 85 d8 02 00 00 	mov    r8,QWORD PTR [rbp+0x2d8]
   18483c7fd:	48 8d 95 00 02 00 00 	lea    rdx,[rbp+0x200]
   18483c804:	48 c7 85 38 02 00 00 	mov    QWORD PTR [rbp+0x238],0x0
   18483c80b:	00 00 00 00 
   18483c80f:	49 8b 48 38          	mov    rcx,QWORD PTR [r8+0x38]
   18483c813:	48 85 c9             	test   rcx,rcx
   18483c816:	74 64                	je     0x18483c87c
   18483c818:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18483c81b:	ff 10                	call   QWORD PTR [rax]
   18483c81d:	90                   	nop
   18483c81e:	48 89 85 38 02 00 00 	mov    QWORD PTR [rbp+0x238],rax
   18483c825:	48 8b 85 d8 02 00 00 	mov    rax,QWORD PTR [rbp+0x2d8]
   18483c82c:	48 8b 48 38          	mov    rcx,QWORD PTR [rax+0x38]
   18483c830:	48 b8 aa aa aa aa aa 	movabs rax,0xaaaaaaaaaaaaaaaa
   18483c837:	aa aa aa 
   18483c83a:	48 89 85 a0 02 00 00 	mov    QWORD PTR [rbp+0x2a0],rax
   18483c841:	0f 29 b5 90 02 00 00 	movaps XMMWORD PTR [rbp+0x290],xmm6
   18483c848:	0f 29 b5 80 02 00 00 	movaps XMMWORD PTR [rbp+0x280],xmm6
   18483c84f:	0f 29 b5 70 02 00 00 	movaps XMMWORD PTR [rbp+0x270],xmm6
   18483c856:	48 c7 85 a8 02 00 00 	mov    QWORD PTR [rbp+0x2a8],0x0
   18483c85d:	00 00 00 00 
   18483c861:	48 85 c9             	test   rcx,rcx
   18483c864:	74 47                	je     0x18483c8ad
   18483c866:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18483c869:	48 8d 95 70 02 00 00 	lea    rdx,[rbp+0x270]
   18483c870:	ff 10                	call   QWORD PTR [rax]
   18483c872:	90                   	nop
   18483c873:	48 89 85 a8 02 00 00 	mov    QWORD PTR [rbp+0x2a8],rax
   18483c87a:	eb 31                	jmp    0x18483c8ad
   18483c87c:	48 b8 aa aa aa aa aa 	movabs rax,0xaaaaaaaaaaaaaaaa
   18483c883:	aa aa aa 
   18483c886:	48 89 85 a0 02 00 00 	mov    QWORD PTR [rbp+0x2a0],rax
   18483c88d:	0f 29 b5 90 02 00 00 	movaps XMMWORD PTR [rbp+0x290],xmm6
   18483c894:	0f 29 b5 80 02 00 00 	movaps XMMWORD PTR [rbp+0x280],xmm6
   18483c89b:	0f 29 b5 70 02 00 00 	movaps XMMWORD PTR [rbp+0x270],xmm6
   18483c8a2:	48 c7 85 a8 02 00 00 	mov    QWORD PTR [rbp+0x2a8],0x0
   18483c8a9:	00 00 00 00 
   18483c8ad:	0f 57 c0             	xorps  xmm0,xmm0
   18483c8b0:	0f 29 85 60 02 00 00 	movaps XMMWORD PTR [rbp+0x260],xmm0
   18483c8b7:	48 8b 85 e8 02 00 00 	mov    rax,QWORD PTR [rbp+0x2e8]
   18483c8be:	48 85 c0             	test   rax,rax
   18483c8c1:	74 0d                	je     0x18483c8d0
   18483c8c3:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   18483c8c7:	48 8b 85 e8 02 00 00 	mov    rax,QWORD PTR [rbp+0x2e8]
   18483c8ce:	eb 02                	jmp    0x18483c8d2
   18483c8d0:	31 c0                	xor    eax,eax
   18483c8d2:	48 8b 8d e0 02 00 00 	mov    rcx,QWORD PTR [rbp+0x2e0]
   18483c8d9:	48 89 8d 60 02 00 00 	mov    QWORD PTR [rbp+0x260],rcx
   18483c8e0:	48 89 85 68 02 00 00 	mov    QWORD PTR [rbp+0x268],rax
   18483c8e7:	48 8d 4d a0          	lea    rcx,[rbp-0x60]
   18483c8eb:	48 8d 95 60 02 00 00 	lea    rdx,[rbp+0x260]
   18483c8f2:	e8 59 8e 91 fd       	call   0x182155750
   18483c8f7:	90                   	nop
   18483c8f8:	48 8d 4d a0          	lea    rcx,[rbp-0x60]
   18483c8fc:	31 d2                	xor    edx,edx
   18483c8fe:	e8 4d 22 94 fd       	call   0x18217eb50
   18483c903:	90                   	nop
   18483c904:	48 89 c6             	mov    rsi,rax
   18483c907:	e8 64 0c e6 fb       	call   0x18069d570
   18483c90c:	90                   	nop
   18483c90d:	48 89 f1             	mov    rcx,rsi
   18483c910:	48 89 c2             	mov    rdx,rax
   18483c913:	e8 58 22 94 fd       	call   0x18217eb70
   18483c918:	90                   	nop
   18483c919:	48 89 c6             	mov    rsi,rax
   18483c91c:	48 c7 85 08 01 00 00 	mov    QWORD PTR [rbp+0x108],0x0
   18483c923:	00 00 00 00 
   18483c927:	b9 f8 00 00 00       	mov    ecx,0xf8
   18483c92c:	e8 6b ef c6 02       	call   0x1874ab89c
   18483c931:	90                   	nop
   18483c932:	48 8d 0d 4f 42 e8 04 	lea    rcx,[rip+0x4e8424f]        # 0x1896c0b88
   18483c939:	48 89 08             	mov    QWORD PTR [rax],rcx
   18483c93c:	0f 57 c0             	xorps  xmm0,xmm0
   18483c93f:	0f 11 40 08          	movups XMMWORD PTR [rax+0x8],xmm0
   18483c943:	48 8b 8d 58 01 00 00 	mov    rcx,QWORD PTR [rbp+0x158]
   18483c94a:	48 85 c9             	test   rcx,rcx
   18483c94d:	74 0d                	je     0x18483c95c
   18483c94f:	f0 ff 41 08          	lock inc DWORD PTR [rcx+0x8]
   18483c953:	48 8b 95 58 01 00 00 	mov    rdx,QWORD PTR [rbp+0x158]
   18483c95a:	eb 02                	jmp    0x18483c95e
   18483c95c:	31 d2                	xor    edx,edx
   18483c95e:	48 8d 48 08          	lea    rcx,[rax+0x8]
   18483c962:	48 89 8d 40 02 00 00 	mov    QWORD PTR [rbp+0x240],rcx
   18483c969:	48 8b 8d 50 01 00 00 	mov    rcx,QWORD PTR [rbp+0x150]
   18483c970:	48 89 48 08          	mov    QWORD PTR [rax+0x8],rcx
   18483c974:	48 89 50 10          	mov    QWORD PTR [rax+0x10],rdx
   18483c978:	48 8d 48 18          	lea    rcx,[rax+0x18]
   18483c97c:	48 89 8d c8 02 00 00 	mov    QWORD PTR [rbp+0x2c8],rcx
   18483c983:	c6 80 b0 00 00 00 00 	mov    BYTE PTR [rax+0xb0],0x0
   18483c98a:	80 bd f8 01 00 00 01 	cmp    BYTE PTR [rbp+0x1f8],0x1
   18483c991:	48 89 85 f0 02 00 00 	mov    QWORD PTR [rbp+0x2f0],rax
   18483c998:	75 1e                	jne    0x18483c9b8
   18483c99a:	48 8b 8d c8 02 00 00 	mov    rcx,QWORD PTR [rbp+0x2c8]
   18483c9a1:	48 89 da             	mov    rdx,rbx
   18483c9a4:	e8 17 91 94 fd       	call   0x182185ac0
   18483c9a9:	90                   	nop
   18483c9aa:	48 8b 85 f0 02 00 00 	mov    rax,QWORD PTR [rbp+0x2f0]
   18483c9b1:	c6 80 b0 00 00 00 01 	mov    BYTE PTR [rax+0xb0],0x1
   18483c9b8:	48 c7 80 f0 00 00 00 	mov    QWORD PTR [rax+0xf0],0x0
   18483c9bf:	00 00 00 00 
   18483c9c3:	48 8b 8d 38 02 00 00 	mov    rcx,QWORD PTR [rbp+0x238]
   18483c9ca:	48 85 c9             	test   rcx,rcx
   18483c9cd:	74 26                	je     0x18483c9f5
   18483c9cf:	48 8d 90 b8 00 00 00 	lea    rdx,[rax+0xb8]
   18483c9d6:	4c 8b 01             	mov    r8,QWORD PTR [rcx]
   18483c9d9:	48 89 95 48 02 00 00 	mov    QWORD PTR [rbp+0x248],rdx
   18483c9e0:	41 ff 10             	call   QWORD PTR [r8]
   18483c9e3:	90                   	nop
   18483c9e4:	48 8b 8d f0 02 00 00 	mov    rcx,QWORD PTR [rbp+0x2f0]
   18483c9eb:	48 89 81 f0 00 00 00 	mov    QWORD PTR [rcx+0xf0],rax
   18483c9f2:	48 89 c8             	mov    rax,rcx
   18483c9f5:	48 89 85 08 01 00 00 	mov    QWORD PTR [rbp+0x108],rax
   18483c9fc:	48 8d 95 d0 00 00 00 	lea    rdx,[rbp+0xd0]
   18483ca03:	48 89 f1             	mov    rcx,rsi
   18483ca06:	e8 85 21 94 fd       	call   0x18217eb90
   18483ca0b:	90                   	nop
   18483ca0c:	48 89 c6             	mov    rsi,rax
   18483ca0f:	48 c7 85 48 01 00 00 	mov    QWORD PTR [rbp+0x148],0x0
   18483ca16:	00 00 00 00 
   18483ca1a:	b9 48 00 00 00       	mov    ecx,0x48
   18483ca1f:	e8 78 ee c6 02       	call   0x1874ab89c
   18483ca24:	90                   	nop
   18483ca25:	48 8d 0d dc 43 e8 04 	lea    rcx,[rip+0x4e843dc]        # 0x1896c0e08
   18483ca2c:	48 89 08             	mov    QWORD PTR [rax],rcx
   18483ca2f:	48 c7 40 40 00 00 00 	mov    QWORD PTR [rax+0x40],0x0
   18483ca36:	00 
   18483ca37:	48 8b 8d a8 02 00 00 	mov    rcx,QWORD PTR [rbp+0x2a8]
   18483ca3e:	48 85 c9             	test   rcx,rcx
   18483ca41:	74 27                	je     0x18483ca6a
   18483ca43:	48 8d 50 08          	lea    rdx,[rax+0x8]
   18483ca47:	4c 8b 01             	mov    r8,QWORD PTR [rcx]
   18483ca4a:	48 89 85 f0 02 00 00 	mov    QWORD PTR [rbp+0x2f0],rax
   18483ca51:	48 89 95 c8 02 00 00 	mov    QWORD PTR [rbp+0x2c8],rdx
   18483ca58:	41 ff 10             	call   QWORD PTR [r8]
   18483ca5b:	90                   	nop
   18483ca5c:	48 8b 8d f0 02 00 00 	mov    rcx,QWORD PTR [rbp+0x2f0]
   18483ca63:	48 89 41 40          	mov    QWORD PTR [rcx+0x40],rax
   18483ca67:	48 89 c8             	mov    rax,rcx
   18483ca6a:	48 89 85 48 01 00 00 	mov    QWORD PTR [rbp+0x148],rax
   18483ca71:	48 8d 95 10 01 00 00 	lea    rdx,[rbp+0x110]
   18483ca78:	48 89 f1             	mov    rcx,rsi
   18483ca7b:	e8 f0 21 94 fd       	call   0x18217ec70
   18483ca80:	90                   	nop
   18483ca81:	48 89 c1             	mov    rcx,rax
   18483ca84:	31 d2                	xor    edx,edx
   18483ca86:	e8 45 30 94 fd       	call   0x18217fad0
   18483ca8b:	90                   	nop
   18483ca8c:	48 89 c1             	mov    rcx,rax
   18483ca8f:	e8 ec 22 94 fd       	call   0x18217ed80
   18483ca94:	90                   	nop
   18483ca95:	48 89 c6             	mov    rsi,rax
   18483ca98:	48 89 c7             	mov    rdi,rax
   18483ca9b:	48 8d 4d a0          	lea    rcx,[rbp-0x60]
   18483ca9f:	e8 9c d0 19 fc       	call   0x1809d9b40
   18483caa4:	48 81 c6 30 01 00 00 	add    rsi,0x130
   18483caab:	48 8b 87 30 01 00 00 	mov    rax,QWORD PTR [rdi+0x130]
   18483cab2:	48 89 f1             	mov    rcx,rsi
   18483cab5:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18483cab8:	90                   	nop
   18483cab9:	48 8b 8d a8 02 00 00 	mov    rcx,QWORD PTR [rbp+0x2a8]
   18483cac0:	48 85 c9             	test   rcx,rcx
   18483cac3:	74 13                	je     0x18483cad8
   18483cac5:	48 8d 85 70 02 00 00 	lea    rax,[rbp+0x270]
   18483cacc:	48 39 c1             	cmp    rcx,rax
   18483cacf:	0f 95 c2             	setne  dl
   18483cad2:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18483cad5:	ff 50 20             	call   QWORD PTR [rax+0x20]
   18483cad8:	48 8b 8d 38 02 00 00 	mov    rcx,QWORD PTR [rbp+0x238]
   18483cadf:	48 85 c9             	test   rcx,rcx
   18483cae2:	4c 8b bd d0 02 00 00 	mov    r15,QWORD PTR [rbp+0x2d0]
   18483cae9:	74 13                	je     0x18483cafe
   18483caeb:	48 8d 85 00 02 00 00 	lea    rax,[rbp+0x200]
   18483caf2:	48 39 c1             	cmp    rcx,rax
   18483caf5:	0f 95 c2             	setne  dl
   18483caf8:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18483cafb:	ff 50 20             	call   QWORD PTR [rax+0x20]
   18483cafe:	80 bd f8 01 00 00 01 	cmp    BYTE PTR [rbp+0x1f8],0x1
   18483cb05:	4c 8b b5 d8 02 00 00 	mov    r14,QWORD PTR [rbp+0x2d8]
   18483cb0c:	75 08                	jne    0x18483cb16
   18483cb0e:	48 89 d9             	mov    rcx,rbx
   18483cb11:	e8 ca c8 c2 fb       	call   0x1804693e0
   18483cb16:	48 8b b5 58 01 00 00 	mov    rsi,QWORD PTR [rbp+0x158]
   18483cb1d:	48 85 f6             	test   rsi,rsi
   18483cb20:	74 1d                	je     0x18483cb3f
   18483cb22:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   18483cb26:	75 17                	jne    0x18483cb3f
   18483cb28:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   18483cb2b:	48 89 f1             	mov    rcx,rsi
   18483cb2e:	ff 10                	call   QWORD PTR [rax]
   18483cb30:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   18483cb34:	75 09                	jne    0x18483cb3f
   18483cb36:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   18483cb39:	48 89 f1             	mov    rcx,rsi
   18483cb3c:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18483cb3f:	48 8b b5 e8 02 00 00 	mov    rsi,QWORD PTR [rbp+0x2e8]
   18483cb46:	48 85 f6             	test   rsi,rsi
   18483cb49:	74 1d                	je     0x18483cb68
   18483cb4b:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   18483cb4f:	75 17                	jne    0x18483cb68
   18483cb51:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   18483cb54:	48 89 f1             	mov    rcx,rsi
   18483cb57:	ff 10                	call   QWORD PTR [rax]
   18483cb59:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   18483cb5d:	75 09                	jne    0x18483cb68
   18483cb5f:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   18483cb62:	48 89 f1             	mov    rcx,rsi
   18483cb65:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18483cb68:	48 8b b5 b0 02 00 00 	mov    rsi,QWORD PTR [rbp+0x2b0]
   18483cb6f:	48 85 f6             	test   rsi,rsi
   18483cb72:	0f 84 93 00 00 00    	je     0x18483cc0b
   18483cb78:	48 8b 9d b8 02 00 00 	mov    rbx,QWORD PTR [rbp+0x2b8]
   18483cb7f:	48 39 de             	cmp    rsi,rbx
   18483cb82:	75 25                	jne    0x18483cba9
   18483cb84:	48 8b 95 c0 02 00 00 	mov    rdx,QWORD PTR [rbp+0x2c0]
   18483cb8b:	48 29 f2             	sub    rdx,rsi
   18483cb8e:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18483cb95:	73 54                	jae    0x18483cbeb
   18483cb97:	eb 6a                	jmp    0x18483cc03
   18483cb99:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
   18483cba0:	48 83 c6 10          	add    rsi,0x10
   18483cba4:	48 39 de             	cmp    rsi,rbx
   18483cba7:	74 28                	je     0x18483cbd1
   18483cba9:	48 8b 7e 08          	mov    rdi,QWORD PTR [rsi+0x8]
   18483cbad:	48 85 ff             	test   rdi,rdi
   18483cbb0:	74 ee                	je     0x18483cba0
   18483cbb2:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   18483cbb6:	75 e8                	jne    0x18483cba0
   18483cbb8:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   18483cbbb:	48 89 f9             	mov    rcx,rdi
   18483cbbe:	ff 10                	call   QWORD PTR [rax]
   18483cbc0:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   18483cbc4:	75 da                	jne    0x18483cba0
   18483cbc6:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   18483cbc9:	48 89 f9             	mov    rcx,rdi
   18483cbcc:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18483cbcf:	eb cf                	jmp    0x18483cba0
   18483cbd1:	48 8b b5 b0 02 00 00 	mov    rsi,QWORD PTR [rbp+0x2b0]
   18483cbd8:	48 8b 95 c0 02 00 00 	mov    rdx,QWORD PTR [rbp+0x2c0]
   18483cbdf:	48 29 f2             	sub    rdx,rsi
   18483cbe2:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18483cbe9:	72 18                	jb     0x18483cc03
   18483cbeb:	48 8b 46 f8          	mov    rax,QWORD PTR [rsi-0x8]
   18483cbef:	48 83 c6 f8          	add    rsi,0xfffffffffffffff8
   18483cbf3:	48 29 c6             	sub    rsi,rax
   18483cbf6:	48 83 fe 20          	cmp    rsi,0x20
   18483cbfa:	73 4d                	jae    0x18483cc49
   18483cbfc:	48 83 c2 27          	add    rdx,0x27
   18483cc00:	48 89 c6             	mov    rsi,rax
   18483cc03:	48 89 f1             	mov    rcx,rsi
   18483cc06:	e8 d5 ec c6 02       	call   0x1874ab8e0
   18483cc0b:	41 80 bf 98 00 00 00 	cmp    BYTE PTR [r15+0x98],0x1
   18483cc12:	01 
   18483cc13:	75 08                	jne    0x18483cc1d
   18483cc15:	4c 89 f9             	mov    rcx,r15
   18483cc18:	e8 c3 c7 c2 fb       	call   0x1804693e0
   18483cc1d:	49 8b 4e 38          	mov    rcx,QWORD PTR [r14+0x38]
   18483cc21:	48 85 c9             	test   rcx,rcx
   18483cc24:	74 0c                	je     0x18483cc32
   18483cc26:	4c 39 f1             	cmp    rcx,r14
   18483cc29:	0f 95 c2             	setne  dl
   18483cc2c:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18483cc2f:	ff 50 20             	call   QWORD PTR [rax+0x20]
   18483cc32:	0f 28 b5 00 03 00 00 	movaps xmm6,XMMWORD PTR [rbp+0x300]
   18483cc39:	48 81 c4 98 03 00 00 	add    rsp,0x398
   18483cc40:	5b                   	pop    rbx
   18483cc41:	5f                   	pop    rdi
   18483cc42:	5e                   	pop    rsi
   18483cc43:	41 5e                	pop    r14
   18483cc45:	41 5f                	pop    r15
   18483cc47:	5d                   	pop    rbp
   18483cc48:	c3                   	ret
   18483cc49:	e8 3e 07 cd 02       	call   0x18750d38c
   18483cc4e:	cc                   	int3
