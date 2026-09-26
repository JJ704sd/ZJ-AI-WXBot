
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000182e82c00 <.text+0x2e81c00>:
   182e82c00:	55                   	push   rbp
   182e82c01:	41 57                	push   r15
   182e82c03:	41 56                	push   r14
   182e82c05:	56                   	push   rsi
   182e82c06:	57                   	push   rdi
   182e82c07:	53                   	push   rbx
   182e82c08:	48 83 ec 78          	sub    rsp,0x78
   182e82c0c:	48 8d 6c 24 70       	lea    rbp,[rsp+0x70]
   182e82c11:	48 c7 45 00 fe ff ff 	mov    QWORD PTR [rbp+0x0],0xfffffffffffffffe
   182e82c18:	ff 
   182e82c19:	48 89 d7             	mov    rdi,rdx
   182e82c1c:	48 89 ce             	mov    rsi,rcx
   182e82c1f:	48 39 ca             	cmp    rdx,rcx
   182e82c22:	74 0d                	je     0x182e82c31
   182e82c24:	0f b6 47 34          	movzx  eax,BYTE PTR [rdi+0x34]
   182e82c28:	85 c0                	test   eax,eax
   182e82c2a:	75 56                	jne    0x182e82c82
   182e82c2c:	e9 29 02 00 00       	jmp    0x182e82e5a
   182e82c31:	4c 8d 05 38 21 55 06 	lea    r8,[rip+0x6552138]        # 0x1893d4d70
   182e82c38:	48 8d 5d b8          	lea    rbx,[rbp-0x48]
   182e82c3c:	48 89 d9             	mov    rcx,rbx
   182e82c3f:	ba 03 00 00 00       	mov    edx,0x3
   182e82c44:	41 b9 77 02 00 00    	mov    r9d,0x277
   182e82c4a:	e8 31 ef 76 fe       	call   0x1815f1b80
   182e82c4f:	90                   	nop
   182e82c50:	48 8d 15 01 9a fb 05 	lea    rdx,[rip+0x5fb9a01]        # 0x188e3c658
   182e82c57:	48 89 d9             	mov    rcx,rbx
   182e82c5a:	e8 51 ef 76 fe       	call   0x1815f1bb0
   182e82c5f:	90                   	nop
   182e82c60:	48 8d 4d ff          	lea    rcx,[rbp-0x1]
   182e82c64:	48 89 c2             	mov    rdx,rax
   182e82c67:	e8 64 f1 76 fe       	call   0x1815f1dd0
   182e82c6c:	90                   	nop
   182e82c6d:	48 8d 4d b8          	lea    rcx,[rbp-0x48]
   182e82c71:	e8 6a f1 76 fe       	call   0x1815f1de0
   182e82c76:	0f b6 47 34          	movzx  eax,BYTE PTR [rdi+0x34]
   182e82c7a:	85 c0                	test   eax,eax
   182e82c7c:	0f 84 d8 01 00 00    	je     0x182e82e5a
   182e82c82:	a8 01                	test   al,0x1
   182e82c84:	74 26                	je     0x182e82cac
   182e82c86:	80 4e 34 01          	or     BYTE PTR [rsi+0x34],0x1
   182e82c8a:	48 8b 4e 08          	mov    rcx,QWORD PTR [rsi+0x8]
   182e82c8e:	48 85 c9             	test   rcx,rcx
   182e82c91:	0f 84 a7 00 00 00    	je     0x182e82d3e
   182e82c97:	48 8b 57 08          	mov    rdx,QWORD PTR [rdi+0x8]
   182e82c9b:	48 85 d2             	test   rdx,rdx
   182e82c9e:	0f 84 c7 00 00 00    	je     0x182e82d6b
   182e82ca4:	e8 a7 81 7f fd       	call   0x18067ae50
   182e82ca9:	8b 47 34             	mov    eax,DWORD PTR [rdi+0x34]
   182e82cac:	a8 02                	test   al,0x2
   182e82cae:	74 66                	je     0x182e82d16
   182e82cb0:	48 8b 5f 10          	mov    rbx,QWORD PTR [rdi+0x10]
   182e82cb4:	83 4e 34 02          	or     DWORD PTR [rsi+0x34],0x2
   182e82cb8:	48 8b 46 10          	mov    rax,QWORD PTR [rsi+0x10]
   182e82cbc:	48 8d 0d 1d 41 a9 08 	lea    rcx,[rip+0x8a9411d]        # 0x18b916de0
   182e82cc3:	48 39 c8             	cmp    rax,rcx
   182e82cc6:	75 24                	jne    0x182e82cec
   182e82cc8:	b9 20 00 00 00       	mov    ecx,0x20
   182e82ccd:	e8 ca 8b 62 04       	call   0x1874ab89c
   182e82cd2:	0f 57 c0             	xorps  xmm0,xmm0
   182e82cd5:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   182e82cd8:	48 c7 40 10 00 00 00 	mov    QWORD PTR [rax+0x10],0x0
   182e82cdf:	00 
   182e82ce0:	48 c7 40 18 0f 00 00 	mov    QWORD PTR [rax+0x18],0xf
   182e82ce7:	00 
   182e82ce8:	48 89 46 10          	mov    QWORD PTR [rsi+0x10],rax
   182e82cec:	48 39 d8             	cmp    rax,rbx
   182e82cef:	74 25                	je     0x182e82d16
   182e82cf1:	4c 8b 73 10          	mov    r14,QWORD PTR [rbx+0x10]
   182e82cf5:	48 83 7b 18 10       	cmp    QWORD PTR [rbx+0x18],0x10
   182e82cfa:	72 03                	jb     0x182e82cff
   182e82cfc:	48 8b 1b             	mov    rbx,QWORD PTR [rbx]
   182e82cff:	48 8b 48 18          	mov    rcx,QWORD PTR [rax+0x18]
   182e82d03:	49 39 ce             	cmp    r14,rcx
   182e82d06:	76 73                	jbe    0x182e82d7b
   182e82d08:	48 89 c1             	mov    rcx,rax
   182e82d0b:	4c 89 f2             	mov    rdx,r14
   182e82d0e:	49 89 d9             	mov    r9,rbx
   182e82d11:	e8 3a b4 1b fd       	call   0x18003e150
   182e82d16:	8b 47 34             	mov    eax,DWORD PTR [rdi+0x34]
   182e82d19:	a8 04                	test   al,0x4
   182e82d1b:	0f 85 88 00 00 00    	jne    0x182e82da9
   182e82d21:	a8 08                	test   al,0x8
   182e82d23:	0f 85 95 00 00 00    	jne    0x182e82dbe
   182e82d29:	a8 10                	test   al,0x10
   182e82d2b:	0f 85 a2 00 00 00    	jne    0x182e82dd3
   182e82d31:	a8 20                	test   al,0x20
   182e82d33:	0f 85 ab 00 00 00    	jne    0x182e82de4
   182e82d39:	e9 0c 01 00 00       	jmp    0x182e82e4a
   182e82d3e:	b9 18 00 00 00       	mov    ecx,0x18
   182e82d43:	e8 54 8b 62 04       	call   0x1874ab89c
   182e82d48:	90                   	nop
   182e82d49:	48 89 45 f0          	mov    QWORD PTR [rbp-0x10],rax
   182e82d4d:	48 89 c1             	mov    rcx,rax
   182e82d50:	e8 5b 63 7f fd       	call   0x1806790b0
   182e82d55:	90                   	nop
   182e82d56:	48 8b 4d f0          	mov    rcx,QWORD PTR [rbp-0x10]
   182e82d5a:	48 89 4e 08          	mov    QWORD PTR [rsi+0x8],rcx
   182e82d5e:	48 8b 57 08          	mov    rdx,QWORD PTR [rdi+0x8]
   182e82d62:	48 85 d2             	test   rdx,rdx
   182e82d65:	0f 85 39 ff ff ff    	jne    0x182e82ca4
   182e82d6b:	48 8b 05 ee a5 ab 08 	mov    rax,QWORD PTR [rip+0x8aba5ee]        # 0x18b93d360
   182e82d72:	48 8b 50 08          	mov    rdx,QWORD PTR [rax+0x8]
   182e82d76:	e9 29 ff ff ff       	jmp    0x182e82ca4
   182e82d7b:	49 89 c7             	mov    r15,rax
   182e82d7e:	48 83 f9 10          	cmp    rcx,0x10
   182e82d82:	72 03                	jb     0x182e82d87
   182e82d84:	4c 8b 38             	mov    r15,QWORD PTR [rax]
   182e82d87:	4c 89 70 10          	mov    QWORD PTR [rax+0x10],r14
   182e82d8b:	4c 89 f9             	mov    rcx,r15
   182e82d8e:	48 89 da             	mov    rdx,rbx
   182e82d91:	4d 89 f0             	mov    r8,r14
   182e82d94:	e8 b7 12 6c 04       	call   0x187544050
   182e82d99:	43 c6 04 37 00       	mov    BYTE PTR [r15+r14*1],0x0
   182e82d9e:	8b 47 34             	mov    eax,DWORD PTR [rdi+0x34]
   182e82da1:	a8 04                	test   al,0x4
   182e82da3:	0f 84 78 ff ff ff    	je     0x182e82d21
   182e82da9:	8b 47 18             	mov    eax,DWORD PTR [rdi+0x18]
   182e82dac:	83 4e 34 04          	or     DWORD PTR [rsi+0x34],0x4
   182e82db0:	89 46 18             	mov    DWORD PTR [rsi+0x18],eax
   182e82db3:	8b 47 34             	mov    eax,DWORD PTR [rdi+0x34]
   182e82db6:	a8 08                	test   al,0x8
   182e82db8:	0f 84 6b ff ff ff    	je     0x182e82d29
   182e82dbe:	8b 47 1c             	mov    eax,DWORD PTR [rdi+0x1c]
   182e82dc1:	83 4e 34 08          	or     DWORD PTR [rsi+0x34],0x8
   182e82dc5:	89 46 1c             	mov    DWORD PTR [rsi+0x1c],eax
   182e82dc8:	8b 47 34             	mov    eax,DWORD PTR [rdi+0x34]
   182e82dcb:	a8 10                	test   al,0x10
   182e82dcd:	0f 84 5e ff ff ff    	je     0x182e82d31
   182e82dd3:	8b 47 28             	mov    eax,DWORD PTR [rdi+0x28]
   182e82dd6:	83 4e 34 10          	or     DWORD PTR [rsi+0x34],0x10
   182e82dda:	89 46 28             	mov    DWORD PTR [rsi+0x28],eax
   182e82ddd:	8b 47 34             	mov    eax,DWORD PTR [rdi+0x34]
   182e82de0:	a8 20                	test   al,0x20
   182e82de2:	74 66                	je     0x182e82e4a
   182e82de4:	48 8b 5f 20          	mov    rbx,QWORD PTR [rdi+0x20]
   182e82de8:	83 4e 34 20          	or     DWORD PTR [rsi+0x34],0x20
   182e82dec:	48 8b 46 20          	mov    rax,QWORD PTR [rsi+0x20]
   182e82df0:	48 8d 0d e9 3f a9 08 	lea    rcx,[rip+0x8a93fe9]        # 0x18b916de0
   182e82df7:	48 39 c8             	cmp    rax,rcx
   182e82dfa:	75 24                	jne    0x182e82e20
   182e82dfc:	b9 20 00 00 00       	mov    ecx,0x20
   182e82e01:	e8 96 8a 62 04       	call   0x1874ab89c
   182e82e06:	0f 57 c0             	xorps  xmm0,xmm0
   182e82e09:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   182e82e0c:	48 c7 40 10 00 00 00 	mov    QWORD PTR [rax+0x10],0x0
   182e82e13:	00 
   182e82e14:	48 c7 40 18 0f 00 00 	mov    QWORD PTR [rax+0x18],0xf
   182e82e1b:	00 
   182e82e1c:	48 89 46 20          	mov    QWORD PTR [rsi+0x20],rax
   182e82e20:	48 39 d8             	cmp    rax,rbx
   182e82e23:	74 25                	je     0x182e82e4a
   182e82e25:	4c 8b 73 10          	mov    r14,QWORD PTR [rbx+0x10]
   182e82e29:	48 83 7b 18 10       	cmp    QWORD PTR [rbx+0x18],0x10
   182e82e2e:	72 03                	jb     0x182e82e33
   182e82e30:	48 8b 1b             	mov    rbx,QWORD PTR [rbx]
   182e82e33:	48 8b 48 18          	mov    rcx,QWORD PTR [rax+0x18]
   182e82e37:	49 39 ce             	cmp    r14,rcx
   182e82e3a:	76 2b                	jbe    0x182e82e67
   182e82e3c:	48 89 c1             	mov    rcx,rax
   182e82e3f:	4c 89 f2             	mov    rdx,r14
   182e82e42:	49 89 d9             	mov    r9,rbx
   182e82e45:	e8 06 b3 1b fd       	call   0x18003e150
   182e82e4a:	f6 47 34 40          	test   BYTE PTR [rdi+0x34],0x40
   182e82e4e:	74 0a                	je     0x182e82e5a
   182e82e50:	8b 47 2c             	mov    eax,DWORD PTR [rdi+0x2c]
   182e82e53:	83 4e 34 40          	or     DWORD PTR [rsi+0x34],0x40
   182e82e57:	89 46 2c             	mov    DWORD PTR [rsi+0x2c],eax
   182e82e5a:	48 83 c4 78          	add    rsp,0x78
   182e82e5e:	5b                   	pop    rbx
   182e82e5f:	5f                   	pop    rdi
   182e82e60:	5e                   	pop    rsi
   182e82e61:	41 5e                	pop    r14
   182e82e63:	41 5f                	pop    r15
   182e82e65:	5d                   	pop    rbp
   182e82e66:	c3                   	ret
   182e82e67:	49 89 c7             	mov    r15,rax
   182e82e6a:	48 83 f9 10          	cmp    rcx,0x10
   182e82e6e:	72 03                	jb     0x182e82e73
   182e82e70:	4c 8b 38             	mov    r15,QWORD PTR [rax]
   182e82e73:	4c 89 70 10          	mov    QWORD PTR [rax+0x10],r14
   182e82e77:	4c 89 f9             	mov    rcx,r15
   182e82e7a:	48 89 da             	mov    rdx,rbx
   182e82e7d:	4d 89 f0             	mov    r8,r14
   182e82e80:	e8 cb 11 6c 04       	call   0x187544050
   182e82e85:	43 c6 04 37 00       	mov    BYTE PTR [r15+r14*1],0x0
   182e82e8a:	f6 47 34 40          	test   BYTE PTR [rdi+0x34],0x40
   182e82e8e:	75 c0                	jne    0x182e82e50
   182e82e90:	eb c8                	jmp    0x182e82e5a
