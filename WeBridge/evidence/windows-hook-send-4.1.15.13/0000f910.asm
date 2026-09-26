
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

000000018000f910 <.text+0xe910>:
   18000f910:	55                   	push   rbp
   18000f911:	41 57                	push   r15
   18000f913:	41 56                	push   r14
   18000f915:	41 54                	push   r12
   18000f917:	56                   	push   rsi
   18000f918:	57                   	push   rdi
   18000f919:	53                   	push   rbx
   18000f91a:	48 83 ec 40          	sub    rsp,0x40
   18000f91e:	48 8d 6c 24 40       	lea    rbp,[rsp+0x40]
   18000f923:	48 c7 45 f8 fe ff ff 	mov    QWORD PTR [rbp-0x8],0xfffffffffffffffe
   18000f92a:	ff 
   18000f92b:	4c 89 4d e8          	mov    QWORD PTR [rbp-0x18],r9
   18000f92f:	4c 89 45 f0          	mov    QWORD PTR [rbp-0x10],r8
   18000f933:	48 89 55 e0          	mov    QWORD PTR [rbp-0x20],rdx
   18000f937:	48 89 ce             	mov    rsi,rcx
   18000f93a:	b9 18 00 00 00       	mov    ecx,0x18
   18000f93f:	e8 58 bf 49 07       	call   0x1874ab89c
   18000f944:	90                   	nop
   18000f945:	48 b9 01 00 00 00 01 	movabs rcx,0x100000001
   18000f94c:	00 00 00 
   18000f94f:	48 89 48 08          	mov    QWORD PTR [rax+0x8],rcx
   18000f953:	48 8d 0d ee 76 d3 08 	lea    rcx,[rip+0x8d376ee]        # 0x188d47048
   18000f95a:	48 89 08             	mov    QWORD PTR [rax],rcx
   18000f95d:	48 89 c1             	mov    rcx,rax
   18000f960:	48 83 c1 10          	add    rcx,0x10
   18000f964:	c6 40 10 00          	mov    BYTE PTR [rax+0x10],0x0
   18000f968:	48 89 0e             	mov    QWORD PTR [rsi],rcx
   18000f96b:	48 89 46 08          	mov    QWORD PTR [rsi+0x8],rax
   18000f96f:	48 c7 46 48 00 00 00 	mov    QWORD PTR [rsi+0x48],0x0
   18000f976:	00 
   18000f977:	4c 8b 65 e0          	mov    r12,QWORD PTR [rbp-0x20]
   18000f97b:	49 8b 4c 24 38       	mov    rcx,QWORD PTR [r12+0x38]
   18000f980:	48 85 c9             	test   rcx,rcx
   18000f983:	4c 8b 7d f0          	mov    r15,QWORD PTR [rbp-0x10]
   18000f987:	74 38                	je     0x18000f9c1
   18000f989:	4c 39 e1             	cmp    rcx,r12
   18000f98c:	74 06                	je     0x18000f994
   18000f98e:	48 89 4e 48          	mov    QWORD PTR [rsi+0x48],rcx
   18000f992:	eb 24                	jmp    0x18000f9b8
   18000f994:	48 8d 56 10          	lea    rdx,[rsi+0x10]
   18000f998:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000f99b:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18000f99e:	48 89 46 48          	mov    QWORD PTR [rsi+0x48],rax
   18000f9a2:	49 8b 4c 24 38       	mov    rcx,QWORD PTR [r12+0x38]
   18000f9a7:	48 85 c9             	test   rcx,rcx
   18000f9aa:	74 15                	je     0x18000f9c1
   18000f9ac:	4c 39 e1             	cmp    rcx,r12
   18000f9af:	0f 95 c2             	setne  dl
   18000f9b2:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000f9b5:	ff 50 20             	call   QWORD PTR [rax+0x20]
   18000f9b8:	49 c7 44 24 38 00 00 	mov    QWORD PTR [r12+0x38],0x0
   18000f9bf:	00 00 
   18000f9c1:	48 c7 86 88 00 00 00 	mov    QWORD PTR [rsi+0x88],0x0
   18000f9c8:	00 00 00 00 
   18000f9cc:	49 8b 4f 38          	mov    rcx,QWORD PTR [r15+0x38]
   18000f9d0:	48 85 c9             	test   rcx,rcx
   18000f9d3:	4c 8b 75 e8          	mov    r14,QWORD PTR [rbp-0x18]
   18000f9d7:	74 3c                	je     0x18000fa15
   18000f9d9:	4c 39 f9             	cmp    rcx,r15
   18000f9dc:	74 09                	je     0x18000f9e7
   18000f9de:	48 89 8e 88 00 00 00 	mov    QWORD PTR [rsi+0x88],rcx
   18000f9e5:	eb 26                	jmp    0x18000fa0d
   18000f9e7:	48 8d 56 50          	lea    rdx,[rsi+0x50]
   18000f9eb:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000f9ee:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18000f9f1:	48 89 86 88 00 00 00 	mov    QWORD PTR [rsi+0x88],rax
   18000f9f8:	49 8b 4f 38          	mov    rcx,QWORD PTR [r15+0x38]
   18000f9fc:	48 85 c9             	test   rcx,rcx
   18000f9ff:	74 14                	je     0x18000fa15
   18000fa01:	4c 39 f9             	cmp    rcx,r15
   18000fa04:	0f 95 c2             	setne  dl
   18000fa07:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000fa0a:	ff 50 20             	call   QWORD PTR [rax+0x20]
   18000fa0d:	49 c7 47 38 00 00 00 	mov    QWORD PTR [r15+0x38],0x0
   18000fa14:	00 
   18000fa15:	48 8b 5d 68          	mov    rbx,QWORD PTR [rbp+0x68]
   18000fa19:	48 8b 7d 60          	mov    rdi,QWORD PTR [rbp+0x60]
   18000fa1d:	48 c7 86 c8 00 00 00 	mov    QWORD PTR [rsi+0xc8],0x0
   18000fa24:	00 00 00 00 
   18000fa28:	49 8b 4e 38          	mov    rcx,QWORD PTR [r14+0x38]
   18000fa2c:	48 85 c9             	test   rcx,rcx
   18000fa2f:	74 3f                	je     0x18000fa70
   18000fa31:	4c 39 f1             	cmp    rcx,r14
   18000fa34:	74 09                	je     0x18000fa3f
   18000fa36:	48 89 8e c8 00 00 00 	mov    QWORD PTR [rsi+0xc8],rcx
   18000fa3d:	eb 29                	jmp    0x18000fa68
   18000fa3f:	48 8d 96 90 00 00 00 	lea    rdx,[rsi+0x90]
   18000fa46:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000fa49:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18000fa4c:	48 89 86 c8 00 00 00 	mov    QWORD PTR [rsi+0xc8],rax
   18000fa53:	49 8b 4e 38          	mov    rcx,QWORD PTR [r14+0x38]
   18000fa57:	48 85 c9             	test   rcx,rcx
   18000fa5a:	74 14                	je     0x18000fa70
   18000fa5c:	4c 39 f1             	cmp    rcx,r14
   18000fa5f:	0f 95 c2             	setne  dl
   18000fa62:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000fa65:	ff 50 20             	call   QWORD PTR [rax+0x20]
   18000fa68:	49 c7 46 38 00 00 00 	mov    QWORD PTR [r14+0x38],0x0
   18000fa6f:	00 
   18000fa70:	48 89 9e d0 00 00 00 	mov    QWORD PTR [rsi+0xd0],rbx
   18000fa77:	0f 57 c0             	xorps  xmm0,xmm0
   18000fa7a:	0f 11 86 d8 00 00 00 	movups XMMWORD PTR [rsi+0xd8],xmm0
   18000fa81:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   18000fa84:	48 85 c0             	test   rax,rax
   18000fa87:	74 45                	je     0x18000face
   18000fa89:	48 8b 4f 08          	mov    rcx,QWORD PTR [rdi+0x8]
   18000fa8d:	48 85 c9             	test   rcx,rcx
   18000fa90:	74 0d                	je     0x18000fa9f
   18000fa92:	f0 ff 41 08          	lock inc DWORD PTR [rcx+0x8]
   18000fa96:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   18000fa99:	48 8b 4f 08          	mov    rcx,QWORD PTR [rdi+0x8]
   18000fa9d:	eb 02                	jmp    0x18000faa1
   18000fa9f:	31 c9                	xor    ecx,ecx
   18000faa1:	48 89 06             	mov    QWORD PTR [rsi],rax
   18000faa4:	48 8b 7e 08          	mov    rdi,QWORD PTR [rsi+0x8]
   18000faa8:	48 89 4e 08          	mov    QWORD PTR [rsi+0x8],rcx
   18000faac:	48 85 ff             	test   rdi,rdi
   18000faaf:	74 1d                	je     0x18000face
   18000fab1:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   18000fab5:	75 17                	jne    0x18000face
   18000fab7:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   18000faba:	48 89 f9             	mov    rcx,rdi
   18000fabd:	ff 10                	call   QWORD PTR [rax]
   18000fabf:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   18000fac3:	75 09                	jne    0x18000face
   18000fac5:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   18000fac8:	48 89 f9             	mov    rcx,rdi
   18000facb:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18000face:	49 8b 4c 24 38       	mov    rcx,QWORD PTR [r12+0x38]
   18000fad3:	48 85 c9             	test   rcx,rcx
   18000fad6:	74 0c                	je     0x18000fae4
   18000fad8:	4c 39 e1             	cmp    rcx,r12
   18000fadb:	0f 95 c2             	setne  dl
   18000fade:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000fae1:	ff 50 20             	call   QWORD PTR [rax+0x20]
   18000fae4:	49 8b 4f 38          	mov    rcx,QWORD PTR [r15+0x38]
   18000fae8:	48 85 c9             	test   rcx,rcx
   18000faeb:	74 0c                	je     0x18000faf9
   18000faed:	4c 39 f9             	cmp    rcx,r15
   18000faf0:	0f 95 c2             	setne  dl
   18000faf3:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000faf6:	ff 50 20             	call   QWORD PTR [rax+0x20]
   18000faf9:	49 8b 4e 38          	mov    rcx,QWORD PTR [r14+0x38]
   18000fafd:	48 85 c9             	test   rcx,rcx
   18000fb00:	74 0c                	je     0x18000fb0e
   18000fb02:	4c 39 f1             	cmp    rcx,r14
   18000fb05:	0f 95 c2             	setne  dl
   18000fb08:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000fb0b:	ff 50 20             	call   QWORD PTR [rax+0x20]
   18000fb0e:	48 89 f0             	mov    rax,rsi
   18000fb11:	48 83 c4 40          	add    rsp,0x40
   18000fb15:	5b                   	pop    rbx
   18000fb16:	5f                   	pop    rdi
   18000fb17:	5e                   	pop    rsi
   18000fb18:	41 5c                	pop    r12
   18000fb1a:	41 5e                	pop    r14
   18000fb1c:	41 5f                	pop    r15
   18000fb1e:	5d                   	pop    rbp
   18000fb1f:	c3                   	ret
