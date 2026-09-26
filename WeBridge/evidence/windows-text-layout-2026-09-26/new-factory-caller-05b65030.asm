
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000185b65030 <.text+0x5b64030>:
   185b65030:	55                   	push   rbp
   185b65031:	41 57                	push   r15
   185b65033:	41 56                	push   r14
   185b65035:	56                   	push   rsi
   185b65036:	57                   	push   rdi
   185b65037:	53                   	push   rbx
   185b65038:	48 81 ec 88 00 00 00 	sub    rsp,0x88
   185b6503f:	48 8d ac 24 80 00 00 	lea    rbp,[rsp+0x80]
   185b65046:	00 
   185b65047:	48 c7 45 00 fe ff ff 	mov    QWORD PTR [rbp+0x0],0xfffffffffffffffe
   185b6504e:	ff 
   185b6504f:	4c 89 45 f8          	mov    QWORD PTR [rbp-0x8],r8
   185b65053:	48 89 d6             	mov    rsi,rdx
   185b65056:	48 89 cf             	mov    rdi,rcx
   185b65059:	0f 28 05 50 0b 1e 03 	movaps xmm0,XMMWORD PTR [rip+0x31e0b50]        # 0x188d45bb0
   185b65060:	0f 29 45 e0          	movaps XMMWORD PTR [rbp-0x20],xmm0
   185b65064:	48 8d 4d e0          	lea    rcx,[rbp-0x20]
   185b65068:	e8 03 fc b8 fa       	call   0x1806f4c70
   185b6506d:	90                   	nop
   185b6506e:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
   185b65072:	c7 80 18 01 00 00 01 	mov    DWORD PTR [rax+0x118],0x1
   185b65079:	00 00 00 
   185b6507c:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
   185b65080:	48 8b 00             	mov    rax,QWORD PTR [rax]
   185b65083:	8b 90 c8 03 00 00    	mov    edx,DWORD PTR [rax+0x3c8]
   185b65089:	48 8d 5d a0          	lea    rbx,[rbp-0x60]
   185b6508d:	48 89 d9             	mov    rcx,rbx
   185b65090:	e8 bb 01 00 00       	call   0x185b65250
   185b65095:	90                   	nop
   185b65096:	4c 8b 7d f8          	mov    r15,QWORD PTR [rbp-0x8]
   185b6509a:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
   185b6509e:	4c 8d b0 58 07 00 00 	lea    r14,[rax+0x758]
   185b650a5:	49 39 de             	cmp    r14,rbx
   185b650a8:	74 54                	je     0x185b650fe
   185b650aa:	48 8b 80 70 07 00 00 	mov    rax,QWORD PTR [rax+0x770]
   185b650b1:	48 83 f8 10          	cmp    rax,0x10
   185b650b5:	72 34                	jb     0x185b650eb
   185b650b7:	49 8b 0e             	mov    rcx,QWORD PTR [r14]
   185b650ba:	48 8d 50 01          	lea    rdx,[rax+0x1]
   185b650be:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185b650c5:	72 1f                	jb     0x185b650e6
   185b650c7:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   185b650cb:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   185b650cf:	4c 29 c1             	sub    rcx,r8
   185b650d2:	48 83 f9 20          	cmp    rcx,0x20
   185b650d6:	0f 83 02 01 00 00    	jae    0x185b651de
   185b650dc:	48 83 c0 28          	add    rax,0x28
   185b650e0:	48 89 c2             	mov    rdx,rax
   185b650e3:	4c 89 c1             	mov    rcx,r8
   185b650e6:	e8 f5 67 94 01       	call   0x1874ab8e0
   185b650eb:	0f 10 45 a0          	movups xmm0,XMMWORD PTR [rbp-0x60]
   185b650ef:	0f 10 4d b0          	movups xmm1,XMMWORD PTR [rbp-0x50]
   185b650f3:	41 0f 11 4e 10       	movups XMMWORD PTR [r14+0x10],xmm1
   185b650f8:	41 0f 11 06          	movups XMMWORD PTR [r14],xmm0
   185b650fc:	eb 3f                	jmp    0x185b6513d
   185b650fe:	48 8b 45 b8          	mov    rax,QWORD PTR [rbp-0x48]
   185b65102:	48 83 f8 10          	cmp    rax,0x10
   185b65106:	72 35                	jb     0x185b6513d
   185b65108:	48 8b 4d a0          	mov    rcx,QWORD PTR [rbp-0x60]
   185b6510c:	48 8d 50 01          	lea    rdx,[rax+0x1]
   185b65110:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   185b65117:	72 1f                	jb     0x185b65138
   185b65119:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   185b6511d:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   185b65121:	4c 29 c1             	sub    rcx,r8
   185b65124:	48 83 f9 20          	cmp    rcx,0x20
   185b65128:	0f 83 b0 00 00 00    	jae    0x185b651de
   185b6512e:	48 83 c0 28          	add    rax,0x28
   185b65132:	48 89 c2             	mov    rdx,rax
   185b65135:	4c 89 c1             	mov    rcx,r8
   185b65138:	e8 a3 67 94 01       	call   0x1874ab8e0
   185b6513d:	0f 57 c0             	xorps  xmm0,xmm0
   185b65140:	0f 29 45 c0          	movaps XMMWORD PTR [rbp-0x40],xmm0
   185b65144:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
   185b65148:	48 85 c0             	test   rax,rax
   185b6514b:	74 0a                	je     0x185b65157
   185b6514d:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   185b65151:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
   185b65155:	eb 02                	jmp    0x185b65159
   185b65157:	31 c0                	xor    eax,eax
   185b65159:	48 8b 4d e0          	mov    rcx,QWORD PTR [rbp-0x20]
   185b6515d:	48 89 4d c0          	mov    QWORD PTR [rbp-0x40],rcx
   185b65161:	48 89 45 c8          	mov    QWORD PTR [rbp-0x38],rax
   185b65165:	0f 29 45 d0          	movaps XMMWORD PTR [rbp-0x30],xmm0
   185b65169:	49 8b 47 08          	mov    rax,QWORD PTR [r15+0x8]
   185b6516d:	48 85 c0             	test   rax,rax
   185b65170:	74 0a                	je     0x185b6517c
   185b65172:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   185b65176:	49 8b 47 08          	mov    rax,QWORD PTR [r15+0x8]
   185b6517a:	eb 02                	jmp    0x185b6517e
   185b6517c:	31 c0                	xor    eax,eax
   185b6517e:	49 8b 0f             	mov    rcx,QWORD PTR [r15]
   185b65181:	48 89 4d d0          	mov    QWORD PTR [rbp-0x30],rcx
   185b65185:	48 89 45 d8          	mov    QWORD PTR [rbp-0x28],rax
   185b65189:	48 8d 55 d0          	lea    rdx,[rbp-0x30]
   185b6518d:	4c 8d 45 c0          	lea    r8,[rbp-0x40]
   185b65191:	48 89 f9             	mov    rcx,rdi
   185b65194:	e8 a7 92 ff ff       	call   0x185b5e440
   185b65199:	90                   	nop
   185b6519a:	0f 28 45 e0          	movaps xmm0,XMMWORD PTR [rbp-0x20]
   185b6519e:	0f 11 06             	movups XMMWORD PTR [rsi],xmm0
   185b651a1:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
   185b651a5:	48 8b 78 08          	mov    rdi,QWORD PTR [rax+0x8]
   185b651a9:	48 85 ff             	test   rdi,rdi
   185b651ac:	74 1d                	je     0x185b651cb
   185b651ae:	f0 ff 4f 08          	lock dec DWORD PTR [rdi+0x8]
   185b651b2:	75 17                	jne    0x185b651cb
   185b651b4:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185b651b7:	48 89 f9             	mov    rcx,rdi
   185b651ba:	ff 10                	call   QWORD PTR [rax]
   185b651bc:	f0 ff 4f 0c          	lock dec DWORD PTR [rdi+0xc]
   185b651c0:	75 09                	jne    0x185b651cb
   185b651c2:	48 8b 07             	mov    rax,QWORD PTR [rdi]
   185b651c5:	48 89 f9             	mov    rcx,rdi
   185b651c8:	ff 50 08             	call   QWORD PTR [rax+0x8]
   185b651cb:	48 89 f0             	mov    rax,rsi
   185b651ce:	48 81 c4 88 00 00 00 	add    rsp,0x88
   185b651d5:	5b                   	pop    rbx
   185b651d6:	5f                   	pop    rdi
   185b651d7:	5e                   	pop    rsi
   185b651d8:	41 5e                	pop    r14
   185b651da:	41 5f                	pop    r15
   185b651dc:	5d                   	pop    rbp
   185b651dd:	c3                   	ret
   185b651de:	e8 a9 81 9a 01       	call   0x18750d38c
   185b651e3:	cc                   	int3
