
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

00000001819d0bc0 <.text+0x19cfbc0>:
   1819d0bc0:	55                   	push   rbp
   1819d0bc1:	41 56                	push   r14
   1819d0bc3:	56                   	push   rsi
   1819d0bc4:	57                   	push   rdi
   1819d0bc5:	53                   	push   rbx
   1819d0bc6:	48 81 ec e0 01 00 00 	sub    rsp,0x1e0
   1819d0bcd:	48 8d ac 24 80 00 00 	lea    rbp,[rsp+0x80]
   1819d0bd4:	00 
   1819d0bd5:	48 c7 85 58 01 00 00 	mov    QWORD PTR [rbp+0x158],0xfffffffffffffffe
   1819d0bdc:	fe ff ff ff 
   1819d0be0:	48 89 d3             	mov    rbx,rdx
   1819d0be3:	48 89 cf             	mov    rdi,rcx
   1819d0be6:	e8 25 51 67 fe       	call   0x180045d10
   1819d0beb:	48 8d 95 28 01 00 00 	lea    rdx,[rbp+0x128]
   1819d0bf2:	48 89 c1             	mov    rcx,rax
   1819d0bf5:	e8 16 67 67 fe       	call   0x180047310
   1819d0bfa:	48 8b b5 28 01 00 00 	mov    rsi,QWORD PTR [rbp+0x128]
   1819d0c01:	0f 57 c0             	xorps  xmm0,xmm0
   1819d0c04:	0f 29 45 b0          	movaps XMMWORD PTR [rbp-0x50],xmm0
   1819d0c08:	48 c7 45 c0 00 00 00 	mov    QWORD PTR [rbp-0x40],0x0
   1819d0c0f:	00 
   1819d0c10:	4c 8b 77 10          	mov    r14,QWORD PTR [rdi+0x10]
   1819d0c14:	48 8b 4f 08          	mov    rcx,QWORD PTR [rdi+0x8]
   1819d0c18:	4c 89 f0             	mov    rax,r14
   1819d0c1b:	48 29 c8             	sub    rax,rcx
   1819d0c1e:	49 29 ce             	sub    r14,rcx
   1819d0c21:	0f 84 9b 00 00 00    	je     0x1819d0cc2
   1819d0c27:	48 c1 f8 04          	sar    rax,0x4
   1819d0c2b:	48 89 c1             	mov    rcx,rax
   1819d0c2e:	48 c1 e9 3c          	shr    rcx,0x3c
   1819d0c32:	0f 85 7f 02 00 00    	jne    0x1819d0eb7
   1819d0c38:	48 3d 00 01 00 00    	cmp    rax,0x100
   1819d0c3e:	72 24                	jb     0x1819d0c64
   1819d0c40:	49 8d 4e 27          	lea    rcx,[r14+0x27]
   1819d0c44:	e8 53 ac ad 05       	call   0x1874ab89c
   1819d0c49:	90                   	nop
   1819d0c4a:	48 85 c0             	test   rax,rax
   1819d0c4d:	0f 84 70 02 00 00    	je     0x1819d0ec3
   1819d0c53:	48 89 c1             	mov    rcx,rax
   1819d0c56:	48 83 c0 27          	add    rax,0x27
   1819d0c5a:	48 83 e0 e0          	and    rax,0xffffffffffffffe0
   1819d0c5e:	48 89 48 f8          	mov    QWORD PTR [rax-0x8],rcx
   1819d0c62:	eb 09                	jmp    0x1819d0c6d
   1819d0c64:	4c 89 f1             	mov    rcx,r14
   1819d0c67:	e8 30 ac ad 05       	call   0x1874ab89c
   1819d0c6c:	90                   	nop
   1819d0c6d:	48 89 45 b0          	mov    QWORD PTR [rbp-0x50],rax
   1819d0c71:	48 89 45 b8          	mov    QWORD PTR [rbp-0x48],rax
   1819d0c75:	49 01 c6             	add    r14,rax
   1819d0c78:	4c 89 75 c0          	mov    QWORD PTR [rbp-0x40],r14
   1819d0c7c:	48 8b 4f 08          	mov    rcx,QWORD PTR [rdi+0x8]
   1819d0c80:	48 8b 57 10          	mov    rdx,QWORD PTR [rdi+0x10]
   1819d0c84:	48 39 d1             	cmp    rcx,rdx
   1819d0c87:	74 35                	je     0x1819d0cbe
   1819d0c89:	0f 57 c0             	xorps  xmm0,xmm0
   1819d0c8c:	eb 1d                	jmp    0x1819d0cab
   1819d0c8e:	66 90                	xchg   ax,ax
   1819d0c90:	4c 8b 01             	mov    r8,QWORD PTR [rcx]
   1819d0c93:	4c 89 00             	mov    QWORD PTR [rax],r8
   1819d0c96:	4c 8b 41 08          	mov    r8,QWORD PTR [rcx+0x8]
   1819d0c9a:	4c 89 40 08          	mov    QWORD PTR [rax+0x8],r8
   1819d0c9e:	48 83 c0 10          	add    rax,0x10
   1819d0ca2:	48 83 c1 10          	add    rcx,0x10
   1819d0ca6:	48 39 d1             	cmp    rcx,rdx
   1819d0ca9:	74 13                	je     0x1819d0cbe
   1819d0cab:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   1819d0cae:	4c 8b 41 08          	mov    r8,QWORD PTR [rcx+0x8]
   1819d0cb2:	4d 85 c0             	test   r8,r8
   1819d0cb5:	74 d9                	je     0x1819d0c90
   1819d0cb7:	f0 41 ff 40 08       	lock inc DWORD PTR [r8+0x8]
   1819d0cbc:	eb d2                	jmp    0x1819d0c90
   1819d0cbe:	48 89 45 b8          	mov    QWORD PTR [rbp-0x48],rax
   1819d0cc2:	48 8d 7d c8          	lea    rdi,[rbp-0x38]
   1819d0cc6:	48 89 f9             	mov    rcx,rdi
   1819d0cc9:	48 89 da             	mov    rdx,rbx
   1819d0ccc:	e8 df e5 68 fe       	call   0x18005f2b0
   1819d0cd1:	90                   	nop
   1819d0cd2:	48 c7 85 10 01 00 00 	mov    QWORD PTR [rbp+0x110],0x0
   1819d0cd9:	00 00 00 00 
   1819d0cdd:	48 c7 85 40 01 00 00 	mov    QWORD PTR [rbp+0x140],0x0
   1819d0ce4:	00 00 00 00 
   1819d0ce8:	b9 08 01 00 00       	mov    ecx,0x108
   1819d0ced:	e8 aa ab ad 05       	call   0x1874ab89c
   1819d0cf2:	90                   	nop
   1819d0cf3:	49 89 c1             	mov    r9,rax
   1819d0cf6:	48 8d 05 eb 16 74 07 	lea    rax,[rip+0x77416eb]        # 0x1891123e8
   1819d0cfd:	49 89 01             	mov    QWORD PTR [r9],rax
   1819d0d00:	0f 57 c0             	xorps  xmm0,xmm0
   1819d0d03:	41 0f 11 41 08       	movups XMMWORD PTR [r9+0x8],xmm0
   1819d0d08:	49 c7 41 18 00 00 00 	mov    QWORD PTR [r9+0x18],0x0
   1819d0d0f:	00 
   1819d0d10:	48 8b 5d b8          	mov    rbx,QWORD PTR [rbp-0x48]
   1819d0d14:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   1819d0d18:	48 89 d8             	mov    rax,rbx
   1819d0d1b:	48 29 c8             	sub    rax,rcx
   1819d0d1e:	48 29 cb             	sub    rbx,rcx
   1819d0d21:	4c 89 8d 48 01 00 00 	mov    QWORD PTR [rbp+0x148],r9
   1819d0d28:	0f 84 a4 00 00 00    	je     0x1819d0dd2
   1819d0d2e:	48 c1 f8 04          	sar    rax,0x4
   1819d0d32:	48 89 c1             	mov    rcx,rax
   1819d0d35:	48 c1 e9 3c          	shr    rcx,0x3c
   1819d0d39:	0f 85 7e 01 00 00    	jne    0x1819d0ebd
   1819d0d3f:	48 3d 00 01 00 00    	cmp    rax,0x100
   1819d0d45:	72 24                	jb     0x1819d0d6b
   1819d0d47:	48 8d 4b 27          	lea    rcx,[rbx+0x27]
   1819d0d4b:	e8 4c ab ad 05       	call   0x1874ab89c
   1819d0d50:	90                   	nop
   1819d0d51:	48 85 c0             	test   rax,rax
   1819d0d54:	0f 84 69 01 00 00    	je     0x1819d0ec3
   1819d0d5a:	48 89 c1             	mov    rcx,rax
   1819d0d5d:	48 83 c0 27          	add    rax,0x27
   1819d0d61:	48 83 e0 e0          	and    rax,0xffffffffffffffe0
   1819d0d65:	48 89 48 f8          	mov    QWORD PTR [rax-0x8],rcx
   1819d0d69:	eb 09                	jmp    0x1819d0d74
   1819d0d6b:	48 89 d9             	mov    rcx,rbx
   1819d0d6e:	e8 29 ab ad 05       	call   0x1874ab89c
   1819d0d73:	90                   	nop
   1819d0d74:	4c 8b 8d 48 01 00 00 	mov    r9,QWORD PTR [rbp+0x148]
   1819d0d7b:	49 89 41 08          	mov    QWORD PTR [r9+0x8],rax
   1819d0d7f:	49 89 41 10          	mov    QWORD PTR [r9+0x10],rax
   1819d0d83:	48 01 c3             	add    rbx,rax
   1819d0d86:	49 89 59 18          	mov    QWORD PTR [r9+0x18],rbx
   1819d0d8a:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   1819d0d8e:	48 8b 55 b8          	mov    rdx,QWORD PTR [rbp-0x48]
   1819d0d92:	48 39 d1             	cmp    rcx,rdx
   1819d0d95:	74 37                	je     0x1819d0dce
   1819d0d97:	0f 57 c0             	xorps  xmm0,xmm0
   1819d0d9a:	eb 1f                	jmp    0x1819d0dbb
   1819d0d9c:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
   1819d0da0:	4c 8b 01             	mov    r8,QWORD PTR [rcx]
   1819d0da3:	4c 89 00             	mov    QWORD PTR [rax],r8
   1819d0da6:	4c 8b 41 08          	mov    r8,QWORD PTR [rcx+0x8]
   1819d0daa:	4c 89 40 08          	mov    QWORD PTR [rax+0x8],r8
   1819d0dae:	48 83 c0 10          	add    rax,0x10
   1819d0db2:	48 83 c1 10          	add    rcx,0x10
   1819d0db6:	48 39 d1             	cmp    rcx,rdx
   1819d0db9:	74 13                	je     0x1819d0dce
   1819d0dbb:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   1819d0dbe:	4c 8b 41 08          	mov    r8,QWORD PTR [rcx+0x8]
   1819d0dc2:	4d 85 c0             	test   r8,r8
   1819d0dc5:	74 d9                	je     0x1819d0da0
   1819d0dc7:	f0 41 ff 40 08       	lock inc DWORD PTR [r8+0x8]
   1819d0dcc:	eb d2                	jmp    0x1819d0da0
   1819d0dce:	49 89 41 10          	mov    QWORD PTR [r9+0x10],rax
   1819d0dd2:	49 8d 41 08          	lea    rax,[r9+0x8]
   1819d0dd6:	48 89 85 38 01 00 00 	mov    QWORD PTR [rbp+0x138],rax
   1819d0ddd:	49 8d 49 20          	lea    rcx,[r9+0x20]
   1819d0de1:	48 89 fa             	mov    rdx,rdi
   1819d0de4:	e8 c7 e4 68 fe       	call   0x18005f2b0
   1819d0de9:	90                   	nop
   1819d0dea:	48 8b 85 48 01 00 00 	mov    rax,QWORD PTR [rbp+0x148]
   1819d0df1:	48 89 85 10 01 00 00 	mov    QWORD PTR [rbp+0x110],rax
   1819d0df8:	c6 85 57 01 00 00 01 	mov    BYTE PTR [rbp+0x157],0x1
   1819d0dff:	48 8d 15 4a 41 3b 07 	lea    rdx,[rip+0x73b414a]        # 0x188d84f50
   1819d0e06:	4c 8d 05 3b 6e 74 07 	lea    r8,[rip+0x7746e3b]        # 0x189117c48
   1819d0e0d:	48 8d 8d b8 00 00 00 	lea    rcx,[rbp+0xb8]
   1819d0e14:	41 b9 27 02 00 00    	mov    r9d,0x227
   1819d0e1a:	e8 e1 96 7c fe       	call   0x18019a500
   1819d0e1f:	90                   	nop
   1819d0e20:	c6 85 57 01 00 00 00 	mov    BYTE PTR [rbp+0x157],0x0
   1819d0e27:	c7 44 24 20 01 00 00 	mov    DWORD PTR [rsp+0x20],0x1
   1819d0e2e:	00 
   1819d0e2f:	48 8d 95 18 01 00 00 	lea    rdx,[rbp+0x118]
   1819d0e36:	4c 8d 85 b8 00 00 00 	lea    r8,[rbp+0xb8]
   1819d0e3d:	4c 8d 8d d8 00 00 00 	lea    r9,[rbp+0xd8]
   1819d0e44:	48 89 f1             	mov    rcx,rsi
   1819d0e47:	e8 c4 a1 92 fe       	call   0x1802fb010
   1819d0e4c:	90                   	nop
   1819d0e4d:	48 8b b5 20 01 00 00 	mov    rsi,QWORD PTR [rbp+0x120]
   1819d0e54:	48 85 f6             	test   rsi,rsi
   1819d0e57:	74 1d                	je     0x1819d0e76
   1819d0e59:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   1819d0e5d:	75 17                	jne    0x1819d0e76
   1819d0e5f:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1819d0e62:	48 89 f1             	mov    rcx,rsi
   1819d0e65:	ff 10                	call   QWORD PTR [rax]
   1819d0e67:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   1819d0e6b:	75 09                	jne    0x1819d0e76
   1819d0e6d:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1819d0e70:	48 89 f1             	mov    rcx,rsi
   1819d0e73:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1819d0e76:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   1819d0e7a:	e8 11 02 00 00       	call   0x1819d1090
   1819d0e7f:	48 8b b5 30 01 00 00 	mov    rsi,QWORD PTR [rbp+0x130]
   1819d0e86:	48 85 f6             	test   rsi,rsi
   1819d0e89:	74 1e                	je     0x1819d0ea9
   1819d0e8b:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   1819d0e8f:	75 18                	jne    0x1819d0ea9
   1819d0e91:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1819d0e94:	48 89 f1             	mov    rcx,rsi
   1819d0e97:	ff 10                	call   QWORD PTR [rax]
   1819d0e99:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   1819d0e9d:	75 0a                	jne    0x1819d0ea9
   1819d0e9f:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1819d0ea2:	48 89 f1             	mov    rcx,rsi
   1819d0ea5:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1819d0ea8:	90                   	nop
   1819d0ea9:	48 81 c4 e0 01 00 00 	add    rsp,0x1e0
   1819d0eb0:	5b                   	pop    rbx
   1819d0eb1:	5f                   	pop    rdi
   1819d0eb2:	5e                   	pop    rsi
   1819d0eb3:	41 5e                	pop    r14
   1819d0eb5:	5d                   	pop    rbp
   1819d0eb6:	c3                   	ret
   1819d0eb7:	e8 74 a8 63 fe       	call   0x18000b730
   1819d0ebc:	90                   	nop
   1819d0ebd:	e8 6e a8 63 fe       	call   0x18000b730
   1819d0ec2:	90                   	nop
   1819d0ec3:	e8 c4 c4 b3 05       	call   0x18750d38c
   1819d0ec8:	cc                   	int3
