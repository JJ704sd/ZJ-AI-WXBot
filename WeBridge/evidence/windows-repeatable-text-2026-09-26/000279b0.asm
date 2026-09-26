
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

00000001800279b0 <.text+0x269b0>:
   1800279b0:	56                   	push   rsi
   1800279b1:	48 83 ec 20          	sub    rsp,0x20
   1800279b5:	48 8b 02             	mov    rax,QWORD PTR [rdx]
   1800279b8:	4c 8d 05 91 41 01 0b 	lea    r8,[rip+0xb014191]        # 0x18b03bb50
   1800279bf:	4c 39 c0             	cmp    rax,r8
   1800279c2:	74 1e                	je     0x1800279e2
   1800279c4:	48 8b 50 10          	mov    rdx,QWORD PTR [rax+0x10]
   1800279c8:	48 01 c2             	add    rdx,rax
   1800279cb:	74 15                	je     0x1800279e2
   1800279cd:	44 8b 40 04          	mov    r8d,DWORD PTR [rax+0x4]
   1800279d1:	48 89 ce             	mov    rsi,rcx
   1800279d4:	e8 57 c9 29 00       	call   0x1802c4330
   1800279d9:	48 89 f0             	mov    rax,rsi
   1800279dc:	48 83 c4 20          	add    rsp,0x20
   1800279e0:	5e                   	pop    rsi
   1800279e1:	c3                   	ret
   1800279e2:	4c 89 01             	mov    QWORD PTR [rcx],r8
   1800279e5:	48 89 c8             	mov    rax,rcx
   1800279e8:	48 83 c4 20          	add    rsp,0x20
   1800279ec:	5e                   	pop    rsi
   1800279ed:	c3                   	ret
