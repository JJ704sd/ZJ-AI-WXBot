
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000183969310 <.text+0x3968310>:
   183969310:	55                   	push   rbp
   183969311:	41 57                	push   r15
   183969313:	41 56                	push   r14
   183969315:	56                   	push   rsi
   183969316:	57                   	push   rdi
   183969317:	53                   	push   rbx
   183969318:	48 81 ec d8 00 00 00 	sub    rsp,0xd8
   18396931f:	48 8d ac 24 80 00 00 	lea    rbp,[rsp+0x80]
   183969326:	00 
   183969327:	44 0f 29 55 40       	movaps XMMWORD PTR [rbp+0x40],xmm10
   18396932c:	44 0f 29 4d 30       	movaps XMMWORD PTR [rbp+0x30],xmm9
   183969331:	44 0f 29 45 20       	movaps XMMWORD PTR [rbp+0x20],xmm8
   183969336:	0f 29 7d 10          	movaps XMMWORD PTR [rbp+0x10],xmm7
   18396933a:	0f 29 75 00          	movaps XMMWORD PTR [rbp+0x0],xmm6
   18396933e:	48 c7 45 f8 fe ff ff 	mov    QWORD PTR [rbp-0x8],0xfffffffffffffffe
   183969345:	ff 
   183969346:	4c 89 c3             	mov    rbx,r8
   183969349:	48 89 d6             	mov    rsi,rdx
   18396934c:	48 89 cf             	mov    rdi,rcx
   18396934f:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   183969353:	4c 89 c2             	mov    rdx,r8
   183969356:	e8 45 42 f1 ff       	call   0x18387d5a0
   18396935b:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183969362:	00 
   183969363:	b9 20 00 00 00       	mov    ecx,0x20
   183969368:	e8 2f 25 b4 03       	call   0x1874ab89c
   18396936d:	90                   	nop
   18396936e:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183969372:	48 c7 45 e8 12 00 00 	mov    QWORD PTR [rbp-0x18],0x12
   183969379:	00 
   18396937a:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183969381:	00 
   183969382:	0f 10 35 27 e1 b9 05 	movups xmm6,XMMWORD PTR [rip+0x5b9e127]        # 0x1895074b0
   183969389:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   18396938c:	66 c7 40 10 65 72    	mov    WORD PTR [rax+0x10],0x7265
   183969392:	c6 40 12 00          	mov    BYTE PTR [rax+0x12],0x0
   183969396:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396939a:	4c 8d 45 d8          	lea    r8,[rbp-0x28]
   18396939e:	4c 8d 4d b0          	lea    r9,[rbp-0x50]
   1839693a2:	48 89 f9             	mov    rcx,rdi
   1839693a5:	e8 86 2d e9 fd       	call   0x1817fc130
   1839693aa:	90                   	nop
   1839693ab:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   1839693af:	48 83 f8 10          	cmp    rax,0x10
   1839693b3:	72 35                	jb     0x1839693ea
   1839693b5:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   1839693b9:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1839693bd:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1839693c4:	72 1f                	jb     0x1839693e5
   1839693c6:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1839693ca:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1839693ce:	4c 29 c1             	sub    rcx,r8
   1839693d1:	48 83 f9 20          	cmp    rcx,0x20
   1839693d5:	0f 83 04 35 00 00    	jae    0x18396c8df
   1839693db:	48 83 c0 28          	add    rax,0x28
   1839693df:	48 89 c2             	mov    rdx,rax
   1839693e2:	4c 89 c1             	mov    rcx,r8
   1839693e5:	e8 f6 24 b4 03       	call   0x1874ab8e0
   1839693ea:	4c 8b 75 b8          	mov    r14,QWORD PTR [rbp-0x48]
   1839693ee:	4d 85 f6             	test   r14,r14
   1839693f1:	74 1f                	je     0x183969412
   1839693f3:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   1839693f8:	75 18                	jne    0x183969412
   1839693fa:	49 8b 06             	mov    rax,QWORD PTR [r14]
   1839693fd:	4c 89 f1             	mov    rcx,r14
   183969400:	ff 10                	call   QWORD PTR [rax]
   183969402:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   183969407:	75 09                	jne    0x183969412
   183969409:	49 8b 06             	mov    rax,QWORD PTR [r14]
   18396940c:	4c 89 f1             	mov    rcx,r14
   18396940f:	ff 50 08             	call   QWORD PTR [rax+0x8]
   183969412:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183969419:	00 
   18396941a:	b9 20 00 00 00       	mov    ecx,0x20
   18396941f:	e8 78 24 b4 03       	call   0x1874ab89c
   183969424:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183969428:	48 c7 45 e8 12 00 00 	mov    QWORD PTR [rbp-0x18],0x12
   18396942f:	00 
   183969430:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183969437:	00 
   183969438:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   18396943b:	66 c7 40 10 65 72    	mov    WORD PTR [rax+0x10],0x7265
   183969441:	c6 40 12 00          	mov    BYTE PTR [rax+0x12],0x0
   183969445:	0f 57 c0             	xorps  xmm0,xmm0
   183969448:	0f 29 45 b0          	movaps XMMWORD PTR [rbp-0x50],xmm0
   18396944c:	48 c7 45 c0 01 00 00 	mov    QWORD PTR [rbp-0x40],0x1
   183969453:	00 
   183969454:	48 c7 45 c8 0f 00 00 	mov    QWORD PTR [rbp-0x38],0xf
   18396945b:	00 
   18396945c:	c6 45 b0 31          	mov    BYTE PTR [rbp-0x50],0x31
   183969460:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183969464:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   183969468:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18396946c:	48 89 f1             	mov    rcx,rsi
   18396946f:	e8 7c 81 db fc       	call   0x1807215f0
   183969474:	90                   	nop
   183969475:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   183969479:	48 83 f8 10          	cmp    rax,0x10
   18396947d:	72 35                	jb     0x1839694b4
   18396947f:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   183969483:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183969487:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396948e:	72 1f                	jb     0x1839694af
   183969490:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183969494:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183969498:	4c 29 c1             	sub    rcx,r8
   18396949b:	48 83 f9 20          	cmp    rcx,0x20
   18396949f:	0f 83 3a 34 00 00    	jae    0x18396c8df
   1839694a5:	48 83 c0 28          	add    rax,0x28
   1839694a9:	48 89 c2             	mov    rdx,rax
   1839694ac:	4c 89 c1             	mov    rcx,r8
   1839694af:	e8 2c 24 b4 03       	call   0x1874ab8e0
   1839694b4:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   1839694b8:	48 83 f8 10          	cmp    rax,0x10
   1839694bc:	72 35                	jb     0x1839694f3
   1839694be:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   1839694c2:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1839694c6:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1839694cd:	72 1f                	jb     0x1839694ee
   1839694cf:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1839694d3:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1839694d7:	4c 29 c1             	sub    rcx,r8
   1839694da:	48 83 f9 20          	cmp    rcx,0x20
   1839694de:	0f 83 fb 33 00 00    	jae    0x18396c8df
   1839694e4:	48 83 c0 28          	add    rax,0x28
   1839694e8:	48 89 c2             	mov    rdx,rax
   1839694eb:	4c 89 c1             	mov    rcx,r8
   1839694ee:	e8 ed 23 b4 03       	call   0x1874ab8e0
   1839694f3:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   1839694f7:	48 89 da             	mov    rdx,rbx
   1839694fa:	e8 c1 41 f1 ff       	call   0x18387d6c0
   1839694ff:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183969506:	00 
   183969507:	b9 20 00 00 00       	mov    ecx,0x20
   18396950c:	e8 8b 23 b4 03       	call   0x1874ab89c
   183969511:	90                   	nop
   183969512:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183969516:	48 c7 45 e8 13 00 00 	mov    QWORD PTR [rbp-0x18],0x13
   18396951d:	00 
   18396951e:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183969525:	00 
   183969526:	0f 10 35 9b df b9 05 	movups xmm6,XMMWORD PTR [rip+0x5b9df9b]        # 0x1895074c8
   18396952d:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   183969530:	c7 40 0f 64 6c 65 72 	mov    DWORD PTR [rax+0xf],0x72656c64
   183969537:	c6 40 13 00          	mov    BYTE PTR [rax+0x13],0x0
   18396953b:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396953f:	4c 8d 45 d8          	lea    r8,[rbp-0x28]
   183969543:	4c 8d 4d b0          	lea    r9,[rbp-0x50]
   183969547:	48 89 f9             	mov    rcx,rdi
   18396954a:	e8 e1 2b e9 fd       	call   0x1817fc130
   18396954f:	90                   	nop
   183969550:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   183969554:	48 83 f8 10          	cmp    rax,0x10
   183969558:	72 35                	jb     0x18396958f
   18396955a:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396955e:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183969562:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183969569:	72 1f                	jb     0x18396958a
   18396956b:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396956f:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183969573:	4c 29 c1             	sub    rcx,r8
   183969576:	48 83 f9 20          	cmp    rcx,0x20
   18396957a:	0f 83 5f 33 00 00    	jae    0x18396c8df
   183969580:	48 83 c0 28          	add    rax,0x28
   183969584:	48 89 c2             	mov    rdx,rax
   183969587:	4c 89 c1             	mov    rcx,r8
   18396958a:	e8 51 23 b4 03       	call   0x1874ab8e0
   18396958f:	4c 8b 75 b8          	mov    r14,QWORD PTR [rbp-0x48]
   183969593:	4d 85 f6             	test   r14,r14
   183969596:	74 1f                	je     0x1839695b7
   183969598:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   18396959d:	75 18                	jne    0x1839695b7
   18396959f:	49 8b 06             	mov    rax,QWORD PTR [r14]
   1839695a2:	4c 89 f1             	mov    rcx,r14
   1839695a5:	ff 10                	call   QWORD PTR [rax]
   1839695a7:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   1839695ac:	75 09                	jne    0x1839695b7
   1839695ae:	49 8b 06             	mov    rax,QWORD PTR [r14]
   1839695b1:	4c 89 f1             	mov    rcx,r14
   1839695b4:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1839695b7:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   1839695be:	00 
   1839695bf:	b9 20 00 00 00       	mov    ecx,0x20
   1839695c4:	e8 d3 22 b4 03       	call   0x1874ab89c
   1839695c9:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   1839695cd:	48 c7 45 e8 13 00 00 	mov    QWORD PTR [rbp-0x18],0x13
   1839695d4:	00 
   1839695d5:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   1839695dc:	00 
   1839695dd:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   1839695e0:	c7 40 0f 64 6c 65 72 	mov    DWORD PTR [rax+0xf],0x72656c64
   1839695e7:	c6 40 13 00          	mov    BYTE PTR [rax+0x13],0x0
   1839695eb:	0f 57 c0             	xorps  xmm0,xmm0
   1839695ee:	0f 29 45 b0          	movaps XMMWORD PTR [rbp-0x50],xmm0
   1839695f2:	48 c7 45 c0 01 00 00 	mov    QWORD PTR [rbp-0x40],0x1
   1839695f9:	00 
   1839695fa:	48 c7 45 c8 0f 00 00 	mov    QWORD PTR [rbp-0x38],0xf
   183969601:	00 
   183969602:	c6 45 b0 33          	mov    BYTE PTR [rbp-0x50],0x33
   183969606:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396960a:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   18396960e:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   183969612:	48 89 f1             	mov    rcx,rsi
   183969615:	e8 d6 7f db fc       	call   0x1807215f0
   18396961a:	90                   	nop
   18396961b:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18396961f:	48 83 f8 10          	cmp    rax,0x10
   183969623:	72 35                	jb     0x18396965a
   183969625:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   183969629:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396962d:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183969634:	72 1f                	jb     0x183969655
   183969636:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396963a:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396963e:	4c 29 c1             	sub    rcx,r8
   183969641:	48 83 f9 20          	cmp    rcx,0x20
   183969645:	0f 83 94 32 00 00    	jae    0x18396c8df
   18396964b:	48 83 c0 28          	add    rax,0x28
   18396964f:	48 89 c2             	mov    rdx,rax
   183969652:	4c 89 c1             	mov    rcx,r8
   183969655:	e8 86 22 b4 03       	call   0x1874ab8e0
   18396965a:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396965e:	48 83 f8 10          	cmp    rax,0x10
   183969662:	72 35                	jb     0x183969699
   183969664:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   183969668:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396966c:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183969673:	72 1f                	jb     0x183969694
   183969675:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183969679:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396967d:	4c 29 c1             	sub    rcx,r8
   183969680:	48 83 f9 20          	cmp    rcx,0x20
   183969684:	0f 83 55 32 00 00    	jae    0x18396c8df
   18396968a:	48 83 c0 28          	add    rax,0x28
   18396968e:	48 89 c2             	mov    rdx,rax
   183969691:	4c 89 c1             	mov    rcx,r8
   183969694:	e8 47 22 b4 03       	call   0x1874ab8e0
   183969699:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   1839696a0:	00 
   1839696a1:	b9 20 00 00 00       	mov    ecx,0x20
   1839696a6:	e8 f1 21 b4 03       	call   0x1874ab89c
   1839696ab:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   1839696af:	48 c7 45 e8 13 00 00 	mov    QWORD PTR [rbp-0x18],0x13
   1839696b6:	00 
   1839696b7:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   1839696be:	00 
   1839696bf:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   1839696c2:	c7 40 0f 64 6c 65 72 	mov    DWORD PTR [rax+0xf],0x72656c64
   1839696c9:	c6 40 13 00          	mov    BYTE PTR [rax+0x13],0x0
   1839696cd:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   1839696d1:	ba 31 00 00 00       	mov    edx,0x31
   1839696d6:	41 b8 02 00 00 00    	mov    r8d,0x2
   1839696dc:	e8 5f fa ff ff       	call   0x183969140
   1839696e1:	90                   	nop
   1839696e2:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   1839696e6:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   1839696ea:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   1839696ee:	48 89 f1             	mov    rcx,rsi
   1839696f1:	e8 fa 7e db fc       	call   0x1807215f0
   1839696f6:	90                   	nop
   1839696f7:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   1839696fb:	48 83 f8 10          	cmp    rax,0x10
   1839696ff:	72 35                	jb     0x183969736
   183969701:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   183969705:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183969709:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183969710:	72 1f                	jb     0x183969731
   183969712:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183969716:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396971a:	4c 29 c1             	sub    rcx,r8
   18396971d:	48 83 f9 20          	cmp    rcx,0x20
   183969721:	0f 83 b8 31 00 00    	jae    0x18396c8df
   183969727:	48 83 c0 28          	add    rax,0x28
   18396972b:	48 89 c2             	mov    rdx,rax
   18396972e:	4c 89 c1             	mov    rcx,r8
   183969731:	e8 aa 21 b4 03       	call   0x1874ab8e0
   183969736:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396973a:	48 83 f8 10          	cmp    rax,0x10
   18396973e:	72 35                	jb     0x183969775
   183969740:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   183969744:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183969748:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396974f:	72 1f                	jb     0x183969770
   183969751:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183969755:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183969759:	4c 29 c1             	sub    rcx,r8
   18396975c:	48 83 f9 20          	cmp    rcx,0x20
   183969760:	0f 83 79 31 00 00    	jae    0x18396c8df
   183969766:	48 83 c0 28          	add    rax,0x28
   18396976a:	48 89 c2             	mov    rdx,rax
   18396976d:	4c 89 c1             	mov    rcx,r8
   183969770:	e8 6b 21 b4 03       	call   0x1874ab8e0
   183969775:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   183969779:	48 89 da             	mov    rdx,rbx
   18396977c:	e8 5f 40 f1 ff       	call   0x18387d7e0
   183969781:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183969788:	00 
   183969789:	b9 20 00 00 00       	mov    ecx,0x20
   18396978e:	e8 09 21 b4 03       	call   0x1874ab89c
   183969793:	90                   	nop
   183969794:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183969798:	48 c7 45 e8 12 00 00 	mov    QWORD PTR [rbp-0x18],0x12
   18396979f:	00 
   1839697a0:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   1839697a7:	00 
   1839697a8:	0f 10 35 31 dd b9 05 	movups xmm6,XMMWORD PTR [rip+0x5b9dd31]        # 0x1895074e0
   1839697af:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   1839697b2:	66 c7 40 10 65 72    	mov    WORD PTR [rax+0x10],0x7265
   1839697b8:	c6 40 12 00          	mov    BYTE PTR [rax+0x12],0x0
   1839697bc:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   1839697c0:	4c 8d 45 d8          	lea    r8,[rbp-0x28]
   1839697c4:	4c 8d 4d b0          	lea    r9,[rbp-0x50]
   1839697c8:	48 89 f9             	mov    rcx,rdi
   1839697cb:	e8 60 29 e9 fd       	call   0x1817fc130
   1839697d0:	90                   	nop
   1839697d1:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   1839697d5:	48 83 f8 10          	cmp    rax,0x10
   1839697d9:	72 35                	jb     0x183969810
   1839697db:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   1839697df:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1839697e3:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1839697ea:	72 1f                	jb     0x18396980b
   1839697ec:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1839697f0:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1839697f4:	4c 29 c1             	sub    rcx,r8
   1839697f7:	48 83 f9 20          	cmp    rcx,0x20
   1839697fb:	0f 83 de 30 00 00    	jae    0x18396c8df
   183969801:	48 83 c0 28          	add    rax,0x28
   183969805:	48 89 c2             	mov    rdx,rax
   183969808:	4c 89 c1             	mov    rcx,r8
   18396980b:	e8 d0 20 b4 03       	call   0x1874ab8e0
   183969810:	4c 8b 75 b8          	mov    r14,QWORD PTR [rbp-0x48]
   183969814:	4d 85 f6             	test   r14,r14
   183969817:	74 1f                	je     0x183969838
   183969819:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   18396981e:	75 18                	jne    0x183969838
   183969820:	49 8b 06             	mov    rax,QWORD PTR [r14]
   183969823:	4c 89 f1             	mov    rcx,r14
   183969826:	ff 10                	call   QWORD PTR [rax]
   183969828:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   18396982d:	75 09                	jne    0x183969838
   18396982f:	49 8b 06             	mov    rax,QWORD PTR [r14]
   183969832:	4c 89 f1             	mov    rcx,r14
   183969835:	ff 50 08             	call   QWORD PTR [rax+0x8]
   183969838:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396983f:	00 
   183969840:	b9 20 00 00 00       	mov    ecx,0x20
   183969845:	e8 52 20 b4 03       	call   0x1874ab89c
   18396984a:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396984e:	48 c7 45 e8 12 00 00 	mov    QWORD PTR [rbp-0x18],0x12
   183969855:	00 
   183969856:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18396985d:	00 
   18396985e:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   183969861:	66 c7 40 10 65 72    	mov    WORD PTR [rax+0x10],0x7265
   183969867:	c6 40 12 00          	mov    BYTE PTR [rax+0x12],0x0
   18396986b:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   18396986f:	ba 31 00 00 00       	mov    edx,0x31
   183969874:	41 b8 06 00 00 00    	mov    r8d,0x6
   18396987a:	e8 c1 f8 ff ff       	call   0x183969140
   18396987f:	90                   	nop
   183969880:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183969884:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   183969888:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18396988c:	48 89 f1             	mov    rcx,rsi
   18396988f:	e8 5c 7d db fc       	call   0x1807215f0
   183969894:	90                   	nop
   183969895:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   183969899:	48 83 f8 10          	cmp    rax,0x10
   18396989d:	72 35                	jb     0x1839698d4
   18396989f:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   1839698a3:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1839698a7:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1839698ae:	72 1f                	jb     0x1839698cf
   1839698b0:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1839698b4:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1839698b8:	4c 29 c1             	sub    rcx,r8
   1839698bb:	48 83 f9 20          	cmp    rcx,0x20
   1839698bf:	0f 83 1a 30 00 00    	jae    0x18396c8df
   1839698c5:	48 83 c0 28          	add    rax,0x28
   1839698c9:	48 89 c2             	mov    rdx,rax
   1839698cc:	4c 89 c1             	mov    rcx,r8
   1839698cf:	e8 0c 20 b4 03       	call   0x1874ab8e0
   1839698d4:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   1839698d8:	48 83 f8 10          	cmp    rax,0x10
   1839698dc:	72 35                	jb     0x183969913
   1839698de:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   1839698e2:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1839698e6:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1839698ed:	72 1f                	jb     0x18396990e
   1839698ef:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1839698f3:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1839698f7:	4c 29 c1             	sub    rcx,r8
   1839698fa:	48 83 f9 20          	cmp    rcx,0x20
   1839698fe:	0f 83 db 2f 00 00    	jae    0x18396c8df
   183969904:	48 83 c0 28          	add    rax,0x28
   183969908:	48 89 c2             	mov    rdx,rax
   18396990b:	4c 89 c1             	mov    rcx,r8
   18396990e:	e8 cd 1f b4 03       	call   0x1874ab8e0
   183969913:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396991a:	00 
   18396991b:	b9 20 00 00 00       	mov    ecx,0x20
   183969920:	e8 77 1f b4 03       	call   0x1874ab89c
   183969925:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183969929:	48 c7 45 e8 12 00 00 	mov    QWORD PTR [rbp-0x18],0x12
   183969930:	00 
   183969931:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183969938:	00 
   183969939:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   18396993c:	66 c7 40 10 65 72    	mov    WORD PTR [rax+0x10],0x7265
   183969942:	c6 40 12 00          	mov    BYTE PTR [rax+0x12],0x0
   183969946:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   18396994a:	ba 31 00 00 00       	mov    edx,0x31
   18396994f:	41 b8 4a 00 00 00    	mov    r8d,0x4a
   183969955:	e8 e6 f7 ff ff       	call   0x183969140
   18396995a:	90                   	nop
   18396995b:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396995f:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   183969963:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   183969967:	48 89 f1             	mov    rcx,rsi
   18396996a:	e8 81 7c db fc       	call   0x1807215f0
   18396996f:	90                   	nop
   183969970:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   183969974:	48 83 f8 10          	cmp    rax,0x10
   183969978:	72 35                	jb     0x1839699af
   18396997a:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18396997e:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183969982:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183969989:	72 1f                	jb     0x1839699aa
   18396998b:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396998f:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183969993:	4c 29 c1             	sub    rcx,r8
   183969996:	48 83 f9 20          	cmp    rcx,0x20
   18396999a:	0f 83 3f 2f 00 00    	jae    0x18396c8df
   1839699a0:	48 83 c0 28          	add    rax,0x28
   1839699a4:	48 89 c2             	mov    rdx,rax
   1839699a7:	4c 89 c1             	mov    rcx,r8
   1839699aa:	e8 31 1f b4 03       	call   0x1874ab8e0
   1839699af:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   1839699b3:	48 83 f8 10          	cmp    rax,0x10
   1839699b7:	72 35                	jb     0x1839699ee
   1839699b9:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   1839699bd:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1839699c1:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1839699c8:	72 1f                	jb     0x1839699e9
   1839699ca:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1839699ce:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1839699d2:	4c 29 c1             	sub    rcx,r8
   1839699d5:	48 83 f9 20          	cmp    rcx,0x20
   1839699d9:	0f 83 00 2f 00 00    	jae    0x18396c8df
   1839699df:	48 83 c0 28          	add    rax,0x28
   1839699e3:	48 89 c2             	mov    rdx,rax
   1839699e6:	4c 89 c1             	mov    rcx,r8
   1839699e9:	e8 f2 1e b4 03       	call   0x1874ab8e0
   1839699ee:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   1839699f5:	00 
   1839699f6:	b9 20 00 00 00       	mov    ecx,0x20
   1839699fb:	e8 9c 1e b4 03       	call   0x1874ab89c
   183969a00:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183969a04:	48 c7 45 e8 12 00 00 	mov    QWORD PTR [rbp-0x18],0x12
   183969a0b:	00 
   183969a0c:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183969a13:	00 
   183969a14:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   183969a17:	66 c7 40 10 65 72    	mov    WORD PTR [rax+0x10],0x7265
   183969a1d:	c6 40 12 00          	mov    BYTE PTR [rax+0x12],0x0
   183969a21:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   183969a25:	ba 31 00 00 00       	mov    edx,0x31
   183969a2a:	41 b8 82 00 00 00    	mov    r8d,0x82
   183969a30:	e8 0b f7 ff ff       	call   0x183969140
   183969a35:	90                   	nop
   183969a36:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183969a3a:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   183969a3e:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   183969a42:	48 89 f1             	mov    rcx,rsi
   183969a45:	e8 a6 7b db fc       	call   0x1807215f0
   183969a4a:	90                   	nop
   183969a4b:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   183969a4f:	48 83 f8 10          	cmp    rax,0x10
   183969a53:	72 35                	jb     0x183969a8a
   183969a55:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   183969a59:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183969a5d:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183969a64:	72 1f                	jb     0x183969a85
   183969a66:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183969a6a:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183969a6e:	4c 29 c1             	sub    rcx,r8
   183969a71:	48 83 f9 20          	cmp    rcx,0x20
   183969a75:	0f 83 64 2e 00 00    	jae    0x18396c8df
   183969a7b:	48 83 c0 28          	add    rax,0x28
   183969a7f:	48 89 c2             	mov    rdx,rax
   183969a82:	4c 89 c1             	mov    rcx,r8
   183969a85:	e8 56 1e b4 03       	call   0x1874ab8e0
   183969a8a:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   183969a8e:	48 83 f8 10          	cmp    rax,0x10
   183969a92:	72 35                	jb     0x183969ac9
   183969a94:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   183969a98:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183969a9c:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183969aa3:	72 1f                	jb     0x183969ac4
   183969aa5:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183969aa9:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183969aad:	4c 29 c1             	sub    rcx,r8
   183969ab0:	48 83 f9 20          	cmp    rcx,0x20
   183969ab4:	0f 83 25 2e 00 00    	jae    0x18396c8df
   183969aba:	48 83 c0 28          	add    rax,0x28
   183969abe:	48 89 c2             	mov    rdx,rax
   183969ac1:	4c 89 c1             	mov    rcx,r8
   183969ac4:	e8 17 1e b4 03       	call   0x1874ab8e0
   183969ac9:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183969ad0:	00 
   183969ad1:	b9 20 00 00 00       	mov    ecx,0x20
   183969ad6:	e8 c1 1d b4 03       	call   0x1874ab89c
   183969adb:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183969adf:	48 c7 45 e8 12 00 00 	mov    QWORD PTR [rbp-0x18],0x12
   183969ae6:	00 
   183969ae7:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183969aee:	00 
   183969aef:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   183969af2:	66 c7 40 10 65 72    	mov    WORD PTR [rax+0x10],0x7265
   183969af8:	c6 40 12 00          	mov    BYTE PTR [rax+0x12],0x0
   183969afc:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   183969b00:	ba 31 00 00 00       	mov    edx,0x31
   183969b05:	41 b8 83 00 00 00    	mov    r8d,0x83
   183969b0b:	e8 30 f6 ff ff       	call   0x183969140
   183969b10:	90                   	nop
   183969b11:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183969b15:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   183969b19:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   183969b1d:	48 89 f1             	mov    rcx,rsi
   183969b20:	e8 cb 7a db fc       	call   0x1807215f0
   183969b25:	90                   	nop
   183969b26:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   183969b2a:	48 83 f8 10          	cmp    rax,0x10
   183969b2e:	72 35                	jb     0x183969b65
   183969b30:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   183969b34:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183969b38:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183969b3f:	72 1f                	jb     0x183969b60
   183969b41:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183969b45:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183969b49:	4c 29 c1             	sub    rcx,r8
   183969b4c:	48 83 f9 20          	cmp    rcx,0x20
   183969b50:	0f 83 89 2d 00 00    	jae    0x18396c8df
   183969b56:	48 83 c0 28          	add    rax,0x28
   183969b5a:	48 89 c2             	mov    rdx,rax
   183969b5d:	4c 89 c1             	mov    rcx,r8
   183969b60:	e8 7b 1d b4 03       	call   0x1874ab8e0
   183969b65:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   183969b69:	48 83 f8 10          	cmp    rax,0x10
   183969b6d:	72 35                	jb     0x183969ba4
   183969b6f:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   183969b73:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183969b77:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183969b7e:	72 1f                	jb     0x183969b9f
   183969b80:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183969b84:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183969b88:	4c 29 c1             	sub    rcx,r8
   183969b8b:	48 83 f9 20          	cmp    rcx,0x20
   183969b8f:	0f 83 4a 2d 00 00    	jae    0x18396c8df
   183969b95:	48 83 c0 28          	add    rax,0x28
   183969b99:	48 89 c2             	mov    rdx,rax
   183969b9c:	4c 89 c1             	mov    rcx,r8
   183969b9f:	e8 3c 1d b4 03       	call   0x1874ab8e0
   183969ba4:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   183969ba8:	48 89 da             	mov    rdx,rbx
   183969bab:	e8 50 3d f1 ff       	call   0x18387d900
   183969bb0:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183969bb7:	00 
   183969bb8:	b9 20 00 00 00       	mov    ecx,0x20
   183969bbd:	e8 da 1c b4 03       	call   0x1874ab89c
   183969bc2:	90                   	nop
   183969bc3:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183969bc7:	48 c7 45 e8 13 00 00 	mov    QWORD PTR [rbp-0x18],0x13
   183969bce:	00 
   183969bcf:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183969bd6:	00 
   183969bd7:	0f 10 35 1a d9 b9 05 	movups xmm6,XMMWORD PTR [rip+0x5b9d91a]        # 0x1895074f8
   183969bde:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   183969be1:	c7 40 0f 64 6c 65 72 	mov    DWORD PTR [rax+0xf],0x72656c64
   183969be8:	c6 40 13 00          	mov    BYTE PTR [rax+0x13],0x0
   183969bec:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183969bf0:	4c 8d 45 d8          	lea    r8,[rbp-0x28]
   183969bf4:	4c 8d 4d b0          	lea    r9,[rbp-0x50]
   183969bf8:	48 89 f9             	mov    rcx,rdi
   183969bfb:	e8 30 25 e9 fd       	call   0x1817fc130
   183969c00:	90                   	nop
   183969c01:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   183969c05:	48 83 f8 10          	cmp    rax,0x10
   183969c09:	72 35                	jb     0x183969c40
   183969c0b:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   183969c0f:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183969c13:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183969c1a:	72 1f                	jb     0x183969c3b
   183969c1c:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183969c20:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183969c24:	4c 29 c1             	sub    rcx,r8
   183969c27:	48 83 f9 20          	cmp    rcx,0x20
   183969c2b:	0f 83 ae 2c 00 00    	jae    0x18396c8df
   183969c31:	48 83 c0 28          	add    rax,0x28
   183969c35:	48 89 c2             	mov    rdx,rax
   183969c38:	4c 89 c1             	mov    rcx,r8
   183969c3b:	e8 a0 1c b4 03       	call   0x1874ab8e0
   183969c40:	4c 8b 75 b8          	mov    r14,QWORD PTR [rbp-0x48]
   183969c44:	4d 85 f6             	test   r14,r14
   183969c47:	74 1f                	je     0x183969c68
   183969c49:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   183969c4e:	75 18                	jne    0x183969c68
   183969c50:	49 8b 06             	mov    rax,QWORD PTR [r14]
   183969c53:	4c 89 f1             	mov    rcx,r14
   183969c56:	ff 10                	call   QWORD PTR [rax]
   183969c58:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   183969c5d:	75 09                	jne    0x183969c68
   183969c5f:	49 8b 06             	mov    rax,QWORD PTR [r14]
   183969c62:	4c 89 f1             	mov    rcx,r14
   183969c65:	ff 50 08             	call   QWORD PTR [rax+0x8]
   183969c68:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183969c6f:	00 
   183969c70:	b9 20 00 00 00       	mov    ecx,0x20
   183969c75:	e8 22 1c b4 03       	call   0x1874ab89c
   183969c7a:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183969c7e:	48 c7 45 e8 13 00 00 	mov    QWORD PTR [rbp-0x18],0x13
   183969c85:	00 
   183969c86:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183969c8d:	00 
   183969c8e:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   183969c91:	c7 40 0f 64 6c 65 72 	mov    DWORD PTR [rax+0xf],0x72656c64
   183969c98:	c6 40 13 00          	mov    BYTE PTR [rax+0x13],0x0
   183969c9c:	0f 57 c0             	xorps  xmm0,xmm0
   183969c9f:	0f 29 45 b0          	movaps XMMWORD PTR [rbp-0x50],xmm0
   183969ca3:	48 c7 45 c0 02 00 00 	mov    QWORD PTR [rbp-0x40],0x2
   183969caa:	00 
   183969cab:	48 c7 45 c8 0f 00 00 	mov    QWORD PTR [rbp-0x38],0xf
   183969cb2:	00 
   183969cb3:	66 c7 45 b0 34 33    	mov    WORD PTR [rbp-0x50],0x3334
   183969cb9:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183969cbd:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   183969cc1:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   183969cc5:	48 89 f1             	mov    rcx,rsi
   183969cc8:	e8 23 79 db fc       	call   0x1807215f0
   183969ccd:	90                   	nop
   183969cce:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   183969cd2:	48 83 f8 10          	cmp    rax,0x10
   183969cd6:	72 35                	jb     0x183969d0d
   183969cd8:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   183969cdc:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183969ce0:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183969ce7:	72 1f                	jb     0x183969d08
   183969ce9:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183969ced:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183969cf1:	4c 29 c1             	sub    rcx,r8
   183969cf4:	48 83 f9 20          	cmp    rcx,0x20
   183969cf8:	0f 83 e1 2b 00 00    	jae    0x18396c8df
   183969cfe:	48 83 c0 28          	add    rax,0x28
   183969d02:	48 89 c2             	mov    rdx,rax
   183969d05:	4c 89 c1             	mov    rcx,r8
   183969d08:	e8 d3 1b b4 03       	call   0x1874ab8e0
   183969d0d:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   183969d11:	48 83 f8 10          	cmp    rax,0x10
   183969d15:	72 35                	jb     0x183969d4c
   183969d17:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   183969d1b:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183969d1f:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183969d26:	72 1f                	jb     0x183969d47
   183969d28:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183969d2c:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183969d30:	4c 29 c1             	sub    rcx,r8
   183969d33:	48 83 f9 20          	cmp    rcx,0x20
   183969d37:	0f 83 a2 2b 00 00    	jae    0x18396c8df
   183969d3d:	48 83 c0 28          	add    rax,0x28
   183969d41:	48 89 c2             	mov    rdx,rax
   183969d44:	4c 89 c1             	mov    rcx,r8
   183969d47:	e8 94 1b b4 03       	call   0x1874ab8e0
   183969d4c:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   183969d50:	48 89 da             	mov    rdx,rbx
   183969d53:	e8 58 3d f1 ff       	call   0x18387dab0
   183969d58:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183969d5f:	00 
   183969d60:	b9 20 00 00 00       	mov    ecx,0x20
   183969d65:	e8 32 1b b4 03       	call   0x1874ab89c
   183969d6a:	90                   	nop
   183969d6b:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183969d6f:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   183969d76:	00 
   183969d77:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183969d7e:	00 
   183969d7f:	44 0f 10 05 89 d7 b9 	movups xmm8,XMMWORD PTR [rip+0x5b9d789]        # 0x189507510
   183969d86:	05 
   183969d87:	44 0f 11 00          	movups XMMWORD PTR [rax],xmm8
   183969d8b:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   183969d91:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183969d95:	4c 8d 45 d8          	lea    r8,[rbp-0x28]
   183969d99:	4c 8d 4d b0          	lea    r9,[rbp-0x50]
   183969d9d:	48 89 f9             	mov    rcx,rdi
   183969da0:	e8 8b 23 e9 fd       	call   0x1817fc130
   183969da5:	90                   	nop
   183969da6:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   183969daa:	48 83 f8 10          	cmp    rax,0x10
   183969dae:	72 35                	jb     0x183969de5
   183969db0:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   183969db4:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183969db8:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183969dbf:	72 1f                	jb     0x183969de0
   183969dc1:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183969dc5:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183969dc9:	4c 29 c1             	sub    rcx,r8
   183969dcc:	48 83 f9 20          	cmp    rcx,0x20
   183969dd0:	0f 83 09 2b 00 00    	jae    0x18396c8df
   183969dd6:	48 83 c0 28          	add    rax,0x28
   183969dda:	48 89 c2             	mov    rdx,rax
   183969ddd:	4c 89 c1             	mov    rcx,r8
   183969de0:	e8 fb 1a b4 03       	call   0x1874ab8e0
   183969de5:	4c 8b 75 b8          	mov    r14,QWORD PTR [rbp-0x48]
   183969de9:	4d 85 f6             	test   r14,r14
   183969dec:	74 1f                	je     0x183969e0d
   183969dee:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   183969df3:	75 18                	jne    0x183969e0d
   183969df5:	49 8b 06             	mov    rax,QWORD PTR [r14]
   183969df8:	4c 89 f1             	mov    rcx,r14
   183969dfb:	ff 10                	call   QWORD PTR [rax]
   183969dfd:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   183969e02:	75 09                	jne    0x183969e0d
   183969e04:	49 8b 06             	mov    rax,QWORD PTR [r14]
   183969e07:	4c 89 f1             	mov    rcx,r14
   183969e0a:	ff 50 08             	call   QWORD PTR [rax+0x8]
   183969e0d:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   183969e11:	48 89 da             	mov    rdx,rbx
   183969e14:	e8 b7 3d f1 ff       	call   0x18387dbd0
   183969e19:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183969e20:	00 
   183969e21:	b9 20 00 00 00       	mov    ecx,0x20
   183969e26:	e8 71 1a b4 03       	call   0x1874ab89c
   183969e2b:	90                   	nop
   183969e2c:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183969e30:	48 c7 45 e8 17 00 00 	mov    QWORD PTR [rbp-0x18],0x17
   183969e37:	00 
   183969e38:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183969e3f:	00 
   183969e40:	44 0f 10 0d e0 d6 b9 	movups xmm9,XMMWORD PTR [rip+0x5b9d6e0]        # 0x189507528
   183969e47:	05 
   183969e48:	44 0f 11 08          	movups XMMWORD PTR [rax],xmm9
   183969e4c:	49 bf 65 48 61 6e 64 	movabs r15,0x72656c646e614865
   183969e53:	6c 65 72 
   183969e56:	4c 89 78 0f          	mov    QWORD PTR [rax+0xf],r15
   183969e5a:	c6 40 17 00          	mov    BYTE PTR [rax+0x17],0x0
   183969e5e:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183969e62:	4c 8d 45 d8          	lea    r8,[rbp-0x28]
   183969e66:	4c 8d 4d b0          	lea    r9,[rbp-0x50]
   183969e6a:	48 89 f9             	mov    rcx,rdi
   183969e6d:	e8 be 22 e9 fd       	call   0x1817fc130
   183969e72:	90                   	nop
   183969e73:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   183969e77:	48 83 f8 10          	cmp    rax,0x10
   183969e7b:	72 35                	jb     0x183969eb2
   183969e7d:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   183969e81:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183969e85:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183969e8c:	72 1f                	jb     0x183969ead
   183969e8e:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183969e92:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183969e96:	4c 29 c1             	sub    rcx,r8
   183969e99:	48 83 f9 20          	cmp    rcx,0x20
   183969e9d:	0f 83 3c 2a 00 00    	jae    0x18396c8df
   183969ea3:	48 83 c0 28          	add    rax,0x28
   183969ea7:	48 89 c2             	mov    rdx,rax
   183969eaa:	4c 89 c1             	mov    rcx,r8
   183969ead:	e8 2e 1a b4 03       	call   0x1874ab8e0
   183969eb2:	4c 8b 75 b8          	mov    r14,QWORD PTR [rbp-0x48]
   183969eb6:	4d 85 f6             	test   r14,r14
   183969eb9:	74 1f                	je     0x183969eda
   183969ebb:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   183969ec0:	75 18                	jne    0x183969eda
   183969ec2:	49 8b 06             	mov    rax,QWORD PTR [r14]
   183969ec5:	4c 89 f1             	mov    rcx,r14
   183969ec8:	ff 10                	call   QWORD PTR [rax]
   183969eca:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   183969ecf:	75 09                	jne    0x183969eda
   183969ed1:	49 8b 06             	mov    rax,QWORD PTR [r14]
   183969ed4:	4c 89 f1             	mov    rcx,r14
   183969ed7:	ff 50 08             	call   QWORD PTR [rax+0x8]
   183969eda:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   183969ede:	48 89 da             	mov    rdx,rbx
   183969ee1:	e8 3a 5d 00 00       	call   0x18396fc20
   183969ee6:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183969eed:	00 
   183969eee:	b9 20 00 00 00       	mov    ecx,0x20
   183969ef3:	e8 a4 19 b4 03       	call   0x1874ab89c
   183969ef8:	90                   	nop
   183969ef9:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183969efd:	48 c7 45 e8 17 00 00 	mov    QWORD PTR [rbp-0x18],0x17
   183969f04:	00 
   183969f05:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183969f0c:	00 
   183969f0d:	44 0f 10 15 2b d6 b9 	movups xmm10,XMMWORD PTR [rip+0x5b9d62b]        # 0x189507540
   183969f14:	05 
   183969f15:	44 0f 11 10          	movups XMMWORD PTR [rax],xmm10
   183969f19:	4c 89 78 0f          	mov    QWORD PTR [rax+0xf],r15
   183969f1d:	c6 40 17 00          	mov    BYTE PTR [rax+0x17],0x0
   183969f21:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183969f25:	4c 8d 45 d8          	lea    r8,[rbp-0x28]
   183969f29:	4c 8d 4d b0          	lea    r9,[rbp-0x50]
   183969f2d:	48 89 f9             	mov    rcx,rdi
   183969f30:	e8 fb 21 e9 fd       	call   0x1817fc130
   183969f35:	90                   	nop
   183969f36:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   183969f3a:	48 83 f8 10          	cmp    rax,0x10
   183969f3e:	72 35                	jb     0x183969f75
   183969f40:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   183969f44:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183969f48:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183969f4f:	72 1f                	jb     0x183969f70
   183969f51:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183969f55:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183969f59:	4c 29 c1             	sub    rcx,r8
   183969f5c:	48 83 f9 20          	cmp    rcx,0x20
   183969f60:	0f 83 79 29 00 00    	jae    0x18396c8df
   183969f66:	48 83 c0 28          	add    rax,0x28
   183969f6a:	48 89 c2             	mov    rdx,rax
   183969f6d:	4c 89 c1             	mov    rcx,r8
   183969f70:	e8 6b 19 b4 03       	call   0x1874ab8e0
   183969f75:	4c 8b 75 b8          	mov    r14,QWORD PTR [rbp-0x48]
   183969f79:	4d 85 f6             	test   r14,r14
   183969f7c:	74 1f                	je     0x183969f9d
   183969f7e:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   183969f83:	75 18                	jne    0x183969f9d
   183969f85:	49 8b 06             	mov    rax,QWORD PTR [r14]
   183969f88:	4c 89 f1             	mov    rcx,r14
   183969f8b:	ff 10                	call   QWORD PTR [rax]
   183969f8d:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   183969f92:	75 09                	jne    0x183969f9d
   183969f94:	49 8b 06             	mov    rax,QWORD PTR [r14]
   183969f97:	4c 89 f1             	mov    rcx,r14
   183969f9a:	ff 50 08             	call   QWORD PTR [rax+0x8]
   183969f9d:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   183969fa1:	48 89 da             	mov    rdx,rbx
   183969fa4:	e8 97 5d 00 00       	call   0x18396fd40
   183969fa9:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183969fb0:	00 
   183969fb1:	b9 20 00 00 00       	mov    ecx,0x20
   183969fb6:	e8 e1 18 b4 03       	call   0x1874ab89c
   183969fbb:	90                   	nop
   183969fbc:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183969fc0:	48 c7 45 e8 1d 00 00 	mov    QWORD PTR [rbp-0x18],0x1d
   183969fc7:	00 
   183969fc8:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183969fcf:	00 
   183969fd0:	0f 10 35 8e d5 b9 05 	movups xmm6,XMMWORD PTR [rip+0x5b9d58e]        # 0x189507565
   183969fd7:	0f 11 70 0d          	movups XMMWORD PTR [rax+0xd],xmm6
   183969fdb:	0f 10 3d 76 d5 b9 05 	movups xmm7,XMMWORD PTR [rip+0x5b9d576]        # 0x189507558
   183969fe2:	0f 11 38             	movups XMMWORD PTR [rax],xmm7
   183969fe5:	c6 40 1d 00          	mov    BYTE PTR [rax+0x1d],0x0
   183969fe9:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183969fed:	4c 8d 45 d8          	lea    r8,[rbp-0x28]
   183969ff1:	4c 8d 4d b0          	lea    r9,[rbp-0x50]
   183969ff5:	48 89 f9             	mov    rcx,rdi
   183969ff8:	e8 33 21 e9 fd       	call   0x1817fc130
   183969ffd:	90                   	nop
   183969ffe:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396a002:	48 83 f8 10          	cmp    rax,0x10
   18396a006:	72 35                	jb     0x18396a03d
   18396a008:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396a00c:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396a010:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396a017:	72 1f                	jb     0x18396a038
   18396a019:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396a01d:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396a021:	4c 29 c1             	sub    rcx,r8
   18396a024:	48 83 f9 20          	cmp    rcx,0x20
   18396a028:	0f 83 b1 28 00 00    	jae    0x18396c8df
   18396a02e:	48 83 c0 28          	add    rax,0x28
   18396a032:	48 89 c2             	mov    rdx,rax
   18396a035:	4c 89 c1             	mov    rcx,r8
   18396a038:	e8 a3 18 b4 03       	call   0x1874ab8e0
   18396a03d:	4c 8b 75 b8          	mov    r14,QWORD PTR [rbp-0x48]
   18396a041:	4d 85 f6             	test   r14,r14
   18396a044:	74 1f                	je     0x18396a065
   18396a046:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   18396a04b:	75 18                	jne    0x18396a065
   18396a04d:	49 8b 06             	mov    rax,QWORD PTR [r14]
   18396a050:	4c 89 f1             	mov    rcx,r14
   18396a053:	ff 10                	call   QWORD PTR [rax]
   18396a055:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   18396a05a:	75 09                	jne    0x18396a065
   18396a05c:	49 8b 06             	mov    rax,QWORD PTR [r14]
   18396a05f:	4c 89 f1             	mov    rcx,r14
   18396a062:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18396a065:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396a06c:	00 
   18396a06d:	b9 20 00 00 00       	mov    ecx,0x20
   18396a072:	e8 25 18 b4 03       	call   0x1874ab89c
   18396a077:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396a07b:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   18396a082:	00 
   18396a083:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18396a08a:	00 
   18396a08b:	44 0f 11 00          	movups XMMWORD PTR [rax],xmm8
   18396a08f:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   18396a095:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   18396a099:	ba 31 00 00 00       	mov    edx,0x31
   18396a09e:	41 b8 01 00 00 00    	mov    r8d,0x1
   18396a0a4:	e8 97 f0 ff ff       	call   0x183969140
   18396a0a9:	90                   	nop
   18396a0aa:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396a0ae:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   18396a0b2:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18396a0b6:	48 89 f1             	mov    rcx,rsi
   18396a0b9:	e8 32 75 db fc       	call   0x1807215f0
   18396a0be:	90                   	nop
   18396a0bf:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18396a0c3:	48 83 f8 10          	cmp    rax,0x10
   18396a0c7:	72 35                	jb     0x18396a0fe
   18396a0c9:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18396a0cd:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396a0d1:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396a0d8:	72 1f                	jb     0x18396a0f9
   18396a0da:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396a0de:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396a0e2:	4c 29 c1             	sub    rcx,r8
   18396a0e5:	48 83 f9 20          	cmp    rcx,0x20
   18396a0e9:	0f 83 f0 27 00 00    	jae    0x18396c8df
   18396a0ef:	48 83 c0 28          	add    rax,0x28
   18396a0f3:	48 89 c2             	mov    rdx,rax
   18396a0f6:	4c 89 c1             	mov    rcx,r8
   18396a0f9:	e8 e2 17 b4 03       	call   0x1874ab8e0
   18396a0fe:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396a102:	48 83 f8 10          	cmp    rax,0x10
   18396a106:	72 35                	jb     0x18396a13d
   18396a108:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396a10c:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396a110:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396a117:	72 1f                	jb     0x18396a138
   18396a119:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396a11d:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396a121:	4c 29 c1             	sub    rcx,r8
   18396a124:	48 83 f9 20          	cmp    rcx,0x20
   18396a128:	0f 83 b1 27 00 00    	jae    0x18396c8df
   18396a12e:	48 83 c0 28          	add    rax,0x28
   18396a132:	48 89 c2             	mov    rdx,rax
   18396a135:	4c 89 c1             	mov    rcx,r8
   18396a138:	e8 a3 17 b4 03       	call   0x1874ab8e0
   18396a13d:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396a144:	00 
   18396a145:	b9 20 00 00 00       	mov    ecx,0x20
   18396a14a:	e8 4d 17 b4 03       	call   0x1874ab89c
   18396a14f:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396a153:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   18396a15a:	00 
   18396a15b:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18396a162:	00 
   18396a163:	44 0f 11 00          	movups XMMWORD PTR [rax],xmm8
   18396a167:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   18396a16d:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   18396a171:	ba 31 00 00 00       	mov    edx,0x31
   18396a176:	41 b8 8b 00 00 00    	mov    r8d,0x8b
   18396a17c:	e8 bf ef ff ff       	call   0x183969140
   18396a181:	90                   	nop
   18396a182:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396a186:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   18396a18a:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18396a18e:	48 89 f1             	mov    rcx,rsi
   18396a191:	e8 5a 74 db fc       	call   0x1807215f0
   18396a196:	90                   	nop
   18396a197:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18396a19b:	48 83 f8 10          	cmp    rax,0x10
   18396a19f:	72 35                	jb     0x18396a1d6
   18396a1a1:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18396a1a5:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396a1a9:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396a1b0:	72 1f                	jb     0x18396a1d1
   18396a1b2:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396a1b6:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396a1ba:	4c 29 c1             	sub    rcx,r8
   18396a1bd:	48 83 f9 20          	cmp    rcx,0x20
   18396a1c1:	0f 83 18 27 00 00    	jae    0x18396c8df
   18396a1c7:	48 83 c0 28          	add    rax,0x28
   18396a1cb:	48 89 c2             	mov    rdx,rax
   18396a1ce:	4c 89 c1             	mov    rcx,r8
   18396a1d1:	e8 0a 17 b4 03       	call   0x1874ab8e0
   18396a1d6:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396a1da:	48 83 f8 10          	cmp    rax,0x10
   18396a1de:	72 35                	jb     0x18396a215
   18396a1e0:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396a1e4:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396a1e8:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396a1ef:	72 1f                	jb     0x18396a210
   18396a1f1:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396a1f5:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396a1f9:	4c 29 c1             	sub    rcx,r8
   18396a1fc:	48 83 f9 20          	cmp    rcx,0x20
   18396a200:	0f 83 d9 26 00 00    	jae    0x18396c8df
   18396a206:	48 83 c0 28          	add    rax,0x28
   18396a20a:	48 89 c2             	mov    rdx,rax
   18396a20d:	4c 89 c1             	mov    rcx,r8
   18396a210:	e8 cb 16 b4 03       	call   0x1874ab8e0
   18396a215:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396a21c:	00 
   18396a21d:	b9 20 00 00 00       	mov    ecx,0x20
   18396a222:	e8 75 16 b4 03       	call   0x1874ab89c
   18396a227:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396a22b:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   18396a232:	00 
   18396a233:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18396a23a:	00 
   18396a23b:	44 0f 11 00          	movups XMMWORD PTR [rax],xmm8
   18396a23f:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   18396a245:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   18396a249:	ba 31 00 00 00       	mov    edx,0x31
   18396a24e:	41 b8 04 00 00 00    	mov    r8d,0x4
   18396a254:	e8 e7 ee ff ff       	call   0x183969140
   18396a259:	90                   	nop
   18396a25a:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396a25e:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   18396a262:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18396a266:	48 89 f1             	mov    rcx,rsi
   18396a269:	e8 82 73 db fc       	call   0x1807215f0
   18396a26e:	90                   	nop
   18396a26f:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18396a273:	48 83 f8 10          	cmp    rax,0x10
   18396a277:	72 35                	jb     0x18396a2ae
   18396a279:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18396a27d:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396a281:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396a288:	72 1f                	jb     0x18396a2a9
   18396a28a:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396a28e:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396a292:	4c 29 c1             	sub    rcx,r8
   18396a295:	48 83 f9 20          	cmp    rcx,0x20
   18396a299:	0f 83 40 26 00 00    	jae    0x18396c8df
   18396a29f:	48 83 c0 28          	add    rax,0x28
   18396a2a3:	48 89 c2             	mov    rdx,rax
   18396a2a6:	4c 89 c1             	mov    rcx,r8
   18396a2a9:	e8 32 16 b4 03       	call   0x1874ab8e0
   18396a2ae:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396a2b2:	48 83 f8 10          	cmp    rax,0x10
   18396a2b6:	72 35                	jb     0x18396a2ed
   18396a2b8:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396a2bc:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396a2c0:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396a2c7:	72 1f                	jb     0x18396a2e8
   18396a2c9:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396a2cd:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396a2d1:	4c 29 c1             	sub    rcx,r8
   18396a2d4:	48 83 f9 20          	cmp    rcx,0x20
   18396a2d8:	0f 83 01 26 00 00    	jae    0x18396c8df
   18396a2de:	48 83 c0 28          	add    rax,0x28
   18396a2e2:	48 89 c2             	mov    rdx,rax
   18396a2e5:	4c 89 c1             	mov    rcx,r8
   18396a2e8:	e8 f3 15 b4 03       	call   0x1874ab8e0
   18396a2ed:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396a2f4:	00 
   18396a2f5:	b9 20 00 00 00       	mov    ecx,0x20
   18396a2fa:	e8 9d 15 b4 03       	call   0x1874ab89c
   18396a2ff:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396a303:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   18396a30a:	00 
   18396a30b:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18396a312:	00 
   18396a313:	44 0f 11 00          	movups XMMWORD PTR [rax],xmm8
   18396a317:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   18396a31d:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   18396a321:	ba 31 00 00 00       	mov    edx,0x31
   18396a326:	41 b8 05 00 00 00    	mov    r8d,0x5
   18396a32c:	e8 0f ee ff ff       	call   0x183969140
   18396a331:	90                   	nop
   18396a332:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396a336:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   18396a33a:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18396a33e:	48 89 f1             	mov    rcx,rsi
   18396a341:	e8 aa 72 db fc       	call   0x1807215f0
   18396a346:	90                   	nop
   18396a347:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18396a34b:	48 83 f8 10          	cmp    rax,0x10
   18396a34f:	72 35                	jb     0x18396a386
   18396a351:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18396a355:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396a359:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396a360:	72 1f                	jb     0x18396a381
   18396a362:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396a366:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396a36a:	4c 29 c1             	sub    rcx,r8
   18396a36d:	48 83 f9 20          	cmp    rcx,0x20
   18396a371:	0f 83 68 25 00 00    	jae    0x18396c8df
   18396a377:	48 83 c0 28          	add    rax,0x28
   18396a37b:	48 89 c2             	mov    rdx,rax
   18396a37e:	4c 89 c1             	mov    rcx,r8
   18396a381:	e8 5a 15 b4 03       	call   0x1874ab8e0
   18396a386:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396a38a:	48 83 f8 10          	cmp    rax,0x10
   18396a38e:	72 35                	jb     0x18396a3c5
   18396a390:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396a394:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396a398:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396a39f:	72 1f                	jb     0x18396a3c0
   18396a3a1:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396a3a5:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396a3a9:	4c 29 c1             	sub    rcx,r8
   18396a3ac:	48 83 f9 20          	cmp    rcx,0x20
   18396a3b0:	0f 83 29 25 00 00    	jae    0x18396c8df
   18396a3b6:	48 83 c0 28          	add    rax,0x28
   18396a3ba:	48 89 c2             	mov    rdx,rax
   18396a3bd:	4c 89 c1             	mov    rcx,r8
   18396a3c0:	e8 1b 15 b4 03       	call   0x1874ab8e0
   18396a3c5:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396a3cc:	00 
   18396a3cd:	b9 20 00 00 00       	mov    ecx,0x20
   18396a3d2:	e8 c5 14 b4 03       	call   0x1874ab89c
   18396a3d7:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396a3db:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   18396a3e2:	00 
   18396a3e3:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18396a3ea:	00 
   18396a3eb:	44 0f 11 00          	movups XMMWORD PTR [rax],xmm8
   18396a3ef:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   18396a3f5:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   18396a3f9:	ba 31 00 00 00       	mov    edx,0x31
   18396a3fe:	41 b8 21 00 00 00    	mov    r8d,0x21
   18396a404:	e8 37 ed ff ff       	call   0x183969140
   18396a409:	90                   	nop
   18396a40a:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396a40e:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   18396a412:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18396a416:	48 89 f1             	mov    rcx,rsi
   18396a419:	e8 d2 71 db fc       	call   0x1807215f0
   18396a41e:	90                   	nop
   18396a41f:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18396a423:	48 83 f8 10          	cmp    rax,0x10
   18396a427:	72 35                	jb     0x18396a45e
   18396a429:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18396a42d:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396a431:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396a438:	72 1f                	jb     0x18396a459
   18396a43a:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396a43e:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396a442:	4c 29 c1             	sub    rcx,r8
   18396a445:	48 83 f9 20          	cmp    rcx,0x20
   18396a449:	0f 83 90 24 00 00    	jae    0x18396c8df
   18396a44f:	48 83 c0 28          	add    rax,0x28
   18396a453:	48 89 c2             	mov    rdx,rax
   18396a456:	4c 89 c1             	mov    rcx,r8
   18396a459:	e8 82 14 b4 03       	call   0x1874ab8e0
   18396a45e:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396a462:	48 83 f8 10          	cmp    rax,0x10
   18396a466:	72 35                	jb     0x18396a49d
   18396a468:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396a46c:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396a470:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396a477:	72 1f                	jb     0x18396a498
   18396a479:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396a47d:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396a481:	4c 29 c1             	sub    rcx,r8
   18396a484:	48 83 f9 20          	cmp    rcx,0x20
   18396a488:	0f 83 51 24 00 00    	jae    0x18396c8df
   18396a48e:	48 83 c0 28          	add    rax,0x28
   18396a492:	48 89 c2             	mov    rdx,rax
   18396a495:	4c 89 c1             	mov    rcx,r8
   18396a498:	e8 43 14 b4 03       	call   0x1874ab8e0
   18396a49d:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396a4a4:	00 
   18396a4a5:	b9 20 00 00 00       	mov    ecx,0x20
   18396a4aa:	e8 ed 13 b4 03       	call   0x1874ab89c
   18396a4af:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396a4b3:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   18396a4ba:	00 
   18396a4bb:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18396a4c2:	00 
   18396a4c3:	44 0f 11 00          	movups XMMWORD PTR [rax],xmm8
   18396a4c7:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   18396a4cd:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   18396a4d1:	ba 31 00 00 00       	mov    edx,0x31
   18396a4d6:	41 b8 2c 00 00 00    	mov    r8d,0x2c
   18396a4dc:	e8 5f ec ff ff       	call   0x183969140
   18396a4e1:	90                   	nop
   18396a4e2:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396a4e6:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   18396a4ea:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18396a4ee:	48 89 f1             	mov    rcx,rsi
   18396a4f1:	e8 fa 70 db fc       	call   0x1807215f0
   18396a4f6:	90                   	nop
   18396a4f7:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18396a4fb:	48 83 f8 10          	cmp    rax,0x10
   18396a4ff:	72 35                	jb     0x18396a536
   18396a501:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18396a505:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396a509:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396a510:	72 1f                	jb     0x18396a531
   18396a512:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396a516:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396a51a:	4c 29 c1             	sub    rcx,r8
   18396a51d:	48 83 f9 20          	cmp    rcx,0x20
   18396a521:	0f 83 b8 23 00 00    	jae    0x18396c8df
   18396a527:	48 83 c0 28          	add    rax,0x28
   18396a52b:	48 89 c2             	mov    rdx,rax
   18396a52e:	4c 89 c1             	mov    rcx,r8
   18396a531:	e8 aa 13 b4 03       	call   0x1874ab8e0
   18396a536:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396a53a:	48 83 f8 10          	cmp    rax,0x10
   18396a53e:	72 35                	jb     0x18396a575
   18396a540:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396a544:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396a548:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396a54f:	72 1f                	jb     0x18396a570
   18396a551:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396a555:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396a559:	4c 29 c1             	sub    rcx,r8
   18396a55c:	48 83 f9 20          	cmp    rcx,0x20
   18396a560:	0f 83 79 23 00 00    	jae    0x18396c8df
   18396a566:	48 83 c0 28          	add    rax,0x28
   18396a56a:	48 89 c2             	mov    rdx,rax
   18396a56d:	4c 89 c1             	mov    rcx,r8
   18396a570:	e8 6b 13 b4 03       	call   0x1874ab8e0
   18396a575:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396a57c:	00 
   18396a57d:	b9 20 00 00 00       	mov    ecx,0x20
   18396a582:	e8 15 13 b4 03       	call   0x1874ab89c
   18396a587:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396a58b:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   18396a592:	00 
   18396a593:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18396a59a:	00 
   18396a59b:	44 0f 11 00          	movups XMMWORD PTR [rax],xmm8
   18396a59f:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   18396a5a5:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   18396a5a9:	ba 31 00 00 00       	mov    edx,0x31
   18396a5ae:	41 b8 24 00 00 00    	mov    r8d,0x24
   18396a5b4:	e8 87 eb ff ff       	call   0x183969140
   18396a5b9:	90                   	nop
   18396a5ba:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396a5be:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   18396a5c2:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18396a5c6:	48 89 f1             	mov    rcx,rsi
   18396a5c9:	e8 22 70 db fc       	call   0x1807215f0
   18396a5ce:	90                   	nop
   18396a5cf:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18396a5d3:	48 83 f8 10          	cmp    rax,0x10
   18396a5d7:	72 35                	jb     0x18396a60e
   18396a5d9:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18396a5dd:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396a5e1:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396a5e8:	72 1f                	jb     0x18396a609
   18396a5ea:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396a5ee:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396a5f2:	4c 29 c1             	sub    rcx,r8
   18396a5f5:	48 83 f9 20          	cmp    rcx,0x20
   18396a5f9:	0f 83 e0 22 00 00    	jae    0x18396c8df
   18396a5ff:	48 83 c0 28          	add    rax,0x28
   18396a603:	48 89 c2             	mov    rdx,rax
   18396a606:	4c 89 c1             	mov    rcx,r8
   18396a609:	e8 d2 12 b4 03       	call   0x1874ab8e0
   18396a60e:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396a612:	48 83 f8 10          	cmp    rax,0x10
   18396a616:	72 35                	jb     0x18396a64d
   18396a618:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396a61c:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396a620:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396a627:	72 1f                	jb     0x18396a648
   18396a629:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396a62d:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396a631:	4c 29 c1             	sub    rcx,r8
   18396a634:	48 83 f9 20          	cmp    rcx,0x20
   18396a638:	0f 83 a1 22 00 00    	jae    0x18396c8df
   18396a63e:	48 83 c0 28          	add    rax,0x28
   18396a642:	48 89 c2             	mov    rdx,rax
   18396a645:	4c 89 c1             	mov    rcx,r8
   18396a648:	e8 93 12 b4 03       	call   0x1874ab8e0
   18396a64d:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396a654:	00 
   18396a655:	b9 20 00 00 00       	mov    ecx,0x20
   18396a65a:	e8 3d 12 b4 03       	call   0x1874ab89c
   18396a65f:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396a663:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   18396a66a:	00 
   18396a66b:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18396a672:	00 
   18396a673:	44 0f 11 00          	movups XMMWORD PTR [rax],xmm8
   18396a677:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   18396a67d:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   18396a681:	ba 31 00 00 00       	mov    edx,0x31
   18396a686:	41 b8 33 00 00 00    	mov    r8d,0x33
   18396a68c:	e8 af ea ff ff       	call   0x183969140
   18396a691:	90                   	nop
   18396a692:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396a696:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   18396a69a:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18396a69e:	48 89 f1             	mov    rcx,rsi
   18396a6a1:	e8 4a 6f db fc       	call   0x1807215f0
   18396a6a6:	90                   	nop
   18396a6a7:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18396a6ab:	48 83 f8 10          	cmp    rax,0x10
   18396a6af:	72 35                	jb     0x18396a6e6
   18396a6b1:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18396a6b5:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396a6b9:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396a6c0:	72 1f                	jb     0x18396a6e1
   18396a6c2:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396a6c6:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396a6ca:	4c 29 c1             	sub    rcx,r8
   18396a6cd:	48 83 f9 20          	cmp    rcx,0x20
   18396a6d1:	0f 83 08 22 00 00    	jae    0x18396c8df
   18396a6d7:	48 83 c0 28          	add    rax,0x28
   18396a6db:	48 89 c2             	mov    rdx,rax
   18396a6de:	4c 89 c1             	mov    rcx,r8
   18396a6e1:	e8 fa 11 b4 03       	call   0x1874ab8e0
   18396a6e6:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396a6ea:	48 83 f8 10          	cmp    rax,0x10
   18396a6ee:	72 35                	jb     0x18396a725
   18396a6f0:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396a6f4:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396a6f8:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396a6ff:	72 1f                	jb     0x18396a720
   18396a701:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396a705:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396a709:	4c 29 c1             	sub    rcx,r8
   18396a70c:	48 83 f9 20          	cmp    rcx,0x20
   18396a710:	0f 83 c9 21 00 00    	jae    0x18396c8df
   18396a716:	48 83 c0 28          	add    rax,0x28
   18396a71a:	48 89 c2             	mov    rdx,rax
   18396a71d:	4c 89 c1             	mov    rcx,r8
   18396a720:	e8 bb 11 b4 03       	call   0x1874ab8e0
   18396a725:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396a72c:	00 
   18396a72d:	b9 20 00 00 00       	mov    ecx,0x20
   18396a732:	e8 65 11 b4 03       	call   0x1874ab89c
   18396a737:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396a73b:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   18396a742:	00 
   18396a743:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18396a74a:	00 
   18396a74b:	44 0f 11 00          	movups XMMWORD PTR [rax],xmm8
   18396a74f:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   18396a755:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   18396a759:	ba 31 00 00 00       	mov    edx,0x31
   18396a75e:	41 b8 3f 00 00 00    	mov    r8d,0x3f
   18396a764:	e8 d7 e9 ff ff       	call   0x183969140
   18396a769:	90                   	nop
   18396a76a:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396a76e:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   18396a772:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18396a776:	48 89 f1             	mov    rcx,rsi
   18396a779:	e8 72 6e db fc       	call   0x1807215f0
   18396a77e:	90                   	nop
   18396a77f:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18396a783:	48 83 f8 10          	cmp    rax,0x10
   18396a787:	72 35                	jb     0x18396a7be
   18396a789:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18396a78d:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396a791:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396a798:	72 1f                	jb     0x18396a7b9
   18396a79a:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396a79e:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396a7a2:	4c 29 c1             	sub    rcx,r8
   18396a7a5:	48 83 f9 20          	cmp    rcx,0x20
   18396a7a9:	0f 83 30 21 00 00    	jae    0x18396c8df
   18396a7af:	48 83 c0 28          	add    rax,0x28
   18396a7b3:	48 89 c2             	mov    rdx,rax
   18396a7b6:	4c 89 c1             	mov    rcx,r8
   18396a7b9:	e8 22 11 b4 03       	call   0x1874ab8e0
   18396a7be:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396a7c2:	48 83 f8 10          	cmp    rax,0x10
   18396a7c6:	72 35                	jb     0x18396a7fd
   18396a7c8:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396a7cc:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396a7d0:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396a7d7:	72 1f                	jb     0x18396a7f8
   18396a7d9:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396a7dd:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396a7e1:	4c 29 c1             	sub    rcx,r8
   18396a7e4:	48 83 f9 20          	cmp    rcx,0x20
   18396a7e8:	0f 83 f1 20 00 00    	jae    0x18396c8df
   18396a7ee:	48 83 c0 28          	add    rax,0x28
   18396a7f2:	48 89 c2             	mov    rdx,rax
   18396a7f5:	4c 89 c1             	mov    rcx,r8
   18396a7f8:	e8 e3 10 b4 03       	call   0x1874ab8e0
   18396a7fd:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396a804:	00 
   18396a805:	b9 20 00 00 00       	mov    ecx,0x20
   18396a80a:	e8 8d 10 b4 03       	call   0x1874ab89c
   18396a80f:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396a813:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   18396a81a:	00 
   18396a81b:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18396a822:	00 
   18396a823:	44 0f 11 00          	movups XMMWORD PTR [rax],xmm8
   18396a827:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   18396a82d:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   18396a831:	ba 31 00 00 00       	mov    edx,0x31
   18396a836:	41 b8 65 00 00 00    	mov    r8d,0x65
   18396a83c:	e8 ff e8 ff ff       	call   0x183969140
   18396a841:	90                   	nop
   18396a842:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396a846:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   18396a84a:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18396a84e:	48 89 f1             	mov    rcx,rsi
   18396a851:	e8 9a 6d db fc       	call   0x1807215f0
   18396a856:	90                   	nop
   18396a857:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18396a85b:	48 83 f8 10          	cmp    rax,0x10
   18396a85f:	72 35                	jb     0x18396a896
   18396a861:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18396a865:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396a869:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396a870:	72 1f                	jb     0x18396a891
   18396a872:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396a876:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396a87a:	4c 29 c1             	sub    rcx,r8
   18396a87d:	48 83 f9 20          	cmp    rcx,0x20
   18396a881:	0f 83 58 20 00 00    	jae    0x18396c8df
   18396a887:	48 83 c0 28          	add    rax,0x28
   18396a88b:	48 89 c2             	mov    rdx,rax
   18396a88e:	4c 89 c1             	mov    rcx,r8
   18396a891:	e8 4a 10 b4 03       	call   0x1874ab8e0
   18396a896:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396a89a:	48 83 f8 10          	cmp    rax,0x10
   18396a89e:	72 35                	jb     0x18396a8d5
   18396a8a0:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396a8a4:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396a8a8:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396a8af:	72 1f                	jb     0x18396a8d0
   18396a8b1:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396a8b5:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396a8b9:	4c 29 c1             	sub    rcx,r8
   18396a8bc:	48 83 f9 20          	cmp    rcx,0x20
   18396a8c0:	0f 83 19 20 00 00    	jae    0x18396c8df
   18396a8c6:	48 83 c0 28          	add    rax,0x28
   18396a8ca:	48 89 c2             	mov    rdx,rax
   18396a8cd:	4c 89 c1             	mov    rcx,r8
   18396a8d0:	e8 0b 10 b4 03       	call   0x1874ab8e0
   18396a8d5:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396a8dc:	00 
   18396a8dd:	b9 20 00 00 00       	mov    ecx,0x20
   18396a8e2:	e8 b5 0f b4 03       	call   0x1874ab89c
   18396a8e7:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396a8eb:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   18396a8f2:	00 
   18396a8f3:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18396a8fa:	00 
   18396a8fb:	44 0f 11 00          	movups XMMWORD PTR [rax],xmm8
   18396a8ff:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   18396a905:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   18396a909:	ba 31 00 00 00       	mov    edx,0x31
   18396a90e:	41 b8 58 00 00 00    	mov    r8d,0x58
   18396a914:	e8 27 e8 ff ff       	call   0x183969140
   18396a919:	90                   	nop
   18396a91a:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396a91e:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   18396a922:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18396a926:	48 89 f1             	mov    rcx,rsi
   18396a929:	e8 c2 6c db fc       	call   0x1807215f0
   18396a92e:	90                   	nop
   18396a92f:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18396a933:	48 83 f8 10          	cmp    rax,0x10
   18396a937:	72 35                	jb     0x18396a96e
   18396a939:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18396a93d:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396a941:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396a948:	72 1f                	jb     0x18396a969
   18396a94a:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396a94e:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396a952:	4c 29 c1             	sub    rcx,r8
   18396a955:	48 83 f9 20          	cmp    rcx,0x20
   18396a959:	0f 83 80 1f 00 00    	jae    0x18396c8df
   18396a95f:	48 83 c0 28          	add    rax,0x28
   18396a963:	48 89 c2             	mov    rdx,rax
   18396a966:	4c 89 c1             	mov    rcx,r8
   18396a969:	e8 72 0f b4 03       	call   0x1874ab8e0
   18396a96e:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396a972:	48 83 f8 10          	cmp    rax,0x10
   18396a976:	72 35                	jb     0x18396a9ad
   18396a978:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396a97c:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396a980:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396a987:	72 1f                	jb     0x18396a9a8
   18396a989:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396a98d:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396a991:	4c 29 c1             	sub    rcx,r8
   18396a994:	48 83 f9 20          	cmp    rcx,0x20
   18396a998:	0f 83 41 1f 00 00    	jae    0x18396c8df
   18396a99e:	48 83 c0 28          	add    rax,0x28
   18396a9a2:	48 89 c2             	mov    rdx,rax
   18396a9a5:	4c 89 c1             	mov    rcx,r8
   18396a9a8:	e8 33 0f b4 03       	call   0x1874ab8e0
   18396a9ad:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396a9b4:	00 
   18396a9b5:	b9 20 00 00 00       	mov    ecx,0x20
   18396a9ba:	e8 dd 0e b4 03       	call   0x1874ab89c
   18396a9bf:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396a9c3:	48 c7 45 e8 17 00 00 	mov    QWORD PTR [rbp-0x18],0x17
   18396a9ca:	00 
   18396a9cb:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18396a9d2:	00 
   18396a9d3:	44 0f 11 08          	movups XMMWORD PTR [rax],xmm9
   18396a9d7:	4c 89 78 0f          	mov    QWORD PTR [rax+0xf],r15
   18396a9db:	c6 40 17 00          	mov    BYTE PTR [rax+0x17],0x0
   18396a9df:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   18396a9e3:	ba 31 00 00 00       	mov    edx,0x31
   18396a9e8:	41 b8 13 00 00 00    	mov    r8d,0x13
   18396a9ee:	e8 4d e7 ff ff       	call   0x183969140
   18396a9f3:	90                   	nop
   18396a9f4:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396a9f8:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   18396a9fc:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18396aa00:	48 89 f1             	mov    rcx,rsi
   18396aa03:	e8 e8 6b db fc       	call   0x1807215f0
   18396aa08:	90                   	nop
   18396aa09:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18396aa0d:	48 83 f8 10          	cmp    rax,0x10
   18396aa11:	72 35                	jb     0x18396aa48
   18396aa13:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18396aa17:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396aa1b:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396aa22:	72 1f                	jb     0x18396aa43
   18396aa24:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396aa28:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396aa2c:	4c 29 c1             	sub    rcx,r8
   18396aa2f:	48 83 f9 20          	cmp    rcx,0x20
   18396aa33:	0f 83 a6 1e 00 00    	jae    0x18396c8df
   18396aa39:	48 83 c0 28          	add    rax,0x28
   18396aa3d:	48 89 c2             	mov    rdx,rax
   18396aa40:	4c 89 c1             	mov    rcx,r8
   18396aa43:	e8 98 0e b4 03       	call   0x1874ab8e0
   18396aa48:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396aa4c:	48 83 f8 10          	cmp    rax,0x10
   18396aa50:	72 35                	jb     0x18396aa87
   18396aa52:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396aa56:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396aa5a:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396aa61:	72 1f                	jb     0x18396aa82
   18396aa63:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396aa67:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396aa6b:	4c 29 c1             	sub    rcx,r8
   18396aa6e:	48 83 f9 20          	cmp    rcx,0x20
   18396aa72:	0f 83 67 1e 00 00    	jae    0x18396c8df
   18396aa78:	48 83 c0 28          	add    rax,0x28
   18396aa7c:	48 89 c2             	mov    rdx,rax
   18396aa7f:	4c 89 c1             	mov    rcx,r8
   18396aa82:	e8 59 0e b4 03       	call   0x1874ab8e0
   18396aa87:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396aa8e:	00 
   18396aa8f:	b9 20 00 00 00       	mov    ecx,0x20
   18396aa94:	e8 03 0e b4 03       	call   0x1874ab89c
   18396aa99:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396aa9d:	48 c7 45 e8 17 00 00 	mov    QWORD PTR [rbp-0x18],0x17
   18396aaa4:	00 
   18396aaa5:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18396aaac:	00 
   18396aaad:	44 0f 11 10          	movups XMMWORD PTR [rax],xmm10
   18396aab1:	4c 89 78 0f          	mov    QWORD PTR [rax+0xf],r15
   18396aab5:	c6 40 17 00          	mov    BYTE PTR [rax+0x17],0x0
   18396aab9:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   18396aabd:	ba 31 00 00 00       	mov    edx,0x31
   18396aac2:	41 b8 28 00 00 00    	mov    r8d,0x28
   18396aac8:	e8 73 e6 ff ff       	call   0x183969140
   18396aacd:	90                   	nop
   18396aace:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396aad2:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   18396aad6:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18396aada:	48 89 f1             	mov    rcx,rsi
   18396aadd:	e8 0e 6b db fc       	call   0x1807215f0
   18396aae2:	90                   	nop
   18396aae3:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18396aae7:	48 83 f8 10          	cmp    rax,0x10
   18396aaeb:	72 35                	jb     0x18396ab22
   18396aaed:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18396aaf1:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396aaf5:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396aafc:	72 1f                	jb     0x18396ab1d
   18396aafe:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396ab02:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396ab06:	4c 29 c1             	sub    rcx,r8
   18396ab09:	48 83 f9 20          	cmp    rcx,0x20
   18396ab0d:	0f 83 cc 1d 00 00    	jae    0x18396c8df
   18396ab13:	48 83 c0 28          	add    rax,0x28
   18396ab17:	48 89 c2             	mov    rdx,rax
   18396ab1a:	4c 89 c1             	mov    rcx,r8
   18396ab1d:	e8 be 0d b4 03       	call   0x1874ab8e0
   18396ab22:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396ab26:	48 83 f8 10          	cmp    rax,0x10
   18396ab2a:	72 35                	jb     0x18396ab61
   18396ab2c:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396ab30:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396ab34:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396ab3b:	72 1f                	jb     0x18396ab5c
   18396ab3d:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396ab41:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396ab45:	4c 29 c1             	sub    rcx,r8
   18396ab48:	48 83 f9 20          	cmp    rcx,0x20
   18396ab4c:	0f 83 8d 1d 00 00    	jae    0x18396c8df
   18396ab52:	48 83 c0 28          	add    rax,0x28
   18396ab56:	48 89 c2             	mov    rdx,rax
   18396ab59:	4c 89 c1             	mov    rcx,r8
   18396ab5c:	e8 7f 0d b4 03       	call   0x1874ab8e0
   18396ab61:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396ab68:	00 
   18396ab69:	b9 20 00 00 00       	mov    ecx,0x20
   18396ab6e:	e8 29 0d b4 03       	call   0x1874ab89c
   18396ab73:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396ab77:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   18396ab7e:	00 
   18396ab7f:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18396ab86:	00 
   18396ab87:	44 0f 11 00          	movups XMMWORD PTR [rax],xmm8
   18396ab8b:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   18396ab91:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   18396ab95:	ba 31 00 00 00       	mov    edx,0x31
   18396ab9a:	41 b8 44 00 00 00    	mov    r8d,0x44
   18396aba0:	e8 9b e5 ff ff       	call   0x183969140
   18396aba5:	90                   	nop
   18396aba6:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396abaa:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   18396abae:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18396abb2:	48 89 f1             	mov    rcx,rsi
   18396abb5:	e8 36 6a db fc       	call   0x1807215f0
   18396abba:	90                   	nop
   18396abbb:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18396abbf:	48 83 f8 10          	cmp    rax,0x10
   18396abc3:	72 35                	jb     0x18396abfa
   18396abc5:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18396abc9:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396abcd:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396abd4:	72 1f                	jb     0x18396abf5
   18396abd6:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396abda:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396abde:	4c 29 c1             	sub    rcx,r8
   18396abe1:	48 83 f9 20          	cmp    rcx,0x20
   18396abe5:	0f 83 f4 1c 00 00    	jae    0x18396c8df
   18396abeb:	48 83 c0 28          	add    rax,0x28
   18396abef:	48 89 c2             	mov    rdx,rax
   18396abf2:	4c 89 c1             	mov    rcx,r8
   18396abf5:	e8 e6 0c b4 03       	call   0x1874ab8e0
   18396abfa:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396abfe:	48 83 f8 10          	cmp    rax,0x10
   18396ac02:	72 35                	jb     0x18396ac39
   18396ac04:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396ac08:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396ac0c:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396ac13:	72 1f                	jb     0x18396ac34
   18396ac15:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396ac19:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396ac1d:	4c 29 c1             	sub    rcx,r8
   18396ac20:	48 83 f9 20          	cmp    rcx,0x20
   18396ac24:	0f 83 b5 1c 00 00    	jae    0x18396c8df
   18396ac2a:	48 83 c0 28          	add    rax,0x28
   18396ac2e:	48 89 c2             	mov    rdx,rax
   18396ac31:	4c 89 c1             	mov    rcx,r8
   18396ac34:	e8 a7 0c b4 03       	call   0x1874ab8e0
   18396ac39:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396ac40:	00 
   18396ac41:	b9 20 00 00 00       	mov    ecx,0x20
   18396ac46:	e8 51 0c b4 03       	call   0x1874ab89c
   18396ac4b:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396ac4f:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   18396ac56:	00 
   18396ac57:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18396ac5e:	00 
   18396ac5f:	44 0f 11 00          	movups XMMWORD PTR [rax],xmm8
   18396ac63:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   18396ac69:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   18396ac6d:	ba 31 00 00 00       	mov    edx,0x31
   18396ac72:	41 b8 32 00 00 00    	mov    r8d,0x32
   18396ac78:	e8 c3 e4 ff ff       	call   0x183969140
   18396ac7d:	90                   	nop
   18396ac7e:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396ac82:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   18396ac86:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18396ac8a:	48 89 f1             	mov    rcx,rsi
   18396ac8d:	e8 5e 69 db fc       	call   0x1807215f0
   18396ac92:	90                   	nop
   18396ac93:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18396ac97:	48 83 f8 10          	cmp    rax,0x10
   18396ac9b:	72 35                	jb     0x18396acd2
   18396ac9d:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18396aca1:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396aca5:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396acac:	72 1f                	jb     0x18396accd
   18396acae:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396acb2:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396acb6:	4c 29 c1             	sub    rcx,r8
   18396acb9:	48 83 f9 20          	cmp    rcx,0x20
   18396acbd:	0f 83 1c 1c 00 00    	jae    0x18396c8df
   18396acc3:	48 83 c0 28          	add    rax,0x28
   18396acc7:	48 89 c2             	mov    rdx,rax
   18396acca:	4c 89 c1             	mov    rcx,r8
   18396accd:	e8 0e 0c b4 03       	call   0x1874ab8e0
   18396acd2:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396acd6:	48 83 f8 10          	cmp    rax,0x10
   18396acda:	72 35                	jb     0x18396ad11
   18396acdc:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396ace0:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396ace4:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396aceb:	72 1f                	jb     0x18396ad0c
   18396aced:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396acf1:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396acf5:	4c 29 c1             	sub    rcx,r8
   18396acf8:	48 83 f9 20          	cmp    rcx,0x20
   18396acfc:	0f 83 dd 1b 00 00    	jae    0x18396c8df
   18396ad02:	48 83 c0 28          	add    rax,0x28
   18396ad06:	48 89 c2             	mov    rdx,rax
   18396ad09:	4c 89 c1             	mov    rcx,r8
   18396ad0c:	e8 cf 0b b4 03       	call   0x1874ab8e0
   18396ad11:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396ad18:	00 
   18396ad19:	b9 20 00 00 00       	mov    ecx,0x20
   18396ad1e:	e8 79 0b b4 03       	call   0x1874ab89c
   18396ad23:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396ad27:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   18396ad2e:	00 
   18396ad2f:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18396ad36:	00 
   18396ad37:	44 0f 11 00          	movups XMMWORD PTR [rax],xmm8
   18396ad3b:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   18396ad41:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   18396ad45:	ba 31 00 00 00       	mov    edx,0x31
   18396ad4a:	41 b8 69 00 00 00    	mov    r8d,0x69
   18396ad50:	e8 eb e3 ff ff       	call   0x183969140
   18396ad55:	90                   	nop
   18396ad56:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396ad5a:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   18396ad5e:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18396ad62:	48 89 f1             	mov    rcx,rsi
   18396ad65:	e8 86 68 db fc       	call   0x1807215f0
   18396ad6a:	90                   	nop
   18396ad6b:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18396ad6f:	48 83 f8 10          	cmp    rax,0x10
   18396ad73:	72 35                	jb     0x18396adaa
   18396ad75:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18396ad79:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396ad7d:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396ad84:	72 1f                	jb     0x18396ada5
   18396ad86:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396ad8a:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396ad8e:	4c 29 c1             	sub    rcx,r8
   18396ad91:	48 83 f9 20          	cmp    rcx,0x20
   18396ad95:	0f 83 44 1b 00 00    	jae    0x18396c8df
   18396ad9b:	48 83 c0 28          	add    rax,0x28
   18396ad9f:	48 89 c2             	mov    rdx,rax
   18396ada2:	4c 89 c1             	mov    rcx,r8
   18396ada5:	e8 36 0b b4 03       	call   0x1874ab8e0
   18396adaa:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396adae:	48 83 f8 10          	cmp    rax,0x10
   18396adb2:	72 35                	jb     0x18396ade9
   18396adb4:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396adb8:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396adbc:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396adc3:	72 1f                	jb     0x18396ade4
   18396adc5:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396adc9:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396adcd:	4c 29 c1             	sub    rcx,r8
   18396add0:	48 83 f9 20          	cmp    rcx,0x20
   18396add4:	0f 83 05 1b 00 00    	jae    0x18396c8df
   18396adda:	48 83 c0 28          	add    rax,0x28
   18396adde:	48 89 c2             	mov    rdx,rax
   18396ade1:	4c 89 c1             	mov    rcx,r8
   18396ade4:	e8 f7 0a b4 03       	call   0x1874ab8e0
   18396ade9:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396adf0:	00 
   18396adf1:	b9 20 00 00 00       	mov    ecx,0x20
   18396adf6:	e8 a1 0a b4 03       	call   0x1874ab89c
   18396adfb:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396adff:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   18396ae06:	00 
   18396ae07:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18396ae0e:	00 
   18396ae0f:	44 0f 11 00          	movups XMMWORD PTR [rax],xmm8
   18396ae13:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   18396ae19:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   18396ae1d:	ba 31 00 00 00       	mov    edx,0x31
   18396ae22:	41 b8 5c 00 00 00    	mov    r8d,0x5c
   18396ae28:	e8 13 e3 ff ff       	call   0x183969140
   18396ae2d:	90                   	nop
   18396ae2e:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396ae32:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   18396ae36:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18396ae3a:	48 89 f1             	mov    rcx,rsi
   18396ae3d:	e8 ae 67 db fc       	call   0x1807215f0
   18396ae42:	90                   	nop
   18396ae43:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18396ae47:	48 83 f8 10          	cmp    rax,0x10
   18396ae4b:	72 35                	jb     0x18396ae82
   18396ae4d:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18396ae51:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396ae55:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396ae5c:	72 1f                	jb     0x18396ae7d
   18396ae5e:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396ae62:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396ae66:	4c 29 c1             	sub    rcx,r8
   18396ae69:	48 83 f9 20          	cmp    rcx,0x20
   18396ae6d:	0f 83 6c 1a 00 00    	jae    0x18396c8df
   18396ae73:	48 83 c0 28          	add    rax,0x28
   18396ae77:	48 89 c2             	mov    rdx,rax
   18396ae7a:	4c 89 c1             	mov    rcx,r8
   18396ae7d:	e8 5e 0a b4 03       	call   0x1874ab8e0
   18396ae82:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396ae86:	48 83 f8 10          	cmp    rax,0x10
   18396ae8a:	72 35                	jb     0x18396aec1
   18396ae8c:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396ae90:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396ae94:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396ae9b:	72 1f                	jb     0x18396aebc
   18396ae9d:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396aea1:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396aea5:	4c 29 c1             	sub    rcx,r8
   18396aea8:	48 83 f9 20          	cmp    rcx,0x20
   18396aeac:	0f 83 2d 1a 00 00    	jae    0x18396c8df
   18396aeb2:	48 83 c0 28          	add    rax,0x28
   18396aeb6:	48 89 c2             	mov    rdx,rax
   18396aeb9:	4c 89 c1             	mov    rcx,r8
   18396aebc:	e8 1f 0a b4 03       	call   0x1874ab8e0
   18396aec1:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396aec8:	00 
   18396aec9:	b9 20 00 00 00       	mov    ecx,0x20
   18396aece:	e8 c9 09 b4 03       	call   0x1874ab89c
   18396aed3:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396aed7:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   18396aede:	00 
   18396aedf:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18396aee6:	00 
   18396aee7:	44 0f 11 00          	movups XMMWORD PTR [rax],xmm8
   18396aeeb:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   18396aef1:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   18396aef5:	ba 31 00 00 00       	mov    edx,0x31
   18396aefa:	41 b8 5d 00 00 00    	mov    r8d,0x5d
   18396af00:	e8 3b e2 ff ff       	call   0x183969140
   18396af05:	90                   	nop
   18396af06:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396af0a:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   18396af0e:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18396af12:	48 89 f1             	mov    rcx,rsi
   18396af15:	e8 d6 66 db fc       	call   0x1807215f0
   18396af1a:	90                   	nop
   18396af1b:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18396af1f:	48 83 f8 10          	cmp    rax,0x10
   18396af23:	72 35                	jb     0x18396af5a
   18396af25:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18396af29:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396af2d:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396af34:	72 1f                	jb     0x18396af55
   18396af36:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396af3a:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396af3e:	4c 29 c1             	sub    rcx,r8
   18396af41:	48 83 f9 20          	cmp    rcx,0x20
   18396af45:	0f 83 94 19 00 00    	jae    0x18396c8df
   18396af4b:	48 83 c0 28          	add    rax,0x28
   18396af4f:	48 89 c2             	mov    rdx,rax
   18396af52:	4c 89 c1             	mov    rcx,r8
   18396af55:	e8 86 09 b4 03       	call   0x1874ab8e0
   18396af5a:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396af5e:	48 83 f8 10          	cmp    rax,0x10
   18396af62:	72 35                	jb     0x18396af99
   18396af64:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396af68:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396af6c:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396af73:	72 1f                	jb     0x18396af94
   18396af75:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396af79:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396af7d:	4c 29 c1             	sub    rcx,r8
   18396af80:	48 83 f9 20          	cmp    rcx,0x20
   18396af84:	0f 83 55 19 00 00    	jae    0x18396c8df
   18396af8a:	48 83 c0 28          	add    rax,0x28
   18396af8e:	48 89 c2             	mov    rdx,rax
   18396af91:	4c 89 c1             	mov    rcx,r8
   18396af94:	e8 47 09 b4 03       	call   0x1874ab8e0
   18396af99:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396afa0:	00 
   18396afa1:	b9 20 00 00 00       	mov    ecx,0x20
   18396afa6:	e8 f1 08 b4 03       	call   0x1874ab89c
   18396afab:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396afaf:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   18396afb6:	00 
   18396afb7:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18396afbe:	00 
   18396afbf:	44 0f 11 00          	movups XMMWORD PTR [rax],xmm8
   18396afc3:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   18396afc9:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   18396afcd:	ba 31 00 00 00       	mov    edx,0x31
   18396afd2:	41 b8 6b 00 00 00    	mov    r8d,0x6b
   18396afd8:	e8 63 e1 ff ff       	call   0x183969140
   18396afdd:	90                   	nop
   18396afde:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396afe2:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   18396afe6:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18396afea:	48 89 f1             	mov    rcx,rsi
   18396afed:	e8 fe 65 db fc       	call   0x1807215f0
   18396aff2:	90                   	nop
   18396aff3:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18396aff7:	48 83 f8 10          	cmp    rax,0x10
   18396affb:	72 35                	jb     0x18396b032
   18396affd:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18396b001:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396b005:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396b00c:	72 1f                	jb     0x18396b02d
   18396b00e:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396b012:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396b016:	4c 29 c1             	sub    rcx,r8
   18396b019:	48 83 f9 20          	cmp    rcx,0x20
   18396b01d:	0f 83 bc 18 00 00    	jae    0x18396c8df
   18396b023:	48 83 c0 28          	add    rax,0x28
   18396b027:	48 89 c2             	mov    rdx,rax
   18396b02a:	4c 89 c1             	mov    rcx,r8
   18396b02d:	e8 ae 08 b4 03       	call   0x1874ab8e0
   18396b032:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396b036:	48 83 f8 10          	cmp    rax,0x10
   18396b03a:	72 35                	jb     0x18396b071
   18396b03c:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396b040:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396b044:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396b04b:	72 1f                	jb     0x18396b06c
   18396b04d:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396b051:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396b055:	4c 29 c1             	sub    rcx,r8
   18396b058:	48 83 f9 20          	cmp    rcx,0x20
   18396b05c:	0f 83 7d 18 00 00    	jae    0x18396c8df
   18396b062:	48 83 c0 28          	add    rax,0x28
   18396b066:	48 89 c2             	mov    rdx,rax
   18396b069:	4c 89 c1             	mov    rcx,r8
   18396b06c:	e8 6f 08 b4 03       	call   0x1874ab8e0
   18396b071:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396b078:	00 
   18396b079:	b9 20 00 00 00       	mov    ecx,0x20
   18396b07e:	e8 19 08 b4 03       	call   0x1874ab89c
   18396b083:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396b087:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   18396b08e:	00 
   18396b08f:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18396b096:	00 
   18396b097:	44 0f 11 00          	movups XMMWORD PTR [rax],xmm8
   18396b09b:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   18396b0a1:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   18396b0a5:	ba 31 00 00 00       	mov    edx,0x31
   18396b0aa:	41 b8 03 00 00 00    	mov    r8d,0x3
   18396b0b0:	e8 8b e0 ff ff       	call   0x183969140
   18396b0b5:	90                   	nop
   18396b0b6:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396b0ba:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   18396b0be:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18396b0c2:	48 89 f1             	mov    rcx,rsi
   18396b0c5:	e8 26 65 db fc       	call   0x1807215f0
   18396b0ca:	90                   	nop
   18396b0cb:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18396b0cf:	48 83 f8 10          	cmp    rax,0x10
   18396b0d3:	72 35                	jb     0x18396b10a
   18396b0d5:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18396b0d9:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396b0dd:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396b0e4:	72 1f                	jb     0x18396b105
   18396b0e6:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396b0ea:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396b0ee:	4c 29 c1             	sub    rcx,r8
   18396b0f1:	48 83 f9 20          	cmp    rcx,0x20
   18396b0f5:	0f 83 e4 17 00 00    	jae    0x18396c8df
   18396b0fb:	48 83 c0 28          	add    rax,0x28
   18396b0ff:	48 89 c2             	mov    rdx,rax
   18396b102:	4c 89 c1             	mov    rcx,r8
   18396b105:	e8 d6 07 b4 03       	call   0x1874ab8e0
   18396b10a:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396b10e:	48 83 f8 10          	cmp    rax,0x10
   18396b112:	72 35                	jb     0x18396b149
   18396b114:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396b118:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396b11c:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396b123:	72 1f                	jb     0x18396b144
   18396b125:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396b129:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396b12d:	4c 29 c1             	sub    rcx,r8
   18396b130:	48 83 f9 20          	cmp    rcx,0x20
   18396b134:	0f 83 a5 17 00 00    	jae    0x18396c8df
   18396b13a:	48 83 c0 28          	add    rax,0x28
   18396b13e:	48 89 c2             	mov    rdx,rax
   18396b141:	4c 89 c1             	mov    rcx,r8
   18396b144:	e8 97 07 b4 03       	call   0x1874ab8e0
   18396b149:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396b150:	00 
   18396b151:	b9 20 00 00 00       	mov    ecx,0x20
   18396b156:	e8 41 07 b4 03       	call   0x1874ab89c
   18396b15b:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396b15f:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   18396b166:	00 
   18396b167:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18396b16e:	00 
   18396b16f:	44 0f 11 00          	movups XMMWORD PTR [rax],xmm8
   18396b173:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   18396b179:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   18396b17d:	ba 31 00 00 00       	mov    edx,0x31
   18396b182:	41 b8 d0 07 00 00    	mov    r8d,0x7d0
   18396b188:	e8 b3 df ff ff       	call   0x183969140
   18396b18d:	90                   	nop
   18396b18e:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396b192:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   18396b196:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18396b19a:	48 89 f1             	mov    rcx,rsi
   18396b19d:	e8 4e 64 db fc       	call   0x1807215f0
   18396b1a2:	90                   	nop
   18396b1a3:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18396b1a7:	48 83 f8 10          	cmp    rax,0x10
   18396b1ab:	72 35                	jb     0x18396b1e2
   18396b1ad:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18396b1b1:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396b1b5:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396b1bc:	72 1f                	jb     0x18396b1dd
   18396b1be:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396b1c2:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396b1c6:	4c 29 c1             	sub    rcx,r8
   18396b1c9:	48 83 f9 20          	cmp    rcx,0x20
   18396b1cd:	0f 83 0c 17 00 00    	jae    0x18396c8df
   18396b1d3:	48 83 c0 28          	add    rax,0x28
   18396b1d7:	48 89 c2             	mov    rdx,rax
   18396b1da:	4c 89 c1             	mov    rcx,r8
   18396b1dd:	e8 fe 06 b4 03       	call   0x1874ab8e0
   18396b1e2:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396b1e6:	48 83 f8 10          	cmp    rax,0x10
   18396b1ea:	72 35                	jb     0x18396b221
   18396b1ec:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396b1f0:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396b1f4:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396b1fb:	72 1f                	jb     0x18396b21c
   18396b1fd:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396b201:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396b205:	4c 29 c1             	sub    rcx,r8
   18396b208:	48 83 f9 20          	cmp    rcx,0x20
   18396b20c:	0f 83 cd 16 00 00    	jae    0x18396c8df
   18396b212:	48 83 c0 28          	add    rax,0x28
   18396b216:	48 89 c2             	mov    rdx,rax
   18396b219:	4c 89 c1             	mov    rcx,r8
   18396b21c:	e8 bf 06 b4 03       	call   0x1874ab8e0
   18396b221:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396b228:	00 
   18396b229:	b9 20 00 00 00       	mov    ecx,0x20
   18396b22e:	e8 69 06 b4 03       	call   0x1874ab89c
   18396b233:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396b237:	48 c7 45 e8 17 00 00 	mov    QWORD PTR [rbp-0x18],0x17
   18396b23e:	00 
   18396b23f:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18396b246:	00 
   18396b247:	44 0f 11 08          	movups XMMWORD PTR [rax],xmm9
   18396b24b:	4c 89 78 0f          	mov    QWORD PTR [rax+0xf],r15
   18396b24f:	c6 40 17 00          	mov    BYTE PTR [rax+0x17],0x0
   18396b253:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   18396b257:	ba 31 00 00 00       	mov    edx,0x31
   18396b25c:	41 b8 18 00 00 00    	mov    r8d,0x18
   18396b262:	e8 d9 de ff ff       	call   0x183969140
   18396b267:	90                   	nop
   18396b268:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396b26c:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   18396b270:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18396b274:	48 89 f1             	mov    rcx,rsi
   18396b277:	e8 74 63 db fc       	call   0x1807215f0
   18396b27c:	90                   	nop
   18396b27d:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18396b281:	48 83 f8 10          	cmp    rax,0x10
   18396b285:	72 35                	jb     0x18396b2bc
   18396b287:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18396b28b:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396b28f:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396b296:	72 1f                	jb     0x18396b2b7
   18396b298:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396b29c:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396b2a0:	4c 29 c1             	sub    rcx,r8
   18396b2a3:	48 83 f9 20          	cmp    rcx,0x20
   18396b2a7:	0f 83 32 16 00 00    	jae    0x18396c8df
   18396b2ad:	48 83 c0 28          	add    rax,0x28
   18396b2b1:	48 89 c2             	mov    rdx,rax
   18396b2b4:	4c 89 c1             	mov    rcx,r8
   18396b2b7:	e8 24 06 b4 03       	call   0x1874ab8e0
   18396b2bc:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396b2c0:	48 83 f8 10          	cmp    rax,0x10
   18396b2c4:	72 35                	jb     0x18396b2fb
   18396b2c6:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396b2ca:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396b2ce:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396b2d5:	72 1f                	jb     0x18396b2f6
   18396b2d7:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396b2db:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396b2df:	4c 29 c1             	sub    rcx,r8
   18396b2e2:	48 83 f9 20          	cmp    rcx,0x20
   18396b2e6:	0f 83 f3 15 00 00    	jae    0x18396c8df
   18396b2ec:	48 83 c0 28          	add    rax,0x28
   18396b2f0:	48 89 c2             	mov    rdx,rax
   18396b2f3:	4c 89 c1             	mov    rcx,r8
   18396b2f6:	e8 e5 05 b4 03       	call   0x1874ab8e0
   18396b2fb:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396b302:	00 
   18396b303:	b9 20 00 00 00       	mov    ecx,0x20
   18396b308:	e8 8f 05 b4 03       	call   0x1874ab89c
   18396b30d:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396b311:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   18396b318:	00 
   18396b319:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18396b320:	00 
   18396b321:	44 0f 11 00          	movups XMMWORD PTR [rax],xmm8
   18396b325:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   18396b32b:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   18396b32f:	ba 31 00 00 00       	mov    edx,0x31
   18396b334:	41 b8 52 00 00 00    	mov    r8d,0x52
   18396b33a:	e8 01 de ff ff       	call   0x183969140
   18396b33f:	90                   	nop
   18396b340:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396b344:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   18396b348:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18396b34c:	48 89 f1             	mov    rcx,rsi
   18396b34f:	e8 9c 62 db fc       	call   0x1807215f0
   18396b354:	90                   	nop
   18396b355:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18396b359:	48 83 f8 10          	cmp    rax,0x10
   18396b35d:	72 35                	jb     0x18396b394
   18396b35f:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18396b363:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396b367:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396b36e:	72 1f                	jb     0x18396b38f
   18396b370:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396b374:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396b378:	4c 29 c1             	sub    rcx,r8
   18396b37b:	48 83 f9 20          	cmp    rcx,0x20
   18396b37f:	0f 83 5a 15 00 00    	jae    0x18396c8df
   18396b385:	48 83 c0 28          	add    rax,0x28
   18396b389:	48 89 c2             	mov    rdx,rax
   18396b38c:	4c 89 c1             	mov    rcx,r8
   18396b38f:	e8 4c 05 b4 03       	call   0x1874ab8e0
   18396b394:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396b398:	48 83 f8 10          	cmp    rax,0x10
   18396b39c:	72 35                	jb     0x18396b3d3
   18396b39e:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396b3a2:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396b3a6:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396b3ad:	72 1f                	jb     0x18396b3ce
   18396b3af:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396b3b3:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396b3b7:	4c 29 c1             	sub    rcx,r8
   18396b3ba:	48 83 f9 20          	cmp    rcx,0x20
   18396b3be:	0f 83 1b 15 00 00    	jae    0x18396c8df
   18396b3c4:	48 83 c0 28          	add    rax,0x28
   18396b3c8:	48 89 c2             	mov    rdx,rax
   18396b3cb:	4c 89 c1             	mov    rcx,r8
   18396b3ce:	e8 0d 05 b4 03       	call   0x1874ab8e0
   18396b3d3:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396b3da:	00 
   18396b3db:	b9 20 00 00 00       	mov    ecx,0x20
   18396b3e0:	e8 b7 04 b4 03       	call   0x1874ab89c
   18396b3e5:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396b3e9:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   18396b3f0:	00 
   18396b3f1:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18396b3f8:	00 
   18396b3f9:	44 0f 11 00          	movups XMMWORD PTR [rax],xmm8
   18396b3fd:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   18396b403:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   18396b407:	ba 31 00 00 00       	mov    edx,0x31
   18396b40c:	41 b8 6f 00 00 00    	mov    r8d,0x6f
   18396b412:	e8 29 dd ff ff       	call   0x183969140
   18396b417:	90                   	nop
   18396b418:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396b41c:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   18396b420:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18396b424:	48 89 f1             	mov    rcx,rsi
   18396b427:	e8 c4 61 db fc       	call   0x1807215f0
   18396b42c:	90                   	nop
   18396b42d:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18396b431:	48 83 f8 10          	cmp    rax,0x10
   18396b435:	72 35                	jb     0x18396b46c
   18396b437:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18396b43b:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396b43f:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396b446:	72 1f                	jb     0x18396b467
   18396b448:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396b44c:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396b450:	4c 29 c1             	sub    rcx,r8
   18396b453:	48 83 f9 20          	cmp    rcx,0x20
   18396b457:	0f 83 82 14 00 00    	jae    0x18396c8df
   18396b45d:	48 83 c0 28          	add    rax,0x28
   18396b461:	48 89 c2             	mov    rdx,rax
   18396b464:	4c 89 c1             	mov    rcx,r8
   18396b467:	e8 74 04 b4 03       	call   0x1874ab8e0
   18396b46c:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396b470:	48 83 f8 10          	cmp    rax,0x10
   18396b474:	72 35                	jb     0x18396b4ab
   18396b476:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396b47a:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396b47e:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396b485:	72 1f                	jb     0x18396b4a6
   18396b487:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396b48b:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396b48f:	4c 29 c1             	sub    rcx,r8
   18396b492:	48 83 f9 20          	cmp    rcx,0x20
   18396b496:	0f 83 43 14 00 00    	jae    0x18396c8df
   18396b49c:	48 83 c0 28          	add    rax,0x28
   18396b4a0:	48 89 c2             	mov    rdx,rax
   18396b4a3:	4c 89 c1             	mov    rcx,r8
   18396b4a6:	e8 35 04 b4 03       	call   0x1874ab8e0
   18396b4ab:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396b4b2:	00 
   18396b4b3:	b9 20 00 00 00       	mov    ecx,0x20
   18396b4b8:	e8 df 03 b4 03       	call   0x1874ab89c
   18396b4bd:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396b4c1:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   18396b4c8:	00 
   18396b4c9:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18396b4d0:	00 
   18396b4d1:	44 0f 11 00          	movups XMMWORD PTR [rax],xmm8
   18396b4d5:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   18396b4db:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   18396b4df:	ba 31 00 00 00       	mov    edx,0x31
   18396b4e4:	41 b8 60 00 00 00    	mov    r8d,0x60
   18396b4ea:	e8 51 dc ff ff       	call   0x183969140
   18396b4ef:	90                   	nop
   18396b4f0:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396b4f4:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   18396b4f8:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18396b4fc:	48 89 f1             	mov    rcx,rsi
   18396b4ff:	e8 ec 60 db fc       	call   0x1807215f0
   18396b504:	90                   	nop
   18396b505:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18396b509:	48 83 f8 10          	cmp    rax,0x10
   18396b50d:	72 35                	jb     0x18396b544
   18396b50f:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18396b513:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396b517:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396b51e:	72 1f                	jb     0x18396b53f
   18396b520:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396b524:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396b528:	4c 29 c1             	sub    rcx,r8
   18396b52b:	48 83 f9 20          	cmp    rcx,0x20
   18396b52f:	0f 83 aa 13 00 00    	jae    0x18396c8df
   18396b535:	48 83 c0 28          	add    rax,0x28
   18396b539:	48 89 c2             	mov    rdx,rax
   18396b53c:	4c 89 c1             	mov    rcx,r8
   18396b53f:	e8 9c 03 b4 03       	call   0x1874ab8e0
   18396b544:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396b548:	48 83 f8 10          	cmp    rax,0x10
   18396b54c:	72 35                	jb     0x18396b583
   18396b54e:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396b552:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396b556:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396b55d:	72 1f                	jb     0x18396b57e
   18396b55f:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396b563:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396b567:	4c 29 c1             	sub    rcx,r8
   18396b56a:	48 83 f9 20          	cmp    rcx,0x20
   18396b56e:	0f 83 6b 13 00 00    	jae    0x18396c8df
   18396b574:	48 83 c0 28          	add    rax,0x28
   18396b578:	48 89 c2             	mov    rdx,rax
   18396b57b:	4c 89 c1             	mov    rcx,r8
   18396b57e:	e8 5d 03 b4 03       	call   0x1874ab8e0
   18396b583:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396b58a:	00 
   18396b58b:	b9 20 00 00 00       	mov    ecx,0x20
   18396b590:	e8 07 03 b4 03       	call   0x1874ab89c
   18396b595:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396b599:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   18396b5a0:	00 
   18396b5a1:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18396b5a8:	00 
   18396b5a9:	44 0f 11 00          	movups XMMWORD PTR [rax],xmm8
   18396b5ad:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   18396b5b3:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   18396b5b7:	ba 31 00 00 00       	mov    edx,0x31
   18396b5bc:	41 b8 35 00 00 00    	mov    r8d,0x35
   18396b5c2:	e8 79 db ff ff       	call   0x183969140
   18396b5c7:	90                   	nop
   18396b5c8:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396b5cc:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   18396b5d0:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18396b5d4:	48 89 f1             	mov    rcx,rsi
   18396b5d7:	e8 14 60 db fc       	call   0x1807215f0
   18396b5dc:	90                   	nop
   18396b5dd:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18396b5e1:	48 83 f8 10          	cmp    rax,0x10
   18396b5e5:	72 35                	jb     0x18396b61c
   18396b5e7:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18396b5eb:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396b5ef:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396b5f6:	72 1f                	jb     0x18396b617
   18396b5f8:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396b5fc:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396b600:	4c 29 c1             	sub    rcx,r8
   18396b603:	48 83 f9 20          	cmp    rcx,0x20
   18396b607:	0f 83 d2 12 00 00    	jae    0x18396c8df
   18396b60d:	48 83 c0 28          	add    rax,0x28
   18396b611:	48 89 c2             	mov    rdx,rax
   18396b614:	4c 89 c1             	mov    rcx,r8
   18396b617:	e8 c4 02 b4 03       	call   0x1874ab8e0
   18396b61c:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396b620:	48 83 f8 10          	cmp    rax,0x10
   18396b624:	72 35                	jb     0x18396b65b
   18396b626:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396b62a:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396b62e:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396b635:	72 1f                	jb     0x18396b656
   18396b637:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396b63b:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396b63f:	4c 29 c1             	sub    rcx,r8
   18396b642:	48 83 f9 20          	cmp    rcx,0x20
   18396b646:	0f 83 93 12 00 00    	jae    0x18396c8df
   18396b64c:	48 83 c0 28          	add    rax,0x28
   18396b650:	48 89 c2             	mov    rdx,rax
   18396b653:	4c 89 c1             	mov    rcx,r8
   18396b656:	e8 85 02 b4 03       	call   0x1874ab8e0
   18396b65b:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396b662:	00 
   18396b663:	b9 20 00 00 00       	mov    ecx,0x20
   18396b668:	e8 2f 02 b4 03       	call   0x1874ab89c
   18396b66d:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396b671:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   18396b678:	00 
   18396b679:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18396b680:	00 
   18396b681:	44 0f 11 00          	movups XMMWORD PTR [rax],xmm8
   18396b685:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   18396b68b:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   18396b68f:	ba 31 00 00 00       	mov    edx,0x31
   18396b694:	41 b8 84 00 00 00    	mov    r8d,0x84
   18396b69a:	e8 a1 da ff ff       	call   0x183969140
   18396b69f:	90                   	nop
   18396b6a0:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396b6a4:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   18396b6a8:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18396b6ac:	48 89 f1             	mov    rcx,rsi
   18396b6af:	e8 3c 5f db fc       	call   0x1807215f0
   18396b6b4:	90                   	nop
   18396b6b5:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18396b6b9:	48 83 f8 10          	cmp    rax,0x10
   18396b6bd:	72 35                	jb     0x18396b6f4
   18396b6bf:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18396b6c3:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396b6c7:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396b6ce:	72 1f                	jb     0x18396b6ef
   18396b6d0:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396b6d4:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396b6d8:	4c 29 c1             	sub    rcx,r8
   18396b6db:	48 83 f9 20          	cmp    rcx,0x20
   18396b6df:	0f 83 fa 11 00 00    	jae    0x18396c8df
   18396b6e5:	48 83 c0 28          	add    rax,0x28
   18396b6e9:	48 89 c2             	mov    rdx,rax
   18396b6ec:	4c 89 c1             	mov    rcx,r8
   18396b6ef:	e8 ec 01 b4 03       	call   0x1874ab8e0
   18396b6f4:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396b6f8:	48 83 f8 10          	cmp    rax,0x10
   18396b6fc:	72 35                	jb     0x18396b733
   18396b6fe:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396b702:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396b706:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396b70d:	72 1f                	jb     0x18396b72e
   18396b70f:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396b713:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396b717:	4c 29 c1             	sub    rcx,r8
   18396b71a:	48 83 f9 20          	cmp    rcx,0x20
   18396b71e:	0f 83 bb 11 00 00    	jae    0x18396c8df
   18396b724:	48 83 c0 28          	add    rax,0x28
   18396b728:	48 89 c2             	mov    rdx,rax
   18396b72b:	4c 89 c1             	mov    rcx,r8
   18396b72e:	e8 ad 01 b4 03       	call   0x1874ab8e0
   18396b733:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   18396b737:	48 89 da             	mov    rdx,rbx
   18396b73a:	e8 11 4c 00 00       	call   0x183970350
   18396b73f:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396b746:	00 
   18396b747:	b9 20 00 00 00       	mov    ecx,0x20
   18396b74c:	e8 4b 01 b4 03       	call   0x1874ab89c
   18396b751:	90                   	nop
   18396b752:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396b756:	48 c7 45 e8 17 00 00 	mov    QWORD PTR [rbp-0x18],0x17
   18396b75d:	00 
   18396b75e:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18396b765:	00 
   18396b766:	44 0f 10 05 0a be b9 	movups xmm8,XMMWORD PTR [rip+0x5b9be0a]        # 0x189507578
   18396b76d:	05 
   18396b76e:	44 0f 11 00          	movups XMMWORD PTR [rax],xmm8
   18396b772:	4c 89 78 0f          	mov    QWORD PTR [rax+0xf],r15
   18396b776:	c6 40 17 00          	mov    BYTE PTR [rax+0x17],0x0
   18396b77a:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396b77e:	4c 8d 45 d8          	lea    r8,[rbp-0x28]
   18396b782:	4c 8d 4d b0          	lea    r9,[rbp-0x50]
   18396b786:	48 89 f9             	mov    rcx,rdi
   18396b789:	e8 c2 46 00 00       	call   0x18396fe50
   18396b78e:	90                   	nop
   18396b78f:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396b793:	48 83 f8 10          	cmp    rax,0x10
   18396b797:	72 35                	jb     0x18396b7ce
   18396b799:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396b79d:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396b7a1:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396b7a8:	72 1f                	jb     0x18396b7c9
   18396b7aa:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396b7ae:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396b7b2:	4c 29 c1             	sub    rcx,r8
   18396b7b5:	48 83 f9 20          	cmp    rcx,0x20
   18396b7b9:	0f 83 20 11 00 00    	jae    0x18396c8df
   18396b7bf:	48 83 c0 28          	add    rax,0x28
   18396b7c3:	48 89 c2             	mov    rdx,rax
   18396b7c6:	4c 89 c1             	mov    rcx,r8
   18396b7c9:	e8 12 01 b4 03       	call   0x1874ab8e0
   18396b7ce:	4c 8b 75 b8          	mov    r14,QWORD PTR [rbp-0x48]
   18396b7d2:	4d 85 f6             	test   r14,r14
   18396b7d5:	74 1f                	je     0x18396b7f6
   18396b7d7:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   18396b7dc:	75 18                	jne    0x18396b7f6
   18396b7de:	49 8b 06             	mov    rax,QWORD PTR [r14]
   18396b7e1:	4c 89 f1             	mov    rcx,r14
   18396b7e4:	ff 10                	call   QWORD PTR [rax]
   18396b7e6:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   18396b7eb:	75 09                	jne    0x18396b7f6
   18396b7ed:	49 8b 06             	mov    rax,QWORD PTR [r14]
   18396b7f0:	4c 89 f1             	mov    rcx,r14
   18396b7f3:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18396b7f6:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396b7fd:	00 
   18396b7fe:	b9 20 00 00 00       	mov    ecx,0x20
   18396b803:	e8 94 00 b4 03       	call   0x1874ab89c
   18396b808:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396b80c:	48 c7 45 e8 17 00 00 	mov    QWORD PTR [rbp-0x18],0x17
   18396b813:	00 
   18396b814:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18396b81b:	00 
   18396b81c:	44 0f 11 00          	movups XMMWORD PTR [rax],xmm8
   18396b820:	4c 89 78 0f          	mov    QWORD PTR [rax+0xf],r15
   18396b824:	c6 40 17 00          	mov    BYTE PTR [rax+0x17],0x0
   18396b828:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   18396b82c:	ba 31 00 00 00       	mov    edx,0x31
   18396b831:	41 b8 39 00 00 00    	mov    r8d,0x39
   18396b837:	e8 04 d9 ff ff       	call   0x183969140
   18396b83c:	90                   	nop
   18396b83d:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396b841:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   18396b845:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18396b849:	48 89 f1             	mov    rcx,rsi
   18396b84c:	e8 8f 95 6b fd       	call   0x181024de0
   18396b851:	90                   	nop
   18396b852:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18396b856:	48 83 f8 10          	cmp    rax,0x10
   18396b85a:	72 35                	jb     0x18396b891
   18396b85c:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18396b860:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396b864:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396b86b:	72 1f                	jb     0x18396b88c
   18396b86d:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396b871:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396b875:	4c 29 c1             	sub    rcx,r8
   18396b878:	48 83 f9 20          	cmp    rcx,0x20
   18396b87c:	0f 83 5d 10 00 00    	jae    0x18396c8df
   18396b882:	48 83 c0 28          	add    rax,0x28
   18396b886:	48 89 c2             	mov    rdx,rax
   18396b889:	4c 89 c1             	mov    rcx,r8
   18396b88c:	e8 4f 00 b4 03       	call   0x1874ab8e0
   18396b891:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396b895:	48 83 f8 10          	cmp    rax,0x10
   18396b899:	72 35                	jb     0x18396b8d0
   18396b89b:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396b89f:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396b8a3:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396b8aa:	72 1f                	jb     0x18396b8cb
   18396b8ac:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396b8b0:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396b8b4:	4c 29 c1             	sub    rcx,r8
   18396b8b7:	48 83 f9 20          	cmp    rcx,0x20
   18396b8bb:	0f 83 1e 10 00 00    	jae    0x18396c8df
   18396b8c1:	48 83 c0 28          	add    rax,0x28
   18396b8c5:	48 89 c2             	mov    rdx,rax
   18396b8c8:	4c 89 c1             	mov    rcx,r8
   18396b8cb:	e8 10 00 b4 03       	call   0x1874ab8e0
   18396b8d0:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   18396b8d4:	48 89 da             	mov    rdx,rbx
   18396b8d7:	e8 84 4b 00 00       	call   0x183970460
   18396b8dc:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396b8e3:	00 
   18396b8e4:	b9 30 00 00 00       	mov    ecx,0x30
   18396b8e9:	e8 ae ff b3 03       	call   0x1874ab89c
   18396b8ee:	90                   	nop
   18396b8ef:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396b8f3:	48 c7 45 e8 21 00 00 	mov    QWORD PTR [rbp-0x18],0x21
   18396b8fa:	00 
   18396b8fb:	48 c7 45 f0 2f 00 00 	mov    QWORD PTR [rbp-0x10],0x2f
   18396b902:	00 
   18396b903:	44 0f 10 05 95 bc b9 	movups xmm8,XMMWORD PTR [rip+0x5b9bc95]        # 0x1895075a0
   18396b90a:	05 
   18396b90b:	44 0f 11 40 10       	movups XMMWORD PTR [rax+0x10],xmm8
   18396b910:	44 0f 10 0d 78 bc b9 	movups xmm9,XMMWORD PTR [rip+0x5b9bc78]        # 0x189507590
   18396b917:	05 
   18396b918:	44 0f 11 08          	movups XMMWORD PTR [rax],xmm9
   18396b91c:	66 c7 40 20 72 00    	mov    WORD PTR [rax+0x20],0x72
   18396b922:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396b926:	4c 8d 45 d8          	lea    r8,[rbp-0x28]
   18396b92a:	4c 8d 4d b0          	lea    r9,[rbp-0x50]
   18396b92e:	48 89 f9             	mov    rcx,rdi
   18396b931:	e8 1a 45 00 00       	call   0x18396fe50
   18396b936:	90                   	nop
   18396b937:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396b93b:	48 83 f8 10          	cmp    rax,0x10
   18396b93f:	72 35                	jb     0x18396b976
   18396b941:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396b945:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396b949:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396b950:	72 1f                	jb     0x18396b971
   18396b952:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396b956:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396b95a:	4c 29 c1             	sub    rcx,r8
   18396b95d:	48 83 f9 20          	cmp    rcx,0x20
   18396b961:	0f 83 78 0f 00 00    	jae    0x18396c8df
   18396b967:	48 83 c0 28          	add    rax,0x28
   18396b96b:	48 89 c2             	mov    rdx,rax
   18396b96e:	4c 89 c1             	mov    rcx,r8
   18396b971:	e8 6a ff b3 03       	call   0x1874ab8e0
   18396b976:	4c 8b 75 b8          	mov    r14,QWORD PTR [rbp-0x48]
   18396b97a:	4d 85 f6             	test   r14,r14
   18396b97d:	74 1f                	je     0x18396b99e
   18396b97f:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   18396b984:	75 18                	jne    0x18396b99e
   18396b986:	49 8b 06             	mov    rax,QWORD PTR [r14]
   18396b989:	4c 89 f1             	mov    rcx,r14
   18396b98c:	ff 10                	call   QWORD PTR [rax]
   18396b98e:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   18396b993:	75 09                	jne    0x18396b99e
   18396b995:	49 8b 06             	mov    rax,QWORD PTR [r14]
   18396b998:	4c 89 f1             	mov    rcx,r14
   18396b99b:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18396b99e:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396b9a5:	00 
   18396b9a6:	b9 30 00 00 00       	mov    ecx,0x30
   18396b9ab:	e8 ec fe b3 03       	call   0x1874ab89c
   18396b9b0:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396b9b4:	48 c7 45 e8 21 00 00 	mov    QWORD PTR [rbp-0x18],0x21
   18396b9bb:	00 
   18396b9bc:	48 c7 45 f0 2f 00 00 	mov    QWORD PTR [rbp-0x10],0x2f
   18396b9c3:	00 
   18396b9c4:	44 0f 11 08          	movups XMMWORD PTR [rax],xmm9
   18396b9c8:	44 0f 11 40 10       	movups XMMWORD PTR [rax+0x10],xmm8
   18396b9cd:	66 c7 40 20 72 00    	mov    WORD PTR [rax+0x20],0x72
   18396b9d3:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   18396b9d7:	ba 31 00 00 00       	mov    edx,0x31
   18396b9dc:	41 b8 54 00 00 00    	mov    r8d,0x54
   18396b9e2:	e8 59 d7 ff ff       	call   0x183969140
   18396b9e7:	90                   	nop
   18396b9e8:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396b9ec:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   18396b9f0:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18396b9f4:	48 89 f1             	mov    rcx,rsi
   18396b9f7:	e8 e4 93 6b fd       	call   0x181024de0
   18396b9fc:	90                   	nop
   18396b9fd:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18396ba01:	48 83 f8 10          	cmp    rax,0x10
   18396ba05:	72 35                	jb     0x18396ba3c
   18396ba07:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18396ba0b:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396ba0f:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396ba16:	72 1f                	jb     0x18396ba37
   18396ba18:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396ba1c:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396ba20:	4c 29 c1             	sub    rcx,r8
   18396ba23:	48 83 f9 20          	cmp    rcx,0x20
   18396ba27:	0f 83 b2 0e 00 00    	jae    0x18396c8df
   18396ba2d:	48 83 c0 28          	add    rax,0x28
   18396ba31:	48 89 c2             	mov    rdx,rax
   18396ba34:	4c 89 c1             	mov    rcx,r8
   18396ba37:	e8 a4 fe b3 03       	call   0x1874ab8e0
   18396ba3c:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396ba40:	48 83 f8 10          	cmp    rax,0x10
   18396ba44:	72 35                	jb     0x18396ba7b
   18396ba46:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396ba4a:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396ba4e:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396ba55:	72 1f                	jb     0x18396ba76
   18396ba57:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396ba5b:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396ba5f:	4c 29 c1             	sub    rcx,r8
   18396ba62:	48 83 f9 20          	cmp    rcx,0x20
   18396ba66:	0f 83 73 0e 00 00    	jae    0x18396c8df
   18396ba6c:	48 83 c0 28          	add    rax,0x28
   18396ba70:	48 89 c2             	mov    rdx,rax
   18396ba73:	4c 89 c1             	mov    rcx,r8
   18396ba76:	e8 65 fe b3 03       	call   0x1874ab8e0
   18396ba7b:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396ba82:	00 
   18396ba83:	b9 30 00 00 00       	mov    ecx,0x30
   18396ba88:	e8 0f fe b3 03       	call   0x1874ab89c
   18396ba8d:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396ba91:	48 c7 45 e8 21 00 00 	mov    QWORD PTR [rbp-0x18],0x21
   18396ba98:	00 
   18396ba99:	48 c7 45 f0 2f 00 00 	mov    QWORD PTR [rbp-0x10],0x2f
   18396baa0:	00 
   18396baa1:	44 0f 11 08          	movups XMMWORD PTR [rax],xmm9
   18396baa5:	44 0f 11 40 10       	movups XMMWORD PTR [rax+0x10],xmm8
   18396baaa:	66 c7 40 20 72 00    	mov    WORD PTR [rax+0x20],0x72
   18396bab0:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   18396bab4:	ba 31 00 00 00       	mov    edx,0x31
   18396bab9:	41 b8 67 00 00 00    	mov    r8d,0x67
   18396babf:	e8 7c d6 ff ff       	call   0x183969140
   18396bac4:	90                   	nop
   18396bac5:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396bac9:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   18396bacd:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18396bad1:	48 89 f1             	mov    rcx,rsi
   18396bad4:	e8 07 93 6b fd       	call   0x181024de0
   18396bad9:	90                   	nop
   18396bada:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18396bade:	48 83 f8 10          	cmp    rax,0x10
   18396bae2:	72 35                	jb     0x18396bb19
   18396bae4:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18396bae8:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396baec:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396baf3:	72 1f                	jb     0x18396bb14
   18396baf5:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396baf9:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396bafd:	4c 29 c1             	sub    rcx,r8
   18396bb00:	48 83 f9 20          	cmp    rcx,0x20
   18396bb04:	0f 83 d5 0d 00 00    	jae    0x18396c8df
   18396bb0a:	48 83 c0 28          	add    rax,0x28
   18396bb0e:	48 89 c2             	mov    rdx,rax
   18396bb11:	4c 89 c1             	mov    rcx,r8
   18396bb14:	e8 c7 fd b3 03       	call   0x1874ab8e0
   18396bb19:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396bb1d:	48 83 f8 10          	cmp    rax,0x10
   18396bb21:	72 35                	jb     0x18396bb58
   18396bb23:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396bb27:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396bb2b:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396bb32:	72 1f                	jb     0x18396bb53
   18396bb34:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396bb38:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396bb3c:	4c 29 c1             	sub    rcx,r8
   18396bb3f:	48 83 f9 20          	cmp    rcx,0x20
   18396bb43:	0f 83 96 0d 00 00    	jae    0x18396c8df
   18396bb49:	48 83 c0 28          	add    rax,0x28
   18396bb4d:	48 89 c2             	mov    rdx,rax
   18396bb50:	4c 89 c1             	mov    rcx,r8
   18396bb53:	e8 88 fd b3 03       	call   0x1874ab8e0
   18396bb58:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   18396bb5c:	48 89 da             	mov    rdx,rbx
   18396bb5f:	e8 0c 4a 00 00       	call   0x183970570
   18396bb64:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396bb6b:	00 
   18396bb6c:	b9 20 00 00 00       	mov    ecx,0x20
   18396bb71:	e8 26 fd b3 03       	call   0x1874ab89c
   18396bb76:	90                   	nop
   18396bb77:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396bb7b:	48 c7 45 e8 13 00 00 	mov    QWORD PTR [rbp-0x18],0x13
   18396bb82:	00 
   18396bb83:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18396bb8a:	00 
   18396bb8b:	44 0f 10 05 25 ba b9 	movups xmm8,XMMWORD PTR [rip+0x5b9ba25]        # 0x1895075b8
   18396bb92:	05 
   18396bb93:	44 0f 11 00          	movups XMMWORD PTR [rax],xmm8
   18396bb97:	c7 40 0f 64 6c 65 72 	mov    DWORD PTR [rax+0xf],0x72656c64
   18396bb9e:	c6 40 13 00          	mov    BYTE PTR [rax+0x13],0x0
   18396bba2:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396bba6:	4c 8d 45 d8          	lea    r8,[rbp-0x28]
   18396bbaa:	4c 8d 4d b0          	lea    r9,[rbp-0x50]
   18396bbae:	48 89 f9             	mov    rcx,rdi
   18396bbb1:	e8 7a 05 e9 fd       	call   0x1817fc130
   18396bbb6:	90                   	nop
   18396bbb7:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396bbbb:	48 83 f8 10          	cmp    rax,0x10
   18396bbbf:	72 35                	jb     0x18396bbf6
   18396bbc1:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396bbc5:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396bbc9:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396bbd0:	72 1f                	jb     0x18396bbf1
   18396bbd2:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396bbd6:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396bbda:	4c 29 c1             	sub    rcx,r8
   18396bbdd:	48 83 f9 20          	cmp    rcx,0x20
   18396bbe1:	0f 83 f8 0c 00 00    	jae    0x18396c8df
   18396bbe7:	48 83 c0 28          	add    rax,0x28
   18396bbeb:	48 89 c2             	mov    rdx,rax
   18396bbee:	4c 89 c1             	mov    rcx,r8
   18396bbf1:	e8 ea fc b3 03       	call   0x1874ab8e0
   18396bbf6:	4c 8b 75 b8          	mov    r14,QWORD PTR [rbp-0x48]
   18396bbfa:	4d 85 f6             	test   r14,r14
   18396bbfd:	74 1f                	je     0x18396bc1e
   18396bbff:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   18396bc04:	75 18                	jne    0x18396bc1e
   18396bc06:	49 8b 06             	mov    rax,QWORD PTR [r14]
   18396bc09:	4c 89 f1             	mov    rcx,r14
   18396bc0c:	ff 10                	call   QWORD PTR [rax]
   18396bc0e:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   18396bc13:	75 09                	jne    0x18396bc1e
   18396bc15:	49 8b 06             	mov    rax,QWORD PTR [r14]
   18396bc18:	4c 89 f1             	mov    rcx,r14
   18396bc1b:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18396bc1e:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396bc25:	00 
   18396bc26:	b9 20 00 00 00       	mov    ecx,0x20
   18396bc2b:	e8 6c fc b3 03       	call   0x1874ab89c
   18396bc30:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396bc34:	48 c7 45 e8 13 00 00 	mov    QWORD PTR [rbp-0x18],0x13
   18396bc3b:	00 
   18396bc3c:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18396bc43:	00 
   18396bc44:	44 0f 11 00          	movups XMMWORD PTR [rax],xmm8
   18396bc48:	c7 40 0f 64 6c 65 72 	mov    DWORD PTR [rax+0xf],0x72656c64
   18396bc4f:	c6 40 13 00          	mov    BYTE PTR [rax+0x13],0x0
   18396bc53:	0f 57 c0             	xorps  xmm0,xmm0
   18396bc56:	0f 29 45 b0          	movaps XMMWORD PTR [rbp-0x50],xmm0
   18396bc5a:	48 c7 45 c0 02 00 00 	mov    QWORD PTR [rbp-0x40],0x2
   18396bc61:	00 
   18396bc62:	48 c7 45 c8 0f 00 00 	mov    QWORD PTR [rbp-0x38],0xf
   18396bc69:	00 
   18396bc6a:	66 c7 45 b0 33 34    	mov    WORD PTR [rbp-0x50],0x3433
   18396bc70:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396bc74:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   18396bc78:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18396bc7c:	48 89 f1             	mov    rcx,rsi
   18396bc7f:	e8 6c 59 db fc       	call   0x1807215f0
   18396bc84:	90                   	nop
   18396bc85:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18396bc89:	48 83 f8 10          	cmp    rax,0x10
   18396bc8d:	72 35                	jb     0x18396bcc4
   18396bc8f:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18396bc93:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396bc97:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396bc9e:	72 1f                	jb     0x18396bcbf
   18396bca0:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396bca4:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396bca8:	4c 29 c1             	sub    rcx,r8
   18396bcab:	48 83 f9 20          	cmp    rcx,0x20
   18396bcaf:	0f 83 2a 0c 00 00    	jae    0x18396c8df
   18396bcb5:	48 83 c0 28          	add    rax,0x28
   18396bcb9:	48 89 c2             	mov    rdx,rax
   18396bcbc:	4c 89 c1             	mov    rcx,r8
   18396bcbf:	e8 1c fc b3 03       	call   0x1874ab8e0
   18396bcc4:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396bcc8:	48 83 f8 10          	cmp    rax,0x10
   18396bccc:	72 35                	jb     0x18396bd03
   18396bcce:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396bcd2:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396bcd6:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396bcdd:	72 1f                	jb     0x18396bcfe
   18396bcdf:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396bce3:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396bce7:	4c 29 c1             	sub    rcx,r8
   18396bcea:	48 83 f9 20          	cmp    rcx,0x20
   18396bcee:	0f 83 eb 0b 00 00    	jae    0x18396c8df
   18396bcf4:	48 83 c0 28          	add    rax,0x28
   18396bcf8:	48 89 c2             	mov    rdx,rax
   18396bcfb:	4c 89 c1             	mov    rcx,r8
   18396bcfe:	e8 dd fb b3 03       	call   0x1874ab8e0
   18396bd03:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   18396bd07:	48 89 da             	mov    rdx,rbx
   18396bd0a:	e8 d1 1f f1 ff       	call   0x18387dce0
   18396bd0f:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396bd16:	00 
   18396bd17:	b9 20 00 00 00       	mov    ecx,0x20
   18396bd1c:	e8 7b fb b3 03       	call   0x1874ab89c
   18396bd21:	90                   	nop
   18396bd22:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396bd26:	48 c7 45 e8 16 00 00 	mov    QWORD PTR [rbp-0x18],0x16
   18396bd2d:	00 
   18396bd2e:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18396bd35:	00 
   18396bd36:	44 0f 10 05 92 b8 b9 	movups xmm8,XMMWORD PTR [rip+0x5b9b892]        # 0x1895075d0
   18396bd3d:	05 
   18396bd3e:	44 0f 11 00          	movups XMMWORD PTR [rax],xmm8
   18396bd42:	4c 89 78 0e          	mov    QWORD PTR [rax+0xe],r15
   18396bd46:	c6 40 16 00          	mov    BYTE PTR [rax+0x16],0x0
   18396bd4a:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396bd4e:	4c 8d 45 d8          	lea    r8,[rbp-0x28]
   18396bd52:	4c 8d 4d b0          	lea    r9,[rbp-0x50]
   18396bd56:	48 89 f9             	mov    rcx,rdi
   18396bd59:	e8 d2 03 e9 fd       	call   0x1817fc130
   18396bd5e:	90                   	nop
   18396bd5f:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396bd63:	48 83 f8 10          	cmp    rax,0x10
   18396bd67:	72 35                	jb     0x18396bd9e
   18396bd69:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396bd6d:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396bd71:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396bd78:	72 1f                	jb     0x18396bd99
   18396bd7a:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396bd7e:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396bd82:	4c 29 c1             	sub    rcx,r8
   18396bd85:	48 83 f9 20          	cmp    rcx,0x20
   18396bd89:	0f 83 50 0b 00 00    	jae    0x18396c8df
   18396bd8f:	48 83 c0 28          	add    rax,0x28
   18396bd93:	48 89 c2             	mov    rdx,rax
   18396bd96:	4c 89 c1             	mov    rcx,r8
   18396bd99:	e8 42 fb b3 03       	call   0x1874ab8e0
   18396bd9e:	4c 8b 75 b8          	mov    r14,QWORD PTR [rbp-0x48]
   18396bda2:	4d 85 f6             	test   r14,r14
   18396bda5:	74 1f                	je     0x18396bdc6
   18396bda7:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   18396bdac:	75 18                	jne    0x18396bdc6
   18396bdae:	49 8b 06             	mov    rax,QWORD PTR [r14]
   18396bdb1:	4c 89 f1             	mov    rcx,r14
   18396bdb4:	ff 10                	call   QWORD PTR [rax]
   18396bdb6:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   18396bdbb:	75 09                	jne    0x18396bdc6
   18396bdbd:	49 8b 06             	mov    rax,QWORD PTR [r14]
   18396bdc0:	4c 89 f1             	mov    rcx,r14
   18396bdc3:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18396bdc6:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396bdcd:	00 
   18396bdce:	b9 20 00 00 00       	mov    ecx,0x20
   18396bdd3:	e8 c4 fa b3 03       	call   0x1874ab89c
   18396bdd8:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396bddc:	48 c7 45 e8 16 00 00 	mov    QWORD PTR [rbp-0x18],0x16
   18396bde3:	00 
   18396bde4:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18396bdeb:	00 
   18396bdec:	44 0f 11 00          	movups XMMWORD PTR [rax],xmm8
   18396bdf0:	4c 89 78 0e          	mov    QWORD PTR [rax+0xe],r15
   18396bdf4:	c6 40 16 00          	mov    BYTE PTR [rax+0x16],0x0
   18396bdf8:	0f 57 c0             	xorps  xmm0,xmm0
   18396bdfb:	0f 29 45 b0          	movaps XMMWORD PTR [rbp-0x50],xmm0
   18396bdff:	48 c7 45 c0 02 00 00 	mov    QWORD PTR [rbp-0x40],0x2
   18396be06:	00 
   18396be07:	48 c7 45 c8 0f 00 00 	mov    QWORD PTR [rbp-0x38],0xf
   18396be0e:	00 
   18396be0f:	66 c7 45 b0 34 37    	mov    WORD PTR [rbp-0x50],0x3734
   18396be15:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396be19:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   18396be1d:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18396be21:	48 89 f1             	mov    rcx,rsi
   18396be24:	e8 c7 57 db fc       	call   0x1807215f0
   18396be29:	90                   	nop
   18396be2a:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18396be2e:	48 83 f8 10          	cmp    rax,0x10
   18396be32:	72 35                	jb     0x18396be69
   18396be34:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18396be38:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396be3c:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396be43:	72 1f                	jb     0x18396be64
   18396be45:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396be49:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396be4d:	4c 29 c1             	sub    rcx,r8
   18396be50:	48 83 f9 20          	cmp    rcx,0x20
   18396be54:	0f 83 85 0a 00 00    	jae    0x18396c8df
   18396be5a:	48 83 c0 28          	add    rax,0x28
   18396be5e:	48 89 c2             	mov    rdx,rax
   18396be61:	4c 89 c1             	mov    rcx,r8
   18396be64:	e8 77 fa b3 03       	call   0x1874ab8e0
   18396be69:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396be6d:	48 83 f8 10          	cmp    rax,0x10
   18396be71:	72 35                	jb     0x18396bea8
   18396be73:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396be77:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396be7b:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396be82:	72 1f                	jb     0x18396bea3
   18396be84:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396be88:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396be8c:	4c 29 c1             	sub    rcx,r8
   18396be8f:	48 83 f9 20          	cmp    rcx,0x20
   18396be93:	0f 83 46 0a 00 00    	jae    0x18396c8df
   18396be99:	48 83 c0 28          	add    rax,0x28
   18396be9d:	48 89 c2             	mov    rdx,rax
   18396bea0:	4c 89 c1             	mov    rcx,r8
   18396bea3:	e8 38 fa b3 03       	call   0x1874ab8e0
   18396bea8:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396beaf:	00 
   18396beb0:	b9 20 00 00 00       	mov    ecx,0x20
   18396beb5:	e8 e2 f9 b3 03       	call   0x1874ab89c
   18396beba:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396bebe:	48 c7 45 e8 16 00 00 	mov    QWORD PTR [rbp-0x18],0x16
   18396bec5:	00 
   18396bec6:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18396becd:	00 
   18396bece:	44 0f 11 00          	movups XMMWORD PTR [rax],xmm8
   18396bed2:	4c 89 78 0e          	mov    QWORD PTR [rax+0xe],r15
   18396bed6:	c6 40 16 00          	mov    BYTE PTR [rax+0x16],0x0
   18396beda:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   18396bede:	ba 31 00 00 00       	mov    edx,0x31
   18396bee3:	41 b8 08 00 00 00    	mov    r8d,0x8
   18396bee9:	e8 52 d2 ff ff       	call   0x183969140
   18396beee:	90                   	nop
   18396beef:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396bef3:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   18396bef7:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18396befb:	48 89 f1             	mov    rcx,rsi
   18396befe:	e8 ed 56 db fc       	call   0x1807215f0
   18396bf03:	90                   	nop
   18396bf04:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18396bf08:	48 83 f8 10          	cmp    rax,0x10
   18396bf0c:	72 35                	jb     0x18396bf43
   18396bf0e:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18396bf12:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396bf16:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396bf1d:	72 1f                	jb     0x18396bf3e
   18396bf1f:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396bf23:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396bf27:	4c 29 c1             	sub    rcx,r8
   18396bf2a:	48 83 f9 20          	cmp    rcx,0x20
   18396bf2e:	0f 83 ab 09 00 00    	jae    0x18396c8df
   18396bf34:	48 83 c0 28          	add    rax,0x28
   18396bf38:	48 89 c2             	mov    rdx,rax
   18396bf3b:	4c 89 c1             	mov    rcx,r8
   18396bf3e:	e8 9d f9 b3 03       	call   0x1874ab8e0
   18396bf43:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396bf47:	48 83 f8 10          	cmp    rax,0x10
   18396bf4b:	72 35                	jb     0x18396bf82
   18396bf4d:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396bf51:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396bf55:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396bf5c:	72 1f                	jb     0x18396bf7d
   18396bf5e:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396bf62:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396bf66:	4c 29 c1             	sub    rcx,r8
   18396bf69:	48 83 f9 20          	cmp    rcx,0x20
   18396bf6d:	0f 83 6c 09 00 00    	jae    0x18396c8df
   18396bf73:	48 83 c0 28          	add    rax,0x28
   18396bf77:	48 89 c2             	mov    rdx,rax
   18396bf7a:	4c 89 c1             	mov    rcx,r8
   18396bf7d:	e8 5e f9 b3 03       	call   0x1874ab8e0
   18396bf82:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   18396bf86:	48 89 da             	mov    rdx,rbx
   18396bf89:	e8 72 1e f1 ff       	call   0x18387de00
   18396bf8e:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396bf95:	00 
   18396bf96:	b9 20 00 00 00       	mov    ecx,0x20
   18396bf9b:	e8 fc f8 b3 03       	call   0x1874ab89c
   18396bfa0:	90                   	nop
   18396bfa1:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396bfa5:	48 c7 45 e8 12 00 00 	mov    QWORD PTR [rbp-0x18],0x12
   18396bfac:	00 
   18396bfad:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18396bfb4:	00 
   18396bfb5:	44 0f 10 05 2b b6 b9 	movups xmm8,XMMWORD PTR [rip+0x5b9b62b]        # 0x1895075e8
   18396bfbc:	05 
   18396bfbd:	44 0f 11 00          	movups XMMWORD PTR [rax],xmm8
   18396bfc1:	66 c7 40 10 65 72    	mov    WORD PTR [rax+0x10],0x7265
   18396bfc7:	c6 40 12 00          	mov    BYTE PTR [rax+0x12],0x0
   18396bfcb:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396bfcf:	4c 8d 45 d8          	lea    r8,[rbp-0x28]
   18396bfd3:	4c 8d 4d b0          	lea    r9,[rbp-0x50]
   18396bfd7:	48 89 f9             	mov    rcx,rdi
   18396bfda:	e8 51 01 e9 fd       	call   0x1817fc130
   18396bfdf:	90                   	nop
   18396bfe0:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396bfe4:	48 83 f8 10          	cmp    rax,0x10
   18396bfe8:	72 35                	jb     0x18396c01f
   18396bfea:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396bfee:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396bff2:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396bff9:	72 1f                	jb     0x18396c01a
   18396bffb:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396bfff:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396c003:	4c 29 c1             	sub    rcx,r8
   18396c006:	48 83 f9 20          	cmp    rcx,0x20
   18396c00a:	0f 83 cf 08 00 00    	jae    0x18396c8df
   18396c010:	48 83 c0 28          	add    rax,0x28
   18396c014:	48 89 c2             	mov    rdx,rax
   18396c017:	4c 89 c1             	mov    rcx,r8
   18396c01a:	e8 c1 f8 b3 03       	call   0x1874ab8e0
   18396c01f:	4c 8b 75 b8          	mov    r14,QWORD PTR [rbp-0x48]
   18396c023:	4d 85 f6             	test   r14,r14
   18396c026:	74 1f                	je     0x18396c047
   18396c028:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   18396c02d:	75 18                	jne    0x18396c047
   18396c02f:	49 8b 06             	mov    rax,QWORD PTR [r14]
   18396c032:	4c 89 f1             	mov    rcx,r14
   18396c035:	ff 10                	call   QWORD PTR [rax]
   18396c037:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   18396c03c:	75 09                	jne    0x18396c047
   18396c03e:	49 8b 06             	mov    rax,QWORD PTR [r14]
   18396c041:	4c 89 f1             	mov    rcx,r14
   18396c044:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18396c047:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396c04e:	00 
   18396c04f:	b9 20 00 00 00       	mov    ecx,0x20
   18396c054:	e8 43 f8 b3 03       	call   0x1874ab89c
   18396c059:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396c05d:	48 c7 45 e8 12 00 00 	mov    QWORD PTR [rbp-0x18],0x12
   18396c064:	00 
   18396c065:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18396c06c:	00 
   18396c06d:	44 0f 11 00          	movups XMMWORD PTR [rax],xmm8
   18396c071:	66 c7 40 10 65 72    	mov    WORD PTR [rax+0x10],0x7265
   18396c077:	c6 40 12 00          	mov    BYTE PTR [rax+0x12],0x0
   18396c07b:	0f 57 c0             	xorps  xmm0,xmm0
   18396c07e:	0f 29 45 b0          	movaps XMMWORD PTR [rbp-0x50],xmm0
   18396c082:	48 c7 45 c0 02 00 00 	mov    QWORD PTR [rbp-0x40],0x2
   18396c089:	00 
   18396c08a:	48 c7 45 c8 0f 00 00 	mov    QWORD PTR [rbp-0x38],0xf
   18396c091:	00 
   18396c092:	66 c7 45 b0 35 30    	mov    WORD PTR [rbp-0x50],0x3035
   18396c098:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396c09c:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   18396c0a0:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18396c0a4:	48 89 f1             	mov    rcx,rsi
   18396c0a7:	e8 44 55 db fc       	call   0x1807215f0
   18396c0ac:	90                   	nop
   18396c0ad:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18396c0b1:	48 83 f8 10          	cmp    rax,0x10
   18396c0b5:	72 35                	jb     0x18396c0ec
   18396c0b7:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18396c0bb:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396c0bf:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396c0c6:	72 1f                	jb     0x18396c0e7
   18396c0c8:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396c0cc:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396c0d0:	4c 29 c1             	sub    rcx,r8
   18396c0d3:	48 83 f9 20          	cmp    rcx,0x20
   18396c0d7:	0f 83 02 08 00 00    	jae    0x18396c8df
   18396c0dd:	48 83 c0 28          	add    rax,0x28
   18396c0e1:	48 89 c2             	mov    rdx,rax
   18396c0e4:	4c 89 c1             	mov    rcx,r8
   18396c0e7:	e8 f4 f7 b3 03       	call   0x1874ab8e0
   18396c0ec:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396c0f0:	48 83 f8 10          	cmp    rax,0x10
   18396c0f4:	72 35                	jb     0x18396c12b
   18396c0f6:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396c0fa:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396c0fe:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396c105:	72 1f                	jb     0x18396c126
   18396c107:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396c10b:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396c10f:	4c 29 c1             	sub    rcx,r8
   18396c112:	48 83 f9 20          	cmp    rcx,0x20
   18396c116:	0f 83 c3 07 00 00    	jae    0x18396c8df
   18396c11c:	48 83 c0 28          	add    rax,0x28
   18396c120:	48 89 c2             	mov    rdx,rax
   18396c123:	4c 89 c1             	mov    rcx,r8
   18396c126:	e8 b5 f7 b3 03       	call   0x1874ab8e0
   18396c12b:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   18396c12f:	48 89 da             	mov    rdx,rbx
   18396c132:	e8 49 45 00 00       	call   0x183970680
   18396c137:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396c13e:	00 
   18396c13f:	b9 20 00 00 00       	mov    ecx,0x20
   18396c144:	e8 53 f7 b3 03       	call   0x1874ab89c
   18396c149:	90                   	nop
   18396c14a:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396c14e:	48 c7 45 e8 14 00 00 	mov    QWORD PTR [rbp-0x18],0x14
   18396c155:	00 
   18396c156:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18396c15d:	00 
   18396c15e:	44 0f 10 05 9a b4 b9 	movups xmm8,XMMWORD PTR [rip+0x5b9b49a]        # 0x189507600
   18396c165:	05 
   18396c166:	44 0f 11 00          	movups XMMWORD PTR [rax],xmm8
   18396c16a:	c7 40 10 64 6c 65 72 	mov    DWORD PTR [rax+0x10],0x72656c64
   18396c171:	c6 40 14 00          	mov    BYTE PTR [rax+0x14],0x0
   18396c175:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396c179:	4c 8d 45 d8          	lea    r8,[rbp-0x28]
   18396c17d:	4c 8d 4d b0          	lea    r9,[rbp-0x50]
   18396c181:	48 89 f9             	mov    rcx,rdi
   18396c184:	e8 a7 ff e8 fd       	call   0x1817fc130
   18396c189:	90                   	nop
   18396c18a:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396c18e:	48 83 f8 10          	cmp    rax,0x10
   18396c192:	72 35                	jb     0x18396c1c9
   18396c194:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396c198:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396c19c:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396c1a3:	72 1f                	jb     0x18396c1c4
   18396c1a5:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396c1a9:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396c1ad:	4c 29 c1             	sub    rcx,r8
   18396c1b0:	48 83 f9 20          	cmp    rcx,0x20
   18396c1b4:	0f 83 25 07 00 00    	jae    0x18396c8df
   18396c1ba:	48 83 c0 28          	add    rax,0x28
   18396c1be:	48 89 c2             	mov    rdx,rax
   18396c1c1:	4c 89 c1             	mov    rcx,r8
   18396c1c4:	e8 17 f7 b3 03       	call   0x1874ab8e0
   18396c1c9:	4c 8b 75 b8          	mov    r14,QWORD PTR [rbp-0x48]
   18396c1cd:	4d 85 f6             	test   r14,r14
   18396c1d0:	74 1f                	je     0x18396c1f1
   18396c1d2:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   18396c1d7:	75 18                	jne    0x18396c1f1
   18396c1d9:	49 8b 06             	mov    rax,QWORD PTR [r14]
   18396c1dc:	4c 89 f1             	mov    rcx,r14
   18396c1df:	ff 10                	call   QWORD PTR [rax]
   18396c1e1:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   18396c1e6:	75 09                	jne    0x18396c1f1
   18396c1e8:	49 8b 06             	mov    rax,QWORD PTR [r14]
   18396c1eb:	4c 89 f1             	mov    rcx,r14
   18396c1ee:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18396c1f1:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396c1f8:	00 
   18396c1f9:	b9 20 00 00 00       	mov    ecx,0x20
   18396c1fe:	e8 99 f6 b3 03       	call   0x1874ab89c
   18396c203:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396c207:	48 c7 45 e8 14 00 00 	mov    QWORD PTR [rbp-0x18],0x14
   18396c20e:	00 
   18396c20f:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18396c216:	00 
   18396c217:	44 0f 11 00          	movups XMMWORD PTR [rax],xmm8
   18396c21b:	c7 40 10 64 6c 65 72 	mov    DWORD PTR [rax+0x10],0x72656c64
   18396c222:	c6 40 14 00          	mov    BYTE PTR [rax+0x14],0x0
   18396c226:	0f 57 c0             	xorps  xmm0,xmm0
   18396c229:	0f 29 45 b0          	movaps XMMWORD PTR [rbp-0x50],xmm0
   18396c22d:	48 c7 45 c0 05 00 00 	mov    QWORD PTR [rbp-0x40],0x5
   18396c234:	00 
   18396c235:	48 c7 45 c8 0f 00 00 	mov    QWORD PTR [rbp-0x38],0xf
   18396c23c:	00 
   18396c23d:	c6 45 b0 31          	mov    BYTE PTR [rbp-0x50],0x31
   18396c241:	c7 45 b1 30 30 30 30 	mov    DWORD PTR [rbp-0x4f],0x30303030
   18396c248:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396c24c:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   18396c250:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18396c254:	48 89 f1             	mov    rcx,rsi
   18396c257:	e8 94 53 db fc       	call   0x1807215f0
   18396c25c:	90                   	nop
   18396c25d:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18396c261:	48 83 f8 10          	cmp    rax,0x10
   18396c265:	72 35                	jb     0x18396c29c
   18396c267:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18396c26b:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396c26f:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396c276:	72 1f                	jb     0x18396c297
   18396c278:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396c27c:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396c280:	4c 29 c1             	sub    rcx,r8
   18396c283:	48 83 f9 20          	cmp    rcx,0x20
   18396c287:	0f 83 52 06 00 00    	jae    0x18396c8df
   18396c28d:	48 83 c0 28          	add    rax,0x28
   18396c291:	48 89 c2             	mov    rdx,rax
   18396c294:	4c 89 c1             	mov    rcx,r8
   18396c297:	e8 44 f6 b3 03       	call   0x1874ab8e0
   18396c29c:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396c2a0:	48 83 f8 10          	cmp    rax,0x10
   18396c2a4:	72 35                	jb     0x18396c2db
   18396c2a6:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396c2aa:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396c2ae:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396c2b5:	72 1f                	jb     0x18396c2d6
   18396c2b7:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396c2bb:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396c2bf:	4c 29 c1             	sub    rcx,r8
   18396c2c2:	48 83 f9 20          	cmp    rcx,0x20
   18396c2c6:	0f 83 13 06 00 00    	jae    0x18396c8df
   18396c2cc:	48 83 c0 28          	add    rax,0x28
   18396c2d0:	48 89 c2             	mov    rdx,rax
   18396c2d3:	4c 89 c1             	mov    rcx,r8
   18396c2d6:	e8 05 f6 b3 03       	call   0x1874ab8e0
   18396c2db:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   18396c2df:	48 89 da             	mov    rdx,rbx
   18396c2e2:	e8 89 1c f1 ff       	call   0x18387df70
   18396c2e7:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396c2ee:	00 
   18396c2ef:	b9 20 00 00 00       	mov    ecx,0x20
   18396c2f4:	e8 a3 f5 b3 03       	call   0x1874ab89c
   18396c2f9:	90                   	nop
   18396c2fa:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396c2fe:	48 c7 45 e8 16 00 00 	mov    QWORD PTR [rbp-0x18],0x16
   18396c305:	00 
   18396c306:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18396c30d:	00 
   18396c30e:	44 0f 10 05 02 b3 b9 	movups xmm8,XMMWORD PTR [rip+0x5b9b302]        # 0x189507618
   18396c315:	05 
   18396c316:	44 0f 11 00          	movups XMMWORD PTR [rax],xmm8
   18396c31a:	4c 89 78 0e          	mov    QWORD PTR [rax+0xe],r15
   18396c31e:	c6 40 16 00          	mov    BYTE PTR [rax+0x16],0x0
   18396c322:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396c326:	4c 8d 45 d8          	lea    r8,[rbp-0x28]
   18396c32a:	4c 8d 4d b0          	lea    r9,[rbp-0x50]
   18396c32e:	48 89 f9             	mov    rcx,rdi
   18396c331:	e8 fa fd e8 fd       	call   0x1817fc130
   18396c336:	90                   	nop
   18396c337:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396c33b:	48 83 f8 10          	cmp    rax,0x10
   18396c33f:	72 35                	jb     0x18396c376
   18396c341:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396c345:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396c349:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396c350:	72 1f                	jb     0x18396c371
   18396c352:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396c356:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396c35a:	4c 29 c1             	sub    rcx,r8
   18396c35d:	48 83 f9 20          	cmp    rcx,0x20
   18396c361:	0f 83 78 05 00 00    	jae    0x18396c8df
   18396c367:	48 83 c0 28          	add    rax,0x28
   18396c36b:	48 89 c2             	mov    rdx,rax
   18396c36e:	4c 89 c1             	mov    rcx,r8
   18396c371:	e8 6a f5 b3 03       	call   0x1874ab8e0
   18396c376:	4c 8b 75 b8          	mov    r14,QWORD PTR [rbp-0x48]
   18396c37a:	4d 85 f6             	test   r14,r14
   18396c37d:	74 1f                	je     0x18396c39e
   18396c37f:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   18396c384:	75 18                	jne    0x18396c39e
   18396c386:	49 8b 06             	mov    rax,QWORD PTR [r14]
   18396c389:	4c 89 f1             	mov    rcx,r14
   18396c38c:	ff 10                	call   QWORD PTR [rax]
   18396c38e:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   18396c393:	75 09                	jne    0x18396c39e
   18396c395:	49 8b 06             	mov    rax,QWORD PTR [r14]
   18396c398:	4c 89 f1             	mov    rcx,r14
   18396c39b:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18396c39e:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396c3a5:	00 
   18396c3a6:	b9 20 00 00 00       	mov    ecx,0x20
   18396c3ab:	e8 ec f4 b3 03       	call   0x1874ab89c
   18396c3b0:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396c3b4:	48 c7 45 e8 16 00 00 	mov    QWORD PTR [rbp-0x18],0x16
   18396c3bb:	00 
   18396c3bc:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18396c3c3:	00 
   18396c3c4:	44 0f 11 00          	movups XMMWORD PTR [rax],xmm8
   18396c3c8:	4c 89 78 0e          	mov    QWORD PTR [rax+0xe],r15
   18396c3cc:	c6 40 16 00          	mov    BYTE PTR [rax+0x16],0x0
   18396c3d0:	0f 57 c0             	xorps  xmm0,xmm0
   18396c3d3:	0f 29 45 b0          	movaps XMMWORD PTR [rbp-0x50],xmm0
   18396c3d7:	48 c7 45 c0 02 00 00 	mov    QWORD PTR [rbp-0x40],0x2
   18396c3de:	00 
   18396c3df:	48 c7 45 c8 0f 00 00 	mov    QWORD PTR [rbp-0x38],0xf
   18396c3e6:	00 
   18396c3e7:	66 c7 45 b0 34 38    	mov    WORD PTR [rbp-0x50],0x3834
   18396c3ed:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396c3f1:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   18396c3f5:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18396c3f9:	48 89 f1             	mov    rcx,rsi
   18396c3fc:	e8 ef 51 db fc       	call   0x1807215f0
   18396c401:	90                   	nop
   18396c402:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18396c406:	48 83 f8 10          	cmp    rax,0x10
   18396c40a:	72 35                	jb     0x18396c441
   18396c40c:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18396c410:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396c414:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396c41b:	72 1f                	jb     0x18396c43c
   18396c41d:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396c421:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396c425:	4c 29 c1             	sub    rcx,r8
   18396c428:	48 83 f9 20          	cmp    rcx,0x20
   18396c42c:	0f 83 ad 04 00 00    	jae    0x18396c8df
   18396c432:	48 83 c0 28          	add    rax,0x28
   18396c436:	48 89 c2             	mov    rdx,rax
   18396c439:	4c 89 c1             	mov    rcx,r8
   18396c43c:	e8 9f f4 b3 03       	call   0x1874ab8e0
   18396c441:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396c445:	48 83 f8 10          	cmp    rax,0x10
   18396c449:	72 35                	jb     0x18396c480
   18396c44b:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396c44f:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396c453:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396c45a:	72 1f                	jb     0x18396c47b
   18396c45c:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396c460:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396c464:	4c 29 c1             	sub    rcx,r8
   18396c467:	48 83 f9 20          	cmp    rcx,0x20
   18396c46b:	0f 83 6e 04 00 00    	jae    0x18396c8df
   18396c471:	48 83 c0 28          	add    rax,0x28
   18396c475:	48 89 c2             	mov    rdx,rax
   18396c478:	4c 89 c1             	mov    rcx,r8
   18396c47b:	e8 60 f4 b3 03       	call   0x1874ab8e0
   18396c480:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   18396c484:	48 89 da             	mov    rdx,rbx
   18396c487:	e8 04 1c f1 ff       	call   0x18387e090
   18396c48c:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396c493:	00 
   18396c494:	b9 20 00 00 00       	mov    ecx,0x20
   18396c499:	e8 fe f3 b3 03       	call   0x1874ab89c
   18396c49e:	90                   	nop
   18396c49f:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396c4a3:	48 c7 45 e8 17 00 00 	mov    QWORD PTR [rbp-0x18],0x17
   18396c4aa:	00 
   18396c4ab:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18396c4b2:	00 
   18396c4b3:	44 0f 10 05 75 b1 b9 	movups xmm8,XMMWORD PTR [rip+0x5b9b175]        # 0x189507630
   18396c4ba:	05 
   18396c4bb:	44 0f 11 00          	movups XMMWORD PTR [rax],xmm8
   18396c4bf:	4c 89 78 0f          	mov    QWORD PTR [rax+0xf],r15
   18396c4c3:	c6 40 17 00          	mov    BYTE PTR [rax+0x17],0x0
   18396c4c7:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396c4cb:	4c 8d 45 d8          	lea    r8,[rbp-0x28]
   18396c4cf:	4c 8d 4d b0          	lea    r9,[rbp-0x50]
   18396c4d3:	48 89 f9             	mov    rcx,rdi
   18396c4d6:	e8 55 fc e8 fd       	call   0x1817fc130
   18396c4db:	90                   	nop
   18396c4dc:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396c4e0:	48 83 f8 10          	cmp    rax,0x10
   18396c4e4:	72 35                	jb     0x18396c51b
   18396c4e6:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396c4ea:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396c4ee:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396c4f5:	72 1f                	jb     0x18396c516
   18396c4f7:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396c4fb:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396c4ff:	4c 29 c1             	sub    rcx,r8
   18396c502:	48 83 f9 20          	cmp    rcx,0x20
   18396c506:	0f 83 d3 03 00 00    	jae    0x18396c8df
   18396c50c:	48 83 c0 28          	add    rax,0x28
   18396c510:	48 89 c2             	mov    rdx,rax
   18396c513:	4c 89 c1             	mov    rcx,r8
   18396c516:	e8 c5 f3 b3 03       	call   0x1874ab8e0
   18396c51b:	48 8b 7d b8          	mov    rdi,QWORD PTR [rbp-0x48]
   18396c51f:	48 85 ff             	test   rdi,rdi
   18396c522:	74 1d                	je     0x18396c541
   18396c524:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   18396c528:	75 17                	jne    0x18396c541
   18396c52a:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   18396c52d:	48 89 f9             	mov    rcx,rdi
   18396c530:	ff 10                	call   QWORD PTR [rax]
   18396c532:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   18396c536:	75 09                	jne    0x18396c541
   18396c538:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   18396c53b:	48 89 f9             	mov    rcx,rdi
   18396c53e:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18396c541:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396c548:	00 
   18396c549:	b9 20 00 00 00       	mov    ecx,0x20
   18396c54e:	e8 49 f3 b3 03       	call   0x1874ab89c
   18396c553:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396c557:	48 c7 45 e8 17 00 00 	mov    QWORD PTR [rbp-0x18],0x17
   18396c55e:	00 
   18396c55f:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18396c566:	00 
   18396c567:	44 0f 11 00          	movups XMMWORD PTR [rax],xmm8
   18396c56b:	4c 89 78 0f          	mov    QWORD PTR [rax+0xf],r15
   18396c56f:	c6 40 17 00          	mov    BYTE PTR [rax+0x17],0x0
   18396c573:	0f 57 c0             	xorps  xmm0,xmm0
   18396c576:	0f 29 45 b0          	movaps XMMWORD PTR [rbp-0x50],xmm0
   18396c57a:	48 c7 45 c0 02 00 00 	mov    QWORD PTR [rbp-0x40],0x2
   18396c581:	00 
   18396c582:	48 c7 45 c8 0f 00 00 	mov    QWORD PTR [rbp-0x38],0xf
   18396c589:	00 
   18396c58a:	66 c7 45 b0 34 32    	mov    WORD PTR [rbp-0x50],0x3234
   18396c590:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396c594:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   18396c598:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18396c59c:	48 89 f1             	mov    rcx,rsi
   18396c59f:	e8 4c 50 db fc       	call   0x1807215f0
   18396c5a4:	90                   	nop
   18396c5a5:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18396c5a9:	48 83 f8 10          	cmp    rax,0x10
   18396c5ad:	72 35                	jb     0x18396c5e4
   18396c5af:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18396c5b3:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396c5b7:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396c5be:	72 1f                	jb     0x18396c5df
   18396c5c0:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396c5c4:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396c5c8:	4c 29 c1             	sub    rcx,r8
   18396c5cb:	48 83 f9 20          	cmp    rcx,0x20
   18396c5cf:	0f 83 0a 03 00 00    	jae    0x18396c8df
   18396c5d5:	48 83 c0 28          	add    rax,0x28
   18396c5d9:	48 89 c2             	mov    rdx,rax
   18396c5dc:	4c 89 c1             	mov    rcx,r8
   18396c5df:	e8 fc f2 b3 03       	call   0x1874ab8e0
   18396c5e4:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396c5e8:	48 83 f8 10          	cmp    rax,0x10
   18396c5ec:	72 35                	jb     0x18396c623
   18396c5ee:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396c5f2:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396c5f6:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396c5fd:	72 1f                	jb     0x18396c61e
   18396c5ff:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396c603:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396c607:	4c 29 c1             	sub    rcx,r8
   18396c60a:	48 83 f9 20          	cmp    rcx,0x20
   18396c60e:	0f 83 cb 02 00 00    	jae    0x18396c8df
   18396c614:	48 83 c0 28          	add    rax,0x28
   18396c618:	48 89 c2             	mov    rdx,rax
   18396c61b:	4c 89 c1             	mov    rcx,r8
   18396c61e:	e8 bd f2 b3 03       	call   0x1874ab8e0
   18396c623:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396c62a:	00 
   18396c62b:	b9 20 00 00 00       	mov    ecx,0x20
   18396c630:	e8 67 f2 b3 03       	call   0x1874ab89c
   18396c635:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396c639:	48 c7 45 e8 17 00 00 	mov    QWORD PTR [rbp-0x18],0x17
   18396c640:	00 
   18396c641:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18396c648:	00 
   18396c649:	44 0f 11 00          	movups XMMWORD PTR [rax],xmm8
   18396c64d:	4c 89 78 0f          	mov    QWORD PTR [rax+0xf],r15
   18396c651:	c6 40 17 00          	mov    BYTE PTR [rax+0x17],0x0
   18396c655:	0f 57 c0             	xorps  xmm0,xmm0
   18396c658:	0f 29 45 b0          	movaps XMMWORD PTR [rbp-0x50],xmm0
   18396c65c:	48 c7 45 c0 02 00 00 	mov    QWORD PTR [rbp-0x40],0x2
   18396c663:	00 
   18396c664:	48 c7 45 c8 0f 00 00 	mov    QWORD PTR [rbp-0x38],0xf
   18396c66b:	00 
   18396c66c:	66 c7 45 b0 36 36    	mov    WORD PTR [rbp-0x50],0x3636
   18396c672:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396c676:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   18396c67a:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18396c67e:	48 89 f1             	mov    rcx,rsi
   18396c681:	e8 6a 4f db fc       	call   0x1807215f0
   18396c686:	90                   	nop
   18396c687:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18396c68b:	48 83 f8 10          	cmp    rax,0x10
   18396c68f:	72 35                	jb     0x18396c6c6
   18396c691:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18396c695:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396c699:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396c6a0:	72 1f                	jb     0x18396c6c1
   18396c6a2:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396c6a6:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396c6aa:	4c 29 c1             	sub    rcx,r8
   18396c6ad:	48 83 f9 20          	cmp    rcx,0x20
   18396c6b1:	0f 83 28 02 00 00    	jae    0x18396c8df
   18396c6b7:	48 83 c0 28          	add    rax,0x28
   18396c6bb:	48 89 c2             	mov    rdx,rax
   18396c6be:	4c 89 c1             	mov    rcx,r8
   18396c6c1:	e8 1a f2 b3 03       	call   0x1874ab8e0
   18396c6c6:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396c6ca:	48 83 f8 10          	cmp    rax,0x10
   18396c6ce:	72 35                	jb     0x18396c705
   18396c6d0:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396c6d4:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396c6d8:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396c6df:	72 1f                	jb     0x18396c700
   18396c6e1:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396c6e5:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396c6e9:	4c 29 c1             	sub    rcx,r8
   18396c6ec:	48 83 f9 20          	cmp    rcx,0x20
   18396c6f0:	0f 83 e9 01 00 00    	jae    0x18396c8df
   18396c6f6:	48 83 c0 28          	add    rax,0x28
   18396c6fa:	48 89 c2             	mov    rdx,rax
   18396c6fd:	4c 89 c1             	mov    rcx,r8
   18396c700:	e8 db f1 b3 03       	call   0x1874ab8e0
   18396c705:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396c70c:	00 
   18396c70d:	b9 20 00 00 00       	mov    ecx,0x20
   18396c712:	e8 85 f1 b3 03       	call   0x1874ab89c
   18396c717:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396c71b:	48 c7 45 e8 17 00 00 	mov    QWORD PTR [rbp-0x18],0x17
   18396c722:	00 
   18396c723:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18396c72a:	00 
   18396c72b:	44 0f 11 00          	movups XMMWORD PTR [rax],xmm8
   18396c72f:	4c 89 78 0f          	mov    QWORD PTR [rax+0xf],r15
   18396c733:	c6 40 17 00          	mov    BYTE PTR [rax+0x17],0x0
   18396c737:	0f 57 c0             	xorps  xmm0,xmm0
   18396c73a:	0f 29 45 b0          	movaps XMMWORD PTR [rbp-0x50],xmm0
   18396c73e:	48 c7 45 c0 02 00 00 	mov    QWORD PTR [rbp-0x40],0x2
   18396c745:	00 
   18396c746:	48 c7 45 c8 0f 00 00 	mov    QWORD PTR [rbp-0x38],0xf
   18396c74d:	00 
   18396c74e:	66 c7 45 b0 36 37    	mov    WORD PTR [rbp-0x50],0x3736
   18396c754:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396c758:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   18396c75c:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18396c760:	48 89 f1             	mov    rcx,rsi
   18396c763:	e8 88 4e db fc       	call   0x1807215f0
   18396c768:	90                   	nop
   18396c769:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18396c76d:	48 83 f8 10          	cmp    rax,0x10
   18396c771:	72 35                	jb     0x18396c7a8
   18396c773:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18396c777:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396c77b:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396c782:	72 1f                	jb     0x18396c7a3
   18396c784:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396c788:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396c78c:	4c 29 c1             	sub    rcx,r8
   18396c78f:	48 83 f9 20          	cmp    rcx,0x20
   18396c793:	0f 83 46 01 00 00    	jae    0x18396c8df
   18396c799:	48 83 c0 28          	add    rax,0x28
   18396c79d:	48 89 c2             	mov    rdx,rax
   18396c7a0:	4c 89 c1             	mov    rcx,r8
   18396c7a3:	e8 38 f1 b3 03       	call   0x1874ab8e0
   18396c7a8:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396c7ac:	48 83 f8 10          	cmp    rax,0x10
   18396c7b0:	72 35                	jb     0x18396c7e7
   18396c7b2:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396c7b6:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396c7ba:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396c7c1:	72 1f                	jb     0x18396c7e2
   18396c7c3:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396c7c7:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396c7cb:	4c 29 c1             	sub    rcx,r8
   18396c7ce:	48 83 f9 20          	cmp    rcx,0x20
   18396c7d2:	0f 83 07 01 00 00    	jae    0x18396c8df
   18396c7d8:	48 83 c0 28          	add    rax,0x28
   18396c7dc:	48 89 c2             	mov    rdx,rax
   18396c7df:	4c 89 c1             	mov    rcx,r8
   18396c7e2:	e8 f9 f0 b3 03       	call   0x1874ab8e0
   18396c7e7:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18396c7ee:	00 
   18396c7ef:	b9 20 00 00 00       	mov    ecx,0x20
   18396c7f4:	e8 a3 f0 b3 03       	call   0x1874ab89c
   18396c7f9:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18396c7fd:	48 c7 45 e8 1d 00 00 	mov    QWORD PTR [rbp-0x18],0x1d
   18396c804:	00 
   18396c805:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18396c80c:	00 
   18396c80d:	0f 11 38             	movups XMMWORD PTR [rax],xmm7
   18396c810:	0f 11 70 0d          	movups XMMWORD PTR [rax+0xd],xmm6
   18396c814:	c6 40 1d 00          	mov    BYTE PTR [rax+0x1d],0x0
   18396c818:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   18396c81c:	ba 31 00 00 00       	mov    edx,0x31
   18396c821:	41 b8 87 00 00 00    	mov    r8d,0x87
   18396c827:	e8 14 c9 ff ff       	call   0x183969140
   18396c82c:	90                   	nop
   18396c82d:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18396c831:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   18396c835:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18396c839:	48 89 f1             	mov    rcx,rsi
   18396c83c:	e8 af 4d db fc       	call   0x1807215f0
   18396c841:	90                   	nop
   18396c842:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18396c846:	48 83 f8 10          	cmp    rax,0x10
   18396c84a:	72 31                	jb     0x18396c87d
   18396c84c:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18396c850:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396c854:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396c85b:	72 1b                	jb     0x18396c878
   18396c85d:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396c861:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396c865:	4c 29 c1             	sub    rcx,r8
   18396c868:	48 83 f9 20          	cmp    rcx,0x20
   18396c86c:	73 71                	jae    0x18396c8df
   18396c86e:	48 83 c0 28          	add    rax,0x28
   18396c872:	48 89 c2             	mov    rdx,rax
   18396c875:	4c 89 c1             	mov    rcx,r8
   18396c878:	e8 63 f0 b3 03       	call   0x1874ab8e0
   18396c87d:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18396c881:	48 83 f8 10          	cmp    rax,0x10
   18396c885:	72 31                	jb     0x18396c8b8
   18396c887:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18396c88b:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18396c88f:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18396c896:	72 1b                	jb     0x18396c8b3
   18396c898:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18396c89c:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18396c8a0:	4c 29 c1             	sub    rcx,r8
   18396c8a3:	48 83 f9 20          	cmp    rcx,0x20
   18396c8a7:	73 36                	jae    0x18396c8df
   18396c8a9:	48 83 c0 28          	add    rax,0x28
   18396c8ad:	48 89 c2             	mov    rdx,rax
   18396c8b0:	4c 89 c1             	mov    rcx,r8
   18396c8b3:	e8 28 f0 b3 03       	call   0x1874ab8e0
   18396c8b8:	0f 28 75 00          	movaps xmm6,XMMWORD PTR [rbp+0x0]
   18396c8bc:	0f 28 7d 10          	movaps xmm7,XMMWORD PTR [rbp+0x10]
   18396c8c0:	44 0f 28 45 20       	movaps xmm8,XMMWORD PTR [rbp+0x20]
   18396c8c5:	44 0f 28 4d 30       	movaps xmm9,XMMWORD PTR [rbp+0x30]
   18396c8ca:	44 0f 28 55 40       	movaps xmm10,XMMWORD PTR [rbp+0x40]
   18396c8cf:	48 81 c4 d8 00 00 00 	add    rsp,0xd8
   18396c8d6:	5b                   	pop    rbx
   18396c8d7:	5f                   	pop    rdi
   18396c8d8:	5e                   	pop    rsi
   18396c8d9:	41 5e                	pop    r14
   18396c8db:	41 5f                	pop    r15
   18396c8dd:	5d                   	pop    rbp
   18396c8de:	c3                   	ret
   18396c8df:	e8 a8 0a ba 03       	call   0x18750d38c
   18396c8e4:	cc                   	int3
