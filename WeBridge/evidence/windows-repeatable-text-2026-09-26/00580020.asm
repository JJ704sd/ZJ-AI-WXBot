
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000180580020 <.text+0x57f020>:
   180580020:	55                   	push   rbp
   180580021:	56                   	push   rsi
   180580022:	48 83 ec 68          	sub    rsp,0x68
   180580026:	48 8d 6c 24 60       	lea    rbp,[rsp+0x60]
   18058002b:	48 c7 45 00 fe ff ff 	mov    QWORD PTR [rbp+0x0],0xfffffffffffffffe
   180580032:	ff 
   180580033:	4c 8b 02             	mov    r8,QWORD PTR [rdx]
   180580036:	48 8b 42 08          	mov    rax,QWORD PTR [rdx+0x8]
   18058003a:	0f 57 c0             	xorps  xmm0,xmm0
   18058003d:	0f 11 01             	movups XMMWORD PTR [rcx],xmm0
   180580040:	48 c7 41 10 00 00 00 	mov    QWORD PTR [rcx+0x10],0x0
   180580047:	00 
   180580048:	48 89 4d f8          	mov    QWORD PTR [rbp-0x8],rcx
   18058004c:	48 c7 41 18 0f 00 00 	mov    QWORD PTR [rcx+0x18],0xf
   180580053:	00 
   180580054:	48 b9 ff ff ff ff ff 	movabs rcx,0xffffffffffff
   18058005b:	ff 00 00 
   18058005e:	48 21 c1             	and    rcx,rax
   180580061:	48 c1 e8 30          	shr    rax,0x30
   180580065:	25 ff 3f 00 00       	and    eax,0x3fff
   18058006a:	0d 00 80 00 00       	or     eax,0x8000
   18058006f:	44 89 c2             	mov    edx,r8d
   180580072:	81 e2 ff 0f 00 00    	and    edx,0xfff
   180580078:	81 ca 00 40 00 00    	or     edx,0x4000
   18058007e:	45 89 c1             	mov    r9d,r8d
   180580081:	41 c1 e9 10          	shr    r9d,0x10
   180580085:	49 c1 e8 20          	shr    r8,0x20
   180580089:	48 89 4c 24 30       	mov    QWORD PTR [rsp+0x30],rcx
   18058008e:	89 44 24 28          	mov    DWORD PTR [rsp+0x28],eax
   180580092:	89 54 24 20          	mov    DWORD PTR [rsp+0x20],edx
   180580096:	48 8d 15 3b 3c 8a 08 	lea    rdx,[rip+0x88a3c3b]        # 0x188e23cd8
   18058009d:	48 8d 75 d8          	lea    rsi,[rbp-0x28]
   1805800a1:	48 89 f1             	mov    rcx,rsi
   1805800a4:	e8 97 c3 ff ff       	call   0x18057c440
   1805800a9:	90                   	nop
   1805800aa:	48 8b 45 f8          	mov    rax,QWORD PTR [rbp-0x8]
   1805800ae:	48 39 f0             	cmp    rax,rsi
   1805800b1:	48 89 c6             	mov    rsi,rax
   1805800b4:	74 11                	je     0x1805800c7
   1805800b6:	0f 10 45 d8          	movups xmm0,XMMWORD PTR [rbp-0x28]
   1805800ba:	0f 10 4d e8          	movups xmm1,XMMWORD PTR [rbp-0x18]
   1805800be:	0f 11 4e 10          	movups XMMWORD PTR [rsi+0x10],xmm1
   1805800c2:	0f 11 06             	movups XMMWORD PTR [rsi],xmm0
   1805800c5:	eb 3b                	jmp    0x180580102
   1805800c7:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   1805800cb:	48 83 f8 10          	cmp    rax,0x10
   1805800cf:	72 31                	jb     0x180580102
   1805800d1:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   1805800d5:	48 8d 50 01          	lea    rdx,[rax+0x1]
   1805800d9:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   1805800e0:	72 1b                	jb     0x1805800fd
   1805800e2:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   1805800e6:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   1805800ea:	4c 29 c1             	sub    rcx,r8
   1805800ed:	48 83 f9 20          	cmp    rcx,0x20
   1805800f1:	73 19                	jae    0x18058010c
   1805800f3:	48 83 c0 28          	add    rax,0x28
   1805800f7:	48 89 c2             	mov    rdx,rax
   1805800fa:	4c 89 c1             	mov    rcx,r8
   1805800fd:	e8 de b7 f2 06       	call   0x1874ab8e0
   180580102:	48 89 f0             	mov    rax,rsi
   180580105:	48 83 c4 68          	add    rsp,0x68
   180580109:	5e                   	pop    rsi
   18058010a:	5d                   	pop    rbp
   18058010b:	c3                   	ret
   18058010c:	e8 7b d2 f8 06       	call   0x18750d38c
   180580111:	cc                   	int3
