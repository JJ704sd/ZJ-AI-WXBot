
.research\wechat-4.1.10.27-reference\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

00000001836ce7a0 <.text+0x36cd7a0>:
   1836ce7a0:	55                   	push   rbp
   1836ce7a1:	41 57                	push   r15
   1836ce7a3:	41 56                	push   r14
   1836ce7a5:	41 55                	push   r13
   1836ce7a7:	41 54                	push   r12
   1836ce7a9:	56                   	push   rsi
   1836ce7aa:	57                   	push   rdi
   1836ce7ab:	53                   	push   rbx
   1836ce7ac:	48 81 ec 48 03 00 00 	sub    rsp,0x348
   1836ce7b3:	48 8d ac 24 80 00 00 	lea    rbp,[rsp+0x80]
   1836ce7ba:	00 
   1836ce7bb:	44 0f 29 85 b0 02 00 	movaps XMMWORD PTR [rbp+0x2b0],xmm8
   1836ce7c2:	00 
   1836ce7c3:	0f 29 bd a0 02 00 00 	movaps XMMWORD PTR [rbp+0x2a0],xmm7
   1836ce7ca:	0f 29 b5 90 02 00 00 	movaps XMMWORD PTR [rbp+0x290],xmm6
   1836ce7d1:	48 c7 85 88 02 00 00 	mov    QWORD PTR [rbp+0x288],0xfffffffffffffffe
   1836ce7d8:	fe ff ff ff 
   1836ce7dc:	4c 89 8d 98 01 00 00 	mov    QWORD PTR [rbp+0x198],r9
   1836ce7e3:	4c 89 85 90 01 00 00 	mov    QWORD PTR [rbp+0x190],r8
   1836ce7ea:	49 89 cf             	mov    r15,rcx
   1836ce7ed:	48 8b 9d 30 03 00 00 	mov    rbx,QWORD PTR [rbp+0x330]
   1836ce7f4:	8b 03                	mov    eax,DWORD PTR [rbx]
   1836ce7f6:	89 85 7c 02 00 00    	mov    DWORD PTR [rbp+0x27c],eax
   1836ce7fc:	0f 28 35 bd 98 aa 04 	movaps xmm6,XMMWORD PTR [rip+0x4aa98bd]        # 0x1881780c0
   1836ce803:	0f 57 ff             	xorps  xmm7,xmm7
   1836ce806:	44 0f 28 05 f2 da 1e 	movaps xmm8,XMMWORD PTR [rip+0x51edaf2]        # 0x1888bc300
   1836ce80d:	05 
   1836ce80e:	48 bf aa aa aa aa aa 	movabs rdi,0xaaaaaaaaaaaaaaaa
   1836ce815:	aa aa aa 
   1836ce818:	48 8d b5 30 01 00 00 	lea    rsi,[rbp+0x130]
   1836ce81f:	4c 8d 25 64 9d aa 04 	lea    r12,[rip+0x4aa9d64]        # 0x18817858a
   1836ce826:	48 89 8d 80 02 00 00 	mov    QWORD PTR [rbp+0x280],rcx
   1836ce82d:	eb 19                	jmp    0x1836ce848
   1836ce82f:	90                   	nop
   1836ce830:	48 83 c0 28          	add    rax,0x28
   1836ce834:	48 89 c2             	mov    rdx,rax
   1836ce837:	4c 89 c1             	mov    rcx,r8
   1836ce83a:	e8 01 e9 13 03       	call   0x18680d140
   1836ce83f:	45 84 ed             	test   r13b,r13b
   1836ce842:	0f 84 29 0a 00 00    	je     0x1836cf271
   1836ce848:	48 89 bd 60 01 00 00 	mov    QWORD PTR [rbp+0x160],rdi
   1836ce84f:	0f 29 b5 50 01 00 00 	movaps XMMWORD PTR [rbp+0x150],xmm6
   1836ce856:	0f 29 b5 40 01 00 00 	movaps XMMWORD PTR [rbp+0x140],xmm6
   1836ce85d:	0f 29 b5 30 01 00 00 	movaps XMMWORD PTR [rbp+0x130],xmm6
   1836ce864:	48 89 f1             	mov    rcx,rsi
   1836ce867:	31 d2                	xor    edx,edx
   1836ce869:	45 31 c0             	xor    r8d,r8d
   1836ce86c:	e8 5f 2a 00 00       	call   0x1836d12d0
   1836ce871:	c7 85 30 01 00 00 92 	mov    DWORD PTR [rbp+0x130],0xffffff92
   1836ce878:	ff ff ff 
   1836ce87b:	83 bd 34 01 00 00 00 	cmp    DWORD PTR [rbp+0x134],0x0
   1836ce882:	75 0a                	jne    0x1836ce88e
   1836ce884:	c7 85 34 01 00 00 aa 	mov    DWORD PTR [rbp+0x134],0xfffffbaa
   1836ce88b:	fb ff ff 
   1836ce88e:	49 89 fe             	mov    r14,rdi
   1836ce891:	49 89 7f 30          	mov    QWORD PTR [r15+0x30],rdi
   1836ce895:	41 0f 11 77 20       	movups XMMWORD PTR [r15+0x20],xmm6
   1836ce89a:	41 0f 11 77 10       	movups XMMWORD PTR [r15+0x10],xmm6
   1836ce89f:	41 0f 11 37          	movups XMMWORD PTR [r15],xmm6
   1836ce8a3:	8b 7b 04             	mov    edi,DWORD PTR [rbx+0x4]
   1836ce8a6:	b9 40 00 00 00       	mov    ecx,0x40
   1836ce8ab:	e8 4c e8 13 03       	call   0x18680d0fc
   1836ce8b0:	90                   	nop
   1836ce8b1:	48 89 85 70 02 00 00 	mov    QWORD PTR [rbp+0x270],rax
   1836ce8b8:	48 89 c1             	mov    rcx,rax
   1836ce8bb:	48 89 f2             	mov    rdx,rsi
   1836ce8be:	e8 4d 33 00 00       	call   0x1836d1c10
   1836ce8c3:	90                   	nop
   1836ce8c4:	48 8b 85 70 02 00 00 	mov    rax,QWORD PTR [rbp+0x270]
   1836ce8cb:	48 89 85 a0 01 00 00 	mov    QWORD PTR [rbp+0x1a0],rax
   1836ce8d2:	48 8d 85 a0 01 00 00 	lea    rax,[rbp+0x1a0]
   1836ce8d9:	48 89 44 24 30       	mov    QWORD PTR [rsp+0x30],rax
   1836ce8de:	89 7c 24 28          	mov    DWORD PTR [rsp+0x28],edi
   1836ce8e2:	48 c7 44 24 20 00 00 	mov    QWORD PTR [rsp+0x20],0x0
   1836ce8e9:	00 00 
   1836ce8eb:	48 8d 4d 10          	lea    rcx,[rbp+0x10]
   1836ce8ef:	48 8d 15 8f 0c af 04 	lea    rdx,[rip+0x4af0c8f]        # 0x1881bf585
   1836ce8f6:	4c 8d 05 7f 0c af 04 	lea    r8,[rip+0x4af0c7f]        # 0x1881bf57c
   1836ce8fd:	41 b9 3e 01 00 00    	mov    r9d,0x13e
   1836ce903:	e8 f8 33 c9 fc       	call   0x180361d00
   1836ce908:	90                   	nop
   1836ce909:	48 8b 8d a0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1a0]
   1836ce910:	48 85 c9             	test   rcx,rcx
   1836ce913:	48 8d bd d0 01 00 00 	lea    rdi,[rbp+0x1d0]
   1836ce91a:	74 0b                	je     0x1836ce927
   1836ce91c:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   1836ce91f:	ba 01 00 00 00       	mov    edx,0x1
   1836ce924:	ff 10                	call   QWORD PTR [rax]
   1836ce926:	90                   	nop
   1836ce927:	48 8d 8d a0 01 00 00 	lea    rcx,[rbp+0x1a0]
   1836ce92e:	48 8b 95 90 01 00 00 	mov    rdx,QWORD PTR [rbp+0x190]
   1836ce935:	e8 d6 e3 59 ff       	call   0x182c6cd10
   1836ce93a:	90                   	nop
   1836ce93b:	0f 11 7f 10          	movups XMMWORD PTR [rdi+0x10],xmm7
   1836ce93f:	0f 11 3f             	movups XMMWORD PTR [rdi],xmm7
   1836ce942:	48 8b 85 98 01 00 00 	mov    rax,QWORD PTR [rbp+0x198]
   1836ce949:	48 83 78 18 10       	cmp    QWORD PTR [rax+0x18],0x10
   1836ce94e:	49 89 c5             	mov    r13,rax
   1836ce951:	72 03                	jb     0x1836ce956
   1836ce953:	4c 8b 28             	mov    r13,QWORD PTR [rax]
   1836ce956:	48 8b 78 10          	mov    rdi,QWORD PTR [rax+0x10]
   1836ce95a:	48 85 ff             	test   rdi,rdi
   1836ce95d:	0f 88 47 09 00 00    	js     0x1836cf2aa
   1836ce963:	48 83 ff 0f          	cmp    rdi,0xf
   1836ce967:	77 27                	ja     0x1836ce990
   1836ce969:	48 89 bd e0 01 00 00 	mov    QWORD PTR [rbp+0x1e0],rdi
   1836ce970:	48 c7 85 e8 01 00 00 	mov    QWORD PTR [rbp+0x1e8],0xf
   1836ce977:	0f 00 00 00 
   1836ce97b:	41 0f 10 45 00       	movups xmm0,XMMWORD PTR [r13+0x0]
   1836ce980:	48 8d 8d d0 01 00 00 	lea    rcx,[rbp+0x1d0]
   1836ce987:	0f 11 01             	movups XMMWORD PTR [rcx],xmm0
   1836ce98a:	e9 8f 00 00 00       	jmp    0x1836cea1e
   1836ce98f:	90                   	nop
   1836ce990:	48 89 f8             	mov    rax,rdi
   1836ce993:	48 83 c8 0f          	or     rax,0xf
   1836ce997:	48 83 f8 17          	cmp    rax,0x17
   1836ce99b:	41 bf 16 00 00 00    	mov    r15d,0x16
   1836ce9a1:	4c 0f 43 f8          	cmovae r15,rax
   1836ce9a5:	48 3d ff 0f 00 00    	cmp    rax,0xfff
   1836ce9ab:	72 33                	jb     0x1836ce9e0
   1836ce9ad:	49 8d 4f 28          	lea    rcx,[r15+0x28]
   1836ce9b1:	e8 46 e7 13 03       	call   0x18680d0fc
   1836ce9b6:	90                   	nop
   1836ce9b7:	48 85 c0             	test   rax,rax
   1836ce9ba:	0f 84 de 08 00 00    	je     0x1836cf29e
   1836ce9c0:	48 89 c1             	mov    rcx,rax
   1836ce9c3:	48 83 c0 27          	add    rax,0x27
   1836ce9c7:	48 83 e0 e0          	and    rax,0xffffffffffffffe0
   1836ce9cb:	48 89 48 f8          	mov    QWORD PTR [rax-0x8],rcx
   1836ce9cf:	eb 19                	jmp    0x1836ce9ea
   1836ce9d1:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
   1836ce9d8:	0f 1f 84 00 00 00 00 
   1836ce9df:	00 
   1836ce9e0:	49 8d 4f 01          	lea    rcx,[r15+0x1]
   1836ce9e4:	e8 13 e7 13 03       	call   0x18680d0fc
   1836ce9e9:	90                   	nop
   1836ce9ea:	48 89 85 d0 01 00 00 	mov    QWORD PTR [rbp+0x1d0],rax
   1836ce9f1:	48 89 bd e0 01 00 00 	mov    QWORD PTR [rbp+0x1e0],rdi
   1836ce9f8:	4c 89 bd e8 01 00 00 	mov    QWORD PTR [rbp+0x1e8],r15
   1836ce9ff:	48 ff c7             	inc    rdi
   1836cea02:	48 89 c1             	mov    rcx,rax
   1836cea05:	4c 89 ea             	mov    rdx,r13
   1836cea08:	49 89 f8             	mov    r8,rdi
   1836cea0b:	e8 c0 76 1c 03       	call   0x1868960d0
   1836cea10:	4c 8b bd 80 02 00 00 	mov    r15,QWORD PTR [rbp+0x280]
   1836cea17:	48 8d 8d d0 01 00 00 	lea    rcx,[rbp+0x1d0]
   1836cea1e:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1836cea21:	48 89 85 f0 01 00 00 	mov    QWORD PTR [rbp+0x1f0],rax
   1836cea28:	0f 11 79 38          	movups XMMWORD PTR [rcx+0x38],xmm7
   1836cea2c:	0f 11 79 28          	movups XMMWORD PTR [rcx+0x28],xmm7
   1836cea30:	4c 8b 6b 18          	mov    r13,QWORD PTR [rbx+0x18]
   1836cea34:	48 83 7b 20 10       	cmp    QWORD PTR [rbx+0x20],0x10
   1836cea39:	48 8d 7b 08          	lea    rdi,[rbx+0x8]
   1836cea3d:	72 04                	jb     0x1836cea43
   1836cea3f:	48 8b 7b 08          	mov    rdi,QWORD PTR [rbx+0x8]
   1836cea43:	4d 85 ed             	test   r13,r13
   1836cea46:	0f 88 58 08 00 00    	js     0x1836cf2a4
   1836cea4c:	49 83 fd 0f          	cmp    r13,0xf
   1836cea50:	77 2e                	ja     0x1836cea80
   1836cea52:	4c 89 ad 08 02 00 00 	mov    QWORD PTR [rbp+0x208],r13
   1836cea59:	48 c7 85 10 02 00 00 	mov    QWORD PTR [rbp+0x210],0xf
   1836cea60:	0f 00 00 00 
   1836cea64:	0f 10 07             	movups xmm0,XMMWORD PTR [rdi]
   1836cea67:	48 8d 85 d0 01 00 00 	lea    rax,[rbp+0x1d0]
   1836cea6e:	0f 11 40 28          	movups XMMWORD PTR [rax+0x28],xmm0
   1836cea72:	e9 90 00 00 00       	jmp    0x1836ceb07
   1836cea77:	66 0f 1f 84 00 00 00 	nop    WORD PTR [rax+rax*1+0x0]
   1836cea7e:	00 00 
   1836cea80:	4c 89 e8             	mov    rax,r13
   1836cea83:	48 83 c8 0f          	or     rax,0xf
   1836cea87:	48 83 f8 17          	cmp    rax,0x17
   1836cea8b:	41 bf 16 00 00 00    	mov    r15d,0x16
   1836cea91:	4c 0f 43 f8          	cmovae r15,rax
   1836cea95:	48 3d ff 0f 00 00    	cmp    rax,0xfff
   1836cea9b:	72 33                	jb     0x1836cead0
   1836cea9d:	49 8d 4f 28          	lea    rcx,[r15+0x28]
   1836ceaa1:	e8 56 e6 13 03       	call   0x18680d0fc
   1836ceaa6:	90                   	nop
   1836ceaa7:	48 85 c0             	test   rax,rax
   1836ceaaa:	0f 84 ee 07 00 00    	je     0x1836cf29e
   1836ceab0:	48 89 c1             	mov    rcx,rax
   1836ceab3:	48 83 c0 27          	add    rax,0x27
   1836ceab7:	48 83 e0 e0          	and    rax,0xffffffffffffffe0
   1836ceabb:	48 89 48 f8          	mov    QWORD PTR [rax-0x8],rcx
   1836ceabf:	eb 19                	jmp    0x1836ceada
   1836ceac1:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
   1836ceac8:	0f 1f 84 00 00 00 00 
   1836ceacf:	00 
   1836cead0:	49 8d 4f 01          	lea    rcx,[r15+0x1]
   1836cead4:	e8 23 e6 13 03       	call   0x18680d0fc
   1836cead9:	90                   	nop
   1836ceada:	48 89 85 f8 01 00 00 	mov    QWORD PTR [rbp+0x1f8],rax
   1836ceae1:	4c 89 ad 08 02 00 00 	mov    QWORD PTR [rbp+0x208],r13
   1836ceae8:	4c 89 bd 10 02 00 00 	mov    QWORD PTR [rbp+0x210],r15
   1836ceaef:	49 ff c5             	inc    r13
   1836ceaf2:	48 89 c1             	mov    rcx,rax
   1836ceaf5:	48 89 fa             	mov    rdx,rdi
   1836ceaf8:	4d 89 e8             	mov    r8,r13
   1836ceafb:	e8 d0 75 1c 03       	call   0x1868960d0
   1836ceb00:	4c 8b bd 80 02 00 00 	mov    r15,QWORD PTR [rbp+0x280]
   1836ceb07:	48 8b 43 28          	mov    rax,QWORD PTR [rbx+0x28]
   1836ceb0b:	48 89 85 18 02 00 00 	mov    QWORD PTR [rbp+0x218],rax
   1836ceb12:	48 8d 4d 10          	lea    rcx,[rbp+0x10]
   1836ceb16:	4c 89 fa             	mov    rdx,r15
   1836ceb19:	4c 8d bd a0 01 00 00 	lea    r15,[rbp+0x1a0]
   1836ceb20:	4d 89 f8             	mov    r8,r15
   1836ceb23:	e8 c8 28 00 00       	call   0x1836d13f0
   1836ceb28:	90                   	nop
   1836ceb29:	4c 89 f7             	mov    rdi,r14
   1836ceb2c:	48 8b 85 10 02 00 00 	mov    rax,QWORD PTR [rbp+0x210]
   1836ceb33:	48 83 f8 10          	cmp    rax,0x10
   1836ceb37:	72 38                	jb     0x1836ceb71
   1836ceb39:	48 8b 8d f8 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1f8]
   1836ceb40:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1836ceb44:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1836ceb4b:	72 1f                	jb     0x1836ceb6c
   1836ceb4d:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1836ceb51:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1836ceb55:	4c 29 c1             	sub    rcx,r8
   1836ceb58:	48 83 f9 20          	cmp    rcx,0x20
   1836ceb5c:	0f 83 3c 07 00 00    	jae    0x1836cf29e
   1836ceb62:	48 83 c0 28          	add    rax,0x28
   1836ceb66:	48 89 c2             	mov    rdx,rax
   1836ceb69:	4c 89 c1             	mov    rcx,r8
   1836ceb6c:	e8 cf e5 13 03       	call   0x18680d140
   1836ceb71:	48 c7 85 08 02 00 00 	mov    QWORD PTR [rbp+0x208],0x0
   1836ceb78:	00 00 00 00 
   1836ceb7c:	48 c7 85 10 02 00 00 	mov    QWORD PTR [rbp+0x210],0xf
   1836ceb83:	0f 00 00 00 
   1836ceb87:	c6 85 f8 01 00 00 00 	mov    BYTE PTR [rbp+0x1f8],0x0
   1836ceb8e:	48 8b 85 e8 01 00 00 	mov    rax,QWORD PTR [rbp+0x1e8]
   1836ceb95:	48 83 f8 10          	cmp    rax,0x10
   1836ceb99:	72 38                	jb     0x1836cebd3
   1836ceb9b:	48 8b 8d d0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1d0]
   1836ceba2:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1836ceba6:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1836cebad:	72 1f                	jb     0x1836cebce
   1836cebaf:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1836cebb3:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1836cebb7:	4c 29 c1             	sub    rcx,r8
   1836cebba:	48 83 f9 20          	cmp    rcx,0x20
   1836cebbe:	0f 83 da 06 00 00    	jae    0x1836cf29e
   1836cebc4:	48 83 c0 28          	add    rax,0x28
   1836cebc8:	48 89 c2             	mov    rdx,rax
   1836cebcb:	4c 89 c1             	mov    rcx,r8
   1836cebce:	e8 6d e5 13 03       	call   0x18680d140
   1836cebd3:	48 c7 85 e0 01 00 00 	mov    QWORD PTR [rbp+0x1e0],0x0
   1836cebda:	00 00 00 00 
   1836cebde:	48 c7 85 e8 01 00 00 	mov    QWORD PTR [rbp+0x1e8],0xf
   1836cebe5:	0f 00 00 00 
   1836cebe9:	c6 85 d0 01 00 00 00 	mov    BYTE PTR [rbp+0x1d0],0x0
   1836cebf0:	4c 89 f9             	mov    rcx,r15
   1836cebf3:	e8 68 e2 59 ff       	call   0x182c6ce60
   1836cebf8:	48 8b 4d 60          	mov    rcx,QWORD PTR [rbp+0x60]
   1836cebfc:	48 85 c9             	test   rcx,rcx
   1836cebff:	74 12                	je     0x1836cec13
   1836cec01:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   1836cec04:	ba 01 00 00 00       	mov    edx,0x1
   1836cec09:	ff 10                	call   QWORD PTR [rax]
   1836cec0b:	48 c7 45 60 00 00 00 	mov    QWORD PTR [rbp+0x60],0x0
   1836cec12:	00 
   1836cec13:	48 8b 45 30          	mov    rax,QWORD PTR [rbp+0x30]
   1836cec17:	48 83 f8 10          	cmp    rax,0x10
   1836cec1b:	72 35                	jb     0x1836cec52
   1836cec1d:	48 8b 4d 18          	mov    rcx,QWORD PTR [rbp+0x18]
   1836cec21:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1836cec25:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1836cec2c:	72 1f                	jb     0x1836cec4d
   1836cec2e:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1836cec32:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1836cec36:	4c 29 c1             	sub    rcx,r8
   1836cec39:	48 83 f9 20          	cmp    rcx,0x20
   1836cec3d:	0f 83 5b 06 00 00    	jae    0x1836cf29e
   1836cec43:	48 83 c0 28          	add    rax,0x28
   1836cec47:	48 89 c2             	mov    rdx,rax
   1836cec4a:	4c 89 c1             	mov    rcx,r8
   1836cec4d:	e8 ee e4 13 03       	call   0x18680d140
   1836cec52:	48 8d 85 44 02 00 00 	lea    rax,[rbp+0x244]
   1836cec59:	48 89 78 24          	mov    QWORD PTR [rax+0x24],rdi
   1836cec5d:	0f 11 70 14          	movups XMMWORD PTR [rax+0x14],xmm6
   1836cec61:	44 0f 29 85 30 02 00 	movaps XMMWORD PTR [rbp+0x230],xmm8
   1836cec68:	00 
   1836cec69:	c7 85 40 02 00 00 0a 	mov    DWORD PTR [rbp+0x240],0x20a
   1836cec70:	02 00 00 
   1836cec73:	0f 11 38             	movups XMMWORD PTR [rax],xmm7
   1836cec76:	c7 40 10 00 00 00 00 	mov    DWORD PTR [rax+0x10],0x0
   1836cec7d:	b9 30 00 00 00       	mov    ecx,0x30
   1836cec82:	e8 75 e4 13 03       	call   0x18680d0fc
   1836cec87:	90                   	nop
   1836cec88:	48 89 85 48 02 00 00 	mov    QWORD PTR [rbp+0x248],rax
   1836cec8f:	48 c7 85 58 02 00 00 	mov    QWORD PTR [rbp+0x258],0x20
   1836cec96:	20 00 00 00 
   1836cec9a:	48 c7 85 60 02 00 00 	mov    QWORD PTR [rbp+0x260],0x2f
   1836ceca1:	2f 00 00 00 
   1836ceca5:	0f 10 05 80 dc 1e 05 	movups xmm0,XMMWORD PTR [rip+0x51edc80]        # 0x1888bc92c
   1836cecac:	0f 11 40 10          	movups XMMWORD PTR [rax+0x10],xmm0
   1836cecb0:	0f 10 05 65 dc 1e 05 	movups xmm0,XMMWORD PTR [rip+0x51edc65]        # 0x1888bc91c
   1836cecb7:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   1836cecba:	c6 40 20 00          	mov    BYTE PTR [rax+0x20],0x0
   1836cecbe:	c6 85 68 02 00 00 01 	mov    BYTE PTR [rbp+0x268],0x1
   1836cecc5:	48 8b 7b 18          	mov    rdi,QWORD PTR [rbx+0x18]
   1836cecc9:	48 85 ff             	test   rdi,rdi
   1836ceccc:	74 5f                	je     0x1836ced2d
   1836cecce:	48 8d 4b 08          	lea    rcx,[rbx+0x8]
   1836cecd2:	48 8d 95 48 02 00 00 	lea    rdx,[rbp+0x248]
   1836cecd9:	48 39 ca             	cmp    rdx,rcx
   1836cecdc:	74 4f                	je     0x1836ced2d
   1836cecde:	48 83 7b 20 10       	cmp    QWORD PTR [rbx+0x20],0x10
   1836cece3:	4c 8d 4b 08          	lea    r9,[rbx+0x8]
   1836cece7:	72 04                	jb     0x1836ceced
   1836cece9:	4c 8b 4b 08          	mov    r9,QWORD PTR [rbx+0x8]
   1836ceced:	48 83 ff 2f          	cmp    rdi,0x2f
   1836cecf1:	76 1d                	jbe    0x1836ced10
   1836cecf3:	48 8d 8d 48 02 00 00 	lea    rcx,[rbp+0x248]
   1836cecfa:	48 89 fa             	mov    rdx,rdi
   1836cecfd:	e8 6e 57 98 fc       	call   0x180054470
   1836ced02:	90                   	nop
   1836ced03:	eb 28                	jmp    0x1836ced2d
   1836ced05:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
   1836ced0c:	00 00 00 00 
   1836ced10:	48 89 bd 58 02 00 00 	mov    QWORD PTR [rbp+0x258],rdi
   1836ced17:	48 89 c1             	mov    rcx,rax
   1836ced1a:	4c 89 ca             	mov    rdx,r9
   1836ced1d:	49 89 f8             	mov    r8,rdi
   1836ced20:	49 89 c7             	mov    r15,rax
   1836ced23:	e8 a8 73 1c 03       	call   0x1868960d0
   1836ced28:	41 c6 04 3f 00       	mov    BYTE PTR [r15+rdi*1],0x0
   1836ced2d:	44 8b 3b             	mov    r15d,DWORD PTR [rbx]
   1836ced30:	45 89 fd             	mov    r13d,r15d
   1836ced33:	44 8b 8d 7c 02 00 00 	mov    r9d,DWORD PTR [rbp+0x27c]
   1836ced3a:	45 29 cd             	sub    r13d,r9d
   1836ced3d:	48 8b 8d 80 02 00 00 	mov    rcx,QWORD PTR [rbp+0x280]
   1836ced44:	8b 01                	mov    eax,DWORD PTR [rcx]
   1836ced46:	44 8b 41 04          	mov    r8d,DWORD PTR [rcx+0x4]
   1836ced4a:	31 d2                	xor    edx,edx
   1836ced4c:	89 c1                	mov    ecx,eax
   1836ced4e:	44 09 c1             	or     ecx,r8d
   1836ced51:	0f 84 89 01 00 00    	je     0x1836ceee0
   1836ced57:	48 8b 8d 80 02 00 00 	mov    rcx,QWORD PTR [rbp+0x280]
   1836ced5e:	48 8b 49 28          	mov    rcx,QWORD PTR [rcx+0x28]
   1836ced62:	48 8b 49 08          	mov    rcx,QWORD PTR [rcx+0x8]
   1836ced66:	48 85 c9             	test   rcx,rcx
   1836ced69:	75 0b                	jne    0x1836ced76
   1836ced6b:	48 8b 0d 46 bb 19 07 	mov    rcx,QWORD PTR [rip+0x719bb46]        # 0x18a86a8b8
   1836ced72:	48 8b 49 08          	mov    rcx,QWORD PTR [rcx+0x8]
   1836ced76:	44 8b 49 10          	mov    r9d,DWORD PTR [rcx+0x10]
   1836ced7a:	44 89 6c 24 20       	mov    DWORD PTR [rsp+0x20],r13d
   1836ced7f:	48 8d 8d 48 02 00 00 	lea    rcx,[rbp+0x248]
   1836ced86:	89 c2                	mov    edx,eax
   1836ced88:	e8 93 57 f0 fc       	call   0x1805d4520
   1836ced8d:	90                   	nop
   1836ced8e:	48 8b 85 80 02 00 00 	mov    rax,QWORD PTR [rbp+0x280]
   1836ced95:	8b 10                	mov    edx,DWORD PTR [rax]
   1836ced97:	85 d2                	test   edx,edx
   1836ced99:	0f 94 c0             	sete   al
   1836ced9c:	83 fa 92             	cmp    edx,0xffffff92
   1836ced9f:	0f 94 c1             	sete   cl
   1836ceda2:	08 c1                	or     cl,al
   1836ceda4:	44 8b 8d 7c 02 00 00 	mov    r9d,DWORD PTR [rbp+0x27c]
   1836cedab:	45 85 c9             	test   r9d,r9d
   1836cedae:	0f 95 c0             	setne  al
   1836cedb1:	20 c8                	and    al,cl
   1836cedb3:	3c 01                	cmp    al,0x1
   1836cedb5:	0f 85 25 01 00 00    	jne    0x1836ceee0
   1836cedbb:	b8 e8 03 00 00       	mov    eax,0x3e8
   1836cedc0:	44 89 e9             	mov    ecx,r13d
   1836cedc3:	d3 e0                	shl    eax,cl
   1836cedc5:	89 c1                	mov    ecx,eax
   1836cedc7:	e8 64 b8 c7 fc       	call   0x18034a630
   1836cedcc:	90                   	nop
   1836cedcd:	ff 8d 7c 02 00 00    	dec    DWORD PTR [rbp+0x27c]
   1836cedd3:	b9 02 00 00 00       	mov    ecx,0x2
   1836cedd8:	e8 63 99 99 fc       	call   0x180068740
   1836ceddd:	41 b5 01             	mov    r13b,0x1
   1836cede0:	85 c0                	test   eax,eax
   1836cede2:	0f 84 7e 02 00 00    	je     0x1836cf066
   1836cede8:	48 8d 8d 70 01 00 00 	lea    rcx,[rbp+0x170]
   1836cedef:	e8 7c 9a 99 fc       	call   0x180068870
   1836cedf4:	90                   	nop
   1836cedf5:	48 83 bd 88 01 00 00 	cmp    QWORD PTR [rbp+0x188],0x10
   1836cedfc:	10 
   1836cedfd:	4c 8d 85 70 01 00 00 	lea    r8,[rbp+0x170]
   1836cee04:	72 07                	jb     0x1836cee0d
   1836cee06:	4c 8b 85 70 01 00 00 	mov    r8,QWORD PTR [rbp+0x170]
   1836cee0d:	48 8d 05 73 14 af 04 	lea    rax,[rip+0x4af1473]        # 0x1881c0287
   1836cee14:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1836cee19:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   1836cee20:	00 00 
   1836cee22:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   1836cee27:	c7 44 24 28 50 01 00 	mov    DWORD PTR [rsp+0x28],0x150
   1836cee2e:	00 
   1836cee2f:	48 8d bd a0 01 00 00 	lea    rdi,[rbp+0x1a0]
   1836cee36:	48 89 f9             	mov    rcx,rdi
   1836cee39:	ba 02 00 00 00       	mov    edx,0x2
   1836cee3e:	4c 8d 0d e9 0f af 04 	lea    r9,[rip+0x4af0fe9]        # 0x1881bfe2e
   1836cee45:	e8 76 9d 99 fc       	call   0x180068bc0
   1836cee4a:	90                   	nop
   1836cee4b:	4c 8b 9d 80 02 00 00 	mov    r11,QWORD PTR [rbp+0x280]
   1836cee52:	41 8b 4b 04          	mov    ecx,DWORD PTR [r11+0x4]
   1836cee56:	48 c7 85 90 00 00 00 	mov    QWORD PTR [rbp+0x90],0x0
   1836cee5d:	00 00 00 00 
   1836cee61:	b8 08 00 00 00       	mov    eax,0x8
   1836cee66:	89 ca                	mov    edx,ecx
   1836cee68:	0f 1f 84 00 00 00 00 	nop    DWORD PTR [rax+rax*1+0x0]
   1836cee6f:	00 
   1836cee70:	4c 63 c2             	movsxd r8,edx
   1836cee73:	49 69 d0 67 66 66 66 	imul   rdx,r8,0x66666667
   1836cee7a:	49 89 d1             	mov    r9,rdx
   1836cee7d:	49 c1 e9 3f          	shr    r9,0x3f
   1836cee81:	48 c1 fa 22          	sar    rdx,0x22
   1836cee85:	44 01 ca             	add    edx,r9d
   1836cee88:	44 8d 0c 12          	lea    r9d,[rdx+rdx*1]
   1836cee8c:	47 8d 0c 89          	lea    r9d,[r9+r9*4]
   1836cee90:	45 89 c2             	mov    r10d,r8d
   1836cee93:	45 29 ca             	sub    r10d,r9d
   1836cee96:	4d 63 ca             	movsxd r9,r10d
   1836cee99:	47 0f b6 4c 21 23    	movzx  r9d,BYTE PTR [r9+r12*1+0x23]
   1836cee9f:	44 88 8c 05 90 00 00 	mov    BYTE PTR [rbp+rax*1+0x90],r9b
   1836ceea6:	00 
   1836ceea7:	48 ff c0             	inc    rax
   1836ceeaa:	41 83 c0 09          	add    r8d,0x9
   1836ceeae:	41 83 f8 12          	cmp    r8d,0x12
   1836ceeb2:	77 bc                	ja     0x1836cee70
   1836ceeb4:	85 c9                	test   ecx,ecx
   1836ceeb6:	0f 88 b1 01 00 00    	js     0x1836cf06d
   1836ceebc:	c6 84 05 90 00 00 00 	mov    BYTE PTR [rbp+rax*1+0x90],0x0
   1836ceec3:	00 
   1836ceec4:	48 83 f8 0a          	cmp    rax,0xa
   1836ceec8:	0f 8d b8 01 00 00    	jge    0x1836cf086
   1836ceece:	e9 e7 01 00 00       	jmp    0x1836cf0ba
   1836ceed3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
   1836ceeda:	84 00 00 00 00 00 
   1836ceee0:	40 b7 01             	mov    dil,0x1
   1836ceee3:	45 39 cf             	cmp    r15d,r9d
   1836ceee6:	74 39                	je     0x1836cef21
   1836ceee8:	48 8b 8d 80 02 00 00 	mov    rcx,QWORD PTR [rbp+0x280]
   1836ceeef:	48 8b 41 28          	mov    rax,QWORD PTR [rcx+0x28]
   1836ceef3:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
   1836ceef7:	48 85 c0             	test   rax,rax
   1836ceefa:	75 0b                	jne    0x1836cef07
   1836ceefc:	48 8b 05 b5 b9 19 07 	mov    rax,QWORD PTR [rip+0x719b9b5]        # 0x18a86a8b8
   1836cef03:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
   1836cef07:	44 8b 41 04          	mov    r8d,DWORD PTR [rcx+0x4]
   1836cef0b:	44 8b 48 10          	mov    r9d,DWORD PTR [rax+0x10]
   1836cef0f:	44 89 6c 24 20       	mov    DWORD PTR [rsp+0x20],r13d
   1836cef14:	48 8d 8d 48 02 00 00 	lea    rcx,[rbp+0x248]
   1836cef1b:	e8 00 56 f0 fc       	call   0x1805d4520
   1836cef20:	90                   	nop
   1836cef21:	45 31 ed             	xor    r13d,r13d
   1836cef24:	4c 8b bd 80 02 00 00 	mov    r15,QWORD PTR [rbp+0x280]
   1836cef2b:	48 8b 85 60 02 00 00 	mov    rax,QWORD PTR [rbp+0x260]
   1836cef32:	48 83 f8 10          	cmp    rax,0x10
   1836cef36:	72 38                	jb     0x1836cef70
   1836cef38:	48 8b 8d 48 02 00 00 	mov    rcx,QWORD PTR [rbp+0x248]
   1836cef3f:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1836cef43:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1836cef4a:	72 1f                	jb     0x1836cef6b
   1836cef4c:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1836cef50:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1836cef54:	4c 29 c1             	sub    rcx,r8
   1836cef57:	48 83 f9 20          	cmp    rcx,0x20
   1836cef5b:	0f 83 3d 03 00 00    	jae    0x1836cf29e
   1836cef61:	48 83 c0 28          	add    rax,0x28
   1836cef65:	48 89 c2             	mov    rdx,rax
   1836cef68:	4c 89 c1             	mov    rcx,r8
   1836cef6b:	e8 d0 e1 13 03       	call   0x18680d140
   1836cef70:	40 84 ff             	test   dil,dil
   1836cef73:	75 7f                	jne    0x1836ceff4
   1836cef75:	49 8b 7f 30          	mov    rdi,QWORD PTR [r15+0x30]
   1836cef79:	48 85 ff             	test   rdi,rdi
   1836cef7c:	74 22                	je     0x1836cefa0
   1836cef7e:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   1836cef82:	75 1c                	jne    0x1836cefa0
   1836cef84:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1836cef87:	48 89 f9             	mov    rcx,rdi
   1836cef8a:	ff 10                	call   QWORD PTR [rax]
   1836cef8c:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   1836cef90:	75 0e                	jne    0x1836cefa0
   1836cef92:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1836cef95:	48 89 f9             	mov    rcx,rdi
   1836cef98:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1836cef9b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]
   1836cefa0:	49 8b 47 20          	mov    rax,QWORD PTR [r15+0x20]
   1836cefa4:	48 83 f8 10          	cmp    rax,0x10
   1836cefa8:	72 35                	jb     0x1836cefdf
   1836cefaa:	49 8b 4f 08          	mov    rcx,QWORD PTR [r15+0x8]
   1836cefae:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1836cefb2:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1836cefb9:	72 1f                	jb     0x1836cefda
   1836cefbb:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1836cefbf:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1836cefc3:	4c 29 c1             	sub    rcx,r8
   1836cefc6:	48 83 f9 20          	cmp    rcx,0x20
   1836cefca:	0f 83 ce 02 00 00    	jae    0x1836cf29e
   1836cefd0:	48 83 c0 28          	add    rax,0x28
   1836cefd4:	48 89 c2             	mov    rdx,rax
   1836cefd7:	4c 89 c1             	mov    rcx,r8
   1836cefda:	e8 61 e1 13 03       	call   0x18680d140
   1836cefdf:	49 c7 47 18 00 00 00 	mov    QWORD PTR [r15+0x18],0x0
   1836cefe6:	00 
   1836cefe7:	49 c7 47 20 0f 00 00 	mov    QWORD PTR [r15+0x20],0xf
   1836cefee:	00 
   1836cefef:	41 c6 47 08 00       	mov    BYTE PTR [r15+0x8],0x0
   1836ceff4:	48 8b bd 60 01 00 00 	mov    rdi,QWORD PTR [rbp+0x160]
   1836ceffb:	48 85 ff             	test   rdi,rdi
   1836ceffe:	74 20                	je     0x1836cf020
   1836cf000:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   1836cf004:	75 1a                	jne    0x1836cf020
   1836cf006:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1836cf009:	48 89 f9             	mov    rcx,rdi
   1836cf00c:	ff 10                	call   QWORD PTR [rax]
   1836cf00e:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   1836cf012:	75 0c                	jne    0x1836cf020
   1836cf014:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1836cf017:	48 89 f9             	mov    rcx,rdi
   1836cf01a:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1836cf01d:	0f 1f 00             	nop    DWORD PTR [rax]
   1836cf020:	48 8b 85 50 01 00 00 	mov    rax,QWORD PTR [rbp+0x150]
   1836cf027:	48 83 f8 10          	cmp    rax,0x10
   1836cf02b:	4c 89 f7             	mov    rdi,r14
   1836cf02e:	0f 82 0b f8 ff ff    	jb     0x1836ce83f
   1836cf034:	48 8b 8d 38 01 00 00 	mov    rcx,QWORD PTR [rbp+0x138]
   1836cf03b:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1836cf03f:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1836cf046:	0f 82 ee f7 ff ff    	jb     0x1836ce83a
   1836cf04c:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1836cf050:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1836cf054:	4c 29 c1             	sub    rcx,r8
   1836cf057:	48 83 f9 20          	cmp    rcx,0x20
   1836cf05b:	0f 82 cf f7 ff ff    	jb     0x1836ce830
   1836cf061:	e9 38 02 00 00       	jmp    0x1836cf29e
   1836cf066:	31 ff                	xor    edi,edi
   1836cf068:	e9 b7 fe ff ff       	jmp    0x1836cef24
   1836cf06d:	c6 84 05 90 00 00 00 	mov    BYTE PTR [rbp+rax*1+0x90],0x2d
   1836cf074:	2d 
   1836cf075:	48 ff c0             	inc    rax
   1836cf078:	c6 84 05 90 00 00 00 	mov    BYTE PTR [rbp+rax*1+0x90],0x0
   1836cf07f:	00 
   1836cf080:	48 83 f8 0a          	cmp    rax,0xa
   1836cf084:	7c 34                	jl     0x1836cf0ba
   1836cf086:	48 01 e8             	add    rax,rbp
   1836cf089:	48 05 90 00 00 00    	add    rax,0x90
   1836cf08f:	48 ff c8             	dec    rax
   1836cf092:	48 8d 8d 99 00 00 00 	lea    rcx,[rbp+0x99]
   1836cf099:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
   1836cf0a0:	0f b6 10             	movzx  edx,BYTE PTR [rax]
   1836cf0a3:	44 0f b6 41 ff       	movzx  r8d,BYTE PTR [rcx-0x1]
   1836cf0a8:	44 88 00             	mov    BYTE PTR [rax],r8b
   1836cf0ab:	88 51 ff             	mov    BYTE PTR [rcx-0x1],dl
   1836cf0ae:	48 ff c8             	dec    rax
   1836cf0b1:	48 39 c1             	cmp    rcx,rax
   1836cf0b4:	48 8d 49 01          	lea    rcx,[rcx+0x1]
   1836cf0b8:	72 e6                	jb     0x1836cf0a0
   1836cf0ba:	48 8d 85 98 00 00 00 	lea    rax,[rbp+0x98]
   1836cf0c1:	48 89 85 90 00 00 00 	mov    QWORD PTR [rbp+0x90],rax
   1836cf0c8:	41 8b 0b             	mov    ecx,DWORD PTR [r11]
   1836cf0cb:	48 c7 85 e0 00 00 00 	mov    QWORD PTR [rbp+0xe0],0x0
   1836cf0d2:	00 00 00 00 
   1836cf0d6:	b8 08 00 00 00       	mov    eax,0x8
   1836cf0db:	89 ca                	mov    edx,ecx
   1836cf0dd:	0f 1f 00             	nop    DWORD PTR [rax]
   1836cf0e0:	4c 63 c2             	movsxd r8,edx
   1836cf0e3:	49 69 d0 67 66 66 66 	imul   rdx,r8,0x66666667
   1836cf0ea:	49 89 d1             	mov    r9,rdx
   1836cf0ed:	49 c1 e9 3f          	shr    r9,0x3f
   1836cf0f1:	48 c1 fa 22          	sar    rdx,0x22
   1836cf0f5:	44 01 ca             	add    edx,r9d
   1836cf0f8:	44 8d 0c 12          	lea    r9d,[rdx+rdx*1]
   1836cf0fc:	47 8d 0c 89          	lea    r9d,[r9+r9*4]
   1836cf100:	45 89 c2             	mov    r10d,r8d
   1836cf103:	45 29 ca             	sub    r10d,r9d
   1836cf106:	4d 63 ca             	movsxd r9,r10d
   1836cf109:	47 0f b6 4c 21 23    	movzx  r9d,BYTE PTR [r9+r12*1+0x23]
   1836cf10f:	44 88 8c 05 e0 00 00 	mov    BYTE PTR [rbp+rax*1+0xe0],r9b
   1836cf116:	00 
   1836cf117:	48 ff c0             	inc    rax
   1836cf11a:	41 83 c0 09          	add    r8d,0x9
   1836cf11e:	41 83 f8 12          	cmp    r8d,0x12
   1836cf122:	77 bc                	ja     0x1836cf0e0
   1836cf124:	85 c9                	test   ecx,ecx
   1836cf126:	78 10                	js     0x1836cf138
   1836cf128:	c6 84 05 e0 00 00 00 	mov    BYTE PTR [rbp+rax*1+0xe0],0x0
   1836cf12f:	00 
   1836cf130:	48 83 f8 0a          	cmp    rax,0xa
   1836cf134:	7d 1b                	jge    0x1836cf151
   1836cf136:	eb 52                	jmp    0x1836cf18a
   1836cf138:	c6 84 05 e0 00 00 00 	mov    BYTE PTR [rbp+rax*1+0xe0],0x2d
   1836cf13f:	2d 
   1836cf140:	48 ff c0             	inc    rax
   1836cf143:	c6 84 05 e0 00 00 00 	mov    BYTE PTR [rbp+rax*1+0xe0],0x0
   1836cf14a:	00 
   1836cf14b:	48 83 f8 0a          	cmp    rax,0xa
   1836cf14f:	7c 39                	jl     0x1836cf18a
   1836cf151:	48 01 e8             	add    rax,rbp
   1836cf154:	48 05 e0 00 00 00    	add    rax,0xe0
   1836cf15a:	48 ff c8             	dec    rax
   1836cf15d:	48 8d 8d e9 00 00 00 	lea    rcx,[rbp+0xe9]
   1836cf164:	66 66 66 2e 0f 1f 84 	data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
   1836cf16b:	00 00 00 00 00 
   1836cf170:	0f b6 10             	movzx  edx,BYTE PTR [rax]
   1836cf173:	44 0f b6 41 ff       	movzx  r8d,BYTE PTR [rcx-0x1]
   1836cf178:	44 88 00             	mov    BYTE PTR [rax],r8b
   1836cf17b:	88 51 ff             	mov    BYTE PTR [rcx-0x1],dl
   1836cf17e:	48 ff c8             	dec    rax
   1836cf181:	48 39 c1             	cmp    rcx,rax
   1836cf184:	48 8d 49 01          	lea    rcx,[rcx+0x1]
   1836cf188:	72 e6                	jb     0x1836cf170
   1836cf18a:	48 8d 85 e8 00 00 00 	lea    rax,[rbp+0xe8]
   1836cf191:	48 89 85 e0 00 00 00 	mov    QWORD PTR [rbp+0xe0],rax
   1836cf198:	48 83 bd 60 02 00 00 	cmp    QWORD PTR [rbp+0x260],0x10
   1836cf19f:	10 
   1836cf1a0:	48 8d 85 48 02 00 00 	lea    rax,[rbp+0x248]
   1836cf1a7:	72 07                	jb     0x1836cf1b0
   1836cf1a9:	48 8b 85 48 02 00 00 	mov    rax,QWORD PTR [rbp+0x248]
   1836cf1b0:	48 89 45 c0          	mov    QWORD PTR [rbp-0x40],rax
   1836cf1b4:	c6 45 c8 00          	mov    BYTE PTR [rbp-0x38],0x0
   1836cf1b8:	48 8d 45 20          	lea    rax,[rbp+0x20]
   1836cf1bc:	0f 29 78 60          	movaps XMMWORD PTR [rax+0x60],xmm7
   1836cf1c0:	0f 29 78 50          	movaps XMMWORD PTR [rax+0x50],xmm7
   1836cf1c4:	0f 29 78 40          	movaps XMMWORD PTR [rax+0x40],xmm7
   1836cf1c8:	0f 29 78 30          	movaps XMMWORD PTR [rax+0x30],xmm7
   1836cf1cc:	0f 29 78 20          	movaps XMMWORD PTR [rax+0x20],xmm7
   1836cf1d0:	0f 29 78 10          	movaps XMMWORD PTR [rax+0x10],xmm7
   1836cf1d4:	0f 29 38             	movaps XMMWORD PTR [rax],xmm7
   1836cf1d7:	48 8d 45 c0          	lea    rax,[rbp-0x40]
   1836cf1db:	48 89 45 10          	mov    QWORD PTR [rbp+0x10],rax
   1836cf1df:	48 8d 85 e0 00 00 00 	lea    rax,[rbp+0xe0]
   1836cf1e6:	48 89 45 18          	mov    QWORD PTR [rbp+0x18],rax
   1836cf1ea:	48 8d 85 90 00 00 00 	lea    rax,[rbp+0x90]
   1836cf1f1:	48 89 45 20          	mov    QWORD PTR [rbp+0x20],rax
   1836cf1f5:	48 89 f9             	mov    rcx,rdi
   1836cf1f8:	48 8d 15 d8 10 af 04 	lea    rdx,[rip+0x4af10d8]        # 0x1881c02d7
   1836cf1ff:	4c 8d 45 10          	lea    r8,[rbp+0x10]
   1836cf203:	e8 58 9f 99 fc       	call   0x180069160
   1836cf208:	90                   	nop
   1836cf209:	48 89 f9             	mov    rcx,rdi
   1836cf20c:	e8 af 9a 99 fc       	call   0x180068cc0
   1836cf211:	48 8b 85 88 01 00 00 	mov    rax,QWORD PTR [rbp+0x188]
   1836cf218:	48 83 f8 10          	cmp    rax,0x10
   1836cf21c:	4c 8b bd 80 02 00 00 	mov    r15,QWORD PTR [rbp+0x280]
   1836cf223:	72 34                	jb     0x1836cf259
   1836cf225:	48 8b 8d 70 01 00 00 	mov    rcx,QWORD PTR [rbp+0x170]
   1836cf22c:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1836cf230:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1836cf237:	72 1b                	jb     0x1836cf254
   1836cf239:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1836cf23d:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1836cf241:	4c 29 c1             	sub    rcx,r8
   1836cf244:	48 83 f9 20          	cmp    rcx,0x20
   1836cf248:	73 54                	jae    0x1836cf29e
   1836cf24a:	48 83 c0 28          	add    rax,0x28
   1836cf24e:	48 89 c2             	mov    rdx,rax
   1836cf251:	4c 89 c1             	mov    rcx,r8
   1836cf254:	e8 e7 de 13 03       	call   0x18680d140
   1836cf259:	31 ff                	xor    edi,edi
   1836cf25b:	48 8b 85 60 02 00 00 	mov    rax,QWORD PTR [rbp+0x260]
   1836cf262:	48 83 f8 10          	cmp    rax,0x10
   1836cf266:	0f 83 cc fc ff ff    	jae    0x1836cef38
   1836cf26c:	e9 ff fc ff ff       	jmp    0x1836cef70
   1836cf271:	4c 89 f8             	mov    rax,r15
   1836cf274:	0f 28 b5 90 02 00 00 	movaps xmm6,XMMWORD PTR [rbp+0x290]
   1836cf27b:	0f 28 bd a0 02 00 00 	movaps xmm7,XMMWORD PTR [rbp+0x2a0]
   1836cf282:	44 0f 28 85 b0 02 00 	movaps xmm8,XMMWORD PTR [rbp+0x2b0]
   1836cf289:	00 
   1836cf28a:	48 81 c4 48 03 00 00 	add    rsp,0x348
   1836cf291:	5b                   	pop    rbx
   1836cf292:	5f                   	pop    rdi
   1836cf293:	5e                   	pop    rsi
   1836cf294:	41 5c                	pop    r12
   1836cf296:	41 5d                	pop    r13
   1836cf298:	41 5e                	pop    r14
   1836cf29a:	41 5f                	pop    r15
   1836cf29c:	5d                   	pop    rbp
   1836cf29d:	c3                   	ret
   1836cf29e:	e8 d5 11 19 03       	call   0x186860478
   1836cf2a3:	90                   	nop
   1836cf2a4:	e8 b7 96 93 fc       	call   0x180008960
   1836cf2a9:	90                   	nop
   1836cf2aa:	e8 b1 96 93 fc       	call   0x180008960
   1836cf2af:	90                   	nop
   1836cf2b0:	cc                   	int3
