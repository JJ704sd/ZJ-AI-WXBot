
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000185b5f6f0 <.text+0x5b5e6f0>:
   185b5f6f0:	55                   	push   rbp
   185b5f6f1:	41 56                	push   r14
   185b5f6f3:	56                   	push   rsi
   185b5f6f4:	57                   	push   rdi
   185b5f6f5:	53                   	push   rbx
   185b5f6f6:	48 83 ec 60          	sub    rsp,0x60
   185b5f6fa:	48 8d 6c 24 60       	lea    rbp,[rsp+0x60]
   185b5f6ff:	48 c7 45 f8 fe ff ff 	mov    QWORD PTR [rbp-0x8],0xfffffffffffffffe
   185b5f706:	ff 
   185b5f707:	4c 89 45 f0          	mov    QWORD PTR [rbp-0x10],r8
   185b5f70b:	48 89 d6             	mov    rsi,rdx
   185b5f70e:	48 89 cf             	mov    rdi,rcx
   185b5f711:	0f 28 05 98 64 1e 03 	movaps xmm0,XMMWORD PTR [rip+0x31e6498]        # 0x188d45bb0
   185b5f718:	0f 29 45 e0          	movaps XMMWORD PTR [rbp-0x20],xmm0
   185b5f71c:	48 8d 4d e0          	lea    rcx,[rbp-0x20]
   185b5f720:	e8 4b 55 b9 fa       	call   0x1806f4c70
   185b5f725:	90                   	nop
   185b5f726:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
   185b5f72a:	c7 80 18 01 00 00 01 	mov    DWORD PTR [rax+0x118],0x1
   185b5f731:	00 00 00 
   185b5f734:	48 8b 4d f0          	mov    rcx,QWORD PTR [rbp-0x10]
   185b5f738:	48 8b 09             	mov    rcx,QWORD PTR [rcx]
   185b5f73b:	4c 8d 89 b0 01 00 00 	lea    r9,[rcx+0x1b0]
   185b5f742:	48 8d 98 58 07 00 00 	lea    rbx,[rax+0x758]
   185b5f749:	4c 39 cb             	cmp    rbx,r9
   185b5f74c:	74 55                	je     0x185b5f7a3
   185b5f74e:	4c 8b b1 c0 01 00 00 	mov    r14,QWORD PTR [rcx+0x1c0]
   185b5f755:	48 83 b9 c8 01 00 00 	cmp    QWORD PTR [rcx+0x1c8],0x10
   185b5f75c:	10 
   185b5f75d:	72 07                	jb     0x185b5f766
   185b5f75f:	4c 8b 89 b0 01 00 00 	mov    r9,QWORD PTR [rcx+0x1b0]
   185b5f766:	48 8b 88 70 07 00 00 	mov    rcx,QWORD PTR [rax+0x770]
   185b5f76d:	49 39 ce             	cmp    r14,rcx
   185b5f770:	76 0e                	jbe    0x185b5f780
   185b5f772:	48 89 d9             	mov    rcx,rbx
   185b5f775:	4c 89 f2             	mov    rdx,r14
   185b5f778:	e8 d3 e9 4d fa       	call   0x18003e150
   185b5f77d:	90                   	nop
   185b5f77e:	eb 23                	jmp    0x185b5f7a3
   185b5f780:	48 83 f9 10          	cmp    rcx,0x10
   185b5f784:	72 03                	jb     0x185b5f789
   185b5f786:	48 8b 1b             	mov    rbx,QWORD PTR [rbx]
   185b5f789:	4c 89 b0 68 07 00 00 	mov    QWORD PTR [rax+0x768],r14
   185b5f790:	48 89 d9             	mov    rcx,rbx
   185b5f793:	4c 89 ca             	mov    rdx,r9
   185b5f796:	4d 89 f0             	mov    r8,r14
   185b5f799:	e8 b2 48 9e 01       	call   0x187544050
   185b5f79e:	42 c6 04 33 00       	mov    BYTE PTR [rbx+r14*1],0x0
   185b5f7a3:	0f 57 c0             	xorps  xmm0,xmm0
   185b5f7a6:	0f 29 45 c0          	movaps XMMWORD PTR [rbp-0x40],xmm0
   185b5f7aa:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
   185b5f7ae:	48 85 c0             	test   rax,rax
   185b5f7b1:	74 0a                	je     0x185b5f7bd
   185b5f7b3:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   185b5f7b7:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
   185b5f7bb:	eb 02                	jmp    0x185b5f7bf
   185b5f7bd:	31 c0                	xor    eax,eax
   185b5f7bf:	48 8b 55 f0          	mov    rdx,QWORD PTR [rbp-0x10]
   185b5f7c3:	48 8b 4d e0          	mov    rcx,QWORD PTR [rbp-0x20]
   185b5f7c7:	48 89 4d c0          	mov    QWORD PTR [rbp-0x40],rcx
   185b5f7cb:	48 89 45 c8          	mov    QWORD PTR [rbp-0x38],rax
   185b5f7cf:	0f 29 45 d0          	movaps XMMWORD PTR [rbp-0x30],xmm0
   185b5f7d3:	48 8b 42 08          	mov    rax,QWORD PTR [rdx+0x8]
   185b5f7d7:	48 85 c0             	test   rax,rax
   185b5f7da:	74 0a                	je     0x185b5f7e6
   185b5f7dc:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   185b5f7e0:	48 8b 42 08          	mov    rax,QWORD PTR [rdx+0x8]
   185b5f7e4:	eb 02                	jmp    0x185b5f7e8
   185b5f7e6:	31 c0                	xor    eax,eax
   185b5f7e8:	48 8b 0a             	mov    rcx,QWORD PTR [rdx]
   185b5f7eb:	48 89 4d d0          	mov    QWORD PTR [rbp-0x30],rcx
   185b5f7ef:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   185b5f7f3:	48 8d 55 d0          	lea    rdx,[rbp-0x30]
   185b5f7f7:	4c 8d 45 c0          	lea    r8,[rbp-0x40]
   185b5f7fb:	48 89 f9             	mov    rcx,rdi
   185b5f7fe:	e8 3d ec ff ff       	call   0x185b5e440
   185b5f803:	90                   	nop
   185b5f804:	0f 28 45 e0          	movaps xmm0,XMMWORD PTR [rbp-0x20]
   185b5f808:	0f 11 06             	movups XMMWORD PTR [rsi],xmm0
   185b5f80b:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   185b5f80f:	48 8b 78 08          	mov    rdi,QWORD PTR [rax+0x8]
   185b5f813:	48 85 ff             	test   rdi,rdi
   185b5f816:	74 1d                	je     0x185b5f835
   185b5f818:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   185b5f81c:	75 17                	jne    0x185b5f835
   185b5f81e:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185b5f821:	48 89 f9             	mov    rcx,rdi
   185b5f824:	ff 10                	call   QWORD PTR [rax]
   185b5f826:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   185b5f82a:	75 09                	jne    0x185b5f835
   185b5f82c:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185b5f82f:	48 89 f9             	mov    rcx,rdi
   185b5f832:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185b5f835:	48 89 f0             	mov    rax,rsi
   185b5f838:	48 83 c4 60          	add    rsp,0x60
   185b5f83c:	5b                   	pop    rbx
   185b5f83d:	5f                   	pop    rdi
   185b5f83e:	5e                   	pop    rsi
   185b5f83f:	41 5e                	pop    r14
   185b5f841:	5d                   	pop    rbp
   185b5f842:	c3                   	ret
