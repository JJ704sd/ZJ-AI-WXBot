
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000184435fd0 <.text+0x4434fd0>:
   184435fd0:	55                   	push   rbp
   184435fd1:	56                   	push   rsi
   184435fd2:	57                   	push   rdi
   184435fd3:	48 83 ec 50          	sub    rsp,0x50
   184435fd7:	48 8d 6c 24 50       	lea    rbp,[rsp+0x50]
   184435fdc:	48 c7 45 f8 fe ff ff 	mov    QWORD PTR [rbp-0x8],0xfffffffffffffffe
   184435fe3:	ff 
   184435fe4:	48 89 ce             	mov    rsi,rcx
   184435fe7:	48 8d 7d d8          	lea    rdi,[rbp-0x28]
   184435feb:	48 89 f9             	mov    rcx,rdi
   184435fee:	e8 ed 08 dd fb       	call   0x1802068e0
   184435ff3:	48 8b 45 e8          	mov    rax,QWORD PTR [rbp-0x18]
   184435ff7:	48 8b 4d f0          	mov    rcx,QWORD PTR [rbp-0x10]
   184435ffb:	48 89 ca             	mov    rdx,rcx
   184435ffe:	48 29 c2             	sub    rdx,rax
   184436001:	48 83 fa 02          	cmp    rdx,0x2
   184436005:	73 24                	jae    0x18443602b
   184436007:	48 c7 44 24 20 02 00 	mov    QWORD PTR [rsp+0x20],0x2
   18443600e:	00 00 
   184436010:	4c 8d 0d 55 e2 20 05 	lea    r9,[rip+0x520e255]        # 0x18964426c
   184436017:	48 8d 4d d8          	lea    rcx,[rbp-0x28]
   18443601b:	ba 02 00 00 00       	mov    edx,0x2
   184436020:	e8 9b 33 bd fb       	call   0x1800093c0
   184436025:	90                   	nop
   184436026:	48 89 c7             	mov    rdi,rax
   184436029:	eb 20                	jmp    0x18443604b
   18443602b:	48 8d 50 02          	lea    rdx,[rax+0x2]
   18443602f:	48 89 55 e8          	mov    QWORD PTR [rbp-0x18],rdx
   184436033:	48 89 fa             	mov    rdx,rdi
   184436036:	48 83 f9 10          	cmp    rcx,0x10
   18443603a:	72 04                	jb     0x184436040
   18443603c:	48 8b 55 d8          	mov    rdx,QWORD PTR [rbp-0x28]
   184436040:	66 c7 04 02 5f 6d    	mov    WORD PTR [rdx+rax*1],0x6d5f
   184436046:	c6 44 02 02 00       	mov    BYTE PTR [rdx+rax*1+0x2],0x0
   18443604b:	0f 10 07             	movups xmm0,XMMWORD PTR [rdi]
   18443604e:	0f 10 4f 10          	movups xmm1,XMMWORD PTR [rdi+0x10]
   184436052:	0f 11 4e 10          	movups XMMWORD PTR [rsi+0x10],xmm1
   184436056:	0f 11 06             	movups XMMWORD PTR [rsi],xmm0
   184436059:	48 c7 47 10 00 00 00 	mov    QWORD PTR [rdi+0x10],0x0
   184436060:	00 
   184436061:	48 c7 47 18 0f 00 00 	mov    QWORD PTR [rdi+0x18],0xf
   184436068:	00 
   184436069:	c6 07 00             	mov    BYTE PTR [rdi],0x0
   18443606c:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
   184436070:	48 83 f8 10          	cmp    rax,0x10
   184436074:	72 31                	jb     0x1844360a7
   184436076:	48 8b 4d d8          	mov    rcx,QWORD PTR [rbp-0x28]
   18443607a:	48 8d 50 01          	lea    rdx,[rax+0x1]
   18443607e:	48 81 fa 00 10 00 00 	cmp    rdx,0x1000
   184436085:	72 1b                	jb     0x1844360a2
   184436087:	4c 8b 41 f8          	mov    r8,QWORD PTR [rcx-0x8]
   18443608b:	48 83 c1 f8          	add    rcx,0xfffffffffffffff8
   18443608f:	4c 29 c1             	sub    rcx,r8
   184436092:	48 83 f9 20          	cmp    rcx,0x20
   184436096:	73 1a                	jae    0x1844360b2
   184436098:	48 83 c0 28          	add    rax,0x28
   18443609c:	48 89 c2             	mov    rdx,rax
   18443609f:	4c 89 c1             	mov    rcx,r8
   1844360a2:	e8 39 58 07 03       	call   0x1874ab8e0
   1844360a7:	48 89 f0             	mov    rax,rsi
   1844360aa:	48 83 c4 50          	add    rsp,0x50
   1844360ae:	5f                   	pop    rdi
   1844360af:	5e                   	pop    rsi
   1844360b0:	5d                   	pop    rbp
   1844360b1:	c3                   	ret
   1844360b2:	e8 d5 72 0d 03       	call   0x18750d38c
   1844360b7:	cc                   	int3
