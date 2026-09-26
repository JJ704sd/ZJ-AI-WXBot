
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

00000001817f7a00 <.text+0x17f6a00>:
   1817f7a00:	55                   	push   rbp
   1817f7a01:	41 56                	push   r14
   1817f7a03:	56                   	push   rsi
   1817f7a04:	57                   	push   rdi
   1817f7a05:	53                   	push   rbx
   1817f7a06:	48 81 ec b0 02 00 00 	sub    rsp,0x2b0
   1817f7a0d:	48 8d ac 24 80 00 00 	lea    rbp,[rsp+0x80]
   1817f7a14:	00 
   1817f7a15:	0f 29 b5 20 02 00 00 	movaps XMMWORD PTR [rbp+0x220],xmm6
   1817f7a1c:	48 c7 85 18 02 00 00 	mov    QWORD PTR [rbp+0x218],0xfffffffffffffffe
   1817f7a23:	fe ff ff ff 
   1817f7a27:	4c 89 85 10 02 00 00 	mov    QWORD PTR [rbp+0x210],r8
   1817f7a2e:	49 89 d6             	mov    r14,rdx
   1817f7a31:	48 89 ce             	mov    rsi,rcx
   1817f7a34:	0f 28 35 75 e1 54 07 	movaps xmm6,XMMWORD PTR [rip+0x754e175]        # 0x188d45bb0
   1817f7a3b:	0f 29 75 30          	movaps XMMWORD PTR [rbp+0x30],xmm6
   1817f7a3f:	48 8d 15 92 ef 8e 07 	lea    rdx,[rip+0x78eef92]        # 0x1890e69d8
   1817f7a46:	4c 8d 05 ab 43 8e 07 	lea    r8,[rip+0x78e43ab]        # 0x1890dbdf8
   1817f7a4d:	48 8d 8d a0 00 00 00 	lea    rcx,[rbp+0xa0]
   1817f7a54:	41 b9 85 10 00 00    	mov    r9d,0x1085
   1817f7a5a:	e8 a1 2a 9a fe       	call   0x18019a500
   1817f7a5f:	90                   	nop
   1817f7a60:	c7 45 30 02 00 00 00 	mov    DWORD PTR [rbp+0x30],0x2
   1817f7a67:	48 c7 45 40 00 00 00 	mov    QWORD PTR [rbp+0x40],0x0
   1817f7a6e:	00 
   1817f7a6f:	0f 28 85 a0 00 00 00 	movaps xmm0,XMMWORD PTR [rbp+0xa0]
   1817f7a76:	0f 11 45 48          	movups XMMWORD PTR [rbp+0x48],xmm0
   1817f7a7a:	0f 57 c0             	xorps  xmm0,xmm0
   1817f7a7d:	0f 11 45 58          	movups XMMWORD PTR [rbp+0x58],xmm0
   1817f7a81:	48 c7 45 68 00 00 00 	mov    QWORD PTR [rbp+0x68],0x0
   1817f7a88:	00 
   1817f7a89:	48 c7 45 70 0f 00 00 	mov    QWORD PTR [rbp+0x70],0xf
   1817f7a90:	00 
   1817f7a91:	e8 2a d5 1b ff       	call   0x1809b4fc0
   1817f7a96:	90                   	nop
   1817f7a97:	48 89 45 38          	mov    QWORD PTR [rbp+0x38],rax
   1817f7a9b:	48 83 7d 70 1f       	cmp    QWORD PTR [rbp+0x70],0x1f
   1817f7aa0:	73 18                	jae    0x1817f7aba
   1817f7aa2:	4c 8d 0d e7 db 8d 07 	lea    r9,[rip+0x78ddbe7]        # 0x1890d5690
   1817f7aa9:	ba 1f 00 00 00       	mov    edx,0x1f
   1817f7aae:	48 8d 4d 58          	lea    rcx,[rbp+0x58]
   1817f7ab2:	e8 99 66 84 fe       	call   0x18003e150
   1817f7ab7:	90                   	nop
   1817f7ab8:	eb 25                	jmp    0x1817f7adf
   1817f7aba:	48 8b 45 58          	mov    rax,QWORD PTR [rbp+0x58]
   1817f7abe:	48 c7 45 68 1f 00 00 	mov    QWORD PTR [rbp+0x68],0x1f
   1817f7ac5:	00 
   1817f7ac6:	0f 10 05 d2 db 8d 07 	movups xmm0,XMMWORD PTR [rip+0x78ddbd2]        # 0x1890d569f
   1817f7acd:	0f 11 40 0f          	movups XMMWORD PTR [rax+0xf],xmm0
   1817f7ad1:	0f 10 05 b8 db 8d 07 	movups xmm0,XMMWORD PTR [rip+0x78ddbb8]        # 0x1890d5690
   1817f7ad8:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   1817f7adb:	c6 40 1f 00          	mov    BYTE PTR [rax+0x1f],0x0
   1817f7adf:	0f 29 b5 30 01 00 00 	movaps XMMWORD PTR [rbp+0x130],xmm6
   1817f7ae6:	0f 57 c0             	xorps  xmm0,xmm0
   1817f7ae9:	0f 29 85 80 00 00 00 	movaps XMMWORD PTR [rbp+0x80],xmm0
   1817f7af0:	48 8b 8d 10 02 00 00 	mov    rcx,QWORD PTR [rbp+0x210]
   1817f7af7:	48 8b 41 08          	mov    rax,QWORD PTR [rcx+0x8]
   1817f7afb:	48 85 c0             	test   rax,rax
   1817f7afe:	74 0a                	je     0x1817f7b0a
   1817f7b00:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   1817f7b04:	48 8b 41 08          	mov    rax,QWORD PTR [rcx+0x8]
   1817f7b08:	eb 02                	jmp    0x1817f7b0c
   1817f7b0a:	31 c0                	xor    eax,eax
   1817f7b0c:	48 8b 09             	mov    rcx,QWORD PTR [rcx]
   1817f7b0f:	48 89 8d 80 00 00 00 	mov    QWORD PTR [rbp+0x80],rcx
   1817f7b16:	48 89 85 88 00 00 00 	mov    QWORD PTR [rbp+0x88],rax
   1817f7b1d:	48 8d 95 30 01 00 00 	lea    rdx,[rbp+0x130]
   1817f7b24:	4c 8d 85 80 00 00 00 	lea    r8,[rbp+0x80]
   1817f7b2b:	48 89 f1             	mov    rcx,rsi
   1817f7b2e:	e8 bd 99 fa ff       	call   0x1817a14f0
   1817f7b33:	90                   	nop
   1817f7b34:	48 8b 8d 30 01 00 00 	mov    rcx,QWORD PTR [rbp+0x130]
   1817f7b3b:	48 85 c9             	test   rcx,rcx
   1817f7b3e:	74 47                	je     0x1817f7b87
   1817f7b40:	48 b8 aa aa aa aa aa 	movabs rax,0xaaaaaaaaaaaaaaaa
   1817f7b47:	aa aa aa 
   1817f7b4a:	49 89 46 30          	mov    QWORD PTR [r14+0x30],rax
   1817f7b4e:	41 0f 11 76 20       	movups XMMWORD PTR [r14+0x20],xmm6
   1817f7b53:	41 0f 11 76 10       	movups XMMWORD PTR [r14+0x10],xmm6
   1817f7b58:	41 0f 11 36          	movups XMMWORD PTR [r14],xmm6
   1817f7b5c:	0f 57 c0             	xorps  xmm0,xmm0
   1817f7b5f:	0f 29 85 90 00 00 00 	movaps XMMWORD PTR [rbp+0x90],xmm0
   1817f7b66:	48 8b 95 10 02 00 00 	mov    rdx,QWORD PTR [rbp+0x210]
   1817f7b6d:	48 8b 42 08          	mov    rax,QWORD PTR [rdx+0x8]
   1817f7b71:	48 85 c0             	test   rax,rax
   1817f7b74:	0f 84 3e 01 00 00    	je     0x1817f7cb8
   1817f7b7a:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   1817f7b7e:	48 8b 42 08          	mov    rax,QWORD PTR [rdx+0x8]
   1817f7b82:	e9 33 01 00 00       	jmp    0x1817f7cba
   1817f7b87:	b9 04 00 00 00       	mov    ecx,0x4
   1817f7b8c:	e8 4f 52 87 fe       	call   0x18006cde0
   1817f7b91:	85 c0                	test   eax,eax
   1817f7b93:	0f 84 f8 00 00 00    	je     0x1817f7c91
   1817f7b99:	48 8d 75 e0          	lea    rsi,[rbp-0x20]
   1817f7b9d:	48 89 f1             	mov    rcx,rsi
   1817f7ba0:	e8 6b 53 87 fe       	call   0x18006cf10
   1817f7ba5:	90                   	nop
   1817f7ba6:	48 83 7d f8 10       	cmp    QWORD PTR [rbp-0x8],0x10
   1817f7bab:	72 04                	jb     0x1817f7bb1
   1817f7bad:	48 8b 75 e0          	mov    rsi,QWORD PTR [rbp-0x20]
   1817f7bb1:	48 8d 05 c0 a6 8e 07 	lea    rax,[rip+0x78ea6c0]        # 0x1890e2278
   1817f7bb8:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1817f7bbd:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   1817f7bc4:	00 00 
   1817f7bc6:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   1817f7bcb:	c7 44 24 28 88 10 00 	mov    DWORD PTR [rsp+0x28],0x1088
   1817f7bd2:	00 
   1817f7bd3:	4c 8d 0d 1e 42 8e 07 	lea    r9,[rip+0x78e421e]        # 0x1890dbdf8
   1817f7bda:	48 8d 8d a0 00 00 00 	lea    rcx,[rbp+0xa0]
   1817f7be1:	ba 04 00 00 00       	mov    edx,0x4
   1817f7be6:	49 89 f0             	mov    r8,rsi
   1817f7be9:	e8 82 56 87 fe       	call   0x18006d270
   1817f7bee:	90                   	nop
   1817f7bef:	0f 57 c0             	xorps  xmm0,xmm0
   1817f7bf2:	0f 29 85 b0 01 00 00 	movaps XMMWORD PTR [rbp+0x1b0],xmm0
   1817f7bf9:	0f 29 85 a0 01 00 00 	movaps XMMWORD PTR [rbp+0x1a0],xmm0
   1817f7c00:	0f 29 85 90 01 00 00 	movaps XMMWORD PTR [rbp+0x190],xmm0
   1817f7c07:	0f 29 85 80 01 00 00 	movaps XMMWORD PTR [rbp+0x180],xmm0
   1817f7c0e:	0f 29 85 70 01 00 00 	movaps XMMWORD PTR [rbp+0x170],xmm0
   1817f7c15:	0f 29 85 60 01 00 00 	movaps XMMWORD PTR [rbp+0x160],xmm0
   1817f7c1c:	0f 29 85 50 01 00 00 	movaps XMMWORD PTR [rbp+0x150],xmm0
   1817f7c23:	0f 29 85 40 01 00 00 	movaps XMMWORD PTR [rbp+0x140],xmm0
   1817f7c2a:	48 8d 15 3f ed 8e 07 	lea    rdx,[rip+0x78eed3f]        # 0x1890e6970
   1817f7c31:	48 8d 8d a0 00 00 00 	lea    rcx,[rbp+0xa0]
   1817f7c38:	4c 8d 85 40 01 00 00 	lea    r8,[rbp+0x140]
   1817f7c3f:	e8 cc 5b 87 fe       	call   0x18006d810
   1817f7c44:	90                   	nop
   1817f7c45:	48 8d 8d a0 00 00 00 	lea    rcx,[rbp+0xa0]
   1817f7c4c:	e8 1f 57 87 fe       	call   0x18006d370
   1817f7c51:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
   1817f7c55:	48 83 f8 10          	cmp    rax,0x10
   1817f7c59:	72 36                	jb     0x1817f7c91
   1817f7c5b:	48 8b 4d e0          	mov    rcx,QWORD PTR [rbp-0x20]
   1817f7c5f:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1817f7c63:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1817f7c6a:	72 1f                	jb     0x1817f7c8b
   1817f7c6c:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1817f7c70:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1817f7c74:	4c 29 c1             	sub    rcx,r8
   1817f7c77:	48 83 f9 20          	cmp    rcx,0x20
   1817f7c7b:	0f 83 88 07 00 00    	jae    0x1817f8409
   1817f7c81:	48 83 c0 28          	add    rax,0x28
   1817f7c85:	48 89 c2             	mov    rdx,rax
   1817f7c88:	4c 89 c1             	mov    rcx,r8
   1817f7c8b:	e8 50 3c cb 05       	call   0x1874ab8e0
   1817f7c90:	90                   	nop
   1817f7c91:	c7 44 24 20 04 00 00 	mov    DWORD PTR [rsp+0x20],0x4
   1817f7c98:	00 
   1817f7c99:	4c 89 f1             	mov    rcx,r14
   1817f7c9c:	ba 01 00 00 00       	mov    edx,0x1
   1817f7ca1:	41 b8 01 00 00 00    	mov    r8d,0x1
   1817f7ca7:	41 b9 04 00 00 00    	mov    r9d,0x4
   1817f7cad:	e8 fe 00 19 02       	call   0x183987db0
   1817f7cb2:	90                   	nop
   1817f7cb3:	e9 a8 06 00 00       	jmp    0x1817f8360
   1817f7cb8:	31 c0                	xor    eax,eax
   1817f7cba:	48 8b 12             	mov    rdx,QWORD PTR [rdx]
   1817f7cbd:	48 89 95 90 00 00 00 	mov    QWORD PTR [rbp+0x90],rdx
   1817f7cc4:	48 89 85 98 00 00 00 	mov    QWORD PTR [rbp+0x98],rax
   1817f7ccb:	4c 8d 85 90 00 00 00 	lea    r8,[rbp+0x90]
   1817f7cd2:	4c 89 f2             	mov    rdx,r14
   1817f7cd5:	e8 56 e7 17 02       	call   0x183976430
   1817f7cda:	90                   	nop
   1817f7cdb:	41 8b 46 04          	mov    eax,DWORD PTR [r14+0x4]
   1817f7cdf:	41 0b 06             	or     eax,DWORD PTR [r14]
   1817f7ce2:	4c 89 b5 08 02 00 00 	mov    QWORD PTR [rbp+0x208],r14
   1817f7ce9:	0f 84 0e 01 00 00    	je     0x1817f7dfd
   1817f7cef:	b9 04 00 00 00       	mov    ecx,0x4
   1817f7cf4:	e8 e7 50 87 fe       	call   0x18006cde0
   1817f7cf9:	85 c0                	test   eax,eax
   1817f7cfb:	0f 84 5f 06 00 00    	je     0x1817f8360
   1817f7d01:	48 8d b5 c8 01 00 00 	lea    rsi,[rbp+0x1c8]
   1817f7d08:	48 89 f1             	mov    rcx,rsi
   1817f7d0b:	e8 00 52 87 fe       	call   0x18006cf10
   1817f7d10:	90                   	nop
   1817f7d11:	48 83 bd e0 01 00 00 	cmp    QWORD PTR [rbp+0x1e0],0x10
   1817f7d18:	10 
   1817f7d19:	72 07                	jb     0x1817f7d22
   1817f7d1b:	48 8b b5 c8 01 00 00 	mov    rsi,QWORD PTR [rbp+0x1c8]
   1817f7d22:	48 8d 05 4f a5 8e 07 	lea    rax,[rip+0x78ea54f]        # 0x1890e2278
   1817f7d29:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1817f7d2e:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   1817f7d35:	00 00 
   1817f7d37:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   1817f7d3c:	c7 44 24 28 8e 10 00 	mov    DWORD PTR [rsp+0x28],0x108e
   1817f7d43:	00 
   1817f7d44:	4c 8d 0d ad 40 8e 07 	lea    r9,[rip+0x78e40ad]        # 0x1890dbdf8
   1817f7d4b:	48 8d 8d a0 00 00 00 	lea    rcx,[rbp+0xa0]
   1817f7d52:	ba 04 00 00 00       	mov    edx,0x4
   1817f7d57:	49 89 f0             	mov    r8,rsi
   1817f7d5a:	e8 11 55 87 fe       	call   0x18006d270
   1817f7d5f:	90                   	nop
   1817f7d60:	48 8b 85 10 02 00 00 	mov    rax,QWORD PTR [rbp+0x210]
   1817f7d67:	48 8b 08             	mov    rcx,QWORD PTR [rax]
   1817f7d6a:	48 8d b5 e8 01 00 00 	lea    rsi,[rbp+0x1e8]
   1817f7d71:	48 89 f2             	mov    rdx,rsi
   1817f7d74:	e8 57 d9 18 02       	call   0x1839856d0
   1817f7d79:	90                   	nop
   1817f7d7a:	48 83 bd 00 02 00 00 	cmp    QWORD PTR [rbp+0x200],0x10
   1817f7d81:	10 
   1817f7d82:	72 07                	jb     0x1817f7d8b
   1817f7d84:	48 8b b5 e8 01 00 00 	mov    rsi,QWORD PTR [rbp+0x1e8]
   1817f7d8b:	48 89 75 e0          	mov    QWORD PTR [rbp-0x20],rsi
   1817f7d8f:	c6 45 e8 00          	mov    BYTE PTR [rbp-0x18],0x0
   1817f7d93:	0f 57 c0             	xorps  xmm0,xmm0
   1817f7d96:	0f 11 85 a8 01 00 00 	movups XMMWORD PTR [rbp+0x1a8],xmm0
   1817f7d9d:	0f 11 85 98 01 00 00 	movups XMMWORD PTR [rbp+0x198],xmm0
   1817f7da4:	0f 11 85 88 01 00 00 	movups XMMWORD PTR [rbp+0x188],xmm0
   1817f7dab:	0f 11 85 78 01 00 00 	movups XMMWORD PTR [rbp+0x178],xmm0
   1817f7db2:	0f 11 85 68 01 00 00 	movups XMMWORD PTR [rbp+0x168],xmm0
   1817f7db9:	0f 11 85 58 01 00 00 	movups XMMWORD PTR [rbp+0x158],xmm0
   1817f7dc0:	0f 11 85 48 01 00 00 	movups XMMWORD PTR [rbp+0x148],xmm0
   1817f7dc7:	48 c7 85 b8 01 00 00 	mov    QWORD PTR [rbp+0x1b8],0x0
   1817f7dce:	00 00 00 00 
   1817f7dd2:	48 8d 45 e0          	lea    rax,[rbp-0x20]
   1817f7dd6:	48 89 85 40 01 00 00 	mov    QWORD PTR [rbp+0x140],rax
   1817f7ddd:	48 8d 15 3c ec 8e 07 	lea    rdx,[rip+0x78eec3c]        # 0x1890e6a20
   1817f7de4:	48 8d 8d a0 00 00 00 	lea    rcx,[rbp+0xa0]
   1817f7deb:	4c 8d 85 40 01 00 00 	lea    r8,[rbp+0x140]
   1817f7df2:	e8 19 5a 87 fe       	call   0x18006d810
   1817f7df7:	90                   	nop
   1817f7df8:	e9 60 03 00 00       	jmp    0x1817f815d
   1817f7dfd:	48 8b 85 10 02 00 00 	mov    rax,QWORD PTR [rbp+0x210]
   1817f7e04:	48 8b 08             	mov    rcx,QWORD PTR [rax]
   1817f7e07:	ba 06 00 00 00       	mov    edx,0x6
   1817f7e0c:	e8 1f ed 18 02       	call   0x183986b30
   1817f7e11:	90                   	nop
   1817f7e12:	48 8b 85 10 02 00 00 	mov    rax,QWORD PTR [rbp+0x210]
   1817f7e19:	48 8b 08             	mov    rcx,QWORD PTR [rax]
   1817f7e1c:	48 8d 95 a0 00 00 00 	lea    rdx,[rbp+0xa0]
   1817f7e23:	e8 e8 ec 18 02       	call   0x183986b10
   1817f7e28:	90                   	nop
   1817f7e29:	48 8d 95 a0 00 00 00 	lea    rdx,[rbp+0xa0]
   1817f7e30:	48 89 f1             	mov    rcx,rsi
   1817f7e33:	e8 28 8c ff ff       	call   0x1817f0a60
   1817f7e38:	90                   	nop
   1817f7e39:	48 8b 85 b8 00 00 00 	mov    rax,QWORD PTR [rbp+0xb8]
   1817f7e40:	48 83 f8 10          	cmp    rax,0x10
   1817f7e44:	48 8b b5 10 02 00 00 	mov    rsi,QWORD PTR [rbp+0x210]
   1817f7e4b:	72 38                	jb     0x1817f7e85
   1817f7e4d:	48 8b 8d a0 00 00 00 	mov    rcx,QWORD PTR [rbp+0xa0]
   1817f7e54:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1817f7e58:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1817f7e5f:	72 1f                	jb     0x1817f7e80
   1817f7e61:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1817f7e65:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1817f7e69:	4c 29 c1             	sub    rcx,r8
   1817f7e6c:	48 83 f9 20          	cmp    rcx,0x20
   1817f7e70:	0f 83 93 05 00 00    	jae    0x1817f8409
   1817f7e76:	48 83 c0 28          	add    rax,0x28
   1817f7e7a:	48 89 c2             	mov    rdx,rax
   1817f7e7d:	4c 89 c1             	mov    rcx,r8
   1817f7e80:	e8 5b 3a cb 05       	call   0x1874ab8e0
   1817f7e85:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1817f7e88:	48 8b 88 b0 00 00 00 	mov    rcx,QWORD PTR [rax+0xb0]
   1817f7e8f:	48 85 c9             	test   rcx,rcx
   1817f7e92:	74 0d                	je     0x1817f7ea1
   1817f7e94:	f0 ff 41 08          	lock inc DWORD PTR [rcx+0x8]
   1817f7e98:	48 8b 88 b0 00 00 00 	mov    rcx,QWORD PTR [rax+0xb0]
   1817f7e9f:	eb 02                	jmp    0x1817f7ea3
   1817f7ea1:	31 c9                	xor    ecx,ecx
   1817f7ea3:	48 8b 80 a8 00 00 00 	mov    rax,QWORD PTR [rax+0xa8]
   1817f7eaa:	48 89 85 40 01 00 00 	mov    QWORD PTR [rbp+0x140],rax
   1817f7eb1:	48 89 8d 48 01 00 00 	mov    QWORD PTR [rbp+0x148],rcx
   1817f7eb8:	48 8d 75 e0          	lea    rsi,[rbp-0x20]
   1817f7ebc:	48 8d 9d a0 00 00 00 	lea    rbx,[rbp+0xa0]
   1817f7ec3:	48 8d bd 40 01 00 00 	lea    rdi,[rbp+0x140]
   1817f7eca:	48 89 f1             	mov    rcx,rsi
   1817f7ecd:	48 89 da             	mov    rdx,rbx
   1817f7ed0:	49 89 f8             	mov    r8,rdi
   1817f7ed3:	e8 b8 4c fa ff       	call   0x18179cb90
   1817f7ed8:	90                   	nop
   1817f7ed9:	48 8b 85 a0 00 00 00 	mov    rax,QWORD PTR [rbp+0xa0]
   1817f7ee0:	48 8b 8d 08 02 00 00 	mov    rcx,QWORD PTR [rbp+0x208]
   1817f7ee7:	48 89 01             	mov    QWORD PTR [rcx],rax
   1817f7eea:	48 39 d9             	cmp    rcx,rbx
   1817f7eed:	74 41                	je     0x1817f7f30
   1817f7eef:	48 8b 9d b8 00 00 00 	mov    rbx,QWORD PTR [rbp+0xb8]
   1817f7ef6:	48 83 bd c0 00 00 00 	cmp    QWORD PTR [rbp+0xc0],0x10
   1817f7efd:	10 
   1817f7efe:	72 09                	jb     0x1817f7f09
   1817f7f00:	4c 8b 8d a8 00 00 00 	mov    r9,QWORD PTR [rbp+0xa8]
   1817f7f07:	eb 07                	jmp    0x1817f7f10
   1817f7f09:	4c 8d 8d a8 00 00 00 	lea    r9,[rbp+0xa8]
   1817f7f10:	48 8b 8d 08 02 00 00 	mov    rcx,QWORD PTR [rbp+0x208]
   1817f7f17:	4c 8d 71 08          	lea    r14,[rcx+0x8]
   1817f7f1b:	48 8b 41 20          	mov    rax,QWORD PTR [rcx+0x20]
   1817f7f1f:	48 39 c3             	cmp    rbx,rax
   1817f7f22:	76 25                	jbe    0x1817f7f49
   1817f7f24:	4c 89 f1             	mov    rcx,r14
   1817f7f27:	48 89 da             	mov    rdx,rbx
   1817f7f2a:	e8 21 62 84 fe       	call   0x18003e150
   1817f7f2f:	90                   	nop
   1817f7f30:	48 8b 85 d0 00 00 00 	mov    rax,QWORD PTR [rbp+0xd0]
   1817f7f37:	48 85 c0             	test   rax,rax
   1817f7f3a:	74 3a                	je     0x1817f7f76
   1817f7f3c:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   1817f7f40:	48 8b 85 d0 00 00 00 	mov    rax,QWORD PTR [rbp+0xd0]
   1817f7f47:	eb 2f                	jmp    0x1817f7f78
   1817f7f49:	48 83 f8 10          	cmp    rax,0x10
   1817f7f4d:	72 04                	jb     0x1817f7f53
   1817f7f4f:	4c 8b 71 08          	mov    r14,QWORD PTR [rcx+0x8]
   1817f7f53:	48 89 59 18          	mov    QWORD PTR [rcx+0x18],rbx
   1817f7f57:	4c 89 f1             	mov    rcx,r14
   1817f7f5a:	4c 89 ca             	mov    rdx,r9
   1817f7f5d:	49 89 d8             	mov    r8,rbx
   1817f7f60:	e8 eb c0 d4 05       	call   0x187544050
   1817f7f65:	41 c6 04 1e 00       	mov    BYTE PTR [r14+rbx*1],0x0
   1817f7f6a:	48 8b 85 d0 00 00 00 	mov    rax,QWORD PTR [rbp+0xd0]
   1817f7f71:	48 85 c0             	test   rax,rax
   1817f7f74:	75 c6                	jne    0x1817f7f3c
   1817f7f76:	31 c0                	xor    eax,eax
   1817f7f78:	4c 8b b5 08 02 00 00 	mov    r14,QWORD PTR [rbp+0x208]
   1817f7f7f:	48 8b 8d c8 00 00 00 	mov    rcx,QWORD PTR [rbp+0xc8]
   1817f7f86:	49 89 4e 28          	mov    QWORD PTR [r14+0x28],rcx
   1817f7f8a:	49 8b 5e 30          	mov    rbx,QWORD PTR [r14+0x30]
   1817f7f8e:	49 89 46 30          	mov    QWORD PTR [r14+0x30],rax
   1817f7f92:	48 85 db             	test   rbx,rbx
   1817f7f95:	74 1d                	je     0x1817f7fb4
   1817f7f97:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   1817f7f9b:	75 17                	jne    0x1817f7fb4
   1817f7f9d:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1817f7fa0:	48 89 d9             	mov    rcx,rbx
   1817f7fa3:	ff 10                	call   QWORD PTR [rax]
   1817f7fa5:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   1817f7fa9:	75 09                	jne    0x1817f7fb4
   1817f7fab:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1817f7fae:	48 89 d9             	mov    rcx,rbx
   1817f7fb1:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1817f7fb4:	48 8b 9d d0 00 00 00 	mov    rbx,QWORD PTR [rbp+0xd0]
   1817f7fbb:	48 85 db             	test   rbx,rbx
   1817f7fbe:	74 1d                	je     0x1817f7fdd
   1817f7fc0:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   1817f7fc4:	75 17                	jne    0x1817f7fdd
   1817f7fc6:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1817f7fc9:	48 89 d9             	mov    rcx,rbx
   1817f7fcc:	ff 10                	call   QWORD PTR [rax]
   1817f7fce:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   1817f7fd2:	75 09                	jne    0x1817f7fdd
   1817f7fd4:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1817f7fd7:	48 89 d9             	mov    rcx,rbx
   1817f7fda:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1817f7fdd:	48 8b 85 c0 00 00 00 	mov    rax,QWORD PTR [rbp+0xc0]
   1817f7fe4:	48 83 f8 10          	cmp    rax,0x10
   1817f7fe8:	72 38                	jb     0x1817f8022
   1817f7fea:	48 8b 8d a8 00 00 00 	mov    rcx,QWORD PTR [rbp+0xa8]
   1817f7ff1:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1817f7ff5:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1817f7ffc:	72 1f                	jb     0x1817f801d
   1817f7ffe:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1817f8002:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1817f8006:	4c 29 c1             	sub    rcx,r8
   1817f8009:	48 83 f9 20          	cmp    rcx,0x20
   1817f800d:	0f 83 f6 03 00 00    	jae    0x1817f8409
   1817f8013:	48 83 c0 28          	add    rax,0x28
   1817f8017:	48 89 c2             	mov    rdx,rax
   1817f801a:	4c 89 c1             	mov    rcx,r8
   1817f801d:	e8 be 38 cb 05       	call   0x1874ab8e0
   1817f8022:	48 8b 9d 48 01 00 00 	mov    rbx,QWORD PTR [rbp+0x148]
   1817f8029:	48 85 db             	test   rbx,rbx
   1817f802c:	74 1d                	je     0x1817f804b
   1817f802e:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   1817f8032:	75 17                	jne    0x1817f804b
   1817f8034:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1817f8037:	48 89 d9             	mov    rcx,rbx
   1817f803a:	ff 10                	call   QWORD PTR [rax]
   1817f803c:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   1817f8040:	75 09                	jne    0x1817f804b
   1817f8042:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1817f8045:	48 89 d9             	mov    rcx,rbx
   1817f8048:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1817f804b:	41 8b 46 04          	mov    eax,DWORD PTR [r14+0x4]
   1817f804f:	41 0b 06             	or     eax,DWORD PTR [r14]
   1817f8052:	0f 84 8b 01 00 00    	je     0x1817f81e3
   1817f8058:	b9 04 00 00 00       	mov    ecx,0x4
   1817f805d:	e8 7e 4d 87 fe       	call   0x18006cde0
   1817f8062:	85 c0                	test   eax,eax
   1817f8064:	0f 84 f6 02 00 00    	je     0x1817f8360
   1817f806a:	48 8d bd c8 01 00 00 	lea    rdi,[rbp+0x1c8]
   1817f8071:	48 89 f9             	mov    rcx,rdi
   1817f8074:	e8 97 4e 87 fe       	call   0x18006cf10
   1817f8079:	90                   	nop
   1817f807a:	48 83 bd e0 01 00 00 	cmp    QWORD PTR [rbp+0x1e0],0x10
   1817f8081:	10 
   1817f8082:	72 07                	jb     0x1817f808b
   1817f8084:	48 8b bd c8 01 00 00 	mov    rdi,QWORD PTR [rbp+0x1c8]
   1817f808b:	48 8d 05 e6 a1 8e 07 	lea    rax,[rip+0x78ea1e6]        # 0x1890e2278
   1817f8092:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1817f8097:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   1817f809e:	00 00 
   1817f80a0:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   1817f80a5:	c7 44 24 28 98 10 00 	mov    DWORD PTR [rsp+0x28],0x1098
   1817f80ac:	00 
   1817f80ad:	4c 8d 0d 44 3d 8e 07 	lea    r9,[rip+0x78e3d44]        # 0x1890dbdf8
   1817f80b4:	48 8d 8d a0 00 00 00 	lea    rcx,[rbp+0xa0]
   1817f80bb:	ba 04 00 00 00       	mov    edx,0x4
   1817f80c0:	49 89 f8             	mov    r8,rdi
   1817f80c3:	e8 a8 51 87 fe       	call   0x18006d270
   1817f80c8:	90                   	nop
   1817f80c9:	48 8b 85 10 02 00 00 	mov    rax,QWORD PTR [rbp+0x210]
   1817f80d0:	48 8b 08             	mov    rcx,QWORD PTR [rax]
   1817f80d3:	48 8d bd e8 01 00 00 	lea    rdi,[rbp+0x1e8]
   1817f80da:	48 89 fa             	mov    rdx,rdi
   1817f80dd:	e8 ee d5 18 02       	call   0x1839856d0
   1817f80e2:	90                   	nop
   1817f80e3:	48 83 bd 00 02 00 00 	cmp    QWORD PTR [rbp+0x200],0x10
   1817f80ea:	10 
   1817f80eb:	72 07                	jb     0x1817f80f4
   1817f80ed:	48 8b bd e8 01 00 00 	mov    rdi,QWORD PTR [rbp+0x1e8]
   1817f80f4:	48 89 7d e0          	mov    QWORD PTR [rbp-0x20],rdi
   1817f80f8:	c6 45 e8 00          	mov    BYTE PTR [rbp-0x18],0x0
   1817f80fc:	0f 57 c0             	xorps  xmm0,xmm0
   1817f80ff:	0f 11 85 a8 01 00 00 	movups XMMWORD PTR [rbp+0x1a8],xmm0
   1817f8106:	0f 11 85 98 01 00 00 	movups XMMWORD PTR [rbp+0x198],xmm0
   1817f810d:	0f 11 85 88 01 00 00 	movups XMMWORD PTR [rbp+0x188],xmm0
   1817f8114:	0f 11 85 78 01 00 00 	movups XMMWORD PTR [rbp+0x178],xmm0
   1817f811b:	0f 11 85 68 01 00 00 	movups XMMWORD PTR [rbp+0x168],xmm0
   1817f8122:	0f 11 85 58 01 00 00 	movups XMMWORD PTR [rbp+0x158],xmm0
   1817f8129:	0f 11 85 48 01 00 00 	movups XMMWORD PTR [rbp+0x148],xmm0
   1817f8130:	48 c7 85 b8 01 00 00 	mov    QWORD PTR [rbp+0x1b8],0x0
   1817f8137:	00 00 00 00 
   1817f813b:	48 89 b5 40 01 00 00 	mov    QWORD PTR [rbp+0x140],rsi
   1817f8142:	48 8d 15 3f e9 8e 07 	lea    rdx,[rip+0x78ee93f]        # 0x1890e6a88
   1817f8149:	48 8d 8d a0 00 00 00 	lea    rcx,[rbp+0xa0]
   1817f8150:	4c 8d 85 40 01 00 00 	lea    r8,[rbp+0x140]
   1817f8157:	e8 b4 56 87 fe       	call   0x18006d810
   1817f815c:	90                   	nop
   1817f815d:	48 8b 85 00 02 00 00 	mov    rax,QWORD PTR [rbp+0x200]
   1817f8164:	48 83 f8 10          	cmp    rax,0x10
   1817f8168:	4c 8b b5 08 02 00 00 	mov    r14,QWORD PTR [rbp+0x208]
   1817f816f:	72 38                	jb     0x1817f81a9
   1817f8171:	48 8b 8d e8 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1e8]
   1817f8178:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1817f817c:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1817f8183:	72 1f                	jb     0x1817f81a4
   1817f8185:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1817f8189:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1817f818d:	4c 29 c1             	sub    rcx,r8
   1817f8190:	48 83 f9 20          	cmp    rcx,0x20
   1817f8194:	0f 83 6f 02 00 00    	jae    0x1817f8409
   1817f819a:	48 83 c0 28          	add    rax,0x28
   1817f819e:	48 89 c2             	mov    rdx,rax
   1817f81a1:	4c 89 c1             	mov    rcx,r8
   1817f81a4:	e8 37 37 cb 05       	call   0x1874ab8e0
   1817f81a9:	48 8d 8d a0 00 00 00 	lea    rcx,[rbp+0xa0]
   1817f81b0:	e8 bb 51 87 fe       	call   0x18006d370
   1817f81b5:	48 8b 85 e0 01 00 00 	mov    rax,QWORD PTR [rbp+0x1e0]
   1817f81bc:	48 83 f8 10          	cmp    rax,0x10
   1817f81c0:	0f 82 9a 01 00 00    	jb     0x1817f8360
   1817f81c6:	48 8b 8d c8 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1c8]
   1817f81cd:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1817f81d1:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1817f81d8:	0f 82 7d 01 00 00    	jb     0x1817f835b
   1817f81de:	e9 59 01 00 00       	jmp    0x1817f833c
   1817f81e3:	48 8b 85 10 02 00 00 	mov    rax,QWORD PTR [rbp+0x210]
   1817f81ea:	48 8b 08             	mov    rcx,QWORD PTR [rax]
   1817f81ed:	48 8d b5 a0 00 00 00 	lea    rsi,[rbp+0xa0]
   1817f81f4:	48 89 f2             	mov    rdx,rsi
   1817f81f7:	e8 d4 d4 18 02       	call   0x1839856d0
   1817f81fc:	90                   	nop
   1817f81fd:	48 c7 85 48 01 00 00 	mov    QWORD PTR [rbp+0x148],0x0
   1817f8204:	00 00 00 00 
   1817f8208:	48 c7 85 50 01 00 00 	mov    QWORD PTR [rbp+0x150],0xb
   1817f820f:	0b 00 00 00 
   1817f8213:	48 c7 85 58 01 00 00 	mov    QWORD PTR [rbp+0x158],0xf
   1817f821a:	0f 00 00 00 
   1817f821e:	48 b8 73 65 6e 64 20 	movabs rax,0x6e696620646e6573
   1817f8225:	66 69 6e 
   1817f8228:	48 89 85 40 01 00 00 	mov    QWORD PTR [rbp+0x140],rax
   1817f822f:	c7 85 47 01 00 00 6e 	mov    DWORD PTR [rbp+0x147],0x6873696e
   1817f8236:	69 73 68 
   1817f8239:	48 8b 9d b0 00 00 00 	mov    rbx,QWORD PTR [rbp+0xb0]
   1817f8240:	48 83 bd b8 00 00 00 	cmp    QWORD PTR [rbp+0xb8],0x10
   1817f8247:	10 
   1817f8248:	72 07                	jb     0x1817f8251
   1817f824a:	48 8b b5 a0 00 00 00 	mov    rsi,QWORD PTR [rbp+0xa0]
   1817f8251:	48 83 fb 04          	cmp    rbx,0x4
   1817f8255:	76 1d                	jbe    0x1817f8274
   1817f8257:	48 89 5c 24 20       	mov    QWORD PTR [rsp+0x20],rbx
   1817f825c:	48 8d 8d 40 01 00 00 	lea    rcx,[rbp+0x140]
   1817f8263:	48 89 da             	mov    rdx,rbx
   1817f8266:	49 89 f1             	mov    r9,rsi
   1817f8269:	e8 52 11 81 fe       	call   0x1800093c0
   1817f826e:	90                   	nop
   1817f826f:	48 89 c7             	mov    rdi,rax
   1817f8272:	eb 25                	jmp    0x1817f8299
   1817f8274:	48 8d 8d 4b 01 00 00 	lea    rcx,[rbp+0x14b]
   1817f827b:	48 8d 43 0b          	lea    rax,[rbx+0xb]
   1817f827f:	48 89 85 50 01 00 00 	mov    QWORD PTR [rbp+0x150],rax
   1817f8286:	48 89 f2             	mov    rdx,rsi
   1817f8289:	49 89 d8             	mov    r8,rbx
   1817f828c:	e8 bf bd d4 05       	call   0x187544050
   1817f8291:	c6 84 1d 4b 01 00 00 	mov    BYTE PTR [rbp+rbx*1+0x14b],0x0
   1817f8298:	00 
   1817f8299:	0f 10 07             	movups xmm0,XMMWORD PTR [rdi]
   1817f829c:	0f 10 4f 10          	movups xmm1,XMMWORD PTR [rdi+0x10]
   1817f82a0:	0f 29 4d d0          	movaps XMMWORD PTR [rbp-0x30],xmm1
   1817f82a4:	0f 29 45 c0          	movaps XMMWORD PTR [rbp-0x40],xmm0
   1817f82a8:	48 c7 47 10 00 00 00 	mov    QWORD PTR [rdi+0x10],0x0
   1817f82af:	00 
   1817f82b0:	48 c7 47 18 0f 00 00 	mov    QWORD PTR [rdi+0x18],0xf
   1817f82b7:	00 
   1817f82b8:	c6 07 00             	mov    BYTE PTR [rdi],0x0
   1817f82bb:	48 8d 4d 30          	lea    rcx,[rbp+0x30]
   1817f82bf:	48 8d 55 c0          	lea    rdx,[rbp-0x40]
   1817f82c3:	41 b8 32 00 00 00    	mov    r8d,0x32
   1817f82c9:	e8 22 ce 7c ff       	call   0x180fc50f0
   1817f82ce:	90                   	nop
   1817f82cf:	48 8b 85 58 01 00 00 	mov    rax,QWORD PTR [rbp+0x158]
   1817f82d6:	48 83 f8 10          	cmp    rax,0x10
   1817f82da:	4c 8b b5 08 02 00 00 	mov    r14,QWORD PTR [rbp+0x208]
   1817f82e1:	72 38                	jb     0x1817f831b
   1817f82e3:	48 8b 8d 40 01 00 00 	mov    rcx,QWORD PTR [rbp+0x140]
   1817f82ea:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1817f82ee:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1817f82f5:	72 1f                	jb     0x1817f8316
   1817f82f7:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1817f82fb:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1817f82ff:	4c 29 c1             	sub    rcx,r8
   1817f8302:	48 83 f9 20          	cmp    rcx,0x20
   1817f8306:	0f 83 fd 00 00 00    	jae    0x1817f8409
   1817f830c:	48 83 c0 28          	add    rax,0x28
   1817f8310:	48 89 c2             	mov    rdx,rax
   1817f8313:	4c 89 c1             	mov    rcx,r8
   1817f8316:	e8 c5 35 cb 05       	call   0x1874ab8e0
   1817f831b:	48 8b 85 b8 00 00 00 	mov    rax,QWORD PTR [rbp+0xb8]
   1817f8322:	48 83 f8 10          	cmp    rax,0x10
   1817f8326:	72 38                	jb     0x1817f8360
   1817f8328:	48 8b 8d a0 00 00 00 	mov    rcx,QWORD PTR [rbp+0xa0]
   1817f832f:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1817f8333:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1817f833a:	72 1f                	jb     0x1817f835b
   1817f833c:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1817f8340:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1817f8344:	4c 29 c1             	sub    rcx,r8
   1817f8347:	48 83 f9 20          	cmp    rcx,0x20
   1817f834b:	0f 83 b8 00 00 00    	jae    0x1817f8409
   1817f8351:	48 83 c0 28          	add    rax,0x28
   1817f8355:	48 89 c2             	mov    rdx,rax
   1817f8358:	4c 89 c1             	mov    rcx,r8
   1817f835b:	e8 80 35 cb 05       	call   0x1874ab8e0
   1817f8360:	48 8b b5 38 01 00 00 	mov    rsi,QWORD PTR [rbp+0x138]
   1817f8367:	48 85 f6             	test   rsi,rsi
   1817f836a:	74 1d                	je     0x1817f8389
   1817f836c:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   1817f8370:	75 17                	jne    0x1817f8389
   1817f8372:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1817f8375:	48 89 f1             	mov    rcx,rsi
   1817f8378:	ff 10                	call   QWORD PTR [rax]
   1817f837a:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   1817f837e:	75 09                	jne    0x1817f8389
   1817f8380:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1817f8383:	48 89 f1             	mov    rcx,rsi
   1817f8386:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1817f8389:	48 8b 45 70          	mov    rax,QWORD PTR [rbp+0x70]
   1817f838d:	48 83 f8 10          	cmp    rax,0x10
   1817f8391:	48 8b b5 10 02 00 00 	mov    rsi,QWORD PTR [rbp+0x210]
   1817f8398:	72 31                	jb     0x1817f83cb
   1817f839a:	48 8b 4d 58          	mov    rcx,QWORD PTR [rbp+0x58]
   1817f839e:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1817f83a2:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1817f83a9:	72 1b                	jb     0x1817f83c6
   1817f83ab:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1817f83af:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1817f83b3:	4c 29 c1             	sub    rcx,r8
   1817f83b6:	48 83 f9 20          	cmp    rcx,0x20
   1817f83ba:	73 4d                	jae    0x1817f8409
   1817f83bc:	48 83 c0 28          	add    rax,0x28
   1817f83c0:	48 89 c2             	mov    rdx,rax
   1817f83c3:	4c 89 c1             	mov    rcx,r8
   1817f83c6:	e8 15 35 cb 05       	call   0x1874ab8e0
   1817f83cb:	48 8b 76 08          	mov    rsi,QWORD PTR [rsi+0x8]
   1817f83cf:	48 85 f6             	test   rsi,rsi
   1817f83d2:	74 1d                	je     0x1817f83f1
   1817f83d4:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   1817f83d8:	75 17                	jne    0x1817f83f1
   1817f83da:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1817f83dd:	48 89 f1             	mov    rcx,rsi
   1817f83e0:	ff 10                	call   QWORD PTR [rax]
   1817f83e2:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   1817f83e6:	75 09                	jne    0x1817f83f1
   1817f83e8:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1817f83eb:	48 89 f1             	mov    rcx,rsi
   1817f83ee:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1817f83f1:	4c 89 f0             	mov    rax,r14
   1817f83f4:	0f 28 b5 20 02 00 00 	movaps xmm6,XMMWORD PTR [rbp+0x220]
   1817f83fb:	48 81 c4 b0 02 00 00 	add    rsp,0x2b0
   1817f8402:	5b                   	pop    rbx
   1817f8403:	5f                   	pop    rdi
   1817f8404:	5e                   	pop    rsi
   1817f8405:	41 5e                	pop    r14
   1817f8407:	5d                   	pop    rbp
   1817f8408:	c3                   	ret
   1817f8409:	e8 7e 4f d1 05       	call   0x18750d38c
   1817f840e:	cc                   	int3
