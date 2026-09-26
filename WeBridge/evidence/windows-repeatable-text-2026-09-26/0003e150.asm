
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

000000018003e150 <.text+0x3d150>:
   18003e150:	41 57                	push   r15
   18003e152:	41 56                	push   r14
   18003e154:	41 54                	push   r12
   18003e156:	56                   	push   rsi
   18003e157:	57                   	push   rdi
   18003e158:	53                   	push   rbx
   18003e159:	48 83 ec 28          	sub    rsp,0x28
   18003e15d:	48 85 d2             	test   rdx,rdx
   18003e160:	0f 88 e5 00 00 00    	js     0x18003e24b
   18003e166:	4c 89 cb             	mov    rbx,r9
   18003e169:	48 89 d7             	mov    rdi,rdx
   18003e16c:	48 89 ce             	mov    rsi,rcx
   18003e16f:	4c 8b 79 18          	mov    r15,QWORD PTR [rcx+0x18]
   18003e173:	4c 89 f8             	mov    rax,r15
   18003e176:	48 d1 e8             	shr    rax,1
   18003e179:	49 bc ff ff ff ff ff 	movabs r12,0x7fffffffffffffff
   18003e180:	ff ff 7f 
   18003e183:	48 89 c1             	mov    rcx,rax
   18003e186:	4c 31 e1             	xor    rcx,r12
   18003e189:	49 39 cf             	cmp    r15,rcx
   18003e18c:	77 27                	ja     0x18003e1b5
   18003e18e:	48 89 f9             	mov    rcx,rdi
   18003e191:	48 83 c9 0f          	or     rcx,0xf
   18003e195:	4c 01 f8             	add    rax,r15
   18003e198:	48 39 c1             	cmp    rcx,rax
   18003e19b:	49 89 c4             	mov    r12,rax
   18003e19e:	4c 0f 47 e1          	cmova  r12,rcx
   18003e1a2:	49 81 fc ff 0f 00 00 	cmp    r12,0xfff
   18003e1a9:	72 2e                	jb     0x18003e1d9
   18003e1ab:	49 83 fc d8          	cmp    r12,0xffffffffffffffd8
   18003e1af:	0f 83 a0 00 00 00    	jae    0x18003e255
   18003e1b5:	49 8d 4c 24 28       	lea    rcx,[r12+0x28]
   18003e1ba:	e8 dd d6 46 07       	call   0x1874ab89c
   18003e1bf:	48 85 c0             	test   rax,rax
   18003e1c2:	0f 84 88 00 00 00    	je     0x18003e250
   18003e1c8:	49 89 c6             	mov    r14,rax
   18003e1cb:	49 83 c6 27          	add    r14,0x27
   18003e1cf:	49 83 e6 e0          	and    r14,0xffffffffffffffe0
   18003e1d3:	49 89 46 f8          	mov    QWORD PTR [r14-0x8],rax
   18003e1d7:	eb 0d                	jmp    0x18003e1e6
   18003e1d9:	49 8d 4c 24 01       	lea    rcx,[r12+0x1]
   18003e1de:	e8 b9 d6 46 07       	call   0x1874ab89c
   18003e1e3:	49 89 c6             	mov    r14,rax
   18003e1e6:	48 89 7e 10          	mov    QWORD PTR [rsi+0x10],rdi
   18003e1ea:	4c 89 66 18          	mov    QWORD PTR [rsi+0x18],r12
   18003e1ee:	4c 89 f1             	mov    rcx,r14
   18003e1f1:	48 89 da             	mov    rdx,rbx
   18003e1f4:	49 89 f8             	mov    r8,rdi
   18003e1f7:	e8 54 5e 50 07       	call   0x187544050
   18003e1fc:	41 c6 04 3e 00       	mov    BYTE PTR [r14+rdi*1],0x0
   18003e201:	49 83 ff 10          	cmp    r15,0x10
   18003e205:	72 30                	jb     0x18003e237
   18003e207:	48 8b 0e             	mov    rcx,QWORD PTR [rsi]
   18003e20a:	49 8d 57 01          	lea    rdx,[r15+0x1]
   18003e20e:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   18003e215:	72 1b                	jb     0x18003e232
   18003e217:	48 8b 41 f8          	mov    rax,QWORD PTR [rcx-0x8]
   18003e21b:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18003e21f:	48 29 c1             	sub    rcx,rax
   18003e222:	48 83 f9 20          	cmp    rcx,0x20
   18003e226:	73 28                	jae    0x18003e250
   18003e228:	49 83 c7 28          	add    r15,0x28
   18003e22c:	4c 89 fa             	mov    rdx,r15
   18003e22f:	48 89 c1             	mov    rcx,rax
   18003e232:	e8 a9 d6 46 07       	call   0x1874ab8e0
   18003e237:	4c 89 36             	mov    QWORD PTR [rsi],r14
   18003e23a:	48 89 f0             	mov    rax,rsi
   18003e23d:	48 83 c4 28          	add    rsp,0x28
   18003e241:	5b                   	pop    rbx
   18003e242:	5f                   	pop    rdi
   18003e243:	5e                   	pop    rsi
   18003e244:	41 5c                	pop    r12
   18003e246:	41 5e                	pop    r14
   18003e248:	41 5f                	pop    r15
   18003e24a:	c3                   	ret
   18003e24b:	e8 40 a9 fc ff       	call   0x180008b90
   18003e250:	e8 37 f1 4c 07       	call   0x18750d38c
   18003e255:	e8 e6 a7 fc ff       	call   0x180008a40
   18003e25a:	cc                   	int3
