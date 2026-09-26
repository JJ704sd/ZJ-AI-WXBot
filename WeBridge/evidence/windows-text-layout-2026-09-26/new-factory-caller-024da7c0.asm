
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

00000001824da7c0 <.text+0x24d97c0>:
   1824da7c0:	55                   	push   rbp
   1824da7c1:	41 57                	push   r15
   1824da7c3:	41 56                	push   r14
   1824da7c5:	41 55                	push   r13
   1824da7c7:	41 54                	push   r12
   1824da7c9:	56                   	push   rsi
   1824da7ca:	57                   	push   rdi
   1824da7cb:	53                   	push   rbx
   1824da7cc:	48 81 ec 48 02 00 00 	sub    rsp,0x248
   1824da7d3:	48 8d ac 24 80 00 00 	lea    rbp,[rsp+0x80]
   1824da7da:	00 
   1824da7db:	0f 29 b5 b0 01 00 00 	movaps XMMWORD PTR [rbp+0x1b0],xmm6
   1824da7e2:	48 c7 85 a8 01 00 00 	mov    QWORD PTR [rbp+0x1a8],0xfffffffffffffffe
   1824da7e9:	fe ff ff ff 
   1824da7ed:	4c 89 ce             	mov    rsi,r9
   1824da7f0:	4c 89 c7             	mov    rdi,r8
   1824da7f3:	49 89 d7             	mov    r15,rdx
   1824da7f6:	0f 28 35 b3 b3 86 06 	movaps xmm6,XMMWORD PTR [rip+0x686b3b3]        # 0x188d45bb0
   1824da7fd:	0f 29 b5 80 01 00 00 	movaps XMMWORD PTR [rbp+0x180],xmm6
   1824da804:	48 8d 8d 80 01 00 00 	lea    rcx,[rbp+0x180]
   1824da80b:	e8 60 a4 21 fe       	call   0x1806f4c70
   1824da810:	48 8b 85 80 01 00 00 	mov    rax,QWORD PTR [rbp+0x180]
   1824da817:	48 b9 31 00 00 00 01 	movabs rcx,0x100000031
   1824da81e:	00 00 00 
   1824da821:	48 89 88 18 01 00 00 	mov    QWORD PTR [rax+0x118],rcx
   1824da828:	0f 29 b5 30 01 00 00 	movaps XMMWORD PTR [rbp+0x130],xmm6
   1824da82f:	48 8d 8d 58 01 00 00 	lea    rcx,[rbp+0x158]
   1824da836:	e8 e5 c9 b6 fd       	call   0x180047220
   1824da83b:	90                   	nop
   1824da83c:	48 8b 8d 58 01 00 00 	mov    rcx,QWORD PTR [rbp+0x158]
   1824da843:	48 8d 95 90 00 00 00 	lea    rdx,[rbp+0x90]
   1824da84a:	e8 f1 1e e9 fd       	call   0x18036c740
   1824da84f:	90                   	nop
   1824da850:	48 8b 8d 90 00 00 00 	mov    rcx,QWORD PTR [rbp+0x90]
   1824da857:	48 89 ea             	mov    rdx,rbp
   1824da85a:	e8 31 a5 21 fe       	call   0x1806f4d90
   1824da85f:	90                   	nop
   1824da860:	48 8b 4d 00          	mov    rcx,QWORD PTR [rbp+0x0]
   1824da864:	0f 57 c0             	xorps  xmm0,xmm0
   1824da867:	0f 29 85 90 01 00 00 	movaps XMMWORD PTR [rbp+0x190],xmm0
   1824da86e:	48 8b 85 88 01 00 00 	mov    rax,QWORD PTR [rbp+0x188]
   1824da875:	48 85 c0             	test   rax,rax
   1824da878:	74 0d                	je     0x1824da887
   1824da87a:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   1824da87e:	48 8b 85 88 01 00 00 	mov    rax,QWORD PTR [rbp+0x188]
   1824da885:	eb 02                	jmp    0x1824da889
   1824da887:	31 c0                	xor    eax,eax
   1824da889:	48 8b 95 80 01 00 00 	mov    rdx,QWORD PTR [rbp+0x180]
   1824da890:	48 89 95 90 01 00 00 	mov    QWORD PTR [rbp+0x190],rdx
   1824da897:	48 89 85 98 01 00 00 	mov    QWORD PTR [rbp+0x198],rax
   1824da89e:	48 8d 95 30 01 00 00 	lea    rdx,[rbp+0x130]
   1824da8a5:	4c 8d 85 90 01 00 00 	lea    r8,[rbp+0x190]
   1824da8ac:	e8 1f 8b 2d ff       	call   0x1817b33d0
   1824da8b1:	90                   	nop
   1824da8b2:	48 8b 9d 98 01 00 00 	mov    rbx,QWORD PTR [rbp+0x198]
   1824da8b9:	48 85 db             	test   rbx,rbx
   1824da8bc:	74 1d                	je     0x1824da8db
   1824da8be:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   1824da8c2:	75 17                	jne    0x1824da8db
   1824da8c4:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1824da8c7:	48 89 d9             	mov    rcx,rbx
   1824da8ca:	ff 10                	call   QWORD PTR [rax]
   1824da8cc:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   1824da8d0:	75 09                	jne    0x1824da8db
   1824da8d2:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1824da8d5:	48 89 d9             	mov    rcx,rbx
   1824da8d8:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1824da8db:	48 8b 5d 08          	mov    rbx,QWORD PTR [rbp+0x8]
   1824da8df:	48 85 db             	test   rbx,rbx
   1824da8e2:	74 1d                	je     0x1824da901
   1824da8e4:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   1824da8e8:	75 17                	jne    0x1824da901
   1824da8ea:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1824da8ed:	48 89 d9             	mov    rcx,rbx
   1824da8f0:	ff 10                	call   QWORD PTR [rax]
   1824da8f2:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   1824da8f6:	75 09                	jne    0x1824da901
   1824da8f8:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1824da8fb:	48 89 d9             	mov    rcx,rbx
   1824da8fe:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1824da901:	48 8b 9d 98 00 00 00 	mov    rbx,QWORD PTR [rbp+0x98]
   1824da908:	48 85 db             	test   rbx,rbx
   1824da90b:	74 1d                	je     0x1824da92a
   1824da90d:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   1824da911:	75 17                	jne    0x1824da92a
   1824da913:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1824da916:	48 89 d9             	mov    rcx,rbx
   1824da919:	ff 10                	call   QWORD PTR [rax]
   1824da91b:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   1824da91f:	75 09                	jne    0x1824da92a
   1824da921:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1824da924:	48 89 d9             	mov    rcx,rbx
   1824da927:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1824da92a:	48 8b 9d 60 01 00 00 	mov    rbx,QWORD PTR [rbp+0x160]
   1824da931:	48 85 db             	test   rbx,rbx
   1824da934:	74 1d                	je     0x1824da953
   1824da936:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   1824da93a:	75 17                	jne    0x1824da953
   1824da93c:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1824da93f:	48 89 d9             	mov    rcx,rbx
   1824da942:	ff 10                	call   QWORD PTR [rax]
   1824da944:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   1824da948:	75 09                	jne    0x1824da953
   1824da94a:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1824da94d:	48 89 d9             	mov    rcx,rbx
   1824da950:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1824da953:	48 83 bd 30 01 00 00 	cmp    QWORD PTR [rbp+0x130],0x0
   1824da95a:	00 
   1824da95b:	74 51                	je     0x1824da9ae
   1824da95d:	0f 29 b5 90 01 00 00 	movaps XMMWORD PTR [rbp+0x190],xmm6
   1824da964:	b9 00 01 00 00       	mov    ecx,0x100
   1824da969:	e8 2e 0f fd 04       	call   0x1874ab89c
   1824da96e:	90                   	nop
   1824da96f:	48 b9 01 00 00 00 01 	movabs rcx,0x100000001
   1824da976:	00 00 00 
   1824da979:	48 89 48 08          	mov    QWORD PTR [rax+0x8],rcx
   1824da97d:	48 8d 0d 04 d7 bf 06 	lea    rcx,[rip+0x6bfd704]        # 0x1890d8088
   1824da984:	48 89 08             	mov    QWORD PTR [rax],rcx
   1824da987:	0f 57 c0             	xorps  xmm0,xmm0
   1824da98a:	0f 29 45 00          	movaps XMMWORD PTR [rbp+0x0],xmm0
   1824da98e:	48 8b 8d 88 01 00 00 	mov    rcx,QWORD PTR [rbp+0x188]
   1824da995:	48 85 c9             	test   rcx,rcx
   1824da998:	0f 84 28 01 00 00    	je     0x1824daac6
   1824da99e:	f0 ff 41 08          	lock inc DWORD PTR [rcx+0x8]
   1824da9a2:	48 8b 95 88 01 00 00 	mov    rdx,QWORD PTR [rbp+0x188]
   1824da9a9:	e9 1a 01 00 00       	jmp    0x1824daac8
   1824da9ae:	b9 04 00 00 00       	mov    ecx,0x4
   1824da9b3:	e8 28 24 b9 fd       	call   0x18006cde0
   1824da9b8:	85 c0                	test   eax,eax
   1824da9ba:	0f 84 fa 00 00 00    	je     0x1824daaba
   1824da9c0:	48 8d b5 58 01 00 00 	lea    rsi,[rbp+0x158]
   1824da9c7:	48 89 f1             	mov    rcx,rsi
   1824da9ca:	e8 41 25 b9 fd       	call   0x18006cf10
   1824da9cf:	90                   	nop
   1824da9d0:	48 83 bd 70 01 00 00 	cmp    QWORD PTR [rbp+0x170],0x10
   1824da9d7:	10 
   1824da9d8:	72 07                	jb     0x1824da9e1
   1824da9da:	48 8b b5 58 01 00 00 	mov    rsi,QWORD PTR [rbp+0x158]
   1824da9e1:	48 8d 05 c0 6c da 06 	lea    rax,[rip+0x6da6cc0]        # 0x1892816a8
   1824da9e8:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1824da9ed:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   1824da9f4:	00 00 
   1824da9f6:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   1824da9fb:	c7 44 24 28 a2 01 00 	mov    DWORD PTR [rsp+0x28],0x1a2
   1824daa02:	00 
   1824daa03:	4c 8d 0d 16 6c da 06 	lea    r9,[rip+0x6da6c16]        # 0x189281620
   1824daa0a:	48 89 e9             	mov    rcx,rbp
   1824daa0d:	ba 04 00 00 00       	mov    edx,0x4
   1824daa12:	49 89 f0             	mov    r8,rsi
   1824daa15:	e8 56 28 b9 fd       	call   0x18006d270
   1824daa1a:	90                   	nop
   1824daa1b:	0f 57 c0             	xorps  xmm0,xmm0
   1824daa1e:	0f 29 85 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm0
   1824daa25:	0f 29 85 f0 00 00 00 	movaps XMMWORD PTR [rbp+0xf0],xmm0
   1824daa2c:	0f 29 85 e0 00 00 00 	movaps XMMWORD PTR [rbp+0xe0],xmm0
   1824daa33:	0f 29 85 d0 00 00 00 	movaps XMMWORD PTR [rbp+0xd0],xmm0
   1824daa3a:	0f 29 85 c0 00 00 00 	movaps XMMWORD PTR [rbp+0xc0],xmm0
   1824daa41:	0f 29 85 b0 00 00 00 	movaps XMMWORD PTR [rbp+0xb0],xmm0
   1824daa48:	0f 29 85 a0 00 00 00 	movaps XMMWORD PTR [rbp+0xa0],xmm0
   1824daa4f:	0f 29 85 90 00 00 00 	movaps XMMWORD PTR [rbp+0x90],xmm0
   1824daa56:	48 8d 15 93 71 da 06 	lea    rdx,[rip+0x6da7193]        # 0x189281bf0
   1824daa5d:	48 89 e9             	mov    rcx,rbp
   1824daa60:	4c 8d 85 90 00 00 00 	lea    r8,[rbp+0x90]
   1824daa67:	e8 a4 2d b9 fd       	call   0x18006d810
   1824daa6c:	90                   	nop
   1824daa6d:	48 89 e9             	mov    rcx,rbp
   1824daa70:	e8 fb 28 b9 fd       	call   0x18006d370
   1824daa75:	48 8b 85 70 01 00 00 	mov    rax,QWORD PTR [rbp+0x170]
   1824daa7c:	48 83 f8 10          	cmp    rax,0x10
   1824daa80:	72 38                	jb     0x1824daaba
   1824daa82:	48 8b 8d 58 01 00 00 	mov    rcx,QWORD PTR [rbp+0x158]
   1824daa89:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1824daa8d:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1824daa94:	72 1f                	jb     0x1824daab5
   1824daa96:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1824daa9a:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1824daa9e:	4c 29 c1             	sub    rcx,r8
   1824daaa1:	48 83 f9 20          	cmp    rcx,0x20
   1824daaa5:	0f 83 d5 04 00 00    	jae    0x1824daf80
   1824daaab:	48 83 c0 28          	add    rax,0x28
   1824daaaf:	48 89 c2             	mov    rdx,rax
   1824daab2:	4c 89 c1             	mov    rcx,r8
   1824daab5:	e8 26 0e fd 04       	call   0x1874ab8e0
   1824daaba:	0f 57 c0             	xorps  xmm0,xmm0
   1824daabd:	41 0f 11 07          	movups XMMWORD PTR [r15],xmm0
   1824daac1:	e9 4a 04 00 00       	jmp    0x1824daf10
   1824daac6:	31 d2                	xor    edx,edx
   1824daac8:	48 8d 58 10          	lea    rbx,[rax+0x10]
   1824daacc:	48 8b 8d 80 01 00 00 	mov    rcx,QWORD PTR [rbp+0x180]
   1824daad3:	48 89 4d 00          	mov    QWORD PTR [rbp+0x0],rcx
   1824daad7:	48 89 55 08          	mov    QWORD PTR [rbp+0x8],rdx
   1824daadb:	48 89 85 28 01 00 00 	mov    QWORD PTR [rbp+0x128],rax
   1824daae2:	48 89 ea             	mov    rdx,rbp
   1824daae5:	48 89 d9             	mov    rcx,rbx
   1824daae8:	41 b0 01             	mov    r8b,0x1
   1824daaeb:	e8 40 6f 4a 01       	call   0x183981a30
   1824daaf0:	90                   	nop
   1824daaf1:	48 89 9d 90 01 00 00 	mov    QWORD PTR [rbp+0x190],rbx
   1824daaf8:	48 8b 85 28 01 00 00 	mov    rax,QWORD PTR [rbp+0x128]
   1824daaff:	48 89 85 98 01 00 00 	mov    QWORD PTR [rbp+0x198],rax
   1824dab06:	48 8b 8d 30 01 00 00 	mov    rcx,QWORD PTR [rbp+0x130]
   1824dab0d:	0f 57 c0             	xorps  xmm0,xmm0
   1824dab10:	0f 29 85 10 01 00 00 	movaps XMMWORD PTR [rbp+0x110],xmm0
   1824dab17:	48 85 c0             	test   rax,rax
   1824dab1a:	74 14                	je     0x1824dab30
   1824dab1c:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   1824dab20:	48 8b 9d 90 01 00 00 	mov    rbx,QWORD PTR [rbp+0x190]
   1824dab27:	48 8b 85 98 01 00 00 	mov    rax,QWORD PTR [rbp+0x198]
   1824dab2e:	eb 02                	jmp    0x1824dab32
   1824dab30:	31 c0                	xor    eax,eax
   1824dab32:	48 89 9d 10 01 00 00 	mov    QWORD PTR [rbp+0x110],rbx
   1824dab39:	48 89 85 18 01 00 00 	mov    QWORD PTR [rbp+0x118],rax
   1824dab40:	48 8d 55 c8          	lea    rdx,[rbp-0x38]
   1824dab44:	4c 8d 85 10 01 00 00 	lea    r8,[rbp+0x110]
   1824dab4b:	e8 40 73 49 01       	call   0x183971e90
   1824dab50:	90                   	nop
   1824dab51:	48 8b 5d f8          	mov    rbx,QWORD PTR [rbp-0x8]
   1824dab55:	48 85 db             	test   rbx,rbx
   1824dab58:	74 1d                	je     0x1824dab77
   1824dab5a:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   1824dab5e:	75 17                	jne    0x1824dab77
   1824dab60:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1824dab63:	48 89 d9             	mov    rcx,rbx
   1824dab66:	ff 10                	call   QWORD PTR [rax]
   1824dab68:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   1824dab6c:	75 09                	jne    0x1824dab77
   1824dab6e:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1824dab71:	48 89 d9             	mov    rcx,rbx
   1824dab74:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1824dab77:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
   1824dab7b:	48 83 f8 10          	cmp    rax,0x10
   1824dab7f:	72 35                	jb     0x1824dabb6
   1824dab81:	48 8b 4d d0          	mov    rcx,QWORD PTR [rbp-0x30]
   1824dab85:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1824dab89:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1824dab90:	72 1f                	jb     0x1824dabb1
   1824dab92:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1824dab96:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1824dab9a:	4c 29 c1             	sub    rcx,r8
   1824dab9d:	48 83 f9 20          	cmp    rcx,0x20
   1824daba1:	0f 83 d9 03 00 00    	jae    0x1824daf80
   1824daba7:	48 83 c0 28          	add    rax,0x28
   1824dabab:	48 89 c2             	mov    rdx,rax
   1824dabae:	4c 89 c1             	mov    rcx,r8
   1824dabb1:	e8 2a 0d fd 04       	call   0x1874ab8e0
   1824dabb6:	41 0f 11 37          	movups XMMWORD PTR [r15],xmm6
   1824dabba:	48 8b 85 90 01 00 00 	mov    rax,QWORD PTR [rbp+0x190]
   1824dabc1:	48 8b 48 20          	mov    rcx,QWORD PTR [rax+0x20]
   1824dabc5:	48 85 c9             	test   rcx,rcx
   1824dabc8:	74 0a                	je     0x1824dabd4
   1824dabca:	f0 ff 41 08          	lock inc DWORD PTR [rcx+0x8]
   1824dabce:	48 8b 48 20          	mov    rcx,QWORD PTR [rax+0x20]
   1824dabd2:	eb 02                	jmp    0x1824dabd6
   1824dabd4:	31 c9                	xor    ecx,ecx
   1824dabd6:	48 8b 58 18          	mov    rbx,QWORD PTR [rax+0x18]
   1824dabda:	49 89 1f             	mov    QWORD PTR [r15],rbx
   1824dabdd:	49 89 4f 08          	mov    QWORD PTR [r15+0x8],rcx
   1824dabe1:	0f 29 b5 40 01 00 00 	movaps XMMWORD PTR [rbp+0x140],xmm6
   1824dabe8:	48 8b 8b 88 02 00 00 	mov    rcx,QWORD PTR [rbx+0x288]
   1824dabef:	c7 44 24 20 00 00 00 	mov    DWORD PTR [rsp+0x20],0x0
   1824dabf6:	00 
   1824dabf7:	4c 8d 05 82 e0 bd 08 	lea    r8,[rip+0x8bde082]        # 0x18b0b8c80
   1824dabfe:	4c 8d 0d ab e0 bd 08 	lea    r9,[rip+0x8bde0ab]        # 0x18b0b8cb0
   1824dac05:	31 d2                	xor    edx,edx
   1824dac07:	e8 e0 8d 01 05       	call   0x1874f39ec
   1824dac0c:	90                   	nop
   1824dac0d:	49 89 c6             	mov    r14,rax
   1824dac10:	48 85 c0             	test   rax,rax
   1824dac13:	74 31                	je     0x1824dac46
   1824dac15:	4c 8b 8d 30 02 00 00 	mov    r9,QWORD PTR [rbp+0x230]
   1824dac1c:	4d 89 f5             	mov    r13,r14
   1824dac1f:	48 8b 83 90 02 00 00 	mov    rax,QWORD PTR [rbx+0x290]
   1824dac26:	48 85 c0             	test   rax,rax
   1824dac29:	4c 89 bd 78 01 00 00 	mov    QWORD PTR [rbp+0x178],r15
   1824dac30:	0f 84 49 01 00 00    	je     0x1824dad7f
   1824dac36:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   1824dac3a:	48 8b 9b 90 02 00 00 	mov    rbx,QWORD PTR [rbx+0x290]
   1824dac41:	e9 3b 01 00 00       	jmp    0x1824dad81
   1824dac46:	0f 57 c0             	xorps  xmm0,xmm0
   1824dac49:	0f 29 85 40 01 00 00 	movaps XMMWORD PTR [rbp+0x140],xmm0
   1824dac50:	b9 04 00 00 00       	mov    ecx,0x4
   1824dac55:	e8 86 21 b9 fd       	call   0x18006cde0
   1824dac5a:	85 c0                	test   eax,eax
   1824dac5c:	0f 84 85 02 00 00    	je     0x1824daee7
   1824dac62:	4c 89 bd 78 01 00 00 	mov    QWORD PTR [rbp+0x178],r15
   1824dac69:	48 8d b5 58 01 00 00 	lea    rsi,[rbp+0x158]
   1824dac70:	48 89 f1             	mov    rcx,rsi
   1824dac73:	e8 98 22 b9 fd       	call   0x18006cf10
   1824dac78:	90                   	nop
   1824dac79:	48 83 bd 70 01 00 00 	cmp    QWORD PTR [rbp+0x170],0x10
   1824dac80:	10 
   1824dac81:	72 07                	jb     0x1824dac8a
   1824dac83:	48 8b b5 58 01 00 00 	mov    rsi,QWORD PTR [rbp+0x158]
   1824dac8a:	48 8d 05 17 6a da 06 	lea    rax,[rip+0x6da6a17]        # 0x1892816a8
   1824dac91:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1824dac96:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   1824dac9d:	00 00 
   1824dac9f:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   1824daca4:	c7 44 24 28 aa 01 00 	mov    DWORD PTR [rsp+0x28],0x1aa
   1824dacab:	00 
   1824dacac:	4c 8d 0d 6d 69 da 06 	lea    r9,[rip+0x6da696d]        # 0x189281620
   1824dacb3:	48 89 e9             	mov    rcx,rbp
   1824dacb6:	ba 04 00 00 00       	mov    edx,0x4
   1824dacbb:	49 89 f0             	mov    r8,rsi
   1824dacbe:	e8 ad 25 b9 fd       	call   0x18006d270
   1824dacc3:	90                   	nop
   1824dacc4:	0f 57 c0             	xorps  xmm0,xmm0
   1824dacc7:	0f 29 85 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm0
   1824dacce:	0f 29 85 f0 00 00 00 	movaps XMMWORD PTR [rbp+0xf0],xmm0
   1824dacd5:	0f 29 85 e0 00 00 00 	movaps XMMWORD PTR [rbp+0xe0],xmm0
   1824dacdc:	0f 29 85 d0 00 00 00 	movaps XMMWORD PTR [rbp+0xd0],xmm0
   1824dace3:	0f 29 85 c0 00 00 00 	movaps XMMWORD PTR [rbp+0xc0],xmm0
   1824dacea:	0f 29 85 b0 00 00 00 	movaps XMMWORD PTR [rbp+0xb0],xmm0
   1824dacf1:	0f 29 85 a0 00 00 00 	movaps XMMWORD PTR [rbp+0xa0],xmm0
   1824dacf8:	0f 29 85 90 00 00 00 	movaps XMMWORD PTR [rbp+0x90],xmm0
   1824dacff:	48 8d 15 5a 6a da 06 	lea    rdx,[rip+0x6da6a5a]        # 0x189281760
   1824dad06:	48 89 e9             	mov    rcx,rbp
   1824dad09:	4c 8d 85 90 00 00 00 	lea    r8,[rbp+0x90]
   1824dad10:	e8 fb 2a b9 fd       	call   0x18006d810
   1824dad15:	90                   	nop
   1824dad16:	48 89 e9             	mov    rcx,rbp
   1824dad19:	e8 52 26 b9 fd       	call   0x18006d370
   1824dad1e:	48 8b 85 70 01 00 00 	mov    rax,QWORD PTR [rbp+0x170]
   1824dad25:	48 83 f8 10          	cmp    rax,0x10
   1824dad29:	72 38                	jb     0x1824dad63
   1824dad2b:	48 8b 8d 58 01 00 00 	mov    rcx,QWORD PTR [rbp+0x158]
   1824dad32:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1824dad36:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1824dad3d:	72 1f                	jb     0x1824dad5e
   1824dad3f:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1824dad43:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1824dad47:	4c 29 c1             	sub    rcx,r8
   1824dad4a:	48 83 f9 20          	cmp    rcx,0x20
   1824dad4e:	0f 83 2c 02 00 00    	jae    0x1824daf80
   1824dad54:	48 83 c0 28          	add    rax,0x28
   1824dad58:	48 89 c2             	mov    rdx,rax
   1824dad5b:	4c 89 c1             	mov    rcx,r8
   1824dad5e:	e8 7d 0b fd 04       	call   0x1874ab8e0
   1824dad63:	48 8b 9d 48 01 00 00 	mov    rbx,QWORD PTR [rbp+0x148]
   1824dad6a:	48 85 db             	test   rbx,rbx
   1824dad6d:	4c 8b bd 78 01 00 00 	mov    r15,QWORD PTR [rbp+0x178]
   1824dad74:	0f 85 1f 01 00 00    	jne    0x1824dae99
   1824dad7a:	e9 68 01 00 00       	jmp    0x1824daee7
   1824dad7f:	31 db                	xor    ebx,ebx
   1824dad81:	4c 89 ad 40 01 00 00 	mov    QWORD PTR [rbp+0x140],r13
   1824dad88:	48 89 9d 48 01 00 00 	mov    QWORD PTR [rbp+0x148],rbx
   1824dad8f:	4d 8d be 60 02 00 00 	lea    r15,[r14+0x260]
   1824dad96:	4d 39 cf             	cmp    r15,r9
   1824dad99:	74 26                	je     0x1824dadc1
   1824dad9b:	4d 8b 61 10          	mov    r12,QWORD PTR [r9+0x10]
   1824dad9f:	49 83 79 18 10       	cmp    QWORD PTR [r9+0x18],0x10
   1824dada4:	72 03                	jb     0x1824dada9
   1824dada6:	4d 8b 09             	mov    r9,QWORD PTR [r9]
   1824dada9:	49 8b 85 78 02 00 00 	mov    rax,QWORD PTR [r13+0x278]
   1824dadb0:	49 39 c4             	cmp    r12,rax
   1824dadb3:	76 1a                	jbe    0x1824dadcf
   1824dadb5:	4c 89 f9             	mov    rcx,r15
   1824dadb8:	4c 89 e2             	mov    rdx,r12
   1824dadbb:	e8 90 33 b6 fd       	call   0x18003e150
   1824dadc0:	90                   	nop
   1824dadc1:	4d 8d be 48 03 00 00 	lea    r15,[r14+0x348]
   1824dadc8:	49 39 ff             	cmp    r15,rdi
   1824dadcb:	75 31                	jne    0x1824dadfe
   1824dadcd:	eb 58                	jmp    0x1824dae27
   1824dadcf:	48 83 f8 10          	cmp    rax,0x10
   1824dadd3:	72 03                	jb     0x1824dadd8
   1824dadd5:	4d 8b 3f             	mov    r15,QWORD PTR [r15]
   1824dadd8:	4d 89 a5 70 02 00 00 	mov    QWORD PTR [r13+0x270],r12
   1824daddf:	4c 89 f9             	mov    rcx,r15
   1824dade2:	4c 89 ca             	mov    rdx,r9
   1824dade5:	4d 89 e0             	mov    r8,r12
   1824dade8:	e8 63 92 06 05       	call   0x187544050
   1824daded:	43 c6 04 27 00       	mov    BYTE PTR [r15+r12*1],0x0
   1824dadf2:	4d 8d be 48 03 00 00 	lea    r15,[r14+0x348]
   1824dadf9:	49 39 ff             	cmp    r15,rdi
   1824dadfc:	74 29                	je     0x1824dae27
   1824dadfe:	4c 8b 67 10          	mov    r12,QWORD PTR [rdi+0x10]
   1824dae02:	48 83 7f 18 10       	cmp    QWORD PTR [rdi+0x18],0x10
   1824dae07:	72 03                	jb     0x1824dae0c
   1824dae09:	48 8b 3f             	mov    rdi,QWORD PTR [rdi]
   1824dae0c:	49 8b 85 60 03 00 00 	mov    rax,QWORD PTR [r13+0x360]
   1824dae13:	49 39 c4             	cmp    r12,rax
   1824dae16:	76 1d                	jbe    0x1824dae35
   1824dae18:	4c 89 f9             	mov    rcx,r15
   1824dae1b:	4c 89 e2             	mov    rdx,r12
   1824dae1e:	49 89 f9             	mov    r9,rdi
   1824dae21:	e8 2a 33 b6 fd       	call   0x18003e150
   1824dae26:	90                   	nop
   1824dae27:	49 81 c6 a0 04 00 00 	add    r14,0x4a0
   1824dae2e:	49 39 f6             	cmp    r14,rsi
   1824dae31:	75 31                	jne    0x1824dae64
   1824dae33:	eb 58                	jmp    0x1824dae8d
   1824dae35:	48 83 f8 10          	cmp    rax,0x10
   1824dae39:	72 03                	jb     0x1824dae3e
   1824dae3b:	4d 8b 3f             	mov    r15,QWORD PTR [r15]
   1824dae3e:	4d 89 a5 58 03 00 00 	mov    QWORD PTR [r13+0x358],r12
   1824dae45:	4c 89 f9             	mov    rcx,r15
   1824dae48:	48 89 fa             	mov    rdx,rdi
   1824dae4b:	4d 89 e0             	mov    r8,r12
   1824dae4e:	e8 fd 91 06 05       	call   0x187544050
   1824dae53:	43 c6 04 27 00       	mov    BYTE PTR [r15+r12*1],0x0
   1824dae58:	49 81 c6 a0 04 00 00 	add    r14,0x4a0
   1824dae5f:	49 39 f6             	cmp    r14,rsi
   1824dae62:	74 29                	je     0x1824dae8d
   1824dae64:	48 8b 7e 10          	mov    rdi,QWORD PTR [rsi+0x10]
   1824dae68:	48 83 7e 18 10       	cmp    QWORD PTR [rsi+0x18],0x10
   1824dae6d:	72 03                	jb     0x1824dae72
   1824dae6f:	48 8b 36             	mov    rsi,QWORD PTR [rsi]
   1824dae72:	49 8b 85 b8 04 00 00 	mov    rax,QWORD PTR [r13+0x4b8]
   1824dae79:	48 39 c7             	cmp    rdi,rax
   1824dae7c:	76 3a                	jbe    0x1824daeb8
   1824dae7e:	4c 89 f1             	mov    rcx,r14
   1824dae81:	48 89 fa             	mov    rdx,rdi
   1824dae84:	49 89 f1             	mov    r9,rsi
   1824dae87:	e8 c4 32 b6 fd       	call   0x18003e150
   1824dae8c:	90                   	nop
   1824dae8d:	48 85 db             	test   rbx,rbx
   1824dae90:	4c 8b bd 78 01 00 00 	mov    r15,QWORD PTR [rbp+0x178]
   1824dae97:	74 4e                	je     0x1824daee7
   1824dae99:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   1824dae9d:	75 48                	jne    0x1824daee7
   1824dae9f:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1824daea2:	48 89 d9             	mov    rcx,rbx
   1824daea5:	ff 10                	call   QWORD PTR [rax]
   1824daea7:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   1824daeab:	75 3a                	jne    0x1824daee7
   1824daead:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1824daeb0:	48 89 d9             	mov    rcx,rbx
   1824daeb3:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1824daeb6:	eb 2f                	jmp    0x1824daee7
   1824daeb8:	48 83 f8 10          	cmp    rax,0x10
   1824daebc:	72 03                	jb     0x1824daec1
   1824daebe:	4d 8b 36             	mov    r14,QWORD PTR [r14]
   1824daec1:	49 89 bd b0 04 00 00 	mov    QWORD PTR [r13+0x4b0],rdi
   1824daec8:	4c 89 f1             	mov    rcx,r14
   1824daecb:	48 89 f2             	mov    rdx,rsi
   1824daece:	49 89 f8             	mov    r8,rdi
   1824daed1:	e8 7a 91 06 05       	call   0x187544050
   1824daed6:	41 c6 04 3e 00       	mov    BYTE PTR [r14+rdi*1],0x0
   1824daedb:	48 85 db             	test   rbx,rbx
   1824daede:	4c 8b bd 78 01 00 00 	mov    r15,QWORD PTR [rbp+0x178]
   1824daee5:	75 b2                	jne    0x1824dae99
   1824daee7:	48 8b b5 98 01 00 00 	mov    rsi,QWORD PTR [rbp+0x198]
   1824daeee:	48 85 f6             	test   rsi,rsi
   1824daef1:	74 1d                	je     0x1824daf10
   1824daef3:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   1824daef7:	75 17                	jne    0x1824daf10
   1824daef9:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1824daefc:	48 89 f1             	mov    rcx,rsi
   1824daeff:	ff 10                	call   QWORD PTR [rax]
   1824daf01:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   1824daf05:	75 09                	jne    0x1824daf10
   1824daf07:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1824daf0a:	48 89 f1             	mov    rcx,rsi
   1824daf0d:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1824daf10:	48 8b b5 38 01 00 00 	mov    rsi,QWORD PTR [rbp+0x138]
   1824daf17:	48 85 f6             	test   rsi,rsi
   1824daf1a:	74 1d                	je     0x1824daf39
   1824daf1c:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   1824daf20:	75 17                	jne    0x1824daf39
   1824daf22:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1824daf25:	48 89 f1             	mov    rcx,rsi
   1824daf28:	ff 10                	call   QWORD PTR [rax]
   1824daf2a:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   1824daf2e:	75 09                	jne    0x1824daf39
   1824daf30:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1824daf33:	48 89 f1             	mov    rcx,rsi
   1824daf36:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1824daf39:	48 8b b5 88 01 00 00 	mov    rsi,QWORD PTR [rbp+0x188]
   1824daf40:	48 85 f6             	test   rsi,rsi
   1824daf43:	74 1d                	je     0x1824daf62
   1824daf45:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   1824daf49:	75 17                	jne    0x1824daf62
   1824daf4b:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1824daf4e:	48 89 f1             	mov    rcx,rsi
   1824daf51:	ff 10                	call   QWORD PTR [rax]
   1824daf53:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   1824daf57:	75 09                	jne    0x1824daf62
   1824daf59:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1824daf5c:	48 89 f1             	mov    rcx,rsi
   1824daf5f:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1824daf62:	4c 89 f8             	mov    rax,r15
   1824daf65:	0f 28 b5 b0 01 00 00 	movaps xmm6,XMMWORD PTR [rbp+0x1b0]
   1824daf6c:	48 81 c4 48 02 00 00 	add    rsp,0x248
   1824daf73:	5b                   	pop    rbx
   1824daf74:	5f                   	pop    rdi
   1824daf75:	5e                   	pop    rsi
   1824daf76:	41 5c                	pop    r12
   1824daf78:	41 5d                	pop    r13
   1824daf7a:	41 5e                	pop    r14
   1824daf7c:	41 5f                	pop    r15
   1824daf7e:	5d                   	pop    rbp
   1824daf7f:	c3                   	ret
   1824daf80:	e8 07 24 03 05       	call   0x18750d38c
   1824daf85:	cc                   	int3
