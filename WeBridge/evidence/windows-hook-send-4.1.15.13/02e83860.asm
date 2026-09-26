
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000182e83860 <.text+0x2e82860>:
   182e83860:	56                   	push   rsi
   182e83861:	48 83 ec 20          	sub    rsp,0x20
   182e83865:	48 89 d6             	mov    rsi,rdx
   182e83868:	48 c7 42 08 00 00 00 	mov    QWORD PTR [rdx+0x8],0x0
   182e8386f:	00 
   182e83870:	b9 20 00 00 00       	mov    ecx,0x20
   182e83875:	e8 22 80 62 04       	call   0x1874ab89c
   182e8387a:	48 89 06             	mov    QWORD PTR [rsi],rax
   182e8387d:	48 c7 46 10 1b 00 00 	mov    QWORD PTR [rsi+0x10],0x1b
   182e83884:	00 
   182e83885:	48 c7 46 18 1f 00 00 	mov    QWORD PTR [rsi+0x18],0x1f
   182e8388c:	00 
   182e8388d:	0f 10 05 04 16 55 06 	movups xmm0,XMMWORD PTR [rip+0x6551604]        # 0x1893d4e98
   182e83894:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   182e83897:	0f 10 05 05 16 55 06 	movups xmm0,XMMWORD PTR [rip+0x6551605]        # 0x1893d4ea3
   182e8389e:	0f 11 40 0b          	movups XMMWORD PTR [rax+0xb],xmm0
   182e838a2:	c6 40 1b 00          	mov    BYTE PTR [rax+0x1b],0x0
   182e838a6:	48 89 f0             	mov    rax,rsi
   182e838a9:	48 83 c4 20          	add    rsp,0x20
   182e838ad:	5e                   	pop    rsi
   182e838ae:	c3                   	ret
