
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000185c9cfa0 <.text+0x5c9bfa0>:
   185c9cfa0:	55                   	push   rbp
   185c9cfa1:	41 56                	push   r14
   185c9cfa3:	56                   	push   rsi
   185c9cfa4:	57                   	push   rdi
   185c9cfa5:	53                   	push   rbx
   185c9cfa6:	48 83 ec 60          	sub    rsp,0x60
   185c9cfaa:	48 8d 6c 24 60       	lea    rbp,[rsp+0x60]
   185c9cfaf:	48 c7 45 f8 fe ff ff 	mov    QWORD PTR [rbp-0x8],0xfffffffffffffffe
   185c9cfb6:	ff 
   185c9cfb7:	48 89 d7             	mov    rdi,rdx
   185c9cfba:	48 89 ce             	mov    rsi,rcx
   185c9cfbd:	0f 28 05 ec 8b 0a 03 	movaps xmm0,XMMWORD PTR [rip+0x30a8bec]        # 0x188d45bb0
   185c9cfc4:	0f 29 45 e0          	movaps XMMWORD PTR [rbp-0x20],xmm0
   185c9cfc8:	48 8d 4d e0          	lea    rcx,[rbp-0x20]
   185c9cfcc:	e8 9f 7c a5 fa       	call   0x1806f4c70
   185c9cfd1:	90                   	nop
   185c9cfd2:	48 8d 5d c0          	lea    rbx,[rbp-0x40]
   185c9cfd6:	48 89 f9             	mov    rcx,rdi
   185c9cfd9:	48 89 da             	mov    rdx,rbx
   185c9cfdc:	e8 bf 87 3e fa       	call   0x1800857a0
   185c9cfe1:	90                   	nop
   185c9cfe2:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
   185c9cfe6:	4c 8d b0 58 07 00 00 	lea    r14,[rax+0x758]
   185c9cfed:	49 39 de             	cmp    r14,rbx
   185c9cff0:	74 54                	je     0x185c9d046
   185c9cff2:	48 8b 80 70 07 00 00 	mov    rax,QWORD PTR [rax+0x770]
   185c9cff9:	48 83 f8 10          	cmp    rax,0x10
   185c9cffd:	72 34                	jb     0x185c9d033
   185c9cfff:	49 8b 0e             	mov    rcx,QWORD PTR [r14]
   185c9d002:	48 8d 50 01          	lea    rdx,[rax+0x1]
   185c9d006:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185c9d00d:	72 1f                	jb     0x185c9d02e
   185c9d00f:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   185c9d013:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   185c9d017:	4c 29 c1             	sub    rcx,r8
   185c9d01a:	48 83 f9 20          	cmp    rcx,0x20
   185c9d01e:	0f 83 c4 00 00 00    	jae    0x185c9d0e8
   185c9d024:	48 83 c0 28          	add    rax,0x28
   185c9d028:	48 89 c2             	mov    rdx,rax
   185c9d02b:	4c 89 c1             	mov    rcx,r8
   185c9d02e:	e8 ad e8 80 01       	call   0x1874ab8e0
   185c9d033:	0f 10 45 c0          	movups xmm0,XMMWORD PTR [rbp-0x40]
   185c9d037:	0f 10 4d d0          	movups xmm1,XMMWORD PTR [rbp-0x30]
   185c9d03b:	41 0f 11 4e 10       	movups XMMWORD PTR [r14+0x10],xmm1
   185c9d040:	41 0f 11 06          	movups XMMWORD PTR [r14],xmm0
   185c9d044:	eb 3b                	jmp    0x185c9d081
   185c9d046:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
   185c9d04a:	48 83 f8 10          	cmp    rax,0x10
   185c9d04e:	72 31                	jb     0x185c9d081
   185c9d050:	48 8b 4d c0          	mov    rcx,QWORD PTR [rbp-0x40]
   185c9d054:	48 8d 50 01          	lea    rdx,[rax+0x1]
   185c9d058:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185c9d05f:	72 1b                	jb     0x185c9d07c
   185c9d061:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   185c9d065:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   185c9d069:	4c 29 c1             	sub    rcx,r8
   185c9d06c:	48 83 f9 20          	cmp    rcx,0x20
   185c9d070:	73 76                	jae    0x185c9d0e8
   185c9d072:	48 83 c0 28          	add    rax,0x28
   185c9d076:	48 89 c2             	mov    rdx,rax
   185c9d079:	4c 89 c1             	mov    rcx,r8
   185c9d07c:	e8 5f e8 80 01       	call   0x1874ab8e0
   185c9d081:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
   185c9d085:	c7 80 18 01 00 00 01 	mov    DWORD PTR [rax+0x118],0x1
   185c9d08c:	00 00 00 
   185c9d08f:	48 8d 4d c0          	lea    rcx,[rbp-0x40]
   185c9d093:	48 89 fa             	mov    rdx,rdi
   185c9d096:	e8 15 a9 38 fa       	call   0x1800279b0
   185c9d09b:	90                   	nop
   185c9d09c:	48 8b 4d c0          	mov    rcx,QWORD PTR [rbp-0x40]
   185c9d0a0:	48 63 41 04          	movsxd rax,DWORD PTR [rcx+0x4]
   185c9d0a4:	48 8b 55 e0          	mov    rdx,QWORD PTR [rbp-0x20]
   185c9d0a8:	48 89 82 c8 01 00 00 	mov    QWORD PTR [rdx+0x1c8],rax
   185c9d0af:	8b 01                	mov    eax,DWORD PTR [rcx]
   185c9d0b1:	83 f8 ff             	cmp    eax,0xffffffff
   185c9d0b4:	74 1d                	je     0x185c9d0d3
   185c9d0b6:	85 c0                	test   eax,eax
   185c9d0b8:	74 09                	je     0x185c9d0c3
   185c9d0ba:	f0 ff 09             	lock dec DWORD PTR [rcx]
   185c9d0bd:	75 14                	jne    0x185c9d0d3
   185c9d0bf:	48 8b 4d c0          	mov    rcx,QWORD PTR [rbp-0x40]
   185c9d0c3:	ba 01 00 00 00       	mov    edx,0x1
   185c9d0c8:	41 b8 08 00 00 00    	mov    r8d,0x8
   185c9d0ce:	e8 5d b8 39 fa       	call   0x180038930
   185c9d0d3:	0f 28 45 e0          	movaps xmm0,XMMWORD PTR [rbp-0x20]
   185c9d0d7:	0f 11 06             	movups XMMWORD PTR [rsi],xmm0
   185c9d0da:	48 89 f0             	mov    rax,rsi
   185c9d0dd:	48 83 c4 60          	add    rsp,0x60
   185c9d0e1:	5b                   	pop    rbx
   185c9d0e2:	5f                   	pop    rdi
   185c9d0e3:	5e                   	pop    rsi
   185c9d0e4:	41 5e                	pop    r14
   185c9d0e6:	5d                   	pop    rbp
   185c9d0e7:	c3                   	ret
   185c9d0e8:	e8 9f 02 87 01       	call   0x18750d38c
   185c9d0ed:	cc                   	int3
