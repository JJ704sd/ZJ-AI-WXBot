
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000185b6cda0 <.text+0x5b6bda0>:
   185b6cda0:	55                   	push   rbp
   185b6cda1:	41 57                	push   r15
   185b6cda3:	41 56                	push   r14
   185b6cda5:	56                   	push   rsi
   185b6cda6:	57                   	push   rdi
   185b6cda7:	53                   	push   rbx
   185b6cda8:	48 81 ec 88 00 00 00 	sub    rsp,0x88
   185b6cdaf:	48 8d ac 24 80 00 00 	lea    rbp,[rsp+0x80]
   185b6cdb6:	00 
   185b6cdb7:	48 c7 45 00 fe ff ff 	mov    QWORD PTR [rbp+0x0],0xfffffffffffffffe
   185b6cdbe:	ff 
   185b6cdbf:	4c 89 45 f8          	mov    QWORD PTR [rbp-0x8],r8
   185b6cdc3:	48 89 d6             	mov    rsi,rdx
   185b6cdc6:	48 89 cf             	mov    rdi,rcx
   185b6cdc9:	0f 28 05 e0 8d 1d 03 	movaps xmm0,XMMWORD PTR [rip+0x31d8de0]        # 0x188d45bb0
   185b6cdd0:	0f 29 45 e0          	movaps XMMWORD PTR [rbp-0x20],xmm0
   185b6cdd4:	48 8d 4d e0          	lea    rcx,[rbp-0x20]
   185b6cdd8:	e8 93 7e b8 fa       	call   0x1806f4c70
   185b6cddd:	90                   	nop
   185b6cdde:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
   185b6cde2:	c7 80 18 01 00 00 01 	mov    DWORD PTR [rax+0x118],0x1
   185b6cde9:	00 00 00 
   185b6cdec:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
   185b6cdf0:	48 8b 00             	mov    rax,QWORD PTR [rax]
   185b6cdf3:	8b 50 08             	mov    edx,DWORD PTR [rax+0x8]
   185b6cdf6:	48 8d 5d a0          	lea    rbx,[rbp-0x60]
   185b6cdfa:	48 89 d9             	mov    rcx,rbx
   185b6cdfd:	e8 6e 00 84 fc       	call   0x1823ace70
   185b6ce02:	90                   	nop
   185b6ce03:	4c 8b 7d f8          	mov    r15,QWORD PTR [rbp-0x8]
   185b6ce07:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
   185b6ce0b:	4c 8d b0 58 07 00 00 	lea    r14,[rax+0x758]
   185b6ce12:	49 39 de             	cmp    r14,rbx
   185b6ce15:	74 54                	je     0x185b6ce6b
   185b6ce17:	48 8b 80 70 07 00 00 	mov    rax,QWORD PTR [rax+0x770]
   185b6ce1e:	48 83 f8 10          	cmp    rax,0x10
   185b6ce22:	72 34                	jb     0x185b6ce58
   185b6ce24:	49 8b 0e             	mov    rcx,QWORD PTR [r14]
   185b6ce27:	48 8d 50 01          	lea    rdx,[rax+0x1]
   185b6ce2b:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185b6ce32:	72 1f                	jb     0x185b6ce53
   185b6ce34:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   185b6ce38:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   185b6ce3c:	4c 29 c1             	sub    rcx,r8
   185b6ce3f:	48 83 f9 20          	cmp    rcx,0x20
   185b6ce43:	0f 83 02 01 00 00    	jae    0x185b6cf4b
   185b6ce49:	48 83 c0 28          	add    rax,0x28
   185b6ce4d:	48 89 c2             	mov    rdx,rax
   185b6ce50:	4c 89 c1             	mov    rcx,r8
   185b6ce53:	e8 88 ea 93 01       	call   0x1874ab8e0
   185b6ce58:	0f 10 45 a0          	movups xmm0,XMMWORD PTR [rbp-0x60]
   185b6ce5c:	0f 10 4d b0          	movups xmm1,XMMWORD PTR [rbp-0x50]
   185b6ce60:	41 0f 11 4e 10       	movups XMMWORD PTR [r14+0x10],xmm1
   185b6ce65:	41 0f 11 06          	movups XMMWORD PTR [r14],xmm0
   185b6ce69:	eb 3f                	jmp    0x185b6ceaa
   185b6ce6b:	48 8b 45 b8          	mov    rax,QWORD PTR [rbp-0x48]
   185b6ce6f:	48 83 f8 10          	cmp    rax,0x10
   185b6ce73:	72 35                	jb     0x185b6ceaa
   185b6ce75:	48 8b 4d a0          	mov    rcx,QWORD PTR [rbp-0x60]
   185b6ce79:	48 8d 50 01          	lea    rdx,[rax+0x1]
   185b6ce7d:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185b6ce84:	72 1f                	jb     0x185b6cea5
   185b6ce86:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   185b6ce8a:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   185b6ce8e:	4c 29 c1             	sub    rcx,r8
   185b6ce91:	48 83 f9 20          	cmp    rcx,0x20
   185b6ce95:	0f 83 b0 00 00 00    	jae    0x185b6cf4b
   185b6ce9b:	48 83 c0 28          	add    rax,0x28
   185b6ce9f:	48 89 c2             	mov    rdx,rax
   185b6cea2:	4c 89 c1             	mov    rcx,r8
   185b6cea5:	e8 36 ea 93 01       	call   0x1874ab8e0
   185b6ceaa:	0f 57 c0             	xorps  xmm0,xmm0
   185b6cead:	0f 29 45 c0          	movaps XMMWORD PTR [rbp-0x40],xmm0
   185b6ceb1:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
   185b6ceb5:	48 85 c0             	test   rax,rax
   185b6ceb8:	74 0a                	je     0x185b6cec4
   185b6ceba:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   185b6cebe:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
   185b6cec2:	eb 02                	jmp    0x185b6cec6
   185b6cec4:	31 c0                	xor    eax,eax
   185b6cec6:	48 8b 4d e0          	mov    rcx,QWORD PTR [rbp-0x20]
   185b6ceca:	48 89 4d c0          	mov    QWORD PTR [rbp-0x40],rcx
   185b6cece:	48 89 45 c8          	mov    QWORD PTR [rbp-0x38],rax
   185b6ced2:	0f 29 45 d0          	movaps XMMWORD PTR [rbp-0x30],xmm0
   185b6ced6:	49 8b 47 08          	mov    rax,QWORD PTR [r15+0x8]
   185b6ceda:	48 85 c0             	test   rax,rax
   185b6cedd:	74 0a                	je     0x185b6cee9
   185b6cedf:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   185b6cee3:	49 8b 47 08          	mov    rax,QWORD PTR [r15+0x8]
   185b6cee7:	eb 02                	jmp    0x185b6ceeb
   185b6cee9:	31 c0                	xor    eax,eax
   185b6ceeb:	49 8b 0f             	mov    rcx,QWORD PTR [r15]
   185b6ceee:	48 89 4d d0          	mov    QWORD PTR [rbp-0x30],rcx
   185b6cef2:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   185b6cef6:	48 8d 55 d0          	lea    rdx,[rbp-0x30]
   185b6cefa:	4c 8d 45 c0          	lea    r8,[rbp-0x40]
   185b6cefe:	48 89 f9             	mov    rcx,rdi
   185b6cf01:	e8 3a 15 ff ff       	call   0x185b5e440
   185b6cf06:	90                   	nop
   185b6cf07:	0f 28 45 e0          	movaps xmm0,XMMWORD PTR [rbp-0x20]
   185b6cf0b:	0f 11 06             	movups XMMWORD PTR [rsi],xmm0
   185b6cf0e:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
   185b6cf12:	48 8b 78 08          	mov    rdi,QWORD PTR [rax+0x8]
   185b6cf16:	48 85 ff             	test   rdi,rdi
   185b6cf19:	74 1d                	je     0x185b6cf38
   185b6cf1b:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   185b6cf1f:	75 17                	jne    0x185b6cf38
   185b6cf21:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185b6cf24:	48 89 f9             	mov    rcx,rdi
   185b6cf27:	ff 10                	call   QWORD PTR [rax]
   185b6cf29:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   185b6cf2d:	75 09                	jne    0x185b6cf38
   185b6cf2f:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185b6cf32:	48 89 f9             	mov    rcx,rdi
   185b6cf35:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185b6cf38:	48 89 f0             	mov    rax,rsi
   185b6cf3b:	48 81 c4 88 00 00 00 	add    rsp,0x88
   185b6cf42:	5b                   	pop    rbx
   185b6cf43:	5f                   	pop    rdi
   185b6cf44:	5e                   	pop    rsi
   185b6cf45:	41 5e                	pop    r14
   185b6cf47:	41 5f                	pop    r15
   185b6cf49:	5d                   	pop    rbp
   185b6cf4a:	c3                   	ret
   185b6cf4b:	e8 3c 04 9a 01       	call   0x18750d38c
   185b6cf50:	cc                   	int3
