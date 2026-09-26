
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

000000018005f2b0 <.text+0x5e2b0>:
   18005f2b0:	55                   	push   rbp
   18005f2b1:	56                   	push   rsi
   18005f2b2:	48 83 ec 48          	sub    rsp,0x48
   18005f2b6:	48 8d 6c 24 40       	lea    rbp,[rsp+0x40]
   18005f2bb:	48 c7 45 00 fe ff ff 	mov    QWORD PTR [rbp+0x0],0xfffffffffffffffe
   18005f2c2:	ff 
   18005f2c3:	48 89 d6             	mov    rsi,rdx
   18005f2c6:	49 89 c8             	mov    r8,rcx
   18005f2c9:	0f 57 c0             	xorps  xmm0,xmm0
   18005f2cc:	0f 11 01             	movups XMMWORD PTR [rcx],xmm0
   18005f2cf:	48 8b 42 08          	mov    rax,QWORD PTR [rdx+0x8]
   18005f2d3:	48 85 c0             	test   rax,rax
   18005f2d6:	74 04                	je     0x18005f2dc
   18005f2d8:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   18005f2dc:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   18005f2df:	49 89 00             	mov    QWORD PTR [r8],rax
   18005f2e2:	48 8b 46 08          	mov    rax,QWORD PTR [rsi+0x8]
   18005f2e6:	49 89 40 08          	mov    QWORD PTR [r8+0x8],rax
   18005f2ea:	49 8d 40 10          	lea    rax,[r8+0x10]
   18005f2ee:	48 89 45 e8          	mov    QWORD PTR [rbp-0x18],rax
   18005f2f2:	49 c7 40 48 00 00 00 	mov    QWORD PTR [r8+0x48],0x0
   18005f2f9:	00 
   18005f2fa:	48 8b 4e 48          	mov    rcx,QWORD PTR [rsi+0x48]
   18005f2fe:	48 85 c9             	test   rcx,rcx
   18005f301:	4c 89 45 f8          	mov    QWORD PTR [rbp-0x8],r8
   18005f305:	74 12                	je     0x18005f319
   18005f307:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18005f30a:	48 8b 55 e8          	mov    rdx,QWORD PTR [rbp-0x18]
   18005f30e:	ff 10                	call   QWORD PTR [rax]
   18005f310:	90                   	nop
   18005f311:	4c 8b 45 f8          	mov    r8,QWORD PTR [rbp-0x8]
   18005f315:	49 89 40 48          	mov    QWORD PTR [r8+0x48],rax
   18005f319:	49 8d 40 50          	lea    rax,[r8+0x50]
   18005f31d:	48 89 45 f0          	mov    QWORD PTR [rbp-0x10],rax
   18005f321:	49 c7 80 88 00 00 00 	mov    QWORD PTR [r8+0x88],0x0
   18005f328:	00 00 00 00 
   18005f32c:	48 8b 8e 88 00 00 00 	mov    rcx,QWORD PTR [rsi+0x88]
   18005f333:	48 85 c9             	test   rcx,rcx
   18005f336:	74 15                	je     0x18005f34d
   18005f338:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18005f33b:	48 8b 55 f0          	mov    rdx,QWORD PTR [rbp-0x10]
   18005f33f:	ff 10                	call   QWORD PTR [rax]
   18005f341:	90                   	nop
   18005f342:	4c 8b 45 f8          	mov    r8,QWORD PTR [rbp-0x8]
   18005f346:	49 89 80 88 00 00 00 	mov    QWORD PTR [r8+0x88],rax
   18005f34d:	49 c7 80 c8 00 00 00 	mov    QWORD PTR [r8+0xc8],0x0
   18005f354:	00 00 00 00 
   18005f358:	48 8b 8e c8 00 00 00 	mov    rcx,QWORD PTR [rsi+0xc8]
   18005f35f:	48 85 c9             	test   rcx,rcx
   18005f362:	74 1c                	je     0x18005f380
   18005f364:	49 8d 90 90 00 00 00 	lea    rdx,[r8+0x90]
   18005f36b:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18005f36e:	48 89 55 e0          	mov    QWORD PTR [rbp-0x20],rdx
   18005f372:	ff 10                	call   QWORD PTR [rax]
   18005f374:	90                   	nop
   18005f375:	4c 8b 45 f8          	mov    r8,QWORD PTR [rbp-0x8]
   18005f379:	49 89 80 c8 00 00 00 	mov    QWORD PTR [r8+0xc8],rax
   18005f380:	48 8b 86 d0 00 00 00 	mov    rax,QWORD PTR [rsi+0xd0]
   18005f387:	49 89 80 d0 00 00 00 	mov    QWORD PTR [r8+0xd0],rax
   18005f38e:	0f 57 c0             	xorps  xmm0,xmm0
   18005f391:	41 0f 11 80 d8 00 00 	movups XMMWORD PTR [r8+0xd8],xmm0
   18005f398:	00 
   18005f399:	48 83 be e0 00 00 00 	cmp    QWORD PTR [rsi+0xe0],0x0
   18005f3a0:	00 
   18005f3a1:	74 20                	je     0x18005f3c3
   18005f3a3:	48 8b 86 d8 00 00 00 	mov    rax,QWORD PTR [rsi+0xd8]
   18005f3aa:	49 89 80 d8 00 00 00 	mov    QWORD PTR [r8+0xd8],rax
   18005f3b1:	48 8b 86 e0 00 00 00 	mov    rax,QWORD PTR [rsi+0xe0]
   18005f3b8:	49 89 80 e0 00 00 00 	mov    QWORD PTR [r8+0xe0],rax
   18005f3bf:	f0 ff 40 0c          	lock inc DWORD PTR [rax+0xc]
   18005f3c3:	4c 89 c0             	mov    rax,r8
   18005f3c6:	48 83 c4 48          	add    rsp,0x48
   18005f3ca:	5e                   	pop    rsi
   18005f3cb:	5d                   	pop    rbp
   18005f3cc:	c3                   	ret
