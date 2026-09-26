
.research\wechat-4.1.10.27-reference\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000181677a30 <.text+0x1676a30>:
   181677a30:	55                   	push   rbp
   181677a31:	41 56                	push   r14
   181677a33:	56                   	push   rsi
   181677a34:	57                   	push   rdi
   181677a35:	53                   	push   rbx
   181677a36:	48 81 ec e0 01 00 00 	sub    rsp,0x1e0
   181677a3d:	48 8d ac 24 80 00 00 	lea    rbp,[rsp+0x80]
   181677a44:	00 
   181677a45:	48 c7 85 58 01 00 00 	mov    QWORD PTR [rbp+0x158],0xfffffffffffffffe
   181677a4c:	fe ff ff ff 
   181677a50:	48 89 d3             	mov    rbx,rdx
   181677a53:	48 89 cf             	mov    rdi,rcx
   181677a56:	e8 65 96 9c fe       	call   0x1800410c0
   181677a5b:	48 8d 95 28 01 00 00 	lea    rdx,[rbp+0x128]
   181677a62:	48 89 c1             	mov    rcx,rax
   181677a65:	e8 46 ac 9c fe       	call   0x1800426b0
   181677a6a:	48 8b b5 28 01 00 00 	mov    rsi,QWORD PTR [rbp+0x128]
   181677a71:	0f 57 c0             	xorps  xmm0,xmm0
   181677a74:	0f 29 45 b0          	movaps XMMWORD PTR [rbp-0x50],xmm0
   181677a78:	48 c7 45 c0 00 00 00 	mov    QWORD PTR [rbp-0x40],0x0
   181677a7f:	00 
   181677a80:	4c 8b 77 10          	mov    r14,QWORD PTR [rdi+0x10]
   181677a84:	48 8b 4f 08          	mov    rcx,QWORD PTR [rdi+0x8]
   181677a88:	4c 89 f0             	mov    rax,r14
   181677a8b:	48 29 c8             	sub    rax,rcx
   181677a8e:	49 29 ce             	sub    r14,rcx
   181677a91:	0f 84 9b 00 00 00    	je     0x181677b32
   181677a97:	48 c1 f8 04          	sar    rax,0x4
   181677a9b:	48 89 c1             	mov    rcx,rax
   181677a9e:	48 c1 e9 3c          	shr    rcx,0x3c
   181677aa2:	0f 85 7f 02 00 00    	jne    0x181677d27
   181677aa8:	48 3d 00 01 00 00    	cmp    rax,0x100
   181677aae:	72 24                	jb     0x181677ad4
   181677ab0:	49 8d 4e 27          	lea    rcx,[r14+0x27]
   181677ab4:	e8 43 56 19 05       	call   0x18680d0fc
   181677ab9:	90                   	nop
   181677aba:	48 85 c0             	test   rax,rax
   181677abd:	0f 84 70 02 00 00    	je     0x181677d33
   181677ac3:	48 89 c1             	mov    rcx,rax
   181677ac6:	48 83 c0 27          	add    rax,0x27
   181677aca:	48 83 e0 e0          	and    rax,0xffffffffffffffe0
   181677ace:	48 89 48 f8          	mov    QWORD PTR [rax-0x8],rcx
   181677ad2:	eb 09                	jmp    0x181677add
   181677ad4:	4c 89 f1             	mov    rcx,r14
   181677ad7:	e8 20 56 19 05       	call   0x18680d0fc
   181677adc:	90                   	nop
   181677add:	48 89 45 b0          	mov    QWORD PTR [rbp-0x50],rax
   181677ae1:	48 89 45 b8          	mov    QWORD PTR [rbp-0x48],rax
   181677ae5:	49 01 c6             	add    r14,rax
   181677ae8:	4c 89 75 c0          	mov    QWORD PTR [rbp-0x40],r14
   181677aec:	48 8b 4f 08          	mov    rcx,QWORD PTR [rdi+0x8]
   181677af0:	48 8b 57 10          	mov    rdx,QWORD PTR [rdi+0x10]
   181677af4:	48 39 d1             	cmp    rcx,rdx
   181677af7:	74 35                	je     0x181677b2e
   181677af9:	0f 57 c0             	xorps  xmm0,xmm0
   181677afc:	eb 1d                	jmp    0x181677b1b
   181677afe:	66 90                	xchg   ax,ax
   181677b00:	4c 8b 01             	mov    r8,QWORD PTR [rcx]
   181677b03:	4c 89 00             	mov    QWORD PTR [rax],r8
   181677b06:	4c 8b 41 08          	mov    r8,QWORD PTR [rcx+0x8]
   181677b0a:	4c 89 40 08          	mov    QWORD PTR [rax+0x8],r8
   181677b0e:	48 83 c0 10          	add    rax,0x10
   181677b12:	48 83 c1 10          	add    rcx,0x10
   181677b16:	48 39 d1             	cmp    rcx,rdx
   181677b19:	74 13                	je     0x181677b2e
   181677b1b:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   181677b1e:	4c 8b 41 08          	mov    r8,QWORD PTR [rcx+0x8]
   181677b22:	4d 85 c0             	test   r8,r8
   181677b25:	74 d9                	je     0x181677b00
   181677b27:	f0 41 ff 40 08       	lock inc DWORD PTR [r8+0x8]
   181677b2c:	eb d2                	jmp    0x181677b00
   181677b2e:	48 89 45 b8          	mov    QWORD PTR [rbp-0x48],rax
   181677b32:	48 8d 7d c8          	lea    rdi,[rbp-0x38]
   181677b36:	48 89 f9             	mov    rcx,rdi
   181677b39:	48 89 da             	mov    rdx,rbx
   181677b3c:	e8 5f 2d 9e fe       	call   0x18005a8a0
   181677b41:	90                   	nop
   181677b42:	48 c7 85 20 01 00 00 	mov    QWORD PTR [rbp+0x120],0x0
   181677b49:	00 00 00 00 
   181677b4d:	48 c7 85 40 01 00 00 	mov    QWORD PTR [rbp+0x140],0x0
   181677b54:	00 00 00 00 
   181677b58:	b9 08 01 00 00       	mov    ecx,0x108
   181677b5d:	e8 9a 55 19 05       	call   0x18680d0fc
   181677b62:	90                   	nop
   181677b63:	49 89 c1             	mov    r9,rax
   181677b66:	48 8d 05 3b 4f e7 06 	lea    rax,[rip+0x6e74f3b]        # 0x1884ecaa8
   181677b6d:	49 89 01             	mov    QWORD PTR [r9],rax
   181677b70:	0f 57 c0             	xorps  xmm0,xmm0
   181677b73:	41 0f 11 41 08       	movups XMMWORD PTR [r9+0x8],xmm0
   181677b78:	49 c7 41 18 00 00 00 	mov    QWORD PTR [r9+0x18],0x0
   181677b7f:	00 
   181677b80:	48 8b 5d b8          	mov    rbx,QWORD PTR [rbp-0x48]
   181677b84:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   181677b88:	48 89 d8             	mov    rax,rbx
   181677b8b:	48 29 c8             	sub    rax,rcx
   181677b8e:	48 29 cb             	sub    rbx,rcx
   181677b91:	4c 89 8d 48 01 00 00 	mov    QWORD PTR [rbp+0x148],r9
   181677b98:	0f 84 a4 00 00 00    	je     0x181677c42
   181677b9e:	48 c1 f8 04          	sar    rax,0x4
   181677ba2:	48 89 c1             	mov    rcx,rax
   181677ba5:	48 c1 e9 3c          	shr    rcx,0x3c
   181677ba9:	0f 85 7e 01 00 00    	jne    0x181677d2d
   181677baf:	48 3d 00 01 00 00    	cmp    rax,0x100
   181677bb5:	72 24                	jb     0x181677bdb
   181677bb7:	48 8d 4b 27          	lea    rcx,[rbx+0x27]
   181677bbb:	e8 3c 55 19 05       	call   0x18680d0fc
   181677bc0:	90                   	nop
   181677bc1:	48 85 c0             	test   rax,rax
   181677bc4:	0f 84 69 01 00 00    	je     0x181677d33
   181677bca:	48 89 c1             	mov    rcx,rax
   181677bcd:	48 83 c0 27          	add    rax,0x27
   181677bd1:	48 83 e0 e0          	and    rax,0xffffffffffffffe0
   181677bd5:	48 89 48 f8          	mov    QWORD PTR [rax-0x8],rcx
   181677bd9:	eb 09                	jmp    0x181677be4
   181677bdb:	48 89 d9             	mov    rcx,rbx
   181677bde:	e8 19 55 19 05       	call   0x18680d0fc
   181677be3:	90                   	nop
   181677be4:	4c 8b 8d 48 01 00 00 	mov    r9,QWORD PTR [rbp+0x148]
   181677beb:	49 89 41 08          	mov    QWORD PTR [r9+0x8],rax
   181677bef:	49 89 41 10          	mov    QWORD PTR [r9+0x10],rax
   181677bf3:	48 01 c3             	add    rbx,rax
   181677bf6:	49 89 59 18          	mov    QWORD PTR [r9+0x18],rbx
   181677bfa:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   181677bfe:	48 8b 55 b8          	mov    rdx,QWORD PTR [rbp-0x48]
   181677c02:	48 39 d1             	cmp    rcx,rdx
   181677c05:	74 37                	je     0x181677c3e
   181677c07:	0f 57 c0             	xorps  xmm0,xmm0
   181677c0a:	eb 1f                	jmp    0x181677c2b
   181677c0c:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
   181677c10:	4c 8b 01             	mov    r8,QWORD PTR [rcx]
   181677c13:	4c 89 00             	mov    QWORD PTR [rax],r8
   181677c16:	4c 8b 41 08          	mov    r8,QWORD PTR [rcx+0x8]
   181677c1a:	4c 89 40 08          	mov    QWORD PTR [rax+0x8],r8
   181677c1e:	48 83 c0 10          	add    rax,0x10
   181677c22:	48 83 c1 10          	add    rcx,0x10
   181677c26:	48 39 d1             	cmp    rcx,rdx
   181677c29:	74 13                	je     0x181677c3e
   181677c2b:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   181677c2e:	4c 8b 41 08          	mov    r8,QWORD PTR [rcx+0x8]
   181677c32:	4d 85 c0             	test   r8,r8
   181677c35:	74 d9                	je     0x181677c10
   181677c37:	f0 41 ff 40 08       	lock inc DWORD PTR [r8+0x8]
   181677c3c:	eb d2                	jmp    0x181677c10
   181677c3e:	49 89 41 10          	mov    QWORD PTR [r9+0x10],rax
   181677c42:	49 8d 41 08          	lea    rax,[r9+0x8]
   181677c46:	48 89 85 38 01 00 00 	mov    QWORD PTR [rbp+0x138],rax
   181677c4d:	49 8d 49 20          	lea    rcx,[r9+0x20]
   181677c51:	48 89 fa             	mov    rdx,rdi
   181677c54:	e8 47 2c 9e fe       	call   0x18005a8a0
   181677c59:	90                   	nop
   181677c5a:	48 8b 85 48 01 00 00 	mov    rax,QWORD PTR [rbp+0x148]
   181677c61:	48 89 85 20 01 00 00 	mov    QWORD PTR [rbp+0x120],rax
   181677c68:	c6 85 57 01 00 00 01 	mov    BYTE PTR [rbp+0x157],0x1
   181677c6f:	48 8d 15 66 e5 b3 06 	lea    rdx,[rip+0x6b3e566]        # 0x1881b61dc
   181677c76:	4c 8d 05 5d a0 e7 06 	lea    r8,[rip+0x6e7a05d]        # 0x1884f1cda
   181677c7d:	48 8d 8d b8 00 00 00 	lea    rcx,[rbp+0xb8]
   181677c84:	41 b9 07 02 00 00    	mov    r9d,0x207
   181677c8a:	e8 b1 51 b1 fe       	call   0x18018ce40
   181677c8f:	90                   	nop
   181677c90:	c6 85 57 01 00 00 00 	mov    BYTE PTR [rbp+0x157],0x0
   181677c97:	c7 44 24 20 01 00 00 	mov    DWORD PTR [rsp+0x20],0x1
   181677c9e:	00 
   181677c9f:	48 8d 95 d8 00 00 00 	lea    rdx,[rbp+0xd8]
   181677ca6:	4c 8d 85 b8 00 00 00 	lea    r8,[rbp+0xb8]
   181677cad:	4c 8d 8d e8 00 00 00 	lea    r9,[rbp+0xe8]
   181677cb4:	48 89 f1             	mov    rcx,rsi
   181677cb7:	e8 f4 3f c4 fe       	call   0x1802bbcb0
   181677cbc:	90                   	nop
   181677cbd:	48 8b b5 e0 00 00 00 	mov    rsi,QWORD PTR [rbp+0xe0]
   181677cc4:	48 85 f6             	test   rsi,rsi
   181677cc7:	74 1d                	je     0x181677ce6
   181677cc9:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   181677ccd:	75 17                	jne    0x181677ce6
   181677ccf:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   181677cd2:	48 89 f1             	mov    rcx,rsi
   181677cd5:	ff 10                	call   QWORD PTR [rax]
   181677cd7:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   181677cdb:	75 09                	jne    0x181677ce6
   181677cdd:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   181677ce0:	48 89 f1             	mov    rcx,rsi
   181677ce3:	ff 50 08             	call   QWORD PTR [rax+0x8]
   181677ce6:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   181677cea:	e8 11 03 00 00       	call   0x181678000
   181677cef:	48 8b b5 30 01 00 00 	mov    rsi,QWORD PTR [rbp+0x130]
   181677cf6:	48 85 f6             	test   rsi,rsi
   181677cf9:	74 1e                	je     0x181677d19
   181677cfb:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   181677cff:	75 18                	jne    0x181677d19
   181677d01:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   181677d04:	48 89 f1             	mov    rcx,rsi
   181677d07:	ff 10                	call   QWORD PTR [rax]
   181677d09:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   181677d0d:	75 0a                	jne    0x181677d19
   181677d0f:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   181677d12:	48 89 f1             	mov    rcx,rsi
   181677d15:	ff 50 08             	call   QWORD PTR [rax+0x8]
   181677d18:	90                   	nop
   181677d19:	48 81 c4 e0 01 00 00 	add    rsp,0x1e0
   181677d20:	5b                   	pop    rbx
   181677d21:	5f                   	pop    rdi
   181677d22:	5e                   	pop    rsi
   181677d23:	41 5e                	pop    r14
   181677d25:	5d                   	pop    rbp
   181677d26:	c3                   	ret
   181677d27:	e8 44 33 99 fe       	call   0x18000b070
   181677d2c:	90                   	nop
   181677d2d:	e8 3e 33 99 fe       	call   0x18000b070
   181677d32:	90                   	nop
   181677d33:	e8 40 87 1e 05       	call   0x186860478
   181677d38:	cc                   	int3
