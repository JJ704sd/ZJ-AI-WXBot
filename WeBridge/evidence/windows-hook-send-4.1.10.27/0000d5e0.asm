
.research\wechat-4.1.10.27-reference\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

000000018000d5e0 <.text+0xc5e0>:
   18000d5e0:	55                   	push   rbp
   18000d5e1:	41 57                	push   r15
   18000d5e3:	41 56                	push   r14
   18000d5e5:	41 55                	push   r13
   18000d5e7:	41 54                	push   r12
   18000d5e9:	56                   	push   rsi
   18000d5ea:	57                   	push   rdi
   18000d5eb:	53                   	push   rbx
   18000d5ec:	48 81 ec c8 02 00 00 	sub    rsp,0x2c8
   18000d5f3:	48 8d ac 24 80 00 00 	lea    rbp,[rsp+0x80]
   18000d5fa:	00 
   18000d5fb:	48 c7 85 40 02 00 00 	mov    QWORD PTR [rbp+0x240],0xfffffffffffffffe
   18000d602:	fe ff ff ff 
   18000d606:	4d 89 cf             	mov    r15,r9
   18000d609:	4d 89 c4             	mov    r12,r8
   18000d60c:	49 89 d5             	mov    r13,rdx
   18000d60f:	48 89 ce             	mov    rsi,rcx
   18000d612:	4c 8b b5 b0 02 00 00 	mov    r14,QWORD PTR [rbp+0x2b0]
   18000d619:	48 83 bd c8 02 00 00 	cmp    QWORD PTR [rbp+0x2c8],0x0
   18000d620:	00 
   18000d621:	4c 89 8d 30 02 00 00 	mov    QWORD PTR [rbp+0x230],r9
   18000d628:	4c 89 85 28 02 00 00 	mov    QWORD PTR [rbp+0x228],r8
   18000d62f:	0f 85 2c 01 00 00    	jne    0x18000d761
   18000d635:	48 8b 05 74 0a 0c 0a 	mov    rax,QWORD PTR [rip+0xa0c0a74]        # 0x18a0ce0b0
   18000d63c:	48 ff c0             	inc    rax
   18000d63f:	48 89 05 6a 0a 0c 0a 	mov    QWORD PTR [rip+0xa0c0a6a],rax        # 0x18a0ce0b0
   18000d646:	48 89 85 c8 02 00 00 	mov    QWORD PTR [rbp+0x2c8],rax
   18000d64d:	48 8b 4e 48          	mov    rcx,QWORD PTR [rsi+0x48]
   18000d651:	48 85 c9             	test   rcx,rcx
   18000d654:	74 5a                	je     0x18000d6b0
   18000d656:	8b 41 08             	mov    eax,DWORD PTR [rcx+0x8]
   18000d659:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
   18000d660:	85 c0                	test   eax,eax
   18000d662:	74 4c                	je     0x18000d6b0
   18000d664:	8d 50 01             	lea    edx,[rax+0x1]
   18000d667:	f0 0f b1 51 08       	lock cmpxchg DWORD PTR [rcx+0x8],edx
   18000d66c:	75 f2                	jne    0x18000d660
   18000d66e:	48 8b 7e 48          	mov    rdi,QWORD PTR [rsi+0x48]
   18000d672:	48 83 7e 40 00       	cmp    QWORD PTR [rsi+0x40],0x0
   18000d677:	0f 84 54 05 00 00    	je     0x18000dbd1
   18000d67d:	48 85 ff             	test   rdi,rdi
   18000d680:	0f 84 db 00 00 00    	je     0x18000d761
   18000d686:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   18000d68a:	0f 85 d1 00 00 00    	jne    0x18000d761
   18000d690:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   18000d693:	48 89 f9             	mov    rcx,rdi
   18000d696:	ff 10                	call   QWORD PTR [rax]
   18000d698:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   18000d69c:	0f 85 bf 00 00 00    	jne    0x18000d761
   18000d6a2:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   18000d6a5:	48 89 f9             	mov    rcx,rdi
   18000d6a8:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18000d6ab:	e9 b1 00 00 00       	jmp    0x18000d761
   18000d6b0:	48 83 7e 38 00       	cmp    QWORD PTR [rsi+0x38],0x0
   18000d6b5:	0f 84 a6 00 00 00    	je     0x18000d761
   18000d6bb:	48 8b 3d 26 d2 82 0a 	mov    rdi,QWORD PTR [rip+0xa82d226]        # 0x18a83a8e8
   18000d6c2:	48 89 f9             	mov    rcx,rdi
   18000d6c5:	e8 7a 0d 80 06       	call   0x18680e444
   18000d6ca:	85 c0                	test   eax,eax
   18000d6cc:	0f 85 99 06 00 00    	jne    0x18000dd6b
   18000d6d2:	48 89 bd 38 02 00 00 	mov    QWORD PTR [rbp+0x238],rdi
   18000d6d9:	81 7f 4c ff ff ff 7f 	cmp    DWORD PTR [rdi+0x4c],0x7fffffff
   18000d6e0:	0f 84 90 06 00 00    	je     0x18000dd76
   18000d6e6:	48 8b 95 c0 02 00 00 	mov    rdx,QWORD PTR [rbp+0x2c0]
   18000d6ed:	48 8d 8d 40 01 00 00 	lea    rcx,[rbp+0x140]
   18000d6f4:	e8 d7 f1 17 00       	call   0x18018c8d0
   18000d6f9:	90                   	nop
   18000d6fa:	c7 85 60 01 00 00 00 	mov    DWORD PTR [rbp+0x160],0x0
   18000d701:	00 00 00 
   18000d704:	48 8d 0d cd d1 82 0a 	lea    rcx,[rip+0xa82d1cd]        # 0x18a83a8d8
   18000d70b:	48 8d 95 30 01 00 00 	lea    rdx,[rbp+0x130]
   18000d712:	4c 8d 85 c8 02 00 00 	lea    r8,[rbp+0x2c8]
   18000d719:	e8 62 11 00 00       	call   0x18000e880
   18000d71e:	90                   	nop
   18000d71f:	48 8b bd 30 01 00 00 	mov    rdi,QWORD PTR [rbp+0x130]
   18000d726:	48 8d 4f 28          	lea    rcx,[rdi+0x28]
   18000d72a:	48 8d 95 40 01 00 00 	lea    rdx,[rbp+0x140]
   18000d731:	e8 9a f1 17 00       	call   0x18018c8d0
   18000d736:	90                   	nop
   18000d737:	8b 85 60 01 00 00    	mov    eax,DWORD PTR [rbp+0x160]
   18000d73d:	89 47 48             	mov    DWORD PTR [rdi+0x48],eax
   18000d740:	48 8b 8d 38 02 00 00 	mov    rcx,QWORD PTR [rbp+0x238]
   18000d747:	e8 20 0d 80 06       	call   0x18680e46c
   18000d74c:	4c 8b b5 b0 02 00 00 	mov    r14,QWORD PTR [rbp+0x2b0]
   18000d753:	4c 8b bd 30 02 00 00 	mov    r15,QWORD PTR [rbp+0x230]
   18000d75a:	4c 8b a5 28 02 00 00 	mov    r12,QWORD PTR [rbp+0x228]
   18000d761:	48 8b bd c8 02 00 00 	mov    rdi,QWORD PTR [rbp+0x2c8]
   18000d768:	49 89 7d 00          	mov    QWORD PTR [r13+0x0],rdi
   18000d76c:	0f 57 c0             	xorps  xmm0,xmm0
   18000d76f:	41 0f 11 45 08       	movups XMMWORD PTR [r13+0x8],xmm0
   18000d774:	41 0f 11 45 18       	movups XMMWORD PTR [r13+0x18],xmm0
   18000d779:	48 83 7e 38 00       	cmp    QWORD PTR [rsi+0x38],0x0
   18000d77e:	4c 89 ad 38 02 00 00 	mov    QWORD PTR [rbp+0x238],r13
   18000d785:	0f 84 9a 00 00 00    	je     0x18000d825
   18000d78b:	48 b8 aa aa aa aa aa 	movabs rax,0xaaaaaaaaaaaaaaaa
   18000d792:	aa aa aa 
   18000d795:	48 89 85 20 02 00 00 	mov    QWORD PTR [rbp+0x220],rax
   18000d79c:	0f 28 05 1d a9 16 08 	movaps xmm0,XMMWORD PTR [rip+0x816a91d]        # 0x1881780c0
   18000d7a3:	0f 29 85 10 02 00 00 	movaps XMMWORD PTR [rbp+0x210],xmm0
   18000d7aa:	0f 29 85 00 02 00 00 	movaps XMMWORD PTR [rbp+0x200],xmm0
   18000d7b1:	0f 29 85 f0 01 00 00 	movaps XMMWORD PTR [rbp+0x1f0],xmm0
   18000d7b8:	0f 29 85 e0 01 00 00 	movaps XMMWORD PTR [rbp+0x1e0],xmm0
   18000d7bf:	0f 29 85 d0 01 00 00 	movaps XMMWORD PTR [rbp+0x1d0],xmm0
   18000d7c6:	0f 29 85 c0 01 00 00 	movaps XMMWORD PTR [rbp+0x1c0],xmm0
   18000d7cd:	0f 29 85 b0 01 00 00 	movaps XMMWORD PTR [rbp+0x1b0],xmm0
   18000d7d4:	0f 29 85 a0 01 00 00 	movaps XMMWORD PTR [rbp+0x1a0],xmm0
   18000d7db:	0f 29 85 90 01 00 00 	movaps XMMWORD PTR [rbp+0x190],xmm0
   18000d7e2:	0f 29 85 80 01 00 00 	movaps XMMWORD PTR [rbp+0x180],xmm0
   18000d7e9:	0f 29 85 70 01 00 00 	movaps XMMWORD PTR [rbp+0x170],xmm0
   18000d7f0:	0f 29 85 60 01 00 00 	movaps XMMWORD PTR [rbp+0x160],xmm0
   18000d7f7:	0f 29 85 50 01 00 00 	movaps XMMWORD PTR [rbp+0x150],xmm0
   18000d7fe:	0f 29 85 40 01 00 00 	movaps XMMWORD PTR [rbp+0x140],xmm0
   18000d805:	48 c7 45 e8 00 00 00 	mov    QWORD PTR [rbp-0x18],0x0
   18000d80c:	00 
   18000d80d:	49 8b 4e 38          	mov    rcx,QWORD PTR [r14+0x38]
   18000d811:	48 85 c9             	test   rcx,rcx
   18000d814:	0f 84 80 00 00 00    	je     0x18000d89a
   18000d81a:	4c 39 f1             	cmp    rcx,r14
   18000d81d:	74 50                	je     0x18000d86f
   18000d81f:	48 89 4d e8          	mov    QWORD PTR [rbp-0x18],rcx
   18000d823:	eb 6d                	jmp    0x18000d892
   18000d825:	0f 29 85 40 01 00 00 	movaps XMMWORD PTR [rbp+0x140],xmm0
   18000d82c:	48 8b 4e 48          	mov    rcx,QWORD PTR [rsi+0x48]
   18000d830:	48 85 c9             	test   rcx,rcx
   18000d833:	0f 84 4f 02 00 00    	je     0x18000da88
   18000d839:	8b 41 08             	mov    eax,DWORD PTR [rcx+0x8]
   18000d83c:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
   18000d840:	85 c0                	test   eax,eax
   18000d842:	0f 84 49 03 00 00    	je     0x18000db91
   18000d848:	8d 50 01             	lea    edx,[rax+0x1]
   18000d84b:	f0 0f b1 51 08       	lock cmpxchg DWORD PTR [rcx+0x8],edx
   18000d850:	75 ee                	jne    0x18000d840
   18000d852:	0f 10 46 40          	movups xmm0,XMMWORD PTR [rsi+0x40]
   18000d856:	48 8b 7e 40          	mov    rdi,QWORD PTR [rsi+0x40]
   18000d85a:	0f 29 85 40 01 00 00 	movaps XMMWORD PTR [rbp+0x140],xmm0
   18000d861:	48 85 ff             	test   rdi,rdi
   18000d864:	0f 85 37 03 00 00    	jne    0x18000dba1
   18000d86a:	e9 ee 01 00 00       	jmp    0x18000da5d
   18000d86f:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000d872:	48 8d 55 b0          	lea    rdx,[rbp-0x50]
   18000d876:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18000d879:	48 89 45 e8          	mov    QWORD PTR [rbp-0x18],rax
   18000d87d:	49 8b 4e 38          	mov    rcx,QWORD PTR [r14+0x38]
   18000d881:	48 85 c9             	test   rcx,rcx
   18000d884:	74 14                	je     0x18000d89a
   18000d886:	4c 39 f1             	cmp    rcx,r14
   18000d889:	0f 95 c2             	setne  dl
   18000d88c:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000d88f:	ff 50 20             	call   QWORD PTR [rax+0x20]
   18000d892:	49 c7 46 38 00 00 00 	mov    QWORD PTR [r14+0x38],0x0
   18000d899:	00 
   18000d89a:	48 c7 45 28 00 00 00 	mov    QWORD PTR [rbp+0x28],0x0
   18000d8a1:	00 
   18000d8a2:	49 8b 4f 38          	mov    rcx,QWORD PTR [r15+0x38]
   18000d8a6:	48 85 c9             	test   rcx,rcx
   18000d8a9:	74 36                	je     0x18000d8e1
   18000d8ab:	4c 39 f9             	cmp    rcx,r15
   18000d8ae:	74 06                	je     0x18000d8b6
   18000d8b0:	48 89 4d 28          	mov    QWORD PTR [rbp+0x28],rcx
   18000d8b4:	eb 23                	jmp    0x18000d8d9
   18000d8b6:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000d8b9:	48 8d 55 f0          	lea    rdx,[rbp-0x10]
   18000d8bd:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18000d8c0:	48 89 45 28          	mov    QWORD PTR [rbp+0x28],rax
   18000d8c4:	49 8b 4f 38          	mov    rcx,QWORD PTR [r15+0x38]
   18000d8c8:	48 85 c9             	test   rcx,rcx
   18000d8cb:	74 14                	je     0x18000d8e1
   18000d8cd:	4c 39 f9             	cmp    rcx,r15
   18000d8d0:	0f 95 c2             	setne  dl
   18000d8d3:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000d8d6:	ff 50 20             	call   QWORD PTR [rax+0x20]
   18000d8d9:	49 c7 47 38 00 00 00 	mov    QWORD PTR [r15+0x38],0x0
   18000d8e0:	00 
   18000d8e1:	48 8b 9d b8 02 00 00 	mov    rbx,QWORD PTR [rbp+0x2b8]
   18000d8e8:	48 c7 45 68 00 00 00 	mov    QWORD PTR [rbp+0x68],0x0
   18000d8ef:	00 
   18000d8f0:	49 8b 4c 24 38       	mov    rcx,QWORD PTR [r12+0x38]
   18000d8f5:	48 85 c9             	test   rcx,rcx
   18000d8f8:	74 38                	je     0x18000d932
   18000d8fa:	4c 39 e1             	cmp    rcx,r12
   18000d8fd:	74 06                	je     0x18000d905
   18000d8ff:	48 89 4d 68          	mov    QWORD PTR [rbp+0x68],rcx
   18000d903:	eb 24                	jmp    0x18000d929
   18000d905:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000d908:	48 8d 55 30          	lea    rdx,[rbp+0x30]
   18000d90c:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18000d90f:	48 89 45 68          	mov    QWORD PTR [rbp+0x68],rax
   18000d913:	49 8b 4c 24 38       	mov    rcx,QWORD PTR [r12+0x38]
   18000d918:	48 85 c9             	test   rcx,rcx
   18000d91b:	74 15                	je     0x18000d932
   18000d91d:	4c 39 e1             	cmp    rcx,r12
   18000d920:	0f 95 c2             	setne  dl
   18000d923:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000d926:	ff 50 20             	call   QWORD PTR [rax+0x20]
   18000d929:	49 c7 44 24 38 00 00 	mov    QWORD PTR [r12+0x38],0x0
   18000d930:	00 00 
   18000d932:	48 89 7c 24 28       	mov    QWORD PTR [rsp+0x28],rdi
   18000d937:	48 89 5c 24 20       	mov    QWORD PTR [rsp+0x20],rbx
   18000d93c:	48 8d 8d 40 01 00 00 	lea    rcx,[rbp+0x140]
   18000d943:	48 8d 55 30          	lea    rdx,[rbp+0x30]
   18000d947:	4c 8d 45 f0          	lea    r8,[rbp-0x10]
   18000d94b:	4c 8d 4d b0          	lea    r9,[rbp-0x50]
   18000d94f:	e8 ec 05 00 00       	call   0x18000df40
   18000d954:	90                   	nop
   18000d955:	48 8b 4e 38          	mov    rcx,QWORD PTR [rsi+0x38]
   18000d959:	48 85 c9             	test   rcx,rcx
   18000d95c:	0f 84 03 04 00 00    	je     0x18000dd65
   18000d962:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000d965:	48 8d 95 40 01 00 00 	lea    rdx,[rbp+0x140]
   18000d96c:	ff 50 10             	call   QWORD PTR [rax+0x10]
   18000d96f:	90                   	nop
   18000d970:	48 8b 85 48 01 00 00 	mov    rax,QWORD PTR [rbp+0x148]
   18000d977:	48 85 c0             	test   rax,rax
   18000d97a:	74 0d                	je     0x18000d989
   18000d97c:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   18000d980:	48 8b 85 48 01 00 00 	mov    rax,QWORD PTR [rbp+0x148]
   18000d987:	eb 02                	jmp    0x18000d98b
   18000d989:	31 c0                	xor    eax,eax
   18000d98b:	48 8b 95 38 02 00 00 	mov    rdx,QWORD PTR [rbp+0x238]
   18000d992:	48 8b 8d 40 01 00 00 	mov    rcx,QWORD PTR [rbp+0x140]
   18000d999:	48 89 4a 08          	mov    QWORD PTR [rdx+0x8],rcx
   18000d99d:	48 8b 7a 10          	mov    rdi,QWORD PTR [rdx+0x10]
   18000d9a1:	48 89 42 10          	mov    QWORD PTR [rdx+0x10],rax
   18000d9a5:	48 85 ff             	test   rdi,rdi
   18000d9a8:	74 1d                	je     0x18000d9c7
   18000d9aa:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   18000d9ae:	75 17                	jne    0x18000d9c7
   18000d9b0:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   18000d9b3:	48 89 f9             	mov    rcx,rdi
   18000d9b6:	ff 10                	call   QWORD PTR [rax]
   18000d9b8:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   18000d9bc:	75 09                	jne    0x18000d9c7
   18000d9be:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   18000d9c1:	48 89 f9             	mov    rcx,rdi
   18000d9c4:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18000d9c7:	48 8b 8d 20 02 00 00 	mov    rcx,QWORD PTR [rbp+0x220]
   18000d9ce:	48 85 c9             	test   rcx,rcx
   18000d9d1:	74 0c                	je     0x18000d9df
   18000d9d3:	f0 ff 49 0c          	lock dec DWORD PTR [rcx+0xc]
   18000d9d7:	75 06                	jne    0x18000d9df
   18000d9d9:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000d9dc:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18000d9df:	48 8b 8d 08 02 00 00 	mov    rcx,QWORD PTR [rbp+0x208]
   18000d9e6:	48 85 c9             	test   rcx,rcx
   18000d9e9:	74 1e                	je     0x18000da09
   18000d9eb:	48 8d 85 d0 01 00 00 	lea    rax,[rbp+0x1d0]
   18000d9f2:	48 39 c1             	cmp    rcx,rax
   18000d9f5:	0f 95 c2             	setne  dl
   18000d9f8:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000d9fb:	ff 50 20             	call   QWORD PTR [rax+0x20]
   18000d9fe:	48 c7 85 08 02 00 00 	mov    QWORD PTR [rbp+0x208],0x0
   18000da05:	00 00 00 00 
   18000da09:	48 8b 8d c8 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1c8]
   18000da10:	48 85 c9             	test   rcx,rcx
   18000da13:	74 1e                	je     0x18000da33
   18000da15:	48 8d 85 90 01 00 00 	lea    rax,[rbp+0x190]
   18000da1c:	48 39 c1             	cmp    rcx,rax
   18000da1f:	0f 95 c2             	setne  dl
   18000da22:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000da25:	ff 50 20             	call   QWORD PTR [rax+0x20]
   18000da28:	48 c7 85 c8 01 00 00 	mov    QWORD PTR [rbp+0x1c8],0x0
   18000da2f:	00 00 00 00 
   18000da33:	48 8b 8d 88 01 00 00 	mov    rcx,QWORD PTR [rbp+0x188]
   18000da3a:	48 85 c9             	test   rcx,rcx
   18000da3d:	74 1e                	je     0x18000da5d
   18000da3f:	48 8d 85 50 01 00 00 	lea    rax,[rbp+0x150]
   18000da46:	48 39 c1             	cmp    rcx,rax
   18000da49:	0f 95 c2             	setne  dl
   18000da4c:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000da4f:	ff 50 20             	call   QWORD PTR [rax+0x20]
   18000da52:	48 c7 85 88 01 00 00 	mov    QWORD PTR [rbp+0x188],0x0
   18000da59:	00 00 00 00 
   18000da5d:	48 8b bd 48 01 00 00 	mov    rdi,QWORD PTR [rbp+0x148]
   18000da64:	48 85 ff             	test   rdi,rdi
   18000da67:	74 26                	je     0x18000da8f
   18000da69:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   18000da6d:	75 20                	jne    0x18000da8f
   18000da6f:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   18000da72:	48 89 f9             	mov    rcx,rdi
   18000da75:	ff 10                	call   QWORD PTR [rax]
   18000da77:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   18000da7b:	75 12                	jne    0x18000da8f
   18000da7d:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   18000da80:	48 89 f9             	mov    rcx,rdi
   18000da83:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18000da86:	eb 07                	jmp    0x18000da8f
   18000da88:	31 ff                	xor    edi,edi
   18000da8a:	48 85 ff             	test   rdi,rdi
   18000da8d:	75 da                	jne    0x18000da69
   18000da8f:	b9 28 00 00 00       	mov    ecx,0x28
   18000da94:	e8 63 f6 7f 06       	call   0x18680d0fc
   18000da99:	90                   	nop
   18000da9a:	48 b9 01 00 00 00 01 	movabs rcx,0x100000001
   18000daa1:	00 00 00 
   18000daa4:	48 89 48 08          	mov    QWORD PTR [rax+0x8],rcx
   18000daa8:	48 8d 0d b9 b9 16 08 	lea    rcx,[rip+0x816b9b9]        # 0x188179468
   18000daaf:	48 89 08             	mov    QWORD PTR [rax],rcx
   18000dab2:	48 8b 4e 48          	mov    rcx,QWORD PTR [rsi+0x48]
   18000dab6:	48 85 c9             	test   rcx,rcx
   18000dab9:	74 0a                	je     0x18000dac5
   18000dabb:	48 8b 56 40          	mov    rdx,QWORD PTR [rsi+0x40]
   18000dabf:	f0 ff 41 0c          	lock inc DWORD PTR [rcx+0xc]
   18000dac3:	eb 02                	jmp    0x18000dac7
   18000dac5:	31 d2                	xor    edx,edx
   18000dac7:	48 8b bd b0 02 00 00 	mov    rdi,QWORD PTR [rbp+0x2b0]
   18000dace:	48 8b 9d 30 02 00 00 	mov    rbx,QWORD PTR [rbp+0x230]
   18000dad5:	4c 8b b5 28 02 00 00 	mov    r14,QWORD PTR [rbp+0x228]
   18000dadc:	4c 8b bd 38 02 00 00 	mov    r15,QWORD PTR [rbp+0x238]
   18000dae3:	49 89 c0             	mov    r8,rax
   18000dae6:	49 83 c0 10          	add    r8,0x10
   18000daea:	4c 8d 0d 07 ba 16 08 	lea    r9,[rip+0x816ba07]        # 0x1881794f8
   18000daf1:	4c 89 48 10          	mov    QWORD PTR [rax+0x10],r9
   18000daf5:	48 89 50 18          	mov    QWORD PTR [rax+0x18],rdx
   18000daf9:	48 89 48 20          	mov    QWORD PTR [rax+0x20],rcx
   18000dafd:	4d 89 47 18          	mov    QWORD PTR [r15+0x18],r8
   18000db01:	49 8b 77 20          	mov    rsi,QWORD PTR [r15+0x20]
   18000db05:	49 89 47 20          	mov    QWORD PTR [r15+0x20],rax
   18000db09:	48 85 f6             	test   rsi,rsi
   18000db0c:	74 1d                	je     0x18000db2b
   18000db0e:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   18000db12:	75 17                	jne    0x18000db2b
   18000db14:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   18000db17:	48 89 f1             	mov    rcx,rsi
   18000db1a:	ff 10                	call   QWORD PTR [rax]
   18000db1c:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   18000db20:	75 09                	jne    0x18000db2b
   18000db22:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   18000db25:	48 89 f1             	mov    rcx,rsi
   18000db28:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18000db2b:	49 8b 4e 38          	mov    rcx,QWORD PTR [r14+0x38]
   18000db2f:	48 85 c9             	test   rcx,rcx
   18000db32:	74 14                	je     0x18000db48
   18000db34:	4c 39 f1             	cmp    rcx,r14
   18000db37:	0f 95 c2             	setne  dl
   18000db3a:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000db3d:	ff 50 20             	call   QWORD PTR [rax+0x20]
   18000db40:	49 c7 46 38 00 00 00 	mov    QWORD PTR [r14+0x38],0x0
   18000db47:	00 
   18000db48:	48 8b 4b 38          	mov    rcx,QWORD PTR [rbx+0x38]
   18000db4c:	48 85 c9             	test   rcx,rcx
   18000db4f:	74 14                	je     0x18000db65
   18000db51:	48 39 d9             	cmp    rcx,rbx
   18000db54:	0f 95 c2             	setne  dl
   18000db57:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000db5a:	ff 50 20             	call   QWORD PTR [rax+0x20]
   18000db5d:	48 c7 43 38 00 00 00 	mov    QWORD PTR [rbx+0x38],0x0
   18000db64:	00 
   18000db65:	48 8b 4f 38          	mov    rcx,QWORD PTR [rdi+0x38]
   18000db69:	48 85 c9             	test   rcx,rcx
   18000db6c:	74 0c                	je     0x18000db7a
   18000db6e:	48 39 f9             	cmp    rcx,rdi
   18000db71:	0f 95 c2             	setne  dl
   18000db74:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000db77:	ff 50 20             	call   QWORD PTR [rax+0x20]
   18000db7a:	4c 89 f8             	mov    rax,r15
   18000db7d:	48 81 c4 c8 02 00 00 	add    rsp,0x2c8
   18000db84:	5b                   	pop    rbx
   18000db85:	5f                   	pop    rdi
   18000db86:	5e                   	pop    rsi
   18000db87:	41 5c                	pop    r12
   18000db89:	41 5d                	pop    r13
   18000db8b:	41 5e                	pop    r14
   18000db8d:	41 5f                	pop    r15
   18000db8f:	5d                   	pop    rbp
   18000db90:	c3                   	ret
   18000db91:	48 8b bd 40 01 00 00 	mov    rdi,QWORD PTR [rbp+0x140]
   18000db98:	48 85 ff             	test   rdi,rdi
   18000db9b:	0f 84 bc fe ff ff    	je     0x18000da5d
   18000dba1:	48 c7 85 a8 00 00 00 	mov    QWORD PTR [rbp+0xa8],0x0
   18000dba8:	00 00 00 00 
   18000dbac:	48 8b 9d 28 02 00 00 	mov    rbx,QWORD PTR [rbp+0x228]
   18000dbb3:	48 8b 4b 38          	mov    rcx,QWORD PTR [rbx+0x38]
   18000dbb7:	48 85 c9             	test   rcx,rcx
   18000dbba:	4c 8b b5 38 02 00 00 	mov    r14,QWORD PTR [rbp+0x238]
   18000dbc1:	74 70                	je     0x18000dc33
   18000dbc3:	48 39 d9             	cmp    rcx,rbx
   18000dbc6:	74 3d                	je     0x18000dc05
   18000dbc8:	48 89 8d a8 00 00 00 	mov    QWORD PTR [rbp+0xa8],rcx
   18000dbcf:	eb 5a                	jmp    0x18000dc2b
   18000dbd1:	48 8b 5e 38          	mov    rbx,QWORD PTR [rsi+0x38]
   18000dbd5:	48 85 ff             	test   rdi,rdi
   18000dbd8:	74 1d                	je     0x18000dbf7
   18000dbda:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   18000dbde:	75 17                	jne    0x18000dbf7
   18000dbe0:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   18000dbe3:	48 89 f9             	mov    rcx,rdi
   18000dbe6:	ff 10                	call   QWORD PTR [rax]
   18000dbe8:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   18000dbec:	75 09                	jne    0x18000dbf7
   18000dbee:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   18000dbf1:	48 89 f9             	mov    rcx,rdi
   18000dbf4:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18000dbf7:	48 85 db             	test   rbx,rbx
   18000dbfa:	0f 85 bb fa ff ff    	jne    0x18000d6bb
   18000dc00:	e9 5c fb ff ff       	jmp    0x18000d761
   18000dc05:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000dc08:	48 8d 55 70          	lea    rdx,[rbp+0x70]
   18000dc0c:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18000dc0f:	48 89 85 a8 00 00 00 	mov    QWORD PTR [rbp+0xa8],rax
   18000dc16:	48 8b 4b 38          	mov    rcx,QWORD PTR [rbx+0x38]
   18000dc1a:	48 85 c9             	test   rcx,rcx
   18000dc1d:	74 14                	je     0x18000dc33
   18000dc1f:	48 39 d9             	cmp    rcx,rbx
   18000dc22:	0f 95 c2             	setne  dl
   18000dc25:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000dc28:	ff 50 20             	call   QWORD PTR [rax+0x20]
   18000dc2b:	48 c7 43 38 00 00 00 	mov    QWORD PTR [rbx+0x38],0x0
   18000dc32:	00 
   18000dc33:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   18000dc36:	4c 8d 45 70          	lea    r8,[rbp+0x70]
   18000dc3a:	48 89 f9             	mov    rcx,rdi
   18000dc3d:	4c 89 f2             	mov    rdx,r14
   18000dc40:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18000dc43:	90                   	nop
   18000dc44:	48 8b 85 30 02 00 00 	mov    rax,QWORD PTR [rbp+0x230]
   18000dc4b:	48 8b 48 38          	mov    rcx,QWORD PTR [rax+0x38]
   18000dc4f:	48 85 c9             	test   rcx,rcx
   18000dc52:	74 7c                	je     0x18000dcd0
   18000dc54:	48 8b bd 40 01 00 00 	mov    rdi,QWORD PTR [rbp+0x140]
   18000dc5b:	48 c7 85 e8 00 00 00 	mov    QWORD PTR [rbp+0xe8],0x0
   18000dc62:	00 00 00 00 
   18000dc66:	48 8b 9d 30 02 00 00 	mov    rbx,QWORD PTR [rbp+0x230]
   18000dc6d:	48 39 d9             	cmp    rcx,rbx
   18000dc70:	74 10                	je     0x18000dc82
   18000dc72:	48 89 8d e8 00 00 00 	mov    QWORD PTR [rbp+0xe8],rcx
   18000dc79:	48 8b 95 38 02 00 00 	mov    rdx,QWORD PTR [rbp+0x238]
   18000dc80:	eb 36                	jmp    0x18000dcb8
   18000dc82:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000dc85:	48 8d 95 b0 00 00 00 	lea    rdx,[rbp+0xb0]
   18000dc8c:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18000dc8f:	48 89 85 e8 00 00 00 	mov    QWORD PTR [rbp+0xe8],rax
   18000dc96:	48 8b 4b 38          	mov    rcx,QWORD PTR [rbx+0x38]
   18000dc9a:	48 85 c9             	test   rcx,rcx
   18000dc9d:	48 8b 95 38 02 00 00 	mov    rdx,QWORD PTR [rbp+0x238]
   18000dca4:	74 1a                	je     0x18000dcc0
   18000dca6:	48 39 d9             	cmp    rcx,rbx
   18000dca9:	49 89 d6             	mov    r14,rdx
   18000dcac:	0f 95 c2             	setne  dl
   18000dcaf:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000dcb2:	ff 50 20             	call   QWORD PTR [rax+0x20]
   18000dcb5:	4c 89 f2             	mov    rdx,r14
   18000dcb8:	48 c7 43 38 00 00 00 	mov    QWORD PTR [rbx+0x38],0x0
   18000dcbf:	00 
   18000dcc0:	4c 8d 85 b0 00 00 00 	lea    r8,[rbp+0xb0]
   18000dcc7:	48 89 f9             	mov    rcx,rdi
   18000dcca:	e8 01 06 00 00       	call   0x18000e2d0
   18000dccf:	90                   	nop
   18000dcd0:	48 8b 85 b0 02 00 00 	mov    rax,QWORD PTR [rbp+0x2b0]
   18000dcd7:	48 8b 48 38          	mov    rcx,QWORD PTR [rax+0x38]
   18000dcdb:	48 85 c9             	test   rcx,rcx
   18000dcde:	0f 84 79 fd ff ff    	je     0x18000da5d
   18000dce4:	48 8b bd 40 01 00 00 	mov    rdi,QWORD PTR [rbp+0x140]
   18000dceb:	48 c7 85 28 01 00 00 	mov    QWORD PTR [rbp+0x128],0x0
   18000dcf2:	00 00 00 00 
   18000dcf6:	48 8b 9d b0 02 00 00 	mov    rbx,QWORD PTR [rbp+0x2b0]
   18000dcfd:	48 39 d9             	cmp    rcx,rbx
   18000dd00:	74 10                	je     0x18000dd12
   18000dd02:	48 89 8d 28 01 00 00 	mov    QWORD PTR [rbp+0x128],rcx
   18000dd09:	48 8b 95 38 02 00 00 	mov    rdx,QWORD PTR [rbp+0x238]
   18000dd10:	eb 36                	jmp    0x18000dd48
   18000dd12:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000dd15:	48 8d 95 f0 00 00 00 	lea    rdx,[rbp+0xf0]
   18000dd1c:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18000dd1f:	48 89 85 28 01 00 00 	mov    QWORD PTR [rbp+0x128],rax
   18000dd26:	48 8b 4b 38          	mov    rcx,QWORD PTR [rbx+0x38]
   18000dd2a:	48 85 c9             	test   rcx,rcx
   18000dd2d:	48 8b 95 38 02 00 00 	mov    rdx,QWORD PTR [rbp+0x238]
   18000dd34:	74 1a                	je     0x18000dd50
   18000dd36:	48 39 d9             	cmp    rcx,rbx
   18000dd39:	49 89 d6             	mov    r14,rdx
   18000dd3c:	0f 95 c2             	setne  dl
   18000dd3f:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18000dd42:	ff 50 20             	call   QWORD PTR [rax+0x20]
   18000dd45:	4c 89 f2             	mov    rdx,r14
   18000dd48:	48 c7 43 38 00 00 00 	mov    QWORD PTR [rbx+0x38],0x0
   18000dd4f:	00 
   18000dd50:	4c 8d 85 f0 00 00 00 	lea    r8,[rbp+0xf0]
   18000dd57:	48 89 f9             	mov    rcx,rdi
   18000dd5a:	e8 11 08 00 00       	call   0x18000e570
   18000dd5f:	90                   	nop
   18000dd60:	e9 f8 fc ff ff       	jmp    0x18000da5d
   18000dd65:	e8 7e 02 80 06       	call   0x18680dfe8
   18000dd6a:	90                   	nop
   18000dd6b:	b9 05 00 00 00       	mov    ecx,0x5
   18000dd70:	e8 17 fb 7f 06       	call   0x18680d88c
   18000dd75:	90                   	nop
   18000dd76:	48 8b 85 38 02 00 00 	mov    rax,QWORD PTR [rbp+0x238]
   18000dd7d:	c7 40 4c fe ff ff 7f 	mov    DWORD PTR [rax+0x4c],0x7ffffffe
   18000dd84:	b9 06 00 00 00       	mov    ecx,0x6
   18000dd89:	e8 fe fa 7f 06       	call   0x18680d88c
   18000dd8e:	90                   	nop
   18000dd8f:	cc                   	int3
