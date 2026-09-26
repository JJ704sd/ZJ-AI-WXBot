
.research\wechat-4.1.10.27-reference\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000182c6d260 <.text+0x2c6c260>:
   182c6d260:	56                   	push   rsi
   182c6d261:	48 83 ec 20          	sub    rsp,0x20
   182c6d265:	48 89 d6             	mov    rsi,rdx
   182c6d268:	48 c7 42 08 00 00 00 	mov    QWORD PTR [rdx+0x8],0x0
   182c6d26f:	00 
   182c6d270:	b9 20 00 00 00       	mov    ecx,0x20
   182c6d275:	e8 82 fe b9 03       	call   0x18680d0fc
   182c6d27a:	48 89 06             	mov    QWORD PTR [rsi],rax
   182c6d27d:	48 c7 46 10 1a 00 00 	mov    QWORD PTR [rsi+0x10],0x1a
   182c6d284:	00 
   182c6d285:	48 c7 46 18 1f 00 00 	mov    QWORD PTR [rsi+0x18],0x1f
   182c6d28c:	00 
   182c6d28d:	0f 10 05 94 ae b3 05 	movups xmm0,XMMWORD PTR [rip+0x5b3ae94]        # 0x1887a8128
   182c6d294:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   182c6d297:	0f 10 05 94 ae b3 05 	movups xmm0,XMMWORD PTR [rip+0x5b3ae94]        # 0x1887a8132
   182c6d29e:	0f 11 40 0a          	movups XMMWORD PTR [rax+0xa],xmm0
   182c6d2a2:	c6 40 1a 00          	mov    BYTE PTR [rax+0x1a],0x0
   182c6d2a6:	48 89 f0             	mov    rax,rsi
   182c6d2a9:	48 83 c4 20          	add    rsp,0x20
   182c6d2ad:	5e                   	pop    rsi
   182c6d2ae:	c3                   	ret
