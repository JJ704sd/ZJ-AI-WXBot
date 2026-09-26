
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

00000001854b02f0 <.text+0x54af2f0>:
   1854b02f0:	55                   	push   rbp
   1854b02f1:	41 57                	push   r15
   1854b02f3:	41 56                	push   r14
   1854b02f5:	41 55                	push   r13
   1854b02f7:	41 54                	push   r12
   1854b02f9:	56                   	push   rsi
   1854b02fa:	57                   	push   rdi
   1854b02fb:	53                   	push   rbx
   1854b02fc:	48 81 ec 18 03 00 00 	sub    rsp,0x318
   1854b0303:	48 8d ac 24 80 00 00 	lea    rbp,[rsp+0x80]
   1854b030a:	00 
   1854b030b:	0f 29 b5 80 02 00 00 	movaps XMMWORD PTR [rbp+0x280],xmm6
   1854b0312:	48 c7 85 78 02 00 00 	mov    QWORD PTR [rbp+0x278],0xfffffffffffffffe
   1854b0319:	fe ff ff ff 
   1854b031d:	4c 89 8d 58 02 00 00 	mov    QWORD PTR [rbp+0x258],r9
   1854b0324:	4c 89 c6             	mov    rsi,r8
   1854b0327:	48 89 d3             	mov    rbx,rdx
   1854b032a:	0f 28 35 7f 58 89 03 	movaps xmm6,XMMWORD PTR [rip+0x389587f]        # 0x188d45bb0
   1854b0331:	0f 29 b5 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm6
   1854b0338:	48 8d bd b0 00 00 00 	lea    rdi,[rbp+0xb0]
   1854b033f:	48 89 f9             	mov    rcx,rdi
   1854b0342:	e8 d9 6e b9 fa       	call   0x180047220
   1854b0347:	90                   	nop
   1854b0348:	48 8b 8d b0 00 00 00 	mov    rcx,QWORD PTR [rbp+0xb0]
   1854b034f:	48 8d 95 10 01 00 00 	lea    rdx,[rbp+0x110]
   1854b0356:	e8 e5 c3 eb fa       	call   0x18036c740
   1854b035b:	90                   	nop
   1854b035c:	48 8b 8d 10 01 00 00 	mov    rcx,QWORD PTR [rbp+0x110]
   1854b0363:	48 8d 95 90 01 00 00 	lea    rdx,[rbp+0x190]
   1854b036a:	e8 d1 06 fb fa       	call   0x180460a40
   1854b036f:	90                   	nop
   1854b0370:	48 8b 8d 90 01 00 00 	mov    rcx,QWORD PTR [rbp+0x190]
   1854b0377:	48 8d 95 00 01 00 00 	lea    rdx,[rbp+0x100]
   1854b037e:	49 89 d8             	mov    r8,rbx
   1854b0381:	e8 0a a3 b5 fb       	call   0x18100a690
   1854b0386:	90                   	nop
   1854b0387:	4c 8b b5 98 01 00 00 	mov    r14,QWORD PTR [rbp+0x198]
   1854b038e:	4d 85 f6             	test   r14,r14
   1854b0391:	74 1f                	je     0x1854b03b2
   1854b0393:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   1854b0398:	75 18                	jne    0x1854b03b2
   1854b039a:	49 8b 06             	mov    rax,QWORD PTR [r14]
   1854b039d:	4c 89 f1             	mov    rcx,r14
   1854b03a0:	ff 10                	call   QWORD PTR [rax]
   1854b03a2:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   1854b03a7:	75 09                	jne    0x1854b03b2
   1854b03a9:	49 8b 06             	mov    rax,QWORD PTR [r14]
   1854b03ac:	4c 89 f1             	mov    rcx,r14
   1854b03af:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1854b03b2:	4c 8b b5 18 01 00 00 	mov    r14,QWORD PTR [rbp+0x118]
   1854b03b9:	4d 85 f6             	test   r14,r14
   1854b03bc:	74 1f                	je     0x1854b03dd
   1854b03be:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   1854b03c3:	75 18                	jne    0x1854b03dd
   1854b03c5:	49 8b 06             	mov    rax,QWORD PTR [r14]
   1854b03c8:	4c 89 f1             	mov    rcx,r14
   1854b03cb:	ff 10                	call   QWORD PTR [rax]
   1854b03cd:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   1854b03d2:	75 09                	jne    0x1854b03dd
   1854b03d4:	49 8b 06             	mov    rax,QWORD PTR [r14]
   1854b03d7:	4c 89 f1             	mov    rcx,r14
   1854b03da:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1854b03dd:	4c 8b b5 b8 00 00 00 	mov    r14,QWORD PTR [rbp+0xb8]
   1854b03e4:	4d 85 f6             	test   r14,r14
   1854b03e7:	74 1f                	je     0x1854b0408
   1854b03e9:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   1854b03ee:	75 18                	jne    0x1854b0408
   1854b03f0:	49 8b 06             	mov    rax,QWORD PTR [r14]
   1854b03f3:	4c 89 f1             	mov    rcx,r14
   1854b03f6:	ff 10                	call   QWORD PTR [rax]
   1854b03f8:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   1854b03fd:	75 09                	jne    0x1854b0408
   1854b03ff:	49 8b 06             	mov    rax,QWORD PTR [r14]
   1854b0402:	4c 89 f1             	mov    rcx,r14
   1854b0405:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1854b0408:	48 83 bd 00 01 00 00 	cmp    QWORD PTR [rbp+0x100],0x0
   1854b040f:	00 
   1854b0410:	74 7c                	je     0x1854b048e
   1854b0412:	0f 29 b5 20 02 00 00 	movaps XMMWORD PTR [rbp+0x220],xmm6
   1854b0419:	48 8d 8d 20 02 00 00 	lea    rcx,[rbp+0x220]
   1854b0420:	e8 4b 48 24 fb       	call   0x1806f4c70
   1854b0425:	90                   	nop
   1854b0426:	48 8b 85 20 02 00 00 	mov    rax,QWORD PTR [rbp+0x220]
   1854b042d:	c7 80 18 01 00 00 01 	mov    DWORD PTR [rax+0x118],0x1
   1854b0434:	00 00 00 
   1854b0437:	4c 8d 4b 20          	lea    r9,[rbx+0x20]
   1854b043b:	4c 8d b0 58 07 00 00 	lea    r14,[rax+0x758]
   1854b0442:	4d 39 ce             	cmp    r14,r9
   1854b0445:	74 2b                	je     0x1854b0472
   1854b0447:	4c 8b 7b 30          	mov    r15,QWORD PTR [rbx+0x30]
   1854b044b:	48 83 7b 38 10       	cmp    QWORD PTR [rbx+0x38],0x10
   1854b0450:	72 04                	jb     0x1854b0456
   1854b0452:	4c 8b 4b 20          	mov    r9,QWORD PTR [rbx+0x20]
   1854b0456:	48 8b 88 70 07 00 00 	mov    rcx,QWORD PTR [rax+0x770]
   1854b045d:	49 39 cf             	cmp    r15,rcx
   1854b0460:	0f 86 c0 02 00 00    	jbe    0x1854b0726
   1854b0466:	4c 89 f1             	mov    rcx,r14
   1854b0469:	4c 89 fa             	mov    rdx,r15
   1854b046c:	e8 df dc b8 fa       	call   0x18003e150
   1854b0471:	90                   	nop
   1854b0472:	48 8b 85 20 02 00 00 	mov    rax,QWORD PTR [rbp+0x220]
   1854b0479:	4c 8d b0 b0 00 00 00 	lea    r14,[rax+0xb0]
   1854b0480:	49 39 de             	cmp    r14,rbx
   1854b0483:	0f 85 d3 02 00 00    	jne    0x1854b075c
   1854b0489:	e9 1c 03 00 00       	jmp    0x1854b07aa
   1854b048e:	b9 03 00 00 00       	mov    ecx,0x3
   1854b0493:	e8 48 c9 bb fa       	call   0x18006cde0
   1854b0498:	85 c0                	test   eax,eax
   1854b049a:	0f 84 3b 01 00 00    	je     0x1854b05db
   1854b04a0:	4c 8d b5 20 02 00 00 	lea    r14,[rbp+0x220]
   1854b04a7:	4c 89 f1             	mov    rcx,r14
   1854b04aa:	e8 61 ca bb fa       	call   0x18006cf10
   1854b04af:	90                   	nop
   1854b04b0:	48 83 bd 38 02 00 00 	cmp    QWORD PTR [rbp+0x238],0x10
   1854b04b7:	10 
   1854b04b8:	72 07                	jb     0x1854b04c1
   1854b04ba:	4c 8b b5 20 02 00 00 	mov    r14,QWORD PTR [rbp+0x220]
   1854b04c1:	48 8d 05 28 58 35 04 	lea    rax,[rip+0x4355828]        # 0x189805cf0
   1854b04c8:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1854b04cd:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   1854b04d4:	00 00 
   1854b04d6:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   1854b04db:	c7 44 24 28 79 00 00 	mov    DWORD PTR [rsp+0x28],0x79
   1854b04e2:	00 
   1854b04e3:	4c 8d 0d c6 55 35 04 	lea    r9,[rip+0x43555c6]        # 0x189805ab0
   1854b04ea:	48 8d 8d 90 01 00 00 	lea    rcx,[rbp+0x190]
   1854b04f1:	ba 03 00 00 00       	mov    edx,0x3
   1854b04f6:	4d 89 f0             	mov    r8,r14
   1854b04f9:	e8 72 cd bb fa       	call   0x18006d270
   1854b04fe:	90                   	nop
   1854b04ff:	48 83 7b 18 10       	cmp    QWORD PTR [rbx+0x18],0x10
   1854b0504:	72 03                	jb     0x1854b0509
   1854b0506:	48 8b 1b             	mov    rbx,QWORD PTR [rbx]
   1854b0509:	48 89 9d b0 00 00 00 	mov    QWORD PTR [rbp+0xb0],rbx
   1854b0510:	c6 85 b8 00 00 00 00 	mov    BYTE PTR [rbp+0xb8],0x0
   1854b0517:	48 83 7e 18 10       	cmp    QWORD PTR [rsi+0x18],0x10
   1854b051c:	72 03                	jb     0x1854b0521
   1854b051e:	48 8b 36             	mov    rsi,QWORD PTR [rsi]
   1854b0521:	48 89 75 40          	mov    QWORD PTR [rbp+0x40],rsi
   1854b0525:	c6 45 48 00          	mov    BYTE PTR [rbp+0x48],0x0
   1854b0529:	0f 57 c0             	xorps  xmm0,xmm0
   1854b052c:	0f 11 85 80 01 00 00 	movups XMMWORD PTR [rbp+0x180],xmm0
   1854b0533:	0f 11 85 70 01 00 00 	movups XMMWORD PTR [rbp+0x170],xmm0
   1854b053a:	0f 11 85 60 01 00 00 	movups XMMWORD PTR [rbp+0x160],xmm0
   1854b0541:	0f 11 85 50 01 00 00 	movups XMMWORD PTR [rbp+0x150],xmm0
   1854b0548:	0f 11 85 40 01 00 00 	movups XMMWORD PTR [rbp+0x140],xmm0
   1854b054f:	0f 11 85 30 01 00 00 	movups XMMWORD PTR [rbp+0x130],xmm0
   1854b0556:	0f 11 85 20 01 00 00 	movups XMMWORD PTR [rbp+0x120],xmm0
   1854b055d:	48 8d 45 40          	lea    rax,[rbp+0x40]
   1854b0561:	48 89 85 10 01 00 00 	mov    QWORD PTR [rbp+0x110],rax
   1854b0568:	48 89 bd 18 01 00 00 	mov    QWORD PTR [rbp+0x118],rdi
   1854b056f:	48 8d 15 22 3f 35 04 	lea    rdx,[rip+0x4353f22]        # 0x189804498
   1854b0576:	48 8d 8d 90 01 00 00 	lea    rcx,[rbp+0x190]
   1854b057d:	4c 8d 85 10 01 00 00 	lea    r8,[rbp+0x110]
   1854b0584:	e8 87 d2 bb fa       	call   0x18006d810
   1854b0589:	90                   	nop
   1854b058a:	48 8d 8d 90 01 00 00 	lea    rcx,[rbp+0x190]
   1854b0591:	e8 da cd bb fa       	call   0x18006d370
   1854b0596:	48 8b 85 38 02 00 00 	mov    rax,QWORD PTR [rbp+0x238]
   1854b059d:	48 83 f8 10          	cmp    rax,0x10
   1854b05a1:	72 38                	jb     0x1854b05db
   1854b05a3:	48 8b 8d 20 02 00 00 	mov    rcx,QWORD PTR [rbp+0x220]
   1854b05aa:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1854b05ae:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1854b05b5:	72 1f                	jb     0x1854b05d6
   1854b05b7:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1854b05bb:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1854b05bf:	4c 29 c1             	sub    rcx,r8
   1854b05c2:	48 83 f9 20          	cmp    rcx,0x20
   1854b05c6:	0f 83 65 0a 00 00    	jae    0x1854b1031
   1854b05cc:	48 83 c0 28          	add    rax,0x28
   1854b05d0:	48 89 c2             	mov    rdx,rax
   1854b05d3:	4c 89 c1             	mov    rcx,r8
   1854b05d6:	e8 05 b3 ff 01       	call   0x1874ab8e0
   1854b05db:	0f 57 c0             	xorps  xmm0,xmm0
   1854b05de:	0f 29 85 20 01 00 00 	movaps XMMWORD PTR [rbp+0x120],xmm0
   1854b05e5:	0f 29 85 10 01 00 00 	movaps XMMWORD PTR [rbp+0x110],xmm0
   1854b05ec:	b9 20 00 00 00       	mov    ecx,0x20
   1854b05f1:	e8 a6 b2 ff 01       	call   0x1874ab89c
   1854b05f6:	90                   	nop
   1854b05f7:	48 89 85 10 01 00 00 	mov    QWORD PTR [rbp+0x110],rax
   1854b05fe:	48 c7 85 20 01 00 00 	mov    QWORD PTR [rbp+0x120],0x11
   1854b0605:	11 00 00 00 
   1854b0609:	48 c7 85 28 01 00 00 	mov    QWORD PTR [rbp+0x128],0x1f
   1854b0610:	1f 00 00 00 
   1854b0614:	0f 10 05 ed 20 35 04 	movups xmm0,XMMWORD PTR [rip+0x43520ed]        # 0x189802708
   1854b061b:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   1854b061e:	66 c7 40 10 64 00    	mov    WORD PTR [rax+0x10],0x64
   1854b0624:	0f 29 b5 b0 01 00 00 	movaps XMMWORD PTR [rbp+0x1b0],xmm6
   1854b062b:	0f 29 b5 90 01 00 00 	movaps XMMWORD PTR [rbp+0x190],xmm6
   1854b0632:	0f 29 b5 a0 01 00 00 	movaps XMMWORD PTR [rbp+0x1a0],xmm6
   1854b0639:	c6 85 b8 01 00 00 00 	mov    BYTE PTR [rbp+0x1b8],0x0
   1854b0640:	c6 85 90 01 00 00 00 	mov    BYTE PTR [rbp+0x190],0x0
   1854b0647:	48 8d 8d 98 01 00 00 	lea    rcx,[rbp+0x198]
   1854b064e:	48 8d 95 10 01 00 00 	lea    rdx,[rbp+0x110]
   1854b0655:	e8 36 f4 4c fc       	call   0x18197fa90
   1854b065a:	90                   	nop
   1854b065b:	48 8b 85 58 02 00 00 	mov    rax,QWORD PTR [rbp+0x258]
   1854b0662:	48 8b 08             	mov    rcx,QWORD PTR [rax]
   1854b0665:	48 89 8d b0 00 00 00 	mov    QWORD PTR [rbp+0xb0],rcx
   1854b066c:	48 c7 00 00 00 00 00 	mov    QWORD PTR [rax],0x0
   1854b0673:	48 8d 95 90 01 00 00 	lea    rdx,[rbp+0x190]
   1854b067a:	ff 51 08             	call   QWORD PTR [rcx+0x8]
   1854b067d:	90                   	nop
   1854b067e:	48 8d 8d b0 00 00 00 	lea    rcx,[rbp+0xb0]
   1854b0685:	e8 c6 69 c5 fa       	call   0x180107050
   1854b068a:	80 bd b8 01 00 00 01 	cmp    BYTE PTR [rbp+0x1b8],0x1
   1854b0691:	75 45                	jne    0x1854b06d8
   1854b0693:	48 8b 85 b0 01 00 00 	mov    rax,QWORD PTR [rbp+0x1b0]
   1854b069a:	48 83 f8 10          	cmp    rax,0x10
   1854b069e:	72 38                	jb     0x1854b06d8
   1854b06a0:	48 8b 8d 98 01 00 00 	mov    rcx,QWORD PTR [rbp+0x198]
   1854b06a7:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1854b06ab:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1854b06b2:	72 1f                	jb     0x1854b06d3
   1854b06b4:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1854b06b8:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1854b06bc:	4c 29 c1             	sub    rcx,r8
   1854b06bf:	48 83 f9 20          	cmp    rcx,0x20
   1854b06c3:	0f 83 68 09 00 00    	jae    0x1854b1031
   1854b06c9:	48 83 c0 28          	add    rax,0x28
   1854b06cd:	48 89 c2             	mov    rdx,rax
   1854b06d0:	4c 89 c1             	mov    rcx,r8
   1854b06d3:	e8 08 b2 ff 01       	call   0x1874ab8e0
   1854b06d8:	48 8b 85 28 01 00 00 	mov    rax,QWORD PTR [rbp+0x128]
   1854b06df:	48 83 f8 10          	cmp    rax,0x10
   1854b06e3:	0f 82 f8 08 00 00    	jb     0x1854b0fe1
   1854b06e9:	48 8b 8d 10 01 00 00 	mov    rcx,QWORD PTR [rbp+0x110]
   1854b06f0:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1854b06f4:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1854b06fb:	72 1f                	jb     0x1854b071c
   1854b06fd:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1854b0701:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1854b0705:	4c 29 c1             	sub    rcx,r8
   1854b0708:	48 83 f9 20          	cmp    rcx,0x20
   1854b070c:	0f 83 1f 09 00 00    	jae    0x1854b1031
   1854b0712:	48 83 c0 28          	add    rax,0x28
   1854b0716:	48 89 c2             	mov    rdx,rax
   1854b0719:	4c 89 c1             	mov    rcx,r8
   1854b071c:	e8 bf b1 ff 01       	call   0x1874ab8e0
   1854b0721:	e9 bb 08 00 00       	jmp    0x1854b0fe1
   1854b0726:	48 83 f9 10          	cmp    rcx,0x10
   1854b072a:	72 03                	jb     0x1854b072f
   1854b072c:	4d 8b 36             	mov    r14,QWORD PTR [r14]
   1854b072f:	4c 89 b8 68 07 00 00 	mov    QWORD PTR [rax+0x768],r15
   1854b0736:	4c 89 f1             	mov    rcx,r14
   1854b0739:	4c 89 ca             	mov    rdx,r9
   1854b073c:	4d 89 f8             	mov    r8,r15
   1854b073f:	e8 0c 39 09 02       	call   0x187544050
   1854b0744:	43 c6 04 3e 00       	mov    BYTE PTR [r14+r15*1],0x0
   1854b0749:	48 8b 85 20 02 00 00 	mov    rax,QWORD PTR [rbp+0x220]
   1854b0750:	4c 8d b0 b0 00 00 00 	lea    r14,[rax+0xb0]
   1854b0757:	49 39 de             	cmp    r14,rbx
   1854b075a:	74 4e                	je     0x1854b07aa
   1854b075c:	4c 8b 7b 10          	mov    r15,QWORD PTR [rbx+0x10]
   1854b0760:	48 83 7b 18 10       	cmp    QWORD PTR [rbx+0x18],0x10
   1854b0765:	72 03                	jb     0x1854b076a
   1854b0767:	48 8b 1b             	mov    rbx,QWORD PTR [rbx]
   1854b076a:	48 8b 88 c8 00 00 00 	mov    rcx,QWORD PTR [rax+0xc8]
   1854b0771:	49 39 cf             	cmp    r15,rcx
   1854b0774:	76 11                	jbe    0x1854b0787
   1854b0776:	4c 89 f1             	mov    rcx,r14
   1854b0779:	4c 89 fa             	mov    rdx,r15
   1854b077c:	49 89 d9             	mov    r9,rbx
   1854b077f:	e8 cc d9 b8 fa       	call   0x18003e150
   1854b0784:	90                   	nop
   1854b0785:	eb 23                	jmp    0x1854b07aa
   1854b0787:	48 83 f9 10          	cmp    rcx,0x10
   1854b078b:	72 03                	jb     0x1854b0790
   1854b078d:	4d 8b 36             	mov    r14,QWORD PTR [r14]
   1854b0790:	4c 89 b8 c0 00 00 00 	mov    QWORD PTR [rax+0xc0],r15
   1854b0797:	4c 89 f1             	mov    rcx,r14
   1854b079a:	48 89 da             	mov    rdx,rbx
   1854b079d:	4d 89 f8             	mov    r8,r15
   1854b07a0:	e8 ab 38 09 02       	call   0x187544050
   1854b07a5:	43 c6 04 3e 00       	mov    BYTE PTR [r14+r15*1],0x0
   1854b07aa:	0f 29 b5 40 02 00 00 	movaps XMMWORD PTR [rbp+0x240],xmm6
   1854b07b1:	48 8d 8d 10 01 00 00 	lea    rcx,[rbp+0x110]
   1854b07b8:	e8 63 6a b9 fa       	call   0x180047220
   1854b07bd:	90                   	nop
   1854b07be:	48 8b 8d 10 01 00 00 	mov    rcx,QWORD PTR [rbp+0x110]
   1854b07c5:	48 8d 95 90 01 00 00 	lea    rdx,[rbp+0x190]
   1854b07cc:	e8 6f bf eb fa       	call   0x18036c740
   1854b07d1:	90                   	nop
   1854b07d2:	48 8b 8d 90 01 00 00 	mov    rcx,QWORD PTR [rbp+0x190]
   1854b07d9:	48 8d 95 40 02 00 00 	lea    rdx,[rbp+0x240]
   1854b07e0:	e8 ab 45 24 fb       	call   0x1806f4d90
   1854b07e5:	90                   	nop
   1854b07e6:	48 8b 9d 98 01 00 00 	mov    rbx,QWORD PTR [rbp+0x198]
   1854b07ed:	48 85 db             	test   rbx,rbx
   1854b07f0:	74 1d                	je     0x1854b080f
   1854b07f2:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   1854b07f6:	75 17                	jne    0x1854b080f
   1854b07f8:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1854b07fb:	48 89 d9             	mov    rcx,rbx
   1854b07fe:	ff 10                	call   QWORD PTR [rax]
   1854b0800:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   1854b0804:	75 09                	jne    0x1854b080f
   1854b0806:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1854b0809:	48 89 d9             	mov    rcx,rbx
   1854b080c:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1854b080f:	48 8b 9d 18 01 00 00 	mov    rbx,QWORD PTR [rbp+0x118]
   1854b0816:	48 85 db             	test   rbx,rbx
   1854b0819:	74 1d                	je     0x1854b0838
   1854b081b:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   1854b081f:	75 17                	jne    0x1854b0838
   1854b0821:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1854b0824:	48 89 d9             	mov    rcx,rbx
   1854b0827:	ff 10                	call   QWORD PTR [rax]
   1854b0829:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   1854b082d:	75 09                	jne    0x1854b0838
   1854b082f:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1854b0832:	48 89 d9             	mov    rcx,rbx
   1854b0835:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1854b0838:	48 83 bd 40 02 00 00 	cmp    QWORD PTR [rbp+0x240],0x0
   1854b083f:	00 
   1854b0840:	0f 84 ef 01 00 00    	je     0x1854b0a35
   1854b0846:	b9 20 00 00 00       	mov    ecx,0x20
   1854b084b:	e8 4c b0 ff 01       	call   0x1874ab89c
   1854b0850:	90                   	nop
   1854b0851:	48 b9 01 00 00 00 01 	movabs rcx,0x100000001
   1854b0858:	00 00 00 
   1854b085b:	48 89 48 08          	mov    QWORD PTR [rax+0x8],rcx
   1854b085f:	48 8d 0d 82 4f 35 04 	lea    rcx,[rip+0x4354f82]        # 0x1898057e8
   1854b0866:	48 89 08             	mov    QWORD PTR [rax],rcx
   1854b0869:	0f 57 c0             	xorps  xmm0,xmm0
   1854b086c:	0f 11 40 10          	movups XMMWORD PTR [rax+0x10],xmm0
   1854b0870:	48 89 85 68 02 00 00 	mov    QWORD PTR [rbp+0x268],rax
   1854b0877:	48 8d 48 18          	lea    rcx,[rax+0x18]
   1854b087b:	48 8b 95 58 02 00 00 	mov    rdx,QWORD PTR [rbp+0x258]
   1854b0882:	e8 c9 66 c5 fa       	call   0x180106f50
   1854b0887:	90                   	nop
   1854b0888:	48 8d 8d b0 00 00 00 	lea    rcx,[rbp+0xb0]
   1854b088f:	e8 8c 69 b9 fa       	call   0x180047220
   1854b0894:	90                   	nop
   1854b0895:	48 8b 8d b0 00 00 00 	mov    rcx,QWORD PTR [rbp+0xb0]
   1854b089c:	48 8d 95 10 01 00 00 	lea    rdx,[rbp+0x110]
   1854b08a3:	e8 98 be eb fa       	call   0x18036c740
   1854b08a8:	90                   	nop
   1854b08a9:	48 8b 8d 10 01 00 00 	mov    rcx,QWORD PTR [rbp+0x110]
   1854b08b0:	48 8d 95 90 01 00 00 	lea    rdx,[rbp+0x190]
   1854b08b7:	e8 44 f4 9d fb       	call   0x180e8fd00
   1854b08bc:	90                   	nop
   1854b08bd:	48 8b 95 68 02 00 00 	mov    rdx,QWORD PTR [rbp+0x268]
   1854b08c4:	4c 8d 7a 08          	lea    r15,[rdx+0x8]
   1854b08c8:	4c 8d 62 10          	lea    r12,[rdx+0x10]
   1854b08cc:	48 8b 8d 90 01 00 00 	mov    rcx,QWORD PTR [rbp+0x190]
   1854b08d3:	48 85 d2             	test   rdx,rdx
   1854b08d6:	74 04                	je     0x1854b08dc
   1854b08d8:	f0 41 ff 07          	lock inc DWORD PTR [r15]
   1854b08dc:	48 8d 05 95 4f 35 04 	lea    rax,[rip+0x4354f95]        # 0x189805878
   1854b08e3:	48 89 45 c0          	mov    QWORD PTR [rbp-0x40],rax
   1854b08e7:	4c 89 65 c8          	mov    QWORD PTR [rbp-0x38],r12
   1854b08eb:	48 89 55 d0          	mov    QWORD PTR [rbp-0x30],rdx
   1854b08ef:	48 8d 55 c0          	lea    rdx,[rbp-0x40]
   1854b08f3:	48 89 55 f8          	mov    QWORD PTR [rbp-0x8],rdx
   1854b08f7:	e8 04 ce 90 fd       	call   0x182dbd700
   1854b08fc:	90                   	nop
   1854b08fd:	48 8b bd 98 01 00 00 	mov    rdi,QWORD PTR [rbp+0x198]
   1854b0904:	48 85 ff             	test   rdi,rdi
   1854b0907:	74 1d                	je     0x1854b0926
   1854b0909:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   1854b090d:	75 17                	jne    0x1854b0926
   1854b090f:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1854b0912:	48 89 f9             	mov    rcx,rdi
   1854b0915:	ff 10                	call   QWORD PTR [rax]
   1854b0917:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   1854b091b:	75 09                	jne    0x1854b0926
   1854b091d:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1854b0920:	48 89 f9             	mov    rcx,rdi
   1854b0923:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1854b0926:	48 8b bd 18 01 00 00 	mov    rdi,QWORD PTR [rbp+0x118]
   1854b092d:	48 85 ff             	test   rdi,rdi
   1854b0930:	74 1d                	je     0x1854b094f
   1854b0932:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   1854b0936:	75 17                	jne    0x1854b094f
   1854b0938:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1854b093b:	48 89 f9             	mov    rcx,rdi
   1854b093e:	ff 10                	call   QWORD PTR [rax]
   1854b0940:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   1854b0944:	75 09                	jne    0x1854b094f
   1854b0946:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1854b0949:	48 89 f9             	mov    rcx,rdi
   1854b094c:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1854b094f:	48 8b bd b8 00 00 00 	mov    rdi,QWORD PTR [rbp+0xb8]
   1854b0956:	48 85 ff             	test   rdi,rdi
   1854b0959:	74 1e                	je     0x1854b0979
   1854b095b:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   1854b095f:	75 18                	jne    0x1854b0979
   1854b0961:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1854b0964:	48 89 f9             	mov    rcx,rdi
   1854b0967:	ff 10                	call   QWORD PTR [rax]
   1854b0969:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   1854b096d:	75 0a                	jne    0x1854b0979
   1854b096f:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1854b0972:	48 89 f9             	mov    rcx,rdi
   1854b0975:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1854b0978:	90                   	nop
   1854b0979:	e8 92 53 b9 fa       	call   0x180045d10
   1854b097e:	90                   	nop
   1854b097f:	48 8d 95 b0 00 00 00 	lea    rdx,[rbp+0xb0]
   1854b0986:	48 89 c1             	mov    rcx,rax
   1854b0989:	e8 82 69 b9 fa       	call   0x180047310
   1854b098e:	90                   	nop
   1854b098f:	48 8b bd b0 00 00 00 	mov    rdi,QWORD PTR [rbp+0xb0]
   1854b0996:	48 8b 85 68 02 00 00 	mov    rax,QWORD PTR [rbp+0x268]
   1854b099d:	48 85 c0             	test   rax,rax
   1854b09a0:	74 04                	je     0x1854b09a6
   1854b09a2:	f0 41 ff 07          	lock inc DWORD PTR [r15]
   1854b09a6:	4c 89 a5 90 01 00 00 	mov    QWORD PTR [rbp+0x190],r12
   1854b09ad:	48 89 85 98 01 00 00 	mov    QWORD PTR [rbp+0x198],rax
   1854b09b4:	0f 57 c0             	xorps  xmm0,xmm0
   1854b09b7:	0f 11 85 a0 01 00 00 	movups XMMWORD PTR [rbp+0x1a0],xmm0
   1854b09be:	0f 11 85 b0 01 00 00 	movups XMMWORD PTR [rbp+0x1b0],xmm0
   1854b09c5:	48 8b 5e 10          	mov    rbx,QWORD PTR [rsi+0x10]
   1854b09c9:	48 83 7e 18 10       	cmp    QWORD PTR [rsi+0x18],0x10
   1854b09ce:	72 03                	jb     0x1854b09d3
   1854b09d0:	48 8b 36             	mov    rsi,QWORD PTR [rsi]
   1854b09d3:	48 85 db             	test   rbx,rbx
   1854b09d6:	0f 88 5b 06 00 00    	js     0x1854b1037
   1854b09dc:	48 8d 85 a0 01 00 00 	lea    rax,[rbp+0x1a0]
   1854b09e3:	48 83 fb 0f          	cmp    rbx,0xf
   1854b09e7:	0f 86 e1 02 00 00    	jbe    0x1854b0cce
   1854b09ed:	48 89 d8             	mov    rax,rbx
   1854b09f0:	48 83 c8 0f          	or     rax,0xf
   1854b09f4:	48 83 f8 17          	cmp    rax,0x17
   1854b09f8:	41 be 16 00 00 00    	mov    r14d,0x16
   1854b09fe:	4c 0f 43 f0          	cmovae r14,rax
   1854b0a02:	48 3d ff 0f 00 00    	cmp    rax,0xfff
   1854b0a08:	0f 82 f1 02 00 00    	jb     0x1854b0cff
   1854b0a0e:	49 8d 4e 28          	lea    rcx,[r14+0x28]
   1854b0a12:	e8 85 ae ff 01       	call   0x1874ab89c
   1854b0a17:	90                   	nop
   1854b0a18:	48 85 c0             	test   rax,rax
   1854b0a1b:	0f 84 10 06 00 00    	je     0x1854b1031
   1854b0a21:	48 89 c1             	mov    rcx,rax
   1854b0a24:	48 83 c0 27          	add    rax,0x27
   1854b0a28:	48 83 e0 e0          	and    rax,0xffffffffffffffe0
   1854b0a2c:	48 89 48 f8          	mov    QWORD PTR [rax-0x8],rcx
   1854b0a30:	e9 d4 02 00 00       	jmp    0x1854b0d09
   1854b0a35:	b9 04 00 00 00       	mov    ecx,0x4
   1854b0a3a:	e8 a1 c3 bb fa       	call   0x18006cde0
   1854b0a3f:	85 c0                	test   eax,eax
   1854b0a41:	0f 84 1a 01 00 00    	je     0x1854b0b61
   1854b0a47:	48 8d 5d 40          	lea    rbx,[rbp+0x40]
   1854b0a4b:	48 89 d9             	mov    rcx,rbx
   1854b0a4e:	e8 bd c4 bb fa       	call   0x18006cf10
   1854b0a53:	90                   	nop
   1854b0a54:	48 83 7d 58 10       	cmp    QWORD PTR [rbp+0x58],0x10
   1854b0a59:	72 04                	jb     0x1854b0a5f
   1854b0a5b:	48 8b 5d 40          	mov    rbx,QWORD PTR [rbp+0x40]
   1854b0a5f:	48 8d 05 8a 52 35 04 	lea    rax,[rip+0x435528a]        # 0x189805cf0
   1854b0a66:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1854b0a6b:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   1854b0a72:	00 00 
   1854b0a74:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   1854b0a79:	c7 44 24 28 87 00 00 	mov    DWORD PTR [rsp+0x28],0x87
   1854b0a80:	00 
   1854b0a81:	4c 8d 0d 28 50 35 04 	lea    r9,[rip+0x4355028]        # 0x189805ab0
   1854b0a88:	48 8d 8d 90 01 00 00 	lea    rcx,[rbp+0x190]
   1854b0a8f:	ba 04 00 00 00       	mov    edx,0x4
   1854b0a94:	49 89 d8             	mov    r8,rbx
   1854b0a97:	e8 d4 c7 bb fa       	call   0x18006d270
   1854b0a9c:	90                   	nop
   1854b0a9d:	48 83 7e 18 10       	cmp    QWORD PTR [rsi+0x18],0x10
   1854b0aa2:	72 03                	jb     0x1854b0aa7
   1854b0aa4:	48 8b 36             	mov    rsi,QWORD PTR [rsi]
   1854b0aa7:	48 89 b5 b0 00 00 00 	mov    QWORD PTR [rbp+0xb0],rsi
   1854b0aae:	c6 85 b8 00 00 00 00 	mov    BYTE PTR [rbp+0xb8],0x0
   1854b0ab5:	0f 57 c0             	xorps  xmm0,xmm0
   1854b0ab8:	0f 11 85 78 01 00 00 	movups XMMWORD PTR [rbp+0x178],xmm0
   1854b0abf:	0f 11 85 68 01 00 00 	movups XMMWORD PTR [rbp+0x168],xmm0
   1854b0ac6:	0f 11 85 58 01 00 00 	movups XMMWORD PTR [rbp+0x158],xmm0
   1854b0acd:	0f 11 85 48 01 00 00 	movups XMMWORD PTR [rbp+0x148],xmm0
   1854b0ad4:	0f 11 85 38 01 00 00 	movups XMMWORD PTR [rbp+0x138],xmm0
   1854b0adb:	0f 11 85 28 01 00 00 	movups XMMWORD PTR [rbp+0x128],xmm0
   1854b0ae2:	0f 11 85 18 01 00 00 	movups XMMWORD PTR [rbp+0x118],xmm0
   1854b0ae9:	48 c7 85 88 01 00 00 	mov    QWORD PTR [rbp+0x188],0x0
   1854b0af0:	00 00 00 00 
   1854b0af4:	48 89 bd 10 01 00 00 	mov    QWORD PTR [rbp+0x110],rdi
   1854b0afb:	48 8d 15 4e f2 34 04 	lea    rdx,[rip+0x434f24e]        # 0x1897ffd50
   1854b0b02:	48 8d 8d 90 01 00 00 	lea    rcx,[rbp+0x190]
   1854b0b09:	4c 8d 85 10 01 00 00 	lea    r8,[rbp+0x110]
   1854b0b10:	e8 fb cc bb fa       	call   0x18006d810
   1854b0b15:	90                   	nop
   1854b0b16:	48 8d 8d 90 01 00 00 	lea    rcx,[rbp+0x190]
   1854b0b1d:	e8 4e c8 bb fa       	call   0x18006d370
   1854b0b22:	48 8b 45 58          	mov    rax,QWORD PTR [rbp+0x58]
   1854b0b26:	48 83 f8 10          	cmp    rax,0x10
   1854b0b2a:	72 35                	jb     0x1854b0b61
   1854b0b2c:	48 8b 4d 40          	mov    rcx,QWORD PTR [rbp+0x40]
   1854b0b30:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1854b0b34:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1854b0b3b:	72 1f                	jb     0x1854b0b5c
   1854b0b3d:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1854b0b41:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1854b0b45:	4c 29 c1             	sub    rcx,r8
   1854b0b48:	48 83 f9 20          	cmp    rcx,0x20
   1854b0b4c:	0f 83 df 04 00 00    	jae    0x1854b1031
   1854b0b52:	48 83 c0 28          	add    rax,0x28
   1854b0b56:	48 89 c2             	mov    rdx,rax
   1854b0b59:	4c 89 c1             	mov    rcx,r8
   1854b0b5c:	e8 7f ad ff 01       	call   0x1874ab8e0
   1854b0b61:	0f 57 c0             	xorps  xmm0,xmm0
   1854b0b64:	0f 29 85 20 01 00 00 	movaps XMMWORD PTR [rbp+0x120],xmm0
   1854b0b6b:	0f 29 85 10 01 00 00 	movaps XMMWORD PTR [rbp+0x110],xmm0
   1854b0b72:	b9 40 00 00 00       	mov    ecx,0x40
   1854b0b77:	e8 20 ad ff 01       	call   0x1874ab89c
   1854b0b7c:	90                   	nop
   1854b0b7d:	48 89 85 10 01 00 00 	mov    QWORD PTR [rbp+0x110],rax
   1854b0b84:	48 c7 85 20 01 00 00 	mov    QWORD PTR [rbp+0x120],0x37
   1854b0b8b:	37 00 00 00 
   1854b0b8f:	48 c7 85 28 01 00 00 	mov    QWORD PTR [rbp+0x128],0x3f
   1854b0b96:	3f 00 00 00 
   1854b0b9a:	0f 10 05 27 4c 35 04 	movups xmm0,XMMWORD PTR [rip+0x4354c27]        # 0x1898057c8
   1854b0ba1:	0f 11 40 20          	movups XMMWORD PTR [rax+0x20],xmm0
   1854b0ba5:	0f 10 05 0c 4c 35 04 	movups xmm0,XMMWORD PTR [rip+0x4354c0c]        # 0x1898057b8
   1854b0bac:	0f 11 40 10          	movups XMMWORD PTR [rax+0x10],xmm0
   1854b0bb0:	0f 10 05 f1 4b 35 04 	movups xmm0,XMMWORD PTR [rip+0x4354bf1]        # 0x1898057a8
   1854b0bb7:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   1854b0bba:	48 b9 76 61 69 6c 61 	movabs rcx,0x656c62616c696176
   1854b0bc1:	62 6c 65 
   1854b0bc4:	48 89 48 2f          	mov    QWORD PTR [rax+0x2f],rcx
   1854b0bc8:	c6 40 37 00          	mov    BYTE PTR [rax+0x37],0x0
   1854b0bcc:	0f 29 b5 b0 01 00 00 	movaps XMMWORD PTR [rbp+0x1b0],xmm6
   1854b0bd3:	0f 29 b5 90 01 00 00 	movaps XMMWORD PTR [rbp+0x190],xmm6
   1854b0bda:	0f 29 b5 a0 01 00 00 	movaps XMMWORD PTR [rbp+0x1a0],xmm6
   1854b0be1:	c6 85 b8 01 00 00 00 	mov    BYTE PTR [rbp+0x1b8],0x0
   1854b0be8:	c6 85 90 01 00 00 00 	mov    BYTE PTR [rbp+0x190],0x0
   1854b0bef:	48 8d 8d 98 01 00 00 	lea    rcx,[rbp+0x198]
   1854b0bf6:	48 8d 95 10 01 00 00 	lea    rdx,[rbp+0x110]
   1854b0bfd:	e8 8e ee 4c fc       	call   0x18197fa90
   1854b0c02:	90                   	nop
   1854b0c03:	48 8b 85 58 02 00 00 	mov    rax,QWORD PTR [rbp+0x258]
   1854b0c0a:	48 8b 08             	mov    rcx,QWORD PTR [rax]
   1854b0c0d:	48 89 8d b0 00 00 00 	mov    QWORD PTR [rbp+0xb0],rcx
   1854b0c14:	48 c7 00 00 00 00 00 	mov    QWORD PTR [rax],0x0
   1854b0c1b:	48 8d 95 90 01 00 00 	lea    rdx,[rbp+0x190]
   1854b0c22:	ff 51 08             	call   QWORD PTR [rcx+0x8]
   1854b0c25:	90                   	nop
   1854b0c26:	48 8d 8d b0 00 00 00 	lea    rcx,[rbp+0xb0]
   1854b0c2d:	e8 1e 64 c5 fa       	call   0x180107050
   1854b0c32:	80 bd b8 01 00 00 01 	cmp    BYTE PTR [rbp+0x1b8],0x1
   1854b0c39:	75 45                	jne    0x1854b0c80
   1854b0c3b:	48 8b 85 b0 01 00 00 	mov    rax,QWORD PTR [rbp+0x1b0]
   1854b0c42:	48 83 f8 10          	cmp    rax,0x10
   1854b0c46:	72 38                	jb     0x1854b0c80
   1854b0c48:	48 8b 8d 98 01 00 00 	mov    rcx,QWORD PTR [rbp+0x198]
   1854b0c4f:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1854b0c53:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1854b0c5a:	72 1f                	jb     0x1854b0c7b
   1854b0c5c:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1854b0c60:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1854b0c64:	4c 29 c1             	sub    rcx,r8
   1854b0c67:	48 83 f9 20          	cmp    rcx,0x20
   1854b0c6b:	0f 83 c0 03 00 00    	jae    0x1854b1031
   1854b0c71:	48 83 c0 28          	add    rax,0x28
   1854b0c75:	48 89 c2             	mov    rdx,rax
   1854b0c78:	4c 89 c1             	mov    rcx,r8
   1854b0c7b:	e8 60 ac ff 01       	call   0x1874ab8e0
   1854b0c80:	48 8b 85 28 01 00 00 	mov    rax,QWORD PTR [rbp+0x128]
   1854b0c87:	48 83 f8 10          	cmp    rax,0x10
   1854b0c8b:	0f 82 fe 02 00 00    	jb     0x1854b0f8f
   1854b0c91:	48 8b 8d 10 01 00 00 	mov    rcx,QWORD PTR [rbp+0x110]
   1854b0c98:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1854b0c9c:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1854b0ca3:	72 1f                	jb     0x1854b0cc4
   1854b0ca5:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1854b0ca9:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1854b0cad:	4c 29 c1             	sub    rcx,r8
   1854b0cb0:	48 83 f9 20          	cmp    rcx,0x20
   1854b0cb4:	0f 83 77 03 00 00    	jae    0x1854b1031
   1854b0cba:	48 83 c0 28          	add    rax,0x28
   1854b0cbe:	48 89 c2             	mov    rdx,rax
   1854b0cc1:	4c 89 c1             	mov    rcx,r8
   1854b0cc4:	e8 17 ac ff 01       	call   0x1874ab8e0
   1854b0cc9:	e9 c1 02 00 00       	jmp    0x1854b0f8f
   1854b0cce:	48 89 9d b0 01 00 00 	mov    QWORD PTR [rbp+0x1b0],rbx
   1854b0cd5:	48 c7 85 b8 01 00 00 	mov    QWORD PTR [rbp+0x1b8],0xf
   1854b0cdc:	0f 00 00 00 
   1854b0ce0:	0f 10 06             	movups xmm0,XMMWORD PTR [rsi]
   1854b0ce3:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   1854b0ce6:	48 8b 85 28 02 00 00 	mov    rax,QWORD PTR [rbp+0x228]
   1854b0ced:	48 85 c0             	test   rax,rax
   1854b0cf0:	74 47                	je     0x1854b0d39
   1854b0cf2:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   1854b0cf6:	4c 8b ad 28 02 00 00 	mov    r13,QWORD PTR [rbp+0x228]
   1854b0cfd:	eb 3d                	jmp    0x1854b0d3c
   1854b0cff:	49 8d 4e 01          	lea    rcx,[r14+0x1]
   1854b0d03:	e8 94 ab ff 01       	call   0x1874ab89c
   1854b0d08:	90                   	nop
   1854b0d09:	48 89 85 a0 01 00 00 	mov    QWORD PTR [rbp+0x1a0],rax
   1854b0d10:	48 89 9d b0 01 00 00 	mov    QWORD PTR [rbp+0x1b0],rbx
   1854b0d17:	4c 89 b5 b8 01 00 00 	mov    QWORD PTR [rbp+0x1b8],r14
   1854b0d1e:	4c 8d 43 01          	lea    r8,[rbx+0x1]
   1854b0d22:	48 89 c1             	mov    rcx,rax
   1854b0d25:	48 89 f2             	mov    rdx,rsi
   1854b0d28:	e8 23 33 09 02       	call   0x187544050
   1854b0d2d:	48 8b 85 28 02 00 00 	mov    rax,QWORD PTR [rbp+0x228]
   1854b0d34:	48 85 c0             	test   rax,rax
   1854b0d37:	75 b9                	jne    0x1854b0cf2
   1854b0d39:	45 31 ed             	xor    r13d,r13d
   1854b0d3c:	4c 89 e6             	mov    rsi,r12
   1854b0d3f:	4c 8b b5 20 02 00 00 	mov    r14,QWORD PTR [rbp+0x220]
   1854b0d46:	4c 89 b5 c0 01 00 00 	mov    QWORD PTR [rbp+0x1c0],r14
   1854b0d4d:	4c 89 ad c8 01 00 00 	mov    QWORD PTR [rbp+0x1c8],r13
   1854b0d54:	48 8b 85 48 02 00 00 	mov    rax,QWORD PTR [rbp+0x248]
   1854b0d5b:	48 85 c0             	test   rax,rax
   1854b0d5e:	4c 89 bd a0 00 00 00 	mov    QWORD PTR [rbp+0xa0],r15
   1854b0d65:	74 0d                	je     0x1854b0d74
   1854b0d67:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   1854b0d6b:	4c 8b a5 48 02 00 00 	mov    r12,QWORD PTR [rbp+0x248]
   1854b0d72:	eb 03                	jmp    0x1854b0d77
   1854b0d74:	45 31 e4             	xor    r12d,r12d
   1854b0d77:	4c 8b bd 40 02 00 00 	mov    r15,QWORD PTR [rbp+0x240]
   1854b0d7e:	4c 89 bd d0 01 00 00 	mov    QWORD PTR [rbp+0x1d0],r15
   1854b0d85:	4c 89 a5 d8 01 00 00 	mov    QWORD PTR [rbp+0x1d8],r12
   1854b0d8c:	48 c7 45 38 00 00 00 	mov    QWORD PTR [rbp+0x38],0x0
   1854b0d93:	00 
   1854b0d94:	b9 58 00 00 00       	mov    ecx,0x58
   1854b0d99:	e8 fe aa ff 01       	call   0x1874ab89c
   1854b0d9e:	90                   	nop
   1854b0d9f:	48 89 c2             	mov    rdx,rax
   1854b0da2:	48 8d 05 bf 4b 35 04 	lea    rax,[rip+0x4354bbf]        # 0x189805968
   1854b0da9:	48 89 02             	mov    QWORD PTR [rdx],rax
   1854b0dac:	48 89 72 08          	mov    QWORD PTR [rdx+0x8],rsi
   1854b0db0:	48 8b 85 68 02 00 00 	mov    rax,QWORD PTR [rbp+0x268]
   1854b0db7:	48 89 42 10          	mov    QWORD PTR [rdx+0x10],rax
   1854b0dbb:	0f 57 c0             	xorps  xmm0,xmm0
   1854b0dbe:	0f 29 85 90 01 00 00 	movaps XMMWORD PTR [rbp+0x190],xmm0
   1854b0dc5:	0f 11 42 28          	movups XMMWORD PTR [rdx+0x28],xmm0
   1854b0dc9:	0f 11 42 18          	movups XMMWORD PTR [rdx+0x18],xmm0
   1854b0dcd:	48 83 fb 0f          	cmp    rbx,0xf
   1854b0dd1:	76 55                	jbe    0x1854b0e28
   1854b0dd3:	48 89 95 60 02 00 00 	mov    QWORD PTR [rbp+0x260],rdx
   1854b0dda:	48 89 bd a8 00 00 00 	mov    QWORD PTR [rbp+0xa8],rdi
   1854b0de1:	48 8b b5 a0 01 00 00 	mov    rsi,QWORD PTR [rbp+0x1a0]
   1854b0de8:	48 89 d8             	mov    rax,rbx
   1854b0deb:	48 83 c8 0f          	or     rax,0xf
   1854b0def:	48 83 f8 17          	cmp    rax,0x17
   1854b0df3:	bf 16 00 00 00       	mov    edi,0x16
   1854b0df8:	48 0f 43 f8          	cmovae rdi,rax
   1854b0dfc:	48 3d ff 0f 00 00    	cmp    rax,0xfff
   1854b0e02:	72 46                	jb     0x1854b0e4a
   1854b0e04:	48 8d 4f 28          	lea    rcx,[rdi+0x28]
   1854b0e08:	e8 8f aa ff 01       	call   0x1874ab89c
   1854b0e0d:	90                   	nop
   1854b0e0e:	48 85 c0             	test   rax,rax
   1854b0e11:	0f 84 1a 02 00 00    	je     0x1854b1031
   1854b0e17:	48 89 c1             	mov    rcx,rax
   1854b0e1a:	48 83 c0 27          	add    rax,0x27
   1854b0e1e:	48 83 e0 e0          	and    rax,0xffffffffffffffe0
   1854b0e22:	48 89 48 f8          	mov    QWORD PTR [rax-0x8],rcx
   1854b0e26:	eb 2c                	jmp    0x1854b0e54
   1854b0e28:	48 89 d0             	mov    rax,rdx
   1854b0e2b:	48 83 c0 18          	add    rax,0x18
   1854b0e2f:	48 89 5a 28          	mov    QWORD PTR [rdx+0x28],rbx
   1854b0e33:	48 c7 42 30 0f 00 00 	mov    QWORD PTR [rdx+0x30],0xf
   1854b0e3a:	00 
   1854b0e3b:	48 8d 8d a0 01 00 00 	lea    rcx,[rbp+0x1a0]
   1854b0e42:	0f 10 01             	movups xmm0,XMMWORD PTR [rcx]
   1854b0e45:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   1854b0e48:	eb 3c                	jmp    0x1854b0e86
   1854b0e4a:	48 8d 4f 01          	lea    rcx,[rdi+0x1]
   1854b0e4e:	e8 49 aa ff 01       	call   0x1874ab89c
   1854b0e53:	90                   	nop
   1854b0e54:	48 8b 8d 60 02 00 00 	mov    rcx,QWORD PTR [rbp+0x260]
   1854b0e5b:	48 89 41 18          	mov    QWORD PTR [rcx+0x18],rax
   1854b0e5f:	48 89 59 28          	mov    QWORD PTR [rcx+0x28],rbx
   1854b0e63:	48 89 79 30          	mov    QWORD PTR [rcx+0x30],rdi
   1854b0e67:	48 ff c3             	inc    rbx
   1854b0e6a:	48 89 c1             	mov    rcx,rax
   1854b0e6d:	48 89 f2             	mov    rdx,rsi
   1854b0e70:	49 89 d8             	mov    r8,rbx
   1854b0e73:	e8 d8 31 09 02       	call   0x187544050
   1854b0e78:	48 8b 95 60 02 00 00 	mov    rdx,QWORD PTR [rbp+0x260]
   1854b0e7f:	48 8b bd a8 00 00 00 	mov    rdi,QWORD PTR [rbp+0xa8]
   1854b0e86:	48 8d 85 c0 01 00 00 	lea    rax,[rbp+0x1c0]
   1854b0e8d:	4c 89 72 38          	mov    QWORD PTR [rdx+0x38],r14
   1854b0e91:	4c 89 6a 40          	mov    QWORD PTR [rdx+0x40],r13
   1854b0e95:	0f 57 c0             	xorps  xmm0,xmm0
   1854b0e98:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   1854b0e9b:	4c 89 7a 48          	mov    QWORD PTR [rdx+0x48],r15
   1854b0e9f:	4c 89 62 50          	mov    QWORD PTR [rdx+0x50],r12
   1854b0ea3:	0f 11 40 10          	movups XMMWORD PTR [rax+0x10],xmm0
   1854b0ea7:	48 89 55 38          	mov    QWORD PTR [rbp+0x38],rdx
   1854b0eab:	c6 85 77 02 00 00 01 	mov    BYTE PTR [rbp+0x277],0x1
   1854b0eb2:	48 8d 15 f7 65 34 04 	lea    rdx,[rip+0x43465f7]        # 0x1897f74b0
   1854b0eb9:	4c 8d 05 f0 4b 35 04 	lea    r8,[rip+0x4354bf0]        # 0x189805ab0
   1854b0ec0:	48 8d 8d 10 01 00 00 	lea    rcx,[rbp+0x110]
   1854b0ec7:	41 b9 95 00 00 00    	mov    r9d,0x95
   1854b0ecd:	e8 2e 96 ce fa       	call   0x18019a500
   1854b0ed2:	90                   	nop
   1854b0ed3:	c6 85 77 02 00 00 00 	mov    BYTE PTR [rbp+0x277],0x0
   1854b0eda:	c7 44 24 20 01 00 00 	mov    DWORD PTR [rsp+0x20],0x1
   1854b0ee1:	00 
   1854b0ee2:	48 8d 95 90 00 00 00 	lea    rdx,[rbp+0x90]
   1854b0ee9:	4c 8d 85 10 01 00 00 	lea    r8,[rbp+0x110]
   1854b0ef0:	49 89 e9             	mov    r9,rbp
   1854b0ef3:	48 89 f9             	mov    rcx,rdi
   1854b0ef6:	e8 15 a1 e4 fa       	call   0x1802fb010
   1854b0efb:	90                   	nop
   1854b0efc:	48 8b b5 98 00 00 00 	mov    rsi,QWORD PTR [rbp+0x98]
   1854b0f03:	48 85 f6             	test   rsi,rsi
   1854b0f06:	48 8b 9d a0 00 00 00 	mov    rbx,QWORD PTR [rbp+0xa0]
   1854b0f0d:	74 1d                	je     0x1854b0f2c
   1854b0f0f:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   1854b0f13:	75 17                	jne    0x1854b0f2c
   1854b0f15:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1854b0f18:	48 89 f1             	mov    rcx,rsi
   1854b0f1b:	ff 10                	call   QWORD PTR [rax]
   1854b0f1d:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   1854b0f21:	75 09                	jne    0x1854b0f2c
   1854b0f23:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1854b0f26:	48 89 f1             	mov    rcx,rsi
   1854b0f29:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1854b0f2c:	48 8d 8d 90 01 00 00 	lea    rcx,[rbp+0x190]
   1854b0f33:	e8 88 0a 00 00       	call   0x1854b19c0
   1854b0f38:	48 8b b5 b8 00 00 00 	mov    rsi,QWORD PTR [rbp+0xb8]
   1854b0f3f:	48 85 f6             	test   rsi,rsi
   1854b0f42:	48 8b bd 68 02 00 00 	mov    rdi,QWORD PTR [rbp+0x268]
   1854b0f49:	74 1d                	je     0x1854b0f68
   1854b0f4b:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   1854b0f4f:	75 17                	jne    0x1854b0f68
   1854b0f51:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1854b0f54:	48 89 f1             	mov    rcx,rsi
   1854b0f57:	ff 10                	call   QWORD PTR [rax]
   1854b0f59:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   1854b0f5d:	75 09                	jne    0x1854b0f68
   1854b0f5f:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1854b0f62:	48 89 f1             	mov    rcx,rsi
   1854b0f65:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1854b0f68:	48 85 ff             	test   rdi,rdi
   1854b0f6b:	74 22                	je     0x1854b0f8f
   1854b0f6d:	f0 ff 0b             	lock dec DWORD PTR [rbx]
   1854b0f70:	75 1d                	jne    0x1854b0f8f
   1854b0f72:	48 89 fe             	mov    rsi,rdi
   1854b0f75:	48 83 c6 0c          	add    rsi,0xc
   1854b0f79:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1854b0f7c:	48 89 f9             	mov    rcx,rdi
   1854b0f7f:	ff 10                	call   QWORD PTR [rax]
   1854b0f81:	f0 ff 0e             	lock dec DWORD PTR [rsi]
   1854b0f84:	75 09                	jne    0x1854b0f8f
   1854b0f86:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1854b0f89:	48 89 f9             	mov    rcx,rdi
   1854b0f8c:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1854b0f8f:	48 8b b5 48 02 00 00 	mov    rsi,QWORD PTR [rbp+0x248]
   1854b0f96:	48 85 f6             	test   rsi,rsi
   1854b0f99:	74 1d                	je     0x1854b0fb8
   1854b0f9b:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   1854b0f9f:	75 17                	jne    0x1854b0fb8
   1854b0fa1:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1854b0fa4:	48 89 f1             	mov    rcx,rsi
   1854b0fa7:	ff 10                	call   QWORD PTR [rax]
   1854b0fa9:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   1854b0fad:	75 09                	jne    0x1854b0fb8
   1854b0faf:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1854b0fb2:	48 89 f1             	mov    rcx,rsi
   1854b0fb5:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1854b0fb8:	48 8b b5 28 02 00 00 	mov    rsi,QWORD PTR [rbp+0x228]
   1854b0fbf:	48 85 f6             	test   rsi,rsi
   1854b0fc2:	74 1d                	je     0x1854b0fe1
   1854b0fc4:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   1854b0fc8:	75 17                	jne    0x1854b0fe1
   1854b0fca:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1854b0fcd:	48 89 f1             	mov    rcx,rsi
   1854b0fd0:	ff 10                	call   QWORD PTR [rax]
   1854b0fd2:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   1854b0fd6:	75 09                	jne    0x1854b0fe1
   1854b0fd8:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1854b0fdb:	48 89 f1             	mov    rcx,rsi
   1854b0fde:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1854b0fe1:	48 8b b5 08 01 00 00 	mov    rsi,QWORD PTR [rbp+0x108]
   1854b0fe8:	48 85 f6             	test   rsi,rsi
   1854b0feb:	74 1d                	je     0x1854b100a
   1854b0fed:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   1854b0ff1:	75 17                	jne    0x1854b100a
   1854b0ff3:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1854b0ff6:	48 89 f1             	mov    rcx,rsi
   1854b0ff9:	ff 10                	call   QWORD PTR [rax]
   1854b0ffb:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   1854b0fff:	75 09                	jne    0x1854b100a
   1854b1001:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1854b1004:	48 89 f1             	mov    rcx,rsi
   1854b1007:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1854b100a:	48 8b 8d 58 02 00 00 	mov    rcx,QWORD PTR [rbp+0x258]
   1854b1011:	e8 3a 60 c5 fa       	call   0x180107050
   1854b1016:	0f 28 b5 80 02 00 00 	movaps xmm6,XMMWORD PTR [rbp+0x280]
   1854b101d:	48 81 c4 18 03 00 00 	add    rsp,0x318
   1854b1024:	5b                   	pop    rbx
   1854b1025:	5f                   	pop    rdi
   1854b1026:	5e                   	pop    rsi
   1854b1027:	41 5c                	pop    r12
   1854b1029:	41 5d                	pop    r13
   1854b102b:	41 5e                	pop    r14
   1854b102d:	41 5f                	pop    r15
   1854b102f:	5d                   	pop    rbp
   1854b1030:	c3                   	ret
   1854b1031:	e8 56 c3 05 02       	call   0x18750d38c
   1854b1036:	90                   	nop
   1854b1037:	e8 54 7b b5 fa       	call   0x180008b90
   1854b103c:	90                   	nop
   1854b103d:	cc                   	int3
