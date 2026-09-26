
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000181824020 <.text+0x1823020>:
   181824020:	55                   	push   rbp
   181824021:	41 57                	push   r15
   181824023:	41 56                	push   r14
   181824025:	41 55                	push   r13
   181824027:	41 54                	push   r12
   181824029:	56                   	push   rsi
   18182402a:	57                   	push   rdi
   18182402b:	53                   	push   rbx
   18182402c:	48 81 ec 08 02 00 00 	sub    rsp,0x208
   181824033:	48 8d ac 24 80 00 00 	lea    rbp,[rsp+0x80]
   18182403a:	00 
   18182403b:	0f 29 bd 70 01 00 00 	movaps XMMWORD PTR [rbp+0x170],xmm7
   181824042:	0f 29 b5 60 01 00 00 	movaps XMMWORD PTR [rbp+0x160],xmm6
   181824049:	48 c7 85 58 01 00 00 	mov    QWORD PTR [rbp+0x158],0xfffffffffffffffe
   181824050:	fe ff ff ff 
   181824054:	4c 89 c3             	mov    rbx,r8
   181824057:	48 89 d1             	mov    rcx,rdx
   18182405a:	48 89 55 78          	mov    QWORD PTR [rbp+0x78],rdx
   18182405e:	e8 bd 90 37 ff       	call   0x180b9d120
   181824063:	84 c0                	test   al,al
   181824065:	0f 84 64 0d 00 00    	je     0x181824dcf
   18182406b:	0f 57 c0             	xorps  xmm0,xmm0
   18182406e:	0f 29 85 d0 00 00 00 	movaps XMMWORD PTR [rbp+0xd0],xmm0
   181824075:	48 c7 85 e0 00 00 00 	mov    QWORD PTR [rbp+0xe0],0x0
   18182407c:	00 00 00 00 
   181824080:	48 8b 4b 08          	mov    rcx,QWORD PTR [rbx+0x8]
   181824084:	48 8b 13             	mov    rdx,QWORD PTR [rbx]
   181824087:	49 89 c8             	mov    r8,rcx
   18182408a:	49 29 d0             	sub    r8,rdx
   18182408d:	49 c1 f8 03          	sar    r8,0x3
   181824091:	48 b8 cd cc cc cc cc 	movabs rax,0xcccccccccccccccd
   181824098:	cc cc cc 
   18182409b:	49 0f af c0          	imul   rax,r8
   18182409f:	48 89 45 e8          	mov    QWORD PTR [rbp-0x18],rax
   1818240a3:	48 39 d1             	cmp    rcx,rdx
   1818240a6:	74 1b                	je     0x1818240c3
   1818240a8:	48 c1 e8 3b          	shr    rax,0x3b
   1818240ac:	0f 85 4b 0d 00 00    	jne    0x181824dfd
   1818240b2:	48 8d 8d d0 00 00 00 	lea    rcx,[rbp+0xd0]
   1818240b9:	48 8d 55 e8          	lea    rdx,[rbp-0x18]
   1818240bd:	e8 7e 02 84 fe       	call   0x180064340
   1818240c2:	90                   	nop
   1818240c3:	c7 45 e8 ff ff ff ff 	mov    DWORD PTR [rbp-0x18],0xffffffff
   1818240ca:	0f 28 35 df 1a 52 07 	movaps xmm6,XMMWORD PTR [rip+0x7521adf]        # 0x188d45bb0
   1818240d1:	0f 11 75 ec          	movups XMMWORD PTR [rbp-0x14],xmm6
   1818240d5:	0f 11 75 fc          	movups XMMWORD PTR [rbp-0x4],xmm6
   1818240d9:	0f 11 75 0c          	movups XMMWORD PTR [rbp+0xc],xmm6
   1818240dd:	0f 11 75 18          	movups XMMWORD PTR [rbp+0x18],xmm6
   1818240e1:	c7 85 80 00 00 00 00 	mov    DWORD PTR [rbp+0x80],0x0
   1818240e8:	00 00 00 
   1818240eb:	48 8d 4d e8          	lea    rcx,[rbp-0x18]
   1818240ef:	48 8d 95 80 00 00 00 	lea    rdx,[rbp+0x80]
   1818240f6:	4c 8d 85 30 01 00 00 	lea    r8,[rbp+0x130]
   1818240fd:	e8 4e aa 7e fe       	call   0x18000eb50
   181824102:	90                   	nop
   181824103:	48 8b 33             	mov    rsi,QWORD PTR [rbx]
   181824106:	48 8b 5b 08          	mov    rbx,QWORD PTR [rbx+0x8]
   18182410a:	4c 8d bd 80 00 00 00 	lea    r15,[rbp+0x80]
   181824111:	0f 57 ff             	xorps  xmm7,xmm7
   181824114:	eb 27                	jmp    0x18182413d
   181824116:	48 8d 8d d0 00 00 00 	lea    rcx,[rbp+0xd0]
   18182411d:	4c 89 e2             	mov    rdx,r12
   181824120:	49 89 f0             	mov    r8,rsi
   181824123:	e8 f8 03 84 fe       	call   0x180064520
   181824128:	90                   	nop
   181824129:	48 8d 4d e8          	lea    rcx,[rbp-0x18]
   18182412d:	4c 89 fa             	mov    rdx,r15
   181824130:	49 89 f0             	mov    r8,rsi
   181824133:	e8 d8 5f 9a fe       	call   0x1801ca110
   181824138:	90                   	nop
   181824139:	48 83 c6 28          	add    rsi,0x28
   18182413d:	48 39 de             	cmp    rsi,rbx
   181824140:	0f 84 da 00 00 00    	je     0x181824220
   181824146:	83 7e 20 04          	cmp    DWORD PTR [rsi+0x20],0x4
   18182414a:	75 ed                	jne    0x181824139
   18182414c:	4c 8b a5 d8 00 00 00 	mov    r12,QWORD PTR [rbp+0xd8]
   181824153:	4c 3b a5 e0 00 00 00 	cmp    r12,QWORD PTR [rbp+0xe0]
   18182415a:	74 ba                	je     0x181824116
   18182415c:	41 0f 11 7c 24 10    	movups XMMWORD PTR [r12+0x10],xmm7
   181824162:	41 0f 11 3c 24       	movups XMMWORD PTR [r12],xmm7
   181824167:	48 83 7e 18 10       	cmp    QWORD PTR [rsi+0x18],0x10
   18182416c:	49 89 f5             	mov    r13,rsi
   18182416f:	72 03                	jb     0x181824174
   181824171:	4c 8b 2e             	mov    r13,QWORD PTR [rsi]
   181824174:	48 8b 7e 10          	mov    rdi,QWORD PTR [rsi+0x10]
   181824178:	48 85 ff             	test   rdi,rdi
   18182417b:	0f 88 76 0c 00 00    	js     0x181824df7
   181824181:	48 83 ff 0f          	cmp    rdi,0xf
   181824185:	77 22                	ja     0x1818241a9
   181824187:	49 89 7c 24 10       	mov    QWORD PTR [r12+0x10],rdi
   18182418c:	49 c7 44 24 18 0f 00 	mov    QWORD PTR [r12+0x18],0xf
   181824193:	00 00 
   181824195:	41 0f 10 45 00       	movups xmm0,XMMWORD PTR [r13+0x0]
   18182419a:	41 0f 11 04 24       	movups XMMWORD PTR [r12],xmm0
   18182419f:	48 83 85 d8 00 00 00 	add    QWORD PTR [rbp+0xd8],0x20
   1818241a6:	20 
   1818241a7:	eb 80                	jmp    0x181824129
   1818241a9:	48 89 f8             	mov    rax,rdi
   1818241ac:	48 83 c8 0f          	or     rax,0xf
   1818241b0:	48 83 f8 17          	cmp    rax,0x17
   1818241b4:	41 be 16 00 00 00    	mov    r14d,0x16
   1818241ba:	4c 0f 43 f0          	cmovae r14,rax
   1818241be:	48 3d ff 0f 00 00    	cmp    rax,0xfff
   1818241c4:	72 24                	jb     0x1818241ea
   1818241c6:	49 8d 4e 28          	lea    rcx,[r14+0x28]
   1818241ca:	e8 cd 76 c8 05       	call   0x1874ab89c
   1818241cf:	90                   	nop
   1818241d0:	48 85 c0             	test   rax,rax
   1818241d3:	0f 84 18 0c 00 00    	je     0x181824df1
   1818241d9:	48 89 c1             	mov    rcx,rax
   1818241dc:	48 83 c0 27          	add    rax,0x27
   1818241e0:	48 83 e0 e0          	and    rax,0xffffffffffffffe0
   1818241e4:	48 89 48 f8          	mov    QWORD PTR [rax-0x8],rcx
   1818241e8:	eb 0a                	jmp    0x1818241f4
   1818241ea:	49 8d 4e 01          	lea    rcx,[r14+0x1]
   1818241ee:	e8 a9 76 c8 05       	call   0x1874ab89c
   1818241f3:	90                   	nop
   1818241f4:	49 89 04 24          	mov    QWORD PTR [r12],rax
   1818241f8:	49 89 7c 24 10       	mov    QWORD PTR [r12+0x10],rdi
   1818241fd:	4d 89 74 24 18       	mov    QWORD PTR [r12+0x18],r14
   181824202:	48 ff c7             	inc    rdi
   181824205:	48 89 c1             	mov    rcx,rax
   181824208:	4c 89 ea             	mov    rdx,r13
   18182420b:	49 89 f8             	mov    r8,rdi
   18182420e:	e8 3d fe d1 05       	call   0x187544050
   181824213:	48 83 85 d8 00 00 00 	add    QWORD PTR [rbp+0xd8],0x20
   18182421a:	20 
   18182421b:	e9 09 ff ff ff       	jmp    0x181824129
   181824220:	48 8b 85 d0 00 00 00 	mov    rax,QWORD PTR [rbp+0xd0]
   181824227:	48 3b 85 d8 00 00 00 	cmp    rax,QWORD PTR [rbp+0xd8]
   18182422e:	0f 84 e0 0a 00 00    	je     0x181824d14
   181824234:	c7 85 80 00 00 00 ff 	mov    DWORD PTR [rbp+0x80],0xffffffff
   18182423b:	ff ff ff 
   18182423e:	0f 11 b5 84 00 00 00 	movups XMMWORD PTR [rbp+0x84],xmm6
   181824245:	0f 11 b5 94 00 00 00 	movups XMMWORD PTR [rbp+0x94],xmm6
   18182424c:	0f 11 b5 a4 00 00 00 	movups XMMWORD PTR [rbp+0xa4],xmm6
   181824253:	0f 11 b5 b0 00 00 00 	movups XMMWORD PTR [rbp+0xb0],xmm6
   18182425a:	48 8d 8d f0 00 00 00 	lea    rcx,[rbp+0xf0]
   181824261:	e8 ba 2f 82 fe       	call   0x180047220
   181824266:	90                   	nop
   181824267:	48 8b 8d f0 00 00 00 	mov    rcx,QWORD PTR [rbp+0xf0]
   18182426e:	48 8d 95 10 01 00 00 	lea    rdx,[rbp+0x110]
   181824275:	e8 c6 84 b4 fe       	call   0x18036c740
   18182427a:	90                   	nop
   18182427b:	48 8b 8d 10 01 00 00 	mov    rcx,QWORD PTR [rbp+0x110]
   181824282:	48 8d 95 30 01 00 00 	lea    rdx,[rbp+0x130]
   181824289:	e8 b2 c7 c3 fe       	call   0x180460a40
   18182428e:	90                   	nop
   18182428f:	48 8b 8d 30 01 00 00 	mov    rcx,QWORD PTR [rbp+0x130]
   181824296:	48 8d 95 80 00 00 00 	lea    rdx,[rbp+0x80]
   18182429d:	4c 8d 45 e8          	lea    r8,[rbp-0x18]
   1818242a1:	41 b1 01             	mov    r9b,0x1
   1818242a4:	e8 f7 ff 7f ff       	call   0x1810242a0
   1818242a9:	90                   	nop
   1818242aa:	48 8b b5 38 01 00 00 	mov    rsi,QWORD PTR [rbp+0x138]
   1818242b1:	48 85 f6             	test   rsi,rsi
   1818242b4:	74 1d                	je     0x1818242d3
   1818242b6:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   1818242ba:	75 17                	jne    0x1818242d3
   1818242bc:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1818242bf:	48 89 f1             	mov    rcx,rsi
   1818242c2:	ff 10                	call   QWORD PTR [rax]
   1818242c4:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   1818242c8:	75 09                	jne    0x1818242d3
   1818242ca:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1818242cd:	48 89 f1             	mov    rcx,rsi
   1818242d0:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1818242d3:	48 8b b5 18 01 00 00 	mov    rsi,QWORD PTR [rbp+0x118]
   1818242da:	48 85 f6             	test   rsi,rsi
   1818242dd:	74 1d                	je     0x1818242fc
   1818242df:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   1818242e3:	75 17                	jne    0x1818242fc
   1818242e5:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1818242e8:	48 89 f1             	mov    rcx,rsi
   1818242eb:	ff 10                	call   QWORD PTR [rax]
   1818242ed:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   1818242f1:	75 09                	jne    0x1818242fc
   1818242f3:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1818242f6:	48 89 f1             	mov    rcx,rsi
   1818242f9:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1818242fc:	48 8b b5 f8 00 00 00 	mov    rsi,QWORD PTR [rbp+0xf8]
   181824303:	48 85 f6             	test   rsi,rsi
   181824306:	74 1d                	je     0x181824325
   181824308:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   18182430c:	75 17                	jne    0x181824325
   18182430e:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   181824311:	48 89 f1             	mov    rcx,rsi
   181824314:	ff 10                	call   QWORD PTR [rax]
   181824316:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   18182431a:	75 09                	jne    0x181824325
   18182431c:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   18182431f:	48 89 f1             	mov    rcx,rsi
   181824322:	ff 50 08             	call   QWORD PTR [rax+0x8]
   181824325:	0f 57 ff             	xorps  xmm7,xmm7
   181824328:	0f 29 bd 30 01 00 00 	movaps XMMWORD PTR [rbp+0x130],xmm7
   18182432f:	48 c7 85 40 01 00 00 	mov    QWORD PTR [rbp+0x140],0x0
   181824336:	00 00 00 00 
   18182433a:	48 c7 85 48 01 00 00 	mov    QWORD PTR [rbp+0x148],0xf
   181824341:	0f 00 00 00 
   181824345:	48 8b 85 d8 00 00 00 	mov    rax,QWORD PTR [rbp+0xd8]
   18182434c:	48 2b 85 d0 00 00 00 	sub    rax,QWORD PTR [rbp+0xd0]
   181824353:	48 c1 f8 05          	sar    rax,0x5
   181824357:	48 89 45 68          	mov    QWORD PTR [rbp+0x68],rax
   18182435b:	48 ff c8             	dec    rax
   18182435e:	48 89 45 70          	mov    QWORD PTR [rbp+0x70],rax
   181824362:	31 c0                	xor    eax,eax
   181824364:	48 bb b3 01 00 00 00 	movabs rbx,0x100000001b3
   18182436b:	01 00 00 
   18182436e:	eb 15                	jmp    0x181824385
   181824370:	48 83 c0 28          	add    rax,0x28
   181824374:	48 89 c2             	mov    rdx,rax
   181824377:	4c 89 c1             	mov    rcx,r8
   18182437a:	e8 61 75 c8 05       	call   0x1874ab8e0
   18182437f:	48 8b 45 60          	mov    rax,QWORD PTR [rbp+0x60]
   181824383:	ff c0                	inc    eax
   181824385:	48 63 c8             	movsxd rcx,eax
   181824388:	48 39 4d 68          	cmp    QWORD PTR [rbp+0x68],rcx
   18182438c:	0f 86 4a 05 00 00    	jbe    0x1818248dc
   181824392:	48 89 45 60          	mov    QWORD PTR [rbp+0x60],rax
   181824396:	48 8b 85 d0 00 00 00 	mov    rax,QWORD PTR [rbp+0xd0]
   18182439d:	48 89 4d 58          	mov    QWORD PTR [rbp+0x58],rcx
   1818243a1:	48 c1 e1 05          	shl    rcx,0x5
   1818243a5:	4c 8d 24 08          	lea    r12,[rax+rcx*1]
   1818243a9:	48 83 7c 08 18 10    	cmp    QWORD PTR [rax+rcx*1+0x18],0x10
   1818243af:	4d 89 e5             	mov    r13,r12
   1818243b2:	72 04                	jb     0x1818243b8
   1818243b4:	4c 8b 2c 08          	mov    r13,QWORD PTR [rax+rcx*1]
   1818243b8:	48 8b 74 08 10       	mov    rsi,QWORD PTR [rax+rcx*1+0x10]
   1818243bd:	48 b9 25 23 22 84 e4 	movabs rcx,0xcbf29ce484222325
   1818243c4:	9c f2 cb 
   1818243c7:	48 85 f6             	test   rsi,rsi
   1818243ca:	0f 84 84 00 00 00    	je     0x181824454
   1818243d0:	89 f0                	mov    eax,esi
   1818243d2:	83 e0 03             	and    eax,0x3
   1818243d5:	48 83 fe 04          	cmp    rsi,0x4
   1818243d9:	73 05                	jae    0x1818243e0
   1818243db:	31 d2                	xor    edx,edx
   1818243dd:	eb 53                	jmp    0x181824432
   1818243df:	90                   	nop
   1818243e0:	49 89 f0             	mov    r8,rsi
   1818243e3:	49 83 e0 fc          	and    r8,0xfffffffffffffffc
   1818243e7:	31 d2                	xor    edx,edx
   1818243e9:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
   1818243f0:	45 0f b6 4c 15 00    	movzx  r9d,BYTE PTR [r13+rdx*1+0x0]
   1818243f6:	4c 31 c9             	xor    rcx,r9
   1818243f9:	48 0f af cb          	imul   rcx,rbx
   1818243fd:	45 0f b6 4c 15 01    	movzx  r9d,BYTE PTR [r13+rdx*1+0x1]
   181824403:	49 31 c9             	xor    r9,rcx
   181824406:	4c 0f af cb          	imul   r9,rbx
   18182440a:	45 0f b6 54 15 02    	movzx  r10d,BYTE PTR [r13+rdx*1+0x2]
   181824410:	4d 31 ca             	xor    r10,r9
   181824413:	4c 0f af d3          	imul   r10,rbx
   181824417:	41 0f b6 4c 15 03    	movzx  ecx,BYTE PTR [r13+rdx*1+0x3]
   18182441d:	4c 31 d1             	xor    rcx,r10
   181824420:	48 0f af cb          	imul   rcx,rbx
   181824424:	48 83 c2 04          	add    rdx,0x4
   181824428:	49 39 d0             	cmp    r8,rdx
   18182442b:	75 c3                	jne    0x1818243f0
   18182442d:	48 85 c0             	test   rax,rax
   181824430:	74 22                	je     0x181824454
   181824432:	4c 01 ea             	add    rdx,r13
   181824435:	45 31 c0             	xor    r8d,r8d
   181824438:	0f 1f 84 00 00 00 00 	nop    DWORD PTR [rax+rax*1+0x0]
   18182443f:	00 
   181824440:	46 0f b6 0c 02       	movzx  r9d,BYTE PTR [rdx+r8*1]
   181824445:	4c 31 c9             	xor    rcx,r9
   181824448:	48 0f af cb          	imul   rcx,rbx
   18182444c:	49 ff c0             	inc    r8
   18182444f:	4c 39 c0             	cmp    rax,r8
   181824452:	75 ec                	jne    0x181824440
   181824454:	48 23 8d b0 00 00 00 	and    rcx,QWORD PTR [rbp+0xb0]
   18182445b:	4c 8b bd 88 00 00 00 	mov    r15,QWORD PTR [rbp+0x88]
   181824462:	48 8b 85 98 00 00 00 	mov    rax,QWORD PTR [rbp+0x98]
   181824469:	48 c1 e1 04          	shl    rcx,0x4
   18182446d:	48 8b 7c 08 08       	mov    rdi,QWORD PTR [rax+rcx*1+0x8]
   181824472:	4c 39 ff             	cmp    rdi,r15
   181824475:	0f 84 95 00 00 00    	je     0x181824510
   18182447b:	4c 8b 34 08          	mov    r14,QWORD PTR [rax+rcx*1]
   18182447f:	48 85 f6             	test   rsi,rsi
   181824482:	74 60                	je     0x1818244e4
   181824484:	66 66 66 2e 0f 1f 84 	data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
   18182448b:	00 00 00 00 00 
   181824490:	48 3b 77 20          	cmp    rsi,QWORD PTR [rdi+0x20]
   181824494:	75 2d                	jne    0x1818244c3
   181824496:	48 83 7f 28 10       	cmp    QWORD PTR [rdi+0x28],0x10
   18182449b:	72 13                	jb     0x1818244b0
   18182449d:	48 8b 57 10          	mov    rdx,QWORD PTR [rdi+0x10]
   1818244a1:	eb 11                	jmp    0x1818244b4
   1818244a3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
   1818244aa:	84 00 00 00 00 00 
   1818244b0:	48 8d 57 10          	lea    rdx,[rdi+0x10]
   1818244b4:	4c 89 e9             	mov    rcx,r13
   1818244b7:	49 89 f0             	mov    r8,rsi
   1818244ba:	e8 91 fa d1 05       	call   0x187543f50
   1818244bf:	85 c0                	test   eax,eax
   1818244c1:	74 3d                	je     0x181824500
   1818244c3:	4c 39 f7             	cmp    rdi,r14
   1818244c6:	74 48                	je     0x181824510
   1818244c8:	48 8b 7f 08          	mov    rdi,QWORD PTR [rdi+0x8]
   1818244cc:	48 3b 77 20          	cmp    rsi,QWORD PTR [rdi+0x20]
   1818244d0:	74 c4                	je     0x181824496
   1818244d2:	eb ef                	jmp    0x1818244c3
   1818244d4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
   1818244db:	00 00 00 00 00 
   1818244e0:	48 8b 7f 08          	mov    rdi,QWORD PTR [rdi+0x8]
   1818244e4:	48 83 7f 20 00       	cmp    QWORD PTR [rdi+0x20],0x0
   1818244e9:	74 15                	je     0x181824500
   1818244eb:	4c 39 f7             	cmp    rdi,r14
   1818244ee:	75 f0                	jne    0x1818244e0
   1818244f0:	eb 1e                	jmp    0x181824510
   1818244f2:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
   1818244f9:	1f 84 00 00 00 00 00 
   181824500:	48 85 ff             	test   rdi,rdi
   181824503:	75 0e                	jne    0x181824513
   181824505:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
   18182450c:	00 00 00 00 
   181824510:	4c 89 ff             	mov    rdi,r15
   181824513:	0f 29 bd 10 01 00 00 	movaps XMMWORD PTR [rbp+0x110],xmm7
   18182451a:	48 c7 85 20 01 00 00 	mov    QWORD PTR [rbp+0x120],0x0
   181824521:	00 00 00 00 
   181824525:	48 c7 85 28 01 00 00 	mov    QWORD PTR [rbp+0x128],0xf
   18182452c:	0f 00 00 00 
   181824530:	4c 39 ff             	cmp    rdi,r15
   181824533:	74 5b                	je     0x181824590
   181824535:	4c 8d 4f 30          	lea    r9,[rdi+0x30]
   181824539:	4c 8d bd 10 01 00 00 	lea    r15,[rbp+0x110]
   181824540:	4d 39 cf             	cmp    r15,r9
   181824543:	4c 8d b5 f0 00 00 00 	lea    r14,[rbp+0xf0]
   18182454a:	4c 8d ad 30 01 00 00 	lea    r13,[rbp+0x130]
   181824551:	74 2a                	je     0x18182457d
   181824553:	48 8b 77 40          	mov    rsi,QWORD PTR [rdi+0x40]
   181824557:	48 85 f6             	test   rsi,rsi
   18182455a:	74 21                	je     0x18182457d
   18182455c:	48 83 7f 48 10       	cmp    QWORD PTR [rdi+0x48],0x10
   181824561:	72 04                	jb     0x181824567
   181824563:	4c 8b 4f 30          	mov    r9,QWORD PTR [rdi+0x30]
   181824567:	48 83 fe 0f          	cmp    rsi,0xf
   18182456b:	0f 86 9a 00 00 00    	jbe    0x18182460b
   181824571:	4c 89 f9             	mov    rcx,r15
   181824574:	48 89 f2             	mov    rdx,rsi
   181824577:	e8 d4 9b 81 fe       	call   0x18003e150
   18182457c:	90                   	nop
   18182457d:	4d 39 e7             	cmp    r15,r12
   181824580:	0f 85 a7 00 00 00    	jne    0x18182462d
   181824586:	e9 d5 00 00 00       	jmp    0x181824660
   18182458b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]
   181824590:	b8 0f 00 00 00       	mov    eax,0xf
   181824595:	4c 8d bd 10 01 00 00 	lea    r15,[rbp+0x110]
   18182459c:	4d 39 e7             	cmp    r15,r12
   18182459f:	4c 8d b5 f0 00 00 00 	lea    r14,[rbp+0xf0]
   1818245a6:	4c 8d ad 30 01 00 00 	lea    r13,[rbp+0x130]
   1818245ad:	0f 84 ad 00 00 00    	je     0x181824660
   1818245b3:	49 83 7c 24 18 10    	cmp    QWORD PTR [r12+0x18],0x10
   1818245b9:	4d 89 e1             	mov    r9,r12
   1818245bc:	72 04                	jb     0x1818245c2
   1818245be:	4d 8b 0c 24          	mov    r9,QWORD PTR [r12]
   1818245c2:	49 8b 74 24 10       	mov    rsi,QWORD PTR [r12+0x10]
   1818245c7:	48 39 c6             	cmp    rsi,rax
   1818245ca:	76 14                	jbe    0x1818245e0
   1818245cc:	4c 89 f9             	mov    rcx,r15
   1818245cf:	48 89 f2             	mov    rdx,rsi
   1818245d2:	e8 79 9b 81 fe       	call   0x18003e150
   1818245d7:	90                   	nop
   1818245d8:	e9 83 00 00 00       	jmp    0x181824660
   1818245dd:	0f 1f 00             	nop    DWORD PTR [rax]
   1818245e0:	4c 89 ff             	mov    rdi,r15
   1818245e3:	48 83 f8 10          	cmp    rax,0x10
   1818245e7:	72 07                	jb     0x1818245f0
   1818245e9:	48 8b bd 10 01 00 00 	mov    rdi,QWORD PTR [rbp+0x110]
   1818245f0:	48 89 b5 20 01 00 00 	mov    QWORD PTR [rbp+0x120],rsi
   1818245f7:	48 89 f9             	mov    rcx,rdi
   1818245fa:	4c 89 ca             	mov    rdx,r9
   1818245fd:	49 89 f0             	mov    r8,rsi
   181824600:	e8 4b fa d1 05       	call   0x187544050
   181824605:	c6 04 37 00          	mov    BYTE PTR [rdi+rsi*1],0x0
   181824609:	eb 55                	jmp    0x181824660
   18182460b:	48 89 b5 20 01 00 00 	mov    QWORD PTR [rbp+0x120],rsi
   181824612:	4c 89 f9             	mov    rcx,r15
   181824615:	4c 89 ca             	mov    rdx,r9
   181824618:	49 89 f0             	mov    r8,rsi
   18182461b:	e8 30 fa d1 05       	call   0x187544050
   181824620:	c6 84 35 10 01 00 00 	mov    BYTE PTR [rbp+rsi*1+0x110],0x0
   181824627:	00 
   181824628:	4d 39 e7             	cmp    r15,r12
   18182462b:	74 33                	je     0x181824660
   18182462d:	48 83 bd 20 01 00 00 	cmp    QWORD PTR [rbp+0x120],0x0
   181824634:	00 
   181824635:	75 29                	jne    0x181824660
   181824637:	48 8b 85 28 01 00 00 	mov    rax,QWORD PTR [rbp+0x128]
   18182463e:	49 83 7c 24 18 10    	cmp    QWORD PTR [r12+0x18],0x10
   181824644:	4d 89 e1             	mov    r9,r12
   181824647:	0f 83 71 ff ff ff    	jae    0x1818245be
   18182464d:	e9 70 ff ff ff       	jmp    0x1818245c2
   181824652:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nop WORD PTR [rax+rax*1+0x0]
   181824659:	1f 84 00 00 00 00 00 
   181824660:	4c 89 f1             	mov    rcx,r14
   181824663:	4c 89 e2             	mov    rdx,r12
   181824666:	4d 89 f8             	mov    r8,r15
   181824669:	e8 a2 53 f5 fe       	call   0x180779a10
   18182466e:	90                   	nop
   18182466f:	48 83 bd 08 01 00 00 	cmp    QWORD PTR [rbp+0x108],0x10
   181824676:	10 
   181824677:	72 07                	jb     0x181824680
   181824679:	4c 8b b5 f0 00 00 00 	mov    r14,QWORD PTR [rbp+0xf0]
   181824680:	48 8b 85 00 01 00 00 	mov    rax,QWORD PTR [rbp+0x100]
   181824687:	48 8b 8d 40 01 00 00 	mov    rcx,QWORD PTR [rbp+0x140]
   18182468e:	48 8b 95 48 01 00 00 	mov    rdx,QWORD PTR [rbp+0x148]
   181824695:	49 89 d0             	mov    r8,rdx
   181824698:	49 29 c8             	sub    r8,rcx
   18182469b:	4c 39 c0             	cmp    rax,r8
   18182469e:	0f 86 ac 00 00 00    	jbe    0x181824750
   1818246a4:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1818246a9:	4c 89 e9             	mov    rcx,r13
   1818246ac:	48 89 c2             	mov    rdx,rax
   1818246af:	4d 89 f1             	mov    r9,r14
   1818246b2:	e8 09 4d 7e fe       	call   0x1800093c0
   1818246b7:	90                   	nop
   1818246b8:	49 39 c5             	cmp    r13,rax
   1818246bb:	74 33                	je     0x1818246f0
   1818246bd:	48 83 78 18 10       	cmp    QWORD PTR [rax+0x18],0x10
   1818246c2:	49 89 c1             	mov    r9,rax
   1818246c5:	72 03                	jb     0x1818246ca
   1818246c7:	4c 8b 08             	mov    r9,QWORD PTR [rax]
   1818246ca:	48 8b 70 10          	mov    rsi,QWORD PTR [rax+0x10]
   1818246ce:	48 8b 85 48 01 00 00 	mov    rax,QWORD PTR [rbp+0x148]
   1818246d5:	48 39 c6             	cmp    rsi,rax
   1818246d8:	0f 86 98 00 00 00    	jbe    0x181824776
   1818246de:	4c 89 e9             	mov    rcx,r13
   1818246e1:	48 89 f2             	mov    rdx,rsi
   1818246e4:	e8 67 9a 81 fe       	call   0x18003e150
   1818246e9:	90                   	nop
   1818246ea:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]
   1818246f0:	48 8b 85 08 01 00 00 	mov    rax,QWORD PTR [rbp+0x108]
   1818246f7:	48 83 f8 10          	cmp    rax,0x10
   1818246fb:	0f 82 af 00 00 00    	jb     0x1818247b0
   181824701:	48 8b 8d f0 00 00 00 	mov    rcx,QWORD PTR [rbp+0xf0]
   181824708:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18182470c:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   181824713:	72 1f                	jb     0x181824734
   181824715:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   181824719:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18182471d:	4c 29 c1             	sub    rcx,r8
   181824720:	48 83 f9 20          	cmp    rcx,0x20
   181824724:	0f 83 c7 06 00 00    	jae    0x181824df1
   18182472a:	48 83 c0 28          	add    rax,0x28
   18182472e:	48 89 c2             	mov    rdx,rax
   181824731:	4c 89 c1             	mov    rcx,r8
   181824734:	e8 a7 71 c8 05       	call   0x1874ab8e0
   181824739:	48 8b 45 58          	mov    rax,QWORD PTR [rbp+0x58]
   18182473d:	48 39 45 70          	cmp    QWORD PTR [rbp+0x70],rax
   181824741:	0f 84 17 01 00 00    	je     0x18182485e
   181824747:	eb 75                	jmp    0x1818247be
   181824749:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
   181824750:	48 8d 34 01          	lea    rsi,[rcx+rax*1]
   181824754:	48 89 b5 40 01 00 00 	mov    QWORD PTR [rbp+0x140],rsi
   18182475b:	4c 89 ef             	mov    rdi,r13
   18182475e:	48 83 fa 10          	cmp    rdx,0x10
   181824762:	72 07                	jb     0x18182476b
   181824764:	48 8b bd 30 01 00 00 	mov    rdi,QWORD PTR [rbp+0x130]
   18182476b:	48 01 f9             	add    rcx,rdi
   18182476e:	4c 89 f2             	mov    rdx,r14
   181824771:	49 89 c0             	mov    r8,rax
   181824774:	eb 20                	jmp    0x181824796
   181824776:	4c 89 ef             	mov    rdi,r13
   181824779:	48 83 f8 10          	cmp    rax,0x10
   18182477d:	72 07                	jb     0x181824786
   18182477f:	48 8b bd 30 01 00 00 	mov    rdi,QWORD PTR [rbp+0x130]
   181824786:	48 89 b5 40 01 00 00 	mov    QWORD PTR [rbp+0x140],rsi
   18182478d:	48 89 f9             	mov    rcx,rdi
   181824790:	4c 89 ca             	mov    rdx,r9
   181824793:	49 89 f0             	mov    r8,rsi
   181824796:	e8 b5 f8 d1 05       	call   0x187544050
   18182479b:	c6 04 37 00          	mov    BYTE PTR [rdi+rsi*1],0x0
   18182479f:	48 8b 85 08 01 00 00 	mov    rax,QWORD PTR [rbp+0x108]
   1818247a6:	48 83 f8 10          	cmp    rax,0x10
   1818247aa:	0f 83 51 ff ff ff    	jae    0x181824701
   1818247b0:	48 8b 45 58          	mov    rax,QWORD PTR [rbp+0x58]
   1818247b4:	48 39 45 70          	cmp    QWORD PTR [rbp+0x70],rax
   1818247b8:	0f 84 a0 00 00 00    	je     0x18182485e
   1818247be:	e8 bd f0 89 fe       	call   0x1800c3880
   1818247c3:	90                   	nop
   1818247c4:	48 89 c6             	mov    rsi,rax
   1818247c7:	48 89 c1             	mov    rcx,rax
   1818247ca:	e8 d1 fd cf 05       	call   0x1875245a0
   1818247cf:	48 8b 8d 40 01 00 00 	mov    rcx,QWORD PTR [rbp+0x140]
   1818247d6:	48 8b 95 48 01 00 00 	mov    rdx,QWORD PTR [rbp+0x148]
   1818247dd:	49 89 d0             	mov    r8,rdx
   1818247e0:	49 29 c8             	sub    r8,rcx
   1818247e3:	4c 39 c0             	cmp    rax,r8
   1818247e6:	76 48                	jbe    0x181824830
   1818247e8:	48 89 44 24 20       	mov    QWORD PTR [rsp+0x20],rax
   1818247ed:	4c 89 e9             	mov    rcx,r13
   1818247f0:	48 89 c2             	mov    rdx,rax
   1818247f3:	49 89 f1             	mov    r9,rsi
   1818247f6:	e8 c5 4b 7e fe       	call   0x1800093c0
   1818247fb:	90                   	nop
   1818247fc:	49 39 c5             	cmp    r13,rax
   1818247ff:	74 5d                	je     0x18182485e
   181824801:	48 83 78 18 10       	cmp    QWORD PTR [rax+0x18],0x10
   181824806:	49 89 c1             	mov    r9,rax
   181824809:	72 03                	jb     0x18182480e
   18182480b:	4c 8b 08             	mov    r9,QWORD PTR [rax]
   18182480e:	48 8b 70 10          	mov    rsi,QWORD PTR [rax+0x10]
   181824812:	48 8b 85 48 01 00 00 	mov    rax,QWORD PTR [rbp+0x148]
   181824819:	48 39 c6             	cmp    rsi,rax
   18182481c:	0f 86 7f 00 00 00    	jbe    0x1818248a1
   181824822:	4c 89 e9             	mov    rcx,r13
   181824825:	48 89 f2             	mov    rdx,rsi
   181824828:	e8 23 99 81 fe       	call   0x18003e150
   18182482d:	90                   	nop
   18182482e:	eb 2e                	jmp    0x18182485e
   181824830:	48 89 c7             	mov    rdi,rax
   181824833:	48 01 cf             	add    rdi,rcx
   181824836:	48 89 bd 40 01 00 00 	mov    QWORD PTR [rbp+0x140],rdi
   18182483d:	48 83 fa 10          	cmp    rdx,0x10
   181824841:	72 07                	jb     0x18182484a
   181824843:	4c 8b ad 30 01 00 00 	mov    r13,QWORD PTR [rbp+0x130]
   18182484a:	4c 01 e9             	add    rcx,r13
   18182484d:	48 89 f2             	mov    rdx,rsi
   181824850:	49 89 c0             	mov    r8,rax
   181824853:	e8 f8 f7 d1 05       	call   0x187544050
   181824858:	41 c6 44 3d 00 00    	mov    BYTE PTR [r13+rdi*1+0x0],0x0
   18182485e:	48 8b 85 28 01 00 00 	mov    rax,QWORD PTR [rbp+0x128]
   181824865:	48 83 f8 10          	cmp    rax,0x10
   181824869:	0f 82 10 fb ff ff    	jb     0x18182437f
   18182486f:	48 8b 8d 10 01 00 00 	mov    rcx,QWORD PTR [rbp+0x110]
   181824876:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18182487a:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   181824881:	0f 82 f3 fa ff ff    	jb     0x18182437a
   181824887:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18182488b:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18182488f:	4c 29 c1             	sub    rcx,r8
   181824892:	48 83 f9 20          	cmp    rcx,0x20
   181824896:	0f 82 d4 fa ff ff    	jb     0x181824370
   18182489c:	e9 50 05 00 00       	jmp    0x181824df1
   1818248a1:	48 83 f8 10          	cmp    rax,0x10
   1818248a5:	72 07                	jb     0x1818248ae
   1818248a7:	4c 8b ad 30 01 00 00 	mov    r13,QWORD PTR [rbp+0x130]
   1818248ae:	48 89 b5 40 01 00 00 	mov    QWORD PTR [rbp+0x140],rsi
   1818248b5:	4c 89 e9             	mov    rcx,r13
   1818248b8:	4c 89 ca             	mov    rdx,r9
   1818248bb:	49 89 f0             	mov    r8,rsi
   1818248be:	e8 8d f7 d1 05       	call   0x187544050
   1818248c3:	41 c6 44 35 00 00    	mov    BYTE PTR [r13+rsi*1+0x0],0x0
   1818248c9:	48 8b 85 28 01 00 00 	mov    rax,QWORD PTR [rbp+0x128]
   1818248d0:	48 83 f8 10          	cmp    rax,0x10
   1818248d4:	0f 82 a5 fa ff ff    	jb     0x18182437f
   1818248da:	eb 93                	jmp    0x18182486f
   1818248dc:	0f 29 b5 f0 00 00 00 	movaps XMMWORD PTR [rbp+0xf0],xmm6
   1818248e3:	48 8d 8d f0 00 00 00 	lea    rcx,[rbp+0xf0]
   1818248ea:	e8 81 03 ed fe       	call   0x1806f4c70
   1818248ef:	90                   	nop
   1818248f0:	48 8b 85 f0 00 00 00 	mov    rax,QWORD PTR [rbp+0xf0]
   1818248f7:	48 8d b0 b0 00 00 00 	lea    rsi,[rax+0xb0]
   1818248fe:	4c 8b 4d 78          	mov    r9,QWORD PTR [rbp+0x78]
   181824902:	4c 39 ce             	cmp    rsi,r9
   181824905:	48 8d 9d 88 00 00 00 	lea    rbx,[rbp+0x88]
   18182490c:	74 4a                	je     0x181824958
   18182490e:	49 8b 79 10          	mov    rdi,QWORD PTR [r9+0x10]
   181824912:	49 83 79 18 10       	cmp    QWORD PTR [r9+0x18],0x10
   181824917:	72 03                	jb     0x18182491c
   181824919:	4d 8b 09             	mov    r9,QWORD PTR [r9]
   18182491c:	48 8b 88 c8 00 00 00 	mov    rcx,QWORD PTR [rax+0xc8]
   181824923:	48 39 cf             	cmp    rdi,rcx
   181824926:	76 0e                	jbe    0x181824936
   181824928:	48 89 f1             	mov    rcx,rsi
   18182492b:	48 89 fa             	mov    rdx,rdi
   18182492e:	e8 1d 98 81 fe       	call   0x18003e150
   181824933:	90                   	nop
   181824934:	eb 22                	jmp    0x181824958
   181824936:	48 83 f9 10          	cmp    rcx,0x10
   18182493a:	72 03                	jb     0x18182493f
   18182493c:	48 8b 36             	mov    rsi,QWORD PTR [rsi]
   18182493f:	48 89 b8 c0 00 00 00 	mov    QWORD PTR [rax+0xc0],rdi
   181824946:	48 89 f1             	mov    rcx,rsi
   181824949:	4c 89 ca             	mov    rdx,r9
   18182494c:	49 89 f8             	mov    r8,rdi
   18182494f:	e8 fc f6 d1 05       	call   0x187544050
   181824954:	c6 04 3e 00          	mov    BYTE PTR [rsi+rdi*1],0x0
   181824958:	48 8b 85 f0 00 00 00 	mov    rax,QWORD PTR [rbp+0xf0]
   18182495f:	c7 80 18 01 00 00 10 	mov    DWORD PTR [rax+0x118],0x2710
   181824966:	27 00 00 
   181824969:	48 8b b5 30 01 00 00 	mov    rsi,QWORD PTR [rbp+0x130]
   181824970:	48 8b bd 48 01 00 00 	mov    rdi,QWORD PTR [rbp+0x148]
   181824977:	e8 24 a5 89 fe       	call   0x1800beea0
   18182497c:	90                   	nop
   18182497d:	48 83 ff 10          	cmp    rdi,0x10
   181824981:	4c 8d 85 30 01 00 00 	lea    r8,[rbp+0x130]
   181824988:	4c 0f 43 c6          	cmovae r8,rsi
   18182498c:	48 8d b5 10 01 00 00 	lea    rsi,[rbp+0x110]
   181824993:	48 89 f1             	mov    rcx,rsi
   181824996:	48 89 c2             	mov    rdx,rax
   181824999:	e8 a2 7a d5 fe       	call   0x18057c440
   18182499e:	90                   	nop
   18182499f:	48 8b 85 f0 00 00 00 	mov    rax,QWORD PTR [rbp+0xf0]
   1818249a6:	48 8d b8 58 07 00 00 	lea    rdi,[rax+0x758]
   1818249ad:	48 39 f7             	cmp    rdi,rsi
   1818249b0:	74 58                	je     0x181824a0a
   1818249b2:	48 8b 80 70 07 00 00 	mov    rax,QWORD PTR [rax+0x770]
   1818249b9:	48 83 f8 10          	cmp    rax,0x10
   1818249bd:	72 34                	jb     0x1818249f3
   1818249bf:	48 8b 0f             	mov    rcx,QWORD PTR [rdi]
   1818249c2:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1818249c6:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1818249cd:	72 1f                	jb     0x1818249ee
   1818249cf:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1818249d3:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1818249d7:	4c 29 c1             	sub    rcx,r8
   1818249da:	48 83 f9 20          	cmp    rcx,0x20
   1818249de:	0f 83 0d 04 00 00    	jae    0x181824df1
   1818249e4:	48 83 c0 28          	add    rax,0x28
   1818249e8:	48 89 c2             	mov    rdx,rax
   1818249eb:	4c 89 c1             	mov    rcx,r8
   1818249ee:	e8 ed 6e c8 05       	call   0x1874ab8e0
   1818249f3:	0f 10 85 10 01 00 00 	movups xmm0,XMMWORD PTR [rbp+0x110]
   1818249fa:	0f 10 8d 20 01 00 00 	movups xmm1,XMMWORD PTR [rbp+0x120]
   181824a01:	0f 11 4f 10          	movups XMMWORD PTR [rdi+0x10],xmm1
   181824a05:	0f 11 07             	movups XMMWORD PTR [rdi],xmm0
   181824a08:	eb 45                	jmp    0x181824a4f
   181824a0a:	48 8b 85 28 01 00 00 	mov    rax,QWORD PTR [rbp+0x128]
   181824a11:	48 83 f8 10          	cmp    rax,0x10
   181824a15:	72 38                	jb     0x181824a4f
   181824a17:	48 8b 8d 10 01 00 00 	mov    rcx,QWORD PTR [rbp+0x110]
   181824a1e:	48 8d 50 01          	lea    rdx,[rax+0x1]
   181824a22:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   181824a29:	72 1f                	jb     0x181824a4a
   181824a2b:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   181824a2f:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   181824a33:	4c 29 c1             	sub    rcx,r8
   181824a36:	48 83 f9 20          	cmp    rcx,0x20
   181824a3a:	0f 83 b1 03 00 00    	jae    0x181824df1
   181824a40:	48 83 c0 28          	add    rax,0x28
   181824a44:	48 89 c2             	mov    rdx,rax
   181824a47:	4c 89 c1             	mov    rcx,r8
   181824a4a:	e8 91 6e c8 05       	call   0x1874ab8e0
   181824a4f:	48 8b 85 f0 00 00 00 	mov    rax,QWORD PTR [rbp+0xf0]
   181824a56:	c7 80 9c 00 00 00 01 	mov    DWORD PTR [rax+0x9c],0x1
   181824a5d:	00 00 00 
   181824a60:	48 8d 4d 48          	lea    rcx,[rbp+0x48]
   181824a64:	e8 b7 27 82 fe       	call   0x180047220
   181824a69:	90                   	nop
   181824a6a:	48 8b 4d 48          	mov    rcx,QWORD PTR [rbp+0x48]
   181824a6e:	48 8d 55 38          	lea    rdx,[rbp+0x38]
   181824a72:	e8 c9 7c b4 fe       	call   0x18036c740
   181824a77:	90                   	nop
   181824a78:	48 8b 4d 38          	mov    rcx,QWORD PTR [rbp+0x38]
   181824a7c:	48 8d 55 28          	lea    rdx,[rbp+0x28]
   181824a80:	e8 0b 03 ed fe       	call   0x1806f4d90
   181824a85:	90                   	nop
   181824a86:	48 8b 4d 28          	mov    rcx,QWORD PTR [rbp+0x28]
   181824a8a:	0f 57 c0             	xorps  xmm0,xmm0
   181824a8d:	0f 29 85 c0 00 00 00 	movaps XMMWORD PTR [rbp+0xc0],xmm0
   181824a94:	48 8b 85 f8 00 00 00 	mov    rax,QWORD PTR [rbp+0xf8]
   181824a9b:	48 85 c0             	test   rax,rax
   181824a9e:	74 40                	je     0x181824ae0
   181824aa0:	f0 ff 40 08          	lock inc DWORD PTR [rax+0x8]
   181824aa4:	48 8b 85 f0 00 00 00 	mov    rax,QWORD PTR [rbp+0xf0]
   181824aab:	48 8b 95 f8 00 00 00 	mov    rdx,QWORD PTR [rbp+0xf8]
   181824ab2:	48 89 85 c0 00 00 00 	mov    QWORD PTR [rbp+0xc0],rax
   181824ab9:	48 89 95 c8 00 00 00 	mov    QWORD PTR [rbp+0xc8],rdx
   181824ac0:	0f 29 85 10 01 00 00 	movaps XMMWORD PTR [rbp+0x110],xmm0
   181824ac7:	48 85 d2             	test   rdx,rdx
   181824aca:	74 2d                	je     0x181824af9
   181824acc:	f0 ff 42 08          	lock inc DWORD PTR [rdx+0x8]
   181824ad0:	48 8b 85 c0 00 00 00 	mov    rax,QWORD PTR [rbp+0xc0]
   181824ad7:	48 8b 95 c8 00 00 00 	mov    rdx,QWORD PTR [rbp+0xc8]
   181824ade:	eb 1b                	jmp    0x181824afb
   181824ae0:	48 8b 85 f0 00 00 00 	mov    rax,QWORD PTR [rbp+0xf0]
   181824ae7:	48 89 85 c0 00 00 00 	mov    QWORD PTR [rbp+0xc0],rax
   181824aee:	48 c7 85 c8 00 00 00 	mov    QWORD PTR [rbp+0xc8],0x0
   181824af5:	00 00 00 00 
   181824af9:	31 d2                	xor    edx,edx
   181824afb:	48 89 85 10 01 00 00 	mov    QWORD PTR [rbp+0x110],rax
   181824b02:	48 89 95 18 01 00 00 	mov    QWORD PTR [rbp+0x118],rdx
   181824b09:	48 8d 55 b0          	lea    rdx,[rbp-0x50]
   181824b0d:	4c 8d 85 10 01 00 00 	lea    r8,[rbp+0x110]
   181824b14:	45 31 c9             	xor    r9d,r9d
   181824b17:	e8 e4 a5 f6 ff       	call   0x18178f100
   181824b1c:	90                   	nop
   181824b1d:	48 8b b5 c8 00 00 00 	mov    rsi,QWORD PTR [rbp+0xc8]
   181824b24:	48 85 f6             	test   rsi,rsi
   181824b27:	74 1d                	je     0x181824b46
   181824b29:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   181824b2d:	75 17                	jne    0x181824b46
   181824b2f:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   181824b32:	48 89 f1             	mov    rcx,rsi
   181824b35:	ff 10                	call   QWORD PTR [rax]
   181824b37:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   181824b3b:	75 09                	jne    0x181824b46
   181824b3d:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   181824b40:	48 89 f1             	mov    rcx,rsi
   181824b43:	ff 50 08             	call   QWORD PTR [rax+0x8]
   181824b46:	48 8b 75 e0          	mov    rsi,QWORD PTR [rbp-0x20]
   181824b4a:	48 85 f6             	test   rsi,rsi
   181824b4d:	74 1d                	je     0x181824b6c
   181824b4f:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   181824b53:	75 17                	jne    0x181824b6c
   181824b55:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   181824b58:	48 89 f1             	mov    rcx,rsi
   181824b5b:	ff 10                	call   QWORD PTR [rax]
   181824b5d:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   181824b61:	75 09                	jne    0x181824b6c
   181824b63:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   181824b66:	48 89 f1             	mov    rcx,rsi
   181824b69:	ff 50 08             	call   QWORD PTR [rax+0x8]
   181824b6c:	48 8b 45 d0          	mov    rax,QWORD PTR [rbp-0x30]
   181824b70:	48 83 f8 10          	cmp    rax,0x10
   181824b74:	72 35                	jb     0x181824bab
   181824b76:	48 8b 4d b8          	mov    rcx,QWORD PTR [rbp-0x48]
   181824b7a:	48 8d 50 01          	lea    rdx,[rax+0x1]
   181824b7e:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   181824b85:	72 1f                	jb     0x181824ba6
   181824b87:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   181824b8b:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   181824b8f:	4c 29 c1             	sub    rcx,r8
   181824b92:	48 83 f9 20          	cmp    rcx,0x20
   181824b96:	0f 83 55 02 00 00    	jae    0x181824df1
   181824b9c:	48 83 c0 28          	add    rax,0x28
   181824ba0:	48 89 c2             	mov    rdx,rax
   181824ba3:	4c 89 c1             	mov    rcx,r8
   181824ba6:	e8 35 6d c8 05       	call   0x1874ab8e0
   181824bab:	48 8b 75 30          	mov    rsi,QWORD PTR [rbp+0x30]
   181824baf:	48 85 f6             	test   rsi,rsi
   181824bb2:	74 1d                	je     0x181824bd1
   181824bb4:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   181824bb8:	75 17                	jne    0x181824bd1
   181824bba:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   181824bbd:	48 89 f1             	mov    rcx,rsi
   181824bc0:	ff 10                	call   QWORD PTR [rax]
   181824bc2:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   181824bc6:	75 09                	jne    0x181824bd1
   181824bc8:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   181824bcb:	48 89 f1             	mov    rcx,rsi
   181824bce:	ff 50 08             	call   QWORD PTR [rax+0x8]
   181824bd1:	48 8b 75 40          	mov    rsi,QWORD PTR [rbp+0x40]
   181824bd5:	48 85 f6             	test   rsi,rsi
   181824bd8:	74 1d                	je     0x181824bf7
   181824bda:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   181824bde:	75 17                	jne    0x181824bf7
   181824be0:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   181824be3:	48 89 f1             	mov    rcx,rsi
   181824be6:	ff 10                	call   QWORD PTR [rax]
   181824be8:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   181824bec:	75 09                	jne    0x181824bf7
   181824bee:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   181824bf1:	48 89 f1             	mov    rcx,rsi
   181824bf4:	ff 50 08             	call   QWORD PTR [rax+0x8]
   181824bf7:	48 8b 75 50          	mov    rsi,QWORD PTR [rbp+0x50]
   181824bfb:	48 85 f6             	test   rsi,rsi
   181824bfe:	74 1d                	je     0x181824c1d
   181824c00:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   181824c04:	75 17                	jne    0x181824c1d
   181824c06:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   181824c09:	48 89 f1             	mov    rcx,rsi
   181824c0c:	ff 10                	call   QWORD PTR [rax]
   181824c0e:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   181824c12:	75 09                	jne    0x181824c1d
   181824c14:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   181824c17:	48 89 f1             	mov    rcx,rsi
   181824c1a:	ff 50 08             	call   QWORD PTR [rax+0x8]
   181824c1d:	48 8b b5 f8 00 00 00 	mov    rsi,QWORD PTR [rbp+0xf8]
   181824c24:	48 85 f6             	test   rsi,rsi
   181824c27:	74 1d                	je     0x181824c46
   181824c29:	f0 ff 4e 08          	lock dec DWORD PTR [rsi+0x8]
   181824c2d:	75 17                	jne    0x181824c46
   181824c2f:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   181824c32:	48 89 f1             	mov    rcx,rsi
   181824c35:	ff 10                	call   QWORD PTR [rax]
   181824c37:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   181824c3b:	75 09                	jne    0x181824c46
   181824c3d:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   181824c40:	48 89 f1             	mov    rcx,rsi
   181824c43:	ff 50 08             	call   QWORD PTR [rax+0x8]
   181824c46:	48 8b 85 48 01 00 00 	mov    rax,QWORD PTR [rbp+0x148]
   181824c4d:	48 83 f8 10          	cmp    rax,0x10
   181824c51:	72 38                	jb     0x181824c8b
   181824c53:	48 8b 8d 30 01 00 00 	mov    rcx,QWORD PTR [rbp+0x130]
   181824c5a:	48 8d 50 01          	lea    rdx,[rax+0x1]
   181824c5e:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   181824c65:	72 1f                	jb     0x181824c86
   181824c67:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   181824c6b:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   181824c6f:	4c 29 c1             	sub    rcx,r8
   181824c72:	48 83 f9 20          	cmp    rcx,0x20
   181824c76:	0f 83 75 01 00 00    	jae    0x181824df1
   181824c7c:	48 83 c0 28          	add    rax,0x28
   181824c80:	48 89 c2             	mov    rdx,rax
   181824c83:	4c 89 c1             	mov    rcx,r8
   181824c86:	e8 55 6c c8 05       	call   0x1874ab8e0
   181824c8b:	48 8b 8d 98 00 00 00 	mov    rcx,QWORD PTR [rbp+0x98]
   181824c92:	48 85 c9             	test   rcx,rcx
   181824c95:	74 34                	je     0x181824ccb
   181824c97:	48 8b 95 a8 00 00 00 	mov    rdx,QWORD PTR [rbp+0xa8]
   181824c9e:	48 29 ca             	sub    rdx,rcx
   181824ca1:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   181824ca8:	72 1c                	jb     0x181824cc6
   181824caa:	48 8b 41 f8          	mov    rax,QWORD PTR [rcx-0x8]
   181824cae:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   181824cb2:	48 29 c1             	sub    rcx,rax
   181824cb5:	48 83 f9 20          	cmp    rcx,0x20
   181824cb9:	0f 83 32 01 00 00    	jae    0x181824df1
   181824cbf:	48 83 c2 27          	add    rdx,0x27
   181824cc3:	48 89 c1             	mov    rcx,rax
   181824cc6:	e8 15 6c c8 05       	call   0x1874ab8e0
   181824ccb:	48 8b 85 88 00 00 00 	mov    rax,QWORD PTR [rbp+0x88]
   181824cd2:	48 8b 48 08          	mov    rcx,QWORD PTR [rax+0x8]
   181824cd6:	48 c7 01 00 00 00 00 	mov    QWORD PTR [rcx],0x0
   181824cdd:	48 8b 10             	mov    rdx,QWORD PTR [rax]
   181824ce0:	48 85 d2             	test   rdx,rdx
   181824ce3:	74 1e                	je     0x181824d03
   181824ce5:	66 66 2e 0f 1f 84 00 	data16 cs nop WORD PTR [rax+rax*1+0x0]
   181824cec:	00 00 00 00 
   181824cf0:	48 8b 32             	mov    rsi,QWORD PTR [rdx]
   181824cf3:	48 89 d9             	mov    rcx,rbx
   181824cf6:	e8 25 e8 88 fe       	call   0x1800b3520
   181824cfb:	48 89 f2             	mov    rdx,rsi
   181824cfe:	48 85 f6             	test   rsi,rsi
   181824d01:	75 ed                	jne    0x181824cf0
   181824d03:	48 8b 8d 88 00 00 00 	mov    rcx,QWORD PTR [rbp+0x88]
   181824d0a:	ba 50 00 00 00       	mov    edx,0x50
   181824d0f:	e8 cc 6b c8 05       	call   0x1874ab8e0
   181824d14:	48 8d 4d e8          	lea    rcx,[rbp-0x18]
   181824d18:	e8 c3 a1 7e fe       	call   0x18000eee0
   181824d1d:	48 8b b5 d0 00 00 00 	mov    rsi,QWORD PTR [rbp+0xd0]
   181824d24:	48 85 f6             	test   rsi,rsi
   181824d27:	0f 84 a2 00 00 00    	je     0x181824dcf
   181824d2d:	48 8b bd d8 00 00 00 	mov    rdi,QWORD PTR [rbp+0xd8]
   181824d34:	48 39 fe             	cmp    rsi,rdi
   181824d37:	75 25                	jne    0x181824d5e
   181824d39:	48 8b 95 e0 00 00 00 	mov    rdx,QWORD PTR [rbp+0xe0]
   181824d40:	48 29 f2             	sub    rdx,rsi
   181824d43:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   181824d4a:	73 63                	jae    0x181824daf
   181824d4c:	eb 79                	jmp    0x181824dc7
   181824d4e:	66 90                	xchg   ax,ax
   181824d50:	e8 8b 6b c8 05       	call   0x1874ab8e0
   181824d55:	48 83 c6 20          	add    rsi,0x20
   181824d59:	48 39 fe             	cmp    rsi,rdi
   181824d5c:	74 37                	je     0x181824d95
   181824d5e:	48 8b 46 18          	mov    rax,QWORD PTR [rsi+0x18]
   181824d62:	48 83 f8 10          	cmp    rax,0x10
   181824d66:	72 ed                	jb     0x181824d55
   181824d68:	48 8b 0e             	mov    rcx,QWORD PTR [rsi]
   181824d6b:	48 8d 50 01          	lea    rdx,[rax+0x1]
   181824d6f:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   181824d76:	72 d8                	jb     0x181824d50
   181824d78:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   181824d7c:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   181824d80:	4c 29 c1             	sub    rcx,r8
   181824d83:	48 83 f9 20          	cmp    rcx,0x20
   181824d87:	73 68                	jae    0x181824df1
   181824d89:	48 83 c0 28          	add    rax,0x28
   181824d8d:	48 89 c2             	mov    rdx,rax
   181824d90:	4c 89 c1             	mov    rcx,r8
   181824d93:	eb bb                	jmp    0x181824d50
   181824d95:	48 8b b5 d0 00 00 00 	mov    rsi,QWORD PTR [rbp+0xd0]
   181824d9c:	48 8b 95 e0 00 00 00 	mov    rdx,QWORD PTR [rbp+0xe0]
   181824da3:	48 29 f2             	sub    rdx,rsi
   181824da6:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   181824dad:	72 18                	jb     0x181824dc7
   181824daf:	48 8b 46 f8          	mov    rax,QWORD PTR [rsi-0x8]
   181824db3:	48 83 c6 f8          	add    rsi,0xfffffffffffffff8
   181824db7:	48 29 c6             	sub    rsi,rax
   181824dba:	48 83 fe 20          	cmp    rsi,0x20
   181824dbe:	73 31                	jae    0x181824df1
   181824dc0:	48 83 c2 27          	add    rdx,0x27
   181824dc4:	48 89 c6             	mov    rsi,rax
   181824dc7:	48 89 f1             	mov    rcx,rsi
   181824dca:	e8 11 6b c8 05       	call   0x1874ab8e0
   181824dcf:	0f 28 b5 60 01 00 00 	movaps xmm6,XMMWORD PTR [rbp+0x160]
   181824dd6:	0f 28 bd 70 01 00 00 	movaps xmm7,XMMWORD PTR [rbp+0x170]
   181824ddd:	48 81 c4 08 02 00 00 	add    rsp,0x208
   181824de4:	5b                   	pop    rbx
   181824de5:	5f                   	pop    rdi
   181824de6:	5e                   	pop    rsi
   181824de7:	41 5c                	pop    r12
   181824de9:	41 5d                	pop    r13
   181824deb:	41 5e                	pop    r14
   181824ded:	41 5f                	pop    r15
   181824def:	5d                   	pop    rbp
   181824df0:	c3                   	ret
   181824df1:	e8 96 85 ce 05       	call   0x18750d38c
   181824df6:	90                   	nop
   181824df7:	e8 94 3d 7e fe       	call   0x180008b90
   181824dfc:	90                   	nop
   181824dfd:	e8 2e 69 7e fe       	call   0x18000b730
   181824e02:	90                   	nop
   181824e03:	cc                   	int3
