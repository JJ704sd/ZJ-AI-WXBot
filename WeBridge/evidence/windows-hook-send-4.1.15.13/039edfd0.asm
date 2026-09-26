
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

00000001839edfd0 <.text+0x39ecfd0>:
   1839edfd0:	55                   	push   rbp
   1839edfd1:	41 57                	push   r15
   1839edfd3:	41 56                	push   r14
   1839edfd5:	41 55                	push   r13
   1839edfd7:	41 54                	push   r12
   1839edfd9:	56                   	push   rsi
   1839edfda:	57                   	push   rdi
   1839edfdb:	53                   	push   rbx
   1839edfdc:	48 81 ec 48 03 00 00 	sub    rsp,0x348
   1839edfe3:	48 8d ac 24 80 00 00 	lea    rbp,[rsp+0x80]
   1839edfea:	00 
   1839edfeb:	44 0f 29 85 b0 02 00 	movaps XMMWORD PTR [rbp+0x2b0],xmm8
   1839edff2:	00 
   1839edff3:	0f 29 bd a0 02 00 00 	movaps XMMWORD PTR [rbp+0x2a0],xmm7
   1839edffa:	0f 29 b5 90 02 00 00 	movaps XMMWORD PTR [rbp+0x290],xmm6
   1839ee001:	48 c7 85 88 02 00 00 	mov    QWORD PTR [rbp+0x288],0xfffffffffffffffe
   1839ee008:	fe ff ff ff 
   1839ee00c:	4c 89 8d 28 02 00 00 	mov    QWORD PTR [rbp+0x228],r9
   1839ee013:	4c 89 85 20 02 00 00 	mov    QWORD PTR [rbp+0x220],r8
   1839ee01a:	49 89 cf             	mov    r15,rcx
   1839ee01d:	48 8b bd 30 03 00 00 	mov    rdi,QWORD PTR [rbp+0x330]
   1839ee024:	8b 07                	mov    eax,DWORD PTR [rdi]
   1839ee026:	89 85 7c 02 00 00    	mov    DWORD PTR [rbp+0x27c],eax
   1839ee02c:	0f 28 35 7d 7b 35 05 	movaps xmm6,XMMWORD PTR [rip+0x5357b7d]        # 0x188d45bb0
   1839ee033:	0f 57 ff             	xorps  xmm7,xmm7
   1839ee036:	44 0f 28 05 62 66 b2 	movaps xmm8,XMMWORD PTR [rip+0x5b26662]        # 0x1895146a0
   1839ee03d:	05 
   1839ee03e:	48 bb aa aa aa aa aa 	movabs rbx,0xaaaaaaaaaaaaaaaa
   1839ee045:	aa aa aa 
   1839ee048:	48 8d b5 30 01 00 00 	lea    rsi,[rbp+0x130]
   1839ee04f:	4c 8d 25 1a 82 35 05 	lea    r12,[rip+0x535821a]        # 0x188d46270
   1839ee056:	48 89 8d 80 02 00 00 	mov    QWORD PTR [rbp+0x280],rcx
   1839ee05d:	eb 19                	jmp    0x1839ee078
   1839ee05f:	90                   	nop
   1839ee060:	48 83 c0 28          	add    rax,0x28
   1839ee064:	48 89 c2             	mov    rdx,rax
   1839ee067:	4c 89 c1             	mov    rcx,r8
   1839ee06a:	e8 71 d8 ab 03       	call   0x1874ab8e0
   1839ee06f:	45 84 ed             	test   r13b,r13b
   1839ee072:	0f 84 cd 09 00 00    	je     0x1839eea45
   1839ee078:	48 89 9d 60 01 00 00 	mov    QWORD PTR [rbp+0x160],rbx
   1839ee07f:	0f 29 b5 50 01 00 00 	movaps XMMWORD PTR [rbp+0x150],xmm6
   1839ee086:	0f 29 b5 40 01 00 00 	movaps XMMWORD PTR [rbp+0x140],xmm6
   1839ee08d:	0f 29 b5 30 01 00 00 	movaps XMMWORD PTR [rbp+0x130],xmm6
   1839ee094:	48 89 f1             	mov    rcx,rsi
   1839ee097:	31 d2                	xor    edx,edx
   1839ee099:	45 31 c0             	xor    r8d,r8d
   1839ee09c:	e8 0f 2b 00 00       	call   0x1839f0bb0
   1839ee0a1:	c7 85 30 01 00 00 92 	mov    DWORD PTR [rbp+0x130],0xffffff92
   1839ee0a8:	ff ff ff 
   1839ee0ab:	83 bd 34 01 00 00 00 	cmp    DWORD PTR [rbp+0x134],0x0
   1839ee0b2:	75 0a                	jne    0x1839ee0be
   1839ee0b4:	c7 85 34 01 00 00 aa 	mov    DWORD PTR [rbp+0x134],0xfffffbaa
   1839ee0bb:	fb ff ff 
   1839ee0be:	49 89 de             	mov    r14,rbx
   1839ee0c1:	49 89 5f 30          	mov    QWORD PTR [r15+0x30],rbx
   1839ee0c5:	41 0f 11 77 20       	movups XMMWORD PTR [r15+0x20],xmm6
   1839ee0ca:	41 0f 11 77 10       	movups XMMWORD PTR [r15+0x10],xmm6
   1839ee0cf:	41 0f 11 37          	movups XMMWORD PTR [r15],xmm6
   1839ee0d3:	8b 5f 04             	mov    ebx,DWORD PTR [rdi+0x4]
   1839ee0d6:	b9 40 00 00 00       	mov    ecx,0x40
   1839ee0db:	e8 bc d7 ab 03       	call   0x1874ab89c
   1839ee0e0:	90                   	nop
   1839ee0e1:	48 89 85 70 02 00 00 	mov    QWORD PTR [rbp+0x270],rax
   1839ee0e8:	48 89 c1             	mov    rcx,rax
   1839ee0eb:	48 89 f2             	mov    rdx,rsi
   1839ee0ee:	e8 dd 33 00 00       	call   0x1839f14d0
   1839ee0f3:	90                   	nop
   1839ee0f4:	48 8b 85 70 02 00 00 	mov    rax,QWORD PTR [rbp+0x270]
   1839ee0fb:	48 89 85 70 01 00 00 	mov    QWORD PTR [rbp+0x170],rax
   1839ee102:	48 8d 85 70 01 00 00 	lea    rax,[rbp+0x170]
   1839ee109:	48 89 44 24 30       	mov    QWORD PTR [rsp+0x30],rax
   1839ee10e:	89 5c 24 28          	mov    DWORD PTR [rsp+0x28],ebx
   1839ee112:	48 c7 44 24 20 00 00 	mov    QWORD PTR [rsp+0x20],0x0
   1839ee119:	00 00 
   1839ee11b:	48 8d 4d 10          	lea    rcx,[rbp+0x10]
   1839ee11f:	48 8d 15 da 02 3a 05 	lea    rdx,[rip+0x53a02da]        # 0x188d8e400
   1839ee126:	4c 8d 05 c3 02 3a 05 	lea    r8,[rip+0x53a02c3]        # 0x188d8e3f0
   1839ee12d:	41 b9 3e 01 00 00    	mov    r9d,0x13e
   1839ee133:	e8 e8 61 9c fc       	call   0x1803b4320
   1839ee138:	90                   	nop
   1839ee139:	48 8b 8d 70 01 00 00 	mov    rcx,QWORD PTR [rbp+0x170]
   1839ee140:	48 85 c9             	test   rcx,rcx
   1839ee143:	48 8d 9d a0 01 00 00 	lea    rbx,[rbp+0x1a0]
   1839ee14a:	74 0b                	je     0x1839ee157
   1839ee14c:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   1839ee14f:	ba 01 00 00 00       	mov    edx,0x1
   1839ee154:	ff 10                	call   QWORD PTR [rax]
   1839ee156:	90                   	nop
   1839ee157:	48 8d 8d 70 01 00 00 	lea    rcx,[rbp+0x170]
   1839ee15e:	48 8b 95 20 02 00 00 	mov    rdx,QWORD PTR [rbp+0x220]
   1839ee165:	e8 46 57 49 ff       	call   0x182e838b0
   1839ee16a:	90                   	nop
   1839ee16b:	0f 11 7b 10          	movups XMMWORD PTR [rbx+0x10],xmm7
   1839ee16f:	0f 11 3b             	movups XMMWORD PTR [rbx],xmm7
   1839ee172:	48 8b 85 28 02 00 00 	mov    rax,QWORD PTR [rbp+0x228]
   1839ee179:	48 83 78 18 10       	cmp    QWORD PTR [rax+0x18],0x10
   1839ee17e:	49 89 c5             	mov    r13,rax
   1839ee181:	72 03                	jb     0x1839ee186
   1839ee183:	4c 8b 28             	mov    r13,QWORD PTR [rax]
   1839ee186:	48 8b 58 10          	mov    rbx,QWORD PTR [rax+0x10]
   1839ee18a:	48 85 db             	test   rbx,rbx
   1839ee18d:	0f 88 eb 08 00 00    	js     0x1839eea7e
   1839ee193:	48 83 fb 0f          	cmp    rbx,0xf
   1839ee197:	77 27                	ja     0x1839ee1c0
   1839ee199:	48 89 9d b0 01 00 00 	mov    QWORD PTR [rbp+0x1b0],rbx
   1839ee1a0:	48 c7 85 b8 01 00 00 	mov    QWORD PTR [rbp+0x1b8],0xf
   1839ee1a7:	0f 00 00 00 
   1839ee1ab:	41 0f 10 45 00       	movups xmm0,XMMWORD PTR [r13+0x0]
   1839ee1b0:	48 8d 8d a0 01 00 00 	lea    rcx,[rbp+0x1a0]
   1839ee1b7:	0f 11 01             	movups XMMWORD PTR [rcx],xmm0
   1839ee1ba:	e9 8f 00 00 00       	jmp    0x1839ee24e
   1839ee1bf:	90                   	nop
   1839ee1c0:	48 89 d8             	mov    rax,rbx
   1839ee1c3:	48 83 c8 0f          	or     rax,0xf
   1839ee1c7:	48 83 f8 17          	cmp    rax,0x17
   1839ee1cb:	41 bf 16 00 00 00    	mov    r15d,0x16
   1839ee1d1:	4c 0f 43 f8          	cmovae r15,rax
   1839ee1d5:	48 3d ff 0f 00 00    	cmp    rax,0xfff
   1839ee1db:	72 33                	jb     0x1839ee210
   1839ee1dd:	49 8d 4f 28          	lea    rcx,[r15+0x28]
   1839ee1e1:	e8 b6 d6 ab 03       	call   0x1874ab89c
   1839ee1e6:	90                   	nop
   1839ee1e7:	48 85 c0             	test   rax,rax
   1839ee1ea:	0f 84 82 08 00 00    	je     0x1839eea72
   1839ee1f0:	48 89 c1             	mov    rcx,rax
   1839ee1f3:	48 83 c0 27          	add    rax,0x27
   1839ee1f7:	48 83 e0 e0          	and    rax,0xffffffffffffffe0
   1839ee1fb:	48 89 48 f8          	mov    QWORD PTR [rax-0x8],rcx
   1839ee1ff:	eb 19                	jmp    0x1839ee21a
   1839ee201:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
   1839ee208:	0f 1f 84 00 00 00 00 
   1839ee20f:	00 
   1839ee210:	49 8d 4f 01          	lea    rcx,[r15+0x1]
   1839ee214:	e8 83 d6 ab 03       	call   0x1874ab89c
   1839ee219:	90                   	nop
   1839ee21a:	48 89 85 a0 01 00 00 	mov    QWORD PTR [rbp+0x1a0],rax
   1839ee221:	48 89 9d b0 01 00 00 	mov    QWORD PTR [rbp+0x1b0],rbx
   1839ee228:	4c 89 bd b8 01 00 00 	mov    QWORD PTR [rbp+0x1b8],r15
   1839ee22f:	48 ff c3             	inc    rbx
   1839ee232:	48 89 c1             	mov    rcx,rax
   1839ee235:	4c 89 ea             	mov    rdx,r13
   1839ee238:	49 89 d8             	mov    r8,rbx
   1839ee23b:	e8 10 5e b5 03       	call   0x187544050
   1839ee240:	4c 8b bd 80 02 00 00 	mov    r15,QWORD PTR [rbp+0x280]
   1839ee247:	48 8d 8d a0 01 00 00 	lea    rcx,[rbp+0x1a0]
   1839ee24e:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1839ee251:	48 89 85 c0 01 00 00 	mov    QWORD PTR [rbp+0x1c0],rax
   1839ee258:	0f 11 79 38          	movups XMMWORD PTR [rcx+0x38],xmm7
   1839ee25c:	0f 11 79 28          	movups XMMWORD PTR [rcx+0x28],xmm7
   1839ee260:	4c 8b 6f 18          	mov    r13,QWORD PTR [rdi+0x18]
   1839ee264:	48 83 7f 20 10       	cmp    QWORD PTR [rdi+0x20],0x10
   1839ee269:	48 8d 5f 08          	lea    rbx,[rdi+0x8]
   1839ee26d:	72 04                	jb     0x1839ee273
   1839ee26f:	48 8b 5f 08          	mov    rbx,QWORD PTR [rdi+0x8]
   1839ee273:	4d 85 ed             	test   r13,r13
   1839ee276:	0f 88 fc 07 00 00    	js     0x1839eea78
   1839ee27c:	49 83 fd 0f          	cmp    r13,0xf
   1839ee280:	77 2e                	ja     0x1839ee2b0
   1839ee282:	4c 89 ad d8 01 00 00 	mov    QWORD PTR [rbp+0x1d8],r13
   1839ee289:	48 c7 85 e0 01 00 00 	mov    QWORD PTR [rbp+0x1e0],0xf
   1839ee290:	0f 00 00 00 
   1839ee294:	0f 10 03             	movups xmm0,XMMWORD PTR [rbx]
   1839ee297:	48 8d 85 a0 01 00 00 	lea    rax,[rbp+0x1a0]
   1839ee29e:	0f 11 40 28          	movups XMMWORD PTR [rax+0x28],xmm0
   1839ee2a2:	e9 90 00 00 00       	jmp    0x1839ee337
   1839ee2a7:	66 0f 1f 84 00 00 00 	nop    WORD PTR [rax+rax*1+0x0]
   1839ee2ae:	00 00 
   1839ee2b0:	4c 89 e8             	mov    rax,r13
   1839ee2b3:	48 83 c8 0f          	or     rax,0xf
   1839ee2b7:	48 83 f8 17          	cmp    rax,0x17
   1839ee2bb:	41 bf 16 00 00 00    	mov    r15d,0x16
   1839ee2c1:	4c 0f 43 f8          	cmovae r15,rax
   1839ee2c5:	48 3d ff 0f 00 00    	cmp    rax,0xfff
   1839ee2cb:	72 33                	jb     0x1839ee300
   1839ee2cd:	49 8d 4f 28          	lea    rcx,[r15+0x28]
   1839ee2d1:	e8 c6 d5 ab 03       	call   0x1874ab89c
   1839ee2d6:	90                   	nop
   1839ee2d7:	48 85 c0             	test   rax,rax
   1839ee2da:	0f 84 92 07 00 00    	je     0x1839eea72
   1839ee2e0:	48 89 c1             	mov    rcx,rax
   1839ee2e3:	48 83 c0 27          	add    rax,0x27
   1839ee2e7:	48 83 e0 e0          	and    rax,0xffffffffffffffe0
   1839ee2eb:	48 89 48 f8          	mov    QWORD PTR [rax-0x8],rcx
   1839ee2ef:	eb 19                	jmp    0x1839ee30a
   1839ee2f1:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
   1839ee2f8:	0f 1f 84 00 00 00 00 
   1839ee2ff:	00 
   1839ee300:	49 8d 4f 01          	lea    rcx,[r15+0x1]
   1839ee304:	e8 93 d5 ab 03       	call   0x1874ab89c
   1839ee309:	90                   	nop
   1839ee30a:	48 89 85 c8 01 00 00 	mov    QWORD PTR [rbp+0x1c8],rax
   1839ee311:	4c 89 ad d8 01 00 00 	mov    QWORD PTR [rbp+0x1d8],r13
   1839ee318:	4c 89 bd e0 01 00 00 	mov    QWORD PTR [rbp+0x1e0],r15
   1839ee31f:	49 ff c5             	inc    r13
   1839ee322:	48 89 c1             	mov    rcx,rax
   1839ee325:	48 89 da             	mov    rdx,rbx
   1839ee328:	4d 89 e8             	mov    r8,r13
   1839ee32b:	e8 20 5d b5 03       	call   0x187544050
   1839ee330:	4c 8b bd 80 02 00 00 	mov    r15,QWORD PTR [rbp+0x280]
   1839ee337:	48 8b 47 28          	mov    rax,QWORD PTR [rdi+0x28]
   1839ee33b:	48 89 85 e8 01 00 00 	mov    QWORD PTR [rbp+0x1e8],rax
   1839ee342:	48 8d 4d 10          	lea    rcx,[rbp+0x10]
   1839ee346:	4c 89 fa             	mov    rdx,r15
   1839ee349:	4c 8d bd 70 01 00 00 	lea    r15,[rbp+0x170]
   1839ee350:	4d 89 f8             	mov    r8,r15
   1839ee353:	e8 78 29 00 00       	call   0x1839f0cd0
   1839ee358:	90                   	nop
   1839ee359:	4c 89 f3             	mov    rbx,r14
   1839ee35c:	48 8b 85 e0 01 00 00 	mov    rax,QWORD PTR [rbp+0x1e0]
   1839ee363:	48 83 f8 10          	cmp    rax,0x10
   1839ee367:	72 38                	jb     0x1839ee3a1
   1839ee369:	48 8b 8d c8 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1c8]
   1839ee370:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1839ee374:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1839ee37b:	72 1f                	jb     0x1839ee39c
   1839ee37d:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1839ee381:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1839ee385:	4c 29 c1             	sub    rcx,r8
   1839ee388:	48 83 f9 20          	cmp    rcx,0x20
   1839ee38c:	0f 83 e0 06 00 00    	jae    0x1839eea72
   1839ee392:	48 83 c0 28          	add    rax,0x28
   1839ee396:	48 89 c2             	mov    rdx,rax
   1839ee399:	4c 89 c1             	mov    rcx,r8
   1839ee39c:	e8 3f d5 ab 03       	call   0x1874ab8e0
   1839ee3a1:	48 8b 85 b8 01 00 00 	mov    rax,QWORD PTR [rbp+0x1b8]
   1839ee3a8:	48 83 f8 10          	cmp    rax,0x10
   1839ee3ac:	72 38                	jb     0x1839ee3e6
   1839ee3ae:	48 8b 8d a0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1a0]
   1839ee3b5:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1839ee3b9:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1839ee3c0:	72 1f                	jb     0x1839ee3e1
   1839ee3c2:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1839ee3c6:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1839ee3ca:	4c 29 c1             	sub    rcx,r8
   1839ee3cd:	48 83 f9 20          	cmp    rcx,0x20
   1839ee3d1:	0f 83 9b 06 00 00    	jae    0x1839eea72
   1839ee3d7:	48 83 c0 28          	add    rax,0x28
   1839ee3db:	48 89 c2             	mov    rdx,rax
   1839ee3de:	4c 89 c1             	mov    rcx,r8
   1839ee3e1:	e8 fa d4 ab 03       	call   0x1874ab8e0
   1839ee3e6:	4c 89 f9             	mov    rcx,r15
   1839ee3e9:	e8 12 56 49 ff       	call   0x182e83a00
   1839ee3ee:	48 8b 4d 60          	mov    rcx,QWORD PTR [rbp+0x60]
   1839ee3f2:	48 85 c9             	test   rcx,rcx
   1839ee3f5:	74 0a                	je     0x1839ee401
   1839ee3f7:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   1839ee3fa:	ba 01 00 00 00       	mov    edx,0x1
   1839ee3ff:	ff 10                	call   QWORD PTR [rax]
   1839ee401:	48 8b 45 30          	mov    rax,QWORD PTR [rbp+0x30]
   1839ee405:	48 83 f8 10          	cmp    rax,0x10
   1839ee409:	72 35                	jb     0x1839ee440
   1839ee40b:	48 8b 4d 18          	mov    rcx,QWORD PTR [rbp+0x18]
   1839ee40f:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1839ee413:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1839ee41a:	72 1f                	jb     0x1839ee43b
   1839ee41c:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1839ee420:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1839ee424:	4c 29 c1             	sub    rcx,r8
   1839ee427:	48 83 f9 20          	cmp    rcx,0x20
   1839ee42b:	0f 83 41 06 00 00    	jae    0x1839eea72
   1839ee431:	48 83 c0 28          	add    rax,0x28
   1839ee435:	48 89 c2             	mov    rdx,rax
   1839ee438:	4c 89 c1             	mov    rcx,r8
   1839ee43b:	e8 a0 d4 ab 03       	call   0x1874ab8e0
   1839ee440:	48 8d 85 44 02 00 00 	lea    rax,[rbp+0x244]
   1839ee447:	48 89 58 24          	mov    QWORD PTR [rax+0x24],rbx
   1839ee44b:	0f 11 70 14          	movups XMMWORD PTR [rax+0x14],xmm6
   1839ee44f:	44 0f 29 85 30 02 00 	movaps XMMWORD PTR [rbp+0x230],xmm8
   1839ee456:	00 
   1839ee457:	c7 85 40 02 00 00 0a 	mov    DWORD PTR [rbp+0x240],0x20a
   1839ee45e:	02 00 00 
   1839ee461:	0f 11 38             	movups XMMWORD PTR [rax],xmm7
   1839ee464:	c7 40 10 00 00 00 00 	mov    DWORD PTR [rax+0x10],0x0
   1839ee46b:	b9 30 00 00 00       	mov    ecx,0x30
   1839ee470:	e8 27 d4 ab 03       	call   0x1874ab89c
   1839ee475:	90                   	nop
   1839ee476:	48 89 85 48 02 00 00 	mov    QWORD PTR [rbp+0x248],rax
   1839ee47d:	48 c7 85 58 02 00 00 	mov    QWORD PTR [rbp+0x258],0x20
   1839ee484:	20 00 00 00 
   1839ee488:	48 c7 85 60 02 00 00 	mov    QWORD PTR [rbp+0x260],0x2f
   1839ee48f:	2f 00 00 00 
   1839ee493:	0f 10 05 36 68 b2 05 	movups xmm0,XMMWORD PTR [rip+0x5b26836]        # 0x189514cd0
   1839ee49a:	0f 11 40 10          	movups XMMWORD PTR [rax+0x10],xmm0
   1839ee49e:	0f 10 05 1b 68 b2 05 	movups xmm0,XMMWORD PTR [rip+0x5b2681b]        # 0x189514cc0
   1839ee4a5:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   1839ee4a8:	c6 40 20 00          	mov    BYTE PTR [rax+0x20],0x0
   1839ee4ac:	c6 85 68 02 00 00 01 	mov    BYTE PTR [rbp+0x268],0x1
   1839ee4b3:	48 8b 5f 18          	mov    rbx,QWORD PTR [rdi+0x18]
   1839ee4b7:	48 85 db             	test   rbx,rbx
   1839ee4ba:	74 51                	je     0x1839ee50d
   1839ee4bc:	48 83 7f 20 10       	cmp    QWORD PTR [rdi+0x20],0x10
   1839ee4c1:	4c 8d 4f 08          	lea    r9,[rdi+0x8]
   1839ee4c5:	72 04                	jb     0x1839ee4cb
   1839ee4c7:	4c 8b 4f 08          	mov    r9,QWORD PTR [rdi+0x8]
   1839ee4cb:	48 83 fb 2f          	cmp    rbx,0x2f
   1839ee4cf:	76 1f                	jbe    0x1839ee4f0
   1839ee4d1:	48 8d 8d 48 02 00 00 	lea    rcx,[rbp+0x248]
   1839ee4d8:	48 89 da             	mov    rdx,rbx
   1839ee4db:	e8 70 fc 64 fc       	call   0x18003e150
   1839ee4e0:	90                   	nop
   1839ee4e1:	eb 2a                	jmp    0x1839ee50d
   1839ee4e3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
   1839ee4ea:	84 00 00 00 00 00 
   1839ee4f0:	48 89 9d 58 02 00 00 	mov    QWORD PTR [rbp+0x258],rbx
   1839ee4f7:	48 89 c1             	mov    rcx,rax
   1839ee4fa:	4c 89 ca             	mov    rdx,r9
   1839ee4fd:	49 89 d8             	mov    r8,rbx
   1839ee500:	49 89 c7             	mov    r15,rax
   1839ee503:	e8 48 5b b5 03       	call   0x187544050
   1839ee508:	41 c6 04 1f 00       	mov    BYTE PTR [r15+rbx*1],0x0
   1839ee50d:	44 8b 3f             	mov    r15d,DWORD PTR [rdi]
   1839ee510:	45 89 fd             	mov    r13d,r15d
   1839ee513:	44 8b 8d 7c 02 00 00 	mov    r9d,DWORD PTR [rbp+0x27c]
   1839ee51a:	45 29 cd             	sub    r13d,r9d
   1839ee51d:	48 8b 8d 80 02 00 00 	mov    rcx,QWORD PTR [rbp+0x280]
   1839ee524:	8b 01                	mov    eax,DWORD PTR [rcx]
   1839ee526:	44 8b 41 04          	mov    r8d,DWORD PTR [rcx+0x4]
   1839ee52a:	31 d2                	xor    edx,edx
   1839ee52c:	89 c1                	mov    ecx,eax
   1839ee52e:	44 09 c1             	or     ecx,r8d
   1839ee531:	0f 84 89 01 00 00    	je     0x1839ee6c0
   1839ee537:	48 8b 8d 80 02 00 00 	mov    rcx,QWORD PTR [rbp+0x280]
   1839ee53e:	48 8b 49 28          	mov    rcx,QWORD PTR [rcx+0x28]
   1839ee542:	48 8b 49 08          	mov    rcx,QWORD PTR [rcx+0x8]
   1839ee546:	48 85 c9             	test   rcx,rcx
   1839ee549:	75 0b                	jne    0x1839ee556
   1839ee54b:	48 8b 0d 26 ee f4 07 	mov    rcx,QWORD PTR [rip+0x7f4ee26]        # 0x18b93d378
   1839ee552:	48 8b 49 08          	mov    rcx,QWORD PTR [rcx+0x8]
   1839ee556:	44 8b 49 10          	mov    r9d,DWORD PTR [rcx+0x10]
   1839ee55a:	44 89 6c 24 20       	mov    DWORD PTR [rsp+0x20],r13d
   1839ee55f:	48 8d 8d 48 02 00 00 	lea    rcx,[rbp+0x248]
   1839ee566:	89 c2                	mov    edx,eax
   1839ee568:	e8 f3 d6 c8 fc       	call   0x18067bc60
   1839ee56d:	90                   	nop
   1839ee56e:	48 8b 85 80 02 00 00 	mov    rax,QWORD PTR [rbp+0x280]
   1839ee575:	8b 10                	mov    edx,DWORD PTR [rax]
   1839ee577:	85 d2                	test   edx,edx
   1839ee579:	0f 94 c0             	sete   al
   1839ee57c:	83 fa 92             	cmp    edx,0xffffff92
   1839ee57f:	0f 94 c1             	sete   cl
   1839ee582:	08 c1                	or     cl,al
   1839ee584:	44 8b 8d 7c 02 00 00 	mov    r9d,DWORD PTR [rbp+0x27c]
   1839ee58b:	45 85 c9             	test   r9d,r9d
   1839ee58e:	0f 95 c0             	setne  al
   1839ee591:	20 c8                	and    al,cl
   1839ee593:	3c 01                	cmp    al,0x1
   1839ee595:	0f 85 25 01 00 00    	jne    0x1839ee6c0
   1839ee59b:	b8 e8 03 00 00       	mov    eax,0x3e8
   1839ee5a0:	44 89 e9             	mov    ecx,r13d
   1839ee5a3:	d3 e0                	shl    eax,cl
   1839ee5a5:	89 c1                	mov    ecx,eax
   1839ee5a7:	e8 94 ea 9a fc       	call   0x18039d040
   1839ee5ac:	90                   	nop
   1839ee5ad:	ff 8d 7c 02 00 00    	dec    DWORD PTR [rbp+0x27c]
   1839ee5b3:	b9 02 00 00 00       	mov    ecx,0x2
   1839ee5b8:	e8 23 e8 67 fc       	call   0x18006cde0
   1839ee5bd:	41 b5 01             	mov    r13b,0x1
   1839ee5c0:	85 c0                	test   eax,eax
   1839ee5c2:	0f 84 6e 02 00 00    	je     0x1839ee836
   1839ee5c8:	48 8d 8d 00 02 00 00 	lea    rcx,[rbp+0x200]
   1839ee5cf:	e8 3c e9 67 fc       	call   0x18006cf10
   1839ee5d4:	90                   	nop
   1839ee5d5:	48 83 bd 18 02 00 00 	cmp    QWORD PTR [rbp+0x218],0x10
   1839ee5dc:	10 
   1839ee5dd:	4c 8d 85 00 02 00 00 	lea    r8,[rbp+0x200]
   1839ee5e4:	72 07                	jb     0x1839ee5ed
   1839ee5e6:	4c 8b 85 00 02 00 00 	mov    r8,QWORD PTR [rbp+0x200]
   1839ee5ed:	48 8d 05 2c 07 3a 05 	lea    rax,[rip+0x53a072c]        # 0x188d8ed20
   1839ee5f4:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1839ee5f9:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   1839ee600:	00 00 
   1839ee602:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   1839ee607:	c7 44 24 28 50 01 00 	mov    DWORD PTR [rsp+0x28],0x150
   1839ee60e:	00 
   1839ee60f:	48 8d 9d 70 01 00 00 	lea    rbx,[rbp+0x170]
   1839ee616:	48 89 d9             	mov    rcx,rbx
   1839ee619:	ba 02 00 00 00       	mov    edx,0x2
   1839ee61e:	4c 8d 0d 23 0b 3a 05 	lea    r9,[rip+0x53a0b23]        # 0x188d8f148
   1839ee625:	e8 46 ec 67 fc       	call   0x18006d270
   1839ee62a:	90                   	nop
   1839ee62b:	4c 8b 95 80 02 00 00 	mov    r10,QWORD PTR [rbp+0x280]
   1839ee632:	41 8b 4a 04          	mov    ecx,DWORD PTR [r10+0x4]
   1839ee636:	48 c7 85 90 00 00 00 	mov    QWORD PTR [rbp+0x90],0x0
   1839ee63d:	00 00 00 00 
   1839ee641:	b8 08 00 00 00       	mov    eax,0x8
   1839ee646:	89 ca                	mov    edx,ecx
   1839ee648:	0f 1f 84 00 00 00 00 	nop    DWORD PTR [rax+rax*1+0x0]
   1839ee64f:	00 
   1839ee650:	4c 63 c2             	movsxd r8,edx
   1839ee653:	49 69 d0 67 66 66 66 	imul   rdx,r8,0x66666667
   1839ee65a:	49 89 d1             	mov    r9,rdx
   1839ee65d:	49 c1 e9 3f          	shr    r9,0x3f
   1839ee661:	48 c1 fa 22          	sar    rdx,0x22
   1839ee665:	44 01 ca             	add    edx,r9d
   1839ee668:	44 8d 0c 12          	lea    r9d,[rdx+rdx*1]
   1839ee66c:	47 8d 0c 89          	lea    r9d,[r9+r9*4]
   1839ee670:	41 f7 d9             	neg    r9d
   1839ee673:	45 01 c1             	add    r9d,r8d
   1839ee676:	41 83 c1 23          	add    r9d,0x23
   1839ee67a:	4d 63 c9             	movsxd r9,r9d
   1839ee67d:	47 0f b6 0c 21       	movzx  r9d,BYTE PTR [r9+r12*1]
   1839ee682:	44 88 8c 05 90 00 00 	mov    BYTE PTR [rbp+rax*1+0x90],r9b
   1839ee689:	00 
   1839ee68a:	48 ff c0             	inc    rax
   1839ee68d:	41 83 c0 09          	add    r8d,0x9
   1839ee691:	41 83 f8 12          	cmp    r8d,0x12
   1839ee695:	77 b9                	ja     0x1839ee650
   1839ee697:	85 c9                	test   ecx,ecx
   1839ee699:	0f 88 9e 01 00 00    	js     0x1839ee83d
   1839ee69f:	c6 84 05 90 00 00 00 	mov    BYTE PTR [rbp+rax*1+0x90],0x0
   1839ee6a6:	00 
   1839ee6a7:	48 83 f8 0a          	cmp    rax,0xa
   1839ee6ab:	0f 8d a5 01 00 00    	jge    0x1839ee856
   1839ee6b1:	e9 d4 01 00 00       	jmp    0x1839ee88a
   1839ee6b6:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
   1839ee6bd:	00 00 00 
   1839ee6c0:	b3 01                	mov    bl,0x1
   1839ee6c2:	45 39 cf             	cmp    r15d,r9d
   1839ee6c5:	74 39                	je     0x1839ee700
   1839ee6c7:	48 8b 8d 80 02 00 00 	mov    rcx,QWORD PTR [rbp+0x280]
   1839ee6ce:	48 8b 41 28          	mov    rax,QWORD PTR [rcx+0x28]
   1839ee6d2:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
   1839ee6d6:	48 85 c0             	test   rax,rax
   1839ee6d9:	75 0b                	jne    0x1839ee6e6
   1839ee6db:	48 8b 05 96 ec f4 07 	mov    rax,QWORD PTR [rip+0x7f4ec96]        # 0x18b93d378
   1839ee6e2:	48 8b 40 08          	mov    rax,QWORD PTR [rax+0x8]
   1839ee6e6:	44 8b 41 04          	mov    r8d,DWORD PTR [rcx+0x4]
   1839ee6ea:	44 8b 48 10          	mov    r9d,DWORD PTR [rax+0x10]
   1839ee6ee:	44 89 6c 24 20       	mov    DWORD PTR [rsp+0x20],r13d
   1839ee6f3:	48 8d 8d 48 02 00 00 	lea    rcx,[rbp+0x248]
   1839ee6fa:	e8 61 d5 c8 fc       	call   0x18067bc60
   1839ee6ff:	90                   	nop
   1839ee700:	45 31 ed             	xor    r13d,r13d
   1839ee703:	4c 8b bd 80 02 00 00 	mov    r15,QWORD PTR [rbp+0x280]
   1839ee70a:	48 8b 85 60 02 00 00 	mov    rax,QWORD PTR [rbp+0x260]
   1839ee711:	48 83 f8 10          	cmp    rax,0x10
   1839ee715:	72 38                	jb     0x1839ee74f
   1839ee717:	48 8b 8d 48 02 00 00 	mov    rcx,QWORD PTR [rbp+0x248]
   1839ee71e:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1839ee722:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1839ee729:	72 1f                	jb     0x1839ee74a
   1839ee72b:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1839ee72f:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1839ee733:	4c 29 c1             	sub    rcx,r8
   1839ee736:	48 83 f9 20          	cmp    rcx,0x20
   1839ee73a:	0f 83 32 03 00 00    	jae    0x1839eea72
   1839ee740:	48 83 c0 28          	add    rax,0x28
   1839ee744:	48 89 c2             	mov    rdx,rax
   1839ee747:	4c 89 c1             	mov    rcx,r8
   1839ee74a:	e8 91 d1 ab 03       	call   0x1874ab8e0
   1839ee74f:	84 db                	test   bl,bl
   1839ee751:	75 6c                	jne    0x1839ee7bf
   1839ee753:	49 8b 5f 30          	mov    rbx,QWORD PTR [r15+0x30]
   1839ee757:	48 85 db             	test   rbx,rbx
   1839ee75a:	74 24                	je     0x1839ee780
   1839ee75c:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   1839ee760:	75 1e                	jne    0x1839ee780
   1839ee762:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1839ee765:	48 89 d9             	mov    rcx,rbx
   1839ee768:	ff 10                	call   QWORD PTR [rax]
   1839ee76a:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   1839ee76e:	75 10                	jne    0x1839ee780
   1839ee770:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1839ee773:	48 89 d9             	mov    rcx,rbx
   1839ee776:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1839ee779:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
   1839ee780:	49 8b 47 20          	mov    rax,QWORD PTR [r15+0x20]
   1839ee784:	48 83 f8 10          	cmp    rax,0x10
   1839ee788:	72 35                	jb     0x1839ee7bf
   1839ee78a:	49 8b 4f 08          	mov    rcx,QWORD PTR [r15+0x8]
   1839ee78e:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1839ee792:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1839ee799:	72 1f                	jb     0x1839ee7ba
   1839ee79b:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1839ee79f:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1839ee7a3:	4c 29 c1             	sub    rcx,r8
   1839ee7a6:	48 83 f9 20          	cmp    rcx,0x20
   1839ee7aa:	0f 83 c2 02 00 00    	jae    0x1839eea72
   1839ee7b0:	48 83 c0 28          	add    rax,0x28
   1839ee7b4:	48 89 c2             	mov    rdx,rax
   1839ee7b7:	4c 89 c1             	mov    rcx,r8
   1839ee7ba:	e8 21 d1 ab 03       	call   0x1874ab8e0
   1839ee7bf:	48 8b 9d 60 01 00 00 	mov    rbx,QWORD PTR [rbp+0x160]
   1839ee7c6:	48 85 db             	test   rbx,rbx
   1839ee7c9:	74 25                	je     0x1839ee7f0
   1839ee7cb:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   1839ee7cf:	75 1f                	jne    0x1839ee7f0
   1839ee7d1:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1839ee7d4:	48 89 d9             	mov    rcx,rbx
   1839ee7d7:	ff 10                	call   QWORD PTR [rax]
   1839ee7d9:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   1839ee7dd:	75 11                	jne    0x1839ee7f0
   1839ee7df:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1839ee7e2:	48 89 d9             	mov    rcx,rbx
   1839ee7e5:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1839ee7e8:	0f 1f 84 00 00 00 00 	nop    DWORD PTR [rax+rax*1+0x0]
   1839ee7ef:	00 
   1839ee7f0:	48 8b 85 50 01 00 00 	mov    rax,QWORD PTR [rbp+0x150]
   1839ee7f7:	48 83 f8 10          	cmp    rax,0x10
   1839ee7fb:	4c 89 f3             	mov    rbx,r14
   1839ee7fe:	0f 82 6b f8 ff ff    	jb     0x1839ee06f
   1839ee804:	48 8b 8d 38 01 00 00 	mov    rcx,QWORD PTR [rbp+0x138]
   1839ee80b:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1839ee80f:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1839ee816:	0f 82 4e f8 ff ff    	jb     0x1839ee06a
   1839ee81c:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1839ee820:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1839ee824:	4c 29 c1             	sub    rcx,r8
   1839ee827:	48 83 f9 20          	cmp    rcx,0x20
   1839ee82b:	0f 82 2f f8 ff ff    	jb     0x1839ee060
   1839ee831:	e9 3c 02 00 00       	jmp    0x1839eea72
   1839ee836:	31 db                	xor    ebx,ebx
   1839ee838:	e9 c6 fe ff ff       	jmp    0x1839ee703
   1839ee83d:	c6 84 05 90 00 00 00 	mov    BYTE PTR [rbp+rax*1+0x90],0x2d
   1839ee844:	2d 
   1839ee845:	48 ff c0             	inc    rax
   1839ee848:	c6 84 05 90 00 00 00 	mov    BYTE PTR [rbp+rax*1+0x90],0x0
   1839ee84f:	00 
   1839ee850:	48 83 f8 0a          	cmp    rax,0xa
   1839ee854:	7c 34                	jl     0x1839ee88a
   1839ee856:	48 01 e8             	add    rax,rbp
   1839ee859:	48 05 90 00 00 00    	add    rax,0x90
   1839ee85f:	48 ff c8             	dec    rax
   1839ee862:	48 8d 8d 99 00 00 00 	lea    rcx,[rbp+0x99]
   1839ee869:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
   1839ee870:	0f b6 10             	movzx  edx,BYTE PTR [rax]
   1839ee873:	44 0f b6 41 ff       	movzx  r8d,BYTE PTR [rcx-0x1]
   1839ee878:	44 88 00             	mov    BYTE PTR [rax],r8b
   1839ee87b:	88 51 ff             	mov    BYTE PTR [rcx-0x1],dl
   1839ee87e:	48 ff c8             	dec    rax
   1839ee881:	48 39 c1             	cmp    rcx,rax
   1839ee884:	48 8d 49 01          	lea    rcx,[rcx+0x1]
   1839ee888:	72 e6                	jb     0x1839ee870
   1839ee88a:	48 8d 85 98 00 00 00 	lea    rax,[rbp+0x98]
   1839ee891:	48 89 85 90 00 00 00 	mov    QWORD PTR [rbp+0x90],rax
   1839ee898:	41 8b 0a             	mov    ecx,DWORD PTR [r10]
   1839ee89b:	48 c7 85 e0 00 00 00 	mov    QWORD PTR [rbp+0xe0],0x0
   1839ee8a2:	00 00 00 00 
   1839ee8a6:	b8 08 00 00 00       	mov    eax,0x8
   1839ee8ab:	89 ca                	mov    edx,ecx
   1839ee8ad:	0f 1f 00             	nop    DWORD PTR [rax]
   1839ee8b0:	4c 63 c2             	movsxd r8,edx
   1839ee8b3:	49 69 d0 67 66 66 66 	imul   rdx,r8,0x66666667
   1839ee8ba:	49 89 d1             	mov    r9,rdx
   1839ee8bd:	49 c1 e9 3f          	shr    r9,0x3f
   1839ee8c1:	48 c1 fa 22          	sar    rdx,0x22
   1839ee8c5:	44 01 ca             	add    edx,r9d
   1839ee8c8:	44 8d 0c 12          	lea    r9d,[rdx+rdx*1]
   1839ee8cc:	47 8d 0c 89          	lea    r9d,[r9+r9*4]
   1839ee8d0:	41 f7 d9             	neg    r9d
   1839ee8d3:	45 01 c1             	add    r9d,r8d
   1839ee8d6:	41 83 c1 23          	add    r9d,0x23
   1839ee8da:	4d 63 c9             	movsxd r9,r9d
   1839ee8dd:	47 0f b6 0c 21       	movzx  r9d,BYTE PTR [r9+r12*1]
   1839ee8e2:	44 88 8c 05 e0 00 00 	mov    BYTE PTR [rbp+rax*1+0xe0],r9b
   1839ee8e9:	00 
   1839ee8ea:	48 ff c0             	inc    rax
   1839ee8ed:	41 83 c0 09          	add    r8d,0x9
   1839ee8f1:	41 83 f8 12          	cmp    r8d,0x12
   1839ee8f5:	77 b9                	ja     0x1839ee8b0
   1839ee8f7:	85 c9                	test   ecx,ecx
   1839ee8f9:	78 10                	js     0x1839ee90b
   1839ee8fb:	c6 84 05 e0 00 00 00 	mov    BYTE PTR [rbp+rax*1+0xe0],0x0
   1839ee902:	00 
   1839ee903:	48 83 f8 0a          	cmp    rax,0xa
   1839ee907:	7d 1b                	jge    0x1839ee924
   1839ee909:	eb 4f                	jmp    0x1839ee95a
   1839ee90b:	c6 84 05 e0 00 00 00 	mov    BYTE PTR [rbp+rax*1+0xe0],0x2d
   1839ee912:	2d 
   1839ee913:	48 ff c0             	inc    rax
   1839ee916:	c6 84 05 e0 00 00 00 	mov    BYTE PTR [rbp+rax*1+0xe0],0x0
   1839ee91d:	00 
   1839ee91e:	48 83 f8 0a          	cmp    rax,0xa
   1839ee922:	7c 36                	jl     0x1839ee95a
   1839ee924:	48 01 e8             	add    rax,rbp
   1839ee927:	48 05 e0 00 00 00    	add    rax,0xe0
   1839ee92d:	48 ff c8             	dec    rax
   1839ee930:	48 8d 8d e9 00 00 00 	lea    rcx,[rbp+0xe9]
   1839ee937:	66 0f 1f 84 00 00 00 	nop    WORD PTR [rax+rax*1+0x0]
   1839ee93e:	00 00 
   1839ee940:	0f b6 10             	movzx  edx,BYTE PTR [rax]
   1839ee943:	44 0f b6 41 ff       	movzx  r8d,BYTE PTR [rcx-0x1]
   1839ee948:	44 88 00             	mov    BYTE PTR [rax],r8b
   1839ee94b:	88 51 ff             	mov    BYTE PTR [rcx-0x1],dl
   1839ee94e:	48 ff c8             	dec    rax
   1839ee951:	48 39 c1             	cmp    rcx,rax
   1839ee954:	48 8d 49 01          	lea    rcx,[rcx+0x1]
   1839ee958:	72 e6                	jb     0x1839ee940
   1839ee95a:	48 8d 85 e8 00 00 00 	lea    rax,[rbp+0xe8]
   1839ee961:	48 89 85 e0 00 00 00 	mov    QWORD PTR [rbp+0xe0],rax
   1839ee968:	48 83 bd 60 02 00 00 	cmp    QWORD PTR [rbp+0x260],0x10
   1839ee96f:	10 
   1839ee970:	48 8d 85 48 02 00 00 	lea    rax,[rbp+0x248]
   1839ee977:	72 07                	jb     0x1839ee980
   1839ee979:	48 8b 85 48 02 00 00 	mov    rax,QWORD PTR [rbp+0x248]
   1839ee980:	48 89 45 c0          	mov    QWORD PTR [rbp-0x40],rax
   1839ee984:	c6 45 c8 00          	mov    BYTE PTR [rbp-0x38],0x0
   1839ee988:	48 8d 45 28          	lea    rax,[rbp+0x28]
   1839ee98c:	0f 11 78 50          	movups XMMWORD PTR [rax+0x50],xmm7
   1839ee990:	0f 11 78 40          	movups XMMWORD PTR [rax+0x40],xmm7
   1839ee994:	0f 11 78 30          	movups XMMWORD PTR [rax+0x30],xmm7
   1839ee998:	0f 11 78 20          	movups XMMWORD PTR [rax+0x20],xmm7
   1839ee99c:	0f 11 78 10          	movups XMMWORD PTR [rax+0x10],xmm7
   1839ee9a0:	0f 11 38             	movups XMMWORD PTR [rax],xmm7
   1839ee9a3:	48 c7 40 60 00 00 00 	mov    QWORD PTR [rax+0x60],0x0
   1839ee9aa:	00 
   1839ee9ab:	48 8d 45 c0          	lea    rax,[rbp-0x40]
   1839ee9af:	48 89 45 10          	mov    QWORD PTR [rbp+0x10],rax
   1839ee9b3:	48 8d 85 e0 00 00 00 	lea    rax,[rbp+0xe0]
   1839ee9ba:	48 89 45 18          	mov    QWORD PTR [rbp+0x18],rax
   1839ee9be:	48 8d 85 90 00 00 00 	lea    rax,[rbp+0x90]
   1839ee9c5:	48 89 45 20          	mov    QWORD PTR [rbp+0x20],rax
   1839ee9c9:	48 89 d9             	mov    rcx,rbx
   1839ee9cc:	48 8d 15 8d 07 3a 05 	lea    rdx,[rip+0x53a078d]        # 0x188d8f160
   1839ee9d3:	4c 8d 45 10          	lea    r8,[rbp+0x10]
   1839ee9d7:	e8 34 ee 67 fc       	call   0x18006d810
   1839ee9dc:	90                   	nop
   1839ee9dd:	48 89 d9             	mov    rcx,rbx
   1839ee9e0:	e8 8b e9 67 fc       	call   0x18006d370
   1839ee9e5:	48 8b 85 18 02 00 00 	mov    rax,QWORD PTR [rbp+0x218]
   1839ee9ec:	48 83 f8 10          	cmp    rax,0x10
   1839ee9f0:	4c 8b bd 80 02 00 00 	mov    r15,QWORD PTR [rbp+0x280]
   1839ee9f7:	72 34                	jb     0x1839eea2d
   1839ee9f9:	48 8b 8d 00 02 00 00 	mov    rcx,QWORD PTR [rbp+0x200]
   1839eea00:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1839eea04:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1839eea0b:	72 1b                	jb     0x1839eea28
   1839eea0d:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1839eea11:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1839eea15:	4c 29 c1             	sub    rcx,r8
   1839eea18:	48 83 f9 20          	cmp    rcx,0x20
   1839eea1c:	73 54                	jae    0x1839eea72
   1839eea1e:	48 83 c0 28          	add    rax,0x28
   1839eea22:	48 89 c2             	mov    rdx,rax
   1839eea25:	4c 89 c1             	mov    rcx,r8
   1839eea28:	e8 b3 ce ab 03       	call   0x1874ab8e0
   1839eea2d:	31 db                	xor    ebx,ebx
   1839eea2f:	48 8b 85 60 02 00 00 	mov    rax,QWORD PTR [rbp+0x260]
   1839eea36:	48 83 f8 10          	cmp    rax,0x10
   1839eea3a:	0f 83 d7 fc ff ff    	jae    0x1839ee717
   1839eea40:	e9 0a fd ff ff       	jmp    0x1839ee74f
   1839eea45:	4c 89 f8             	mov    rax,r15
   1839eea48:	0f 28 b5 90 02 00 00 	movaps xmm6,XMMWORD PTR [rbp+0x290]
   1839eea4f:	0f 28 bd a0 02 00 00 	movaps xmm7,XMMWORD PTR [rbp+0x2a0]
   1839eea56:	44 0f 28 85 b0 02 00 	movaps xmm8,XMMWORD PTR [rbp+0x2b0]
   1839eea5d:	00 
   1839eea5e:	48 81 c4 48 03 00 00 	add    rsp,0x348
   1839eea65:	5b                   	pop    rbx
   1839eea66:	5f                   	pop    rdi
   1839eea67:	5e                   	pop    rsi
   1839eea68:	41 5c                	pop    r12
   1839eea6a:	41 5d                	pop    r13
   1839eea6c:	41 5e                	pop    r14
   1839eea6e:	41 5f                	pop    r15
   1839eea70:	5d                   	pop    rbp
   1839eea71:	c3                   	ret
   1839eea72:	e8 15 e9 b1 03       	call   0x18750d38c
   1839eea77:	90                   	nop
   1839eea78:	e8 13 a1 61 fc       	call   0x180008b90
   1839eea7d:	90                   	nop
   1839eea7e:	e8 0d a1 61 fc       	call   0x180008b90
   1839eea83:	90                   	nop
   1839eea84:	cc                   	int3
