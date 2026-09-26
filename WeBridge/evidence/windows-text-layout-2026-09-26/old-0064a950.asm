
.research\wechat-4.1.10.27-reference\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

000000018064a950 <.text+0x649950>:
   18064a950:	55                   	push   rbp
   18064a951:	41 56                	push   r14
   18064a953:	56                   	push   rsi
   18064a954:	57                   	push   rdi
   18064a955:	53                   	push   rbx
   18064a956:	48 83 ec 30          	sub    rsp,0x30
   18064a95a:	48 8d 6c 24 30       	lea    rbp,[rsp+0x30]
   18064a95f:	48 c7 45 f8 fe ff ff 	mov    QWORD PTR [rbp-0x8],0xfffffffffffffffe
   18064a966:	ff 
   18064a967:	48 89 ce             	mov    rsi,rcx
   18064a96a:	b9 58 07 00 00       	mov    ecx,0x758
   18064a96f:	e8 88 27 1c 06       	call   0x18680d0fc
   18064a974:	48 b9 01 00 00 00 01 	movabs rcx,0x100000001
   18064a97b:	00 00 00 
   18064a97e:	48 89 48 08          	mov    QWORD PTR [rax+0x8],rcx
   18064a982:	48 8d 0d cf e9 c2 07 	lea    rcx,[rip+0x7c2e9cf]        # 0x188279358
   18064a989:	48 89 08             	mov    QWORD PTR [rax],rcx
   18064a98c:	48 89 45 f0          	mov    QWORD PTR [rbp-0x10],rax
   18064a990:	48 8d 58 10          	lea    rbx,[rax+0x10]
   18064a994:	41 b8 48 07 00 00    	mov    r8d,0x748
   18064a99a:	48 89 d9             	mov    rcx,rbx
   18064a99d:	31 d2                	xor    edx,edx
   18064a99f:	e8 cc bd 24 06       	call   0x186896770
   18064a9a4:	90                   	nop
   18064a9a5:	48 89 d9             	mov    rcx,rbx
   18064a9a8:	e8 83 82 06 00       	call   0x1806b2c30
   18064a9ad:	90                   	nop
   18064a9ae:	48 89 1e             	mov    QWORD PTR [rsi],rbx
   18064a9b1:	48 8b 55 f0          	mov    rdx,QWORD PTR [rbp-0x10]
   18064a9b5:	48 89 56 08          	mov    QWORD PTR [rsi+0x8],rdx
   18064a9b9:	48 8b 42 20          	mov    rax,QWORD PTR [rdx+0x20]
   18064a9bd:	48 85 c0             	test   rax,rax
   18064a9c0:	74 06                	je     0x18064a9c8
   18064a9c2:	83 78 08 00          	cmp    DWORD PTR [rax+0x8],0x0
   18064a9c6:	75 61                	jne    0x18064aa29
   18064a9c8:	41 b6 01             	mov    r14b,0x1
   18064a9cb:	48 85 d2             	test   rdx,rdx
   18064a9ce:	74 16                	je     0x18064a9e6
   18064a9d0:	f0 ff 42 08          	lock inc DWORD PTR [rdx+0x8]
   18064a9d4:	48 8b 7e 08          	mov    rdi,QWORD PTR [rsi+0x8]
   18064a9d8:	48 85 ff             	test   rdi,rdi
   18064a9db:	74 09                	je     0x18064a9e6
   18064a9dd:	f0 ff 47 0c          	lock inc DWORD PTR [rdi+0xc]
   18064a9e1:	45 31 f6             	xor    r14d,r14d
   18064a9e4:	eb 04                	jmp    0x18064a9ea
   18064a9e6:	31 ff                	xor    edi,edi
   18064a9e8:	31 db                	xor    ebx,ebx
   18064a9ea:	48 89 5a 18          	mov    QWORD PTR [rdx+0x18],rbx
   18064a9ee:	48 8b 4a 20          	mov    rcx,QWORD PTR [rdx+0x20]
   18064a9f2:	48 89 7a 20          	mov    QWORD PTR [rdx+0x20],rdi
   18064a9f6:	48 85 c9             	test   rcx,rcx
   18064a9f9:	74 0c                	je     0x18064aa07
   18064a9fb:	f0 ff 49 0c          	lock dec DWORD PTR [rcx+0xc]
   18064a9ff:	75 06                	jne    0x18064aa07
   18064aa01:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18064aa04:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18064aa07:	45 84 f6             	test   r14b,r14b
   18064aa0a:	75 1d                	jne    0x18064aa29
   18064aa0c:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   18064aa10:	75 17                	jne    0x18064aa29
   18064aa12:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   18064aa15:	48 89 f9             	mov    rcx,rdi
   18064aa18:	ff 10                	call   QWORD PTR [rax]
   18064aa1a:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   18064aa1e:	75 09                	jne    0x18064aa29
   18064aa20:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   18064aa23:	48 89 f9             	mov    rcx,rdi
   18064aa26:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18064aa29:	48 89 f0             	mov    rax,rsi
   18064aa2c:	48 83 c4 30          	add    rsp,0x30
   18064aa30:	5b                   	pop    rbx
   18064aa31:	5f                   	pop    rdi
   18064aa32:	5e                   	pop    rsi
   18064aa33:	41 5e                	pop    r14
   18064aa35:	5d                   	pop    rbp
   18064aa36:	c3                   	ret
