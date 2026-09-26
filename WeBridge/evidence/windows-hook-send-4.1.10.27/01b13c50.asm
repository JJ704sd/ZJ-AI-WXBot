
.research\wechat-4.1.10.27-reference\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000181b13c50 <.text+0x1b12c50>:
   181b13c50:	41 57                	push   r15
   181b13c52:	41 56                	push   r14
   181b13c54:	56                   	push   rsi
   181b13c55:	57                   	push   rdi
   181b13c56:	53                   	push   rbx
   181b13c57:	48 83 ec 20          	sub    rsp,0x20
   181b13c5b:	48 89 d6             	mov    rsi,rdx
   181b13c5e:	48 89 cf             	mov    rdi,rcx
   181b13c61:	48 8d 05 f0 22 a8 06 	lea    rax,[rip+0x6a822f0]        # 0x188595f58
   181b13c68:	48 89 02             	mov    QWORD PTR [rdx],rax
   181b13c6b:	0f 57 c0             	xorps  xmm0,xmm0
   181b13c6e:	0f 11 42 08          	movups XMMWORD PTR [rdx+0x8],xmm0
   181b13c72:	0f 11 42 18          	movups XMMWORD PTR [rdx+0x18],xmm0
   181b13c76:	48 8b 59 18          	mov    rbx,QWORD PTR [rcx+0x18]
   181b13c7a:	48 83 79 20 10       	cmp    QWORD PTR [rcx+0x20],0x10
   181b13c7f:	72 06                	jb     0x181b13c87
   181b13c81:	4c 8b 77 08          	mov    r14,QWORD PTR [rdi+0x8]
   181b13c85:	eb 04                	jmp    0x181b13c8b
   181b13c87:	4c 8d 77 08          	lea    r14,[rdi+0x8]
   181b13c8b:	48 85 db             	test   rbx,rbx
   181b13c8e:	0f 88 b4 00 00 00    	js     0x181b13d48
   181b13c94:	48 83 fb 0f          	cmp    rbx,0xf
   181b13c98:	77 19                	ja     0x181b13cb3
   181b13c9a:	48 8d 46 08          	lea    rax,[rsi+0x8]
   181b13c9e:	48 89 5e 18          	mov    QWORD PTR [rsi+0x18],rbx
   181b13ca2:	48 c7 46 20 0f 00 00 	mov    QWORD PTR [rsi+0x20],0xf
   181b13ca9:	00 
   181b13caa:	41 0f 10 06          	movups xmm0,XMMWORD PTR [r14]
   181b13cae:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   181b13cb1:	eb 62                	jmp    0x181b13d15
   181b13cb3:	48 89 d8             	mov    rax,rbx
   181b13cb6:	48 83 c8 0f          	or     rax,0xf
   181b13cba:	48 83 f8 17          	cmp    rax,0x17
   181b13cbe:	41 bf 16 00 00 00    	mov    r15d,0x16
   181b13cc4:	4c 0f 43 f8          	cmovae r15,rax
   181b13cc8:	48 3d ff 0f 00 00    	cmp    rax,0xfff
   181b13cce:	72 1f                	jb     0x181b13cef
   181b13cd0:	49 8d 4f 28          	lea    rcx,[r15+0x28]
   181b13cd4:	e8 23 94 cf 04       	call   0x18680d0fc
   181b13cd9:	48 85 c0             	test   rax,rax
   181b13cdc:	74 6f                	je     0x181b13d4d
   181b13cde:	48 89 c1             	mov    rcx,rax
   181b13ce1:	48 83 c0 27          	add    rax,0x27
   181b13ce5:	48 83 e0 e0          	and    rax,0xffffffffffffffe0
   181b13ce9:	48 89 48 f8          	mov    QWORD PTR [rax-0x8],rcx
   181b13ced:	eb 09                	jmp    0x181b13cf8
   181b13cef:	49 8d 4f 01          	lea    rcx,[r15+0x1]
   181b13cf3:	e8 04 94 cf 04       	call   0x18680d0fc
   181b13cf8:	48 89 46 08          	mov    QWORD PTR [rsi+0x8],rax
   181b13cfc:	48 89 5e 18          	mov    QWORD PTR [rsi+0x18],rbx
   181b13d00:	4c 89 7e 20          	mov    QWORD PTR [rsi+0x20],r15
   181b13d04:	48 ff c3             	inc    rbx
   181b13d07:	48 89 c1             	mov    rcx,rax
   181b13d0a:	4c 89 f2             	mov    rdx,r14
   181b13d0d:	49 89 d8             	mov    r8,rbx
   181b13d10:	e8 bb 23 d8 04       	call   0x1868960d0
   181b13d15:	0f 57 c0             	xorps  xmm0,xmm0
   181b13d18:	0f 11 46 28          	movups XMMWORD PTR [rsi+0x28],xmm0
   181b13d1c:	48 8b 47 30          	mov    rax,QWORD PTR [rdi+0x30]
   181b13d20:	48 85 c0             	test   rax,rax
   181b13d23:	74 04                	je     0x181b13d29
   181b13d25:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   181b13d29:	48 8b 47 28          	mov    rax,QWORD PTR [rdi+0x28]
   181b13d2d:	48 89 46 28          	mov    QWORD PTR [rsi+0x28],rax
   181b13d31:	48 8b 47 30          	mov    rax,QWORD PTR [rdi+0x30]
   181b13d35:	48 89 46 30          	mov    QWORD PTR [rsi+0x30],rax
   181b13d39:	48 89 f0             	mov    rax,rsi
   181b13d3c:	48 83 c4 20          	add    rsp,0x20
   181b13d40:	5b                   	pop    rbx
   181b13d41:	5f                   	pop    rdi
   181b13d42:	5e                   	pop    rsi
   181b13d43:	41 5e                	pop    r14
   181b13d45:	41 5f                	pop    r15
   181b13d47:	c3                   	ret
   181b13d48:	e8 13 4c 4f fe       	call   0x180008960
   181b13d4d:	e8 26 c7 d4 04       	call   0x186860478
   181b13d52:	cc                   	int3
