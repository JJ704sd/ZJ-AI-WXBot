
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

00000001816e64a0 <.text+0x16e54a0>:
   1816e64a0:	55                   	push   rbp
   1816e64a1:	41 57                	push   r15
   1816e64a3:	41 56                	push   r14
   1816e64a5:	41 55                	push   r13
   1816e64a7:	41 54                	push   r12
   1816e64a9:	56                   	push   rsi
   1816e64aa:	57                   	push   rdi
   1816e64ab:	53                   	push   rbx
   1816e64ac:	48 81 ec 28 01 00 00 	sub    rsp,0x128
   1816e64b3:	48 8d ac 24 80 00 00 	lea    rbp,[rsp+0x80]
   1816e64ba:	00 
   1816e64bb:	0f 29 b5 90 00 00 00 	movaps XMMWORD PTR [rbp+0x90],xmm6
   1816e64c2:	48 c7 85 88 00 00 00 	mov    QWORD PTR [rbp+0x88],0xfffffffffffffffe
   1816e64c9:	fe ff ff ff 
   1816e64cd:	4c 89 c6             	mov    rsi,r8
   1816e64d0:	49 89 d6             	mov    r14,rdx
   1816e64d3:	0f 28 35 d6 f6 65 07 	movaps xmm6,XMMWORD PTR [rip+0x765f6d6]        # 0x188d45bb0
   1816e64da:	0f 29 75 70          	movaps XMMWORD PTR [rbp+0x70],xmm6
   1816e64de:	48 8d 4d 70          	lea    rcx,[rbp+0x70]
   1816e64e2:	e8 89 e7 00 ff       	call   0x1806f4c70
   1816e64e7:	4d 8d 4e 08          	lea    r9,[r14+0x8]
   1816e64eb:	48 8b 45 70          	mov    rax,QWORD PTR [rbp+0x70]
   1816e64ef:	48 8d b8 b0 00 00 00 	lea    rdi,[rax+0xb0]
   1816e64f6:	4c 39 cf             	cmp    rdi,r9
   1816e64f9:	74 4b                	je     0x1816e6546
   1816e64fb:	49 8b 5e 18          	mov    rbx,QWORD PTR [r14+0x18]
   1816e64ff:	49 83 7e 20 10       	cmp    QWORD PTR [r14+0x20],0x10
   1816e6504:	72 04                	jb     0x1816e650a
   1816e6506:	4d 8b 4e 08          	mov    r9,QWORD PTR [r14+0x8]
   1816e650a:	48 8b 88 c8 00 00 00 	mov    rcx,QWORD PTR [rax+0xc8]
   1816e6511:	48 39 cb             	cmp    rbx,rcx
   1816e6514:	76 0e                	jbe    0x1816e6524
   1816e6516:	48 89 f9             	mov    rcx,rdi
   1816e6519:	48 89 da             	mov    rdx,rbx
   1816e651c:	e8 2f 7c 95 fe       	call   0x18003e150
   1816e6521:	90                   	nop
   1816e6522:	eb 22                	jmp    0x1816e6546
   1816e6524:	48 83 f9 10          	cmp    rcx,0x10
   1816e6528:	72 03                	jb     0x1816e652d
   1816e652a:	48 8b 3f             	mov    rdi,QWORD PTR [rdi]
   1816e652d:	48 89 98 c0 00 00 00 	mov    QWORD PTR [rax+0xc0],rbx
   1816e6534:	48 89 f9             	mov    rcx,rdi
   1816e6537:	4c 89 ca             	mov    rdx,r9
   1816e653a:	49 89 d8             	mov    r8,rbx
   1816e653d:	e8 0e db e5 05       	call   0x187544050
   1816e6542:	c6 04 1f 00          	mov    BYTE PTR [rdi+rbx*1],0x0
   1816e6546:	48 8b 45 70          	mov    rax,QWORD PTR [rbp+0x70]
   1816e654a:	c7 80 18 01 00 00 10 	mov    DWORD PTR [rax+0x118],0x2710
   1816e6551:	27 00 00 
   1816e6554:	0f 29 75 60          	movaps XMMWORD PTR [rbp+0x60],xmm6
   1816e6558:	0f 29 75 50          	movaps XMMWORD PTR [rbp+0x50],xmm6
   1816e655c:	e8 7f 88 9d fe       	call   0x1800bede0
   1816e6561:	90                   	nop
   1816e6562:	48 89 c7             	mov    rdi,rax
   1816e6565:	0f 57 c0             	xorps  xmm0,xmm0
   1816e6568:	0f 29 45 60          	movaps XMMWORD PTR [rbp+0x60],xmm0
   1816e656c:	0f 29 45 50          	movaps XMMWORD PTR [rbp+0x50],xmm0
   1816e6570:	48 89 c1             	mov    rcx,rax
   1816e6573:	e8 28 e0 e3 05       	call   0x1875245a0
   1816e6578:	48 85 c0             	test   rax,rax
   1816e657b:	0f 88 a5 03 00 00    	js     0x1816e6926
   1816e6581:	48 89 c3             	mov    rbx,rax
   1816e6584:	48 83 f8 10          	cmp    rax,0x10
   1816e6588:	73 0c                	jae    0x1816e6596
   1816e658a:	4c 8d 75 50          	lea    r14,[rbp+0x50]
   1816e658e:	41 bf 0f 00 00 00    	mov    r15d,0xf
   1816e6594:	eb 55                	jmp    0x1816e65eb
   1816e6596:	48 89 d8             	mov    rax,rbx
   1816e6599:	48 83 c8 0f          	or     rax,0xf
   1816e659d:	48 83 f8 17          	cmp    rax,0x17
   1816e65a1:	41 bf 16 00 00 00    	mov    r15d,0x16
   1816e65a7:	4c 0f 43 f8          	cmovae r15,rax
   1816e65ab:	48 3d ff 0f 00 00    	cmp    rax,0xfff
   1816e65b1:	72 27                	jb     0x1816e65da
   1816e65b3:	49 8d 4f 28          	lea    rcx,[r15+0x28]
   1816e65b7:	e8 e0 52 dc 05       	call   0x1874ab89c
   1816e65bc:	90                   	nop
   1816e65bd:	49 89 c6             	mov    r14,rax
   1816e65c0:	48 85 c0             	test   rax,rax
   1816e65c3:	0f 84 57 03 00 00    	je     0x1816e6920
   1816e65c9:	4c 89 f0             	mov    rax,r14
   1816e65cc:	49 83 c6 27          	add    r14,0x27
   1816e65d0:	49 83 e6 e0          	and    r14,0xffffffffffffffe0
   1816e65d4:	49 89 46 f8          	mov    QWORD PTR [r14-0x8],rax
   1816e65d8:	eb 0d                	jmp    0x1816e65e7
   1816e65da:	49 8d 4f 01          	lea    rcx,[r15+0x1]
   1816e65de:	e8 b9 52 dc 05       	call   0x1874ab89c
   1816e65e3:	90                   	nop
   1816e65e4:	49 89 c6             	mov    r14,rax
   1816e65e7:	4c 89 75 50          	mov    QWORD PTR [rbp+0x50],r14
   1816e65eb:	48 89 5d 60          	mov    QWORD PTR [rbp+0x60],rbx
   1816e65ef:	4c 89 7d 68          	mov    QWORD PTR [rbp+0x68],r15
   1816e65f3:	4c 89 f1             	mov    rcx,r14
   1816e65f6:	48 89 fa             	mov    rdx,rdi
   1816e65f9:	49 89 d8             	mov    r8,rbx
   1816e65fc:	e8 4f da e5 05       	call   0x187544050
   1816e6601:	41 c6 04 1e 00       	mov    BYTE PTR [r14+rbx*1],0x0
   1816e6606:	48 8b 5e 10          	mov    rbx,QWORD PTR [rsi+0x10]
   1816e660a:	48 8b 7d 60          	mov    rdi,QWORD PTR [rbp+0x60]
   1816e660e:	49 bd ff ff ff ff ff 	movabs r13,0x7fffffffffffffff
   1816e6615:	ff ff 7f 
   1816e6618:	48 89 d8             	mov    rax,rbx
   1816e661b:	4c 31 e8             	xor    rax,r13
   1816e661e:	48 39 f8             	cmp    rax,rdi
   1816e6621:	0f 82 05 03 00 00    	jb     0x1816e692c
   1816e6627:	48 8b 0e             	mov    rcx,QWORD PTR [rsi]
   1816e662a:	48 8b 56 18          	mov    rdx,QWORD PTR [rsi+0x18]
   1816e662e:	4c 8b 45 50          	mov    r8,QWORD PTR [rbp+0x50]
   1816e6632:	4c 8b 7d 68          	mov    r15,QWORD PTR [rbp+0x68]
   1816e6636:	0f 57 c0             	xorps  xmm0,xmm0
   1816e6639:	0f 29 45 10          	movaps XMMWORD PTR [rbp+0x10],xmm0
   1816e663d:	4c 8d 24 1f          	lea    r12,[rdi+rbx*1]
   1816e6641:	49 83 fc 10          	cmp    r12,0x10
   1816e6645:	72 55                	jb     0x1816e669c
   1816e6647:	4d 85 e4             	test   r12,r12
   1816e664a:	48 89 4d 38          	mov    QWORD PTR [rbp+0x38],rcx
   1816e664e:	48 89 55 40          	mov    QWORD PTR [rbp+0x40],rdx
   1816e6652:	4c 89 45 48          	mov    QWORD PTR [rbp+0x48],r8
   1816e6656:	78 1d                	js     0x1816e6675
   1816e6658:	4c 89 e0             	mov    rax,r12
   1816e665b:	48 83 c8 0f          	or     rax,0xf
   1816e665f:	48 83 f8 17          	cmp    rax,0x17
   1816e6663:	41 bd 16 00 00 00    	mov    r13d,0x16
   1816e6669:	4c 0f 43 e8          	cmovae r13,rax
   1816e666d:	48 3d ff 0f 00 00    	cmp    rax,0xfff
   1816e6673:	72 33                	jb     0x1816e66a8
   1816e6675:	49 8d 4d 28          	lea    rcx,[r13+0x28]
   1816e6679:	e8 1e 52 dc 05       	call   0x1874ab89c
   1816e667e:	90                   	nop
   1816e667f:	49 89 c6             	mov    r14,rax
   1816e6682:	48 85 c0             	test   rax,rax
   1816e6685:	0f 84 95 02 00 00    	je     0x1816e6920
   1816e668b:	4c 89 f0             	mov    rax,r14
   1816e668e:	49 83 c6 27          	add    r14,0x27
   1816e6692:	49 83 e6 e0          	and    r14,0xffffffffffffffe0
   1816e6696:	49 89 46 f8          	mov    QWORD PTR [r14-0x8],rax
   1816e669a:	eb 19                	jmp    0x1816e66b5
   1816e669c:	4c 8d 75 10          	lea    r14,[rbp+0x10]
   1816e66a0:	41 bd 0f 00 00 00    	mov    r13d,0xf
   1816e66a6:	eb 1d                	jmp    0x1816e66c5
   1816e66a8:	49 8d 4d 01          	lea    rcx,[r13+0x1]
   1816e66ac:	e8 eb 51 dc 05       	call   0x1874ab89c
   1816e66b1:	90                   	nop
   1816e66b2:	49 89 c6             	mov    r14,rax
   1816e66b5:	48 8b 4d 38          	mov    rcx,QWORD PTR [rbp+0x38]
   1816e66b9:	48 8b 55 40          	mov    rdx,QWORD PTR [rbp+0x40]
   1816e66bd:	4c 8b 45 48          	mov    r8,QWORD PTR [rbp+0x48]
   1816e66c1:	4c 89 75 10          	mov    QWORD PTR [rbp+0x10],r14
   1816e66c5:	49 83 ff 10          	cmp    r15,0x10
   1816e66c9:	4c 8d 7d 50          	lea    r15,[rbp+0x50]
   1816e66cd:	4d 0f 43 f8          	cmovae r15,r8
   1816e66d1:	48 83 fa 10          	cmp    rdx,0x10
   1816e66d5:	48 0f 43 f1          	cmovae rsi,rcx
   1816e66d9:	4c 89 65 20          	mov    QWORD PTR [rbp+0x20],r12
   1816e66dd:	4c 89 6d 28          	mov    QWORD PTR [rbp+0x28],r13
   1816e66e1:	4c 89 f1             	mov    rcx,r14
   1816e66e4:	48 89 f2             	mov    rdx,rsi
   1816e66e7:	49 89 d8             	mov    r8,rbx
   1816e66ea:	e8 61 d9 e5 05       	call   0x187544050
   1816e66ef:	4c 01 f3             	add    rbx,r14
   1816e66f2:	48 89 d9             	mov    rcx,rbx
   1816e66f5:	4c 89 fa             	mov    rdx,r15
   1816e66f8:	49 89 f8             	mov    r8,rdi
   1816e66fb:	e8 50 d9 e5 05       	call   0x187544050
   1816e6700:	43 c6 04 26 00       	mov    BYTE PTR [r14+r12*1],0x0
   1816e6705:	48 8b 4d 70          	mov    rcx,QWORD PTR [rbp+0x70]
   1816e6709:	48 8d b1 58 07 00 00 	lea    rsi,[rcx+0x758]
   1816e6710:	48 8b 81 70 07 00 00 	mov    rax,QWORD PTR [rcx+0x770]
   1816e6717:	48 83 f8 10          	cmp    rax,0x10
   1816e671b:	72 38                	jb     0x1816e6755
   1816e671d:	48 8b 0e             	mov    rcx,QWORD PTR [rsi]
   1816e6720:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1816e6724:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1816e672b:	72 1f                	jb     0x1816e674c
   1816e672d:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1816e6731:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1816e6735:	4c 29 c1             	sub    rcx,r8
   1816e6738:	48 83 f9 20          	cmp    rcx,0x20
   1816e673c:	0f 83 de 01 00 00    	jae    0x1816e6920
   1816e6742:	48 83 c0 28          	add    rax,0x28
   1816e6746:	48 89 c2             	mov    rdx,rax
   1816e6749:	4c 89 c1             	mov    rcx,r8
   1816e674c:	e8 8f 51 dc 05       	call   0x1874ab8e0
   1816e6751:	48 8b 4d 70          	mov    rcx,QWORD PTR [rbp+0x70]
   1816e6755:	0f 28 45 10          	movaps xmm0,XMMWORD PTR [rbp+0x10]
   1816e6759:	0f 28 4d 20          	movaps xmm1,XMMWORD PTR [rbp+0x20]
   1816e675d:	0f 11 4e 10          	movups XMMWORD PTR [rsi+0x10],xmm1
   1816e6761:	0f 11 06             	movups XMMWORD PTR [rsi],xmm0
   1816e6764:	c7 81 9c 00 00 00 01 	mov    DWORD PTR [rcx+0x9c],0x1
   1816e676b:	00 00 00 
   1816e676e:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1816e6772:	e8 a9 0a 96 fe       	call   0x180047220
   1816e6777:	90                   	nop
   1816e6778:	48 8b 4d f0          	mov    rcx,QWORD PTR [rbp-0x10]
   1816e677c:	48 8d 55 e0          	lea    rdx,[rbp-0x20]
   1816e6780:	e8 bb 5f c8 fe       	call   0x18036c740
   1816e6785:	90                   	nop
   1816e6786:	48 8b 4d e0          	mov    rcx,QWORD PTR [rbp-0x20]
   1816e678a:	48 8d 55 10          	lea    rdx,[rbp+0x10]
   1816e678e:	e8 fd e5 00 ff       	call   0x1806f4d90
   1816e6793:	90                   	nop
   1816e6794:	48 8b 4d 10          	mov    rcx,QWORD PTR [rbp+0x10]
   1816e6798:	0f 57 c0             	xorps  xmm0,xmm0
   1816e679b:	0f 29 45 00          	movaps XMMWORD PTR [rbp+0x0],xmm0
   1816e679f:	48 8b 45 78          	mov    rax,QWORD PTR [rbp+0x78]
   1816e67a3:	48 85 c0             	test   rax,rax
   1816e67a6:	74 0a                	je     0x1816e67b2
   1816e67a8:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   1816e67ac:	48 8b 45 78          	mov    rax,QWORD PTR [rbp+0x78]
   1816e67b0:	eb 02                	jmp    0x1816e67b4
   1816e67b2:	31 c0                	xor    eax,eax
   1816e67b4:	48 8b 55 70          	mov    rdx,QWORD PTR [rbp+0x70]
   1816e67b8:	48 89 55 00          	mov    QWORD PTR [rbp+0x0],rdx
   1816e67bc:	48 89 45 08          	mov    QWORD PTR [rbp+0x8],rax
   1816e67c0:	48 8d 55 a8          	lea    rdx,[rbp-0x58]
   1816e67c4:	49 89 e8             	mov    r8,rbp
   1816e67c7:	e8 54 8f 0a 00       	call   0x18178f720
   1816e67cc:	90                   	nop
   1816e67cd:	48 8b 75 d8          	mov    rsi,QWORD PTR [rbp-0x28]
   1816e67d1:	48 85 f6             	test   rsi,rsi
   1816e67d4:	74 1d                	je     0x1816e67f3
   1816e67d6:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   1816e67da:	75 17                	jne    0x1816e67f3
   1816e67dc:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1816e67df:	48 89 f1             	mov    rcx,rsi
   1816e67e2:	ff 10                	call   QWORD PTR [rax]
   1816e67e4:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   1816e67e8:	75 09                	jne    0x1816e67f3
   1816e67ea:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1816e67ed:	48 89 f1             	mov    rcx,rsi
   1816e67f0:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1816e67f3:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   1816e67f7:	48 83 f8 10          	cmp    rax,0x10
   1816e67fb:	72 35                	jb     0x1816e6832
   1816e67fd:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   1816e6801:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1816e6805:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1816e680c:	72 1f                	jb     0x1816e682d
   1816e680e:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1816e6812:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1816e6816:	4c 29 c1             	sub    rcx,r8
   1816e6819:	48 83 f9 20          	cmp    rcx,0x20
   1816e681d:	0f 83 fd 00 00 00    	jae    0x1816e6920
   1816e6823:	48 83 c0 28          	add    rax,0x28
   1816e6827:	48 89 c2             	mov    rdx,rax
   1816e682a:	4c 89 c1             	mov    rcx,r8
   1816e682d:	e8 ae 50 dc 05       	call   0x1874ab8e0
   1816e6832:	48 8b 75 18          	mov    rsi,QWORD PTR [rbp+0x18]
   1816e6836:	48 85 f6             	test   rsi,rsi
   1816e6839:	74 1d                	je     0x1816e6858
   1816e683b:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   1816e683f:	75 17                	jne    0x1816e6858
   1816e6841:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1816e6844:	48 89 f1             	mov    rcx,rsi
   1816e6847:	ff 10                	call   QWORD PTR [rax]
   1816e6849:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   1816e684d:	75 09                	jne    0x1816e6858
   1816e684f:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1816e6852:	48 89 f1             	mov    rcx,rsi
   1816e6855:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1816e6858:	48 8b 75 e8          	mov    rsi,QWORD PTR [rbp-0x18]
   1816e685c:	48 85 f6             	test   rsi,rsi
   1816e685f:	74 1d                	je     0x1816e687e
   1816e6861:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   1816e6865:	75 17                	jne    0x1816e687e
   1816e6867:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1816e686a:	48 89 f1             	mov    rcx,rsi
   1816e686d:	ff 10                	call   QWORD PTR [rax]
   1816e686f:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   1816e6873:	75 09                	jne    0x1816e687e
   1816e6875:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1816e6878:	48 89 f1             	mov    rcx,rsi
   1816e687b:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1816e687e:	48 8b 75 f8          	mov    rsi,QWORD PTR [rbp-0x8]
   1816e6882:	48 85 f6             	test   rsi,rsi
   1816e6885:	74 1d                	je     0x1816e68a4
   1816e6887:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   1816e688b:	75 17                	jne    0x1816e68a4
   1816e688d:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1816e6890:	48 89 f1             	mov    rcx,rsi
   1816e6893:	ff 10                	call   QWORD PTR [rax]
   1816e6895:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   1816e6899:	75 09                	jne    0x1816e68a4
   1816e689b:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1816e689e:	48 89 f1             	mov    rcx,rsi
   1816e68a1:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1816e68a4:	48 8b 45 68          	mov    rax,QWORD PTR [rbp+0x68]
   1816e68a8:	48 83 f8 10          	cmp    rax,0x10
   1816e68ac:	72 31                	jb     0x1816e68df
   1816e68ae:	48 8b 4d 50          	mov    rcx,QWORD PTR [rbp+0x50]
   1816e68b2:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1816e68b6:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1816e68bd:	72 1b                	jb     0x1816e68da
   1816e68bf:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1816e68c3:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1816e68c7:	4c 29 c1             	sub    rcx,r8
   1816e68ca:	48 83 f9 20          	cmp    rcx,0x20
   1816e68ce:	73 50                	jae    0x1816e6920
   1816e68d0:	48 83 c0 28          	add    rax,0x28
   1816e68d4:	48 89 c2             	mov    rdx,rax
   1816e68d7:	4c 89 c1             	mov    rcx,r8
   1816e68da:	e8 01 50 dc 05       	call   0x1874ab8e0
   1816e68df:	48 8b 75 78          	mov    rsi,QWORD PTR [rbp+0x78]
   1816e68e3:	48 85 f6             	test   rsi,rsi
   1816e68e6:	74 1d                	je     0x1816e6905
   1816e68e8:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   1816e68ec:	75 17                	jne    0x1816e6905
   1816e68ee:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1816e68f1:	48 89 f1             	mov    rcx,rsi
   1816e68f4:	ff 10                	call   QWORD PTR [rax]
   1816e68f6:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   1816e68fa:	75 09                	jne    0x1816e6905
   1816e68fc:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1816e68ff:	48 89 f1             	mov    rcx,rsi
   1816e6902:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1816e6905:	0f 28 b5 90 00 00 00 	movaps xmm6,XMMWORD PTR [rbp+0x90]
   1816e690c:	48 81 c4 28 01 00 00 	add    rsp,0x128
   1816e6913:	5b                   	pop    rbx
   1816e6914:	5f                   	pop    rdi
   1816e6915:	5e                   	pop    rsi
   1816e6916:	41 5c                	pop    r12
   1816e6918:	41 5d                	pop    r13
   1816e691a:	41 5e                	pop    r14
   1816e691c:	41 5f                	pop    r15
   1816e691e:	5d                   	pop    rbp
   1816e691f:	c3                   	ret
   1816e6920:	e8 67 6a e2 05       	call   0x18750d38c
   1816e6925:	90                   	nop
   1816e6926:	e8 65 22 92 fe       	call   0x180008b90
   1816e692b:	90                   	nop
   1816e692c:	e8 5f 22 92 fe       	call   0x180008b90
   1816e6931:	90                   	nop
   1816e6932:	cc                   	int3
