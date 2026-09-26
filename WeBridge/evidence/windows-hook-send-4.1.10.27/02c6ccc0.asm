
.research\wechat-4.1.10.27-reference\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000182c6ccc0 <.text+0x2c6bcc0>:
   182c6ccc0:	56                   	push   rsi
   182c6ccc1:	48 83 ec 20          	sub    rsp,0x20
   182c6ccc5:	48 89 d6             	mov    rsi,rdx
   182c6ccc8:	48 c7 42 08 00 00 00 	mov    QWORD PTR [rdx+0x8],0x0
   182c6cccf:	00 
   182c6ccd0:	b9 20 00 00 00       	mov    ecx,0x20
   182c6ccd5:	e8 22 04 ba 03       	call   0x18680d0fc
   182c6ccda:	48 89 06             	mov    QWORD PTR [rsi],rax
   182c6ccdd:	48 c7 46 10 1b 00 00 	mov    QWORD PTR [rsi+0x10],0x1b
   182c6cce4:	00 
   182c6cce5:	48 c7 46 18 1f 00 00 	mov    QWORD PTR [rsi+0x18],0x1f
   182c6ccec:	00 
   182c6cced:	0f 10 05 a4 b3 b3 05 	movups xmm0,XMMWORD PTR [rip+0x5b3b3a4]        # 0x1887a8098
   182c6ccf4:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   182c6ccf7:	0f 10 05 a5 b3 b3 05 	movups xmm0,XMMWORD PTR [rip+0x5b3b3a5]        # 0x1887a80a3
   182c6ccfe:	0f 11 40 0b          	movups XMMWORD PTR [rax+0xb],xmm0
   182c6cd02:	c6 40 1b 00          	mov    BYTE PTR [rax+0x1b],0x0
   182c6cd06:	48 89 f0             	mov    rax,rsi
   182c6cd09:	48 83 c4 20          	add    rsp,0x20
   182c6cd0d:	5e                   	pop    rsi
   182c6cd0e:	c3                   	ret
