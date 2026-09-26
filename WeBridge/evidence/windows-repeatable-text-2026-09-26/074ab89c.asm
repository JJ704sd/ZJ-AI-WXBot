
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

00000001874ab89c <.text+0x74aa89c>:
   1874ab89c:	40 53                	rex push rbx
   1874ab89e:	48 83 ec 20          	sub    rsp,0x20
   1874ab8a2:	48 8b d9             	mov    rbx,rcx
   1874ab8a5:	eb 0f                	jmp    0x1874ab8b6
   1874ab8a7:	48 8b cb             	mov    rcx,rbx
   1874ab8aa:	e8 21 c4 05 00       	call   0x187507cd0
   1874ab8af:	85 c0                	test   eax,eax
   1874ab8b1:	74 13                	je     0x1874ab8c6
   1874ab8b3:	48 8b cb             	mov    rcx,rbx
   1874ab8b6:	e8 d9 2c 07 00       	call   0x18751e594
   1874ab8bb:	48 85 c0             	test   rax,rax
   1874ab8be:	74 e7                	je     0x1874ab8a7
   1874ab8c0:	48 83 c4 20          	add    rsp,0x20
   1874ab8c4:	5b                   	pop    rbx
   1874ab8c5:	c3                   	ret
   1874ab8c6:	48 83 fb ff          	cmp    rbx,0xffffffffffffffff
   1874ab8ca:	74 06                	je     0x1874ab8d2
   1874ab8cc:	e8 8b 0a 00 00       	call   0x1874ac35c
   1874ab8d1:	cc                   	int3
   1874ab8d2:	e8 21 72 00 00       	call   0x1874b2af8
   1874ab8d7:	cc                   	int3
