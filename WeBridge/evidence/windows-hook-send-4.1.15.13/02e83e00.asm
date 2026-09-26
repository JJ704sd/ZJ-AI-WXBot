
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000182e83e00 <.text+0x2e82e00>:
   182e83e00:	56                   	push   rsi
   182e83e01:	48 83 ec 20          	sub    rsp,0x20
   182e83e05:	48 89 d6             	mov    rsi,rdx
   182e83e08:	48 c7 42 08 00 00 00 	mov    QWORD PTR [rdx+0x8],0x0
   182e83e0f:	00 
   182e83e10:	b9 20 00 00 00       	mov    ecx,0x20
   182e83e15:	e8 82 7a 62 04       	call   0x1874ab89c
   182e83e1a:	48 89 06             	mov    QWORD PTR [rsi],rax
   182e83e1d:	48 c7 46 10 1a 00 00 	mov    QWORD PTR [rsi+0x10],0x1a
   182e83e24:	00 
   182e83e25:	48 c7 46 18 1f 00 00 	mov    QWORD PTR [rsi+0x18],0x1f
   182e83e2c:	00 
   182e83e2d:	0f 10 05 f4 10 55 06 	movups xmm0,XMMWORD PTR [rip+0x65510f4]        # 0x1893d4f28
   182e83e34:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   182e83e37:	0f 10 05 f4 10 55 06 	movups xmm0,XMMWORD PTR [rip+0x65510f4]        # 0x1893d4f32
   182e83e3e:	0f 11 40 0a          	movups XMMWORD PTR [rax+0xa],xmm0
   182e83e42:	c6 40 1a 00          	mov    BYTE PTR [rax+0x1a],0x0
   182e83e46:	48 89 f0             	mov    rax,rsi
   182e83e49:	48 83 c4 20          	add    rsp,0x20
   182e83e4d:	5e                   	pop    rsi
   182e83e4e:	c3                   	ret
