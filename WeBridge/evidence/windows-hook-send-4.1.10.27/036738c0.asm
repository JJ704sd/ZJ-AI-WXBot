
.research\wechat-4.1.10.27-reference\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

00000001836738c0 <.text+0x36728c0>:
   1836738c0:	55                   	push   rbp
   1836738c1:	41 57                	push   r15
   1836738c3:	41 56                	push   r14
   1836738c5:	56                   	push   rsi
   1836738c6:	57                   	push   rdi
   1836738c7:	53                   	push   rbx
   1836738c8:	48 81 ec b8 00 00 00 	sub    rsp,0xb8
   1836738cf:	48 8d ac 24 80 00 00 	lea    rbp,[rsp+0x80]
   1836738d6:	00 
   1836738d7:	44 0f 29 45 20       	movaps XMMWORD PTR [rbp+0x20],xmm8
   1836738dc:	0f 29 7d 10          	movaps XMMWORD PTR [rbp+0x10],xmm7
   1836738e0:	0f 29 75 00          	movaps XMMWORD PTR [rbp+0x0],xmm6
   1836738e4:	48 c7 45 f8 fe ff ff 	mov    QWORD PTR [rbp-0x8],0xfffffffffffffffe
   1836738eb:	ff 
   1836738ec:	4c 89 c3             	mov    rbx,r8
   1836738ef:	48 89 d6             	mov    rsi,rdx
   1836738f2:	48 89 cf             	mov    rdi,rcx
   1836738f5:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   1836738f9:	4c 89 c2             	mov    rdx,r8
   1836738fc:	e8 8f 21 f2 ff       	call   0x183595a90
   183673901:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183673908:	00 
   183673909:	b9 20 00 00 00       	mov    ecx,0x20
   18367390e:	e8 e9 97 19 03       	call   0x18680d0fc
   183673913:	90                   	nop
   183673914:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183673918:	48 c7 45 e8 12 00 00 	mov    QWORD PTR [rbp-0x18],0x12
   18367391f:	00 
   183673920:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183673927:	00 
   183673928:	0f 10 35 32 ed 23 05 	movups xmm6,XMMWORD PTR [rip+0x523ed32]        # 0x1888b2661
   18367392f:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   183673932:	66 c7 40 10 65 72    	mov    WORD PTR [rax+0x10],0x7265
   183673938:	c6 40 12 00          	mov    BYTE PTR [rax+0x12],0x0
   18367393c:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183673940:	4c 8d 45 d8          	lea    r8,[rbp-0x28]
   183673944:	4c 8d 4d b0          	lea    r9,[rbp-0x50]
   183673948:	48 89 f9             	mov    rcx,rdi
   18367394b:	e8 30 5c 0a fe       	call   0x181719580
   183673950:	90                   	nop
   183673951:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   183673955:	48 83 f8 10          	cmp    rax,0x10
   183673959:	72 35                	jb     0x183673990
   18367395b:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18367395f:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183673963:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18367396a:	72 1f                	jb     0x18367398b
   18367396c:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183673970:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183673974:	4c 29 c1             	sub    rcx,r8
   183673977:	48 83 f9 20          	cmp    rcx,0x20
   18367397b:	0f 83 96 30 00 00    	jae    0x183676a17
   183673981:	48 83 c0 28          	add    rax,0x28
   183673985:	48 89 c2             	mov    rdx,rax
   183673988:	4c 89 c1             	mov    rcx,r8
   18367398b:	e8 b0 97 19 03       	call   0x18680d140
   183673990:	4c 8b 75 b8          	mov    r14,QWORD PTR [rbp-0x48]
   183673994:	4d 85 f6             	test   r14,r14
   183673997:	74 1f                	je     0x1836739b8
   183673999:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   18367399e:	75 18                	jne    0x1836739b8
   1836739a0:	49 8b 06             	mov    rax,QWORD PTR [r14]
   1836739a3:	4c 89 f1             	mov    rcx,r14
   1836739a6:	ff 10                	call   QWORD PTR [rax]
   1836739a8:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   1836739ad:	75 09                	jne    0x1836739b8
   1836739af:	49 8b 06             	mov    rax,QWORD PTR [r14]
   1836739b2:	4c 89 f1             	mov    rcx,r14
   1836739b5:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1836739b8:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   1836739bf:	00 
   1836739c0:	b9 20 00 00 00       	mov    ecx,0x20
   1836739c5:	e8 32 97 19 03       	call   0x18680d0fc
   1836739ca:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   1836739ce:	48 c7 45 e8 12 00 00 	mov    QWORD PTR [rbp-0x18],0x12
   1836739d5:	00 
   1836739d6:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   1836739dd:	00 
   1836739de:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   1836739e1:	66 c7 40 10 65 72    	mov    WORD PTR [rax+0x10],0x7265
   1836739e7:	c6 40 12 00          	mov    BYTE PTR [rax+0x12],0x0
   1836739eb:	0f 57 c0             	xorps  xmm0,xmm0
   1836739ee:	0f 29 45 b0          	movaps XMMWORD PTR [rbp-0x50],xmm0
   1836739f2:	48 c7 45 c0 01 00 00 	mov    QWORD PTR [rbp-0x40],0x1
   1836739f9:	00 
   1836739fa:	48 c7 45 c8 0f 00 00 	mov    QWORD PTR [rbp-0x38],0xf
   183673a01:	00 
   183673a02:	c6 45 b0 31          	mov    BYTE PTR [rbp-0x50],0x31
   183673a06:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183673a0a:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   183673a0e:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   183673a12:	48 89 f1             	mov    rcx,rsi
   183673a15:	e8 66 2a 00 fd       	call   0x180676480
   183673a1a:	90                   	nop
   183673a1b:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   183673a1f:	48 83 f8 10          	cmp    rax,0x10
   183673a23:	72 35                	jb     0x183673a5a
   183673a25:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   183673a29:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183673a2d:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183673a34:	72 1f                	jb     0x183673a55
   183673a36:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183673a3a:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183673a3e:	4c 29 c1             	sub    rcx,r8
   183673a41:	48 83 f9 20          	cmp    rcx,0x20
   183673a45:	0f 83 cc 2f 00 00    	jae    0x183676a17
   183673a4b:	48 83 c0 28          	add    rax,0x28
   183673a4f:	48 89 c2             	mov    rdx,rax
   183673a52:	4c 89 c1             	mov    rcx,r8
   183673a55:	e8 e6 96 19 03       	call   0x18680d140
   183673a5a:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   183673a5e:	48 83 f8 10          	cmp    rax,0x10
   183673a62:	72 35                	jb     0x183673a99
   183673a64:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   183673a68:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183673a6c:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183673a73:	72 1f                	jb     0x183673a94
   183673a75:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183673a79:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183673a7d:	4c 29 c1             	sub    rcx,r8
   183673a80:	48 83 f9 20          	cmp    rcx,0x20
   183673a84:	0f 83 8d 2f 00 00    	jae    0x183676a17
   183673a8a:	48 83 c0 28          	add    rax,0x28
   183673a8e:	48 89 c2             	mov    rdx,rax
   183673a91:	4c 89 c1             	mov    rcx,r8
   183673a94:	e8 a7 96 19 03       	call   0x18680d140
   183673a99:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   183673a9d:	48 89 da             	mov    rdx,rbx
   183673aa0:	e8 0b 21 f2 ff       	call   0x183595bb0
   183673aa5:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183673aac:	00 
   183673aad:	b9 20 00 00 00       	mov    ecx,0x20
   183673ab2:	e8 45 96 19 03       	call   0x18680d0fc
   183673ab7:	90                   	nop
   183673ab8:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183673abc:	48 c7 45 e8 13 00 00 	mov    QWORD PTR [rbp-0x18],0x13
   183673ac3:	00 
   183673ac4:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183673acb:	00 
   183673acc:	0f 10 35 a1 eb 23 05 	movups xmm6,XMMWORD PTR [rip+0x523eba1]        # 0x1888b2674
   183673ad3:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   183673ad6:	c7 40 0f 64 6c 65 72 	mov    DWORD PTR [rax+0xf],0x72656c64
   183673add:	c6 40 13 00          	mov    BYTE PTR [rax+0x13],0x0
   183673ae1:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183673ae5:	4c 8d 45 d8          	lea    r8,[rbp-0x28]
   183673ae9:	4c 8d 4d b0          	lea    r9,[rbp-0x50]
   183673aed:	48 89 f9             	mov    rcx,rdi
   183673af0:	e8 8b 5a 0a fe       	call   0x181719580
   183673af5:	90                   	nop
   183673af6:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   183673afa:	48 83 f8 10          	cmp    rax,0x10
   183673afe:	72 35                	jb     0x183673b35
   183673b00:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   183673b04:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183673b08:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183673b0f:	72 1f                	jb     0x183673b30
   183673b11:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183673b15:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183673b19:	4c 29 c1             	sub    rcx,r8
   183673b1c:	48 83 f9 20          	cmp    rcx,0x20
   183673b20:	0f 83 f1 2e 00 00    	jae    0x183676a17
   183673b26:	48 83 c0 28          	add    rax,0x28
   183673b2a:	48 89 c2             	mov    rdx,rax
   183673b2d:	4c 89 c1             	mov    rcx,r8
   183673b30:	e8 0b 96 19 03       	call   0x18680d140
   183673b35:	4c 8b 75 b8          	mov    r14,QWORD PTR [rbp-0x48]
   183673b39:	4d 85 f6             	test   r14,r14
   183673b3c:	74 1f                	je     0x183673b5d
   183673b3e:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   183673b43:	75 18                	jne    0x183673b5d
   183673b45:	49 8b 06             	mov    rax,QWORD PTR [r14]
   183673b48:	4c 89 f1             	mov    rcx,r14
   183673b4b:	ff 10                	call   QWORD PTR [rax]
   183673b4d:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   183673b52:	75 09                	jne    0x183673b5d
   183673b54:	49 8b 06             	mov    rax,QWORD PTR [r14]
   183673b57:	4c 89 f1             	mov    rcx,r14
   183673b5a:	ff 50 08             	call   QWORD PTR [rax+0x8]
   183673b5d:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183673b64:	00 
   183673b65:	b9 20 00 00 00       	mov    ecx,0x20
   183673b6a:	e8 8d 95 19 03       	call   0x18680d0fc
   183673b6f:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183673b73:	48 c7 45 e8 13 00 00 	mov    QWORD PTR [rbp-0x18],0x13
   183673b7a:	00 
   183673b7b:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183673b82:	00 
   183673b83:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   183673b86:	c7 40 0f 64 6c 65 72 	mov    DWORD PTR [rax+0xf],0x72656c64
   183673b8d:	c6 40 13 00          	mov    BYTE PTR [rax+0x13],0x0
   183673b91:	0f 57 c0             	xorps  xmm0,xmm0
   183673b94:	0f 29 45 b0          	movaps XMMWORD PTR [rbp-0x50],xmm0
   183673b98:	48 c7 45 c0 01 00 00 	mov    QWORD PTR [rbp-0x40],0x1
   183673b9f:	00 
   183673ba0:	48 c7 45 c8 0f 00 00 	mov    QWORD PTR [rbp-0x38],0xf
   183673ba7:	00 
   183673ba8:	c6 45 b0 33          	mov    BYTE PTR [rbp-0x50],0x33
   183673bac:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183673bb0:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   183673bb4:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   183673bb8:	48 89 f1             	mov    rcx,rsi
   183673bbb:	e8 c0 28 00 fd       	call   0x180676480
   183673bc0:	90                   	nop
   183673bc1:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   183673bc5:	48 83 f8 10          	cmp    rax,0x10
   183673bc9:	72 35                	jb     0x183673c00
   183673bcb:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   183673bcf:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183673bd3:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183673bda:	72 1f                	jb     0x183673bfb
   183673bdc:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183673be0:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183673be4:	4c 29 c1             	sub    rcx,r8
   183673be7:	48 83 f9 20          	cmp    rcx,0x20
   183673beb:	0f 83 26 2e 00 00    	jae    0x183676a17
   183673bf1:	48 83 c0 28          	add    rax,0x28
   183673bf5:	48 89 c2             	mov    rdx,rax
   183673bf8:	4c 89 c1             	mov    rcx,r8
   183673bfb:	e8 40 95 19 03       	call   0x18680d140
   183673c00:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   183673c04:	48 83 f8 10          	cmp    rax,0x10
   183673c08:	72 35                	jb     0x183673c3f
   183673c0a:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   183673c0e:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183673c12:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183673c19:	72 1f                	jb     0x183673c3a
   183673c1b:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183673c1f:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183673c23:	4c 29 c1             	sub    rcx,r8
   183673c26:	48 83 f9 20          	cmp    rcx,0x20
   183673c2a:	0f 83 e7 2d 00 00    	jae    0x183676a17
   183673c30:	48 83 c0 28          	add    rax,0x28
   183673c34:	48 89 c2             	mov    rdx,rax
   183673c37:	4c 89 c1             	mov    rcx,r8
   183673c3a:	e8 01 95 19 03       	call   0x18680d140
   183673c3f:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183673c46:	00 
   183673c47:	b9 20 00 00 00       	mov    ecx,0x20
   183673c4c:	e8 ab 94 19 03       	call   0x18680d0fc
   183673c51:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183673c55:	48 c7 45 e8 13 00 00 	mov    QWORD PTR [rbp-0x18],0x13
   183673c5c:	00 
   183673c5d:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183673c64:	00 
   183673c65:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   183673c68:	c7 40 0f 64 6c 65 72 	mov    DWORD PTR [rax+0xf],0x72656c64
   183673c6f:	c6 40 13 00          	mov    BYTE PTR [rax+0x13],0x0
   183673c73:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   183673c77:	ba 31 00 00 00       	mov    edx,0x31
   183673c7c:	41 b8 02 00 00 00    	mov    r8d,0x2
   183673c82:	e8 59 fa ff ff       	call   0x1836736e0
   183673c87:	90                   	nop
   183673c88:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183673c8c:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   183673c90:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   183673c94:	48 89 f1             	mov    rcx,rsi
   183673c97:	e8 e4 27 00 fd       	call   0x180676480
   183673c9c:	90                   	nop
   183673c9d:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   183673ca1:	48 83 f8 10          	cmp    rax,0x10
   183673ca5:	72 35                	jb     0x183673cdc
   183673ca7:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   183673cab:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183673caf:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183673cb6:	72 1f                	jb     0x183673cd7
   183673cb8:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183673cbc:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183673cc0:	4c 29 c1             	sub    rcx,r8
   183673cc3:	48 83 f9 20          	cmp    rcx,0x20
   183673cc7:	0f 83 4a 2d 00 00    	jae    0x183676a17
   183673ccd:	48 83 c0 28          	add    rax,0x28
   183673cd1:	48 89 c2             	mov    rdx,rax
   183673cd4:	4c 89 c1             	mov    rcx,r8
   183673cd7:	e8 64 94 19 03       	call   0x18680d140
   183673cdc:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   183673ce0:	48 83 f8 10          	cmp    rax,0x10
   183673ce4:	72 35                	jb     0x183673d1b
   183673ce6:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   183673cea:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183673cee:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183673cf5:	72 1f                	jb     0x183673d16
   183673cf7:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183673cfb:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183673cff:	4c 29 c1             	sub    rcx,r8
   183673d02:	48 83 f9 20          	cmp    rcx,0x20
   183673d06:	0f 83 0b 2d 00 00    	jae    0x183676a17
   183673d0c:	48 83 c0 28          	add    rax,0x28
   183673d10:	48 89 c2             	mov    rdx,rax
   183673d13:	4c 89 c1             	mov    rcx,r8
   183673d16:	e8 25 94 19 03       	call   0x18680d140
   183673d1b:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   183673d1f:	48 89 da             	mov    rdx,rbx
   183673d22:	e8 a9 1f f2 ff       	call   0x183595cd0
   183673d27:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183673d2e:	00 
   183673d2f:	b9 20 00 00 00       	mov    ecx,0x20
   183673d34:	e8 c3 93 19 03       	call   0x18680d0fc
   183673d39:	90                   	nop
   183673d3a:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183673d3e:	48 c7 45 e8 12 00 00 	mov    QWORD PTR [rbp-0x18],0x12
   183673d45:	00 
   183673d46:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183673d4d:	00 
   183673d4e:	0f 10 35 33 e9 23 05 	movups xmm6,XMMWORD PTR [rip+0x523e933]        # 0x1888b2688
   183673d55:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   183673d58:	66 c7 40 10 65 72    	mov    WORD PTR [rax+0x10],0x7265
   183673d5e:	c6 40 12 00          	mov    BYTE PTR [rax+0x12],0x0
   183673d62:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183673d66:	4c 8d 45 d8          	lea    r8,[rbp-0x28]
   183673d6a:	4c 8d 4d b0          	lea    r9,[rbp-0x50]
   183673d6e:	48 89 f9             	mov    rcx,rdi
   183673d71:	e8 0a 58 0a fe       	call   0x181719580
   183673d76:	90                   	nop
   183673d77:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   183673d7b:	48 83 f8 10          	cmp    rax,0x10
   183673d7f:	72 35                	jb     0x183673db6
   183673d81:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   183673d85:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183673d89:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183673d90:	72 1f                	jb     0x183673db1
   183673d92:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183673d96:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183673d9a:	4c 29 c1             	sub    rcx,r8
   183673d9d:	48 83 f9 20          	cmp    rcx,0x20
   183673da1:	0f 83 70 2c 00 00    	jae    0x183676a17
   183673da7:	48 83 c0 28          	add    rax,0x28
   183673dab:	48 89 c2             	mov    rdx,rax
   183673dae:	4c 89 c1             	mov    rcx,r8
   183673db1:	e8 8a 93 19 03       	call   0x18680d140
   183673db6:	4c 8b 75 b8          	mov    r14,QWORD PTR [rbp-0x48]
   183673dba:	4d 85 f6             	test   r14,r14
   183673dbd:	74 1f                	je     0x183673dde
   183673dbf:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   183673dc4:	75 18                	jne    0x183673dde
   183673dc6:	49 8b 06             	mov    rax,QWORD PTR [r14]
   183673dc9:	4c 89 f1             	mov    rcx,r14
   183673dcc:	ff 10                	call   QWORD PTR [rax]
   183673dce:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   183673dd3:	75 09                	jne    0x183673dde
   183673dd5:	49 8b 06             	mov    rax,QWORD PTR [r14]
   183673dd8:	4c 89 f1             	mov    rcx,r14
   183673ddb:	ff 50 08             	call   QWORD PTR [rax+0x8]
   183673dde:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183673de5:	00 
   183673de6:	b9 20 00 00 00       	mov    ecx,0x20
   183673deb:	e8 0c 93 19 03       	call   0x18680d0fc
   183673df0:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183673df4:	48 c7 45 e8 12 00 00 	mov    QWORD PTR [rbp-0x18],0x12
   183673dfb:	00 
   183673dfc:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183673e03:	00 
   183673e04:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   183673e07:	66 c7 40 10 65 72    	mov    WORD PTR [rax+0x10],0x7265
   183673e0d:	c6 40 12 00          	mov    BYTE PTR [rax+0x12],0x0
   183673e11:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   183673e15:	ba 31 00 00 00       	mov    edx,0x31
   183673e1a:	41 b8 06 00 00 00    	mov    r8d,0x6
   183673e20:	e8 bb f8 ff ff       	call   0x1836736e0
   183673e25:	90                   	nop
   183673e26:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183673e2a:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   183673e2e:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   183673e32:	48 89 f1             	mov    rcx,rsi
   183673e35:	e8 46 26 00 fd       	call   0x180676480
   183673e3a:	90                   	nop
   183673e3b:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   183673e3f:	48 83 f8 10          	cmp    rax,0x10
   183673e43:	72 35                	jb     0x183673e7a
   183673e45:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   183673e49:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183673e4d:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183673e54:	72 1f                	jb     0x183673e75
   183673e56:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183673e5a:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183673e5e:	4c 29 c1             	sub    rcx,r8
   183673e61:	48 83 f9 20          	cmp    rcx,0x20
   183673e65:	0f 83 ac 2b 00 00    	jae    0x183676a17
   183673e6b:	48 83 c0 28          	add    rax,0x28
   183673e6f:	48 89 c2             	mov    rdx,rax
   183673e72:	4c 89 c1             	mov    rcx,r8
   183673e75:	e8 c6 92 19 03       	call   0x18680d140
   183673e7a:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   183673e7e:	48 83 f8 10          	cmp    rax,0x10
   183673e82:	72 35                	jb     0x183673eb9
   183673e84:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   183673e88:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183673e8c:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183673e93:	72 1f                	jb     0x183673eb4
   183673e95:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183673e99:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183673e9d:	4c 29 c1             	sub    rcx,r8
   183673ea0:	48 83 f9 20          	cmp    rcx,0x20
   183673ea4:	0f 83 6d 2b 00 00    	jae    0x183676a17
   183673eaa:	48 83 c0 28          	add    rax,0x28
   183673eae:	48 89 c2             	mov    rdx,rax
   183673eb1:	4c 89 c1             	mov    rcx,r8
   183673eb4:	e8 87 92 19 03       	call   0x18680d140
   183673eb9:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183673ec0:	00 
   183673ec1:	b9 20 00 00 00       	mov    ecx,0x20
   183673ec6:	e8 31 92 19 03       	call   0x18680d0fc
   183673ecb:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183673ecf:	48 c7 45 e8 12 00 00 	mov    QWORD PTR [rbp-0x18],0x12
   183673ed6:	00 
   183673ed7:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183673ede:	00 
   183673edf:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   183673ee2:	66 c7 40 10 65 72    	mov    WORD PTR [rax+0x10],0x7265
   183673ee8:	c6 40 12 00          	mov    BYTE PTR [rax+0x12],0x0
   183673eec:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   183673ef0:	ba 31 00 00 00       	mov    edx,0x31
   183673ef5:	41 b8 4a 00 00 00    	mov    r8d,0x4a
   183673efb:	e8 e0 f7 ff ff       	call   0x1836736e0
   183673f00:	90                   	nop
   183673f01:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183673f05:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   183673f09:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   183673f0d:	48 89 f1             	mov    rcx,rsi
   183673f10:	e8 6b 25 00 fd       	call   0x180676480
   183673f15:	90                   	nop
   183673f16:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   183673f1a:	48 83 f8 10          	cmp    rax,0x10
   183673f1e:	72 35                	jb     0x183673f55
   183673f20:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   183673f24:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183673f28:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183673f2f:	72 1f                	jb     0x183673f50
   183673f31:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183673f35:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183673f39:	4c 29 c1             	sub    rcx,r8
   183673f3c:	48 83 f9 20          	cmp    rcx,0x20
   183673f40:	0f 83 d1 2a 00 00    	jae    0x183676a17
   183673f46:	48 83 c0 28          	add    rax,0x28
   183673f4a:	48 89 c2             	mov    rdx,rax
   183673f4d:	4c 89 c1             	mov    rcx,r8
   183673f50:	e8 eb 91 19 03       	call   0x18680d140
   183673f55:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   183673f59:	48 83 f8 10          	cmp    rax,0x10
   183673f5d:	72 35                	jb     0x183673f94
   183673f5f:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   183673f63:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183673f67:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183673f6e:	72 1f                	jb     0x183673f8f
   183673f70:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183673f74:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183673f78:	4c 29 c1             	sub    rcx,r8
   183673f7b:	48 83 f9 20          	cmp    rcx,0x20
   183673f7f:	0f 83 92 2a 00 00    	jae    0x183676a17
   183673f85:	48 83 c0 28          	add    rax,0x28
   183673f89:	48 89 c2             	mov    rdx,rax
   183673f8c:	4c 89 c1             	mov    rcx,r8
   183673f8f:	e8 ac 91 19 03       	call   0x18680d140
   183673f94:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183673f9b:	00 
   183673f9c:	b9 20 00 00 00       	mov    ecx,0x20
   183673fa1:	e8 56 91 19 03       	call   0x18680d0fc
   183673fa6:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183673faa:	48 c7 45 e8 12 00 00 	mov    QWORD PTR [rbp-0x18],0x12
   183673fb1:	00 
   183673fb2:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183673fb9:	00 
   183673fba:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   183673fbd:	66 c7 40 10 65 72    	mov    WORD PTR [rax+0x10],0x7265
   183673fc3:	c6 40 12 00          	mov    BYTE PTR [rax+0x12],0x0
   183673fc7:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   183673fcb:	ba 31 00 00 00       	mov    edx,0x31
   183673fd0:	41 b8 82 00 00 00    	mov    r8d,0x82
   183673fd6:	e8 05 f7 ff ff       	call   0x1836736e0
   183673fdb:	90                   	nop
   183673fdc:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183673fe0:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   183673fe4:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   183673fe8:	48 89 f1             	mov    rcx,rsi
   183673feb:	e8 90 24 00 fd       	call   0x180676480
   183673ff0:	90                   	nop
   183673ff1:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   183673ff5:	48 83 f8 10          	cmp    rax,0x10
   183673ff9:	72 35                	jb     0x183674030
   183673ffb:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   183673fff:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183674003:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18367400a:	72 1f                	jb     0x18367402b
   18367400c:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183674010:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183674014:	4c 29 c1             	sub    rcx,r8
   183674017:	48 83 f9 20          	cmp    rcx,0x20
   18367401b:	0f 83 f6 29 00 00    	jae    0x183676a17
   183674021:	48 83 c0 28          	add    rax,0x28
   183674025:	48 89 c2             	mov    rdx,rax
   183674028:	4c 89 c1             	mov    rcx,r8
   18367402b:	e8 10 91 19 03       	call   0x18680d140
   183674030:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   183674034:	48 83 f8 10          	cmp    rax,0x10
   183674038:	72 35                	jb     0x18367406f
   18367403a:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18367403e:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183674042:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183674049:	72 1f                	jb     0x18367406a
   18367404b:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18367404f:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183674053:	4c 29 c1             	sub    rcx,r8
   183674056:	48 83 f9 20          	cmp    rcx,0x20
   18367405a:	0f 83 b7 29 00 00    	jae    0x183676a17
   183674060:	48 83 c0 28          	add    rax,0x28
   183674064:	48 89 c2             	mov    rdx,rax
   183674067:	4c 89 c1             	mov    rcx,r8
   18367406a:	e8 d1 90 19 03       	call   0x18680d140
   18367406f:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183674076:	00 
   183674077:	b9 20 00 00 00       	mov    ecx,0x20
   18367407c:	e8 7b 90 19 03       	call   0x18680d0fc
   183674081:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183674085:	48 c7 45 e8 12 00 00 	mov    QWORD PTR [rbp-0x18],0x12
   18367408c:	00 
   18367408d:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183674094:	00 
   183674095:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   183674098:	66 c7 40 10 65 72    	mov    WORD PTR [rax+0x10],0x7265
   18367409e:	c6 40 12 00          	mov    BYTE PTR [rax+0x12],0x0
   1836740a2:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   1836740a6:	ba 31 00 00 00       	mov    edx,0x31
   1836740ab:	41 b8 83 00 00 00    	mov    r8d,0x83
   1836740b1:	e8 2a f6 ff ff       	call   0x1836736e0
   1836740b6:	90                   	nop
   1836740b7:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   1836740bb:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   1836740bf:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   1836740c3:	48 89 f1             	mov    rcx,rsi
   1836740c6:	e8 b5 23 00 fd       	call   0x180676480
   1836740cb:	90                   	nop
   1836740cc:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   1836740d0:	48 83 f8 10          	cmp    rax,0x10
   1836740d4:	72 35                	jb     0x18367410b
   1836740d6:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   1836740da:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1836740de:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1836740e5:	72 1f                	jb     0x183674106
   1836740e7:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1836740eb:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1836740ef:	4c 29 c1             	sub    rcx,r8
   1836740f2:	48 83 f9 20          	cmp    rcx,0x20
   1836740f6:	0f 83 1b 29 00 00    	jae    0x183676a17
   1836740fc:	48 83 c0 28          	add    rax,0x28
   183674100:	48 89 c2             	mov    rdx,rax
   183674103:	4c 89 c1             	mov    rcx,r8
   183674106:	e8 35 90 19 03       	call   0x18680d140
   18367410b:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18367410f:	48 83 f8 10          	cmp    rax,0x10
   183674113:	72 35                	jb     0x18367414a
   183674115:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   183674119:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18367411d:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183674124:	72 1f                	jb     0x183674145
   183674126:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18367412a:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18367412e:	4c 29 c1             	sub    rcx,r8
   183674131:	48 83 f9 20          	cmp    rcx,0x20
   183674135:	0f 83 dc 28 00 00    	jae    0x183676a17
   18367413b:	48 83 c0 28          	add    rax,0x28
   18367413f:	48 89 c2             	mov    rdx,rax
   183674142:	4c 89 c1             	mov    rcx,r8
   183674145:	e8 f6 8f 19 03       	call   0x18680d140
   18367414a:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   18367414e:	48 89 da             	mov    rdx,rbx
   183674151:	e8 9a 1c f2 ff       	call   0x183595df0
   183674156:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18367415d:	00 
   18367415e:	b9 20 00 00 00       	mov    ecx,0x20
   183674163:	e8 94 8f 19 03       	call   0x18680d0fc
   183674168:	90                   	nop
   183674169:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18367416d:	48 c7 45 e8 13 00 00 	mov    QWORD PTR [rbp-0x18],0x13
   183674174:	00 
   183674175:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18367417c:	00 
   18367417d:	0f 10 35 17 e5 23 05 	movups xmm6,XMMWORD PTR [rip+0x523e517]        # 0x1888b269b
   183674184:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   183674187:	c7 40 0f 64 6c 65 72 	mov    DWORD PTR [rax+0xf],0x72656c64
   18367418e:	c6 40 13 00          	mov    BYTE PTR [rax+0x13],0x0
   183674192:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183674196:	4c 8d 45 d8          	lea    r8,[rbp-0x28]
   18367419a:	4c 8d 4d b0          	lea    r9,[rbp-0x50]
   18367419e:	48 89 f9             	mov    rcx,rdi
   1836741a1:	e8 da 53 0a fe       	call   0x181719580
   1836741a6:	90                   	nop
   1836741a7:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   1836741ab:	48 83 f8 10          	cmp    rax,0x10
   1836741af:	72 35                	jb     0x1836741e6
   1836741b1:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   1836741b5:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1836741b9:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1836741c0:	72 1f                	jb     0x1836741e1
   1836741c2:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1836741c6:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1836741ca:	4c 29 c1             	sub    rcx,r8
   1836741cd:	48 83 f9 20          	cmp    rcx,0x20
   1836741d1:	0f 83 40 28 00 00    	jae    0x183676a17
   1836741d7:	48 83 c0 28          	add    rax,0x28
   1836741db:	48 89 c2             	mov    rdx,rax
   1836741de:	4c 89 c1             	mov    rcx,r8
   1836741e1:	e8 5a 8f 19 03       	call   0x18680d140
   1836741e6:	4c 8b 75 b8          	mov    r14,QWORD PTR [rbp-0x48]
   1836741ea:	4d 85 f6             	test   r14,r14
   1836741ed:	74 1f                	je     0x18367420e
   1836741ef:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   1836741f4:	75 18                	jne    0x18367420e
   1836741f6:	49 8b 06             	mov    rax,QWORD PTR [r14]
   1836741f9:	4c 89 f1             	mov    rcx,r14
   1836741fc:	ff 10                	call   QWORD PTR [rax]
   1836741fe:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   183674203:	75 09                	jne    0x18367420e
   183674205:	49 8b 06             	mov    rax,QWORD PTR [r14]
   183674208:	4c 89 f1             	mov    rcx,r14
   18367420b:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18367420e:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183674215:	00 
   183674216:	b9 20 00 00 00       	mov    ecx,0x20
   18367421b:	e8 dc 8e 19 03       	call   0x18680d0fc
   183674220:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183674224:	48 c7 45 e8 13 00 00 	mov    QWORD PTR [rbp-0x18],0x13
   18367422b:	00 
   18367422c:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183674233:	00 
   183674234:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   183674237:	c7 40 0f 64 6c 65 72 	mov    DWORD PTR [rax+0xf],0x72656c64
   18367423e:	c6 40 13 00          	mov    BYTE PTR [rax+0x13],0x0
   183674242:	0f 57 c0             	xorps  xmm0,xmm0
   183674245:	0f 29 45 b0          	movaps XMMWORD PTR [rbp-0x50],xmm0
   183674249:	48 c7 45 c0 02 00 00 	mov    QWORD PTR [rbp-0x40],0x2
   183674250:	00 
   183674251:	48 c7 45 c8 0f 00 00 	mov    QWORD PTR [rbp-0x38],0xf
   183674258:	00 
   183674259:	66 c7 45 b0 34 33    	mov    WORD PTR [rbp-0x50],0x3334
   18367425f:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183674263:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   183674267:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18367426b:	48 89 f1             	mov    rcx,rsi
   18367426e:	e8 0d 22 00 fd       	call   0x180676480
   183674273:	90                   	nop
   183674274:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   183674278:	48 83 f8 10          	cmp    rax,0x10
   18367427c:	72 35                	jb     0x1836742b3
   18367427e:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   183674282:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183674286:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18367428d:	72 1f                	jb     0x1836742ae
   18367428f:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183674293:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183674297:	4c 29 c1             	sub    rcx,r8
   18367429a:	48 83 f9 20          	cmp    rcx,0x20
   18367429e:	0f 83 73 27 00 00    	jae    0x183676a17
   1836742a4:	48 83 c0 28          	add    rax,0x28
   1836742a8:	48 89 c2             	mov    rdx,rax
   1836742ab:	4c 89 c1             	mov    rcx,r8
   1836742ae:	e8 8d 8e 19 03       	call   0x18680d140
   1836742b3:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   1836742b7:	48 83 f8 10          	cmp    rax,0x10
   1836742bb:	72 35                	jb     0x1836742f2
   1836742bd:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   1836742c1:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1836742c5:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1836742cc:	72 1f                	jb     0x1836742ed
   1836742ce:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1836742d2:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1836742d6:	4c 29 c1             	sub    rcx,r8
   1836742d9:	48 83 f9 20          	cmp    rcx,0x20
   1836742dd:	0f 83 34 27 00 00    	jae    0x183676a17
   1836742e3:	48 83 c0 28          	add    rax,0x28
   1836742e7:	48 89 c2             	mov    rdx,rax
   1836742ea:	4c 89 c1             	mov    rcx,r8
   1836742ed:	e8 4e 8e 19 03       	call   0x18680d140
   1836742f2:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   1836742f6:	48 89 da             	mov    rdx,rbx
   1836742f9:	e8 a2 1c f2 ff       	call   0x183595fa0
   1836742fe:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183674305:	00 
   183674306:	b9 20 00 00 00       	mov    ecx,0x20
   18367430b:	e8 ec 8d 19 03       	call   0x18680d0fc
   183674310:	90                   	nop
   183674311:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183674315:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   18367431c:	00 
   18367431d:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183674324:	00 
   183674325:	0f 10 35 83 e3 23 05 	movups xmm6,XMMWORD PTR [rip+0x523e383]        # 0x1888b26af
   18367432c:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   18367432f:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   183674335:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183674339:	4c 8d 45 d8          	lea    r8,[rbp-0x28]
   18367433d:	4c 8d 4d b0          	lea    r9,[rbp-0x50]
   183674341:	48 89 f9             	mov    rcx,rdi
   183674344:	e8 37 52 0a fe       	call   0x181719580
   183674349:	90                   	nop
   18367434a:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18367434e:	48 83 f8 10          	cmp    rax,0x10
   183674352:	72 35                	jb     0x183674389
   183674354:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   183674358:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18367435c:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183674363:	72 1f                	jb     0x183674384
   183674365:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183674369:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18367436d:	4c 29 c1             	sub    rcx,r8
   183674370:	48 83 f9 20          	cmp    rcx,0x20
   183674374:	0f 83 9d 26 00 00    	jae    0x183676a17
   18367437a:	48 83 c0 28          	add    rax,0x28
   18367437e:	48 89 c2             	mov    rdx,rax
   183674381:	4c 89 c1             	mov    rcx,r8
   183674384:	e8 b7 8d 19 03       	call   0x18680d140
   183674389:	4c 8b 75 b8          	mov    r14,QWORD PTR [rbp-0x48]
   18367438d:	4d 85 f6             	test   r14,r14
   183674390:	74 1f                	je     0x1836743b1
   183674392:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   183674397:	75 18                	jne    0x1836743b1
   183674399:	49 8b 06             	mov    rax,QWORD PTR [r14]
   18367439c:	4c 89 f1             	mov    rcx,r14
   18367439f:	ff 10                	call   QWORD PTR [rax]
   1836743a1:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   1836743a6:	75 09                	jne    0x1836743b1
   1836743a8:	49 8b 06             	mov    rax,QWORD PTR [r14]
   1836743ab:	4c 89 f1             	mov    rcx,r14
   1836743ae:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1836743b1:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   1836743b5:	48 89 da             	mov    rdx,rbx
   1836743b8:	e8 03 1d f2 ff       	call   0x1835960c0
   1836743bd:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   1836743c4:	00 
   1836743c5:	b9 20 00 00 00       	mov    ecx,0x20
   1836743ca:	e8 2d 8d 19 03       	call   0x18680d0fc
   1836743cf:	90                   	nop
   1836743d0:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   1836743d4:	48 c7 45 e8 17 00 00 	mov    QWORD PTR [rbp-0x18],0x17
   1836743db:	00 
   1836743dc:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   1836743e3:	00 
   1836743e4:	0f 10 3d d6 e2 23 05 	movups xmm7,XMMWORD PTR [rip+0x523e2d6]        # 0x1888b26c1
   1836743eb:	0f 11 38             	movups XMMWORD PTR [rax],xmm7
   1836743ee:	49 bf 65 48 61 6e 64 	movabs r15,0x72656c646e614865
   1836743f5:	6c 65 72 
   1836743f8:	4c 89 78 0f          	mov    QWORD PTR [rax+0xf],r15
   1836743fc:	c6 40 17 00          	mov    BYTE PTR [rax+0x17],0x0
   183674400:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183674404:	4c 8d 45 d8          	lea    r8,[rbp-0x28]
   183674408:	4c 8d 4d b0          	lea    r9,[rbp-0x50]
   18367440c:	48 89 f9             	mov    rcx,rdi
   18367440f:	e8 6c 51 0a fe       	call   0x181719580
   183674414:	90                   	nop
   183674415:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   183674419:	48 83 f8 10          	cmp    rax,0x10
   18367441d:	72 35                	jb     0x183674454
   18367441f:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   183674423:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183674427:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18367442e:	72 1f                	jb     0x18367444f
   183674430:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183674434:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183674438:	4c 29 c1             	sub    rcx,r8
   18367443b:	48 83 f9 20          	cmp    rcx,0x20
   18367443f:	0f 83 d2 25 00 00    	jae    0x183676a17
   183674445:	48 83 c0 28          	add    rax,0x28
   183674449:	48 89 c2             	mov    rdx,rax
   18367444c:	4c 89 c1             	mov    rcx,r8
   18367444f:	e8 ec 8c 19 03       	call   0x18680d140
   183674454:	4c 8b 75 b8          	mov    r14,QWORD PTR [rbp-0x48]
   183674458:	4d 85 f6             	test   r14,r14
   18367445b:	74 1f                	je     0x18367447c
   18367445d:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   183674462:	75 18                	jne    0x18367447c
   183674464:	49 8b 06             	mov    rax,QWORD PTR [r14]
   183674467:	4c 89 f1             	mov    rcx,r14
   18367446a:	ff 10                	call   QWORD PTR [rax]
   18367446c:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   183674471:	75 09                	jne    0x18367447c
   183674473:	49 8b 06             	mov    rax,QWORD PTR [r14]
   183674476:	4c 89 f1             	mov    rcx,r14
   183674479:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18367447c:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   183674480:	48 89 da             	mov    rdx,rbx
   183674483:	e8 b8 47 00 00       	call   0x183678c40
   183674488:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18367448f:	00 
   183674490:	b9 20 00 00 00       	mov    ecx,0x20
   183674495:	e8 62 8c 19 03       	call   0x18680d0fc
   18367449a:	90                   	nop
   18367449b:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18367449f:	48 c7 45 e8 17 00 00 	mov    QWORD PTR [rbp-0x18],0x17
   1836744a6:	00 
   1836744a7:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   1836744ae:	00 
   1836744af:	44 0f 10 05 22 e2 23 	movups xmm8,XMMWORD PTR [rip+0x523e222]        # 0x1888b26d9
   1836744b6:	05 
   1836744b7:	44 0f 11 00          	movups XMMWORD PTR [rax],xmm8
   1836744bb:	4c 89 78 0f          	mov    QWORD PTR [rax+0xf],r15
   1836744bf:	c6 40 17 00          	mov    BYTE PTR [rax+0x17],0x0
   1836744c3:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   1836744c7:	4c 8d 45 d8          	lea    r8,[rbp-0x28]
   1836744cb:	4c 8d 4d b0          	lea    r9,[rbp-0x50]
   1836744cf:	48 89 f9             	mov    rcx,rdi
   1836744d2:	e8 a9 50 0a fe       	call   0x181719580
   1836744d7:	90                   	nop
   1836744d8:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   1836744dc:	48 83 f8 10          	cmp    rax,0x10
   1836744e0:	72 35                	jb     0x183674517
   1836744e2:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   1836744e6:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1836744ea:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1836744f1:	72 1f                	jb     0x183674512
   1836744f3:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1836744f7:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1836744fb:	4c 29 c1             	sub    rcx,r8
   1836744fe:	48 83 f9 20          	cmp    rcx,0x20
   183674502:	0f 83 0f 25 00 00    	jae    0x183676a17
   183674508:	48 83 c0 28          	add    rax,0x28
   18367450c:	48 89 c2             	mov    rdx,rax
   18367450f:	4c 89 c1             	mov    rcx,r8
   183674512:	e8 29 8c 19 03       	call   0x18680d140
   183674517:	4c 8b 75 b8          	mov    r14,QWORD PTR [rbp-0x48]
   18367451b:	4d 85 f6             	test   r14,r14
   18367451e:	74 1f                	je     0x18367453f
   183674520:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   183674525:	75 18                	jne    0x18367453f
   183674527:	49 8b 06             	mov    rax,QWORD PTR [r14]
   18367452a:	4c 89 f1             	mov    rcx,r14
   18367452d:	ff 10                	call   QWORD PTR [rax]
   18367452f:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   183674534:	75 09                	jne    0x18367453f
   183674536:	49 8b 06             	mov    rax,QWORD PTR [r14]
   183674539:	4c 89 f1             	mov    rcx,r14
   18367453c:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18367453f:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183674546:	00 
   183674547:	b9 20 00 00 00       	mov    ecx,0x20
   18367454c:	e8 ab 8b 19 03       	call   0x18680d0fc
   183674551:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183674555:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   18367455c:	00 
   18367455d:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183674564:	00 
   183674565:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   183674568:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   18367456e:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   183674572:	ba 31 00 00 00       	mov    edx,0x31
   183674577:	41 b8 01 00 00 00    	mov    r8d,0x1
   18367457d:	e8 5e f1 ff ff       	call   0x1836736e0
   183674582:	90                   	nop
   183674583:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183674587:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   18367458b:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18367458f:	48 89 f1             	mov    rcx,rsi
   183674592:	e8 e9 1e 00 fd       	call   0x180676480
   183674597:	90                   	nop
   183674598:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18367459c:	48 83 f8 10          	cmp    rax,0x10
   1836745a0:	72 35                	jb     0x1836745d7
   1836745a2:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   1836745a6:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1836745aa:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1836745b1:	72 1f                	jb     0x1836745d2
   1836745b3:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1836745b7:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1836745bb:	4c 29 c1             	sub    rcx,r8
   1836745be:	48 83 f9 20          	cmp    rcx,0x20
   1836745c2:	0f 83 4f 24 00 00    	jae    0x183676a17
   1836745c8:	48 83 c0 28          	add    rax,0x28
   1836745cc:	48 89 c2             	mov    rdx,rax
   1836745cf:	4c 89 c1             	mov    rcx,r8
   1836745d2:	e8 69 8b 19 03       	call   0x18680d140
   1836745d7:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   1836745db:	48 83 f8 10          	cmp    rax,0x10
   1836745df:	72 35                	jb     0x183674616
   1836745e1:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   1836745e5:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1836745e9:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1836745f0:	72 1f                	jb     0x183674611
   1836745f2:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1836745f6:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1836745fa:	4c 29 c1             	sub    rcx,r8
   1836745fd:	48 83 f9 20          	cmp    rcx,0x20
   183674601:	0f 83 10 24 00 00    	jae    0x183676a17
   183674607:	48 83 c0 28          	add    rax,0x28
   18367460b:	48 89 c2             	mov    rdx,rax
   18367460e:	4c 89 c1             	mov    rcx,r8
   183674611:	e8 2a 8b 19 03       	call   0x18680d140
   183674616:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18367461d:	00 
   18367461e:	b9 20 00 00 00       	mov    ecx,0x20
   183674623:	e8 d4 8a 19 03       	call   0x18680d0fc
   183674628:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18367462c:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   183674633:	00 
   183674634:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18367463b:	00 
   18367463c:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   18367463f:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   183674645:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   183674649:	ba 31 00 00 00       	mov    edx,0x31
   18367464e:	41 b8 04 00 00 00    	mov    r8d,0x4
   183674654:	e8 87 f0 ff ff       	call   0x1836736e0
   183674659:	90                   	nop
   18367465a:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18367465e:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   183674662:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   183674666:	48 89 f1             	mov    rcx,rsi
   183674669:	e8 12 1e 00 fd       	call   0x180676480
   18367466e:	90                   	nop
   18367466f:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   183674673:	48 83 f8 10          	cmp    rax,0x10
   183674677:	72 35                	jb     0x1836746ae
   183674679:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18367467d:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183674681:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183674688:	72 1f                	jb     0x1836746a9
   18367468a:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18367468e:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183674692:	4c 29 c1             	sub    rcx,r8
   183674695:	48 83 f9 20          	cmp    rcx,0x20
   183674699:	0f 83 78 23 00 00    	jae    0x183676a17
   18367469f:	48 83 c0 28          	add    rax,0x28
   1836746a3:	48 89 c2             	mov    rdx,rax
   1836746a6:	4c 89 c1             	mov    rcx,r8
   1836746a9:	e8 92 8a 19 03       	call   0x18680d140
   1836746ae:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   1836746b2:	48 83 f8 10          	cmp    rax,0x10
   1836746b6:	72 35                	jb     0x1836746ed
   1836746b8:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   1836746bc:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1836746c0:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1836746c7:	72 1f                	jb     0x1836746e8
   1836746c9:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1836746cd:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1836746d1:	4c 29 c1             	sub    rcx,r8
   1836746d4:	48 83 f9 20          	cmp    rcx,0x20
   1836746d8:	0f 83 39 23 00 00    	jae    0x183676a17
   1836746de:	48 83 c0 28          	add    rax,0x28
   1836746e2:	48 89 c2             	mov    rdx,rax
   1836746e5:	4c 89 c1             	mov    rcx,r8
   1836746e8:	e8 53 8a 19 03       	call   0x18680d140
   1836746ed:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   1836746f4:	00 
   1836746f5:	b9 20 00 00 00       	mov    ecx,0x20
   1836746fa:	e8 fd 89 19 03       	call   0x18680d0fc
   1836746ff:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183674703:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   18367470a:	00 
   18367470b:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183674712:	00 
   183674713:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   183674716:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   18367471c:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   183674720:	ba 31 00 00 00       	mov    edx,0x31
   183674725:	41 b8 05 00 00 00    	mov    r8d,0x5
   18367472b:	e8 b0 ef ff ff       	call   0x1836736e0
   183674730:	90                   	nop
   183674731:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183674735:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   183674739:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18367473d:	48 89 f1             	mov    rcx,rsi
   183674740:	e8 3b 1d 00 fd       	call   0x180676480
   183674745:	90                   	nop
   183674746:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18367474a:	48 83 f8 10          	cmp    rax,0x10
   18367474e:	72 35                	jb     0x183674785
   183674750:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   183674754:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183674758:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18367475f:	72 1f                	jb     0x183674780
   183674761:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183674765:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183674769:	4c 29 c1             	sub    rcx,r8
   18367476c:	48 83 f9 20          	cmp    rcx,0x20
   183674770:	0f 83 a1 22 00 00    	jae    0x183676a17
   183674776:	48 83 c0 28          	add    rax,0x28
   18367477a:	48 89 c2             	mov    rdx,rax
   18367477d:	4c 89 c1             	mov    rcx,r8
   183674780:	e8 bb 89 19 03       	call   0x18680d140
   183674785:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   183674789:	48 83 f8 10          	cmp    rax,0x10
   18367478d:	72 35                	jb     0x1836747c4
   18367478f:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   183674793:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183674797:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18367479e:	72 1f                	jb     0x1836747bf
   1836747a0:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1836747a4:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1836747a8:	4c 29 c1             	sub    rcx,r8
   1836747ab:	48 83 f9 20          	cmp    rcx,0x20
   1836747af:	0f 83 62 22 00 00    	jae    0x183676a17
   1836747b5:	48 83 c0 28          	add    rax,0x28
   1836747b9:	48 89 c2             	mov    rdx,rax
   1836747bc:	4c 89 c1             	mov    rcx,r8
   1836747bf:	e8 7c 89 19 03       	call   0x18680d140
   1836747c4:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   1836747cb:	00 
   1836747cc:	b9 20 00 00 00       	mov    ecx,0x20
   1836747d1:	e8 26 89 19 03       	call   0x18680d0fc
   1836747d6:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   1836747da:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   1836747e1:	00 
   1836747e2:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   1836747e9:	00 
   1836747ea:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   1836747ed:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   1836747f3:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   1836747f7:	ba 31 00 00 00       	mov    edx,0x31
   1836747fc:	41 b8 21 00 00 00    	mov    r8d,0x21
   183674802:	e8 d9 ee ff ff       	call   0x1836736e0
   183674807:	90                   	nop
   183674808:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18367480c:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   183674810:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   183674814:	48 89 f1             	mov    rcx,rsi
   183674817:	e8 64 1c 00 fd       	call   0x180676480
   18367481c:	90                   	nop
   18367481d:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   183674821:	48 83 f8 10          	cmp    rax,0x10
   183674825:	72 35                	jb     0x18367485c
   183674827:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18367482b:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18367482f:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183674836:	72 1f                	jb     0x183674857
   183674838:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18367483c:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183674840:	4c 29 c1             	sub    rcx,r8
   183674843:	48 83 f9 20          	cmp    rcx,0x20
   183674847:	0f 83 ca 21 00 00    	jae    0x183676a17
   18367484d:	48 83 c0 28          	add    rax,0x28
   183674851:	48 89 c2             	mov    rdx,rax
   183674854:	4c 89 c1             	mov    rcx,r8
   183674857:	e8 e4 88 19 03       	call   0x18680d140
   18367485c:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   183674860:	48 83 f8 10          	cmp    rax,0x10
   183674864:	72 35                	jb     0x18367489b
   183674866:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18367486a:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18367486e:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183674875:	72 1f                	jb     0x183674896
   183674877:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18367487b:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18367487f:	4c 29 c1             	sub    rcx,r8
   183674882:	48 83 f9 20          	cmp    rcx,0x20
   183674886:	0f 83 8b 21 00 00    	jae    0x183676a17
   18367488c:	48 83 c0 28          	add    rax,0x28
   183674890:	48 89 c2             	mov    rdx,rax
   183674893:	4c 89 c1             	mov    rcx,r8
   183674896:	e8 a5 88 19 03       	call   0x18680d140
   18367489b:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   1836748a2:	00 
   1836748a3:	b9 20 00 00 00       	mov    ecx,0x20
   1836748a8:	e8 4f 88 19 03       	call   0x18680d0fc
   1836748ad:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   1836748b1:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   1836748b8:	00 
   1836748b9:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   1836748c0:	00 
   1836748c1:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   1836748c4:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   1836748ca:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   1836748ce:	ba 31 00 00 00       	mov    edx,0x31
   1836748d3:	41 b8 2c 00 00 00    	mov    r8d,0x2c
   1836748d9:	e8 02 ee ff ff       	call   0x1836736e0
   1836748de:	90                   	nop
   1836748df:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   1836748e3:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   1836748e7:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   1836748eb:	48 89 f1             	mov    rcx,rsi
   1836748ee:	e8 8d 1b 00 fd       	call   0x180676480
   1836748f3:	90                   	nop
   1836748f4:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   1836748f8:	48 83 f8 10          	cmp    rax,0x10
   1836748fc:	72 35                	jb     0x183674933
   1836748fe:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   183674902:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183674906:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18367490d:	72 1f                	jb     0x18367492e
   18367490f:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183674913:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183674917:	4c 29 c1             	sub    rcx,r8
   18367491a:	48 83 f9 20          	cmp    rcx,0x20
   18367491e:	0f 83 f3 20 00 00    	jae    0x183676a17
   183674924:	48 83 c0 28          	add    rax,0x28
   183674928:	48 89 c2             	mov    rdx,rax
   18367492b:	4c 89 c1             	mov    rcx,r8
   18367492e:	e8 0d 88 19 03       	call   0x18680d140
   183674933:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   183674937:	48 83 f8 10          	cmp    rax,0x10
   18367493b:	72 35                	jb     0x183674972
   18367493d:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   183674941:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183674945:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18367494c:	72 1f                	jb     0x18367496d
   18367494e:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183674952:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183674956:	4c 29 c1             	sub    rcx,r8
   183674959:	48 83 f9 20          	cmp    rcx,0x20
   18367495d:	0f 83 b4 20 00 00    	jae    0x183676a17
   183674963:	48 83 c0 28          	add    rax,0x28
   183674967:	48 89 c2             	mov    rdx,rax
   18367496a:	4c 89 c1             	mov    rcx,r8
   18367496d:	e8 ce 87 19 03       	call   0x18680d140
   183674972:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183674979:	00 
   18367497a:	b9 20 00 00 00       	mov    ecx,0x20
   18367497f:	e8 78 87 19 03       	call   0x18680d0fc
   183674984:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183674988:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   18367498f:	00 
   183674990:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183674997:	00 
   183674998:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   18367499b:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   1836749a1:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   1836749a5:	ba 31 00 00 00       	mov    edx,0x31
   1836749aa:	41 b8 24 00 00 00    	mov    r8d,0x24
   1836749b0:	e8 2b ed ff ff       	call   0x1836736e0
   1836749b5:	90                   	nop
   1836749b6:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   1836749ba:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   1836749be:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   1836749c2:	48 89 f1             	mov    rcx,rsi
   1836749c5:	e8 b6 1a 00 fd       	call   0x180676480
   1836749ca:	90                   	nop
   1836749cb:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   1836749cf:	48 83 f8 10          	cmp    rax,0x10
   1836749d3:	72 35                	jb     0x183674a0a
   1836749d5:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   1836749d9:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1836749dd:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1836749e4:	72 1f                	jb     0x183674a05
   1836749e6:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1836749ea:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1836749ee:	4c 29 c1             	sub    rcx,r8
   1836749f1:	48 83 f9 20          	cmp    rcx,0x20
   1836749f5:	0f 83 1c 20 00 00    	jae    0x183676a17
   1836749fb:	48 83 c0 28          	add    rax,0x28
   1836749ff:	48 89 c2             	mov    rdx,rax
   183674a02:	4c 89 c1             	mov    rcx,r8
   183674a05:	e8 36 87 19 03       	call   0x18680d140
   183674a0a:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   183674a0e:	48 83 f8 10          	cmp    rax,0x10
   183674a12:	72 35                	jb     0x183674a49
   183674a14:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   183674a18:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183674a1c:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183674a23:	72 1f                	jb     0x183674a44
   183674a25:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183674a29:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183674a2d:	4c 29 c1             	sub    rcx,r8
   183674a30:	48 83 f9 20          	cmp    rcx,0x20
   183674a34:	0f 83 dd 1f 00 00    	jae    0x183676a17
   183674a3a:	48 83 c0 28          	add    rax,0x28
   183674a3e:	48 89 c2             	mov    rdx,rax
   183674a41:	4c 89 c1             	mov    rcx,r8
   183674a44:	e8 f7 86 19 03       	call   0x18680d140
   183674a49:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183674a50:	00 
   183674a51:	b9 20 00 00 00       	mov    ecx,0x20
   183674a56:	e8 a1 86 19 03       	call   0x18680d0fc
   183674a5b:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183674a5f:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   183674a66:	00 
   183674a67:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183674a6e:	00 
   183674a6f:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   183674a72:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   183674a78:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   183674a7c:	ba 31 00 00 00       	mov    edx,0x31
   183674a81:	41 b8 33 00 00 00    	mov    r8d,0x33
   183674a87:	e8 54 ec ff ff       	call   0x1836736e0
   183674a8c:	90                   	nop
   183674a8d:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183674a91:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   183674a95:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   183674a99:	48 89 f1             	mov    rcx,rsi
   183674a9c:	e8 df 19 00 fd       	call   0x180676480
   183674aa1:	90                   	nop
   183674aa2:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   183674aa6:	48 83 f8 10          	cmp    rax,0x10
   183674aaa:	72 35                	jb     0x183674ae1
   183674aac:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   183674ab0:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183674ab4:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183674abb:	72 1f                	jb     0x183674adc
   183674abd:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183674ac1:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183674ac5:	4c 29 c1             	sub    rcx,r8
   183674ac8:	48 83 f9 20          	cmp    rcx,0x20
   183674acc:	0f 83 45 1f 00 00    	jae    0x183676a17
   183674ad2:	48 83 c0 28          	add    rax,0x28
   183674ad6:	48 89 c2             	mov    rdx,rax
   183674ad9:	4c 89 c1             	mov    rcx,r8
   183674adc:	e8 5f 86 19 03       	call   0x18680d140
   183674ae1:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   183674ae5:	48 83 f8 10          	cmp    rax,0x10
   183674ae9:	72 35                	jb     0x183674b20
   183674aeb:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   183674aef:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183674af3:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183674afa:	72 1f                	jb     0x183674b1b
   183674afc:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183674b00:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183674b04:	4c 29 c1             	sub    rcx,r8
   183674b07:	48 83 f9 20          	cmp    rcx,0x20
   183674b0b:	0f 83 06 1f 00 00    	jae    0x183676a17
   183674b11:	48 83 c0 28          	add    rax,0x28
   183674b15:	48 89 c2             	mov    rdx,rax
   183674b18:	4c 89 c1             	mov    rcx,r8
   183674b1b:	e8 20 86 19 03       	call   0x18680d140
   183674b20:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183674b27:	00 
   183674b28:	b9 20 00 00 00       	mov    ecx,0x20
   183674b2d:	e8 ca 85 19 03       	call   0x18680d0fc
   183674b32:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183674b36:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   183674b3d:	00 
   183674b3e:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183674b45:	00 
   183674b46:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   183674b49:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   183674b4f:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   183674b53:	ba 31 00 00 00       	mov    edx,0x31
   183674b58:	41 b8 3f 00 00 00    	mov    r8d,0x3f
   183674b5e:	e8 7d eb ff ff       	call   0x1836736e0
   183674b63:	90                   	nop
   183674b64:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183674b68:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   183674b6c:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   183674b70:	48 89 f1             	mov    rcx,rsi
   183674b73:	e8 08 19 00 fd       	call   0x180676480
   183674b78:	90                   	nop
   183674b79:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   183674b7d:	48 83 f8 10          	cmp    rax,0x10
   183674b81:	72 35                	jb     0x183674bb8
   183674b83:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   183674b87:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183674b8b:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183674b92:	72 1f                	jb     0x183674bb3
   183674b94:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183674b98:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183674b9c:	4c 29 c1             	sub    rcx,r8
   183674b9f:	48 83 f9 20          	cmp    rcx,0x20
   183674ba3:	0f 83 6e 1e 00 00    	jae    0x183676a17
   183674ba9:	48 83 c0 28          	add    rax,0x28
   183674bad:	48 89 c2             	mov    rdx,rax
   183674bb0:	4c 89 c1             	mov    rcx,r8
   183674bb3:	e8 88 85 19 03       	call   0x18680d140
   183674bb8:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   183674bbc:	48 83 f8 10          	cmp    rax,0x10
   183674bc0:	72 35                	jb     0x183674bf7
   183674bc2:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   183674bc6:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183674bca:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183674bd1:	72 1f                	jb     0x183674bf2
   183674bd3:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183674bd7:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183674bdb:	4c 29 c1             	sub    rcx,r8
   183674bde:	48 83 f9 20          	cmp    rcx,0x20
   183674be2:	0f 83 2f 1e 00 00    	jae    0x183676a17
   183674be8:	48 83 c0 28          	add    rax,0x28
   183674bec:	48 89 c2             	mov    rdx,rax
   183674bef:	4c 89 c1             	mov    rcx,r8
   183674bf2:	e8 49 85 19 03       	call   0x18680d140
   183674bf7:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183674bfe:	00 
   183674bff:	b9 20 00 00 00       	mov    ecx,0x20
   183674c04:	e8 f3 84 19 03       	call   0x18680d0fc
   183674c09:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183674c0d:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   183674c14:	00 
   183674c15:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183674c1c:	00 
   183674c1d:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   183674c20:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   183674c26:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   183674c2a:	ba 31 00 00 00       	mov    edx,0x31
   183674c2f:	41 b8 65 00 00 00    	mov    r8d,0x65
   183674c35:	e8 a6 ea ff ff       	call   0x1836736e0
   183674c3a:	90                   	nop
   183674c3b:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183674c3f:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   183674c43:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   183674c47:	48 89 f1             	mov    rcx,rsi
   183674c4a:	e8 31 18 00 fd       	call   0x180676480
   183674c4f:	90                   	nop
   183674c50:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   183674c54:	48 83 f8 10          	cmp    rax,0x10
   183674c58:	72 35                	jb     0x183674c8f
   183674c5a:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   183674c5e:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183674c62:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183674c69:	72 1f                	jb     0x183674c8a
   183674c6b:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183674c6f:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183674c73:	4c 29 c1             	sub    rcx,r8
   183674c76:	48 83 f9 20          	cmp    rcx,0x20
   183674c7a:	0f 83 97 1d 00 00    	jae    0x183676a17
   183674c80:	48 83 c0 28          	add    rax,0x28
   183674c84:	48 89 c2             	mov    rdx,rax
   183674c87:	4c 89 c1             	mov    rcx,r8
   183674c8a:	e8 b1 84 19 03       	call   0x18680d140
   183674c8f:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   183674c93:	48 83 f8 10          	cmp    rax,0x10
   183674c97:	72 35                	jb     0x183674cce
   183674c99:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   183674c9d:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183674ca1:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183674ca8:	72 1f                	jb     0x183674cc9
   183674caa:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183674cae:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183674cb2:	4c 29 c1             	sub    rcx,r8
   183674cb5:	48 83 f9 20          	cmp    rcx,0x20
   183674cb9:	0f 83 58 1d 00 00    	jae    0x183676a17
   183674cbf:	48 83 c0 28          	add    rax,0x28
   183674cc3:	48 89 c2             	mov    rdx,rax
   183674cc6:	4c 89 c1             	mov    rcx,r8
   183674cc9:	e8 72 84 19 03       	call   0x18680d140
   183674cce:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183674cd5:	00 
   183674cd6:	b9 20 00 00 00       	mov    ecx,0x20
   183674cdb:	e8 1c 84 19 03       	call   0x18680d0fc
   183674ce0:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183674ce4:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   183674ceb:	00 
   183674cec:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183674cf3:	00 
   183674cf4:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   183674cf7:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   183674cfd:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   183674d01:	ba 31 00 00 00       	mov    edx,0x31
   183674d06:	41 b8 58 00 00 00    	mov    r8d,0x58
   183674d0c:	e8 cf e9 ff ff       	call   0x1836736e0
   183674d11:	90                   	nop
   183674d12:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183674d16:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   183674d1a:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   183674d1e:	48 89 f1             	mov    rcx,rsi
   183674d21:	e8 5a 17 00 fd       	call   0x180676480
   183674d26:	90                   	nop
   183674d27:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   183674d2b:	48 83 f8 10          	cmp    rax,0x10
   183674d2f:	72 35                	jb     0x183674d66
   183674d31:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   183674d35:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183674d39:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183674d40:	72 1f                	jb     0x183674d61
   183674d42:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183674d46:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183674d4a:	4c 29 c1             	sub    rcx,r8
   183674d4d:	48 83 f9 20          	cmp    rcx,0x20
   183674d51:	0f 83 c0 1c 00 00    	jae    0x183676a17
   183674d57:	48 83 c0 28          	add    rax,0x28
   183674d5b:	48 89 c2             	mov    rdx,rax
   183674d5e:	4c 89 c1             	mov    rcx,r8
   183674d61:	e8 da 83 19 03       	call   0x18680d140
   183674d66:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   183674d6a:	48 83 f8 10          	cmp    rax,0x10
   183674d6e:	72 35                	jb     0x183674da5
   183674d70:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   183674d74:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183674d78:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183674d7f:	72 1f                	jb     0x183674da0
   183674d81:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183674d85:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183674d89:	4c 29 c1             	sub    rcx,r8
   183674d8c:	48 83 f9 20          	cmp    rcx,0x20
   183674d90:	0f 83 81 1c 00 00    	jae    0x183676a17
   183674d96:	48 83 c0 28          	add    rax,0x28
   183674d9a:	48 89 c2             	mov    rdx,rax
   183674d9d:	4c 89 c1             	mov    rcx,r8
   183674da0:	e8 9b 83 19 03       	call   0x18680d140
   183674da5:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183674dac:	00 
   183674dad:	b9 20 00 00 00       	mov    ecx,0x20
   183674db2:	e8 45 83 19 03       	call   0x18680d0fc
   183674db7:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183674dbb:	48 c7 45 e8 17 00 00 	mov    QWORD PTR [rbp-0x18],0x17
   183674dc2:	00 
   183674dc3:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183674dca:	00 
   183674dcb:	0f 11 38             	movups XMMWORD PTR [rax],xmm7
   183674dce:	4c 89 78 0f          	mov    QWORD PTR [rax+0xf],r15
   183674dd2:	c6 40 17 00          	mov    BYTE PTR [rax+0x17],0x0
   183674dd6:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   183674dda:	ba 31 00 00 00       	mov    edx,0x31
   183674ddf:	41 b8 13 00 00 00    	mov    r8d,0x13
   183674de5:	e8 f6 e8 ff ff       	call   0x1836736e0
   183674dea:	90                   	nop
   183674deb:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183674def:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   183674df3:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   183674df7:	48 89 f1             	mov    rcx,rsi
   183674dfa:	e8 81 16 00 fd       	call   0x180676480
   183674dff:	90                   	nop
   183674e00:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   183674e04:	48 83 f8 10          	cmp    rax,0x10
   183674e08:	72 35                	jb     0x183674e3f
   183674e0a:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   183674e0e:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183674e12:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183674e19:	72 1f                	jb     0x183674e3a
   183674e1b:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183674e1f:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183674e23:	4c 29 c1             	sub    rcx,r8
   183674e26:	48 83 f9 20          	cmp    rcx,0x20
   183674e2a:	0f 83 e7 1b 00 00    	jae    0x183676a17
   183674e30:	48 83 c0 28          	add    rax,0x28
   183674e34:	48 89 c2             	mov    rdx,rax
   183674e37:	4c 89 c1             	mov    rcx,r8
   183674e3a:	e8 01 83 19 03       	call   0x18680d140
   183674e3f:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   183674e43:	48 83 f8 10          	cmp    rax,0x10
   183674e47:	72 35                	jb     0x183674e7e
   183674e49:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   183674e4d:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183674e51:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183674e58:	72 1f                	jb     0x183674e79
   183674e5a:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183674e5e:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183674e62:	4c 29 c1             	sub    rcx,r8
   183674e65:	48 83 f9 20          	cmp    rcx,0x20
   183674e69:	0f 83 a8 1b 00 00    	jae    0x183676a17
   183674e6f:	48 83 c0 28          	add    rax,0x28
   183674e73:	48 89 c2             	mov    rdx,rax
   183674e76:	4c 89 c1             	mov    rcx,r8
   183674e79:	e8 c2 82 19 03       	call   0x18680d140
   183674e7e:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183674e85:	00 
   183674e86:	b9 20 00 00 00       	mov    ecx,0x20
   183674e8b:	e8 6c 82 19 03       	call   0x18680d0fc
   183674e90:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183674e94:	48 c7 45 e8 17 00 00 	mov    QWORD PTR [rbp-0x18],0x17
   183674e9b:	00 
   183674e9c:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183674ea3:	00 
   183674ea4:	44 0f 11 00          	movups XMMWORD PTR [rax],xmm8
   183674ea8:	4c 89 78 0f          	mov    QWORD PTR [rax+0xf],r15
   183674eac:	c6 40 17 00          	mov    BYTE PTR [rax+0x17],0x0
   183674eb0:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   183674eb4:	ba 31 00 00 00       	mov    edx,0x31
   183674eb9:	41 b8 28 00 00 00    	mov    r8d,0x28
   183674ebf:	e8 1c e8 ff ff       	call   0x1836736e0
   183674ec4:	90                   	nop
   183674ec5:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183674ec9:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   183674ecd:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   183674ed1:	48 89 f1             	mov    rcx,rsi
   183674ed4:	e8 a7 15 00 fd       	call   0x180676480
   183674ed9:	90                   	nop
   183674eda:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   183674ede:	48 83 f8 10          	cmp    rax,0x10
   183674ee2:	72 35                	jb     0x183674f19
   183674ee4:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   183674ee8:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183674eec:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183674ef3:	72 1f                	jb     0x183674f14
   183674ef5:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183674ef9:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183674efd:	4c 29 c1             	sub    rcx,r8
   183674f00:	48 83 f9 20          	cmp    rcx,0x20
   183674f04:	0f 83 0d 1b 00 00    	jae    0x183676a17
   183674f0a:	48 83 c0 28          	add    rax,0x28
   183674f0e:	48 89 c2             	mov    rdx,rax
   183674f11:	4c 89 c1             	mov    rcx,r8
   183674f14:	e8 27 82 19 03       	call   0x18680d140
   183674f19:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   183674f1d:	48 83 f8 10          	cmp    rax,0x10
   183674f21:	72 35                	jb     0x183674f58
   183674f23:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   183674f27:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183674f2b:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183674f32:	72 1f                	jb     0x183674f53
   183674f34:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183674f38:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183674f3c:	4c 29 c1             	sub    rcx,r8
   183674f3f:	48 83 f9 20          	cmp    rcx,0x20
   183674f43:	0f 83 ce 1a 00 00    	jae    0x183676a17
   183674f49:	48 83 c0 28          	add    rax,0x28
   183674f4d:	48 89 c2             	mov    rdx,rax
   183674f50:	4c 89 c1             	mov    rcx,r8
   183674f53:	e8 e8 81 19 03       	call   0x18680d140
   183674f58:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183674f5f:	00 
   183674f60:	b9 20 00 00 00       	mov    ecx,0x20
   183674f65:	e8 92 81 19 03       	call   0x18680d0fc
   183674f6a:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183674f6e:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   183674f75:	00 
   183674f76:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183674f7d:	00 
   183674f7e:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   183674f81:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   183674f87:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   183674f8b:	ba 31 00 00 00       	mov    edx,0x31
   183674f90:	41 b8 44 00 00 00    	mov    r8d,0x44
   183674f96:	e8 45 e7 ff ff       	call   0x1836736e0
   183674f9b:	90                   	nop
   183674f9c:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183674fa0:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   183674fa4:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   183674fa8:	48 89 f1             	mov    rcx,rsi
   183674fab:	e8 d0 14 00 fd       	call   0x180676480
   183674fb0:	90                   	nop
   183674fb1:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   183674fb5:	48 83 f8 10          	cmp    rax,0x10
   183674fb9:	72 35                	jb     0x183674ff0
   183674fbb:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   183674fbf:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183674fc3:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183674fca:	72 1f                	jb     0x183674feb
   183674fcc:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183674fd0:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183674fd4:	4c 29 c1             	sub    rcx,r8
   183674fd7:	48 83 f9 20          	cmp    rcx,0x20
   183674fdb:	0f 83 36 1a 00 00    	jae    0x183676a17
   183674fe1:	48 83 c0 28          	add    rax,0x28
   183674fe5:	48 89 c2             	mov    rdx,rax
   183674fe8:	4c 89 c1             	mov    rcx,r8
   183674feb:	e8 50 81 19 03       	call   0x18680d140
   183674ff0:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   183674ff4:	48 83 f8 10          	cmp    rax,0x10
   183674ff8:	72 35                	jb     0x18367502f
   183674ffa:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   183674ffe:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183675002:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183675009:	72 1f                	jb     0x18367502a
   18367500b:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18367500f:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183675013:	4c 29 c1             	sub    rcx,r8
   183675016:	48 83 f9 20          	cmp    rcx,0x20
   18367501a:	0f 83 f7 19 00 00    	jae    0x183676a17
   183675020:	48 83 c0 28          	add    rax,0x28
   183675024:	48 89 c2             	mov    rdx,rax
   183675027:	4c 89 c1             	mov    rcx,r8
   18367502a:	e8 11 81 19 03       	call   0x18680d140
   18367502f:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183675036:	00 
   183675037:	b9 20 00 00 00       	mov    ecx,0x20
   18367503c:	e8 bb 80 19 03       	call   0x18680d0fc
   183675041:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183675045:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   18367504c:	00 
   18367504d:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183675054:	00 
   183675055:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   183675058:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   18367505e:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   183675062:	ba 31 00 00 00       	mov    edx,0x31
   183675067:	41 b8 32 00 00 00    	mov    r8d,0x32
   18367506d:	e8 6e e6 ff ff       	call   0x1836736e0
   183675072:	90                   	nop
   183675073:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183675077:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   18367507b:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18367507f:	48 89 f1             	mov    rcx,rsi
   183675082:	e8 f9 13 00 fd       	call   0x180676480
   183675087:	90                   	nop
   183675088:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18367508c:	48 83 f8 10          	cmp    rax,0x10
   183675090:	72 35                	jb     0x1836750c7
   183675092:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   183675096:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18367509a:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1836750a1:	72 1f                	jb     0x1836750c2
   1836750a3:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1836750a7:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1836750ab:	4c 29 c1             	sub    rcx,r8
   1836750ae:	48 83 f9 20          	cmp    rcx,0x20
   1836750b2:	0f 83 5f 19 00 00    	jae    0x183676a17
   1836750b8:	48 83 c0 28          	add    rax,0x28
   1836750bc:	48 89 c2             	mov    rdx,rax
   1836750bf:	4c 89 c1             	mov    rcx,r8
   1836750c2:	e8 79 80 19 03       	call   0x18680d140
   1836750c7:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   1836750cb:	48 83 f8 10          	cmp    rax,0x10
   1836750cf:	72 35                	jb     0x183675106
   1836750d1:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   1836750d5:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1836750d9:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1836750e0:	72 1f                	jb     0x183675101
   1836750e2:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1836750e6:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1836750ea:	4c 29 c1             	sub    rcx,r8
   1836750ed:	48 83 f9 20          	cmp    rcx,0x20
   1836750f1:	0f 83 20 19 00 00    	jae    0x183676a17
   1836750f7:	48 83 c0 28          	add    rax,0x28
   1836750fb:	48 89 c2             	mov    rdx,rax
   1836750fe:	4c 89 c1             	mov    rcx,r8
   183675101:	e8 3a 80 19 03       	call   0x18680d140
   183675106:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18367510d:	00 
   18367510e:	b9 20 00 00 00       	mov    ecx,0x20
   183675113:	e8 e4 7f 19 03       	call   0x18680d0fc
   183675118:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18367511c:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   183675123:	00 
   183675124:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18367512b:	00 
   18367512c:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   18367512f:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   183675135:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   183675139:	ba 31 00 00 00       	mov    edx,0x31
   18367513e:	41 b8 69 00 00 00    	mov    r8d,0x69
   183675144:	e8 97 e5 ff ff       	call   0x1836736e0
   183675149:	90                   	nop
   18367514a:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18367514e:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   183675152:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   183675156:	48 89 f1             	mov    rcx,rsi
   183675159:	e8 22 13 00 fd       	call   0x180676480
   18367515e:	90                   	nop
   18367515f:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   183675163:	48 83 f8 10          	cmp    rax,0x10
   183675167:	72 35                	jb     0x18367519e
   183675169:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18367516d:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183675171:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183675178:	72 1f                	jb     0x183675199
   18367517a:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18367517e:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183675182:	4c 29 c1             	sub    rcx,r8
   183675185:	48 83 f9 20          	cmp    rcx,0x20
   183675189:	0f 83 88 18 00 00    	jae    0x183676a17
   18367518f:	48 83 c0 28          	add    rax,0x28
   183675193:	48 89 c2             	mov    rdx,rax
   183675196:	4c 89 c1             	mov    rcx,r8
   183675199:	e8 a2 7f 19 03       	call   0x18680d140
   18367519e:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   1836751a2:	48 83 f8 10          	cmp    rax,0x10
   1836751a6:	72 35                	jb     0x1836751dd
   1836751a8:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   1836751ac:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1836751b0:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1836751b7:	72 1f                	jb     0x1836751d8
   1836751b9:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1836751bd:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1836751c1:	4c 29 c1             	sub    rcx,r8
   1836751c4:	48 83 f9 20          	cmp    rcx,0x20
   1836751c8:	0f 83 49 18 00 00    	jae    0x183676a17
   1836751ce:	48 83 c0 28          	add    rax,0x28
   1836751d2:	48 89 c2             	mov    rdx,rax
   1836751d5:	4c 89 c1             	mov    rcx,r8
   1836751d8:	e8 63 7f 19 03       	call   0x18680d140
   1836751dd:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   1836751e4:	00 
   1836751e5:	b9 20 00 00 00       	mov    ecx,0x20
   1836751ea:	e8 0d 7f 19 03       	call   0x18680d0fc
   1836751ef:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   1836751f3:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   1836751fa:	00 
   1836751fb:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183675202:	00 
   183675203:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   183675206:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   18367520c:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   183675210:	ba 31 00 00 00       	mov    edx,0x31
   183675215:	41 b8 5c 00 00 00    	mov    r8d,0x5c
   18367521b:	e8 c0 e4 ff ff       	call   0x1836736e0
   183675220:	90                   	nop
   183675221:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183675225:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   183675229:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18367522d:	48 89 f1             	mov    rcx,rsi
   183675230:	e8 4b 12 00 fd       	call   0x180676480
   183675235:	90                   	nop
   183675236:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18367523a:	48 83 f8 10          	cmp    rax,0x10
   18367523e:	72 35                	jb     0x183675275
   183675240:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   183675244:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183675248:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18367524f:	72 1f                	jb     0x183675270
   183675251:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183675255:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183675259:	4c 29 c1             	sub    rcx,r8
   18367525c:	48 83 f9 20          	cmp    rcx,0x20
   183675260:	0f 83 b1 17 00 00    	jae    0x183676a17
   183675266:	48 83 c0 28          	add    rax,0x28
   18367526a:	48 89 c2             	mov    rdx,rax
   18367526d:	4c 89 c1             	mov    rcx,r8
   183675270:	e8 cb 7e 19 03       	call   0x18680d140
   183675275:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   183675279:	48 83 f8 10          	cmp    rax,0x10
   18367527d:	72 35                	jb     0x1836752b4
   18367527f:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   183675283:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183675287:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18367528e:	72 1f                	jb     0x1836752af
   183675290:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183675294:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183675298:	4c 29 c1             	sub    rcx,r8
   18367529b:	48 83 f9 20          	cmp    rcx,0x20
   18367529f:	0f 83 72 17 00 00    	jae    0x183676a17
   1836752a5:	48 83 c0 28          	add    rax,0x28
   1836752a9:	48 89 c2             	mov    rdx,rax
   1836752ac:	4c 89 c1             	mov    rcx,r8
   1836752af:	e8 8c 7e 19 03       	call   0x18680d140
   1836752b4:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   1836752bb:	00 
   1836752bc:	b9 20 00 00 00       	mov    ecx,0x20
   1836752c1:	e8 36 7e 19 03       	call   0x18680d0fc
   1836752c6:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   1836752ca:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   1836752d1:	00 
   1836752d2:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   1836752d9:	00 
   1836752da:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   1836752dd:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   1836752e3:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   1836752e7:	ba 31 00 00 00       	mov    edx,0x31
   1836752ec:	41 b8 5d 00 00 00    	mov    r8d,0x5d
   1836752f2:	e8 e9 e3 ff ff       	call   0x1836736e0
   1836752f7:	90                   	nop
   1836752f8:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   1836752fc:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   183675300:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   183675304:	48 89 f1             	mov    rcx,rsi
   183675307:	e8 74 11 00 fd       	call   0x180676480
   18367530c:	90                   	nop
   18367530d:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   183675311:	48 83 f8 10          	cmp    rax,0x10
   183675315:	72 35                	jb     0x18367534c
   183675317:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18367531b:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18367531f:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183675326:	72 1f                	jb     0x183675347
   183675328:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18367532c:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183675330:	4c 29 c1             	sub    rcx,r8
   183675333:	48 83 f9 20          	cmp    rcx,0x20
   183675337:	0f 83 da 16 00 00    	jae    0x183676a17
   18367533d:	48 83 c0 28          	add    rax,0x28
   183675341:	48 89 c2             	mov    rdx,rax
   183675344:	4c 89 c1             	mov    rcx,r8
   183675347:	e8 f4 7d 19 03       	call   0x18680d140
   18367534c:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   183675350:	48 83 f8 10          	cmp    rax,0x10
   183675354:	72 35                	jb     0x18367538b
   183675356:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18367535a:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18367535e:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183675365:	72 1f                	jb     0x183675386
   183675367:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18367536b:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18367536f:	4c 29 c1             	sub    rcx,r8
   183675372:	48 83 f9 20          	cmp    rcx,0x20
   183675376:	0f 83 9b 16 00 00    	jae    0x183676a17
   18367537c:	48 83 c0 28          	add    rax,0x28
   183675380:	48 89 c2             	mov    rdx,rax
   183675383:	4c 89 c1             	mov    rcx,r8
   183675386:	e8 b5 7d 19 03       	call   0x18680d140
   18367538b:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183675392:	00 
   183675393:	b9 20 00 00 00       	mov    ecx,0x20
   183675398:	e8 5f 7d 19 03       	call   0x18680d0fc
   18367539d:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   1836753a1:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   1836753a8:	00 
   1836753a9:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   1836753b0:	00 
   1836753b1:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   1836753b4:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   1836753ba:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   1836753be:	ba 31 00 00 00       	mov    edx,0x31
   1836753c3:	41 b8 03 00 00 00    	mov    r8d,0x3
   1836753c9:	e8 12 e3 ff ff       	call   0x1836736e0
   1836753ce:	90                   	nop
   1836753cf:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   1836753d3:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   1836753d7:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   1836753db:	48 89 f1             	mov    rcx,rsi
   1836753de:	e8 9d 10 00 fd       	call   0x180676480
   1836753e3:	90                   	nop
   1836753e4:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   1836753e8:	48 83 f8 10          	cmp    rax,0x10
   1836753ec:	72 35                	jb     0x183675423
   1836753ee:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   1836753f2:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1836753f6:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1836753fd:	72 1f                	jb     0x18367541e
   1836753ff:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183675403:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183675407:	4c 29 c1             	sub    rcx,r8
   18367540a:	48 83 f9 20          	cmp    rcx,0x20
   18367540e:	0f 83 03 16 00 00    	jae    0x183676a17
   183675414:	48 83 c0 28          	add    rax,0x28
   183675418:	48 89 c2             	mov    rdx,rax
   18367541b:	4c 89 c1             	mov    rcx,r8
   18367541e:	e8 1d 7d 19 03       	call   0x18680d140
   183675423:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   183675427:	48 83 f8 10          	cmp    rax,0x10
   18367542b:	72 35                	jb     0x183675462
   18367542d:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   183675431:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183675435:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18367543c:	72 1f                	jb     0x18367545d
   18367543e:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183675442:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183675446:	4c 29 c1             	sub    rcx,r8
   183675449:	48 83 f9 20          	cmp    rcx,0x20
   18367544d:	0f 83 c4 15 00 00    	jae    0x183676a17
   183675453:	48 83 c0 28          	add    rax,0x28
   183675457:	48 89 c2             	mov    rdx,rax
   18367545a:	4c 89 c1             	mov    rcx,r8
   18367545d:	e8 de 7c 19 03       	call   0x18680d140
   183675462:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183675469:	00 
   18367546a:	b9 20 00 00 00       	mov    ecx,0x20
   18367546f:	e8 88 7c 19 03       	call   0x18680d0fc
   183675474:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183675478:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   18367547f:	00 
   183675480:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183675487:	00 
   183675488:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   18367548b:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   183675491:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   183675495:	ba 31 00 00 00       	mov    edx,0x31
   18367549a:	41 b8 d0 07 00 00    	mov    r8d,0x7d0
   1836754a0:	e8 3b e2 ff ff       	call   0x1836736e0
   1836754a5:	90                   	nop
   1836754a6:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   1836754aa:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   1836754ae:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   1836754b2:	48 89 f1             	mov    rcx,rsi
   1836754b5:	e8 c6 0f 00 fd       	call   0x180676480
   1836754ba:	90                   	nop
   1836754bb:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   1836754bf:	48 83 f8 10          	cmp    rax,0x10
   1836754c3:	72 35                	jb     0x1836754fa
   1836754c5:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   1836754c9:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1836754cd:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1836754d4:	72 1f                	jb     0x1836754f5
   1836754d6:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1836754da:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1836754de:	4c 29 c1             	sub    rcx,r8
   1836754e1:	48 83 f9 20          	cmp    rcx,0x20
   1836754e5:	0f 83 2c 15 00 00    	jae    0x183676a17
   1836754eb:	48 83 c0 28          	add    rax,0x28
   1836754ef:	48 89 c2             	mov    rdx,rax
   1836754f2:	4c 89 c1             	mov    rcx,r8
   1836754f5:	e8 46 7c 19 03       	call   0x18680d140
   1836754fa:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   1836754fe:	48 83 f8 10          	cmp    rax,0x10
   183675502:	72 35                	jb     0x183675539
   183675504:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   183675508:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18367550c:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183675513:	72 1f                	jb     0x183675534
   183675515:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183675519:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18367551d:	4c 29 c1             	sub    rcx,r8
   183675520:	48 83 f9 20          	cmp    rcx,0x20
   183675524:	0f 83 ed 14 00 00    	jae    0x183676a17
   18367552a:	48 83 c0 28          	add    rax,0x28
   18367552e:	48 89 c2             	mov    rdx,rax
   183675531:	4c 89 c1             	mov    rcx,r8
   183675534:	e8 07 7c 19 03       	call   0x18680d140
   183675539:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183675540:	00 
   183675541:	b9 20 00 00 00       	mov    ecx,0x20
   183675546:	e8 b1 7b 19 03       	call   0x18680d0fc
   18367554b:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18367554f:	48 c7 45 e8 17 00 00 	mov    QWORD PTR [rbp-0x18],0x17
   183675556:	00 
   183675557:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18367555e:	00 
   18367555f:	0f 11 38             	movups XMMWORD PTR [rax],xmm7
   183675562:	4c 89 78 0f          	mov    QWORD PTR [rax+0xf],r15
   183675566:	c6 40 17 00          	mov    BYTE PTR [rax+0x17],0x0
   18367556a:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   18367556e:	ba 31 00 00 00       	mov    edx,0x31
   183675573:	41 b8 18 00 00 00    	mov    r8d,0x18
   183675579:	e8 62 e1 ff ff       	call   0x1836736e0
   18367557e:	90                   	nop
   18367557f:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183675583:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   183675587:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18367558b:	48 89 f1             	mov    rcx,rsi
   18367558e:	e8 ed 0e 00 fd       	call   0x180676480
   183675593:	90                   	nop
   183675594:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   183675598:	48 83 f8 10          	cmp    rax,0x10
   18367559c:	72 35                	jb     0x1836755d3
   18367559e:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   1836755a2:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1836755a6:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1836755ad:	72 1f                	jb     0x1836755ce
   1836755af:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1836755b3:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1836755b7:	4c 29 c1             	sub    rcx,r8
   1836755ba:	48 83 f9 20          	cmp    rcx,0x20
   1836755be:	0f 83 53 14 00 00    	jae    0x183676a17
   1836755c4:	48 83 c0 28          	add    rax,0x28
   1836755c8:	48 89 c2             	mov    rdx,rax
   1836755cb:	4c 89 c1             	mov    rcx,r8
   1836755ce:	e8 6d 7b 19 03       	call   0x18680d140
   1836755d3:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   1836755d7:	48 83 f8 10          	cmp    rax,0x10
   1836755db:	72 35                	jb     0x183675612
   1836755dd:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   1836755e1:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1836755e5:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1836755ec:	72 1f                	jb     0x18367560d
   1836755ee:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1836755f2:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1836755f6:	4c 29 c1             	sub    rcx,r8
   1836755f9:	48 83 f9 20          	cmp    rcx,0x20
   1836755fd:	0f 83 14 14 00 00    	jae    0x183676a17
   183675603:	48 83 c0 28          	add    rax,0x28
   183675607:	48 89 c2             	mov    rdx,rax
   18367560a:	4c 89 c1             	mov    rcx,r8
   18367560d:	e8 2e 7b 19 03       	call   0x18680d140
   183675612:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183675619:	00 
   18367561a:	b9 20 00 00 00       	mov    ecx,0x20
   18367561f:	e8 d8 7a 19 03       	call   0x18680d0fc
   183675624:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183675628:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   18367562f:	00 
   183675630:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183675637:	00 
   183675638:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   18367563b:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   183675641:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   183675645:	ba 31 00 00 00       	mov    edx,0x31
   18367564a:	41 b8 52 00 00 00    	mov    r8d,0x52
   183675650:	e8 8b e0 ff ff       	call   0x1836736e0
   183675655:	90                   	nop
   183675656:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18367565a:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   18367565e:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   183675662:	48 89 f1             	mov    rcx,rsi
   183675665:	e8 16 0e 00 fd       	call   0x180676480
   18367566a:	90                   	nop
   18367566b:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18367566f:	48 83 f8 10          	cmp    rax,0x10
   183675673:	72 35                	jb     0x1836756aa
   183675675:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   183675679:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18367567d:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183675684:	72 1f                	jb     0x1836756a5
   183675686:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18367568a:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18367568e:	4c 29 c1             	sub    rcx,r8
   183675691:	48 83 f9 20          	cmp    rcx,0x20
   183675695:	0f 83 7c 13 00 00    	jae    0x183676a17
   18367569b:	48 83 c0 28          	add    rax,0x28
   18367569f:	48 89 c2             	mov    rdx,rax
   1836756a2:	4c 89 c1             	mov    rcx,r8
   1836756a5:	e8 96 7a 19 03       	call   0x18680d140
   1836756aa:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   1836756ae:	48 83 f8 10          	cmp    rax,0x10
   1836756b2:	72 35                	jb     0x1836756e9
   1836756b4:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   1836756b8:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1836756bc:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1836756c3:	72 1f                	jb     0x1836756e4
   1836756c5:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1836756c9:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1836756cd:	4c 29 c1             	sub    rcx,r8
   1836756d0:	48 83 f9 20          	cmp    rcx,0x20
   1836756d4:	0f 83 3d 13 00 00    	jae    0x183676a17
   1836756da:	48 83 c0 28          	add    rax,0x28
   1836756de:	48 89 c2             	mov    rdx,rax
   1836756e1:	4c 89 c1             	mov    rcx,r8
   1836756e4:	e8 57 7a 19 03       	call   0x18680d140
   1836756e9:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   1836756f0:	00 
   1836756f1:	b9 20 00 00 00       	mov    ecx,0x20
   1836756f6:	e8 01 7a 19 03       	call   0x18680d0fc
   1836756fb:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   1836756ff:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   183675706:	00 
   183675707:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18367570e:	00 
   18367570f:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   183675712:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   183675718:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   18367571c:	ba 31 00 00 00       	mov    edx,0x31
   183675721:	41 b8 6f 00 00 00    	mov    r8d,0x6f
   183675727:	e8 b4 df ff ff       	call   0x1836736e0
   18367572c:	90                   	nop
   18367572d:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183675731:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   183675735:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   183675739:	48 89 f1             	mov    rcx,rsi
   18367573c:	e8 3f 0d 00 fd       	call   0x180676480
   183675741:	90                   	nop
   183675742:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   183675746:	48 83 f8 10          	cmp    rax,0x10
   18367574a:	72 35                	jb     0x183675781
   18367574c:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   183675750:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183675754:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18367575b:	72 1f                	jb     0x18367577c
   18367575d:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183675761:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183675765:	4c 29 c1             	sub    rcx,r8
   183675768:	48 83 f9 20          	cmp    rcx,0x20
   18367576c:	0f 83 a5 12 00 00    	jae    0x183676a17
   183675772:	48 83 c0 28          	add    rax,0x28
   183675776:	48 89 c2             	mov    rdx,rax
   183675779:	4c 89 c1             	mov    rcx,r8
   18367577c:	e8 bf 79 19 03       	call   0x18680d140
   183675781:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   183675785:	48 83 f8 10          	cmp    rax,0x10
   183675789:	72 35                	jb     0x1836757c0
   18367578b:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18367578f:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183675793:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18367579a:	72 1f                	jb     0x1836757bb
   18367579c:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1836757a0:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1836757a4:	4c 29 c1             	sub    rcx,r8
   1836757a7:	48 83 f9 20          	cmp    rcx,0x20
   1836757ab:	0f 83 66 12 00 00    	jae    0x183676a17
   1836757b1:	48 83 c0 28          	add    rax,0x28
   1836757b5:	48 89 c2             	mov    rdx,rax
   1836757b8:	4c 89 c1             	mov    rcx,r8
   1836757bb:	e8 80 79 19 03       	call   0x18680d140
   1836757c0:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   1836757c7:	00 
   1836757c8:	b9 20 00 00 00       	mov    ecx,0x20
   1836757cd:	e8 2a 79 19 03       	call   0x18680d0fc
   1836757d2:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   1836757d6:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   1836757dd:	00 
   1836757de:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   1836757e5:	00 
   1836757e6:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   1836757e9:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   1836757ef:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   1836757f3:	ba 31 00 00 00       	mov    edx,0x31
   1836757f8:	41 b8 35 00 00 00    	mov    r8d,0x35
   1836757fe:	e8 dd de ff ff       	call   0x1836736e0
   183675803:	90                   	nop
   183675804:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183675808:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   18367580c:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   183675810:	48 89 f1             	mov    rcx,rsi
   183675813:	e8 68 0c 00 fd       	call   0x180676480
   183675818:	90                   	nop
   183675819:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18367581d:	48 83 f8 10          	cmp    rax,0x10
   183675821:	72 35                	jb     0x183675858
   183675823:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   183675827:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18367582b:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183675832:	72 1f                	jb     0x183675853
   183675834:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183675838:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18367583c:	4c 29 c1             	sub    rcx,r8
   18367583f:	48 83 f9 20          	cmp    rcx,0x20
   183675843:	0f 83 ce 11 00 00    	jae    0x183676a17
   183675849:	48 83 c0 28          	add    rax,0x28
   18367584d:	48 89 c2             	mov    rdx,rax
   183675850:	4c 89 c1             	mov    rcx,r8
   183675853:	e8 e8 78 19 03       	call   0x18680d140
   183675858:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18367585c:	48 83 f8 10          	cmp    rax,0x10
   183675860:	72 35                	jb     0x183675897
   183675862:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   183675866:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18367586a:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183675871:	72 1f                	jb     0x183675892
   183675873:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183675877:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18367587b:	4c 29 c1             	sub    rcx,r8
   18367587e:	48 83 f9 20          	cmp    rcx,0x20
   183675882:	0f 83 8f 11 00 00    	jae    0x183676a17
   183675888:	48 83 c0 28          	add    rax,0x28
   18367588c:	48 89 c2             	mov    rdx,rax
   18367588f:	4c 89 c1             	mov    rcx,r8
   183675892:	e8 a9 78 19 03       	call   0x18680d140
   183675897:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18367589e:	00 
   18367589f:	b9 20 00 00 00       	mov    ecx,0x20
   1836758a4:	e8 53 78 19 03       	call   0x18680d0fc
   1836758a9:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   1836758ad:	48 c7 45 e8 11 00 00 	mov    QWORD PTR [rbp-0x18],0x11
   1836758b4:	00 
   1836758b5:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   1836758bc:	00 
   1836758bd:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   1836758c0:	66 c7 40 10 72 00    	mov    WORD PTR [rax+0x10],0x72
   1836758c6:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   1836758ca:	ba 31 00 00 00       	mov    edx,0x31
   1836758cf:	41 b8 84 00 00 00    	mov    r8d,0x84
   1836758d5:	e8 06 de ff ff       	call   0x1836736e0
   1836758da:	90                   	nop
   1836758db:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   1836758df:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   1836758e3:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   1836758e7:	48 89 f1             	mov    rcx,rsi
   1836758ea:	e8 91 0b 00 fd       	call   0x180676480
   1836758ef:	90                   	nop
   1836758f0:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   1836758f4:	48 83 f8 10          	cmp    rax,0x10
   1836758f8:	72 35                	jb     0x18367592f
   1836758fa:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   1836758fe:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183675902:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183675909:	72 1f                	jb     0x18367592a
   18367590b:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18367590f:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183675913:	4c 29 c1             	sub    rcx,r8
   183675916:	48 83 f9 20          	cmp    rcx,0x20
   18367591a:	0f 83 f7 10 00 00    	jae    0x183676a17
   183675920:	48 83 c0 28          	add    rax,0x28
   183675924:	48 89 c2             	mov    rdx,rax
   183675927:	4c 89 c1             	mov    rcx,r8
   18367592a:	e8 11 78 19 03       	call   0x18680d140
   18367592f:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   183675933:	48 83 f8 10          	cmp    rax,0x10
   183675937:	72 35                	jb     0x18367596e
   183675939:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18367593d:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183675941:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183675948:	72 1f                	jb     0x183675969
   18367594a:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18367594e:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183675952:	4c 29 c1             	sub    rcx,r8
   183675955:	48 83 f9 20          	cmp    rcx,0x20
   183675959:	0f 83 b8 10 00 00    	jae    0x183676a17
   18367595f:	48 83 c0 28          	add    rax,0x28
   183675963:	48 89 c2             	mov    rdx,rax
   183675966:	4c 89 c1             	mov    rcx,r8
   183675969:	e8 d2 77 19 03       	call   0x18680d140
   18367596e:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   183675972:	48 89 da             	mov    rdx,rbx
   183675975:	e8 86 38 00 00       	call   0x183679200
   18367597a:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183675981:	00 
   183675982:	b9 20 00 00 00       	mov    ecx,0x20
   183675987:	e8 70 77 19 03       	call   0x18680d0fc
   18367598c:	90                   	nop
   18367598d:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183675991:	48 c7 45 e8 17 00 00 	mov    QWORD PTR [rbp-0x18],0x17
   183675998:	00 
   183675999:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   1836759a0:	00 
   1836759a1:	0f 10 35 49 cd 23 05 	movups xmm6,XMMWORD PTR [rip+0x523cd49]        # 0x1888b26f1
   1836759a8:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   1836759ab:	4c 89 78 0f          	mov    QWORD PTR [rax+0xf],r15
   1836759af:	c6 40 17 00          	mov    BYTE PTR [rax+0x17],0x0
   1836759b3:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   1836759b7:	4c 8d 45 d8          	lea    r8,[rbp-0x28]
   1836759bb:	4c 8d 4d b0          	lea    r9,[rbp-0x50]
   1836759bf:	48 89 f9             	mov    rcx,rdi
   1836759c2:	e8 99 33 00 00       	call   0x183678d60
   1836759c7:	90                   	nop
   1836759c8:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   1836759cc:	48 83 f8 10          	cmp    rax,0x10
   1836759d0:	72 35                	jb     0x183675a07
   1836759d2:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   1836759d6:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1836759da:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1836759e1:	72 1f                	jb     0x183675a02
   1836759e3:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1836759e7:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1836759eb:	4c 29 c1             	sub    rcx,r8
   1836759ee:	48 83 f9 20          	cmp    rcx,0x20
   1836759f2:	0f 83 1f 10 00 00    	jae    0x183676a17
   1836759f8:	48 83 c0 28          	add    rax,0x28
   1836759fc:	48 89 c2             	mov    rdx,rax
   1836759ff:	4c 89 c1             	mov    rcx,r8
   183675a02:	e8 39 77 19 03       	call   0x18680d140
   183675a07:	4c 8b 75 b8          	mov    r14,QWORD PTR [rbp-0x48]
   183675a0b:	4d 85 f6             	test   r14,r14
   183675a0e:	74 1f                	je     0x183675a2f
   183675a10:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   183675a15:	75 18                	jne    0x183675a2f
   183675a17:	49 8b 06             	mov    rax,QWORD PTR [r14]
   183675a1a:	4c 89 f1             	mov    rcx,r14
   183675a1d:	ff 10                	call   QWORD PTR [rax]
   183675a1f:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   183675a24:	75 09                	jne    0x183675a2f
   183675a26:	49 8b 06             	mov    rax,QWORD PTR [r14]
   183675a29:	4c 89 f1             	mov    rcx,r14
   183675a2c:	ff 50 08             	call   QWORD PTR [rax+0x8]
   183675a2f:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183675a36:	00 
   183675a37:	b9 20 00 00 00       	mov    ecx,0x20
   183675a3c:	e8 bb 76 19 03       	call   0x18680d0fc
   183675a41:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183675a45:	48 c7 45 e8 17 00 00 	mov    QWORD PTR [rbp-0x18],0x17
   183675a4c:	00 
   183675a4d:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183675a54:	00 
   183675a55:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   183675a58:	4c 89 78 0f          	mov    QWORD PTR [rax+0xf],r15
   183675a5c:	c6 40 17 00          	mov    BYTE PTR [rax+0x17],0x0
   183675a60:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   183675a64:	ba 31 00 00 00       	mov    edx,0x31
   183675a69:	41 b8 39 00 00 00    	mov    r8d,0x39
   183675a6f:	e8 6c dc ff ff       	call   0x1836736e0
   183675a74:	90                   	nop
   183675a75:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183675a79:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   183675a7d:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   183675a81:	48 89 f1             	mov    rcx,rsi
   183675a84:	e8 57 8f 90 fd       	call   0x180f7e9e0
   183675a89:	90                   	nop
   183675a8a:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   183675a8e:	48 83 f8 10          	cmp    rax,0x10
   183675a92:	72 35                	jb     0x183675ac9
   183675a94:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   183675a98:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183675a9c:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183675aa3:	72 1f                	jb     0x183675ac4
   183675aa5:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183675aa9:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183675aad:	4c 29 c1             	sub    rcx,r8
   183675ab0:	48 83 f9 20          	cmp    rcx,0x20
   183675ab4:	0f 83 5d 0f 00 00    	jae    0x183676a17
   183675aba:	48 83 c0 28          	add    rax,0x28
   183675abe:	48 89 c2             	mov    rdx,rax
   183675ac1:	4c 89 c1             	mov    rcx,r8
   183675ac4:	e8 77 76 19 03       	call   0x18680d140
   183675ac9:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   183675acd:	48 83 f8 10          	cmp    rax,0x10
   183675ad1:	72 35                	jb     0x183675b08
   183675ad3:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   183675ad7:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183675adb:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183675ae2:	72 1f                	jb     0x183675b03
   183675ae4:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183675ae8:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183675aec:	4c 29 c1             	sub    rcx,r8
   183675aef:	48 83 f9 20          	cmp    rcx,0x20
   183675af3:	0f 83 1e 0f 00 00    	jae    0x183676a17
   183675af9:	48 83 c0 28          	add    rax,0x28
   183675afd:	48 89 c2             	mov    rdx,rax
   183675b00:	4c 89 c1             	mov    rcx,r8
   183675b03:	e8 38 76 19 03       	call   0x18680d140
   183675b08:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   183675b0c:	48 89 da             	mov    rdx,rbx
   183675b0f:	e8 fc 37 00 00       	call   0x183679310
   183675b14:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183675b1b:	00 
   183675b1c:	b9 30 00 00 00       	mov    ecx,0x30
   183675b21:	e8 d6 75 19 03       	call   0x18680d0fc
   183675b26:	90                   	nop
   183675b27:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183675b2b:	48 c7 45 e8 21 00 00 	mov    QWORD PTR [rbp-0x18],0x21
   183675b32:	00 
   183675b33:	48 c7 45 f0 2f 00 00 	mov    QWORD PTR [rbp-0x10],0x2f
   183675b3a:	00 
   183675b3b:	0f 10 35 d7 cb 23 05 	movups xmm6,XMMWORD PTR [rip+0x523cbd7]        # 0x1888b2719
   183675b42:	0f 11 70 10          	movups XMMWORD PTR [rax+0x10],xmm6
   183675b46:	0f 10 3d bc cb 23 05 	movups xmm7,XMMWORD PTR [rip+0x523cbbc]        # 0x1888b2709
   183675b4d:	0f 11 38             	movups XMMWORD PTR [rax],xmm7
   183675b50:	66 c7 40 20 72 00    	mov    WORD PTR [rax+0x20],0x72
   183675b56:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183675b5a:	4c 8d 45 d8          	lea    r8,[rbp-0x28]
   183675b5e:	4c 8d 4d b0          	lea    r9,[rbp-0x50]
   183675b62:	48 89 f9             	mov    rcx,rdi
   183675b65:	e8 f6 31 00 00       	call   0x183678d60
   183675b6a:	90                   	nop
   183675b6b:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   183675b6f:	48 83 f8 10          	cmp    rax,0x10
   183675b73:	72 35                	jb     0x183675baa
   183675b75:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   183675b79:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183675b7d:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183675b84:	72 1f                	jb     0x183675ba5
   183675b86:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183675b8a:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183675b8e:	4c 29 c1             	sub    rcx,r8
   183675b91:	48 83 f9 20          	cmp    rcx,0x20
   183675b95:	0f 83 7c 0e 00 00    	jae    0x183676a17
   183675b9b:	48 83 c0 28          	add    rax,0x28
   183675b9f:	48 89 c2             	mov    rdx,rax
   183675ba2:	4c 89 c1             	mov    rcx,r8
   183675ba5:	e8 96 75 19 03       	call   0x18680d140
   183675baa:	4c 8b 75 b8          	mov    r14,QWORD PTR [rbp-0x48]
   183675bae:	4d 85 f6             	test   r14,r14
   183675bb1:	74 1f                	je     0x183675bd2
   183675bb3:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   183675bb8:	75 18                	jne    0x183675bd2
   183675bba:	49 8b 06             	mov    rax,QWORD PTR [r14]
   183675bbd:	4c 89 f1             	mov    rcx,r14
   183675bc0:	ff 10                	call   QWORD PTR [rax]
   183675bc2:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   183675bc7:	75 09                	jne    0x183675bd2
   183675bc9:	49 8b 06             	mov    rax,QWORD PTR [r14]
   183675bcc:	4c 89 f1             	mov    rcx,r14
   183675bcf:	ff 50 08             	call   QWORD PTR [rax+0x8]
   183675bd2:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183675bd9:	00 
   183675bda:	b9 30 00 00 00       	mov    ecx,0x30
   183675bdf:	e8 18 75 19 03       	call   0x18680d0fc
   183675be4:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183675be8:	48 c7 45 e8 21 00 00 	mov    QWORD PTR [rbp-0x18],0x21
   183675bef:	00 
   183675bf0:	48 c7 45 f0 2f 00 00 	mov    QWORD PTR [rbp-0x10],0x2f
   183675bf7:	00 
   183675bf8:	0f 11 38             	movups XMMWORD PTR [rax],xmm7
   183675bfb:	0f 11 70 10          	movups XMMWORD PTR [rax+0x10],xmm6
   183675bff:	66 c7 40 20 72 00    	mov    WORD PTR [rax+0x20],0x72
   183675c05:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   183675c09:	ba 31 00 00 00       	mov    edx,0x31
   183675c0e:	41 b8 54 00 00 00    	mov    r8d,0x54
   183675c14:	e8 c7 da ff ff       	call   0x1836736e0
   183675c19:	90                   	nop
   183675c1a:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183675c1e:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   183675c22:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   183675c26:	48 89 f1             	mov    rcx,rsi
   183675c29:	e8 b2 8d 90 fd       	call   0x180f7e9e0
   183675c2e:	90                   	nop
   183675c2f:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   183675c33:	48 83 f8 10          	cmp    rax,0x10
   183675c37:	72 35                	jb     0x183675c6e
   183675c39:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   183675c3d:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183675c41:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183675c48:	72 1f                	jb     0x183675c69
   183675c4a:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183675c4e:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183675c52:	4c 29 c1             	sub    rcx,r8
   183675c55:	48 83 f9 20          	cmp    rcx,0x20
   183675c59:	0f 83 b8 0d 00 00    	jae    0x183676a17
   183675c5f:	48 83 c0 28          	add    rax,0x28
   183675c63:	48 89 c2             	mov    rdx,rax
   183675c66:	4c 89 c1             	mov    rcx,r8
   183675c69:	e8 d2 74 19 03       	call   0x18680d140
   183675c6e:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   183675c72:	48 83 f8 10          	cmp    rax,0x10
   183675c76:	72 35                	jb     0x183675cad
   183675c78:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   183675c7c:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183675c80:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183675c87:	72 1f                	jb     0x183675ca8
   183675c89:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183675c8d:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183675c91:	4c 29 c1             	sub    rcx,r8
   183675c94:	48 83 f9 20          	cmp    rcx,0x20
   183675c98:	0f 83 79 0d 00 00    	jae    0x183676a17
   183675c9e:	48 83 c0 28          	add    rax,0x28
   183675ca2:	48 89 c2             	mov    rdx,rax
   183675ca5:	4c 89 c1             	mov    rcx,r8
   183675ca8:	e8 93 74 19 03       	call   0x18680d140
   183675cad:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183675cb4:	00 
   183675cb5:	b9 30 00 00 00       	mov    ecx,0x30
   183675cba:	e8 3d 74 19 03       	call   0x18680d0fc
   183675cbf:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183675cc3:	48 c7 45 e8 21 00 00 	mov    QWORD PTR [rbp-0x18],0x21
   183675cca:	00 
   183675ccb:	48 c7 45 f0 2f 00 00 	mov    QWORD PTR [rbp-0x10],0x2f
   183675cd2:	00 
   183675cd3:	0f 11 38             	movups XMMWORD PTR [rax],xmm7
   183675cd6:	0f 11 70 10          	movups XMMWORD PTR [rax+0x10],xmm6
   183675cda:	66 c7 40 20 72 00    	mov    WORD PTR [rax+0x20],0x72
   183675ce0:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   183675ce4:	ba 31 00 00 00       	mov    edx,0x31
   183675ce9:	41 b8 67 00 00 00    	mov    r8d,0x67
   183675cef:	e8 ec d9 ff ff       	call   0x1836736e0
   183675cf4:	90                   	nop
   183675cf5:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183675cf9:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   183675cfd:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   183675d01:	48 89 f1             	mov    rcx,rsi
   183675d04:	e8 d7 8c 90 fd       	call   0x180f7e9e0
   183675d09:	90                   	nop
   183675d0a:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   183675d0e:	48 83 f8 10          	cmp    rax,0x10
   183675d12:	72 35                	jb     0x183675d49
   183675d14:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   183675d18:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183675d1c:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183675d23:	72 1f                	jb     0x183675d44
   183675d25:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183675d29:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183675d2d:	4c 29 c1             	sub    rcx,r8
   183675d30:	48 83 f9 20          	cmp    rcx,0x20
   183675d34:	0f 83 dd 0c 00 00    	jae    0x183676a17
   183675d3a:	48 83 c0 28          	add    rax,0x28
   183675d3e:	48 89 c2             	mov    rdx,rax
   183675d41:	4c 89 c1             	mov    rcx,r8
   183675d44:	e8 f7 73 19 03       	call   0x18680d140
   183675d49:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   183675d4d:	48 83 f8 10          	cmp    rax,0x10
   183675d51:	72 35                	jb     0x183675d88
   183675d53:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   183675d57:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183675d5b:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183675d62:	72 1f                	jb     0x183675d83
   183675d64:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183675d68:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183675d6c:	4c 29 c1             	sub    rcx,r8
   183675d6f:	48 83 f9 20          	cmp    rcx,0x20
   183675d73:	0f 83 9e 0c 00 00    	jae    0x183676a17
   183675d79:	48 83 c0 28          	add    rax,0x28
   183675d7d:	48 89 c2             	mov    rdx,rax
   183675d80:	4c 89 c1             	mov    rcx,r8
   183675d83:	e8 b8 73 19 03       	call   0x18680d140
   183675d88:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   183675d8c:	48 89 da             	mov    rdx,rbx
   183675d8f:	e8 8c 36 00 00       	call   0x183679420
   183675d94:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183675d9b:	00 
   183675d9c:	b9 20 00 00 00       	mov    ecx,0x20
   183675da1:	e8 56 73 19 03       	call   0x18680d0fc
   183675da6:	90                   	nop
   183675da7:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183675dab:	48 c7 45 e8 13 00 00 	mov    QWORD PTR [rbp-0x18],0x13
   183675db2:	00 
   183675db3:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183675dba:	00 
   183675dbb:	0f 10 35 69 c9 23 05 	movups xmm6,XMMWORD PTR [rip+0x523c969]        # 0x1888b272b
   183675dc2:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   183675dc5:	c7 40 0f 64 6c 65 72 	mov    DWORD PTR [rax+0xf],0x72656c64
   183675dcc:	c6 40 13 00          	mov    BYTE PTR [rax+0x13],0x0
   183675dd0:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183675dd4:	4c 8d 45 d8          	lea    r8,[rbp-0x28]
   183675dd8:	4c 8d 4d b0          	lea    r9,[rbp-0x50]
   183675ddc:	48 89 f9             	mov    rcx,rdi
   183675ddf:	e8 9c 37 0a fe       	call   0x181719580
   183675de4:	90                   	nop
   183675de5:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   183675de9:	48 83 f8 10          	cmp    rax,0x10
   183675ded:	72 35                	jb     0x183675e24
   183675def:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   183675df3:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183675df7:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183675dfe:	72 1f                	jb     0x183675e1f
   183675e00:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183675e04:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183675e08:	4c 29 c1             	sub    rcx,r8
   183675e0b:	48 83 f9 20          	cmp    rcx,0x20
   183675e0f:	0f 83 02 0c 00 00    	jae    0x183676a17
   183675e15:	48 83 c0 28          	add    rax,0x28
   183675e19:	48 89 c2             	mov    rdx,rax
   183675e1c:	4c 89 c1             	mov    rcx,r8
   183675e1f:	e8 1c 73 19 03       	call   0x18680d140
   183675e24:	4c 8b 75 b8          	mov    r14,QWORD PTR [rbp-0x48]
   183675e28:	4d 85 f6             	test   r14,r14
   183675e2b:	74 1f                	je     0x183675e4c
   183675e2d:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   183675e32:	75 18                	jne    0x183675e4c
   183675e34:	49 8b 06             	mov    rax,QWORD PTR [r14]
   183675e37:	4c 89 f1             	mov    rcx,r14
   183675e3a:	ff 10                	call   QWORD PTR [rax]
   183675e3c:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   183675e41:	75 09                	jne    0x183675e4c
   183675e43:	49 8b 06             	mov    rax,QWORD PTR [r14]
   183675e46:	4c 89 f1             	mov    rcx,r14
   183675e49:	ff 50 08             	call   QWORD PTR [rax+0x8]
   183675e4c:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183675e53:	00 
   183675e54:	b9 20 00 00 00       	mov    ecx,0x20
   183675e59:	e8 9e 72 19 03       	call   0x18680d0fc
   183675e5e:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183675e62:	48 c7 45 e8 13 00 00 	mov    QWORD PTR [rbp-0x18],0x13
   183675e69:	00 
   183675e6a:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183675e71:	00 
   183675e72:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   183675e75:	c7 40 0f 64 6c 65 72 	mov    DWORD PTR [rax+0xf],0x72656c64
   183675e7c:	c6 40 13 00          	mov    BYTE PTR [rax+0x13],0x0
   183675e80:	0f 57 c0             	xorps  xmm0,xmm0
   183675e83:	0f 29 45 b0          	movaps XMMWORD PTR [rbp-0x50],xmm0
   183675e87:	48 c7 45 c0 02 00 00 	mov    QWORD PTR [rbp-0x40],0x2
   183675e8e:	00 
   183675e8f:	48 c7 45 c8 0f 00 00 	mov    QWORD PTR [rbp-0x38],0xf
   183675e96:	00 
   183675e97:	66 c7 45 b0 33 34    	mov    WORD PTR [rbp-0x50],0x3433
   183675e9d:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183675ea1:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   183675ea5:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   183675ea9:	48 89 f1             	mov    rcx,rsi
   183675eac:	e8 cf 05 00 fd       	call   0x180676480
   183675eb1:	90                   	nop
   183675eb2:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   183675eb6:	48 83 f8 10          	cmp    rax,0x10
   183675eba:	72 35                	jb     0x183675ef1
   183675ebc:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   183675ec0:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183675ec4:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183675ecb:	72 1f                	jb     0x183675eec
   183675ecd:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183675ed1:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183675ed5:	4c 29 c1             	sub    rcx,r8
   183675ed8:	48 83 f9 20          	cmp    rcx,0x20
   183675edc:	0f 83 35 0b 00 00    	jae    0x183676a17
   183675ee2:	48 83 c0 28          	add    rax,0x28
   183675ee6:	48 89 c2             	mov    rdx,rax
   183675ee9:	4c 89 c1             	mov    rcx,r8
   183675eec:	e8 4f 72 19 03       	call   0x18680d140
   183675ef1:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   183675ef5:	48 83 f8 10          	cmp    rax,0x10
   183675ef9:	72 35                	jb     0x183675f30
   183675efb:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   183675eff:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183675f03:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183675f0a:	72 1f                	jb     0x183675f2b
   183675f0c:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183675f10:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183675f14:	4c 29 c1             	sub    rcx,r8
   183675f17:	48 83 f9 20          	cmp    rcx,0x20
   183675f1b:	0f 83 f6 0a 00 00    	jae    0x183676a17
   183675f21:	48 83 c0 28          	add    rax,0x28
   183675f25:	48 89 c2             	mov    rdx,rax
   183675f28:	4c 89 c1             	mov    rcx,r8
   183675f2b:	e8 10 72 19 03       	call   0x18680d140
   183675f30:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   183675f34:	48 89 da             	mov    rdx,rbx
   183675f37:	e8 94 02 f2 ff       	call   0x1835961d0
   183675f3c:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183675f43:	00 
   183675f44:	b9 20 00 00 00       	mov    ecx,0x20
   183675f49:	e8 ae 71 19 03       	call   0x18680d0fc
   183675f4e:	90                   	nop
   183675f4f:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183675f53:	48 c7 45 e8 16 00 00 	mov    QWORD PTR [rbp-0x18],0x16
   183675f5a:	00 
   183675f5b:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183675f62:	00 
   183675f63:	0f 10 35 d5 c7 23 05 	movups xmm6,XMMWORD PTR [rip+0x523c7d5]        # 0x1888b273f
   183675f6a:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   183675f6d:	4c 89 78 0e          	mov    QWORD PTR [rax+0xe],r15
   183675f71:	c6 40 16 00          	mov    BYTE PTR [rax+0x16],0x0
   183675f75:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183675f79:	4c 8d 45 d8          	lea    r8,[rbp-0x28]
   183675f7d:	4c 8d 4d b0          	lea    r9,[rbp-0x50]
   183675f81:	48 89 f9             	mov    rcx,rdi
   183675f84:	e8 f7 35 0a fe       	call   0x181719580
   183675f89:	90                   	nop
   183675f8a:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   183675f8e:	48 83 f8 10          	cmp    rax,0x10
   183675f92:	72 35                	jb     0x183675fc9
   183675f94:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   183675f98:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183675f9c:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183675fa3:	72 1f                	jb     0x183675fc4
   183675fa5:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183675fa9:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183675fad:	4c 29 c1             	sub    rcx,r8
   183675fb0:	48 83 f9 20          	cmp    rcx,0x20
   183675fb4:	0f 83 5d 0a 00 00    	jae    0x183676a17
   183675fba:	48 83 c0 28          	add    rax,0x28
   183675fbe:	48 89 c2             	mov    rdx,rax
   183675fc1:	4c 89 c1             	mov    rcx,r8
   183675fc4:	e8 77 71 19 03       	call   0x18680d140
   183675fc9:	4c 8b 75 b8          	mov    r14,QWORD PTR [rbp-0x48]
   183675fcd:	4d 85 f6             	test   r14,r14
   183675fd0:	74 1f                	je     0x183675ff1
   183675fd2:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   183675fd7:	75 18                	jne    0x183675ff1
   183675fd9:	49 8b 06             	mov    rax,QWORD PTR [r14]
   183675fdc:	4c 89 f1             	mov    rcx,r14
   183675fdf:	ff 10                	call   QWORD PTR [rax]
   183675fe1:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   183675fe6:	75 09                	jne    0x183675ff1
   183675fe8:	49 8b 06             	mov    rax,QWORD PTR [r14]
   183675feb:	4c 89 f1             	mov    rcx,r14
   183675fee:	ff 50 08             	call   QWORD PTR [rax+0x8]
   183675ff1:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183675ff8:	00 
   183675ff9:	b9 20 00 00 00       	mov    ecx,0x20
   183675ffe:	e8 f9 70 19 03       	call   0x18680d0fc
   183676003:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183676007:	48 c7 45 e8 16 00 00 	mov    QWORD PTR [rbp-0x18],0x16
   18367600e:	00 
   18367600f:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183676016:	00 
   183676017:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   18367601a:	4c 89 78 0e          	mov    QWORD PTR [rax+0xe],r15
   18367601e:	c6 40 16 00          	mov    BYTE PTR [rax+0x16],0x0
   183676022:	0f 57 c0             	xorps  xmm0,xmm0
   183676025:	0f 29 45 b0          	movaps XMMWORD PTR [rbp-0x50],xmm0
   183676029:	48 c7 45 c0 02 00 00 	mov    QWORD PTR [rbp-0x40],0x2
   183676030:	00 
   183676031:	48 c7 45 c8 0f 00 00 	mov    QWORD PTR [rbp-0x38],0xf
   183676038:	00 
   183676039:	66 c7 45 b0 34 37    	mov    WORD PTR [rbp-0x50],0x3734
   18367603f:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183676043:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   183676047:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18367604b:	48 89 f1             	mov    rcx,rsi
   18367604e:	e8 2d 04 00 fd       	call   0x180676480
   183676053:	90                   	nop
   183676054:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   183676058:	48 83 f8 10          	cmp    rax,0x10
   18367605c:	72 35                	jb     0x183676093
   18367605e:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   183676062:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183676066:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18367606d:	72 1f                	jb     0x18367608e
   18367606f:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183676073:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183676077:	4c 29 c1             	sub    rcx,r8
   18367607a:	48 83 f9 20          	cmp    rcx,0x20
   18367607e:	0f 83 93 09 00 00    	jae    0x183676a17
   183676084:	48 83 c0 28          	add    rax,0x28
   183676088:	48 89 c2             	mov    rdx,rax
   18367608b:	4c 89 c1             	mov    rcx,r8
   18367608e:	e8 ad 70 19 03       	call   0x18680d140
   183676093:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   183676097:	48 83 f8 10          	cmp    rax,0x10
   18367609b:	72 35                	jb     0x1836760d2
   18367609d:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   1836760a1:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1836760a5:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1836760ac:	72 1f                	jb     0x1836760cd
   1836760ae:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1836760b2:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1836760b6:	4c 29 c1             	sub    rcx,r8
   1836760b9:	48 83 f9 20          	cmp    rcx,0x20
   1836760bd:	0f 83 54 09 00 00    	jae    0x183676a17
   1836760c3:	48 83 c0 28          	add    rax,0x28
   1836760c7:	48 89 c2             	mov    rdx,rax
   1836760ca:	4c 89 c1             	mov    rcx,r8
   1836760cd:	e8 6e 70 19 03       	call   0x18680d140
   1836760d2:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   1836760d9:	00 
   1836760da:	b9 20 00 00 00       	mov    ecx,0x20
   1836760df:	e8 18 70 19 03       	call   0x18680d0fc
   1836760e4:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   1836760e8:	48 c7 45 e8 16 00 00 	mov    QWORD PTR [rbp-0x18],0x16
   1836760ef:	00 
   1836760f0:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   1836760f7:	00 
   1836760f8:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   1836760fb:	4c 89 78 0e          	mov    QWORD PTR [rax+0xe],r15
   1836760ff:	c6 40 16 00          	mov    BYTE PTR [rax+0x16],0x0
   183676103:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   183676107:	ba 31 00 00 00       	mov    edx,0x31
   18367610c:	41 b8 08 00 00 00    	mov    r8d,0x8
   183676112:	e8 c9 d5 ff ff       	call   0x1836736e0
   183676117:	90                   	nop
   183676118:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18367611c:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   183676120:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   183676124:	48 89 f1             	mov    rcx,rsi
   183676127:	e8 54 03 00 fd       	call   0x180676480
   18367612c:	90                   	nop
   18367612d:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   183676131:	48 83 f8 10          	cmp    rax,0x10
   183676135:	72 35                	jb     0x18367616c
   183676137:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18367613b:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18367613f:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183676146:	72 1f                	jb     0x183676167
   183676148:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18367614c:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183676150:	4c 29 c1             	sub    rcx,r8
   183676153:	48 83 f9 20          	cmp    rcx,0x20
   183676157:	0f 83 ba 08 00 00    	jae    0x183676a17
   18367615d:	48 83 c0 28          	add    rax,0x28
   183676161:	48 89 c2             	mov    rdx,rax
   183676164:	4c 89 c1             	mov    rcx,r8
   183676167:	e8 d4 6f 19 03       	call   0x18680d140
   18367616c:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   183676170:	48 83 f8 10          	cmp    rax,0x10
   183676174:	72 35                	jb     0x1836761ab
   183676176:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18367617a:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18367617e:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183676185:	72 1f                	jb     0x1836761a6
   183676187:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18367618b:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18367618f:	4c 29 c1             	sub    rcx,r8
   183676192:	48 83 f9 20          	cmp    rcx,0x20
   183676196:	0f 83 7b 08 00 00    	jae    0x183676a17
   18367619c:	48 83 c0 28          	add    rax,0x28
   1836761a0:	48 89 c2             	mov    rdx,rax
   1836761a3:	4c 89 c1             	mov    rcx,r8
   1836761a6:	e8 95 6f 19 03       	call   0x18680d140
   1836761ab:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   1836761af:	48 89 da             	mov    rdx,rbx
   1836761b2:	e8 39 01 f2 ff       	call   0x1835962f0
   1836761b7:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   1836761be:	00 
   1836761bf:	b9 20 00 00 00       	mov    ecx,0x20
   1836761c4:	e8 33 6f 19 03       	call   0x18680d0fc
   1836761c9:	90                   	nop
   1836761ca:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   1836761ce:	48 c7 45 e8 12 00 00 	mov    QWORD PTR [rbp-0x18],0x12
   1836761d5:	00 
   1836761d6:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   1836761dd:	00 
   1836761de:	0f 10 35 71 c5 23 05 	movups xmm6,XMMWORD PTR [rip+0x523c571]        # 0x1888b2756
   1836761e5:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   1836761e8:	66 c7 40 10 65 72    	mov    WORD PTR [rax+0x10],0x7265
   1836761ee:	c6 40 12 00          	mov    BYTE PTR [rax+0x12],0x0
   1836761f2:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   1836761f6:	4c 8d 45 d8          	lea    r8,[rbp-0x28]
   1836761fa:	4c 8d 4d b0          	lea    r9,[rbp-0x50]
   1836761fe:	48 89 f9             	mov    rcx,rdi
   183676201:	e8 7a 33 0a fe       	call   0x181719580
   183676206:	90                   	nop
   183676207:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18367620b:	48 83 f8 10          	cmp    rax,0x10
   18367620f:	72 35                	jb     0x183676246
   183676211:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   183676215:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183676219:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183676220:	72 1f                	jb     0x183676241
   183676222:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183676226:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18367622a:	4c 29 c1             	sub    rcx,r8
   18367622d:	48 83 f9 20          	cmp    rcx,0x20
   183676231:	0f 83 e0 07 00 00    	jae    0x183676a17
   183676237:	48 83 c0 28          	add    rax,0x28
   18367623b:	48 89 c2             	mov    rdx,rax
   18367623e:	4c 89 c1             	mov    rcx,r8
   183676241:	e8 fa 6e 19 03       	call   0x18680d140
   183676246:	4c 8b 75 b8          	mov    r14,QWORD PTR [rbp-0x48]
   18367624a:	4d 85 f6             	test   r14,r14
   18367624d:	74 1f                	je     0x18367626e
   18367624f:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   183676254:	75 18                	jne    0x18367626e
   183676256:	49 8b 06             	mov    rax,QWORD PTR [r14]
   183676259:	4c 89 f1             	mov    rcx,r14
   18367625c:	ff 10                	call   QWORD PTR [rax]
   18367625e:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   183676263:	75 09                	jne    0x18367626e
   183676265:	49 8b 06             	mov    rax,QWORD PTR [r14]
   183676268:	4c 89 f1             	mov    rcx,r14
   18367626b:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18367626e:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183676275:	00 
   183676276:	b9 20 00 00 00       	mov    ecx,0x20
   18367627b:	e8 7c 6e 19 03       	call   0x18680d0fc
   183676280:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183676284:	48 c7 45 e8 12 00 00 	mov    QWORD PTR [rbp-0x18],0x12
   18367628b:	00 
   18367628c:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183676293:	00 
   183676294:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   183676297:	66 c7 40 10 65 72    	mov    WORD PTR [rax+0x10],0x7265
   18367629d:	c6 40 12 00          	mov    BYTE PTR [rax+0x12],0x0
   1836762a1:	0f 57 c0             	xorps  xmm0,xmm0
   1836762a4:	0f 29 45 b0          	movaps XMMWORD PTR [rbp-0x50],xmm0
   1836762a8:	48 c7 45 c0 02 00 00 	mov    QWORD PTR [rbp-0x40],0x2
   1836762af:	00 
   1836762b0:	48 c7 45 c8 0f 00 00 	mov    QWORD PTR [rbp-0x38],0xf
   1836762b7:	00 
   1836762b8:	66 c7 45 b0 35 30    	mov    WORD PTR [rbp-0x50],0x3035
   1836762be:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   1836762c2:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   1836762c6:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   1836762ca:	48 89 f1             	mov    rcx,rsi
   1836762cd:	e8 ae 01 00 fd       	call   0x180676480
   1836762d2:	90                   	nop
   1836762d3:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   1836762d7:	48 83 f8 10          	cmp    rax,0x10
   1836762db:	72 35                	jb     0x183676312
   1836762dd:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   1836762e1:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1836762e5:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1836762ec:	72 1f                	jb     0x18367630d
   1836762ee:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1836762f2:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1836762f6:	4c 29 c1             	sub    rcx,r8
   1836762f9:	48 83 f9 20          	cmp    rcx,0x20
   1836762fd:	0f 83 14 07 00 00    	jae    0x183676a17
   183676303:	48 83 c0 28          	add    rax,0x28
   183676307:	48 89 c2             	mov    rdx,rax
   18367630a:	4c 89 c1             	mov    rcx,r8
   18367630d:	e8 2e 6e 19 03       	call   0x18680d140
   183676312:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   183676316:	48 83 f8 10          	cmp    rax,0x10
   18367631a:	72 35                	jb     0x183676351
   18367631c:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   183676320:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183676324:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18367632b:	72 1f                	jb     0x18367634c
   18367632d:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183676331:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183676335:	4c 29 c1             	sub    rcx,r8
   183676338:	48 83 f9 20          	cmp    rcx,0x20
   18367633c:	0f 83 d5 06 00 00    	jae    0x183676a17
   183676342:	48 83 c0 28          	add    rax,0x28
   183676346:	48 89 c2             	mov    rdx,rax
   183676349:	4c 89 c1             	mov    rcx,r8
   18367634c:	e8 ef 6d 19 03       	call   0x18680d140
   183676351:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   183676355:	48 89 da             	mov    rdx,rbx
   183676358:	e8 d3 31 00 00       	call   0x183679530
   18367635d:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183676364:	00 
   183676365:	b9 20 00 00 00       	mov    ecx,0x20
   18367636a:	e8 8d 6d 19 03       	call   0x18680d0fc
   18367636f:	90                   	nop
   183676370:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183676374:	48 c7 45 e8 14 00 00 	mov    QWORD PTR [rbp-0x18],0x14
   18367637b:	00 
   18367637c:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183676383:	00 
   183676384:	0f 10 35 de c3 23 05 	movups xmm6,XMMWORD PTR [rip+0x523c3de]        # 0x1888b2769
   18367638b:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   18367638e:	c7 40 10 64 6c 65 72 	mov    DWORD PTR [rax+0x10],0x72656c64
   183676395:	c6 40 14 00          	mov    BYTE PTR [rax+0x14],0x0
   183676399:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18367639d:	4c 8d 45 d8          	lea    r8,[rbp-0x28]
   1836763a1:	4c 8d 4d b0          	lea    r9,[rbp-0x50]
   1836763a5:	48 89 f9             	mov    rcx,rdi
   1836763a8:	e8 d3 31 0a fe       	call   0x181719580
   1836763ad:	90                   	nop
   1836763ae:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   1836763b2:	48 83 f8 10          	cmp    rax,0x10
   1836763b6:	72 35                	jb     0x1836763ed
   1836763b8:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   1836763bc:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1836763c0:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1836763c7:	72 1f                	jb     0x1836763e8
   1836763c9:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1836763cd:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1836763d1:	4c 29 c1             	sub    rcx,r8
   1836763d4:	48 83 f9 20          	cmp    rcx,0x20
   1836763d8:	0f 83 39 06 00 00    	jae    0x183676a17
   1836763de:	48 83 c0 28          	add    rax,0x28
   1836763e2:	48 89 c2             	mov    rdx,rax
   1836763e5:	4c 89 c1             	mov    rcx,r8
   1836763e8:	e8 53 6d 19 03       	call   0x18680d140
   1836763ed:	4c 8b 75 b8          	mov    r14,QWORD PTR [rbp-0x48]
   1836763f1:	4d 85 f6             	test   r14,r14
   1836763f4:	74 1f                	je     0x183676415
   1836763f6:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   1836763fb:	75 18                	jne    0x183676415
   1836763fd:	49 8b 06             	mov    rax,QWORD PTR [r14]
   183676400:	4c 89 f1             	mov    rcx,r14
   183676403:	ff 10                	call   QWORD PTR [rax]
   183676405:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   18367640a:	75 09                	jne    0x183676415
   18367640c:	49 8b 06             	mov    rax,QWORD PTR [r14]
   18367640f:	4c 89 f1             	mov    rcx,r14
   183676412:	ff 50 08             	call   QWORD PTR [rax+0x8]
   183676415:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   18367641c:	00 
   18367641d:	b9 20 00 00 00       	mov    ecx,0x20
   183676422:	e8 d5 6c 19 03       	call   0x18680d0fc
   183676427:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   18367642b:	48 c7 45 e8 14 00 00 	mov    QWORD PTR [rbp-0x18],0x14
   183676432:	00 
   183676433:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   18367643a:	00 
   18367643b:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   18367643e:	c7 40 10 64 6c 65 72 	mov    DWORD PTR [rax+0x10],0x72656c64
   183676445:	c6 40 14 00          	mov    BYTE PTR [rax+0x14],0x0
   183676449:	0f 57 c0             	xorps  xmm0,xmm0
   18367644c:	0f 29 45 b0          	movaps XMMWORD PTR [rbp-0x50],xmm0
   183676450:	48 c7 45 c0 05 00 00 	mov    QWORD PTR [rbp-0x40],0x5
   183676457:	00 
   183676458:	48 c7 45 c8 0f 00 00 	mov    QWORD PTR [rbp-0x38],0xf
   18367645f:	00 
   183676460:	c6 45 b0 31          	mov    BYTE PTR [rbp-0x50],0x31
   183676464:	c7 45 b1 30 30 30 30 	mov    DWORD PTR [rbp-0x4f],0x30303030
   18367646b:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   18367646f:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   183676473:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   183676477:	48 89 f1             	mov    rcx,rsi
   18367647a:	e8 01 00 00 fd       	call   0x180676480
   18367647f:	90                   	nop
   183676480:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   183676484:	48 83 f8 10          	cmp    rax,0x10
   183676488:	72 35                	jb     0x1836764bf
   18367648a:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18367648e:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183676492:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183676499:	72 1f                	jb     0x1836764ba
   18367649b:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18367649f:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1836764a3:	4c 29 c1             	sub    rcx,r8
   1836764a6:	48 83 f9 20          	cmp    rcx,0x20
   1836764aa:	0f 83 67 05 00 00    	jae    0x183676a17
   1836764b0:	48 83 c0 28          	add    rax,0x28
   1836764b4:	48 89 c2             	mov    rdx,rax
   1836764b7:	4c 89 c1             	mov    rcx,r8
   1836764ba:	e8 81 6c 19 03       	call   0x18680d140
   1836764bf:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   1836764c3:	48 83 f8 10          	cmp    rax,0x10
   1836764c7:	72 35                	jb     0x1836764fe
   1836764c9:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   1836764cd:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1836764d1:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1836764d8:	72 1f                	jb     0x1836764f9
   1836764da:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1836764de:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1836764e2:	4c 29 c1             	sub    rcx,r8
   1836764e5:	48 83 f9 20          	cmp    rcx,0x20
   1836764e9:	0f 83 28 05 00 00    	jae    0x183676a17
   1836764ef:	48 83 c0 28          	add    rax,0x28
   1836764f3:	48 89 c2             	mov    rdx,rax
   1836764f6:	4c 89 c1             	mov    rcx,r8
   1836764f9:	e8 42 6c 19 03       	call   0x18680d140
   1836764fe:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   183676502:	48 89 da             	mov    rdx,rbx
   183676505:	e8 46 ff f1 ff       	call   0x183596450
   18367650a:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183676511:	00 
   183676512:	b9 20 00 00 00       	mov    ecx,0x20
   183676517:	e8 e0 6b 19 03       	call   0x18680d0fc
   18367651c:	90                   	nop
   18367651d:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183676521:	48 c7 45 e8 16 00 00 	mov    QWORD PTR [rbp-0x18],0x16
   183676528:	00 
   183676529:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183676530:	00 
   183676531:	0f 10 35 46 c2 23 05 	movups xmm6,XMMWORD PTR [rip+0x523c246]        # 0x1888b277e
   183676538:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   18367653b:	4c 89 78 0e          	mov    QWORD PTR [rax+0xe],r15
   18367653f:	c6 40 16 00          	mov    BYTE PTR [rax+0x16],0x0
   183676543:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183676547:	4c 8d 45 d8          	lea    r8,[rbp-0x28]
   18367654b:	4c 8d 4d b0          	lea    r9,[rbp-0x50]
   18367654f:	48 89 f9             	mov    rcx,rdi
   183676552:	e8 29 30 0a fe       	call   0x181719580
   183676557:	90                   	nop
   183676558:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   18367655c:	48 83 f8 10          	cmp    rax,0x10
   183676560:	72 35                	jb     0x183676597
   183676562:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   183676566:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18367656a:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183676571:	72 1f                	jb     0x183676592
   183676573:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183676577:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18367657b:	4c 29 c1             	sub    rcx,r8
   18367657e:	48 83 f9 20          	cmp    rcx,0x20
   183676582:	0f 83 8f 04 00 00    	jae    0x183676a17
   183676588:	48 83 c0 28          	add    rax,0x28
   18367658c:	48 89 c2             	mov    rdx,rax
   18367658f:	4c 89 c1             	mov    rcx,r8
   183676592:	e8 a9 6b 19 03       	call   0x18680d140
   183676597:	4c 8b 75 b8          	mov    r14,QWORD PTR [rbp-0x48]
   18367659b:	4d 85 f6             	test   r14,r14
   18367659e:	74 1f                	je     0x1836765bf
   1836765a0:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   1836765a5:	75 18                	jne    0x1836765bf
   1836765a7:	49 8b 06             	mov    rax,QWORD PTR [r14]
   1836765aa:	4c 89 f1             	mov    rcx,r14
   1836765ad:	ff 10                	call   QWORD PTR [rax]
   1836765af:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   1836765b4:	75 09                	jne    0x1836765bf
   1836765b6:	49 8b 06             	mov    rax,QWORD PTR [r14]
   1836765b9:	4c 89 f1             	mov    rcx,r14
   1836765bc:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1836765bf:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   1836765c6:	00 
   1836765c7:	b9 20 00 00 00       	mov    ecx,0x20
   1836765cc:	e8 2b 6b 19 03       	call   0x18680d0fc
   1836765d1:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   1836765d5:	48 c7 45 e8 16 00 00 	mov    QWORD PTR [rbp-0x18],0x16
   1836765dc:	00 
   1836765dd:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   1836765e4:	00 
   1836765e5:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   1836765e8:	4c 89 78 0e          	mov    QWORD PTR [rax+0xe],r15
   1836765ec:	c6 40 16 00          	mov    BYTE PTR [rax+0x16],0x0
   1836765f0:	0f 57 c0             	xorps  xmm0,xmm0
   1836765f3:	0f 29 45 b0          	movaps XMMWORD PTR [rbp-0x50],xmm0
   1836765f7:	48 c7 45 c0 02 00 00 	mov    QWORD PTR [rbp-0x40],0x2
   1836765fe:	00 
   1836765ff:	48 c7 45 c8 0f 00 00 	mov    QWORD PTR [rbp-0x38],0xf
   183676606:	00 
   183676607:	66 c7 45 b0 34 38    	mov    WORD PTR [rbp-0x50],0x3834
   18367660d:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183676611:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   183676615:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   183676619:	48 89 f1             	mov    rcx,rsi
   18367661c:	e8 5f fe ff fc       	call   0x180676480
   183676621:	90                   	nop
   183676622:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   183676626:	48 83 f8 10          	cmp    rax,0x10
   18367662a:	72 35                	jb     0x183676661
   18367662c:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   183676630:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183676634:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18367663b:	72 1f                	jb     0x18367665c
   18367663d:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183676641:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183676645:	4c 29 c1             	sub    rcx,r8
   183676648:	48 83 f9 20          	cmp    rcx,0x20
   18367664c:	0f 83 c5 03 00 00    	jae    0x183676a17
   183676652:	48 83 c0 28          	add    rax,0x28
   183676656:	48 89 c2             	mov    rdx,rax
   183676659:	4c 89 c1             	mov    rcx,r8
   18367665c:	e8 df 6a 19 03       	call   0x18680d140
   183676661:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   183676665:	48 83 f8 10          	cmp    rax,0x10
   183676669:	72 35                	jb     0x1836766a0
   18367666b:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18367666f:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183676673:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18367667a:	72 1f                	jb     0x18367669b
   18367667c:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183676680:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183676684:	4c 29 c1             	sub    rcx,r8
   183676687:	48 83 f9 20          	cmp    rcx,0x20
   18367668b:	0f 83 86 03 00 00    	jae    0x183676a17
   183676691:	48 83 c0 28          	add    rax,0x28
   183676695:	48 89 c2             	mov    rdx,rax
   183676698:	4c 89 c1             	mov    rcx,r8
   18367669b:	e8 a0 6a 19 03       	call   0x18680d140
   1836766a0:	48 8d 4d b0          	lea    rcx,[rbp-0x50]
   1836766a4:	48 89 da             	mov    rdx,rbx
   1836766a7:	e8 c4 fe f1 ff       	call   0x183596570
   1836766ac:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   1836766b3:	00 
   1836766b4:	b9 20 00 00 00       	mov    ecx,0x20
   1836766b9:	e8 3e 6a 19 03       	call   0x18680d0fc
   1836766be:	90                   	nop
   1836766bf:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   1836766c3:	48 c7 45 e8 17 00 00 	mov    QWORD PTR [rbp-0x18],0x17
   1836766ca:	00 
   1836766cb:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   1836766d2:	00 
   1836766d3:	0f 10 35 bb c0 23 05 	movups xmm6,XMMWORD PTR [rip+0x523c0bb]        # 0x1888b2795
   1836766da:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   1836766dd:	4c 89 78 0f          	mov    QWORD PTR [rax+0xf],r15
   1836766e1:	c6 40 17 00          	mov    BYTE PTR [rax+0x17],0x0
   1836766e5:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   1836766e9:	4c 8d 45 d8          	lea    r8,[rbp-0x28]
   1836766ed:	4c 8d 4d b0          	lea    r9,[rbp-0x50]
   1836766f1:	48 89 f9             	mov    rcx,rdi
   1836766f4:	e8 87 2e 0a fe       	call   0x181719580
   1836766f9:	90                   	nop
   1836766fa:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   1836766fe:	48 83 f8 10          	cmp    rax,0x10
   183676702:	72 35                	jb     0x183676739
   183676704:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   183676708:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18367670c:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183676713:	72 1f                	jb     0x183676734
   183676715:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183676719:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18367671d:	4c 29 c1             	sub    rcx,r8
   183676720:	48 83 f9 20          	cmp    rcx,0x20
   183676724:	0f 83 ed 02 00 00    	jae    0x183676a17
   18367672a:	48 83 c0 28          	add    rax,0x28
   18367672e:	48 89 c2             	mov    rdx,rax
   183676731:	4c 89 c1             	mov    rcx,r8
   183676734:	e8 07 6a 19 03       	call   0x18680d140
   183676739:	48 8b 7d b8          	mov    rdi,QWORD PTR [rbp-0x48]
   18367673d:	48 85 ff             	test   rdi,rdi
   183676740:	74 1d                	je     0x18367675f
   183676742:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   183676746:	75 17                	jne    0x18367675f
   183676748:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   18367674b:	48 89 f9             	mov    rcx,rdi
   18367674e:	ff 10                	call   QWORD PTR [rax]
   183676750:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   183676754:	75 09                	jne    0x18367675f
   183676756:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   183676759:	48 89 f9             	mov    rcx,rdi
   18367675c:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18367675f:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183676766:	00 
   183676767:	b9 20 00 00 00       	mov    ecx,0x20
   18367676c:	e8 8b 69 19 03       	call   0x18680d0fc
   183676771:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183676775:	48 c7 45 e8 17 00 00 	mov    QWORD PTR [rbp-0x18],0x17
   18367677c:	00 
   18367677d:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183676784:	00 
   183676785:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   183676788:	4c 89 78 0f          	mov    QWORD PTR [rax+0xf],r15
   18367678c:	c6 40 17 00          	mov    BYTE PTR [rax+0x17],0x0
   183676790:	0f 57 c0             	xorps  xmm0,xmm0
   183676793:	0f 29 45 b0          	movaps XMMWORD PTR [rbp-0x50],xmm0
   183676797:	48 c7 45 c0 02 00 00 	mov    QWORD PTR [rbp-0x40],0x2
   18367679e:	00 
   18367679f:	48 c7 45 c8 0f 00 00 	mov    QWORD PTR [rbp-0x38],0xf
   1836767a6:	00 
   1836767a7:	66 c7 45 b0 34 32    	mov    WORD PTR [rbp-0x50],0x3234
   1836767ad:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   1836767b1:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   1836767b5:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   1836767b9:	48 89 f1             	mov    rcx,rsi
   1836767bc:	e8 bf fc ff fc       	call   0x180676480
   1836767c1:	90                   	nop
   1836767c2:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   1836767c6:	48 83 f8 10          	cmp    rax,0x10
   1836767ca:	72 35                	jb     0x183676801
   1836767cc:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   1836767d0:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1836767d4:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1836767db:	72 1f                	jb     0x1836767fc
   1836767dd:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1836767e1:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1836767e5:	4c 29 c1             	sub    rcx,r8
   1836767e8:	48 83 f9 20          	cmp    rcx,0x20
   1836767ec:	0f 83 25 02 00 00    	jae    0x183676a17
   1836767f2:	48 83 c0 28          	add    rax,0x28
   1836767f6:	48 89 c2             	mov    rdx,rax
   1836767f9:	4c 89 c1             	mov    rcx,r8
   1836767fc:	e8 3f 69 19 03       	call   0x18680d140
   183676801:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   183676805:	48 83 f8 10          	cmp    rax,0x10
   183676809:	72 35                	jb     0x183676840
   18367680b:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18367680f:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183676813:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18367681a:	72 1f                	jb     0x18367683b
   18367681c:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183676820:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183676824:	4c 29 c1             	sub    rcx,r8
   183676827:	48 83 f9 20          	cmp    rcx,0x20
   18367682b:	0f 83 e6 01 00 00    	jae    0x183676a17
   183676831:	48 83 c0 28          	add    rax,0x28
   183676835:	48 89 c2             	mov    rdx,rax
   183676838:	4c 89 c1             	mov    rcx,r8
   18367683b:	e8 00 69 19 03       	call   0x18680d140
   183676840:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183676847:	00 
   183676848:	b9 20 00 00 00       	mov    ecx,0x20
   18367684d:	e8 aa 68 19 03       	call   0x18680d0fc
   183676852:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183676856:	48 c7 45 e8 17 00 00 	mov    QWORD PTR [rbp-0x18],0x17
   18367685d:	00 
   18367685e:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183676865:	00 
   183676866:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   183676869:	4c 89 78 0f          	mov    QWORD PTR [rax+0xf],r15
   18367686d:	c6 40 17 00          	mov    BYTE PTR [rax+0x17],0x0
   183676871:	0f 57 c0             	xorps  xmm0,xmm0
   183676874:	0f 29 45 b0          	movaps XMMWORD PTR [rbp-0x50],xmm0
   183676878:	48 c7 45 c0 02 00 00 	mov    QWORD PTR [rbp-0x40],0x2
   18367687f:	00 
   183676880:	48 c7 45 c8 0f 00 00 	mov    QWORD PTR [rbp-0x38],0xf
   183676887:	00 
   183676888:	66 c7 45 b0 36 36    	mov    WORD PTR [rbp-0x50],0x3636
   18367688e:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183676892:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   183676896:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18367689a:	48 89 f1             	mov    rcx,rsi
   18367689d:	e8 de fb ff fc       	call   0x180676480
   1836768a2:	90                   	nop
   1836768a3:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   1836768a7:	48 83 f8 10          	cmp    rax,0x10
   1836768ab:	72 35                	jb     0x1836768e2
   1836768ad:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   1836768b1:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1836768b5:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1836768bc:	72 1f                	jb     0x1836768dd
   1836768be:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1836768c2:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1836768c6:	4c 29 c1             	sub    rcx,r8
   1836768c9:	48 83 f9 20          	cmp    rcx,0x20
   1836768cd:	0f 83 44 01 00 00    	jae    0x183676a17
   1836768d3:	48 83 c0 28          	add    rax,0x28
   1836768d7:	48 89 c2             	mov    rdx,rax
   1836768da:	4c 89 c1             	mov    rcx,r8
   1836768dd:	e8 5e 68 19 03       	call   0x18680d140
   1836768e2:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   1836768e6:	48 83 f8 10          	cmp    rax,0x10
   1836768ea:	72 35                	jb     0x183676921
   1836768ec:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   1836768f0:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1836768f4:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1836768fb:	72 1f                	jb     0x18367691c
   1836768fd:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183676901:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183676905:	4c 29 c1             	sub    rcx,r8
   183676908:	48 83 f9 20          	cmp    rcx,0x20
   18367690c:	0f 83 05 01 00 00    	jae    0x183676a17
   183676912:	48 83 c0 28          	add    rax,0x28
   183676916:	48 89 c2             	mov    rdx,rax
   183676919:	4c 89 c1             	mov    rcx,r8
   18367691c:	e8 1f 68 19 03       	call   0x18680d140
   183676921:	48 c7 45 e0 00 00 00 	mov    QWORD PTR [rbp-0x20],0x0
   183676928:	00 
   183676929:	b9 20 00 00 00       	mov    ecx,0x20
   18367692e:	e8 c9 67 19 03       	call   0x18680d0fc
   183676933:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   183676937:	48 c7 45 e8 17 00 00 	mov    QWORD PTR [rbp-0x18],0x17
   18367693e:	00 
   18367693f:	48 c7 45 f0 1f 00 00 	mov    QWORD PTR [rbp-0x10],0x1f
   183676946:	00 
   183676947:	0f 11 30             	movups XMMWORD PTR [rax],xmm6
   18367694a:	4c 89 78 0f          	mov    QWORD PTR [rax+0xf],r15
   18367694e:	c6 40 17 00          	mov    BYTE PTR [rax+0x17],0x0
   183676952:	0f 57 c0             	xorps  xmm0,xmm0
   183676955:	0f 29 45 b0          	movaps XMMWORD PTR [rbp-0x50],xmm0
   183676959:	48 c7 45 c0 02 00 00 	mov    QWORD PTR [rbp-0x40],0x2
   183676960:	00 
   183676961:	48 c7 45 c8 0f 00 00 	mov    QWORD PTR [rbp-0x38],0xf
   183676968:	00 
   183676969:	66 c7 45 b0 36 37    	mov    WORD PTR [rbp-0x50],0x3736
   18367696f:	48 8d 55 a0          	lea    rdx,[rbp-0x60]
   183676973:	4c 8d 45 b0          	lea    r8,[rbp-0x50]
   183676977:	4c 8d 4d d8          	lea    r9,[rbp-0x28]
   18367697b:	48 89 f1             	mov    rcx,rsi
   18367697e:	e8 fd fa ff fc       	call   0x180676480
   183676983:	90                   	nop
   183676984:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   183676988:	48 83 f8 10          	cmp    rax,0x10
   18367698c:	72 31                	jb     0x1836769bf
   18367698e:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   183676992:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183676996:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18367699d:	72 1b                	jb     0x1836769ba
   18367699f:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1836769a3:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1836769a7:	4c 29 c1             	sub    rcx,r8
   1836769aa:	48 83 f9 20          	cmp    rcx,0x20
   1836769ae:	73 67                	jae    0x183676a17
   1836769b0:	48 83 c0 28          	add    rax,0x28
   1836769b4:	48 89 c2             	mov    rdx,rax
   1836769b7:	4c 89 c1             	mov    rcx,r8
   1836769ba:	e8 81 67 19 03       	call   0x18680d140
   1836769bf:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   1836769c3:	48 83 f8 10          	cmp    rax,0x10
   1836769c7:	72 31                	jb     0x1836769fa
   1836769c9:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   1836769cd:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1836769d1:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1836769d8:	72 1b                	jb     0x1836769f5
   1836769da:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1836769de:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1836769e2:	4c 29 c1             	sub    rcx,r8
   1836769e5:	48 83 f9 20          	cmp    rcx,0x20
   1836769e9:	73 2c                	jae    0x183676a17
   1836769eb:	48 83 c0 28          	add    rax,0x28
   1836769ef:	48 89 c2             	mov    rdx,rax
   1836769f2:	4c 89 c1             	mov    rcx,r8
   1836769f5:	e8 46 67 19 03       	call   0x18680d140
   1836769fa:	0f 28 75 00          	movaps xmm6,XMMWORD PTR [rbp+0x0]
   1836769fe:	0f 28 7d 10          	movaps xmm7,XMMWORD PTR [rbp+0x10]
   183676a02:	44 0f 28 45 20       	movaps xmm8,XMMWORD PTR [rbp+0x20]
   183676a07:	48 81 c4 b8 00 00 00 	add    rsp,0xb8
   183676a0e:	5b                   	pop    rbx
   183676a0f:	5f                   	pop    rdi
   183676a10:	5e                   	pop    rsi
   183676a11:	41 5e                	pop    r14
   183676a13:	41 5f                	pop    r15
   183676a15:	5d                   	pop    rbp
   183676a16:	c3                   	ret
   183676a17:	e8 5c 9a 1e 03       	call   0x186860478
   183676a1c:	cc                   	int3
