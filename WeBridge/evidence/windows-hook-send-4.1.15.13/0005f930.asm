
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

000000018005f930 <.text+0x5e930>:
   18005f930:	55                   	push   rbp
   18005f931:	56                   	push   rsi
   18005f932:	57                   	push   rdi
   18005f933:	48 83 ec 40          	sub    rsp,0x40
   18005f937:	48 8d 6c 24 40       	lea    rbp,[rsp+0x40]
   18005f93c:	48 c7 45 f8 fe ff ff 	mov    QWORD PTR [rbp-0x8],0xfffffffffffffffe
   18005f943:	ff 
   18005f944:	48 89 ce             	mov    rsi,rcx
   18005f947:	48 8b 3d 72 29 8b 0b 	mov    rdi,QWORD PTR [rip+0xb8b2972]        # 0x18b9122c0
   18005f94e:	48 89 f9             	mov    rcx,rdi
   18005f951:	e8 b2 cf 44 07       	call   0x1874ac908
   18005f956:	85 c0                	test   eax,eax
   18005f958:	0f 85 e0 00 00 00    	jne    0x18005fa3e
   18005f95e:	81 7f 4c ff ff ff 7f 	cmp    DWORD PTR [rdi+0x4c],0x7fffffff
   18005f965:	0f 84 dd 00 00 00    	je     0x18005fa48
   18005f96b:	48 8d 96 d0 00 00 00 	lea    rdx,[rsi+0xd0]
   18005f972:	48 8d 0d 37 29 8b 0b 	lea    rcx,[rip+0xb8b2937]        # 0x18b9122b0
   18005f979:	e8 12 01 00 00       	call   0x18005fa90
   18005f97e:	48 89 f9             	mov    rcx,rdi
   18005f981:	e8 aa cf 44 07       	call   0x1874ac930
   18005f986:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   18005f989:	80 38 00             	cmp    BYTE PTR [rax],0x0
   18005f98c:	75 18                	jne    0x18005f9a6
   18005f98e:	48 8b 8e c8 00 00 00 	mov    rcx,QWORD PTR [rsi+0xc8]
   18005f995:	48 85 c9             	test   rcx,rcx
   18005f998:	74 14                	je     0x18005f9ae
   18005f99a:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18005f99d:	ff 50 10             	call   QWORD PTR [rax+0x10]
   18005f9a0:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   18005f9a3:	c6 00 01             	mov    BYTE PTR [rax],0x1
   18005f9a6:	48 83 c4 40          	add    rsp,0x40
   18005f9aa:	5f                   	pop    rdi
   18005f9ab:	5e                   	pop    rsi
   18005f9ac:	5d                   	pop    rbp
   18005f9ad:	c3                   	ret
   18005f9ae:	0f 57 c0             	xorps  xmm0,xmm0
   18005f9b1:	0f 29 45 e0          	movaps XMMWORD PTR [rbp-0x20],xmm0
   18005f9b5:	48 8b 8e e0 00 00 00 	mov    rcx,QWORD PTR [rsi+0xe0]
   18005f9bc:	48 85 c9             	test   rcx,rcx
   18005f9bf:	74 36                	je     0x18005f9f7
   18005f9c1:	8b 41 08             	mov    eax,DWORD PTR [rcx+0x8]
   18005f9c4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
   18005f9cb:	00 00 00 00 00 
   18005f9d0:	85 c0                	test   eax,eax
   18005f9d2:	74 2c                	je     0x18005fa00
   18005f9d4:	8d 50 01             	lea    edx,[rax+0x1]
   18005f9d7:	f0 0f b1 51 08       	lock cmpxchg DWORD PTR [rcx+0x8],edx
   18005f9dc:	75 f2                	jne    0x18005f9d0
   18005f9de:	0f 10 86 d8 00 00 00 	movups xmm0,XMMWORD PTR [rsi+0xd8]
   18005f9e5:	48 8b 8e d8 00 00 00 	mov    rcx,QWORD PTR [rsi+0xd8]
   18005f9ec:	0f 29 45 e0          	movaps XMMWORD PTR [rbp-0x20],xmm0
   18005f9f0:	48 85 c9             	test   rcx,rcx
   18005f9f3:	75 14                	jne    0x18005fa09
   18005f9f5:	eb 18                	jmp    0x18005fa0f
   18005f9f7:	31 ff                	xor    edi,edi
   18005f9f9:	48 85 ff             	test   rdi,rdi
   18005f9fc:	75 1a                	jne    0x18005fa18
   18005f9fe:	eb a0                	jmp    0x18005f9a0
   18005fa00:	48 8b 4d e0          	mov    rcx,QWORD PTR [rbp-0x20]
   18005fa04:	48 85 c9             	test   rcx,rcx
   18005fa07:	74 06                	je     0x18005fa0f
   18005fa09:	e8 92 01 00 00       	call   0x18005fba0
   18005fa0e:	90                   	nop
   18005fa0f:	48 8b 7d e8          	mov    rdi,QWORD PTR [rbp-0x18]
   18005fa13:	48 85 ff             	test   rdi,rdi
   18005fa16:	74 88                	je     0x18005f9a0
   18005fa18:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   18005fa1c:	75 82                	jne    0x18005f9a0
   18005fa1e:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   18005fa21:	48 89 f9             	mov    rcx,rdi
   18005fa24:	ff 10                	call   QWORD PTR [rax]
   18005fa26:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   18005fa2a:	0f 85 70 ff ff ff    	jne    0x18005f9a0
   18005fa30:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   18005fa33:	48 89 f9             	mov    rcx,rdi
   18005fa36:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18005fa39:	e9 62 ff ff ff       	jmp    0x18005f9a0
   18005fa3e:	b9 05 00 00 00       	mov    ecx,0x5
   18005fa43:	e8 fc c4 44 07       	call   0x1874abf44
   18005fa48:	c7 47 4c fe ff ff 7f 	mov    DWORD PTR [rdi+0x4c],0x7ffffffe
   18005fa4f:	b9 06 00 00 00       	mov    ecx,0x6
   18005fa54:	e8 eb c4 44 07       	call   0x1874abf44
   18005fa59:	cc                   	int3
