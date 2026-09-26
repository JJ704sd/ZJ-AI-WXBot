
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

00000001801cf940 <.text+0x1ce940>:
   1801cf940:	55                   	push   rbp
   1801cf941:	56                   	push   rsi
   1801cf942:	57                   	push   rdi
   1801cf943:	53                   	push   rbx
   1801cf944:	48 83 ec 38          	sub    rsp,0x38
   1801cf948:	48 8d 6c 24 30       	lea    rbp,[rsp+0x30]
   1801cf94d:	48 c7 45 00 fe ff ff 	mov    QWORD PTR [rbp+0x0],0xfffffffffffffffe
   1801cf954:	ff 
   1801cf955:	48 89 d7             	mov    rdi,rdx
   1801cf958:	48 89 ce             	mov    rsi,rcx
   1801cf95b:	48 8b 1d 5e 29 74 0b 	mov    rbx,QWORD PTR [rip+0xb74295e]        # 0x18b9122c0
   1801cf962:	48 89 d9             	mov    rcx,rbx
   1801cf965:	e8 9e cf 2d 07       	call   0x1874ac908
   1801cf96a:	85 c0                	test   eax,eax
   1801cf96c:	0f 85 df 00 00 00    	jne    0x1801cfa51
   1801cf972:	81 7b 4c ff ff ff 7f 	cmp    DWORD PTR [rbx+0x4c],0x7fffffff
   1801cf979:	0f 84 dc 00 00 00    	je     0x1801cfa5b
   1801cf97f:	48 8d 96 d0 00 00 00 	lea    rdx,[rsi+0xd0]
   1801cf986:	48 8d 0d 23 29 74 0b 	lea    rcx,[rip+0xb742923]        # 0x18b9122b0
   1801cf98d:	e8 fe 00 e9 ff       	call   0x18005fa90
   1801cf992:	48 89 d9             	mov    rcx,rbx
   1801cf995:	e8 96 cf 2d 07       	call   0x1874ac930
   1801cf99a:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1801cf99d:	80 38 00             	cmp    BYTE PTR [rax],0x0
   1801cf9a0:	75 1b                	jne    0x1801cf9bd
   1801cf9a2:	48 8b 8e 88 00 00 00 	mov    rcx,QWORD PTR [rsi+0x88]
   1801cf9a9:	48 85 c9             	test   rcx,rcx
   1801cf9ac:	74 18                	je     0x1801cf9c6
   1801cf9ae:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   1801cf9b1:	48 89 fa             	mov    rdx,rdi
   1801cf9b4:	ff 50 10             	call   QWORD PTR [rax+0x10]
   1801cf9b7:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1801cf9ba:	c6 00 01             	mov    BYTE PTR [rax],0x1
   1801cf9bd:	48 83 c4 38          	add    rsp,0x38
   1801cf9c1:	5b                   	pop    rbx
   1801cf9c2:	5f                   	pop    rdi
   1801cf9c3:	5e                   	pop    rsi
   1801cf9c4:	5d                   	pop    rbp
   1801cf9c5:	c3                   	ret
   1801cf9c6:	0f 57 c0             	xorps  xmm0,xmm0
   1801cf9c9:	0f 29 45 f0          	movaps XMMWORD PTR [rbp-0x10],xmm0
   1801cf9cd:	48 8b 8e e0 00 00 00 	mov    rcx,QWORD PTR [rsi+0xe0]
   1801cf9d4:	48 85 c9             	test   rcx,rcx
   1801cf9d7:	74 2e                	je     0x1801cfa07
   1801cf9d9:	8b 41 08             	mov    eax,DWORD PTR [rcx+0x8]
   1801cf9dc:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
   1801cf9e0:	85 c0                	test   eax,eax
   1801cf9e2:	74 2c                	je     0x1801cfa10
   1801cf9e4:	8d 50 01             	lea    edx,[rax+0x1]
   1801cf9e7:	f0 0f b1 51 08       	lock cmpxchg DWORD PTR [rcx+0x8],edx
   1801cf9ec:	75 f2                	jne    0x1801cf9e0
   1801cf9ee:	0f 10 86 d8 00 00 00 	movups xmm0,XMMWORD PTR [rsi+0xd8]
   1801cf9f5:	48 8b 8e d8 00 00 00 	mov    rcx,QWORD PTR [rsi+0xd8]
   1801cf9fc:	0f 29 45 f0          	movaps XMMWORD PTR [rbp-0x10],xmm0
   1801cfa00:	48 85 c9             	test   rcx,rcx
   1801cfa03:	75 14                	jne    0x1801cfa19
   1801cfa05:	eb 1b                	jmp    0x1801cfa22
   1801cfa07:	31 ff                	xor    edi,edi
   1801cfa09:	48 85 ff             	test   rdi,rdi
   1801cfa0c:	75 1d                	jne    0x1801cfa2b
   1801cfa0e:	eb a7                	jmp    0x1801cf9b7
   1801cfa10:	48 8b 4d f0          	mov    rcx,QWORD PTR [rbp-0x10]
   1801cfa14:	48 85 c9             	test   rcx,rcx
   1801cfa17:	74 09                	je     0x1801cfa22
   1801cfa19:	48 89 fa             	mov    rdx,rdi
   1801cfa1c:	e8 7f 00 00 00       	call   0x1801cfaa0
   1801cfa21:	90                   	nop
   1801cfa22:	48 8b 7d f8          	mov    rdi,QWORD PTR [rbp-0x8]
   1801cfa26:	48 85 ff             	test   rdi,rdi
   1801cfa29:	74 8c                	je     0x1801cf9b7
   1801cfa2b:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   1801cfa2f:	75 86                	jne    0x1801cf9b7
   1801cfa31:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1801cfa34:	48 89 f9             	mov    rcx,rdi
   1801cfa37:	ff 10                	call   QWORD PTR [rax]
   1801cfa39:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   1801cfa3d:	0f 85 74 ff ff ff    	jne    0x1801cf9b7
   1801cfa43:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1801cfa46:	48 89 f9             	mov    rcx,rdi
   1801cfa49:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1801cfa4c:	e9 66 ff ff ff       	jmp    0x1801cf9b7
   1801cfa51:	b9 05 00 00 00       	mov    ecx,0x5
   1801cfa56:	e8 e9 c4 2d 07       	call   0x1874abf44
   1801cfa5b:	c7 43 4c fe ff ff 7f 	mov    DWORD PTR [rbx+0x4c],0x7ffffffe
   1801cfa62:	b9 06 00 00 00       	mov    ecx,0x6
   1801cfa67:	e8 d8 c4 2d 07       	call   0x1874abf44
   1801cfa6c:	cc                   	int3
