
.research\wechat-4.1.10.27-reference\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

00000001806b2d30 <.text+0x6b1d30>:
   1806b2d30:	55                   	push   rbp
   1806b2d31:	41 56                	push   r14
   1806b2d33:	56                   	push   rsi
   1806b2d34:	57                   	push   rdi
   1806b2d35:	53                   	push   rbx
   1806b2d36:	48 81 ec 80 00 00 00 	sub    rsp,0x80
   1806b2d3d:	48 8d ac 24 80 00 00 	lea    rbp,[rsp+0x80]
   1806b2d44:	00 
   1806b2d45:	0f 29 75 f0          	movaps XMMWORD PTR [rbp-0x10],xmm6
   1806b2d49:	48 c7 45 e8 fe ff ff 	mov    QWORD PTR [rbp-0x18],0xfffffffffffffffe
   1806b2d50:	ff 
   1806b2d51:	48 89 d6             	mov    rsi,rdx
   1806b2d54:	0f 57 f6             	xorps  xmm6,xmm6
   1806b2d57:	0f 11 71 08          	movups XMMWORD PTR [rcx+0x8],xmm6
   1806b2d5b:	0f 11 71 18          	movups XMMWORD PTR [rcx+0x18],xmm6
   1806b2d5f:	48 c7 41 28 00 00 00 	mov    QWORD PTR [rcx+0x28],0x0
   1806b2d66:	00 
   1806b2d67:	48 c7 41 30 0f 00 00 	mov    QWORD PTR [rcx+0x30],0xf
   1806b2d6e:	00 
   1806b2d6f:	0f 11 71 38          	movups XMMWORD PTR [rcx+0x38],xmm6
   1806b2d73:	48 c7 41 48 00 00 00 	mov    QWORD PTR [rcx+0x48],0x0
   1806b2d7a:	00 
   1806b2d7b:	48 c7 41 50 0f 00 00 	mov    QWORD PTR [rcx+0x50],0xf
   1806b2d82:	00 
   1806b2d83:	0f 11 71 58          	movups XMMWORD PTR [rcx+0x58],xmm6
   1806b2d87:	48 c7 41 68 00 00 00 	mov    QWORD PTR [rcx+0x68],0x0
   1806b2d8e:	00 
   1806b2d8f:	48 c7 41 70 0f 00 00 	mov    QWORD PTR [rcx+0x70],0xf
   1806b2d96:	00 
   1806b2d97:	0f 11 71 78          	movups XMMWORD PTR [rcx+0x78],xmm6
   1806b2d9b:	48 c7 81 88 00 00 00 	mov    QWORD PTR [rcx+0x88],0x0
   1806b2da2:	00 00 00 00 
   1806b2da6:	48 c7 81 90 00 00 00 	mov    QWORD PTR [rcx+0x90],0xf
   1806b2dad:	0f 00 00 00 
   1806b2db1:	0f 28 05 08 ac bb 07 	movaps xmm0,XMMWORD PTR [rip+0x7bbac08]        # 0x18826d9c0
   1806b2db8:	0f 11 81 98 00 00 00 	movups XMMWORD PTR [rcx+0x98],xmm0
   1806b2dbf:	c7 81 a8 00 00 00 00 	mov    DWORD PTR [rcx+0xa8],0x0
   1806b2dc6:	00 00 00 
   1806b2dc9:	0f 11 b1 b0 00 00 00 	movups XMMWORD PTR [rcx+0xb0],xmm6
   1806b2dd0:	48 c7 81 c0 00 00 00 	mov    QWORD PTR [rcx+0xc0],0x0
   1806b2dd7:	00 00 00 00 
   1806b2ddb:	48 c7 81 c8 00 00 00 	mov    QWORD PTR [rcx+0xc8],0xf
   1806b2de2:	0f 00 00 00 
   1806b2de6:	48 8d 05 8b 67 bc 07 	lea    rax,[rip+0x7bc678b]        # 0x188279578
   1806b2ded:	48 89 01             	mov    QWORD PTR [rcx],rax
   1806b2df0:	0f 11 b1 d0 00 00 00 	movups XMMWORD PTR [rcx+0xd0],xmm6
   1806b2df7:	48 89 4d e0          	mov    QWORD PTR [rbp-0x20],rcx
   1806b2dfb:	48 81 c1 e0 00 00 00 	add    rcx,0xe0
   1806b2e02:	48 89 4d a0          	mov    QWORD PTR [rbp-0x60],rcx
   1806b2e06:	e8 75 3d 9e ff       	call   0x180096b80
   1806b2e0b:	90                   	nop
   1806b2e0c:	48 8b 4d e0          	mov    rcx,QWORD PTR [rbp-0x20]
   1806b2e10:	c6 81 00 01 00 00 00 	mov    BYTE PTR [rcx+0x100],0x0
   1806b2e17:	48 8d 81 08 01 00 00 	lea    rax,[rcx+0x108]
   1806b2e1e:	48 89 45 a8          	mov    QWORD PTR [rbp-0x58],rax
   1806b2e22:	0f 11 b1 08 01 00 00 	movups XMMWORD PTR [rcx+0x108],xmm6
   1806b2e29:	48 c7 81 18 01 00 00 	mov    QWORD PTR [rcx+0x118],0x0
   1806b2e30:	00 00 00 00 
   1806b2e34:	48 c7 81 20 01 00 00 	mov    QWORD PTR [rcx+0x120],0xf
   1806b2e3b:	0f 00 00 00 
   1806b2e3f:	48 81 c1 28 01 00 00 	add    rcx,0x128
   1806b2e46:	48 89 4d b0          	mov    QWORD PTR [rbp-0x50],rcx
   1806b2e4a:	e8 31 3d 9e ff       	call   0x180096b80
   1806b2e4f:	90                   	nop
   1806b2e50:	48 8b 55 e0          	mov    rdx,QWORD PTR [rbp-0x20]
   1806b2e54:	48 8d 82 48 01 00 00 	lea    rax,[rdx+0x148]
   1806b2e5b:	48 89 45 b8          	mov    QWORD PTR [rbp-0x48],rax
   1806b2e5f:	0f 11 b2 48 01 00 00 	movups XMMWORD PTR [rdx+0x148],xmm6
   1806b2e66:	48 c7 82 58 01 00 00 	mov    QWORD PTR [rdx+0x158],0x0
   1806b2e6d:	00 00 00 00 
   1806b2e71:	48 c7 82 60 01 00 00 	mov    QWORD PTR [rdx+0x160],0xf
   1806b2e78:	0f 00 00 00 
   1806b2e7c:	48 8d 82 68 01 00 00 	lea    rax,[rdx+0x168]
   1806b2e83:	48 89 45 c0          	mov    QWORD PTR [rbp-0x40],rax
   1806b2e87:	0f 11 b2 68 01 00 00 	movups XMMWORD PTR [rdx+0x168],xmm6
   1806b2e8e:	48 c7 82 78 01 00 00 	mov    QWORD PTR [rdx+0x178],0x0
   1806b2e95:	00 00 00 00 
   1806b2e99:	48 c7 82 80 01 00 00 	mov    QWORD PTR [rdx+0x180],0xf
   1806b2ea0:	0f 00 00 00 
   1806b2ea4:	48 8d 82 90 01 00 00 	lea    rax,[rdx+0x190]
   1806b2eab:	48 89 45 c8          	mov    QWORD PTR [rbp-0x38],rax
   1806b2eaf:	0f 11 b2 88 01 00 00 	movups XMMWORD PTR [rdx+0x188],xmm6
   1806b2eb6:	0f 11 b2 98 01 00 00 	movups XMMWORD PTR [rdx+0x198],xmm6
   1806b2ebd:	48 c7 82 a8 01 00 00 	mov    QWORD PTR [rdx+0x1a8],0xf
   1806b2ec4:	0f 00 00 00 
   1806b2ec8:	48 8d 8a b0 01 00 00 	lea    rcx,[rdx+0x1b0]
   1806b2ecf:	48 8d 82 08 02 00 00 	lea    rax,[rdx+0x208]
   1806b2ed6:	48 89 45 d0          	mov    QWORD PTR [rbp-0x30],rax
   1806b2eda:	48 8d ba 40 06 00 00 	lea    rdi,[rdx+0x640]
   1806b2ee1:	41 b8 f8 04 00 00    	mov    r8d,0x4f8
   1806b2ee7:	48 89 4d d8          	mov    QWORD PTR [rbp-0x28],rcx
   1806b2eeb:	31 d2                	xor    edx,edx
   1806b2eed:	e8 7e 38 1e 06       	call   0x186896770
   1806b2ef2:	90                   	nop
   1806b2ef3:	48 89 f9             	mov    rcx,rdi
   1806b2ef6:	e8 85 98 21 01       	call   0x1818cc780
   1806b2efb:	90                   	nop
   1806b2efc:	4c 8b 75 e0          	mov    r14,QWORD PTR [rbp-0x20]
   1806b2f00:	41 0f 11 b6 b8 06 00 	movups XMMWORD PTR [r14+0x6b8],xmm6
   1806b2f07:	00 
   1806b2f08:	41 0f 11 b6 a8 06 00 	movups XMMWORD PTR [r14+0x6a8],xmm6
   1806b2f0f:	00 
   1806b2f10:	48 8b 7e 10          	mov    rdi,QWORD PTR [rsi+0x10]
   1806b2f14:	48 83 7e 18 10       	cmp    QWORD PTR [rsi+0x18],0x10
   1806b2f19:	72 03                	jb     0x1806b2f1e
   1806b2f1b:	48 8b 36             	mov    rsi,QWORD PTR [rsi]
   1806b2f1e:	48 85 ff             	test   rdi,rdi
   1806b2f21:	0f 88 fa 00 00 00    	js     0x1806b3021
   1806b2f27:	48 83 ff 0f          	cmp    rdi,0xf
   1806b2f2b:	77 21                	ja     0x1806b2f4e
   1806b2f2d:	49 8d 86 a8 06 00 00 	lea    rax,[r14+0x6a8]
   1806b2f34:	49 89 be b8 06 00 00 	mov    QWORD PTR [r14+0x6b8],rdi
   1806b2f3b:	49 c7 86 c0 06 00 00 	mov    QWORD PTR [r14+0x6c0],0xf
   1806b2f42:	0f 00 00 00 
   1806b2f46:	0f 10 06             	movups xmm0,XMMWORD PTR [rsi]
   1806b2f49:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   1806b2f4c:	eb 74                	jmp    0x1806b2fc2
   1806b2f4e:	48 89 f8             	mov    rax,rdi
   1806b2f51:	48 83 c8 0f          	or     rax,0xf
   1806b2f55:	48 83 f8 17          	cmp    rax,0x17
   1806b2f59:	bb 16 00 00 00       	mov    ebx,0x16
   1806b2f5e:	48 0f 43 d8          	cmovae rbx,rax
   1806b2f62:	48 3d ff 0f 00 00    	cmp    rax,0xfff
   1806b2f68:	72 24                	jb     0x1806b2f8e
   1806b2f6a:	48 8d 4b 28          	lea    rcx,[rbx+0x28]
   1806b2f6e:	e8 89 a1 15 06       	call   0x18680d0fc
   1806b2f73:	90                   	nop
   1806b2f74:	48 85 c0             	test   rax,rax
   1806b2f77:	0f 84 aa 00 00 00    	je     0x1806b3027
   1806b2f7d:	48 89 c1             	mov    rcx,rax
   1806b2f80:	48 83 c0 27          	add    rax,0x27
   1806b2f84:	48 83 e0 e0          	and    rax,0xffffffffffffffe0
   1806b2f88:	48 89 48 f8          	mov    QWORD PTR [rax-0x8],rcx
   1806b2f8c:	eb 0a                	jmp    0x1806b2f98
   1806b2f8e:	48 8d 4b 01          	lea    rcx,[rbx+0x1]
   1806b2f92:	e8 65 a1 15 06       	call   0x18680d0fc
   1806b2f97:	90                   	nop
   1806b2f98:	4c 8b 75 e0          	mov    r14,QWORD PTR [rbp-0x20]
   1806b2f9c:	49 89 86 a8 06 00 00 	mov    QWORD PTR [r14+0x6a8],rax
   1806b2fa3:	49 89 be b8 06 00 00 	mov    QWORD PTR [r14+0x6b8],rdi
   1806b2faa:	49 89 9e c0 06 00 00 	mov    QWORD PTR [r14+0x6c0],rbx
   1806b2fb1:	48 ff c7             	inc    rdi
   1806b2fb4:	48 89 c1             	mov    rcx,rax
   1806b2fb7:	48 89 f2             	mov    rdx,rsi
   1806b2fba:	49 89 f8             	mov    r8,rdi
   1806b2fbd:	e8 0e 31 1e 06       	call   0x1868960d0
   1806b2fc2:	0f 57 c0             	xorps  xmm0,xmm0
   1806b2fc5:	41 0f 11 86 c8 06 00 	movups XMMWORD PTR [r14+0x6c8],xmm0
   1806b2fcc:	00 
   1806b2fcd:	49 c7 86 d8 06 00 00 	mov    QWORD PTR [r14+0x6d8],0x0
   1806b2fd4:	00 00 00 00 
   1806b2fd8:	49 c7 86 e0 06 00 00 	mov    QWORD PTR [r14+0x6e0],0xf
   1806b2fdf:	0f 00 00 00 
   1806b2fe3:	41 0f 11 86 e8 06 00 	movups XMMWORD PTR [r14+0x6e8],xmm0
   1806b2fea:	00 
   1806b2feb:	49 c7 86 f8 06 00 00 	mov    QWORD PTR [r14+0x6f8],0x0
   1806b2ff2:	00 00 00 00 
   1806b2ff6:	49 c7 86 00 07 00 00 	mov    QWORD PTR [r14+0x700],0xf
   1806b2ffd:	0f 00 00 00 
   1806b3001:	41 c7 86 9c 00 00 00 	mov    DWORD PTR [r14+0x9c],0x1
   1806b3008:	01 00 00 00 
   1806b300c:	4c 89 f0             	mov    rax,r14
   1806b300f:	0f 28 75 f0          	movaps xmm6,XMMWORD PTR [rbp-0x10]
   1806b3013:	48 81 c4 80 00 00 00 	add    rsp,0x80
   1806b301a:	5b                   	pop    rbx
   1806b301b:	5f                   	pop    rdi
   1806b301c:	5e                   	pop    rsi
   1806b301d:	41 5e                	pop    r14
   1806b301f:	5d                   	pop    rbp
   1806b3020:	c3                   	ret
   1806b3021:	e8 3a 59 95 ff       	call   0x180008960
   1806b3026:	90                   	nop
   1806b3027:	e8 4c d4 1a 06       	call   0x186860478
   1806b302c:	cc                   	int3
