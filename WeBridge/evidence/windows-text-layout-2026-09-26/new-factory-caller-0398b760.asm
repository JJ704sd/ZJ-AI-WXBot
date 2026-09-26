
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

000000018398b760 <.text+0x398a760>:
   18398b760:	55                   	push   rbp
   18398b761:	41 57                	push   r15
   18398b763:	41 56                	push   r14
   18398b765:	41 55                	push   r13
   18398b767:	41 54                	push   r12
   18398b769:	56                   	push   rsi
   18398b76a:	57                   	push   rdi
   18398b76b:	53                   	push   rbx
   18398b76c:	48 81 ec 18 02 00 00 	sub    rsp,0x218
   18398b773:	48 8d ac 24 80 00 00 	lea    rbp,[rsp+0x80]
   18398b77a:	00 
   18398b77b:	0f 29 b5 80 01 00 00 	movaps XMMWORD PTR [rbp+0x180],xmm6
   18398b782:	48 c7 85 78 01 00 00 	mov    QWORD PTR [rbp+0x178],0xfffffffffffffffe
   18398b789:	fe ff ff ff 
   18398b78d:	4d 89 ce             	mov    r14,r9
   18398b790:	4c 89 c6             	mov    rsi,r8
   18398b793:	48 89 4d 10          	mov    QWORD PTR [rbp+0x10],rcx
   18398b797:	48 b8 aa aa aa aa aa 	movabs rax,0xaaaaaaaaaaaaaaaa
   18398b79e:	aa aa aa 
   18398b7a1:	48 89 02             	mov    QWORD PTR [rdx],rax
   18398b7a4:	c6 02 00             	mov    BYTE PTR [rdx],0x0
   18398b7a7:	0f 57 c0             	xorps  xmm0,xmm0
   18398b7aa:	0f 11 42 08          	movups XMMWORD PTR [rdx+0x8],xmm0
   18398b7ae:	48 c7 42 18 00 00 00 	mov    QWORD PTR [rdx+0x18],0x0
   18398b7b5:	00 
   18398b7b6:	48 c7 42 20 0f 00 00 	mov    QWORD PTR [rdx+0x20],0xf
   18398b7bd:	00 
   18398b7be:	0f 11 42 28          	movups XMMWORD PTR [rdx+0x28],xmm0
   18398b7c2:	0f 11 42 38          	movups XMMWORD PTR [rdx+0x38],xmm0
   18398b7c6:	48 89 95 48 01 00 00 	mov    QWORD PTR [rbp+0x148],rdx
   18398b7cd:	48 c7 42 48 0f 00 00 	mov    QWORD PTR [rdx+0x48],0xf
   18398b7d4:	00 
   18398b7d5:	0f 28 35 d4 a3 3b 05 	movaps xmm6,XMMWORD PTR [rip+0x53ba3d4]        # 0x188d45bb0
   18398b7dc:	0f 29 b5 90 00 00 00 	movaps XMMWORD PTR [rbp+0x90],xmm6
   18398b7e3:	0f 29 b5 80 00 00 00 	movaps XMMWORD PTR [rbp+0x80],xmm6
   18398b7ea:	0f 29 75 70          	movaps XMMWORD PTR [rbp+0x70],xmm6
   18398b7ee:	0f 29 75 60          	movaps XMMWORD PTR [rbp+0x60],xmm6
   18398b7f2:	48 8d 4d 60          	lea    rcx,[rbp+0x60]
   18398b7f6:	e8 55 77 0e 02       	call   0x185a72f50
   18398b7fb:	90                   	nop
   18398b7fc:	0f 29 75 50          	movaps XMMWORD PTR [rbp+0x50],xmm6
   18398b800:	0f 29 75 40          	movaps XMMWORD PTR [rbp+0x40],xmm6
   18398b804:	e8 b7 97 02 fd       	call   0x1809b4fc0
   18398b809:	90                   	nop
   18398b80a:	48 89 c1             	mov    rcx,rax
   18398b80d:	48 8b 85 48 01 00 00 	mov    rax,QWORD PTR [rbp+0x148]
   18398b814:	4c 8d 50 08          	lea    r10,[rax+0x8]
   18398b818:	4c 8d 58 28          	lea    r11,[rax+0x28]
   18398b81c:	49 8d 46 50          	lea    rax,[r14+0x50]
   18398b820:	48 89 45 18          	mov    QWORD PTR [rbp+0x18],rax
   18398b824:	4c 8d bd c5 00 00 00 	lea    r15,[rbp+0xc5]
   18398b82b:	48 b8 aa aa aa aa aa 	movabs rax,0xaaaaaaaaaaaaaaaa
   18398b832:	aa aa aa 
   18398b835:	48 89 85 bd 00 00 00 	mov    QWORD PTR [rbp+0xbd],rax
   18398b83c:	0f 29 b5 b0 00 00 00 	movaps XMMWORD PTR [rbp+0xb0],xmm6
   18398b843:	31 db                	xor    ebx,ebx
   18398b845:	49 b8 cd cc cc cc cc 	movabs r8,0xcccccccccccccccd
   18398b84c:	cc cc cc 
   18398b84f:	90                   	nop
   18398b850:	48 89 c8             	mov    rax,rcx
   18398b853:	49 f7 e0             	mul    r8
   18398b856:	48 c1 ea 03          	shr    rdx,0x3
   18398b85a:	8d 04 12             	lea    eax,[rdx+rdx*1]
   18398b85d:	8d 04 80             	lea    eax,[rax+rax*4]
   18398b860:	41 89 c9             	mov    r9d,ecx
   18398b863:	41 29 c1             	sub    r9d,eax
   18398b866:	41 80 c9 30          	or     r9b,0x30
   18398b86a:	45 88 4f ff          	mov    BYTE PTR [r15-0x1],r9b
   18398b86e:	49 ff cf             	dec    r15
   18398b871:	48 ff c3             	inc    rbx
   18398b874:	48 83 f9 09          	cmp    rcx,0x9
   18398b878:	48 89 d1             	mov    rcx,rdx
   18398b87b:	77 d3                	ja     0x18398b850
   18398b87d:	0f 57 c0             	xorps  xmm0,xmm0
   18398b880:	0f 29 85 f0 00 00 00 	movaps XMMWORD PTR [rbp+0xf0],xmm0
   18398b887:	48 85 db             	test   rbx,rbx
   18398b88a:	0f 88 a2 0c 00 00    	js     0x18398c532
   18398b890:	4c 89 5d 28          	mov    QWORD PTR [rbp+0x28],r11
   18398b894:	4c 89 55 20          	mov    QWORD PTR [rbp+0x20],r10
   18398b898:	48 83 fb 10          	cmp    rbx,0x10
   18398b89c:	73 0e                	jae    0x18398b8ac
   18398b89e:	4c 8d a5 f0 00 00 00 	lea    r12,[rbp+0xf0]
   18398b8a5:	bf 0f 00 00 00       	mov    edi,0xf
   18398b8aa:	eb 58                	jmp    0x18398b904
   18398b8ac:	48 89 d8             	mov    rax,rbx
   18398b8af:	48 83 c8 0f          	or     rax,0xf
   18398b8b3:	48 83 f8 17          	cmp    rax,0x17
   18398b8b7:	bf 16 00 00 00       	mov    edi,0x16
   18398b8bc:	48 0f 43 f8          	cmovae rdi,rax
   18398b8c0:	48 3d ff 0f 00 00    	cmp    rax,0xfff
   18398b8c6:	72 28                	jb     0x18398b8f0
   18398b8c8:	48 8d 4f 28          	lea    rcx,[rdi+0x28]
   18398b8cc:	e8 cb ff b1 03       	call   0x1874ab89c
   18398b8d1:	90                   	nop
   18398b8d2:	49 89 c4             	mov    r12,rax
   18398b8d5:	48 85 c0             	test   rax,rax
   18398b8d8:	0f 84 4e 0c 00 00    	je     0x18398c52c
   18398b8de:	4c 89 e0             	mov    rax,r12
   18398b8e1:	49 83 c4 27          	add    r12,0x27
   18398b8e5:	49 83 e4 e0          	and    r12,0xffffffffffffffe0
   18398b8e9:	49 89 44 24 f8       	mov    QWORD PTR [r12-0x8],rax
   18398b8ee:	eb 0d                	jmp    0x18398b8fd
   18398b8f0:	48 8d 4f 01          	lea    rcx,[rdi+0x1]
   18398b8f4:	e8 a3 ff b1 03       	call   0x1874ab89c
   18398b8f9:	90                   	nop
   18398b8fa:	49 89 c4             	mov    r12,rax
   18398b8fd:	4c 89 a5 f0 00 00 00 	mov    QWORD PTR [rbp+0xf0],r12
   18398b904:	48 89 9d 00 01 00 00 	mov    QWORD PTR [rbp+0x100],rbx
   18398b90b:	48 89 bd 08 01 00 00 	mov    QWORD PTR [rbp+0x108],rdi
   18398b912:	4c 89 e1             	mov    rcx,r12
   18398b915:	4c 89 fa             	mov    rdx,r15
   18398b918:	49 89 d8             	mov    r8,rbx
   18398b91b:	e8 30 87 bb 03       	call   0x187544050
   18398b920:	41 c6 04 1c 00       	mov    BYTE PTR [r12+rbx*1],0x0
   18398b925:	48 8d 9d 50 01 00 00 	lea    rbx,[rbp+0x150]
   18398b92c:	4c 89 f1             	mov    rcx,r14
   18398b92f:	48 89 da             	mov    rdx,rbx
   18398b932:	e8 79 cb 08 fd       	call   0x180a184b0
   18398b937:	90                   	nop
   18398b938:	48 8b 85 60 01 00 00 	mov    rax,QWORD PTR [rbp+0x160]
   18398b93f:	48 8b 8d 68 01 00 00 	mov    rcx,QWORD PTR [rbp+0x168]
   18398b946:	48 39 c1             	cmp    rcx,rax
   18398b949:	75 27                	jne    0x18398b972
   18398b94b:	48 c7 44 24 20 01 00 	mov    QWORD PTR [rsp+0x20],0x1
   18398b952:	00 00 
   18398b954:	4c 8d 0d c9 b8 46 05 	lea    r9,[rip+0x546b8c9]        # 0x188df7224
   18398b95b:	48 8d 8d 50 01 00 00 	lea    rcx,[rbp+0x150]
   18398b962:	ba 01 00 00 00       	mov    edx,0x1
   18398b967:	e8 54 da 67 fc       	call   0x1800093c0
   18398b96c:	90                   	nop
   18398b96d:	48 89 c3             	mov    rbx,rax
   18398b970:	eb 21                	jmp    0x18398b993
   18398b972:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18398b976:	48 89 95 60 01 00 00 	mov    QWORD PTR [rbp+0x160],rdx
   18398b97d:	48 89 da             	mov    rdx,rbx
   18398b980:	48 83 f9 10          	cmp    rcx,0x10
   18398b984:	72 07                	jb     0x18398b98d
   18398b986:	48 8b 95 50 01 00 00 	mov    rdx,QWORD PTR [rbp+0x150]
   18398b98d:	66 c7 04 02 5f 00    	mov    WORD PTR [rdx+rax*1],0x5f
   18398b993:	0f 10 03             	movups xmm0,XMMWORD PTR [rbx]
   18398b996:	0f 10 4b 10          	movups xmm1,XMMWORD PTR [rbx+0x10]
   18398b99a:	0f 29 8d c0 00 00 00 	movaps XMMWORD PTR [rbp+0xc0],xmm1
   18398b9a1:	0f 29 85 b0 00 00 00 	movaps XMMWORD PTR [rbp+0xb0],xmm0
   18398b9a8:	48 c7 43 10 00 00 00 	mov    QWORD PTR [rbx+0x10],0x0
   18398b9af:	00 
   18398b9b0:	48 c7 43 18 0f 00 00 	mov    QWORD PTR [rbx+0x18],0xf
   18398b9b7:	00 
   18398b9b8:	c6 03 00             	mov    BYTE PTR [rbx],0x0
   18398b9bb:	4c 8d 7d 40          	lea    r15,[rbp+0x40]
   18398b9bf:	4c 8d 85 b0 00 00 00 	lea    r8,[rbp+0xb0]
   18398b9c6:	48 8d bd f0 00 00 00 	lea    rdi,[rbp+0xf0]
   18398b9cd:	4c 89 f9             	mov    rcx,r15
   18398b9d0:	49 89 f9             	mov    r9,rdi
   18398b9d3:	e8 f8 88 6f fc       	call   0x1800842d0
   18398b9d8:	90                   	nop
   18398b9d9:	48 8b 85 c8 00 00 00 	mov    rax,QWORD PTR [rbp+0xc8]
   18398b9e0:	48 83 f8 10          	cmp    rax,0x10
   18398b9e4:	72 38                	jb     0x18398ba1e
   18398b9e6:	48 8b 8d b0 00 00 00 	mov    rcx,QWORD PTR [rbp+0xb0]
   18398b9ed:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18398b9f1:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18398b9f8:	72 1f                	jb     0x18398ba19
   18398b9fa:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18398b9fe:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18398ba02:	4c 29 c1             	sub    rcx,r8
   18398ba05:	48 83 f9 20          	cmp    rcx,0x20
   18398ba09:	0f 83 1d 0b 00 00    	jae    0x18398c52c
   18398ba0f:	48 83 c0 28          	add    rax,0x28
   18398ba13:	48 89 c2             	mov    rdx,rax
   18398ba16:	4c 89 c1             	mov    rcx,r8
   18398ba19:	e8 c2 fe b1 03       	call   0x1874ab8e0
   18398ba1e:	48 8b 85 68 01 00 00 	mov    rax,QWORD PTR [rbp+0x168]
   18398ba25:	48 83 f8 10          	cmp    rax,0x10
   18398ba29:	72 38                	jb     0x18398ba63
   18398ba2b:	48 8b 8d 50 01 00 00 	mov    rcx,QWORD PTR [rbp+0x150]
   18398ba32:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18398ba36:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18398ba3d:	72 1f                	jb     0x18398ba5e
   18398ba3f:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18398ba43:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18398ba47:	4c 29 c1             	sub    rcx,r8
   18398ba4a:	48 83 f9 20          	cmp    rcx,0x20
   18398ba4e:	0f 83 d8 0a 00 00    	jae    0x18398c52c
   18398ba54:	48 83 c0 28          	add    rax,0x28
   18398ba58:	48 89 c2             	mov    rdx,rax
   18398ba5b:	4c 89 c1             	mov    rcx,r8
   18398ba5e:	e8 7d fe b1 03       	call   0x1874ab8e0
   18398ba63:	48 8b 85 08 01 00 00 	mov    rax,QWORD PTR [rbp+0x108]
   18398ba6a:	48 83 f8 10          	cmp    rax,0x10
   18398ba6e:	72 39                	jb     0x18398baa9
   18398ba70:	48 8b 8d f0 00 00 00 	mov    rcx,QWORD PTR [rbp+0xf0]
   18398ba77:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18398ba7b:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18398ba82:	72 1f                	jb     0x18398baa3
   18398ba84:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18398ba88:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18398ba8c:	4c 29 c1             	sub    rcx,r8
   18398ba8f:	48 83 f9 20          	cmp    rcx,0x20
   18398ba93:	0f 83 93 0a 00 00    	jae    0x18398c52c
   18398ba99:	48 83 c0 28          	add    rax,0x28
   18398ba9d:	48 89 c2             	mov    rdx,rax
   18398baa0:	4c 89 c1             	mov    rcx,r8
   18398baa3:	e8 38 fe b1 03       	call   0x1874ab8e0
   18398baa8:	90                   	nop
   18398baa9:	e8 62 a2 6b fc       	call   0x180045d10
   18398baae:	90                   	nop
   18398baaf:	48 8b 10             	mov    rdx,QWORD PTR [rax]
   18398bab2:	48 89 c1             	mov    rcx,rax
   18398bab5:	ff 52 20             	call   QWORD PTR [rdx+0x20]
   18398bab8:	90                   	nop
   18398bab9:	49 89 c4             	mov    r12,rax
   18398babc:	80 8d 98 00 00 00 02 	or     BYTE PTR [rbp+0x98],0x2
   18398bac3:	48 8b 45 70          	mov    rax,QWORD PTR [rbp+0x70]
   18398bac7:	48 8d 1d 12 b3 f8 07 	lea    rbx,[rip+0x7f8b312]        # 0x18b916de0
   18398bace:	48 39 d8             	cmp    rax,rbx
   18398bad1:	74 0e                	je     0x18398bae1
   18398bad3:	4c 39 e0             	cmp    rax,r12
   18398bad6:	48 89 bd a8 00 00 00 	mov    QWORD PTR [rbp+0xa8],rdi
   18398badd:	75 33                	jne    0x18398bb12
   18398badf:	eb 5a                	jmp    0x18398bb3b
   18398bae1:	b9 20 00 00 00       	mov    ecx,0x20
   18398bae6:	e8 b1 fd b1 03       	call   0x1874ab89c
   18398baeb:	90                   	nop
   18398baec:	0f 57 c0             	xorps  xmm0,xmm0
   18398baef:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   18398baf2:	48 c7 40 10 00 00 00 	mov    QWORD PTR [rax+0x10],0x0
   18398baf9:	00 
   18398bafa:	48 c7 40 18 0f 00 00 	mov    QWORD PTR [rax+0x18],0xf
   18398bb01:	00 
   18398bb02:	48 89 45 70          	mov    QWORD PTR [rbp+0x70],rax
   18398bb06:	4c 39 e0             	cmp    rax,r12
   18398bb09:	48 89 bd a8 00 00 00 	mov    QWORD PTR [rbp+0xa8],rdi
   18398bb10:	74 29                	je     0x18398bb3b
   18398bb12:	4d 8b 6c 24 10       	mov    r13,QWORD PTR [r12+0x10]
   18398bb17:	49 83 7c 24 18 10    	cmp    QWORD PTR [r12+0x18],0x10
   18398bb1d:	72 04                	jb     0x18398bb23
   18398bb1f:	4d 8b 24 24          	mov    r12,QWORD PTR [r12]
   18398bb23:	48 8b 48 18          	mov    rcx,QWORD PTR [rax+0x18]
   18398bb27:	49 39 cd             	cmp    r13,rcx
   18398bb2a:	76 30                	jbe    0x18398bb5c
   18398bb2c:	48 89 c1             	mov    rcx,rax
   18398bb2f:	4c 89 ea             	mov    rdx,r13
   18398bb32:	4d 89 e1             	mov    r9,r12
   18398bb35:	e8 16 26 6b fc       	call   0x18003e150
   18398bb3a:	90                   	nop
   18398bb3b:	80 8d 98 00 00 00 08 	or     BYTE PTR [rbp+0x98],0x8
   18398bb42:	48 8b 85 80 00 00 00 	mov    rax,QWORD PTR [rbp+0x80]
   18398bb49:	48 39 d8             	cmp    rax,rbx
   18398bb4c:	74 4b                	je     0x18398bb99
   18398bb4e:	49 8d 4e 50          	lea    rcx,[r14+0x50]
   18398bb52:	48 39 c8             	cmp    rax,rcx
   18398bb55:	75 73                	jne    0x18398bbca
   18398bb57:	e9 96 00 00 00       	jmp    0x18398bbf2
   18398bb5c:	48 89 c7             	mov    rdi,rax
   18398bb5f:	48 83 f9 10          	cmp    rcx,0x10
   18398bb63:	72 03                	jb     0x18398bb68
   18398bb65:	48 8b 38             	mov    rdi,QWORD PTR [rax]
   18398bb68:	4c 89 68 10          	mov    QWORD PTR [rax+0x10],r13
   18398bb6c:	48 89 f9             	mov    rcx,rdi
   18398bb6f:	4c 89 e2             	mov    rdx,r12
   18398bb72:	4d 89 e8             	mov    r8,r13
   18398bb75:	e8 d6 84 bb 03       	call   0x187544050
   18398bb7a:	42 c6 04 2f 00       	mov    BYTE PTR [rdi+r13*1],0x0
   18398bb7f:	48 8d bd f0 00 00 00 	lea    rdi,[rbp+0xf0]
   18398bb86:	80 8d 98 00 00 00 08 	or     BYTE PTR [rbp+0x98],0x8
   18398bb8d:	48 8b 85 80 00 00 00 	mov    rax,QWORD PTR [rbp+0x80]
   18398bb94:	48 39 d8             	cmp    rax,rbx
   18398bb97:	75 b5                	jne    0x18398bb4e
   18398bb99:	b9 20 00 00 00       	mov    ecx,0x20
   18398bb9e:	e8 f9 fc b1 03       	call   0x1874ab89c
   18398bba3:	90                   	nop
   18398bba4:	0f 57 c0             	xorps  xmm0,xmm0
   18398bba7:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   18398bbaa:	48 c7 40 10 00 00 00 	mov    QWORD PTR [rax+0x10],0x0
   18398bbb1:	00 
   18398bbb2:	48 c7 40 18 0f 00 00 	mov    QWORD PTR [rax+0x18],0xf
   18398bbb9:	00 
   18398bbba:	48 89 85 80 00 00 00 	mov    QWORD PTR [rbp+0x80],rax
   18398bbc1:	49 8d 4e 50          	lea    rcx,[r14+0x50]
   18398bbc5:	48 39 c8             	cmp    rax,rcx
   18398bbc8:	74 28                	je     0x18398bbf2
   18398bbca:	4d 8b 66 60          	mov    r12,QWORD PTR [r14+0x60]
   18398bbce:	49 83 7e 68 10       	cmp    QWORD PTR [r14+0x68],0x10
   18398bbd3:	4d 8d 4e 50          	lea    r9,[r14+0x50]
   18398bbd7:	72 04                	jb     0x18398bbdd
   18398bbd9:	4d 8b 4e 50          	mov    r9,QWORD PTR [r14+0x50]
   18398bbdd:	48 8b 48 18          	mov    rcx,QWORD PTR [rax+0x18]
   18398bbe1:	49 39 cc             	cmp    r12,rcx
   18398bbe4:	76 26                	jbe    0x18398bc0c
   18398bbe6:	48 89 c1             	mov    rcx,rax
   18398bbe9:	4c 89 e2             	mov    rdx,r12
   18398bbec:	e8 5f 25 6b fc       	call   0x18003e150
   18398bbf1:	90                   	nop
   18398bbf2:	80 8d 98 00 00 00 04 	or     BYTE PTR [rbp+0x98],0x4
   18398bbf9:	48 8b 45 78          	mov    rax,QWORD PTR [rbp+0x78]
   18398bbfd:	48 39 d8             	cmp    rax,rbx
   18398bc00:	74 44                	je     0x18398bc46
   18398bc02:	48 39 f0             	cmp    rax,rsi
   18398bc05:	75 69                	jne    0x18398bc70
   18398bc07:	e9 8e 00 00 00       	jmp    0x18398bc9a
   18398bc0c:	48 89 c7             	mov    rdi,rax
   18398bc0f:	48 83 f9 10          	cmp    rcx,0x10
   18398bc13:	72 03                	jb     0x18398bc18
   18398bc15:	48 8b 38             	mov    rdi,QWORD PTR [rax]
   18398bc18:	4c 89 60 10          	mov    QWORD PTR [rax+0x10],r12
   18398bc1c:	48 89 f9             	mov    rcx,rdi
   18398bc1f:	4c 89 ca             	mov    rdx,r9
   18398bc22:	4d 89 e0             	mov    r8,r12
   18398bc25:	e8 26 84 bb 03       	call   0x187544050
   18398bc2a:	42 c6 04 27 00       	mov    BYTE PTR [rdi+r12*1],0x0
   18398bc2f:	48 8d bd f0 00 00 00 	lea    rdi,[rbp+0xf0]
   18398bc36:	80 8d 98 00 00 00 04 	or     BYTE PTR [rbp+0x98],0x4
   18398bc3d:	48 8b 45 78          	mov    rax,QWORD PTR [rbp+0x78]
   18398bc41:	48 39 d8             	cmp    rax,rbx
   18398bc44:	75 bc                	jne    0x18398bc02
   18398bc46:	b9 20 00 00 00       	mov    ecx,0x20
   18398bc4b:	e8 4c fc b1 03       	call   0x1874ab89c
   18398bc50:	90                   	nop
   18398bc51:	0f 57 c0             	xorps  xmm0,xmm0
   18398bc54:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   18398bc57:	48 c7 40 10 00 00 00 	mov    QWORD PTR [rax+0x10],0x0
   18398bc5e:	00 
   18398bc5f:	48 c7 40 18 0f 00 00 	mov    QWORD PTR [rax+0x18],0xf
   18398bc66:	00 
   18398bc67:	48 89 45 78          	mov    QWORD PTR [rbp+0x78],rax
   18398bc6b:	48 39 f0             	cmp    rax,rsi
   18398bc6e:	74 2a                	je     0x18398bc9a
   18398bc70:	4c 8b 76 10          	mov    r14,QWORD PTR [rsi+0x10]
   18398bc74:	48 83 7e 18 10       	cmp    QWORD PTR [rsi+0x18],0x10
   18398bc79:	49 89 f1             	mov    r9,rsi
   18398bc7c:	72 03                	jb     0x18398bc81
   18398bc7e:	4c 8b 0e             	mov    r9,QWORD PTR [rsi]
   18398bc81:	48 8b 48 18          	mov    rcx,QWORD PTR [rax+0x18]
   18398bc85:	49 39 ce             	cmp    r14,rcx
   18398bc88:	0f 86 7a 03 00 00    	jbe    0x18398c008
   18398bc8e:	48 89 c1             	mov    rcx,rax
   18398bc91:	4c 89 f2             	mov    rdx,r14
   18398bc94:	e8 b7 24 6b fc       	call   0x18003e150
   18398bc99:	90                   	nop
   18398bc9a:	80 8d 98 00 00 00 10 	or     BYTE PTR [rbp+0x98],0x10
   18398bca1:	48 8b 8d 88 00 00 00 	mov    rcx,QWORD PTR [rbp+0x88]
   18398bca8:	48 39 d9             	cmp    rcx,rbx
   18398bcab:	0f 84 98 03 00 00    	je     0x18398c049
   18398bcb1:	4c 39 f9             	cmp    rcx,r15
   18398bcb4:	74 50                	je     0x18398bd06
   18398bcb6:	48 8b 41 18          	mov    rax,QWORD PTR [rcx+0x18]
   18398bcba:	4c 8b 75 50          	mov    r14,QWORD PTR [rbp+0x50]
   18398bcbe:	48 83 7d 58 10       	cmp    QWORD PTR [rbp+0x58],0x10
   18398bcc3:	72 04                	jb     0x18398bcc9
   18398bcc5:	4c 8b 7d 40          	mov    r15,QWORD PTR [rbp+0x40]
   18398bcc9:	49 39 c6             	cmp    r14,rax
   18398bccc:	76 0e                	jbe    0x18398bcdc
   18398bcce:	4c 89 f2             	mov    rdx,r14
   18398bcd1:	4d 89 f9             	mov    r9,r15
   18398bcd4:	e8 77 24 6b fc       	call   0x18003e150
   18398bcd9:	90                   	nop
   18398bcda:	eb 2a                	jmp    0x18398bd06
   18398bcdc:	48 89 cf             	mov    rdi,rcx
   18398bcdf:	48 83 f8 10          	cmp    rax,0x10
   18398bce3:	72 03                	jb     0x18398bce8
   18398bce5:	48 8b 39             	mov    rdi,QWORD PTR [rcx]
   18398bce8:	4c 89 71 10          	mov    QWORD PTR [rcx+0x10],r14
   18398bcec:	48 89 f9             	mov    rcx,rdi
   18398bcef:	4c 89 fa             	mov    rdx,r15
   18398bcf2:	4d 89 f0             	mov    r8,r14
   18398bcf5:	e8 56 83 bb 03       	call   0x187544050
   18398bcfa:	42 c6 04 37 00       	mov    BYTE PTR [rdi+r14*1],0x0
   18398bcff:	48 8d bd f0 00 00 00 	lea    rdi,[rbp+0xf0]
   18398bd06:	80 8d 98 00 00 00 20 	or     BYTE PTR [rbp+0x98],0x20
   18398bd0d:	c7 85 90 00 00 00 00 	mov    DWORD PTR [rbp+0x90],0x0
   18398bd14:	00 00 00 
   18398bd17:	48 b8 aa aa aa aa aa 	movabs rax,0xaaaaaaaaaaaaaaaa
   18398bd1e:	aa aa aa 
   18398bd21:	48 89 85 e0 00 00 00 	mov    QWORD PTR [rbp+0xe0],rax
   18398bd28:	0f 29 b5 d0 00 00 00 	movaps XMMWORD PTR [rbp+0xd0],xmm6
   18398bd2f:	0f 29 b5 c0 00 00 00 	movaps XMMWORD PTR [rbp+0xc0],xmm6
   18398bd36:	0f 29 b5 b0 00 00 00 	movaps XMMWORD PTR [rbp+0xb0],xmm6
   18398bd3d:	48 b8 00 00 00 00 c0 	movabs rax,0x1d4c000000000
   18398bd44:	d4 01 00 
   18398bd47:	48 89 85 f0 00 00 00 	mov    QWORD PTR [rbp+0xf0],rax
   18398bd4e:	0f 57 c0             	xorps  xmm0,xmm0
   18398bd51:	0f 11 85 f8 00 00 00 	movups XMMWORD PTR [rbp+0xf8],xmm0
   18398bd58:	48 c7 85 08 01 00 00 	mov    QWORD PTR [rbp+0x108],0x0
   18398bd5f:	00 00 00 00 
   18398bd63:	48 c7 85 10 01 00 00 	mov    QWORD PTR [rbp+0x110],0xf
   18398bd6a:	0f 00 00 00 
   18398bd6e:	c6 85 18 01 00 00 00 	mov    BYTE PTR [rbp+0x118],0x0
   18398bd75:	c7 85 1c 01 00 00 00 	mov    DWORD PTR [rbp+0x11c],0x0
   18398bd7c:	00 00 00 
   18398bd7f:	0f 29 85 50 01 00 00 	movaps XMMWORD PTR [rbp+0x150],xmm0
   18398bd86:	48 c7 85 60 01 00 00 	mov    QWORD PTR [rbp+0x160],0x0
   18398bd8d:	00 00 00 00 
   18398bd91:	48 c7 85 68 01 00 00 	mov    QWORD PTR [rbp+0x168],0xf
   18398bd98:	0f 00 00 00 
   18398bd9c:	e8 6f 9f 6b fc       	call   0x180045d10
   18398bda1:	90                   	nop
   18398bda2:	48 8b 10             	mov    rdx,QWORD PTR [rax]
   18398bda5:	48 89 c1             	mov    rcx,rax
   18398bda8:	ff 52 10             	call   QWORD PTR [rdx+0x10]
   18398bdab:	90                   	nop
   18398bdac:	48 89 7c 24 20       	mov    QWORD PTR [rsp+0x20],rdi
   18398bdb1:	48 8d 8d b0 00 00 00 	lea    rcx,[rbp+0xb0]
   18398bdb8:	4c 8d 45 60          	lea    r8,[rbp+0x60]
   18398bdbc:	4c 8d 8d 50 01 00 00 	lea    r9,[rbp+0x150]
   18398bdc3:	48 89 c2             	mov    rdx,rax
   18398bdc6:	e8 35 0b 00 00       	call   0x18398c900
   18398bdcb:	90                   	nop
   18398bdcc:	48 8b 85 68 01 00 00 	mov    rax,QWORD PTR [rbp+0x168]
   18398bdd3:	48 83 f8 10          	cmp    rax,0x10
   18398bdd7:	72 38                	jb     0x18398be11
   18398bdd9:	48 8b 8d 50 01 00 00 	mov    rcx,QWORD PTR [rbp+0x150]
   18398bde0:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18398bde4:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18398bdeb:	72 1f                	jb     0x18398be0c
   18398bded:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18398bdf1:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18398bdf5:	4c 29 c1             	sub    rcx,r8
   18398bdf8:	48 83 f9 20          	cmp    rcx,0x20
   18398bdfc:	0f 83 2a 07 00 00    	jae    0x18398c52c
   18398be02:	48 83 c0 28          	add    rax,0x28
   18398be06:	48 89 c2             	mov    rdx,rax
   18398be09:	4c 89 c1             	mov    rcx,r8
   18398be0c:	e8 cf fa b1 03       	call   0x1874ab8e0
   18398be11:	48 8b 85 10 01 00 00 	mov    rax,QWORD PTR [rbp+0x110]
   18398be18:	48 83 f8 10          	cmp    rax,0x10
   18398be1c:	72 38                	jb     0x18398be56
   18398be1e:	48 8b 8d f8 00 00 00 	mov    rcx,QWORD PTR [rbp+0xf8]
   18398be25:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18398be29:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18398be30:	72 1f                	jb     0x18398be51
   18398be32:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18398be36:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18398be3a:	4c 29 c1             	sub    rcx,r8
   18398be3d:	48 83 f9 20          	cmp    rcx,0x20
   18398be41:	0f 83 e5 06 00 00    	jae    0x18398c52c
   18398be47:	48 83 c0 28          	add    rax,0x28
   18398be4b:	48 89 c2             	mov    rdx,rax
   18398be4e:	4c 89 c1             	mov    rcx,r8
   18398be51:	e8 8a fa b1 03       	call   0x1874ab8e0
   18398be56:	8b 85 b4 00 00 00    	mov    eax,DWORD PTR [rbp+0xb4]
   18398be5c:	8b 8d b0 00 00 00    	mov    ecx,DWORD PTR [rbp+0xb0]
   18398be62:	09 c1                	or     ecx,eax
   18398be64:	0f 85 31 01 00 00    	jne    0x18398bf9b
   18398be6a:	48 8b 45 18          	mov    rax,QWORD PTR [rbp+0x18]
   18398be6e:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   18398be73:	4c 8d 85 b0 00 00 00 	lea    r8,[rbp+0xb0]
   18398be7a:	48 8b 4d 10          	mov    rcx,QWORD PTR [rbp+0x10]
   18398be7e:	48 89 fa             	mov    rdx,rdi
   18398be81:	49 89 f1             	mov    r9,rsi
   18398be84:	e8 67 19 00 00       	call   0x18398d7f0
   18398be89:	90                   	nop
   18398be8a:	0f b6 85 f0 00 00 00 	movzx  eax,BYTE PTR [rbp+0xf0]
   18398be91:	48 8b 9d 48 01 00 00 	mov    rbx,QWORD PTR [rbp+0x148]
   18398be98:	88 03                	mov    BYTE PTR [rbx],al
   18398be9a:	48 39 fb             	cmp    rbx,rdi
   18398be9d:	0f 84 ea 01 00 00    	je     0x18398c08d
   18398bea3:	48 8b 43 20          	mov    rax,QWORD PTR [rbx+0x20]
   18398bea7:	48 83 f8 10          	cmp    rax,0x10
   18398beab:	48 8b 75 20          	mov    rsi,QWORD PTR [rbp+0x20]
   18398beaf:	72 34                	jb     0x18398bee5
   18398beb1:	48 8b 0e             	mov    rcx,QWORD PTR [rsi]
   18398beb4:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18398beb8:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18398bebf:	72 1f                	jb     0x18398bee0
   18398bec1:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18398bec5:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18398bec9:	4c 29 c1             	sub    rcx,r8
   18398becc:	48 83 f9 20          	cmp    rcx,0x20
   18398bed0:	0f 83 56 06 00 00    	jae    0x18398c52c
   18398bed6:	48 83 c0 28          	add    rax,0x28
   18398beda:	48 89 c2             	mov    rdx,rax
   18398bedd:	4c 89 c1             	mov    rcx,r8
   18398bee0:	e8 fb f9 b1 03       	call   0x1874ab8e0
   18398bee5:	48 8d 85 f8 00 00 00 	lea    rax,[rbp+0xf8]
   18398beec:	0f 10 00             	movups xmm0,XMMWORD PTR [rax]
   18398beef:	0f 10 48 10          	movups xmm1,XMMWORD PTR [rax+0x10]
   18398bef3:	0f 11 4e 10          	movups XMMWORD PTR [rsi+0x10],xmm1
   18398bef7:	0f 11 06             	movups XMMWORD PTR [rsi],xmm0
   18398befa:	48 c7 85 08 01 00 00 	mov    QWORD PTR [rbp+0x108],0x0
   18398bf01:	00 00 00 00 
   18398bf05:	48 c7 85 10 01 00 00 	mov    QWORD PTR [rbp+0x110],0xf
   18398bf0c:	0f 00 00 00 
   18398bf10:	c6 85 f8 00 00 00 00 	mov    BYTE PTR [rbp+0xf8],0x0
   18398bf17:	48 8b 85 18 01 00 00 	mov    rax,QWORD PTR [rbp+0x118]
   18398bf1e:	48 89 43 28          	mov    QWORD PTR [rbx+0x28],rax
   18398bf22:	48 8d 73 30          	lea    rsi,[rbx+0x30]
   18398bf26:	48 8b 43 48          	mov    rax,QWORD PTR [rbx+0x48]
   18398bf2a:	48 83 f8 10          	cmp    rax,0x10
   18398bf2e:	72 34                	jb     0x18398bf64
   18398bf30:	48 8b 0e             	mov    rcx,QWORD PTR [rsi]
   18398bf33:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18398bf37:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18398bf3e:	72 1f                	jb     0x18398bf5f
   18398bf40:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18398bf44:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18398bf48:	4c 29 c1             	sub    rcx,r8
   18398bf4b:	48 83 f9 20          	cmp    rcx,0x20
   18398bf4f:	0f 83 d7 05 00 00    	jae    0x18398c52c
   18398bf55:	48 83 c0 28          	add    rax,0x28
   18398bf59:	48 89 c2             	mov    rdx,rax
   18398bf5c:	4c 89 c1             	mov    rcx,r8
   18398bf5f:	e8 7c f9 b1 03       	call   0x1874ab8e0
   18398bf64:	48 8d 85 20 01 00 00 	lea    rax,[rbp+0x120]
   18398bf6b:	0f 10 00             	movups xmm0,XMMWORD PTR [rax]
   18398bf6e:	0f 10 48 10          	movups xmm1,XMMWORD PTR [rax+0x10]
   18398bf72:	0f 11 4e 10          	movups XMMWORD PTR [rsi+0x10],xmm1
   18398bf76:	0f 11 06             	movups XMMWORD PTR [rsi],xmm0
   18398bf79:	48 c7 85 30 01 00 00 	mov    QWORD PTR [rbp+0x130],0x0
   18398bf80:	00 00 00 00 
   18398bf84:	48 c7 85 38 01 00 00 	mov    QWORD PTR [rbp+0x138],0xf
   18398bf8b:	0f 00 00 00 
   18398bf8f:	c6 85 20 01 00 00 00 	mov    BYTE PTR [rbp+0x120],0x0
   18398bf96:	e9 45 01 00 00       	jmp    0x18398c0e0
   18398bf9b:	83 f8 fe             	cmp    eax,0xfffffffe
   18398bf9e:	48 8b 9d 48 01 00 00 	mov    rbx,QWORD PTR [rbp+0x148]
   18398bfa5:	0f 85 a6 04 00 00    	jne    0x18398c451
   18398bfab:	0f 29 b5 50 01 00 00 	movaps XMMWORD PTR [rbp+0x150],xmm6
   18398bfb2:	48 8d 8d 50 01 00 00 	lea    rcx,[rbp+0x150]
   18398bfb9:	e8 b2 8c d6 fc       	call   0x1806f4c70
   18398bfbe:	90                   	nop
   18398bfbf:	48 8b 85 50 01 00 00 	mov    rax,QWORD PTR [rbp+0x150]
   18398bfc6:	48 8d b8 b0 00 00 00 	lea    rdi,[rax+0xb0]
   18398bfcd:	48 39 f7             	cmp    rdi,rsi
   18398bfd0:	0f 84 7b 01 00 00    	je     0x18398c151
   18398bfd6:	4c 8b 76 10          	mov    r14,QWORD PTR [rsi+0x10]
   18398bfda:	48 83 7e 18 10       	cmp    QWORD PTR [rsi+0x18],0x10
   18398bfdf:	72 03                	jb     0x18398bfe4
   18398bfe1:	48 8b 36             	mov    rsi,QWORD PTR [rsi]
   18398bfe4:	48 8b 88 c8 00 00 00 	mov    rcx,QWORD PTR [rax+0xc8]
   18398bfeb:	49 39 ce             	cmp    r14,rcx
   18398bfee:	0f 86 3a 01 00 00    	jbe    0x18398c12e
   18398bff4:	48 89 f9             	mov    rcx,rdi
   18398bff7:	4c 89 f2             	mov    rdx,r14
   18398bffa:	49 89 f1             	mov    r9,rsi
   18398bffd:	e8 4e 21 6b fc       	call   0x18003e150
   18398c002:	90                   	nop
   18398c003:	e9 49 01 00 00       	jmp    0x18398c151
   18398c008:	48 89 c7             	mov    rdi,rax
   18398c00b:	48 83 f9 10          	cmp    rcx,0x10
   18398c00f:	72 03                	jb     0x18398c014
   18398c011:	48 8b 38             	mov    rdi,QWORD PTR [rax]
   18398c014:	4c 89 70 10          	mov    QWORD PTR [rax+0x10],r14
   18398c018:	48 89 f9             	mov    rcx,rdi
   18398c01b:	4c 89 ca             	mov    rdx,r9
   18398c01e:	4d 89 f0             	mov    r8,r14
   18398c021:	e8 2a 80 bb 03       	call   0x187544050
   18398c026:	42 c6 04 37 00       	mov    BYTE PTR [rdi+r14*1],0x0
   18398c02b:	48 8d bd f0 00 00 00 	lea    rdi,[rbp+0xf0]
   18398c032:	80 8d 98 00 00 00 10 	or     BYTE PTR [rbp+0x98],0x10
   18398c039:	48 8b 8d 88 00 00 00 	mov    rcx,QWORD PTR [rbp+0x88]
   18398c040:	48 39 d9             	cmp    rcx,rbx
   18398c043:	0f 85 68 fc ff ff    	jne    0x18398bcb1
   18398c049:	b9 20 00 00 00       	mov    ecx,0x20
   18398c04e:	e8 49 f8 b1 03       	call   0x1874ab89c
   18398c053:	90                   	nop
   18398c054:	48 89 c1             	mov    rcx,rax
   18398c057:	0f 57 c0             	xorps  xmm0,xmm0
   18398c05a:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   18398c05d:	48 c7 40 10 00 00 00 	mov    QWORD PTR [rax+0x10],0x0
   18398c064:	00 
   18398c065:	48 c7 40 18 0f 00 00 	mov    QWORD PTR [rax+0x18],0xf
   18398c06c:	00 
   18398c06d:	48 89 85 88 00 00 00 	mov    QWORD PTR [rbp+0x88],rax
   18398c074:	b8 0f 00 00 00       	mov    eax,0xf
   18398c079:	4c 8b 75 50          	mov    r14,QWORD PTR [rbp+0x50]
   18398c07d:	48 83 7d 58 10       	cmp    QWORD PTR [rbp+0x58],0x10
   18398c082:	0f 83 3d fc ff ff    	jae    0x18398bcc5
   18398c088:	e9 3c fc ff ff       	jmp    0x18398bcc9
   18398c08d:	48 8b 85 18 01 00 00 	mov    rax,QWORD PTR [rbp+0x118]
   18398c094:	48 8b 4d 28          	mov    rcx,QWORD PTR [rbp+0x28]
   18398c098:	48 89 01             	mov    QWORD PTR [rcx],rax
   18398c09b:	48 8b 85 38 01 00 00 	mov    rax,QWORD PTR [rbp+0x138]
   18398c0a2:	48 83 f8 10          	cmp    rax,0x10
   18398c0a6:	72 38                	jb     0x18398c0e0
   18398c0a8:	48 8b 8d 20 01 00 00 	mov    rcx,QWORD PTR [rbp+0x120]
   18398c0af:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18398c0b3:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18398c0ba:	72 1f                	jb     0x18398c0db
   18398c0bc:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18398c0c0:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18398c0c4:	4c 29 c1             	sub    rcx,r8
   18398c0c7:	48 83 f9 20          	cmp    rcx,0x20
   18398c0cb:	0f 83 5b 04 00 00    	jae    0x18398c52c
   18398c0d1:	48 83 c0 28          	add    rax,0x28
   18398c0d5:	48 89 c2             	mov    rdx,rax
   18398c0d8:	4c 89 c1             	mov    rcx,r8
   18398c0db:	e8 00 f8 b1 03       	call   0x1874ab8e0
   18398c0e0:	48 8b 85 10 01 00 00 	mov    rax,QWORD PTR [rbp+0x110]
   18398c0e7:	48 83 f8 10          	cmp    rax,0x10
   18398c0eb:	0f 82 60 03 00 00    	jb     0x18398c451
   18398c0f1:	48 8b 8d f8 00 00 00 	mov    rcx,QWORD PTR [rbp+0xf8]
   18398c0f8:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18398c0fc:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18398c103:	72 1f                	jb     0x18398c124
   18398c105:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18398c109:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18398c10d:	4c 29 c1             	sub    rcx,r8
   18398c110:	48 83 f9 20          	cmp    rcx,0x20
   18398c114:	0f 83 12 04 00 00    	jae    0x18398c52c
   18398c11a:	48 83 c0 28          	add    rax,0x28
   18398c11e:	48 89 c2             	mov    rdx,rax
   18398c121:	4c 89 c1             	mov    rcx,r8
   18398c124:	e8 b7 f7 b1 03       	call   0x1874ab8e0
   18398c129:	e9 23 03 00 00       	jmp    0x18398c451
   18398c12e:	48 83 f9 10          	cmp    rcx,0x10
   18398c132:	72 03                	jb     0x18398c137
   18398c134:	48 8b 3f             	mov    rdi,QWORD PTR [rdi]
   18398c137:	4c 89 b0 c0 00 00 00 	mov    QWORD PTR [rax+0xc0],r14
   18398c13e:	48 89 f9             	mov    rcx,rdi
   18398c141:	48 89 f2             	mov    rdx,rsi
   18398c144:	4d 89 f0             	mov    r8,r14
   18398c147:	e8 04 7f bb 03       	call   0x187544050
   18398c14c:	42 c6 04 37 00       	mov    BYTE PTR [rdi+r14*1],0x0
   18398c151:	48 8b 85 50 01 00 00 	mov    rax,QWORD PTR [rbp+0x150]
   18398c158:	c7 80 18 01 00 00 10 	mov    DWORD PTR [rax+0x118],0x2710
   18398c15f:	27 00 00 
   18398c162:	0f 29 b5 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm6
   18398c169:	0f 29 b5 f0 00 00 00 	movaps XMMWORD PTR [rbp+0xf0],xmm6
   18398c170:	e8 6b 2c 73 fc       	call   0x1800bede0
   18398c175:	90                   	nop
   18398c176:	48 89 c6             	mov    rsi,rax
   18398c179:	0f 57 c0             	xorps  xmm0,xmm0
   18398c17c:	0f 29 85 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm0
   18398c183:	0f 29 85 f0 00 00 00 	movaps XMMWORD PTR [rbp+0xf0],xmm0
   18398c18a:	48 89 c1             	mov    rcx,rax
   18398c18d:	e8 0e 84 b9 03       	call   0x1875245a0
   18398c192:	48 85 c0             	test   rax,rax
   18398c195:	0f 88 9d 03 00 00    	js     0x18398c538
   18398c19b:	48 89 c7             	mov    rdi,rax
   18398c19e:	bb 0f 00 00 00       	mov    ebx,0xf
   18398c1a3:	48 83 f8 10          	cmp    rax,0x10
   18398c1a7:	72 5b                	jb     0x18398c204
   18398c1a9:	48 89 f8             	mov    rax,rdi
   18398c1ac:	48 83 c8 0f          	or     rax,0xf
   18398c1b0:	48 83 f8 17          	cmp    rax,0x17
   18398c1b4:	bb 16 00 00 00       	mov    ebx,0x16
   18398c1b9:	48 0f 43 d8          	cmovae rbx,rax
   18398c1bd:	48 3d ff 0f 00 00    	cmp    rax,0xfff
   18398c1c3:	72 24                	jb     0x18398c1e9
   18398c1c5:	48 8d 4b 28          	lea    rcx,[rbx+0x28]
   18398c1c9:	e8 ce f6 b1 03       	call   0x1874ab89c
   18398c1ce:	90                   	nop
   18398c1cf:	48 85 c0             	test   rax,rax
   18398c1d2:	0f 84 54 03 00 00    	je     0x18398c52c
   18398c1d8:	48 89 c1             	mov    rcx,rax
   18398c1db:	48 83 c1 27          	add    rcx,0x27
   18398c1df:	48 83 e1 e0          	and    rcx,0xffffffffffffffe0
   18398c1e3:	48 89 41 f8          	mov    QWORD PTR [rcx-0x8],rax
   18398c1e7:	eb 0d                	jmp    0x18398c1f6
   18398c1e9:	48 8d 4b 01          	lea    rcx,[rbx+0x1]
   18398c1ed:	e8 aa f6 b1 03       	call   0x1874ab89c
   18398c1f2:	90                   	nop
   18398c1f3:	48 89 c1             	mov    rcx,rax
   18398c1f6:	48 89 8d a8 00 00 00 	mov    QWORD PTR [rbp+0xa8],rcx
   18398c1fd:	48 89 8d f0 00 00 00 	mov    QWORD PTR [rbp+0xf0],rcx
   18398c204:	48 89 bd 00 01 00 00 	mov    QWORD PTR [rbp+0x100],rdi
   18398c20b:	48 89 9d 08 01 00 00 	mov    QWORD PTR [rbp+0x108],rbx
   18398c212:	48 8b 9d a8 00 00 00 	mov    rbx,QWORD PTR [rbp+0xa8]
   18398c219:	48 89 d9             	mov    rcx,rbx
   18398c21c:	48 89 f2             	mov    rdx,rsi
   18398c21f:	49 89 f8             	mov    r8,rdi
   18398c222:	e8 29 7e bb 03       	call   0x187544050
   18398c227:	c6 04 3b 00          	mov    BYTE PTR [rbx+rdi*1],0x0
   18398c22b:	e8 30 d7 74 fc       	call   0x1800d9960
   18398c230:	90                   	nop
   18398c231:	48 89 c6             	mov    rsi,rax
   18398c234:	48 8b 9d 50 01 00 00 	mov    rbx,QWORD PTR [rbp+0x150]
   18398c23b:	48 8d bb 58 07 00 00 	lea    rdi,[rbx+0x758]
   18398c242:	48 89 c1             	mov    rcx,rax
   18398c245:	e8 56 83 b9 03       	call   0x1875245a0
   18398c24a:	48 8b 8b 70 07 00 00 	mov    rcx,QWORD PTR [rbx+0x770]
   18398c251:	48 39 c8             	cmp    rax,rcx
   18398c254:	76 11                	jbe    0x18398c267
   18398c256:	48 89 f9             	mov    rcx,rdi
   18398c259:	48 89 c2             	mov    rdx,rax
   18398c25c:	49 89 f1             	mov    r9,rsi
   18398c25f:	e8 ec 1e 6b fc       	call   0x18003e150
   18398c264:	90                   	nop
   18398c265:	eb 25                	jmp    0x18398c28c
   18398c267:	48 83 f9 10          	cmp    rcx,0x10
   18398c26b:	72 03                	jb     0x18398c270
   18398c26d:	48 8b 3f             	mov    rdi,QWORD PTR [rdi]
   18398c270:	48 89 83 68 07 00 00 	mov    QWORD PTR [rbx+0x768],rax
   18398c277:	48 89 f9             	mov    rcx,rdi
   18398c27a:	48 89 f2             	mov    rdx,rsi
   18398c27d:	49 89 c0             	mov    r8,rax
   18398c280:	48 89 c6             	mov    rsi,rax
   18398c283:	e8 c8 7d bb 03       	call   0x187544050
   18398c288:	c6 04 37 00          	mov    BYTE PTR [rdi+rsi*1],0x0
   18398c28c:	48 8b 85 50 01 00 00 	mov    rax,QWORD PTR [rbp+0x150]
   18398c293:	c7 80 9c 00 00 00 01 	mov    DWORD PTR [rax+0x9c],0x1
   18398c29a:	00 00 00 
   18398c29d:	48 89 e9             	mov    rcx,rbp
   18398c2a0:	e8 7b af 6b fc       	call   0x180047220
   18398c2a5:	90                   	nop
   18398c2a6:	48 8b 4d 00          	mov    rcx,QWORD PTR [rbp+0x0]
   18398c2aa:	48 8d 55 f0          	lea    rdx,[rbp-0x10]
   18398c2ae:	e8 8d 04 9e fc       	call   0x18036c740
   18398c2b3:	90                   	nop
   18398c2b4:	48 8b 4d f0          	mov    rcx,QWORD PTR [rbp-0x10]
   18398c2b8:	48 8d 55 e0          	lea    rdx,[rbp-0x20]
   18398c2bc:	e8 cf 8a d6 fc       	call   0x1806f4d90
   18398c2c1:	90                   	nop
   18398c2c2:	48 8b 4d e0          	mov    rcx,QWORD PTR [rbp-0x20]
   18398c2c6:	0f 57 c0             	xorps  xmm0,xmm0
   18398c2c9:	0f 29 45 30          	movaps XMMWORD PTR [rbp+0x30],xmm0
   18398c2cd:	48 8b 85 58 01 00 00 	mov    rax,QWORD PTR [rbp+0x158]
   18398c2d4:	48 85 c0             	test   rax,rax
   18398c2d7:	74 0d                	je     0x18398c2e6
   18398c2d9:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   18398c2dd:	48 8b 85 58 01 00 00 	mov    rax,QWORD PTR [rbp+0x158]
   18398c2e4:	eb 02                	jmp    0x18398c2e8
   18398c2e6:	31 c0                	xor    eax,eax
   18398c2e8:	48 8b 95 50 01 00 00 	mov    rdx,QWORD PTR [rbp+0x150]
   18398c2ef:	48 89 55 30          	mov    QWORD PTR [rbp+0x30],rdx
   18398c2f3:	48 89 45 38          	mov    QWORD PTR [rbp+0x38],rax
   18398c2f7:	48 8d 55 a8          	lea    rdx,[rbp-0x58]
   18398c2fb:	4c 8d 45 30          	lea    r8,[rbp+0x30]
   18398c2ff:	e8 1c 34 e0 fd       	call   0x18178f720
   18398c304:	90                   	nop
   18398c305:	48 8b 75 d8          	mov    rsi,QWORD PTR [rbp-0x28]
   18398c309:	48 85 f6             	test   rsi,rsi
   18398c30c:	74 1d                	je     0x18398c32b
   18398c30e:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   18398c312:	75 17                	jne    0x18398c32b
   18398c314:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   18398c317:	48 89 f1             	mov    rcx,rsi
   18398c31a:	ff 10                	call   QWORD PTR [rax]
   18398c31c:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   18398c320:	75 09                	jne    0x18398c32b
   18398c322:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   18398c325:	48 89 f1             	mov    rcx,rsi
   18398c328:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18398c32b:	48 8b 45 c8          	mov    rax,QWORD PTR [rbp-0x38]
   18398c32f:	48 83 f8 10          	cmp    rax,0x10
   18398c333:	48 8b 9d 48 01 00 00 	mov    rbx,QWORD PTR [rbp+0x148]
   18398c33a:	72 35                	jb     0x18398c371
   18398c33c:	48 8b 4d b0          	mov    rcx,QWORD PTR [rbp-0x50]
   18398c340:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18398c344:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18398c34b:	72 1f                	jb     0x18398c36c
   18398c34d:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18398c351:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18398c355:	4c 29 c1             	sub    rcx,r8
   18398c358:	48 83 f9 20          	cmp    rcx,0x20
   18398c35c:	0f 83 ca 01 00 00    	jae    0x18398c52c
   18398c362:	48 83 c0 28          	add    rax,0x28
   18398c366:	48 89 c2             	mov    rdx,rax
   18398c369:	4c 89 c1             	mov    rcx,r8
   18398c36c:	e8 6f f5 b1 03       	call   0x1874ab8e0
   18398c371:	48 8b 75 e8          	mov    rsi,QWORD PTR [rbp-0x18]
   18398c375:	48 85 f6             	test   rsi,rsi
   18398c378:	74 1d                	je     0x18398c397
   18398c37a:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   18398c37e:	75 17                	jne    0x18398c397
   18398c380:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   18398c383:	48 89 f1             	mov    rcx,rsi
   18398c386:	ff 10                	call   QWORD PTR [rax]
   18398c388:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   18398c38c:	75 09                	jne    0x18398c397
   18398c38e:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   18398c391:	48 89 f1             	mov    rcx,rsi
   18398c394:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18398c397:	48 8b 75 f8          	mov    rsi,QWORD PTR [rbp-0x8]
   18398c39b:	48 85 f6             	test   rsi,rsi
   18398c39e:	74 1d                	je     0x18398c3bd
   18398c3a0:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   18398c3a4:	75 17                	jne    0x18398c3bd
   18398c3a6:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   18398c3a9:	48 89 f1             	mov    rcx,rsi
   18398c3ac:	ff 10                	call   QWORD PTR [rax]
   18398c3ae:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   18398c3b2:	75 09                	jne    0x18398c3bd
   18398c3b4:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   18398c3b7:	48 89 f1             	mov    rcx,rsi
   18398c3ba:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18398c3bd:	48 8b 75 08          	mov    rsi,QWORD PTR [rbp+0x8]
   18398c3c1:	48 85 f6             	test   rsi,rsi
   18398c3c4:	74 1d                	je     0x18398c3e3
   18398c3c6:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   18398c3ca:	75 17                	jne    0x18398c3e3
   18398c3cc:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   18398c3cf:	48 89 f1             	mov    rcx,rsi
   18398c3d2:	ff 10                	call   QWORD PTR [rax]
   18398c3d4:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   18398c3d8:	75 09                	jne    0x18398c3e3
   18398c3da:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   18398c3dd:	48 89 f1             	mov    rcx,rsi
   18398c3e0:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18398c3e3:	48 8b 85 08 01 00 00 	mov    rax,QWORD PTR [rbp+0x108]
   18398c3ea:	48 83 f8 10          	cmp    rax,0x10
   18398c3ee:	72 38                	jb     0x18398c428
   18398c3f0:	48 8b 8d f0 00 00 00 	mov    rcx,QWORD PTR [rbp+0xf0]
   18398c3f7:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18398c3fb:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18398c402:	72 1f                	jb     0x18398c423
   18398c404:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18398c408:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18398c40c:	4c 29 c1             	sub    rcx,r8
   18398c40f:	48 83 f9 20          	cmp    rcx,0x20
   18398c413:	0f 83 13 01 00 00    	jae    0x18398c52c
   18398c419:	48 83 c0 28          	add    rax,0x28
   18398c41d:	48 89 c2             	mov    rdx,rax
   18398c420:	4c 89 c1             	mov    rcx,r8
   18398c423:	e8 b8 f4 b1 03       	call   0x1874ab8e0
   18398c428:	48 8b b5 58 01 00 00 	mov    rsi,QWORD PTR [rbp+0x158]
   18398c42f:	48 85 f6             	test   rsi,rsi
   18398c432:	74 1d                	je     0x18398c451
   18398c434:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   18398c438:	75 17                	jne    0x18398c451
   18398c43a:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   18398c43d:	48 89 f1             	mov    rcx,rsi
   18398c440:	ff 10                	call   QWORD PTR [rax]
   18398c442:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   18398c446:	75 09                	jne    0x18398c451
   18398c448:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   18398c44b:	48 89 f1             	mov    rcx,rsi
   18398c44e:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18398c451:	8b 85 b4 00 00 00    	mov    eax,DWORD PTR [rbp+0xb4]
   18398c457:	0b 85 b0 00 00 00    	or     eax,DWORD PTR [rbp+0xb0]
   18398c45d:	0f 94 03             	sete   BYTE PTR [rbx]
   18398c460:	48 8b b5 e0 00 00 00 	mov    rsi,QWORD PTR [rbp+0xe0]
   18398c467:	48 85 f6             	test   rsi,rsi
   18398c46a:	74 1d                	je     0x18398c489
   18398c46c:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   18398c470:	75 17                	jne    0x18398c489
   18398c472:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   18398c475:	48 89 f1             	mov    rcx,rsi
   18398c478:	ff 10                	call   QWORD PTR [rax]
   18398c47a:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   18398c47e:	75 09                	jne    0x18398c489
   18398c480:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   18398c483:	48 89 f1             	mov    rcx,rsi
   18398c486:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18398c489:	48 8b 85 d0 00 00 00 	mov    rax,QWORD PTR [rbp+0xd0]
   18398c490:	48 83 f8 10          	cmp    rax,0x10
   18398c494:	72 34                	jb     0x18398c4ca
   18398c496:	48 8b 8d b8 00 00 00 	mov    rcx,QWORD PTR [rbp+0xb8]
   18398c49d:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18398c4a1:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18398c4a8:	72 1b                	jb     0x18398c4c5
   18398c4aa:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18398c4ae:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18398c4b2:	4c 29 c1             	sub    rcx,r8
   18398c4b5:	48 83 f9 20          	cmp    rcx,0x20
   18398c4b9:	73 71                	jae    0x18398c52c
   18398c4bb:	48 83 c0 28          	add    rax,0x28
   18398c4bf:	48 89 c2             	mov    rdx,rax
   18398c4c2:	4c 89 c1             	mov    rcx,r8
   18398c4c5:	e8 16 f4 b1 03       	call   0x1874ab8e0
   18398c4ca:	48 8b 45 58          	mov    rax,QWORD PTR [rbp+0x58]
   18398c4ce:	48 83 f8 10          	cmp    rax,0x10
   18398c4d2:	72 31                	jb     0x18398c505
   18398c4d4:	48 8b 4d 40          	mov    rcx,QWORD PTR [rbp+0x40]
   18398c4d8:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18398c4dc:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18398c4e3:	72 1b                	jb     0x18398c500
   18398c4e5:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18398c4e9:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18398c4ed:	4c 29 c1             	sub    rcx,r8
   18398c4f0:	48 83 f9 20          	cmp    rcx,0x20
   18398c4f4:	73 36                	jae    0x18398c52c
   18398c4f6:	48 83 c0 28          	add    rax,0x28
   18398c4fa:	48 89 c2             	mov    rdx,rax
   18398c4fd:	4c 89 c1             	mov    rcx,r8
   18398c500:	e8 db f3 b1 03       	call   0x1874ab8e0
   18398c505:	48 8d 4d 60          	lea    rcx,[rbp+0x60]
   18398c509:	e8 22 6f 0e 02       	call   0x185a73430
   18398c50e:	48 89 d8             	mov    rax,rbx
   18398c511:	0f 28 b5 80 01 00 00 	movaps xmm6,XMMWORD PTR [rbp+0x180]
   18398c518:	48 81 c4 18 02 00 00 	add    rsp,0x218
   18398c51f:	5b                   	pop    rbx
   18398c520:	5f                   	pop    rdi
   18398c521:	5e                   	pop    rsi
   18398c522:	41 5c                	pop    r12
   18398c524:	41 5d                	pop    r13
   18398c526:	41 5e                	pop    r14
   18398c528:	41 5f                	pop    r15
   18398c52a:	5d                   	pop    rbp
   18398c52b:	c3                   	ret
   18398c52c:	e8 5b 0e b8 03       	call   0x18750d38c
   18398c531:	90                   	nop
   18398c532:	e8 59 c6 67 fc       	call   0x180008b90
   18398c537:	90                   	nop
   18398c538:	e8 53 c6 67 fc       	call   0x180008b90
   18398c53d:	90                   	nop
   18398c53e:	cc                   	int3
