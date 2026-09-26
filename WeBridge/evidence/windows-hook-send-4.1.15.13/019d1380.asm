
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

00000001819d1380 <.text+0x19d0380>:
   1819d1380:	55                   	push   rbp
   1819d1381:	56                   	push   rsi
   1819d1382:	57                   	push   rdi
   1819d1383:	48 81 ec d0 00 00 00 	sub    rsp,0xd0
   1819d138a:	48 8d ac 24 80 00 00 	lea    rbp,[rsp+0x80]
   1819d1391:	00 
   1819d1392:	48 c7 45 48 fe ff ff 	mov    QWORD PTR [rbp+0x48],0xfffffffffffffffe
   1819d1399:	ff 
   1819d139a:	48 89 ce             	mov    rsi,rcx
   1819d139d:	48 b8 aa aa aa aa aa 	movabs rax,0xaaaaaaaaaaaaaaaa
   1819d13a4:	aa aa aa 
   1819d13a7:	48 89 45 e0          	mov    QWORD PTR [rbp-0x20],rax
   1819d13ab:	0f 28 05 fe 47 37 07 	movaps xmm0,XMMWORD PTR [rip+0x73747fe]        # 0x188d45bb0
   1819d13b2:	0f 29 45 d0          	movaps XMMWORD PTR [rbp-0x30],xmm0
   1819d13b6:	0f 29 45 c0          	movaps XMMWORD PTR [rbp-0x40],xmm0
   1819d13ba:	0f 29 45 b0          	movaps XMMWORD PTR [rbp-0x50],xmm0
   1819d13be:	0f 29 45 a0          	movaps XMMWORD PTR [rbp-0x60],xmm0
   1819d13c2:	48 8d 4d 10          	lea    rcx,[rbp+0x10]
   1819d13c6:	e8 55 5e 67 fe       	call   0x180047220
   1819d13cb:	48 8b 4d 10          	mov    rcx,QWORD PTR [rbp+0x10]
   1819d13cf:	48 8d 55 28          	lea    rdx,[rbp+0x28]
   1819d13d3:	e8 68 b3 99 fe       	call   0x18036c740
   1819d13d8:	90                   	nop
   1819d13d9:	48 8b 4d 28          	mov    rcx,QWORD PTR [rbp+0x28]
   1819d13dd:	48 8d 55 f0          	lea    rdx,[rbp-0x10]
   1819d13e1:	e8 aa 39 d2 fe       	call   0x1806f4d90
   1819d13e6:	90                   	nop
   1819d13e7:	4c 8d 46 08          	lea    r8,[rsi+0x8]
   1819d13eb:	48 8b 4d f0          	mov    rcx,QWORD PTR [rbp-0x10]
   1819d13ef:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   1819d13f3:	41 b1 01             	mov    r9b,0x1
   1819d13f6:	e8 b5 09 dd ff       	call   0x1817a1db0
   1819d13fb:	90                   	nop
   1819d13fc:	48 8b 7d f8          	mov    rdi,QWORD PTR [rbp-0x8]
   1819d1400:	48 85 ff             	test   rdi,rdi
   1819d1403:	74 1d                	je     0x1819d1422
   1819d1405:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   1819d1409:	75 17                	jne    0x1819d1422
   1819d140b:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1819d140e:	48 89 f9             	mov    rcx,rdi
   1819d1411:	ff 10                	call   QWORD PTR [rax]
   1819d1413:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   1819d1417:	75 09                	jne    0x1819d1422
   1819d1419:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1819d141c:	48 89 f9             	mov    rcx,rdi
   1819d141f:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1819d1422:	48 8b 7d 30          	mov    rdi,QWORD PTR [rbp+0x30]
   1819d1426:	48 85 ff             	test   rdi,rdi
   1819d1429:	74 1d                	je     0x1819d1448
   1819d142b:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   1819d142f:	75 17                	jne    0x1819d1448
   1819d1431:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1819d1434:	48 89 f9             	mov    rcx,rdi
   1819d1437:	ff 10                	call   QWORD PTR [rax]
   1819d1439:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   1819d143d:	75 09                	jne    0x1819d1448
   1819d143f:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1819d1442:	48 89 f9             	mov    rcx,rdi
   1819d1445:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1819d1448:	48 8b 7d 18          	mov    rdi,QWORD PTR [rbp+0x18]
   1819d144c:	48 85 ff             	test   rdi,rdi
   1819d144f:	74 1e                	je     0x1819d146f
   1819d1451:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   1819d1455:	75 18                	jne    0x1819d146f
   1819d1457:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1819d145a:	48 89 f9             	mov    rcx,rdi
   1819d145d:	ff 10                	call   QWORD PTR [rax]
   1819d145f:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   1819d1463:	75 0a                	jne    0x1819d146f
   1819d1465:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1819d1468:	48 89 f9             	mov    rcx,rdi
   1819d146b:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1819d146e:	90                   	nop
   1819d146f:	b9 58 01 00 00       	mov    ecx,0x158
   1819d1474:	e8 23 a4 ad 05       	call   0x1874ab89c
   1819d1479:	90                   	nop
   1819d147a:	48 8d 15 7f 02 00 00 	lea    rdx,[rip+0x27f]        # 0x1819d1700
   1819d1481:	4c 8d 05 f8 03 00 00 	lea    r8,[rip+0x3f8]        # 0x1819d1880
   1819d1488:	48 89 c1             	mov    rcx,rax
   1819d148b:	48 89 45 38          	mov    QWORD PTR [rbp+0x38],rax
   1819d148f:	e8 6c 5a 73 fe       	call   0x180106f00
   1819d1494:	90                   	nop
   1819d1495:	48 83 c6 20          	add    rsi,0x20
   1819d1499:	48 8b 45 38          	mov    rax,QWORD PTR [rbp+0x38]
   1819d149d:	48 8d 48 28          	lea    rcx,[rax+0x28]
   1819d14a1:	48 89 4d 20          	mov    QWORD PTR [rbp+0x20],rcx
   1819d14a5:	48 89 f2             	mov    rdx,rsi
   1819d14a8:	e8 03 de 68 fe       	call   0x18005f2b0
   1819d14ad:	90                   	nop
   1819d14ae:	48 8b 4d 38          	mov    rcx,QWORD PTR [rbp+0x38]
   1819d14b2:	48 81 c1 10 01 00 00 	add    rcx,0x110
   1819d14b9:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   1819d14bd:	e8 ee 04 00 00       	call   0x1819d19b0
   1819d14c2:	90                   	nop
   1819d14c3:	48 8b 45 38          	mov    rax,QWORD PTR [rbp+0x38]
   1819d14c7:	48 89 45 28          	mov    QWORD PTR [rbp+0x28],rax
   1819d14cb:	c6 45 47 01          	mov    BYTE PTR [rbp+0x47],0x1
   1819d14cf:	48 8d 15 7a 3a 3b 07 	lea    rdx,[rip+0x73b3a7a]        # 0x188d84f50
   1819d14d6:	4c 8d 05 6b 67 74 07 	lea    r8,[rip+0x774676b]        # 0x189117c48
   1819d14dd:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1819d14e1:	41 b9 2b 02 00 00    	mov    r9d,0x22b
   1819d14e7:	e8 14 90 7c fe       	call   0x18019a500
   1819d14ec:	90                   	nop
   1819d14ed:	c6 45 47 00          	mov    BYTE PTR [rbp+0x47],0x0
   1819d14f1:	48 8d 4d f0          	lea    rcx,[rbp-0x10]
   1819d14f5:	48 8d 55 28          	lea    rdx,[rbp+0x28]
   1819d14f9:	45 31 c0             	xor    r8d,r8d
   1819d14fc:	45 31 c9             	xor    r9d,r9d
   1819d14ff:	e8 bc 78 9b fe       	call   0x180388dc0
   1819d1504:	90                   	nop
   1819d1505:	48 8d 4d c8          	lea    rcx,[rbp-0x38]
   1819d1509:	e8 02 2d bf ff       	call   0x1815c4210
   1819d150e:	48 8b 45 c0          	mov    rax,QWORD PTR [rbp-0x40]
   1819d1512:	48 83 f8 10          	cmp    rax,0x10
   1819d1516:	72 32                	jb     0x1819d154a
   1819d1518:	48 8b 4d a8          	mov    rcx,QWORD PTR [rbp-0x58]
   1819d151c:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1819d1520:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1819d1527:	72 1b                	jb     0x1819d1544
   1819d1529:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1819d152d:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1819d1531:	4c 29 c1             	sub    rcx,r8
   1819d1534:	48 83 f9 20          	cmp    rcx,0x20
   1819d1538:	73 1b                	jae    0x1819d1555
   1819d153a:	48 83 c0 28          	add    rax,0x28
   1819d153e:	48 89 c2             	mov    rdx,rax
   1819d1541:	4c 89 c1             	mov    rcx,r8
   1819d1544:	e8 97 a3 ad 05       	call   0x1874ab8e0
   1819d1549:	90                   	nop
   1819d154a:	48 81 c4 d0 00 00 00 	add    rsp,0xd0
   1819d1551:	5f                   	pop    rdi
   1819d1552:	5e                   	pop    rsi
   1819d1553:	5d                   	pop    rbp
   1819d1554:	c3                   	ret
   1819d1555:	e8 32 be b3 05       	call   0x18750d38c
   1819d155a:	cc                   	int3
