
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000180057690 <.text+0x56690>:
   180057690:	55                   	push   rbp
   180057691:	56                   	push   rsi
   180057692:	57                   	push   rdi
   180057693:	53                   	push   rbx
   180057694:	48 83 ec 38          	sub    rsp,0x38
   180057698:	48 8d 6c 24 30       	lea    rbp,[rsp+0x30]
   18005769d:	48 c7 45 00 fe ff ff 	mov    QWORD PTR [rbp+0x0],0xfffffffffffffffe
   1800576a4:	ff 
   1800576a5:	48 89 d6             	mov    rsi,rdx
   1800576a8:	48 89 cf             	mov    rdi,rcx
   1800576ab:	48 8b 1d 0e ac 8b 0b 	mov    rbx,QWORD PTR [rip+0xb8bac0e]        # 0x18b9122c0
   1800576b2:	48 89 d9             	mov    rcx,rbx
   1800576b5:	e8 4e 52 45 07       	call   0x1874ac908
   1800576ba:	85 c0                	test   eax,eax
   1800576bc:	0f 85 e1 00 00 00    	jne    0x1800577a3
   1800576c2:	81 7b 4c ff ff ff 7f 	cmp    DWORD PTR [rbx+0x4c],0x7fffffff
   1800576c9:	0f 84 de 00 00 00    	je     0x1800577ad
   1800576cf:	48 8d 97 d0 00 00 00 	lea    rdx,[rdi+0xd0]
   1800576d6:	48 8d 0d d3 ab 8b 0b 	lea    rcx,[rip+0xb8babd3]        # 0x18b9122b0
   1800576dd:	e8 ae 83 00 00       	call   0x18005fa90
   1800576e2:	48 89 d9             	mov    rcx,rbx
   1800576e5:	e8 46 52 45 07       	call   0x1874ac930
   1800576ea:	48 8b 4f 48          	mov    rcx,QWORD PTR [rdi+0x48]
   1800576ee:	48 85 c9             	test   rcx,rcx
   1800576f1:	74 1e                	je     0x180057711
   1800576f3:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1800576f6:	80 38 00             	cmp    BYTE PTR [rax],0x0
   1800576f9:	0f 85 9b 00 00 00    	jne    0x18005779a
   1800576ff:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   180057702:	48 89 f2             	mov    rdx,rsi
   180057705:	48 83 c4 38          	add    rsp,0x38
   180057709:	5b                   	pop    rbx
   18005770a:	5f                   	pop    rdi
   18005770b:	5e                   	pop    rsi
   18005770c:	5d                   	pop    rbp
   18005770d:	48 ff 60 10          	rex.W jmp QWORD PTR [rax+0x10]
   180057711:	0f 57 c0             	xorps  xmm0,xmm0
   180057714:	0f 29 45 f0          	movaps XMMWORD PTR [rbp-0x10],xmm0
   180057718:	48 8b 8f e0 00 00 00 	mov    rcx,QWORD PTR [rdi+0xe0]
   18005771f:	48 85 c9             	test   rcx,rcx
   180057722:	74 33                	je     0x180057757
   180057724:	8b 41 08             	mov    eax,DWORD PTR [rcx+0x8]
   180057727:	66 0f 1f 84 00 00 00 	nop    WORD PTR [rax+rax*1+0x0]
   18005772e:	00 00 
   180057730:	85 c0                	test   eax,eax
   180057732:	74 2c                	je     0x180057760
   180057734:	8d 50 01             	lea    edx,[rax+0x1]
   180057737:	f0 0f b1 51 08       	lock cmpxchg DWORD PTR [rcx+0x8],edx
   18005773c:	75 f2                	jne    0x180057730
   18005773e:	0f 10 87 d8 00 00 00 	movups xmm0,XMMWORD PTR [rdi+0xd8]
   180057745:	48 8b 8f d8 00 00 00 	mov    rcx,QWORD PTR [rdi+0xd8]
   18005774c:	0f 29 45 f0          	movaps XMMWORD PTR [rbp-0x10],xmm0
   180057750:	48 85 c9             	test   rcx,rcx
   180057753:	75 14                	jne    0x180057769
   180057755:	eb 1c                	jmp    0x180057773
   180057757:	31 f6                	xor    esi,esi
   180057759:	48 85 f6             	test   rsi,rsi
   18005775c:	75 1e                	jne    0x18005777c
   18005775e:	eb 3a                	jmp    0x18005779a
   180057760:	48 8b 4d f0          	mov    rcx,QWORD PTR [rbp-0x10]
   180057764:	48 85 c9             	test   rcx,rcx
   180057767:	74 0a                	je     0x180057773
   180057769:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18005776c:	48 89 f2             	mov    rdx,rsi
   18005776f:	ff 50 10             	call   QWORD PTR [rax+0x10]
   180057772:	90                   	nop
   180057773:	48 8b 75 f8          	mov    rsi,QWORD PTR [rbp-0x8]
   180057777:	48 85 f6             	test   rsi,rsi
   18005777a:	74 1e                	je     0x18005779a
   18005777c:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   180057780:	75 18                	jne    0x18005779a
   180057782:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   180057785:	48 89 f1             	mov    rcx,rsi
   180057788:	ff 10                	call   QWORD PTR [rax]
   18005778a:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   18005778e:	75 0a                	jne    0x18005779a
   180057790:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   180057793:	48 89 f1             	mov    rcx,rsi
   180057796:	ff 50 08             	call   QWORD PTR [rax+0x8]
   180057799:	90                   	nop
   18005779a:	48 83 c4 38          	add    rsp,0x38
   18005779e:	5b                   	pop    rbx
   18005779f:	5f                   	pop    rdi
   1800577a0:	5e                   	pop    rsi
   1800577a1:	5d                   	pop    rbp
   1800577a2:	c3                   	ret
   1800577a3:	b9 05 00 00 00       	mov    ecx,0x5
   1800577a8:	e8 97 47 45 07       	call   0x1874abf44
   1800577ad:	c7 43 4c fe ff ff 7f 	mov    DWORD PTR [rbx+0x4c],0x7ffffffe
   1800577b4:	b9 06 00 00 00       	mov    ecx,0x6
   1800577b9:	e8 86 47 45 07       	call   0x1874abf44
   1800577be:	cc                   	int3
