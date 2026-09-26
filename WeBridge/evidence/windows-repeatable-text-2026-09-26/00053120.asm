
D:\Program Files\Tencent\Weixin\4.1.15.13\Weixin.dll:     file format pei-x86-64


Disassembly of section .text:

0000000180053120 <.text+0x52120>:
   180053120:	56                   	push   rsi
   180053121:	48 83 ec 20          	sub    rsp,0x20
   180053125:	48 85 c9             	test   rcx,rcx
   180053128:	74 23                	je     0x18005314d
   18005312a:	f0 ff 49 08          	lock dec DWORD PTR [rcx+0x8]
   18005312e:	75 1d                	jne    0x18005314d
   180053130:	48 8b 01             	mov    rax,QWORD PTR [rcx]
   180053133:	48 89 ce             	mov    rsi,rcx
   180053136:	ff 10                	call   QWORD PTR [rax]
   180053138:	f0 ff 4e 0c          	lock dec DWORD PTR [rsi+0xc]
   18005313c:	75 0f                	jne    0x18005314d
   18005313e:	48 8b 06             	mov    rax,QWORD PTR [rsi]
   180053141:	48 89 f1             	mov    rcx,rsi
   180053144:	48 83 c4 20          	add    rsp,0x20
   180053148:	5e                   	pop    rsi
   180053149:	48 ff 60 08          	rex.W jmp QWORD PTR [rax+0x8]
   18005314d:	48 83 c4 20          	add    rsp,0x20
   180053151:	5e                   	pop    rsi
   180053152:	c3                   	ret
