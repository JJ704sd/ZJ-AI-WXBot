
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

00000001819d11e0 <.text+0x19d01e0>:
   1819d11e0:	55                   	push   rbp
   1819d11e1:	56                   	push   rsi
   1819d11e2:	57                   	push   rdi
   1819d11e3:	48 83 ec 40          	sub    rsp,0x40
   1819d11e7:	48 8d 6c 24 40       	lea    rbp,[rsp+0x40]
   1819d11ec:	48 c7 45 f8 fe ff ff 	mov    QWORD PTR [rbp-0x8],0xfffffffffffffffe
   1819d11f3:	ff 
   1819d11f4:	48 89 ce             	mov    rsi,rcx
   1819d11f7:	b9 08 01 00 00       	mov    ecx,0x108
   1819d11fc:	e8 9b a6 ad 05       	call   0x1874ab89c
   1819d1201:	49 89 c1             	mov    r9,rax
   1819d1204:	48 8d 05 dd 11 74 07 	lea    rax,[rip+0x77411dd]        # 0x1891123e8
   1819d120b:	49 89 01             	mov    QWORD PTR [r9],rax
   1819d120e:	0f 57 c0             	xorps  xmm0,xmm0
   1819d1211:	41 0f 11 41 08       	movups XMMWORD PTR [r9+0x8],xmm0
   1819d1216:	49 c7 41 18 00 00 00 	mov    QWORD PTR [r9+0x18],0x0
   1819d121d:	00 
   1819d121e:	48 8b 7e 10          	mov    rdi,QWORD PTR [rsi+0x10]
   1819d1222:	48 8b 4e 08          	mov    rcx,QWORD PTR [rsi+0x8]
   1819d1226:	48 89 f8             	mov    rax,rdi
   1819d1229:	48 29 c8             	sub    rax,rcx
   1819d122c:	48 29 cf             	sub    rdi,rcx
   1819d122f:	4c 89 4d f0          	mov    QWORD PTR [rbp-0x10],r9
   1819d1233:	0f 84 a9 00 00 00    	je     0x1819d12e2
   1819d1239:	48 c1 f8 04          	sar    rax,0x4
   1819d123d:	48 89 c1             	mov    rcx,rax
   1819d1240:	48 c1 e9 3c          	shr    rcx,0x3c
   1819d1244:	0f 85 bd 00 00 00    	jne    0x1819d1307
   1819d124a:	48 3d 00 01 00 00    	cmp    rax,0x100
   1819d1250:	72 24                	jb     0x1819d1276
   1819d1252:	48 8d 4f 27          	lea    rcx,[rdi+0x27]
   1819d1256:	e8 41 a6 ad 05       	call   0x1874ab89c
   1819d125b:	90                   	nop
   1819d125c:	48 85 c0             	test   rax,rax
   1819d125f:	0f 84 a8 00 00 00    	je     0x1819d130d
   1819d1265:	48 89 c1             	mov    rcx,rax
   1819d1268:	48 83 c0 27          	add    rax,0x27
   1819d126c:	48 83 e0 e0          	and    rax,0xffffffffffffffe0
   1819d1270:	48 89 48 f8          	mov    QWORD PTR [rax-0x8],rcx
   1819d1274:	eb 09                	jmp    0x1819d127f
   1819d1276:	48 89 f9             	mov    rcx,rdi
   1819d1279:	e8 1e a6 ad 05       	call   0x1874ab89c
   1819d127e:	90                   	nop
   1819d127f:	4c 8b 4d f0          	mov    r9,QWORD PTR [rbp-0x10]
   1819d1283:	49 89 41 08          	mov    QWORD PTR [r9+0x8],rax
   1819d1287:	49 89 41 10          	mov    QWORD PTR [r9+0x10],rax
   1819d128b:	48 01 c7             	add    rdi,rax
   1819d128e:	49 89 79 18          	mov    QWORD PTR [r9+0x18],rdi
   1819d1292:	48 8b 4e 08          	mov    rcx,QWORD PTR [rsi+0x8]
   1819d1296:	48 8b 56 10          	mov    rdx,QWORD PTR [rsi+0x10]
   1819d129a:	48 39 d1             	cmp    rcx,rdx
   1819d129d:	74 3f                	je     0x1819d12de
   1819d129f:	0f 57 c0             	xorps  xmm0,xmm0
   1819d12a2:	eb 27                	jmp    0x1819d12cb
   1819d12a4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
   1819d12ab:	00 00 00 00 00 
   1819d12b0:	4c 8b 01             	mov    r8,QWORD PTR [rcx]
   1819d12b3:	4c 89 00             	mov    QWORD PTR [rax],r8
   1819d12b6:	4c 8b 41 08          	mov    r8,QWORD PTR [rcx+0x8]
   1819d12ba:	4c 89 40 08          	mov    QWORD PTR [rax+0x8],r8
   1819d12be:	48 83 c0 10          	add    rax,0x10
   1819d12c2:	48 83 c1 10          	add    rcx,0x10
   1819d12c6:	48 39 d1             	cmp    rcx,rdx
   1819d12c9:	74 13                	je     0x1819d12de
   1819d12cb:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   1819d12ce:	4c 8b 41 08          	mov    r8,QWORD PTR [rcx+0x8]
   1819d12d2:	4d 85 c0             	test   r8,r8
   1819d12d5:	74 d9                	je     0x1819d12b0
   1819d12d7:	f0 41 ff 40 08       	lock inc DWORD PTR [r8+0x8]
   1819d12dc:	eb d2                	jmp    0x1819d12b0
   1819d12de:	49 89 41 10          	mov    QWORD PTR [r9+0x10],rax
   1819d12e2:	49 8d 41 08          	lea    rax,[r9+0x8]
   1819d12e6:	48 89 45 e8          	mov    QWORD PTR [rbp-0x18],rax
   1819d12ea:	49 8d 49 20          	lea    rcx,[r9+0x20]
   1819d12ee:	48 83 c6 20          	add    rsi,0x20
   1819d12f2:	48 89 f2             	mov    rdx,rsi
   1819d12f5:	e8 b6 df 68 fe       	call   0x18005f2b0
   1819d12fa:	90                   	nop
   1819d12fb:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   1819d12ff:	48 83 c4 40          	add    rsp,0x40
   1819d1303:	5f                   	pop    rdi
   1819d1304:	5e                   	pop    rsi
   1819d1305:	5d                   	pop    rbp
   1819d1306:	c3                   	ret
   1819d1307:	e8 24 a4 63 fe       	call   0x18000b730
   1819d130c:	90                   	nop
   1819d130d:	e8 7a c0 b3 05       	call   0x18750d38c
   1819d1312:	cc                   	int3
