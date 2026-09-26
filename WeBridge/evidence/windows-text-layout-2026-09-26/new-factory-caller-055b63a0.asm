
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

00000001855b63a0 <.text+0x55b53a0>:
   1855b63a0:	55                   	push   rbp
   1855b63a1:	41 57                	push   r15
   1855b63a3:	41 56                	push   r14
   1855b63a5:	56                   	push   rsi
   1855b63a6:	57                   	push   rdi
   1855b63a7:	53                   	push   rbx
   1855b63a8:	48 81 ec e8 02 00 00 	sub    rsp,0x2e8
   1855b63af:	48 8d ac 24 80 00 00 	lea    rbp,[rsp+0x80]
   1855b63b6:	00 
   1855b63b7:	0f 29 b5 50 02 00 00 	movaps XMMWORD PTR [rbp+0x250],xmm6
   1855b63be:	48 c7 85 48 02 00 00 	mov    QWORD PTR [rbp+0x248],0xfffffffffffffffe
   1855b63c5:	fe ff ff ff 
   1855b63c9:	48 89 d6             	mov    rsi,rdx
   1855b63cc:	48 89 cf             	mov    rdi,rcx
   1855b63cf:	e8 3c f9 a8 fa       	call   0x180045d10
   1855b63d4:	48 8b 10             	mov    rdx,QWORD PTR [rax]
   1855b63d7:	48 89 c1             	mov    rcx,rax
   1855b63da:	ff 52 68             	call   QWORD PTR [rdx+0x68]
   1855b63dd:	bb 01 00 00 00       	mov    ebx,0x1
   1855b63e2:	84 c0                	test   al,al
   1855b63e4:	0f 84 d3 31 00 00    	je     0x1855b95bd
   1855b63ea:	b9 02 00 00 00       	mov    ecx,0x2
   1855b63ef:	e8 ec 69 ab fa       	call   0x18006cde0
   1855b63f4:	85 c0                	test   eax,eax
   1855b63f6:	0f 84 65 02 00 00    	je     0x1855b6661
   1855b63fc:	48 8d 5d 50          	lea    rbx,[rbp+0x50]
   1855b6400:	48 89 d9             	mov    rcx,rbx
   1855b6403:	e8 08 6b ab fa       	call   0x18006cf10
   1855b6408:	48 83 7d 68 10       	cmp    QWORD PTR [rbp+0x68],0x10
   1855b640d:	72 04                	jb     0x1855b6413
   1855b640f:	48 8b 5d 50          	mov    rbx,QWORD PTR [rbp+0x50]
   1855b6413:	48 8d 05 c6 b4 26 04 	lea    rax,[rip+0x426b4c6]        # 0x1898218e0
   1855b641a:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1855b641f:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   1855b6426:	00 00 
   1855b6428:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   1855b642d:	c7 44 24 28 80 01 00 	mov    DWORD PTR [rsp+0x28],0x180
   1855b6434:	00 
   1855b6435:	4c 8d 0d 04 b5 26 04 	lea    r9,[rip+0x426b504]        # 0x189821940
   1855b643c:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b6443:	ba 02 00 00 00       	mov    edx,0x2
   1855b6448:	49 89 d8             	mov    r8,rbx
   1855b644b:	e8 20 6e ab fa       	call   0x18006d270
   1855b6450:	90                   	nop
   1855b6451:	8b 57 08             	mov    edx,DWORD PTR [rdi+0x8]
   1855b6454:	48 c7 85 70 01 00 00 	mov    QWORD PTR [rbp+0x170],0x0
   1855b645b:	00 00 00 00 
   1855b645f:	b8 07 00 00 00       	mov    eax,0x7
   1855b6464:	48 8d 8d 77 01 00 00 	lea    rcx,[rbp+0x177]
   1855b646b:	41 b9 cd cc cc cc    	mov    r9d,0xcccccccd
   1855b6471:	4c 8d 05 f8 fd 78 03 	lea    r8,[rip+0x378fdf8]        # 0x188d46270
   1855b6478:	0f 1f 84 00 00 00 00 	nop    DWORD PTR [rax+rax*1+0x0]
   1855b647f:	00 
   1855b6480:	41 89 d2             	mov    r10d,edx
   1855b6483:	4d 0f af d1          	imul   r10,r9
   1855b6487:	49 c1 ea 23          	shr    r10,0x23
   1855b648b:	47 8d 1c 12          	lea    r11d,[r10+r10*1]
   1855b648f:	47 8d 1c 9b          	lea    r11d,[r11+r11*4]
   1855b6493:	41 f7 db             	neg    r11d
   1855b6496:	41 01 d3             	add    r11d,edx
   1855b6499:	41 83 c3 23          	add    r11d,0x23
   1855b649d:	47 0f b6 1c 03       	movzx  r11d,BYTE PTR [r11+r8*1]
   1855b64a2:	44 88 59 01          	mov    BYTE PTR [rcx+0x1],r11b
   1855b64a6:	48 ff c1             	inc    rcx
   1855b64a9:	48 ff c0             	inc    rax
   1855b64ac:	83 fa 09             	cmp    edx,0x9
   1855b64af:	44 89 d2             	mov    edx,r10d
   1855b64b2:	77 cc                	ja     0x1855b6480
   1855b64b4:	48 8d 95 78 01 00 00 	lea    rdx,[rbp+0x178]
   1855b64bb:	c6 41 01 00          	mov    BYTE PTR [rcx+0x1],0x0
   1855b64bf:	48 83 f8 09          	cmp    rax,0x9
   1855b64c3:	72 27                	jb     0x1855b64ec
   1855b64c5:	48 8d 85 79 01 00 00 	lea    rax,[rbp+0x179]
   1855b64cc:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
   1855b64d0:	44 0f b6 09          	movzx  r9d,BYTE PTR [rcx]
   1855b64d4:	44 0f b6 50 ff       	movzx  r10d,BYTE PTR [rax-0x1]
   1855b64d9:	44 88 11             	mov    BYTE PTR [rcx],r10b
   1855b64dc:	48 ff c9             	dec    rcx
   1855b64df:	44 88 48 ff          	mov    BYTE PTR [rax-0x1],r9b
   1855b64e3:	48 39 c8             	cmp    rax,rcx
   1855b64e6:	48 8d 40 01          	lea    rax,[rax+0x1]
   1855b64ea:	72 e4                	jb     0x1855b64d0
   1855b64ec:	48 89 95 70 01 00 00 	mov    QWORD PTR [rbp+0x170],rdx
   1855b64f3:	48 83 7f 28 10       	cmp    QWORD PTR [rdi+0x28],0x10
   1855b64f8:	72 06                	jb     0x1855b6500
   1855b64fa:	48 8b 47 10          	mov    rax,QWORD PTR [rdi+0x10]
   1855b64fe:	eb 04                	jmp    0x1855b6504
   1855b6500:	48 8d 47 10          	lea    rax,[rdi+0x10]
   1855b6504:	48 89 45 70          	mov    QWORD PTR [rbp+0x70],rax
   1855b6508:	c6 45 78 00          	mov    BYTE PTR [rbp+0x78],0x0
   1855b650c:	48 8b 8f f0 06 00 00 	mov    rcx,QWORD PTR [rdi+0x6f0]
   1855b6513:	48 c7 45 f0 00 00 00 	mov    QWORD PTR [rbp-0x10],0x0
   1855b651a:	00 
   1855b651b:	41 ba 07 00 00 00    	mov    r10d,0x7
   1855b6521:	4c 8d 4d f7          	lea    r9,[rbp-0x9]
   1855b6525:	49 bb cd cc cc cc cc 	movabs r11,0xcccccccccccccccd
   1855b652c:	cc cc cc 
   1855b652f:	90                   	nop
   1855b6530:	48 89 c8             	mov    rax,rcx
   1855b6533:	49 f7 e3             	mul    r11
   1855b6536:	48 c1 ea 03          	shr    rdx,0x3
   1855b653a:	48 8d 04 12          	lea    rax,[rdx+rdx*1]
   1855b653e:	48 8d 04 80          	lea    rax,[rax+rax*4]
   1855b6542:	4c 89 c3             	mov    rbx,r8
   1855b6545:	48 29 c3             	sub    rbx,rax
   1855b6548:	0f b6 44 0b 23       	movzx  eax,BYTE PTR [rbx+rcx*1+0x23]
   1855b654d:	41 88 41 01          	mov    BYTE PTR [r9+0x1],al
   1855b6551:	49 ff c1             	inc    r9
   1855b6554:	49 ff c2             	inc    r10
   1855b6557:	48 83 f9 09          	cmp    rcx,0x9
   1855b655b:	48 89 d1             	mov    rcx,rdx
   1855b655e:	77 d0                	ja     0x1855b6530
   1855b6560:	48 8d 45 f8          	lea    rax,[rbp-0x8]
   1855b6564:	41 c6 41 01 00       	mov    BYTE PTR [r9+0x1],0x0
   1855b6569:	49 83 fa 09          	cmp    r10,0x9
   1855b656d:	72 2c                	jb     0x1855b659b
   1855b656f:	48 8d 4d f9          	lea    rcx,[rbp-0x7]
   1855b6573:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
   1855b657a:	84 00 00 00 00 00 
   1855b6580:	41 0f b6 11          	movzx  edx,BYTE PTR [r9]
   1855b6584:	44 0f b6 41 ff       	movzx  r8d,BYTE PTR [rcx-0x1]
   1855b6589:	45 88 01             	mov    BYTE PTR [r9],r8b
   1855b658c:	49 ff c9             	dec    r9
   1855b658f:	88 51 ff             	mov    BYTE PTR [rcx-0x1],dl
   1855b6592:	4c 39 c9             	cmp    rcx,r9
   1855b6595:	48 8d 49 01          	lea    rcx,[rcx+0x1]
   1855b6599:	72 e5                	jb     0x1855b6580
   1855b659b:	48 89 45 f0          	mov    QWORD PTR [rbp-0x10],rax
   1855b659f:	0f 57 c0             	xorps  xmm0,xmm0
   1855b65a2:	0f 11 85 28 02 00 00 	movups XMMWORD PTR [rbp+0x228],xmm0
   1855b65a9:	0f 11 85 18 02 00 00 	movups XMMWORD PTR [rbp+0x218],xmm0
   1855b65b0:	0f 11 85 08 02 00 00 	movups XMMWORD PTR [rbp+0x208],xmm0
   1855b65b7:	0f 11 85 f8 01 00 00 	movups XMMWORD PTR [rbp+0x1f8],xmm0
   1855b65be:	0f 11 85 e8 01 00 00 	movups XMMWORD PTR [rbp+0x1e8],xmm0
   1855b65c5:	0f 11 85 d8 01 00 00 	movups XMMWORD PTR [rbp+0x1d8],xmm0
   1855b65cc:	48 c7 85 38 02 00 00 	mov    QWORD PTR [rbp+0x238],0x0
   1855b65d3:	00 00 00 00 
   1855b65d7:	48 8d 45 f0          	lea    rax,[rbp-0x10]
   1855b65db:	48 89 85 c0 01 00 00 	mov    QWORD PTR [rbp+0x1c0],rax
   1855b65e2:	48 8d 45 70          	lea    rax,[rbp+0x70]
   1855b65e6:	48 89 85 c8 01 00 00 	mov    QWORD PTR [rbp+0x1c8],rax
   1855b65ed:	48 8d 85 70 01 00 00 	lea    rax,[rbp+0x170]
   1855b65f4:	48 89 85 d0 01 00 00 	mov    QWORD PTR [rbp+0x1d0],rax
   1855b65fb:	48 8d 15 86 b5 26 04 	lea    rdx,[rip+0x426b586]        # 0x189821b88
   1855b6602:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b6609:	4c 8d 85 c0 01 00 00 	lea    r8,[rbp+0x1c0]
   1855b6610:	e8 fb 71 ab fa       	call   0x18006d810
   1855b6615:	90                   	nop
   1855b6616:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b661d:	e8 4e 6d ab fa       	call   0x18006d370
   1855b6622:	48 8b 45 68          	mov    rax,QWORD PTR [rbp+0x68]
   1855b6626:	48 83 f8 10          	cmp    rax,0x10
   1855b662a:	72 35                	jb     0x1855b6661
   1855b662c:	48 8b 4d 50          	mov    rcx,QWORD PTR [rbp+0x50]
   1855b6630:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1855b6634:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1855b663b:	72 1f                	jb     0x1855b665c
   1855b663d:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1855b6641:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1855b6645:	4c 29 c1             	sub    rcx,r8
   1855b6648:	48 83 f9 20          	cmp    rcx,0x20
   1855b664c:	0f 83 85 2f 00 00    	jae    0x1855b95d7
   1855b6652:	48 83 c0 28          	add    rax,0x28
   1855b6656:	48 89 c2             	mov    rdx,rax
   1855b6659:	4c 89 c1             	mov    rcx,r8
   1855b665c:	e8 7f 52 ef 01       	call   0x1874ab8e0
   1855b6661:	8b 47 08             	mov    eax,DWORD PTR [rdi+0x8]
   1855b6664:	bb 02 00 00 00       	mov    ebx,0x2
   1855b6669:	8d 48 ff             	lea    ecx,[rax-0x1]
   1855b666c:	83 f9 24             	cmp    ecx,0x24
   1855b666f:	0f 87 ab 01 00 00    	ja     0x1855b6820
   1855b6675:	48 8d 05 38 b8 26 04 	lea    rax,[rip+0x426b838]        # 0x189821eb4
   1855b667c:	48 63 0c 88          	movsxd rcx,DWORD PTR [rax+rcx*4]
   1855b6680:	48 01 c1             	add    rcx,rax
   1855b6683:	ff e1                	jmp    rcx
   1855b6685:	0f 28 35 24 f5 78 03 	movaps xmm6,XMMWORD PTR [rip+0x378f524]        # 0x188d45bb0
   1855b668c:	0f 29 75 40          	movaps XMMWORD PTR [rbp+0x40],xmm6
   1855b6690:	48 8d 4d 40          	lea    rcx,[rbp+0x40]
   1855b6694:	e8 37 01 97 fd       	call   0x182f267d0
   1855b6699:	48 8b 45 40          	mov    rax,QWORD PTR [rbp+0x40]
   1855b669d:	c7 80 18 01 00 00 2b 	mov    DWORD PTR [rax+0x118],0x2b
   1855b66a4:	00 00 00 
   1855b66a7:	0f 29 b5 80 00 00 00 	movaps XMMWORD PTR [rbp+0x80],xmm6
   1855b66ae:	0f 29 75 70          	movaps XMMWORD PTR [rbp+0x70],xmm6
   1855b66b2:	48 8d 4d 70          	lea    rcx,[rbp+0x70]
   1855b66b6:	41 b8 01 00 00 00    	mov    r8d,0x1
   1855b66bc:	48 89 fa             	mov    rdx,rdi
   1855b66bf:	45 31 c9             	xor    r9d,r9d
   1855b66c2:	e8 69 d2 fa fe       	call   0x184563930
   1855b66c7:	90                   	nop
   1855b66c8:	0f 29 75 00          	movaps XMMWORD PTR [rbp+0x0],xmm6
   1855b66cc:	0f 29 75 f0          	movaps XMMWORD PTR [rbp-0x10],xmm6
   1855b66d0:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b66d4:	41 b8 01 00 00 00    	mov    r8d,0x1
   1855b66da:	48 89 fa             	mov    rdx,rdi
   1855b66dd:	e8 7e 9a fa fe       	call   0x184560160
   1855b66e2:	90                   	nop
   1855b66e3:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b66e7:	e8 e4 80 dd fa       	call   0x18038e7d0
   1855b66ec:	90                   	nop
   1855b66ed:	84 c0                	test   al,al
   1855b66ef:	75 68                	jne    0x1855b6759
   1855b66f1:	48 8d 4d 70          	lea    rcx,[rbp+0x70]
   1855b66f5:	e8 d6 80 dd fa       	call   0x18038e7d0
   1855b66fa:	90                   	nop
   1855b66fb:	84 c0                	test   al,al
   1855b66fd:	74 5a                	je     0x1855b6759
   1855b66ff:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b6703:	48 8d 95 e0 00 00 00 	lea    rdx,[rbp+0xe0]
   1855b670a:	e8 61 93 ae fa       	call   0x18009fa70
   1855b670f:	90                   	nop
   1855b6710:	48 8d 4d 70          	lea    rcx,[rbp+0x70]
   1855b6714:	48 8d 95 c0 01 00 00 	lea    rdx,[rbp+0x1c0]
   1855b671b:	e8 50 93 ae fa       	call   0x18009fa70
   1855b6720:	90                   	nop
   1855b6721:	48 8d 8d c0 01 00 00 	lea    rcx,[rbp+0x1c0]
   1855b6728:	48 8d 95 e0 00 00 00 	lea    rdx,[rbp+0xe0]
   1855b672f:	41 b8 07 00 00 00    	mov    r8d,0x7
   1855b6735:	41 b9 01 00 00 00    	mov    r9d,0x1
   1855b673b:	e8 30 9c 4c fb       	call   0x180a80370
   1855b6740:	90                   	nop
   1855b6741:	48 8d 8d c0 01 00 00 	lea    rcx,[rbp+0x1c0]
   1855b6748:	e8 c3 b8 a4 fa       	call   0x180002010
   1855b674d:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b6754:	e8 b7 b8 a4 fa       	call   0x180002010
   1855b6759:	bb 20 01 00 00       	mov    ebx,0x120
   1855b675e:	48 8b 4d 40          	mov    rcx,QWORD PTR [rbp+0x40]
   1855b6762:	48 01 d9             	add    rcx,rbx
   1855b6765:	48 8d 55 f0          	lea    rdx,[rbp-0x10]
   1855b6769:	e8 62 4e ae fa       	call   0x18009b5d0
   1855b676e:	90                   	nop
   1855b676f:	48 03 5d 40          	add    rbx,QWORD PTR [rbp+0x40]
   1855b6773:	48 89 d9             	mov    rcx,rbx
   1855b6776:	e8 55 80 dd fa       	call   0x18038e7d0
   1855b677b:	90                   	nop
   1855b677c:	84 c0                	test   al,al
   1855b677e:	0f 84 32 09 00 00    	je     0x1855b70b6
   1855b6784:	48 8b 45 48          	mov    rax,QWORD PTR [rbp+0x48]
   1855b6788:	48 85 c0             	test   rax,rax
   1855b678b:	0f 84 e9 18 00 00    	je     0x1855b807a
   1855b6791:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   1855b6795:	48 8b 45 48          	mov    rax,QWORD PTR [rbp+0x48]
   1855b6799:	e9 de 18 00 00       	jmp    0x1855b807c
   1855b679e:	0f 28 05 0b f4 78 03 	movaps xmm0,XMMWORD PTR [rip+0x378f40b]        # 0x188d45bb0
   1855b67a5:	0f 29 85 c0 01 00 00 	movaps XMMWORD PTR [rbp+0x1c0],xmm0
   1855b67ac:	48 8d 8d c0 01 00 00 	lea    rcx,[rbp+0x1c0]
   1855b67b3:	e8 18 41 00 00       	call   0x1855ba8d0
   1855b67b8:	48 8b 85 c0 01 00 00 	mov    rax,QWORD PTR [rbp+0x1c0]
   1855b67bf:	48 b9 31 00 00 00 03 	movabs rcx,0x300000031
   1855b67c6:	00 00 00 
   1855b67c9:	48 89 88 18 01 00 00 	mov    QWORD PTR [rax+0x118],rcx
   1855b67d0:	4c 8d 8f 90 00 00 00 	lea    r9,[rdi+0x90]
   1855b67d7:	48 8d 98 98 07 00 00 	lea    rbx,[rax+0x798]
   1855b67de:	4c 39 cb             	cmp    rbx,r9
   1855b67e1:	0f 84 d6 0a 00 00    	je     0x1855b72bd
   1855b67e7:	4c 8b b7 a0 00 00 00 	mov    r14,QWORD PTR [rdi+0xa0]
   1855b67ee:	48 83 bf a8 00 00 00 	cmp    QWORD PTR [rdi+0xa8],0x10
   1855b67f5:	10 
   1855b67f6:	72 07                	jb     0x1855b67ff
   1855b67f8:	4c 8b 8f 90 00 00 00 	mov    r9,QWORD PTR [rdi+0x90]
   1855b67ff:	48 8b 88 b0 07 00 00 	mov    rcx,QWORD PTR [rax+0x7b0]
   1855b6806:	49 39 ce             	cmp    r14,rcx
   1855b6809:	0f 86 8b 0a 00 00    	jbe    0x1855b729a
   1855b680f:	48 89 d9             	mov    rcx,rbx
   1855b6812:	4c 89 f2             	mov    rdx,r14
   1855b6815:	e8 36 79 a8 fa       	call   0x18003e150
   1855b681a:	90                   	nop
   1855b681b:	e9 9d 0a 00 00       	jmp    0x1855b72bd
   1855b6820:	3d 97 27 00 00       	cmp    eax,0x2797
   1855b6825:	0f 85 92 2d 00 00    	jne    0x1855b95bd
   1855b682b:	0f 28 35 7e f3 78 03 	movaps xmm6,XMMWORD PTR [rip+0x378f37e]        # 0x188d45bb0
   1855b6832:	0f 29 b5 e0 00 00 00 	movaps XMMWORD PTR [rbp+0xe0],xmm6
   1855b6839:	b9 04 00 00 00       	mov    ecx,0x4
   1855b683e:	e8 59 50 ef 01       	call   0x1874ab89c
   1855b6843:	48 89 45 c8          	mov    QWORD PTR [rbp-0x38],rax
   1855b6847:	48 8d 48 04          	lea    rcx,[rax+0x4]
   1855b684b:	48 89 4d d8          	mov    QWORD PTR [rbp-0x28],rcx
   1855b684f:	c7 00 00 00 00 00    	mov    DWORD PTR [rax],0x0
   1855b6855:	48 89 4d d0          	mov    QWORD PTR [rbp-0x30],rcx
   1855b6859:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b6860:	4c 8d 45 c8          	lea    r8,[rbp-0x38]
   1855b6864:	48 89 fa             	mov    rdx,rdi
   1855b6867:	41 b9 87 00 00 00    	mov    r9d,0x87
   1855b686d:	e8 ee 76 52 fe       	call   0x183addf60
   1855b6872:	48 8b 85 e0 00 00 00 	mov    rax,QWORD PTR [rbp+0xe0]
   1855b6879:	48 85 c0             	test   rax,rax
   1855b687c:	0f 84 c8 24 00 00    	je     0x1855b8d4a
   1855b6882:	0f 29 b5 c0 01 00 00 	movaps XMMWORD PTR [rbp+0x1c0],xmm6
   1855b6889:	0f 57 c0             	xorps  xmm0,xmm0
   1855b688c:	0f 29 45 e0          	movaps XMMWORD PTR [rbp-0x20],xmm0
   1855b6890:	48 8b 8d e8 00 00 00 	mov    rcx,QWORD PTR [rbp+0xe8]
   1855b6897:	48 85 c9             	test   rcx,rcx
   1855b689a:	0f 84 d7 2a 00 00    	je     0x1855b9377
   1855b68a0:	f0 ff 41 08          	lock inc DWORD PTR [rcx+0x8]
   1855b68a4:	48 8b 85 e0 00 00 00 	mov    rax,QWORD PTR [rbp+0xe0]
   1855b68ab:	48 8b 8d e8 00 00 00 	mov    rcx,QWORD PTR [rbp+0xe8]
   1855b68b2:	e9 c2 2a 00 00       	jmp    0x1855b9379
   1855b68b7:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1855b68ba:	48 8d 95 e0 00 00 00 	lea    rdx,[rbp+0xe0]
   1855b68c1:	48 89 f9             	mov    rcx,rdi
   1855b68c4:	ff 50 18             	call   QWORD PTR [rax+0x18]
   1855b68c7:	48 8b 8d e0 00 00 00 	mov    rcx,QWORD PTR [rbp+0xe0]
   1855b68ce:	c7 44 24 20 00 00 00 	mov    DWORD PTR [rsp+0x20],0x0
   1855b68d5:	00 
   1855b68d6:	4c 8d 05 43 c6 b3 05 	lea    r8,[rip+0x5b3c643]        # 0x18b0f2f20
   1855b68dd:	4c 8d 0d 6c c6 b3 05 	lea    r9,[rip+0x5b3c66c]        # 0x18b0f2f50
   1855b68e4:	31 d2                	xor    edx,edx
   1855b68e6:	e8 01 d1 f3 01       	call   0x1874f39ec
   1855b68eb:	90                   	nop
   1855b68ec:	48 85 c0             	test   rax,rax
   1855b68ef:	0f 84 1f 16 00 00    	je     0x1855b7f14
   1855b68f5:	48 89 45 70          	mov    QWORD PTR [rbp+0x70],rax
   1855b68f9:	48 8b 85 e8 00 00 00 	mov    rax,QWORD PTR [rbp+0xe8]
   1855b6900:	48 89 45 78          	mov    QWORD PTR [rbp+0x78],rax
   1855b6904:	48 8b 4d 70          	mov    rcx,QWORD PTR [rbp+0x70]
   1855b6908:	48 85 c9             	test   rcx,rcx
   1855b690b:	0f 84 c6 2a 00 00    	je     0x1855b93d7
   1855b6911:	0f 57 c0             	xorps  xmm0,xmm0
   1855b6914:	0f 29 45 f0          	movaps XMMWORD PTR [rbp-0x10],xmm0
   1855b6918:	48 8d 55 f0          	lea    rdx,[rbp-0x10]
   1855b691c:	e8 7f 45 00 00       	call   0x1855baea0
   1855b6921:	90                   	nop
   1855b6922:	48 89 c3             	mov    rbx,rax
   1855b6925:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   1855b6929:	48 85 c0             	test   rax,rax
   1855b692c:	0f 84 8c 28 00 00    	je     0x1855b91be
   1855b6932:	c7 80 1c 01 00 00 18 	mov    DWORD PTR [rax+0x11c],0x18
   1855b6939:	00 00 00 
   1855b693c:	e9 b3 03 00 00       	jmp    0x1855b6cf4
   1855b6941:	0f 28 35 68 f2 78 03 	movaps xmm6,XMMWORD PTR [rip+0x378f268]        # 0x188d45bb0
   1855b6948:	0f 29 b5 c0 01 00 00 	movaps XMMWORD PTR [rbp+0x1c0],xmm6
   1855b694f:	48 8d 8d c0 01 00 00 	lea    rcx,[rbp+0x1c0]
   1855b6956:	e8 65 48 64 fc       	call   0x181bfb1c0
   1855b695b:	48 8b 85 c0 01 00 00 	mov    rax,QWORD PTR [rbp+0x1c0]
   1855b6962:	c7 80 18 01 00 00 2f 	mov    DWORD PTR [rax+0x118],0x2f
   1855b6969:	00 00 00 
   1855b696c:	b9 f0 01 00 00       	mov    ecx,0x1f0
   1855b6971:	e8 26 4f ef 01       	call   0x1874ab89c
   1855b6976:	90                   	nop
   1855b6977:	49 89 c6             	mov    r14,rax
   1855b697a:	48 b9 01 00 00 00 01 	movabs rcx,0x100000001
   1855b6981:	00 00 00 
   1855b6984:	48 89 48 08          	mov    QWORD PTR [rax+0x8],rcx
   1855b6988:	48 8d 0d 79 e9 8f 03 	lea    rcx,[rip+0x38fe979]        # 0x188eb5308
   1855b698f:	48 89 08             	mov    QWORD PTR [rax],rcx
   1855b6992:	4c 8d 78 10          	lea    r15,[rax+0x10]
   1855b6996:	48 83 c0 18          	add    rax,0x18
   1855b699a:	31 db                	xor    ebx,ebx
   1855b699c:	41 b8 98 01 00 00    	mov    r8d,0x198
   1855b69a2:	48 89 c1             	mov    rcx,rax
   1855b69a5:	31 d2                	xor    edx,edx
   1855b69a7:	e8 44 dd f8 01       	call   0x1875446f0
   1855b69ac:	49 c7 46 38 0f 00 00 	mov    QWORD PTR [r14+0x38],0xf
   1855b69b3:	00 
   1855b69b4:	0f 57 c0             	xorps  xmm0,xmm0
   1855b69b7:	41 0f 11 46 40       	movups XMMWORD PTR [r14+0x40],xmm0
   1855b69bc:	49 c7 46 50 00 00 00 	mov    QWORD PTR [r14+0x50],0x0
   1855b69c3:	00 
   1855b69c4:	49 c7 46 58 0f 00 00 	mov    QWORD PTR [r14+0x58],0xf
   1855b69cb:	00 
   1855b69cc:	41 0f 11 46 60       	movups XMMWORD PTR [r14+0x60],xmm0
   1855b69d1:	49 c7 46 70 00 00 00 	mov    QWORD PTR [r14+0x70],0x0
   1855b69d8:	00 
   1855b69d9:	49 c7 46 78 0f 00 00 	mov    QWORD PTR [r14+0x78],0xf
   1855b69e0:	00 
   1855b69e1:	41 0f 11 86 80 00 00 	movups XMMWORD PTR [r14+0x80],xmm0
   1855b69e8:	00 
   1855b69e9:	49 c7 86 90 00 00 00 	mov    QWORD PTR [r14+0x90],0x0
   1855b69f0:	00 00 00 00 
   1855b69f4:	49 c7 86 98 00 00 00 	mov    QWORD PTR [r14+0x98],0xf
   1855b69fb:	0f 00 00 00 
   1855b69ff:	41 0f 11 86 a0 00 00 	movups XMMWORD PTR [r14+0xa0],xmm0
   1855b6a06:	00 
   1855b6a07:	49 c7 86 b0 00 00 00 	mov    QWORD PTR [r14+0xb0],0x0
   1855b6a0e:	00 00 00 00 
   1855b6a12:	49 c7 86 b8 00 00 00 	mov    QWORD PTR [r14+0xb8],0xf
   1855b6a19:	0f 00 00 00 
   1855b6a1d:	41 0f 11 86 c0 00 00 	movups XMMWORD PTR [r14+0xc0],xmm0
   1855b6a24:	00 
   1855b6a25:	49 c7 86 d0 00 00 00 	mov    QWORD PTR [r14+0xd0],0x0
   1855b6a2c:	00 00 00 00 
   1855b6a30:	49 c7 86 d8 00 00 00 	mov    QWORD PTR [r14+0xd8],0xf
   1855b6a37:	0f 00 00 00 
   1855b6a3b:	41 0f 11 86 e0 00 00 	movups XMMWORD PTR [r14+0xe0],xmm0
   1855b6a42:	00 
   1855b6a43:	49 c7 86 f0 00 00 00 	mov    QWORD PTR [r14+0xf0],0x0
   1855b6a4a:	00 00 00 00 
   1855b6a4e:	49 c7 86 f8 00 00 00 	mov    QWORD PTR [r14+0xf8],0xf
   1855b6a55:	0f 00 00 00 
   1855b6a59:	41 0f 11 86 00 01 00 	movups XMMWORD PTR [r14+0x100],xmm0
   1855b6a60:	00 
   1855b6a61:	49 c7 86 10 01 00 00 	mov    QWORD PTR [r14+0x110],0x0
   1855b6a68:	00 00 00 00 
   1855b6a6c:	49 c7 86 18 01 00 00 	mov    QWORD PTR [r14+0x118],0xf
   1855b6a73:	0f 00 00 00 
   1855b6a77:	41 0f 11 86 20 01 00 	movups XMMWORD PTR [r14+0x120],xmm0
   1855b6a7e:	00 
   1855b6a7f:	49 c7 86 30 01 00 00 	mov    QWORD PTR [r14+0x130],0x0
   1855b6a86:	00 00 00 00 
   1855b6a8a:	49 c7 86 38 01 00 00 	mov    QWORD PTR [r14+0x138],0xf
   1855b6a91:	0f 00 00 00 
   1855b6a95:	41 0f 11 86 40 01 00 	movups XMMWORD PTR [r14+0x140],xmm0
   1855b6a9c:	00 
   1855b6a9d:	49 c7 86 50 01 00 00 	mov    QWORD PTR [r14+0x150],0x0
   1855b6aa4:	00 00 00 00 
   1855b6aa8:	49 c7 86 58 01 00 00 	mov    QWORD PTR [r14+0x158],0xf
   1855b6aaf:	0f 00 00 00 
   1855b6ab3:	41 0f 11 86 60 01 00 	movups XMMWORD PTR [r14+0x160],xmm0
   1855b6aba:	00 
   1855b6abb:	49 c7 86 70 01 00 00 	mov    QWORD PTR [r14+0x170],0x0
   1855b6ac2:	00 00 00 00 
   1855b6ac6:	49 c7 86 78 01 00 00 	mov    QWORD PTR [r14+0x178],0xf
   1855b6acd:	0f 00 00 00 
   1855b6ad1:	41 0f 11 86 80 01 00 	movups XMMWORD PTR [r14+0x180],xmm0
   1855b6ad8:	00 
   1855b6ad9:	49 c7 86 90 01 00 00 	mov    QWORD PTR [r14+0x190],0x0
   1855b6ae0:	00 00 00 00 
   1855b6ae4:	49 c7 86 98 01 00 00 	mov    QWORD PTR [r14+0x198],0xf
   1855b6aeb:	0f 00 00 00 
   1855b6aef:	41 c7 86 a8 01 00 00 	mov    DWORD PTR [r14+0x1a8],0xffffffff
   1855b6af6:	ff ff ff ff 
   1855b6afa:	48 8d 05 97 1d c5 03 	lea    rax,[rip+0x3c51d97]        # 0x189208898
   1855b6b01:	49 89 46 10          	mov    QWORD PTR [r14+0x10],rax
   1855b6b05:	41 0f 11 86 b0 01 00 	movups XMMWORD PTR [r14+0x1b0],xmm0
   1855b6b0c:	00 
   1855b6b0d:	49 c7 86 c0 01 00 00 	mov    QWORD PTR [r14+0x1c0],0x0
   1855b6b14:	00 00 00 00 
   1855b6b18:	49 c7 86 c8 01 00 00 	mov    QWORD PTR [r14+0x1c8],0xf
   1855b6b1f:	0f 00 00 00 
   1855b6b23:	41 0f 11 86 e0 01 00 	movups XMMWORD PTR [r14+0x1e0],xmm0
   1855b6b2a:	00 
   1855b6b2b:	41 0f 11 86 d0 01 00 	movups XMMWORD PTR [r14+0x1d0],xmm0
   1855b6b32:	00 
   1855b6b33:	4c 89 bd 70 01 00 00 	mov    QWORD PTR [rbp+0x170],r15
   1855b6b3a:	4c 89 b5 78 01 00 00 	mov    QWORD PTR [rbp+0x178],r14
   1855b6b41:	0f 29 75 70          	movaps XMMWORD PTR [rbp+0x70],xmm6
   1855b6b45:	48 8b 87 28 06 00 00 	mov    rax,QWORD PTR [rdi+0x628]
   1855b6b4c:	48 85 c0             	test   rax,rax
   1855b6b4f:	74 0b                	je     0x1855b6b5c
   1855b6b51:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   1855b6b55:	48 8b 9f 28 06 00 00 	mov    rbx,QWORD PTR [rdi+0x628]
   1855b6b5c:	48 8b bf 20 06 00 00 	mov    rdi,QWORD PTR [rdi+0x620]
   1855b6b63:	48 89 7d 70          	mov    QWORD PTR [rbp+0x70],rdi
   1855b6b67:	48 89 5d 78          	mov    QWORD PTR [rbp+0x78],rbx
   1855b6b6b:	48 85 ff             	test   rdi,rdi
   1855b6b6e:	74 56                	je     0x1855b6bc6
   1855b6b70:	48 8b 9d 70 01 00 00 	mov    rbx,QWORD PTR [rbp+0x170]
   1855b6b77:	48 89 d9             	mov    rcx,rbx
   1855b6b7a:	48 89 fa             	mov    rdx,rdi
   1855b6b7d:	e8 ae 82 05 fe       	call   0x18360ee30
   1855b6b82:	90                   	nop
   1855b6b83:	48 8d 57 30          	lea    rdx,[rdi+0x30]
   1855b6b87:	48 89 d9             	mov    rcx,rbx
   1855b6b8a:	e8 31 9f 6f fc       	call   0x181cb0ac0
   1855b6b8f:	90                   	nop
   1855b6b90:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b6b97:	48 89 fa             	mov    rdx,rdi
   1855b6b9a:	45 31 c0             	xor    r8d,r8d
   1855b6b9d:	e8 de 14 91 fb       	call   0x180ec8080
   1855b6ba2:	90                   	nop
   1855b6ba3:	b9 20 01 00 00       	mov    ecx,0x120
   1855b6ba8:	48 03 8d c0 01 00 00 	add    rcx,QWORD PTR [rbp+0x1c0]
   1855b6baf:	48 8d bd e0 00 00 00 	lea    rdi,[rbp+0xe0]
   1855b6bb6:	48 89 fa             	mov    rdx,rdi
   1855b6bb9:	e8 82 4a ae fa       	call   0x18009b640
   1855b6bbe:	48 89 f9             	mov    rcx,rdi
   1855b6bc1:	e8 9a 0e a5 fa       	call   0x180007a60
   1855b6bc6:	48 8b 85 c0 01 00 00 	mov    rax,QWORD PTR [rbp+0x1c0]
   1855b6bcd:	48 8b 8d 78 01 00 00 	mov    rcx,QWORD PTR [rbp+0x178]
   1855b6bd4:	48 85 c9             	test   rcx,rcx
   1855b6bd7:	0f 84 d3 13 00 00    	je     0x1855b7fb0
   1855b6bdd:	f0 ff 41 08          	lock inc DWORD PTR [rcx+0x8]
   1855b6be1:	48 8b 8d 78 01 00 00 	mov    rcx,QWORD PTR [rbp+0x178]
   1855b6be8:	e9 c5 13 00 00       	jmp    0x1855b7fb2
   1855b6bed:	0f 28 05 bc ef 78 03 	movaps xmm0,XMMWORD PTR [rip+0x378efbc]        # 0x188d45bb0
   1855b6bf4:	0f 29 85 e0 00 00 00 	movaps XMMWORD PTR [rbp+0xe0],xmm0
   1855b6bfb:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b6c02:	e8 e9 3e 00 00       	call   0x1855baaf0
   1855b6c07:	48 8b 85 e0 00 00 00 	mov    rax,QWORD PTR [rbp+0xe0]
   1855b6c0e:	48 b9 31 00 00 00 5c 	movabs rcx,0x5c00000031
   1855b6c15:	00 00 00 
   1855b6c18:	48 89 88 18 01 00 00 	mov    QWORD PTR [rax+0x118],rcx
   1855b6c1f:	4c 8d 8f 90 00 00 00 	lea    r9,[rdi+0x90]
   1855b6c26:	48 8d 98 98 07 00 00 	lea    rbx,[rax+0x798]
   1855b6c2d:	4c 39 cb             	cmp    rbx,r9
   1855b6c30:	0f 84 64 15 00 00    	je     0x1855b819a
   1855b6c36:	4c 8b b7 a0 00 00 00 	mov    r14,QWORD PTR [rdi+0xa0]
   1855b6c3d:	48 83 bf a8 00 00 00 	cmp    QWORD PTR [rdi+0xa8],0x10
   1855b6c44:	10 
   1855b6c45:	72 07                	jb     0x1855b6c4e
   1855b6c47:	4c 8b 8f 90 00 00 00 	mov    r9,QWORD PTR [rdi+0x90]
   1855b6c4e:	48 8b 88 b0 07 00 00 	mov    rcx,QWORD PTR [rax+0x7b0]
   1855b6c55:	49 39 ce             	cmp    r14,rcx
   1855b6c58:	0f 86 19 15 00 00    	jbe    0x1855b8177
   1855b6c5e:	48 89 d9             	mov    rcx,rbx
   1855b6c61:	4c 89 f2             	mov    rdx,r14
   1855b6c64:	e8 e7 74 a8 fa       	call   0x18003e150
   1855b6c69:	90                   	nop
   1855b6c6a:	e9 2b 15 00 00       	jmp    0x1855b819a
   1855b6c6f:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1855b6c72:	48 8d 95 e0 00 00 00 	lea    rdx,[rbp+0xe0]
   1855b6c79:	48 89 f9             	mov    rcx,rdi
   1855b6c7c:	ff 50 18             	call   QWORD PTR [rax+0x18]
   1855b6c7f:	48 8b 8d e0 00 00 00 	mov    rcx,QWORD PTR [rbp+0xe0]
   1855b6c86:	c7 44 24 20 00 00 00 	mov    DWORD PTR [rsp+0x20],0x0
   1855b6c8d:	00 
   1855b6c8e:	4c 8d 05 8b c2 b3 05 	lea    r8,[rip+0x5b3c28b]        # 0x18b0f2f20
   1855b6c95:	4c 8d 0d b4 c2 b3 05 	lea    r9,[rip+0x5b3c2b4]        # 0x18b0f2f50
   1855b6c9c:	31 d2                	xor    edx,edx
   1855b6c9e:	e8 49 cd f3 01       	call   0x1874f39ec
   1855b6ca3:	90                   	nop
   1855b6ca4:	48 85 c0             	test   rax,rax
   1855b6ca7:	0f 84 b5 12 00 00    	je     0x1855b7f62
   1855b6cad:	48 89 45 70          	mov    QWORD PTR [rbp+0x70],rax
   1855b6cb1:	48 8b 85 e8 00 00 00 	mov    rax,QWORD PTR [rbp+0xe8]
   1855b6cb8:	48 89 45 78          	mov    QWORD PTR [rbp+0x78],rax
   1855b6cbc:	48 8b 4d 70          	mov    rcx,QWORD PTR [rbp+0x70]
   1855b6cc0:	48 85 c9             	test   rcx,rcx
   1855b6cc3:	0f 84 ea 27 00 00    	je     0x1855b94b3
   1855b6cc9:	0f 57 c0             	xorps  xmm0,xmm0
   1855b6ccc:	0f 29 45 f0          	movaps XMMWORD PTR [rbp-0x10],xmm0
   1855b6cd0:	48 8d 55 f0          	lea    rdx,[rbp-0x10]
   1855b6cd4:	e8 c7 41 00 00       	call   0x1855baea0
   1855b6cd9:	90                   	nop
   1855b6cda:	48 89 c3             	mov    rbx,rax
   1855b6cdd:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   1855b6ce1:	48 85 c0             	test   rax,rax
   1855b6ce4:	0f 84 a0 25 00 00    	je     0x1855b928a
   1855b6cea:	c7 80 1c 01 00 00 13 	mov    DWORD PTR [rax+0x11c],0x13
   1855b6cf1:	00 00 00 
   1855b6cf4:	48 8d 55 f0          	lea    rdx,[rbp-0x10]
   1855b6cf8:	48 89 f1             	mov    rcx,rsi
   1855b6cfb:	e8 40 8b 16 fb       	call   0x18071f840
   1855b6d00:	e9 64 26 00 00       	jmp    0x1855b9369
   1855b6d05:	0f 28 05 a4 ee 78 03 	movaps xmm0,XMMWORD PTR [rip+0x378eea4]        # 0x188d45bb0
   1855b6d0c:	0f 29 85 e0 00 00 00 	movaps XMMWORD PTR [rbp+0xe0],xmm0
   1855b6d13:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b6d1a:	e8 d1 3d 00 00       	call   0x1855baaf0
   1855b6d1f:	48 8b 85 e0 00 00 00 	mov    rax,QWORD PTR [rbp+0xe0]
   1855b6d26:	48 b9 31 00 00 00 5d 	movabs rcx,0x5d00000031
   1855b6d2d:	00 00 00 
   1855b6d30:	48 89 88 18 01 00 00 	mov    QWORD PTR [rax+0x118],rcx
   1855b6d37:	4c 8d 8f 90 00 00 00 	lea    r9,[rdi+0x90]
   1855b6d3e:	48 8d 98 98 07 00 00 	lea    rbx,[rax+0x798]
   1855b6d45:	4c 39 cb             	cmp    rbx,r9
   1855b6d48:	0f 84 c6 14 00 00    	je     0x1855b8214
   1855b6d4e:	4c 8b b7 a0 00 00 00 	mov    r14,QWORD PTR [rdi+0xa0]
   1855b6d55:	48 83 bf a8 00 00 00 	cmp    QWORD PTR [rdi+0xa8],0x10
   1855b6d5c:	10 
   1855b6d5d:	72 07                	jb     0x1855b6d66
   1855b6d5f:	4c 8b 8f 90 00 00 00 	mov    r9,QWORD PTR [rdi+0x90]
   1855b6d66:	48 8b 88 b0 07 00 00 	mov    rcx,QWORD PTR [rax+0x7b0]
   1855b6d6d:	49 39 ce             	cmp    r14,rcx
   1855b6d70:	0f 86 7b 14 00 00    	jbe    0x1855b81f1
   1855b6d76:	48 89 d9             	mov    rcx,rbx
   1855b6d79:	4c 89 f2             	mov    rdx,r14
   1855b6d7c:	e8 cf 73 a8 fa       	call   0x18003e150
   1855b6d81:	90                   	nop
   1855b6d82:	e9 8d 14 00 00       	jmp    0x1855b8214
   1855b6d87:	0f 28 35 22 ee 78 03 	movaps xmm6,XMMWORD PTR [rip+0x378ee22]        # 0x188d45bb0
   1855b6d8e:	0f 29 b5 c0 00 00 00 	movaps XMMWORD PTR [rbp+0xc0],xmm6
   1855b6d95:	48 8d 8d c0 00 00 00 	lea    rcx,[rbp+0xc0]
   1855b6d9c:	e8 bf 45 5f fd       	call   0x182bab360
   1855b6da1:	48 8b 85 c0 00 00 00 	mov    rax,QWORD PTR [rbp+0xc0]
   1855b6da8:	48 b9 31 00 00 00 06 	movabs rcx,0x600000031
   1855b6daf:	00 00 00 
   1855b6db2:	48 89 88 18 01 00 00 	mov    QWORD PTR [rax+0x118],rcx
   1855b6db9:	4c 8d 8f 90 01 00 00 	lea    r9,[rdi+0x190]
   1855b6dc0:	48 8d 98 a8 01 00 00 	lea    rbx,[rax+0x1a8]
   1855b6dc7:	4c 39 cb             	cmp    rbx,r9
   1855b6dca:	0f 84 be 14 00 00    	je     0x1855b828e
   1855b6dd0:	4c 8b b7 a0 01 00 00 	mov    r14,QWORD PTR [rdi+0x1a0]
   1855b6dd7:	48 83 bf a8 01 00 00 	cmp    QWORD PTR [rdi+0x1a8],0x10
   1855b6dde:	10 
   1855b6ddf:	72 07                	jb     0x1855b6de8
   1855b6de1:	4c 8b 8f 90 01 00 00 	mov    r9,QWORD PTR [rdi+0x190]
   1855b6de8:	48 8b 88 c0 01 00 00 	mov    rcx,QWORD PTR [rax+0x1c0]
   1855b6def:	49 39 ce             	cmp    r14,rcx
   1855b6df2:	0f 86 73 14 00 00    	jbe    0x1855b826b
   1855b6df8:	48 89 d9             	mov    rcx,rbx
   1855b6dfb:	4c 89 f2             	mov    rdx,r14
   1855b6dfe:	e8 4d 73 a8 fa       	call   0x18003e150
   1855b6e03:	90                   	nop
   1855b6e04:	e9 85 14 00 00       	jmp    0x1855b828e
   1855b6e09:	0f 28 35 a0 ed 78 03 	movaps xmm6,XMMWORD PTR [rip+0x378eda0]        # 0x188d45bb0
   1855b6e10:	0f 29 b5 c0 00 00 00 	movaps XMMWORD PTR [rbp+0xc0],xmm6
   1855b6e17:	48 8d 8d c0 00 00 00 	lea    rcx,[rbp+0xc0]
   1855b6e1e:	e8 cd 02 7b fc       	call   0x181d670f0
   1855b6e23:	48 8b 85 c0 00 00 00 	mov    rax,QWORD PTR [rbp+0xc0]
   1855b6e2a:	c7 80 18 01 00 00 03 	mov    DWORD PTR [rax+0x118],0x3
   1855b6e31:	00 00 00 
   1855b6e34:	0f 29 b5 80 00 00 00 	movaps XMMWORD PTR [rbp+0x80],xmm6
   1855b6e3b:	0f 29 75 70          	movaps XMMWORD PTR [rbp+0x70],xmm6
   1855b6e3f:	48 8d 4d 70          	lea    rcx,[rbp+0x70]
   1855b6e43:	41 b8 01 00 00 00    	mov    r8d,0x1
   1855b6e49:	48 89 fa             	mov    rdx,rdi
   1855b6e4c:	45 31 c9             	xor    r9d,r9d
   1855b6e4f:	e8 dc ca fa fe       	call   0x184563930
   1855b6e54:	90                   	nop
   1855b6e55:	48 8d 4d 70          	lea    rcx,[rbp+0x70]
   1855b6e59:	e8 72 79 dd fa       	call   0x18038e7d0
   1855b6e5e:	90                   	nop
   1855b6e5f:	84 c0                	test   al,al
   1855b6e61:	74 16                	je     0x1855b6e79
   1855b6e63:	b9 20 01 00 00       	mov    ecx,0x120
   1855b6e68:	48 03 8d c0 00 00 00 	add    rcx,QWORD PTR [rbp+0xc0]
   1855b6e6f:	48 8d 55 70          	lea    rdx,[rbp+0x70]
   1855b6e73:	e8 58 47 ae fa       	call   0x18009b5d0
   1855b6e78:	90                   	nop
   1855b6e79:	b9 20 01 00 00       	mov    ecx,0x120
   1855b6e7e:	48 03 8d c0 00 00 00 	add    rcx,QWORD PTR [rbp+0xc0]
   1855b6e85:	e8 46 79 dd fa       	call   0x18038e7d0
   1855b6e8a:	90                   	nop
   1855b6e8b:	84 c0                	test   al,al
   1855b6e8d:	75 49                	jne    0x1855b6ed8
   1855b6e8f:	0f 29 b5 f0 00 00 00 	movaps XMMWORD PTR [rbp+0xf0],xmm6
   1855b6e96:	0f 29 b5 e0 00 00 00 	movaps XMMWORD PTR [rbp+0xe0],xmm6
   1855b6e9d:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b6ea4:	41 b8 01 00 00 00    	mov    r8d,0x1
   1855b6eaa:	48 89 fa             	mov    rdx,rdi
   1855b6ead:	e8 ae 92 fa fe       	call   0x184560160
   1855b6eb2:	90                   	nop
   1855b6eb3:	b9 20 01 00 00       	mov    ecx,0x120
   1855b6eb8:	48 03 8d c0 00 00 00 	add    rcx,QWORD PTR [rbp+0xc0]
   1855b6ebf:	48 8d 95 e0 00 00 00 	lea    rdx,[rbp+0xe0]
   1855b6ec6:	e8 05 47 ae fa       	call   0x18009b5d0
   1855b6ecb:	90                   	nop
   1855b6ecc:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b6ed3:	e8 88 0b a5 fa       	call   0x180007a60
   1855b6ed8:	b9 20 01 00 00       	mov    ecx,0x120
   1855b6edd:	48 03 8d c0 00 00 00 	add    rcx,QWORD PTR [rbp+0xc0]
   1855b6ee4:	e8 e7 78 dd fa       	call   0x18038e7d0
   1855b6ee9:	90                   	nop
   1855b6eea:	84 c0                	test   al,al
   1855b6eec:	0f 84 d3 08 00 00    	je     0x1855b77c5
   1855b6ef2:	48 8d 95 c0 00 00 00 	lea    rdx,[rbp+0xc0]
   1855b6ef9:	48 89 f1             	mov    rcx,rsi
   1855b6efc:	e8 3f 89 16 fb       	call   0x18071f840
   1855b6f01:	e9 51 14 00 00       	jmp    0x1855b8357
   1855b6f06:	0f 28 05 a3 ec 78 03 	movaps xmm0,XMMWORD PTR [rip+0x378eca3]        # 0x188d45bb0
   1855b6f0d:	0f 29 45 70          	movaps XMMWORD PTR [rbp+0x70],xmm0
   1855b6f11:	48 8b 87 a8 05 00 00 	mov    rax,QWORD PTR [rdi+0x5a8]
   1855b6f18:	48 85 c0             	test   rax,rax
   1855b6f1b:	0f 84 24 0a 00 00    	je     0x1855b7945
   1855b6f21:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   1855b6f25:	4c 8b b7 a8 05 00 00 	mov    r14,QWORD PTR [rdi+0x5a8]
   1855b6f2c:	e9 17 0a 00 00       	jmp    0x1855b7948
   1855b6f31:	0f 28 05 78 ec 78 03 	movaps xmm0,XMMWORD PTR [rip+0x378ec78]        # 0x188d45bb0
   1855b6f38:	0f 29 85 e0 00 00 00 	movaps XMMWORD PTR [rbp+0xe0],xmm0
   1855b6f3f:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b6f46:	e8 25 dd 13 fb       	call   0x1806f4c70
   1855b6f4b:	48 8b 85 e0 00 00 00 	mov    rax,QWORD PTR [rbp+0xe0]
   1855b6f52:	c7 80 18 01 00 00 01 	mov    DWORD PTR [rax+0x118],0x1
   1855b6f59:	00 00 00 
   1855b6f5c:	4c 8d 8f b0 01 00 00 	lea    r9,[rdi+0x1b0]
   1855b6f63:	48 8d 98 58 07 00 00 	lea    rbx,[rax+0x758]
   1855b6f6a:	4c 39 cb             	cmp    rbx,r9
   1855b6f6d:	0f 84 c4 1a 00 00    	je     0x1855b8a37
   1855b6f73:	4c 8b b7 c0 01 00 00 	mov    r14,QWORD PTR [rdi+0x1c0]
   1855b6f7a:	48 83 bf c8 01 00 00 	cmp    QWORD PTR [rdi+0x1c8],0x10
   1855b6f81:	10 
   1855b6f82:	72 07                	jb     0x1855b6f8b
   1855b6f84:	4c 8b 8f b0 01 00 00 	mov    r9,QWORD PTR [rdi+0x1b0]
   1855b6f8b:	48 8b 88 70 07 00 00 	mov    rcx,QWORD PTR [rax+0x770]
   1855b6f92:	49 39 ce             	cmp    r14,rcx
   1855b6f95:	0f 86 7c 15 00 00    	jbe    0x1855b8517
   1855b6f9b:	48 89 d9             	mov    rcx,rbx
   1855b6f9e:	4c 89 f2             	mov    rdx,r14
   1855b6fa1:	e8 aa 71 a8 fa       	call   0x18003e150
   1855b6fa6:	90                   	nop
   1855b6fa7:	e9 8b 1a 00 00       	jmp    0x1855b8a37
   1855b6fac:	0f 57 c0             	xorps  xmm0,xmm0
   1855b6faf:	0f 29 85 80 01 00 00 	movaps XMMWORD PTR [rbp+0x180],xmm0
   1855b6fb6:	0f 29 85 70 01 00 00 	movaps XMMWORD PTR [rbp+0x170],xmm0
   1855b6fbd:	48 8b 9f e0 00 00 00 	mov    rbx,QWORD PTR [rdi+0xe0]
   1855b6fc4:	48 83 bf e8 00 00 00 	cmp    QWORD PTR [rdi+0xe8],0x10
   1855b6fcb:	10 
   1855b6fcc:	0f 82 74 07 00 00    	jb     0x1855b7746
   1855b6fd2:	4c 8b b7 d0 00 00 00 	mov    r14,QWORD PTR [rdi+0xd0]
   1855b6fd9:	e9 6f 07 00 00       	jmp    0x1855b774d
   1855b6fde:	0f 28 05 cb eb 78 03 	movaps xmm0,XMMWORD PTR [rip+0x378ebcb]        # 0x188d45bb0
   1855b6fe5:	0f 29 45 70          	movaps XMMWORD PTR [rbp+0x70],xmm0
   1855b6fe9:	48 8b 87 f8 05 00 00 	mov    rax,QWORD PTR [rdi+0x5f8]
   1855b6ff0:	48 85 c0             	test   rax,rax
   1855b6ff3:	0f 84 e4 0a 00 00    	je     0x1855b7add
   1855b6ff9:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   1855b6ffd:	4c 8b b7 f8 05 00 00 	mov    r14,QWORD PTR [rdi+0x5f8]
   1855b7004:	e9 d7 0a 00 00       	jmp    0x1855b7ae0
   1855b7009:	0f 28 35 a0 eb 78 03 	movaps xmm6,XMMWORD PTR [rip+0x378eba0]        # 0x188d45bb0
   1855b7010:	0f 29 75 70          	movaps XMMWORD PTR [rbp+0x70],xmm6
   1855b7014:	48 8b 87 b8 05 00 00 	mov    rax,QWORD PTR [rdi+0x5b8]
   1855b701b:	48 85 c0             	test   rax,rax
   1855b701e:	0f 84 82 0c 00 00    	je     0x1855b7ca6
   1855b7024:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   1855b7028:	48 8b 87 b8 05 00 00 	mov    rax,QWORD PTR [rdi+0x5b8]
   1855b702f:	e9 74 0c 00 00       	jmp    0x1855b7ca8
   1855b7034:	0f 28 35 75 eb 78 03 	movaps xmm6,XMMWORD PTR [rip+0x378eb75]        # 0x188d45bb0
   1855b703b:	0f 29 b5 c0 01 00 00 	movaps XMMWORD PTR [rbp+0x1c0],xmm6
   1855b7042:	48 8d 8d c0 01 00 00 	lea    rcx,[rbp+0x1c0]
   1855b7049:	e8 e2 a5 f2 fe       	call   0x1844e1630
   1855b704e:	48 8b 85 c0 01 00 00 	mov    rax,QWORD PTR [rbp+0x1c0]
   1855b7055:	48 b9 31 00 00 00 44 	movabs rcx,0x4400000031
   1855b705c:	00 00 00 
   1855b705f:	48 89 88 18 01 00 00 	mov    QWORD PTR [rax+0x118],rcx
   1855b7066:	4c 8d 8f 90 00 00 00 	lea    r9,[rdi+0x90]
   1855b706d:	48 8d 98 98 07 00 00 	lea    rbx,[rax+0x798]
   1855b7074:	4c 39 cb             	cmp    rbx,r9
   1855b7077:	0f 84 e5 14 00 00    	je     0x1855b8562
   1855b707d:	4c 8b b7 a0 00 00 00 	mov    r14,QWORD PTR [rdi+0xa0]
   1855b7084:	48 83 bf a8 00 00 00 	cmp    QWORD PTR [rdi+0xa8],0x10
   1855b708b:	10 
   1855b708c:	72 07                	jb     0x1855b7095
   1855b708e:	4c 8b 8f 90 00 00 00 	mov    r9,QWORD PTR [rdi+0x90]
   1855b7095:	48 8b 88 b0 07 00 00 	mov    rcx,QWORD PTR [rax+0x7b0]
   1855b709c:	49 39 ce             	cmp    r14,rcx
   1855b709f:	0f 86 9a 14 00 00    	jbe    0x1855b853f
   1855b70a5:	48 89 d9             	mov    rcx,rbx
   1855b70a8:	4c 89 f2             	mov    rdx,r14
   1855b70ab:	e8 a0 70 a8 fa       	call   0x18003e150
   1855b70b0:	90                   	nop
   1855b70b1:	e9 ac 14 00 00       	jmp    0x1855b8562
   1855b70b6:	b9 02 00 00 00       	mov    ecx,0x2
   1855b70bb:	e8 20 5d ab fa       	call   0x18006cde0
   1855b70c0:	85 c0                	test   eax,eax
   1855b70c2:	0f 84 18 01 00 00    	je     0x1855b71e0
   1855b70c8:	48 8d 75 50          	lea    rsi,[rbp+0x50]
   1855b70cc:	48 89 f1             	mov    rcx,rsi
   1855b70cf:	e8 3c 5e ab fa       	call   0x18006cf10
   1855b70d4:	90                   	nop
   1855b70d5:	48 83 7d 68 10       	cmp    QWORD PTR [rbp+0x68],0x10
   1855b70da:	72 04                	jb     0x1855b70e0
   1855b70dc:	48 8b 75 50          	mov    rsi,QWORD PTR [rbp+0x50]
   1855b70e0:	48 8d 05 f9 a7 26 04 	lea    rax,[rip+0x426a7f9]        # 0x1898218e0
   1855b70e7:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1855b70ec:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   1855b70f3:	00 00 
   1855b70f5:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   1855b70fa:	c7 44 24 28 a9 01 00 	mov    DWORD PTR [rsp+0x28],0x1a9
   1855b7101:	00 
   1855b7102:	4c 8d 0d 37 a8 26 04 	lea    r9,[rip+0x426a837]        # 0x189821940
   1855b7109:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b7110:	ba 02 00 00 00       	mov    edx,0x2
   1855b7115:	49 89 f0             	mov    r8,rsi
   1855b7118:	e8 53 61 ab fa       	call   0x18006d270
   1855b711d:	90                   	nop
   1855b711e:	b9 20 01 00 00       	mov    ecx,0x120
   1855b7123:	48 03 4d 40          	add    rcx,QWORD PTR [rbp+0x40]
   1855b7127:	48 8d b5 c0 00 00 00 	lea    rsi,[rbp+0xc0]
   1855b712e:	48 89 f2             	mov    rdx,rsi
   1855b7131:	e8 3a 89 ae fa       	call   0x18009fa70
   1855b7136:	90                   	nop
   1855b7137:	48 83 bd d8 00 00 00 	cmp    QWORD PTR [rbp+0xd8],0x10
   1855b713e:	10 
   1855b713f:	72 07                	jb     0x1855b7148
   1855b7141:	48 8b b5 c0 00 00 00 	mov    rsi,QWORD PTR [rbp+0xc0]
   1855b7148:	48 89 b5 70 01 00 00 	mov    QWORD PTR [rbp+0x170],rsi
   1855b714f:	c6 85 78 01 00 00 00 	mov    BYTE PTR [rbp+0x178],0x0
   1855b7156:	0f 57 c0             	xorps  xmm0,xmm0
   1855b7159:	0f 11 85 28 02 00 00 	movups XMMWORD PTR [rbp+0x228],xmm0
   1855b7160:	0f 11 85 18 02 00 00 	movups XMMWORD PTR [rbp+0x218],xmm0
   1855b7167:	0f 11 85 08 02 00 00 	movups XMMWORD PTR [rbp+0x208],xmm0
   1855b716e:	0f 11 85 f8 01 00 00 	movups XMMWORD PTR [rbp+0x1f8],xmm0
   1855b7175:	0f 11 85 e8 01 00 00 	movups XMMWORD PTR [rbp+0x1e8],xmm0
   1855b717c:	0f 11 85 d8 01 00 00 	movups XMMWORD PTR [rbp+0x1d8],xmm0
   1855b7183:	0f 11 85 c8 01 00 00 	movups XMMWORD PTR [rbp+0x1c8],xmm0
   1855b718a:	48 c7 85 38 02 00 00 	mov    QWORD PTR [rbp+0x238],0x0
   1855b7191:	00 00 00 00 
   1855b7195:	48 8d 85 70 01 00 00 	lea    rax,[rbp+0x170]
   1855b719c:	48 89 85 c0 01 00 00 	mov    QWORD PTR [rbp+0x1c0],rax
   1855b71a3:	48 8d 15 3e a8 26 04 	lea    rdx,[rip+0x426a83e]        # 0x1898219e8
   1855b71aa:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b71b1:	4c 8d 85 c0 01 00 00 	lea    r8,[rbp+0x1c0]
   1855b71b8:	e8 53 66 ab fa       	call   0x18006d810
   1855b71bd:	90                   	nop
   1855b71be:	48 8d 8d c0 00 00 00 	lea    rcx,[rbp+0xc0]
   1855b71c5:	e8 46 ae a4 fa       	call   0x180002010
   1855b71ca:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b71d1:	e8 9a 61 ab fa       	call   0x18006d370
   1855b71d6:	48 8d 4d 50          	lea    rcx,[rbp+0x50]
   1855b71da:	e8 31 ae a4 fa       	call   0x180002010
   1855b71df:	90                   	nop
   1855b71e0:	e8 2b eb a8 fa       	call   0x180045d10
   1855b71e5:	90                   	nop
   1855b71e6:	4c 8b 00             	mov    r8,QWORD PTR [rax]
   1855b71e9:	48 8d 55 50          	lea    rdx,[rbp+0x50]
   1855b71ed:	48 89 c1             	mov    rcx,rax
   1855b71f0:	41 ff 50 60          	call   QWORD PTR [r8+0x60]
   1855b71f4:	90                   	nop
   1855b71f5:	48 8b 4d 50          	mov    rcx,QWORD PTR [rbp+0x50]
   1855b71f9:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   1855b71fc:	48 8d 95 70 01 00 00 	lea    rdx,[rbp+0x170]
   1855b7203:	ff 50 30             	call   QWORD PTR [rax+0x30]
   1855b7206:	90                   	nop
   1855b7207:	48 8b 8d 70 01 00 00 	mov    rcx,QWORD PTR [rbp+0x170]
   1855b720e:	48 8d 05 d3 a7 a6 03 	lea    rax,[rip+0x3a6a7d3]        # 0x1890219e8
   1855b7215:	48 89 85 c0 00 00 00 	mov    QWORD PTR [rbp+0xc0],rax
   1855b721c:	0f 29 b5 e0 00 00 00 	movaps XMMWORD PTR [rbp+0xe0],xmm6
   1855b7223:	48 8d 95 e0 00 00 00 	lea    rdx,[rbp+0xe0]
   1855b722a:	4c 8d 85 c0 00 00 00 	lea    r8,[rbp+0xc0]
   1855b7231:	e8 4a 78 be fa       	call   0x18019ea80
   1855b7236:	90                   	nop
   1855b7237:	48 8b 85 e0 00 00 00 	mov    rax,QWORD PTR [rbp+0xe0]
   1855b723e:	48 8b 8d e8 00 00 00 	mov    rcx,QWORD PTR [rbp+0xe8]
   1855b7245:	48 85 c9             	test   rcx,rcx
   1855b7248:	0f 84 66 0e 00 00    	je     0x1855b80b4
   1855b724e:	f0 ff 41 08          	lock inc DWORD PTR [rcx+0x8]
   1855b7252:	48 8b b5 e8 00 00 00 	mov    rsi,QWORD PTR [rbp+0xe8]
   1855b7259:	48 89 85 c0 01 00 00 	mov    QWORD PTR [rbp+0x1c0],rax
   1855b7260:	48 89 b5 c8 01 00 00 	mov    QWORD PTR [rbp+0x1c8],rsi
   1855b7267:	48 85 f6             	test   rsi,rsi
   1855b726a:	0f 84 56 0e 00 00    	je     0x1855b80c6
   1855b7270:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   1855b7274:	0f 85 4c 0e 00 00    	jne    0x1855b80c6
   1855b727a:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1855b727d:	48 89 f1             	mov    rcx,rsi
   1855b7280:	ff 10                	call   QWORD PTR [rax]
   1855b7282:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   1855b7286:	0f 85 3a 0e 00 00    	jne    0x1855b80c6
   1855b728c:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1855b728f:	48 89 f1             	mov    rcx,rsi
   1855b7292:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1855b7295:	e9 2c 0e 00 00       	jmp    0x1855b80c6
   1855b729a:	48 83 f9 10          	cmp    rcx,0x10
   1855b729e:	72 03                	jb     0x1855b72a3
   1855b72a0:	48 8b 1b             	mov    rbx,QWORD PTR [rbx]
   1855b72a3:	4c 89 b0 a8 07 00 00 	mov    QWORD PTR [rax+0x7a8],r14
   1855b72aa:	48 89 d9             	mov    rcx,rbx
   1855b72ad:	4c 89 ca             	mov    rdx,r9
   1855b72b0:	4d 89 f0             	mov    r8,r14
   1855b72b3:	e8 98 cd f8 01       	call   0x187544050
   1855b72b8:	42 c6 04 33 00       	mov    BYTE PTR [rbx+r14*1],0x0
   1855b72bd:	4c 8d 8f 90 01 00 00 	lea    r9,[rdi+0x190]
   1855b72c4:	48 8b 85 c0 01 00 00 	mov    rax,QWORD PTR [rbp+0x1c0]
   1855b72cb:	48 8d 98 58 07 00 00 	lea    rbx,[rax+0x758]
   1855b72d2:	4c 39 cb             	cmp    rbx,r9
   1855b72d5:	74 55                	je     0x1855b732c
   1855b72d7:	4c 8b b7 a0 01 00 00 	mov    r14,QWORD PTR [rdi+0x1a0]
   1855b72de:	48 83 bf a8 01 00 00 	cmp    QWORD PTR [rdi+0x1a8],0x10
   1855b72e5:	10 
   1855b72e6:	72 07                	jb     0x1855b72ef
   1855b72e8:	4c 8b 8f 90 01 00 00 	mov    r9,QWORD PTR [rdi+0x190]
   1855b72ef:	48 8b 88 70 07 00 00 	mov    rcx,QWORD PTR [rax+0x770]
   1855b72f6:	49 39 ce             	cmp    r14,rcx
   1855b72f9:	76 0e                	jbe    0x1855b7309
   1855b72fb:	48 89 d9             	mov    rcx,rbx
   1855b72fe:	4c 89 f2             	mov    rdx,r14
   1855b7301:	e8 4a 6e a8 fa       	call   0x18003e150
   1855b7306:	90                   	nop
   1855b7307:	eb 23                	jmp    0x1855b732c
   1855b7309:	48 83 f9 10          	cmp    rcx,0x10
   1855b730d:	72 03                	jb     0x1855b7312
   1855b730f:	48 8b 1b             	mov    rbx,QWORD PTR [rbx]
   1855b7312:	4c 89 b0 68 07 00 00 	mov    QWORD PTR [rax+0x768],r14
   1855b7319:	48 89 d9             	mov    rcx,rbx
   1855b731c:	4c 89 ca             	mov    rdx,r9
   1855b731f:	4d 89 f0             	mov    r8,r14
   1855b7322:	e8 29 cd f8 01       	call   0x187544050
   1855b7327:	42 c6 04 33 00       	mov    BYTE PTR [rbx+r14*1],0x0
   1855b732c:	4c 8d 8f b0 01 00 00 	lea    r9,[rdi+0x1b0]
   1855b7333:	48 8b 85 c0 01 00 00 	mov    rax,QWORD PTR [rbp+0x1c0]
   1855b733a:	48 8d 98 78 07 00 00 	lea    rbx,[rax+0x778]
   1855b7341:	4c 39 cb             	cmp    rbx,r9
   1855b7344:	74 55                	je     0x1855b739b
   1855b7346:	4c 8b b7 c0 01 00 00 	mov    r14,QWORD PTR [rdi+0x1c0]
   1855b734d:	48 83 bf c8 01 00 00 	cmp    QWORD PTR [rdi+0x1c8],0x10
   1855b7354:	10 
   1855b7355:	72 07                	jb     0x1855b735e
   1855b7357:	4c 8b 8f b0 01 00 00 	mov    r9,QWORD PTR [rdi+0x1b0]
   1855b735e:	48 8b 88 90 07 00 00 	mov    rcx,QWORD PTR [rax+0x790]
   1855b7365:	49 39 ce             	cmp    r14,rcx
   1855b7368:	76 0e                	jbe    0x1855b7378
   1855b736a:	48 89 d9             	mov    rcx,rbx
   1855b736d:	4c 89 f2             	mov    rdx,r14
   1855b7370:	e8 db 6d a8 fa       	call   0x18003e150
   1855b7375:	90                   	nop
   1855b7376:	eb 23                	jmp    0x1855b739b
   1855b7378:	48 83 f9 10          	cmp    rcx,0x10
   1855b737c:	72 03                	jb     0x1855b7381
   1855b737e:	48 8b 1b             	mov    rbx,QWORD PTR [rbx]
   1855b7381:	4c 89 b0 88 07 00 00 	mov    QWORD PTR [rax+0x788],r14
   1855b7388:	48 89 d9             	mov    rcx,rbx
   1855b738b:	4c 89 ca             	mov    rdx,r9
   1855b738e:	4d 89 f0             	mov    r8,r14
   1855b7391:	e8 ba cc f8 01       	call   0x187544050
   1855b7396:	42 c6 04 33 00       	mov    BYTE PTR [rbx+r14*1],0x0
   1855b739b:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b73a2:	41 b8 02 00 00 00    	mov    r8d,0x2
   1855b73a8:	48 89 fa             	mov    rdx,rdi
   1855b73ab:	e8 b0 8d fa fe       	call   0x184560160
   1855b73b0:	90                   	nop
   1855b73b1:	b9 20 01 00 00       	mov    ecx,0x120
   1855b73b6:	48 03 8d c0 01 00 00 	add    rcx,QWORD PTR [rbp+0x1c0]
   1855b73bd:	48 8d 9d e0 00 00 00 	lea    rbx,[rbp+0xe0]
   1855b73c4:	48 89 da             	mov    rdx,rbx
   1855b73c7:	e8 74 42 ae fa       	call   0x18009b640
   1855b73cc:	48 89 d9             	mov    rcx,rbx
   1855b73cf:	e8 8c 06 a5 fa       	call   0x180007a60
   1855b73d4:	4c 8d 8f d0 03 00 00 	lea    r9,[rdi+0x3d0]
   1855b73db:	48 8b 85 c0 01 00 00 	mov    rax,QWORD PTR [rbp+0x1c0]
   1855b73e2:	48 8d 98 e0 07 00 00 	lea    rbx,[rax+0x7e0]
   1855b73e9:	4c 39 cb             	cmp    rbx,r9
   1855b73ec:	74 55                	je     0x1855b7443
   1855b73ee:	4c 8b b7 e0 03 00 00 	mov    r14,QWORD PTR [rdi+0x3e0]
   1855b73f5:	48 83 bf e8 03 00 00 	cmp    QWORD PTR [rdi+0x3e8],0x10
   1855b73fc:	10 
   1855b73fd:	72 07                	jb     0x1855b7406
   1855b73ff:	4c 8b 8f d0 03 00 00 	mov    r9,QWORD PTR [rdi+0x3d0]
   1855b7406:	48 8b 88 f8 07 00 00 	mov    rcx,QWORD PTR [rax+0x7f8]
   1855b740d:	49 39 ce             	cmp    r14,rcx
   1855b7410:	76 0e                	jbe    0x1855b7420
   1855b7412:	48 89 d9             	mov    rcx,rbx
   1855b7415:	4c 89 f2             	mov    rdx,r14
   1855b7418:	e8 33 6d a8 fa       	call   0x18003e150
   1855b741d:	90                   	nop
   1855b741e:	eb 23                	jmp    0x1855b7443
   1855b7420:	48 83 f9 10          	cmp    rcx,0x10
   1855b7424:	72 03                	jb     0x1855b7429
   1855b7426:	48 8b 1b             	mov    rbx,QWORD PTR [rbx]
   1855b7429:	4c 89 b0 f0 07 00 00 	mov    QWORD PTR [rax+0x7f0],r14
   1855b7430:	48 89 d9             	mov    rcx,rbx
   1855b7433:	4c 89 ca             	mov    rdx,r9
   1855b7436:	4d 89 f0             	mov    r8,r14
   1855b7439:	e8 12 cc f8 01       	call   0x187544050
   1855b743e:	42 c6 04 33 00       	mov    BYTE PTR [rbx+r14*1],0x0
   1855b7443:	4c 8d 8f 10 04 00 00 	lea    r9,[rdi+0x410]
   1855b744a:	48 8b 85 c0 01 00 00 	mov    rax,QWORD PTR [rbp+0x1c0]
   1855b7451:	48 8d 98 00 08 00 00 	lea    rbx,[rax+0x800]
   1855b7458:	4c 39 cb             	cmp    rbx,r9
   1855b745b:	74 55                	je     0x1855b74b2
   1855b745d:	4c 8b b7 20 04 00 00 	mov    r14,QWORD PTR [rdi+0x420]
   1855b7464:	48 83 bf 28 04 00 00 	cmp    QWORD PTR [rdi+0x428],0x10
   1855b746b:	10 
   1855b746c:	72 07                	jb     0x1855b7475
   1855b746e:	4c 8b 8f 10 04 00 00 	mov    r9,QWORD PTR [rdi+0x410]
   1855b7475:	48 8b 88 18 08 00 00 	mov    rcx,QWORD PTR [rax+0x818]
   1855b747c:	49 39 ce             	cmp    r14,rcx
   1855b747f:	76 0e                	jbe    0x1855b748f
   1855b7481:	48 89 d9             	mov    rcx,rbx
   1855b7484:	4c 89 f2             	mov    rdx,r14
   1855b7487:	e8 c4 6c a8 fa       	call   0x18003e150
   1855b748c:	90                   	nop
   1855b748d:	eb 23                	jmp    0x1855b74b2
   1855b748f:	48 83 f9 10          	cmp    rcx,0x10
   1855b7493:	72 03                	jb     0x1855b7498
   1855b7495:	48 8b 1b             	mov    rbx,QWORD PTR [rbx]
   1855b7498:	4c 89 b0 10 08 00 00 	mov    QWORD PTR [rax+0x810],r14
   1855b749f:	48 89 d9             	mov    rcx,rbx
   1855b74a2:	4c 89 ca             	mov    rdx,r9
   1855b74a5:	4d 89 f0             	mov    r8,r14
   1855b74a8:	e8 a3 cb f8 01       	call   0x187544050
   1855b74ad:	42 c6 04 33 00       	mov    BYTE PTR [rbx+r14*1],0x0
   1855b74b2:	4c 8d 8f f0 03 00 00 	lea    r9,[rdi+0x3f0]
   1855b74b9:	48 8b 85 c0 01 00 00 	mov    rax,QWORD PTR [rbp+0x1c0]
   1855b74c0:	48 8d 98 20 08 00 00 	lea    rbx,[rax+0x820]
   1855b74c7:	4c 39 cb             	cmp    rbx,r9
   1855b74ca:	74 55                	je     0x1855b7521
   1855b74cc:	4c 8b b7 00 04 00 00 	mov    r14,QWORD PTR [rdi+0x400]
   1855b74d3:	48 83 bf 08 04 00 00 	cmp    QWORD PTR [rdi+0x408],0x10
   1855b74da:	10 
   1855b74db:	72 07                	jb     0x1855b74e4
   1855b74dd:	4c 8b 8f f0 03 00 00 	mov    r9,QWORD PTR [rdi+0x3f0]
   1855b74e4:	48 8b 88 38 08 00 00 	mov    rcx,QWORD PTR [rax+0x838]
   1855b74eb:	49 39 ce             	cmp    r14,rcx
   1855b74ee:	76 0e                	jbe    0x1855b74fe
   1855b74f0:	48 89 d9             	mov    rcx,rbx
   1855b74f3:	4c 89 f2             	mov    rdx,r14
   1855b74f6:	e8 55 6c a8 fa       	call   0x18003e150
   1855b74fb:	90                   	nop
   1855b74fc:	eb 23                	jmp    0x1855b7521
   1855b74fe:	48 83 f9 10          	cmp    rcx,0x10
   1855b7502:	72 03                	jb     0x1855b7507
   1855b7504:	48 8b 1b             	mov    rbx,QWORD PTR [rbx]
   1855b7507:	4c 89 b0 30 08 00 00 	mov    QWORD PTR [rax+0x830],r14
   1855b750e:	48 89 d9             	mov    rcx,rbx
   1855b7511:	4c 89 ca             	mov    rdx,r9
   1855b7514:	4d 89 f0             	mov    r8,r14
   1855b7517:	e8 34 cb f8 01       	call   0x187544050
   1855b751c:	42 c6 04 33 00       	mov    BYTE PTR [rbx+r14*1],0x0
   1855b7521:	4c 8d 8f a0 04 00 00 	lea    r9,[rdi+0x4a0]
   1855b7528:	48 8b 85 c0 01 00 00 	mov    rax,QWORD PTR [rbp+0x1c0]
   1855b752f:	48 8d 98 40 08 00 00 	lea    rbx,[rax+0x840]
   1855b7536:	4c 39 cb             	cmp    rbx,r9
   1855b7539:	74 55                	je     0x1855b7590
   1855b753b:	4c 8b b7 b0 04 00 00 	mov    r14,QWORD PTR [rdi+0x4b0]
   1855b7542:	48 83 bf b8 04 00 00 	cmp    QWORD PTR [rdi+0x4b8],0x10
   1855b7549:	10 
   1855b754a:	72 07                	jb     0x1855b7553
   1855b754c:	4c 8b 8f a0 04 00 00 	mov    r9,QWORD PTR [rdi+0x4a0]
   1855b7553:	48 8b 88 58 08 00 00 	mov    rcx,QWORD PTR [rax+0x858]
   1855b755a:	49 39 ce             	cmp    r14,rcx
   1855b755d:	76 0e                	jbe    0x1855b756d
   1855b755f:	48 89 d9             	mov    rcx,rbx
   1855b7562:	4c 89 f2             	mov    rdx,r14
   1855b7565:	e8 e6 6b a8 fa       	call   0x18003e150
   1855b756a:	90                   	nop
   1855b756b:	eb 23                	jmp    0x1855b7590
   1855b756d:	48 83 f9 10          	cmp    rcx,0x10
   1855b7571:	72 03                	jb     0x1855b7576
   1855b7573:	48 8b 1b             	mov    rbx,QWORD PTR [rbx]
   1855b7576:	4c 89 b0 50 08 00 00 	mov    QWORD PTR [rax+0x850],r14
   1855b757d:	48 89 d9             	mov    rcx,rbx
   1855b7580:	4c 89 ca             	mov    rdx,r9
   1855b7583:	4d 89 f0             	mov    r8,r14
   1855b7586:	e8 c5 ca f8 01       	call   0x187544050
   1855b758b:	42 c6 04 33 00       	mov    BYTE PTR [rbx+r14*1],0x0
   1855b7590:	4c 8d 8f c0 04 00 00 	lea    r9,[rdi+0x4c0]
   1855b7597:	48 8b 85 c0 01 00 00 	mov    rax,QWORD PTR [rbp+0x1c0]
   1855b759e:	48 8d 98 60 08 00 00 	lea    rbx,[rax+0x860]
   1855b75a5:	4c 39 cb             	cmp    rbx,r9
   1855b75a8:	74 55                	je     0x1855b75ff
   1855b75aa:	4c 8b b7 d0 04 00 00 	mov    r14,QWORD PTR [rdi+0x4d0]
   1855b75b1:	48 83 bf d8 04 00 00 	cmp    QWORD PTR [rdi+0x4d8],0x10
   1855b75b8:	10 
   1855b75b9:	72 07                	jb     0x1855b75c2
   1855b75bb:	4c 8b 8f c0 04 00 00 	mov    r9,QWORD PTR [rdi+0x4c0]
   1855b75c2:	48 8b 88 78 08 00 00 	mov    rcx,QWORD PTR [rax+0x878]
   1855b75c9:	49 39 ce             	cmp    r14,rcx
   1855b75cc:	76 0e                	jbe    0x1855b75dc
   1855b75ce:	48 89 d9             	mov    rcx,rbx
   1855b75d1:	4c 89 f2             	mov    rdx,r14
   1855b75d4:	e8 77 6b a8 fa       	call   0x18003e150
   1855b75d9:	90                   	nop
   1855b75da:	eb 23                	jmp    0x1855b75ff
   1855b75dc:	48 83 f9 10          	cmp    rcx,0x10
   1855b75e0:	72 03                	jb     0x1855b75e5
   1855b75e2:	48 8b 1b             	mov    rbx,QWORD PTR [rbx]
   1855b75e5:	4c 89 b0 70 08 00 00 	mov    QWORD PTR [rax+0x870],r14
   1855b75ec:	48 89 d9             	mov    rcx,rbx
   1855b75ef:	4c 89 ca             	mov    rdx,r9
   1855b75f2:	4d 89 f0             	mov    r8,r14
   1855b75f5:	e8 56 ca f8 01       	call   0x187544050
   1855b75fa:	42 c6 04 33 00       	mov    BYTE PTR [rbx+r14*1],0x0
   1855b75ff:	8b 8f f0 01 00 00    	mov    ecx,DWORD PTR [rdi+0x1f0]
   1855b7605:	48 8b 85 c0 01 00 00 	mov    rax,QWORD PTR [rbp+0x1c0]
   1855b760c:	89 88 80 08 00 00    	mov    DWORD PTR [rax+0x880],ecx
   1855b7612:	4c 8d 8f 40 02 00 00 	lea    r9,[rdi+0x240]
   1855b7619:	48 8d 98 88 08 00 00 	lea    rbx,[rax+0x888]
   1855b7620:	4c 39 cb             	cmp    rbx,r9
   1855b7623:	74 55                	je     0x1855b767a
   1855b7625:	4c 8b b7 50 02 00 00 	mov    r14,QWORD PTR [rdi+0x250]
   1855b762c:	48 83 bf 58 02 00 00 	cmp    QWORD PTR [rdi+0x258],0x10
   1855b7633:	10 
   1855b7634:	72 07                	jb     0x1855b763d
   1855b7636:	4c 8b 8f 40 02 00 00 	mov    r9,QWORD PTR [rdi+0x240]
   1855b763d:	48 8b 88 a0 08 00 00 	mov    rcx,QWORD PTR [rax+0x8a0]
   1855b7644:	49 39 ce             	cmp    r14,rcx
   1855b7647:	76 0e                	jbe    0x1855b7657
   1855b7649:	48 89 d9             	mov    rcx,rbx
   1855b764c:	4c 89 f2             	mov    rdx,r14
   1855b764f:	e8 fc 6a a8 fa       	call   0x18003e150
   1855b7654:	90                   	nop
   1855b7655:	eb 23                	jmp    0x1855b767a
   1855b7657:	48 83 f9 10          	cmp    rcx,0x10
   1855b765b:	72 03                	jb     0x1855b7660
   1855b765d:	48 8b 1b             	mov    rbx,QWORD PTR [rbx]
   1855b7660:	4c 89 b0 98 08 00 00 	mov    QWORD PTR [rax+0x898],r14
   1855b7667:	48 89 d9             	mov    rcx,rbx
   1855b766a:	4c 89 ca             	mov    rdx,r9
   1855b766d:	4d 89 f0             	mov    r8,r14
   1855b7670:	e8 db c9 f8 01       	call   0x187544050
   1855b7675:	42 c6 04 33 00       	mov    BYTE PTR [rbx+r14*1],0x0
   1855b767a:	4c 8d 8f 60 02 00 00 	lea    r9,[rdi+0x260]
   1855b7681:	48 8b 85 c0 01 00 00 	mov    rax,QWORD PTR [rbp+0x1c0]
   1855b7688:	48 8d 98 a8 08 00 00 	lea    rbx,[rax+0x8a8]
   1855b768f:	4c 39 cb             	cmp    rbx,r9
   1855b7692:	74 55                	je     0x1855b76e9
   1855b7694:	4c 8b b7 70 02 00 00 	mov    r14,QWORD PTR [rdi+0x270]
   1855b769b:	48 83 bf 78 02 00 00 	cmp    QWORD PTR [rdi+0x278],0x10
   1855b76a2:	10 
   1855b76a3:	72 07                	jb     0x1855b76ac
   1855b76a5:	4c 8b 8f 60 02 00 00 	mov    r9,QWORD PTR [rdi+0x260]
   1855b76ac:	48 8b 88 c0 08 00 00 	mov    rcx,QWORD PTR [rax+0x8c0]
   1855b76b3:	49 39 ce             	cmp    r14,rcx
   1855b76b6:	76 0e                	jbe    0x1855b76c6
   1855b76b8:	48 89 d9             	mov    rcx,rbx
   1855b76bb:	4c 89 f2             	mov    rdx,r14
   1855b76be:	e8 8d 6a a8 fa       	call   0x18003e150
   1855b76c3:	90                   	nop
   1855b76c4:	eb 23                	jmp    0x1855b76e9
   1855b76c6:	48 83 f9 10          	cmp    rcx,0x10
   1855b76ca:	72 03                	jb     0x1855b76cf
   1855b76cc:	48 8b 1b             	mov    rbx,QWORD PTR [rbx]
   1855b76cf:	4c 89 b0 b8 08 00 00 	mov    QWORD PTR [rax+0x8b8],r14
   1855b76d6:	48 89 d9             	mov    rcx,rbx
   1855b76d9:	4c 89 ca             	mov    rdx,r9
   1855b76dc:	4d 89 f0             	mov    r8,r14
   1855b76df:	e8 6c c9 f8 01       	call   0x187544050
   1855b76e4:	42 c6 04 33 00       	mov    BYTE PTR [rbx+r14*1],0x0
   1855b76e9:	48 8b 85 c8 01 00 00 	mov    rax,QWORD PTR [rbp+0x1c8]
   1855b76f0:	48 85 c0             	test   rax,rax
   1855b76f3:	74 0d                	je     0x1855b7702
   1855b76f5:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   1855b76f9:	48 8b 85 c8 01 00 00 	mov    rax,QWORD PTR [rbp+0x1c8]
   1855b7700:	eb 02                	jmp    0x1855b7704
   1855b7702:	31 c0                	xor    eax,eax
   1855b7704:	48 8b 8d c0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1c0]
   1855b770b:	48 89 0e             	mov    QWORD PTR [rsi],rcx
   1855b770e:	48 8b 7e 08          	mov    rdi,QWORD PTR [rsi+0x8]
   1855b7712:	48 89 46 08          	mov    QWORD PTR [rsi+0x8],rax
   1855b7716:	48 85 ff             	test   rdi,rdi
   1855b7719:	0f 84 fb 15 00 00    	je     0x1855b8d1a
   1855b771f:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   1855b7723:	0f 85 f1 15 00 00    	jne    0x1855b8d1a
   1855b7729:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1855b772c:	48 89 f9             	mov    rcx,rdi
   1855b772f:	ff 10                	call   QWORD PTR [rax]
   1855b7731:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   1855b7735:	0f 85 df 15 00 00    	jne    0x1855b8d1a
   1855b773b:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1855b773e:	48 89 f9             	mov    rcx,rdi
   1855b7741:	e9 d1 15 00 00       	jmp    0x1855b8d17
   1855b7746:	4c 8d b7 d0 00 00 00 	lea    r14,[rdi+0xd0]
   1855b774d:	48 85 db             	test   rbx,rbx
   1855b7750:	0f 88 86 1e 00 00    	js     0x1855b95dc
   1855b7756:	48 83 fb 0f          	cmp    rbx,0xf
   1855b775a:	77 22                	ja     0x1855b777e
   1855b775c:	48 89 9d 80 01 00 00 	mov    QWORD PTR [rbp+0x180],rbx
   1855b7763:	48 c7 85 88 01 00 00 	mov    QWORD PTR [rbp+0x188],0xf
   1855b776a:	0f 00 00 00 
   1855b776e:	41 0f 10 06          	movups xmm0,XMMWORD PTR [r14]
   1855b7772:	0f 29 85 70 01 00 00 	movaps XMMWORD PTR [rbp+0x170],xmm0
   1855b7779:	e9 05 16 00 00       	jmp    0x1855b8d83
   1855b777e:	48 89 d8             	mov    rax,rbx
   1855b7781:	48 83 c8 0f          	or     rax,0xf
   1855b7785:	48 83 f8 17          	cmp    rax,0x17
   1855b7789:	41 bf 16 00 00 00    	mov    r15d,0x16
   1855b778f:	4c 0f 43 f8          	cmovae r15,rax
   1855b7793:	48 3d ff 0f 00 00    	cmp    rax,0xfff
   1855b7799:	0f 82 b5 15 00 00    	jb     0x1855b8d54
   1855b779f:	49 8d 4f 28          	lea    rcx,[r15+0x28]
   1855b77a3:	e8 f4 40 ef 01       	call   0x1874ab89c
   1855b77a8:	48 85 c0             	test   rax,rax
   1855b77ab:	0f 84 26 1e 00 00    	je     0x1855b95d7
   1855b77b1:	48 89 c1             	mov    rcx,rax
   1855b77b4:	48 83 c0 27          	add    rax,0x27
   1855b77b8:	48 83 e0 e0          	and    rax,0xffffffffffffffe0
   1855b77bc:	48 89 48 f8          	mov    QWORD PTR [rax-0x8],rcx
   1855b77c0:	e9 98 15 00 00       	jmp    0x1855b8d5d
   1855b77c5:	b9 02 00 00 00       	mov    ecx,0x2
   1855b77ca:	e8 11 56 ab fa       	call   0x18006cde0
   1855b77cf:	85 c0                	test   eax,eax
   1855b77d1:	0f 84 0f 01 00 00    	je     0x1855b78e6
   1855b77d7:	48 8d 75 f0          	lea    rsi,[rbp-0x10]
   1855b77db:	48 89 f1             	mov    rcx,rsi
   1855b77de:	e8 2d 57 ab fa       	call   0x18006cf10
   1855b77e3:	90                   	nop
   1855b77e4:	48 83 7d 08 10       	cmp    QWORD PTR [rbp+0x8],0x10
   1855b77e9:	72 04                	jb     0x1855b77ef
   1855b77eb:	48 8b 75 f0          	mov    rsi,QWORD PTR [rbp-0x10]
   1855b77ef:	48 8d 05 ea a0 26 04 	lea    rax,[rip+0x426a0ea]        # 0x1898218e0
   1855b77f6:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1855b77fb:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   1855b7802:	00 00 
   1855b7804:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   1855b7809:	c7 44 24 28 96 01 00 	mov    DWORD PTR [rsp+0x28],0x196
   1855b7810:	00 
   1855b7811:	4c 8d 0d 28 a1 26 04 	lea    r9,[rip+0x426a128]        # 0x189821940
   1855b7818:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b781f:	ba 02 00 00 00       	mov    edx,0x2
   1855b7824:	49 89 f0             	mov    r8,rsi
   1855b7827:	e8 44 5a ab fa       	call   0x18006d270
   1855b782c:	90                   	nop
   1855b782d:	b9 20 01 00 00       	mov    ecx,0x120
   1855b7832:	48 03 8d c0 00 00 00 	add    rcx,QWORD PTR [rbp+0xc0]
   1855b7839:	48 8d 75 50          	lea    rsi,[rbp+0x50]
   1855b783d:	48 89 f2             	mov    rdx,rsi
   1855b7840:	e8 2b 82 ae fa       	call   0x18009fa70
   1855b7845:	90                   	nop
   1855b7846:	48 83 7d 68 10       	cmp    QWORD PTR [rbp+0x68],0x10
   1855b784b:	72 04                	jb     0x1855b7851
   1855b784d:	48 8b 75 50          	mov    rsi,QWORD PTR [rbp+0x50]
   1855b7851:	48 89 b5 70 01 00 00 	mov    QWORD PTR [rbp+0x170],rsi
   1855b7858:	c6 85 78 01 00 00 00 	mov    BYTE PTR [rbp+0x178],0x0
   1855b785f:	0f 57 c0             	xorps  xmm0,xmm0
   1855b7862:	0f 11 85 28 02 00 00 	movups XMMWORD PTR [rbp+0x228],xmm0
   1855b7869:	0f 11 85 18 02 00 00 	movups XMMWORD PTR [rbp+0x218],xmm0
   1855b7870:	0f 11 85 08 02 00 00 	movups XMMWORD PTR [rbp+0x208],xmm0
   1855b7877:	0f 11 85 f8 01 00 00 	movups XMMWORD PTR [rbp+0x1f8],xmm0
   1855b787e:	0f 11 85 e8 01 00 00 	movups XMMWORD PTR [rbp+0x1e8],xmm0
   1855b7885:	0f 11 85 d8 01 00 00 	movups XMMWORD PTR [rbp+0x1d8],xmm0
   1855b788c:	0f 11 85 c8 01 00 00 	movups XMMWORD PTR [rbp+0x1c8],xmm0
   1855b7893:	48 c7 85 38 02 00 00 	mov    QWORD PTR [rbp+0x238],0x0
   1855b789a:	00 00 00 00 
   1855b789e:	48 8d 85 70 01 00 00 	lea    rax,[rbp+0x170]
   1855b78a5:	48 89 85 c0 01 00 00 	mov    QWORD PTR [rbp+0x1c0],rax
   1855b78ac:	48 8d 15 35 a1 26 04 	lea    rdx,[rip+0x426a135]        # 0x1898219e8
   1855b78b3:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b78ba:	4c 8d 85 c0 01 00 00 	lea    r8,[rbp+0x1c0]
   1855b78c1:	e8 4a 5f ab fa       	call   0x18006d810
   1855b78c6:	90                   	nop
   1855b78c7:	48 8d 4d 50          	lea    rcx,[rbp+0x50]
   1855b78cb:	e8 40 a7 a4 fa       	call   0x180002010
   1855b78d0:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b78d7:	e8 94 5a ab fa       	call   0x18006d370
   1855b78dc:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b78e0:	e8 2b a7 a4 fa       	call   0x180002010
   1855b78e5:	90                   	nop
   1855b78e6:	e8 25 e4 a8 fa       	call   0x180045d10
   1855b78eb:	90                   	nop
   1855b78ec:	4c 8b 00             	mov    r8,QWORD PTR [rax]
   1855b78ef:	48 8d 95 70 01 00 00 	lea    rdx,[rbp+0x170]
   1855b78f6:	48 89 c1             	mov    rcx,rax
   1855b78f9:	41 ff 50 60          	call   QWORD PTR [r8+0x60]
   1855b78fd:	90                   	nop
   1855b78fe:	48 8b 8d 70 01 00 00 	mov    rcx,QWORD PTR [rbp+0x170]
   1855b7905:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   1855b7908:	48 8d 95 c0 01 00 00 	lea    rdx,[rbp+0x1c0]
   1855b790f:	ff 50 30             	call   QWORD PTR [rax+0x30]
   1855b7912:	90                   	nop
   1855b7913:	48 8b 8d c0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1c0]
   1855b791a:	48 8d 95 e0 00 00 00 	lea    rdx,[rbp+0xe0]
   1855b7921:	e8 4a 76 05 fe       	call   0x18360ef70
   1855b7926:	90                   	nop
   1855b7927:	48 8b 8d e0 00 00 00 	mov    rcx,QWORD PTR [rbp+0xe0]
   1855b792e:	41 b8 01 00 00 00    	mov    r8d,0x1
   1855b7934:	48 89 fa             	mov    rdx,rdi
   1855b7937:	45 31 c9             	xor    r9d,r9d
   1855b793a:	e8 61 65 07 fe       	call   0x18362dea0
   1855b793f:	90                   	nop
   1855b7940:	e9 94 0b 00 00       	jmp    0x1855b84d9
   1855b7945:	45 31 f6             	xor    r14d,r14d
   1855b7948:	48 8b bf a0 05 00 00 	mov    rdi,QWORD PTR [rdi+0x5a0]
   1855b794f:	48 89 7d 70          	mov    QWORD PTR [rbp+0x70],rdi
   1855b7953:	4c 89 75 78          	mov    QWORD PTR [rbp+0x78],r14
   1855b7957:	48 85 ff             	test   rdi,rdi
   1855b795a:	0f 84 ac 00 00 00    	je     0x1855b7a0c
   1855b7960:	0f 29 85 e0 00 00 00 	movaps XMMWORD PTR [rbp+0xe0],xmm0
   1855b7967:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b796e:	e8 7d ef 96 fd       	call   0x182f268f0
   1855b7973:	90                   	nop
   1855b7974:	48 8b 8d e0 00 00 00 	mov    rcx,QWORD PTR [rbp+0xe0]
   1855b797b:	c7 81 18 01 00 00 30 	mov    DWORD PTR [rcx+0x118],0x30
   1855b7982:	00 00 00 
   1855b7985:	f2 0f 10 47 08       	movsd  xmm0,QWORD PTR [rdi+0x8]
   1855b798a:	f2 0f 11 81 58 07 00 	movsd  QWORD PTR [rcx+0x758],xmm0
   1855b7991:	00 
   1855b7992:	f2 0f 10 07          	movsd  xmm0,QWORD PTR [rdi]
   1855b7996:	f2 0f 11 81 60 07 00 	movsd  QWORD PTR [rcx+0x760],xmm0
   1855b799d:	00 
   1855b799e:	48 8d 57 18          	lea    rdx,[rdi+0x18]
   1855b79a2:	48 81 c1 70 07 00 00 	add    rcx,0x770
   1855b79a9:	e8 72 da d8 fa       	call   0x180345420
   1855b79ae:	90                   	nop
   1855b79af:	48 8d 57 38          	lea    rdx,[rdi+0x38]
   1855b79b3:	b9 90 07 00 00       	mov    ecx,0x790
   1855b79b8:	48 03 8d e0 00 00 00 	add    rcx,QWORD PTR [rbp+0xe0]
   1855b79bf:	e8 5c da d8 fa       	call   0x180345420
   1855b79c4:	90                   	nop
   1855b79c5:	48 8d 57 58          	lea    rdx,[rdi+0x58]
   1855b79c9:	b9 d0 07 00 00       	mov    ecx,0x7d0
   1855b79ce:	48 03 8d e0 00 00 00 	add    rcx,QWORD PTR [rbp+0xe0]
   1855b79d5:	e8 46 da d8 fa       	call   0x180345420
   1855b79da:	90                   	nop
   1855b79db:	f2 0f 2c 47 10       	cvttsd2si eax,QWORD PTR [rdi+0x10]
   1855b79e0:	48 8b 8d e0 00 00 00 	mov    rcx,QWORD PTR [rbp+0xe0]
   1855b79e7:	89 81 68 07 00 00    	mov    DWORD PTR [rcx+0x768],eax
   1855b79ed:	48 8d bd e0 00 00 00 	lea    rdi,[rbp+0xe0]
   1855b79f4:	48 89 f1             	mov    rcx,rsi
   1855b79f7:	48 89 fa             	mov    rdx,rdi
   1855b79fa:	e8 41 7e 16 fb       	call   0x18071f840
   1855b79ff:	48 89 f9             	mov    rcx,rdi
   1855b7a02:	e8 59 a6 a4 fa       	call   0x180002060
   1855b7a07:	e9 79 01 00 00       	jmp    0x1855b7b85
   1855b7a0c:	b9 04 00 00 00       	mov    ecx,0x4
   1855b7a11:	e8 ca 53 ab fa       	call   0x18006cde0
   1855b7a16:	bb 01 00 00 00       	mov    ebx,0x1
   1855b7a1b:	85 c0                	test   eax,eax
   1855b7a1d:	0f 84 51 02 00 00    	je     0x1855b7c74
   1855b7a23:	48 8d b5 70 01 00 00 	lea    rsi,[rbp+0x170]
   1855b7a2a:	48 89 f1             	mov    rcx,rsi
   1855b7a2d:	e8 de 54 ab fa       	call   0x18006cf10
   1855b7a32:	90                   	nop
   1855b7a33:	48 83 bd 88 01 00 00 	cmp    QWORD PTR [rbp+0x188],0x10
   1855b7a3a:	10 
   1855b7a3b:	72 07                	jb     0x1855b7a44
   1855b7a3d:	48 8b b5 70 01 00 00 	mov    rsi,QWORD PTR [rbp+0x170]
   1855b7a44:	48 8d 05 95 9e 26 04 	lea    rax,[rip+0x4269e95]        # 0x1898218e0
   1855b7a4b:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1855b7a50:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   1855b7a57:	00 00 
   1855b7a59:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   1855b7a5e:	c7 44 24 28 dc 01 00 	mov    DWORD PTR [rsp+0x28],0x1dc
   1855b7a65:	00 
   1855b7a66:	4c 8d 0d d3 9e 26 04 	lea    r9,[rip+0x4269ed3]        # 0x189821940
   1855b7a6d:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b7a74:	ba 04 00 00 00       	mov    edx,0x4
   1855b7a79:	49 89 f0             	mov    r8,rsi
   1855b7a7c:	e8 ef 57 ab fa       	call   0x18006d270
   1855b7a81:	90                   	nop
   1855b7a82:	0f 57 c0             	xorps  xmm0,xmm0
   1855b7a85:	0f 29 85 30 02 00 00 	movaps XMMWORD PTR [rbp+0x230],xmm0
   1855b7a8c:	0f 29 85 20 02 00 00 	movaps XMMWORD PTR [rbp+0x220],xmm0
   1855b7a93:	0f 29 85 10 02 00 00 	movaps XMMWORD PTR [rbp+0x210],xmm0
   1855b7a9a:	0f 29 85 00 02 00 00 	movaps XMMWORD PTR [rbp+0x200],xmm0
   1855b7aa1:	0f 29 85 f0 01 00 00 	movaps XMMWORD PTR [rbp+0x1f0],xmm0
   1855b7aa8:	0f 29 85 e0 01 00 00 	movaps XMMWORD PTR [rbp+0x1e0],xmm0
   1855b7aaf:	0f 29 85 d0 01 00 00 	movaps XMMWORD PTR [rbp+0x1d0],xmm0
   1855b7ab6:	0f 29 85 c0 01 00 00 	movaps XMMWORD PTR [rbp+0x1c0],xmm0
   1855b7abd:	48 8d 15 5c a0 26 04 	lea    rdx,[rip+0x426a05c]        # 0x189821b20
   1855b7ac4:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b7acb:	4c 8d 85 c0 01 00 00 	lea    r8,[rbp+0x1c0]
   1855b7ad2:	e8 39 5d ab fa       	call   0x18006d810
   1855b7ad7:	90                   	nop
   1855b7ad8:	e9 7b 01 00 00       	jmp    0x1855b7c58
   1855b7add:	45 31 f6             	xor    r14d,r14d
   1855b7ae0:	48 8b bf f0 05 00 00 	mov    rdi,QWORD PTR [rdi+0x5f0]
   1855b7ae7:	48 89 7d 70          	mov    QWORD PTR [rbp+0x70],rdi
   1855b7aeb:	4c 89 75 78          	mov    QWORD PTR [rbp+0x78],r14
   1855b7aef:	48 85 ff             	test   rdi,rdi
   1855b7af2:	0f 84 94 00 00 00    	je     0x1855b7b8c
   1855b7af8:	0f 29 85 e0 00 00 00 	movaps XMMWORD PTR [rbp+0xe0],xmm0
   1855b7aff:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b7b06:	e8 f5 14 50 fc       	call   0x181ab9000
   1855b7b0b:	90                   	nop
   1855b7b0c:	48 8b 85 e0 00 00 00 	mov    rax,QWORD PTR [rbp+0xe0]
   1855b7b13:	48 b9 31 00 00 00 33 	movabs rcx,0x3300000031
   1855b7b1a:	00 00 00 
   1855b7b1d:	48 89 88 18 01 00 00 	mov    QWORD PTR [rax+0x118],rcx
   1855b7b24:	48 8d 8d c0 01 00 00 	lea    rcx,[rbp+0x1c0]
   1855b7b2b:	e8 20 31 00 00       	call   0x1855bac50
   1855b7b30:	90                   	nop
   1855b7b31:	b9 e0 07 00 00       	mov    ecx,0x7e0
   1855b7b36:	48 03 8d e0 00 00 00 	add    rcx,QWORD PTR [rbp+0xe0]
   1855b7b3d:	48 8d 9d c0 01 00 00 	lea    rbx,[rbp+0x1c0]
   1855b7b44:	48 89 da             	mov    rdx,rbx
   1855b7b47:	e8 64 ff 49 fb       	call   0x180a57ab0
   1855b7b4c:	48 89 d9             	mov    rcx,rbx
   1855b7b4f:	e8 0c a5 a4 fa       	call   0x180002060
   1855b7b54:	48 8b 85 e0 00 00 00 	mov    rax,QWORD PTR [rbp+0xe0]
   1855b7b5b:	48 8b 88 e0 07 00 00 	mov    rcx,QWORD PTR [rax+0x7e0]
   1855b7b62:	48 89 fa             	mov    rdx,rdi
   1855b7b65:	e8 b6 79 50 fd       	call   0x182abf520
   1855b7b6a:	90                   	nop
   1855b7b6b:	48 8d bd e0 00 00 00 	lea    rdi,[rbp+0xe0]
   1855b7b72:	48 89 f1             	mov    rcx,rsi
   1855b7b75:	48 89 fa             	mov    rdx,rdi
   1855b7b78:	e8 c3 7c 16 fb       	call   0x18071f840
   1855b7b7d:	48 89 f9             	mov    rcx,rdi
   1855b7b80:	e8 db a4 a4 fa       	call   0x180002060
   1855b7b85:	31 db                	xor    ebx,ebx
   1855b7b87:	e9 e8 00 00 00       	jmp    0x1855b7c74
   1855b7b8c:	b9 04 00 00 00       	mov    ecx,0x4
   1855b7b91:	e8 4a 52 ab fa       	call   0x18006cde0
   1855b7b96:	bb 01 00 00 00       	mov    ebx,0x1
   1855b7b9b:	85 c0                	test   eax,eax
   1855b7b9d:	0f 84 d1 00 00 00    	je     0x1855b7c74
   1855b7ba3:	48 8d b5 70 01 00 00 	lea    rsi,[rbp+0x170]
   1855b7baa:	48 89 f1             	mov    rcx,rsi
   1855b7bad:	e8 5e 53 ab fa       	call   0x18006cf10
   1855b7bb2:	90                   	nop
   1855b7bb3:	48 83 bd 88 01 00 00 	cmp    QWORD PTR [rbp+0x188],0x10
   1855b7bba:	10 
   1855b7bbb:	72 07                	jb     0x1855b7bc4
   1855b7bbd:	48 8b b5 70 01 00 00 	mov    rsi,QWORD PTR [rbp+0x170]
   1855b7bc4:	48 8d 05 15 9d 26 04 	lea    rax,[rip+0x4269d15]        # 0x1898218e0
   1855b7bcb:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1855b7bd0:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   1855b7bd7:	00 00 
   1855b7bd9:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   1855b7bde:	c7 44 24 28 5e 02 00 	mov    DWORD PTR [rsp+0x28],0x25e
   1855b7be5:	00 
   1855b7be6:	4c 8d 0d 53 9d 26 04 	lea    r9,[rip+0x4269d53]        # 0x189821940
   1855b7bed:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b7bf4:	ba 04 00 00 00       	mov    edx,0x4
   1855b7bf9:	49 89 f0             	mov    r8,rsi
   1855b7bfc:	e8 6f 56 ab fa       	call   0x18006d270
   1855b7c01:	90                   	nop
   1855b7c02:	0f 57 c0             	xorps  xmm0,xmm0
   1855b7c05:	0f 29 85 30 02 00 00 	movaps XMMWORD PTR [rbp+0x230],xmm0
   1855b7c0c:	0f 29 85 20 02 00 00 	movaps XMMWORD PTR [rbp+0x220],xmm0
   1855b7c13:	0f 29 85 10 02 00 00 	movaps XMMWORD PTR [rbp+0x210],xmm0
   1855b7c1a:	0f 29 85 00 02 00 00 	movaps XMMWORD PTR [rbp+0x200],xmm0
   1855b7c21:	0f 29 85 f0 01 00 00 	movaps XMMWORD PTR [rbp+0x1f0],xmm0
   1855b7c28:	0f 29 85 e0 01 00 00 	movaps XMMWORD PTR [rbp+0x1e0],xmm0
   1855b7c2f:	0f 29 85 d0 01 00 00 	movaps XMMWORD PTR [rbp+0x1d0],xmm0
   1855b7c36:	0f 29 85 c0 01 00 00 	movaps XMMWORD PTR [rbp+0x1c0],xmm0
   1855b7c3d:	48 8d 15 cc 9f 26 04 	lea    rdx,[rip+0x4269fcc]        # 0x189821c10
   1855b7c44:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b7c4b:	4c 8d 85 c0 01 00 00 	lea    r8,[rbp+0x1c0]
   1855b7c52:	e8 b9 5b ab fa       	call   0x18006d810
   1855b7c57:	90                   	nop
   1855b7c58:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b7c5f:	e8 0c 57 ab fa       	call   0x18006d370
   1855b7c64:	48 8d 8d 70 01 00 00 	lea    rcx,[rbp+0x170]
   1855b7c6b:	e8 a0 a3 a4 fa       	call   0x180002010
   1855b7c70:	4c 8b 75 78          	mov    r14,QWORD PTR [rbp+0x78]
   1855b7c74:	4d 85 f6             	test   r14,r14
   1855b7c77:	0f 84 40 19 00 00    	je     0x1855b95bd
   1855b7c7d:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   1855b7c82:	0f 85 35 19 00 00    	jne    0x1855b95bd
   1855b7c88:	49 8b 06             	mov    rax,QWORD PTR [r14]
   1855b7c8b:	4c 89 f1             	mov    rcx,r14
   1855b7c8e:	ff 10                	call   QWORD PTR [rax]
   1855b7c90:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   1855b7c95:	0f 85 22 19 00 00    	jne    0x1855b95bd
   1855b7c9b:	49 8b 06             	mov    rax,QWORD PTR [r14]
   1855b7c9e:	4c 89 f1             	mov    rcx,r14
   1855b7ca1:	e9 14 19 00 00       	jmp    0x1855b95ba
   1855b7ca6:	31 c0                	xor    eax,eax
   1855b7ca8:	48 8b 9f b0 05 00 00 	mov    rbx,QWORD PTR [rdi+0x5b0]
   1855b7caf:	48 89 5d 70          	mov    QWORD PTR [rbp+0x70],rbx
   1855b7cb3:	48 89 45 78          	mov    QWORD PTR [rbp+0x78],rax
   1855b7cb7:	48 85 db             	test   rbx,rbx
   1855b7cba:	0f 84 83 01 00 00    	je     0x1855b7e43
   1855b7cc0:	48 89 d9             	mov    rcx,rbx
   1855b7cc3:	e8 b8 8c 50 fb       	call   0x180ac0980
   1855b7cc8:	90                   	nop
   1855b7cc9:	84 c0                	test   al,al
   1855b7ccb:	0f 84 ca 0d 00 00    	je     0x1855b8a9b
   1855b7cd1:	0f 29 b5 c0 01 00 00 	movaps XMMWORD PTR [rbp+0x1c0],xmm6
   1855b7cd8:	48 8d 8d c0 01 00 00 	lea    rcx,[rbp+0x1c0]
   1855b7cdf:	e8 6c 53 f2 fc       	call   0x1824dd050
   1855b7ce4:	90                   	nop
   1855b7ce5:	48 8b 8d c0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1c0]
   1855b7cec:	48 b8 31 00 00 00 21 	movabs rax,0x2100000031
   1855b7cf3:	00 00 00 
   1855b7cf6:	48 89 81 18 01 00 00 	mov    QWORD PTR [rcx+0x118],rax
   1855b7cfd:	48 8d 97 90 01 00 00 	lea    rdx,[rdi+0x190]
   1855b7d04:	48 81 c1 58 07 00 00 	add    rcx,0x758
   1855b7d0b:	e8 10 d7 d8 fa       	call   0x180345420
   1855b7d10:	90                   	nop
   1855b7d11:	48 8d 97 b0 01 00 00 	lea    rdx,[rdi+0x1b0]
   1855b7d18:	b9 78 07 00 00       	mov    ecx,0x778
   1855b7d1d:	48 03 8d c0 01 00 00 	add    rcx,QWORD PTR [rbp+0x1c0]
   1855b7d24:	e8 f7 d6 d8 fa       	call   0x180345420
   1855b7d29:	90                   	nop
   1855b7d2a:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b7d31:	41 b8 02 00 00 00    	mov    r8d,0x2
   1855b7d37:	48 89 fa             	mov    rdx,rdi
   1855b7d3a:	45 31 c9             	xor    r9d,r9d
   1855b7d3d:	e8 ee bb fa fe       	call   0x184563930
   1855b7d42:	90                   	nop
   1855b7d43:	b9 10 09 00 00       	mov    ecx,0x910
   1855b7d48:	48 03 8d c0 01 00 00 	add    rcx,QWORD PTR [rbp+0x1c0]
   1855b7d4f:	48 8d bd e0 00 00 00 	lea    rdi,[rbp+0xe0]
   1855b7d56:	48 89 fa             	mov    rdx,rdi
   1855b7d59:	e8 e2 38 ae fa       	call   0x18009b640
   1855b7d5e:	48 89 f9             	mov    rcx,rdi
   1855b7d61:	e8 fa fc a4 fa       	call   0x180007a60
   1855b7d66:	b9 08 08 00 00       	mov    ecx,0x808
   1855b7d6b:	48 03 8d c0 01 00 00 	add    rcx,QWORD PTR [rbp+0x1c0]
   1855b7d72:	48 89 da             	mov    rdx,rbx
   1855b7d75:	e8 a6 d6 d8 fa       	call   0x180345420
   1855b7d7a:	90                   	nop
   1855b7d7b:	48 8d 93 80 00 00 00 	lea    rdx,[rbx+0x80]
   1855b7d82:	b9 e8 07 00 00       	mov    ecx,0x7e8
   1855b7d87:	48 03 8d c0 01 00 00 	add    rcx,QWORD PTR [rbp+0x1c0]
   1855b7d8e:	e8 8d d6 d8 fa       	call   0x180345420
   1855b7d93:	90                   	nop
   1855b7d94:	48 8d 53 60          	lea    rdx,[rbx+0x60]
   1855b7d98:	b9 98 07 00 00       	mov    ecx,0x798
   1855b7d9d:	48 03 8d c0 01 00 00 	add    rcx,QWORD PTR [rbp+0x1c0]
   1855b7da4:	e8 77 d6 d8 fa       	call   0x180345420
   1855b7da9:	90                   	nop
   1855b7daa:	48 8d 53 40          	lea    rdx,[rbx+0x40]
   1855b7dae:	b9 28 08 00 00       	mov    ecx,0x828
   1855b7db3:	48 03 8d c0 01 00 00 	add    rcx,QWORD PTR [rbp+0x1c0]
   1855b7dba:	e8 61 d6 d8 fa       	call   0x180345420
   1855b7dbf:	90                   	nop
   1855b7dc0:	8b 83 a0 00 00 00    	mov    eax,DWORD PTR [rbx+0xa0]
   1855b7dc6:	48 8b 8d c0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1c0]
   1855b7dcd:	89 81 48 08 00 00    	mov    DWORD PTR [rcx+0x848],eax
   1855b7dd3:	8b 83 a8 00 00 00    	mov    eax,DWORD PTR [rbx+0xa8]
   1855b7dd9:	89 81 4c 08 00 00    	mov    DWORD PTR [rcx+0x84c],eax
   1855b7ddf:	48 8d 7b 20          	lea    rdi,[rbx+0x20]
   1855b7de3:	48 81 c1 58 08 00 00 	add    rcx,0x858
   1855b7dea:	48 89 fa             	mov    rdx,rdi
   1855b7ded:	e8 2e d6 d8 fa       	call   0x180345420
   1855b7df2:	90                   	nop
   1855b7df3:	8b 83 ac 00 00 00    	mov    eax,DWORD PTR [rbx+0xac]
   1855b7df9:	48 8b 8d c0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1c0]
   1855b7e00:	89 81 78 08 00 00    	mov    DWORD PTR [rcx+0x878],eax
   1855b7e06:	8b 83 a4 00 00 00    	mov    eax,DWORD PTR [rbx+0xa4]
   1855b7e0c:	89 81 a0 08 00 00    	mov    DWORD PTR [rcx+0x8a0],eax
   1855b7e12:	48 81 c1 f0 08 00 00 	add    rcx,0x8f0
   1855b7e19:	48 89 fa             	mov    rdx,rdi
   1855b7e1c:	e8 ff d5 d8 fa       	call   0x180345420
   1855b7e21:	90                   	nop
   1855b7e22:	48 8d bd c0 01 00 00 	lea    rdi,[rbp+0x1c0]
   1855b7e29:	48 89 f1             	mov    rcx,rsi
   1855b7e2c:	48 89 fa             	mov    rdx,rdi
   1855b7e2f:	e8 0c 7a 16 fb       	call   0x18071f840
   1855b7e34:	48 89 f9             	mov    rcx,rdi
   1855b7e37:	e8 24 a2 a4 fa       	call   0x180002060
   1855b7e3c:	31 db                	xor    ebx,ebx
   1855b7e3e:	e9 54 17 00 00       	jmp    0x1855b9597
   1855b7e43:	b9 04 00 00 00       	mov    ecx,0x4
   1855b7e48:	e8 93 4f ab fa       	call   0x18006cde0
   1855b7e4d:	bb 01 00 00 00       	mov    ebx,0x1
   1855b7e52:	85 c0                	test   eax,eax
   1855b7e54:	0f 84 3d 17 00 00    	je     0x1855b9597
   1855b7e5a:	48 8d b5 70 01 00 00 	lea    rsi,[rbp+0x170]
   1855b7e61:	48 89 f1             	mov    rcx,rsi
   1855b7e64:	e8 a7 50 ab fa       	call   0x18006cf10
   1855b7e69:	90                   	nop
   1855b7e6a:	48 83 bd 88 01 00 00 	cmp    QWORD PTR [rbp+0x188],0x10
   1855b7e71:	10 
   1855b7e72:	72 07                	jb     0x1855b7e7b
   1855b7e74:	48 8b b5 70 01 00 00 	mov    rsi,QWORD PTR [rbp+0x170]
   1855b7e7b:	48 8d 05 5e 9a 26 04 	lea    rax,[rip+0x4269a5e]        # 0x1898218e0
   1855b7e82:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1855b7e87:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   1855b7e8e:	00 00 
   1855b7e90:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   1855b7e95:	c7 44 24 28 2b 02 00 	mov    DWORD PTR [rsp+0x28],0x22b
   1855b7e9c:	00 
   1855b7e9d:	4c 8d 0d 9c 9a 26 04 	lea    r9,[rip+0x4269a9c]        # 0x189821940
   1855b7ea4:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b7eab:	ba 04 00 00 00       	mov    edx,0x4
   1855b7eb0:	49 89 f0             	mov    r8,rsi
   1855b7eb3:	e8 b8 53 ab fa       	call   0x18006d270
   1855b7eb8:	90                   	nop
   1855b7eb9:	0f 57 c0             	xorps  xmm0,xmm0
   1855b7ebc:	0f 29 85 30 02 00 00 	movaps XMMWORD PTR [rbp+0x230],xmm0
   1855b7ec3:	0f 29 85 20 02 00 00 	movaps XMMWORD PTR [rbp+0x220],xmm0
   1855b7eca:	0f 29 85 10 02 00 00 	movaps XMMWORD PTR [rbp+0x210],xmm0
   1855b7ed1:	0f 29 85 00 02 00 00 	movaps XMMWORD PTR [rbp+0x200],xmm0
   1855b7ed8:	0f 29 85 f0 01 00 00 	movaps XMMWORD PTR [rbp+0x1f0],xmm0
   1855b7edf:	0f 29 85 e0 01 00 00 	movaps XMMWORD PTR [rbp+0x1e0],xmm0
   1855b7ee6:	0f 29 85 d0 01 00 00 	movaps XMMWORD PTR [rbp+0x1d0],xmm0
   1855b7eed:	0f 29 85 c0 01 00 00 	movaps XMMWORD PTR [rbp+0x1c0],xmm0
   1855b7ef4:	48 8d 15 e5 9c 26 04 	lea    rdx,[rip+0x4269ce5]        # 0x189821be0
   1855b7efb:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b7f02:	4c 8d 85 c0 01 00 00 	lea    r8,[rbp+0x1c0]
   1855b7f09:	e8 02 59 ab fa       	call   0x18006d810
   1855b7f0e:	90                   	nop
   1855b7f0f:	e9 6b 16 00 00       	jmp    0x1855b957f
   1855b7f14:	0f 57 c0             	xorps  xmm0,xmm0
   1855b7f17:	0f 29 45 70          	movaps XMMWORD PTR [rbp+0x70],xmm0
   1855b7f1b:	48 8b bd e8 00 00 00 	mov    rdi,QWORD PTR [rbp+0xe8]
   1855b7f22:	48 85 ff             	test   rdi,rdi
   1855b7f25:	0f 84 a1 14 00 00    	je     0x1855b93cc
   1855b7f2b:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   1855b7f2f:	0f 85 cf e9 ff ff    	jne    0x1855b6904
   1855b7f35:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1855b7f38:	48 89 f9             	mov    rcx,rdi
   1855b7f3b:	ff 10                	call   QWORD PTR [rax]
   1855b7f3d:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   1855b7f41:	0f 85 bd e9 ff ff    	jne    0x1855b6904
   1855b7f47:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1855b7f4a:	48 89 f9             	mov    rcx,rdi
   1855b7f4d:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1855b7f50:	48 8b 4d 70          	mov    rcx,QWORD PTR [rbp+0x70]
   1855b7f54:	48 85 c9             	test   rcx,rcx
   1855b7f57:	0f 85 b4 e9 ff ff    	jne    0x1855b6911
   1855b7f5d:	e9 75 14 00 00       	jmp    0x1855b93d7
   1855b7f62:	0f 57 c0             	xorps  xmm0,xmm0
   1855b7f65:	0f 29 45 70          	movaps XMMWORD PTR [rbp+0x70],xmm0
   1855b7f69:	48 8b bd e8 00 00 00 	mov    rdi,QWORD PTR [rbp+0xe8]
   1855b7f70:	48 85 ff             	test   rdi,rdi
   1855b7f73:	0f 84 2f 15 00 00    	je     0x1855b94a8
   1855b7f79:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   1855b7f7d:	0f 85 39 ed ff ff    	jne    0x1855b6cbc
   1855b7f83:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1855b7f86:	48 89 f9             	mov    rcx,rdi
   1855b7f89:	ff 10                	call   QWORD PTR [rax]
   1855b7f8b:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   1855b7f8f:	0f 85 27 ed ff ff    	jne    0x1855b6cbc
   1855b7f95:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1855b7f98:	48 89 f9             	mov    rcx,rdi
   1855b7f9b:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1855b7f9e:	48 8b 4d 70          	mov    rcx,QWORD PTR [rbp+0x70]
   1855b7fa2:	48 85 c9             	test   rcx,rcx
   1855b7fa5:	0f 85 1e ed ff ff    	jne    0x1855b6cc9
   1855b7fab:	e9 03 15 00 00       	jmp    0x1855b94b3
   1855b7fb0:	31 c9                	xor    ecx,ecx
   1855b7fb2:	48 8b 95 70 01 00 00 	mov    rdx,QWORD PTR [rbp+0x170]
   1855b7fb9:	48 89 90 58 07 00 00 	mov    QWORD PTR [rax+0x758],rdx
   1855b7fc0:	48 8b b8 60 07 00 00 	mov    rdi,QWORD PTR [rax+0x760]
   1855b7fc7:	48 89 88 60 07 00 00 	mov    QWORD PTR [rax+0x760],rcx
   1855b7fce:	48 85 ff             	test   rdi,rdi
   1855b7fd1:	74 1d                	je     0x1855b7ff0
   1855b7fd3:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   1855b7fd7:	75 17                	jne    0x1855b7ff0
   1855b7fd9:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1855b7fdc:	48 89 f9             	mov    rcx,rdi
   1855b7fdf:	ff 10                	call   QWORD PTR [rax]
   1855b7fe1:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   1855b7fe5:	75 09                	jne    0x1855b7ff0
   1855b7fe7:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1855b7fea:	48 89 f9             	mov    rcx,rdi
   1855b7fed:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1855b7ff0:	48 8b 85 c8 01 00 00 	mov    rax,QWORD PTR [rbp+0x1c8]
   1855b7ff7:	48 85 c0             	test   rax,rax
   1855b7ffa:	74 0d                	je     0x1855b8009
   1855b7ffc:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   1855b8000:	48 8b 85 c8 01 00 00 	mov    rax,QWORD PTR [rbp+0x1c8]
   1855b8007:	eb 02                	jmp    0x1855b800b
   1855b8009:	31 c0                	xor    eax,eax
   1855b800b:	48 8b 8d c0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1c0]
   1855b8012:	48 89 0e             	mov    QWORD PTR [rsi],rcx
   1855b8015:	48 8b 7e 08          	mov    rdi,QWORD PTR [rsi+0x8]
   1855b8019:	48 89 46 08          	mov    QWORD PTR [rsi+0x8],rax
   1855b801d:	48 85 ff             	test   rdi,rdi
   1855b8020:	74 1d                	je     0x1855b803f
   1855b8022:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   1855b8026:	75 17                	jne    0x1855b803f
   1855b8028:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1855b802b:	48 89 f9             	mov    rcx,rdi
   1855b802e:	ff 10                	call   QWORD PTR [rax]
   1855b8030:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   1855b8034:	75 09                	jne    0x1855b803f
   1855b8036:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1855b8039:	48 89 f9             	mov    rcx,rdi
   1855b803c:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1855b803f:	48 8b 75 78          	mov    rsi,QWORD PTR [rbp+0x78]
   1855b8043:	48 85 f6             	test   rsi,rsi
   1855b8046:	74 1d                	je     0x1855b8065
   1855b8048:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   1855b804c:	75 17                	jne    0x1855b8065
   1855b804e:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1855b8051:	48 89 f1             	mov    rcx,rsi
   1855b8054:	ff 10                	call   QWORD PTR [rax]
   1855b8056:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   1855b805a:	75 09                	jne    0x1855b8065
   1855b805c:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1855b805f:	48 89 f1             	mov    rcx,rsi
   1855b8062:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1855b8065:	48 8b b5 78 01 00 00 	mov    rsi,QWORD PTR [rbp+0x178]
   1855b806c:	48 85 f6             	test   rsi,rsi
   1855b806f:	0f 85 88 0c 00 00    	jne    0x1855b8cfd
   1855b8075:	e9 a0 0c 00 00       	jmp    0x1855b8d1a
   1855b807a:	31 c0                	xor    eax,eax
   1855b807c:	48 8b 4d 40          	mov    rcx,QWORD PTR [rbp+0x40]
   1855b8080:	48 89 0e             	mov    QWORD PTR [rsi],rcx
   1855b8083:	48 8b 7e 08          	mov    rdi,QWORD PTR [rsi+0x8]
   1855b8087:	48 89 46 08          	mov    QWORD PTR [rsi+0x8],rax
   1855b808b:	48 85 ff             	test   rdi,rdi
   1855b808e:	74 1d                	je     0x1855b80ad
   1855b8090:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   1855b8094:	75 17                	jne    0x1855b80ad
   1855b8096:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1855b8099:	48 89 f9             	mov    rcx,rdi
   1855b809c:	ff 10                	call   QWORD PTR [rax]
   1855b809e:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   1855b80a2:	75 09                	jne    0x1855b80ad
   1855b80a4:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1855b80a7:	48 89 f9             	mov    rcx,rdi
   1855b80aa:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1855b80ad:	31 db                	xor    ebx,ebx
   1855b80af:	e9 a8 00 00 00       	jmp    0x1855b815c
   1855b80b4:	48 89 85 c0 01 00 00 	mov    QWORD PTR [rbp+0x1c0],rax
   1855b80bb:	48 c7 85 c8 01 00 00 	mov    QWORD PTR [rbp+0x1c8],0x0
   1855b80c2:	00 00 00 00 
   1855b80c6:	48 8b 8d c0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1c0]
   1855b80cd:	41 b8 01 00 00 00    	mov    r8d,0x1
   1855b80d3:	48 89 fa             	mov    rdx,rdi
   1855b80d6:	45 31 c9             	xor    r9d,r9d
   1855b80d9:	e8 c2 5d 07 fe       	call   0x18362dea0
   1855b80de:	90                   	nop
   1855b80df:	48 8b b5 c8 01 00 00 	mov    rsi,QWORD PTR [rbp+0x1c8]
   1855b80e6:	48 85 f6             	test   rsi,rsi
   1855b80e9:	74 1d                	je     0x1855b8108
   1855b80eb:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   1855b80ef:	75 17                	jne    0x1855b8108
   1855b80f1:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1855b80f4:	48 89 f1             	mov    rcx,rsi
   1855b80f7:	ff 10                	call   QWORD PTR [rax]
   1855b80f9:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   1855b80fd:	75 09                	jne    0x1855b8108
   1855b80ff:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1855b8102:	48 89 f1             	mov    rcx,rsi
   1855b8105:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1855b8108:	48 8b b5 78 01 00 00 	mov    rsi,QWORD PTR [rbp+0x178]
   1855b810f:	48 85 f6             	test   rsi,rsi
   1855b8112:	74 1d                	je     0x1855b8131
   1855b8114:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   1855b8118:	75 17                	jne    0x1855b8131
   1855b811a:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1855b811d:	48 89 f1             	mov    rcx,rsi
   1855b8120:	ff 10                	call   QWORD PTR [rax]
   1855b8122:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   1855b8126:	75 09                	jne    0x1855b8131
   1855b8128:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1855b812b:	48 89 f1             	mov    rcx,rsi
   1855b812e:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1855b8131:	48 8b 75 58          	mov    rsi,QWORD PTR [rbp+0x58]
   1855b8135:	48 85 f6             	test   rsi,rsi
   1855b8138:	74 1d                	je     0x1855b8157
   1855b813a:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   1855b813e:	75 17                	jne    0x1855b8157
   1855b8140:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1855b8143:	48 89 f1             	mov    rcx,rsi
   1855b8146:	ff 10                	call   QWORD PTR [rax]
   1855b8148:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   1855b814c:	75 09                	jne    0x1855b8157
   1855b814e:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1855b8151:	48 89 f1             	mov    rcx,rsi
   1855b8154:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1855b8157:	bb 03 00 00 00       	mov    ebx,0x3
   1855b815c:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b8160:	e8 fb f8 a4 fa       	call   0x180007a60
   1855b8165:	48 8d 4d 70          	lea    rcx,[rbp+0x70]
   1855b8169:	e8 f2 f8 a4 fa       	call   0x180007a60
   1855b816e:	48 8b 75 48          	mov    rsi,QWORD PTR [rbp+0x48]
   1855b8172:	e9 24 14 00 00       	jmp    0x1855b959b
   1855b8177:	48 83 f9 10          	cmp    rcx,0x10
   1855b817b:	72 03                	jb     0x1855b8180
   1855b817d:	48 8b 1b             	mov    rbx,QWORD PTR [rbx]
   1855b8180:	4c 89 b0 a8 07 00 00 	mov    QWORD PTR [rax+0x7a8],r14
   1855b8187:	48 89 d9             	mov    rcx,rbx
   1855b818a:	4c 89 ca             	mov    rdx,r9
   1855b818d:	4d 89 f0             	mov    r8,r14
   1855b8190:	e8 bb be f8 01       	call   0x187544050
   1855b8195:	42 c6 04 33 00       	mov    BYTE PTR [rbx+r14*1],0x0
   1855b819a:	4c 8d 8f 90 01 00 00 	lea    r9,[rdi+0x190]
   1855b81a1:	48 8b 85 e0 00 00 00 	mov    rax,QWORD PTR [rbp+0xe0]
   1855b81a8:	48 8d 98 58 07 00 00 	lea    rbx,[rax+0x758]
   1855b81af:	4c 39 cb             	cmp    rbx,r9
   1855b81b2:	0f 84 27 04 00 00    	je     0x1855b85df
   1855b81b8:	4c 8b b7 a0 01 00 00 	mov    r14,QWORD PTR [rdi+0x1a0]
   1855b81bf:	48 83 bf a8 01 00 00 	cmp    QWORD PTR [rdi+0x1a8],0x10
   1855b81c6:	10 
   1855b81c7:	72 07                	jb     0x1855b81d0
   1855b81c9:	4c 8b 8f 90 01 00 00 	mov    r9,QWORD PTR [rdi+0x190]
   1855b81d0:	48 8b 88 70 07 00 00 	mov    rcx,QWORD PTR [rax+0x770]
   1855b81d7:	49 39 ce             	cmp    r14,rcx
   1855b81da:	0f 86 dc 03 00 00    	jbe    0x1855b85bc
   1855b81e0:	48 89 d9             	mov    rcx,rbx
   1855b81e3:	4c 89 f2             	mov    rdx,r14
   1855b81e6:	e8 65 5f a8 fa       	call   0x18003e150
   1855b81eb:	90                   	nop
   1855b81ec:	e9 ee 03 00 00       	jmp    0x1855b85df
   1855b81f1:	48 83 f9 10          	cmp    rcx,0x10
   1855b81f5:	72 03                	jb     0x1855b81fa
   1855b81f7:	48 8b 1b             	mov    rbx,QWORD PTR [rbx]
   1855b81fa:	4c 89 b0 a8 07 00 00 	mov    QWORD PTR [rax+0x7a8],r14
   1855b8201:	48 89 d9             	mov    rcx,rbx
   1855b8204:	4c 89 ca             	mov    rdx,r9
   1855b8207:	4d 89 f0             	mov    r8,r14
   1855b820a:	e8 41 be f8 01       	call   0x187544050
   1855b820f:	42 c6 04 33 00       	mov    BYTE PTR [rbx+r14*1],0x0
   1855b8214:	4c 8d 8f 90 01 00 00 	lea    r9,[rdi+0x190]
   1855b821b:	48 8b 85 e0 00 00 00 	mov    rax,QWORD PTR [rbp+0xe0]
   1855b8222:	48 8d 98 58 07 00 00 	lea    rbx,[rax+0x758]
   1855b8229:	4c 39 cb             	cmp    rbx,r9
   1855b822c:	0f 84 27 04 00 00    	je     0x1855b8659
   1855b8232:	4c 8b b7 a0 01 00 00 	mov    r14,QWORD PTR [rdi+0x1a0]
   1855b8239:	48 83 bf a8 01 00 00 	cmp    QWORD PTR [rdi+0x1a8],0x10
   1855b8240:	10 
   1855b8241:	72 07                	jb     0x1855b824a
   1855b8243:	4c 8b 8f 90 01 00 00 	mov    r9,QWORD PTR [rdi+0x190]
   1855b824a:	48 8b 88 70 07 00 00 	mov    rcx,QWORD PTR [rax+0x770]
   1855b8251:	49 39 ce             	cmp    r14,rcx
   1855b8254:	0f 86 dc 03 00 00    	jbe    0x1855b8636
   1855b825a:	48 89 d9             	mov    rcx,rbx
   1855b825d:	4c 89 f2             	mov    rdx,r14
   1855b8260:	e8 eb 5e a8 fa       	call   0x18003e150
   1855b8265:	90                   	nop
   1855b8266:	e9 ee 03 00 00       	jmp    0x1855b8659
   1855b826b:	48 83 f9 10          	cmp    rcx,0x10
   1855b826f:	72 03                	jb     0x1855b8274
   1855b8271:	48 8b 1b             	mov    rbx,QWORD PTR [rbx]
   1855b8274:	4c 89 b0 b8 01 00 00 	mov    QWORD PTR [rax+0x1b8],r14
   1855b827b:	48 89 d9             	mov    rcx,rbx
   1855b827e:	4c 89 ca             	mov    rdx,r9
   1855b8281:	4d 89 f0             	mov    r8,r14
   1855b8284:	e8 c7 bd f8 01       	call   0x187544050
   1855b8289:	42 c6 04 33 00       	mov    BYTE PTR [rbx+r14*1],0x0
   1855b828e:	0f 29 b5 80 00 00 00 	movaps XMMWORD PTR [rbp+0x80],xmm6
   1855b8295:	0f 29 75 70          	movaps XMMWORD PTR [rbp+0x70],xmm6
   1855b8299:	48 8d 4d 70          	lea    rcx,[rbp+0x70]
   1855b829d:	41 b8 01 00 00 00    	mov    r8d,0x1
   1855b82a3:	48 89 fa             	mov    rdx,rdi
   1855b82a6:	45 31 c9             	xor    r9d,r9d
   1855b82a9:	e8 82 b6 fa fe       	call   0x184563930
   1855b82ae:	90                   	nop
   1855b82af:	48 8d 4d 70          	lea    rcx,[rbp+0x70]
   1855b82b3:	e8 18 65 dd fa       	call   0x18038e7d0
   1855b82b8:	90                   	nop
   1855b82b9:	84 c0                	test   al,al
   1855b82bb:	74 16                	je     0x1855b82d3
   1855b82bd:	b9 20 01 00 00       	mov    ecx,0x120
   1855b82c2:	48 03 8d c0 00 00 00 	add    rcx,QWORD PTR [rbp+0xc0]
   1855b82c9:	48 8d 55 70          	lea    rdx,[rbp+0x70]
   1855b82cd:	e8 fe 32 ae fa       	call   0x18009b5d0
   1855b82d2:	90                   	nop
   1855b82d3:	b9 20 01 00 00       	mov    ecx,0x120
   1855b82d8:	48 03 8d c0 00 00 00 	add    rcx,QWORD PTR [rbp+0xc0]
   1855b82df:	e8 ec 64 dd fa       	call   0x18038e7d0
   1855b82e4:	90                   	nop
   1855b82e5:	84 c0                	test   al,al
   1855b82e7:	75 49                	jne    0x1855b8332
   1855b82e9:	0f 29 b5 f0 00 00 00 	movaps XMMWORD PTR [rbp+0xf0],xmm6
   1855b82f0:	0f 29 b5 e0 00 00 00 	movaps XMMWORD PTR [rbp+0xe0],xmm6
   1855b82f7:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b82fe:	41 b8 01 00 00 00    	mov    r8d,0x1
   1855b8304:	48 89 fa             	mov    rdx,rdi
   1855b8307:	e8 54 7e fa fe       	call   0x184560160
   1855b830c:	90                   	nop
   1855b830d:	b9 20 01 00 00       	mov    ecx,0x120
   1855b8312:	48 03 8d c0 00 00 00 	add    rcx,QWORD PTR [rbp+0xc0]
   1855b8319:	48 8d 95 e0 00 00 00 	lea    rdx,[rbp+0xe0]
   1855b8320:	e8 ab 32 ae fa       	call   0x18009b5d0
   1855b8325:	90                   	nop
   1855b8326:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b832d:	e8 2e f7 a4 fa       	call   0x180007a60
   1855b8332:	b9 20 01 00 00       	mov    ecx,0x120
   1855b8337:	48 03 8d c0 00 00 00 	add    rcx,QWORD PTR [rbp+0xc0]
   1855b833e:	e8 8d 64 dd fa       	call   0x18038e7d0
   1855b8343:	90                   	nop
   1855b8344:	84 c0                	test   al,al
   1855b8346:	74 16                	je     0x1855b835e
   1855b8348:	48 8d 95 c0 00 00 00 	lea    rdx,[rbp+0xc0]
   1855b834f:	48 89 f1             	mov    rcx,rsi
   1855b8352:	e8 e9 74 16 fb       	call   0x18071f840
   1855b8357:	31 db                	xor    ebx,ebx
   1855b8359:	e9 a4 01 00 00       	jmp    0x1855b8502
   1855b835e:	b9 02 00 00 00       	mov    ecx,0x2
   1855b8363:	e8 78 4a ab fa       	call   0x18006cde0
   1855b8368:	85 c0                	test   eax,eax
   1855b836a:	0f 84 0f 01 00 00    	je     0x1855b847f
   1855b8370:	48 8d 75 f0          	lea    rsi,[rbp-0x10]
   1855b8374:	48 89 f1             	mov    rcx,rsi
   1855b8377:	e8 94 4b ab fa       	call   0x18006cf10
   1855b837c:	90                   	nop
   1855b837d:	48 83 7d 08 10       	cmp    QWORD PTR [rbp+0x8],0x10
   1855b8382:	72 04                	jb     0x1855b8388
   1855b8384:	48 8b 75 f0          	mov    rsi,QWORD PTR [rbp-0x10]
   1855b8388:	48 8d 05 51 95 26 04 	lea    rax,[rip+0x4269551]        # 0x1898218e0
   1855b838f:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1855b8394:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   1855b839b:	00 00 
   1855b839d:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   1855b83a2:	c7 44 24 28 0d 02 00 	mov    DWORD PTR [rsp+0x28],0x20d
   1855b83a9:	00 
   1855b83aa:	4c 8d 0d 8f 95 26 04 	lea    r9,[rip+0x426958f]        # 0x189821940
   1855b83b1:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b83b8:	ba 02 00 00 00       	mov    edx,0x2
   1855b83bd:	49 89 f0             	mov    r8,rsi
   1855b83c0:	e8 ab 4e ab fa       	call   0x18006d270
   1855b83c5:	90                   	nop
   1855b83c6:	b9 20 01 00 00       	mov    ecx,0x120
   1855b83cb:	48 03 8d c0 00 00 00 	add    rcx,QWORD PTR [rbp+0xc0]
   1855b83d2:	48 8d 75 50          	lea    rsi,[rbp+0x50]
   1855b83d6:	48 89 f2             	mov    rdx,rsi
   1855b83d9:	e8 92 76 ae fa       	call   0x18009fa70
   1855b83de:	90                   	nop
   1855b83df:	48 83 7d 68 10       	cmp    QWORD PTR [rbp+0x68],0x10
   1855b83e4:	72 04                	jb     0x1855b83ea
   1855b83e6:	48 8b 75 50          	mov    rsi,QWORD PTR [rbp+0x50]
   1855b83ea:	48 89 b5 70 01 00 00 	mov    QWORD PTR [rbp+0x170],rsi
   1855b83f1:	c6 85 78 01 00 00 00 	mov    BYTE PTR [rbp+0x178],0x0
   1855b83f8:	0f 57 c0             	xorps  xmm0,xmm0
   1855b83fb:	0f 11 85 28 02 00 00 	movups XMMWORD PTR [rbp+0x228],xmm0
   1855b8402:	0f 11 85 18 02 00 00 	movups XMMWORD PTR [rbp+0x218],xmm0
   1855b8409:	0f 11 85 08 02 00 00 	movups XMMWORD PTR [rbp+0x208],xmm0
   1855b8410:	0f 11 85 f8 01 00 00 	movups XMMWORD PTR [rbp+0x1f8],xmm0
   1855b8417:	0f 11 85 e8 01 00 00 	movups XMMWORD PTR [rbp+0x1e8],xmm0
   1855b841e:	0f 11 85 d8 01 00 00 	movups XMMWORD PTR [rbp+0x1d8],xmm0
   1855b8425:	0f 11 85 c8 01 00 00 	movups XMMWORD PTR [rbp+0x1c8],xmm0
   1855b842c:	48 c7 85 38 02 00 00 	mov    QWORD PTR [rbp+0x238],0x0
   1855b8433:	00 00 00 00 
   1855b8437:	48 8d 85 70 01 00 00 	lea    rax,[rbp+0x170]
   1855b843e:	48 89 85 c0 01 00 00 	mov    QWORD PTR [rbp+0x1c0],rax
   1855b8445:	48 8d 15 9c 95 26 04 	lea    rdx,[rip+0x426959c]        # 0x1898219e8
   1855b844c:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b8453:	4c 8d 85 c0 01 00 00 	lea    r8,[rbp+0x1c0]
   1855b845a:	e8 b1 53 ab fa       	call   0x18006d810
   1855b845f:	90                   	nop
   1855b8460:	48 8d 4d 50          	lea    rcx,[rbp+0x50]
   1855b8464:	e8 a7 9b a4 fa       	call   0x180002010
   1855b8469:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b8470:	e8 fb 4e ab fa       	call   0x18006d370
   1855b8475:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b8479:	e8 92 9b a4 fa       	call   0x180002010
   1855b847e:	90                   	nop
   1855b847f:	e8 8c d8 a8 fa       	call   0x180045d10
   1855b8484:	90                   	nop
   1855b8485:	4c 8b 00             	mov    r8,QWORD PTR [rax]
   1855b8488:	48 8d 95 70 01 00 00 	lea    rdx,[rbp+0x170]
   1855b848f:	48 89 c1             	mov    rcx,rax
   1855b8492:	41 ff 50 60          	call   QWORD PTR [r8+0x60]
   1855b8496:	90                   	nop
   1855b8497:	48 8b 8d 70 01 00 00 	mov    rcx,QWORD PTR [rbp+0x170]
   1855b849e:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   1855b84a1:	48 8d 95 c0 01 00 00 	lea    rdx,[rbp+0x1c0]
   1855b84a8:	ff 50 30             	call   QWORD PTR [rax+0x30]
   1855b84ab:	90                   	nop
   1855b84ac:	48 8b 8d c0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1c0]
   1855b84b3:	48 8d 95 e0 00 00 00 	lea    rdx,[rbp+0xe0]
   1855b84ba:	e8 b1 6a 05 fe       	call   0x18360ef70
   1855b84bf:	90                   	nop
   1855b84c0:	48 8b 8d e0 00 00 00 	mov    rcx,QWORD PTR [rbp+0xe0]
   1855b84c7:	41 b8 01 00 00 00    	mov    r8d,0x1
   1855b84cd:	48 89 fa             	mov    rdx,rdi
   1855b84d0:	45 31 c9             	xor    r9d,r9d
   1855b84d3:	e8 c8 59 07 fe       	call   0x18362dea0
   1855b84d8:	90                   	nop
   1855b84d9:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b84e0:	e8 7b 9b a4 fa       	call   0x180002060
   1855b84e5:	48 8d 8d c0 01 00 00 	lea    rcx,[rbp+0x1c0]
   1855b84ec:	e8 6f 9b a4 fa       	call   0x180002060
   1855b84f1:	48 8d 8d 70 01 00 00 	lea    rcx,[rbp+0x170]
   1855b84f8:	e8 63 9b a4 fa       	call   0x180002060
   1855b84fd:	bb 03 00 00 00       	mov    ebx,0x3
   1855b8502:	48 8d 4d 70          	lea    rcx,[rbp+0x70]
   1855b8506:	e8 55 f5 a4 fa       	call   0x180007a60
   1855b850b:	48 8b b5 c8 00 00 00 	mov    rsi,QWORD PTR [rbp+0xc8]
   1855b8512:	e9 84 10 00 00       	jmp    0x1855b959b
   1855b8517:	48 83 f9 10          	cmp    rcx,0x10
   1855b851b:	72 03                	jb     0x1855b8520
   1855b851d:	48 8b 1b             	mov    rbx,QWORD PTR [rbx]
   1855b8520:	4c 89 b0 68 07 00 00 	mov    QWORD PTR [rax+0x768],r14
   1855b8527:	48 89 d9             	mov    rcx,rbx
   1855b852a:	4c 89 ca             	mov    rdx,r9
   1855b852d:	4d 89 f0             	mov    r8,r14
   1855b8530:	e8 1b bb f8 01       	call   0x187544050
   1855b8535:	42 c6 04 33 00       	mov    BYTE PTR [rbx+r14*1],0x0
   1855b853a:	e9 f8 04 00 00       	jmp    0x1855b8a37
   1855b853f:	48 83 f9 10          	cmp    rcx,0x10
   1855b8543:	72 03                	jb     0x1855b8548
   1855b8545:	48 8b 1b             	mov    rbx,QWORD PTR [rbx]
   1855b8548:	4c 89 b0 a8 07 00 00 	mov    QWORD PTR [rax+0x7a8],r14
   1855b854f:	48 89 d9             	mov    rcx,rbx
   1855b8552:	4c 89 ca             	mov    rdx,r9
   1855b8555:	4d 89 f0             	mov    r8,r14
   1855b8558:	e8 f3 ba f8 01       	call   0x187544050
   1855b855d:	42 c6 04 33 00       	mov    BYTE PTR [rbx+r14*1],0x0
   1855b8562:	48 8d 9f d0 00 00 00 	lea    rbx,[rdi+0xd0]
   1855b8569:	48 8b 85 c0 01 00 00 	mov    rax,QWORD PTR [rbp+0x1c0]
   1855b8570:	4c 8d b0 e8 07 00 00 	lea    r14,[rax+0x7e8]
   1855b8577:	49 39 de             	cmp    r14,rbx
   1855b857a:	0f 84 53 01 00 00    	je     0x1855b86d3
   1855b8580:	4c 8b bf e0 00 00 00 	mov    r15,QWORD PTR [rdi+0xe0]
   1855b8587:	48 83 bf e8 00 00 00 	cmp    QWORD PTR [rdi+0xe8],0x10
   1855b858e:	10 
   1855b858f:	49 89 d9             	mov    r9,rbx
   1855b8592:	72 07                	jb     0x1855b859b
   1855b8594:	4c 8b 8f d0 00 00 00 	mov    r9,QWORD PTR [rdi+0xd0]
   1855b859b:	48 8b 88 00 08 00 00 	mov    rcx,QWORD PTR [rax+0x800]
   1855b85a2:	49 39 cf             	cmp    r15,rcx
   1855b85a5:	0f 86 05 01 00 00    	jbe    0x1855b86b0
   1855b85ab:	4c 89 f1             	mov    rcx,r14
   1855b85ae:	4c 89 fa             	mov    rdx,r15
   1855b85b1:	e8 9a 5b a8 fa       	call   0x18003e150
   1855b85b6:	90                   	nop
   1855b85b7:	e9 17 01 00 00       	jmp    0x1855b86d3
   1855b85bc:	48 83 f9 10          	cmp    rcx,0x10
   1855b85c0:	72 03                	jb     0x1855b85c5
   1855b85c2:	48 8b 1b             	mov    rbx,QWORD PTR [rbx]
   1855b85c5:	4c 89 b0 68 07 00 00 	mov    QWORD PTR [rax+0x768],r14
   1855b85cc:	48 89 d9             	mov    rcx,rbx
   1855b85cf:	4c 89 ca             	mov    rdx,r9
   1855b85d2:	4d 89 f0             	mov    r8,r14
   1855b85d5:	e8 76 ba f8 01       	call   0x187544050
   1855b85da:	42 c6 04 33 00       	mov    BYTE PTR [rbx+r14*1],0x0
   1855b85df:	4c 8d 8f b0 01 00 00 	lea    r9,[rdi+0x1b0]
   1855b85e6:	48 8b 85 e0 00 00 00 	mov    rax,QWORD PTR [rbp+0xe0]
   1855b85ed:	48 8d 98 78 07 00 00 	lea    rbx,[rax+0x778]
   1855b85f4:	4c 39 cb             	cmp    rbx,r9
   1855b85f7:	0f 84 7f 02 00 00    	je     0x1855b887c
   1855b85fd:	4c 8b b7 c0 01 00 00 	mov    r14,QWORD PTR [rdi+0x1c0]
   1855b8604:	48 83 bf c8 01 00 00 	cmp    QWORD PTR [rdi+0x1c8],0x10
   1855b860b:	10 
   1855b860c:	72 07                	jb     0x1855b8615
   1855b860e:	4c 8b 8f b0 01 00 00 	mov    r9,QWORD PTR [rdi+0x1b0]
   1855b8615:	48 8b 88 90 07 00 00 	mov    rcx,QWORD PTR [rax+0x790]
   1855b861c:	49 39 ce             	cmp    r14,rcx
   1855b861f:	0f 86 34 02 00 00    	jbe    0x1855b8859
   1855b8625:	48 89 d9             	mov    rcx,rbx
   1855b8628:	4c 89 f2             	mov    rdx,r14
   1855b862b:	e8 20 5b a8 fa       	call   0x18003e150
   1855b8630:	90                   	nop
   1855b8631:	e9 46 02 00 00       	jmp    0x1855b887c
   1855b8636:	48 83 f9 10          	cmp    rcx,0x10
   1855b863a:	72 03                	jb     0x1855b863f
   1855b863c:	48 8b 1b             	mov    rbx,QWORD PTR [rbx]
   1855b863f:	4c 89 b0 68 07 00 00 	mov    QWORD PTR [rax+0x768],r14
   1855b8646:	48 89 d9             	mov    rcx,rbx
   1855b8649:	4c 89 ca             	mov    rdx,r9
   1855b864c:	4d 89 f0             	mov    r8,r14
   1855b864f:	e8 fc b9 f8 01       	call   0x187544050
   1855b8654:	42 c6 04 33 00       	mov    BYTE PTR [rbx+r14*1],0x0
   1855b8659:	4c 8d 8f b0 01 00 00 	lea    r9,[rdi+0x1b0]
   1855b8660:	48 8b 85 e0 00 00 00 	mov    rax,QWORD PTR [rbp+0xe0]
   1855b8667:	48 8d 98 78 07 00 00 	lea    rbx,[rax+0x778]
   1855b866e:	4c 39 cb             	cmp    rbx,r9
   1855b8671:	0f 84 7f 02 00 00    	je     0x1855b88f6
   1855b8677:	4c 8b b7 c0 01 00 00 	mov    r14,QWORD PTR [rdi+0x1c0]
   1855b867e:	48 83 bf c8 01 00 00 	cmp    QWORD PTR [rdi+0x1c8],0x10
   1855b8685:	10 
   1855b8686:	72 07                	jb     0x1855b868f
   1855b8688:	4c 8b 8f b0 01 00 00 	mov    r9,QWORD PTR [rdi+0x1b0]
   1855b868f:	48 8b 88 90 07 00 00 	mov    rcx,QWORD PTR [rax+0x790]
   1855b8696:	49 39 ce             	cmp    r14,rcx
   1855b8699:	0f 86 34 02 00 00    	jbe    0x1855b88d3
   1855b869f:	48 89 d9             	mov    rcx,rbx
   1855b86a2:	4c 89 f2             	mov    rdx,r14
   1855b86a5:	e8 a6 5a a8 fa       	call   0x18003e150
   1855b86aa:	90                   	nop
   1855b86ab:	e9 46 02 00 00       	jmp    0x1855b88f6
   1855b86b0:	48 83 f9 10          	cmp    rcx,0x10
   1855b86b4:	72 03                	jb     0x1855b86b9
   1855b86b6:	4d 8b 36             	mov    r14,QWORD PTR [r14]
   1855b86b9:	4c 89 b8 f8 07 00 00 	mov    QWORD PTR [rax+0x7f8],r15
   1855b86c0:	4c 89 f1             	mov    rcx,r14
   1855b86c3:	4c 89 ca             	mov    rdx,r9
   1855b86c6:	4d 89 f8             	mov    r8,r15
   1855b86c9:	e8 82 b9 f8 01       	call   0x187544050
   1855b86ce:	43 c6 04 3e 00       	mov    BYTE PTR [r14+r15*1],0x0
   1855b86d3:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b86da:	41 b8 02 00 00 00    	mov    r8d,0x2
   1855b86e0:	48 89 fa             	mov    rdx,rdi
   1855b86e3:	45 31 c9             	xor    r9d,r9d
   1855b86e6:	e8 45 b2 fa fe       	call   0x184563930
   1855b86eb:	90                   	nop
   1855b86ec:	b9 68 08 00 00       	mov    ecx,0x868
   1855b86f1:	48 03 8d c0 01 00 00 	add    rcx,QWORD PTR [rbp+0x1c0]
   1855b86f8:	4c 8d b5 e0 00 00 00 	lea    r14,[rbp+0xe0]
   1855b86ff:	4c 89 f2             	mov    rdx,r14
   1855b8702:	e8 39 2f ae fa       	call   0x18009b640
   1855b8707:	4c 89 f1             	mov    rcx,r14
   1855b870a:	e8 51 f3 a4 fa       	call   0x180007a60
   1855b870f:	0f 29 b5 e0 00 00 00 	movaps XMMWORD PTR [rbp+0xe0],xmm6
   1855b8716:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1855b8719:	48 8d 95 e0 00 00 00 	lea    rdx,[rbp+0xe0]
   1855b8720:	48 89 f9             	mov    rcx,rdi
   1855b8723:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1855b8726:	90                   	nop
   1855b8727:	48 8b 8d e0 00 00 00 	mov    rcx,QWORD PTR [rbp+0xe0]
   1855b872e:	48 85 c9             	test   rcx,rcx
   1855b8731:	0f 84 85 00 00 00    	je     0x1855b87bc
   1855b8737:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   1855b873a:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1855b873d:	90                   	nop
   1855b873e:	b9 58 07 00 00       	mov    ecx,0x758
   1855b8743:	48 03 8d c0 01 00 00 	add    rcx,QWORD PTR [rbp+0x1c0]
   1855b874a:	48 89 c2             	mov    rdx,rax
   1855b874d:	e8 ce cc d8 fa       	call   0x180345420
   1855b8752:	90                   	nop
   1855b8753:	48 8b 8d e0 00 00 00 	mov    rcx,QWORD PTR [rbp+0xe0]
   1855b875a:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   1855b875d:	ff 50 10             	call   QWORD PTR [rax+0x10]
   1855b8760:	90                   	nop
   1855b8761:	b9 78 07 00 00       	mov    ecx,0x778
   1855b8766:	48 03 8d c0 01 00 00 	add    rcx,QWORD PTR [rbp+0x1c0]
   1855b876d:	48 89 c2             	mov    rdx,rax
   1855b8770:	e8 ab cc d8 fa       	call   0x180345420
   1855b8775:	90                   	nop
   1855b8776:	48 8b 8d e0 00 00 00 	mov    rcx,QWORD PTR [rbp+0xe0]
   1855b877d:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   1855b8780:	ff 50 20             	call   QWORD PTR [rax+0x20]
   1855b8783:	90                   	nop
   1855b8784:	b9 e8 07 00 00       	mov    ecx,0x7e8
   1855b8789:	48 03 8d c0 01 00 00 	add    rcx,QWORD PTR [rbp+0x1c0]
   1855b8790:	48 89 c2             	mov    rdx,rax
   1855b8793:	e8 88 cc d8 fa       	call   0x180345420
   1855b8798:	90                   	nop
   1855b8799:	48 8b 8d e0 00 00 00 	mov    rcx,QWORD PTR [rbp+0xe0]
   1855b87a0:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   1855b87a3:	ff 50 18             	call   QWORD PTR [rax+0x18]
   1855b87a6:	90                   	nop
   1855b87a7:	b9 08 08 00 00       	mov    ecx,0x808
   1855b87ac:	48 03 8d c0 01 00 00 	add    rcx,QWORD PTR [rbp+0x1c0]
   1855b87b3:	48 89 c2             	mov    rdx,rax
   1855b87b6:	e8 65 cc d8 fa       	call   0x180345420
   1855b87bb:	90                   	nop
   1855b87bc:	48 8b 8d c0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1c0]
   1855b87c3:	48 83 b9 f8 07 00 00 	cmp    QWORD PTR [rcx+0x7f8],0x0
   1855b87ca:	00 
   1855b87cb:	75 3c                	jne    0x1855b8809
   1855b87cd:	48 81 c1 e8 07 00 00 	add    rcx,0x7e8
   1855b87d4:	48 89 da             	mov    rdx,rbx
   1855b87d7:	e8 44 cc d8 fa       	call   0x180345420
   1855b87dc:	90                   	nop
   1855b87dd:	48 8b 8d c0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1c0]
   1855b87e4:	48 83 b9 f8 07 00 00 	cmp    QWORD PTR [rcx+0x7f8],0x0
   1855b87eb:	00 
   1855b87ec:	75 1b                	jne    0x1855b8809
   1855b87ee:	48 81 c1 e8 07 00 00 	add    rcx,0x7e8
   1855b87f5:	48 8d 97 d0 03 00 00 	lea    rdx,[rdi+0x3d0]
   1855b87fc:	e8 1f cc d8 fa       	call   0x180345420
   1855b8801:	90                   	nop
   1855b8802:	48 8b 8d c0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1c0]
   1855b8809:	4c 8d 8f 10 01 00 00 	lea    r9,[rdi+0x110]
   1855b8810:	48 8d 99 48 08 00 00 	lea    rbx,[rcx+0x848]
   1855b8817:	4c 39 cb             	cmp    rbx,r9
   1855b881a:	0f 84 6f 03 00 00    	je     0x1855b8b8f
   1855b8820:	4c 8b b7 20 01 00 00 	mov    r14,QWORD PTR [rdi+0x120]
   1855b8827:	48 83 bf 28 01 00 00 	cmp    QWORD PTR [rdi+0x128],0x10
   1855b882e:	10 
   1855b882f:	72 07                	jb     0x1855b8838
   1855b8831:	4c 8b 8f 10 01 00 00 	mov    r9,QWORD PTR [rdi+0x110]
   1855b8838:	48 8b 81 60 08 00 00 	mov    rax,QWORD PTR [rcx+0x860]
   1855b883f:	49 39 c6             	cmp    r14,rax
   1855b8842:	0f 86 24 03 00 00    	jbe    0x1855b8b6c
   1855b8848:	48 89 d9             	mov    rcx,rbx
   1855b884b:	4c 89 f2             	mov    rdx,r14
   1855b884e:	e8 fd 58 a8 fa       	call   0x18003e150
   1855b8853:	90                   	nop
   1855b8854:	e9 36 03 00 00       	jmp    0x1855b8b8f
   1855b8859:	48 83 f9 10          	cmp    rcx,0x10
   1855b885d:	72 03                	jb     0x1855b8862
   1855b885f:	48 8b 1b             	mov    rbx,QWORD PTR [rbx]
   1855b8862:	4c 89 b0 88 07 00 00 	mov    QWORD PTR [rax+0x788],r14
   1855b8869:	48 89 d9             	mov    rcx,rbx
   1855b886c:	4c 89 ca             	mov    rdx,r9
   1855b886f:	4d 89 f0             	mov    r8,r14
   1855b8872:	e8 d9 b7 f8 01       	call   0x187544050
   1855b8877:	42 c6 04 33 00       	mov    BYTE PTR [rbx+r14*1],0x0
   1855b887c:	4c 8d 8f c0 04 00 00 	lea    r9,[rdi+0x4c0]
   1855b8883:	48 8b 85 e0 00 00 00 	mov    rax,QWORD PTR [rbp+0xe0]
   1855b888a:	48 8d 98 e0 07 00 00 	lea    rbx,[rax+0x7e0]
   1855b8891:	4c 39 cb             	cmp    rbx,r9
   1855b8894:	0f 84 d2 00 00 00    	je     0x1855b896c
   1855b889a:	4c 8b b7 d0 04 00 00 	mov    r14,QWORD PTR [rdi+0x4d0]
   1855b88a1:	48 83 bf d8 04 00 00 	cmp    QWORD PTR [rdi+0x4d8],0x10
   1855b88a8:	10 
   1855b88a9:	72 07                	jb     0x1855b88b2
   1855b88ab:	4c 8b 8f c0 04 00 00 	mov    r9,QWORD PTR [rdi+0x4c0]
   1855b88b2:	48 8b 88 f8 07 00 00 	mov    rcx,QWORD PTR [rax+0x7f8]
   1855b88b9:	49 39 ce             	cmp    r14,rcx
   1855b88bc:	0f 86 87 00 00 00    	jbe    0x1855b8949
   1855b88c2:	48 89 d9             	mov    rcx,rbx
   1855b88c5:	4c 89 f2             	mov    rdx,r14
   1855b88c8:	e8 83 58 a8 fa       	call   0x18003e150
   1855b88cd:	90                   	nop
   1855b88ce:	e9 99 00 00 00       	jmp    0x1855b896c
   1855b88d3:	48 83 f9 10          	cmp    rcx,0x10
   1855b88d7:	72 03                	jb     0x1855b88dc
   1855b88d9:	48 8b 1b             	mov    rbx,QWORD PTR [rbx]
   1855b88dc:	4c 89 b0 88 07 00 00 	mov    QWORD PTR [rax+0x788],r14
   1855b88e3:	48 89 d9             	mov    rcx,rbx
   1855b88e6:	4c 89 ca             	mov    rdx,r9
   1855b88e9:	4d 89 f0             	mov    r8,r14
   1855b88ec:	e8 5f b7 f8 01       	call   0x187544050
   1855b88f1:	42 c6 04 33 00       	mov    BYTE PTR [rbx+r14*1],0x0
   1855b88f6:	4c 8d 8f c0 04 00 00 	lea    r9,[rdi+0x4c0]
   1855b88fd:	48 8b 85 e0 00 00 00 	mov    rax,QWORD PTR [rbp+0xe0]
   1855b8904:	48 8d 98 e0 07 00 00 	lea    rbx,[rax+0x7e0]
   1855b890b:	4c 39 cb             	cmp    rbx,r9
   1855b890e:	0f 84 c3 00 00 00    	je     0x1855b89d7
   1855b8914:	4c 8b b7 d0 04 00 00 	mov    r14,QWORD PTR [rdi+0x4d0]
   1855b891b:	48 83 bf d8 04 00 00 	cmp    QWORD PTR [rdi+0x4d8],0x10
   1855b8922:	10 
   1855b8923:	72 07                	jb     0x1855b892c
   1855b8925:	4c 8b 8f c0 04 00 00 	mov    r9,QWORD PTR [rdi+0x4c0]
   1855b892c:	48 8b 88 f8 07 00 00 	mov    rcx,QWORD PTR [rax+0x7f8]
   1855b8933:	49 39 ce             	cmp    r14,rcx
   1855b8936:	76 7c                	jbe    0x1855b89b4
   1855b8938:	48 89 d9             	mov    rcx,rbx
   1855b893b:	4c 89 f2             	mov    rdx,r14
   1855b893e:	e8 0d 58 a8 fa       	call   0x18003e150
   1855b8943:	90                   	nop
   1855b8944:	e9 8e 00 00 00       	jmp    0x1855b89d7
   1855b8949:	48 83 f9 10          	cmp    rcx,0x10
   1855b894d:	72 03                	jb     0x1855b8952
   1855b894f:	48 8b 1b             	mov    rbx,QWORD PTR [rbx]
   1855b8952:	4c 89 b0 f0 07 00 00 	mov    QWORD PTR [rax+0x7f0],r14
   1855b8959:	48 89 d9             	mov    rcx,rbx
   1855b895c:	4c 89 ca             	mov    rdx,r9
   1855b895f:	4d 89 f0             	mov    r8,r14
   1855b8962:	e8 e9 b6 f8 01       	call   0x187544050
   1855b8967:	42 c6 04 33 00       	mov    BYTE PTR [rbx+r14*1],0x0
   1855b896c:	48 8b 87 d8 05 00 00 	mov    rax,QWORD PTR [rdi+0x5d8]
   1855b8973:	48 85 c0             	test   rax,rax
   1855b8976:	74 0d                	je     0x1855b8985
   1855b8978:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   1855b897c:	48 8b 87 d8 05 00 00 	mov    rax,QWORD PTR [rdi+0x5d8]
   1855b8983:	eb 02                	jmp    0x1855b8987
   1855b8985:	31 c0                	xor    eax,eax
   1855b8987:	48 8b 8f d0 05 00 00 	mov    rcx,QWORD PTR [rdi+0x5d0]
   1855b898e:	48 8b 95 e0 00 00 00 	mov    rdx,QWORD PTR [rbp+0xe0]
   1855b8995:	48 89 8a 00 08 00 00 	mov    QWORD PTR [rdx+0x800],rcx
   1855b899c:	48 8b ba 08 08 00 00 	mov    rdi,QWORD PTR [rdx+0x808]
   1855b89a3:	48 89 82 08 08 00 00 	mov    QWORD PTR [rdx+0x808],rax
   1855b89aa:	48 85 ff             	test   rdi,rdi
   1855b89ad:	75 6b                	jne    0x1855b8a1a
   1855b89af:	e9 83 00 00 00       	jmp    0x1855b8a37
   1855b89b4:	48 83 f9 10          	cmp    rcx,0x10
   1855b89b8:	72 03                	jb     0x1855b89bd
   1855b89ba:	48 8b 1b             	mov    rbx,QWORD PTR [rbx]
   1855b89bd:	4c 89 b0 f0 07 00 00 	mov    QWORD PTR [rax+0x7f0],r14
   1855b89c4:	48 89 d9             	mov    rcx,rbx
   1855b89c7:	4c 89 ca             	mov    rdx,r9
   1855b89ca:	4d 89 f0             	mov    r8,r14
   1855b89cd:	e8 7e b6 f8 01       	call   0x187544050
   1855b89d2:	42 c6 04 33 00       	mov    BYTE PTR [rbx+r14*1],0x0
   1855b89d7:	48 8b 87 e8 05 00 00 	mov    rax,QWORD PTR [rdi+0x5e8]
   1855b89de:	48 85 c0             	test   rax,rax
   1855b89e1:	74 0d                	je     0x1855b89f0
   1855b89e3:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   1855b89e7:	48 8b 87 e8 05 00 00 	mov    rax,QWORD PTR [rdi+0x5e8]
   1855b89ee:	eb 02                	jmp    0x1855b89f2
   1855b89f0:	31 c0                	xor    eax,eax
   1855b89f2:	48 8b 8f e0 05 00 00 	mov    rcx,QWORD PTR [rdi+0x5e0]
   1855b89f9:	48 8b 95 e0 00 00 00 	mov    rdx,QWORD PTR [rbp+0xe0]
   1855b8a00:	48 89 8a 10 08 00 00 	mov    QWORD PTR [rdx+0x810],rcx
   1855b8a07:	48 8b ba 18 08 00 00 	mov    rdi,QWORD PTR [rdx+0x818]
   1855b8a0e:	48 89 82 18 08 00 00 	mov    QWORD PTR [rdx+0x818],rax
   1855b8a15:	48 85 ff             	test   rdi,rdi
   1855b8a18:	74 1d                	je     0x1855b8a37
   1855b8a1a:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   1855b8a1e:	75 17                	jne    0x1855b8a37
   1855b8a20:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1855b8a23:	48 89 f9             	mov    rcx,rdi
   1855b8a26:	ff 10                	call   QWORD PTR [rax]
   1855b8a28:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   1855b8a2c:	75 09                	jne    0x1855b8a37
   1855b8a2e:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1855b8a31:	48 89 f9             	mov    rcx,rdi
   1855b8a34:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1855b8a37:	48 8b 85 e8 00 00 00 	mov    rax,QWORD PTR [rbp+0xe8]
   1855b8a3e:	48 85 c0             	test   rax,rax
   1855b8a41:	74 0d                	je     0x1855b8a50
   1855b8a43:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   1855b8a47:	48 8b 85 e8 00 00 00 	mov    rax,QWORD PTR [rbp+0xe8]
   1855b8a4e:	eb 02                	jmp    0x1855b8a52
   1855b8a50:	31 c0                	xor    eax,eax
   1855b8a52:	48 8b 8d e0 00 00 00 	mov    rcx,QWORD PTR [rbp+0xe0]
   1855b8a59:	48 89 0e             	mov    QWORD PTR [rsi],rcx
   1855b8a5c:	48 8b 7e 08          	mov    rdi,QWORD PTR [rsi+0x8]
   1855b8a60:	48 89 46 08          	mov    QWORD PTR [rsi+0x8],rax
   1855b8a64:	48 85 ff             	test   rdi,rdi
   1855b8a67:	74 1d                	je     0x1855b8a86
   1855b8a69:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   1855b8a6d:	75 17                	jne    0x1855b8a86
   1855b8a6f:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1855b8a72:	48 89 f9             	mov    rcx,rdi
   1855b8a75:	ff 10                	call   QWORD PTR [rax]
   1855b8a77:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   1855b8a7b:	75 09                	jne    0x1855b8a86
   1855b8a7d:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1855b8a80:	48 89 f9             	mov    rcx,rdi
   1855b8a83:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1855b8a86:	48 8b b5 e8 00 00 00 	mov    rsi,QWORD PTR [rbp+0xe8]
   1855b8a8d:	48 85 f6             	test   rsi,rsi
   1855b8a90:	0f 85 90 02 00 00    	jne    0x1855b8d26
   1855b8a96:	e9 a8 02 00 00       	jmp    0x1855b8d43
   1855b8a9b:	b9 04 00 00 00       	mov    ecx,0x4
   1855b8aa0:	e8 3b 43 ab fa       	call   0x18006cde0
   1855b8aa5:	bb 02 00 00 00       	mov    ebx,0x2
   1855b8aaa:	85 c0                	test   eax,eax
   1855b8aac:	0f 84 e5 0a 00 00    	je     0x1855b9597
   1855b8ab2:	48 8d b5 70 01 00 00 	lea    rsi,[rbp+0x170]
   1855b8ab9:	48 89 f1             	mov    rcx,rsi
   1855b8abc:	e8 4f 44 ab fa       	call   0x18006cf10
   1855b8ac1:	90                   	nop
   1855b8ac2:	48 83 bd 88 01 00 00 	cmp    QWORD PTR [rbp+0x188],0x10
   1855b8ac9:	10 
   1855b8aca:	72 07                	jb     0x1855b8ad3
   1855b8acc:	48 8b b5 70 01 00 00 	mov    rsi,QWORD PTR [rbp+0x170]
   1855b8ad3:	48 8d 05 06 8e 26 04 	lea    rax,[rip+0x4268e06]        # 0x1898218e0
   1855b8ada:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1855b8adf:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   1855b8ae6:	00 00 
   1855b8ae8:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   1855b8aed:	c7 44 24 28 30 02 00 	mov    DWORD PTR [rsp+0x28],0x230
   1855b8af4:	00 
   1855b8af5:	4c 8d 0d 44 8e 26 04 	lea    r9,[rip+0x4268e44]        # 0x189821940
   1855b8afc:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b8b03:	ba 04 00 00 00       	mov    edx,0x4
   1855b8b08:	49 89 f0             	mov    r8,rsi
   1855b8b0b:	e8 60 47 ab fa       	call   0x18006d270
   1855b8b10:	90                   	nop
   1855b8b11:	0f 57 c0             	xorps  xmm0,xmm0
   1855b8b14:	0f 29 85 30 02 00 00 	movaps XMMWORD PTR [rbp+0x230],xmm0
   1855b8b1b:	0f 29 85 20 02 00 00 	movaps XMMWORD PTR [rbp+0x220],xmm0
   1855b8b22:	0f 29 85 10 02 00 00 	movaps XMMWORD PTR [rbp+0x210],xmm0
   1855b8b29:	0f 29 85 00 02 00 00 	movaps XMMWORD PTR [rbp+0x200],xmm0
   1855b8b30:	0f 29 85 f0 01 00 00 	movaps XMMWORD PTR [rbp+0x1f0],xmm0
   1855b8b37:	0f 29 85 e0 01 00 00 	movaps XMMWORD PTR [rbp+0x1e0],xmm0
   1855b8b3e:	0f 29 85 d0 01 00 00 	movaps XMMWORD PTR [rbp+0x1d0],xmm0
   1855b8b45:	0f 29 85 c0 01 00 00 	movaps XMMWORD PTR [rbp+0x1c0],xmm0
   1855b8b4c:	48 8d 15 f5 8f 26 04 	lea    rdx,[rip+0x4268ff5]        # 0x189821b48
   1855b8b53:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b8b5a:	4c 8d 85 c0 01 00 00 	lea    r8,[rbp+0x1c0]
   1855b8b61:	e8 aa 4c ab fa       	call   0x18006d810
   1855b8b66:	90                   	nop
   1855b8b67:	e9 13 0a 00 00       	jmp    0x1855b957f
   1855b8b6c:	48 83 f8 10          	cmp    rax,0x10
   1855b8b70:	72 03                	jb     0x1855b8b75
   1855b8b72:	48 8b 1b             	mov    rbx,QWORD PTR [rbx]
   1855b8b75:	4c 89 b1 58 08 00 00 	mov    QWORD PTR [rcx+0x858],r14
   1855b8b7c:	48 89 d9             	mov    rcx,rbx
   1855b8b7f:	4c 89 ca             	mov    rdx,r9
   1855b8b82:	4d 89 f0             	mov    r8,r14
   1855b8b85:	e8 c6 b4 f8 01       	call   0x187544050
   1855b8b8a:	42 c6 04 33 00       	mov    BYTE PTR [rbx+r14*1],0x0
   1855b8b8f:	0f 29 b5 70 01 00 00 	movaps XMMWORD PTR [rbp+0x170],xmm6
   1855b8b96:	48 8b 87 78 06 00 00 	mov    rax,QWORD PTR [rdi+0x678]
   1855b8b9d:	48 85 c0             	test   rax,rax
   1855b8ba0:	74 0d                	je     0x1855b8baf
   1855b8ba2:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   1855b8ba6:	48 8b 87 78 06 00 00 	mov    rax,QWORD PTR [rdi+0x678]
   1855b8bad:	eb 02                	jmp    0x1855b8bb1
   1855b8baf:	31 c0                	xor    eax,eax
   1855b8bb1:	48 8b 97 70 06 00 00 	mov    rdx,QWORD PTR [rdi+0x670]
   1855b8bb8:	48 89 95 70 01 00 00 	mov    QWORD PTR [rbp+0x170],rdx
   1855b8bbf:	48 89 85 78 01 00 00 	mov    QWORD PTR [rbp+0x178],rax
   1855b8bc6:	48 85 d2             	test   rdx,rdx
   1855b8bc9:	74 2e                	je     0x1855b8bf9
   1855b8bcb:	0f 29 75 70          	movaps XMMWORD PTR [rbp+0x70],xmm6
   1855b8bcf:	48 8d 4d 70          	lea    rcx,[rbp+0x70]
   1855b8bd3:	e8 08 26 00 00       	call   0x1855bb1e0
   1855b8bd8:	90                   	nop
   1855b8bd9:	b9 d8 08 00 00       	mov    ecx,0x8d8
   1855b8bde:	48 03 8d c0 01 00 00 	add    rcx,QWORD PTR [rbp+0x1c0]
   1855b8be5:	48 8d 5d 70          	lea    rbx,[rbp+0x70]
   1855b8be9:	48 89 da             	mov    rdx,rbx
   1855b8bec:	e8 4f 6c 16 fb       	call   0x18071f840
   1855b8bf1:	48 89 d9             	mov    rcx,rbx
   1855b8bf4:	e8 67 94 a4 fa       	call   0x180002060
   1855b8bf9:	4c 8d 8f 58 04 00 00 	lea    r9,[rdi+0x458]
   1855b8c00:	48 8b 85 c0 01 00 00 	mov    rax,QWORD PTR [rbp+0x1c0]
   1855b8c07:	48 8d 98 d0 01 00 00 	lea    rbx,[rax+0x1d0]
   1855b8c0e:	4c 39 cb             	cmp    rbx,r9
   1855b8c11:	74 55                	je     0x1855b8c68
   1855b8c13:	4c 8b b7 68 04 00 00 	mov    r14,QWORD PTR [rdi+0x468]
   1855b8c1a:	48 83 bf 70 04 00 00 	cmp    QWORD PTR [rdi+0x470],0x10
   1855b8c21:	10 
   1855b8c22:	72 07                	jb     0x1855b8c2b
   1855b8c24:	4c 8b 8f 58 04 00 00 	mov    r9,QWORD PTR [rdi+0x458]
   1855b8c2b:	48 8b 88 e8 01 00 00 	mov    rcx,QWORD PTR [rax+0x1e8]
   1855b8c32:	49 39 ce             	cmp    r14,rcx
   1855b8c35:	76 0e                	jbe    0x1855b8c45
   1855b8c37:	48 89 d9             	mov    rcx,rbx
   1855b8c3a:	4c 89 f2             	mov    rdx,r14
   1855b8c3d:	e8 0e 55 a8 fa       	call   0x18003e150
   1855b8c42:	90                   	nop
   1855b8c43:	eb 23                	jmp    0x1855b8c68
   1855b8c45:	48 83 f9 10          	cmp    rcx,0x10
   1855b8c49:	72 03                	jb     0x1855b8c4e
   1855b8c4b:	48 8b 1b             	mov    rbx,QWORD PTR [rbx]
   1855b8c4e:	4c 89 b0 e0 01 00 00 	mov    QWORD PTR [rax+0x1e0],r14
   1855b8c55:	48 89 d9             	mov    rcx,rbx
   1855b8c58:	4c 89 ca             	mov    rdx,r9
   1855b8c5b:	4d 89 f0             	mov    r8,r14
   1855b8c5e:	e8 ed b3 f8 01       	call   0x187544050
   1855b8c63:	42 c6 04 33 00       	mov    BYTE PTR [rbx+r14*1],0x0
   1855b8c68:	48 8b 85 c0 01 00 00 	mov    rax,QWORD PTR [rbp+0x1c0]
   1855b8c6f:	c7 80 9c 00 00 00 03 	mov    DWORD PTR [rax+0x9c],0x3
   1855b8c76:	00 00 00 
   1855b8c79:	48 8b 8d c8 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1c8]
   1855b8c80:	48 85 c9             	test   rcx,rcx
   1855b8c83:	74 14                	je     0x1855b8c99
   1855b8c85:	f0 ff 41 08          	lock inc DWORD PTR [rcx+0x8]
   1855b8c89:	48 8b 85 c0 01 00 00 	mov    rax,QWORD PTR [rbp+0x1c0]
   1855b8c90:	48 8b 8d c8 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1c8]
   1855b8c97:	eb 02                	jmp    0x1855b8c9b
   1855b8c99:	31 c9                	xor    ecx,ecx
   1855b8c9b:	48 89 06             	mov    QWORD PTR [rsi],rax
   1855b8c9e:	48 8b 7e 08          	mov    rdi,QWORD PTR [rsi+0x8]
   1855b8ca2:	48 89 4e 08          	mov    QWORD PTR [rsi+0x8],rcx
   1855b8ca6:	48 85 ff             	test   rdi,rdi
   1855b8ca9:	74 1d                	je     0x1855b8cc8
   1855b8cab:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   1855b8caf:	75 17                	jne    0x1855b8cc8
   1855b8cb1:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1855b8cb4:	48 89 f9             	mov    rcx,rdi
   1855b8cb7:	ff 10                	call   QWORD PTR [rax]
   1855b8cb9:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   1855b8cbd:	75 09                	jne    0x1855b8cc8
   1855b8cbf:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1855b8cc2:	48 89 f9             	mov    rcx,rdi
   1855b8cc5:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1855b8cc8:	48 8b b5 78 01 00 00 	mov    rsi,QWORD PTR [rbp+0x178]
   1855b8ccf:	48 85 f6             	test   rsi,rsi
   1855b8cd2:	74 1d                	je     0x1855b8cf1
   1855b8cd4:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   1855b8cd8:	75 17                	jne    0x1855b8cf1
   1855b8cda:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1855b8cdd:	48 89 f1             	mov    rcx,rsi
   1855b8ce0:	ff 10                	call   QWORD PTR [rax]
   1855b8ce2:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   1855b8ce6:	75 09                	jne    0x1855b8cf1
   1855b8ce8:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1855b8ceb:	48 89 f1             	mov    rcx,rsi
   1855b8cee:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1855b8cf1:	48 8b b5 e8 00 00 00 	mov    rsi,QWORD PTR [rbp+0xe8]
   1855b8cf8:	48 85 f6             	test   rsi,rsi
   1855b8cfb:	74 1d                	je     0x1855b8d1a
   1855b8cfd:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   1855b8d01:	75 17                	jne    0x1855b8d1a
   1855b8d03:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1855b8d06:	48 89 f1             	mov    rcx,rsi
   1855b8d09:	ff 10                	call   QWORD PTR [rax]
   1855b8d0b:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   1855b8d0f:	75 09                	jne    0x1855b8d1a
   1855b8d11:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1855b8d14:	48 89 f1             	mov    rcx,rsi
   1855b8d17:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1855b8d1a:	48 8b b5 c8 01 00 00 	mov    rsi,QWORD PTR [rbp+0x1c8]
   1855b8d21:	48 85 f6             	test   rsi,rsi
   1855b8d24:	74 1d                	je     0x1855b8d43
   1855b8d26:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   1855b8d2a:	75 17                	jne    0x1855b8d43
   1855b8d2c:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1855b8d2f:	48 89 f1             	mov    rcx,rsi
   1855b8d32:	ff 10                	call   QWORD PTR [rax]
   1855b8d34:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   1855b8d38:	75 09                	jne    0x1855b8d43
   1855b8d3a:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1855b8d3d:	48 89 f1             	mov    rcx,rsi
   1855b8d40:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1855b8d43:	31 db                	xor    ebx,ebx
   1855b8d45:	e9 73 08 00 00       	jmp    0x1855b95bd
   1855b8d4a:	bb 01 00 00 00       	mov    ebx,0x1
   1855b8d4f:	e9 6c 06 00 00       	jmp    0x1855b93c0
   1855b8d54:	49 8d 4f 01          	lea    rcx,[r15+0x1]
   1855b8d58:	e8 3f 2b ef 01       	call   0x1874ab89c
   1855b8d5d:	48 89 85 70 01 00 00 	mov    QWORD PTR [rbp+0x170],rax
   1855b8d64:	48 89 9d 80 01 00 00 	mov    QWORD PTR [rbp+0x180],rbx
   1855b8d6b:	4c 89 bd 88 01 00 00 	mov    QWORD PTR [rbp+0x188],r15
   1855b8d72:	48 ff c3             	inc    rbx
   1855b8d75:	48 89 c1             	mov    rcx,rax
   1855b8d78:	4c 89 f2             	mov    rdx,r14
   1855b8d7b:	49 89 d8             	mov    r8,rbx
   1855b8d7e:	e8 cd b2 f8 01       	call   0x187544050
   1855b8d83:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1855b8d86:	48 8d 95 e0 00 00 00 	lea    rdx,[rbp+0xe0]
   1855b8d8d:	48 89 f9             	mov    rcx,rdi
   1855b8d90:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1855b8d93:	90                   	nop
   1855b8d94:	48 8b 8d e0 00 00 00 	mov    rcx,QWORD PTR [rbp+0xe0]
   1855b8d9b:	c7 44 24 20 00 00 00 	mov    DWORD PTR [rsp+0x20],0x0
   1855b8da2:	00 
   1855b8da3:	4c 8d 05 76 a0 b3 05 	lea    r8,[rip+0x5b3a076]        # 0x18b0f2e20
   1855b8daa:	4c 8d 0d 3f a0 b3 05 	lea    r9,[rip+0x5b3a03f]        # 0x18b0f2df0
   1855b8db1:	31 d2                	xor    edx,edx
   1855b8db3:	e8 34 ac f3 01       	call   0x1874f39ec
   1855b8db8:	90                   	nop
   1855b8db9:	48 85 c0             	test   rax,rax
   1855b8dbc:	0f 84 8a 01 00 00    	je     0x1855b8f4c
   1855b8dc2:	48 89 45 f0          	mov    QWORD PTR [rbp-0x10],rax
   1855b8dc6:	48 8b 85 e8 00 00 00 	mov    rax,QWORD PTR [rbp+0xe8]
   1855b8dcd:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
   1855b8dd1:	48 83 bd 80 01 00 00 	cmp    QWORD PTR [rbp+0x180],0x0
   1855b8dd8:	00 
   1855b8dd9:	0f 84 ae 01 00 00    	je     0x1855b8f8d
   1855b8ddf:	0f 28 05 ca cd 78 03 	movaps xmm0,XMMWORD PTR [rip+0x378cdca]        # 0x188d45bb0
   1855b8de6:	0f 29 85 c0 01 00 00 	movaps XMMWORD PTR [rbp+0x1c0],xmm0
   1855b8ded:	48 8d 8d c0 01 00 00 	lea    rcx,[rbp+0x1c0]
   1855b8df4:	e8 37 88 f2 fe       	call   0x1844e1630
   1855b8df9:	90                   	nop
   1855b8dfa:	48 8b 8d c0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1c0]
   1855b8e01:	48 b8 31 00 00 00 05 	movabs rax,0x500000031
   1855b8e08:	00 00 00 
   1855b8e0b:	48 89 81 18 01 00 00 	mov    QWORD PTR [rcx+0x118],rax
   1855b8e12:	48 81 c1 e8 07 00 00 	add    rcx,0x7e8
   1855b8e19:	48 8d 95 70 01 00 00 	lea    rdx,[rbp+0x170]
   1855b8e20:	e8 fb c5 d8 fa       	call   0x180345420
   1855b8e25:	90                   	nop
   1855b8e26:	48 8b 5d f0          	mov    rbx,QWORD PTR [rbp-0x10]
   1855b8e2a:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1855b8e2d:	48 89 d9             	mov    rcx,rbx
   1855b8e30:	ff 50 18             	call   QWORD PTR [rax+0x18]
   1855b8e33:	90                   	nop
   1855b8e34:	b9 08 08 00 00       	mov    ecx,0x808
   1855b8e39:	48 03 8d c0 01 00 00 	add    rcx,QWORD PTR [rbp+0x1c0]
   1855b8e40:	48 89 c2             	mov    rdx,rax
   1855b8e43:	e8 d8 c5 d8 fa       	call   0x180345420
   1855b8e48:	90                   	nop
   1855b8e49:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1855b8e4c:	48 89 d9             	mov    rcx,rbx
   1855b8e4f:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1855b8e52:	90                   	nop
   1855b8e53:	b9 58 07 00 00       	mov    ecx,0x758
   1855b8e58:	48 03 8d c0 01 00 00 	add    rcx,QWORD PTR [rbp+0x1c0]
   1855b8e5f:	48 89 c2             	mov    rdx,rax
   1855b8e62:	e8 b9 c5 d8 fa       	call   0x180345420
   1855b8e67:	90                   	nop
   1855b8e68:	48 8b 8d c0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1c0]
   1855b8e6f:	48 83 b9 68 07 00 00 	cmp    QWORD PTR [rcx+0x768],0x0
   1855b8e76:	00 
   1855b8e77:	75 14                	jne    0x1855b8e8d
   1855b8e79:	48 81 c1 58 07 00 00 	add    rcx,0x758
   1855b8e80:	48 8d 97 90 01 00 00 	lea    rdx,[rdi+0x190]
   1855b8e87:	e8 94 c5 d8 fa       	call   0x180345420
   1855b8e8c:	90                   	nop
   1855b8e8d:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1855b8e90:	48 89 d9             	mov    rcx,rbx
   1855b8e93:	ff 50 10             	call   QWORD PTR [rax+0x10]
   1855b8e96:	90                   	nop
   1855b8e97:	b9 78 07 00 00       	mov    ecx,0x778
   1855b8e9c:	48 03 8d c0 01 00 00 	add    rcx,QWORD PTR [rbp+0x1c0]
   1855b8ea3:	48 89 c2             	mov    rdx,rax
   1855b8ea6:	e8 75 c5 d8 fa       	call   0x180345420
   1855b8eab:	90                   	nop
   1855b8eac:	48 8b 8d c0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1c0]
   1855b8eb3:	48 83 b9 88 07 00 00 	cmp    QWORD PTR [rcx+0x788],0x0
   1855b8eba:	00 
   1855b8ebb:	75 1b                	jne    0x1855b8ed8
   1855b8ebd:	48 81 c1 78 07 00 00 	add    rcx,0x778
   1855b8ec4:	48 8d 97 b0 01 00 00 	lea    rdx,[rdi+0x1b0]
   1855b8ecb:	e8 50 c5 d8 fa       	call   0x180345420
   1855b8ed0:	90                   	nop
   1855b8ed1:	48 8b 8d c0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1c0]
   1855b8ed8:	48 8d 97 90 00 00 00 	lea    rdx,[rdi+0x90]
   1855b8edf:	48 81 c1 98 07 00 00 	add    rcx,0x798
   1855b8ee6:	e8 35 c5 d8 fa       	call   0x180345420
   1855b8eeb:	90                   	nop
   1855b8eec:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b8ef3:	41 b8 02 00 00 00    	mov    r8d,0x2
   1855b8ef9:	48 89 fa             	mov    rdx,rdi
   1855b8efc:	45 31 c9             	xor    r9d,r9d
   1855b8eff:	e8 2c aa fa fe       	call   0x184563930
   1855b8f04:	90                   	nop
   1855b8f05:	b9 68 08 00 00       	mov    ecx,0x868
   1855b8f0a:	48 03 8d c0 01 00 00 	add    rcx,QWORD PTR [rbp+0x1c0]
   1855b8f11:	48 8d bd e0 00 00 00 	lea    rdi,[rbp+0xe0]
   1855b8f18:	48 89 fa             	mov    rdx,rdi
   1855b8f1b:	e8 20 27 ae fa       	call   0x18009b640
   1855b8f20:	48 89 f9             	mov    rcx,rdi
   1855b8f23:	e8 38 eb a4 fa       	call   0x180007a60
   1855b8f28:	0f 57 c0             	xorps  xmm0,xmm0
   1855b8f2b:	0f 29 85 e0 00 00 00 	movaps XMMWORD PTR [rbp+0xe0],xmm0
   1855b8f32:	48 8b 43 10          	mov    rax,QWORD PTR [rbx+0x10]
   1855b8f36:	48 85 c0             	test   rax,rax
   1855b8f39:	0f 84 7e 01 00 00    	je     0x1855b90bd
   1855b8f3f:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   1855b8f43:	48 8b 43 10          	mov    rax,QWORD PTR [rbx+0x10]
   1855b8f47:	e9 73 01 00 00       	jmp    0x1855b90bf
   1855b8f4c:	0f 57 c0             	xorps  xmm0,xmm0
   1855b8f4f:	0f 29 45 f0          	movaps XMMWORD PTR [rbp-0x10],xmm0
   1855b8f53:	48 8b 9d e8 00 00 00 	mov    rbx,QWORD PTR [rbp+0xe8]
   1855b8f5a:	48 85 db             	test   rbx,rbx
   1855b8f5d:	0f 84 6e fe ff ff    	je     0x1855b8dd1
   1855b8f63:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   1855b8f67:	0f 85 64 fe ff ff    	jne    0x1855b8dd1
   1855b8f6d:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1855b8f70:	48 89 d9             	mov    rcx,rbx
   1855b8f73:	ff 10                	call   QWORD PTR [rax]
   1855b8f75:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   1855b8f79:	0f 85 52 fe ff ff    	jne    0x1855b8dd1
   1855b8f7f:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1855b8f82:	48 89 d9             	mov    rcx,rbx
   1855b8f85:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1855b8f88:	e9 44 fe ff ff       	jmp    0x1855b8dd1
   1855b8f8d:	48 8b 4d f0          	mov    rcx,QWORD PTR [rbp-0x10]
   1855b8f91:	48 85 c9             	test   rcx,rcx
   1855b8f94:	74 25                	je     0x1855b8fbb
   1855b8f96:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   1855b8f99:	ff 50 20             	call   QWORD PTR [rax+0x20]
   1855b8f9c:	90                   	nop
   1855b8f9d:	48 8d 8d 70 01 00 00 	lea    rcx,[rbp+0x170]
   1855b8fa4:	48 89 c2             	mov    rdx,rax
   1855b8fa7:	e8 74 c4 d8 fa       	call   0x180345420
   1855b8fac:	90                   	nop
   1855b8fad:	48 83 bd 80 01 00 00 	cmp    QWORD PTR [rbp+0x180],0x0
   1855b8fb4:	00 
   1855b8fb5:	0f 85 24 fe ff ff    	jne    0x1855b8ddf
   1855b8fbb:	48 8d 97 d0 03 00 00 	lea    rdx,[rdi+0x3d0]
   1855b8fc2:	48 8d 8d 70 01 00 00 	lea    rcx,[rbp+0x170]
   1855b8fc9:	e8 52 c4 d8 fa       	call   0x180345420
   1855b8fce:	90                   	nop
   1855b8fcf:	48 83 bd 80 01 00 00 	cmp    QWORD PTR [rbp+0x180],0x0
   1855b8fd6:	00 
   1855b8fd7:	0f 85 02 fe ff ff    	jne    0x1855b8ddf
   1855b8fdd:	b9 04 00 00 00       	mov    ecx,0x4
   1855b8fe2:	e8 f9 3d ab fa       	call   0x18006cde0
   1855b8fe7:	bb 01 00 00 00       	mov    ebx,0x1
   1855b8fec:	85 c0                	test   eax,eax
   1855b8fee:	0f 84 56 01 00 00    	je     0x1855b914a
   1855b8ff4:	48 8d 75 70          	lea    rsi,[rbp+0x70]
   1855b8ff8:	48 89 f1             	mov    rcx,rsi
   1855b8ffb:	e8 10 3f ab fa       	call   0x18006cf10
   1855b9000:	90                   	nop
   1855b9001:	48 83 bd 88 00 00 00 	cmp    QWORD PTR [rbp+0x88],0x10
   1855b9008:	10 
   1855b9009:	72 04                	jb     0x1855b900f
   1855b900b:	48 8b 75 70          	mov    rsi,QWORD PTR [rbp+0x70]
   1855b900f:	48 8d 05 ca 88 26 04 	lea    rax,[rip+0x42688ca]        # 0x1898218e0
   1855b9016:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1855b901b:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   1855b9022:	00 00 
   1855b9024:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   1855b9029:	c7 44 24 28 bc 01 00 	mov    DWORD PTR [rsp+0x28],0x1bc
   1855b9030:	00 
   1855b9031:	4c 8d 0d 08 89 26 04 	lea    r9,[rip+0x4268908]        # 0x189821940
   1855b9038:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b903f:	ba 04 00 00 00       	mov    edx,0x4
   1855b9044:	49 89 f0             	mov    r8,rsi
   1855b9047:	e8 24 42 ab fa       	call   0x18006d270
   1855b904c:	90                   	nop
   1855b904d:	0f 57 c0             	xorps  xmm0,xmm0
   1855b9050:	0f 29 85 30 02 00 00 	movaps XMMWORD PTR [rbp+0x230],xmm0
   1855b9057:	0f 29 85 20 02 00 00 	movaps XMMWORD PTR [rbp+0x220],xmm0
   1855b905e:	0f 29 85 10 02 00 00 	movaps XMMWORD PTR [rbp+0x210],xmm0
   1855b9065:	0f 29 85 00 02 00 00 	movaps XMMWORD PTR [rbp+0x200],xmm0
   1855b906c:	0f 29 85 f0 01 00 00 	movaps XMMWORD PTR [rbp+0x1f0],xmm0
   1855b9073:	0f 29 85 e0 01 00 00 	movaps XMMWORD PTR [rbp+0x1e0],xmm0
   1855b907a:	0f 29 85 d0 01 00 00 	movaps XMMWORD PTR [rbp+0x1d0],xmm0
   1855b9081:	0f 29 85 c0 01 00 00 	movaps XMMWORD PTR [rbp+0x1c0],xmm0
   1855b9088:	48 8d 15 99 68 c9 03 	lea    rdx,[rip+0x3c96899]        # 0x18924f928
   1855b908f:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b9096:	4c 8d 85 c0 01 00 00 	lea    r8,[rbp+0x1c0]
   1855b909d:	e8 6e 47 ab fa       	call   0x18006d810
   1855b90a2:	90                   	nop
   1855b90a3:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b90aa:	e8 c1 42 ab fa       	call   0x18006d370
   1855b90af:	48 8d 4d 70          	lea    rcx,[rbp+0x70]
   1855b90b3:	e8 58 8f a4 fa       	call   0x180002010
   1855b90b8:	e9 8d 00 00 00       	jmp    0x1855b914a
   1855b90bd:	31 c0                	xor    eax,eax
   1855b90bf:	48 8b 53 08          	mov    rdx,QWORD PTR [rbx+0x8]
   1855b90c3:	48 89 95 e0 00 00 00 	mov    QWORD PTR [rbp+0xe0],rdx
   1855b90ca:	48 89 85 e8 00 00 00 	mov    QWORD PTR [rbp+0xe8],rax
   1855b90d1:	48 85 d2             	test   rdx,rdx
   1855b90d4:	74 4c                	je     0x1855b9122
   1855b90d6:	48 83 c2 08          	add    rdx,0x8
   1855b90da:	b9 28 08 00 00       	mov    ecx,0x828
   1855b90df:	48 03 8d c0 01 00 00 	add    rcx,QWORD PTR [rbp+0x1c0]
   1855b90e6:	e8 35 c3 d8 fa       	call   0x180345420
   1855b90eb:	90                   	nop
   1855b90ec:	48 8b 95 e0 00 00 00 	mov    rdx,QWORD PTR [rbp+0xe0]
   1855b90f3:	48 83 c2 28          	add    rdx,0x28
   1855b90f7:	b9 48 08 00 00       	mov    ecx,0x848
   1855b90fc:	48 03 8d c0 01 00 00 	add    rcx,QWORD PTR [rbp+0x1c0]
   1855b9103:	e8 18 c3 d8 fa       	call   0x180345420
   1855b9108:	90                   	nop
   1855b9109:	b9 c8 08 00 00       	mov    ecx,0x8c8
   1855b910e:	48 03 8d c0 01 00 00 	add    rcx,QWORD PTR [rbp+0x1c0]
   1855b9115:	48 8d 95 e0 00 00 00 	lea    rdx,[rbp+0xe0]
   1855b911c:	e8 ff be ab 00       	call   0x186075020
   1855b9121:	90                   	nop
   1855b9122:	48 8d bd c0 01 00 00 	lea    rdi,[rbp+0x1c0]
   1855b9129:	48 89 f1             	mov    rcx,rsi
   1855b912c:	48 89 fa             	mov    rdx,rdi
   1855b912f:	e8 0c 67 16 fb       	call   0x18071f840
   1855b9134:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b913b:	e8 20 8f a4 fa       	call   0x180002060
   1855b9140:	48 89 f9             	mov    rcx,rdi
   1855b9143:	e8 18 8f a4 fa       	call   0x180002060
   1855b9148:	31 db                	xor    ebx,ebx
   1855b914a:	48 8b 75 f8          	mov    rsi,QWORD PTR [rbp-0x8]
   1855b914e:	48 85 f6             	test   rsi,rsi
   1855b9151:	74 1d                	je     0x1855b9170
   1855b9153:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   1855b9157:	75 17                	jne    0x1855b9170
   1855b9159:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1855b915c:	48 89 f1             	mov    rcx,rsi
   1855b915f:	ff 10                	call   QWORD PTR [rax]
   1855b9161:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   1855b9165:	75 09                	jne    0x1855b9170
   1855b9167:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1855b916a:	48 89 f1             	mov    rcx,rsi
   1855b916d:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1855b9170:	48 8b 85 88 01 00 00 	mov    rax,QWORD PTR [rbp+0x188]
   1855b9177:	48 83 f8 10          	cmp    rax,0x10
   1855b917b:	0f 82 3c 04 00 00    	jb     0x1855b95bd
   1855b9181:	48 8b 8d 70 01 00 00 	mov    rcx,QWORD PTR [rbp+0x170]
   1855b9188:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1855b918c:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1855b9193:	72 1f                	jb     0x1855b91b4
   1855b9195:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1855b9199:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1855b919d:	4c 29 c1             	sub    rcx,r8
   1855b91a0:	48 83 f9 20          	cmp    rcx,0x20
   1855b91a4:	0f 83 2d 04 00 00    	jae    0x1855b95d7
   1855b91aa:	48 83 c0 28          	add    rax,0x28
   1855b91ae:	48 89 c2             	mov    rdx,rax
   1855b91b1:	4c 89 c1             	mov    rcx,r8
   1855b91b4:	e8 27 27 ef 01       	call   0x1874ab8e0
   1855b91b9:	e9 ff 03 00 00       	jmp    0x1855b95bd
   1855b91be:	b9 04 00 00 00       	mov    ecx,0x4
   1855b91c3:	e8 18 3c ab fa       	call   0x18006cde0
   1855b91c8:	85 c0                	test   eax,eax
   1855b91ca:	0f 84 99 01 00 00    	je     0x1855b9369
   1855b91d0:	48 8d b5 70 01 00 00 	lea    rsi,[rbp+0x170]
   1855b91d7:	48 89 f1             	mov    rcx,rsi
   1855b91da:	e8 31 3d ab fa       	call   0x18006cf10
   1855b91df:	90                   	nop
   1855b91e0:	48 83 bd 88 01 00 00 	cmp    QWORD PTR [rbp+0x188],0x10
   1855b91e7:	10 
   1855b91e8:	72 07                	jb     0x1855b91f1
   1855b91ea:	48 8b b5 70 01 00 00 	mov    rsi,QWORD PTR [rbp+0x170]
   1855b91f1:	48 8d 05 e8 86 26 04 	lea    rax,[rip+0x42686e8]        # 0x1898218e0
   1855b91f8:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1855b91fd:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   1855b9204:	00 00 
   1855b9206:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   1855b920b:	c7 44 24 28 52 02 00 	mov    DWORD PTR [rsp+0x28],0x252
   1855b9212:	00 
   1855b9213:	4c 8d 0d 26 87 26 04 	lea    r9,[rip+0x4268726]        # 0x189821940
   1855b921a:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b9221:	ba 04 00 00 00       	mov    edx,0x4
   1855b9226:	49 89 f0             	mov    r8,rsi
   1855b9229:	e8 42 40 ab fa       	call   0x18006d270
   1855b922e:	90                   	nop
   1855b922f:	0f 57 c0             	xorps  xmm0,xmm0
   1855b9232:	0f 29 85 30 02 00 00 	movaps XMMWORD PTR [rbp+0x230],xmm0
   1855b9239:	0f 29 85 20 02 00 00 	movaps XMMWORD PTR [rbp+0x220],xmm0
   1855b9240:	0f 29 85 10 02 00 00 	movaps XMMWORD PTR [rbp+0x210],xmm0
   1855b9247:	0f 29 85 00 02 00 00 	movaps XMMWORD PTR [rbp+0x200],xmm0
   1855b924e:	0f 29 85 f0 01 00 00 	movaps XMMWORD PTR [rbp+0x1f0],xmm0
   1855b9255:	0f 29 85 e0 01 00 00 	movaps XMMWORD PTR [rbp+0x1e0],xmm0
   1855b925c:	0f 29 85 d0 01 00 00 	movaps XMMWORD PTR [rbp+0x1d0],xmm0
   1855b9263:	0f 29 85 c0 01 00 00 	movaps XMMWORD PTR [rbp+0x1c0],xmm0
   1855b926a:	48 8d 15 af 39 1f 04 	lea    rdx,[rip+0x41f39af]        # 0x1897acc20
   1855b9271:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b9278:	4c 8d 85 c0 01 00 00 	lea    r8,[rbp+0x1c0]
   1855b927f:	e8 8c 45 ab fa       	call   0x18006d810
   1855b9284:	90                   	nop
   1855b9285:	e9 c7 00 00 00       	jmp    0x1855b9351
   1855b928a:	b9 04 00 00 00       	mov    ecx,0x4
   1855b928f:	e8 4c 3b ab fa       	call   0x18006cde0
   1855b9294:	85 c0                	test   eax,eax
   1855b9296:	0f 84 cd 00 00 00    	je     0x1855b9369
   1855b929c:	48 8d b5 70 01 00 00 	lea    rsi,[rbp+0x170]
   1855b92a3:	48 89 f1             	mov    rcx,rsi
   1855b92a6:	e8 65 3c ab fa       	call   0x18006cf10
   1855b92ab:	90                   	nop
   1855b92ac:	48 83 bd 88 01 00 00 	cmp    QWORD PTR [rbp+0x188],0x10
   1855b92b3:	10 
   1855b92b4:	72 07                	jb     0x1855b92bd
   1855b92b6:	48 8b b5 70 01 00 00 	mov    rsi,QWORD PTR [rbp+0x170]
   1855b92bd:	48 8d 05 1c 86 26 04 	lea    rax,[rip+0x426861c]        # 0x1898218e0
   1855b92c4:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1855b92c9:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   1855b92d0:	00 00 
   1855b92d2:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   1855b92d7:	c7 44 24 28 1f 02 00 	mov    DWORD PTR [rsp+0x28],0x21f
   1855b92de:	00 
   1855b92df:	4c 8d 0d 5a 86 26 04 	lea    r9,[rip+0x426865a]        # 0x189821940
   1855b92e6:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b92ed:	ba 04 00 00 00       	mov    edx,0x4
   1855b92f2:	49 89 f0             	mov    r8,rsi
   1855b92f5:	e8 76 3f ab fa       	call   0x18006d270
   1855b92fa:	90                   	nop
   1855b92fb:	0f 57 c0             	xorps  xmm0,xmm0
   1855b92fe:	0f 29 85 30 02 00 00 	movaps XMMWORD PTR [rbp+0x230],xmm0
   1855b9305:	0f 29 85 20 02 00 00 	movaps XMMWORD PTR [rbp+0x220],xmm0
   1855b930c:	0f 29 85 10 02 00 00 	movaps XMMWORD PTR [rbp+0x210],xmm0
   1855b9313:	0f 29 85 00 02 00 00 	movaps XMMWORD PTR [rbp+0x200],xmm0
   1855b931a:	0f 29 85 f0 01 00 00 	movaps XMMWORD PTR [rbp+0x1f0],xmm0
   1855b9321:	0f 29 85 e0 01 00 00 	movaps XMMWORD PTR [rbp+0x1e0],xmm0
   1855b9328:	0f 29 85 d0 01 00 00 	movaps XMMWORD PTR [rbp+0x1d0],xmm0
   1855b932f:	0f 29 85 c0 01 00 00 	movaps XMMWORD PTR [rbp+0x1c0],xmm0
   1855b9336:	48 8d 15 e3 38 1f 04 	lea    rdx,[rip+0x41f38e3]        # 0x1897acc20
   1855b933d:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b9344:	4c 8d 85 c0 01 00 00 	lea    r8,[rbp+0x1c0]
   1855b934b:	e8 c0 44 ab fa       	call   0x18006d810
   1855b9350:	90                   	nop
   1855b9351:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b9358:	e8 13 40 ab fa       	call   0x18006d370
   1855b935d:	48 8d 8d 70 01 00 00 	lea    rcx,[rbp+0x170]
   1855b9364:	e8 a7 8c a4 fa       	call   0x180002010
   1855b9369:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1855b936d:	e8 ee 8c a4 fa       	call   0x180002060
   1855b9372:	e9 20 02 00 00       	jmp    0x1855b9597
   1855b9377:	31 c9                	xor    ecx,ecx
   1855b9379:	48 89 45 e0          	mov    QWORD PTR [rbp-0x20],rax
   1855b937d:	48 89 4d e8          	mov    QWORD PTR [rbp-0x18],rcx
   1855b9381:	48 8d 8d c0 01 00 00 	lea    rcx,[rbp+0x1c0]
   1855b9388:	48 8d 55 e0          	lea    rdx,[rbp-0x20]
   1855b938c:	e8 0f 33 52 fe       	call   0x183adc6a0
   1855b9391:	90                   	nop
   1855b9392:	48 83 bd c0 01 00 00 	cmp    QWORD PTR [rbp+0x1c0],0x0
   1855b9399:	00 
   1855b939a:	74 13                	je     0x1855b93af
   1855b939c:	48 8d 95 c0 01 00 00 	lea    rdx,[rbp+0x1c0]
   1855b93a3:	48 89 f1             	mov    rcx,rsi
   1855b93a6:	e8 95 64 16 fb       	call   0x18071f840
   1855b93ab:	31 db                	xor    ebx,ebx
   1855b93ad:	eb 05                	jmp    0x1855b93b4
   1855b93af:	bb 01 00 00 00       	mov    ebx,0x1
   1855b93b4:	48 8d 8d c0 01 00 00 	lea    rcx,[rbp+0x1c0]
   1855b93bb:	e8 a0 8c a4 fa       	call   0x180002060
   1855b93c0:	48 8b b5 e8 00 00 00 	mov    rsi,QWORD PTR [rbp+0xe8]
   1855b93c7:	e9 cf 01 00 00       	jmp    0x1855b959b
   1855b93cc:	31 c9                	xor    ecx,ecx
   1855b93ce:	48 85 c9             	test   rcx,rcx
   1855b93d1:	0f 85 3a d5 ff ff    	jne    0x1855b6911
   1855b93d7:	b9 04 00 00 00       	mov    ecx,0x4
   1855b93dc:	e8 ff 39 ab fa       	call   0x18006cde0
   1855b93e1:	bb 01 00 00 00       	mov    ebx,0x1
   1855b93e6:	85 c0                	test   eax,eax
   1855b93e8:	0f 84 a9 01 00 00    	je     0x1855b9597
   1855b93ee:	48 8d b5 70 01 00 00 	lea    rsi,[rbp+0x170]
   1855b93f5:	48 89 f1             	mov    rcx,rsi
   1855b93f8:	e8 13 3b ab fa       	call   0x18006cf10
   1855b93fd:	90                   	nop
   1855b93fe:	48 83 bd 88 01 00 00 	cmp    QWORD PTR [rbp+0x188],0x10
   1855b9405:	10 
   1855b9406:	72 07                	jb     0x1855b940f
   1855b9408:	48 8b b5 70 01 00 00 	mov    rsi,QWORD PTR [rbp+0x170]
   1855b940f:	48 8d 05 ca 84 26 04 	lea    rax,[rip+0x42684ca]        # 0x1898218e0
   1855b9416:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1855b941b:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   1855b9422:	00 00 
   1855b9424:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   1855b9429:	c7 44 24 28 4b 02 00 	mov    DWORD PTR [rsp+0x28],0x24b
   1855b9430:	00 
   1855b9431:	4c 8d 0d 08 85 26 04 	lea    r9,[rip+0x4268508]        # 0x189821940
   1855b9438:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b943f:	ba 04 00 00 00       	mov    edx,0x4
   1855b9444:	49 89 f0             	mov    r8,rsi
   1855b9447:	e8 24 3e ab fa       	call   0x18006d270
   1855b944c:	90                   	nop
   1855b944d:	0f 57 c0             	xorps  xmm0,xmm0
   1855b9450:	0f 29 85 30 02 00 00 	movaps XMMWORD PTR [rbp+0x230],xmm0
   1855b9457:	0f 29 85 20 02 00 00 	movaps XMMWORD PTR [rbp+0x220],xmm0
   1855b945e:	0f 29 85 10 02 00 00 	movaps XMMWORD PTR [rbp+0x210],xmm0
   1855b9465:	0f 29 85 00 02 00 00 	movaps XMMWORD PTR [rbp+0x200],xmm0
   1855b946c:	0f 29 85 f0 01 00 00 	movaps XMMWORD PTR [rbp+0x1f0],xmm0
   1855b9473:	0f 29 85 e0 01 00 00 	movaps XMMWORD PTR [rbp+0x1e0],xmm0
   1855b947a:	0f 29 85 d0 01 00 00 	movaps XMMWORD PTR [rbp+0x1d0],xmm0
   1855b9481:	0f 29 85 c0 01 00 00 	movaps XMMWORD PTR [rbp+0x1c0],xmm0
   1855b9488:	48 8d 15 91 37 1f 04 	lea    rdx,[rip+0x41f3791]        # 0x1897acc20
   1855b948f:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b9496:	4c 8d 85 c0 01 00 00 	lea    r8,[rbp+0x1c0]
   1855b949d:	e8 6e 43 ab fa       	call   0x18006d810
   1855b94a2:	90                   	nop
   1855b94a3:	e9 d7 00 00 00       	jmp    0x1855b957f
   1855b94a8:	31 c9                	xor    ecx,ecx
   1855b94aa:	48 85 c9             	test   rcx,rcx
   1855b94ad:	0f 85 16 d8 ff ff    	jne    0x1855b6cc9
   1855b94b3:	b9 04 00 00 00       	mov    ecx,0x4
   1855b94b8:	e8 23 39 ab fa       	call   0x18006cde0
   1855b94bd:	bb 01 00 00 00       	mov    ebx,0x1
   1855b94c2:	85 c0                	test   eax,eax
   1855b94c4:	0f 84 cd 00 00 00    	je     0x1855b9597
   1855b94ca:	48 8d b5 70 01 00 00 	lea    rsi,[rbp+0x170]
   1855b94d1:	48 89 f1             	mov    rcx,rsi
   1855b94d4:	e8 37 3a ab fa       	call   0x18006cf10
   1855b94d9:	90                   	nop
   1855b94da:	48 83 bd 88 01 00 00 	cmp    QWORD PTR [rbp+0x188],0x10
   1855b94e1:	10 
   1855b94e2:	72 07                	jb     0x1855b94eb
   1855b94e4:	48 8b b5 70 01 00 00 	mov    rsi,QWORD PTR [rbp+0x170]
   1855b94eb:	48 8d 05 ee 83 26 04 	lea    rax,[rip+0x42683ee]        # 0x1898218e0
   1855b94f2:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1855b94f7:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   1855b94fe:	00 00 
   1855b9500:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   1855b9505:	c7 44 24 28 18 02 00 	mov    DWORD PTR [rsp+0x28],0x218
   1855b950c:	00 
   1855b950d:	4c 8d 0d 2c 84 26 04 	lea    r9,[rip+0x426842c]        # 0x189821940
   1855b9514:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b951b:	ba 04 00 00 00       	mov    edx,0x4
   1855b9520:	49 89 f0             	mov    r8,rsi
   1855b9523:	e8 48 3d ab fa       	call   0x18006d270
   1855b9528:	90                   	nop
   1855b9529:	0f 57 c0             	xorps  xmm0,xmm0
   1855b952c:	0f 29 85 30 02 00 00 	movaps XMMWORD PTR [rbp+0x230],xmm0
   1855b9533:	0f 29 85 20 02 00 00 	movaps XMMWORD PTR [rbp+0x220],xmm0
   1855b953a:	0f 29 85 10 02 00 00 	movaps XMMWORD PTR [rbp+0x210],xmm0
   1855b9541:	0f 29 85 00 02 00 00 	movaps XMMWORD PTR [rbp+0x200],xmm0
   1855b9548:	0f 29 85 f0 01 00 00 	movaps XMMWORD PTR [rbp+0x1f0],xmm0
   1855b954f:	0f 29 85 e0 01 00 00 	movaps XMMWORD PTR [rbp+0x1e0],xmm0
   1855b9556:	0f 29 85 d0 01 00 00 	movaps XMMWORD PTR [rbp+0x1d0],xmm0
   1855b955d:	0f 29 85 c0 01 00 00 	movaps XMMWORD PTR [rbp+0x1c0],xmm0
   1855b9564:	48 8d 15 b5 36 1f 04 	lea    rdx,[rip+0x41f36b5]        # 0x1897acc20
   1855b956b:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b9572:	4c 8d 85 c0 01 00 00 	lea    r8,[rbp+0x1c0]
   1855b9579:	e8 92 42 ab fa       	call   0x18006d810
   1855b957e:	90                   	nop
   1855b957f:	48 8d 8d e0 00 00 00 	lea    rcx,[rbp+0xe0]
   1855b9586:	e8 e5 3d ab fa       	call   0x18006d370
   1855b958b:	48 8d 8d 70 01 00 00 	lea    rcx,[rbp+0x170]
   1855b9592:	e8 79 8a a4 fa       	call   0x180002010
   1855b9597:	48 8b 75 78          	mov    rsi,QWORD PTR [rbp+0x78]
   1855b959b:	48 85 f6             	test   rsi,rsi
   1855b959e:	74 1d                	je     0x1855b95bd
   1855b95a0:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   1855b95a4:	75 17                	jne    0x1855b95bd
   1855b95a6:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1855b95a9:	48 89 f1             	mov    rcx,rsi
   1855b95ac:	ff 10                	call   QWORD PTR [rax]
   1855b95ae:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   1855b95b2:	75 09                	jne    0x1855b95bd
   1855b95b4:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1855b95b7:	48 89 f1             	mov    rcx,rsi
   1855b95ba:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1855b95bd:	48 89 d8             	mov    rax,rbx
   1855b95c0:	0f 28 b5 50 02 00 00 	movaps xmm6,XMMWORD PTR [rbp+0x250]
   1855b95c7:	48 81 c4 e8 02 00 00 	add    rsp,0x2e8
   1855b95ce:	5b                   	pop    rbx
   1855b95cf:	5f                   	pop    rdi
   1855b95d0:	5e                   	pop    rsi
   1855b95d1:	41 5e                	pop    r14
   1855b95d3:	41 5f                	pop    r15
   1855b95d5:	5d                   	pop    rbp
   1855b95d6:	c3                   	ret
   1855b95d7:	e8 b0 3d f5 01       	call   0x18750d38c
   1855b95dc:	e8 af f5 a4 fa       	call   0x180008b90
   1855b95e1:	cc                   	int3
