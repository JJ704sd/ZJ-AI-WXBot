
.research\wechat-4.1.10.27-reference\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

00000001806b2c30 <.text+0x6b1c30>:
   1806b2c30:	55                   	push   rbp
   1806b2c31:	56                   	push   rsi
   1806b2c32:	57                   	push   rdi
   1806b2c33:	48 83 ec 50          	sub    rsp,0x50
   1806b2c37:	48 8d 6c 24 50       	lea    rbp,[rsp+0x50]
   1806b2c3c:	48 c7 45 f8 fe ff ff 	mov    QWORD PTR [rbp-0x8],0xfffffffffffffffe
   1806b2c43:	ff 
   1806b2c44:	48 89 ce             	mov    rsi,rcx
   1806b2c47:	48 8d 7d d8          	lea    rdi,[rbp-0x28]
   1806b2c4b:	48 89 f9             	mov    rcx,rdi
   1806b2c4e:	e8 ed c5 e2 ff       	call   0x1804df240
   1806b2c53:	90                   	nop
   1806b2c54:	48 89 f1             	mov    rcx,rsi
   1806b2c57:	48 89 fa             	mov    rdx,rdi
   1806b2c5a:	e8 d1 00 00 00       	call   0x1806b2d30
   1806b2c5f:	90                   	nop
   1806b2c60:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   1806b2c64:	48 83 f8 10          	cmp    rax,0x10
   1806b2c68:	72 31                	jb     0x1806b2c9b
   1806b2c6a:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   1806b2c6e:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1806b2c72:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1806b2c79:	72 1b                	jb     0x1806b2c96
   1806b2c7b:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1806b2c7f:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1806b2c83:	4c 29 c1             	sub    rcx,r8
   1806b2c86:	48 83 f9 20          	cmp    rcx,0x20
   1806b2c8a:	73 61                	jae    0x1806b2ced
   1806b2c8c:	48 83 c0 28          	add    rax,0x28
   1806b2c90:	48 89 c2             	mov    rdx,rax
   1806b2c93:	4c 89 c1             	mov    rcx,r8
   1806b2c96:	e8 a5 a4 15 06       	call   0x18680d140
   1806b2c9b:	48 8d 05 46 67 bc 07 	lea    rax,[rip+0x7bc6746]        # 0x1882793e8
   1806b2ca2:	48 89 06             	mov    QWORD PTR [rsi],rax
   1806b2ca5:	0f 57 c0             	xorps  xmm0,xmm0
   1806b2ca8:	0f 11 86 08 07 00 00 	movups XMMWORD PTR [rsi+0x708],xmm0
   1806b2caf:	48 c7 86 18 07 00 00 	mov    QWORD PTR [rsi+0x718],0x0
   1806b2cb6:	00 00 00 00 
   1806b2cba:	48 c7 86 20 07 00 00 	mov    QWORD PTR [rsi+0x720],0xf
   1806b2cc1:	0f 00 00 00 
   1806b2cc5:	0f 11 86 28 07 00 00 	movups XMMWORD PTR [rsi+0x728],xmm0
   1806b2ccc:	48 c7 86 38 07 00 00 	mov    QWORD PTR [rsi+0x738],0x0
   1806b2cd3:	00 00 00 00 
   1806b2cd7:	48 c7 86 40 07 00 00 	mov    QWORD PTR [rsi+0x740],0xf
   1806b2cde:	0f 00 00 00 
   1806b2ce2:	48 89 f0             	mov    rax,rsi
   1806b2ce5:	48 83 c4 50          	add    rsp,0x50
   1806b2ce9:	5f                   	pop    rdi
   1806b2cea:	5e                   	pop    rsi
   1806b2ceb:	5d                   	pop    rbp
   1806b2cec:	c3                   	ret
   1806b2ced:	e8 86 d7 1a 06       	call   0x186860478
   1806b2cf2:	cc                   	int3
