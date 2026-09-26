
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

00000001839f2c00 <.text+0x39f1c00>:
   1839f2c00:	55                   	push   rbp
   1839f2c01:	41 56                	push   r14
   1839f2c03:	56                   	push   rsi
   1839f2c04:	57                   	push   rdi
   1839f2c05:	53                   	push   rbx
   1839f2c06:	48 83 ec 40          	sub    rsp,0x40
   1839f2c0a:	48 8d 6c 24 40       	lea    rbp,[rsp+0x40]
   1839f2c0f:	48 c7 45 f8 fe ff ff 	mov    QWORD PTR [rbp-0x8],0xfffffffffffffffe
   1839f2c16:	ff 
   1839f2c17:	48 89 d6             	mov    rsi,rdx
   1839f2c1a:	48 c7 41 08 00 00 00 	mov    QWORD PTR [rcx+0x8],0x0
   1839f2c21:	00 
   1839f2c22:	c7 41 10 00 00 00 00 	mov    DWORD PTR [rcx+0x10],0x0
   1839f2c29:	0f 57 c0             	xorps  xmm0,xmm0
   1839f2c2c:	0f 11 41 18          	movups XMMWORD PTR [rcx+0x18],xmm0
   1839f2c30:	48 c7 41 28 00 00 00 	mov    QWORD PTR [rcx+0x28],0x0
   1839f2c37:	00 
   1839f2c38:	48 c7 41 30 0f 00 00 	mov    QWORD PTR [rcx+0x30],0xf
   1839f2c3f:	00 
   1839f2c40:	c7 41 38 00 00 01 01 	mov    DWORD PTR [rcx+0x38],0x1010000
   1839f2c47:	0f 11 41 40          	movups XMMWORD PTR [rcx+0x40],xmm0
   1839f2c4b:	48 c7 41 50 00 00 00 	mov    QWORD PTR [rcx+0x50],0x0
   1839f2c52:	00 
   1839f2c53:	48 c7 41 58 0f 00 00 	mov    QWORD PTR [rcx+0x58],0xf
   1839f2c5a:	00 
   1839f2c5b:	48 c7 81 98 00 00 00 	mov    QWORD PTR [rcx+0x98],0x0
   1839f2c62:	00 00 00 00 
   1839f2c66:	c6 81 a0 00 00 00 00 	mov    BYTE PTR [rcx+0xa0],0x0
   1839f2c6d:	c7 81 a4 00 00 00 00 	mov    DWORD PTR [rcx+0xa4],0x0
   1839f2c74:	00 00 00 
   1839f2c77:	48 8d 05 3a 1d b2 05 	lea    rax,[rip+0x5b21d3a]        # 0x1895149b8
   1839f2c7e:	48 89 01             	mov    QWORD PTR [rcx],rax
   1839f2c81:	48 89 4d f0          	mov    QWORD PTR [rbp-0x10],rcx
   1839f2c85:	48 81 c1 a8 00 00 00 	add    rcx,0xa8
   1839f2c8c:	48 89 4d e0          	mov    QWORD PTR [rbp-0x20],rcx
   1839f2c90:	e8 cb fa 48 ff       	call   0x182e82760
   1839f2c95:	90                   	nop
   1839f2c96:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   1839f2c9a:	48 8d 88 d8 00 00 00 	lea    rcx,[rax+0xd8]
   1839f2ca1:	48 89 4d e8          	mov    QWORD PTR [rbp-0x18],rcx
   1839f2ca5:	e8 e6 fa 48 ff       	call   0x182e82790
   1839f2caa:	90                   	nop
   1839f2cab:	8b 46 10             	mov    eax,DWORD PTR [rsi+0x10]
   1839f2cae:	48 8b 4d f0          	mov    rcx,QWORD PTR [rbp-0x10]
   1839f2cb2:	89 41 0c             	mov    DWORD PTR [rcx+0xc],eax
   1839f2cb5:	48 39 f1             	cmp    rcx,rsi
   1839f2cb8:	74 5e                	je     0x1839f2d18
   1839f2cba:	4c 8b 75 f0          	mov    r14,QWORD PTR [rbp-0x10]
   1839f2cbe:	48 8b 7e 28          	mov    rdi,QWORD PTR [rsi+0x28]
   1839f2cc2:	48 83 7e 30 10       	cmp    QWORD PTR [rsi+0x30],0x10
   1839f2cc7:	72 32                	jb     0x1839f2cfb
   1839f2cc9:	4c 8b 4e 18          	mov    r9,QWORD PTR [rsi+0x18]
   1839f2ccd:	49 8d 5e 18          	lea    rbx,[r14+0x18]
   1839f2cd1:	49 8b 46 30          	mov    rax,QWORD PTR [r14+0x30]
   1839f2cd5:	48 39 c7             	cmp    rdi,rax
   1839f2cd8:	77 32                	ja     0x1839f2d0c
   1839f2cda:	48 83 f8 10          	cmp    rax,0x10
   1839f2cde:	72 03                	jb     0x1839f2ce3
   1839f2ce0:	48 8b 1b             	mov    rbx,QWORD PTR [rbx]
   1839f2ce3:	49 89 7e 28          	mov    QWORD PTR [r14+0x28],rdi
   1839f2ce7:	48 89 d9             	mov    rcx,rbx
   1839f2cea:	4c 89 ca             	mov    rdx,r9
   1839f2ced:	49 89 f8             	mov    r8,rdi
   1839f2cf0:	e8 5b 13 b5 03       	call   0x187544050
   1839f2cf5:	c6 04 3b 00          	mov    BYTE PTR [rbx+rdi*1],0x0
   1839f2cf9:	eb 1d                	jmp    0x1839f2d18
   1839f2cfb:	4c 8d 4e 18          	lea    r9,[rsi+0x18]
   1839f2cff:	49 8d 5e 18          	lea    rbx,[r14+0x18]
   1839f2d03:	49 8b 46 30          	mov    rax,QWORD PTR [r14+0x30]
   1839f2d07:	48 39 c7             	cmp    rdi,rax
   1839f2d0a:	76 ce                	jbe    0x1839f2cda
   1839f2d0c:	48 89 d9             	mov    rcx,rbx
   1839f2d0f:	48 89 fa             	mov    rdx,rdi
   1839f2d12:	e8 39 b4 64 fc       	call   0x18003e150
   1839f2d17:	90                   	nop
   1839f2d18:	83 7e 0c 00          	cmp    DWORD PTR [rsi+0xc],0x0
   1839f2d1c:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   1839f2d20:	0f 95 40 39          	setne  BYTE PTR [rax+0x39]
   1839f2d24:	0f b6 4e 38          	movzx  ecx,BYTE PTR [rsi+0x38]
   1839f2d28:	88 48 3b             	mov    BYTE PTR [rax+0x3b],cl
   1839f2d2b:	c7 40 10 01 00 00 00 	mov    DWORD PTR [rax+0x10],0x1
   1839f2d32:	48 83 c4 40          	add    rsp,0x40
   1839f2d36:	5b                   	pop    rbx
   1839f2d37:	5f                   	pop    rdi
   1839f2d38:	5e                   	pop    rsi
   1839f2d39:	41 5e                	pop    r14
   1839f2d3b:	5d                   	pop    rbp
   1839f2d3c:	c3                   	ret
