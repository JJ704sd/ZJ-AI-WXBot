
.research\wechat-4.1.10.27-reference\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000182c72de0 <.text+0x2c71de0>:
   182c72de0:	41 57                	push   r15
   182c72de2:	41 56                	push   r14
   182c72de4:	56                   	push   rsi
   182c72de5:	57                   	push   rdi
   182c72de6:	53                   	push   rbx
   182c72de7:	48 83 ec 30          	sub    rsp,0x30
   182c72deb:	0f 29 74 24 20       	movaps XMMWORD PTR [rsp+0x20],xmm6
   182c72df0:	48 89 d6             	mov    rsi,rdx
   182c72df3:	48 89 cf             	mov    rdi,rcx
   182c72df6:	8b 52 08             	mov    edx,DWORD PTR [rdx+0x8]
   182c72df9:	03 51 08             	add    edx,DWORD PTR [rcx+0x8]
   182c72dfc:	e8 6f 94 07 fe       	call   0x180cec270
   182c72e01:	83 7e 08 00          	cmp    DWORD PTR [rsi+0x8],0x0
   182c72e05:	0f 8e 9e 00 00 00    	jle    0x182c72ea9
   182c72e0b:	31 db                	xor    ebx,ebx
   182c72e0d:	4c 8d 35 24 52 b3 05 	lea    r14,[rip+0x5b35224]        # 0x1887a8038
   182c72e14:	4c 8d 3d 1d bf bc 07 	lea    r15,[rip+0x7bcbf1d]        # 0x18a83ed38
   182c72e1b:	0f 57 f6             	xorps  xmm6,xmm6
   182c72e1e:	eb 27                	jmp    0x182c72e47
   182c72e20:	48 63 c8             	movsxd rcx,eax
   182c72e23:	48 8b 17             	mov    rdx,QWORD PTR [rdi]
   182c72e26:	ff c0                	inc    eax
   182c72e28:	89 47 08             	mov    DWORD PTR [rdi+0x8],eax
   182c72e2b:	48 8b 0c ca          	mov    rcx,QWORD PTR [rdx+rcx*8]
   182c72e2f:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   182c72e32:	48 8b 14 d8          	mov    rdx,QWORD PTR [rax+rbx*8]
   182c72e36:	e8 25 92 ff ff       	call   0x182c6c060
   182c72e3b:	48 ff c3             	inc    rbx
   182c72e3e:	48 63 46 08          	movsxd rax,DWORD PTR [rsi+0x8]
   182c72e42:	48 39 c3             	cmp    rbx,rax
   182c72e45:	7d 62                	jge    0x182c72ea9
   182c72e47:	8b 47 08             	mov    eax,DWORD PTR [rdi+0x8]
   182c72e4a:	8b 57 0c             	mov    edx,DWORD PTR [rdi+0xc]
   182c72e4d:	39 d0                	cmp    eax,edx
   182c72e4f:	7c cf                	jl     0x182c72e20
   182c72e51:	3b 57 10             	cmp    edx,DWORD PTR [rdi+0x10]
   182c72e54:	75 0d                	jne    0x182c72e63
   182c72e56:	ff c2                	inc    edx
   182c72e58:	48 89 f9             	mov    rcx,rdi
   182c72e5b:	e8 10 94 07 fe       	call   0x180cec270
   182c72e60:	8b 57 0c             	mov    edx,DWORD PTR [rdi+0xc]
   182c72e63:	ff c2                	inc    edx
   182c72e65:	89 57 0c             	mov    DWORD PTR [rdi+0xc],edx
   182c72e68:	b9 38 00 00 00       	mov    ecx,0x38
   182c72e6d:	e8 8a a2 b9 03       	call   0x18680d0fc
   182c72e72:	48 89 c1             	mov    rcx,rax
   182c72e75:	4c 89 30             	mov    QWORD PTR [rax],r14
   182c72e78:	48 c7 40 08 00 00 00 	mov    QWORD PTR [rax+0x8],0x0
   182c72e7f:	00 
   182c72e80:	4c 89 78 10          	mov    QWORD PTR [rax+0x10],r15
   182c72e84:	48 c7 40 18 00 00 00 	mov    QWORD PTR [rax+0x18],0x0
   182c72e8b:	00 
   182c72e8c:	4c 89 78 20          	mov    QWORD PTR [rax+0x20],r15
   182c72e90:	0f 11 70 28          	movups XMMWORD PTR [rax+0x28],xmm6
   182c72e94:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   182c72e97:	48 63 57 08          	movsxd rdx,DWORD PTR [rdi+0x8]
   182c72e9b:	44 8d 42 01          	lea    r8d,[rdx+0x1]
   182c72e9f:	44 89 47 08          	mov    DWORD PTR [rdi+0x8],r8d
   182c72ea3:	48 89 0c d0          	mov    QWORD PTR [rax+rdx*8],rcx
   182c72ea7:	eb 86                	jmp    0x182c72e2f
   182c72ea9:	0f 28 74 24 20       	movaps xmm6,XMMWORD PTR [rsp+0x20]
   182c72eae:	48 83 c4 30          	add    rsp,0x30
   182c72eb2:	5b                   	pop    rbx
   182c72eb3:	5f                   	pop    rdi
   182c72eb4:	5e                   	pop    rsi
   182c72eb5:	41 5e                	pop    r14
   182c72eb7:	41 5f                	pop    r15
   182c72eb9:	c3                   	ret
