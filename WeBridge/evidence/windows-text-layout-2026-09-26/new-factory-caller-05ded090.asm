
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000185ded090 <.text+0x5dec090>:
   185ded090:	55                   	push   rbp
   185ded091:	41 57                	push   r15
   185ded093:	41 56                	push   r14
   185ded095:	41 55                	push   r13
   185ded097:	41 54                	push   r12
   185ded099:	56                   	push   rsi
   185ded09a:	57                   	push   rdi
   185ded09b:	53                   	push   rbx
   185ded09c:	48 81 ec 38 02 00 00 	sub    rsp,0x238
   185ded0a3:	48 8d ac 24 80 00 00 	lea    rbp,[rsp+0x80]
   185ded0aa:	00 
   185ded0ab:	0f 29 bd a0 01 00 00 	movaps XMMWORD PTR [rbp+0x1a0],xmm7
   185ded0b2:	0f 29 b5 90 01 00 00 	movaps XMMWORD PTR [rbp+0x190],xmm6
   185ded0b9:	48 c7 85 88 01 00 00 	mov    QWORD PTR [rbp+0x188],0xfffffffffffffffe
   185ded0c0:	fe ff ff ff 
   185ded0c4:	4c 89 8d d0 00 00 00 	mov    QWORD PTR [rbp+0xd0],r9
   185ded0cb:	49 89 d5             	mov    r13,rdx
   185ded0ce:	48 89 8d 98 00 00 00 	mov    QWORD PTR [rbp+0x98],rcx
   185ded0d5:	4c 8b a5 20 02 00 00 	mov    r12,QWORD PTR [rbp+0x220]
   185ded0dc:	0f 57 c0             	xorps  xmm0,xmm0
   185ded0df:	0f 29 85 80 00 00 00 	movaps XMMWORD PTR [rbp+0x80],xmm0
   185ded0e6:	48 c7 85 90 00 00 00 	mov    QWORD PTR [rbp+0x90],0x0
   185ded0ed:	00 00 00 00 
   185ded0f1:	0f 29 85 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm0
   185ded0f8:	48 c7 85 10 01 00 00 	mov    QWORD PTR [rbp+0x110],0x0
   185ded0ff:	00 00 00 00 
   185ded103:	0f 29 45 50          	movaps XMMWORD PTR [rbp+0x50],xmm0
   185ded107:	48 c7 45 60 00 00 00 	mov    QWORD PTR [rbp+0x60],0x0
   185ded10e:	00 
   185ded10f:	4c 89 85 d8 00 00 00 	mov    QWORD PTR [rbp+0xd8],r8
   185ded116:	49 83 78 08 00       	cmp    QWORD PTR [r8+0x8],0x0
   185ded11b:	48 89 95 f8 00 00 00 	mov    QWORD PTR [rbp+0xf8],rdx
   185ded122:	0f 84 24 02 00 00    	je     0x185ded34c
   185ded128:	48 8b 85 d8 00 00 00 	mov    rax,QWORD PTR [rbp+0xd8]
   185ded12f:	48 8b 00             	mov    rax,QWORD PTR [rax]
   185ded132:	48 8b 08             	mov    rcx,QWORD PTR [rax]
   185ded135:	48 83 c1 20          	add    rcx,0x20
   185ded139:	e8 62 2d db fa       	call   0x180b9fea0
   185ded13e:	90                   	nop
   185ded13f:	84 c0                	test   al,al
   185ded141:	4c 8b ad f8 00 00 00 	mov    r13,QWORD PTR [rbp+0xf8]
   185ded148:	0f 84 fe 01 00 00    	je     0x185ded34c
   185ded14e:	0f 28 35 5b 8a f5 02 	movaps xmm6,XMMWORD PTR [rip+0x2f58a5b]        # 0x188d45bb0
   185ded155:	0f 29 b5 40 01 00 00 	movaps XMMWORD PTR [rbp+0x140],xmm6
   185ded15c:	0f 57 c0             	xorps  xmm0,xmm0
   185ded15f:	0f 29 45 e0          	movaps XMMWORD PTR [rbp-0x20],xmm0
   185ded163:	49 8b 45 08          	mov    rax,QWORD PTR [r13+0x8]
   185ded167:	48 85 c0             	test   rax,rax
   185ded16a:	74 0a                	je     0x185ded176
   185ded16c:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   185ded170:	49 8b 45 08          	mov    rax,QWORD PTR [r13+0x8]
   185ded174:	eb 02                	jmp    0x185ded178
   185ded176:	31 c0                	xor    eax,eax
   185ded178:	49 8b 4d 00          	mov    rcx,QWORD PTR [r13+0x0]
   185ded17c:	48 89 4d e0          	mov    QWORD PTR [rbp-0x20],rcx
   185ded180:	48 89 45 e8          	mov    QWORD PTR [rbp-0x18],rax
   185ded184:	48 8d 8d 40 01 00 00 	lea    rcx,[rbp+0x140]
   185ded18b:	48 8d 55 e0          	lea    rdx,[rbp-0x20]
   185ded18f:	e8 4c 94 ff ff       	call   0x185de65e0
   185ded194:	90                   	nop
   185ded195:	48 8b 85 40 01 00 00 	mov    rax,QWORD PTR [rbp+0x140]
   185ded19c:	48 85 c0             	test   rax,rax
   185ded19f:	74 5b                	je     0x185ded1fc
   185ded1a1:	0f 57 c0             	xorps  xmm0,xmm0
   185ded1a4:	0f 29 85 60 01 00 00 	movaps XMMWORD PTR [rbp+0x160],xmm0
   185ded1ab:	48 8b 8d 48 01 00 00 	mov    rcx,QWORD PTR [rbp+0x148]
   185ded1b2:	48 85 c9             	test   rcx,rcx
   185ded1b5:	74 14                	je     0x185ded1cb
   185ded1b7:	f0 ff 41 08          	lock inc DWORD PTR [rcx+0x8]
   185ded1bb:	48 8b 85 40 01 00 00 	mov    rax,QWORD PTR [rbp+0x140]
   185ded1c2:	48 8b 8d 48 01 00 00 	mov    rcx,QWORD PTR [rbp+0x148]
   185ded1c9:	eb 02                	jmp    0x185ded1cd
   185ded1cb:	31 c9                	xor    ecx,ecx
   185ded1cd:	48 89 85 60 01 00 00 	mov    QWORD PTR [rbp+0x160],rax
   185ded1d4:	48 89 8d 68 01 00 00 	mov    QWORD PTR [rbp+0x168],rcx
   185ded1db:	48 8b 55 58          	mov    rdx,QWORD PTR [rbp+0x58]
   185ded1df:	48 3b 55 60          	cmp    rdx,QWORD PTR [rbp+0x60]
   185ded1e3:	0f 84 b8 09 00 00    	je     0x185dedba1
   185ded1e9:	48 89 02             	mov    QWORD PTR [rdx],rax
   185ded1ec:	48 8b 85 68 01 00 00 	mov    rax,QWORD PTR [rbp+0x168]
   185ded1f3:	48 89 42 08          	mov    QWORD PTR [rdx+0x8],rax
   185ded1f7:	48 83 45 58 10       	add    QWORD PTR [rbp+0x58],0x10
   185ded1fc:	48 b8 aa aa aa aa aa 	movabs rax,0xaaaaaaaaaaaaaaaa
   185ded203:	aa aa aa 
   185ded206:	48 89 85 70 01 00 00 	mov    QWORD PTR [rbp+0x170],rax
   185ded20d:	0f 29 b5 60 01 00 00 	movaps XMMWORD PTR [rbp+0x160],xmm6
   185ded214:	0f 57 c0             	xorps  xmm0,xmm0
   185ded217:	0f 29 45 b0          	movaps XMMWORD PTR [rbp-0x50],xmm0
   185ded21b:	48 8d 45 b0          	lea    rax,[rbp-0x50]
   185ded21f:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   185ded224:	48 8d 8d 60 01 00 00 	lea    rcx,[rbp+0x160]
   185ded22b:	48 8d 95 80 00 00 00 	lea    rdx,[rbp+0x80]
   185ded232:	4c 8d 4d 50          	lea    r9,[rbp+0x50]
   185ded236:	4c 8b 85 d8 00 00 00 	mov    r8,QWORD PTR [rbp+0xd8]
   185ded23d:	e8 fe b4 b2 fe       	call   0x184918740
   185ded242:	90                   	nop
   185ded243:	4c 8b 85 60 01 00 00 	mov    r8,QWORD PTR [rbp+0x160]
   185ded24a:	4c 8b 8d 68 01 00 00 	mov    r9,QWORD PTR [rbp+0x168]
   185ded251:	48 8b 95 08 01 00 00 	mov    rdx,QWORD PTR [rbp+0x108]
   185ded258:	4d 29 c1             	sub    r9,r8
   185ded25b:	49 c1 f9 04          	sar    r9,0x4
   185ded25f:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   185ded266:	e8 75 d7 2d fb       	call   0x1810ca9e0
   185ded26b:	90                   	nop
   185ded26c:	4c 8b b5 60 01 00 00 	mov    r14,QWORD PTR [rbp+0x160]
   185ded273:	4d 85 f6             	test   r14,r14
   185ded276:	4c 8b ad f8 00 00 00 	mov    r13,QWORD PTR [rbp+0xf8]
   185ded27d:	0f 84 9e 00 00 00    	je     0x185ded321
   185ded283:	48 8b b5 68 01 00 00 	mov    rsi,QWORD PTR [rbp+0x168]
   185ded28a:	49 39 f6             	cmp    r14,rsi
   185ded28d:	75 2a                	jne    0x185ded2b9
   185ded28f:	48 8b 95 70 01 00 00 	mov    rdx,QWORD PTR [rbp+0x170]
   185ded296:	4c 29 f2             	sub    rdx,r14
   185ded299:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185ded2a0:	73 5b                	jae    0x185ded2fd
   185ded2a2:	eb 75                	jmp    0x185ded319
   185ded2a4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
   185ded2ab:	00 00 00 00 00 
   185ded2b0:	49 83 c6 10          	add    r14,0x10
   185ded2b4:	49 39 f6             	cmp    r14,rsi
   185ded2b7:	74 2a                	je     0x185ded2e3
   185ded2b9:	4d 8b 7e 08          	mov    r15,QWORD PTR [r14+0x8]
   185ded2bd:	4d 85 ff             	test   r15,r15
   185ded2c0:	74 ee                	je     0x185ded2b0
   185ded2c2:	f0 41 ff 4f 08       	lock dec DWORD PTR [r15+0x8]
   185ded2c7:	75 e7                	jne    0x185ded2b0
   185ded2c9:	49 8b 07             	mov    rax,QWORD PTR [r15]
   185ded2cc:	4c 89 f9             	mov    rcx,r15
   185ded2cf:	ff 10                	call   QWORD PTR [rax]
   185ded2d1:	f0 41 ff 4f 0c       	lock dec DWORD PTR [r15+0xc]
   185ded2d6:	75 d8                	jne    0x185ded2b0
   185ded2d8:	49 8b 07             	mov    rax,QWORD PTR [r15]
   185ded2db:	4c 89 f9             	mov    rcx,r15
   185ded2de:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185ded2e1:	eb cd                	jmp    0x185ded2b0
   185ded2e3:	4c 8b b5 60 01 00 00 	mov    r14,QWORD PTR [rbp+0x160]
   185ded2ea:	48 8b 95 70 01 00 00 	mov    rdx,QWORD PTR [rbp+0x170]
   185ded2f1:	4c 29 f2             	sub    rdx,r14
   185ded2f4:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185ded2fb:	72 1c                	jb     0x185ded319
   185ded2fd:	49 8b 46 f8          	mov    rax,QWORD PTR [r14-0x8]
   185ded301:	49 83 c6 f8          	add    r14,0xfffffffffffffff8
   185ded305:	49 29 c6             	sub    r14,rax
   185ded308:	49 83 fe 20          	cmp    r14,0x20
   185ded30c:	0f 83 a3 26 00 00    	jae    0x185def9b5
   185ded312:	48 83 c2 27          	add    rdx,0x27
   185ded316:	49 89 c6             	mov    r14,rax
   185ded319:	4c 89 f1             	mov    rcx,r14
   185ded31c:	e8 bf e5 6b 01       	call   0x1874ab8e0
   185ded321:	4c 8b b5 48 01 00 00 	mov    r14,QWORD PTR [rbp+0x148]
   185ded328:	4d 85 f6             	test   r14,r14
   185ded32b:	74 1f                	je     0x185ded34c
   185ded32d:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   185ded332:	75 18                	jne    0x185ded34c
   185ded334:	49 8b 06             	mov    rax,QWORD PTR [r14]
   185ded337:	4c 89 f1             	mov    rcx,r14
   185ded33a:	ff 10                	call   QWORD PTR [rax]
   185ded33c:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   185ded341:	75 09                	jne    0x185ded34c
   185ded343:	49 8b 06             	mov    rax,QWORD PTR [r14]
   185ded346:	4c 89 f1             	mov    rcx,r14
   185ded349:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185ded34c:	0f 28 35 5d 88 f5 02 	movaps xmm6,XMMWORD PTR [rip+0x2f5885d]        # 0x188d45bb0
   185ded353:	0f 29 75 40          	movaps XMMWORD PTR [rbp+0x40],xmm6
   185ded357:	49 8b 4d 00          	mov    rcx,QWORD PTR [r13+0x0]
   185ded35b:	c7 44 24 20 00 00 00 	mov    DWORD PTR [rsp+0x20],0x0
   185ded362:	00 
   185ded363:	4c 8d 05 56 91 38 05 	lea    r8,[rip+0x5389156]        # 0x18b1764c0
   185ded36a:	4c 8d 0d 7f 62 56 05 	lea    r9,[rip+0x556627f]        # 0x18b3535f0
   185ded371:	31 d2                	xor    edx,edx
   185ded373:	e8 74 66 70 01       	call   0x1874f39ec
   185ded378:	90                   	nop
   185ded379:	49 89 c6             	mov    r14,rax
   185ded37c:	48 85 c0             	test   rax,rax
   185ded37f:	74 13                	je     0x185ded394
   185ded381:	49 8b 45 08          	mov    rax,QWORD PTR [r13+0x8]
   185ded385:	48 85 c0             	test   rax,rax
   185ded388:	74 60                	je     0x185ded3ea
   185ded38a:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   185ded38e:	49 8b 45 08          	mov    rax,QWORD PTR [r13+0x8]
   185ded392:	eb 58                	jmp    0x185ded3ec
   185ded394:	0f 57 c0             	xorps  xmm0,xmm0
   185ded397:	0f 29 45 40          	movaps XMMWORD PTR [rbp+0x40],xmm0
   185ded39b:	0f 29 b5 b0 00 00 00 	movaps XMMWORD PTR [rbp+0xb0],xmm6
   185ded3a2:	49 8b 4d 00          	mov    rcx,QWORD PTR [r13+0x0]
   185ded3a6:	c7 44 24 20 00 00 00 	mov    DWORD PTR [rsp+0x20],0x0
   185ded3ad:	00 
   185ded3ae:	4c 8d 05 0b 91 38 05 	lea    r8,[rip+0x538910b]        # 0x18b1764c0
   185ded3b5:	4c 8d 0d 44 94 56 05 	lea    r9,[rip+0x5569444]        # 0x18b356800
   185ded3bc:	31 d2                	xor    edx,edx
   185ded3be:	e8 29 66 70 01       	call   0x1874f39ec
   185ded3c3:	90                   	nop
   185ded3c4:	49 89 c6             	mov    r14,rax
   185ded3c7:	48 85 c0             	test   rax,rax
   185ded3ca:	0f 84 65 03 00 00    	je     0x185ded735
   185ded3d0:	49 8b 45 08          	mov    rax,QWORD PTR [r13+0x8]
   185ded3d4:	48 85 c0             	test   rax,rax
   185ded3d7:	0f 84 76 04 00 00    	je     0x185ded853
   185ded3dd:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   185ded3e1:	49 8b 45 08          	mov    rax,QWORD PTR [r13+0x8]
   185ded3e5:	e9 6b 04 00 00       	jmp    0x185ded855
   185ded3ea:	31 c0                	xor    eax,eax
   185ded3ec:	4c 89 75 40          	mov    QWORD PTR [rbp+0x40],r14
   185ded3f0:	48 89 45 48          	mov    QWORD PTR [rbp+0x48],rax
   185ded3f4:	0f 29 b5 20 01 00 00 	movaps XMMWORD PTR [rbp+0x120],xmm6
   185ded3fb:	48 8d 95 20 01 00 00 	lea    rdx,[rbp+0x120]
   185ded402:	4c 89 f1             	mov    rcx,r14
   185ded405:	e8 a6 51 37 fc       	call   0x1821625b0
   185ded40a:	90                   	nop
   185ded40b:	48 83 bd 20 01 00 00 	cmp    QWORD PTR [rbp+0x120],0x0
   185ded412:	00 
   185ded413:	74 4c                	je     0x185ded461
   185ded415:	48 8b 95 88 00 00 00 	mov    rdx,QWORD PTR [rbp+0x88]
   185ded41c:	48 3b 95 90 00 00 00 	cmp    rdx,QWORD PTR [rbp+0x90]
   185ded423:	0f 84 01 02 00 00    	je     0x185ded62a
   185ded429:	0f 57 c0             	xorps  xmm0,xmm0
   185ded42c:	0f 11 02             	movups XMMWORD PTR [rdx],xmm0
   185ded42f:	48 8b 85 28 01 00 00 	mov    rax,QWORD PTR [rbp+0x128]
   185ded436:	48 85 c0             	test   rax,rax
   185ded439:	74 04                	je     0x185ded43f
   185ded43b:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   185ded43f:	48 8b 85 20 01 00 00 	mov    rax,QWORD PTR [rbp+0x120]
   185ded446:	48 89 02             	mov    QWORD PTR [rdx],rax
   185ded449:	48 8b 85 28 01 00 00 	mov    rax,QWORD PTR [rbp+0x128]
   185ded450:	48 89 42 08          	mov    QWORD PTR [rdx+0x8],rax
   185ded454:	48 83 85 88 00 00 00 	add    QWORD PTR [rbp+0x88],0x10
   185ded45b:	10 
   185ded45c:	e9 dd 01 00 00       	jmp    0x185ded63e
   185ded461:	4c 89 f1             	mov    rcx,r14
   185ded464:	e8 c7 24 58 fa       	call   0x18036f930
   185ded469:	90                   	nop
   185ded46a:	49 89 c7             	mov    r15,rax
   185ded46d:	4c 8b 30             	mov    r14,QWORD PTR [rax]
   185ded470:	48 8b 70 08          	mov    rsi,QWORD PTR [rax+0x8]
   185ded474:	48 89 f1             	mov    rcx,rsi
   185ded477:	4c 29 f1             	sub    rcx,r14
   185ded47a:	48 c1 f9 06          	sar    rcx,0x6
   185ded47e:	48 b8 f1 f0 f0 f0 f0 	movabs rax,0xf0f0f0f0f0f0f0f1
   185ded485:	f0 f0 f0 
   185ded488:	48 0f af c1          	imul   rax,rcx
   185ded48c:	48 89 85 60 01 00 00 	mov    QWORD PTR [rbp+0x160],rax
   185ded493:	48 8b 8d 90 00 00 00 	mov    rcx,QWORD PTR [rbp+0x90]
   185ded49a:	48 2b 8d 80 00 00 00 	sub    rcx,QWORD PTR [rbp+0x80]
   185ded4a1:	48 c1 f9 04          	sar    rcx,0x4
   185ded4a5:	48 39 c8             	cmp    rax,rcx
   185ded4a8:	76 25                	jbe    0x185ded4cf
   185ded4aa:	48 c1 e8 3c          	shr    rax,0x3c
   185ded4ae:	0f 85 13 25 00 00    	jne    0x185def9c7
   185ded4b4:	48 8d 8d 80 00 00 00 	lea    rcx,[rbp+0x80]
   185ded4bb:	48 8d 95 60 01 00 00 	lea    rdx,[rbp+0x160]
   185ded4c2:	e8 b9 f6 83 fa       	call   0x18062cb80
   185ded4c7:	90                   	nop
   185ded4c8:	4d 8b 37             	mov    r14,QWORD PTR [r15]
   185ded4cb:	49 8b 77 08          	mov    rsi,QWORD PTR [r15+0x8]
   185ded4cf:	48 bf 01 00 00 00 01 	movabs rdi,0x100000001
   185ded4d6:	00 00 00 
   185ded4d9:	48 8d 1d 88 b1 0d 03 	lea    rbx,[rip+0x30db188]        # 0x188ec8668
   185ded4e0:	4c 8d bd 80 00 00 00 	lea    r15,[rbp+0x80]
   185ded4e7:	4c 8d a5 60 01 00 00 	lea    r12,[rbp+0x160]
   185ded4ee:	0f 57 ff             	xorps  xmm7,xmm7
   185ded4f1:	49 39 f6             	cmp    r14,rsi
   185ded4f4:	75 66                	jne    0x185ded55c
   185ded4f6:	4c 8b 75 40          	mov    r14,QWORD PTR [rbp+0x40]
   185ded4fa:	4c 89 f1             	mov    rcx,r14
   185ded4fd:	e8 ce 86 71 fa       	call   0x180505bd0
   185ded502:	90                   	nop
   185ded503:	83 f8 1c             	cmp    eax,0x1c
   185ded506:	0f 85 82 02 00 00    	jne    0x185ded78e
   185ded50c:	48 b8 aa aa aa aa aa 	movabs rax,0xaaaaaaaaaaaaaaaa
   185ded513:	aa aa aa 
   185ded516:	48 89 85 70 01 00 00 	mov    QWORD PTR [rbp+0x170],rax
   185ded51d:	0f 29 b5 60 01 00 00 	movaps XMMWORD PTR [rbp+0x160],xmm6
   185ded524:	0f 57 c0             	xorps  xmm0,xmm0
   185ded527:	0f 29 45 00          	movaps XMMWORD PTR [rbp+0x0],xmm0
   185ded52b:	48 8b 8d 20 02 00 00 	mov    rcx,QWORD PTR [rbp+0x220]
   185ded532:	48 8b 41 08          	mov    rax,QWORD PTR [rcx+0x8]
   185ded536:	48 85 c0             	test   rax,rax
   185ded539:	0f 84 c4 09 00 00    	je     0x185dedf03
   185ded53f:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   185ded543:	48 8b 41 08          	mov    rax,QWORD PTR [rcx+0x8]
   185ded547:	e9 b9 09 00 00       	jmp    0x185dedf05
   185ded54c:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
   185ded550:	49 81 c6 40 04 00 00 	add    r14,0x440
   185ded557:	49 39 f6             	cmp    r14,rsi
   185ded55a:	74 9a                	je     0x185ded4f6
   185ded55c:	b9 50 04 00 00       	mov    ecx,0x450
   185ded561:	e8 36 e3 6b 01       	call   0x1874ab89c
   185ded566:	90                   	nop
   185ded567:	48 89 78 08          	mov    QWORD PTR [rax+0x8],rdi
   185ded56b:	48 89 18             	mov    QWORD PTR [rax],rbx
   185ded56e:	48 89 45 38          	mov    QWORD PTR [rbp+0x38],rax
   185ded572:	49 89 c5             	mov    r13,rax
   185ded575:	49 83 c5 10          	add    r13,0x10
   185ded579:	4c 89 e9             	mov    rcx,r13
   185ded57c:	4c 89 f2             	mov    rdx,r14
   185ded57f:	e8 cc 85 3b fa       	call   0x1801a5b50
   185ded584:	90                   	nop
   185ded585:	4c 89 ad 60 01 00 00 	mov    QWORD PTR [rbp+0x160],r13
   185ded58c:	48 8b 45 38          	mov    rax,QWORD PTR [rbp+0x38]
   185ded590:	48 89 85 68 01 00 00 	mov    QWORD PTR [rbp+0x168],rax
   185ded597:	48 8b 95 88 00 00 00 	mov    rdx,QWORD PTR [rbp+0x88]
   185ded59e:	48 3b 95 90 00 00 00 	cmp    rdx,QWORD PTR [rbp+0x90]
   185ded5a5:	74 39                	je     0x185ded5e0
   185ded5a7:	0f 11 3a             	movups XMMWORD PTR [rdx],xmm7
   185ded5aa:	48 8b 85 60 01 00 00 	mov    rax,QWORD PTR [rbp+0x160]
   185ded5b1:	48 89 02             	mov    QWORD PTR [rdx],rax
   185ded5b4:	48 8b 85 68 01 00 00 	mov    rax,QWORD PTR [rbp+0x168]
   185ded5bb:	48 89 42 08          	mov    QWORD PTR [rdx+0x8],rax
   185ded5bf:	48 83 85 88 00 00 00 	add    QWORD PTR [rbp+0x88],0x10
   185ded5c6:	10 
   185ded5c7:	49 81 c6 40 04 00 00 	add    r14,0x440
   185ded5ce:	49 39 f6             	cmp    r14,rsi
   185ded5d1:	75 89                	jne    0x185ded55c
   185ded5d3:	e9 1e ff ff ff       	jmp    0x185ded4f6
   185ded5d8:	0f 1f 84 00 00 00 00 	nop    DWORD PTR [rax+rax*1+0x0]
   185ded5df:	00 
   185ded5e0:	4c 89 f9             	mov    rcx,r15
   185ded5e3:	4d 89 e0             	mov    r8,r12
   185ded5e6:	e8 75 49 2c fb       	call   0x1810b1f60
   185ded5eb:	90                   	nop
   185ded5ec:	4c 8b ad 68 01 00 00 	mov    r13,QWORD PTR [rbp+0x168]
   185ded5f3:	4d 85 ed             	test   r13,r13
   185ded5f6:	0f 84 54 ff ff ff    	je     0x185ded550
   185ded5fc:	f0 41 ff 4d 08       	lock dec DWORD PTR [r13+0x8]
   185ded601:	0f 85 49 ff ff ff    	jne    0x185ded550
   185ded607:	49 8b 45 00          	mov    rax,QWORD PTR [r13+0x0]
   185ded60b:	4c 89 e9             	mov    rcx,r13
   185ded60e:	ff 10                	call   QWORD PTR [rax]
   185ded610:	f0 41 ff 4d 0c       	lock dec DWORD PTR [r13+0xc]
   185ded615:	0f 85 35 ff ff ff    	jne    0x185ded550
   185ded61b:	49 8b 45 00          	mov    rax,QWORD PTR [r13+0x0]
   185ded61f:	4c 89 e9             	mov    rcx,r13
   185ded622:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185ded625:	e9 26 ff ff ff       	jmp    0x185ded550
   185ded62a:	48 8d 8d 80 00 00 00 	lea    rcx,[rbp+0x80]
   185ded631:	4c 8d 85 20 01 00 00 	lea    r8,[rbp+0x120]
   185ded638:	e8 c3 42 3e fa       	call   0x1801d1900
   185ded63d:	90                   	nop
   185ded63e:	48 b8 aa aa aa aa aa 	movabs rax,0xaaaaaaaaaaaaaaaa
   185ded645:	aa aa aa 
   185ded648:	48 89 85 70 01 00 00 	mov    QWORD PTR [rbp+0x170],rax
   185ded64f:	0f 29 b5 60 01 00 00 	movaps XMMWORD PTR [rbp+0x160],xmm6
   185ded656:	0f 57 c0             	xorps  xmm0,xmm0
   185ded659:	0f 29 45 f0          	movaps XMMWORD PTR [rbp-0x10],xmm0
   185ded65d:	48 8b 8d 20 02 00 00 	mov    rcx,QWORD PTR [rbp+0x220]
   185ded664:	48 8b 41 08          	mov    rax,QWORD PTR [rcx+0x8]
   185ded668:	48 85 c0             	test   rax,rax
   185ded66b:	74 0a                	je     0x185ded677
   185ded66d:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   185ded671:	48 8b 41 08          	mov    rax,QWORD PTR [rcx+0x8]
   185ded675:	eb 02                	jmp    0x185ded679
   185ded677:	31 c0                	xor    eax,eax
   185ded679:	48 8b 09             	mov    rcx,QWORD PTR [rcx]
   185ded67c:	48 89 4d f0          	mov    QWORD PTR [rbp-0x10],rcx
   185ded680:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
   185ded684:	48 8d 45 f0          	lea    rax,[rbp-0x10]
   185ded688:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   185ded68d:	48 8d 8d 60 01 00 00 	lea    rcx,[rbp+0x160]
   185ded694:	48 8d 95 80 00 00 00 	lea    rdx,[rbp+0x80]
   185ded69b:	4c 8b 85 d8 00 00 00 	mov    r8,QWORD PTR [rbp+0xd8]
   185ded6a2:	4c 8b 8d d0 00 00 00 	mov    r9,QWORD PTR [rbp+0xd0]
   185ded6a9:	e8 92 b0 b2 fe       	call   0x184918740
   185ded6ae:	90                   	nop
   185ded6af:	4c 8b 85 60 01 00 00 	mov    r8,QWORD PTR [rbp+0x160]
   185ded6b6:	4c 8b 8d 68 01 00 00 	mov    r9,QWORD PTR [rbp+0x168]
   185ded6bd:	48 8b 95 08 01 00 00 	mov    rdx,QWORD PTR [rbp+0x108]
   185ded6c4:	4d 29 c1             	sub    r9,r8
   185ded6c7:	49 c1 f9 04          	sar    r9,0x4
   185ded6cb:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   185ded6d2:	e8 09 d3 2d fb       	call   0x1810ca9e0
   185ded6d7:	90                   	nop
   185ded6d8:	48 8b bd 60 01 00 00 	mov    rdi,QWORD PTR [rbp+0x160]
   185ded6df:	48 85 ff             	test   rdi,rdi
   185ded6e2:	0f 84 28 09 00 00    	je     0x185dee010
   185ded6e8:	48 8b b5 68 01 00 00 	mov    rsi,QWORD PTR [rbp+0x168]
   185ded6ef:	48 39 f7             	cmp    rdi,rsi
   185ded6f2:	75 19                	jne    0x185ded70d
   185ded6f4:	e9 86 08 00 00       	jmp    0x185dedf7f
   185ded6f9:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
   185ded700:	48 83 c7 10          	add    rdi,0x10
   185ded704:	48 39 f7             	cmp    rdi,rsi
   185ded707:	0f 84 c4 08 00 00    	je     0x185dedfd1
   185ded70d:	48 8b 5f 08          	mov    rbx,QWORD PTR [rdi+0x8]
   185ded711:	48 85 db             	test   rbx,rbx
   185ded714:	74 ea                	je     0x185ded700
   185ded716:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   185ded71a:	75 e4                	jne    0x185ded700
   185ded71c:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185ded71f:	48 89 d9             	mov    rcx,rbx
   185ded722:	ff 10                	call   QWORD PTR [rax]
   185ded724:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   185ded728:	75 d6                	jne    0x185ded700
   185ded72a:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185ded72d:	48 89 d9             	mov    rcx,rbx
   185ded730:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185ded733:	eb cb                	jmp    0x185ded700
   185ded735:	0f 57 c0             	xorps  xmm0,xmm0
   185ded738:	0f 29 85 b0 00 00 00 	movaps XMMWORD PTR [rbp+0xb0],xmm0
   185ded73f:	0f 29 b5 c0 00 00 00 	movaps XMMWORD PTR [rbp+0xc0],xmm6
   185ded746:	49 8b 4d 00          	mov    rcx,QWORD PTR [r13+0x0]
   185ded74a:	c7 44 24 20 00 00 00 	mov    DWORD PTR [rsp+0x20],0x0
   185ded751:	00 
   185ded752:	4c 8d 05 67 8d 38 05 	lea    r8,[rip+0x5388d67]        # 0x18b1764c0
   185ded759:	4c 8d 0d 80 82 56 05 	lea    r9,[rip+0x5568280]        # 0x18b3559e0
   185ded760:	31 d2                	xor    edx,edx
   185ded762:	e8 85 62 70 01       	call   0x1874f39ec
   185ded767:	90                   	nop
   185ded768:	49 89 c6             	mov    r14,rax
   185ded76b:	48 85 c0             	test   rax,rax
   185ded76e:	0f 84 80 07 00 00    	je     0x185dedef4
   185ded774:	49 8b 45 08          	mov    rax,QWORD PTR [r13+0x8]
   185ded778:	48 85 c0             	test   rax,rax
   185ded77b:	0f 84 8e 0b 00 00    	je     0x185dee30f
   185ded781:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   185ded785:	49 8b 45 08          	mov    rax,QWORD PTR [r13+0x8]
   185ded789:	e9 83 0b 00 00       	jmp    0x185dee311
   185ded78e:	4c 89 f1             	mov    rcx,r14
   185ded791:	e8 3a 84 71 fa       	call   0x180505bd0
   185ded796:	90                   	nop
   185ded797:	83 f8 1b             	cmp    eax,0x1b
   185ded79a:	0f 85 70 08 00 00    	jne    0x185dee010
   185ded7a0:	0f 29 b5 b0 00 00 00 	movaps XMMWORD PTR [rbp+0xb0],xmm6
   185ded7a7:	48 8d 8d b0 00 00 00 	lea    rcx,[rbp+0xb0]
   185ded7ae:	e8 dd 31 44 fc       	call   0x182230990
   185ded7b3:	90                   	nop
   185ded7b4:	48 8b 8d b0 00 00 00 	mov    rcx,QWORD PTR [rbp+0xb0]
   185ded7bb:	48 b8 31 00 00 00 13 	movabs rax,0x1300000031
   185ded7c2:	00 00 00 
   185ded7c5:	48 89 81 18 01 00 00 	mov    QWORD PTR [rcx+0x118],rax
   185ded7cc:	48 8d 95 80 00 00 00 	lea    rdx,[rbp+0x80]
   185ded7d3:	e8 a8 33 44 fc       	call   0x182230b80
   185ded7d8:	90                   	nop
   185ded7d9:	0f 57 c0             	xorps  xmm0,xmm0
   185ded7dc:	0f 29 85 60 01 00 00 	movaps XMMWORD PTR [rbp+0x160],xmm0
   185ded7e3:	48 c7 85 70 01 00 00 	mov    QWORD PTR [rbp+0x170],0x0
   185ded7ea:	00 00 00 00 
   185ded7ee:	0f 29 85 40 01 00 00 	movaps XMMWORD PTR [rbp+0x140],xmm0
   185ded7f5:	48 8b 85 b8 00 00 00 	mov    rax,QWORD PTR [rbp+0xb8]
   185ded7fc:	48 85 c0             	test   rax,rax
   185ded7ff:	0f 84 82 0e 00 00    	je     0x185dee687
   185ded805:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   185ded809:	48 8b 95 68 01 00 00 	mov    rdx,QWORD PTR [rbp+0x168]
   185ded810:	0f 28 85 b0 00 00 00 	movaps xmm0,XMMWORD PTR [rbp+0xb0]
   185ded817:	0f 29 85 40 01 00 00 	movaps XMMWORD PTR [rbp+0x140],xmm0
   185ded81e:	48 3b 95 70 01 00 00 	cmp    rdx,QWORD PTR [rbp+0x170]
   185ded825:	0f 84 77 0e 00 00    	je     0x185dee6a2
   185ded82b:	0f 57 c0             	xorps  xmm0,xmm0
   185ded82e:	0f 11 02             	movups XMMWORD PTR [rdx],xmm0
   185ded831:	48 8b 85 40 01 00 00 	mov    rax,QWORD PTR [rbp+0x140]
   185ded838:	48 89 02             	mov    QWORD PTR [rdx],rax
   185ded83b:	48 8b 85 48 01 00 00 	mov    rax,QWORD PTR [rbp+0x148]
   185ded842:	48 89 42 08          	mov    QWORD PTR [rdx+0x8],rax
   185ded846:	48 83 85 68 01 00 00 	add    QWORD PTR [rbp+0x168],0x10
   185ded84d:	10 
   185ded84e:	e9 8e 0e 00 00       	jmp    0x185dee6e1
   185ded853:	31 c0                	xor    eax,eax
   185ded855:	4c 89 b5 b0 00 00 00 	mov    QWORD PTR [rbp+0xb0],r14
   185ded85c:	48 89 85 b8 00 00 00 	mov    QWORD PTR [rbp+0xb8],rax
   185ded863:	0f 29 b5 c0 00 00 00 	movaps XMMWORD PTR [rbp+0xc0],xmm6
   185ded86a:	48 8d 8d c0 00 00 00 	lea    rcx,[rbp+0xc0]
   185ded871:	e8 fa 73 90 fa       	call   0x1806f4c70
   185ded876:	90                   	nop
   185ded877:	48 8b 85 c0 00 00 00 	mov    rax,QWORD PTR [rbp+0xc0]
   185ded87e:	c7 80 18 01 00 00 01 	mov    DWORD PTR [rax+0x118],0x1
   185ded885:	00 00 00 
   185ded888:	49 8b 06             	mov    rax,QWORD PTR [r14]
   185ded88b:	4c 8d bd 60 01 00 00 	lea    r15,[rbp+0x160]
   185ded892:	4c 89 f1             	mov    rcx,r14
   185ded895:	4c 89 fa             	mov    rdx,r15
   185ded898:	ff 50 18             	call   QWORD PTR [rax+0x18]
   185ded89b:	90                   	nop
   185ded89c:	48 8b 85 c0 00 00 00 	mov    rax,QWORD PTR [rbp+0xc0]
   185ded8a3:	48 8d b0 58 07 00 00 	lea    rsi,[rax+0x758]
   185ded8aa:	4c 39 fe             	cmp    rsi,r15
   185ded8ad:	74 58                	je     0x185ded907
   185ded8af:	48 8b 80 70 07 00 00 	mov    rax,QWORD PTR [rax+0x770]
   185ded8b6:	48 83 f8 10          	cmp    rax,0x10
   185ded8ba:	72 34                	jb     0x185ded8f0
   185ded8bc:	48 8b 0e             	mov    rcx,QWORD PTR [rsi]
   185ded8bf:	48 8d 50 01          	lea    rdx,[rax+0x1]
   185ded8c3:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185ded8ca:	72 1f                	jb     0x185ded8eb
   185ded8cc:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   185ded8d0:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   185ded8d4:	4c 29 c1             	sub    rcx,r8
   185ded8d7:	48 83 f9 20          	cmp    rcx,0x20
   185ded8db:	0f 83 d4 20 00 00    	jae    0x185def9b5
   185ded8e1:	48 83 c0 28          	add    rax,0x28
   185ded8e5:	48 89 c2             	mov    rdx,rax
   185ded8e8:	4c 89 c1             	mov    rcx,r8
   185ded8eb:	e8 f0 df 6b 01       	call   0x1874ab8e0
   185ded8f0:	0f 10 85 60 01 00 00 	movups xmm0,XMMWORD PTR [rbp+0x160]
   185ded8f7:	0f 10 8d 70 01 00 00 	movups xmm1,XMMWORD PTR [rbp+0x170]
   185ded8fe:	0f 11 4e 10          	movups XMMWORD PTR [rsi+0x10],xmm1
   185ded902:	0f 11 06             	movups XMMWORD PTR [rsi],xmm0
   185ded905:	eb 45                	jmp    0x185ded94c
   185ded907:	48 8b 85 78 01 00 00 	mov    rax,QWORD PTR [rbp+0x178]
   185ded90e:	48 83 f8 10          	cmp    rax,0x10
   185ded912:	72 38                	jb     0x185ded94c
   185ded914:	48 8b 8d 60 01 00 00 	mov    rcx,QWORD PTR [rbp+0x160]
   185ded91b:	48 8d 50 01          	lea    rdx,[rax+0x1]
   185ded91f:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185ded926:	72 1f                	jb     0x185ded947
   185ded928:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   185ded92c:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   185ded930:	4c 29 c1             	sub    rcx,r8
   185ded933:	48 83 f9 20          	cmp    rcx,0x20
   185ded937:	0f 83 78 20 00 00    	jae    0x185def9b5
   185ded93d:	48 83 c0 28          	add    rax,0x28
   185ded941:	48 89 c2             	mov    rdx,rax
   185ded944:	4c 89 c1             	mov    rcx,r8
   185ded947:	e8 94 df 6b 01       	call   0x1874ab8e0
   185ded94c:	0f 57 c0             	xorps  xmm0,xmm0
   185ded94f:	0f 29 85 60 01 00 00 	movaps XMMWORD PTR [rbp+0x160],xmm0
   185ded956:	48 c7 85 70 01 00 00 	mov    QWORD PTR [rbp+0x170],0x0
   185ded95d:	00 00 00 00 
   185ded961:	0f 29 85 40 01 00 00 	movaps XMMWORD PTR [rbp+0x140],xmm0
   185ded968:	48 8b 85 c8 00 00 00 	mov    rax,QWORD PTR [rbp+0xc8]
   185ded96f:	48 85 c0             	test   rax,rax
   185ded972:	74 47                	je     0x185ded9bb
   185ded974:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   185ded978:	48 8b 95 68 01 00 00 	mov    rdx,QWORD PTR [rbp+0x168]
   185ded97f:	0f 28 85 c0 00 00 00 	movaps xmm0,XMMWORD PTR [rbp+0xc0]
   185ded986:	0f 29 85 40 01 00 00 	movaps XMMWORD PTR [rbp+0x140],xmm0
   185ded98d:	48 3b 95 70 01 00 00 	cmp    rdx,QWORD PTR [rbp+0x170]
   185ded994:	74 40                	je     0x185ded9d6
   185ded996:	0f 57 c0             	xorps  xmm0,xmm0
   185ded999:	0f 11 02             	movups XMMWORD PTR [rdx],xmm0
   185ded99c:	48 8b 85 40 01 00 00 	mov    rax,QWORD PTR [rbp+0x140]
   185ded9a3:	48 89 02             	mov    QWORD PTR [rdx],rax
   185ded9a6:	48 8b 85 48 01 00 00 	mov    rax,QWORD PTR [rbp+0x148]
   185ded9ad:	48 89 42 08          	mov    QWORD PTR [rdx+0x8],rax
   185ded9b1:	48 83 85 68 01 00 00 	add    QWORD PTR [rbp+0x168],0x10
   185ded9b8:	10 
   185ded9b9:	eb 5a                	jmp    0x185deda15
   185ded9bb:	48 8b 85 c0 00 00 00 	mov    rax,QWORD PTR [rbp+0xc0]
   185ded9c2:	48 89 85 40 01 00 00 	mov    QWORD PTR [rbp+0x140],rax
   185ded9c9:	48 c7 85 48 01 00 00 	mov    QWORD PTR [rbp+0x148],0x0
   185ded9d0:	00 00 00 00 
   185ded9d4:	31 d2                	xor    edx,edx
   185ded9d6:	48 8d 8d 60 01 00 00 	lea    rcx,[rbp+0x160]
   185ded9dd:	4c 8d 85 40 01 00 00 	lea    r8,[rbp+0x140]
   185ded9e4:	e8 77 45 2c fb       	call   0x1810b1f60
   185ded9e9:	90                   	nop
   185ded9ea:	4c 8b b5 48 01 00 00 	mov    r14,QWORD PTR [rbp+0x148]
   185ded9f1:	4d 85 f6             	test   r14,r14
   185ded9f4:	74 1f                	je     0x185deda15
   185ded9f6:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   185ded9fb:	75 18                	jne    0x185deda15
   185ded9fd:	49 8b 06             	mov    rax,QWORD PTR [r14]
   185deda00:	4c 89 f1             	mov    rcx,r14
   185deda03:	ff 10                	call   QWORD PTR [rax]
   185deda05:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   185deda0a:	75 09                	jne    0x185deda15
   185deda0c:	49 8b 06             	mov    rax,QWORD PTR [r14]
   185deda0f:	4c 89 f1             	mov    rcx,r14
   185deda12:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185deda15:	48 b8 aa aa aa aa aa 	movabs rax,0xaaaaaaaaaaaaaaaa
   185deda1c:	aa aa aa 
   185deda1f:	48 89 85 50 01 00 00 	mov    QWORD PTR [rbp+0x150],rax
   185deda26:	0f 29 b5 40 01 00 00 	movaps XMMWORD PTR [rbp+0x140],xmm6
   185deda2d:	48 8d 8d 40 01 00 00 	lea    rcx,[rbp+0x140]
   185deda34:	48 8d 95 60 01 00 00 	lea    rdx,[rbp+0x160]
   185deda3b:	4c 8b 85 d8 00 00 00 	mov    r8,QWORD PTR [rbp+0xd8]
   185deda42:	4c 8b 8d d0 00 00 00 	mov    r9,QWORD PTR [rbp+0xd0]
   185deda49:	e8 92 91 b2 fe       	call   0x184916be0
   185deda4e:	90                   	nop
   185deda4f:	4c 8b 85 40 01 00 00 	mov    r8,QWORD PTR [rbp+0x140]
   185deda56:	4c 8b 8d 48 01 00 00 	mov    r9,QWORD PTR [rbp+0x148]
   185deda5d:	48 8b 95 08 01 00 00 	mov    rdx,QWORD PTR [rbp+0x108]
   185deda64:	4d 29 c1             	sub    r9,r8
   185deda67:	49 c1 f9 04          	sar    r9,0x4
   185deda6b:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   185deda72:	e8 69 cf 2d fb       	call   0x1810ca9e0
   185deda77:	90                   	nop
   185deda78:	e8 93 82 25 fa       	call   0x180045d10
   185deda7d:	90                   	nop
   185deda7e:	4c 8b 00             	mov    r8,QWORD PTR [rax]
   185deda81:	48 8d 55 70          	lea    rdx,[rbp+0x70]
   185deda85:	48 89 c1             	mov    rcx,rax
   185deda88:	41 ff 50 60          	call   QWORD PTR [r8+0x60]
   185deda8c:	90                   	nop
   185deda8d:	48 8b 4d 70          	mov    rcx,QWORD PTR [rbp+0x70]
   185deda91:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   185deda94:	48 8d 95 a0 00 00 00 	lea    rdx,[rbp+0xa0]
   185deda9b:	ff 50 30             	call   QWORD PTR [rax+0x30]
   185deda9e:	90                   	nop
   185deda9f:	48 8b 8d a0 00 00 00 	mov    rcx,QWORD PTR [rbp+0xa0]
   185dedaa6:	48 8d 05 5b 2d 06 03 	lea    rax,[rip+0x3062d5b]        # 0x188e50808
   185dedaad:	48 89 45 28          	mov    QWORD PTR [rbp+0x28],rax
   185dedab1:	0f 29 b5 20 01 00 00 	movaps XMMWORD PTR [rbp+0x120],xmm6
   185dedab8:	48 8d 95 20 01 00 00 	lea    rdx,[rbp+0x120]
   185dedabf:	4c 8d 45 28          	lea    r8,[rbp+0x28]
   185dedac3:	e8 b8 0f 3b fa       	call   0x18019ea80
   185dedac8:	90                   	nop
   185dedac9:	48 8b 85 20 01 00 00 	mov    rax,QWORD PTR [rbp+0x120]
   185dedad0:	48 8b 8d 28 01 00 00 	mov    rcx,QWORD PTR [rbp+0x128]
   185dedad7:	48 85 c9             	test   rcx,rcx
   185dedada:	74 3d                	je     0x185dedb19
   185dedadc:	f0 ff 41 08          	lock inc DWORD PTR [rcx+0x8]
   185dedae0:	48 8b bd 28 01 00 00 	mov    rdi,QWORD PTR [rbp+0x128]
   185dedae7:	48 89 85 e0 00 00 00 	mov    QWORD PTR [rbp+0xe0],rax
   185dedaee:	48 89 bd e8 00 00 00 	mov    QWORD PTR [rbp+0xe8],rdi
   185dedaf5:	48 85 ff             	test   rdi,rdi
   185dedaf8:	74 31                	je     0x185dedb2b
   185dedafa:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   185dedafe:	75 2b                	jne    0x185dedb2b
   185dedb00:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185dedb03:	48 89 f9             	mov    rcx,rdi
   185dedb06:	ff 10                	call   QWORD PTR [rax]
   185dedb08:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   185dedb0c:	75 1d                	jne    0x185dedb2b
   185dedb0e:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185dedb11:	48 89 f9             	mov    rcx,rdi
   185dedb14:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185dedb17:	eb 12                	jmp    0x185dedb2b
   185dedb19:	48 89 85 e0 00 00 00 	mov    QWORD PTR [rbp+0xe0],rax
   185dedb20:	48 c7 85 e8 00 00 00 	mov    QWORD PTR [rbp+0xe8],0x0
   185dedb27:	00 00 00 00 
   185dedb2b:	48 8b 9d 08 01 00 00 	mov    rbx,QWORD PTR [rbp+0x108]
   185dedb32:	48 8b 8d 00 01 00 00 	mov    rcx,QWORD PTR [rbp+0x100]
   185dedb39:	48 89 d8             	mov    rax,rbx
   185dedb3c:	48 29 c8             	sub    rax,rcx
   185dedb3f:	48 8b bd e0 00 00 00 	mov    rdi,QWORD PTR [rbp+0xe0]
   185dedb46:	0f 57 c0             	xorps  xmm0,xmm0
   185dedb49:	0f 29 85 20 01 00 00 	movaps XMMWORD PTR [rbp+0x120],xmm0
   185dedb50:	48 c7 85 30 01 00 00 	mov    QWORD PTR [rbp+0x130],0x0
   185dedb57:	00 00 00 00 
   185dedb5b:	48 29 cb             	sub    rbx,rcx
   185dedb5e:	0f 84 01 01 00 00    	je     0x185dedc65
   185dedb64:	48 c1 f8 04          	sar    rax,0x4
   185dedb68:	48 89 c1             	mov    rcx,rax
   185dedb6b:	48 c1 e9 3c          	shr    rcx,0x3c
   185dedb6f:	0f 85 4c 1e 00 00    	jne    0x185def9c1
   185dedb75:	48 3d 00 01 00 00    	cmp    rax,0x100
   185dedb7b:	72 71                	jb     0x185dedbee
   185dedb7d:	48 8d 4b 27          	lea    rcx,[rbx+0x27]
   185dedb81:	e8 16 dd 6b 01       	call   0x1874ab89c
   185dedb86:	90                   	nop
   185dedb87:	48 85 c0             	test   rax,rax
   185dedb8a:	0f 84 25 1e 00 00    	je     0x185def9b5
   185dedb90:	48 89 c1             	mov    rcx,rax
   185dedb93:	48 83 c0 27          	add    rax,0x27
   185dedb97:	48 83 e0 e0          	and    rax,0xffffffffffffffe0
   185dedb9b:	48 89 48 f8          	mov    QWORD PTR [rax-0x8],rcx
   185dedb9f:	eb 56                	jmp    0x185dedbf7
   185dedba1:	48 8d 4d 50          	lea    rcx,[rbp+0x50]
   185dedba5:	4c 8d 85 60 01 00 00 	lea    r8,[rbp+0x160]
   185dedbac:	e8 af 43 2c fb       	call   0x1810b1f60
   185dedbb1:	90                   	nop
   185dedbb2:	4c 8b b5 68 01 00 00 	mov    r14,QWORD PTR [rbp+0x168]
   185dedbb9:	4d 85 f6             	test   r14,r14
   185dedbbc:	0f 84 3a f6 ff ff    	je     0x185ded1fc
   185dedbc2:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   185dedbc7:	0f 85 2f f6 ff ff    	jne    0x185ded1fc
   185dedbcd:	49 8b 06             	mov    rax,QWORD PTR [r14]
   185dedbd0:	4c 89 f1             	mov    rcx,r14
   185dedbd3:	ff 10                	call   QWORD PTR [rax]
   185dedbd5:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   185dedbda:	0f 85 1c f6 ff ff    	jne    0x185ded1fc
   185dedbe0:	49 8b 06             	mov    rax,QWORD PTR [r14]
   185dedbe3:	4c 89 f1             	mov    rcx,r14
   185dedbe6:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185dedbe9:	e9 0e f6 ff ff       	jmp    0x185ded1fc
   185dedbee:	48 89 d9             	mov    rcx,rbx
   185dedbf1:	e8 a6 dc 6b 01       	call   0x1874ab89c
   185dedbf6:	90                   	nop
   185dedbf7:	48 89 85 20 01 00 00 	mov    QWORD PTR [rbp+0x120],rax
   185dedbfe:	48 89 85 28 01 00 00 	mov    QWORD PTR [rbp+0x128],rax
   185dedc05:	48 01 c3             	add    rbx,rax
   185dedc08:	48 89 9d 30 01 00 00 	mov    QWORD PTR [rbp+0x130],rbx
   185dedc0f:	48 8b 8d 00 01 00 00 	mov    rcx,QWORD PTR [rbp+0x100]
   185dedc16:	48 8b 95 08 01 00 00 	mov    rdx,QWORD PTR [rbp+0x108]
   185dedc1d:	48 39 d1             	cmp    rcx,rdx
   185dedc20:	74 3c                	je     0x185dedc5e
   185dedc22:	0f 57 c0             	xorps  xmm0,xmm0
   185dedc25:	eb 24                	jmp    0x185dedc4b
   185dedc27:	66 0f 1f 84 00 00 00 	nop    WORD PTR [rax+rax*1+0x0]
   185dedc2e:	00 00 
   185dedc30:	4c 8b 01             	mov    r8,QWORD PTR [rcx]
   185dedc33:	4c 89 00             	mov    QWORD PTR [rax],r8
   185dedc36:	4c 8b 41 08          	mov    r8,QWORD PTR [rcx+0x8]
   185dedc3a:	4c 89 40 08          	mov    QWORD PTR [rax+0x8],r8
   185dedc3e:	48 83 c0 10          	add    rax,0x10
   185dedc42:	48 83 c1 10          	add    rcx,0x10
   185dedc46:	48 39 d1             	cmp    rcx,rdx
   185dedc49:	74 13                	je     0x185dedc5e
   185dedc4b:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   185dedc4e:	4c 8b 41 08          	mov    r8,QWORD PTR [rcx+0x8]
   185dedc52:	4d 85 c0             	test   r8,r8
   185dedc55:	74 d9                	je     0x185dedc30
   185dedc57:	f0 41 ff 40 08       	lock inc DWORD PTR [r8+0x8]
   185dedc5c:	eb d2                	jmp    0x185dedc30
   185dedc5e:	48 89 85 28 01 00 00 	mov    QWORD PTR [rbp+0x128],rax
   185dedc65:	4c 8d 85 20 01 00 00 	lea    r8,[rbp+0x120]
   185dedc6c:	48 89 f9             	mov    rcx,rdi
   185dedc6f:	48 8b 95 98 00 00 00 	mov    rdx,QWORD PTR [rbp+0x98]
   185dedc76:	e8 75 73 bb fb       	call   0x1819a4ff0
   185dedc7b:	90                   	nop
   185dedc7c:	48 8b bd 20 01 00 00 	mov    rdi,QWORD PTR [rbp+0x120]
   185dedc83:	48 85 ff             	test   rdi,rdi
   185dedc86:	4c 8b a5 20 02 00 00 	mov    r12,QWORD PTR [rbp+0x220]
   185dedc8d:	4c 8b ad f8 00 00 00 	mov    r13,QWORD PTR [rbp+0xf8]
   185dedc94:	0f 84 95 00 00 00    	je     0x185dedd2f
   185dedc9a:	48 8b b5 28 01 00 00 	mov    rsi,QWORD PTR [rbp+0x128]
   185dedca1:	48 39 f7             	cmp    rdi,rsi
   185dedca4:	75 23                	jne    0x185dedcc9
   185dedca6:	48 8b 95 30 01 00 00 	mov    rdx,QWORD PTR [rbp+0x130]
   185dedcad:	48 29 fa             	sub    rdx,rdi
   185dedcb0:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185dedcb7:	73 52                	jae    0x185dedd0b
   185dedcb9:	eb 6c                	jmp    0x185dedd27
   185dedcbb:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]
   185dedcc0:	48 83 c7 10          	add    rdi,0x10
   185dedcc4:	48 39 f7             	cmp    rdi,rsi
   185dedcc7:	74 28                	je     0x185dedcf1
   185dedcc9:	48 8b 5f 08          	mov    rbx,QWORD PTR [rdi+0x8]
   185dedccd:	48 85 db             	test   rbx,rbx
   185dedcd0:	74 ee                	je     0x185dedcc0
   185dedcd2:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   185dedcd6:	75 e8                	jne    0x185dedcc0
   185dedcd8:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185dedcdb:	48 89 d9             	mov    rcx,rbx
   185dedcde:	ff 10                	call   QWORD PTR [rax]
   185dedce0:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   185dedce4:	75 da                	jne    0x185dedcc0
   185dedce6:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185dedce9:	48 89 d9             	mov    rcx,rbx
   185dedcec:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185dedcef:	eb cf                	jmp    0x185dedcc0
   185dedcf1:	48 8b bd 20 01 00 00 	mov    rdi,QWORD PTR [rbp+0x120]
   185dedcf8:	48 8b 95 30 01 00 00 	mov    rdx,QWORD PTR [rbp+0x130]
   185dedcff:	48 29 fa             	sub    rdx,rdi
   185dedd02:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185dedd09:	72 1c                	jb     0x185dedd27
   185dedd0b:	48 8b 47 f8          	mov    rax,QWORD PTR [rdi-0x8]
   185dedd0f:	48 83 c7 f8          	add    rdi,0xfffffffffffffff8
   185dedd13:	48 29 c7             	sub    rdi,rax
   185dedd16:	48 83 ff 20          	cmp    rdi,0x20
   185dedd1a:	0f 83 95 1c 00 00    	jae    0x185def9b5
   185dedd20:	48 83 c2 27          	add    rdx,0x27
   185dedd24:	48 89 c7             	mov    rdi,rax
   185dedd27:	48 89 f9             	mov    rcx,rdi
   185dedd2a:	e8 b1 db 6b 01       	call   0x1874ab8e0
   185dedd2f:	48 8b bd e8 00 00 00 	mov    rdi,QWORD PTR [rbp+0xe8]
   185dedd36:	48 85 ff             	test   rdi,rdi
   185dedd39:	74 1d                	je     0x185dedd58
   185dedd3b:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   185dedd3f:	75 17                	jne    0x185dedd58
   185dedd41:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185dedd44:	48 89 f9             	mov    rcx,rdi
   185dedd47:	ff 10                	call   QWORD PTR [rax]
   185dedd49:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   185dedd4d:	75 09                	jne    0x185dedd58
   185dedd4f:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185dedd52:	48 89 f9             	mov    rcx,rdi
   185dedd55:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185dedd58:	48 8b bd a8 00 00 00 	mov    rdi,QWORD PTR [rbp+0xa8]
   185dedd5f:	48 85 ff             	test   rdi,rdi
   185dedd62:	74 1d                	je     0x185dedd81
   185dedd64:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   185dedd68:	75 17                	jne    0x185dedd81
   185dedd6a:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185dedd6d:	48 89 f9             	mov    rcx,rdi
   185dedd70:	ff 10                	call   QWORD PTR [rax]
   185dedd72:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   185dedd76:	75 09                	jne    0x185dedd81
   185dedd78:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185dedd7b:	48 89 f9             	mov    rcx,rdi
   185dedd7e:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185dedd81:	48 8b 7d 78          	mov    rdi,QWORD PTR [rbp+0x78]
   185dedd85:	48 85 ff             	test   rdi,rdi
   185dedd88:	74 1d                	je     0x185dedda7
   185dedd8a:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   185dedd8e:	75 17                	jne    0x185dedda7
   185dedd90:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185dedd93:	48 89 f9             	mov    rcx,rdi
   185dedd96:	ff 10                	call   QWORD PTR [rax]
   185dedd98:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   185dedd9c:	75 09                	jne    0x185dedda7
   185dedd9e:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185dedda1:	48 89 f9             	mov    rcx,rdi
   185dedda4:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185dedda7:	48 8b bd 40 01 00 00 	mov    rdi,QWORD PTR [rbp+0x140]
   185deddae:	48 85 ff             	test   rdi,rdi
   185deddb1:	0f 84 98 00 00 00    	je     0x185dede4f
   185deddb7:	48 8b b5 48 01 00 00 	mov    rsi,QWORD PTR [rbp+0x148]
   185deddbe:	48 39 f7             	cmp    rdi,rsi
   185deddc1:	75 26                	jne    0x185dedde9
   185deddc3:	48 8b 95 50 01 00 00 	mov    rdx,QWORD PTR [rbp+0x150]
   185deddca:	48 29 fa             	sub    rdx,rdi
   185deddcd:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185deddd4:	73 55                	jae    0x185dede2b
   185deddd6:	eb 6f                	jmp    0x185dede47
   185deddd8:	0f 1f 84 00 00 00 00 	nop    DWORD PTR [rax+rax*1+0x0]
   185dedddf:	00 
   185dedde0:	48 83 c7 10          	add    rdi,0x10
   185dedde4:	48 39 f7             	cmp    rdi,rsi
   185dedde7:	74 28                	je     0x185dede11
   185dedde9:	48 8b 5f 08          	mov    rbx,QWORD PTR [rdi+0x8]
   185dedded:	48 85 db             	test   rbx,rbx
   185deddf0:	74 ee                	je     0x185dedde0
   185deddf2:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   185deddf6:	75 e8                	jne    0x185dedde0
   185deddf8:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185deddfb:	48 89 d9             	mov    rcx,rbx
   185deddfe:	ff 10                	call   QWORD PTR [rax]
   185dede00:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   185dede04:	75 da                	jne    0x185dedde0
   185dede06:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185dede09:	48 89 d9             	mov    rcx,rbx
   185dede0c:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185dede0f:	eb cf                	jmp    0x185dedde0
   185dede11:	48 8b bd 40 01 00 00 	mov    rdi,QWORD PTR [rbp+0x140]
   185dede18:	48 8b 95 50 01 00 00 	mov    rdx,QWORD PTR [rbp+0x150]
   185dede1f:	48 29 fa             	sub    rdx,rdi
   185dede22:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185dede29:	72 1c                	jb     0x185dede47
   185dede2b:	48 8b 47 f8          	mov    rax,QWORD PTR [rdi-0x8]
   185dede2f:	48 83 c7 f8          	add    rdi,0xfffffffffffffff8
   185dede33:	48 29 c7             	sub    rdi,rax
   185dede36:	48 83 ff 20          	cmp    rdi,0x20
   185dede3a:	0f 83 75 1b 00 00    	jae    0x185def9b5
   185dede40:	48 83 c2 27          	add    rdx,0x27
   185dede44:	48 89 c7             	mov    rdi,rax
   185dede47:	48 89 f9             	mov    rcx,rdi
   185dede4a:	e8 91 da 6b 01       	call   0x1874ab8e0
   185dede4f:	48 8b bd 60 01 00 00 	mov    rdi,QWORD PTR [rbp+0x160]
   185dede56:	48 85 ff             	test   rdi,rdi
   185dede59:	0f 84 84 18 00 00    	je     0x185def6e3
   185dede5f:	48 8b b5 68 01 00 00 	mov    rsi,QWORD PTR [rbp+0x168]
   185dede66:	48 39 f7             	cmp    rdi,rsi
   185dede69:	75 1e                	jne    0x185dede89
   185dede6b:	48 8b 95 70 01 00 00 	mov    rdx,QWORD PTR [rbp+0x170]
   185dede72:	48 29 fa             	sub    rdx,rdi
   185dede75:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185dede7c:	73 4d                	jae    0x185dedecb
   185dede7e:	eb 67                	jmp    0x185dedee7
   185dede80:	48 83 c7 10          	add    rdi,0x10
   185dede84:	48 39 f7             	cmp    rdi,rsi
   185dede87:	74 28                	je     0x185dedeb1
   185dede89:	48 8b 5f 08          	mov    rbx,QWORD PTR [rdi+0x8]
   185dede8d:	48 85 db             	test   rbx,rbx
   185dede90:	74 ee                	je     0x185dede80
   185dede92:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   185dede96:	75 e8                	jne    0x185dede80
   185dede98:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185dede9b:	48 89 d9             	mov    rcx,rbx
   185dede9e:	ff 10                	call   QWORD PTR [rax]
   185dedea0:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   185dedea4:	75 da                	jne    0x185dede80
   185dedea6:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185dedea9:	48 89 d9             	mov    rcx,rbx
   185dedeac:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185dedeaf:	eb cf                	jmp    0x185dede80
   185dedeb1:	48 8b bd 60 01 00 00 	mov    rdi,QWORD PTR [rbp+0x160]
   185dedeb8:	48 8b 95 70 01 00 00 	mov    rdx,QWORD PTR [rbp+0x170]
   185dedebf:	48 29 fa             	sub    rdx,rdi
   185dedec2:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185dedec9:	72 1c                	jb     0x185dedee7
   185dedecb:	48 8b 47 f8          	mov    rax,QWORD PTR [rdi-0x8]
   185dedecf:	48 83 c7 f8          	add    rdi,0xfffffffffffffff8
   185deded3:	48 29 c7             	sub    rdi,rax
   185deded6:	48 83 ff 20          	cmp    rdi,0x20
   185dededa:	0f 83 d5 1a 00 00    	jae    0x185def9b5
   185dedee0:	48 83 c2 27          	add    rdx,0x27
   185dedee4:	48 89 c7             	mov    rdi,rax
   185dedee7:	48 89 f9             	mov    rcx,rdi
   185dedeea:	e8 f1 d9 6b 01       	call   0x1874ab8e0
   185dedeef:	e9 ef 17 00 00       	jmp    0x185def6e3
   185dedef4:	0f 57 c0             	xorps  xmm0,xmm0
   185dedef7:	0f 29 85 c0 00 00 00 	movaps XMMWORD PTR [rbp+0xc0],xmm0
   185dedefe:	e9 42 0b 00 00       	jmp    0x185deea45
   185dedf03:	31 c0                	xor    eax,eax
   185dedf05:	48 8b 09             	mov    rcx,QWORD PTR [rcx]
   185dedf08:	48 89 4d 00          	mov    QWORD PTR [rbp+0x0],rcx
   185dedf0c:	48 89 45 08          	mov    QWORD PTR [rbp+0x8],rax
   185dedf10:	48 89 e8             	mov    rax,rbp
   185dedf13:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   185dedf18:	48 8d 8d 60 01 00 00 	lea    rcx,[rbp+0x160]
   185dedf1f:	48 8d 95 80 00 00 00 	lea    rdx,[rbp+0x80]
   185dedf26:	4c 8b 85 d8 00 00 00 	mov    r8,QWORD PTR [rbp+0xd8]
   185dedf2d:	4c 8b 8d d0 00 00 00 	mov    r9,QWORD PTR [rbp+0xd0]
   185dedf34:	e8 07 a8 b2 fe       	call   0x184918740
   185dedf39:	90                   	nop
   185dedf3a:	4c 8b 85 60 01 00 00 	mov    r8,QWORD PTR [rbp+0x160]
   185dedf41:	4c 8b 8d 68 01 00 00 	mov    r9,QWORD PTR [rbp+0x168]
   185dedf48:	48 8b 95 08 01 00 00 	mov    rdx,QWORD PTR [rbp+0x108]
   185dedf4f:	4d 29 c1             	sub    r9,r8
   185dedf52:	49 c1 f9 04          	sar    r9,0x4
   185dedf56:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   185dedf5d:	e8 7e ca 2d fb       	call   0x1810ca9e0
   185dedf62:	90                   	nop
   185dedf63:	48 8b bd 60 01 00 00 	mov    rdi,QWORD PTR [rbp+0x160]
   185dedf6a:	48 85 ff             	test   rdi,rdi
   185dedf6d:	0f 84 9d 00 00 00    	je     0x185dee010
   185dedf73:	48 8b b5 68 01 00 00 	mov    rsi,QWORD PTR [rbp+0x168]
   185dedf7a:	48 39 f7             	cmp    rdi,rsi
   185dedf7d:	75 2a                	jne    0x185dedfa9
   185dedf7f:	48 8b 95 70 01 00 00 	mov    rdx,QWORD PTR [rbp+0x170]
   185dedf86:	48 29 fa             	sub    rdx,rdi
   185dedf89:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185dedf90:	73 59                	jae    0x185dedfeb
   185dedf92:	eb 73                	jmp    0x185dee007
   185dedf94:	66 66 66 2e 0f 1f 84 	data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
   185dedf9b:	00 00 00 00 00 
   185dedfa0:	48 83 c7 10          	add    rdi,0x10
   185dedfa4:	48 39 f7             	cmp    rdi,rsi
   185dedfa7:	74 28                	je     0x185dedfd1
   185dedfa9:	48 8b 5f 08          	mov    rbx,QWORD PTR [rdi+0x8]
   185dedfad:	48 85 db             	test   rbx,rbx
   185dedfb0:	74 ee                	je     0x185dedfa0
   185dedfb2:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   185dedfb6:	75 e8                	jne    0x185dedfa0
   185dedfb8:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185dedfbb:	48 89 d9             	mov    rcx,rbx
   185dedfbe:	ff 10                	call   QWORD PTR [rax]
   185dedfc0:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   185dedfc4:	75 da                	jne    0x185dedfa0
   185dedfc6:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185dedfc9:	48 89 d9             	mov    rcx,rbx
   185dedfcc:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185dedfcf:	eb cf                	jmp    0x185dedfa0
   185dedfd1:	48 8b bd 60 01 00 00 	mov    rdi,QWORD PTR [rbp+0x160]
   185dedfd8:	48 8b 95 70 01 00 00 	mov    rdx,QWORD PTR [rbp+0x170]
   185dedfdf:	48 29 fa             	sub    rdx,rdi
   185dedfe2:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185dedfe9:	72 1c                	jb     0x185dee007
   185dedfeb:	48 8b 47 f8          	mov    rax,QWORD PTR [rdi-0x8]
   185dedfef:	48 83 c7 f8          	add    rdi,0xfffffffffffffff8
   185dedff3:	48 29 c7             	sub    rdi,rax
   185dedff6:	48 83 ff 20          	cmp    rdi,0x20
   185dedffa:	0f 83 b5 19 00 00    	jae    0x185def9b5
   185dee000:	48 83 c2 27          	add    rdx,0x27
   185dee004:	48 89 c7             	mov    rdi,rax
   185dee007:	48 89 f9             	mov    rcx,rdi
   185dee00a:	e8 d1 d8 6b 01       	call   0x1874ab8e0
   185dee00f:	90                   	nop
   185dee010:	e8 fb 7c 25 fa       	call   0x180045d10
   185dee015:	90                   	nop
   185dee016:	4c 8b 00             	mov    r8,QWORD PTR [rax]
   185dee019:	48 8d 95 c0 00 00 00 	lea    rdx,[rbp+0xc0]
   185dee020:	48 89 c1             	mov    rcx,rax
   185dee023:	41 ff 50 60          	call   QWORD PTR [r8+0x60]
   185dee027:	90                   	nop
   185dee028:	48 8b 8d c0 00 00 00 	mov    rcx,QWORD PTR [rbp+0xc0]
   185dee02f:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   185dee032:	48 8d 95 b0 00 00 00 	lea    rdx,[rbp+0xb0]
   185dee039:	ff 50 30             	call   QWORD PTR [rax+0x30]
   185dee03c:	90                   	nop
   185dee03d:	48 8b 8d b0 00 00 00 	mov    rcx,QWORD PTR [rbp+0xb0]
   185dee044:	48 8d 05 bd 27 06 03 	lea    rax,[rip+0x30627bd]        # 0x188e50808
   185dee04b:	48 89 85 e0 00 00 00 	mov    QWORD PTR [rbp+0xe0],rax
   185dee052:	0f 29 b5 60 01 00 00 	movaps XMMWORD PTR [rbp+0x160],xmm6
   185dee059:	48 8d 95 60 01 00 00 	lea    rdx,[rbp+0x160]
   185dee060:	4c 8d 85 e0 00 00 00 	lea    r8,[rbp+0xe0]
   185dee067:	e8 14 0a 3b fa       	call   0x18019ea80
   185dee06c:	90                   	nop
   185dee06d:	48 8b 85 60 01 00 00 	mov    rax,QWORD PTR [rbp+0x160]
   185dee074:	48 8b 8d 68 01 00 00 	mov    rcx,QWORD PTR [rbp+0x168]
   185dee07b:	48 85 c9             	test   rcx,rcx
   185dee07e:	74 3d                	je     0x185dee0bd
   185dee080:	f0 ff 41 08          	lock inc DWORD PTR [rcx+0x8]
   185dee084:	48 8b bd 68 01 00 00 	mov    rdi,QWORD PTR [rbp+0x168]
   185dee08b:	48 89 85 40 01 00 00 	mov    QWORD PTR [rbp+0x140],rax
   185dee092:	48 89 bd 48 01 00 00 	mov    QWORD PTR [rbp+0x148],rdi
   185dee099:	48 85 ff             	test   rdi,rdi
   185dee09c:	74 31                	je     0x185dee0cf
   185dee09e:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   185dee0a2:	75 2b                	jne    0x185dee0cf
   185dee0a4:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185dee0a7:	48 89 f9             	mov    rcx,rdi
   185dee0aa:	ff 10                	call   QWORD PTR [rax]
   185dee0ac:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   185dee0b0:	75 1d                	jne    0x185dee0cf
   185dee0b2:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185dee0b5:	48 89 f9             	mov    rcx,rdi
   185dee0b8:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185dee0bb:	eb 12                	jmp    0x185dee0cf
   185dee0bd:	48 89 85 40 01 00 00 	mov    QWORD PTR [rbp+0x140],rax
   185dee0c4:	48 c7 85 48 01 00 00 	mov    QWORD PTR [rbp+0x148],0x0
   185dee0cb:	00 00 00 00 
   185dee0cf:	48 8b 9d 08 01 00 00 	mov    rbx,QWORD PTR [rbp+0x108]
   185dee0d6:	48 8b 8d 00 01 00 00 	mov    rcx,QWORD PTR [rbp+0x100]
   185dee0dd:	48 89 d8             	mov    rax,rbx
   185dee0e0:	48 29 c8             	sub    rax,rcx
   185dee0e3:	48 8b bd 40 01 00 00 	mov    rdi,QWORD PTR [rbp+0x140]
   185dee0ea:	0f 57 c0             	xorps  xmm0,xmm0
   185dee0ed:	0f 29 85 60 01 00 00 	movaps XMMWORD PTR [rbp+0x160],xmm0
   185dee0f4:	48 c7 85 70 01 00 00 	mov    QWORD PTR [rbp+0x170],0x0
   185dee0fb:	00 00 00 00 
   185dee0ff:	48 29 cb             	sub    rbx,rcx
   185dee102:	0f 84 ad 00 00 00    	je     0x185dee1b5
   185dee108:	48 c1 f8 04          	sar    rax,0x4
   185dee10c:	48 89 c1             	mov    rcx,rax
   185dee10f:	48 c1 e9 3c          	shr    rcx,0x3c
   185dee113:	0f 85 a2 18 00 00    	jne    0x185def9bb
   185dee119:	48 3d 00 01 00 00    	cmp    rax,0x100
   185dee11f:	72 24                	jb     0x185dee145
   185dee121:	48 8d 4b 27          	lea    rcx,[rbx+0x27]
   185dee125:	e8 72 d7 6b 01       	call   0x1874ab89c
   185dee12a:	90                   	nop
   185dee12b:	48 85 c0             	test   rax,rax
   185dee12e:	0f 84 81 18 00 00    	je     0x185def9b5
   185dee134:	48 89 c1             	mov    rcx,rax
   185dee137:	48 83 c0 27          	add    rax,0x27
   185dee13b:	48 83 e0 e0          	and    rax,0xffffffffffffffe0
   185dee13f:	48 89 48 f8          	mov    QWORD PTR [rax-0x8],rcx
   185dee143:	eb 09                	jmp    0x185dee14e
   185dee145:	48 89 d9             	mov    rcx,rbx
   185dee148:	e8 4f d7 6b 01       	call   0x1874ab89c
   185dee14d:	90                   	nop
   185dee14e:	48 89 85 60 01 00 00 	mov    QWORD PTR [rbp+0x160],rax
   185dee155:	48 89 85 68 01 00 00 	mov    QWORD PTR [rbp+0x168],rax
   185dee15c:	48 01 c3             	add    rbx,rax
   185dee15f:	48 89 9d 70 01 00 00 	mov    QWORD PTR [rbp+0x170],rbx
   185dee166:	48 8b 8d 00 01 00 00 	mov    rcx,QWORD PTR [rbp+0x100]
   185dee16d:	48 8b 95 08 01 00 00 	mov    rdx,QWORD PTR [rbp+0x108]
   185dee174:	48 39 d1             	cmp    rcx,rdx
   185dee177:	74 35                	je     0x185dee1ae
   185dee179:	0f 57 c0             	xorps  xmm0,xmm0
   185dee17c:	eb 1d                	jmp    0x185dee19b
   185dee17e:	66 90                	xchg   ax,ax
   185dee180:	4c 8b 01             	mov    r8,QWORD PTR [rcx]
   185dee183:	4c 89 00             	mov    QWORD PTR [rax],r8
   185dee186:	4c 8b 41 08          	mov    r8,QWORD PTR [rcx+0x8]
   185dee18a:	4c 89 40 08          	mov    QWORD PTR [rax+0x8],r8
   185dee18e:	48 83 c0 10          	add    rax,0x10
   185dee192:	48 83 c1 10          	add    rcx,0x10
   185dee196:	48 39 d1             	cmp    rcx,rdx
   185dee199:	74 13                	je     0x185dee1ae
   185dee19b:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   185dee19e:	4c 8b 41 08          	mov    r8,QWORD PTR [rcx+0x8]
   185dee1a2:	4d 85 c0             	test   r8,r8
   185dee1a5:	74 d9                	je     0x185dee180
   185dee1a7:	f0 41 ff 40 08       	lock inc DWORD PTR [r8+0x8]
   185dee1ac:	eb d2                	jmp    0x185dee180
   185dee1ae:	48 89 85 68 01 00 00 	mov    QWORD PTR [rbp+0x168],rax
   185dee1b5:	4c 8d 85 60 01 00 00 	lea    r8,[rbp+0x160]
   185dee1bc:	48 89 f9             	mov    rcx,rdi
   185dee1bf:	48 8b 95 98 00 00 00 	mov    rdx,QWORD PTR [rbp+0x98]
   185dee1c6:	e8 25 6e bb fb       	call   0x1819a4ff0
   185dee1cb:	90                   	nop
   185dee1cc:	48 8b bd 60 01 00 00 	mov    rdi,QWORD PTR [rbp+0x160]
   185dee1d3:	48 85 ff             	test   rdi,rdi
   185dee1d6:	4c 8b a5 20 02 00 00 	mov    r12,QWORD PTR [rbp+0x220]
   185dee1dd:	4c 8b ad f8 00 00 00 	mov    r13,QWORD PTR [rbp+0xf8]
   185dee1e4:	0f 84 95 00 00 00    	je     0x185dee27f
   185dee1ea:	48 8b b5 68 01 00 00 	mov    rsi,QWORD PTR [rbp+0x168]
   185dee1f1:	48 39 f7             	cmp    rdi,rsi
   185dee1f4:	75 23                	jne    0x185dee219
   185dee1f6:	48 8b 95 70 01 00 00 	mov    rdx,QWORD PTR [rbp+0x170]
   185dee1fd:	48 29 fa             	sub    rdx,rdi
   185dee200:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185dee207:	73 52                	jae    0x185dee25b
   185dee209:	eb 6c                	jmp    0x185dee277
   185dee20b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]
   185dee210:	48 83 c7 10          	add    rdi,0x10
   185dee214:	48 39 f7             	cmp    rdi,rsi
   185dee217:	74 28                	je     0x185dee241
   185dee219:	48 8b 5f 08          	mov    rbx,QWORD PTR [rdi+0x8]
   185dee21d:	48 85 db             	test   rbx,rbx
   185dee220:	74 ee                	je     0x185dee210
   185dee222:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   185dee226:	75 e8                	jne    0x185dee210
   185dee228:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185dee22b:	48 89 d9             	mov    rcx,rbx
   185dee22e:	ff 10                	call   QWORD PTR [rax]
   185dee230:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   185dee234:	75 da                	jne    0x185dee210
   185dee236:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185dee239:	48 89 d9             	mov    rcx,rbx
   185dee23c:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185dee23f:	eb cf                	jmp    0x185dee210
   185dee241:	48 8b bd 60 01 00 00 	mov    rdi,QWORD PTR [rbp+0x160]
   185dee248:	48 8b 95 70 01 00 00 	mov    rdx,QWORD PTR [rbp+0x170]
   185dee24f:	48 29 fa             	sub    rdx,rdi
   185dee252:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185dee259:	72 1c                	jb     0x185dee277
   185dee25b:	48 8b 47 f8          	mov    rax,QWORD PTR [rdi-0x8]
   185dee25f:	48 83 c7 f8          	add    rdi,0xfffffffffffffff8
   185dee263:	48 29 c7             	sub    rdi,rax
   185dee266:	48 83 ff 20          	cmp    rdi,0x20
   185dee26a:	0f 83 45 17 00 00    	jae    0x185def9b5
   185dee270:	48 83 c2 27          	add    rdx,0x27
   185dee274:	48 89 c7             	mov    rdi,rax
   185dee277:	48 89 f9             	mov    rcx,rdi
   185dee27a:	e8 61 d6 6b 01       	call   0x1874ab8e0
   185dee27f:	48 8b bd 48 01 00 00 	mov    rdi,QWORD PTR [rbp+0x148]
   185dee286:	48 85 ff             	test   rdi,rdi
   185dee289:	74 1d                	je     0x185dee2a8
   185dee28b:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   185dee28f:	75 17                	jne    0x185dee2a8
   185dee291:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185dee294:	48 89 f9             	mov    rcx,rdi
   185dee297:	ff 10                	call   QWORD PTR [rax]
   185dee299:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   185dee29d:	75 09                	jne    0x185dee2a8
   185dee29f:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185dee2a2:	48 89 f9             	mov    rcx,rdi
   185dee2a5:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185dee2a8:	48 8b bd b8 00 00 00 	mov    rdi,QWORD PTR [rbp+0xb8]
   185dee2af:	48 85 ff             	test   rdi,rdi
   185dee2b2:	74 1d                	je     0x185dee2d1
   185dee2b4:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   185dee2b8:	75 17                	jne    0x185dee2d1
   185dee2ba:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185dee2bd:	48 89 f9             	mov    rcx,rdi
   185dee2c0:	ff 10                	call   QWORD PTR [rax]
   185dee2c2:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   185dee2c6:	75 09                	jne    0x185dee2d1
   185dee2c8:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185dee2cb:	48 89 f9             	mov    rcx,rdi
   185dee2ce:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185dee2d1:	48 8b bd c8 00 00 00 	mov    rdi,QWORD PTR [rbp+0xc8]
   185dee2d8:	48 85 ff             	test   rdi,rdi
   185dee2db:	74 1d                	je     0x185dee2fa
   185dee2dd:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   185dee2e1:	75 17                	jne    0x185dee2fa
   185dee2e3:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185dee2e6:	48 89 f9             	mov    rcx,rdi
   185dee2e9:	ff 10                	call   QWORD PTR [rax]
   185dee2eb:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   185dee2ef:	75 09                	jne    0x185dee2fa
   185dee2f1:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185dee2f4:	48 89 f9             	mov    rcx,rdi
   185dee2f7:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185dee2fa:	48 8b bd 28 01 00 00 	mov    rdi,QWORD PTR [rbp+0x128]
   185dee301:	48 85 ff             	test   rdi,rdi
   185dee304:	0f 85 0e 14 00 00    	jne    0x185def718
   185dee30a:	e9 26 14 00 00       	jmp    0x185def735
   185dee30f:	31 c0                	xor    eax,eax
   185dee311:	4c 89 b5 c0 00 00 00 	mov    QWORD PTR [rbp+0xc0],r14
   185dee318:	48 89 85 c8 00 00 00 	mov    QWORD PTR [rbp+0xc8],rax
   185dee31f:	4c 89 f1             	mov    rcx,r14
   185dee322:	e8 99 5d 58 fb       	call   0x1813740c0
   185dee327:	90                   	nop
   185dee328:	48 8b 48 08          	mov    rcx,QWORD PTR [rax+0x8]
   185dee32c:	48 2b 08             	sub    rcx,QWORD PTR [rax]
   185dee32f:	48 81 f9 c8 09 00 00 	cmp    rcx,0x9c8
   185dee336:	0f 85 62 01 00 00    	jne    0x185dee49e
   185dee33c:	0f 29 b5 20 01 00 00 	movaps XMMWORD PTR [rbp+0x120],xmm6
   185dee343:	48 8d 95 20 01 00 00 	lea    rdx,[rbp+0x120]
   185dee34a:	4c 89 f1             	mov    rcx,r14
   185dee34d:	e8 be 36 44 fc       	call   0x182231a10
   185dee352:	90                   	nop
   185dee353:	48 8b 8d 20 01 00 00 	mov    rcx,QWORD PTR [rbp+0x120]
   185dee35a:	48 85 c9             	test   rcx,rcx
   185dee35d:	0f 84 fd 00 00 00    	je     0x185dee460
   185dee363:	0f 57 c0             	xorps  xmm0,xmm0
   185dee366:	0f 29 85 e0 00 00 00 	movaps XMMWORD PTR [rbp+0xe0],xmm0
   185dee36d:	48 8d 95 e0 00 00 00 	lea    rdx,[rbp+0xe0]
   185dee374:	e8 c7 41 7c ff       	call   0x1855b2540
   185dee379:	90                   	nop
   185dee37a:	48 85 c0             	test   rax,rax
   185dee37d:	0f 85 b2 00 00 00    	jne    0x185dee435
   185dee383:	48 83 bd e0 00 00 00 	cmp    QWORD PTR [rbp+0xe0],0x0
   185dee38a:	00 
   185dee38b:	0f 84 a4 00 00 00    	je     0x185dee435
   185dee391:	0f 57 c0             	xorps  xmm0,xmm0
   185dee394:	0f 29 85 60 01 00 00 	movaps XMMWORD PTR [rbp+0x160],xmm0
   185dee39b:	48 c7 85 70 01 00 00 	mov    QWORD PTR [rbp+0x170],0x0
   185dee3a2:	00 00 00 00 
   185dee3a6:	48 8d 8d 60 01 00 00 	lea    rcx,[rbp+0x160]
   185dee3ad:	48 8d 95 e0 00 00 00 	lea    rdx,[rbp+0xe0]
   185dee3b4:	e8 47 14 93 fa       	call   0x18071f800
   185dee3b9:	90                   	nop
   185dee3ba:	48 b8 aa aa aa aa aa 	movabs rax,0xaaaaaaaaaaaaaaaa
   185dee3c1:	aa aa aa 
   185dee3c4:	48 89 85 50 01 00 00 	mov    QWORD PTR [rbp+0x150],rax
   185dee3cb:	0f 29 b5 40 01 00 00 	movaps XMMWORD PTR [rbp+0x140],xmm6
   185dee3d2:	48 8d 8d 40 01 00 00 	lea    rcx,[rbp+0x140]
   185dee3d9:	48 8d 95 60 01 00 00 	lea    rdx,[rbp+0x160]
   185dee3e0:	4c 8b 85 d8 00 00 00 	mov    r8,QWORD PTR [rbp+0xd8]
   185dee3e7:	4c 8b 8d d0 00 00 00 	mov    r9,QWORD PTR [rbp+0xd0]
   185dee3ee:	e8 ed 87 b2 fe       	call   0x184916be0
   185dee3f3:	90                   	nop
   185dee3f4:	4c 8b 85 40 01 00 00 	mov    r8,QWORD PTR [rbp+0x140]
   185dee3fb:	4c 8b 8d 48 01 00 00 	mov    r9,QWORD PTR [rbp+0x148]
   185dee402:	48 8b 95 08 01 00 00 	mov    rdx,QWORD PTR [rbp+0x108]
   185dee409:	4d 29 c1             	sub    r9,r8
   185dee40c:	49 c1 f9 04          	sar    r9,0x4
   185dee410:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   185dee417:	e8 c4 c5 2d fb       	call   0x1810ca9e0
   185dee41c:	90                   	nop
   185dee41d:	48 8d 8d 40 01 00 00 	lea    rcx,[rbp+0x140]
   185dee424:	e8 87 3c 3e fa       	call   0x1801d20b0
   185dee429:	48 8d 8d 60 01 00 00 	lea    rcx,[rbp+0x160]
   185dee430:	e8 7b 3c 3e fa       	call   0x1801d20b0
   185dee435:	4c 8b b5 e8 00 00 00 	mov    r14,QWORD PTR [rbp+0xe8]
   185dee43c:	4d 85 f6             	test   r14,r14
   185dee43f:	74 1f                	je     0x185dee460
   185dee441:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   185dee446:	75 18                	jne    0x185dee460
   185dee448:	49 8b 06             	mov    rax,QWORD PTR [r14]
   185dee44b:	4c 89 f1             	mov    rcx,r14
   185dee44e:	ff 10                	call   QWORD PTR [rax]
   185dee450:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   185dee455:	75 09                	jne    0x185dee460
   185dee457:	49 8b 06             	mov    rax,QWORD PTR [r14]
   185dee45a:	4c 89 f1             	mov    rcx,r14
   185dee45d:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185dee460:	4c 8b b5 28 01 00 00 	mov    r14,QWORD PTR [rbp+0x128]
   185dee467:	4d 85 f6             	test   r14,r14
   185dee46a:	4c 8b a5 20 02 00 00 	mov    r12,QWORD PTR [rbp+0x220]
   185dee471:	74 1f                	je     0x185dee492
   185dee473:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   185dee478:	75 18                	jne    0x185dee492
   185dee47a:	49 8b 06             	mov    rax,QWORD PTR [r14]
   185dee47d:	4c 89 f1             	mov    rcx,r14
   185dee480:	ff 10                	call   QWORD PTR [rax]
   185dee482:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   185dee487:	75 09                	jne    0x185dee492
   185dee489:	49 8b 06             	mov    rax,QWORD PTR [r14]
   185dee48c:	4c 89 f1             	mov    rcx,r14
   185dee48f:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185dee492:	4c 8b ad f8 00 00 00 	mov    r13,QWORD PTR [rbp+0xf8]
   185dee499:	e9 d3 04 00 00       	jmp    0x185dee971
   185dee49e:	48 c1 f9 03          	sar    rcx,0x3
   185dee4a2:	48 ba 09 9d 40 39 8a 	movabs rdx,0x58550f8a39409d09
   185dee4a9:	0f 55 58 
   185dee4ac:	48 0f af d1          	imul   rdx,rcx
   185dee4b0:	48 83 fa 02          	cmp    rdx,0x2
   185dee4b4:	4c 8b a5 20 02 00 00 	mov    r12,QWORD PTR [rbp+0x220]
   185dee4bb:	4c 8b ad f8 00 00 00 	mov    r13,QWORD PTR [rbp+0xf8]
   185dee4c2:	0f 82 a9 04 00 00    	jb     0x185dee971
   185dee4c8:	0f 57 ff             	xorps  xmm7,xmm7
   185dee4cb:	0f 29 bd 60 01 00 00 	movaps XMMWORD PTR [rbp+0x160],xmm7
   185dee4d2:	48 c7 85 70 01 00 00 	mov    QWORD PTR [rbp+0x170],0x0
   185dee4d9:	00 00 00 00 
   185dee4dd:	4c 8b 30             	mov    r14,QWORD PTR [rax]
   185dee4e0:	48 8b 70 08          	mov    rsi,QWORD PTR [rax+0x8]
   185dee4e4:	49 39 f6             	cmp    r14,rsi
   185dee4e7:	0f 84 d1 00 00 00    	je     0x185dee5be
   185dee4ed:	4c 8d bd 40 01 00 00 	lea    r15,[rbp+0x140]
   185dee4f4:	4c 8d a5 60 01 00 00 	lea    r12,[rbp+0x160]
   185dee4fb:	eb 13                	jmp    0x185dee510
   185dee4fd:	0f 1f 00             	nop    DWORD PTR [rax]
   185dee500:	49 81 c6 c8 09 00 00 	add    r14,0x9c8
   185dee507:	49 39 f6             	cmp    r14,rsi
   185dee50a:	0f 84 ae 00 00 00    	je     0x185dee5be
   185dee510:	0f 29 bd 40 01 00 00 	movaps XMMWORD PTR [rbp+0x140],xmm7
   185dee517:	4c 89 f1             	mov    rcx,r14
   185dee51a:	4c 89 fa             	mov    rdx,r15
   185dee51d:	e8 1e 40 7c ff       	call   0x1855b2540
   185dee522:	90                   	nop
   185dee523:	48 85 c0             	test   rax,rax
   185dee526:	75 58                	jne    0x185dee580
   185dee528:	48 83 bd 40 01 00 00 	cmp    QWORD PTR [rbp+0x140],0x0
   185dee52f:	00 
   185dee530:	74 4e                	je     0x185dee580
   185dee532:	48 8b 95 68 01 00 00 	mov    rdx,QWORD PTR [rbp+0x168]
   185dee539:	48 3b 95 70 01 00 00 	cmp    rdx,QWORD PTR [rbp+0x170]
   185dee540:	74 32                	je     0x185dee574
   185dee542:	0f 11 3a             	movups XMMWORD PTR [rdx],xmm7
   185dee545:	48 8b 85 48 01 00 00 	mov    rax,QWORD PTR [rbp+0x148]
   185dee54c:	48 85 c0             	test   rax,rax
   185dee54f:	74 04                	je     0x185dee555
   185dee551:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   185dee555:	48 8b 85 40 01 00 00 	mov    rax,QWORD PTR [rbp+0x140]
   185dee55c:	48 89 02             	mov    QWORD PTR [rdx],rax
   185dee55f:	48 8b 85 48 01 00 00 	mov    rax,QWORD PTR [rbp+0x148]
   185dee566:	48 89 42 08          	mov    QWORD PTR [rdx+0x8],rax
   185dee56a:	48 83 85 68 01 00 00 	add    QWORD PTR [rbp+0x168],0x10
   185dee571:	10 
   185dee572:	eb 0c                	jmp    0x185dee580
   185dee574:	4c 89 e1             	mov    rcx,r12
   185dee577:	4d 89 f8             	mov    r8,r15
   185dee57a:	e8 81 33 3e fa       	call   0x1801d1900
   185dee57f:	90                   	nop
   185dee580:	4c 8b ad 48 01 00 00 	mov    r13,QWORD PTR [rbp+0x148]
   185dee587:	4d 85 ed             	test   r13,r13
   185dee58a:	0f 84 70 ff ff ff    	je     0x185dee500
   185dee590:	f0 41 ff 4d 08       	lock dec DWORD PTR [r13+0x8]
   185dee595:	0f 85 65 ff ff ff    	jne    0x185dee500
   185dee59b:	49 8b 45 00          	mov    rax,QWORD PTR [r13+0x0]
   185dee59f:	4c 89 e9             	mov    rcx,r13
   185dee5a2:	ff 10                	call   QWORD PTR [rax]
   185dee5a4:	f0 41 ff 4d 0c       	lock dec DWORD PTR [r13+0xc]
   185dee5a9:	0f 85 51 ff ff ff    	jne    0x185dee500
   185dee5af:	49 8b 45 00          	mov    rax,QWORD PTR [r13+0x0]
   185dee5b3:	4c 89 e9             	mov    rcx,r13
   185dee5b6:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185dee5b9:	e9 42 ff ff ff       	jmp    0x185dee500
   185dee5be:	48 b8 aa aa aa aa aa 	movabs rax,0xaaaaaaaaaaaaaaaa
   185dee5c5:	aa aa aa 
   185dee5c8:	48 89 85 50 01 00 00 	mov    QWORD PTR [rbp+0x150],rax
   185dee5cf:	0f 29 b5 40 01 00 00 	movaps XMMWORD PTR [rbp+0x140],xmm6
   185dee5d6:	48 8d 8d 40 01 00 00 	lea    rcx,[rbp+0x140]
   185dee5dd:	48 8d 95 60 01 00 00 	lea    rdx,[rbp+0x160]
   185dee5e4:	4c 8b 85 d8 00 00 00 	mov    r8,QWORD PTR [rbp+0xd8]
   185dee5eb:	4c 8b 8d d0 00 00 00 	mov    r9,QWORD PTR [rbp+0xd0]
   185dee5f2:	e8 e9 85 b2 fe       	call   0x184916be0
   185dee5f7:	90                   	nop
   185dee5f8:	4c 8b 85 40 01 00 00 	mov    r8,QWORD PTR [rbp+0x140]
   185dee5ff:	4c 8b 8d 48 01 00 00 	mov    r9,QWORD PTR [rbp+0x148]
   185dee606:	48 8b 95 08 01 00 00 	mov    rdx,QWORD PTR [rbp+0x108]
   185dee60d:	4d 29 c1             	sub    r9,r8
   185dee610:	49 c1 f9 04          	sar    r9,0x4
   185dee614:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   185dee61b:	e8 c0 c3 2d fb       	call   0x1810ca9e0
   185dee620:	90                   	nop
   185dee621:	4c 8b b5 40 01 00 00 	mov    r14,QWORD PTR [rbp+0x140]
   185dee628:	4d 85 f6             	test   r14,r14
   185dee62b:	4c 8b a5 20 02 00 00 	mov    r12,QWORD PTR [rbp+0x220]
   185dee632:	4c 8b ad f8 00 00 00 	mov    r13,QWORD PTR [rbp+0xf8]
   185dee639:	0f 84 98 02 00 00    	je     0x185dee8d7
   185dee63f:	48 8b b5 48 01 00 00 	mov    rsi,QWORD PTR [rbp+0x148]
   185dee646:	49 39 f6             	cmp    r14,rsi
   185dee649:	75 12                	jne    0x185dee65d
   185dee64b:	e9 50 02 00 00       	jmp    0x185dee8a0
   185dee650:	49 83 c6 10          	add    r14,0x10
   185dee654:	49 39 f6             	cmp    r14,rsi
   185dee657:	0f 84 3c 02 00 00    	je     0x185dee899
   185dee65d:	4d 8b 7e 08          	mov    r15,QWORD PTR [r14+0x8]
   185dee661:	4d 85 ff             	test   r15,r15
   185dee664:	74 ea                	je     0x185dee650
   185dee666:	f0 41 ff 4f 08       	lock dec DWORD PTR [r15+0x8]
   185dee66b:	75 e3                	jne    0x185dee650
   185dee66d:	49 8b 07             	mov    rax,QWORD PTR [r15]
   185dee670:	4c 89 f9             	mov    rcx,r15
   185dee673:	ff 10                	call   QWORD PTR [rax]
   185dee675:	f0 41 ff 4f 0c       	lock dec DWORD PTR [r15+0xc]
   185dee67a:	75 d4                	jne    0x185dee650
   185dee67c:	49 8b 07             	mov    rax,QWORD PTR [r15]
   185dee67f:	4c 89 f9             	mov    rcx,r15
   185dee682:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185dee685:	eb c9                	jmp    0x185dee650
   185dee687:	48 8b 85 b0 00 00 00 	mov    rax,QWORD PTR [rbp+0xb0]
   185dee68e:	48 89 85 40 01 00 00 	mov    QWORD PTR [rbp+0x140],rax
   185dee695:	48 c7 85 48 01 00 00 	mov    QWORD PTR [rbp+0x148],0x0
   185dee69c:	00 00 00 00 
   185dee6a0:	31 d2                	xor    edx,edx
   185dee6a2:	48 8d 8d 60 01 00 00 	lea    rcx,[rbp+0x160]
   185dee6a9:	4c 8d 85 40 01 00 00 	lea    r8,[rbp+0x140]
   185dee6b0:	e8 ab 38 2c fb       	call   0x1810b1f60
   185dee6b5:	90                   	nop
   185dee6b6:	4c 8b b5 48 01 00 00 	mov    r14,QWORD PTR [rbp+0x148]
   185dee6bd:	4d 85 f6             	test   r14,r14
   185dee6c0:	74 1f                	je     0x185dee6e1
   185dee6c2:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   185dee6c7:	75 18                	jne    0x185dee6e1
   185dee6c9:	49 8b 06             	mov    rax,QWORD PTR [r14]
   185dee6cc:	4c 89 f1             	mov    rcx,r14
   185dee6cf:	ff 10                	call   QWORD PTR [rax]
   185dee6d1:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   185dee6d6:	75 09                	jne    0x185dee6e1
   185dee6d8:	49 8b 06             	mov    rax,QWORD PTR [r14]
   185dee6db:	4c 89 f1             	mov    rcx,r14
   185dee6de:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185dee6e1:	48 b8 aa aa aa aa aa 	movabs rax,0xaaaaaaaaaaaaaaaa
   185dee6e8:	aa aa aa 
   185dee6eb:	48 89 85 50 01 00 00 	mov    QWORD PTR [rbp+0x150],rax
   185dee6f2:	0f 29 b5 40 01 00 00 	movaps XMMWORD PTR [rbp+0x140],xmm6
   185dee6f9:	48 8d 8d 40 01 00 00 	lea    rcx,[rbp+0x140]
   185dee700:	48 8d 95 60 01 00 00 	lea    rdx,[rbp+0x160]
   185dee707:	4c 8b 85 d8 00 00 00 	mov    r8,QWORD PTR [rbp+0xd8]
   185dee70e:	4c 8b 8d d0 00 00 00 	mov    r9,QWORD PTR [rbp+0xd0]
   185dee715:	e8 c6 84 b2 fe       	call   0x184916be0
   185dee71a:	90                   	nop
   185dee71b:	4c 8b 85 40 01 00 00 	mov    r8,QWORD PTR [rbp+0x140]
   185dee722:	4c 8b 8d 48 01 00 00 	mov    r9,QWORD PTR [rbp+0x148]
   185dee729:	48 8b 95 08 01 00 00 	mov    rdx,QWORD PTR [rbp+0x108]
   185dee730:	4d 29 c1             	sub    r9,r8
   185dee733:	49 c1 f9 04          	sar    r9,0x4
   185dee737:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   185dee73e:	e8 9d c2 2d fb       	call   0x1810ca9e0
   185dee743:	90                   	nop
   185dee744:	48 8b bd 40 01 00 00 	mov    rdi,QWORD PTR [rbp+0x140]
   185dee74b:	48 85 ff             	test   rdi,rdi
   185dee74e:	74 7f                	je     0x185dee7cf
   185dee750:	48 8b b5 48 01 00 00 	mov    rsi,QWORD PTR [rbp+0x148]
   185dee757:	48 39 f7             	cmp    rdi,rsi
   185dee75a:	75 0d                	jne    0x185dee769
   185dee75c:	eb 3a                	jmp    0x185dee798
   185dee75e:	66 90                	xchg   ax,ax
   185dee760:	48 83 c7 10          	add    rdi,0x10
   185dee764:	48 39 f7             	cmp    rdi,rsi
   185dee767:	74 28                	je     0x185dee791
   185dee769:	48 8b 5f 08          	mov    rbx,QWORD PTR [rdi+0x8]
   185dee76d:	48 85 db             	test   rbx,rbx
   185dee770:	74 ee                	je     0x185dee760
   185dee772:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   185dee776:	75 e8                	jne    0x185dee760
   185dee778:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185dee77b:	48 89 d9             	mov    rcx,rbx
   185dee77e:	ff 10                	call   QWORD PTR [rax]
   185dee780:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   185dee784:	75 da                	jne    0x185dee760
   185dee786:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185dee789:	48 89 d9             	mov    rcx,rbx
   185dee78c:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185dee78f:	eb cf                	jmp    0x185dee760
   185dee791:	48 8b bd 40 01 00 00 	mov    rdi,QWORD PTR [rbp+0x140]
   185dee798:	48 8b 95 50 01 00 00 	mov    rdx,QWORD PTR [rbp+0x150]
   185dee79f:	48 29 fa             	sub    rdx,rdi
   185dee7a2:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185dee7a9:	72 1c                	jb     0x185dee7c7
   185dee7ab:	48 8b 47 f8          	mov    rax,QWORD PTR [rdi-0x8]
   185dee7af:	48 83 c7 f8          	add    rdi,0xfffffffffffffff8
   185dee7b3:	48 29 c7             	sub    rdi,rax
   185dee7b6:	48 83 ff 20          	cmp    rdi,0x20
   185dee7ba:	0f 83 f5 11 00 00    	jae    0x185def9b5
   185dee7c0:	48 83 c2 27          	add    rdx,0x27
   185dee7c4:	48 89 c7             	mov    rdi,rax
   185dee7c7:	48 89 f9             	mov    rcx,rdi
   185dee7ca:	e8 11 d1 6b 01       	call   0x1874ab8e0
   185dee7cf:	48 8b bd 60 01 00 00 	mov    rdi,QWORD PTR [rbp+0x160]
   185dee7d6:	48 85 ff             	test   rdi,rdi
   185dee7d9:	0f 84 80 00 00 00    	je     0x185dee85f
   185dee7df:	48 8b b5 68 01 00 00 	mov    rsi,QWORD PTR [rbp+0x168]
   185dee7e6:	48 39 f7             	cmp    rdi,rsi
   185dee7e9:	75 0e                	jne    0x185dee7f9
   185dee7eb:	eb 3b                	jmp    0x185dee828
   185dee7ed:	0f 1f 00             	nop    DWORD PTR [rax]
   185dee7f0:	48 83 c7 10          	add    rdi,0x10
   185dee7f4:	48 39 f7             	cmp    rdi,rsi
   185dee7f7:	74 28                	je     0x185dee821
   185dee7f9:	48 8b 5f 08          	mov    rbx,QWORD PTR [rdi+0x8]
   185dee7fd:	48 85 db             	test   rbx,rbx
   185dee800:	74 ee                	je     0x185dee7f0
   185dee802:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   185dee806:	75 e8                	jne    0x185dee7f0
   185dee808:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185dee80b:	48 89 d9             	mov    rcx,rbx
   185dee80e:	ff 10                	call   QWORD PTR [rax]
   185dee810:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   185dee814:	75 da                	jne    0x185dee7f0
   185dee816:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185dee819:	48 89 d9             	mov    rcx,rbx
   185dee81c:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185dee81f:	eb cf                	jmp    0x185dee7f0
   185dee821:	48 8b bd 60 01 00 00 	mov    rdi,QWORD PTR [rbp+0x160]
   185dee828:	48 8b 95 70 01 00 00 	mov    rdx,QWORD PTR [rbp+0x170]
   185dee82f:	48 29 fa             	sub    rdx,rdi
   185dee832:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185dee839:	72 1c                	jb     0x185dee857
   185dee83b:	48 8b 47 f8          	mov    rax,QWORD PTR [rdi-0x8]
   185dee83f:	48 83 c7 f8          	add    rdi,0xfffffffffffffff8
   185dee843:	48 29 c7             	sub    rdi,rax
   185dee846:	48 83 ff 20          	cmp    rdi,0x20
   185dee84a:	0f 83 65 11 00 00    	jae    0x185def9b5
   185dee850:	48 83 c2 27          	add    rdx,0x27
   185dee854:	48 89 c7             	mov    rdi,rax
   185dee857:	48 89 f9             	mov    rcx,rdi
   185dee85a:	e8 81 d0 6b 01       	call   0x1874ab8e0
   185dee85f:	48 8b bd b8 00 00 00 	mov    rdi,QWORD PTR [rbp+0xb8]
   185dee866:	48 85 ff             	test   rdi,rdi
   185dee869:	0f 84 a1 f7 ff ff    	je     0x185dee010
   185dee86f:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   185dee873:	0f 85 97 f7 ff ff    	jne    0x185dee010
   185dee879:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185dee87c:	48 89 f9             	mov    rcx,rdi
   185dee87f:	ff 10                	call   QWORD PTR [rax]
   185dee881:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   185dee885:	0f 85 85 f7 ff ff    	jne    0x185dee010
   185dee88b:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185dee88e:	48 89 f9             	mov    rcx,rdi
   185dee891:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185dee894:	e9 77 f7 ff ff       	jmp    0x185dee010
   185dee899:	4c 8b b5 40 01 00 00 	mov    r14,QWORD PTR [rbp+0x140]
   185dee8a0:	48 8b 95 50 01 00 00 	mov    rdx,QWORD PTR [rbp+0x150]
   185dee8a7:	4c 29 f2             	sub    rdx,r14
   185dee8aa:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185dee8b1:	72 1c                	jb     0x185dee8cf
   185dee8b3:	49 8b 46 f8          	mov    rax,QWORD PTR [r14-0x8]
   185dee8b7:	49 83 c6 f8          	add    r14,0xfffffffffffffff8
   185dee8bb:	49 29 c6             	sub    r14,rax
   185dee8be:	49 83 fe 20          	cmp    r14,0x20
   185dee8c2:	0f 83 ed 10 00 00    	jae    0x185def9b5
   185dee8c8:	48 83 c2 27          	add    rdx,0x27
   185dee8cc:	49 89 c6             	mov    r14,rax
   185dee8cf:	4c 89 f1             	mov    rcx,r14
   185dee8d2:	e8 09 d0 6b 01       	call   0x1874ab8e0
   185dee8d7:	4c 8b b5 60 01 00 00 	mov    r14,QWORD PTR [rbp+0x160]
   185dee8de:	4d 85 f6             	test   r14,r14
   185dee8e1:	0f 84 8a 00 00 00    	je     0x185dee971
   185dee8e7:	48 8b b5 68 01 00 00 	mov    rsi,QWORD PTR [rbp+0x168]
   185dee8ee:	49 39 f6             	cmp    r14,rsi
   185dee8f1:	75 16                	jne    0x185dee909
   185dee8f3:	eb 45                	jmp    0x185dee93a
   185dee8f5:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
   185dee8fc:	00 00 00 00 
   185dee900:	49 83 c6 10          	add    r14,0x10
   185dee904:	49 39 f6             	cmp    r14,rsi
   185dee907:	74 2a                	je     0x185dee933
   185dee909:	4d 8b 7e 08          	mov    r15,QWORD PTR [r14+0x8]
   185dee90d:	4d 85 ff             	test   r15,r15
   185dee910:	74 ee                	je     0x185dee900
   185dee912:	f0 41 ff 4f 08       	lock dec DWORD PTR [r15+0x8]
   185dee917:	75 e7                	jne    0x185dee900
   185dee919:	49 8b 07             	mov    rax,QWORD PTR [r15]
   185dee91c:	4c 89 f9             	mov    rcx,r15
   185dee91f:	ff 10                	call   QWORD PTR [rax]
   185dee921:	f0 41 ff 4f 0c       	lock dec DWORD PTR [r15+0xc]
   185dee926:	75 d8                	jne    0x185dee900
   185dee928:	49 8b 07             	mov    rax,QWORD PTR [r15]
   185dee92b:	4c 89 f9             	mov    rcx,r15
   185dee92e:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185dee931:	eb cd                	jmp    0x185dee900
   185dee933:	4c 8b b5 60 01 00 00 	mov    r14,QWORD PTR [rbp+0x160]
   185dee93a:	48 8b 95 70 01 00 00 	mov    rdx,QWORD PTR [rbp+0x170]
   185dee941:	4c 29 f2             	sub    rdx,r14
   185dee944:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185dee94b:	72 1c                	jb     0x185dee969
   185dee94d:	49 8b 46 f8          	mov    rax,QWORD PTR [r14-0x8]
   185dee951:	49 83 c6 f8          	add    r14,0xfffffffffffffff8
   185dee955:	49 29 c6             	sub    r14,rax
   185dee958:	49 83 fe 20          	cmp    r14,0x20
   185dee95c:	0f 83 53 10 00 00    	jae    0x185def9b5
   185dee962:	48 83 c2 27          	add    rdx,0x27
   185dee966:	49 89 c6             	mov    r14,rax
   185dee969:	4c 89 f1             	mov    rcx,r14
   185dee96c:	e8 6f cf 6b 01       	call   0x1874ab8e0
   185dee971:	48 8b 85 00 01 00 00 	mov    rax,QWORD PTR [rbp+0x100]
   185dee978:	48 3b 85 08 01 00 00 	cmp    rax,QWORD PTR [rbp+0x108]
   185dee97f:	0f 84 c0 00 00 00    	je     0x185deea45
   185dee985:	e8 86 73 25 fa       	call   0x180045d10
   185dee98a:	90                   	nop
   185dee98b:	4c 8b 00             	mov    r8,QWORD PTR [rax]
   185dee98e:	48 8d 95 e0 00 00 00 	lea    rdx,[rbp+0xe0]
   185dee995:	48 89 c1             	mov    rcx,rax
   185dee998:	41 ff 50 60          	call   QWORD PTR [r8+0x60]
   185dee99c:	90                   	nop
   185dee99d:	48 8b 8d e0 00 00 00 	mov    rcx,QWORD PTR [rbp+0xe0]
   185dee9a4:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   185dee9a7:	48 8d 95 20 01 00 00 	lea    rdx,[rbp+0x120]
   185dee9ae:	ff 50 30             	call   QWORD PTR [rax+0x30]
   185dee9b1:	90                   	nop
   185dee9b2:	48 8b 8d 20 01 00 00 	mov    rcx,QWORD PTR [rbp+0x120]
   185dee9b9:	48 8d 05 48 1e 06 03 	lea    rax,[rip+0x3061e48]        # 0x188e50808
   185dee9c0:	48 89 85 a0 00 00 00 	mov    QWORD PTR [rbp+0xa0],rax
   185dee9c7:	0f 29 b5 60 01 00 00 	movaps XMMWORD PTR [rbp+0x160],xmm6
   185dee9ce:	48 8d 95 60 01 00 00 	lea    rdx,[rbp+0x160]
   185dee9d5:	4c 8d 85 a0 00 00 00 	lea    r8,[rbp+0xa0]
   185dee9dc:	e8 9f 00 3b fa       	call   0x18019ea80
   185dee9e1:	90                   	nop
   185dee9e2:	48 8b 85 60 01 00 00 	mov    rax,QWORD PTR [rbp+0x160]
   185dee9e9:	48 8b 8d 68 01 00 00 	mov    rcx,QWORD PTR [rbp+0x168]
   185dee9f0:	48 85 c9             	test   rcx,rcx
   185dee9f3:	0f 84 09 01 00 00    	je     0x185deeb02
   185dee9f9:	f0 ff 41 08          	lock inc DWORD PTR [rcx+0x8]
   185dee9fd:	48 8b bd 68 01 00 00 	mov    rdi,QWORD PTR [rbp+0x168]
   185deea04:	48 89 85 40 01 00 00 	mov    QWORD PTR [rbp+0x140],rax
   185deea0b:	48 89 bd 48 01 00 00 	mov    QWORD PTR [rbp+0x148],rdi
   185deea12:	48 85 ff             	test   rdi,rdi
   185deea15:	0f 84 f9 00 00 00    	je     0x185deeb14
   185deea1b:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   185deea1f:	0f 85 ef 00 00 00    	jne    0x185deeb14
   185deea25:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185deea28:	48 89 f9             	mov    rcx,rdi
   185deea2b:	ff 10                	call   QWORD PTR [rax]
   185deea2d:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   185deea31:	0f 85 dd 00 00 00    	jne    0x185deeb14
   185deea37:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185deea3a:	48 89 f9             	mov    rcx,rdi
   185deea3d:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185deea40:	e9 cf 00 00 00       	jmp    0x185deeb14
   185deea45:	0f 29 b5 e0 00 00 00 	movaps XMMWORD PTR [rbp+0xe0],xmm6
   185deea4c:	49 8b 4d 00          	mov    rcx,QWORD PTR [r13+0x0]
   185deea50:	c7 44 24 20 00 00 00 	mov    DWORD PTR [rsp+0x20],0x0
   185deea57:	00 
   185deea58:	4c 8d 05 61 7a 38 05 	lea    r8,[rip+0x5387a61]        # 0x18b1764c0
   185deea5f:	4c 8d 0d 1a 7e 56 05 	lea    r9,[rip+0x5567e1a]        # 0x18b356880
   185deea66:	31 d2                	xor    edx,edx
   185deea68:	e8 7f 4f 70 01       	call   0x1874f39ec
   185deea6d:	90                   	nop
   185deea6e:	49 89 c6             	mov    r14,rax
   185deea71:	48 85 c0             	test   rax,rax
   185deea74:	74 33                	je     0x185deeaa9
   185deea76:	49 8b 45 08          	mov    rax,QWORD PTR [r13+0x8]
   185deea7a:	48 85 c0             	test   rax,rax
   185deea7d:	0f 84 0e 01 00 00    	je     0x185deeb91
   185deea83:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   185deea87:	49 8b 45 08          	mov    rax,QWORD PTR [r13+0x8]
   185deea8b:	4c 89 b5 e0 00 00 00 	mov    QWORD PTR [rbp+0xe0],r14
   185deea92:	48 89 85 e8 00 00 00 	mov    QWORD PTR [rbp+0xe8],rax
   185deea99:	49 83 be a0 00 00 00 	cmp    QWORD PTR [r14+0xa0],0x0
   185deeaa0:	00 
   185deeaa1:	0f 85 08 01 00 00    	jne    0x185deebaf
   185deeaa7:	eb 0a                	jmp    0x185deeab3
   185deeaa9:	0f 57 c0             	xorps  xmm0,xmm0
   185deeaac:	0f 29 85 e0 00 00 00 	movaps XMMWORD PTR [rbp+0xe0],xmm0
   185deeab3:	48 8b 8d d0 00 00 00 	mov    rcx,QWORD PTR [rbp+0xd0]
   185deeaba:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   185deeabd:	48 3b 41 08          	cmp    rax,QWORD PTR [rcx+0x8]
   185deeac1:	0f 84 18 06 00 00    	je     0x185def0df
   185deeac7:	48 b8 aa aa aa aa aa 	movabs rax,0xaaaaaaaaaaaaaaaa
   185deeace:	aa aa aa 
   185deead1:	48 89 85 70 01 00 00 	mov    QWORD PTR [rbp+0x170],rax
   185deead8:	0f 29 b5 60 01 00 00 	movaps XMMWORD PTR [rbp+0x160],xmm6
   185deeadf:	0f 57 c0             	xorps  xmm0,xmm0
   185deeae2:	0f 29 45 10          	movaps XMMWORD PTR [rbp+0x10],xmm0
   185deeae6:	49 8b 44 24 08       	mov    rax,QWORD PTR [r12+0x8]
   185deeaeb:	48 85 c0             	test   rax,rax
   185deeaee:	0f 84 e7 04 00 00    	je     0x185deefdb
   185deeaf4:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   185deeaf8:	49 8b 44 24 08       	mov    rax,QWORD PTR [r12+0x8]
   185deeafd:	e9 db 04 00 00       	jmp    0x185deefdd
   185deeb02:	48 89 85 40 01 00 00 	mov    QWORD PTR [rbp+0x140],rax
   185deeb09:	48 c7 85 48 01 00 00 	mov    QWORD PTR [rbp+0x148],0x0
   185deeb10:	00 00 00 00 
   185deeb14:	48 8b 9d 08 01 00 00 	mov    rbx,QWORD PTR [rbp+0x108]
   185deeb1b:	48 8b 8d 00 01 00 00 	mov    rcx,QWORD PTR [rbp+0x100]
   185deeb22:	48 89 d8             	mov    rax,rbx
   185deeb25:	48 29 c8             	sub    rax,rcx
   185deeb28:	48 8b bd 40 01 00 00 	mov    rdi,QWORD PTR [rbp+0x140]
   185deeb2f:	0f 57 c0             	xorps  xmm0,xmm0
   185deeb32:	0f 29 85 60 01 00 00 	movaps XMMWORD PTR [rbp+0x160],xmm0
   185deeb39:	48 c7 85 70 01 00 00 	mov    QWORD PTR [rbp+0x170],0x0
   185deeb40:	00 00 00 00 
   185deeb44:	48 29 cb             	sub    rbx,rcx
   185deeb47:	0f 84 a8 01 00 00    	je     0x185deecf5
   185deeb4d:	48 c1 f8 04          	sar    rax,0x4
   185deeb51:	48 89 c1             	mov    rcx,rax
   185deeb54:	48 c1 e9 3c          	shr    rcx,0x3c
   185deeb58:	0f 85 6f 0e 00 00    	jne    0x185def9cd
   185deeb5e:	48 3d 00 01 00 00    	cmp    rax,0x100
   185deeb64:	0f 82 11 01 00 00    	jb     0x185deec7b
   185deeb6a:	48 8d 4b 27          	lea    rcx,[rbx+0x27]
   185deeb6e:	e8 29 cd 6b 01       	call   0x1874ab89c
   185deeb73:	90                   	nop
   185deeb74:	48 85 c0             	test   rax,rax
   185deeb77:	0f 84 38 0e 00 00    	je     0x185def9b5
   185deeb7d:	48 89 c1             	mov    rcx,rax
   185deeb80:	48 83 c0 27          	add    rax,0x27
   185deeb84:	48 83 e0 e0          	and    rax,0xffffffffffffffe0
   185deeb88:	48 89 48 f8          	mov    QWORD PTR [rax-0x8],rcx
   185deeb8c:	e9 f3 00 00 00       	jmp    0x185deec84
   185deeb91:	31 c0                	xor    eax,eax
   185deeb93:	4c 89 b5 e0 00 00 00 	mov    QWORD PTR [rbp+0xe0],r14
   185deeb9a:	48 89 85 e8 00 00 00 	mov    QWORD PTR [rbp+0xe8],rax
   185deeba1:	49 83 be a0 00 00 00 	cmp    QWORD PTR [r14+0xa0],0x0
   185deeba8:	00 
   185deeba9:	0f 84 04 ff ff ff    	je     0x185deeab3
   185deebaf:	0f 29 b5 a0 00 00 00 	movaps XMMWORD PTR [rbp+0xa0],xmm6
   185deebb6:	48 8d 8d a0 00 00 00 	lea    rcx,[rbp+0xa0]
   185deebbd:	e8 9e c7 db fc       	call   0x182bab360
   185deebc2:	90                   	nop
   185deebc3:	4c 89 f2             	mov    rdx,r14
   185deebc6:	48 81 c2 90 00 00 00 	add    rdx,0x90
   185deebcd:	48 8b 8d a0 00 00 00 	mov    rcx,QWORD PTR [rbp+0xa0]
   185deebd4:	48 b8 31 00 00 00 06 	movabs rax,0x600000031
   185deebdb:	00 00 00 
   185deebde:	48 89 81 18 01 00 00 	mov    QWORD PTR [rcx+0x118],rax
   185deebe5:	48 81 c1 20 01 00 00 	add    rcx,0x120
   185deebec:	e8 df c9 2a fa       	call   0x18009b5d0
   185deebf1:	90                   	nop
   185deebf2:	49 8b 06             	mov    rax,QWORD PTR [r14]
   185deebf5:	4c 8d bd 60 01 00 00 	lea    r15,[rbp+0x160]
   185deebfc:	4c 89 f1             	mov    rcx,r14
   185deebff:	4c 89 fa             	mov    rdx,r15
   185deec02:	ff 90 88 00 00 00    	call   QWORD PTR [rax+0x88]
   185deec08:	90                   	nop
   185deec09:	48 8b 85 a0 00 00 00 	mov    rax,QWORD PTR [rbp+0xa0]
   185deec10:	48 8d b0 a8 01 00 00 	lea    rsi,[rax+0x1a8]
   185deec17:	4c 39 fe             	cmp    rsi,r15
   185deec1a:	0f 84 cd 01 00 00    	je     0x185deeded
   185deec20:	48 8b 80 c0 01 00 00 	mov    rax,QWORD PTR [rax+0x1c0]
   185deec27:	48 83 f8 10          	cmp    rax,0x10
   185deec2b:	72 34                	jb     0x185deec61
   185deec2d:	48 8b 0e             	mov    rcx,QWORD PTR [rsi]
   185deec30:	48 8d 50 01          	lea    rdx,[rax+0x1]
   185deec34:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185deec3b:	72 1f                	jb     0x185deec5c
   185deec3d:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   185deec41:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   185deec45:	4c 29 c1             	sub    rcx,r8
   185deec48:	48 83 f9 20          	cmp    rcx,0x20
   185deec4c:	0f 83 63 0d 00 00    	jae    0x185def9b5
   185deec52:	48 83 c0 28          	add    rax,0x28
   185deec56:	48 89 c2             	mov    rdx,rax
   185deec59:	4c 89 c1             	mov    rcx,r8
   185deec5c:	e8 7f cc 6b 01       	call   0x1874ab8e0
   185deec61:	0f 10 85 60 01 00 00 	movups xmm0,XMMWORD PTR [rbp+0x160]
   185deec68:	0f 10 8d 70 01 00 00 	movups xmm1,XMMWORD PTR [rbp+0x170]
   185deec6f:	0f 11 4e 10          	movups XMMWORD PTR [rsi+0x10],xmm1
   185deec73:	0f 11 06             	movups XMMWORD PTR [rsi],xmm0
   185deec76:	e9 b7 01 00 00       	jmp    0x185deee32
   185deec7b:	48 89 d9             	mov    rcx,rbx
   185deec7e:	e8 19 cc 6b 01       	call   0x1874ab89c
   185deec83:	90                   	nop
   185deec84:	48 89 85 60 01 00 00 	mov    QWORD PTR [rbp+0x160],rax
   185deec8b:	48 89 85 68 01 00 00 	mov    QWORD PTR [rbp+0x168],rax
   185deec92:	48 01 c3             	add    rbx,rax
   185deec95:	48 89 9d 70 01 00 00 	mov    QWORD PTR [rbp+0x170],rbx
   185deec9c:	48 8b 8d 00 01 00 00 	mov    rcx,QWORD PTR [rbp+0x100]
   185deeca3:	48 8b 95 08 01 00 00 	mov    rdx,QWORD PTR [rbp+0x108]
   185deecaa:	48 39 d1             	cmp    rcx,rdx
   185deecad:	74 3f                	je     0x185deecee
   185deecaf:	0f 57 c0             	xorps  xmm0,xmm0
   185deecb2:	eb 27                	jmp    0x185deecdb
   185deecb4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
   185deecbb:	00 00 00 00 00 
   185deecc0:	4c 8b 01             	mov    r8,QWORD PTR [rcx]
   185deecc3:	4c 89 00             	mov    QWORD PTR [rax],r8
   185deecc6:	4c 8b 41 08          	mov    r8,QWORD PTR [rcx+0x8]
   185deecca:	4c 89 40 08          	mov    QWORD PTR [rax+0x8],r8
   185deecce:	48 83 c0 10          	add    rax,0x10
   185deecd2:	48 83 c1 10          	add    rcx,0x10
   185deecd6:	48 39 d1             	cmp    rcx,rdx
   185deecd9:	74 13                	je     0x185deecee
   185deecdb:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   185deecde:	4c 8b 41 08          	mov    r8,QWORD PTR [rcx+0x8]
   185deece2:	4d 85 c0             	test   r8,r8
   185deece5:	74 d9                	je     0x185deecc0
   185deece7:	f0 41 ff 40 08       	lock inc DWORD PTR [r8+0x8]
   185deecec:	eb d2                	jmp    0x185deecc0
   185deecee:	48 89 85 68 01 00 00 	mov    QWORD PTR [rbp+0x168],rax
   185deecf5:	4c 8d 85 60 01 00 00 	lea    r8,[rbp+0x160]
   185deecfc:	48 89 f9             	mov    rcx,rdi
   185deecff:	48 8b 95 98 00 00 00 	mov    rdx,QWORD PTR [rbp+0x98]
   185deed06:	e8 e5 62 bb fb       	call   0x1819a4ff0
   185deed0b:	90                   	nop
   185deed0c:	48 8b bd 60 01 00 00 	mov    rdi,QWORD PTR [rbp+0x160]
   185deed13:	48 85 ff             	test   rdi,rdi
   185deed16:	4c 8b a5 20 02 00 00 	mov    r12,QWORD PTR [rbp+0x220]
   185deed1d:	4c 8b ad f8 00 00 00 	mov    r13,QWORD PTR [rbp+0xf8]
   185deed24:	0f 84 85 00 00 00    	je     0x185deedaf
   185deed2a:	48 8b b5 68 01 00 00 	mov    rsi,QWORD PTR [rbp+0x168]
   185deed31:	48 39 f7             	cmp    rdi,rsi
   185deed34:	75 13                	jne    0x185deed49
   185deed36:	eb 40                	jmp    0x185deed78
   185deed38:	0f 1f 84 00 00 00 00 	nop    DWORD PTR [rax+rax*1+0x0]
   185deed3f:	00 
   185deed40:	48 83 c7 10          	add    rdi,0x10
   185deed44:	48 39 f7             	cmp    rdi,rsi
   185deed47:	74 28                	je     0x185deed71
   185deed49:	48 8b 5f 08          	mov    rbx,QWORD PTR [rdi+0x8]
   185deed4d:	48 85 db             	test   rbx,rbx
   185deed50:	74 ee                	je     0x185deed40
   185deed52:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   185deed56:	75 e8                	jne    0x185deed40
   185deed58:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185deed5b:	48 89 d9             	mov    rcx,rbx
   185deed5e:	ff 10                	call   QWORD PTR [rax]
   185deed60:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   185deed64:	75 da                	jne    0x185deed40
   185deed66:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185deed69:	48 89 d9             	mov    rcx,rbx
   185deed6c:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185deed6f:	eb cf                	jmp    0x185deed40
   185deed71:	48 8b bd 60 01 00 00 	mov    rdi,QWORD PTR [rbp+0x160]
   185deed78:	48 8b 95 70 01 00 00 	mov    rdx,QWORD PTR [rbp+0x170]
   185deed7f:	48 29 fa             	sub    rdx,rdi
   185deed82:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185deed89:	72 1c                	jb     0x185deeda7
   185deed8b:	48 8b 47 f8          	mov    rax,QWORD PTR [rdi-0x8]
   185deed8f:	48 83 c7 f8          	add    rdi,0xfffffffffffffff8
   185deed93:	48 29 c7             	sub    rdi,rax
   185deed96:	48 83 ff 20          	cmp    rdi,0x20
   185deed9a:	0f 83 15 0c 00 00    	jae    0x185def9b5
   185deeda0:	48 83 c2 27          	add    rdx,0x27
   185deeda4:	48 89 c7             	mov    rdi,rax
   185deeda7:	48 89 f9             	mov    rcx,rdi
   185deedaa:	e8 31 cb 6b 01       	call   0x1874ab8e0
   185deedaf:	48 8b bd 48 01 00 00 	mov    rdi,QWORD PTR [rbp+0x148]
   185deedb6:	48 85 ff             	test   rdi,rdi
   185deedb9:	74 1d                	je     0x185deedd8
   185deedbb:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   185deedbf:	75 17                	jne    0x185deedd8
   185deedc1:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185deedc4:	48 89 f9             	mov    rcx,rdi
   185deedc7:	ff 10                	call   QWORD PTR [rax]
   185deedc9:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   185deedcd:	75 09                	jne    0x185deedd8
   185deedcf:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185deedd2:	48 89 f9             	mov    rcx,rdi
   185deedd5:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185deedd8:	48 8b bd 28 01 00 00 	mov    rdi,QWORD PTR [rbp+0x128]
   185deeddf:	48 85 ff             	test   rdi,rdi
   185deede2:	0f 85 b5 08 00 00    	jne    0x185def69d
   185deede8:	e9 cd 08 00 00       	jmp    0x185def6ba
   185deeded:	48 8b 85 78 01 00 00 	mov    rax,QWORD PTR [rbp+0x178]
   185deedf4:	48 83 f8 10          	cmp    rax,0x10
   185deedf8:	72 38                	jb     0x185deee32
   185deedfa:	48 8b 8d 60 01 00 00 	mov    rcx,QWORD PTR [rbp+0x160]
   185deee01:	48 8d 50 01          	lea    rdx,[rax+0x1]
   185deee05:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185deee0c:	72 1f                	jb     0x185deee2d
   185deee0e:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   185deee12:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   185deee16:	4c 29 c1             	sub    rcx,r8
   185deee19:	48 83 f9 20          	cmp    rcx,0x20
   185deee1d:	0f 83 92 0b 00 00    	jae    0x185def9b5
   185deee23:	48 83 c0 28          	add    rax,0x28
   185deee27:	48 89 c2             	mov    rdx,rax
   185deee2a:	4c 89 c1             	mov    rcx,r8
   185deee2d:	e8 ae ca 6b 01       	call   0x1874ab8e0
   185deee32:	0f 57 c0             	xorps  xmm0,xmm0
   185deee35:	0f 29 85 60 01 00 00 	movaps XMMWORD PTR [rbp+0x160],xmm0
   185deee3c:	48 c7 85 70 01 00 00 	mov    QWORD PTR [rbp+0x170],0x0
   185deee43:	00 00 00 00 
   185deee47:	48 8d 8d 60 01 00 00 	lea    rcx,[rbp+0x160]
   185deee4e:	4c 8d 85 a0 00 00 00 	lea    r8,[rbp+0xa0]
   185deee55:	31 d2                	xor    edx,edx
   185deee57:	e8 a4 2a 3e fa       	call   0x1801d1900
   185deee5c:	90                   	nop
   185deee5d:	48 b8 aa aa aa aa aa 	movabs rax,0xaaaaaaaaaaaaaaaa
   185deee64:	aa aa aa 
   185deee67:	48 89 85 50 01 00 00 	mov    QWORD PTR [rbp+0x150],rax
   185deee6e:	0f 29 b5 40 01 00 00 	movaps XMMWORD PTR [rbp+0x140],xmm6
   185deee75:	48 8d 8d 40 01 00 00 	lea    rcx,[rbp+0x140]
   185deee7c:	48 8d 95 60 01 00 00 	lea    rdx,[rbp+0x160]
   185deee83:	4c 8b 85 d8 00 00 00 	mov    r8,QWORD PTR [rbp+0xd8]
   185deee8a:	4c 8b 8d d0 00 00 00 	mov    r9,QWORD PTR [rbp+0xd0]
   185deee91:	e8 4a 7d b2 fe       	call   0x184916be0
   185deee96:	90                   	nop
   185deee97:	4c 8b 85 40 01 00 00 	mov    r8,QWORD PTR [rbp+0x140]
   185deee9e:	4c 8b 8d 48 01 00 00 	mov    r9,QWORD PTR [rbp+0x148]
   185deeea5:	48 8b 95 08 01 00 00 	mov    rdx,QWORD PTR [rbp+0x108]
   185deeeac:	4d 29 c1             	sub    r9,r8
   185deeeaf:	49 c1 f9 04          	sar    r9,0x4
   185deeeb3:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   185deeeba:	e8 21 bb 2d fb       	call   0x1810ca9e0
   185deeebf:	90                   	nop
   185deeec0:	e8 4b 6e 25 fa       	call   0x180045d10
   185deeec5:	90                   	nop
   185deeec6:	4c 8b 00             	mov    r8,QWORD PTR [rax]
   185deeec9:	48 8d 55 d0          	lea    rdx,[rbp-0x30]
   185deeecd:	48 89 c1             	mov    rcx,rax
   185deeed0:	41 ff 50 60          	call   QWORD PTR [r8+0x60]
   185deeed4:	90                   	nop
   185deeed5:	48 8b 4d d0          	mov    rcx,QWORD PTR [rbp-0x30]
   185deeed9:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   185deeedc:	48 8d 55 28          	lea    rdx,[rbp+0x28]
   185deeee0:	ff 50 30             	call   QWORD PTR [rax+0x30]
   185deeee3:	90                   	nop
   185deeee4:	48 8b 4d 28          	mov    rcx,QWORD PTR [rbp+0x28]
   185deeee8:	48 8d 05 19 19 06 03 	lea    rax,[rip+0x3061919]        # 0x188e50808
   185deeeef:	48 89 45 c8          	mov    QWORD PTR [rbp-0x38],rax
   185deeef3:	0f 29 b5 20 01 00 00 	movaps XMMWORD PTR [rbp+0x120],xmm6
   185deeefa:	48 8d 95 20 01 00 00 	lea    rdx,[rbp+0x120]
   185deef01:	4c 8d 45 c8          	lea    r8,[rbp-0x38]
   185deef05:	e8 76 fb 3a fa       	call   0x18019ea80
   185deef0a:	90                   	nop
   185deef0b:	48 8b 85 20 01 00 00 	mov    rax,QWORD PTR [rbp+0x120]
   185deef12:	48 8b 8d 28 01 00 00 	mov    rcx,QWORD PTR [rbp+0x128]
   185deef19:	48 85 c9             	test   rcx,rcx
   185deef1c:	74 37                	je     0x185deef55
   185deef1e:	f0 ff 41 08          	lock inc DWORD PTR [rcx+0x8]
   185deef22:	48 8b bd 28 01 00 00 	mov    rdi,QWORD PTR [rbp+0x128]
   185deef29:	48 89 45 70          	mov    QWORD PTR [rbp+0x70],rax
   185deef2d:	48 89 7d 78          	mov    QWORD PTR [rbp+0x78],rdi
   185deef31:	48 85 ff             	test   rdi,rdi
   185deef34:	74 2b                	je     0x185deef61
   185deef36:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   185deef3a:	75 25                	jne    0x185deef61
   185deef3c:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185deef3f:	48 89 f9             	mov    rcx,rdi
   185deef42:	ff 10                	call   QWORD PTR [rax]
   185deef44:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   185deef48:	75 17                	jne    0x185deef61
   185deef4a:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185deef4d:	48 89 f9             	mov    rcx,rdi
   185deef50:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185deef53:	eb 0c                	jmp    0x185deef61
   185deef55:	48 89 45 70          	mov    QWORD PTR [rbp+0x70],rax
   185deef59:	48 c7 45 78 00 00 00 	mov    QWORD PTR [rbp+0x78],0x0
   185deef60:	00 
   185deef61:	48 8b 9d 08 01 00 00 	mov    rbx,QWORD PTR [rbp+0x108]
   185deef68:	48 8b 8d 00 01 00 00 	mov    rcx,QWORD PTR [rbp+0x100]
   185deef6f:	48 89 d8             	mov    rax,rbx
   185deef72:	48 29 c8             	sub    rax,rcx
   185deef75:	48 8b 7d 70          	mov    rdi,QWORD PTR [rbp+0x70]
   185deef79:	0f 57 c0             	xorps  xmm0,xmm0
   185deef7c:	0f 29 85 20 01 00 00 	movaps XMMWORD PTR [rbp+0x120],xmm0
   185deef83:	48 c7 85 30 01 00 00 	mov    QWORD PTR [rbp+0x130],0x0
   185deef8a:	00 00 00 00 
   185deef8e:	48 29 cb             	sub    rbx,rcx
   185deef91:	0f 84 2e 03 00 00    	je     0x185def2c5
   185deef97:	48 c1 f8 04          	sar    rax,0x4
   185deef9b:	48 89 c1             	mov    rcx,rax
   185deef9e:	48 c1 e9 3c          	shr    rcx,0x3c
   185deefa2:	0f 85 2b 0a 00 00    	jne    0x185def9d3
   185deefa8:	48 3d 00 01 00 00    	cmp    rax,0x100
   185deefae:	0f 82 9e 02 00 00    	jb     0x185def252
   185deefb4:	48 8d 4b 27          	lea    rcx,[rbx+0x27]
   185deefb8:	e8 df c8 6b 01       	call   0x1874ab89c
   185deefbd:	90                   	nop
   185deefbe:	48 85 c0             	test   rax,rax
   185deefc1:	0f 84 ee 09 00 00    	je     0x185def9b5
   185deefc7:	48 89 c1             	mov    rcx,rax
   185deefca:	48 83 c0 27          	add    rax,0x27
   185deefce:	48 83 e0 e0          	and    rax,0xffffffffffffffe0
   185deefd2:	48 89 48 f8          	mov    QWORD PTR [rax-0x8],rcx
   185deefd6:	e9 80 02 00 00       	jmp    0x185def25b
   185deefdb:	31 c0                	xor    eax,eax
   185deefdd:	49 8b 0c 24          	mov    rcx,QWORD PTR [r12]
   185deefe1:	48 89 4d 10          	mov    QWORD PTR [rbp+0x10],rcx
   185deefe5:	48 89 45 18          	mov    QWORD PTR [rbp+0x18],rax
   185deefe9:	48 8d 45 10          	lea    rax,[rbp+0x10]
   185deefed:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   185deeff2:	48 8d 8d 60 01 00 00 	lea    rcx,[rbp+0x160]
   185deeff9:	48 8d 95 80 00 00 00 	lea    rdx,[rbp+0x80]
   185def000:	4c 8b 85 d8 00 00 00 	mov    r8,QWORD PTR [rbp+0xd8]
   185def007:	4c 8b 8d d0 00 00 00 	mov    r9,QWORD PTR [rbp+0xd0]
   185def00e:	e8 2d 97 b2 fe       	call   0x184918740
   185def013:	90                   	nop
   185def014:	4c 8b 85 60 01 00 00 	mov    r8,QWORD PTR [rbp+0x160]
   185def01b:	4c 8b 8d 68 01 00 00 	mov    r9,QWORD PTR [rbp+0x168]
   185def022:	48 8b 95 08 01 00 00 	mov    rdx,QWORD PTR [rbp+0x108]
   185def029:	4d 29 c1             	sub    r9,r8
   185def02c:	49 c1 f9 04          	sar    r9,0x4
   185def030:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   185def037:	e8 a4 b9 2d fb       	call   0x1810ca9e0
   185def03c:	90                   	nop
   185def03d:	48 8b bd 60 01 00 00 	mov    rdi,QWORD PTR [rbp+0x160]
   185def044:	48 85 ff             	test   rdi,rdi
   185def047:	4c 8b a5 20 02 00 00 	mov    r12,QWORD PTR [rbp+0x220]
   185def04e:	4c 8b ad f8 00 00 00 	mov    r13,QWORD PTR [rbp+0xf8]
   185def055:	0f 84 84 00 00 00    	je     0x185def0df
   185def05b:	48 8b b5 68 01 00 00 	mov    rsi,QWORD PTR [rbp+0x168]
   185def062:	48 39 f7             	cmp    rdi,rsi
   185def065:	75 12                	jne    0x185def079
   185def067:	eb 3f                	jmp    0x185def0a8
   185def069:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
   185def070:	48 83 c7 10          	add    rdi,0x10
   185def074:	48 39 f7             	cmp    rdi,rsi
   185def077:	74 28                	je     0x185def0a1
   185def079:	48 8b 5f 08          	mov    rbx,QWORD PTR [rdi+0x8]
   185def07d:	48 85 db             	test   rbx,rbx
   185def080:	74 ee                	je     0x185def070
   185def082:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   185def086:	75 e8                	jne    0x185def070
   185def088:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185def08b:	48 89 d9             	mov    rcx,rbx
   185def08e:	ff 10                	call   QWORD PTR [rax]
   185def090:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   185def094:	75 da                	jne    0x185def070
   185def096:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185def099:	48 89 d9             	mov    rcx,rbx
   185def09c:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185def09f:	eb cf                	jmp    0x185def070
   185def0a1:	48 8b bd 60 01 00 00 	mov    rdi,QWORD PTR [rbp+0x160]
   185def0a8:	48 8b 95 70 01 00 00 	mov    rdx,QWORD PTR [rbp+0x170]
   185def0af:	48 29 fa             	sub    rdx,rdi
   185def0b2:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185def0b9:	72 1c                	jb     0x185def0d7
   185def0bb:	48 8b 47 f8          	mov    rax,QWORD PTR [rdi-0x8]
   185def0bf:	48 83 c7 f8          	add    rdi,0xfffffffffffffff8
   185def0c3:	48 29 c7             	sub    rdi,rax
   185def0c6:	48 83 ff 20          	cmp    rdi,0x20
   185def0ca:	0f 83 e5 08 00 00    	jae    0x185def9b5
   185def0d0:	48 83 c2 27          	add    rdx,0x27
   185def0d4:	48 89 c7             	mov    rdi,rax
   185def0d7:	48 89 f9             	mov    rcx,rdi
   185def0da:	e8 01 c8 6b 01       	call   0x1874ab8e0
   185def0df:	48 8b 85 00 01 00 00 	mov    rax,QWORD PTR [rbp+0x100]
   185def0e6:	48 3b 85 08 01 00 00 	cmp    rax,QWORD PTR [rbp+0x108]
   185def0ed:	0f 84 a7 00 00 00    	je     0x185def19a
   185def0f3:	e8 18 6c 25 fa       	call   0x180045d10
   185def0f8:	90                   	nop
   185def0f9:	4c 8b 00             	mov    r8,QWORD PTR [rax]
   185def0fc:	48 8d 95 a0 00 00 00 	lea    rdx,[rbp+0xa0]
   185def103:	48 89 c1             	mov    rcx,rax
   185def106:	41 ff 50 60          	call   QWORD PTR [r8+0x60]
   185def10a:	90                   	nop
   185def10b:	48 8b 8d a0 00 00 00 	mov    rcx,QWORD PTR [rbp+0xa0]
   185def112:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   185def115:	48 8d 95 20 01 00 00 	lea    rdx,[rbp+0x120]
   185def11c:	ff 50 30             	call   QWORD PTR [rax+0x30]
   185def11f:	90                   	nop
   185def120:	48 8b 8d 20 01 00 00 	mov    rcx,QWORD PTR [rbp+0x120]
   185def127:	48 8d 05 da 16 06 03 	lea    rax,[rip+0x30616da]        # 0x188e50808
   185def12e:	48 89 45 70          	mov    QWORD PTR [rbp+0x70],rax
   185def132:	0f 29 b5 60 01 00 00 	movaps XMMWORD PTR [rbp+0x160],xmm6
   185def139:	48 8d 95 60 01 00 00 	lea    rdx,[rbp+0x160]
   185def140:	4c 8d 45 70          	lea    r8,[rbp+0x70]
   185def144:	e8 37 f9 3a fa       	call   0x18019ea80
   185def149:	90                   	nop
   185def14a:	48 8b 85 60 01 00 00 	mov    rax,QWORD PTR [rbp+0x160]
   185def151:	48 8b 8d 68 01 00 00 	mov    rcx,QWORD PTR [rbp+0x168]
   185def158:	48 85 c9             	test   rcx,rcx
   185def15b:	74 66                	je     0x185def1c3
   185def15d:	f0 ff 41 08          	lock inc DWORD PTR [rcx+0x8]
   185def161:	48 8b bd 68 01 00 00 	mov    rdi,QWORD PTR [rbp+0x168]
   185def168:	48 89 85 40 01 00 00 	mov    QWORD PTR [rbp+0x140],rax
   185def16f:	48 89 bd 48 01 00 00 	mov    QWORD PTR [rbp+0x148],rdi
   185def176:	48 85 ff             	test   rdi,rdi
   185def179:	74 5a                	je     0x185def1d5
   185def17b:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   185def17f:	75 54                	jne    0x185def1d5
   185def181:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185def184:	48 89 f9             	mov    rcx,rdi
   185def187:	ff 10                	call   QWORD PTR [rax]
   185def189:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   185def18d:	75 46                	jne    0x185def1d5
   185def18f:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185def192:	48 89 f9             	mov    rcx,rdi
   185def195:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185def198:	eb 3b                	jmp    0x185def1d5
   185def19a:	48 8d 05 17 b9 b4 03 	lea    rax,[rip+0x3b4b917]        # 0x18993aab8
   185def1a1:	48 8b 8d 98 00 00 00 	mov    rcx,QWORD PTR [rbp+0x98]
   185def1a8:	48 89 01             	mov    QWORD PTR [rcx],rax
   185def1ab:	48 89 49 38          	mov    QWORD PTR [rcx+0x38],rcx
   185def1af:	0f 57 c0             	xorps  xmm0,xmm0
   185def1b2:	0f 11 41 40          	movups XMMWORD PTR [rcx+0x40],xmm0
   185def1b6:	48 c7 41 50 00 00 00 	mov    QWORD PTR [rcx+0x50],0x0
   185def1bd:	00 
   185def1be:	e9 f7 04 00 00       	jmp    0x185def6ba
   185def1c3:	48 89 85 40 01 00 00 	mov    QWORD PTR [rbp+0x140],rax
   185def1ca:	48 c7 85 48 01 00 00 	mov    QWORD PTR [rbp+0x148],0x0
   185def1d1:	00 00 00 00 
   185def1d5:	48 8b 9d 08 01 00 00 	mov    rbx,QWORD PTR [rbp+0x108]
   185def1dc:	48 8b 8d 00 01 00 00 	mov    rcx,QWORD PTR [rbp+0x100]
   185def1e3:	48 89 d8             	mov    rax,rbx
   185def1e6:	48 29 c8             	sub    rax,rcx
   185def1e9:	48 8b bd 40 01 00 00 	mov    rdi,QWORD PTR [rbp+0x140]
   185def1f0:	0f 57 c0             	xorps  xmm0,xmm0
   185def1f3:	0f 29 85 60 01 00 00 	movaps XMMWORD PTR [rbp+0x160],xmm0
   185def1fa:	48 c7 85 70 01 00 00 	mov    QWORD PTR [rbp+0x170],0x0
   185def201:	00 00 00 00 
   185def205:	48 29 cb             	sub    rbx,rcx
   185def208:	0f 84 77 03 00 00    	je     0x185def585
   185def20e:	48 c1 f8 04          	sar    rax,0x4
   185def212:	48 89 c1             	mov    rcx,rax
   185def215:	48 c1 e9 3c          	shr    rcx,0x3c
   185def219:	0f 85 ba 07 00 00    	jne    0x185def9d9
   185def21f:	48 3d 00 01 00 00    	cmp    rax,0x100
   185def225:	0f 82 e9 02 00 00    	jb     0x185def514
   185def22b:	48 8d 4b 27          	lea    rcx,[rbx+0x27]
   185def22f:	e8 68 c6 6b 01       	call   0x1874ab89c
   185def234:	90                   	nop
   185def235:	48 85 c0             	test   rax,rax
   185def238:	0f 84 77 07 00 00    	je     0x185def9b5
   185def23e:	48 89 c1             	mov    rcx,rax
   185def241:	48 83 c0 27          	add    rax,0x27
   185def245:	48 83 e0 e0          	and    rax,0xffffffffffffffe0
   185def249:	48 89 48 f8          	mov    QWORD PTR [rax-0x8],rcx
   185def24d:	e9 cb 02 00 00       	jmp    0x185def51d
   185def252:	48 89 d9             	mov    rcx,rbx
   185def255:	e8 42 c6 6b 01       	call   0x1874ab89c
   185def25a:	90                   	nop
   185def25b:	48 89 85 20 01 00 00 	mov    QWORD PTR [rbp+0x120],rax
   185def262:	48 89 85 28 01 00 00 	mov    QWORD PTR [rbp+0x128],rax
   185def269:	48 01 c3             	add    rbx,rax
   185def26c:	48 89 9d 30 01 00 00 	mov    QWORD PTR [rbp+0x130],rbx
   185def273:	48 8b 8d 00 01 00 00 	mov    rcx,QWORD PTR [rbp+0x100]
   185def27a:	48 8b 95 08 01 00 00 	mov    rdx,QWORD PTR [rbp+0x108]
   185def281:	48 39 d1             	cmp    rcx,rdx
   185def284:	74 38                	je     0x185def2be
   185def286:	0f 57 c0             	xorps  xmm0,xmm0
   185def289:	eb 20                	jmp    0x185def2ab
   185def28b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]
   185def290:	4c 8b 01             	mov    r8,QWORD PTR [rcx]
   185def293:	4c 89 00             	mov    QWORD PTR [rax],r8
   185def296:	4c 8b 41 08          	mov    r8,QWORD PTR [rcx+0x8]
   185def29a:	4c 89 40 08          	mov    QWORD PTR [rax+0x8],r8
   185def29e:	48 83 c0 10          	add    rax,0x10
   185def2a2:	48 83 c1 10          	add    rcx,0x10
   185def2a6:	48 39 d1             	cmp    rcx,rdx
   185def2a9:	74 13                	je     0x185def2be
   185def2ab:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   185def2ae:	4c 8b 41 08          	mov    r8,QWORD PTR [rcx+0x8]
   185def2b2:	4d 85 c0             	test   r8,r8
   185def2b5:	74 d9                	je     0x185def290
   185def2b7:	f0 41 ff 40 08       	lock inc DWORD PTR [r8+0x8]
   185def2bc:	eb d2                	jmp    0x185def290
   185def2be:	48 89 85 28 01 00 00 	mov    QWORD PTR [rbp+0x128],rax
   185def2c5:	4c 8d 85 20 01 00 00 	lea    r8,[rbp+0x120]
   185def2cc:	48 89 f9             	mov    rcx,rdi
   185def2cf:	48 8b 95 98 00 00 00 	mov    rdx,QWORD PTR [rbp+0x98]
   185def2d6:	e8 15 5d bb fb       	call   0x1819a4ff0
   185def2db:	90                   	nop
   185def2dc:	48 8b bd 20 01 00 00 	mov    rdi,QWORD PTR [rbp+0x120]
   185def2e3:	48 85 ff             	test   rdi,rdi
   185def2e6:	4c 8b a5 20 02 00 00 	mov    r12,QWORD PTR [rbp+0x220]
   185def2ed:	4c 8b ad f8 00 00 00 	mov    r13,QWORD PTR [rbp+0xf8]
   185def2f4:	0f 84 85 00 00 00    	je     0x185def37f
   185def2fa:	48 8b b5 28 01 00 00 	mov    rsi,QWORD PTR [rbp+0x128]
   185def301:	48 39 f7             	cmp    rdi,rsi
   185def304:	75 13                	jne    0x185def319
   185def306:	eb 40                	jmp    0x185def348
   185def308:	0f 1f 84 00 00 00 00 	nop    DWORD PTR [rax+rax*1+0x0]
   185def30f:	00 
   185def310:	48 83 c7 10          	add    rdi,0x10
   185def314:	48 39 f7             	cmp    rdi,rsi
   185def317:	74 28                	je     0x185def341
   185def319:	48 8b 5f 08          	mov    rbx,QWORD PTR [rdi+0x8]
   185def31d:	48 85 db             	test   rbx,rbx
   185def320:	74 ee                	je     0x185def310
   185def322:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   185def326:	75 e8                	jne    0x185def310
   185def328:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185def32b:	48 89 d9             	mov    rcx,rbx
   185def32e:	ff 10                	call   QWORD PTR [rax]
   185def330:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   185def334:	75 da                	jne    0x185def310
   185def336:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185def339:	48 89 d9             	mov    rcx,rbx
   185def33c:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185def33f:	eb cf                	jmp    0x185def310
   185def341:	48 8b bd 20 01 00 00 	mov    rdi,QWORD PTR [rbp+0x120]
   185def348:	48 8b 95 30 01 00 00 	mov    rdx,QWORD PTR [rbp+0x130]
   185def34f:	48 29 fa             	sub    rdx,rdi
   185def352:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185def359:	72 1c                	jb     0x185def377
   185def35b:	48 8b 47 f8          	mov    rax,QWORD PTR [rdi-0x8]
   185def35f:	48 83 c7 f8          	add    rdi,0xfffffffffffffff8
   185def363:	48 29 c7             	sub    rdi,rax
   185def366:	48 83 ff 20          	cmp    rdi,0x20
   185def36a:	0f 83 45 06 00 00    	jae    0x185def9b5
   185def370:	48 83 c2 27          	add    rdx,0x27
   185def374:	48 89 c7             	mov    rdi,rax
   185def377:	48 89 f9             	mov    rcx,rdi
   185def37a:	e8 61 c5 6b 01       	call   0x1874ab8e0
   185def37f:	48 8b 7d 78          	mov    rdi,QWORD PTR [rbp+0x78]
   185def383:	48 85 ff             	test   rdi,rdi
   185def386:	74 1d                	je     0x185def3a5
   185def388:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   185def38c:	75 17                	jne    0x185def3a5
   185def38e:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185def391:	48 89 f9             	mov    rcx,rdi
   185def394:	ff 10                	call   QWORD PTR [rax]
   185def396:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   185def39a:	75 09                	jne    0x185def3a5
   185def39c:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185def39f:	48 89 f9             	mov    rcx,rdi
   185def3a2:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185def3a5:	48 8b 7d 30          	mov    rdi,QWORD PTR [rbp+0x30]
   185def3a9:	48 85 ff             	test   rdi,rdi
   185def3ac:	74 1d                	je     0x185def3cb
   185def3ae:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   185def3b2:	75 17                	jne    0x185def3cb
   185def3b4:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185def3b7:	48 89 f9             	mov    rcx,rdi
   185def3ba:	ff 10                	call   QWORD PTR [rax]
   185def3bc:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   185def3c0:	75 09                	jne    0x185def3cb
   185def3c2:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185def3c5:	48 89 f9             	mov    rcx,rdi
   185def3c8:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185def3cb:	48 8b 7d d8          	mov    rdi,QWORD PTR [rbp-0x28]
   185def3cf:	48 85 ff             	test   rdi,rdi
   185def3d2:	74 1d                	je     0x185def3f1
   185def3d4:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   185def3d8:	75 17                	jne    0x185def3f1
   185def3da:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185def3dd:	48 89 f9             	mov    rcx,rdi
   185def3e0:	ff 10                	call   QWORD PTR [rax]
   185def3e2:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   185def3e6:	75 09                	jne    0x185def3f1
   185def3e8:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185def3eb:	48 89 f9             	mov    rcx,rdi
   185def3ee:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185def3f1:	48 8b bd 40 01 00 00 	mov    rdi,QWORD PTR [rbp+0x140]
   185def3f8:	48 85 ff             	test   rdi,rdi
   185def3fb:	0f 84 7e 00 00 00    	je     0x185def47f
   185def401:	48 8b b5 48 01 00 00 	mov    rsi,QWORD PTR [rbp+0x148]
   185def408:	48 39 f7             	cmp    rdi,rsi
   185def40b:	75 0c                	jne    0x185def419
   185def40d:	eb 39                	jmp    0x185def448
   185def40f:	90                   	nop
   185def410:	48 83 c7 10          	add    rdi,0x10
   185def414:	48 39 f7             	cmp    rdi,rsi
   185def417:	74 28                	je     0x185def441
   185def419:	48 8b 5f 08          	mov    rbx,QWORD PTR [rdi+0x8]
   185def41d:	48 85 db             	test   rbx,rbx
   185def420:	74 ee                	je     0x185def410
   185def422:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   185def426:	75 e8                	jne    0x185def410
   185def428:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185def42b:	48 89 d9             	mov    rcx,rbx
   185def42e:	ff 10                	call   QWORD PTR [rax]
   185def430:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   185def434:	75 da                	jne    0x185def410
   185def436:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185def439:	48 89 d9             	mov    rcx,rbx
   185def43c:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185def43f:	eb cf                	jmp    0x185def410
   185def441:	48 8b bd 40 01 00 00 	mov    rdi,QWORD PTR [rbp+0x140]
   185def448:	48 8b 95 50 01 00 00 	mov    rdx,QWORD PTR [rbp+0x150]
   185def44f:	48 29 fa             	sub    rdx,rdi
   185def452:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185def459:	72 1c                	jb     0x185def477
   185def45b:	48 8b 47 f8          	mov    rax,QWORD PTR [rdi-0x8]
   185def45f:	48 83 c7 f8          	add    rdi,0xfffffffffffffff8
   185def463:	48 29 c7             	sub    rdi,rax
   185def466:	48 83 ff 20          	cmp    rdi,0x20
   185def46a:	0f 83 45 05 00 00    	jae    0x185def9b5
   185def470:	48 83 c2 27          	add    rdx,0x27
   185def474:	48 89 c7             	mov    rdi,rax
   185def477:	48 89 f9             	mov    rcx,rdi
   185def47a:	e8 61 c4 6b 01       	call   0x1874ab8e0
   185def47f:	48 8b bd 60 01 00 00 	mov    rdi,QWORD PTR [rbp+0x160]
   185def486:	48 85 ff             	test   rdi,rdi
   185def489:	0f 84 02 02 00 00    	je     0x185def691
   185def48f:	48 8b b5 68 01 00 00 	mov    rsi,QWORD PTR [rbp+0x168]
   185def496:	48 39 f7             	cmp    rdi,rsi
   185def499:	75 0e                	jne    0x185def4a9
   185def49b:	eb 3b                	jmp    0x185def4d8
   185def49d:	0f 1f 00             	nop    DWORD PTR [rax]
   185def4a0:	48 83 c7 10          	add    rdi,0x10
   185def4a4:	48 39 f7             	cmp    rdi,rsi
   185def4a7:	74 28                	je     0x185def4d1
   185def4a9:	48 8b 5f 08          	mov    rbx,QWORD PTR [rdi+0x8]
   185def4ad:	48 85 db             	test   rbx,rbx
   185def4b0:	74 ee                	je     0x185def4a0
   185def4b2:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   185def4b6:	75 e8                	jne    0x185def4a0
   185def4b8:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185def4bb:	48 89 d9             	mov    rcx,rbx
   185def4be:	ff 10                	call   QWORD PTR [rax]
   185def4c0:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   185def4c4:	75 da                	jne    0x185def4a0
   185def4c6:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185def4c9:	48 89 d9             	mov    rcx,rbx
   185def4cc:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185def4cf:	eb cf                	jmp    0x185def4a0
   185def4d1:	48 8b bd 60 01 00 00 	mov    rdi,QWORD PTR [rbp+0x160]
   185def4d8:	48 8b 95 70 01 00 00 	mov    rdx,QWORD PTR [rbp+0x170]
   185def4df:	48 29 fa             	sub    rdx,rdi
   185def4e2:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185def4e9:	72 1c                	jb     0x185def507
   185def4eb:	48 8b 47 f8          	mov    rax,QWORD PTR [rdi-0x8]
   185def4ef:	48 83 c7 f8          	add    rdi,0xfffffffffffffff8
   185def4f3:	48 29 c7             	sub    rdi,rax
   185def4f6:	48 83 ff 20          	cmp    rdi,0x20
   185def4fa:	0f 83 b5 04 00 00    	jae    0x185def9b5
   185def500:	48 83 c2 27          	add    rdx,0x27
   185def504:	48 89 c7             	mov    rdi,rax
   185def507:	48 89 f9             	mov    rcx,rdi
   185def50a:	e8 d1 c3 6b 01       	call   0x1874ab8e0
   185def50f:	e9 7d 01 00 00       	jmp    0x185def691
   185def514:	48 89 d9             	mov    rcx,rbx
   185def517:	e8 80 c3 6b 01       	call   0x1874ab89c
   185def51c:	90                   	nop
   185def51d:	48 89 85 60 01 00 00 	mov    QWORD PTR [rbp+0x160],rax
   185def524:	48 89 85 68 01 00 00 	mov    QWORD PTR [rbp+0x168],rax
   185def52b:	48 01 c3             	add    rbx,rax
   185def52e:	48 89 9d 70 01 00 00 	mov    QWORD PTR [rbp+0x170],rbx
   185def535:	48 8b 8d 00 01 00 00 	mov    rcx,QWORD PTR [rbp+0x100]
   185def53c:	48 8b 95 08 01 00 00 	mov    rdx,QWORD PTR [rbp+0x108]
   185def543:	48 39 d1             	cmp    rcx,rdx
   185def546:	74 36                	je     0x185def57e
   185def548:	0f 57 c0             	xorps  xmm0,xmm0
   185def54b:	eb 1e                	jmp    0x185def56b
   185def54d:	0f 1f 00             	nop    DWORD PTR [rax]
   185def550:	4c 8b 01             	mov    r8,QWORD PTR [rcx]
   185def553:	4c 89 00             	mov    QWORD PTR [rax],r8
   185def556:	4c 8b 41 08          	mov    r8,QWORD PTR [rcx+0x8]
   185def55a:	4c 89 40 08          	mov    QWORD PTR [rax+0x8],r8
   185def55e:	48 83 c0 10          	add    rax,0x10
   185def562:	48 83 c1 10          	add    rcx,0x10
   185def566:	48 39 d1             	cmp    rcx,rdx
   185def569:	74 13                	je     0x185def57e
   185def56b:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   185def56e:	4c 8b 41 08          	mov    r8,QWORD PTR [rcx+0x8]
   185def572:	4d 85 c0             	test   r8,r8
   185def575:	74 d9                	je     0x185def550
   185def577:	f0 41 ff 40 08       	lock inc DWORD PTR [r8+0x8]
   185def57c:	eb d2                	jmp    0x185def550
   185def57e:	48 89 85 68 01 00 00 	mov    QWORD PTR [rbp+0x168],rax
   185def585:	4c 8d 85 60 01 00 00 	lea    r8,[rbp+0x160]
   185def58c:	48 89 f9             	mov    rcx,rdi
   185def58f:	48 8b 95 98 00 00 00 	mov    rdx,QWORD PTR [rbp+0x98]
   185def596:	e8 55 5a bb fb       	call   0x1819a4ff0
   185def59b:	90                   	nop
   185def59c:	48 8b bd 60 01 00 00 	mov    rdi,QWORD PTR [rbp+0x160]
   185def5a3:	48 85 ff             	test   rdi,rdi
   185def5a6:	4c 8b a5 20 02 00 00 	mov    r12,QWORD PTR [rbp+0x220]
   185def5ad:	4c 8b ad f8 00 00 00 	mov    r13,QWORD PTR [rbp+0xf8]
   185def5b4:	0f 84 85 00 00 00    	je     0x185def63f
   185def5ba:	48 8b b5 68 01 00 00 	mov    rsi,QWORD PTR [rbp+0x168]
   185def5c1:	48 39 f7             	cmp    rdi,rsi
   185def5c4:	75 13                	jne    0x185def5d9
   185def5c6:	eb 40                	jmp    0x185def608
   185def5c8:	0f 1f 84 00 00 00 00 	nop    DWORD PTR [rax+rax*1+0x0]
   185def5cf:	00 
   185def5d0:	48 83 c7 10          	add    rdi,0x10
   185def5d4:	48 39 f7             	cmp    rdi,rsi
   185def5d7:	74 28                	je     0x185def601
   185def5d9:	48 8b 5f 08          	mov    rbx,QWORD PTR [rdi+0x8]
   185def5dd:	48 85 db             	test   rbx,rbx
   185def5e0:	74 ee                	je     0x185def5d0
   185def5e2:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   185def5e6:	75 e8                	jne    0x185def5d0
   185def5e8:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185def5eb:	48 89 d9             	mov    rcx,rbx
   185def5ee:	ff 10                	call   QWORD PTR [rax]
   185def5f0:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   185def5f4:	75 da                	jne    0x185def5d0
   185def5f6:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185def5f9:	48 89 d9             	mov    rcx,rbx
   185def5fc:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185def5ff:	eb cf                	jmp    0x185def5d0
   185def601:	48 8b bd 60 01 00 00 	mov    rdi,QWORD PTR [rbp+0x160]
   185def608:	48 8b 95 70 01 00 00 	mov    rdx,QWORD PTR [rbp+0x170]
   185def60f:	48 29 fa             	sub    rdx,rdi
   185def612:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185def619:	72 1c                	jb     0x185def637
   185def61b:	48 8b 47 f8          	mov    rax,QWORD PTR [rdi-0x8]
   185def61f:	48 83 c7 f8          	add    rdi,0xfffffffffffffff8
   185def623:	48 29 c7             	sub    rdi,rax
   185def626:	48 83 ff 20          	cmp    rdi,0x20
   185def62a:	0f 83 85 03 00 00    	jae    0x185def9b5
   185def630:	48 83 c2 27          	add    rdx,0x27
   185def634:	48 89 c7             	mov    rdi,rax
   185def637:	48 89 f9             	mov    rcx,rdi
   185def63a:	e8 a1 c2 6b 01       	call   0x1874ab8e0
   185def63f:	48 8b bd 48 01 00 00 	mov    rdi,QWORD PTR [rbp+0x148]
   185def646:	48 85 ff             	test   rdi,rdi
   185def649:	74 1d                	je     0x185def668
   185def64b:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   185def64f:	75 17                	jne    0x185def668
   185def651:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185def654:	48 89 f9             	mov    rcx,rdi
   185def657:	ff 10                	call   QWORD PTR [rax]
   185def659:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   185def65d:	75 09                	jne    0x185def668
   185def65f:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185def662:	48 89 f9             	mov    rcx,rdi
   185def665:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185def668:	48 8b bd 28 01 00 00 	mov    rdi,QWORD PTR [rbp+0x128]
   185def66f:	48 85 ff             	test   rdi,rdi
   185def672:	74 1d                	je     0x185def691
   185def674:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   185def678:	75 17                	jne    0x185def691
   185def67a:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185def67d:	48 89 f9             	mov    rcx,rdi
   185def680:	ff 10                	call   QWORD PTR [rax]
   185def682:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   185def686:	75 09                	jne    0x185def691
   185def688:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185def68b:	48 89 f9             	mov    rcx,rdi
   185def68e:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185def691:	48 8b bd a8 00 00 00 	mov    rdi,QWORD PTR [rbp+0xa8]
   185def698:	48 85 ff             	test   rdi,rdi
   185def69b:	74 1d                	je     0x185def6ba
   185def69d:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   185def6a1:	75 17                	jne    0x185def6ba
   185def6a3:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185def6a6:	48 89 f9             	mov    rcx,rdi
   185def6a9:	ff 10                	call   QWORD PTR [rax]
   185def6ab:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   185def6af:	75 09                	jne    0x185def6ba
   185def6b1:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185def6b4:	48 89 f9             	mov    rcx,rdi
   185def6b7:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185def6ba:	48 8b bd e8 00 00 00 	mov    rdi,QWORD PTR [rbp+0xe8]
   185def6c1:	48 85 ff             	test   rdi,rdi
   185def6c4:	74 1d                	je     0x185def6e3
   185def6c6:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   185def6ca:	75 17                	jne    0x185def6e3
   185def6cc:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185def6cf:	48 89 f9             	mov    rcx,rdi
   185def6d2:	ff 10                	call   QWORD PTR [rax]
   185def6d4:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   185def6d8:	75 09                	jne    0x185def6e3
   185def6da:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185def6dd:	48 89 f9             	mov    rcx,rdi
   185def6e0:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185def6e3:	48 8b bd c8 00 00 00 	mov    rdi,QWORD PTR [rbp+0xc8]
   185def6ea:	48 85 ff             	test   rdi,rdi
   185def6ed:	74 1d                	je     0x185def70c
   185def6ef:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   185def6f3:	75 17                	jne    0x185def70c
   185def6f5:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185def6f8:	48 89 f9             	mov    rcx,rdi
   185def6fb:	ff 10                	call   QWORD PTR [rax]
   185def6fd:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   185def701:	75 09                	jne    0x185def70c
   185def703:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185def706:	48 89 f9             	mov    rcx,rdi
   185def709:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185def70c:	48 8b bd b8 00 00 00 	mov    rdi,QWORD PTR [rbp+0xb8]
   185def713:	48 85 ff             	test   rdi,rdi
   185def716:	74 1d                	je     0x185def735
   185def718:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   185def71c:	75 17                	jne    0x185def735
   185def71e:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185def721:	48 89 f9             	mov    rcx,rdi
   185def724:	ff 10                	call   QWORD PTR [rax]
   185def726:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   185def72a:	75 09                	jne    0x185def735
   185def72c:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185def72f:	48 89 f9             	mov    rcx,rdi
   185def732:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185def735:	48 8b 7d 48          	mov    rdi,QWORD PTR [rbp+0x48]
   185def739:	48 85 ff             	test   rdi,rdi
   185def73c:	74 1d                	je     0x185def75b
   185def73e:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   185def742:	75 17                	jne    0x185def75b
   185def744:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185def747:	48 89 f9             	mov    rcx,rdi
   185def74a:	ff 10                	call   QWORD PTR [rax]
   185def74c:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   185def750:	75 09                	jne    0x185def75b
   185def752:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185def755:	48 89 f9             	mov    rcx,rdi
   185def758:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185def75b:	48 8b 7d 50          	mov    rdi,QWORD PTR [rbp+0x50]
   185def75f:	48 85 ff             	test   rdi,rdi
   185def762:	0f 84 91 00 00 00    	je     0x185def7f9
   185def768:	48 8b 75 58          	mov    rsi,QWORD PTR [rbp+0x58]
   185def76c:	48 39 f7             	cmp    rdi,rsi
   185def76f:	75 28                	jne    0x185def799
   185def771:	48 8b 55 60          	mov    rdx,QWORD PTR [rbp+0x60]
   185def775:	48 29 fa             	sub    rdx,rdi
   185def778:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185def77f:	73 54                	jae    0x185def7d5
   185def781:	eb 6e                	jmp    0x185def7f1
   185def783:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
   185def78a:	84 00 00 00 00 00 
   185def790:	48 83 c7 10          	add    rdi,0x10
   185def794:	48 39 f7             	cmp    rdi,rsi
   185def797:	74 28                	je     0x185def7c1
   185def799:	48 8b 5f 08          	mov    rbx,QWORD PTR [rdi+0x8]
   185def79d:	48 85 db             	test   rbx,rbx
   185def7a0:	74 ee                	je     0x185def790
   185def7a2:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   185def7a6:	75 e8                	jne    0x185def790
   185def7a8:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185def7ab:	48 89 d9             	mov    rcx,rbx
   185def7ae:	ff 10                	call   QWORD PTR [rax]
   185def7b0:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   185def7b4:	75 da                	jne    0x185def790
   185def7b6:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185def7b9:	48 89 d9             	mov    rcx,rbx
   185def7bc:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185def7bf:	eb cf                	jmp    0x185def790
   185def7c1:	48 8b 7d 50          	mov    rdi,QWORD PTR [rbp+0x50]
   185def7c5:	48 8b 55 60          	mov    rdx,QWORD PTR [rbp+0x60]
   185def7c9:	48 29 fa             	sub    rdx,rdi
   185def7cc:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185def7d3:	72 1c                	jb     0x185def7f1
   185def7d5:	48 8b 47 f8          	mov    rax,QWORD PTR [rdi-0x8]
   185def7d9:	48 83 c7 f8          	add    rdi,0xfffffffffffffff8
   185def7dd:	48 29 c7             	sub    rdi,rax
   185def7e0:	48 83 ff 20          	cmp    rdi,0x20
   185def7e4:	0f 83 cb 01 00 00    	jae    0x185def9b5
   185def7ea:	48 83 c2 27          	add    rdx,0x27
   185def7ee:	48 89 c7             	mov    rdi,rax
   185def7f1:	48 89 f9             	mov    rcx,rdi
   185def7f4:	e8 e7 c0 6b 01       	call   0x1874ab8e0
   185def7f9:	48 8b bd 00 01 00 00 	mov    rdi,QWORD PTR [rbp+0x100]
   185def800:	48 85 ff             	test   rdi,rdi
   185def803:	0f 84 96 00 00 00    	je     0x185def89f
   185def809:	48 8b b5 08 01 00 00 	mov    rsi,QWORD PTR [rbp+0x108]
   185def810:	48 39 f7             	cmp    rdi,rsi
   185def813:	75 24                	jne    0x185def839
   185def815:	48 8b 95 10 01 00 00 	mov    rdx,QWORD PTR [rbp+0x110]
   185def81c:	48 29 fa             	sub    rdx,rdi
   185def81f:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185def826:	73 53                	jae    0x185def87b
   185def828:	eb 6d                	jmp    0x185def897
   185def82a:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
   185def830:	48 83 c7 10          	add    rdi,0x10
   185def834:	48 39 f7             	cmp    rdi,rsi
   185def837:	74 28                	je     0x185def861
   185def839:	48 8b 5f 08          	mov    rbx,QWORD PTR [rdi+0x8]
   185def83d:	48 85 db             	test   rbx,rbx
   185def840:	74 ee                	je     0x185def830
   185def842:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   185def846:	75 e8                	jne    0x185def830
   185def848:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185def84b:	48 89 d9             	mov    rcx,rbx
   185def84e:	ff 10                	call   QWORD PTR [rax]
   185def850:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   185def854:	75 da                	jne    0x185def830
   185def856:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185def859:	48 89 d9             	mov    rcx,rbx
   185def85c:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185def85f:	eb cf                	jmp    0x185def830
   185def861:	48 8b bd 00 01 00 00 	mov    rdi,QWORD PTR [rbp+0x100]
   185def868:	48 8b 95 10 01 00 00 	mov    rdx,QWORD PTR [rbp+0x110]
   185def86f:	48 29 fa             	sub    rdx,rdi
   185def872:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185def879:	72 1c                	jb     0x185def897
   185def87b:	48 8b 47 f8          	mov    rax,QWORD PTR [rdi-0x8]
   185def87f:	48 83 c7 f8          	add    rdi,0xfffffffffffffff8
   185def883:	48 29 c7             	sub    rdi,rax
   185def886:	48 83 ff 20          	cmp    rdi,0x20
   185def88a:	0f 83 25 01 00 00    	jae    0x185def9b5
   185def890:	48 83 c2 27          	add    rdx,0x27
   185def894:	48 89 c7             	mov    rdi,rax
   185def897:	48 89 f9             	mov    rcx,rdi
   185def89a:	e8 41 c0 6b 01       	call   0x1874ab8e0
   185def89f:	48 8b bd 80 00 00 00 	mov    rdi,QWORD PTR [rbp+0x80]
   185def8a6:	48 85 ff             	test   rdi,rdi
   185def8a9:	0f 84 90 00 00 00    	je     0x185def93f
   185def8af:	48 8b b5 88 00 00 00 	mov    rsi,QWORD PTR [rbp+0x88]
   185def8b6:	48 39 f7             	cmp    rdi,rsi
   185def8b9:	75 1e                	jne    0x185def8d9
   185def8bb:	48 8b 95 90 00 00 00 	mov    rdx,QWORD PTR [rbp+0x90]
   185def8c2:	48 29 fa             	sub    rdx,rdi
   185def8c5:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185def8cc:	73 4d                	jae    0x185def91b
   185def8ce:	eb 67                	jmp    0x185def937
   185def8d0:	48 83 c7 10          	add    rdi,0x10
   185def8d4:	48 39 f7             	cmp    rdi,rsi
   185def8d7:	74 28                	je     0x185def901
   185def8d9:	48 8b 5f 08          	mov    rbx,QWORD PTR [rdi+0x8]
   185def8dd:	48 85 db             	test   rbx,rbx
   185def8e0:	74 ee                	je     0x185def8d0
   185def8e2:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   185def8e6:	75 e8                	jne    0x185def8d0
   185def8e8:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185def8eb:	48 89 d9             	mov    rcx,rbx
   185def8ee:	ff 10                	call   QWORD PTR [rax]
   185def8f0:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   185def8f4:	75 da                	jne    0x185def8d0
   185def8f6:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   185def8f9:	48 89 d9             	mov    rcx,rbx
   185def8fc:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185def8ff:	eb cf                	jmp    0x185def8d0
   185def901:	48 8b bd 80 00 00 00 	mov    rdi,QWORD PTR [rbp+0x80]
   185def908:	48 8b 95 90 00 00 00 	mov    rdx,QWORD PTR [rbp+0x90]
   185def90f:	48 29 fa             	sub    rdx,rdi
   185def912:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185def919:	72 1c                	jb     0x185def937
   185def91b:	48 8b 47 f8          	mov    rax,QWORD PTR [rdi-0x8]
   185def91f:	48 83 c7 f8          	add    rdi,0xfffffffffffffff8
   185def923:	48 29 c7             	sub    rdi,rax
   185def926:	48 83 ff 20          	cmp    rdi,0x20
   185def92a:	0f 83 85 00 00 00    	jae    0x185def9b5
   185def930:	48 83 c2 27          	add    rdx,0x27
   185def934:	48 89 c7             	mov    rdi,rax
   185def937:	48 89 f9             	mov    rcx,rdi
   185def93a:	e8 a1 bf 6b 01       	call   0x1874ab8e0
   185def93f:	49 8b 7d 08          	mov    rdi,QWORD PTR [r13+0x8]
   185def943:	48 85 ff             	test   rdi,rdi
   185def946:	74 1d                	je     0x185def965
   185def948:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   185def94c:	75 17                	jne    0x185def965
   185def94e:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185def951:	48 89 f9             	mov    rcx,rdi
   185def954:	ff 10                	call   QWORD PTR [rax]
   185def956:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   185def95a:	75 09                	jne    0x185def965
   185def95c:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185def95f:	48 89 f9             	mov    rcx,rdi
   185def962:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185def965:	49 8b 7c 24 08       	mov    rdi,QWORD PTR [r12+0x8]
   185def96a:	48 85 ff             	test   rdi,rdi
   185def96d:	74 1d                	je     0x185def98c
   185def96f:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   185def973:	75 17                	jne    0x185def98c
   185def975:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185def978:	48 89 f9             	mov    rcx,rdi
   185def97b:	ff 10                	call   QWORD PTR [rax]
   185def97d:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   185def981:	75 09                	jne    0x185def98c
   185def983:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185def986:	48 89 f9             	mov    rcx,rdi
   185def989:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185def98c:	48 8b 85 98 00 00 00 	mov    rax,QWORD PTR [rbp+0x98]
   185def993:	0f 28 b5 90 01 00 00 	movaps xmm6,XMMWORD PTR [rbp+0x190]
   185def99a:	0f 28 bd a0 01 00 00 	movaps xmm7,XMMWORD PTR [rbp+0x1a0]
   185def9a1:	48 81 c4 38 02 00 00 	add    rsp,0x238
   185def9a8:	5b                   	pop    rbx
   185def9a9:	5f                   	pop    rdi
   185def9aa:	5e                   	pop    rsi
   185def9ab:	41 5c                	pop    r12
   185def9ad:	41 5d                	pop    r13
   185def9af:	41 5e                	pop    r14
   185def9b1:	41 5f                	pop    r15
   185def9b3:	5d                   	pop    rbp
   185def9b4:	c3                   	ret
   185def9b5:	e8 d2 d9 71 01       	call   0x18750d38c
   185def9ba:	90                   	nop
   185def9bb:	e8 70 bd 21 fa       	call   0x18000b730
   185def9c0:	90                   	nop
   185def9c1:	e8 6a bd 21 fa       	call   0x18000b730
   185def9c6:	90                   	nop
   185def9c7:	e8 64 bd 21 fa       	call   0x18000b730
   185def9cc:	90                   	nop
   185def9cd:	e8 5e bd 21 fa       	call   0x18000b730
   185def9d2:	90                   	nop
   185def9d3:	e8 58 bd 21 fa       	call   0x18000b730
   185def9d8:	90                   	nop
   185def9d9:	e8 52 bd 21 fa       	call   0x18000b730
   185def9de:	90                   	nop
   185def9df:	cc                   	int3
