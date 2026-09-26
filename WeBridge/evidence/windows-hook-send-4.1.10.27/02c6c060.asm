
.research\wechat-4.1.10.27-reference\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000182c6c060 <.text+0x2c6b060>:
   182c6c060:	55                   	push   rbp
   182c6c061:	41 57                	push   r15
   182c6c063:	41 56                	push   r14
   182c6c065:	56                   	push   rsi
   182c6c066:	57                   	push   rdi
   182c6c067:	53                   	push   rbx
   182c6c068:	48 83 ec 78          	sub    rsp,0x78
   182c6c06c:	48 8d 6c 24 70       	lea    rbp,[rsp+0x70]
   182c6c071:	48 c7 45 00 fe ff ff 	mov    QWORD PTR [rbp+0x0],0xfffffffffffffffe
   182c6c078:	ff 
   182c6c079:	48 89 d7             	mov    rdi,rdx
   182c6c07c:	48 89 ce             	mov    rsi,rcx
   182c6c07f:	48 39 ca             	cmp    rdx,rcx
   182c6c082:	74 0d                	je     0x182c6c091
   182c6c084:	0f b6 47 34          	movzx  eax,BYTE PTR [rdi+0x34]
   182c6c088:	85 c0                	test   eax,eax
   182c6c08a:	75 56                	jne    0x182c6c0e2
   182c6c08c:	e9 29 02 00 00       	jmp    0x182c6c2ba
   182c6c091:	4c 8d 05 d4 be b3 05 	lea    r8,[rip+0x5b3bed4]        # 0x1887a7f6c
   182c6c098:	48 8d 5d b8          	lea    rbx,[rbp-0x48]
   182c6c09c:	48 89 d9             	mov    rcx,rbx
   182c6c09f:	ba 03 00 00 00       	mov    edx,0x3
   182c6c0a4:	41 b9 77 02 00 00    	mov    r9d,0x277
   182c6c0aa:	e8 b1 c5 88 fe       	call   0x1814f8660
   182c6c0af:	90                   	nop
   182c6c0b0:	48 8d 15 81 78 5f 05 	lea    rdx,[rip+0x55f7881]        # 0x188263938
   182c6c0b7:	48 89 d9             	mov    rcx,rbx
   182c6c0ba:	e8 d1 c5 88 fe       	call   0x1814f8690
   182c6c0bf:	90                   	nop
   182c6c0c0:	48 8d 4d ff          	lea    rcx,[rbp-0x1]
   182c6c0c4:	48 89 c2             	mov    rdx,rax
   182c6c0c7:	e8 e4 c7 88 fe       	call   0x1814f88b0
   182c6c0cc:	90                   	nop
   182c6c0cd:	48 8d 4d b8          	lea    rcx,[rbp-0x48]
   182c6c0d1:	e8 ca 5d 49 fd       	call   0x180101ea0
   182c6c0d6:	0f b6 47 34          	movzx  eax,BYTE PTR [rdi+0x34]
   182c6c0da:	85 c0                	test   eax,eax
   182c6c0dc:	0f 84 d8 01 00 00    	je     0x182c6c2ba
   182c6c0e2:	a8 01                	test   al,0x1
   182c6c0e4:	74 26                	je     0x182c6c10c
   182c6c0e6:	80 4e 34 01          	or     BYTE PTR [rsi+0x34],0x1
   182c6c0ea:	48 8b 4e 08          	mov    rcx,QWORD PTR [rsi+0x8]
   182c6c0ee:	48 85 c9             	test   rcx,rcx
   182c6c0f1:	0f 84 a7 00 00 00    	je     0x182c6c19e
   182c6c0f7:	48 8b 57 08          	mov    rdx,QWORD PTR [rdi+0x8]
   182c6c0fb:	48 85 d2             	test   rdx,rdx
   182c6c0fe:	0f 84 c7 00 00 00    	je     0x182c6c1cb
   182c6c104:	e8 07 76 96 fd       	call   0x1805d3710
   182c6c109:	8b 47 34             	mov    eax,DWORD PTR [rdi+0x34]
   182c6c10c:	a8 02                	test   al,0x2
   182c6c10e:	74 66                	je     0x182c6c176
   182c6c110:	48 8b 5f 10          	mov    rbx,QWORD PTR [rdi+0x10]
   182c6c114:	83 4e 34 02          	or     DWORD PTR [rsi+0x34],0x2
   182c6c118:	48 8b 46 10          	mov    rax,QWORD PTR [rsi+0x10]
   182c6c11c:	48 8d 0d 15 2c bd 07 	lea    rcx,[rip+0x7bd2c15]        # 0x18a83ed38
   182c6c123:	48 39 c8             	cmp    rax,rcx
   182c6c126:	75 24                	jne    0x182c6c14c
   182c6c128:	b9 20 00 00 00       	mov    ecx,0x20
   182c6c12d:	e8 ca 0f ba 03       	call   0x18680d0fc
   182c6c132:	0f 57 c0             	xorps  xmm0,xmm0
   182c6c135:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   182c6c138:	48 c7 40 10 00 00 00 	mov    QWORD PTR [rax+0x10],0x0
   182c6c13f:	00 
   182c6c140:	48 c7 40 18 0f 00 00 	mov    QWORD PTR [rax+0x18],0xf
   182c6c147:	00 
   182c6c148:	48 89 46 10          	mov    QWORD PTR [rsi+0x10],rax
   182c6c14c:	48 39 d8             	cmp    rax,rbx
   182c6c14f:	74 25                	je     0x182c6c176
   182c6c151:	4c 8b 73 10          	mov    r14,QWORD PTR [rbx+0x10]
   182c6c155:	48 83 7b 18 10       	cmp    QWORD PTR [rbx+0x18],0x10
   182c6c15a:	72 03                	jb     0x182c6c15f
   182c6c15c:	48 8b 1b             	mov    rbx,QWORD PTR [rbx]
   182c6c15f:	48 8b 48 18          	mov    rcx,QWORD PTR [rax+0x18]
   182c6c163:	49 39 ce             	cmp    r14,rcx
   182c6c166:	76 73                	jbe    0x182c6c1db
   182c6c168:	48 89 c1             	mov    rcx,rax
   182c6c16b:	4c 89 f2             	mov    rdx,r14
   182c6c16e:	49 89 d9             	mov    r9,rbx
   182c6c171:	e8 fa 82 3e fd       	call   0x180054470
   182c6c176:	8b 47 34             	mov    eax,DWORD PTR [rdi+0x34]
   182c6c179:	a8 04                	test   al,0x4
   182c6c17b:	0f 85 88 00 00 00    	jne    0x182c6c209
   182c6c181:	a8 08                	test   al,0x8
   182c6c183:	0f 85 95 00 00 00    	jne    0x182c6c21e
   182c6c189:	a8 10                	test   al,0x10
   182c6c18b:	0f 85 a2 00 00 00    	jne    0x182c6c233
   182c6c191:	a8 20                	test   al,0x20
   182c6c193:	0f 85 ab 00 00 00    	jne    0x182c6c244
   182c6c199:	e9 0c 01 00 00       	jmp    0x182c6c2aa
   182c6c19e:	b9 18 00 00 00       	mov    ecx,0x18
   182c6c1a3:	e8 54 0f ba 03       	call   0x18680d0fc
   182c6c1a8:	90                   	nop
   182c6c1a9:	48 89 45 f0          	mov    QWORD PTR [rbp-0x10],rax
   182c6c1ad:	48 89 c1             	mov    rcx,rax
   182c6c1b0:	e8 bb 57 96 fd       	call   0x1805d1970
   182c6c1b5:	90                   	nop
   182c6c1b6:	48 8b 4d f0          	mov    rcx,QWORD PTR [rbp-0x10]
   182c6c1ba:	48 89 4e 08          	mov    QWORD PTR [rsi+0x8],rcx
   182c6c1be:	48 8b 57 08          	mov    rdx,QWORD PTR [rdi+0x8]
   182c6c1c2:	48 85 d2             	test   rdx,rdx
   182c6c1c5:	0f 85 39 ff ff ff    	jne    0x182c6c104
   182c6c1cb:	48 8b 05 ce e6 bf 07 	mov    rax,QWORD PTR [rip+0x7bfe6ce]        # 0x18a86a8a0
   182c6c1d2:	48 8b 50 08          	mov    rdx,QWORD PTR [rax+0x8]
   182c6c1d6:	e9 29 ff ff ff       	jmp    0x182c6c104
   182c6c1db:	49 89 c7             	mov    r15,rax
   182c6c1de:	48 83 f9 10          	cmp    rcx,0x10
   182c6c1e2:	72 03                	jb     0x182c6c1e7
   182c6c1e4:	4c 8b 38             	mov    r15,QWORD PTR [rax]
   182c6c1e7:	4c 89 70 10          	mov    QWORD PTR [rax+0x10],r14
   182c6c1eb:	4c 89 f9             	mov    rcx,r15
   182c6c1ee:	48 89 da             	mov    rdx,rbx
   182c6c1f1:	4d 89 f0             	mov    r8,r14
   182c6c1f4:	e8 d7 9e c2 03       	call   0x1868960d0
   182c6c1f9:	43 c6 04 37 00       	mov    BYTE PTR [r15+r14*1],0x0
   182c6c1fe:	8b 47 34             	mov    eax,DWORD PTR [rdi+0x34]
   182c6c201:	a8 04                	test   al,0x4
   182c6c203:	0f 84 78 ff ff ff    	je     0x182c6c181
   182c6c209:	8b 47 18             	mov    eax,DWORD PTR [rdi+0x18]
   182c6c20c:	83 4e 34 04          	or     DWORD PTR [rsi+0x34],0x4
   182c6c210:	89 46 18             	mov    DWORD PTR [rsi+0x18],eax
   182c6c213:	8b 47 34             	mov    eax,DWORD PTR [rdi+0x34]
   182c6c216:	a8 08                	test   al,0x8
   182c6c218:	0f 84 6b ff ff ff    	je     0x182c6c189
   182c6c21e:	8b 47 1c             	mov    eax,DWORD PTR [rdi+0x1c]
   182c6c221:	83 4e 34 08          	or     DWORD PTR [rsi+0x34],0x8
   182c6c225:	89 46 1c             	mov    DWORD PTR [rsi+0x1c],eax
   182c6c228:	8b 47 34             	mov    eax,DWORD PTR [rdi+0x34]
   182c6c22b:	a8 10                	test   al,0x10
   182c6c22d:	0f 84 5e ff ff ff    	je     0x182c6c191
   182c6c233:	8b 47 28             	mov    eax,DWORD PTR [rdi+0x28]
   182c6c236:	83 4e 34 10          	or     DWORD PTR [rsi+0x34],0x10
   182c6c23a:	89 46 28             	mov    DWORD PTR [rsi+0x28],eax
   182c6c23d:	8b 47 34             	mov    eax,DWORD PTR [rdi+0x34]
   182c6c240:	a8 20                	test   al,0x20
   182c6c242:	74 66                	je     0x182c6c2aa
   182c6c244:	48 8b 5f 20          	mov    rbx,QWORD PTR [rdi+0x20]
   182c6c248:	83 4e 34 20          	or     DWORD PTR [rsi+0x34],0x20
   182c6c24c:	48 8b 46 20          	mov    rax,QWORD PTR [rsi+0x20]
   182c6c250:	48 8d 0d e1 2a bd 07 	lea    rcx,[rip+0x7bd2ae1]        # 0x18a83ed38
   182c6c257:	48 39 c8             	cmp    rax,rcx
   182c6c25a:	75 24                	jne    0x182c6c280
   182c6c25c:	b9 20 00 00 00       	mov    ecx,0x20
   182c6c261:	e8 96 0e ba 03       	call   0x18680d0fc
   182c6c266:	0f 57 c0             	xorps  xmm0,xmm0
   182c6c269:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   182c6c26c:	48 c7 40 10 00 00 00 	mov    QWORD PTR [rax+0x10],0x0
   182c6c273:	00 
   182c6c274:	48 c7 40 18 0f 00 00 	mov    QWORD PTR [rax+0x18],0xf
   182c6c27b:	00 
   182c6c27c:	48 89 46 20          	mov    QWORD PTR [rsi+0x20],rax
   182c6c280:	48 39 d8             	cmp    rax,rbx
   182c6c283:	74 25                	je     0x182c6c2aa
   182c6c285:	4c 8b 73 10          	mov    r14,QWORD PTR [rbx+0x10]
   182c6c289:	48 83 7b 18 10       	cmp    QWORD PTR [rbx+0x18],0x10
   182c6c28e:	72 03                	jb     0x182c6c293
   182c6c290:	48 8b 1b             	mov    rbx,QWORD PTR [rbx]
   182c6c293:	48 8b 48 18          	mov    rcx,QWORD PTR [rax+0x18]
   182c6c297:	49 39 ce             	cmp    r14,rcx
   182c6c29a:	76 2b                	jbe    0x182c6c2c7
   182c6c29c:	48 89 c1             	mov    rcx,rax
   182c6c29f:	4c 89 f2             	mov    rdx,r14
   182c6c2a2:	49 89 d9             	mov    r9,rbx
   182c6c2a5:	e8 c6 81 3e fd       	call   0x180054470
   182c6c2aa:	f6 47 34 40          	test   BYTE PTR [rdi+0x34],0x40
   182c6c2ae:	74 0a                	je     0x182c6c2ba
   182c6c2b0:	8b 47 2c             	mov    eax,DWORD PTR [rdi+0x2c]
   182c6c2b3:	83 4e 34 40          	or     DWORD PTR [rsi+0x34],0x40
   182c6c2b7:	89 46 2c             	mov    DWORD PTR [rsi+0x2c],eax
   182c6c2ba:	48 83 c4 78          	add    rsp,0x78
   182c6c2be:	5b                   	pop    rbx
   182c6c2bf:	5f                   	pop    rdi
   182c6c2c0:	5e                   	pop    rsi
   182c6c2c1:	41 5e                	pop    r14
   182c6c2c3:	41 5f                	pop    r15
   182c6c2c5:	5d                   	pop    rbp
   182c6c2c6:	c3                   	ret
   182c6c2c7:	49 89 c7             	mov    r15,rax
   182c6c2ca:	48 83 f9 10          	cmp    rcx,0x10
   182c6c2ce:	72 03                	jb     0x182c6c2d3
   182c6c2d0:	4c 8b 38             	mov    r15,QWORD PTR [rax]
   182c6c2d3:	4c 89 70 10          	mov    QWORD PTR [rax+0x10],r14
   182c6c2d7:	4c 89 f9             	mov    rcx,r15
   182c6c2da:	48 89 da             	mov    rdx,rbx
   182c6c2dd:	4d 89 f0             	mov    r8,r14
   182c6c2e0:	e8 eb 9d c2 03       	call   0x1868960d0
   182c6c2e5:	43 c6 04 37 00       	mov    BYTE PTR [r15+r14*1],0x0
   182c6c2ea:	f6 47 34 40          	test   BYTE PTR [rdi+0x34],0x40
   182c6c2ee:	75 c0                	jne    0x182c6c2b0
   182c6c2f0:	eb c8                	jmp    0x182c6c2ba
