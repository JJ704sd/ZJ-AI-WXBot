
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000182f22ef0 <.text+0x2f21ef0>:
   182f22ef0:	55                   	push   rbp
   182f22ef1:	41 57                	push   r15
   182f22ef3:	41 56                	push   r14
   182f22ef5:	41 55                	push   r13
   182f22ef7:	41 54                	push   r12
   182f22ef9:	56                   	push   rsi
   182f22efa:	57                   	push   rdi
   182f22efb:	53                   	push   rbx
   182f22efc:	48 81 ec 38 03 00 00 	sub    rsp,0x338
   182f22f03:	48 8d ac 24 80 00 00 	lea    rbp,[rsp+0x80]
   182f22f0a:	00 
   182f22f0b:	0f 29 bd a0 02 00 00 	movaps XMMWORD PTR [rbp+0x2a0],xmm7
   182f22f12:	0f 29 b5 90 02 00 00 	movaps XMMWORD PTR [rbp+0x290],xmm6
   182f22f19:	48 c7 85 88 02 00 00 	mov    QWORD PTR [rbp+0x288],0xfffffffffffffffe
   182f22f20:	fe ff ff ff 
   182f22f24:	4c 89 85 98 01 00 00 	mov    QWORD PTR [rbp+0x198],r8
   182f22f2b:	48 c7 85 70 02 00 00 	mov    QWORD PTR [rbp+0x270],0x1
   182f22f32:	01 00 00 00 
   182f22f36:	49 8b 00             	mov    rax,QWORD PTR [r8]
   182f22f39:	48 85 c0             	test   rax,rax
   182f22f3c:	4c 89 8d 78 02 00 00 	mov    QWORD PTR [rbp+0x278],r9
   182f22f43:	0f 84 fe 00 00 00    	je     0x182f23047
   182f22f49:	4d 89 ce             	mov    r14,r9
   182f22f4c:	49 8b 09             	mov    rcx,QWORD PTR [r9]
   182f22f4f:	48 85 c9             	test   rcx,rcx
   182f22f52:	0f 84 c0 01 00 00    	je     0x182f23118
   182f22f58:	48 8b b0 b0 00 00 00 	mov    rsi,QWORD PTR [rax+0xb0]
   182f22f5f:	48 8b 80 b8 00 00 00 	mov    rax,QWORD PTR [rax+0xb8]
   182f22f66:	48 39 c6             	cmp    rsi,rax
   182f22f69:	0f 84 7a 02 00 00    	je     0x182f231e9
   182f22f6f:	48 29 f0             	sub    rax,rsi
   182f22f72:	48 83 f8 50          	cmp    rax,0x50
   182f22f76:	0f 85 3e 03 00 00    	jne    0x182f232ba
   182f22f7c:	0f 57 c0             	xorps  xmm0,xmm0
   182f22f7f:	0f 29 85 a0 00 00 00 	movaps XMMWORD PTR [rbp+0xa0],xmm0
   182f22f86:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   182f22f89:	48 83 f8 01          	cmp    rax,0x1
   182f22f8d:	49 89 d7             	mov    r15,rdx
   182f22f90:	0f 84 65 07 00 00    	je     0x182f236fb
   182f22f96:	48 83 f8 03          	cmp    rax,0x3
   182f22f9a:	0f 84 11 07 00 00    	je     0x182f236b1
   182f22fa0:	48 83 f8 02          	cmp    rax,0x2
   182f22fa4:	0f 85 e1 07 00 00    	jne    0x182f2378b
   182f22faa:	48 83 c1 68          	add    rcx,0x68
   182f22fae:	48 8d 5e 08          	lea    rbx,[rsi+0x8]
   182f22fb2:	48 89 da             	mov    rdx,rbx
   182f22fb5:	e8 d6 34 00 00       	call   0x182f26490
   182f22fba:	48 85 c0             	test   rax,rax
   182f22fbd:	0f 84 ab 0a 00 00    	je     0x182f23a6e
   182f22fc3:	48 89 c7             	mov    rdi,rax
   182f22fc6:	8b 00                	mov    eax,DWORD PTR [rax]
   182f22fc8:	ff c8                	dec    eax
   182f22fca:	83 f8 07             	cmp    eax,0x7
   182f22fcd:	0f 87 31 16 00 00    	ja     0x182f24604
   182f22fd3:	48 8d 9f 38 02 00 00 	lea    rbx,[rdi+0x238]
   182f22fda:	48 8d 0d 3b 67 4c 06 	lea    rcx,[rip+0x64c673b]        # 0x1893e971c
   182f22fe1:	48 63 04 81          	movsxd rax,DWORD PTR [rcx+rax*4]
   182f22fe5:	48 01 c8             	add    rax,rcx
   182f22fe8:	ff e0                	jmp    rax
   182f22fea:	48 83 bf 98 00 00 00 	cmp    QWORD PTR [rdi+0x98],0x0
   182f22ff1:	00 
   182f22ff2:	0f 84 1d 1e 00 00    	je     0x182f24e15
   182f22ff8:	0f 28 05 b1 2b e2 05 	movaps xmm0,XMMWORD PTR [rip+0x5e22bb1]        # 0x188d45bb0
   182f22fff:	0f 29 85 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm0
   182f23006:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f2300d:	e8 5e 1c 7d fd       	call   0x1806f4c70
   182f23012:	90                   	nop
   182f23013:	48 89 fa             	mov    rdx,rdi
   182f23016:	48 81 c2 88 00 00 00 	add    rdx,0x88
   182f2301d:	48 8b 8d 00 01 00 00 	mov    rcx,QWORD PTR [rbp+0x100]
   182f23024:	c7 81 18 01 00 00 01 	mov    DWORD PTR [rcx+0x118],0x1
   182f2302b:	00 00 00 
   182f2302e:	48 81 c1 58 07 00 00 	add    rcx,0x758
   182f23035:	e8 e6 23 42 fd       	call   0x180345420
   182f2303a:	90                   	nop
   182f2303b:	48 8b 87 98 00 00 00 	mov    rax,QWORD PTR [rdi+0x98]
   182f23042:	e9 00 07 00 00       	jmp    0x182f23747
   182f23047:	b9 04 00 00 00       	mov    ecx,0x4
   182f2304c:	e8 8f 9d 14 fd       	call   0x18006cde0
   182f23051:	bf 02 00 00 00       	mov    edi,0x2
   182f23056:	85 c0                	test   eax,eax
   182f23058:	0f 84 79 03 00 00    	je     0x182f233d7
   182f2305e:	48 8d b5 b0 00 00 00 	lea    rsi,[rbp+0xb0]
   182f23065:	48 89 f1             	mov    rcx,rsi
   182f23068:	e8 a3 9e 14 fd       	call   0x18006cf10
   182f2306d:	90                   	nop
   182f2306e:	48 83 bd c8 00 00 00 	cmp    QWORD PTR [rbp+0xc8],0x10
   182f23075:	10 
   182f23076:	72 07                	jb     0x182f2307f
   182f23078:	48 8b b5 b0 00 00 00 	mov    rsi,QWORD PTR [rbp+0xb0]
   182f2307f:	48 8d 05 fa 64 4c 06 	lea    rax,[rip+0x64c64fa]        # 0x1893e9580
   182f23086:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   182f2308b:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   182f23092:	00 00 
   182f23094:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   182f23099:	c7 44 24 28 3a 01 00 	mov    DWORD PTR [rsp+0x28],0x13a
   182f230a0:	00 
   182f230a1:	4c 8d 0d 58 5f 4c 06 	lea    r9,[rip+0x64c5f58]        # 0x1893e9000
   182f230a8:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f230af:	ba 04 00 00 00       	mov    edx,0x4
   182f230b4:	49 89 f0             	mov    r8,rsi
   182f230b7:	e8 b4 a1 14 fd       	call   0x18006d270
   182f230bc:	90                   	nop
   182f230bd:	0f 57 c0             	xorps  xmm0,xmm0
   182f230c0:	0f 29 85 10 02 00 00 	movaps XMMWORD PTR [rbp+0x210],xmm0
   182f230c7:	0f 29 85 00 02 00 00 	movaps XMMWORD PTR [rbp+0x200],xmm0
   182f230ce:	0f 29 85 f0 01 00 00 	movaps XMMWORD PTR [rbp+0x1f0],xmm0
   182f230d5:	0f 29 85 e0 01 00 00 	movaps XMMWORD PTR [rbp+0x1e0],xmm0
   182f230dc:	0f 29 85 d0 01 00 00 	movaps XMMWORD PTR [rbp+0x1d0],xmm0
   182f230e3:	0f 29 85 c0 01 00 00 	movaps XMMWORD PTR [rbp+0x1c0],xmm0
   182f230ea:	0f 29 85 b0 01 00 00 	movaps XMMWORD PTR [rbp+0x1b0],xmm0
   182f230f1:	0f 29 85 a0 01 00 00 	movaps XMMWORD PTR [rbp+0x1a0],xmm0
   182f230f8:	48 8d 15 21 60 4c 06 	lea    rdx,[rip+0x64c6021]        # 0x1893e9120
   182f230ff:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f23106:	4c 8d 85 a0 01 00 00 	lea    r8,[rbp+0x1a0]
   182f2310d:	e8 fe a6 14 fd       	call   0x18006d810
   182f23112:	90                   	nop
   182f23113:	e9 6e 02 00 00       	jmp    0x182f23386
   182f23118:	b9 04 00 00 00       	mov    ecx,0x4
   182f2311d:	e8 be 9c 14 fd       	call   0x18006cde0
   182f23122:	bf 02 00 00 00       	mov    edi,0x2
   182f23127:	85 c0                	test   eax,eax
   182f23129:	0f 84 a8 02 00 00    	je     0x182f233d7
   182f2312f:	48 8d b5 b0 00 00 00 	lea    rsi,[rbp+0xb0]
   182f23136:	48 89 f1             	mov    rcx,rsi
   182f23139:	e8 d2 9d 14 fd       	call   0x18006cf10
   182f2313e:	90                   	nop
   182f2313f:	48 83 bd c8 00 00 00 	cmp    QWORD PTR [rbp+0xc8],0x10
   182f23146:	10 
   182f23147:	72 07                	jb     0x182f23150
   182f23149:	48 8b b5 b0 00 00 00 	mov    rsi,QWORD PTR [rbp+0xb0]
   182f23150:	48 8d 05 29 64 4c 06 	lea    rax,[rip+0x64c6429]        # 0x1893e9580
   182f23157:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   182f2315c:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   182f23163:	00 00 
   182f23165:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   182f2316a:	c7 44 24 28 3f 01 00 	mov    DWORD PTR [rsp+0x28],0x13f
   182f23171:	00 
   182f23172:	4c 8d 0d 87 5e 4c 06 	lea    r9,[rip+0x64c5e87]        # 0x1893e9000
   182f23179:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f23180:	ba 04 00 00 00       	mov    edx,0x4
   182f23185:	49 89 f0             	mov    r8,rsi
   182f23188:	e8 e3 a0 14 fd       	call   0x18006d270
   182f2318d:	90                   	nop
   182f2318e:	0f 57 c0             	xorps  xmm0,xmm0
   182f23191:	0f 29 85 10 02 00 00 	movaps XMMWORD PTR [rbp+0x210],xmm0
   182f23198:	0f 29 85 00 02 00 00 	movaps XMMWORD PTR [rbp+0x200],xmm0
   182f2319f:	0f 29 85 f0 01 00 00 	movaps XMMWORD PTR [rbp+0x1f0],xmm0
   182f231a6:	0f 29 85 e0 01 00 00 	movaps XMMWORD PTR [rbp+0x1e0],xmm0
   182f231ad:	0f 29 85 d0 01 00 00 	movaps XMMWORD PTR [rbp+0x1d0],xmm0
   182f231b4:	0f 29 85 c0 01 00 00 	movaps XMMWORD PTR [rbp+0x1c0],xmm0
   182f231bb:	0f 29 85 b0 01 00 00 	movaps XMMWORD PTR [rbp+0x1b0],xmm0
   182f231c2:	0f 29 85 a0 01 00 00 	movaps XMMWORD PTR [rbp+0x1a0],xmm0
   182f231c9:	48 8d 15 48 09 4c 06 	lea    rdx,[rip+0x64c0948]        # 0x1893e3b18
   182f231d0:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f231d7:	4c 8d 85 a0 01 00 00 	lea    r8,[rbp+0x1a0]
   182f231de:	e8 2d a6 14 fd       	call   0x18006d810
   182f231e3:	90                   	nop
   182f231e4:	e9 9d 01 00 00       	jmp    0x182f23386
   182f231e9:	b9 04 00 00 00       	mov    ecx,0x4
   182f231ee:	e8 ed 9b 14 fd       	call   0x18006cde0
   182f231f3:	bf 02 00 00 00       	mov    edi,0x2
   182f231f8:	85 c0                	test   eax,eax
   182f231fa:	0f 84 d7 01 00 00    	je     0x182f233d7
   182f23200:	48 8d b5 b0 00 00 00 	lea    rsi,[rbp+0xb0]
   182f23207:	48 89 f1             	mov    rcx,rsi
   182f2320a:	e8 01 9d 14 fd       	call   0x18006cf10
   182f2320f:	90                   	nop
   182f23210:	48 83 bd c8 00 00 00 	cmp    QWORD PTR [rbp+0xc8],0x10
   182f23217:	10 
   182f23218:	72 07                	jb     0x182f23221
   182f2321a:	48 8b b5 b0 00 00 00 	mov    rsi,QWORD PTR [rbp+0xb0]
   182f23221:	48 8d 05 58 63 4c 06 	lea    rax,[rip+0x64c6358]        # 0x1893e9580
   182f23228:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   182f2322d:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   182f23234:	00 00 
   182f23236:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   182f2323b:	c7 44 24 28 46 01 00 	mov    DWORD PTR [rsp+0x28],0x146
   182f23242:	00 
   182f23243:	4c 8d 0d b6 5d 4c 06 	lea    r9,[rip+0x64c5db6]        # 0x1893e9000
   182f2324a:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f23251:	ba 04 00 00 00       	mov    edx,0x4
   182f23256:	49 89 f0             	mov    r8,rsi
   182f23259:	e8 12 a0 14 fd       	call   0x18006d270
   182f2325e:	90                   	nop
   182f2325f:	0f 57 c0             	xorps  xmm0,xmm0
   182f23262:	0f 29 85 10 02 00 00 	movaps XMMWORD PTR [rbp+0x210],xmm0
   182f23269:	0f 29 85 00 02 00 00 	movaps XMMWORD PTR [rbp+0x200],xmm0
   182f23270:	0f 29 85 f0 01 00 00 	movaps XMMWORD PTR [rbp+0x1f0],xmm0
   182f23277:	0f 29 85 e0 01 00 00 	movaps XMMWORD PTR [rbp+0x1e0],xmm0
   182f2327e:	0f 29 85 d0 01 00 00 	movaps XMMWORD PTR [rbp+0x1d0],xmm0
   182f23285:	0f 29 85 c0 01 00 00 	movaps XMMWORD PTR [rbp+0x1c0],xmm0
   182f2328c:	0f 29 85 b0 01 00 00 	movaps XMMWORD PTR [rbp+0x1b0],xmm0
   182f23293:	0f 29 85 a0 01 00 00 	movaps XMMWORD PTR [rbp+0x1a0],xmm0
   182f2329a:	48 8d 15 a7 5d 4c 06 	lea    rdx,[rip+0x64c5da7]        # 0x1893e9048
   182f232a1:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f232a8:	4c 8d 85 a0 01 00 00 	lea    r8,[rbp+0x1a0]
   182f232af:	e8 5c a5 14 fd       	call   0x18006d810
   182f232b4:	90                   	nop
   182f232b5:	e9 cc 00 00 00       	jmp    0x182f23386
   182f232ba:	b9 04 00 00 00       	mov    ecx,0x4
   182f232bf:	e8 1c 9b 14 fd       	call   0x18006cde0
   182f232c4:	bf 08 00 00 00       	mov    edi,0x8
   182f232c9:	85 c0                	test   eax,eax
   182f232cb:	0f 84 06 01 00 00    	je     0x182f233d7
   182f232d1:	48 8d b5 b0 00 00 00 	lea    rsi,[rbp+0xb0]
   182f232d8:	48 89 f1             	mov    rcx,rsi
   182f232db:	e8 30 9c 14 fd       	call   0x18006cf10
   182f232e0:	90                   	nop
   182f232e1:	48 83 bd c8 00 00 00 	cmp    QWORD PTR [rbp+0xc8],0x10
   182f232e8:	10 
   182f232e9:	72 07                	jb     0x182f232f2
   182f232eb:	48 8b b5 b0 00 00 00 	mov    rsi,QWORD PTR [rbp+0xb0]
   182f232f2:	48 8d 05 87 62 4c 06 	lea    rax,[rip+0x64c6287]        # 0x1893e9580
   182f232f9:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   182f232fe:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   182f23305:	00 00 
   182f23307:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   182f2330c:	c7 44 24 28 4c 01 00 	mov    DWORD PTR [rsp+0x28],0x14c
   182f23313:	00 
   182f23314:	4c 8d 0d e5 5c 4c 06 	lea    r9,[rip+0x64c5ce5]        # 0x1893e9000
   182f2331b:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f23322:	ba 04 00 00 00       	mov    edx,0x4
   182f23327:	49 89 f0             	mov    r8,rsi
   182f2332a:	e8 41 9f 14 fd       	call   0x18006d270
   182f2332f:	90                   	nop
   182f23330:	0f 57 c0             	xorps  xmm0,xmm0
   182f23333:	0f 29 85 10 02 00 00 	movaps XMMWORD PTR [rbp+0x210],xmm0
   182f2333a:	0f 29 85 00 02 00 00 	movaps XMMWORD PTR [rbp+0x200],xmm0
   182f23341:	0f 29 85 f0 01 00 00 	movaps XMMWORD PTR [rbp+0x1f0],xmm0
   182f23348:	0f 29 85 e0 01 00 00 	movaps XMMWORD PTR [rbp+0x1e0],xmm0
   182f2334f:	0f 29 85 d0 01 00 00 	movaps XMMWORD PTR [rbp+0x1d0],xmm0
   182f23356:	0f 29 85 c0 01 00 00 	movaps XMMWORD PTR [rbp+0x1c0],xmm0
   182f2335d:	0f 29 85 b0 01 00 00 	movaps XMMWORD PTR [rbp+0x1b0],xmm0
   182f23364:	0f 29 85 a0 01 00 00 	movaps XMMWORD PTR [rbp+0x1a0],xmm0
   182f2336b:	48 8d 15 76 5d 4c 06 	lea    rdx,[rip+0x64c5d76]        # 0x1893e90e8
   182f23372:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f23379:	4c 8d 85 a0 01 00 00 	lea    r8,[rbp+0x1a0]
   182f23380:	e8 8b a4 14 fd       	call   0x18006d810
   182f23385:	90                   	nop
   182f23386:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f2338d:	e8 de 9f 14 fd       	call   0x18006d370
   182f23392:	48 8b 85 c8 00 00 00 	mov    rax,QWORD PTR [rbp+0xc8]
   182f23399:	48 83 f8 10          	cmp    rax,0x10
   182f2339d:	72 38                	jb     0x182f233d7
   182f2339f:	48 8b 8d b0 00 00 00 	mov    rcx,QWORD PTR [rbp+0xb0]
   182f233a6:	48 8d 50 01          	lea    rdx,[rax+0x1]
   182f233aa:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   182f233b1:	72 1f                	jb     0x182f233d2
   182f233b3:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   182f233b7:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   182f233bb:	4c 29 c1             	sub    rcx,r8
   182f233be:	48 83 f9 20          	cmp    rcx,0x20
   182f233c2:	0f 83 1d 1c 00 00    	jae    0x182f24fe5
   182f233c8:	48 83 c0 28          	add    rax,0x28
   182f233cc:	48 89 c2             	mov    rdx,rax
   182f233cf:	4c 89 c1             	mov    rcx,r8
   182f233d2:	e8 09 85 58 04       	call   0x1874ab8e0
   182f233d7:	48 89 bd 70 02 00 00 	mov    QWORD PTR [rbp+0x270],rdi
   182f233de:	b9 04 00 00 00       	mov    ecx,0x4
   182f233e3:	e8 f8 99 14 fd       	call   0x18006cde0
   182f233e8:	85 c0                	test   eax,eax
   182f233ea:	0f 84 4c 01 00 00    	je     0x182f2353c
   182f233f0:	48 8d b5 30 02 00 00 	lea    rsi,[rbp+0x230]
   182f233f7:	48 89 f1             	mov    rcx,rsi
   182f233fa:	e8 11 9b 14 fd       	call   0x18006cf10
   182f233ff:	90                   	nop
   182f23400:	48 83 bd 48 02 00 00 	cmp    QWORD PTR [rbp+0x248],0x10
   182f23407:	10 
   182f23408:	72 07                	jb     0x182f23411
   182f2340a:	48 8b b5 30 02 00 00 	mov    rsi,QWORD PTR [rbp+0x230]
   182f23411:	48 8d 05 68 61 4c 06 	lea    rax,[rip+0x64c6168]        # 0x1893e9580
   182f23418:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   182f2341d:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   182f23424:	00 00 
   182f23426:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   182f2342b:	c7 44 24 28 0c 02 00 	mov    DWORD PTR [rsp+0x28],0x20c
   182f23432:	00 
   182f23433:	4c 8d 0d c6 5b 4c 06 	lea    r9,[rip+0x64c5bc6]        # 0x1893e9000
   182f2343a:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f23441:	ba 04 00 00 00       	mov    edx,0x4
   182f23446:	49 89 f0             	mov    r8,rsi
   182f23449:	e8 22 9e 14 fd       	call   0x18006d270
   182f2344e:	90                   	nop
   182f2344f:	48 c7 85 b0 00 00 00 	mov    QWORD PTR [rbp+0xb0],0x0
   182f23456:	00 00 00 00 
   182f2345a:	44 8b 8d 70 02 00 00 	mov    r9d,DWORD PTR [rbp+0x270]
   182f23461:	48 8d b5 b8 00 00 00 	lea    rsi,[rbp+0xb8]
   182f23468:	4c 8d 05 1d ed e5 05 	lea    r8,[rip+0x5e5ed1d]        # 0x188d8218c
   182f2346f:	ba 41 00 00 00       	mov    edx,0x41
   182f23474:	48 89 f1             	mov    rcx,rsi
   182f23477:	e8 e4 b7 13 fd       	call   0x18005ec60
   182f2347c:	48 89 b5 b0 00 00 00 	mov    QWORD PTR [rbp+0xb0],rsi
   182f23483:	0f 57 c0             	xorps  xmm0,xmm0
   182f23486:	0f 11 85 08 02 00 00 	movups XMMWORD PTR [rbp+0x208],xmm0
   182f2348d:	0f 11 85 f8 01 00 00 	movups XMMWORD PTR [rbp+0x1f8],xmm0
   182f23494:	0f 11 85 e8 01 00 00 	movups XMMWORD PTR [rbp+0x1e8],xmm0
   182f2349b:	0f 11 85 d8 01 00 00 	movups XMMWORD PTR [rbp+0x1d8],xmm0
   182f234a2:	0f 11 85 c8 01 00 00 	movups XMMWORD PTR [rbp+0x1c8],xmm0
   182f234a9:	0f 11 85 b8 01 00 00 	movups XMMWORD PTR [rbp+0x1b8],xmm0
   182f234b0:	0f 11 85 a8 01 00 00 	movups XMMWORD PTR [rbp+0x1a8],xmm0
   182f234b7:	48 c7 85 18 02 00 00 	mov    QWORD PTR [rbp+0x218],0x0
   182f234be:	00 00 00 00 
   182f234c2:	48 8d 85 b0 00 00 00 	lea    rax,[rbp+0xb0]
   182f234c9:	48 89 85 a0 01 00 00 	mov    QWORD PTR [rbp+0x1a0],rax
   182f234d0:	48 8d 15 a9 06 4c 06 	lea    rdx,[rip+0x64c06a9]        # 0x1893e3b80
   182f234d7:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f234de:	4c 8d 85 a0 01 00 00 	lea    r8,[rbp+0x1a0]
   182f234e5:	e8 26 a3 14 fd       	call   0x18006d810
   182f234ea:	90                   	nop
   182f234eb:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f234f2:	e8 79 9e 14 fd       	call   0x18006d370
   182f234f7:	48 8b 85 48 02 00 00 	mov    rax,QWORD PTR [rbp+0x248]
   182f234fe:	48 83 f8 10          	cmp    rax,0x10
   182f23502:	72 38                	jb     0x182f2353c
   182f23504:	48 8b 8d 30 02 00 00 	mov    rcx,QWORD PTR [rbp+0x230]
   182f2350b:	48 8d 50 01          	lea    rdx,[rax+0x1]
   182f2350f:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   182f23516:	72 1f                	jb     0x182f23537
   182f23518:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   182f2351c:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   182f23520:	4c 29 c1             	sub    rcx,r8
   182f23523:	48 83 f9 20          	cmp    rcx,0x20
   182f23527:	0f 83 b8 1a 00 00    	jae    0x182f24fe5
   182f2352d:	48 83 c0 28          	add    rax,0x28
   182f23531:	48 89 c2             	mov    rdx,rax
   182f23534:	4c 89 c1             	mov    rcx,r8
   182f23537:	e8 a4 83 58 04       	call   0x1874ab8e0
   182f2353c:	0f 28 05 6d 26 e2 05 	movaps xmm0,XMMWORD PTR [rip+0x5e2266d]        # 0x188d45bb0
   182f23543:	0f 29 85 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm0
   182f2354a:	b9 28 00 00 00       	mov    ecx,0x28
   182f2354f:	e8 48 83 58 04       	call   0x1874ab89c
   182f23554:	90                   	nop
   182f23555:	48 b9 01 00 00 00 01 	movabs rcx,0x100000001
   182f2355c:	00 00 00 
   182f2355f:	48 89 48 08          	mov    QWORD PTR [rax+0x8],rcx
   182f23563:	48 8d 0d 3e 47 08 06 	lea    rcx,[rip+0x608473e]        # 0x188fa7ca8
   182f2356a:	48 89 08             	mov    QWORD PTR [rax],rcx
   182f2356d:	48 8d 48 10          	lea    rcx,[rax+0x10]
   182f23571:	48 8b 95 70 02 00 00 	mov    rdx,QWORD PTR [rbp+0x270]
   182f23578:	4c 8d 05 b1 45 08 06 	lea    r8,[rip+0x60845b1]        # 0x188fa7b30
   182f2357f:	4c 89 40 10          	mov    QWORD PTR [rax+0x10],r8
   182f23583:	48 c7 40 18 05 00 00 	mov    QWORD PTR [rax+0x18],0x5
   182f2358a:	00 
   182f2358b:	48 89 50 20          	mov    QWORD PTR [rax+0x20],rdx
   182f2358f:	48 89 8d 00 01 00 00 	mov    QWORD PTR [rbp+0x100],rcx
   182f23596:	48 89 85 08 01 00 00 	mov    QWORD PTR [rbp+0x108],rax
   182f2359d:	0f 57 c0             	xorps  xmm0,xmm0
   182f235a0:	0f 29 45 70          	movaps XMMWORD PTR [rbp+0x70],xmm0
   182f235a4:	48 85 c0             	test   rax,rax
   182f235a7:	74 14                	je     0x182f235bd
   182f235a9:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   182f235ad:	48 8b 8d 00 01 00 00 	mov    rcx,QWORD PTR [rbp+0x100]
   182f235b4:	48 8b 85 08 01 00 00 	mov    rax,QWORD PTR [rbp+0x108]
   182f235bb:	eb 02                	jmp    0x182f235bf
   182f235bd:	31 c0                	xor    eax,eax
   182f235bf:	48 8b 95 98 01 00 00 	mov    rdx,QWORD PTR [rbp+0x198]
   182f235c6:	48 89 4d 70          	mov    QWORD PTR [rbp+0x70],rcx
   182f235ca:	48 89 45 78          	mov    QWORD PTR [rbp+0x78],rax
   182f235ce:	0f 29 85 80 00 00 00 	movaps XMMWORD PTR [rbp+0x80],xmm0
   182f235d5:	48 8b 42 08          	mov    rax,QWORD PTR [rdx+0x8]
   182f235d9:	48 85 c0             	test   rax,rax
   182f235dc:	74 0a                	je     0x182f235e8
   182f235de:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   182f235e2:	48 8b 42 08          	mov    rax,QWORD PTR [rdx+0x8]
   182f235e6:	eb 02                	jmp    0x182f235ea
   182f235e8:	31 c0                	xor    eax,eax
   182f235ea:	48 8b 0a             	mov    rcx,QWORD PTR [rdx]
   182f235ed:	48 89 8d 80 00 00 00 	mov    QWORD PTR [rbp+0x80],rcx
   182f235f4:	48 89 85 88 00 00 00 	mov    QWORD PTR [rbp+0x88],rax
   182f235fb:	48 8d 8d 80 00 00 00 	lea    rcx,[rbp+0x80]
   182f23602:	48 8d 55 70          	lea    rdx,[rbp+0x70]
   182f23606:	e8 e5 72 fc ff       	call   0x182eea8f0
   182f2360b:	90                   	nop
   182f2360c:	48 8b b5 08 01 00 00 	mov    rsi,QWORD PTR [rbp+0x108]
   182f23613:	48 85 f6             	test   rsi,rsi
   182f23616:	74 1d                	je     0x182f23635
   182f23618:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   182f2361c:	75 17                	jne    0x182f23635
   182f2361e:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   182f23621:	48 89 f1             	mov    rcx,rsi
   182f23624:	ff 10                	call   QWORD PTR [rax]
   182f23626:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   182f2362a:	75 09                	jne    0x182f23635
   182f2362c:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   182f2362f:	48 89 f1             	mov    rcx,rsi
   182f23632:	ff 50 08             	call   QWORD PTR [rax+0x8]
   182f23635:	4c 8b b5 78 02 00 00 	mov    r14,QWORD PTR [rbp+0x278]
   182f2363c:	48 8b bd 98 01 00 00 	mov    rdi,QWORD PTR [rbp+0x198]
   182f23643:	48 8b 77 08          	mov    rsi,QWORD PTR [rdi+0x8]
   182f23647:	48 85 f6             	test   rsi,rsi
   182f2364a:	74 1d                	je     0x182f23669
   182f2364c:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   182f23650:	75 17                	jne    0x182f23669
   182f23652:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   182f23655:	48 89 f1             	mov    rcx,rsi
   182f23658:	ff 10                	call   QWORD PTR [rax]
   182f2365a:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   182f2365e:	75 09                	jne    0x182f23669
   182f23660:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   182f23663:	48 89 f1             	mov    rcx,rsi
   182f23666:	ff 50 08             	call   QWORD PTR [rax+0x8]
   182f23669:	49 8b 76 08          	mov    rsi,QWORD PTR [r14+0x8]
   182f2366d:	48 85 f6             	test   rsi,rsi
   182f23670:	74 1d                	je     0x182f2368f
   182f23672:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   182f23676:	75 17                	jne    0x182f2368f
   182f23678:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   182f2367b:	48 89 f1             	mov    rcx,rsi
   182f2367e:	ff 10                	call   QWORD PTR [rax]
   182f23680:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   182f23684:	75 09                	jne    0x182f2368f
   182f23686:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   182f23689:	48 89 f1             	mov    rcx,rsi
   182f2368c:	ff 50 08             	call   QWORD PTR [rax+0x8]
   182f2368f:	0f 28 b5 90 02 00 00 	movaps xmm6,XMMWORD PTR [rbp+0x290]
   182f23696:	0f 28 bd a0 02 00 00 	movaps xmm7,XMMWORD PTR [rbp+0x2a0]
   182f2369d:	48 81 c4 38 03 00 00 	add    rsp,0x338
   182f236a4:	5b                   	pop    rbx
   182f236a5:	5f                   	pop    rdi
   182f236a6:	5e                   	pop    rsi
   182f236a7:	41 5c                	pop    r12
   182f236a9:	41 5d                	pop    r13
   182f236ab:	41 5e                	pop    r14
   182f236ad:	41 5f                	pop    r15
   182f236af:	5d                   	pop    rbp
   182f236b0:	c3                   	ret
   182f236b1:	48 83 7e 18 00       	cmp    QWORD PTR [rsi+0x18],0x0
   182f236b6:	0f 84 07 02 00 00    	je     0x182f238c3
   182f236bc:	0f 28 05 ed 24 e2 05 	movaps xmm0,XMMWORD PTR [rip+0x5e224ed]        # 0x188d45bb0
   182f236c3:	0f 29 85 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm0
   182f236ca:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f236d1:	e8 9a 15 7d fd       	call   0x1806f4c70
   182f236d6:	90                   	nop
   182f236d7:	48 8d 56 08          	lea    rdx,[rsi+0x8]
   182f236db:	48 8b 8d 00 01 00 00 	mov    rcx,QWORD PTR [rbp+0x100]
   182f236e2:	c7 81 18 01 00 00 01 	mov    DWORD PTR [rcx+0x118],0x1
   182f236e9:	00 00 00 
   182f236ec:	48 81 c1 58 07 00 00 	add    rcx,0x758
   182f236f3:	e8 28 1d 42 fd       	call   0x180345420
   182f236f8:	90                   	nop
   182f236f9:	eb 48                	jmp    0x182f23743
   182f236fb:	48 83 7e 18 00       	cmp    QWORD PTR [rsi+0x18],0x0
   182f23700:	0f 84 89 02 00 00    	je     0x182f2398f
   182f23706:	0f 28 05 a3 24 e2 05 	movaps xmm0,XMMWORD PTR [rip+0x5e224a3]        # 0x188d45bb0
   182f2370d:	0f 29 85 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm0
   182f23714:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f2371b:	e8 50 15 7d fd       	call   0x1806f4c70
   182f23720:	90                   	nop
   182f23721:	48 8d 56 08          	lea    rdx,[rsi+0x8]
   182f23725:	48 8b 8d 00 01 00 00 	mov    rcx,QWORD PTR [rbp+0x100]
   182f2372c:	c7 81 18 01 00 00 01 	mov    DWORD PTR [rcx+0x118],0x1
   182f23733:	00 00 00 
   182f23736:	48 81 c1 58 07 00 00 	add    rcx,0x758
   182f2373d:	e8 de 1c 42 fd       	call   0x180345420
   182f23742:	90                   	nop
   182f23743:	48 8b 46 18          	mov    rax,QWORD PTR [rsi+0x18]
   182f23747:	48 8b 8d 00 01 00 00 	mov    rcx,QWORD PTR [rbp+0x100]
   182f2374e:	48 89 81 c8 01 00 00 	mov    QWORD PTR [rcx+0x1c8],rax
   182f23755:	48 8d 8d a0 00 00 00 	lea    rcx,[rbp+0xa0]
   182f2375c:	48 8d bd 00 01 00 00 	lea    rdi,[rbp+0x100]
   182f23763:	48 89 fa             	mov    rdx,rdi
   182f23766:	e8 d5 c0 7f fd       	call   0x18071f840
   182f2376b:	48 89 f9             	mov    rcx,rdi
   182f2376e:	e8 ed e8 0d fd       	call   0x180002060
   182f23773:	b8 01 00 00 00       	mov    eax,0x1
   182f23778:	48 89 85 68 02 00 00 	mov    QWORD PTR [rbp+0x268],rax
   182f2377f:	4c 8b b5 78 02 00 00 	mov    r14,QWORD PTR [rbp+0x278]
   182f23786:	e9 0b 04 00 00       	jmp    0x182f23b96
   182f2378b:	b9 04 00 00 00       	mov    ecx,0x4
   182f23790:	e8 4b 96 14 fd       	call   0x18006cde0
   182f23795:	85 c0                	test   eax,eax
   182f23797:	0f 84 16 01 00 00    	je     0x182f238b3
   182f2379d:	48 8d bd 30 02 00 00 	lea    rdi,[rbp+0x230]
   182f237a4:	48 89 f9             	mov    rcx,rdi
   182f237a7:	e8 64 97 14 fd       	call   0x18006cf10
   182f237ac:	90                   	nop
   182f237ad:	48 83 bd 48 02 00 00 	cmp    QWORD PTR [rbp+0x248],0x10
   182f237b4:	10 
   182f237b5:	72 07                	jb     0x182f237be
   182f237b7:	48 8b bd 30 02 00 00 	mov    rdi,QWORD PTR [rbp+0x230]
   182f237be:	48 8d 05 bb 5d 4c 06 	lea    rax,[rip+0x64c5dbb]        # 0x1893e9580
   182f237c5:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   182f237ca:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   182f237d1:	00 00 
   182f237d3:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   182f237d8:	c7 44 24 28 db 01 00 	mov    DWORD PTR [rsp+0x28],0x1db
   182f237df:	00 
   182f237e0:	4c 8d 0d 19 58 4c 06 	lea    r9,[rip+0x64c5819]        # 0x1893e9000
   182f237e7:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f237ee:	ba 04 00 00 00       	mov    edx,0x4
   182f237f3:	49 89 f8             	mov    r8,rdi
   182f237f6:	e8 75 9a 14 fd       	call   0x18006d270
   182f237fb:	90                   	nop
   182f237fc:	48 c7 85 b0 00 00 00 	mov    QWORD PTR [rbp+0xb0],0x0
   182f23803:	00 00 00 00 
   182f23807:	44 8b 0e             	mov    r9d,DWORD PTR [rsi]
   182f2380a:	48 8d bd b8 00 00 00 	lea    rdi,[rbp+0xb8]
   182f23811:	4c 8d 05 74 e9 e5 05 	lea    r8,[rip+0x5e5e974]        # 0x188d8218c
   182f23818:	ba 41 00 00 00       	mov    edx,0x41
   182f2381d:	48 89 f9             	mov    rcx,rdi
   182f23820:	e8 3b b4 13 fd       	call   0x18005ec60
   182f23825:	48 89 bd b0 00 00 00 	mov    QWORD PTR [rbp+0xb0],rdi
   182f2382c:	0f 57 c0             	xorps  xmm0,xmm0
   182f2382f:	0f 11 85 08 02 00 00 	movups XMMWORD PTR [rbp+0x208],xmm0
   182f23836:	0f 11 85 f8 01 00 00 	movups XMMWORD PTR [rbp+0x1f8],xmm0
   182f2383d:	0f 11 85 e8 01 00 00 	movups XMMWORD PTR [rbp+0x1e8],xmm0
   182f23844:	0f 11 85 d8 01 00 00 	movups XMMWORD PTR [rbp+0x1d8],xmm0
   182f2384b:	0f 11 85 c8 01 00 00 	movups XMMWORD PTR [rbp+0x1c8],xmm0
   182f23852:	0f 11 85 b8 01 00 00 	movups XMMWORD PTR [rbp+0x1b8],xmm0
   182f23859:	0f 11 85 a8 01 00 00 	movups XMMWORD PTR [rbp+0x1a8],xmm0
   182f23860:	48 c7 85 18 02 00 00 	mov    QWORD PTR [rbp+0x218],0x0
   182f23867:	00 00 00 00 
   182f2386b:	48 8d 85 b0 00 00 00 	lea    rax,[rbp+0xb0]
   182f23872:	48 89 85 a0 01 00 00 	mov    QWORD PTR [rbp+0x1a0],rax
   182f23879:	48 8d 15 d0 5c 4c 06 	lea    rdx,[rip+0x64c5cd0]        # 0x1893e9550
   182f23880:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f23887:	4c 8d 85 a0 01 00 00 	lea    r8,[rbp+0x1a0]
   182f2388e:	e8 7d 9f 14 fd       	call   0x18006d810
   182f23893:	90                   	nop
   182f23894:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f2389b:	e8 d0 9a 14 fd       	call   0x18006d370
   182f238a0:	48 8d 8d 30 02 00 00 	lea    rcx,[rbp+0x230]
   182f238a7:	e8 64 e7 0d fd       	call   0x180002010
   182f238ac:	4c 8b b5 78 02 00 00 	mov    r14,QWORD PTR [rbp+0x278]
   182f238b3:	48 c7 85 70 02 00 00 	mov    QWORD PTR [rbp+0x270],0x8
   182f238ba:	08 00 00 00 
   182f238be:	e9 c7 02 00 00       	jmp    0x182f23b8a
   182f238c3:	b9 04 00 00 00       	mov    ecx,0x4
   182f238c8:	e8 13 95 14 fd       	call   0x18006cde0
   182f238cd:	85 c0                	test   eax,eax
   182f238cf:	0f 84 aa 02 00 00    	je     0x182f23b7f
   182f238d5:	48 8d bd b0 00 00 00 	lea    rdi,[rbp+0xb0]
   182f238dc:	48 89 f9             	mov    rcx,rdi
   182f238df:	e8 2c 96 14 fd       	call   0x18006cf10
   182f238e4:	90                   	nop
   182f238e5:	48 83 bd c8 00 00 00 	cmp    QWORD PTR [rbp+0xc8],0x10
   182f238ec:	10 
   182f238ed:	72 07                	jb     0x182f238f6
   182f238ef:	48 8b bd b0 00 00 00 	mov    rdi,QWORD PTR [rbp+0xb0]
   182f238f6:	48 8d 05 83 5c 4c 06 	lea    rax,[rip+0x64c5c83]        # 0x1893e9580
   182f238fd:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   182f23902:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   182f23909:	00 00 
   182f2390b:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   182f23910:	c7 44 24 28 c1 01 00 	mov    DWORD PTR [rsp+0x28],0x1c1
   182f23917:	00 
   182f23918:	4c 8d 0d e1 56 4c 06 	lea    r9,[rip+0x64c56e1]        # 0x1893e9000
   182f2391f:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f23926:	ba 04 00 00 00       	mov    edx,0x4
   182f2392b:	49 89 f8             	mov    r8,rdi
   182f2392e:	e8 3d 99 14 fd       	call   0x18006d270
   182f23933:	90                   	nop
   182f23934:	0f 57 c0             	xorps  xmm0,xmm0
   182f23937:	0f 29 85 10 02 00 00 	movaps XMMWORD PTR [rbp+0x210],xmm0
   182f2393e:	0f 29 85 00 02 00 00 	movaps XMMWORD PTR [rbp+0x200],xmm0
   182f23945:	0f 29 85 f0 01 00 00 	movaps XMMWORD PTR [rbp+0x1f0],xmm0
   182f2394c:	0f 29 85 e0 01 00 00 	movaps XMMWORD PTR [rbp+0x1e0],xmm0
   182f23953:	0f 29 85 d0 01 00 00 	movaps XMMWORD PTR [rbp+0x1d0],xmm0
   182f2395a:	0f 29 85 c0 01 00 00 	movaps XMMWORD PTR [rbp+0x1c0],xmm0
   182f23961:	0f 29 85 b0 01 00 00 	movaps XMMWORD PTR [rbp+0x1b0],xmm0
   182f23968:	0f 29 85 a0 01 00 00 	movaps XMMWORD PTR [rbp+0x1a0],xmm0
   182f2396f:	48 8d 15 ba 5b 4c 06 	lea    rdx,[rip+0x64c5bba]        # 0x1893e9530
   182f23976:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f2397d:	4c 8d 85 a0 01 00 00 	lea    r8,[rbp+0x1a0]
   182f23984:	e8 87 9e 14 fd       	call   0x18006d810
   182f23989:	90                   	nop
   182f2398a:	e9 c7 00 00 00       	jmp    0x182f23a56
   182f2398f:	b9 04 00 00 00       	mov    ecx,0x4
   182f23994:	e8 47 94 14 fd       	call   0x18006cde0
   182f23999:	85 c0                	test   eax,eax
   182f2399b:	0f 84 de 01 00 00    	je     0x182f23b7f
   182f239a1:	48 8d bd b0 00 00 00 	lea    rdi,[rbp+0xb0]
   182f239a8:	48 89 f9             	mov    rcx,rdi
   182f239ab:	e8 60 95 14 fd       	call   0x18006cf10
   182f239b0:	90                   	nop
   182f239b1:	48 83 bd c8 00 00 00 	cmp    QWORD PTR [rbp+0xc8],0x10
   182f239b8:	10 
   182f239b9:	72 07                	jb     0x182f239c2
   182f239bb:	48 8b bd b0 00 00 00 	mov    rdi,QWORD PTR [rbp+0xb0]
   182f239c2:	48 8d 05 b7 5b 4c 06 	lea    rax,[rip+0x64c5bb7]        # 0x1893e9580
   182f239c9:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   182f239ce:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   182f239d5:	00 00 
   182f239d7:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   182f239dc:	c7 44 24 28 cf 01 00 	mov    DWORD PTR [rsp+0x28],0x1cf
   182f239e3:	00 
   182f239e4:	4c 8d 0d 15 56 4c 06 	lea    r9,[rip+0x64c5615]        # 0x1893e9000
   182f239eb:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f239f2:	ba 04 00 00 00       	mov    edx,0x4
   182f239f7:	49 89 f8             	mov    r8,rdi
   182f239fa:	e8 71 98 14 fd       	call   0x18006d270
   182f239ff:	90                   	nop
   182f23a00:	0f 57 c0             	xorps  xmm0,xmm0
   182f23a03:	0f 29 85 10 02 00 00 	movaps XMMWORD PTR [rbp+0x210],xmm0
   182f23a0a:	0f 29 85 00 02 00 00 	movaps XMMWORD PTR [rbp+0x200],xmm0
   182f23a11:	0f 29 85 f0 01 00 00 	movaps XMMWORD PTR [rbp+0x1f0],xmm0
   182f23a18:	0f 29 85 e0 01 00 00 	movaps XMMWORD PTR [rbp+0x1e0],xmm0
   182f23a1f:	0f 29 85 d0 01 00 00 	movaps XMMWORD PTR [rbp+0x1d0],xmm0
   182f23a26:	0f 29 85 c0 01 00 00 	movaps XMMWORD PTR [rbp+0x1c0],xmm0
   182f23a2d:	0f 29 85 b0 01 00 00 	movaps XMMWORD PTR [rbp+0x1b0],xmm0
   182f23a34:	0f 29 85 a0 01 00 00 	movaps XMMWORD PTR [rbp+0x1a0],xmm0
   182f23a3b:	48 8d 15 b6 5b 4c 06 	lea    rdx,[rip+0x64c5bb6]        # 0x1893e95f8
   182f23a42:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f23a49:	4c 8d 85 a0 01 00 00 	lea    r8,[rbp+0x1a0]
   182f23a50:	e8 bb 9d 14 fd       	call   0x18006d810
   182f23a55:	90                   	nop
   182f23a56:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f23a5d:	e8 0e 99 14 fd       	call   0x18006d370
   182f23a62:	48 8d 8d b0 00 00 00 	lea    rcx,[rbp+0xb0]
   182f23a69:	e9 05 01 00 00       	jmp    0x182f23b73
   182f23a6e:	b9 04 00 00 00       	mov    ecx,0x4
   182f23a73:	e8 68 93 14 fd       	call   0x18006cde0
   182f23a78:	85 c0                	test   eax,eax
   182f23a7a:	0f 84 ff 00 00 00    	je     0x182f23b7f
   182f23a80:	48 8d bd 30 02 00 00 	lea    rdi,[rbp+0x230]
   182f23a87:	48 89 f9             	mov    rcx,rdi
   182f23a8a:	e8 81 94 14 fd       	call   0x18006cf10
   182f23a8f:	90                   	nop
   182f23a90:	48 83 bd 48 02 00 00 	cmp    QWORD PTR [rbp+0x248],0x10
   182f23a97:	10 
   182f23a98:	72 07                	jb     0x182f23aa1
   182f23a9a:	48 8b bd 30 02 00 00 	mov    rdi,QWORD PTR [rbp+0x230]
   182f23aa1:	48 8d 05 d8 5a 4c 06 	lea    rax,[rip+0x64c5ad8]        # 0x1893e9580
   182f23aa8:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   182f23aad:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   182f23ab4:	00 00 
   182f23ab6:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   182f23abb:	c7 44 24 28 58 01 00 	mov    DWORD PTR [rsp+0x28],0x158
   182f23ac2:	00 
   182f23ac3:	4c 8d 0d 36 55 4c 06 	lea    r9,[rip+0x64c5536]        # 0x1893e9000
   182f23aca:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f23ad1:	ba 04 00 00 00       	mov    edx,0x4
   182f23ad6:	49 89 f8             	mov    r8,rdi
   182f23ad9:	e8 92 97 14 fd       	call   0x18006d270
   182f23ade:	90                   	nop
   182f23adf:	48 83 7e 20 10       	cmp    QWORD PTR [rsi+0x20],0x10
   182f23ae4:	72 04                	jb     0x182f23aea
   182f23ae6:	48 8b 5e 08          	mov    rbx,QWORD PTR [rsi+0x8]
   182f23aea:	48 89 9d b0 00 00 00 	mov    QWORD PTR [rbp+0xb0],rbx
   182f23af1:	c6 85 b8 00 00 00 00 	mov    BYTE PTR [rbp+0xb8],0x0
   182f23af8:	0f 57 c0             	xorps  xmm0,xmm0
   182f23afb:	0f 11 85 08 02 00 00 	movups XMMWORD PTR [rbp+0x208],xmm0
   182f23b02:	0f 11 85 f8 01 00 00 	movups XMMWORD PTR [rbp+0x1f8],xmm0
   182f23b09:	0f 11 85 e8 01 00 00 	movups XMMWORD PTR [rbp+0x1e8],xmm0
   182f23b10:	0f 11 85 d8 01 00 00 	movups XMMWORD PTR [rbp+0x1d8],xmm0
   182f23b17:	0f 11 85 c8 01 00 00 	movups XMMWORD PTR [rbp+0x1c8],xmm0
   182f23b1e:	0f 11 85 b8 01 00 00 	movups XMMWORD PTR [rbp+0x1b8],xmm0
   182f23b25:	0f 11 85 a8 01 00 00 	movups XMMWORD PTR [rbp+0x1a8],xmm0
   182f23b2c:	48 c7 85 18 02 00 00 	mov    QWORD PTR [rbp+0x218],0x0
   182f23b33:	00 00 00 00 
   182f23b37:	48 8d 85 b0 00 00 00 	lea    rax,[rbp+0xb0]
   182f23b3e:	48 89 85 a0 01 00 00 	mov    QWORD PTR [rbp+0x1a0],rax
   182f23b45:	48 8d 15 84 19 4c 06 	lea    rdx,[rip+0x64c1984]        # 0x1893e54d0
   182f23b4c:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f23b53:	4c 8d 85 a0 01 00 00 	lea    r8,[rbp+0x1a0]
   182f23b5a:	e8 b1 9c 14 fd       	call   0x18006d810
   182f23b5f:	90                   	nop
   182f23b60:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f23b67:	e8 04 98 14 fd       	call   0x18006d370
   182f23b6c:	48 8d 8d 30 02 00 00 	lea    rcx,[rbp+0x230]
   182f23b73:	e8 98 e4 0d fd       	call   0x180002010
   182f23b78:	4c 8b b5 78 02 00 00 	mov    r14,QWORD PTR [rbp+0x278]
   182f23b7f:	48 c7 85 70 02 00 00 	mov    QWORD PTR [rbp+0x270],0x2
   182f23b86:	02 00 00 00 
   182f23b8a:	b8 03 00 00 00       	mov    eax,0x3
   182f23b8f:	48 89 85 68 02 00 00 	mov    QWORD PTR [rbp+0x268],rax
   182f23b96:	48 83 bd a0 00 00 00 	cmp    QWORD PTR [rbp+0xa0],0x0
   182f23b9d:	00 
   182f23b9e:	0f 84 de 01 00 00    	je     0x182f23d82
   182f23ba4:	48 8b 85 98 01 00 00 	mov    rax,QWORD PTR [rbp+0x198]
   182f23bab:	4c 8b 28             	mov    r13,QWORD PTR [rax]
   182f23bae:	41 0f 10 b5 c8 00 00 	movups xmm6,XMMWORD PTR [r13+0xc8]
   182f23bb5:	00 
   182f23bb6:	41 0f 10 bd d8 00 00 	movups xmm7,XMMWORD PTR [r13+0xd8]
   182f23bbd:	00 
   182f23bbe:	45 8a a5 e8 00 00 00 	mov    r12b,BYTE PTR [r13+0xe8]
   182f23bc5:	48 8d 8d b0 00 00 00 	lea    rcx,[rbp+0xb0]
   182f23bcc:	e8 4f 36 12 fd       	call   0x180047220
   182f23bd1:	90                   	nop
   182f23bd2:	48 8b 8d b0 00 00 00 	mov    rcx,QWORD PTR [rbp+0xb0]
   182f23bd9:	48 8d bd a0 01 00 00 	lea    rdi,[rbp+0x1a0]
   182f23be0:	48 89 fa             	mov    rdx,rdi
   182f23be3:	e8 58 8b 44 fd       	call   0x18036c740
   182f23be8:	90                   	nop
   182f23be9:	48 8b 8d a0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1a0]
   182f23bf0:	48 8d 95 00 01 00 00 	lea    rdx,[rbp+0x100]
   182f23bf7:	e8 e4 5c 47 fd       	call   0x1803998e0
   182f23bfc:	90                   	nop
   182f23bfd:	49 8d 5d 60          	lea    rbx,[r13+0x60]
   182f23c01:	48 8b 8d 00 01 00 00 	mov    rcx,QWORD PTR [rbp+0x100]
   182f23c08:	48 89 da             	mov    rdx,rbx
   182f23c0b:	41 b0 01             	mov    r8b,0x1
   182f23c0e:	45 31 c9             	xor    r9d,r9d
   182f23c11:	e8 1a 56 03 fe       	call   0x180f59230
   182f23c16:	90                   	nop
   182f23c17:	4c 8b b5 08 01 00 00 	mov    r14,QWORD PTR [rbp+0x108]
   182f23c1e:	4d 85 f6             	test   r14,r14
   182f23c21:	4c 89 f8             	mov    rax,r15
   182f23c24:	74 25                	je     0x182f23c4b
   182f23c26:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   182f23c2b:	75 1e                	jne    0x182f23c4b
   182f23c2d:	49 8b 06             	mov    rax,QWORD PTR [r14]
   182f23c30:	4c 89 f1             	mov    rcx,r14
   182f23c33:	ff 10                	call   QWORD PTR [rax]
   182f23c35:	4c 89 f8             	mov    rax,r15
   182f23c38:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   182f23c3d:	75 0c                	jne    0x182f23c4b
   182f23c3f:	49 8b 06             	mov    rax,QWORD PTR [r14]
   182f23c42:	4c 89 f1             	mov    rcx,r14
   182f23c45:	ff 50 08             	call   QWORD PTR [rax+0x8]
   182f23c48:	4c 89 f8             	mov    rax,r15
   182f23c4b:	4c 8b b5 a8 01 00 00 	mov    r14,QWORD PTR [rbp+0x1a8]
   182f23c52:	4d 85 f6             	test   r14,r14
   182f23c55:	74 25                	je     0x182f23c7c
   182f23c57:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   182f23c5c:	75 1e                	jne    0x182f23c7c
   182f23c5e:	49 8b 06             	mov    rax,QWORD PTR [r14]
   182f23c61:	4c 89 f1             	mov    rcx,r14
   182f23c64:	ff 10                	call   QWORD PTR [rax]
   182f23c66:	4c 89 f8             	mov    rax,r15
   182f23c69:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   182f23c6e:	75 0c                	jne    0x182f23c7c
   182f23c70:	49 8b 06             	mov    rax,QWORD PTR [r14]
   182f23c73:	4c 89 f1             	mov    rcx,r14
   182f23c76:	ff 50 08             	call   QWORD PTR [rax+0x8]
   182f23c79:	4c 89 f8             	mov    rax,r15
   182f23c7c:	0f c6 f7 88          	shufps xmm6,xmm7,0x88
   182f23c80:	4c 8b b5 b8 00 00 00 	mov    r14,QWORD PTR [rbp+0xb8]
   182f23c87:	4d 85 f6             	test   r14,r14
   182f23c8a:	74 25                	je     0x182f23cb1
   182f23c8c:	f0 41 ff 4e 08       	lock dec DWORD PTR [r14+0x8]
   182f23c91:	75 1e                	jne    0x182f23cb1
   182f23c93:	49 8b 06             	mov    rax,QWORD PTR [r14]
   182f23c96:	4c 89 f1             	mov    rcx,r14
   182f23c99:	ff 10                	call   QWORD PTR [rax]
   182f23c9b:	4c 89 f8             	mov    rax,r15
   182f23c9e:	f0 41 ff 4e 0c       	lock dec DWORD PTR [r14+0xc]
   182f23ca3:	75 0c                	jne    0x182f23cb1
   182f23ca5:	49 8b 06             	mov    rax,QWORD PTR [r14]
   182f23ca8:	4c 89 f1             	mov    rcx,r14
   182f23cab:	ff 50 08             	call   QWORD PTR [rax+0x8]
   182f23cae:	4c 89 f8             	mov    rax,r15
   182f23cb1:	48 b9 aa aa aa aa aa 	movabs rcx,0xaaaaaaaaaaaaaaaa
   182f23cb8:	aa aa aa 
   182f23cbb:	48 89 8d c8 00 00 00 	mov    QWORD PTR [rbp+0xc8],rcx
   182f23cc2:	48 89 85 b0 00 00 00 	mov    QWORD PTR [rbp+0xb0],rax
   182f23cc9:	0f 11 b5 b8 00 00 00 	movups XMMWORD PTR [rbp+0xb8],xmm6
   182f23cd0:	44 88 a5 c8 00 00 00 	mov    BYTE PTR [rbp+0xc8],r12b
   182f23cd7:	0f 28 35 d2 1e e2 05 	movaps xmm6,XMMWORD PTR [rip+0x5e21ed2]        # 0x188d45bb0
   182f23cde:	0f 29 b5 50 02 00 00 	movaps XMMWORD PTR [rbp+0x250],xmm6
   182f23ce5:	e8 26 20 12 fd       	call   0x180045d10
   182f23cea:	90                   	nop
   182f23ceb:	4c 8b 00             	mov    r8,QWORD PTR [rax]
   182f23cee:	48 8d 95 30 02 00 00 	lea    rdx,[rbp+0x230]
   182f23cf5:	48 89 c1             	mov    rcx,rax
   182f23cf8:	41 ff 50 58          	call   QWORD PTR [r8+0x58]
   182f23cfc:	90                   	nop
   182f23cfd:	4c 8b b5 30 02 00 00 	mov    r14,QWORD PTR [rbp+0x230]
   182f23d04:	0f 57 c0             	xorps  xmm0,xmm0
   182f23d07:	0f 29 85 10 01 00 00 	movaps XMMWORD PTR [rbp+0x110],xmm0
   182f23d0e:	0f 29 85 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm0
   182f23d15:	4d 8b 7d 70          	mov    r15,QWORD PTR [r13+0x70]
   182f23d19:	49 83 7d 78 10       	cmp    QWORD PTR [r13+0x78],0x10
   182f23d1e:	49 89 dc             	mov    r12,rbx
   182f23d21:	72 04                	jb     0x182f23d27
   182f23d23:	4d 8b 65 60          	mov    r12,QWORD PTR [r13+0x60]
   182f23d27:	4d 85 ff             	test   r15,r15
   182f23d2a:	0f 88 bb 12 00 00    	js     0x182f24feb
   182f23d30:	49 83 ff 0f          	cmp    r15,0xf
   182f23d34:	0f 86 3e 01 00 00    	jbe    0x182f23e78
   182f23d3a:	4c 89 f8             	mov    rax,r15
   182f23d3d:	48 83 c8 0f          	or     rax,0xf
   182f23d41:	48 83 f8 17          	cmp    rax,0x17
   182f23d45:	41 bd 16 00 00 00    	mov    r13d,0x16
   182f23d4b:	4c 0f 43 e8          	cmovae r13,rax
   182f23d4f:	48 3d ff 0f 00 00    	cmp    rax,0xfff
   182f23d55:	0f 82 3d 01 00 00    	jb     0x182f23e98
   182f23d5b:	49 8d 4d 28          	lea    rcx,[r13+0x28]
   182f23d5f:	e8 38 7b 58 04       	call   0x1874ab89c
   182f23d64:	90                   	nop
   182f23d65:	48 85 c0             	test   rax,rax
   182f23d68:	0f 84 77 12 00 00    	je     0x182f24fe5
   182f23d6e:	48 89 c1             	mov    rcx,rax
   182f23d71:	48 83 c0 27          	add    rax,0x27
   182f23d75:	48 83 e0 e0          	and    rax,0xffffffffffffffe0
   182f23d79:	48 89 48 f8          	mov    QWORD PTR [rax-0x8],rcx
   182f23d7d:	e9 20 01 00 00       	jmp    0x182f23ea2
   182f23d82:	b9 04 00 00 00       	mov    ecx,0x4
   182f23d87:	e8 54 90 14 fd       	call   0x18006cde0
   182f23d8c:	85 c0                	test   eax,eax
   182f23d8e:	0f 84 d4 00 00 00    	je     0x182f23e68
   182f23d94:	48 8d b5 b0 00 00 00 	lea    rsi,[rbp+0xb0]
   182f23d9b:	48 89 f1             	mov    rcx,rsi
   182f23d9e:	e8 6d 91 14 fd       	call   0x18006cf10
   182f23da3:	90                   	nop
   182f23da4:	48 83 bd c8 00 00 00 	cmp    QWORD PTR [rbp+0xc8],0x10
   182f23dab:	10 
   182f23dac:	72 07                	jb     0x182f23db5
   182f23dae:	48 8b b5 b0 00 00 00 	mov    rsi,QWORD PTR [rbp+0xb0]
   182f23db5:	48 8d 05 c4 57 4c 06 	lea    rax,[rip+0x64c57c4]        # 0x1893e9580
   182f23dbc:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   182f23dc1:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   182f23dc8:	00 00 
   182f23dca:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   182f23dcf:	c7 44 24 28 e2 01 00 	mov    DWORD PTR [rsp+0x28],0x1e2
   182f23dd6:	00 
   182f23dd7:	4c 8d 0d 22 52 4c 06 	lea    r9,[rip+0x64c5222]        # 0x1893e9000
   182f23dde:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f23de5:	ba 04 00 00 00       	mov    edx,0x4
   182f23dea:	49 89 f0             	mov    r8,rsi
   182f23ded:	e8 7e 94 14 fd       	call   0x18006d270
   182f23df2:	90                   	nop
   182f23df3:	0f 57 c0             	xorps  xmm0,xmm0
   182f23df6:	0f 29 85 10 02 00 00 	movaps XMMWORD PTR [rbp+0x210],xmm0
   182f23dfd:	0f 29 85 00 02 00 00 	movaps XMMWORD PTR [rbp+0x200],xmm0
   182f23e04:	0f 29 85 f0 01 00 00 	movaps XMMWORD PTR [rbp+0x1f0],xmm0
   182f23e0b:	0f 29 85 e0 01 00 00 	movaps XMMWORD PTR [rbp+0x1e0],xmm0
   182f23e12:	0f 29 85 d0 01 00 00 	movaps XMMWORD PTR [rbp+0x1d0],xmm0
   182f23e19:	0f 29 85 c0 01 00 00 	movaps XMMWORD PTR [rbp+0x1c0],xmm0
   182f23e20:	0f 29 85 b0 01 00 00 	movaps XMMWORD PTR [rbp+0x1b0],xmm0
   182f23e27:	0f 29 85 a0 01 00 00 	movaps XMMWORD PTR [rbp+0x1a0],xmm0
   182f23e2e:	48 8d 15 db 55 4c 06 	lea    rdx,[rip+0x64c55db]        # 0x1893e9410
   182f23e35:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f23e3c:	4c 8d 85 a0 01 00 00 	lea    r8,[rbp+0x1a0]
   182f23e43:	e8 c8 99 14 fd       	call   0x18006d810
   182f23e48:	90                   	nop
   182f23e49:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f23e50:	e8 1b 95 14 fd       	call   0x18006d370
   182f23e55:	48 8d 8d b0 00 00 00 	lea    rcx,[rbp+0xb0]
   182f23e5c:	e8 af e1 0d fd       	call   0x180002010
   182f23e61:	4c 8b b5 78 02 00 00 	mov    r14,QWORD PTR [rbp+0x278]
   182f23e68:	48 c7 85 70 02 00 00 	mov    QWORD PTR [rbp+0x270],0x2
   182f23e6f:	02 00 00 00 
   182f23e73:	e9 49 07 00 00       	jmp    0x182f245c1
   182f23e78:	4c 89 bd 10 01 00 00 	mov    QWORD PTR [rbp+0x110],r15
   182f23e7f:	48 c7 85 18 01 00 00 	mov    QWORD PTR [rbp+0x118],0xf
   182f23e86:	0f 00 00 00 
   182f23e8a:	41 0f 10 04 24       	movups xmm0,XMMWORD PTR [r12]
   182f23e8f:	0f 29 85 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm0
   182f23e96:	eb 2e                	jmp    0x182f23ec6
   182f23e98:	49 8d 4d 01          	lea    rcx,[r13+0x1]
   182f23e9c:	e8 fb 79 58 04       	call   0x1874ab89c
   182f23ea1:	90                   	nop
   182f23ea2:	48 89 85 00 01 00 00 	mov    QWORD PTR [rbp+0x100],rax
   182f23ea9:	4c 89 bd 10 01 00 00 	mov    QWORD PTR [rbp+0x110],r15
   182f23eb0:	4c 89 ad 18 01 00 00 	mov    QWORD PTR [rbp+0x118],r13
   182f23eb7:	4d 8d 47 01          	lea    r8,[r15+0x1]
   182f23ebb:	48 89 c1             	mov    rcx,rax
   182f23ebe:	4c 89 e2             	mov    rdx,r12
   182f23ec1:	e8 8a 01 62 04       	call   0x187544050
   182f23ec6:	48 c7 45 f8 00 00 00 	mov    QWORD PTR [rbp-0x8],0x0
   182f23ecd:	00 
   182f23ece:	b9 28 00 00 00       	mov    ecx,0x28
   182f23ed3:	e8 c4 79 58 04       	call   0x1874ab89c
   182f23ed8:	90                   	nop
   182f23ed9:	49 89 c5             	mov    r13,rax
   182f23edc:	48 8d 05 35 4f 4c 06 	lea    rax,[rip+0x64c4f35]        # 0x1893e8e18
   182f23ee3:	49 89 45 00          	mov    QWORD PTR [r13+0x0],rax
   182f23ee7:	0f 57 c0             	xorps  xmm0,xmm0
   182f23eea:	41 0f 11 45 08       	movups XMMWORD PTR [r13+0x8],xmm0
   182f23eef:	41 0f 11 45 18       	movups XMMWORD PTR [r13+0x18],xmm0
   182f23ef4:	49 83 ff 0f          	cmp    r15,0xf
   182f23ef8:	76 4f                	jbe    0x182f23f49
   182f23efa:	4c 89 ad 28 02 00 00 	mov    QWORD PTR [rbp+0x228],r13
   182f23f01:	4c 8b a5 00 01 00 00 	mov    r12,QWORD PTR [rbp+0x100]
   182f23f08:	4c 89 f8             	mov    rax,r15
   182f23f0b:	48 83 c8 0f          	or     rax,0xf
   182f23f0f:	48 83 f8 17          	cmp    rax,0x17
   182f23f13:	41 bd 16 00 00 00    	mov    r13d,0x16
   182f23f19:	4c 0f 43 e8          	cmovae r13,rax
   182f23f1d:	48 3d ff 0f 00 00    	cmp    rax,0xfff
   182f23f23:	72 65                	jb     0x182f23f8a
   182f23f25:	49 8d 4d 28          	lea    rcx,[r13+0x28]
   182f23f29:	e8 6e 79 58 04       	call   0x1874ab89c
   182f23f2e:	90                   	nop
   182f23f2f:	48 85 c0             	test   rax,rax
   182f23f32:	0f 84 ad 10 00 00    	je     0x182f24fe5
   182f23f38:	48 89 c1             	mov    rcx,rax
   182f23f3b:	48 83 c0 27          	add    rax,0x27
   182f23f3f:	48 83 e0 e0          	and    rax,0xffffffffffffffe0
   182f23f43:	48 89 48 f8          	mov    QWORD PTR [rax-0x8],rcx
   182f23f47:	eb 4b                	jmp    0x182f23f94
   182f23f49:	4c 89 e8             	mov    rax,r13
   182f23f4c:	48 83 c0 08          	add    rax,0x8
   182f23f50:	4d 89 7d 18          	mov    QWORD PTR [r13+0x18],r15
   182f23f54:	49 c7 45 20 0f 00 00 	mov    QWORD PTR [r13+0x20],0xf
   182f23f5b:	00 
   182f23f5c:	0f 28 85 00 01 00 00 	movaps xmm0,XMMWORD PTR [rbp+0x100]
   182f23f63:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   182f23f66:	4c 89 6d f8          	mov    QWORD PTR [rbp-0x8],r13
   182f23f6a:	48 8b 85 a8 00 00 00 	mov    rax,QWORD PTR [rbp+0xa8]
   182f23f71:	48 85 c0             	test   rax,rax
   182f23f74:	74 55                	je     0x182f23fcb
   182f23f76:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   182f23f7a:	48 8b 85 a8 00 00 00 	mov    rax,QWORD PTR [rbp+0xa8]
   182f23f81:	48 89 85 28 02 00 00 	mov    QWORD PTR [rbp+0x228],rax
   182f23f88:	eb 4c                	jmp    0x182f23fd6
   182f23f8a:	49 8d 4d 01          	lea    rcx,[r13+0x1]
   182f23f8e:	e8 09 79 58 04       	call   0x1874ab89c
   182f23f93:	90                   	nop
   182f23f94:	48 8b 8d 28 02 00 00 	mov    rcx,QWORD PTR [rbp+0x228]
   182f23f9b:	48 89 41 08          	mov    QWORD PTR [rcx+0x8],rax
   182f23f9f:	4c 89 79 18          	mov    QWORD PTR [rcx+0x18],r15
   182f23fa3:	4c 89 69 20          	mov    QWORD PTR [rcx+0x20],r13
   182f23fa7:	49 89 cd             	mov    r13,rcx
   182f23faa:	49 ff c7             	inc    r15
   182f23fad:	48 89 c1             	mov    rcx,rax
   182f23fb0:	4c 89 e2             	mov    rdx,r12
   182f23fb3:	4d 89 f8             	mov    r8,r15
   182f23fb6:	e8 95 00 62 04       	call   0x187544050
   182f23fbb:	4c 89 6d f8          	mov    QWORD PTR [rbp-0x8],r13
   182f23fbf:	48 8b 85 a8 00 00 00 	mov    rax,QWORD PTR [rbp+0xa8]
   182f23fc6:	48 85 c0             	test   rax,rax
   182f23fc9:	75 ab                	jne    0x182f23f76
   182f23fcb:	48 c7 85 28 02 00 00 	mov    QWORD PTR [rbp+0x228],0x0
   182f23fd2:	00 00 00 00 
   182f23fd6:	4c 8b bd a0 00 00 00 	mov    r15,QWORD PTR [rbp+0xa0]
   182f23fdd:	0f 57 ff             	xorps  xmm7,xmm7
   182f23fe0:	0f 29 bd a0 01 00 00 	movaps XMMWORD PTR [rbp+0x1a0],xmm7
   182f23fe7:	48 c7 85 b0 01 00 00 	mov    QWORD PTR [rbp+0x1b0],0x0
   182f23fee:	00 00 00 00 
   182f23ff2:	c6 85 87 02 00 00 01 	mov    BYTE PTR [rbp+0x287],0x1
   182f23ff9:	b9 10 00 00 00       	mov    ecx,0x10
   182f23ffe:	e8 99 78 58 04       	call   0x1874ab89c
   182f24003:	90                   	nop
   182f24004:	48 89 85 a0 01 00 00 	mov    QWORD PTR [rbp+0x1a0],rax
   182f2400b:	48 89 85 a8 01 00 00 	mov    QWORD PTR [rbp+0x1a8],rax
   182f24012:	48 89 c1             	mov    rcx,rax
   182f24015:	48 83 c1 10          	add    rcx,0x10
   182f24019:	48 89 8d b0 01 00 00 	mov    QWORD PTR [rbp+0x1b0],rcx
   182f24020:	0f 11 38             	movups XMMWORD PTR [rax],xmm7
   182f24023:	48 8b 95 28 02 00 00 	mov    rdx,QWORD PTR [rbp+0x228]
   182f2402a:	48 85 d2             	test   rdx,rdx
   182f2402d:	74 04                	je     0x182f24033
   182f2402f:	f0 ff 42 08          	lock inc DWORD PTR [rdx+0x8]
   182f24033:	4c 89 38             	mov    QWORD PTR [rax],r15
   182f24036:	48 89 50 08          	mov    QWORD PTR [rax+0x8],rdx
   182f2403a:	48 89 8d a8 01 00 00 	mov    QWORD PTR [rbp+0x1a8],rcx
   182f24041:	48 8d 45 c0          	lea    rax,[rbp-0x40]
   182f24045:	48 89 44 24 28       	mov    QWORD PTR [rsp+0x28],rax
   182f2404a:	48 89 7c 24 20       	mov    QWORD PTR [rsp+0x20],rdi
   182f2404f:	c6 44 24 30 01       	mov    BYTE PTR [rsp+0x30],0x1
   182f24054:	48 8d 95 50 02 00 00 	lea    rdx,[rbp+0x250]
   182f2405b:	4c 8d 8d b0 00 00 00 	lea    r9,[rbp+0xb0]
   182f24062:	4c 89 f1             	mov    rcx,r14
   182f24065:	49 89 d8             	mov    r8,rbx
   182f24068:	e8 43 1c 57 fd       	call   0x180495cb0
   182f2406d:	90                   	nop
   182f2406e:	48 8b bd a0 01 00 00 	mov    rdi,QWORD PTR [rbp+0x1a0]
   182f24075:	48 85 ff             	test   rdi,rdi
   182f24078:	4c 8b bd 28 02 00 00 	mov    r15,QWORD PTR [rbp+0x228]
   182f2407f:	0f 84 8a 00 00 00    	je     0x182f2410f
   182f24085:	4c 8b b5 a8 01 00 00 	mov    r14,QWORD PTR [rbp+0x1a8]
   182f2408c:	4c 39 f7             	cmp    rdi,r14
   182f2408f:	75 18                	jne    0x182f240a9
   182f24091:	eb 45                	jmp    0x182f240d8
   182f24093:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
   182f2409a:	84 00 00 00 00 00 
   182f240a0:	48 83 c7 10          	add    rdi,0x10
   182f240a4:	4c 39 f7             	cmp    rdi,r14
   182f240a7:	74 28                	je     0x182f240d1
   182f240a9:	48 8b 5f 08          	mov    rbx,QWORD PTR [rdi+0x8]
   182f240ad:	48 85 db             	test   rbx,rbx
   182f240b0:	74 ee                	je     0x182f240a0
   182f240b2:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   182f240b6:	75 e8                	jne    0x182f240a0
   182f240b8:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   182f240bb:	48 89 d9             	mov    rcx,rbx
   182f240be:	ff 10                	call   QWORD PTR [rax]
   182f240c0:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   182f240c4:	75 da                	jne    0x182f240a0
   182f240c6:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   182f240c9:	48 89 d9             	mov    rcx,rbx
   182f240cc:	ff 50 08             	call   QWORD PTR [rax+0x8]
   182f240cf:	eb cf                	jmp    0x182f240a0
   182f240d1:	48 8b bd a0 01 00 00 	mov    rdi,QWORD PTR [rbp+0x1a0]
   182f240d8:	48 8b 95 b0 01 00 00 	mov    rdx,QWORD PTR [rbp+0x1b0]
   182f240df:	48 29 fa             	sub    rdx,rdi
   182f240e2:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   182f240e9:	72 1c                	jb     0x182f24107
   182f240eb:	48 8b 47 f8          	mov    rax,QWORD PTR [rdi-0x8]
   182f240ef:	48 83 c7 f8          	add    rdi,0xfffffffffffffff8
   182f240f3:	48 29 c7             	sub    rdi,rax
   182f240f6:	48 83 ff 20          	cmp    rdi,0x20
   182f240fa:	0f 83 e5 0e 00 00    	jae    0x182f24fe5
   182f24100:	48 83 c2 27          	add    rdx,0x27
   182f24104:	48 89 c7             	mov    rdi,rax
   182f24107:	48 89 f9             	mov    rcx,rdi
   182f2410a:	e8 d1 77 58 04       	call   0x1874ab8e0
   182f2410f:	4d 85 ff             	test   r15,r15
   182f24112:	74 1f                	je     0x182f24133
   182f24114:	f0 41 ff 4f 08       	lock dec DWORD PTR [r15+0x8]
   182f24119:	75 18                	jne    0x182f24133
   182f2411b:	49 8b 07             	mov    rax,QWORD PTR [r15]
   182f2411e:	4c 89 f9             	mov    rcx,r15
   182f24121:	ff 10                	call   QWORD PTR [rax]
   182f24123:	f0 41 ff 4f 0c       	lock dec DWORD PTR [r15+0xc]
   182f24128:	75 09                	jne    0x182f24133
   182f2412a:	49 8b 07             	mov    rax,QWORD PTR [r15]
   182f2412d:	4c 89 f9             	mov    rcx,r15
   182f24130:	ff 50 08             	call   QWORD PTR [rax+0x8]
   182f24133:	48 8b 85 18 01 00 00 	mov    rax,QWORD PTR [rbp+0x118]
   182f2413a:	48 83 f8 10          	cmp    rax,0x10
   182f2413e:	72 38                	jb     0x182f24178
   182f24140:	48 8b 8d 00 01 00 00 	mov    rcx,QWORD PTR [rbp+0x100]
   182f24147:	48 8d 50 01          	lea    rdx,[rax+0x1]
   182f2414b:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   182f24152:	72 1f                	jb     0x182f24173
   182f24154:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   182f24158:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   182f2415c:	4c 29 c1             	sub    rcx,r8
   182f2415f:	48 83 f9 20          	cmp    rcx,0x20
   182f24163:	0f 83 7c 0e 00 00    	jae    0x182f24fe5
   182f24169:	48 83 c0 28          	add    rax,0x28
   182f2416d:	48 89 c2             	mov    rdx,rax
   182f24170:	4c 89 c1             	mov    rcx,r8
   182f24173:	e8 68 77 58 04       	call   0x1874ab8e0
   182f24178:	48 8b bd 38 02 00 00 	mov    rdi,QWORD PTR [rbp+0x238]
   182f2417f:	48 85 ff             	test   rdi,rdi
   182f24182:	74 1e                	je     0x182f241a2
   182f24184:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   182f24188:	75 18                	jne    0x182f241a2
   182f2418a:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   182f2418d:	48 89 f9             	mov    rcx,rdi
   182f24190:	ff 10                	call   QWORD PTR [rax]
   182f24192:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   182f24196:	75 0a                	jne    0x182f241a2
   182f24198:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   182f2419b:	48 89 f9             	mov    rcx,rdi
   182f2419e:	ff 50 08             	call   QWORD PTR [rax+0x8]
   182f241a1:	90                   	nop
   182f241a2:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f241a9:	48 8d 95 50 02 00 00 	lea    rdx,[rbp+0x250]
   182f241b0:	e8 5b 28 00 00       	call   0x182f26a10
   182f241b5:	90                   	nop
   182f241b6:	48 83 78 10 00       	cmp    QWORD PTR [rax+0x10],0x0
   182f241bb:	0f 85 f9 00 00 00    	jne    0x182f242ba
   182f241c1:	80 78 18 00          	cmp    BYTE PTR [rax+0x18],0x0
   182f241c5:	0f 85 ef 00 00 00    	jne    0x182f242ba
   182f241cb:	b9 04 00 00 00       	mov    ecx,0x4
   182f241d0:	e8 0b 8c 14 fd       	call   0x18006cde0
   182f241d5:	85 c0                	test   eax,eax
   182f241d7:	0f 84 cd 00 00 00    	je     0x182f242aa
   182f241dd:	48 8d b5 30 02 00 00 	lea    rsi,[rbp+0x230]
   182f241e4:	48 89 f1             	mov    rcx,rsi
   182f241e7:	e8 24 8d 14 fd       	call   0x18006cf10
   182f241ec:	90                   	nop
   182f241ed:	48 83 bd 48 02 00 00 	cmp    QWORD PTR [rbp+0x248],0x10
   182f241f4:	10 
   182f241f5:	72 07                	jb     0x182f241fe
   182f241f7:	48 8b b5 30 02 00 00 	mov    rsi,QWORD PTR [rbp+0x230]
   182f241fe:	48 8d 05 7b 53 4c 06 	lea    rax,[rip+0x64c537b]        # 0x1893e9580
   182f24205:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   182f2420a:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   182f24211:	00 00 
   182f24213:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   182f24218:	c7 44 24 28 f7 01 00 	mov    DWORD PTR [rsp+0x28],0x1f7
   182f2421f:	00 
   182f24220:	4c 8d 0d d9 4d 4c 06 	lea    r9,[rip+0x64c4dd9]        # 0x1893e9000
   182f24227:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f2422e:	ba 04 00 00 00       	mov    edx,0x4
   182f24233:	49 89 f0             	mov    r8,rsi
   182f24236:	e8 35 90 14 fd       	call   0x18006d270
   182f2423b:	90                   	nop
   182f2423c:	0f 57 c0             	xorps  xmm0,xmm0
   182f2423f:	0f 29 85 10 02 00 00 	movaps XMMWORD PTR [rbp+0x210],xmm0
   182f24246:	0f 29 85 00 02 00 00 	movaps XMMWORD PTR [rbp+0x200],xmm0
   182f2424d:	0f 29 85 f0 01 00 00 	movaps XMMWORD PTR [rbp+0x1f0],xmm0
   182f24254:	0f 29 85 e0 01 00 00 	movaps XMMWORD PTR [rbp+0x1e0],xmm0
   182f2425b:	0f 29 85 d0 01 00 00 	movaps XMMWORD PTR [rbp+0x1d0],xmm0
   182f24262:	0f 29 85 c0 01 00 00 	movaps XMMWORD PTR [rbp+0x1c0],xmm0
   182f24269:	0f 29 85 b0 01 00 00 	movaps XMMWORD PTR [rbp+0x1b0],xmm0
   182f24270:	0f 29 85 a0 01 00 00 	movaps XMMWORD PTR [rbp+0x1a0],xmm0
   182f24277:	48 8d 15 b2 53 4c 06 	lea    rdx,[rip+0x64c53b2]        # 0x1893e9630
   182f2427e:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f24285:	4c 8d 85 a0 01 00 00 	lea    r8,[rbp+0x1a0]
   182f2428c:	e8 7f 95 14 fd       	call   0x18006d810
   182f24291:	90                   	nop
   182f24292:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f24299:	e8 d2 90 14 fd       	call   0x18006d370
   182f2429e:	48 8d 8d 30 02 00 00 	lea    rcx,[rbp+0x230]
   182f242a5:	e8 66 dd 0d fd       	call   0x180002010
   182f242aa:	48 c7 85 70 02 00 00 	mov    QWORD PTR [rbp+0x270],0x4
   182f242b1:	04 00 00 00 
   182f242b5:	e9 d7 02 00 00       	jmp    0x182f24591
   182f242ba:	80 38 00             	cmp    BYTE PTR [rax],0x0
   182f242bd:	0f 84 7c 01 00 00    	je     0x182f2443f
   182f242c3:	0f 29 b5 40 01 00 00 	movaps XMMWORD PTR [rbp+0x140],xmm6
   182f242ca:	0f 29 b5 30 01 00 00 	movaps XMMWORD PTR [rbp+0x130],xmm6
   182f242d1:	0f 29 b5 20 01 00 00 	movaps XMMWORD PTR [rbp+0x120],xmm6
   182f242d8:	0f 29 b5 10 01 00 00 	movaps XMMWORD PTR [rbp+0x110],xmm6
   182f242df:	0f 29 b5 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm6
   182f242e6:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f242ed:	48 89 f2             	mov    rdx,rsi
   182f242f0:	e8 eb 22 00 00       	call   0x182f265e0
   182f242f5:	90                   	nop
   182f242f6:	48 8b 85 68 02 00 00 	mov    rax,QWORD PTR [rbp+0x268]
   182f242fd:	48 89 85 28 01 00 00 	mov    QWORD PTR [rbp+0x128],rax
   182f24304:	0f 29 b5 90 00 00 00 	movaps XMMWORD PTR [rbp+0x90],xmm6
   182f2430b:	48 8d b5 a0 01 00 00 	lea    rsi,[rbp+0x1a0]
   182f24312:	48 8d 95 00 01 00 00 	lea    rdx,[rbp+0x100]
   182f24319:	48 89 f1             	mov    rcx,rsi
   182f2431c:	e8 bf 22 00 00       	call   0x182f265e0
   182f24321:	90                   	nop
   182f24322:	48 8d 85 f0 01 00 00 	lea    rax,[rbp+0x1f0]
   182f24329:	0f 57 c0             	xorps  xmm0,xmm0
   182f2432c:	0f 29 85 30 02 00 00 	movaps XMMWORD PTR [rbp+0x230],xmm0
   182f24333:	48 c7 85 40 02 00 00 	mov    QWORD PTR [rbp+0x240],0x0
   182f2433a:	00 00 00 00 
   182f2433e:	48 89 45 40          	mov    QWORD PTR [rbp+0x40],rax
   182f24342:	48 89 75 48          	mov    QWORD PTR [rbp+0x48],rsi
   182f24346:	48 8d 8d 30 02 00 00 	lea    rcx,[rbp+0x230]
   182f2434d:	4c 8d 45 48          	lea    r8,[rbp+0x48]
   182f24351:	4c 8d 4d 40          	lea    r9,[rbp+0x40]
   182f24355:	ba 01 00 00 00       	mov    edx,0x1
   182f2435a:	e8 b1 34 00 00       	call   0x182f27810
   182f2435f:	90                   	nop
   182f24360:	48 8d 8d 90 00 00 00 	lea    rcx,[rbp+0x90]
   182f24367:	48 8d 95 30 02 00 00 	lea    rdx,[rbp+0x230]
   182f2436e:	4c 8d 85 70 02 00 00 	lea    r8,[rbp+0x270]
   182f24375:	e8 f6 27 00 00       	call   0x182f26b70
   182f2437a:	90                   	nop
   182f2437b:	48 8d 8d 30 02 00 00 	lea    rcx,[rbp+0x230]
   182f24382:	e8 19 5a 40 fd       	call   0x180329da0
   182f24387:	48 8b 85 e8 01 00 00 	mov    rax,QWORD PTR [rbp+0x1e8]
   182f2438e:	48 83 f8 10          	cmp    rax,0x10
   182f24392:	48 8b b5 98 01 00 00 	mov    rsi,QWORD PTR [rbp+0x198]
   182f24399:	72 38                	jb     0x182f243d3
   182f2439b:	48 8b 8d d0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1d0]
   182f243a2:	48 8d 50 01          	lea    rdx,[rax+0x1]
   182f243a6:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   182f243ad:	72 1f                	jb     0x182f243ce
   182f243af:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   182f243b3:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   182f243b7:	4c 29 c1             	sub    rcx,r8
   182f243ba:	48 83 f9 20          	cmp    rcx,0x20
   182f243be:	0f 83 21 0c 00 00    	jae    0x182f24fe5
   182f243c4:	48 83 c0 28          	add    rax,0x28
   182f243c8:	48 89 c2             	mov    rdx,rax
   182f243cb:	4c 89 c1             	mov    rcx,r8
   182f243ce:	e8 0d 75 58 04       	call   0x1874ab8e0
   182f243d3:	48 8b 85 c0 01 00 00 	mov    rax,QWORD PTR [rbp+0x1c0]
   182f243da:	48 83 f8 10          	cmp    rax,0x10
   182f243de:	72 38                	jb     0x182f24418
   182f243e0:	48 8b 8d a8 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1a8]
   182f243e7:	48 8d 50 01          	lea    rdx,[rax+0x1]
   182f243eb:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   182f243f2:	72 1f                	jb     0x182f24413
   182f243f4:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   182f243f8:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   182f243fc:	4c 29 c1             	sub    rcx,r8
   182f243ff:	48 83 f9 20          	cmp    rcx,0x20
   182f24403:	0f 83 dc 0b 00 00    	jae    0x182f24fe5
   182f24409:	48 83 c0 28          	add    rax,0x28
   182f2440d:	48 89 c2             	mov    rdx,rax
   182f24410:	4c 89 c1             	mov    rcx,r8
   182f24413:	e8 c8 74 58 04       	call   0x1874ab8e0
   182f24418:	0f 57 c0             	xorps  xmm0,xmm0
   182f2441b:	0f 29 45 50          	movaps XMMWORD PTR [rbp+0x50],xmm0
   182f2441f:	48 8b 85 98 00 00 00 	mov    rax,QWORD PTR [rbp+0x98]
   182f24426:	48 85 c0             	test   rax,rax
   182f24429:	0f 84 fc 00 00 00    	je     0x182f2452b
   182f2442f:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   182f24433:	48 8b 85 98 00 00 00 	mov    rax,QWORD PTR [rbp+0x98]
   182f2443a:	e9 ee 00 00 00       	jmp    0x182f2452d
   182f2443f:	b9 04 00 00 00       	mov    ecx,0x4
   182f24444:	e8 97 89 14 fd       	call   0x18006cde0
   182f24449:	85 c0                	test   eax,eax
   182f2444b:	0f 84 cd 00 00 00    	je     0x182f2451e
   182f24451:	48 8d b5 30 02 00 00 	lea    rsi,[rbp+0x230]
   182f24458:	48 89 f1             	mov    rcx,rsi
   182f2445b:	e8 b0 8a 14 fd       	call   0x18006cf10
   182f24460:	90                   	nop
   182f24461:	48 83 bd 48 02 00 00 	cmp    QWORD PTR [rbp+0x248],0x10
   182f24468:	10 
   182f24469:	72 07                	jb     0x182f24472
   182f2446b:	48 8b b5 30 02 00 00 	mov    rsi,QWORD PTR [rbp+0x230]
   182f24472:	48 8d 05 07 51 4c 06 	lea    rax,[rip+0x64c5107]        # 0x1893e9580
   182f24479:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   182f2447e:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   182f24485:	00 00 
   182f24487:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   182f2448c:	c7 44 24 28 fe 01 00 	mov    DWORD PTR [rsp+0x28],0x1fe
   182f24493:	00 
   182f24494:	4c 8d 0d 65 4b 4c 06 	lea    r9,[rip+0x64c4b65]        # 0x1893e9000
   182f2449b:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f244a2:	ba 04 00 00 00       	mov    edx,0x4
   182f244a7:	49 89 f0             	mov    r8,rsi
   182f244aa:	e8 c1 8d 14 fd       	call   0x18006d270
   182f244af:	90                   	nop
   182f244b0:	0f 57 c0             	xorps  xmm0,xmm0
   182f244b3:	0f 29 85 10 02 00 00 	movaps XMMWORD PTR [rbp+0x210],xmm0
   182f244ba:	0f 29 85 00 02 00 00 	movaps XMMWORD PTR [rbp+0x200],xmm0
   182f244c1:	0f 29 85 f0 01 00 00 	movaps XMMWORD PTR [rbp+0x1f0],xmm0
   182f244c8:	0f 29 85 e0 01 00 00 	movaps XMMWORD PTR [rbp+0x1e0],xmm0
   182f244cf:	0f 29 85 d0 01 00 00 	movaps XMMWORD PTR [rbp+0x1d0],xmm0
   182f244d6:	0f 29 85 c0 01 00 00 	movaps XMMWORD PTR [rbp+0x1c0],xmm0
   182f244dd:	0f 29 85 b0 01 00 00 	movaps XMMWORD PTR [rbp+0x1b0],xmm0
   182f244e4:	0f 29 85 a0 01 00 00 	movaps XMMWORD PTR [rbp+0x1a0],xmm0
   182f244eb:	48 8d 15 66 51 4c 06 	lea    rdx,[rip+0x64c5166]        # 0x1893e9658
   182f244f2:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f244f9:	4c 8d 85 a0 01 00 00 	lea    r8,[rbp+0x1a0]
   182f24500:	e8 0b 93 14 fd       	call   0x18006d810
   182f24505:	90                   	nop
   182f24506:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f2450d:	e8 5e 8e 14 fd       	call   0x18006d370
   182f24512:	48 8d 8d 30 02 00 00 	lea    rcx,[rbp+0x230]
   182f24519:	e8 f2 da 0d fd       	call   0x180002010
   182f2451e:	48 c7 85 70 02 00 00 	mov    QWORD PTR [rbp+0x270],0x2
   182f24525:	02 00 00 00 
   182f24529:	eb 66                	jmp    0x182f24591
   182f2452b:	31 c0                	xor    eax,eax
   182f2452d:	48 8b 8d 90 00 00 00 	mov    rcx,QWORD PTR [rbp+0x90]
   182f24534:	48 89 4d 50          	mov    QWORD PTR [rbp+0x50],rcx
   182f24538:	48 89 45 58          	mov    QWORD PTR [rbp+0x58],rax
   182f2453c:	0f 29 45 60          	movaps XMMWORD PTR [rbp+0x60],xmm0
   182f24540:	48 8b 46 08          	mov    rax,QWORD PTR [rsi+0x8]
   182f24544:	48 85 c0             	test   rax,rax
   182f24547:	74 0a                	je     0x182f24553
   182f24549:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   182f2454d:	48 8b 46 08          	mov    rax,QWORD PTR [rsi+0x8]
   182f24551:	eb 02                	jmp    0x182f24555
   182f24553:	31 c0                	xor    eax,eax
   182f24555:	48 8b 0e             	mov    rcx,QWORD PTR [rsi]
   182f24558:	48 89 4d 60          	mov    QWORD PTR [rbp+0x60],rcx
   182f2455c:	48 89 45 68          	mov    QWORD PTR [rbp+0x68],rax
   182f24560:	48 8d 4d 60          	lea    rcx,[rbp+0x60]
   182f24564:	48 8d 55 50          	lea    rdx,[rbp+0x50]
   182f24568:	e8 83 63 fc ff       	call   0x182eea8f0
   182f2456d:	90                   	nop
   182f2456e:	48 c7 85 70 02 00 00 	mov    QWORD PTR [rbp+0x270],0x1
   182f24575:	01 00 00 00 
   182f24579:	48 8d 8d 90 00 00 00 	lea    rcx,[rbp+0x90]
   182f24580:	e8 db da 0d fd       	call   0x180002060
   182f24585:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f2458c:	e8 6f 4b 40 fd       	call   0x180329100
   182f24591:	48 8b b5 58 02 00 00 	mov    rsi,QWORD PTR [rbp+0x258]
   182f24598:	48 85 f6             	test   rsi,rsi
   182f2459b:	4c 8b b5 78 02 00 00 	mov    r14,QWORD PTR [rbp+0x278]
   182f245a2:	74 1d                	je     0x182f245c1
   182f245a4:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   182f245a8:	75 17                	jne    0x182f245c1
   182f245aa:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   182f245ad:	48 89 f1             	mov    rcx,rsi
   182f245b0:	ff 10                	call   QWORD PTR [rax]
   182f245b2:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   182f245b6:	75 09                	jne    0x182f245c1
   182f245b8:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   182f245bb:	48 89 f1             	mov    rcx,rsi
   182f245be:	ff 50 08             	call   QWORD PTR [rax+0x8]
   182f245c1:	48 8b bd 98 01 00 00 	mov    rdi,QWORD PTR [rbp+0x198]
   182f245c8:	48 8b b5 a8 00 00 00 	mov    rsi,QWORD PTR [rbp+0xa8]
   182f245cf:	48 85 f6             	test   rsi,rsi
   182f245d2:	74 1d                	je     0x182f245f1
   182f245d4:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   182f245d8:	75 17                	jne    0x182f245f1
   182f245da:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   182f245dd:	48 89 f1             	mov    rcx,rsi
   182f245e0:	ff 10                	call   QWORD PTR [rax]
   182f245e2:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   182f245e6:	75 09                	jne    0x182f245f1
   182f245e8:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   182f245eb:	48 89 f1             	mov    rcx,rsi
   182f245ee:	ff 50 08             	call   QWORD PTR [rax+0x8]
   182f245f1:	48 83 bd 70 02 00 00 	cmp    QWORD PTR [rbp+0x270],0x1
   182f245f8:	01 
   182f245f9:	0f 85 df ed ff ff    	jne    0x182f233de
   182f245ff:	e9 3f f0 ff ff       	jmp    0x182f23643
   182f24604:	b9 04 00 00 00       	mov    ecx,0x4
   182f24609:	e8 d2 87 14 fd       	call   0x18006cde0
   182f2460e:	85 c0                	test   eax,eax
   182f24610:	0f 84 9d f2 ff ff    	je     0x182f238b3
   182f24616:	48 8d 9d 30 02 00 00 	lea    rbx,[rbp+0x230]
   182f2461d:	48 89 d9             	mov    rcx,rbx
   182f24620:	e8 eb 88 14 fd       	call   0x18006cf10
   182f24625:	90                   	nop
   182f24626:	48 83 bd 48 02 00 00 	cmp    QWORD PTR [rbp+0x248],0x10
   182f2462d:	10 
   182f2462e:	72 07                	jb     0x182f24637
   182f24630:	48 8b 9d 30 02 00 00 	mov    rbx,QWORD PTR [rbp+0x230]
   182f24637:	48 8d 05 42 4f 4c 06 	lea    rax,[rip+0x64c4f42]        # 0x1893e9580
   182f2463e:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   182f24643:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   182f2464a:	00 00 
   182f2464c:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   182f24651:	c7 44 24 28 b7 01 00 	mov    DWORD PTR [rsp+0x28],0x1b7
   182f24658:	00 
   182f24659:	4c 8d 0d a0 49 4c 06 	lea    r9,[rip+0x64c49a0]        # 0x1893e9000
   182f24660:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f24667:	ba 04 00 00 00       	mov    edx,0x4
   182f2466c:	49 89 d8             	mov    r8,rbx
   182f2466f:	e8 fc 8b 14 fd       	call   0x18006d270
   182f24674:	90                   	nop
   182f24675:	48 8b 17             	mov    rdx,QWORD PTR [rdi]
   182f24678:	48 8d bd b0 00 00 00 	lea    rdi,[rbp+0xb0]
   182f2467f:	48 89 f9             	mov    rcx,rdi
   182f24682:	41 b0 0a             	mov    r8b,0xa
   182f24685:	e8 26 62 16 fd       	call   0x18008a8b0
   182f2468a:	90                   	nop
   182f2468b:	0f 57 c0             	xorps  xmm0,xmm0
   182f2468e:	0f 11 85 08 02 00 00 	movups XMMWORD PTR [rbp+0x208],xmm0
   182f24695:	0f 11 85 f8 01 00 00 	movups XMMWORD PTR [rbp+0x1f8],xmm0
   182f2469c:	0f 11 85 e8 01 00 00 	movups XMMWORD PTR [rbp+0x1e8],xmm0
   182f246a3:	0f 11 85 d8 01 00 00 	movups XMMWORD PTR [rbp+0x1d8],xmm0
   182f246aa:	0f 11 85 c8 01 00 00 	movups XMMWORD PTR [rbp+0x1c8],xmm0
   182f246b1:	0f 11 85 b8 01 00 00 	movups XMMWORD PTR [rbp+0x1b8],xmm0
   182f246b8:	0f 11 85 a8 01 00 00 	movups XMMWORD PTR [rbp+0x1a8],xmm0
   182f246bf:	48 c7 85 18 02 00 00 	mov    QWORD PTR [rbp+0x218],0x0
   182f246c6:	00 00 00 00 
   182f246ca:	48 89 bd a0 01 00 00 	mov    QWORD PTR [rbp+0x1a0],rdi
   182f246d1:	48 8d 15 a0 0d 4c 06 	lea    rdx,[rip+0x64c0da0]        # 0x1893e5478
   182f246d8:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f246df:	4c 8d 85 a0 01 00 00 	lea    r8,[rbp+0x1a0]
   182f246e6:	e8 25 91 14 fd       	call   0x18006d810
   182f246eb:	90                   	nop
   182f246ec:	e9 a3 f1 ff ff       	jmp    0x182f23894
   182f246f1:	0f 28 05 b8 14 e2 05 	movaps xmm0,XMMWORD PTR [rip+0x5e214b8]        # 0x188d45bb0
   182f246f8:	0f 29 85 50 02 00 00 	movaps XMMWORD PTR [rbp+0x250],xmm0
   182f246ff:	48 8d 8d 50 02 00 00 	lea    rcx,[rbp+0x250]
   182f24706:	e8 c5 20 00 00       	call   0x182f267d0
   182f2470b:	90                   	nop
   182f2470c:	48 8b 85 50 02 00 00 	mov    rax,QWORD PTR [rbp+0x250]
   182f24713:	c7 80 18 01 00 00 2b 	mov    DWORD PTR [rax+0x118],0x2b
   182f2471a:	00 00 00 
   182f2471d:	48 89 d9             	mov    rcx,rbx
   182f24720:	e8 9b b9 46 fd       	call   0x1803900c0
   182f24725:	90                   	nop
   182f24726:	84 c0                	test   al,al
   182f24728:	0f 84 44 03 00 00    	je     0x182f24a72
   182f2472e:	48 83 bf 50 02 00 00 	cmp    QWORD PTR [rdi+0x250],0x10
   182f24735:	10 
   182f24736:	72 07                	jb     0x182f2473f
   182f24738:	48 8b 9f 38 02 00 00 	mov    rbx,QWORD PTR [rdi+0x238]
   182f2473f:	48 89 5d 10          	mov    QWORD PTR [rbp+0x10],rbx
   182f24743:	48 8b 87 48 02 00 00 	mov    rax,QWORD PTR [rdi+0x248]
   182f2474a:	48 89 45 18          	mov    QWORD PTR [rbp+0x18],rax
   182f2474e:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f24755:	48 8d 55 10          	lea    rdx,[rbp+0x10]
   182f24759:	e8 f2 b3 17 fd       	call   0x18009fb50
   182f2475e:	90                   	nop
   182f2475f:	b9 20 01 00 00       	mov    ecx,0x120
   182f24764:	48 03 8d 50 02 00 00 	add    rcx,QWORD PTR [rbp+0x250]
   182f2476b:	48 8d 9d 00 01 00 00 	lea    rbx,[rbp+0x100]
   182f24772:	48 89 da             	mov    rdx,rbx
   182f24775:	e8 c6 6e 17 fd       	call   0x18009b640
   182f2477a:	48 89 d9             	mov    rcx,rbx
   182f2477d:	e8 de 32 0e fd       	call   0x180007a60
   182f24782:	48 83 7f 78 00       	cmp    QWORD PTR [rdi+0x78],0x0
   182f24787:	74 16                	je     0x182f2479f
   182f24789:	48 8d 57 68          	lea    rdx,[rdi+0x68]
   182f2478d:	b9 a8 01 00 00       	mov    ecx,0x1a8
   182f24792:	48 03 8d 50 02 00 00 	add    rcx,QWORD PTR [rbp+0x250]
   182f24799:	e8 82 0c 42 fd       	call   0x180345420
   182f2479e:	90                   	nop
   182f2479f:	48 83 bf 70 02 00 00 	cmp    QWORD PTR [rdi+0x270],0x10
   182f247a6:	10 
   182f247a7:	0f 82 34 07 00 00    	jb     0x182f24ee1
   182f247ad:	48 8b 87 58 02 00 00 	mov    rax,QWORD PTR [rdi+0x258]
   182f247b4:	e9 2f 07 00 00       	jmp    0x182f24ee8
   182f247b9:	0f 28 05 f0 13 e2 05 	movaps xmm0,XMMWORD PTR [rip+0x5e213f0]        # 0x188d45bb0
   182f247c0:	0f 29 85 50 02 00 00 	movaps XMMWORD PTR [rbp+0x250],xmm0
   182f247c7:	48 8d 8d 50 02 00 00 	lea    rcx,[rbp+0x250]
   182f247ce:	e8 1d 29 e4 fe       	call   0x181d670f0
   182f247d3:	90                   	nop
   182f247d4:	48 8b 85 50 02 00 00 	mov    rax,QWORD PTR [rbp+0x250]
   182f247db:	c7 80 18 01 00 00 03 	mov    DWORD PTR [rax+0x118],0x3
   182f247e2:	00 00 00 
   182f247e5:	48 89 d9             	mov    rcx,rbx
   182f247e8:	e8 d3 b8 46 fd       	call   0x1803900c0
   182f247ed:	90                   	nop
   182f247ee:	84 c0                	test   al,al
   182f247f0:	0f 84 a1 03 00 00    	je     0x182f24b97
   182f247f6:	48 83 bf 50 02 00 00 	cmp    QWORD PTR [rdi+0x250],0x10
   182f247fd:	10 
   182f247fe:	72 07                	jb     0x182f24807
   182f24800:	48 8b 9f 38 02 00 00 	mov    rbx,QWORD PTR [rdi+0x238]
   182f24807:	48 89 5d 00          	mov    QWORD PTR [rbp+0x0],rbx
   182f2480b:	48 8b 87 48 02 00 00 	mov    rax,QWORD PTR [rdi+0x248]
   182f24812:	48 89 45 08          	mov    QWORD PTR [rbp+0x8],rax
   182f24816:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f2481d:	48 89 ea             	mov    rdx,rbp
   182f24820:	e8 2b b3 17 fd       	call   0x18009fb50
   182f24825:	90                   	nop
   182f24826:	b9 20 01 00 00       	mov    ecx,0x120
   182f2482b:	48 03 8d 50 02 00 00 	add    rcx,QWORD PTR [rbp+0x250]
   182f24832:	48 8d bd 00 01 00 00 	lea    rdi,[rbp+0x100]
   182f24839:	48 89 fa             	mov    rdx,rdi
   182f2483c:	e8 ff 6d 17 fd       	call   0x18009b640
   182f24841:	48 89 f9             	mov    rcx,rdi
   182f24844:	e8 17 32 0e fd       	call   0x180007a60
   182f24849:	48 8d 8d a0 00 00 00 	lea    rcx,[rbp+0xa0]
   182f24850:	48 8d 95 50 02 00 00 	lea    rdx,[rbp+0x250]
   182f24857:	e8 e4 af 7f fd       	call   0x18071f840
   182f2485c:	b8 01 00 00 00       	mov    eax,0x1
   182f24861:	e9 51 04 00 00       	jmp    0x182f24cb7
   182f24866:	0f 28 35 43 13 e2 05 	movaps xmm6,XMMWORD PTR [rip+0x5e21343]        # 0x188d45bb0
   182f2486d:	0f 29 b5 00 01 00 00 	movaps XMMWORD PTR [rbp+0x100],xmm6
   182f24874:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f2487b:	e8 70 20 00 00       	call   0x182f268f0
   182f24880:	90                   	nop
   182f24881:	48 8b 85 00 01 00 00 	mov    rax,QWORD PTR [rbp+0x100]
   182f24888:	c7 80 18 01 00 00 30 	mov    DWORD PTR [rax+0x118],0x30
   182f2488f:	00 00 00 
   182f24892:	48 8d 8f 78 01 00 00 	lea    rcx,[rdi+0x178]
   182f24899:	0f 57 c9             	xorps  xmm1,xmm1
   182f2489c:	e8 bf a4 2e fd       	call   0x18020ed60
   182f248a1:	90                   	nop
   182f248a2:	48 8d 8f 58 01 00 00 	lea    rcx,[rdi+0x158]
   182f248a9:	48 8b 85 00 01 00 00 	mov    rax,QWORD PTR [rbp+0x100]
   182f248b0:	f2 0f 11 80 58 07 00 	movsd  QWORD PTR [rax+0x758],xmm0
   182f248b7:	00 
   182f248b8:	0f 57 c9             	xorps  xmm1,xmm1
   182f248bb:	e8 a0 a4 2e fd       	call   0x18020ed60
   182f248c0:	90                   	nop
   182f248c1:	48 8b 8d 00 01 00 00 	mov    rcx,QWORD PTR [rbp+0x100]
   182f248c8:	f2 0f 11 81 60 07 00 	movsd  QWORD PTR [rcx+0x760],xmm0
   182f248cf:	00 
   182f248d0:	48 8d 97 b8 01 00 00 	lea    rdx,[rdi+0x1b8]
   182f248d7:	48 81 c1 70 07 00 00 	add    rcx,0x770
   182f248de:	e8 3d 0b 42 fd       	call   0x180345420
   182f248e3:	90                   	nop
   182f248e4:	48 8d 97 d8 01 00 00 	lea    rdx,[rdi+0x1d8]
   182f248eb:	b9 90 07 00 00       	mov    ecx,0x790
   182f248f0:	48 03 8d 00 01 00 00 	add    rcx,QWORD PTR [rbp+0x100]
   182f248f7:	e8 24 0b 42 fd       	call   0x180345420
   182f248fc:	90                   	nop
   182f248fd:	48 8d 8f 98 01 00 00 	lea    rcx,[rdi+0x198]
   182f24904:	31 d2                	xor    edx,edx
   182f24906:	e8 d5 a0 2e fd       	call   0x18020e9e0
   182f2490b:	90                   	nop
   182f2490c:	48 8b 8d 00 01 00 00 	mov    rcx,QWORD PTR [rbp+0x100]
   182f24913:	89 81 68 07 00 00    	mov    DWORD PTR [rcx+0x768],eax
   182f24919:	48 8d 97 f8 01 00 00 	lea    rdx,[rdi+0x1f8]
   182f24920:	48 81 c1 d0 07 00 00 	add    rcx,0x7d0
   182f24927:	e8 f4 0a 42 fd       	call   0x180345420
   182f2492c:	90                   	nop
   182f2492d:	48 8b 85 00 01 00 00 	mov    rax,QWORD PTR [rbp+0x100]
   182f24934:	48 83 b8 e0 07 00 00 	cmp    QWORD PTR [rax+0x7e0],0x0
   182f2493b:	00 
   182f2493c:	0f 85 80 06 00 00    	jne    0x182f24fc2
   182f24942:	48 8b 85 78 02 00 00 	mov    rax,QWORD PTR [rbp+0x278]
   182f24949:	48 8b 08             	mov    rcx,QWORD PTR [rax]
   182f2494c:	48 83 c7 08          	add    rdi,0x8
   182f24950:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   182f24953:	48 89 fa             	mov    rdx,rdi
   182f24956:	ff 50 18             	call   QWORD PTR [rax+0x18]
   182f24959:	90                   	nop
   182f2495a:	48 85 c0             	test   rax,rax
   182f2495d:	0f 84 5f 06 00 00    	je     0x182f24fc2
   182f24963:	0f 29 b5 a0 01 00 00 	movaps XMMWORD PTR [rbp+0x1a0],xmm6
   182f2496a:	48 8b 88 a8 05 00 00 	mov    rcx,QWORD PTR [rax+0x5a8]
   182f24971:	48 85 c9             	test   rcx,rcx
   182f24974:	0f 84 0a 06 00 00    	je     0x182f24f84
   182f2497a:	f0 ff 41 08          	lock inc DWORD PTR [rcx+0x8]
   182f2497e:	48 8b 88 a8 05 00 00 	mov    rcx,QWORD PTR [rax+0x5a8]
   182f24985:	e9 fc 05 00 00       	jmp    0x182f24f86
   182f2498a:	0f 28 05 1f 12 e2 05 	movaps xmm0,XMMWORD PTR [rip+0x5e2121f]        # 0x188d45bb0
   182f24991:	0f 29 85 50 02 00 00 	movaps XMMWORD PTR [rbp+0x250],xmm0
   182f24998:	48 8d 8d 50 02 00 00 	lea    rcx,[rbp+0x250]
   182f2499f:	e8 bc 69 c8 ff       	call   0x182bab360
   182f249a4:	90                   	nop
   182f249a5:	48 8b 8d 50 02 00 00 	mov    rcx,QWORD PTR [rbp+0x250]
   182f249ac:	48 b8 31 00 00 00 06 	movabs rax,0x600000031
   182f249b3:	00 00 00 
   182f249b6:	48 89 81 18 01 00 00 	mov    QWORD PTR [rcx+0x118],rax
   182f249bd:	49 89 fe             	mov    r14,rdi
   182f249c0:	49 83 c6 68          	add    r14,0x68
   182f249c4:	48 81 c1 a8 01 00 00 	add    rcx,0x1a8
   182f249cb:	4c 89 f2             	mov    rdx,r14
   182f249ce:	e8 4d 0a 42 fd       	call   0x180345420
   182f249d3:	90                   	nop
   182f249d4:	48 89 d9             	mov    rcx,rbx
   182f249d7:	e8 e4 b6 46 fd       	call   0x1803900c0
   182f249dc:	90                   	nop
   182f249dd:	84 c0                	test   al,al
   182f249df:	0f 84 f1 02 00 00    	je     0x182f24cd6
   182f249e5:	48 83 bf 50 02 00 00 	cmp    QWORD PTR [rdi+0x250],0x10
   182f249ec:	10 
   182f249ed:	72 07                	jb     0x182f249f6
   182f249ef:	48 8b 9f 38 02 00 00 	mov    rbx,QWORD PTR [rdi+0x238]
   182f249f6:	48 89 5d 30          	mov    QWORD PTR [rbp+0x30],rbx
   182f249fa:	48 8b 87 48 02 00 00 	mov    rax,QWORD PTR [rdi+0x248]
   182f24a01:	48 89 45 38          	mov    QWORD PTR [rbp+0x38],rax
   182f24a05:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f24a0c:	48 8d 55 30          	lea    rdx,[rbp+0x30]
   182f24a10:	e8 3b b1 17 fd       	call   0x18009fb50
   182f24a15:	90                   	nop
   182f24a16:	b9 20 01 00 00       	mov    ecx,0x120
   182f24a1b:	48 03 8d 50 02 00 00 	add    rcx,QWORD PTR [rbp+0x250]
   182f24a22:	48 8d 9d 00 01 00 00 	lea    rbx,[rbp+0x100]
   182f24a29:	48 89 da             	mov    rdx,rbx
   182f24a2c:	e8 0f 6c 17 fd       	call   0x18009b640
   182f24a31:	48 89 d9             	mov    rcx,rbx
   182f24a34:	e8 27 30 0e fd       	call   0x180007a60
   182f24a39:	48 83 7f 78 00       	cmp    QWORD PTR [rdi+0x78],0x0
   182f24a3e:	74 15                	je     0x182f24a55
   182f24a40:	b9 a8 01 00 00       	mov    ecx,0x1a8
   182f24a45:	48 03 8d 50 02 00 00 	add    rcx,QWORD PTR [rbp+0x250]
   182f24a4c:	4c 89 f2             	mov    rdx,r14
   182f24a4f:	e8 cc 09 42 fd       	call   0x180345420
   182f24a54:	90                   	nop
   182f24a55:	48 8d 8d a0 00 00 00 	lea    rcx,[rbp+0xa0]
   182f24a5c:	48 8d 95 50 02 00 00 	lea    rdx,[rbp+0x250]
   182f24a63:	e8 d8 ad 7f fd       	call   0x18071f840
   182f24a68:	b8 01 00 00 00       	mov    eax,0x1
   182f24a6d:	e9 84 03 00 00       	jmp    0x182f24df6
   182f24a72:	b9 04 00 00 00       	mov    ecx,0x4
   182f24a77:	e8 64 83 14 fd       	call   0x18006cde0
   182f24a7c:	85 c0                	test   eax,eax
   182f24a7e:	0f 84 fe 00 00 00    	je     0x182f24b82
   182f24a84:	4c 8d b5 30 02 00 00 	lea    r14,[rbp+0x230]
   182f24a8b:	4c 89 f1             	mov    rcx,r14
   182f24a8e:	e8 7d 84 14 fd       	call   0x18006cf10
   182f24a93:	90                   	nop
   182f24a94:	48 83 bd 48 02 00 00 	cmp    QWORD PTR [rbp+0x248],0x10
   182f24a9b:	10 
   182f24a9c:	72 07                	jb     0x182f24aa5
   182f24a9e:	4c 8b b5 30 02 00 00 	mov    r14,QWORD PTR [rbp+0x230]
   182f24aa5:	48 8d 05 d4 4a 4c 06 	lea    rax,[rip+0x64c4ad4]        # 0x1893e9580
   182f24aac:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   182f24ab1:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   182f24ab8:	00 00 
   182f24aba:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   182f24abf:	c7 44 24 28 81 01 00 	mov    DWORD PTR [rsp+0x28],0x181
   182f24ac6:	00 
   182f24ac7:	4c 8d 0d 32 45 4c 06 	lea    r9,[rip+0x64c4532]        # 0x1893e9000
   182f24ace:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f24ad5:	ba 04 00 00 00       	mov    edx,0x4
   182f24ada:	4d 89 f0             	mov    r8,r14
   182f24add:	e8 8e 87 14 fd       	call   0x18006d270
   182f24ae2:	90                   	nop
   182f24ae3:	48 83 bf 50 02 00 00 	cmp    QWORD PTR [rdi+0x250],0x10
   182f24aea:	10 
   182f24aeb:	72 07                	jb     0x182f24af4
   182f24aed:	48 8b 9f 38 02 00 00 	mov    rbx,QWORD PTR [rdi+0x238]
   182f24af4:	48 89 9d b0 00 00 00 	mov    QWORD PTR [rbp+0xb0],rbx
   182f24afb:	c6 85 b8 00 00 00 00 	mov    BYTE PTR [rbp+0xb8],0x0
   182f24b02:	0f 57 c0             	xorps  xmm0,xmm0
   182f24b05:	0f 11 85 08 02 00 00 	movups XMMWORD PTR [rbp+0x208],xmm0
   182f24b0c:	0f 11 85 f8 01 00 00 	movups XMMWORD PTR [rbp+0x1f8],xmm0
   182f24b13:	0f 11 85 e8 01 00 00 	movups XMMWORD PTR [rbp+0x1e8],xmm0
   182f24b1a:	0f 11 85 d8 01 00 00 	movups XMMWORD PTR [rbp+0x1d8],xmm0
   182f24b21:	0f 11 85 c8 01 00 00 	movups XMMWORD PTR [rbp+0x1c8],xmm0
   182f24b28:	0f 11 85 b8 01 00 00 	movups XMMWORD PTR [rbp+0x1b8],xmm0
   182f24b2f:	0f 11 85 a8 01 00 00 	movups XMMWORD PTR [rbp+0x1a8],xmm0
   182f24b36:	48 c7 85 18 02 00 00 	mov    QWORD PTR [rbp+0x218],0x0
   182f24b3d:	00 00 00 00 
   182f24b41:	48 8d 85 b0 00 00 00 	lea    rax,[rbp+0xb0]
   182f24b48:	48 89 85 a0 01 00 00 	mov    QWORD PTR [rbp+0x1a0],rax
   182f24b4f:	48 8d 15 9a 49 4c 06 	lea    rdx,[rip+0x64c499a]        # 0x1893e94f0
   182f24b56:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f24b5d:	4c 8d 85 a0 01 00 00 	lea    r8,[rbp+0x1a0]
   182f24b64:	e8 a7 8c 14 fd       	call   0x18006d810
   182f24b69:	90                   	nop
   182f24b6a:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f24b71:	e8 fa 87 14 fd       	call   0x18006d370
   182f24b76:	48 8d 8d 30 02 00 00 	lea    rcx,[rbp+0x230]
   182f24b7d:	e8 8e d4 0d fd       	call   0x180002010
   182f24b82:	48 c7 85 70 02 00 00 	mov    QWORD PTR [rbp+0x270],0x2
   182f24b89:	02 00 00 00 
   182f24b8d:	b8 05 00 00 00       	mov    eax,0x5
   182f24b92:	e9 ce 03 00 00       	jmp    0x182f24f65
   182f24b97:	b9 04 00 00 00       	mov    ecx,0x4
   182f24b9c:	e8 3f 82 14 fd       	call   0x18006cde0
   182f24ba1:	85 c0                	test   eax,eax
   182f24ba3:	0f 84 fe 00 00 00    	je     0x182f24ca7
   182f24ba9:	4c 8d b5 30 02 00 00 	lea    r14,[rbp+0x230]
   182f24bb0:	4c 89 f1             	mov    rcx,r14
   182f24bb3:	e8 58 83 14 fd       	call   0x18006cf10
   182f24bb8:	90                   	nop
   182f24bb9:	48 83 bd 48 02 00 00 	cmp    QWORD PTR [rbp+0x248],0x10
   182f24bc0:	10 
   182f24bc1:	72 07                	jb     0x182f24bca
   182f24bc3:	4c 8b b5 30 02 00 00 	mov    r14,QWORD PTR [rbp+0x230]
   182f24bca:	48 8d 05 af 49 4c 06 	lea    rax,[rip+0x64c49af]        # 0x1893e9580
   182f24bd1:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   182f24bd6:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   182f24bdd:	00 00 
   182f24bdf:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   182f24be4:	c7 44 24 28 74 01 00 	mov    DWORD PTR [rsp+0x28],0x174
   182f24beb:	00 
   182f24bec:	4c 8d 0d 0d 44 4c 06 	lea    r9,[rip+0x64c440d]        # 0x1893e9000
   182f24bf3:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f24bfa:	ba 04 00 00 00       	mov    edx,0x4
   182f24bff:	4d 89 f0             	mov    r8,r14
   182f24c02:	e8 69 86 14 fd       	call   0x18006d270
   182f24c07:	90                   	nop
   182f24c08:	48 83 bf 50 02 00 00 	cmp    QWORD PTR [rdi+0x250],0x10
   182f24c0f:	10 
   182f24c10:	72 07                	jb     0x182f24c19
   182f24c12:	48 8b 9f 38 02 00 00 	mov    rbx,QWORD PTR [rdi+0x238]
   182f24c19:	48 89 9d b0 00 00 00 	mov    QWORD PTR [rbp+0xb0],rbx
   182f24c20:	c6 85 b8 00 00 00 00 	mov    BYTE PTR [rbp+0xb8],0x0
   182f24c27:	0f 57 c0             	xorps  xmm0,xmm0
   182f24c2a:	0f 11 85 08 02 00 00 	movups XMMWORD PTR [rbp+0x208],xmm0
   182f24c31:	0f 11 85 f8 01 00 00 	movups XMMWORD PTR [rbp+0x1f8],xmm0
   182f24c38:	0f 11 85 e8 01 00 00 	movups XMMWORD PTR [rbp+0x1e8],xmm0
   182f24c3f:	0f 11 85 d8 01 00 00 	movups XMMWORD PTR [rbp+0x1d8],xmm0
   182f24c46:	0f 11 85 c8 01 00 00 	movups XMMWORD PTR [rbp+0x1c8],xmm0
   182f24c4d:	0f 11 85 b8 01 00 00 	movups XMMWORD PTR [rbp+0x1b8],xmm0
   182f24c54:	0f 11 85 a8 01 00 00 	movups XMMWORD PTR [rbp+0x1a8],xmm0
   182f24c5b:	48 c7 85 18 02 00 00 	mov    QWORD PTR [rbp+0x218],0x0
   182f24c62:	00 00 00 00 
   182f24c66:	48 8d 85 b0 00 00 00 	lea    rax,[rbp+0xb0]
   182f24c6d:	48 89 85 a0 01 00 00 	mov    QWORD PTR [rbp+0x1a0],rax
   182f24c74:	48 8d 15 75 48 4c 06 	lea    rdx,[rip+0x64c4875]        # 0x1893e94f0
   182f24c7b:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f24c82:	4c 8d 85 a0 01 00 00 	lea    r8,[rbp+0x1a0]
   182f24c89:	e8 82 8b 14 fd       	call   0x18006d810
   182f24c8e:	90                   	nop
   182f24c8f:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f24c96:	e8 d5 86 14 fd       	call   0x18006d370
   182f24c9b:	48 8d 8d 30 02 00 00 	lea    rcx,[rbp+0x230]
   182f24ca2:	e8 69 d3 0d fd       	call   0x180002010
   182f24ca7:	48 c7 85 70 02 00 00 	mov    QWORD PTR [rbp+0x270],0x2
   182f24cae:	02 00 00 00 
   182f24cb2:	b8 05 00 00 00       	mov    eax,0x5
   182f24cb7:	48 89 85 68 02 00 00 	mov    QWORD PTR [rbp+0x268],rax
   182f24cbe:	4c 8b b5 78 02 00 00 	mov    r14,QWORD PTR [rbp+0x278]
   182f24cc5:	48 8d 8d 50 02 00 00 	lea    rcx,[rbp+0x250]
   182f24ccc:	e8 8f d3 0d fd       	call   0x180002060
   182f24cd1:	e9 c0 ee ff ff       	jmp    0x182f23b96
   182f24cd6:	b9 04 00 00 00       	mov    ecx,0x4
   182f24cdb:	e8 00 81 14 fd       	call   0x18006cde0
   182f24ce0:	85 c0                	test   eax,eax
   182f24ce2:	0f 84 fe 00 00 00    	je     0x182f24de6
   182f24ce8:	4c 8d b5 30 02 00 00 	lea    r14,[rbp+0x230]
   182f24cef:	4c 89 f1             	mov    rcx,r14
   182f24cf2:	e8 19 82 14 fd       	call   0x18006cf10
   182f24cf7:	90                   	nop
   182f24cf8:	48 83 bd 48 02 00 00 	cmp    QWORD PTR [rbp+0x248],0x10
   182f24cff:	10 
   182f24d00:	72 07                	jb     0x182f24d09
   182f24d02:	4c 8b b5 30 02 00 00 	mov    r14,QWORD PTR [rbp+0x230]
   182f24d09:	48 8d 05 70 48 4c 06 	lea    rax,[rip+0x64c4870]        # 0x1893e9580
   182f24d10:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   182f24d15:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   182f24d1c:	00 00 
   182f24d1e:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   182f24d23:	c7 44 24 28 98 01 00 	mov    DWORD PTR [rsp+0x28],0x198
   182f24d2a:	00 
   182f24d2b:	4c 8d 0d ce 42 4c 06 	lea    r9,[rip+0x64c42ce]        # 0x1893e9000
   182f24d32:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f24d39:	ba 04 00 00 00       	mov    edx,0x4
   182f24d3e:	4d 89 f0             	mov    r8,r14
   182f24d41:	e8 2a 85 14 fd       	call   0x18006d270
   182f24d46:	90                   	nop
   182f24d47:	48 83 bf 50 02 00 00 	cmp    QWORD PTR [rdi+0x250],0x10
   182f24d4e:	10 
   182f24d4f:	72 07                	jb     0x182f24d58
   182f24d51:	48 8b 9f 38 02 00 00 	mov    rbx,QWORD PTR [rdi+0x238]
   182f24d58:	48 89 9d b0 00 00 00 	mov    QWORD PTR [rbp+0xb0],rbx
   182f24d5f:	c6 85 b8 00 00 00 00 	mov    BYTE PTR [rbp+0xb8],0x0
   182f24d66:	0f 57 c0             	xorps  xmm0,xmm0
   182f24d69:	0f 11 85 08 02 00 00 	movups XMMWORD PTR [rbp+0x208],xmm0
   182f24d70:	0f 11 85 f8 01 00 00 	movups XMMWORD PTR [rbp+0x1f8],xmm0
   182f24d77:	0f 11 85 e8 01 00 00 	movups XMMWORD PTR [rbp+0x1e8],xmm0
   182f24d7e:	0f 11 85 d8 01 00 00 	movups XMMWORD PTR [rbp+0x1d8],xmm0
   182f24d85:	0f 11 85 c8 01 00 00 	movups XMMWORD PTR [rbp+0x1c8],xmm0
   182f24d8c:	0f 11 85 b8 01 00 00 	movups XMMWORD PTR [rbp+0x1b8],xmm0
   182f24d93:	0f 11 85 a8 01 00 00 	movups XMMWORD PTR [rbp+0x1a8],xmm0
   182f24d9a:	48 c7 85 18 02 00 00 	mov    QWORD PTR [rbp+0x218],0x0
   182f24da1:	00 00 00 00 
   182f24da5:	48 8d 85 b0 00 00 00 	lea    rax,[rbp+0xb0]
   182f24dac:	48 89 85 a0 01 00 00 	mov    QWORD PTR [rbp+0x1a0],rax
   182f24db3:	48 8d 15 36 47 4c 06 	lea    rdx,[rip+0x64c4736]        # 0x1893e94f0
   182f24dba:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f24dc1:	4c 8d 85 a0 01 00 00 	lea    r8,[rbp+0x1a0]
   182f24dc8:	e8 43 8a 14 fd       	call   0x18006d810
   182f24dcd:	90                   	nop
   182f24dce:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f24dd5:	e8 96 85 14 fd       	call   0x18006d370
   182f24dda:	48 8d 8d 30 02 00 00 	lea    rcx,[rbp+0x230]
   182f24de1:	e8 2a d2 0d fd       	call   0x180002010
   182f24de6:	48 c7 85 70 02 00 00 	mov    QWORD PTR [rbp+0x270],0x2
   182f24ded:	02 00 00 00 
   182f24df1:	b8 05 00 00 00       	mov    eax,0x5
   182f24df6:	48 89 85 68 02 00 00 	mov    QWORD PTR [rbp+0x268],rax
   182f24dfd:	4c 8b b5 78 02 00 00 	mov    r14,QWORD PTR [rbp+0x278]
   182f24e04:	48 8d 8d 50 02 00 00 	lea    rcx,[rbp+0x250]
   182f24e0b:	e8 50 d2 0d fd       	call   0x180002060
   182f24e10:	e9 81 ed ff ff       	jmp    0x182f23b96
   182f24e15:	b9 04 00 00 00       	mov    ecx,0x4
   182f24e1a:	e8 c1 7f 14 fd       	call   0x18006cde0
   182f24e1f:	85 c0                	test   eax,eax
   182f24e21:	0f 84 58 ed ff ff    	je     0x182f23b7f
   182f24e27:	48 8d bd b0 00 00 00 	lea    rdi,[rbp+0xb0]
   182f24e2e:	48 89 f9             	mov    rcx,rdi
   182f24e31:	e8 da 80 14 fd       	call   0x18006cf10
   182f24e36:	90                   	nop
   182f24e37:	48 83 bd c8 00 00 00 	cmp    QWORD PTR [rbp+0xc8],0x10
   182f24e3e:	10 
   182f24e3f:	72 07                	jb     0x182f24e48
   182f24e41:	48 8b bd b0 00 00 00 	mov    rdi,QWORD PTR [rbp+0xb0]
   182f24e48:	48 8d 05 31 47 4c 06 	lea    rax,[rip+0x64c4731]        # 0x1893e9580
   182f24e4f:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   182f24e54:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   182f24e5b:	00 00 
   182f24e5d:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   182f24e62:	c7 44 24 28 64 01 00 	mov    DWORD PTR [rsp+0x28],0x164
   182f24e69:	00 
   182f24e6a:	4c 8d 0d 8f 41 4c 06 	lea    r9,[rip+0x64c418f]        # 0x1893e9000
   182f24e71:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f24e78:	ba 04 00 00 00       	mov    edx,0x4
   182f24e7d:	49 89 f8             	mov    r8,rdi
   182f24e80:	e8 eb 83 14 fd       	call   0x18006d270
   182f24e85:	90                   	nop
   182f24e86:	0f 57 c0             	xorps  xmm0,xmm0
   182f24e89:	0f 29 85 10 02 00 00 	movaps XMMWORD PTR [rbp+0x210],xmm0
   182f24e90:	0f 29 85 00 02 00 00 	movaps XMMWORD PTR [rbp+0x200],xmm0
   182f24e97:	0f 29 85 f0 01 00 00 	movaps XMMWORD PTR [rbp+0x1f0],xmm0
   182f24e9e:	0f 29 85 e0 01 00 00 	movaps XMMWORD PTR [rbp+0x1e0],xmm0
   182f24ea5:	0f 29 85 d0 01 00 00 	movaps XMMWORD PTR [rbp+0x1d0],xmm0
   182f24eac:	0f 29 85 c0 01 00 00 	movaps XMMWORD PTR [rbp+0x1c0],xmm0
   182f24eb3:	0f 29 85 b0 01 00 00 	movaps XMMWORD PTR [rbp+0x1b0],xmm0
   182f24eba:	0f 29 85 a0 01 00 00 	movaps XMMWORD PTR [rbp+0x1a0],xmm0
   182f24ec1:	48 8d 15 10 47 4c 06 	lea    rdx,[rip+0x64c4710]        # 0x1893e95d8
   182f24ec8:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f24ecf:	4c 8d 85 a0 01 00 00 	lea    r8,[rbp+0x1a0]
   182f24ed6:	e8 35 89 14 fd       	call   0x18006d810
   182f24edb:	90                   	nop
   182f24edc:	e9 75 eb ff ff       	jmp    0x182f23a56
   182f24ee1:	48 8d 87 58 02 00 00 	lea    rax,[rdi+0x258]
   182f24ee8:	48 89 45 20          	mov    QWORD PTR [rbp+0x20],rax
   182f24eec:	48 8b 87 68 02 00 00 	mov    rax,QWORD PTR [rdi+0x268]
   182f24ef3:	48 89 45 28          	mov    QWORD PTR [rbp+0x28],rax
   182f24ef7:	48 8d 8d 00 01 00 00 	lea    rcx,[rbp+0x100]
   182f24efe:	48 8d 55 20          	lea    rdx,[rbp+0x20]
   182f24f02:	e8 49 ac 17 fd       	call   0x18009fb50
   182f24f07:	90                   	nop
   182f24f08:	b9 70 07 00 00       	mov    ecx,0x770
   182f24f0d:	48 03 8d 50 02 00 00 	add    rcx,QWORD PTR [rbp+0x250]
   182f24f14:	48 89 da             	mov    rdx,rbx
   182f24f17:	e8 24 67 17 fd       	call   0x18009b640
   182f24f1c:	48 89 d9             	mov    rcx,rbx
   182f24f1f:	e8 3c 2b 0e fd       	call   0x180007a60
   182f24f24:	48 83 bf 48 01 00 00 	cmp    QWORD PTR [rdi+0x148],0x0
   182f24f2b:	00 
   182f24f2c:	74 1f                	je     0x182f24f4d
   182f24f2e:	48 81 c7 38 01 00 00 	add    rdi,0x138
   182f24f35:	48 89 f9             	mov    rcx,rdi
   182f24f38:	31 d2                	xor    edx,edx
   182f24f3a:	e8 21 9b 2e fd       	call   0x18020ea60
   182f24f3f:	90                   	nop
   182f24f40:	48 8b 8d 50 02 00 00 	mov    rcx,QWORD PTR [rbp+0x250]
   182f24f47:	89 81 6c 07 00 00    	mov    DWORD PTR [rcx+0x76c],eax
   182f24f4d:	48 8d 8d a0 00 00 00 	lea    rcx,[rbp+0xa0]
   182f24f54:	48 8d 95 50 02 00 00 	lea    rdx,[rbp+0x250]
   182f24f5b:	e8 e0 a8 7f fd       	call   0x18071f840
   182f24f60:	b8 01 00 00 00       	mov    eax,0x1
   182f24f65:	48 89 85 68 02 00 00 	mov    QWORD PTR [rbp+0x268],rax
   182f24f6c:	4c 8b b5 78 02 00 00 	mov    r14,QWORD PTR [rbp+0x278]
   182f24f73:	48 8d 8d 50 02 00 00 	lea    rcx,[rbp+0x250]
   182f24f7a:	e8 e1 d0 0d fd       	call   0x180002060
   182f24f7f:	e9 12 ec ff ff       	jmp    0x182f23b96
   182f24f84:	31 c9                	xor    ecx,ecx
   182f24f86:	48 8b 90 a0 05 00 00 	mov    rdx,QWORD PTR [rax+0x5a0]
   182f24f8d:	48 89 95 a0 01 00 00 	mov    QWORD PTR [rbp+0x1a0],rdx
   182f24f94:	48 89 8d a8 01 00 00 	mov    QWORD PTR [rbp+0x1a8],rcx
   182f24f9b:	48 85 d2             	test   rdx,rdx
   182f24f9e:	74 16                	je     0x182f24fb6
   182f24fa0:	48 83 c2 58          	add    rdx,0x58
   182f24fa4:	b9 d0 07 00 00       	mov    ecx,0x7d0
   182f24fa9:	48 03 8d 00 01 00 00 	add    rcx,QWORD PTR [rbp+0x100]
   182f24fb0:	e8 6b 04 42 fd       	call   0x180345420
   182f24fb5:	90                   	nop
   182f24fb6:	48 8d 8d a0 01 00 00 	lea    rcx,[rbp+0x1a0]
   182f24fbd:	e8 9e d0 0d fd       	call   0x180002060
   182f24fc2:	48 8d 8d a0 00 00 00 	lea    rcx,[rbp+0xa0]
   182f24fc9:	48 8d bd 00 01 00 00 	lea    rdi,[rbp+0x100]
   182f24fd0:	48 89 fa             	mov    rdx,rdi
   182f24fd3:	e8 68 a8 7f fd       	call   0x18071f840
   182f24fd8:	48 89 f9             	mov    rcx,rdi
   182f24fdb:	e8 80 d0 0d fd       	call   0x180002060
   182f24fe0:	e9 8e e7 ff ff       	jmp    0x182f23773
   182f24fe5:	e8 a2 83 5e 04       	call   0x18750d38c
   182f24fea:	90                   	nop
   182f24feb:	e8 a0 3b 0e fd       	call   0x180008b90
   182f24ff0:	90                   	nop
   182f24ff1:	cc                   	int3
