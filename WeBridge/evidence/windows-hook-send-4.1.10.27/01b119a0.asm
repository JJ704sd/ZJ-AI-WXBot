
.research\wechat-4.1.10.27-reference\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000181b119a0 <.text+0x1b109a0>:
   181b119a0:	55                   	push   rbp
   181b119a1:	41 57                	push   r15
   181b119a3:	41 56                	push   r14
   181b119a5:	41 54                	push   r12
   181b119a7:	56                   	push   rsi
   181b119a8:	57                   	push   rdi
   181b119a9:	53                   	push   rbx
   181b119aa:	48 81 ec b0 02 00 00 	sub    rsp,0x2b0
   181b119b1:	48 8d ac 24 80 00 00 	lea    rbp,[rsp+0x80]
   181b119b8:	00 
   181b119b9:	48 c7 85 28 02 00 00 	mov    QWORD PTR [rbp+0x228],0xfffffffffffffffe
   181b119c0:	fe ff ff ff 
   181b119c4:	48 89 cf             	mov    rdi,rcx
   181b119c7:	48 8b 31             	mov    rsi,QWORD PTR [rcx]
   181b119ca:	48 8b 8e 18 03 00 00 	mov    rcx,QWORD PTR [rsi+0x318]
   181b119d1:	4c 8b 4f 28          	mov    r9,QWORD PTR [rdi+0x28]
   181b119d5:	4c 8d 47 08          	lea    r8,[rdi+0x8]
   181b119d9:	48 8d 95 b8 00 00 00 	lea    rdx,[rbp+0xb8]
   181b119e0:	e8 ab dd ea 01       	call   0x1839bf790
   181b119e5:	90                   	nop
   181b119e6:	48 8d 15 ef 47 6a 06 	lea    rdx,[rip+0x66a47ef]        # 0x1881b61dc
   181b119ed:	4c 8d 05 44 6b a8 06 	lea    r8,[rip+0x6a86b44]        # 0x188598538
   181b119f4:	48 8d 9d a0 01 00 00 	lea    rbx,[rbp+0x1a0]
   181b119fb:	48 89 d9             	mov    rcx,rbx
   181b119fe:	41 b9 27 04 00 00    	mov    r9d,0x427
   181b11a04:	e8 37 b4 67 fe       	call   0x18018ce40
   181b11a09:	90                   	nop
   181b11a0a:	4c 8d b6 50 03 00 00 	lea    r14,[rsi+0x350]
   181b11a11:	4c 8b be 58 03 00 00 	mov    r15,QWORD PTR [rsi+0x358]
   181b11a18:	48 8d 95 e0 01 00 00 	lea    rdx,[rbp+0x1e0]
   181b11a1f:	4c 89 f1             	mov    rcx,r14
   181b11a22:	e8 69 57 af fe       	call   0x180607190
   181b11a27:	90                   	nop
   181b11a28:	48 8d 8d c0 01 00 00 	lea    rcx,[rbp+0x1c0]
   181b11a2f:	48 8d 95 e0 01 00 00 	lea    rdx,[rbp+0x1e0]
   181b11a36:	4d 89 f8             	mov    r8,r15
   181b11a39:	e8 22 58 af fe       	call   0x180607260
   181b11a3e:	90                   	nop
   181b11a3f:	48 8d 8d e0 01 00 00 	lea    rcx,[rbp+0x1e0]
   181b11a46:	e8 d5 56 af fe       	call   0x180607120
   181b11a4b:	48 c7 45 70 00 00 00 	mov    QWORD PTR [rbp+0x70],0x0
   181b11a52:	00 
   181b11a53:	48 8d 05 7e 43 a8 06 	lea    rax,[rip+0x6a8437e]        # 0x188595dd8
   181b11a5a:	48 89 45 38          	mov    QWORD PTR [rbp+0x38],rax
   181b11a5e:	48 8d 4d 40          	lea    rcx,[rbp+0x40]
   181b11a62:	48 8d 95 c0 01 00 00 	lea    rdx,[rbp+0x1c0]
   181b11a69:	e8 c2 ae 5e fe       	call   0x1800fc930
   181b11a6e:	48 8b 85 c8 01 00 00 	mov    rax,QWORD PTR [rbp+0x1c8]
   181b11a75:	48 89 45 48          	mov    QWORD PTR [rbp+0x48],rax
   181b11a79:	48 8d 45 38          	lea    rax,[rbp+0x38]
   181b11a7d:	48 89 45 70          	mov    QWORD PTR [rbp+0x70],rax
   181b11a81:	4c 8b be 58 03 00 00 	mov    r15,QWORD PTR [rsi+0x358]
   181b11a88:	c6 85 26 02 00 00 01 	mov    BYTE PTR [rbp+0x226],0x1
   181b11a8f:	48 8d 95 e0 01 00 00 	lea    rdx,[rbp+0x1e0]
   181b11a96:	4c 89 f1             	mov    rcx,r14
   181b11a99:	e8 f2 56 af fe       	call   0x180607190
   181b11a9e:	90                   	nop
   181b11a9f:	48 8d 8d d0 01 00 00 	lea    rcx,[rbp+0x1d0]
   181b11aa6:	48 8d 95 e0 01 00 00 	lea    rdx,[rbp+0x1e0]
   181b11aad:	4d 89 f8             	mov    r8,r15
   181b11ab0:	e8 ab 57 af fe       	call   0x180607260
   181b11ab5:	90                   	nop
   181b11ab6:	48 8d 8d e0 01 00 00 	lea    rcx,[rbp+0x1e0]
   181b11abd:	e8 5e 56 af fe       	call   0x180607120
   181b11ac2:	48 c7 85 b0 00 00 00 	mov    QWORD PTR [rbp+0xb0],0x0
   181b11ac9:	00 00 00 00 
   181b11acd:	48 8d 05 c4 43 a8 06 	lea    rax,[rip+0x6a843c4]        # 0x188595e98
   181b11ad4:	48 89 45 78          	mov    QWORD PTR [rbp+0x78],rax
   181b11ad8:	48 8d 8d 80 00 00 00 	lea    rcx,[rbp+0x80]
   181b11adf:	48 8d 95 d0 01 00 00 	lea    rdx,[rbp+0x1d0]
   181b11ae6:	e8 45 ae 5e fe       	call   0x1800fc930
   181b11aeb:	48 8b 85 d8 01 00 00 	mov    rax,QWORD PTR [rbp+0x1d8]
   181b11af2:	48 89 85 88 00 00 00 	mov    QWORD PTR [rbp+0x88],rax
   181b11af9:	48 8d 45 78          	lea    rax,[rbp+0x78]
   181b11afd:	48 89 85 b0 00 00 00 	mov    QWORD PTR [rbp+0xb0],rax
   181b11b04:	0f 57 c0             	xorps  xmm0,xmm0
   181b11b07:	0f 29 85 f0 01 00 00 	movaps XMMWORD PTR [rbp+0x1f0],xmm0
   181b11b0e:	0f 29 85 e0 01 00 00 	movaps XMMWORD PTR [rbp+0x1e0],xmm0
   181b11b15:	4c 8b 77 48          	mov    r14,QWORD PTR [rdi+0x48]
   181b11b19:	48 83 7f 50 10       	cmp    QWORD PTR [rdi+0x50],0x10
   181b11b1e:	72 06                	jb     0x181b11b26
   181b11b20:	4c 8b 7f 38          	mov    r15,QWORD PTR [rdi+0x38]
   181b11b24:	eb 04                	jmp    0x181b11b2a
   181b11b26:	4c 8d 7f 38          	lea    r15,[rdi+0x38]
   181b11b2a:	4d 85 f6             	test   r14,r14
   181b11b2d:	0f 88 76 08 00 00    	js     0x181b123a9
   181b11b33:	49 83 fe 0f          	cmp    r14,0xf
   181b11b37:	77 22                	ja     0x181b11b5b
   181b11b39:	4c 89 b5 f0 01 00 00 	mov    QWORD PTR [rbp+0x1f0],r14
   181b11b40:	48 c7 85 f8 01 00 00 	mov    QWORD PTR [rbp+0x1f8],0xf
   181b11b47:	0f 00 00 00 
   181b11b4b:	41 0f 10 07          	movups xmm0,XMMWORD PTR [r15]
   181b11b4f:	0f 29 85 e0 01 00 00 	movaps XMMWORD PTR [rbp+0x1e0],xmm0
   181b11b56:	e9 81 00 00 00       	jmp    0x181b11bdc
   181b11b5b:	4c 89 f0             	mov    rax,r14
   181b11b5e:	48 83 c8 0f          	or     rax,0xf
   181b11b62:	48 83 f8 17          	cmp    rax,0x17
   181b11b66:	41 bc 16 00 00 00    	mov    r12d,0x16
   181b11b6c:	4c 0f 43 e0          	cmovae r12,rax
   181b11b70:	48 3d ff 0f 00 00    	cmp    rax,0xfff
   181b11b76:	72 2c                	jb     0x181b11ba4
   181b11b78:	49 8d 4c 24 28       	lea    rcx,[r12+0x28]
   181b11b7d:	c6 85 27 02 00 00 01 	mov    BYTE PTR [rbp+0x227],0x1
   181b11b84:	e8 73 b5 cf 04       	call   0x18680d0fc
   181b11b89:	90                   	nop
   181b11b8a:	48 85 c0             	test   rax,rax
   181b11b8d:	0f 84 23 08 00 00    	je     0x181b123b6
   181b11b93:	48 89 c1             	mov    rcx,rax
   181b11b96:	48 83 c0 27          	add    rax,0x27
   181b11b9a:	48 83 e0 e0          	and    rax,0xffffffffffffffe0
   181b11b9e:	48 89 48 f8          	mov    QWORD PTR [rax-0x8],rcx
   181b11ba2:	eb 12                	jmp    0x181b11bb6
   181b11ba4:	49 8d 4c 24 01       	lea    rcx,[r12+0x1]
   181b11ba9:	c6 85 27 02 00 00 01 	mov    BYTE PTR [rbp+0x227],0x1
   181b11bb0:	e8 47 b5 cf 04       	call   0x18680d0fc
   181b11bb5:	90                   	nop
   181b11bb6:	48 89 85 e0 01 00 00 	mov    QWORD PTR [rbp+0x1e0],rax
   181b11bbd:	4c 89 b5 f0 01 00 00 	mov    QWORD PTR [rbp+0x1f0],r14
   181b11bc4:	4c 89 a5 f8 01 00 00 	mov    QWORD PTR [rbp+0x1f8],r12
   181b11bcb:	49 ff c6             	inc    r14
   181b11bce:	48 89 c1             	mov    rcx,rax
   181b11bd1:	4c 89 fa             	mov    rdx,r15
   181b11bd4:	4d 89 f0             	mov    r8,r14
   181b11bd7:	e8 f4 44 d8 04       	call   0x1868960d0
   181b11bdc:	48 8d 85 00 02 00 00 	lea    rax,[rbp+0x200]
   181b11be3:	0f 57 c0             	xorps  xmm0,xmm0
   181b11be6:	0f 29 85 00 02 00 00 	movaps XMMWORD PTR [rbp+0x200],xmm0
   181b11bed:	48 8b 4f 60          	mov    rcx,QWORD PTR [rdi+0x60]
   181b11bf1:	48 85 c9             	test   rcx,rcx
   181b11bf4:	4c 8d 4d 38          	lea    r9,[rbp+0x38]
   181b11bf8:	74 0a                	je     0x181b11c04
   181b11bfa:	f0 ff 41 08          	lock inc DWORD PTR [rcx+0x8]
   181b11bfe:	48 8b 4f 60          	mov    rcx,QWORD PTR [rdi+0x60]
   181b11c02:	eb 02                	jmp    0x181b11c06
   181b11c04:	31 c9                	xor    ecx,ecx
   181b11c06:	48 8b 57 58          	mov    rdx,QWORD PTR [rdi+0x58]
   181b11c0a:	4c 8d 05 47 43 a8 06 	lea    r8,[rip+0x6a84347]        # 0x188595f58
   181b11c11:	4c 89 45 e0          	mov    QWORD PTR [rbp-0x20],r8
   181b11c15:	0f 28 8d e0 01 00 00 	movaps xmm1,XMMWORD PTR [rbp+0x1e0]
   181b11c1c:	0f 28 95 f0 01 00 00 	movaps xmm2,XMMWORD PTR [rbp+0x1f0]
   181b11c23:	0f 11 4d e8          	movups XMMWORD PTR [rbp-0x18],xmm1
   181b11c27:	0f 11 55 f8          	movups XMMWORD PTR [rbp-0x8],xmm2
   181b11c2b:	48 c7 85 f0 01 00 00 	mov    QWORD PTR [rbp+0x1f0],0x0
   181b11c32:	00 00 00 00 
   181b11c36:	48 c7 85 f8 01 00 00 	mov    QWORD PTR [rbp+0x1f8],0xf
   181b11c3d:	0f 00 00 00 
   181b11c41:	c6 85 e0 01 00 00 00 	mov    BYTE PTR [rbp+0x1e0],0x0
   181b11c48:	48 89 55 08          	mov    QWORD PTR [rbp+0x8],rdx
   181b11c4c:	48 89 4d 10          	mov    QWORD PTR [rbp+0x10],rcx
   181b11c50:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   181b11c53:	4c 8d 45 e0          	lea    r8,[rbp-0x20]
   181b11c57:	4c 89 45 18          	mov    QWORD PTR [rbp+0x18],r8
   181b11c5b:	48 89 5c 24 28       	mov    QWORD PTR [rsp+0x28],rbx
   181b11c60:	4c 89 4c 24 20       	mov    QWORD PTR [rsp+0x20],r9
   181b11c65:	48 8d 9d b8 00 00 00 	lea    rbx,[rbp+0xb8]
   181b11c6c:	48 8d 55 b8          	lea    rdx,[rbp-0x48]
   181b11c70:	4c 8d 4d 78          	lea    r9,[rbp+0x78]
   181b11c74:	48 89 d9             	mov    rcx,rbx
   181b11c77:	e8 a4 4e b6 ff       	call   0x181676b20
   181b11c7c:	90                   	nop
   181b11c7d:	4c 8b 75 d8          	mov    r14,QWORD PTR [rbp-0x28]
   181b11c81:	4d 85 f6             	test   r14,r14
   181b11c84:	74 1f                	je     0x181b11ca5
   181b11c86:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   181b11c8b:	75 18                	jne    0x181b11ca5
   181b11c8d:	49 8b 06             	mov    rax,QWORD PTR [r14]
   181b11c90:	4c 89 f1             	mov    rcx,r14
   181b11c93:	ff 10                	call   QWORD PTR [rax]
   181b11c95:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   181b11c9a:	75 09                	jne    0x181b11ca5
   181b11c9c:	49 8b 06             	mov    rax,QWORD PTR [r14]
   181b11c9f:	4c 89 f1             	mov    rcx,r14
   181b11ca2:	ff 50 08             	call   QWORD PTR [rax+0x8]
   181b11ca5:	4c 8b 75 c8          	mov    r14,QWORD PTR [rbp-0x38]
   181b11ca9:	4d 85 f6             	test   r14,r14
   181b11cac:	74 1f                	je     0x181b11ccd
   181b11cae:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   181b11cb3:	75 18                	jne    0x181b11ccd
   181b11cb5:	49 8b 06             	mov    rax,QWORD PTR [r14]
   181b11cb8:	4c 89 f1             	mov    rcx,r14
   181b11cbb:	ff 10                	call   QWORD PTR [rax]
   181b11cbd:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   181b11cc2:	75 09                	jne    0x181b11ccd
   181b11cc4:	49 8b 06             	mov    rax,QWORD PTR [r14]
   181b11cc7:	4c 89 f1             	mov    rcx,r14
   181b11cca:	ff 50 08             	call   QWORD PTR [rax+0x8]
   181b11ccd:	4c 8b b5 08 02 00 00 	mov    r14,QWORD PTR [rbp+0x208]
   181b11cd4:	4d 85 f6             	test   r14,r14
   181b11cd7:	74 1f                	je     0x181b11cf8
   181b11cd9:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   181b11cde:	75 18                	jne    0x181b11cf8
   181b11ce0:	49 8b 06             	mov    rax,QWORD PTR [r14]
   181b11ce3:	4c 89 f1             	mov    rcx,r14
   181b11ce6:	ff 10                	call   QWORD PTR [rax]
   181b11ce8:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   181b11ced:	75 09                	jne    0x181b11cf8
   181b11cef:	49 8b 06             	mov    rax,QWORD PTR [r14]
   181b11cf2:	4c 89 f1             	mov    rcx,r14
   181b11cf5:	ff 50 08             	call   QWORD PTR [rax+0x8]
   181b11cf8:	48 8b 85 f8 01 00 00 	mov    rax,QWORD PTR [rbp+0x1f8]
   181b11cff:	48 83 f8 10          	cmp    rax,0x10
   181b11d03:	72 38                	jb     0x181b11d3d
   181b11d05:	48 8b 8d e0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1e0]
   181b11d0c:	48 8d 50 01          	lea    rdx,[rax+0x1]
   181b11d10:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   181b11d17:	72 1f                	jb     0x181b11d38
   181b11d19:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   181b11d1d:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   181b11d21:	4c 29 c1             	sub    rcx,r8
   181b11d24:	48 83 f9 20          	cmp    rcx,0x20
   181b11d28:	0f 83 88 06 00 00    	jae    0x181b123b6
   181b11d2e:	48 83 c0 28          	add    rax,0x28
   181b11d32:	48 89 c2             	mov    rdx,rax
   181b11d35:	4c 89 c1             	mov    rcx,r8
   181b11d38:	e8 03 b4 cf 04       	call   0x18680d140
   181b11d3d:	48 8d 8d d0 01 00 00 	lea    rcx,[rbp+0x1d0]
   181b11d44:	e8 d7 53 af fe       	call   0x180607120
   181b11d49:	48 8d 8d c0 01 00 00 	lea    rcx,[rbp+0x1c0]
   181b11d50:	e8 cb 53 af fe       	call   0x180607120
   181b11d55:	48 8b 8d 00 01 00 00 	mov    rcx,QWORD PTR [rbp+0x100]
   181b11d5c:	48 85 c9             	test   rcx,rcx
   181b11d5f:	74 0c                	je     0x181b11d6d
   181b11d61:	f0 ff 49 0c          	lock dec DWORD PTR [rcx+0xc]
   181b11d65:	75 06                	jne    0x181b11d6d
   181b11d67:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   181b11d6a:	ff 50 08             	call   QWORD PTR [rax+0x8]
   181b11d6d:	48 8b 8d f0 00 00 00 	mov    rcx,QWORD PTR [rbp+0xf0]
   181b11d74:	48 85 c9             	test   rcx,rcx
   181b11d77:	74 0c                	je     0x181b11d85
   181b11d79:	48 39 d9             	cmp    rcx,rbx
   181b11d7c:	0f 95 c2             	setne  dl
   181b11d7f:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   181b11d82:	ff 50 20             	call   QWORD PTR [rax+0x20]
   181b11d85:	48 8b 8e 58 02 00 00 	mov    rcx,QWORD PTR [rsi+0x258]
   181b11d8c:	49 bf 01 00 00 00 01 	movabs r15,0x100000001
   181b11d93:	00 00 00 
   181b11d96:	48 85 c9             	test   rcx,rcx
   181b11d99:	0f 84 b6 00 00 00    	je     0x181b11e55
   181b11d9f:	4c 8d 47 70          	lea    r8,[rdi+0x70]
   181b11da3:	8b 57 68             	mov    edx,DWORD PTR [rdi+0x68]
   181b11da6:	e8 e5 5d ec 01       	call   0x1839d7b90
   181b11dab:	0f 57 c0             	xorps  xmm0,xmm0
   181b11dae:	48 8b 9e 60 02 00 00 	mov    rbx,QWORD PTR [rsi+0x260]
   181b11db5:	0f 11 86 58 02 00 00 	movups XMMWORD PTR [rsi+0x258],xmm0
   181b11dbc:	48 85 db             	test   rbx,rbx
   181b11dbf:	74 1d                	je     0x181b11dde
   181b11dc1:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   181b11dc5:	75 17                	jne    0x181b11dde
   181b11dc7:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   181b11dca:	48 89 d9             	mov    rcx,rbx
   181b11dcd:	ff 10                	call   QWORD PTR [rax]
   181b11dcf:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   181b11dd3:	75 09                	jne    0x181b11dde
   181b11dd5:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   181b11dd8:	48 89 d9             	mov    rcx,rbx
   181b11ddb:	ff 50 08             	call   QWORD PTR [rax+0x8]
   181b11dde:	4c 8d b6 d8 02 00 00 	lea    r14,[rsi+0x2d8]
   181b11de5:	b9 30 01 00 00       	mov    ecx,0x130
   181b11dea:	e8 0d b3 cf 04       	call   0x18680d0fc
   181b11def:	48 89 c3             	mov    rbx,rax
   181b11df2:	4c 89 78 08          	mov    QWORD PTR [rax+0x8],r15
   181b11df6:	48 8d 05 1b 42 a8 06 	lea    rax,[rip+0x6a8421b]        # 0x188596018
   181b11dfd:	48 89 03             	mov    QWORD PTR [rbx],rax
   181b11e00:	48 89 9d 18 02 00 00 	mov    QWORD PTR [rbp+0x218],rbx
   181b11e07:	48 83 c3 10          	add    rbx,0x10
   181b11e0b:	48 89 d9             	mov    rcx,rbx
   181b11e0e:	4c 89 f2             	mov    rdx,r14
   181b11e11:	e8 5a 28 ec 01       	call   0x1839d4670
   181b11e16:	90                   	nop
   181b11e17:	48 89 9e 58 02 00 00 	mov    QWORD PTR [rsi+0x258],rbx
   181b11e1e:	48 8b 9e 60 02 00 00 	mov    rbx,QWORD PTR [rsi+0x260]
   181b11e25:	48 8b 85 18 02 00 00 	mov    rax,QWORD PTR [rbp+0x218]
   181b11e2c:	48 89 86 60 02 00 00 	mov    QWORD PTR [rsi+0x260],rax
   181b11e33:	48 85 db             	test   rbx,rbx
   181b11e36:	74 1d                	je     0x181b11e55
   181b11e38:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   181b11e3c:	75 17                	jne    0x181b11e55
   181b11e3e:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   181b11e41:	48 89 d9             	mov    rcx,rbx
   181b11e44:	ff 10                	call   QWORD PTR [rax]
   181b11e46:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   181b11e4a:	75 09                	jne    0x181b11e55
   181b11e4c:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   181b11e4f:	48 89 d9             	mov    rcx,rbx
   181b11e52:	ff 50 08             	call   QWORD PTR [rax+0x8]
   181b11e55:	48 8b 86 18 03 00 00 	mov    rax,QWORD PTR [rsi+0x318]
   181b11e5c:	48 8b 88 20 01 00 00 	mov    rcx,QWORD PTR [rax+0x120]
   181b11e63:	e8 58 3a ed 01       	call   0x1839e58c0
   181b11e68:	48 8b 8e 20 02 00 00 	mov    rcx,QWORD PTR [rsi+0x220]
   181b11e6f:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   181b11e72:	ff 90 c0 01 00 00    	call   QWORD PTR [rax+0x1c0]
   181b11e78:	48 8b 47 78          	mov    rax,QWORD PTR [rdi+0x78]
   181b11e7c:	8b 48 0c             	mov    ecx,DWORD PTR [rax+0xc]
   181b11e7f:	3b 48 08             	cmp    ecx,DWORD PTR [rax+0x8]
   181b11e82:	74 13                	je     0x181b11e97
   181b11e84:	48 83 c7 78          	add    rdi,0x78
   181b11e88:	48 8b 8e 20 02 00 00 	mov    rcx,QWORD PTR [rsi+0x220]
   181b11e8f:	48 89 fa             	mov    rdx,rdi
   181b11e92:	e8 19 45 59 00       	call   0x1820a63b0
   181b11e97:	48 8b 8e 18 03 00 00 	mov    rcx,QWORD PTR [rsi+0x318]
   181b11e9e:	0f 57 c0             	xorps  xmm0,xmm0
   181b11ea1:	0f 29 45 20          	movaps XMMWORD PTR [rbp+0x20],xmm0
   181b11ea5:	48 8d 55 20          	lea    rdx,[rbp+0x20]
   181b11ea9:	e8 d2 e3 ea 01       	call   0x1839c0280
   181b11eae:	48 8b 8e 20 02 00 00 	mov    rcx,QWORD PTR [rsi+0x220]
   181b11eb5:	48 85 c9             	test   rcx,rcx
   181b11eb8:	74 23                	je     0x181b11edd
   181b11eba:	e8 91 79 f8 ff       	call   0x181a99850
   181b11ebf:	48 85 c0             	test   rax,rax
   181b11ec2:	74 19                	je     0x181b11edd
   181b11ec4:	48 8b 8e 20 02 00 00 	mov    rcx,QWORD PTR [rsi+0x220]
   181b11ecb:	e8 80 79 f8 ff       	call   0x181a99850
   181b11ed0:	48 89 c1             	mov    rcx,rax
   181b11ed3:	ba 03 00 00 00       	mov    edx,0x3
   181b11ed8:	e8 f3 36 54 00       	call   0x1820555d0
   181b11edd:	48 8b 86 a0 01 00 00 	mov    rax,QWORD PTR [rsi+0x1a0]
   181b11ee4:	48 8b 48 10          	mov    rcx,QWORD PTR [rax+0x10]
   181b11ee8:	48 85 c9             	test   rcx,rcx
   181b11eeb:	48 89 8d 18 02 00 00 	mov    QWORD PTR [rbp+0x218],rcx
   181b11ef2:	74 0a                	je     0x181b11efe
   181b11ef4:	48 8b 78 08          	mov    rdi,QWORD PTR [rax+0x8]
   181b11ef8:	f0 ff 41 0c          	lock inc DWORD PTR [rcx+0xc]
   181b11efc:	eb 02                	jmp    0x181b11f00
   181b11efe:	31 ff                	xor    edi,edi
   181b11f00:	b9 18 00 00 00       	mov    ecx,0x18
   181b11f05:	e8 f2 b1 cf 04       	call   0x18680d0fc
   181b11f0a:	90                   	nop
   181b11f0b:	4c 89 78 08          	mov    QWORD PTR [rax+0x8],r15
   181b11f0f:	48 8d 0d 02 73 66 06 	lea    rcx,[rip+0x6667302]        # 0x188179218
   181b11f16:	48 89 08             	mov    QWORD PTR [rax],rcx
   181b11f19:	48 89 c1             	mov    rcx,rax
   181b11f1c:	48 83 c1 10          	add    rcx,0x10
   181b11f20:	c6 40 10 00          	mov    BYTE PTR [rax+0x10],0x0
   181b11f24:	48 89 8d b8 00 00 00 	mov    QWORD PTR [rbp+0xb8],rcx
   181b11f2b:	48 89 85 c0 00 00 00 	mov    QWORD PTR [rbp+0xc0],rax
   181b11f32:	48 c7 85 00 01 00 00 	mov    QWORD PTR [rbp+0x100],0x0
   181b11f39:	00 00 00 00 
   181b11f3d:	48 c7 85 40 01 00 00 	mov    QWORD PTR [rbp+0x140],0x0
   181b11f44:	00 00 00 00 
   181b11f48:	0f 57 c0             	xorps  xmm0,xmm0
   181b11f4b:	0f 11 85 80 01 00 00 	movups XMMWORD PTR [rbp+0x180],xmm0
   181b11f52:	48 89 bd 90 01 00 00 	mov    QWORD PTR [rbp+0x190],rdi
   181b11f59:	48 8b 85 18 02 00 00 	mov    rax,QWORD PTR [rbp+0x218]
   181b11f60:	48 89 85 98 01 00 00 	mov    QWORD PTR [rbp+0x198],rax
   181b11f67:	c7 85 e0 01 00 00 00 	mov    DWORD PTR [rbp+0x1e0],0x0
   181b11f6e:	00 00 00 
   181b11f71:	48 8d 8d b8 00 00 00 	lea    rcx,[rbp+0xb8]
   181b11f78:	48 8d 95 e0 01 00 00 	lea    rdx,[rbp+0x1e0]
   181b11f7f:	e8 6c 0a 54 fe       	call   0x1800529f0
   181b11f84:	90                   	nop
   181b11f85:	48 8b 8d 98 01 00 00 	mov    rcx,QWORD PTR [rbp+0x198]
   181b11f8c:	48 85 c9             	test   rcx,rcx
   181b11f8f:	74 0c                	je     0x181b11f9d
   181b11f91:	f0 ff 49 0c          	lock dec DWORD PTR [rcx+0xc]
   181b11f95:	75 06                	jne    0x181b11f9d
   181b11f97:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   181b11f9a:	ff 50 08             	call   QWORD PTR [rax+0x8]
   181b11f9d:	48 8b 8d 80 01 00 00 	mov    rcx,QWORD PTR [rbp+0x180]
   181b11fa4:	48 85 c9             	test   rcx,rcx
   181b11fa7:	74 1e                	je     0x181b11fc7
   181b11fa9:	48 8d 85 48 01 00 00 	lea    rax,[rbp+0x148]
   181b11fb0:	48 39 c1             	cmp    rcx,rax
   181b11fb3:	0f 95 c2             	setne  dl
   181b11fb6:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   181b11fb9:	ff 50 20             	call   QWORD PTR [rax+0x20]
   181b11fbc:	48 c7 85 80 01 00 00 	mov    QWORD PTR [rbp+0x180],0x0
   181b11fc3:	00 00 00 00 
   181b11fc7:	48 8b 8d 40 01 00 00 	mov    rcx,QWORD PTR [rbp+0x140]
   181b11fce:	48 85 c9             	test   rcx,rcx
   181b11fd1:	74 1e                	je     0x181b11ff1
   181b11fd3:	48 8d 85 08 01 00 00 	lea    rax,[rbp+0x108]
   181b11fda:	48 39 c1             	cmp    rcx,rax
   181b11fdd:	0f 95 c2             	setne  dl
   181b11fe0:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   181b11fe3:	ff 50 20             	call   QWORD PTR [rax+0x20]
   181b11fe6:	48 c7 85 40 01 00 00 	mov    QWORD PTR [rbp+0x140],0x0
   181b11fed:	00 00 00 00 
   181b11ff1:	48 8b 8d 00 01 00 00 	mov    rcx,QWORD PTR [rbp+0x100]
   181b11ff8:	48 85 c9             	test   rcx,rcx
   181b11ffb:	74 1e                	je     0x181b1201b
   181b11ffd:	48 8d 85 c8 00 00 00 	lea    rax,[rbp+0xc8]
   181b12004:	48 39 c1             	cmp    rcx,rax
   181b12007:	0f 95 c2             	setne  dl
   181b1200a:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   181b1200d:	ff 50 20             	call   QWORD PTR [rax+0x20]
   181b12010:	48 c7 85 00 01 00 00 	mov    QWORD PTR [rbp+0x100],0x0
   181b12017:	00 00 00 00 
   181b1201b:	48 8b bd c0 00 00 00 	mov    rdi,QWORD PTR [rbp+0xc0]
   181b12022:	48 85 ff             	test   rdi,rdi
   181b12025:	74 1d                	je     0x181b12044
   181b12027:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   181b1202b:	75 17                	jne    0x181b12044
   181b1202d:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   181b12030:	48 89 f9             	mov    rcx,rdi
   181b12033:	ff 10                	call   QWORD PTR [rax]
   181b12035:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   181b12039:	75 09                	jne    0x181b12044
   181b1203b:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   181b1203e:	48 89 f9             	mov    rcx,rdi
   181b12041:	ff 50 08             	call   QWORD PTR [rax+0x8]
   181b12044:	48 8b be 18 03 00 00 	mov    rdi,QWORD PTR [rsi+0x318]
   181b1204b:	48 8b 8e 20 02 00 00 	mov    rcx,QWORD PTR [rsi+0x220]
   181b12052:	48 8d 95 c0 01 00 00 	lea    rdx,[rbp+0x1c0]
   181b12059:	41 b0 01             	mov    r8b,0x1
   181b1205c:	e8 3f 14 59 00       	call   0x1820a34a0
   181b12061:	48 8b 85 c0 01 00 00 	mov    rax,QWORD PTR [rbp+0x1c0]
   181b12068:	48 89 85 e0 01 00 00 	mov    QWORD PTR [rbp+0x1e0],rax
   181b1206f:	48 8d 05 22 67 54 08 	lea    rax,[rip+0x8546722]        # 0x18a058798
   181b12076:	48 89 85 c0 01 00 00 	mov    QWORD PTR [rbp+0x1c0],rax
   181b1207d:	c6 85 e8 01 00 00 01 	mov    BYTE PTR [rbp+0x1e8],0x1
   181b12084:	48 8b 8e 20 02 00 00 	mov    rcx,QWORD PTR [rsi+0x220]
   181b1208b:	48 8d 95 d0 01 00 00 	lea    rdx,[rbp+0x1d0]
   181b12092:	e8 09 2c 59 00       	call   0x1820a4ca0
   181b12097:	90                   	nop
   181b12098:	48 8b 85 d0 01 00 00 	mov    rax,QWORD PTR [rbp+0x1d0]
   181b1209f:	48 89 85 a0 01 00 00 	mov    QWORD PTR [rbp+0x1a0],rax
   181b120a6:	48 8d 05 73 66 54 08 	lea    rax,[rip+0x8546673]        # 0x18a058720
   181b120ad:	48 89 85 d0 01 00 00 	mov    QWORD PTR [rbp+0x1d0],rax
   181b120b4:	c6 85 a8 01 00 00 01 	mov    BYTE PTR [rbp+0x1a8],0x1
   181b120bb:	48 89 f1             	mov    rcx,rsi
   181b120be:	e8 6d a5 fe ff       	call   0x181afc630
   181b120c3:	90                   	nop
   181b120c4:	89 c3                	mov    ebx,eax
   181b120c6:	c7 85 b8 00 00 00 0a 	mov    DWORD PTR [rbp+0xb8],0xa
   181b120cd:	00 00 00 
   181b120d0:	0f 57 c0             	xorps  xmm0,xmm0
   181b120d3:	0f 11 85 c0 00 00 00 	movups XMMWORD PTR [rbp+0xc0],xmm0
   181b120da:	0f 11 85 d0 00 00 00 	movups XMMWORD PTR [rbp+0xd0],xmm0
   181b120e1:	4c 8b b6 e8 02 00 00 	mov    r14,QWORD PTR [rsi+0x2e8]
   181b120e8:	48 83 be f0 02 00 00 	cmp    QWORD PTR [rsi+0x2f0],0x10
   181b120ef:	10 
   181b120f0:	72 09                	jb     0x181b120fb
   181b120f2:	4c 8b be d8 02 00 00 	mov    r15,QWORD PTR [rsi+0x2d8]
   181b120f9:	eb 07                	jmp    0x181b12102
   181b120fb:	4c 8d be d8 02 00 00 	lea    r15,[rsi+0x2d8]
   181b12102:	4d 85 f6             	test   r14,r14
   181b12105:	0f 88 b1 02 00 00    	js     0x181b123bc
   181b1210b:	49 83 fe 0f          	cmp    r14,0xf
   181b1210f:	77 22                	ja     0x181b12133
   181b12111:	48 8d 85 c0 00 00 00 	lea    rax,[rbp+0xc0]
   181b12118:	4c 89 b5 d0 00 00 00 	mov    QWORD PTR [rbp+0xd0],r14
   181b1211f:	48 c7 85 d8 00 00 00 	mov    QWORD PTR [rbp+0xd8],0xf
   181b12126:	0f 00 00 00 
   181b1212a:	41 0f 10 07          	movups xmm0,XMMWORD PTR [r15]
   181b1212e:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   181b12131:	eb 73                	jmp    0x181b121a6
   181b12133:	4c 89 f0             	mov    rax,r14
   181b12136:	48 83 c8 0f          	or     rax,0xf
   181b1213a:	48 83 f8 17          	cmp    rax,0x17
   181b1213e:	41 bc 16 00 00 00    	mov    r12d,0x16
   181b12144:	4c 0f 43 e0          	cmovae r12,rax
   181b12148:	48 3d ff 0f 00 00    	cmp    rax,0xfff
   181b1214e:	72 25                	jb     0x181b12175
   181b12150:	49 8d 4c 24 28       	lea    rcx,[r12+0x28]
   181b12155:	e8 a2 af cf 04       	call   0x18680d0fc
   181b1215a:	90                   	nop
   181b1215b:	48 85 c0             	test   rax,rax
   181b1215e:	0f 84 52 02 00 00    	je     0x181b123b6
   181b12164:	48 89 c1             	mov    rcx,rax
   181b12167:	48 83 c0 27          	add    rax,0x27
   181b1216b:	48 83 e0 e0          	and    rax,0xffffffffffffffe0
   181b1216f:	48 89 48 f8          	mov    QWORD PTR [rax-0x8],rcx
   181b12173:	eb 0b                	jmp    0x181b12180
   181b12175:	49 8d 4c 24 01       	lea    rcx,[r12+0x1]
   181b1217a:	e8 7d af cf 04       	call   0x18680d0fc
   181b1217f:	90                   	nop
   181b12180:	48 89 85 c0 00 00 00 	mov    QWORD PTR [rbp+0xc0],rax
   181b12187:	4c 89 b5 d0 00 00 00 	mov    QWORD PTR [rbp+0xd0],r14
   181b1218e:	4c 89 a5 d8 00 00 00 	mov    QWORD PTR [rbp+0xd8],r12
   181b12195:	49 ff c6             	inc    r14
   181b12198:	48 89 c1             	mov    rcx,rax
   181b1219b:	4c 89 fa             	mov    rdx,r15
   181b1219e:	4d 89 f0             	mov    r8,r14
   181b121a1:	e8 2a 3f d8 04       	call   0x1868960d0
   181b121a6:	88 9d e0 00 00 00    	mov    BYTE PTR [rbp+0xe0],bl
   181b121ac:	48 8d 95 b8 00 00 00 	lea    rdx,[rbp+0xb8]
   181b121b3:	4c 8d 85 a0 01 00 00 	lea    r8,[rbp+0x1a0]
   181b121ba:	4c 8d 8d e0 01 00 00 	lea    r9,[rbp+0x1e0]
   181b121c1:	48 89 f9             	mov    rcx,rdi
   181b121c4:	e8 07 e6 ea 01       	call   0x1839c07d0
   181b121c9:	90                   	nop
   181b121ca:	48 8b 85 d8 00 00 00 	mov    rax,QWORD PTR [rbp+0xd8]
   181b121d1:	48 83 f8 10          	cmp    rax,0x10
   181b121d5:	72 38                	jb     0x181b1220f
   181b121d7:	48 8b 8d c0 00 00 00 	mov    rcx,QWORD PTR [rbp+0xc0]
   181b121de:	48 8d 50 01          	lea    rdx,[rax+0x1]
   181b121e2:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   181b121e9:	72 1f                	jb     0x181b1220a
   181b121eb:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   181b121ef:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   181b121f3:	4c 29 c1             	sub    rcx,r8
   181b121f6:	48 83 f9 20          	cmp    rcx,0x20
   181b121fa:	0f 83 b6 01 00 00    	jae    0x181b123b6
   181b12200:	48 83 c0 28          	add    rax,0x28
   181b12204:	48 89 c2             	mov    rdx,rax
   181b12207:	4c 89 c1             	mov    rcx,r8
   181b1220a:	e8 31 af cf 04       	call   0x18680d140
   181b1220f:	80 bd a8 01 00 00 01 	cmp    BYTE PTR [rbp+0x1a8],0x1
   181b12216:	75 2e                	jne    0x181b12246
   181b12218:	48 8b 8d a0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1a0]
   181b1221f:	8b 01                	mov    eax,DWORD PTR [rcx]
   181b12221:	83 f8 ff             	cmp    eax,0xffffffff
   181b12224:	74 20                	je     0x181b12246
   181b12226:	85 c0                	test   eax,eax
   181b12228:	74 0c                	je     0x181b12236
   181b1222a:	f0 ff 09             	lock dec DWORD PTR [rcx]
   181b1222d:	75 17                	jne    0x181b12246
   181b1222f:	48 8b 8d a0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1a0]
   181b12236:	ba 02 00 00 00       	mov    edx,0x2
   181b1223b:	41 b8 08 00 00 00    	mov    r8d,0x8
   181b12241:	e8 ca 55 52 fe       	call   0x180037810
   181b12246:	48 8b 8d d0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1d0]
   181b1224d:	8b 01                	mov    eax,DWORD PTR [rcx]
   181b1224f:	83 f8 ff             	cmp    eax,0xffffffff
   181b12252:	74 20                	je     0x181b12274
   181b12254:	85 c0                	test   eax,eax
   181b12256:	74 0c                	je     0x181b12264
   181b12258:	f0 ff 09             	lock dec DWORD PTR [rcx]
   181b1225b:	75 17                	jne    0x181b12274
   181b1225d:	48 8b 8d d0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1d0]
   181b12264:	ba 02 00 00 00       	mov    edx,0x2
   181b12269:	41 b8 08 00 00 00    	mov    r8d,0x8
   181b1226f:	e8 9c 55 52 fe       	call   0x180037810
   181b12274:	80 bd e8 01 00 00 01 	cmp    BYTE PTR [rbp+0x1e8],0x1
   181b1227b:	75 38                	jne    0x181b122b5
   181b1227d:	48 8b bd e0 01 00 00 	mov    rdi,QWORD PTR [rbp+0x1e0]
   181b12284:	8b 07                	mov    eax,DWORD PTR [rdi]
   181b12286:	83 f8 ff             	cmp    eax,0xffffffff
   181b12289:	74 2a                	je     0x181b122b5
   181b1228b:	85 c0                	test   eax,eax
   181b1228d:	74 0c                	je     0x181b1229b
   181b1228f:	f0 ff 0f             	lock dec DWORD PTR [rdi]
   181b12292:	75 21                	jne    0x181b122b5
   181b12294:	48 8b bd e0 01 00 00 	mov    rdi,QWORD PTR [rbp+0x1e0]
   181b1229b:	4c 63 7f 0c          	movsxd r15,DWORD PTR [rdi+0xc]
   181b1229f:	4c 63 67 08          	movsxd r12,DWORD PTR [rdi+0x8]
   181b122a3:	45 39 fc             	cmp    r12d,r15d
   181b122a6:	0f 85 a9 00 00 00    	jne    0x181b12355
   181b122ac:	48 89 f9             	mov    rcx,rdi
   181b122af:	e8 4c 58 52 fe       	call   0x180037b00
   181b122b4:	90                   	nop
   181b122b5:	48 8b bd c0 01 00 00 	mov    rdi,QWORD PTR [rbp+0x1c0]
   181b122bc:	8b 07                	mov    eax,DWORD PTR [rdi]
   181b122be:	83 f8 ff             	cmp    eax,0xffffffff
   181b122c1:	74 26                	je     0x181b122e9
   181b122c3:	85 c0                	test   eax,eax
   181b122c5:	74 0c                	je     0x181b122d3
   181b122c7:	f0 ff 0f             	lock dec DWORD PTR [rdi]
   181b122ca:	75 1d                	jne    0x181b122e9
   181b122cc:	48 8b bd c0 01 00 00 	mov    rdi,QWORD PTR [rbp+0x1c0]
   181b122d3:	4c 63 7f 0c          	movsxd r15,DWORD PTR [rdi+0xc]
   181b122d7:	4c 63 67 08          	movsxd r12,DWORD PTR [rdi+0x8]
   181b122db:	45 39 fc             	cmp    r12d,r15d
   181b122de:	75 24                	jne    0x181b12304
   181b122e0:	48 89 f9             	mov    rcx,rdi
   181b122e3:	e8 18 58 52 fe       	call   0x180037b00
   181b122e8:	90                   	nop
   181b122e9:	48 89 f1             	mov    rcx,rsi
   181b122ec:	e8 3f 51 cf fe       	call   0x180807430
   181b122f1:	90                   	nop
   181b122f2:	48 81 c4 b0 02 00 00 	add    rsp,0x2b0
   181b122f9:	5b                   	pop    rbx
   181b122fa:	5f                   	pop    rdi
   181b122fb:	5e                   	pop    rsi
   181b122fc:	41 5c                	pop    r12
   181b122fe:	41 5e                	pop    r14
   181b12300:	41 5f                	pop    r15
   181b12302:	5d                   	pop    rbp
   181b12303:	c3                   	ret
   181b12304:	49 c1 e4 03          	shl    r12,0x3
   181b12308:	49 c1 e7 03          	shl    r15,0x3
   181b1230c:	eb 13                	jmp    0x181b12321
   181b1230e:	66 90                	xchg   ax,ax
   181b12310:	48 89 d9             	mov    rcx,rbx
   181b12313:	e8 20 ae cf 04       	call   0x18680d138
   181b12318:	49 83 c7 f8          	add    r15,0xfffffffffffffff8
   181b1231c:	4d 39 fc             	cmp    r12,r15
   181b1231f:	74 bf                	je     0x181b122e0
   181b12321:	4a 8b 5c 3f 08       	mov    rbx,QWORD PTR [rdi+r15*1+0x8]
   181b12326:	48 85 db             	test   rbx,rbx
   181b12329:	74 ed                	je     0x181b12318
   181b1232b:	4c 8b 73 08          	mov    r14,QWORD PTR [rbx+0x8]
   181b1232f:	4d 85 f6             	test   r14,r14
   181b12332:	74 dc                	je     0x181b12310
   181b12334:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   181b12339:	75 d5                	jne    0x181b12310
   181b1233b:	49 8b 06             	mov    rax,QWORD PTR [r14]
   181b1233e:	4c 89 f1             	mov    rcx,r14
   181b12341:	ff 10                	call   QWORD PTR [rax]
   181b12343:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   181b12348:	75 c6                	jne    0x181b12310
   181b1234a:	49 8b 06             	mov    rax,QWORD PTR [r14]
   181b1234d:	4c 89 f1             	mov    rcx,r14
   181b12350:	ff 50 08             	call   QWORD PTR [rax+0x8]
   181b12353:	eb bb                	jmp    0x181b12310
   181b12355:	49 c1 e4 03          	shl    r12,0x3
   181b12359:	49 c1 e7 03          	shl    r15,0x3
   181b1235d:	eb 16                	jmp    0x181b12375
   181b1235f:	90                   	nop
   181b12360:	48 89 d9             	mov    rcx,rbx
   181b12363:	e8 d0 ad cf 04       	call   0x18680d138
   181b12368:	49 83 c7 f8          	add    r15,0xfffffffffffffff8
   181b1236c:	4d 39 fc             	cmp    r12,r15
   181b1236f:	0f 84 37 ff ff ff    	je     0x181b122ac
   181b12375:	4a 8b 5c 3f 08       	mov    rbx,QWORD PTR [rdi+r15*1+0x8]
   181b1237a:	48 85 db             	test   rbx,rbx
   181b1237d:	74 e9                	je     0x181b12368
   181b1237f:	4c 8b 73 08          	mov    r14,QWORD PTR [rbx+0x8]
   181b12383:	4d 85 f6             	test   r14,r14
   181b12386:	74 d8                	je     0x181b12360
   181b12388:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   181b1238d:	75 d1                	jne    0x181b12360
   181b1238f:	49 8b 06             	mov    rax,QWORD PTR [r14]
   181b12392:	4c 89 f1             	mov    rcx,r14
   181b12395:	ff 10                	call   QWORD PTR [rax]
   181b12397:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   181b1239c:	75 c2                	jne    0x181b12360
   181b1239e:	49 8b 06             	mov    rax,QWORD PTR [r14]
   181b123a1:	4c 89 f1             	mov    rcx,r14
   181b123a4:	ff 50 08             	call   QWORD PTR [rax+0x8]
   181b123a7:	eb b7                	jmp    0x181b12360
   181b123a9:	c6 85 27 02 00 00 01 	mov    BYTE PTR [rbp+0x227],0x1
   181b123b0:	e8 ab 65 4f fe       	call   0x180008960
   181b123b5:	90                   	nop
   181b123b6:	e8 bd e0 d4 04       	call   0x186860478
   181b123bb:	90                   	nop
   181b123bc:	e8 9f 65 4f fe       	call   0x180008960
   181b123c1:	90                   	nop
   181b123c2:	cc                   	int3
