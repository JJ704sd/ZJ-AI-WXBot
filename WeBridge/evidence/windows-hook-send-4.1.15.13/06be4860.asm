
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000186be4860 <.text+0x6be3860>:
   186be4860:	55                   	push   rbp
   186be4861:	56                   	push   rsi
   186be4862:	48 81 ec 48 01 00 00 	sub    rsp,0x148
   186be4869:	48 8d ac 24 80 00 00 	lea    rbp,[rsp+0x80]
   186be4870:	00 
   186be4871:	48 c7 85 c0 00 00 00 	mov    QWORD PTR [rbp+0xc0],0xfffffffffffffffe
   186be4878:	fe ff ff ff 
   186be487c:	0f 57 c0             	xorps  xmm0,xmm0
   186be487f:	0f 11 41 08          	movups XMMWORD PTR [rcx+0x8],xmm0
   186be4883:	c6 41 18 00          	mov    BYTE PTR [rcx+0x18],0x0
   186be4887:	c7 41 20 00 00 00 00 	mov    DWORD PTR [rcx+0x20],0x0
   186be488e:	48 8d 05 d3 4f f1 02 	lea    rax,[rip+0x2f14fd3]        # 0x189af9868
   186be4895:	48 89 01             	mov    QWORD PTR [rcx],rax
   186be4898:	48 89 8d b8 00 00 00 	mov    QWORD PTR [rbp+0xb8],rcx
   186be489f:	48 83 c1 28          	add    rcx,0x28
   186be48a3:	48 89 4d 78          	mov    QWORD PTR [rbp+0x78],rcx
   186be48a7:	e8 c4 02 00 00       	call   0x186be4b70
   186be48ac:	90                   	nop
   186be48ad:	48 8b 85 b8 00 00 00 	mov    rax,QWORD PTR [rbp+0xb8]
   186be48b4:	48 8d 48 38          	lea    rcx,[rax+0x38]
   186be48b8:	48 89 8d 80 00 00 00 	mov    QWORD PTR [rbp+0x80],rcx
   186be48bf:	e8 bc 40 c6 fd       	call   0x184848980
   186be48c4:	90                   	nop
   186be48c5:	48 8b 85 b8 00 00 00 	mov    rax,QWORD PTR [rbp+0xb8]
   186be48cc:	48 8d 48 48          	lea    rcx,[rax+0x48]
   186be48d0:	48 89 8d 88 00 00 00 	mov    QWORD PTR [rbp+0x88],rcx
   186be48d7:	e8 b4 3c ff ff       	call   0x186bd8590
   186be48dc:	90                   	nop
   186be48dd:	48 8b 85 b8 00 00 00 	mov    rax,QWORD PTR [rbp+0xb8]
   186be48e4:	48 c7 40 58 00 00 00 	mov    QWORD PTR [rax+0x58],0x0
   186be48eb:	00 
   186be48ec:	c6 40 70 00          	mov    BYTE PTR [rax+0x70],0x0
   186be48f0:	0f 28 05 49 1f ae 02 	movaps xmm0,XMMWORD PTR [rip+0x2ae1f49]        # 0x1896c6840
   186be48f7:	0f 11 40 60          	movups XMMWORD PTR [rax+0x60],xmm0
   186be48fb:	48 c7 40 78 00 00 00 	mov    QWORD PTR [rax+0x78],0x0
   186be4902:	00 
   186be4903:	c7 80 80 00 00 00 00 	mov    DWORD PTR [rax+0x80],0x0
   186be490a:	00 00 00 
   186be490d:	66 c7 80 84 00 00 00 	mov    WORD PTR [rax+0x84],0x0
   186be4914:	00 00 
   186be4916:	c7 80 88 00 00 00 00 	mov    DWORD PTR [rax+0x88],0x0
   186be491d:	00 00 00 
   186be4920:	48 8d b0 90 00 00 00 	lea    rsi,[rax+0x90]
   186be4927:	48 c7 45 f0 00 00 00 	mov    QWORD PTR [rbp-0x10],0x0
   186be492e:	00 
   186be492f:	48 c7 45 30 00 00 00 	mov    QWORD PTR [rbp+0x30],0x0
   186be4936:	00 
   186be4937:	48 c7 45 70 00 00 00 	mov    QWORD PTR [rbp+0x70],0x0
   186be493e:	00 
   186be493f:	0f 57 c0             	xorps  xmm0,xmm0
   186be4942:	0f 29 85 a0 00 00 00 	movaps XMMWORD PTR [rbp+0xa0],xmm0
   186be4949:	48 8d 85 a0 00 00 00 	lea    rax,[rbp+0xa0]
   186be4950:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   186be4955:	48 c7 44 24 28 00 00 	mov    QWORD PTR [rsp+0x28],0x0
   186be495c:	00 00 
   186be495e:	48 8d 55 b8          	lea    rdx,[rbp-0x48]
   186be4962:	4c 8d 45 f8          	lea    r8,[rbp-0x8]
   186be4966:	4c 8d 4d 38          	lea    r9,[rbp+0x38]
   186be496a:	48 89 f1             	mov    rcx,rsi
   186be496d:	e8 9e af 42 f9       	call   0x18000f910
   186be4972:	90                   	nop
   186be4973:	48 89 b5 90 00 00 00 	mov    QWORD PTR [rbp+0x90],rsi
   186be497a:	48 8b b5 a8 00 00 00 	mov    rsi,QWORD PTR [rbp+0xa8]
   186be4981:	48 85 f6             	test   rsi,rsi
   186be4984:	74 1d                	je     0x186be49a3
   186be4986:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   186be498a:	75 17                	jne    0x186be49a3
   186be498c:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   186be498f:	48 89 f1             	mov    rcx,rsi
   186be4992:	ff 10                	call   QWORD PTR [rax]
   186be4994:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   186be4998:	75 09                	jne    0x186be49a3
   186be499a:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   186be499d:	48 89 f1             	mov    rcx,rsi
   186be49a0:	ff 50 08             	call   QWORD PTR [rax+0x8]
   186be49a3:	48 8b b5 b8 00 00 00 	mov    rsi,QWORD PTR [rbp+0xb8]
   186be49aa:	48 8d 86 78 01 00 00 	lea    rax,[rsi+0x178]
   186be49b1:	48 89 85 98 00 00 00 	mov    QWORD PTR [rbp+0x98],rax
   186be49b8:	48 8d 8e a8 01 00 00 	lea    rcx,[rsi+0x1a8]
   186be49bf:	0f 57 c0             	xorps  xmm0,xmm0
   186be49c2:	0f 11 86 91 01 00 00 	movups XMMWORD PTR [rsi+0x191],xmm0
   186be49c9:	0f 11 86 88 01 00 00 	movups XMMWORD PTR [rsi+0x188],xmm0
   186be49d0:	0f 11 86 78 01 00 00 	movups XMMWORD PTR [rsi+0x178],xmm0
   186be49d7:	48 89 f2             	mov    rdx,rsi
   186be49da:	e8 11 8a ac f9       	call   0x1806ad3f0
   186be49df:	90                   	nop
   186be49e0:	c6 46 70 01          	mov    BYTE PTR [rsi+0x70],0x1
   186be49e4:	48 89 f0             	mov    rax,rsi
   186be49e7:	48 81 c4 48 01 00 00 	add    rsp,0x148
   186be49ee:	5e                   	pop    rsi
   186be49ef:	5d                   	pop    rbp
   186be49f0:	c3                   	ret
