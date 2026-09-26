
.research\wechat-4.1.10.27-reference\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

00000001836d3060 <.text+0x36d2060>:
   1836d3060:	55                   	push   rbp
   1836d3061:	41 57                	push   r15
   1836d3063:	41 56                	push   r14
   1836d3065:	41 54                	push   r12
   1836d3067:	56                   	push   rsi
   1836d3068:	57                   	push   rdi
   1836d3069:	53                   	push   rbx
   1836d306a:	48 83 ec 70          	sub    rsp,0x70
   1836d306e:	48 8d 6c 24 70       	lea    rbp,[rsp+0x70]
   1836d3073:	48 c7 45 f8 fe ff ff 	mov    QWORD PTR [rbp-0x8],0xfffffffffffffffe
   1836d307a:	ff 
   1836d307b:	4c 89 cf             	mov    rdi,r9
   1836d307e:	4c 89 c3             	mov    rbx,r8
   1836d3081:	49 89 d6             	mov    r14,rdx
   1836d3084:	48 89 ce             	mov    rsi,rcx
   1836d3087:	48 b8 aa aa aa aa aa 	movabs rax,0xaaaaaaaaaaaaaaaa
   1836d308e:	aa aa aa 
   1836d3091:	48 89 45 e8          	mov    QWORD PTR [rbp-0x18],rax
   1836d3095:	0f 28 05 64 92 1e 05 	movaps xmm0,XMMWORD PTR [rip+0x51e9264]        # 0x1888bc300
   1836d309c:	0f 29 45 b0          	movaps XMMWORD PTR [rbp-0x50],xmm0
   1836d30a0:	c7 45 c0 0a 02 00 00 	mov    DWORD PTR [rbp-0x40],0x20a
   1836d30a7:	0f 57 c0             	xorps  xmm0,xmm0
   1836d30aa:	0f 11 45 c4          	movups XMMWORD PTR [rbp-0x3c],xmm0
   1836d30ae:	c7 45 d4 00 00 00 00 	mov    DWORD PTR [rbp-0x2c],0x0
   1836d30b5:	b9 30 00 00 00       	mov    ecx,0x30
   1836d30ba:	e8 3d a0 13 03       	call   0x18680d0fc
   1836d30bf:	90                   	nop
   1836d30c0:	48 89 45 c8          	mov    QWORD PTR [rbp-0x38],rax
   1836d30c4:	48 c7 45 d8 20 00 00 	mov    QWORD PTR [rbp-0x28],0x20
   1836d30cb:	00 
   1836d30cc:	48 c7 45 e0 2f 00 00 	mov    QWORD PTR [rbp-0x20],0x2f
   1836d30d3:	00 
   1836d30d4:	0f 10 05 51 98 1e 05 	movups xmm0,XMMWORD PTR [rip+0x51e9851]        # 0x1888bc92c
   1836d30db:	0f 11 40 10          	movups XMMWORD PTR [rax+0x10],xmm0
   1836d30df:	0f 10 05 36 98 1e 05 	movups xmm0,XMMWORD PTR [rip+0x51e9836]        # 0x1888bc91c
   1836d30e6:	0f 11 00             	movups XMMWORD PTR [rax],xmm0
   1836d30e9:	c6 40 20 00          	mov    BYTE PTR [rax+0x20],0x0
   1836d30ed:	c6 45 e8 01          	mov    BYTE PTR [rbp-0x18],0x1
   1836d30f1:	4c 8b 7f 18          	mov    r15,QWORD PTR [rdi+0x18]
   1836d30f5:	4d 85 ff             	test   r15,r15
   1836d30f8:	74 43                	je     0x1836d313d
   1836d30fa:	48 8d 4d c8          	lea    rcx,[rbp-0x38]
   1836d30fe:	4c 8d 4f 08          	lea    r9,[rdi+0x8]
   1836d3102:	4c 39 c9             	cmp    rcx,r9
   1836d3105:	74 36                	je     0x1836d313d
   1836d3107:	48 83 7f 20 10       	cmp    QWORD PTR [rdi+0x20],0x10
   1836d310c:	72 04                	jb     0x1836d3112
   1836d310e:	4c 8b 4f 08          	mov    r9,QWORD PTR [rdi+0x8]
   1836d3112:	49 83 ff 2f          	cmp    r15,0x2f
   1836d3116:	76 0b                	jbe    0x1836d3123
   1836d3118:	4c 89 fa             	mov    rdx,r15
   1836d311b:	e8 50 13 98 fc       	call   0x180054470
   1836d3120:	90                   	nop
   1836d3121:	eb 1a                	jmp    0x1836d313d
   1836d3123:	4c 89 7d d8          	mov    QWORD PTR [rbp-0x28],r15
   1836d3127:	48 89 c1             	mov    rcx,rax
   1836d312a:	4c 89 ca             	mov    rdx,r9
   1836d312d:	4d 89 f8             	mov    r8,r15
   1836d3130:	49 89 c4             	mov    r12,rax
   1836d3133:	e8 98 2f 1c 03       	call   0x1868960d0
   1836d3138:	43 c6 04 3c 00       	mov    BYTE PTR [r12+r15*1],0x0
   1836d313d:	b9 58 01 00 00       	mov    ecx,0x158
   1836d3142:	e8 b5 9f 13 03       	call   0x18680d0fc
   1836d3147:	90                   	nop
   1836d3148:	48 8d 55 b0          	lea    rdx,[rbp-0x50]
   1836d314c:	48 89 c1             	mov    rcx,rax
   1836d314f:	48 89 45 f0          	mov    QWORD PTR [rbp-0x10],rax
   1836d3153:	e8 48 02 00 00       	call   0x1836d33a0
   1836d3158:	90                   	nop
   1836d3159:	4c 8b 65 f0          	mov    r12,QWORD PTR [rbp-0x10]
   1836d315d:	49 8b 04 24          	mov    rax,QWORD PTR [r12]
   1836d3161:	4c 89 e1             	mov    rcx,r12
   1836d3164:	ff 50 18             	call   QWORD PTR [rax+0x18]
   1836d3167:	90                   	nop
   1836d3168:	48 89 c1             	mov    rcx,rax
   1836d316b:	4c 89 f2             	mov    rdx,r14
   1836d316e:	e8 bd a0 59 ff       	call   0x182c6d230
   1836d3173:	90                   	nop
   1836d3174:	4d 8d b4 24 98 00 00 	lea    r14,[r12+0x98]
   1836d317b:	00 
   1836d317c:	4c 8b 7d 60          	mov    r15,QWORD PTR [rbp+0x60]
   1836d3180:	4d 39 fe             	cmp    r14,r15
   1836d3183:	74 6b                	je     0x1836d31f0
   1836d3185:	49 8b 8c 24 d0 00 00 	mov    rcx,QWORD PTR [r12+0xd0]
   1836d318c:	00 
   1836d318d:	48 85 c9             	test   rcx,rcx
   1836d3190:	74 18                	je     0x1836d31aa
   1836d3192:	4c 39 f1             	cmp    rcx,r14
   1836d3195:	0f 95 c2             	setne  dl
   1836d3198:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   1836d319b:	ff 50 20             	call   QWORD PTR [rax+0x20]
   1836d319e:	49 c7 84 24 d0 00 00 	mov    QWORD PTR [r12+0xd0],0x0
   1836d31a5:	00 00 00 00 00 
   1836d31aa:	49 8b 4f 38          	mov    rcx,QWORD PTR [r15+0x38]
   1836d31ae:	48 85 c9             	test   rcx,rcx
   1836d31b1:	74 3d                	je     0x1836d31f0
   1836d31b3:	4c 39 f9             	cmp    rcx,r15
   1836d31b6:	74 0a                	je     0x1836d31c2
   1836d31b8:	49 89 8c 24 d0 00 00 	mov    QWORD PTR [r12+0xd0],rcx
   1836d31bf:	00 
   1836d31c0:	eb 26                	jmp    0x1836d31e8
   1836d31c2:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   1836d31c5:	4c 89 f2             	mov    rdx,r14
   1836d31c8:	ff 50 08             	call   QWORD PTR [rax+0x8]
   1836d31cb:	49 89 84 24 d0 00 00 	mov    QWORD PTR [r12+0xd0],rax
   1836d31d2:	00 
   1836d31d3:	49 8b 4f 38          	mov    rcx,QWORD PTR [r15+0x38]
   1836d31d7:	48 85 c9             	test   rcx,rcx
   1836d31da:	74 14                	je     0x1836d31f0
   1836d31dc:	4c 39 f9             	cmp    rcx,r15
   1836d31df:	0f 95 c2             	setne  dl
   1836d31e2:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   1836d31e5:	ff 50 20             	call   QWORD PTR [rax+0x20]
   1836d31e8:	49 c7 47 38 00 00 00 	mov    QWORD PTR [r15+0x38],0x0
   1836d31ef:	00 
   1836d31f0:	4d 8d 74 24 58       	lea    r14,[r12+0x58]
   1836d31f5:	49 39 de             	cmp    r14,rbx
   1836d31f8:	74 4a                	je     0x1836d3244
   1836d31fa:	4c 8b 7b 10          	mov    r15,QWORD PTR [rbx+0x10]
   1836d31fe:	48 83 7b 18 10       	cmp    QWORD PTR [rbx+0x18],0x10
   1836d3203:	72 03                	jb     0x1836d3208
   1836d3205:	48 8b 1b             	mov    rbx,QWORD PTR [rbx]
   1836d3208:	49 8b 44 24 70       	mov    rax,QWORD PTR [r12+0x70]
   1836d320d:	49 39 c7             	cmp    r15,rax
   1836d3210:	76 11                	jbe    0x1836d3223
   1836d3212:	4c 89 f1             	mov    rcx,r14
   1836d3215:	4c 89 fa             	mov    rdx,r15
   1836d3218:	49 89 d9             	mov    r9,rbx
   1836d321b:	e8 50 12 98 fc       	call   0x180054470
   1836d3220:	90                   	nop
   1836d3221:	eb 21                	jmp    0x1836d3244
   1836d3223:	48 83 f8 10          	cmp    rax,0x10
   1836d3227:	72 03                	jb     0x1836d322c
   1836d3229:	4d 8b 36             	mov    r14,QWORD PTR [r14]
   1836d322c:	4d 89 7c 24 68       	mov    QWORD PTR [r12+0x68],r15
   1836d3231:	4c 89 f1             	mov    rcx,r14
   1836d3234:	48 89 da             	mov    rdx,rbx
   1836d3237:	4d 89 f8             	mov    r8,r15
   1836d323a:	e8 91 2e 1c 03       	call   0x1868960d0
   1836d323f:	43 c6 04 3e 00       	mov    BYTE PTR [r14+r15*1],0x0
   1836d3244:	0f b6 47 28          	movzx  eax,BYTE PTR [rdi+0x28]
   1836d3248:	41 88 84 24 e8 00 00 	mov    BYTE PTR [r12+0xe8],al
   1836d324f:	00 
   1836d3250:	8b 47 2c             	mov    eax,DWORD PTR [rdi+0x2c]
   1836d3253:	41 89 84 24 ec 00 00 	mov    DWORD PTR [r12+0xec],eax
   1836d325a:	00 
   1836d325b:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   1836d325e:	48 89 f1             	mov    rcx,rsi
   1836d3261:	4c 89 e2             	mov    rdx,r12
   1836d3264:	ff 50 28             	call   QWORD PTR [rax+0x28]
   1836d3267:	90                   	nop
   1836d3268:	e8 d3 17 f0 fc       	call   0x1805d4a40
   1836d326d:	90                   	nop
   1836d326e:	4c 89 e2             	mov    rdx,r12
   1836d3271:	48 83 c2 18          	add    rdx,0x18
   1836d3275:	48 89 c1             	mov    rcx,rax
   1836d3278:	e8 83 1b f0 fc       	call   0x1805d4e00
   1836d327d:	90                   	nop
   1836d327e:	41 8b 74 24 08       	mov    esi,DWORD PTR [r12+0x8]
   1836d3283:	48 8b 45 e0          	mov    rax,QWORD PTR [rbp-0x20]
   1836d3287:	48 83 f8 10          	cmp    rax,0x10
   1836d328b:	48 8b 7d 60          	mov    rdi,QWORD PTR [rbp+0x60]
   1836d328f:	72 31                	jb     0x1836d32c2
   1836d3291:	48 8b 4d c8          	mov    rcx,QWORD PTR [rbp-0x38]
   1836d3295:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1836d3299:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1836d32a0:	72 1b                	jb     0x1836d32bd
   1836d32a2:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1836d32a6:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1836d32aa:	4c 29 c1             	sub    rcx,r8
   1836d32ad:	48 83 f9 20          	cmp    rcx,0x20
   1836d32b1:	73 35                	jae    0x1836d32e8
   1836d32b3:	48 83 c0 28          	add    rax,0x28
   1836d32b7:	48 89 c2             	mov    rdx,rax
   1836d32ba:	4c 89 c1             	mov    rcx,r8
   1836d32bd:	e8 7e 9e 13 03       	call   0x18680d140
   1836d32c2:	48 8b 4f 38          	mov    rcx,QWORD PTR [rdi+0x38]
   1836d32c6:	48 85 c9             	test   rcx,rcx
   1836d32c9:	74 0c                	je     0x1836d32d7
   1836d32cb:	48 39 f9             	cmp    rcx,rdi
   1836d32ce:	0f 95 c2             	setne  dl
   1836d32d1:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   1836d32d4:	ff 50 20             	call   QWORD PTR [rax+0x20]
   1836d32d7:	89 f0                	mov    eax,esi
   1836d32d9:	48 83 c4 70          	add    rsp,0x70
   1836d32dd:	5b                   	pop    rbx
   1836d32de:	5f                   	pop    rdi
   1836d32df:	5e                   	pop    rsi
   1836d32e0:	41 5c                	pop    r12
   1836d32e2:	41 5e                	pop    r14
   1836d32e4:	41 5f                	pop    r15
   1836d32e6:	5d                   	pop    rbp
   1836d32e7:	c3                   	ret
   1836d32e8:	e8 8b d1 18 03       	call   0x186860478
   1836d32ed:	cc                   	int3
