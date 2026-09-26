
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000182e83ab0 <.text+0x2e82ab0>:
   182e83ab0:	41 57                	push   r15
   182e83ab2:	41 56                	push   r14
   182e83ab4:	41 55                	push   r13
   182e83ab6:	41 54                	push   r12
   182e83ab8:	56                   	push   rsi
   182e83ab9:	57                   	push   rdi
   182e83aba:	55                   	push   rbp
   182e83abb:	53                   	push   rbx
   182e83abc:	48 83 ec 48          	sub    rsp,0x48
   182e83ac0:	0f 29 74 24 30       	movaps XMMWORD PTR [rsp+0x30],xmm6
   182e83ac5:	48 89 d6             	mov    rsi,rdx
   182e83ac8:	48 89 cf             	mov    rdi,rcx
   182e83acb:	48 8d 59 20          	lea    rbx,[rcx+0x20]
   182e83acf:	4c 8d 7c 24 2c       	lea    r15,[rsp+0x2c]
   182e83ad4:	4c 8d 35 05 33 a9 08 	lea    r14,[rip+0x8a93305]        # 0x18b916de0
   182e83adb:	0f 57 f6             	xorps  xmm6,xmm6
   182e83ade:	66 90                	xchg   ax,ax
   182e83ae0:	48 8b 4e 08          	mov    rcx,QWORD PTR [rsi+0x8]
   182e83ae4:	48 3b 4e 10          	cmp    rcx,QWORD PTR [rsi+0x10]
   182e83ae8:	73 26                	jae    0x182e83b10
   182e83aea:	0f be 01             	movsx  eax,BYTE PTR [rcx]
   182e83aed:	85 c0                	test   eax,eax
   182e83aef:	78 1f                	js     0x182e83b10
   182e83af1:	89 46 20             	mov    DWORD PTR [rsi+0x20],eax
   182e83af4:	48 ff c1             	inc    rcx
   182e83af7:	48 89 4e 08          	mov    QWORD PTR [rsi+0x8],rcx
   182e83afb:	40 b5 01             	mov    bpl,0x1
   182e83afe:	85 c0                	test   eax,eax
   182e83b00:	75 24                	jne    0x182e83b26
   182e83b02:	e9 09 02 00 00       	jmp    0x182e83d10
   182e83b07:	66 0f 1f 84 00 00 00 	nop    WORD PTR [rax+rax*1+0x0]
   182e83b0e:	00 00 
   182e83b10:	48 89 f1             	mov    rcx,rsi
   182e83b13:	e8 68 f8 76 fe       	call   0x1815f3380
   182e83b18:	89 46 20             	mov    DWORD PTR [rsi+0x20],eax
   182e83b1b:	40 b5 01             	mov    bpl,0x1
   182e83b1e:	85 c0                	test   eax,eax
   182e83b20:	0f 84 ea 01 00 00    	je     0x182e83d10
   182e83b26:	89 c2                	mov    edx,eax
   182e83b28:	c1 ea 03             	shr    edx,0x3
   182e83b2b:	89 c1                	mov    ecx,eax
   182e83b2d:	83 e1 07             	and    ecx,0x7
   182e83b30:	83 fa 02             	cmp    edx,0x2
   182e83b33:	74 2b                	je     0x182e83b60
   182e83b35:	83 fa 01             	cmp    edx,0x1
   182e83b38:	75 2b                	jne    0x182e83b65
   182e83b3a:	85 c9                	test   ecx,ecx
   182e83b3c:	75 27                	jne    0x182e83b65
   182e83b3e:	48 8b 46 08          	mov    rax,QWORD PTR [rsi+0x8]
   182e83b42:	48 3b 46 10          	cmp    rax,QWORD PTR [rsi+0x10]
   182e83b46:	73 3d                	jae    0x182e83b85
   182e83b48:	0f be 00             	movsx  eax,BYTE PTR [rax]
   182e83b4b:	85 c0                	test   eax,eax
   182e83b4d:	78 36                	js     0x182e83b85
   182e83b4f:	89 03                	mov    DWORD PTR [rbx],eax
   182e83b51:	48 ff 46 08          	inc    QWORD PTR [rsi+0x8]
   182e83b55:	eb 41                	jmp    0x182e83b98
   182e83b57:	66 0f 1f 84 00 00 00 	nop    WORD PTR [rax+rax*1+0x0]
   182e83b5e:	00 00 
   182e83b60:	83 f9 02             	cmp    ecx,0x2
   182e83b63:	74 55                	je     0x182e83bba
   182e83b65:	83 f9 04             	cmp    ecx,0x4
   182e83b68:	0f 84 a2 01 00 00    	je     0x182e83d10
   182e83b6e:	48 89 f1             	mov    rcx,rsi
   182e83b71:	89 c2                	mov    edx,eax
   182e83b73:	e8 18 05 77 fe       	call   0x1815f4090
   182e83b78:	84 c0                	test   al,al
   182e83b7a:	0f 85 60 ff ff ff    	jne    0x182e83ae0
   182e83b80:	e9 89 01 00 00       	jmp    0x182e83d0e
   182e83b85:	48 89 f1             	mov    rcx,rsi
   182e83b88:	48 89 da             	mov    rdx,rbx
   182e83b8b:	e8 90 f6 76 fe       	call   0x1815f3220
   182e83b90:	84 c0                	test   al,al
   182e83b92:	0f 84 76 01 00 00    	je     0x182e83d0e
   182e83b98:	80 4f 28 01          	or     BYTE PTR [rdi+0x28],0x1
   182e83b9c:	48 8b 46 08          	mov    rax,QWORD PTR [rsi+0x8]
   182e83ba0:	48 3b 46 10          	cmp    rax,QWORD PTR [rsi+0x10]
   182e83ba4:	0f 83 36 ff ff ff    	jae    0x182e83ae0
   182e83baa:	80 38 12             	cmp    BYTE PTR [rax],0x12
   182e83bad:	0f 85 2d ff ff ff    	jne    0x182e83ae0
   182e83bb3:	48 ff c0             	inc    rax
   182e83bb6:	48 89 46 08          	mov    QWORD PTR [rsi+0x8],rax
   182e83bba:	8b 47 10             	mov    eax,DWORD PTR [rdi+0x10]
   182e83bbd:	8b 57 14             	mov    edx,DWORD PTR [rdi+0x14]
   182e83bc0:	39 d0                	cmp    eax,edx
   182e83bc2:	7d 27                	jge    0x182e83beb
   182e83bc4:	48 63 c8             	movsxd rcx,eax
   182e83bc7:	48 8b 57 08          	mov    rdx,QWORD PTR [rdi+0x8]
   182e83bcb:	ff c0                	inc    eax
   182e83bcd:	89 47 10             	mov    DWORD PTR [rdi+0x10],eax
   182e83bd0:	4c 8b 24 ca          	mov    r12,QWORD PTR [rdx+rcx*8]
   182e83bd4:	c7 44 24 2c aa aa aa 	mov    DWORD PTR [rsp+0x2c],0xaaaaaaaa
   182e83bdb:	aa 
   182e83bdc:	48 8b 46 08          	mov    rax,QWORD PTR [rsi+0x8]
   182e83be0:	48 3b 46 10          	cmp    rax,QWORD PTR [rsi+0x10]
   182e83be4:	72 7b                	jb     0x182e83c61
   182e83be6:	e9 8a 00 00 00       	jmp    0x182e83c75
   182e83beb:	3b 57 18             	cmp    edx,DWORD PTR [rdi+0x18]
   182e83bee:	75 0e                	jne    0x182e83bfe
   182e83bf0:	ff c2                	inc    edx
   182e83bf2:	48 8d 4f 08          	lea    rcx,[rdi+0x8]
   182e83bf6:	e8 75 a1 f2 fd       	call   0x180dadd70
   182e83bfb:	8b 57 14             	mov    edx,DWORD PTR [rdi+0x14]
   182e83bfe:	ff c2                	inc    edx
   182e83c00:	89 57 14             	mov    DWORD PTR [rdi+0x14],edx
   182e83c03:	b9 38 00 00 00       	mov    ecx,0x38
   182e83c08:	e8 8f 7c 62 04       	call   0x1874ab89c
   182e83c0d:	49 89 c4             	mov    r12,rax
   182e83c10:	48 8d 05 21 12 55 06 	lea    rax,[rip+0x6551221]        # 0x1893d4e38
   182e83c17:	49 89 04 24          	mov    QWORD PTR [r12],rax
   182e83c1b:	49 c7 44 24 08 00 00 	mov    QWORD PTR [r12+0x8],0x0
   182e83c22:	00 00 
   182e83c24:	4d 89 74 24 10       	mov    QWORD PTR [r12+0x10],r14
   182e83c29:	49 c7 44 24 18 00 00 	mov    QWORD PTR [r12+0x18],0x0
   182e83c30:	00 00 
   182e83c32:	4d 89 74 24 20       	mov    QWORD PTR [r12+0x20],r14
   182e83c37:	41 0f 11 74 24 28    	movups XMMWORD PTR [r12+0x28],xmm6
   182e83c3d:	48 8b 47 08          	mov    rax,QWORD PTR [rdi+0x8]
   182e83c41:	48 63 4f 10          	movsxd rcx,DWORD PTR [rdi+0x10]
   182e83c45:	8d 51 01             	lea    edx,[rcx+0x1]
   182e83c48:	89 57 10             	mov    DWORD PTR [rdi+0x10],edx
   182e83c4b:	4c 89 24 c8          	mov    QWORD PTR [rax+rcx*8],r12
   182e83c4f:	c7 44 24 2c aa aa aa 	mov    DWORD PTR [rsp+0x2c],0xaaaaaaaa
   182e83c56:	aa 
   182e83c57:	48 8b 46 08          	mov    rax,QWORD PTR [rsi+0x8]
   182e83c5b:	48 3b 46 10          	cmp    rax,QWORD PTR [rsi+0x10]
   182e83c5f:	73 14                	jae    0x182e83c75
   182e83c61:	0f be 08             	movsx  ecx,BYTE PTR [rax]
   182e83c64:	85 c9                	test   ecx,ecx
   182e83c66:	78 0d                	js     0x182e83c75
   182e83c68:	89 4c 24 2c          	mov    DWORD PTR [rsp+0x2c],ecx
   182e83c6c:	48 ff c0             	inc    rax
   182e83c6f:	48 89 46 08          	mov    QWORD PTR [rsi+0x8],rax
   182e83c73:	eb 13                	jmp    0x182e83c88
   182e83c75:	48 89 f1             	mov    rcx,rsi
   182e83c78:	4c 89 fa             	mov    rdx,r15
   182e83c7b:	e8 a0 f5 76 fe       	call   0x1815f3220
   182e83c80:	84 c0                	test   al,al
   182e83c82:	0f 84 86 00 00 00    	je     0x182e83d0e
   182e83c88:	8b 46 38             	mov    eax,DWORD PTR [rsi+0x38]
   182e83c8b:	ff c0                	inc    eax
   182e83c8d:	89 46 38             	mov    DWORD PTR [rsi+0x38],eax
   182e83c90:	3b 46 3c             	cmp    eax,DWORD PTR [rsi+0x3c]
   182e83c93:	7f 79                	jg     0x182e83d0e
   182e83c95:	8b 54 24 2c          	mov    edx,DWORD PTR [rsp+0x2c]
   182e83c99:	48 89 f1             	mov    rcx,rsi
   182e83c9c:	e8 4f ec 76 fe       	call   0x1815f28f0
   182e83ca1:	41 89 c5             	mov    r13d,eax
   182e83ca4:	4c 89 e1             	mov    rcx,r12
   182e83ca7:	48 89 f2             	mov    rdx,rsi
   182e83caa:	e8 41 f4 ff ff       	call   0x182e830f0
   182e83caf:	84 c0                	test   al,al
   182e83cb1:	74 5b                	je     0x182e83d0e
   182e83cb3:	80 7e 24 01          	cmp    BYTE PTR [rsi+0x24],0x1
   182e83cb7:	75 55                	jne    0x182e83d0e
   182e83cb9:	48 89 f1             	mov    rcx,rsi
   182e83cbc:	44 89 ea             	mov    edx,r13d
   182e83cbf:	e8 9c ec 76 fe       	call   0x1815f2960
   182e83cc4:	8b 46 38             	mov    eax,DWORD PTR [rsi+0x38]
   182e83cc7:	85 c0                	test   eax,eax
   182e83cc9:	7e 05                	jle    0x182e83cd0
   182e83ccb:	ff c8                	dec    eax
   182e83ccd:	89 46 38             	mov    DWORD PTR [rsi+0x38],eax
   182e83cd0:	48 8b 46 08          	mov    rax,QWORD PTR [rsi+0x8]
   182e83cd4:	48 8b 4e 10          	mov    rcx,QWORD PTR [rsi+0x10]
   182e83cd8:	48 39 c8             	cmp    rax,rcx
   182e83cdb:	73 09                	jae    0x182e83ce6
   182e83cdd:	80 38 12             	cmp    BYTE PTR [rax],0x12
   182e83ce0:	0f 84 cd fe ff ff    	je     0x182e83bb3
   182e83ce6:	48 39 c8             	cmp    rax,rcx
   182e83ce9:	0f 85 f1 fd ff ff    	jne    0x182e83ae0
   182e83cef:	83 7e 2c 00          	cmp    DWORD PTR [rsi+0x2c],0x0
   182e83cf3:	75 0c                	jne    0x182e83d01
   182e83cf5:	8b 46 18             	mov    eax,DWORD PTR [rsi+0x18]
   182e83cf8:	3b 46 28             	cmp    eax,DWORD PTR [rsi+0x28]
   182e83cfb:	0f 85 df fd ff ff    	jne    0x182e83ae0
   182e83d01:	c7 46 20 00 00 00 00 	mov    DWORD PTR [rsi+0x20],0x0
   182e83d08:	c6 46 24 01          	mov    BYTE PTR [rsi+0x24],0x1
   182e83d0c:	eb 02                	jmp    0x182e83d10
   182e83d0e:	31 ed                	xor    ebp,ebp
   182e83d10:	89 e8                	mov    eax,ebp
   182e83d12:	0f 28 74 24 30       	movaps xmm6,XMMWORD PTR [rsp+0x30]
   182e83d17:	48 83 c4 48          	add    rsp,0x48
   182e83d1b:	5b                   	pop    rbx
   182e83d1c:	5d                   	pop    rbp
   182e83d1d:	5f                   	pop    rdi
   182e83d1e:	5e                   	pop    rsi
   182e83d1f:	41 5c                	pop    r12
   182e83d21:	41 5d                	pop    r13
   182e83d23:	41 5e                	pop    r14
   182e83d25:	41 5f                	pop    r15
   182e83d27:	c3                   	ret
