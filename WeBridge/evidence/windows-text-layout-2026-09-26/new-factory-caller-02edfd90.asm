
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000182edfd90 <.text+0x2eded90>:
   182edfd90:	55                   	push   rbp
   182edfd91:	56                   	push   rsi
   182edfd92:	57                   	push   rdi
   182edfd93:	53                   	push   rbx
   182edfd94:	48 81 ec 78 04 00 00 	sub    rsp,0x478
   182edfd9b:	48 8d ac 24 80 00 00 	lea    rbp,[rsp+0x80]
   182edfda2:	00 
   182edfda3:	48 c7 85 f0 03 00 00 	mov    QWORD PTR [rbp+0x3f0],0xfffffffffffffffe
   182edfdaa:	fe ff ff ff 
   182edfdae:	48 89 d6             	mov    rsi,rdx
   182edfdb1:	48 89 cf             	mov    rdi,rcx
   182edfdb4:	80 b9 08 07 00 00 01 	cmp    BYTE PTR [rcx+0x708],0x1
   182edfdbb:	75 53                	jne    0x182edfe10
   182edfdbd:	48 81 c7 20 04 00 00 	add    rdi,0x420
   182edfdc4:	0f 28 05 e5 5d e6 05 	movaps xmm0,XMMWORD PTR [rip+0x5e65de5]        # 0x188d45bb0
   182edfdcb:	0f 29 85 e0 03 00 00 	movaps XMMWORD PTR [rbp+0x3e0],xmm0
   182edfdd2:	48 8d 8d e0 03 00 00 	lea    rcx,[rbp+0x3e0]
   182edfdd9:	e8 82 f4 34 ff       	call   0x18222f260
   182edfdde:	90                   	nop
   182edfddf:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   182edfde3:	48 89 f9             	mov    rcx,rdi
   182edfde6:	e8 e5 8f b7 fd       	call   0x180a58dd0
   182edfdeb:	90                   	nop
   182edfdec:	b9 18 01 00 00       	mov    ecx,0x118
   182edfdf1:	48 03 8d e0 03 00 00 	add    rcx,QWORD PTR [rbp+0x3e0]
   182edfdf8:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   182edfdfc:	e8 0f d2 b4 fd       	call   0x180a2d010
   182edfe01:	90                   	nop
   182edfe02:	48 8d 4d a0          	lea    rcx,[rbp-0x60]
   182edfe06:	e8 35 f0 2c fd       	call   0x1801aee40
   182edfe0b:	e9 e1 00 00 00       	jmp    0x182edfef1
   182edfe10:	0f 28 05 99 5d e6 05 	movaps xmm0,XMMWORD PTR [rip+0x5e65d99]        # 0x188d45bb0
   182edfe17:	0f 29 85 e0 03 00 00 	movaps XMMWORD PTR [rbp+0x3e0],xmm0
   182edfe1e:	48 8d 8d e0 03 00 00 	lea    rcx,[rbp+0x3e0]
   182edfe25:	e8 46 4e 81 fd       	call   0x1806f4c70
   182edfe2a:	48 8b 85 e0 03 00 00 	mov    rax,QWORD PTR [rbp+0x3e0]
   182edfe31:	c7 80 18 01 00 00 01 	mov    DWORD PTR [rax+0x118],0x1
   182edfe38:	00 00 00 
   182edfe3b:	48 81 c7 a0 03 00 00 	add    rdi,0x3a0
   182edfe42:	48 8d 5d a0          	lea    rbx,[rbp-0x60]
   182edfe46:	48 89 f9             	mov    rcx,rdi
   182edfe49:	48 89 da             	mov    rdx,rbx
   182edfe4c:	41 b0 01             	mov    r8b,0x1
   182edfe4f:	e8 2c a1 3b ff       	call   0x182299f80
   182edfe54:	90                   	nop
   182edfe55:	48 8b 85 e0 03 00 00 	mov    rax,QWORD PTR [rbp+0x3e0]
   182edfe5c:	48 8d b8 58 07 00 00 	lea    rdi,[rax+0x758]
   182edfe63:	48 39 df             	cmp    rdi,rbx
   182edfe66:	74 4e                	je     0x182edfeb6
   182edfe68:	48 8b 80 70 07 00 00 	mov    rax,QWORD PTR [rax+0x770]
   182edfe6f:	48 83 f8 10          	cmp    rax,0x10
   182edfe73:	72 30                	jb     0x182edfea5
   182edfe75:	48 8b 0f             	mov    rcx,QWORD PTR [rdi]
   182edfe78:	48 8d 50 01          	lea    rdx,[rax+0x1]
   182edfe7c:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   182edfe83:	72 1b                	jb     0x182edfea0
   182edfe85:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   182edfe89:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   182edfe8d:	4c 29 c1             	sub    rcx,r8
   182edfe90:	48 83 f9 20          	cmp    rcx,0x20
   182edfe94:	73 74                	jae    0x182edff0a
   182edfe96:	48 83 c0 28          	add    rax,0x28
   182edfe9a:	48 89 c2             	mov    rdx,rax
   182edfe9d:	4c 89 c1             	mov    rcx,r8
   182edfea0:	e8 3b ba 5c 04       	call   0x1874ab8e0
   182edfea5:	0f 10 45 a0          	movups xmm0,XMMWORD PTR [rbp-0x60]
   182edfea9:	0f 10 4d b0          	movups xmm1,XMMWORD PTR [rbp-0x50]
   182edfead:	0f 11 4f 10          	movups XMMWORD PTR [rdi+0x10],xmm1
   182edfeb1:	0f 11 07             	movups XMMWORD PTR [rdi],xmm0
   182edfeb4:	eb 3b                	jmp    0x182edfef1
   182edfeb6:	48 8b 45 b8          	mov    rax,QWORD PTR [rbp-0x48]
   182edfeba:	48 83 f8 10          	cmp    rax,0x10
   182edfebe:	72 31                	jb     0x182edfef1
   182edfec0:	48 8b 4d a0          	mov    rcx,QWORD PTR [rbp-0x60]
   182edfec4:	48 8d 50 01          	lea    rdx,[rax+0x1]
   182edfec8:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   182edfecf:	72 1b                	jb     0x182edfeec
   182edfed1:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   182edfed5:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   182edfed9:	4c 29 c1             	sub    rcx,r8
   182edfedc:	48 83 f9 20          	cmp    rcx,0x20
   182edfee0:	73 28                	jae    0x182edff0a
   182edfee2:	48 83 c0 28          	add    rax,0x28
   182edfee6:	48 89 c2             	mov    rdx,rax
   182edfee9:	4c 89 c1             	mov    rcx,r8
   182edfeec:	e8 ef b9 5c 04       	call   0x1874ab8e0
   182edfef1:	0f 28 85 e0 03 00 00 	movaps xmm0,XMMWORD PTR [rbp+0x3e0]
   182edfef8:	0f 11 06             	movups XMMWORD PTR [rsi],xmm0
   182edfefb:	48 89 f0             	mov    rax,rsi
   182edfefe:	48 81 c4 78 04 00 00 	add    rsp,0x478
   182edff05:	5b                   	pop    rbx
   182edff06:	5f                   	pop    rdi
   182edff07:	5e                   	pop    rsi
   182edff08:	5d                   	pop    rbp
   182edff09:	c3                   	ret
   182edff0a:	e8 7d d4 62 04       	call   0x18750d38c
   182edff0f:	cc                   	int3
