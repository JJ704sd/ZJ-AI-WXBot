
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

00000001849ab300 <.text+0x49aa300>:
   1849ab300:	56                   	push   rsi
   1849ab301:	48 83 ec 20          	sub    rsp,0x20
   1849ab305:	48 89 ce             	mov    rsi,rcx
   1849ab308:	e8 13 dd 7f fb       	call   0x1801a9020
   1849ab30d:	48 8d 05 f4 51 8a 04 	lea    rax,[rip+0x48a51f4]        # 0x189250508
   1849ab314:	48 89 06             	mov    QWORD PTR [rsi],rax
   1849ab317:	0f 57 c0             	xorps  xmm0,xmm0
   1849ab31a:	0f 11 86 d0 06 00 00 	movups XMMWORD PTR [rsi+0x6d0],xmm0
   1849ab321:	0f 11 86 e0 06 00 00 	movups XMMWORD PTR [rsi+0x6e0],xmm0
   1849ab328:	0f 11 86 f0 06 00 00 	movups XMMWORD PTR [rsi+0x6f0],xmm0
   1849ab32f:	48 c7 86 00 07 00 00 	mov    QWORD PTR [rsi+0x700],0xf
   1849ab336:	0f 00 00 00 
   1849ab33a:	0f 11 86 08 07 00 00 	movups XMMWORD PTR [rsi+0x708],xmm0
   1849ab341:	48 c7 86 18 07 00 00 	mov    QWORD PTR [rsi+0x718],0x0
   1849ab348:	00 00 00 00 
   1849ab34c:	48 c7 86 20 07 00 00 	mov    QWORD PTR [rsi+0x720],0xf
   1849ab353:	0f 00 00 00 
   1849ab357:	0f 11 86 28 07 00 00 	movups XMMWORD PTR [rsi+0x728],xmm0
   1849ab35e:	48 c7 86 38 07 00 00 	mov    QWORD PTR [rsi+0x738],0x0
   1849ab365:	00 00 00 00 
   1849ab369:	48 c7 86 40 07 00 00 	mov    QWORD PTR [rsi+0x740],0xf
   1849ab370:	0f 00 00 00 
   1849ab374:	48 c7 86 48 07 00 00 	mov    QWORD PTR [rsi+0x748],0x0
   1849ab37b:	00 00 00 00 
   1849ab37f:	48 89 f0             	mov    rax,rsi
   1849ab382:	48 83 c4 20          	add    rsp,0x20
   1849ab386:	5e                   	pop    rsi
   1849ab387:	c3                   	ret
