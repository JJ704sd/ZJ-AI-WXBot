
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000182e830f0 <.text+0x2e820f0>:
   182e830f0:	55                   	push   rbp
   182e830f1:	41 57                	push   r15
   182e830f3:	41 56                	push   r14
   182e830f5:	41 55                	push   r13
   182e830f7:	41 54                	push   r12
   182e830f9:	56                   	push   rsi
   182e830fa:	57                   	push   rdi
   182e830fb:	53                   	push   rbx
   182e830fc:	48 83 ec 58          	sub    rsp,0x58
   182e83100:	48 8d 6c 24 50       	lea    rbp,[rsp+0x50]
   182e83105:	0f 29 75 f0          	movaps XMMWORD PTR [rbp-0x10],xmm6
   182e83109:	48 c7 45 e8 fe ff ff 	mov    QWORD PTR [rbp-0x18],0xfffffffffffffffe
   182e83110:	ff 
   182e83111:	48 89 d6             	mov    rsi,rdx
   182e83114:	48 89 cf             	mov    rdi,rcx
   182e83117:	48 8d 59 18          	lea    rbx,[rcx+0x18]
   182e8311b:	4c 8d 61 1c          	lea    r12,[rcx+0x1c]
   182e8311f:	4c 8d 79 28          	lea    r15,[rcx+0x28]
   182e83123:	4c 8d 35 f2 23 55 06 	lea    r14,[rip+0x65523f2]        # 0x1893d551c
   182e8312a:	0f 57 f6             	xorps  xmm6,xmm6
   182e8312d:	0f 1f 00             	nop    DWORD PTR [rax]
   182e83130:	48 8b 4e 08          	mov    rcx,QWORD PTR [rsi+0x8]
   182e83134:	48 3b 4e 10          	cmp    rcx,QWORD PTR [rsi+0x10]
   182e83138:	73 26                	jae    0x182e83160
   182e8313a:	0f be 01             	movsx  eax,BYTE PTR [rcx]
   182e8313d:	85 c0                	test   eax,eax
   182e8313f:	78 1f                	js     0x182e83160
   182e83141:	89 46 20             	mov    DWORD PTR [rsi+0x20],eax
   182e83144:	48 ff c1             	inc    rcx
   182e83147:	48 89 4e 08          	mov    QWORD PTR [rsi+0x8],rcx
   182e8314b:	41 b5 01             	mov    r13b,0x1
   182e8314e:	85 c0                	test   eax,eax
   182e83150:	75 24                	jne    0x182e83176
   182e83152:	e9 e7 03 00 00       	jmp    0x182e8353e
   182e83157:	66 0f 1f 84 00 00 00 	nop    WORD PTR [rax+rax*1+0x0]
   182e8315e:	00 00 
   182e83160:	48 89 f1             	mov    rcx,rsi
   182e83163:	e8 18 02 77 fe       	call   0x1815f3380
   182e83168:	89 46 20             	mov    DWORD PTR [rsi+0x20],eax
   182e8316b:	41 b5 01             	mov    r13b,0x1
   182e8316e:	85 c0                	test   eax,eax
   182e83170:	0f 84 c8 03 00 00    	je     0x182e8353e
   182e83176:	89 c2                	mov    edx,eax
   182e83178:	c1 ea 03             	shr    edx,0x3
   182e8317b:	89 c1                	mov    ecx,eax
   182e8317d:	83 e1 07             	and    ecx,0x7
   182e83180:	ff ca                	dec    edx
   182e83182:	83 fa 06             	cmp    edx,0x6
   182e83185:	0f 87 65 01 00 00    	ja     0x182e832f0
   182e8318b:	49 63 14 96          	movsxd rdx,DWORD PTR [r14+rdx*4]
   182e8318f:	4c 01 f2             	add    rdx,r14
   182e83192:	ff e2                	jmp    rdx
   182e83194:	83 f9 02             	cmp    ecx,0x2
   182e83197:	0f 85 53 01 00 00    	jne    0x182e832f0
   182e8319d:	80 4f 34 01          	or     BYTE PTR [rdi+0x34],0x1
   182e831a1:	4c 8b 7f 08          	mov    r15,QWORD PTR [rdi+0x8]
   182e831a5:	4d 85 ff             	test   r15,r15
   182e831a8:	75 20                	jne    0x182e831ca
   182e831aa:	b9 18 00 00 00       	mov    ecx,0x18
   182e831af:	e8 e8 86 62 04       	call   0x1874ab89c
   182e831b4:	90                   	nop
   182e831b5:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   182e831b9:	48 89 c1             	mov    rcx,rax
   182e831bc:	e8 ef 5e 7f fd       	call   0x1806790b0
   182e831c1:	90                   	nop
   182e831c2:	4c 8b 7d d8          	mov    r15,QWORD PTR [rbp-0x28]
   182e831c6:	4c 89 7f 08          	mov    QWORD PTR [rdi+0x8],r15
   182e831ca:	49 89 dc             	mov    r12,rbx
   182e831cd:	c7 45 e4 aa aa aa aa 	mov    DWORD PTR [rbp-0x1c],0xaaaaaaaa
   182e831d4:	48 8b 46 08          	mov    rax,QWORD PTR [rsi+0x8]
   182e831d8:	48 3b 46 10          	cmp    rax,QWORD PTR [rsi+0x10]
   182e831dc:	0f 83 d6 02 00 00    	jae    0x182e834b8
   182e831e2:	0f be 08             	movsx  ecx,BYTE PTR [rax]
   182e831e5:	85 c9                	test   ecx,ecx
   182e831e7:	0f 88 cb 02 00 00    	js     0x182e834b8
   182e831ed:	89 4d e4             	mov    DWORD PTR [rbp-0x1c],ecx
   182e831f0:	48 ff c0             	inc    rax
   182e831f3:	48 89 46 08          	mov    QWORD PTR [rsi+0x8],rax
   182e831f7:	e9 cc 02 00 00       	jmp    0x182e834c8
   182e831fc:	85 c9                	test   ecx,ecx
   182e831fe:	0f 85 ec 00 00 00    	jne    0x182e832f0
   182e83204:	48 8b 46 08          	mov    rax,QWORD PTR [rsi+0x8]
   182e83208:	48 8b 4e 10          	mov    rcx,QWORD PTR [rsi+0x10]
   182e8320c:	48 39 c8             	cmp    rax,rcx
   182e8320f:	0f 82 9c 01 00 00    	jb     0x182e833b1
   182e83215:	e9 a7 01 00 00       	jmp    0x182e833c1
   182e8321a:	85 c9                	test   ecx,ecx
   182e8321c:	0f 85 ce 00 00 00    	jne    0x182e832f0
   182e83222:	48 8b 46 08          	mov    rax,QWORD PTR [rsi+0x8]
   182e83226:	48 8b 4e 10          	mov    rcx,QWORD PTR [rsi+0x10]
   182e8322a:	48 39 c8             	cmp    rax,rcx
   182e8322d:	0f 82 9a 00 00 00    	jb     0x182e832cd
   182e83233:	e9 ee 00 00 00       	jmp    0x182e83326
   182e83238:	85 c9                	test   ecx,ecx
   182e8323a:	0f 85 b0 00 00 00    	jne    0x182e832f0
   182e83240:	48 8b 46 08          	mov    rax,QWORD PTR [rsi+0x8]
   182e83244:	48 8b 4e 10          	mov    rcx,QWORD PTR [rsi+0x10]
   182e83248:	48 39 c8             	cmp    rax,rcx
   182e8324b:	0f 82 12 01 00 00    	jb     0x182e83363
   182e83251:	e9 1e 01 00 00       	jmp    0x182e83374
   182e83256:	83 f9 02             	cmp    ecx,0x2
   182e83259:	0f 85 91 00 00 00    	jne    0x182e832f0
   182e8325f:	80 4f 34 02          	or     BYTE PTR [rdi+0x34],0x2
   182e83263:	48 8b 57 10          	mov    rdx,QWORD PTR [rdi+0x10]
   182e83267:	48 8d 05 72 3b a9 08 	lea    rax,[rip+0x8a93b72]        # 0x18b916de0
   182e8326e:	48 39 c2             	cmp    rdx,rax
   182e83271:	75 24                	jne    0x182e83297
   182e83273:	b9 20 00 00 00       	mov    ecx,0x20
   182e83278:	e8 1f 86 62 04       	call   0x1874ab89c
   182e8327d:	48 89 c2             	mov    rdx,rax
   182e83280:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   182e83283:	48 c7 40 10 00 00 00 	mov    QWORD PTR [rax+0x10],0x0
   182e8328a:	00 
   182e8328b:	48 c7 40 18 0f 00 00 	mov    QWORD PTR [rax+0x18],0xf
   182e83292:	00 
   182e83293:	48 89 47 10          	mov    QWORD PTR [rdi+0x10],rax
   182e83297:	48 89 f1             	mov    rcx,rsi
   182e8329a:	e8 f1 14 77 fe       	call   0x1815f4790
   182e8329f:	84 c0                	test   al,al
   182e832a1:	0f 84 94 02 00 00    	je     0x182e8353b
   182e832a7:	48 8b 46 08          	mov    rax,QWORD PTR [rsi+0x8]
   182e832ab:	48 8b 4e 10          	mov    rcx,QWORD PTR [rsi+0x10]
   182e832af:	48 39 c8             	cmp    rax,rcx
   182e832b2:	0f 83 78 fe ff ff    	jae    0x182e83130
   182e832b8:	80 38 18             	cmp    BYTE PTR [rax],0x18
   182e832bb:	0f 85 6f fe ff ff    	jne    0x182e83130
   182e832c1:	48 ff c0             	inc    rax
   182e832c4:	48 89 46 08          	mov    QWORD PTR [rsi+0x8],rax
   182e832c8:	48 39 c8             	cmp    rax,rcx
   182e832cb:	73 59                	jae    0x182e83326
   182e832cd:	0f be 00             	movsx  eax,BYTE PTR [rax]
   182e832d0:	85 c0                	test   eax,eax
   182e832d2:	78 52                	js     0x182e83326
   182e832d4:	89 03                	mov    DWORD PTR [rbx],eax
   182e832d6:	48 ff 46 08          	inc    QWORD PTR [rsi+0x8]
   182e832da:	eb 5d                	jmp    0x182e83339
   182e832dc:	83 f9 02             	cmp    ecx,0x2
   182e832df:	75 0f                	jne    0x182e832f0
   182e832e1:	e9 10 01 00 00       	jmp    0x182e833f6
   182e832e6:	85 c9                	test   ecx,ecx
   182e832e8:	74 26                	je     0x182e83310
   182e832ea:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
   182e832f0:	83 f9 04             	cmp    ecx,0x4
   182e832f3:	0f 84 45 02 00 00    	je     0x182e8353e
   182e832f9:	48 89 f1             	mov    rcx,rsi
   182e832fc:	89 c2                	mov    edx,eax
   182e832fe:	e8 8d 0d 77 fe       	call   0x1815f4090
   182e83303:	84 c0                	test   al,al
   182e83305:	0f 85 25 fe ff ff    	jne    0x182e83130
   182e8330b:	e9 2b 02 00 00       	jmp    0x182e8353b
   182e83310:	48 8b 46 08          	mov    rax,QWORD PTR [rsi+0x8]
   182e83314:	48 8b 4e 10          	mov    rcx,QWORD PTR [rsi+0x10]
   182e83318:	48 39 c8             	cmp    rax,rcx
   182e8331b:	0f 82 43 01 00 00    	jb     0x182e83464
   182e83321:	e9 51 01 00 00       	jmp    0x182e83477
   182e83326:	48 89 f1             	mov    rcx,rsi
   182e83329:	48 89 da             	mov    rdx,rbx
   182e8332c:	e8 ef fe 76 fe       	call   0x1815f3220
   182e83331:	84 c0                	test   al,al
   182e83333:	0f 84 02 02 00 00    	je     0x182e8353b
   182e83339:	80 4f 34 04          	or     BYTE PTR [rdi+0x34],0x4
   182e8333d:	48 8b 46 08          	mov    rax,QWORD PTR [rsi+0x8]
   182e83341:	48 8b 4e 10          	mov    rcx,QWORD PTR [rsi+0x10]
   182e83345:	48 39 c8             	cmp    rax,rcx
   182e83348:	0f 83 e2 fd ff ff    	jae    0x182e83130
   182e8334e:	80 38 20             	cmp    BYTE PTR [rax],0x20
   182e83351:	0f 85 d9 fd ff ff    	jne    0x182e83130
   182e83357:	48 ff c0             	inc    rax
   182e8335a:	48 89 46 08          	mov    QWORD PTR [rsi+0x8],rax
   182e8335e:	48 39 c8             	cmp    rax,rcx
   182e83361:	73 11                	jae    0x182e83374
   182e83363:	0f be 00             	movsx  eax,BYTE PTR [rax]
   182e83366:	85 c0                	test   eax,eax
   182e83368:	78 0a                	js     0x182e83374
   182e8336a:	41 89 04 24          	mov    DWORD PTR [r12],eax
   182e8336e:	48 ff 46 08          	inc    QWORD PTR [rsi+0x8]
   182e83372:	eb 13                	jmp    0x182e83387
   182e83374:	48 89 f1             	mov    rcx,rsi
   182e83377:	4c 89 e2             	mov    rdx,r12
   182e8337a:	e8 a1 fe 76 fe       	call   0x1815f3220
   182e8337f:	84 c0                	test   al,al
   182e83381:	0f 84 b4 01 00 00    	je     0x182e8353b
   182e83387:	80 4f 34 08          	or     BYTE PTR [rdi+0x34],0x8
   182e8338b:	48 8b 46 08          	mov    rax,QWORD PTR [rsi+0x8]
   182e8338f:	48 8b 4e 10          	mov    rcx,QWORD PTR [rsi+0x10]
   182e83393:	48 39 c8             	cmp    rax,rcx
   182e83396:	0f 83 94 fd ff ff    	jae    0x182e83130
   182e8339c:	80 38 28             	cmp    BYTE PTR [rax],0x28
   182e8339f:	0f 85 8b fd ff ff    	jne    0x182e83130
   182e833a5:	48 ff c0             	inc    rax
   182e833a8:	48 89 46 08          	mov    QWORD PTR [rsi+0x8],rax
   182e833ac:	48 39 c8             	cmp    rax,rcx
   182e833af:	73 10                	jae    0x182e833c1
   182e833b1:	0f be 00             	movsx  eax,BYTE PTR [rax]
   182e833b4:	85 c0                	test   eax,eax
   182e833b6:	78 09                	js     0x182e833c1
   182e833b8:	41 89 07             	mov    DWORD PTR [r15],eax
   182e833bb:	48 ff 46 08          	inc    QWORD PTR [rsi+0x8]
   182e833bf:	eb 13                	jmp    0x182e833d4
   182e833c1:	48 89 f1             	mov    rcx,rsi
   182e833c4:	4c 89 fa             	mov    rdx,r15
   182e833c7:	e8 54 fe 76 fe       	call   0x1815f3220
   182e833cc:	84 c0                	test   al,al
   182e833ce:	0f 84 67 01 00 00    	je     0x182e8353b
   182e833d4:	80 4f 34 10          	or     BYTE PTR [rdi+0x34],0x10
   182e833d8:	48 8b 46 08          	mov    rax,QWORD PTR [rsi+0x8]
   182e833dc:	48 3b 46 10          	cmp    rax,QWORD PTR [rsi+0x10]
   182e833e0:	0f 83 4a fd ff ff    	jae    0x182e83130
   182e833e6:	80 38 32             	cmp    BYTE PTR [rax],0x32
   182e833e9:	0f 85 41 fd ff ff    	jne    0x182e83130
   182e833ef:	48 ff c0             	inc    rax
   182e833f2:	48 89 46 08          	mov    QWORD PTR [rsi+0x8],rax
   182e833f6:	80 4f 34 20          	or     BYTE PTR [rdi+0x34],0x20
   182e833fa:	48 8b 57 20          	mov    rdx,QWORD PTR [rdi+0x20]
   182e833fe:	48 8d 05 db 39 a9 08 	lea    rax,[rip+0x8a939db]        # 0x18b916de0
   182e83405:	48 39 c2             	cmp    rdx,rax
   182e83408:	75 24                	jne    0x182e8342e
   182e8340a:	b9 20 00 00 00       	mov    ecx,0x20
   182e8340f:	e8 88 84 62 04       	call   0x1874ab89c
   182e83414:	48 89 c2             	mov    rdx,rax
   182e83417:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   182e8341a:	48 c7 40 10 00 00 00 	mov    QWORD PTR [rax+0x10],0x0
   182e83421:	00 
   182e83422:	48 c7 40 18 0f 00 00 	mov    QWORD PTR [rax+0x18],0xf
   182e83429:	00 
   182e8342a:	48 89 47 20          	mov    QWORD PTR [rdi+0x20],rax
   182e8342e:	48 89 f1             	mov    rcx,rsi
   182e83431:	e8 5a 13 77 fe       	call   0x1815f4790
   182e83436:	84 c0                	test   al,al
   182e83438:	0f 84 fd 00 00 00    	je     0x182e8353b
   182e8343e:	48 8b 46 08          	mov    rax,QWORD PTR [rsi+0x8]
   182e83442:	48 8b 4e 10          	mov    rcx,QWORD PTR [rsi+0x10]
   182e83446:	48 39 c8             	cmp    rax,rcx
   182e83449:	0f 83 e1 fc ff ff    	jae    0x182e83130
   182e8344f:	80 38 38             	cmp    BYTE PTR [rax],0x38
   182e83452:	0f 85 d8 fc ff ff    	jne    0x182e83130
   182e83458:	48 ff c0             	inc    rax
   182e8345b:	48 89 46 08          	mov    QWORD PTR [rsi+0x8],rax
   182e8345f:	48 39 c8             	cmp    rax,rcx
   182e83462:	73 13                	jae    0x182e83477
   182e83464:	0f be 00             	movsx  eax,BYTE PTR [rax]
   182e83467:	85 c0                	test   eax,eax
   182e83469:	78 0c                	js     0x182e83477
   182e8346b:	48 8d 4f 2c          	lea    rcx,[rdi+0x2c]
   182e8346f:	89 01                	mov    DWORD PTR [rcx],eax
   182e83471:	48 ff 46 08          	inc    QWORD PTR [rsi+0x8]
   182e83475:	eb 14                	jmp    0x182e8348b
   182e83477:	48 89 f1             	mov    rcx,rsi
   182e8347a:	48 8d 57 2c          	lea    rdx,[rdi+0x2c]
   182e8347e:	e8 9d fd 76 fe       	call   0x1815f3220
   182e83483:	84 c0                	test   al,al
   182e83485:	0f 84 b0 00 00 00    	je     0x182e8353b
   182e8348b:	80 4f 34 40          	or     BYTE PTR [rdi+0x34],0x40
   182e8348f:	48 8b 46 08          	mov    rax,QWORD PTR [rsi+0x8]
   182e83493:	48 3b 46 10          	cmp    rax,QWORD PTR [rsi+0x10]
   182e83497:	0f 85 93 fc ff ff    	jne    0x182e83130
   182e8349d:	83 7e 2c 00          	cmp    DWORD PTR [rsi+0x2c],0x0
   182e834a1:	0f 85 af 00 00 00    	jne    0x182e83556
   182e834a7:	8b 46 18             	mov    eax,DWORD PTR [rsi+0x18]
   182e834aa:	3b 46 28             	cmp    eax,DWORD PTR [rsi+0x28]
   182e834ad:	0f 85 7d fc ff ff    	jne    0x182e83130
   182e834b3:	e9 9e 00 00 00       	jmp    0x182e83556
   182e834b8:	48 89 f1             	mov    rcx,rsi
   182e834bb:	48 8d 55 e4          	lea    rdx,[rbp-0x1c]
   182e834bf:	e8 5c fd 76 fe       	call   0x1815f3220
   182e834c4:	84 c0                	test   al,al
   182e834c6:	74 73                	je     0x182e8353b
   182e834c8:	8b 46 38             	mov    eax,DWORD PTR [rsi+0x38]
   182e834cb:	ff c0                	inc    eax
   182e834cd:	89 46 38             	mov    DWORD PTR [rsi+0x38],eax
   182e834d0:	3b 46 3c             	cmp    eax,DWORD PTR [rsi+0x3c]
   182e834d3:	7f 66                	jg     0x182e8353b
   182e834d5:	8b 55 e4             	mov    edx,DWORD PTR [rbp-0x1c]
   182e834d8:	48 89 f1             	mov    rcx,rsi
   182e834db:	e8 10 f4 76 fe       	call   0x1815f28f0
   182e834e0:	89 c3                	mov    ebx,eax
   182e834e2:	4c 89 f9             	mov    rcx,r15
   182e834e5:	48 89 f2             	mov    rdx,rsi
   182e834e8:	e8 c3 53 7f fd       	call   0x1806788b0
   182e834ed:	84 c0                	test   al,al
   182e834ef:	74 4a                	je     0x182e8353b
   182e834f1:	80 7e 24 01          	cmp    BYTE PTR [rsi+0x24],0x1
   182e834f5:	75 44                	jne    0x182e8353b
   182e834f7:	48 89 f1             	mov    rcx,rsi
   182e834fa:	89 da                	mov    edx,ebx
   182e834fc:	e8 5f f4 76 fe       	call   0x1815f2960
   182e83501:	8b 46 38             	mov    eax,DWORD PTR [rsi+0x38]
   182e83504:	85 c0                	test   eax,eax
   182e83506:	7e 05                	jle    0x182e8350d
   182e83508:	ff c8                	dec    eax
   182e8350a:	89 46 38             	mov    DWORD PTR [rsi+0x38],eax
   182e8350d:	48 8b 46 08          	mov    rax,QWORD PTR [rsi+0x8]
   182e83511:	48 3b 46 10          	cmp    rax,QWORD PTR [rsi+0x10]
   182e83515:	4c 89 e3             	mov    rbx,r12
   182e83518:	4c 8d 67 1c          	lea    r12,[rdi+0x1c]
   182e8351c:	4c 8d 7f 28          	lea    r15,[rdi+0x28]
   182e83520:	0f 83 0a fc ff ff    	jae    0x182e83130
   182e83526:	80 38 12             	cmp    BYTE PTR [rax],0x12
   182e83529:	0f 85 01 fc ff ff    	jne    0x182e83130
   182e8352f:	48 ff c0             	inc    rax
   182e83532:	48 89 46 08          	mov    QWORD PTR [rsi+0x8],rax
   182e83536:	e9 24 fd ff ff       	jmp    0x182e8325f
   182e8353b:	45 31 ed             	xor    r13d,r13d
   182e8353e:	44 89 e8             	mov    eax,r13d
   182e83541:	0f 28 75 f0          	movaps xmm6,XMMWORD PTR [rbp-0x10]
   182e83545:	48 83 c4 58          	add    rsp,0x58
   182e83549:	5b                   	pop    rbx
   182e8354a:	5f                   	pop    rdi
   182e8354b:	5e                   	pop    rsi
   182e8354c:	41 5c                	pop    r12
   182e8354e:	41 5d                	pop    r13
   182e83550:	41 5e                	pop    r14
   182e83552:	41 5f                	pop    r15
   182e83554:	5d                   	pop    rbp
   182e83555:	c3                   	ret
   182e83556:	c7 46 20 00 00 00 00 	mov    DWORD PTR [rsi+0x20],0x0
   182e8355d:	c6 46 24 01          	mov    BYTE PTR [rsi+0x24],0x1
   182e83561:	eb db                	jmp    0x182e8353e
