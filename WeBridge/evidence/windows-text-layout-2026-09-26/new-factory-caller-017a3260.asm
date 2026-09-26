
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

00000001817a3260 <.text+0x17a2260>:
   1817a3260:	55                   	push   rbp
   1817a3261:	41 57                	push   r15
   1817a3263:	41 56                	push   r14
   1817a3265:	56                   	push   rsi
   1817a3266:	57                   	push   rdi
   1817a3267:	53                   	push   rbx
   1817a3268:	48 81 ec 38 0a 00 00 	sub    rsp,0xa38
   1817a326f:	48 8d ac 24 80 00 00 	lea    rbp,[rsp+0x80]
   1817a3276:	00 
   1817a3277:	0f 29 b5 a0 09 00 00 	movaps XMMWORD PTR [rbp+0x9a0],xmm6
   1817a327e:	48 c7 85 98 09 00 00 	mov    QWORD PTR [rbp+0x998],0xfffffffffffffffe
   1817a3285:	fe ff ff ff 
   1817a3289:	48 89 d7             	mov    rdi,rdx
   1817a328c:	48 89 ce             	mov    rsi,rcx
   1817a328f:	49 be aa aa aa aa aa 	movabs r14,0xaaaaaaaaaaaaaaaa
   1817a3296:	aa aa aa 
   1817a3299:	4c 89 b5 b0 08 00 00 	mov    QWORD PTR [rbp+0x8b0],r14
   1817a32a0:	0f 28 35 09 29 5a 07 	movaps xmm6,XMMWORD PTR [rip+0x75a2909]        # 0x188d45bb0
   1817a32a7:	0f 29 b5 a0 08 00 00 	movaps XMMWORD PTR [rbp+0x8a0],xmm6
   1817a32ae:	0f 29 b5 90 08 00 00 	movaps XMMWORD PTR [rbp+0x890],xmm6
   1817a32b5:	0f 29 b5 80 08 00 00 	movaps XMMWORD PTR [rbp+0x880],xmm6
   1817a32bc:	0f 57 c0             	xorps  xmm0,xmm0
   1817a32bf:	0f 29 85 60 09 00 00 	movaps XMMWORD PTR [rbp+0x960],xmm0
   1817a32c6:	48 8b 42 08          	mov    rax,QWORD PTR [rdx+0x8]
   1817a32ca:	48 85 c0             	test   rax,rax
   1817a32cd:	74 39                	je     0x1817a3308
   1817a32cf:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   1817a32d3:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1817a32d6:	48 8b 4f 08          	mov    rcx,QWORD PTR [rdi+0x8]
   1817a32da:	48 89 85 60 09 00 00 	mov    QWORD PTR [rbp+0x960],rax
   1817a32e1:	48 89 8d 68 09 00 00 	mov    QWORD PTR [rbp+0x968],rcx
   1817a32e8:	0f 29 85 a0 02 00 00 	movaps XMMWORD PTR [rbp+0x2a0],xmm0
   1817a32ef:	48 85 c9             	test   rcx,rcx
   1817a32f2:	74 29                	je     0x1817a331d
   1817a32f4:	f0 ff 41 08          	lock inc DWORD PTR [rcx+0x8]
   1817a32f8:	48 8b 85 60 09 00 00 	mov    rax,QWORD PTR [rbp+0x960]
   1817a32ff:	48 8b 8d 68 09 00 00 	mov    rcx,QWORD PTR [rbp+0x968]
   1817a3306:	eb 17                	jmp    0x1817a331f
   1817a3308:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1817a330b:	48 89 85 60 09 00 00 	mov    QWORD PTR [rbp+0x960],rax
   1817a3312:	48 c7 85 68 09 00 00 	mov    QWORD PTR [rbp+0x968],0x0
   1817a3319:	00 00 00 00 
   1817a331d:	31 c9                	xor    ecx,ecx
   1817a331f:	48 89 85 a0 02 00 00 	mov    QWORD PTR [rbp+0x2a0],rax
   1817a3326:	48 89 8d a8 02 00 00 	mov    QWORD PTR [rbp+0x2a8],rcx
   1817a332d:	48 8d 95 80 08 00 00 	lea    rdx,[rbp+0x880]
   1817a3334:	4c 8d 85 a0 02 00 00 	lea    r8,[rbp+0x2a0]
   1817a333b:	48 89 f1             	mov    rcx,rsi
   1817a333e:	45 31 c9             	xor    r9d,r9d
   1817a3341:	e8 ba bd fe ff       	call   0x18178f100
   1817a3346:	90                   	nop
   1817a3347:	48 8b 9d 68 09 00 00 	mov    rbx,QWORD PTR [rbp+0x968]
   1817a334e:	48 85 db             	test   rbx,rbx
   1817a3351:	74 1d                	je     0x1817a3370
   1817a3353:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   1817a3357:	75 17                	jne    0x1817a3370
   1817a3359:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1817a335c:	48 89 d9             	mov    rcx,rbx
   1817a335f:	ff 10                	call   QWORD PTR [rax]
   1817a3361:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   1817a3365:	75 09                	jne    0x1817a3370
   1817a3367:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1817a336a:	48 89 d9             	mov    rcx,rbx
   1817a336d:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1817a3370:	4c 89 b5 50 09 00 00 	mov    QWORD PTR [rbp+0x950],r14
   1817a3377:	0f 29 b5 40 09 00 00 	movaps XMMWORD PTR [rbp+0x940],xmm6
   1817a337e:	0f 29 b5 30 09 00 00 	movaps XMMWORD PTR [rbp+0x930],xmm6
   1817a3385:	0f 29 b5 20 09 00 00 	movaps XMMWORD PTR [rbp+0x920],xmm6
   1817a338c:	0f 29 b5 10 09 00 00 	movaps XMMWORD PTR [rbp+0x910],xmm6
   1817a3393:	0f 29 b5 00 09 00 00 	movaps XMMWORD PTR [rbp+0x900],xmm6
   1817a339a:	48 8b 95 a8 08 00 00 	mov    rdx,QWORD PTR [rbp+0x8a8]
   1817a33a1:	c6 85 50 09 00 00 00 	mov    BYTE PTR [rbp+0x950],0x0
   1817a33a8:	80 7a 50 01          	cmp    BYTE PTR [rdx+0x50],0x1
   1817a33ac:	0f 85 ea 00 00 00    	jne    0x1817a349c
   1817a33b2:	48 8d 8d 00 09 00 00 	lea    rcx,[rbp+0x900]
   1817a33b9:	e8 22 5f fc fe       	call   0x1807692e0
   1817a33be:	90                   	nop
   1817a33bf:	c6 85 50 09 00 00 01 	mov    BYTE PTR [rbp+0x950],0x1
   1817a33c6:	48 8d 15 9b 98 72 07 	lea    rdx,[rip+0x772989b]        # 0x188eccc68
   1817a33cd:	48 8d 9d a0 02 00 00 	lea    rbx,[rbp+0x2a0]
   1817a33d4:	41 b8 f0 02 00 00    	mov    r8d,0x2f0
   1817a33da:	48 89 d9             	mov    rcx,rbx
   1817a33dd:	e8 6e 0c da 05       	call   0x187544050
   1817a33e2:	8b 85 20 09 00 00    	mov    eax,DWORD PTR [rbp+0x920]
   1817a33e8:	44 8b 8d 24 09 00 00 	mov    r9d,DWORD PTR [rbp+0x924]
   1817a33ef:	89 44 24 20          	mov    DWORD PTR [rsp+0x20],eax
   1817a33f3:	4c 8d 85 00 09 00 00 	lea    r8,[rbp+0x900]
   1817a33fa:	48 89 f1             	mov    rcx,rsi
   1817a33fd:	48 89 da             	mov    rdx,rbx
   1817a3400:	e8 6b 1c 00 00       	call   0x1817a5070
   1817a3405:	90                   	nop
   1817a3406:	80 bd 88 05 00 00 01 	cmp    BYTE PTR [rbp+0x588],0x1
   1817a340d:	0f 85 89 00 00 00    	jne    0x1817a349c
   1817a3413:	48 8d 15 e6 4c 72 07 	lea    rdx,[rip+0x7724ce6]        # 0x188ec8100
   1817a341a:	48 8d 9d 90 05 00 00 	lea    rbx,[rbp+0x590]
   1817a3421:	41 b8 e8 02 00 00    	mov    r8d,0x2e8
   1817a3427:	48 89 d9             	mov    rcx,rbx
   1817a342a:	e8 21 0c da 05       	call   0x187544050
   1817a342f:	90                   	nop
   1817a3430:	48 8d 95 a0 02 00 00 	lea    rdx,[rbp+0x2a0]
   1817a3437:	48 89 d9             	mov    rcx,rbx
   1817a343a:	e8 a1 0e a2 fe       	call   0x1801c42e0
   1817a343f:	90                   	nop
   1817a3440:	c7 85 f8 06 00 00 05 	mov    DWORD PTR [rbp+0x6f8],0x5
   1817a3447:	00 00 00 
   1817a344a:	c6 44 24 20 01       	mov    BYTE PTR [rsp+0x20],0x1
   1817a344f:	48 8d 55 b0          	lea    rdx,[rbp-0x50]
   1817a3453:	4c 8d 85 90 05 00 00 	lea    r8,[rbp+0x590]
   1817a345a:	48 89 f1             	mov    rcx,rsi
   1817a345d:	41 b9 04 00 00 00    	mov    r9d,0x4
   1817a3463:	e8 f8 23 00 00       	call   0x1817a5860
   1817a3468:	90                   	nop
   1817a3469:	80 bd 98 02 00 00 01 	cmp    BYTE PTR [rbp+0x298],0x1
   1817a3470:	75 09                	jne    0x1817a347b
   1817a3472:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   1817a3476:	e8 75 1c a2 fe       	call   0x1801c50f0
   1817a347b:	48 8d 8d 90 05 00 00 	lea    rcx,[rbp+0x590]
   1817a3482:	e8 69 1c a2 fe       	call   0x1801c50f0
   1817a3487:	80 bd 88 05 00 00 01 	cmp    BYTE PTR [rbp+0x588],0x1
   1817a348e:	75 0c                	jne    0x1817a349c
   1817a3490:	48 8d 8d a0 02 00 00 	lea    rcx,[rbp+0x2a0]
   1817a3497:	e8 54 1c a2 fe       	call   0x1801c50f0
   1817a349c:	0f 29 b5 80 09 00 00 	movaps XMMWORD PTR [rbp+0x980],xmm6
   1817a34a3:	48 8d 8d 80 09 00 00 	lea    rcx,[rbp+0x980]
   1817a34aa:	e8 c1 17 f5 fe       	call   0x1806f4c70
   1817a34af:	90                   	nop
   1817a34b0:	4c 8b 0f             	mov    r9,QWORD PTR [rdi]
   1817a34b3:	48 8b 85 80 09 00 00 	mov    rax,QWORD PTR [rbp+0x980]
   1817a34ba:	4c 39 c8             	cmp    rax,r9
   1817a34bd:	74 75                	je     0x1817a3534
   1817a34bf:	49 8b b9 c0 00 00 00 	mov    rdi,QWORD PTR [r9+0xc0]
   1817a34c6:	49 83 b9 c8 00 00 00 	cmp    QWORD PTR [r9+0xc8],0x10
   1817a34cd:	10 
   1817a34ce:	72 3e                	jb     0x1817a350e
   1817a34d0:	4d 8b 89 b0 00 00 00 	mov    r9,QWORD PTR [r9+0xb0]
   1817a34d7:	48 8d 98 b0 00 00 00 	lea    rbx,[rax+0xb0]
   1817a34de:	48 8b 88 c8 00 00 00 	mov    rcx,QWORD PTR [rax+0xc8]
   1817a34e5:	48 39 cf             	cmp    rdi,rcx
   1817a34e8:	77 3e                	ja     0x1817a3528
   1817a34ea:	48 83 f9 10          	cmp    rcx,0x10
   1817a34ee:	72 03                	jb     0x1817a34f3
   1817a34f0:	48 8b 1b             	mov    rbx,QWORD PTR [rbx]
   1817a34f3:	48 89 b8 c0 00 00 00 	mov    QWORD PTR [rax+0xc0],rdi
   1817a34fa:	48 89 d9             	mov    rcx,rbx
   1817a34fd:	4c 89 ca             	mov    rdx,r9
   1817a3500:	49 89 f8             	mov    r8,rdi
   1817a3503:	e8 48 0b da 05       	call   0x187544050
   1817a3508:	c6 04 3b 00          	mov    BYTE PTR [rbx+rdi*1],0x0
   1817a350c:	eb 26                	jmp    0x1817a3534
   1817a350e:	49 81 c1 b0 00 00 00 	add    r9,0xb0
   1817a3515:	48 8d 98 b0 00 00 00 	lea    rbx,[rax+0xb0]
   1817a351c:	48 8b 88 c8 00 00 00 	mov    rcx,QWORD PTR [rax+0xc8]
   1817a3523:	48 39 cf             	cmp    rdi,rcx
   1817a3526:	76 c2                	jbe    0x1817a34ea
   1817a3528:	48 89 d9             	mov    rcx,rbx
   1817a352b:	48 89 fa             	mov    rdx,rdi
   1817a352e:	e8 1d ac 89 fe       	call   0x18003e150
   1817a3533:	90                   	nop
   1817a3534:	48 8b 85 80 09 00 00 	mov    rax,QWORD PTR [rbp+0x980]
   1817a353b:	c7 80 18 01 00 00 10 	mov    DWORD PTR [rax+0x118],0x2710
   1817a3542:	27 00 00 
   1817a3545:	e8 16 6f 91 fe       	call   0x1800ba460
   1817a354a:	90                   	nop
   1817a354b:	48 89 c7             	mov    rdi,rax
   1817a354e:	4c 8b bd 80 09 00 00 	mov    r15,QWORD PTR [rbp+0x980]
   1817a3555:	49 8d 9f 58 07 00 00 	lea    rbx,[r15+0x758]
   1817a355c:	48 89 c1             	mov    rcx,rax
   1817a355f:	e8 3c 10 d8 05       	call   0x1875245a0
   1817a3564:	49 8b 8f 70 07 00 00 	mov    rcx,QWORD PTR [r15+0x770]
   1817a356b:	48 39 c8             	cmp    rax,rcx
   1817a356e:	76 11                	jbe    0x1817a3581
   1817a3570:	48 89 d9             	mov    rcx,rbx
   1817a3573:	48 89 c2             	mov    rdx,rax
   1817a3576:	49 89 f9             	mov    r9,rdi
   1817a3579:	e8 d2 ab 89 fe       	call   0x18003e150
   1817a357e:	90                   	nop
   1817a357f:	eb 25                	jmp    0x1817a35a6
   1817a3581:	48 83 f9 10          	cmp    rcx,0x10
   1817a3585:	72 03                	jb     0x1817a358a
   1817a3587:	48 8b 1b             	mov    rbx,QWORD PTR [rbx]
   1817a358a:	49 89 87 68 07 00 00 	mov    QWORD PTR [r15+0x768],rax
   1817a3591:	48 89 d9             	mov    rcx,rbx
   1817a3594:	48 89 fa             	mov    rdx,rdi
   1817a3597:	49 89 c0             	mov    r8,rax
   1817a359a:	48 89 c7             	mov    rdi,rax
   1817a359d:	e8 ae 0a da 05       	call   0x187544050
   1817a35a2:	c6 04 3b 00          	mov    BYTE PTR [rbx+rdi*1],0x0
   1817a35a6:	48 8b 85 80 09 00 00 	mov    rax,QWORD PTR [rbp+0x980]
   1817a35ad:	c7 80 9c 00 00 00 01 	mov    DWORD PTR [rax+0x9c],0x1
   1817a35b4:	00 00 00 
   1817a35b7:	4c 89 b5 f0 08 00 00 	mov    QWORD PTR [rbp+0x8f0],r14
   1817a35be:	0f 29 b5 e0 08 00 00 	movaps XMMWORD PTR [rbp+0x8e0],xmm6
   1817a35c5:	0f 29 b5 d0 08 00 00 	movaps XMMWORD PTR [rbp+0x8d0],xmm6
   1817a35cc:	0f 29 b5 c0 08 00 00 	movaps XMMWORD PTR [rbp+0x8c0],xmm6
   1817a35d3:	0f 57 c0             	xorps  xmm0,xmm0
   1817a35d6:	0f 29 85 70 09 00 00 	movaps XMMWORD PTR [rbp+0x970],xmm0
   1817a35dd:	48 8b 8d 88 09 00 00 	mov    rcx,QWORD PTR [rbp+0x988]
   1817a35e4:	48 85 c9             	test   rcx,rcx
   1817a35e7:	74 40                	je     0x1817a3629
   1817a35e9:	f0 ff 41 08          	lock inc DWORD PTR [rcx+0x8]
   1817a35ed:	48 8b 85 80 09 00 00 	mov    rax,QWORD PTR [rbp+0x980]
   1817a35f4:	48 8b 8d 88 09 00 00 	mov    rcx,QWORD PTR [rbp+0x988]
   1817a35fb:	48 89 85 70 09 00 00 	mov    QWORD PTR [rbp+0x970],rax
   1817a3602:	48 89 8d 78 09 00 00 	mov    QWORD PTR [rbp+0x978],rcx
   1817a3609:	0f 29 85 a0 02 00 00 	movaps XMMWORD PTR [rbp+0x2a0],xmm0
   1817a3610:	48 85 c9             	test   rcx,rcx
   1817a3613:	74 26                	je     0x1817a363b
   1817a3615:	f0 ff 41 08          	lock inc DWORD PTR [rcx+0x8]
   1817a3619:	48 8b 85 70 09 00 00 	mov    rax,QWORD PTR [rbp+0x970]
   1817a3620:	48 8b 8d 78 09 00 00 	mov    rcx,QWORD PTR [rbp+0x978]
   1817a3627:	eb 14                	jmp    0x1817a363d
   1817a3629:	48 89 85 70 09 00 00 	mov    QWORD PTR [rbp+0x970],rax
   1817a3630:	48 c7 85 78 09 00 00 	mov    QWORD PTR [rbp+0x978],0x0
   1817a3637:	00 00 00 00 
   1817a363b:	31 c9                	xor    ecx,ecx
   1817a363d:	48 89 85 a0 02 00 00 	mov    QWORD PTR [rbp+0x2a0],rax
   1817a3644:	48 89 8d a8 02 00 00 	mov    QWORD PTR [rbp+0x2a8],rcx
   1817a364b:	48 8d 95 c0 08 00 00 	lea    rdx,[rbp+0x8c0]
   1817a3652:	4c 8d 85 a0 02 00 00 	lea    r8,[rbp+0x2a0]
   1817a3659:	48 89 f1             	mov    rcx,rsi
   1817a365c:	45 31 c9             	xor    r9d,r9d
   1817a365f:	e8 9c ba fe ff       	call   0x18178f100
   1817a3664:	90                   	nop
   1817a3665:	48 8b bd 78 09 00 00 	mov    rdi,QWORD PTR [rbp+0x978]
   1817a366c:	48 85 ff             	test   rdi,rdi
   1817a366f:	74 1d                	je     0x1817a368e
   1817a3671:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   1817a3675:	75 17                	jne    0x1817a368e
   1817a3677:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1817a367a:	48 89 f9             	mov    rcx,rdi
   1817a367d:	ff 10                	call   QWORD PTR [rax]
   1817a367f:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   1817a3683:	75 09                	jne    0x1817a368e
   1817a3685:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1817a3688:	48 89 f9             	mov    rcx,rdi
   1817a368b:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1817a368e:	4c 89 b5 e0 05 00 00 	mov    QWORD PTR [rbp+0x5e0],r14
   1817a3695:	0f 29 b5 d0 05 00 00 	movaps XMMWORD PTR [rbp+0x5d0],xmm6
   1817a369c:	0f 29 b5 c0 05 00 00 	movaps XMMWORD PTR [rbp+0x5c0],xmm6
   1817a36a3:	0f 29 b5 b0 05 00 00 	movaps XMMWORD PTR [rbp+0x5b0],xmm6
   1817a36aa:	0f 29 b5 a0 05 00 00 	movaps XMMWORD PTR [rbp+0x5a0],xmm6
   1817a36b1:	0f 29 b5 90 05 00 00 	movaps XMMWORD PTR [rbp+0x590],xmm6
   1817a36b8:	48 8b 95 e8 08 00 00 	mov    rdx,QWORD PTR [rbp+0x8e8]
   1817a36bf:	c6 85 e0 05 00 00 00 	mov    BYTE PTR [rbp+0x5e0],0x0
   1817a36c6:	80 7a 50 01          	cmp    BYTE PTR [rdx+0x50],0x1
   1817a36ca:	0f 85 19 01 00 00    	jne    0x1817a37e9
   1817a36d0:	48 8d 8d 90 05 00 00 	lea    rcx,[rbp+0x590]
   1817a36d7:	e8 04 5c fc fe       	call   0x1807692e0
   1817a36dc:	90                   	nop
   1817a36dd:	c6 85 e0 05 00 00 01 	mov    BYTE PTR [rbp+0x5e0],0x1
   1817a36e4:	48 8d 15 7d 95 72 07 	lea    rdx,[rip+0x772957d]        # 0x188eccc68
   1817a36eb:	48 8d bd a0 02 00 00 	lea    rdi,[rbp+0x2a0]
   1817a36f2:	41 b8 f0 02 00 00    	mov    r8d,0x2f0
   1817a36f8:	48 89 f9             	mov    rcx,rdi
   1817a36fb:	e8 50 09 da 05       	call   0x187544050
   1817a3700:	8b 85 b0 05 00 00    	mov    eax,DWORD PTR [rbp+0x5b0]
   1817a3706:	44 8b 8d b4 05 00 00 	mov    r9d,DWORD PTR [rbp+0x5b4]
   1817a370d:	89 44 24 20          	mov    DWORD PTR [rsp+0x20],eax
   1817a3711:	4c 8d 85 90 05 00 00 	lea    r8,[rbp+0x590]
   1817a3718:	48 89 f1             	mov    rcx,rsi
   1817a371b:	48 89 fa             	mov    rdx,rdi
   1817a371e:	e8 4d 19 00 00       	call   0x1817a5070
   1817a3723:	90                   	nop
   1817a3724:	80 bd 88 05 00 00 01 	cmp    BYTE PTR [rbp+0x588],0x1
   1817a372b:	75 25                	jne    0x1817a3752
   1817a372d:	48 8d 95 a0 02 00 00 	lea    rdx,[rbp+0x2a0]
   1817a3734:	48 89 f1             	mov    rcx,rsi
   1817a3737:	e8 d4 a9 fe ff       	call   0x18178e110
   1817a373c:	90                   	nop
   1817a373d:	80 bd 88 05 00 00 01 	cmp    BYTE PTR [rbp+0x588],0x1
   1817a3744:	75 0c                	jne    0x1817a3752
   1817a3746:	48 8d 8d a0 02 00 00 	lea    rcx,[rbp+0x2a0]
   1817a374d:	e8 9e 19 a2 fe       	call   0x1801c50f0
   1817a3752:	80 bd e0 05 00 00 01 	cmp    BYTE PTR [rbp+0x5e0],0x1
   1817a3759:	0f 85 8a 00 00 00    	jne    0x1817a37e9
   1817a375f:	48 8b 85 d8 05 00 00 	mov    rax,QWORD PTR [rbp+0x5d8]
   1817a3766:	48 83 f8 10          	cmp    rax,0x10
   1817a376a:	72 38                	jb     0x1817a37a4
   1817a376c:	48 8b 8d c0 05 00 00 	mov    rcx,QWORD PTR [rbp+0x5c0]
   1817a3773:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1817a3777:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1817a377e:	72 1f                	jb     0x1817a379f
   1817a3780:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1817a3784:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1817a3788:	4c 29 c1             	sub    rcx,r8
   1817a378b:	48 83 f9 20          	cmp    rcx,0x20
   1817a378f:	0f 83 03 02 00 00    	jae    0x1817a3998
   1817a3795:	48 83 c0 28          	add    rax,0x28
   1817a3799:	48 89 c2             	mov    rdx,rax
   1817a379c:	4c 89 c1             	mov    rcx,r8
   1817a379f:	e8 3c 81 d0 05       	call   0x1874ab8e0
   1817a37a4:	48 8b 85 a8 05 00 00 	mov    rax,QWORD PTR [rbp+0x5a8]
   1817a37ab:	48 83 f8 10          	cmp    rax,0x10
   1817a37af:	72 38                	jb     0x1817a37e9
   1817a37b1:	48 8b 8d 90 05 00 00 	mov    rcx,QWORD PTR [rbp+0x590]
   1817a37b8:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1817a37bc:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1817a37c3:	72 1f                	jb     0x1817a37e4
   1817a37c5:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1817a37c9:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1817a37cd:	4c 29 c1             	sub    rcx,r8
   1817a37d0:	48 83 f9 20          	cmp    rcx,0x20
   1817a37d4:	0f 83 be 01 00 00    	jae    0x1817a3998
   1817a37da:	48 83 c0 28          	add    rax,0x28
   1817a37de:	48 89 c2             	mov    rdx,rax
   1817a37e1:	4c 89 c1             	mov    rcx,r8
   1817a37e4:	e8 f7 80 d0 05       	call   0x1874ab8e0
   1817a37e9:	48 8b b5 f0 08 00 00 	mov    rsi,QWORD PTR [rbp+0x8f0]
   1817a37f0:	48 85 f6             	test   rsi,rsi
   1817a37f3:	74 1d                	je     0x1817a3812
   1817a37f5:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   1817a37f9:	75 17                	jne    0x1817a3812
   1817a37fb:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1817a37fe:	48 89 f1             	mov    rcx,rsi
   1817a3801:	ff 10                	call   QWORD PTR [rax]
   1817a3803:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   1817a3807:	75 09                	jne    0x1817a3812
   1817a3809:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1817a380c:	48 89 f1             	mov    rcx,rsi
   1817a380f:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1817a3812:	48 8b 85 e0 08 00 00 	mov    rax,QWORD PTR [rbp+0x8e0]
   1817a3819:	48 83 f8 10          	cmp    rax,0x10
   1817a381d:	72 38                	jb     0x1817a3857
   1817a381f:	48 8b 8d c8 08 00 00 	mov    rcx,QWORD PTR [rbp+0x8c8]
   1817a3826:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1817a382a:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1817a3831:	72 1f                	jb     0x1817a3852
   1817a3833:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1817a3837:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1817a383b:	4c 29 c1             	sub    rcx,r8
   1817a383e:	48 83 f9 20          	cmp    rcx,0x20
   1817a3842:	0f 83 50 01 00 00    	jae    0x1817a3998
   1817a3848:	48 83 c0 28          	add    rax,0x28
   1817a384c:	48 89 c2             	mov    rdx,rax
   1817a384f:	4c 89 c1             	mov    rcx,r8
   1817a3852:	e8 89 80 d0 05       	call   0x1874ab8e0
   1817a3857:	48 8b b5 88 09 00 00 	mov    rsi,QWORD PTR [rbp+0x988]
   1817a385e:	48 85 f6             	test   rsi,rsi
   1817a3861:	74 1d                	je     0x1817a3880
   1817a3863:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   1817a3867:	75 17                	jne    0x1817a3880
   1817a3869:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1817a386c:	48 89 f1             	mov    rcx,rsi
   1817a386f:	ff 10                	call   QWORD PTR [rax]
   1817a3871:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   1817a3875:	75 09                	jne    0x1817a3880
   1817a3877:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1817a387a:	48 89 f1             	mov    rcx,rsi
   1817a387d:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1817a3880:	80 bd 50 09 00 00 01 	cmp    BYTE PTR [rbp+0x950],0x1
   1817a3887:	0f 85 8a 00 00 00    	jne    0x1817a3917
   1817a388d:	48 8b 85 48 09 00 00 	mov    rax,QWORD PTR [rbp+0x948]
   1817a3894:	48 83 f8 10          	cmp    rax,0x10
   1817a3898:	72 38                	jb     0x1817a38d2
   1817a389a:	48 8b 8d 30 09 00 00 	mov    rcx,QWORD PTR [rbp+0x930]
   1817a38a1:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1817a38a5:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1817a38ac:	72 1f                	jb     0x1817a38cd
   1817a38ae:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1817a38b2:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1817a38b6:	4c 29 c1             	sub    rcx,r8
   1817a38b9:	48 83 f9 20          	cmp    rcx,0x20
   1817a38bd:	0f 83 d5 00 00 00    	jae    0x1817a3998
   1817a38c3:	48 83 c0 28          	add    rax,0x28
   1817a38c7:	48 89 c2             	mov    rdx,rax
   1817a38ca:	4c 89 c1             	mov    rcx,r8
   1817a38cd:	e8 0e 80 d0 05       	call   0x1874ab8e0
   1817a38d2:	48 8b 85 18 09 00 00 	mov    rax,QWORD PTR [rbp+0x918]
   1817a38d9:	48 83 f8 10          	cmp    rax,0x10
   1817a38dd:	72 38                	jb     0x1817a3917
   1817a38df:	48 8b 8d 00 09 00 00 	mov    rcx,QWORD PTR [rbp+0x900]
   1817a38e6:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1817a38ea:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1817a38f1:	72 1f                	jb     0x1817a3912
   1817a38f3:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1817a38f7:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1817a38fb:	4c 29 c1             	sub    rcx,r8
   1817a38fe:	48 83 f9 20          	cmp    rcx,0x20
   1817a3902:	0f 83 90 00 00 00    	jae    0x1817a3998
   1817a3908:	48 83 c0 28          	add    rax,0x28
   1817a390c:	48 89 c2             	mov    rdx,rax
   1817a390f:	4c 89 c1             	mov    rcx,r8
   1817a3912:	e8 c9 7f d0 05       	call   0x1874ab8e0
   1817a3917:	48 8b b5 b0 08 00 00 	mov    rsi,QWORD PTR [rbp+0x8b0]
   1817a391e:	48 85 f6             	test   rsi,rsi
   1817a3921:	74 1d                	je     0x1817a3940
   1817a3923:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   1817a3927:	75 17                	jne    0x1817a3940
   1817a3929:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1817a392c:	48 89 f1             	mov    rcx,rsi
   1817a392f:	ff 10                	call   QWORD PTR [rax]
   1817a3931:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   1817a3935:	75 09                	jne    0x1817a3940
   1817a3937:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1817a393a:	48 89 f1             	mov    rcx,rsi
   1817a393d:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1817a3940:	48 8b 85 a0 08 00 00 	mov    rax,QWORD PTR [rbp+0x8a0]
   1817a3947:	48 83 f8 10          	cmp    rax,0x10
   1817a394b:	72 34                	jb     0x1817a3981
   1817a394d:	48 8b 8d 88 08 00 00 	mov    rcx,QWORD PTR [rbp+0x888]
   1817a3954:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1817a3958:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1817a395f:	72 1b                	jb     0x1817a397c
   1817a3961:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1817a3965:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1817a3969:	4c 29 c1             	sub    rcx,r8
   1817a396c:	48 83 f9 20          	cmp    rcx,0x20
   1817a3970:	73 26                	jae    0x1817a3998
   1817a3972:	48 83 c0 28          	add    rax,0x28
   1817a3976:	48 89 c2             	mov    rdx,rax
   1817a3979:	4c 89 c1             	mov    rcx,r8
   1817a397c:	e8 5f 7f d0 05       	call   0x1874ab8e0
   1817a3981:	0f 28 b5 a0 09 00 00 	movaps xmm6,XMMWORD PTR [rbp+0x9a0]
   1817a3988:	48 81 c4 38 0a 00 00 	add    rsp,0xa38
   1817a398f:	5b                   	pop    rbx
   1817a3990:	5f                   	pop    rdi
   1817a3991:	5e                   	pop    rsi
   1817a3992:	41 5e                	pop    r14
   1817a3994:	41 5f                	pop    r15
   1817a3996:	5d                   	pop    rbp
   1817a3997:	c3                   	ret
   1817a3998:	e8 ef 99 d6 05       	call   0x18750d38c
   1817a399d:	cc                   	int3
