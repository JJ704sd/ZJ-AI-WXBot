
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000183995970 <.text+0x3994970>:
   183995970:	55                   	push   rbp
   183995971:	41 57                	push   r15
   183995973:	41 56                	push   r14
   183995975:	41 54                	push   r12
   183995977:	56                   	push   rsi
   183995978:	57                   	push   rdi
   183995979:	53                   	push   rbx
   18399597a:	48 83 ec 40          	sub    rsp,0x40
   18399597e:	48 8d 6c 24 40       	lea    rbp,[rsp+0x40]
   183995983:	48 c7 45 f8 fe ff ff 	mov    QWORD PTR [rbp-0x8],0xfffffffffffffffe
   18399598a:	ff 
   18399598b:	4c 89 cf             	mov    rdi,r9
   18399598e:	4d 89 c6             	mov    r14,r8
   183995991:	48 89 d3             	mov    rbx,rdx
   183995994:	48 89 ce             	mov    rsi,rcx
   183995997:	0f 28 05 12 02 3b 05 	movaps xmm0,XMMWORD PTR [rip+0x53b0212]        # 0x188d45bb0
   18399599e:	0f 29 45 e0          	movaps XMMWORD PTR [rbp-0x20],xmm0
   1839959a2:	48 8d 4d e0          	lea    rcx,[rbp-0x20]
   1839959a6:	e8 c5 f2 d5 fc       	call   0x1806f4c70
   1839959ab:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
   1839959af:	4c 8d b8 58 07 00 00 	lea    r15,[rax+0x758]
   1839959b6:	4d 39 f7             	cmp    r15,r14
   1839959b9:	74 4e                	je     0x183995a09
   1839959bb:	4d 8b 66 10          	mov    r12,QWORD PTR [r14+0x10]
   1839959bf:	49 83 7e 18 10       	cmp    QWORD PTR [r14+0x18],0x10
   1839959c4:	4d 89 f1             	mov    r9,r14
   1839959c7:	72 03                	jb     0x1839959cc
   1839959c9:	4d 8b 0e             	mov    r9,QWORD PTR [r14]
   1839959cc:	48 8b 88 70 07 00 00 	mov    rcx,QWORD PTR [rax+0x770]
   1839959d3:	49 39 cc             	cmp    r12,rcx
   1839959d6:	76 0e                	jbe    0x1839959e6
   1839959d8:	4c 89 f9             	mov    rcx,r15
   1839959db:	4c 89 e2             	mov    rdx,r12
   1839959de:	e8 6d 87 6a fc       	call   0x18003e150
   1839959e3:	90                   	nop
   1839959e4:	eb 23                	jmp    0x183995a09
   1839959e6:	48 83 f9 10          	cmp    rcx,0x10
   1839959ea:	72 03                	jb     0x1839959ef
   1839959ec:	4d 8b 3f             	mov    r15,QWORD PTR [r15]
   1839959ef:	4c 89 a0 68 07 00 00 	mov    QWORD PTR [rax+0x768],r12
   1839959f6:	4c 89 f9             	mov    rcx,r15
   1839959f9:	4c 89 ca             	mov    rdx,r9
   1839959fc:	4d 89 e0             	mov    r8,r12
   1839959ff:	e8 4c e6 ba 03       	call   0x187544050
   183995a04:	43 c6 04 27 00       	mov    BYTE PTR [r15+r12*1],0x0
   183995a09:	48 8b 4d e0          	mov    rcx,QWORD PTR [rbp-0x20]
   183995a0d:	48 b8 31 00 00 00 39 	movabs rax,0x3900000031
   183995a14:	00 00 00 
   183995a17:	48 89 81 18 01 00 00 	mov    QWORD PTR [rcx+0x118],rax
   183995a1e:	49 8b 46 10          	mov    rax,QWORD PTR [r14+0x10]
   183995a22:	48 89 81 c8 01 00 00 	mov    QWORD PTR [rcx+0x1c8],rax
   183995a29:	48 81 c1 f0 01 00 00 	add    rcx,0x1f0
   183995a30:	48 89 da             	mov    rdx,rbx
   183995a33:	e8 98 5c b5 fe       	call   0x1824eb6d0
   183995a38:	90                   	nop
   183995a39:	b9 f0 01 00 00       	mov    ecx,0x1f0
   183995a3e:	48 03 4d e0          	add    rcx,QWORD PTR [rbp-0x20]
   183995a42:	48 89 fa             	mov    rdx,rdi
   183995a45:	e8 76 5e b5 fe       	call   0x1824eb8c0
   183995a4a:	90                   	nop
   183995a4b:	0f 28 45 e0          	movaps xmm0,XMMWORD PTR [rbp-0x20]
   183995a4f:	0f 11 06             	movups XMMWORD PTR [rsi],xmm0
   183995a52:	48 89 f0             	mov    rax,rsi
   183995a55:	48 83 c4 40          	add    rsp,0x40
   183995a59:	5b                   	pop    rbx
   183995a5a:	5f                   	pop    rdi
   183995a5b:	5e                   	pop    rsi
   183995a5c:	41 5c                	pop    r12
   183995a5e:	41 5e                	pop    r14
   183995a60:	41 5f                	pop    r15
   183995a62:	5d                   	pop    rbp
   183995a63:	c3                   	ret
