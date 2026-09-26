
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

000000018057fe90 <.text+0x57ee90>:
   18057fe90:	55                   	push   rbp
   18057fe91:	41 56                	push   r14
   18057fe93:	56                   	push   rsi
   18057fe94:	57                   	push   rdi
   18057fe95:	53                   	push   rbx
   18057fe96:	48 83 ec 60          	sub    rsp,0x60
   18057fe9a:	48 8d 6c 24 60       	lea    rbp,[rsp+0x60]
   18057fe9f:	48 c7 45 f8 fe ff ff 	mov    QWORD PTR [rbp-0x8],0xfffffffffffffffe
   18057fea6:	ff 
   18057fea7:	48 89 ce             	mov    rsi,rcx
   18057feaa:	0f 28 05 ff 5c 7c 08 	movaps xmm0,XMMWORD PTR [rip+0x87c5cff]        # 0x188d45bb0
   18057feb1:	0f 29 45 e0          	movaps XMMWORD PTR [rbp-0x20],xmm0
   18057feb5:	0f 29 45 d0          	movaps XMMWORD PTR [rbp-0x30],xmm0
   18057feb9:	0f 29 45 c0          	movaps XMMWORD PTR [rbp-0x40],xmm0
   18057febd:	48 8d 5d c0          	lea    rbx,[rbp-0x40]
   18057fec1:	ba 10 00 00 00       	mov    edx,0x10
   18057fec6:	48 89 d9             	mov    rcx,rbx
   18057fec9:	e8 e2 b7 d3 00       	call   0x1812bb6b0
   18057fece:	48 8d 7d d0          	lea    rdi,[rbp-0x30]
   18057fed2:	48 89 f9             	mov    rcx,rdi
   18057fed5:	48 89 da             	mov    rdx,rbx
   18057fed8:	e8 43 01 00 00       	call   0x180580020
   18057fedd:	0f 57 c0             	xorps  xmm0,xmm0
   18057fee0:	0f 11 46 10          	movups XMMWORD PTR [rsi+0x10],xmm0
   18057fee4:	0f 11 06             	movups XMMWORD PTR [rsi],xmm0
   18057fee7:	48 8b 5d e0          	mov    rbx,QWORD PTR [rbp-0x20]
   18057feeb:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
   18057feef:	48 83 f8 10          	cmp    rax,0x10
   18057fef3:	72 04                	jb     0x18057fef9
   18057fef5:	48 8b 7d d0          	mov    rdi,QWORD PTR [rbp-0x30]
   18057fef9:	48 85 db             	test   rbx,rbx
   18057fefc:	0f 88 d3 00 00 00    	js     0x18057ffd5
   18057ff02:	48 83 fb 0f          	cmp    rbx,0xf
   18057ff06:	77 1d                	ja     0x18057ff25
   18057ff08:	48 89 5e 10          	mov    QWORD PTR [rsi+0x10],rbx
   18057ff0c:	48 c7 46 18 0f 00 00 	mov    QWORD PTR [rsi+0x18],0xf
   18057ff13:	00 
   18057ff14:	0f 10 07             	movups xmm0,XMMWORD PTR [rdi]
   18057ff17:	0f 11 06             	movups XMMWORD PTR [rsi],xmm0
   18057ff1a:	48 83 f8 10          	cmp    rax,0x10
   18057ff1e:	73 76                	jae    0x18057ff96
   18057ff20:	e9 a2 00 00 00       	jmp    0x18057ffc7
   18057ff25:	48 89 d8             	mov    rax,rbx
   18057ff28:	48 83 c8 0f          	or     rax,0xf
   18057ff2c:	48 83 f8 17          	cmp    rax,0x17
   18057ff30:	41 be 16 00 00 00    	mov    r14d,0x16
   18057ff36:	4c 0f 43 f0          	cmovae r14,rax
   18057ff3a:	48 3d ff 0f 00 00    	cmp    rax,0xfff
   18057ff40:	72 24                	jb     0x18057ff66
   18057ff42:	49 8d 4e 28          	lea    rcx,[r14+0x28]
   18057ff46:	e8 51 b9 f2 06       	call   0x1874ab89c
   18057ff4b:	90                   	nop
   18057ff4c:	48 85 c0             	test   rax,rax
   18057ff4f:	0f 84 86 00 00 00    	je     0x18057ffdb
   18057ff55:	48 89 c1             	mov    rcx,rax
   18057ff58:	48 83 c0 27          	add    rax,0x27
   18057ff5c:	48 83 e0 e0          	and    rax,0xffffffffffffffe0
   18057ff60:	48 89 48 f8          	mov    QWORD PTR [rax-0x8],rcx
   18057ff64:	eb 0a                	jmp    0x18057ff70
   18057ff66:	49 8d 4e 01          	lea    rcx,[r14+0x1]
   18057ff6a:	e8 2d b9 f2 06       	call   0x1874ab89c
   18057ff6f:	90                   	nop
   18057ff70:	48 89 06             	mov    QWORD PTR [rsi],rax
   18057ff73:	48 89 5e 10          	mov    QWORD PTR [rsi+0x10],rbx
   18057ff77:	4c 89 76 18          	mov    QWORD PTR [rsi+0x18],r14
   18057ff7b:	48 ff c3             	inc    rbx
   18057ff7e:	48 89 c1             	mov    rcx,rax
   18057ff81:	48 89 fa             	mov    rdx,rdi
   18057ff84:	49 89 d8             	mov    r8,rbx
   18057ff87:	e8 c4 40 fc 06       	call   0x187544050
   18057ff8c:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
   18057ff90:	48 83 f8 10          	cmp    rax,0x10
   18057ff94:	72 31                	jb     0x18057ffc7
   18057ff96:	48 8b 4d d0          	mov    rcx,QWORD PTR [rbp-0x30]
   18057ff9a:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18057ff9e:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18057ffa5:	72 1b                	jb     0x18057ffc2
   18057ffa7:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18057ffab:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18057ffaf:	4c 29 c1             	sub    rcx,r8
   18057ffb2:	48 83 f9 20          	cmp    rcx,0x20
   18057ffb6:	73 23                	jae    0x18057ffdb
   18057ffb8:	48 83 c0 28          	add    rax,0x28
   18057ffbc:	48 89 c2             	mov    rdx,rax
   18057ffbf:	4c 89 c1             	mov    rcx,r8
   18057ffc2:	e8 19 b9 f2 06       	call   0x1874ab8e0
   18057ffc7:	48 89 f0             	mov    rax,rsi
   18057ffca:	48 83 c4 60          	add    rsp,0x60
   18057ffce:	5b                   	pop    rbx
   18057ffcf:	5f                   	pop    rdi
   18057ffd0:	5e                   	pop    rsi
   18057ffd1:	41 5e                	pop    r14
   18057ffd3:	5d                   	pop    rbp
   18057ffd4:	c3                   	ret
   18057ffd5:	e8 b6 8b a8 ff       	call   0x180008b90
   18057ffda:	90                   	nop
   18057ffdb:	e8 ac d3 f8 06       	call   0x18750d38c
   18057ffe0:	cc                   	int3
