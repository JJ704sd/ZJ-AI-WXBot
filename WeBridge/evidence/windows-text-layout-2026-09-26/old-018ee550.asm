
.research\wechat-4.1.10.27-reference\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

00000001818ee550 <.text+0x18ed550>:
   1818ee550:	55                   	push   rbp
   1818ee551:	56                   	push   rsi
   1818ee552:	57                   	push   rdi
   1818ee553:	53                   	push   rbx
   1818ee554:	48 83 ec 38          	sub    rsp,0x38
   1818ee558:	48 8d 6c 24 30       	lea    rbp,[rsp+0x30]
   1818ee55d:	48 c7 45 00 fe ff ff 	mov    QWORD PTR [rbp+0x0],0xfffffffffffffffe
   1818ee564:	ff 
   1818ee565:	4c 89 c6             	mov    rsi,r8
   1818ee568:	48 89 d7             	mov    rdi,rdx
   1818ee56b:	48 89 cb             	mov    rbx,rcx
   1818ee56e:	48 8d 15 4b ed c3 06 	lea    rdx,[rip+0x6c3ed4b]        # 0x18852d2c0
   1818ee575:	41 b8 48 07 00 00    	mov    r8d,0x748
   1818ee57b:	e8 50 7b fa 04       	call   0x1868960d0
   1818ee580:	48 89 d9             	mov    rcx,rbx
   1818ee583:	e8 a8 46 dc fe       	call   0x1806b2c30
   1818ee588:	8b 05 d2 9f f6 08    	mov    eax,DWORD PTR [rip+0x8f69fd2]        # 0x18a858560
   1818ee58e:	8b 0d 5c dd f4 08    	mov    ecx,DWORD PTR [rip+0x8f4dd5c]        # 0x18a83c2f0
   1818ee594:	65 48 8b 14 25 58 00 	mov    rdx,QWORD PTR gs:0x58
   1818ee59b:	00 00 
   1818ee59d:	48 8b 0c ca          	mov    rcx,QWORD PTR [rdx+rcx*8]
   1818ee5a1:	3b 81 c4 00 00 00    	cmp    eax,DWORD PTR [rcx+0xc4]
   1818ee5a7:	48 89 5d f8          	mov    QWORD PTR [rbp-0x8],rbx
   1818ee5ab:	7f 23                	jg     0x1818ee5d0
   1818ee5ad:	48 8b 15 a4 9f f6 08 	mov    rdx,QWORD PTR [rip+0x8f69fa4]        # 0x18a858558
   1818ee5b4:	48 89 d9             	mov    rcx,rbx
   1818ee5b7:	49 89 f8             	mov    r8,rdi
   1818ee5ba:	49 89 f1             	mov    r9,rsi
   1818ee5bd:	e8 0e fa bf ff       	call   0x1814edfd0
   1818ee5c2:	90                   	nop
   1818ee5c3:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
   1818ee5c7:	48 83 c4 38          	add    rsp,0x38
   1818ee5cb:	5b                   	pop    rbx
   1818ee5cc:	5f                   	pop    rdi
   1818ee5cd:	5e                   	pop    rsi
   1818ee5ce:	5d                   	pop    rbp
   1818ee5cf:	c3                   	ret
   1818ee5d0:	48 8d 0d 89 9f f6 08 	lea    rcx,[rip+0x8f69f89]        # 0x18a858560
   1818ee5d7:	e8 b4 eb f1 04       	call   0x18680d190
   1818ee5dc:	83 3d 7d 9f f6 08 ff 	cmp    DWORD PTR [rip+0x8f69f7d],0xffffffff        # 0x18a858560
   1818ee5e3:	75 c8                	jne    0x1818ee5ad
   1818ee5e5:	e8 86 00 00 00       	call   0x1818ee670
   1818ee5ea:	90                   	nop
   1818ee5eb:	48 89 05 66 9f f6 08 	mov    QWORD PTR [rip+0x8f69f66],rax        # 0x18a858558
   1818ee5f2:	48 8d 0d 67 9f f6 08 	lea    rcx,[rip+0x8f69f67]        # 0x18a858560
   1818ee5f9:	e8 46 ec f1 04       	call   0x18680d244
   1818ee5fe:	48 8b 5d f8          	mov    rbx,QWORD PTR [rbp-0x8]
   1818ee602:	eb a9                	jmp    0x1818ee5ad
