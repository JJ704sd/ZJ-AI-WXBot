
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000185c7e920 <.text+0x5c7d920>:
   185c7e920:	55                   	push   rbp
   185c7e921:	41 56                	push   r14
   185c7e923:	56                   	push   rsi
   185c7e924:	57                   	push   rdi
   185c7e925:	53                   	push   rbx
   185c7e926:	48 81 ec d0 02 00 00 	sub    rsp,0x2d0
   185c7e92d:	48 8d ac 24 80 00 00 	lea    rbp,[rsp+0x80]
   185c7e934:	00 
   185c7e935:	0f 29 b5 40 02 00 00 	movaps XMMWORD PTR [rbp+0x240],xmm6
   185c7e93c:	48 c7 85 38 02 00 00 	mov    QWORD PTR [rbp+0x238],0xfffffffffffffffe
   185c7e943:	fe ff ff ff 
   185c7e947:	48 83 b9 88 01 00 00 	cmp    QWORD PTR [rcx+0x188],0x0
   185c7e94e:	00 
   185c7e94f:	74 35                	je     0x185c7e986
   185c7e951:	48 89 ce             	mov    rsi,rcx
   185c7e954:	48 b8 aa aa aa aa aa 	movabs rax,0xaaaaaaaaaaaaaaaa
   185c7e95b:	aa aa aa 
   185c7e95e:	48 89 85 28 02 00 00 	mov    QWORD PTR [rbp+0x228],rax
   185c7e965:	44 8b 81 a8 01 00 00 	mov    r8d,DWORD PTR [rcx+0x1a8]
   185c7e96c:	48 83 b9 b0 01 00 00 	cmp    QWORD PTR [rcx+0x1b0],0x10
   185c7e973:	10 
   185c7e974:	0f 82 2c 01 00 00    	jb     0x185c7eaa6
   185c7e97a:	48 8b be 98 01 00 00 	mov    rdi,QWORD PTR [rsi+0x198]
   185c7e981:	e9 27 01 00 00       	jmp    0x185c7eaad
   185c7e986:	b9 04 00 00 00       	mov    ecx,0x4
   185c7e98b:	e8 50 e4 3e fa       	call   0x18006cde0
   185c7e990:	85 c0                	test   eax,eax
   185c7e992:	0f 84 1d 07 00 00    	je     0x185c7f0b5
   185c7e998:	48 8d b5 f0 01 00 00 	lea    rsi,[rbp+0x1f0]
   185c7e99f:	48 89 f1             	mov    rcx,rsi
   185c7e9a2:	e8 69 e5 3e fa       	call   0x18006cf10
   185c7e9a7:	48 83 bd 08 02 00 00 	cmp    QWORD PTR [rbp+0x208],0x10
   185c7e9ae:	10 
   185c7e9af:	72 07                	jb     0x185c7e9b8
   185c7e9b1:	48 8b b5 f0 01 00 00 	mov    rsi,QWORD PTR [rbp+0x1f0]
   185c7e9b8:	48 8d 05 79 d6 c7 03 	lea    rax,[rip+0x3c7d679]        # 0x1898fc038
   185c7e9bf:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   185c7e9c4:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   185c7e9cb:	00 00 
   185c7e9cd:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   185c7e9d2:	c7 44 24 28 7c 00 00 	mov    DWORD PTR [rsp+0x28],0x7c
   185c7e9d9:	00 
   185c7e9da:	4c 8d 0d 5f d4 c7 03 	lea    r9,[rip+0x3c7d45f]        # 0x1898fbe40
   185c7e9e1:	48 8d 8d 30 01 00 00 	lea    rcx,[rbp+0x130]
   185c7e9e8:	ba 04 00 00 00       	mov    edx,0x4
   185c7e9ed:	49 89 f0             	mov    r8,rsi
   185c7e9f0:	e8 7b e8 3e fa       	call   0x18006d270
   185c7e9f5:	90                   	nop
   185c7e9f6:	0f 57 c0             	xorps  xmm0,xmm0
   185c7e9f9:	0f 29 85 20 01 00 00 	movaps XMMWORD PTR [rbp+0x120],xmm0
   185c7ea00:	0f 29 85 10 01 00 00 	movaps XMMWORD PTR [rbp+0x110],xmm0
   185c7ea07:	0f 29 85 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm0
   185c7ea0e:	0f 29 85 f0 00 00 00 	movaps XMMWORD PTR [rbp+0xf0],xmm0
   185c7ea15:	0f 29 85 e0 00 00 00 	movaps XMMWORD PTR [rbp+0xe0],xmm0
   185c7ea1c:	0f 29 85 d0 00 00 00 	movaps XMMWORD PTR [rbp+0xd0],xmm0
   185c7ea23:	0f 29 85 c0 00 00 00 	movaps XMMWORD PTR [rbp+0xc0],xmm0
   185c7ea2a:	0f 29 85 b0 00 00 00 	movaps XMMWORD PTR [rbp+0xb0],xmm0
   185c7ea31:	48 8d 15 58 d6 c7 03 	lea    rdx,[rip+0x3c7d658]        # 0x1898fc090
   185c7ea38:	48 8d 8d 30 01 00 00 	lea    rcx,[rbp+0x130]
   185c7ea3f:	4c 8d 85 b0 00 00 00 	lea    r8,[rbp+0xb0]
   185c7ea46:	e8 c5 ed 3e fa       	call   0x18006d810
   185c7ea4b:	90                   	nop
   185c7ea4c:	48 8d 8d 30 01 00 00 	lea    rcx,[rbp+0x130]
   185c7ea53:	e8 18 e9 3e fa       	call   0x18006d370
   185c7ea58:	48 8b 85 08 02 00 00 	mov    rax,QWORD PTR [rbp+0x208]
   185c7ea5f:	48 83 f8 10          	cmp    rax,0x10
   185c7ea63:	0f 82 4c 06 00 00    	jb     0x185c7f0b5
   185c7ea69:	48 8b 8d f0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1f0]
   185c7ea70:	48 8d 50 01          	lea    rdx,[rax+0x1]
   185c7ea74:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185c7ea7b:	72 1f                	jb     0x185c7ea9c
   185c7ea7d:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   185c7ea81:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   185c7ea85:	4c 29 c1             	sub    rcx,r8
   185c7ea88:	48 83 f9 20          	cmp    rcx,0x20
   185c7ea8c:	0f 83 38 06 00 00    	jae    0x185c7f0ca
   185c7ea92:	48 83 c0 28          	add    rax,0x28
   185c7ea96:	48 89 c2             	mov    rdx,rax
   185c7ea99:	4c 89 c1             	mov    rcx,r8
   185c7ea9c:	e8 3f ce 82 01       	call   0x1874ab8e0
   185c7eaa1:	e9 0f 06 00 00       	jmp    0x185c7f0b5
   185c7eaa6:	48 8d be 98 01 00 00 	lea    rdi,[rsi+0x198]
   185c7eaad:	48 85 ff             	test   rdi,rdi
   185c7eab0:	0f 94 c0             	sete   al
   185c7eab3:	41 83 f8 ff          	cmp    r8d,0xffffffff
   185c7eab7:	0f 95 c1             	setne  cl
   185c7eaba:	08 c1                	or     cl,al
   185c7eabc:	75 0b                	jne    0x185c7eac9
   185c7eabe:	48 89 f9             	mov    rcx,rdi
   185c7eac1:	e8 da 5a 8a 01       	call   0x1875245a0
   185c7eac6:	49 89 c0             	mov    r8,rax
   185c7eac9:	48 8d 8d 28 02 00 00 	lea    rcx,[rbp+0x228]
   185c7ead0:	48 89 fa             	mov    rdx,rdi
   185c7ead3:	e8 a8 94 3a fa       	call   0x180027f80
   185c7ead8:	0f 28 35 d1 70 0c 03 	movaps xmm6,XMMWORD PTR [rip+0x30c70d1]        # 0x188d45bb0
   185c7eadf:	0f 29 b5 10 02 00 00 	movaps XMMWORD PTR [rbp+0x210],xmm6
   185c7eae6:	48 8d 8d 10 02 00 00 	lea    rcx,[rbp+0x210]
   185c7eaed:	e8 7e 61 a7 fa       	call   0x1806f4c70
   185c7eaf2:	90                   	nop
   185c7eaf3:	48 8d 8d 28 02 00 00 	lea    rcx,[rbp+0x228]
   185c7eafa:	48 8d bd 30 01 00 00 	lea    rdi,[rbp+0x130]
   185c7eb01:	48 89 fa             	mov    rdx,rdi
   185c7eb04:	e8 97 6c 40 fa       	call   0x1800857a0
   185c7eb09:	90                   	nop
   185c7eb0a:	48 8b 85 10 02 00 00 	mov    rax,QWORD PTR [rbp+0x210]
   185c7eb11:	48 8d 98 58 07 00 00 	lea    rbx,[rax+0x758]
   185c7eb18:	48 39 fb             	cmp    rbx,rdi
   185c7eb1b:	74 58                	je     0x185c7eb75
   185c7eb1d:	48 8b 80 70 07 00 00 	mov    rax,QWORD PTR [rax+0x770]
   185c7eb24:	48 83 f8 10          	cmp    rax,0x10
   185c7eb28:	72 34                	jb     0x185c7eb5e
   185c7eb2a:	48 8b 0b             	mov    rcx,QWORD PTR [rbx]
   185c7eb2d:	48 8d 50 01          	lea    rdx,[rax+0x1]
   185c7eb31:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185c7eb38:	72 1f                	jb     0x185c7eb59
   185c7eb3a:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   185c7eb3e:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   185c7eb42:	4c 29 c1             	sub    rcx,r8
   185c7eb45:	48 83 f9 20          	cmp    rcx,0x20
   185c7eb49:	0f 83 7b 05 00 00    	jae    0x185c7f0ca
   185c7eb4f:	48 83 c0 28          	add    rax,0x28
   185c7eb53:	48 89 c2             	mov    rdx,rax
   185c7eb56:	4c 89 c1             	mov    rcx,r8
   185c7eb59:	e8 82 cd 82 01       	call   0x1874ab8e0
   185c7eb5e:	0f 10 85 30 01 00 00 	movups xmm0,XMMWORD PTR [rbp+0x130]
   185c7eb65:	0f 10 8d 40 01 00 00 	movups xmm1,XMMWORD PTR [rbp+0x140]
   185c7eb6c:	0f 11 4b 10          	movups XMMWORD PTR [rbx+0x10],xmm1
   185c7eb70:	0f 11 03             	movups XMMWORD PTR [rbx],xmm0
   185c7eb73:	eb 45                	jmp    0x185c7ebba
   185c7eb75:	48 8b 85 48 01 00 00 	mov    rax,QWORD PTR [rbp+0x148]
   185c7eb7c:	48 83 f8 10          	cmp    rax,0x10
   185c7eb80:	72 38                	jb     0x185c7ebba
   185c7eb82:	48 8b 8d 30 01 00 00 	mov    rcx,QWORD PTR [rbp+0x130]
   185c7eb89:	48 8d 50 01          	lea    rdx,[rax+0x1]
   185c7eb8d:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185c7eb94:	72 1f                	jb     0x185c7ebb5
   185c7eb96:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   185c7eb9a:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   185c7eb9e:	4c 29 c1             	sub    rcx,r8
   185c7eba1:	48 83 f9 20          	cmp    rcx,0x20
   185c7eba5:	0f 83 1f 05 00 00    	jae    0x185c7f0ca
   185c7ebab:	48 83 c0 28          	add    rax,0x28
   185c7ebaf:	48 89 c2             	mov    rdx,rax
   185c7ebb2:	4c 89 c1             	mov    rcx,r8
   185c7ebb5:	e8 26 cd 82 01       	call   0x1874ab8e0
   185c7ebba:	4c 8d 8e 78 01 00 00 	lea    r9,[rsi+0x178]
   185c7ebc1:	48 8b 85 10 02 00 00 	mov    rax,QWORD PTR [rbp+0x210]
   185c7ebc8:	c7 80 18 01 00 00 01 	mov    DWORD PTR [rax+0x118],0x1
   185c7ebcf:	00 00 00 
   185c7ebd2:	48 8b 8d 28 02 00 00 	mov    rcx,QWORD PTR [rbp+0x228]
   185c7ebd9:	48 63 49 04          	movsxd rcx,DWORD PTR [rcx+0x4]
   185c7ebdd:	48 89 88 c8 01 00 00 	mov    QWORD PTR [rax+0x1c8],rcx
   185c7ebe4:	48 8d b8 b0 00 00 00 	lea    rdi,[rax+0xb0]
   185c7ebeb:	4c 39 cf             	cmp    rdi,r9
   185c7ebee:	74 54                	je     0x185c7ec44
   185c7ebf0:	48 8b 9e 88 01 00 00 	mov    rbx,QWORD PTR [rsi+0x188]
   185c7ebf7:	48 83 be 90 01 00 00 	cmp    QWORD PTR [rsi+0x190],0x10
   185c7ebfe:	10 
   185c7ebff:	72 07                	jb     0x185c7ec08
   185c7ec01:	4c 8b 8e 78 01 00 00 	mov    r9,QWORD PTR [rsi+0x178]
   185c7ec08:	48 8b 88 c8 00 00 00 	mov    rcx,QWORD PTR [rax+0xc8]
   185c7ec0f:	48 39 cb             	cmp    rbx,rcx
   185c7ec12:	76 0e                	jbe    0x185c7ec22
   185c7ec14:	48 89 f9             	mov    rcx,rdi
   185c7ec17:	48 89 da             	mov    rdx,rbx
   185c7ec1a:	e8 31 f5 3b fa       	call   0x18003e150
   185c7ec1f:	90                   	nop
   185c7ec20:	eb 22                	jmp    0x185c7ec44
   185c7ec22:	48 83 f9 10          	cmp    rcx,0x10
   185c7ec26:	72 03                	jb     0x185c7ec2b
   185c7ec28:	48 8b 3f             	mov    rdi,QWORD PTR [rdi]
   185c7ec2b:	48 89 98 c0 00 00 00 	mov    QWORD PTR [rax+0xc0],rbx
   185c7ec32:	48 89 f9             	mov    rcx,rdi
   185c7ec35:	4c 89 ca             	mov    rdx,r9
   185c7ec38:	49 89 d8             	mov    r8,rbx
   185c7ec3b:	e8 10 54 8c 01       	call   0x187544050
   185c7ec40:	c6 04 1f 00          	mov    BYTE PTR [rdi+rbx*1],0x0
   185c7ec44:	4c 8d 8e b8 01 00 00 	lea    r9,[rsi+0x1b8]
   185c7ec4b:	48 8b 85 10 02 00 00 	mov    rax,QWORD PTR [rbp+0x210]
   185c7ec52:	48 8d 78 18          	lea    rdi,[rax+0x18]
   185c7ec56:	4c 39 cf             	cmp    rdi,r9
   185c7ec59:	74 4e                	je     0x185c7eca9
   185c7ec5b:	48 8b 9e c8 01 00 00 	mov    rbx,QWORD PTR [rsi+0x1c8]
   185c7ec62:	48 83 be d0 01 00 00 	cmp    QWORD PTR [rsi+0x1d0],0x10
   185c7ec69:	10 
   185c7ec6a:	72 07                	jb     0x185c7ec73
   185c7ec6c:	4c 8b 8e b8 01 00 00 	mov    r9,QWORD PTR [rsi+0x1b8]
   185c7ec73:	48 8b 48 30          	mov    rcx,QWORD PTR [rax+0x30]
   185c7ec77:	48 39 cb             	cmp    rbx,rcx
   185c7ec7a:	76 0e                	jbe    0x185c7ec8a
   185c7ec7c:	48 89 f9             	mov    rcx,rdi
   185c7ec7f:	48 89 da             	mov    rdx,rbx
   185c7ec82:	e8 c9 f4 3b fa       	call   0x18003e150
   185c7ec87:	90                   	nop
   185c7ec88:	eb 1f                	jmp    0x185c7eca9
   185c7ec8a:	48 83 f9 10          	cmp    rcx,0x10
   185c7ec8e:	72 03                	jb     0x185c7ec93
   185c7ec90:	48 8b 3f             	mov    rdi,QWORD PTR [rdi]
   185c7ec93:	48 89 58 28          	mov    QWORD PTR [rax+0x28],rbx
   185c7ec97:	48 89 f9             	mov    rcx,rdi
   185c7ec9a:	4c 89 ca             	mov    rdx,r9
   185c7ec9d:	49 89 d8             	mov    r8,rbx
   185c7eca0:	e8 ab 53 8c 01       	call   0x187544050
   185c7eca5:	c6 04 1f 00          	mov    BYTE PTR [rdi+rbx*1],0x0
   185c7eca9:	e8 62 70 3c fa       	call   0x180045d10
   185c7ecae:	90                   	nop
   185c7ecaf:	4c 8b 00             	mov    r8,QWORD PTR [rax]
   185c7ecb2:	48 8d 95 d0 01 00 00 	lea    rdx,[rbp+0x1d0]
   185c7ecb9:	48 89 c1             	mov    rcx,rax
   185c7ecbc:	41 ff 50 60          	call   QWORD PTR [r8+0x60]
   185c7ecc0:	90                   	nop
   185c7ecc1:	48 8b 8d d0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1d0]
   185c7ecc8:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   185c7eccb:	48 8d 95 c0 01 00 00 	lea    rdx,[rbp+0x1c0]
   185c7ecd2:	ff 50 30             	call   QWORD PTR [rax+0x30]
   185c7ecd5:	90                   	nop
   185c7ecd6:	48 8b 8d c0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1c0]
   185c7ecdd:	48 8d 05 24 1b 1d 03 	lea    rax,[rip+0x31d1b24]        # 0x188e50808
   185c7ece4:	48 89 85 b0 00 00 00 	mov    QWORD PTR [rbp+0xb0],rax
   185c7eceb:	0f 29 b5 30 01 00 00 	movaps XMMWORD PTR [rbp+0x130],xmm6
   185c7ecf2:	48 8d 95 30 01 00 00 	lea    rdx,[rbp+0x130]
   185c7ecf9:	4c 8d 85 b0 00 00 00 	lea    r8,[rbp+0xb0]
   185c7ed00:	e8 7b fd 51 fa       	call   0x18019ea80
   185c7ed05:	90                   	nop
   185c7ed06:	48 8b 85 30 01 00 00 	mov    rax,QWORD PTR [rbp+0x130]
   185c7ed0d:	48 8b 8d 38 01 00 00 	mov    rcx,QWORD PTR [rbp+0x138]
   185c7ed14:	48 85 c9             	test   rcx,rcx
   185c7ed17:	74 3d                	je     0x185c7ed56
   185c7ed19:	f0 ff 41 08          	lock inc DWORD PTR [rcx+0x8]
   185c7ed1d:	48 8b b5 38 01 00 00 	mov    rsi,QWORD PTR [rbp+0x138]
   185c7ed24:	48 89 85 e0 01 00 00 	mov    QWORD PTR [rbp+0x1e0],rax
   185c7ed2b:	48 89 b5 e8 01 00 00 	mov    QWORD PTR [rbp+0x1e8],rsi
   185c7ed32:	48 85 f6             	test   rsi,rsi
   185c7ed35:	74 31                	je     0x185c7ed68
   185c7ed37:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   185c7ed3b:	75 2b                	jne    0x185c7ed68
   185c7ed3d:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   185c7ed40:	48 89 f1             	mov    rcx,rsi
   185c7ed43:	ff 10                	call   QWORD PTR [rax]
   185c7ed45:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   185c7ed49:	75 1d                	jne    0x185c7ed68
   185c7ed4b:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   185c7ed4e:	48 89 f1             	mov    rcx,rsi
   185c7ed51:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185c7ed54:	eb 12                	jmp    0x185c7ed68
   185c7ed56:	48 89 85 e0 01 00 00 	mov    QWORD PTR [rbp+0x1e0],rax
   185c7ed5d:	48 c7 85 e8 01 00 00 	mov    QWORD PTR [rbp+0x1e8],0x0
   185c7ed64:	00 00 00 00 
   185c7ed68:	48 8b b5 e0 01 00 00 	mov    rsi,QWORD PTR [rbp+0x1e0]
   185c7ed6f:	48 8b 85 18 02 00 00 	mov    rax,QWORD PTR [rbp+0x218]
   185c7ed76:	48 85 c0             	test   rax,rax
   185c7ed79:	74 14                	je     0x185c7ed8f
   185c7ed7b:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   185c7ed7f:	48 8b 85 18 02 00 00 	mov    rax,QWORD PTR [rbp+0x218]
   185c7ed86:	48 89 85 30 02 00 00 	mov    QWORD PTR [rbp+0x230],rax
   185c7ed8d:	eb 0b                	jmp    0x185c7ed9a
   185c7ed8f:	48 c7 85 30 02 00 00 	mov    QWORD PTR [rbp+0x230],0x0
   185c7ed96:	00 00 00 00 
   185c7ed9a:	48 8b bd 10 02 00 00 	mov    rdi,QWORD PTR [rbp+0x210]
   185c7eda1:	0f 57 f6             	xorps  xmm6,xmm6
   185c7eda4:	0f 29 b5 f0 01 00 00 	movaps XMMWORD PTR [rbp+0x1f0],xmm6
   185c7edab:	48 c7 85 00 02 00 00 	mov    QWORD PTR [rbp+0x200],0x0
   185c7edb2:	00 00 00 00 
   185c7edb6:	b9 10 00 00 00       	mov    ecx,0x10
   185c7edbb:	e8 dc ca 82 01       	call   0x1874ab89c
   185c7edc0:	90                   	nop
   185c7edc1:	48 89 85 f0 01 00 00 	mov    QWORD PTR [rbp+0x1f0],rax
   185c7edc8:	48 89 85 f8 01 00 00 	mov    QWORD PTR [rbp+0x1f8],rax
   185c7edcf:	48 89 c1             	mov    rcx,rax
   185c7edd2:	48 83 c1 10          	add    rcx,0x10
   185c7edd6:	48 89 8d 00 02 00 00 	mov    QWORD PTR [rbp+0x200],rcx
   185c7eddd:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   185c7ede0:	48 8b 95 30 02 00 00 	mov    rdx,QWORD PTR [rbp+0x230]
   185c7ede7:	48 85 d2             	test   rdx,rdx
   185c7edea:	74 04                	je     0x185c7edf0
   185c7edec:	f0 ff 42 08          	lock inc DWORD PTR [rdx+0x8]
   185c7edf0:	48 89 38             	mov    QWORD PTR [rax],rdi
   185c7edf3:	48 89 50 08          	mov    QWORD PTR [rax+0x8],rdx
   185c7edf7:	48 89 8d f8 01 00 00 	mov    QWORD PTR [rbp+0x1f8],rcx
   185c7edfe:	48 8d 95 30 01 00 00 	lea    rdx,[rbp+0x130]
   185c7ee05:	4c 8d 85 f0 01 00 00 	lea    r8,[rbp+0x1f0]
   185c7ee0c:	48 89 f1             	mov    rcx,rsi
   185c7ee0f:	41 b1 01             	mov    r9b,0x1
   185c7ee12:	e8 b9 5b d2 fb       	call   0x1819a49d0
   185c7ee17:	90                   	nop
   185c7ee18:	48 8d 15 b1 d2 c7 03 	lea    rdx,[rip+0x3c7d2b1]        # 0x1898fc0d0
   185c7ee1f:	4c 8d 05 1a d0 c7 03 	lea    r8,[rip+0x3c7d01a]        # 0x1898fbe40
   185c7ee26:	48 8d b5 b0 00 00 00 	lea    rsi,[rbp+0xb0]
   185c7ee2d:	48 89 f1             	mov    rcx,rsi
   185c7ee30:	41 b9 89 00 00 00    	mov    r9d,0x89
   185c7ee36:	e8 c5 b6 51 fa       	call   0x18019a500
   185c7ee3b:	90                   	nop
   185c7ee3c:	48 c7 45 00 00 00 00 	mov    QWORD PTR [rbp+0x0],0x0
   185c7ee43:	00 
   185c7ee44:	48 8d 05 cd ce c7 03 	lea    rax,[rip+0x3c7cecd]        # 0x1898fbd18
   185c7ee4b:	48 89 45 08          	mov    QWORD PTR [rbp+0x8],rax
   185c7ee4f:	4c 8d 4d 08          	lea    r9,[rbp+0x8]
   185c7ee53:	4c 89 4d 40          	mov    QWORD PTR [rbp+0x40],r9
   185c7ee57:	48 8d 05 fa cd c7 03 	lea    rax,[rip+0x3c7cdfa]        # 0x1898fbc58
   185c7ee5e:	48 89 45 48          	mov    QWORD PTR [rbp+0x48],rax
   185c7ee62:	4c 8d 45 48          	lea    r8,[rbp+0x48]
   185c7ee66:	4c 89 85 80 00 00 00 	mov    QWORD PTR [rbp+0x80],r8
   185c7ee6d:	48 89 74 24 28       	mov    QWORD PTR [rsp+0x28],rsi
   185c7ee72:	48 8d 45 c8          	lea    rax,[rbp-0x38]
   185c7ee76:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   185c7ee7b:	48 8d b5 30 01 00 00 	lea    rsi,[rbp+0x130]
   185c7ee82:	48 8d 95 88 00 00 00 	lea    rdx,[rbp+0x88]
   185c7ee89:	48 89 f1             	mov    rcx,rsi
   185c7ee8c:	e8 8f 0e d5 fb       	call   0x1819cfd20
   185c7ee91:	90                   	nop
   185c7ee92:	48 8b bd a8 00 00 00 	mov    rdi,QWORD PTR [rbp+0xa8]
   185c7ee99:	48 85 ff             	test   rdi,rdi
   185c7ee9c:	74 1d                	je     0x185c7eebb
   185c7ee9e:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   185c7eea2:	75 17                	jne    0x185c7eebb
   185c7eea4:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185c7eea7:	48 89 f9             	mov    rcx,rdi
   185c7eeaa:	ff 10                	call   QWORD PTR [rax]
   185c7eeac:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   185c7eeb0:	75 09                	jne    0x185c7eebb
   185c7eeb2:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185c7eeb5:	48 89 f9             	mov    rcx,rdi
   185c7eeb8:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185c7eebb:	48 8b bd 98 00 00 00 	mov    rdi,QWORD PTR [rbp+0x98]
   185c7eec2:	48 85 ff             	test   rdi,rdi
   185c7eec5:	4c 8b b5 30 02 00 00 	mov    r14,QWORD PTR [rbp+0x230]
   185c7eecc:	74 1d                	je     0x185c7eeeb
   185c7eece:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   185c7eed2:	75 17                	jne    0x185c7eeeb
   185c7eed4:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185c7eed7:	48 89 f9             	mov    rcx,rdi
   185c7eeda:	ff 10                	call   QWORD PTR [rax]
   185c7eedc:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   185c7eee0:	75 09                	jne    0x185c7eeeb
   185c7eee2:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185c7eee5:	48 89 f9             	mov    rcx,rdi
   185c7eee8:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185c7eeeb:	48 8b 8d 78 01 00 00 	mov    rcx,QWORD PTR [rbp+0x178]
   185c7eef2:	48 85 c9             	test   rcx,rcx
   185c7eef5:	74 0c                	je     0x185c7ef03
   185c7eef7:	f0 ff 49 0c          	lock dec DWORD PTR [rcx+0xc]
   185c7eefb:	75 06                	jne    0x185c7ef03
   185c7eefd:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   185c7ef00:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185c7ef03:	48 8b 8d 68 01 00 00 	mov    rcx,QWORD PTR [rbp+0x168]
   185c7ef0a:	48 85 c9             	test   rcx,rcx
   185c7ef0d:	74 0c                	je     0x185c7ef1b
   185c7ef0f:	48 39 f1             	cmp    rcx,rsi
   185c7ef12:	0f 95 c2             	setne  dl
   185c7ef15:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   185c7ef18:	ff 50 20             	call   QWORD PTR [rax+0x20]
   185c7ef1b:	48 8b b5 f0 01 00 00 	mov    rsi,QWORD PTR [rbp+0x1f0]
   185c7ef22:	48 85 f6             	test   rsi,rsi
   185c7ef25:	0f 84 94 00 00 00    	je     0x185c7efbf
   185c7ef2b:	48 8b 9d f8 01 00 00 	mov    rbx,QWORD PTR [rbp+0x1f8]
   185c7ef32:	48 39 de             	cmp    rsi,rbx
   185c7ef35:	75 22                	jne    0x185c7ef59
   185c7ef37:	48 8b 95 00 02 00 00 	mov    rdx,QWORD PTR [rbp+0x200]
   185c7ef3e:	48 29 f2             	sub    rdx,rsi
   185c7ef41:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185c7ef48:	73 51                	jae    0x185c7ef9b
   185c7ef4a:	eb 6b                	jmp    0x185c7efb7
   185c7ef4c:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
   185c7ef50:	48 83 c6 10          	add    rsi,0x10
   185c7ef54:	48 39 de             	cmp    rsi,rbx
   185c7ef57:	74 28                	je     0x185c7ef81
   185c7ef59:	48 8b 7e 08          	mov    rdi,QWORD PTR [rsi+0x8]
   185c7ef5d:	48 85 ff             	test   rdi,rdi
   185c7ef60:	74 ee                	je     0x185c7ef50
   185c7ef62:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   185c7ef66:	75 e8                	jne    0x185c7ef50
   185c7ef68:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185c7ef6b:	48 89 f9             	mov    rcx,rdi
   185c7ef6e:	ff 10                	call   QWORD PTR [rax]
   185c7ef70:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   185c7ef74:	75 da                	jne    0x185c7ef50
   185c7ef76:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185c7ef79:	48 89 f9             	mov    rcx,rdi
   185c7ef7c:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185c7ef7f:	eb cf                	jmp    0x185c7ef50
   185c7ef81:	48 8b b5 f0 01 00 00 	mov    rsi,QWORD PTR [rbp+0x1f0]
   185c7ef88:	48 8b 95 00 02 00 00 	mov    rdx,QWORD PTR [rbp+0x200]
   185c7ef8f:	48 29 f2             	sub    rdx,rsi
   185c7ef92:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185c7ef99:	72 1c                	jb     0x185c7efb7
   185c7ef9b:	48 8b 46 f8          	mov    rax,QWORD PTR [rsi-0x8]
   185c7ef9f:	48 83 c6 f8          	add    rsi,0xfffffffffffffff8
   185c7efa3:	48 29 c6             	sub    rsi,rax
   185c7efa6:	48 83 fe 20          	cmp    rsi,0x20
   185c7efaa:	0f 83 1a 01 00 00    	jae    0x185c7f0ca
   185c7efb0:	48 83 c2 27          	add    rdx,0x27
   185c7efb4:	48 89 c6             	mov    rsi,rax
   185c7efb7:	48 89 f1             	mov    rcx,rsi
   185c7efba:	e8 21 c9 82 01       	call   0x1874ab8e0
   185c7efbf:	4d 85 f6             	test   r14,r14
   185c7efc2:	74 1f                	je     0x185c7efe3
   185c7efc4:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   185c7efc9:	75 18                	jne    0x185c7efe3
   185c7efcb:	49 8b 06             	mov    rax,QWORD PTR [r14]
   185c7efce:	4c 89 f1             	mov    rcx,r14
   185c7efd1:	ff 10                	call   QWORD PTR [rax]
   185c7efd3:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   185c7efd8:	75 09                	jne    0x185c7efe3
   185c7efda:	49 8b 06             	mov    rax,QWORD PTR [r14]
   185c7efdd:	4c 89 f1             	mov    rcx,r14
   185c7efe0:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185c7efe3:	48 8b b5 e8 01 00 00 	mov    rsi,QWORD PTR [rbp+0x1e8]
   185c7efea:	48 85 f6             	test   rsi,rsi
   185c7efed:	74 1d                	je     0x185c7f00c
   185c7efef:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   185c7eff3:	75 17                	jne    0x185c7f00c
   185c7eff5:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   185c7eff8:	48 89 f1             	mov    rcx,rsi
   185c7effb:	ff 10                	call   QWORD PTR [rax]
   185c7effd:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   185c7f001:	75 09                	jne    0x185c7f00c
   185c7f003:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   185c7f006:	48 89 f1             	mov    rcx,rsi
   185c7f009:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185c7f00c:	48 8b b5 c8 01 00 00 	mov    rsi,QWORD PTR [rbp+0x1c8]
   185c7f013:	48 85 f6             	test   rsi,rsi
   185c7f016:	74 1d                	je     0x185c7f035
   185c7f018:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   185c7f01c:	75 17                	jne    0x185c7f035
   185c7f01e:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   185c7f021:	48 89 f1             	mov    rcx,rsi
   185c7f024:	ff 10                	call   QWORD PTR [rax]
   185c7f026:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   185c7f02a:	75 09                	jne    0x185c7f035
   185c7f02c:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   185c7f02f:	48 89 f1             	mov    rcx,rsi
   185c7f032:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185c7f035:	48 8b b5 d8 01 00 00 	mov    rsi,QWORD PTR [rbp+0x1d8]
   185c7f03c:	48 85 f6             	test   rsi,rsi
   185c7f03f:	74 1d                	je     0x185c7f05e
   185c7f041:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   185c7f045:	75 17                	jne    0x185c7f05e
   185c7f047:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   185c7f04a:	48 89 f1             	mov    rcx,rsi
   185c7f04d:	ff 10                	call   QWORD PTR [rax]
   185c7f04f:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   185c7f053:	75 09                	jne    0x185c7f05e
   185c7f055:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   185c7f058:	48 89 f1             	mov    rcx,rsi
   185c7f05b:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185c7f05e:	48 8b b5 18 02 00 00 	mov    rsi,QWORD PTR [rbp+0x218]
   185c7f065:	48 85 f6             	test   rsi,rsi
   185c7f068:	74 1d                	je     0x185c7f087
   185c7f06a:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   185c7f06e:	75 17                	jne    0x185c7f087
   185c7f070:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   185c7f073:	48 89 f1             	mov    rcx,rsi
   185c7f076:	ff 10                	call   QWORD PTR [rax]
   185c7f078:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   185c7f07c:	75 09                	jne    0x185c7f087
   185c7f07e:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   185c7f081:	48 89 f1             	mov    rcx,rsi
   185c7f084:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185c7f087:	48 8b 8d 28 02 00 00 	mov    rcx,QWORD PTR [rbp+0x228]
   185c7f08e:	8b 01                	mov    eax,DWORD PTR [rcx]
   185c7f090:	83 f8 ff             	cmp    eax,0xffffffff
   185c7f093:	74 20                	je     0x185c7f0b5
   185c7f095:	85 c0                	test   eax,eax
   185c7f097:	74 0c                	je     0x185c7f0a5
   185c7f099:	f0 ff 09             	lock dec DWORD PTR [rcx]
   185c7f09c:	75 17                	jne    0x185c7f0b5
   185c7f09e:	48 8b 8d 28 02 00 00 	mov    rcx,QWORD PTR [rbp+0x228]
   185c7f0a5:	ba 02 00 00 00       	mov    edx,0x2
   185c7f0aa:	41 b8 08 00 00 00    	mov    r8d,0x8
   185c7f0b0:	e8 7b 98 3b fa       	call   0x180038930
   185c7f0b5:	0f 28 b5 40 02 00 00 	movaps xmm6,XMMWORD PTR [rbp+0x240]
   185c7f0bc:	48 81 c4 d0 02 00 00 	add    rsp,0x2d0
   185c7f0c3:	5b                   	pop    rbx
   185c7f0c4:	5f                   	pop    rdi
   185c7f0c5:	5e                   	pop    rsi
   185c7f0c6:	41 5e                	pop    r14
   185c7f0c8:	5d                   	pop    rbp
   185c7f0c9:	c3                   	ret
   185c7f0ca:	e8 bd e2 88 01       	call   0x18750d38c
   185c7f0cf:	cc                   	int3
