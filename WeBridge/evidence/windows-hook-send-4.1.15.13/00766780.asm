
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000180766780 <.text+0x765780>:
   180766780:	55                   	push   rbp
   180766781:	41 56                	push   r14
   180766783:	56                   	push   rsi
   180766784:	57                   	push   rdi
   180766785:	53                   	push   rbx
   180766786:	48 81 ec 80 00 00 00 	sub    rsp,0x80
   18076678d:	48 8d ac 24 80 00 00 	lea    rbp,[rsp+0x80]
   180766794:	00 
   180766795:	0f 29 75 f0          	movaps XMMWORD PTR [rbp-0x10],xmm6
   180766799:	48 c7 45 e8 fe ff ff 	mov    QWORD PTR [rbp-0x18],0xfffffffffffffffe
   1807667a0:	ff 
   1807667a1:	48 89 d6             	mov    rsi,rdx
   1807667a4:	0f 57 f6             	xorps  xmm6,xmm6
   1807667a7:	0f 11 71 08          	movups XMMWORD PTR [rcx+0x8],xmm6
   1807667ab:	0f 11 71 18          	movups XMMWORD PTR [rcx+0x18],xmm6
   1807667af:	48 c7 41 28 00 00 00 	mov    QWORD PTR [rcx+0x28],0x0
   1807667b6:	00 
   1807667b7:	48 c7 41 30 0f 00 00 	mov    QWORD PTR [rcx+0x30],0xf
   1807667be:	00 
   1807667bf:	0f 11 71 38          	movups XMMWORD PTR [rcx+0x38],xmm6
   1807667c3:	48 c7 41 48 00 00 00 	mov    QWORD PTR [rcx+0x48],0x0
   1807667ca:	00 
   1807667cb:	48 c7 41 50 0f 00 00 	mov    QWORD PTR [rcx+0x50],0xf
   1807667d2:	00 
   1807667d3:	0f 11 71 58          	movups XMMWORD PTR [rcx+0x58],xmm6
   1807667d7:	48 c7 41 68 00 00 00 	mov    QWORD PTR [rcx+0x68],0x0
   1807667de:	00 
   1807667df:	48 c7 41 70 0f 00 00 	mov    QWORD PTR [rcx+0x70],0xf
   1807667e6:	00 
   1807667e7:	0f 11 71 78          	movups XMMWORD PTR [rcx+0x78],xmm6
   1807667eb:	48 c7 81 88 00 00 00 	mov    QWORD PTR [rcx+0x88],0x0
   1807667f2:	00 00 00 00 
   1807667f6:	48 c7 81 90 00 00 00 	mov    QWORD PTR [rcx+0x90],0xf
   1807667fd:	0f 00 00 00 
   180766801:	0f 28 05 78 ff 6d 08 	movaps xmm0,XMMWORD PTR [rip+0x86dff78]        # 0x188e46780
   180766808:	0f 11 81 98 00 00 00 	movups XMMWORD PTR [rcx+0x98],xmm0
   18076680f:	c7 81 a8 00 00 00 00 	mov    DWORD PTR [rcx+0xa8],0x0
   180766816:	00 00 00 
   180766819:	0f 11 b1 b0 00 00 00 	movups XMMWORD PTR [rcx+0xb0],xmm6
   180766820:	48 c7 81 c0 00 00 00 	mov    QWORD PTR [rcx+0xc0],0x0
   180766827:	00 00 00 00 
   18076682b:	48 c7 81 c8 00 00 00 	mov    QWORD PTR [rcx+0xc8],0xf
   180766832:	0f 00 00 00 
   180766836:	48 c7 81 d0 00 00 00 	mov    QWORD PTR [rcx+0xd0],0x0
   18076683d:	00 00 00 00 
   180766841:	c6 81 08 01 00 00 00 	mov    BYTE PTR [rcx+0x108],0x0
   180766848:	c7 81 10 01 00 00 00 	mov    DWORD PTR [rcx+0x110],0x0
   18076684f:	00 00 00 
   180766852:	48 8d 05 bf ce 6e 08 	lea    rax,[rip+0x86ecebf]        # 0x188e53718
   180766859:	48 89 01             	mov    QWORD PTR [rcx],rax
   18076685c:	48 c7 81 18 01 00 00 	mov    QWORD PTR [rcx+0x118],0x0
   180766863:	00 00 00 00 
   180766867:	48 89 4d e0          	mov    QWORD PTR [rbp-0x20],rcx
   18076686b:	48 81 c1 20 01 00 00 	add    rcx,0x120
   180766872:	48 89 4d a0          	mov    QWORD PTR [rbp-0x60],rcx
   180766876:	e8 d5 4b 93 ff       	call   0x18009b450
   18076687b:	90                   	nop
   18076687c:	48 8b 4d e0          	mov    rcx,QWORD PTR [rbp-0x20]
   180766880:	c6 81 40 01 00 00 00 	mov    BYTE PTR [rcx+0x140],0x0
   180766887:	48 8d 81 48 01 00 00 	lea    rax,[rcx+0x148]
   18076688e:	48 89 45 a8          	mov    QWORD PTR [rbp-0x58],rax
   180766892:	0f 11 b1 48 01 00 00 	movups XMMWORD PTR [rcx+0x148],xmm6
   180766899:	48 c7 81 58 01 00 00 	mov    QWORD PTR [rcx+0x158],0x0
   1807668a0:	00 00 00 00 
   1807668a4:	48 c7 81 60 01 00 00 	mov    QWORD PTR [rcx+0x160],0xf
   1807668ab:	0f 00 00 00 
   1807668af:	48 81 c1 68 01 00 00 	add    rcx,0x168
   1807668b6:	48 89 4d b0          	mov    QWORD PTR [rbp-0x50],rcx
   1807668ba:	e8 91 4b 93 ff       	call   0x18009b450
   1807668bf:	90                   	nop
   1807668c0:	48 8b 55 e0          	mov    rdx,QWORD PTR [rbp-0x20]
   1807668c4:	48 8d 82 88 01 00 00 	lea    rax,[rdx+0x188]
   1807668cb:	48 89 45 b8          	mov    QWORD PTR [rbp-0x48],rax
   1807668cf:	0f 11 b2 88 01 00 00 	movups XMMWORD PTR [rdx+0x188],xmm6
   1807668d6:	48 c7 82 98 01 00 00 	mov    QWORD PTR [rdx+0x198],0x0
   1807668dd:	00 00 00 00 
   1807668e1:	48 c7 82 a0 01 00 00 	mov    QWORD PTR [rdx+0x1a0],0xf
   1807668e8:	0f 00 00 00 
   1807668ec:	48 8d 82 a8 01 00 00 	lea    rax,[rdx+0x1a8]
   1807668f3:	48 89 45 c0          	mov    QWORD PTR [rbp-0x40],rax
   1807668f7:	0f 11 b2 a8 01 00 00 	movups XMMWORD PTR [rdx+0x1a8],xmm6
   1807668fe:	48 c7 82 b8 01 00 00 	mov    QWORD PTR [rdx+0x1b8],0x0
   180766905:	00 00 00 00 
   180766909:	48 c7 82 c0 01 00 00 	mov    QWORD PTR [rdx+0x1c0],0xf
   180766910:	0f 00 00 00 
   180766914:	48 8d 82 d0 01 00 00 	lea    rax,[rdx+0x1d0]
   18076691b:	48 89 45 c8          	mov    QWORD PTR [rbp-0x38],rax
   18076691f:	0f 11 b2 c8 01 00 00 	movups XMMWORD PTR [rdx+0x1c8],xmm6
   180766926:	0f 11 b2 d8 01 00 00 	movups XMMWORD PTR [rdx+0x1d8],xmm6
   18076692d:	48 c7 82 e8 01 00 00 	mov    QWORD PTR [rdx+0x1e8],0xf
   180766934:	0f 00 00 00 
   180766938:	48 8d 8a f0 01 00 00 	lea    rcx,[rdx+0x1f0]
   18076693f:	48 8d 82 48 02 00 00 	lea    rax,[rdx+0x248]
   180766946:	48 89 45 d0          	mov    QWORD PTR [rbp-0x30],rax
   18076694a:	48 8d ba 90 06 00 00 	lea    rdi,[rdx+0x690]
   180766951:	41 b8 08 05 00 00    	mov    r8d,0x508
   180766957:	48 89 4d d8          	mov    QWORD PTR [rbp-0x28],rcx
   18076695b:	31 d2                	xor    edx,edx
   18076695d:	e8 8e dd dd 06       	call   0x1875446f0
   180766962:	90                   	nop
   180766963:	48 89 f9             	mov    rcx,rdi
   180766966:	e8 e5 92 2f 01       	call   0x181a5fc50
   18076696b:	90                   	nop
   18076696c:	4c 8b 75 e0          	mov    r14,QWORD PTR [rbp-0x20]
   180766970:	41 0f 11 b6 08 07 00 	movups XMMWORD PTR [r14+0x708],xmm6
   180766977:	00 
   180766978:	41 0f 11 b6 f8 06 00 	movups XMMWORD PTR [r14+0x6f8],xmm6
   18076697f:	00 
   180766980:	48 8b 7e 10          	mov    rdi,QWORD PTR [rsi+0x10]
   180766984:	48 83 7e 18 10       	cmp    QWORD PTR [rsi+0x18],0x10
   180766989:	72 03                	jb     0x18076698e
   18076698b:	48 8b 36             	mov    rsi,QWORD PTR [rsi]
   18076698e:	48 85 ff             	test   rdi,rdi
   180766991:	0f 88 fa 00 00 00    	js     0x180766a91
   180766997:	48 83 ff 0f          	cmp    rdi,0xf
   18076699b:	77 21                	ja     0x1807669be
   18076699d:	49 8d 86 f8 06 00 00 	lea    rax,[r14+0x6f8]
   1807669a4:	49 89 be 08 07 00 00 	mov    QWORD PTR [r14+0x708],rdi
   1807669ab:	49 c7 86 10 07 00 00 	mov    QWORD PTR [r14+0x710],0xf
   1807669b2:	0f 00 00 00 
   1807669b6:	0f 10 06             	movups xmm0,XMMWORD PTR [rsi]
   1807669b9:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   1807669bc:	eb 74                	jmp    0x180766a32
   1807669be:	48 89 f8             	mov    rax,rdi
   1807669c1:	48 83 c8 0f          	or     rax,0xf
   1807669c5:	48 83 f8 17          	cmp    rax,0x17
   1807669c9:	bb 16 00 00 00       	mov    ebx,0x16
   1807669ce:	48 0f 43 d8          	cmovae rbx,rax
   1807669d2:	48 3d ff 0f 00 00    	cmp    rax,0xfff
   1807669d8:	72 24                	jb     0x1807669fe
   1807669da:	48 8d 4b 28          	lea    rcx,[rbx+0x28]
   1807669de:	e8 b9 4e d4 06       	call   0x1874ab89c
   1807669e3:	90                   	nop
   1807669e4:	48 85 c0             	test   rax,rax
   1807669e7:	0f 84 aa 00 00 00    	je     0x180766a97
   1807669ed:	48 89 c1             	mov    rcx,rax
   1807669f0:	48 83 c0 27          	add    rax,0x27
   1807669f4:	48 83 e0 e0          	and    rax,0xffffffffffffffe0
   1807669f8:	48 89 48 f8          	mov    QWORD PTR [rax-0x8],rcx
   1807669fc:	eb 0a                	jmp    0x180766a08
   1807669fe:	48 8d 4b 01          	lea    rcx,[rbx+0x1]
   180766a02:	e8 95 4e d4 06       	call   0x1874ab89c
   180766a07:	90                   	nop
   180766a08:	4c 8b 75 e0          	mov    r14,QWORD PTR [rbp-0x20]
   180766a0c:	49 89 86 f8 06 00 00 	mov    QWORD PTR [r14+0x6f8],rax
   180766a13:	49 89 be 08 07 00 00 	mov    QWORD PTR [r14+0x708],rdi
   180766a1a:	49 89 9e 10 07 00 00 	mov    QWORD PTR [r14+0x710],rbx
   180766a21:	48 ff c7             	inc    rdi
   180766a24:	48 89 c1             	mov    rcx,rax
   180766a27:	48 89 f2             	mov    rdx,rsi
   180766a2a:	49 89 f8             	mov    r8,rdi
   180766a2d:	e8 1e d6 dd 06       	call   0x187544050
   180766a32:	0f 57 c0             	xorps  xmm0,xmm0
   180766a35:	41 0f 11 86 18 07 00 	movups XMMWORD PTR [r14+0x718],xmm0
   180766a3c:	00 
   180766a3d:	49 c7 86 28 07 00 00 	mov    QWORD PTR [r14+0x728],0x0
   180766a44:	00 00 00 00 
   180766a48:	49 c7 86 30 07 00 00 	mov    QWORD PTR [r14+0x730],0xf
   180766a4f:	0f 00 00 00 
   180766a53:	41 0f 11 86 38 07 00 	movups XMMWORD PTR [r14+0x738],xmm0
   180766a5a:	00 
   180766a5b:	49 c7 86 48 07 00 00 	mov    QWORD PTR [r14+0x748],0x0
   180766a62:	00 00 00 00 
   180766a66:	49 c7 86 50 07 00 00 	mov    QWORD PTR [r14+0x750],0xf
   180766a6d:	0f 00 00 00 
   180766a71:	41 c7 86 9c 00 00 00 	mov    DWORD PTR [r14+0x9c],0x1
   180766a78:	01 00 00 00 
   180766a7c:	4c 89 f0             	mov    rax,r14
   180766a7f:	0f 28 75 f0          	movaps xmm6,XMMWORD PTR [rbp-0x10]
   180766a83:	48 81 c4 80 00 00 00 	add    rsp,0x80
   180766a8a:	5b                   	pop    rbx
   180766a8b:	5f                   	pop    rdi
   180766a8c:	5e                   	pop    rsi
   180766a8d:	41 5e                	pop    r14
   180766a8f:	5d                   	pop    rbp
   180766a90:	c3                   	ret
   180766a91:	e8 fa 20 8a ff       	call   0x180008b90
   180766a96:	90                   	nop
   180766a97:	e8 f0 68 da 06       	call   0x18750d38c
   180766a9c:	cc                   	int3
