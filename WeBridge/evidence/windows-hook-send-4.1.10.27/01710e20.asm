
.research\wechat-4.1.10.27-reference\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000181710e20 <.text+0x170fe20>:
   181710e20:	55                   	push   rbp
   181710e21:	41 57                	push   r15
   181710e23:	41 56                	push   r14
   181710e25:	56                   	push   rsi
   181710e26:	57                   	push   rdi
   181710e27:	53                   	push   rbx
   181710e28:	48 81 ec 68 03 00 00 	sub    rsp,0x368
   181710e2f:	48 8d ac 24 80 00 00 	lea    rbp,[rsp+0x80]
   181710e36:	00 
   181710e37:	0f 29 b5 d0 02 00 00 	movaps XMMWORD PTR [rbp+0x2d0],xmm6
   181710e3e:	48 c7 85 c8 02 00 00 	mov    QWORD PTR [rbp+0x2c8],0xfffffffffffffffe
   181710e45:	fe ff ff ff 
   181710e49:	4c 89 85 c0 02 00 00 	mov    QWORD PTR [rbp+0x2c0],r8
   181710e50:	48 89 d6             	mov    rsi,rdx
   181710e53:	48 89 cf             	mov    rdi,rcx
   181710e56:	0f 28 35 63 72 a6 06 	movaps xmm6,XMMWORD PTR [rip+0x6a67263]        # 0x1881780c0
   181710e5d:	0f 29 b5 a0 00 00 00 	movaps XMMWORD PTR [rbp+0xa0],xmm6
   181710e64:	48 8d 15 f8 ba de 06 	lea    rdx,[rip+0x6debaf8]        # 0x1884fc963
   181710e6b:	4c 8d 05 83 9b de 06 	lea    r8,[rip+0x6de9b83]        # 0x1884fa9f5
   181710e72:	48 8d 8d 30 01 00 00 	lea    rcx,[rbp+0x130]
   181710e79:	41 b9 93 0d 00 00    	mov    r9d,0xd93
   181710e7f:	e8 bc bf a7 fe       	call   0x18018ce40
   181710e84:	90                   	nop
   181710e85:	c7 85 a0 00 00 00 02 	mov    DWORD PTR [rbp+0xa0],0x2
   181710e8c:	00 00 00 
   181710e8f:	48 c7 85 b0 00 00 00 	mov    QWORD PTR [rbp+0xb0],0x0
   181710e96:	00 00 00 00 
   181710e9a:	0f 28 85 30 01 00 00 	movaps xmm0,XMMWORD PTR [rbp+0x130]
   181710ea1:	0f 11 85 b8 00 00 00 	movups XMMWORD PTR [rbp+0xb8],xmm0
   181710ea8:	0f 57 c0             	xorps  xmm0,xmm0
   181710eab:	0f 11 85 c8 00 00 00 	movups XMMWORD PTR [rbp+0xc8],xmm0
   181710eb2:	48 c7 85 d8 00 00 00 	mov    QWORD PTR [rbp+0xd8],0x0
   181710eb9:	00 00 00 00 
   181710ebd:	48 c7 85 e0 00 00 00 	mov    QWORD PTR [rbp+0xe0],0xf
   181710ec4:	0f 00 00 00 
   181710ec8:	e8 03 8a 23 ff       	call   0x1809498d0
   181710ecd:	90                   	nop
   181710ece:	48 89 85 a8 00 00 00 	mov    QWORD PTR [rbp+0xa8],rax
   181710ed5:	48 83 bd e0 00 00 00 	cmp    QWORD PTR [rbp+0xe0],0x1f
   181710edc:	1f 
   181710edd:	73 1b                	jae    0x181710efa
   181710edf:	4c 8d 0d 2a 38 de 06 	lea    r9,[rip+0x6de382a]        # 0x1884f4710
   181710ee6:	ba 1f 00 00 00       	mov    edx,0x1f
   181710eeb:	48 8d 8d c8 00 00 00 	lea    rcx,[rbp+0xc8]
   181710ef2:	e8 79 35 94 fe       	call   0x180054470
   181710ef7:	90                   	nop
   181710ef8:	eb 2b                	jmp    0x181710f25
   181710efa:	48 8b 85 c8 00 00 00 	mov    rax,QWORD PTR [rbp+0xc8]
   181710f01:	48 c7 85 d8 00 00 00 	mov    QWORD PTR [rbp+0xd8],0x1f
   181710f08:	1f 00 00 00 
   181710f0c:	0f 10 05 0c 38 de 06 	movups xmm0,XMMWORD PTR [rip+0x6de380c]        # 0x1884f471f
   181710f13:	0f 11 40 0f          	movups XMMWORD PTR [rax+0xf],xmm0
   181710f17:	0f 10 05 f2 37 de 06 	movups xmm0,XMMWORD PTR [rip+0x6de37f2]        # 0x1884f4710
   181710f1e:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   181710f21:	c6 40 1f 00          	mov    BYTE PTR [rax+0x1f],0x0
   181710f25:	48 8b 9d c0 02 00 00 	mov    rbx,QWORD PTR [rbp+0x2c0]
   181710f2c:	48 8b 0b             	mov    rcx,QWORD PTR [rbx]
   181710f2f:	ba 01 00 00 00       	mov    edx,0x1
   181710f34:	e8 07 d0 f7 01       	call   0x18368df40
   181710f39:	90                   	nop
   181710f3a:	48 b8 aa aa aa aa aa 	movabs rax,0xaaaaaaaaaaaaaaaa
   181710f41:	aa aa aa 
   181710f44:	48 89 85 b0 02 00 00 	mov    QWORD PTR [rbp+0x2b0],rax
   181710f4b:	0f 29 b5 a0 02 00 00 	movaps XMMWORD PTR [rbp+0x2a0],xmm6
   181710f52:	0f 29 b5 90 02 00 00 	movaps XMMWORD PTR [rbp+0x290],xmm6
   181710f59:	0f 29 b5 80 02 00 00 	movaps XMMWORD PTR [rbp+0x280],xmm6
   181710f60:	0f 57 c0             	xorps  xmm0,xmm0
   181710f63:	0f 29 85 f0 00 00 00 	movaps XMMWORD PTR [rbp+0xf0],xmm0
   181710f6a:	48 8b 43 08          	mov    rax,QWORD PTR [rbx+0x8]
   181710f6e:	48 85 c0             	test   rax,rax
   181710f71:	74 0a                	je     0x181710f7d
   181710f73:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   181710f77:	48 8b 43 08          	mov    rax,QWORD PTR [rbx+0x8]
   181710f7b:	eb 02                	jmp    0x181710f7f
   181710f7d:	31 c0                	xor    eax,eax
   181710f7f:	48 8b 0b             	mov    rcx,QWORD PTR [rbx]
   181710f82:	48 89 8d f0 00 00 00 	mov    QWORD PTR [rbp+0xf0],rcx
   181710f89:	48 89 85 f8 00 00 00 	mov    QWORD PTR [rbp+0xf8],rax
   181710f90:	48 8d 95 30 01 00 00 	lea    rdx,[rbp+0x130]
   181710f97:	4c 8d 85 f0 00 00 00 	lea    r8,[rbp+0xf0]
   181710f9e:	48 89 f9             	mov    rcx,rdi
   181710fa1:	e8 8a 15 00 00       	call   0x181712530
   181710fa6:	90                   	nop
   181710fa7:	48 8d 9d 00 02 00 00 	lea    rbx,[rbp+0x200]
   181710fae:	48 8d 95 80 02 00 00 	lea    rdx,[rbp+0x280]
   181710fb5:	4c 8d 85 30 01 00 00 	lea    r8,[rbp+0x130]
   181710fbc:	48 89 d9             	mov    rcx,rbx
   181710fbf:	e8 2c f5 fa ff       	call   0x1816c04f0
   181710fc4:	90                   	nop
   181710fc5:	4c 8b b5 38 01 00 00 	mov    r14,QWORD PTR [rbp+0x138]
   181710fcc:	4d 85 f6             	test   r14,r14
   181710fcf:	74 1f                	je     0x181710ff0
   181710fd1:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   181710fd6:	75 18                	jne    0x181710ff0
   181710fd8:	49 8b 06             	mov    rax,QWORD PTR [r14]
   181710fdb:	4c 89 f1             	mov    rcx,r14
   181710fde:	ff 10                	call   QWORD PTR [rax]
   181710fe0:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   181710fe5:	75 09                	jne    0x181710ff0
   181710fe7:	49 8b 06             	mov    rax,QWORD PTR [r14]
   181710fea:	4c 89 f1             	mov    rcx,r14
   181710fed:	ff 50 08             	call   QWORD PTR [rax+0x8]
   181710ff0:	48 8b 8d a8 02 00 00 	mov    rcx,QWORD PTR [rbp+0x2a8]
   181710ff7:	48 8b 85 c0 02 00 00 	mov    rax,QWORD PTR [rbp+0x2c0]
   181710ffe:	48 8b 00             	mov    rax,QWORD PTR [rax]
   181711001:	0f 57 c0             	xorps  xmm0,xmm0
   181711004:	0f 29 85 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm0
   18171100b:	48 8b 50 20          	mov    rdx,QWORD PTR [rax+0x20]
   18171100f:	48 85 d2             	test   rdx,rdx
   181711012:	74 0a                	je     0x18171101e
   181711014:	f0 ff 42 08          	lock inc DWORD PTR [rdx+0x8]
   181711018:	48 8b 50 20          	mov    rdx,QWORD PTR [rax+0x20]
   18171101c:	eb 02                	jmp    0x181711020
   18171101e:	31 d2                	xor    edx,edx
   181711020:	48 8b 40 18          	mov    rax,QWORD PTR [rax+0x18]
   181711024:	48 89 85 00 01 00 00 	mov    QWORD PTR [rbp+0x100],rax
   18171102b:	48 89 95 08 01 00 00 	mov    QWORD PTR [rbp+0x108],rdx
   181711032:	48 8d 95 00 01 00 00 	lea    rdx,[rbp+0x100]
   181711039:	e8 02 34 00 00       	call   0x181714440
   18171103e:	90                   	nop
   18171103f:	48 8b 85 c0 02 00 00 	mov    rax,QWORD PTR [rbp+0x2c0]
   181711046:	48 8b 08             	mov    rcx,QWORD PTR [rax]
   181711049:	48 83 c1 78          	add    rcx,0x78
   18171104d:	48 8d 95 80 02 00 00 	lea    rdx,[rbp+0x280]
   181711054:	e8 e7 35 00 00       	call   0x181714640
   181711059:	90                   	nop
   18171105a:	48 8b 85 c0 02 00 00 	mov    rax,QWORD PTR [rbp+0x2c0]
   181711061:	48 8b 08             	mov    rcx,QWORD PTR [rax]
   181711064:	4c 8d b5 30 01 00 00 	lea    r14,[rbp+0x130]
   18171106b:	4c 89 f2             	mov    rdx,r14
   18171106e:	e8 5d ba f7 01       	call   0x18368cad0
   181711073:	90                   	nop
   181711074:	0f 57 c0             	xorps  xmm0,xmm0
   181711077:	0f 29 85 10 02 00 00 	movaps XMMWORD PTR [rbp+0x210],xmm0
   18171107e:	0f 29 85 00 02 00 00 	movaps XMMWORD PTR [rbp+0x200],xmm0
   181711085:	b9 20 00 00 00       	mov    ecx,0x20
   18171108a:	e8 6d c0 0f 05       	call   0x18680d0fc
   18171108f:	90                   	nop
   181711090:	48 89 85 00 02 00 00 	mov    QWORD PTR [rbp+0x200],rax
   181711097:	48 c7 85 10 02 00 00 	mov    QWORD PTR [rbp+0x210],0x15
   18171109e:	15 00 00 00 
   1817110a2:	48 c7 85 18 02 00 00 	mov    QWORD PTR [rbp+0x218],0x1f
   1817110a9:	1f 00 00 00 
   1817110ad:	0f 10 05 7c 36 de 06 	movups xmm0,XMMWORD PTR [rip+0x6de367c]        # 0x1884f4730
   1817110b4:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   1817110b7:	48 b9 73 61 67 65 54 	movabs rcx,0x62446f5465676173
   1817110be:	6f 44 62 
   1817110c1:	48 89 48 0d          	mov    QWORD PTR [rax+0xd],rcx
   1817110c5:	c6 40 15 00          	mov    BYTE PTR [rax+0x15],0x0
   1817110c9:	4c 8b bd 40 01 00 00 	mov    r15,QWORD PTR [rbp+0x140]
   1817110d0:	48 83 bd 48 01 00 00 	cmp    QWORD PTR [rbp+0x148],0x10
   1817110d7:	10 
   1817110d8:	72 07                	jb     0x1817110e1
   1817110da:	4c 8b b5 30 01 00 00 	mov    r14,QWORD PTR [rbp+0x130]
   1817110e1:	49 83 ff 0a          	cmp    r15,0xa
   1817110e5:	76 1d                	jbe    0x181711104
   1817110e7:	4c 89 7c 24 20       	mov    QWORD PTR [rsp+0x20],r15
   1817110ec:	48 8d 8d 00 02 00 00 	lea    rcx,[rbp+0x200]
   1817110f3:	4c 89 fa             	mov    rdx,r15
   1817110f6:	4d 89 f1             	mov    r9,r14
   1817110f9:	e8 f2 80 8f fe       	call   0x1800091f0
   1817110fe:	90                   	nop
   1817110ff:	48 89 c3             	mov    rbx,rax
   181711102:	eb 26                	jmp    0x18171112a
   181711104:	48 89 c1             	mov    rcx,rax
   181711107:	48 83 c1 15          	add    rcx,0x15
   18171110b:	49 8d 57 15          	lea    rdx,[r15+0x15]
   18171110f:	48 89 95 10 02 00 00 	mov    QWORD PTR [rbp+0x210],rdx
   181711116:	4c 89 f2             	mov    rdx,r14
   181711119:	4d 89 f8             	mov    r8,r15
   18171111c:	49 89 c6             	mov    r14,rax
   18171111f:	e8 ac 4f 18 05       	call   0x1868960d0
   181711124:	43 c6 44 3e 15 00    	mov    BYTE PTR [r14+r15*1+0x15],0x0
   18171112a:	0f 10 03             	movups xmm0,XMMWORD PTR [rbx]
   18171112d:	0f 10 4b 10          	movups xmm1,XMMWORD PTR [rbx+0x10]
   181711131:	0f 29 4d d0          	movaps XMMWORD PTR [rbp-0x30],xmm1
   181711135:	0f 29 45 c0          	movaps XMMWORD PTR [rbp-0x40],xmm0
   181711139:	48 c7 43 10 00 00 00 	mov    QWORD PTR [rbx+0x10],0x0
   181711140:	00 
   181711141:	48 c7 43 18 0f 00 00 	mov    QWORD PTR [rbx+0x18],0xf
   181711148:	00 
   181711149:	c6 03 00             	mov    BYTE PTR [rbx],0x0
   18171114c:	48 8d 8d a0 00 00 00 	lea    rcx,[rbp+0xa0]
   181711153:	48 8d 55 c0          	lea    rdx,[rbp-0x40]
   181711157:	41 b8 32 00 00 00    	mov    r8d,0x32
   18171115d:	e8 3e 91 81 ff       	call   0x180f2a2a0
   181711162:	90                   	nop
   181711163:	48 8b 85 18 02 00 00 	mov    rax,QWORD PTR [rbp+0x218]
   18171116a:	48 83 f8 10          	cmp    rax,0x10
   18171116e:	48 8b 9d c0 02 00 00 	mov    rbx,QWORD PTR [rbp+0x2c0]
   181711175:	72 38                	jb     0x1817111af
   181711177:	48 8b 8d 00 02 00 00 	mov    rcx,QWORD PTR [rbp+0x200]
   18171117e:	48 8d 50 01          	lea    rdx,[rax+0x1]
   181711182:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   181711189:	72 1f                	jb     0x1817111aa
   18171118b:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18171118f:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   181711193:	4c 29 c1             	sub    rcx,r8
   181711196:	48 83 f9 20          	cmp    rcx,0x20
   18171119a:	0f 83 d7 0d 00 00    	jae    0x181711f77
   1817111a0:	48 83 c0 28          	add    rax,0x28
   1817111a4:	48 89 c2             	mov    rdx,rax
   1817111a7:	4c 89 c1             	mov    rcx,r8
   1817111aa:	e8 91 bf 0f 05       	call   0x18680d140
   1817111af:	48 8b 85 48 01 00 00 	mov    rax,QWORD PTR [rbp+0x148]
   1817111b6:	48 83 f8 10          	cmp    rax,0x10
   1817111ba:	72 38                	jb     0x1817111f4
   1817111bc:	48 8b 8d 30 01 00 00 	mov    rcx,QWORD PTR [rbp+0x130]
   1817111c3:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1817111c7:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1817111ce:	72 1f                	jb     0x1817111ef
   1817111d0:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1817111d4:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1817111d8:	4c 29 c1             	sub    rcx,r8
   1817111db:	48 83 f9 20          	cmp    rcx,0x20
   1817111df:	0f 83 92 0d 00 00    	jae    0x181711f77
   1817111e5:	48 83 c0 28          	add    rax,0x28
   1817111e9:	48 89 c2             	mov    rdx,rax
   1817111ec:	4c 89 c1             	mov    rcx,r8
   1817111ef:	e8 4c bf 0f 05       	call   0x18680d140
   1817111f4:	8b 85 84 02 00 00    	mov    eax,DWORD PTR [rbp+0x284]
   1817111fa:	0b 85 80 02 00 00    	or     eax,DWORD PTR [rbp+0x280]
   181711200:	0f 84 6f 02 00 00    	je     0x181711475
   181711206:	b9 04 00 00 00       	mov    ecx,0x4
   18171120b:	e8 30 75 95 fe       	call   0x180068740
   181711210:	85 c0                	test   eax,eax
   181711212:	0f 84 2e 02 00 00    	je     0x181711446
   181711218:	48 8d bd c0 01 00 00 	lea    rdi,[rbp+0x1c0]
   18171121f:	48 89 f9             	mov    rcx,rdi
   181711222:	e8 49 76 95 fe       	call   0x180068870
   181711227:	90                   	nop
   181711228:	48 83 bd d8 01 00 00 	cmp    QWORD PTR [rbp+0x1d8],0x10
   18171122f:	10 
   181711230:	72 07                	jb     0x181711239
   181711232:	48 8b bd c0 01 00 00 	mov    rdi,QWORD PTR [rbp+0x1c0]
   181711239:	48 8d 05 6e 1a df 06 	lea    rax,[rip+0x6df1a6e]        # 0x188502cae
   181711240:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   181711245:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   18171124c:	00 00 
   18171124e:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   181711253:	c7 44 24 28 9c 0d 00 	mov    DWORD PTR [rsp+0x28],0xd9c
   18171125a:	00 
   18171125b:	4c 8d 0d 93 97 de 06 	lea    r9,[rip+0x6de9793]        # 0x1884fa9f5
   181711262:	48 8d 8d 30 01 00 00 	lea    rcx,[rbp+0x130]
   181711269:	ba 04 00 00 00       	mov    edx,0x4
   18171126e:	49 89 f8             	mov    r8,rdi
   181711271:	e8 4a 79 95 fe       	call   0x180068bc0
   181711276:	90                   	nop
   181711277:	48 8b 85 c0 02 00 00 	mov    rax,QWORD PTR [rbp+0x2c0]
   18171127e:	48 8b 08             	mov    rcx,QWORD PTR [rax]
   181711281:	e8 aa cc f7 01       	call   0x18368df30
   181711286:	90                   	nop
   181711287:	48 c7 45 50 00 00 00 	mov    QWORD PTR [rbp+0x50],0x0
   18171128e:	00 
   18171128f:	b9 07 00 00 00       	mov    ecx,0x7
   181711294:	48 8d 55 57          	lea    rdx,[rbp+0x57]
   181711298:	41 b8 cd cc cc cc    	mov    r8d,0xcccccccd
   18171129e:	4c 8d 0d e5 72 a6 06 	lea    r9,[rip+0x6a672e5]        # 0x18817858a
   1817112a5:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
   1817112ac:	00 00 00 00 
   1817112b0:	41 89 c2             	mov    r10d,eax
   1817112b3:	4d 0f af d0          	imul   r10,r8
   1817112b7:	49 c1 ea 23          	shr    r10,0x23
   1817112bb:	47 8d 1c 12          	lea    r11d,[r10+r10*1]
   1817112bf:	47 8d 1c 9b          	lea    r11d,[r11+r11*4]
   1817112c3:	41 f7 db             	neg    r11d
   1817112c6:	41 01 c3             	add    r11d,eax
   1817112c9:	41 83 c3 23          	add    r11d,0x23
   1817112cd:	47 0f b6 1c 0b       	movzx  r11d,BYTE PTR [r11+r9*1]
   1817112d2:	44 88 5a 01          	mov    BYTE PTR [rdx+0x1],r11b
   1817112d6:	48 ff c2             	inc    rdx
   1817112d9:	48 ff c1             	inc    rcx
   1817112dc:	83 f8 09             	cmp    eax,0x9
   1817112df:	44 89 d0             	mov    eax,r10d
   1817112e2:	77 cc                	ja     0x1817112b0
   1817112e4:	48 8d 45 58          	lea    rax,[rbp+0x58]
   1817112e8:	c6 42 01 00          	mov    BYTE PTR [rdx+0x1],0x0
   1817112ec:	48 83 f9 09          	cmp    rcx,0x9
   1817112f0:	4c 8b 95 c0 02 00 00 	mov    r10,QWORD PTR [rbp+0x2c0]
   1817112f7:	72 23                	jb     0x18171131c
   1817112f9:	48 8d 4d 59          	lea    rcx,[rbp+0x59]
   1817112fd:	0f 1f 00             	nop    DWORD PTR [rax]
   181711300:	44 0f b6 02          	movzx  r8d,BYTE PTR [rdx]
   181711304:	44 0f b6 49 ff       	movzx  r9d,BYTE PTR [rcx-0x1]
   181711309:	44 88 0a             	mov    BYTE PTR [rdx],r9b
   18171130c:	48 ff ca             	dec    rdx
   18171130f:	44 88 41 ff          	mov    BYTE PTR [rcx-0x1],r8b
   181711313:	48 39 d1             	cmp    rcx,rdx
   181711316:	48 8d 49 01          	lea    rcx,[rcx+0x1]
   18171131a:	72 e4                	jb     0x181711300
   18171131c:	48 89 45 50          	mov    QWORD PTR [rbp+0x50],rax
   181711320:	49 8b 0a             	mov    rcx,QWORD PTR [r10]
   181711323:	48 8d bd e0 01 00 00 	lea    rdi,[rbp+0x1e0]
   18171132a:	48 89 fa             	mov    rdx,rdi
   18171132d:	e8 9e b7 f7 01       	call   0x18368cad0
   181711332:	90                   	nop
   181711333:	48 83 bd f8 01 00 00 	cmp    QWORD PTR [rbp+0x1f8],0x10
   18171133a:	10 
   18171133b:	72 07                	jb     0x181711344
   18171133d:	48 8b bd e0 01 00 00 	mov    rdi,QWORD PTR [rbp+0x1e0]
   181711344:	48 89 7d 00          	mov    QWORD PTR [rbp+0x0],rdi
   181711348:	c6 45 08 00          	mov    BYTE PTR [rbp+0x8],0x0
   18171134c:	0f 57 c0             	xorps  xmm0,xmm0
   18171134f:	0f 29 85 70 02 00 00 	movaps XMMWORD PTR [rbp+0x270],xmm0
   181711356:	0f 29 85 60 02 00 00 	movaps XMMWORD PTR [rbp+0x260],xmm0
   18171135d:	0f 29 85 50 02 00 00 	movaps XMMWORD PTR [rbp+0x250],xmm0
   181711364:	0f 29 85 40 02 00 00 	movaps XMMWORD PTR [rbp+0x240],xmm0
   18171136b:	0f 29 85 30 02 00 00 	movaps XMMWORD PTR [rbp+0x230],xmm0
   181711372:	0f 29 85 20 02 00 00 	movaps XMMWORD PTR [rbp+0x220],xmm0
   181711379:	0f 29 85 10 02 00 00 	movaps XMMWORD PTR [rbp+0x210],xmm0
   181711380:	48 89 e8             	mov    rax,rbp
   181711383:	48 89 85 00 02 00 00 	mov    QWORD PTR [rbp+0x200],rax
   18171138a:	48 8d 45 50          	lea    rax,[rbp+0x50]
   18171138e:	48 89 85 08 02 00 00 	mov    QWORD PTR [rbp+0x208],rax
   181711395:	48 8d 15 7a 24 df 06 	lea    rdx,[rip+0x6df247a]        # 0x188503816
   18171139c:	48 8d 8d 30 01 00 00 	lea    rcx,[rbp+0x130]
   1817113a3:	4c 8d 85 00 02 00 00 	lea    r8,[rbp+0x200]
   1817113aa:	e8 b1 7d 95 fe       	call   0x180069160
   1817113af:	90                   	nop
   1817113b0:	48 8b 85 f8 01 00 00 	mov    rax,QWORD PTR [rbp+0x1f8]
   1817113b7:	48 83 f8 10          	cmp    rax,0x10
   1817113bb:	72 38                	jb     0x1817113f5
   1817113bd:	48 8b 8d e0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1e0]
   1817113c4:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1817113c8:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1817113cf:	72 1f                	jb     0x1817113f0
   1817113d1:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1817113d5:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1817113d9:	4c 29 c1             	sub    rcx,r8
   1817113dc:	48 83 f9 20          	cmp    rcx,0x20
   1817113e0:	0f 83 91 0b 00 00    	jae    0x181711f77
   1817113e6:	48 83 c0 28          	add    rax,0x28
   1817113ea:	48 89 c2             	mov    rdx,rax
   1817113ed:	4c 89 c1             	mov    rcx,r8
   1817113f0:	e8 4b bd 0f 05       	call   0x18680d140
   1817113f5:	48 8d 8d 30 01 00 00 	lea    rcx,[rbp+0x130]
   1817113fc:	e8 bf 78 95 fe       	call   0x180068cc0
   181711401:	48 8b 85 d8 01 00 00 	mov    rax,QWORD PTR [rbp+0x1d8]
   181711408:	48 83 f8 10          	cmp    rax,0x10
   18171140c:	72 38                	jb     0x181711446
   18171140e:	48 8b 8d c0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1c0]
   181711415:	48 8d 50 01          	lea    rdx,[rax+0x1]
   181711419:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   181711420:	72 1f                	jb     0x181711441
   181711422:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   181711426:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18171142a:	4c 29 c1             	sub    rcx,r8
   18171142d:	48 83 f9 20          	cmp    rcx,0x20
   181711431:	0f 83 40 0b 00 00    	jae    0x181711f77
   181711437:	48 83 c0 28          	add    rax,0x28
   18171143b:	48 89 c2             	mov    rdx,rax
   18171143e:	4c 89 c1             	mov    rcx,r8
   181711441:	e8 fa bc 0f 05       	call   0x18680d140
   181711446:	48 8b 85 80 02 00 00 	mov    rax,QWORD PTR [rbp+0x280]
   18171144d:	48 89 06             	mov    QWORD PTR [rsi],rax
   181711450:	0f 57 c0             	xorps  xmm0,xmm0
   181711453:	0f 11 46 08          	movups XMMWORD PTR [rsi+0x8],xmm0
   181711457:	0f 11 46 18          	movups XMMWORD PTR [rsi+0x18],xmm0
   18171145b:	48 8b bd 98 02 00 00 	mov    rdi,QWORD PTR [rbp+0x298]
   181711462:	48 83 bd a0 02 00 00 	cmp    QWORD PTR [rbp+0x2a0],0x10
   181711469:	10 
   18171146a:	72 76                	jb     0x1817114e2
   18171146c:	48 8b 9d 88 02 00 00 	mov    rbx,QWORD PTR [rbp+0x288]
   181711473:	eb 74                	jmp    0x1817114e9
   181711475:	48 8b 0b             	mov    rcx,QWORD PTR [rbx]
   181711478:	e8 d3 ca f7 01       	call   0x18368df50
   18171147d:	90                   	nop
   18171147e:	84 c0                	test   al,al
   181711480:	74 32                	je     0x1817114b4
   181711482:	0f 29 b5 e0 01 00 00 	movaps XMMWORD PTR [rbp+0x1e0],xmm6
   181711489:	0f 57 c0             	xorps  xmm0,xmm0
   18171148c:	0f 29 85 10 01 00 00 	movaps XMMWORD PTR [rbp+0x110],xmm0
   181711493:	48 8b 8d c0 02 00 00 	mov    rcx,QWORD PTR [rbp+0x2c0]
   18171149a:	48 8b 41 08          	mov    rax,QWORD PTR [rcx+0x8]
   18171149e:	48 85 c0             	test   rax,rax
   1817114a1:	0f 84 99 00 00 00    	je     0x181711540
   1817114a7:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   1817114ab:	48 8b 41 08          	mov    rax,QWORD PTR [rcx+0x8]
   1817114af:	e9 8e 00 00 00       	jmp    0x181711542
   1817114b4:	48 8b 85 c0 02 00 00 	mov    rax,QWORD PTR [rbp+0x2c0]
   1817114bb:	48 8b 00             	mov    rax,QWORD PTR [rax]
   1817114be:	0f 57 c0             	xorps  xmm0,xmm0
   1817114c1:	0f 29 85 30 01 00 00 	movaps XMMWORD PTR [rbp+0x130],xmm0
   1817114c8:	48 8b 48 20          	mov    rcx,QWORD PTR [rax+0x20]
   1817114cc:	48 85 c9             	test   rcx,rcx
   1817114cf:	0f 84 ea 00 00 00    	je     0x1817115bf
   1817114d5:	f0 ff 41 08          	lock inc DWORD PTR [rcx+0x8]
   1817114d9:	48 8b 58 20          	mov    rbx,QWORD PTR [rax+0x20]
   1817114dd:	e9 df 00 00 00       	jmp    0x1817115c1
   1817114e2:	48 8d 9d 88 02 00 00 	lea    rbx,[rbp+0x288]
   1817114e9:	48 85 ff             	test   rdi,rdi
   1817114ec:	0f 88 8b 0a 00 00    	js     0x181711f7d
   1817114f2:	48 83 ff 0f          	cmp    rdi,0xf
   1817114f6:	0f 86 47 01 00 00    	jbe    0x181711643
   1817114fc:	48 89 f8             	mov    rax,rdi
   1817114ff:	48 83 c8 0f          	or     rax,0xf
   181711503:	48 83 f8 17          	cmp    rax,0x17
   181711507:	41 be 16 00 00 00    	mov    r14d,0x16
   18171150d:	4c 0f 43 f0          	cmovae r14,rax
   181711511:	48 3d ff 0f 00 00    	cmp    rax,0xfff
   181711517:	72 18                	jb     0x181711531
   181711519:	49 8d 4e 28          	lea    rcx,[r14+0x28]
   18171151d:	e8 da bb 0f 05       	call   0x18680d0fc
   181711522:	90                   	nop
   181711523:	48 85 c0             	test   rax,rax
   181711526:	0f 85 66 01 00 00    	jne    0x181711692
   18171152c:	e9 46 0a 00 00       	jmp    0x181711f77
   181711531:	49 8d 4e 01          	lea    rcx,[r14+0x1]
   181711535:	e8 c2 bb 0f 05       	call   0x18680d0fc
   18171153a:	90                   	nop
   18171153b:	e9 b1 02 00 00       	jmp    0x1817117f1
   181711540:	31 c0                	xor    eax,eax
   181711542:	48 8b 09             	mov    rcx,QWORD PTR [rcx]
   181711545:	48 89 8d 10 01 00 00 	mov    QWORD PTR [rbp+0x110],rcx
   18171154c:	48 89 85 18 01 00 00 	mov    QWORD PTR [rbp+0x118],rax
   181711553:	48 8d 95 e0 01 00 00 	lea    rdx,[rbp+0x1e0]
   18171155a:	4c 8d 85 10 01 00 00 	lea    r8,[rbp+0x110]
   181711561:	48 89 f9             	mov    rcx,rdi
   181711564:	e8 67 32 00 00       	call   0x1817147d0
   181711569:	90                   	nop
   18171156a:	48 83 bd e0 01 00 00 	cmp    QWORD PTR [rbp+0x1e0],0x0
   181711571:	00 
   181711572:	0f 84 2e 01 00 00    	je     0x1817116a6
   181711578:	48 8b 85 c0 02 00 00 	mov    rax,QWORD PTR [rbp+0x2c0]
   18171157f:	48 8b 08             	mov    rcx,QWORD PTR [rax]
   181711582:	ba 03 00 00 00       	mov    edx,0x3
   181711587:	e8 b4 c9 f7 01       	call   0x18368df40
   18171158c:	90                   	nop
   18171158d:	48 8b 8d e0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1e0]
   181711594:	0f 57 c0             	xorps  xmm0,xmm0
   181711597:	0f 29 85 20 01 00 00 	movaps XMMWORD PTR [rbp+0x120],xmm0
   18171159e:	48 8b 95 c0 02 00 00 	mov    rdx,QWORD PTR [rbp+0x2c0]
   1817115a5:	48 8b 42 08          	mov    rax,QWORD PTR [rdx+0x8]
   1817115a9:	48 85 c0             	test   rax,rax
   1817115ac:	0f 84 9b 02 00 00    	je     0x18171184d
   1817115b2:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   1817115b6:	48 8b 42 08          	mov    rax,QWORD PTR [rdx+0x8]
   1817115ba:	e9 90 02 00 00       	jmp    0x18171184f
   1817115bf:	31 db                	xor    ebx,ebx
   1817115c1:	48 8b 50 18          	mov    rdx,QWORD PTR [rax+0x18]
   1817115c5:	48 89 95 30 01 00 00 	mov    QWORD PTR [rbp+0x130],rdx
   1817115cc:	48 89 9d 38 01 00 00 	mov    QWORD PTR [rbp+0x138],rbx
   1817115d3:	48 89 f9             	mov    rcx,rdi
   1817115d6:	e8 15 b1 fa ff       	call   0x1816bc6f0
   1817115db:	90                   	nop
   1817115dc:	48 85 db             	test   rbx,rbx
   1817115df:	74 1d                	je     0x1817115fe
   1817115e1:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   1817115e5:	75 17                	jne    0x1817115fe
   1817115e7:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1817115ea:	48 89 d9             	mov    rcx,rbx
   1817115ed:	ff 10                	call   QWORD PTR [rax]
   1817115ef:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   1817115f3:	75 09                	jne    0x1817115fe
   1817115f5:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1817115f8:	48 89 d9             	mov    rcx,rbx
   1817115fb:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1817115fe:	48 8b 85 80 02 00 00 	mov    rax,QWORD PTR [rbp+0x280]
   181711605:	48 89 06             	mov    QWORD PTR [rsi],rax
   181711608:	0f 57 c0             	xorps  xmm0,xmm0
   18171160b:	0f 11 46 08          	movups XMMWORD PTR [rsi+0x8],xmm0
   18171160f:	0f 11 46 18          	movups XMMWORD PTR [rsi+0x18],xmm0
   181711613:	48 8b bd 98 02 00 00 	mov    rdi,QWORD PTR [rbp+0x298]
   18171161a:	48 83 bd a0 02 00 00 	cmp    QWORD PTR [rbp+0x2a0],0x10
   181711621:	10 
   181711622:	72 09                	jb     0x18171162d
   181711624:	48 8b 9d 88 02 00 00 	mov    rbx,QWORD PTR [rbp+0x288]
   18171162b:	eb 07                	jmp    0x181711634
   18171162d:	48 8d 9d 88 02 00 00 	lea    rbx,[rbp+0x288]
   181711634:	48 85 ff             	test   rdi,rdi
   181711637:	0f 88 46 09 00 00    	js     0x181711f83
   18171163d:	48 83 ff 0f          	cmp    rdi,0xf
   181711641:	77 1b                	ja     0x18171165e
   181711643:	48 8d 46 08          	lea    rax,[rsi+0x8]
   181711647:	48 89 7e 18          	mov    QWORD PTR [rsi+0x18],rdi
   18171164b:	48 c7 46 20 0f 00 00 	mov    QWORD PTR [rsi+0x20],0xf
   181711652:	00 
   181711653:	0f 10 03             	movups xmm0,XMMWORD PTR [rbx]
   181711656:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   181711659:	e9 b0 01 00 00       	jmp    0x18171180e
   18171165e:	48 89 f8             	mov    rax,rdi
   181711661:	48 83 c8 0f          	or     rax,0xf
   181711665:	48 83 f8 17          	cmp    rax,0x17
   181711669:	41 be 16 00 00 00    	mov    r14d,0x16
   18171166f:	4c 0f 43 f0          	cmovae r14,rax
   181711673:	48 3d ff 0f 00 00    	cmp    rax,0xfff
   181711679:	0f 82 68 01 00 00    	jb     0x1817117e7
   18171167f:	49 8d 4e 28          	lea    rcx,[r14+0x28]
   181711683:	e8 74 ba 0f 05       	call   0x18680d0fc
   181711688:	90                   	nop
   181711689:	48 85 c0             	test   rax,rax
   18171168c:	0f 84 e5 08 00 00    	je     0x181711f77
   181711692:	48 89 c1             	mov    rcx,rax
   181711695:	48 83 c0 27          	add    rax,0x27
   181711699:	48 83 e0 e0          	and    rax,0xffffffffffffffe0
   18171169d:	48 89 48 f8          	mov    QWORD PTR [rax-0x8],rcx
   1817116a1:	e9 4b 01 00 00       	jmp    0x1817117f1
   1817116a6:	b9 04 00 00 00       	mov    ecx,0x4
   1817116ab:	e8 90 70 95 fe       	call   0x180068740
   1817116b0:	85 c0                	test   eax,eax
   1817116b2:	0f 84 f8 00 00 00    	je     0x1817117b0
   1817116b8:	48 8d 7d 50          	lea    rdi,[rbp+0x50]
   1817116bc:	48 89 f9             	mov    rcx,rdi
   1817116bf:	e8 ac 71 95 fe       	call   0x180068870
   1817116c4:	90                   	nop
   1817116c5:	48 83 7d 68 10       	cmp    QWORD PTR [rbp+0x68],0x10
   1817116ca:	72 04                	jb     0x1817116d0
   1817116cc:	48 8b 7d 50          	mov    rdi,QWORD PTR [rbp+0x50]
   1817116d0:	48 8d 05 d7 15 df 06 	lea    rax,[rip+0x6df15d7]        # 0x188502cae
   1817116d7:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1817116dc:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   1817116e3:	00 00 
   1817116e5:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   1817116ea:	c7 44 24 28 a8 0d 00 	mov    DWORD PTR [rsp+0x28],0xda8
   1817116f1:	00 
   1817116f2:	4c 8d 0d fc 92 de 06 	lea    r9,[rip+0x6de92fc]        # 0x1884fa9f5
   1817116f9:	48 8d 8d 30 01 00 00 	lea    rcx,[rbp+0x130]
   181711700:	ba 04 00 00 00       	mov    edx,0x4
   181711705:	49 89 f8             	mov    r8,rdi
   181711708:	e8 b3 74 95 fe       	call   0x180068bc0
   18171170d:	90                   	nop
   18171170e:	0f 57 c0             	xorps  xmm0,xmm0
   181711711:	0f 29 85 70 02 00 00 	movaps XMMWORD PTR [rbp+0x270],xmm0
   181711718:	0f 29 85 60 02 00 00 	movaps XMMWORD PTR [rbp+0x260],xmm0
   18171171f:	0f 29 85 50 02 00 00 	movaps XMMWORD PTR [rbp+0x250],xmm0
   181711726:	0f 29 85 40 02 00 00 	movaps XMMWORD PTR [rbp+0x240],xmm0
   18171172d:	0f 29 85 30 02 00 00 	movaps XMMWORD PTR [rbp+0x230],xmm0
   181711734:	0f 29 85 20 02 00 00 	movaps XMMWORD PTR [rbp+0x220],xmm0
   18171173b:	0f 29 85 10 02 00 00 	movaps XMMWORD PTR [rbp+0x210],xmm0
   181711742:	0f 29 85 00 02 00 00 	movaps XMMWORD PTR [rbp+0x200],xmm0
   181711749:	48 8d 15 60 cb de 06 	lea    rdx,[rip+0x6decb60]        # 0x1884fe2b0
   181711750:	48 8d 8d 30 01 00 00 	lea    rcx,[rbp+0x130]
   181711757:	4c 8d 85 00 02 00 00 	lea    r8,[rbp+0x200]
   18171175e:	e8 fd 79 95 fe       	call   0x180069160
   181711763:	90                   	nop
   181711764:	48 8d 8d 30 01 00 00 	lea    rcx,[rbp+0x130]
   18171176b:	e8 50 75 95 fe       	call   0x180068cc0
   181711770:	48 8b 45 68          	mov    rax,QWORD PTR [rbp+0x68]
   181711774:	48 83 f8 10          	cmp    rax,0x10
   181711778:	72 36                	jb     0x1817117b0
   18171177a:	48 8b 4d 50          	mov    rcx,QWORD PTR [rbp+0x50]
   18171177e:	48 8d 50 01          	lea    rdx,[rax+0x1]
   181711782:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   181711789:	72 1f                	jb     0x1817117aa
   18171178b:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18171178f:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   181711793:	4c 29 c1             	sub    rcx,r8
   181711796:	48 83 f9 20          	cmp    rcx,0x20
   18171179a:	0f 83 d7 07 00 00    	jae    0x181711f77
   1817117a0:	48 83 c0 28          	add    rax,0x28
   1817117a4:	48 89 c2             	mov    rdx,rax
   1817117a7:	4c 89 c1             	mov    rcx,r8
   1817117aa:	e8 91 b9 0f 05       	call   0x18680d140
   1817117af:	90                   	nop
   1817117b0:	c7 44 24 20 04 00 00 	mov    DWORD PTR [rsp+0x20],0x4
   1817117b7:	00 
   1817117b8:	48 89 f1             	mov    rcx,rsi
   1817117bb:	ba 01 00 00 00       	mov    edx,0x1
   1817117c0:	41 b8 01 00 00 00    	mov    r8d,0x1
   1817117c6:	41 b9 04 00 00 00    	mov    r9d,0x4
   1817117cc:	e8 ff d1 f7 01       	call   0x18368e9d0
   1817117d1:	90                   	nop
   1817117d2:	48 8b bd e8 01 00 00 	mov    rdi,QWORD PTR [rbp+0x1e8]
   1817117d9:	48 85 ff             	test   rdi,rdi
   1817117dc:	0f 85 82 06 00 00    	jne    0x181711e64
   1817117e2:	e9 9a 06 00 00       	jmp    0x181711e81
   1817117e7:	49 8d 4e 01          	lea    rcx,[r14+0x1]
   1817117eb:	e8 0c b9 0f 05       	call   0x18680d0fc
   1817117f0:	90                   	nop
   1817117f1:	48 89 46 08          	mov    QWORD PTR [rsi+0x8],rax
   1817117f5:	48 89 7e 18          	mov    QWORD PTR [rsi+0x18],rdi
   1817117f9:	4c 89 76 20          	mov    QWORD PTR [rsi+0x20],r14
   1817117fd:	48 ff c7             	inc    rdi
   181711800:	48 89 c1             	mov    rcx,rax
   181711803:	48 89 da             	mov    rdx,rbx
   181711806:	49 89 f8             	mov    r8,rdi
   181711809:	e8 c2 48 18 05       	call   0x1868960d0
   18171180e:	0f 57 c0             	xorps  xmm0,xmm0
   181711811:	0f 11 46 28          	movups XMMWORD PTR [rsi+0x28],xmm0
   181711815:	48 8b 85 b0 02 00 00 	mov    rax,QWORD PTR [rbp+0x2b0]
   18171181c:	48 85 c0             	test   rax,rax
   18171181f:	74 0d                	je     0x18171182e
   181711821:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   181711825:	48 8b bd b0 02 00 00 	mov    rdi,QWORD PTR [rbp+0x2b0]
   18171182c:	eb 02                	jmp    0x181711830
   18171182e:	31 ff                	xor    edi,edi
   181711830:	48 8b 85 a8 02 00 00 	mov    rax,QWORD PTR [rbp+0x2a8]
   181711837:	48 89 46 28          	mov    QWORD PTR [rsi+0x28],rax
   18171183b:	48 89 7e 30          	mov    QWORD PTR [rsi+0x30],rdi
   18171183f:	48 85 ff             	test   rdi,rdi
   181711842:	0f 85 45 06 00 00    	jne    0x181711e8d
   181711848:	e9 5d 06 00 00       	jmp    0x181711eaa
   18171184d:	31 c0                	xor    eax,eax
   18171184f:	48 8b 12             	mov    rdx,QWORD PTR [rdx]
   181711852:	48 89 95 20 01 00 00 	mov    QWORD PTR [rbp+0x120],rdx
   181711859:	48 89 85 28 01 00 00 	mov    QWORD PTR [rbp+0x128],rax
   181711860:	48 8d 95 30 01 00 00 	lea    rdx,[rbp+0x130]
   181711867:	4c 8d 85 20 01 00 00 	lea    r8,[rbp+0x120]
   18171186e:	e8 5d be f6 01       	call   0x18367d6d0
   181711873:	90                   	nop
   181711874:	48 8b 85 30 01 00 00 	mov    rax,QWORD PTR [rbp+0x130]
   18171187b:	48 8b 9d 48 01 00 00 	mov    rbx,QWORD PTR [rbp+0x148]
   181711882:	48 89 85 80 02 00 00 	mov    QWORD PTR [rbp+0x280],rax
   181711889:	48 83 bd 50 01 00 00 	cmp    QWORD PTR [rbp+0x150],0x10
   181711890:	10 
   181711891:	72 46                	jb     0x1817118d9
   181711893:	4c 8b 8d 38 01 00 00 	mov    r9,QWORD PTR [rbp+0x138]
   18171189a:	48 8d bd 88 02 00 00 	lea    rdi,[rbp+0x288]
   1817118a1:	48 8b 85 a0 02 00 00 	mov    rax,QWORD PTR [rbp+0x2a0]
   1817118a8:	48 39 c3             	cmp    rbx,rax
   1817118ab:	77 46                	ja     0x1817118f3
   1817118ad:	49 89 fe             	mov    r14,rdi
   1817118b0:	48 83 f8 10          	cmp    rax,0x10
   1817118b4:	72 07                	jb     0x1817118bd
   1817118b6:	4c 8b b5 88 02 00 00 	mov    r14,QWORD PTR [rbp+0x288]
   1817118bd:	48 89 9d 98 02 00 00 	mov    QWORD PTR [rbp+0x298],rbx
   1817118c4:	4c 89 f1             	mov    rcx,r14
   1817118c7:	4c 89 ca             	mov    rdx,r9
   1817118ca:	49 89 d8             	mov    r8,rbx
   1817118cd:	e8 fe 47 18 05       	call   0x1868960d0
   1817118d2:	41 c6 04 1e 00       	mov    BYTE PTR [r14+rbx*1],0x0
   1817118d7:	eb 26                	jmp    0x1817118ff
   1817118d9:	4c 8d 8d 38 01 00 00 	lea    r9,[rbp+0x138]
   1817118e0:	48 8d bd 88 02 00 00 	lea    rdi,[rbp+0x288]
   1817118e7:	48 8b 85 a0 02 00 00 	mov    rax,QWORD PTR [rbp+0x2a0]
   1817118ee:	48 39 c3             	cmp    rbx,rax
   1817118f1:	76 ba                	jbe    0x1817118ad
   1817118f3:	48 89 f9             	mov    rcx,rdi
   1817118f6:	48 89 da             	mov    rdx,rbx
   1817118f9:	e8 72 2b 94 fe       	call   0x180054470
   1817118fe:	90                   	nop
   1817118ff:	48 8b 85 60 01 00 00 	mov    rax,QWORD PTR [rbp+0x160]
   181711906:	48 85 c0             	test   rax,rax
   181711909:	74 0d                	je     0x181711918
   18171190b:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   18171190f:	48 8b 85 60 01 00 00 	mov    rax,QWORD PTR [rbp+0x160]
   181711916:	eb 02                	jmp    0x18171191a
   181711918:	31 c0                	xor    eax,eax
   18171191a:	4c 8b b5 c0 02 00 00 	mov    r14,QWORD PTR [rbp+0x2c0]
   181711921:	48 8b 8d 58 01 00 00 	mov    rcx,QWORD PTR [rbp+0x158]
   181711928:	48 89 8d a8 02 00 00 	mov    QWORD PTR [rbp+0x2a8],rcx
   18171192f:	48 8b 9d b0 02 00 00 	mov    rbx,QWORD PTR [rbp+0x2b0]
   181711936:	48 89 85 b0 02 00 00 	mov    QWORD PTR [rbp+0x2b0],rax
   18171193d:	48 85 db             	test   rbx,rbx
   181711940:	74 1d                	je     0x18171195f
   181711942:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   181711946:	75 17                	jne    0x18171195f
   181711948:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   18171194b:	48 89 d9             	mov    rcx,rbx
   18171194e:	ff 10                	call   QWORD PTR [rax]
   181711950:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   181711954:	75 09                	jne    0x18171195f
   181711956:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   181711959:	48 89 d9             	mov    rcx,rbx
   18171195c:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18171195f:	48 8b 9d 60 01 00 00 	mov    rbx,QWORD PTR [rbp+0x160]
   181711966:	48 85 db             	test   rbx,rbx
   181711969:	74 1d                	je     0x181711988
   18171196b:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   18171196f:	75 17                	jne    0x181711988
   181711971:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   181711974:	48 89 d9             	mov    rcx,rbx
   181711977:	ff 10                	call   QWORD PTR [rax]
   181711979:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   18171197d:	75 09                	jne    0x181711988
   18171197f:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   181711982:	48 89 d9             	mov    rcx,rbx
   181711985:	ff 50 08             	call   QWORD PTR [rax+0x8]
   181711988:	48 8b 85 50 01 00 00 	mov    rax,QWORD PTR [rbp+0x150]
   18171198f:	48 83 f8 10          	cmp    rax,0x10
   181711993:	72 38                	jb     0x1817119cd
   181711995:	48 8b 8d 38 01 00 00 	mov    rcx,QWORD PTR [rbp+0x138]
   18171199c:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1817119a0:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1817119a7:	72 1f                	jb     0x1817119c8
   1817119a9:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1817119ad:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1817119b1:	4c 29 c1             	sub    rcx,r8
   1817119b4:	48 83 f9 20          	cmp    rcx,0x20
   1817119b8:	0f 83 b9 05 00 00    	jae    0x181711f77
   1817119be:	48 83 c0 28          	add    rax,0x28
   1817119c2:	48 89 c2             	mov    rdx,rax
   1817119c5:	4c 89 c1             	mov    rcx,r8
   1817119c8:	e8 73 b7 0f 05       	call   0x18680d140
   1817119cd:	49 8b 0e             	mov    rcx,QWORD PTR [r14]
   1817119d0:	48 8d 9d 30 01 00 00 	lea    rbx,[rbp+0x130]
   1817119d7:	48 89 da             	mov    rdx,rbx
   1817119da:	e8 f1 b0 f7 01       	call   0x18368cad0
   1817119df:	90                   	nop
   1817119e0:	0f 57 c0             	xorps  xmm0,xmm0
   1817119e3:	0f 29 85 10 02 00 00 	movaps XMMWORD PTR [rbp+0x210],xmm0
   1817119ea:	0f 29 85 00 02 00 00 	movaps XMMWORD PTR [rbp+0x200],xmm0
   1817119f1:	b9 20 00 00 00       	mov    ecx,0x20
   1817119f6:	e8 01 b7 0f 05       	call   0x18680d0fc
   1817119fb:	90                   	nop
   1817119fc:	48 89 85 00 02 00 00 	mov    QWORD PTR [rbp+0x200],rax
   181711a03:	48 c7 85 10 02 00 00 	mov    QWORD PTR [rbp+0x210],0x14
   181711a0a:	14 00 00 00 
   181711a0e:	48 c7 85 18 02 00 00 	mov    QWORD PTR [rbp+0x218],0x1f
   181711a15:	1f 00 00 00 
   181711a19:	0f 10 05 26 2d de 06 	movups xmm0,XMMWORD PTR [rip+0x6de2d26]        # 0x1884f4746
   181711a20:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   181711a23:	c7 40 10 73 61 67 65 	mov    DWORD PTR [rax+0x10],0x65676173
   181711a2a:	c6 40 14 00          	mov    BYTE PTR [rax+0x14],0x0
   181711a2e:	4c 8b b5 40 01 00 00 	mov    r14,QWORD PTR [rbp+0x140]
   181711a35:	48 83 bd 48 01 00 00 	cmp    QWORD PTR [rbp+0x148],0x10
   181711a3c:	10 
   181711a3d:	72 07                	jb     0x181711a46
   181711a3f:	48 8b 9d 30 01 00 00 	mov    rbx,QWORD PTR [rbp+0x130]
   181711a46:	49 83 fe 0b          	cmp    r14,0xb
   181711a4a:	76 1a                	jbe    0x181711a66
   181711a4c:	4c 89 74 24 20       	mov    QWORD PTR [rsp+0x20],r14
   181711a51:	48 8d 8d 00 02 00 00 	lea    rcx,[rbp+0x200]
   181711a58:	4c 89 f2             	mov    rdx,r14
   181711a5b:	49 89 d9             	mov    r9,rbx
   181711a5e:	e8 8d 77 8f fe       	call   0x1800091f0
   181711a63:	90                   	nop
   181711a64:	eb 2d                	jmp    0x181711a93
   181711a66:	48 89 c1             	mov    rcx,rax
   181711a69:	48 83 c1 14          	add    rcx,0x14
   181711a6d:	49 8d 56 14          	lea    rdx,[r14+0x14]
   181711a71:	48 89 95 10 02 00 00 	mov    QWORD PTR [rbp+0x210],rdx
   181711a78:	48 89 da             	mov    rdx,rbx
   181711a7b:	4d 89 f0             	mov    r8,r14
   181711a7e:	48 89 c3             	mov    rbx,rax
   181711a81:	e8 4a 46 18 05       	call   0x1868960d0
   181711a86:	42 c6 44 33 14 00    	mov    BYTE PTR [rbx+r14*1+0x14],0x0
   181711a8c:	48 8d 85 00 02 00 00 	lea    rax,[rbp+0x200]
   181711a93:	0f 10 00             	movups xmm0,XMMWORD PTR [rax]
   181711a96:	0f 10 48 10          	movups xmm1,XMMWORD PTR [rax+0x10]
   181711a9a:	0f 29 4d f0          	movaps XMMWORD PTR [rbp-0x10],xmm1
   181711a9e:	0f 29 45 e0          	movaps XMMWORD PTR [rbp-0x20],xmm0
   181711aa2:	48 c7 40 10 00 00 00 	mov    QWORD PTR [rax+0x10],0x0
   181711aa9:	00 
   181711aaa:	48 c7 40 18 0f 00 00 	mov    QWORD PTR [rax+0x18],0xf
   181711ab1:	00 
   181711ab2:	c6 00 00             	mov    BYTE PTR [rax],0x0
   181711ab5:	48 8d 8d a0 00 00 00 	lea    rcx,[rbp+0xa0]
   181711abc:	48 8d 55 e0          	lea    rdx,[rbp-0x20]
   181711ac0:	41 b8 32 00 00 00    	mov    r8d,0x32
   181711ac6:	e8 d5 87 81 ff       	call   0x180f2a2a0
   181711acb:	90                   	nop
   181711acc:	48 8b 85 18 02 00 00 	mov    rax,QWORD PTR [rbp+0x218]
   181711ad3:	48 83 f8 10          	cmp    rax,0x10
   181711ad7:	72 38                	jb     0x181711b11
   181711ad9:	48 8b 8d 00 02 00 00 	mov    rcx,QWORD PTR [rbp+0x200]
   181711ae0:	48 8d 50 01          	lea    rdx,[rax+0x1]
   181711ae4:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   181711aeb:	72 1f                	jb     0x181711b0c
   181711aed:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   181711af1:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   181711af5:	4c 29 c1             	sub    rcx,r8
   181711af8:	48 83 f9 20          	cmp    rcx,0x20
   181711afc:	0f 83 75 04 00 00    	jae    0x181711f77
   181711b02:	48 83 c0 28          	add    rax,0x28
   181711b06:	48 89 c2             	mov    rdx,rax
   181711b09:	4c 89 c1             	mov    rcx,r8
   181711b0c:	e8 2f b6 0f 05       	call   0x18680d140
   181711b11:	48 8b 85 48 01 00 00 	mov    rax,QWORD PTR [rbp+0x148]
   181711b18:	48 83 f8 10          	cmp    rax,0x10
   181711b1c:	72 38                	jb     0x181711b56
   181711b1e:	48 8b 8d 30 01 00 00 	mov    rcx,QWORD PTR [rbp+0x130]
   181711b25:	48 8d 50 01          	lea    rdx,[rax+0x1]
   181711b29:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   181711b30:	72 1f                	jb     0x181711b51
   181711b32:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   181711b36:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   181711b3a:	4c 29 c1             	sub    rcx,r8
   181711b3d:	48 83 f9 20          	cmp    rcx,0x20
   181711b41:	0f 83 30 04 00 00    	jae    0x181711f77
   181711b47:	48 83 c0 28          	add    rax,0x28
   181711b4b:	48 89 c2             	mov    rdx,rax
   181711b4e:	4c 89 c1             	mov    rcx,r8
   181711b51:	e8 ea b5 0f 05       	call   0x18680d140
   181711b56:	8b 85 84 02 00 00    	mov    eax,DWORD PTR [rbp+0x284]
   181711b5c:	0b 85 80 02 00 00    	or     eax,DWORD PTR [rbp+0x280]
   181711b62:	0f 84 f4 01 00 00    	je     0x181711d5c
   181711b68:	b9 04 00 00 00       	mov    ecx,0x4
   181711b6d:	e8 ce 6b 95 fe       	call   0x180068740
   181711b72:	85 c0                	test   eax,eax
   181711b74:	0f 84 79 01 00 00    	je     0x181711cf3
   181711b7a:	48 89 eb             	mov    rbx,rbp
   181711b7d:	48 89 d9             	mov    rcx,rbx
   181711b80:	e8 eb 6c 95 fe       	call   0x180068870
   181711b85:	90                   	nop
   181711b86:	48 83 7d 18 10       	cmp    QWORD PTR [rbp+0x18],0x10
   181711b8b:	72 04                	jb     0x181711b91
   181711b8d:	48 8b 5d 00          	mov    rbx,QWORD PTR [rbp+0x0]
   181711b91:	48 8d 05 16 11 df 06 	lea    rax,[rip+0x6df1116]        # 0x188502cae
   181711b98:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   181711b9d:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   181711ba4:	00 00 
   181711ba6:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   181711bab:	c7 44 24 28 b0 0d 00 	mov    DWORD PTR [rsp+0x28],0xdb0
   181711bb2:	00 
   181711bb3:	4c 8d 0d 3b 8e de 06 	lea    r9,[rip+0x6de8e3b]        # 0x1884fa9f5
   181711bba:	48 8d 8d 30 01 00 00 	lea    rcx,[rbp+0x130]
   181711bc1:	ba 04 00 00 00       	mov    edx,0x4
   181711bc6:	49 89 d8             	mov    r8,rbx
   181711bc9:	e8 f2 6f 95 fe       	call   0x180068bc0
   181711bce:	90                   	nop
   181711bcf:	48 8b 85 c0 02 00 00 	mov    rax,QWORD PTR [rbp+0x2c0]
   181711bd6:	48 8b 08             	mov    rcx,QWORD PTR [rax]
   181711bd9:	48 8d 9d c0 01 00 00 	lea    rbx,[rbp+0x1c0]
   181711be0:	48 89 da             	mov    rdx,rbx
   181711be3:	e8 e8 ae f7 01       	call   0x18368cad0
   181711be8:	90                   	nop
   181711be9:	48 83 bd d8 01 00 00 	cmp    QWORD PTR [rbp+0x1d8],0x10
   181711bf0:	10 
   181711bf1:	72 07                	jb     0x181711bfa
   181711bf3:	48 8b 9d c0 01 00 00 	mov    rbx,QWORD PTR [rbp+0x1c0]
   181711bfa:	48 89 5d 50          	mov    QWORD PTR [rbp+0x50],rbx
   181711bfe:	c6 45 58 00          	mov    BYTE PTR [rbp+0x58],0x0
   181711c02:	0f 57 c0             	xorps  xmm0,xmm0
   181711c05:	0f 29 85 00 02 00 00 	movaps XMMWORD PTR [rbp+0x200],xmm0
   181711c0c:	0f 29 85 70 02 00 00 	movaps XMMWORD PTR [rbp+0x270],xmm0
   181711c13:	0f 29 85 60 02 00 00 	movaps XMMWORD PTR [rbp+0x260],xmm0
   181711c1a:	0f 29 85 50 02 00 00 	movaps XMMWORD PTR [rbp+0x250],xmm0
   181711c21:	0f 29 85 40 02 00 00 	movaps XMMWORD PTR [rbp+0x240],xmm0
   181711c28:	0f 29 85 30 02 00 00 	movaps XMMWORD PTR [rbp+0x230],xmm0
   181711c2f:	0f 29 85 20 02 00 00 	movaps XMMWORD PTR [rbp+0x220],xmm0
   181711c36:	0f 29 85 10 02 00 00 	movaps XMMWORD PTR [rbp+0x210],xmm0
   181711c3d:	48 8d 45 50          	lea    rax,[rbp+0x50]
   181711c41:	48 89 85 00 02 00 00 	mov    QWORD PTR [rbp+0x200],rax
   181711c48:	48 8d 15 c7 be de 06 	lea    rdx,[rip+0x6debec7]        # 0x1884fdb16
   181711c4f:	48 8d 8d 30 01 00 00 	lea    rcx,[rbp+0x130]
   181711c56:	4c 8d 85 00 02 00 00 	lea    r8,[rbp+0x200]
   181711c5d:	e8 fe 74 95 fe       	call   0x180069160
   181711c62:	90                   	nop
   181711c63:	48 8b 85 d8 01 00 00 	mov    rax,QWORD PTR [rbp+0x1d8]
   181711c6a:	48 83 f8 10          	cmp    rax,0x10
   181711c6e:	72 38                	jb     0x181711ca8
   181711c70:	48 8b 8d c0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1c0]
   181711c77:	48 8d 50 01          	lea    rdx,[rax+0x1]
   181711c7b:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   181711c82:	72 1f                	jb     0x181711ca3
   181711c84:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   181711c88:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   181711c8c:	4c 29 c1             	sub    rcx,r8
   181711c8f:	48 83 f9 20          	cmp    rcx,0x20
   181711c93:	0f 83 de 02 00 00    	jae    0x181711f77
   181711c99:	48 83 c0 28          	add    rax,0x28
   181711c9d:	48 89 c2             	mov    rdx,rax
   181711ca0:	4c 89 c1             	mov    rcx,r8
   181711ca3:	e8 98 b4 0f 05       	call   0x18680d140
   181711ca8:	48 8d 8d 30 01 00 00 	lea    rcx,[rbp+0x130]
   181711caf:	e8 0c 70 95 fe       	call   0x180068cc0
   181711cb4:	48 8b 45 18          	mov    rax,QWORD PTR [rbp+0x18]
   181711cb8:	48 83 f8 10          	cmp    rax,0x10
   181711cbc:	72 35                	jb     0x181711cf3
   181711cbe:	48 8b 4d 00          	mov    rcx,QWORD PTR [rbp+0x0]
   181711cc2:	48 8d 50 01          	lea    rdx,[rax+0x1]
   181711cc6:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   181711ccd:	72 1f                	jb     0x181711cee
   181711ccf:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   181711cd3:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   181711cd7:	4c 29 c1             	sub    rcx,r8
   181711cda:	48 83 f9 20          	cmp    rcx,0x20
   181711cde:	0f 83 93 02 00 00    	jae    0x181711f77
   181711ce4:	48 83 c0 28          	add    rax,0x28
   181711ce8:	48 89 c2             	mov    rdx,rax
   181711ceb:	4c 89 c1             	mov    rcx,r8
   181711cee:	e8 4d b4 0f 05       	call   0x18680d140
   181711cf3:	48 8b 85 80 02 00 00 	mov    rax,QWORD PTR [rbp+0x280]
   181711cfa:	48 89 06             	mov    QWORD PTR [rsi],rax
   181711cfd:	0f 57 c0             	xorps  xmm0,xmm0
   181711d00:	0f 11 46 08          	movups XMMWORD PTR [rsi+0x8],xmm0
   181711d04:	0f 11 46 18          	movups XMMWORD PTR [rsi+0x18],xmm0
   181711d08:	48 8b 9d 98 02 00 00 	mov    rbx,QWORD PTR [rbp+0x298]
   181711d0f:	48 83 bd a0 02 00 00 	cmp    QWORD PTR [rbp+0x2a0],0x10
   181711d16:	10 
   181711d17:	72 07                	jb     0x181711d20
   181711d19:	48 8b bd 88 02 00 00 	mov    rdi,QWORD PTR [rbp+0x288]
   181711d20:	48 85 db             	test   rbx,rbx
   181711d23:	0f 88 66 02 00 00    	js     0x181711f8f
   181711d29:	48 83 fb 0f          	cmp    rbx,0xf
   181711d2d:	76 69                	jbe    0x181711d98
   181711d2f:	48 89 d8             	mov    rax,rbx
   181711d32:	48 83 c8 0f          	or     rax,0xf
   181711d36:	48 83 f8 17          	cmp    rax,0x17
   181711d3a:	41 be 16 00 00 00    	mov    r14d,0x16
   181711d40:	4c 0f 43 f0          	cmovae r14,rax
   181711d44:	48 3d ff 0f 00 00    	cmp    rax,0xfff
   181711d4a:	0f 82 ad 00 00 00    	jb     0x181711dfd
   181711d50:	49 8d 4e 28          	lea    rcx,[r14+0x28]
   181711d54:	e8 a3 b3 0f 05       	call   0x18680d0fc
   181711d59:	90                   	nop
   181711d5a:	eb 7b                	jmp    0x181711dd7
   181711d5c:	48 8b 85 80 02 00 00 	mov    rax,QWORD PTR [rbp+0x280]
   181711d63:	48 89 06             	mov    QWORD PTR [rsi],rax
   181711d66:	0f 57 c0             	xorps  xmm0,xmm0
   181711d69:	0f 11 46 08          	movups XMMWORD PTR [rsi+0x8],xmm0
   181711d6d:	0f 11 46 18          	movups XMMWORD PTR [rsi+0x18],xmm0
   181711d71:	48 8b 9d 98 02 00 00 	mov    rbx,QWORD PTR [rbp+0x298]
   181711d78:	48 83 bd a0 02 00 00 	cmp    QWORD PTR [rbp+0x2a0],0x10
   181711d7f:	10 
   181711d80:	72 07                	jb     0x181711d89
   181711d82:	48 8b bd 88 02 00 00 	mov    rdi,QWORD PTR [rbp+0x288]
   181711d89:	48 85 db             	test   rbx,rbx
   181711d8c:	0f 88 f7 01 00 00    	js     0x181711f89
   181711d92:	48 83 fb 0f          	cmp    rbx,0xf
   181711d96:	77 18                	ja     0x181711db0
   181711d98:	48 8d 46 08          	lea    rax,[rsi+0x8]
   181711d9c:	48 89 5e 18          	mov    QWORD PTR [rsi+0x18],rbx
   181711da0:	48 c7 46 20 0f 00 00 	mov    QWORD PTR [rsi+0x20],0xf
   181711da7:	00 
   181711da8:	0f 10 07             	movups xmm0,XMMWORD PTR [rdi]
   181711dab:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   181711dae:	eb 74                	jmp    0x181711e24
   181711db0:	48 89 d8             	mov    rax,rbx
   181711db3:	48 83 c8 0f          	or     rax,0xf
   181711db7:	48 83 f8 17          	cmp    rax,0x17
   181711dbb:	41 be 16 00 00 00    	mov    r14d,0x16
   181711dc1:	4c 0f 43 f0          	cmovae r14,rax
   181711dc5:	48 3d ff 0f 00 00    	cmp    rax,0xfff
   181711dcb:	72 24                	jb     0x181711df1
   181711dcd:	49 8d 4e 28          	lea    rcx,[r14+0x28]
   181711dd1:	e8 26 b3 0f 05       	call   0x18680d0fc
   181711dd6:	90                   	nop
   181711dd7:	48 85 c0             	test   rax,rax
   181711dda:	0f 84 97 01 00 00    	je     0x181711f77
   181711de0:	48 89 c1             	mov    rcx,rax
   181711de3:	48 83 c0 27          	add    rax,0x27
   181711de7:	48 83 e0 e0          	and    rax,0xffffffffffffffe0
   181711deb:	48 89 48 f8          	mov    QWORD PTR [rax-0x8],rcx
   181711def:	eb 16                	jmp    0x181711e07
   181711df1:	49 8d 4e 01          	lea    rcx,[r14+0x1]
   181711df5:	e8 02 b3 0f 05       	call   0x18680d0fc
   181711dfa:	90                   	nop
   181711dfb:	eb 0a                	jmp    0x181711e07
   181711dfd:	49 8d 4e 01          	lea    rcx,[r14+0x1]
   181711e01:	e8 f6 b2 0f 05       	call   0x18680d0fc
   181711e06:	90                   	nop
   181711e07:	48 89 46 08          	mov    QWORD PTR [rsi+0x8],rax
   181711e0b:	48 89 5e 18          	mov    QWORD PTR [rsi+0x18],rbx
   181711e0f:	4c 89 76 20          	mov    QWORD PTR [rsi+0x20],r14
   181711e13:	48 ff c3             	inc    rbx
   181711e16:	48 89 c1             	mov    rcx,rax
   181711e19:	48 89 fa             	mov    rdx,rdi
   181711e1c:	49 89 d8             	mov    r8,rbx
   181711e1f:	e8 ac 42 18 05       	call   0x1868960d0
   181711e24:	48 8d 4e 28          	lea    rcx,[rsi+0x28]
   181711e28:	0f 57 c0             	xorps  xmm0,xmm0
   181711e2b:	0f 11 46 28          	movups XMMWORD PTR [rsi+0x28],xmm0
   181711e2f:	48 8b 85 b0 02 00 00 	mov    rax,QWORD PTR [rbp+0x2b0]
   181711e36:	48 85 c0             	test   rax,rax
   181711e39:	74 0d                	je     0x181711e48
   181711e3b:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   181711e3f:	48 8b 85 b0 02 00 00 	mov    rax,QWORD PTR [rbp+0x2b0]
   181711e46:	eb 02                	jmp    0x181711e4a
   181711e48:	31 c0                	xor    eax,eax
   181711e4a:	48 8b 95 a8 02 00 00 	mov    rdx,QWORD PTR [rbp+0x2a8]
   181711e51:	48 89 11             	mov    QWORD PTR [rcx],rdx
   181711e54:	48 89 46 30          	mov    QWORD PTR [rsi+0x30],rax
   181711e58:	48 8b bd e8 01 00 00 	mov    rdi,QWORD PTR [rbp+0x1e8]
   181711e5f:	48 85 ff             	test   rdi,rdi
   181711e62:	74 1d                	je     0x181711e81
   181711e64:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   181711e68:	75 17                	jne    0x181711e81
   181711e6a:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   181711e6d:	48 89 f9             	mov    rcx,rdi
   181711e70:	ff 10                	call   QWORD PTR [rax]
   181711e72:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   181711e76:	75 09                	jne    0x181711e81
   181711e78:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   181711e7b:	48 89 f9             	mov    rcx,rdi
   181711e7e:	ff 50 08             	call   QWORD PTR [rax+0x8]
   181711e81:	48 8b bd b0 02 00 00 	mov    rdi,QWORD PTR [rbp+0x2b0]
   181711e88:	48 85 ff             	test   rdi,rdi
   181711e8b:	74 1d                	je     0x181711eaa
   181711e8d:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   181711e91:	75 17                	jne    0x181711eaa
   181711e93:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   181711e96:	48 89 f9             	mov    rcx,rdi
   181711e99:	ff 10                	call   QWORD PTR [rax]
   181711e9b:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   181711e9f:	75 09                	jne    0x181711eaa
   181711ea1:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   181711ea4:	48 89 f9             	mov    rcx,rdi
   181711ea7:	ff 50 08             	call   QWORD PTR [rax+0x8]
   181711eaa:	48 8b 85 a0 02 00 00 	mov    rax,QWORD PTR [rbp+0x2a0]
   181711eb1:	48 83 f8 10          	cmp    rax,0x10
   181711eb5:	48 8b bd c0 02 00 00 	mov    rdi,QWORD PTR [rbp+0x2c0]
   181711ebc:	72 38                	jb     0x181711ef6
   181711ebe:	48 8b 8d 88 02 00 00 	mov    rcx,QWORD PTR [rbp+0x288]
   181711ec5:	48 8d 50 01          	lea    rdx,[rax+0x1]
   181711ec9:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   181711ed0:	72 1f                	jb     0x181711ef1
   181711ed2:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   181711ed6:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   181711eda:	4c 29 c1             	sub    rcx,r8
   181711edd:	48 83 f9 20          	cmp    rcx,0x20
   181711ee1:	0f 83 90 00 00 00    	jae    0x181711f77
   181711ee7:	48 83 c0 28          	add    rax,0x28
   181711eeb:	48 89 c2             	mov    rdx,rax
   181711eee:	4c 89 c1             	mov    rcx,r8
   181711ef1:	e8 4a b2 0f 05       	call   0x18680d140
   181711ef6:	48 8b 85 e0 00 00 00 	mov    rax,QWORD PTR [rbp+0xe0]
   181711efd:	48 83 f8 10          	cmp    rax,0x10
   181711f01:	72 34                	jb     0x181711f37
   181711f03:	48 8b 8d c8 00 00 00 	mov    rcx,QWORD PTR [rbp+0xc8]
   181711f0a:	48 8d 50 01          	lea    rdx,[rax+0x1]
   181711f0e:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   181711f15:	72 1b                	jb     0x181711f32
   181711f17:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   181711f1b:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   181711f1f:	4c 29 c1             	sub    rcx,r8
   181711f22:	48 83 f9 20          	cmp    rcx,0x20
   181711f26:	73 4f                	jae    0x181711f77
   181711f28:	48 83 c0 28          	add    rax,0x28
   181711f2c:	48 89 c2             	mov    rdx,rax
   181711f2f:	4c 89 c1             	mov    rcx,r8
   181711f32:	e8 09 b2 0f 05       	call   0x18680d140
   181711f37:	48 8b 7f 08          	mov    rdi,QWORD PTR [rdi+0x8]
   181711f3b:	48 85 ff             	test   rdi,rdi
   181711f3e:	74 1d                	je     0x181711f5d
   181711f40:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   181711f44:	75 17                	jne    0x181711f5d
   181711f46:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   181711f49:	48 89 f9             	mov    rcx,rdi
   181711f4c:	ff 10                	call   QWORD PTR [rax]
   181711f4e:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   181711f52:	75 09                	jne    0x181711f5d
   181711f54:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   181711f57:	48 89 f9             	mov    rcx,rdi
   181711f5a:	ff 50 08             	call   QWORD PTR [rax+0x8]
   181711f5d:	48 89 f0             	mov    rax,rsi
   181711f60:	0f 28 b5 d0 02 00 00 	movaps xmm6,XMMWORD PTR [rbp+0x2d0]
   181711f67:	48 81 c4 68 03 00 00 	add    rsp,0x368
   181711f6e:	5b                   	pop    rbx
   181711f6f:	5f                   	pop    rdi
   181711f70:	5e                   	pop    rsi
   181711f71:	41 5e                	pop    r14
   181711f73:	41 5f                	pop    r15
   181711f75:	5d                   	pop    rbp
   181711f76:	c3                   	ret
   181711f77:	e8 fc e4 14 05       	call   0x186860478
   181711f7c:	90                   	nop
   181711f7d:	e8 de 69 8f fe       	call   0x180008960
   181711f82:	90                   	nop
   181711f83:	e8 d8 69 8f fe       	call   0x180008960
   181711f88:	90                   	nop
   181711f89:	e8 d2 69 8f fe       	call   0x180008960
   181711f8e:	90                   	nop
   181711f8f:	e8 cc 69 8f fe       	call   0x180008960
   181711f94:	90                   	nop
   181711f95:	cc                   	int3
