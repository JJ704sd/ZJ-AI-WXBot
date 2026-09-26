
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

00000001854932a0 <.text+0x54922a0>:
   1854932a0:	55                   	push   rbp
   1854932a1:	41 57                	push   r15
   1854932a3:	41 56                	push   r14
   1854932a5:	41 54                	push   r12
   1854932a7:	56                   	push   rsi
   1854932a8:	57                   	push   rdi
   1854932a9:	53                   	push   rbx
   1854932aa:	48 81 ec 70 03 00 00 	sub    rsp,0x370
   1854932b1:	48 8d ac 24 80 00 00 	lea    rbp,[rsp+0x80]
   1854932b8:	00 
   1854932b9:	0f 29 b5 e0 02 00 00 	movaps XMMWORD PTR [rbp+0x2e0],xmm6
   1854932c0:	48 c7 85 d8 02 00 00 	mov    QWORD PTR [rbp+0x2d8],0xfffffffffffffffe
   1854932c7:	fe ff ff ff 
   1854932cb:	4c 89 8d c8 02 00 00 	mov    QWORD PTR [rbp+0x2c8],r9
   1854932d2:	4c 89 c6             	mov    rsi,r8
   1854932d5:	48 89 d7             	mov    rdi,rdx
   1854932d8:	0f 28 35 d1 28 8b 03 	movaps xmm6,XMMWORD PTR [rip+0x38b28d1]        # 0x188d45bb0
   1854932df:	0f 29 b5 80 00 00 00 	movaps XMMWORD PTR [rbp+0x80],xmm6
   1854932e6:	48 8d 9d 00 01 00 00 	lea    rbx,[rbp+0x100]
   1854932ed:	48 89 d9             	mov    rcx,rbx
   1854932f0:	e8 2b 3f bb fa       	call   0x180047220
   1854932f5:	90                   	nop
   1854932f6:	48 8b 8d 00 01 00 00 	mov    rcx,QWORD PTR [rbp+0x100]
   1854932fd:	48 8d 95 20 02 00 00 	lea    rdx,[rbp+0x220]
   185493304:	e8 37 94 ed fa       	call   0x18036c740
   185493309:	90                   	nop
   18549330a:	48 8b 8d 20 02 00 00 	mov    rcx,QWORD PTR [rbp+0x220]
   185493311:	48 8d 95 90 01 00 00 	lea    rdx,[rbp+0x190]
   185493318:	e8 23 d7 fc fa       	call   0x180460a40
   18549331d:	90                   	nop
   18549331e:	48 8b 8d 90 01 00 00 	mov    rcx,QWORD PTR [rbp+0x190]
   185493325:	48 8d 95 80 00 00 00 	lea    rdx,[rbp+0x80]
   18549332c:	49 89 f8             	mov    r8,rdi
   18549332f:	e8 5c 73 b7 fb       	call   0x18100a690
   185493334:	90                   	nop
   185493335:	4c 8b b5 98 01 00 00 	mov    r14,QWORD PTR [rbp+0x198]
   18549333c:	4d 85 f6             	test   r14,r14
   18549333f:	74 1f                	je     0x185493360
   185493341:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   185493346:	75 18                	jne    0x185493360
   185493348:	49 8b 06             	mov    rax,QWORD PTR [r14]
   18549334b:	4c 89 f1             	mov    rcx,r14
   18549334e:	ff 10                	call   QWORD PTR [rax]
   185493350:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   185493355:	75 09                	jne    0x185493360
   185493357:	49 8b 06             	mov    rax,QWORD PTR [r14]
   18549335a:	4c 89 f1             	mov    rcx,r14
   18549335d:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185493360:	4c 8b b5 28 02 00 00 	mov    r14,QWORD PTR [rbp+0x228]
   185493367:	4d 85 f6             	test   r14,r14
   18549336a:	74 1f                	je     0x18549338b
   18549336c:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   185493371:	75 18                	jne    0x18549338b
   185493373:	49 8b 06             	mov    rax,QWORD PTR [r14]
   185493376:	4c 89 f1             	mov    rcx,r14
   185493379:	ff 10                	call   QWORD PTR [rax]
   18549337b:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   185493380:	75 09                	jne    0x18549338b
   185493382:	49 8b 06             	mov    rax,QWORD PTR [r14]
   185493385:	4c 89 f1             	mov    rcx,r14
   185493388:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18549338b:	4c 8b b5 08 01 00 00 	mov    r14,QWORD PTR [rbp+0x108]
   185493392:	4d 85 f6             	test   r14,r14
   185493395:	74 1f                	je     0x1854933b6
   185493397:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   18549339c:	75 18                	jne    0x1854933b6
   18549339e:	49 8b 06             	mov    rax,QWORD PTR [r14]
   1854933a1:	4c 89 f1             	mov    rcx,r14
   1854933a4:	ff 10                	call   QWORD PTR [rax]
   1854933a6:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   1854933ab:	75 09                	jne    0x1854933b6
   1854933ad:	49 8b 06             	mov    rax,QWORD PTR [r14]
   1854933b0:	4c 89 f1             	mov    rcx,r14
   1854933b3:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1854933b6:	48 83 bd 80 00 00 00 	cmp    QWORD PTR [rbp+0x80],0x0
   1854933bd:	00 
   1854933be:	74 6e                	je     0x18549342e
   1854933c0:	0f 57 c0             	xorps  xmm0,xmm0
   1854933c3:	0f 29 85 a0 02 00 00 	movaps XMMWORD PTR [rbp+0x2a0],xmm0
   1854933ca:	48 c7 85 b0 02 00 00 	mov    QWORD PTR [rbp+0x2b0],0x0
   1854933d1:	00 00 00 00 
   1854933d5:	48 c7 85 b8 02 00 00 	mov    QWORD PTR [rbp+0x2b8],0xf
   1854933dc:	0f 00 00 00 
   1854933e0:	80 7f 50 01          	cmp    BYTE PTR [rdi+0x50],0x1
   1854933e4:	0f 85 e1 02 00 00    	jne    0x1854936cb
   1854933ea:	4c 8b 77 38          	mov    r14,QWORD PTR [rdi+0x38]
   1854933ee:	48 83 7f 40 10       	cmp    QWORD PTR [rdi+0x40],0x10
   1854933f3:	0f 82 1b 03 00 00    	jb     0x185493714
   1854933f9:	4c 8b 4f 28          	mov    r9,QWORD PTR [rdi+0x28]
   1854933fd:	49 83 fe 0f          	cmp    r14,0xf
   185493401:	0f 87 1b 03 00 00    	ja     0x185493722
   185493407:	4c 89 b5 b0 02 00 00 	mov    QWORD PTR [rbp+0x2b0],r14
   18549340e:	48 8d 8d a0 02 00 00 	lea    rcx,[rbp+0x2a0]
   185493415:	4c 89 ca             	mov    rdx,r9
   185493418:	4d 89 f0             	mov    r8,r14
   18549341b:	e8 30 0c 0b 02       	call   0x187544050
   185493420:	42 c6 84 35 a0 02 00 	mov    BYTE PTR [rbp+r14*1+0x2a0],0x0
   185493427:	00 00 
   185493429:	e9 6d 07 00 00       	jmp    0x185493b9b
   18549342e:	b9 03 00 00 00       	mov    ecx,0x3
   185493433:	e8 a8 99 bd fa       	call   0x18006cde0
   185493438:	85 c0                	test   eax,eax
   18549343a:	0f 84 44 01 00 00    	je     0x185493584
   185493440:	4c 8d b5 a0 02 00 00 	lea    r14,[rbp+0x2a0]
   185493447:	4c 89 f1             	mov    rcx,r14
   18549344a:	e8 c1 9a bd fa       	call   0x18006cf10
   18549344f:	90                   	nop
   185493450:	48 83 bd b8 02 00 00 	cmp    QWORD PTR [rbp+0x2b8],0x10
   185493457:	10 
   185493458:	72 07                	jb     0x185493461
   18549345a:	4c 8b b5 a0 02 00 00 	mov    r14,QWORD PTR [rbp+0x2a0]
   185493461:	48 8d 05 b8 0e 37 04 	lea    rax,[rip+0x4370eb8]        # 0x189804320
   185493468:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   18549346d:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   185493474:	00 00 
   185493476:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   18549347b:	c7 44 24 28 15 01 00 	mov    DWORD PTR [rsp+0x28],0x115
   185493482:	00 
   185493483:	4c 8d 0d 26 09 37 04 	lea    r9,[rip+0x4370926]        # 0x189803db0
   18549348a:	48 8d 8d 90 01 00 00 	lea    rcx,[rbp+0x190]
   185493491:	ba 03 00 00 00       	mov    edx,0x3
   185493496:	4d 89 f0             	mov    r8,r14
   185493499:	e8 d2 9d bd fa       	call   0x18006d270
   18549349e:	90                   	nop
   18549349f:	48 83 7f 18 10       	cmp    QWORD PTR [rdi+0x18],0x10
   1854934a4:	72 03                	jb     0x1854934a9
   1854934a6:	48 8b 3f             	mov    rdi,QWORD PTR [rdi]
   1854934a9:	48 89 bd 00 01 00 00 	mov    QWORD PTR [rbp+0x100],rdi
   1854934b0:	c6 85 08 01 00 00 00 	mov    BYTE PTR [rbp+0x108],0x0
   1854934b7:	48 83 7e 18 10       	cmp    QWORD PTR [rsi+0x18],0x10
   1854934bc:	72 03                	jb     0x1854934c1
   1854934be:	48 8b 36             	mov    rsi,QWORD PTR [rsi]
   1854934c1:	48 89 b5 b0 00 00 00 	mov    QWORD PTR [rbp+0xb0],rsi
   1854934c8:	c6 85 b8 00 00 00 00 	mov    BYTE PTR [rbp+0xb8],0x0
   1854934cf:	0f 57 c0             	xorps  xmm0,xmm0
   1854934d2:	0f 11 85 90 02 00 00 	movups XMMWORD PTR [rbp+0x290],xmm0
   1854934d9:	0f 11 85 80 02 00 00 	movups XMMWORD PTR [rbp+0x280],xmm0
   1854934e0:	0f 11 85 70 02 00 00 	movups XMMWORD PTR [rbp+0x270],xmm0
   1854934e7:	0f 11 85 60 02 00 00 	movups XMMWORD PTR [rbp+0x260],xmm0
   1854934ee:	0f 11 85 50 02 00 00 	movups XMMWORD PTR [rbp+0x250],xmm0
   1854934f5:	0f 11 85 40 02 00 00 	movups XMMWORD PTR [rbp+0x240],xmm0
   1854934fc:	0f 11 85 30 02 00 00 	movups XMMWORD PTR [rbp+0x230],xmm0
   185493503:	48 8d 85 b0 00 00 00 	lea    rax,[rbp+0xb0]
   18549350a:	48 89 85 20 02 00 00 	mov    QWORD PTR [rbp+0x220],rax
   185493511:	48 89 9d 28 02 00 00 	mov    QWORD PTR [rbp+0x228],rbx
   185493518:	48 8d 15 79 0f 37 04 	lea    rdx,[rip+0x4370f79]        # 0x189804498
   18549351f:	48 8d 8d 90 01 00 00 	lea    rcx,[rbp+0x190]
   185493526:	4c 8d 85 20 02 00 00 	lea    r8,[rbp+0x220]
   18549352d:	e8 de a2 bd fa       	call   0x18006d810
   185493532:	90                   	nop
   185493533:	48 8d 8d 90 01 00 00 	lea    rcx,[rbp+0x190]
   18549353a:	e8 31 9e bd fa       	call   0x18006d370
   18549353f:	48 8b 85 b8 02 00 00 	mov    rax,QWORD PTR [rbp+0x2b8]
   185493546:	48 83 f8 10          	cmp    rax,0x10
   18549354a:	72 38                	jb     0x185493584
   18549354c:	48 8b 8d a0 02 00 00 	mov    rcx,QWORD PTR [rbp+0x2a0]
   185493553:	48 8d 50 01          	lea    rdx,[rax+0x1]
   185493557:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18549355e:	72 1f                	jb     0x18549357f
   185493560:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   185493564:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   185493568:	4c 29 c1             	sub    rcx,r8
   18549356b:	48 83 f9 20          	cmp    rcx,0x20
   18549356f:	0f 83 96 13 00 00    	jae    0x18549490b
   185493575:	48 83 c0 28          	add    rax,0x28
   185493579:	48 89 c2             	mov    rdx,rax
   18549357c:	4c 89 c1             	mov    rcx,r8
   18549357f:	e8 5c 83 01 02       	call   0x1874ab8e0
   185493584:	0f 57 c0             	xorps  xmm0,xmm0
   185493587:	0f 29 85 30 02 00 00 	movaps XMMWORD PTR [rbp+0x230],xmm0
   18549358e:	0f 29 85 20 02 00 00 	movaps XMMWORD PTR [rbp+0x220],xmm0
   185493595:	b9 20 00 00 00       	mov    ecx,0x20
   18549359a:	e8 fd 82 01 02       	call   0x1874ab89c
   18549359f:	90                   	nop
   1854935a0:	48 89 85 20 02 00 00 	mov    QWORD PTR [rbp+0x220],rax
   1854935a7:	48 c7 85 30 02 00 00 	mov    QWORD PTR [rbp+0x230],0x11
   1854935ae:	11 00 00 00 
   1854935b2:	48 c7 85 38 02 00 00 	mov    QWORD PTR [rbp+0x238],0x1f
   1854935b9:	1f 00 00 00 
   1854935bd:	0f 10 05 44 f1 36 04 	movups xmm0,XMMWORD PTR [rip+0x436f144]        # 0x189802708
   1854935c4:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   1854935c7:	66 c7 40 10 64 00    	mov    WORD PTR [rax+0x10],0x64
   1854935cd:	0f 29 b5 a0 01 00 00 	movaps XMMWORD PTR [rbp+0x1a0],xmm6
   1854935d4:	0f 29 b5 b0 01 00 00 	movaps XMMWORD PTR [rbp+0x1b0],xmm6
   1854935db:	0f 29 b5 d0 01 00 00 	movaps XMMWORD PTR [rbp+0x1d0],xmm6
   1854935e2:	0f 29 b5 90 01 00 00 	movaps XMMWORD PTR [rbp+0x190],xmm6
   1854935e9:	0f 29 b5 c0 01 00 00 	movaps XMMWORD PTR [rbp+0x1c0],xmm6
   1854935f0:	c6 85 a0 01 00 00 00 	mov    BYTE PTR [rbp+0x1a0],0x0
   1854935f7:	c6 85 b0 01 00 00 00 	mov    BYTE PTR [rbp+0x1b0],0x0
   1854935fe:	c6 85 d8 01 00 00 00 	mov    BYTE PTR [rbp+0x1d8],0x0
   185493605:	c6 85 90 01 00 00 00 	mov    BYTE PTR [rbp+0x190],0x0
   18549360c:	48 8d 8d b8 01 00 00 	lea    rcx,[rbp+0x1b8]
   185493613:	48 8d 95 20 02 00 00 	lea    rdx,[rbp+0x220]
   18549361a:	e8 71 c4 4e fc       	call   0x18197fa90
   18549361f:	90                   	nop
   185493620:	48 8b 85 c8 02 00 00 	mov    rax,QWORD PTR [rbp+0x2c8]
   185493627:	48 8b 08             	mov    rcx,QWORD PTR [rax]
   18549362a:	48 89 8d 00 01 00 00 	mov    QWORD PTR [rbp+0x100],rcx
   185493631:	48 c7 00 00 00 00 00 	mov    QWORD PTR [rax],0x0
   185493638:	48 8d 95 90 01 00 00 	lea    rdx,[rbp+0x190]
   18549363f:	ff 51 08             	call   QWORD PTR [rcx+0x8]
   185493642:	90                   	nop
   185493643:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   18549364a:	e8 01 3a c7 fa       	call   0x180107050
   18549364f:	80 bd d8 01 00 00 01 	cmp    BYTE PTR [rbp+0x1d8],0x1
   185493656:	75 45                	jne    0x18549369d
   185493658:	48 8b 85 d0 01 00 00 	mov    rax,QWORD PTR [rbp+0x1d0]
   18549365f:	48 83 f8 10          	cmp    rax,0x10
   185493663:	72 38                	jb     0x18549369d
   185493665:	48 8b 8d b8 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1b8]
   18549366c:	48 8d 50 01          	lea    rdx,[rax+0x1]
   185493670:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185493677:	72 1f                	jb     0x185493698
   185493679:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18549367d:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   185493681:	4c 29 c1             	sub    rcx,r8
   185493684:	48 83 f9 20          	cmp    rcx,0x20
   185493688:	0f 83 7d 12 00 00    	jae    0x18549490b
   18549368e:	48 83 c0 28          	add    rax,0x28
   185493692:	48 89 c2             	mov    rdx,rax
   185493695:	4c 89 c1             	mov    rcx,r8
   185493698:	e8 43 82 01 02       	call   0x1874ab8e0
   18549369d:	48 8b 85 38 02 00 00 	mov    rax,QWORD PTR [rbp+0x238]
   1854936a4:	48 83 f8 10          	cmp    rax,0x10
   1854936a8:	0f 82 0f 12 00 00    	jb     0x1854948bd
   1854936ae:	48 8b 8d 20 02 00 00 	mov    rcx,QWORD PTR [rbp+0x220]
   1854936b5:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1854936b9:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1854936c0:	0f 83 d7 11 00 00    	jae    0x18549489d
   1854936c6:	e9 ed 11 00 00       	jmp    0x1854948b8
   1854936cb:	48 b8 aa aa aa aa aa 	movabs rax,0xaaaaaaaaaaaaaaaa
   1854936d2:	aa aa aa 
   1854936d5:	48 89 85 d0 00 00 00 	mov    QWORD PTR [rbp+0xd0],rax
   1854936dc:	0f 29 b5 c0 00 00 00 	movaps XMMWORD PTR [rbp+0xc0],xmm6
   1854936e3:	0f 29 b5 b0 00 00 00 	movaps XMMWORD PTR [rbp+0xb0],xmm6
   1854936ea:	0f 29 85 90 01 00 00 	movaps XMMWORD PTR [rbp+0x190],xmm0
   1854936f1:	48 c7 85 a0 01 00 00 	mov    QWORD PTR [rbp+0x1a0],0x0
   1854936f8:	00 00 00 00 
   1854936fc:	48 c7 85 a8 01 00 00 	mov    QWORD PTR [rbp+0x1a8],0xf
   185493703:	0f 00 00 00 
   185493707:	48 83 7f 40 10       	cmp    QWORD PTR [rdi+0x40],0x10
   18549370c:	72 29                	jb     0x185493737
   18549370e:	48 8b 47 28          	mov    rax,QWORD PTR [rdi+0x28]
   185493712:	eb 27                	jmp    0x18549373b
   185493714:	4c 8d 4f 28          	lea    r9,[rdi+0x28]
   185493718:	49 83 fe 0f          	cmp    r14,0xf
   18549371c:	0f 86 e5 fc ff ff    	jbe    0x185493407
   185493722:	48 8d 8d a0 02 00 00 	lea    rcx,[rbp+0x2a0]
   185493729:	4c 89 f2             	mov    rdx,r14
   18549372c:	e8 1f aa ba fa       	call   0x18003e150
   185493731:	90                   	nop
   185493732:	e9 64 04 00 00       	jmp    0x185493b9b
   185493737:	48 8d 47 28          	lea    rax,[rdi+0x28]
   18549373b:	48 89 85 20 02 00 00 	mov    QWORD PTR [rbp+0x220],rax
   185493742:	48 8b 47 38          	mov    rax,QWORD PTR [rdi+0x38]
   185493746:	48 89 85 28 02 00 00 	mov    QWORD PTR [rbp+0x228],rax
   18549374d:	48 8d 8d 20 02 00 00 	lea    rcx,[rbp+0x220]
   185493754:	48 8d 95 90 01 00 00 	lea    rdx,[rbp+0x190]
   18549375b:	e8 b0 26 1b fb       	call   0x180645e10
   185493760:	90                   	nop
   185493761:	84 c0                	test   al,al
   185493763:	74 65                	je     0x1854937ca
   185493765:	0f 28 85 90 01 00 00 	movaps xmm0,XMMWORD PTR [rbp+0x190]
   18549376c:	0f 28 8d a0 01 00 00 	movaps xmm1,XMMWORD PTR [rbp+0x1a0]
   185493773:	0f 29 8d c0 00 00 00 	movaps XMMWORD PTR [rbp+0xc0],xmm1
   18549377a:	0f 29 85 b0 00 00 00 	movaps XMMWORD PTR [rbp+0xb0],xmm0
   185493781:	c6 85 d0 00 00 00 01 	mov    BYTE PTR [rbp+0xd0],0x1
   185493788:	4c 8b b5 c0 00 00 00 	mov    r14,QWORD PTR [rbp+0xc0]
   18549378f:	48 83 bd c8 00 00 00 	cmp    QWORD PTR [rbp+0xc8],0x10
   185493796:	10 
   185493797:	0f 82 4e 03 00 00    	jb     0x185493aeb
   18549379d:	4c 8b 8d b0 00 00 00 	mov    r9,QWORD PTR [rbp+0xb0]
   1854937a4:	48 8b 85 b8 02 00 00 	mov    rax,QWORD PTR [rbp+0x2b8]
   1854937ab:	49 39 c6             	cmp    r14,rax
   1854937ae:	0f 87 4e 03 00 00    	ja     0x185493b02
   1854937b4:	48 83 f8 10          	cmp    rax,0x10
   1854937b8:	0f 82 62 03 00 00    	jb     0x185493b20
   1854937be:	4c 8b bd a0 02 00 00 	mov    r15,QWORD PTR [rbp+0x2a0]
   1854937c5:	e9 5d 03 00 00       	jmp    0x185493b27
   1854937ca:	c6 85 d0 00 00 00 00 	mov    BYTE PTR [rbp+0xd0],0x0
   1854937d1:	48 8b 85 a8 01 00 00 	mov    rax,QWORD PTR [rbp+0x1a8]
   1854937d8:	48 83 f8 0f          	cmp    rax,0xf
   1854937dc:	76 45                	jbe    0x185493823
   1854937de:	48 8b 8d 90 01 00 00 	mov    rcx,QWORD PTR [rbp+0x190]
   1854937e5:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1854937e9:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1854937f0:	72 1f                	jb     0x185493811
   1854937f2:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1854937f6:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1854937fa:	4c 29 c1             	sub    rcx,r8
   1854937fd:	48 83 f9 20          	cmp    rcx,0x20
   185493801:	0f 83 04 11 00 00    	jae    0x18549490b
   185493807:	48 83 c0 28          	add    rax,0x28
   18549380b:	48 89 c2             	mov    rdx,rax
   18549380e:	4c 89 c1             	mov    rcx,r8
   185493811:	e8 ca 80 01 02       	call   0x1874ab8e0
   185493816:	f6 85 d0 00 00 00 01 	test   BYTE PTR [rbp+0xd0],0x1
   18549381d:	0f 85 65 ff ff ff    	jne    0x185493788
   185493823:	b9 04 00 00 00       	mov    ecx,0x4
   185493828:	e8 b3 95 bd fa       	call   0x18006cde0
   18549382d:	85 c0                	test   eax,eax
   18549382f:	0f 84 2c 01 00 00    	je     0x185493961
   185493835:	4c 8d b5 70 01 00 00 	lea    r14,[rbp+0x170]
   18549383c:	4c 89 f1             	mov    rcx,r14
   18549383f:	e8 cc 96 bd fa       	call   0x18006cf10
   185493844:	90                   	nop
   185493845:	48 83 bd 88 01 00 00 	cmp    QWORD PTR [rbp+0x188],0x10
   18549384c:	10 
   18549384d:	72 07                	jb     0x185493856
   18549384f:	4c 8b b5 70 01 00 00 	mov    r14,QWORD PTR [rbp+0x170]
   185493856:	48 8d 05 c3 0a 37 04 	lea    rax,[rip+0x4370ac3]        # 0x189804320
   18549385d:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   185493862:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   185493869:	00 00 
   18549386b:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   185493870:	c7 44 24 28 21 01 00 	mov    DWORD PTR [rsp+0x28],0x121
   185493877:	00 
   185493878:	4c 8d 0d 31 05 37 04 	lea    r9,[rip+0x4370531]        # 0x189803db0
   18549387f:	48 8d 8d 90 01 00 00 	lea    rcx,[rbp+0x190]
   185493886:	ba 04 00 00 00       	mov    edx,0x4
   18549388b:	4d 89 f0             	mov    r8,r14
   18549388e:	e8 dd 99 bd fa       	call   0x18006d270
   185493893:	90                   	nop
   185493894:	48 83 7e 18 10       	cmp    QWORD PTR [rsi+0x18],0x10
   185493899:	48 89 f0             	mov    rax,rsi
   18549389c:	72 03                	jb     0x1854938a1
   18549389e:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1854938a1:	48 89 85 00 01 00 00 	mov    QWORD PTR [rbp+0x100],rax
   1854938a8:	c6 85 08 01 00 00 00 	mov    BYTE PTR [rbp+0x108],0x0
   1854938af:	0f 57 c0             	xorps  xmm0,xmm0
   1854938b2:	0f 11 85 88 02 00 00 	movups XMMWORD PTR [rbp+0x288],xmm0
   1854938b9:	0f 11 85 78 02 00 00 	movups XMMWORD PTR [rbp+0x278],xmm0
   1854938c0:	0f 11 85 68 02 00 00 	movups XMMWORD PTR [rbp+0x268],xmm0
   1854938c7:	0f 11 85 58 02 00 00 	movups XMMWORD PTR [rbp+0x258],xmm0
   1854938ce:	0f 11 85 48 02 00 00 	movups XMMWORD PTR [rbp+0x248],xmm0
   1854938d5:	0f 11 85 38 02 00 00 	movups XMMWORD PTR [rbp+0x238],xmm0
   1854938dc:	0f 11 85 28 02 00 00 	movups XMMWORD PTR [rbp+0x228],xmm0
   1854938e3:	48 c7 85 98 02 00 00 	mov    QWORD PTR [rbp+0x298],0x0
   1854938ea:	00 00 00 00 
   1854938ee:	48 89 9d 20 02 00 00 	mov    QWORD PTR [rbp+0x220],rbx
   1854938f5:	48 8d 15 fc 0b 37 04 	lea    rdx,[rip+0x4370bfc]        # 0x1898044f8
   1854938fc:	48 8d 8d 90 01 00 00 	lea    rcx,[rbp+0x190]
   185493903:	4c 8d 85 20 02 00 00 	lea    r8,[rbp+0x220]
   18549390a:	e8 01 9f bd fa       	call   0x18006d810
   18549390f:	90                   	nop
   185493910:	48 8d 8d 90 01 00 00 	lea    rcx,[rbp+0x190]
   185493917:	e8 54 9a bd fa       	call   0x18006d370
   18549391c:	48 8b 85 88 01 00 00 	mov    rax,QWORD PTR [rbp+0x188]
   185493923:	48 83 f8 10          	cmp    rax,0x10
   185493927:	72 38                	jb     0x185493961
   185493929:	48 8b 8d 70 01 00 00 	mov    rcx,QWORD PTR [rbp+0x170]
   185493930:	48 8d 50 01          	lea    rdx,[rax+0x1]
   185493934:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18549393b:	72 1f                	jb     0x18549395c
   18549393d:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   185493941:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   185493945:	4c 29 c1             	sub    rcx,r8
   185493948:	48 83 f9 20          	cmp    rcx,0x20
   18549394c:	0f 83 b9 0f 00 00    	jae    0x18549490b
   185493952:	48 83 c0 28          	add    rax,0x28
   185493956:	48 89 c2             	mov    rdx,rax
   185493959:	4c 89 c1             	mov    rcx,r8
   18549395c:	e8 7f 7f 01 02       	call   0x1874ab8e0
   185493961:	0f 57 c0             	xorps  xmm0,xmm0
   185493964:	0f 29 85 30 02 00 00 	movaps XMMWORD PTR [rbp+0x230],xmm0
   18549396b:	0f 29 85 20 02 00 00 	movaps XMMWORD PTR [rbp+0x220],xmm0
   185493972:	b9 40 00 00 00       	mov    ecx,0x40
   185493977:	e8 20 7f 01 02       	call   0x1874ab89c
   18549397c:	90                   	nop
   18549397d:	48 89 85 20 02 00 00 	mov    QWORD PTR [rbp+0x220],rax
   185493984:	48 c7 85 30 02 00 00 	mov    QWORD PTR [rbp+0x230],0x33
   18549398b:	33 00 00 00 
   18549398f:	48 c7 85 38 02 00 00 	mov    QWORD PTR [rbp+0x238],0x3f
   185493996:	3f 00 00 00 
   18549399a:	0f 10 05 9f ed 36 04 	movups xmm0,XMMWORD PTR [rip+0x436ed9f]        # 0x189802740
   1854939a1:	0f 11 40 20          	movups XMMWORD PTR [rax+0x20],xmm0
   1854939a5:	0f 10 05 84 ed 36 04 	movups xmm0,XMMWORD PTR [rip+0x436ed84]        # 0x189802730
   1854939ac:	0f 11 40 10          	movups XMMWORD PTR [rax+0x10],xmm0
   1854939b0:	0f 10 05 69 ed 36 04 	movups xmm0,XMMWORD PTR [rip+0x436ed69]        # 0x189802720
   1854939b7:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   1854939ba:	c7 40 2f 61 6c 69 64 	mov    DWORD PTR [rax+0x2f],0x64696c61
   1854939c1:	c6 40 33 00          	mov    BYTE PTR [rax+0x33],0x0
   1854939c5:	0f 29 b5 a0 01 00 00 	movaps XMMWORD PTR [rbp+0x1a0],xmm6
   1854939cc:	0f 29 b5 b0 01 00 00 	movaps XMMWORD PTR [rbp+0x1b0],xmm6
   1854939d3:	0f 29 b5 d0 01 00 00 	movaps XMMWORD PTR [rbp+0x1d0],xmm6
   1854939da:	0f 29 b5 90 01 00 00 	movaps XMMWORD PTR [rbp+0x190],xmm6
   1854939e1:	0f 29 b5 c0 01 00 00 	movaps XMMWORD PTR [rbp+0x1c0],xmm6
   1854939e8:	c6 85 a0 01 00 00 00 	mov    BYTE PTR [rbp+0x1a0],0x0
   1854939ef:	c6 85 b0 01 00 00 00 	mov    BYTE PTR [rbp+0x1b0],0x0
   1854939f6:	c6 85 d8 01 00 00 00 	mov    BYTE PTR [rbp+0x1d8],0x0
   1854939fd:	c6 85 90 01 00 00 00 	mov    BYTE PTR [rbp+0x190],0x0
   185493a04:	48 8d 8d b8 01 00 00 	lea    rcx,[rbp+0x1b8]
   185493a0b:	48 8d 95 20 02 00 00 	lea    rdx,[rbp+0x220]
   185493a12:	e8 79 c0 4e fc       	call   0x18197fa90
   185493a17:	90                   	nop
   185493a18:	48 8b 85 c8 02 00 00 	mov    rax,QWORD PTR [rbp+0x2c8]
   185493a1f:	48 8b 08             	mov    rcx,QWORD PTR [rax]
   185493a22:	48 89 8d 00 01 00 00 	mov    QWORD PTR [rbp+0x100],rcx
   185493a29:	48 c7 00 00 00 00 00 	mov    QWORD PTR [rax],0x0
   185493a30:	48 8d 95 90 01 00 00 	lea    rdx,[rbp+0x190]
   185493a37:	ff 51 08             	call   QWORD PTR [rcx+0x8]
   185493a3a:	90                   	nop
   185493a3b:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   185493a42:	e8 09 36 c7 fa       	call   0x180107050
   185493a47:	80 bd d8 01 00 00 01 	cmp    BYTE PTR [rbp+0x1d8],0x1
   185493a4e:	75 45                	jne    0x185493a95
   185493a50:	48 8b 85 d0 01 00 00 	mov    rax,QWORD PTR [rbp+0x1d0]
   185493a57:	48 83 f8 10          	cmp    rax,0x10
   185493a5b:	72 38                	jb     0x185493a95
   185493a5d:	48 8b 8d b8 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1b8]
   185493a64:	48 8d 50 01          	lea    rdx,[rax+0x1]
   185493a68:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185493a6f:	72 1f                	jb     0x185493a90
   185493a71:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   185493a75:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   185493a79:	4c 29 c1             	sub    rcx,r8
   185493a7c:	48 83 f9 20          	cmp    rcx,0x20
   185493a80:	0f 83 85 0e 00 00    	jae    0x18549490b
   185493a86:	48 83 c0 28          	add    rax,0x28
   185493a8a:	48 89 c2             	mov    rdx,rax
   185493a8d:	4c 89 c1             	mov    rcx,r8
   185493a90:	e8 4b 7e 01 02       	call   0x1874ab8e0
   185493a95:	48 8b 85 38 02 00 00 	mov    rax,QWORD PTR [rbp+0x238]
   185493a9c:	48 83 f8 10          	cmp    rax,0x10
   185493aa0:	72 38                	jb     0x185493ada
   185493aa2:	48 8b 8d 20 02 00 00 	mov    rcx,QWORD PTR [rbp+0x220]
   185493aa9:	48 8d 50 01          	lea    rdx,[rax+0x1]
   185493aad:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185493ab4:	72 1f                	jb     0x185493ad5
   185493ab6:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   185493aba:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   185493abe:	4c 29 c1             	sub    rcx,r8
   185493ac1:	48 83 f9 20          	cmp    rcx,0x20
   185493ac5:	0f 83 40 0e 00 00    	jae    0x18549490b
   185493acb:	48 83 c0 28          	add    rax,0x28
   185493acf:	48 89 c2             	mov    rdx,rax
   185493ad2:	4c 89 c1             	mov    rcx,r8
   185493ad5:	e8 06 7e 01 02       	call   0x1874ab8e0
   185493ada:	45 31 ff             	xor    r15d,r15d
   185493add:	80 bd d0 00 00 00 01 	cmp    BYTE PTR [rbp+0xd0],0x1
   185493ae4:	74 67                	je     0x185493b4d
   185493ae6:	e9 a7 00 00 00       	jmp    0x185493b92
   185493aeb:	4c 8d 8d b0 00 00 00 	lea    r9,[rbp+0xb0]
   185493af2:	48 8b 85 b8 02 00 00 	mov    rax,QWORD PTR [rbp+0x2b8]
   185493af9:	49 39 c6             	cmp    r14,rax
   185493afc:	0f 86 b2 fc ff ff    	jbe    0x1854937b4
   185493b02:	41 b7 01             	mov    r15b,0x1
   185493b05:	48 8d 8d a0 02 00 00 	lea    rcx,[rbp+0x2a0]
   185493b0c:	4c 89 f2             	mov    rdx,r14
   185493b0f:	e8 3c a6 ba fa       	call   0x18003e150
   185493b14:	90                   	nop
   185493b15:	80 bd d0 00 00 00 01 	cmp    BYTE PTR [rbp+0xd0],0x1
   185493b1c:	74 2f                	je     0x185493b4d
   185493b1e:	eb 72                	jmp    0x185493b92
   185493b20:	4c 8d bd a0 02 00 00 	lea    r15,[rbp+0x2a0]
   185493b27:	4c 89 b5 b0 02 00 00 	mov    QWORD PTR [rbp+0x2b0],r14
   185493b2e:	4c 89 f9             	mov    rcx,r15
   185493b31:	4c 89 ca             	mov    rdx,r9
   185493b34:	4d 89 f0             	mov    r8,r14
   185493b37:	e8 14 05 0b 02       	call   0x187544050
   185493b3c:	43 c6 04 37 00       	mov    BYTE PTR [r15+r14*1],0x0
   185493b41:	41 b7 01             	mov    r15b,0x1
   185493b44:	80 bd d0 00 00 00 01 	cmp    BYTE PTR [rbp+0xd0],0x1
   185493b4b:	75 45                	jne    0x185493b92
   185493b4d:	48 8b 85 c8 00 00 00 	mov    rax,QWORD PTR [rbp+0xc8]
   185493b54:	48 83 f8 10          	cmp    rax,0x10
   185493b58:	72 38                	jb     0x185493b92
   185493b5a:	48 8b 8d b0 00 00 00 	mov    rcx,QWORD PTR [rbp+0xb0]
   185493b61:	48 8d 50 01          	lea    rdx,[rax+0x1]
   185493b65:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185493b6c:	72 1f                	jb     0x185493b8d
   185493b6e:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   185493b72:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   185493b76:	4c 29 c1             	sub    rcx,r8
   185493b79:	48 83 f9 20          	cmp    rcx,0x20
   185493b7d:	0f 83 88 0d 00 00    	jae    0x18549490b
   185493b83:	48 83 c0 28          	add    rax,0x28
   185493b87:	48 89 c2             	mov    rdx,rax
   185493b8a:	4c 89 c1             	mov    rcx,r8
   185493b8d:	e8 4e 7d 01 02       	call   0x1874ab8e0
   185493b92:	45 84 ff             	test   r15b,r15b
   185493b95:	0f 84 e1 0c 00 00    	je     0x18549487c
   185493b9b:	b9 02 00 00 00       	mov    ecx,0x2
   185493ba0:	e8 3b 92 bd fa       	call   0x18006cde0
   185493ba5:	85 c0                	test   eax,eax
   185493ba7:	0f 84 d5 01 00 00    	je     0x185493d82
   185493bad:	4c 8d b5 70 01 00 00 	lea    r14,[rbp+0x170]
   185493bb4:	4c 89 f1             	mov    rcx,r14
   185493bb7:	e8 54 93 bd fa       	call   0x18006cf10
   185493bbc:	90                   	nop
   185493bbd:	48 83 bd 88 01 00 00 	cmp    QWORD PTR [rbp+0x188],0x10
   185493bc4:	10 
   185493bc5:	72 07                	jb     0x185493bce
   185493bc7:	4c 8b b5 70 01 00 00 	mov    r14,QWORD PTR [rbp+0x170]
   185493bce:	48 8d 05 4b 07 37 04 	lea    rax,[rip+0x437074b]        # 0x189804320
   185493bd5:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   185493bda:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   185493be1:	00 00 
   185493be3:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   185493be8:	c7 44 24 28 27 01 00 	mov    DWORD PTR [rsp+0x28],0x127
   185493bef:	00 
   185493bf0:	4c 8d 0d b9 01 37 04 	lea    r9,[rip+0x43701b9]        # 0x189803db0
   185493bf7:	48 8d 8d 90 01 00 00 	lea    rcx,[rbp+0x190]
   185493bfe:	ba 02 00 00 00       	mov    edx,0x2
   185493c03:	4d 89 f0             	mov    r8,r14
   185493c06:	e8 65 96 bd fa       	call   0x18006d270
   185493c0b:	90                   	nop
   185493c0c:	48 8b 8d b0 02 00 00 	mov    rcx,QWORD PTR [rbp+0x2b0]
   185493c13:	48 c7 85 00 01 00 00 	mov    QWORD PTR [rbp+0x100],0x0
   185493c1a:	00 00 00 00 
   185493c1e:	41 b9 07 00 00 00    	mov    r9d,0x7
   185493c24:	4c 8d 85 07 01 00 00 	lea    r8,[rbp+0x107]
   185493c2b:	49 ba cd cc cc cc cc 	movabs r10,0xcccccccccccccccd
   185493c32:	cc cc cc 
   185493c35:	4c 8d 1d 34 26 8b 03 	lea    r11,[rip+0x38b2634]        # 0x188d46270
   185493c3c:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
   185493c40:	48 89 c8             	mov    rax,rcx
   185493c43:	49 f7 e2             	mul    r10
   185493c46:	48 c1 ea 03          	shr    rdx,0x3
   185493c4a:	48 8d 04 12          	lea    rax,[rdx+rdx*1]
   185493c4e:	48 8d 04 80          	lea    rax,[rax+rax*4]
   185493c52:	4d 89 de             	mov    r14,r11
   185493c55:	49 29 c6             	sub    r14,rax
   185493c58:	41 0f b6 44 0e 23    	movzx  eax,BYTE PTR [r14+rcx*1+0x23]
   185493c5e:	41 88 40 01          	mov    BYTE PTR [r8+0x1],al
   185493c62:	49 ff c0             	inc    r8
   185493c65:	49 ff c1             	inc    r9
   185493c68:	48 83 f9 09          	cmp    rcx,0x9
   185493c6c:	48 89 d1             	mov    rcx,rdx
   185493c6f:	77 cf                	ja     0x185493c40
   185493c71:	48 8d 85 08 01 00 00 	lea    rax,[rbp+0x108]
   185493c78:	41 c6 40 01 00       	mov    BYTE PTR [r8+0x1],0x0
   185493c7d:	49 83 f9 09          	cmp    r9,0x9
   185493c81:	72 28                	jb     0x185493cab
   185493c83:	48 8d 8d 09 01 00 00 	lea    rcx,[rbp+0x109]
   185493c8a:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
   185493c90:	41 0f b6 10          	movzx  edx,BYTE PTR [r8]
   185493c94:	44 0f b6 49 ff       	movzx  r9d,BYTE PTR [rcx-0x1]
   185493c99:	45 88 08             	mov    BYTE PTR [r8],r9b
   185493c9c:	49 ff c8             	dec    r8
   185493c9f:	88 51 ff             	mov    BYTE PTR [rcx-0x1],dl
   185493ca2:	4c 39 c1             	cmp    rcx,r8
   185493ca5:	48 8d 49 01          	lea    rcx,[rcx+0x1]
   185493ca9:	72 e5                	jb     0x185493c90
   185493cab:	48 89 85 00 01 00 00 	mov    QWORD PTR [rbp+0x100],rax
   185493cb2:	48 83 7e 18 10       	cmp    QWORD PTR [rsi+0x18],0x10
   185493cb7:	48 89 f0             	mov    rax,rsi
   185493cba:	72 03                	jb     0x185493cbf
   185493cbc:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   185493cbf:	48 89 85 b0 00 00 00 	mov    QWORD PTR [rbp+0xb0],rax
   185493cc6:	c6 85 b8 00 00 00 00 	mov    BYTE PTR [rbp+0xb8],0x0
   185493ccd:	0f 57 c0             	xorps  xmm0,xmm0
   185493cd0:	0f 11 85 90 02 00 00 	movups XMMWORD PTR [rbp+0x290],xmm0
   185493cd7:	0f 11 85 80 02 00 00 	movups XMMWORD PTR [rbp+0x280],xmm0
   185493cde:	0f 11 85 70 02 00 00 	movups XMMWORD PTR [rbp+0x270],xmm0
   185493ce5:	0f 11 85 60 02 00 00 	movups XMMWORD PTR [rbp+0x260],xmm0
   185493cec:	0f 11 85 50 02 00 00 	movups XMMWORD PTR [rbp+0x250],xmm0
   185493cf3:	0f 11 85 40 02 00 00 	movups XMMWORD PTR [rbp+0x240],xmm0
   185493cfa:	0f 11 85 30 02 00 00 	movups XMMWORD PTR [rbp+0x230],xmm0
   185493d01:	48 8d 85 b0 00 00 00 	lea    rax,[rbp+0xb0]
   185493d08:	48 89 85 20 02 00 00 	mov    QWORD PTR [rbp+0x220],rax
   185493d0f:	48 89 9d 28 02 00 00 	mov    QWORD PTR [rbp+0x228],rbx
   185493d16:	48 8d 15 5b 08 37 04 	lea    rdx,[rip+0x437085b]        # 0x189804578
   185493d1d:	48 8d 8d 90 01 00 00 	lea    rcx,[rbp+0x190]
   185493d24:	4c 8d 85 20 02 00 00 	lea    r8,[rbp+0x220]
   185493d2b:	e8 e0 9a bd fa       	call   0x18006d810
   185493d30:	90                   	nop
   185493d31:	48 8d 8d 90 01 00 00 	lea    rcx,[rbp+0x190]
   185493d38:	e8 33 96 bd fa       	call   0x18006d370
   185493d3d:	48 8b 85 88 01 00 00 	mov    rax,QWORD PTR [rbp+0x188]
   185493d44:	48 83 f8 10          	cmp    rax,0x10
   185493d48:	72 38                	jb     0x185493d82
   185493d4a:	48 8b 8d 70 01 00 00 	mov    rcx,QWORD PTR [rbp+0x170]
   185493d51:	48 8d 50 01          	lea    rdx,[rax+0x1]
   185493d55:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185493d5c:	72 1f                	jb     0x185493d7d
   185493d5e:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   185493d62:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   185493d66:	4c 29 c1             	sub    rcx,r8
   185493d69:	48 83 f9 20          	cmp    rcx,0x20
   185493d6d:	0f 83 98 0b 00 00    	jae    0x18549490b
   185493d73:	48 83 c0 28          	add    rax,0x28
   185493d77:	48 89 c2             	mov    rdx,rax
   185493d7a:	4c 89 c1             	mov    rcx,r8
   185493d7d:	e8 5e 7b 01 02       	call   0x1874ab8e0
   185493d82:	0f 29 b5 80 01 00 00 	movaps XMMWORD PTR [rbp+0x180],xmm6
   185493d89:	0f 29 b5 70 01 00 00 	movaps XMMWORD PTR [rbp+0x170],xmm6
   185493d90:	48 c7 85 28 02 00 00 	mov    QWORD PTR [rbp+0x228],0x0
   185493d97:	00 00 00 00 
   185493d9b:	48 c7 85 30 02 00 00 	mov    QWORD PTR [rbp+0x230],0x8
   185493da2:	08 00 00 00 
   185493da6:	48 c7 85 38 02 00 00 	mov    QWORD PTR [rbp+0x238],0xf
   185493dad:	0f 00 00 00 
   185493db1:	48 b8 63 61 74 65 67 	movabs rax,0x79726f6765746163
   185493db8:	6f 72 79 
   185493dbb:	48 89 85 20 02 00 00 	mov    QWORD PTR [rbp+0x220],rax
   185493dc2:	48 8d 8d 90 01 00 00 	lea    rcx,[rbp+0x190]
   185493dc9:	4c 8d b5 a0 02 00 00 	lea    r14,[rbp+0x2a0]
   185493dd0:	4c 8d 85 20 02 00 00 	lea    r8,[rbp+0x220]
   185493dd7:	4c 89 f2             	mov    rdx,r14
   185493dda:	e8 f1 29 23 ff       	call   0x1846c67d0
   185493ddf:	90                   	nop
   185493de0:	4c 8d bd 70 01 00 00 	lea    r15,[rbp+0x170]
   185493de7:	48 8d 95 90 01 00 00 	lea    rdx,[rbp+0x190]
   185493dee:	4c 89 f9             	mov    rcx,r15
   185493df1:	e8 9a 26 23 ff       	call   0x1846c6490
   185493df6:	90                   	nop
   185493df7:	48 8b 85 a8 01 00 00 	mov    rax,QWORD PTR [rbp+0x1a8]
   185493dfe:	48 83 f8 10          	cmp    rax,0x10
   185493e02:	72 38                	jb     0x185493e3c
   185493e04:	48 8b 8d 90 01 00 00 	mov    rcx,QWORD PTR [rbp+0x190]
   185493e0b:	48 8d 50 01          	lea    rdx,[rax+0x1]
   185493e0f:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185493e16:	72 1f                	jb     0x185493e37
   185493e18:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   185493e1c:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   185493e20:	4c 29 c1             	sub    rcx,r8
   185493e23:	48 83 f9 20          	cmp    rcx,0x20
   185493e27:	0f 83 de 0a 00 00    	jae    0x18549490b
   185493e2d:	48 83 c0 28          	add    rax,0x28
   185493e31:	48 89 c2             	mov    rdx,rax
   185493e34:	4c 89 c1             	mov    rcx,r8
   185493e37:	e8 a4 7a 01 02       	call   0x1874ab8e0
   185493e3c:	48 8b 85 80 01 00 00 	mov    rax,QWORD PTR [rbp+0x180]
   185493e43:	48 83 bd 88 01 00 00 	cmp    QWORD PTR [rbp+0x188],0x10
   185493e4a:	10 
   185493e4b:	72 07                	jb     0x185493e54
   185493e4d:	4c 8b bd 70 01 00 00 	mov    r15,QWORD PTR [rbp+0x170]
   185493e54:	48 83 f8 08          	cmp    rax,0x8
   185493e58:	74 5c                	je     0x185493eb6
   185493e5a:	48 83 f8 0d          	cmp    rax,0xd
   185493e5e:	75 69                	jne    0x185493ec9
   185493e60:	48 b8 62 72 61 6e 64 	movabs rax,0x63615f646e617262
   185493e67:	5f 61 63 
   185493e6a:	49 33 07             	xor    rax,QWORD PTR [r15]
   185493e6d:	48 b9 5f 61 63 63 6f 	movabs rcx,0x746e756f6363615f
   185493e74:	75 6e 74 
   185493e77:	49 33 4f 05          	xor    rcx,QWORD PTR [r15+0x5]
   185493e7b:	48 09 c1             	or     rcx,rax
   185493e7e:	75 49                	jne    0x185493ec9
   185493e80:	48 8b 8d c8 02 00 00 	mov    rcx,QWORD PTR [rbp+0x2c8]
   185493e87:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   185493e8a:	48 89 45 58          	mov    QWORD PTR [rbp+0x58],rax
   185493e8e:	48 c7 01 00 00 00 00 	mov    QWORD PTR [rcx],0x0
   185493e95:	48 8d 45 58          	lea    rax,[rbp+0x58]
   185493e99:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   185493e9e:	4c 8d 85 a0 02 00 00 	lea    r8,[rbp+0x2a0]
   185493ea5:	48 89 fa             	mov    rdx,rdi
   185493ea8:	49 89 f1             	mov    r9,rsi
   185493eab:	e8 d0 18 00 00       	call   0x185495780
   185493eb0:	90                   	nop
   185493eb1:	e9 81 09 00 00       	jmp    0x185494837
   185493eb6:	48 b8 65 6d 6f 74 69 	movabs rax,0x6e6f6369746f6d65
   185493ebd:	63 6f 6e 
   185493ec0:	49 39 07             	cmp    QWORD PTR [r15],rax
   185493ec3:	0f 84 e3 01 00 00    	je     0x1854940ac
   185493ec9:	8b 47 20             	mov    eax,DWORD PTR [rdi+0x20]
   185493ecc:	83 f8 31             	cmp    eax,0x31
   185493ecf:	74 3f                	je     0x185493f10
   185493ed1:	83 f8 03             	cmp    eax,0x3
   185493ed4:	0f 85 51 01 00 00    	jne    0x18549402b
   185493eda:	48 8b 8d c8 02 00 00 	mov    rcx,QWORD PTR [rbp+0x2c8]
   185493ee1:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   185493ee4:	48 89 45 68          	mov    QWORD PTR [rbp+0x68],rax
   185493ee8:	48 c7 01 00 00 00 00 	mov    QWORD PTR [rcx],0x0
   185493eef:	48 8d 45 68          	lea    rax,[rbp+0x68]
   185493ef3:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   185493ef8:	4c 8d 85 a0 02 00 00 	lea    r8,[rbp+0x2a0]
   185493eff:	48 89 fa             	mov    rdx,rdi
   185493f02:	49 89 f1             	mov    r9,rsi
   185493f05:	e8 c6 5b 00 00       	call   0x185499ad0
   185493f0a:	90                   	nop
   185493f0b:	e9 27 09 00 00       	jmp    0x185494837
   185493f10:	0f 29 b5 a0 01 00 00 	movaps XMMWORD PTR [rbp+0x1a0],xmm6
   185493f17:	0f 29 b5 90 01 00 00 	movaps XMMWORD PTR [rbp+0x190],xmm6
   185493f1e:	0f 57 c0             	xorps  xmm0,xmm0
   185493f21:	0f 29 85 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm0
   185493f28:	48 c7 85 10 01 00 00 	mov    QWORD PTR [rbp+0x110],0x4
   185493f2f:	04 00 00 00 
   185493f33:	48 c7 85 18 01 00 00 	mov    QWORD PTR [rbp+0x118],0xf
   185493f3a:	0f 00 00 00 
   185493f3e:	c7 85 00 01 00 00 74 	mov    DWORD PTR [rbp+0x100],0x65707974
   185493f45:	79 70 65 
   185493f48:	48 8d 8d 20 02 00 00 	lea    rcx,[rbp+0x220]
   185493f4f:	48 8d 95 a0 02 00 00 	lea    rdx,[rbp+0x2a0]
   185493f56:	4c 8d 85 00 01 00 00 	lea    r8,[rbp+0x100]
   185493f5d:	e8 6e 28 23 ff       	call   0x1846c67d0
   185493f62:	90                   	nop
   185493f63:	48 8d 8d 90 01 00 00 	lea    rcx,[rbp+0x190]
   185493f6a:	48 8d 95 20 02 00 00 	lea    rdx,[rbp+0x220]
   185493f71:	e8 1a 25 23 ff       	call   0x1846c6490
   185493f76:	90                   	nop
   185493f77:	48 8b 85 38 02 00 00 	mov    rax,QWORD PTR [rbp+0x238]
   185493f7e:	48 83 f8 10          	cmp    rax,0x10
   185493f82:	72 38                	jb     0x185493fbc
   185493f84:	48 8b 8d 20 02 00 00 	mov    rcx,QWORD PTR [rbp+0x220]
   185493f8b:	48 8d 50 01          	lea    rdx,[rax+0x1]
   185493f8f:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185493f96:	72 1f                	jb     0x185493fb7
   185493f98:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   185493f9c:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   185493fa0:	4c 29 c1             	sub    rcx,r8
   185493fa3:	48 83 f9 20          	cmp    rcx,0x20
   185493fa7:	0f 83 5e 09 00 00    	jae    0x18549490b
   185493fad:	48 83 c0 28          	add    rax,0x28
   185493fb1:	48 89 c2             	mov    rdx,rax
   185493fb4:	4c 89 c1             	mov    rcx,r8
   185493fb7:	e8 24 79 01 02       	call   0x1874ab8e0
   185493fbc:	48 83 bd a0 01 00 00 	cmp    QWORD PTR [rbp+0x1a0],0x0
   185493fc3:	00 
   185493fc4:	74 1c                	je     0x185493fe2
   185493fc6:	48 8d 8d 90 01 00 00 	lea    rcx,[rbp+0x190]
   185493fcd:	31 d2                	xor    edx,edx
   185493fcf:	e8 8c ab d7 fa       	call   0x18020eb60
   185493fd4:	90                   	nop
   185493fd5:	83 f8 06             	cmp    eax,0x6
   185493fd8:	0f 84 13 01 00 00    	je     0x1854940f1
   185493fde:	85 c0                	test   eax,eax
   185493fe0:	75 13                	jne    0x185493ff5
   185493fe2:	48 8d 15 8f 41 d9 03 	lea    rdx,[rip+0x3d9418f]        # 0x189228178
   185493fe9:	48 8d 8d 70 01 00 00 	lea    rcx,[rbp+0x170]
   185493ff0:	e8 cb 13 eb fa       	call   0x1803453c0
   185493ff5:	48 8b 8d c8 02 00 00 	mov    rcx,QWORD PTR [rbp+0x2c8]
   185493ffc:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   185493fff:	48 89 45 78          	mov    QWORD PTR [rbp+0x78],rax
   185494003:	48 c7 01 00 00 00 00 	mov    QWORD PTR [rcx],0x0
   18549400a:	48 8d 45 78          	lea    rax,[rbp+0x78]
   18549400e:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   185494013:	4c 8d 85 a0 02 00 00 	lea    r8,[rbp+0x2a0]
   18549401a:	48 89 fa             	mov    rdx,rdi
   18549401d:	49 89 f1             	mov    r9,rsi
   185494020:	e8 bb 8a 00 00       	call   0x18549cae0
   185494025:	90                   	nop
   185494026:	e9 f7 00 00 00       	jmp    0x185494122
   18549402b:	0f 29 b5 50 01 00 00 	movaps XMMWORD PTR [rbp+0x150],xmm6
   185494032:	83 f8 01             	cmp    eax,0x1
   185494035:	0f 85 a7 00 00 00    	jne    0x1854940e2
   18549403b:	0f 29 b5 90 01 00 00 	movaps XMMWORD PTR [rbp+0x190],xmm6
   185494042:	48 8d 8d 90 01 00 00 	lea    rcx,[rbp+0x190]
   185494049:	e8 22 0c 26 fb       	call   0x1806f4c70
   18549404e:	90                   	nop
   18549404f:	48 8b 85 90 01 00 00 	mov    rax,QWORD PTR [rbp+0x190]
   185494056:	c7 80 18 01 00 00 01 	mov    DWORD PTR [rax+0x118],0x1
   18549405d:	00 00 00 
   185494060:	4c 8d b8 58 07 00 00 	lea    r15,[rax+0x758]
   185494067:	4d 39 f7             	cmp    r15,r14
   18549406a:	0f 84 23 01 00 00    	je     0x185494193
   185494070:	4c 8b a5 b0 02 00 00 	mov    r12,QWORD PTR [rbp+0x2b0]
   185494077:	48 83 bd b8 02 00 00 	cmp    QWORD PTR [rbp+0x2b8],0x10
   18549407e:	10 
   18549407f:	72 07                	jb     0x185494088
   185494081:	4c 8b b5 a0 02 00 00 	mov    r14,QWORD PTR [rbp+0x2a0]
   185494088:	48 8b 88 70 07 00 00 	mov    rcx,QWORD PTR [rax+0x770]
   18549408f:	49 39 cc             	cmp    r12,rcx
   185494092:	0f 86 d8 00 00 00    	jbe    0x185494170
   185494098:	4c 89 f9             	mov    rcx,r15
   18549409b:	4c 89 e2             	mov    rdx,r12
   18549409e:	4d 89 f1             	mov    r9,r14
   1854940a1:	e8 aa a0 ba fa       	call   0x18003e150
   1854940a6:	90                   	nop
   1854940a7:	e9 e7 00 00 00       	jmp    0x185494193
   1854940ac:	48 8b 8d c8 02 00 00 	mov    rcx,QWORD PTR [rbp+0x2c8]
   1854940b3:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   1854940b6:	48 89 45 60          	mov    QWORD PTR [rbp+0x60],rax
   1854940ba:	48 c7 01 00 00 00 00 	mov    QWORD PTR [rcx],0x0
   1854940c1:	48 8d 45 60          	lea    rax,[rbp+0x60]
   1854940c5:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1854940ca:	4c 8d 85 a0 02 00 00 	lea    r8,[rbp+0x2a0]
   1854940d1:	48 89 fa             	mov    rdx,rdi
   1854940d4:	49 89 f1             	mov    r9,rsi
   1854940d7:	e8 f4 32 00 00       	call   0x1854973d0
   1854940dc:	90                   	nop
   1854940dd:	e9 55 07 00 00       	jmp    0x185494837
   1854940e2:	0f 57 c0             	xorps  xmm0,xmm0
   1854940e5:	0f 29 85 50 01 00 00 	movaps XMMWORD PTR [rbp+0x150],xmm0
   1854940ec:	e9 09 03 00 00       	jmp    0x1854943fa
   1854940f1:	48 8b 8d c8 02 00 00 	mov    rcx,QWORD PTR [rbp+0x2c8]
   1854940f8:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   1854940fb:	48 89 45 70          	mov    QWORD PTR [rbp+0x70],rax
   1854940ff:	48 c7 01 00 00 00 00 	mov    QWORD PTR [rcx],0x0
   185494106:	48 8d 45 70          	lea    rax,[rbp+0x70]
   18549410a:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   18549410f:	4c 8d 85 a0 02 00 00 	lea    r8,[rbp+0x2a0]
   185494116:	48 89 fa             	mov    rdx,rdi
   185494119:	49 89 f1             	mov    r9,rsi
   18549411c:	e8 3f 73 00 00       	call   0x18549b460
   185494121:	90                   	nop
   185494122:	48 8b 85 a8 01 00 00 	mov    rax,QWORD PTR [rbp+0x1a8]
   185494129:	48 83 f8 10          	cmp    rax,0x10
   18549412d:	0f 82 04 07 00 00    	jb     0x185494837
   185494133:	48 8b 8d 90 01 00 00 	mov    rcx,QWORD PTR [rbp+0x190]
   18549413a:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18549413e:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185494145:	72 1f                	jb     0x185494166
   185494147:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18549414b:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18549414f:	4c 29 c1             	sub    rcx,r8
   185494152:	48 83 f9 20          	cmp    rcx,0x20
   185494156:	0f 83 af 07 00 00    	jae    0x18549490b
   18549415c:	48 83 c0 28          	add    rax,0x28
   185494160:	48 89 c2             	mov    rdx,rax
   185494163:	4c 89 c1             	mov    rcx,r8
   185494166:	e8 75 77 01 02       	call   0x1874ab8e0
   18549416b:	e9 c7 06 00 00       	jmp    0x185494837
   185494170:	48 83 f9 10          	cmp    rcx,0x10
   185494174:	72 03                	jb     0x185494179
   185494176:	4d 8b 3f             	mov    r15,QWORD PTR [r15]
   185494179:	4c 89 a0 68 07 00 00 	mov    QWORD PTR [rax+0x768],r12
   185494180:	4c 89 f9             	mov    rcx,r15
   185494183:	4c 89 f2             	mov    rdx,r14
   185494186:	4d 89 e0             	mov    r8,r12
   185494189:	e8 c2 fe 0a 02       	call   0x187544050
   18549418e:	43 c6 04 27 00       	mov    BYTE PTR [r15+r12*1],0x0
   185494193:	48 8b 85 90 01 00 00 	mov    rax,QWORD PTR [rbp+0x190]
   18549419a:	4c 8d b0 b0 00 00 00 	lea    r14,[rax+0xb0]
   1854941a1:	49 39 fe             	cmp    r14,rdi
   1854941a4:	74 55                	je     0x1854941fb
   1854941a6:	4c 8b 7f 10          	mov    r15,QWORD PTR [rdi+0x10]
   1854941aa:	48 83 7f 18 10       	cmp    QWORD PTR [rdi+0x18],0x10
   1854941af:	49 89 f9             	mov    r9,rdi
   1854941b2:	72 03                	jb     0x1854941b7
   1854941b4:	4c 8b 0f             	mov    r9,QWORD PTR [rdi]
   1854941b7:	48 8b 88 c8 00 00 00 	mov    rcx,QWORD PTR [rax+0xc8]
   1854941be:	49 39 cf             	cmp    r15,rcx
   1854941c1:	76 0e                	jbe    0x1854941d1
   1854941c3:	4c 89 f1             	mov    rcx,r14
   1854941c6:	4c 89 fa             	mov    rdx,r15
   1854941c9:	e8 82 9f ba fa       	call   0x18003e150
   1854941ce:	90                   	nop
   1854941cf:	eb 23                	jmp    0x1854941f4
   1854941d1:	48 83 f9 10          	cmp    rcx,0x10
   1854941d5:	72 03                	jb     0x1854941da
   1854941d7:	4d 8b 36             	mov    r14,QWORD PTR [r14]
   1854941da:	4c 89 b8 c0 00 00 00 	mov    QWORD PTR [rax+0xc0],r15
   1854941e1:	4c 89 f1             	mov    rcx,r14
   1854941e4:	4c 89 ca             	mov    rdx,r9
   1854941e7:	4d 89 f8             	mov    r8,r15
   1854941ea:	e8 61 fe 0a 02       	call   0x187544050
   1854941ef:	43 c6 04 3e 00       	mov    BYTE PTR [r14+r15*1],0x0
   1854941f4:	48 8b 85 90 01 00 00 	mov    rax,QWORD PTR [rbp+0x190]
   1854941fb:	48 89 85 50 01 00 00 	mov    QWORD PTR [rbp+0x150],rax
   185494202:	48 8b 8d 98 01 00 00 	mov    rcx,QWORD PTR [rbp+0x198]
   185494209:	48 89 8d 58 01 00 00 	mov    QWORD PTR [rbp+0x158],rcx
   185494210:	48 85 c0             	test   rax,rax
   185494213:	0f 84 e1 01 00 00    	je     0x1854943fa
   185494219:	0f 29 b5 90 00 00 00 	movaps XMMWORD PTR [rbp+0x90],xmm6
   185494220:	48 8d 8d 20 02 00 00 	lea    rcx,[rbp+0x220]
   185494227:	e8 f4 2f bb fa       	call   0x180047220
   18549422c:	90                   	nop
   18549422d:	48 8b 8d 20 02 00 00 	mov    rcx,QWORD PTR [rbp+0x220]
   185494234:	48 8d 95 90 01 00 00 	lea    rdx,[rbp+0x190]
   18549423b:	e8 00 85 ed fa       	call   0x18036c740
   185494240:	90                   	nop
   185494241:	48 8b 8d 90 01 00 00 	mov    rcx,QWORD PTR [rbp+0x190]
   185494248:	48 8d 95 90 00 00 00 	lea    rdx,[rbp+0x90]
   18549424f:	e8 3c 0b 26 fb       	call   0x1806f4d90
   185494254:	90                   	nop
   185494255:	48 8d 8d 90 01 00 00 	lea    rcx,[rbp+0x190]
   18549425c:	e8 ff dd b6 fa       	call   0x180002060
   185494261:	48 8d 8d 20 02 00 00 	lea    rcx,[rbp+0x220]
   185494268:	e8 f3 dd b6 fa       	call   0x180002060
   18549426d:	48 83 bd 90 00 00 00 	cmp    QWORD PTR [rbp+0x90],0x0
   185494274:	00 
   185494275:	0f 84 26 03 00 00    	je     0x1854945a1
   18549427b:	b9 20 00 00 00       	mov    ecx,0x20
   185494280:	e8 17 76 01 02       	call   0x1874ab89c
   185494285:	90                   	nop
   185494286:	48 b9 01 00 00 00 01 	movabs rcx,0x100000001
   18549428d:	00 00 00 
   185494290:	48 89 48 08          	mov    QWORD PTR [rax+0x8],rcx
   185494294:	48 8d 0d 6d e6 36 04 	lea    rcx,[rip+0x436e66d]        # 0x189802908
   18549429b:	48 89 08             	mov    QWORD PTR [rax],rcx
   18549429e:	0f 57 c0             	xorps  xmm0,xmm0
   1854942a1:	0f 11 40 10          	movups XMMWORD PTR [rax+0x10],xmm0
   1854942a5:	48 89 85 68 01 00 00 	mov    QWORD PTR [rbp+0x168],rax
   1854942ac:	48 8d 48 18          	lea    rcx,[rax+0x18]
   1854942b0:	48 8b 95 c8 02 00 00 	mov    rdx,QWORD PTR [rbp+0x2c8]
   1854942b7:	e8 94 2c c7 fa       	call   0x180106f50
   1854942bc:	90                   	nop
   1854942bd:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   1854942c4:	e8 57 2f bb fa       	call   0x180047220
   1854942c9:	90                   	nop
   1854942ca:	48 8b 8d 00 01 00 00 	mov    rcx,QWORD PTR [rbp+0x100]
   1854942d1:	48 8d 95 20 02 00 00 	lea    rdx,[rbp+0x220]
   1854942d8:	e8 63 84 ed fa       	call   0x18036c740
   1854942dd:	90                   	nop
   1854942de:	48 8b 8d 20 02 00 00 	mov    rcx,QWORD PTR [rbp+0x220]
   1854942e5:	48 8d 95 90 01 00 00 	lea    rdx,[rbp+0x190]
   1854942ec:	e8 0f ba 9f fb       	call   0x180e8fd00
   1854942f1:	90                   	nop
   1854942f2:	48 8b 95 68 01 00 00 	mov    rdx,QWORD PTR [rbp+0x168]
   1854942f9:	48 8d 5a 10          	lea    rbx,[rdx+0x10]
   1854942fd:	48 8b 8d 90 01 00 00 	mov    rcx,QWORD PTR [rbp+0x190]
   185494304:	48 85 d2             	test   rdx,rdx
   185494307:	74 04                	je     0x18549430d
   185494309:	f0 ff 42 08          	lock inc DWORD PTR [rdx+0x8]
   18549430d:	48 8d 05 84 e6 36 04 	lea    rax,[rip+0x436e684]        # 0x189802998
   185494314:	48 89 45 08          	mov    QWORD PTR [rbp+0x8],rax
   185494318:	48 89 5d 10          	mov    QWORD PTR [rbp+0x10],rbx
   18549431c:	48 89 55 18          	mov    QWORD PTR [rbp+0x18],rdx
   185494320:	48 8d 55 08          	lea    rdx,[rbp+0x8]
   185494324:	48 89 55 40          	mov    QWORD PTR [rbp+0x40],rdx
   185494328:	e8 d3 93 92 fd       	call   0x182dbd700
   18549432d:	90                   	nop
   18549432e:	31 c9                	xor    ecx,ecx
   185494330:	e8 eb ed bb fa       	call   0x180053120
   185494335:	48 8d 8d 90 01 00 00 	lea    rcx,[rbp+0x190]
   18549433c:	e8 1f dd b6 fa       	call   0x180002060
   185494341:	48 8d 8d 20 02 00 00 	lea    rcx,[rbp+0x220]
   185494348:	e8 13 dd b6 fa       	call   0x180002060
   18549434d:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   185494354:	e8 07 dd b6 fa       	call   0x180002060
   185494359:	0f 29 b5 30 02 00 00 	movaps XMMWORD PTR [rbp+0x230],xmm6
   185494360:	0f 29 b5 20 02 00 00 	movaps XMMWORD PTR [rbp+0x220],xmm6
   185494367:	48 8d 8d 20 02 00 00 	lea    rcx,[rbp+0x220]
   18549436e:	48 89 fa             	mov    rdx,rdi
   185494371:	e8 b6 7a 01 02       	call   0x1874abe2c
   185494376:	90                   	nop
   185494377:	44 8b 77 20          	mov    r14d,DWORD PTR [rdi+0x20]
   18549437b:	e8 90 19 bb fa       	call   0x180045d10
   185494380:	90                   	nop
   185494381:	48 8d 95 b0 00 00 00 	lea    rdx,[rbp+0xb0]
   185494388:	48 89 c1             	mov    rcx,rax
   18549438b:	e8 80 2f bb fa       	call   0x180047310
   185494390:	90                   	nop
   185494391:	48 8b bd b0 00 00 00 	mov    rdi,QWORD PTR [rbp+0xb0]
   185494398:	0f 57 c0             	xorps  xmm0,xmm0
   18549439b:	0f 29 85 90 01 00 00 	movaps XMMWORD PTR [rbp+0x190],xmm0
   1854943a2:	48 8b 85 68 01 00 00 	mov    rax,QWORD PTR [rbp+0x168]
   1854943a9:	48 85 c0             	test   rax,rax
   1854943ac:	74 04                	je     0x1854943b2
   1854943ae:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   1854943b2:	48 89 9d 90 01 00 00 	mov    QWORD PTR [rbp+0x190],rbx
   1854943b9:	48 89 85 98 01 00 00 	mov    QWORD PTR [rbp+0x198],rax
   1854943c0:	48 8d 8d a0 01 00 00 	lea    rcx,[rbp+0x1a0]
   1854943c7:	48 89 f2             	mov    rdx,rsi
   1854943ca:	e8 5d 7a 01 02       	call   0x1874abe2c
   1854943cf:	90                   	nop
   1854943d0:	0f 57 c0             	xorps  xmm0,xmm0
   1854943d3:	0f 29 85 c0 01 00 00 	movaps XMMWORD PTR [rbp+0x1c0],xmm0
   1854943da:	48 8b 85 58 01 00 00 	mov    rax,QWORD PTR [rbp+0x158]
   1854943e1:	48 85 c0             	test   rax,rax
   1854943e4:	0f 84 13 03 00 00    	je     0x1854946fd
   1854943ea:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   1854943ee:	48 8b 85 58 01 00 00 	mov    rax,QWORD PTR [rbp+0x158]
   1854943f5:	e9 05 03 00 00       	jmp    0x1854946ff
   1854943fa:	b9 04 00 00 00       	mov    ecx,0x4
   1854943ff:	e8 dc 89 bd fa       	call   0x18006cde0
   185494404:	85 c0                	test   eax,eax
   185494406:	0f 84 09 01 00 00    	je     0x185494515
   18549440c:	48 8d 9d 90 00 00 00 	lea    rbx,[rbp+0x90]
   185494413:	48 89 d9             	mov    rcx,rbx
   185494416:	e8 f5 8a bd fa       	call   0x18006cf10
   18549441b:	90                   	nop
   18549441c:	48 83 bd a8 00 00 00 	cmp    QWORD PTR [rbp+0xa8],0x10
   185494423:	10 
   185494424:	72 07                	jb     0x18549442d
   185494426:	48 8b 9d 90 00 00 00 	mov    rbx,QWORD PTR [rbp+0x90]
   18549442d:	48 8d 05 ec fe 36 04 	lea    rax,[rip+0x436feec]        # 0x189804320
   185494434:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   185494439:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   185494440:	00 00 
   185494442:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   185494447:	c7 44 24 28 53 01 00 	mov    DWORD PTR [rsp+0x28],0x153
   18549444e:	00 
   18549444f:	4c 8d 0d 5a f9 36 04 	lea    r9,[rip+0x436f95a]        # 0x189803db0
   185494456:	48 8d 8d 90 01 00 00 	lea    rcx,[rbp+0x190]
   18549445d:	ba 04 00 00 00       	mov    edx,0x4
   185494462:	49 89 d8             	mov    r8,rbx
   185494465:	e8 06 8e bd fa       	call   0x18006d270
   18549446a:	90                   	nop
   18549446b:	8b 57 20             	mov    edx,DWORD PTR [rdi+0x20]
   18549446e:	48 8d 9d 00 01 00 00 	lea    rbx,[rbp+0x100]
   185494475:	48 89 d9             	mov    rcx,rbx
   185494478:	41 b0 0a             	mov    r8b,0xa
   18549447b:	e8 e0 14 d1 fa       	call   0x1801a5960
   185494480:	90                   	nop
   185494481:	48 83 7e 18 10       	cmp    QWORD PTR [rsi+0x18],0x10
   185494486:	72 03                	jb     0x18549448b
   185494488:	48 8b 36             	mov    rsi,QWORD PTR [rsi]
   18549448b:	48 89 b5 b0 00 00 00 	mov    QWORD PTR [rbp+0xb0],rsi
   185494492:	c6 85 b8 00 00 00 00 	mov    BYTE PTR [rbp+0xb8],0x0
   185494499:	0f 57 c0             	xorps  xmm0,xmm0
   18549449c:	0f 11 85 90 02 00 00 	movups XMMWORD PTR [rbp+0x290],xmm0
   1854944a3:	0f 11 85 80 02 00 00 	movups XMMWORD PTR [rbp+0x280],xmm0
   1854944aa:	0f 11 85 70 02 00 00 	movups XMMWORD PTR [rbp+0x270],xmm0
   1854944b1:	0f 11 85 60 02 00 00 	movups XMMWORD PTR [rbp+0x260],xmm0
   1854944b8:	0f 11 85 50 02 00 00 	movups XMMWORD PTR [rbp+0x250],xmm0
   1854944bf:	0f 11 85 40 02 00 00 	movups XMMWORD PTR [rbp+0x240],xmm0
   1854944c6:	0f 11 85 30 02 00 00 	movups XMMWORD PTR [rbp+0x230],xmm0
   1854944cd:	48 8d 85 b0 00 00 00 	lea    rax,[rbp+0xb0]
   1854944d4:	48 89 85 20 02 00 00 	mov    QWORD PTR [rbp+0x220],rax
   1854944db:	48 89 9d 28 02 00 00 	mov    QWORD PTR [rbp+0x228],rbx
   1854944e2:	48 8d 15 ef 00 37 04 	lea    rdx,[rip+0x43700ef]        # 0x1898045d8
   1854944e9:	48 8d 8d 90 01 00 00 	lea    rcx,[rbp+0x190]
   1854944f0:	4c 8d 85 20 02 00 00 	lea    r8,[rbp+0x220]
   1854944f7:	e8 14 93 bd fa       	call   0x18006d810
   1854944fc:	90                   	nop
   1854944fd:	48 8d 8d 90 01 00 00 	lea    rcx,[rbp+0x190]
   185494504:	e8 67 8e bd fa       	call   0x18006d370
   185494509:	48 8d 8d 90 00 00 00 	lea    rcx,[rbp+0x90]
   185494510:	e8 fb da b6 fa       	call   0x180002010
   185494515:	8b 57 20             	mov    edx,DWORD PTR [rdi+0x20]
   185494518:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   18549451f:	e8 cc 65 c0 fa       	call   0x18009aaf0
   185494524:	90                   	nop
   185494525:	48 8d 15 2c e2 36 04 	lea    rdx,[rip+0x436e22c]        # 0x189802758
   18549452c:	48 8d 8d 20 02 00 00 	lea    rcx,[rbp+0x220]
   185494533:	4c 8d 85 00 01 00 00 	lea    r8,[rbp+0x100]
   18549453a:	e8 41 78 c8 fb       	call   0x18111bd80
   18549453f:	90                   	nop
   185494540:	48 8d 8d 90 01 00 00 	lea    rcx,[rbp+0x190]
   185494547:	48 8d 95 20 02 00 00 	lea    rdx,[rbp+0x220]
   18549454e:	e8 5d 11 00 00       	call   0x1854956b0
   185494553:	90                   	nop
   185494554:	48 8d 95 90 01 00 00 	lea    rdx,[rbp+0x190]
   18549455b:	48 8b 8d c8 02 00 00 	mov    rcx,QWORD PTR [rbp+0x2c8]
   185494562:	e8 39 c7 92 fd       	call   0x182dc0ca0
   185494567:	90                   	nop
   185494568:	48 8d 8d 90 01 00 00 	lea    rcx,[rbp+0x190]
   18549456f:	e8 ac 11 00 00       	call   0x185495720
   185494574:	48 8d 8d 20 02 00 00 	lea    rcx,[rbp+0x220]
   18549457b:	e8 90 da b6 fa       	call   0x180002010
   185494580:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   185494587:	e8 84 da b6 fa       	call   0x180002010
   18549458c:	48 8b b5 58 01 00 00 	mov    rsi,QWORD PTR [rbp+0x158]
   185494593:	48 85 f6             	test   rsi,rsi
   185494596:	0f 85 7e 02 00 00    	jne    0x18549481a
   18549459c:	e9 96 02 00 00       	jmp    0x185494837
   1854945a1:	b9 04 00 00 00       	mov    ecx,0x4
   1854945a6:	e8 35 88 bd fa       	call   0x18006cde0
   1854945ab:	85 c0                	test   eax,eax
   1854945ad:	0f 84 f1 00 00 00    	je     0x1854946a4
   1854945b3:	48 8d bd b0 00 00 00 	lea    rdi,[rbp+0xb0]
   1854945ba:	48 89 f9             	mov    rcx,rdi
   1854945bd:	e8 4e 89 bd fa       	call   0x18006cf10
   1854945c2:	90                   	nop
   1854945c3:	48 83 bd c8 00 00 00 	cmp    QWORD PTR [rbp+0xc8],0x10
   1854945ca:	10 
   1854945cb:	72 07                	jb     0x1854945d4
   1854945cd:	48 8b bd b0 00 00 00 	mov    rdi,QWORD PTR [rbp+0xb0]
   1854945d4:	48 8d 05 45 fd 36 04 	lea    rax,[rip+0x436fd45]        # 0x189804320
   1854945db:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1854945e0:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   1854945e7:	00 00 
   1854945e9:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   1854945ee:	c7 44 24 28 5b 01 00 	mov    DWORD PTR [rsp+0x28],0x15b
   1854945f5:	00 
   1854945f6:	4c 8d 0d b3 f7 36 04 	lea    r9,[rip+0x436f7b3]        # 0x189803db0
   1854945fd:	48 8d 8d 90 01 00 00 	lea    rcx,[rbp+0x190]
   185494604:	ba 04 00 00 00       	mov    edx,0x4
   185494609:	49 89 f8             	mov    r8,rdi
   18549460c:	e8 5f 8c bd fa       	call   0x18006d270
   185494611:	90                   	nop
   185494612:	48 83 7e 18 10       	cmp    QWORD PTR [rsi+0x18],0x10
   185494617:	72 03                	jb     0x18549461c
   185494619:	48 8b 36             	mov    rsi,QWORD PTR [rsi]
   18549461c:	48 89 b5 00 01 00 00 	mov    QWORD PTR [rbp+0x100],rsi
   185494623:	c6 85 08 01 00 00 00 	mov    BYTE PTR [rbp+0x108],0x0
   18549462a:	0f 57 c0             	xorps  xmm0,xmm0
   18549462d:	0f 11 85 88 02 00 00 	movups XMMWORD PTR [rbp+0x288],xmm0
   185494634:	0f 11 85 78 02 00 00 	movups XMMWORD PTR [rbp+0x278],xmm0
   18549463b:	0f 11 85 68 02 00 00 	movups XMMWORD PTR [rbp+0x268],xmm0
   185494642:	0f 11 85 58 02 00 00 	movups XMMWORD PTR [rbp+0x258],xmm0
   185494649:	0f 11 85 48 02 00 00 	movups XMMWORD PTR [rbp+0x248],xmm0
   185494650:	0f 11 85 38 02 00 00 	movups XMMWORD PTR [rbp+0x238],xmm0
   185494657:	0f 11 85 28 02 00 00 	movups XMMWORD PTR [rbp+0x228],xmm0
   18549465e:	48 c7 85 98 02 00 00 	mov    QWORD PTR [rbp+0x298],0x0
   185494665:	00 00 00 00 
   185494669:	48 89 9d 20 02 00 00 	mov    QWORD PTR [rbp+0x220],rbx
   185494670:	48 8d 15 d9 b6 36 04 	lea    rdx,[rip+0x436b6d9]        # 0x1897ffd50
   185494677:	48 8d 8d 90 01 00 00 	lea    rcx,[rbp+0x190]
   18549467e:	4c 8d 85 20 02 00 00 	lea    r8,[rbp+0x220]
   185494685:	e8 86 91 bd fa       	call   0x18006d810
   18549468a:	90                   	nop
   18549468b:	48 8d 8d 90 01 00 00 	lea    rcx,[rbp+0x190]
   185494692:	e8 d9 8c bd fa       	call   0x18006d370
   185494697:	48 8d 8d b0 00 00 00 	lea    rcx,[rbp+0xb0]
   18549469e:	e8 6d d9 b6 fa       	call   0x180002010
   1854946a3:	90                   	nop
   1854946a4:	48 8d 15 cd e0 36 04 	lea    rdx,[rip+0x436e0cd]        # 0x189802778
   1854946ab:	48 8d 8d 20 02 00 00 	lea    rcx,[rbp+0x220]
   1854946b2:	e8 19 44 bf fa       	call   0x180088ad0
   1854946b7:	90                   	nop
   1854946b8:	48 8d 8d 90 01 00 00 	lea    rcx,[rbp+0x190]
   1854946bf:	48 8d 95 20 02 00 00 	lea    rdx,[rbp+0x220]
   1854946c6:	e8 e5 0f 00 00       	call   0x1854956b0
   1854946cb:	90                   	nop
   1854946cc:	48 8d 95 90 01 00 00 	lea    rdx,[rbp+0x190]
   1854946d3:	48 8b 8d c8 02 00 00 	mov    rcx,QWORD PTR [rbp+0x2c8]
   1854946da:	e8 c1 c5 92 fd       	call   0x182dc0ca0
   1854946df:	90                   	nop
   1854946e0:	48 8d 8d 90 01 00 00 	lea    rcx,[rbp+0x190]
   1854946e7:	e8 34 10 00 00       	call   0x185495720
   1854946ec:	48 8d 8d 20 02 00 00 	lea    rcx,[rbp+0x220]
   1854946f3:	e8 18 d9 b6 fa       	call   0x180002010
   1854946f8:	e9 05 01 00 00       	jmp    0x185494802
   1854946fd:	31 c0                	xor    eax,eax
   1854946ff:	48 8b 8d 50 01 00 00 	mov    rcx,QWORD PTR [rbp+0x150]
   185494706:	48 89 8d c0 01 00 00 	mov    QWORD PTR [rbp+0x1c0],rcx
   18549470d:	48 89 85 c8 01 00 00 	mov    QWORD PTR [rbp+0x1c8],rax
   185494714:	48 8d 8d d0 01 00 00 	lea    rcx,[rbp+0x1d0]
   18549471b:	48 8d 95 20 02 00 00 	lea    rdx,[rbp+0x220]
   185494722:	e8 05 77 01 02       	call   0x1874abe2c
   185494727:	90                   	nop
   185494728:	44 89 b5 f0 01 00 00 	mov    DWORD PTR [rbp+0x1f0],r14d
   18549472f:	0f 57 c0             	xorps  xmm0,xmm0
   185494732:	0f 11 85 f8 01 00 00 	movups XMMWORD PTR [rbp+0x1f8],xmm0
   185494739:	48 8b 85 98 00 00 00 	mov    rax,QWORD PTR [rbp+0x98]
   185494740:	48 85 c0             	test   rax,rax
   185494743:	74 0d                	je     0x185494752
   185494745:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   185494749:	48 8b 85 98 00 00 00 	mov    rax,QWORD PTR [rbp+0x98]
   185494750:	eb 02                	jmp    0x185494754
   185494752:	31 c0                	xor    eax,eax
   185494754:	48 8b 8d 90 00 00 00 	mov    rcx,QWORD PTR [rbp+0x90]
   18549475b:	48 89 8d f8 01 00 00 	mov    QWORD PTR [rbp+0x1f8],rcx
   185494762:	48 89 85 00 02 00 00 	mov    QWORD PTR [rbp+0x200],rax
   185494769:	48 8d 4d c8          	lea    rcx,[rbp-0x38]
   18549476d:	48 8d 95 90 01 00 00 	lea    rdx,[rbp+0x190]
   185494774:	e8 97 f6 00 00       	call   0x1854a3e10
   185494779:	90                   	nop
   18549477a:	c6 85 d7 02 00 00 01 	mov    BYTE PTR [rbp+0x2d7],0x1
   185494781:	48 8d 15 28 2d 36 04 	lea    rdx,[rip+0x4362d28]        # 0x1897f74b0
   185494788:	4c 8d 05 21 f6 36 04 	lea    r8,[rip+0x436f621]        # 0x189803db0
   18549478f:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   185494796:	41 b9 77 01 00 00    	mov    r9d,0x177
   18549479c:	e8 5f 5d d0 fa       	call   0x18019a500
   1854947a1:	90                   	nop
   1854947a2:	c6 85 d7 02 00 00 00 	mov    BYTE PTR [rbp+0x2d7],0x0
   1854947a9:	c7 44 24 20 01 00 00 	mov    DWORD PTR [rsp+0x20],0x1
   1854947b0:	00 
   1854947b1:	48 8d 55 48          	lea    rdx,[rbp+0x48]
   1854947b5:	4c 8d 85 00 01 00 00 	lea    r8,[rbp+0x100]
   1854947bc:	4c 8d 4d c8          	lea    r9,[rbp-0x38]
   1854947c0:	48 89 f9             	mov    rcx,rdi
   1854947c3:	e8 48 68 e6 fa       	call   0x1802fb010
   1854947c8:	90                   	nop
   1854947c9:	48 8d 4d 48          	lea    rcx,[rbp+0x48]
   1854947cd:	e8 8e d8 b6 fa       	call   0x180002060
   1854947d2:	48 8d 8d 90 01 00 00 	lea    rcx,[rbp+0x190]
   1854947d9:	e8 42 f8 00 00       	call   0x1854a4020
   1854947de:	48 8d 8d b0 00 00 00 	lea    rcx,[rbp+0xb0]
   1854947e5:	e8 76 d8 b6 fa       	call   0x180002060
   1854947ea:	48 8d 8d 20 02 00 00 	lea    rcx,[rbp+0x220]
   1854947f1:	e8 1a d8 b6 fa       	call   0x180002010
   1854947f6:	48 8b 8d 68 01 00 00 	mov    rcx,QWORD PTR [rbp+0x168]
   1854947fd:	e8 1e e9 bb fa       	call   0x180053120
   185494802:	48 8d 8d 90 00 00 00 	lea    rcx,[rbp+0x90]
   185494809:	e8 52 d8 b6 fa       	call   0x180002060
   18549480e:	48 8b b5 58 01 00 00 	mov    rsi,QWORD PTR [rbp+0x158]
   185494815:	48 85 f6             	test   rsi,rsi
   185494818:	74 1d                	je     0x185494837
   18549481a:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   18549481e:	75 17                	jne    0x185494837
   185494820:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   185494823:	48 89 f1             	mov    rcx,rsi
   185494826:	ff 10                	call   QWORD PTR [rax]
   185494828:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   18549482c:	75 09                	jne    0x185494837
   18549482e:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   185494831:	48 89 f1             	mov    rcx,rsi
   185494834:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185494837:	48 8b 85 88 01 00 00 	mov    rax,QWORD PTR [rbp+0x188]
   18549483e:	48 83 f8 10          	cmp    rax,0x10
   185494842:	72 38                	jb     0x18549487c
   185494844:	48 8b 8d 70 01 00 00 	mov    rcx,QWORD PTR [rbp+0x170]
   18549484b:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18549484f:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185494856:	72 1f                	jb     0x185494877
   185494858:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18549485c:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   185494860:	4c 29 c1             	sub    rcx,r8
   185494863:	48 83 f9 20          	cmp    rcx,0x20
   185494867:	0f 83 9e 00 00 00    	jae    0x18549490b
   18549486d:	48 83 c0 28          	add    rax,0x28
   185494871:	48 89 c2             	mov    rdx,rax
   185494874:	4c 89 c1             	mov    rcx,r8
   185494877:	e8 64 70 01 02       	call   0x1874ab8e0
   18549487c:	48 8b 85 b8 02 00 00 	mov    rax,QWORD PTR [rbp+0x2b8]
   185494883:	48 83 f8 10          	cmp    rax,0x10
   185494887:	72 34                	jb     0x1854948bd
   185494889:	48 8b 8d a0 02 00 00 	mov    rcx,QWORD PTR [rbp+0x2a0]
   185494890:	48 8d 50 01          	lea    rdx,[rax+0x1]
   185494894:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18549489b:	72 1b                	jb     0x1854948b8
   18549489d:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1854948a1:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1854948a5:	4c 29 c1             	sub    rcx,r8
   1854948a8:	48 83 f9 20          	cmp    rcx,0x20
   1854948ac:	73 5d                	jae    0x18549490b
   1854948ae:	48 83 c0 28          	add    rax,0x28
   1854948b2:	48 89 c2             	mov    rdx,rax
   1854948b5:	4c 89 c1             	mov    rcx,r8
   1854948b8:	e8 23 70 01 02       	call   0x1874ab8e0
   1854948bd:	48 8b b5 88 00 00 00 	mov    rsi,QWORD PTR [rbp+0x88]
   1854948c4:	48 85 f6             	test   rsi,rsi
   1854948c7:	74 1d                	je     0x1854948e6
   1854948c9:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   1854948cd:	75 17                	jne    0x1854948e6
   1854948cf:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1854948d2:	48 89 f1             	mov    rcx,rsi
   1854948d5:	ff 10                	call   QWORD PTR [rax]
   1854948d7:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   1854948db:	75 09                	jne    0x1854948e6
   1854948dd:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1854948e0:	48 89 f1             	mov    rcx,rsi
   1854948e3:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1854948e6:	48 8b 8d c8 02 00 00 	mov    rcx,QWORD PTR [rbp+0x2c8]
   1854948ed:	e8 5e 27 c7 fa       	call   0x180107050
   1854948f2:	0f 28 b5 e0 02 00 00 	movaps xmm6,XMMWORD PTR [rbp+0x2e0]
   1854948f9:	48 81 c4 70 03 00 00 	add    rsp,0x370
   185494900:	5b                   	pop    rbx
   185494901:	5f                   	pop    rdi
   185494902:	5e                   	pop    rsi
   185494903:	41 5c                	pop    r12
   185494905:	41 5e                	pop    r14
   185494907:	41 5f                	pop    r15
   185494909:	5d                   	pop    rbp
   18549490a:	c3                   	ret
   18549490b:	e8 7c 8a 07 02       	call   0x18750d38c
   185494910:	cc                   	int3
