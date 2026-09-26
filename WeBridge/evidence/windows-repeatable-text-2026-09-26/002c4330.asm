
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

00000001802c4330 <.text+0x2c3330>:
   1802c4330:	55                   	push   rbp
   1802c4331:	41 56                	push   r14
   1802c4333:	56                   	push   rsi
   1802c4334:	57                   	push   rdi
   1802c4335:	53                   	push   rbx
   1802c4336:	48 83 ec 30          	sub    rsp,0x30
   1802c433a:	48 8d 6c 24 30       	lea    rbp,[rsp+0x30]
   1802c433f:	48 c7 45 f8 fe ff ff 	mov    QWORD PTR [rbp-0x8],0xfffffffffffffffe
   1802c4346:	ff 
   1802c4347:	44 89 c7             	mov    edi,r8d
   1802c434a:	48 89 d6             	mov    rsi,rdx
   1802c434d:	49 89 ce             	mov    r14,rcx
   1802c4350:	8d 14 7f             	lea    edx,[rdi+rdi*2]
   1802c4353:	45 31 c0             	xor    r8d,r8d
   1802c4356:	e8 e5 f3 e7 ff       	call   0x180143740
   1802c435b:	4d 8b 06             	mov    r8,QWORD PTR [r14]
   1802c435e:	4d 03 40 10          	add    r8,QWORD PTR [r8+0x10]
   1802c4362:	85 ff                	test   edi,edi
   1802c4364:	0f 84 fe 01 00 00    	je     0x1802c4568
   1802c436a:	48 63 cf             	movsxd rcx,edi
   1802c436d:	48 8d 04 4e          	lea    rax,[rsi+rcx*2]
   1802c4371:	48 01 c9             	add    rcx,rcx
   1802c4374:	48 01 f1             	add    rcx,rsi
   1802c4377:	48 83 c1 e0          	add    rcx,0xffffffffffffffe0
   1802c437b:	66 0f ef c0          	pxor   xmm0,xmm0
   1802c437f:	4c 89 c2             	mov    rdx,r8
   1802c4382:	eb 15                	jmp    0x1802c4399
   1802c4384:	66 66 66 2e 0f 1f 84 	data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
   1802c438b:	00 00 00 00 00 
   1802c4390:	48 39 c6             	cmp    rsi,rax
   1802c4393:	0f 84 c6 01 00 00    	je     0x1802c455f
   1802c4399:	49 89 c1             	mov    r9,rax
   1802c439c:	49 29 f1             	sub    r9,rsi
   1802c439f:	49 d1 f9             	sar    r9,1
   1802c43a2:	49 83 f9 10          	cmp    r9,0x10
   1802c43a6:	7c 43                	jl     0x1802c43eb
   1802c43a8:	49 89 c8             	mov    r8,rcx
   1802c43ab:	49 29 f0             	sub    r8,rsi
   1802c43ae:	66 90                	xchg   ax,ax
   1802c43b0:	f3 0f 6f 0e          	movdqu xmm1,XMMWORD PTR [rsi]
   1802c43b4:	f3 0f 6f 56 10       	movdqu xmm2,XMMWORD PTR [rsi+0x10]
   1802c43b9:	66 0f 67 ca          	packuswb xmm1,xmm2
   1802c43bd:	f3 0f 7f 0a          	movdqu XMMWORD PTR [rdx],xmm1
   1802c43c1:	66 0f 64 c8          	pcmpgtb xmm1,xmm0
   1802c43c5:	66 44 0f d7 c9       	pmovmskb r9d,xmm1
   1802c43ca:	41 81 f9 ff ff 00 00 	cmp    r9d,0xffff
   1802c43d1:	75 5d                	jne    0x1802c4430
   1802c43d3:	48 83 c6 20          	add    rsi,0x20
   1802c43d7:	48 83 c2 10          	add    rdx,0x10
   1802c43db:	4d 89 c1             	mov    r9,r8
   1802c43de:	49 d1 f9             	sar    r9,1
   1802c43e1:	49 83 c0 e0          	add    r8,0xffffffffffffffe0
   1802c43e5:	49 83 f9 0f          	cmp    r9,0xf
   1802c43e9:	7f c5                	jg     0x1802c43b0
   1802c43eb:	49 83 f9 08          	cmp    r9,0x8
   1802c43ef:	7c 2f                	jl     0x1802c4420
   1802c43f1:	f3 0f 6f 0e          	movdqu xmm1,XMMWORD PTR [rsi]
   1802c43f5:	66 0f 67 c9          	packuswb xmm1,xmm1
   1802c43f9:	66 0f d6 0a          	movq   QWORD PTR [rdx],xmm1
   1802c43fd:	66 0f 64 c8          	pcmpgtb xmm1,xmm0
   1802c4401:	66 44 0f d7 c1       	pmovmskb r8d,xmm1
   1802c4406:	41 80 f8 ff          	cmp    r8b,0xff
   1802c440a:	74 14                	je     0x1802c4420
   1802c440c:	41 f6 d0             	not    r8b
   1802c440f:	45 0f b6 c8          	movzx  r9d,r8b
   1802c4413:	45 0f bd c1          	bsr    r8d,r9d
   1802c4417:	eb 22                	jmp    0x1802c443b
   1802c4419:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
   1802c4420:	49 89 c0             	mov    r8,rax
   1802c4423:	48 39 c6             	cmp    rsi,rax
   1802c4426:	75 63                	jne    0x1802c448b
   1802c4428:	e9 32 01 00 00       	jmp    0x1802c455f
   1802c442d:	0f 1f 00             	nop    DWORD PTR [rax]
   1802c4430:	41 f7 d1             	not    r9d
   1802c4433:	45 0f b7 c1          	movzx  r8d,r9w
   1802c4437:	45 0f bd c0          	bsr    r8d,r8d
   1802c443b:	4e 8d 04 46          	lea    r8,[rsi+r8*2]
   1802c443f:	49 83 c0 02          	add    r8,0x2
   1802c4443:	f3 45 0f bc c9       	tzcnt  r9d,r9d
   1802c4448:	4c 01 ca             	add    rdx,r9
   1802c444b:	4a 8d 34 4e          	lea    rsi,[rsi+r9*2]
   1802c444f:	eb 3a                	jmp    0x1802c448b
   1802c4451:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
   1802c4458:	0f 1f 84 00 00 00 00 
   1802c445f:	00 
   1802c4460:	45 89 cb             	mov    r11d,r9d
   1802c4463:	41 c1 eb 06          	shr    r11d,0x6
   1802c4467:	41 80 cb c0          	or     r11b,0xc0
   1802c446b:	44 88 1a             	mov    BYTE PTR [rdx],r11b
   1802c446e:	48 ff c2             	inc    rdx
   1802c4471:	41 80 e1 3f          	and    r9b,0x3f
   1802c4475:	41 80 c9 80          	or     r9b,0x80
   1802c4479:	44 88 0a             	mov    BYTE PTR [rdx],r9b
   1802c447c:	4c 89 d6             	mov    rsi,r10
   1802c447f:	48 ff c2             	inc    rdx
   1802c4482:	4d 39 c2             	cmp    r10,r8
   1802c4485:	0f 83 05 ff ff ff    	jae    0x1802c4390
   1802c448b:	4c 8d 56 02          	lea    r10,[rsi+0x2]
   1802c448f:	44 0f b7 0e          	movzx  r9d,WORD PTR [rsi]
   1802c4493:	41 83 f9 7f          	cmp    r9d,0x7f
   1802c4497:	76 e0                	jbe    0x1802c4479
   1802c4499:	45 0f b7 d9          	movzx  r11d,r9w
   1802c449d:	41 81 fb ff 07 00 00 	cmp    r11d,0x7ff
   1802c44a4:	76 ba                	jbe    0x1802c4460
   1802c44a6:	44 89 cf             	mov    edi,r9d
   1802c44a9:	81 e7 00 f8 00 00    	and    edi,0xf800
   1802c44af:	81 ff 00 d8 00 00    	cmp    edi,0xd800
   1802c44b5:	75 6f                	jne    0x1802c4526
   1802c44b7:	4c 39 d0             	cmp    rax,r10
   1802c44ba:	41 0f 94 c3          	sete   r11b
   1802c44be:	44 89 cf             	mov    edi,r9d
   1802c44c1:	81 e7 00 dc 00 00    	and    edi,0xdc00
   1802c44c7:	81 ff 00 d8 00 00    	cmp    edi,0xd800
   1802c44cd:	0f 95 c3             	setne  bl
   1802c44d0:	44 08 db             	or     bl,r11b
   1802c44d3:	75 73                	jne    0x1802c4548
   1802c44d5:	45 0f b7 1a          	movzx  r11d,WORD PTR [r10]
   1802c44d9:	44 89 df             	mov    edi,r11d
   1802c44dc:	81 e7 00 fc 00 00    	and    edi,0xfc00
   1802c44e2:	81 ff 00 dc 00 00    	cmp    edi,0xdc00
   1802c44e8:	75 5e                	jne    0x1802c4548
   1802c44ea:	48 83 c6 04          	add    rsi,0x4
   1802c44ee:	41 c1 e1 0a          	shl    r9d,0xa
   1802c44f2:	45 01 d9             	add    r9d,r11d
   1802c44f5:	41 81 c1 00 24 a0 fc 	add    r9d,0xfca02400
   1802c44fc:	45 89 ca             	mov    r10d,r9d
   1802c44ff:	41 c1 ea 12          	shr    r10d,0x12
   1802c4503:	41 80 ca f0          	or     r10b,0xf0
   1802c4507:	44 88 12             	mov    BYTE PTR [rdx],r10b
   1802c450a:	45 89 ca             	mov    r10d,r9d
   1802c450d:	41 c1 ea 0c          	shr    r10d,0xc
   1802c4511:	41 80 e2 3f          	and    r10b,0x3f
   1802c4515:	41 80 ca 80          	or     r10b,0x80
   1802c4519:	44 88 52 01          	mov    BYTE PTR [rdx+0x1],r10b
   1802c451d:	48 83 c2 02          	add    rdx,0x2
   1802c4521:	49 89 f2             	mov    r10,rsi
   1802c4524:	eb 0e                	jmp    0x1802c4534
   1802c4526:	41 c1 eb 0c          	shr    r11d,0xc
   1802c452a:	41 80 cb e0          	or     r11b,0xe0
   1802c452e:	44 88 1a             	mov    BYTE PTR [rdx],r11b
   1802c4531:	48 ff c2             	inc    rdx
   1802c4534:	45 89 cb             	mov    r11d,r9d
   1802c4537:	41 c1 eb 06          	shr    r11d,0x6
   1802c453b:	41 80 e3 3f          	and    r11b,0x3f
   1802c453f:	41 80 cb 80          	or     r11b,0x80
   1802c4543:	e9 23 ff ff ff       	jmp    0x1802c446b
   1802c4548:	c6 02 3f             	mov    BYTE PTR [rdx],0x3f
   1802c454b:	4c 89 d6             	mov    rsi,r10
   1802c454e:	48 ff c2             	inc    rdx
   1802c4551:	4d 39 c2             	cmp    r10,r8
   1802c4554:	0f 82 31 ff ff ff    	jb     0x1802c448b
   1802c455a:	e9 31 fe ff ff       	jmp    0x1802c4390
   1802c455f:	4d 8b 06             	mov    r8,QWORD PTR [r14]
   1802c4562:	4d 03 40 10          	add    r8,QWORD PTR [r8+0x10]
   1802c4566:	eb 03                	jmp    0x1802c456b
   1802c4568:	4c 89 c2             	mov    rdx,r8
   1802c456b:	44 29 c2             	sub    edx,r8d
   1802c456e:	4c 89 f1             	mov    rcx,r14
   1802c4571:	4c 89 75 f0          	mov    QWORD PTR [rbp-0x10],r14
   1802c4575:	e8 e6 f0 e7 ff       	call   0x180143660
   1802c457a:	90                   	nop
   1802c457b:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   1802c457f:	48 83 c4 30          	add    rsp,0x30
   1802c4583:	5b                   	pop    rbx
   1802c4584:	5f                   	pop    rdi
   1802c4585:	5e                   	pop    rsi
   1802c4586:	41 5e                	pop    r14
   1802c4588:	5d                   	pop    rbp
   1802c4589:	c3                   	ret
