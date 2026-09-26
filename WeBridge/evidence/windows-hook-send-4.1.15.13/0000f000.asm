
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

000000018000f000 <.text+0xe000>:
   18000f000:	55                   	push   rbp
   18000f001:	41 57                	push   r15
   18000f003:	41 56                	push   r14
   18000f005:	41 55                	push   r13
   18000f007:	41 54                	push   r12
   18000f009:	56                   	push   rsi
   18000f00a:	57                   	push   rdi
   18000f00b:	53                   	push   rbx
   18000f00c:	48 81 ec c8 02 00 00 	sub    rsp,0x2c8
   18000f013:	48 8d ac 24 80 00 00 	lea    rbp,[rsp+0x80]
   18000f01a:	00 
   18000f01b:	48 c7 85 40 02 00 00 	mov    QWORD PTR [rbp+0x240],0xfffffffffffffffe
   18000f022:	fe ff ff ff 
   18000f026:	4d 89 cf             	mov    r15,r9
   18000f029:	4d 89 c5             	mov    r13,r8
   18000f02c:	49 89 d4             	mov    r12,rdx
   18000f02f:	48 89 ce             	mov    rsi,rcx
   18000f032:	4c 8b b5 b0 02 00 00 	mov    r14,QWORD PTR [rbp+0x2b0]
   18000f039:	48 83 bd c8 02 00 00 	cmp    QWORD PTR [rbp+0x2c8],0x0
   18000f040:	00 
   18000f041:	4c 89 8d 30 02 00 00 	mov    QWORD PTR [rbp+0x230],r9
   18000f048:	4c 89 85 28 02 00 00 	mov    QWORD PTR [rbp+0x228],r8
   18000f04f:	0f 85 2c 01 00 00    	jne    0x18000f181
   18000f055:	48 8b 05 54 d2 0a 0b 	mov    rax,QWORD PTR [rip+0xb0ad254]        # 0x18b0bc2b0
   18000f05c:	48 ff c0             	inc    rax
   18000f05f:	48 89 05 4a d2 0a 0b 	mov    QWORD PTR [rip+0xb0ad24a],rax        # 0x18b0bc2b0
   18000f066:	48 89 85 c8 02 00 00 	mov    QWORD PTR [rbp+0x2c8],rax
   18000f06d:	48 8b 4e 48          	mov    rcx,QWORD PTR [rsi+0x48]
   18000f071:	48 85 c9             	test   rcx,rcx
   18000f074:	74 5a                	je     0x18000f0d0
   18000f076:	8b 41 08             	mov    eax,DWORD PTR [rcx+0x8]
   18000f079:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
   18000f080:	85 c0                	test   eax,eax
   18000f082:	74 4c                	je     0x18000f0d0
   18000f084:	8d 50 01             	lea    edx,[rax+0x1]
   18000f087:	f0 0f b1 51 08       	lock cmpxchg DWORD PTR [rcx+0x8],edx
   18000f08c:	75 f2                	jne    0x18000f080
   18000f08e:	48 8b 7e 48          	mov    rdi,QWORD PTR [rsi+0x48]
   18000f092:	48 83 7e 40 00       	cmp    QWORD PTR [rsi+0x40],0x0
   18000f097:	0f 84 20 05 00 00    	je     0x18000f5bd
   18000f09d:	48 85 ff             	test   rdi,rdi
   18000f0a0:	0f 84 db 00 00 00    	je     0x18000f181
   18000f0a6:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   18000f0aa:	0f 85 d1 00 00 00    	jne    0x18000f181
   18000f0b0:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   18000f0b3:	48 89 f9             	mov    rcx,rdi
   18000f0b6:	ff 10                	call   QWORD PTR [rax]
   18000f0b8:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   18000f0bc:	0f 85 bf 00 00 00    	jne    0x18000f181
   18000f0c2:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   18000f0c5:	48 89 f9             	mov    rcx,rdi
   18000f0c8:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18000f0cb:	e9 b1 00 00 00       	jmp    0x18000f181
   18000f0d0:	48 83 7e 38 00       	cmp    QWORD PTR [rsi+0x38],0x0
   18000f0d5:	0f 84 a6 00 00 00    	je     0x18000f181
   18000f0db:	48 8b 3d de 31 90 0b 	mov    rdi,QWORD PTR [rip+0xb9031de]        # 0x18b9122c0
   18000f0e2:	48 89 f9             	mov    rcx,rdi
   18000f0e5:	e8 1e d8 49 07       	call   0x1874ac908
   18000f0ea:	85 c0                	test   eax,eax
   18000f0ec:	0f 85 65 06 00 00    	jne    0x18000f757
   18000f0f2:	48 89 bd 38 02 00 00 	mov    QWORD PTR [rbp+0x238],rdi
   18000f0f9:	81 7f 4c ff ff ff 7f 	cmp    DWORD PTR [rdi+0x4c],0x7fffffff
   18000f100:	0f 84 5c 06 00 00    	je     0x18000f762
   18000f106:	48 8b 95 c0 02 00 00 	mov    rdx,QWORD PTR [rbp+0x2c0]
   18000f10d:	48 8d 8d 40 01 00 00 	lea    rcx,[rbp+0x140]
   18000f114:	e8 b7 ae 18 00       	call   0x180199fd0
   18000f119:	90                   	nop
   18000f11a:	c7 85 60 01 00 00 00 	mov    DWORD PTR [rbp+0x160],0x0
   18000f121:	00 00 00 
   18000f124:	48 8d 0d 85 31 90 0b 	lea    rcx,[rip+0xb903185]        # 0x18b9122b0
   18000f12b:	48 8d 95 30 01 00 00 	lea    rdx,[rbp+0x130]
   18000f132:	4c 8d 85 c8 02 00 00 	lea    r8,[rbp+0x2c8]
   18000f139:	e8 12 10 00 00       	call   0x180010150
   18000f13e:	90                   	nop
   18000f13f:	48 8b bd 30 01 00 00 	mov    rdi,QWORD PTR [rbp+0x130]
   18000f146:	48 8d 4f 28          	lea    rcx,[rdi+0x28]
   18000f14a:	48 8d 95 40 01 00 00 	lea    rdx,[rbp+0x140]
   18000f151:	e8 7a ae 18 00       	call   0x180199fd0
   18000f156:	90                   	nop
   18000f157:	8b 85 60 01 00 00    	mov    eax,DWORD PTR [rbp+0x160]
   18000f15d:	89 47 48             	mov    DWORD PTR [rdi+0x48],eax
   18000f160:	48 8b 8d 38 02 00 00 	mov    rcx,QWORD PTR [rbp+0x238]
   18000f167:	e8 c4 d7 49 07       	call   0x1874ac930
   18000f16c:	4c 8b b5 b0 02 00 00 	mov    r14,QWORD PTR [rbp+0x2b0]
   18000f173:	4c 8b bd 30 02 00 00 	mov    r15,QWORD PTR [rbp+0x230]
   18000f17a:	4c 8b ad 28 02 00 00 	mov    r13,QWORD PTR [rbp+0x228]
   18000f181:	48 8b bd c8 02 00 00 	mov    rdi,QWORD PTR [rbp+0x2c8]
   18000f188:	49 89 3c 24          	mov    QWORD PTR [r12],rdi
   18000f18c:	0f 57 c0             	xorps  xmm0,xmm0
   18000f18f:	41 0f 11 44 24 08    	movups XMMWORD PTR [r12+0x8],xmm0
   18000f195:	41 0f 11 44 24 18    	movups XMMWORD PTR [r12+0x18],xmm0
   18000f19b:	48 83 7e 38 00       	cmp    QWORD PTR [rsi+0x38],0x0
   18000f1a0:	4c 89 a5 38 02 00 00 	mov    QWORD PTR [rbp+0x238],r12
   18000f1a7:	0f 84 9a 00 00 00    	je     0x18000f247
   18000f1ad:	48 b8 aa aa aa aa aa 	movabs rax,0xaaaaaaaaaaaaaaaa
   18000f1b4:	aa aa aa 
   18000f1b7:	48 89 85 20 02 00 00 	mov    QWORD PTR [rbp+0x220],rax
   18000f1be:	0f 28 05 eb 69 d3 08 	movaps xmm0,XMMWORD PTR [rip+0x8d369eb]        # 0x188d45bb0
   18000f1c5:	0f 29 85 10 02 00 00 	movaps XMMWORD PTR [rbp+0x210],xmm0
   18000f1cc:	0f 29 85 00 02 00 00 	movaps XMMWORD PTR [rbp+0x200],xmm0
   18000f1d3:	0f 29 85 f0 01 00 00 	movaps XMMWORD PTR [rbp+0x1f0],xmm0
   18000f1da:	0f 29 85 e0 01 00 00 	movaps XMMWORD PTR [rbp+0x1e0],xmm0
   18000f1e1:	0f 29 85 d0 01 00 00 	movaps XMMWORD PTR [rbp+0x1d0],xmm0
   18000f1e8:	0f 29 85 c0 01 00 00 	movaps XMMWORD PTR [rbp+0x1c0],xmm0
   18000f1ef:	0f 29 85 b0 01 00 00 	movaps XMMWORD PTR [rbp+0x1b0],xmm0
   18000f1f6:	0f 29 85 a0 01 00 00 	movaps XMMWORD PTR [rbp+0x1a0],xmm0
   18000f1fd:	0f 29 85 90 01 00 00 	movaps XMMWORD PTR [rbp+0x190],xmm0
   18000f204:	0f 29 85 80 01 00 00 	movaps XMMWORD PTR [rbp+0x180],xmm0
   18000f20b:	0f 29 85 70 01 00 00 	movaps XMMWORD PTR [rbp+0x170],xmm0
   18000f212:	0f 29 85 60 01 00 00 	movaps XMMWORD PTR [rbp+0x160],xmm0
   18000f219:	0f 29 85 50 01 00 00 	movaps XMMWORD PTR [rbp+0x150],xmm0
   18000f220:	0f 29 85 40 01 00 00 	movaps XMMWORD PTR [rbp+0x140],xmm0
   18000f227:	48 c7 45 e8 00 00 00 	mov    QWORD PTR [rbp-0x18],0x0
   18000f22e:	00 
   18000f22f:	49 8b 4e 38          	mov    rcx,QWORD PTR [r14+0x38]
   18000f233:	48 85 c9             	test   rcx,rcx
   18000f236:	0f 84 7e 00 00 00    	je     0x18000f2ba
   18000f23c:	4c 39 f1             	cmp    rcx,r14
   18000f23f:	74 4e                	je     0x18000f28f
   18000f241:	48 89 4d e8          	mov    QWORD PTR [rbp-0x18],rcx
   18000f245:	eb 6b                	jmp    0x18000f2b2
   18000f247:	0f 29 85 40 01 00 00 	movaps XMMWORD PTR [rbp+0x140],xmm0
   18000f24e:	48 8b 4e 48          	mov    rcx,QWORD PTR [rsi+0x48]
   18000f252:	48 85 c9             	test   rcx,rcx
   18000f255:	0f 84 29 02 00 00    	je     0x18000f484
   18000f25b:	8b 41 08             	mov    eax,DWORD PTR [rcx+0x8]
   18000f25e:	66 90                	xchg   ax,ax
   18000f260:	85 c0                	test   eax,eax
   18000f262:	0f 84 15 03 00 00    	je     0x18000f57d
   18000f268:	8d 50 01             	lea    edx,[rax+0x1]
   18000f26b:	f0 0f b1 51 08       	lock cmpxchg DWORD PTR [rcx+0x8],edx
   18000f270:	75 ee                	jne    0x18000f260
   18000f272:	0f 10 46 40          	movups xmm0,XMMWORD PTR [rsi+0x40]
   18000f276:	48 8b 7e 40          	mov    rdi,QWORD PTR [rsi+0x40]
   18000f27a:	0f 29 85 40 01 00 00 	movaps XMMWORD PTR [rbp+0x140],xmm0
   18000f281:	48 85 ff             	test   rdi,rdi
   18000f284:	0f 85 03 03 00 00    	jne    0x18000f58d
   18000f28a:	e9 ca 01 00 00       	jmp    0x18000f459
   18000f28f:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000f292:	48 8d 55 b0          	lea    rdx,[rbp-0x50]
   18000f296:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18000f299:	48 89 45 e8          	mov    QWORD PTR [rbp-0x18],rax
   18000f29d:	49 8b 4e 38          	mov    rcx,QWORD PTR [r14+0x38]
   18000f2a1:	48 85 c9             	test   rcx,rcx
   18000f2a4:	74 14                	je     0x18000f2ba
   18000f2a6:	4c 39 f1             	cmp    rcx,r14
   18000f2a9:	0f 95 c2             	setne  dl
   18000f2ac:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000f2af:	ff 50 20             	call   QWORD PTR [rax+0x20]
   18000f2b2:	49 c7 46 38 00 00 00 	mov    QWORD PTR [r14+0x38],0x0
   18000f2b9:	00 
   18000f2ba:	48 c7 45 28 00 00 00 	mov    QWORD PTR [rbp+0x28],0x0
   18000f2c1:	00 
   18000f2c2:	49 8b 4f 38          	mov    rcx,QWORD PTR [r15+0x38]
   18000f2c6:	48 85 c9             	test   rcx,rcx
   18000f2c9:	74 36                	je     0x18000f301
   18000f2cb:	4c 39 f9             	cmp    rcx,r15
   18000f2ce:	74 06                	je     0x18000f2d6
   18000f2d0:	48 89 4d 28          	mov    QWORD PTR [rbp+0x28],rcx
   18000f2d4:	eb 23                	jmp    0x18000f2f9
   18000f2d6:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000f2d9:	48 8d 55 f0          	lea    rdx,[rbp-0x10]
   18000f2dd:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18000f2e0:	48 89 45 28          	mov    QWORD PTR [rbp+0x28],rax
   18000f2e4:	49 8b 4f 38          	mov    rcx,QWORD PTR [r15+0x38]
   18000f2e8:	48 85 c9             	test   rcx,rcx
   18000f2eb:	74 14                	je     0x18000f301
   18000f2ed:	4c 39 f9             	cmp    rcx,r15
   18000f2f0:	0f 95 c2             	setne  dl
   18000f2f3:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000f2f6:	ff 50 20             	call   QWORD PTR [rax+0x20]
   18000f2f9:	49 c7 47 38 00 00 00 	mov    QWORD PTR [r15+0x38],0x0
   18000f300:	00 
   18000f301:	48 8b 9d b8 02 00 00 	mov    rbx,QWORD PTR [rbp+0x2b8]
   18000f308:	48 c7 45 68 00 00 00 	mov    QWORD PTR [rbp+0x68],0x0
   18000f30f:	00 
   18000f310:	49 8b 4d 38          	mov    rcx,QWORD PTR [r13+0x38]
   18000f314:	48 85 c9             	test   rcx,rcx
   18000f317:	74 36                	je     0x18000f34f
   18000f319:	4c 39 e9             	cmp    rcx,r13
   18000f31c:	74 06                	je     0x18000f324
   18000f31e:	48 89 4d 68          	mov    QWORD PTR [rbp+0x68],rcx
   18000f322:	eb 23                	jmp    0x18000f347
   18000f324:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000f327:	48 8d 55 30          	lea    rdx,[rbp+0x30]
   18000f32b:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18000f32e:	48 89 45 68          	mov    QWORD PTR [rbp+0x68],rax
   18000f332:	49 8b 4d 38          	mov    rcx,QWORD PTR [r13+0x38]
   18000f336:	48 85 c9             	test   rcx,rcx
   18000f339:	74 14                	je     0x18000f34f
   18000f33b:	4c 39 e9             	cmp    rcx,r13
   18000f33e:	0f 95 c2             	setne  dl
   18000f341:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000f344:	ff 50 20             	call   QWORD PTR [rax+0x20]
   18000f347:	49 c7 45 38 00 00 00 	mov    QWORD PTR [r13+0x38],0x0
   18000f34e:	00 
   18000f34f:	48 89 7c 24 28       	mov    QWORD PTR [rsp+0x28],rdi
   18000f354:	48 89 5c 24 20       	mov    QWORD PTR [rsp+0x20],rbx
   18000f359:	48 8d 8d 40 01 00 00 	lea    rcx,[rbp+0x140]
   18000f360:	48 8d 55 30          	lea    rdx,[rbp+0x30]
   18000f364:	4c 8d 45 f0          	lea    r8,[rbp-0x10]
   18000f368:	4c 8d 4d b0          	lea    r9,[rbp-0x50]
   18000f36c:	e8 9f 05 00 00       	call   0x18000f910
   18000f371:	90                   	nop
   18000f372:	48 8b 4e 38          	mov    rcx,QWORD PTR [rsi+0x38]
   18000f376:	48 85 c9             	test   rcx,rcx
   18000f379:	0f 84 d2 03 00 00    	je     0x18000f751
   18000f37f:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000f382:	48 8d 95 40 01 00 00 	lea    rdx,[rbp+0x140]
   18000f389:	ff 50 10             	call   QWORD PTR [rax+0x10]
   18000f38c:	90                   	nop
   18000f38d:	48 8b 85 48 01 00 00 	mov    rax,QWORD PTR [rbp+0x148]
   18000f394:	48 85 c0             	test   rax,rax
   18000f397:	74 0d                	je     0x18000f3a6
   18000f399:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   18000f39d:	48 8b 85 48 01 00 00 	mov    rax,QWORD PTR [rbp+0x148]
   18000f3a4:	eb 02                	jmp    0x18000f3a8
   18000f3a6:	31 c0                	xor    eax,eax
   18000f3a8:	48 8b 95 38 02 00 00 	mov    rdx,QWORD PTR [rbp+0x238]
   18000f3af:	48 8b 8d 40 01 00 00 	mov    rcx,QWORD PTR [rbp+0x140]
   18000f3b6:	48 89 4a 08          	mov    QWORD PTR [rdx+0x8],rcx
   18000f3ba:	48 8b 7a 10          	mov    rdi,QWORD PTR [rdx+0x10]
   18000f3be:	48 89 42 10          	mov    QWORD PTR [rdx+0x10],rax
   18000f3c2:	48 85 ff             	test   rdi,rdi
   18000f3c5:	74 1d                	je     0x18000f3e4
   18000f3c7:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   18000f3cb:	75 17                	jne    0x18000f3e4
   18000f3cd:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   18000f3d0:	48 89 f9             	mov    rcx,rdi
   18000f3d3:	ff 10                	call   QWORD PTR [rax]
   18000f3d5:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   18000f3d9:	75 09                	jne    0x18000f3e4
   18000f3db:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   18000f3de:	48 89 f9             	mov    rcx,rdi
   18000f3e1:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18000f3e4:	48 8b 8d 20 02 00 00 	mov    rcx,QWORD PTR [rbp+0x220]
   18000f3eb:	48 85 c9             	test   rcx,rcx
   18000f3ee:	74 0c                	je     0x18000f3fc
   18000f3f0:	f0 ff 49 0c          	lock dec DWORD PTR [rcx+0xc]
   18000f3f4:	75 06                	jne    0x18000f3fc
   18000f3f6:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000f3f9:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18000f3fc:	48 8b 8d 08 02 00 00 	mov    rcx,QWORD PTR [rbp+0x208]
   18000f403:	48 85 c9             	test   rcx,rcx
   18000f406:	74 13                	je     0x18000f41b
   18000f408:	48 8d 85 d0 01 00 00 	lea    rax,[rbp+0x1d0]
   18000f40f:	48 39 c1             	cmp    rcx,rax
   18000f412:	0f 95 c2             	setne  dl
   18000f415:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000f418:	ff 50 20             	call   QWORD PTR [rax+0x20]
   18000f41b:	48 8b 8d c8 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1c8]
   18000f422:	48 85 c9             	test   rcx,rcx
   18000f425:	74 13                	je     0x18000f43a
   18000f427:	48 8d 85 90 01 00 00 	lea    rax,[rbp+0x190]
   18000f42e:	48 39 c1             	cmp    rcx,rax
   18000f431:	0f 95 c2             	setne  dl
   18000f434:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000f437:	ff 50 20             	call   QWORD PTR [rax+0x20]
   18000f43a:	48 8b 8d 88 01 00 00 	mov    rcx,QWORD PTR [rbp+0x188]
   18000f441:	48 85 c9             	test   rcx,rcx
   18000f444:	74 13                	je     0x18000f459
   18000f446:	48 8d 85 50 01 00 00 	lea    rax,[rbp+0x150]
   18000f44d:	48 39 c1             	cmp    rcx,rax
   18000f450:	0f 95 c2             	setne  dl
   18000f453:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000f456:	ff 50 20             	call   QWORD PTR [rax+0x20]
   18000f459:	48 8b bd 48 01 00 00 	mov    rdi,QWORD PTR [rbp+0x148]
   18000f460:	48 85 ff             	test   rdi,rdi
   18000f463:	74 26                	je     0x18000f48b
   18000f465:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   18000f469:	75 20                	jne    0x18000f48b
   18000f46b:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   18000f46e:	48 89 f9             	mov    rcx,rdi
   18000f471:	ff 10                	call   QWORD PTR [rax]
   18000f473:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   18000f477:	75 12                	jne    0x18000f48b
   18000f479:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   18000f47c:	48 89 f9             	mov    rcx,rdi
   18000f47f:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18000f482:	eb 07                	jmp    0x18000f48b
   18000f484:	31 ff                	xor    edi,edi
   18000f486:	48 85 ff             	test   rdi,rdi
   18000f489:	75 da                	jne    0x18000f465
   18000f48b:	b9 28 00 00 00       	mov    ecx,0x28
   18000f490:	e8 07 c4 49 07       	call   0x1874ab89c
   18000f495:	90                   	nop
   18000f496:	48 b9 01 00 00 00 01 	movabs rcx,0x100000001
   18000f49d:	00 00 00 
   18000f4a0:	48 89 48 08          	mov    QWORD PTR [rax+0x8],rcx
   18000f4a4:	48 8d 0d fd 82 d3 08 	lea    rcx,[rip+0x8d382fd]        # 0x188d477a8
   18000f4ab:	48 89 08             	mov    QWORD PTR [rax],rcx
   18000f4ae:	48 8b 4e 48          	mov    rcx,QWORD PTR [rsi+0x48]
   18000f4b2:	48 85 c9             	test   rcx,rcx
   18000f4b5:	74 0a                	je     0x18000f4c1
   18000f4b7:	48 8b 56 40          	mov    rdx,QWORD PTR [rsi+0x40]
   18000f4bb:	f0 ff 41 0c          	lock inc DWORD PTR [rcx+0xc]
   18000f4bf:	eb 02                	jmp    0x18000f4c3
   18000f4c1:	31 d2                	xor    edx,edx
   18000f4c3:	48 8b bd b0 02 00 00 	mov    rdi,QWORD PTR [rbp+0x2b0]
   18000f4ca:	48 8b 9d 30 02 00 00 	mov    rbx,QWORD PTR [rbp+0x230]
   18000f4d1:	4c 8b b5 38 02 00 00 	mov    r14,QWORD PTR [rbp+0x238]
   18000f4d8:	4c 8b bd 28 02 00 00 	mov    r15,QWORD PTR [rbp+0x228]
   18000f4df:	49 89 c0             	mov    r8,rax
   18000f4e2:	49 83 c0 10          	add    r8,0x10
   18000f4e6:	4c 8d 0d 4b 83 d3 08 	lea    r9,[rip+0x8d3834b]        # 0x188d47838
   18000f4ed:	4c 89 48 10          	mov    QWORD PTR [rax+0x10],r9
   18000f4f1:	48 89 50 18          	mov    QWORD PTR [rax+0x18],rdx
   18000f4f5:	48 89 48 20          	mov    QWORD PTR [rax+0x20],rcx
   18000f4f9:	4d 89 46 18          	mov    QWORD PTR [r14+0x18],r8
   18000f4fd:	49 8b 76 20          	mov    rsi,QWORD PTR [r14+0x20]
   18000f501:	49 89 46 20          	mov    QWORD PTR [r14+0x20],rax
   18000f505:	48 85 f6             	test   rsi,rsi
   18000f508:	74 1d                	je     0x18000f527
   18000f50a:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   18000f50e:	75 17                	jne    0x18000f527
   18000f510:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   18000f513:	48 89 f1             	mov    rcx,rsi
   18000f516:	ff 10                	call   QWORD PTR [rax]
   18000f518:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   18000f51c:	75 09                	jne    0x18000f527
   18000f51e:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   18000f521:	48 89 f1             	mov    rcx,rsi
   18000f524:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18000f527:	49 8b 4f 38          	mov    rcx,QWORD PTR [r15+0x38]
   18000f52b:	48 85 c9             	test   rcx,rcx
   18000f52e:	74 0c                	je     0x18000f53c
   18000f530:	4c 39 f9             	cmp    rcx,r15
   18000f533:	0f 95 c2             	setne  dl
   18000f536:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000f539:	ff 50 20             	call   QWORD PTR [rax+0x20]
   18000f53c:	48 8b 4b 38          	mov    rcx,QWORD PTR [rbx+0x38]
   18000f540:	48 85 c9             	test   rcx,rcx
   18000f543:	74 0c                	je     0x18000f551
   18000f545:	48 39 d9             	cmp    rcx,rbx
   18000f548:	0f 95 c2             	setne  dl
   18000f54b:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000f54e:	ff 50 20             	call   QWORD PTR [rax+0x20]
   18000f551:	48 8b 4f 38          	mov    rcx,QWORD PTR [rdi+0x38]
   18000f555:	48 85 c9             	test   rcx,rcx
   18000f558:	74 0c                	je     0x18000f566
   18000f55a:	48 39 f9             	cmp    rcx,rdi
   18000f55d:	0f 95 c2             	setne  dl
   18000f560:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000f563:	ff 50 20             	call   QWORD PTR [rax+0x20]
   18000f566:	4c 89 f0             	mov    rax,r14
   18000f569:	48 81 c4 c8 02 00 00 	add    rsp,0x2c8
   18000f570:	5b                   	pop    rbx
   18000f571:	5f                   	pop    rdi
   18000f572:	5e                   	pop    rsi
   18000f573:	41 5c                	pop    r12
   18000f575:	41 5d                	pop    r13
   18000f577:	41 5e                	pop    r14
   18000f579:	41 5f                	pop    r15
   18000f57b:	5d                   	pop    rbp
   18000f57c:	c3                   	ret
   18000f57d:	48 8b bd 40 01 00 00 	mov    rdi,QWORD PTR [rbp+0x140]
   18000f584:	48 85 ff             	test   rdi,rdi
   18000f587:	0f 84 cc fe ff ff    	je     0x18000f459
   18000f58d:	48 c7 85 a8 00 00 00 	mov    QWORD PTR [rbp+0xa8],0x0
   18000f594:	00 00 00 00 
   18000f598:	4c 8b b5 28 02 00 00 	mov    r14,QWORD PTR [rbp+0x228]
   18000f59f:	49 8b 4e 38          	mov    rcx,QWORD PTR [r14+0x38]
   18000f5a3:	48 85 c9             	test   rcx,rcx
   18000f5a6:	48 8b 9d 38 02 00 00 	mov    rbx,QWORD PTR [rbp+0x238]
   18000f5ad:	74 70                	je     0x18000f61f
   18000f5af:	4c 39 f1             	cmp    rcx,r14
   18000f5b2:	74 3d                	je     0x18000f5f1
   18000f5b4:	48 89 8d a8 00 00 00 	mov    QWORD PTR [rbp+0xa8],rcx
   18000f5bb:	eb 5a                	jmp    0x18000f617
   18000f5bd:	48 8b 5e 38          	mov    rbx,QWORD PTR [rsi+0x38]
   18000f5c1:	48 85 ff             	test   rdi,rdi
   18000f5c4:	74 1d                	je     0x18000f5e3
   18000f5c6:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   18000f5ca:	75 17                	jne    0x18000f5e3
   18000f5cc:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   18000f5cf:	48 89 f9             	mov    rcx,rdi
   18000f5d2:	ff 10                	call   QWORD PTR [rax]
   18000f5d4:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   18000f5d8:	75 09                	jne    0x18000f5e3
   18000f5da:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   18000f5dd:	48 89 f9             	mov    rcx,rdi
   18000f5e0:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18000f5e3:	48 85 db             	test   rbx,rbx
   18000f5e6:	0f 85 ef fa ff ff    	jne    0x18000f0db
   18000f5ec:	e9 90 fb ff ff       	jmp    0x18000f181
   18000f5f1:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000f5f4:	48 8d 55 70          	lea    rdx,[rbp+0x70]
   18000f5f8:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18000f5fb:	48 89 85 a8 00 00 00 	mov    QWORD PTR [rbp+0xa8],rax
   18000f602:	49 8b 4e 38          	mov    rcx,QWORD PTR [r14+0x38]
   18000f606:	48 85 c9             	test   rcx,rcx
   18000f609:	74 14                	je     0x18000f61f
   18000f60b:	4c 39 f1             	cmp    rcx,r14
   18000f60e:	0f 95 c2             	setne  dl
   18000f611:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000f614:	ff 50 20             	call   QWORD PTR [rax+0x20]
   18000f617:	49 c7 46 38 00 00 00 	mov    QWORD PTR [r14+0x38],0x0
   18000f61e:	00 
   18000f61f:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   18000f622:	4c 8d 45 70          	lea    r8,[rbp+0x70]
   18000f626:	48 89 f9             	mov    rcx,rdi
   18000f629:	48 89 da             	mov    rdx,rbx
   18000f62c:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18000f62f:	90                   	nop
   18000f630:	48 8b 85 30 02 00 00 	mov    rax,QWORD PTR [rbp+0x230]
   18000f637:	48 8b 48 38          	mov    rcx,QWORD PTR [rax+0x38]
   18000f63b:	48 85 c9             	test   rcx,rcx
   18000f63e:	74 7c                	je     0x18000f6bc
   18000f640:	48 8b bd 40 01 00 00 	mov    rdi,QWORD PTR [rbp+0x140]
   18000f647:	48 c7 85 e8 00 00 00 	mov    QWORD PTR [rbp+0xe8],0x0
   18000f64e:	00 00 00 00 
   18000f652:	48 8b 9d 30 02 00 00 	mov    rbx,QWORD PTR [rbp+0x230]
   18000f659:	48 39 d9             	cmp    rcx,rbx
   18000f65c:	74 10                	je     0x18000f66e
   18000f65e:	48 89 8d e8 00 00 00 	mov    QWORD PTR [rbp+0xe8],rcx
   18000f665:	48 8b 95 38 02 00 00 	mov    rdx,QWORD PTR [rbp+0x238]
   18000f66c:	eb 36                	jmp    0x18000f6a4
   18000f66e:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000f671:	48 8d 95 b0 00 00 00 	lea    rdx,[rbp+0xb0]
   18000f678:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18000f67b:	48 89 85 e8 00 00 00 	mov    QWORD PTR [rbp+0xe8],rax
   18000f682:	48 8b 4b 38          	mov    rcx,QWORD PTR [rbx+0x38]
   18000f686:	48 85 c9             	test   rcx,rcx
   18000f689:	48 8b 95 38 02 00 00 	mov    rdx,QWORD PTR [rbp+0x238]
   18000f690:	74 1a                	je     0x18000f6ac
   18000f692:	48 39 d9             	cmp    rcx,rbx
   18000f695:	49 89 d6             	mov    r14,rdx
   18000f698:	0f 95 c2             	setne  dl
   18000f69b:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000f69e:	ff 50 20             	call   QWORD PTR [rax+0x20]
   18000f6a1:	4c 89 f2             	mov    rdx,r14
   18000f6a4:	48 c7 43 38 00 00 00 	mov    QWORD PTR [rbx+0x38],0x0
   18000f6ab:	00 
   18000f6ac:	4c 8d 85 b0 00 00 00 	lea    r8,[rbp+0xb0]
   18000f6b3:	48 89 f9             	mov    rcx,rdi
   18000f6b6:	e8 e5 04 00 00       	call   0x18000fba0
   18000f6bb:	90                   	nop
   18000f6bc:	48 8b 85 b0 02 00 00 	mov    rax,QWORD PTR [rbp+0x2b0]
   18000f6c3:	48 8b 48 38          	mov    rcx,QWORD PTR [rax+0x38]
   18000f6c7:	48 85 c9             	test   rcx,rcx
   18000f6ca:	0f 84 89 fd ff ff    	je     0x18000f459
   18000f6d0:	48 8b bd 40 01 00 00 	mov    rdi,QWORD PTR [rbp+0x140]
   18000f6d7:	48 c7 85 28 01 00 00 	mov    QWORD PTR [rbp+0x128],0x0
   18000f6de:	00 00 00 00 
   18000f6e2:	48 8b 9d b0 02 00 00 	mov    rbx,QWORD PTR [rbp+0x2b0]
   18000f6e9:	48 39 d9             	cmp    rcx,rbx
   18000f6ec:	74 10                	je     0x18000f6fe
   18000f6ee:	48 89 8d 28 01 00 00 	mov    QWORD PTR [rbp+0x128],rcx
   18000f6f5:	48 8b 95 38 02 00 00 	mov    rdx,QWORD PTR [rbp+0x238]
   18000f6fc:	eb 36                	jmp    0x18000f734
   18000f6fe:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000f701:	48 8d 95 f0 00 00 00 	lea    rdx,[rbp+0xf0]
   18000f708:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18000f70b:	48 89 85 28 01 00 00 	mov    QWORD PTR [rbp+0x128],rax
   18000f712:	48 8b 4b 38          	mov    rcx,QWORD PTR [rbx+0x38]
   18000f716:	48 85 c9             	test   rcx,rcx
   18000f719:	48 8b 95 38 02 00 00 	mov    rdx,QWORD PTR [rbp+0x238]
   18000f720:	74 1a                	je     0x18000f73c
   18000f722:	48 39 d9             	cmp    rcx,rbx
   18000f725:	49 89 d6             	mov    r14,rdx
   18000f728:	0f 95 c2             	setne  dl
   18000f72b:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000f72e:	ff 50 20             	call   QWORD PTR [rax+0x20]
   18000f731:	4c 89 f2             	mov    rdx,r14
   18000f734:	48 c7 43 38 00 00 00 	mov    QWORD PTR [rbx+0x38],0x0
   18000f73b:	00 
   18000f73c:	4c 8d 85 f0 00 00 00 	lea    r8,[rbp+0xf0]
   18000f743:	48 89 f9             	mov    rcx,rdi
   18000f746:	e8 f5 06 00 00       	call   0x18000fe40
   18000f74b:	90                   	nop
   18000f74c:	e9 08 fd ff ff       	jmp    0x18000f459
   18000f751:	e8 56 cd 49 07       	call   0x1874ac4ac
   18000f756:	90                   	nop
   18000f757:	b9 05 00 00 00       	mov    ecx,0x5
   18000f75c:	e8 e3 c7 49 07       	call   0x1874abf44
   18000f761:	90                   	nop
   18000f762:	48 8b 85 38 02 00 00 	mov    rax,QWORD PTR [rbp+0x238]
   18000f769:	c7 40 4c fe ff ff 7f 	mov    DWORD PTR [rax+0x4c],0x7ffffffe
   18000f770:	b9 06 00 00 00       	mov    ecx,0x6
   18000f775:	e8 ca c7 49 07       	call   0x1874abf44
   18000f77a:	90                   	nop
   18000f77b:	cc                   	int3
