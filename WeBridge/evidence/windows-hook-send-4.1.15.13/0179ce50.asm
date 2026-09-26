
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

000000018179ce50 <.text+0x179be50>:
   18179ce50:	55                   	push   rbp
   18179ce51:	41 57                	push   r15
   18179ce53:	41 56                	push   r14
   18179ce55:	41 55                	push   r13
   18179ce57:	41 54                	push   r12
   18179ce59:	56                   	push   rsi
   18179ce5a:	57                   	push   rdi
   18179ce5b:	53                   	push   rbx
   18179ce5c:	48 81 ec f8 04 00 00 	sub    rsp,0x4f8
   18179ce63:	48 8d ac 24 80 00 00 	lea    rbp,[rsp+0x80]
   18179ce6a:	00 
   18179ce6b:	0f 29 bd 60 04 00 00 	movaps XMMWORD PTR [rbp+0x460],xmm7
   18179ce72:	0f 29 b5 50 04 00 00 	movaps XMMWORD PTR [rbp+0x450],xmm6
   18179ce79:	48 c7 85 48 04 00 00 	mov    QWORD PTR [rbp+0x448],0xfffffffffffffffe
   18179ce80:	fe ff ff ff 
   18179ce84:	4c 89 c7             	mov    rdi,r8
   18179ce87:	48 89 d6             	mov    rsi,rdx
   18179ce8a:	48 89 8d c8 01 00 00 	mov    QWORD PTR [rbp+0x1c8],rcx
   18179ce91:	49 bd aa aa aa aa aa 	movabs r13,0xaaaaaaaaaaaaaaaa
   18179ce98:	aa aa aa 
   18179ce9b:	4c 89 6a 30          	mov    QWORD PTR [rdx+0x30],r13
   18179ce9f:	0f 28 35 0a 8d 5a 07 	movaps xmm6,XMMWORD PTR [rip+0x75a8d0a]        # 0x188d45bb0
   18179cea6:	0f 11 72 20          	movups XMMWORD PTR [rdx+0x20],xmm6
   18179ceaa:	0f 11 72 10          	movups XMMWORD PTR [rdx+0x10],xmm6
   18179ceae:	0f 11 32             	movups XMMWORD PTR [rdx],xmm6
   18179ceb1:	48 89 d1             	mov    rcx,rdx
   18179ceb4:	31 d2                	xor    edx,edx
   18179ceb6:	45 31 c0             	xor    r8d,r8d
   18179ceb9:	e8 12 45 00 00       	call   0x1817a13d0
   18179cebe:	48 89 bd 40 04 00 00 	mov    QWORD PTR [rbp+0x440],rdi
   18179cec5:	48 83 3f 00          	cmp    QWORD PTR [rdi],0x0
   18179cec9:	48 89 b5 28 02 00 00 	mov    QWORD PTR [rbp+0x228],rsi
   18179ced0:	0f 84 c8 02 00 00    	je     0x18179d19e
   18179ced6:	b9 02 00 00 00       	mov    ecx,0x2
   18179cedb:	e8 00 ff 8c fe       	call   0x18006cde0
   18179cee0:	48 bf cd cc cc cc cc 	movabs rdi,0xcccccccccccccccd
   18179cee7:	cc cc cc 
   18179ceea:	85 c0                	test   eax,eax
   18179ceec:	0f 84 ec 01 00 00    	je     0x18179d0de
   18179cef2:	48 8d b5 50 02 00 00 	lea    rsi,[rbp+0x250]
   18179cef9:	48 89 f1             	mov    rcx,rsi
   18179cefc:	e8 0f 00 8d fe       	call   0x18006cf10
   18179cf01:	90                   	nop
   18179cf02:	48 83 bd 68 02 00 00 	cmp    QWORD PTR [rbp+0x268],0x10
   18179cf09:	10 
   18179cf0a:	72 07                	jb     0x18179cf13
   18179cf0c:	48 8b b5 50 02 00 00 	mov    rsi,QWORD PTR [rbp+0x250]
   18179cf13:	48 8d 05 c6 13 94 07 	lea    rax,[rip+0x79413c6]        # 0x1890de2e0
   18179cf1a:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   18179cf1f:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   18179cf26:	00 00 
   18179cf28:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   18179cf2d:	c7 44 24 28 dc 02 00 	mov    DWORD PTR [rsp+0x28],0x2dc
   18179cf34:	00 
   18179cf35:	4c 8d 0d bc ee 93 07 	lea    r9,[rip+0x793eebc]        # 0x1890dbdf8
   18179cf3c:	48 8d 8d d0 02 00 00 	lea    rcx,[rbp+0x2d0]
   18179cf43:	ba 02 00 00 00       	mov    edx,0x2
   18179cf48:	49 89 f0             	mov    r8,rsi
   18179cf4b:	e8 20 03 8d fe       	call   0x18006d270
   18179cf50:	90                   	nop
   18179cf51:	48 8b 85 40 04 00 00 	mov    rax,QWORD PTR [rbp+0x440]
   18179cf58:	48 8b 00             	mov    rax,QWORD PTR [rax]
   18179cf5b:	48 8d 0d 4e 2a 5e 07 	lea    rcx,[rip+0x75e2a4e]        # 0x188d7f9b0
   18179cf62:	48 8d 15 4f 2a 5e 07 	lea    rdx,[rip+0x75e2a4f]        # 0x188d7f9b8
   18179cf69:	80 78 18 00          	cmp    BYTE PTR [rax+0x18],0x0
   18179cf6d:	48 0f 45 d1          	cmovne rdx,rcx
   18179cf71:	48 89 95 d0 01 00 00 	mov    QWORD PTR [rbp+0x1d0],rdx
   18179cf78:	c6 85 d8 01 00 00 00 	mov    BYTE PTR [rbp+0x1d8],0x0
   18179cf7f:	48 8b 48 08          	mov    rcx,QWORD PTR [rax+0x8]
   18179cf83:	48 2b 08             	sub    rcx,QWORD PTR [rax]
   18179cf86:	48 c1 f9 04          	sar    rcx,0x4
   18179cf8a:	48 c7 85 00 01 00 00 	mov    QWORD PTR [rbp+0x100],0x0
   18179cf91:	00 00 00 00 
   18179cf95:	41 b9 07 00 00 00    	mov    r9d,0x7
   18179cf9b:	4c 8d 85 07 01 00 00 	lea    r8,[rbp+0x107]
   18179cfa2:	4c 8d 15 c7 92 5a 07 	lea    r10,[rip+0x75a92c7]        # 0x188d46270
   18179cfa9:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
   18179cfb0:	48 89 c8             	mov    rax,rcx
   18179cfb3:	48 f7 e7             	mul    rdi
   18179cfb6:	48 c1 ea 03          	shr    rdx,0x3
   18179cfba:	48 8d 04 12          	lea    rax,[rdx+rdx*1]
   18179cfbe:	48 8d 04 80          	lea    rax,[rax+rax*4]
   18179cfc2:	4d 89 d3             	mov    r11,r10
   18179cfc5:	49 29 c3             	sub    r11,rax
   18179cfc8:	41 0f b6 44 0b 23    	movzx  eax,BYTE PTR [r11+rcx*1+0x23]
   18179cfce:	41 88 40 01          	mov    BYTE PTR [r8+0x1],al
   18179cfd2:	49 ff c0             	inc    r8
   18179cfd5:	49 ff c1             	inc    r9
   18179cfd8:	48 83 f9 09          	cmp    rcx,0x9
   18179cfdc:	48 89 d1             	mov    rcx,rdx
   18179cfdf:	77 cf                	ja     0x18179cfb0
   18179cfe1:	48 8d 85 08 01 00 00 	lea    rax,[rbp+0x108]
   18179cfe8:	41 c6 40 01 00       	mov    BYTE PTR [r8+0x1],0x0
   18179cfed:	49 83 f9 09          	cmp    r9,0x9
   18179cff1:	72 28                	jb     0x18179d01b
   18179cff3:	48 8d 8d 09 01 00 00 	lea    rcx,[rbp+0x109]
   18179cffa:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
   18179d000:	41 0f b6 10          	movzx  edx,BYTE PTR [r8]
   18179d004:	44 0f b6 49 ff       	movzx  r9d,BYTE PTR [rcx-0x1]
   18179d009:	45 88 08             	mov    BYTE PTR [r8],r9b
   18179d00c:	49 ff c8             	dec    r8
   18179d00f:	88 51 ff             	mov    BYTE PTR [rcx-0x1],dl
   18179d012:	4c 39 c1             	cmp    rcx,r8
   18179d015:	48 8d 49 01          	lea    rcx,[rcx+0x1]
   18179d019:	72 e5                	jb     0x18179d000
   18179d01b:	48 89 85 00 01 00 00 	mov    QWORD PTR [rbp+0x100],rax
   18179d022:	0f 57 c0             	xorps  xmm0,xmm0
   18179d025:	0f 11 85 d0 03 00 00 	movups XMMWORD PTR [rbp+0x3d0],xmm0
   18179d02c:	0f 11 85 c0 03 00 00 	movups XMMWORD PTR [rbp+0x3c0],xmm0
   18179d033:	0f 11 85 b0 03 00 00 	movups XMMWORD PTR [rbp+0x3b0],xmm0
   18179d03a:	0f 11 85 a0 03 00 00 	movups XMMWORD PTR [rbp+0x3a0],xmm0
   18179d041:	0f 11 85 90 03 00 00 	movups XMMWORD PTR [rbp+0x390],xmm0
   18179d048:	0f 11 85 80 03 00 00 	movups XMMWORD PTR [rbp+0x380],xmm0
   18179d04f:	0f 11 85 70 03 00 00 	movups XMMWORD PTR [rbp+0x370],xmm0
   18179d056:	48 8d 85 00 01 00 00 	lea    rax,[rbp+0x100]
   18179d05d:	48 89 85 60 03 00 00 	mov    QWORD PTR [rbp+0x360],rax
   18179d064:	48 8d 85 d0 01 00 00 	lea    rax,[rbp+0x1d0]
   18179d06b:	48 89 85 68 03 00 00 	mov    QWORD PTR [rbp+0x368],rax
   18179d072:	48 8d 15 d7 1e 94 07 	lea    rdx,[rip+0x7941ed7]        # 0x1890def50
   18179d079:	48 8d 8d d0 02 00 00 	lea    rcx,[rbp+0x2d0]
   18179d080:	4c 8d 85 60 03 00 00 	lea    r8,[rbp+0x360]
   18179d087:	e8 84 07 8d fe       	call   0x18006d810
   18179d08c:	90                   	nop
   18179d08d:	48 8d 8d d0 02 00 00 	lea    rcx,[rbp+0x2d0]
   18179d094:	e8 d7 02 8d fe       	call   0x18006d370
   18179d099:	48 8b 85 68 02 00 00 	mov    rax,QWORD PTR [rbp+0x268]
   18179d0a0:	48 83 f8 10          	cmp    rax,0x10
   18179d0a4:	72 38                	jb     0x18179d0de
   18179d0a6:	48 8b 8d 50 02 00 00 	mov    rcx,QWORD PTR [rbp+0x250]
   18179d0ad:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18179d0b1:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18179d0b8:	72 1f                	jb     0x18179d0d9
   18179d0ba:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18179d0be:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18179d0c2:	4c 29 c1             	sub    rcx,r8
   18179d0c5:	48 83 f9 20          	cmp    rcx,0x20
   18179d0c9:	0f 83 62 31 00 00    	jae    0x1817a0231
   18179d0cf:	48 83 c0 28          	add    rax,0x28
   18179d0d3:	48 89 c2             	mov    rdx,rax
   18179d0d6:	4c 89 c1             	mov    rcx,r8
   18179d0d9:	e8 02 e8 d0 05       	call   0x1874ab8e0
   18179d0de:	4c 89 ad f0 00 00 00 	mov    QWORD PTR [rbp+0xf0],r13
   18179d0e5:	0f 29 b5 e0 00 00 00 	movaps XMMWORD PTR [rbp+0xe0],xmm6
   18179d0ec:	0f 29 b5 d0 00 00 00 	movaps XMMWORD PTR [rbp+0xd0],xmm6
   18179d0f3:	0f 29 b5 c0 00 00 00 	movaps XMMWORD PTR [rbp+0xc0],xmm6
   18179d0fa:	0f 29 b5 b0 00 00 00 	movaps XMMWORD PTR [rbp+0xb0],xmm6
   18179d101:	48 8d 15 38 1f 94 07 	lea    rdx,[rip+0x7941f38]        # 0x1890df040
   18179d108:	4c 8d 05 e9 ec 93 07 	lea    r8,[rip+0x793ece9]        # 0x1890dbdf8
   18179d10f:	48 8d 8d d0 02 00 00 	lea    rcx,[rbp+0x2d0]
   18179d116:	41 b9 dd 02 00 00    	mov    r9d,0x2dd
   18179d11c:	e8 df d3 9f fe       	call   0x18019a500
   18179d121:	90                   	nop
   18179d122:	c7 85 b0 00 00 00 02 	mov    DWORD PTR [rbp+0xb0],0x2
   18179d129:	00 00 00 
   18179d12c:	48 c7 85 c0 00 00 00 	mov    QWORD PTR [rbp+0xc0],0x0
   18179d133:	00 00 00 00 
   18179d137:	0f 28 85 d0 02 00 00 	movaps xmm0,XMMWORD PTR [rbp+0x2d0]
   18179d13e:	0f 11 85 c8 00 00 00 	movups XMMWORD PTR [rbp+0xc8],xmm0
   18179d145:	0f 57 c0             	xorps  xmm0,xmm0
   18179d148:	0f 11 85 d8 00 00 00 	movups XMMWORD PTR [rbp+0xd8],xmm0
   18179d14f:	48 c7 85 e8 00 00 00 	mov    QWORD PTR [rbp+0xe8],0x0
   18179d156:	00 00 00 00 
   18179d15a:	48 c7 85 f0 00 00 00 	mov    QWORD PTR [rbp+0xf0],0xf
   18179d161:	0f 00 00 00 
   18179d165:	e8 56 7e 21 ff       	call   0x1809b4fc0
   18179d16a:	90                   	nop
   18179d16b:	48 89 85 b8 00 00 00 	mov    QWORD PTR [rbp+0xb8],rax
   18179d172:	48 83 bd f0 00 00 00 	cmp    QWORD PTR [rbp+0xf0],0x19
   18179d179:	19 
   18179d17a:	0f 83 2b 02 00 00    	jae    0x18179d3ab
   18179d180:	4c 8d 0d 79 80 93 07 	lea    r9,[rip+0x7938079]        # 0x1890d5200
   18179d187:	ba 19 00 00 00       	mov    edx,0x19
   18179d18c:	48 8d 8d d8 00 00 00 	lea    rcx,[rbp+0xd8]
   18179d193:	e8 b8 0f 8a fe       	call   0x18003e150
   18179d198:	90                   	nop
   18179d199:	e9 38 02 00 00       	jmp    0x18179d3d6
   18179d19e:	b9 04 00 00 00       	mov    ecx,0x4
   18179d1a3:	e8 38 fc 8c fe       	call   0x18006cde0
   18179d1a8:	85 c0                	test   eax,eax
   18179d1aa:	0f 84 07 01 00 00    	je     0x18179d2b7
   18179d1b0:	48 8d b5 d0 01 00 00 	lea    rsi,[rbp+0x1d0]
   18179d1b7:	48 89 f1             	mov    rcx,rsi
   18179d1ba:	e8 51 fd 8c fe       	call   0x18006cf10
   18179d1bf:	90                   	nop
   18179d1c0:	48 83 bd e8 01 00 00 	cmp    QWORD PTR [rbp+0x1e8],0x10
   18179d1c7:	10 
   18179d1c8:	72 07                	jb     0x18179d1d1
   18179d1ca:	48 8b b5 d0 01 00 00 	mov    rsi,QWORD PTR [rbp+0x1d0]
   18179d1d1:	48 8d 05 08 11 94 07 	lea    rax,[rip+0x7941108]        # 0x1890de2e0
   18179d1d8:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   18179d1dd:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   18179d1e4:	00 00 
   18179d1e6:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   18179d1eb:	c7 44 24 28 d7 02 00 	mov    DWORD PTR [rsp+0x28],0x2d7
   18179d1f2:	00 
   18179d1f3:	4c 8d 0d fe eb 93 07 	lea    r9,[rip+0x793ebfe]        # 0x1890dbdf8
   18179d1fa:	48 8d 8d d0 02 00 00 	lea    rcx,[rbp+0x2d0]
   18179d201:	ba 04 00 00 00       	mov    edx,0x4
   18179d206:	49 89 f0             	mov    r8,rsi
   18179d209:	e8 62 00 8d fe       	call   0x18006d270
   18179d20e:	90                   	nop
   18179d20f:	0f 57 c0             	xorps  xmm0,xmm0
   18179d212:	0f 29 85 d0 03 00 00 	movaps XMMWORD PTR [rbp+0x3d0],xmm0
   18179d219:	0f 29 85 c0 03 00 00 	movaps XMMWORD PTR [rbp+0x3c0],xmm0
   18179d220:	0f 29 85 b0 03 00 00 	movaps XMMWORD PTR [rbp+0x3b0],xmm0
   18179d227:	0f 29 85 a0 03 00 00 	movaps XMMWORD PTR [rbp+0x3a0],xmm0
   18179d22e:	0f 29 85 90 03 00 00 	movaps XMMWORD PTR [rbp+0x390],xmm0
   18179d235:	0f 29 85 80 03 00 00 	movaps XMMWORD PTR [rbp+0x380],xmm0
   18179d23c:	0f 29 85 70 03 00 00 	movaps XMMWORD PTR [rbp+0x370],xmm0
   18179d243:	0f 29 85 60 03 00 00 	movaps XMMWORD PTR [rbp+0x360],xmm0
   18179d24a:	48 8d 15 af 1b 94 07 	lea    rdx,[rip+0x7941baf]        # 0x1890dee00
   18179d251:	48 8d 8d d0 02 00 00 	lea    rcx,[rbp+0x2d0]
   18179d258:	4c 8d 85 60 03 00 00 	lea    r8,[rbp+0x360]
   18179d25f:	e8 ac 05 8d fe       	call   0x18006d810
   18179d264:	90                   	nop
   18179d265:	48 8d 8d d0 02 00 00 	lea    rcx,[rbp+0x2d0]
   18179d26c:	e8 ff 00 8d fe       	call   0x18006d370
   18179d271:	48 8b 85 e8 01 00 00 	mov    rax,QWORD PTR [rbp+0x1e8]
   18179d278:	48 83 f8 10          	cmp    rax,0x10
   18179d27c:	72 39                	jb     0x18179d2b7
   18179d27e:	48 8b 8d d0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1d0]
   18179d285:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18179d289:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18179d290:	72 1f                	jb     0x18179d2b1
   18179d292:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18179d296:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18179d29a:	4c 29 c1             	sub    rcx,r8
   18179d29d:	48 83 f9 20          	cmp    rcx,0x20
   18179d2a1:	0f 83 8a 2f 00 00    	jae    0x1817a0231
   18179d2a7:	48 83 c0 28          	add    rax,0x28
   18179d2ab:	48 89 c2             	mov    rdx,rax
   18179d2ae:	4c 89 c1             	mov    rcx,r8
   18179d2b1:	e8 2a e6 d0 05       	call   0x1874ab8e0
   18179d2b6:	90                   	nop
   18179d2b7:	48 8d 8d d0 02 00 00 	lea    rcx,[rbp+0x2d0]
   18179d2be:	ba 01 00 00 00       	mov    edx,0x1
   18179d2c3:	41 b8 01 00 00 00    	mov    r8d,0x1
   18179d2c9:	e8 d2 aa 1e 02       	call   0x183987da0
   18179d2ce:	90                   	nop
   18179d2cf:	4c 8b b5 28 02 00 00 	mov    r14,QWORD PTR [rbp+0x228]
   18179d2d6:	49 8b 76 28          	mov    rsi,QWORD PTR [r14+0x28]
   18179d2da:	48 8d 95 d0 02 00 00 	lea    rdx,[rbp+0x2d0]
   18179d2e1:	48 89 f1             	mov    rcx,rsi
   18179d2e4:	e8 97 da 09 00       	call   0x18183ad80
   18179d2e9:	90                   	nop
   18179d2ea:	48 8b 85 28 03 00 00 	mov    rax,QWORD PTR [rbp+0x328]
   18179d2f1:	48 89 46 58          	mov    QWORD PTR [rsi+0x58],rax
   18179d2f5:	41 c7 46 04 00 00 00 	mov    DWORD PTR [r14+0x4],0x0
   18179d2fc:	00 
   18179d2fd:	80 bd 20 03 00 00 00 	cmp    BYTE PTR [rbp+0x320],0x0
   18179d304:	0f 84 6b 10 00 00    	je     0x18179e375
   18179d30a:	48 8b 85 18 03 00 00 	mov    rax,QWORD PTR [rbp+0x318]
   18179d311:	48 83 f8 10          	cmp    rax,0x10
   18179d315:	72 38                	jb     0x18179d34f
   18179d317:	48 8b 8d 00 03 00 00 	mov    rcx,QWORD PTR [rbp+0x300]
   18179d31e:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18179d322:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18179d329:	72 1f                	jb     0x18179d34a
   18179d32b:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18179d32f:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18179d333:	4c 29 c1             	sub    rcx,r8
   18179d336:	48 83 f9 20          	cmp    rcx,0x20
   18179d33a:	0f 83 f1 2e 00 00    	jae    0x1817a0231
   18179d340:	48 83 c0 28          	add    rax,0x28
   18179d344:	48 89 c2             	mov    rdx,rax
   18179d347:	4c 89 c1             	mov    rcx,r8
   18179d34a:	e8 91 e5 d0 05       	call   0x1874ab8e0
   18179d34f:	48 8b 85 e8 02 00 00 	mov    rax,QWORD PTR [rbp+0x2e8]
   18179d356:	48 83 f8 10          	cmp    rax,0x10
   18179d35a:	72 38                	jb     0x18179d394
   18179d35c:	48 8b 8d d0 02 00 00 	mov    rcx,QWORD PTR [rbp+0x2d0]
   18179d363:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18179d367:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18179d36e:	72 1f                	jb     0x18179d38f
   18179d370:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18179d374:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18179d378:	4c 29 c1             	sub    rcx,r8
   18179d37b:	48 83 f9 20          	cmp    rcx,0x20
   18179d37f:	0f 83 ac 2e 00 00    	jae    0x1817a0231
   18179d385:	48 83 c0 28          	add    rax,0x28
   18179d389:	48 89 c2             	mov    rdx,rax
   18179d38c:	4c 89 c1             	mov    rcx,r8
   18179d38f:	e8 4c e5 d0 05       	call   0x1874ab8e0
   18179d394:	41 83 7e 04 00       	cmp    DWORD PTR [r14+0x4],0x0
   18179d399:	41 c7 06 04 00 00 00 	mov    DWORD PTR [r14],0x4
   18179d3a0:	0f 85 66 2e 00 00    	jne    0x1817a020c
   18179d3a6:	e9 d1 0f 00 00       	jmp    0x18179e37c
   18179d3ab:	48 8b 85 d8 00 00 00 	mov    rax,QWORD PTR [rbp+0xd8]
   18179d3b2:	48 c7 85 e8 00 00 00 	mov    QWORD PTR [rbp+0xe8],0x19
   18179d3b9:	19 00 00 00 
   18179d3bd:	0f 10 05 45 7e 93 07 	movups xmm0,XMMWORD PTR [rip+0x7937e45]        # 0x1890d5209
   18179d3c4:	0f 11 40 09          	movups XMMWORD PTR [rax+0x9],xmm0
   18179d3c8:	0f 10 05 31 7e 93 07 	movups xmm0,XMMWORD PTR [rip+0x7937e31]        # 0x1890d5200
   18179d3cf:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   18179d3d2:	c6 40 19 00          	mov    BYTE PTR [rax+0x19],0x0
   18179d3d6:	0f 57 c0             	xorps  xmm0,xmm0
   18179d3d9:	0f 29 85 b0 01 00 00 	movaps XMMWORD PTR [rbp+0x1b0],xmm0
   18179d3e0:	48 c7 85 c0 01 00 00 	mov    QWORD PTR [rbp+0x1c0],0x0
   18179d3e7:	00 00 00 00 
   18179d3eb:	0f 29 85 b0 02 00 00 	movaps XMMWORD PTR [rbp+0x2b0],xmm0
   18179d3f2:	48 c7 85 c0 02 00 00 	mov    QWORD PTR [rbp+0x2c0],0x0
   18179d3f9:	00 00 00 00 
   18179d3fd:	0f 29 85 00 04 00 00 	movaps XMMWORD PTR [rbp+0x400],xmm0
   18179d404:	48 c7 85 10 04 00 00 	mov    QWORD PTR [rbp+0x410],0x0
   18179d40b:	00 00 00 00 
   18179d40f:	48 c7 85 18 04 00 00 	mov    QWORD PTR [rbp+0x418],0xf
   18179d416:	0f 00 00 00 
   18179d41a:	48 8b 85 40 04 00 00 	mov    rax,QWORD PTR [rbp+0x440]
   18179d421:	48 8b 00             	mov    rax,QWORD PTR [rax]
   18179d424:	48 8b 48 08          	mov    rcx,QWORD PTR [rax+0x8]
   18179d428:	4c 8b 00             	mov    r8,QWORD PTR [rax]
   18179d42b:	48 89 ca             	mov    rdx,rcx
   18179d42e:	4c 29 c2             	sub    rdx,r8
   18179d431:	48 c1 fa 04          	sar    rdx,0x4
   18179d435:	48 89 95 d0 02 00 00 	mov    QWORD PTR [rbp+0x2d0],rdx
   18179d43c:	4c 39 c1             	cmp    rcx,r8
   18179d43f:	74 4e                	je     0x18179d48f
   18179d441:	48 c1 ea 3c          	shr    rdx,0x3c
   18179d445:	0f 85 ec 2d 00 00    	jne    0x1817a0237
   18179d44b:	48 8d 8d b0 01 00 00 	lea    rcx,[rbp+0x1b0]
   18179d452:	48 8d 95 d0 02 00 00 	lea    rdx,[rbp+0x2d0]
   18179d459:	e8 22 f7 e8 fe       	call   0x18062cb80
   18179d45e:	90                   	nop
   18179d45f:	48 8b 85 40 04 00 00 	mov    rax,QWORD PTR [rbp+0x440]
   18179d466:	48 8b 00             	mov    rax,QWORD PTR [rax]
   18179d469:	48 8b 95 c0 02 00 00 	mov    rdx,QWORD PTR [rbp+0x2c0]
   18179d470:	48 2b 95 b0 02 00 00 	sub    rdx,QWORD PTR [rbp+0x2b0]
   18179d477:	48 8b 48 08          	mov    rcx,QWORD PTR [rax+0x8]
   18179d47b:	48 c1 fa 03          	sar    rdx,0x3
   18179d47f:	49 b8 f5 d3 4f 3f fd 	movabs r8,0x4fd3f4fd3f4fd3f5
   18179d486:	f4 d3 4f 
   18179d489:	49 0f af d0          	imul   rdx,r8
   18179d48d:	eb 02                	jmp    0x18179d491
   18179d48f:	31 d2                	xor    edx,edx
   18179d491:	48 89 8d a8 02 00 00 	mov    QWORD PTR [rbp+0x2a8],rcx
   18179d498:	48 2b 08             	sub    rcx,QWORD PTR [rax]
   18179d49b:	48 c1 f9 04          	sar    rcx,0x4
   18179d49f:	48 89 8d d0 02 00 00 	mov    QWORD PTR [rbp+0x2d0],rcx
   18179d4a6:	48 39 d1             	cmp    rcx,rdx
   18179d4a9:	76 3c                	jbe    0x18179d4e7
   18179d4ab:	48 b8 17 58 60 81 05 	movabs rax,0x58160581605817
   18179d4b2:	16 58 00 
   18179d4b5:	48 39 c1             	cmp    rcx,rax
   18179d4b8:	0f 83 7f 2d 00 00    	jae    0x1817a023d
   18179d4be:	48 8d 8d b0 02 00 00 	lea    rcx,[rbp+0x2b0]
   18179d4c5:	48 8d 95 d0 02 00 00 	lea    rdx,[rbp+0x2d0]
   18179d4cc:	e8 5f 2a de ff       	call   0x18157ff30
   18179d4d1:	90                   	nop
   18179d4d2:	48 8b 85 40 04 00 00 	mov    rax,QWORD PTR [rbp+0x440]
   18179d4d9:	48 8b 00             	mov    rax,QWORD PTR [rax]
   18179d4dc:	48 8b 48 08          	mov    rcx,QWORD PTR [rax+0x8]
   18179d4e0:	48 89 8d a8 02 00 00 	mov    QWORD PTR [rbp+0x2a8],rcx
   18179d4e7:	4c 8b 30             	mov    r14,QWORD PTR [rax]
   18179d4ea:	48 8d bd 58 02 00 00 	lea    rdi,[rbp+0x258]
   18179d4f1:	0f 57 ff             	xorps  xmm7,xmm7
   18179d4f4:	4c 8d a5 d0 02 00 00 	lea    r12,[rbp+0x2d0]
   18179d4fb:	48 8d 9d 70 01 00 00 	lea    rbx,[rbp+0x170]
   18179d502:	48 8d b5 50 01 00 00 	lea    rsi,[rbp+0x150]
   18179d509:	eb 09                	jmp    0x18179d514
   18179d50b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]
   18179d510:	49 83 c6 10          	add    r14,0x10
   18179d514:	4c 3b b5 a8 02 00 00 	cmp    r14,QWORD PTR [rbp+0x2a8]
   18179d51b:	0f 84 0c 0b 00 00    	je     0x18179e02d
   18179d521:	0f 29 bd e0 03 00 00 	movaps XMMWORD PTR [rbp+0x3e0],xmm7
   18179d528:	49 8b 4e 08          	mov    rcx,QWORD PTR [r14+0x8]
   18179d52c:	48 85 c9             	test   rcx,rcx
   18179d52f:	74 df                	je     0x18179d510
   18179d531:	8b 41 08             	mov    eax,DWORD PTR [rcx+0x8]
   18179d534:	66 66 66 2e 0f 1f 84 	data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
   18179d53b:	00 00 00 00 00 
   18179d540:	85 c0                	test   eax,eax
   18179d542:	74 2c                	je     0x18179d570
   18179d544:	8d 50 01             	lea    edx,[rax+0x1]
   18179d547:	f0 0f b1 51 08       	lock cmpxchg DWORD PTR [rcx+0x8],edx
   18179d54c:	75 f2                	jne    0x18179d540
   18179d54e:	49 8b 06             	mov    rax,QWORD PTR [r14]
   18179d551:	48 89 85 e0 03 00 00 	mov    QWORD PTR [rbp+0x3e0],rax
   18179d558:	4d 8b 7e 08          	mov    r15,QWORD PTR [r14+0x8]
   18179d55c:	4c 89 bd e8 03 00 00 	mov    QWORD PTR [rbp+0x3e8],r15
   18179d563:	48 85 c0             	test   rax,rax
   18179d566:	75 1f                	jne    0x18179d587
   18179d568:	e9 4a 0a 00 00       	jmp    0x18179dfb7
   18179d56d:	0f 1f 00             	nop    DWORD PTR [rax]
   18179d570:	48 8b 85 e0 03 00 00 	mov    rax,QWORD PTR [rbp+0x3e0]
   18179d577:	4c 8b bd e8 03 00 00 	mov    r15,QWORD PTR [rbp+0x3e8]
   18179d57e:	48 85 c0             	test   rax,rax
   18179d581:	0f 84 30 0a 00 00    	je     0x18179dfb7
   18179d587:	0f 29 b5 30 02 00 00 	movaps XMMWORD PTR [rbp+0x230],xmm6
   18179d58e:	0f 29 7d 50          	movaps XMMWORD PTR [rbp+0x50],xmm7
   18179d592:	4d 85 ff             	test   r15,r15
   18179d595:	74 15                	je     0x18179d5ac
   18179d597:	f0 41 ff 47 08       	lock inc DWORD PTR [r15+0x8]
   18179d59c:	48 8b 85 e0 03 00 00 	mov    rax,QWORD PTR [rbp+0x3e0]
   18179d5a3:	48 8b 8d e8 03 00 00 	mov    rcx,QWORD PTR [rbp+0x3e8]
   18179d5aa:	eb 02                	jmp    0x18179d5ae
   18179d5ac:	31 c9                	xor    ecx,ecx
   18179d5ae:	49 89 df             	mov    r15,rbx
   18179d5b1:	48 89 45 50          	mov    QWORD PTR [rbp+0x50],rax
   18179d5b5:	48 89 4d 58          	mov    QWORD PTR [rbp+0x58],rcx
   18179d5b9:	48 8b 8d c8 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1c8]
   18179d5c0:	48 8d 95 30 02 00 00 	lea    rdx,[rbp+0x230]
   18179d5c7:	4c 8d 45 50          	lea    r8,[rbp+0x50]
   18179d5cb:	e8 20 3f 00 00       	call   0x1817a14f0
   18179d5d0:	90                   	nop
   18179d5d1:	48 83 bd 30 02 00 00 	cmp    QWORD PTR [rbp+0x230],0x0
   18179d5d8:	00 
   18179d5d9:	74 63                	je     0x18179d63e
   18179d5db:	4c 89 ad 80 02 00 00 	mov    QWORD PTR [rbp+0x280],r13
   18179d5e2:	0f 29 b5 70 02 00 00 	movaps XMMWORD PTR [rbp+0x270],xmm6
   18179d5e9:	0f 29 b5 60 02 00 00 	movaps XMMWORD PTR [rbp+0x260],xmm6
   18179d5f0:	0f 29 b5 50 02 00 00 	movaps XMMWORD PTR [rbp+0x250],xmm6
   18179d5f7:	48 8d 8d 50 02 00 00 	lea    rcx,[rbp+0x250]
   18179d5fe:	31 d2                	xor    edx,edx
   18179d600:	45 31 c0             	xor    r8d,r8d
   18179d603:	e8 c8 3d 00 00       	call   0x1817a13d0
   18179d608:	90                   	nop
   18179d609:	0f 29 b5 20 04 00 00 	movaps XMMWORD PTR [rbp+0x420],xmm6
   18179d610:	48 8b 85 e0 03 00 00 	mov    rax,QWORD PTR [rbp+0x3e0]
   18179d617:	48 8b 48 08          	mov    rcx,QWORD PTR [rax+0x8]
   18179d61b:	48 85 c9             	test   rcx,rcx
   18179d61e:	0f 84 a3 00 00 00    	je     0x18179d6c7
   18179d624:	48 8b 50 10          	mov    rdx,QWORD PTR [rax+0x10]
   18179d628:	48 85 d2             	test   rdx,rdx
   18179d62b:	0f 84 9f 00 00 00    	je     0x18179d6d0
   18179d631:	f0 ff 42 08          	lock inc DWORD PTR [rdx+0x8]
   18179d635:	48 8b 40 10          	mov    rax,QWORD PTR [rax+0x10]
   18179d639:	e9 94 00 00 00       	jmp    0x18179d6d2
   18179d63e:	b9 04 00 00 00       	mov    ecx,0x4
   18179d643:	e8 98 f7 8c fe       	call   0x18006cde0
   18179d648:	85 c0                	test   eax,eax
   18179d64a:	0f 84 35 09 00 00    	je     0x18179df85
   18179d650:	48 8d 8d 50 02 00 00 	lea    rcx,[rbp+0x250]
   18179d657:	e8 b4 f8 8c fe       	call   0x18006cf10
   18179d65c:	90                   	nop
   18179d65d:	48 83 bd 68 02 00 00 	cmp    QWORD PTR [rbp+0x268],0x10
   18179d664:	10 
   18179d665:	4c 8d 85 50 02 00 00 	lea    r8,[rbp+0x250]
   18179d66c:	72 07                	jb     0x18179d675
   18179d66e:	4c 8b 85 50 02 00 00 	mov    r8,QWORD PTR [rbp+0x250]
   18179d675:	48 8d 05 64 0c 94 07 	lea    rax,[rip+0x7940c64]        # 0x1890de2e0
   18179d67c:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   18179d681:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   18179d688:	00 00 
   18179d68a:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   18179d68f:	c7 44 24 28 ed 02 00 	mov    DWORD PTR [rsp+0x28],0x2ed
   18179d696:	00 
   18179d697:	4c 89 e1             	mov    rcx,r12
   18179d69a:	ba 04 00 00 00       	mov    edx,0x4
   18179d69f:	4c 8d 0d 52 e7 93 07 	lea    r9,[rip+0x793e752]        # 0x1890dbdf8
   18179d6a6:	e8 c5 fb 8c fe       	call   0x18006d270
   18179d6ab:	90                   	nop
   18179d6ac:	48 8b 8d e0 03 00 00 	mov    rcx,QWORD PTR [rbp+0x3e0]
   18179d6b3:	48 83 79 50 10       	cmp    QWORD PTR [rcx+0x50],0x10
   18179d6b8:	0f 82 ac 01 00 00    	jb     0x18179d86a
   18179d6be:	48 8b 41 38          	mov    rax,QWORD PTR [rcx+0x38]
   18179d6c2:	e9 a7 01 00 00       	jmp    0x18179d86e
   18179d6c7:	0f 29 bd 20 04 00 00 	movaps XMMWORD PTR [rbp+0x420],xmm7
   18179d6ce:	eb 47                	jmp    0x18179d717
   18179d6d0:	31 c0                	xor    eax,eax
   18179d6d2:	48 89 8d 20 04 00 00 	mov    QWORD PTR [rbp+0x420],rcx
   18179d6d9:	48 89 85 28 04 00 00 	mov    QWORD PTR [rbp+0x428],rax
   18179d6e0:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18179d6e3:	ff 50 18             	call   QWORD PTR [rax+0x18]
   18179d6e6:	90                   	nop
   18179d6e7:	83 f8 01             	cmp    eax,0x1
   18179d6ea:	75 2b                	jne    0x18179d717
   18179d6ec:	48 8b 8d 30 02 00 00 	mov    rcx,QWORD PTR [rbp+0x230]
   18179d6f3:	0f 29 7d 60          	movaps XMMWORD PTR [rbp+0x60],xmm7
   18179d6f7:	48 8b 85 e8 03 00 00 	mov    rax,QWORD PTR [rbp+0x3e8]
   18179d6fe:	48 85 c0             	test   rax,rax
   18179d701:	0f 84 6d 02 00 00    	je     0x18179d974
   18179d707:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   18179d70b:	48 8b 85 e8 03 00 00 	mov    rax,QWORD PTR [rbp+0x3e8]
   18179d712:	e9 5f 02 00 00       	jmp    0x18179d976
   18179d717:	48 8b 8d 30 02 00 00 	mov    rcx,QWORD PTR [rbp+0x230]
   18179d71e:	0f 29 bd 80 00 00 00 	movaps XMMWORD PTR [rbp+0x80],xmm7
   18179d725:	48 8b 85 e8 03 00 00 	mov    rax,QWORD PTR [rbp+0x3e8]
   18179d72c:	48 85 c0             	test   rax,rax
   18179d72f:	74 0d                	je     0x18179d73e
   18179d731:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   18179d735:	48 8b 85 e8 03 00 00 	mov    rax,QWORD PTR [rbp+0x3e8]
   18179d73c:	eb 02                	jmp    0x18179d740
   18179d73e:	31 c0                	xor    eax,eax
   18179d740:	48 8b 95 e0 03 00 00 	mov    rdx,QWORD PTR [rbp+0x3e0]
   18179d747:	48 89 95 80 00 00 00 	mov    QWORD PTR [rbp+0x80],rdx
   18179d74e:	48 89 85 88 00 00 00 	mov    QWORD PTR [rbp+0x88],rax
   18179d755:	48 8d 55 18          	lea    rdx,[rbp+0x18]
   18179d759:	4c 8d 85 80 00 00 00 	lea    r8,[rbp+0x80]
   18179d760:	e8 fb 66 1d 02       	call   0x183973e60
   18179d765:	90                   	nop
   18179d766:	4c 8b 7d 48          	mov    r15,QWORD PTR [rbp+0x48]
   18179d76a:	4d 85 ff             	test   r15,r15
   18179d76d:	74 1f                	je     0x18179d78e
   18179d76f:	f0 41 ff 4f 08       	lock dec DWORD PTR [r15+0x8]
   18179d774:	75 18                	jne    0x18179d78e
   18179d776:	49 8b 07             	mov    rax,QWORD PTR [r15]
   18179d779:	4c 89 f9             	mov    rcx,r15
   18179d77c:	ff 10                	call   QWORD PTR [rax]
   18179d77e:	f0 41 ff 4f 0c       	lock dec DWORD PTR [r15+0xc]
   18179d783:	75 09                	jne    0x18179d78e
   18179d785:	49 8b 07             	mov    rax,QWORD PTR [r15]
   18179d788:	4c 89 f9             	mov    rcx,r15
   18179d78b:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18179d78e:	48 8b 45 38          	mov    rax,QWORD PTR [rbp+0x38]
   18179d792:	48 83 f8 10          	cmp    rax,0x10
   18179d796:	72 35                	jb     0x18179d7cd
   18179d798:	48 8b 4d 20          	mov    rcx,QWORD PTR [rbp+0x20]
   18179d79c:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18179d7a0:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18179d7a7:	72 1f                	jb     0x18179d7c8
   18179d7a9:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18179d7ad:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18179d7b1:	4c 29 c1             	sub    rcx,r8
   18179d7b4:	48 83 f9 20          	cmp    rcx,0x20
   18179d7b8:	0f 83 73 2a 00 00    	jae    0x1817a0231
   18179d7be:	48 83 c0 28          	add    rax,0x28
   18179d7c2:	48 89 c2             	mov    rdx,rax
   18179d7c5:	4c 89 c1             	mov    rcx,r8
   18179d7c8:	e8 13 e1 d0 05       	call   0x1874ab8e0
   18179d7cd:	48 8b 8d 30 02 00 00 	mov    rcx,QWORD PTR [rbp+0x230]
   18179d7d4:	0f 29 bd 90 00 00 00 	movaps XMMWORD PTR [rbp+0x90],xmm7
   18179d7db:	48 8b 85 e8 03 00 00 	mov    rax,QWORD PTR [rbp+0x3e8]
   18179d7e2:	48 85 c0             	test   rax,rax
   18179d7e5:	74 0d                	je     0x18179d7f4
   18179d7e7:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   18179d7eb:	48 8b 85 e8 03 00 00 	mov    rax,QWORD PTR [rbp+0x3e8]
   18179d7f2:	eb 02                	jmp    0x18179d7f6
   18179d7f4:	31 c0                	xor    eax,eax
   18179d7f6:	48 8b 95 e0 03 00 00 	mov    rdx,QWORD PTR [rbp+0x3e0]
   18179d7fd:	48 89 95 90 00 00 00 	mov    QWORD PTR [rbp+0x90],rdx
   18179d804:	48 89 85 98 00 00 00 	mov    QWORD PTR [rbp+0x98],rax
   18179d80b:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18179d80e:	4c 89 e2             	mov    rdx,r12
   18179d811:	4c 8d 85 90 00 00 00 	lea    r8,[rbp+0x90]
   18179d818:	ff 50 10             	call   QWORD PTR [rax+0x10]
   18179d81b:	90                   	nop
   18179d81c:	48 8b 85 d0 02 00 00 	mov    rax,QWORD PTR [rbp+0x2d0]
   18179d823:	4c 8b bd e8 02 00 00 	mov    r15,QWORD PTR [rbp+0x2e8]
   18179d82a:	48 89 85 50 02 00 00 	mov    QWORD PTR [rbp+0x250],rax
   18179d831:	48 83 bd f0 02 00 00 	cmp    QWORD PTR [rbp+0x2f0],0x10
   18179d838:	10 
   18179d839:	4c 8d 8d d8 02 00 00 	lea    r9,[rbp+0x2d8]
   18179d840:	72 07                	jb     0x18179d849
   18179d842:	4c 8b 8d d8 02 00 00 	mov    r9,QWORD PTR [rbp+0x2d8]
   18179d849:	48 8b 85 70 02 00 00 	mov    rax,QWORD PTR [rbp+0x270]
   18179d850:	49 39 c7             	cmp    r15,rax
   18179d853:	0f 86 50 02 00 00    	jbe    0x18179daa9
   18179d859:	48 89 f9             	mov    rcx,rdi
   18179d85c:	4c 89 fa             	mov    rdx,r15
   18179d85f:	e8 ec 08 8a fe       	call   0x18003e150
   18179d864:	90                   	nop
   18179d865:	e9 26 02 00 00       	jmp    0x18179da90
   18179d86a:	48 8d 41 38          	lea    rax,[rcx+0x38]
   18179d86e:	48 89 85 d0 01 00 00 	mov    QWORD PTR [rbp+0x1d0],rax
   18179d875:	c6 85 d8 01 00 00 00 	mov    BYTE PTR [rbp+0x1d8],0x0
   18179d87c:	4c 89 fa             	mov    rdx,r15
   18179d87f:	e8 4c 7e 1e 02       	call   0x1839856d0
   18179d884:	90                   	nop
   18179d885:	48 83 bd 88 01 00 00 	cmp    QWORD PTR [rbp+0x188],0x10
   18179d88c:	10 
   18179d88d:	72 07                	jb     0x18179d896
   18179d88f:	4c 8b bd 70 01 00 00 	mov    r15,QWORD PTR [rbp+0x170]
   18179d896:	4c 89 bd 00 01 00 00 	mov    QWORD PTR [rbp+0x100],r15
   18179d89d:	c6 85 08 01 00 00 00 	mov    BYTE PTR [rbp+0x108],0x0
   18179d8a4:	48 8d 85 70 03 00 00 	lea    rax,[rbp+0x370]
   18179d8ab:	0f 11 78 60          	movups XMMWORD PTR [rax+0x60],xmm7
   18179d8af:	0f 11 78 50          	movups XMMWORD PTR [rax+0x50],xmm7
   18179d8b3:	0f 11 78 40          	movups XMMWORD PTR [rax+0x40],xmm7
   18179d8b7:	0f 11 78 30          	movups XMMWORD PTR [rax+0x30],xmm7
   18179d8bb:	0f 11 78 20          	movups XMMWORD PTR [rax+0x20],xmm7
   18179d8bf:	0f 11 78 10          	movups XMMWORD PTR [rax+0x10],xmm7
   18179d8c3:	0f 11 38             	movups XMMWORD PTR [rax],xmm7
   18179d8c6:	48 8d 85 00 01 00 00 	lea    rax,[rbp+0x100]
   18179d8cd:	48 89 85 60 03 00 00 	mov    QWORD PTR [rbp+0x360],rax
   18179d8d4:	48 8d 85 d0 01 00 00 	lea    rax,[rbp+0x1d0]
   18179d8db:	48 89 85 68 03 00 00 	mov    QWORD PTR [rbp+0x368],rax
   18179d8e2:	4c 89 e1             	mov    rcx,r12
   18179d8e5:	48 8d 15 24 00 94 07 	lea    rdx,[rip+0x7940024]        # 0x1890dd910
   18179d8ec:	4c 8d 85 60 03 00 00 	lea    r8,[rbp+0x360]
   18179d8f3:	e8 18 ff 8c fe       	call   0x18006d810
   18179d8f8:	90                   	nop
   18179d8f9:	48 8b 85 88 01 00 00 	mov    rax,QWORD PTR [rbp+0x188]
   18179d900:	48 83 f8 10          	cmp    rax,0x10
   18179d904:	72 38                	jb     0x18179d93e
   18179d906:	48 8b 8d 70 01 00 00 	mov    rcx,QWORD PTR [rbp+0x170]
   18179d90d:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18179d911:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18179d918:	72 1f                	jb     0x18179d939
   18179d91a:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18179d91e:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18179d922:	4c 29 c1             	sub    rcx,r8
   18179d925:	48 83 f9 20          	cmp    rcx,0x20
   18179d929:	0f 83 02 29 00 00    	jae    0x1817a0231
   18179d92f:	48 83 c0 28          	add    rax,0x28
   18179d933:	48 89 c2             	mov    rdx,rax
   18179d936:	4c 89 c1             	mov    rcx,r8
   18179d939:	e8 a2 df d0 05       	call   0x1874ab8e0
   18179d93e:	4c 89 e1             	mov    rcx,r12
   18179d941:	e8 2a fa 8c fe       	call   0x18006d370
   18179d946:	48 8b 85 68 02 00 00 	mov    rax,QWORD PTR [rbp+0x268]
   18179d94d:	48 83 f8 10          	cmp    rax,0x10
   18179d951:	0f 82 2e 06 00 00    	jb     0x18179df85
   18179d957:	48 8b 8d 50 02 00 00 	mov    rcx,QWORD PTR [rbp+0x250]
   18179d95e:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18179d962:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18179d969:	0f 83 f2 05 00 00    	jae    0x18179df61
   18179d96f:	e9 0c 06 00 00       	jmp    0x18179df80
   18179d974:	31 c0                	xor    eax,eax
   18179d976:	48 8b 95 e0 03 00 00 	mov    rdx,QWORD PTR [rbp+0x3e0]
   18179d97d:	48 89 55 60          	mov    QWORD PTR [rbp+0x60],rdx
   18179d981:	48 89 45 68          	mov    QWORD PTR [rbp+0x68],rax
   18179d985:	48 8d 55 e0          	lea    rdx,[rbp-0x20]
   18179d989:	4c 8d 45 60          	lea    r8,[rbp+0x60]
   18179d98d:	e8 6e 5a 1d 02       	call   0x183973400
   18179d992:	90                   	nop
   18179d993:	4c 8b 7d 10          	mov    r15,QWORD PTR [rbp+0x10]
   18179d997:	4d 85 ff             	test   r15,r15
   18179d99a:	74 1f                	je     0x18179d9bb
   18179d99c:	f0 41 ff 4f 08       	lock dec DWORD PTR [r15+0x8]
   18179d9a1:	75 18                	jne    0x18179d9bb
   18179d9a3:	49 8b 07             	mov    rax,QWORD PTR [r15]
   18179d9a6:	4c 89 f9             	mov    rcx,r15
   18179d9a9:	ff 10                	call   QWORD PTR [rax]
   18179d9ab:	f0 41 ff 4f 0c       	lock dec DWORD PTR [r15+0xc]
   18179d9b0:	75 09                	jne    0x18179d9bb
   18179d9b2:	49 8b 07             	mov    rax,QWORD PTR [r15]
   18179d9b5:	4c 89 f9             	mov    rcx,r15
   18179d9b8:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18179d9bb:	48 8b 45 00          	mov    rax,QWORD PTR [rbp+0x0]
   18179d9bf:	48 83 f8 10          	cmp    rax,0x10
   18179d9c3:	72 35                	jb     0x18179d9fa
   18179d9c5:	48 8b 4d e8          	mov    rcx,QWORD PTR [rbp-0x18]
   18179d9c9:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18179d9cd:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18179d9d4:	72 1f                	jb     0x18179d9f5
   18179d9d6:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18179d9da:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18179d9de:	4c 29 c1             	sub    rcx,r8
   18179d9e1:	48 83 f9 20          	cmp    rcx,0x20
   18179d9e5:	0f 83 46 28 00 00    	jae    0x1817a0231
   18179d9eb:	48 83 c0 28          	add    rax,0x28
   18179d9ef:	48 89 c2             	mov    rdx,rax
   18179d9f2:	4c 89 c1             	mov    rcx,r8
   18179d9f5:	e8 e6 de d0 05       	call   0x1874ab8e0
   18179d9fa:	48 8b 8d 30 02 00 00 	mov    rcx,QWORD PTR [rbp+0x230]
   18179da01:	0f 29 7d 70          	movaps XMMWORD PTR [rbp+0x70],xmm7
   18179da05:	48 8b 85 e8 03 00 00 	mov    rax,QWORD PTR [rbp+0x3e8]
   18179da0c:	48 85 c0             	test   rax,rax
   18179da0f:	74 0d                	je     0x18179da1e
   18179da11:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   18179da15:	48 8b 85 e8 03 00 00 	mov    rax,QWORD PTR [rbp+0x3e8]
   18179da1c:	eb 02                	jmp    0x18179da20
   18179da1e:	31 c0                	xor    eax,eax
   18179da20:	48 8b 95 e0 03 00 00 	mov    rdx,QWORD PTR [rbp+0x3e0]
   18179da27:	48 89 55 70          	mov    QWORD PTR [rbp+0x70],rdx
   18179da2b:	48 89 45 78          	mov    QWORD PTR [rbp+0x78],rax
   18179da2f:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   18179da32:	4c 89 e2             	mov    rdx,r12
   18179da35:	4c 8d 45 70          	lea    r8,[rbp+0x70]
   18179da39:	ff 50 20             	call   QWORD PTR [rax+0x20]
   18179da3c:	90                   	nop
   18179da3d:	48 8b 85 d0 02 00 00 	mov    rax,QWORD PTR [rbp+0x2d0]
   18179da44:	4c 8b bd e8 02 00 00 	mov    r15,QWORD PTR [rbp+0x2e8]
   18179da4b:	48 89 85 50 02 00 00 	mov    QWORD PTR [rbp+0x250],rax
   18179da52:	48 83 bd f0 02 00 00 	cmp    QWORD PTR [rbp+0x2f0],0x10
   18179da59:	10 
   18179da5a:	4c 8d 8d d8 02 00 00 	lea    r9,[rbp+0x2d8]
   18179da61:	72 07                	jb     0x18179da6a
   18179da63:	4c 8b 8d d8 02 00 00 	mov    r9,QWORD PTR [rbp+0x2d8]
   18179da6a:	48 8b 85 70 02 00 00 	mov    rax,QWORD PTR [rbp+0x270]
   18179da71:	49 39 c7             	cmp    r15,rax
   18179da74:	76 33                	jbe    0x18179daa9
   18179da76:	48 89 f9             	mov    rcx,rdi
   18179da79:	4c 89 fa             	mov    rdx,r15
   18179da7c:	e8 cf 06 8a fe       	call   0x18003e150
   18179da81:	90                   	nop
   18179da82:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
   18179da89:	1f 84 00 00 00 00 00 
   18179da90:	48 8b 85 00 03 00 00 	mov    rax,QWORD PTR [rbp+0x300]
   18179da97:	48 85 c0             	test   rax,rax
   18179da9a:	74 4a                	je     0x18179dae6
   18179da9c:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   18179daa0:	48 8b 85 00 03 00 00 	mov    rax,QWORD PTR [rbp+0x300]
   18179daa7:	eb 3f                	jmp    0x18179dae8
   18179daa9:	49 89 fc             	mov    r12,rdi
   18179daac:	48 83 f8 10          	cmp    rax,0x10
   18179dab0:	72 07                	jb     0x18179dab9
   18179dab2:	4c 8b a5 58 02 00 00 	mov    r12,QWORD PTR [rbp+0x258]
   18179dab9:	4c 89 bd 68 02 00 00 	mov    QWORD PTR [rbp+0x268],r15
   18179dac0:	4c 89 e1             	mov    rcx,r12
   18179dac3:	4c 89 ca             	mov    rdx,r9
   18179dac6:	4d 89 f8             	mov    r8,r15
   18179dac9:	e8 82 65 da 05       	call   0x187544050
   18179dace:	43 c6 04 3c 00       	mov    BYTE PTR [r12+r15*1],0x0
   18179dad3:	4c 8d a5 d0 02 00 00 	lea    r12,[rbp+0x2d0]
   18179dada:	48 8b 85 00 03 00 00 	mov    rax,QWORD PTR [rbp+0x300]
   18179dae1:	48 85 c0             	test   rax,rax
   18179dae4:	75 b6                	jne    0x18179da9c
   18179dae6:	31 c0                	xor    eax,eax
   18179dae8:	48 8b 8d f8 02 00 00 	mov    rcx,QWORD PTR [rbp+0x2f8]
   18179daef:	48 89 8d 78 02 00 00 	mov    QWORD PTR [rbp+0x278],rcx
   18179daf6:	4c 8b bd 80 02 00 00 	mov    r15,QWORD PTR [rbp+0x280]
   18179dafd:	48 89 85 80 02 00 00 	mov    QWORD PTR [rbp+0x280],rax
   18179db04:	4d 85 ff             	test   r15,r15
   18179db07:	74 27                	je     0x18179db30
   18179db09:	f0 41 ff 4f 08       	lock dec DWORD PTR [r15+0x8]
   18179db0e:	75 20                	jne    0x18179db30
   18179db10:	49 8b 07             	mov    rax,QWORD PTR [r15]
   18179db13:	4c 89 f9             	mov    rcx,r15
   18179db16:	ff 10                	call   QWORD PTR [rax]
   18179db18:	f0 41 ff 4f 0c       	lock dec DWORD PTR [r15+0xc]
   18179db1d:	75 11                	jne    0x18179db30
   18179db1f:	49 8b 07             	mov    rax,QWORD PTR [r15]
   18179db22:	4c 89 f9             	mov    rcx,r15
   18179db25:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18179db28:	0f 1f 84 00 00 00 00 	nop    DWORD PTR [rax+rax*1+0x0]
   18179db2f:	00 
   18179db30:	4c 8b bd 00 03 00 00 	mov    r15,QWORD PTR [rbp+0x300]
   18179db37:	4d 85 ff             	test   r15,r15
   18179db3a:	74 24                	je     0x18179db60
   18179db3c:	f0 41 ff 4f 08       	lock dec DWORD PTR [r15+0x8]
   18179db41:	75 1d                	jne    0x18179db60
   18179db43:	49 8b 07             	mov    rax,QWORD PTR [r15]
   18179db46:	4c 89 f9             	mov    rcx,r15
   18179db49:	ff 10                	call   QWORD PTR [rax]
   18179db4b:	f0 41 ff 4f 0c       	lock dec DWORD PTR [r15+0xc]
   18179db50:	75 0e                	jne    0x18179db60
   18179db52:	49 8b 07             	mov    rax,QWORD PTR [r15]
   18179db55:	4c 89 f9             	mov    rcx,r15
   18179db58:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18179db5b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]
   18179db60:	48 8b 85 f0 02 00 00 	mov    rax,QWORD PTR [rbp+0x2f0]
   18179db67:	48 83 f8 10          	cmp    rax,0x10
   18179db6b:	49 89 df             	mov    r15,rbx
   18179db6e:	72 38                	jb     0x18179dba8
   18179db70:	48 8b 8d d8 02 00 00 	mov    rcx,QWORD PTR [rbp+0x2d8]
   18179db77:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18179db7b:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18179db82:	72 1f                	jb     0x18179dba3
   18179db84:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18179db88:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18179db8c:	4c 29 c1             	sub    rcx,r8
   18179db8f:	48 83 f9 20          	cmp    rcx,0x20
   18179db93:	0f 83 98 26 00 00    	jae    0x1817a0231
   18179db99:	48 83 c0 28          	add    rax,0x28
   18179db9d:	48 89 c2             	mov    rdx,rax
   18179dba0:	4c 89 c1             	mov    rcx,r8
   18179dba3:	e8 38 dd d0 05       	call   0x1874ab8e0
   18179dba8:	8b 85 54 02 00 00    	mov    eax,DWORD PTR [rbp+0x254]
   18179dbae:	0b 85 50 02 00 00    	or     eax,DWORD PTR [rbp+0x250]
   18179dbb4:	0f 84 81 00 00 00    	je     0x18179dc3b
   18179dbba:	b9 04 00 00 00       	mov    ecx,0x4
   18179dbbf:	e8 1c f2 8c fe       	call   0x18006cde0
   18179dbc4:	85 c0                	test   eax,eax
   18179dbc6:	0f 84 11 03 00 00    	je     0x18179dedd
   18179dbcc:	4c 89 f9             	mov    rcx,r15
   18179dbcf:	e8 3c f3 8c fe       	call   0x18006cf10
   18179dbd4:	90                   	nop
   18179dbd5:	48 83 bd 88 01 00 00 	cmp    QWORD PTR [rbp+0x188],0x10
   18179dbdc:	10 
   18179dbdd:	72 07                	jb     0x18179dbe6
   18179dbdf:	4c 8b bd 70 01 00 00 	mov    r15,QWORD PTR [rbp+0x170]
   18179dbe6:	48 8d 05 f3 06 94 07 	lea    rax,[rip+0x79406f3]        # 0x1890de2e0
   18179dbed:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   18179dbf2:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   18179dbf9:	00 00 
   18179dbfb:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   18179dc00:	c7 44 24 28 ff 02 00 	mov    DWORD PTR [rsp+0x28],0x2ff
   18179dc07:	00 
   18179dc08:	4c 89 e1             	mov    rcx,r12
   18179dc0b:	ba 04 00 00 00       	mov    edx,0x4
   18179dc10:	4d 89 f8             	mov    r8,r15
   18179dc13:	4c 8d 0d de e1 93 07 	lea    r9,[rip+0x793e1de]        # 0x1890dbdf8
   18179dc1a:	e8 51 f6 8c fe       	call   0x18006d270
   18179dc1f:	90                   	nop
   18179dc20:	48 8b 8d e0 03 00 00 	mov    rcx,QWORD PTR [rbp+0x3e0]
   18179dc27:	48 83 79 50 10       	cmp    QWORD PTR [rcx+0x50],0x10
   18179dc2c:	0f 82 b3 00 00 00    	jb     0x18179dce5
   18179dc32:	48 8b 41 38          	mov    rax,QWORD PTR [rcx+0x38]
   18179dc36:	e9 ae 00 00 00       	jmp    0x18179dce9
   18179dc3b:	48 8b 8d e0 03 00 00 	mov    rcx,QWORD PTR [rbp+0x3e0]
   18179dc42:	e8 c9 9a 1e 02       	call   0x183987710
   18179dc47:	90                   	nop
   18179dc48:	0f 29 b5 d0 02 00 00 	movaps XMMWORD PTR [rbp+0x2d0],xmm6
   18179dc4f:	48 8b 85 e0 03 00 00 	mov    rax,QWORD PTR [rbp+0x3e0]
   18179dc56:	48 8b 48 20          	mov    rcx,QWORD PTR [rax+0x20]
   18179dc5a:	48 85 c9             	test   rcx,rcx
   18179dc5d:	74 0a                	je     0x18179dc69
   18179dc5f:	f0 ff 41 08          	lock inc DWORD PTR [rcx+0x8]
   18179dc63:	4c 8b 60 20          	mov    r12,QWORD PTR [rax+0x20]
   18179dc67:	eb 03                	jmp    0x18179dc6c
   18179dc69:	45 31 e4             	xor    r12d,r12d
   18179dc6c:	4c 8b 78 18          	mov    r15,QWORD PTR [rax+0x18]
   18179dc70:	4c 89 bd d0 02 00 00 	mov    QWORD PTR [rbp+0x2d0],r15
   18179dc77:	4c 89 a5 d8 02 00 00 	mov    QWORD PTR [rbp+0x2d8],r12
   18179dc7e:	4d 85 ff             	test   r15,r15
   18179dc81:	0f 84 27 02 00 00    	je     0x18179deae
   18179dc87:	48 83 bd 10 04 00 00 	cmp    QWORD PTR [rbp+0x410],0x0
   18179dc8e:	00 
   18179dc8f:	0f 84 7d 01 00 00    	je     0x18179de12
   18179dc95:	48 8b 95 b8 01 00 00 	mov    rdx,QWORD PTR [rbp+0x1b8]
   18179dc9c:	48 3b 95 c0 01 00 00 	cmp    rdx,QWORD PTR [rbp+0x1c0]
   18179dca3:	0f 84 b1 01 00 00    	je     0x18179de5a
   18179dca9:	0f 11 3a             	movups XMMWORD PTR [rdx],xmm7
   18179dcac:	48 8b 85 e8 03 00 00 	mov    rax,QWORD PTR [rbp+0x3e8]
   18179dcb3:	48 85 c0             	test   rax,rax
   18179dcb6:	74 0b                	je     0x18179dcc3
   18179dcb8:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   18179dcbc:	4c 8b bd d0 02 00 00 	mov    r15,QWORD PTR [rbp+0x2d0]
   18179dcc3:	48 8b 85 e0 03 00 00 	mov    rax,QWORD PTR [rbp+0x3e0]
   18179dcca:	48 89 02             	mov    QWORD PTR [rdx],rax
   18179dccd:	48 8b 85 e8 03 00 00 	mov    rax,QWORD PTR [rbp+0x3e8]
   18179dcd4:	48 89 42 08          	mov    QWORD PTR [rdx+0x8],rax
   18179dcd8:	48 83 85 b8 01 00 00 	add    QWORD PTR [rbp+0x1b8],0x10
   18179dcdf:	10 
   18179dce0:	e9 89 01 00 00       	jmp    0x18179de6e
   18179dce5:	48 8d 41 38          	lea    rax,[rcx+0x38]
   18179dce9:	48 89 85 d0 01 00 00 	mov    QWORD PTR [rbp+0x1d0],rax
   18179dcf0:	c6 85 d8 01 00 00 00 	mov    BYTE PTR [rbp+0x1d8],0x0
   18179dcf7:	49 89 f7             	mov    r15,rsi
   18179dcfa:	48 89 f2             	mov    rdx,rsi
   18179dcfd:	e8 ce 79 1e 02       	call   0x1839856d0
   18179dd02:	90                   	nop
   18179dd03:	48 83 bd 68 01 00 00 	cmp    QWORD PTR [rbp+0x168],0x10
   18179dd0a:	10 
   18179dd0b:	72 07                	jb     0x18179dd14
   18179dd0d:	4c 8b bd 50 01 00 00 	mov    r15,QWORD PTR [rbp+0x150]
   18179dd14:	4c 89 bd 00 01 00 00 	mov    QWORD PTR [rbp+0x100],r15
   18179dd1b:	c6 85 08 01 00 00 00 	mov    BYTE PTR [rbp+0x108],0x0
   18179dd22:	48 8d 85 70 03 00 00 	lea    rax,[rbp+0x370]
   18179dd29:	0f 11 78 60          	movups XMMWORD PTR [rax+0x60],xmm7
   18179dd2d:	0f 11 78 50          	movups XMMWORD PTR [rax+0x50],xmm7
   18179dd31:	0f 11 78 40          	movups XMMWORD PTR [rax+0x40],xmm7
   18179dd35:	0f 11 78 30          	movups XMMWORD PTR [rax+0x30],xmm7
   18179dd39:	0f 11 78 20          	movups XMMWORD PTR [rax+0x20],xmm7
   18179dd3d:	0f 11 78 10          	movups XMMWORD PTR [rax+0x10],xmm7
   18179dd41:	0f 11 38             	movups XMMWORD PTR [rax],xmm7
   18179dd44:	48 8d 85 00 01 00 00 	lea    rax,[rbp+0x100]
   18179dd4b:	48 89 85 60 03 00 00 	mov    QWORD PTR [rbp+0x360],rax
   18179dd52:	48 8d 85 d0 01 00 00 	lea    rax,[rbp+0x1d0]
   18179dd59:	48 89 85 68 03 00 00 	mov    QWORD PTR [rbp+0x368],rax
   18179dd60:	4c 89 e1             	mov    rcx,r12
   18179dd63:	48 8d 15 6e e7 93 07 	lea    rdx,[rip+0x793e76e]        # 0x1890dc4d8
   18179dd6a:	4c 8d 85 60 03 00 00 	lea    r8,[rbp+0x360]
   18179dd71:	e8 9a fa 8c fe       	call   0x18006d810
   18179dd76:	90                   	nop
   18179dd77:	48 8b 85 68 01 00 00 	mov    rax,QWORD PTR [rbp+0x168]
   18179dd7e:	48 83 f8 10          	cmp    rax,0x10
   18179dd82:	72 38                	jb     0x18179ddbc
   18179dd84:	48 8b 8d 50 01 00 00 	mov    rcx,QWORD PTR [rbp+0x150]
   18179dd8b:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18179dd8f:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18179dd96:	72 1f                	jb     0x18179ddb7
   18179dd98:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18179dd9c:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18179dda0:	4c 29 c1             	sub    rcx,r8
   18179dda3:	48 83 f9 20          	cmp    rcx,0x20
   18179dda7:	0f 83 84 24 00 00    	jae    0x1817a0231
   18179ddad:	48 83 c0 28          	add    rax,0x28
   18179ddb1:	48 89 c2             	mov    rdx,rax
   18179ddb4:	4c 89 c1             	mov    rcx,r8
   18179ddb7:	e8 24 db d0 05       	call   0x1874ab8e0
   18179ddbc:	4c 89 e1             	mov    rcx,r12
   18179ddbf:	e8 ac f5 8c fe       	call   0x18006d370
   18179ddc4:	48 8b 85 88 01 00 00 	mov    rax,QWORD PTR [rbp+0x188]
   18179ddcb:	48 83 f8 10          	cmp    rax,0x10
   18179ddcf:	0f 82 08 01 00 00    	jb     0x18179dedd
   18179ddd5:	48 8b 8d 70 01 00 00 	mov    rcx,QWORD PTR [rbp+0x170]
   18179dddc:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18179dde0:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18179dde7:	72 1f                	jb     0x18179de08
   18179dde9:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18179dded:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18179ddf1:	4c 29 c1             	sub    rcx,r8
   18179ddf4:	48 83 f9 20          	cmp    rcx,0x20
   18179ddf8:	0f 83 33 24 00 00    	jae    0x1817a0231
   18179ddfe:	48 83 c0 28          	add    rax,0x28
   18179de02:	48 89 c2             	mov    rdx,rax
   18179de05:	4c 89 c1             	mov    rcx,r8
   18179de08:	e8 d3 da d0 05       	call   0x1874ab8e0
   18179de0d:	e9 cb 00 00 00       	jmp    0x18179dedd
   18179de12:	48 8b 85 e0 03 00 00 	mov    rax,QWORD PTR [rbp+0x3e0]
   18179de19:	4c 8d 48 38          	lea    r9,[rax+0x38]
   18179de1d:	48 8d 8d 00 04 00 00 	lea    rcx,[rbp+0x400]
   18179de24:	4c 39 c9             	cmp    rcx,r9
   18179de27:	0f 84 68 fe ff ff    	je     0x18179dc95
   18179de2d:	48 83 78 50 10       	cmp    QWORD PTR [rax+0x50],0x10
   18179de32:	72 04                	jb     0x18179de38
   18179de34:	4c 8b 48 38          	mov    r9,QWORD PTR [rax+0x38]
   18179de38:	4c 8b 60 48          	mov    r12,QWORD PTR [rax+0x48]
   18179de3c:	48 8b 85 18 04 00 00 	mov    rax,QWORD PTR [rbp+0x418]
   18179de43:	49 39 c4             	cmp    r12,rax
   18179de46:	0f 86 a0 01 00 00    	jbe    0x18179dfec
   18179de4c:	4c 89 e2             	mov    rdx,r12
   18179de4f:	e8 fc 02 8a fe       	call   0x18003e150
   18179de54:	90                   	nop
   18179de55:	e9 3b fe ff ff       	jmp    0x18179dc95
   18179de5a:	48 8d 8d b0 01 00 00 	lea    rcx,[rbp+0x1b0]
   18179de61:	4c 8d 85 e0 03 00 00 	lea    r8,[rbp+0x3e0]
   18179de68:	e8 93 3a a3 fe       	call   0x1801d1900
   18179de6d:	90                   	nop
   18179de6e:	48 8b 95 b8 02 00 00 	mov    rdx,QWORD PTR [rbp+0x2b8]
   18179de75:	48 3b 95 c0 02 00 00 	cmp    rdx,QWORD PTR [rbp+0x2c0]
   18179de7c:	74 19                	je     0x18179de97
   18179de7e:	48 89 d1             	mov    rcx,rdx
   18179de81:	4c 89 fa             	mov    rdx,r15
   18179de84:	e8 57 64 a2 fe       	call   0x1801c42e0
   18179de89:	90                   	nop
   18179de8a:	48 81 85 b8 02 00 00 	add    QWORD PTR [rbp+0x2b8],0x2e8
   18179de91:	e8 02 00 00 
   18179de95:	eb 10                	jmp    0x18179dea7
   18179de97:	48 8d 8d b0 02 00 00 	lea    rcx,[rbp+0x2b0]
   18179de9e:	4d 89 f8             	mov    r8,r15
   18179dea1:	e8 ca e7 dd ff       	call   0x18157c670
   18179dea6:	90                   	nop
   18179dea7:	4c 8b a5 d8 02 00 00 	mov    r12,QWORD PTR [rbp+0x2d8]
   18179deae:	4d 85 e4             	test   r12,r12
   18179deb1:	74 23                	je     0x18179ded6
   18179deb3:	f0 41 ff 4c 24 08    	lock dec DWORD PTR [r12+0x8]
   18179deb9:	75 1b                	jne    0x18179ded6
   18179debb:	49 8b 04 24          	mov    rax,QWORD PTR [r12]
   18179debf:	4c 89 e1             	mov    rcx,r12
   18179dec2:	ff 10                	call   QWORD PTR [rax]
   18179dec4:	f0 41 ff 4c 24 0c    	lock dec DWORD PTR [r12+0xc]
   18179deca:	75 0a                	jne    0x18179ded6
   18179decc:	49 8b 04 24          	mov    rax,QWORD PTR [r12]
   18179ded0:	4c 89 e1             	mov    rcx,r12
   18179ded3:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18179ded6:	4c 8d a5 d0 02 00 00 	lea    r12,[rbp+0x2d0]
   18179dedd:	4c 8b bd 28 04 00 00 	mov    r15,QWORD PTR [rbp+0x428]
   18179dee4:	4d 85 ff             	test   r15,r15
   18179dee7:	74 27                	je     0x18179df10
   18179dee9:	f0 41 ff 4f 08       	lock dec DWORD PTR [r15+0x8]
   18179deee:	75 20                	jne    0x18179df10
   18179def0:	49 8b 07             	mov    rax,QWORD PTR [r15]
   18179def3:	4c 89 f9             	mov    rcx,r15
   18179def6:	ff 10                	call   QWORD PTR [rax]
   18179def8:	f0 41 ff 4f 0c       	lock dec DWORD PTR [r15+0xc]
   18179defd:	75 11                	jne    0x18179df10
   18179deff:	49 8b 07             	mov    rax,QWORD PTR [r15]
   18179df02:	4c 89 f9             	mov    rcx,r15
   18179df05:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18179df08:	0f 1f 84 00 00 00 00 	nop    DWORD PTR [rax+rax*1+0x0]
   18179df0f:	00 
   18179df10:	4c 8b bd 80 02 00 00 	mov    r15,QWORD PTR [rbp+0x280]
   18179df17:	4d 85 ff             	test   r15,r15
   18179df1a:	74 24                	je     0x18179df40
   18179df1c:	f0 41 ff 4f 08       	lock dec DWORD PTR [r15+0x8]
   18179df21:	75 1d                	jne    0x18179df40
   18179df23:	49 8b 07             	mov    rax,QWORD PTR [r15]
   18179df26:	4c 89 f9             	mov    rcx,r15
   18179df29:	ff 10                	call   QWORD PTR [rax]
   18179df2b:	f0 41 ff 4f 0c       	lock dec DWORD PTR [r15+0xc]
   18179df30:	75 0e                	jne    0x18179df40
   18179df32:	49 8b 07             	mov    rax,QWORD PTR [r15]
   18179df35:	4c 89 f9             	mov    rcx,r15
   18179df38:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18179df3b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]
   18179df40:	48 8b 85 70 02 00 00 	mov    rax,QWORD PTR [rbp+0x270]
   18179df47:	48 83 f8 10          	cmp    rax,0x10
   18179df4b:	72 38                	jb     0x18179df85
   18179df4d:	48 8b 8d 58 02 00 00 	mov    rcx,QWORD PTR [rbp+0x258]
   18179df54:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18179df58:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18179df5f:	72 1f                	jb     0x18179df80
   18179df61:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18179df65:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18179df69:	4c 29 c1             	sub    rcx,r8
   18179df6c:	48 83 f9 20          	cmp    rcx,0x20
   18179df70:	0f 83 bb 22 00 00    	jae    0x1817a0231
   18179df76:	48 83 c0 28          	add    rax,0x28
   18179df7a:	48 89 c2             	mov    rdx,rax
   18179df7d:	4c 89 c1             	mov    rcx,r8
   18179df80:	e8 5b d9 d0 05       	call   0x1874ab8e0
   18179df85:	4c 8b bd 38 02 00 00 	mov    r15,QWORD PTR [rbp+0x238]
   18179df8c:	4d 85 ff             	test   r15,r15
   18179df8f:	74 1f                	je     0x18179dfb0
   18179df91:	f0 41 ff 4f 08       	lock dec DWORD PTR [r15+0x8]
   18179df96:	75 18                	jne    0x18179dfb0
   18179df98:	49 8b 07             	mov    rax,QWORD PTR [r15]
   18179df9b:	4c 89 f9             	mov    rcx,r15
   18179df9e:	ff 10                	call   QWORD PTR [rax]
   18179dfa0:	f0 41 ff 4f 0c       	lock dec DWORD PTR [r15+0xc]
   18179dfa5:	75 09                	jne    0x18179dfb0
   18179dfa7:	49 8b 07             	mov    rax,QWORD PTR [r15]
   18179dfaa:	4c 89 f9             	mov    rcx,r15
   18179dfad:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18179dfb0:	4c 8b bd e8 03 00 00 	mov    r15,QWORD PTR [rbp+0x3e8]
   18179dfb7:	4d 85 ff             	test   r15,r15
   18179dfba:	0f 84 50 f5 ff ff    	je     0x18179d510
   18179dfc0:	f0 41 ff 4f 08       	lock dec DWORD PTR [r15+0x8]
   18179dfc5:	0f 85 45 f5 ff ff    	jne    0x18179d510
   18179dfcb:	49 8b 07             	mov    rax,QWORD PTR [r15]
   18179dfce:	4c 89 f9             	mov    rcx,r15
   18179dfd1:	ff 10                	call   QWORD PTR [rax]
   18179dfd3:	f0 41 ff 4f 0c       	lock dec DWORD PTR [r15+0xc]
   18179dfd8:	0f 85 32 f5 ff ff    	jne    0x18179d510
   18179dfde:	49 8b 07             	mov    rax,QWORD PTR [r15]
   18179dfe1:	4c 89 f9             	mov    rcx,r15
   18179dfe4:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18179dfe7:	e9 24 f5 ff ff       	jmp    0x18179d510
   18179dfec:	4c 89 ef             	mov    rdi,r13
   18179dfef:	4c 8d ad 00 04 00 00 	lea    r13,[rbp+0x400]
   18179dff6:	48 83 f8 10          	cmp    rax,0x10
   18179dffa:	72 07                	jb     0x18179e003
   18179dffc:	4c 8b ad 00 04 00 00 	mov    r13,QWORD PTR [rbp+0x400]
   18179e003:	4c 89 a5 10 04 00 00 	mov    QWORD PTR [rbp+0x410],r12
   18179e00a:	4c 89 e9             	mov    rcx,r13
   18179e00d:	4c 89 ca             	mov    rdx,r9
   18179e010:	4d 89 e0             	mov    r8,r12
   18179e013:	e8 38 60 da 05       	call   0x187544050
   18179e018:	43 c6 44 25 00 00    	mov    BYTE PTR [r13+r12*1+0x0],0x0
   18179e01e:	49 89 fd             	mov    r13,rdi
   18179e021:	48 8d bd 58 02 00 00 	lea    rdi,[rbp+0x258]
   18179e028:	e9 68 fc ff ff       	jmp    0x18179dc95
   18179e02d:	48 8b 85 b0 02 00 00 	mov    rax,QWORD PTR [rbp+0x2b0]
   18179e034:	48 3b 85 b8 02 00 00 	cmp    rax,QWORD PTR [rbp+0x2b8]
   18179e03b:	0f 84 fb 01 00 00    	je     0x18179e23c
   18179e041:	48 83 bd 10 04 00 00 	cmp    QWORD PTR [rbp+0x410],0x0
   18179e048:	00 
   18179e049:	0f 84 ed 01 00 00    	je     0x18179e23c
   18179e04f:	b9 02 00 00 00       	mov    ecx,0x2
   18179e054:	e8 87 ed 8c fe       	call   0x18006cde0
   18179e059:	85 c0                	test   eax,eax
   18179e05b:	49 be cd cc cc cc cc 	movabs r14,0xcccccccccccccccd
   18179e062:	cc cc cc 
   18179e065:	0f 84 d9 05 00 00    	je     0x18179e644
   18179e06b:	48 8d b5 70 01 00 00 	lea    rsi,[rbp+0x170]
   18179e072:	48 89 f1             	mov    rcx,rsi
   18179e075:	e8 96 ee 8c fe       	call   0x18006cf10
   18179e07a:	90                   	nop
   18179e07b:	48 83 bd 88 01 00 00 	cmp    QWORD PTR [rbp+0x188],0x10
   18179e082:	10 
   18179e083:	72 07                	jb     0x18179e08c
   18179e085:	48 8b b5 70 01 00 00 	mov    rsi,QWORD PTR [rbp+0x170]
   18179e08c:	48 8d 05 4d 02 94 07 	lea    rax,[rip+0x794024d]        # 0x1890de2e0
   18179e093:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   18179e098:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   18179e09f:	00 00 
   18179e0a1:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   18179e0a6:	c7 44 24 28 16 03 00 	mov    DWORD PTR [rsp+0x28],0x316
   18179e0ad:	00 
   18179e0ae:	4c 8d 0d 43 dd 93 07 	lea    r9,[rip+0x793dd43]        # 0x1890dbdf8
   18179e0b5:	48 8d 8d d0 02 00 00 	lea    rcx,[rbp+0x2d0]
   18179e0bc:	ba 02 00 00 00       	mov    edx,0x2
   18179e0c1:	49 89 f0             	mov    r8,rsi
   18179e0c4:	e8 a7 f1 8c fe       	call   0x18006d270
   18179e0c9:	90                   	nop
   18179e0ca:	48 8b 85 40 04 00 00 	mov    rax,QWORD PTR [rbp+0x440]
   18179e0d1:	48 8b 00             	mov    rax,QWORD PTR [rax]
   18179e0d4:	48 8b 48 08          	mov    rcx,QWORD PTR [rax+0x8]
   18179e0d8:	48 2b 08             	sub    rcx,QWORD PTR [rax]
   18179e0db:	48 c1 f9 04          	sar    rcx,0x4
   18179e0df:	48 c7 85 d0 01 00 00 	mov    QWORD PTR [rbp+0x1d0],0x0
   18179e0e6:	00 00 00 00 
   18179e0ea:	41 ba 07 00 00 00    	mov    r10d,0x7
   18179e0f0:	4c 8d 8d d7 01 00 00 	lea    r9,[rbp+0x1d7]
   18179e0f7:	4c 8d 05 72 81 5a 07 	lea    r8,[rip+0x75a8172]        # 0x188d46270
   18179e0fe:	66 90                	xchg   ax,ax
   18179e100:	48 89 c8             	mov    rax,rcx
   18179e103:	49 f7 e6             	mul    r14
   18179e106:	48 c1 ea 03          	shr    rdx,0x3
   18179e10a:	48 8d 04 12          	lea    rax,[rdx+rdx*1]
   18179e10e:	48 8d 04 80          	lea    rax,[rax+rax*4]
   18179e112:	4d 89 c3             	mov    r11,r8
   18179e115:	49 29 c3             	sub    r11,rax
   18179e118:	41 0f b6 44 0b 23    	movzx  eax,BYTE PTR [r11+rcx*1+0x23]
   18179e11e:	41 88 41 01          	mov    BYTE PTR [r9+0x1],al
   18179e122:	49 ff c1             	inc    r9
   18179e125:	49 ff c2             	inc    r10
   18179e128:	48 83 f9 09          	cmp    rcx,0x9
   18179e12c:	48 89 d1             	mov    rcx,rdx
   18179e12f:	77 cf                	ja     0x18179e100
   18179e131:	48 8d 85 d8 01 00 00 	lea    rax,[rbp+0x1d8]
   18179e138:	41 c6 41 01 00       	mov    BYTE PTR [r9+0x1],0x0
   18179e13d:	49 83 fa 09          	cmp    r10,0x9
   18179e141:	72 28                	jb     0x18179e16b
   18179e143:	48 8d 8d d9 01 00 00 	lea    rcx,[rbp+0x1d9]
   18179e14a:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
   18179e150:	41 0f b6 11          	movzx  edx,BYTE PTR [r9]
   18179e154:	44 0f b6 51 ff       	movzx  r10d,BYTE PTR [rcx-0x1]
   18179e159:	45 88 11             	mov    BYTE PTR [r9],r10b
   18179e15c:	49 ff c9             	dec    r9
   18179e15f:	88 51 ff             	mov    BYTE PTR [rcx-0x1],dl
   18179e162:	4c 39 c9             	cmp    rcx,r9
   18179e165:	48 8d 49 01          	lea    rcx,[rcx+0x1]
   18179e169:	72 e5                	jb     0x18179e150
   18179e16b:	48 89 85 d0 01 00 00 	mov    QWORD PTR [rbp+0x1d0],rax
   18179e172:	48 8b 8d b8 02 00 00 	mov    rcx,QWORD PTR [rbp+0x2b8]
   18179e179:	48 2b 8d b0 02 00 00 	sub    rcx,QWORD PTR [rbp+0x2b0]
   18179e180:	48 c1 f9 03          	sar    rcx,0x3
   18179e184:	48 b8 f5 d3 4f 3f fd 	movabs rax,0x4fd3f4fd3f4fd3f5
   18179e18b:	f4 d3 4f 
   18179e18e:	48 0f af c8          	imul   rcx,rax
   18179e192:	48 c7 85 00 01 00 00 	mov    QWORD PTR [rbp+0x100],0x0
   18179e199:	00 00 00 00 
   18179e19d:	41 ba 07 00 00 00    	mov    r10d,0x7
   18179e1a3:	4c 8d 8d 07 01 00 00 	lea    r9,[rbp+0x107]
   18179e1aa:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
   18179e1b0:	48 89 c8             	mov    rax,rcx
   18179e1b3:	49 f7 e6             	mul    r14
   18179e1b6:	48 c1 ea 03          	shr    rdx,0x3
   18179e1ba:	48 8d 04 12          	lea    rax,[rdx+rdx*1]
   18179e1be:	48 8d 04 80          	lea    rax,[rax+rax*4]
   18179e1c2:	4d 89 c3             	mov    r11,r8
   18179e1c5:	49 29 c3             	sub    r11,rax
   18179e1c8:	41 0f b6 44 0b 23    	movzx  eax,BYTE PTR [r11+rcx*1+0x23]
   18179e1ce:	41 88 41 01          	mov    BYTE PTR [r9+0x1],al
   18179e1d2:	49 ff c1             	inc    r9
   18179e1d5:	49 ff c2             	inc    r10
   18179e1d8:	48 83 f9 09          	cmp    rcx,0x9
   18179e1dc:	48 89 d1             	mov    rcx,rdx
   18179e1df:	77 cf                	ja     0x18179e1b0
   18179e1e1:	48 8d 85 08 01 00 00 	lea    rax,[rbp+0x108]
   18179e1e8:	41 c6 41 01 00       	mov    BYTE PTR [r9+0x1],0x0
   18179e1ed:	49 83 fa 09          	cmp    r10,0x9
   18179e1f1:	72 28                	jb     0x18179e21b
   18179e1f3:	48 8d 8d 09 01 00 00 	lea    rcx,[rbp+0x109]
   18179e1fa:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
   18179e200:	41 0f b6 11          	movzx  edx,BYTE PTR [r9]
   18179e204:	44 0f b6 41 ff       	movzx  r8d,BYTE PTR [rcx-0x1]
   18179e209:	45 88 01             	mov    BYTE PTR [r9],r8b
   18179e20c:	49 ff c9             	dec    r9
   18179e20f:	88 51 ff             	mov    BYTE PTR [rcx-0x1],dl
   18179e212:	4c 39 c9             	cmp    rcx,r9
   18179e215:	48 8d 49 01          	lea    rcx,[rcx+0x1]
   18179e219:	72 e5                	jb     0x18179e200
   18179e21b:	48 89 85 00 01 00 00 	mov    QWORD PTR [rbp+0x100],rax
   18179e222:	48 83 bd 18 04 00 00 	cmp    QWORD PTR [rbp+0x418],0x10
   18179e229:	10 
   18179e22a:	0f 82 30 03 00 00    	jb     0x18179e560
   18179e230:	48 8b 85 00 04 00 00 	mov    rax,QWORD PTR [rbp+0x400]
   18179e237:	e9 2b 03 00 00       	jmp    0x18179e567
   18179e23c:	b9 04 00 00 00       	mov    ecx,0x4
   18179e241:	e8 9a eb 8c fe       	call   0x18006cde0
   18179e246:	85 c0                	test   eax,eax
   18179e248:	48 bf cd cc cc cc cc 	movabs rdi,0xcccccccccccccccd
   18179e24f:	cc cc cc 
   18179e252:	0f 84 03 02 00 00    	je     0x18179e45b
   18179e258:	48 8d b5 50 02 00 00 	lea    rsi,[rbp+0x250]
   18179e25f:	48 89 f1             	mov    rcx,rsi
   18179e262:	e8 a9 ec 8c fe       	call   0x18006cf10
   18179e267:	90                   	nop
   18179e268:	48 83 bd 68 02 00 00 	cmp    QWORD PTR [rbp+0x268],0x10
   18179e26f:	10 
   18179e270:	72 07                	jb     0x18179e279
   18179e272:	48 8b b5 50 02 00 00 	mov    rsi,QWORD PTR [rbp+0x250]
   18179e279:	48 8d 05 60 00 94 07 	lea    rax,[rip+0x7940060]        # 0x1890de2e0
   18179e280:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   18179e285:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   18179e28c:	00 00 
   18179e28e:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   18179e293:	c7 44 24 28 10 03 00 	mov    DWORD PTR [rsp+0x28],0x310
   18179e29a:	00 
   18179e29b:	4c 8d 0d 56 db 93 07 	lea    r9,[rip+0x793db56]        # 0x1890dbdf8
   18179e2a2:	48 8d 8d d0 02 00 00 	lea    rcx,[rbp+0x2d0]
   18179e2a9:	ba 04 00 00 00       	mov    edx,0x4
   18179e2ae:	49 89 f0             	mov    r8,rsi
   18179e2b1:	e8 ba ef 8c fe       	call   0x18006d270
   18179e2b6:	90                   	nop
   18179e2b7:	48 8b 85 40 04 00 00 	mov    rax,QWORD PTR [rbp+0x440]
   18179e2be:	48 8b 00             	mov    rax,QWORD PTR [rax]
   18179e2c1:	48 8b 48 08          	mov    rcx,QWORD PTR [rax+0x8]
   18179e2c5:	48 2b 08             	sub    rcx,QWORD PTR [rax]
   18179e2c8:	48 c1 f9 04          	sar    rcx,0x4
   18179e2cc:	48 c7 85 d0 01 00 00 	mov    QWORD PTR [rbp+0x1d0],0x0
   18179e2d3:	00 00 00 00 
   18179e2d7:	41 b9 07 00 00 00    	mov    r9d,0x7
   18179e2dd:	4c 8d 85 d7 01 00 00 	lea    r8,[rbp+0x1d7]
   18179e2e4:	4c 8d 15 85 7f 5a 07 	lea    r10,[rip+0x75a7f85]        # 0x188d46270
   18179e2eb:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]
   18179e2f0:	48 89 c8             	mov    rax,rcx
   18179e2f3:	48 f7 e7             	mul    rdi
   18179e2f6:	48 c1 ea 03          	shr    rdx,0x3
   18179e2fa:	48 8d 04 12          	lea    rax,[rdx+rdx*1]
   18179e2fe:	48 8d 04 80          	lea    rax,[rax+rax*4]
   18179e302:	4d 89 d3             	mov    r11,r10
   18179e305:	49 29 c3             	sub    r11,rax
   18179e308:	41 0f b6 44 0b 23    	movzx  eax,BYTE PTR [r11+rcx*1+0x23]
   18179e30e:	41 88 40 01          	mov    BYTE PTR [r8+0x1],al
   18179e312:	49 ff c0             	inc    r8
   18179e315:	49 ff c1             	inc    r9
   18179e318:	48 83 f9 09          	cmp    rcx,0x9
   18179e31c:	48 89 d1             	mov    rcx,rdx
   18179e31f:	77 cf                	ja     0x18179e2f0
   18179e321:	48 8d 85 d8 01 00 00 	lea    rax,[rbp+0x1d8]
   18179e328:	41 c6 40 01 00       	mov    BYTE PTR [r8+0x1],0x0
   18179e32d:	49 83 f9 09          	cmp    r9,0x9
   18179e331:	72 28                	jb     0x18179e35b
   18179e333:	48 8d 8d d9 01 00 00 	lea    rcx,[rbp+0x1d9]
   18179e33a:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
   18179e340:	41 0f b6 10          	movzx  edx,BYTE PTR [r8]
   18179e344:	44 0f b6 49 ff       	movzx  r9d,BYTE PTR [rcx-0x1]
   18179e349:	45 88 08             	mov    BYTE PTR [r8],r9b
   18179e34c:	49 ff c8             	dec    r8
   18179e34f:	88 51 ff             	mov    BYTE PTR [rcx-0x1],dl
   18179e352:	4c 39 c1             	cmp    rcx,r8
   18179e355:	48 8d 49 01          	lea    rcx,[rcx+0x1]
   18179e359:	72 e5                	jb     0x18179e340
   18179e35b:	48 89 85 d0 01 00 00 	mov    QWORD PTR [rbp+0x1d0],rax
   18179e362:	48 83 bd 18 04 00 00 	cmp    QWORD PTR [rbp+0x418],0x10
   18179e369:	10 
   18179e36a:	72 1d                	jb     0x18179e389
   18179e36c:	48 8b 85 00 04 00 00 	mov    rax,QWORD PTR [rbp+0x400]
   18179e373:	eb 1b                	jmp    0x18179e390
   18179e375:	41 c7 06 04 00 00 00 	mov    DWORD PTR [r14],0x4
   18179e37c:	41 c7 46 04 90 01 00 	mov    DWORD PTR [r14+0x4],0x190
   18179e383:	00 
   18179e384:	e9 83 1e 00 00       	jmp    0x1817a020c
   18179e389:	48 8d 85 00 04 00 00 	lea    rax,[rbp+0x400]
   18179e390:	48 89 85 00 01 00 00 	mov    QWORD PTR [rbp+0x100],rax
   18179e397:	c6 85 08 01 00 00 00 	mov    BYTE PTR [rbp+0x108],0x0
   18179e39e:	0f 57 c0             	xorps  xmm0,xmm0
   18179e3a1:	0f 11 85 d0 03 00 00 	movups XMMWORD PTR [rbp+0x3d0],xmm0
   18179e3a8:	0f 11 85 c0 03 00 00 	movups XMMWORD PTR [rbp+0x3c0],xmm0
   18179e3af:	0f 11 85 b0 03 00 00 	movups XMMWORD PTR [rbp+0x3b0],xmm0
   18179e3b6:	0f 11 85 a0 03 00 00 	movups XMMWORD PTR [rbp+0x3a0],xmm0
   18179e3bd:	0f 11 85 90 03 00 00 	movups XMMWORD PTR [rbp+0x390],xmm0
   18179e3c4:	0f 11 85 80 03 00 00 	movups XMMWORD PTR [rbp+0x380],xmm0
   18179e3cb:	0f 11 85 70 03 00 00 	movups XMMWORD PTR [rbp+0x370],xmm0
   18179e3d2:	48 8d 85 00 01 00 00 	lea    rax,[rbp+0x100]
   18179e3d9:	48 89 85 60 03 00 00 	mov    QWORD PTR [rbp+0x360],rax
   18179e3e0:	48 8d 85 d0 01 00 00 	lea    rax,[rbp+0x1d0]
   18179e3e7:	48 89 85 68 03 00 00 	mov    QWORD PTR [rbp+0x368],rax
   18179e3ee:	48 8d 15 1b 0d 94 07 	lea    rdx,[rip+0x7940d1b]        # 0x1890df110
   18179e3f5:	48 8d 8d d0 02 00 00 	lea    rcx,[rbp+0x2d0]
   18179e3fc:	4c 8d 85 60 03 00 00 	lea    r8,[rbp+0x360]
   18179e403:	e8 08 f4 8c fe       	call   0x18006d810
   18179e408:	90                   	nop
   18179e409:	48 8d 8d d0 02 00 00 	lea    rcx,[rbp+0x2d0]
   18179e410:	e8 5b ef 8c fe       	call   0x18006d370
   18179e415:	48 8b 85 68 02 00 00 	mov    rax,QWORD PTR [rbp+0x268]
   18179e41c:	48 83 f8 10          	cmp    rax,0x10
   18179e420:	72 39                	jb     0x18179e45b
   18179e422:	48 8b 8d 50 02 00 00 	mov    rcx,QWORD PTR [rbp+0x250]
   18179e429:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18179e42d:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18179e434:	72 1f                	jb     0x18179e455
   18179e436:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18179e43a:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18179e43e:	4c 29 c1             	sub    rcx,r8
   18179e441:	48 83 f9 20          	cmp    rcx,0x20
   18179e445:	0f 83 e6 1d 00 00    	jae    0x1817a0231
   18179e44b:	48 83 c0 28          	add    rax,0x28
   18179e44f:	48 89 c2             	mov    rdx,rax
   18179e452:	4c 89 c1             	mov    rcx,r8
   18179e455:	e8 86 d4 d0 05       	call   0x1874ab8e0
   18179e45a:	90                   	nop
   18179e45b:	48 8d 8d d0 02 00 00 	lea    rcx,[rbp+0x2d0]
   18179e462:	ba 01 00 00 00       	mov    edx,0x1
   18179e467:	41 b8 01 00 00 00    	mov    r8d,0x1
   18179e46d:	e8 2e 99 1e 02       	call   0x183987da0
   18179e472:	90                   	nop
   18179e473:	4c 8b b5 28 02 00 00 	mov    r14,QWORD PTR [rbp+0x228]
   18179e47a:	49 8b 76 28          	mov    rsi,QWORD PTR [r14+0x28]
   18179e47e:	48 8d 95 d0 02 00 00 	lea    rdx,[rbp+0x2d0]
   18179e485:	48 89 f1             	mov    rcx,rsi
   18179e488:	e8 f3 c8 09 00       	call   0x18183ad80
   18179e48d:	90                   	nop
   18179e48e:	48 8b 85 28 03 00 00 	mov    rax,QWORD PTR [rbp+0x328]
   18179e495:	48 89 46 58          	mov    QWORD PTR [rsi+0x58],rax
   18179e499:	41 c7 46 04 00 00 00 	mov    DWORD PTR [r14+0x4],0x0
   18179e4a0:	00 
   18179e4a1:	80 bd 20 03 00 00 00 	cmp    BYTE PTR [rbp+0x320],0x0
   18179e4a8:	0f 84 9e 00 00 00    	je     0x18179e54c
   18179e4ae:	48 8b 85 18 03 00 00 	mov    rax,QWORD PTR [rbp+0x318]
   18179e4b5:	48 83 f8 10          	cmp    rax,0x10
   18179e4b9:	72 38                	jb     0x18179e4f3
   18179e4bb:	48 8b 8d 00 03 00 00 	mov    rcx,QWORD PTR [rbp+0x300]
   18179e4c2:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18179e4c6:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18179e4cd:	72 1f                	jb     0x18179e4ee
   18179e4cf:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18179e4d3:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18179e4d7:	4c 29 c1             	sub    rcx,r8
   18179e4da:	48 83 f9 20          	cmp    rcx,0x20
   18179e4de:	0f 83 4d 1d 00 00    	jae    0x1817a0231
   18179e4e4:	48 83 c0 28          	add    rax,0x28
   18179e4e8:	48 89 c2             	mov    rdx,rax
   18179e4eb:	4c 89 c1             	mov    rcx,r8
   18179e4ee:	e8 ed d3 d0 05       	call   0x1874ab8e0
   18179e4f3:	48 8b 85 e8 02 00 00 	mov    rax,QWORD PTR [rbp+0x2e8]
   18179e4fa:	48 83 f8 10          	cmp    rax,0x10
   18179e4fe:	72 38                	jb     0x18179e538
   18179e500:	48 8b 8d d0 02 00 00 	mov    rcx,QWORD PTR [rbp+0x2d0]
   18179e507:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18179e50b:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18179e512:	72 1f                	jb     0x18179e533
   18179e514:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18179e518:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18179e51c:	4c 29 c1             	sub    rcx,r8
   18179e51f:	48 83 f9 20          	cmp    rcx,0x20
   18179e523:	0f 83 08 1d 00 00    	jae    0x1817a0231
   18179e529:	48 83 c0 28          	add    rax,0x28
   18179e52d:	48 89 c2             	mov    rdx,rax
   18179e530:	4c 89 c1             	mov    rcx,r8
   18179e533:	e8 a8 d3 d0 05       	call   0x1874ab8e0
   18179e538:	41 83 7e 04 00       	cmp    DWORD PTR [r14+0x4],0x0
   18179e53d:	41 c7 06 04 00 00 00 	mov    DWORD PTR [r14],0x4
   18179e544:	0f 85 1a 1b 00 00    	jne    0x1817a0064
   18179e54a:	eb 07                	jmp    0x18179e553
   18179e54c:	41 c7 06 04 00 00 00 	mov    DWORD PTR [r14],0x4
   18179e553:	41 c7 46 04 90 01 00 	mov    DWORD PTR [r14+0x4],0x190
   18179e55a:	00 
   18179e55b:	e9 04 1b 00 00       	jmp    0x1817a0064
   18179e560:	48 8d 85 00 04 00 00 	lea    rax,[rbp+0x400]
   18179e567:	48 89 85 50 02 00 00 	mov    QWORD PTR [rbp+0x250],rax
   18179e56e:	c6 85 58 02 00 00 00 	mov    BYTE PTR [rbp+0x258],0x0
   18179e575:	0f 57 c0             	xorps  xmm0,xmm0
   18179e578:	0f 11 85 c8 03 00 00 	movups XMMWORD PTR [rbp+0x3c8],xmm0
   18179e57f:	0f 11 85 b8 03 00 00 	movups XMMWORD PTR [rbp+0x3b8],xmm0
   18179e586:	0f 11 85 a8 03 00 00 	movups XMMWORD PTR [rbp+0x3a8],xmm0
   18179e58d:	0f 11 85 98 03 00 00 	movups XMMWORD PTR [rbp+0x398],xmm0
   18179e594:	0f 11 85 88 03 00 00 	movups XMMWORD PTR [rbp+0x388],xmm0
   18179e59b:	0f 11 85 78 03 00 00 	movups XMMWORD PTR [rbp+0x378],xmm0
   18179e5a2:	48 c7 85 d8 03 00 00 	mov    QWORD PTR [rbp+0x3d8],0x0
   18179e5a9:	00 00 00 00 
   18179e5ad:	48 8d 85 50 02 00 00 	lea    rax,[rbp+0x250]
   18179e5b4:	48 89 85 60 03 00 00 	mov    QWORD PTR [rbp+0x360],rax
   18179e5bb:	48 8d 85 00 01 00 00 	lea    rax,[rbp+0x100]
   18179e5c2:	48 89 85 68 03 00 00 	mov    QWORD PTR [rbp+0x368],rax
   18179e5c9:	48 8d 85 d0 01 00 00 	lea    rax,[rbp+0x1d0]
   18179e5d0:	48 89 85 70 03 00 00 	mov    QWORD PTR [rbp+0x370],rax
   18179e5d7:	48 8d 15 c2 e2 93 07 	lea    rdx,[rip+0x793e2c2]        # 0x1890dc8a0
   18179e5de:	48 8d 8d d0 02 00 00 	lea    rcx,[rbp+0x2d0]
   18179e5e5:	4c 8d 85 60 03 00 00 	lea    r8,[rbp+0x360]
   18179e5ec:	e8 1f f2 8c fe       	call   0x18006d810
   18179e5f1:	90                   	nop
   18179e5f2:	48 8d 8d d0 02 00 00 	lea    rcx,[rbp+0x2d0]
   18179e5f9:	e8 72 ed 8c fe       	call   0x18006d370
   18179e5fe:	48 8b 85 88 01 00 00 	mov    rax,QWORD PTR [rbp+0x188]
   18179e605:	48 83 f8 10          	cmp    rax,0x10
   18179e609:	72 39                	jb     0x18179e644
   18179e60b:	48 8b 8d 70 01 00 00 	mov    rcx,QWORD PTR [rbp+0x170]
   18179e612:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18179e616:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18179e61d:	72 1f                	jb     0x18179e63e
   18179e61f:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18179e623:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18179e627:	4c 29 c1             	sub    rcx,r8
   18179e62a:	48 83 f9 20          	cmp    rcx,0x20
   18179e62e:	0f 83 fd 1b 00 00    	jae    0x1817a0231
   18179e634:	48 83 c0 28          	add    rax,0x28
   18179e638:	48 89 c2             	mov    rdx,rax
   18179e63b:	4c 89 c1             	mov    rcx,r8
   18179e63e:	e8 9d d2 d0 05       	call   0x1874ab8e0
   18179e643:	90                   	nop
   18179e644:	48 8d 15 d5 6b 93 07 	lea    rdx,[rip+0x7936bd5]        # 0x1890d5220
   18179e64b:	48 8d 8d b0 00 00 00 	lea    rcx,[rbp+0xb0]
   18179e652:	45 31 c0             	xor    r8d,r8d
   18179e655:	e8 f6 b6 bc fe       	call   0x180369d50
   18179e65a:	90                   	nop
   18179e65b:	4c 89 ad 40 02 00 00 	mov    QWORD PTR [rbp+0x240],r13
   18179e662:	0f 29 b5 30 02 00 00 	movaps XMMWORD PTR [rbp+0x230],xmm6
   18179e669:	48 8b 85 c8 01 00 00 	mov    rax,QWORD PTR [rbp+0x1c8]
   18179e670:	48 8b 88 80 0c 00 00 	mov    rcx,QWORD PTR [rax+0xc80]
   18179e677:	48 8d 95 d0 02 00 00 	lea    rdx,[rbp+0x2d0]
   18179e67e:	4c 8d 85 b0 02 00 00 	lea    r8,[rbp+0x2b0]
   18179e685:	48 8d b5 00 04 00 00 	lea    rsi,[rbp+0x400]
   18179e68c:	49 89 f1             	mov    r9,rsi
   18179e68f:	e8 3c a8 0f 02       	call   0x183898ed0
   18179e694:	90                   	nop
   18179e695:	48 8d 8d 60 03 00 00 	lea    rcx,[rbp+0x360]
   18179e69c:	48 8d 95 30 02 00 00 	lea    rdx,[rbp+0x230]
   18179e6a3:	48 8d bd d0 02 00 00 	lea    rdi,[rbp+0x2d0]
   18179e6aa:	49 89 f8             	mov    r8,rdi
   18179e6ad:	e8 fe 34 00 00       	call   0x1817a1bb0
   18179e6b2:	90                   	nop
   18179e6b3:	48 8b 9d d8 02 00 00 	mov    rbx,QWORD PTR [rbp+0x2d8]
   18179e6ba:	48 85 db             	test   rbx,rbx
   18179e6bd:	74 1d                	je     0x18179e6dc
   18179e6bf:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   18179e6c3:	75 17                	jne    0x18179e6dc
   18179e6c5:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   18179e6c8:	48 89 d9             	mov    rcx,rbx
   18179e6cb:	ff 10                	call   QWORD PTR [rax]
   18179e6cd:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   18179e6d1:	75 09                	jne    0x18179e6dc
   18179e6d3:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   18179e6d6:	48 89 d9             	mov    rcx,rbx
   18179e6d9:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18179e6dc:	48 8b 8d b8 02 00 00 	mov    rcx,QWORD PTR [rbp+0x2b8]
   18179e6e3:	48 2b 8d b0 02 00 00 	sub    rcx,QWORD PTR [rbp+0x2b0]
   18179e6ea:	48 c1 f9 03          	sar    rcx,0x3
   18179e6ee:	48 b8 f5 d3 4f 3f fd 	movabs rax,0x4fd3f4fd3f4fd3f5
   18179e6f5:	f4 d3 4f 
   18179e6f8:	48 0f af c8          	imul   rcx,rax
   18179e6fc:	4c 8d bd 75 03 00 00 	lea    r15,[rbp+0x375]
   18179e703:	4c 89 ad 6d 03 00 00 	mov    QWORD PTR [rbp+0x36d],r13
   18179e70a:	0f 29 b5 60 03 00 00 	movaps XMMWORD PTR [rbp+0x360],xmm6
   18179e711:	31 db                	xor    ebx,ebx
   18179e713:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
   18179e71a:	84 00 00 00 00 00 
   18179e720:	48 89 c8             	mov    rax,rcx
   18179e723:	49 f7 e6             	mul    r14
   18179e726:	48 c1 ea 03          	shr    rdx,0x3
   18179e72a:	8d 04 12             	lea    eax,[rdx+rdx*1]
   18179e72d:	8d 04 80             	lea    eax,[rax+rax*4]
   18179e730:	41 89 c8             	mov    r8d,ecx
   18179e733:	41 29 c0             	sub    r8d,eax
   18179e736:	41 80 c8 30          	or     r8b,0x30
   18179e73a:	45 88 47 ff          	mov    BYTE PTR [r15-0x1],r8b
   18179e73e:	49 ff cf             	dec    r15
   18179e741:	48 ff c3             	inc    rbx
   18179e744:	48 83 f9 09          	cmp    rcx,0x9
   18179e748:	48 89 d1             	mov    rcx,rdx
   18179e74b:	77 d3                	ja     0x18179e720
   18179e74d:	0f 57 c0             	xorps  xmm0,xmm0
   18179e750:	0f 29 85 d0 02 00 00 	movaps XMMWORD PTR [rbp+0x2d0],xmm0
   18179e757:	48 85 db             	test   rbx,rbx
   18179e75a:	4c 8d ad d0 01 00 00 	lea    r13,[rbp+0x1d0]
   18179e761:	0f 88 dc 1a 00 00    	js     0x1817a0243
   18179e767:	41 be 0f 00 00 00    	mov    r14d,0xf
   18179e76d:	48 83 fb 10          	cmp    rbx,0x10
   18179e771:	72 58                	jb     0x18179e7cb
   18179e773:	48 89 d8             	mov    rax,rbx
   18179e776:	48 83 c8 0f          	or     rax,0xf
   18179e77a:	48 83 f8 17          	cmp    rax,0x17
   18179e77e:	41 be 16 00 00 00    	mov    r14d,0x16
   18179e784:	4c 0f 43 f0          	cmovae r14,rax
   18179e788:	48 3d ff 0f 00 00    	cmp    rax,0xfff
   18179e78e:	72 27                	jb     0x18179e7b7
   18179e790:	49 8d 4e 28          	lea    rcx,[r14+0x28]
   18179e794:	e8 03 d1 d0 05       	call   0x1874ab89c
   18179e799:	90                   	nop
   18179e79a:	48 89 c7             	mov    rdi,rax
   18179e79d:	48 85 c0             	test   rax,rax
   18179e7a0:	0f 84 8b 1a 00 00    	je     0x1817a0231
   18179e7a6:	48 89 f8             	mov    rax,rdi
   18179e7a9:	48 83 c7 27          	add    rdi,0x27
   18179e7ad:	48 83 e7 e0          	and    rdi,0xffffffffffffffe0
   18179e7b1:	48 89 47 f8          	mov    QWORD PTR [rdi-0x8],rax
   18179e7b5:	eb 0d                	jmp    0x18179e7c4
   18179e7b7:	49 8d 4e 01          	lea    rcx,[r14+0x1]
   18179e7bb:	e8 dc d0 d0 05       	call   0x1874ab89c
   18179e7c0:	90                   	nop
   18179e7c1:	48 89 c7             	mov    rdi,rax
   18179e7c4:	48 89 bd d0 02 00 00 	mov    QWORD PTR [rbp+0x2d0],rdi
   18179e7cb:	48 89 9d e0 02 00 00 	mov    QWORD PTR [rbp+0x2e0],rbx
   18179e7d2:	4c 89 b5 e8 02 00 00 	mov    QWORD PTR [rbp+0x2e8],r14
   18179e7d9:	48 89 f9             	mov    rcx,rdi
   18179e7dc:	4c 89 fa             	mov    rdx,r15
   18179e7df:	49 89 d8             	mov    r8,rbx
   18179e7e2:	e8 69 58 da 05       	call   0x187544050
   18179e7e7:	c6 04 1f 00          	mov    BYTE PTR [rdi+rbx*1],0x0
   18179e7eb:	48 8b bd 10 04 00 00 	mov    rdi,QWORD PTR [rbp+0x410]
   18179e7f2:	48 b8 e3 ff ff ff ff 	movabs rax,0x7fffffffffffffe3
   18179e7f9:	ff ff 7f 
   18179e7fc:	48 39 c7             	cmp    rdi,rax
   18179e7ff:	0f 8d 44 1a 00 00    	jge    0x1817a0249
   18179e805:	48 8b 9d 00 04 00 00 	mov    rbx,QWORD PTR [rbp+0x400]
   18179e80c:	4c 8b b5 18 04 00 00 	mov    r14,QWORD PTR [rbp+0x418]
   18179e813:	0f 57 c0             	xorps  xmm0,xmm0
   18179e816:	0f 29 85 d0 01 00 00 	movaps XMMWORD PTR [rbp+0x1d0],xmm0
   18179e81d:	4c 8d 7f 1d          	lea    r15,[rdi+0x1d]
   18179e821:	41 bc 0f 00 00 00    	mov    r12d,0xf
   18179e827:	49 83 ff 10          	cmp    r15,0x10
   18179e82b:	72 6c                	jb     0x18179e899
   18179e82d:	48 83 ff e3          	cmp    rdi,0xffffffffffffffe3
   18179e831:	7d 0c                	jge    0x18179e83f
   18179e833:	49 bc ff ff ff ff ff 	movabs r12,0x7fffffffffffffff
   18179e83a:	ff ff 7f 
   18179e83d:	eb 1d                	jmp    0x18179e85c
   18179e83f:	4c 89 f8             	mov    rax,r15
   18179e842:	48 83 c8 0f          	or     rax,0xf
   18179e846:	48 83 f8 17          	cmp    rax,0x17
   18179e84a:	41 bc 16 00 00 00    	mov    r12d,0x16
   18179e850:	4c 0f 43 e0          	cmovae r12,rax
   18179e854:	48 3d ff 0f 00 00    	cmp    rax,0xfff
   18179e85a:	72 28                	jb     0x18179e884
   18179e85c:	49 8d 4c 24 28       	lea    rcx,[r12+0x28]
   18179e861:	e8 36 d0 d0 05       	call   0x1874ab89c
   18179e866:	90                   	nop
   18179e867:	49 89 c5             	mov    r13,rax
   18179e86a:	48 85 c0             	test   rax,rax
   18179e86d:	0f 84 be 19 00 00    	je     0x1817a0231
   18179e873:	4c 89 e8             	mov    rax,r13
   18179e876:	49 83 c5 27          	add    r13,0x27
   18179e87a:	49 83 e5 e0          	and    r13,0xffffffffffffffe0
   18179e87e:	49 89 45 f8          	mov    QWORD PTR [r13-0x8],rax
   18179e882:	eb 0e                	jmp    0x18179e892
   18179e884:	49 8d 4c 24 01       	lea    rcx,[r12+0x1]
   18179e889:	e8 0e d0 d0 05       	call   0x1874ab89c
   18179e88e:	90                   	nop
   18179e88f:	49 89 c5             	mov    r13,rax
   18179e892:	4c 89 ad d0 01 00 00 	mov    QWORD PTR [rbp+0x1d0],r13
   18179e899:	49 83 fe 10          	cmp    r14,0x10
   18179e89d:	48 0f 42 de          	cmovb  rbx,rsi
   18179e8a1:	4c 89 bd e0 01 00 00 	mov    QWORD PTR [rbp+0x1e0],r15
   18179e8a8:	4c 89 a5 e8 01 00 00 	mov    QWORD PTR [rbp+0x1e8],r12
   18179e8af:	0f 10 05 87 69 93 07 	movups xmm0,XMMWORD PTR [rip+0x7936987]        # 0x1890d523d
   18179e8b6:	41 0f 11 45 0d       	movups XMMWORD PTR [r13+0xd],xmm0
   18179e8bb:	0f 10 05 6e 69 93 07 	movups xmm0,XMMWORD PTR [rip+0x793696e]        # 0x1890d5230
   18179e8c2:	41 0f 11 45 00       	movups XMMWORD PTR [r13+0x0],xmm0
   18179e8c7:	49 8d 4d 1d          	lea    rcx,[r13+0x1d]
   18179e8cb:	48 89 da             	mov    rdx,rbx
   18179e8ce:	49 89 f8             	mov    r8,rdi
   18179e8d1:	e8 7a 57 da 05       	call   0x187544050
   18179e8d6:	41 c6 44 3d 1d 00    	mov    BYTE PTR [r13+rdi*1+0x1d],0x0
   18179e8dc:	48 8b 8d e0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1e0]
   18179e8e3:	48 8b 95 e8 01 00 00 	mov    rdx,QWORD PTR [rbp+0x1e8]
   18179e8ea:	48 89 d0             	mov    rax,rdx
   18179e8ed:	48 29 c8             	sub    rax,rcx
   18179e8f0:	48 83 f8 08          	cmp    rax,0x8
   18179e8f4:	73 24                	jae    0x18179e91a
   18179e8f6:	48 c7 44 24 20 08 00 	mov    QWORD PTR [rsp+0x20],0x8
   18179e8fd:	00 00 
   18179e8ff:	4c 8d 0d 72 3c 82 07 	lea    r9,[rip+0x7823c72]        # 0x188fc2578
   18179e906:	48 8d 8d d0 01 00 00 	lea    rcx,[rbp+0x1d0]
   18179e90d:	ba 08 00 00 00       	mov    edx,0x8
   18179e912:	e8 a9 aa 86 fe       	call   0x1800093c0
   18179e917:	90                   	nop
   18179e918:	eb 36                	jmp    0x18179e950
   18179e91a:	48 8d 41 08          	lea    rax,[rcx+0x8]
   18179e91e:	48 89 85 e0 01 00 00 	mov    QWORD PTR [rbp+0x1e0],rax
   18179e925:	48 8d 85 d0 01 00 00 	lea    rax,[rbp+0x1d0]
   18179e92c:	49 89 c0             	mov    r8,rax
   18179e92f:	48 83 fa 10          	cmp    rdx,0x10
   18179e933:	72 07                	jb     0x18179e93c
   18179e935:	4c 8b 85 d0 01 00 00 	mov    r8,QWORD PTR [rbp+0x1d0]
   18179e93c:	48 ba 2c 20 63 6f 75 	movabs rdx,0x3a746e756f63202c
   18179e943:	6e 74 3a 
   18179e946:	49 89 14 08          	mov    QWORD PTR [r8+rcx*1],rdx
   18179e94a:	41 c6 44 08 08 00    	mov    BYTE PTR [r8+rcx*1+0x8],0x0
   18179e950:	0f 10 00             	movups xmm0,XMMWORD PTR [rax]
   18179e953:	0f 10 48 10          	movups xmm1,XMMWORD PTR [rax+0x10]
   18179e957:	0f 29 8d 70 03 00 00 	movaps XMMWORD PTR [rbp+0x370],xmm1
   18179e95e:	0f 29 85 60 03 00 00 	movaps XMMWORD PTR [rbp+0x360],xmm0
   18179e965:	48 c7 40 10 00 00 00 	mov    QWORD PTR [rax+0x10],0x0
   18179e96c:	00 
   18179e96d:	48 c7 40 18 0f 00 00 	mov    QWORD PTR [rax+0x18],0xf
   18179e974:	00 
   18179e975:	c6 00 00             	mov    BYTE PTR [rax],0x0
   18179e978:	48 8d 4d c0          	lea    rcx,[rbp-0x40]
   18179e97c:	4c 8d 85 60 03 00 00 	lea    r8,[rbp+0x360]
   18179e983:	4c 8d 8d d0 02 00 00 	lea    r9,[rbp+0x2d0]
   18179e98a:	e8 41 59 8e fe       	call   0x1800842d0
   18179e98f:	90                   	nop
   18179e990:	48 8d 8d b0 00 00 00 	lea    rcx,[rbp+0xb0]
   18179e997:	48 8d 55 c0          	lea    rdx,[rbp-0x40]
   18179e99b:	45 31 c0             	xor    r8d,r8d
   18179e99e:	e8 4d 67 82 ff       	call   0x180fc50f0
   18179e9a3:	90                   	nop
   18179e9a4:	48 8b 85 78 03 00 00 	mov    rax,QWORD PTR [rbp+0x378]
   18179e9ab:	48 83 f8 10          	cmp    rax,0x10
   18179e9af:	72 38                	jb     0x18179e9e9
   18179e9b1:	48 8b 8d 60 03 00 00 	mov    rcx,QWORD PTR [rbp+0x360]
   18179e9b8:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18179e9bc:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18179e9c3:	72 1f                	jb     0x18179e9e4
   18179e9c5:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18179e9c9:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18179e9cd:	4c 29 c1             	sub    rcx,r8
   18179e9d0:	48 83 f9 20          	cmp    rcx,0x20
   18179e9d4:	0f 83 57 18 00 00    	jae    0x1817a0231
   18179e9da:	48 83 c0 28          	add    rax,0x28
   18179e9de:	48 89 c2             	mov    rdx,rax
   18179e9e1:	4c 89 c1             	mov    rcx,r8
   18179e9e4:	e8 f7 ce d0 05       	call   0x1874ab8e0
   18179e9e9:	48 8b 85 e8 01 00 00 	mov    rax,QWORD PTR [rbp+0x1e8]
   18179e9f0:	48 83 f8 10          	cmp    rax,0x10
   18179e9f4:	72 38                	jb     0x18179ea2e
   18179e9f6:	48 8b 8d d0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1d0]
   18179e9fd:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18179ea01:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18179ea08:	72 1f                	jb     0x18179ea29
   18179ea0a:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18179ea0e:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18179ea12:	4c 29 c1             	sub    rcx,r8
   18179ea15:	48 83 f9 20          	cmp    rcx,0x20
   18179ea19:	0f 83 12 18 00 00    	jae    0x1817a0231
   18179ea1f:	48 83 c0 28          	add    rax,0x28
   18179ea23:	48 89 c2             	mov    rdx,rax
   18179ea26:	4c 89 c1             	mov    rcx,r8
   18179ea29:	e8 b2 ce d0 05       	call   0x1874ab8e0
   18179ea2e:	48 8b 85 e8 02 00 00 	mov    rax,QWORD PTR [rbp+0x2e8]
   18179ea35:	48 83 f8 10          	cmp    rax,0x10
   18179ea39:	72 38                	jb     0x18179ea73
   18179ea3b:	48 8b 8d d0 02 00 00 	mov    rcx,QWORD PTR [rbp+0x2d0]
   18179ea42:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18179ea46:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18179ea4d:	72 1f                	jb     0x18179ea6e
   18179ea4f:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18179ea53:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18179ea57:	4c 29 c1             	sub    rcx,r8
   18179ea5a:	48 83 f9 20          	cmp    rcx,0x20
   18179ea5e:	0f 83 cd 17 00 00    	jae    0x1817a0231
   18179ea64:	48 83 c0 28          	add    rax,0x28
   18179ea68:	48 89 c2             	mov    rdx,rax
   18179ea6b:	4c 89 c1             	mov    rcx,r8
   18179ea6e:	e8 6d ce d0 05       	call   0x1874ab8e0
   18179ea73:	b9 02 00 00 00       	mov    ecx,0x2
   18179ea78:	e8 63 e3 8c fe       	call   0x18006cde0
   18179ea7d:	85 c0                	test   eax,eax
   18179ea7f:	0f 84 ba 02 00 00    	je     0x18179ed3f
   18179ea85:	48 8d bd 70 01 00 00 	lea    rdi,[rbp+0x170]
   18179ea8c:	48 89 f9             	mov    rcx,rdi
   18179ea8f:	e8 7c e4 8c fe       	call   0x18006cf10
   18179ea94:	90                   	nop
   18179ea95:	48 83 bd 88 01 00 00 	cmp    QWORD PTR [rbp+0x188],0x10
   18179ea9c:	10 
   18179ea9d:	72 07                	jb     0x18179eaa6
   18179ea9f:	48 8b bd 70 01 00 00 	mov    rdi,QWORD PTR [rbp+0x170]
   18179eaa6:	48 8d 05 33 f8 93 07 	lea    rax,[rip+0x793f833]        # 0x1890de2e0
   18179eaad:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   18179eab2:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   18179eab9:	00 00 
   18179eabb:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   18179eac0:	c7 44 24 28 1c 03 00 	mov    DWORD PTR [rsp+0x28],0x31c
   18179eac7:	00 
   18179eac8:	4c 8d 0d 29 d3 93 07 	lea    r9,[rip+0x793d329]        # 0x1890dbdf8
   18179eacf:	48 8d 8d d0 02 00 00 	lea    rcx,[rbp+0x2d0]
   18179ead6:	ba 02 00 00 00       	mov    edx,0x2
   18179eadb:	49 89 f8             	mov    r8,rdi
   18179eade:	e8 8d e7 8c fe       	call   0x18006d270
   18179eae3:	90                   	nop
   18179eae4:	48 bf cd cc cc cc cc 	movabs rdi,0xcccccccccccccccd
   18179eaeb:	cc cc cc 
   18179eaee:	48 8b 8d 38 02 00 00 	mov    rcx,QWORD PTR [rbp+0x238]
   18179eaf5:	48 2b 8d 30 02 00 00 	sub    rcx,QWORD PTR [rbp+0x230]
   18179eafc:	48 c1 f9 03          	sar    rcx,0x3
   18179eb00:	48 b8 f5 d3 4f 3f fd 	movabs rax,0x4fd3f4fd3f4fd3f5
   18179eb07:	f4 d3 4f 
   18179eb0a:	48 0f af c8          	imul   rcx,rax
   18179eb0e:	48 c7 85 d0 01 00 00 	mov    QWORD PTR [rbp+0x1d0],0x0
   18179eb15:	00 00 00 00 
   18179eb19:	41 ba 07 00 00 00    	mov    r10d,0x7
   18179eb1f:	4c 8d 8d d7 01 00 00 	lea    r9,[rbp+0x1d7]
   18179eb26:	4c 8d 05 43 77 5a 07 	lea    r8,[rip+0x75a7743]        # 0x188d46270
   18179eb2d:	0f 1f 00             	nop    DWORD PTR [rax]
   18179eb30:	48 89 c8             	mov    rax,rcx
   18179eb33:	48 f7 e7             	mul    rdi
   18179eb36:	48 c1 ea 03          	shr    rdx,0x3
   18179eb3a:	48 8d 04 12          	lea    rax,[rdx+rdx*1]
   18179eb3e:	48 8d 04 80          	lea    rax,[rax+rax*4]
   18179eb42:	4d 89 c3             	mov    r11,r8
   18179eb45:	49 29 c3             	sub    r11,rax
   18179eb48:	41 0f b6 44 0b 23    	movzx  eax,BYTE PTR [r11+rcx*1+0x23]
   18179eb4e:	41 88 41 01          	mov    BYTE PTR [r9+0x1],al
   18179eb52:	49 ff c1             	inc    r9
   18179eb55:	49 ff c2             	inc    r10
   18179eb58:	48 83 f9 09          	cmp    rcx,0x9
   18179eb5c:	48 89 d1             	mov    rcx,rdx
   18179eb5f:	77 cf                	ja     0x18179eb30
   18179eb61:	48 8d 85 d8 01 00 00 	lea    rax,[rbp+0x1d8]
   18179eb68:	41 c6 41 01 00       	mov    BYTE PTR [r9+0x1],0x0
   18179eb6d:	49 83 fa 09          	cmp    r10,0x9
   18179eb71:	72 28                	jb     0x18179eb9b
   18179eb73:	48 8d 8d d9 01 00 00 	lea    rcx,[rbp+0x1d9]
   18179eb7a:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
   18179eb80:	41 0f b6 11          	movzx  edx,BYTE PTR [r9]
   18179eb84:	44 0f b6 51 ff       	movzx  r10d,BYTE PTR [rcx-0x1]
   18179eb89:	45 88 11             	mov    BYTE PTR [r9],r10b
   18179eb8c:	49 ff c9             	dec    r9
   18179eb8f:	88 51 ff             	mov    BYTE PTR [rcx-0x1],dl
   18179eb92:	4c 39 c9             	cmp    rcx,r9
   18179eb95:	48 8d 49 01          	lea    rcx,[rcx+0x1]
   18179eb99:	72 e5                	jb     0x18179eb80
   18179eb9b:	48 89 85 d0 01 00 00 	mov    QWORD PTR [rbp+0x1d0],rax
   18179eba2:	48 8b 8d b8 02 00 00 	mov    rcx,QWORD PTR [rbp+0x2b8]
   18179eba9:	48 2b 8d b0 02 00 00 	sub    rcx,QWORD PTR [rbp+0x2b0]
   18179ebb0:	48 c1 f9 03          	sar    rcx,0x3
   18179ebb4:	48 b8 f5 d3 4f 3f fd 	movabs rax,0x4fd3f4fd3f4fd3f5
   18179ebbb:	f4 d3 4f 
   18179ebbe:	48 0f af c8          	imul   rcx,rax
   18179ebc2:	48 c7 85 00 01 00 00 	mov    QWORD PTR [rbp+0x100],0x0
   18179ebc9:	00 00 00 00 
   18179ebcd:	41 ba 07 00 00 00    	mov    r10d,0x7
   18179ebd3:	4c 8d 8d 07 01 00 00 	lea    r9,[rbp+0x107]
   18179ebda:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
   18179ebe0:	48 89 c8             	mov    rax,rcx
   18179ebe3:	48 f7 e7             	mul    rdi
   18179ebe6:	48 c1 ea 03          	shr    rdx,0x3
   18179ebea:	48 8d 04 12          	lea    rax,[rdx+rdx*1]
   18179ebee:	48 8d 04 80          	lea    rax,[rax+rax*4]
   18179ebf2:	4d 89 c3             	mov    r11,r8
   18179ebf5:	49 29 c3             	sub    r11,rax
   18179ebf8:	41 0f b6 44 0b 23    	movzx  eax,BYTE PTR [r11+rcx*1+0x23]
   18179ebfe:	41 88 41 01          	mov    BYTE PTR [r9+0x1],al
   18179ec02:	49 ff c1             	inc    r9
   18179ec05:	49 ff c2             	inc    r10
   18179ec08:	48 83 f9 09          	cmp    rcx,0x9
   18179ec0c:	48 89 d1             	mov    rcx,rdx
   18179ec0f:	77 cf                	ja     0x18179ebe0
   18179ec11:	48 8d 85 08 01 00 00 	lea    rax,[rbp+0x108]
   18179ec18:	41 c6 41 01 00       	mov    BYTE PTR [r9+0x1],0x0
   18179ec1d:	49 83 fa 09          	cmp    r10,0x9
   18179ec21:	72 28                	jb     0x18179ec4b
   18179ec23:	48 8d 8d 09 01 00 00 	lea    rcx,[rbp+0x109]
   18179ec2a:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
   18179ec30:	41 0f b6 11          	movzx  edx,BYTE PTR [r9]
   18179ec34:	44 0f b6 41 ff       	movzx  r8d,BYTE PTR [rcx-0x1]
   18179ec39:	45 88 01             	mov    BYTE PTR [r9],r8b
   18179ec3c:	49 ff c9             	dec    r9
   18179ec3f:	88 51 ff             	mov    BYTE PTR [rcx-0x1],dl
   18179ec42:	4c 39 c9             	cmp    rcx,r9
   18179ec45:	48 8d 49 01          	lea    rcx,[rcx+0x1]
   18179ec49:	72 e5                	jb     0x18179ec30
   18179ec4b:	48 89 85 00 01 00 00 	mov    QWORD PTR [rbp+0x100],rax
   18179ec52:	48 83 bd 18 04 00 00 	cmp    QWORD PTR [rbp+0x418],0x10
   18179ec59:	10 
   18179ec5a:	72 07                	jb     0x18179ec63
   18179ec5c:	48 8b b5 00 04 00 00 	mov    rsi,QWORD PTR [rbp+0x400]
   18179ec63:	48 89 b5 50 02 00 00 	mov    QWORD PTR [rbp+0x250],rsi
   18179ec6a:	c6 85 58 02 00 00 00 	mov    BYTE PTR [rbp+0x258],0x0
   18179ec71:	0f 57 c0             	xorps  xmm0,xmm0
   18179ec74:	0f 11 85 c8 03 00 00 	movups XMMWORD PTR [rbp+0x3c8],xmm0
   18179ec7b:	0f 11 85 b8 03 00 00 	movups XMMWORD PTR [rbp+0x3b8],xmm0
   18179ec82:	0f 11 85 a8 03 00 00 	movups XMMWORD PTR [rbp+0x3a8],xmm0
   18179ec89:	0f 11 85 98 03 00 00 	movups XMMWORD PTR [rbp+0x398],xmm0
   18179ec90:	0f 11 85 88 03 00 00 	movups XMMWORD PTR [rbp+0x388],xmm0
   18179ec97:	0f 11 85 78 03 00 00 	movups XMMWORD PTR [rbp+0x378],xmm0
   18179ec9e:	48 c7 85 d8 03 00 00 	mov    QWORD PTR [rbp+0x3d8],0x0
   18179eca5:	00 00 00 00 
   18179eca9:	48 8d 85 50 02 00 00 	lea    rax,[rbp+0x250]
   18179ecb0:	48 89 85 60 03 00 00 	mov    QWORD PTR [rbp+0x360],rax
   18179ecb7:	48 8d 85 00 01 00 00 	lea    rax,[rbp+0x100]
   18179ecbe:	48 89 85 68 03 00 00 	mov    QWORD PTR [rbp+0x368],rax
   18179ecc5:	48 8d 85 d0 01 00 00 	lea    rax,[rbp+0x1d0]
   18179eccc:	48 89 85 70 03 00 00 	mov    QWORD PTR [rbp+0x370],rax
   18179ecd3:	48 8d 15 56 05 94 07 	lea    rdx,[rip+0x7940556]        # 0x1890df230
   18179ecda:	48 8d 8d d0 02 00 00 	lea    rcx,[rbp+0x2d0]
   18179ece1:	4c 8d 85 60 03 00 00 	lea    r8,[rbp+0x360]
   18179ece8:	e8 23 eb 8c fe       	call   0x18006d810
   18179eced:	90                   	nop
   18179ecee:	48 8d 8d d0 02 00 00 	lea    rcx,[rbp+0x2d0]
   18179ecf5:	e8 76 e6 8c fe       	call   0x18006d370
   18179ecfa:	48 8b 85 88 01 00 00 	mov    rax,QWORD PTR [rbp+0x188]
   18179ed01:	48 83 f8 10          	cmp    rax,0x10
   18179ed05:	72 38                	jb     0x18179ed3f
   18179ed07:	48 8b 8d 70 01 00 00 	mov    rcx,QWORD PTR [rbp+0x170]
   18179ed0e:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18179ed12:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18179ed19:	72 1f                	jb     0x18179ed3a
   18179ed1b:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18179ed1f:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18179ed23:	4c 29 c1             	sub    rcx,r8
   18179ed26:	48 83 f9 20          	cmp    rcx,0x20
   18179ed2a:	0f 83 01 15 00 00    	jae    0x1817a0231
   18179ed30:	48 83 c0 28          	add    rax,0x28
   18179ed34:	48 89 c2             	mov    rdx,rax
   18179ed37:	4c 89 c1             	mov    rcx,r8
   18179ed3a:	e8 a1 cb d0 05       	call   0x1874ab8e0
   18179ed3f:	c7 85 70 01 00 00 ff 	mov    DWORD PTR [rbp+0x170],0xffffffff
   18179ed46:	ff ff ff 
   18179ed49:	0f 11 b5 74 01 00 00 	movups XMMWORD PTR [rbp+0x174],xmm6
   18179ed50:	0f 11 b5 84 01 00 00 	movups XMMWORD PTR [rbp+0x184],xmm6
   18179ed57:	0f 11 b5 94 01 00 00 	movups XMMWORD PTR [rbp+0x194],xmm6
   18179ed5e:	0f 11 b5 a0 01 00 00 	movups XMMWORD PTR [rbp+0x1a0],xmm6
   18179ed65:	c7 85 d0 02 00 00 00 	mov    DWORD PTR [rbp+0x2d0],0x0
   18179ed6c:	00 00 00 
   18179ed6f:	48 8d 8d 70 01 00 00 	lea    rcx,[rbp+0x170]
   18179ed76:	48 8d 95 d0 02 00 00 	lea    rdx,[rbp+0x2d0]
   18179ed7d:	4c 8d 85 60 03 00 00 	lea    r8,[rbp+0x360]
   18179ed84:	e8 c7 72 0a 00       	call   0x181846050
   18179ed89:	90                   	nop
   18179ed8a:	48 8b b5 30 02 00 00 	mov    rsi,QWORD PTR [rbp+0x230]
   18179ed91:	4c 8b b5 38 02 00 00 	mov    r14,QWORD PTR [rbp+0x238]
   18179ed98:	48 8d bd 70 01 00 00 	lea    rdi,[rbp+0x170]
   18179ed9f:	48 8d 9d d0 02 00 00 	lea    rbx,[rbp+0x2d0]
   18179eda6:	4c 39 f6             	cmp    rsi,r14
   18179eda9:	74 38                	je     0x18179ede3
   18179edab:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]
   18179edb0:	4c 8d 86 c8 02 00 00 	lea    r8,[rsi+0x2c8]
   18179edb7:	48 89 f9             	mov    rcx,rdi
   18179edba:	48 89 da             	mov    rdx,rbx
   18179edbd:	e8 ee 73 0a 00       	call   0x1818461b0
   18179edc2:	90                   	nop
   18179edc3:	48 8b 8d d0 02 00 00 	mov    rcx,QWORD PTR [rbp+0x2d0]
   18179edca:	48 83 c1 30          	add    rcx,0x30
   18179edce:	48 89 f2             	mov    rdx,rsi
   18179edd1:	e8 fa 8a de ff       	call   0x1815878d0
   18179edd6:	90                   	nop
   18179edd7:	48 81 c6 e8 02 00 00 	add    rsi,0x2e8
   18179edde:	4c 39 f6             	cmp    rsi,r14
   18179ede1:	75 cd                	jne    0x18179edb0
   18179ede3:	4c 8b a5 b0 01 00 00 	mov    r12,QWORD PTR [rbp+0x1b0]
   18179edea:	48 8b 8d b8 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1b8]
   18179edf1:	48 89 c8             	mov    rax,rcx
   18179edf4:	4c 29 e0             	sub    rax,r12
   18179edf7:	48 c1 f8 04          	sar    rax,0x4
   18179edfb:	0f 57 ff             	xorps  xmm7,xmm7
   18179edfe:	0f 29 bd 20 04 00 00 	movaps XMMWORD PTR [rbp+0x420],xmm7
   18179ee05:	48 c7 85 30 04 00 00 	mov    QWORD PTR [rbp+0x430],0x0
   18179ee0c:	00 00 00 00 
   18179ee10:	48 89 85 d0 02 00 00 	mov    QWORD PTR [rbp+0x2d0],rax
   18179ee17:	48 89 8d c8 01 00 00 	mov    QWORD PTR [rbp+0x1c8],rcx
   18179ee1e:	4c 39 e1             	cmp    rcx,r12
   18179ee21:	49 be cd cc cc cc cc 	movabs r14,0xcccccccccccccccd
   18179ee28:	cc cc cc 
   18179ee2b:	74 3c                	je     0x18179ee69
   18179ee2d:	48 b9 34 33 33 33 33 	movabs rcx,0x333333333333334
   18179ee34:	33 33 03 
   18179ee37:	48 39 c8             	cmp    rax,rcx
   18179ee3a:	0f 83 0f 14 00 00    	jae    0x1817a024f
   18179ee40:	48 8d 8d 20 04 00 00 	lea    rcx,[rbp+0x420]
   18179ee47:	48 8d 95 d0 02 00 00 	lea    rdx,[rbp+0x2d0]
   18179ee4e:	e8 8d 79 0a 00       	call   0x1818467e0
   18179ee53:	90                   	nop
   18179ee54:	4c 8b a5 b0 01 00 00 	mov    r12,QWORD PTR [rbp+0x1b0]
   18179ee5b:	48 8b 85 b8 01 00 00 	mov    rax,QWORD PTR [rbp+0x1b8]
   18179ee62:	48 89 85 c8 01 00 00 	mov    QWORD PTR [rbp+0x1c8],rax
   18179ee69:	b0 01                	mov    al,0x1
   18179ee6b:	89 85 a4 02 00 00    	mov    DWORD PTR [rbp+0x2a4],eax
   18179ee71:	49 bf b3 01 00 00 00 	movabs r15,0x100000001b3
   18179ee78:	01 00 00 
   18179ee7b:	eb 07                	jmp    0x18179ee84
   18179ee7d:	0f 1f 00             	nop    DWORD PTR [rax]
   18179ee80:	49 83 c4 10          	add    r12,0x10
   18179ee84:	4c 3b a5 c8 01 00 00 	cmp    r12,QWORD PTR [rbp+0x1c8]
   18179ee8b:	0f 84 af 06 00 00    	je     0x18179f540
   18179ee91:	0f 29 b5 a0 00 00 00 	movaps XMMWORD PTR [rbp+0xa0],xmm6
   18179ee98:	49 8b 04 24          	mov    rax,QWORD PTR [r12]
   18179ee9c:	48 8b 48 20          	mov    rcx,QWORD PTR [rax+0x20]
   18179eea0:	48 85 c9             	test   rcx,rcx
   18179eea3:	74 0b                	je     0x18179eeb0
   18179eea5:	f0 ff 41 08          	lock inc DWORD PTR [rcx+0x8]
   18179eea9:	48 8b 70 20          	mov    rsi,QWORD PTR [rax+0x20]
   18179eead:	eb 03                	jmp    0x18179eeb2
   18179eeaf:	90                   	nop
   18179eeb0:	31 f6                	xor    esi,esi
   18179eeb2:	4c 8b 68 18          	mov    r13,QWORD PTR [rax+0x18]
   18179eeb6:	4c 89 ad a0 00 00 00 	mov    QWORD PTR [rbp+0xa0],r13
   18179eebd:	48 89 b5 a8 00 00 00 	mov    QWORD PTR [rbp+0xa8],rsi
   18179eec4:	4d 85 ed             	test   r13,r13
   18179eec7:	0f 84 65 04 00 00    	je     0x18179f332
   18179eecd:	49 8d b5 c8 02 00 00 	lea    rsi,[r13+0x2c8]
   18179eed4:	49 83 bd e0 02 00 00 	cmp    QWORD PTR [r13+0x2e0],0x10
   18179eedb:	10 
   18179eedc:	72 07                	jb     0x18179eee5
   18179eede:	49 8b b5 c8 02 00 00 	mov    rsi,QWORD PTR [r13+0x2c8]
   18179eee5:	4c 89 a5 a8 02 00 00 	mov    QWORD PTR [rbp+0x2a8],r12
   18179eeec:	49 8b 9d d8 02 00 00 	mov    rbx,QWORD PTR [r13+0x2d8]
   18179eef3:	48 b9 25 23 22 84 e4 	movabs rcx,0xcbf29ce484222325
   18179eefa:	9c f2 cb 
   18179eefd:	48 85 db             	test   rbx,rbx
   18179ef00:	0f 84 7e 00 00 00    	je     0x18179ef84
   18179ef06:	89 d8                	mov    eax,ebx
   18179ef08:	83 e0 03             	and    eax,0x3
   18179ef0b:	48 83 fb 04          	cmp    rbx,0x4
   18179ef0f:	73 04                	jae    0x18179ef15
   18179ef11:	31 d2                	xor    edx,edx
   18179ef13:	eb 4b                	jmp    0x18179ef60
   18179ef15:	49 89 d8             	mov    r8,rbx
   18179ef18:	49 83 e0 fc          	and    r8,0xfffffffffffffffc
   18179ef1c:	31 d2                	xor    edx,edx
   18179ef1e:	66 90                	xchg   ax,ax
   18179ef20:	44 0f b6 0c 16       	movzx  r9d,BYTE PTR [rsi+rdx*1]
   18179ef25:	4c 31 c9             	xor    rcx,r9
   18179ef28:	49 0f af cf          	imul   rcx,r15
   18179ef2c:	44 0f b6 4c 16 01    	movzx  r9d,BYTE PTR [rsi+rdx*1+0x1]
   18179ef32:	49 31 c9             	xor    r9,rcx
   18179ef35:	4d 0f af cf          	imul   r9,r15
   18179ef39:	44 0f b6 54 16 02    	movzx  r10d,BYTE PTR [rsi+rdx*1+0x2]
   18179ef3f:	4d 31 ca             	xor    r10,r9
   18179ef42:	4d 0f af d7          	imul   r10,r15
   18179ef46:	0f b6 4c 16 03       	movzx  ecx,BYTE PTR [rsi+rdx*1+0x3]
   18179ef4b:	4c 31 d1             	xor    rcx,r10
   18179ef4e:	49 0f af cf          	imul   rcx,r15
   18179ef52:	48 83 c2 04          	add    rdx,0x4
   18179ef56:	49 39 d0             	cmp    r8,rdx
   18179ef59:	75 c5                	jne    0x18179ef20
   18179ef5b:	48 85 c0             	test   rax,rax
   18179ef5e:	74 24                	je     0x18179ef84
   18179ef60:	48 01 f2             	add    rdx,rsi
   18179ef63:	45 31 c0             	xor    r8d,r8d
   18179ef66:	66 2e 0f 1f 84 00 00 	cs nop WORD PTR [rax+rax*1+0x0]
   18179ef6d:	00 00 00 
   18179ef70:	46 0f b6 0c 02       	movzx  r9d,BYTE PTR [rdx+r8*1]
   18179ef75:	4c 31 c9             	xor    rcx,r9
   18179ef78:	49 0f af cf          	imul   rcx,r15
   18179ef7c:	49 ff c0             	inc    r8
   18179ef7f:	4c 39 c0             	cmp    rax,r8
   18179ef82:	75 ec                	jne    0x18179ef70
   18179ef84:	48 23 8d a0 01 00 00 	and    rcx,QWORD PTR [rbp+0x1a0]
   18179ef8b:	4c 8b a5 78 01 00 00 	mov    r12,QWORD PTR [rbp+0x178]
   18179ef92:	48 8b 85 88 01 00 00 	mov    rax,QWORD PTR [rbp+0x188]
   18179ef99:	48 c1 e1 04          	shl    rcx,0x4
   18179ef9d:	4c 8b 74 08 08       	mov    r14,QWORD PTR [rax+rcx*1+0x8]
   18179efa2:	4d 39 e6             	cmp    r14,r12
   18179efa5:	0f 84 55 01 00 00    	je     0x18179f100
   18179efab:	48 8b 3c 08          	mov    rdi,QWORD PTR [rax+rcx*1]
   18179efaf:	48 85 db             	test   rbx,rbx
   18179efb2:	74 60                	je     0x18179f014
   18179efb4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
   18179efbb:	00 00 00 00 00 
   18179efc0:	49 3b 5e 20          	cmp    rbx,QWORD PTR [r14+0x20]
   18179efc4:	75 2d                	jne    0x18179eff3
   18179efc6:	49 83 7e 28 10       	cmp    QWORD PTR [r14+0x28],0x10
   18179efcb:	72 13                	jb     0x18179efe0
   18179efcd:	49 8b 56 10          	mov    rdx,QWORD PTR [r14+0x10]
   18179efd1:	eb 11                	jmp    0x18179efe4
   18179efd3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
   18179efda:	84 00 00 00 00 00 
   18179efe0:	49 8d 56 10          	lea    rdx,[r14+0x10]
   18179efe4:	48 89 f1             	mov    rcx,rsi
   18179efe7:	49 89 d8             	mov    r8,rbx
   18179efea:	e8 61 4f da 05       	call   0x187543f50
   18179efef:	85 c0                	test   eax,eax
   18179eff1:	74 32                	je     0x18179f025
   18179eff3:	49 39 fe             	cmp    r14,rdi
   18179eff6:	0f 84 04 01 00 00    	je     0x18179f100
   18179effc:	4d 8b 76 08          	mov    r14,QWORD PTR [r14+0x8]
   18179f000:	49 3b 5e 20          	cmp    rbx,QWORD PTR [r14+0x20]
   18179f004:	74 c0                	je     0x18179efc6
   18179f006:	eb eb                	jmp    0x18179eff3
   18179f008:	0f 1f 84 00 00 00 00 	nop    DWORD PTR [rax+rax*1+0x0]
   18179f00f:	00 
   18179f010:	4d 8b 76 08          	mov    r14,QWORD PTR [r14+0x8]
   18179f014:	49 83 7e 20 00       	cmp    QWORD PTR [r14+0x20],0x0
   18179f019:	74 0a                	je     0x18179f025
   18179f01b:	49 39 fe             	cmp    r14,rdi
   18179f01e:	75 f0                	jne    0x18179f010
   18179f020:	e9 db 00 00 00       	jmp    0x18179f100
   18179f025:	4d 39 e6             	cmp    r14,r12
   18179f028:	0f 84 d2 00 00 00    	je     0x18179f100
   18179f02e:	4d 85 f6             	test   r14,r14
   18179f031:	0f 84 c9 00 00 00    	je     0x18179f100
   18179f037:	48 85 db             	test   rbx,rbx
   18179f03a:	0f 84 c0 00 00 00    	je     0x18179f100
   18179f040:	41 83 be 74 01 00 00 	cmp    DWORD PTR [r14+0x174],0x0
   18179f047:	00 
   18179f048:	0f 84 b2 00 00 00    	je     0x18179f100
   18179f04e:	0f 29 b5 60 03 00 00 	movaps XMMWORD PTR [rbp+0x360],xmm6
   18179f055:	b9 f8 02 00 00       	mov    ecx,0x2f8
   18179f05a:	e8 3d c8 d0 05       	call   0x1874ab89c
   18179f05f:	90                   	nop
   18179f060:	4c 8b a5 a8 02 00 00 	mov    r12,QWORD PTR [rbp+0x2a8]
   18179f067:	48 89 c1             	mov    rcx,rax
   18179f06a:	49 83 c6 30          	add    r14,0x30
   18179f06e:	48 b8 01 00 00 00 01 	movabs rax,0x100000001
   18179f075:	00 00 00 
   18179f078:	48 89 41 08          	mov    QWORD PTR [rcx+0x8],rax
   18179f07c:	48 8d 05 45 08 60 07 	lea    rax,[rip+0x7600845]        # 0x188d9f8c8
   18179f083:	48 89 01             	mov    QWORD PTR [rcx],rax
   18179f086:	48 89 8d f8 00 00 00 	mov    QWORD PTR [rbp+0xf8],rcx
   18179f08d:	48 8d 59 10          	lea    rbx,[rcx+0x10]
   18179f091:	48 89 d9             	mov    rcx,rbx
   18179f094:	4c 89 f2             	mov    rdx,r14
   18179f097:	e8 44 52 a2 fe       	call   0x1801c42e0
   18179f09c:	90                   	nop
   18179f09d:	48 89 9d 60 03 00 00 	mov    QWORD PTR [rbp+0x360],rbx
   18179f0a4:	48 8b 8d f8 00 00 00 	mov    rcx,QWORD PTR [rbp+0xf8]
   18179f0ab:	48 89 8d 68 03 00 00 	mov    QWORD PTR [rbp+0x368],rcx
   18179f0b2:	49 8b 04 24          	mov    rax,QWORD PTR [r12]
   18179f0b6:	40 b7 01             	mov    dil,0x1
   18179f0b9:	48 85 c9             	test   rcx,rcx
   18179f0bc:	49 be cd cc cc cc cc 	movabs r14,0xcccccccccccccccd
   18179f0c3:	cc cc cc 
   18179f0c6:	0f 84 99 02 00 00    	je     0x18179f365
   18179f0cc:	f0 ff 41 08          	lock inc DWORD PTR [rcx+0x8]
   18179f0d0:	48 8b 9d 60 03 00 00 	mov    rbx,QWORD PTR [rbp+0x360]
   18179f0d7:	48 8b b5 68 03 00 00 	mov    rsi,QWORD PTR [rbp+0x368]
   18179f0de:	48 85 f6             	test   rsi,rsi
   18179f0e1:	0f 84 7e 02 00 00    	je     0x18179f365
   18179f0e7:	f0 ff 46 08          	lock inc DWORD PTR [rsi+0x8]
   18179f0eb:	31 ff                	xor    edi,edi
   18179f0ed:	e9 75 02 00 00       	jmp    0x18179f367
   18179f0f2:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
   18179f0f9:	1f 84 00 00 00 00 00 
   18179f100:	b9 04 00 00 00       	mov    ecx,0x4
   18179f105:	e8 d6 dc 8c fe       	call   0x18006cde0
   18179f10a:	85 c0                	test   eax,eax
   18179f10c:	0f 84 fe 01 00 00    	je     0x18179f310
   18179f112:	48 8d b5 50 01 00 00 	lea    rsi,[rbp+0x150]
   18179f119:	48 89 f1             	mov    rcx,rsi
   18179f11c:	e8 ef dd 8c fe       	call   0x18006cf10
   18179f121:	90                   	nop
   18179f122:	4c 8b a5 a8 02 00 00 	mov    r12,QWORD PTR [rbp+0x2a8]
   18179f129:	48 83 bd 68 01 00 00 	cmp    QWORD PTR [rbp+0x168],0x10
   18179f130:	10 
   18179f131:	49 89 f0             	mov    r8,rsi
   18179f134:	48 8d b5 e0 03 00 00 	lea    rsi,[rbp+0x3e0]
   18179f13b:	49 8d bd c8 02 00 00 	lea    rdi,[r13+0x2c8]
   18179f142:	72 07                	jb     0x18179f14b
   18179f144:	4c 8b 85 50 01 00 00 	mov    r8,QWORD PTR [rbp+0x150]
   18179f14b:	48 8d 05 8e f1 93 07 	lea    rax,[rip+0x793f18e]        # 0x1890de2e0
   18179f152:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   18179f157:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   18179f15e:	00 00 
   18179f160:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   18179f165:	c7 44 24 28 37 03 00 	mov    DWORD PTR [rsp+0x28],0x337
   18179f16c:	00 
   18179f16d:	48 8d 8d d0 02 00 00 	lea    rcx,[rbp+0x2d0]
   18179f174:	ba 04 00 00 00       	mov    edx,0x4
   18179f179:	4c 8d 0d 78 cc 93 07 	lea    r9,[rip+0x793cc78]        # 0x1890dbdf8
   18179f180:	e8 eb e0 8c fe       	call   0x18006d270
   18179f185:	90                   	nop
   18179f186:	49 83 bd e0 02 00 00 	cmp    QWORD PTR [r13+0x2e0],0x10
   18179f18d:	10 
   18179f18e:	72 07                	jb     0x18179f197
   18179f190:	49 8b bd c8 02 00 00 	mov    rdi,QWORD PTR [r13+0x2c8]
   18179f197:	48 89 bd d0 01 00 00 	mov    QWORD PTR [rbp+0x1d0],rdi
   18179f19e:	c6 85 d8 01 00 00 00 	mov    BYTE PTR [rbp+0x1d8],0x0
   18179f1a5:	48 83 bd 18 04 00 00 	cmp    QWORD PTR [rbp+0x418],0x10
   18179f1ac:	10 
   18179f1ad:	48 8d 85 00 04 00 00 	lea    rax,[rbp+0x400]
   18179f1b4:	49 be cd cc cc cc cc 	movabs r14,0xcccccccccccccccd
   18179f1bb:	cc cc cc 
   18179f1be:	72 07                	jb     0x18179f1c7
   18179f1c0:	48 8b 85 00 04 00 00 	mov    rax,QWORD PTR [rbp+0x400]
   18179f1c7:	48 89 85 00 01 00 00 	mov    QWORD PTR [rbp+0x100],rax
   18179f1ce:	c6 85 08 01 00 00 00 	mov    BYTE PTR [rbp+0x108],0x0
   18179f1d5:	49 8b 0c 24          	mov    rcx,QWORD PTR [r12]
   18179f1d9:	48 89 f2             	mov    rdx,rsi
   18179f1dc:	e8 ef 64 1e 02       	call   0x1839856d0
   18179f1e1:	90                   	nop
   18179f1e2:	48 83 bd f8 03 00 00 	cmp    QWORD PTR [rbp+0x3f8],0x10
   18179f1e9:	10 
   18179f1ea:	72 07                	jb     0x18179f1f3
   18179f1ec:	48 8b b5 e0 03 00 00 	mov    rsi,QWORD PTR [rbp+0x3e0]
   18179f1f3:	48 89 b5 50 02 00 00 	mov    QWORD PTR [rbp+0x250],rsi
   18179f1fa:	c6 85 58 02 00 00 00 	mov    BYTE PTR [rbp+0x258],0x0
   18179f201:	48 8d 85 78 03 00 00 	lea    rax,[rbp+0x378]
   18179f208:	0f 11 78 50          	movups XMMWORD PTR [rax+0x50],xmm7
   18179f20c:	0f 11 78 40          	movups XMMWORD PTR [rax+0x40],xmm7
   18179f210:	0f 11 78 30          	movups XMMWORD PTR [rax+0x30],xmm7
   18179f214:	0f 11 78 20          	movups XMMWORD PTR [rax+0x20],xmm7
   18179f218:	0f 11 78 10          	movups XMMWORD PTR [rax+0x10],xmm7
   18179f21c:	0f 11 38             	movups XMMWORD PTR [rax],xmm7
   18179f21f:	48 c7 40 60 00 00 00 	mov    QWORD PTR [rax+0x60],0x0
   18179f226:	00 
   18179f227:	48 8d 85 50 02 00 00 	lea    rax,[rbp+0x250]
   18179f22e:	48 89 85 60 03 00 00 	mov    QWORD PTR [rbp+0x360],rax
   18179f235:	48 8d 85 00 01 00 00 	lea    rax,[rbp+0x100]
   18179f23c:	48 89 85 68 03 00 00 	mov    QWORD PTR [rbp+0x368],rax
   18179f243:	48 8d 85 d0 01 00 00 	lea    rax,[rbp+0x1d0]
   18179f24a:	48 89 85 70 03 00 00 	mov    QWORD PTR [rbp+0x370],rax
   18179f251:	48 8d 8d d0 02 00 00 	lea    rcx,[rbp+0x2d0]
   18179f258:	48 8d 15 31 e4 93 07 	lea    rdx,[rip+0x793e431]        # 0x1890dd690
   18179f25f:	4c 8d 85 60 03 00 00 	lea    r8,[rbp+0x360]
   18179f266:	e8 a5 e5 8c fe       	call   0x18006d810
   18179f26b:	90                   	nop
   18179f26c:	48 8b 85 f8 03 00 00 	mov    rax,QWORD PTR [rbp+0x3f8]
   18179f273:	48 83 f8 10          	cmp    rax,0x10
   18179f277:	72 38                	jb     0x18179f2b1
   18179f279:	48 8b 8d e0 03 00 00 	mov    rcx,QWORD PTR [rbp+0x3e0]
   18179f280:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18179f284:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18179f28b:	72 1f                	jb     0x18179f2ac
   18179f28d:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18179f291:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18179f295:	4c 29 c1             	sub    rcx,r8
   18179f298:	48 83 f9 20          	cmp    rcx,0x20
   18179f29c:	0f 83 8f 0f 00 00    	jae    0x1817a0231
   18179f2a2:	48 83 c0 28          	add    rax,0x28
   18179f2a6:	48 89 c2             	mov    rdx,rax
   18179f2a9:	4c 89 c1             	mov    rcx,r8
   18179f2ac:	e8 2f c6 d0 05       	call   0x1874ab8e0
   18179f2b1:	48 8d 8d d0 02 00 00 	lea    rcx,[rbp+0x2d0]
   18179f2b8:	e8 b3 e0 8c fe       	call   0x18006d370
   18179f2bd:	48 8b 85 68 01 00 00 	mov    rax,QWORD PTR [rbp+0x168]
   18179f2c4:	48 83 f8 10          	cmp    rax,0x10
   18179f2c8:	72 38                	jb     0x18179f302
   18179f2ca:	48 8b 8d 50 01 00 00 	mov    rcx,QWORD PTR [rbp+0x150]
   18179f2d1:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18179f2d5:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18179f2dc:	72 1f                	jb     0x18179f2fd
   18179f2de:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18179f2e2:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18179f2e6:	4c 29 c1             	sub    rcx,r8
   18179f2e9:	48 83 f9 20          	cmp    rcx,0x20
   18179f2ed:	0f 83 3e 0f 00 00    	jae    0x1817a0231
   18179f2f3:	48 83 c0 28          	add    rax,0x28
   18179f2f7:	48 89 c2             	mov    rdx,rax
   18179f2fa:	4c 89 c1             	mov    rcx,r8
   18179f2fd:	e8 de c5 d0 05       	call   0x1874ab8e0
   18179f302:	c7 85 a4 02 00 00 00 	mov    DWORD PTR [rbp+0x2a4],0x0
   18179f309:	00 00 00 
   18179f30c:	eb 1d                	jmp    0x18179f32b
   18179f30e:	66 90                	xchg   ax,ax
   18179f310:	c7 85 a4 02 00 00 00 	mov    DWORD PTR [rbp+0x2a4],0x0
   18179f317:	00 00 00 
   18179f31a:	49 be cd cc cc cc cc 	movabs r14,0xcccccccccccccccd
   18179f321:	cc cc cc 
   18179f324:	4c 8b a5 a8 02 00 00 	mov    r12,QWORD PTR [rbp+0x2a8]
   18179f32b:	48 8b b5 a8 00 00 00 	mov    rsi,QWORD PTR [rbp+0xa8]
   18179f332:	48 85 f6             	test   rsi,rsi
   18179f335:	0f 84 45 fb ff ff    	je     0x18179ee80
   18179f33b:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   18179f33f:	0f 85 3b fb ff ff    	jne    0x18179ee80
   18179f345:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   18179f348:	48 89 f1             	mov    rcx,rsi
   18179f34b:	ff 10                	call   QWORD PTR [rax]
   18179f34d:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   18179f351:	0f 85 29 fb ff ff    	jne    0x18179ee80
   18179f357:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   18179f35a:	48 89 f1             	mov    rcx,rsi
   18179f35d:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18179f360:	e9 1b fb ff ff       	jmp    0x18179ee80
   18179f365:	31 f6                	xor    esi,esi
   18179f367:	48 89 58 18          	mov    QWORD PTR [rax+0x18],rbx
   18179f36b:	48 8b 58 20          	mov    rbx,QWORD PTR [rax+0x20]
   18179f36f:	48 89 70 20          	mov    QWORD PTR [rax+0x20],rsi
   18179f373:	48 85 db             	test   rbx,rbx
   18179f376:	74 1d                	je     0x18179f395
   18179f378:	f0 ff 4b 08          	lock dec DWORD PTR [rbx+0x8]
   18179f37c:	75 17                	jne    0x18179f395
   18179f37e:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   18179f381:	48 89 d9             	mov    rcx,rbx
   18179f384:	ff 10                	call   QWORD PTR [rax]
   18179f386:	f0 ff 4b 0c          	lock dec DWORD PTR [rbx+0xc]
   18179f38a:	75 09                	jne    0x18179f395
   18179f38c:	48 8b 03             	mov    rax,QWORD PTR [rbx]
   18179f38f:	48 89 d9             	mov    rcx,rbx
   18179f392:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18179f395:	40 84 ff             	test   dil,dil
   18179f398:	75 1d                	jne    0x18179f3b7
   18179f39a:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   18179f39e:	75 17                	jne    0x18179f3b7
   18179f3a0:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   18179f3a3:	48 89 f1             	mov    rcx,rsi
   18179f3a6:	ff 10                	call   QWORD PTR [rax]
   18179f3a8:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   18179f3ac:	75 09                	jne    0x18179f3b7
   18179f3ae:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   18179f3b1:	48 89 f1             	mov    rcx,rsi
   18179f3b4:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18179f3b7:	48 8b 95 60 03 00 00 	mov    rdx,QWORD PTR [rbp+0x360]
   18179f3be:	48 8d 8d d0 02 00 00 	lea    rcx,[rbp+0x2d0]
   18179f3c5:	e8 b6 e7 ad 00       	call   0x18227db80
   18179f3ca:	90                   	nop
   18179f3cb:	48 8b 95 28 04 00 00 	mov    rdx,QWORD PTR [rbp+0x428]
   18179f3d2:	48 3b 95 30 04 00 00 	cmp    rdx,QWORD PTR [rbp+0x430]
   18179f3d9:	0f 84 89 00 00 00    	je     0x18179f468
   18179f3df:	0f 11 7a 10          	movups XMMWORD PTR [rdx+0x10],xmm7
   18179f3e3:	0f 11 3a             	movups XMMWORD PTR [rdx],xmm7
   18179f3e6:	0f 10 85 d0 02 00 00 	movups xmm0,XMMWORD PTR [rbp+0x2d0]
   18179f3ed:	0f 10 8d e0 02 00 00 	movups xmm1,XMMWORD PTR [rbp+0x2e0]
   18179f3f4:	0f 11 4a 10          	movups XMMWORD PTR [rdx+0x10],xmm1
   18179f3f8:	0f 11 02             	movups XMMWORD PTR [rdx],xmm0
   18179f3fb:	48 c7 85 e0 02 00 00 	mov    QWORD PTR [rbp+0x2e0],0x0
   18179f402:	00 00 00 00 
   18179f406:	48 c7 85 e8 02 00 00 	mov    QWORD PTR [rbp+0x2e8],0xf
   18179f40d:	0f 00 00 00 
   18179f411:	c6 85 d0 02 00 00 00 	mov    BYTE PTR [rbp+0x2d0],0x0
   18179f418:	48 8d 85 f0 02 00 00 	lea    rax,[rbp+0x2f0]
   18179f41f:	0f 10 00             	movups xmm0,XMMWORD PTR [rax]
   18179f422:	0f 11 42 20          	movups XMMWORD PTR [rdx+0x20],xmm0
   18179f426:	0f 11 7a 40          	movups XMMWORD PTR [rdx+0x40],xmm7
   18179f42a:	0f 11 7a 30          	movups XMMWORD PTR [rdx+0x30],xmm7
   18179f42e:	0f 10 40 10          	movups xmm0,XMMWORD PTR [rax+0x10]
   18179f432:	0f 10 48 20          	movups xmm1,XMMWORD PTR [rax+0x20]
   18179f436:	0f 11 42 30          	movups XMMWORD PTR [rdx+0x30],xmm0
   18179f43a:	0f 11 4a 40          	movups XMMWORD PTR [rdx+0x40],xmm1
   18179f43e:	48 c7 85 10 03 00 00 	mov    QWORD PTR [rbp+0x310],0x0
   18179f445:	00 00 00 00 
   18179f449:	48 c7 85 18 03 00 00 	mov    QWORD PTR [rbp+0x318],0xf
   18179f450:	0f 00 00 00 
   18179f454:	c6 85 00 03 00 00 00 	mov    BYTE PTR [rbp+0x300],0x0
   18179f45b:	48 83 c2 50          	add    rdx,0x50
   18179f45f:	48 89 95 28 04 00 00 	mov    QWORD PTR [rbp+0x428],rdx
   18179f466:	eb 59                	jmp    0x18179f4c1
   18179f468:	48 8d 8d 20 04 00 00 	lea    rcx,[rbp+0x420]
   18179f46f:	4c 8d 85 d0 02 00 00 	lea    r8,[rbp+0x2d0]
   18179f476:	e8 75 3a e2 ff       	call   0x1815c2ef0
   18179f47b:	90                   	nop
   18179f47c:	48 8b 85 18 03 00 00 	mov    rax,QWORD PTR [rbp+0x318]
   18179f483:	48 83 f8 10          	cmp    rax,0x10
   18179f487:	72 38                	jb     0x18179f4c1
   18179f489:	48 8b 8d 00 03 00 00 	mov    rcx,QWORD PTR [rbp+0x300]
   18179f490:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18179f494:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18179f49b:	72 1f                	jb     0x18179f4bc
   18179f49d:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18179f4a1:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18179f4a5:	4c 29 c1             	sub    rcx,r8
   18179f4a8:	48 83 f9 20          	cmp    rcx,0x20
   18179f4ac:	0f 83 7f 0d 00 00    	jae    0x1817a0231
   18179f4b2:	48 83 c0 28          	add    rax,0x28
   18179f4b6:	48 89 c2             	mov    rdx,rax
   18179f4b9:	4c 89 c1             	mov    rcx,r8
   18179f4bc:	e8 1f c4 d0 05       	call   0x1874ab8e0
   18179f4c1:	48 8b 85 e8 02 00 00 	mov    rax,QWORD PTR [rbp+0x2e8]
   18179f4c8:	48 83 f8 10          	cmp    rax,0x10
   18179f4cc:	72 38                	jb     0x18179f506
   18179f4ce:	48 8b 8d d0 02 00 00 	mov    rcx,QWORD PTR [rbp+0x2d0]
   18179f4d5:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18179f4d9:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18179f4e0:	72 1f                	jb     0x18179f501
   18179f4e2:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18179f4e6:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18179f4ea:	4c 29 c1             	sub    rcx,r8
   18179f4ed:	48 83 f9 20          	cmp    rcx,0x20
   18179f4f1:	0f 83 3a 0d 00 00    	jae    0x1817a0231
   18179f4f7:	48 83 c0 28          	add    rax,0x28
   18179f4fb:	48 89 c2             	mov    rdx,rax
   18179f4fe:	4c 89 c1             	mov    rcx,r8
   18179f501:	e8 da c3 d0 05       	call   0x1874ab8e0
   18179f506:	48 8b b5 68 03 00 00 	mov    rsi,QWORD PTR [rbp+0x368]
   18179f50d:	48 85 f6             	test   rsi,rsi
   18179f510:	0f 84 15 fe ff ff    	je     0x18179f32b
   18179f516:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   18179f51a:	0f 85 0b fe ff ff    	jne    0x18179f32b
   18179f520:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   18179f523:	48 89 f1             	mov    rcx,rsi
   18179f526:	ff 10                	call   QWORD PTR [rax]
   18179f528:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   18179f52c:	0f 85 f9 fd ff ff    	jne    0x18179f32b
   18179f532:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   18179f535:	48 89 f1             	mov    rcx,rsi
   18179f538:	ff 50 08             	call   QWORD PTR [rax+0x8]
   18179f53b:	e9 eb fd ff ff       	jmp    0x18179f32b
   18179f540:	f6 85 a4 02 00 00 01 	test   BYTE PTR [rbp+0x2a4],0x1
   18179f547:	0f 84 b3 01 00 00    	je     0x18179f700
   18179f54d:	48 8b 85 20 04 00 00 	mov    rax,QWORD PTR [rbp+0x420]
   18179f554:	48 3b 85 28 04 00 00 	cmp    rax,QWORD PTR [rbp+0x428]
   18179f55b:	0f 84 9f 01 00 00    	je     0x18179f700
   18179f561:	48 8d 15 e8 5c 93 07 	lea    rdx,[rip+0x7935ce8]        # 0x1890d5250
   18179f568:	48 8d 8d b0 00 00 00 	lea    rcx,[rbp+0xb0]
   18179f56f:	45 31 c0             	xor    r8d,r8d
   18179f572:	e8 d9 a7 bc fe       	call   0x180369d50
   18179f577:	90                   	nop
   18179f578:	4c 8d bd 78 01 00 00 	lea    r15,[rbp+0x178]
   18179f57f:	48 8b 85 40 04 00 00 	mov    rax,QWORD PTR [rbp+0x440]
   18179f586:	48 8b 38             	mov    rdi,QWORD PTR [rax]
   18179f589:	80 7f 50 01          	cmp    BYTE PTR [rdi+0x50],0x1
   18179f58d:	0f 85 46 05 00 00    	jne    0x18179fad9
   18179f593:	48 8d 4f 38          	lea    rcx,[rdi+0x38]
   18179f597:	48 8d 85 20 04 00 00 	lea    rax,[rbp+0x420]
   18179f59e:	48 39 c1             	cmp    rcx,rax
   18179f5a1:	74 30                	je     0x18179f5d3
   18179f5a3:	e8 68 4c e2 ff       	call   0x1815c4210
   18179f5a8:	0f 28 85 20 04 00 00 	movaps xmm0,XMMWORD PTR [rbp+0x420]
   18179f5af:	0f 11 47 38          	movups XMMWORD PTR [rdi+0x38],xmm0
   18179f5b3:	48 8b 85 30 04 00 00 	mov    rax,QWORD PTR [rbp+0x430]
   18179f5ba:	48 89 47 48          	mov    QWORD PTR [rdi+0x48],rax
   18179f5be:	0f 57 c0             	xorps  xmm0,xmm0
   18179f5c1:	0f 29 85 20 04 00 00 	movaps XMMWORD PTR [rbp+0x420],xmm0
   18179f5c8:	48 c7 85 30 04 00 00 	mov    QWORD PTR [rbp+0x430],0x0
   18179f5cf:	00 00 00 00 
   18179f5d3:	b9 02 00 00 00       	mov    ecx,0x2
   18179f5d8:	e8 03 d8 8c fe       	call   0x18006cde0
   18179f5dd:	85 c0                	test   eax,eax
   18179f5df:	0f 84 72 08 00 00    	je     0x18179fe57
   18179f5e5:	48 8d b5 50 02 00 00 	lea    rsi,[rbp+0x250]
   18179f5ec:	48 89 f1             	mov    rcx,rsi
   18179f5ef:	e8 1c d9 8c fe       	call   0x18006cf10
   18179f5f4:	90                   	nop
   18179f5f5:	48 83 bd 68 02 00 00 	cmp    QWORD PTR [rbp+0x268],0x10
   18179f5fc:	10 
   18179f5fd:	72 07                	jb     0x18179f606
   18179f5ff:	48 8b b5 50 02 00 00 	mov    rsi,QWORD PTR [rbp+0x250]
   18179f606:	48 8d 05 d3 ec 93 07 	lea    rax,[rip+0x793ecd3]        # 0x1890de2e0
   18179f60d:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   18179f612:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   18179f619:	00 00 
   18179f61b:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   18179f620:	c7 44 24 28 48 03 00 	mov    DWORD PTR [rsp+0x28],0x348
   18179f627:	00 
   18179f628:	4c 8d 0d c9 c7 93 07 	lea    r9,[rip+0x793c7c9]        # 0x1890dbdf8
   18179f62f:	48 8d 8d d0 02 00 00 	lea    rcx,[rbp+0x2d0]
   18179f636:	ba 02 00 00 00       	mov    edx,0x2
   18179f63b:	49 89 f0             	mov    r8,rsi
   18179f63e:	e8 2d dc 8c fe       	call   0x18006d270
   18179f643:	90                   	nop
   18179f644:	48 8b 85 40 04 00 00 	mov    rax,QWORD PTR [rbp+0x440]
   18179f64b:	48 8b 00             	mov    rax,QWORD PTR [rax]
   18179f64e:	48 8b 50 28          	mov    rdx,QWORD PTR [rax+0x28]
   18179f652:	48 2b 50 20          	sub    rdx,QWORD PTR [rax+0x20]
   18179f656:	48 c1 fa 04          	sar    rdx,0x4
   18179f65a:	49 0f af d6          	imul   rdx,r14
   18179f65e:	48 8d b5 d0 01 00 00 	lea    rsi,[rbp+0x1d0]
   18179f665:	48 89 f1             	mov    rcx,rsi
   18179f668:	41 b0 0a             	mov    r8b,0xa
   18179f66b:	e8 40 b2 8e fe       	call   0x18008a8b0
   18179f670:	90                   	nop
   18179f671:	48 8b 85 40 04 00 00 	mov    rax,QWORD PTR [rbp+0x440]
   18179f678:	48 8b 00             	mov    rax,QWORD PTR [rax]
   18179f67b:	48 8b 50 40          	mov    rdx,QWORD PTR [rax+0x40]
   18179f67f:	48 2b 50 38          	sub    rdx,QWORD PTR [rax+0x38]
   18179f683:	48 c1 fa 04          	sar    rdx,0x4
   18179f687:	49 0f af d6          	imul   rdx,r14
   18179f68b:	48 8d bd 00 01 00 00 	lea    rdi,[rbp+0x100]
   18179f692:	48 89 f9             	mov    rcx,rdi
   18179f695:	41 b0 0a             	mov    r8b,0xa
   18179f698:	e8 13 b2 8e fe       	call   0x18008a8b0
   18179f69d:	90                   	nop
   18179f69e:	0f 57 c0             	xorps  xmm0,xmm0
   18179f6a1:	0f 11 85 d0 03 00 00 	movups XMMWORD PTR [rbp+0x3d0],xmm0
   18179f6a8:	0f 11 85 c0 03 00 00 	movups XMMWORD PTR [rbp+0x3c0],xmm0
   18179f6af:	0f 11 85 b0 03 00 00 	movups XMMWORD PTR [rbp+0x3b0],xmm0
   18179f6b6:	0f 11 85 a0 03 00 00 	movups XMMWORD PTR [rbp+0x3a0],xmm0
   18179f6bd:	0f 11 85 90 03 00 00 	movups XMMWORD PTR [rbp+0x390],xmm0
   18179f6c4:	0f 11 85 80 03 00 00 	movups XMMWORD PTR [rbp+0x380],xmm0
   18179f6cb:	0f 11 85 70 03 00 00 	movups XMMWORD PTR [rbp+0x370],xmm0
   18179f6d2:	48 89 bd 60 03 00 00 	mov    QWORD PTR [rbp+0x360],rdi
   18179f6d9:	48 89 b5 68 03 00 00 	mov    QWORD PTR [rbp+0x368],rsi
   18179f6e0:	48 8d 15 99 ea 93 07 	lea    rdx,[rip+0x793ea99]        # 0x1890de180
   18179f6e7:	48 8d 8d d0 02 00 00 	lea    rcx,[rbp+0x2d0]
   18179f6ee:	4c 8d 85 60 03 00 00 	lea    r8,[rbp+0x360]
   18179f6f5:	e8 16 e1 8c fe       	call   0x18006d810
   18179f6fa:	90                   	nop
   18179f6fb:	e9 3f 07 00 00       	jmp    0x18179fe3f
   18179f700:	b9 04 00 00 00       	mov    ecx,0x4
   18179f705:	e8 d6 d6 8c fe       	call   0x18006cde0
   18179f70a:	85 c0                	test   eax,eax
   18179f70c:	4c 8d bd 78 01 00 00 	lea    r15,[rbp+0x178]
   18179f713:	0f 84 b0 02 00 00    	je     0x18179f9c9
   18179f719:	48 8d b5 50 01 00 00 	lea    rsi,[rbp+0x150]
   18179f720:	48 89 f1             	mov    rcx,rsi
   18179f723:	e8 e8 d7 8c fe       	call   0x18006cf10
   18179f728:	90                   	nop
   18179f729:	48 83 bd 68 01 00 00 	cmp    QWORD PTR [rbp+0x168],0x10
   18179f730:	10 
   18179f731:	72 07                	jb     0x18179f73a
   18179f733:	48 8b b5 50 01 00 00 	mov    rsi,QWORD PTR [rbp+0x150]
   18179f73a:	48 8d 05 9f eb 93 07 	lea    rax,[rip+0x793eb9f]        # 0x1890de2e0
   18179f741:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   18179f746:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   18179f74d:	00 00 
   18179f74f:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   18179f754:	c7 44 24 28 3c 03 00 	mov    DWORD PTR [rsp+0x28],0x33c
   18179f75b:	00 
   18179f75c:	4c 8d 0d 95 c6 93 07 	lea    r9,[rip+0x793c695]        # 0x1890dbdf8
   18179f763:	48 8d 8d d0 02 00 00 	lea    rcx,[rbp+0x2d0]
   18179f76a:	ba 04 00 00 00       	mov    edx,0x4
   18179f76f:	49 89 f0             	mov    r8,rsi
   18179f772:	e8 f9 da 8c fe       	call   0x18006d270
   18179f777:	90                   	nop
   18179f778:	48 8b 8d 28 04 00 00 	mov    rcx,QWORD PTR [rbp+0x428]
   18179f77f:	48 2b 8d 20 04 00 00 	sub    rcx,QWORD PTR [rbp+0x420]
   18179f786:	48 c1 f9 04          	sar    rcx,0x4
   18179f78a:	49 0f af ce          	imul   rcx,r14
   18179f78e:	48 c7 85 d0 01 00 00 	mov    QWORD PTR [rbp+0x1d0],0x0
   18179f795:	00 00 00 00 
   18179f799:	41 ba 07 00 00 00    	mov    r10d,0x7
   18179f79f:	4c 8d 8d d7 01 00 00 	lea    r9,[rbp+0x1d7]
   18179f7a6:	4c 8d 05 c3 6a 5a 07 	lea    r8,[rip+0x75a6ac3]        # 0x188d46270
   18179f7ad:	0f 1f 00             	nop    DWORD PTR [rax]
   18179f7b0:	48 89 c8             	mov    rax,rcx
   18179f7b3:	49 f7 e6             	mul    r14
   18179f7b6:	48 c1 ea 03          	shr    rdx,0x3
   18179f7ba:	48 8d 04 12          	lea    rax,[rdx+rdx*1]
   18179f7be:	48 8d 04 80          	lea    rax,[rax+rax*4]
   18179f7c2:	4d 89 c3             	mov    r11,r8
   18179f7c5:	49 29 c3             	sub    r11,rax
   18179f7c8:	41 0f b6 44 0b 23    	movzx  eax,BYTE PTR [r11+rcx*1+0x23]
   18179f7ce:	41 88 41 01          	mov    BYTE PTR [r9+0x1],al
   18179f7d2:	49 ff c1             	inc    r9
   18179f7d5:	49 ff c2             	inc    r10
   18179f7d8:	48 83 f9 09          	cmp    rcx,0x9
   18179f7dc:	48 89 d1             	mov    rcx,rdx
   18179f7df:	77 cf                	ja     0x18179f7b0
   18179f7e1:	48 8d 85 d8 01 00 00 	lea    rax,[rbp+0x1d8]
   18179f7e8:	41 c6 41 01 00       	mov    BYTE PTR [r9+0x1],0x0
   18179f7ed:	49 83 fa 09          	cmp    r10,0x9
   18179f7f1:	72 28                	jb     0x18179f81b
   18179f7f3:	48 8d 8d d9 01 00 00 	lea    rcx,[rbp+0x1d9]
   18179f7fa:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
   18179f800:	41 0f b6 11          	movzx  edx,BYTE PTR [r9]
   18179f804:	44 0f b6 51 ff       	movzx  r10d,BYTE PTR [rcx-0x1]
   18179f809:	45 88 11             	mov    BYTE PTR [r9],r10b
   18179f80c:	49 ff c9             	dec    r9
   18179f80f:	88 51 ff             	mov    BYTE PTR [rcx-0x1],dl
   18179f812:	4c 39 c9             	cmp    rcx,r9
   18179f815:	48 8d 49 01          	lea    rcx,[rcx+0x1]
   18179f819:	72 e5                	jb     0x18179f800
   18179f81b:	48 89 85 d0 01 00 00 	mov    QWORD PTR [rbp+0x1d0],rax
   18179f822:	48 8b 8d b8 02 00 00 	mov    rcx,QWORD PTR [rbp+0x2b8]
   18179f829:	48 2b 8d b0 02 00 00 	sub    rcx,QWORD PTR [rbp+0x2b0]
   18179f830:	48 c1 f9 03          	sar    rcx,0x3
   18179f834:	48 b8 f5 d3 4f 3f fd 	movabs rax,0x4fd3f4fd3f4fd3f5
   18179f83b:	f4 d3 4f 
   18179f83e:	48 0f af c8          	imul   rcx,rax
   18179f842:	48 c7 85 00 01 00 00 	mov    QWORD PTR [rbp+0x100],0x0
   18179f849:	00 00 00 00 
   18179f84d:	41 ba 07 00 00 00    	mov    r10d,0x7
   18179f853:	4c 8d 8d 07 01 00 00 	lea    r9,[rbp+0x107]
   18179f85a:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
   18179f860:	48 89 c8             	mov    rax,rcx
   18179f863:	49 f7 e6             	mul    r14
   18179f866:	48 c1 ea 03          	shr    rdx,0x3
   18179f86a:	48 8d 04 12          	lea    rax,[rdx+rdx*1]
   18179f86e:	48 8d 04 80          	lea    rax,[rax+rax*4]
   18179f872:	4d 89 c3             	mov    r11,r8
   18179f875:	49 29 c3             	sub    r11,rax
   18179f878:	41 0f b6 44 0b 23    	movzx  eax,BYTE PTR [r11+rcx*1+0x23]
   18179f87e:	41 88 41 01          	mov    BYTE PTR [r9+0x1],al
   18179f882:	49 ff c1             	inc    r9
   18179f885:	49 ff c2             	inc    r10
   18179f888:	48 83 f9 09          	cmp    rcx,0x9
   18179f88c:	48 89 d1             	mov    rcx,rdx
   18179f88f:	77 cf                	ja     0x18179f860
   18179f891:	48 8d 85 08 01 00 00 	lea    rax,[rbp+0x108]
   18179f898:	41 c6 41 01 00       	mov    BYTE PTR [r9+0x1],0x0
   18179f89d:	49 83 fa 09          	cmp    r10,0x9
   18179f8a1:	72 28                	jb     0x18179f8cb
   18179f8a3:	48 8d 8d 09 01 00 00 	lea    rcx,[rbp+0x109]
   18179f8aa:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
   18179f8b0:	41 0f b6 11          	movzx  edx,BYTE PTR [r9]
   18179f8b4:	44 0f b6 41 ff       	movzx  r8d,BYTE PTR [rcx-0x1]
   18179f8b9:	45 88 01             	mov    BYTE PTR [r9],r8b
   18179f8bc:	49 ff c9             	dec    r9
   18179f8bf:	88 51 ff             	mov    BYTE PTR [rcx-0x1],dl
   18179f8c2:	4c 39 c9             	cmp    rcx,r9
   18179f8c5:	48 8d 49 01          	lea    rcx,[rcx+0x1]
   18179f8c9:	72 e5                	jb     0x18179f8b0
   18179f8cb:	48 89 85 00 01 00 00 	mov    QWORD PTR [rbp+0x100],rax
   18179f8d2:	48 83 bd 18 04 00 00 	cmp    QWORD PTR [rbp+0x418],0x10
   18179f8d9:	10 
   18179f8da:	72 09                	jb     0x18179f8e5
   18179f8dc:	48 8b 85 00 04 00 00 	mov    rax,QWORD PTR [rbp+0x400]
   18179f8e3:	eb 07                	jmp    0x18179f8ec
   18179f8e5:	48 8d 85 00 04 00 00 	lea    rax,[rbp+0x400]
   18179f8ec:	48 89 85 50 02 00 00 	mov    QWORD PTR [rbp+0x250],rax
   18179f8f3:	c6 85 58 02 00 00 00 	mov    BYTE PTR [rbp+0x258],0x0
   18179f8fa:	0f 57 c0             	xorps  xmm0,xmm0
   18179f8fd:	0f 11 85 c8 03 00 00 	movups XMMWORD PTR [rbp+0x3c8],xmm0
   18179f904:	0f 11 85 b8 03 00 00 	movups XMMWORD PTR [rbp+0x3b8],xmm0
   18179f90b:	0f 11 85 a8 03 00 00 	movups XMMWORD PTR [rbp+0x3a8],xmm0
   18179f912:	0f 11 85 98 03 00 00 	movups XMMWORD PTR [rbp+0x398],xmm0
   18179f919:	0f 11 85 88 03 00 00 	movups XMMWORD PTR [rbp+0x388],xmm0
   18179f920:	0f 11 85 78 03 00 00 	movups XMMWORD PTR [rbp+0x378],xmm0
   18179f927:	48 c7 85 d8 03 00 00 	mov    QWORD PTR [rbp+0x3d8],0x0
   18179f92e:	00 00 00 00 
   18179f932:	48 8d 85 50 02 00 00 	lea    rax,[rbp+0x250]
   18179f939:	48 89 85 60 03 00 00 	mov    QWORD PTR [rbp+0x360],rax
   18179f940:	48 8d 85 00 01 00 00 	lea    rax,[rbp+0x100]
   18179f947:	48 89 85 68 03 00 00 	mov    QWORD PTR [rbp+0x368],rax
   18179f94e:	48 8d 85 d0 01 00 00 	lea    rax,[rbp+0x1d0]
   18179f955:	48 89 85 70 03 00 00 	mov    QWORD PTR [rbp+0x370],rax
   18179f95c:	48 8d 15 2d d1 93 07 	lea    rdx,[rip+0x793d12d]        # 0x1890dca90
   18179f963:	48 8d 8d d0 02 00 00 	lea    rcx,[rbp+0x2d0]
   18179f96a:	4c 8d 85 60 03 00 00 	lea    r8,[rbp+0x360]
   18179f971:	e8 9a de 8c fe       	call   0x18006d810
   18179f976:	90                   	nop
   18179f977:	48 8d 8d d0 02 00 00 	lea    rcx,[rbp+0x2d0]
   18179f97e:	e8 ed d9 8c fe       	call   0x18006d370
   18179f983:	48 8b 85 68 01 00 00 	mov    rax,QWORD PTR [rbp+0x168]
   18179f98a:	48 83 f8 10          	cmp    rax,0x10
   18179f98e:	72 39                	jb     0x18179f9c9
   18179f990:	48 8b 8d 50 01 00 00 	mov    rcx,QWORD PTR [rbp+0x150]
   18179f997:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18179f99b:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18179f9a2:	72 1f                	jb     0x18179f9c3
   18179f9a4:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18179f9a8:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18179f9ac:	4c 29 c1             	sub    rcx,r8
   18179f9af:	48 83 f9 20          	cmp    rcx,0x20
   18179f9b3:	0f 83 78 08 00 00    	jae    0x1817a0231
   18179f9b9:	48 83 c0 28          	add    rax,0x28
   18179f9bd:	48 89 c2             	mov    rdx,rax
   18179f9c0:	4c 89 c1             	mov    rcx,r8
   18179f9c3:	e8 18 bf d0 05       	call   0x1874ab8e0
   18179f9c8:	90                   	nop
   18179f9c9:	48 8d 8d d0 02 00 00 	lea    rcx,[rbp+0x2d0]
   18179f9d0:	ba 01 00 00 00       	mov    edx,0x1
   18179f9d5:	41 b8 01 00 00 00    	mov    r8d,0x1
   18179f9db:	e8 c0 83 1e 02       	call   0x183987da0
   18179f9e0:	90                   	nop
   18179f9e1:	4c 8b b5 28 02 00 00 	mov    r14,QWORD PTR [rbp+0x228]
   18179f9e8:	49 8b 76 28          	mov    rsi,QWORD PTR [r14+0x28]
   18179f9ec:	48 8d 95 d0 02 00 00 	lea    rdx,[rbp+0x2d0]
   18179f9f3:	48 89 f1             	mov    rcx,rsi
   18179f9f6:	e8 85 b3 09 00       	call   0x18183ad80
   18179f9fb:	90                   	nop
   18179f9fc:	48 8b 85 28 03 00 00 	mov    rax,QWORD PTR [rbp+0x328]
   18179fa03:	48 89 46 58          	mov    QWORD PTR [rsi+0x58],rax
   18179fa07:	41 c7 46 04 00 00 00 	mov    DWORD PTR [r14+0x4],0x0
   18179fa0e:	00 
   18179fa0f:	80 bd 20 03 00 00 00 	cmp    BYTE PTR [rbp+0x320],0x0
   18179fa16:	0f 84 a9 00 00 00    	je     0x18179fac5
   18179fa1c:	48 8b 85 18 03 00 00 	mov    rax,QWORD PTR [rbp+0x318]
   18179fa23:	48 83 f8 10          	cmp    rax,0x10
   18179fa27:	72 38                	jb     0x18179fa61
   18179fa29:	48 8b 8d 00 03 00 00 	mov    rcx,QWORD PTR [rbp+0x300]
   18179fa30:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18179fa34:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18179fa3b:	72 1f                	jb     0x18179fa5c
   18179fa3d:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18179fa41:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18179fa45:	4c 29 c1             	sub    rcx,r8
   18179fa48:	48 83 f9 20          	cmp    rcx,0x20
   18179fa4c:	0f 83 df 07 00 00    	jae    0x1817a0231
   18179fa52:	48 83 c0 28          	add    rax,0x28
   18179fa56:	48 89 c2             	mov    rdx,rax
   18179fa59:	4c 89 c1             	mov    rcx,r8
   18179fa5c:	e8 7f be d0 05       	call   0x1874ab8e0
   18179fa61:	48 8b 85 e8 02 00 00 	mov    rax,QWORD PTR [rbp+0x2e8]
   18179fa68:	48 83 f8 10          	cmp    rax,0x10
   18179fa6c:	72 38                	jb     0x18179faa6
   18179fa6e:	48 8b 8d d0 02 00 00 	mov    rcx,QWORD PTR [rbp+0x2d0]
   18179fa75:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18179fa79:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18179fa80:	72 1f                	jb     0x18179faa1
   18179fa82:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18179fa86:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18179fa8a:	4c 29 c1             	sub    rcx,r8
   18179fa8d:	48 83 f9 20          	cmp    rcx,0x20
   18179fa91:	0f 83 9a 07 00 00    	jae    0x1817a0231
   18179fa97:	48 83 c0 28          	add    rax,0x28
   18179fa9b:	48 89 c2             	mov    rdx,rax
   18179fa9e:	4c 89 c1             	mov    rcx,r8
   18179faa1:	e8 3a be d0 05       	call   0x1874ab8e0
   18179faa6:	41 83 7e 04 00       	cmp    DWORD PTR [r14+0x4],0x0
   18179faab:	41 c7 06 04 00 00 00 	mov    DWORD PTR [r14],0x4
   18179fab2:	0f 85 ea 04 00 00    	jne    0x18179ffa2
   18179fab8:	41 c7 46 04 90 01 00 	mov    DWORD PTR [r14+0x4],0x190
   18179fabf:	00 
   18179fac0:	e9 dd 04 00 00       	jmp    0x18179ffa2
   18179fac5:	41 c7 06 04 00 00 00 	mov    DWORD PTR [r14],0x4
   18179facc:	41 c7 46 04 90 01 00 	mov    DWORD PTR [r14+0x4],0x190
   18179fad3:	00 
   18179fad4:	e9 c9 04 00 00       	jmp    0x18179ffa2
   18179fad9:	48 8b 77 20          	mov    rsi,QWORD PTR [rdi+0x20]
   18179fadd:	48 8b 5f 28          	mov    rbx,QWORD PTR [rdi+0x28]
   18179fae1:	48 8d bd 20 04 00 00 	lea    rdi,[rbp+0x420]
   18179fae8:	0f 1f 84 00 00 00 00 	nop    DWORD PTR [rax+rax*1+0x0]
   18179faef:	00 
   18179faf0:	48 39 de             	cmp    rsi,rbx
   18179faf3:	74 3d                	je     0x18179fb32
   18179faf5:	48 8b 95 28 04 00 00 	mov    rdx,QWORD PTR [rbp+0x428]
   18179fafc:	48 3b 95 30 04 00 00 	cmp    rdx,QWORD PTR [rbp+0x430]
   18179fb03:	74 1b                	je     0x18179fb20
   18179fb05:	48 89 d1             	mov    rcx,rdx
   18179fb08:	48 89 f2             	mov    rdx,rsi
   18179fb0b:	e8 d0 97 fc fe       	call   0x1807692e0
   18179fb10:	90                   	nop
   18179fb11:	48 83 85 28 04 00 00 	add    QWORD PTR [rbp+0x428],0x50
   18179fb18:	50 
   18179fb19:	48 83 c6 50          	add    rsi,0x50
   18179fb1d:	eb d1                	jmp    0x18179faf0
   18179fb1f:	90                   	nop
   18179fb20:	48 89 f9             	mov    rcx,rdi
   18179fb23:	49 89 f0             	mov    r8,rsi
   18179fb26:	e8 a5 5d 0a 00       	call   0x1818458d0
   18179fb2b:	90                   	nop
   18179fb2c:	48 83 c6 50          	add    rsi,0x50
   18179fb30:	eb be                	jmp    0x18179faf0
   18179fb32:	b9 02 00 00 00       	mov    ecx,0x2
   18179fb37:	e8 a4 d2 8c fe       	call   0x18006cde0
   18179fb3c:	85 c0                	test   eax,eax
   18179fb3e:	0f 84 2a 01 00 00    	je     0x18179fc6e
   18179fb44:	48 8d b5 50 02 00 00 	lea    rsi,[rbp+0x250]
   18179fb4b:	48 89 f1             	mov    rcx,rsi
   18179fb4e:	e8 bd d3 8c fe       	call   0x18006cf10
   18179fb53:	90                   	nop
   18179fb54:	48 83 bd 68 02 00 00 	cmp    QWORD PTR [rbp+0x268],0x10
   18179fb5b:	10 
   18179fb5c:	72 07                	jb     0x18179fb65
   18179fb5e:	48 8b b5 50 02 00 00 	mov    rsi,QWORD PTR [rbp+0x250]
   18179fb65:	48 8d 05 74 e7 93 07 	lea    rax,[rip+0x793e774]        # 0x1890de2e0
   18179fb6c:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   18179fb71:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   18179fb78:	00 00 
   18179fb7a:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   18179fb7f:	c7 44 24 28 4f 03 00 	mov    DWORD PTR [rsp+0x28],0x34f
   18179fb86:	00 
   18179fb87:	4c 8d 0d 6a c2 93 07 	lea    r9,[rip+0x793c26a]        # 0x1890dbdf8
   18179fb8e:	48 8d 8d d0 02 00 00 	lea    rcx,[rbp+0x2d0]
   18179fb95:	ba 02 00 00 00       	mov    edx,0x2
   18179fb9a:	49 89 f0             	mov    r8,rsi
   18179fb9d:	e8 ce d6 8c fe       	call   0x18006d270
   18179fba2:	90                   	nop
   18179fba3:	48 8b 95 28 04 00 00 	mov    rdx,QWORD PTR [rbp+0x428]
   18179fbaa:	48 2b 95 20 04 00 00 	sub    rdx,QWORD PTR [rbp+0x420]
   18179fbb1:	48 c1 fa 04          	sar    rdx,0x4
   18179fbb5:	49 0f af d6          	imul   rdx,r14
   18179fbb9:	48 8d b5 d0 01 00 00 	lea    rsi,[rbp+0x1d0]
   18179fbc0:	48 89 f1             	mov    rcx,rsi
   18179fbc3:	41 b0 0a             	mov    r8b,0xa
   18179fbc6:	e8 e5 ac 8e fe       	call   0x18008a8b0
   18179fbcb:	90                   	nop
   18179fbcc:	48 8b 85 40 04 00 00 	mov    rax,QWORD PTR [rbp+0x440]
   18179fbd3:	48 8b 00             	mov    rax,QWORD PTR [rax]
   18179fbd6:	48 8b 50 28          	mov    rdx,QWORD PTR [rax+0x28]
   18179fbda:	48 2b 50 20          	sub    rdx,QWORD PTR [rax+0x20]
   18179fbde:	48 c1 fa 04          	sar    rdx,0x4
   18179fbe2:	49 0f af d6          	imul   rdx,r14
   18179fbe6:	48 8d bd 00 01 00 00 	lea    rdi,[rbp+0x100]
   18179fbed:	48 89 f9             	mov    rcx,rdi
   18179fbf0:	41 b0 0a             	mov    r8b,0xa
   18179fbf3:	e8 b8 ac 8e fe       	call   0x18008a8b0
   18179fbf8:	90                   	nop
   18179fbf9:	0f 57 c0             	xorps  xmm0,xmm0
   18179fbfc:	0f 11 85 d0 03 00 00 	movups XMMWORD PTR [rbp+0x3d0],xmm0
   18179fc03:	0f 11 85 c0 03 00 00 	movups XMMWORD PTR [rbp+0x3c0],xmm0
   18179fc0a:	0f 11 85 b0 03 00 00 	movups XMMWORD PTR [rbp+0x3b0],xmm0
   18179fc11:	0f 11 85 a0 03 00 00 	movups XMMWORD PTR [rbp+0x3a0],xmm0
   18179fc18:	0f 11 85 90 03 00 00 	movups XMMWORD PTR [rbp+0x390],xmm0
   18179fc1f:	0f 11 85 80 03 00 00 	movups XMMWORD PTR [rbp+0x380],xmm0
   18179fc26:	0f 11 85 70 03 00 00 	movups XMMWORD PTR [rbp+0x370],xmm0
   18179fc2d:	48 89 bd 60 03 00 00 	mov    QWORD PTR [rbp+0x360],rdi
   18179fc34:	48 89 b5 68 03 00 00 	mov    QWORD PTR [rbp+0x368],rsi
   18179fc3b:	48 8d 15 7e cd 93 07 	lea    rdx,[rip+0x793cd7e]        # 0x1890dc9c0
   18179fc42:	48 8d 8d d0 02 00 00 	lea    rcx,[rbp+0x2d0]
   18179fc49:	4c 8d 85 60 03 00 00 	lea    r8,[rbp+0x360]
   18179fc50:	e8 bb db 8c fe       	call   0x18006d810
   18179fc55:	90                   	nop
   18179fc56:	48 8d 8d d0 02 00 00 	lea    rcx,[rbp+0x2d0]
   18179fc5d:	e8 0e d7 8c fe       	call   0x18006d370
   18179fc62:	48 8d 8d 50 02 00 00 	lea    rcx,[rbp+0x250]
   18179fc69:	e8 a2 23 86 fe       	call   0x180002010
   18179fc6e:	48 8b 85 28 04 00 00 	mov    rax,QWORD PTR [rbp+0x428]
   18179fc75:	48 2b 85 20 04 00 00 	sub    rax,QWORD PTR [rbp+0x420]
   18179fc7c:	48 c1 f8 04          	sar    rax,0x4
   18179fc80:	49 0f af c6          	imul   rax,r14
   18179fc84:	48 83 f8 02          	cmp    rax,0x2
   18179fc88:	0f 82 c9 01 00 00    	jb     0x18179fe57
   18179fc8e:	48 8d 8d d0 01 00 00 	lea    rcx,[rbp+0x1d0]
   18179fc95:	e8 86 75 8a fe       	call   0x180047220
   18179fc9a:	90                   	nop
   18179fc9b:	48 8b 8d d0 01 00 00 	mov    rcx,QWORD PTR [rbp+0x1d0]
   18179fca2:	48 8d 95 60 03 00 00 	lea    rdx,[rbp+0x360]
   18179fca9:	e8 92 ca bc fe       	call   0x18036c740
   18179fcae:	90                   	nop
   18179fcaf:	48 8b 8d 60 03 00 00 	mov    rcx,QWORD PTR [rbp+0x360]
   18179fcb6:	48 8d 95 d0 02 00 00 	lea    rdx,[rbp+0x2d0]
   18179fcbd:	e8 9e 2e 2c ff       	call   0x180a62b60
   18179fcc2:	90                   	nop
   18179fcc3:	48 8b 8d d0 02 00 00 	mov    rcx,QWORD PTR [rbp+0x2d0]
   18179fcca:	48 8d 95 20 04 00 00 	lea    rdx,[rbp+0x420]
   18179fcd1:	41 b0 01             	mov    r8b,0x1
   18179fcd4:	45 31 c9             	xor    r9d,r9d
   18179fcd7:	e8 94 15 b6 00       	call   0x182301270
   18179fcdc:	90                   	nop
   18179fcdd:	48 8d 8d d0 02 00 00 	lea    rcx,[rbp+0x2d0]
   18179fce4:	e8 77 23 86 fe       	call   0x180002060
   18179fce9:	48 8d 8d 60 03 00 00 	lea    rcx,[rbp+0x360]
   18179fcf0:	e8 6b 23 86 fe       	call   0x180002060
   18179fcf5:	48 8d 8d d0 01 00 00 	lea    rcx,[rbp+0x1d0]
   18179fcfc:	e8 5f 23 86 fe       	call   0x180002060
   18179fd01:	90                   	nop
   18179fd02:	48 8d 15 5f 55 93 07 	lea    rdx,[rip+0x793555f]        # 0x1890d5268
   18179fd09:	48 8d 8d b0 00 00 00 	lea    rcx,[rbp+0xb0]
   18179fd10:	45 31 c0             	xor    r8d,r8d
   18179fd13:	e8 38 a0 bc fe       	call   0x180369d50
   18179fd18:	90                   	nop
   18179fd19:	b9 02 00 00 00       	mov    ecx,0x2
   18179fd1e:	e8 bd d0 8c fe       	call   0x18006cde0
   18179fd23:	85 c0                	test   eax,eax
   18179fd25:	0f 84 2c 01 00 00    	je     0x18179fe57
   18179fd2b:	48 8d b5 50 02 00 00 	lea    rsi,[rbp+0x250]
   18179fd32:	48 89 f1             	mov    rcx,rsi
   18179fd35:	e8 d6 d1 8c fe       	call   0x18006cf10
   18179fd3a:	90                   	nop
   18179fd3b:	48 83 bd 68 02 00 00 	cmp    QWORD PTR [rbp+0x268],0x10
   18179fd42:	10 
   18179fd43:	72 07                	jb     0x18179fd4c
   18179fd45:	48 8b b5 50 02 00 00 	mov    rsi,QWORD PTR [rbp+0x250]
   18179fd4c:	48 8d 05 8d e5 93 07 	lea    rax,[rip+0x793e58d]        # 0x1890de2e0
   18179fd53:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   18179fd58:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   18179fd5f:	00 00 
   18179fd61:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   18179fd66:	c7 44 24 28 53 03 00 	mov    DWORD PTR [rsp+0x28],0x353
   18179fd6d:	00 
   18179fd6e:	4c 8d 0d 83 c0 93 07 	lea    r9,[rip+0x793c083]        # 0x1890dbdf8
   18179fd75:	48 8d 8d d0 02 00 00 	lea    rcx,[rbp+0x2d0]
   18179fd7c:	ba 02 00 00 00       	mov    edx,0x2
   18179fd81:	49 89 f0             	mov    r8,rsi
   18179fd84:	e8 e7 d4 8c fe       	call   0x18006d270
   18179fd89:	90                   	nop
   18179fd8a:	48 8b 95 28 04 00 00 	mov    rdx,QWORD PTR [rbp+0x428]
   18179fd91:	48 2b 95 20 04 00 00 	sub    rdx,QWORD PTR [rbp+0x420]
   18179fd98:	48 c1 fa 04          	sar    rdx,0x4
   18179fd9c:	49 0f af d6          	imul   rdx,r14
   18179fda0:	48 8d b5 d0 01 00 00 	lea    rsi,[rbp+0x1d0]
   18179fda7:	48 89 f1             	mov    rcx,rsi
   18179fdaa:	41 b0 0a             	mov    r8b,0xa
   18179fdad:	e8 fe aa 8e fe       	call   0x18008a8b0
   18179fdb2:	90                   	nop
   18179fdb3:	48 83 bd 18 04 00 00 	cmp    QWORD PTR [rbp+0x418],0x10
   18179fdba:	10 
   18179fdbb:	72 09                	jb     0x18179fdc6
   18179fdbd:	48 8b 85 00 04 00 00 	mov    rax,QWORD PTR [rbp+0x400]
   18179fdc4:	eb 07                	jmp    0x18179fdcd
   18179fdc6:	48 8d 85 00 04 00 00 	lea    rax,[rbp+0x400]
   18179fdcd:	48 89 85 00 01 00 00 	mov    QWORD PTR [rbp+0x100],rax
   18179fdd4:	c6 85 08 01 00 00 00 	mov    BYTE PTR [rbp+0x108],0x0
   18179fddb:	0f 57 c0             	xorps  xmm0,xmm0
   18179fdde:	0f 11 85 d0 03 00 00 	movups XMMWORD PTR [rbp+0x3d0],xmm0
   18179fde5:	0f 11 85 c0 03 00 00 	movups XMMWORD PTR [rbp+0x3c0],xmm0
   18179fdec:	0f 11 85 b0 03 00 00 	movups XMMWORD PTR [rbp+0x3b0],xmm0
   18179fdf3:	0f 11 85 a0 03 00 00 	movups XMMWORD PTR [rbp+0x3a0],xmm0
   18179fdfa:	0f 11 85 90 03 00 00 	movups XMMWORD PTR [rbp+0x390],xmm0
   18179fe01:	0f 11 85 80 03 00 00 	movups XMMWORD PTR [rbp+0x380],xmm0
   18179fe08:	0f 11 85 70 03 00 00 	movups XMMWORD PTR [rbp+0x370],xmm0
   18179fe0f:	48 8d 85 00 01 00 00 	lea    rax,[rbp+0x100]
   18179fe16:	48 89 85 60 03 00 00 	mov    QWORD PTR [rbp+0x360],rax
   18179fe1d:	48 89 b5 68 03 00 00 	mov    QWORD PTR [rbp+0x368],rsi
   18179fe24:	48 8d 15 75 e0 93 07 	lea    rdx,[rip+0x793e075]        # 0x1890ddea0
   18179fe2b:	48 8d 8d d0 02 00 00 	lea    rcx,[rbp+0x2d0]
   18179fe32:	4c 8d 85 60 03 00 00 	lea    r8,[rbp+0x360]
   18179fe39:	e8 d2 d9 8c fe       	call   0x18006d810
   18179fe3e:	90                   	nop
   18179fe3f:	48 8d 8d d0 02 00 00 	lea    rcx,[rbp+0x2d0]
   18179fe46:	e8 25 d5 8c fe       	call   0x18006d370
   18179fe4b:	48 8d 8d 50 02 00 00 	lea    rcx,[rbp+0x250]
   18179fe52:	e8 b9 21 86 fe       	call   0x180002010
   18179fe57:	b9 02 00 00 00       	mov    ecx,0x2
   18179fe5c:	e8 7f cf 8c fe       	call   0x18006cde0
   18179fe61:	85 c0                	test   eax,eax
   18179fe63:	4c 8b b5 28 02 00 00 	mov    r14,QWORD PTR [rbp+0x228]
   18179fe6a:	0f 84 32 01 00 00    	je     0x18179ffa2
   18179fe70:	48 8d b5 50 02 00 00 	lea    rsi,[rbp+0x250]
   18179fe77:	48 89 f1             	mov    rcx,rsi
   18179fe7a:	e8 91 d0 8c fe       	call   0x18006cf10
   18179fe7f:	90                   	nop
   18179fe80:	48 83 bd 68 02 00 00 	cmp    QWORD PTR [rbp+0x268],0x10
   18179fe87:	10 
   18179fe88:	72 07                	jb     0x18179fe91
   18179fe8a:	48 8b b5 50 02 00 00 	mov    rsi,QWORD PTR [rbp+0x250]
   18179fe91:	48 8d 05 48 e4 93 07 	lea    rax,[rip+0x793e448]        # 0x1890de2e0
   18179fe98:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   18179fe9d:	48 c7 44 24 38 00 00 	mov    QWORD PTR [rsp+0x38],0x0
   18179fea4:	00 00 
   18179fea6:	c6 44 24 30 00       	mov    BYTE PTR [rsp+0x30],0x0
   18179feab:	c7 44 24 28 57 03 00 	mov    DWORD PTR [rsp+0x28],0x357
   18179feb2:	00 
   18179feb3:	4c 8d 0d 3e bf 93 07 	lea    r9,[rip+0x793bf3e]        # 0x1890dbdf8
   18179feba:	48 8d 8d d0 02 00 00 	lea    rcx,[rbp+0x2d0]
   18179fec1:	ba 02 00 00 00       	mov    edx,0x2
   18179fec6:	49 89 f0             	mov    r8,rsi
   18179fec9:	e8 a2 d3 8c fe       	call   0x18006d270
   18179fece:	90                   	nop
   18179fecf:	48 8b 85 40 04 00 00 	mov    rax,QWORD PTR [rbp+0x440]
   18179fed6:	48 8b 00             	mov    rax,QWORD PTR [rax]
   18179fed9:	48 8b 50 08          	mov    rdx,QWORD PTR [rax+0x8]
   18179fedd:	48 2b 10             	sub    rdx,QWORD PTR [rax]
   18179fee0:	48 c1 fa 04          	sar    rdx,0x4
   18179fee4:	48 8d b5 d0 01 00 00 	lea    rsi,[rbp+0x1d0]
   18179feeb:	48 89 f1             	mov    rcx,rsi
   18179feee:	41 b0 0a             	mov    r8b,0xa
   18179fef1:	e8 ba a9 8e fe       	call   0x18008a8b0
   18179fef6:	90                   	nop
   18179fef7:	48 83 bd 18 04 00 00 	cmp    QWORD PTR [rbp+0x418],0x10
   18179fefe:	10 
   18179feff:	72 09                	jb     0x18179ff0a
   18179ff01:	48 8b 85 00 04 00 00 	mov    rax,QWORD PTR [rbp+0x400]
   18179ff08:	eb 07                	jmp    0x18179ff11
   18179ff0a:	48 8d 85 00 04 00 00 	lea    rax,[rbp+0x400]
   18179ff11:	48 89 85 00 01 00 00 	mov    QWORD PTR [rbp+0x100],rax
   18179ff18:	c6 85 08 01 00 00 00 	mov    BYTE PTR [rbp+0x108],0x0
   18179ff1f:	0f 57 c0             	xorps  xmm0,xmm0
   18179ff22:	0f 11 85 d0 03 00 00 	movups XMMWORD PTR [rbp+0x3d0],xmm0
   18179ff29:	0f 11 85 c0 03 00 00 	movups XMMWORD PTR [rbp+0x3c0],xmm0
   18179ff30:	0f 11 85 b0 03 00 00 	movups XMMWORD PTR [rbp+0x3b0],xmm0
   18179ff37:	0f 11 85 a0 03 00 00 	movups XMMWORD PTR [rbp+0x3a0],xmm0
   18179ff3e:	0f 11 85 90 03 00 00 	movups XMMWORD PTR [rbp+0x390],xmm0
   18179ff45:	0f 11 85 80 03 00 00 	movups XMMWORD PTR [rbp+0x380],xmm0
   18179ff4c:	0f 11 85 70 03 00 00 	movups XMMWORD PTR [rbp+0x370],xmm0
   18179ff53:	48 8d 85 00 01 00 00 	lea    rax,[rbp+0x100]
   18179ff5a:	48 89 85 60 03 00 00 	mov    QWORD PTR [rbp+0x360],rax
   18179ff61:	48 89 b5 68 03 00 00 	mov    QWORD PTR [rbp+0x368],rsi
   18179ff68:	48 8d 15 79 f3 93 07 	lea    rdx,[rip+0x793f379]        # 0x1890df2e8
   18179ff6f:	48 8d 8d d0 02 00 00 	lea    rcx,[rbp+0x2d0]
   18179ff76:	4c 8d 85 60 03 00 00 	lea    r8,[rbp+0x360]
   18179ff7d:	e8 8e d8 8c fe       	call   0x18006d810
   18179ff82:	90                   	nop
   18179ff83:	48 8d 8d d0 02 00 00 	lea    rcx,[rbp+0x2d0]
   18179ff8a:	e8 e1 d3 8c fe       	call   0x18006d370
   18179ff8f:	48 8d 8d 50 02 00 00 	lea    rcx,[rbp+0x250]
   18179ff96:	e8 75 20 86 fe       	call   0x180002010
   18179ff9b:	4c 8b b5 28 02 00 00 	mov    r14,QWORD PTR [rbp+0x228]
   18179ffa2:	48 8d 8d 20 04 00 00 	lea    rcx,[rbp+0x420]
   18179ffa9:	e8 62 42 e2 ff       	call   0x1815c4210
   18179ffae:	48 8b 8d 88 01 00 00 	mov    rcx,QWORD PTR [rbp+0x188]
   18179ffb5:	48 85 c9             	test   rcx,rcx
   18179ffb8:	74 34                	je     0x18179ffee
   18179ffba:	48 8b 95 98 01 00 00 	mov    rdx,QWORD PTR [rbp+0x198]
   18179ffc1:	48 29 ca             	sub    rdx,rcx
   18179ffc4:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18179ffcb:	72 1c                	jb     0x18179ffe9
   18179ffcd:	48 8b 41 f8          	mov    rax,QWORD PTR [rcx-0x8]
   18179ffd1:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18179ffd5:	48 29 c1             	sub    rcx,rax
   18179ffd8:	48 83 f9 20          	cmp    rcx,0x20
   18179ffdc:	0f 83 4f 02 00 00    	jae    0x1817a0231
   18179ffe2:	48 83 c2 27          	add    rdx,0x27
   18179ffe6:	48 89 c1             	mov    rcx,rax
   18179ffe9:	e8 f2 b8 d0 05       	call   0x1874ab8e0
   18179ffee:	4c 89 f9             	mov    rcx,r15
   18179fff1:	e8 7a 8c f6 ff       	call   0x181708c70
   18179fff6:	48 8b b5 30 02 00 00 	mov    rsi,QWORD PTR [rbp+0x230]
   18179fffd:	48 85 f6             	test   rsi,rsi
   1817a0000:	74 62                	je     0x1817a0064
   1817a0002:	48 8b bd 38 02 00 00 	mov    rdi,QWORD PTR [rbp+0x238]
   1817a0009:	48 39 fe             	cmp    rsi,rdi
   1817a000c:	74 1f                	je     0x1817a002d
   1817a000e:	66 90                	xchg   ax,ax
   1817a0010:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1817a0013:	48 89 f1             	mov    rcx,rsi
   1817a0016:	31 d2                	xor    edx,edx
   1817a0018:	ff 10                	call   QWORD PTR [rax]
   1817a001a:	48 81 c6 e8 02 00 00 	add    rsi,0x2e8
   1817a0021:	48 39 fe             	cmp    rsi,rdi
   1817a0024:	75 ea                	jne    0x1817a0010
   1817a0026:	48 8b b5 30 02 00 00 	mov    rsi,QWORD PTR [rbp+0x230]
   1817a002d:	48 8b 95 40 02 00 00 	mov    rdx,QWORD PTR [rbp+0x240]
   1817a0034:	48 29 f2             	sub    rdx,rsi
   1817a0037:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1817a003e:	72 1c                	jb     0x1817a005c
   1817a0040:	48 8b 46 f8          	mov    rax,QWORD PTR [rsi-0x8]
   1817a0044:	48 83 c6 f8          	add    rsi,0xfffffffffffffff8
   1817a0048:	48 29 c6             	sub    rsi,rax
   1817a004b:	48 83 fe 20          	cmp    rsi,0x20
   1817a004f:	0f 83 dc 01 00 00    	jae    0x1817a0231
   1817a0055:	48 83 c2 27          	add    rdx,0x27
   1817a0059:	48 89 c6             	mov    rsi,rax
   1817a005c:	48 89 f1             	mov    rcx,rsi
   1817a005f:	e8 7c b8 d0 05       	call   0x1874ab8e0
   1817a0064:	48 8b 85 18 04 00 00 	mov    rax,QWORD PTR [rbp+0x418]
   1817a006b:	48 83 f8 10          	cmp    rax,0x10
   1817a006f:	72 38                	jb     0x1817a00a9
   1817a0071:	48 8b 8d 00 04 00 00 	mov    rcx,QWORD PTR [rbp+0x400]
   1817a0078:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1817a007c:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1817a0083:	72 1f                	jb     0x1817a00a4
   1817a0085:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1817a0089:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1817a008d:	4c 29 c1             	sub    rcx,r8
   1817a0090:	48 83 f9 20          	cmp    rcx,0x20
   1817a0094:	0f 83 97 01 00 00    	jae    0x1817a0231
   1817a009a:	48 83 c0 28          	add    rax,0x28
   1817a009e:	48 89 c2             	mov    rdx,rax
   1817a00a1:	4c 89 c1             	mov    rcx,r8
   1817a00a4:	e8 37 b8 d0 05       	call   0x1874ab8e0
   1817a00a9:	48 8b b5 b0 02 00 00 	mov    rsi,QWORD PTR [rbp+0x2b0]
   1817a00b0:	48 85 f6             	test   rsi,rsi
   1817a00b3:	74 6f                	je     0x1817a0124
   1817a00b5:	48 8b bd b8 02 00 00 	mov    rdi,QWORD PTR [rbp+0x2b8]
   1817a00bc:	48 39 fe             	cmp    rsi,rdi
   1817a00bf:	74 2c                	je     0x1817a00ed
   1817a00c1:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
   1817a00c8:	0f 1f 84 00 00 00 00 
   1817a00cf:	00 
   1817a00d0:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1817a00d3:	48 89 f1             	mov    rcx,rsi
   1817a00d6:	31 d2                	xor    edx,edx
   1817a00d8:	ff 10                	call   QWORD PTR [rax]
   1817a00da:	48 81 c6 e8 02 00 00 	add    rsi,0x2e8
   1817a00e1:	48 39 fe             	cmp    rsi,rdi
   1817a00e4:	75 ea                	jne    0x1817a00d0
   1817a00e6:	48 8b b5 b0 02 00 00 	mov    rsi,QWORD PTR [rbp+0x2b0]
   1817a00ed:	48 8b 95 c0 02 00 00 	mov    rdx,QWORD PTR [rbp+0x2c0]
   1817a00f4:	48 29 f2             	sub    rdx,rsi
   1817a00f7:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1817a00fe:	72 1c                	jb     0x1817a011c
   1817a0100:	48 8b 46 f8          	mov    rax,QWORD PTR [rsi-0x8]
   1817a0104:	48 83 c6 f8          	add    rsi,0xfffffffffffffff8
   1817a0108:	48 29 c6             	sub    rsi,rax
   1817a010b:	48 83 fe 20          	cmp    rsi,0x20
   1817a010f:	0f 83 1c 01 00 00    	jae    0x1817a0231
   1817a0115:	48 83 c2 27          	add    rdx,0x27
   1817a0119:	48 89 c6             	mov    rsi,rax
   1817a011c:	48 89 f1             	mov    rcx,rsi
   1817a011f:	e8 bc b7 d0 05       	call   0x1874ab8e0
   1817a0124:	48 8b b5 b0 01 00 00 	mov    rsi,QWORD PTR [rbp+0x1b0]
   1817a012b:	48 85 f6             	test   rsi,rsi
   1817a012e:	0f 84 97 00 00 00    	je     0x1817a01cb
   1817a0134:	48 8b 9d b8 01 00 00 	mov    rbx,QWORD PTR [rbp+0x1b8]
   1817a013b:	48 39 de             	cmp    rsi,rbx
   1817a013e:	75 29                	jne    0x1817a0169
   1817a0140:	48 8b 95 c0 01 00 00 	mov    rdx,QWORD PTR [rbp+0x1c0]
   1817a0147:	48 29 f2             	sub    rdx,rsi
   1817a014a:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1817a0151:	73 58                	jae    0x1817a01ab
   1817a0153:	eb 6e                	jmp    0x1817a01c3
   1817a0155:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
   1817a015c:	00 00 00 00 
   1817a0160:	48 83 c6 10          	add    rsi,0x10
   1817a0164:	48 39 de             	cmp    rsi,rbx
   1817a0167:	74 28                	je     0x1817a0191
   1817a0169:	48 8b 7e 08          	mov    rdi,QWORD PTR [rsi+0x8]
   1817a016d:	48 85 ff             	test   rdi,rdi
   1817a0170:	74 ee                	je     0x1817a0160
   1817a0172:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   1817a0176:	75 e8                	jne    0x1817a0160
   1817a0178:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1817a017b:	48 89 f9             	mov    rcx,rdi
   1817a017e:	ff 10                	call   QWORD PTR [rax]
   1817a0180:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   1817a0184:	75 da                	jne    0x1817a0160
   1817a0186:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   1817a0189:	48 89 f9             	mov    rcx,rdi
   1817a018c:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1817a018f:	eb cf                	jmp    0x1817a0160
   1817a0191:	48 8b b5 b0 01 00 00 	mov    rsi,QWORD PTR [rbp+0x1b0]
   1817a0198:	48 8b 95 c0 01 00 00 	mov    rdx,QWORD PTR [rbp+0x1c0]
   1817a019f:	48 29 f2             	sub    rdx,rsi
   1817a01a2:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1817a01a9:	72 18                	jb     0x1817a01c3
   1817a01ab:	48 8b 46 f8          	mov    rax,QWORD PTR [rsi-0x8]
   1817a01af:	48 83 c6 f8          	add    rsi,0xfffffffffffffff8
   1817a01b3:	48 29 c6             	sub    rsi,rax
   1817a01b6:	48 83 fe 20          	cmp    rsi,0x20
   1817a01ba:	73 75                	jae    0x1817a0231
   1817a01bc:	48 83 c2 27          	add    rdx,0x27
   1817a01c0:	48 89 c6             	mov    rsi,rax
   1817a01c3:	48 89 f1             	mov    rcx,rsi
   1817a01c6:	e8 15 b7 d0 05       	call   0x1874ab8e0
   1817a01cb:	48 8b 85 f0 00 00 00 	mov    rax,QWORD PTR [rbp+0xf0]
   1817a01d2:	48 83 f8 10          	cmp    rax,0x10
   1817a01d6:	72 34                	jb     0x1817a020c
   1817a01d8:	48 8b 8d d8 00 00 00 	mov    rcx,QWORD PTR [rbp+0xd8]
   1817a01df:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1817a01e3:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1817a01ea:	72 1b                	jb     0x1817a0207
   1817a01ec:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1817a01f0:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1817a01f4:	4c 29 c1             	sub    rcx,r8
   1817a01f7:	48 83 f9 20          	cmp    rcx,0x20
   1817a01fb:	73 34                	jae    0x1817a0231
   1817a01fd:	48 83 c0 28          	add    rax,0x28
   1817a0201:	48 89 c2             	mov    rdx,rax
   1817a0204:	4c 89 c1             	mov    rcx,r8
   1817a0207:	e8 d4 b6 d0 05       	call   0x1874ab8e0
   1817a020c:	4c 89 f0             	mov    rax,r14
   1817a020f:	0f 28 b5 50 04 00 00 	movaps xmm6,XMMWORD PTR [rbp+0x450]
   1817a0216:	0f 28 bd 60 04 00 00 	movaps xmm7,XMMWORD PTR [rbp+0x460]
   1817a021d:	48 81 c4 f8 04 00 00 	add    rsp,0x4f8
   1817a0224:	5b                   	pop    rbx
   1817a0225:	5f                   	pop    rdi
   1817a0226:	5e                   	pop    rsi
   1817a0227:	41 5c                	pop    r12
   1817a0229:	41 5d                	pop    r13
   1817a022b:	41 5e                	pop    r14
   1817a022d:	41 5f                	pop    r15
   1817a022f:	5d                   	pop    rbp
   1817a0230:	c3                   	ret
   1817a0231:	e8 56 d1 d6 05       	call   0x18750d38c
   1817a0236:	90                   	nop
   1817a0237:	e8 f4 b4 86 fe       	call   0x18000b730
   1817a023c:	90                   	nop
   1817a023d:	e8 ee b4 86 fe       	call   0x18000b730
   1817a0242:	90                   	nop
   1817a0243:	e8 48 89 86 fe       	call   0x180008b90
   1817a0248:	90                   	nop
   1817a0249:	e8 42 89 86 fe       	call   0x180008b90
   1817a024e:	90                   	nop
   1817a024f:	e8 dc b4 86 fe       	call   0x18000b730
   1817a0254:	90                   	nop
   1817a0255:	cc                   	int3
