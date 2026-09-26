
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000183788740 <.text+0x3787740>:
   183788740:	55                   	push   rbp
   183788741:	41 57                	push   r15
   183788743:	41 56                	push   r14
   183788745:	41 55                	push   r13
   183788747:	41 54                	push   r12
   183788749:	56                   	push   rsi
   18378874a:	57                   	push   rdi
   18378874b:	53                   	push   rbx
   18378874c:	48 81 ec 98 02 00 00 	sub    rsp,0x298
   183788753:	48 8d ac 24 80 00 00 	lea    rbp,[rsp+0x80]
   18378875a:	00 
   18378875b:	0f 29 b5 00 02 00 00 	movaps XMMWORD PTR [rbp+0x200],xmm6
   183788762:	48 c7 85 f8 01 00 00 	mov    QWORD PTR [rbp+0x1f8],0xfffffffffffffffe
   183788769:	fe ff ff ff 
   18378876d:	48 89 d7             	mov    rdi,rdx
   183788770:	48 89 ce             	mov    rsi,rcx
   183788773:	48 8b 0a             	mov    rcx,QWORD PTR [rdx]
   183788776:	48 85 c9             	test   rcx,rcx
   183788779:	0f 84 a9 00 00 00    	je     0x183788828
   18378877f:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   183788782:	ff 50 10             	call   QWORD PTR [rax+0x10]
   183788785:	89 c3                	mov    ebx,eax
   183788787:	48 8b 0f             	mov    rcx,QWORD PTR [rdi]
   18378878a:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18378878d:	ff 50 08             	call   QWORD PTR [rax+0x8]
   183788790:	89 c0                	mov    eax,eax
   183788792:	48 c1 e3 20          	shl    rbx,0x20
   183788796:	48 8d 0c 03          	lea    rcx,[rbx+rax*1]
   18378879a:	48 83 c1 d6          	add    rcx,0xffffffffffffffd6
   18378879e:	48 83 f9 19          	cmp    rcx,0x19
   1837887a2:	0f 87 ea 00 00 00    	ja     0x183788892
   1837887a8:	ba 01 00 00 03       	mov    edx,0x3000001
   1837887ad:	48 0f a3 ca          	bt     rdx,rcx
   1837887b1:	0f 83 db 00 00 00    	jae    0x183788892
   1837887b7:	48 09 c3             	or     rbx,rax
   1837887ba:	0f 28 35 ef d3 5b 05 	movaps xmm6,XMMWORD PTR [rip+0x55bd3ef]        # 0x188d45bb0
   1837887c1:	0f 29 b5 90 01 00 00 	movaps XMMWORD PTR [rbp+0x190],xmm6
   1837887c8:	0f 29 b5 80 01 00 00 	movaps XMMWORD PTR [rbp+0x180],xmm6
   1837887cf:	4c 8d b5 80 01 00 00 	lea    r14,[rbp+0x180]
   1837887d6:	4c 89 f1             	mov    rcx,r14
   1837887d9:	48 89 da             	mov    rdx,rbx
   1837887dc:	e8 6f 17 00 00       	call   0x183789f50
   1837887e1:	0f 29 b5 10 01 00 00 	movaps XMMWORD PTR [rbp+0x110],xmm6
   1837887e8:	48 8b 0f             	mov    rcx,QWORD PTR [rdi]
   1837887eb:	c7 44 24 20 00 00 00 	mov    DWORD PTR [rsp+0x20],0x0
   1837887f2:	00 
   1837887f3:	4c 8d 05 d6 ae 99 07 	lea    r8,[rip+0x799aed6]        # 0x18b1236d0
   1837887fa:	4c 8d 0d 1f dd 9e 07 	lea    r9,[rip+0x79edd1f]        # 0x18b176520
   183788801:	31 d2                	xor    edx,edx
   183788803:	e8 e4 b1 d6 03       	call   0x1874f39ec
   183788808:	90                   	nop
   183788809:	48 85 c0             	test   rax,rax
   18378880c:	74 32                	je     0x183788840
   18378880e:	48 8b 4f 08          	mov    rcx,QWORD PTR [rdi+0x8]
   183788812:	48 85 c9             	test   rcx,rcx
   183788815:	0f 84 9c 00 00 00    	je     0x1837888b7
   18378881b:	f0 ff 41 08          	lock inc DWORD PTR [rcx+0x8]
   18378881f:	48 8b 4f 08          	mov    rcx,QWORD PTR [rdi+0x8]
   183788823:	e9 91 00 00 00       	jmp    0x1837888b9
   183788828:	48 8b 47 08          	mov    rax,QWORD PTR [rdi+0x8]
   18378882c:	48 85 c0             	test   rax,rax
   18378882f:	74 7b                	je     0x1837888ac
   183788831:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   183788835:	0f 10 07             	movups xmm0,XMMWORD PTR [rdi]
   183788838:	0f 11 06             	movups XMMWORD PTR [rsi],xmm0
   18378883b:	e9 04 11 00 00       	jmp    0x183789944
   183788840:	0f 57 c0             	xorps  xmm0,xmm0
   183788843:	0f 29 85 10 01 00 00 	movaps XMMWORD PTR [rbp+0x110],xmm0
   18378884a:	0f 29 75 70          	movaps XMMWORD PTR [rbp+0x70],xmm6
   18378884e:	48 8b 0f             	mov    rcx,QWORD PTR [rdi]
   183788851:	c7 44 24 20 00 00 00 	mov    DWORD PTR [rsp+0x20],0x0
   183788858:	00 
   183788859:	4c 8d 05 70 ae 99 07 	lea    r8,[rip+0x799ae70]        # 0x18b1236d0
   183788860:	4c 8d 0d a9 b7 bc 07 	lea    r9,[rip+0x7bcb7a9]        # 0x18b354010
   183788867:	31 d2                	xor    edx,edx
   183788869:	e8 7e b1 d6 03       	call   0x1874f39ec
   18378886e:	90                   	nop
   18378886f:	48 85 c0             	test   rax,rax
   183788872:	0f 84 03 0e 00 00    	je     0x18378967b
   183788878:	48 8b 4f 08          	mov    rcx,QWORD PTR [rdi+0x8]
   18378887c:	48 85 c9             	test   rcx,rcx
   18378887f:	0f 84 f6 01 00 00    	je     0x183788a7b
   183788885:	f0 ff 41 08          	lock inc DWORD PTR [rcx+0x8]
   183788889:	48 8b 4f 08          	mov    rcx,QWORD PTR [rdi+0x8]
   18378888d:	e9 eb 01 00 00       	jmp    0x183788a7d
   183788892:	48 8b 47 08          	mov    rax,QWORD PTR [rdi+0x8]
   183788896:	48 85 c0             	test   rax,rax
   183788899:	0f 84 53 01 00 00    	je     0x1837889f2
   18378889f:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   1837888a3:	48 8b 47 08          	mov    rax,QWORD PTR [rdi+0x8]
   1837888a7:	e9 48 01 00 00       	jmp    0x1837889f4
   1837888ac:	0f 57 c0             	xorps  xmm0,xmm0
   1837888af:	0f 11 06             	movups XMMWORD PTR [rsi],xmm0
   1837888b2:	e9 8d 10 00 00       	jmp    0x183789944
   1837888b7:	31 c9                	xor    ecx,ecx
   1837888b9:	48 89 85 10 01 00 00 	mov    QWORD PTR [rbp+0x110],rax
   1837888c0:	48 89 8d 18 01 00 00 	mov    QWORD PTR [rbp+0x118],rcx
   1837888c7:	48 05 18 01 00 00    	add    rax,0x118
   1837888cd:	0f 29 75 c0          	movaps XMMWORD PTR [rbp-0x40],xmm6
   1837888d1:	48 8d 4d c0          	lea    rcx,[rbp-0x40]
   1837888d5:	48 89 c2             	mov    rdx,rax
   1837888d8:	e8 b3 24 2d fd       	call   0x180a5ad90
   1837888dd:	90                   	nop
   1837888de:	48 8b 5d c0          	mov    rbx,QWORD PTR [rbp-0x40]
   1837888e2:	48 85 db             	test   rbx,rbx
   1837888e5:	0f 84 7e 01 00 00    	je     0x183788a69
   1837888eb:	b9 f8 02 00 00       	mov    ecx,0x2f8
   1837888f0:	e8 a7 2f d2 03       	call   0x1874ab89c
   1837888f5:	90                   	nop
   1837888f6:	48 b9 01 00 00 00 01 	movabs rcx,0x100000001
   1837888fd:	00 00 00 
   183788900:	48 89 48 08          	mov    QWORD PTR [rax+0x8],rcx
   183788904:	48 8d 0d bd 6f 61 05 	lea    rcx,[rip+0x5616fbd]        # 0x188d9f8c8
   18378890b:	48 89 08             	mov    QWORD PTR [rax],rcx
   18378890e:	4c 8d 78 10          	lea    r15,[rax+0x10]
   183788912:	4c 89 f9             	mov    rcx,r15
   183788915:	48 89 da             	mov    rdx,rbx
   183788918:	48 89 85 a8 01 00 00 	mov    QWORD PTR [rbp+0x1a8],rax
   18378891f:	e8 bc b9 a3 fc       	call   0x1801c42e0
   183788924:	90                   	nop
   183788925:	4c 89 bd 20 01 00 00 	mov    QWORD PTR [rbp+0x120],r15
   18378892c:	4c 8b a5 a8 01 00 00 	mov    r12,QWORD PTR [rbp+0x1a8]
   183788933:	4c 89 a5 28 01 00 00 	mov    QWORD PTR [rbp+0x128],r12
   18378893a:	4c 89 f9             	mov    rcx,r15
   18378893d:	b2 01                	mov    dl,0x1
   18378893f:	e8 bc 9e 2c fd       	call   0x180a52800
   183788944:	90                   	nop
   183788945:	0f 29 b5 90 00 00 00 	movaps XMMWORD PTR [rbp+0x90],xmm6
   18378894c:	0f 29 b5 80 00 00 00 	movaps XMMWORD PTR [rbp+0x80],xmm6
   183788953:	48 8d 9d 80 00 00 00 	lea    rbx,[rbp+0x80]
   18378895a:	48 89 d9             	mov    rcx,rbx
   18378895d:	4c 89 fa             	mov    rdx,r15
   183788960:	e8 fb b5 b4 fe       	call   0x1822d3f60
   183788965:	90                   	nop
   183788966:	4c 8b bd 90 00 00 00 	mov    r15,QWORD PTR [rbp+0x90]
   18378896d:	4d 85 ff             	test   r15,r15
   183788970:	74 30                	je     0x1837889a2
   183788972:	48 83 bd 98 00 00 00 	cmp    QWORD PTR [rbp+0x98],0x10
   183788979:	10 
   18378897a:	72 07                	jb     0x183788983
   18378897c:	48 8b 9d 80 00 00 00 	mov    rbx,QWORD PTR [rbp+0x80]
   183788983:	48 8b 85 98 01 00 00 	mov    rax,QWORD PTR [rbp+0x198]
   18378898a:	49 39 c7             	cmp    r15,rax
   18378898d:	76 74                	jbe    0x183788a03
   18378898f:	48 8d 8d 80 01 00 00 	lea    rcx,[rbp+0x180]
   183788996:	4c 89 fa             	mov    rdx,r15
   183788999:	49 89 d9             	mov    r9,rbx
   18378899c:	e8 af 57 8b fc       	call   0x18003e150
   1837889a1:	90                   	nop
   1837889a2:	48 8b 85 98 00 00 00 	mov    rax,QWORD PTR [rbp+0x98]
   1837889a9:	48 83 f8 10          	cmp    rax,0x10
   1837889ad:	0f 82 88 00 00 00    	jb     0x183788a3b
   1837889b3:	48 8b 8d 80 00 00 00 	mov    rcx,QWORD PTR [rbp+0x80]
   1837889ba:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1837889be:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1837889c5:	72 1f                	jb     0x1837889e6
   1837889c7:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1837889cb:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1837889cf:	4c 29 c1             	sub    rcx,r8
   1837889d2:	48 83 f9 20          	cmp    rcx,0x20
   1837889d6:	0f 83 86 0f 00 00    	jae    0x183789962
   1837889dc:	48 83 c0 28          	add    rax,0x28
   1837889e0:	48 89 c2             	mov    rdx,rax
   1837889e3:	4c 89 c1             	mov    rcx,r8
   1837889e6:	e8 f5 2e d2 03       	call   0x1874ab8e0
   1837889eb:	4d 85 e4             	test   r12,r12
   1837889ee:	75 50                	jne    0x183788a40
   1837889f0:	eb 77                	jmp    0x183788a69
   1837889f2:	31 c0                	xor    eax,eax
   1837889f4:	48 8b 0f             	mov    rcx,QWORD PTR [rdi]
   1837889f7:	48 89 0e             	mov    QWORD PTR [rsi],rcx
   1837889fa:	48 89 46 08          	mov    QWORD PTR [rsi+0x8],rax
   1837889fe:	e9 41 0f 00 00       	jmp    0x183789944
   183788a03:	48 83 f8 10          	cmp    rax,0x10
   183788a07:	72 07                	jb     0x183788a10
   183788a09:	4c 8b b5 80 01 00 00 	mov    r14,QWORD PTR [rbp+0x180]
   183788a10:	4c 89 bd 90 01 00 00 	mov    QWORD PTR [rbp+0x190],r15
   183788a17:	4c 89 f1             	mov    rcx,r14
   183788a1a:	48 89 da             	mov    rdx,rbx
   183788a1d:	4d 89 f8             	mov    r8,r15
   183788a20:	e8 2b b6 db 03       	call   0x187544050
   183788a25:	43 c6 04 3e 00       	mov    BYTE PTR [r14+r15*1],0x0
   183788a2a:	48 8b 85 98 00 00 00 	mov    rax,QWORD PTR [rbp+0x98]
   183788a31:	48 83 f8 10          	cmp    rax,0x10
   183788a35:	0f 83 78 ff ff ff    	jae    0x1837889b3
   183788a3b:	4d 85 e4             	test   r12,r12
   183788a3e:	74 29                	je     0x183788a69
   183788a40:	49 8d 44 24 08       	lea    rax,[r12+0x8]
   183788a45:	f0 ff 08             	lock dec DWORD PTR [rax]
   183788a48:	75 1f                	jne    0x183788a69
   183788a4a:	4c 89 e3             	mov    rbx,r12
   183788a4d:	48 83 c3 0c          	add    rbx,0xc
   183788a51:	49 8b 04 24          	mov    rax,QWORD PTR [r12]
   183788a55:	4c 89 e1             	mov    rcx,r12
   183788a58:	ff 10                	call   QWORD PTR [rax]
   183788a5a:	f0 ff 0b             	lock dec DWORD PTR [rbx]
   183788a5d:	75 0a                	jne    0x183788a69
   183788a5f:	49 8b 04 24          	mov    rax,QWORD PTR [r12]
   183788a63:	4c 89 e1             	mov    rcx,r12
   183788a66:	ff 50 08             	call   QWORD PTR [rax+0x8]
   183788a69:	48 8b 5d c8          	mov    rbx,QWORD PTR [rbp-0x38]
   183788a6d:	48 85 db             	test   rbx,rbx
   183788a70:	0f 85 e8 0b 00 00    	jne    0x18378965e
   183788a76:	e9 00 0c 00 00       	jmp    0x18378967b
   183788a7b:	31 c9                	xor    ecx,ecx
   183788a7d:	48 89 45 70          	mov    QWORD PTR [rbp+0x70],rax
   183788a81:	48 89 4d 78          	mov    QWORD PTR [rbp+0x78],rcx
   183788a85:	0f 57 c0             	xorps  xmm0,xmm0
   183788a88:	0f 29 85 70 01 00 00 	movaps XMMWORD PTR [rbp+0x170],xmm0
   183788a8f:	48 8b 88 60 07 00 00 	mov    rcx,QWORD PTR [rax+0x760]
   183788a96:	48 85 c9             	test   rcx,rcx
   183788a99:	74 0d                	je     0x183788aa8
   183788a9b:	f0 ff 41 08          	lock inc DWORD PTR [rcx+0x8]
   183788a9f:	4c 8b b8 60 07 00 00 	mov    r15,QWORD PTR [rax+0x760]
   183788aa6:	eb 03                	jmp    0x183788aab
   183788aa8:	45 31 ff             	xor    r15d,r15d
   183788aab:	4c 8b b0 58 07 00 00 	mov    r14,QWORD PTR [rax+0x758]
   183788ab2:	4c 89 b5 70 01 00 00 	mov    QWORD PTR [rbp+0x170],r14
   183788ab9:	4c 89 bd 78 01 00 00 	mov    QWORD PTR [rbp+0x178],r15
   183788ac0:	4d 85 f6             	test   r14,r14
   183788ac3:	74 7a                	je     0x183788b3f
   183788ac5:	0f 29 85 80 00 00 00 	movaps XMMWORD PTR [rbp+0x80],xmm0
   183788acc:	48 c7 85 90 00 00 00 	mov    QWORD PTR [rbp+0x90],0x0
   183788ad3:	00 00 00 00 
   183788ad7:	48 c7 85 98 00 00 00 	mov    QWORD PTR [rbp+0x98],0xf
   183788ade:	0f 00 00 00 
   183788ae2:	4c 89 f1             	mov    rcx,r14
   183788ae5:	e8 56 8a 6f fe       	call   0x181e81540
   183788aea:	90                   	nop
   183788aeb:	ff c8                	dec    eax
   183788aed:	83 f8 04             	cmp    eax,0x4
   183788af0:	0f 87 65 03 00 00    	ja     0x183788e5b
   183788af6:	48 8d 0d 7b 55 d5 05 	lea    rcx,[rip+0x5d5557b]        # 0x1894de078
   183788afd:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
   183788b01:	48 01 c8             	add    rax,rcx
   183788b04:	ff e0                	jmp    rax
   183788b06:	e8 35 7b 93 fc       	call   0x1800c0640
   183788b0b:	90                   	nop
   183788b0c:	49 89 c7             	mov    r15,rax
   183788b0f:	48 89 c1             	mov    rcx,rax
   183788b12:	e8 89 ba d9 03       	call   0x1875245a0
   183788b17:	48 8b 8d 98 00 00 00 	mov    rcx,QWORD PTR [rbp+0x98]
   183788b1e:	48 39 c8             	cmp    rax,rcx
   183788b21:	0f 86 d4 00 00 00    	jbe    0x183788bfb
   183788b27:	48 8d 8d 80 00 00 00 	lea    rcx,[rbp+0x80]
   183788b2e:	48 89 c2             	mov    rdx,rax
   183788b31:	4d 89 f9             	mov    r9,r15
   183788b34:	e8 17 56 8b fc       	call   0x18003e150
   183788b39:	90                   	nop
   183788b3a:	e9 1c 03 00 00       	jmp    0x183788e5b
   183788b3f:	48 8d 8d b0 01 00 00 	lea    rcx,[rbp+0x1b0]
   183788b46:	48 89 da             	mov    rdx,rbx
   183788b49:	e8 02 14 00 00       	call   0x183789f50
   183788b4e:	90                   	nop
   183788b4f:	e9 7c 0a 00 00       	jmp    0x1837895d0
   183788b54:	e8 47 69 93 fc       	call   0x1800bf4a0
   183788b59:	90                   	nop
   183788b5a:	49 89 c7             	mov    r15,rax
   183788b5d:	48 89 c1             	mov    rcx,rax
   183788b60:	e8 3b ba d9 03       	call   0x1875245a0
   183788b65:	48 8b 8d 98 00 00 00 	mov    rcx,QWORD PTR [rbp+0x98]
   183788b6c:	48 39 c8             	cmp    rax,rcx
   183788b6f:	0f 86 86 00 00 00    	jbe    0x183788bfb
   183788b75:	48 8d 8d 80 00 00 00 	lea    rcx,[rbp+0x80]
   183788b7c:	48 89 c2             	mov    rdx,rax
   183788b7f:	4d 89 f9             	mov    r9,r15
   183788b82:	e8 c9 55 8b fc       	call   0x18003e150
   183788b87:	90                   	nop
   183788b88:	e9 ce 02 00 00       	jmp    0x183788e5b
   183788b8d:	e8 ae 68 93 fc       	call   0x1800bf440
   183788b92:	90                   	nop
   183788b93:	49 89 c6             	mov    r14,rax
   183788b96:	48 89 c1             	mov    rcx,rax
   183788b99:	e8 02 ba d9 03       	call   0x1875245a0
   183788b9e:	48 8b 8d 98 00 00 00 	mov    rcx,QWORD PTR [rbp+0x98]
   183788ba5:	48 39 c8             	cmp    rax,rcx
   183788ba8:	0f 86 85 00 00 00    	jbe    0x183788c33
   183788bae:	48 8d 8d 80 00 00 00 	lea    rcx,[rbp+0x80]
   183788bb5:	48 89 c2             	mov    rdx,rax
   183788bb8:	4d 89 f1             	mov    r9,r14
   183788bbb:	e8 90 55 8b fc       	call   0x18003e150
   183788bc0:	90                   	nop
   183788bc1:	e9 a0 00 00 00       	jmp    0x183788c66
   183788bc6:	e8 15 68 93 fc       	call   0x1800bf3e0
   183788bcb:	90                   	nop
   183788bcc:	49 89 c7             	mov    r15,rax
   183788bcf:	48 89 c1             	mov    rcx,rax
   183788bd2:	e8 c9 b9 d9 03       	call   0x1875245a0
   183788bd7:	48 8b 8d 98 00 00 00 	mov    rcx,QWORD PTR [rbp+0x98]
   183788bde:	48 39 c8             	cmp    rax,rcx
   183788be1:	76 18                	jbe    0x183788bfb
   183788be3:	48 8d 8d 80 00 00 00 	lea    rcx,[rbp+0x80]
   183788bea:	48 89 c2             	mov    rdx,rax
   183788bed:	4d 89 f9             	mov    r9,r15
   183788bf0:	e8 5b 55 8b fc       	call   0x18003e150
   183788bf5:	90                   	nop
   183788bf6:	e9 60 02 00 00       	jmp    0x183788e5b
   183788bfb:	48 83 f9 10          	cmp    rcx,0x10
   183788bff:	72 09                	jb     0x183788c0a
   183788c01:	4c 8b a5 80 00 00 00 	mov    r12,QWORD PTR [rbp+0x80]
   183788c08:	eb 07                	jmp    0x183788c11
   183788c0a:	4c 8d a5 80 00 00 00 	lea    r12,[rbp+0x80]
   183788c11:	48 89 85 90 00 00 00 	mov    QWORD PTR [rbp+0x90],rax
   183788c18:	4c 89 e1             	mov    rcx,r12
   183788c1b:	4c 89 fa             	mov    rdx,r15
   183788c1e:	49 89 c0             	mov    r8,rax
   183788c21:	49 89 c7             	mov    r15,rax
   183788c24:	e8 27 b4 db 03       	call   0x187544050
   183788c29:	43 c6 04 3c 00       	mov    BYTE PTR [r12+r15*1],0x0
   183788c2e:	e9 28 02 00 00       	jmp    0x183788e5b
   183788c33:	48 83 f9 10          	cmp    rcx,0x10
   183788c37:	72 09                	jb     0x183788c42
   183788c39:	4c 8b bd 80 00 00 00 	mov    r15,QWORD PTR [rbp+0x80]
   183788c40:	eb 07                	jmp    0x183788c49
   183788c42:	4c 8d bd 80 00 00 00 	lea    r15,[rbp+0x80]
   183788c49:	48 89 85 90 00 00 00 	mov    QWORD PTR [rbp+0x90],rax
   183788c50:	4c 89 f9             	mov    rcx,r15
   183788c53:	4c 89 f2             	mov    rdx,r14
   183788c56:	49 89 c0             	mov    r8,rax
   183788c59:	49 89 c6             	mov    r14,rax
   183788c5c:	e8 ef b3 db 03       	call   0x187544050
   183788c61:	43 c6 04 37 00       	mov    BYTE PTR [r15+r14*1],0x0
   183788c66:	0f 29 b5 20 01 00 00 	movaps XMMWORD PTR [rbp+0x120],xmm6
   183788c6d:	e8 9e d0 8b fc       	call   0x180045d10
   183788c72:	90                   	nop
   183788c73:	4c 8b 00             	mov    r8,QWORD PTR [rax]
   183788c76:	48 8d 55 60          	lea    rdx,[rbp+0x60]
   183788c7a:	48 89 c1             	mov    rcx,rax
   183788c7d:	41 ff 50 60          	call   QWORD PTR [r8+0x60]
   183788c81:	90                   	nop
   183788c82:	48 8b 4d 60          	mov    rcx,QWORD PTR [rbp+0x60]
   183788c86:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   183788c89:	48 8d 55 50          	lea    rdx,[rbp+0x50]
   183788c8d:	ff 50 38             	call   QWORD PTR [rax+0x38]
   183788c90:	90                   	nop
   183788c91:	48 8b 4d 50          	mov    rcx,QWORD PTR [rbp+0x50]
   183788c95:	48 8d 05 9c 7b 67 05 	lea    rax,[rip+0x5677b9c]        # 0x188e00838
   183788c9c:	48 89 45 48          	mov    QWORD PTR [rbp+0x48],rax
   183788ca0:	0f 29 75 c0          	movaps XMMWORD PTR [rbp-0x40],xmm6
   183788ca4:	48 8d 55 c0          	lea    rdx,[rbp-0x40]
   183788ca8:	4c 8d 45 48          	lea    r8,[rbp+0x48]
   183788cac:	e8 bf 8f c2 fc       	call   0x1803b1c70
   183788cb1:	90                   	nop
   183788cb2:	48 8b 45 c0          	mov    rax,QWORD PTR [rbp-0x40]
   183788cb6:	48 8b 4d c8          	mov    rcx,QWORD PTR [rbp-0x38]
   183788cba:	48 85 c9             	test   rcx,rcx
   183788cbd:	74 3c                	je     0x183788cfb
   183788cbf:	f0 ff 41 08          	lock inc DWORD PTR [rcx+0x8]
   183788cc3:	4c 8b 75 c8          	mov    r14,QWORD PTR [rbp-0x38]
   183788cc7:	48 89 85 d0 01 00 00 	mov    QWORD PTR [rbp+0x1d0],rax
   183788cce:	4c 89 b5 d8 01 00 00 	mov    QWORD PTR [rbp+0x1d8],r14
   183788cd5:	4d 85 f6             	test   r14,r14
   183788cd8:	74 33                	je     0x183788d0d
   183788cda:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   183788cdf:	75 2c                	jne    0x183788d0d
   183788ce1:	49 8b 06             	mov    rax,QWORD PTR [r14]
   183788ce4:	4c 89 f1             	mov    rcx,r14
   183788ce7:	ff 10                	call   QWORD PTR [rax]
   183788ce9:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   183788cee:	75 1d                	jne    0x183788d0d
   183788cf0:	49 8b 06             	mov    rax,QWORD PTR [r14]
   183788cf3:	4c 89 f1             	mov    rcx,r14
   183788cf6:	ff 50 08             	call   QWORD PTR [rax+0x8]
   183788cf9:	eb 12                	jmp    0x183788d0d
   183788cfb:	48 89 85 d0 01 00 00 	mov    QWORD PTR [rbp+0x1d0],rax
   183788d02:	48 c7 85 d8 01 00 00 	mov    QWORD PTR [rbp+0x1d8],0x0
   183788d09:	00 00 00 00 
   183788d0d:	4c 8b b5 d0 01 00 00 	mov    r14,QWORD PTR [rbp+0x1d0]
   183788d14:	48 8b 8d 70 01 00 00 	mov    rcx,QWORD PTR [rbp+0x170]
   183788d1b:	e8 40 74 5b fd       	call   0x180d40160
   183788d20:	90                   	nop
   183788d21:	48 8d 95 20 01 00 00 	lea    rdx,[rbp+0x120]
   183788d28:	4c 89 f1             	mov    rcx,r14
   183788d2b:	49 89 c0             	mov    r8,rax
   183788d2e:	e8 7d cf 79 fd       	call   0x180f25cb0
   183788d33:	90                   	nop
   183788d34:	4c 8b b5 d8 01 00 00 	mov    r14,QWORD PTR [rbp+0x1d8]
   183788d3b:	4d 85 f6             	test   r14,r14
   183788d3e:	74 1f                	je     0x183788d5f
   183788d40:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   183788d45:	75 18                	jne    0x183788d5f
   183788d47:	49 8b 06             	mov    rax,QWORD PTR [r14]
   183788d4a:	4c 89 f1             	mov    rcx,r14
   183788d4d:	ff 10                	call   QWORD PTR [rax]
   183788d4f:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   183788d54:	75 09                	jne    0x183788d5f
   183788d56:	49 8b 06             	mov    rax,QWORD PTR [r14]
   183788d59:	4c 89 f1             	mov    rcx,r14
   183788d5c:	ff 50 08             	call   QWORD PTR [rax+0x8]
   183788d5f:	4c 8b 75 58          	mov    r14,QWORD PTR [rbp+0x58]
   183788d63:	4d 85 f6             	test   r14,r14
   183788d66:	74 1f                	je     0x183788d87
   183788d68:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   183788d6d:	75 18                	jne    0x183788d87
   183788d6f:	49 8b 06             	mov    rax,QWORD PTR [r14]
   183788d72:	4c 89 f1             	mov    rcx,r14
   183788d75:	ff 10                	call   QWORD PTR [rax]
   183788d77:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   183788d7c:	75 09                	jne    0x183788d87
   183788d7e:	49 8b 06             	mov    rax,QWORD PTR [r14]
   183788d81:	4c 89 f1             	mov    rcx,r14
   183788d84:	ff 50 08             	call   QWORD PTR [rax+0x8]
   183788d87:	4c 8b 75 68          	mov    r14,QWORD PTR [rbp+0x68]
   183788d8b:	4d 85 f6             	test   r14,r14
   183788d8e:	74 1f                	je     0x183788daf
   183788d90:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   183788d95:	75 18                	jne    0x183788daf
   183788d97:	49 8b 06             	mov    rax,QWORD PTR [r14]
   183788d9a:	4c 89 f1             	mov    rcx,r14
   183788d9d:	ff 10                	call   QWORD PTR [rax]
   183788d9f:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   183788da4:	75 09                	jne    0x183788daf
   183788da6:	49 8b 06             	mov    rax,QWORD PTR [r14]
   183788da9:	4c 89 f1             	mov    rcx,r14
   183788dac:	ff 50 08             	call   QWORD PTR [rax+0x8]
   183788daf:	48 8b 85 20 01 00 00 	mov    rax,QWORD PTR [rbp+0x120]
   183788db6:	48 85 c0             	test   rax,rax
   183788db9:	74 6e                	je     0x183788e29
   183788dbb:	83 b8 40 02 00 00 01 	cmp    DWORD PTR [rax+0x240],0x1
   183788dc2:	75 65                	jne    0x183788e29
   183788dc4:	e8 d7 66 93 fc       	call   0x1800bf4a0
   183788dc9:	90                   	nop
   183788dca:	49 89 c6             	mov    r14,rax
   183788dcd:	48 89 c1             	mov    rcx,rax
   183788dd0:	e8 cb b7 d9 03       	call   0x1875245a0
   183788dd5:	48 8b 8d 98 00 00 00 	mov    rcx,QWORD PTR [rbp+0x98]
   183788ddc:	48 39 c8             	cmp    rax,rcx
   183788ddf:	76 15                	jbe    0x183788df6
   183788de1:	48 8d 8d 80 00 00 00 	lea    rcx,[rbp+0x80]
   183788de8:	48 89 c2             	mov    rdx,rax
   183788deb:	4d 89 f1             	mov    r9,r14
   183788dee:	e8 5d 53 8b fc       	call   0x18003e150
   183788df3:	90                   	nop
   183788df4:	eb 33                	jmp    0x183788e29
   183788df6:	48 83 f9 10          	cmp    rcx,0x10
   183788dfa:	72 09                	jb     0x183788e05
   183788dfc:	4c 8b bd 80 00 00 00 	mov    r15,QWORD PTR [rbp+0x80]
   183788e03:	eb 07                	jmp    0x183788e0c
   183788e05:	4c 8d bd 80 00 00 00 	lea    r15,[rbp+0x80]
   183788e0c:	48 89 85 90 00 00 00 	mov    QWORD PTR [rbp+0x90],rax
   183788e13:	4c 89 f9             	mov    rcx,r15
   183788e16:	4c 89 f2             	mov    rdx,r14
   183788e19:	49 89 c0             	mov    r8,rax
   183788e1c:	49 89 c6             	mov    r14,rax
   183788e1f:	e8 2c b2 db 03       	call   0x187544050
   183788e24:	43 c6 04 37 00       	mov    BYTE PTR [r15+r14*1],0x0
   183788e29:	4c 8b b5 28 01 00 00 	mov    r14,QWORD PTR [rbp+0x128]
   183788e30:	4d 85 f6             	test   r14,r14
   183788e33:	74 1f                	je     0x183788e54
   183788e35:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   183788e3a:	75 18                	jne    0x183788e54
   183788e3c:	49 8b 06             	mov    rax,QWORD PTR [r14]
   183788e3f:	4c 89 f1             	mov    rcx,r14
   183788e42:	ff 10                	call   QWORD PTR [rax]
   183788e44:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   183788e49:	75 09                	jne    0x183788e54
   183788e4b:	49 8b 06             	mov    rax,QWORD PTR [r14]
   183788e4e:	4c 89 f1             	mov    rcx,r14
   183788e51:	ff 50 08             	call   QWORD PTR [rax+0x8]
   183788e54:	4c 8b b5 70 01 00 00 	mov    r14,QWORD PTR [rbp+0x170]
   183788e5b:	4c 89 f1             	mov    rcx,r14
   183788e5e:	e8 6d af be fc       	call   0x180373dd0
   183788e63:	90                   	nop
   183788e64:	49 89 c7             	mov    r15,rax
   183788e67:	48 83 78 10 00       	cmp    QWORD PTR [rax+0x10],0x0
   183788e6c:	0f 84 c4 00 00 00    	je     0x183788f36
   183788e72:	0f 29 75 d0          	movaps XMMWORD PTR [rbp-0x30],xmm6
   183788e76:	0f 29 75 c0          	movaps XMMWORD PTR [rbp-0x40],xmm6
   183788e7a:	48 8d 4d c0          	lea    rcx,[rbp-0x40]
   183788e7e:	48 89 da             	mov    rdx,rbx
   183788e81:	45 31 c0             	xor    r8d,r8d
   183788e84:	e8 07 22 b4 fe       	call   0x1822cb090
   183788e89:	90                   	nop
   183788e8a:	0f 29 b5 30 01 00 00 	movaps XMMWORD PTR [rbp+0x130],xmm6
   183788e91:	0f 29 b5 20 01 00 00 	movaps XMMWORD PTR [rbp+0x120],xmm6
   183788e98:	48 8b 9d 90 00 00 00 	mov    rbx,QWORD PTR [rbp+0x90]
   183788e9f:	48 85 db             	test   rbx,rbx
   183788ea2:	0f 84 c9 00 00 00    	je     0x183788f71
   183788ea8:	49 bd ff ff ff ff ff 	movabs r13,0x7fffffffffffffff
   183788eaf:	ff ff 7f 
   183788eb2:	4c 39 eb             	cmp    rbx,r13
   183788eb5:	0f 84 ad 0a 00 00    	je     0x183789968
   183788ebb:	48 8b 8d 80 00 00 00 	mov    rcx,QWORD PTR [rbp+0x80]
   183788ec2:	4c 8b b5 98 00 00 00 	mov    r14,QWORD PTR [rbp+0x98]
   183788ec9:	0f 57 c0             	xorps  xmm0,xmm0
   183788ecc:	0f 29 85 d0 01 00 00 	movaps XMMWORD PTR [rbp+0x1d0],xmm0
   183788ed3:	48 8d 43 01          	lea    rax,[rbx+0x1]
   183788ed7:	48 83 f8 10          	cmp    rax,0x10
   183788edb:	0f 82 e4 00 00 00    	jb     0x183788fc5
   183788ee1:	48 85 c0             	test   rax,rax
   183788ee4:	48 89 8d a8 01 00 00 	mov    QWORD PTR [rbp+0x1a8],rcx
   183788eeb:	78 1e                	js     0x183788f0b
   183788eed:	48 83 c8 0f          	or     rax,0xf
   183788ef1:	48 83 f8 17          	cmp    rax,0x17
   183788ef5:	41 bd 16 00 00 00    	mov    r13d,0x16
   183788efb:	4c 0f 43 e8          	cmovae r13,rax
   183788eff:	48 3d ff 0f 00 00    	cmp    rax,0xfff
   183788f05:	0f 82 a8 01 00 00    	jb     0x1837890b3
   183788f0b:	49 8d 4d 28          	lea    rcx,[r13+0x28]
   183788f0f:	e8 88 29 d2 03       	call   0x1874ab89c
   183788f14:	90                   	nop
   183788f15:	49 89 c4             	mov    r12,rax
   183788f18:	48 85 c0             	test   rax,rax
   183788f1b:	0f 84 41 0a 00 00    	je     0x183789962
   183788f21:	4c 89 e0             	mov    rax,r12
   183788f24:	49 83 c4 27          	add    r12,0x27
   183788f28:	49 83 e4 e0          	and    r12,0xffffffffffffffe0
   183788f2c:	49 89 44 24 f8       	mov    QWORD PTR [r12-0x8],rax
   183788f31:	e9 8a 01 00 00       	jmp    0x1837890c0
   183788f36:	4c 8b b5 90 00 00 00 	mov    r14,QWORD PTR [rbp+0x90]
   183788f3d:	4d 85 f6             	test   r14,r14
   183788f40:	0f 84 91 00 00 00    	je     0x183788fd7
   183788f46:	0f 57 c0             	xorps  xmm0,xmm0
   183788f49:	0f 29 85 c0 01 00 00 	movaps XMMWORD PTR [rbp+0x1c0],xmm0
   183788f50:	0f 29 85 b0 01 00 00 	movaps XMMWORD PTR [rbp+0x1b0],xmm0
   183788f57:	48 83 bd 98 00 00 00 	cmp    QWORD PTR [rbp+0x98],0x10
   183788f5e:	10 
   183788f5f:	0f 82 87 00 00 00    	jb     0x183788fec
   183788f65:	48 8b 9d 80 00 00 00 	mov    rbx,QWORD PTR [rbp+0x80]
   183788f6c:	e9 82 00 00 00       	jmp    0x183788ff3
   183788f71:	0f 57 c0             	xorps  xmm0,xmm0
   183788f74:	0f 29 85 30 01 00 00 	movaps XMMWORD PTR [rbp+0x130],xmm0
   183788f7b:	0f 29 85 20 01 00 00 	movaps XMMWORD PTR [rbp+0x120],xmm0
   183788f82:	49 8b 5f 10          	mov    rbx,QWORD PTR [r15+0x10]
   183788f86:	49 83 7f 18 10       	cmp    QWORD PTR [r15+0x18],0x10
   183788f8b:	72 03                	jb     0x183788f90
   183788f8d:	4d 8b 3f             	mov    r15,QWORD PTR [r15]
   183788f90:	48 85 db             	test   rbx,rbx
   183788f93:	0f 88 e1 09 00 00    	js     0x18378997a
   183788f99:	48 83 fb 0f          	cmp    rbx,0xf
   183788f9d:	0f 87 c8 00 00 00    	ja     0x18378906b
   183788fa3:	48 89 9d 30 01 00 00 	mov    QWORD PTR [rbp+0x130],rbx
   183788faa:	48 c7 85 38 01 00 00 	mov    QWORD PTR [rbp+0x138],0xf
   183788fb1:	0f 00 00 00 
   183788fb5:	41 0f 10 07          	movups xmm0,XMMWORD PTR [r15]
   183788fb9:	0f 29 85 20 01 00 00 	movaps XMMWORD PTR [rbp+0x120],xmm0
   183788fc0:	e9 8d 02 00 00       	jmp    0x183789252
   183788fc5:	4c 8d a5 d0 01 00 00 	lea    r12,[rbp+0x1d0]
   183788fcc:	41 bd 0f 00 00 00    	mov    r13d,0xf
   183788fd2:	e9 fb 00 00 00       	jmp    0x1837890d2
   183788fd7:	48 8d 8d b0 01 00 00 	lea    rcx,[rbp+0x1b0]
   183788fde:	48 89 da             	mov    rdx,rbx
   183788fe1:	e8 6a 0f 00 00       	call   0x183789f50
   183788fe6:	90                   	nop
   183788fe7:	e9 98 05 00 00       	jmp    0x183789584
   183788fec:	48 8d 9d 80 00 00 00 	lea    rbx,[rbp+0x80]
   183788ff3:	4d 85 f6             	test   r14,r14
   183788ff6:	0f 88 78 09 00 00    	js     0x183789974
   183788ffc:	49 83 fe 0f          	cmp    r14,0xf
   183789000:	77 21                	ja     0x183789023
   183789002:	4c 89 b5 c0 01 00 00 	mov    QWORD PTR [rbp+0x1c0],r14
   183789009:	48 c7 85 c8 01 00 00 	mov    QWORD PTR [rbp+0x1c8],0xf
   183789010:	0f 00 00 00 
   183789014:	0f 10 03             	movups xmm0,XMMWORD PTR [rbx]
   183789017:	0f 29 85 b0 01 00 00 	movaps XMMWORD PTR [rbp+0x1b0],xmm0
   18378901e:	e9 61 05 00 00       	jmp    0x183789584
   183789023:	4c 89 f0             	mov    rax,r14
   183789026:	48 83 c8 0f          	or     rax,0xf
   18378902a:	48 83 f8 17          	cmp    rax,0x17
   18378902e:	41 bf 16 00 00 00    	mov    r15d,0x16
   183789034:	4c 0f 43 f8          	cmovae r15,rax
   183789038:	48 3d ff 0f 00 00    	cmp    rax,0xfff
   18378903e:	0f 82 a9 01 00 00    	jb     0x1837891ed
   183789044:	49 8d 4f 28          	lea    rcx,[r15+0x28]
   183789048:	e8 4f 28 d2 03       	call   0x1874ab89c
   18378904d:	90                   	nop
   18378904e:	48 85 c0             	test   rax,rax
   183789051:	0f 84 0b 09 00 00    	je     0x183789962
   183789057:	48 89 c1             	mov    rcx,rax
   18378905a:	48 83 c0 27          	add    rax,0x27
   18378905e:	48 83 e0 e0          	and    rax,0xffffffffffffffe0
   183789062:	48 89 48 f8          	mov    QWORD PTR [rax-0x8],rcx
   183789066:	e9 8c 01 00 00       	jmp    0x1837891f7
   18378906b:	48 89 d8             	mov    rax,rbx
   18378906e:	48 83 c8 0f          	or     rax,0xf
   183789072:	48 83 f8 17          	cmp    rax,0x17
   183789076:	41 be 16 00 00 00    	mov    r14d,0x16
   18378907c:	4c 0f 43 f0          	cmovae r14,rax
   183789080:	48 3d ff 0f 00 00    	cmp    rax,0xfff
   183789086:	0f 82 96 01 00 00    	jb     0x183789222
   18378908c:	49 8d 4e 28          	lea    rcx,[r14+0x28]
   183789090:	e8 07 28 d2 03       	call   0x1874ab89c
   183789095:	90                   	nop
   183789096:	48 85 c0             	test   rax,rax
   183789099:	0f 84 c3 08 00 00    	je     0x183789962
   18378909f:	48 89 c1             	mov    rcx,rax
   1837890a2:	48 83 c0 27          	add    rax,0x27
   1837890a6:	48 83 e0 e0          	and    rax,0xffffffffffffffe0
   1837890aa:	48 89 48 f8          	mov    QWORD PTR [rax-0x8],rcx
   1837890ae:	e9 79 01 00 00       	jmp    0x18378922c
   1837890b3:	49 8d 4d 01          	lea    rcx,[r13+0x1]
   1837890b7:	e8 e0 27 d2 03       	call   0x1874ab89c
   1837890bc:	90                   	nop
   1837890bd:	49 89 c4             	mov    r12,rax
   1837890c0:	48 8b 8d a8 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1a8]
   1837890c7:	48 8d 43 01          	lea    rax,[rbx+0x1]
   1837890cb:	4c 89 a5 d0 01 00 00 	mov    QWORD PTR [rbp+0x1d0],r12
   1837890d2:	49 83 fe 10          	cmp    r14,0x10
   1837890d6:	48 8d 95 80 00 00 00 	lea    rdx,[rbp+0x80]
   1837890dd:	48 0f 43 d1          	cmovae rdx,rcx
   1837890e1:	48 89 85 e0 01 00 00 	mov    QWORD PTR [rbp+0x1e0],rax
   1837890e8:	4c 89 ad e8 01 00 00 	mov    QWORD PTR [rbp+0x1e8],r13
   1837890ef:	4c 89 e1             	mov    rcx,r12
   1837890f2:	49 89 d8             	mov    r8,rbx
   1837890f5:	e8 56 af db 03       	call   0x187544050
   1837890fa:	66 41 c7 04 1c 20 00 	mov    WORD PTR [r12+rbx*1],0x20
   183789101:	49 8b 47 10          	mov    rax,QWORD PTR [r15+0x10]
   183789105:	49 83 7f 18 10       	cmp    QWORD PTR [r15+0x18],0x10
   18378910a:	72 03                	jb     0x18378910f
   18378910c:	4d 8b 3f             	mov    r15,QWORD PTR [r15]
   18378910f:	48 8b 8d e0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1e0]
   183789116:	48 8b 95 e8 01 00 00 	mov    rdx,QWORD PTR [rbp+0x1e8]
   18378911d:	49 89 d0             	mov    r8,rdx
   183789120:	49 29 c8             	sub    r8,rcx
   183789123:	4c 39 c0             	cmp    rax,r8
   183789126:	76 1d                	jbe    0x183789145
   183789128:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   18378912d:	48 8d 8d d0 01 00 00 	lea    rcx,[rbp+0x1d0]
   183789134:	48 89 c2             	mov    rdx,rax
   183789137:	4d 89 f9             	mov    r9,r15
   18378913a:	e8 81 02 88 fc       	call   0x1800093c0
   18378913f:	90                   	nop
   183789140:	48 89 c3             	mov    rbx,rax
   183789143:	eb 35                	jmp    0x18378917a
   183789145:	4c 8d 34 01          	lea    r14,[rcx+rax*1]
   183789149:	4c 89 b5 e0 01 00 00 	mov    QWORD PTR [rbp+0x1e0],r14
   183789150:	48 8d 9d d0 01 00 00 	lea    rbx,[rbp+0x1d0]
   183789157:	49 89 dc             	mov    r12,rbx
   18378915a:	48 83 fa 10          	cmp    rdx,0x10
   18378915e:	72 07                	jb     0x183789167
   183789160:	4c 8b a5 d0 01 00 00 	mov    r12,QWORD PTR [rbp+0x1d0]
   183789167:	4c 01 e1             	add    rcx,r12
   18378916a:	4c 89 fa             	mov    rdx,r15
   18378916d:	49 89 c0             	mov    r8,rax
   183789170:	e8 db ae db 03       	call   0x187544050
   183789175:	43 c6 04 34 00       	mov    BYTE PTR [r12+r14*1],0x0
   18378917a:	0f 10 03             	movups xmm0,XMMWORD PTR [rbx]
   18378917d:	0f 10 4b 10          	movups xmm1,XMMWORD PTR [rbx+0x10]
   183789181:	0f 29 8d 30 01 00 00 	movaps XMMWORD PTR [rbp+0x130],xmm1
   183789188:	0f 29 85 20 01 00 00 	movaps XMMWORD PTR [rbp+0x120],xmm0
   18378918f:	48 c7 43 10 00 00 00 	mov    QWORD PTR [rbx+0x10],0x0
   183789196:	00 
   183789197:	48 c7 43 18 0f 00 00 	mov    QWORD PTR [rbx+0x18],0xf
   18378919e:	00 
   18378919f:	c6 03 00             	mov    BYTE PTR [rbx],0x0
   1837891a2:	48 8b 85 e8 01 00 00 	mov    rax,QWORD PTR [rbp+0x1e8]
   1837891a9:	48 83 f8 10          	cmp    rax,0x10
   1837891ad:	0f 82 9f 00 00 00    	jb     0x183789252
   1837891b3:	48 8b 8d d0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1d0]
   1837891ba:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1837891be:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1837891c5:	72 1f                	jb     0x1837891e6
   1837891c7:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1837891cb:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1837891cf:	4c 29 c1             	sub    rcx,r8
   1837891d2:	48 83 f9 20          	cmp    rcx,0x20
   1837891d6:	0f 83 86 07 00 00    	jae    0x183789962
   1837891dc:	48 83 c0 28          	add    rax,0x28
   1837891e0:	48 89 c2             	mov    rdx,rax
   1837891e3:	4c 89 c1             	mov    rcx,r8
   1837891e6:	e8 f5 26 d2 03       	call   0x1874ab8e0
   1837891eb:	eb 65                	jmp    0x183789252
   1837891ed:	49 8d 4f 01          	lea    rcx,[r15+0x1]
   1837891f1:	e8 a6 26 d2 03       	call   0x1874ab89c
   1837891f6:	90                   	nop
   1837891f7:	48 89 85 b0 01 00 00 	mov    QWORD PTR [rbp+0x1b0],rax
   1837891fe:	4c 89 b5 c0 01 00 00 	mov    QWORD PTR [rbp+0x1c0],r14
   183789205:	4c 89 bd c8 01 00 00 	mov    QWORD PTR [rbp+0x1c8],r15
   18378920c:	49 ff c6             	inc    r14
   18378920f:	48 89 c1             	mov    rcx,rax
   183789212:	48 89 da             	mov    rdx,rbx
   183789215:	4d 89 f0             	mov    r8,r14
   183789218:	e8 33 ae db 03       	call   0x187544050
   18378921d:	e9 62 03 00 00       	jmp    0x183789584
   183789222:	49 8d 4e 01          	lea    rcx,[r14+0x1]
   183789226:	e8 71 26 d2 03       	call   0x1874ab89c
   18378922b:	90                   	nop
   18378922c:	48 89 85 20 01 00 00 	mov    QWORD PTR [rbp+0x120],rax
   183789233:	48 89 9d 30 01 00 00 	mov    QWORD PTR [rbp+0x130],rbx
   18378923a:	4c 89 b5 38 01 00 00 	mov    QWORD PTR [rbp+0x138],r14
   183789241:	48 ff c3             	inc    rbx
   183789244:	48 89 c1             	mov    rcx,rax
   183789247:	4c 89 fa             	mov    rdx,r15
   18378924a:	49 89 d8             	mov    r8,rbx
   18378924d:	e8 fe ad db 03       	call   0x187544050
   183789252:	48 8b 5d d0          	mov    rbx,QWORD PTR [rbp-0x30]
   183789256:	48 85 db             	test   rbx,rbx
   183789259:	74 7c                	je     0x1837892d7
   18378925b:	49 be ff ff ff ff ff 	movabs r14,0x7fffffffffffffff
   183789262:	ff ff 7f 
   183789265:	4c 39 f3             	cmp    rbx,r14
   183789268:	0f 84 00 07 00 00    	je     0x18378996e
   18378926e:	4c 8b 65 c0          	mov    r12,QWORD PTR [rbp-0x40]
   183789272:	4c 8b 6d d8          	mov    r13,QWORD PTR [rbp-0x28]
   183789276:	0f 57 c0             	xorps  xmm0,xmm0
   183789279:	0f 29 85 d0 01 00 00 	movaps XMMWORD PTR [rbp+0x1d0],xmm0
   183789280:	48 8d 43 01          	lea    rax,[rbx+0x1]
   183789284:	48 83 f8 10          	cmp    rax,0x10
   183789288:	72 78                	jb     0x183789302
   18378928a:	48 85 c0             	test   rax,rax
   18378928d:	78 1e                	js     0x1837892ad
   18378928f:	48 83 c8 0f          	or     rax,0xf
   183789293:	48 83 f8 17          	cmp    rax,0x17
   183789297:	41 be 16 00 00 00    	mov    r14d,0x16
   18378929d:	4c 0f 43 f0          	cmovae r14,rax
   1837892a1:	48 3d ff 0f 00 00    	cmp    rax,0xfff
   1837892a7:	0f 82 e7 00 00 00    	jb     0x183789394
   1837892ad:	49 8d 4e 28          	lea    rcx,[r14+0x28]
   1837892b1:	e8 e6 25 d2 03       	call   0x1874ab89c
   1837892b6:	90                   	nop
   1837892b7:	49 89 c7             	mov    r15,rax
   1837892ba:	48 85 c0             	test   rax,rax
   1837892bd:	0f 84 9f 06 00 00    	je     0x183789962
   1837892c3:	4c 89 f8             	mov    rax,r15
   1837892c6:	49 83 c7 27          	add    r15,0x27
   1837892ca:	49 83 e7 e0          	and    r15,0xffffffffffffffe0
   1837892ce:	49 89 47 f8          	mov    QWORD PTR [r15-0x8],rax
   1837892d2:	e9 ca 00 00 00       	jmp    0x1837893a1
   1837892d7:	0f 57 c0             	xorps  xmm0,xmm0
   1837892da:	0f 29 85 c0 01 00 00 	movaps XMMWORD PTR [rbp+0x1c0],xmm0
   1837892e1:	0f 29 85 b0 01 00 00 	movaps XMMWORD PTR [rbp+0x1b0],xmm0
   1837892e8:	48 8b 9d 30 01 00 00 	mov    rbx,QWORD PTR [rbp+0x130]
   1837892ef:	48 83 bd 38 01 00 00 	cmp    QWORD PTR [rbp+0x138],0x10
   1837892f6:	10 
   1837892f7:	72 1b                	jb     0x183789314
   1837892f9:	4c 8b b5 20 01 00 00 	mov    r14,QWORD PTR [rbp+0x120]
   183789300:	eb 19                	jmp    0x18378931b
   183789302:	4c 8d bd d0 01 00 00 	lea    r15,[rbp+0x1d0]
   183789309:	41 be 0f 00 00 00    	mov    r14d,0xf
   18378930f:	e9 98 00 00 00       	jmp    0x1837893ac
   183789314:	4c 8d b5 20 01 00 00 	lea    r14,[rbp+0x120]
   18378931b:	48 85 db             	test   rbx,rbx
   18378931e:	0f 88 5c 06 00 00    	js     0x183789980
   183789324:	48 83 fb 0f          	cmp    rbx,0xf
   183789328:	77 22                	ja     0x18378934c
   18378932a:	48 89 9d c0 01 00 00 	mov    QWORD PTR [rbp+0x1c0],rbx
   183789331:	48 c7 85 c8 01 00 00 	mov    QWORD PTR [rbp+0x1c8],0xf
   183789338:	0f 00 00 00 
   18378933c:	41 0f 10 06          	movups xmm0,XMMWORD PTR [r14]
   183789340:	0f 29 85 b0 01 00 00 	movaps XMMWORD PTR [rbp+0x1b0],xmm0
   183789347:	e9 b4 01 00 00       	jmp    0x183789500
   18378934c:	48 89 d8             	mov    rax,rbx
   18378934f:	48 83 c8 0f          	or     rax,0xf
   183789353:	48 83 f8 17          	cmp    rax,0x17
   183789357:	41 bf 16 00 00 00    	mov    r15d,0x16
   18378935d:	4c 0f 43 f8          	cmovae r15,rax
   183789361:	48 3d ff 0f 00 00    	cmp    rax,0xfff
   183789367:	0f 82 63 01 00 00    	jb     0x1837894d0
   18378936d:	49 8d 4f 28          	lea    rcx,[r15+0x28]
   183789371:	e8 26 25 d2 03       	call   0x1874ab89c
   183789376:	90                   	nop
   183789377:	48 85 c0             	test   rax,rax
   18378937a:	0f 84 e2 05 00 00    	je     0x183789962
   183789380:	48 89 c1             	mov    rcx,rax
   183789383:	48 83 c0 27          	add    rax,0x27
   183789387:	48 83 e0 e0          	and    rax,0xffffffffffffffe0
   18378938b:	48 89 48 f8          	mov    QWORD PTR [rax-0x8],rcx
   18378938f:	e9 46 01 00 00       	jmp    0x1837894da
   183789394:	49 8d 4e 01          	lea    rcx,[r14+0x1]
   183789398:	e8 ff 24 d2 03       	call   0x1874ab89c
   18378939d:	90                   	nop
   18378939e:	49 89 c7             	mov    r15,rax
   1837893a1:	48 8d 43 01          	lea    rax,[rbx+0x1]
   1837893a5:	4c 89 bd d0 01 00 00 	mov    QWORD PTR [rbp+0x1d0],r15
   1837893ac:	49 83 fd 10          	cmp    r13,0x10
   1837893b0:	48 8d 55 c0          	lea    rdx,[rbp-0x40]
   1837893b4:	49 0f 43 d4          	cmovae rdx,r12
   1837893b8:	48 89 85 e0 01 00 00 	mov    QWORD PTR [rbp+0x1e0],rax
   1837893bf:	4c 89 b5 e8 01 00 00 	mov    QWORD PTR [rbp+0x1e8],r14
   1837893c6:	4c 89 f9             	mov    rcx,r15
   1837893c9:	49 89 d8             	mov    r8,rbx
   1837893cc:	e8 7f ac db 03       	call   0x187544050
   1837893d1:	66 41 c7 04 1f 20 00 	mov    WORD PTR [r15+rbx*1],0x20
   1837893d8:	48 8b 85 30 01 00 00 	mov    rax,QWORD PTR [rbp+0x130]
   1837893df:	48 83 bd 38 01 00 00 	cmp    QWORD PTR [rbp+0x138],0x10
   1837893e6:	10 
   1837893e7:	72 09                	jb     0x1837893f2
   1837893e9:	4c 8b 8d 20 01 00 00 	mov    r9,QWORD PTR [rbp+0x120]
   1837893f0:	eb 07                	jmp    0x1837893f9
   1837893f2:	4c 8d 8d 20 01 00 00 	lea    r9,[rbp+0x120]
   1837893f9:	48 8b 8d e0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1e0]
   183789400:	48 8b 95 e8 01 00 00 	mov    rdx,QWORD PTR [rbp+0x1e8]
   183789407:	49 89 d0             	mov    r8,rdx
   18378940a:	49 29 c8             	sub    r8,rcx
   18378940d:	4c 39 c0             	cmp    rax,r8
   183789410:	76 1a                	jbe    0x18378942c
   183789412:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   183789417:	48 8d 8d d0 01 00 00 	lea    rcx,[rbp+0x1d0]
   18378941e:	48 89 c2             	mov    rdx,rax
   183789421:	e8 9a ff 87 fc       	call   0x1800093c0
   183789426:	90                   	nop
   183789427:	48 89 c3             	mov    rbx,rax
   18378942a:	eb 35                	jmp    0x183789461
   18378942c:	4c 8d 34 01          	lea    r14,[rcx+rax*1]
   183789430:	4c 89 b5 e0 01 00 00 	mov    QWORD PTR [rbp+0x1e0],r14
   183789437:	48 8d 9d d0 01 00 00 	lea    rbx,[rbp+0x1d0]
   18378943e:	49 89 df             	mov    r15,rbx
   183789441:	48 83 fa 10          	cmp    rdx,0x10
   183789445:	72 07                	jb     0x18378944e
   183789447:	4c 8b bd d0 01 00 00 	mov    r15,QWORD PTR [rbp+0x1d0]
   18378944e:	4c 01 f9             	add    rcx,r15
   183789451:	4c 89 ca             	mov    rdx,r9
   183789454:	49 89 c0             	mov    r8,rax
   183789457:	e8 f4 ab db 03       	call   0x187544050
   18378945c:	43 c6 04 37 00       	mov    BYTE PTR [r15+r14*1],0x0
   183789461:	0f 10 03             	movups xmm0,XMMWORD PTR [rbx]
   183789464:	0f 10 4b 10          	movups xmm1,XMMWORD PTR [rbx+0x10]
   183789468:	0f 29 8d c0 01 00 00 	movaps XMMWORD PTR [rbp+0x1c0],xmm1
   18378946f:	0f 29 85 b0 01 00 00 	movaps XMMWORD PTR [rbp+0x1b0],xmm0
   183789476:	48 c7 43 10 00 00 00 	mov    QWORD PTR [rbx+0x10],0x0
   18378947d:	00 
   18378947e:	48 c7 43 18 0f 00 00 	mov    QWORD PTR [rbx+0x18],0xf
   183789485:	00 
   183789486:	c6 03 00             	mov    BYTE PTR [rbx],0x0
   183789489:	48 8b 85 e8 01 00 00 	mov    rax,QWORD PTR [rbp+0x1e8]
   183789490:	48 83 f8 10          	cmp    rax,0x10
   183789494:	72 6a                	jb     0x183789500
   183789496:	48 8b 8d d0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1d0]
   18378949d:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1837894a1:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1837894a8:	72 1f                	jb     0x1837894c9
   1837894aa:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1837894ae:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1837894b2:	4c 29 c1             	sub    rcx,r8
   1837894b5:	48 83 f9 20          	cmp    rcx,0x20
   1837894b9:	0f 83 a3 04 00 00    	jae    0x183789962
   1837894bf:	48 83 c0 28          	add    rax,0x28
   1837894c3:	48 89 c2             	mov    rdx,rax
   1837894c6:	4c 89 c1             	mov    rcx,r8
   1837894c9:	e8 12 24 d2 03       	call   0x1874ab8e0
   1837894ce:	eb 30                	jmp    0x183789500
   1837894d0:	49 8d 4f 01          	lea    rcx,[r15+0x1]
   1837894d4:	e8 c3 23 d2 03       	call   0x1874ab89c
   1837894d9:	90                   	nop
   1837894da:	48 89 85 b0 01 00 00 	mov    QWORD PTR [rbp+0x1b0],rax
   1837894e1:	48 89 9d c0 01 00 00 	mov    QWORD PTR [rbp+0x1c0],rbx
   1837894e8:	4c 89 bd c8 01 00 00 	mov    QWORD PTR [rbp+0x1c8],r15
   1837894ef:	48 ff c3             	inc    rbx
   1837894f2:	48 89 c1             	mov    rcx,rax
   1837894f5:	4c 89 f2             	mov    rdx,r14
   1837894f8:	49 89 d8             	mov    r8,rbx
   1837894fb:	e8 50 ab db 03       	call   0x187544050
   183789500:	48 8b 85 38 01 00 00 	mov    rax,QWORD PTR [rbp+0x138]
   183789507:	48 83 f8 10          	cmp    rax,0x10
   18378950b:	72 38                	jb     0x183789545
   18378950d:	48 8b 8d 20 01 00 00 	mov    rcx,QWORD PTR [rbp+0x120]
   183789514:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183789518:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18378951f:	72 1f                	jb     0x183789540
   183789521:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183789525:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183789529:	4c 29 c1             	sub    rcx,r8
   18378952c:	48 83 f9 20          	cmp    rcx,0x20
   183789530:	0f 83 2c 04 00 00    	jae    0x183789962
   183789536:	48 83 c0 28          	add    rax,0x28
   18378953a:	48 89 c2             	mov    rdx,rax
   18378953d:	4c 89 c1             	mov    rcx,r8
   183789540:	e8 9b 23 d2 03       	call   0x1874ab8e0
   183789545:	48 8b 45 d8          	mov    rax,QWORD PTR [rbp-0x28]
   183789549:	48 83 f8 10          	cmp    rax,0x10
   18378954d:	72 35                	jb     0x183789584
   18378954f:	48 8b 4d c0          	mov    rcx,QWORD PTR [rbp-0x40]
   183789553:	48 8d 50 01          	lea    rdx,[rax+0x1]
   183789557:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18378955e:	72 1f                	jb     0x18378957f
   183789560:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183789564:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   183789568:	4c 29 c1             	sub    rcx,r8
   18378956b:	48 83 f9 20          	cmp    rcx,0x20
   18378956f:	0f 83 ed 03 00 00    	jae    0x183789962
   183789575:	48 83 c0 28          	add    rax,0x28
   183789579:	48 89 c2             	mov    rdx,rax
   18378957c:	4c 89 c1             	mov    rcx,r8
   18378957f:	e8 5c 23 d2 03       	call   0x1874ab8e0
   183789584:	48 8b 85 98 00 00 00 	mov    rax,QWORD PTR [rbp+0x98]
   18378958b:	48 83 f8 10          	cmp    rax,0x10
   18378958f:	72 38                	jb     0x1837895c9
   183789591:	48 8b 8d 80 00 00 00 	mov    rcx,QWORD PTR [rbp+0x80]
   183789598:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18378959c:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1837895a3:	72 1f                	jb     0x1837895c4
   1837895a5:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1837895a9:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1837895ad:	4c 29 c1             	sub    rcx,r8
   1837895b0:	48 83 f9 20          	cmp    rcx,0x20
   1837895b4:	0f 83 a8 03 00 00    	jae    0x183789962
   1837895ba:	48 83 c0 28          	add    rax,0x28
   1837895be:	48 89 c2             	mov    rdx,rax
   1837895c1:	4c 89 c1             	mov    rcx,r8
   1837895c4:	e8 17 23 d2 03       	call   0x1874ab8e0
   1837895c9:	4c 8b bd 78 01 00 00 	mov    r15,QWORD PTR [rbp+0x178]
   1837895d0:	4d 85 ff             	test   r15,r15
   1837895d3:	74 1f                	je     0x1837895f4
   1837895d5:	f0 41 ff 4f 08       	lock dec DWORD PTR [r15+0x8]
   1837895da:	75 18                	jne    0x1837895f4
   1837895dc:	49 8b 07             	mov    rax,QWORD PTR [r15]
   1837895df:	4c 89 f9             	mov    rcx,r15
   1837895e2:	ff 10                	call   QWORD PTR [rax]
   1837895e4:	f0 41 ff 4f 0c       	lock dec DWORD PTR [r15+0xc]
   1837895e9:	75 09                	jne    0x1837895f4
   1837895eb:	49 8b 07             	mov    rax,QWORD PTR [r15]
   1837895ee:	4c 89 f9             	mov    rcx,r15
   1837895f1:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1837895f4:	48 8b 85 98 01 00 00 	mov    rax,QWORD PTR [rbp+0x198]
   1837895fb:	48 83 f8 10          	cmp    rax,0x10
   1837895ff:	72 38                	jb     0x183789639
   183789601:	48 8b 8d 80 01 00 00 	mov    rcx,QWORD PTR [rbp+0x180]
   183789608:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18378960c:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183789613:	72 1f                	jb     0x183789634
   183789615:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183789619:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18378961d:	4c 29 c1             	sub    rcx,r8
   183789620:	48 83 f9 20          	cmp    rcx,0x20
   183789624:	0f 83 38 03 00 00    	jae    0x183789962
   18378962a:	48 83 c0 28          	add    rax,0x28
   18378962e:	48 89 c2             	mov    rdx,rax
   183789631:	4c 89 c1             	mov    rcx,r8
   183789634:	e8 a7 22 d2 03       	call   0x1874ab8e0
   183789639:	0f 28 85 b0 01 00 00 	movaps xmm0,XMMWORD PTR [rbp+0x1b0]
   183789640:	0f 28 8d c0 01 00 00 	movaps xmm1,XMMWORD PTR [rbp+0x1c0]
   183789647:	0f 29 8d 90 01 00 00 	movaps XMMWORD PTR [rbp+0x190],xmm1
   18378964e:	0f 29 85 80 01 00 00 	movaps XMMWORD PTR [rbp+0x180],xmm0
   183789655:	48 8b 5d 78          	mov    rbx,QWORD PTR [rbp+0x78]
   183789659:	48 85 db             	test   rbx,rbx
   18378965c:	74 1d                	je     0x18378967b
   18378965e:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   183789662:	75 17                	jne    0x18378967b
   183789664:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   183789667:	48 89 d9             	mov    rcx,rbx
   18378966a:	ff 10                	call   QWORD PTR [rax]
   18378966c:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   183789670:	75 09                	jne    0x18378967b
   183789672:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   183789675:	48 89 d9             	mov    rcx,rbx
   183789678:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18378967b:	0f 29 b5 b0 01 00 00 	movaps XMMWORD PTR [rbp+0x1b0],xmm6
   183789682:	48 8d 8d b0 01 00 00 	lea    rcx,[rbp+0x1b0]
   183789689:	e8 e2 b5 f6 fc       	call   0x1806f4c70
   18378968e:	90                   	nop
   18378968f:	48 8b 85 b0 01 00 00 	mov    rax,QWORD PTR [rbp+0x1b0]
   183789696:	c7 80 18 01 00 00 01 	mov    DWORD PTR [rax+0x118],0x1
   18378969d:	00 00 00 
   1837896a0:	4c 8b 0f             	mov    r9,QWORD PTR [rdi]
   1837896a3:	4c 39 c8             	cmp    rax,r9
   1837896a6:	74 75                	je     0x18378971d
   1837896a8:	49 8b b9 c0 00 00 00 	mov    rdi,QWORD PTR [r9+0xc0]
   1837896af:	49 83 b9 c8 00 00 00 	cmp    QWORD PTR [r9+0xc8],0x10
   1837896b6:	10 
   1837896b7:	72 3e                	jb     0x1837896f7
   1837896b9:	4d 8b 89 b0 00 00 00 	mov    r9,QWORD PTR [r9+0xb0]
   1837896c0:	48 8d 98 b0 00 00 00 	lea    rbx,[rax+0xb0]
   1837896c7:	48 8b 88 c8 00 00 00 	mov    rcx,QWORD PTR [rax+0xc8]
   1837896ce:	48 39 cf             	cmp    rdi,rcx
   1837896d1:	77 3e                	ja     0x183789711
   1837896d3:	48 83 f9 10          	cmp    rcx,0x10
   1837896d7:	72 03                	jb     0x1837896dc
   1837896d9:	48 8b 1b             	mov    rbx,QWORD PTR [rbx]
   1837896dc:	48 89 b8 c0 00 00 00 	mov    QWORD PTR [rax+0xc0],rdi
   1837896e3:	48 89 d9             	mov    rcx,rbx
   1837896e6:	4c 89 ca             	mov    rdx,r9
   1837896e9:	49 89 f8             	mov    r8,rdi
   1837896ec:	e8 5f a9 db 03       	call   0x187544050
   1837896f1:	c6 04 3b 00          	mov    BYTE PTR [rbx+rdi*1],0x0
   1837896f5:	eb 26                	jmp    0x18378971d
   1837896f7:	49 81 c1 b0 00 00 00 	add    r9,0xb0
   1837896fe:	48 8d 98 b0 00 00 00 	lea    rbx,[rax+0xb0]
   183789705:	48 8b 88 c8 00 00 00 	mov    rcx,QWORD PTR [rax+0xc8]
   18378970c:	48 39 cf             	cmp    rdi,rcx
   18378970f:	76 c2                	jbe    0x1837896d3
   183789711:	48 89 d9             	mov    rcx,rbx
   183789714:	48 89 fa             	mov    rdx,rdi
   183789717:	e8 34 4a 8b fc       	call   0x18003e150
   18378971c:	90                   	nop
   18378971d:	48 8b 85 b0 01 00 00 	mov    rax,QWORD PTR [rbp+0x1b0]
   183789724:	48 8d b8 58 07 00 00 	lea    rdi,[rax+0x758]
   18378972b:	4c 8d 8d 80 01 00 00 	lea    r9,[rbp+0x180]
   183789732:	4c 39 cf             	cmp    rdi,r9
   183789735:	74 30                	je     0x183789767
   183789737:	48 8b 9d 90 01 00 00 	mov    rbx,QWORD PTR [rbp+0x190]
   18378973e:	48 83 bd 98 01 00 00 	cmp    QWORD PTR [rbp+0x198],0x10
   183789745:	10 
   183789746:	72 07                	jb     0x18378974f
   183789748:	4c 8b 8d 80 01 00 00 	mov    r9,QWORD PTR [rbp+0x180]
   18378974f:	48 8b 88 70 07 00 00 	mov    rcx,QWORD PTR [rax+0x770]
   183789756:	48 39 cb             	cmp    rbx,rcx
   183789759:	76 1f                	jbe    0x18378977a
   18378975b:	48 89 f9             	mov    rcx,rdi
   18378975e:	48 89 da             	mov    rdx,rbx
   183789761:	e8 ea 49 8b fc       	call   0x18003e150
   183789766:	90                   	nop
   183789767:	b9 02 00 00 00       	mov    ecx,0x2
   18378976c:	e8 6f 36 8e fc       	call   0x18006cde0
   183789771:	85 c0                	test   eax,eax
   183789773:	75 39                	jne    0x1837897ae
   183789775:	e9 56 01 00 00       	jmp    0x1837898d0
   18378977a:	48 83 f9 10          	cmp    rcx,0x10
   18378977e:	72 03                	jb     0x183789783
   183789780:	48 8b 3f             	mov    rdi,QWORD PTR [rdi]
   183789783:	48 89 98 68 07 00 00 	mov    QWORD PTR [rax+0x768],rbx
   18378978a:	48 89 f9             	mov    rcx,rdi
   18378978d:	4c 89 ca             	mov    rdx,r9
   183789790:	49 89 d8             	mov    r8,rbx
   183789793:	e8 b8 a8 db 03       	call   0x187544050
   183789798:	c6 04 1f 00          	mov    BYTE PTR [rdi+rbx*1],0x0
   18378979c:	b9 02 00 00 00       	mov    ecx,0x2
   1837897a1:	e8 3a 36 8e fc       	call   0x18006cde0
   1837897a6:	85 c0                	test   eax,eax
   1837897a8:	0f 84 22 01 00 00    	je     0x1837898d0
   1837897ae:	48 8d bd d0 01 00 00 	lea    rdi,[rbp+0x1d0]
   1837897b5:	48 89 f9             	mov    rcx,rdi
   1837897b8:	e8 53 37 8e fc       	call   0x18006cf10
   1837897bd:	90                   	nop
   1837897be:	48 83 bd e8 01 00 00 	cmp    QWORD PTR [rbp+0x1e8],0x10
   1837897c5:	10 
   1837897c6:	72 07                	jb     0x1837897cf
   1837897c8:	48 8b bd d0 01 00 00 	mov    rdi,QWORD PTR [rbp+0x1d0]
   1837897cf:	48 8d 05 7a 47 d5 05 	lea    rax,[rip+0x5d5477a]        # 0x1894ddf50
   1837897d6:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1837897db:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   1837897e2:	00 00 
   1837897e4:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   1837897e9:	c7 44 24 28 a6 00 00 	mov    DWORD PTR [rsp+0x28],0xa6
   1837897f0:	00 
   1837897f1:	4c 8d 0d d0 47 d5 05 	lea    r9,[rip+0x5d547d0]        # 0x1894ddfc8
   1837897f8:	48 8d 8d 80 00 00 00 	lea    rcx,[rbp+0x80]
   1837897ff:	ba 02 00 00 00       	mov    edx,0x2
   183789804:	49 89 f8             	mov    r8,rdi
   183789807:	e8 64 3a 8e fc       	call   0x18006d270
   18378980c:	90                   	nop
   18378980d:	48 83 bd 98 01 00 00 	cmp    QWORD PTR [rbp+0x198],0x10
   183789814:	10 
   183789815:	72 09                	jb     0x183789820
   183789817:	48 8b 85 80 01 00 00 	mov    rax,QWORD PTR [rbp+0x180]
   18378981e:	eb 07                	jmp    0x183789827
   183789820:	48 8d 85 80 01 00 00 	lea    rax,[rbp+0x180]
   183789827:	48 89 85 20 01 00 00 	mov    QWORD PTR [rbp+0x120],rax
   18378982e:	c6 85 28 01 00 00 00 	mov    BYTE PTR [rbp+0x128],0x0
   183789835:	0f 57 c0             	xorps  xmm0,xmm0
   183789838:	0f 11 45 28          	movups XMMWORD PTR [rbp+0x28],xmm0
   18378983c:	0f 11 45 18          	movups XMMWORD PTR [rbp+0x18],xmm0
   183789840:	0f 11 45 08          	movups XMMWORD PTR [rbp+0x8],xmm0
   183789844:	0f 11 45 f8          	movups XMMWORD PTR [rbp-0x8],xmm0
   183789848:	0f 11 45 e8          	movups XMMWORD PTR [rbp-0x18],xmm0
   18378984c:	0f 11 45 d8          	movups XMMWORD PTR [rbp-0x28],xmm0
   183789850:	0f 11 45 c8          	movups XMMWORD PTR [rbp-0x38],xmm0
   183789854:	48 c7 45 38 00 00 00 	mov    QWORD PTR [rbp+0x38],0x0
   18378985b:	00 
   18378985c:	48 8d 85 20 01 00 00 	lea    rax,[rbp+0x120]
   183789863:	48 89 45 c0          	mov    QWORD PTR [rbp-0x40],rax
   183789867:	48 8d 15 92 47 d5 05 	lea    rdx,[rip+0x5d54792]        # 0x1894de000
   18378986e:	48 8d 8d 80 00 00 00 	lea    rcx,[rbp+0x80]
   183789875:	4c 8d 45 c0          	lea    r8,[rbp-0x40]
   183789879:	e8 92 3f 8e fc       	call   0x18006d810
   18378987e:	90                   	nop
   18378987f:	48 8d 8d 80 00 00 00 	lea    rcx,[rbp+0x80]
   183789886:	e8 e5 3a 8e fc       	call   0x18006d370
   18378988b:	48 8b 85 e8 01 00 00 	mov    rax,QWORD PTR [rbp+0x1e8]
   183789892:	48 83 f8 10          	cmp    rax,0x10
   183789896:	72 38                	jb     0x1837898d0
   183789898:	48 8b 8d d0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1d0]
   18378989f:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1837898a3:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1837898aa:	72 1f                	jb     0x1837898cb
   1837898ac:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1837898b0:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1837898b4:	4c 29 c1             	sub    rcx,r8
   1837898b7:	48 83 f9 20          	cmp    rcx,0x20
   1837898bb:	0f 83 a1 00 00 00    	jae    0x183789962
   1837898c1:	48 83 c0 28          	add    rax,0x28
   1837898c5:	48 89 c2             	mov    rdx,rax
   1837898c8:	4c 89 c1             	mov    rcx,r8
   1837898cb:	e8 10 20 d2 03       	call   0x1874ab8e0
   1837898d0:	0f 28 85 b0 01 00 00 	movaps xmm0,XMMWORD PTR [rbp+0x1b0]
   1837898d7:	0f 11 06             	movups XMMWORD PTR [rsi],xmm0
   1837898da:	48 8b bd 18 01 00 00 	mov    rdi,QWORD PTR [rbp+0x118]
   1837898e1:	48 85 ff             	test   rdi,rdi
   1837898e4:	74 1d                	je     0x183789903
   1837898e6:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   1837898ea:	75 17                	jne    0x183789903
   1837898ec:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1837898ef:	48 89 f9             	mov    rcx,rdi
   1837898f2:	ff 10                	call   QWORD PTR [rax]
   1837898f4:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   1837898f8:	75 09                	jne    0x183789903
   1837898fa:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1837898fd:	48 89 f9             	mov    rcx,rdi
   183789900:	ff 50 08             	call   QWORD PTR [rax+0x8]
   183789903:	48 8b 85 98 01 00 00 	mov    rax,QWORD PTR [rbp+0x198]
   18378990a:	48 83 f8 10          	cmp    rax,0x10
   18378990e:	72 34                	jb     0x183789944
   183789910:	48 8b 8d 80 01 00 00 	mov    rcx,QWORD PTR [rbp+0x180]
   183789917:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18378991b:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   183789922:	72 1b                	jb     0x18378993f
   183789924:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   183789928:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18378992c:	4c 29 c1             	sub    rcx,r8
   18378992f:	48 83 f9 20          	cmp    rcx,0x20
   183789933:	73 2d                	jae    0x183789962
   183789935:	48 83 c0 28          	add    rax,0x28
   183789939:	48 89 c2             	mov    rdx,rax
   18378993c:	4c 89 c1             	mov    rcx,r8
   18378993f:	e8 9c 1f d2 03       	call   0x1874ab8e0
   183789944:	48 89 f0             	mov    rax,rsi
   183789947:	0f 28 b5 00 02 00 00 	movaps xmm6,XMMWORD PTR [rbp+0x200]
   18378994e:	48 81 c4 98 02 00 00 	add    rsp,0x298
   183789955:	5b                   	pop    rbx
   183789956:	5f                   	pop    rdi
   183789957:	5e                   	pop    rsi
   183789958:	41 5c                	pop    r12
   18378995a:	41 5d                	pop    r13
   18378995c:	41 5e                	pop    r14
   18378995e:	41 5f                	pop    r15
   183789960:	5d                   	pop    rbp
   183789961:	c3                   	ret
   183789962:	e8 25 3a d8 03       	call   0x18750d38c
   183789967:	90                   	nop
   183789968:	e8 23 f2 87 fc       	call   0x180008b90
   18378996d:	90                   	nop
   18378996e:	e8 1d f2 87 fc       	call   0x180008b90
   183789973:	90                   	nop
   183789974:	e8 17 f2 87 fc       	call   0x180008b90
   183789979:	90                   	nop
   18378997a:	e8 11 f2 87 fc       	call   0x180008b90
   18378997f:	90                   	nop
   183789980:	e8 0b f2 87 fc       	call   0x180008b90
   183789985:	90                   	nop
   183789986:	cc                   	int3
