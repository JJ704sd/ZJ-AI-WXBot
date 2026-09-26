
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000182e89940 <.text+0x2e88940>:
   182e89940:	41 57                	push   r15
   182e89942:	41 56                	push   r14
   182e89944:	56                   	push   rsi
   182e89945:	57                   	push   rdi
   182e89946:	53                   	push   rbx
   182e89947:	48 83 ec 30          	sub    rsp,0x30
   182e8994b:	0f 29 74 24 20       	movaps XMMWORD PTR [rsp+0x20],xmm6
   182e89950:	48 89 d6             	mov    rsi,rdx
   182e89953:	48 89 cf             	mov    rdi,rcx
   182e89956:	8b 52 08             	mov    edx,DWORD PTR [rdx+0x8]
   182e89959:	03 51 08             	add    edx,DWORD PTR [rcx+0x8]
   182e8995c:	e8 0f 44 f2 fd       	call   0x180dadd70
   182e89961:	83 7e 08 00          	cmp    DWORD PTR [rsi+0x8],0x0
   182e89965:	0f 8e 9e 00 00 00    	jle    0x182e89a09
   182e8996b:	31 db                	xor    ebx,ebx
   182e8996d:	4c 8d 35 c4 b4 54 06 	lea    r14,[rip+0x654b4c4]        # 0x1893d4e38
   182e89974:	4c 8d 3d 65 d4 a8 08 	lea    r15,[rip+0x8a8d465]        # 0x18b916de0
   182e8997b:	0f 57 f6             	xorps  xmm6,xmm6
   182e8997e:	eb 27                	jmp    0x182e899a7
   182e89980:	48 63 c8             	movsxd rcx,eax
   182e89983:	48 8b 17             	mov    rdx,QWORD PTR [rdi]
   182e89986:	ff c0                	inc    eax
   182e89988:	89 47 08             	mov    DWORD PTR [rdi+0x8],eax
   182e8998b:	48 8b 0c ca          	mov    rcx,QWORD PTR [rdx+rcx*8]
   182e8998f:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   182e89992:	48 8b 14 d8          	mov    rdx,QWORD PTR [rax+rbx*8]
   182e89996:	e8 65 92 ff ff       	call   0x182e82c00
   182e8999b:	48 ff c3             	inc    rbx
   182e8999e:	48 63 46 08          	movsxd rax,DWORD PTR [rsi+0x8]
   182e899a2:	48 39 c3             	cmp    rbx,rax
   182e899a5:	7d 62                	jge    0x182e89a09
   182e899a7:	8b 47 08             	mov    eax,DWORD PTR [rdi+0x8]
   182e899aa:	8b 57 0c             	mov    edx,DWORD PTR [rdi+0xc]
   182e899ad:	39 d0                	cmp    eax,edx
   182e899af:	7c cf                	jl     0x182e89980
   182e899b1:	3b 57 10             	cmp    edx,DWORD PTR [rdi+0x10]
   182e899b4:	75 0d                	jne    0x182e899c3
   182e899b6:	ff c2                	inc    edx
   182e899b8:	48 89 f9             	mov    rcx,rdi
   182e899bb:	e8 b0 43 f2 fd       	call   0x180dadd70
   182e899c0:	8b 57 0c             	mov    edx,DWORD PTR [rdi+0xc]
   182e899c3:	ff c2                	inc    edx
   182e899c5:	89 57 0c             	mov    DWORD PTR [rdi+0xc],edx
   182e899c8:	b9 38 00 00 00       	mov    ecx,0x38
   182e899cd:	e8 ca 1e 62 04       	call   0x1874ab89c
   182e899d2:	48 89 c1             	mov    rcx,rax
   182e899d5:	4c 89 30             	mov    QWORD PTR [rax],r14
   182e899d8:	48 c7 40 08 00 00 00 	mov    QWORD PTR [rax+0x8],0x0
   182e899df:	00 
   182e899e0:	4c 89 78 10          	mov    QWORD PTR [rax+0x10],r15
   182e899e4:	48 c7 40 18 00 00 00 	mov    QWORD PTR [rax+0x18],0x0
   182e899eb:	00 
   182e899ec:	4c 89 78 20          	mov    QWORD PTR [rax+0x20],r15
   182e899f0:	0f 11 70 28          	movups XMMWORD PTR [rax+0x28],xmm6
   182e899f4:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   182e899f7:	48 63 57 08          	movsxd rdx,DWORD PTR [rdi+0x8]
   182e899fb:	44 8d 42 01          	lea    r8d,[rdx+0x1]
   182e899ff:	44 89 47 08          	mov    DWORD PTR [rdi+0x8],r8d
   182e89a03:	48 89 0c d0          	mov    QWORD PTR [rax+rdx*8],rcx
   182e89a07:	eb 86                	jmp    0x182e8998f
   182e89a09:	0f 28 74 24 20       	movaps xmm6,XMMWORD PTR [rsp+0x20]
   182e89a0e:	48 83 c4 30          	add    rsp,0x30
   182e89a12:	5b                   	pop    rbx
   182e89a13:	5f                   	pop    rdi
   182e89a14:	5e                   	pop    rsi
   182e89a15:	41 5e                	pop    r14
   182e89a17:	41 5f                	pop    r15
   182e89a19:	c3                   	ret
