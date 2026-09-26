
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000182e838b0 <.text+0x2e828b0>:
   182e838b0:	55                   	push   rbp
   182e838b1:	48 83 ec 40          	sub    rsp,0x40
   182e838b5:	48 8d 6c 24 40       	lea    rbp,[rsp+0x40]
   182e838ba:	48 c7 45 f8 fe ff ff 	mov    QWORD PTR [rbp-0x8],0xfffffffffffffffe
   182e838c1:	ff 
   182e838c2:	48 8d 05 ff 15 55 06 	lea    rax,[rip+0x65515ff]        # 0x1893d4ec8
   182e838c9:	48 89 01             	mov    QWORD PTR [rcx],rax
   182e838cc:	48 8d 41 08          	lea    rax,[rcx+0x8]
   182e838d0:	48 89 45 e8          	mov    QWORD PTR [rbp-0x18],rax
   182e838d4:	0f 57 c0             	xorps  xmm0,xmm0
   182e838d7:	0f 11 41 08          	movups XMMWORD PTR [rcx+0x8],xmm0
   182e838db:	c7 41 18 00 00 00 00 	mov    DWORD PTR [rcx+0x18],0x0
   182e838e2:	48 c7 41 20 00 00 00 	mov    QWORD PTR [rcx+0x20],0x0
   182e838e9:	00 
   182e838ea:	c7 41 28 00 00 00 00 	mov    DWORD PTR [rcx+0x28],0x0
   182e838f1:	48 89 4d f0          	mov    QWORD PTR [rbp-0x10],rcx
   182e838f5:	e8 46 00 00 00       	call   0x182e83940
   182e838fa:	90                   	nop
   182e838fb:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   182e838ff:	48 83 c4 40          	add    rsp,0x40
   182e83903:	5d                   	pop    rbp
   182e83904:	c3                   	ret
