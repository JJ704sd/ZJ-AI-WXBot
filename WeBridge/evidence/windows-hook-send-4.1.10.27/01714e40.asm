
.research\wechat-4.1.10.27-reference\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000181714e40 <.text+0x1713e40>:
   181714e40:	55                   	push   rbp
   181714e41:	41 56                	push   r14
   181714e43:	56                   	push   rsi
   181714e44:	57                   	push   rdi
   181714e45:	53                   	push   rbx
   181714e46:	48 81 ec b0 02 00 00 	sub    rsp,0x2b0
   181714e4d:	48 8d ac 24 80 00 00 	lea    rbp,[rsp+0x80]
   181714e54:	00 
   181714e55:	0f 29 b5 20 02 00 00 	movaps XMMWORD PTR [rbp+0x220],xmm6
   181714e5c:	48 c7 85 18 02 00 00 	mov    QWORD PTR [rbp+0x218],0xfffffffffffffffe
   181714e63:	fe ff ff ff 
   181714e67:	4c 89 85 10 02 00 00 	mov    QWORD PTR [rbp+0x210],r8
   181714e6e:	49 89 d6             	mov    r14,rdx
   181714e71:	48 89 ce             	mov    rsi,rcx
   181714e74:	0f 28 35 45 32 a6 06 	movaps xmm6,XMMWORD PTR [rip+0x6a63245]        # 0x1881780c0
   181714e7b:	0f 29 75 30          	movaps XMMWORD PTR [rbp+0x30],xmm6
   181714e7f:	48 8d 15 03 ea de 06 	lea    rdx,[rip+0x6deea03]        # 0x188503889
   181714e86:	4c 8d 05 68 5b de 06 	lea    r8,[rip+0x6de5b68]        # 0x1884fa9f5
   181714e8d:	48 8d 8d a0 00 00 00 	lea    rcx,[rbp+0xa0]
   181714e94:	41 b9 b8 0d 00 00    	mov    r9d,0xdb8
   181714e9a:	e8 a1 7f a7 fe       	call   0x18018ce40
   181714e9f:	90                   	nop
   181714ea0:	c7 45 30 02 00 00 00 	mov    DWORD PTR [rbp+0x30],0x2
   181714ea7:	48 c7 45 40 00 00 00 	mov    QWORD PTR [rbp+0x40],0x0
   181714eae:	00 
   181714eaf:	0f 28 85 a0 00 00 00 	movaps xmm0,XMMWORD PTR [rbp+0xa0]
   181714eb6:	0f 11 45 48          	movups XMMWORD PTR [rbp+0x48],xmm0
   181714eba:	0f 57 c0             	xorps  xmm0,xmm0
   181714ebd:	0f 11 45 58          	movups XMMWORD PTR [rbp+0x58],xmm0
   181714ec1:	48 c7 45 68 00 00 00 	mov    QWORD PTR [rbp+0x68],0x0
   181714ec8:	00 
   181714ec9:	48 c7 45 70 0f 00 00 	mov    QWORD PTR [rbp+0x70],0xf
   181714ed0:	00 
   181714ed1:	e8 fa 49 23 ff       	call   0x1809498d0
   181714ed6:	90                   	nop
   181714ed7:	48 89 45 38          	mov    QWORD PTR [rbp+0x38],rax
   181714edb:	48 83 7d 70 1f       	cmp    QWORD PTR [rbp+0x70],0x1f
   181714ee0:	73 18                	jae    0x181714efa
   181714ee2:	4c 8d 0d 27 f8 dd 06 	lea    r9,[rip+0x6ddf827]        # 0x1884f4710
   181714ee9:	ba 1f 00 00 00       	mov    edx,0x1f
   181714eee:	48 8d 4d 58          	lea    rcx,[rbp+0x58]
   181714ef2:	e8 79 f5 93 fe       	call   0x180054470
   181714ef7:	90                   	nop
   181714ef8:	eb 25                	jmp    0x181714f1f
   181714efa:	48 8b 45 58          	mov    rax,QWORD PTR [rbp+0x58]
   181714efe:	48 c7 45 68 1f 00 00 	mov    QWORD PTR [rbp+0x68],0x1f
   181714f05:	00 
   181714f06:	0f 10 05 12 f8 dd 06 	movups xmm0,XMMWORD PTR [rip+0x6ddf812]        # 0x1884f471f
   181714f0d:	0f 11 40 0f          	movups XMMWORD PTR [rax+0xf],xmm0
   181714f11:	0f 10 05 f8 f7 dd 06 	movups xmm0,XMMWORD PTR [rip+0x6ddf7f8]        # 0x1884f4710
   181714f18:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   181714f1b:	c6 40 1f 00          	mov    BYTE PTR [rax+0x1f],0x0
   181714f1f:	0f 29 b5 30 01 00 00 	movaps XMMWORD PTR [rbp+0x130],xmm6
   181714f26:	0f 57 c0             	xorps  xmm0,xmm0
   181714f29:	0f 29 85 80 00 00 00 	movaps XMMWORD PTR [rbp+0x80],xmm0
   181714f30:	48 8b 8d 10 02 00 00 	mov    rcx,QWORD PTR [rbp+0x210]
   181714f37:	48 8b 41 08          	mov    rax,QWORD PTR [rcx+0x8]
   181714f3b:	48 85 c0             	test   rax,rax
   181714f3e:	74 0a                	je     0x181714f4a
   181714f40:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   181714f44:	48 8b 41 08          	mov    rax,QWORD PTR [rcx+0x8]
   181714f48:	eb 02                	jmp    0x181714f4c
   181714f4a:	31 c0                	xor    eax,eax
   181714f4c:	48 8b 09             	mov    rcx,QWORD PTR [rcx]
   181714f4f:	48 89 8d 80 00 00 00 	mov    QWORD PTR [rbp+0x80],rcx
   181714f56:	48 89 85 88 00 00 00 	mov    QWORD PTR [rbp+0x88],rax
   181714f5d:	48 8d 95 30 01 00 00 	lea    rdx,[rbp+0x130]
   181714f64:	4c 8d 85 80 00 00 00 	lea    r8,[rbp+0x80]
   181714f6b:	48 89 f1             	mov    rcx,rsi
   181714f6e:	e8 5d f8 ff ff       	call   0x1817147d0
   181714f73:	90                   	nop
   181714f74:	48 8b 8d 30 01 00 00 	mov    rcx,QWORD PTR [rbp+0x130]
   181714f7b:	48 85 c9             	test   rcx,rcx
   181714f7e:	74 47                	je     0x181714fc7
   181714f80:	48 b8 aa aa aa aa aa 	movabs rax,0xaaaaaaaaaaaaaaaa
   181714f87:	aa aa aa 
   181714f8a:	49 89 46 30          	mov    QWORD PTR [r14+0x30],rax
   181714f8e:	41 0f 11 76 20       	movups XMMWORD PTR [r14+0x20],xmm6
   181714f93:	41 0f 11 76 10       	movups XMMWORD PTR [r14+0x10],xmm6
   181714f98:	41 0f 11 36          	movups XMMWORD PTR [r14],xmm6
   181714f9c:	0f 57 c0             	xorps  xmm0,xmm0
   181714f9f:	0f 29 85 90 00 00 00 	movaps XMMWORD PTR [rbp+0x90],xmm0
   181714fa6:	48 8b 95 10 02 00 00 	mov    rdx,QWORD PTR [rbp+0x210]
   181714fad:	48 8b 42 08          	mov    rax,QWORD PTR [rdx+0x8]
   181714fb1:	48 85 c0             	test   rax,rax
   181714fb4:	0f 84 3e 01 00 00    	je     0x1817150f8
   181714fba:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   181714fbe:	48 8b 42 08          	mov    rax,QWORD PTR [rdx+0x8]
   181714fc2:	e9 33 01 00 00       	jmp    0x1817150fa
   181714fc7:	b9 04 00 00 00       	mov    ecx,0x4
   181714fcc:	e8 6f 37 95 fe       	call   0x180068740
   181714fd1:	85 c0                	test   eax,eax
   181714fd3:	0f 84 f8 00 00 00    	je     0x1817150d1
   181714fd9:	48 8d 75 e0          	lea    rsi,[rbp-0x20]
   181714fdd:	48 89 f1             	mov    rcx,rsi
   181714fe0:	e8 8b 38 95 fe       	call   0x180068870
   181714fe5:	90                   	nop
   181714fe6:	48 83 7d f8 10       	cmp    QWORD PTR [rbp-0x8],0x10
   181714feb:	72 04                	jb     0x181714ff1
   181714fed:	48 8b 75 e0          	mov    rsi,QWORD PTR [rbp-0x20]
   181714ff1:	48 8d 05 4f e9 de 06 	lea    rax,[rip+0x6dee94f]        # 0x188503947
   181714ff8:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   181714ffd:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   181715004:	00 00 
   181715006:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   18171500b:	c7 44 24 28 bb 0d 00 	mov    DWORD PTR [rsp+0x28],0xdbb
   181715012:	00 
   181715013:	4c 8d 0d db 59 de 06 	lea    r9,[rip+0x6de59db]        # 0x1884fa9f5
   18171501a:	48 8d 8d a0 00 00 00 	lea    rcx,[rbp+0xa0]
   181715021:	ba 04 00 00 00       	mov    edx,0x4
   181715026:	49 89 f0             	mov    r8,rsi
   181715029:	e8 92 3b 95 fe       	call   0x180068bc0
   18171502e:	90                   	nop
   18171502f:	0f 57 c0             	xorps  xmm0,xmm0
   181715032:	0f 29 85 b0 01 00 00 	movaps XMMWORD PTR [rbp+0x1b0],xmm0
   181715039:	0f 29 85 a0 01 00 00 	movaps XMMWORD PTR [rbp+0x1a0],xmm0
   181715040:	0f 29 85 90 01 00 00 	movaps XMMWORD PTR [rbp+0x190],xmm0
   181715047:	0f 29 85 80 01 00 00 	movaps XMMWORD PTR [rbp+0x180],xmm0
   18171504e:	0f 29 85 70 01 00 00 	movaps XMMWORD PTR [rbp+0x170],xmm0
   181715055:	0f 29 85 60 01 00 00 	movaps XMMWORD PTR [rbp+0x160],xmm0
   18171505c:	0f 29 85 50 01 00 00 	movaps XMMWORD PTR [rbp+0x150],xmm0
   181715063:	0f 29 85 40 01 00 00 	movaps XMMWORD PTR [rbp+0x140],xmm0
   18171506a:	48 8d 15 3f 92 de 06 	lea    rdx,[rip+0x6de923f]        # 0x1884fe2b0
   181715071:	48 8d 8d a0 00 00 00 	lea    rcx,[rbp+0xa0]
   181715078:	4c 8d 85 40 01 00 00 	lea    r8,[rbp+0x140]
   18171507f:	e8 dc 40 95 fe       	call   0x180069160
   181715084:	90                   	nop
   181715085:	48 8d 8d a0 00 00 00 	lea    rcx,[rbp+0xa0]
   18171508c:	e8 2f 3c 95 fe       	call   0x180068cc0
   181715091:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
   181715095:	48 83 f8 10          	cmp    rax,0x10
   181715099:	72 36                	jb     0x1817150d1
   18171509b:	48 8b 4d e0          	mov    rcx,QWORD PTR [rbp-0x20]
   18171509f:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1817150a3:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1817150aa:	72 1f                	jb     0x1817150cb
   1817150ac:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1817150b0:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1817150b4:	4c 29 c1             	sub    rcx,r8
   1817150b7:	48 83 f9 20          	cmp    rcx,0x20
   1817150bb:	0f 83 a7 07 00 00    	jae    0x181715868
   1817150c1:	48 83 c0 28          	add    rax,0x28
   1817150c5:	48 89 c2             	mov    rdx,rax
   1817150c8:	4c 89 c1             	mov    rcx,r8
   1817150cb:	e8 70 80 0f 05       	call   0x18680d140
   1817150d0:	90                   	nop
   1817150d1:	c7 44 24 20 04 00 00 	mov    DWORD PTR [rsp+0x20],0x4
   1817150d8:	00 
   1817150d9:	4c 89 f1             	mov    rcx,r14
   1817150dc:	ba 01 00 00 00       	mov    edx,0x1
   1817150e1:	41 b8 01 00 00 00    	mov    r8d,0x1
   1817150e7:	41 b9 04 00 00 00    	mov    r9d,0x4
   1817150ed:	e8 de 98 f7 01       	call   0x18368e9d0
   1817150f2:	90                   	nop
   1817150f3:	e9 c7 06 00 00       	jmp    0x1817157bf
   1817150f8:	31 c0                	xor    eax,eax
   1817150fa:	48 8b 12             	mov    rdx,QWORD PTR [rdx]
   1817150fd:	48 89 95 90 00 00 00 	mov    QWORD PTR [rbp+0x90],rdx
   181715104:	48 89 85 98 00 00 00 	mov    QWORD PTR [rbp+0x98],rax
   18171510b:	4c 8d 85 90 00 00 00 	lea    r8,[rbp+0x90]
   181715112:	4c 89 f2             	mov    rdx,r14
   181715115:	e8 06 9c f6 01       	call   0x18367ed20
   18171511a:	90                   	nop
   18171511b:	41 8b 46 04          	mov    eax,DWORD PTR [r14+0x4]
   18171511f:	41 0b 06             	or     eax,DWORD PTR [r14]
   181715122:	4c 89 b5 08 02 00 00 	mov    QWORD PTR [rbp+0x208],r14
   181715129:	0f 84 0a 01 00 00    	je     0x181715239
   18171512f:	b9 04 00 00 00       	mov    ecx,0x4
   181715134:	e8 07 36 95 fe       	call   0x180068740
   181715139:	85 c0                	test   eax,eax
   18171513b:	0f 84 7e 06 00 00    	je     0x1817157bf
   181715141:	48 8d b5 c8 01 00 00 	lea    rsi,[rbp+0x1c8]
   181715148:	48 89 f1             	mov    rcx,rsi
   18171514b:	e8 20 37 95 fe       	call   0x180068870
   181715150:	90                   	nop
   181715151:	48 83 bd e0 01 00 00 	cmp    QWORD PTR [rbp+0x1e0],0x10
   181715158:	10 
   181715159:	72 07                	jb     0x181715162
   18171515b:	48 8b b5 c8 01 00 00 	mov    rsi,QWORD PTR [rbp+0x1c8]
   181715162:	48 8d 05 de e7 de 06 	lea    rax,[rip+0x6dee7de]        # 0x188503947
   181715169:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   18171516e:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   181715175:	00 00 
   181715177:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   18171517c:	c7 44 24 28 c1 0d 00 	mov    DWORD PTR [rsp+0x28],0xdc1
   181715183:	00 
   181715184:	4c 8d 0d 6a 58 de 06 	lea    r9,[rip+0x6de586a]        # 0x1884fa9f5
   18171518b:	48 8d 8d a0 00 00 00 	lea    rcx,[rbp+0xa0]
   181715192:	ba 04 00 00 00       	mov    edx,0x4
   181715197:	49 89 f0             	mov    r8,rsi
   18171519a:	e8 21 3a 95 fe       	call   0x180068bc0
   18171519f:	90                   	nop
   1817151a0:	48 8b 85 10 02 00 00 	mov    rax,QWORD PTR [rbp+0x210]
   1817151a7:	48 8b 08             	mov    rcx,QWORD PTR [rax]
   1817151aa:	48 8d b5 e8 01 00 00 	lea    rsi,[rbp+0x1e8]
   1817151b1:	48 89 f2             	mov    rdx,rsi
   1817151b4:	e8 17 79 f7 01       	call   0x18368cad0
   1817151b9:	90                   	nop
   1817151ba:	48 83 bd 00 02 00 00 	cmp    QWORD PTR [rbp+0x200],0x10
   1817151c1:	10 
   1817151c2:	72 07                	jb     0x1817151cb
   1817151c4:	48 8b b5 e8 01 00 00 	mov    rsi,QWORD PTR [rbp+0x1e8]
   1817151cb:	48 89 75 e0          	mov    QWORD PTR [rbp-0x20],rsi
   1817151cf:	c6 45 e8 00          	mov    BYTE PTR [rbp-0x18],0x0
   1817151d3:	0f 57 c0             	xorps  xmm0,xmm0
   1817151d6:	0f 29 85 40 01 00 00 	movaps XMMWORD PTR [rbp+0x140],xmm0
   1817151dd:	0f 29 85 b0 01 00 00 	movaps XMMWORD PTR [rbp+0x1b0],xmm0
   1817151e4:	0f 29 85 a0 01 00 00 	movaps XMMWORD PTR [rbp+0x1a0],xmm0
   1817151eb:	0f 29 85 90 01 00 00 	movaps XMMWORD PTR [rbp+0x190],xmm0
   1817151f2:	0f 29 85 80 01 00 00 	movaps XMMWORD PTR [rbp+0x180],xmm0
   1817151f9:	0f 29 85 70 01 00 00 	movaps XMMWORD PTR [rbp+0x170],xmm0
   181715200:	0f 29 85 60 01 00 00 	movaps XMMWORD PTR [rbp+0x160],xmm0
   181715207:	0f 29 85 50 01 00 00 	movaps XMMWORD PTR [rbp+0x150],xmm0
   18171520e:	48 8d 45 e0          	lea    rax,[rbp-0x20]
   181715212:	48 89 85 40 01 00 00 	mov    QWORD PTR [rbp+0x140],rax
   181715219:	48 8d 15 90 e8 de 06 	lea    rdx,[rip+0x6dee890]        # 0x188503ab0
   181715220:	48 8d 8d a0 00 00 00 	lea    rcx,[rbp+0xa0]
   181715227:	4c 8d 85 40 01 00 00 	lea    r8,[rbp+0x140]
   18171522e:	e8 2d 3f 95 fe       	call   0x180069160
   181715233:	90                   	nop
   181715234:	e9 83 03 00 00       	jmp    0x1817155bc
   181715239:	48 8b 85 10 02 00 00 	mov    rax,QWORD PTR [rbp+0x210]
   181715240:	48 8b 08             	mov    rcx,QWORD PTR [rax]
   181715243:	ba 06 00 00 00       	mov    edx,0x6
   181715248:	e8 f3 8c f7 01       	call   0x18368df40
   18171524d:	90                   	nop
   18171524e:	48 8b 85 10 02 00 00 	mov    rax,QWORD PTR [rbp+0x210]
   181715255:	48 8b 08             	mov    rcx,QWORD PTR [rax]
   181715258:	48 8d 95 a0 00 00 00 	lea    rdx,[rbp+0xa0]
   18171525f:	e8 ac 8c f7 01       	call   0x18368df10
   181715264:	90                   	nop
   181715265:	48 8d 95 a0 00 00 00 	lea    rdx,[rbp+0xa0]
   18171526c:	48 89 f1             	mov    rcx,rsi
   18171526f:	e8 7c 93 ff ff       	call   0x18170e5f0
   181715274:	90                   	nop
   181715275:	48 8b 85 b8 00 00 00 	mov    rax,QWORD PTR [rbp+0xb8]
   18171527c:	48 83 f8 10          	cmp    rax,0x10
   181715280:	48 8b b5 10 02 00 00 	mov    rsi,QWORD PTR [rbp+0x210]
   181715287:	72 38                	jb     0x1817152c1
   181715289:	48 8b 8d a0 00 00 00 	mov    rcx,QWORD PTR [rbp+0xa0]
   181715290:	48 8d 50 01          	lea    rdx,[rax+0x1]
   181715294:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18171529b:	72 1f                	jb     0x1817152bc
   18171529d:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1817152a1:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1817152a5:	4c 29 c1             	sub    rcx,r8
   1817152a8:	48 83 f9 20          	cmp    rcx,0x20
   1817152ac:	0f 83 b6 05 00 00    	jae    0x181715868
   1817152b2:	48 83 c0 28          	add    rax,0x28
   1817152b6:	48 89 c2             	mov    rdx,rax
   1817152b9:	4c 89 c1             	mov    rcx,r8
   1817152bc:	e8 7f 7e 0f 05       	call   0x18680d140
   1817152c1:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1817152c4:	0f 57 c0             	xorps  xmm0,xmm0
   1817152c7:	0f 29 85 40 01 00 00 	movaps XMMWORD PTR [rbp+0x140],xmm0
   1817152ce:	48 8b 88 b0 00 00 00 	mov    rcx,QWORD PTR [rax+0xb0]
   1817152d5:	48 85 c9             	test   rcx,rcx
   1817152d8:	74 0d                	je     0x1817152e7
   1817152da:	f0 ff 41 08          	lock inc DWORD PTR [rcx+0x8]
   1817152de:	48 8b 88 b0 00 00 00 	mov    rcx,QWORD PTR [rax+0xb0]
   1817152e5:	eb 02                	jmp    0x1817152e9
   1817152e7:	31 c9                	xor    ecx,ecx
   1817152e9:	48 8b 80 a8 00 00 00 	mov    rax,QWORD PTR [rax+0xa8]
   1817152f0:	48 89 85 40 01 00 00 	mov    QWORD PTR [rbp+0x140],rax
   1817152f7:	48 89 8d 48 01 00 00 	mov    QWORD PTR [rbp+0x148],rcx
   1817152fe:	48 8d 75 e0          	lea    rsi,[rbp-0x20]
   181715302:	48 8d 9d a0 00 00 00 	lea    rbx,[rbp+0xa0]
   181715309:	48 8d bd 40 01 00 00 	lea    rdi,[rbp+0x140]
   181715310:	48 89 f1             	mov    rcx,rsi
   181715313:	48 89 da             	mov    rdx,rbx
   181715316:	49 89 f8             	mov    r8,rdi
   181715319:	e8 d2 b1 fa ff       	call   0x1816c04f0
   18171531e:	90                   	nop
   18171531f:	48 8b 85 a0 00 00 00 	mov    rax,QWORD PTR [rbp+0xa0]
   181715326:	48 8b 8d 08 02 00 00 	mov    rcx,QWORD PTR [rbp+0x208]
   18171532d:	48 89 01             	mov    QWORD PTR [rcx],rax
   181715330:	48 39 d9             	cmp    rcx,rbx
   181715333:	74 41                	je     0x181715376
   181715335:	48 8b 9d b8 00 00 00 	mov    rbx,QWORD PTR [rbp+0xb8]
   18171533c:	48 83 bd c0 00 00 00 	cmp    QWORD PTR [rbp+0xc0],0x10
   181715343:	10 
   181715344:	72 09                	jb     0x18171534f
   181715346:	4c 8b 8d a8 00 00 00 	mov    r9,QWORD PTR [rbp+0xa8]
   18171534d:	eb 07                	jmp    0x181715356
   18171534f:	4c 8d 8d a8 00 00 00 	lea    r9,[rbp+0xa8]
   181715356:	48 8b 8d 08 02 00 00 	mov    rcx,QWORD PTR [rbp+0x208]
   18171535d:	4c 8d 71 08          	lea    r14,[rcx+0x8]
   181715361:	48 8b 41 20          	mov    rax,QWORD PTR [rcx+0x20]
   181715365:	48 39 c3             	cmp    rbx,rax
   181715368:	76 25                	jbe    0x18171538f
   18171536a:	4c 89 f1             	mov    rcx,r14
   18171536d:	48 89 da             	mov    rdx,rbx
   181715370:	e8 fb f0 93 fe       	call   0x180054470
   181715375:	90                   	nop
   181715376:	48 8b 85 d0 00 00 00 	mov    rax,QWORD PTR [rbp+0xd0]
   18171537d:	48 85 c0             	test   rax,rax
   181715380:	74 3a                	je     0x1817153bc
   181715382:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   181715386:	48 8b 85 d0 00 00 00 	mov    rax,QWORD PTR [rbp+0xd0]
   18171538d:	eb 2f                	jmp    0x1817153be
   18171538f:	48 83 f8 10          	cmp    rax,0x10
   181715393:	72 04                	jb     0x181715399
   181715395:	4c 8b 71 08          	mov    r14,QWORD PTR [rcx+0x8]
   181715399:	48 89 59 18          	mov    QWORD PTR [rcx+0x18],rbx
   18171539d:	4c 89 f1             	mov    rcx,r14
   1817153a0:	4c 89 ca             	mov    rdx,r9
   1817153a3:	49 89 d8             	mov    r8,rbx
   1817153a6:	e8 25 0d 18 05       	call   0x1868960d0
   1817153ab:	41 c6 04 1e 00       	mov    BYTE PTR [r14+rbx*1],0x0
   1817153b0:	48 8b 85 d0 00 00 00 	mov    rax,QWORD PTR [rbp+0xd0]
   1817153b7:	48 85 c0             	test   rax,rax
   1817153ba:	75 c6                	jne    0x181715382
   1817153bc:	31 c0                	xor    eax,eax
   1817153be:	4c 8b b5 08 02 00 00 	mov    r14,QWORD PTR [rbp+0x208]
   1817153c5:	48 8b 8d c8 00 00 00 	mov    rcx,QWORD PTR [rbp+0xc8]
   1817153cc:	49 89 4e 28          	mov    QWORD PTR [r14+0x28],rcx
   1817153d0:	49 8b 5e 30          	mov    rbx,QWORD PTR [r14+0x30]
   1817153d4:	49 89 46 30          	mov    QWORD PTR [r14+0x30],rax
   1817153d8:	48 85 db             	test   rbx,rbx
   1817153db:	74 1d                	je     0x1817153fa
   1817153dd:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   1817153e1:	75 17                	jne    0x1817153fa
   1817153e3:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1817153e6:	48 89 d9             	mov    rcx,rbx
   1817153e9:	ff 10                	call   QWORD PTR [rax]
   1817153eb:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   1817153ef:	75 09                	jne    0x1817153fa
   1817153f1:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1817153f4:	48 89 d9             	mov    rcx,rbx
   1817153f7:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1817153fa:	48 8b 9d d0 00 00 00 	mov    rbx,QWORD PTR [rbp+0xd0]
   181715401:	48 85 db             	test   rbx,rbx
   181715404:	74 1d                	je     0x181715423
   181715406:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   18171540a:	75 17                	jne    0x181715423
   18171540c:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   18171540f:	48 89 d9             	mov    rcx,rbx
   181715412:	ff 10                	call   QWORD PTR [rax]
   181715414:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   181715418:	75 09                	jne    0x181715423
   18171541a:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   18171541d:	48 89 d9             	mov    rcx,rbx
   181715420:	ff 50 08             	call   QWORD PTR [rax+0x8]
   181715423:	48 8b 85 c0 00 00 00 	mov    rax,QWORD PTR [rbp+0xc0]
   18171542a:	48 83 f8 10          	cmp    rax,0x10
   18171542e:	72 38                	jb     0x181715468
   181715430:	48 8b 8d a8 00 00 00 	mov    rcx,QWORD PTR [rbp+0xa8]
   181715437:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18171543b:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   181715442:	72 1f                	jb     0x181715463
   181715444:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   181715448:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18171544c:	4c 29 c1             	sub    rcx,r8
   18171544f:	48 83 f9 20          	cmp    rcx,0x20
   181715453:	0f 83 0f 04 00 00    	jae    0x181715868
   181715459:	48 83 c0 28          	add    rax,0x28
   18171545d:	48 89 c2             	mov    rdx,rax
   181715460:	4c 89 c1             	mov    rcx,r8
   181715463:	e8 d8 7c 0f 05       	call   0x18680d140
   181715468:	48 c7 85 b8 00 00 00 	mov    QWORD PTR [rbp+0xb8],0x0
   18171546f:	00 00 00 00 
   181715473:	48 c7 85 c0 00 00 00 	mov    QWORD PTR [rbp+0xc0],0xf
   18171547a:	0f 00 00 00 
   18171547e:	c6 85 a8 00 00 00 00 	mov    BYTE PTR [rbp+0xa8],0x0
   181715485:	48 8b 9d 48 01 00 00 	mov    rbx,QWORD PTR [rbp+0x148]
   18171548c:	48 85 db             	test   rbx,rbx
   18171548f:	74 1d                	je     0x1817154ae
   181715491:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   181715495:	75 17                	jne    0x1817154ae
   181715497:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   18171549a:	48 89 d9             	mov    rcx,rbx
   18171549d:	ff 10                	call   QWORD PTR [rax]
   18171549f:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   1817154a3:	75 09                	jne    0x1817154ae
   1817154a5:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   1817154a8:	48 89 d9             	mov    rcx,rbx
   1817154ab:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1817154ae:	41 8b 46 04          	mov    eax,DWORD PTR [r14+0x4]
   1817154b2:	41 0b 06             	or     eax,DWORD PTR [r14]
   1817154b5:	0f 84 87 01 00 00    	je     0x181715642
   1817154bb:	b9 04 00 00 00       	mov    ecx,0x4
   1817154c0:	e8 7b 32 95 fe       	call   0x180068740
   1817154c5:	85 c0                	test   eax,eax
   1817154c7:	0f 84 f2 02 00 00    	je     0x1817157bf
   1817154cd:	48 8d bd c8 01 00 00 	lea    rdi,[rbp+0x1c8]
   1817154d4:	48 89 f9             	mov    rcx,rdi
   1817154d7:	e8 94 33 95 fe       	call   0x180068870
   1817154dc:	90                   	nop
   1817154dd:	48 83 bd e0 01 00 00 	cmp    QWORD PTR [rbp+0x1e0],0x10
   1817154e4:	10 
   1817154e5:	72 07                	jb     0x1817154ee
   1817154e7:	48 8b bd c8 01 00 00 	mov    rdi,QWORD PTR [rbp+0x1c8]
   1817154ee:	48 8d 05 52 e4 de 06 	lea    rax,[rip+0x6dee452]        # 0x188503947
   1817154f5:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1817154fa:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   181715501:	00 00 
   181715503:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   181715508:	c7 44 24 28 cb 0d 00 	mov    DWORD PTR [rsp+0x28],0xdcb
   18171550f:	00 
   181715510:	4c 8d 0d de 54 de 06 	lea    r9,[rip+0x6de54de]        # 0x1884fa9f5
   181715517:	48 8d 8d a0 00 00 00 	lea    rcx,[rbp+0xa0]
   18171551e:	ba 04 00 00 00       	mov    edx,0x4
   181715523:	49 89 f8             	mov    r8,rdi
   181715526:	e8 95 36 95 fe       	call   0x180068bc0
   18171552b:	90                   	nop
   18171552c:	48 8b 85 10 02 00 00 	mov    rax,QWORD PTR [rbp+0x210]
   181715533:	48 8b 08             	mov    rcx,QWORD PTR [rax]
   181715536:	48 8d bd e8 01 00 00 	lea    rdi,[rbp+0x1e8]
   18171553d:	48 89 fa             	mov    rdx,rdi
   181715540:	e8 8b 75 f7 01       	call   0x18368cad0
   181715545:	90                   	nop
   181715546:	48 83 bd 00 02 00 00 	cmp    QWORD PTR [rbp+0x200],0x10
   18171554d:	10 
   18171554e:	72 07                	jb     0x181715557
   181715550:	48 8b bd e8 01 00 00 	mov    rdi,QWORD PTR [rbp+0x1e8]
   181715557:	48 89 7d e0          	mov    QWORD PTR [rbp-0x20],rdi
   18171555b:	c6 45 e8 00          	mov    BYTE PTR [rbp-0x18],0x0
   18171555f:	0f 57 c0             	xorps  xmm0,xmm0
   181715562:	0f 29 85 40 01 00 00 	movaps XMMWORD PTR [rbp+0x140],xmm0
   181715569:	0f 29 85 b0 01 00 00 	movaps XMMWORD PTR [rbp+0x1b0],xmm0
   181715570:	0f 29 85 a0 01 00 00 	movaps XMMWORD PTR [rbp+0x1a0],xmm0
   181715577:	0f 29 85 90 01 00 00 	movaps XMMWORD PTR [rbp+0x190],xmm0
   18171557e:	0f 29 85 80 01 00 00 	movaps XMMWORD PTR [rbp+0x180],xmm0
   181715585:	0f 29 85 70 01 00 00 	movaps XMMWORD PTR [rbp+0x170],xmm0
   18171558c:	0f 29 85 60 01 00 00 	movaps XMMWORD PTR [rbp+0x160],xmm0
   181715593:	0f 29 85 50 01 00 00 	movaps XMMWORD PTR [rbp+0x150],xmm0
   18171559a:	48 89 b5 40 01 00 00 	mov    QWORD PTR [rbp+0x140],rsi
   1817155a1:	48 8d 15 6d e5 de 06 	lea    rdx,[rip+0x6dee56d]        # 0x188503b15
   1817155a8:	48 8d 8d a0 00 00 00 	lea    rcx,[rbp+0xa0]
   1817155af:	4c 8d 85 40 01 00 00 	lea    r8,[rbp+0x140]
   1817155b6:	e8 a5 3b 95 fe       	call   0x180069160
   1817155bb:	90                   	nop
   1817155bc:	48 8b 85 00 02 00 00 	mov    rax,QWORD PTR [rbp+0x200]
   1817155c3:	48 83 f8 10          	cmp    rax,0x10
   1817155c7:	4c 8b b5 08 02 00 00 	mov    r14,QWORD PTR [rbp+0x208]
   1817155ce:	72 38                	jb     0x181715608
   1817155d0:	48 8b 8d e8 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1e8]
   1817155d7:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1817155db:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1817155e2:	72 1f                	jb     0x181715603
   1817155e4:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1817155e8:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1817155ec:	4c 29 c1             	sub    rcx,r8
   1817155ef:	48 83 f9 20          	cmp    rcx,0x20
   1817155f3:	0f 83 6f 02 00 00    	jae    0x181715868
   1817155f9:	48 83 c0 28          	add    rax,0x28
   1817155fd:	48 89 c2             	mov    rdx,rax
   181715600:	4c 89 c1             	mov    rcx,r8
   181715603:	e8 38 7b 0f 05       	call   0x18680d140
   181715608:	48 8d 8d a0 00 00 00 	lea    rcx,[rbp+0xa0]
   18171560f:	e8 ac 36 95 fe       	call   0x180068cc0
   181715614:	48 8b 85 e0 01 00 00 	mov    rax,QWORD PTR [rbp+0x1e0]
   18171561b:	48 83 f8 10          	cmp    rax,0x10
   18171561f:	0f 82 9a 01 00 00    	jb     0x1817157bf
   181715625:	48 8b 8d c8 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1c8]
   18171562c:	48 8d 50 01          	lea    rdx,[rax+0x1]
   181715630:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   181715637:	0f 82 7d 01 00 00    	jb     0x1817157ba
   18171563d:	e9 59 01 00 00       	jmp    0x18171579b
   181715642:	48 8b 85 10 02 00 00 	mov    rax,QWORD PTR [rbp+0x210]
   181715649:	48 8b 08             	mov    rcx,QWORD PTR [rax]
   18171564c:	48 8d b5 a0 00 00 00 	lea    rsi,[rbp+0xa0]
   181715653:	48 89 f2             	mov    rdx,rsi
   181715656:	e8 75 74 f7 01       	call   0x18368cad0
   18171565b:	90                   	nop
   18171565c:	48 c7 85 48 01 00 00 	mov    QWORD PTR [rbp+0x148],0x0
   181715663:	00 00 00 00 
   181715667:	48 c7 85 50 01 00 00 	mov    QWORD PTR [rbp+0x150],0xb
   18171566e:	0b 00 00 00 
   181715672:	48 c7 85 58 01 00 00 	mov    QWORD PTR [rbp+0x158],0xf
   181715679:	0f 00 00 00 
   18171567d:	48 b8 73 65 6e 64 20 	movabs rax,0x6e696620646e6573
   181715684:	66 69 6e 
   181715687:	48 89 85 40 01 00 00 	mov    QWORD PTR [rbp+0x140],rax
   18171568e:	c7 85 47 01 00 00 6e 	mov    DWORD PTR [rbp+0x147],0x6873696e
   181715695:	69 73 68 
   181715698:	48 8b 9d b0 00 00 00 	mov    rbx,QWORD PTR [rbp+0xb0]
   18171569f:	48 83 bd b8 00 00 00 	cmp    QWORD PTR [rbp+0xb8],0x10
   1817156a6:	10 
   1817156a7:	72 07                	jb     0x1817156b0
   1817156a9:	48 8b b5 a0 00 00 00 	mov    rsi,QWORD PTR [rbp+0xa0]
   1817156b0:	48 83 fb 04          	cmp    rbx,0x4
   1817156b4:	76 1d                	jbe    0x1817156d3
   1817156b6:	48 89 5c 24 20       	mov    QWORD PTR [rsp+0x20],rbx
   1817156bb:	48 8d 8d 40 01 00 00 	lea    rcx,[rbp+0x140]
   1817156c2:	48 89 da             	mov    rdx,rbx
   1817156c5:	49 89 f1             	mov    r9,rsi
   1817156c8:	e8 23 3b 8f fe       	call   0x1800091f0
   1817156cd:	90                   	nop
   1817156ce:	48 89 c7             	mov    rdi,rax
   1817156d1:	eb 25                	jmp    0x1817156f8
   1817156d3:	48 8d 8d 4b 01 00 00 	lea    rcx,[rbp+0x14b]
   1817156da:	48 8d 43 0b          	lea    rax,[rbx+0xb]
   1817156de:	48 89 85 50 01 00 00 	mov    QWORD PTR [rbp+0x150],rax
   1817156e5:	48 89 f2             	mov    rdx,rsi
   1817156e8:	49 89 d8             	mov    r8,rbx
   1817156eb:	e8 e0 09 18 05       	call   0x1868960d0
   1817156f0:	c6 84 1d 4b 01 00 00 	mov    BYTE PTR [rbp+rbx*1+0x14b],0x0
   1817156f7:	00 
   1817156f8:	0f 10 07             	movups xmm0,XMMWORD PTR [rdi]
   1817156fb:	0f 10 4f 10          	movups xmm1,XMMWORD PTR [rdi+0x10]
   1817156ff:	0f 29 4d d0          	movaps XMMWORD PTR [rbp-0x30],xmm1
   181715703:	0f 29 45 c0          	movaps XMMWORD PTR [rbp-0x40],xmm0
   181715707:	48 c7 47 10 00 00 00 	mov    QWORD PTR [rdi+0x10],0x0
   18171570e:	00 
   18171570f:	48 c7 47 18 0f 00 00 	mov    QWORD PTR [rdi+0x18],0xf
   181715716:	00 
   181715717:	c6 07 00             	mov    BYTE PTR [rdi],0x0
   18171571a:	48 8d 4d 30          	lea    rcx,[rbp+0x30]
   18171571e:	48 8d 55 c0          	lea    rdx,[rbp-0x40]
   181715722:	41 b8 32 00 00 00    	mov    r8d,0x32
   181715728:	e8 73 4b 81 ff       	call   0x180f2a2a0
   18171572d:	90                   	nop
   18171572e:	48 8b 85 58 01 00 00 	mov    rax,QWORD PTR [rbp+0x158]
   181715735:	48 83 f8 10          	cmp    rax,0x10
   181715739:	4c 8b b5 08 02 00 00 	mov    r14,QWORD PTR [rbp+0x208]
   181715740:	72 38                	jb     0x18171577a
   181715742:	48 8b 8d 40 01 00 00 	mov    rcx,QWORD PTR [rbp+0x140]
   181715749:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18171574d:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   181715754:	72 1f                	jb     0x181715775
   181715756:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18171575a:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18171575e:	4c 29 c1             	sub    rcx,r8
   181715761:	48 83 f9 20          	cmp    rcx,0x20
   181715765:	0f 83 fd 00 00 00    	jae    0x181715868
   18171576b:	48 83 c0 28          	add    rax,0x28
   18171576f:	48 89 c2             	mov    rdx,rax
   181715772:	4c 89 c1             	mov    rcx,r8
   181715775:	e8 c6 79 0f 05       	call   0x18680d140
   18171577a:	48 8b 85 b8 00 00 00 	mov    rax,QWORD PTR [rbp+0xb8]
   181715781:	48 83 f8 10          	cmp    rax,0x10
   181715785:	72 38                	jb     0x1817157bf
   181715787:	48 8b 8d a0 00 00 00 	mov    rcx,QWORD PTR [rbp+0xa0]
   18171578e:	48 8d 50 01          	lea    rdx,[rax+0x1]
   181715792:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   181715799:	72 1f                	jb     0x1817157ba
   18171579b:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18171579f:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1817157a3:	4c 29 c1             	sub    rcx,r8
   1817157a6:	48 83 f9 20          	cmp    rcx,0x20
   1817157aa:	0f 83 b8 00 00 00    	jae    0x181715868
   1817157b0:	48 83 c0 28          	add    rax,0x28
   1817157b4:	48 89 c2             	mov    rdx,rax
   1817157b7:	4c 89 c1             	mov    rcx,r8
   1817157ba:	e8 81 79 0f 05       	call   0x18680d140
   1817157bf:	48 8b b5 38 01 00 00 	mov    rsi,QWORD PTR [rbp+0x138]
   1817157c6:	48 85 f6             	test   rsi,rsi
   1817157c9:	74 1d                	je     0x1817157e8
   1817157cb:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   1817157cf:	75 17                	jne    0x1817157e8
   1817157d1:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1817157d4:	48 89 f1             	mov    rcx,rsi
   1817157d7:	ff 10                	call   QWORD PTR [rax]
   1817157d9:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   1817157dd:	75 09                	jne    0x1817157e8
   1817157df:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1817157e2:	48 89 f1             	mov    rcx,rsi
   1817157e5:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1817157e8:	48 8b 45 70          	mov    rax,QWORD PTR [rbp+0x70]
   1817157ec:	48 83 f8 10          	cmp    rax,0x10
   1817157f0:	48 8b b5 10 02 00 00 	mov    rsi,QWORD PTR [rbp+0x210]
   1817157f7:	72 31                	jb     0x18171582a
   1817157f9:	48 8b 4d 58          	mov    rcx,QWORD PTR [rbp+0x58]
   1817157fd:	48 8d 50 01          	lea    rdx,[rax+0x1]
   181715801:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   181715808:	72 1b                	jb     0x181715825
   18171580a:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18171580e:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   181715812:	4c 29 c1             	sub    rcx,r8
   181715815:	48 83 f9 20          	cmp    rcx,0x20
   181715819:	73 4d                	jae    0x181715868
   18171581b:	48 83 c0 28          	add    rax,0x28
   18171581f:	48 89 c2             	mov    rdx,rax
   181715822:	4c 89 c1             	mov    rcx,r8
   181715825:	e8 16 79 0f 05       	call   0x18680d140
   18171582a:	48 8b 76 08          	mov    rsi,QWORD PTR [rsi+0x8]
   18171582e:	48 85 f6             	test   rsi,rsi
   181715831:	74 1d                	je     0x181715850
   181715833:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   181715837:	75 17                	jne    0x181715850
   181715839:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   18171583c:	48 89 f1             	mov    rcx,rsi
   18171583f:	ff 10                	call   QWORD PTR [rax]
   181715841:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   181715845:	75 09                	jne    0x181715850
   181715847:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   18171584a:	48 89 f1             	mov    rcx,rsi
   18171584d:	ff 50 08             	call   QWORD PTR [rax+0x8]
   181715850:	4c 89 f0             	mov    rax,r14
   181715853:	0f 28 b5 20 02 00 00 	movaps xmm6,XMMWORD PTR [rbp+0x220]
   18171585a:	48 81 c4 b0 02 00 00 	add    rsp,0x2b0
   181715861:	5b                   	pop    rbx
   181715862:	5f                   	pop    rdi
   181715863:	5e                   	pop    rsi
   181715864:	41 5e                	pop    r14
   181715866:	5d                   	pop    rbp
   181715867:	c3                   	ret
   181715868:	e8 0b ac 14 05       	call   0x186860478
   18171586d:	cc                   	int3
