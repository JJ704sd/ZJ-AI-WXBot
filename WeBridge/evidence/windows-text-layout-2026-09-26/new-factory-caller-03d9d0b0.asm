
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000183d9d0b0 <.text+0x3d9c0b0>:
   183d9d0b0:	55                   	push   rbp
   183d9d0b1:	41 56                	push   r14
   183d9d0b3:	56                   	push   rsi
   183d9d0b4:	57                   	push   rdi
   183d9d0b5:	53                   	push   rbx
   183d9d0b6:	48 83 ec 60          	sub    rsp,0x60
   183d9d0ba:	48 8d 6c 24 60       	lea    rbp,[rsp+0x60]
   183d9d0bf:	48 c7 45 f8 fe ff ff 	mov    QWORD PTR [rbp-0x8],0xfffffffffffffffe
   183d9d0c6:	ff 
   183d9d0c7:	4c 89 c7             	mov    rdi,r8
   183d9d0ca:	48 89 d6             	mov    rsi,rdx
   183d9d0cd:	0f 28 05 dc 8a fa 04 	movaps xmm0,XMMWORD PTR [rip+0x4fa8adc]        # 0x188d45bb0
   183d9d0d4:	0f 29 45 e0          	movaps XMMWORD PTR [rbp-0x20],xmm0
   183d9d0d8:	48 8d 4d e0          	lea    rcx,[rbp-0x20]
   183d9d0dc:	e8 8f 7b 95 fc       	call   0x1806f4c70
   183d9d0e1:	90                   	nop
   183d9d0e2:	48 8d 5d c0          	lea    rbx,[rbp-0x40]
   183d9d0e6:	48 89 f9             	mov    rcx,rdi
   183d9d0e9:	48 89 da             	mov    rdx,rbx
   183d9d0ec:	e8 af 86 2e fc       	call   0x1800857a0
   183d9d0f1:	90                   	nop
   183d9d0f2:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
   183d9d0f6:	4c 8d b0 58 07 00 00 	lea    r14,[rax+0x758]
   183d9d0fd:	49 39 de             	cmp    r14,rbx
   183d9d100:	74 54                	je     0x183d9d156
   183d9d102:	48 8b 80 70 07 00 00 	mov    rax,QWORD PTR [rax+0x770]
   183d9d109:	48 83 f8 10          	cmp    rax,0x10
   183d9d10d:	72 34                	jb     0x183d9d143
   183d9d10f:	49 8b 0e             	mov    rcx,QWORD PTR [r14]
   183d9d112:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183d9d116:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183d9d11d:	72 1f                	jb     0x183d9d13e
   183d9d11f:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183d9d123:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183d9d127:	4c 29 c1             	sub    rcx,r8
   183d9d12a:	48 83 f9 20          	cmp    rcx,0x20
   183d9d12e:	0f 83 c4 00 00 00    	jae    0x183d9d1f8
   183d9d134:	48 83 c0 28          	add    rax,0x28
   183d9d138:	48 89 c2             	mov    rdx,rax
   183d9d13b:	4c 89 c1             	mov    rcx,r8
   183d9d13e:	e8 9d e7 70 03       	call   0x1874ab8e0
   183d9d143:	0f 10 45 c0          	movups xmm0,XMMWORD PTR [rbp-0x40]
   183d9d147:	0f 10 4d d0          	movups xmm1,XMMWORD PTR [rbp-0x30]
   183d9d14b:	41 0f 11 4e 10       	movups XMMWORD PTR [r14+0x10],xmm1
   183d9d150:	41 0f 11 06          	movups XMMWORD PTR [r14],xmm0
   183d9d154:	eb 3b                	jmp    0x183d9d191
   183d9d156:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
   183d9d15a:	48 83 f8 10          	cmp    rax,0x10
   183d9d15e:	72 31                	jb     0x183d9d191
   183d9d160:	48 8b 4d c0          	mov    rcx,QWORD PTR [rbp-0x40]
   183d9d164:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183d9d168:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183d9d16f:	72 1b                	jb     0x183d9d18c
   183d9d171:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183d9d175:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183d9d179:	4c 29 c1             	sub    rcx,r8
   183d9d17c:	48 83 f9 20          	cmp    rcx,0x20
   183d9d180:	73 76                	jae    0x183d9d1f8
   183d9d182:	48 83 c0 28          	add    rax,0x28
   183d9d186:	48 89 c2             	mov    rdx,rax
   183d9d189:	4c 89 c1             	mov    rcx,r8
   183d9d18c:	e8 4f e7 70 03       	call   0x1874ab8e0
   183d9d191:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
   183d9d195:	c7 80 18 01 00 00 01 	mov    DWORD PTR [rax+0x118],0x1
   183d9d19c:	00 00 00 
   183d9d19f:	48 8d 4d c0          	lea    rcx,[rbp-0x40]
   183d9d1a3:	48 89 fa             	mov    rdx,rdi
   183d9d1a6:	e8 05 a8 28 fc       	call   0x1800279b0
   183d9d1ab:	90                   	nop
   183d9d1ac:	48 8b 4d c0          	mov    rcx,QWORD PTR [rbp-0x40]
   183d9d1b0:	48 63 41 04          	movsxd rax,DWORD PTR [rcx+0x4]
   183d9d1b4:	48 8b 55 e0          	mov    rdx,QWORD PTR [rbp-0x20]
   183d9d1b8:	48 89 82 c8 01 00 00 	mov    QWORD PTR [rdx+0x1c8],rax
   183d9d1bf:	8b 01                	mov    eax,DWORD PTR [rcx]
   183d9d1c1:	83 f8 ff             	cmp    eax,0xffffffff
   183d9d1c4:	74 1d                	je     0x183d9d1e3
   183d9d1c6:	85 c0                	test   eax,eax
   183d9d1c8:	74 09                	je     0x183d9d1d3
   183d9d1ca:	f0 ff 09             	lock dec DWORD PTR [rcx]
   183d9d1cd:	75 14                	jne    0x183d9d1e3
   183d9d1cf:	48 8b 4d c0          	mov    rcx,QWORD PTR [rbp-0x40]
   183d9d1d3:	ba 01 00 00 00       	mov    edx,0x1
   183d9d1d8:	41 b8 08 00 00 00    	mov    r8d,0x8
   183d9d1de:	e8 4d b7 29 fc       	call   0x180038930
   183d9d1e3:	0f 28 45 e0          	movaps xmm0,XMMWORD PTR [rbp-0x20]
   183d9d1e7:	0f 11 06             	movups XMMWORD PTR [rsi],xmm0
   183d9d1ea:	48 89 f0             	mov    rax,rsi
   183d9d1ed:	48 83 c4 60          	add    rsp,0x60
   183d9d1f1:	5b                   	pop    rbx
   183d9d1f2:	5f                   	pop    rdi
   183d9d1f3:	5e                   	pop    rsi
   183d9d1f4:	41 5e                	pop    r14
   183d9d1f6:	5d                   	pop    rbp
   183d9d1f7:	c3                   	ret
   183d9d1f8:	e8 8f 01 77 03       	call   0x18750d38c
   183d9d1fd:	cc                   	int3
