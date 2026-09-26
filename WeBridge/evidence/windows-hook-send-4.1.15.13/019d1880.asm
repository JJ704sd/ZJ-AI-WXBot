
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

00000001819d1880 <.text+0x19d0880>:
   1819d1880:	56                   	push   rsi
   1819d1881:	48 83 ec 20          	sub    rsp,0x20
   1819d1885:	48 85 c9             	test   rcx,rcx
   1819d1888:	74 1c                	je     0x1819d18a6
   1819d188a:	48 8d 41 28          	lea    rax,[rcx+0x28]
   1819d188e:	48 89 ce             	mov    rsi,rcx
   1819d1891:	48 89 c1             	mov    rcx,rax
   1819d1894:	e8 17 00 00 00       	call   0x1819d18b0
   1819d1899:	48 89 f1             	mov    rcx,rsi
   1819d189c:	48 83 c4 20          	add    rsp,0x20
   1819d18a0:	5e                   	pop    rsi
   1819d18a1:	e9 32 a0 ad 05       	jmp    0x1874ab8d8
   1819d18a6:	48 83 c4 20          	add    rsp,0x20
   1819d18aa:	5e                   	pop    rsi
   1819d18ab:	c3                   	ret
