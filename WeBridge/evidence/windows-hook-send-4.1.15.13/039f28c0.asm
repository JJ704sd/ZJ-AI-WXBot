
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

00000001839f28c0 <.text+0x39f18c0>:
   1839f28c0:	55                   	push   rbp
   1839f28c1:	41 57                	push   r15
   1839f28c3:	41 56                	push   r14
   1839f28c5:	41 54                	push   r12
   1839f28c7:	56                   	push   rsi
   1839f28c8:	57                   	push   rdi
   1839f28c9:	53                   	push   rbx
   1839f28ca:	48 83 ec 70          	sub    rsp,0x70
   1839f28ce:	48 8d 6c 24 70       	lea    rbp,[rsp+0x70]
   1839f28d3:	48 c7 45 f8 fe ff ff 	mov    QWORD PTR [rbp-0x8],0xfffffffffffffffe
   1839f28da:	ff 
   1839f28db:	4c 89 cf             	mov    rdi,r9
   1839f28de:	4c 89 c3             	mov    rbx,r8
   1839f28e1:	49 89 d6             	mov    r14,rdx
   1839f28e4:	48 89 ce             	mov    rsi,rcx
   1839f28e7:	48 b8 aa aa aa aa aa 	movabs rax,0xaaaaaaaaaaaaaaaa
   1839f28ee:	aa aa aa 
   1839f28f1:	48 89 45 e8          	mov    QWORD PTR [rbp-0x18],rax
   1839f28f5:	0f 28 05 a4 1d b2 05 	movaps xmm0,XMMWORD PTR [rip+0x5b21da4]        # 0x1895146a0
   1839f28fc:	0f 29 45 b0          	movaps XMMWORD PTR [rbp-0x50],xmm0
   1839f2900:	c7 45 c0 0a 02 00 00 	mov    DWORD PTR [rbp-0x40],0x20a
   1839f2907:	0f 57 c0             	xorps  xmm0,xmm0
   1839f290a:	0f 11 45 c4          	movups XMMWORD PTR [rbp-0x3c],xmm0
   1839f290e:	c7 45 d4 00 00 00 00 	mov    DWORD PTR [rbp-0x2c],0x0
   1839f2915:	b9 30 00 00 00       	mov    ecx,0x30
   1839f291a:	e8 7d 8f ab 03       	call   0x1874ab89c
   1839f291f:	90                   	nop
   1839f2920:	48 89 45 c8          	mov    QWORD PTR [rbp-0x38],rax
   1839f2924:	48 c7 45 d8 20 00 00 	mov    QWORD PTR [rbp-0x28],0x20
   1839f292b:	00 
   1839f292c:	48 c7 45 e0 2f 00 00 	mov    QWORD PTR [rbp-0x20],0x2f
   1839f2933:	00 
   1839f2934:	0f 10 05 95 23 b2 05 	movups xmm0,XMMWORD PTR [rip+0x5b22395]        # 0x189514cd0
   1839f293b:	0f 11 40 10          	movups XMMWORD PTR [rax+0x10],xmm0
   1839f293f:	0f 10 05 7a 23 b2 05 	movups xmm0,XMMWORD PTR [rip+0x5b2237a]        # 0x189514cc0
   1839f2946:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   1839f2949:	c6 40 20 00          	mov    BYTE PTR [rax+0x20],0x0
   1839f294d:	c6 45 e8 01          	mov    BYTE PTR [rbp-0x18],0x1
   1839f2951:	4c 8b 7f 18          	mov    r15,QWORD PTR [rdi+0x18]
   1839f2955:	4d 85 ff             	test   r15,r15
   1839f2958:	74 44                	je     0x1839f299e
   1839f295a:	48 83 7f 20 10       	cmp    QWORD PTR [rdi+0x20],0x10
   1839f295f:	72 26                	jb     0x1839f2987
   1839f2961:	4c 8b 4f 08          	mov    r9,QWORD PTR [rdi+0x8]
   1839f2965:	49 83 ff 2f          	cmp    r15,0x2f
   1839f2969:	77 26                	ja     0x1839f2991
   1839f296b:	4c 89 7d d8          	mov    QWORD PTR [rbp-0x28],r15
   1839f296f:	48 89 c1             	mov    rcx,rax
   1839f2972:	4c 89 ca             	mov    rdx,r9
   1839f2975:	4d 89 f8             	mov    r8,r15
   1839f2978:	49 89 c4             	mov    r12,rax
   1839f297b:	e8 d0 16 b5 03       	call   0x187544050
   1839f2980:	43 c6 04 3c 00       	mov    BYTE PTR [r12+r15*1],0x0
   1839f2985:	eb 17                	jmp    0x1839f299e
   1839f2987:	4c 8d 4f 08          	lea    r9,[rdi+0x8]
   1839f298b:	49 83 ff 2f          	cmp    r15,0x2f
   1839f298f:	76 da                	jbe    0x1839f296b
   1839f2991:	48 8d 4d c8          	lea    rcx,[rbp-0x38]
   1839f2995:	4c 89 fa             	mov    rdx,r15
   1839f2998:	e8 b3 b7 64 fc       	call   0x18003e150
   1839f299d:	90                   	nop
   1839f299e:	b9 10 01 00 00       	mov    ecx,0x110
   1839f29a3:	e8 f4 8e ab 03       	call   0x1874ab89c
   1839f29a8:	90                   	nop
   1839f29a9:	48 8d 55 b0          	lea    rdx,[rbp-0x50]
   1839f29ad:	48 89 c1             	mov    rcx,rax
   1839f29b0:	48 89 45 f0          	mov    QWORD PTR [rbp-0x10],rax
   1839f29b4:	e8 47 02 00 00       	call   0x1839f2c00
   1839f29b9:	90                   	nop
   1839f29ba:	4c 8b 65 f0          	mov    r12,QWORD PTR [rbp-0x10]
   1839f29be:	49 8b 04 24          	mov    rax,QWORD PTR [r12]
   1839f29c2:	4c 89 e1             	mov    rcx,r12
   1839f29c5:	ff 50 18             	call   QWORD PTR [rax+0x18]
   1839f29c8:	90                   	nop
   1839f29c9:	48 89 c1             	mov    rcx,rax
   1839f29cc:	4c 89 f2             	mov    rdx,r14
   1839f29cf:	e8 fc 13 49 ff       	call   0x182e83dd0
   1839f29d4:	90                   	nop
   1839f29d5:	4d 8d 74 24 60       	lea    r14,[r12+0x60]
   1839f29da:	4c 8b 7d 60          	mov    r15,QWORD PTR [rbp+0x60]
   1839f29de:	4d 39 fe             	cmp    r14,r15
   1839f29e1:	74 6b                	je     0x1839f2a4e
   1839f29e3:	49 8b 8c 24 98 00 00 	mov    rcx,QWORD PTR [r12+0x98]
   1839f29ea:	00 
   1839f29eb:	48 85 c9             	test   rcx,rcx
   1839f29ee:	74 18                	je     0x1839f2a08
   1839f29f0:	4c 39 f1             	cmp    rcx,r14
   1839f29f3:	0f 95 c2             	setne  dl
   1839f29f6:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   1839f29f9:	ff 50 20             	call   QWORD PTR [rax+0x20]
   1839f29fc:	49 c7 84 24 98 00 00 	mov    QWORD PTR [r12+0x98],0x0
   1839f2a03:	00 00 00 00 00 
   1839f2a08:	49 8b 4f 38          	mov    rcx,QWORD PTR [r15+0x38]
   1839f2a0c:	48 85 c9             	test   rcx,rcx
   1839f2a0f:	74 3d                	je     0x1839f2a4e
   1839f2a11:	4c 39 f9             	cmp    rcx,r15
   1839f2a14:	74 0a                	je     0x1839f2a20
   1839f2a16:	49 89 8c 24 98 00 00 	mov    QWORD PTR [r12+0x98],rcx
   1839f2a1d:	00 
   1839f2a1e:	eb 26                	jmp    0x1839f2a46
   1839f2a20:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   1839f2a23:	4c 89 f2             	mov    rdx,r14
   1839f2a26:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1839f2a29:	49 89 84 24 98 00 00 	mov    QWORD PTR [r12+0x98],rax
   1839f2a30:	00 
   1839f2a31:	49 8b 4f 38          	mov    rcx,QWORD PTR [r15+0x38]
   1839f2a35:	48 85 c9             	test   rcx,rcx
   1839f2a38:	74 14                	je     0x1839f2a4e
   1839f2a3a:	4c 39 f9             	cmp    rcx,r15
   1839f2a3d:	0f 95 c2             	setne  dl
   1839f2a40:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   1839f2a43:	ff 50 20             	call   QWORD PTR [rax+0x20]
   1839f2a46:	49 c7 47 38 00 00 00 	mov    QWORD PTR [r15+0x38],0x0
   1839f2a4d:	00 
   1839f2a4e:	4d 8d 74 24 40       	lea    r14,[r12+0x40]
   1839f2a53:	49 39 de             	cmp    r14,rbx
   1839f2a56:	74 4a                	je     0x1839f2aa2
   1839f2a58:	4c 8b 7b 10          	mov    r15,QWORD PTR [rbx+0x10]
   1839f2a5c:	48 83 7b 18 10       	cmp    QWORD PTR [rbx+0x18],0x10
   1839f2a61:	72 03                	jb     0x1839f2a66
   1839f2a63:	48 8b 1b             	mov    rbx,QWORD PTR [rbx]
   1839f2a66:	49 8b 44 24 58       	mov    rax,QWORD PTR [r12+0x58]
   1839f2a6b:	49 39 c7             	cmp    r15,rax
   1839f2a6e:	76 11                	jbe    0x1839f2a81
   1839f2a70:	4c 89 f1             	mov    rcx,r14
   1839f2a73:	4c 89 fa             	mov    rdx,r15
   1839f2a76:	49 89 d9             	mov    r9,rbx
   1839f2a79:	e8 d2 b6 64 fc       	call   0x18003e150
   1839f2a7e:	90                   	nop
   1839f2a7f:	eb 21                	jmp    0x1839f2aa2
   1839f2a81:	48 83 f8 10          	cmp    rax,0x10
   1839f2a85:	72 03                	jb     0x1839f2a8a
   1839f2a87:	4d 8b 36             	mov    r14,QWORD PTR [r14]
   1839f2a8a:	4d 89 7c 24 50       	mov    QWORD PTR [r12+0x50],r15
   1839f2a8f:	4c 89 f1             	mov    rcx,r14
   1839f2a92:	48 89 da             	mov    rdx,rbx
   1839f2a95:	4d 89 f8             	mov    r8,r15
   1839f2a98:	e8 b3 15 b5 03       	call   0x187544050
   1839f2a9d:	43 c6 04 3e 00       	mov    BYTE PTR [r14+r15*1],0x0
   1839f2aa2:	0f b6 47 28          	movzx  eax,BYTE PTR [rdi+0x28]
   1839f2aa6:	41 88 84 24 a0 00 00 	mov    BYTE PTR [r12+0xa0],al
   1839f2aad:	00 
   1839f2aae:	8b 47 2c             	mov    eax,DWORD PTR [rdi+0x2c]
   1839f2ab1:	41 89 84 24 a4 00 00 	mov    DWORD PTR [r12+0xa4],eax
   1839f2ab8:	00 
   1839f2ab9:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1839f2abc:	48 89 f1             	mov    rcx,rsi
   1839f2abf:	4c 89 e2             	mov    rdx,r12
   1839f2ac2:	ff 50 28             	call   QWORD PTR [rax+0x28]
   1839f2ac5:	90                   	nop
   1839f2ac6:	e8 b5 96 c8 fc       	call   0x18067c180
   1839f2acb:	90                   	nop
   1839f2acc:	4c 89 e2             	mov    rdx,r12
   1839f2acf:	48 83 c2 18          	add    rdx,0x18
   1839f2ad3:	48 89 c1             	mov    rcx,rax
   1839f2ad6:	e8 45 9a c8 fc       	call   0x18067c520
   1839f2adb:	90                   	nop
   1839f2adc:	41 8b 74 24 08       	mov    esi,DWORD PTR [r12+0x8]
   1839f2ae1:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
   1839f2ae5:	48 83 f8 10          	cmp    rax,0x10
   1839f2ae9:	48 8b 7d 60          	mov    rdi,QWORD PTR [rbp+0x60]
   1839f2aed:	72 31                	jb     0x1839f2b20
   1839f2aef:	48 8b 4d c8          	mov    rcx,QWORD PTR [rbp-0x38]
   1839f2af3:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1839f2af7:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1839f2afe:	72 1b                	jb     0x1839f2b1b
   1839f2b00:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1839f2b04:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1839f2b08:	4c 29 c1             	sub    rcx,r8
   1839f2b0b:	48 83 f9 20          	cmp    rcx,0x20
   1839f2b0f:	73 35                	jae    0x1839f2b46
   1839f2b11:	48 83 c0 28          	add    rax,0x28
   1839f2b15:	48 89 c2             	mov    rdx,rax
   1839f2b18:	4c 89 c1             	mov    rcx,r8
   1839f2b1b:	e8 c0 8d ab 03       	call   0x1874ab8e0
   1839f2b20:	48 8b 4f 38          	mov    rcx,QWORD PTR [rdi+0x38]
   1839f2b24:	48 85 c9             	test   rcx,rcx
   1839f2b27:	74 0c                	je     0x1839f2b35
   1839f2b29:	48 39 f9             	cmp    rcx,rdi
   1839f2b2c:	0f 95 c2             	setne  dl
   1839f2b2f:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   1839f2b32:	ff 50 20             	call   QWORD PTR [rax+0x20]
   1839f2b35:	89 f0                	mov    eax,esi
   1839f2b37:	48 83 c4 70          	add    rsp,0x70
   1839f2b3b:	5b                   	pop    rbx
   1839f2b3c:	5f                   	pop    rdi
   1839f2b3d:	5e                   	pop    rsi
   1839f2b3e:	41 5c                	pop    r12
   1839f2b40:	41 5e                	pop    r14
   1839f2b42:	41 5f                	pop    r15
   1839f2b44:	5d                   	pop    rbp
   1839f2b45:	c3                   	ret
   1839f2b46:	e8 41 a8 b1 03       	call   0x18750d38c
   1839f2b4b:	cc                   	int3
