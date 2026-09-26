
.research\wechat-4.1.10.27-reference\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

000000018000df40 <.text+0xcf40>:
   18000df40:	55                   	push   rbp
   18000df41:	41 57                	push   r15
   18000df43:	41 56                	push   r14
   18000df45:	41 54                	push   r12
   18000df47:	56                   	push   rsi
   18000df48:	57                   	push   rdi
   18000df49:	53                   	push   rbx
   18000df4a:	48 83 ec 40          	sub    rsp,0x40
   18000df4e:	48 8d 6c 24 40       	lea    rbp,[rsp+0x40]
   18000df53:	48 c7 45 f8 fe ff ff 	mov    QWORD PTR [rbp-0x8],0xfffffffffffffffe
   18000df5a:	ff 
   18000df5b:	4c 89 4d e8          	mov    QWORD PTR [rbp-0x18],r9
   18000df5f:	4c 89 45 f0          	mov    QWORD PTR [rbp-0x10],r8
   18000df63:	48 89 55 e0          	mov    QWORD PTR [rbp-0x20],rdx
   18000df67:	48 89 ce             	mov    rsi,rcx
   18000df6a:	b9 18 00 00 00       	mov    ecx,0x18
   18000df6f:	e8 88 f1 7f 06       	call   0x18680d0fc
   18000df74:	90                   	nop
   18000df75:	48 b9 01 00 00 00 01 	movabs rcx,0x100000001
   18000df7c:	00 00 00 
   18000df7f:	48 89 48 08          	mov    QWORD PTR [rax+0x8],rcx
   18000df83:	48 8d 0d 8e b2 16 08 	lea    rcx,[rip+0x816b28e]        # 0x188179218
   18000df8a:	48 89 08             	mov    QWORD PTR [rax],rcx
   18000df8d:	48 89 c1             	mov    rcx,rax
   18000df90:	48 83 c1 10          	add    rcx,0x10
   18000df94:	c6 40 10 00          	mov    BYTE PTR [rax+0x10],0x0
   18000df98:	48 89 0e             	mov    QWORD PTR [rsi],rcx
   18000df9b:	48 89 46 08          	mov    QWORD PTR [rsi+0x8],rax
   18000df9f:	48 c7 46 48 00 00 00 	mov    QWORD PTR [rsi+0x48],0x0
   18000dfa6:	00 
   18000dfa7:	4c 8b 65 e0          	mov    r12,QWORD PTR [rbp-0x20]
   18000dfab:	49 8b 4c 24 38       	mov    rcx,QWORD PTR [r12+0x38]
   18000dfb0:	48 85 c9             	test   rcx,rcx
   18000dfb3:	4c 8b 7d f0          	mov    r15,QWORD PTR [rbp-0x10]
   18000dfb7:	74 38                	je     0x18000dff1
   18000dfb9:	4c 39 e1             	cmp    rcx,r12
   18000dfbc:	74 06                	je     0x18000dfc4
   18000dfbe:	48 89 4e 48          	mov    QWORD PTR [rsi+0x48],rcx
   18000dfc2:	eb 24                	jmp    0x18000dfe8
   18000dfc4:	48 8d 56 10          	lea    rdx,[rsi+0x10]
   18000dfc8:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000dfcb:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18000dfce:	48 89 46 48          	mov    QWORD PTR [rsi+0x48],rax
   18000dfd2:	49 8b 4c 24 38       	mov    rcx,QWORD PTR [r12+0x38]
   18000dfd7:	48 85 c9             	test   rcx,rcx
   18000dfda:	74 15                	je     0x18000dff1
   18000dfdc:	4c 39 e1             	cmp    rcx,r12
   18000dfdf:	0f 95 c2             	setne  dl
   18000dfe2:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000dfe5:	ff 50 20             	call   QWORD PTR [rax+0x20]
   18000dfe8:	49 c7 44 24 38 00 00 	mov    QWORD PTR [r12+0x38],0x0
   18000dfef:	00 00 
   18000dff1:	48 c7 86 88 00 00 00 	mov    QWORD PTR [rsi+0x88],0x0
   18000dff8:	00 00 00 00 
   18000dffc:	49 8b 4f 38          	mov    rcx,QWORD PTR [r15+0x38]
   18000e000:	48 85 c9             	test   rcx,rcx
   18000e003:	4c 8b 75 e8          	mov    r14,QWORD PTR [rbp-0x18]
   18000e007:	74 3c                	je     0x18000e045
   18000e009:	4c 39 f9             	cmp    rcx,r15
   18000e00c:	74 09                	je     0x18000e017
   18000e00e:	48 89 8e 88 00 00 00 	mov    QWORD PTR [rsi+0x88],rcx
   18000e015:	eb 26                	jmp    0x18000e03d
   18000e017:	48 8d 56 50          	lea    rdx,[rsi+0x50]
   18000e01b:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000e01e:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18000e021:	48 89 86 88 00 00 00 	mov    QWORD PTR [rsi+0x88],rax
   18000e028:	49 8b 4f 38          	mov    rcx,QWORD PTR [r15+0x38]
   18000e02c:	48 85 c9             	test   rcx,rcx
   18000e02f:	74 14                	je     0x18000e045
   18000e031:	4c 39 f9             	cmp    rcx,r15
   18000e034:	0f 95 c2             	setne  dl
   18000e037:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000e03a:	ff 50 20             	call   QWORD PTR [rax+0x20]
   18000e03d:	49 c7 47 38 00 00 00 	mov    QWORD PTR [r15+0x38],0x0
   18000e044:	00 
   18000e045:	48 8b 5d 68          	mov    rbx,QWORD PTR [rbp+0x68]
   18000e049:	48 8b 7d 60          	mov    rdi,QWORD PTR [rbp+0x60]
   18000e04d:	48 c7 86 c8 00 00 00 	mov    QWORD PTR [rsi+0xc8],0x0
   18000e054:	00 00 00 00 
   18000e058:	49 8b 4e 38          	mov    rcx,QWORD PTR [r14+0x38]
   18000e05c:	48 85 c9             	test   rcx,rcx
   18000e05f:	74 3f                	je     0x18000e0a0
   18000e061:	4c 39 f1             	cmp    rcx,r14
   18000e064:	74 09                	je     0x18000e06f
   18000e066:	48 89 8e c8 00 00 00 	mov    QWORD PTR [rsi+0xc8],rcx
   18000e06d:	eb 29                	jmp    0x18000e098
   18000e06f:	48 8d 96 90 00 00 00 	lea    rdx,[rsi+0x90]
   18000e076:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000e079:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18000e07c:	48 89 86 c8 00 00 00 	mov    QWORD PTR [rsi+0xc8],rax
   18000e083:	49 8b 4e 38          	mov    rcx,QWORD PTR [r14+0x38]
   18000e087:	48 85 c9             	test   rcx,rcx
   18000e08a:	74 14                	je     0x18000e0a0
   18000e08c:	4c 39 f1             	cmp    rcx,r14
   18000e08f:	0f 95 c2             	setne  dl
   18000e092:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000e095:	ff 50 20             	call   QWORD PTR [rax+0x20]
   18000e098:	49 c7 46 38 00 00 00 	mov    QWORD PTR [r14+0x38],0x0
   18000e09f:	00 
   18000e0a0:	48 89 9e d0 00 00 00 	mov    QWORD PTR [rsi+0xd0],rbx
   18000e0a7:	0f 57 c0             	xorps  xmm0,xmm0
   18000e0aa:	0f 11 86 d8 00 00 00 	movups XMMWORD PTR [rsi+0xd8],xmm0
   18000e0b1:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   18000e0b4:	48 85 c0             	test   rax,rax
   18000e0b7:	74 45                	je     0x18000e0fe
   18000e0b9:	48 8b 4f 08          	mov    rcx,QWORD PTR [rdi+0x8]
   18000e0bd:	48 85 c9             	test   rcx,rcx
   18000e0c0:	74 0d                	je     0x18000e0cf
   18000e0c2:	f0 ff 41 08          	lock inc DWORD PTR [rcx+0x8]
   18000e0c6:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   18000e0c9:	48 8b 4f 08          	mov    rcx,QWORD PTR [rdi+0x8]
   18000e0cd:	eb 02                	jmp    0x18000e0d1
   18000e0cf:	31 c9                	xor    ecx,ecx
   18000e0d1:	48 89 06             	mov    QWORD PTR [rsi],rax
   18000e0d4:	48 8b 7e 08          	mov    rdi,QWORD PTR [rsi+0x8]
   18000e0d8:	48 89 4e 08          	mov    QWORD PTR [rsi+0x8],rcx
   18000e0dc:	48 85 ff             	test   rdi,rdi
   18000e0df:	74 1d                	je     0x18000e0fe
   18000e0e1:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   18000e0e5:	75 17                	jne    0x18000e0fe
   18000e0e7:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   18000e0ea:	48 89 f9             	mov    rcx,rdi
   18000e0ed:	ff 10                	call   QWORD PTR [rax]
   18000e0ef:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   18000e0f3:	75 09                	jne    0x18000e0fe
   18000e0f5:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   18000e0f8:	48 89 f9             	mov    rcx,rdi
   18000e0fb:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18000e0fe:	49 8b 4c 24 38       	mov    rcx,QWORD PTR [r12+0x38]
   18000e103:	48 85 c9             	test   rcx,rcx
   18000e106:	74 15                	je     0x18000e11d
   18000e108:	4c 39 e1             	cmp    rcx,r12
   18000e10b:	0f 95 c2             	setne  dl
   18000e10e:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000e111:	ff 50 20             	call   QWORD PTR [rax+0x20]
   18000e114:	49 c7 44 24 38 00 00 	mov    QWORD PTR [r12+0x38],0x0
   18000e11b:	00 00 
   18000e11d:	49 8b 4f 38          	mov    rcx,QWORD PTR [r15+0x38]
   18000e121:	48 85 c9             	test   rcx,rcx
   18000e124:	74 14                	je     0x18000e13a
   18000e126:	4c 39 f9             	cmp    rcx,r15
   18000e129:	0f 95 c2             	setne  dl
   18000e12c:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000e12f:	ff 50 20             	call   QWORD PTR [rax+0x20]
   18000e132:	49 c7 47 38 00 00 00 	mov    QWORD PTR [r15+0x38],0x0
   18000e139:	00 
   18000e13a:	49 8b 4e 38          	mov    rcx,QWORD PTR [r14+0x38]
   18000e13e:	48 85 c9             	test   rcx,rcx
   18000e141:	74 0c                	je     0x18000e14f
   18000e143:	4c 39 f1             	cmp    rcx,r14
   18000e146:	0f 95 c2             	setne  dl
   18000e149:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000e14c:	ff 50 20             	call   QWORD PTR [rax+0x20]
   18000e14f:	48 89 f0             	mov    rax,rsi
   18000e152:	48 83 c4 40          	add    rsp,0x40
   18000e156:	5b                   	pop    rbx
   18000e157:	5f                   	pop    rdi
   18000e158:	5e                   	pop    rsi
   18000e159:	41 5c                	pop    r12
   18000e15b:	41 5e                	pop    r14
   18000e15d:	41 5f                	pop    r15
   18000e15f:	5d                   	pop    rbp
   18000e160:	c3                   	ret
