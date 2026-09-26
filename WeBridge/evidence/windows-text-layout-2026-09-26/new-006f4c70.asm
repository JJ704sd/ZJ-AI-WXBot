
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

00000001806f4c70 <.text+0x6f3c70>:
   1806f4c70:	55                   	push   rbp
   1806f4c71:	56                   	push   rsi
   1806f4c72:	57                   	push   rdi
   1806f4c73:	53                   	push   rbx
   1806f4c74:	48 83 ec 38          	sub    rsp,0x38
   1806f4c78:	48 8d 6c 24 30       	lea    rbp,[rsp+0x30]
   1806f4c7d:	48 c7 45 00 fe ff ff 	mov    QWORD PTR [rbp+0x0],0xfffffffffffffffe
   1806f4c84:	ff 
   1806f4c85:	48 89 ce             	mov    rsi,rcx
   1806f4c88:	b9 a8 07 00 00       	mov    ecx,0x7a8
   1806f4c8d:	e8 0a 6c db 06       	call   0x1874ab89c
   1806f4c92:	48 b9 01 00 00 00 01 	movabs rcx,0x100000001
   1806f4c99:	00 00 00 
   1806f4c9c:	48 89 48 08          	mov    QWORD PTR [rax+0x8],rcx
   1806f4ca0:	48 8d 0d 51 e8 75 08 	lea    rcx,[rip+0x875e851]        # 0x188e534f8
   1806f4ca7:	48 89 08             	mov    QWORD PTR [rax],rcx
   1806f4caa:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
   1806f4cae:	48 8d 78 10          	lea    rdi,[rax+0x10]
   1806f4cb2:	41 b8 98 07 00 00    	mov    r8d,0x798
   1806f4cb8:	48 89 f9             	mov    rcx,rdi
   1806f4cbb:	31 d2                	xor    edx,edx
   1806f4cbd:	e8 2e fa e4 06       	call   0x1875446f0
   1806f4cc2:	90                   	nop
   1806f4cc3:	48 89 f9             	mov    rcx,rdi
   1806f4cc6:	e8 b5 19 07 00       	call   0x180766680
   1806f4ccb:	90                   	nop
   1806f4ccc:	48 89 3e             	mov    QWORD PTR [rsi],rdi
   1806f4ccf:	48 8b 5d f8          	mov    rbx,QWORD PTR [rbp-0x8]
   1806f4cd3:	48 89 5e 08          	mov    QWORD PTR [rsi+0x8],rbx
   1806f4cd7:	48 8b 4b 20          	mov    rcx,QWORD PTR [rbx+0x20]
   1806f4cdb:	48 85 c9             	test   rcx,rcx
   1806f4cde:	74 06                	je     0x1806f4ce6
   1806f4ce0:	83 79 08 00          	cmp    DWORD PTR [rcx+0x8],0x0
   1806f4ce4:	75 66                	jne    0x1806f4d4c
   1806f4ce6:	48 85 db             	test   rbx,rbx
   1806f4ce9:	74 1b                	je     0x1806f4d06
   1806f4ceb:	f0 ff 43 08          	lock inc DWORD PTR [rbx+0x8]
   1806f4cef:	f0 ff 43 0c          	lock inc DWORD PTR [rbx+0xc]
   1806f4cf3:	48 8b 4b 20          	mov    rcx,QWORD PTR [rbx+0x20]
   1806f4cf7:	48 89 7b 18          	mov    QWORD PTR [rbx+0x18],rdi
   1806f4cfb:	48 89 5b 20          	mov    QWORD PTR [rbx+0x20],rbx
   1806f4cff:	48 85 c9             	test   rcx,rcx
   1806f4d02:	75 11                	jne    0x1806f4d15
   1806f4d04:	eb 1b                	jmp    0x1806f4d21
   1806f4d06:	31 ff                	xor    edi,edi
   1806f4d08:	48 89 7b 18          	mov    QWORD PTR [rbx+0x18],rdi
   1806f4d0c:	48 89 5b 20          	mov    QWORD PTR [rbx+0x20],rbx
   1806f4d10:	48 85 c9             	test   rcx,rcx
   1806f4d13:	74 0c                	je     0x1806f4d21
   1806f4d15:	f0 ff 49 0c          	lock dec DWORD PTR [rcx+0xc]
   1806f4d19:	75 06                	jne    0x1806f4d21
   1806f4d1b:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   1806f4d1e:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1806f4d21:	48 85 db             	test   rbx,rbx
   1806f4d24:	74 26                	je     0x1806f4d4c
   1806f4d26:	48 8d 43 08          	lea    rax,[rbx+0x8]
   1806f4d2a:	f0 ff 08             	lock dec DWORD PTR [rax]
   1806f4d2d:	75 1d                	jne    0x1806f4d4c
   1806f4d2f:	48 89 df             	mov    rdi,rbx
   1806f4d32:	48 83 c7 0c          	add    rdi,0xc
   1806f4d36:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1806f4d39:	48 89 d9             	mov    rcx,rbx
   1806f4d3c:	ff 10                	call   QWORD PTR [rax]
   1806f4d3e:	f0 ff 0f             	lock dec DWORD PTR [rdi]
   1806f4d41:	75 09                	jne    0x1806f4d4c
   1806f4d43:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1806f4d46:	48 89 d9             	mov    rcx,rbx
   1806f4d49:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1806f4d4c:	48 89 f0             	mov    rax,rsi
   1806f4d4f:	48 83 c4 38          	add    rsp,0x38
   1806f4d53:	5b                   	pop    rbx
   1806f4d54:	5f                   	pop    rdi
   1806f4d55:	5e                   	pop    rsi
   1806f4d56:	5d                   	pop    rbp
   1806f4d57:	c3                   	ret
