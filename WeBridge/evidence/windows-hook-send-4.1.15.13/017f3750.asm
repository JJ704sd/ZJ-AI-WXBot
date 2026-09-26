
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

00000001817f3750 <.text+0x17f2750>:
   1817f3750:	55                   	push   rbp
   1817f3751:	41 57                	push   r15
   1817f3753:	41 56                	push   r14
   1817f3755:	56                   	push   rsi
   1817f3756:	57                   	push   rdi
   1817f3757:	53                   	push   rbx
   1817f3758:	48 81 ec 68 03 00 00 	sub    rsp,0x368
   1817f375f:	48 8d ac 24 80 00 00 	lea    rbp,[rsp+0x80]
   1817f3766:	00 
   1817f3767:	0f 29 b5 d0 02 00 00 	movaps XMMWORD PTR [rbp+0x2d0],xmm6
   1817f376e:	48 c7 85 c8 02 00 00 	mov    QWORD PTR [rbp+0x2c8],0xfffffffffffffffe
   1817f3775:	fe ff ff ff 
   1817f3779:	4c 89 85 c0 02 00 00 	mov    QWORD PTR [rbp+0x2c0],r8
   1817f3780:	48 89 d6             	mov    rsi,rdx
   1817f3783:	48 89 cf             	mov    rdi,rcx
   1817f3786:	0f 28 35 23 24 55 07 	movaps xmm6,XMMWORD PTR [rip+0x7552423]        # 0x188d45bb0
   1817f378d:	0f 29 b5 b0 00 00 00 	movaps XMMWORD PTR [rbp+0xb0],xmm6
   1817f3794:	48 8d 15 85 da 8e 07 	lea    rdx,[rip+0x78eda85]        # 0x1890e1220
   1817f379b:	4c 8d 05 56 86 8e 07 	lea    r8,[rip+0x78e8656]        # 0x1890dbdf8
   1817f37a2:	48 8d 8d 30 01 00 00 	lea    rcx,[rbp+0x130]
   1817f37a9:	41 b9 60 10 00 00    	mov    r9d,0x1060
   1817f37af:	e8 4c 6d 9a fe       	call   0x18019a500
   1817f37b4:	90                   	nop
   1817f37b5:	c7 85 b0 00 00 00 02 	mov    DWORD PTR [rbp+0xb0],0x2
   1817f37bc:	00 00 00 
   1817f37bf:	48 c7 85 c0 00 00 00 	mov    QWORD PTR [rbp+0xc0],0x0
   1817f37c6:	00 00 00 00 
   1817f37ca:	0f 28 85 30 01 00 00 	movaps xmm0,XMMWORD PTR [rbp+0x130]
   1817f37d1:	0f 11 85 c8 00 00 00 	movups XMMWORD PTR [rbp+0xc8],xmm0
   1817f37d8:	0f 57 c0             	xorps  xmm0,xmm0
   1817f37db:	0f 11 85 d8 00 00 00 	movups XMMWORD PTR [rbp+0xd8],xmm0
   1817f37e2:	48 c7 85 e8 00 00 00 	mov    QWORD PTR [rbp+0xe8],0x0
   1817f37e9:	00 00 00 00 
   1817f37ed:	48 c7 85 f0 00 00 00 	mov    QWORD PTR [rbp+0xf0],0xf
   1817f37f4:	0f 00 00 00 
   1817f37f8:	e8 c3 17 1c ff       	call   0x1809b4fc0
   1817f37fd:	90                   	nop
   1817f37fe:	48 89 85 b8 00 00 00 	mov    QWORD PTR [rbp+0xb8],rax
   1817f3805:	48 83 bd f0 00 00 00 	cmp    QWORD PTR [rbp+0xf0],0x1f
   1817f380c:	1f 
   1817f380d:	73 1b                	jae    0x1817f382a
   1817f380f:	4c 8d 0d 7a 1e 8e 07 	lea    r9,[rip+0x78e1e7a]        # 0x1890d5690
   1817f3816:	ba 1f 00 00 00       	mov    edx,0x1f
   1817f381b:	48 8d 8d d8 00 00 00 	lea    rcx,[rbp+0xd8]
   1817f3822:	e8 29 a9 84 fe       	call   0x18003e150
   1817f3827:	90                   	nop
   1817f3828:	eb 2b                	jmp    0x1817f3855
   1817f382a:	48 8b 85 d8 00 00 00 	mov    rax,QWORD PTR [rbp+0xd8]
   1817f3831:	48 c7 85 e8 00 00 00 	mov    QWORD PTR [rbp+0xe8],0x1f
   1817f3838:	1f 00 00 00 
   1817f383c:	0f 10 05 5c 1e 8e 07 	movups xmm0,XMMWORD PTR [rip+0x78e1e5c]        # 0x1890d569f
   1817f3843:	0f 11 40 0f          	movups XMMWORD PTR [rax+0xf],xmm0
   1817f3847:	0f 10 05 42 1e 8e 07 	movups xmm0,XMMWORD PTR [rip+0x78e1e42]        # 0x1890d5690
   1817f384e:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   1817f3851:	c6 40 1f 00          	mov    BYTE PTR [rax+0x1f],0x0
   1817f3855:	48 8b 9d c0 02 00 00 	mov    rbx,QWORD PTR [rbp+0x2c0]
   1817f385c:	48 8b 0b             	mov    rcx,QWORD PTR [rbx]
   1817f385f:	ba 01 00 00 00       	mov    edx,0x1
   1817f3864:	e8 c7 32 19 02       	call   0x183986b30
   1817f3869:	90                   	nop
   1817f386a:	48 b8 aa aa aa aa aa 	movabs rax,0xaaaaaaaaaaaaaaaa
   1817f3871:	aa aa aa 
   1817f3874:	48 89 85 b0 02 00 00 	mov    QWORD PTR [rbp+0x2b0],rax
   1817f387b:	0f 29 b5 a0 02 00 00 	movaps XMMWORD PTR [rbp+0x2a0],xmm6
   1817f3882:	0f 29 b5 90 02 00 00 	movaps XMMWORD PTR [rbp+0x290],xmm6
   1817f3889:	0f 29 b5 80 02 00 00 	movaps XMMWORD PTR [rbp+0x280],xmm6
   1817f3890:	0f 57 c0             	xorps  xmm0,xmm0
   1817f3893:	0f 29 85 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm0
   1817f389a:	48 8b 43 08          	mov    rax,QWORD PTR [rbx+0x8]
   1817f389e:	48 85 c0             	test   rax,rax
   1817f38a1:	74 0a                	je     0x1817f38ad
   1817f38a3:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   1817f38a7:	48 8b 43 08          	mov    rax,QWORD PTR [rbx+0x8]
   1817f38ab:	eb 02                	jmp    0x1817f38af
   1817f38ad:	31 c0                	xor    eax,eax
   1817f38af:	48 8b 0b             	mov    rcx,QWORD PTR [rbx]
   1817f38b2:	48 89 8d 00 01 00 00 	mov    QWORD PTR [rbp+0x100],rcx
   1817f38b9:	48 89 85 08 01 00 00 	mov    QWORD PTR [rbp+0x108],rax
   1817f38c0:	48 8d 95 30 01 00 00 	lea    rdx,[rbp+0x130]
   1817f38c7:	4c 8d 85 00 01 00 00 	lea    r8,[rbp+0x100]
   1817f38ce:	48 89 f9             	mov    rcx,rdi
   1817f38d1:	e8 4a 15 00 00       	call   0x1817f4e20
   1817f38d6:	90                   	nop
   1817f38d7:	48 8d 9d 00 02 00 00 	lea    rbx,[rbp+0x200]
   1817f38de:	48 8d 95 80 02 00 00 	lea    rdx,[rbp+0x280]
   1817f38e5:	4c 8d 85 30 01 00 00 	lea    r8,[rbp+0x130]
   1817f38ec:	48 89 d9             	mov    rcx,rbx
   1817f38ef:	e8 9c 92 fa ff       	call   0x18179cb90
   1817f38f4:	90                   	nop
   1817f38f5:	4c 8b b5 38 01 00 00 	mov    r14,QWORD PTR [rbp+0x138]
   1817f38fc:	4d 85 f6             	test   r14,r14
   1817f38ff:	74 1f                	je     0x1817f3920
   1817f3901:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   1817f3906:	75 18                	jne    0x1817f3920
   1817f3908:	49 8b 06             	mov    rax,QWORD PTR [r14]
   1817f390b:	4c 89 f1             	mov    rcx,r14
   1817f390e:	ff 10                	call   QWORD PTR [rax]
   1817f3910:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   1817f3915:	75 09                	jne    0x1817f3920
   1817f3917:	49 8b 06             	mov    rax,QWORD PTR [r14]
   1817f391a:	4c 89 f1             	mov    rcx,r14
   1817f391d:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1817f3920:	48 8b 8d a8 02 00 00 	mov    rcx,QWORD PTR [rbp+0x2a8]
   1817f3927:	48 8b 85 c0 02 00 00 	mov    rax,QWORD PTR [rbp+0x2c0]
   1817f392e:	48 8b 00             	mov    rax,QWORD PTR [rax]
   1817f3931:	48 8b 50 20          	mov    rdx,QWORD PTR [rax+0x20]
   1817f3935:	48 85 d2             	test   rdx,rdx
   1817f3938:	74 0a                	je     0x1817f3944
   1817f393a:	f0 ff 42 08          	lock inc DWORD PTR [rdx+0x8]
   1817f393e:	48 8b 50 20          	mov    rdx,QWORD PTR [rax+0x20]
   1817f3942:	eb 02                	jmp    0x1817f3946
   1817f3944:	31 d2                	xor    edx,edx
   1817f3946:	48 8b 40 18          	mov    rax,QWORD PTR [rax+0x18]
   1817f394a:	48 89 45 50          	mov    QWORD PTR [rbp+0x50],rax
   1817f394e:	48 89 55 58          	mov    QWORD PTR [rbp+0x58],rdx
   1817f3952:	48 8d 55 50          	lea    rdx,[rbp+0x50]
   1817f3956:	e8 55 3d 00 00       	call   0x1817f76b0
   1817f395b:	90                   	nop
   1817f395c:	48 8b 85 c0 02 00 00 	mov    rax,QWORD PTR [rbp+0x2c0]
   1817f3963:	48 8b 08             	mov    rcx,QWORD PTR [rax]
   1817f3966:	48 83 c1 78          	add    rcx,0x78
   1817f396a:	48 8d 95 80 02 00 00 	lea    rdx,[rbp+0x280]
   1817f3971:	e8 fa 3e 00 00       	call   0x1817f7870
   1817f3976:	90                   	nop
   1817f3977:	48 8b 85 c0 02 00 00 	mov    rax,QWORD PTR [rbp+0x2c0]
   1817f397e:	48 8b 08             	mov    rcx,QWORD PTR [rax]
   1817f3981:	4c 8d b5 30 01 00 00 	lea    r14,[rbp+0x130]
   1817f3988:	4c 89 f2             	mov    rdx,r14
   1817f398b:	e8 40 1d 19 02       	call   0x1839856d0
   1817f3990:	90                   	nop
   1817f3991:	48 c7 85 08 02 00 00 	mov    QWORD PTR [rbp+0x208],0x0
   1817f3998:	00 00 00 00 
   1817f399c:	b9 20 00 00 00       	mov    ecx,0x20
   1817f39a1:	e8 f6 7e cb 05       	call   0x1874ab89c
   1817f39a6:	90                   	nop
   1817f39a7:	48 89 85 00 02 00 00 	mov    QWORD PTR [rbp+0x200],rax
   1817f39ae:	48 c7 85 10 02 00 00 	mov    QWORD PTR [rbp+0x210],0x15
   1817f39b5:	15 00 00 00 
   1817f39b9:	48 c7 85 18 02 00 00 	mov    QWORD PTR [rbp+0x218],0x1f
   1817f39c0:	1f 00 00 00 
   1817f39c4:	0f 10 05 e5 1c 8e 07 	movups xmm0,XMMWORD PTR [rip+0x78e1ce5]        # 0x1890d56b0
   1817f39cb:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   1817f39ce:	48 b9 73 61 67 65 54 	movabs rcx,0x62446f5465676173
   1817f39d5:	6f 44 62 
   1817f39d8:	48 89 48 0d          	mov    QWORD PTR [rax+0xd],rcx
   1817f39dc:	c6 40 15 00          	mov    BYTE PTR [rax+0x15],0x0
   1817f39e0:	4c 8b bd 40 01 00 00 	mov    r15,QWORD PTR [rbp+0x140]
   1817f39e7:	48 83 bd 48 01 00 00 	cmp    QWORD PTR [rbp+0x148],0x10
   1817f39ee:	10 
   1817f39ef:	72 07                	jb     0x1817f39f8
   1817f39f1:	4c 8b b5 30 01 00 00 	mov    r14,QWORD PTR [rbp+0x130]
   1817f39f8:	49 83 ff 0a          	cmp    r15,0xa
   1817f39fc:	76 1d                	jbe    0x1817f3a1b
   1817f39fe:	4c 89 7c 24 20       	mov    QWORD PTR [rsp+0x20],r15
   1817f3a03:	48 8d 8d 00 02 00 00 	lea    rcx,[rbp+0x200]
   1817f3a0a:	4c 89 fa             	mov    rdx,r15
   1817f3a0d:	4d 89 f1             	mov    r9,r14
   1817f3a10:	e8 ab 59 81 fe       	call   0x1800093c0
   1817f3a15:	90                   	nop
   1817f3a16:	48 89 c3             	mov    rbx,rax
   1817f3a19:	eb 26                	jmp    0x1817f3a41
   1817f3a1b:	48 89 c1             	mov    rcx,rax
   1817f3a1e:	48 83 c1 15          	add    rcx,0x15
   1817f3a22:	49 8d 57 15          	lea    rdx,[r15+0x15]
   1817f3a26:	48 89 95 10 02 00 00 	mov    QWORD PTR [rbp+0x210],rdx
   1817f3a2d:	4c 89 f2             	mov    rdx,r14
   1817f3a30:	4d 89 f8             	mov    r8,r15
   1817f3a33:	49 89 c6             	mov    r14,rax
   1817f3a36:	e8 15 06 d5 05       	call   0x187544050
   1817f3a3b:	43 c6 44 3e 15 00    	mov    BYTE PTR [r14+r15*1+0x15],0x0
   1817f3a41:	0f 10 03             	movups xmm0,XMMWORD PTR [rbx]
   1817f3a44:	0f 10 4b 10          	movups xmm1,XMMWORD PTR [rbx+0x10]
   1817f3a48:	0f 29 4d d0          	movaps XMMWORD PTR [rbp-0x30],xmm1
   1817f3a4c:	0f 29 45 c0          	movaps XMMWORD PTR [rbp-0x40],xmm0
   1817f3a50:	48 c7 43 10 00 00 00 	mov    QWORD PTR [rbx+0x10],0x0
   1817f3a57:	00 
   1817f3a58:	48 c7 43 18 0f 00 00 	mov    QWORD PTR [rbx+0x18],0xf
   1817f3a5f:	00 
   1817f3a60:	c6 03 00             	mov    BYTE PTR [rbx],0x0
   1817f3a63:	48 8d 8d b0 00 00 00 	lea    rcx,[rbp+0xb0]
   1817f3a6a:	48 8d 55 c0          	lea    rdx,[rbp-0x40]
   1817f3a6e:	41 b8 32 00 00 00    	mov    r8d,0x32
   1817f3a74:	e8 77 16 7d ff       	call   0x180fc50f0
   1817f3a79:	90                   	nop
   1817f3a7a:	48 8b 85 18 02 00 00 	mov    rax,QWORD PTR [rbp+0x218]
   1817f3a81:	48 83 f8 10          	cmp    rax,0x10
   1817f3a85:	48 8b 9d c0 02 00 00 	mov    rbx,QWORD PTR [rbp+0x2c0]
   1817f3a8c:	72 38                	jb     0x1817f3ac6
   1817f3a8e:	48 8b 8d 00 02 00 00 	mov    rcx,QWORD PTR [rbp+0x200]
   1817f3a95:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1817f3a99:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1817f3aa0:	72 1f                	jb     0x1817f3ac1
   1817f3aa2:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1817f3aa6:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1817f3aaa:	4c 29 c1             	sub    rcx,r8
   1817f3aad:	48 83 f9 20          	cmp    rcx,0x20
   1817f3ab1:	0f 83 c4 0d 00 00    	jae    0x1817f487b
   1817f3ab7:	48 83 c0 28          	add    rax,0x28
   1817f3abb:	48 89 c2             	mov    rdx,rax
   1817f3abe:	4c 89 c1             	mov    rcx,r8
   1817f3ac1:	e8 1a 7e cb 05       	call   0x1874ab8e0
   1817f3ac6:	48 8b 85 48 01 00 00 	mov    rax,QWORD PTR [rbp+0x148]
   1817f3acd:	48 83 f8 10          	cmp    rax,0x10
   1817f3ad1:	72 38                	jb     0x1817f3b0b
   1817f3ad3:	48 8b 8d 30 01 00 00 	mov    rcx,QWORD PTR [rbp+0x130]
   1817f3ada:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1817f3ade:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1817f3ae5:	72 1f                	jb     0x1817f3b06
   1817f3ae7:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1817f3aeb:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1817f3aef:	4c 29 c1             	sub    rcx,r8
   1817f3af2:	48 83 f9 20          	cmp    rcx,0x20
   1817f3af6:	0f 83 7f 0d 00 00    	jae    0x1817f487b
   1817f3afc:	48 83 c0 28          	add    rax,0x28
   1817f3b00:	48 89 c2             	mov    rdx,rax
   1817f3b03:	4c 89 c1             	mov    rcx,r8
   1817f3b06:	e8 d5 7d cb 05       	call   0x1874ab8e0
   1817f3b0b:	8b 85 84 02 00 00    	mov    eax,DWORD PTR [rbp+0x284]
   1817f3b11:	0b 85 80 02 00 00    	or     eax,DWORD PTR [rbp+0x280]
   1817f3b17:	0f 84 68 02 00 00    	je     0x1817f3d85
   1817f3b1d:	b9 04 00 00 00       	mov    ecx,0x4
   1817f3b22:	e8 b9 92 87 fe       	call   0x18006cde0
   1817f3b27:	85 c0                	test   eax,eax
   1817f3b29:	0f 84 27 02 00 00    	je     0x1817f3d56
   1817f3b2f:	48 8d bd c0 01 00 00 	lea    rdi,[rbp+0x1c0]
   1817f3b36:	48 89 f9             	mov    rcx,rdi
   1817f3b39:	e8 d2 93 87 fe       	call   0x18006cf10
   1817f3b3e:	90                   	nop
   1817f3b3f:	48 83 bd d8 01 00 00 	cmp    QWORD PTR [rbp+0x1d8],0x10
   1817f3b46:	10 
   1817f3b47:	72 07                	jb     0x1817f3b50
   1817f3b49:	48 8b bd c0 01 00 00 	mov    rdi,QWORD PTR [rbp+0x1c0]
   1817f3b50:	48 8d 05 39 bb 8e 07 	lea    rax,[rip+0x78ebb39]        # 0x1890df690
   1817f3b57:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1817f3b5c:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   1817f3b63:	00 00 
   1817f3b65:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   1817f3b6a:	c7 44 24 28 69 10 00 	mov    DWORD PTR [rsp+0x28],0x1069
   1817f3b71:	00 
   1817f3b72:	4c 8d 0d 7f 82 8e 07 	lea    r9,[rip+0x78e827f]        # 0x1890dbdf8
   1817f3b79:	48 8d 8d 30 01 00 00 	lea    rcx,[rbp+0x130]
   1817f3b80:	ba 04 00 00 00       	mov    edx,0x4
   1817f3b85:	49 89 f8             	mov    r8,rdi
   1817f3b88:	e8 e3 96 87 fe       	call   0x18006d270
   1817f3b8d:	90                   	nop
   1817f3b8e:	48 8b 85 c0 02 00 00 	mov    rax,QWORD PTR [rbp+0x2c0]
   1817f3b95:	48 8b 08             	mov    rcx,QWORD PTR [rax]
   1817f3b98:	e8 b3 9e 72 ff       	call   0x180f1da50
   1817f3b9d:	90                   	nop
   1817f3b9e:	48 c7 45 60 00 00 00 	mov    QWORD PTR [rbp+0x60],0x0
   1817f3ba5:	00 
   1817f3ba6:	b9 07 00 00 00       	mov    ecx,0x7
   1817f3bab:	48 8d 55 67          	lea    rdx,[rbp+0x67]
   1817f3baf:	41 b8 cd cc cc cc    	mov    r8d,0xcccccccd
   1817f3bb5:	4c 8d 0d b4 26 55 07 	lea    r9,[rip+0x75526b4]        # 0x188d46270
   1817f3bbc:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
   1817f3bc0:	41 89 c2             	mov    r10d,eax
   1817f3bc3:	4d 0f af d0          	imul   r10,r8
   1817f3bc7:	49 c1 ea 23          	shr    r10,0x23
   1817f3bcb:	47 8d 1c 12          	lea    r11d,[r10+r10*1]
   1817f3bcf:	47 8d 1c 9b          	lea    r11d,[r11+r11*4]
   1817f3bd3:	41 f7 db             	neg    r11d
   1817f3bd6:	41 01 c3             	add    r11d,eax
   1817f3bd9:	41 83 c3 23          	add    r11d,0x23
   1817f3bdd:	47 0f b6 1c 0b       	movzx  r11d,BYTE PTR [r11+r9*1]
   1817f3be2:	44 88 5a 01          	mov    BYTE PTR [rdx+0x1],r11b
   1817f3be6:	48 ff c2             	inc    rdx
   1817f3be9:	48 ff c1             	inc    rcx
   1817f3bec:	83 f8 09             	cmp    eax,0x9
   1817f3bef:	44 89 d0             	mov    eax,r10d
   1817f3bf2:	77 cc                	ja     0x1817f3bc0
   1817f3bf4:	48 8d 45 68          	lea    rax,[rbp+0x68]
   1817f3bf8:	c6 42 01 00          	mov    BYTE PTR [rdx+0x1],0x0
   1817f3bfc:	48 83 f9 09          	cmp    rcx,0x9
   1817f3c00:	4c 8b 95 c0 02 00 00 	mov    r10,QWORD PTR [rbp+0x2c0]
   1817f3c07:	72 23                	jb     0x1817f3c2c
   1817f3c09:	48 8d 4d 69          	lea    rcx,[rbp+0x69]
   1817f3c0d:	0f 1f 00             	nop    DWORD PTR [rax]
   1817f3c10:	44 0f b6 02          	movzx  r8d,BYTE PTR [rdx]
   1817f3c14:	44 0f b6 49 ff       	movzx  r9d,BYTE PTR [rcx-0x1]
   1817f3c19:	44 88 0a             	mov    BYTE PTR [rdx],r9b
   1817f3c1c:	48 ff ca             	dec    rdx
   1817f3c1f:	44 88 41 ff          	mov    BYTE PTR [rcx-0x1],r8b
   1817f3c23:	48 39 d1             	cmp    rcx,rdx
   1817f3c26:	48 8d 49 01          	lea    rcx,[rcx+0x1]
   1817f3c2a:	72 e4                	jb     0x1817f3c10
   1817f3c2c:	48 89 45 60          	mov    QWORD PTR [rbp+0x60],rax
   1817f3c30:	49 8b 0a             	mov    rcx,QWORD PTR [r10]
   1817f3c33:	48 8d bd e0 01 00 00 	lea    rdi,[rbp+0x1e0]
   1817f3c3a:	48 89 fa             	mov    rdx,rdi
   1817f3c3d:	e8 8e 1a 19 02       	call   0x1839856d0
   1817f3c42:	90                   	nop
   1817f3c43:	48 83 bd f8 01 00 00 	cmp    QWORD PTR [rbp+0x1f8],0x10
   1817f3c4a:	10 
   1817f3c4b:	72 07                	jb     0x1817f3c54
   1817f3c4d:	48 8b bd e0 01 00 00 	mov    rdi,QWORD PTR [rbp+0x1e0]
   1817f3c54:	48 89 7d 00          	mov    QWORD PTR [rbp+0x0],rdi
   1817f3c58:	c6 45 08 00          	mov    BYTE PTR [rbp+0x8],0x0
   1817f3c5c:	0f 57 c0             	xorps  xmm0,xmm0
   1817f3c5f:	0f 11 85 70 02 00 00 	movups XMMWORD PTR [rbp+0x270],xmm0
   1817f3c66:	0f 11 85 60 02 00 00 	movups XMMWORD PTR [rbp+0x260],xmm0
   1817f3c6d:	0f 11 85 50 02 00 00 	movups XMMWORD PTR [rbp+0x250],xmm0
   1817f3c74:	0f 11 85 40 02 00 00 	movups XMMWORD PTR [rbp+0x240],xmm0
   1817f3c7b:	0f 11 85 30 02 00 00 	movups XMMWORD PTR [rbp+0x230],xmm0
   1817f3c82:	0f 11 85 20 02 00 00 	movups XMMWORD PTR [rbp+0x220],xmm0
   1817f3c89:	0f 11 85 10 02 00 00 	movups XMMWORD PTR [rbp+0x210],xmm0
   1817f3c90:	48 89 e8             	mov    rax,rbp
   1817f3c93:	48 89 85 00 02 00 00 	mov    QWORD PTR [rbp+0x200],rax
   1817f3c9a:	48 8d 45 60          	lea    rax,[rbp+0x60]
   1817f3c9e:	48 89 85 08 02 00 00 	mov    QWORD PTR [rbp+0x208],rax
   1817f3ca5:	48 8d 15 4c 2c 8f 07 	lea    rdx,[rip+0x78f2c4c]        # 0x1890e68f8
   1817f3cac:	48 8d 8d 30 01 00 00 	lea    rcx,[rbp+0x130]
   1817f3cb3:	4c 8d 85 00 02 00 00 	lea    r8,[rbp+0x200]
   1817f3cba:	e8 51 9b 87 fe       	call   0x18006d810
   1817f3cbf:	90                   	nop
   1817f3cc0:	48 8b 85 f8 01 00 00 	mov    rax,QWORD PTR [rbp+0x1f8]
   1817f3cc7:	48 83 f8 10          	cmp    rax,0x10
   1817f3ccb:	72 38                	jb     0x1817f3d05
   1817f3ccd:	48 8b 8d e0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1e0]
   1817f3cd4:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1817f3cd8:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1817f3cdf:	72 1f                	jb     0x1817f3d00
   1817f3ce1:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1817f3ce5:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1817f3ce9:	4c 29 c1             	sub    rcx,r8
   1817f3cec:	48 83 f9 20          	cmp    rcx,0x20
   1817f3cf0:	0f 83 85 0b 00 00    	jae    0x1817f487b
   1817f3cf6:	48 83 c0 28          	add    rax,0x28
   1817f3cfa:	48 89 c2             	mov    rdx,rax
   1817f3cfd:	4c 89 c1             	mov    rcx,r8
   1817f3d00:	e8 db 7b cb 05       	call   0x1874ab8e0
   1817f3d05:	48 8d 8d 30 01 00 00 	lea    rcx,[rbp+0x130]
   1817f3d0c:	e8 5f 96 87 fe       	call   0x18006d370
   1817f3d11:	48 8b 85 d8 01 00 00 	mov    rax,QWORD PTR [rbp+0x1d8]
   1817f3d18:	48 83 f8 10          	cmp    rax,0x10
   1817f3d1c:	72 38                	jb     0x1817f3d56
   1817f3d1e:	48 8b 8d c0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1c0]
   1817f3d25:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1817f3d29:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1817f3d30:	72 1f                	jb     0x1817f3d51
   1817f3d32:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1817f3d36:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1817f3d3a:	4c 29 c1             	sub    rcx,r8
   1817f3d3d:	48 83 f9 20          	cmp    rcx,0x20
   1817f3d41:	0f 83 34 0b 00 00    	jae    0x1817f487b
   1817f3d47:	48 83 c0 28          	add    rax,0x28
   1817f3d4b:	48 89 c2             	mov    rdx,rax
   1817f3d4e:	4c 89 c1             	mov    rcx,r8
   1817f3d51:	e8 8a 7b cb 05       	call   0x1874ab8e0
   1817f3d56:	48 8b 85 80 02 00 00 	mov    rax,QWORD PTR [rbp+0x280]
   1817f3d5d:	48 89 06             	mov    QWORD PTR [rsi],rax
   1817f3d60:	0f 57 c0             	xorps  xmm0,xmm0
   1817f3d63:	0f 11 46 08          	movups XMMWORD PTR [rsi+0x8],xmm0
   1817f3d67:	0f 11 46 18          	movups XMMWORD PTR [rsi+0x18],xmm0
   1817f3d6b:	48 8b bd 98 02 00 00 	mov    rdi,QWORD PTR [rbp+0x298]
   1817f3d72:	48 83 bd a0 02 00 00 	cmp    QWORD PTR [rbp+0x2a0],0x10
   1817f3d79:	10 
   1817f3d7a:	72 6c                	jb     0x1817f3de8
   1817f3d7c:	48 8b 9d 88 02 00 00 	mov    rbx,QWORD PTR [rbp+0x288]
   1817f3d83:	eb 6a                	jmp    0x1817f3def
   1817f3d85:	48 8b 0b             	mov    rcx,QWORD PTR [rbx]
   1817f3d88:	e8 b3 2d 19 02       	call   0x183986b40
   1817f3d8d:	90                   	nop
   1817f3d8e:	84 c0                	test   al,al
   1817f3d90:	74 32                	je     0x1817f3dc4
   1817f3d92:	0f 29 b5 e0 01 00 00 	movaps XMMWORD PTR [rbp+0x1e0],xmm6
   1817f3d99:	0f 57 c0             	xorps  xmm0,xmm0
   1817f3d9c:	0f 29 85 10 01 00 00 	movaps XMMWORD PTR [rbp+0x110],xmm0
   1817f3da3:	48 8b 8d c0 02 00 00 	mov    rcx,QWORD PTR [rbp+0x2c0]
   1817f3daa:	48 8b 41 08          	mov    rax,QWORD PTR [rcx+0x8]
   1817f3dae:	48 85 c0             	test   rax,rax
   1817f3db1:	0f 84 8f 00 00 00    	je     0x1817f3e46
   1817f3db7:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   1817f3dbb:	48 8b 41 08          	mov    rax,QWORD PTR [rcx+0x8]
   1817f3dbf:	e9 84 00 00 00       	jmp    0x1817f3e48
   1817f3dc4:	48 8b 85 c0 02 00 00 	mov    rax,QWORD PTR [rbp+0x2c0]
   1817f3dcb:	48 8b 00             	mov    rax,QWORD PTR [rax]
   1817f3dce:	48 8b 48 20          	mov    rcx,QWORD PTR [rax+0x20]
   1817f3dd2:	48 85 c9             	test   rcx,rcx
   1817f3dd5:	0f 84 ea 00 00 00    	je     0x1817f3ec5
   1817f3ddb:	f0 ff 41 08          	lock inc DWORD PTR [rcx+0x8]
   1817f3ddf:	48 8b 58 20          	mov    rbx,QWORD PTR [rax+0x20]
   1817f3de3:	e9 df 00 00 00       	jmp    0x1817f3ec7
   1817f3de8:	48 8d 9d 88 02 00 00 	lea    rbx,[rbp+0x288]
   1817f3def:	48 85 ff             	test   rdi,rdi
   1817f3df2:	0f 88 89 0a 00 00    	js     0x1817f4881
   1817f3df8:	48 83 ff 0f          	cmp    rdi,0xf
   1817f3dfc:	0f 86 47 01 00 00    	jbe    0x1817f3f49
   1817f3e02:	48 89 f8             	mov    rax,rdi
   1817f3e05:	48 83 c8 0f          	or     rax,0xf
   1817f3e09:	48 83 f8 17          	cmp    rax,0x17
   1817f3e0d:	41 be 16 00 00 00    	mov    r14d,0x16
   1817f3e13:	4c 0f 43 f0          	cmovae r14,rax
   1817f3e17:	48 3d ff 0f 00 00    	cmp    rax,0xfff
   1817f3e1d:	72 18                	jb     0x1817f3e37
   1817f3e1f:	49 8d 4e 28          	lea    rcx,[r14+0x28]
   1817f3e23:	e8 74 7a cb 05       	call   0x1874ab89c
   1817f3e28:	90                   	nop
   1817f3e29:	48 85 c0             	test   rax,rax
   1817f3e2c:	0f 85 66 01 00 00    	jne    0x1817f3f98
   1817f3e32:	e9 44 0a 00 00       	jmp    0x1817f487b
   1817f3e37:	49 8d 4e 01          	lea    rcx,[r14+0x1]
   1817f3e3b:	e8 5c 7a cb 05       	call   0x1874ab89c
   1817f3e40:	90                   	nop
   1817f3e41:	e9 b1 02 00 00       	jmp    0x1817f40f7
   1817f3e46:	31 c0                	xor    eax,eax
   1817f3e48:	48 8b 09             	mov    rcx,QWORD PTR [rcx]
   1817f3e4b:	48 89 8d 10 01 00 00 	mov    QWORD PTR [rbp+0x110],rcx
   1817f3e52:	48 89 85 18 01 00 00 	mov    QWORD PTR [rbp+0x118],rax
   1817f3e59:	48 8d 95 e0 01 00 00 	lea    rdx,[rbp+0x1e0]
   1817f3e60:	4c 8d 85 10 01 00 00 	lea    r8,[rbp+0x110]
   1817f3e67:	48 89 f9             	mov    rcx,rdi
   1817f3e6a:	e8 81 d6 fa ff       	call   0x1817a14f0
   1817f3e6f:	90                   	nop
   1817f3e70:	48 83 bd e0 01 00 00 	cmp    QWORD PTR [rbp+0x1e0],0x0
   1817f3e77:	00 
   1817f3e78:	0f 84 2e 01 00 00    	je     0x1817f3fac
   1817f3e7e:	48 8b 85 c0 02 00 00 	mov    rax,QWORD PTR [rbp+0x2c0]
   1817f3e85:	48 8b 08             	mov    rcx,QWORD PTR [rax]
   1817f3e88:	ba 03 00 00 00       	mov    edx,0x3
   1817f3e8d:	e8 9e 2c 19 02       	call   0x183986b30
   1817f3e92:	90                   	nop
   1817f3e93:	48 8b 8d e0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1e0]
   1817f3e9a:	0f 57 c0             	xorps  xmm0,xmm0
   1817f3e9d:	0f 29 85 20 01 00 00 	movaps XMMWORD PTR [rbp+0x120],xmm0
   1817f3ea4:	48 8b 95 c0 02 00 00 	mov    rdx,QWORD PTR [rbp+0x2c0]
   1817f3eab:	48 8b 42 08          	mov    rax,QWORD PTR [rdx+0x8]
   1817f3eaf:	48 85 c0             	test   rax,rax
   1817f3eb2:	0f 84 9b 02 00 00    	je     0x1817f4153
   1817f3eb8:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   1817f3ebc:	48 8b 42 08          	mov    rax,QWORD PTR [rdx+0x8]
   1817f3ec0:	e9 90 02 00 00       	jmp    0x1817f4155
   1817f3ec5:	31 db                	xor    ebx,ebx
   1817f3ec7:	48 8b 50 18          	mov    rdx,QWORD PTR [rax+0x18]
   1817f3ecb:	48 89 95 30 01 00 00 	mov    QWORD PTR [rbp+0x130],rdx
   1817f3ed2:	48 89 9d 38 01 00 00 	mov    QWORD PTR [rbp+0x138],rbx
   1817f3ed9:	48 89 f9             	mov    rcx,rdi
   1817f3edc:	e8 2f a2 f9 ff       	call   0x18178e110
   1817f3ee1:	90                   	nop
   1817f3ee2:	48 85 db             	test   rbx,rbx
   1817f3ee5:	74 1d                	je     0x1817f3f04
   1817f3ee7:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   1817f3eeb:	75 17                	jne    0x1817f3f04
   1817f3eed:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1817f3ef0:	48 89 d9             	mov    rcx,rbx
   1817f3ef3:	ff 10                	call   QWORD PTR [rax]
   1817f3ef5:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   1817f3ef9:	75 09                	jne    0x1817f3f04
   1817f3efb:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1817f3efe:	48 89 d9             	mov    rcx,rbx
   1817f3f01:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1817f3f04:	48 8b 85 80 02 00 00 	mov    rax,QWORD PTR [rbp+0x280]
   1817f3f0b:	48 89 06             	mov    QWORD PTR [rsi],rax
   1817f3f0e:	0f 57 c0             	xorps  xmm0,xmm0
   1817f3f11:	0f 11 46 08          	movups XMMWORD PTR [rsi+0x8],xmm0
   1817f3f15:	0f 11 46 18          	movups XMMWORD PTR [rsi+0x18],xmm0
   1817f3f19:	48 8b bd 98 02 00 00 	mov    rdi,QWORD PTR [rbp+0x298]
   1817f3f20:	48 83 bd a0 02 00 00 	cmp    QWORD PTR [rbp+0x2a0],0x10
   1817f3f27:	10 
   1817f3f28:	72 09                	jb     0x1817f3f33
   1817f3f2a:	48 8b 9d 88 02 00 00 	mov    rbx,QWORD PTR [rbp+0x288]
   1817f3f31:	eb 07                	jmp    0x1817f3f3a
   1817f3f33:	48 8d 9d 88 02 00 00 	lea    rbx,[rbp+0x288]
   1817f3f3a:	48 85 ff             	test   rdi,rdi
   1817f3f3d:	0f 88 44 09 00 00    	js     0x1817f4887
   1817f3f43:	48 83 ff 0f          	cmp    rdi,0xf
   1817f3f47:	77 1b                	ja     0x1817f3f64
   1817f3f49:	48 8d 46 08          	lea    rax,[rsi+0x8]
   1817f3f4d:	48 89 7e 18          	mov    QWORD PTR [rsi+0x18],rdi
   1817f3f51:	48 c7 46 20 0f 00 00 	mov    QWORD PTR [rsi+0x20],0xf
   1817f3f58:	00 
   1817f3f59:	0f 10 03             	movups xmm0,XMMWORD PTR [rbx]
   1817f3f5c:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   1817f3f5f:	e9 b0 01 00 00       	jmp    0x1817f4114
   1817f3f64:	48 89 f8             	mov    rax,rdi
   1817f3f67:	48 83 c8 0f          	or     rax,0xf
   1817f3f6b:	48 83 f8 17          	cmp    rax,0x17
   1817f3f6f:	41 be 16 00 00 00    	mov    r14d,0x16
   1817f3f75:	4c 0f 43 f0          	cmovae r14,rax
   1817f3f79:	48 3d ff 0f 00 00    	cmp    rax,0xfff
   1817f3f7f:	0f 82 68 01 00 00    	jb     0x1817f40ed
   1817f3f85:	49 8d 4e 28          	lea    rcx,[r14+0x28]
   1817f3f89:	e8 0e 79 cb 05       	call   0x1874ab89c
   1817f3f8e:	90                   	nop
   1817f3f8f:	48 85 c0             	test   rax,rax
   1817f3f92:	0f 84 e3 08 00 00    	je     0x1817f487b
   1817f3f98:	48 89 c1             	mov    rcx,rax
   1817f3f9b:	48 83 c0 27          	add    rax,0x27
   1817f3f9f:	48 83 e0 e0          	and    rax,0xffffffffffffffe0
   1817f3fa3:	48 89 48 f8          	mov    QWORD PTR [rax-0x8],rcx
   1817f3fa7:	e9 4b 01 00 00       	jmp    0x1817f40f7
   1817f3fac:	b9 04 00 00 00       	mov    ecx,0x4
   1817f3fb1:	e8 2a 8e 87 fe       	call   0x18006cde0
   1817f3fb6:	85 c0                	test   eax,eax
   1817f3fb8:	0f 84 f8 00 00 00    	je     0x1817f40b6
   1817f3fbe:	48 8d 7d 60          	lea    rdi,[rbp+0x60]
   1817f3fc2:	48 89 f9             	mov    rcx,rdi
   1817f3fc5:	e8 46 8f 87 fe       	call   0x18006cf10
   1817f3fca:	90                   	nop
   1817f3fcb:	48 83 7d 78 10       	cmp    QWORD PTR [rbp+0x78],0x10
   1817f3fd0:	72 04                	jb     0x1817f3fd6
   1817f3fd2:	48 8b 7d 60          	mov    rdi,QWORD PTR [rbp+0x60]
   1817f3fd6:	48 8d 05 b3 b6 8e 07 	lea    rax,[rip+0x78eb6b3]        # 0x1890df690
   1817f3fdd:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1817f3fe2:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   1817f3fe9:	00 00 
   1817f3feb:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   1817f3ff0:	c7 44 24 28 75 10 00 	mov    DWORD PTR [rsp+0x28],0x1075
   1817f3ff7:	00 
   1817f3ff8:	4c 8d 0d f9 7d 8e 07 	lea    r9,[rip+0x78e7df9]        # 0x1890dbdf8
   1817f3fff:	48 8d 8d 30 01 00 00 	lea    rcx,[rbp+0x130]
   1817f4006:	ba 04 00 00 00       	mov    edx,0x4
   1817f400b:	49 89 f8             	mov    r8,rdi
   1817f400e:	e8 5d 92 87 fe       	call   0x18006d270
   1817f4013:	90                   	nop
   1817f4014:	0f 57 c0             	xorps  xmm0,xmm0
   1817f4017:	0f 29 85 70 02 00 00 	movaps XMMWORD PTR [rbp+0x270],xmm0
   1817f401e:	0f 29 85 60 02 00 00 	movaps XMMWORD PTR [rbp+0x260],xmm0
   1817f4025:	0f 29 85 50 02 00 00 	movaps XMMWORD PTR [rbp+0x250],xmm0
   1817f402c:	0f 29 85 40 02 00 00 	movaps XMMWORD PTR [rbp+0x240],xmm0
   1817f4033:	0f 29 85 30 02 00 00 	movaps XMMWORD PTR [rbp+0x230],xmm0
   1817f403a:	0f 29 85 20 02 00 00 	movaps XMMWORD PTR [rbp+0x220],xmm0
   1817f4041:	0f 29 85 10 02 00 00 	movaps XMMWORD PTR [rbp+0x210],xmm0
   1817f4048:	0f 29 85 00 02 00 00 	movaps XMMWORD PTR [rbp+0x200],xmm0
   1817f404f:	48 8d 15 1a 29 8f 07 	lea    rdx,[rip+0x78f291a]        # 0x1890e6970
   1817f4056:	48 8d 8d 30 01 00 00 	lea    rcx,[rbp+0x130]
   1817f405d:	4c 8d 85 00 02 00 00 	lea    r8,[rbp+0x200]
   1817f4064:	e8 a7 97 87 fe       	call   0x18006d810
   1817f4069:	90                   	nop
   1817f406a:	48 8d 8d 30 01 00 00 	lea    rcx,[rbp+0x130]
   1817f4071:	e8 fa 92 87 fe       	call   0x18006d370
   1817f4076:	48 8b 45 78          	mov    rax,QWORD PTR [rbp+0x78]
   1817f407a:	48 83 f8 10          	cmp    rax,0x10
   1817f407e:	72 36                	jb     0x1817f40b6
   1817f4080:	48 8b 4d 60          	mov    rcx,QWORD PTR [rbp+0x60]
   1817f4084:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1817f4088:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1817f408f:	72 1f                	jb     0x1817f40b0
   1817f4091:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1817f4095:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1817f4099:	4c 29 c1             	sub    rcx,r8
   1817f409c:	48 83 f9 20          	cmp    rcx,0x20
   1817f40a0:	0f 83 d5 07 00 00    	jae    0x1817f487b
   1817f40a6:	48 83 c0 28          	add    rax,0x28
   1817f40aa:	48 89 c2             	mov    rdx,rax
   1817f40ad:	4c 89 c1             	mov    rcx,r8
   1817f40b0:	e8 2b 78 cb 05       	call   0x1874ab8e0
   1817f40b5:	90                   	nop
   1817f40b6:	c7 44 24 20 04 00 00 	mov    DWORD PTR [rsp+0x20],0x4
   1817f40bd:	00 
   1817f40be:	48 89 f1             	mov    rcx,rsi
   1817f40c1:	ba 01 00 00 00       	mov    edx,0x1
   1817f40c6:	41 b8 01 00 00 00    	mov    r8d,0x1
   1817f40cc:	41 b9 04 00 00 00    	mov    r9d,0x4
   1817f40d2:	e8 d9 3c 19 02       	call   0x183987db0
   1817f40d7:	90                   	nop
   1817f40d8:	48 8b bd e8 01 00 00 	mov    rdi,QWORD PTR [rbp+0x1e8]
   1817f40df:	48 85 ff             	test   rdi,rdi
   1817f40e2:	0f 85 80 06 00 00    	jne    0x1817f4768
   1817f40e8:	e9 98 06 00 00       	jmp    0x1817f4785
   1817f40ed:	49 8d 4e 01          	lea    rcx,[r14+0x1]
   1817f40f1:	e8 a6 77 cb 05       	call   0x1874ab89c
   1817f40f6:	90                   	nop
   1817f40f7:	48 89 46 08          	mov    QWORD PTR [rsi+0x8],rax
   1817f40fb:	48 89 7e 18          	mov    QWORD PTR [rsi+0x18],rdi
   1817f40ff:	4c 89 76 20          	mov    QWORD PTR [rsi+0x20],r14
   1817f4103:	48 ff c7             	inc    rdi
   1817f4106:	48 89 c1             	mov    rcx,rax
   1817f4109:	48 89 da             	mov    rdx,rbx
   1817f410c:	49 89 f8             	mov    r8,rdi
   1817f410f:	e8 3c ff d4 05       	call   0x187544050
   1817f4114:	0f 57 c0             	xorps  xmm0,xmm0
   1817f4117:	0f 11 46 28          	movups XMMWORD PTR [rsi+0x28],xmm0
   1817f411b:	48 8b 85 b0 02 00 00 	mov    rax,QWORD PTR [rbp+0x2b0]
   1817f4122:	48 85 c0             	test   rax,rax
   1817f4125:	74 0d                	je     0x1817f4134
   1817f4127:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   1817f412b:	48 8b bd b0 02 00 00 	mov    rdi,QWORD PTR [rbp+0x2b0]
   1817f4132:	eb 02                	jmp    0x1817f4136
   1817f4134:	31 ff                	xor    edi,edi
   1817f4136:	48 8b 85 a8 02 00 00 	mov    rax,QWORD PTR [rbp+0x2a8]
   1817f413d:	48 89 46 28          	mov    QWORD PTR [rsi+0x28],rax
   1817f4141:	48 89 7e 30          	mov    QWORD PTR [rsi+0x30],rdi
   1817f4145:	48 85 ff             	test   rdi,rdi
   1817f4148:	0f 85 43 06 00 00    	jne    0x1817f4791
   1817f414e:	e9 5b 06 00 00       	jmp    0x1817f47ae
   1817f4153:	31 c0                	xor    eax,eax
   1817f4155:	48 8b 12             	mov    rdx,QWORD PTR [rdx]
   1817f4158:	48 89 95 20 01 00 00 	mov    QWORD PTR [rbp+0x120],rdx
   1817f415f:	48 89 85 28 01 00 00 	mov    QWORD PTR [rbp+0x128],rax
   1817f4166:	48 8d 95 30 01 00 00 	lea    rdx,[rbp+0x130]
   1817f416d:	4c 8d 85 20 01 00 00 	lea    r8,[rbp+0x120]
   1817f4174:	e8 b7 08 18 02       	call   0x183974a30
   1817f4179:	90                   	nop
   1817f417a:	48 8b 85 30 01 00 00 	mov    rax,QWORD PTR [rbp+0x130]
   1817f4181:	48 8b 9d 48 01 00 00 	mov    rbx,QWORD PTR [rbp+0x148]
   1817f4188:	48 89 85 80 02 00 00 	mov    QWORD PTR [rbp+0x280],rax
   1817f418f:	48 83 bd 50 01 00 00 	cmp    QWORD PTR [rbp+0x150],0x10
   1817f4196:	10 
   1817f4197:	72 46                	jb     0x1817f41df
   1817f4199:	4c 8b 8d 38 01 00 00 	mov    r9,QWORD PTR [rbp+0x138]
   1817f41a0:	48 8d bd 88 02 00 00 	lea    rdi,[rbp+0x288]
   1817f41a7:	48 8b 85 a0 02 00 00 	mov    rax,QWORD PTR [rbp+0x2a0]
   1817f41ae:	48 39 c3             	cmp    rbx,rax
   1817f41b1:	77 46                	ja     0x1817f41f9
   1817f41b3:	49 89 fe             	mov    r14,rdi
   1817f41b6:	48 83 f8 10          	cmp    rax,0x10
   1817f41ba:	72 07                	jb     0x1817f41c3
   1817f41bc:	4c 8b b5 88 02 00 00 	mov    r14,QWORD PTR [rbp+0x288]
   1817f41c3:	48 89 9d 98 02 00 00 	mov    QWORD PTR [rbp+0x298],rbx
   1817f41ca:	4c 89 f1             	mov    rcx,r14
   1817f41cd:	4c 89 ca             	mov    rdx,r9
   1817f41d0:	49 89 d8             	mov    r8,rbx
   1817f41d3:	e8 78 fe d4 05       	call   0x187544050
   1817f41d8:	41 c6 04 1e 00       	mov    BYTE PTR [r14+rbx*1],0x0
   1817f41dd:	eb 26                	jmp    0x1817f4205
   1817f41df:	4c 8d 8d 38 01 00 00 	lea    r9,[rbp+0x138]
   1817f41e6:	48 8d bd 88 02 00 00 	lea    rdi,[rbp+0x288]
   1817f41ed:	48 8b 85 a0 02 00 00 	mov    rax,QWORD PTR [rbp+0x2a0]
   1817f41f4:	48 39 c3             	cmp    rbx,rax
   1817f41f7:	76 ba                	jbe    0x1817f41b3
   1817f41f9:	48 89 f9             	mov    rcx,rdi
   1817f41fc:	48 89 da             	mov    rdx,rbx
   1817f41ff:	e8 4c 9f 84 fe       	call   0x18003e150
   1817f4204:	90                   	nop
   1817f4205:	48 8b 85 60 01 00 00 	mov    rax,QWORD PTR [rbp+0x160]
   1817f420c:	48 85 c0             	test   rax,rax
   1817f420f:	74 0d                	je     0x1817f421e
   1817f4211:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   1817f4215:	48 8b 85 60 01 00 00 	mov    rax,QWORD PTR [rbp+0x160]
   1817f421c:	eb 02                	jmp    0x1817f4220
   1817f421e:	31 c0                	xor    eax,eax
   1817f4220:	4c 8b b5 c0 02 00 00 	mov    r14,QWORD PTR [rbp+0x2c0]
   1817f4227:	48 8b 8d 58 01 00 00 	mov    rcx,QWORD PTR [rbp+0x158]
   1817f422e:	48 89 8d a8 02 00 00 	mov    QWORD PTR [rbp+0x2a8],rcx
   1817f4235:	48 8b 9d b0 02 00 00 	mov    rbx,QWORD PTR [rbp+0x2b0]
   1817f423c:	48 89 85 b0 02 00 00 	mov    QWORD PTR [rbp+0x2b0],rax
   1817f4243:	48 85 db             	test   rbx,rbx
   1817f4246:	74 1d                	je     0x1817f4265
   1817f4248:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   1817f424c:	75 17                	jne    0x1817f4265
   1817f424e:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1817f4251:	48 89 d9             	mov    rcx,rbx
   1817f4254:	ff 10                	call   QWORD PTR [rax]
   1817f4256:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   1817f425a:	75 09                	jne    0x1817f4265
   1817f425c:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1817f425f:	48 89 d9             	mov    rcx,rbx
   1817f4262:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1817f4265:	48 8b 9d 60 01 00 00 	mov    rbx,QWORD PTR [rbp+0x160]
   1817f426c:	48 85 db             	test   rbx,rbx
   1817f426f:	74 1d                	je     0x1817f428e
   1817f4271:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   1817f4275:	75 17                	jne    0x1817f428e
   1817f4277:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1817f427a:	48 89 d9             	mov    rcx,rbx
   1817f427d:	ff 10                	call   QWORD PTR [rax]
   1817f427f:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   1817f4283:	75 09                	jne    0x1817f428e
   1817f4285:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1817f4288:	48 89 d9             	mov    rcx,rbx
   1817f428b:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1817f428e:	48 8b 85 50 01 00 00 	mov    rax,QWORD PTR [rbp+0x150]
   1817f4295:	48 83 f8 10          	cmp    rax,0x10
   1817f4299:	72 38                	jb     0x1817f42d3
   1817f429b:	48 8b 8d 38 01 00 00 	mov    rcx,QWORD PTR [rbp+0x138]
   1817f42a2:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1817f42a6:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1817f42ad:	72 1f                	jb     0x1817f42ce
   1817f42af:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1817f42b3:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1817f42b7:	4c 29 c1             	sub    rcx,r8
   1817f42ba:	48 83 f9 20          	cmp    rcx,0x20
   1817f42be:	0f 83 b7 05 00 00    	jae    0x1817f487b
   1817f42c4:	48 83 c0 28          	add    rax,0x28
   1817f42c8:	48 89 c2             	mov    rdx,rax
   1817f42cb:	4c 89 c1             	mov    rcx,r8
   1817f42ce:	e8 0d 76 cb 05       	call   0x1874ab8e0
   1817f42d3:	49 8b 0e             	mov    rcx,QWORD PTR [r14]
   1817f42d6:	48 8d 9d 30 01 00 00 	lea    rbx,[rbp+0x130]
   1817f42dd:	48 89 da             	mov    rdx,rbx
   1817f42e0:	e8 eb 13 19 02       	call   0x1839856d0
   1817f42e5:	90                   	nop
   1817f42e6:	48 c7 85 08 02 00 00 	mov    QWORD PTR [rbp+0x208],0x0
   1817f42ed:	00 00 00 00 
   1817f42f1:	b9 20 00 00 00       	mov    ecx,0x20
   1817f42f6:	e8 a1 75 cb 05       	call   0x1874ab89c
   1817f42fb:	90                   	nop
   1817f42fc:	48 89 85 00 02 00 00 	mov    QWORD PTR [rbp+0x200],rax
   1817f4303:	48 c7 85 10 02 00 00 	mov    QWORD PTR [rbp+0x210],0x14
   1817f430a:	14 00 00 00 
   1817f430e:	48 c7 85 18 02 00 00 	mov    QWORD PTR [rbp+0x218],0x1f
   1817f4315:	1f 00 00 00 
   1817f4319:	0f 10 05 a8 13 8e 07 	movups xmm0,XMMWORD PTR [rip+0x78e13a8]        # 0x1890d56c8
   1817f4320:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   1817f4323:	c7 40 10 73 61 67 65 	mov    DWORD PTR [rax+0x10],0x65676173
   1817f432a:	c6 40 14 00          	mov    BYTE PTR [rax+0x14],0x0
   1817f432e:	4c 8b b5 40 01 00 00 	mov    r14,QWORD PTR [rbp+0x140]
   1817f4335:	48 83 bd 48 01 00 00 	cmp    QWORD PTR [rbp+0x148],0x10
   1817f433c:	10 
   1817f433d:	72 07                	jb     0x1817f4346
   1817f433f:	48 8b 9d 30 01 00 00 	mov    rbx,QWORD PTR [rbp+0x130]
   1817f4346:	49 83 fe 0b          	cmp    r14,0xb
   1817f434a:	76 1a                	jbe    0x1817f4366
   1817f434c:	4c 89 74 24 20       	mov    QWORD PTR [rsp+0x20],r14
   1817f4351:	48 8d 8d 00 02 00 00 	lea    rcx,[rbp+0x200]
   1817f4358:	4c 89 f2             	mov    rdx,r14
   1817f435b:	49 89 d9             	mov    r9,rbx
   1817f435e:	e8 5d 50 81 fe       	call   0x1800093c0
   1817f4363:	90                   	nop
   1817f4364:	eb 2d                	jmp    0x1817f4393
   1817f4366:	48 89 c1             	mov    rcx,rax
   1817f4369:	48 83 c1 14          	add    rcx,0x14
   1817f436d:	49 8d 56 14          	lea    rdx,[r14+0x14]
   1817f4371:	48 89 95 10 02 00 00 	mov    QWORD PTR [rbp+0x210],rdx
   1817f4378:	48 89 da             	mov    rdx,rbx
   1817f437b:	4d 89 f0             	mov    r8,r14
   1817f437e:	48 89 c3             	mov    rbx,rax
   1817f4381:	e8 ca fc d4 05       	call   0x187544050
   1817f4386:	42 c6 44 33 14 00    	mov    BYTE PTR [rbx+r14*1+0x14],0x0
   1817f438c:	48 8d 85 00 02 00 00 	lea    rax,[rbp+0x200]
   1817f4393:	0f 10 00             	movups xmm0,XMMWORD PTR [rax]
   1817f4396:	0f 10 48 10          	movups xmm1,XMMWORD PTR [rax+0x10]
   1817f439a:	0f 29 4d f0          	movaps XMMWORD PTR [rbp-0x10],xmm1
   1817f439e:	0f 29 45 e0          	movaps XMMWORD PTR [rbp-0x20],xmm0
   1817f43a2:	48 c7 40 10 00 00 00 	mov    QWORD PTR [rax+0x10],0x0
   1817f43a9:	00 
   1817f43aa:	48 c7 40 18 0f 00 00 	mov    QWORD PTR [rax+0x18],0xf
   1817f43b1:	00 
   1817f43b2:	c6 00 00             	mov    BYTE PTR [rax],0x0
   1817f43b5:	48 8d 8d b0 00 00 00 	lea    rcx,[rbp+0xb0]
   1817f43bc:	48 8d 55 e0          	lea    rdx,[rbp-0x20]
   1817f43c0:	41 b8 32 00 00 00    	mov    r8d,0x32
   1817f43c6:	e8 25 0d 7d ff       	call   0x180fc50f0
   1817f43cb:	90                   	nop
   1817f43cc:	48 8b 85 18 02 00 00 	mov    rax,QWORD PTR [rbp+0x218]
   1817f43d3:	48 83 f8 10          	cmp    rax,0x10
   1817f43d7:	72 38                	jb     0x1817f4411
   1817f43d9:	48 8b 8d 00 02 00 00 	mov    rcx,QWORD PTR [rbp+0x200]
   1817f43e0:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1817f43e4:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1817f43eb:	72 1f                	jb     0x1817f440c
   1817f43ed:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1817f43f1:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1817f43f5:	4c 29 c1             	sub    rcx,r8
   1817f43f8:	48 83 f9 20          	cmp    rcx,0x20
   1817f43fc:	0f 83 79 04 00 00    	jae    0x1817f487b
   1817f4402:	48 83 c0 28          	add    rax,0x28
   1817f4406:	48 89 c2             	mov    rdx,rax
   1817f4409:	4c 89 c1             	mov    rcx,r8
   1817f440c:	e8 cf 74 cb 05       	call   0x1874ab8e0
   1817f4411:	48 8b 85 48 01 00 00 	mov    rax,QWORD PTR [rbp+0x148]
   1817f4418:	48 83 f8 10          	cmp    rax,0x10
   1817f441c:	72 38                	jb     0x1817f4456
   1817f441e:	48 8b 8d 30 01 00 00 	mov    rcx,QWORD PTR [rbp+0x130]
   1817f4425:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1817f4429:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1817f4430:	72 1f                	jb     0x1817f4451
   1817f4432:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1817f4436:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1817f443a:	4c 29 c1             	sub    rcx,r8
   1817f443d:	48 83 f9 20          	cmp    rcx,0x20
   1817f4441:	0f 83 34 04 00 00    	jae    0x1817f487b
   1817f4447:	48 83 c0 28          	add    rax,0x28
   1817f444b:	48 89 c2             	mov    rdx,rax
   1817f444e:	4c 89 c1             	mov    rcx,r8
   1817f4451:	e8 8a 74 cb 05       	call   0x1874ab8e0
   1817f4456:	8b 85 84 02 00 00    	mov    eax,DWORD PTR [rbp+0x284]
   1817f445c:	0b 85 80 02 00 00    	or     eax,DWORD PTR [rbp+0x280]
   1817f4462:	0f 84 f8 01 00 00    	je     0x1817f4660
   1817f4468:	b9 04 00 00 00       	mov    ecx,0x4
   1817f446d:	e8 6e 89 87 fe       	call   0x18006cde0
   1817f4472:	85 c0                	test   eax,eax
   1817f4474:	0f 84 7d 01 00 00    	je     0x1817f45f7
   1817f447a:	48 89 eb             	mov    rbx,rbp
   1817f447d:	48 89 d9             	mov    rcx,rbx
   1817f4480:	e8 8b 8a 87 fe       	call   0x18006cf10
   1817f4485:	90                   	nop
   1817f4486:	48 83 7d 18 10       	cmp    QWORD PTR [rbp+0x18],0x10
   1817f448b:	72 04                	jb     0x1817f4491
   1817f448d:	48 8b 5d 00          	mov    rbx,QWORD PTR [rbp+0x0]
   1817f4491:	48 8d 05 f8 b1 8e 07 	lea    rax,[rip+0x78eb1f8]        # 0x1890df690
   1817f4498:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1817f449d:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   1817f44a4:	00 00 
   1817f44a6:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   1817f44ab:	c7 44 24 28 7d 10 00 	mov    DWORD PTR [rsp+0x28],0x107d
   1817f44b2:	00 
   1817f44b3:	4c 8d 0d 3e 79 8e 07 	lea    r9,[rip+0x78e793e]        # 0x1890dbdf8
   1817f44ba:	48 8d 8d 30 01 00 00 	lea    rcx,[rbp+0x130]
   1817f44c1:	ba 04 00 00 00       	mov    edx,0x4
   1817f44c6:	49 89 d8             	mov    r8,rbx
   1817f44c9:	e8 a2 8d 87 fe       	call   0x18006d270
   1817f44ce:	90                   	nop
   1817f44cf:	48 8b 85 c0 02 00 00 	mov    rax,QWORD PTR [rbp+0x2c0]
   1817f44d6:	48 8b 08             	mov    rcx,QWORD PTR [rax]
   1817f44d9:	48 8d 9d c0 01 00 00 	lea    rbx,[rbp+0x1c0]
   1817f44e0:	48 89 da             	mov    rdx,rbx
   1817f44e3:	e8 e8 11 19 02       	call   0x1839856d0
   1817f44e8:	90                   	nop
   1817f44e9:	48 83 bd d8 01 00 00 	cmp    QWORD PTR [rbp+0x1d8],0x10
   1817f44f0:	10 
   1817f44f1:	72 07                	jb     0x1817f44fa
   1817f44f3:	48 8b 9d c0 01 00 00 	mov    rbx,QWORD PTR [rbp+0x1c0]
   1817f44fa:	48 89 5d 60          	mov    QWORD PTR [rbp+0x60],rbx
   1817f44fe:	c6 45 68 00          	mov    BYTE PTR [rbp+0x68],0x0
   1817f4502:	0f 57 c0             	xorps  xmm0,xmm0
   1817f4505:	0f 11 85 68 02 00 00 	movups XMMWORD PTR [rbp+0x268],xmm0
   1817f450c:	0f 11 85 58 02 00 00 	movups XMMWORD PTR [rbp+0x258],xmm0
   1817f4513:	0f 11 85 48 02 00 00 	movups XMMWORD PTR [rbp+0x248],xmm0
   1817f451a:	0f 11 85 38 02 00 00 	movups XMMWORD PTR [rbp+0x238],xmm0
   1817f4521:	0f 11 85 28 02 00 00 	movups XMMWORD PTR [rbp+0x228],xmm0
   1817f4528:	0f 11 85 18 02 00 00 	movups XMMWORD PTR [rbp+0x218],xmm0
   1817f452f:	0f 11 85 08 02 00 00 	movups XMMWORD PTR [rbp+0x208],xmm0
   1817f4536:	48 c7 85 78 02 00 00 	mov    QWORD PTR [rbp+0x278],0x0
   1817f453d:	00 00 00 00 
   1817f4541:	48 8d 45 60          	lea    rax,[rbp+0x60]
   1817f4545:	48 89 85 00 02 00 00 	mov    QWORD PTR [rbp+0x200],rax
   1817f454c:	48 8d 15 8d d0 8e 07 	lea    rdx,[rip+0x78ed08d]        # 0x1890e15e0
   1817f4553:	48 8d 8d 30 01 00 00 	lea    rcx,[rbp+0x130]
   1817f455a:	4c 8d 85 00 02 00 00 	lea    r8,[rbp+0x200]
   1817f4561:	e8 aa 92 87 fe       	call   0x18006d810
   1817f4566:	90                   	nop
   1817f4567:	48 8b 85 d8 01 00 00 	mov    rax,QWORD PTR [rbp+0x1d8]
   1817f456e:	48 83 f8 10          	cmp    rax,0x10
   1817f4572:	72 38                	jb     0x1817f45ac
   1817f4574:	48 8b 8d c0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1c0]
   1817f457b:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1817f457f:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1817f4586:	72 1f                	jb     0x1817f45a7
   1817f4588:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1817f458c:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1817f4590:	4c 29 c1             	sub    rcx,r8
   1817f4593:	48 83 f9 20          	cmp    rcx,0x20
   1817f4597:	0f 83 de 02 00 00    	jae    0x1817f487b
   1817f459d:	48 83 c0 28          	add    rax,0x28
   1817f45a1:	48 89 c2             	mov    rdx,rax
   1817f45a4:	4c 89 c1             	mov    rcx,r8
   1817f45a7:	e8 34 73 cb 05       	call   0x1874ab8e0
   1817f45ac:	48 8d 8d 30 01 00 00 	lea    rcx,[rbp+0x130]
   1817f45b3:	e8 b8 8d 87 fe       	call   0x18006d370
   1817f45b8:	48 8b 45 18          	mov    rax,QWORD PTR [rbp+0x18]
   1817f45bc:	48 83 f8 10          	cmp    rax,0x10
   1817f45c0:	72 35                	jb     0x1817f45f7
   1817f45c2:	48 8b 4d 00          	mov    rcx,QWORD PTR [rbp+0x0]
   1817f45c6:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1817f45ca:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1817f45d1:	72 1f                	jb     0x1817f45f2
   1817f45d3:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1817f45d7:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1817f45db:	4c 29 c1             	sub    rcx,r8
   1817f45de:	48 83 f9 20          	cmp    rcx,0x20
   1817f45e2:	0f 83 93 02 00 00    	jae    0x1817f487b
   1817f45e8:	48 83 c0 28          	add    rax,0x28
   1817f45ec:	48 89 c2             	mov    rdx,rax
   1817f45ef:	4c 89 c1             	mov    rcx,r8
   1817f45f2:	e8 e9 72 cb 05       	call   0x1874ab8e0
   1817f45f7:	48 8b 85 80 02 00 00 	mov    rax,QWORD PTR [rbp+0x280]
   1817f45fe:	48 89 06             	mov    QWORD PTR [rsi],rax
   1817f4601:	0f 57 c0             	xorps  xmm0,xmm0
   1817f4604:	0f 11 46 08          	movups XMMWORD PTR [rsi+0x8],xmm0
   1817f4608:	0f 11 46 18          	movups XMMWORD PTR [rsi+0x18],xmm0
   1817f460c:	48 8b 9d 98 02 00 00 	mov    rbx,QWORD PTR [rbp+0x298]
   1817f4613:	48 83 bd a0 02 00 00 	cmp    QWORD PTR [rbp+0x2a0],0x10
   1817f461a:	10 
   1817f461b:	72 07                	jb     0x1817f4624
   1817f461d:	48 8b bd 88 02 00 00 	mov    rdi,QWORD PTR [rbp+0x288]
   1817f4624:	48 85 db             	test   rbx,rbx
   1817f4627:	0f 88 66 02 00 00    	js     0x1817f4893
   1817f462d:	48 83 fb 0f          	cmp    rbx,0xf
   1817f4631:	76 69                	jbe    0x1817f469c
   1817f4633:	48 89 d8             	mov    rax,rbx
   1817f4636:	48 83 c8 0f          	or     rax,0xf
   1817f463a:	48 83 f8 17          	cmp    rax,0x17
   1817f463e:	41 be 16 00 00 00    	mov    r14d,0x16
   1817f4644:	4c 0f 43 f0          	cmovae r14,rax
   1817f4648:	48 3d ff 0f 00 00    	cmp    rax,0xfff
   1817f464e:	0f 82 ad 00 00 00    	jb     0x1817f4701
   1817f4654:	49 8d 4e 28          	lea    rcx,[r14+0x28]
   1817f4658:	e8 3f 72 cb 05       	call   0x1874ab89c
   1817f465d:	90                   	nop
   1817f465e:	eb 7b                	jmp    0x1817f46db
   1817f4660:	48 8b 85 80 02 00 00 	mov    rax,QWORD PTR [rbp+0x280]
   1817f4667:	48 89 06             	mov    QWORD PTR [rsi],rax
   1817f466a:	0f 57 c0             	xorps  xmm0,xmm0
   1817f466d:	0f 11 46 08          	movups XMMWORD PTR [rsi+0x8],xmm0
   1817f4671:	0f 11 46 18          	movups XMMWORD PTR [rsi+0x18],xmm0
   1817f4675:	48 8b 9d 98 02 00 00 	mov    rbx,QWORD PTR [rbp+0x298]
   1817f467c:	48 83 bd a0 02 00 00 	cmp    QWORD PTR [rbp+0x2a0],0x10
   1817f4683:	10 
   1817f4684:	72 07                	jb     0x1817f468d
   1817f4686:	48 8b bd 88 02 00 00 	mov    rdi,QWORD PTR [rbp+0x288]
   1817f468d:	48 85 db             	test   rbx,rbx
   1817f4690:	0f 88 f7 01 00 00    	js     0x1817f488d
   1817f4696:	48 83 fb 0f          	cmp    rbx,0xf
   1817f469a:	77 18                	ja     0x1817f46b4
   1817f469c:	48 8d 46 08          	lea    rax,[rsi+0x8]
   1817f46a0:	48 89 5e 18          	mov    QWORD PTR [rsi+0x18],rbx
   1817f46a4:	48 c7 46 20 0f 00 00 	mov    QWORD PTR [rsi+0x20],0xf
   1817f46ab:	00 
   1817f46ac:	0f 10 07             	movups xmm0,XMMWORD PTR [rdi]
   1817f46af:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   1817f46b2:	eb 74                	jmp    0x1817f4728
   1817f46b4:	48 89 d8             	mov    rax,rbx
   1817f46b7:	48 83 c8 0f          	or     rax,0xf
   1817f46bb:	48 83 f8 17          	cmp    rax,0x17
   1817f46bf:	41 be 16 00 00 00    	mov    r14d,0x16
   1817f46c5:	4c 0f 43 f0          	cmovae r14,rax
   1817f46c9:	48 3d ff 0f 00 00    	cmp    rax,0xfff
   1817f46cf:	72 24                	jb     0x1817f46f5
   1817f46d1:	49 8d 4e 28          	lea    rcx,[r14+0x28]
   1817f46d5:	e8 c2 71 cb 05       	call   0x1874ab89c
   1817f46da:	90                   	nop
   1817f46db:	48 85 c0             	test   rax,rax
   1817f46de:	0f 84 97 01 00 00    	je     0x1817f487b
   1817f46e4:	48 89 c1             	mov    rcx,rax
   1817f46e7:	48 83 c0 27          	add    rax,0x27
   1817f46eb:	48 83 e0 e0          	and    rax,0xffffffffffffffe0
   1817f46ef:	48 89 48 f8          	mov    QWORD PTR [rax-0x8],rcx
   1817f46f3:	eb 16                	jmp    0x1817f470b
   1817f46f5:	49 8d 4e 01          	lea    rcx,[r14+0x1]
   1817f46f9:	e8 9e 71 cb 05       	call   0x1874ab89c
   1817f46fe:	90                   	nop
   1817f46ff:	eb 0a                	jmp    0x1817f470b
   1817f4701:	49 8d 4e 01          	lea    rcx,[r14+0x1]
   1817f4705:	e8 92 71 cb 05       	call   0x1874ab89c
   1817f470a:	90                   	nop
   1817f470b:	48 89 46 08          	mov    QWORD PTR [rsi+0x8],rax
   1817f470f:	48 89 5e 18          	mov    QWORD PTR [rsi+0x18],rbx
   1817f4713:	4c 89 76 20          	mov    QWORD PTR [rsi+0x20],r14
   1817f4717:	48 ff c3             	inc    rbx
   1817f471a:	48 89 c1             	mov    rcx,rax
   1817f471d:	48 89 fa             	mov    rdx,rdi
   1817f4720:	49 89 d8             	mov    r8,rbx
   1817f4723:	e8 28 f9 d4 05       	call   0x187544050
   1817f4728:	48 8d 4e 28          	lea    rcx,[rsi+0x28]
   1817f472c:	0f 57 c0             	xorps  xmm0,xmm0
   1817f472f:	0f 11 46 28          	movups XMMWORD PTR [rsi+0x28],xmm0
   1817f4733:	48 8b 85 b0 02 00 00 	mov    rax,QWORD PTR [rbp+0x2b0]
   1817f473a:	48 85 c0             	test   rax,rax
   1817f473d:	74 0d                	je     0x1817f474c
   1817f473f:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   1817f4743:	48 8b 85 b0 02 00 00 	mov    rax,QWORD PTR [rbp+0x2b0]
   1817f474a:	eb 02                	jmp    0x1817f474e
   1817f474c:	31 c0                	xor    eax,eax
   1817f474e:	48 8b 95 a8 02 00 00 	mov    rdx,QWORD PTR [rbp+0x2a8]
   1817f4755:	48 89 11             	mov    QWORD PTR [rcx],rdx
   1817f4758:	48 89 46 30          	mov    QWORD PTR [rsi+0x30],rax
   1817f475c:	48 8b bd e8 01 00 00 	mov    rdi,QWORD PTR [rbp+0x1e8]
   1817f4763:	48 85 ff             	test   rdi,rdi
   1817f4766:	74 1d                	je     0x1817f4785
   1817f4768:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   1817f476c:	75 17                	jne    0x1817f4785
   1817f476e:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1817f4771:	48 89 f9             	mov    rcx,rdi
   1817f4774:	ff 10                	call   QWORD PTR [rax]
   1817f4776:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   1817f477a:	75 09                	jne    0x1817f4785
   1817f477c:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1817f477f:	48 89 f9             	mov    rcx,rdi
   1817f4782:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1817f4785:	48 8b bd b0 02 00 00 	mov    rdi,QWORD PTR [rbp+0x2b0]
   1817f478c:	48 85 ff             	test   rdi,rdi
   1817f478f:	74 1d                	je     0x1817f47ae
   1817f4791:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   1817f4795:	75 17                	jne    0x1817f47ae
   1817f4797:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1817f479a:	48 89 f9             	mov    rcx,rdi
   1817f479d:	ff 10                	call   QWORD PTR [rax]
   1817f479f:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   1817f47a3:	75 09                	jne    0x1817f47ae
   1817f47a5:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1817f47a8:	48 89 f9             	mov    rcx,rdi
   1817f47ab:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1817f47ae:	48 8b 85 a0 02 00 00 	mov    rax,QWORD PTR [rbp+0x2a0]
   1817f47b5:	48 83 f8 10          	cmp    rax,0x10
   1817f47b9:	48 8b bd c0 02 00 00 	mov    rdi,QWORD PTR [rbp+0x2c0]
   1817f47c0:	72 38                	jb     0x1817f47fa
   1817f47c2:	48 8b 8d 88 02 00 00 	mov    rcx,QWORD PTR [rbp+0x288]
   1817f47c9:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1817f47cd:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1817f47d4:	72 1f                	jb     0x1817f47f5
   1817f47d6:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1817f47da:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1817f47de:	4c 29 c1             	sub    rcx,r8
   1817f47e1:	48 83 f9 20          	cmp    rcx,0x20
   1817f47e5:	0f 83 90 00 00 00    	jae    0x1817f487b
   1817f47eb:	48 83 c0 28          	add    rax,0x28
   1817f47ef:	48 89 c2             	mov    rdx,rax
   1817f47f2:	4c 89 c1             	mov    rcx,r8
   1817f47f5:	e8 e6 70 cb 05       	call   0x1874ab8e0
   1817f47fa:	48 8b 85 f0 00 00 00 	mov    rax,QWORD PTR [rbp+0xf0]
   1817f4801:	48 83 f8 10          	cmp    rax,0x10
   1817f4805:	72 34                	jb     0x1817f483b
   1817f4807:	48 8b 8d d8 00 00 00 	mov    rcx,QWORD PTR [rbp+0xd8]
   1817f480e:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1817f4812:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1817f4819:	72 1b                	jb     0x1817f4836
   1817f481b:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1817f481f:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1817f4823:	4c 29 c1             	sub    rcx,r8
   1817f4826:	48 83 f9 20          	cmp    rcx,0x20
   1817f482a:	73 4f                	jae    0x1817f487b
   1817f482c:	48 83 c0 28          	add    rax,0x28
   1817f4830:	48 89 c2             	mov    rdx,rax
   1817f4833:	4c 89 c1             	mov    rcx,r8
   1817f4836:	e8 a5 70 cb 05       	call   0x1874ab8e0
   1817f483b:	48 8b 7f 08          	mov    rdi,QWORD PTR [rdi+0x8]
   1817f483f:	48 85 ff             	test   rdi,rdi
   1817f4842:	74 1d                	je     0x1817f4861
   1817f4844:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   1817f4848:	75 17                	jne    0x1817f4861
   1817f484a:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1817f484d:	48 89 f9             	mov    rcx,rdi
   1817f4850:	ff 10                	call   QWORD PTR [rax]
   1817f4852:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   1817f4856:	75 09                	jne    0x1817f4861
   1817f4858:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1817f485b:	48 89 f9             	mov    rcx,rdi
   1817f485e:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1817f4861:	48 89 f0             	mov    rax,rsi
   1817f4864:	0f 28 b5 d0 02 00 00 	movaps xmm6,XMMWORD PTR [rbp+0x2d0]
   1817f486b:	48 81 c4 68 03 00 00 	add    rsp,0x368
   1817f4872:	5b                   	pop    rbx
   1817f4873:	5f                   	pop    rdi
   1817f4874:	5e                   	pop    rsi
   1817f4875:	41 5e                	pop    r14
   1817f4877:	41 5f                	pop    r15
   1817f4879:	5d                   	pop    rbp
   1817f487a:	c3                   	ret
   1817f487b:	e8 0c 8b d1 05       	call   0x18750d38c
   1817f4880:	90                   	nop
   1817f4881:	e8 0a 43 81 fe       	call   0x180008b90
   1817f4886:	90                   	nop
   1817f4887:	e8 04 43 81 fe       	call   0x180008b90
   1817f488c:	90                   	nop
   1817f488d:	e8 fe 42 81 fe       	call   0x180008b90
   1817f4892:	90                   	nop
   1817f4893:	e8 f8 42 81 fe       	call   0x180008b90
   1817f4898:	90                   	nop
   1817f4899:	cc                   	int3
